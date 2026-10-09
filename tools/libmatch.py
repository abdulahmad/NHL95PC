#!/usr/bin/env python3
"""Match Watcom library modules (OMF .LIB) against HOCKEY.EXE cseg01 code with fixup bytes masked.
Usage: libmatch.py LIB [LIB...]  -> per-lib summary + per-module hits (json in build/libmatch_<tag>.json)"""
import sys, os, json, re
sys.path.insert(0, os.path.dirname(__file__))
import omf
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
d = open(os.path.join(ROOT, 'HOCKEY.EXE'), 'rb').read()
CODE_OFF, CODE_LIN, CODE_LEN = 0x5F254, 0x10000, 0xA7886
code = d[CODE_OFF:CODE_OFF + CODE_LEN]

def match_seg(data, mask):
    n = len(data)
    if n < 8: return []
    # longest unmasked run as anchor
    best = (0, 0); i = 0
    while i < n:
        if mask[i]: i += 1; continue
        j = i
        while j < n and not mask[j]: j += 1
        if j - i > best[1] - best[0]: best = (i, j)
        i = j
    a, b = best
    if b - a < 6: return []
    anchor = bytes(data[a:b]); hits = []
    start = 0
    while True:
        k = code.find(anchor, start)
        if k < 0: break
        base = k - a
        if base >= 0 and base + n <= len(code) and all(mask[x] or code[base + x] == data[x] for x in range(n)):
            hits.append(base)
        start = k + 1
    return hits

def best_score(data, mask, minrun=10):
    """partial match: try every unmasked run >= minrun bytes as anchor; return (score, base) maximising matching unmasked bytes."""
    n = len(data); runs = []; i = 0
    while i < n:
        if mask[i]: i += 1; continue
        j = i
        while j < n and not mask[j]: j += 1
        if j - i >= minrun: runs.append((i, j))
        i = j
    runs.sort(key=lambda r: r[0] - r[1]); cands = set()
    for a, b in runs[:12]:
        anc = bytes(data[a:b]); k = code.find(anc)
        c = 0
        while k >= 0 and c < 20:
            cands.add(k - a); k = code.find(anc, k + 1); c += 1
    best = (0.0, None); tot = sum(1 for x in range(n) if not mask[x]) or 1
    for base in cands:
        if base < 0 or base + n > len(code): continue
        m = sum(1 for x in range(n) if not mask[x] and code[base + x] == data[x])
        if m / tot > best[0]: best = (m / tot, base)
    return best

def run(lib):
    mods = omf.parse_lib(lib); res = []
    for m in mods:
        for s in m['segs']:
            if s['cls'].upper() != 'CODE' or len(s['data']) < 8: continue
            h = match_seg(s['data'], s['mask'])
            sc, bb = (1.0, None) if h else best_score(s['data'], s['mask'])
            res.append(dict(module=m['name'], seg=s['name'], size=len(s['data']), pubs=[p[0] for p in m['pubs'] if p[1] == s['name']],
                            hits=['%05X' % (CODE_LIN + x) for x in h], best=round(sc, 4), best_at=('%05X' % (CODE_LIN + bb)) if bb is not None else None))
    return res

if __name__ == '__main__':
    for lib in sys.argv[1:]:
        r = run(lib)
        hit = [x for x in r if x['hits']]
        near = [x for x in r if not x['hits'] and x['best'] >= 0.8]
        print('%-50s mods=%4d exact=%4d (%6d B)  near(>=80%%)=%3d (%6d B)' % (lib.split('watcom/')[-1], len(r), len(hit), sum(x['size'] for x in hit), len(near), sum(x['size'] for x in near)))
        tag = re.sub(r'[^A-Za-z0-9]+', '_', lib.split('watcom/')[-1])
        json.dump(r, open(os.path.join(ROOT, 'build', 'libmatch_%s.json' % tag), 'w'), indent=1)
