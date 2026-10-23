#!/usr/bin/env python3
"""emucc.py - compile C files of the project with wcc386 10.0 GA in the emulator (tools/wccre/wccemu.py).

  python3 tools/wccre/emucc.py compile SRC.c [-o OBJ]
  python3 tools/wccre/emucc.py validate [--jobs N] [SRC.c ...]

`compile` lays the files out as tools/cc.py does for DOSBox (S000.C, the headers in INC\\ with 8.3 upper-case
names, INCLUDE=C:\\INC, no options) and runs the compiler in unicorn. `validate` compiles every C file (or the
given ones) that has a DOSBox object in the tools/cc.py cache (~/.cache/nhl95pc-cc, fresh objects only) and
compares the two objects without the dependency comments (class E9h: they hold file times)."""
import argparse, functools, glob, os, shutil, struct, sys, tempfile
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, HERE); sys.path.insert(0, os.path.join(ROOT, 'tools'))
import wccemu

INC = os.path.join(ROOT, 'src/c/include')


def stage(src, work):
    os.mkdir(os.path.join(work, 'INC'))
    for h in os.listdir(INC):
        if h.endswith('.h'):
            shutil.copy(os.path.join(INC, h), os.path.join(work, 'INC', h.upper()))
    shutil.copy(src, os.path.join(work, 'S000.C'))


def compile_c(src, obj, flags='', exe=None, setup=None, fill=None, **emu_kw):
    """compile src to obj in the emulator; returns (ok, compiler output, the WccEmu). setup(emu) can add hooks."""
    work = tempfile.mkdtemp(prefix='emucc_')
    try:
        stage(src, work)
        emu = wccemu.WccEmu(exe or os.path.join(ROOT, 'tools/watcom/dosga/WCC386.EXE'), work,
                            (flags.split() if flags else []) + ['S000.C'], fill=fill, **emu_kw)
        if setup: setup(emu)
        emu.run()
        out = emu.stdout.decode('latin-1').replace('\r', '')
        o = [p for p in os.listdir(work) if p.upper() == 'S000.OBJ']
        ok = bool(o) and ' 0 errors' in out
        if ok:
            os.makedirs(os.path.dirname(os.path.abspath(obj)), exist_ok=True)
            shutil.copy(os.path.join(work, o[0]), obj)
        return ok, out, emu
    finally:
        shutil.rmtree(work, ignore_errors=True)


def compile_session(items, exe=None, setup=None, **emu_kw):
    """compile [(src, obj)] one after another in one emulated session (as tools/cc.py batches DOSBox: S000.C,
    S001.C ... in one directory; each run starts on the memory the previous one left). Returns [(ok, output)]."""
    work = tempfile.mkdtemp(prefix='emucc_')
    try:
        stage(items[0][0], work)
        res, emu = [], None
        for k, (src, obj) in enumerate(items):
            name = 'S%03d.C' % k
            shutil.copy(src, os.path.join(work, name))
            if emu is None:
                emu = wccemu.WccEmu(exe or os.path.join(ROOT, 'tools/watcom/dosga/WCC386.EXE'), work, [name], **emu_kw)
                if setup: setup(emu)
            else:
                emu.start(work, [name])
            emu.run()
            out = emu.stdout.decode('latin-1').replace('\r', '')
            o = [p for p in os.listdir(work) if p.upper() == 'S%03d.OBJ' % k]
            ok = bool(o) and ' 0 errors' in out
            if ok:
                os.makedirs(os.path.dirname(os.path.abspath(obj)), exist_ok=True)
                shutil.copy(os.path.join(work, o[0]), obj)
            res.append((ok, out))
        return res
    finally:
        shutil.rmtree(work, ignore_errors=True)


def strip_deps(data):
    """the OMF records of an object without the dependency comments (88h class E9h)"""
    out, i = bytearray(), 0
    while i + 3 <= len(data):
        typ, ln = data[i], struct.unpack_from('<H', data, i + 1)[0]
        rec = data[i:i + 3 + ln]
        if not (typ == 0x88 and ln >= 2 and rec[4] == 0xE9):
            out += rec
        i += 3 + ln
    return bytes(out)


def _validate_one(src, fill=None, emu_kw={}):
    import cc
    key = cc.cache_key(src, cc.src_flags(src))
    ref = os.path.join(cc.CACHE, key + '.obj')
    if not os.path.exists(ref):
        return src, 'nocache', ''
    tmp = tempfile.mktemp(suffix='.obj')
    try:
        ok, out, emu = compile_c(src, tmp, cc.src_flags(src), fill=fill, **emu_kw)
        if not ok:
            return src, 'fail', out
        same = strip_deps(open(tmp, 'rb').read()) == strip_deps(open(ref, 'rb').read())
        return src, 'same' if same else 'DIFF', ''
    except SystemExit as e:
        return src, 'error', str(e)
    finally:
        if os.path.exists(tmp): os.remove(tmp)


def main():
    ap = argparse.ArgumentParser()
    sub = ap.add_subparsers(dest='cmd', required=True)
    c = sub.add_parser('compile'); c.add_argument('src'); c.add_argument('-o', '--obj')
    v = sub.add_parser('validate'); v.add_argument('srcs', nargs='*'); v.add_argument('--jobs', type=int, default=8)
    v.add_argument('--fill', type=lambda x: int(x, 0), help='fill fresh memory with this byte (default zeros)')
    v.add_argument('--heap-skew', type=lambda x: int(x, 0), default=0)
    v.add_argument('--heap-align', type=lambda x: int(x, 0), default=0x10000)
    a = ap.parse_args()
    if a.cmd == 'compile':
        obj = a.obj or os.path.splitext(os.path.basename(a.src))[0] + '.obj'
        ok, out, emu = compile_c(a.src, obj)
        sys.stdout.write(out)
        sys.exit(0 if ok else 1)
    srcs = a.srcs or sorted(glob.glob(os.path.join(ROOT, 'src/c/*/*.c')))
    from multiprocessing import Pool
    from collections import Counter
    n = Counter()
    with Pool(a.jobs) as pool:
        for src, res, msg in pool.imap_unordered(functools.partial(_validate_one, fill=a.fill, emu_kw=dict(heap_skew=a.heap_skew, heap_align=a.heap_align)), srcs):
            n[res] += 1
            if res in ('DIFF', 'fail', 'error'):
                print('%-6s %s %s' % (res, os.path.relpath(src, ROOT), msg.strip().split('\n')[-1] if msg else ''), flush=True)
    print(dict(n))


if __name__ == '__main__':
    main()
