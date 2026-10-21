#!/usr/bin/env python3
"""scope_decls.py - try declaring a C function's locals in inner blocks and score each variant against the EXE.

  python3 tools/scope_decls.py src/c/<seg>/<File>.c FUNC [--names a,b,c] [--max N] [--jobs N] [--write]

Where a local is declared changes Watcom's register picks and frame slots even when the code does not change:
ModeSetEditLoop matched once `sfx` was declared in the block that uses it, DrawLineGroupBars once its four bar
locals were declared in the loop body. The tool takes the one-variable declarations at the top of FUNC's body (or
only the --names ones), finds the blocks that hold every use of each, keeps the moves where the first use in the
block assigns the variable (so the C keeps its meaning; check loops by hand all the same), scores every single move
and then every combination of the moves that helped (up to --max), compiling in parallel. Scores are the
differing lines of tools/cdiff.py (0 is a match). With --write the best variant is written back to the file."""
import os, re, sys, itertools, argparse, subprocess, tempfile
from concurrent.futures import ThreadPoolExecutor
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import cc

DECL = re.compile(r'^    ((?:unsigned |signed |const |register )*[A-Za-z_]\w*[\s\*]+)(\w+);\s*(/\*.*\*/)?\s*$')

def strip(l):
    l = re.sub(r'"(\\.|[^"])*"', '""', l)
    return re.sub(r'/\*.*?\*/', '', l)

def func_body(lines, func):
    for k, l in enumerate(lines):
        if re.match(r'^[A-Za-z_].*\b%s\s*\(' % re.escape(func), l) and not strip(l).rstrip().endswith(';'):
            j = k
            while j < len(lines) and lines[j].strip() != '{': j += 1
            depth = 0
            for e in range(j, len(lines)):
                depth += strip(lines[e]).count('{') - strip(lines[e]).count('}')
                if depth == 0: return j, e
    raise SystemExit('%s: no definition found' % func)

def block_stacks(lines, a, b):
    stack, out = [], {}
    for i in range(a + 1, b):
        out[i] = list(stack)
        for ch in strip(lines[i]):
            if ch == '{': stack.append(i)
            elif ch == '}' and stack: stack.pop()
    return out

def top_decls(lines, a, b):
    decls, k = [], a + 1
    while k < b:
        l = lines[k]
        m = DECL.match(l)
        if m and 'static' not in l:
            decls.append((k, m.group(2))); k += 1; continue
        s = l.strip()
        if s == '' or s.startswith('/*') or s.startswith('struct') or s.startswith('}') or l.startswith('        '):
            k += 1; continue
        break
    return decls, k

def moves(text, func, names=None):
    """{name: [block line, ...]} for the movable top declarations, innermost block first"""
    lines = text.split('\n')
    a, b = func_body(lines, func)
    decls, start = top_decls(lines, a, b)
    st = block_stacks(lines, a, b)
    out = {}
    for dl, name in decls:
        if names and name not in names: continue
        pat = re.compile(r'\b%s\b' % re.escape(name))
        uses = [i for i in range(start, b) if pat.search(strip(lines[i]))]
        if not uses: continue
        common = None
        for u in uses:
            s = st.get(u, [])
            common = s if common is None else [x for x, y in zip(common, s) if x == y]
        cands = []
        for blk in reversed(common or []):
            if blk in uses: continue                          # used in the block's own header line
            inner = [u for u in uses if u > blk]
            if not re.search(r'\b%s\s*=[^=]' % re.escape(name), strip(lines[min(inner)])): continue
            cands.append(blk)
        if cands: out[name] = cands
    return out

def apply(text, func, plan):
    """plan: [(name, level)] -> text with each name declared in its chosen block (level 0 = innermost)"""
    for name, level in plan:
        lines = text.split('\n')
        mv = moves(text, func, [name])
        if name not in mv or level >= len(mv[name]): return None
        blk = mv[name][level]
        a, b = func_body(lines, func)
        decls, _ = top_decls(lines, a, b)
        dl = [k for k, n in decls if n == name][0]
        nxt = lines[blk + 1]
        indent = len(nxt) - len(nxt.lstrip()) if nxt.strip() else 8
        decl = ' ' * indent + lines[dl].strip()
        # join an existing run of declarations at the top of the block, else start one with a blank line after
        if DECL.match('    ' + nxt.strip()) and len(nxt) - len(nxt.lstrip()) == indent:
            new = lines[:blk + 1] + [decl] + lines[blk + 1:]
        else:
            new = lines[:blk + 1] + [decl, ''] + lines[blk + 1:]
        del new[dl]
        text = '\n'.join(new)
    return text

