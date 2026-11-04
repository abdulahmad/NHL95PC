#!/usr/bin/env python3
"""cverify.py - quick per-file check while matching: cdiff every marked function of the given C files (default: the
C files that differ from HEAD, new ones included) and print MATCH / DIFF per function.

  python3 tools/match/cverify.py [src/c/<module>/<File>.c ...]

A function counts as marked when its asm block includes c/<seg>/<File>.inc or c/<seg>/<File>.<Func>.inc. This is
the inner loop; `make fullcheck` (both builds from scratch) is still the gate before every push."""
import os, re, subprocess, sys
HERE = os.path.dirname(os.path.abspath(__file__))
_td = HERE
while os.path.basename(_td) != 'tools' and _td != os.path.dirname(_td):
    _td = os.path.dirname(_td)
if _td not in sys.path:
    sys.path.insert(0, _td)
import paths
ROOT = paths.ROOT
def changed():
    out = subprocess.run(['git', 'status', '--porcelain', '--untracked-files=all', 'src/c', 'src/engine', 'src/front', 'src/pc'], cwd=ROOT,
                         capture_output=True, text=True).stdout
    return [l[3:] for l in out.splitlines() if l[3:].endswith('.c')]

def marked_funcs(src):
    sys.path.insert(0, os.path.join(ROOT, 'tools'))
    import cc
    stem, fname, asm, inc = cc.c_paths(src)
    if not os.path.exists(asm): return []
    funcs = []
    for m in re.finditer(r'^%%include "c/%s/%s(?:\.(\w+))?\.inc"' % (re.escape(stem), re.escape(fname)), open(asm).read(), re.M):
        funcs.append(m.group(1) or fname)
    return funcs

def main():
    files = sys.argv[1:] or changed()
    bad = 0
    for f in files:
        funcs = marked_funcs(f)
        if not funcs: print('draft  %s (no marked function)' % f); continue
        for fn in funcs:
            r = subprocess.run([sys.executable, os.path.join(ROOT, 'tools/match/cdiff.py'), f, '--func', fn], cwd=ROOT,
                               capture_output=True, text=True)
            ok = r.stdout.strip().endswith('MATCH')
            bad += not ok
            print('%-6s %s %s' % ('MATCH' if ok else 'DIFF', f, fn))
    sys.exit(1 if bad else 0)

if __name__ == '__main__': main()
