#!/usr/bin/env python3
"""Deep semantic matcher PC <-> Genesis (93G first, then 94G).
Methods: struct-field correspondence (fieldmap), global RAM/data map, call-graph alignment/propagation,
distinctive immediates, string refs, control-flow shape. Iterates to a fixed point from anchors.
Outputs: tools/sem_matches.json, tools/struct_fieldmap.csv, tools/global_map.csv"""
import os, sys, json, pickle, math, re, csv, bisect
from collections import defaultdict, Counter
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
os.chdir(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
import fieldmap as FMOD
D = FMOD.D; PC = D['pc']; GENL = [g for g in D['gen'] if g['kind'] == 'code']
FD = pickle.load(open('tools/funcs.pkl', 'rb')); F = FD['funcs']; byaddr = {f['start']: f for f in F}
ENGINE = [(0x47C31, 0x6A106), (0x8BEDB, 0x8C94C)]
FRONT_ALLOWED = (0x10000, 0x8C94C)   # helpers anywhere in game code; libs excluded
def in_engine(a): return any(lo <= a < hi for lo, hi in ENGINE)
# ---- Genesis routines: merge 93/94 versions by name; source game = 93G if present in 93
GBY = defaultdict(dict)
for g in GENL: GBY[g['name']][g['game']] = g
def gsrc(n): return '93G' if '93G' in GBY[n] else '94G'
ALIAS94 = {'rtss2': 'rtss', 'assgoaliecpu': 'assgoalie', 'puckunflip': 'pucknothing'}
# ---------------- anchors ----------------
ASS = ['rtss','assdefo','assdefd','asswingd','asswingo','asscenterd','asscentero','assscore','assstanley','asseben','assepen','assbench','asspenalty','assdopen','assgoalie','assgoalietopuck','asspuckc','assnearest','assshoot','asspassrec','assfight','assfwatch','assfaceoff','assfaceoffp1','pucknorm','puckshadow','pucknothing','puckfaceoff','puckfaceoff2','assgoaliectrl','puckshootout','puckpenshot','assgoaliebreakwait','chkpuckc','assbreakaway','assonetimer']
ASSPC = [0x4F990,0x49CDD,0x49E3A,0x4A1A6,0x4A343,0x4A53A,0x4A65C,0x4A90F,0x4A832,0x4AAC2,0x4B02D,0x4B12C,0x4ADAB,0x4AFFB,0x4B774,0x4B5C2,0x4C6F3,0x4CD4B,0x4D3F8,0x50F3F,0x49460,0x495B8,0x4D4F0,0x4D528,0x4D8C7,0x56ECF,0x4D8FD,0x516E1,0x51BDB,0x4AB87,0x4DFF7,0x4E0BD,0x4EB04,0x4ED7C,0x4F5BF,0x4F7D0]
M = {}   # pc -> dict(name, conf, method, evidence, score)
def put(pc, name, conf, method, ev, score=0.0):
    M[pc] = dict(name=name, src=gsrc(name) if name in GBY else '93G', conf=conf, method=method, evidence=ev, score=score)
put(0x59D9A, 'SetSPA', 'high', 'manual+fields', 'identical semantics: SPA/SPAnum/SPAcnt at PC +38h/+3Ah/+3Ch')
put(0x8C230, 'randomd0', 'high', 'manual+constants', 'LCG multiplier E62D/BB40 identical to 93G randomd0 (seed StanleyCupTimer)')
put(0x8C8E8, 'vtoa', 'high', 'manual+constants', 'returns 8 for x|y==0, same octant logic; 94G vtoa byte table found at D2C75 (data_tables)')
put(0x5C40F, 'updateplayers', 'medium', 'manual+table', 'dispatches asstab (C9161) via assnum(+1Ch)-indexed asslist; content of slots 0-$1C verified against 93G routines; 93G hockey93_02 updateplayers')
# ---------------- field map + global map ----------------
anch_pairs = lambda: [(pc, ('93G' if '93G' in GBY[m['name']] else '94G'), m['name']) for pc, m in M.items() if m['name'] in GBY]
def gen_feat(n):
    gg = GBY[n]; return gg.get('93G') or gg.get('94G')
# slot pairs used for field derivation (position evidence only, verified below)
slot_pairs = [(p, '93G', n) for k, (n, p) in enumerate(zip(ASS, ASSPC)) if k < 29 and k not in (20, 21, 13, 15, 24, 25)]
FM, FEV = FMOD.refine(slot_pairs + anch_pairs(), rounds=6)
INV = {}
for gf, offs in FM.items():
    for o in offs: INV[o] = gf
# global map by alignment of global sequences
GM = {'StanleyCupTimer': {0xC9100}, 'RNGseed': {0xC9100}, 'gmode': {0xC90BB}}
GEV = {'StanleyCupTimer': 'randomd0 seed (manual)', 'RNGseed': 'randomd0 seed (manual)',
       'gmode': 'Stop4Pen (63543): 93G bset #gmclock,(gmode).w <-> test/or byte_C90BB,1 (low byte of the 68k word)'}
for r in json.load(open('tools/data_matches.json')):
    if r['name'] in ('vtoa', 'puckfaceoff2'): continue   # inline tables of code labels
    GM.setdefault(r['name'], set()).add(int(r['pc'][0], 16)); GEV[r['name']] = 'data table byte match (%s, %s, %d elems)' % (r['encoding'], r['file'], r['n'])
def align_seq(A, B, known, claimedB, gap=-0.3):
    n, m = len(A), len(B)
    if not n or not m or n * m > 300000: return []
    S = [[0.0] * (m + 1) for _ in range(n + 1)]; Bk = [[0] * (m + 1) for _ in range(n + 1)]
    for i in range(1, n + 1): S[i][0] = S[i-1][0] + gap; Bk[i][0] = 1
    for j in range(1, m + 1): S[0][j] = S[0][j-1] + gap; Bk[0][j] = 2
    for i in range(1, n + 1):
        a = A[i-1]
        for j in range(1, m + 1):
            b = B[j-1]
            if a in known: s = 3.0 if b in known[a] else -1.0
            elif b in claimedB: s = -0.8
            else: s = 0.4
            x = S[i-1][j-1] + s; y = S[i-1][j] + gap; z = S[i][j-1] + gap
            if x >= y and x >= z: S[i][j] = x; Bk[i][j] = 0
            elif y >= z: S[i][j] = y; Bk[i][j] = 1
            else: S[i][j] = z; Bk[i][j] = 2
    i, j, out = n, m, []
    while i > 0 and j > 0:
        if Bk[i][j] == 0: out.append((A[i-1], B[j-1])); i -= 1; j -= 1
        elif Bk[i][j] == 1: i -= 1
        else: j -= 1
    return out
GDF = Counter()
for _a, _p in PC.items():
    for _x in set(_p['globals']): GDF[_x] += 1
GGDF = Counter()
for _g in GENL:
    for _x in set(_g['globals']): GGDF[_x] += 1
def dedup(seq):
    seen = set(); out = []
    for x in seq:
        if x not in seen: seen.add(x); out.append(x)
    return out
def refine_globals(pairs, rounds=4):
    for _ in range(rounds):
        claimed = {a for v in GM.values() for a in v}
        C = defaultdict(Counter); W = defaultdict(lambda: defaultdict(set))
        for pc, game, n in pairs:
            g = gen_feat(n); p = PC.get(pc)
            if not g or not p: continue
            A = dedup([x for x in g['globals'] if x not in ('M68K_RAM', 'SortCords') and GGDF[x] <= 60])
            B = dedup([x for x in p['globals'] if GDF[x] <= 25])
            for a, b in align_seq(A, B, GM, claimed):
                if a not in GM: C[a][b] += 1; W[a][b].add(n)
        add = 0
        for a, c in C.items():
            b, k = c.most_common(1)[0]
            if k >= 2 and k / sum(c.values()) >= 0.6 and b not in claimed and len(W[a][b]) >= 2:
                GM[a] = {b}; GEV[a] = 'aligned %d/%d accesses in %s' % (k, sum(c.values()), ', '.join(sorted(W[a][b])[:5])); claimed.add(b); add += 1
        if not add: break
# ---------------- similarity ----------------
TRIV = set(range(0, 17)) | {0xFF, 0xFFFF, 0xFFFE, 0x100, 0x8000, 0x20, 0x40, 0x80, 0x7FFF, 0xFFF0, 0xFFF8, 0xFFFC}
def gfeat(g):
    fc = Counter(f[0] for f in g['fields'])
    gl = set(g['globals']); im = set(v for v in g['imms'] if v not in TRIV)
    cs = [c for c, _ in g['calls']]
    return fc, gl, im, cs
def pfeat(p):
    fc = Counter(INV[f[0]] for f in p['fields'] if f[0] in INV and f[3] in ('eax', 'esi', 'edi', 'ebx', 'edx', 'ecx', 'ebp'))
    gl = set(p['globals']); im = set(v for v in p['imms'] if v not in TRIV)
    cs = [c for c, _ in p['calls'] if isinstance(c, int)]
    return fc, gl, im, cs
def cos(a, b):
    if not a or not b: return 0.0
    k = set(a) & set(b); num = sum(a[x] * b[x] for x in k)
    return num / math.sqrt(sum(v * v for v in a.values()) * sum(v * v for v in b.values()))
BITOPS68 = {'btst', 'bset', 'bclr', 'bchg'}; BITOPSX = {'test', 'and', 'or', 'xor', 'bt', 'bts', 'btr'}
def gtoks(n):
    g = gen_feat(n); t = Counter()
    for f, w, op in g['fields']: t['f:' + f] += 1; t[('fb:' if op in BITOPS68 else 'fv:') + f] += 1
    for a in g['globals']:
        if a in GM: t['g:' + str(min(GM[a]))] += 1
    for c, _ in g['calls']:
        c = ALIAS94.get(c, c)
        if c in NAME2PC: t['c:' + c] += 1
    for v in g['imms']:
        if v not in TRIV: t['i:%X' % v] += 1
    return t
def ptoks(pc):
    p = PC[pc]; t = Counter()
    for o, w, op, reg in p['fields']:
        if o in INV: t['f:' + INV[o]] += 1; t[('fb:' if (op in BITOPSX and w == 'b') else 'fv:') + INV[o]] += 1
    for a in p['globals']: t['g:' + str(a)] += 1
    for c, _ in p['calls']:
        if isinstance(c, int) and c in M: t['c:' + M[c]['name']] += 1
    for v in p['imms']:
        if v not in TRIV: t['i:%X' % v] += 1
    return t
NAME2PC = {}
DF = Counter(); NDOC = [1]
def rebuild_idf():
    NAME2PC.clear()
    for pc, m in M.items(): NAME2PC[m['name']] = pc
    DF.clear(); n = 0
    for nm in GBY:
        for k in set(gtoks(nm)): DF[k] += 1
        n += 1
    for pc in PC:
        if FRONT_ALLOWED[0] <= pc < FRONT_ALLOWED[1]:
            for k in set(ptoks(pc)): DF[k] += 1
            n += 1
    NDOC[0] = n
def vec(t):
    v = {k: (1 + math.log(c)) * math.log(NDOC[0] / (1 + DF[k])) for k, c in t.items()}
    nr = math.sqrt(sum(x * x for x in v.values())) or 1
    return {k: x / nr for k, x in v.items()}
def sim(pc, n, detail=False):
    p = PC[pc]; g = gen_feat(n)
    vp, vg = vec(ptoks(pc)), vec(gtoks(n))
    common = set(vp) & set(vg)
    c = sum(vp[k] * vg[k] for k in common)
    rp, rg = max(1, p['ninsn']), max(1, g['ninsn']); ratio = rp / rg
    shape = 0.0 if 0.7 <= ratio <= 7 else (-0.15 if 0.4 <= ratio <= 12 else -0.4)
    # negative call evidence: Genesis calls a routine whose PC address is known but PC body never calls it
    gcalls = {ALIAS94.get(x, x) for x, _ in g['calls']} & set(NAME2PC)
    pcalls = {x for x, _ in p['calls'] if isinstance(x, int)}
    miss = sum(1 for x in gcalls if NAME2PC[x] not in pcalls)
    pk = {M[x]['name'] for x in pcalls if x in M}
    extra = len(pk - {ALIAS94.get(x, x) for x, _ in g['calls']})
    sq = seqsim(pc, n) if (c > 0.15 or detail) else 0.0
    score = 6 * c + 8 * sq + 10 * shape - 0.8 * miss - 0.4 * extra
    if detail:
        top = sorted(common, key=lambda k: -vp[k] * vg[k])[:8]
        return score, dict(cosine='%.2f' % c, fieldseq='%.2f' % sq, shared=' '.join(top), calls='%d known Genesis callees present, %d missing, %d extra' % (len(gcalls) - miss, miss, extra), size='ninsn PC %d / G %d' % (rp, rg))
    return score
def gseq(n):
    g = gen_feat(n); out = []
    # rebuild ordered token stream: fields, calls, imms in body order are stored per-kind; approximate order by kind interleave
    for f, w, op in g['fields']: out.append(('fb:' if op in BITOPS68 else 'fv:') + f)
    return out
def pseq(pc):
    return [('fb:' if (op in BITOPSX and w == 'b') else 'fv:') + INV[o] for o, w, op, reg in PC[pc]['fields'] if o in INV]
def seqsim(pc, n):
    A, B = gseq(n), pseq(pc)
    if not A or not B: return 0.0
    if len(A) * len(B) > 250000: return 0.0
    W = lambda k: math.log(NDOC[0] / (1 + DF.get(k.replace('fb:', 'f:').replace('fv:', 'f:'), 0)) + 1)
    wa = [W(k) for k in A]
    prev = [0.0] * (len(B) + 1)
    for i, a in enumerate(A):
        cur = [0.0] * (len(B) + 1)
        for j, b in enumerate(B):
            x = prev[j] + wa[i] if a == b else 0
            cur[j + 1] = max(prev[j + 1], cur[j], x)
        prev = cur
    tot = math.sqrt(sum(wa) * sum(W(k) for k in B))
    return prev[-1] / tot if tot else 0.0
def sim_old(pc, n, detail=False):
    p = PC[pc]; g = gen_feat(n)
    pf, pg, pi, pcs = pfeat(p); gf, gg, gi, gcs = gfeat(g)
    # fields
    fs = cos(pf, gf); nf = sum(gf.values())
    # globals: mapped
    gmapped = {a for a in gg if a in GM}
    ghit = sum(1 for a in gmapped if GM[a] & pg)
    gs = ghit / len(gmapped) if gmapped else 0.0
    # calls: PC callees with known names
    known_callees = [M[c]['name'] for c in pcs if c in M]
    gset = set(gcs) | {ALIAS94.get(x, x) for x in gcs}
    chit = sum(1 for x in set(known_callees) if x in gset)
    cmiss = len(set(known_callees) - gset)
    cs_ = chit / max(1, len(set(gcs))) if gcs else 0.0
    # immediates (PC rink scaling makes positions differ; keep distinctive)
    ii = len(pi & gi); is_ = ii / max(1, min(len(pi), len(gi))) if gi and pi else 0.0
    # shape
    rp, rg = max(1, p['ninsn']), max(1, g['ninsn'])
    ratio = rp / rg
    shape = 1.0 if 0.8 <= ratio <= 6 else (0.5 if 0.5 <= ratio <= 10 else 0.0)
    br = 1.0 - min(1.0, abs((p['nbr'] / rp) - (g['nbr'] / rg)) * 3)
    score = 2.0 * fs * min(1, nf / 6) + 2.5 * cs_ - 0.7 * cmiss + 1.5 * gs * min(1, len(gmapped) / 2) + 1.0 * is_ * min(1, ii / 3) + 0.5 * shape + 0.3 * br
    if shape == 0: score -= 1.5
    if detail:
        return score, dict(fields='cos %.2f over %d Genesis field accesses' % (fs, nf), globals='%d/%d mapped globals hit' % (ghit, len(gmapped)),
                           calls='%d/%d Genesis callees matched by named PC callees (%d mismatched)' % (chit, len(set(gcs)), cmiss),
                           imms='%d shared distinctive immediates %s' % (ii, sorted('%X' % v for v in (pi & gi))[:6]), size='ninsn PC %d / G %d' % (rp, rg))
    return score
# ---------------- iterate ----------------
def candidates():
    pcs = [a for a in PC if FRONT_ALLOWED[0] <= a < FRONT_ALLOWED[1] and a not in M and PC[a]['ninsn'] >= 3]
    used = {m['name'] for m in M.values()}
    gns = [n for n in GBY if n not in used and gen_feat(n)['ninsn'] >= 3]
    return pcs, gns
def run():
    log = []
    for it in range(10):
        refine_globals(anch_pairs()); rebuild_idf()
        pcs, gns = candidates()
        GF = {n: gfeat(gen_feat(n)) for n in gns}
        # inverted index for prefilter
        idx = defaultdict(set)
        for n, (gf, gg, gi, gcs) in GF.items():
            for f in gf: idx[('f', f)].add(n)
            for a in gg:
                if a in GM: idx[('g', a)].add(n)
            for v in gi: idx[('i', v)].add(n)
            for c in set(gcs): idx[('c', ALIAS94.get(c, c))].add(n)
        S = {}
        for pc in pcs:
            pf, pg, pi, pcs_ = pfeat(PC[pc])
            cand = Counter()
            for f in pf: cand.update(idx.get(('f', f), ()))
            for a in pg:
                for n_ in [k for k, v in GM.items() if a in v]: cand.update(idx.get(('g', n_), ()))
            for v in pi: cand.update(idx.get(('i', v), ()))
            for c in pcs_:
                if c in M: cand.update(idx.get(('c', M[c]['name']), ()) )
            for n, k in cand.most_common(60):
                if k >= 2: S[(pc, n)] = sim(pc, n)
        bestP = defaultdict(list); bestG = defaultdict(list)
        for (pc, n), s in S.items(): bestP[pc].append((s, n)); bestG[n].append((s, pc))
        for d in (bestP, bestG):
            for k in d: d[k].sort(reverse=True)
        added = 0
        for pc, lst in bestP.items():
            s, n = lst[0]; s2 = lst[1][0] if len(lst) > 1 else 0
            gl = bestG[n]; gs2 = gl[1][0] if len(gl) > 1 else 0
            if gl[0][1] != pc: continue
            margin = min(s - s2, s - gs2)
            in_e = in_engine(pc)
            th = 4.5 if in_e else 6.0
            sh = set(vec(ptoks(pc))) & set(vec(gtoks(n)))
            strong = {k for k in sh if not re.match(r'f[bv]?:(Xpos|Ypos)$', k)}
            distinct = {re.sub(r'^f[bv]?:', 'f:', k) for k in strong}
            if len(distinct) < 2: continue
            if not in_e and not any(k.startswith(('c:', 'g:')) for k in strong): continue
            ok = (s >= th and margin >= 1.0) or (in_e and s >= 3.5 and margin >= 0.7 and len(distinct) >= 3)
            if ok:
                conf = 'high' if (s >= 8 and margin >= 3) else 'medium' if (s >= 6 and margin >= 1.5) else 'low'
                if conf == 'high' and (PC[pc]['ninsn'] < 12 or len(distinct) < 3): conf = 'medium'   # thin evidence on tiny bodies
                _, det = sim(pc, n, True)
                put(pc, n, conf, 'semantic(it%d)' % it, '; '.join('%s: %s' % kv for kv in det.items()) + '; margin %.2f' % margin, s); added += 1
        # call-graph propagation: align callee sequences of matched pairs, accumulate votes
        VOTES = defaultdict(set)
        for pc, m in list(M.items()):
            if m['name'] not in GBY or pc not in PC: continue
            g = gen_feat(m['name'])
            A = [ALIAS94.get(c, c) for c, _ in g['calls']]
            B = [c for c, _ in PC[pc]['calls'] if isinstance(c, int)]
            known = {}
            for c in set(B):
                if c in M: known.setdefault(M[c]['name'], set()).add(c)
            claimed = set(M)
            for a, b in align_seq(A, B, known, claimed):
                if a in known or b in M or a not in GBY or b not in PC: continue
                if any(x['name'] == a for x in M.values()): continue
                VOTES[(b, a)].add(m['name'])
        byb = defaultdict(list)
        for (b, a), par in VOTES.items(): byb[b].append((len(par), a, par))
        taken = set()
        for b, lst in sorted(byb.items(), key=lambda t: -max(x[0] for x in t[1])):
            lst.sort(reverse=True)
            v, a, par = lst[0]
            if len(lst) > 1 and lst[1][0] == v: continue
            if a in taken or b in M: continue
            s, det = sim(b, a, True)
            if v >= 3 and s >= 2: conf = 'high'
            elif v >= 2 and s >= 0: conf = 'medium'
            elif v >= 1 and s >= 5: conf = 'medium'
            elif v >= 1 and s >= 3: conf = 'low'
            else: continue
            if b >= 0x8C94C or b < 0x10000:
                conf = 'low'
                det['note'] = 'library-zone routine: role correspondence only (different implementation)'
            taken.add(a)
            put(b, a, conf, 'callgraph(it%d)' % it, 'callee alignment under %d matched caller(s) %s; ' % (v, ', '.join(sorted(par)[:4])) + '; '.join('%s: %s' % kv for kv in det.items()), s); added += 1
        # caller propagation: Genesis callers of a matched routine vs PC callers of its PC address
        GCALLERS = defaultdict(set)
        for nm, gg in GBY.items():
            g_ = gg.get('93G') or gg.get('94G')
            for c_, _ in g_['calls']: GCALLERS[ALIAS94.get(c_, c_)].add(nm)
        used = {x['name'] for x in M.values()}
        CV = defaultdict(float); CP = defaultdict(set)
        for pc, m in list(M.items()):
            if m['name'] not in GBY or pc not in byaddr: continue
            gc = [x for x in GCALLERS.get(m['name'], ()) if x not in used]
            pcall = [x for x in byaddr[pc]['callers'] if F[x]['start'] in PC and F[x]['start'] not in M]
            if not gc or not pcall or len(gc) > 12: continue
            for x in pcall:
                for a in gc:
                    CV[(F[x]['start'], a)] += 1.0 / len(gc); CP[(F[x]['start'], a)].add(m['name'])
        best = {}
        for (b, a), w in CV.items():
            if b not in best or w > best[b][0]: best[b] = (w, a)
        taken = set()
        for b, (w, a) in sorted(best.items(), key=lambda t: -t[1][0]):
            if a in taken or b in M or any(x['name'] == a for x in M.values()): continue
            s_, det = sim(b, a, True)
            if w >= 1.0 and s_ >= 3: conf = 'medium'
            elif w >= 0.5 and s_ >= 4.5: conf = 'low'
            else: continue
            if not (FRONT_ALLOWED[0] <= b < FRONT_ALLOWED[1]): conf = 'low'
            taken.add(a)
            put(b, a, conf, 'callers(it%d)' % it, 'caller propagation weight %.2f via matched callees %s; ' % (w, ', '.join(sorted(CP[(b, a)])[:4])) + '; '.join('%s: %s' % kv for kv in det.items()), s_); added += 1
        log.append((it, added, len(M)))
        if not added: break
    return log
def seed_slots():
    # ---- verify asstab slots by content before using them as anchors
    slot_res = []
    rebuild_idf()
    for k, (n, pc) in enumerate(zip(ASS, ASSPC)):
        if k >= 29: continue
        g = gen_feat(n) if n in GBY else None
        if g is None: slot_res.append((k, n, pc, None)); continue
        s, det = sim(pc, n, True)
        q, nk, _ = FMOD.pair_quality(g, PC[pc], FM) if pc in PC else (None, 0, [])
        # rank of the true name among all 36 slot routines for this PC body
        ranks = sorted(((sim(pc, x), x) for x in ASS if x in GBY and pc in PC), reverse=True)
        rank = [x for _, x in ranks].index(n) + 1 if ranks else None
        slot_res.append((k, n, pc, dict(score=round(s, 2), fieldq=q, nknown=nk, rank=rank, best=ranks[0][1] if ranks else None, det=det)))
    for k, n, pc, r in slot_res:
        if r is None: continue
        q = r['fieldq']
        if k in (20, 21):
            put(pc, 'ass_pc_slot%d' % k, 'medium', 'asstab+content', ('slot $14 (93G assfight) body is NOT fight code: no Pencntdwn/getpde/aggress/fight anims; it sets temp5/temp2, picks a target from table CC9EA by team/position, skates until dist^2<900 then assexit - repurposed (3-stars skate-out)' if k == 20 else
                'slot $15 (93G assfwatch) body is NOT fight-watch code: it selects players and formats \"%s Star\"/\"EA Sports\" via sprintf - repurposed (3-stars of the game presentation)'), 0); M[pc]['src'] = 'PC-new'; continue
        if k == 24:
            put(pc, 'pucknorm', 'high', 'asstab+content', 'slot $18; head identical to 93G pucknorm: bclr pfna; clr temp1(+26h); temp2(+28h)=$78; then calls the body sub_4D6B4', r['score']); continue
        if (r['rank'] == 1 and (q or 0) >= 0.6) or (q or 0) >= 0.8 and r['nknown'] >= 6:
            conf = 'high' if (r['rank'] == 1 and (q or 0) >= 0.8 and r['nknown'] >= 6) else 'medium'
        elif (q or 0) >= 0.5 or r['rank'] and r['rank'] <= 3: conf = 'medium' if (q or 0) >= 0.6 else 'low'
        else: conf = 'low'
        if k in (0, 26): conf = 'medium'
        put(pc, n, conf, 'asstab+content', 'asstab slot %d; field alignment %s of %d known-field accesses; content rank %s/34 vs other slot routines; %s' % (
            k, ('%.0f%%' % (100 * q)) if q is not None else 'n/a', r['nknown'], r['rank'], r['det']['calls']), r['score'])
    for k in range(29, 36):
        put(ASSPC[k], 'ass_pc_slot%d' % k, 'low', 'asstab+content', 'slot %d: position suggested 94G %s but content check fails (rank >=13 of 36 slot routines; best overall matches are 93G assbench/asspenalty-style movement code) -> PC-own assignment (94 PC was ported from 93G, so slots >=$1D are PC additions)' % (k, ASS[k]), 0)
        M[ASSPC[k]]['src'] = 'PC-new'
    for k, a in enumerate([0x4E8EF,0x4842A,0x484DA,0x52720,0x5147D,0x526ED,0x499D8,0x49BC2,0x52FB0,0x52DB0,0x4FAE8]):
        put(a, 'ass_pc_slot%d' % (36 + k), 'low', 'asstab', 'slot %d: beyond all Genesis asstabs; no content match' % (36 + k), 0); M[a]['src'] = 'PC-new'
    put(0x4D6B4, 'pucknorm_body', 'high', 'manual+fields', 'called from pucknorm head (slot $18) at the 93G .nna point; continues 93G pucknorm (puckcross timers, findpc, puckc)', 0); M[0x4D6B4]['src'] = '93G'
    put(0x4D509, 'assexit', 'high', 'manual+fields', 'instruction-for-instruction 93G assexit: assnum(+1Ch)=(assnum+1)&7; bset pfna in pflags(+44h)', 0)
    return slot_res
if __name__ == '__main__':
    slot_res = seed_slots()
    log = run()
    json.dump(dict(matches={'%X' % k: v for k, v in M.items()}, slots=[(k, n, '%X' % pc, r) for k, n, pc, r in slot_res], log=log,
                   fieldmap={k: ['%X' % o for o in v] for k, v in FM.items()}, globalmap={k: ['%X' % o for o in v] for k, v in GM.items()}),
              open('tools/sem_matches.json', 'w'), indent=1, default=str)
    with open('tools/struct_fieldmap.csv', 'w', newline='') as fh:
        w = csv.writer(fh); w.writerow(['genesis_field', 'genesis_offset', 'pc_offset', 'evidence'])
        for k in D['PLAYER']:
            if k in FM: w.writerow([k, '$%02X' % D['SF'][k], ';'.join('%02Xh' % o for o in FM[k]), FEV.get(k, [''])[0]])
    with open('tools/global_map.csv', 'w', newline='') as fh:
        w = csv.writer(fh); w.writerow(['genesis_symbol', 'pc_address', 'evidence'])
        for k, v in sorted(GM.items()): w.writerow([k, ';'.join('%X' % o for o in sorted(v)), GEV.get(k, '')])
    c = Counter((m['src'], m['conf']) for m in M.values())
    print('log', log); print('matches', len(M), dict(c))
    print('engine named', sum(1 for a in M if in_engine(a)), 'of', sum(1 for a in PC if in_engine(a)))
    print('fields', len(FM), 'globals', len(GM))
