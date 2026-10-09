#!/usr/bin/env python3
"""cc.py - compile a C source of the matching decompilation and splice it into the asm build.

  python3 tools/cc.py compile src/c/<seg>/<Func>.c [-o OBJ]   wcc386 10.0 LA under headless DOSBox -> OMF object
  python3 tools/cc.py frag    src/c/<seg>/<Func>.c OBJ OUT.inc  object -> NASM fragment for the marked asm block
  python3 tools/cc.py mark    src/c/<seg>/<Func>.c [--end LABEL] wrap the asm function in the CBUILD markers
  python3 tools/cc.py unmark  src/c/<seg>/<Func>.c              remove the markers again (asm block stays)
  python3 tools/cc.py check                                    toolchain present? (exit 0/1; used by the Makefile)

Layout: src/c/<segment file stem>/<Func>.c (e.g. src/c/042_59D9A_engine_core/SetSPA.c) replaces the block of
src/cseg01/<stem>.asm that starts at label <Func>. In the asm the block is wrapped like this (`mark` writes it):

    ; C: src/c/042_59D9A_engine_core/SetSPA.c
    %ifdef CBUILD
    %include "c/042_59D9A_engine_core/SetSPA.inc"
    %else
    SetSPA:
    ... the original asm, unchanged (the fallback build without the compiler) ...
    %endif ; C

`make` defines CBUILD when the compiler is available (`cc.py check`). The fragment is the compiled _TEXT bytes as
db lines; every fixup becomes `dd label+k` (32-bit offset) or `dd label+k-($+4)` (rel32 call/jmp), so the linker
recreates the same LE fixups. Every label of the asm block (global, local .x, mid-function entry points) is
re-emitted at its original offset, taken from the instruction address comments, so other code that jumps into the
block still assembles. `frag` fails when the compiled size differs from the asm block; the bytes themselves are
checked by the sha1 at the end of `make` (use tools/cdiff.py to see differences).

Compiler: Watcom C/C++32 10.0 LA wcc386 (WATCOM_ROOT, default ~/watcom: dosla/WCC386.EXE + w10a DOS4GW), default
flags. A source may add flags with a comment line `/* cflags: -xx */` (none needed so far). Headers come from
src/c/include (8.3 names)."""
import os, re, sys, shutil, subprocess, tempfile, argparse
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import cobj
W = os.environ.get('WATCOM_ROOT', os.path.expanduser('~/watcom'))
CC = os.path.join(W, 'dosla/WCC386.EXE'); D4G = os.path.join(W, 'w10a/WATCOM/BIN/DOS4GW.EXE')
W32 = os.path.join(W, 'w10a/WATCOM/BIN/W32RUN.EXE')
INC = os.path.join(ROOT, 'src/c/include')
FLAGS = ''

def check():
    return all(os.path.exists(x) for x in (CC, D4G, W32)) and shutil.which('dosbox') is not None

