#!/usr/bin/env python3
"""Byte-compare Genesis numeric data tables (93G/94G dc.b/dc.w/dc.l) with dseg02 initialised data.
Encodings tried: bytes as-is; words as LE16; words widened to LE32; bytes widened to LE16; longs as LE32.
Writes tools/data_matches.json"""
import os, re, glob, json, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
os.chdir(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
import le_parse
info, fx, exe = le_parse.parse('HOCKEY.EXE')
O2 = info['objects'][1]
D = exe[O2['file_start']:O2['file_start'] + O2['file_bytes']]; DB = O2['base']
LBL = re.compile(r'^([A-Za-z_][\w]*):?(?=\s|;|$)')
def tables(game, files):
    out = []
    for path in files:
        cur = None
        for ln in open(path, encoding='latin1'):
            code = ln.partition(';')[0].rstrip()
            m = LBL.match(code)
            if m:
                cur = dict(game=game, name=m.group(1), file=os.path.basename(path), b=[], w=[], l=[], bad=False, order=[]); out.append(cur)
                code = code[m.end():]
            if cur is None: continue
            mm = re.match(r'\s*dc\.([bwl])\s+(.*)', code)
            if not mm:
                if code.strip() and not code.strip().startswith('.'): 
                    if cur['b'] or cur['w'] or cur['l']: cur = None
                continue
            sz = mm.group(1)
            for v in mm.group(2).split(','):
                v = v.strip()
                if re.match(r'^-?\$[0-9A-Fa-f]+$', v): x = int(v.replace('$', ''), 16) * (-1 if v.startswith('-') else 1)
                elif re.match(r'^-?\d+$', v): x = int(v)
                else: cur['bad'] = True; continue
                cur[sz].append(x); cur['order'].append(sz)
    return [t for t in out if (len(t['b']) + len(t['w']) + len(t['l'])) >= 6]
T = tables('93G', [f for f in glob.glob('ref/93/src/*.asm') if not f.endswith('_stub.asm')]) + \
    tables('94G', [f for f in glob.glob('ref/94/src/*.asm') if not f.endswith(('nhl94.asm',))])
def enc(vals, width):
    m = (1 << (8 * width)) - 1
    return b''.join((v & m).to_bytes(width, 'little') for v in vals)
res = []; seen = set()
for t in T:
    for sz, vals in (('b', t['b']), ('w', t['w']), ('l', t['l'])):
        if len(vals) < 6 or len(set(vals)) < 3: continue
        if sz == 'b': encs = [('bytes', enc(vals, 1)), ('bytes->le16', enc(vals, 2))]
        elif sz == 'w': encs = [('words->le16', enc(vals, 2)), ('words->le32', enc(vals, 4)), ('words->bytes', enc(vals, 1)) if max(abs(v) for v in vals) < 256 else None]
        else: encs = [('longs->le32', enc(vals, 4)), ('longs->le16', enc(vals, 2)) if max(abs(v) for v in vals) < 65536 else None]
        for e in encs:
            if not e: continue
            nm, pat = e
            if len(pat) < 8: continue
            hits = [m.start() for m in re.finditer(re.escape(pat), D)][:5]
            if hits and len(hits) <= 2:
                k = (t['name'], hits[0])
                if k in seen: continue
                seen.add(k)
                res.append(dict(game=t['game'], name=t['name'], file=t['file'], dtype=sz, n=len(vals), encoding=nm, pc=['%X' % (DB + h) for h in hits], nbytes=len(pat)))
json.dump(res, open('tools/data_matches.json', 'w'), indent=1)
print(len(T), 'tables;', len(res), 'matches')
for r in sorted(res, key=lambda r: -r['nbytes'])[:60]: print(r['game'], r['name'], r['file'], r['dtype'], r['n'], r['encoding'], r['pc'], r['nbytes'])
