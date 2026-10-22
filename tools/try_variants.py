#!/usr/bin/env python3
"""try_variants.py - score hand-written variants of a C file in one batch.

  python3 tools/try_variants.py src/c/<seg>/<File>.c FUNC VARFILE

VARFILE holds variants, each starting with a line '=== name', then OLD / '---' / NEW blocks (exact text
replacements; several per variant, separated by '+++' lines). All variants compile in one batch and each prints
the permute.py score (MATCH for a match, confirmed with a fresh compile)."""
import os, sys
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import cc, permute


def main():
    if len(sys.argv) < 4: raise SystemExit(__doc__)
    src, func, vf = sys.argv[1:4]
    os.chdir(ROOT)
    text = open(src).read()
    vs = []
    for chunk in open(vf).read().split('=== ')[1:]:
        name, body = chunk.split('\n', 1)
        t = text; ok = True
        for rep in body.split('+++\n'):
            if '---\n' not in rep: continue
            old, new = rep.split('---\n', 1)
            if t.count(old) != 1: print('%s: replacement not unique/found (%d)' % (name, t.count(old))); ok = False; break
            t = t.replace(old, new)
        if ok: vs.append((name.strip(), t))
    d = os.path.dirname(os.path.abspath(src))
    items = []
    for k, (name, t) in enumerate(vs):
        f = os.path.join(d, 'zz_var%d_%s' % (k, os.path.basename(src))); open(f, 'w').write(t)
        items.append((f, f[:-2] + '.obj', ''))
    try:
        oks = cc.compile_parallel(items, 8)
        for (name, t), (f, o, _), ok in zip(vs, items, oks):
            if not ok: print('%-30s compile failed' % name); continue
            s = permute.score(f, o, func, src)
            if s[2]: s = permute.confirm(f, o, func, src) or s[:2] + (False,) + s[3:]
            print('%-30s %4d differing, size %+d, first diff at +%X%s' % (name, s[0], s[1], s[3], '  MATCH' if s[2] else ''))
    finally:
        for f, o, _ in items:
            for x in (f, o):
                if os.path.exists(x): os.remove(x)


if __name__ == '__main__':
    main()
