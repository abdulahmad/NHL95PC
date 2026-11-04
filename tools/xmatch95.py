#!/usr/bin/env python3
"""xmatch95.py - propose 95PC <-> 95G (or 94G) routine pairs across the two CPUs, for the body-by-body naming pass.

  python3 tools/xmatch95.py UNIT [--genesis ../NHL95Genesis] [--file front/trade95.asm] [--top 3] [--all]

UNIT names a 95G source file (trade95, awards95, ...; or a path under the Genesis src/ with --file). For each
Genesis routine of that file it scores every 95PC function and writes docs/xmatch/UNIT.csv with the best few.
It only proposes: a person (or agent) reads both bodies before any rename.

Anchors (68000 and x86 share no opcodes, so the bodies are compared through what they touch):
  strings    text the routine prints. Genesis: the quoted parts of String / dc.b lines in its body.
             95PC: the zero ended text of every dseg02 label the function references (through one dd pointer).
             Compared as normalised words; a whole string in common counts most.
  names      identifiers both sides use with the same name: RAM variables, struct fields, routines it calls,
             data tables (95PC names most of these after Genesis). Lower case, auto names (sub_, dword_ ...) skipped.
  constants  immediates outside the trivial ones (0, 1, 2, -1, FFh, 8, 10h ...).
Score = 3*strings + 2*names + 1*constants (each a 0..1 overlap). `mutual` is set when the pair is each other's
best within the unit."""
import argparse, collections, csv, glob, math, os, re, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, 'tools'))
AUTO = re.compile(r'^(sub|loc|locret|byte|word|dword|unk|off|asc|stru|jpt|def|nullsub|j)_[0-9A-Fa-f]+', re.I)
TRIVIAL = {0, 1, 2, 3, 4, 8, 0x10, 0xFF, 0xFFFF, 0xFFFFFFFF, -1, 0x7F, 0x80}
WORD = re.compile(r"[A-Za-z][A-Za-z']{2,}")


def words(s):
    return {w.lower() for w in WORD.findall(s)}


def norm(s):
    return ' '.join(re.findall(r"[a-z0-9]+", s.lower()))


# ------------------------------------------------------------------ 95PC
def pc_data():
    """label -> bytes / pointer target, from src/dseg02."""
    lab, cur = {}, None
    for f in sorted(glob.glob(os.path.join(ROOT, 'src/dseg02/*.asm'))):
        for l in open(f, errors='replace'):
            l = l.split(';')[0].rstrip()
            m = re.match(r'^([A-Za-z_][\w@$?]*):', l)
            if m:
                cur = m.group(1)
                lab[cur] = {'b': bytearray(), 'p': []}
                continue
            if cur is None:
                continue
            m = re.match(r'^\s*db\s+(.*)', l)
            if m:
                for x in m.group(1).split(','):
                    x = x.strip()
                    if re.match(r"^'.*'$", x):
                        lab[cur]['b'] += x[1:-1].encode('latin-1')
                    elif re.match(r'^[0-9A-Fa-f]+h$', x):
                        lab[cur]['b'].append(int(x[:-1], 16) & 0xFF)
                    elif re.match(r'^\d+$', x):
                        lab[cur]['b'].append(int(x) & 0xFF)
                continue
            m = re.match(r'^\s*dd\s+(.*)', l)
            if m:
                lab[cur]['p'] += [x.strip() for x in m.group(1).split(',')]
    return lab


def pc_text(lab, name, depth=1):
    d = lab.get(name)
    if not d:
        return []
    out = []
    b = bytes(d['b'])
    for chunk in b.split(b'\0'):
        s = chunk.decode('latin-1')
        if len(re.findall(r'[A-Za-z]', s)) >= 3 and sum(c.isprintable() for c in s) >= 0.9 * len(s):
            out.append(s)
    if depth:
        for p in d['p']:
            if re.match(r'^[A-Za-z_]', p):
                out += pc_text(lab, p, depth - 1)
    return out


