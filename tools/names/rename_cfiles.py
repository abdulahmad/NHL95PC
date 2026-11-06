#!/usr/bin/env python3
"""rename_cfiles.py BATCH - after tools/names/rename_symbol.py --batch BATCH --no-build, bring the C side along.

rename_symbol.py renames the label in src/ (asm, C, headers) but not the C file of a matched function.
For each OLD NEW line of the batch file this
  1. moves src/c/**/OLD.c to NEW.c (a file named after the function),
  2. fixes the %include "c/<module>/<File>[.<Func>].inc" lines (file stem and function part),
  3. renames the function and its path in tools/match/c_functions.csv.
Then run `make fullcheck` (MATCH twice) and tools/build/update_symbols.py."""
import os, re, sys, glob, subprocess
HERE = os.path.dirname(os.path.abspath(__file__))
_td = HERE
while os.path.basename(_td) != 'tools' and _td != os.path.dirname(_td):
    _td = os.path.dirname(_td)
if _td not in sys.path:
    sys.path.insert(0, _td)
import paths
ROOT = paths.ROOT
os.chdir(ROOT)
ren = {}
for l in open(sys.argv[1]):
    if l.strip() and not l.startswith('#'):
        a, b = l.split()[:2]
        ren[a] = b
for f in glob.glob('src/c/**/*.c', recursive=True) + glob.glob('src/engine/**/*.c', recursive=True) + glob.glob('src/front/**/*.c', recursive=True) + glob.glob('src/pc/**/*.c', recursive=True):
    s = os.path.basename(f)[:-2]
    if s in ren:
        subprocess.run(['git', 'mv', f, os.path.join(os.path.dirname(f), ren[s] + '.c')], check=True)
inc = re.compile(r'%include "c/([\w/]+)/(\w+)(?:\.(\w+))?\.inc"')
def fix(m):
    # a stem or function part that already names an existing C file / the renamed function stays (chains such as
    # a -> a_ccx, b -> a, where rename_symbol.py already wrote the new name)
    d, s, b = m.group(1), m.group(2), m.group(3)
    if not os.path.isfile('src/c/%s/%s.c' % (d, s)) and not os.path.isfile('src/%s/%s.c' % (d, s)):
        s = ren.get(s, s)
    if b and b not in ren.values():
        b = ren.get(b, b)
    return '%%include "c/%s/%s%s.inc"' % (d, s, '.' + b if b else '')
for f in glob.glob('src/cseg01/**/*.asm', recursive=True) + glob.glob('src/engine/**/*.asm', recursive=True) + glob.glob('src/front/**/*.asm', recursive=True) + glob.glob('src/pc/**/*.asm', recursive=True) + glob.glob('src/lib/**/*.asm', recursive=True):
    t = open(f, newline='').read()
    n = inc.sub(fix, t)
    if n != t:
        open(f, 'w', newline='').write(n)
p = 'tools/match/c_functions.csv'
L = open(p, newline='').read().split('\n')
for i, l in enumerate(L):
    c = l.split(',')
    if len(c) > 4:
        c[0] = ren.get(c[0], c[0])
        if c[4].endswith('.c'):
            st = os.path.basename(c[4])[:-2]
            if st in ren:
                c[4] = c[4][:-len(st) - 2] + ren[st] + '.c'
        L[i] = ','.join(c)
open(p, 'w', newline='').write('\n'.join(L))
