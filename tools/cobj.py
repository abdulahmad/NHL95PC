#!/usr/bin/env python3
"""cobj.py - read one Watcom wcc386 OMF object for C matching.

  parse(path) -> dict(text=bytes, fixups=[Fixup], pubs={asm_name: offset}, segs={name: size}, raw_pubs, exts)
  Fixup = dict(off, kind ('abs32' | 'rel32'), target (asm label name or 'TEXT'), addend)

Only what the matched game functions need: the _TEXT segment, 32-bit offset fixups (loc 9) and 32-bit
self-relative fixups (call/jmp rel32 to another module). Targets are EXTDEF symbols or the module's own _TEXT
(switch jump tables). Anything else (string literals in CONST, static data in _DATA/_BSS) raises CObjError: such a
function cannot be spliced into the asm segment yet.

Watcom name decoration (register convention, default flags): functions get a trailing '_', data a leading '_'.
asm_name() undoes it: SetSPA_ -> SetSPA, _gameclock -> gameclock; names that already exist as asm labels with the
decoration (library code: strcpy_, __CHK) are kept as they are."""
import struct, sys

class CObjError(Exception): pass

def _idx(b, p):
    v = b[p]
    if v & 0x80: return ((v & 0x7F) << 8) | b[p + 1], p + 2
    return v, p + 1

def asm_name(n, known=None):
    if known is not None and n in known: return n
    cands = []
    if n.endswith('_') and not n.startswith('__'): cands.append(n[:-1])
    if n.startswith('_') and not n.startswith('__'): cands.append(n[1:])
    for c in cands:
        if known is None or c in known: return c
    return cands[0] if cands else n

def parse(path, known=None):
    data = open(path, 'rb').read()
    lnames = ['']; segs = []; exts = ['']; pubs = []; grps = ['']
    last = None; fixups = []; threads = {}   # (is_frame, num) -> (method, index)
    p = 0
    while p + 3 <= len(data):
        t = data[p]; ln = struct.unpack_from('<H', data, p + 1)[0]; b = data[p + 3:p + 3 + ln - 1]; p += 3 + ln
        if t in (0x96, 0xCA):
            q = 0
            while q < len(b): l = b[q]; lnames.append(b[q + 1:q + 1 + l].decode('latin1')); q += 1 + l
        elif t in (0x98, 0x99):
            big = t & 1; attr = b[0]; q = 1
            if (attr >> 5) == 0: q += 3
            sz = struct.unpack_from('<I' if big else '<H', b, q)[0]; q += 4 if big else 2
            ni, q = _idx(b, q)
            segs.append(dict(name=lnames[ni], size=sz, data=bytearray(sz)))
        elif t == 0x9A:
            ni, _ = _idx(b, 0); grps.append(lnames[ni])
        elif t in (0x8C, 0xB4):
            q = 0
            while q < len(b):
                l = b[q]; exts.append(b[q + 1:q + 1 + l].decode('latin1')); q += 1 + l; _, q = _idx(b, q)
        elif t in (0x90, 0x91, 0xB6, 0xB7):
            big = t & 1; q = 0
            gi, q = _idx(b, q); si, q = _idx(b, q)
            if si == 0: q += 2
            while q < len(b):
                l = b[q]; nm = b[q + 1:q + 1 + l].decode('latin1'); q += 1 + l
                if not big and len(b) - q == 5: big = 1
                off = struct.unpack_from('<I' if big else '<H', b, q)[0]; q += 4 if big else 2
                _, q = _idx(b, q)
                pubs.append((nm, segs[si - 1]['name'] if si else None, off))
        elif t in (0xA0, 0xA1):
            big = t & 1; si, q = _idx(b, 0)
            off = struct.unpack_from('<I' if big else '<H', b, q)[0]; q += 4 if big else 2
            chunk = b[q:]; s = segs[si - 1]
            if off + len(chunk) > len(s['data']): s['data'].extend(bytes(off + len(chunk) - len(s['data'])))
            s['data'][off:off + len(chunk)] = chunk
            last = (si, off)
        elif t in (0xA2, 0xA3):
            raise CObjError('LIDATA record (initialised static data): not supported')
        elif t in (0x9C, 0x9D):
            big = t & 1; q = 0
            while q < len(b):
                h = b[q]
                if not h & 0x80:          # THREAD subrecord
                    isf = bool(h & 0x40); meth = (h >> 2) & 7; num = h & 3; q += 1
                    ix = None
                    if meth < 3 or not isf: ix, q = _idx(b, q)
                    threads[(isf, num)] = (meth, ix); continue
                loc = (h >> 2) & 0xF; segrel = bool(h & 0x40); drec = ((h & 3) << 8) | b[q + 1]; q += 2
                fd = b[q]; q += 1
                if fd & 0x80: fm, fi = threads[(True, (fd >> 4) & 3)]
                else:
                    fm = (fd >> 4) & 7; fi = None
                    if fm < 3: fi, q = _idx(b, q)
                if fd & 0x08: tm, ti = threads[(False, fd & 3)]; tm &= 3
                else:
                    tm = fd & 3; ti, q = _idx(b, q)
                disp = 0
                if not fd & 0x04:
                    disp = struct.unpack_from('<I' if big else '<H', b, q)[0]; q += 4 if big else 2
                si, off = last; s = segs[si - 1]
                if s['name'] != '_TEXT': raise CObjError('fixup in segment %s' % s['name'])
                if loc != 9: raise CObjError('fixup location type %d at _TEXT+%X (only 32-bit offsets)' % (loc, off + drec))
                o = off + drec
                if tm == 2: tgt = asm_name(exts[ti], known)
                elif tm == 0:
                    sname = segs[ti - 1]['name']
                    if sname != '_TEXT': raise CObjError('reference to %s at _TEXT+%X (string literal or static data)' % (sname, o))
                    tgt = 'TEXT'
                else: raise CObjError('fixup target method %d' % tm)
                inline = struct.unpack_from('<i', s['data'], o)[0]
                fixups.append(dict(off=o, kind='abs32' if segrel else 'rel32', target=tgt, addend=inline + disp))
    segd = {s['name']: s for s in segs}
    for s in segs:
        if s['name'] != '_TEXT' and s['size']: raise CObjError('segment %s has %d bytes (string literals / static data)' % (s['name'], s['size']))
    text = bytes(segd['_TEXT']['data']) if '_TEXT' in segd else b''
    tp = {asm_name(n, known): off for n, sg, off in pubs if sg == '_TEXT'}
    return dict(text=text, fixups=sorted(fixups, key=lambda f: f['off']), pubs=tp, raw_pubs=pubs, exts=exts[1:])

if __name__ == '__main__':
    r = parse(sys.argv[1])
    print('text %d bytes, publics %s' % (len(r['text']), r['pubs']))
    for f in r['fixups']: print('  +%04X %s %s%+d' % (f['off'], f['kind'], f['target'], f['addend']))