def pc_funcs():
    lab = pc_data()
    funcs = {}
    import cc
    for f in cc.iter_asm():
        glob_names = set()
        lines = open(f, errors='replace').read().split('\n')
        for l in lines:
            if l.startswith('global '):
                glob_names.update(x.strip() for x in l[7:].split(','))
        cur = None
        for l in lines:
            m = re.match(r'^([A-Za-z_][\w@$?]*):', l)
            if m and m.group(1) in glob_names:
                cur = m.group(1)
                funcs[cur] = {'file': os.path.relpath(f, ROOT), 'ids': set(), 'k': set(), 's': []}
                continue
            if cur is None or l.startswith(('global', 'extern', '%', ';')):
                continue
            code = l.split(';')[0]
            for t in re.findall(r'\b([A-Za-z_][\w@$?]*)\b', code):
                if t in lab:
                    funcs[cur]['s'] += pc_text(lab, t)
                if not AUTO.match(t):
                    funcs[cur]['ids'].add(t.lower())
            for x in re.findall(r'\b([0-9][0-9A-Fa-f]*)h\b', code):
                funcs[cur]['k'].add(int(x, 16))
            for x in re.findall(r'(?<![\w.])(\d+)(?![\w.h])', code):
                funcs[cur]['k'].add(int(x))
    return funcs


# ------------------------------------------------------------------ Genesis
def gen_routines(path):
    out, cur = collections.OrderedDict(), None
    for l in open(path, errors='replace'):
        m = re.match(r'^([A-Za-z_]\w*)(?=\s|$|;)', l)
        if m and not re.match(r'^\s*\S+\s+(equ|=|rs|set)\b', l, re.I):
            cur = m.group(1)
            out[cur] = {'ids': set(), 'k': set(), 's': [], 'c': l.split(';', 1)[1].strip() if ';' in l else ''}
            continue
        if cur is None:
            continue
        code = l.split(';')[0]
        if not code.strip():
            continue
        out[cur]['s'] += [s for s in re.findall(r"'([^']*)'", code) if len(re.findall(r'[A-Za-z]', s)) >= 3]
        for t in re.findall(r'(?<![.\w])([A-Za-z_]\w*)\b', re.sub(r"'[^']*'", '', code)):
            if not AUTO.match(t):
                out[cur]['ids'].add(t.lower())
        for x in re.findall(r'#\$([0-9A-Fa-f]+)', code):
            out[cur]['k'].add(int(x, 16))
        for x in re.findall(r'#(\d+)\b', code):
            out[cur]['k'].add(int(x))
    return out


OPS = set('''move moveq movea movem lea pea add addq adda addi sub subq suba subi cmp cmpi cmpa tst btst bset bclr
bchg and andi or ori eor eori not neg ext swap asl asr lsl lsr rol ror clr bra bsr jsr jmp rts beq bne bgt blt bge
ble bhi bls bpl bmi bcc bcs dbf dbra muls mulu divs divu exg st sf seq sne w l b s a0 a1 a2 a3 a4 a5 a6 a7 sp d0 d1
d2 d3 d4 d5 d6 d7 pc string dc ds even cc_setx cc_sety cc_setfont cc_addx cc_addy cc_setmap cc_setmapandposition
m68k_ram rts2 rtss rtss2 rtss8 mov push pop call ret jz jnz je jne jl jg jle jge ja jb jae jbe jmp cmp test inc dec
xor shl shr sar lea movsx movzx dword word byte eax ebx ecx edx esi edi ebp esp ax bx cx dx al bl cl dl ah bh ch dh
imul idiv cdq cwd near short ptr offset __chk'''.split())


IDF = {}


def wov(a, b, kind):
    # idf weighted overlap of two sets: shared weight over the geometric mean of both weights
    if not a or not b:
        return 0.0
    w = lambda x: IDF.get((kind, x), 0.0)
    wa, wb = sum(w(x) for x in a), sum(w(x) for x in b)
    return sum(w(x) for x in a & b) / math.sqrt(max(1e-9, wa) * max(1e-9, wb))


