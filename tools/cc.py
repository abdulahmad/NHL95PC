#!/usr/bin/env python3
"""cc.py - compile a C source of the matching decompilation and splice it into the asm build.

  python3 tools/cc.py compile src/c/<seg>/<Func>.c [-o OBJ]   wcc386 10.0 GA (or LA) under headless DOSBox -> OMF object
  python3 tools/cc.py compile A.c B.c ...                      several sources, one DOSBox run per 16 (objects in build/)
  python3 tools/cc.py frag    src/c/<seg>/<Func>.c OBJ OUT.inc  object -> NASM fragment for the marked asm block
  python3 tools/cc.py mark    src/c/<seg>/<Func>.c [--func F [--seg STEM]] [--end LABEL] wrap the asm function in the CBUILD
                              markers (--seg: F sits in another asm segment, e.g. the next one)
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

Compiler: Watcom C/C++32 10.0 wcc386 under DOSBox, default flags, chosen by WATCOM_VER (make WATCOM_VER=...):
  ga (default)  10.0 GA (May 1994; the compiler HOCKEY.EXE was built with): tools/watcom/dosga/ WCC386, DOS4GW, W32RUN
  la            10.0 LA (Limited Availability, Mar 1994; the reference until 2026-10-22, kept as a fallback):
                tools/watcom/dosla/WCC386.EXE with the 10.0a DOS4GW / W32RUN from tools/watcom/w10a/
WATCOM_ROOT moves the tools/watcom tree. The cache key includes the compiler, so the two never share objects. A source may add flags with a comment line `/* cflags: -xx */` (none needed so far). Headers come from
src/c/include (8.3 names)."""
import glob
import os, re, sys, shutil, subprocess, tempfile, argparse, threading
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import cobj
W = os.environ.get('WATCOM_ROOT', os.path.join(ROOT, 'tools/watcom'))
COMPILERS = {   # WATCOM_VER -> (wcc386, DOS/4GW, W32RUN, description)
    'ga': ('dosga/WCC386.EXE', 'dosga/DOS4GW.EXE', 'dosga/W32RUN.EXE', 'wcc386 10.0 GA'),
    'la': ('dosla/WCC386.EXE', 'w10a/WATCOM/BIN/DOS4GW.EXE', 'w10a/WATCOM/BIN/W32RUN.EXE', 'wcc386 10.0 LA'),
}
VER = os.environ.get('WATCOM_VER', '') or 'ga'
if VER not in COMPILERS: raise SystemExit('cc.py: WATCOM_VER=%s: use one of %s' % (VER, ', '.join(sorted(COMPILERS))))
CC, D4G, W32 = (os.path.join(W, x) for x in COMPILERS[VER][:3])
CCNAME = COMPILERS[VER][3]
INC = os.path.join(ROOT, 'src/c/include')
FLAGS = ''

def check():
    return all(os.path.exists(x) for x in (CC, D4G, W32)) and shutil.which('dosbox') is not None

CACHE = os.environ.get('NHL95_CC_CACHE', os.path.expanduser('~/.cache/nhl95pc-cc'))

def included(src):
    """the headers src actually includes (transitively, from src/c/include), sorted"""
    seen, todo = set(), [src]
    while todo:
        for h in re.findall(r'^\s*#\s*include\s*"([^"]+)"', open(todo.pop(), errors='replace').read(), re.M):
            p = os.path.join(INC, h)
            if p not in seen and os.path.exists(p): seen.add(p); todo.append(p)
    return sorted(seen)

def cache_key(src, flags):
    """sha1 of the compiler, flags, the .c and every header it includes: same key -> same object. 'fresh': only
    objects compiled first in their DOSBox run are cached (compile_many); older caches may hold others."""
    import hashlib
    h = hashlib.sha1(('fresh|%s|%s|%s|' % (VER, os.path.getsize(CC), flags)).encode())
    for p in [src] + included(src):
        h.update(os.path.basename(p).encode()); h.update(open(p, 'rb').read())
    return h.hexdigest()

