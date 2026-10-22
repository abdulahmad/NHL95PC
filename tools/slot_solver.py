#!/usr/bin/env python3
"""slot_solver.py - put a draft's spilled locals in the EXE's stack slots by solving their declaration order.

  python3 tools/slot_solver.py src/c/<seg>/<File>.c FUNC [--rounds 12] [--jobs 8] [--write]

1. Reads the spill offsets: the draft is compiled with -d1 (line numbers only; the code is the same) and aligned
   with the EXE (tools/classify_diff.py's alignment). Every aligned pair whose instructions differ only in an
   [esp/ebp + n] slot is a slot mismatch; a store to a slot on a source line that assigns one local names that
   local, so each local gets its compiled slot and the EXE's slot at the same place (same push depth on both
   sides).
2. Solves the order: starting from the file, it tries the declaration orders that sort the misplaced locals by
   their EXE slot (both directions), every move and swap of a misplaced local's declaration, moving one into the
   block that uses it (tools/scope_decls.py), and swapping two adjacent independent statements that assign one
   (Watcom tends to lay the slots out in the order of first assignment). It climbs on (permute.py score, size,
   slot mismatches) with parallel compiles, for --rounds rounds or until nothing improves.
3. Prints the locals' slots before and after; --write writes the best text back when it lowers the permute.py
   score (confirmed with a fresh compile). A local whose slot no order fixes is a hint for a source difference
   (its scope, its first assignment, or a missing / extra local)."""
import argparse, difflib, itertools, os, re, sys, tempfile, shutil, collections
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import cc, cobj, cdiff, permute, classify_diff

STK = re.compile(r'\[(esp|ebp)(?: ([-+]) (0x[0-9a-f]+|\d+))?\]')


def linnum(obj):
    """[(text offset, line)] from the object's 32-bit LINNUM records, sorted"""
    b = open(obj, 'rb').read(); i = 0; out = []
    while i + 3 <= len(b):
        t = b[i]; n = int.from_bytes(b[i + 1:i + 3], 'little'); body = b[i + 3:i + 3 + n - 1]
        if t in (0x94, 0x95):
            p = 0
            _, p = cobj._idx(body, p); _, p = cobj._idx(body, p)
            w = 4 if t == 0x95 else 2
            while p + 2 + w <= len(body):
                out.append((int.from_bytes(body[p + 2:p + 2 + w], 'little'), int.from_bytes(body[p:p + 2], 'little')))
                p += 2 + w
        i += 3 + n
    return sorted(out)


def slot(t):
    """(base register, signed offset) of an instruction text's stack operand, or None"""
    m = STK.search(t.split('  ; ')[0])
    if not m: return None
    v = int(m.group(3), 0) if m.group(3) else 0
    return m.group(1), -v if m.group(2) == '-' else v


def analyse(cand, obj, func, src, lines):
    """(slot mismatches, permute score tuple, [(local, compiled slot, EXE slot)] from the stores)"""
    sc = permute.score(cand, obj, func, src)
    c = cdiff.compare(cand, obj, func, asm_src=src)
    C, O = c['ctexts'], c['otexts']
    c0 = cobj.parse(obj, None)['pubs'].get(func, 0)
    ln = linnum(obj)
    offs = [x[1] for x in c['rows']]
    def line_of(i):
        a = c0 + offs[i]; best = None
        for o, l in ln:
            if o <= a: best = l
            else: break
        return best
    sm = difflib.SequenceMatcher(None, [classify_diff.key(x) for x in C], [classify_diff.key(x) for x in O], autojunk=False)
    bad = 0; stores = []
    for tag, i1, i2, j1, j2 in sm.get_opcodes():
        n = min(i2 - i1, j2 - j1)
        for i, j in zip(range(i1, i1 + n), range(j1, j1 + n)):
            if classify_diff.kind(C[i], O[j]) == 'stack': bad += 1
            sc_, so = slot(C[i]), slot(O[j])
            if not sc_ or not so or not C[i].startswith('mov ') or not STK.search(C[i].split(',')[0]): continue
            l = line_of(i)
            if l is None or l > len(lines): continue
            w = [v for v in permute.writes(lines[l - 1]) if re.match(r'^[A-Za-z_]\w*$', v)]
            if len(w) == 1: stores.append((w[0], sc_[1], so[1]))
    return bad, sc, stores


def table(stores):
    """{local: (most common compiled slot, most common EXE slot at the same places, count)}"""
    by = collections.defaultdict(collections.Counter)
    for v, a, b in stores: by[v][(a, b)] += 1
    return {v: cnt.most_common(1)[0][0] + (sum(cnt.values()),) for v, cnt in by.items()}


def scalar_units(lines, b0, b1):
    return [u for u in permute.decl_units(lines, b0, b1) if u[0] == u[1] and '[' not in permute.strip(lines[u[0]])]


def reorder(lines, b0, b1, order):
    """the text with the scalar declarations in `order` (names), the other declarations in place"""
    us = scalar_units(lines, b0, b1)
    byname = {u[2]: lines[u[0]] for u in us}
    slots = [u[0] for u in us]
    L = list(lines)
    for k, name in zip(slots, order): L[k] = byname[name]
    return '\n'.join(L)


