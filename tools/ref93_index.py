#!/usr/bin/env python3
"""Index column-0 labels in ref/93/src/*.asm (NHLPA93Genesis, fetched read-only) -> tools/ref93.pkl {lower_name: (name,file,line,comment)}"""
import os, re, glob, pickle
os.chdir(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
out = {}
for fn in sorted(glob.glob('ref/93/src/**/*.asm', recursive=True)):
    if fn.endswith('_stub.asm'): continue
    for i, ln in enumerate(open(fn, encoding='latin1'), 1):
        m = re.match(r'^([A-Za-z_][\w]*):?(?=\s|;|$)(.*)', ln.rstrip('\n'))
        if not m: continue
        rest = m.group(2).strip()
        if re.match(r'^(=|equ|rs\.|set|macro|rsset|dc\.)', rest, re.I) and not rest.startswith('dc.'):
            kind = 'equ'
        elif rest.startswith(('dc.', 'ds.')): kind = 'data'
        else: kind = 'label'
        out.setdefault(m.group(1).lower(), (m.group(1), os.path.basename(fn), i, rest.split(';', 1)[1].strip() if ';' in rest else '', kind))
pickle.dump(out, open('tools/ref93.pkl', 'wb'))
print(len(out), 'labels')
for k in ('setspa', 'randomd0', 'vtoa', 'updateplayers', 'asstab', 'penaltylist', 'creditslist', 'rngseed', 'begin', 'opening', 'setvideo', 'rtss', 'assgoalie', 'pucknothing', 'puckunflip', 'rtss2'):
    print(k, out.get(k))
