#!/usr/bin/env python3
"""cdiff.py - objdiff-style compare of a C function's compiled code with the original.

  python3 tools/cdiff.py src/c/<seg>/<Func>.c [--obj OBJ] [--func NAME] [--all] [--context N]

Compiles the C file (tools/cc.py compile -> build/c/<seg>/<Func>.obj) unless --obj is given, then disassembles
both sides with capstone and prints them side by side from the function start (the asm label <Func>, or --func).
The original bytes come from build/parts (your EXE, extracted by `make`), its fixup targets from le_fixups.tsv and
the label addresses from build/obj (run `make` first). Relocated fields are compared by target address, not by
bytes: a compiled `call foo_` matches the original if foo is the label at the call's target.
Markers: '  ' same, '~ ' same instruction with a different relocation target / immediate, '! ' different.
Exit status 0 when the whole function matches (size included), 1 otherwise."""
import os, re, sys, json, argparse, subprocess
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import cobj, cc
from capstone import Cs, CS_ARCH_X86, CS_MODE_32

def load_labels():
    from gen_cheaders import labels
    lab = labels()
    rev = {}
    for n, (a, k, g) in lab.items():
        if a not in rev or (g and not lab[rev[a]][2]) or ('.' in rev[a] and '.' not in n): rev[a] = n
    return {n: v[0] for n, v in lab.items()}, rev

def original(addr, n):
    man = json.load(open(os.path.join(ROOT, 'build/parts/manifest.json')))
    for m in man['segments']:
        s0, s1 = int(m['start'], 16), int(m['end'], 16)
        if m['obj'] == 1 and s0 <= addr < s1:
            d = open(os.path.join(ROOT, 'build/parts', m['file']), 'rb').read()
            return d[addr - s0:addr - s0 + n]
    raise SystemExit('address %X not in cseg01' % addr)

def orig_fixups(a0, a1):
    le = json.load(open(os.path.join(ROOT, 'build/parts/le.json')))
    base = {k + 1: o['base'] for k, o in enumerate(le['objects'])}
    out = {}
    for ln in open(os.path.join(ROOT, 'build/parts/le_fixups.tsv')):
        if ln.startswith('#'): continue
        c, s, t, o = ln.split(); s = int(s, 16)
        if a0 <= s < a1: out[s - a0] = base[int(t)] + int(o, 16)
    return out

def func_addr(src, func):
    stem, f, asm, inc = cc.c_paths(src)
    func = func or f
    L = open(asm).read().split('\n')
    for k, l in enumerate(L):
        if l.startswith(func + ':'):
            for l2 in L[k + 1:]:
                a = cc.ADDR.search(l2)
                if a: return func, int(a.group(1), 16)
    raise SystemExit('label %s not found in %s' % (func, asm))

def sx(v):
    return v - (1 << 32) if v >= 1 << 31 else v

def name_of(rev, a):
    if a in rev: return rev[a]
    best = max((x for x in rev if x <= a and a - x < 0x10000), default=None)
    return '%s+%X' % (rev[best], a - best) if best is not None else '%X' % a

