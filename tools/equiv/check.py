#!/usr/bin/env python3
"""Functional-equivalence check (FUNCTIONAL_PLAN.md, "How the check works" 4-8, step 5).

  python3 tools/equiv/check.py src/<engine|front|pc>/<mod>/<F>.c --func F [--cases 2000] [--seed 1] [--quiet] [--seg SEG] [--ret64] [--callers|--no-callers] [--force] [--budget N]

Runs the original asm of F (in place in HOCKEY.EXE) and the compiled draft on the same seeded cases and compares
the traces from run.py. Verdicts: PASS, NEEDS-REVIEW (equal, but the original trapped or returned an unset
entry register), FAIL (first differing case printed; the run stops there). Rows go to tools/equiv/results.csv
for files under src/engine, src/front or src/pc; a repeat of the same function + source sha1 + cases that passed prints "cached PASS".
Compared per case: ret eax (edx with --ret64; ax only for the short-return allow-list), esi/edi/ebp always, ebx/ecx/edx when the original saves them
(push) or leaves them unchanged in that case, esp delta, writes (ordered; stack-region dests as STK offset from entry esp), calls (ordered; stack args cut to the
callee's `ret N`, register args cut to the registers the callee reads first, and only at a real function entry).
Case inputs: arg registers and stack args are edge values, small randoms or pointers into a 64 KB random arg
buffer at ARG (index-typed regs stay in [0, table-bound); deref regs and most stack args stay mapped in ARG). Odd
seeded cases are a typed stream (no EDGE / 0xa5a5a5a5; struct-shaped objects in ARG); even cases keep the random
corpus except leftover clamps (collide sort-index in {0..0xB, 0x10}; DrawListItems / ListDialog loop counts). Globals the function references (original and draft fixups) are patched with random, edge,
pointer-ish or static bytes; callee returns come from a seeded script. GetInputEvent / PollKey return a dummy event
for the first few hits then 0; ListHitTest returns an in-rect row; FileOpen* returns 0 (success). The stack below the entry esp is refilled per
case from the case seed (same bytes on both sides); an uninitialised stack read in a case that still compares equal is
info ("uninit read, outputs equal"), not review. MenuHitTest out-params are in-rect (hitMenu in [0, 4), hitItem in [0, 32)).
A stopping trap on a case that also hit null page does not count toward "mostly trapped".
Callers mode (--callers; also automatic when coverage after seeded + mutated cases is under 85%, off with --no-callers):
the original callers of F (direct `call rel32` sites in the image) run from seeded random states with every callee
stubbed except F; at F's entry the registers, stack args and every page written so far are snapshotted and become a
case State for both sides. One level up (callers of callers) is used when fewer than 50 snapshots come out.
"""
import os, sys, re, csv, random, hashlib, struct, time, argparse, datetime, collections, dataclasses
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, HERE); sys.path.insert(0, os.path.join(ROOT, 'tools')); import paths
import image, run, cside, capstone
from capstone.x86_const import X86_OP_MEM

ARG, ARG_SIZE = 0x6000000, 0x10000
DATA_LO = 0xC0000   # first data object (index test: [reg + global])
MAXI = 200000   # instruction cap per side; a hit is an 'insn limit' trap
RESULTS = os.path.join(HERE, 'results.csv')
HEAD = ['function', 'c_file', 'source_sha1', 'cases', 'seed', 'verdict', 'first_diff', 'date']
EDGE = [0, 1, 0xFFFFFFFF, 2, 7, 0x7F, 0x80, 0xFF, 0x7FFF, 0x8000, 0xFFFF, 0x7FFFFFFF, 0x80000000]
FAM = {'eax': 'eax ax ah al', 'ebx': 'ebx bx bh bl', 'ecx': 'ecx cx ch cl', 'edx': 'edx dx dh dl',
       'esi': 'esi si', 'edi': 'edi di', 'ebp': 'ebp bp'}
FAMOF = {n: r for r, ns in FAM.items() for n in ns.split()}
ARGREGS = ('eax', 'edx', 'ebx', 'ecx')
# Callers test ax (Abdul ESCALATE: do not change the C return type). Compare ret eax as uint16.
SHORT_AX = frozenset(('CanFillLineSlot', 'FillDressedSlots'))
INDEX_BOUND = 32  # default when the table length is unknown
EVENT_STUB = frozenset((
    'ListDialog', 'RunMenu', 'RunTeamPickMenu', 'RunPlayerPickMenu', 'SportsDesk',
    'GameLineEditorLoop', 'DbLineEditorLoop', 'PlayoffTreeMenu', 'LeagueTeamSelect',
    'TradeScreenLoop', 'InstantReplay', 'EditRosters', 'CalendarScreen', 'TitleScreen',
))
MENU_BARS = frozenset(('RunMenu', 'RunTeamPickMenu', 'RunPlayerPickMenu', 'PlayoffTreeMenu'))
_md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32); _md.detail = True

def table_bound(func):
    """[0, bound) for index-typed regs / stack slots. Nearest table length; 32 if unknown."""
    n = (func or '').lower()
    if any(s in n for s in ('puckcoll', 'passlane', 'checkcheck', 'checkgoal', 'wallcoll', 'blockshot', 'assone')):
        return 17  # SortCords 0-0Bh plus object 10h
    if any(s in n for s in ('playoff',)): return 16
    if any(s in n for s in ('menu', 'desk', 'pick')): return 8
    if any(s in n for s in ('team', 'roster', 'stand', 'division')): return 26
    if any(s in n for s in ('dressed', 'lineslot', 'line', 'skater', 'player', 'slot')): return 25
    return INDEX_BOUND

def collide_sort_index(v):
    """Player / puck sort-index in {0..0xB, 0x10} (checkpuckcoll_ccx early-out)."""
    x = v & 0xFFFF
    if x == 0x10 or x <= 0xB: return x
    return 0x10 if x & 1 else x % 12

def mostly_trapped(done, traps, n_null_stop=0):
    """True when more than half the cases had a stopping trap that was not a null-page continuation.
    Lazy page 0 is info (RULES 2026-11-02); insn-limit / no-return after it is the same artefact."""
    nt = sum(traps.values()) - n_null_stop
    return nt * 2 > done

def clamp_playoff_team_bytes(func, buf, args, regs=None):
    """Keep SimPlayoff/SeedPlayoff series team bytes in [0, 26) so wins[] cannot spill onto the frame.
    Watcom register args: sched is eax, then edx/ebx/ecx, then stack. Every ARG pointer is walked as 6-byte
    game slots (team bytes at +2/+3). No-op for other names."""
    if not any(tag in (func or '') for tag in ('SimPlayoff', 'SeedPlayoff')):
        return buf
    ptrs = []
    if args:
        ptrs.extend(args)
    if regs:
        ptrs.extend(regs.values())
    b = bytearray(buf)
    n = min(len(b), ARG_SIZE)
    seen = set()
    for p in ptrs:
        if not isinstance(p, int) or not (ARG <= p < ARG + ARG_SIZE):
            continue
        base = p - ARG
        if base in seen:
            continue
        seen.add(base)
        o = base
        while o + 4 <= n:
            for off in (o + 2, o + 3):
                if 0 <= off < n:
                    b[off] %= 26
            o += 6
    return bytes(b)

ON1_STUB = ARG + 0x1E0     # non-entry: both sides stub; 0-arg event_stub returns 1
SPRITE_OFF = 0x180
PTRFN_STUB = ARG + 0x1C0   # ptrupdatefn / mousepollfn: leave extent, click-bit 2

def plant_menus(buf, on1=ON1_STUB, y1=10, y2=26):
    """4 MenuItem slots at ARG+0x100: in-rect box, text in ARG, on1 a 0-arg stub target."""
    b = bytearray(buf)
    for k in range(4):
        base = 0x100 + k * 32
        if base + 32 > len(b):
            break
        b[base:base + 16] = struct.pack('<IIII', 10, y1, 50, y2)
        b[base + 16:base + 20] = struct.pack('<I', ARG)
        b[base + 20:base + 24] = struct.pack('<I', on1 & 0xFFFFFFFF)
        b[base + 24:base + 32] = bytes(8)
        b[k * 4:(k + 1) * 4] = struct.pack('<I', ARG + base)
    # item 1 is a submenu (on1 0, on2 the same 4 items) so RunMenu covers the on2 arm
    if len(b) >= 0x100 + 64:
        b[0x100 + 32 + 20:0x100 + 32 + 24] = struct.pack('<I', 0)
        b[0x100 + 32 + 24:0x100 + 32 + 32] = struct.pack('<II', ARG + 0x100, 4)
    return bytes(b)

def plant_screen(img, buf, patches, y1=10, y2=26):
    """Pointer sprite + fn-pointer globals so leftover screen loops don't null-page on pointerspr."""
    b = bytearray(plant_menus(buf, ON1_STUB, y1=y1, y2=y2))
    if len(b) >= SPRITE_OFF + 17:
        b[SPRITE_OFF:SPRITE_OFF + 17] = struct.pack('<HHHH', 0, 0, 8, 8) + bytes(9)
    for stub in (PTRFN_STUB, ON1_STUB):
        off = stub - ARG
        if 0 <= off < len(b):
            b[off] = 0xC3  # ret: pop-scan of the stub target is 0
    patches = dict(patches)
    lab = img.labels()
    spr = ARG + SPRITE_OFF
    for name, val in (('pointerspr', spr), ('ptrupdatefn', PTRFN_STUB), ('mousepollfn', PTRFN_STUB)):
        a = lab.get(name)
        if a:
            patches[a] = struct.pack('<I', val & 0xFFFFFFFF)
    return bytes(b), patches

def overlay_patch(patches, addr, data):
    """Write data at addr, overlaying an existing span patch that contains it."""
    data = bytes(data)
    for lo, b in list(patches.items()):
        if lo <= addr < lo + len(b):
            x = bytearray(b)
            off = addr - lo
            n = min(len(data), len(x) - off)
            x[off:off + n] = data[:n]
            patches[lo] = bytes(x)
            return
    patches[addr] = data

def patch_u32(img, patches, name, val):
    a = img.labels().get(name)
    if a:
        overlay_patch(patches, a, struct.pack('<I', val & 0xFFFFFFFF))

def patch_u16(img, patches, name, val):
    a = img.labels().get(name)
    if a:
        overlay_patch(patches, a, struct.pack('<H', val & 0xFFFF))

def patch_u8(img, patches, name, val):
    a = img.labels().get(name)
    if a:
        overlay_patch(patches, a, bytes([val & 0xFF]))

def plant_player_bytes(x=0x14, y=0xEA, z=2, sc=1, pos=1, pflags=0, nopuck=0, frame=0, xv=0, yv=0, zv=0, pflags2=0,
                       spa=0, facedir=0, puckdist=0, attribute=0, oldx=None, oldy=None, oldz=None,
                       weight=80, aggress=10, checking=10, impact=0, radiusx=8, radiusy=8, puckdir=0):
    """128-byte Player: HIWORD X/Y/Z in world units (structs.h). x/y may be negative."""
    p = bytearray(128)
    struct.pack_into('<I', p, 0x00, (x & 0xFFFF) << 16)   # Xpos
    struct.pack_into('<I', p, 0x04, (y & 0xFFFF) << 16)   # Ypos
    struct.pack_into('<I', p, 0x08, (z & 0xFFFF) << 16)   # Zpos
    struct.pack_into('<h', p, 0x0C, xv)
    struct.pack_into('<h', p, 0x0E, yv)
    struct.pack_into('<h', p, 0x10, zv)
    struct.pack_into('<h', p, 0x12, frame)
    struct.pack_into('<h', p, 0x18, impact)
    struct.pack_into('<h', p, 0x1A, pos)
    struct.pack_into('<h', p, 0x36, facedir)
    struct.pack_into('<h', p, 0x38, spa)
    p[0x3E:0x40] = struct.pack('<h', nopuck)
    p[0x44] = pflags & 0xFF
    p[0x45] = pflags2 & 0xFF
    p[0x52] = puckdir & 0xFF
    p[0x55] = attribute & 0xFF
    p[0x56] = weight & 0xFF
    p[0x62] = aggress & 0xFF
    p[0x64] = checking & 0xFF
    struct.pack_into('<h', p, 0x4E, puckdist)
    struct.pack_into('<h', p, 0x66, radiusx)
    struct.pack_into('<h', p, 0x68, radiusy)
    struct.pack_into('<h', p, 0x6A, sc)
    if oldx is None: oldx = x
    if oldy is None: oldy = y
    if oldz is None: oldz = z
    struct.pack_into('<I', p, 0x74, (oldx & 0xFFFF) << 16)
    struct.pack_into('<I', p, 0x78, (oldy & 0xFFFF) << 16)
    struct.pack_into('<I', p, 0x7C, (oldz & 0xFFFF) << 16)
    return bytes(p)