def score_many(src, func, texts, jobs):
    """[(n, info)] per text: every text is written next to src, all of them are compiled together (batched DOSBox
    runs, cc.compile_parallel), then each is scored by tools/cdiff.py on its object"""
    d = os.path.dirname(os.path.abspath(src)); tmps = []
    try:
        for t in texts:
            fd, tmp = tempfile.mkstemp(prefix='zz_scope_', suffix='.c', dir=d); os.close(fd)
            open(tmp, 'w').write(t); tmps.append(tmp)
        items = [(t, t[:-2] + '.obj', '') for t in tmps]
        oks = cc.compile_parallel(items, jobs)

        def one(k):
            if not oks[k]: return None, 'compile failed'
            r = subprocess.run([sys.executable, os.path.join(HERE, 'cdiff.py'), tmps[k], '--func', func, '--all',
                                '--obj', items[k][1]], capture_output=True, text=True, cwd=ROOT)
            lines = r.stdout.split('\n')
            head = [l for l in lines if l.startswith(func + ' ')]
            if not head: return None, (r.stdout + r.stderr).strip().split('\n')[-1][:100]
            return sum(1 for l in lines if l[:1] in '!~'), head[0].split(':', 1)[1].strip()
        with ThreadPoolExecutor(jobs) as ex: return list(ex.map(one, range(len(tmps))))
    finally:
        for t in tmps:
            for x in (t, t[:-2] + '.obj'):
                if os.path.exists(x): os.remove(x)

def run_plans(src, func, text, plans, jobs):
    """[(plan, n, info)]: each plan applied to text and scored (plans that do not apply score None)"""
    out, todo = [], []
    for p in plans:
        t = apply(text, func, p) if p else text
        if t is None: out.append((p, None, 'not applicable'))
        else: todo.append((p, t))
    for (p, t), (n, info) in zip(todo, score_many(src, func, [t for p, t in todo], jobs)): out.append((p, n, info))
    return out

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('src'); ap.add_argument('func')
    ap.add_argument('--names'); ap.add_argument('--max', type=int, default=256)
    ap.add_argument('--jobs', type=int, default=8); ap.add_argument('--write', action='store_true')
    a = ap.parse_args()
    text = open(a.src).read()
    names = a.names.split(',') if a.names else None
    mv = moves(text, a.func, names)
    if not mv: raise SystemExit('no local can move into an inner block')
    singles = [[(n, lv)] for n in mv for lv in range(len(mv[n]))]
    if True:
        base = run_plans(a.src, a.func, text, [[]], a.jobs)[0]
        print('as written: %s (%s)' % (base[1], base[2]))
        res = run_plans(a.src, a.func, text, singles, a.jobs)
        for plan, n, info in res:
            print('  %-30s %s (%s)' % (' '.join('%s@%d' % p for p in plan), n, info))
        good = {}
        for plan, n, info in res:
            if n is not None and base[1] is not None and n < base[1]:
                name, lv = plan[0]
                if name not in good or n < good[name][1]: good[name] = (lv, n)
        combos = []
        for k in range(2, len(good) + 1):
            for c in itertools.combinations(sorted(good), k):
                combos.append([(n, good[n][0]) for n in c])
        combos = combos[:a.max]
        res2 = run_plans(a.src, a.func, text, combos, a.jobs) if combos else []
        for plan, n, info in res2:
            print('  %-30s %s (%s)' % (' '.join('%s@%d' % p for p in plan), n, info))
    allres = [r for r in res + res2 if r[1] is not None]
    if not allres: return
    best = min(allres, key=lambda r: r[1])
    print('best: %s -> %s (%s)' % (' '.join('%s@%d' % p for p in best[0]), best[1], best[2]))
    if a.write and base[1] is not None and best[1] < base[1]:
        open(a.src, 'w').write(apply(text, a.func, best[0]))
        print('written')

if __name__ == '__main__':
    main()
