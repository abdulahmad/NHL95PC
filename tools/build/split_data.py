#!/usr/bin/env python3
"""split_data.py - cut, rename and join the data files of src/ from a map. Only text moves: every byte stays where
it is, so the build must still print MATCH after a run.
  python3 tools/build/split_data.py MAP [--dry-run]
The data files (the rows of src/segments.txt whose object is the data object) are read in link order as one stream
of labelled lines and cut again where MAP says. MAP lines ('#' starts a comment):
  cut LABEL PATH [header text]     a new file src/PATH starts at the data label LABEL (with the comment lines just
                                   above it); it runs to the next start
  rename OLDPATH PATH [header]     the file that starts where src/OLDPATH starts today becomes src/PATH; when PATH is
                                   the file just before it, the two become one file (both all initialised data or
                                   both all BSS)
  header PATH header text          a new header comment for PATH ('|' starts a new line)
What it changes: the data files (header, `section s_<start>` with the old section's attributes, `extern` and
`global` lines recomputed: a label stays global when it was global, or when another file now uses it),
src/segments.txt (the data rows) and segmap*.json (the data object's list). Old paths of renamed or joined files are
rewritten in the other tracked text files. Run the full build after it, then tools/build/update_symbols.py.
"""
import argparse, glob, json, os, re, subprocess, sys
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(HERE))
SRC = os.path.join(ROOT, 'src')
sys.path.insert(0, HERE)
import asmaddr
LABEL = re.compile(r'^([A-Za-z_][\w@$?]*):')
EQU = re.compile(r'^([A-Za-z_][\w@$?]*)\s+equ\b', re.I)
TOK = re.compile(r'[A-Za-z_][\w@$?]*')


def git(*a):
    return subprocess.run(['git'] + list(a), cwd=ROOT, check=True, capture_output=True, text=True).stdout


def rows():
    return [l.split() for l in open(os.path.join(SRC, 'segments.txt')) if l[:1].isdigit()]


def data_obj(R):
    """the data object: the object of the last row (95 PC: 2, 96 PC: 4)"""
    return R[-1][0]


def parse(path):
    L = open(path, encoding='latin1').read().split('\n')
    if L and L[-1] == '': L = L[:-1]
    hdr, ext, glb, sec, inc = [], [], [], None, []
    k = 0
    while k < len(L) and L[k].startswith(';'): hdr.append(L[k]); k += 1
    while k < len(L) and (L[k] == 'bits 32' or L[k].startswith(('section ', 'extern ', 'global ', '%include '))):
        if L[k].startswith('%include ') and L[k] != '%include "hockey.inc"': inc.append(L[k])
        if L[k].startswith('extern '): ext += [x.strip() for x in L[k][7:].split(',')]
        if L[k].startswith('global '): glb += [x.strip() for x in L[k][7:].split(',')]
        if L[k].startswith('section '): sec = L[k]
        k += 1
    return hdr, ext, glb, sec, k, L[k:], inc


def wrap(kw, names):
    return ['%s %s' % (kw, ', '.join(names[j:j + 8])) for j in range(0, len(names), 8)]


def read_map(path):
    cuts, ren, hdr = [], {}, {}
    for ln in open(path):
        if ln.lstrip().startswith('header'):
            p = ln.rstrip('\n').split(None, 2); hdr[p[1]] = p[2]; continue
        ln = ln.split('#', 1)[0].rstrip()
        p = ln.split(None, 3)
        if not p: continue
        if p[0] == 'cut':
            cuts.append((p[1], p[2]))
            if len(p) > 3: hdr[p[2]] = p[3]
        elif p[0] == 'rename':
            ren[p[1]] = p[2]
            if len(p) > 3: hdr[p[2]] = p[3]
        else:
            sys.exit('map: bad line %r' % ln)
    return cuts, ren, hdr


