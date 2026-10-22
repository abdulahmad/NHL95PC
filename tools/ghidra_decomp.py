#!/usr/bin/env python3
"""ghidra_decomp.py - decompile HOCKEY.EXE functions with Ghidra (headless) for first-pass C drafts.

  python3 tools/ghidra_decomp.py [FUNC ...] [--untouched] [--out build/ghidra/out] [--ghidra DIR] [--java-home DIR]

Ghidra has no loader for the LE format, so this rebuilds the two LE objects from build/parts (make extracts them
from the retail EXE): the code object is imported as a raw x86 32-bit binary at its LE base, the data object is
added as a second block (tools/ghidra/Nhl95Decomp.java). Every label of src/inc/symbols.inc and of the code
segments is applied, a function is created at every __CHK label (game and library), and the named functions (or
with --untouched every game __CHK function that has no C yet) are decompiled to OUT/<name>.c. The output is a
reading aid for a first pass: Watcom passes arguments in eax, edx, ebx, ecx, which Ghidra shows as in_EAX ...
unless the call site makes them clear. Ghidra: GHIDRA_HOME / --ghidra (default ~/tools/ghidra/ghidra_*), a JDK 21:
JAVA_HOME / --java-home (default ~/tools/jdk21). The project is temporary."""
import argparse, csv, glob, json, os, re, shutil, subprocess, sys, tempfile
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import cc, c_progress


def objects():
    """[(base, bytes)] of the LE objects, from build/parts, with the LE fixups applied (each a 32-bit address:
    target object base + offset), so the decompiler sees the real data and code addresses"""
    le = json.load(open(os.path.join(ROOT, 'build/parts/le.json')))
    man = json.load(open(os.path.join(ROOT, 'build/parts/manifest.json')))
    bufs = []
    for k, o in enumerate(le['objects']):
        buf = bytearray(o['virtual_size'])
        for m in man['segments']:
            if m['obj'] != k + 1 or not m['bytes'] or not m.get('file'): continue
            s = int(m['start'], 16) - o['base']
            d = open(os.path.join(ROOT, 'build/parts', m['file']), 'rb').read()
            buf[s:s + len(d)] = d
        bufs.append((o['base'], buf))
    for ln in open(os.path.join(ROOT, 'build/parts/le_fixups.tsv')):
        if ln.startswith('#'): continue
        _, src, tobj, toff = ln.split()
        src = int(src, 16); val = le['objects'][int(tobj) - 1]['base'] + int(toff, 16)
        for base, buf in bufs:
            if base <= src < base + len(buf) - 3: buf[src - base:src - base + 4] = val.to_bytes(4, 'little')
    return [(b, bytes(buf)) for b, buf in bufs]


def labels():
    """{address: name} from symbols.inc and every non-local label of the code segments"""
    out = {}
    for ln in open(os.path.join(ROOT, 'src/inc/symbols.inc')):
        p = ln[1:].split()
        if ln.startswith(';') and len(p) >= 2 and len(p[0]) == 5:
            try: out[int(p[0], 16)] = p[1]
            except ValueError: pass
    for asm in sorted(glob.glob(os.path.join(ROOT, 'src/cseg01/*.asm'))):
        L = open(asm).read().split('\n')
        for k, l in enumerate(L):
            m = cc.LABEL.match(l)
            if not m or m.group(1).startswith('.'): continue
            for l2 in L[k + 1:k + 40]:
                a = cc.ADDR.search(l2)
                if a: out.setdefault(int(a.group(1), 16), m.group(1)); break
    return out


def chk_functions():
    """{name: (address, segment, game?)} of every __CHK function"""
    out = {}
    for asm in sorted(glob.glob(os.path.join(ROOT, 'src/cseg01/*.asm'))):
        st = os.path.basename(asm)[:-4]
        for n, a in c_progress.c_functions(asm).items(): out[n] = (a, st, not c_progress.is_lib(st))
    return out


SMALL = {'s8': 'char', 'u8': 'uchar', 's16': 'short', 'u16': 'ushort', 's32': 'int', 'u32': 'uint'}


def simple_type(t):
    """a C type (without the name) -> void / char / uchar / short / ushort / int / uint / ptr / cptr / ucptr / sptr / iptr"""
    t = re.sub(r'\b(const|volatile|register|struct|union|signed\s+(?=int|short|long))\b', ' ', t)
    stars = t.count('*'); w = t.replace('*', ' ').split()
    w = [SMALL.get(x, x) for x in w]
    if 'char' in w or 'uchar' in w: b = 'uchar' if 'unsigned' in w or 'uchar' in w else 'char'
    elif 'short' in w or 'ushort' in w: b = 'ushort' if 'unsigned' in w or 'ushort' in w else 'short'
    elif 'void' in w: b = 'void'
    elif 'unsigned' in w or 'uint' in w: b = 'uint'
    else: b = 'int'
    if stars == 0: return b
    if stars > 1: return 'ptr'
    return {'char': 'cptr', 'uchar': 'ucptr', 'short': 'sptr', 'int': 'iptr'}.get(b, 'ptr')


def param_type(p):
    """one parameter declaration -> its simple type (the name dropped)"""
    p = p.strip()
    m = re.match(r'^(.*?[\s*])([A-Za-z_]\w*)\s*(\[[^\]]*\])?$', p)
    if m and m.group(2) not in ('int', 'short', 'char', 'long', 'unsigned', 'void', 'signed') and not m.group(2) in SMALL:
        return simple_type(m.group(1) + ('*' if m.group(3) else ''))
    return simple_type(p)


