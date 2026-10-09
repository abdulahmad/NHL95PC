#!/usr/bin/env python3
"""cc.py - compile a C source of the matching decompilation and splice it into the asm build.

  python3 tools/cc.py compile src/c/<seg>/<Func>.c [-o OBJ]   wcc386 10.0 LA under headless DOSBox -> OMF object
  python3 tools/cc.py frag    src/c/<seg>/<Func>.c OBJ OUT.inc  object -> NASM fragment for the marked asm block
  python3 tools/cc.py mark    src/c/<seg>/<Func>.c [--func F] [--end LABEL] wrap the asm function in the CBUILD markers
  python3 tools/cc.py unmark  src/c/<seg>/<Func>.c [--func F]   remove the markers again (asm block stays)
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

Several blocks from one C file (shared exits): Watcom merges identical function tails across a source file, so a
function can end with `jmp Other_popedi` into another function's epilogue (StopNA -> EvadePlayers, reenergizeteam ->
calcpuckcross). Such functions must be compiled in one file. The first block uses the file's own name; every other
function F of the file is marked with `cc.py mark FILE.c --func F` and includes "c/<seg>/<File>.<F>.inc". `frag`
then cuts the slice of _TEXT that starts at F's public (the block's length) and rewrites every rel32 branch that
leaves the slice as `dd (Label+k)-($+4)` to the asm label of the block it lands in. Code of the file that is not
in a marked block (drafts, functions kept in the file for the original layout) is compiled but not spliced. A
branch out of a slice into unmarked code, or a short (rel8) one, is an error.

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

def c_paths(src, func=None):
    """src/c/<stem>/<File>.c [, function F] -> (stem, F (default File), asm path, include name of F's block)"""
    rel = os.path.relpath(os.path.abspath(src), os.path.join(ROOT, 'src/c'))
    stem, fn = rel.split(os.sep)
    fil = os.path.splitext(fn)[0]
    func = func or fil
    inc = 'c/%s/%s.inc' % (stem, fil) if func == fil else 'c/%s/%s.%s.inc' % (stem, fil, func)
    return stem, func, os.path.join(ROOT, 'src/cseg01', stem + '.asm'), inc

def file_blocks(src):
    """every marked block of this C file: {function: include name}"""
    stem, fil, asm, inc0 = c_paths(src)
    out = {}
    for l in open(asm):
        m = re.match(r'%%include "c/%s/%s(\.(\w+))?\.inc"' % (re.escape(stem), re.escape(fil)), l.strip())
        if m: out[m.group(2) or fil] = m.group(0)
    return out

LABEL = re.compile(r'^([A-Za-z_.][\w.$?@]*):')
ADDR = re.compile(r';\s*([0-9A-F]{5})\s*$')

DATA = re.compile(r'^\s*(db|dw|dd)\s+(.*)$')

def data_size(l):
    """bytes of a db/dw/dd line without an address comment (jump tables, alignment padding), else None"""
    m = DATA.match(l.split(';')[0])
    if not m: return None
    n = len([x for x in re.split(r',(?=(?:[^"\']*["\'][^"\']*["\'])*[^"\']*$)', m.group(2)) if x.strip()])
    return n * {'db': 1, 'dw': 2, 'dd': 4}[m.group(1)]

def falls_through(L, k):
    """the code line before L[k] can run into it (not ret/jmp): a label there is an entry point inside the function
    (e.g. sndcb_addesp8_x in SndLoadFile, a tail other functions jump into), not the start of the next one"""
    for l in reversed(L[:k]):
        if LABEL.match(l) or not l.strip() or l.startswith(';'): continue
        if data_size(l) and not ADDR.search(l): return False
        op = l.split()[0] if l.split() else ''
        return ADDR.search(l) is not None and op not in ('ret', 'retn', 'jmp', 'iret')
    return False

def own_label(func, name):
    """labels that belong to func's block although they are global: Func_n1 (switch cases), Func_x / Func_common
    (entry points other code jumps to) - but not Func_jt-style data that precedes the next function"""
    return name.startswith(func + '_')

def trailing_data(L, j):
    """L[j] is the first line after a block: bytes of the data lines (padding, the next function's jump table)
    between it and the next line with an address"""
    n = 0
    for l in L[j:]:
        if ADDR.search(l): break
        d = data_size(l)
        if d: n += d
    return n

def seg_end(stem):
    for ln in open(os.path.join(ROOT, 'src/segments.txt')):
        if ln.startswith('#') or not ln.strip(): continue
        p = ln.split()
        if p[5] == 'cseg01/%s.asm' % stem: return int(p[2], 16)
    raise SystemExit('segment %s not in src/segments.txt' % stem)

def block(src, func=None):
    """the marked asm block of function func (default: the file's name): (start, end, [(label, addr)], lines)"""
    stem, func, asm, inc = c_paths(src, func)
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
    end -= trailing_data(L, j + 1)
    if pend: labels += [(n, end) for n in pend]
    return first, end, labels, body

def leading_labels(src, func=None):
    """data labels right before the marked block (Watcom puts a switch's jump table, then padding, in front of the
    function): {label: address}, walking back over db/dd lines from the block start"""
    stem, func, asm, inc = c_paths(src, func)
    L = open(asm).read().split('\n')
    i = next(k for k, l in enumerate(L) if l.strip() == '%%include "%s"' % inc) - 2
    start = block(src, func)[0]
    out = {}; a = start; k = i - 1
    while k >= 0 and not ADDR.search(L[k]):
        d = data_size(L[k]); m = LABEL.match(L[k])
        if d: a -= d
        elif m: out[m.group(1)] = a
        k -= 1
    return out

def asm_range(src, func=None):
    """(start, end) of the original code: the marked block, else label func up to the next non-local label"""
    stem, func, asm, inc = c_paths(src, func)
    if any(l.strip() == '%%include "%s"' % inc for l in open(asm)):
        s, e, labs, body = block(src, func); return s, e
    L = open(asm).read().split('\n'); start = None; k = 0
    for k, l in enumerate(L):
        m = LABEL.match(l)
        if start is None:
            if m and m.group(1) == func: start = -1
            continue
        a = ADDR.search(l)
        if start == -1 and a: start = int(a.group(1), 16); continue
        if m and not m.group(1).startswith('.') and not own_label(func, m.group(1)) and not falls_through(L, k) and start != -1: break
        if start != -1 and data_size(l) and not a: break
    for l in L[k:]:
        a = ADDR.search(l)
        if a: return start, int(a.group(1), 16) - trailing_data(L, k)
    return start, seg_end(stem) - trailing_data(L, k)

def frag(src, obj, out):
    stem, fil, asm, inc = c_paths(src)
    b = os.path.basename(out)[:-len('.inc')]
    func = b.split('.', 1)[1] if '.' in b else fil
    start, end, labels, body = block(src, func)
    known = set(n for n, a in labels) | symbols()
    r = cobj.parse(obj, known)
    text = r['text']; pubs = r['pubs']
    blocks = file_blocks(src)
    multi = len(blocks) > 1 or func != fil
    s0 = pubs.get(func, 0) if multi else 0
    if func not in pubs and multi: raise SystemExit('%s: no public %s in the object' % (src, func))
    n = end - start
    lead = {}
    if not multi and pubs.get(func, 0) > 0 and len(text) - pubs[func] == n:
        # the switch jump table (+ padding) Watcom emits in front of the function: not part of the block; the
        # asm has the same table as data labels before it
        s0 = pubs[func]; lead = leading_labels(src, func)
    if (not multi and len(text) - s0 != n) or (multi and s0 + n > len(text)):
        raise SystemExit('%s: compiled %d bytes for %s, asm block %05X-%05X is %d bytes (see tools/cdiff.py %s --func %s)'
                         % (os.path.relpath(src, ROOT), len(text) - s0, func, start, end, n, os.path.relpath(src, ROOT), func))
    tt = TextTargets(src, r)
    def textlabel(t):
        if t < s0 and lead:
            a = start - (s0 - t)
            hit = [x for x, v in lead.items() if v == a]
            if not hit: raise SystemExit('%s: reference to _TEXT+%X (before %s): no data label at %05X' % (src, t, func, a))
            return hit[0]
        return tt.resolve(t, func)[0]
    for nm, off in pubs.items():
        la = dict((x, a) for x, a in labels).get(nm)
        if la is not None and la - start != off - s0:
            raise SystemExit('%s: public %s at +%X, asm label at +%X' % (src, nm, off - s0, la - start))
    fx = {f['off'] - s0: f for f in r['fixups'] if s0 <= f['off'] < s0 + n}
    # rel32 branches (no fixup) that leave the slice: to another block of the file
    try:
        from capstone import Cs, CS_ARCH_X86, CS_MODE_32
    except ImportError:
        Cs = None
    xb = {}
    xb8 = {}
    if multi:
        if Cs is None: raise SystemExit('capstone needed for multi-block C files (pip install capstone)')
        for i in Cs(CS_ARCH_X86, CS_MODE_32).disasm(text[s0:s0 + n], s0):
            if not (i.mnemonic == 'call' or i.mnemonic.startswith('j')) or not i.op_str.startswith('0x'): continue
            a = i.address - s0
            if any(k in fx for k in range(a, a + i.size)): continue
            t = int(i.op_str, 16)
            if s0 <= t < s0 + n: continue
            if i.size == 2:  # short branch into another block of the file (a shared tail): rel8 to its label
                xb8[a + 1] = textlabel(t); continue
            xb[a + i.size - 4] = textlabel(t)
    cuts = {}
    for nm, a in labels: cuts.setdefault(a - start, []).append(nm)
    lines = ['; GENERATED by tools/cc.py from %s%s (wcc386 10.0 LA); do not edit' % (os.path.relpath(src, ROOT), ', function %s' % func if multi else '')]
    pos = 0; row = []
    def flush():
        if row: lines.append('db ' + ','.join('0%02Xh' % b for b in row)); row.clear()
    while pos < n:
        for nm in cuts.get(pos, []): flush(); lines.append('%s:' % nm)
        f = fx.get(pos)
        if f:
            flush()
            if f['target'] == 'TEXT':
                tgt = textlabel(f['addend'])
            else:
                tgt = '%s%+d' % (f['target'], f['addend']) if f['addend'] else f['target']
            lines.append('dd %s' % tgt if f['kind'] == 'abs32' else 'dd (%s)-($+4)' % tgt)
            pos += 4; continue
        if pos in xb8:
            flush(); lines.append('db (%s)-($+1)' % xb8[pos]); pos += 1; continue
        if pos in xb:
            flush(); lines.append('dd (%s)-($+4)' % xb[pos]); pos += 4; continue
        row.append(text[s0 + pos]); pos += 1
        if len(row) == 16 or pos in cuts or pos in fx or pos in xb or pos in xb8: flush()
    flush()
    for nm in cuts.get(pos, []): lines.append('%s:' % nm)
    os.makedirs(os.path.dirname(os.path.abspath(out)), exist_ok=True)
    open(out, 'w').write('\n'.join(lines) + '\n')

def label_addr(asm, name):
    L = open(asm).read().split('\n')
    for k, l in enumerate(L):
        if l.startswith(name + ':'):
            for l2 in L[k + 1:]:
                a = ADDR.search(l2)
                if a: return int(a.group(1), 16)
    return None

def original_bytes(addr, n):
    """retail code bytes (build/parts, extracted by make from your HOCKEY.EXE)"""
    import json
    man = json.load(open(os.path.join(ROOT, 'build/parts/manifest.json')))
    for m in man['segments']:
        s0, s1 = int(m['start'], 16), int(m['end'], 16)
        if m['obj'] == 1 and s0 <= addr < s1:
            return open(os.path.join(ROOT, 'build/parts', m['file']), 'rb').read()[addr - s0:addr - s0 + n]
    raise SystemExit('address %X not in cseg01' % addr)

class TextTargets:
    """map an offset in a multi-function object's _TEXT to the asm: (label expression, original address).
    A marked block of the file: its first label + offset. Code of the file that is not marked (a draft kept for
    the layout): only a shared tail is allowed - the bytes from the target up to the next ret must occur exactly
    once in the original function, and the branch goes there (e.g. StopNA's jmp into EvadePlayers' pop/ret)."""
    def __init__(self, src, r):
        self.src = src; self.r = r
        stem, fil, self.asm, inc = c_paths(src)
        self.where = []
        for g in file_blocks(src):
            gs, ge, gl, _ = block(src, g)
            if g not in r['pubs']: raise SystemExit('%s: no public %s in the object' % (src, g))
            self.where.append((r['pubs'][g], r['pubs'][g] + ge - gs, gl[0][0], gs))
    def resolve(self, t, func='?'):
        for a, e, lab, gs in self.where:
            if a <= t < e or (t == e and a < e): return '%s+0%Xh' % (lab, t - a), gs + t - a
        pubs = sorted(self.r['pubs'].items(), key=lambda x: x[1])
        own = [(n, o) for n, o in pubs if o <= t]
        if not own: raise SystemExit('%s: %s refers to _TEXT+%X before any function' % (self.src, func, t))
        g, go = own[-1]
        text = self.r['text']; k = text.find(b'\xc3', t)
        tail = text[t:k + 1] if 0 <= k - t < 16 else b''
        ga = label_addr(self.asm, g)
        if not tail or ga is None:
            raise SystemExit('%s: %s branches to %s+%X (_TEXT+%X), not a marked block nor a shared ret tail' % (self.src, func, g, t - go, t))
        later = [o for n, o in pubs if o > go]
        span = (later[0] - go if later else len(text) - go) + 0x100
        orig = original_bytes(ga, span)
        hits = [m.start() for m in re.finditer(re.escape(tail), orig)]
        if len(hits) != 1:
            raise SystemExit('%s: %s branches to the tail %s of %s; found %d times in the original %s' % (self.src, func, tail.hex(), g, len(hits), g))
        return '%s+0%Xh' % (g, hits[0]), ga + hits[0]

_syms = None
def symbols():
    global _syms
    if _syms is None:
        _syms = set()
        for ln in open(os.path.join(ROOT, 'src/inc/symbols.inc')):
            p = ln[1:].split()
            if ln.startswith(';') and len(p) >= 2 and re.match(r'^[0-9A-F]{5}$', p[0]): _syms.add(p[1])
    return _syms

def mark(src, endlabel=None, func=None):
    stem, func, asm, inc = c_paths(src, func)
    L = open(asm).read().split('\n')
    if any(l.strip() == '%%include "%s"' % inc for l in L): raise SystemExit('already marked')
    i = next((k for k, l in enumerate(L) if l.startswith(func + ':')), None)
    if i is None: raise SystemExit('label %s: not in %s' % (func, asm))
    j = i + 1
    while j < len(L):
        m = LABEL.match(L[j])
        if endlabel:
            if m and m.group(1) == endlabel: break
        elif m and not m.group(1).startswith('.') and not own_label(func, m.group(1)) and not falls_through(L, j): break
        if L[j].startswith('%'): break
        if data_size(L[j]) and not ADDR.search(L[j]) and not endlabel: break
        j += 1
    while j > i + 1 and (not L[j - 1].strip() or L[j - 1].startswith(';')): j -= 1   # the next function's comment block
    rel = os.path.relpath(os.path.abspath(src), ROOT) + ('' if inc.endswith('/%s.inc' % func) else ' (%s)' % func)
    L[i:j] = ['; C: %s' % rel, '%ifdef CBUILD', '%%include "%s"' % inc, '%else'] + L[i:j] + ['%endif ; C']
    open(asm, 'w').write('\n'.join(L))
    print('marked %s lines %d-%d of %s' % (func, i + 1, j, os.path.relpath(asm, ROOT)))

def unmark(src, func=None):
    stem, func, asm, inc = c_paths(src, func)
    L = open(asm).read().split('\n')
    i = next((k for k, l in enumerate(L) if l.strip() == '%%include "%s"' % inc), None)
    if i is None: raise SystemExit('not marked')
    j = next(k for k in range(i, len(L)) if L[k].startswith('%endif'))
    assert L[i - 2].startswith('; C: ') and L[i - 1] == '%ifdef CBUILD' and L[i + 1] == '%else'
    L[i - 2:j + 1] = L[i + 2:j]
    open(asm, 'w').write('\n'.join(L)); print('unmarked %s' % func)

if __name__ == '__main__':
    ap = argparse.ArgumentParser(); ap.add_argument('cmd'); ap.add_argument('src', nargs='?'); ap.add_argument('rest', nargs='*')
    ap.add_argument('-o'); ap.add_argument('--end'); ap.add_argument('--func'); ap.add_argument('--flags', default='')
    a = ap.parse_args()
    if a.cmd == 'check': sys.exit(0 if check() else 1)
    if a.cmd == 'compile':
        obj = a.o or os.path.join(ROOT, 'build', os.path.relpath(os.path.splitext(os.path.abspath(a.src))[0], os.path.join(ROOT, 'src')) + '.obj')
        sys.exit(0 if compile_c(a.src, obj, a.flags) else 1)
    if a.cmd == 'frag': frag(a.src, a.rest[0], a.rest[1])
    elif a.cmd == 'mark': mark(a.src, a.end, a.func)
    elif a.cmd == 'unmark': unmark(a.src, a.func)
    else: sys.exit(__doc__)