def plant_leftover(func, img, buf, patches, seed=0):
    """Deeper H3 plants for leftover NR only: skate corridor, calendar games, collide SortCords, statsplayoffs."""
    n = func or ''
    low = n.lower()
    b = bytearray(buf)
    patches = dict(patches)
    # Player at ARG+0x400 for skate / collide (eax)
    if 'skate' in low:
        kind = seed % 8
        xv = yv = 0
        if kind == 0:   # boards corridor (0xE0 < |y_target| < 0xE8)
            x, y, r0, r1 = 0x14, 0xEA, 0x08, 0xE4
        elif kind == 1: # goal-line (|y| >= 0xF2)
            x, y, r0, r1 = 0x10, 0xF4, 0x14, 0xF0
        elif kind == 2: # within 8: early stop
            x, y, r0, r1 = 0x20, 0x20, 0x22, 0x22
        elif kind == 3: # far: speed / animation
            x, y, r0, r1 = 0x40, 0x40, 0x100, 0x80
        elif kind == 4: # negative world: ABS(Xpos)/ABS(Ypos) arms
            x, y, r0, r1 = -0x40, -0x20, -0x10, 0x10
        elif kind == 5: # target behind: dx/dy negative
            x, y, r0, r1 = 0x80, 0x80, 0x10, 0x10
        elif kind == 6: # |dx|,|dy| in 8..24 so damping runs; |vel| > 0x9C4
            x, y, r0, r1 = 0x20, 0x20, 0x30, 0x30
            xv, yv = -0xC00, -0xC00
        else:           # |X|<=30, |Y|>=0xF2, Ypos<0: boards path with cx<0 (4e414)
            x, y, r0, r1 = 0x10, -0xF4, 0x08, 0x20
        if 0x400 + 128 <= len(b):
            sc = 0x10 if kind in (3, 6) else 1
            pos = 0 if kind in (3, 6) else 1
            b[0x400:0x400 + 128] = plant_player_bytes(x=x, y=y, z=2, sc=sc, pos=pos, xv=xv, yv=yv)
        patch_u16(img, patches, 'regd0', r0 & 0xFFFF)
        patch_u16(img, patches, 'regd1', r1 & 0xFFFF)
    elif 'puckcoll' in low:
        puck = ARG + 0x400
        kind = seed % 4
        sc_pos = 0 if kind in (0, 1) else 1
        sc_frame = 0x431 if kind in (1, 3) else 0
        xv = -0x80 if kind & 1 else 0x40
        yv = -0x40 if kind & 2 else 0x20
        if 0x400 + 128 <= len(b):
            b[0x400:0x400 + 128] = plant_player_bytes(
                x=0x18, y=0x22, z=2, sc=1, pos=1, xv=xv, yv=yv, zv=0, frame=0)
        sc0 = img.labels().get('SortCords')
        if sc0:
            overlay_patch(patches, sc0, plant_player_bytes(
                x=0x20, y=0x20, z=2, sc=0, pos=sc_pos, nopuck=0, frame=sc_frame, xv=0, yv=0))
        patch_u32(img, patches, 'puckc', ARG + 0x5F0)
        if 0x5F0 < len(b):
            b[0x5F0] = 0x10
        patch_u32(img, patches, 'puckx', puck + 2)
        patch_u32(img, patches, 'pucky', puck + 6)
        patch_u32(img, patches, 'puckz', puck + 10)
        patch_u32(img, patches, 'puckvx', puck + 0x0C)
        patch_u32(img, patches, 'puckvy', puck + 0x0E)
        patch_u32(img, patches, 'puckvz', puck + 0x10)
    elif n == 'checkgoal':
        # ebx/ecx clamped to 0x20. Mix checkgoalp, z-bounce, Goal, post (.6), side wallcoll (.10).
        kind = seed % 8
        sc = 1 if kind == 0 else 0x0E
        gx = 0x08 if kind in (2, 3) else 0x20  # arg x - g.x = 24 → outer box, inner Goal fails
        oldy = 0x20 if kind == 2 else 0x10     # dy=0 → .10; else interpolation
        oldz = 0x10 if kind == 1 else 4
        z = 2 if kind != 5 else 0xD
        if 0x400 + 128 <= len(b):
            b[0x400:0x400 + 128] = plant_player_bytes(
                x=0x20, y=0x20, z=z, sc=sc, pos=1, xv=0x40, yv=0x80, zv=-0x80 if kind == 1 else 0x40,
                pflags=0x80 if kind == 6 else 0, oldx=0x10, oldy=oldy, oldz=oldz)
        if 0x480 + 128 <= len(b):
            b[0x480:0x480 + 128] = plant_player_bytes(x=gx, y=0x20, z=2, sc=0x0C, pos=0)
        patch_u16(img, patches, 'wcradiusx', 8)
        patch_u16(img, patches, 'wcradiusy', 8)
        patch_u32(img, patches, 'puckc', ARG + 0x5F0)
        if 0x5F4 <= len(b):
            b[0x5F0] = 0xFF if kind & 2 else 0
            b[0x5F2:0x5F4] = struct.pack('<h', 0x20)
        patch_u32(img, patches, 'pucky', ARG + 0x5F2)
        sc0 = img.labels().get('SortCords')
        if sc0:
            overlay_patch(patches, sc0, plant_player_bytes(
                x=0x18, y=0x20, z=2, sc=1, pos=1, pflags=0x80 if kind & 1 else 0))
    elif n == 'PassLaneChk':
        kind = seed % 4
        # |y| in (0x4E, 0x76] so the 4Eh-line and 76h cap both pass; teammate 0x20 shallower.
        if kind & 1:
            y0, oy, pfl, yv = 0x70, 0x50, 0x80, 0x200
        else:
            y0, oy, pfl, yv = -0x70, -0x50, 0, -0x200
        if 0x400 + 128 <= len(b):
            b[0x400:0x400 + 128] = plant_player_bytes(
                x=0x18, y=y0, z=2, sc=1, pos=1, xv=0x40, yv=yv, pflags=pfl, facedir=2)
        if 0x480 + 128 <= len(b):
            b[0x480:0x480 + 128] = plant_player_bytes(
                x=0x20, y=oy, z=2, sc=1, pos=1, xv=0x40, yv=yv, facedir=2)
    elif n == 'checkcheck':
        # Mostly the SPA 0x621 arm (holdcheck/Bcheck are other functions). q close, ref mix.
        spa_q = (0, 0, 0, 0, 0, 0x589, 0x639, 0x873)[seed % 8]
        qsc = 0x10 if seed & 2 else 1
        qpfl = 8 if seed & 1 else 0
        qx = -0x20 if seed & 8 else 0x20
        qv = 0x200 if seed & 16 else 0x80  # >= 0x1F4 takes the vtoa hit-SPA arm
        ppfl = 8 if qsc == 0x10 else (0x80 if seed & 1 else 0)
        if 0x400 + 128 <= len(b):
            b[0x400:0x400 + 128] = plant_player_bytes(
                x=0x18, y=0x20, z=2, sc=1, pos=1, xv=0x40, spa=0x621, facedir=2,
                attribute=0 if seed & 4 else 8, pflags=ppfl,
                aggress=20, checking=2, weight=80)
        if 0x480 + 128 <= len(b):
            b[0x480:0x480 + 128] = plant_player_bytes(
                x=qx, y=0x24, z=2, sc=qsc, pos=1, spa=spa_q,
                xv=qv, yv=qv, weight=100, impact=0x30, facedir=2, pflags=qpfl)
        patch_u8(img, patches, 'gmode', 0x10 if seed & 4 else (1 if seed & 1 else 0))
    elif n == 'CanBlockShot':
        kind = seed % 4
        side = kind & 1
        py, pky, pfl = (0xC0, 0x80, 8) if not side else (-0xC0, -0x80, 0x80 | 8)
        gy = 0xE0 if not side else -0xE0
        pvy = 0x100 if not side else -0x100  # toward that goal; opposite sign early-outs
        carrier = kind & 2
        if 0x400 + 128 <= len(b):
            b[0x400:0x400 + 128] = plant_player_bytes(
                x=0x20, y=py, z=2, sc=8, pos=1, pflags=pfl, puckdist=0x20,
                facedir=6, puckdir=6)
        patch_u32(img, patches, 'puckc', ARG + 0x5F0)
        if 0x5FA <= len(b):
            b[0x5F0] = 0 if carrier else 0xFF  # carrier (other team) vs loose shotplayer
            b[0x5F2:0x5F8] = struct.pack('<hhh', 0x20, pky, 4)
            b[0x5F8:0x5FA] = struct.pack('<h', pvy)
        patch_u32(img, patches, 'puckx', ARG + 0x5F2)
        patch_u32(img, patches, 'pucky', ARG + 0x5F4)
        patch_u32(img, patches, 'puckz', ARG + 0x5F6)
        patch_u32(img, patches, 'puckvy', ARG + 0x5F8)
        patch_u16(img, patches, 'shotplayer', 0)
        pc = img.labels().get('puckcross')
        if pc:
            overlay_patch(patches, pc, struct.pack('<hhhh', 20, 20, 20, 20))
        sc0 = img.labels().get('SortCords')
        if sc0:
            overlay_patch(patches, sc0, plant_player_bytes(x=0x20, y=pky, z=2, sc=0, pos=1, spa=0x3F9))
            overlay_patch(patches, sc0 + 12 * 128, plant_player_bytes(x=0x20, y=gy, z=2, sc=0x0C, pos=0))
            overlay_patch(patches, sc0 + 13 * 128, plant_player_bytes(x=0x20, y=gy, z=2, sc=0x0D, pos=0))
    elif n == 'wallcoll' or any(s in low for s in ('blockshot', 'assone', 'assgoal', 'assref', 'threestars')):
        if n == 'wallcoll':
            sc = 0x0E if seed & 1 else 1  # puck vs player bounce (player arm is 0x58a14+)
            xv, yv = 0, 0x2000
            px = 0x20 if seed & 4 else -0x20
            z = 0xC if seed & 4 else 2
        else:
            sc = 0x0E if seed & 1 else 1
            xv, yv, px, z = 0x40, 0x200, 0x20, 2
        if 0x400 + 128 <= len(b):
            b[0x400:0x400 + 128] = plant_player_bytes(
                x=px, y=0xC0, z=z, sc=sc, pos=1, xv=xv, yv=yv,
                pflags=0x80 if seed & 2 else 0, puckdist=0x20, spa=0x99,
                oldx=px, oldy=0xC0, impact=0x10)
        patch_u16(img, patches, 'regd0', 0x100)
        patch_u16(img, patches, 'regd1', 0x40)
        patch_u32(img, patches, 'puckc', ARG + 0x5F0)
        if 0x5F2 < len(b):
            b[0x5F0] = 0xFF if seed & 1 else 0x10
            b[0x5F2:0x5F4] = struct.pack('<h', 0xC0)
        patch_u32(img, patches, 'pucky', ARG + 0x5F2)
        patch_u32(img, patches, 'puckx', ARG + 0x5F4)
        patch_u32(img, patches, 'puckz', ARG + 0x5F6)
        if 0x5F8 <= len(b):
            b[0x5F4:0x5F8] = struct.pack('<hh', 0x20, 4)
        patch_u32(img, patches, 'dword_CCC2C', 1 if seed & 2 else 0)
    if n == 'assthreestars':
        # ovltimer -1 skips the early-out (<0x10 / 0x258..0x268).
        patch_u16(img, patches, 'ovltimer', 0xFFFF)
        kind = seed % 5
        pfl = 2 if kind == 0 else 0
        if kind == 2:
            t1, t2, t3 = -1, 0, -1          # gameover
        elif kind == 4:
            t1, t2, t3 = 0, 1, 5            # last star done: ovltimer = 0x258
        elif kind == 1:
            t1, t2, t3 = 2, 1, 5            # star done, announce next
        elif kind == 3:
            t1, t2, t3 = 2, 1, -1           # bring the star out (0x49907)
        else:
            t1, t2, t3 = 2, 1, -1           # intro (pflags=2)
        if 0x400 + 128 <= len(b):
            p = bytearray(b[0x400:0x400 + 128])
            p[0x44] = pfl
            struct.pack_into('<h', p, 0x26, t1)
            struct.pack_into('<h', p, 0x28, t2)
            struct.pack_into('<h', p, 0x2A, t3)
            b[0x400:0x400 + 128] = p
        sm = img.labels().get('startm')
        if sm:
            overlay_patch(patches, sm, b'\x00\x00' * 8)
        spl = img.labels().get('starpl')
        if spl:
            overlay_patch(patches, spl, b'\x00\x00' * 8)
        sc0 = img.labels().get('SortCords')
        if sc0:
            overlay_patch(patches, sc0 + 5 * 128, plant_player_bytes(
                x=0x10, y=0x40, z=2, sc=5, pos=4, frame=-1 if kind == 1 else 0,
                pflags=0x40 if seed & 1 else 0))
            overlay_patch(patches, sc0 + 6 * 128, plant_player_bytes(
                x=0x10, y=-0x40, z=2, sc=6, pos=4, pflags=0))
            if kind in (1, 4):
                q = bytearray(128)
                q[:] = plant_player_bytes(x=0x10, y=0x40, z=2, sc=5, pos=4, frame=-1)
                struct.pack_into('<h', q, 0x26, 0x64)  # q->temp1 == 0x64
                overlay_patch(patches, sc0 + 5 * 128, bytes(q))
        patch_u32(img, patches, 'gameopts', 0x100)  # speech bit
        patch_u32(img, patches, 'musicon', 1)
        so = img.labels().get('starordtab')
        if so:
            overlay_patch(patches, so, b'\x01\x00\x00\x00' * 4)
    if n == 'assrefgoalpa':
        kind = seed % 8
        # ovlseq must be neither 0 nor 2 for the PaGoal overlay body.
        patch_u16(img, patches, 'ovlseq', 1 if kind == 0 else 0)
        patch_u16(img, patches, 'ovltimer', 0xF0 if kind == 0 else (0x100 if kind == 3 else 0))
        e9 = img.labels().get('byte_E9AD3')
        if e9:
            overlay_patch(patches, e9, bytes([1 if kind == 0 else 0, 0, 1, 0xFF, 0xFF]))
        pb = img.labels().get('PenBuf')
        if pb:
            overlay_patch(patches, pb, bytes([2 if kind == 1 else 0, 0, 0, 0, 0, 0, 0, 0]))
        patch_u16(img, patches, 'RefPen', 4 if kind == 3 else (7 if kind == 4 else 1))
        patch_u16(img, patches, 'gsp', 3 if kind == 4 else (0 if kind == 3 else 1))
        patch_u16(img, patches, 'word_CBEC6', 1 if kind == 5 else 0)
        if kind == 2 and 0x5F8 <= len(b):
            b[0x5F2:0x5F4] = struct.pack('<h', 0x120)  # |pucky| > 0x112
        if kind == 6 and 0x5F8 <= len(b):
            b[0x5F2:0x5F4] = struct.pack('<h', 0xF0)  # |pucky| == 0xF0
            b[0x5F4:0x5F6] = struct.pack('<h', 6)     # |puckx| == 6
        if 0x400 + 128 <= len(b) and kind in (3, 4, 5, 6, 7):
            p = bytearray(b[0x400:0x400 + 128])
            if kind in (3, 4, 5):
                p[0x44] = 2  # new assignment
            if kind == 5:
                struct.pack_into('<h', p, 0x2E, 0x300)  # temp5 > 0x258, but pflags&2 returns first
            if kind == 7:
                struct.pack_into('<h', p, 0x2E, 0x300)  # temp5 > 0x258: drop the puck
                p[0x44] = 0
            if kind == 6:
                # close to the resting puck so the pickup arm runs
                struct.pack_into('<I', p, 0x00, (6 & 0xFFFF) << 16)
                struct.pack_into('<I', p, 0x04, (0xE8 & 0xFFFF) << 16)
                struct.pack_into('<h', p, 0x26, 0)  # temp1: --temp1 < 0 then +8
            b[0x400:0x400 + 128] = p
    if n == 'assgoalie':
        kind = seed % 10
        if kind == 1:   # behind the goal line
            gx, gy = 0x10, 0xF0
        elif kind == 2:  # out of the crease (|x| > 0x34)
            gx, gy = 0x40, 0xD0
        elif kind == 4:  # behind, |x| > 0x30 so he keeps his own x
            gx, gy = 0x40, 0xF0
        else:
            gx, gy = 0x10, 0xD0  # crease (0 wraparound, 9 post)
        pfl = 2 if kind == 3 else (0x80 if seed & 2 else 0)
        pdist = 0x10 if kind in (6, 7, 8) else 0x20
        if 0x400 + 128 <= len(b):
            p = bytearray(plant_player_bytes(
                x=gx, y=gy, z=2, sc=1, pos=0, xv=0x40, yv=0x200,
                pflags=pfl, puckdist=pdist, spa=0x99))
            struct.pack_into('<h', p, 0x26, 2 if kind == 5 else -1)  # temp1: 2 is playeracc, -1 takes aidef
            struct.pack_into('<h', p, 0x2E, 10 if kind == 6 else -1)  # temp5 delay vs skip
            struct.pack_into('<h', p, 0x2C, 1 if kind == 7 else 0)  # temp4: -- then 0 for dive
            p[0x5A] = 9  # aidef
            p[0x45] = 0  # pflags2
            struct.pack_into('<h', p, 0x36, 1)  # facedir: 1<<1 & 0x42 takes the facing turn
            if kind in (0, 7, 9):
                struct.pack_into('<I', p, 0x6C, ARG + 0x800)  # tmptr
                struct.pack_into('<I', p, 0x70, ARG + 0x900)  # optmptr
            b[0x400:0x400 + 128] = p
        patch_u8(img, patches, 'gmode', 0)
        patch_u8(img, patches, 'iflags', 0)
        patch_u32(img, patches, 'puckvx', ARG + 0x5F8)
        patch_u32(img, patches, 'puckvy', ARG + 0x5FA)
        if 0x5FC <= len(b):
            b[0x5F8:0x5FC] = struct.pack('<hh', 0, 0x4000)
        if 0x5F0 < len(b):
            if kind in (3, 6):
                b[0x5F0] = 1   # holding: puckc == SCnum
            elif kind == 8:
                b[0x5F0] = 6   # other team: poke
            elif kind in (0, 7, 9):
                b[0x5F0] = 0xFF  # loose: wraparound / dive / post
        if kind == 0 and 0x5F6 <= len(b):
            b[0x5F2:0x5F6] = struct.pack('<hh', 0xA0, 0x50)  # |pucky|>=0x98, |puckx|>=0x44
            struct.pack_into('<h', b, 0x400 + 0x2C, 2)  # temp4: -- then 1, skip dive
        if kind == 9 and 0x5F6 <= len(b):
            b[0x5F2:0x5F6] = struct.pack('<hh', 0xE0, 0x20)  # |pucky|>0xDC post
            struct.pack_into('<h', b, 0x400 + 0x2C, 2)
        if kind in (0, 7, 9) and 0x944 <= len(b):
            struct.pack_into('<i', b, 0x800 + 0x3E, 0x200 if kind != 7 else 0x20)
            struct.pack_into('<i', b, 0x900 + 0x3E, 0x200 if kind != 7 else 0x20)
        pc = img.labels().get('puckcross')
        if pc and kind == 0:
            overlay_patch(patches, pc, struct.pack('<hh', 0x20, 0))  # |pc[0]|>=0x19, pc[1]<0x23
        if pc and kind == 9:
            overlay_patch(patches, pc, struct.pack('<hh', 4, 0x20))  # |pc[0]|<0x19, pc[1]>=x+0xC
        sc0 = img.labels().get('SortCords')
        if sc0 and kind == 6:
            overlay_patch(patches, sc0 + 6 * 128, plant_player_bytes(
                x=0x10, y=0xC0, z=2, sc=6, pos=1, puckdist=0x10, pflags2=0))
    if n == 'assonetimer':
        kind = seed % 4
        patch_u32(img, patches, 'onetimerflag', 0 if kind == 3 else 1)
        if 0x400 + 128 <= len(b):
            p = bytearray(b[0x400:0x400 + 128])
            struct.pack_into('<h', p, 0x26, -0x800)  # temp1 high byte -8
            struct.pack_into('<h', p, 0x38, 0xDD3 if kind == 0 else 0)
            struct.pack_into('<h', p, 0x3A, 0)
            struct.pack_into('<I', p, 0x6C, ARG + 0x900)  # tmptr
            if kind == 2:
                p[0x44] = 8  # pfjoy: skip the attacking-zone test
            b[0x400:0x400 + 128] = p
        if 0x5F0 < len(b):
            b[0x5F0] = 1 if kind == 1 else 0xFF  # SCnum vs loose
        patch_u16(img, patches, 'passdir', 4)
        patch_u32(img, patches, 'puckvx', ARG + 0x5F8)
        patch_u32(img, patches, 'puckvy', ARG + 0x5FA)
        if 0x5FC <= len(b):
            b[0x5F8:0x5FC] = struct.pack('<hh', 0x40, 0x40)
    if n == 'POAfterGame':
        # p+0x40 is the game index; idx/=7 is the series. Plant series*7 so round 1/2/conf/cup mix.
        idxs = (0, 28, 56, 70, 84, 91, 98)
        gi = idxs[seed % 7]
        if 0x244 <= len(b):
            struct.pack_into('<I', b, 0x200 + 0x40, gi)
        patch_u16(img, patches, 'hmscore', 3)
        patch_u16(img, patches, 'awscore', 2)
        patch_u32(img, patches, 'gameopts', 1 << 12)  # optbits12 = 1
        patch_u16(img, patches, 'HomeTeam', 5)
        patch_u16(img, patches, 'VisTeam', 6)
        patch_u32(img, patches, 'ctl1team', 5)
        patch_u32(img, patches, 'ctl2team', 0xFFFFFFFF)
        patch_u32(img, patches, 'ctl1side', 0)
        patch_u32(img, patches, 'ctl2side', 1)
        rec = 0x200 + 0x1998
        if rec + 0x2A * 16 <= len(b):
            for j in range(16):
                off = rec + j * 0x2A
                b[off:off + 6] = bytes([4, 10, 5, 6, 3, 2])
    if n == 'InstantReplay':
        patch_u32(img, patches, 'gamemode', 0 if seed & 1 else 1)
        patch_u32(img, patches, 'ctl1team', 0xFFFFFFFF if seed & 2 else 5)
        patch_u32(img, patches, 'ctl2team', 0xFFFFFFFF)
        fc = img.labels().get('fileoncd')
        if fc:
            overlay_patch(patches, fc + 0x96, b'\x01')
            overlay_patch(patches, fc + 0x223, b'\x01')
    if n == 'StarCompare':
        kind = seed % 7
        if 0x108 <= len(b):
            struct.pack_into('<I', b, 0x100, 1)   # team 0 player 1
            struct.pack_into('<I', b, 0x104, 27)  # team 1 player 2
        def star_row(g, a_, w6=0, w0e=0):
            r = bytearray(16)
            struct.pack_into('<hh', r, 0, g, a_)
            struct.pack_into('<h', r, 6, w6)
            struct.pack_into('<h', r, 14, w0e)
            return bytes(r)
        if kind == 0:
            ra, rb = star_row(5, 0), star_row(1, 0)          # different points
        elif kind == 1:
            ra, rb = star_row(3, 2), star_row(4, 1)          # sa==sb, goals differ
        elif kind == 3:
            ra, rb = star_row(2, 3, 0, 4), star_row(2, 3, 0, 1)  # +0Eh differ
        elif kind == 4:
            ra, rb = star_row(2, 3, 5, 0), star_row(2, 3, 2, 0)  # +6 differ
        else:
            ra, rb = star_row(2, 3), star_row(2, 3)          # equal: hmscore / StarElig / DACA0
        db = img.labels().get('dword_DB088')
        if db:
            overlay_patch(patches, db + 16, ra)     # pa=1
            overlay_patch(patches, db + 432, rb)    # team1*400 + pb=2 * 16
        patch_u32(img, patches, 'gwgteam', 0 if kind == 0 else 0xFFFFFFFF)
        patch_u32(img, patches, 'gwgplayer', 1)
        hs = img.labels().get('hmscore')
        if hs:
            # kinds 0-1 may return at points/goals; 2+ need ds==0 so +0Eh / +6 / StarElig / DACA0 run
            overlay_patch(patches, hs, struct.pack('<h', 3))
            overlay_patch(patches, hs + 256, struct.pack('<h', 3 if kind >= 2 else 1))
        da = img.labels().get('unk_DACA0')
        if da:
            ua, ub = bytearray(20), bytearray(20)
            ua[1], ub[1] = 2, 5
            overlay_patch(patches, da + 20, bytes(ua))
            overlay_patch(patches, da + 540, bytes(ub))
    if n == 'TradeScreenLoop':
        patch_u32(img, patches, 'tradeside', 0)
        tc = img.labels().get('tradecursor')
        if tc:
            overlay_patch(patches, tc, struct.pack('<ii', 1, 1))
    if n in ('RunTeamPickMenu', 'RunPlayerPickMenu'):
        patch_u32(img, patches, 'statsplayoffs', 0 if seed % 2 == 0 else 1)
        order = img.labels().get('statsteamorder')
        if order:
            overlay_patch(patches, order, b''.join(struct.pack('<I', i) for i in range(26)))
        patch_u32(img, patches, 'statsteambuf', ARG + 0x800)
        if 0x800 + 64 <= len(b):
            b[0x800 + 0x0D] = 3
    if n == 'RunPlayerPickMenu':
        rec = bytearray(0x34)
        rec[2] = ord('G') if seed & 1 else ord('C')
        rec[3:8] = b'AAAA\x00'
        rec[0x13:0x18] = b'BBBB\x00'
        sp = img.labels().get('statsplayer')
        if sp:
            overlay_patch(patches, sp, bytes(rec))
        buf = img.labels().get('statsplayerbuf')
        if buf:
            overlay_patch(patches, buf, bytes(rec) * 4)
        patch_u32(img, patches, 'statsnumskaters', 4)
        patch_u32(img, patches, 'statsnumgoalies', 2)
        so = img.labels().get('statsskaterorder')
        if so:
            overlay_patch(patches, so, b''.join(struct.pack('<I', i) for i in range(4)))
        pl = img.labels().get('statsskaterplr')
        if pl:
            overlay_patch(patches, pl, b''.join(struct.pack('<I', i) for i in range(4)))
        go = img.labels().get('statsgoalieorder')
        if go:
            overlay_patch(patches, go, b''.join(struct.pack('<I', i) for i in range(2)))
        gp = img.labels().get('statsgoalieplr')
        if gp:
            overlay_patch(patches, gp, b''.join(struct.pack('<I', i) for i in range(2)))
    if n in ('DrawCalendarDay', 'CalendarScreen'):
        # 6-byte games: month+1, day, home, away, us, them. Selected cell matches calsel*.
        g = ARG + 0x200
        month = 0
        day = 15
        if 0x200 + 12 <= len(b):
            b[0x200:0x200 + 6] = bytes([month + 1, day, 5, 6, 3, 2])
            b[0x206:0x206 + 6] = bytes([month + 1, 16, 6, 5, 0xFF, 0xFF])
        crests = ARG + 0x700
        if 0x700 + 26 * 4 <= len(b):
            for i in range(26):
                b[0x700 + i * 4:0x700 + i * 4 + 4] = struct.pack('<I', ARG + SPRITE_OFF)
        patch_u32(img, patches, 'calselmonth', month + 1)
        patch_u32(img, patches, 'calselday', day)
        mf = img.labels().get('monthfirstday')
        if mf:
            overlay_patch(patches, mf, bytes([1]) * 12)
    if n == 'DrawRinkOverlays':
        patch_u16(img, patches, 'camx', 0x40)
        patch_u16(img, patches, 'camy', 0x40)
        patch_u8(img, patches, 'PBnum', 2)
        patch_u32(img, patches, 'PerTimeTotal', 0x02000000)
        sc_obj = (0x0E, 0x0C, 0x0F, 0x0E)[seed % 4]
        frame = (0x286, 0x22E, 0x189, 0x286)[seed % 4]
        so = img.labels().get('sortobj15')
        if so:
            overlay_patch(patches, so, plant_player_bytes(x=0x20, y=0x40, z=4, sc=sc_obj, pos=1, frame=frame))
        sc0 = img.labels().get('SortCords')
        if sc0:
            overlay_patch(patches, sc0, plant_player_bytes(x=0x20, y=0x40, z=4, sc=sc_obj, pos=1, frame=frame))
        oo = img.labels().get('OOlist')
        if oo:
            overlay_patch(patches, oo, bytes(16))
        patch_u32(img, patches, 'puckc', ARG + 0x5F0)
        py = (-0xEC, 0xC0, -0x10, 0xF4)[seed % 4]
        px = 0x10 if py == -0xEC else 0x80
        pz = 0x10 if py == -0xEC else 4
        if 0x5F8 <= len(b):
            b[0x5F0] = 0xFF if seed & 1 else 0x10
            b[0x5F2:0x5F8] = struct.pack('<hhh', px, py, pz)
        patch_u32(img, patches, 'puckx', ARG + 0x5F2)
        patch_u32(img, patches, 'pucky', ARG + 0x5F4)
        patch_u32(img, patches, 'puckz', ARG + 0x5F6)
    if n == 'InProgress':
        patch_u16(img, patches, 'RefStep', 1)
        patch_u16(img, patches, 'ovlseq', 0 if seed & 1 else 2)
        patch_u16(img, patches, 'ovltimer', 0)
        pb = img.labels().get('PenBuf')
        if pb:
            # 0: energy-byte arm; 0x1A: StartPenaltyShot
            overlay_patch(patches, pb, bytes([0 if seed & 2 else 0x1A, 0, 0, 0, 0, 0, 0, 0]))
        pl = img.labels().get('PenBuf_pl')
        if pl:
            overlay_patch(patches, pl, bytes([0x80, 0, 0, 0, 0, 0, 0, 0]))
        hm = img.labels().get('hmtmstruct')
        if hm:
            overlay_patch(patches, hm + 0x7E, b'\x02\x00' * 28)
        aw = img.labels().get('awtmstruct')
        if aw:
            overlay_patch(patches, aw + 0x7E, b'\x02\x00' * 28)
        sc0 = img.labels().get('SortCords')
        if sc0:
            overlay_patch(patches, sc0, plant_player_bytes(x=0x20, y=0x40, z=2, sc=1, pos=-1, pflags=0x40))
    if n == 'PlayoffTreeMenu':
        patch_u16(img, patches, 'word_C6D24', 1 if seed & 1 else 0)
        patch_u32(img, patches, 'dword_C65AC', 0)
    if n == 'FillDressedSlots':
        if 0x120 <= len(b):
            b[0x100:0x119] = bytes(range(8)) + bytes([0xFF]) + bytes(16)
        patch_u16(img, patches, 'word_E9F12', 0 if seed & 1 else 4)
        patch_u16(img, patches, 'word_E9F14', 0)
        patch_u32(img, patches, 'dword_E9F16', 0)
        e9 = img.labels().get('byte_E9E18')
        if e9:
            overlay_patch(patches, e9, bytes([2 if seed & 2 else 1] * 25))
        hm = img.labels().get('hmroster')
        if hm:
            rec = bytearray(0x27); rec[0] = 1; rec[5] = 3
            overlay_patch(patches, hm, bytes(rec) * 8)
        db = img.labels().get('byte_DB3AE')
        if db:
            overlay_patch(patches, db, bytes([ord('C' if seed & 1 else 'D')]) * 8)
        tab = img.labels().get('hmlinetab')
        if tab:
            overlay_patch(patches, tab, bytes(range(0x30)))
        g473 = img.labels().get('byte_CD473')
        if g473:
            overlay_patch(patches, g473, bytes(25))
        g421 = img.labels().get('byte_CD421')
        if g421:
            overlay_patch(patches, g421, bytes([0, 1, 2, 0xFF]) + bytes([0xFF]) * 12)
    if n == 'PickForLineSlot':
        rec = bytearray(0x27); rec[0] = 1; rec[5] = 3
        hm = img.labels().get('hmroster')
        if hm:
            overlay_patch(patches, hm, bytes(rec) * 8)
        pos = (ord('D'), ord('C'), ord('R'), ord('L'))[seed & 3]
        db = img.labels().get('byte_DB3AE')
        if db:
            blob = bytearray(0x24 * 39)
            for i in range(0x24):
                blob[i * 39] = pos
            overlay_patch(patches, db, bytes(blob))
        for name in ('hmlinetab', 'awlinetab'):
            tab = img.labels().get(name)
            if tab:
                overlay_patch(patches, tab, bytes(range(0x30)))
        g473 = img.labels().get('byte_CD473')
        if g473:
            overlay_patch(patches, g473, bytes(0x24))  # start=0 so CD421 scan finds the slot
        g421 = img.labels().get('byte_CD421')
        if g421:
            overlay_patch(patches, g421, bytes([0, 0x0C, 0x12, 0x1C, 0xFF]) + bytes([0xFF]) * 12)
        dressed = bytes(range(8)) + bytes([0xFF]) * 17
        for name in ('unk_E9D50', 'byte_E9DB4', 'unk_E9CEC', 'unk_E9DE6', 'unk_E9EAE',
                     'unk_E9D82', 'unk_E9E7C', 'unk_E9D1E', 'byte_E9E4A', 'unk_E9EE0'):
            a = img.labels().get(name)
            if a:
                overlay_patch(patches, a, dressed * 2)
    if n == 'PenGoalStuff':
        pb = img.labels().get('PenBuf')
        if pb:
            overlay_patch(patches, pb, bytes([2, 0, 0, 0, 0, 0, 0, 0]))
        pl = img.labels().get('PenBuf_pl')
        if pl:
            overlay_patch(patches, pl, bytes([8 if seed & 1 else 3, 0, 0, 0, 0, 0, 0, 0]))
        patch_u16(img, patches, 'gsp', 0 if seed & 2 else 1)
        patch_u16(img, patches, 'bannermsg', 6)
        hm = img.labels().get('hmtmstruct')
        if hm:
            overlay_patch(patches, hm + 0x36, struct.pack('<h', 6))  # tmap
            overlay_patch(patches, hm + 0x7E, b'\x02\x00' * 28)     # tmpdst
            overlay_patch(patches, hm + 0xB6, bytes([0, 0xFF]) + bytes(34))  # tmpbox
        aw = img.labels().get('awtmstruct')
        if aw:
            overlay_patch(patches, aw + 0x36, struct.pack('<h', 4))
            overlay_patch(patches, aw + 0x7E, b'\x02\x00' * 28)
            overlay_patch(patches, aw + 0xB6, bytes([0, 0xFF]) + bytes(34))
    if n == 'SeedPlayoffRound3':
        # 6-byte games at buf+0x150; g[4] != 0xFF so the date walk finds a played game.
        base = 0x200 + 0x150
        if base + 12 <= len(b):
            b[base:base + 6] = bytes([4, 10, 5, 6, 3, 2])
            b[base + 6:base + 12] = bytes([4, 11, 6, 5, 0xFF, 0xFF])
    return bytes(b), patches

