#!/usr/bin/env python3
"""Per-function features: I/O ports, software interrupts, FPU use, 4CC constants,
library callees. Writes tools/features.pkl (index aligned with funcs.pkl)."""
import pickle, re, bisect
D = pickle.load(open('tools/funcs.pkl', 'rb')); F = D['funcs']; st = [f['start'] for f in F]
idx = pickle.load(open('tools/lst_index.pkl', 'rb')); items = idx['items']
feat = [dict(ports=set(), ints=set(), fpu=0, n=0, fourcc=set(), dxconst=set()) for _ in F]
last_dx = {}
for a in sorted(items):
    seg, k, mn, ops, nm = items[a]
    if seg != 'cseg01' or k != 'insn': continue
    j = bisect.bisect_right(st, a) - 1
    if j < 0 or not (F[j]['start'] <= a < F[j]['end']): continue
    fe = feat[j]; fe['n'] += 1
    o = ops.split(';')[0].strip()
    if mn == 'mov' and re.match(r'(e?dx|dx),\s*([0-9A-F]+)h?$', o):
        v = re.match(r'(e?dx|dx),\s*([0-9A-F]+)(h?)$', o)
        val = int(v.group(2), 16 if v.group(3) else 10); fe['dxconst'].add(val); last_dx[j] = val
    if mn in ('in', 'out'):
        m = re.search(r'\b([0-9A-F]+)h?\b', o.replace('al', '').replace('ax', '').replace('eax', ''))
        if 'dx' in o:
            fe['ports'].add(last_dx.get(j, -1))
        else:
            m = re.search(r'([0-9A-F]+)h', o) or re.search(r'\b(\d+)\b', o)
            if m: fe['ports'].add(int(m.group(1), 16) if o.find('h') >= 0 else int(m.group(1)))
    if mn == 'int':
        m = re.match(r'([0-9A-F]+)h?', o)
        if m: fe['ints'].add(o)
    if mn.startswith('f') and mn not in ('fs',): fe['fpu'] += 1
pickle.dump(feat, open('tools/features.pkl', 'wb'))