def main():
    ap = argparse.ArgumentParser(); ap.add_argument('src'); ap.add_argument('--obj'); ap.add_argument('--func')
    ap.add_argument('--context', type=int, default=6); ap.add_argument('--all', action='store_true')
    a = ap.parse_args()
    obj = a.obj or os.path.join(ROOT, 'build', os.path.relpath(os.path.splitext(os.path.abspath(a.src))[0], os.path.join(ROOT, 'src')) + '.obj')
    if not a.obj and not cc.compile_c(a.src, obj): sys.exit(2)
    labaddr, rev = load_labels()
    func, addr = func_addr(a.src, a.func)
    r = cobj.parse(obj, set(labaddr))
    pubs = sorted(r['pubs'].items(), key=lambda x: x[1])
    off0 = r['pubs'].get(func, 0); nxt = [o for n, o in pubs if o > off0]
    # the whole object from the first public (shared tails / several functions per file)
    text = r['text']; c0 = off0
    n = len(text) - c0
    stem, fil, asm, inc = cc.c_paths(a.src)
    if func != fil and len(r['pubs']) > 1:     # one function of a multi-function file: just its asm block
        n = min(n, cc.asm_range(a.src, func)[1] - addr)
    tt = None
    orig = original(addr, max(n, 1) + 64)
    ofx = orig_fixups(addr, addr + len(orig))
    cfx = {f['off'] - c0: f for f in r['fixups'] if f['off'] >= c0}
    md = Cs(CS_ARCH_X86, CS_MODE_32)
    def dis(buf, limit):
        out = []
        for i in md.disasm(buf, 0):
            if i.address >= limit: break
            out.append(i)
        return out
    C = dis(text[c0:], n); O = dis(orig, n + 64)
    def ctgt(i):
        for k in range(i.address, i.address + i.size):
            f = cfx.get(k)
            if f:
                t = addr - c0 if f['target'] == 'TEXT' else labaddr.get(f['target'])
                if t is None: return ('?' + f['target'], f['kind'])
                return (t + f['addend'] + (0 if f['kind'] == 'abs32' else 0), f['kind'], k)
        return None
    def otgt(i):
        for k in range(i.address, i.address + i.size):
            if k in ofx: return (ofx[k], 'abs32', k)
        return None
    rows = []; first = None; nO = {i.address: i for i in O}
    oi = 0
    for ci in C:
        oinst = O[oi] if oi < len(O) else None; oi += 1
        cb = text[c0 + ci.address:c0 + ci.address + ci.size]
        ct = ctgt(ci); mark = '  '
        if oinst is None: mark = '! '; otxt = ''
        else:
            ob = bytes(oinst.bytes); ot = otgt(oinst)
            otxt = '%s %s' % (oinst.mnemonic, oinst.op_str)
            if ct and ct[1] == 'rel32':
                # compare by destination
                if ob[:len(cb) - 4] != cb[:len(cb) - 4] or len(ob) != len(cb): mark = '! '
                else:
                    dest = addr + oinst.address + oinst.size + int.from_bytes(ob[-4:], 'little', signed=True)
                    if dest != ct[0]: mark = '~ '
                    otxt += '  ; ' + name_of(rev, dest)
            elif ct or ot:
                k = (ct or ot)[2]
                mb = lambda b: b[:k - ci.address] + b[k - ci.address + 4:]
                if len(ob) != len(cb) or mb(ob) != mb(cb): mark = '! '
                elif not ct or not ot or ct[0] != ot[0]: mark = '~ '
                if ot: otxt += '  ; ' + name_of(rev, ot[0])
            elif ob != cb and ci.mnemonic.startswith('j') and ci.size == oinst.size and ci.mnemonic == oinst.mnemonic \
                    and ci.op_str.startswith('0x') and not (0 <= sx(int(ci.op_str, 16)) < n):
                # leaves the function: to another block / shared tail of the file (cc.py TextTargets)
                if tt is None: tt = cc.TextTargets(a.src, r)
                try: cd = tt.resolve(c0 + sx(int(ci.op_str, 16)), func)[1]
                except SystemExit: cd = None
                od = addr + oinst.address + oinst.size + int.from_bytes(ob[-4:] if ci.size > 2 else ob[-1:], 'little', signed=True)
                mark = '  ' if cd == od else '! '
                otxt += '  ; ' + name_of(rev, od)
            elif ob != cb: mark = '! ' if (oinst.mnemonic != ci.mnemonic or oinst.size != ci.size) else '~ '
        ctxt = '%s %s' % (ci.mnemonic, ci.op_str)
        if ct:
            ctxt += '  ; ' + (ct[0] if isinstance(ct[0], str) else name_of(rev, ct[0]))
        rows.append((mark, ci.address, ctxt, otxt))
        if mark != '  ' and first is None: first = len(rows) - 1
    olen = cc.asm_range(a.src, func)[1] - addr
    print('%s %05X: compiled %d bytes, original %s bytes' % (func, addr, n, olen if olen is not None else '?'))
    show = range(len(rows)) if a.all or first is None else range(max(0, first - a.context), min(len(rows), first + 4 * a.context))
    print('     off  %-44s %s' % ('compiled (wcc386)', 'original'))
    for k in show:
        m, off, ct_, ot_ = rows[k]
        print('%s %05X+%03X %-44s %s' % (m, addr, off, ct_[:44], ot_[:60]))
    ok = first is None and olen == n
    if ok: print('MATCH')
    else:
        if first is not None: print('first difference at +%X' % rows[first][1])
        if olen != n: print('size differs: compiled %d, original %s' % (n, olen))
    sys.exit(0 if ok else 1)

if __name__ == '__main__':
    main()
