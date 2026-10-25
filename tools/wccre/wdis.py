#!/usr/bin/env python3
"""wdis.py - look around inside the wcc386 10.0 GA image: disassemble, find references, find callers.

  python3 tools/wccre/wdis.py dis OFF [N]      N instructions from image offset OFF (hex), addresses as offsets
  python3 tools/wccre/wdis.py imm OFF          every place the absolute address BASE+OFF appears (a global's users)
  python3 tools/wccre/wdis.py call OFF         every rel32 call to OFF (a function's callers)

The image is loaded as the emulator loads it (cf_load at wccemu.BASE, relocations applied), so offsets are the
+xxxxx offsets of docs/WCC_INTERNALS.md and the hooks of regdump / irdump. Used to find AddConflictNode (+4FFB9,
`imm 7E794` then `call`) and the two walks that call it."""
import os, struct, sys
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, HERE)
import cf_load, wccemu
from capstone import Cs, CS_ARCH_X86, CS_MODE_32

B = wccemu.BASE
MEM = cf_load.load(os.path.join(ROOT, 'tools/watcom/dosga/WCC386.EXE'), B)[1]


def dis(off, n=40):
    for i in Cs(CS_ARCH_X86, CS_MODE_32).disasm(bytes(MEM[off:off + n * 8]), B + off):
        print('%05X  %s %s' % (i.address - B, i.mnemonic, i.op_str))
        n -= 1
        if n == 0: break


def find(pat):
    out, i = [], -1
    while True:
        i = bytes(MEM).find(pat, i + 1)
        if i < 0: return out
        out.append(i)


def callers(off):
    return [i for i in range(len(MEM) - 5) if MEM[i] == 0xE8 and i + 5 + struct.unpack_from('<i', MEM, i + 1)[0] == off]


def main():
    if len(sys.argv) < 3: raise SystemExit(__doc__)
    cmd, off = sys.argv[1], int(sys.argv[2], 16)
    if cmd == 'dis': dis(off, int(sys.argv[3]) if len(sys.argv) > 3 else 40)
    elif cmd == 'imm': print(' '.join('%05X' % x for x in find(struct.pack('<I', B + off))))
    elif cmd == 'call': print(' '.join('%05X' % x for x in callers(off)))
    else: raise SystemExit(__doc__)


if __name__ == '__main__':
    main()