def signatures():
    """{name: (convention, return, [params])} from the C definitions in src/c and the prototypes there and in protos.h
    (a definition wins)"""
    defs, protos = {}, {}
    pat = re.compile(r'^((?:(?:unsigned|signed|static|const|struct)\s+)*[A-Za-z_]\w*[\s*]+)(__cdecl\s+)?([A-Za-z_]\w*)\s*\(([^()]*)\)\s*(;|\{|$)')
    files = sorted(glob.glob(os.path.join(ROOT, 'src/c/*/*.c'))) + [os.path.join(ROOT, 'src/c/include/protos.h')]
    for f in files:
        for l in open(f, errors='replace'):
            m = pat.match(l.rstrip())
            if not m or m.group(3) in ('if', 'while', 'for', 'switch', 'return'): continue
            ret = simple_type(m.group(1)); params = m.group(4).strip()
            ps = [] if params in ('', 'void') else [x for x in params.split(',')]
            if any('...' in x for x in ps): ps = [x for x in ps if '...' not in x]
            sig = ('__cdecl' if m.group(2) else '__watcall', ret, [param_type(x) for x in ps])
            (defs if m.group(5) != ';' else protos).setdefault(m.group(3), sig)
    protos.update(defs)
    return protos


def untouched(funcs):
    rows = list(csv.DictReader(open(os.path.join(ROOT, 'tools/c_functions.csv'))))
    blocks = [(int(r['address'], 16), int(r['address'], 16) + int(r['size'])) for r in rows if r['status'] == 'matched']
    named = set(n for r in rows for n in r['function'].split())
    return [n for n, (a, st, game) in sorted(funcs.items(), key=lambda x: x[1][0])
            if game and n not in named and not any(s <= a < e for s, e in blocks)]


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('funcs', nargs='*'); ap.add_argument('--untouched', action='store_true')
    ap.add_argument('--out', default=os.path.join(ROOT, 'build/ghidra/out'))
    ap.add_argument('--ghidra', default=os.environ.get('GHIDRA_HOME') or (sorted(glob.glob(os.path.expanduser('~/tools/ghidra/ghidra_*'))) or [''])[-1])
    ap.add_argument('--java-home', default=os.environ.get('JAVA_HOME') or os.path.expanduser('~/tools/jdk21'))
    a = ap.parse_args()
    funcs = chk_functions()
    names = list(a.funcs) + (untouched(funcs) if a.untouched else [])
    if not names: raise SystemExit('name functions or give --untouched')
    labs = labels()
    targets = []
    for n in names:
        if n in funcs: targets.append((funcs[n][0], n))
        else:
            ad = [x for x, y in labs.items() if y == n]
            if not ad: raise SystemExit('%s: no such label' % n)
            targets.append((ad[0], n))
    work = tempfile.mkdtemp(prefix='ghidra_')
    try:
        (cbase, code), (dbase, data) = objects()[:2]
        open(os.path.join(work, 'code.bin'), 'wb').write(code); open(os.path.join(work, 'data.bin'), 'wb').write(data)
        open(os.path.join(work, 'labels.txt'), 'w').write(''.join('%X %s\n' % (x, y) for x, y in sorted(labs.items())))
        sigs = signatures()
        byname = {}
        for x, y in labs.items(): byname.setdefault(y, x)
        fl = {n: x[0] for n, x in funcs.items()}
        for n in sigs:   # functions with a known signature (library routines too) become functions
            if n not in fl and n in byname and byname[n] < cbase + len(code): fl[n] = byname[n]
        open(os.path.join(work, 'funcs.txt'), 'w').write(''.join('%X %s\n' % (x, n) for n, x in fl.items()))
        open(os.path.join(work, 'sigs.txt'), 'w').write(''.join('%s\t%s\t%s\t%s\n' % (n, c, r, ';'.join(p))
                                                               for n, (c, r, p) in sigs.items() if n in fl))
        open(os.path.join(work, 'targets.txt'), 'w').write(''.join('%X %s\n' % t for t in targets))
        os.makedirs(os.path.join(work, 'proj'))
        env = dict(os.environ, JAVA_HOME=a.java_home, PATH=os.path.join(a.java_home, 'bin') + ':' + os.environ['PATH'])
        cmd = [os.path.join(a.ghidra, 'support', 'analyzeHeadless'), os.path.join(work, 'proj'), 'nhl95',
               '-import', os.path.join(work, 'code.bin'), '-loader', 'BinaryLoader', '-loader-baseAddr', '0x%X' % cbase,
               '-processor', 'x86:LE:32:default', '-noanalysis', '-scriptPath', os.path.join(HERE, 'ghidra'),
               '-postScript', 'Nhl95Decomp.java', os.path.join(work, 'data.bin'), '%X' % dbase,
               os.path.join(work, 'labels.txt'), os.path.join(work, 'funcs.txt'), os.path.join(work, 'targets.txt'),
               os.path.abspath(a.out), os.path.join(work, 'sigs.txt')]
        r = subprocess.run(cmd, env=env, capture_output=True, text=True)
        log = r.stdout + r.stderr
        os.makedirs(os.path.join(ROOT, 'build/ghidra'), exist_ok=True)
        open(os.path.join(ROOT, 'build/ghidra/headless.log'), 'w').write(log)
        done = [l for l in log.split('\n') if 'decompiled ' in l]
        print('%d of %d decompiled into %s (log: build/ghidra/headless.log)' % (len(done), len(targets), os.path.relpath(a.out, ROOT)))
        if r.returncode: raise SystemExit('analyzeHeadless exit %d' % r.returncode)
    finally:
        shutil.rmtree(work, ignore_errors=True)


if __name__ == '__main__':
    main()
