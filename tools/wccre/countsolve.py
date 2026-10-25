#!/usr/bin/env python3
"""countsolve.py - which use counts give a draft's locals the EXE's stack slots.

  python3 tools/wccre/countsolve.py src/c/<seg>/<File>.c FUNC [--pairs 8] [--confirm 3]

The stack slots of the names in memory follow the use-count sort (descending loop-weighted reference count, ties
in an unstable order) and then the size sort (docs/WCC_INTERNALS.md, "Stack slots"). declsearch.py searches the
declaration orders, which only reorder ties; when no order works the counts are wrong: the original references a
variable more or less often, or inside more or fewer loops (TeamRosterScreen: one loop-weighted reference to n
fewer). This tool asks the question the other way round:

* The EXE's slot of every declared local in memory is read as declsearch.py reads it (a -d1 compile aligned with
  the EXE).
* The same for the parameters the slot hand-out places (FillDressedSlots' slot), not those homed by a push.
* For every local or parameter in memory with a conflict (a register candidate that was spilled: only those have a count), every
  count from 0 to twice its own (at least +20) is replayed without compiling, with declsearch's model of the sorts
  and the slot hand-out; then the pairs of the best single changes.
* The best few count sets are confirmed by compiling with those counts written into the conflicts before each
  use-count sort (slotdump.py's --count mechanism), so the slots come from the compiler itself.

It prints, per change, how many locals land in their EXE slot (model, then compiler), the counts that work as a
range, and each name's current count. A count is a hint, not an edit: reach it with a natural change in how
often, or at what loop depth, the source references the name (a reference in a loop counts the loop weight)."""
import argparse, os, sys, tempfile
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, HERE); sys.path.insert(0, os.path.join(ROOT, 'tools'))
import declsearch, slotdump as sd


def slotted_names(model, params):
    """{label: (location, size)} of the declared locals in memory and of the parameters the hand-out gives a slot
    (not those homed by a push at the prologue)"""
    out = dict(model.mem)
    for n in sd.handout(model.f, [s['after'] or [] for s in model.f['sizes']]):
        if n['named'] and n['label'] in params and model.slotted(n) and n['label'] not in out:
            out[n['label']] = (model.f['final'][n['addr']]['loc'], n['size'])
    return out


def counted(model, names):
    """{label: count} of those names with a conflict (the first use-count sort's input)"""
    out = {}
    for s in model.f['pres'][:1]:
        for n in s['before']:
            if n['named'] and n['conf'] and not n['tflags'] & 2 and n['label'] in names:
                out.setdefault(n['label'], n['count'])
    return out


def locations_with(model, counts):
    """the model's {label: location} with these counts in every use-count sort (the conflicts are rebuilt between
    two sorts, so the names are matched by label in each list)"""
    np_ = len(model.f['pres'])
    saved = []
    for li in range(np_):
        fl = model.fl[li]
        K = dict(fl['K'])
        for n in model.orig[li]:
            if n['conf'] and n['named'] and n['label'] in counts:
                u = model.U[n['addr']]
                K[u] = model.ukey(dict(n, count=counts[n['label']]), n['id'])
        saved.append(fl['K']); fl['K'] = K
    try:
        at = model.locations(model.base)[1]
        return dict((n['label'], at[n['addr']]) for L in model.orig for n in L
                    if n['named'] and not n['tflags'] & 2 and n['addr'] in at)
    finally:
        for li in range(np_): model.fl[li]['K'] = saved[li]


def compiled_slots(g, names):
    """{label: location} of those names in an emulator compile (slotdump's lists)"""
    out = {}
    for n in sd.handout(g, [s['after'] or [] for s in g['sizes']]):
        fin = g['final'].get(n['addr'])
        if n['named'] and not n['tflags'] & 2 and n['label'] in names and fin and fin['loc'] != sd.NO_LOCATION:
            out.setdefault(n['label'], fin['loc'])
    return out


def hits(locs, want):
    return sum(1 for v, w in want.items() if locs.get(v) == w)


def ranges(vals):
    """[3, 4, 5, 9] -> '3-5, 9'"""
    out, s = [], None
    for v in sorted(vals) + [None]:
        if s is None: s = p = v; continue
        if v is not None and v == p + 1: p = v; continue
        out.append('%d' % s if s == p else '%d-%d' % (s, p)); s = p = v
    return ', '.join(out)


