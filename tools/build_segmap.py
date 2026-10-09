#!/usr/bin/env python3
"""Build the NHL 95 PC segment map.
Inputs: HOCKEY.EXE, tools/lst_index.pkl, tools/funcs.pkl, tools/segdef.py
Outputs: segmap95pc.json, EXE_SEGMAP95PC.md (segment part; name-map summary appended by matcher.py),
         tools/func_module.pkl (function -> segment)
Run order: le_parse.py, lst_parse.py, build_funcs.py, features.py, build_segmap.py, matcher.py"""
import sys, json, pickle, bisect, hashlib, re, os
sys.path.insert(0, os.path.dirname(__file__))
import le_parse, segdef
os.chdir(os.path.join(os.path.dirname(__file__), '..'))
info, fixups, exe = le_parse.parse('HOCKEY.EXE')
idx = pickle.load(open('tools/lst_index.pkl', 'rb'))
FD = pickle.load(open('tools/funcs.pkl', 'rb')); F = FD['funcs']; S = FD['strings']; name2addr = FD['name2addr']
items = idx['items']
O1, O2 = info['objects']
CB, CE = O1['base'], O1['base'] + O1['virtual_size']
DB, DE = O2['base'], O2['base'] + O2['virtual_size']
DFILE_END = O2['base'] + O2['file_bytes']
fstarts = [f['start'] for f in F]
def fidx(a):
    j = bisect.bisect_right(fstarts, a) - 1
    return j if j >= 0 and F[j]['start'] <= a < F[j]['end'] else None

# ---------- cseg: curated + automatic Watcom split in library zone ----------
DPMI = {'__FreeDPMIBlocks_', '__ReAllocDPMIBlock_', 'RationalAlloc_', '__LinkUpNewMHeap_', '__CreateNewNHeap_',
        '__ExpandDGROUP_', '__AdjustAmount_', '__LastFree_', 'int386_', 'int386x_', '__int386x_', '_DoINTR_',
        'segread_', '__EnterWVIDEO_', 'sbrk_', '__brk_', '__Slash_C_', '_dos_getvect_', '_dos_setvect_'}
segs = []
curated = [c for c in segdef.CSEG if c[1] != 'LIBZONE']
LIBZ = [c for c in segdef.CSEG if c[1] == 'LIBZONE'][0][0]
for i, (s, m, g, d, conf, c94) in enumerate(curated):
    e = curated[i+1][0] if i+1 < len(curated) else LIBZ
    segs.append(dict(obj=1, start=s, end=e, module=m, group=g, desc=d, conf=conf, nhl94=c94))
# classify library-zone functions
lz = [i for i, f in enumerate(F) if LIBZ <= f['start'] < CE]
W = {}
for i in lz:
    f = F[i]
    W[i] = f['kind'] == 'collapsed' or (f['kind'] == 'proc' and not f['name'].startswith(('sub_', 'nullsub', 'j_sub')))
changed = True
while changed:
    changed = False
    for i in lz:
        f = F[i]
        if W[i] or f['kind'] in ('align', 'cdata'): continue
        cl = [k for k in f['callers'] if k in W]
        if f['callers'] and all(k in W and W[k] for k in f['callers']):
            W[i] = True; changed = True
# align/cdata inherit previous classification
prevw = False
for i in lz:
    if F[i]['kind'] in ('align', 'cdata'): W[i] = prevw
    prevw = W[i]
libnames = segdef.LIBNAMES
lstarts = [l[0] for l in libnames]
def libname(a):
    j = bisect.bisect_right(lstarts, a) - 1
    return libnames[j]
FORCE_WHOLE = {'watcom', 'dos4gw'}
raw = []
for i in lz:
    f = F[i]; a = f['start']
    ln = libname(a)
    if ln[2] in FORCE_WHOLE:
        key = (ln[1], ln[2], ln[3], ln[4])
    elif f['name'] in DPMI:
        key = ('dos4gw_dpmi_glue', 'dos4gw', 'Watcom clib routines specific to the DOS/4GW (DPMI/Rational) environment: ' , 'high')
    elif W[i]:
        key = ('watcom_clib', 'watcom', 'Watcom C/386 runtime (FLIRT-identified + clib-only helpers): ', 'high')
    else:
        key = (ln[1], ln[2], ln[3], ln[4])
    if a in lstarts and raw and raw[-1]['key'][0] == key[0] and key[1] not in ('watcom', 'dos4gw'):
        pass
    if raw and raw[-1]['key'] == key and not (a in lstarts and key[0] != 'watcom_clib'):
        raw[-1]['end'] = f['end']; raw[-1]['funcs'].append(i)
    else:
        raw.append(dict(start=a, end=f['end'], key=key, funcs=[i]))
