#!/usr/bin/env python3
"""Single-function runner for the functional-equivalence harness (FUNCTIONAL_PLAN.md, "How the check works" 4-7).

  tr = run(img, entry, extent, State(regs={'eax': 5}, args=[1, 2], patches={lin: b'..'}, script=[(7, 0)]))

entry/extent are independent: extent is a list of (start, end) ranges the function owns (or one (start, end) pair),
entry is where execution starts. Step 4 runs a relocated C copy by passing code=[(scratch_addr, bytes)] (mapped
before the run) with entry and extent inside it. Callee addresses stay the EXE labels on both sides.

Stack convention (Watcom, checked in src/cseg01): the CALLEE pops its own stack args (`ret N`). Example: FileReadAt
does `push eax; call _dos_read_` and never adds esp afterwards; _dos_read_ ends in `ret 4`. So a stubbed outgoing
call must pop N bytes after the return address. N is found by following the callee's control flow in the image (_pop_bytes); State.pops {target: N} overrides it. Register args are eax, edx, ebx, ecx, then the stack.
The callee may clobber eax (and edx for 64-bit results); every other register is left alone by the stub.
"""
import os, sys, struct, random, re
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
    ptrsize: object = None                       # f(callee, arg position) -> bytes to compare behind a stack pointer (default 4)

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

WARN = []   # warnings for the run header (pop counts that needed a fallback)
_POP = {}
_PROTOS = None; _SSIZE = None; _PRET = {}; _R64 = {}
INC = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))), 'src', 'include')

def protos():
    """{name: [param type strings]} from src/include/protos.h"""
    global _PROTOS
    if _PROTOS is None:
        txt = re.sub(r'/\*.*?\*/', ' ', open(os.path.join(INC, 'protos.h'), errors='replace').read(), flags=re.S)
        _PROTOS = {}
        for m in re.finditer(r'([A-Za-z_][\w \t\*]*?)\b([A-Za-z_]\w*)\s*\(([^()]*)\)\s*;', txt):
            ps = [x.strip() for x in m.group(3).split(',')]
            _PROTOS[m.group(2)] = [] if ps in ([''], ['void']) else ps
            _PRET[m.group(2)] = m.group(1)
    return _PROTOS

def struct_sizes():
    """{struct name: size in bytes} from src/include/structs.h (packed, sum of the field sizes)"""
    global _SSIZE
    if _SSIZE is None:
        _SSIZE = {}
        base = {'char': 1, 'short': 2, 'int': 4}
        for m in re.finditer(r'typedef struct (\w+) \{(.*?)\n\} \w+;', open(os.path.join(INC, 'structs.h'), errors='replace').read(), re.S):
            tot = 0
            for ln in m.group(2).split('\n'):
                f = re.match(r'\s+((?:unsigned |signed )?\w+(?: \w+)?[ \*]+)(\w+)(?:\[(\w+)\])?;', ln)
                if not f: continue
                t = f.group(1).strip()
                sz = 4 if '*' in t else base.get(t.split()[-1], 4)
                tot += sz * (int(f.group(3), 0) if f.group(3) else 1)
            _SSIZE[m.group(1)] = tot
    return _SSIZE

def proto_of(img, target):
    inv = [n for n, a in img.labels().items() if a == target]
    return next((protos()[n] for n in inv if n in protos()), None)

def returns64(img, target):
    """True when protos.h gives the callee at `target` a `long long` / `__int64` return (the stub then sets edx too;
    every other callee preserves edx)"""
    if target not in _R64:
        protos(); r = False
        for n, a in img.labels().items():
            if a == target and n in _PRET and ('long long' in _PRET[n] or '__int64' in _PRET[n]): r = True
        _R64[target] = r
    return _R64[target]

def ptr_size(img, target, pos):
    """bytes to compare behind a stack pointer passed as argument `pos` (0-3 registers, then stack dwords) to the
    callee at `target`: 4, or the struct size (cap 64) when protos.h types the parameter as a struct pointer"""
    ps = proto_of(img, target)
    if ps and pos < len(ps):
        m = re.search(r'\b(?:struct\s+)?(\w+)\s*\*\s*\w*\s*$', ps[pos])
        sz = struct_sizes().get(m.group(1)) if m else None
        if sz: return min(sz, 64)
    return 4

