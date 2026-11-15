#!/usr/bin/env python3
"""split_modules.py - split and rename the code files of src/ from a map (source cleanup, phase 2).

  python3 tools/build/split_modules.py MAP [--dry-run]

Only text moves: every byte stays where it is, so `make fullcheck` must still print MATCH twice after a run.
The code files (rows `1 ...` of src/segments.txt) are read in link order as one stream and cut again where MAP says.
Each file is src/<module>/<last part of module>.asm, as today (one asm file per folder; cc.py finds it there).

MAP lines ('#' starts a comment):
  cut LABEL NEWMOD [header text]   a new file starts with the routine LABEL (with its header, C switch, jump table
                                   and padding in front of it); it runs to the next start
  rename OLDMOD NEWMOD [header]    the file that starts where OLDMOD starts today gets a new module path
  header MOD header text           a new header comment for MOD ('|' starts a new line)
Module paths are like engine/goalie (the file becomes src/engine/goalie/goalie.asm).

What it changes:
  src/**/<mod>.asm       the new files: header comment, `section s_<start>`, extern / global lines recomputed from
                         what each file defines and uses (with the labels the C fragments in build/c use: run a
                         CBUILD=1 build first)
  src/**/*.c             a C file follows the asm file that holds the file's own function; its `%include "c/..."`
                         and `; C: src/...` lines and tools/match/c_functions.csv follow it
  src/segments.txt, segmap*.json      the code rows
It refuses a cut that a short jump or a local label (Routine.local) would cross.
"""
import argparse, csv, glob, json, os, re, subprocess, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import asmaddr
ROOT = asmaddr.ROOT
SRC = asmaddr.SRC

LABEL = re.compile(r'^([A-Za-z_][\w@$?]*):')
TOK = re.compile(r'[A-Za-z_][\w@$?]*(?:\.[\w@$?]+)?')


def git(*a):
    return subprocess.run(['git'] + list(a), cwd=ROOT, check=True, capture_output=True, text=True).stdout


def read_rows():
    return [l.split() for l in open(os.path.join(SRC, 'segments.txt')) if l[:1].isdigit()]


def parse(path):
    """(header comment lines, extern names, global names, index of the first body line, body lines)"""
    L = open(path, encoding='latin1').read().split('\n')
    if L and L[-1] == '': L = L[:-1]
    hdr, ext, glb = [], [], []
    k = 0
    while k < len(L) and L[k].startswith(';'): hdr.append(L[k]); k += 1
    while k < len(L) and (L[k] in ('bits 32', '%include "hockey.inc"') or L[k].startswith(('section ', 'extern ', 'global '))):
        if L[k].startswith('extern '): ext += [x.strip() for x in L[k][7:].split(',')]
        if L[k].startswith('global '): glb += [x.strip() for x in L[k][7:].split(',')]
        k += 1
    return hdr, ext, glb, k, L[k:]


def block_start(lines, i):
    """first line of the routine at lines[i]: back over its header, `; C:` line, C switch, jump table and padding,
    to the previous routine's last code line or %endif"""
    k = i
    while k > 0:
        p = lines[k - 1]
        if p.startswith('%endif') or asmaddr.is_code(p) or asmaddr.INSN_MARK.match(p.strip()): break
        k -= 1
    return k


def module_of(rel):
    """module path of a src/ file: engine/logic for engine/logic/logic.asm, lib/ea/ea_gfx_06 for a lib slice"""
    d, b = os.path.split(rel[:-4])
    return d if os.path.basename(d) == b else rel[:-4]


def path_of(m, PATH):
    return PATH.get(m) or '%s/%s.asm' % (m, os.path.basename(m))


def wrap(kw, names):
    return ['%s %s' % (kw, ', '.join(names[j:j + 8])) for j in range(0, len(names), 8)]