# absorb tiny non-watcom fragments (<0x20 bytes, not data) sandwiched in watcom runs
merged = []
for r in raw:
    if merged and r['end'] - r['start'] < 0x20 and merged[-1]['key'][0] == 'watcom_clib' and r['key'][1] not in ('watcom', 'dos4gw'):
        merged[-1]['end'] = r['end']; merged[-1]['funcs'] += r['funcs']; continue
    if merged and merged[-1]['key'] == r['key']:
        merged[-1]['end'] = r['end']; merged[-1]['funcs'] += r['funcs']; continue
    merged.append(r)
for r in merged:
    m, g, d, conf = r['key']
    if m in ('watcom_clib', 'dos4gw_dpmi_glue'):
        names = [F[i]['name'] for i in r['funcs'] if F[i]['kind'] == 'collapsed' or not F[i]['name'].startswith(('sub_', 'code_', 'cdata', 'align', 'jpt', 'nullsub'))]
        d = d + (', '.join(names[:8]) + (' ...' if len(names) > 8 else '') if names else 'clib-only helpers')
    segs.append(dict(obj=1, start=r['start'], end=r['end'], module=m, group=g, desc=d, conf=conf, nhl94=''))
segs[-1]['end'] = CE
# disambiguate repeated module names
from collections import Counter
cnt = Counter(s['module'] for s in segs); seen = Counter()
for s in segs:
    if cnt[s['module']] > 1:
        seen[s['module']] += 1; s['module'] = '%s_%02d' % (s['module'], seen[s['module']])

# ---------- dseg: ownership by code references ----------
seg_starts = [s['start'] for s in segs]
def seg_of_code(a):
    j = bisect.bisect_right(seg_starts, a) - 1
    return segs[j]
def resolve(tok):
    if tok in name2addr: return name2addr[tok]
    m = re.match(r'(?:byte|word|dword|unk|off|asc|stru|qword|flt|dbl|funcs)_([0-9A-F]+)$', tok)
    return int(m.group(1), 16) if m else None
dref = {}
for a, t, mn, seg in idx['refs']:
    if seg != 'cseg01': continue
    v = resolve(t)
    if v is None or not (DB <= v < DE): continue
    dref.setdefault(v, Counter())[seg_of_code(a)['group']] += 1
labels = sorted(set([a for a, it in items.items() if it[0] == 'dseg02' and it[4]] + list(dref)))
labels = [a for a in labels if DB <= a < DE]
if labels[0] != DB: labels.insert(0, DB)
own = []
prev = 'unreferenced'
for k, a in enumerate(labels):
    c = dref.get(a)
    g = c.most_common(1)[0][0] if c else None
    own.append(g)
# build runs by group, splitting at end of initialized data
cuts = sorted(set([DFILE_END]))
runs = []
for k, a in enumerate(labels):
    e = labels[k+1] if k+1 < len(labels) else DE
    for cpos in cuts:
        pass
    g = own[k] or (runs[-1]['group'] if runs else 'data')
    if runs and runs[-1]['group'] == g and not (runs[-1]['start'] < DFILE_END <= a and runs[-1]['start'] < DFILE_END and a >= DFILE_END and runs[-1]['end'] <= DFILE_END):
        runs[-1]['end'] = e; runs[-1]['n'] += 1; runs[-1]['ref'] += 1 if own[k] else 0
    else:
        runs.append(dict(start=a, end=e, group=g, n=1, ref=1 if own[k] else 0))
# split a run crossing DFILE_END
fixed = []
for r in runs:
    if r['start'] < DFILE_END < r['end']:
        fixed.append(dict(r, end=DFILE_END)); fixed.append(dict(r, start=DFILE_END))
    else: fixed.append(r)
runs = fixed
# smooth: absorb runs < 0x40 into previous (record as mixed)
sm = []
for r in runs:
    if sm and (r['end'] - r['start'] < 0x40) and not (r['start'] == DFILE_END):
        sm[-1]['end'] = r['end']; sm[-1]['mixed'] = sm[-1].get('mixed', set()) | {r['group']}; continue
    if sm and sm[-1]['group'] == r['group'] and r['start'] != DFILE_END:
        sm[-1]['end'] = r['end']; continue
    sm.append(dict(r))