def _scan_rets(img, target, cap=20000):
    """-> (set of `ret N` values, complete). Every reachable instruction from target: jumps followed (both ways of a
    conditional), calls not entered, at most `cap` instructions. complete is False on the cap or an unfollowed jump."""
    seen = set(); work = [target]; rets = set(); n = 0; complete = True
    while work:
        a = work.pop()
        while a not in seen:
            if n >= cap: return rets, False
            seen.add(a)
            code = b''
            for k in (15, 8, 4, 2, 1):
                try: code = img.read(a, k); break
                except ValueError: pass
            ins = next(_md.disasm(code, a), None)
            if ins is None: complete = False; break
            n += 1; mn = ins.mnemonic
            if mn.startswith('ret'): rets.add(int(ins.op_str, 0) if ins.op_str else 0); break
            if mn == 'jmp' or mn.startswith('j') or mn.startswith('loop'):
                if ins.op_str.startswith('0x'): work.append(int(ins.op_str, 16))
                elif mn == 'jmp': complete = False
                if mn == 'jmp': break
            elif mn in ('hlt', 'ud2'): break
            a += ins.size
    return rets, complete

def _pop_bytes(img, target):
    """N of the callee's `ret N`, from all reachable instructions of the callee (see _scan_rets). If the rets disagree
    or none is found: the stack args of its prototype in protos.h (params beyond the 4 register ones, 4 bytes each),
    else 0; either way a warning goes to WARN for the run header."""
    if target in _POP: return _POP[target]
    rets, complete = _scan_rets(img, target)
    if len(rets) == 1: n = next(iter(rets))
    else:
        ps = proto_of(img, target)
        n = 4 * max(len(ps) - 4, 0) if ps is not None and len(ps) > 4 else 0
        WARN.append('callee %#x: rets %s%s, using %s %d' % (target, sorted(rets) or 'none', '' if complete else ' (scan incomplete)',
                    'prototype' if ps is not None and len(ps) > 4 else 'default', n))
    _POP[target] = n
    return n

_FUNCS = None
def is_func_entry(img, a):
    """a known function address (tools/c_functions.csv) or a `push N / call __CHK` prologue"""
    global _FUNCS
    if _FUNCS is None:
        import csv
        p = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), 'c_functions.csv')
        _FUNCS = {int(r['address'], 16) for r in csv.DictReader(open(p))}
    if a in _FUNCS: return True
    try: b = img.read(a, 10)
    except ValueError: return False
    n = 2 if b[0] == 0x6A else 5 if b[0] == 0x68 else 0
    return bool(n) and b[n] == 0xE8 and (a + n + 5 + struct.unpack_from('<i', b, n + 1)[0]) & 0xFFFFFFFF == img.labels()['__CHK']

SOFT = ('uninit stack read', 'null page')   # traps that never stop a run (null page is info only, uninit is review)