def read_map(path):
    cuts, ren, hdr = [], {}, {}
    for ln in open(path):
        ln = ln.split('#', 1)[0].rstrip() if not ln.lstrip().startswith('header') else ln.rstrip('\n')
        p = ln.split(None, 3)
        if not p: continue
        if p[0] == 'cut':
            cuts.append((p[1], p[2]))
            if len(p) > 3: hdr[p[2]] = p[3]
        elif p[0] == 'rename':
            ren[p[1]] = p[2]
            if len(p) > 3: hdr[p[2]] = p[3]
        elif p[0] == 'header':
            hdr[p[1]] = ln.split(None, 2)[2]
        else:
            sys.exit('map: bad line %r' % ln)
    return cuts, ren, hdr


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('map'); ap.add_argument('--dry-run', action='store_true')
    a = ap.parse_args()
    CUTS, RENAME, HEADER = read_map(a.map)
    rows = read_rows()
    code = [r for r in rows if r[0] == '1']
    files = [(r, module_of(r[5])) for r in code]                             # (row, module path)
    PATH = {m: r[5] for r, m in files}
    old = {m: parse(os.path.join(SRC, r[5])) for r, m in files}
    for m in RENAME: assert m in old, 'rename: no module %s' % m
    stream = []          # (line, old module, line index in the old file)
    starts = []          # (stream index, new module, start address, old module whose start it is)
    for r, m in files:
        hdr, ext, glb, k0, body = old[m]
        starts.append((len(stream), RENAME.get(m, m), int(r[1], 16), m))
        stream += [(l, m, k0 + j) for j, l in enumerate(body)]
    lines = [s[0] for s in stream]
    A = {m: asmaddr.addrs(os.path.join(SRC, r[5])) for r, m in files}
    for lab, new in CUTS:
        idx = [k for k, l in enumerate(lines) if l == lab + ':']
        if len(idx) != 1: sys.exit('cut %s: label found %d times' % (lab, len(idx)))
        k = block_start(lines, idx[0])
        if stream[k][1] != stream[idx[0]][1]: sys.exit('cut %s crosses an old file boundary' % lab)
        om = stream[k][1]
        j = k
        while j < len(stream) and stream[j][2] not in A[om]: j += 1
        if j >= len(stream) or stream[j][1] != om: sys.exit('cut %s: no code after it' % lab)
        starts.append((k, new, A[om][stream[j][2]], None))
    starts.sort()
    names = [s[1] for s in starts]
    dup = {n for n in names if names.count(n) > 1}
    if dup: sys.exit('duplicate new module: %s' % ', '.join(sorted(dup)))
    for i in range(1, len(starts)):
        if starts[i][0] == starts[i - 1][0]: sys.exit('two files start at the same line: %s %s' % (starts[i - 1][1], starts[i][1]))
    end_code = int(code[-1][2], 16)
    new = []
    for i, (k, m, st, om) in enumerate(starts):
        k2 = starts[i + 1][0] if i + 1 < len(starts) else len(stream)
        en = starts[i + 1][2] if i + 1 < len(starts) else end_code
        part = stream[k:k2]
        new.append((m, st, en, [s[0] for s in part], sorted({s[1] for s in part}), om))
    # who defines each label
    defined = {}
    for m, st, en, body, oms, om in new:
        cur = None
        for l in body:
            x = LABEL.match(l)
            if x: defined.setdefault(x.group(1), m); cur = x.group(1)
            elif l.startswith('.') and cur and re.match(r'^\.[\w@$?]+:', l):
                defined.setdefault(cur + l.split(':')[0], m)
    # checks: no short jump and no Routine.local reference newly into another file
    olddef = {}
    for s in stream:
        x = LABEL.match(s[0])
        if x: olddef.setdefault(x.group(1), s[1]); cur0 = x.group(1)
        elif s[0].startswith('.') and re.match(r'^\.[\w@$?]+:', s[0]): olddef.setdefault(cur0 + s[0].split(':')[0], s[1])
    bad = []
    for m, st, en, body, oms, om in new:
        cur = None
        for l, srcm in zip(body, [s[1] for s in stream[[x[0] for x in starts][[n[0] for n in new].index(m)]:]]):
            x = LABEL.match(l)
            if x: cur = x.group(1)
            s = l.split(';')[0]
            jm = re.match(r'^\s*j\w+\s+short\s+([A-Za-z_][\w@$?.]*)', s)
            if jm and defined.get(jm.group(1), m) != m and olddef.get(jm.group(1)) == srcm: bad.append('%s: short jump to %s in %s' % (m, jm.group(1), defined[jm.group(1)]))
            for t in re.findall(r'\b([A-Za-z_][\w@$?]*\.[A-Za-z_0-9][\w@$?]*)\b', s):
                if t in defined and defined[t] != m and olddef.get(t) == srcm: bad.append('%s: %s is a local label of %s' % (m, t, defined[t]))
    if bad: sys.exit('refused:\n  ' + '\n  '.join(sorted(set(bad))))
    allglob_old = set(); allext_old = {}
    for m, (hdr, ext, glb, k0, body) in old.items():
        allglob_old.update(glb); allext_old[m] = ext
    dataglob = set()
    for r in rows:
        if r[0] != '1': dataglob.update(parse(os.path.join(SRC, r[5]))[2])

    def inc_tokens(body):
        t = set()
        for l in body:
            x = re.match(r'%include "(c/[^"]+\.inc)"', l.strip())
            if x:
                p = os.path.join(ROOT, 'build', x.group(1))
                if not os.path.isfile(p): sys.exit('%s missing: run a CBUILD=1 build first' % p)
                t.update(TOK.findall(open(p).read()))
        return t

    incnames = set()
    for f in ('structs.inc', 'x86enc.inc', 'hockey.inc'):
        if not os.path.isfile(os.path.join(SRC, 'inc', f)): continue
        incnames.update(TOK.findall(re.sub(r';.*', '', open(os.path.join(SRC, 'inc', f)).read())))
    uses = {}
    for m, st, en, body, oms, om in new:
        t = set()
        for l in body:
            s = l.split(';')[0]
            if s.lstrip().startswith('%include'): continue
            t.update(re.findall(r'[A-Za-z_][\w@$?]*', s))
        t |= {x.split('.')[0] for x in inc_tokens(body)} | inc_tokens(body)
        uses[m] = t
    out = {}
    for m, st, en, body, oms, om in new:
        here = {n for n, d in defined.items() if d == m and '.' not in n}
        order = {}
        for l in body:
            x = LABEL.match(l)
            if x and x.group(1) not in order: order[x.group(1)] = len(order)
        glb = sorted((n for n in here if n in allglob_old or any(n in uses[o] for o in uses if o != m)), key=lambda n: order[n])
        ext = sorted((n for n in uses[m] if n not in here and n not in incnames
                      and (n in defined or n in dataglob or n in allglob_old)), key=lambda n: n.lower())
        if m in HEADER: hdr = ['; ' + x.strip() for x in HEADER[m].split('|')]
        elif om is not None: hdr = old[om][0]
        else: sys.exit('no header for new module %s' % m)
        txt = hdr + ['bits 32', '%include "hockey.inc"', 'section s_%05X progbits alloc exec nowrite align=1' % st]
        txt += wrap('extern', ext) + wrap('global', glb) + body
        out[m] = (st, en, '\n'.join(txt) + '\n')
    # C files follow the asm file that holds their own function
    cmove = {}
    for c in sorted(glob.glob(os.path.join(SRC, '*', '**', '*.c'), recursive=True)):
        rel = os.path.relpath(c, SRC).replace(os.sep, '/')
        if rel.startswith('include/'): continue
        stem, fn = rel.rsplit('/', 1)
        if stem not in old: continue
        f = fn[:-2]
        d = defined.get(f) or RENAME.get(stem, stem)
        if d != stem: cmove['%s/%s' % (stem, f)] = '%s/%s' % (d, f)
    print('%d code files -> %d; %d C files move' % (len(files), len(new), len(cmove)))
    for m, st, en, body, oms, om in new:
        if om is None or RENAME.get(om, om) != om or len(oms) > 1:
            print('  %-32s %05X-%05X %6d lines  from %s' % (m, st, en, len(body), ', '.join(oms)))
    if a.dry_run: return
    same = {m for m, st, en, body, oms, om in new if om == m and oms == [m] and len(body) == len(old[m][4])}
    pat = re.compile(r'(?:(?<=\bc/)|(?<=\bsrc/)|(?<![\w/]))(' + '|'.join(re.escape(k) for k in sorted(cmove, key=len, reverse=True)) + r')(?=\.)') if cmove else None
    PATHNEW = {RENAME.get(m, m): (PATH[m] if RENAME.get(m, m) == m else None) for r, m in files}
    PATHNEW = {k: v for k, v in PATHNEW.items() if v}
    for r, m in files:
        if m in same: continue
        git('rm', '-q', '--cached', 'src/' + r[5]); os.remove(os.path.join(SRC, r[5]))
    for o, n in cmove.items():
        s, d = os.path.join(SRC, o + '.c'), os.path.join(SRC, n + '.c')
        os.makedirs(os.path.dirname(d), exist_ok=True)
        git('mv', s, d)
    for m, (st, en, txt) in out.items():
        if m in same: continue                  # untouched file: keep it as it is (the C path rewrite below covers it)
        if pat: txt = pat.sub(lambda x: cmove[x.group(1)], txt)
        p = os.path.join(SRC, path_of(m, PATHNEW))
        os.makedirs(os.path.dirname(p), exist_ok=True)
        open(p, 'w', encoding='latin1').write(txt)
        git('add', p)
    for d in sorted({os.path.dirname(os.path.join(SRC, r[5])) for r, m in files}, reverse=True):
        if os.path.isdir(d) and not os.listdir(d): os.rmdir(d)
    seg = open(os.path.join(SRC, 'segments.txt')).read().split('\n')
    hdrl = [l for l in seg if l.startswith('#')]
    oldmod = {int(r[1], 16): r[4] for r in code}
    newcode = ['1 %05X %05X %d %s %s' % (st, en, en - st, oldmod.get(st, m.replace('/', '_')), '%s/%s.asm' % (m, os.path.basename(m)))
               for m, (st, en, txt) in out.items()]
    newcode = ['%s %s' % (l.rsplit(' ', 1)[0], path_of(m, PATHNEW)) for l, m in zip(newcode, out)]
    data = [' '.join(r) for r in rows if r[0] != '1']
    open(os.path.join(SRC, 'segments.txt'), 'w').write('\n'.join(hdrl + newcode + data) + '\n')
    smp = glob.glob(os.path.join(ROOT, 'segmap*.json'))[0]
    sm = json.load(open(smp))
    base = sm['cseg01'][0]
    off = base['file_start'] - base['start'] if 'file_start' in base else None
    oldseg = {s['start']: s for s in sm['cseg01']}
    lst = []
    for m, (st, en, txt) in out.items():
        s = dict(oldseg.get(st, {}))
        s.update(obj=1, start=st, end=en, module=s.get('module', m.replace('/', '_')))
        if off is not None: s.update(file_start=st + off, file_end=en + off, file_bytes=en - st, size=en - st)
        if 'file' in base: s['file'] = path_of(m, PATHNEW)
        if st not in oldseg:
            s.update(desc=HEADER.get(m, '').replace('|', ' '), conf='subject split (cleanup phase 2)', group=m.split('/')[0])
        lst.append(s)
    sm['cseg01'] = lst
    json.dump(sm, open(smp, 'w'), indent=1)
    if cmove:
        for f in git('ls-files').split('\n'):
            if not f.endswith(('.asm', '.md', '.csv', '.txt', '.c', '.h', '.py', '.json')): continue
            p = os.path.join(ROOT, f)
            if not os.path.isfile(p): continue
            t = open(p, encoding='latin1').read()
            t2 = pat.sub(lambda x: cmove[x.group(1)], t)
            if t2 != t: open(p, 'w', encoding='latin1').write(t2)
    cf = os.path.join(ROOT, 'tools/match/c_functions.csv')
    if not os.path.isfile(cf): return
    R = list(csv.DictReader(open(cf, newline='')))
    for r in R:
        fn = r['function'].split()[0]
        if fn in defined: r['segment'] = defined[fn]
    w = csv.DictWriter(open(cf, 'w', newline=''), fieldnames=list(R[0].keys()), lineterminator='\n')
    w.writeheader(); w.writerows(R)


if __name__ == '__main__':
    main()