GROUPDESC = {'frontend': 'front end / menus / league & database UI', 'engine': 'in-game engine', 'season95': 'NHL 95 season/trade/create-player features',
             'ealib': 'EA in-house PC library (graphics/memory/files/input)', 'eacsndf': 'EACSNDF sound library', 'sounddrv': 'sound card drivers',
             'watcom': 'Watcom C runtime', 'dos4gw': 'DOS/4GW glue', 'eagfx': 'EA video/stream libs', 'data': 'data'}
dsegs = []
for k, r in enumerate(sm):
    bss = r['start'] >= DFILE_END
    kind = 'bss' if bss else 'initialized data'
    # sample strings
    strs = [S[a] for a in sorted(S) if r['start'] <= a < r['end']][:4]
    d = '%s for %s%s' % (kind, GROUPDESC.get(r['group'], r['group']), (' (also ' + ', '.join(sorted(r['mixed'])) + ')') if r.get('mixed') else '')
    if strs: d += '; e.g. ' + ' | '.join(repr(x[:24]) for x in strs)
    dsegs.append(dict(obj=2, start=r['start'], end=r['end'], module='data_%s_%02d' % (r['group'], k), group=r['group'], desc=d,
                      conf='medium' if not r.get('mixed') else 'low', nhl94=''))
dsegs[-1]['end'] = DE
# stack: Watcom places the stack at the end of BSS; ESP initial = object 2 end
STACKLOW = 0xF7B88   # unk_F7B88 referenced by Watcom start+1B9 (stack bottom); ESP init = 0xFAB90
tail = dsegs[-1]
assert tail['start'] < STACKLOW
tail['end'] = STACKLOW
dsegs.append(dict(obj=2, start=STACKLOW, end=DE, module='watcom_stack', group='watcom',
    desc='stack (0x3008 bytes): bottom unk_F7B88 referenced by Watcom cstart (start+1B9); top = LE initial ESP 2:0003AB90', conf='high', nhl94=''))
# named data counterparts (evidence-based)
DATA94 = [
 (0xC1B40, 'PenaltyList (data94) names', 'penalty name strings Roughing..Holding.. match 94 PenaltyList text'),
 (0xC5951, 'Credits / CreditsList (teamdata94)', 'shared credit names (Jim Simmons, Scott Orr, Chip Lange, Steve Babineau)'),
 (0xC053C, 'teamdata94 team city names', 'all 26 team cities incl. ANAHEIM/FLORIDA (94 teams)'),
 (0xC9161, 'asstab (93G hockey93_11 / 94G data94)', 'player-assignment function table, 47 entries; first 29 = 93G asstab order, next 7 = 94G additions'),
 (0xC9100, 'StanleyCupTimer (93G ram93) = RNGseed (94G ram94)', 'seed used by randomd0 port (LCG E62D/BB40)'),
]

# ---------- lineage (user: 94 PC <- 93G + some 94G + new menus; 95 PC <- 94 PC + 94G/95G additions) ----------
LIN = {'engine': '93G via 94 PC (+94G additions)', 'season95': '95G role only (season95/trade95/create95/awards95); PC-original code',
       'frontend': 'PC-new', 'watcom': 'library (Watcom)', 'dos4gw': 'library (DOS/4GW)', 'ealib': 'library (EA PC)',
       'eacsndf': 'library (EACSNDF)', 'sounddrv': 'library (EACSNDF drivers)', 'eagfx': 'library (EA PC)'}
ROLE95 = {'trades': '95G trade95 (role)', 'schedule': '95G trade95 schedule half (role)', 'create_player': '95G create95 (role)',
          'season_playoffs': '95G season95 / awards95 (role)'}
for s_ in segs + dsegs:
    s_['lineage'] = LIN.get(s_['group'], s_['group'])
    for k, v in ROLE95.items():
        if s_['module'].startswith(k): s_['nhl95g_role'] = v; s_['lineage'] = '95G role only; PC-original code (no 95G strings shared except award names)'

# ---------- assemble, file offsets, verification ----------
allsegs = segs + dsegs
for s in allsegs:
    o = O1 if s['obj'] == 1 else O2
    s['file_start'] = le_parse.lin2off(info, s['start'])
    last_in_file = min(s['end'], o['base'] + o['file_bytes']) - 1
    s['file_end'] = (le_parse.lin2off(info, last_in_file) + 1) if last_in_file >= s['start'] else None
    s['file_bytes'] = max(0, min(s['end'], o['base'] + o['file_bytes']) - s['start'])
    s['size'] = s['end'] - s['start']
    fl = [F[i]['name'] for i in range(len(F)) if s['start'] <= F[i]['start'] < s['end'] and F[i]['kind'] in ('proc', 'collapsed', 'synth')]
    s['n_funcs'] = len(fl)
    s['nhl94_data'] = [x[1] + ': ' + x[2] for x in DATA94 if s['start'] <= x[0] < s['end']]
