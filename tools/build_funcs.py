#!/usr/bin/env python3
"""Build function table + reference graph from tools/lst_index.pkl.
- IDA procs (end clipped to next function start), collapsed (FLIRT library) functions,
- synthetic functions for code IDA left outside procs (split at call targets and at
  Watcom 'push N / call __CHK' prologues), data/align chunks in code gaps.
Output tools/funcs.pkl: dict(funcs=[...], sym_addr, str_by_addr)"""
import pickle, bisect, re, sys
from collections import defaultdict
idx = pickle.load(open('tools/lst_index.pkl', 'rb'))
items, syms = idx['items'], idx['syms']
addrs = sorted(items)
CBASE, CEND = 0x10000, 0x10000 + 0xA7886
DBASE, DEND = 0xC0000, 0xC0000 + 0x3AB90
name2addr = {n: a for n, (s, a) in syms.items()}
def resolve(tok):
    if tok in name2addr: return name2addr[tok]
    m = re.match(r'(?:sub|loc|locret|byte|word|dword|unk|off|asc|stru|qword|flt|dbl|nullsub|j_sub|jpt|def)_([0-9A-F]+)$', tok)
    if m: return int(m.group(1), 16)
    return None

F = [dict(f) for f in idx['funcs']]
F.sort(key=lambda f: f['start'])
# clip ends
for i, f in enumerate(F):
    nxt = F[i+1]['start'] if i+1 < len(F) else None
    if f['kind'] == 'proc' and nxt is not None and f['end'] > nxt and f['start'] < nxt:
        f['end'] = nxt
# call targets
call_tgts = set()
for a, t, mn, seg in idx['refs']:
    if mn == 'call' or mn == 'jmp':
        v = resolve(t)
        if v is not None and mn == 'call': call_tgts.add(v)
# gaps in code object
def gaps(lo, hi, fl):
    out, prev = [], lo
    for f in fl:
        if f['start'] >= hi or f['end'] <= lo: continue
        if f['start'] > prev: out.append((prev, f['start']))
        prev = max(prev, f['end'])
    if prev < hi: out.append((prev, hi))
    return out
new = []
for lo, hi in gaps(CBASE, CEND, F):
    i = bisect.bisect_left(addrs, lo)
    cur = None
    while i < len(addrs) and addrs[i] < hi:
        a = addrs[i]; seg, kind, mn, ops, nm = items[a]
        nxt_a = addrs[i+1] if i+1 < len(addrs) else hi
        if kind == 'insn':
            prologue = mn == 'push' and i+1 < len(addrs) and items[addrs[i+1]][2] == 'call' and '__CHK' in items[addrs[i+1]][3]
            if cur is None or cur['kind'] != 'synth' or a in call_tgts or prologue:
                cur = dict(name=nm or 'code_%X' % a, start=a, end=None, kind='synth'); new.append(cur)
        else:
            k = 'align' if kind == 'align' else 'cdata'
            if cur is None or cur['kind'] != k or (nm and k == 'cdata'):
                cur = dict(name=nm or '%s_%X' % (k, a), start=a, end=None, kind=k); new.append(cur)
        cur['end'] = min(nxt_a, hi)
        i += 1
    # leading bytes without items
    if new and new[-1]['end'] is None: new[-1]['end'] = hi
F = sorted(F + new, key=lambda f: f['start'])
# fix: ensure contiguous ends inside gaps (item gaps)
for i, f in enumerate(F):
    if f['start'] < CEND:
        nxt = F[i+1]['start'] if i+1 < len(F) and F[i+1]['start'] < CEND else CEND
        if f['end'] < nxt and f['kind'] in ('synth', 'align', 'cdata'): f['end'] = nxt
# owner lookup
starts = [f['start'] for f in F]
def owner(a):
    j = bisect.bisect_right(starts, a) - 1
    if j >= 0 and F[j]['start'] <= a < F[j]['end']: return j
    return None
for f in F:
    f.update(callees=set(), callers=set(), strs=set(), data=set(), drefs_from_data=set())
strings = idx['strings']
for a, t, mn, seg in idx['refs']:
    v = resolve(t)
    if v is None: continue
    if seg == 'cseg01':
        j = owner(a)
        if j is None: continue
        f = F[j]
        if CBASE <= v < CEND:
            k = owner(v)
            if k is not None and k != j:
                if mn in ('call', 'jmp') or mn.startswith('j') or 'offset' in t or True:
                    f['callees'].add(k); F[k]['callers'].add(j)
        elif DBASE <= v < DEND:
            if v in strings: f['strs'].add(v)
            else: f['data'].add(v)
    else:  # data referencing code (function pointer tables)
        if CBASE <= v < CEND:
            k = owner(v)
            if k is not None: F[k]['drefs_from_data'].add(a)
pickle.dump(dict(funcs=F, strings=strings, name2addr=name2addr), open('tools/funcs.pkl', 'wb'))
from collections import Counter
print(Counter(f['kind'] for f in F), 'cseg funcs', sum(1 for f in F if f['start'] < CEND))
