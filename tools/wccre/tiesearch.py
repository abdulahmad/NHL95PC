#!/usr/bin/env python3
"""tiesearch.py - search natural source edits toward the register tie order a draft needs.

  python3 tools/wccre/tiesearch.py src/c/<seg>/<File>.c FUNC [--minutes 60] [--seed N] [--write-match]

tieorder.py finds the order of tied conflicts that gives the EXE bytes (its result, cached in build/tieorder/).
Reaching it usually takes two or three source edits, and each one alone rarely changes the byte score, so
permute.py walks a flat landscape. This search scores every candidate by how many of the needed swaps its real
allocator order satisfies (in the emulated compiler, as irdump.py reads it), then by the byte score, so it can
chain edits that move the right temporaries before the bytes change.

* The target: tieorder's forced order for FUNC (run tieorder first). Each pair of conflicts that order puts the
  other way round from the baseline, one of them a conflict whose register the order changes, is a needed swap. A code generator temporary is identified across edits by
  its defining instruction (source line, opcode, operands with temporaries masked), a variable by its name.
* The edits: permute.py's natural transforms only (declaration order and scope, statement order, operand order,
  comparison form, ++/--, chains, ?:, if order, loop form, compound assignment, shift statements, one-use
  temporaries inlined). Never a new copy, a cast, or a signature change (AGENTS.md).
* The climb: from the best text, every neighbour is compiled (one emulator compile each) and scored as
  (byte match first, differences that are not register-only, unsatisfied swaps, differing instructions), so an
  edit may not add a real code difference while it moves the temporaries; the best improvement is taken, with sideways
  moves on ties of the score, until a byte match, --minutes, or no move improves.

A byte match is confirmed with a fresh DOSBox compile (permute.confirm). --write-match writes it back to the C
file; otherwise the best text goes to build/tiesearch/. Every candidate is logged to build/tiesearch/FUNC.csv."""
import argparse, csv, json, hashlib, os, random, re, sys, tempfile, time
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, HERE); sys.path.insert(0, os.path.join(ROOT, 'tools'))
import irdump, emucc, cc, permute

NATURAL = ['swapdecl', 'movedecl', 'scope', 'swapstmt', 'commute', 'cmpflip', 'incdec', 'zero', 'chain', 'ternary',
           'temp', 'ifswap', 'forchain', 'swap', 'opassign', 'shiftstmt', 'loop', 'lvinline', 'inplace', 'mulshift']
TEMP = re.compile(r'^t\d+$')


def compile_ir(src, func, obj):
    """(ok, {pass: [conflict signatures in allocation order]}) for one compile of src"""
    holder = {}

    def setup(emu): holder['d'] = irdump.IRDump(emu, func)
    ok, out, emu = emucc.compile_c(src, obj, cc.src_flags(src), setup=setup)
    d = holder.get('d')
    if not ok or not d or not d.dumps: return False, {}
    passes = {}
    for k, p, blocks in d.dumps:
        sig = {}
        line = 0
        for b in blocks:
            for r in b['rows']:
                if r['line']: line = r['line']
                if r['res'] and TEMP.match(r['res']) and r['res'] not in sig:
                    ops = ','.join('_' if (o and TEMP.match(o)) else (o or '-') for o in r['ops'])
                    sig[r['res']] = 'L%d %s %s' % (line, irdump.opname(r['op']), ops)
        passes[k] = [sig.get(c['label'], c['label']) if TEMP.match(c['label']) else c['label'] for c in p['confs']]
    return True, passes


def changed_labels(src, func, plan, work):
    """{pass: labels whose register differs between the baseline and the forced order} (tieorder's compiles)"""
    import tieorder
    ok, out, d0 = tieorder.compile_forced(src, func, {}, os.path.join(work, 'f0.obj'))
    ok, out, d1 = tieorder.compile_forced(src, func, plan, os.path.join(work, 'f1.obj'))
    p0, p1 = tieorder.func_passes(d0, func), tieorder.func_passes(d1, func)
    out = {}
    for k in range(min(len(p0), len(p1))):
        r0 = {c['label']: tieorder.given(p0[k], c) for c in p0[k]['confs']}
        r1 = {c['label']: tieorder.given(p1[k], c) for c in p1[k]['confs']}
        out[k] = set(l for l in r0 if r0[l] != r1.get(l))
    return out


def target_pairs(src, func, work):
    """the needed swaps as (signature a, signature b, pass): a must come before b. Only the pairs the forced
    order flips with a conflict whose register changes count: the other reorders of a run are harmless."""
    cache = os.path.join(ROOT, 'build', 'tieorder', '%s.%s.json' % (os.path.basename(src), func))
    if not os.path.exists(cache): raise SystemExit('run tools/wccre/tieorder.py %s %s first' % (src, func))
    c = json.load(open(cache))
    if c.get('sha1') != hashlib.sha1(open(src, 'rb').read()).hexdigest():
        raise SystemExit('%s changed since tieorder ran: run tieorder again' % src)
    if not c.get('best') or c['best'][0] != 0:
        print('note: tieorder found no tie order that gives the EXE bytes (best %s); searching toward its best' % c.get('best'))
    plan = {int(k): v for k, v in c['plan'].items()}
    ok, passes = compile_ir(src, func, os.path.join(work, 'base.obj'))
    labels = labels_of(src, func, work)
    changed = changed_labels(src, func, plan, work)
    pairs = []
    for k, order in plan.items():
        sigs = passes.get(k, []); labs = labels.get(k, [])
        if len(order) != len(sigs) or len(labs) != len(sigs): continue
        pos1 = {i: q for q, i in enumerate(order)}
        for x in range(len(sigs)):
            for y in range(len(sigs)):
                if x < y and pos1[y] < pos1[x] and sigs[x] != sigs[y] and (labs[x] in changed.get(k, ()) or labs[y] in changed.get(k, ())):
                    pairs.append((sigs[y], sigs[x], k))
    return pairs


