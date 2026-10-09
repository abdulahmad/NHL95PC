#!/usr/bin/env python3
"""Produce name_map_94.csv: evidence-based NHL94 name mapping.
Optional: if a local FUNCTION_MAPPINGS95.md is present (it is not in the repo), its claims are fact-checked
against the listing and written to tools/fm95_check.json (gitignored); its function addresses without a Genesis
match are also listed in the CSV as unmatched rows. The CSV itself has no FUNCTION_MAPPINGS95 columns.
Hand-made rows live in tools/manual_names.csv (committed, same columns as the CSV) and are merged in last
with priority: a manual row replaces whatever the evidence passes produced at that address, or is added.
A manual row with method 'manual-reject' and an empty proposed_name withdraws an automatic proposal (e.g. a
low-confidence name that a manual trace placed at another address); duplicate proposed names are reported.
Address universe for the 'unmatched' rows: FUNCTION_MAPPINGS95.md when present (default --universe auto),
otherwise every code function in tools/funcs.pkl (IDA procs + synthetic code functions from build_funcs.py).
Run after build_segmap.py.  Writes name_map_94.csv and tools/matcher_stats.json
  python3 tools/matcher.py [--universe auto|fm95|funcs] [--out name_map_94.csv]"""
import os, re, csv, json, pickle, bisect, argparse, sys
from collections import Counter
os.chdir(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
AP = argparse.ArgumentParser()
AP.add_argument('--universe', choices=('auto', 'fm95', 'funcs'), default='auto')
AP.add_argument('--out', default='name_map_94.csv')
AP.add_argument('--manual', default='tools/manual_names.csv')
ARGS = AP.parse_args()
FM95 = 'FUNCTION_MAPPINGS95.md'
UNIVERSE = ARGS.universe if ARGS.universe != 'auto' else ('fm95' if os.path.isfile(FM95) else 'funcs')
if UNIVERSE == 'fm95' and not os.path.isfile(FM95): sys.exit('--universe fm95 needs a local ' + FM95)
FD = pickle.load(open('tools/funcs.pkl', 'rb')); F = FD['funcs']; S = FD['strings']; n2a = FD['name2addr']
R = pickle.load(open('tools/ref94.pkl', 'rb'))
L94 = {}
for l in R['labels']: L94.setdefault(l['name'].lower(), l)
R93 = pickle.load(open('tools/ref93.pkl', 'rb'))
def _labels(globpat):
    import glob
    out = {}
    for fn in glob.glob(globpat, recursive=True):
        for ln in open(fn, encoding='latin1'):
            m = re.match(r'^([A-Za-z_][\w]*)', ln)
            if m: out.setdefault(m.group(1).lower(), os.path.basename(fn))
    return out
L92 = _labels('ref/92/**/*.asm') if os.path.isdir('ref/92') else {}
L95 = _labels('ref/95/src/*.asm')
for u in json.load(open('ref/95/units95.json')):
    L95.setdefault(str(u[3]).split('+')[0].split('/')[0].lower(), str(u[5]))
def lineage(n):
    """source game per user lineage: 93G first, then 94G, then 95G"""
    k = n.lower()
    if k in R93: return '93G', R93[k][1]
    if k in L94: return '94G', L94[k]['file']
    if k in L95: return '95G', L95[k]
    return 'PC-new', ''
def any_genesis(n):
    k = n.lower(); return k in R93 or k in L94 or k in L95 or k in L92
# listing text per address range (for FM95 fact checks)
LA, LT = [], []
def _load_lst():   # only needed for the optional FM95 cross-check
    for ln in open('HOCKEY.EXE.lst', encoding='latin1', errors='replace'):
        if ln.startswith('cseg01:'):
            try: LA.append(int(ln[7:15], 16)); LT.append(ln)
            except ValueError: pass
def rtext(a, b):
    if not LA: _load_lst()
    i = bisect.bisect_left(LA, a); j = bisect.bisect_left(LA, b)
    return ''.join(LT[i:j])
SG = pickle.load(open('tools/segs.pkl', 'rb'))
segs = SG['segs']; sst = [s['start'] for s in segs]
def segof(a):
    j = bisect.bisect_right(sst, a) - 1; return segs[j]['module'] if j >= 0 else ''
byaddr = {f['start']: i for i, f in enumerate(F)}
def f94(n):
    l = L94.get(n.lower()); return l['file'] if l else ''

# ---------------- evidence-based mappings ----------------
M = {}  # addr -> (proposed, conf, evidence, method, source_game)
# evidence-based matches from tools/sem_match.py (deep semantic pass); run sem_match.py first
SEM = json.load(open('tools/sem_matches.json'))['matches']
for k, v in SEM.items():
    M[int(k, 16)] = (v['name'], v['conf'], v['evidence'], v['method'], v['src'])
DATA = [(0xC9161, 'asstab', 'data94.asm', 'medium', 'code-pointer table (47 dseg->cseg fixups) dispatched by updateplayers; slots 0-$1C = 93G asstab (content-verified), slots $1D-$2E are PC-own assignments (94G $1D-$23 names fail content check)', '93G', 'hockey93_11.asm'),
        (0xC9100, 'StanleyCupTimer (RNG seed)', 'ram94.asm (RNGseed)', 'medium', 'seed of the randomd0 LCG port; 93G names the seed StanleyCupTimer, 94G RNGseed', '93G', 'ram93.asm'),
        (0xC1B40, 'PenaltyList', 'data94.asm', 'medium', 'penalty name strings in Genesis order (+ .pen file table D273E)', '93G', 'hockey93_11.asm'),
        (0xC5951, 'CreditsList', 'teamdata94.asm', 'high', 'credit names Chip Lange / Steve Babineau exist only in 94G (93G Credits lacks them)', '94G', 'teamdata94.asm'),
        (0xC053C, 'TeamList city names', 'teamdata94.asm', 'medium', 'team city string table incl. ANAHEIM/FLORIDA (26-team 94G list; 93G TeamList has 24)', '94G', 'teamdata94.asm'),
        (0xC020C, 'awards names (95G awards95 role)', '', 'low', 'award name strings (Conn Smythe ...) - same role as 95G awards95 table; PC text/case differs', '95G', 'awards95')]

# ---------------- FUNCTION_MAPPINGS95 (optional, local only) ----------------
rows95 = []
for ln in (open(FM95, encoding='utf-8', errors='replace') if os.path.isfile(FM95) else []):
    if not ln.startswith('| `'): continue
    c = [x.strip() for x in ln.strip().strip('|').split('|')]
    if len(c) < 5: continue
    rows95.append(dict(name=c[0].strip('`'), loc=c[1], gen=c[2], sugg=c[3].strip('`'), desc='|'.join(c[4:])))
def strs_of(f):
    out = [S[a] for a in f['strs'] if a in S] + [S[a] for a in f['data'] if a in S]
    return out
stat = Counter(); wrong = []; fm = {}
for r in rows95:
    m = re.search(r'([0-9A-Fa-f]{5,8})', r['loc']); a = int(m.group(1), 16) if m else None
    notes = []; bad = []; good = []
    i = byaddr.get(a)
    nm_addr = n2a.get(r['name'])
    if i is None: bad.append('no function starts at %s' % r['loc'])
    elif nm_addr is not None and nm_addr != a: bad.append('name %s is at %X not %X' % (r['name'], nm_addr, a))
    gnames = re.findall(r'`([^`]+)`', r['gen'])
    g = gnames[0] if gnames else ('' if r['gen'] in ('(PC-specific)', 'Unknown') else r['gen'])
    mine = M.get(a)
    if g:
        if not any_genesis(g):
            bad.append('Genesis name "%s" does not exist in the 92/93/94/95 Genesis sources' % g)
        else: good.append('Genesis label %s exists (%s)' % (g, lineage(g)[0]))
        if mine and mine[0].lower() != g.lower():
            bad.append('evidence maps this to %s' % mine[0])
        elif mine: good.append('agrees with evidence mapping')
    if i is not None:
        f = F[i]
        txt = rtext(f['start'], f['end'])
        cs = {F[k]['name'] for k in f['callees']} | {F[k]['name'] for k in f['callers']} | set(re.findall(r'\b\w+\b', txt))
        for s in set(re.findall(r'\b(sub_[0-9A-F]{5,6})\b', r['desc'])):
            (good if s in cs else bad).append('%s %s in xrefs' % (s, 'found' if s in cs else 'NOT'))
        libs = {x for x in re.findall(r'`([A-Za-z_][\w]*_)`', r['desc'])}
        for s in libs:
            (good if s in cs else bad).append('%s %s in xrefs' % (s, 'found' if s in cs else 'NOT'))
        q = [x for x in re.findall(r'"([^"]{4,})"|\'([^\']{4,})\'', r['desc'])]
        q = [x[0] or x[1] for x in q]
        fs = (' \x00'.join(strs_of(f)) + txt).lower()
        for s in q:
            frags = [x.strip() for x in re.split(r'<[^>]*>|%\w|\.\.\.', s) if len(x.strip()) >= 4]
            core = (max(frags, key=len) if frags else s).lower().replace('\\\\', '\\')[:20]
            (good if core in fs else bad).append('string "%s" %s' % (s[:30], 'found' if core in fs else 'NOT referenced'))
        fns = re.findall(r'\b([\w\-]+\.(?:sav|ppv|pal|fsh|qfs|cfg|dat|viv|mvi|kms|bin|txt|tim|pat))\b', r['desc'], re.I)
        for s in set(fns):
            stem = s.split('.')[0].lower()
            (good if stem in fs else bad).append('file name %s %s' % (s, 'found' if stem in fs else 'NOT referenced'))
    if bad:
        st = 'conflict'; wrong.append((r['name'], r['gen'], r['sugg'], '; '.join(bad)))
    elif good: st = 'confirmed'
    else: st = 'unverified'
    stat[st] += 1
    fm[a] = dict(status=st, name=r['sugg'], gen=g, note='; '.join(bad + good)[:300], fname=r['name'])

# ---------------- write CSV ----------------
cols = ['pc_address', 'ida_name', 'proposed_name', 'source_game', 'source_file', '94_source_file', 'other_game_names', 'confidence', 'evidence', 'segment', 'method']
def alt(n):
    k = n.lower(); o = []
    l94 = {'rtss': 'rtss2', 'assgoalie': 'assgoaliecpu', 'pucknothing': 'puckunflip'}
    if k in l94: o.append('94G ' + l94[k])
    if k in L92: o.append('92G ' + n)
    if k in L95: o.append('95G ' + n)
    return '; '.join(o)
out = []
done = set()
for a in sorted(M):
    n, c, e, meth, src = M[a]
    i = byaddr.get(a); ida = F[i]['name'] if i is not None else ''
    g, gf = lineage(n.replace('_body', ''))
    if src == 'PC-new': g, gf = 'PC-new', ''
    n94 = {'rtss': 'rtss2', 'assgoalie': 'assgoaliecpu', 'pucknothing': 'puckunflip'}.get(n, n)
    out.append(['%08X' % a, ida, n, g, gf, f94(n94.replace('_body', '')), alt(n), c, e, segof(a), meth]); done.add(a)
for a, n, fl, c, e, g, gf in DATA:
    out.append(['%08X' % a, '', n, g, gf, fl, '', c, e, 'dseg02', 'data']); done.add(a)
for i, f in enumerate(F):
    if f['kind'] == 'collapsed' or (f['kind'] == 'proc' and not f['name'].startswith(('sub_', 'nullsub', 'j_'))):
        if f['start'] in done: continue
        lib = 'watcom_clib' if f['kind'] == 'collapsed' else ('watcom_cstart' if f['name'] == 'start' else '')
        conf = 'high'
        ev = 'IDA FLIRT Watcom library signature (collapsed body %d bytes)' % (f['end'] - f['start']) if f['kind'] == 'collapsed' else 'IDA name from entry point / Watcom main_'
        p94 = ''
        if f['name'] == 'main_':
            p94 = 'main94.asm'; ev += '; role of 94 Begin (program entry -> front end), PC-specific body'
        if f['name'] == 'main_':
            out.append(['%08X' % f['start'], f['name'], 'main_ (role: Begin)', '93G', 'hockey93_01.asm', 'hockey94.asm', '94G Begin', 'low', ev, segof(f['start']), 'role'])
        else:
            out.append(['%08X' % f['start'], f['name'], f['name'], 'library', lib, '', '', conf, ev, segof(f['start']), 'flirt'])
        done.add(f['start'])
if UNIVERSE == 'fm95':
    univ = sorted(fm.items(), key=lambda t: t[0] or 0)
else:   # function list from the listing: IDA procs + synthetic code functions (build_funcs.py)
    univ = [(f['start'], dict(fname=f['name'])) for f in F if f['kind'] in ('proc', 'synth')]
for a, x in univ:
    if a in done: continue
    i = byaddr.get(a)
    sg = segof(a) if a else ''
    seggrp = next((q['group'] for q in segs if q['module'] == sg), '')
    sgame = 'library' if seggrp in ('watcom', 'dos4gw', 'ealib', 'eacsndf', 'sounddrv', 'eagfx') else 'PC-new'
    out.append(['%08X' % a if a is not None else '', F[i]['name'] if i is not None else x['fname'], '', sgame, '', '', '', 'none',
                'no Genesis counterpart established (front end/menus/PC libs are PC-original)', segof(a) if a else '', 'unmatched'])
# ---------------- hand-made rows (tools/manual_names.csv) win ----------------
manual = list(csv.DictReader(open(ARGS.manual, newline=''))) if os.path.isfile(ARGS.manual) else []
byrow = {r[0]: k for k, r in enumerate(out)}
n_repl = n_add = 0
for m in manual:
    a = '%08X' % int(m['pc_address'], 16)
    row = [m.get(c, '') for c in cols]; row[0] = a
    if not row[9]: row[9] = segof(int(a, 16))
    if not row[1] and byaddr.get(int(a, 16)) is not None: row[1] = F[byaddr[int(a, 16)]]['name']
    if a in byrow: out[byrow[a]] = row; n_repl += 1
    else: out.append(row); byrow[a] = len(out) - 1; n_add += 1
out.sort(key=lambda r: r[0])
dup = Counter(r[2] for r in out if r[2])
dups = {n: [r[0] for r in out if r[2] == n] for n, c in dup.items() if c > 1}
for n, al in sorted(dups.items()):
    print('warning: name %s proposed at %d addresses: %s' % (n, len(al), ' '.join(al)), file=sys.stderr)
with open(ARGS.out, 'w', newline='') as fh:
    w = csv.writer(fh); w.writerow(cols); w.writerows(out)
conf = Counter((r[3], r[7]) for r in out)
conf = {'%s/%s' % k: v for k, v in sorted(conf.items())}
gen_rows = [r for r in rows95 if r['gen'] not in ('(PC-specific)', 'Unknown')]
st = dict(csv_rows=len(out), universe=UNIVERSE, manual_rows=len(manual), manual_replaced=n_repl, manual_added=n_add,
          mapping_conf_94=dict(conf),
          library_rows=sum(1 for r in out if r[3] == 'library' and r[7] == 'high'))
st['duplicate_names'] = {n: al for n, al in sorted(dups.items())}
json.dump(st, open('tools/matcher_stats.json', 'w'), indent=1)
if rows95:   # local-only cross-check of FUNCTION_MAPPINGS95.md (gitignored output)
    json.dump(dict(fm95_rows=len(rows95), fm95_status=dict(stat), fm95_genesis_claims=len(gen_rows),
                   fm95_genesis_claims_invalid_name=sum(1 for r in gen_rows if re.findall(r'`([^`]+)`', r['gen']) and not L94.get(re.findall(r'`([^`]+)`', r['gen'])[0].lower())),
                   wrong_examples=wrong[:40]), open('tools/fm95_check.json', 'w'), indent=1)
print(json.dumps({k: v for k, v in st.items() if k != 'wrong_examples'}, indent=1))
for w_ in wrong[:25]: print(w_)