def clamp_leftover_inputs(func, regs, args):
    """Even-case clamps for leftover NR (109-plan H3). Typed stream already stays in-bound; this
    keeps loop counts and collide indices off EDGE / ARG-as-count so screen and collide drafts finish."""
    regs, args = dict(regs), list(args)
    n = func or ''
    low = n.lower()
    if n == 'ListDialog':
        regs['edx'] = (regs.get('edx', 1) % 20) or 1
        if args: args[0] = 0  # marks off: first ListHitTest can set n=1
    if n == 'DrawListItems':
        while len(args) < 3: args.append(1)
        args[0] %= 8          # top
        args[1] %= 20         # sel
        args[2] = (args[2] % 20) or 1  # n: never a pointer used as a loop count
    if n in MENU_BARS:
        regs['eax'] = ARG + 0x100
        regs['edx'] = 4  # four planted items (item 1 is a submenu)
    if n == 'SportsDesk':
        regs['eax'] = regs.get('eax', 0) % 3  # mode 0/1/2
    if 'skate' in low or 'puckcoll' in low:
        regs['eax'] = ARG + 0x400  # planted Player
        if 'puckcoll' in low and 'edx' in regs:
            regs['edx'] = 0 if (regs.get('edx', 1) & 1) else collide_sort_index(regs['edx'])
    elif any(s in low for s in ('checkcheck', 'checkgoal', 'passlane')):
        regs['eax'] = ARG + 0x400
        regs['edx'] = ARG + 0x480  # second Player, not a SortCords index
        if n == 'checkgoal':
            regs['ebx'] = 0x20
            regs['ecx'] = 0x20
        if n == 'checkcheck':
            regs['ebx'] = 0x80 if (regs.get('ebx', 0) & 1) else 0x20  # force >= 0x14
    elif any(s in low for s in ('wallcoll', 'blockshot', 'assone', 'assgoal', 'assref', 'threestars')):
        regs['eax'] = ARG + 0x400
    if n == 'DrawCalendarDay':
        # Watcom register: eax month, edx crests, ebx unused, ecx games; stack ngames, team, font, bank
        regs['eax'] = 0
        regs['edx'] = ARG + 0x700
        regs['ebx'] = 0
        regs['ecx'] = ARG + 0x200
        while len(args) < 4:
            args.append(0)
        args[0] = 2   # ngames
        args[1] = 5   # team == games[0].home
        args[2] = 0
        args[3] = 1   # bank
    if n == 'CalendarScreen':
        while len(args) < 4:
            args.append(0)
        regs['eax'] = regs.get('eax', 0) % 26
    if n == 'PlayoffTreeMenu':
        while len(args) < 2:
            args.append(0)
        args[1] = (regs.get('ebx', 0) % 16)  # series; slot = series*2
    if n == 'FillDressedSlots':
        regs['eax'] = ARG + 0x100
        regs['edx'] = 0 if (regs.get('edx', 0) & 1) else 1  # side
        regs['ebx'] = regs.get('ebx', 0) % 0x24            # slot
    if n == 'PickForLineSlot':
        regs['eax'] = 0 if (regs.get('eax', 0) & 1) else 1
        regs['edx'] = (0, 0x0C, 0x12, 0x1C)[regs.get('edx', 0) & 3]
    if n == 'SeedPlayoffRound3':
        regs['eax'] = ARG + 0x200
        regs['edx'] = (1, 3, 5, 7)[regs.get('edx', 0) & 3]  # games, not ARG
        while len(args) < 1:
            args.append(0)
        args[0] = ARG + 0x50  # human out-param
    if n == 'PenGoalStuff':
        regs['eax'] = 0 if (regs.get('eax', 0) & 1) else 1
    if n == 'InstantReplay':
        regs['eax'] = regs.get('eax', 0) & 1  # mode 0/1
    if n == 'POAfterGame':
        regs['eax'] = ARG + 0x200  # planted schedule, not EDGE
    if n == 'StarCompare':
        regs['eax'] = ARG + 0x100
        regs['edx'] = ARG + 0x104
    return regs, args