def score(g, p):
    gs, ps = {norm(s) for s in g['s'] if norm(s)}, {norm(s) for s in p['s'] if norm(s)}
    s_whole = len(gs & ps) / max(1, len(gs)) if gs else 0
    gw = set().union(*[words(s) for s in g['s']]) if g['s'] else set()
    pw = set().union(*[words(s) for s in p['s']]) if p['s'] else set()
    s_words = len(gw & pw) / max(1, len(gw)) if gw else 0
    s = max(s_whole, 0.8 * s_words)
    gi, pi = g['ids'] - OPS, p['ids'] - OPS
    n = wov(gi, pi, 'n')
    gk, pk = g['k'] - TRIVIAL, p['k'] - TRIVIAL
    k = wov(gk, pk, 'k') if len(gk & pk) >= 2 else 0
    return 3 * s + 2 * n + k, s, n, k, sorted(gs & ps)[:3], sorted(gi & pi)[:8]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('unit')
    ap.add_argument('--genesis', default=os.path.join(ROOT, '..', 'NHL95Genesis'))
    ap.add_argument('--file')
    ap.add_argument('--top', type=int, default=3)
    ap.add_argument('--all', action='store_true', help='also score Genesis routines whose name 95PC already has')
    ap.add_argument('--pcnew', action='store_true', help='only 95PC functions with a PC name or an auto name')
    a = ap.parse_args()
    gfile = a.file or next(iter(glob.glob(os.path.join(a.genesis, 'src', '**', a.unit + '.asm'), recursive=True)), None)
    if gfile and not os.path.isabs(gfile) and not os.path.isfile(gfile):
        gfile = os.path.join(a.genesis, 'src', gfile)
    gen = gen_routines(gfile)
    pc = pc_funcs()
    pc_funcs_names = list(pc)
    if a.pcnew:
        keep = {r['proposed_name'] for r in csv.DictReader(open(os.path.join(ROOT, 'name_map_94.csv')))
                if r['source_game'] == 'PC-new'}
        pc = {n: p for n, p in pc.items() if n in keep or AUTO.match(n)}
    df = collections.Counter()
    for p in pc.values():
        df.update(('n', x) for x in p['ids'] - OPS)
        df.update(('k', x) for x in p['k'] - TRIVIAL)
    N = len(pc)
    for key, c in df.items():
        IDF[key] = math.log(N / c)
    best_pc = {}
    rows = []
    allpc = {n.lower() for n in pc_funcs_names}
    for gname, g in gen.items():
        if not (g['ids'] or g['s']):
            continue
        if gname.lower() in allpc and not a.all:
            continue                    # 95PC already has this name
        sc = sorted(((score(g, p), n) for n, p in pc.items()), key=lambda x: -x[0][0])[:a.top]
        for rank, (s, n) in enumerate(sc):
            rows.append([gname, rank + 1, n, '%.2f' % s[0], '%.2f' % s[1], '%.2f' % s[2], '%.2f' % s[3],
                         ' | '.join(s[4]), ' '.join(s[5]), pc[n]['file']])
            if s[0] > best_pc.get(n, (0, None))[0]:
                best_pc[n] = (s[0], gname)
    for r in rows:
        r.insert(4, 'mutual' if r[1] == 1 and best_pc.get(r[2], (0, None))[1] == r[0] else '')
    out = os.path.join(ROOT, 'docs', 'xmatch', a.unit + '.csv')
    os.makedirs(os.path.dirname(out), exist_ok=True)
    with open(out, 'w', newline='') as fh:
        w = csv.writer(fh)
        w.writerow(['genesis', 'rank', 'pc', 'score', 'mutual', 'strings', 'names', 'consts', 'shared_strings',
                    'shared_names', 'pc_file'])
        w.writerows(rows)
    print(out, len(rows), 'rows;', sum(1 for r in rows if r[4]), 'mutual')


if __name__ == '__main__':
    main()
