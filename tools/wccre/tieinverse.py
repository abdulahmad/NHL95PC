#!/usr/bin/env python3
"""tieinverse.py - which changes to a function's conflict list would give a needed tie order (A before B).

  python3 tools/wccre/tieinverse.py src/c/<seg>/<File>.c FUNC A B [--pass N]

tieorder.py finds the order of tied conflicts that gives the EXE bytes and its minimal target ("A before B").
The order comes from the savings sort, an unstable Shell sort over the conflict list as it was built
(docs/WCC_INTERNALS.md: the list is built by the names walk and the live-information walk), so a source edit
moves A and B only by changing that list. This tool replays the sort in Python (slotdump.shell_sort; it checks
that the replay gives the compiler's own order) and reports, for the current draft, every single change of the
list that puts A before B:

  * dropping one conflict (a temporary the original did not have, a name used in fewer blocks)
  * adding one conflict at a place, with the savings values that work there (a temporary the original had)
  * moving one conflict (a temporary created earlier or later: another statement or operand order)

A and B are irdump.py labels of the current draft (tN, or a variable name). The answer says what the list must
look like, not which C edit gives it: the edit must also leave the instructions the same (only the registers of
the tie may move). Use it to choose the edits to try; targetsearch.py scores them."""
import argparse, os, re, subprocess, sys
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, HERE); sys.path.insert(0, os.path.join(ROOT, 'tools'))
from slotdump import shell_sort


def lists(src, func, pas):
    """(savings {label: value}, allocation order, list as built, {label: where created}) from irdump.py"""
    out = subprocess.run([sys.executable, os.path.join(HERE, 'irdump.py'), src, func, '--pass', str(pas)],
                         capture_output=True, text=True, cwd=ROOT).stdout.split('\n')
    i = [k for k, l in enumerate(out) if l.startswith('-- conflicts in allocation')]
    j = [k for k, l in enumerate(out) if l.startswith('-- conflict list as built')]
    if not i or not j: raise SystemExit('irdump.py printed no conflict list for %s pass %d' % (func, pas))
    sav, alloc = {}, []
    for l in out[i[0] + 1:j[0]]:
        m = re.match(r'\s+(\S+)\s+(\d+)', l)
        if m: sav[m.group(1)] = int(m.group(2)); alloc.append(m.group(1))
    items = re.findall(r'(\S+) (B\d+:L\d+|global)', out[j[0] + 1])
    return sav, alloc, [x for x, _ in items], dict(items)


def main():
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('src'); ap.add_argument('func'); ap.add_argument('a'); ap.add_argument('b')
    ap.add_argument('--pass', dest='pas', type=int, default=0)
    a = ap.parse_args()
    sav, alloc, built, where = lists(a.src, a.func, a.pas)
    for x in (a.a, a.b):
        if x not in sav: raise SystemExit('%s is not a conflict of pass %d (labels: %s)' % (x, a.pas, ' '.join(alloc)))
    key = lambda x, y: sav[x] > sav[y]
    if shell_sort(built, key) != alloc: raise SystemExit('the replay does not give the compiler order: not usable here')

    def ok(lst):
        o = shell_sort(lst, key)
        return o.index(a.a) < o.index(a.b)
    print('%s %s pass %d: replay matches the compiler; %s before %s now: %s' % (a.src, a.func, a.pas, a.a, a.b,
                                                                             'yes' if ok(built) else 'no'))
    drops = [x for x in built if x not in (a.a, a.b) and ok([y for y in built if y != x])]
    print('dropping one conflict works for %d: %s' % (len(drops), ', '.join('%s (%s, savings %d)' % (
        x, where[x], sav[x]) for x in drops) or 'none'))
    vals = sorted(set(sav.values())); spots = []
    for p in range(len(built) + 1):
        w = []
        for v in vals:
            sav['(new)'] = v
            if ok(built[:p] + ['(new)'] + built[p:]): w.append(v)
        del sav['(new)']
        if w:
            spots.append('just newer than %s: savings %s' % (
                '%s (%s)' % (built[p], where[built[p]]) if p < len(built) else 'the end',
                'any' if w == vals else ', '.join(map(str, w))))
    print('adding one conflict works at %d of %d places (list order, front = created last):' % (len(spots), len(built) + 1))
    for s in spots: print('  ' + s)
    moves = []
    for i in range(len(built)):
        for j in range(len(built) + 1):
            if j in (i, i + 1): continue
            L = built[:]; x = L.pop(i); L.insert(j if j < i else j - 1, x)
            if ok(L): moves.append('%s (%s) just newer than %s' % (x, where[x], '%s (%s)' % (
                built[j], where[built[j]]) if j < len(built) else 'the end'))
    print('moving one conflict works for %d moves%s' % (len(moves), ':' if moves else ''))
    for s in moves[:30]: print('  ' + s)
    if len(moves) > 30: print('  ... %d more' % (len(moves) - 30))


if __name__ == '__main__':
    main()
