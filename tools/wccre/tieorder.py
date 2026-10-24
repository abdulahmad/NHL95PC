#!/usr/bin/env python3
"""tieorder.py - which order of a function's tied register conflicts gives the EXE's code.

  python3 tools/wccre/tieorder.py src/c/<seg>/<File>.c FUNC [--minutes 15] [--pass N]

The register allocator (docs/WCC_INTERNALS.md) sorts every pass's conflicts by savings with an unstable Shell
sort, so conflicts with equal savings ("a tie run") come out in an order no source line states directly: it
depends on the whole list. A draft whose only problem is that order cannot be fixed by retyping the statements
the diff points at.

This tool compiles the file in the emulator (tools/wccre) and, at the point where AssignConflicts has the sorted
list (+569B4: the list head in eax, stored to +7E794 and walked by each node's next pointer at +0), relinks the
nodes of FUNC's passes in another order. Only members of one tie run change places, so every forced order is one
the unstable sort can produce for some input list. Each candidate is scored like tools/permute.py (differing
instructions, split pieces included). It hill-climbs over swaps within the runs (best improvement per round)
until the score stops improving or the time is up.

The report says:
  * the baseline score and the best forced score (0 means: a tie order exists that gives the EXE bytes; the
    source is otherwise right, and the fix is whatever natural change gives the allocator that order)
  * per changed run: the baseline order and the forced order (variable names, tN for code generator
    temporaries), and the register each conflict gets before and after
  * the instructions whose code changes (offsets in the function), to find the tN in the C source

A forced order is a target, not a source change: never commit a tie-breaker copy to reach it (AGENTS.md). Look
for a natural difference in the function (an expression the original split or joined, a statement order, a
declaration's scope or type) that changes the conflict list so the sort gives that order, and check it with
regdump.py. Nothing is written and nothing is marked."""
import argparse, os, struct, sys, tempfile, time
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, HERE); sys.path.insert(0, os.path.join(ROOT, 'tools'))
import regdump, regsolve, emucc, cc, permute
from unicorn import UC_HOOK_CODE
from unicorn import x86_const as X
from capstone import Cs, CS_ARCH_X86, CS_MODE_32

B = regdump.B
AFTER_SORT = 0x569B4


class Forcer(regsolve.Capture):
    """regsolve's capture (every pass, its function, pre-sort list, registers given); for FUNC's passes listed in
    plan ({occurrence: order of indices into the sorted list}) the sorted list is relinked in that order first."""

    def __init__(self, emu, func, plan):
        self.func, self.plan, self.occ, self.mismatch = func, plan, 0, []
        self.sig = {}
        regsolve.Capture.__init__(self, emu)

    def on_sorted(self, uc, addr, size, _):
        if self.proc_name() == self.func:
            k = self.occ; self.occ += 1
            head = self.emu.r(X.UC_X86_REG_EAX)
            nodes = []
            c = head
            while c and len(nodes) < 20000:
                nodes.append(c); c = self.u32(c)
            sav = tuple(self.u32(n + 0x14) for n in nodes)
            self.sig[k] = sav
            order = self.plan.get(k)
            if order is not None:
                if len(order) != len(nodes) or tuple(sav[i] for i in order) != sav:
                    self.mismatch.append(k)
                else:
                    new = [nodes[i] for i in order]
                    for a, b in zip(new, new[1:]):
                        self.uc.mem_write(a, struct.pack('<I', b))
                    self.uc.mem_write(new[-1], struct.pack('<I', 0))
                    self.uc.reg_write(X.UC_X86_REG_EAX, new[0])
        regsolve.Capture.on_sorted(self, uc, addr, size, _)


def compile_forced(src, func, plan, obj):
    holder = {}

    def setup(emu):
        holder['d'] = Forcer(emu, func, plan)   # regdump hooks on_sorted at +569B4 (AFTER_SORT)

    ok, out, emu = emucc.compile_c(src, obj, cc.src_flags(src), setup=setup)
    return ok, out, holder.get('d')


def func_passes(d, func):
    return [p for p in d.passes if p.get('func') == func]


