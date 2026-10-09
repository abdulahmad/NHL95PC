"""List unattempted __CHK game functions (not in tools/c_functions.csv, no C block yet) by size.

usage: python3 tools/c_candidates.py [MIN [MAX]]   (bytes, default 0..300)
Columns: size, segment, name, address, instruction count, ext (jumps into another function's _retN tail), ret/noret.
"""
import re,glob,os,sys,csv
sys.path.insert(0,'tools')
import c_progress as cp, cc
done={r['function'] for r in csv.DictReader(open('tools/c_functions.csv'))}
out=[]
for f in sorted(glob.glob('src/cseg01/*.asm')):
    stem=os.path.basename(f)[:-4]
    if cp.is_lib(stem): continue
    L=open(f).read().split('\n')
    labs=[]
    for k,l in enumerate(L):
        m=cc.LABEL.match(l)
        if m and not m.group(1).startswith('.'):
            labs.append((k,m.group(1)))
    def addr(k):
        for x in L[k:k+6]:
            a=cc.ADDR.search(x)
            if a: return int(a.group(1),16) if a.groups() else None
    for i,(k,name) in enumerate(labs):
        ins=[x.split(';')[0].strip() for x in L[k+1:k+4] if cc.ADDR.search(x)]
        if not(len(ins)>=2 and ins[0].startswith('push dword') and ins[1]=='call __CHK'): continue
        if name in done: continue
        if k>0 and L[k-1].startswith('; C:') or (k>1 and '%ifdef CBUILD' in L[k-1]): continue
        # end = next non-local label that is __CHK function
        e=len(L)
        for k2,n2 in labs[i+1:]:
            ins2=[x.split(';')[0].strip() for x in L[k2+1:k2+4] if cc.ADDR.search(x)]
            if len(ins2)>=2 and ins2[1]=='call __CHK' or L[k2-1].startswith('; C:') : e=k2;break
            if any(L[j].startswith('; C:') for j in range(max(0,k2-3),k2)): e=k2;break
        body=[x for x in L[k:e] if cc.ADDR.search(x)]
        a0=re.search(r';\s*([0-9A-F]+)\s*$',body[0]); a1=re.search(r';\s*([0-9A-F]+)\s*$',body[-1])
        size=int(a1.group(1),16)-int(a0.group(1),16)+3 if a0 and a1 else 0
        ext=[x for x in body if re.search(r'\bjmp\s+(near\s+)?\w+_ret\d',x)]
        hasret=any(x.split(';')[0].strip()=='ret' or x.split(';')[0].strip().startswith('ret ') for x in body)
        out.append((size,stem[:3]+stem[9:],name,a0.group(1) if a0 else '?',len(body),'ext' if ext else '','ret' if hasret else 'noret'))
out.sort()
lo=int(sys.argv[1]) if len(sys.argv)>1 else 0
hi=int(sys.argv[2]) if len(sys.argv)>2 else 300
sel=[o for o in out if lo<=o[0]<=hi]
for o in sel: print(*o)
print(len(sel),'of',len(out))