def src_flags(src, extra=''):
    m = re.search(r'/\*\s*cflags:([^*]*)\*/', open(src).read())
    return ' '.join(x for x in (FLAGS, m.group(1).strip() if m else '', extra) if x)

def compile_c(src, obj, extra=''):
    return compile_many([(src, obj, extra)])[0]

def compile_many(items, batch=None):
    """compile [(src, obj, extra_flags)]; returns a list of bools. Cache hits are copied; the misses are compiled in
    one DOSBox run per `batch` sources (NHL95_CC_BATCH, default 16): one DOSBox boot serves the whole batch. Only
    the first object of each run goes into the cache: wcc386 can compile a source differently after other files in
    the same run (HANDOFF step 3, the compiler state), and make compiles each file in a fresh run."""
    batch = batch or int(os.environ.get('NHL95_CC_BATCH', '16'))
    nocache = os.environ.get('NHL95_NOCACHE') == '1'
    res = [False] * len(items); todo = {}   # cache key -> [(index, src, obj, flags)]
    for k, (src, obj, extra) in enumerate(items):
        flags = src_flags(src, extra); key = cache_key(src, flags); cobj_ = os.path.join(CACHE, key + '.obj')
        if not nocache and os.path.exists(cobj_):
            os.makedirs(os.path.dirname(os.path.abspath(obj)), exist_ok=True); shutil.copy(cobj_, obj); res[k] = True
        else: todo.setdefault(key, []).append((k, src, obj, flags))
    keys = list(todo)
    for c in range(0, len(keys), batch):
        chunk = keys[c:c + batch]
        oks = compile_batch_raw([todo[key][0][1:] for key in chunk])
        for pos, (key, ok) in enumerate(zip(chunk, oks)):
            k0, src0, obj0, _ = todo[key][0]
            if not ok: continue
            if pos == 0:   # the fresh compiler state
                os.makedirs(CACHE, exist_ok=True); cobj_ = os.path.join(CACHE, key + '.obj')
                tmp = cobj_ + '.%d.%d' % (os.getpid(), threading.get_ident())
                shutil.copy(obj0, tmp); os.replace(tmp, cobj_)
            for k, src, obj, _ in todo[key]:
                if obj != obj0:
                    os.makedirs(os.path.dirname(os.path.abspath(obj)), exist_ok=True); shutil.copy(obj0, obj)
                res[k] = True
    return res

def compile_parallel(items, jobs=8, batch=None):
    """compile_many over `jobs` DOSBox processes at once (each takes every jobs-th item); returns a list of bools"""
    from concurrent.futures import ThreadPoolExecutor
    parts = [list(range(k, len(items), jobs)) for k in range(jobs)]
    res = [False] * len(items)
    with ThreadPoolExecutor(jobs) as ex:
        for idx, oks in zip(parts, ex.map(lambda p: compile_many([items[i] for i in p], batch) if p else [], parts)):
            for i, ok in zip(idx, oks): res[i] = ok
    return res

def compile_c_raw(src, obj, flags):
    return compile_batch_raw([(src, obj, flags)])[0]

# DOSBox [cpu] settings: the dynamic core at a fixed cycle count runs a compile about twice as fast as cycles=max
# (which ramps up over the first seconds of each run); the objects are the same.
DOSBOX_CPU = os.environ.get('NHL95_CC_CPU', 'core=dynamic\ncycles=fixed 2000000')