def tie_runs(confs, minlen=2):
    """[(start, end)] of runs of equal nonzero savings in a sorted pass"""
    runs, i = [], 0
    while i < len(confs):
        j = i
        while j + 1 < len(confs) and confs[j + 1]['savings'] == confs[i]['savings']:
            j += 1
        if j - i + 1 >= minlen and confs[i]['savings']:
            runs.append((i, j + 1))
        i = j + 1
    return runs


def label(c):
    return c.get('label') or 'class%d' % c['cls']


def given(p, c):
    r = p['result'].get(c['conf'])
    return '-' if r is None else r if isinstance(r, str) else ('memory' if r == 0 else regdump.regname(r))


def is_temp(c):
    return not c.get('label') or (c['label'][0] == 't' and c['label'][1:].isdigit())


def edit_orders(p, runs, limit=4000):
    """the tie orders that one natural edit gives, from replaying the Shell sort on the edited pre-sort list:
    {order (indices into the sorted list): [edit, ...]}. Edits: a named variable at another place in creation
    order (a declaration or first use moved), a conflict dropped, one conflict added (savings of a tie run)."""
    import slotdump
    before = p.get('before')
    if not before: return {}
    sorted0 = [c['conf'] for c in p['confs']]
    idx = {c: i for i, c in enumerate(sorted0)}
    lab = {c['conf']: label(c) for c in before}

    def order_of(lst):
        got = [c['conf'] for c in slotdump.shell_sort(lst, regsolve.conf_before) if c['conf'] in idx]
        rank = {c: i for i, c in enumerate(got)}
        order = list(range(len(sorted0)))
        for s, e in runs:
            mem = sorted(range(s, e), key=lambda i: rank.get(sorted0[i], 10 ** 9 + i))
            if any(sorted0[i] not in rank for i in range(s, e)):     # a dropped member keeps its slot
                keep = [i for i in mem if sorted0[i] in rank]
                mem = []
                for i in range(s, e):
                    mem.append(i if sorted0[i] not in rank else keep.pop(0))
            order[s:e] = mem
        return tuple(order)

    base = tuple(range(len(sorted0)))
    out = {}
    def add(lst, what):
        o = order_of(lst)
        if o != base and len(out) < limit: out.setdefault(o, []).append(what)
    for q, c in enumerate(before):
        if is_temp(c): continue
        rest = before[:q] + before[q + 1:]
        for q2 in range(len(rest) + 1):
            if q2 == q: continue
            near = lab[rest[q2 - 1]['conf']] if q2 else '(newest)'
            add(rest[:q2] + [c] + rest[q2:], 'move %s to just older than %s' % (lab[c['conf']], near))
    for q, c in enumerate(before):
        add(before[:q] + before[q + 1:], 'without %s (savings %d)' % (lab[c['conf']], c['savings']))
    for s in sorted(set(p['confs'][s]['savings'] for s, e in runs)):
        for q in range(len(before) + 1):
            near = lab[before[q - 1]['conf']] if q else '(newest)'
            add(before[:q] + [dict(conf=-1, savings=s)] + before[q:],
                'one more conflict of savings %d, just older than %s' % (s, near))
    return out


def real_moves(src, func, names, work, base):
    """compile the C with one declaration of `names` moved to every other place in its block (declsearch.parse /
    rewrite: a reorder keeps the block's declaration places), all in one parallel batch; [(score, text of the move)]
    sorted best first. These are real compiles, so stack slots and everything else the move changes count."""
    import declsearch
    text = open(src).read()
    try: params, blocks = declsearch.parse(text, func)
    except Exception: return []

    class M: pass
    m = M(); m.blocks = [dict(units=[(f, l) for f, l, n in us], names=[n for f, l, n in us]) for _, us in blocks]
    cands = []
    for bi, b in enumerate(m.blocks):
        for nm in b['names']:
            if nm not in names: continue
            rest = [x for x in b['names'] if x != nm]
            for q in range(len(rest) + 1):
                order = rest[:q] + [nm] + rest[q:]
                if order == b['names']: continue
                orders = [bb['names'] for bb in m.blocks]; orders[bi] = order
                where = 'last' if q == len(rest) else 'before %s' % rest[q]
                cands.append(('declare %s %s' % (nm, where), declsearch.rewrite(text, m, orders)))
    if not cands: return []
    items = []
    for k, (what, txt) in enumerate(cands):
        f = os.path.join(work, 'mv%03d_%s' % (k, os.path.basename(src)))
        open(f, 'w').write(txt); items.append((f, f[:-2] + '.obj', cc.src_flags(src)))
    oks = cc.compile_parallel(items, os.cpu_count() or 4)
    out = []
    for (what, _), (f, o, _), ok in zip(cands, items, oks):
        if not ok: continue
        try: out.append((permute.score(f, o, func, src), what))
        except (SystemExit, Exception): pass
    out.sort(key=lambda x: permute.key(x[0]))
    return out