def candidates(text, func, info):
    """(desc, text) moves from text for the misplaced locals in info {local: (cslot, eslot, n)}"""
    lines = text.split('\n'); b0, b1 = permute.body(lines, func)
    us = scalar_units(lines, b0, b1)
    names = [u[2] for u in us]
    bad = [v for v, (a, b, n) in info.items() if a != b and v in names]
    out = []
    if bad:
        want = sorted([v for v in names if v in info], key=lambda v: info[v][1])
        for rev, d in ((False, 'up'), (True, 'down')):
            w = list(reversed(want)) if rev else want
            it = iter(w)
            order = [next(it) if v in info else v for v in names]
            out.append(('sort:%s' % d, reorder(lines, b0, b1, order)))
    if 1 < len(bad) <= 6:   # every order of the misplaced locals among their own declaration places
        pos = [i for i, v in enumerate(names) if v in bad]
        for p in itertools.permutations(bad):
            order = list(names)
            for i, v in zip(pos, p): order[i] = v
            out.append(('perm:%s' % ','.join(p), reorder(lines, b0, b1, order)))
    for v in bad:
        rest = [x for x in names if x != v]
        for j in range(len(rest) + 1):
            order = rest[:j] + [v] + rest[j:]
            if order != names: out.append(('move:%s:%d' % (v, j), reorder(lines, b0, b1, order)))
        for x in names:
            if x != v:
                order = [x if y == v else v if y == x else y for y in names]
                out.append(('swap:%s:%s' % (v, x), reorder(lines, b0, b1, order)))
    for d, t in permute.neighbours(text, func, {'scope', 'swapstmt'}):
        if d.startswith('scope:') and d.split(':')[1].split('@')[0] in bad: out.append((d, t))
        if d.startswith('swapstmt:'):
            k = b0 + int(d.split(':')[1])
            if (permute.writes(lines[k]) | permute.writes(lines[k + 1])) & set(bad): out.append((d, t))
    seen = set(); res = []
    for d, t in out:
        if t != text and t not in seen: seen.add(t); res.append((d, t))
    return res


def evaluate(src, func, texts, work, jobs, n0):
    items = []
    for k, t in enumerate(texts):
        f = os.path.join(work, 's%d_%s' % (n0 + k, os.path.basename(src))); open(f, 'w').write(t)
        items.append((f, f[:-2] + '.obj', '-d1'))
    oks = cc.compile_parallel(items, jobs)
    out = []
    for (f, o, _), ok, t in zip(items, oks, texts):
        r = None
        if ok:
            try: r = analyse(f, o, func, src, t.split('\n'))
            except (SystemExit, Exception): r = None
        out.append(r)
        for x in (f, o):
            if os.path.exists(x): os.remove(x)
    return out


def show(title, info):
    print(title)
    for v, (a, b, n) in sorted(info.items(), key=lambda x: x[1][1]):
        print('  %-12s compiled %5s  EXE %5s  %s(%d stores)' % (v, hex(a) if a >= 0 else '-' + hex(-a), hex(b) if b >= 0 else '-' + hex(-b),
                                                             'ok ' if a == b else '   ', n))


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('src'); ap.add_argument('func')
    ap.add_argument('--rounds', type=int, default=12); ap.add_argument('--jobs', type=int, default=8)
    ap.add_argument('--write', action='store_true')
    a = ap.parse_args()
    src = os.path.relpath(os.path.abspath(a.src), ROOT); func = a.func
    os.chdir(ROOT)
    text0 = open(src).read()
    work = tempfile.mkdtemp(prefix='slots_')
    try:
        r0 = evaluate(src, func, [text0], work, 1, 0)[0]
        if r0 is None: raise SystemExit('%s: does not compile' % src)
        bad0, sc0, st0 = r0
        print('%s %s: %d slot mismatches, permute score %d (size %+d)' % (src, func, bad0, sc0[0], sc0[1]))
        show('locals stored to the stack (most common slot at the stores):', table(st0))
        best = (sc0[0], sc0[1], bad0); best_text, best_info, best_desc = text0, table(st0), 'base'
        cur_text, cur_info, cur_desc = text0, best_info, ''
        seen = {text0}; n = 1
        for rnd in range(a.rounds):
            cands = [(d, t) for d, t in candidates(cur_text, func, cur_info) if t not in seen]
            if not cands: break
            for _, t in cands: seen.add(t)
            res = evaluate(src, func, [t for _, t in cands], work, a.jobs, n); n += len(cands)
            improved = False
            for (d, t), r in zip(cands, res):
                if r is None: continue
                k = (r[1][0], r[1][1], r[0])
                if k < best:
                    best, best_text, best_info, best_desc = k, t, table(r[2]), cur_desc + d
                    improved = True
            print('  round %d: %d candidates, score %d, %d slot mismatches  %s' % (rnd + 1, len(cands), best[0], best[2], best_desc[:100]))
            sys.stdout.flush()
            if not improved: break
            cur_text, cur_info, cur_desc = best_text, best_info, best_desc + ' > '
        if best_text != text0:
            show('after (%s):' % best_desc, best_info)
        print('%s %s: %d -> %d slot mismatches, score %d -> %d' % (src, func, bad0, best[2], sc0[0], best[0]))
        if a.write and best_text != text0 and (best[0], best[1]) < (sc0[0], sc0[1]):
            f = os.path.join(work, 'fresh_' + os.path.basename(src)); open(f, 'w').write(best_text)
            if cc.compile_c_raw(f, f[:-2] + '.obj', cc.src_flags(f)):
                r = permute.score(f, f[:-2] + '.obj', func, src)
                if (r[0], r[1]) < (sc0[0], sc0[1]):
                    open(src, 'w').write(best_text); print('written to %s (fresh compile: %d differing%s)' % (src, r[0], ', MATCH' if r[2] else ''))
    finally:
        shutil.rmtree(work, ignore_errors=True)


if __name__ == '__main__':
    main()
