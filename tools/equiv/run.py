#!/usr/bin/env python3
"""Single-function runner for the functional-equivalence harness (FUNCTIONAL_PLAN.md, "How the check works" 4-7).

  tr = run(img, entry, extent, State(regs={'eax': 5}, args=[1, 2], patches={lin: b'..'}, script=[(7, 0)]))

entry/extent are independent: extent is a list of (start, end) ranges the function owns (or one (start, end) pair),
entry is where execution starts. Step 4 runs a relocated C copy by passing code=[(scratch_addr, bytes)] (mapped
before the run) with entry and extent inside it. Callee addresses stay the EXE labels on both sides.

Stack convention (Watcom, checked in src/cseg01): the CALLEE pops its own stack args (`ret N`). Example: FileReadAt
does `push eax; call _dos_read_` and never adds esp afterwards; _dos_read_ ends in `ret 4`. So a stubbed outgoing
call must pop N bytes after the return address. N is read from the callee's own code in the image (first `ret imm`
within 4096 bytes (every ret of a Watcom function pops the same N)); State.pops {target: N} overrides it. Register args are eax, edx, ebx, ecx, then the stack.
The callee may clobber eax (and edx for 64-bit results); every other register is left alone by the stub.
"""
import os, sys, struct, random
from dataclasses import dataclass, field
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import image
from unicorn import Uc, UcError, UC_ARCH_X86, UC_MODE_32, UC_HOOK_CODE, UC_HOOK_MEM_READ, UC_HOOK_MEM_WRITE, UC_HOOK_MEM_UNMAPPED, UC_PROT_ALL, UC_MEM_READ_UNMAPPED, UC_MEM_WRITE_UNMAPPED
from unicorn.x86_const import *
import capstone

REGS = ('eax', 'ebx', 'ecx', 'edx', 'esi', 'edi', 'ebp')
UREG = {r: globals()['UC_X86_REG_' + r.upper()] for r in REGS + ('esp', 'eip', 'eflags')}
STK, STK_SIZE, ENTRY_OFF = 0x7F00000, 0x40000, 0x20000   # stack region; entry esp sits mid-region
SENT = 0x7E00000                                        # sentinel return address (page holds hlt)
LAZY_MAX = 256                                          # lazily mapped pages per run, then faults as before
PAT = 0xA5                                              # stack fill, so uninitialised reads are deterministic
_md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
_BAD = {'in', 'out', 'ins', 'outs', 'insb', 'insw', 'insd', 'outsb', 'outsw', 'outsd', 'int', 'int3', 'into', 'hlt'}

@dataclass
class State:
    regs: dict = field(default_factory=dict)     # eax ebx ecx edx esi edi ebp (missing = 0)
    args: list = field(default_factory=list)     # dwords above the return address
    patches: dict = field(default_factory=dict)  # {lin: bytes} on top of the loaded image
    script: object = None                        # f(k, target) or list; value is eax or (eax, edx)
    pops: dict = field(default_factory=dict)     # {callee: stack bytes it pops}, overrides the image scan
    seed: int = 0                                # case seed; lazily mapped pages are filled from (seed, page) only
    argsof: object = None                        # f(callee) -> (register args, stack dwords) it reads; enables stack-pointer handling

@dataclass
class Trace:
    ret_eax: int = 0
    ret_edx: int = 0
    regs: dict = field(default_factory=dict)
    esp_delta: int = 0                           # bytes popped above the return address (`ret N`)
    writes: list = field(default_factory=list)   # (addr, size, value), outside the function's frame
    calls: list = field(default_factory=list)    # (target, eax, edx, ebx, ecx, (4 stack dwords), ((stack ptr, 16 bytes at call time), ...))
    traps: list = field(default_factory=list)    # (kind, eip, detail)
    ended: str = ''                              # 'ret' | 'trap'