def explain(p, order, runs, show=12):
    """which single change to the pre-sort list makes the Shell sort produce the needed order: one more conflict
    (savings s) created at a point of the function, or one conflict fewer. The pre-sort list is newest first (each
    conflict is prepended when created), so a position is a point in creation order, between two conflicts that
    name it. Replayed with slotdump.shell_sort, as regsolve.py validates against the compiler."""
    import slotdump
    before = p.get('before')
    if not before:
        print('  (no pre-sort list captured)'); return
    sorted0 = [c['conf'] for c in p['confs']]
    need = [sorted0[i] for i in order]
    pos0 = {c: i for i, c in enumerate(sorted0)}; pos1 = {c: i for i, c in enumerate(need)}
    # the pairs the forced order flips: only these decide the registers that change
    flips = [(a, b) for a in need for b in need if pos1[a] < pos1[b] and pos0[a] > pos0[b]]
    others = [[sorted0[i] for i in range(s, e)] for s, e in runs if order[s:e] == list(range(s, e))]

    def check(lst):
        got = [c['conf'] for c in slotdump.shell_sort(lst, regsolve.conf_before)]
        at = {c: i for i, c in enumerate(got)}
        if any(a not in at or b not in at or at[a] > at[b] for a, b in flips): return None
        moved = sum(1 for o in others if [x for x in got if x in set(o)] != o)
        return moved

    lab = {c['conf']: label(c) for c in before}
    hits = []
    for s in sorted(set(c['savings'] for c in before)):
        for q in range(len(before) + 1):
            dummy = dict(conf=-1, savings=s, label='new')
            r = check(before[:q] + [dummy] + before[q:])
            if r is not None: hits.append((r, 'add', s, q))
    for q in range(len(before)):
        r = check(before[:q] + before[q + 1:])
        if r is not None: hits.append((r, 'drop', before[q]['savings'], q))
    # a named variable at another place in the list (its declaration moved): positions as list indices
    for q, c in enumerate(before):
        if not c.get('label') or (c['label'][0] == 't' and c['label'][1:].isdigit()): continue
        rest = before[:q] + before[q + 1:]
        ok = [q2 for q2 in range(len(rest) + 1) if q2 != q and check(rest[:q2] + [c] + rest[q2:]) is not None]
        if ok: hits.append((0, 'move', c['savings'], (q, ok)))
    if not hits:
        print('  no single added or dropped conflict gives this order (needs two or more changes)'); return
    print('  single changes that give the needed order (other tie runs left in order first):')
    hits.sort(key=lambda h: (h[1] != 'move', h[0], h[1] != 'drop', -h[2]))
    for moved, kind, s, q in hits[:show]:
        if kind == 'move':
            q, ok = q
            rest = [x for x in before if x is not before[q]]
            where = ', '.join('just older than %s' % (lab[rest[q2 - 1]['conf']] if q2 else '(newest)') for q2 in ok[:4])
            print('    %s at another place in creation order (now %s): %s%s' % (
                lab[before[q]['conf']], 'just older than %s' % lab[before[q - 1]['conf']] if q else 'newest', where,
                ' ... (%d places)' % len(ok) if len(ok) > 4 else ''))
            continue
        newer = lab.get(before[q - 1]['conf']) if q > 0 else '(start)'
        if kind == 'drop':
            what = 'without %s (savings %d)' % (lab[before[q]['conf']], s)
        else:
            older = lab.get(before[q]['conf']) if q < len(before) else '(end)'
            what = 'one more conflict of savings %d, created after %s and before %s' % (s, older, newer)
        print('    %s%s' % (what, '' if not moved else '  [%d other run(s) reorder]' % moved))
    if len(hits) > show: print('    ... %d more' % (len(hits) - show))


