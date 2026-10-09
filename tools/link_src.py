#!/usr/bin/env python3
"""link_src.py - link the assembled src/ tree into HOCKEY.EXE and check its sha1.

  python3 tools/link_src.py [--obj build/obj] [--parts build/parts] [--out build/HOCKEY.EXE]

Inputs
  src/segments.txt      layout: one line per segment (object, start, end, initialised bytes, module, source file)
  build/obj/**.o        nasm -f elf32 output of every src/*.asm (one section s_<ADDR> per file)
  build/parts           `rebuild_exe.py extract` of YOUR HOCKEY.EXE; only these are used from it:
                          stub/*      DOS/16M loader, DOS/4GW kernel, Watcom wstub (third-party, never in the repo)
                          le.json     LE header fields / object table / entry + name tables
                          le_fixups.tsv  used ONLY for the order of the fixup records (wlink order), via order_fixups()
                        No segment bytes and no fixup targets are taken from the EXE: they come from the objects.
Steps
  1. read every object; a section named s_<ADDR> is placed at linear address ADDR; global labels -> symbol table
  2. apply relocations: R_386_32 -> 32-bit LE internal fixup (stored value = object-relative offset, as wlink does),
     R_386_PC32 / R_386_PC8 -> resolved in place (no fixup)
  3. write the segment slices into build/link (initialised bytes only; BSS must assemble to zeros / nobits)
  4. fixup set -> order_fixups() -> rebuild_exe.build() -> sha1 check (exit status 1 on mismatch)
Needs only Python 3 (no iced-x86)."""
import os, sys, json, struct, shutil, hashlib, argparse
from collections import defaultdict
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
SHA1 = '3961e0eba6b0338fad1613bb534efafd9406ed4a'

