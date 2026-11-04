#!/usr/bin/env python3
"""permute_replay.py - replay a tools/match/permute.py transform chain and write the result.

  python3 tools/match/permute_replay.py src/{engine,front,pc}/<mod>/<File>.c FUNC "desc > desc + desc > ..." OUT.c

The chain is the transform column of tools/match/permute_log.csv or a summary line (steps joined by ' > ', two
transforms of one step by ' + '). Each step must be one of the current text's candidates."""
import os, sys
HERE = os.path.dirname(os.path.abspath(__file__))
_td = HERE
while os.path.basename(_td) != 'tools' and _td != os.path.dirname(_td):
    _td = os.path.dirname(_td)
if _td not in sys.path:
    sys.path.insert(0, _td)
import paths
import permute


def main():
    if len(sys.argv) < 5: raise SystemExit(__doc__)
    f, func, chain, out = sys.argv[1:5]
    t = open(f).read()
    for step in chain.split(' > '):
        for part in step.split(' + '):
            nb = dict(permute.neighbours(t, func))
            if part.strip() not in nb: raise SystemExit('step %r not found' % part)
            t = nb[part.strip()]
    open(out, 'w').write(t)
    print('written', out)


if __name__ == '__main__':
    main()
