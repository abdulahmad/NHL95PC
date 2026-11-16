#!/usr/bin/env python3
"""localize_labels.py - turn IDA's loc_XXXXX / locret_XXXXX jump targets into NASM local labels (source cleanup, phase 1).

  python3 tools/names/localize_labels.py [--dry-run]

A loc_ label belongs to the routine above it (the nearest label that is not loc_ / locret_). When every reference to
it is inside that routine, it becomes `.1`, `.2`, ... (numbered in order within the routine). A reference written
under a different NASM scope (after another global label inside the routine) uses the full name, `Routine.3`.
A loc_ label that another routine or file uses is dropped and every use becomes an address expression
`<Routine>+0<offset>h` (offset from the routine start in hex), so no placeholder name is left; the routine is
made global / extern where needed.
Only names change: ./build.sh must still print MATCH. Then run tools/build/update_symbols.py and
tools/match/gen_cheaders.py.
"""
import collections, glob, os, re, sys
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'build'))
import asmaddr

LOC = re.compile(r'^(?:loc|locret)_[0-9A-F]+$')
DEF = re.compile(r'^([A-Za-z_.][\w@$?.]*):')
TOK = re.compile(r'(?<![\w.$?@])((?:loc|locret)_[0-9A-F]+)\b')


def main():
    dry = '--dry-run' in sys.argv
    files = asmaddr.asm_files()
    text = {f: open(f, encoding='latin1').read().split('\n') for f in files}
    owner = {}          # loc label -> (file, routine, scope label at its definition, line)
    span = {}           # (file, routine) -> (first line, last line)
    for f in files:
        L = text[f]; rout = None; scope = None; start = 0
        for k, l in enumerate(L):
            m = DEF.match(l)
            if not m or m.group(1).startswith('.'): continue
            n = m.group(1)
            if LOC.match(n):
                if rout is None: continue
                owner[n] = (f, rout, k)
            else:
                if rout is not None: span[(f, rout)] = (start, k - 1)
                rout = n; start = k
        if rout is not None: span[(f, rout)] = (start, len(L) - 1)
    # references
    refs = collections.defaultdict(list)    # loc -> [(file, line)]
    for f in files:
        for k, l in enumerate(text[f]):
            if l.startswith(('global ', 'extern ')): continue
            code = l.split(';')[0]
            for t in TOK.findall(code):
                if DEF.match(l) and l.startswith(t + ':') and code.strip() == t + ':': continue
                refs[t].append((f, k))
    # the SDL2 port names game addresses as SYM_<label> (tools/build/gen_port_syms.py): those labels stay global
    portfiles = [p for p in glob.glob(os.path.join(ROOT, 'port', '**', '*'), recursive=True)
                 if p.endswith(('.c', '.h', '.txt', '.md')) and os.path.isfile(p)]
    portuse = set()
    for p in portfiles:
        portuse.update(re.findall(r'\bSYM_((?:loc|locret)_[0-9A-F]+)\b', open(p, encoding='latin1').read()))
    local, keep = {}, {}
    for n, (f, rout, k) in owner.items():
        a, b = span[(f, rout)]
        if n not in portuse and all(rf == f and a <= rk <= b for rf, rk in refs[n]): local[n] = (f, rout)
        else: keep[n] = (f, rout)
    # names
    A = {f: asmaddr.addrs(f) for f in files}

    def addr_at(f, k):
        idx = [i for i in sorted(A[f]) if i >= k]
        return A[f][idx[0]] if idx else None
    newname = {}
    used = set()
    for f in files:
        for l in text[f]:
            m = DEF.match(l)
            if m: used.add(m.group(1))
    for n, (f, rout) in keep.items():
        k = owner[n][2]
        off = addr_at(f, k) - addr_at(f, span[(f, rout)][0])
        newname[n] = '%s+0%Xh' % (rout, off)
    count = collections.Counter()
    order = sorted(local, key=lambda n: (local[n][0], owner[n][2]))
    for n in order:
        f, rout = local[n]
        count[(f, rout)] += 1
        newname[n] = '.%d' % count[(f, rout)]
    print('%d loc labels: %d become local, %d stay global (used by another routine)' % (len(owner), len(local), len(keep)))
    if dry: return
    for p in portfiles:
        s = open(p, encoding='latin1').read()
        s2 = re.sub(r'\bSYM_((?:loc|locret)_[0-9A-F]+)\b', lambda m: 'SYM_' + newname.get(m.group(1), m.group(1)), s)
        if s2 != s: open(p, 'w', encoding='latin1').write(s2)
    # rewrite: per file, track the NASM scope (last non-local label) of every line
    for f in files:
        L = text[f]; scope = None; out = []
        # scope of each local label's definition (after renaming: the kept / named label above it)
        defscope = {}
        sc = None
        for k, l in enumerate(L):
            m = DEF.match(l)
            if m:
                n = m.group(1)
                if n in local and local[n][0] == f: defscope[n] = sc
                elif not n.startswith('.') and n not in keep: sc = n
        changed = False
        for k, l in enumerate(L):
            m = DEF.match(l)
            if m and not m.group(1).startswith('.') and not (m.group(1) in local) and not (m.group(1) in keep):
                scope = newname.get(m.group(1), m.group(1))
            if l.startswith(('global ', 'extern ')):
                names = [x.strip() for x in l[7:].split(',')]
                names2 = []
                for x in names:
                    if x in local: continue
                    y = keep[x][1] if x in keep else x
                    if y not in names2: names2.append(y)
                nl = (l[:7] + ', '.join(names2)) if names2 else None
                if nl != l: changed = True
                if nl is not None: out.append(nl)
                continue

            def sub(mm):
                n = mm.group(1)
                if n not in newname: return n
                if n in local:
                    s = defscope.get(n)
                    return newname[n] if s == scope else '%s%s' % (s, newname[n])
                return newname[n]
            code, sep, com = l.partition(';')
            if m and m.group(1) in keep and keep[m.group(1)][0] == f and code.strip() == m.group(1) + ':':
                changed = True
                if com.strip(): out.append(';' + com)
                continue
            if m and m.group(1) in local:
                nl = newname[m.group(1)] + ':' + code[len(m.group(1)) + 1:] + sep + com
            else:
                nl = TOK.sub(sub, code) + sep + com
            if nl != l: changed = True
            out.append(nl)
        if changed:
            out = compact(out)
            # routines whose inner labels are used from other files must be global / extern
            txt = '\n'.join(out)
            need = set()
            for n, (kf, rout) in keep.items():
                if re.search(r'(?<![\w.$?@])' + re.escape(rout) + r'\+0[0-9A-F]+h', txt):
                    need.add((rout, 'global' if kf == f else 'extern'))
            for rout, kw in sorted(need):
                if re.search(r'^(?:global|extern) [^\n]*(?<![\w$])' + re.escape(rout) + r'(?![\w$])', txt, re.M): continue
                if kw == 'extern' and re.search(r'^' + re.escape(rout) + r':', txt, re.M): continue
                k = next((i for i, l in enumerate(out) if l.startswith(kw + ' ')), None)
                if k is None: k = next(i for i, l in enumerate(out) if l.startswith('%include')) + 1; out.insert(k, kw + ' ' + rout)
                else: out[k] = out[k] + ', ' + rout
            open(f, 'w', encoding='latin1').write('\n'.join(compact(out)))


def compact(L):
    """rejoin the global / extern lists, 8 names a line"""
    out = []; k = 0
    while k < len(L):
        kw = next((x for x in ('global ', 'extern ') if L[k].startswith(x)), None)
        if kw is None: out.append(L[k]); k += 1; continue
        j = k; names = []
        while j < len(L) and L[j].startswith(kw):
            names += [x.strip() for x in L[j][7:].split(',') if x.strip()]; j += 1
        out += [kw + ', '.join(names[i:i + 8]) for i in range(0, len(names), 8)]
        k = j
    return out


if __name__ == '__main__':
    main()
