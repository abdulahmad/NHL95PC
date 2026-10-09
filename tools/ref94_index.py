#!/usr/bin/env python3
"""Index the NHL 94 Genesis disassembly (ref/94/src/*.asm, fetched read-only) into
tools/ref94.pkl: per global label (file, order, kind code/data, comment, string
literals, call targets, referenced labels, immediates, data words)."""
import re, os, glob, pickle
SRC = 'ref/94/src'
ORDER = []  # file order from nhl94.asm include list
for ln in open('ref/94/src/nhl94.asm', encoding='latin1'):
    m = re.search(r'include\s+"?([\w/\\.]+\.asm)', ln, re.I)
    if m: ORDER.append(os.path.basename(m.group(1).replace('\\', '/')))
LBL = re.compile(r'^([A-Za-z_][\w]*):?(?=\s|;|$)')
labels = []
for path in sorted(glob.glob(SRC + '/*.asm')):
    fn = os.path.basename(path)
    if fn in ('nhl94.asm', 'ram94.asm'): continue
    cur = None
    for i, ln in enumerate(open(path, encoding='latin1')):
        ln = ln.rstrip('\n')
        if not ln.strip() or ln.lstrip().startswith(';') and not ln[:1].isalpha():
            if cur is not None and ln.lstrip().startswith(';'): pass
            continue
        m = LBL.match(ln)
        if m:
            rest = ln[m.end():]
            code, _, cmt = rest.partition(';')
            if re.match(r'\s*(equ|=|set|rs|macro|equr)\b', code, re.I): continue
            cur = dict(name=m.group(1), file=fn, line=i+1, comment=cmt.strip(), body=[], kind=None)
            labels.append(cur)
            ln = '\t' + code
            if not code.strip(): continue
        if cur is None: continue
        code, _, cmt = ln.partition(';')
        if code.strip(): cur['body'].append(code.strip())
for idx, L in enumerate(labels):
    body = L['body']
    first = body[0].split()[0].lower() if body else ''
    L['kind'] = 'data' if first.startswith(('dc.', 'ds.', 'dcb', 'string', 'incbin', 'even', 'align', 'cnop')) or first == '' else 'code'
    txt = '\n'.join(body)
    L['strings'] = [s for s in re.findall(r"'([^']{3,})'", txt)]
    L['calls'] = re.findall(r'\b(?:bsr|jsr|bra|jmp)(?:\.[wsbl])?\s+\(?([A-Za-z_]\w*)', txt)
    L['refs'] = set(re.findall(r'[A-Za-z_]\w*', txt))
    L['imms'] = re.findall(r'#\$?([0-9A-Fa-f]+)', txt)
    L['ninsn'] = len(body)
    L['order'] = idx
names = {L['name'] for L in labels}
for L in labels:
    L['calls'] = [c for c in L['calls'] if c in names]
    L['refs'] = sorted(r for r in L['refs'] if r in names and r != L['name'])
pickle.dump(dict(labels=labels, file_order=ORDER), open('tools/ref94.pkl', 'wb'))
from collections import Counter
print(len(labels), Counter(L['kind'] for L in labels), 'files', len(set(L['file'] for L in labels)))
print('include order:', ORDER)
