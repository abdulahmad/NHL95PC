#!/usr/bin/env python3
"""lx_load.py - load a Watcom LX executable (the 10.x DOS-hosted tools, e.g. wcc386) into flat object images.

  python3 tools/wccre/lx_load.py WCC386.EXE [--dump OUTDIR]

The 10.x tools are OS/2-style LX programs that W32RUN runs under DOS/4GW (it supplies the DOSCALLS
imports). This parses the LX header, object table, object page table, import module table and fixup tables,
and returns each object as (base, bytes) with the internal fixups applied (32-bit offsets get target object
base + offset), so a disassembler or Ghidra sees real addresses. Import fixups are returned as
(obj, offset, source type, -module, ordinal) for an emulator to resolve. --dump writes obj<N>_<base>.bin
and objects.json."""
import argparse, json, os, struct
from collections import Counter


def parse(path):
    d = open(path, 'rb').read()
    lx = struct.unpack_from('<I', d, 0x3C)[0]
    if d[lx:lx + 2] not in (b'LX', b'LE'):
        raise SystemExit('%s: no LX/LE header at %#x' % (path, lx))
    h = lambda off, f='I': struct.unpack_from('<' + f, d, lx + off)[0]
    hdr = dict(kind=d[lx:lx + 2].decode(), lx=lx, num_pages=h(0x14), eip_obj=h(0x18), eip=h(0x1C),
               esp_obj=h(0x20), esp=h(0x24), page_size=h(0x28), shift=h(0x2C), obj_tab=h(0x40),
               num_objs=h(0x44), page_map=h(0x48), fix_page_tab=h(0x68), fix_rec_tab=h(0x6C),
               data_pages=h(0x80), auto_ds=h(0x94), heap=h(0xA8), stack=h(0xAC))
    hdr['imports'] = imports(d, lx, h)
    objs = []
    for i in range(hdr['num_objs']):
        vs, base, flags, pti, npe, _ = struct.unpack_from('<IIIIII', d, lx + hdr['obj_tab'] + 24 * i)
        objs.append(dict(vsize=vs, base=base, flags=flags, page_index=pti, num_pages=npe))
    pages = []
    for p in range(hdr['num_pages']):
        off, size, fl = struct.unpack_from('<IHH', d, lx + hdr['page_map'] + 8 * p)
        pages.append((hdr['data_pages'] + (off << hdr['shift']), size, fl))
    images = []
    for o in objs:
        buf = bytearray(o['vsize'])
        for k in range(o['num_pages']):
            foff, size, fl = pages[o['page_index'] - 1 + k]
            at = k * hdr['page_size']
            if fl == 0:
                chunk = d[foff:foff + size][:max(0, len(buf) - at)]
                buf[at:at + len(chunk)] = chunk
            elif fl not in (2, 3):
                raise SystemExit('page %d flags %d not supported' % (o['page_index'] - 1 + k, fl))
        images.append(buf)
    fpt = [struct.unpack_from('<I', d, lx + hdr['fix_page_tab'] + 4 * p)[0] for p in range(hdr['num_pages'] + 1)]
    frt = lx + hdr['fix_rec_tab']
    fixups = []
    for oi, o in enumerate(objs):
        for k in range(o['num_pages']):
            p = o['page_index'] - 1 + k
            i, end = frt + fpt[p], frt + fpt[p + 1]
            while i < end:
                src, flg = d[i], d[i + 1]; i += 2
                if src & 0x20:
                    cnt = d[i]; i += 1
                else:
                    so = struct.unpack_from('<h', d, i)[0]; i += 2
                tt = flg & 3
                if flg & 0x40:
                    tobj = struct.unpack_from('<H', d, i)[0]; i += 2
                else:
                    tobj = d[i]; i += 1
                stype = src & 0x0F
                toff = 0
                if tt == 0:
                    if stype != 2:  # 2 = 16-bit selector: no offset
                        if flg & 0x10:
                            toff = struct.unpack_from('<I', d, i)[0]; i += 4
                        else:
                            toff = struct.unpack_from('<H', d, i)[0]; i += 2
                elif tt == 1:  # import by ordinal: tobj = module index, toff = ordinal
                    if flg & 0x80:
                        toff = d[i]; i += 1
                    elif flg & 0x10:
                        toff = struct.unpack_from('<I', d, i)[0]; i += 4
                    else:
                        toff = struct.unpack_from('<H', d, i)[0]; i += 2
                    tobj = -tobj
                else:
                    raise SystemExit('fixup target type %d not supported' % tt)
                if flg & 4:
                    raise SystemExit('additive fixups not supported')
                if src & 0x20:
                    srcoffs = list(struct.unpack_from('<%dh' % cnt, d, i)); i += 2 * cnt
                else:
                    srcoffs = [so]
                for so in srcoffs:
                    fixups.append((oi, k * hdr['page_size'] + so, stype, tobj, toff))
    for oi, at, stype, tobj, toff in fixups:
        if tobj < 0:
            continue
        buf = images[oi]
        if stype == 7 and 0 <= at <= len(buf) - 4:  # 32-bit offset
            buf[at:at + 4] = (objs[tobj - 1]['base'] + toff).to_bytes(4, 'little')
        elif stype == 8 and 0 <= at <= len(buf) - 4:  # 32-bit self-relative
            v = objs[tobj - 1]['base'] + toff - (objs[oi]['base'] + at + 4)
            buf[at:at + 4] = (v & 0xFFFFFFFF).to_bytes(4, 'little')
    return hdr, objs, [bytes(b) for b in images], fixups


def imports(d, lx, h):
    """import module names in order (a fixup's module index k is names[k - 1])"""
    names, i = [], lx + h(0x70)
    for _ in range(h(0x74)):
        n = d[i]; names.append(d[i + 1:i + 1 + n].decode('latin-1')); i += 1 + n
    return names


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('exe'); ap.add_argument('--dump')
    a = ap.parse_args()
    hdr, objs, images, fixups = parse(a.exe)
    print(json.dumps(hdr))
    for i, o in enumerate(objs):
        print('obj %d base %#x vsize %#x flags %#x pages %d' % (i + 1, o['base'], o['vsize'], o['flags'], o['num_pages']))
    print('fixups', len(fixups), dict(Counter(f[2] for f in fixups)))
    imp = Counter((hdr['imports'][-f[3] - 1], f[4], f[2]) for f in fixups if f[3] < 0)
    for (m, o, t), n in sorted(imp.items()):
        print('import %s.%d type %d x%d' % (m, o, t, n))
    if a.dump:
        os.makedirs(a.dump, exist_ok=True)
        for i, (o, b) in enumerate(zip(objs, images)):
            open(os.path.join(a.dump, 'obj%d_%x.bin' % (i + 1, o['base'])), 'wb').write(b)
        imps = [dict(obj=f[0] + 1, off=f[1], type=f[2], module=hdr['imports'][-f[3] - 1], ordinal=f[4])
                for f in fixups if f[3] < 0]
        json.dump(dict(hdr=hdr, objs=objs, imports=imps), open(os.path.join(a.dump, 'objects.json'), 'w'), indent=1)


if __name__ == '__main__':
    main()
