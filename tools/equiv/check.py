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

def plant_menus(buf, on1=ON1_STUB):
    """4 MenuItem slots at ARG+0x100: in-rect box, text in ARG, on1 a 0-arg stub target."""
    b = bytearray(buf)
    for k in range(4):
        base = 0x100 + k * 32
        if base + 32 > len(b):
            break
        b[base:base + 16] = struct.pack('<IIII', 10, 10, 50, 26)
        b[base + 16:base + 20] = struct.pack('<I', ARG)
        b[base + 20:base + 24] = struct.pack('<I', on1 & 0xFFFFFFFF)
        b[base + 24:base + 32] = bytes(8)
        b[k * 4:(k + 1) * 4] = struct.pack('<I', ARG + base)
    # item 1 is a submenu (on1 0, on2 the same 4 items) so RunMenu covers the on2 arm
    if len(b) >= 0x100 + 64:
        b[0x100 + 32 + 20:0x100 + 32 + 24] = struct.pack('<I', 0)
        b[0x100 + 32 + 24:0x100 + 32 + 32] = struct.pack('<II', ARG + 0x100, 4)
    return bytes(b)

def plant_screen(img, buf, patches):
    """Pointer sprite + fn-pointer globals so leftover screen loops don't null-page on pointerspr."""
    b = bytearray(plant_menus(buf, ON1_STUB))
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

def clamp_leftover_inputs(func, regs, args):
    """Even-case clamps for leftover NR (109-plan H3). Typed stream already stays in-bound; this
    keeps loop counts and collide indices off EDGE / ARG-as-count so screen and collide drafts finish."""
    regs, args = dict(regs), list(args)
    n = func or ''
    low = n.lower()
    if any(s in low for s in ('puckcoll', 'passlane', 'checkcheck', 'checkgoal', 'wallcoll', 'blockshot', 'assone')):
        if 'edx' in regs: regs['edx'] = collide_sort_index(regs['edx'])
        if 'ebx' in regs and low in ('checkcheck', 'checkgoal', 'wallcoll'):
            regs['ebx'] = collide_sort_index(regs['ebx'])
        eax = regs.get('eax', 0)
        if not (ARG <= eax < ARG + ARG_SIZE):
            regs['eax'] = ARG + 0x400  # Player in ARG, not EDGE / null
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
        buf = clamp_playoff_team_bytes(self.func, buf, args, regs)
        regs, args = clamp_leftover_inputs(self.func, regs, args)
        mode = 'list' if self.func == 'ListDialog' else 'menu' if self.func in EVENT_STUB else ''
        if mode == 'menu':
            buf, patches = plant_screen(self.img, buf, patches)
        return buf, run.State(regs=regs, args=args, patches=patches, script=script,
                              event_stub=bool(mode), event_mode=mode)

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
        if st.event_mode == 'menu':
            b, patches = plant_screen(self.img, b, patches)
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
        return raw[:ARG_SIZE], run.State(regs=regs, args=args, patches=pg, script=None,
                                         event_stub=bool(mode), event_mode=mode)

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
            if st.event_mode == 'menu' and run.is_cdecl(self.img, t):
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