def main():
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('src'); ap.add_argument('func')
    ap.add_argument('--pairs', type=int, default=8, help='best single changes combined in pairs (default 8)')
    ap.add_argument('--confirm', type=int, default=3, help='count sets confirmed by a compile (default 3)')
    a = ap.parse_args()
    src = os.path.relpath(os.path.abspath(a.src), ROOT); func = a.func
    os.chdir(ROOT)
    text0 = open(src).read()
    work = tempfile.mkdtemp(prefix='countsolve_')
    f0, sc0 = declsearch.confirm(src, func, text0, work, 0)
    if f0 is None: raise SystemExit('%s: no function %s in the emulator compile' % (src, func))
    if not f0['pres']: raise SystemExit('%s: no use-count sort (nothing in memory has a count)' % func)
    params, blocks = declsearch.parse(text0, func)
    model = declsearch.Model(f0, params, blocks, False, True)
    mem = slotted_names(model, params)
    want, bias, note = declsearch.exe_locations(src, func, f0, mem, text0, work)
    W = dict((v, w[0]) for v, w in want.items())
    cnt = counted(model, mem)
    base = locations_with(model, {})
    print('%s %s: %s' % (src, func, declsearch.fmt(sc0) if sc0 else 'does not compile'))
    if note: print('  note: ' + note)
    print('  local         size  count  compiled  EXE')
    for v in sorted(W, key=lambda v: -W[v]):
        print('  %-12s %5d %6s  %8d %5d%s%s' % (v, mem[v][1], cnt.get(v, '-'), mem[v][0], W[v],
                                               '  ok' if mem[v][0] == W[v] else '', '  (parameter)' if v in params else ''))
    h0 = hits(base, W)
    print('  model on the current counts: %d of %d in their EXE slot (compiled: %d)' % (
        h0, len(W), sum(1 for v in W if mem[v][0] == W[v])))
    if h0 == len(W): raise SystemExit('  every local is already in its EXE slot')
    if not cnt: raise SystemExit('  no local in memory has a conflict: only declaration order moves them (declsearch.py)')
    # single changes
    single = {}
    for v, c in cnt.items():
        for k in range(0, max(2 * c, c + 20) + 1):
            if k == c: continue
            single.setdefault(v, {})[k] = hits(locations_with(model, {v: k}), W)
    best1 = sorted(((h, v) for v in single for h in set(single[v].values()) if h > h0), reverse=True)
    print('single count changes that put more locals in their EXE slot:')
    if not best1: print('  none')
    shown = set()
    for h, v in best1:
        if v in shown: continue
        shown.add(v)
        ks = [k for k, x in single[v].items() if x == h]
        print('  %-12s count %d -> %s: %d of %d' % (v, cnt[v], ranges(ks), h, len(W)))
    # pairs of the best single changes (one representative count per name and score)
    reps = []
    for h, v in best1[:a.pairs]:
        ks = sorted(k for k, x in single[v].items() if x == h)
        reps.append((v, min(ks, key=lambda k: abs(k - cnt[v]))))
    pairs = []
    for i in range(len(reps)):
        for j in range(i + 1, len(reps)):
            (v1, k1), (v2, k2) = reps[i], reps[j]
            if v1 == v2: continue
            pairs.append((hits(locations_with(model, {v1: k1, v2: k2}), W), {v1: k1, v2: k2}))
    if not pairs:
        # no single change helps (a tie that needs two names moved): small steps of two names at once
        steps = [(v, cnt[v] + d) for v in cnt for d in (-10, -1, 1, 10) if cnt[v] + d >= 0]
        for i in range(len(steps)):
            for j in range(i + 1, len(steps)):
                (v1, k1), (v2, k2) = steps[i], steps[j]
                if v1 == v2: continue
                h = hits(locations_with(model, {v1: k1, v2: k2}), W)
                if h > h0: pairs.append((h, {v1: k1, v2: k2}))
    pairs.sort(key=lambda x: -x[0])
    if pairs and pairs[0][0] > (best1[0][0] if best1 else h0):
        print('pairs:')
        for h, cs in pairs[:5]:
            print('  %s: %d of %d' % (', '.join('%s %d -> %d' % (v, cnt[v], k) for v, k in cs.items()), h, len(W)))
    # confirm with the compiler
    cands = [(h, {v: k}) for (v, k), (h, _) in zip(reps, best1)] + pairs
    cands.sort(key=lambda x: -x[0])
    seen, done = set(), 0
    tmp = os.path.join(work, os.path.basename(src)); open(tmp, 'w').write(text0)
    for h, cs in cands:
        key = tuple(sorted(cs.items()))
        if key in seen: continue
        seen.add(key)
        if done == a.confirm: break
        done += 1
        g = [x for x in sd.compile_dump(tmp, {func: cs}) if x['name'] == func]
        cl = compiled_slots(g[0], mem) if g else {}
        print('compiled with %s: %d of %d in their EXE slot (model %d)%s' % (
            ', '.join('%s=%d' % kv for kv in cs.items()), hits(cl, W), len(W), h,
            ''.join('; %s %d (EXE %d)' % (v, cl.get(v, 0), w) for v, w in sorted(W.items()) if cl.get(v) != w)[:300]))


if __name__ == '__main__':
    main()
