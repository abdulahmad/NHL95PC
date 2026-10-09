import pickle,sys
D=pickle.load(open('tools/funcs.pkl','rb'));F=D['funcs'];S=D['strings']
X=pickle.load(open('tools/features.pkl','rb'))
lo,hi=int(sys.argv[1],16),int(sys.argv[2],16)
for i,f in enumerate(F):
    if not (lo<=f['start']<hi) or f['kind']=='align': continue
    named=sorted({F[k]['name'] for k in f['callees'] if not F[k]['name'].startswith(('sub_','code_','loc_','cdata','jpt','off_','dword','byte','word','unk'))})[:6]
    cl=sorted({'%X'%F[k]['start'] for k in f['callers']})[:3]
    x=X[i]
    print('%X %4X %s %-9s in%-2d%s out%-2d %s %s %s|%s'%(f['start'],f['end']-f['start'],f['kind'][0],f['name'][:9],len(f['callers']),cl,len(f['callees']),'P'+','.join('%X'%p for p in x['ports']) if x['ports'] else '', ','.join(x['ints']), ','.join(named),' ¦ '.join(S[a][:14] for a in sorted(f['strs']))[:50]))
