#!/usr/bin/env python3
"""Derive Genesis player-struct field -> PC offset map by positional voting over anchor pairs.
anchors: list of (pc_addr, game, genesis_name). Writes tools/struct_fieldmap.csv"""
import os, sys, pickle, math, csv, json
from collections import defaultdict
os.chdir(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
D = pickle.load(open('tools/sem_feat.pkl', 'rb'))
GEN = {(g['game'], g['name']): g for g in D['gen']}
WC = {'b': 1, 'w': 2, 'l': 4, '': 0}
def compat(gw, pw, gname, poff, goff):
    if not gw or not pw: return 0.5
    if gw == pw: return 1.0
    if gw == 'l' and pw == 'w': return 0.6   # 16.16 long split, integer word at +2
    if gw == 'w' and pw == 'l': return 0.4
    return 0.1
def vote(anchors, sigma=0.12):
    V = defaultdict(lambda: defaultdict(float)); n = defaultdict(int)
    for pa, game, gn in anchors:
        g = GEN.get((game, gn)); p = D['pc'].get(pa)
        if not g or not p or not g['fields'] or not p['fields']: continue
        GF = g['fields']; PF = [x for x in p['fields'] if x[0] < 0x100]
        for i, (gf, gw, gop) in enumerate(GF):
            gi = (i + .5) / len(GF); n[gf] += 1
            tot = 0; loc = defaultdict(float)
            for j, (po, pw, pop, preg) in enumerate(PF):
                pj = (j + .5) / len(PF)
                w = math.exp(-((gi - pj) / sigma) ** 2) * compat(gw, pw, gf, po, D['SF'][gf])
                loc[po] += w; tot += w
            for po, w in loc.items(): V[gf][po] += w / tot if tot else 0
    return V, n
if __name__ == '__main__':
    anchors = json.load(open(sys.argv[1])) if len(sys.argv) > 1 else []
    V, n = vote(anchors)
    for gf in D['PLAYER']:
        if gf not in V: continue
        top = sorted(V[gf].items(), key=lambda t: -t[1])[:4]
        print('%-10s $%02X n=%-3d' % (gf, D['SF'][gf], n[gf]), '  '.join('%02X:%.2f' % (o, w) for o, w in top))

# ---------------- alignment-based refinement ----------------
SEED = {'Xpos': [0x0, 0x2], 'Ypos': [0x4, 0x6], 'Xvel': [0xC], 'Yvel': [0xE], 'facedir': [0x36], 'SPA': [0x38], 'SPAnum': [0x3A],
        'SPAcnt': [0x3C], 'pflags': [0x44], 'pflags2': [0x45], 'SCnum': [0x6A],
        'assnum': [0x1C], 'temp1': [0x26], 'temp2': [0x28]}   # assexit (4D509) and pucknorm head (4D8C7) are instruction-for-instruction
def align(GF, PF, FM, claimed, gap=-0.4):
    n, m = len(GF), len(PF)
    if n * m > 400000: return 0, []
    S = [[0.0] * (m + 1) for _ in range(n + 1)]; B = [[0] * (m + 1) for _ in range(n + 1)]
    for i in range(1, n + 1): S[i][0] = S[i-1][0] + gap; B[i][0] = 1
    for j in range(1, m + 1): S[0][j] = S[0][j-1] + gap; B[0][j] = 2
    def sub(g, p):
        gf, gw, _ = g; po, pw, _, _ = p
        if gf in FM: return 3.0 if po in FM[gf] else (-1.0)
        if po in claimed: return -0.8
        c = compat(gw, pw, gf, po, 0)
        return 0.6 * c
    for i in range(1, n + 1):
        for j in range(1, m + 1):
            a = S[i-1][j-1] + sub(GF[i-1], PF[j-1]); b = S[i-1][j] + gap; c = S[i][j-1] + gap
            if a >= b and a >= c: S[i][j] = a; B[i][j] = 0
            elif b >= c: S[i][j] = b; B[i][j] = 1
            else: S[i][j] = c; B[i][j] = 2
    i, j = n, m; pairs = []
    while i > 0 and j > 0:
        if B[i][j] == 0: pairs.append((GF[i-1], PF[j-1])); i -= 1; j -= 1
        elif B[i][j] == 1: i -= 1
        else: j -= 1
    return S[n][m], pairs
def pair_quality(g, p, FM):
    """fraction of known-field Genesis accesses aligned to the right PC offset"""
    GF = g['fields']; PF = [x for x in p['fields'] if x[0] < 0x100]
    claimed = {o for v in FM.values() for o in v}
    sc, pairs = align(GF, PF, FM, claimed)
    known = [x for x in GF if x[0] in FM]
    good = sum(1 for gx, px in pairs if gx[0] in FM and px[0] in FM[gx[0]])
    return (good / len(known) if known else None), len(known), pairs
BYTEF = {'newpos', 'newpnum', 'pflags', 'pflags2', 'glitch', 'pnum', 'weight', 'legstr', 'legspd', 'aioff', 'aidef', 'shotspd', 'shotacc', 'passacc', 'rostnum', 'spodds', 'stickhand', 'handed'}
def refine(anchors, rounds=4, minsup=2, minfrac=0.6):
    FM = {k: list(v) for k, v in SEED.items()}; EV = {k: ['seed: SetSPA/asseben hand alignment'] for k in SEED}
    for r in range(rounds):
        claimed = {o for v in FM.values() for o in v}
        C = defaultdict(lambda: defaultdict(float)); CN = defaultdict(lambda: defaultdict(set))
        for pa, game, gn in anchors:
            g = GEN.get((game, gn)); p = D['pc'].get(pa)
            if not g or not p: continue
            q, nk, pairs = pair_quality(g, p, FM)
            if q is None or q < 0.5: continue
            for gx, px in pairs:
                if gx[0] not in FM: C[gx[0]][px[0]] += 1; CN[gx[0]][px[0]].add(gn)
        added = 0
        WID = {'b': 1, 'w': 2, 'l': 4}
        def covered(o):
            for f2, offs in FM.items():
                wv = max(WID.get(x[1], 2) for g_ in GEN.values() for x in g_['fields'][:0]) if False else (4 if f2 in ('Xpos', 'Ypos', 'Zpos') else 1 if f2 in BYTEF else 2)
                for o2 in offs:
                    if o2 <= o < o2 + wv and o != o2: return True
            return False
        for gf, d in C.items():
            tot = sum(d.values()); o, c = max(d.items(), key=lambda t: t[1])
            gw = 1 if gf in BYTEF else 2
            if c >= minsup and c / tot >= minfrac and o not in claimed and len(CN[gf][o]) >= 2 and not covered(o):
                FM[gf] = [o]; EV[gf] = ['aligned %d/%d accesses in %s' % (c, tot, ', '.join(sorted(CN[gf][o])[:6]))]; claimed.add(o); added += 1
        if not added: break
    return FM, EV