def defs(line):
    m = LABEL.match(line) or EQU.match(line)
    return m.group(1) if m else None


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('map'); ap.add_argument('--dry-run', action='store_true')
    a = ap.parse_args()
    CUTS, REN, HEADER = read_map(a.map)
    R = rows(); DO = data_obj(R)
    drows = [r for r in R if r[0] == DO]
    old = {r[5]: parse(os.path.join(SRC, r[5])) for r in drows}
    for o in REN: assert o in old, 'rename: no data file %s' % o
    stream, starts = [], []   # stream: (line, old path, old line index); starts: (stream idx, new path, start, old path)
    for r in drows:
        hdr, ext, glb, sec, k0, body, inc = old[r[5]]
        starts.append((len(stream), REN.get(r[5], r[5]), int(r[1], 16), r[5]))
        stream += [(l, r[5], k0 + j) for j, l in enumerate(body)]
    lines = [s[0] for s in stream]
    A = {}
    for lab, new in CUTS:
        idx = [k for k, l in enumerate(lines) if LABEL.match(l) and LABEL.match(l).group(1) == lab]
        if len(idx) != 1: sys.exit('cut %s: label found %d times' % (lab, len(idx)))
        i = idx[0]; om = stream[i][1]
        k = i
        while k > 0 and stream[k - 1][1] == om and stream[k - 1][0].startswith(';'): k -= 1
        if k == 0 or stream[k - 1][1] != om: sys.exit('cut %s: at the start of %s (use rename)' % (lab, om))
        if om not in A: A[om] = asmaddr.addrs(os.path.join(SRC, om))
        j = i
        while j < len(stream) and stream[j][1] == om and stream[j][2] not in A[om]: j += 1
        if j >= len(stream) or stream[j][1] != om: sys.exit('cut %s: no data after it in %s' % (lab, om))
        starts.append((k, new, A[om][stream[j][2]], None))
    starts.sort()
    merged = []
    for s in starts:
        if merged and s[1] == merged[-1][1]: continue          # rename onto the file before: join
        merged.append(s)
    starts = merged
    names = [s[1] for s in starts]
    dup = sorted({n for n in names if names.count(n) > 1})
    if dup: sys.exit('duplicate new file: %s' % ', '.join(dup))
    rowof = {r[5]: r for r in drows}
    end_all = int(drows[-1][2], 16)
    new = []
    for i, (k, p, st, om) in enumerate(starts):
        k2 = starts[i + 1][0] if i + 1 < len(starts) else len(stream)
        en = starts[i + 1][2] if i + 1 < len(starts) else end_all
        part = stream[k:k2]
        oms = []
        for s in part:
            if s[1] not in oms: oms.append(s[1])
        new.append(dict(path=p, start=st, end=en, body=[s[0] for s in part], oms=oms, om=om))
    for n in new:
        kinds = set()
        for o in n['oms']:
            r = rowof[o]; size = int(r[2], 16) - int(r[1], 16); b = int(r[3])
            kinds.add('init' if b == size else ('bss' if b == 0 else 'mixed'))
        if len(kinds) > 1 or 'mixed' in kinds and len(n['oms']) > 1:
            sys.exit('%s: joins initialised data and BSS (%s)' % (n['path'], ', '.join(n['oms'])))
        n['kind'] = kinds.pop()
        o0 = rowof[n['oms'][0]]
        if n['kind'] == 'mixed':
            init_end = int(o0[1], 16) + int(o0[3])
            n['bytes'] = max(0, min(init_end, n['end']) - n['start'])
        else:
            n['bytes'] = n['end'] - n['start'] if n['kind'] == 'init' else 0
        sec = old[n['oms'][0]][3]
        n['section'] = re.sub(r's_[0-9A-Fa-f]+', 's_%05X' % n['start'], sec)
    defined = {}
    for n in new:
        for l in n['body']:
            d = defs(l)
            if d: defined.setdefault(d, n['path'])
    oldglob = set(); oldext = {}
    for o, (hdr, ext, glb, sec, k0, body, inc) in old.items(): oldglob.update(glb); oldext[o] = set(ext)
    allglob = set()      # every global of the code files (externs a data file may use)
    for r in R:
        if r[0] != DO: allglob.update(parse(os.path.join(SRC, r[5]))[2])
    incnames = set()
    for f in ('structs.inc', 'x86enc.inc', 'hockey.inc', 'spa.inc', 'symbols.inc'):
        p = os.path.join(SRC, 'inc', f)
        if os.path.isfile(p) and f != 'symbols.inc':
            incnames.update(TOK.findall(re.sub(r';.*', '', open(p, encoding='latin1').read())))
    uses = {}
    for n in new:
        t = set()
        for l in n['body']:
            s = l.split(';')[0]
            if s.lstrip().startswith('%'): continue
            d = defs(s)
            if d and LABEL.match(s): s = s[len(d) + 1:]
            elif d: s = s.split(None, 2)[2] if len(s.split(None, 2)) > 2 else ''
            t.update(TOK.findall(re.sub(r"'[^']*'|\"[^\"]*\"", ' ', s)))
        uses[n['path']] = t
    incdef = {}          # names a file gets from its own %include lines (spa.inc equates ...)
    for n in new:
        t = set()
        for o in n['oms']:
            for x in old[o][6]:
                f = re.match(r'%include "([^"]+)"', x)
                pth = os.path.join(SRC, 'inc', f.group(1)) if f else ''
                if os.path.isfile(pth): t.update(TOK.findall(re.sub(r';.*', '', open(pth, encoding='latin1').read())))
        incdef[n['path']] = t
    out = []
    for n in new:
        m = n['path']
        here = [d for d in (defs(l) for l in n['body']) if d]
        hs = set(here)
        glb = []
        for d in here:
            if d in glb: continue
            if d in oldglob or any(d in uses[o] and d not in incdef[o] for o in uses if o != m): glb.append(d)
        oe = set().union(*[oldext[o] for o in n['oms']])
        ext = sorted({t for t in uses[m] if t not in hs and t not in incnames and (t in defined or t in allglob or t in oe)},
                     key=str.lower)
        if m in HEADER: hdr = ['; ' + x.strip() for x in HEADER[m].split('|')]
        elif n['om'] is not None: hdr = old[n['om']][0]
        else: sys.exit('no header for new file %s' % m)
        incs = []
        for o in n['oms']:
            for x in old[o][6]:
                if x not in incs: incs.append(x)
        txt = hdr + ['bits 32', '%include "hockey.inc"'] + incs + [n['section']] + wrap('extern', ext) + wrap('global', glb) + n['body']
        n['text'] = '\n'.join(txt) + '\n'
        out.append(n)
    print('%d data files -> %d' % (len(drows), len(out)))
    for n in out:
        if n['om'] is None or n['path'] != n['om'] or len(n['oms']) > 1:
            print('  %-50s %05X-%05X %5d lines  from %s' % (n['path'], n['start'], n['end'], len(n['body']), ', '.join(n['oms'])))
    if a.dry_run: return
    same = {n['path'] for n in out if n['om'] == n['path'] and n['oms'] == [n['path']] and len(n['body']) == len(old[n['path']][5])}
    for r in drows:
        if r[5] in same: continue
        git('rm', '-q', '--cached', 'src/' + r[5]); os.remove(os.path.join(SRC, r[5]))
    for n in out:
        if n['path'] in same: continue
        p = os.path.join(SRC, n['path']); os.makedirs(os.path.dirname(p), exist_ok=True)
        open(p, 'w', encoding='latin1').write(n['text']); git('add', p)
    oldmod = {int(r[1], 16): r[4] for r in drows}
    seg = open(os.path.join(SRC, 'segments.txt')).read().split('\n')
    hdrl = [l for l in seg if l.startswith('#')]
    code = [' '.join(r) for r in R if r[0] != DO]
    newd = []
    for n in out:
        mod = oldmod.get(n['start']) or 'data_%s_%05X' % (n['path'].split('/')[1] if n['path'].count('/') > 1 else 'shared', n['start'])
        n['module'] = mod
        newd.append('%s %05X %05X %d %s %s' % (DO, n['start'], n['end'], n['bytes'], mod, n['path']))
    open(os.path.join(SRC, 'segments.txt'), 'w').write('\n'.join(hdrl + code + newd) + '\n')
    smp = sorted(glob.glob(os.path.join(ROOT, 'segmap*.json')))[0]
    sm = json.load(open(smp))
    key = next(k for k, v in sm.items() if isinstance(v, list) and v and isinstance(v[0], dict) and str(v[0].get('obj')) == DO)
    base = sm[key][0]
    off = base['file_start'] - base['start'] if 'file_start' in base else None
    oldseg = {s['start']: s for s in sm[key]}
    oldpath = {int(r[1], 16): r[5] for r in R if r[0] == DO}
    lst = []
    for n in out:
        t = oldseg.get(n['start'])
        if t and t['end'] == n['end'] and oldpath.get(n['start']) == n['path']:
            lst.append(t); continue                  # an untouched row keeps its entry as it is
        s = dict(t or {})
        if not s:
            prev = max((x for x in sm[key] if x['start'] < n['start']), key=lambda x: x['start'])
            s = {k: prev[k] for k in prev if k in ('obj', 'group', 'lineage', 'note')}
            if 'desc' in base: s['desc'] = HEADER.get(n['path'], '').replace('|', ' ')
            if 'conf' in base: s['conf'] = 'data split by subject'
        s.update(start=n['start'], end=n['end'], module=n['module'])
        if off is not None:
            fs = n['start'] + off if n['bytes'] else None          # a BSS row has no bytes in the file
            s.update(file_start=fs, file_end=min(n['start'] + n['bytes'], n['end']) + off if n['bytes'] else None,
                     file_bytes=n['bytes'], size=n['end'] - n['start'])
        if 'file' in base: s['file'] = n['path']
        lst.append(s)
    sm[key] = lst
    json.dump(sm, open(smp, 'w'), indent=1)
    # rewrite old paths of renamed / joined files in the other text files
    moved = {}
    for n in out:
        for o in n['oms']:
            if o != n['path'] and o not in {x['path'] for x in out}: moved[o] = n['path']
    if moved:
        pat = re.compile('|'.join(re.escape(k) for k in sorted(moved, key=len, reverse=True)))
        for f in git('ls-files').split('\n'):
            if not f.endswith(('.asm', '.inc', '.md', '.csv', '.txt', '.c', '.h', '.py', '.json')) or f == 'src/segments.txt': continue
            p = os.path.join(ROOT, f)
            if not os.path.isfile(p): continue
            t = open(p, encoding='latin1').read(); t2 = pat.sub(lambda x: moved[x.group(0)], t)
            if t2 != t: open(p, 'w', encoding='latin1').write(t2)


if __name__ == '__main__':
    main()
