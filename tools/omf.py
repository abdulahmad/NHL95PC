#!/usr/bin/env python3
"""Minimal OMF object / library reader (Watcom flavour) for library fingerprinting.
parse_lib(path) -> list of modules; module = dict(name, segs={segname: dict(data=bytearray, mask=bytearray, cls)}, pubs=[(name, seg, off)])
mask[i]=1 where byte i is covered by a fixup (value depends on link-time address)."""
import struct, sys

LOC_LEN = {0: 1, 1: 2, 2: 2, 3: 4, 4: 1, 5: 2, 9: 4, 11: 6, 13: 4}

def _idx(b, p):
    v = b[p]
    if v & 0x80: return ((v & 0x7F) << 8) | b[p + 1], p + 2
    return v, p + 1

def parse_records(data, start=0):
    p = start
    while p + 3 <= len(data):
        t = data[p]; ln = struct.unpack_from('<H', data, p + 1)[0]
        body = data[p + 3:p + 3 + ln - 1]
        yield p, t, body
        p += 3 + ln
        if t in (0x8A, 0x8B): return

def parse_module(data, start):
    lnames = ['']; segs = []; pubs = []; exts = ['']; name = None
    last = None   # (segidx, offset, length) of last LEDATA
    p = start; end = None
    for pos, t, b in parse_records(data, start):
        end = pos + 3 + struct.unpack_from('<H', data, pos + 1)[0]
        if t == 0x80: name = b[1:1 + b[0]].decode('latin1')
        elif t in (0x96, 0xCA):
            q = 0
            while q < len(b): l = b[q]; lnames.append(b[q + 1:q + 1 + l].decode('latin1')); q += 1 + l
        elif t in (0x98, 0x99):
            big = t == 0x99; attr = b[0]; q = 1
            if (attr >> 5) == 0: q += 3
            ln = struct.unpack_from('<I' if big else '<H', b, q)[0]; q += 4 if big else 2
            if attr & 2 and not big: ln = 0x10000
            ni, q = _idx(b, q); ci, q = _idx(b, q)
            segs.append(dict(name=lnames[ni], cls=lnames[ci], data=bytearray(ln), mask=bytearray(ln), fixups=[]))
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
                if not big and len(b) - q == 5: big = 1          # Watcom: 32-bit offsets inside 0x90 records
                off = struct.unpack_from('<I' if big else '<H', b, q)[0]; q += 4 if big else 2
                _, q = _idx(b, q)
                pubs.append((nm, segs[si - 1]['name'] if si else None, off))
        elif t in (0xA0, 0xA1):
            big = t & 1; si, q = _idx(b, 0)
            off = struct.unpack_from('<I' if big else '<H', b, q)[0]; q += 4 if big else 2
            chunk = b[q:]; s = segs[si - 1]
            if off + len(chunk) > len(s['data']): s['data'].extend(bytes(off + len(chunk) - len(s['data']))); s['mask'].extend(bytes(off + len(chunk) - len(s['mask'])))
            s['data'][off:off + len(chunk)] = chunk
            last = (si, off, len(chunk))
        elif t in (0xA2, 0xA3):
            last = None   # LIDATA: rare in clib code; ignore content (mask whole thing unknown)
        elif t in (0x9C, 0x9D):
            big = t & 1; q = 0
            while q < len(b):
                h = b[q]
                if not h & 0x80:   # THREAD
                    meth = (h >> 2) & 7; q += 1
                    if not (h & 0x40) and meth < 3: _, q = _idx(b, q)
                    elif (h & 0x40) and meth < 3: _, q = _idx(b, q)
                    continue
                loc = (h >> 2) & 0xF; m = h & 0x40; drec = ((h & 3) << 8) | b[q + 1]; q += 2
                fd = b[q]; q += 1
                if not fd & 0x80:
                    fm = (fd >> 4) & 7
                    if fm < 3: _, q = _idx(b, q)
                if not fd & 0x08:
                    tm = fd & 3
                    tidx, q = _idx(b, q)
                else:
                    tm = fd & 3; tidx = None
                if not fd & 0x04: q += 4 if big else 2
                if last:
                    si, off, ln = last; s = segs[si - 1]
                    L = LOC_LEN.get(loc, 4)
                    for i in range(L):
                        if off + drec + i < len(s['mask']): s['mask'][off + drec + i] = 1
                    s['fixups'].append((off + drec, loc, bool(m), tm, tidx))
    return dict(name=name, segs=segs, pubs=pubs, exts=exts), end

def parse_lib(path):
    data = open(path, 'rb').read()
    mods = []
    if data[0] == 0xF0:
        psize = struct.unpack_from('<H', data, 1)[0] + 3
        p = psize
        while p < len(data) and data[p] == 0x80:
            m, end = parse_module(data, p); mods.append(m)
            p = -(-end // psize) * psize
    else:
        p = 0
        while p < len(data) and data[p] == 0x80:
            m, end = parse_module(data, p); mods.append(m); p = end
    return mods

if __name__ == '__main__':
    for m in parse_lib(sys.argv[1])[:int(sys.argv[2]) if len(sys.argv) > 2 else 10]:
        print(m['name'], [(s['name'], len(s['data']), sum(s['mask'])) for s in m['segs']], [p[0] for p in m['pubs']][:6])