def main():
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('src'); ap.add_argument('func')
    ap.add_argument('--minutes', type=float, default=15); ap.add_argument('--pass', dest='only', type=int)
    ap.add_argument('--max-run', type=int, default=24, help='skip tie runs longer than this')
    a = ap.parse_args()
    os.chdir(ROOT)
    src, func = a.src, a.func
    work = tempfile.mkdtemp(prefix='tieorder_')
    obj0 = os.path.join(work, 'base.obj')
    ok, out, d0 = compile_forced(src, func, {}, obj0)
    if not ok: raise SystemExit(out)
    passes0 = func_passes(d0, func)
    if not passes0: raise SystemExit('%s: no allocation pass named %s' % (src, func))
    base = permute.score(src, obj0, func, src)
    print('%s %s: baseline %d differing (size %+d), %d allocation pass(es)' % (src, func, base[0], base[1], len(passes0)))
    runs = {}
    for k, p in enumerate(passes0):
        if a.only is not None and k != a.only: continue
        rr = [r for r in tie_runs(p['confs']) if r[1] - r[0] <= a.max_run]
        if rr: runs[k] = rr
        print('  pass %d: %d conflicts, tie runs %s' % (k, len(p['confs']), ', '.join(
            '%d x savings %d' % (e - s, p['confs'][s]['savings']) for s, e in rr) or 'none'))
    if not runs: raise SystemExit('no tie runs: the registers are decided by savings, not by the sort')

    plan = {k: list(range(len(passes0[k]['confs']))) for k in runs}
    best = base; best_plan = {k: v[:] for k, v in plan.items()}
    t0 = time.time(); n = 0
    import json, hashlib
    cached = False
    cache = os.path.join(ROOT, 'build', 'tieorder', '%s.%s.json' % (os.path.basename(src), func))
    h = hashlib.sha1(open(src, 'rb').read()).hexdigest()
    if os.path.exists(cache):
        c = json.load(open(cache))
        if c.get('sha1') == h:
            best = tuple(c['best']); best_plan = {int(k): v for k, v in c['plan'].items()}
            print('  (search result cached in %s)' % os.path.relpath(cache, ROOT))
            cached = True
    seen = set()

    def score_plan(pl):
        key = tuple((k, tuple(v)) for k, v in sorted(pl.items()))
        if key in seen: return None
        seen.add(key)
        obj = os.path.join(work, 'c.obj')
        ok, out, d = compile_forced(src, func, pl, obj)
        if not ok or d.mismatch: return None
        try: return permute.score(src, obj, func, src)
        except (SystemExit, Exception): return None

    edits = {}
    if not cached:
        # stage 1: the orders single natural edits give (replayed), each forced and scored
        for k, rr in runs.items():
            for o, what in edit_orders(passes0[k], rr).items():
                edits[(k, o)] = what
        print('  %d distinct orders from single edits' % len(edits), flush=True)
        scored = []
        for (k, o), what in edits.items():
            if time.time() - t0 > a.minutes * 60: break
            pl = {kk: v[:] for kk, v in plan.items()}; pl[k] = list(o)
            r = score_plan(pl); n += 1
            if r is None: continue
            scored.append((permute.key(r), r, k, o, what))
            if permute.key(r) < permute.key(best): best, best_plan = r, pl
            if r[0] == 0: break
        scored.sort(key=lambda x: x[0])
        for key_, r, k, o, what in scored[:8]:
            if r[0] >= base[0]: break
            print('  %3d differing: %s%s' % (r[0], what[0], ' (and %d more edits)' % (len(what) - 1) if len(what) > 1 else ''))
        print('  stage 1: %d -> %d differing (%d orders, %.0f s)' % (base[0], best[0], n, time.time() - t0), flush=True)
        # the declaration moves among the best edits, compiled for real
        top = [w for key_, r, k, o, what in scored if r[0] <= best[0] for w in what]
        names = set(w.split()[1] for w in top if w.startswith('move '))
        if names:
            real = real_moves(src, func, names, work, base)
            for r, what in real[:6]:
                print('  real compile %3d differing (size %+d): %s%s' % (r[0], r[1], what, '  <- MATCH' if r[2] else ''))
            if real and real[0][0][2]:
                print('result: %s gives the EXE bytes (a natural edit: check it, then mark)' % real[0][1])
    # stage 2: swaps within the runs from the best order (no single edit known for the result)
    improved = True
    while improved and not cached and time.time() - t0 < a.minutes * 60 and best[0] > 0:
        improved = False
        round_best = None
        for k, rr in runs.items():
            for s, e in rr:
                for i in range(s, e):
                    for j in range(i + 1, e):
                        if time.time() - t0 > a.minutes * 60: break
                        pl = {kk: v[:] for kk, v in best_plan.items()}
                        pl[k][i], pl[k][j] = pl[k][j], pl[k][i]
                        r = score_plan(pl); n += 1
                        if r is None: continue
                        if permute.key(r) < permute.key(best) and (round_best is None or permute.key(r) < permute.key(round_best[0])):
                            round_best = (r, pl)
                            if r[0] == 0: break
        if round_best:
            best, best_plan = round_best; improved = True
            print('  %4d candidates, %4.0f s: best %d differing (size %+d)' % (n, time.time() - t0, best[0], best[1]), flush=True)
    os.makedirs(os.path.dirname(cache), exist_ok=True)
    json.dump(dict(sha1=h, best=list(best), plan={str(k): v for k, v in best_plan.items()}), open(cache, 'w'))
    print('result: %d -> %d differing after %d forced orders in %.0f s%s' % (
        base[0], best[0], n, time.time() - t0, ' (a tie order gives the EXE bytes)' if best[0] == 0 and best[2] else ''))
    if best_plan == {k: list(range(len(passes0[k]['confs']))) for k in runs}:
        print('no tie order improves on the baseline: the remaining differences are not in a tie')
        return

    obj1 = os.path.join(work, 'best.obj')
    ok, out, d1 = compile_forced(src, func, best_plan, obj1)
    passes1 = func_passes(d1, func)
    for k, order in sorted(best_plan.items()):
        if order == list(range(len(order))): continue
        p0, p1 = passes0[k], passes1[k]
        print('pass %d:' % k)
        for s, e in runs[k]:
            if order[s:e] == list(range(s, e)): continue
            print('  run of %d at savings %d' % (e - s, p0['confs'][s]['savings']))
            print('    sorted   : %s' % ' '.join(label(p0['confs'][i]) for i in range(s, e)))
            print('    needed   : %s' % ' '.join(label(p0['confs'][i]) for i in order[s:e]))
            for i in range(s, e):
                c0 = p0['confs'][i]
                c1 = next((c for c in p1['confs'] if c['conf'] == c0['conf']), None)
                g0, g1 = given(p0, c0), (given(p1, c1) if c1 else '?')
                if g0 != g1: print('    %-12s %s -> %s' % (label(c0), g0, g1))
        explain(p0, order, runs[k])
    # the instructions that change
    import cobj
    def text(o):
        r = cobj.parse(o, set()); off = r['pubs'].get(func, 0)
        return {i.address: '%s %s' % (i.mnemonic, i.op_str) for i in Cs(CS_ARCH_X86, CS_MODE_32).disasm(r['text'][off:], 0)}
    t0_, t1_ = text(obj0), text(obj1)
    ch = [(o, t0_.get(o), t1_.get(o)) for o in sorted(set(t0_) | set(t1_)) if t0_.get(o) != t1_.get(o)]
    print('instructions that change (offset in %s, baseline -> forced): %d' % (func, len(ch)))
    for o, x, y in ch[:40]:
        print('  +%03X  %-36s %s' % (o, x or '', y or ''))


if __name__ == '__main__':
    main()
