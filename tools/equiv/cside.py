#!/usr/bin/env python3
"""C side of the functional-equivalence harness (FUNCTIONAL_PLAN.md, "How the check works" item 3).

  obj = compile_draft('src/c/<seg>/<F>.c')        # cc.py compile path, cached by source hash in build/equiv/
  entry, extent, code = place(img, obj, 'F')      # run.run(img, entry, extent, state, code=code)

place() copies the whole _TEXT of the object to the scratch base and resolves every fixup the way the asm build does:
a name that is a public of the object itself -> scratch base + offset; any other name -> its img.labels() address
(functions and data; cobj.asm_name undoes the Watcom decoration, so SetSPA_ -> SetSPA, _gameclock -> gameclock);
'TEXT' (switch tables) -> scratch base + addend. abs32 stores the address; rel32 stores target - (site + 4).
The extent is the whole placed _TEXT, not just the function: a shared tail or a second function of the same file
runs on the C side, and a call to another function of the file stays inside. Calls to EXE labels leave the extent
and hit run.py's stubs on both sides, so callee logs are comparable.
Unsupported for now: objects with CONST/_DATA/_BSS bytes (string literals, statics); cobj refuses them."""
import os, sys, struct, dataclasses
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, os.path.join(ROOT, 'tools')); sys.path.insert(0, HERE)
import cc, cobj

OUT = os.path.join(ROOT, 'build', 'equiv')
BASE = 0x7000000

class Unsupported(Exception): pass

def compile_draft(c_path):
    """compile through cc.compile_c (its own cache, flags and headers rule); the object is kept at
    build/equiv/<sha1 of compiler, flags, source, headers>.obj so a repeat call never starts DOSBox"""
    c_path = os.path.abspath(c_path)
    obj = os.path.join(OUT, cc.cache_key(c_path, cc.src_flags(c_path, '')) + '.obj')
    if not os.path.exists(obj):
        os.makedirs(OUT, exist_ok=True); tmp = obj + '.%d' % os.getpid()
        if not cc.compile_c(c_path, tmp): raise SystemExit('compile failed: %s' % c_path)
        os.replace(tmp, obj)
    return _parse(obj)

def _parse(obj, known=None):
    try: r = cobj.parse(obj, known)
    except cobj.CObjError as e: raise Unsupported('unsupported for now (%s): %s' % (os.path.basename(obj), e))
    r['path'] = obj
    return r

def place(img, obj, func, base=BASE):
    """-> (entry, (base, base + len(text)), [(base, bytes)]) for run.run(..., code=code)"""
    lab = img.labels()
    r = _parse(obj['path'], set(lab)) if obj.get('path') else obj   # reparse: decoration maps against real labels
    text = bytearray(r['text'])
    if func not in r['pubs']: raise KeyError('%s is not a public of the object (has %s)' % (func, sorted(r['pubs'])))
    for f in r['fixups']:
        n = f['target']
        if n == 'TEXT': dest = base
        elif n in r['pubs']: dest = base + r['pubs'][n]
        elif n in lab: dest = lab[n]
        else: raise KeyError('unresolvable name %r (fixup at _TEXT+%#x)' % (n, f['off']))
        dest += f['addend']
        v = dest if f['kind'] == 'abs32' else dest - (base + f['off'] + 4)
        text[f['off']:f['off'] + 4] = struct.pack('<I', v & 0xFFFFFFFF)
    return base + r['pubs'][func], (base, base + len(text)), [(base, bytes(text))]

def _csv_rows():
    import csv
    return list(csv.DictReader(open(os.path.join(ROOT, 'tools', 'c_functions.csv'))))

