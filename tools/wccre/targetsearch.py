#!/usr/bin/env python3
"""targetsearch.py - search natural source edits toward a draft's compiler targets (register ties and stack slots).

  python3 tools/wccre/targetsearch.py src/c/<seg>/<File>.c FUNC [--minutes 60] [--beam 3] [--seed N] [--write-match]

permute.py scores candidates by differing instructions alone, and those barely move until the last edit. This
search scores each candidate by the targets the compiler-side tools found, read from one emulator compile:

* register ties: the swaps tieorder.py's forced order needs (as tiesearch.py: pairs of conflicts, identified by
  their defining instruction), used when tieorder has a fresh result for FUNC (build/tieorder/);
* stack slots: the EXE's slot of every local and slotted parameter (read as declsearch.py / countsolve.py read
  them); a candidate scores the names it puts in their EXE slot.

Score, best first: byte match; differences that are neither register nor slot (an edit may not add real code
differences); unmet targets (swaps unsatisfied + names out of their EXE slot); differing instructions; size.
The edits are permute.py's natural transforms (tiesearch.NATURAL: declaration order and scope, statement and
operand order, comparison form, loop form, ...) and rewrites.py's expression rewrites (merge / split an
assignment, reassociate, reuse or recompute a value, swap aliases), which change the temporaries and use counts
the targets depend on; never a new copy, a cast or a signature change (AGENTS.md).
The search keeps the best --beam texts at each step and expands each of them, so it can cross a step that costs
a little before the targets move. A byte match is confirmed with a fresh DOSBox compile; --write-match writes it.
Every candidate is logged to build/targetsearch/FUNC.csv; the best text goes to build/targetsearch/."""
import argparse, csv, json, hashlib, os, random, re, sys, tempfile, time
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, HERE); sys.path.insert(0, os.path.join(ROOT, 'tools'))
import irdump, emucc, cc, permute, declsearch, countsolve, tiesearch, rewrites, slotdump as sd


def compile_both(src, func, obj):
    """one emulator compile -> (ok, {pass: [conflict signatures in allocation order]}, slotdump function or None)"""
    holder = {}

    def setup(emu):
        holder['d'] = irdump.IRDump(emu, func)
        holder['s'] = sd.SlotDump(emu)
    ok, out, emu = emucc.compile_c(src, obj, cc.src_flags(src), setup=setup)
    if not ok: return False, {}, None
    passes = {}
    d = holder.get('d')
    for k, p, blocks in (d.dumps if d else []):
        sig, line = {}, 0
        for b in blocks:
            for r in b['rows']:
                if r['line']: line = r['line']
                if r['res'] and tiesearch.TEMP.match(r['res']) and r['res'] not in sig:
                    ops = ','.join('_' if (o and tiesearch.TEMP.match(o)) else (o or '-') for o in r['ops'])
                    sig[r['res']] = 'L%d %s %s' % (line, irdump.opname(r['op']), ops)
        passes[k] = [sig.get(c['label'], c['label']) if tiesearch.TEMP.match(c['label']) else c['label']
                     for c in p['confs']]
    g = [f for f in holder['s'].funcs if f['name'] == func]
    return True, passes, (g[0] if g else None)


def slot_targets(src, func, work):
    """{name: EXE location} of the locals and slotted parameters, or {} when FUNC has no slots to read"""
    text = open(src).read()
    f0, sc0 = declsearch.confirm(src, func, text, work, 0)
    if f0 is None or not f0['pres']: return {}
    params, blocks = declsearch.parse(text, func)
    model = declsearch.Model(f0, params, blocks, False, True)
    mem = countsolve.slotted_names(model, params)
    want, bias, note = declsearch.exe_locations(src, func, f0, mem, text, work)
    return dict((v, w[0]) for v, w in want.items())


def tie_targets(src, func, work):
    """tiesearch's needed swaps when tieorder has a fresh result for FUNC, else []"""
    cache = os.path.join(ROOT, 'build', 'tieorder', '%s.%s.json' % (os.path.basename(src), func))
    if not os.path.exists(cache): return []
    c = json.load(open(cache))
    if c.get('sha1') != hashlib.sha1(open(src, 'rb').read()).hexdigest(): return []
    try:
        return tiesearch.target_pairs(src, func, work)
    except SystemExit:
        return []


def other_differences(cand, obj, func, src):
    """aligned differences that are neither register-only nor slot-only"""
    import cdiff, draft_causes
    c = cdiff.compare(cand, obj, func, asm_src=src)
    k = draft_causes.classify(c['ctexts'], c['otexts'])
    return sum(k.values()) - k.get('register', 0) - k.get('slot', 0)


