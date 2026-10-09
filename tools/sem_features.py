#!/usr/bin/env python3
"""Semantic features for Genesis routines (93G/94G source) and PC functions (listing).
Writes tools/sem_feat.pkl = dict(gen=[...], pc={addr: {...}}, structfields={name: off}, genram={game:{sym}})"""
import os, re, glob, pickle
from collections import Counter
os.chdir(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
# ---- struct equates (94 stubinc/equals.inc uses 93 names, 94 values)
SF = {}
for ln in open('ref/94/src/stubinc/equals.inc', encoding='latin1'):
    m = re.match(r'^(\w+)\s+equ\s+\$([0-9A-Fa-f]+)', ln)
    if m: SF[m.group(1)] = int(m.group(2), 16)
PLAYER = ['Xpos','attribute','frame','oldframe','VRoffs','VRchar','Ypos','Zpos','OldXpos','OldYpos','OldZpos','Xvel','Yvel','Zvel','impactp','limpact','impact','position','assnum','asslist','temp1','temp2','temp3','temp4','temp5','radiusx','radiusy','Wallcos','Wallsin','SCnum','facedir','SPA','SPAnum','SPAcnt','nopuck','newpos','newpnum','pflags','pflags2','glitch','pnum','weight','legstr','legspd','aioff','aidef','shotspd','shotacc','passacc','rostnum','spodds','stickhand','endurance','handed']
POFF = {SF[n]: n for n in PLAYER if n in SF}
for o in range(0, 0x80, 1):
    if o not in POFF: pass
# ---- RAM symbols
def ramsyms(path_glob):
    out = set()
    for fn in glob.glob(path_glob):
        for ln in open(fn, encoding='latin1'):
            code = ln.partition(';')[0]
            m = re.match(r'^([A-Za-z_]\w*)\s+(rs\.[bwl]|ds\.[bwl]|=|equ)\s*(.*)', code)
            if not m or m.group(1) in SF: continue
            rhs = m.group(3).strip()
            if m.group(2) in ('=', 'equ'):
                # keep only address-valued equates (RAM addresses or expressions over RAM symbols)
                if not (re.match(r'^\$FF[0-9A-Fa-f]{4,6}$', rhs) or re.search(r'[A-Za-z_]{3,}', rhs)): continue
            out.add(m.group(1))
    return out
RAM = {'93G': ramsyms('ref/93/src/ram93.asm'), '94G': ramsyms('ref/94/src/ram94.asm') | ramsyms('ref/94/src/stubinc/ram_addrs.inc')}
LBL = re.compile(r'^([A-Za-z_][\w]*):?(?=\s|;|$)')
def parse_game(game, files):
    labels = []
    for path in files:
        fn = os.path.basename(path); cur = None
        for i, ln in enumerate(open(path, encoding='latin1')):
            ln = ln.rstrip('\n')
            m = LBL.match(ln)
            if m:
                code = ln[m.end():].partition(';')[0]
                if re.match(r'\s*(equ|=|set|rs\b|rs\.|macro|equr)', code, re.I): continue
                cur = dict(game=game, name=m.group(1), file=fn, line=i + 1, body=[]); labels.append(cur)
                if code.strip(): cur['body'].append(code.strip())
                continue
            if cur is None: continue
            code = ln.partition(';')[0].strip()
            if code: cur['body'].append(code)
    names = {L['name'] for L in labels}
    for L in labels:
        b = L['body']
        first = b[0].split()[0].lower() if b else ''
        L['kind'] = 'data' if (not b or first.startswith(('dc.', 'ds.', 'dcb', 'string', 'incbin', 'even', 'align', 'cnop', 'rs'))) else 'code'
    dnames = {L['name'] for L in labels if L['kind'] == 'data'}
    out = []
    for L in labels:
        b = L['body']
        fields = []; glob_ = []; imms = []; calls = []; strs = []; nbr = 0; ninsn = 0
        for ins in b:
            ins = re.sub(r'^\.\w+:?\s+', '', ins)
            if ins.startswith('.') or ins.endswith(':') and ' ' not in ins: continue
            parts = ins.split(None, 1)
            op = parts[0].lower(); args = parts[1] if len(parts) > 1 else ''
            if op.startswith('.'): continue
            ninsn += 1
            base = op.split('.')[0]; w = op.split('.')[1] if '.' in op else ''
            if base in ('btst', 'bset', 'bclr', 'bchg'): w = 'b' if '(' in args else 'l'
            if base in ('bsr', 'jsr', 'bra', 'jmp'):
                t = re.match(r'\(?([A-Za-z_]\w*)', args)
                if t and t.group(1) in names and t.group(1) != L['name']: calls.append((t.group(1), base in ('bra', 'jmp')))
                continue
            if base.startswith('b') and base not in ('btst', 'bset', 'bclr', 'bchg') or base.startswith('db'): nbr += 1
            for disp, reg in re.findall(r'(-?\$?[0-9A-Fa-f]+|[A-Za-z_]\w*)?\((a[0-6])(?:,[ad]\d(?:\.[wl])?)?\)', args):
                if reg == 'a7': continue
                if disp in SF and disp in PLAYER: fields.append((disp, w, base))
                elif disp == '' and reg in ('a1', 'a2', 'a3', 'a4') and not args.strip().startswith('('):
                    fields.append(('Xpos', w, base))
                elif disp == '' and reg in ('a1','a2','a3','a4'): fields.append(('Xpos', w, base))
                elif re.match(r'^\$[0-9A-Fa-f]+$|^\d+$', disp or ''):
                    v = int(disp[1:], 16) if disp.startswith('$') else int(disp)
                    if v in POFF and reg in ('a1','a2','a3','a4'): fields.append((POFF[v], w, base))
            for s in re.findall(r'\(?([A-Za-z_]\w*)\)?\.?[wl]?', args):
                if (s in RAM.get(game, set()) or s in dnames) and s not in SF and s != L['name']:
                    glob_.append(s)
            for hx, dec in re.findall(r'#(?:\$([0-9A-Fa-f]+)|(-?\d+))\b', args):
                v = int(hx, 16) if hx else int(dec)
                if base in ('btst', 'bset', 'bclr', 'bchg') and 0 <= v < 32: v = 1 << (v & 7 if w == 'b' else v)
                imms.append(v & 0xFFFF)
            strs += re.findall(r"'([^']{3,})'", args)
        L.update(fields=fields, globals=glob_, imms=imms, calls=calls, strings=strs, nbr=nbr, ninsn=ninsn)
        del L['body']
        out.append(L)
    return out
G = []
G += parse_game('93G', [f for f in sorted(glob.glob('ref/93/src/*.asm')) if not f.endswith(('_stub.asm', 'ram93.asm'))])
G += parse_game('94G', [f for f in sorted(glob.glob('ref/94/src/*.asm')) if os.path.basename(f) not in ('nhl94.asm', 'ram94.asm')])
# ---- PC side
idx = pickle.load(open('tools/lst_index.pkl', 'rb')); items = idx['items']
FD = pickle.load(open('tools/funcs.pkl', 'rb')); F = FD['funcs']; n2a = FD['name2addr']; S = FD['strings']
addrs = sorted(a for a, it in items.items() if it[0] == 'cseg01' and it[1] == 'insn')
import bisect
WR = {'byte': 'b', 'word': 'w', 'dword': 'l'}
R8 = set('al bl cl dl ah bh ch dh'.split()); R16 = set('ax bx cx dx si di bp'.split())
def resolve(t):
    if t in n2a: return n2a[t]
    m = re.match(r'(?:byte|word|dword|unk|off|asc|stru|qword|flt|dbl|funcs|a[A-Z]\w*)_([0-9A-F]+)$', t)
    return int(m.group(1), 16) if m else None
PC = {}
for f in F:
    if f['kind'] not in ('proc', 'synth'): continue
    i = bisect.bisect_left(addrs, f['start']); j = bisect.bisect_left(addrs, f['end'])
    fields = []; glob_ = []; imms = []; calls = []; nbr = 0; ninsn = 0; strs = []
    for a in addrs[i:j]:
        _, _, mn, ops, _ = items[a]; ops = ops or ''
        if mn == 'call' and ops == '__CHK': continue
        ninsn += 1
        if mn in ('call', 'jmp'):
            t = ops.split()[-1]
            if t.startswith(('sub_', 'loc_')) or t.endswith('_'):
                v = resolve(t) if t.startswith(('sub_', 'loc_')) else n2a.get(t)
                if mn == 'call' or (v is not None and not (f['start'] <= v < f['end'])):
                    calls.append((t if v is None else v, mn == 'jmp'))
            continue
        if mn.startswith('j') or mn.startswith('loop'): nbr += 1
        w = ''
        m = re.search(r'\b(byte|word|dword) ptr', ops)
        if m: w = WR[m.group(1)]
        else:
            regs = re.findall(r'\b([a-d][lhx]|e[a-ds][xip]|[sd]i|e[sd]i|bp)\b', ops.split('[')[0] + (ops.split(']')[-1] if ']' in ops else ''))
            for r in regs:
                w = 'b' if r in R8 else 'w' if r in R16 else 'l'
        for reg, disp in re.findall(r'\[(e[a-ds][xip]|e[sd]i|ebp)\+([0-9A-F]+)h?\]', ops):
            fields.append((int(disp, 16), w, mn, reg))
        for t in re.findall(r'\b((?:byte|word|dword|unk|off|stru|asc|funcs)_[0-9A-F]{5,6}|a[A-Z]\w+)\b', ops):
            v = resolve(t)
            if v is not None and v >= 0xC0000: glob_.append(v)
            if v in S: strs.append(S[v])
        for t in re.findall(r'(?<![\w+\[])(-?[0-9][0-9A-F]*)h?\b(?!\])', ops.split('[')[0] if '[' not in ops else re.sub(r'\[[^\]]*\]', '', ops)):
            try: v = int(t, 16) if re.search(r'[A-F]', t) or ops.find(t + 'h') >= 0 else int(t)
            except ValueError: continue
            imms.append(v & 0xFFFF)
    PC[f['start']] = dict(name=f['name'], start=f['start'], end=f['end'], fields=fields, globals=glob_, imms=imms, calls=calls, strings=strs, nbr=nbr, ninsn=ninsn)
pickle.dump(dict(gen=G, pc=PC, SF=SF, PLAYER=PLAYER, RAM=RAM), open('tools/sem_feat.pkl', 'wb'))
c = Counter((g['game'], g['kind']) for g in G); print(c, 'pc funcs', len(PC))