def _pop_bytes(img, target):
    """N of the callee's `ret N`. Follows an unconditional jmp that leaves the function (target below it or over
    0x800 bytes past it: a shared epilogue), since the next `ret` in memory may belong to another function."""
    addr = target
    for _ in range(6):
        code = b''
        for n in (4096, 1024, 256, 16):   # largest window that stays inside one object
            try: code = img.read(addr, n); break
            except ValueError: pass
        nxt = None
        for i in _md.disasm(code, addr):
            if i.mnemonic == 'ret': return int(i.op_str, 0) if i.op_str else 0
            if i.mnemonic == 'jmp' and i.op_str.startswith('0x'):
                t = int(i.op_str, 16)
                if t < target or t > target + 0x800: nxt = t; break
        if nxt is None: return 0
        addr = nxt
    return 0

def run(img, entry, extent, state=None, max_insns=200000, code=(), cov=None):
    st = state or State()
    ext = [tuple(extent)] if extent and isinstance(extent[0], int) else [tuple(e) for e in extent]
    inext = lambda a: any(s <= a < e for s, e in ext)
    chk = img.labels()['__CHK']
    uc = Uc(UC_ARCH_X86, UC_MODE_32); img.map_into(uc)
    for addr, b in code:
        lo = addr & ~0xFFF; uc.mem_map(lo, (addr + len(b) - lo + 0xFFF) & ~0xFFF, UC_PROT_ALL); uc.mem_write(addr, b)
    uc.mem_map(STK, STK_SIZE, UC_PROT_ALL); uc.mem_write(STK, bytes([PAT]) * STK_SIZE)
    uc.mem_map(SENT, 0x1000, UC_PROT_ALL); uc.mem_write(SENT, b'\xf4')
    for lin, b in st.patches.items(): uc.mem_write(lin, bytes(b))
    esp0 = STK + ENTRY_OFF
    uc.mem_write(esp0, struct.pack('<I', SENT) + b''.join(struct.pack('<I', a & 0xFFFFFFFF) for a in st.args))
    for r in REGS: uc.reg_write(UREG[r], st.regs.get(r, 0) & 0xFFFFFFFF)
    uc.reg_write(UREG['esp'], esp0); uc.reg_write(UREG['eflags'], 0x202)
    tr = Trace(); written = set(); nstub = [0]; done = [False]; lowest = [esp0]; seen = {}
    ih = lambda a: a >= STK and a < esp0   # stack-frame address (below entry esp)

    def trap(kind, eip, detail=''):
        tr.traps.append((kind, eip, detail))
    def stop(): done[0] = True; uc.emu_stop()
    def u32(a): return struct.unpack('<I', bytes(uc.mem_read(a, 4)))[0]
    def script(k, target):
        s = st.script
        v = s(k, target) if callable(s) else ((s[k % len(s)] if s else 0))
        return (v, 0) if isinstance(v, int) else (v[0], v[1])

    def code_hook(u, a, sz, ud):
        esp = u.reg_read(UREG['esp'])
        if esp < lowest[0]: lowest[0] = esp
        if a == SENT: stop(); return
        if inext(a):
            if cov is not None: cov.add(a)
            m = seen.get(a)
            if m is None:
                try: m = next(_md.disasm(bytes(u.mem_read(a, 15)), a)).mnemonic
                except Exception: m = '(bad)'
                seen[a] = m
            if m in _BAD or m == '(bad)':
                trap('invalid insn' if m == '(bad)' else m, a, m); stop()
            return
        # execution left the extent: a call (return address on top is inside extent) or a tail jmp
        top = u32(esp)
        if a == chk:   # no-op stub: drop the 4-byte argument
            u.reg_write(UREG['eip'], top); u.reg_write(UREG['esp'], esp + 8); return
        k = nstub[0]; nstub[0] += 1
        eax, edx = script(k, a)
        rg = tuple(u.reg_read(UREG[r]) for r in ('eax', 'edx', 'ebx', 'ecx')); sa = tuple(u32(esp + 4 + 4 * i) for i in range(4))
        nr, np_ = st.argsof(a) if st.argsof else (0, 0)
        ptrs = []   # stack addresses passed as args: log the 16 bytes they point to, then write 16 seeded bytes there
        for v in rg[:nr] + sa[:np_]:
            if STK <= v <= STK + STK_SIZE - 16 and v not in ptrs: ptrs.append(v)
        snap = tuple((p, bytes(u.mem_read(p, 16))) for p in ptrs)
        tr.calls.append((a,) + rg + (sa, snap))
        for j, p in enumerate(ptrs):
            u.mem_write(p, b''.join(struct.pack('<I', (x + j) & 0xFFFFFFFF) for x in (eax, edx, eax ^ edx, eax + edx)))
            if ih(p): written.update(range(p, min(p + 16, esp0)))
        u.reg_write(UREG['eax'], eax & 0xFFFFFFFF); u.reg_write(UREG['edx'], edx & 0xFFFFFFFF)
        if inext(top):   # call: callee pops return address and its own stack args
            n = st.pops.get(a)
            if n is None: n = _pop_bytes(img, a)
            u.reg_write(UREG['esp'], esp + 4 + n); u.reg_write(UREG['eip'], top)
        else:            # tail call: logged, then the run ends as a return
            tr.esp_delta = esp - esp0 - 4; tr.ended = 'ret'; fin(u); stop()
    def fin(u):
        tr.regs = {r: u.reg_read(UREG[r]) for r in REGS}
        tr.ret_eax, tr.ret_edx = tr.regs['eax'], tr.regs['edx']

    def write_hook(u, t, a, sz, val, ud):
        if ih(a) and a + sz <= esp0: written.update(range(a, a + sz))
        else: tr.writes.append((a, sz, val & ((1 << 8 * sz) - 1)))
    def read_hook(u, t, a, sz, val, ud):
        if ih(a) and a + sz <= esp0:
            bad = [x for x in range(a, a + sz) if x not in written]
            if bad and u.reg_read(UREG['esp']) <= a:
                trap('uninit stack read', u.reg_read(UREG['eip']), '%#x+%d' % (a, sz))
    fa = []
    fixed = [(addr & ~0xFFF, (addr + len(b) + 0xFFF) & ~0xFFF) for addr, b in code] + [(STK, STK + STK_SIZE), (SENT, SENT + 0x1000)]
    fixed += [(o.base & ~0xFFF, (o.base + o.size + 0xFFF) & ~0xFFF) for o in img.objects]
    lazy = []
    def unmapped(u, t, a, sz, val, ud):
        # lazy seeded memory: an unmapped data read or write maps the 4 KB page, filled from (seed, page) only
        if t in (UC_MEM_READ_UNMAPPED, UC_MEM_WRITE_UNMAPPED):
            pages = sorted({a & ~0xFFF, (a + max(sz, 1) - 1) & ~0xFFF})
            if all(p >= 0x1000 and not any(lo <= p < hi for lo, hi in fixed) for p in pages):
                new = [p for p in pages if p not in lazy]
                if len(lazy) + len(new) <= LAZY_MAX:
                    for p in new:
                        uc.mem_map(p, 0x1000, UC_PROT_ALL)
                        uc.mem_write(p, random.Random(((st.seed & 0xFFFFFFFF) << 32) | p).randbytes(0x1000)); lazy.append(p)
                    return True
        fa.append(a); return False
    uc.hook_add(UC_HOOK_MEM_UNMAPPED, unmapped)
    uc.hook_add(UC_HOOK_CODE, code_hook); uc.hook_add(UC_HOOK_MEM_WRITE, write_hook); uc.hook_add(UC_HOOK_MEM_READ, read_hook)
    try:
        uc.emu_start(entry, 0xFFFFFFFF, count=max_insns)
    except UcError as e:
        trap('invalid insn' if 'INSN' in str(e) else 'fault', uc.reg_read(UREG['eip']), str(e) + (' @%#x' % fa[-1] if fa else '')); done[0] = True
    eip, esp = uc.reg_read(UREG['eip']), uc.reg_read(UREG['esp'])
    if not tr.ended:
        fin(uc)
        if eip == SENT and esp >= esp0 + 4 and all(t[0] == 'uninit stack read' for t in tr.traps):
            tr.ended = 'ret'; tr.esp_delta = esp - esp0 - 4
        else:
            if not done[0]: trap('insn limit', eip, str(max_insns))
            tr.ended = 'trap'
            if all(t[0] == 'uninit stack read' for t in tr.traps): trap('no return', eip, 'esp=%#x' % esp)
    elif any(t[0] != 'uninit stack read' for t in tr.traps): tr.ended = 'trap'
    return tr