def compile_batch_raw(items):
    """compile [(src, obj, flags)] in one headless DOSBox run, without the cache; returns a list of bools and writes
    each source's errors / warnings to stderr"""
    work = tempfile.mkdtemp(prefix='cc_')
    try:
        shutil.copy(CC, os.path.join(work, 'WCC386.EXE')); shutil.copy(D4G, os.path.join(work, 'DOS4GW.EXE'))
        shutil.copy(W32, os.path.join(work, 'W32RUN.EXE'))
        os.mkdir(os.path.join(work, 'INC'))
        for h in os.listdir(INC):
            if h.endswith('.h'): shutil.copy(os.path.join(INC, h), os.path.join(work, 'INC', h.upper()))
        cmds = []
        for k, (src, obj, flags) in enumerate(items):
            shutil.copy(src, os.path.join(work, 'S%03d.C' % k))
            cmds.append('WCC386 %s S%03d.C > E%03d.TXT' % (flags, k, k))
        conf = os.path.join(work, 'db.conf')
        open(conf, 'w').write('[sdl]\noutput=surface\n[dosbox]\nmemsize=64\n[cpu]\n%s\n[autoexec]\n'
                              'mount c %s\nc:\nset DOS4G=QUIET\nset PATH=C:\\\nset INCLUDE=C:\\INC\n%s\nexit\n'
                              % (DOSBOX_CPU, work, '\n'.join(cmds)))
        env = dict(os.environ, SDL_VIDEODRIVER='dummy', SDL_AUDIODRIVER='dummy')
        subprocess.run(['timeout', str(120 + 60 * len(items)), 'dosbox', '-conf', conf, '-exit'], env=env,
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        res = []
        for k, (src, obj, flags) in enumerate(items):
            e, name = os.path.join(work, 'E%03d.TXT' % k), 'S%03d.C' % k
            err = open(e, 'rb').read().decode('latin1').replace('\r', '') if os.path.exists(e) else ''
            rel = os.path.relpath(src, ROOT)
            msgs = [l.replace(name, rel) for l in err.split('\n') if re.search(r'\b(Error|Warning)\b|: (E|W)\d', l)]
            o = os.path.join(work, 'S%03d.OBJ' % k)
            if not os.path.exists(o) or ' 0 errors' not in err:
                sys.stderr.write(err.replace(name, rel) or '%s: no compiler output\n' % rel); res.append(False); continue
            for l in msgs: sys.stderr.write(l + '\n')
            os.makedirs(os.path.dirname(os.path.abspath(obj)), exist_ok=True); shutil.copy(o, obj)
            res.append(True)
        return res
    finally: shutil.rmtree(work, ignore_errors=True)

def c_paths(src, func=None):
    """src/c/<stem>/<File>.c [, function F] -> (stem, F (default File), asm path, include name of F's block)"""
    rel = os.path.relpath(os.path.abspath(src), os.path.join(ROOT, 'src/c'))
    stem, fn = rel.split(os.sep)
    fil = os.path.splitext(fn)[0]
    func = func or fil
    inc = 'c/%s/%s.inc' % (stem, fil) if func == fil else 'c/%s/%s.%s.inc' % (stem, fil, func)
    asm = os.path.join(ROOT, 'src/cseg01', stem + '.asm')
    if func != fil:
        # a further function of the file may sit in the next asm segment (one original source file across a
        # segment split): its block is marked there (cc.py mark --func F --seg STEM)
        seg = os.environ.get('CC_SEG')
        if seg: asm = os.path.join(ROOT, 'src/cseg01', seg + '.asm')
        elif '%%include "%s"' % inc not in open(asm).read():
            label = None
            for g in sorted(glob.glob(os.path.join(ROOT, 'src/cseg01/*.asm'))):
                t = open(g).read()
                if '%%include "%s"' % inc in t: asm = g; label = None; break
                if label is None and re.search(r'(?m)^%s:' % re.escape(func), t): label = g
            if label: asm = label
    return stem, func, asm, inc

def file_blocks(src):
    """every marked block of this C file: {function: include name}"""
    stem, fil, asm, inc0 = c_paths(src)
    out = {}
    for g in [asm] + sorted(x for x in glob.glob(os.path.join(ROOT, 'src/cseg01/*.asm')) if x != asm):
        t = open(g).read()
        if 'c/%s/%s' % (stem, fil) not in t: continue
        for l in t.split('\n'):
            m = re.match(r'%%include "c/%s/%s(\.(\w+))?\.inc"' % (re.escape(stem), re.escape(fil)), l.strip())
            if m: out[m.group(2) or fil] = m.group(0)
    return out

LABEL = re.compile(r'^([A-Za-z_.][\w.$?@]*):')
ADDR = re.compile(r';\s*([0-9A-F]{5})\s*$')
# an instruction kept as db because NASM would encode it differently ('db 081h,0E8h,...  ; 6827D sub eax,0B4h'):
# code inside the function, not data after it
INSN_DB = re.compile(r'^\s*db\s[^;]*;\s*[0-9A-F]{5}\s+\S')

def insn_data(L, k):
    """L[k] is part of an instruction kept as data: an INSN_DB line, or a db / dd line (its relocated operand,
    'db 068h ; push imm32' then 'dd Label') right after one"""
    if INSN_DB.match(L[k]): return True
    j = k - 1
    while j >= 0 and data_size(L[j]) and not ADDR.search(L[j]) and not INSN_DB.match(L[j]): j -= 1
    return j >= 0 and j < k and INSN_DB.match(L[j]) is not None and data_size(L[k]) is not None

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
        if INSN_DB.match(l): return l.split(';', 1)[1].split()[1] not in ('ret', 'retn', 'jmp', 'iret')
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
    if end is None: end = seg_end(os.path.basename(asm)[:-4])
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
        if start != -1 and data_size(l) and not a and not insn_data(L, k): break
    for l in L[k:]:
        a = ADDR.search(l)
        if a: return start, int(a.group(1), 16) - trailing_data(L, k)
    return start, seg_end(os.path.basename(asm)[:-4]) - trailing_data(L, k)

def frag(src, obj, out):
    stem, fil, asm, inc = c_paths(src)
    b = os.path.basename(out)[:-len('.inc')]
    func = b.split('.', 1)[1] if '.' in b else fil
    start, end, labels, body = block(src, func)
    known = set(n for n, a in labels) | symbols()
    r = cobj.parse(obj, known)
    text = r['text']; pubs = r['pubs']
    blocks = file_blocks(src)
    # several functions in the object (a single marked block with drafts beside it, as for a block among others):
    # cut the block at its public
    multi = len(blocks) > 1 or func != fil or len(pubs) > 1
    s0 = anchor(src, r, func, start, end) if multi else 0
    if s0 < 0: raise SystemExit('%s: block %s would start before the object' % (src, func))
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
        if multi and t < s0:
            # a block of a multi-function file whose switch jump table sits in front of it (after the previous,
            # possibly draft, function): the asm has the same table as data labels before the block
            a = start - (s0 - t)
            hit = [x for x, v in leading_labels(src, func).items() if v == a]
            if hit: return hit[0]
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
    lines = ['; GENERATED by tools/cc.py from %s%s (%s); do not edit' % (os.path.relpath(src, ROOT), ', function %s' % func if multi else '', CCNAME)]
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

def anchor(src, r, func, start, end):
    """the object offset of the asm block [start, end) of func (a C function, or a label inside one: a piece of a
    split function, e.g. getlinee_pp before TeamLineEnergy): func's public, else from a public of the file by the
    address difference - a public inside the block first, else the nearest one before or after it (the code in
    between must then match too). The object must have the EXE's layout between the two (frag checks the publics
    inside the block; make's sha1 the bytes)."""
    if func in r['pubs']: return r['pubs'][func]
    asm = c_paths(src, func)[2]
    at = [(n, label_addr(asm, n)) for n in r['pubs']]
    at = [(n, a) for n, a in at if a is not None]
    inside = [(a - start, n, a) for n, a in at if start <= a < end]
    before = [(start - a, n, a) for n, a in at if a < start]
    after = [(a - end, n, a) for n, a in at if a >= end]
    pick = min(inside) if inside else min(before + after) if before or after else None
    if pick is None: raise SystemExit('%s: no public of the object to place %s by (asm %s)' % (src, func, os.path.relpath(asm, ROOT)))
    _, n, a = pick
    return r['pubs'][n] - (a - start)

def label_addr(asm, name):
    L = open(asm).read().split('\n')
    for k, l in enumerate(L):
        if l.startswith(name + ':'):
            # db / dd lines carry no address comment (MenuSaveDefaultLines starts with a db push): count their bytes
            skip = 0
            for l2 in L[k + 1:]:
                a = ADDR.search(l2)
                if a: return int(a.group(1), 16) - skip
                w = l2.split(';')[0].split()
                if w[:1] == ['db']: skip += len(' '.join(w[1:]).split(','))
                elif w[:1] == ['dd']: skip += 4 * len(' '.join(w[1:]).split(','))
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
            a = anchor(src, r, g, gs, ge)
            self.where.append((a, a + ge - gs, gl[0][0], gs, gl, c_paths(src, g)[2]))
    def resolve(self, t, func='?'):
        for a, e, lab, gs, gl, gasm in self.where:
            if a <= t < e or (t == e and a < e):
                ta = gs + t - a
                if func != '?' and gasm != c_paths(self.src, func)[2]:
                    # a block in another asm file (one source file across a segment split, e.g. TickPanelPenalties
                    # in 006 ending in DrawPanelLine_x of 005): only that segment's global labels are visible
                    # there, so name the target by the nearest global label at or before it
                    g = [(n, x) for n, x in gl if '.' not in n and x <= ta]
                    if g:
                        n, x = max(g, key=lambda v: v[1])
                        return ('%s+0%Xh' % (n, ta - x) if ta != x else n), ta
                return '%s+0%Xh' % (lab, t - a), ta
        pubs = sorted(self.r['pubs'].items(), key=lambda x: x[1])
        own = [(n, o) for n, o in pubs if o <= t]
        if not own: raise SystemExit('%s: %s refers to _TEXT+%X before any function' % (self.src, func, t))
        g, go = own[-1]
        if t == go and label_addr(self.asm, g) is not None:
            # the entry of another function of the file (a tail call into a draft: MenuP1ControlsExh's
            # `jmp short ControlsDlgExh`): its own label
            return g, label_addr(self.asm, g)
        # the tail: up to the next ret; with no ret close by, up to its first call / jmp out of the module (a rel32
        # fixup: assrefdrop's jumps into the draft assrefwhistle's SkateToSpot tail, which goes on with `jmp ass_popx`
        # in the original and with the pops in the draft) or to a jmp rel32 inside the module right after a relocated
        # field (asscentero into the draft asswingo's `mov edx, EvadePC; jmp asswingd_skateto`). Relocated fields and
        # that jmp's displacement are wildcards.
        text = self.r['text']; k = text.find(b'\xc3', t); tail = b''
        # a `ret n` (C2 n16) ends the tail too (MessageBox into the draft TextInputDialog's `ret 14h`): decode for it
        from capstone import Cs, CS_ARCH_X86, CS_MODE_32
        for i in Cs(CS_ARCH_X86, CS_MODE_32).disasm(text[t:t + 19], t):
            if i.mnemonic == 'ret':
                if i.size == 3 and (k < 0 or i.address < k): k = i.address + 2
                break
        fx = [f for f in self.r['fixups'] if t <= f['off'] < t + 48]
        ends = [f['off'] + 4 for f in fx if f['kind'] == 'rel32']
        jmps = [f['off'] + 4 for f in fx if text[f['off'] + 4:f['off'] + 5] == b'\xe9']
        jmps = [j for j in jmps if not any(x['off'] == j + 1 for x in self.r['fixups'])]
        e = min(ends[:1] + [j + 5 for j in jmps[:1]]) if ends or jmps else None
        e = k + 1 if 0 <= k - t < 16 else e if e is not None and e - t >= 8 else None
        if e:
            masked = set(range(jmps[0] + 1, jmps[0] + 5)) if jmps and e == jmps[0] + 5 else set()
            for f in fx: masked.update(range(f['off'], f['off'] + 4))
            tail = b''.join(b'.' if i in masked else re.escape(text[i:i + 1]) for i in range(t, e))
        ga = label_addr(self.asm, g)
        if not tail or ga is None:
            raise SystemExit('%s: %s branches to %s+%X (_TEXT+%X), not a marked block nor a shared ret tail' % (self.src, func, g, t - go, t))
        later = [o for n, o in pubs if o > go]
        span = (later[0] - go if later else len(text) - go) + 0x100
        orig = original_bytes(ga, span)
        hits = [m.start() for m in re.finditer(tail, orig, re.S)]
        if len(hits) > 1:
            # a short tail (a bare ret: assfaceoff's `jne short assshoot_ret`) occurs more than once: keep the hits
            # that carry a label in the asm (code elsewhere jumps there too)
            at = set(global_labels(self.asm).values())
            lab = [h for h in hits if ga + h in at]
            if len(lab) == 1: hits = lab
        if len(hits) != 1:
            raise SystemExit('%s: %s branches to the tail %s of %s; found %d times in the original %s' % (self.src, func, text[t:t + 16].hex(), g, len(hits), g))
        ta = ga + hits[0]
        if func != '?' and c_paths(self.src, func)[2] != self.asm:
            # the branch is in a block marked in another asm file (FreeLeagueDbsMem in 051 ending in the draft
            # BuildFreeAgentList's tail in 050): name the tail by the nearest global label of the draft's segment
            gl = [(n, x) for n, x in global_labels(self.asm).items() if x <= ta]
            if gl:
                n, x = max(gl, key=lambda v: v[1])
                return ('%s+0%Xh' % (n, ta - x) if ta != x else n), ta
        return '%s+0%Xh' % (g, hits[0]), ta

def global_labels(asm):
    """{label: address} of the labels an asm segment exports (its `global` lines)"""
    L = open(asm).read().split('\n')
    names = set()
    for l in L:
        if l.startswith('global '): names.update(x.strip() for x in l[7:].split(','))
    out = {}
    for k, l in enumerate(L):
        m = LABEL.match(l)
        if m and m.group(1) in names and m.group(1) not in out:
            for l2 in L[k + 1:]:
                a = ADDR.search(l2)
                if a: out[m.group(1)] = int(a.group(1), 16); break
    return out

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
        if data_size(L[j]) and not ADDR.search(L[j]) and not insn_data(L, j) and not endlabel: break
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
    ap.add_argument('-o'); ap.add_argument('--end'); ap.add_argument('--func'); ap.add_argument('--flags', default=''); ap.add_argument('--seg')
    a = ap.parse_args()
    if a.seg: os.environ['CC_SEG'] = a.seg
    if a.cmd == 'check': sys.exit(0 if check() else 1)
    if a.cmd == 'version': print('%s %s (%s)' % (VER, CCNAME, os.path.relpath(CC, ROOT))); sys.exit(0)
    if a.cmd == 'compile':
        objof = lambda s: os.path.join(ROOT, 'build', os.path.relpath(os.path.splitext(os.path.abspath(s))[0], os.path.join(ROOT, 'src')) + '.obj')
        if a.rest:   # several sources: batched DOSBox runs on every core, objects at their build/ paths
            srcs = [a.src] + a.rest
            sys.exit(0 if all(compile_parallel([(s, objof(s), a.flags) for s in srcs], os.cpu_count() or 4)) else 1)
        sys.exit(0 if compile_c(a.src, a.o or objof(a.src), a.flags) else 1)
    if a.cmd == 'frag': frag(a.src, a.rest[0], a.rest[1])
    elif a.cmd == 'mark': mark(a.src, a.end, a.func)
    elif a.cmd == 'unmark': unmark(a.src, a.func)
    else: sys.exit(__doc__)
