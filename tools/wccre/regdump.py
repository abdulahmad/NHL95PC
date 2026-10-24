#!/usr/bin/env python3
"""regdump.py - show how wcc386 10.0 GA hands out registers for a C file, from inside the compiler.

  python3 tools/wccre/regdump.py src/c/<seg>/<File>.c [--raw]

Runs the compiler in the emulator (tools/wccre/emucc.py) and hooks its register allocator, which is the
Open Watcom code generator's (bld/cg/c/regalloc.c), found in the GA image:

  AssignConflicts  +5694C  every pass: CalcSavings (+4F9BC) for each conflict (a variable or temporary),
                           then SortList (+64FC3, an unstable Shell sort +64F44) by savings with ConfBefore
                           (+56A48: c1->savings > c2->savings, unsigned), then in that order: savings 0 ->
                           InMemory (+56840), else GiveRegister (+56888) -> GiveBestReg (+56528)
  conflict_node    +0 next_conflict  +8 name  +C start_block  +10 tree  +14 savings  +1C available  +54 state
  name             +4 class (2 = N_TEMP)  +5 type class

For every pass it prints the conflicts in the order they get registers, with their savings, and what each got
(a register, or memory). Variables show their C name (front-end symbol, read the way FEName +E210 does).
The file is compiled with its own `/* cflags: ... */` flags, as make does (-od in segments 017-019)."""
import argparse, os, struct, sys
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, HERE)
import wccemu, emucc
from unicorn import UC_HOOK_CODE
from unicorn import x86_const as X

B = wccemu.BASE
GA = dict(sorted_list=0x569B4, given=0x568BD, in_memory=0x56840, assign=0x5694C,
          sym_cache_handle=0x7CFCA, sym_cache_buf=0x7BDA4, sym_count=0x7CF78, sym_table=0x7CF70)

REGS = [('EAX', 0x01000003), ('EBX', 0x0200000C), ('ECX', 0x04000030), ('EDX', 0x080000C0),
        ('ESI', 0x10000100), ('EDI', 0x20000200), ('EBP', 0x40000400),
        ('AX', 0x3), ('BX', 0xC), ('CX', 0x30), ('DX', 0xC0), ('SI', 0x100), ('DI', 0x200), ('BP', 0x400),
        ('AL', 0x2), ('AH', 0x1), ('BL', 0x8), ('BH', 0x4), ('CL', 0x20), ('CH', 0x10), ('DL', 0x80), ('DH', 0x40)]


def regname(v):
    for n, m in REGS:
        if v == m:
            return n
    parts = [n for n, m in REGS if v & m == m and len(n) == 3]
    rest = v
    for n, m in REGS:
        if n in parts: rest &= ~m
    return '+'.join(parts + (['%#x' % rest] if rest else [])) or '%#x' % v


class RegDump:
    def __init__(self, emu, raw=False):
        self.emu, self.uc, self.raw = emu, emu.uc, raw
        self.passes = []
        self.cur = None
        for k, f in (('sorted_list', self.on_sorted), ('given', self.on_given), ('in_memory', self.on_memory)):
            self.uc.hook_add(UC_HOOK_CODE, f, begin=B + GA[k], end=B + GA[k])

    def u8(self, a): return self.uc.mem_read(a, 1)[0]
    def u16(self, a): return struct.unpack('<H', self.uc.mem_read(a, 2))[0]
    def u32(self, a): return struct.unpack('<I', self.uc.mem_read(a, 4))[0]

    def sym_name(self, h):
        """FEName (+E210): SymGetPtr(h)->name, without running compiler code. SymGetPtr (+18334): the cached
        symbol, an in-memory table, else the paged store (+18209): 25 records of 28h bytes per 1K page, 16 pages
        per block, block table at +7B884 (8 bytes: memory pointer, flags; bit 4 = in memory)"""
        try:
            if h == self.u16(B + GA['sym_cache_handle']):
                p = B + GA['sym_cache_buf']
            elif h < self.u32(B + GA['sym_count']):
                p = self.u32(self.u32(B + GA['sym_table']) + 4 * h)
            else:
                page = h // 25
                if page == self.u32(B + 0x7C9B0) and self.u32(B + 0x7DBCC):
                    base = self.u32(B + 0x7DBCC)
                else:
                    ent = B + 0x7B884 + (page >> 4) * 8
                    if not self.u8(ent + 4) & 4:
                        return None
                    base = self.u32(ent) + (page & 15) * 0x400
                p = base + (h % 25) * 0x28
            s = self.emu.cstr(self.u32(p), 64)
            return s if s and (s[0].isalpha() or s[0] == '_') and all(c.isalnum() or c == '_' for c in s) else None
        except Exception:
            return None

    def describe(self, conf):
        nm = self.u32(conf + 8)
        cls, tcls = self.u8(nm + 4), self.u8(nm + 5)
        raw = bytes(self.uc.mem_read(nm, 0x30))
        d = dict(conf=conf, name=nm, cls=cls, tcls=tcls, savings=self.u32(conf + 0x14),
                 state=self.u16(conf + 0x54), raw=raw, size=self.u32(nm + 8), label=None)
        if cls == 2:    # N_TEMP: +14 front-end symbol (0 for a code generator temporary), +24 id, +2A flags
            sym = self.u16(nm + 0x14)
            d['id'] = self.u32(nm + 0x24); d['tflags'] = self.u16(nm + 0x2A)
            d['label'] = (self.sym_name(sym) if sym else None) or ('t%d' % d['id'])
        return d

    def on_sorted(self, uc, addr, size, _):
        conf = self.emu.r(X.UC_X86_REG_EAX)
        confs = []
        while conf:
            confs.append(self.describe(conf))
            conf = self.u32(conf)
        self.cur = dict(confs=confs, result={})
        self.passes.append(self.cur)

    def on_given(self, uc, addr, size, _):
        if self.cur is not None:
            self.cur['result'][self.emu.r(X.UC_X86_REG_ESI)] = self.emu.r(X.UC_X86_REG_EAX)

    def on_memory(self, uc, addr, size, _):
        if self.cur is not None:
            conf = self.emu.r(X.UC_X86_REG_EAX)
            self.cur['result'].setdefault(conf, 'memory')

    def report(self, out=sys.stdout):
        for k, p in enumerate(self.passes):
            out.write('pass %d: %d conflicts\n' % (k + 1, len(p['confs'])))
            for c in p['confs']:
                r = p['result'].get(c['conf'])
                got = '-' if r is None else r if isinstance(r, str) else ('memory' if r == 0 else regname(r))
                out.write('  %-14s size %d  savings %6d  -> %-7s %s\n' % (
                    c['label'] or 'class%d' % c['cls'], c['size'], c['savings'], got,
                    c['raw'].hex(' ', 4) if self.raw else ''))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('src'); ap.add_argument('--raw', action='store_true')
    a = ap.parse_args()
    holder = {}
    def setup(emu):
        holder['d'] = RegDump(emu, a.raw)
    import tempfile
    tmp = tempfile.mktemp(suffix='.obj')
    import cc  # tools/ is on sys.path once emucc is imported
    ok, out, emu = emucc.compile_c(a.src, tmp, cc.src_flags(a.src), setup=setup)
    if os.path.exists(tmp): os.remove(tmp)
    if not ok:
        sys.stdout.write(out)
    holder['d'].report()


if __name__ == '__main__':
    main()