def _selftest():
    img = image.load(); lab = img.labels(); inv = {v: k for k, v in lab.items()}; ok = True
    d1 = img.objects[1].base + 0x2000
    ptr = d1 + 0x100
    cases = [   # name, entry, size, State
        ('ReadBE32 (leaf)', lab['ReadBE32'], 45, State(regs={'eax': ptr, 'ebx': 0x11, 'edx': 0x22},
            patches={ptr: bytes([0x12, 0x34, 0x56, 0x78])})),
        ('DrawRinkEndArt (call, 2 stack args)', lab['DrawRinkEndArt'], 43, State(regs={'eax': 1}, script=[(0x55, 0)])),
        ('WaitKeyRelease (loop, calls)', lab['WaitKeyRelease'], 46, State(regs={'eax': 7, 'esi': 9},
            script=lambda k, t: 1 if k in (0, 2, 4) else 0)),
        ('GetLineEnergies (loop, stores)', lab['GetLineEnergies'], 51, State(regs={'eax': 2, 'edx': d1 + 0x200, 'ebx': 5},
            script=lambda k, t: (0x60 + k * 3, 0))),
    ]
    for name, ent, size, s in cases:
        t1 = run(img, ent, (ent, ent + size), s); t2 = run(img, ent, (ent, ent + size), s)
        good = t1 == t2 and t1.ended == 'ret'; ok &= good
        print('%s %s' % ('PASS' if good else 'FAIL', name))
        print('  ret eax=%#x edx=%#x esp_delta=%d writes=%d %s' % (t1.ret_eax, t1.ret_edx, t1.esp_delta, len(t1.writes),
              ' '.join('%#x:%d=%#x' % w for w in t1.writes[:4])))
        print('  calls=%d %s' % (len(t1.calls), ' '.join('%s(eax=%#x,edx=%#x,s0=%#x)' % (inv.get(c[0], hex(c[0])), c[1], c[2], c[5][0])
              for c in t1.calls[:4])))
        print('  traps=%s deterministic=%s' % (t1.traps[:3], t1 == t2))
    # negative: `in al, dx` in a scratch region must trap
    SC = 0x7D00000
    tr = run(img, SC, (SC, SC + 3), State(), code=[(SC, b'\xec\xc3')])
    good = tr.ended == 'trap' and tr.traps and tr.traps[0][0] == 'in'; ok &= bool(good)
    print('%s negative in al,dx -> %s' % ('PASS' if good else 'FAIL', tr.traps))
    # scratch-region copy with a tail jmp to an outside label and a normal ret
    tr = run(img, SC, (SC, SC + 8), State(regs={'eax': 9}), code=[(SC, b'\x40\xc3')])
    good = tr.ended == 'ret' and tr.ret_eax == 10; ok &= good
    print('%s scratch inc eax; ret -> eax=%d' % ('PASS' if good else 'FAIL', tr.ret_eax))
    print('ALL PASS' if ok else 'FAILED'); return ok

if __name__ == '__main__':
    if '--selftest' in sys.argv: sys.exit(0 if _selftest() else 1)
    print(__doc__)
