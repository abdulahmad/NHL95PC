#!/usr/bin/env python3
"""permute_neighbours.py - list tools/permute.py's candidates for a function, with their line changes.

  python3 tools/permute_neighbours.py src/c/<seg>/<File>.c FUNC [T1,T2,...]

One line per candidate: the transform name, then the changed lines (- old || + new). The optional third argument
keeps only those transforms (as permute.py --only)."""
import os, sys, difflib
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import permute


def main():
    if len(sys.argv) < 3: raise SystemExit(__doc__)
    f, func = sys.argv[1], sys.argv[2]
    only = set(sys.argv[3].split(',')) if len(sys.argv) > 3 else None
    t = open(f).read()
    nb = permute.neighbours(t, func, only)
    for d, x in nb:
        dl = [l for l in difflib.unified_diff(t.split('\n'), x.split('\n'), lineterm='', n=0)
              if l[:1] in '+-' and l[:3] not in ('+++', '---')]
        print(d, '|', ' || '.join(z.strip()[:80] for z in dl))
    print(len(nb), 'neighbours')


if __name__ == '__main__':
    main()