def first_use(code, addr, to_ret=False):
    """{reg: 'deref'|'index'|'read'|'write'} for the first use of each register in linear order. pushes, pops and
    `xor r,r` do not count. to_ret: stop at the first ret past the furthest forward jump (callee scan)."""
    use = {}; far = addr; alias = {}   # alias: `mov r1, r2` makes a deref of r1 count for r2
    for i in _md.disasm(code, addr):
        if i.mnemonic in ('push', 'pop') or (i.mnemonic in ('xor', 'sub') and len(set(i.op_str.split(', '))) == 1):
            if i.mnemonic in ('xor', 'sub'):
                for r in (FAMOF.get(i.op_str.split(',')[0].strip()),):
                    if r and r not in use: use[r] = 'write'
            continue
        for op in i.operands:
            if op.type == X86_OP_MEM:
                for rr in (op.mem.base, op.mem.index):
                    r = FAMOF.get(i.reg_name(rr)) if rr else None
                    k = 'index' if op.mem.disp >= DATA_LO else 'deref'   # [reg + global]: reg is an index
                    for x in (r, alias.get(r)):
                        if x and use.get(x) in (None, 'read', 'deref'): use[x] = k if use.get(x) != 'index' else 'index'
        rd, wr = i.regs_access()
        if i.mnemonic == 'mov' and len(i.operands) == 2 and all(o.type == 1 for o in i.operands):
            d, sr = (FAMOF.get(i.reg_name(o.reg)) for o in i.operands)
            if d and sr: alias[d] = alias.get(sr, sr)
        for lst, kind in ((rd, 'read'), (wr, 'write')):
            for rr in lst:
                r = FAMOF.get(i.reg_name(rr))
                if r and r not in use: use[r] = kind
        if to_ret:
            if i.mnemonic.startswith('j') and i.op_str.startswith('0x'): far = max(far, int(i.op_str, 16))
            if i.mnemonic == 'ret' and i.address + i.size > far: break
    return use

def saved_regs(code, addr):
    pu, po = set(), set()   # saved = pushed AND popped (a lone push is an argument or a parameter home)
    for i in _md.disasm(code, addr):
        if i.mnemonic == 'push' and i.op_str in FAMOF: pu.add(FAMOF[i.op_str])
        if i.mnemonic == 'pop' and i.op_str in FAMOF: po.add(FAMOF[i.op_str])
    return pu & po

