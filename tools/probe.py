#!/usr/bin/env python3
"""probe.py - compile a standalone C file with the project compiler and print its disassembly.

  python3 tools/probe.py FILE.c

For codegen experiments outside the build: a small C file (its own extern declarations, or #include "nhl95.h")
compiled with tools/cc.py's compiler and flags (WATCOM_VER, a `/* cflags: */` comment) and disassembled from the
object's _TEXT. Bisecting a draft in a copy (remove a block, recompile, compare) shows which part of a function
causes a codegen choice: e.g. RemoveFromLines' loops alone compare pnum on the stack as the EXE does, and only the
whole function caches it in a register (docs/C_MATCHING.md)."""
import os, sys
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
SRC = os.path.abspath(sys.argv[1]) if len(sys.argv) > 1 else None
sys.path.insert(0, HERE)
import cc, cobj
from capstone import Cs, CS_ARCH_X86, CS_MODE_32


def main():
    if not SRC: raise SystemExit(__doc__)
    os.chdir(ROOT)
    obj = os.path.splitext(SRC)[0] + '.obj'
    ok = cc.compile_many([(SRC, obj, '')])
    if not ok or not ok[0] or not os.path.exists(obj): raise SystemExit('%s: does not compile' % SRC)
    r = cobj.parse(obj)
    names = {o: n for n, o in r['pubs'].items()}
    for i in Cs(CS_ARCH_X86, CS_MODE_32).disasm(r['text'], 0):
        if i.address in names: print('%s:' % names[i.address])
        print('%04X  %-8s %s' % (i.address, i.mnemonic, i.op_str))


if __name__ == '__main__':
    main()
