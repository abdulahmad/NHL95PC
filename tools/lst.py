#!/usr/bin/env python3
"""print listing lines for cseg range: lst.py LO [HI]  (HI default: end of function at LO)"""
import sys, bisect, pickle, os, re
os.chdir(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
lo = int(sys.argv[1], 16)
if len(sys.argv) > 2: hi = int(sys.argv[2], 16)
else:
    F = pickle.load(open('tools/funcs.pkl', 'rb'))['funcs']; hi = [f['end'] for f in F if f['start'] == lo][0]
for ln in open('HOCKEY.EXE.lst', encoding='latin1'):
    if ln.startswith('cseg01:'):
        a = int(ln[7:15], 16)
        if lo <= a < hi:
            t = ln[16:].rstrip()
            if t.strip() and not t.strip().startswith(';') : print('%X %s' % (a, re.sub(r'\s+', ' ', t)[:150]))
        elif a >= hi: break
