#!/usr/bin/env python3
"""cverify.py - quick per-file check while matching: cdiff every marked function of the given C files (default: the
C files that differ from HEAD, new ones included) and print MATCH / DIFF per function.

  python3 tools/cverify.py [src/c/<seg>/<File>.c ...]

A function counts as marked when its asm block includes c/<seg>/<File>.inc or c/<seg>/<File>.<Func>.inc. This is
the inner loop; `make fullcheck` (both builds from scratch) is still the gate before every push."""
import os, re, subprocess, sys
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

def changed():
    out = subprocess.run(['git', 'status', '--porcelain', '--untracked-files=all', 'src/c'], cwd=ROOT,
                         capture_output=True, text=True).stdout
    return [l[3:] for l in out.splitlines() if l[3:].endswith('.c')]

def marked_funcs(src):
    seg, fname = src.split('/')[-2], os.path.splitext(os.path.basename(src))[0]
    asm = os.path.join(ROOT, 'src/cseg01', seg + '.asm')
    if not os.path.exists(asm): return []
    funcs = []
    for m in re.finditer(r'^%%include "c/%s/%s(?:\.(\w+))?\.inc"' % (re.escape(seg), re.escape(fname)), open(asm).read(), re.M):
        funcs.append(m.group(1) or fname)
    return funcs

def main():
    files = sys.argv[1:] or changed()
    bad = 0
    for f in files:
        funcs = marked_funcs(f)
        if not funcs: print('draft  %s (no marked function)' % f); continue
        for fn in funcs:
            r = subprocess.run([sys.executable, os.path.join(ROOT, 'tools/cdiff.py'), f, '--func', fn], cwd=ROOT,
                               capture_output=True, text=True)
            ok = r.stdout.strip().endswith('MATCH')
            bad += not ok
            print('%-6s %s %s' % ('MATCH' if ok else 'DIFF', f, fn))
    sys.exit(1 if bad else 0)

if __name__ == '__main__': main()
