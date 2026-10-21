#!/usr/bin/env python3
"""permute_decls.py - try the declaration orders of a C function's locals and score each one against the EXE.

  python3 tools/permute_decls.py src/c/<seg>/<File>.c FUNC [--addr HEX] [--names a,b,c] [--max N] [--jobs N]

Watcom picks registers and stack slots partly by the order the locals are declared in, so a draft that differs
from the EXE only in register picks or slot order can sometimes be matched by reordering its declarations
(MessageBox, SkaterStatsCard). The tool takes the run of declarations at the top of FUNC's body (one-line
declarations and whole `struct { ... } name;` blocks), or only the --names ones (the others keep their places),
compiles every order (or --max random ones) in parallel, and prints the orders with the fewest differing
instructions: a normalized diff of the compiled function against the original bytes (call / jump targets and
absolute addresses are ignored, so check a 0 with tools/cdiff.py). FUNC's address comes from its asm label
unless --addr is given. Nothing in src/ is written."""
import os, re, sys, random, difflib, argparse, itertools, tempfile, shutil
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import cc, cobj, cdiff
from capstone import Cs, CS_ARCH_X86, CS_MODE_32

DECL = re.compile(r'^    (?:unsigned |signed |struct \w+ |const )*[A-Za-z_]\w*[\s\*]+\(?\*?\s*(\w+)\)?(?:\[[^\]]*\])*'
                  r'(?:\([^)]*\))?;\s*(?:/\*.*\*/)?$')

def decl_units(lines, start):
    """the declaration units after the function's '{' at lines[start]: (first line, last line, names)"""
    units = []
    k = start + 1
    while k < len(lines):
        l = lines[k]
        if re.match(r'^    struct\s*(\w+\s*)?\{\s*$', l):
            j = k
            while j < len(lines) and not re.match(r'^    \}\s*(\w+)\s*;', lines[j]): j += 1
            if j == len(lines): break
            units.append((k, j, [re.match(r'^    \}\s*(\w+)', lines[j]).group(1)]))
            k = j + 1
            continue
        m = DECL.match(l)
        if not m or l.strip().startswith('return'): break
        names = re.findall(r'(\w+)\s*(?:\[[^\]]*\])*\s*(?:,|;)', l.split('=')[0]) or [m.group(1)]
        units.append((k, k, names))
        k += 1
    return units

def func_body(src_text, func):
    lines = src_text.split('\n')
    for k, l in enumerate(lines):
        # a prototype with a trailing comment (`short F(void);  /* addr */`) is not the definition
        if re.match(r'^[A-Za-z_].*\b%s\s*\(' % re.escape(func), l) and not re.sub(r'/\*.*?\*/', '', l).rstrip().endswith(';'):
            j = k
            while j < len(lines) and lines[j].strip() != '{': j += 1
            if j < len(lines): return lines, j
    raise SystemExit('%s: no definition found' % func)

def norm(i):
    x = i.mnemonic + ' ' + i.op_str
    if i.mnemonic.startswith('j') or i.mnemonic == 'call': x = i.mnemonic
    x = re.sub(r' \+ 0x[0-9a-f]{4,}\]', ']', x)
    x = re.sub(r'\[0x[0-9a-f]+\]|\[[0-9]\]', '[abs]', x)
    x = re.sub(r'^push (0x[0-9a-f]+|0)$', 'push N', x)
    x = re.sub(r', (0x[0-9a-f]{3,}|0|4)$', ', IMM', x)
    return x

def score(obj, func, orig_ins):
    o = cobj.parse(obj); t = o['text']
    if func not in o['pubs']: return None
    s = o['pubs'][func]; e = min([p for p in o['pubs'].values() if p > s] + [len(t)])
    c = [norm(i) for i in Cs(CS_ARCH_X86, CS_MODE_32).disasm(t[s:e], 0)]
    r = orig_ins[:len(c)]
    sm = difflib.SequenceMatcher(None, c, r, autojunk=False)
    same = sum(b.size for b in sm.get_matching_blocks())
    return (len(c) - same) + (len(r) - same), e - s

def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('src'); ap.add_argument('func')
    ap.add_argument('--addr'); ap.add_argument('--names')
    ap.add_argument('--max', type=int, default=720); ap.add_argument('--jobs', type=int, default=8)
    ap.add_argument('--seed', type=int, default=1); ap.add_argument('--top', type=int, default=8)
    a = ap.parse_args()
    text = open(a.src).read()
    lines, brace = func_body(text, a.func)
    units = decl_units(lines, brace)
    if a.names:
        want = set(a.names.split(','))
        movable = [u for u in units if set(u[2]) & want]
    else:
        movable = units
    if len(movable) < 2: raise SystemExit('fewer than two declarations to permute: %s' % [u[2] for u in units])
    addr = int(a.addr, 16) if a.addr else cdiff.func_addr(a.src, a.func)[1]
    orig = cdiff.original(addr, 0x4000)
    orig_ins = [norm(i) for i in Cs(CS_ARCH_X86, CS_MODE_32).disasm(orig, 0)]
    slots = [u for u in units if u in movable]
    texts = {id(u): lines[u[0]:u[1] + 1] for u in units}
    n = len(slots)
    import math
    if math.factorial(n) <= a.max:
        orders = list(itertools.permutations(range(n)))
    else:
        rnd = random.Random(a.seed); seen = set(); orders = [tuple(range(n))]
        seen.add(orders[0])
        while len(orders) < a.max:
            p = list(range(n)); rnd.shuffle(p); p = tuple(p)
            if p not in seen: seen.add(p); orders.append(p)
    work = tempfile.mkdtemp(prefix='perm_')
    first, last = units[0][0], units[-1][1]

    def build(order):
        placed = iter([slots[i] for i in order])
        out = []
        for u in units:
            out += texts[id(next(placed))] if u in movable else texts[id(u)]
        return '\n'.join(lines[:first] + out + lines[last + 1:])

    items = []
    for k, order in enumerate(orders):
        f = os.path.join(work, 'p%d.c' % k)
        open(f, 'w').write(build(order))
        items.append((f, f[:-2] + '.obj', ''))
    res = []
    for (f, o, _), ok, order in zip(items, cc.compile_parallel(items, a.jobs), orders):   # batched DOSBox runs
        r = score(o, a.func, orig_ins) if ok else None
        if r is not None: res.append((r[0], r[1], order))
    shutil.rmtree(work, ignore_errors=True)
    res.sort(key=lambda x: (x[0], x[2]))
    print('%d orders of %d declarations (%s) tried; fewest differing instructions first:'
          % (len(res), n, ', '.join('/'.join(u[2]) for u in slots)))
    for d, size, order in res[:a.top]:
        print('  %4d  %5d bytes  %s' % (d, size, ' '.join('/'.join(slots[i][2]) for i in order)))

if __name__ == '__main__':
    main()