class Checker:
    def __init__(self, img, func, c_path, size, ret64=False):
        global DATA_LO; DATA_LO = img.objects[1].base
        self.img, self.func, self.ret64 = img, func, ret64
        self.void = self._is_void(c_path, func)
        self.lab = img.labels(); self.addr = self.lab[func]; self.size = size
        self.orig = img.read(self.addr, size)
        obj = cside.compile_draft(c_path)
        self.entry, self.ext, self.code = cside.place(img, obj, func)
        self.code = list(self.code); self.alias = cside.aliases(img, obj, func)
        self.use = first_use(self.orig, self.addr)
        self.saved = saved_regs(self.orig, self.addr)
        self.cmp_regs = self._cmp_regs()
        self.nstack = run._pop_bytes(img, self.addr) // 4
        self.spans = self._spans(obj)
        po = cside._parse(obj['path'], set(self.lab))['pubs']; self.pubs = sorted((o, n) for n, o in po.items()); self.tlen = self.ext[1] - self.ext[0]
        self.fns = None; self.codeptr = False
        self.reg_n = {}; self.pop_n = {}
        self.cov = set(); self.insns = self._insns(); self.reads = set()
        # one Uc per side for the whole run; run.Runner restores it between cases
        zero = bytes(ARG_SIZE)
        self.rorig = run.Runner(img, self.addr, (self.addr, self.addr + self.size), [(ARG, zero)] + self.code, None, MAXI, self.cov,
                                fresh=(ARG,), watch=(ARG, ARG + ARG_SIZE), reads=self.reads)
        self.rc = run.Runner(img, self.entry, self.ext, [(ARG, zero)] + self.code, self.alias, MAXI, None, fresh=(ARG,))

    @staticmethod
    def _is_void(c_path, func):
        """True when the draft defines `void <func>(...)` (not `void *`); default False (eax is compared)"""
        m = re.search(r'^[ \t]*([A-Za-z_][\w \t\*]*?)[ \t\*]+%s[ \t]*\([^;{]*\)\s*\{' % re.escape(func), open(c_path, errors='replace').read(), re.M)
        if not m: return False
        t = m.group(1).split()
        return 'void' in t and '*' not in m.group(0).split(func)[0]

    def _cmp_regs(self):
        """registers compared at exit, decided once from the original's code: ebx/ecx/edx when the original saves them
        (push/pop) or never writes them in its extent (shared epilogues it jumps to included); esi/edi/ebp always, with a
        warning when the original writes one without saving it"""
        lo, hi = self.addr, self.addr + self.size; wr = set(); seen = set(); work = [lo]
        while work:
            a = work.pop()
            while a not in seen:
                seen.add(a)
                code = b''
                for k in (15, 8, 4, 2, 1):
                    try: code = self.img.read(a, k); break
                    except ValueError: pass
                i = next(_md.disasm(code, a), None)
                if i is None: break
                if i.mnemonic not in ('push', 'pop'):
                    for rr in i.regs_access()[1]:
                        r = FAMOF.get(i.reg_name(rr))
                        if r: wr.add(r)
                if i.mnemonic.startswith('ret') or i.mnemonic in ('hlt', 'ud2'): break
                if (i.mnemonic == 'jmp' or i.mnemonic.startswith('j') or i.mnemonic.startswith('loop')) and i.op_str.startswith('0x'):
                    t = int(i.op_str, 16)
                    if lo <= t < hi or (i.mnemonic == 'jmp' and not run.is_func_entry(self.img, t)): work.append(t)
                    if i.mnemonic == 'jmp': break
                elif i.mnemonic == 'jmp': break
                a += i.size
        out = {r for r in ('ebx', 'ecx', 'edx') if r in self.saved or r not in wr}
        for r in ('esi', 'edi', 'ebp'):
            if r in wr and r not in self.saved: run.WARN.append('original writes %s without saving it' % r)
        return out

    def _insns(self):
        """addresses of the original's instructions (linear disassembly, best effort: dword runs that point back
        into the extent are treated as jump-table data and skipped, undecodable bytes are stepped over)"""
        lo, hi = self.addr, self.addr + self.size; code = self.orig; out = []; off = 0
        inx = lambda o: o + 4 <= len(code) and lo <= struct.unpack_from('<I', code, o)[0] < hi
        while off < len(code):
            if inx(off) and inx(off + 4):
                while inx(off): off += 4
                continue
            i = next(_md.disasm(code[off:off + 15], lo + off), None)
            if i is None: off += 1; continue
            out.append(i.address); off += i.size
        return out

    def _spans(self, obj):
        """data ranges to patch: from each referenced data address to the next label, 4..256 bytes"""
        lab = self.lab
        r = cside._parse(obj['path'], set(lab))
        return self._spans_of(self.addr, self.size, {lab[f['target']] + f['addend'] for f in r['fixups'] if f['target'] in lab})

    def _spans_of(self, addr, size, extra=()):
        img, lab = self.img, self.lab; code0 = img.objects[0]
        tg = {t for s, (k, t) in img.fixups.items() if addr <= s < addr + size}
        tg |= set(extra)
        tg = sorted(t for t in tg if not (code0.base <= t < code0.base + code0.size))
        alls = sorted(set(lab.values())); out = []
        for t in tg:
            nxt = next((a for a in alls if a > t), t + 256)
            try: img.read(t, 1)
            except ValueError: continue
            out.append((t, max(4, min(nxt - t, 256))))
        return out

    def index_bound(self):
        return table_bound(self.func)

    # ---- case generator
    def case(self, seed, i, ctx=None, typed=False):
        use_, nstack_, spans_ = ctx or (self.use, self.nstack, self.spans)
        rng = random.Random(seed * 1000003 + i)
        bound = self.index_bound() if typed else INDEX_BOUND
        m = rng.random(); ff = rng.choice((0.05, 0.1, 0.2, 0.3))
        n = ARG_SIZE   # bulk bytes from randbytes, selected with translate tables and big-int masks (a per-byte loop cost 10 ms)
        sel = lambda p: rng.randbytes(n).translate(bytes(255 if x < p * 256 else 0 for x in range(256)))   # 0xFF where chosen
        mix = lambda x, y, k: (((int.from_bytes(x, 'little') & int.from_bytes(k, 'little')) | (int.from_bytes(y, 'little') & ~int.from_bytes(k, 'little')))
                               & ((1 << 8 * n) - 1)).to_bytes(n, 'little')
        if typed:
            raw = bytearray(rng.randbytes(n))
            # Seed struct-shaped objects in ARG: 4 MenuItem slots, a Player (0x80), a Team (cap 64 of 0x100).
            for k in range(4):
                base = 0x100 + k * 32
                raw[base:base + 16] = struct.pack('<IIII', 0, 0, 40, 16)  # in-rect x1,y1,x2,y2
                raw[k * 4:(k + 1) * 4] = struct.pack('<I', ARG + base)
            pbase = 0x400
            raw[pbase + 0x47] = rng.randrange(0, bound) & 0xFF  # pnum
            raw[pbase + 0x1A:pbase + 0x1C] = struct.pack('<H', rng.randrange(0, 7))  # position
            tbase = 0x500
            raw[tbase + 0x10:tbase + 0x12] = struct.pack('<H', rng.randrange(0, 10))  # tmscore
            buf = bytes(raw)
        elif m < 0.4: buf = rng.randbytes(n)
        elif m < 0.7: buf = mix(rng.randbytes(n).translate(bytes((0, 1, 0xFF, 0x80, 0x7F)[x * 5 // 256] for x in range(256))), rng.randbytes(n), sel(0.8))
        else: buf = mix(b'\xff' * n, rng.randbytes(n), sel(ff))   # sentinel-heavy
        def ptr():
            r = rng.random()
            if typed:
                # mapped ARG, never kernel-ish / 0xa5a5a5a5
                off = 0 if r < 0.3 else 0x100 if r < 0.5 else 0x400 if r < 0.7 else rng.randrange(0, ARG_SIZE - 0x2000) & ~3
                return ARG + off
            off = 0 if r < 0.2 else rng.randrange(0, 256) if r < 0.5 else rng.randrange(0, ARG_SIZE - 0x2000)
            return ARG + off
        def scalar():
            if typed:
                r = rng.random()
                if r < 0.7: return rng.randrange(0, bound)
                if r < 0.9: return rng.randrange(0, 256)
                return ptr()
            r = rng.random()
            if r < 0.4: return rng.choice(EDGE)
            if r < 0.7: return rng.randrange(0, 16)
            if r < 0.85: return rng.randrange(0, 0x10000)
            return rng.getrandbits(32)
        def val(p): return ptr() if rng.random() < p else scalar()
        regs = {}
        for r in ('eax', 'edx', 'ebx', 'ecx', 'esi', 'edi', 'ebp'):
            u = use_.get(r)
            p = 1.0 if u == 'deref' else 0.5 if u == 'read' else 0.2
            if u == 'index':
                regs[r] = rng.randrange(0, bound)
            elif u == 'deref':
                regs[r] = ptr()
            else:
                regs[r] = val(p)
            if r in ('esi', 'edi', 'ebp') and u != 'deref' and u != 'index' and rng.random() < 0.7:
                regs[r] = 0xE5000000 | rng.getrandbits(20) << 4 | (1 + ('esi', 'edi', 'ebp').index(r))   # unique tag
        args = [ptr() if rng.random() < 0.4 else rng.randrange(0, bound) for _ in range(nstack_ + 2)]
        patches = {}
        for lo, nspan in spans_ if rng.random() > 0.3 else ():   # 30% of the cases keep every global as loaded
            m = rng.random(); st0 = self.img.read(lo, nspan)
            if m < 0.3: continue   # static image value
            if typed:
                if m < 0.6:
                    b = bytearray(st0); j = rng.randrange(nspan); b[j] = (b[j] + rng.choice((1, 2, 3))) & 0xFF
                elif m < 0.8: b = b''.join(struct.pack('<I', rng.randrange(0, bound)) for _ in range((nspan + 3) // 4))
                else: b = b''.join(struct.pack('<I', ptr()) for _ in range((nspan + 3) // 4))
            elif m < 0.6:            # static with one byte nudged
                b = bytearray(st0); j = rng.randrange(nspan); b[j] = (b[j] + rng.choice((1, 2, 3, 0xFF, 0xFE, 0x80))) & 0xFF
            elif m < 0.7: b = bytes(rng.getrandbits(8) for _ in range(nspan))
            elif m < 0.8: b = b''.join(struct.pack('<I', rng.choice(EDGE)) for _ in range((nspan + 3) // 4))
            elif m < 0.9: b = b''.join(struct.pack('<I', ptr()) for _ in range((nspan + 3) // 4))
            else: b = bytes(rng.choice((0, 1, 0xFF)) for _ in range(nspan))
            patches[lo] = bytes(b[:nspan])
        if typed:
            script = [((ptr() if rng.random() < 0.2 else rng.randrange(0, bound)), rng.randrange(0, bound)) for _ in range(32)]
        else:
            script = [((ptr() if rng.random() < 0.2 else scalar()), scalar()) for _ in range(32)]
        if self.func in ('PassLaneChk', 'InProgress') and script:
            script[0] = (0, 0)  # ShotLaneOpen / PaSpeechBusy: take the body, not the early out
        buf = clamp_playoff_team_bytes(self.func, buf, args, regs)
        regs, args = clamp_leftover_inputs(self.func, regs, args)
        buf, patches = plant_leftover(self.func, self.img, buf, patches, seed=i)
        mode = 'list' if self.func == 'ListDialog' else 'menu' if self.func in EVENT_STUB else ''
        if self.func in ('RunTeamPickMenu', 'RunPlayerPickMenu'):
            mode = 'menu_pick'  # 0-arg returns 0 so the statsplayoffs arm runs
        if self.func == 'PlayoffTreeMenu':
            mode = 'menu_redraw'  # 0-arg returns 2 so DrawPlayoffTree runs
        y1, y2 = (0x38, 0x50) if self.func == 'RunPlayerPickMenu' else (10, 26)
        if mode in ('menu', 'menu_pick', 'menu_redraw'):
            buf, patches = plant_screen(self.img, buf, patches, y1=y1, y2=y2)
        return buf, run.State(regs=regs, args=args, patches=patches, script=script,
                              event_stub=bool(mode), event_mode=mode, func=self.func)

    # ---- coverage-guided mutation
    def mutate(self, ent, rng):
        """a changed copy of a corpus case (buf, state, ARG offsets the original read): bytes near read offsets, a patched
        global, a callee script return, an arg register or a stack arg. The same result goes to both sides."""
        buf, st, reads = ent
        b = bytearray(buf); regs = dict(st.regs); args = list(st.args); patches = dict(st.patches)
        script = list(st.script) if isinstance(st.script, (list, tuple)) else []
        rl = sorted(reads)
        for _ in range(rng.choice((1, 1, 2, 3))):
            k = rng.random()
            if k < 0.45:
                off = (rng.choice(rl) + rng.randrange(-4, 8)) if rl else rng.randrange(0, 512)
                off = max(0, min(off, ARG_SIZE - 4)); op = rng.random()
                if op < 0.4: b[off] = rng.choice((0, 1, 0xFF, 0x80, 0x7F, (b[off] + 1) & 255, (b[off] - 1) & 255, b[off] ^ (1 << rng.randrange(8))))
                elif op < 0.6: b[off] = rng.getrandbits(8)
                elif op < 0.8: b[off:off + 4] = struct.pack('<I', rng.choice(EDGE))
                else: b[off:off + 4] = struct.pack('<I', ARG + rng.randrange(0, ARG_SIZE - 0x2000))
            elif k < 0.6 and self.spans:
                lo, n = rng.choice(self.spans)
                x = bytearray(patches.get(lo) or self.img.read(lo, n) or b'')
                x = (x + bytes(n))[:n]
                j = rng.randrange(n)
                if rng.random() < 0.5: x[j] = (x[j] + rng.choice((1, 0xFF, 2, 0xFE, 0x80))) & 0xFF
                else: x[j:j + 4] = struct.pack('<I', rng.choice(EDGE))[:n - j]
                patches[lo] = bytes(x[:n])
            elif k < 0.75 and script:
                script[rng.randrange(len(script))] = (rng.choice(EDGE) if rng.random() < 0.6 else rng.randrange(0, 16), rng.choice(EDGE))
            elif k < 0.92:
                regs[rng.choice(list(regs) or ['eax'])] = rng.choice([0, 1, 3, 5, 15, 31, ARG, ARG + 0x100])
            elif args:
                args[rng.randrange(len(args))] = rng.choice([ARG, ARG + 0x40] + list(range(INDEX_BOUND)))
        b = clamp_playoff_team_bytes(self.func, bytes(b), args, regs)
        regs, args = clamp_leftover_inputs(self.func, regs, args)
        b, patches = plant_leftover(self.func, self.img, b, patches, seed=st.seed or 0)
        y1, y2 = (0x38, 0x50) if self.func == 'RunPlayerPickMenu' else (10, 26)
        if st.event_mode in ('menu', 'menu_pick', 'menu_redraw'):
            b, patches = plant_screen(self.img, b, patches, y1=y1, y2=y2)
        return b, dataclasses.replace(st, regs=regs, args=args, patches=patches, script=script)


    # ---- caller-driven entry states
    def callers_of(self, target):
        """[(entry, size)] of the functions with a direct `call rel32` to target, most call sites first (cached)"""
        if not hasattr(self, '_callers'):
            import bisect
            o = self.img.objects[0]; code = self.img.read(o.base, o.size); rows = self._funcs(); starts = [r[0] for r in rows]
            self._sites = collections.defaultdict(collections.Counter); self._callers = {}
            pos = code.find(b'\xe8')
            while pos >= 0 and pos + 5 <= len(code):
                t = (o.base + pos + 5 + struct.unpack_from('<i', code, pos + 1)[0]) & 0xFFFFFFFF
                k = bisect.bisect_right(starts, o.base + pos) - 1
                if k >= 0 and o.base + pos < rows[k][0] + rows[k][1]: self._sites[t][(rows[k][0], rows[k][1])] += 1
                pos = code.find(b'\xe8', pos + 1)
        if target not in self._callers:
            self._callers[target] = [c for c, n in self._sites.get(target, collections.Counter()).most_common() if c[0] != target][:12]
        return self._callers[target]

    def ctx_of(self, fn):
        if fn not in self._ctx:
            e, sz = fn
            try: code = self.img.read(e, max(sz, 1))
            except ValueError: code = b'\xc3'
            self._ctx[fn] = (first_use(code, e), run._pop_bytes(self.img, e) // 4, self._spans_of(e, max(sz, 1)))
        return self._ctx[fn]

    def snap_runner(self, caller, target, shift, nargs):
        k = (caller, target, shift)
        if k not in self._runners:
            e, sz = caller
            lo = run.STK + run.ENTRY_OFF + shift - 0x1000 + 0x80   # the target's esp0 plus 0x80
            self._runners[k] = run.Runner(self.img, e, (e, e + sz), [(ARG, bytes(ARG_SIZE))], None, 100000, None, fresh=(ARG,),
                                          shift=shift, snap_at=target, snap_lo=lo, snap_n=nargs)
        return self._runners[k]

    def get_snap(self, target, level, s_t):
        """one attempt: (buf, State) at the entry of target, from a round-robin caller run at stack shift s_t + 0x1000
        (level > 0: the caller's own entry state comes from its callers), or None"""
        cs = [c for c in self.callers_of(target) if self._dead.get((c, target), 0) < 150]
        if not cs: return None
        k = self._rr.get(target, 0); self._rr[target] = k + 1; c = cs[k % len(cs)]
        s_c = s_t + 0x1000
        nargs = (self.nstack if target == self.addr else run._pop_bytes(self.img, target) // 4) + 2
        runner = self.snap_runner(c, target, s_c, nargs)
        self._att += 1; buf, st = self.case(self.seed0 + 77, self._att, self.ctx_of(c))
        if level > 0:
            src = self.get_snap(c[0], level - 1, s_c)
            if src is None: self._dead[(c, target)] = self._dead.get((c, target), 0) + 1; return None
            buf, st0 = src; st = dataclasses.replace(st0, script=st.script)
        st.seed = self.seed0 * 1000003 + 500000 + self._att
        self.prep(st); runner.run(st, {ARG: buf})
        if runner.snap is None: self._dead[(c, target)] = self._dead.get((c, target), 0) + 1; return None
        self._dead[(c, target)] = 0
        regs, args, pg, fresh = runner.snap
        raw = fresh.get(ARG) or next(iter(fresh.values()), b'\x00' * ARG_SIZE)
        mode = 'list' if self.func == 'ListDialog' else 'menu' if self.func in EVENT_STUB else ''
        if self.func in ('RunTeamPickMenu', 'RunPlayerPickMenu'):
            mode = 'menu_pick'
        if self.func == 'PlayoffTreeMenu':
            mode = 'menu_redraw'
        return raw[:ARG_SIZE], run.State(regs=regs, args=args, patches=pg, script=None,
                                         event_stub=bool(mode), event_mode=mode, func=self.func)

    def gather(self, want, deadline, max_att):
        """up to `want` distinct entry snapshots of the function under test (level 0, then one level up when under 50)
        -> (list of (buf, State, caller entry), number of callers, snapshots from the level above)"""
        self._rr = {}; self._dead = {}; self._att = 0; self._ctx = {}; self._runners = {}; seen = set(); out = []
        self.seed0 = self.seed0 if hasattr(self, 'seed0') else 1
        ncall = len(self.callers_of(self.addr)); up = 0
        for level in (0, 1):
            if level == 1 and (len(out) >= 50 or not ncall): break
            att = 0
            while len(out) < want and att < max_att and (not deadline or time.time() < deadline):
                att += 1
                r = self.get_snap(self.addr, level, 0)
                if r is None:
                    if all(self._dead.get((c, self.addr), 0) >= 150 for c in self.callers_of(self.addr)): break
                    continue
                buf, st = r
                st = dataclasses.replace(st, script=self.case(self.seed0 + 99, len(out))[1].script)
                key = (hash(buf[:2048]), tuple(sorted(st.regs.items())), tuple(st.args), tuple(sorted((a, hash(b)) for a, b in st.patches.items())))
                if key in seen: continue
                seen.add(key); out.append((buf, st)); up += level
            if level == 0 and len(out) >= 50: break
        return out, ncall, up

    def prep(self, st):
        def argsof(t):
            nr, np_ = self.nreg(t), self.npop(t)
            if st.event_mode in ('menu', 'menu_pick', 'menu_redraw') and run.is_cdecl(self.img, t):
                nr = 0  # cdecl: leftover ebx is the menus pointer, not an out-param
            return nr, np_
        st.argsof = argsof
        st.ptrsize = lambda t, pos: run.ptr_size(self.img, t, pos)

    # ---- one side
    def go(self, buf, st, orig):
        self.prep(st)
        if orig: self.reads.clear()
        t = (self.rorig if orig else self.rc).run(st, {ARG: buf})
        return cside._norm(t, self.addr if orig else self.entry)

    def nreg(self, target):
        if target not in self.reg_n:
            # Bytes at a non-entry (RunPlayerPickMenu 0xb300a) are not a callee; first_use invents nreg.
            if not run.is_func_entry(self.img, target):
                self.reg_n[target] = 0
            else:
                try: u = first_use(self.img.read(target, 512), target, True)
                except ValueError: u = {}
                n = 0
                for k, r in enumerate(ARGREGS):
                    if u.get(r) in ('read', 'deref'): n = k + 1
                self.reg_n[target] = n
        return self.reg_n[target]

    def npop(self, target):
        if target not in self.pop_n: self.pop_n[target] = run._pop_bytes(self.img, target) // 4
        return self.pop_n[target]

    def _funcs(self):
        if self.fns is None:
            self.fns = sorted((int(r['address'], 16), int(r['size']), r['function']) for r in cside._csv_rows())
        return self.fns

    def codeval(self, v, orig):
        """a code address compares as an EXE address; a C-side scratch address first maps to the EXE label of the public
        function holding it, plus the offset; inside a function (not its entry) it renders as ('CODE', function)"""
        if self.ext[0] <= v < self.ext[0] + self.tlen:
            off = v - self.ext[0]; p = [x for x in self.pubs if x[0] <= off]
            if not p or p[-1][1] not in self.lab: return v
            if off != p[-1][0]:   # inside a placed function: by function only (a longer draft must not spill into the next label)
                self.codeptr = True; return ('CODE', p[-1][1])
            v = self.lab[p[-1][1]]
        c0 = self.img.objects[0]
        if not c0.base <= v < c0.base + c0.size: return v
        import bisect
        f = self._funcs(); k = bisect.bisect_right(f, (v, 1 << 30, '')) - 1
        if k < 0 or v >= f[k][0] + f[k][1] or v == f[k][0]: return v
        self.codeptr = True
        return ('CODE', f[k][2])

    def view(self, t, init, orig):
        """comparable form of a trace -> dict field -> value"""
        def sv(v, snap=()):   # a stack address compares by the bytes it points to; a sibling function's placed address by its EXE label
            if not orig: v = self.alias.get(v, self.addr if v == self.entry else v)   # (orig side: scratch bytes read as data map in codeval)
            if not run.STK <= v < run.STK + run.STK_SIZE: return self.codeval(v, orig)
            return ('STK', dict(snap).get(v, b''))
        d = {'ended': t.ended, 'esp_delta': t.esp_delta}
        if not self.void:
            eax = t.ret_eax & 0xFFFF if self.func in SHORT_AX else t.ret_eax
            d['ret eax'] = sv(eax)
        if self.ret64: d['ret edx'] = sv(t.ret_edx)
        for r in ('esi', 'edi', 'ebp'): d[r] = sv(t.regs.get(r))
        esp0 = run.STK + run.ENTRY_OFF
        def wdest(a):
            if run.STK <= a < run.STK + run.STK_SIZE:
                return ('STK', a - esp0)
            return a
        d['writes'] = [(wdest(a), s, sv(v)) for a, s, v in t.writes]
        d['calls'] = [(c[0],) + tuple(sv(x, c[6]) for x in c[1:1 + self.nreg(c[0])]) + tuple(sv(x, c[6]) for x in c[5][:self.npop(c[0])])
                      for c in t.calls]
        return d

    def compare(self, buf, st):
        """-> (diff or '', review notes [str], info notes [str], trap kind or '')"""
        self.codeptr = False; a = self.go(buf, st, True); c = self.go(buf, st, False)
        stop = lambda t: next((k for k, e, dd in t.traps if k not in run.SOFT), '')
        ka, kc = stop(a), stop(c)
        rev = sorted({k for k, e, dd in a.traps + c.traps if k in run._BAD})
        va, vc = self.view(a, st, True), self.view(c, st, False)
        cw = ka == kc == 'code write'
        np_ = (['uninit read, outputs equal'] if any(k == 'uninit stack read' for k, e, dd in a.traps + c.traps) else []) + (['code pointer compared by function'] if self.codeptr else []) + ['null page'] * any(k == 'null page' for k, e, dd in a.traps + c.traps) + ['code write'] * cw
        if ka or kc:
            lim = 'insn limit' in (ka, kc) or cw   # either side ran out: compare only as a prefix, whatever the other ended with
            if ka != kc and not lim: return 'trap kind: orig %s vs C %s' % (ka or 'none', kc or 'none'), rev, np_, ka
            if ka == 'fault' and kc == 'fault':
                fa, fc = (next(dd for k, e, dd in t.traps if k == 'fault').split('@')[-1] for t in (a, c))
                if fa != fc: return 'fault address: orig %s vs C %s' % (fa, fc), rev, np_, ka
            for k in ('writes', 'calls'):
                x, y = va[k], vc[k]
                if lim: n = min(len(x), len(y)); x, y = x[:n], y[:n]   # the shorter log must be a prefix
                if x != y: return self.listdiff(k, va[k], vc[k]), rev, np_, ka or kc
            return "", rev, np_, ka or kc
        info = list(np_)
        for r in ('esi', 'edi', 'ebp', 'ebx', 'ecx', 'edx'):   # entry register returned unset (the draft must return the same)
            if a.ended == 'ret' and a.ret_eax == st.regs.get(r) and st.regs.get(r, 0) >> 24 == 0xE5: info.append('unset return %s' % r)
        for r in ('ebx', 'ecx', 'edx'):
            if r in self.cmp_regs:
                va[r], vc[r] = (('STK', b'') if run.STK <= x.regs.get(r) < run.STK + run.STK_SIZE else self.codeval(x.regs.get(r), o) for x, o in ((a, True), (c, False)))
        for k in va:
            if va[k] != vc[k]:
                if isinstance(va[k], list): return self.listdiff(k, va[k], vc[k]), rev, info, ''
                return '%s: orig %s vs C %s' % (k, hx(va[k]), hx(vc[k])), rev, info, ''
        return '', rev, info, ''

    def listdiff(self, k, x, y):
        n = next((j for j in range(max(len(x), len(y))) if j >= len(x) or j >= len(y) or x[j] != y[j]), 0)
        return '%s[%d]: orig %s vs C %s (lens %d/%d)' % (k, n, fmt(x[n:n + 1]), fmt(y[n:n + 1]), len(x), len(y))

    def coverage(self):
        """-> (share, up to 5 largest uncovered (lo, hi) ranges)"""
        miss = [x for x in self.insns if x not in self.cov]; rngs = []; pos = {x: k for k, x in enumerate(self.insns)}
        for x in miss:
            if rngs and pos[x] == rngs[-1][2] + 1: rngs[-1][1] = x; rngs[-1][2] = pos[x]
            else: rngs.append([x, x, pos[x]])
        rngs = sorted(sorted(rngs, key=lambda r: pos[r[0]] - r[2])[:5], key=lambda r: r[0])   # 5 largest, by address
        return 1 - len(miss) / max(len(self.insns), 1), [(r[0], r[1]) for r in rngs]

def _selftest():
    """No Unicorn cases. Proves the Unit 2 comparison rules against the loaded EXE labels."""
    img = image.load(); ok = True
    def check(name, cond):
        nonlocal ok
        print('%s %s' % ('PASS' if cond else 'FAIL', name)); ok = ok and cond
    check('0xb300a is not a function entry', not run.is_func_entry(img, 0xb300a))
    sl = img.labels()['SeriesLength']
    check('SeriesLength is a function entry', run.is_func_entry(img, sl))
    class Box:
        pass
    b = Box(); b.img = img; b.reg_n = {}
    check('nreg at 0xb300a is 0', Checker.nreg(b, 0xb300a) == 0)
    check('nreg at SeriesLength > 0', Checker.nreg(b, sl) >= 0)
    s903 = img.labels().get('sub_903F0')
    check('sub_903F0 is cdecl', s903 and run.is_cdecl(img, s903))
    check('MenuHitTest is not cdecl', not run.is_cdecl(img, img.labels()['MenuHitTest']))
    check('CanFillLineSlot is short-ax', 'CanFillLineSlot' in SHORT_AX and 'FillDressedSlots' in SHORT_AX)
    check('SeriesLength is not short-ax', 'SeriesLength' not in SHORT_AX)
    esp0 = run.STK + run.ENTRY_OFF
    check('SportsDesk dest 0x7f20020 is in the stack region', run.STK <= 0x7F20020 < run.STK + run.STK_SIZE)
    check('STK offset of 0x7f20020 is +0x20', 0x7F20020 - esp0 == 0x20)
    check('table_bound SeriesLength is 32', table_bound('SeriesLength') == INDEX_BOUND)
    check('table_bound CanFillLineSlot is 25', table_bound('CanFillLineSlot') == 25)
    check('table_bound SportsDesk is 8', table_bound('SportsDesk') == 8)
    check('table_bound PlayoffTreeMenu is 16', table_bound('PlayoffTreeMenu') == 16)
    check('table_bound LoadTeamRoster is 26', table_bound('LoadTeamRoster') == 26)
    hm, hi = run.hittest_outs(5, 99)
    check('MenuHitTest hitMenu in [0, 4)', 0 <= hm < 4)
    check('MenuHitTest hitItem in [0, 32)', 0 <= hi < 32)
    import snapshot_dosbox, tempfile
    sample = '{"function":"SeriesLength","regs":{"eax":"0x6000000","ebx":"1"},"args":["0x2"],"pages":{}}\n{"function":"other","regs":{"eax":0}}\n'
    path = tempfile.mktemp(suffix='.jsonl')
    open(path, 'w').write(sample)
    play = snapshot_dosbox.load_play_snaps(path, 'SeriesLength')
    os.remove(path)
    check('play-snaps loads one SeriesLength dump', len(play) == 1 and play[0][1].regs.get('eax') == 0x6000000 and play[0][1].args == [2])
    raw = bytes([0xFF] * 64)
    clamped = clamp_playoff_team_bytes('SimPlayoffRound1', raw, [ARG])
    check('SimPlayoffRound1 g[2] clamped to [0, 26)', clamped[2] == 0xFF % 26 and clamped[3] == 0xFF % 26)
    eax_clamped = clamp_playoff_team_bytes('SimPlayoffRound1', raw, [], {'eax': ARG + 8})
    check('SimPlayoffRound1 eax sched g[2] clamped', eax_clamped[10] == 0xFF % 26)
    check('SeriesLength even-case ARG is not clamped', clamp_playoff_team_bytes('SeriesLength', raw, [ARG])[2] == 0xFF)
    check('SeriesLength stub eax is a best-of', run.serieslen_out(99) in run.SERIES_LENS)
    check('null-page insn-limit is not mostly trapped',
          not mostly_trapped(1834, collections.Counter({'insn limit': 900, 'code write': 4}), n_null_stop=900))
    check('hard insn-limit majority is mostly trapped',
          mostly_trapped(100, collections.Counter({'insn limit': 60}), 0))
    check('null page is SOFT', 'null page' in run.SOFT)
    check('uninit stack read is SOFT', 'uninit stack read' in run.SOFT)
    check('uninit-fault address is review', is_uninit_fault_review('fault address: orig 0xa5a5a5a5 vs C 0x1'))
    check('mapped fault address is not review', not is_uninit_fault_review('fault address: orig 0x100 vs C 0x200'))
    check('collide sort-index 0x10 stays', collide_sort_index(0x10) == 0x10)
    check('collide sort-index 0x20 folds to 0-0xB or 0x10', collide_sort_index(0x20) in set(range(12)) | {0x10})
    r, a = clamp_leftover_inputs('DrawListItems', {'eax': ARG}, [0x6000100, 99, ARG])
    check('DrawListItems n is a small count not ARG', 1 <= a[2] <= 20)
    r, a = clamp_leftover_inputs('ListDialog', {'edx': 0x7FFFFFFF}, [5, ARG])
    check('ListDialog edx n in 1..20 and marks 0', 1 <= r['edx'] <= 20 and a[0] == 0)
    check('GetInputEvent first hits are a mapped event', run.getinput_out(0) != 0 and run.getinput_out(99) == 0)
    check('PollKey first hits are pressed', run.pollkey_out(0) != 0 and run.pollkey_out(99) == 0)
    check('ListHitTest stub is in-rect', 0 <= run.listhit_out(99) < 8)
    check('event stub includes RunMenu and SportsDesk', 'RunMenu' in EVENT_STUB and 'SportsDesk' in EVENT_STUB)
    r, a = clamp_leftover_inputs('RunMenu', {'eax': 0, 'edx': 99}, [])
    check('RunMenu bar is ARG+0x100 and n is 4', r['eax'] == ARG + 0x100 and r['edx'] == 4)
    planted = plant_menus(bytes(0x200), 0x2FED2)
    check('plant_menus on1 at item0+20', struct.unpack_from('<I', planted, 0x100 + 20)[0] == 0x2FED2)
    buf, p = plant_screen(img, bytes(0x200), {})
    ps = img.labels().get('pointerspr')
    check('plant_screen pointerspr -> ARG sprite', ps and struct.unpack_from('<I', p[ps])[0] == ARG + SPRITE_OFF)
    r, a = clamp_leftover_inputs('checkcheck', {'eax': 0xA5A5A5A5, 'edx': 0x20}, [])
    check('checkcheck eax is Player in ARG', ARG <= r['eax'] < ARG + ARG_SIZE)
    check('checkcheck edx is Player pair not sort-index', r['edx'] == ARG + 0x480)
    r, a = clamp_leftover_inputs('checkpuckcoll_ccx', {'eax': 0, 'edx': 0x20}, [])
    check('puckcoll edx stays a sort-index', r['edx'] in set(range(12)) | {0x10, 0})
    r, a = clamp_leftover_inputs('SkateToSpot', {'eax': 0, 'edx': 0xBEEF}, [])
    check('SkateToSpot eax is planted Player', r['eax'] == ARG + 0x400 and r['edx'] == 0xBEEF)
    r, a = clamp_leftover_inputs('DrawCalendarDay', {}, [])
    check('DrawCalendarDay month/games in regs', r['eax'] == 0 and r['ecx'] == ARG + 0x200 and a[0] == 2)
    pb = plant_player_bytes(x=0x14, y=0xEA)
    check('plant_player Ypos hiword is corridor', struct.unpack_from('<I', pb, 4)[0] >> 16 == 0xEA)
    pb = plant_player_bytes(x=-0x40, y=-0x20, xv=-0xC00, yv=0xC00)
    check('plant_player signed Xpos and Xvel', (struct.unpack_from('<i', pb, 0)[0] >> 16) == -0x40
          and struct.unpack_from('<h', pb, 0x0C)[0] == -0xC00)
    buf, p = plant_leftover('checkpuckcoll_ccx', img, bytes(0x800), {}, seed=0)
    sc0 = img.labels().get('SortCords')
    check('plant leftover SortCords goalie pos 0', sc0 and struct.unpack_from('<h', p[sc0], 0x1A)[0] == 0)
    buf, p = plant_leftover('DrawCalendarDay', img, bytes(0x800), {}, seed=0)
    cm = img.labels().get('calselmonth')
    check('plant leftover calselmonth is month+1', cm and struct.unpack_from('<I', p[cm])[0] == 1)
    buf, p = plant_leftover('RunTeamPickMenu', img, bytes(0x900), {}, seed=0)
    sp = img.labels().get('statsplayoffs')
    check('plant leftover statsplayoffs seeded', sp and sp in p)
    buf, p = plant_leftover('RunPlayerPickMenu', img, bytes(0x900), {}, seed=0)
    ns = img.labels().get('statsnumskaters')
    check('plant leftover statsnumskaters is 4', ns and struct.unpack_from('<I', p[ns])[0] == 4)
    buf, p = plant_leftover('InProgress', img, bytes(0x800), {}, seed=0)
    rs = img.labels().get('RefStep')
    check('plant leftover RefStep is 1', rs and struct.unpack_from('<H', p[rs])[0] == 1)
    buf, p = plant_leftover('DrawRinkOverlays', img, bytes(0x800), {}, seed=0)
    cy = img.labels().get('camy')
    check('plant leftover camy is 0x40', cy and struct.unpack_from('<H', p[cy])[0] == 0x40)
    r, a = clamp_leftover_inputs('PassLaneChk', {'eax': 0, 'edx': 0}, [])
    check('PassLaneChk edx is Player pair', r['edx'] == ARG + 0x480)
    buf, p = plant_leftover('PassLaneChk', img, bytes(0x600), {}, seed=0)
    check('PassLaneChk |Y| is 0x70', abs(struct.unpack_from('<i', buf, 0x400 + 4)[0] >> 16) == 0x70)
    buf, p = plant_leftover('checkgoal', img, bytes(0x600), {}, seed=0)
    check('checkgoal p Y equals g Y', (struct.unpack_from('<i', buf, 0x400 + 4)[0] >> 16) == 0x20)
    r, a = clamp_leftover_inputs('checkcheck', {'eax': 0, 'edx': 0, 'ebx': 1}, [])
    check('checkcheck force >= 0x14', r['ebx'] >= 0x14)
    planted = plant_menus(bytes(0x200), 0x2FED2, y1=0x38, y2=0x50)
    check('plant_menus y1 is player-list row', struct.unpack_from('<I', planted, 0x100 + 4)[0] == 0x38)
    r, a = clamp_leftover_inputs('PlayoffTreeMenu', {'eax': 0, 'edx': 99, 'ebx': 5}, [])
    check('PlayoffTreeMenu series is 0..15', a[1] == 5)
    buf, p = plant_leftover('CanBlockShot', img, bytes(0x700), {}, seed=0)
    check('CanBlockShot puckvy toward +Y goal', struct.unpack_from('<h', buf, 0x5F8)[0] == 0x100)
    buf, p = plant_leftover('wallcoll', img, bytes(0x600), {}, seed=0)
    check('wallcoll even seed is a player', struct.unpack_from('<h', buf, 0x400 + 0x6A)[0] == 1)
    r, a = clamp_leftover_inputs('FillDressedSlots', {'edx': 0, 'ebx': 99}, [])
    check('FillDressedSlots list in ARG and slot in range', r['eax'] == ARG + 0x100 and r['ebx'] < 0x24)
    r, a = clamp_leftover_inputs('PickForLineSlot', {'edx': 99}, [])
    check('PickForLineSlot slot is a planted group', r['edx'] in (0, 0x0C, 0x12, 0x1C))
    r, a = clamp_leftover_inputs('SeedPlayoffRound3', {'edx': 99}, [])
    check('SeedPlayoffRound3 games is a best-of', r['edx'] in (1, 3, 5, 7))
    buf, p = plant_leftover('PenGoalStuff', img, bytes(0x100), {}, seed=0)
    pb = img.labels().get('PenBuf')
    check('PenGoalStuff PenBuf is a minor', pb and p.get(pb, b'\x00')[:1] == b'\x02')
    buf, p = plant_leftover('assthreestars', img, bytes(0x600), {}, seed=0)
    ot = img.labels().get('ovltimer')
    check('assthreestars ovltimer is -1', ot and struct.unpack_from('<h', p.get(ot, b'\x00\x00')[:2])[0] == -1)
    buf, p = plant_leftover('assgoalie', img, bytes(0xA00), {}, seed=7)
    check('assgoalie dive optmptr in ARG', struct.unpack_from('<I', buf, 0x400 + 0x70)[0] == ARG + 0x900)
    r, a = clamp_leftover_inputs('POAfterGame', {'eax': 99}, [])
    check('POAfterGame eax is schedule in ARG', r['eax'] == ARG + 0x200)
    buf, p = plant_leftover('POAfterGame', img, bytes(0x300), {}, seed=2)
    check('POAfterGame idx is series*7', struct.unpack_from('<I', buf, 0x200 + 0x40)[0] in (0, 28, 56, 70, 84, 91, 98))
    check('SeriesWinner stub HomeTeam or -1', run.serieswin_out(1) == 5 and run.serieswin_out(0) == 0xFFFFFFFF)
    check('ReplayControlLoop own-hit not nstub k', run.replayctl_out(1) == 1 and run.replayctl_out(8) == 0)
    r, a = clamp_leftover_inputs('StarCompare', {'eax': 99, 'edx': 99}, [])
    check('StarCompare keys in ARG', r['eax'] == ARG + 0x100 and r['edx'] == ARG + 0x104)
    buf, p = plant_leftover('StarCompare', img, bytes(0x200), {}, seed=1)
    db = img.labels().get('dword_DB088')
    check('StarCompare keys 1 and 27', struct.unpack_from('<I', buf, 0x100)[0] == 1
          and struct.unpack_from('<I', buf, 0x104)[0] == 27)
    check('StarCompare DB088 row patched', db and any(lo <= db + 16 < lo + len(v) for lo, v in p.items()))
    buf2, p2 = plant_leftover('StarCompare', img, bytes(0x200), {}, seed=3)
    hs = img.labels().get('hmscore')
    check('StarCompare equal hmscore on tie kinds',
          hs and struct.unpack_from('<h', p2[hs])[0] == 3
          and struct.unpack_from('<h', p2[hs + 256])[0] == 3)
    print('ALL PASS' if ok else 'FAILED')
    return 0 if ok else 1

def is_uninit_fault_review(d):
    """Both sides faulted; orig address is the stack fill. Review, not a C store/call FAIL."""
    return isinstance(d, str) and d.startswith('fault address:') and 'a5a5a5a5' in d.lower()

def hx(v): return hex(v) if isinstance(v, int) else str(v)
def fmt(l): return ' '.join('(%s)' % ','.join(hx(x) for x in e) for e in l) or '(none)'

def find_row(func, seg):
    rows = [r for r in cside._csv_rows() if r['function'] == func and (not seg or r['segment'] == seg or seg in r['segment'])]
    if not rows: raise SystemExit('function %s not in tools/match/c_functions.csv%s' % (func, ' for seg ' + seg if seg else ''))
    return rows[0]

def read_results():
    return list(csv.DictReader(open(RESULTS))) if os.path.exists(RESULTS) else []

def log(row):
    new = not os.path.exists(RESULTS)
    with open(RESULTS, 'a', newline='') as f:
        w = csv.DictWriter(f, HEAD)
        if new: w.writeheader()
        w.writerow(row)

def main(argv=None):
    ap = argparse.ArgumentParser(description='functional-equivalence check of one draft against the original asm')
    ap.add_argument('c_file', nargs='?'); ap.add_argument('--func')
    ap.add_argument('--cases', type=int, default=2000); ap.add_argument('--seed', type=int, default=1)
    ap.add_argument('--budget', type=float, default=0, help='stop after this many seconds (0: no limit; seeded cases get 60%%, mutation the rest); fewer than 500 cases is NEEDS-REVIEW')
    ap.add_argument('--seg'); ap.add_argument('--quiet', action='store_true')
    ap.add_argument('--ret64', action='store_true', help='function returns edx:eax')
    ap.add_argument('--callers', action='store_true', help='also run caller-driven entry states (automatic when coverage after seeded + mutated cases is under 85%%)')
    ap.add_argument('--force', action='store_true', help='ignore a cached PASS')
    ap.add_argument('--no-callers', action='store_true', help='never run the callers phase')
    ap.add_argument('--play-snaps', metavar='JSONL', help='DOSBox-X entry dumps (docs/SNAPSHOTS.md); extra cases after callers')
    ap.add_argument('--selftest', action='store_true', help='harness proofs: short-return, non-entry nreg, STK write dests, typed bounds, MenuHitTest outs')
    a = ap.parse_args(argv)
    if a.selftest:
        return _selftest()
    if not a.c_file or not a.func:
        ap.error('c_file and --func are required (except with --selftest)')
    q = (lambda *x: None) if a.quiet else print
    c_path = os.path.abspath(a.c_file)
    sha = hashlib.sha1(open(c_path, 'rb').read()).hexdigest()
    rel_src = os.path.relpath(c_path, os.path.join(ROOT, 'src')).replace('\\', '/')
    real = rel_src.split('/')[0] in ('engine', 'front', 'pc', 'c')
    rel = os.path.relpath(c_path, ROOT)
    if real and not a.force:
        for r in read_results():
            if (r['function'], r['source_sha1'], r['cases'], r['verdict']) == (a.func, sha, str(a.cases + a.cases // 2), 'PASS'):
                print('cached PASS %s (%s, %s)' % (a.func, r['cases'], r['date'])); return 0
    row = find_row(a.func, a.seg)
    img = image.load(); t0 = time.time()
    la = img.labels()[a.func]; ca = int(row['address'], 16)
    ck = Checker(img, a.func, c_path, int(row['size']) + (ca - la if 0 < ca - la < 0x100 else 0), a.ret64)   # label sits before the csv address (db bytes / entry piece): extent starts at the label
    q('%s: orig %#x+%d, draft at %#x, %d data spans, %d stack dwords%s' % (a.func, ck.addr, ck.size, ck.entry, len(ck.spans), ck.nstack, '; void: eax not compared' if ck.void else ''))
    review = collections.Counter(); info = collections.Counter(); traps = collections.Counter(); V = {'verdict': 'PASS', 'diff': ''}; t1 = time.time(); done = 0; n_null_stop = 0
    corpus = []; nseed = a.cases; nmut = a.cases // 2; total = nseed + nmut; cov_seeded = None; cov_a = None; cov_b = None; ck.seed0 = a.seed
    left = lambda f: not a.budget or time.time() - t1 < a.budget * f

    def one(buf, st, label, pool=None):
        """run one case on both sides; True on a FAIL (printed). pool: list that gets (buf, state, reads, added coverage)"""
        nonlocal done, n_null_stop
        n0 = len(ck.cov)
        d, rv, inf, tk = ck.compare(buf, st); done += 1
        review.update(rv); info.update(inf)
        if tk:
            traps[tk] += 1
            if 'null page' in inf: n_null_stop += 1
        if pool is not None and not d: pool.append((buf, st, set(ck.reads), len(ck.cov) > n0))
        if d:
            V['verdict'] = 'FAIL'; V['diff'] = d
            b = ck.orig[:10]; n = 2 if b[0] == 0x6A else 5 if b[0] == 0x68 else 0
            if not (n and b[n] == 0xE8 and (ck.addr + n + 5 + struct.unpack_from('<i', b, n + 1)[0]) & 0xFFFFFFFF == ck.lab['__CHK']):
                V['verdict'] = 'NEEDS-REVIEW'; V['diff'] = 'entry is not a C prologue; ' + d
            elif is_uninit_fault_review(d):
                V['verdict'] = 'NEEDS-REVIEW'  # orig walked 0xa5a5a5a5; both crashed. Not a C bug.
            print('%s %s: %s\n  %s' % (V['verdict'], a.func, label, d))
            print('  entry regs: ' + ' '.join('%s=%#x' % (r, v) for r, v in st.regs.items()))
            print('  stack args: ' + ' '.join('%#x' % v for v in st.args[:ck.nstack]))
            return True
        return False

    def mutate_phase(pool, n, frac, tag, base):
        for m in range(n):
            if not left(frac): break
            rng = random.Random(a.seed * 7919 + base + m)
            adders = [e for e in pool if e[3]]
            src = adders if adders and rng.random() < 0.7 else pool
            ent = src[rng.randrange(len(src))]
            buf, st = ck.mutate(ent[:3], rng)
            if one(buf, st, 'mutated %scase %d (--seed %d --cases %d)' % (tag, m, a.seed, a.cases), pool if tag else None): return True
        return False

    failed = False
    for i in range(nseed):   # seeded cases get 40% of the budget
        if not left(0.4): break
        buf, st = ck.case(a.seed, i, typed=(i % 2 == 1)); st.seed = a.seed * 1000003 + i
        n0 = len(ck.cov)
        if one(buf, st, 'case %d (seed %d, --seed %d%s)' % (i, st.seed, a.seed, ', typed' if i % 2 else '')): failed = True; break
        if len(ck.cov) > n0:
            corpus.append((buf, st, set(ck.reads), True))
            if len(corpus) > 100: corpus.pop(random.Random(i).randrange(1, 100))
    nseed = done; cov_seeded = ck.coverage()[0]
    if not failed and corpus:   # coverage-guided mutation of the corpus
        for m in range(nmut):
            if not left(0.6): break
            rng = random.Random(a.seed * 7919 + m)
            buf, st = ck.mutate(corpus[rng.randrange(len(corpus))][:3], rng)
            n0 = len(ck.cov)
            if one(buf, st, 'mutated case %d (--seed %d --cases %d; %d seeded cases first)' % (m, a.seed, a.cases, a.cases)): failed = True; break
            if len(ck.cov) > n0:
                corpus.append((buf, st, set(ck.reads), True))
                if len(corpus) > 100: corpus.pop(random.Random(m).randrange(1, 100))
    cov_a = ck.coverage()[0]; nmutdone = done - nseed
    if not failed and (a.callers or (not a.no_callers and cov_a < 0.85)):
        tb = time.time(); rem = (t1 + a.budget - tb) if a.budget else 0
        snaps, ncall, up = ck.gather(a.cases, tb + 0.3 * rem if a.budget else 0, 8 * a.cases)
        pool = []
        for k, (buf, st) in enumerate(snaps):
            if a.budget and time.time() > tb + 0.65 * rem: break
            st.seed = a.seed * 1000003 + 700000 + k
            if one(buf, st, 'snapshot case %d (callers mode, --seed %d --cases %d)' % (k, a.seed, a.cases), pool): failed = True; break
        nsn = len(pool)
        if not failed and pool: failed = mutate_phase(pool, nmut, 1.0, 'snapshot ', 100000)
        cov_b = ck.coverage()[0]
        q('callers: %d callers, %d snapshots (%d via callers of callers), %d run clean; coverage before callers %.1f%%, after %.1f%%' %
          (ncall, len(snaps), up, nsn, 100 * cov_a, 100 * cov_b))
        info['callers cov %.0f%% to %.0f%% (%d snaps)' % (100 * cov_a, 100 * cov_b, len(snaps))] += 1
    if not failed and a.play_snaps:
        import snapshot_dosbox
        play = snapshot_dosbox.load_play_snaps(a.play_snaps, a.func)
        pool = []
        for k, (buf, st) in enumerate(play):
            st.seed = a.seed * 1000003 + 900000 + k
            if one(buf, st, 'play-snap case %d (%s)' % (k, a.play_snaps), pool): failed = True; break
        if not failed and pool: failed = mutate_phase(pool, nmut, 1.0, 'play-snap ', 200000)
        q('play-snaps: %d dumps for %s, %d run clean; coverage %.1f%%' % (len(play), a.func, len(pool), 100 * ck.coverage()[0]))
        info['play-snaps %d dumps %d clean' % (len(play), len(pool))] += 1
    verdict, diff = V['verdict'], V['diff']
    if cov_seeded is not None and nmutdone > 0: q('coverage after seeded cases %.1f%%, after %d mutated cases %.1f%% (corpus %d)' % (100 * cov_seeded, nmutdone, 100 * cov_a, len(corpus)))
    if run.WARN: q('warnings: ' + '; '.join(sorted(set(run.WARN))))
    share, miss = ck.coverage(); nt = sum(traps.values())
    fmtc = lambda c: ', '.join('%s x%d' % kv for kv in sorted(c.items()))
    q('coverage %.1f%% (%d/%d insns executed)%s' % (100 * share, len(ck.insns) - round((1 - share) * len(ck.insns)), len(ck.insns),
      '; uncovered ' + ' '.join('%#x-%#x' % r for r in miss) if miss else ''))
    q('traps: %d/%d cases%s' % (nt, done, ' (' + fmtc(traps) + ')' if nt else ''))
    if verdict == 'PASS':
        why = []
        if review: why.append('trap review: ' + fmtc(review))
        if traps['code write'] * 4 > done: why.append('inputs write into code')
        elif mostly_trapped(done, traps, n_null_stop): why.append('mostly trapped')
        if share < 0.85: why.append('coverage %.0f%%, uncovered %s' % (100 * share, ' '.join('%#x-%#x' % r for r in miss)))
        if done < min(500, total): why.append('only %d cases in the time budget' % done)
        if why: verdict = 'NEEDS-REVIEW'
        diff = '; '.join(why + ([fmtc(info)] if info else []))
    dt = time.time() - t1
    print('%s %s: %d cases in %.1fs (%.1f ms/case)%s' % (verdict, a.func, done, dt, 1000 * dt / max(done, 1), ' ' + diff if diff and verdict != "FAIL" else ""))
    if real: log({'function': a.func, 'c_file': rel, 'source_sha1': sha, 'cases': done if verdict != 'FAIL' else a.cases + a.cases // 2, 'seed': a.seed, 'verdict': verdict,
                  'first_diff': diff[:200], 'date': datetime.date.today().isoformat()})
    else: q('(file outside src/engine|front|pc: not logged)')
    return 0 if verdict != 'FAIL' else 1

if __name__ == '__main__':
    sys.exit(main())