def labels_of(src, func, work):
    """{pass: conflict labels in allocation order} of the baseline (the same compile as compile_ir's)"""
    holder = {}

    def setup(emu): holder['d'] = irdump.IRDump(emu, func)
    emucc.compile_c(src, os.path.join(work, 'lab.obj'), cc.src_flags(src), setup=setup)
    return {k: [c['label'] for c in p['confs']] for k, p, blocks in holder['d'].dumps}


def nonregister(cand, obj, func, src):
    """aligned differences that are not register-only (operands, sizes, branches, slots): an edit must not add
    any, the register ones are what the tie order fixes"""
    import cdiff, draft_causes
    c = cdiff.compare(cand, obj, func, asm_src=src)
    k = draft_causes.classify(c['ctexts'], c['otexts'])
    return sum(k.values()) - k.get('register', 0)


def unsatisfied(passes, pairs):
    n = 0
    for a, b, k in pairs:
        order = passes.get(k, [])
        if a not in order or b not in order or order.index(a) > order.index(b): n += 1
    return n


def main():
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('src'); ap.add_argument('func')
    ap.add_argument('--minutes', type=float, default=60); ap.add_argument('--seed', type=int, default=1)
    ap.add_argument('--write-match', action='store_true')
    a = ap.parse_args()
    os.chdir(ROOT)
    src, func = a.src, a.func
    work = tempfile.mkdtemp(prefix='tiesearch_')
    outdir = os.path.join(ROOT, 'build', 'tiesearch'); os.makedirs(outdir, exist_ok=True)
    pairs = target_pairs(src, func, work)
    if not pairs: raise SystemExit('no needed swaps: nothing to search for')
    print('%s %s: %d needed swap(s)' % (src, func, len(pairs)))
    for p_ in pairs[:8]: print('  %s  before  %s' % (p_[0], p_[1]))
    rnd = random.Random(a.seed)
    cand = os.path.join(work, os.path.basename(src))

    def evaluate(text):
        open(cand, 'w').write(text)
        obj = cand[:-2] + '.obj'
        ok, passes = compile_ir(cand, func, obj)
        if not ok: return None
        try:
            s = permute.score(cand, obj, func, src)
            nr = 0 if s[2] else nonregister(cand, obj, func, src)
        except (SystemExit, Exception): return None
        return (0 if s[2] else 1, nr, unsatisfied(passes, pairs), s[0], s[1]), s

    text = open(src).read()
    best = evaluate(text)
    if best is None: raise SystemExit('the draft does not compile')
    print('baseline: %d differing (%d not register-only), %d of %d swaps unsatisfied' % (best[1][0], best[0][1], best[0][2], len(pairs)))
    log = open(os.path.join(outdir, '%s.csv' % func), 'a', newline=''); w = csv.writer(log)
    t0 = time.time(); n = 0; seen = {permute.fsha(text, func)}; path = []
    while time.time() - t0 < a.minutes * 60 and best[0][0]:
        nb = [x for x in permute.neighbours(text, func, NATURAL) if permute.fsha(x[1], func) not in seen]
        rnd.shuffle(nb)
        if not nb: print('no unvisited neighbours'); break
        step = None; side = []
        for name, t in nb:
            if time.time() - t0 > a.minutes * 60: break
            seen.add(permute.fsha(t, func))
            r = evaluate(t); n += 1
            if r is None: continue
            w.writerow([time.strftime('%Y-%m-%d'), func, ' > '.join(path + [name]), r[1][0], r[0][1], r[0][2], r[1][2]]); log.flush()
            if r[0] < best[0] and (step is None or r[0] < step[1][0]): step = (name, r, t)
            elif r[0] == best[0]: side.append((name, r, t))
            if r[0][0] == 0: break
        if step:
            name, best, text = step[0], step[1], step[2]; path.append(name)
        elif side:
            name, r, text = rnd.choice(side); path.append(name + ' (sideways)')
        else:
            print('no move keeps or improves the score'); break
        print('  %4d candidates %4.0f s: %d differing (%d not register-only), %d swaps unsatisfied  [%s]' % (
            n, time.time() - t0, best[1][0], best[0][1], best[0][2], path[-1]), flush=True)
    out = os.path.join(outdir, os.path.basename(src))
    open(out, 'w').write(text)
    if best[0][0] == 0:
        fresh = os.path.join(work, 'fresh.obj')
        ok = cc.compile_c_raw(out, fresh, cc.src_flags(src)) and permute.score(out, fresh, func, src)[2]
        print('MATCH%s via %s' % ('' if ok else ' (not confirmed by a fresh DOSBox compile)', ' > '.join(path)))
        if ok and a.write_match:
            open(src, 'w').write(text); print('written to %s' % src)
    else:
        print('no match after %d candidates: best %d differing (%d not register-only), %d swaps unsatisfied, text in %s' % (
            n, best[1][0], best[0][1], best[0][2], os.path.relpath(out, ROOT)))


if __name__ == '__main__':
    main()