def main():
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('src'); ap.add_argument('func')
    ap.add_argument('--minutes', type=float, default=60); ap.add_argument('--beam', type=int, default=3)
    ap.add_argument('--seed', type=int, default=1); ap.add_argument('--write-match', action='store_true')
    a = ap.parse_args()
    os.chdir(ROOT)
    src = os.path.relpath(os.path.abspath(a.src), ROOT); func = a.func
    work = tempfile.mkdtemp(prefix='targetsearch_')
    outdir = os.path.join(ROOT, 'build', 'targetsearch'); os.makedirs(outdir, exist_ok=True)
    pairs = tie_targets(src, func, work)
    W = slot_targets(src, func, work)
    print('%s %s: %d tie swap(s) (tieorder), %d slot target(s)' % (src, func, len(pairs), len(W)))
    for p_ in pairs[:6]: print('  tie: %s  before  %s' % (p_[0], p_[1]))
    if W: print('  slots: %s' % ', '.join('%s %d' % kv for kv in sorted(W.items(), key=lambda kv: -kv[1])))
    rnd = random.Random(a.seed)
    cand = os.path.join(work, os.path.basename(src))

    def evaluate(text):
        open(cand, 'w').write(text)
        obj = cand[:-2] + '.obj'
        ok, passes, g = compile_both(cand, func, obj)
        if not ok: return None
        try:
            s = permute.score(cand, obj, func, src)
            other = 0 if s[2] else other_differences(cand, obj, func, src)
        except (SystemExit, Exception):
            return None
        miss = tiesearch.unsatisfied(passes, pairs)
        if W:
            cl = countsolve.compiled_slots(g, W) if g else {}
            gone = set(W) - set(re.findall(r'[A-Za-z_]\w*', text))     # a name an edit removed is no target
            miss += sum(1 for v, w in W.items() if v not in gone and cl.get(v) != w)
        return (0 if s[2] else 1, other, miss, s[0], abs(s[1])), s

    text0 = open(src).read()
    r0 = evaluate(text0)
    if r0 is None: raise SystemExit('the draft does not compile')
    print('baseline: %d differing (%d neither register nor slot), %d target(s) unmet' % (r0[1][0], r0[0][1], r0[0][2]))
    log = open(os.path.join(outdir, '%s.csv' % func), 'a', newline=''); w = csv.writer(log)
    t0 = time.time(); n = 0
    seen = {permute.fsha(text0, func)}
    beam = [(r0[0], text0, [])]          # (key, text, path)
    best = beam[0]
    while time.time() - t0 < a.minutes * 60 and best[0][0]:
        pool = []
        for key, text, path in beam:
            nb = [x for x in permute.neighbours(text, func, tiesearch.NATURAL) + rewrites.neighbours(text, func)
                  if permute.fsha(x[1], func) not in seen]
            rnd.shuffle(nb)
            for name, t in nb:
                if time.time() - t0 > a.minutes * 60: break
                seen.add(permute.fsha(t, func))
                r = evaluate(t); n += 1
                if r is None: continue
                w.writerow([time.strftime('%Y-%m-%d'), func, ' > '.join(path + [name]), r[1][0], r[0][1], r[0][2], r[1][2]])
                log.flush()
                pool.append((r[0], t, path + [name]))
                if r[0][0] == 0: break
            if pool and min(pool)[0][0] == 0: break
        if not pool: print('no unvisited neighbours'); break
        pool.sort(key=lambda x: x[0])
        beam = pool[:a.beam]
        if beam[0][0] < best[0]: best = beam[0]
        print('  %5d candidates %5.0f s: best %d differing (%d other), %d unmet  [%s]' % (
            n, time.time() - t0, best[0][3], best[0][1], best[0][2], ' > '.join(best[2][-3:])), flush=True)
    out = os.path.join(outdir, os.path.basename(src))
    open(out, 'w').write(best[1])
    if best[0][0] == 0:
        fresh = os.path.join(work, 'fresh.obj')
        ok = cc.compile_c_raw(out, fresh, cc.src_flags(src)) and permute.score(out, fresh, func, src)[2]
        print('MATCH%s via %s' % ('' if ok else ' (not confirmed by a fresh DOSBox compile)', ' > '.join(best[2])))
        if ok and a.write_match:
            open(src, 'w').write(best[1]); print('written to %s' % src)
    else:
        print('no match after %d candidates: best %d differing (%d other), %d unmet, text in %s' % (
            n, best[0][3], best[0][1], best[0][2], os.path.relpath(out, ROOT)))


if __name__ == '__main__':
    main()