ver = {}
for o, lst in ((O1, segs), (O2, dsegs)):
    ok_tile = lst[0]['start'] == o['base'] and lst[-1]['end'] == o['base'] + o['virtual_size'] and all(lst[i]['end'] == lst[i+1]['start'] for i in range(len(lst)-1)) and all(x['end'] > x['start'] for x in lst)
    objbytes = b''.join(exe[p['file_off']:p['file_off'] + p['size']] for p in o['pages'])
    cat = b''.join(exe[x['file_start']:x['file_start'] + x['file_bytes']] for x in lst if x['file_bytes'])
    want = objbytes[:min(o['virtual_size'], o['file_bytes'])]
    ver['obj%d' % o['num']] = dict(segments=len(lst), tiles_exactly=ok_tile, concat_equals_object_pages=(cat == want),
        bytes_compared=len(want), sha1=hashlib.sha1(want).hexdigest(), file_pad_after_vsize=o['file_bytes'] - len(want),
        bss_bytes=o['bss_bytes'])
# string cross-check: listing strings vs EXE bytes
good = bad = 0
for a, t in S.items():
    if not (DB <= a < DFILE_END) or '\\x' in t or len(t) < 4: continue
    off = le_parse.lin2off(info, a)
    raw_ = exe[off:off + 300]
    if t.encode('latin1') in raw_[:len(t) + 8]: good += 1
    else: bad += 1
ver['listing_strings_vs_exe'] = dict(matched=good, mismatched=bad)
# file-level regions
fr = []
reg = segdef.FILE_REGIONS
h = info['header']; le = info['le_off']
loader_end = le + h['import_proc_table_off']
# end of LE loader/fixup tables = start of data pages
dp = info['bound_mz_off'] + h['data_pages_off']
starts_ = [0, 0xF474, info['bound_mz_off'], le]
for i, (s0, m, g, d, conf) in enumerate(reg[:4]):
    e = starts_[i+1] if i+1 < 4 else dp
    fr.append(dict(file_start=s0, file_end=e, module=m, group=g, desc=d, conf=conf))
fr.append(dict(file_start=O1['file_start'], file_end=O1['file_end'], module='object1_cseg01_pages', group='le', desc='object 1 pages (see cseg01 segments)', conf='high'))
fr.append(dict(file_start=O2['file_start'], file_end=O2['file_end'], module='object2_dseg02_pages', group='le', desc='object 2 pages (see dseg02 segments)', conf='high'))
ver['file_regions_tile_exe'] = fr[0]['file_start'] == 0 and fr[-1]['file_end'] == len(exe) and all(fr[i]['file_end'] == fr[i+1]['file_start'] for i in range(len(fr)-1))
ver['stub_checks'] = dict(mz0=exe[0:2] == b'MZ', bw_at_F474=exe[0xF474:0xF476] == b'BW', bound_mz=exe[info['bound_mz_off']:info['bound_mz_off']+2] == b'MZ', le=exe[le:le+2] == b'LE')
out = dict(exe=dict(path='HOCKEY.EXE', size=len(exe), sha1=hashlib.sha1(exe).hexdigest()),
           toolchain=dict(compiler='Watcom C/C++ 32-bit (clib FLIRT names, __CHK stack checks, register calling convention, "WATCOM C Run-Time" copyright)',
                          extender='DOS/4GW Professional (4GWPRO.EXP, May 19 1994) bound with Rational DOS/16M loader; Watcom wstub before LE'),
           le_header={k: v for k, v in h.items()}, bound_mz_off=info['bound_mz_off'], le_off=le,
           objects=[{k: v for k, v in o.items() if k != 'pages'} | dict(page_count_in_file=len(o['pages']),
                     lin_to_file='file_off = %#x + (lin - %#x)' % (o['file_start'], o['base'])) for o in (O1, O2)],
           fixups=dict(count=info['fixup_count'], types=info['fixup_type_counts']),
           file_regions=fr, cseg01=segs, dseg02=dsegs, data_counterparts_94=[dict(addr='%X' % a, name=n, evidence=e) for a, n, e in DATA94],
           verification=ver)
json.dump(out, open('segmap95pc.json', 'w'), indent=1, default=lambda x: sorted(x) if isinstance(x, set) else str(x))
pickle.dump(dict(segs=segs, dsegs=dsegs), open('tools/segs.pkl', 'wb'))
print(json.dumps(ver, indent=1))
print('cseg segments', len(segs), 'dseg segments', len(dsegs))