class Runner:
    """One Uc for many cases. run(state, data) restores the previous case first: CPU context, every page the case
    wrote (copied before its first write, via the write hook and `put`), lazily mapped pages unmapped. `fresh` lists
    code-region addresses (the ARG buffer) that the caller rewrites each case through `data`, so they are never tracked.
    watch=(lo, hi) with reads=set(): offsets from lo of every read in that range are added to reads."""
    def __init__(self, img, entry, extent, code=(), alias=None, max_insns=200000, cov=None, fresh=(), watch=None, reads=None):
        alias = alias or {}
        ext = [tuple(extent)] if extent and isinstance(extent[0], int) else [tuple(e) for e in extent]
        inext = lambda a: any(s <= a < e for s, e in ext)
        chk = img.labels()['__CHK']
        uc = Uc(UC_ARCH_X86, UC_MODE_32); img.map_into(uc)
        fixed = [(o.base & ~0xFFF, (o.base + o.size + 0xFFF) & ~0xFFF) for o in img.objects]
        freshr = []; codew = []
        c0 = img.objects[0]; codew.append((c0.base, c0.base + c0.size))   # data writes here end the case ('code write')
        for addr, b in code:
            lo = addr & ~0xFFF; hi = ((addr + len(b) + 0xFFF) & ~0xFFF) + 0x1000   # one spare page: an insn near the end must not straddle unmapped memory
            uc.mem_map(lo, hi - lo, UC_PROT_ALL); uc.mem_write(addr, b); fixed.append((lo, hi))
            if addr in fresh: freshr.append((lo, hi))
            else: codew.append((lo, hi))
        uc.mem_map(STK, STK_SIZE, UC_PROT_ALL); uc.mem_write(STK, bytes([PAT]) * STK_SIZE)
        uc.mem_map(SENT, 0x1000, UC_PROT_ALL); uc.mem_write(SENT, b'\xf4')
        fixed += [(STK, STK + STK_SIZE), (SENT, SENT + 0x1000)]
        esp0 = STK + ENTRY_OFF
        ctx = uc.context_save()
        saved = {}; lazy = []; lazyset = set(); fa = []; seen = {}
        wlo, whi = watch or (1, 0)
        tr = Trace(); written = set(); nstub = [0]; done = [False]; prev = ['']; follow = [False]; cur = State()

        def touch(a, n):
            for p in range(a & ~0xFFF, a + max(n, 1), 0x1000):
                if p not in saved and p not in lazyset and not any(lo <= p < hi for lo, hi in freshr):
                    try: saved[p] = bytes(uc.mem_read(p, 0x1000))
                    except UcError: pass
        def put(a, b):
            touch(a, len(b)); uc.mem_write(a, b)
        ih = lambda a: a >= STK and a < esp0   # stack-frame address (below entry esp)
        def trap(kind, eip, detail=''): tr.traps.append((kind, eip, detail))
        def stop(): done[0] = True; uc.emu_stop()
        def u32(a): return struct.unpack('<I', bytes(uc.mem_read(a, 4)))[0]
        def script(k, target):
            s = cur.script
            v = s(k, target) if callable(s) else ((s[k % len(s)] if s else 0))
            return (v, 0) if isinstance(v, int) else (v[0], v[1])
        def mnem(u, a):
            m0 = seen.get(a)
            if m0 is None:
                m0 = '(bad)'
                for n in (15, 8, 4, 2, 1):   # near the end of a mapped region a 15-byte read can fault
                    try: m0 = next(_md.disasm(bytes(u.mem_read(a, n)), a)).mnemonic; break
                    except Exception: pass
                seen[a] = m0
            return m0
        def fin(u):
            tr.regs = {r: u.reg_read(UREG[r]) for r in REGS}
            tr.ret_eax, tr.ret_edx = tr.regs['eax'], tr.regs['edx']

        e0, e1 = ext[0]; single = len(ext) == 1
        badx = set(_BAD) | {'(bad)'}
        def code_hook(u, a, sz, ud):
            m = seen.get(a)
            if m is None:
                if a == SENT: stop(); return
                m = mnem(u, a)
            pm = prev[0]; prev[0] = m
            if a in alias and a != entry and pm == 'call': a = alias[a]   # same-object callee: stub it like an EXE callee
            elif (e0 <= a < e1) if single else inext(a):
                if cov is not None: cov.add(a)
                if m in badx:
                    trap('invalid insn' if m == '(bad)' else m, a, m); stop()
                return
            elif (pm.startswith('j') or follow[0]) and pm != 'call' and not is_func_entry(img, a) and a != chk:
                follow[0] = True; return   # jmp to a shared epilogue: keep running there until its ret
            esp = u.reg_read(UREG['esp'])
            # execution left the extent: a call (return address on top is inside extent) or a tail jmp
            top = u32(esp)
            if a == chk:   # no-op stub: drop the 4-byte argument
                u.reg_write(UREG['eip'], top); u.reg_write(UREG['esp'], esp + 8); return
            k = nstub[0]; nstub[0] += 1
            eax, edx = script(k, a)
            rg = tuple(u.reg_read(UREG[r]) for r in ('eax', 'edx', 'ebx', 'ecx')); sa = tuple(u32(esp + 4 + 4 * i) for i in range(4))
            nr, np_ = cur.argsof(a) if cur.argsof else (0, 0)
            ptrs = {}   # stack address -> bytes compared behind it (at most 4, or the struct size from protos.h, cap 64)
            for pos, v in [(i, x) for i, x in enumerate(rg[:nr])] + [(4 + i, x) for i, x in enumerate(sa[:np_])]:
                n = cur.ptrsize(a, pos) if cur.ptrsize else 4
                if STK <= v <= STK + STK_SIZE - n: ptrs[v] = max(n, ptrs.get(v, 0))
            # only bytes the caller has written count: unwritten frame bytes are layout, not behaviour
            snap = tuple((p, tuple(u.mem_read(p + i, 1)[0] if (not ih(p + i) or p + i in written) else None for i in range(n)))
                         for p, n in ptrs.items())
            tr.calls.append((a,) + rg + (sa, snap))
            for j, (p, n) in enumerate(ptrs.items()):
                base = (eax, edx, eax ^ edx, eax + edx)
                put(p, b''.join(struct.pack('<I', (base[i % 4] + j + i // 4) & 0xFFFFFFFF) for i in range((n + 3) // 4))[:n])
                if ih(p): written.update(range(p, min(p + n, esp0)))
            u.reg_write(UREG['eax'], eax & 0xFFFFFFFF)   # Watcom callees keep every register but eax (and edx for a 64-bit result)
            if returns64(img, a): u.reg_write(UREG['edx'], edx & 0xFFFFFFFF)
            if inext(top):   # call: callee pops return address and its own stack args
                n = cur.pops.get(a)
                if n is None: n = _pop_bytes(img, a)
                u.reg_write(UREG['esp'], esp + 4 + n); u.reg_write(UREG['eip'], top)
            else:            # tail call: logged, then the run ends as a return
                tr.esp_delta = esp - esp0 - 4; tr.ended = 'ret'; fin(u); stop()

        def write_hook(u, t, a, sz, val, ud):
            if any(lo <= a < hi for lo, hi in codew):
                touch(a, sz); trap('code write', u.reg_read(UREG['eip']), '%#x' % a); stop(); return
            p = a & ~0xFFF
            if p not in saved and p not in lazyset: touch(a, sz)
            elif (a + sz - 1) & ~0xFFF != p: touch(a, sz)
            if ih(a) and a + sz <= esp0: written.update(range(a, a + sz))
            else: tr.writes.append((a, sz, val & ((1 << 8 * sz) - 1)))
        def read_hook(u, t, a, sz, val, ud):
            if wlo <= a < whi and reads is not None: reads.add(a - wlo)
            if ih(a) and a + sz <= esp0:
                bad = [x for x in range(a, a + sz) if x not in written]
                if bad and u.reg_read(UREG['esp']) <= a:
                    trap('uninit stack read', u.reg_read(UREG['eip']), '%#x+%d' % (a, sz))
        def unmapped(u, t, a, sz, val, ud):
            # lazy seeded memory: an unmapped data read or write maps the 4 KB page (page 0 too), filled from (seed, page) only
            if t in (UC_MEM_READ_UNMAPPED, UC_MEM_WRITE_UNMAPPED):
                pages = sorted({a & ~0xFFF, (a + max(sz, 1) - 1) & ~0xFFF})
                if all(not any(lo <= p < hi for lo, hi in fixed) for p in pages):
                    new = [p for p in pages if p not in lazyset]
                    if len(lazy) + len(new) <= LAZY_MAX:
                        for p in new:
                            if p == 0: trap('null page', u.reg_read(UREG['eip']), '%#x' % a)
                            uc.mem_map(p, 0x1000, UC_PROT_ALL)
                            uc.mem_write(p, random.Random(((cur.seed & 0xFFFFFFFF) << 32) | p).randbytes(0x1000)); lazy.append(p); lazyset.add(p)
                        return True
            fa.append(a); return False
        uc.hook_add(UC_HOOK_MEM_UNMAPPED, unmapped)
        uc.hook_add(UC_HOOK_CODE, code_hook); uc.hook_add(UC_HOOK_MEM_WRITE, write_hook); uc.hook_add(UC_HOOK_MEM_READ, read_hook)

        def run_case(st=None, data=None):
            nonlocal tr, written, cur
            for p, b in saved.items(): uc.mem_write(p, b)
            saved.clear()
            for p in lazy: uc.mem_unmap(p, 0x1000)
            lazy.clear(); lazyset.clear(); fa.clear()
            uc.context_restore(ctx)
            cur = st or State(); tr = Trace(); written = set(); nstub[0] = 0; done[0] = False; prev[0] = ''; follow[0] = False
            for a, b in (data or {}).items(): uc.mem_write(a, b)
            for lin, b in cur.patches.items(): put(lin, bytes(b))
            put(esp0, struct.pack('<I', SENT) + b''.join(struct.pack('<I', a & 0xFFFFFFFF) for a in cur.args))
            for r in REGS: uc.reg_write(UREG[r], cur.regs.get(r, 0) & 0xFFFFFFFF)
            uc.reg_write(UREG['esp'], esp0); uc.reg_write(UREG['eflags'], 0x202)
            try:
                uc.emu_start(entry, 0xFFFFFFFF, count=max_insns)
            except UcError as e:
                trap('invalid insn' if 'INSN' in str(e) else 'fault', uc.reg_read(UREG['eip']), str(e) + (' @%#x' % fa[-1] if fa else '')); done[0] = True
            eip, esp = uc.reg_read(UREG['eip']), uc.reg_read(UREG['esp'])
            if not tr.ended:
                fin(uc)
                if eip == SENT and esp >= esp0 + 4 and all(t[0] in SOFT for t in tr.traps):
                    tr.ended = 'ret'; tr.esp_delta = esp - esp0 - 4
                else:
                    if not done[0]: trap('insn limit', eip, str(max_insns))
                    tr.ended = 'trap'
                    if all(t[0] in SOFT for t in tr.traps): trap('no return', eip, 'esp=%#x' % esp)
            elif any(t[0] not in SOFT for t in tr.traps): tr.ended = 'trap'
            return tr
        self.run = run_case

def run(img, entry, extent, state=None, max_insns=200000, code=(), cov=None, alias=None):
    """one case on a fresh Uc. alias {C-side function entry: EXE label address}: a call to another public function of
    the placed object is stubbed and logged as a call to the label address (jumps inside the object still run inline)"""
    return Runner(img, entry, extent, code, alias, max_insns, cov).run(state)

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
        rn = Runner(img, ent, (ent, ent + size)); t3 = rn.run(s); t4 = rn.run(s)   # one Uc reused: same trace as a fresh one
        good = t1 == t2 == t3 == t4 and t1.ended == 'ret'; ok &= good
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