def read_elf(path):
    """minimal ELF32 reader: (data, sections, symbols, relocations by target section index)"""
    d = open(path, 'rb').read()
    assert d[:4] == b'\x7fELF' and d[4] == 1, path
    shoff, = struct.unpack_from('<I', d, 0x20); shentsize, shnum, shstrndx = struct.unpack_from('<HHH', d, 0x2E)
    sh = [struct.unpack_from('<10I', d, shoff + i * shentsize) for i in range(shnum)]
    def sname(off, strtab):
        e = d.index(b'\0', strtab + off); return d[strtab + off:e].decode()
    shstr = sh[shstrndx][4]
    secs = [dict(name=sname(s[0], shstr), type=s[1], off=s[4], size=s[5], link=s[6], info=s[7], entsize=s[9]) for s in sh]
    syms = []
    for i, s in enumerate(secs):
        if s['type'] == 2:
            strt = secs[s['link']]['off']
            for k in range(s['size'] // 16):
                nm, val, sz, info, oth, shn = struct.unpack_from('<IIIBBH', d, s['off'] + 16 * k)
                syms.append(dict(name=sname(nm, strt), value=val, shndx=shn, type=info & 15, bind=info >> 4))
    rels = defaultdict(list)
    for s in secs:
        if s['type'] == 9:
            for k in range(s['size'] // 8):
                o, info = struct.unpack_from('<II', d, s['off'] + 8 * k); rels[s['info']].append((o, info >> 8, info & 0xFF))
    return d, secs, syms, rels

def read_layout(path=os.path.join(ROOT, 'src/segments.txt')):
    segs = []
    for ln in open(path):
        if ln.startswith('#') or not ln.strip(): continue
        ob, s0, s1, nb, mod, src = ln.split()
        segs.append(dict(obj=int(ob), start=int(s0, 16), end=int(s1, 16), bytes=int(nb), module=mod, src=src))
    return segs

def link(segs, objdir, objs_le):
    """objs_le: {1: (base, vsize), 2: ...}. Returns ({start: bytes}, [(src, tobj, toff)], errors)"""
    loaded = []; gsym = {}; errors = []
    for sg in segs:
        op = os.path.join(objdir, os.path.splitext(sg['src'])[0] + '.o')
        d, secs, syms, rels = read_elf(op)
        si = [i for i, s in enumerate(secs) if s['name'] == 's_%05X' % sg['start']]
        if len(si) != 1: errors.append('%s: expected one section s_%05X' % (op, sg['start'])); continue
        si = si[0]
        for s in secs:
            if s['size'] and s['type'] in (1, 8) and s['name'] != 's_%05X' % sg['start']:
                errors.append('%s: unexpected section %s (one section per file)' % (op, s['name']))
        for sy in syms:
            if sy['bind'] == 1 and sy['shndx'] == si:
                if sy['name'] in gsym: errors.append('duplicate global %s (%s and %s)' % (sy['name'], gsym[sy['name']][1], sg['src']))
                gsym[sy['name']] = (sg['start'] + sy['value'], sg['src'])
        loaded.append((sg, d, secs, syms, rels, si))
    out = {}; fixups = []
    def objof(v):
        for k, (b, n) in objs_le.items():
            if b <= v < b + n: return k
        return None
    for sg, d, secs, syms, rels, si in loaded:
        s0 = sg['start']; sec = secs[si]
        buf = bytearray(d[sec['off']:sec['off'] + sec['size']]) if sec['type'] != 8 else bytearray(sec['size'])
        for o, symi, typ in rels.get(si, []):
            sy = syms[symi]
            if sy['shndx'] == 0:
                if sy['name'] not in gsym: errors.append('%s: undefined symbol %s' % (sg['src'], sy['name'])); continue
                S = gsym[sy['name']][0]
            elif sy['shndx'] == si: S = s0 + sy['value']
            else: errors.append('%s: relocation against another section' % sg['src']); continue
            P = s0 + o
            if typ == 23:      # R_386_PC8
                v = S + struct.unpack_from('<b', buf, o)[0] - P
                if not -128 <= v < 128: errors.append('%s: short branch at %05X out of range' % (sg['src'], P))
                struct.pack_into('<B', buf, o, v & 0xFF); continue
            add = struct.unpack_from('<i', buf, o)[0]
            if typ == 1:       # R_386_32 -> LE internal 32-bit offset fixup
                v = S + add; tobj = objof(v)
                if tobj is None:
                    # one past the end of an object is a valid pointer target
                    tobj = next((k for k, (b, n) in objs_le.items() if v == b + n), None)
                    if tobj is None: errors.append('%s: fixup at %05X targets %X outside the objects' % (sg['src'], P, v)); continue
                toff = v - objs_le[tobj][0]
                struct.pack_into('<I', buf, o, toff); fixups.append((P, tobj, toff))
            elif typ == 2:     # R_386_PC32
                struct.pack_into('<I', buf, o, (S + add - P) & 0xFFFFFFFF)
            else: errors.append('%s: relocation type %d' % (sg['src'], typ))
        if len(buf) != sg['end'] - sg['start']:
            errors.append('%s: assembled size %X, segment size %X (the segment layout is fixed)' % (sg['src'], len(buf), sg['end'] - sg['start']))
        if any(buf[sg['bytes']:]): errors.append('%s: non-zero bytes in the BSS part' % sg['src'])
        out[s0] = bytes(buf)
    return out, fixups, errors

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--obj', default=os.path.join(ROOT, 'build/obj'))
    ap.add_argument('--parts', default=os.path.join(ROOT, 'build/parts'), help='rebuild_exe.py extract output of your HOCKEY.EXE')
    ap.add_argument('--work', default=os.path.join(ROOT, 'build/link'))
    ap.add_argument('--out', default=os.path.join(ROOT, 'build/HOCKEY.EXE'))
    a = ap.parse_args()
    import rebuild_exe as RB
    segs = read_layout()
    man = json.load(open(os.path.join(a.parts, 'manifest.json')))
    le = json.load(open(os.path.join(a.parts, 'le.json')))
    objs_le = {k + 1: (o['base'], o['virtual_size']) for k, o in enumerate(le['objects'])}
    ms = [(m['obj'], int(m['start'], 16), int(m['end'], 16), m['bytes']) for m in man['segments'] if not m.get('zero_pad')]
    if ms != [(s['obj'], s['start'], s['end'], s['bytes']) for s in segs]:
        sys.exit('build/parts was split with a different segment map than src/segments.txt: re-run rebuild_exe.py extract')
    data, fixups, errors = link(segs, a.obj, objs_le)
    for e in errors[:50]: print('error:', e, file=sys.stderr)
    if errors: sys.exit('link failed: %d errors' % len(errors))
    # parts for rebuild_exe.build: stubs + LE metadata from the extract, segment slices from the objects
    if os.path.isdir(a.work): shutil.rmtree(a.work)
    os.makedirs(a.work)
    shutil.copytree(os.path.join(a.parts, 'stub'), os.path.join(a.work, 'stub'))
    for f in ('le.json', 'manifest.json'): shutil.copy(os.path.join(a.parts, f), a.work)
    for m in man['segments']:
        if m.get('zero_pad'): continue      # page padding after an object's vsize: zeros, written by build()
        p = os.path.join(a.work, m['file']); os.makedirs(os.path.dirname(p), exist_ok=True)
        open(p, 'wb').write(data[int(m['start'], 16)][:m['bytes']])
    # fixups: the set comes from the relocations; the EXE's table only supplies the record order
    order = os.path.join(a.parts, 'le_fixups.tsv')
    ordered, nnew = RB.order_fixups(fixups, order)
    tsv = os.path.join(a.work, 'fixups.tsv')
    with open(tsv, 'w') as fo:
        for c, s, t, to in ordered: fo.write('%d\t%05X\t%d\t%X\n' % (c, s, t, to))
    ref = set()
    for ln in open(order):
        if ln.startswith('#') or not ln.strip(): continue
        c, s, t, to = ln.split(); ref.add((int(s, 16), int(t), int(to, 16)))
    have = set(fixups)
    exe, mism = RB.build(a.work, a.out, tsv)
    h = hashlib.sha1(exe).hexdigest()
    rep = dict(segments=len(segs), objects_linked=len(data), fixups=len(fixups), fixups_not_in_exe_order_table=nnew,
               fixups_missing_vs_exe=len(ref - have), fixups_extra_vs_exe=len(have - ref), out=os.path.relpath(a.out, ROOT),
               bytes=len(exe), sha1=h, match=h == SHA1)
    print(json.dumps(rep, indent=1))
    if h != SHA1:
        # where does it differ? compare with the slices rebuild_exe.py extracted from your EXE, and the fixup sets
        nd = 0
        for m in man['segments']:
            if m.get('zero_pad') or not m['bytes']: continue
            ref_b = open(os.path.join(a.parts, m['file']), 'rb').read(); got = data[int(m['start'], 16)][:m['bytes']]
            for i in range(min(len(ref_b), len(got))):
                if ref_b[i] != got[i]:
                    if nd < 8: print('first difference: %05X in %s: built %02X, retail %02X' % (int(m['start'], 16) + i, m['file'].split('/')[-1][:-4], got[i], ref_b[i]))
                    nd += 1
        if nd: print('%d differing bytes in the segment slices (instruction address comments: grep the address in src/)' % nd)
        for tag, sset in (('fixup missing (in the EXE, not in src/)', ref - have), ('fixup extra (in src/, not in the EXE)', have - ref)):
            for s_, t_, o_ in sorted(sset)[:8]: print('%s: source %05X -> object %d offset %X' % (tag, s_, t_, o_))
    print(('MATCH: %s is byte-identical to the retail HOCKEY.EXE' if h == SHA1 else 'MISMATCH: %s differs from the retail HOCKEY.EXE') % rep['out'])
    sys.exit(0 if h == SHA1 else 1)

if __name__ == '__main__':
    main()