def compile_c(src, obj, extra=''):
    m = re.search(r'/\*\s*cflags:([^*]*)\*/', open(src).read())
    flags = ' '.join(x for x in (FLAGS, m.group(1).strip() if m else '', extra) if x)
    work = tempfile.mkdtemp(prefix='cc_')
    try:
        shutil.copy(CC, os.path.join(work, 'WCC386.EXE')); shutil.copy(D4G, os.path.join(work, 'DOS4GW.EXE'))
        shutil.copy(W32, os.path.join(work, 'W32RUN.EXE'))
        os.mkdir(os.path.join(work, 'INC'))
        for h in os.listdir(INC):
            if h.endswith('.h'): shutil.copy(os.path.join(INC, h), os.path.join(work, 'INC', h.upper()))
        shutil.copy(src, os.path.join(work, 'SRC.C'))
        conf = os.path.join(work, 'db.conf')
        open(conf, 'w').write('[sdl]\noutput=surface\n[dosbox]\nmemsize=64\n[cpu]\ncycles=max\n[autoexec]\n'
                              'mount c %s\nc:\nset DOS4G=QUIET\nset PATH=C:\\\nset INCLUDE=C:\\INC\nWCC386 %s SRC.C > ERR.TXT\nexit\n' % (work, flags))
        env = dict(os.environ, SDL_VIDEODRIVER='dummy', SDL_AUDIODRIVER='dummy')
        subprocess.run(['timeout', '180', 'dosbox', '-conf', conf, '-exit'], env=env, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        err = open(os.path.join(work, 'ERR.TXT'), 'rb').read().decode('latin1').replace('\r', '') if os.path.exists(os.path.join(work, 'ERR.TXT')) else ''
        msgs = [l.replace('SRC.C', os.path.relpath(src, ROOT)) for l in err.split('\n') if re.search(r'\b(Error|Warning)\b|: (E|W)\d', l)]
        o = os.path.join(work, 'SRC.OBJ')
        if not os.path.exists(o) or ' 0 errors' not in err:
            sys.stderr.write(err.replace('SRC.C', os.path.relpath(src, ROOT))); return False
        for l in msgs: sys.stderr.write(l + '\n')
        os.makedirs(os.path.dirname(os.path.abspath(obj)), exist_ok=True); shutil.copy(o, obj)
        return True
    finally: shutil.rmtree(work, ignore_errors=True)

def c_paths(src):
    """src/c/<stem>/<Func>.c -> (stem, Func, asm path, include name)"""
    rel = os.path.relpath(os.path.abspath(src), os.path.join(ROOT, 'src/c'))
    stem, fn = rel.split(os.sep)
    func = os.path.splitext(fn)[0]
    return stem, func, os.path.join(ROOT, 'src/cseg01', stem + '.asm'), 'c/%s/%s.inc' % (stem, func)

LABEL = re.compile(r'^([A-Za-z_.][\w.$?@]*):')
ADDR = re.compile(r';\s*([0-9A-F]{5})\s*$')

def seg_end(stem):
    for ln in open(os.path.join(ROOT, 'src/segments.txt')):
        if ln.startswith('#') or not ln.strip(): continue
        p = ln.split()
        if p[5] == 'cseg01/%s.asm' % stem: return int(p[2], 16)
    raise SystemExit('segment %s not in src/segments.txt' % stem)

def block(src):
    """the marked asm block for this C file: (start, end, [(label, addr)], lines)"""
    stem, func, asm, inc = c_paths(src)
    L = open(asm).read().split('\n')
    i = next((k for k, l in enumerate(L) if l.strip() == '%%include "%s"' % inc), None)
    if i is None: raise SystemExit('%s: no %%include "%s" block (run cc.py mark)' % (os.path.relpath(asm, ROOT), inc))
    assert L[i + 1].strip() == '%else', 'marker: %else must follow the %include line'
    j = next(k for k in range(i + 2, len(L)) if L[k].startswith('%endif'))
    body = L[i + 2:j]
    labels = []; pend = []; first = None
    for l in body:
        m = LABEL.match(l)
        if m: pend.append(m.group(1)); continue
        a = ADDR.search(l)
        if a:
            ad = int(a.group(1), 16)
            if first is None: first = ad
            labels += [(n, ad) for n in pend]; pend = []
    end = None
    for l in L[j + 1:]:
        a = ADDR.search(l)
        if a: end = int(a.group(1), 16); break
    if end is None: end = seg_end(stem)
    if pend: labels += [(n, end) for n in pend]
    return first, end, labels, body

def asm_range(src, func=None):
    """(start, end) of the original code: the marked block, else label func up to the next non-local label"""
    stem, f, asm, inc = c_paths(src)
    func = func or f
    if func == f and any(l.strip() == '%%include "%s"' % inc for l in open(asm)):
        s, e, labs, body = block(src); return s, e
    L = open(asm).read().split('\n'); start = None; k = 0
    for k, l in enumerate(L):
        m = LABEL.match(l)
        if start is None:
            if m and m.group(1) == func: start = -1
            continue
        a = ADDR.search(l)
        if start == -1 and a: start = int(a.group(1), 16); continue
        if m and not m.group(1).startswith('.') and start != -1: break
    for l in L[k:]:
        a = ADDR.search(l)
        if a: return start, int(a.group(1), 16)
    return start, seg_end(stem)

def frag(src, obj, out):
    stem, func, asm, inc = c_paths(src)
    start, end, labels, body = block(src)
    known = set(n for n, a in labels) | symbols()
    r = cobj.parse(obj, known)
    text = r['text']
    if len(text) != end - start:
        raise SystemExit('%s: compiled %d bytes, asm block %05X-%05X is %d bytes (see tools/cdiff.py %s)'
                         % (os.path.relpath(src, ROOT), len(text), start, end, end - start, os.path.relpath(src, ROOT)))
    for n, off in r['pubs'].items():
        la = dict((x, a) for x, a in labels).get(n)
        if la is not None and la - start != off:
            raise SystemExit('%s: public %s at +%X, asm label at +%X' % (src, n, off, la - start))
    fx = {f['off']: f for f in r['fixups']}
    cuts = {}
    for n, a in labels: cuts.setdefault(a - start, []).append(n)
    lines = ['; GENERATED by tools/cc.py from %s (wcc386 10.0 LA); do not edit' % os.path.relpath(src, ROOT)]
    pos = 0; row = []
    def flush():
        if row: lines.append('db ' + ','.join('0%02Xh' % b for b in row)); row.clear()
    while pos < len(text):
        for n in cuts.get(pos, []): flush(); lines.append('%s:' % n)
        f = fx.get(pos)
        if f:
            flush()
            t = start if f['target'] == 'TEXT' else None
            tgt = ('%s+0%Xh' % (labels[0][0], f['addend'])) if f['target'] == 'TEXT' else '%s%+d' % (f['target'], f['addend']) if f['addend'] else f['target']
            if f['target'] == 'TEXT' and labels[0][1] != start: raise SystemExit('first label not at block start')
            lines.append('dd %s' % tgt if f['kind'] == 'abs32' else 'dd (%s)-($+4)' % tgt)
            pos += 4; continue
        row.append(text[pos]); pos += 1
        if len(row) == 16 or pos in cuts or pos in fx: flush()
    flush()
    for n in cuts.get(pos, []): lines.append('%s:' % n)
    os.makedirs(os.path.dirname(os.path.abspath(out)), exist_ok=True)
    open(out, 'w').write('\n'.join(lines) + '\n')

_syms = None
def symbols():
    global _syms
    if _syms is None:
        _syms = set()
        for ln in open(os.path.join(ROOT, 'src/inc/symbols.inc')):
            p = ln[1:].split()
            if ln.startswith(';') and len(p) >= 2 and re.match(r'^[0-9A-F]{5}$', p[0]): _syms.add(p[1])
    return _syms

def mark(src, endlabel=None):
    stem, func, asm, inc = c_paths(src)
    L = open(asm).read().split('\n')
    if any(l.strip() == '%%include "%s"' % inc for l in L): raise SystemExit('already marked')
    i = next((k for k, l in enumerate(L) if l.startswith(func + ':')), None)
    if i is None: raise SystemExit('label %s: not in %s' % (func, asm))
    j = i + 1
    while j < len(L):
        m = LABEL.match(L[j])
        if endlabel:
            if m and m.group(1) == endlabel: break
        elif m and not m.group(1).startswith('.'): break
        if L[j].startswith('%'): break
        j += 1
    while j > i + 1 and (not L[j - 1].strip() or L[j - 1].startswith(';')): j -= 1   # the next function's comment block
    rel = os.path.relpath(os.path.abspath(src), ROOT)
    L[i:j] = ['; C: %s' % rel, '%ifdef CBUILD', '%%include "%s"' % inc, '%else'] + L[i:j] + ['%endif ; C']
    open(asm, 'w').write('\n'.join(L))
    print('marked %s lines %d-%d of %s' % (func, i + 1, j, os.path.relpath(asm, ROOT)))

def unmark(src):
    stem, func, asm, inc = c_paths(src)
    L = open(asm).read().split('\n')
    i = next((k for k, l in enumerate(L) if l.strip() == '%%include "%s"' % inc), None)
    if i is None: raise SystemExit('not marked')
    j = next(k for k in range(i, len(L)) if L[k].startswith('%endif'))
    assert L[i - 2].startswith('; C: ') and L[i - 1] == '%ifdef CBUILD' and L[i + 1] == '%else'
    L[i - 2:j + 1] = L[i + 2:j]
    open(asm, 'w').write('\n'.join(L)); print('unmarked %s' % func)

if __name__ == '__main__':
    ap = argparse.ArgumentParser(); ap.add_argument('cmd'); ap.add_argument('src', nargs='?'); ap.add_argument('rest', nargs='*')
    ap.add_argument('-o'); ap.add_argument('--end'); ap.add_argument('--flags', default='')
    a = ap.parse_args()
    if a.cmd == 'check': sys.exit(0 if check() else 1)
    if a.cmd == 'compile':
        obj = a.o or os.path.join(ROOT, 'build', os.path.relpath(os.path.splitext(os.path.abspath(a.src))[0], os.path.join(ROOT, 'src')) + '.obj')
        sys.exit(0 if compile_c(a.src, obj, a.flags) else 1)
    if a.cmd == 'frag': frag(a.src, a.rest[0], a.rest[1])
    elif a.cmd == 'mark': mark(a.src, a.end)
    elif a.cmd == 'unmark': unmark(a.src)
    else: sys.exit(__doc__)