def _check_matched(img, name, c_file, size):
    """(a) bytes equal except at fixup sites, whose resolved targets equal the original's; (b) equal traces"""
    import run
    lab = img.labels(); addr = lab[name]; o = compile_draft(os.path.join(ROOT, c_file))
    entry, ext, code = place(img, o, name); text = code[0][1]; base = ext[0]
    r = _parse(o['path'], set(lab)); errs = []
    if len(r['pubs']) != 1: return ['file has %d functions' % len(r['pubs'])], 0, 0
    if len(text) != size: errs.append('size %d != %d' % (len(text), size))
    orig = img.read(addr, size); sites = {f['off']: f for f in r['fixups']}
    cov = set(k for s in sites for k in range(s, s + 4))
    for i in range(min(size, len(text))):
        if i not in cov and text[i] != orig[i]: errs.append('byte +%#x %02x != %02x' % (i, text[i], orig[i])); break
    for s, f in sites.items():
        c = struct.unpack_from('<I', text, s)[0]; o4 = struct.unpack_from('<I', orig, s)[0]
        if f['kind'] == 'rel32': c, o4 = (c + base + s + 4) & 0xFFFFFFFF, (o4 + addr + s + 4) & 0xFFFFFFFF
        if f['target'] == 'TEXT': c, o4 = c - base, o4 - addr   # switch table inside the function
        if c != o4: errs.append('fixup +%#x %s %s: %#x != %#x' % (s, f['kind'], f['target'], c, o4))
    nf = len(sites)
    tr = []
    for k, st in enumerate(_states(img, name)):
        t1 = run.run(img, addr, (addr, addr + size), st); t2 = run.run(img, entry, ext, st, code=code)
        t1, t2 = _norm(t1, addr), _norm(t2, entry)
        if t1 != t2: errs.append('trace differs, case %d: %s' % (k, _first_diff(t1, t2))); break
        tr.append(t1)
    return errs, nf, tr

def _states(img, name):
    import run
    d = img.objects[1].base + 0x2000
    mk = lambda v, w: run.State(regs={'eax': d + 0x100, 'edx': v, 'ebx': w, 'ecx': 3, 'esi': 7, 'edi': 9, 'ebp': 0x55},
                                args=[v, w, 5, 6, 7, 8], script=lambda k, t: ((v * 3 + k) & 0xFFFF, k))
    return [run.State(), mk(0x1234, 5), mk(0xFFFFFFFF, 0), mk(1, 0x80000000)]

def _norm(t, start):
    """trap eips become offsets from the function start (the C side runs in scratch); nothing else is address-bound"""
    return dataclasses.replace(t, traps=[(k, e - start, d) for k, e, d in t.traps])

def _first_diff(a, b):
    for k in a.__dataclass_fields__:
        if getattr(a, k) != getattr(b, k): return '%s: %s vs %s' % (k, str(getattr(a, k))[:90], str(getattr(b, k))[:90])
    return ''

def selftest():
    import time, image, run
    img = image.load(); ok = True
    rows = _csv_rows(); cand = {}
    for r in rows:
        if r['status'] == 'matched' and r['function'] not in cand: cand[r['function']] = r
    picks = [('globals', 'GetMemListHead'), ('calls', 'DrawRinkEndArt'), ('global store', 'ResetInputSampling')]
    for kind, name in picks:
        r = cand[name]; t0 = time.time()
        try: errs, nf, tr = _check_matched(img, name, r['c_file'], int(r['size']))
        except Unsupported as e: errs, nf, tr = [str(e)], 0, []
        ok &= not errs
        print('%s matched %s (%s): %d fixups, %d cases, %.1fs %s' % ('PASS' if not errs else 'FAIL', name, kind, nf,
              len(tr) if tr else 0, time.time() - t0, '; '.join(errs)))
    for name in ('SeriesLength', 'FadePalette'):
        r = next(x for x in rows if x['function'] == name)
        try:
            o = compile_draft(os.path.join(ROOT, r['c_file'])); entry, ext, code = place(img, o, name)
        except (Unsupported, KeyError) as e:
            ok = False; print('FAIL draft %s: %s' % (name, e)); continue
        a = img.labels()[name]; st = run.State()
        t1 = _norm(run.run(img, a, (a, a + int(r['size'])), st), a); t2 = _norm(run.run(img, entry, ext, st, code=code), entry)
        print('PASS draft %s placed at %#x (%d bytes); default-state traces %s%s' % (name, entry, len(code[0][1]),
              'equal' if t1 == t2 else 'DIFFER', '' if t1 == t2 else ' (' + _first_diff(t1, t2) + ')'))
    print('ALL PASS' if ok else 'FAILED'); return ok

if __name__ == '__main__':
    if '--selftest' in sys.argv: sys.exit(0 if selftest() else 1)
    print(__doc__)
