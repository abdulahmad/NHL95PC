#!/usr/bin/env python3
"""check_spa.py - the SPA numbers the code uses must come from the sequences in src/data/engine/frames.asm.
  python3 tools/build/check_spa.py        (prints OK, or each difference; exit code 1 on a difference)
It assembles frames.asm, reads the offset of SPAlist and of every SPA label from the object, and checks the
copies that are typed out: the equ lines of src/inc/spa.inc (asm) and the #define lines of
src/include/consts.h (C). Each name there must be a label of frames.asm with the same number (byte offset
from SPAlist / 2), and each label of frames.asm must be in both."""
import os, re, struct, subprocess, sys, tempfile
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(HERE))
NASM = os.environ.get('NASM', 'nasm')
FRAMES = 'src/data/engine/frames.asm'


def labels():
    """{label: value} of the non-local labels of frames.asm, from its ELF symbol table"""
    o = os.path.join(tempfile.mkdtemp(), 'f.o')
    r = subprocess.run([NASM, '-O0', '-f', 'elf32', '-I', 'src/inc/', '-o', o, FRAMES], cwd=ROOT, capture_output=True, text=True)
    if r.returncode: sys.exit(r.stderr)
    d = open(o, 'rb').read()
    shoff, = struct.unpack_from('<I', d, 32); shentsize, shnum = struct.unpack_from('<HH', d, 46)
    secs = [struct.unpack_from('<IIIIIIIIII', d, shoff + i * shentsize) for i in range(shnum)]
    out = {}
    for s in secs:
        if s[1] != 2: continue                       # SHT_SYMTAB
        strtab = secs[s[6]]
        for k in range(s[5] // 16):
            nm, val, size, info, other, shndx = struct.unpack_from('<IIIBBH', d, s[4] + 16 * k)
            name = d[strtab[4] + nm:d.index(b'\0', strtab[4] + nm)].decode()
            if name.startswith('SPA') and shndx not in (0, 0xFFF1) and '.' not in name: out[name] = val
    return out


def main():
    L = labels()
    if 'SPAlist' not in L: sys.exit('check_spa: no SPAlist in ' + FRAMES)
    base = L.pop('SPAlist'); bad = []
    num = {}
    for n, v in L.items():
        if (v - base) & 1: bad.append('%s: odd byte offset %#x from SPAlist' % (n, v - base))
        num[n] = (v - base) // 2
    for f, rx in (('src/inc/spa.inc', r'^(SPA\w+)\s+equ\s+0*([0-9A-Fa-f]+)h\b'),
                  ('src/include/consts.h', r'^#define\s+(SPA\w+)\s+0x([0-9A-Fa-f]+)\b')):
        seen = set()
        for m in re.finditer(rx, open(os.path.join(ROOT, f)).read(), re.M):
            n, v = m.group(1), int(m.group(2), 16); seen.add(n)
            if n not in num: bad.append('%s: %s %#x is not a label of %s' % (f, n, v, FRAMES))
            elif num[n] != v: bad.append('%s: %s is %#x, %s gives %#x' % (f, n, v, FRAMES, num[n]))
        for n in sorted(set(num) - seen, key=num.get): bad.append('%s: no entry for %s (%#x)' % (f, n, num[n]))
    for b in bad: print(b)
    print('check_spa: OK (%d sequences)' % len(num) if not bad else 'check_spa: %d difference(s)' % len(bad))
    sys.exit(1 if bad else 0)


if __name__ == '__main__':
    main()
