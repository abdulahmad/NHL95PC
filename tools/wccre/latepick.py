#!/usr/bin/env python3
"""latepick.py - the registers wcc386 10.0 GA picks after register allocation, in compile order.

  python3 tools/wccre/latepick.py src/c/<seg>/<File>.c [--func NAME]

After both allocation passes, a late step (+613C8) turns some constants into registers (a byte store of 0
becomes `xor dh, dh` / `mov [x], dh`, a constant operand becomes a register load). It asks +612FE for the
register, and that routine does not choose by liveness alone: it keeps, per size, a fixed list and a position,
and takes the next register after the last one it picked that is not busy at the instruction (live there, or
clobbered by it). The lists:

  byte   AL AH DL DH BL BH CL CH
  word   AX DX BX CX SI DI
  dword  EAX EDX EBX ECX ESI EDI EBP

The position is never reset: it starts at the head of the list for the whole compile (so the first byte pick of
a file is AH) and carries over from function to function. A late register therefore depends on every earlier
late pick of the same size in the file: in this function, and in the functions compiled before it. A draft
compiled alone starts the rotation at the head, while the original module had already moved it.

For each late pick this prints the function, the source line, the size, the register before the pick (where
the rotation stood), the busy registers and the register chosen. To move a late register, change how many picks
of that size come before it (an earlier function of the original module in the same file, or a constant that
is or is not turned into a register earlier), not the statement itself."""
import argparse, os, struct, sys, tempfile
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, HERE); sys.path.insert(0, os.path.join(ROOT, 'tools'))
import emucc, cc, regdump
from unicorn import UC_HOOK_CODE
from unicorn import x86_const as X

B = regdump.B
PICK, PICK_STORE = 0x612FE, 0x61384           # the picker's entry; where it stores and returns the pick
LISTS = {0: ('byte', 0x7F5D4, 0x787AC), 1: ('word', 0x7F5D8, 0x787BC), 2: ('dword', 0x7F5D0, 0x787D8)}


class LatePick(regdump.RegDump):
    def __init__(self, emu):
        self.emu, self.uc, self.picks, self.cur = emu, emu.uc, [], None
        self.uc.hook_add(UC_HOOK_CODE, self.on_pick, begin=B + PICK, end=B + PICK)
        self.uc.hook_add(UC_HOOK_CODE, self.on_store, begin=B + PICK_STORE, end=B + PICK_STORE)

    def proc_name(self):
        try:
            return self.sym_name(self.u16(self.u32(self.u32(B + 0x7E764) + 0x80) + 8))
        except Exception:
            return None

    def on_pick(self, uc, addr, size, _):
        ins = self.emu.r(X.UC_X86_REG_EAX)
        tc = self.u8(ins + 0x38)
        kind = 0 if tc < 2 else 1 if tc <= 3 else 2 if tc <= 5 else None
        if kind is None: self.cur = None; return
        name, cell, lst = LISTS[kind]
        last = self.u32(B + cell)
        busy = self.u32(ins + 8) | self.u32(self.u32(ins + 0x2C) + 0xC)
        res = self.u32(ins + 0x30)
        if res and self.u8(res + 4) == 3: busy |= self.u32(res + 0xC)
        self.cur = dict(func=self.proc_name(), line=self.u16(ins + 0x20), size=name,
                        last=regdump.regname(self.u32(last)) if last else '(start)', busy=busy, reg=None)
        self.picks.append(self.cur)

    def on_store(self, uc, addr, size, _):
        if self.cur is not None:
            self.cur['reg'] = regdump.regname(self.u32(self.emu.r(X.UC_X86_REG_EAX)))
            self.cur = None


def busy_names(mask):
    out = []
    for r in ('EAX', 'EDX', 'EBX', 'ECX', 'ESI', 'EDI', 'EBP'):
        pass
    return '%08X' % mask


def main():
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('src'); ap.add_argument('--func')
    a = ap.parse_args()
    holder = {}

    def setup(emu): holder['p'] = LatePick(emu)
    tmp = tempfile.mktemp(suffix='.obj')
    ok, out, emu = emucc.compile_c(a.src, tmp, cc.src_flags(a.src), setup=setup)
    if os.path.exists(tmp): os.remove(tmp)
    if not ok: sys.stdout.write(out)
    picks = holder['p'].picks
    print('%-24s %5s  %-5s  %-8s  %-9s  %s' % ('function', 'line', 'size', 'after', 'busy', 'picked'))
    for p in picks:
        if a.func and p['func'] != a.func: continue
        print('%-24s %5s  %-5s  %-8s  %-9s  %s' % (p['func'], p['line'] or '.', p['size'], p['last'], '%08X' % p['busy'],
                                                    p['reg'] or '(none free)'))
    print('%d late pick(s) in the file%s' % (len(picks), ', %d in %s' % (sum(1 for p in picks if p['func'] == a.func), a.func)
                                             if a.func else ''))


if __name__ == '__main__':
    main()
