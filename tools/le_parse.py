#!/usr/bin/env python3
"""LE (Linear Executable) parser for DOS/4G bound executables (HOCKEY.EXE, NHL 95 PC).
Usage: le_parse.py HOCKEY.EXE [out.json]
Locates the bound MZ+LE (the DOS/4G kernel stub comes first), parses header,
object table, object page map, fixup page/record tables and entry table, and
computes file-offset <-> linear-address mapping for every page.
LE data-page offsets are relative to the start of the *bound* MZ (the one whose
e_lfanew points at 'LE'), not to the start of the file; this is auto-detected."""
import struct, sys, json

HDR_FIELDS = [
 (0x08,'H','cpu'),(0x0A,'H','os'),(0x0C,'I','module_version'),(0x10,'I','module_flags'),
 (0x14,'I','num_pages'),(0x18,'I','eip_object'),(0x1C,'I','eip'),(0x20,'I','esp_object'),
 (0x24,'I','esp'),(0x28,'I','page_size'),(0x2C,'I','last_page_size'),(0x30,'I','fixup_section_size'),
 (0x38,'I','loader_section_size'),(0x40,'I','object_table_off'),(0x44,'I','num_objects'),
 (0x48,'I','object_page_map_off'),(0x4C,'I','iter_pages_off'),(0x50,'I','resource_table_off'),
 (0x54,'I','num_resources'),(0x58,'I','resident_names_off'),(0x5C,'I','entry_table_off'),
 (0x68,'I','fixup_page_table_off'),(0x6C,'I','fixup_record_table_off'),(0x70,'I','import_module_table_off'),
 (0x74,'I','num_import_modules'),(0x78,'I','import_proc_table_off'),(0x80,'I','data_pages_off'),
 (0x84,'I','num_preload_pages'),(0x88,'I','nonresident_names_off'),(0x8C,'I','nonresident_names_len'),
 (0x94,'I','auto_ds_object'),(0x98,'I','debug_info_off'),(0x9C,'I','debug_info_len'),(0xA8,'I','heap_size')]

def find_le(d):
    # walk MZ headers: candidate MZ whose e_lfanew points at 'LE'
    i = -1
    while True:
        i = d.find(b'MZ', i+1)
        if i < 0: raise SystemExit('no LE found')
        if i+0x40 > len(d): continue
        lf = struct.unpack_from('<I', d, i+0x3C)[0]
        if i+lf+2 <= len(d) and d[i+lf:i+lf+2] == b'LE':
            return i, i+lf

def parse(path):
    d = open(path,'rb').read()
    mz, le = find_le(d)
    h = {k: struct.unpack_from('<'+t, d, le+o)[0] for o,t,k in HDR_FIELDS}
    # stub MZ (DOS/4G kernel) size
    lp, np_ = struct.unpack_from('<HH', d, 2)
    stub_size = (np_-1)*512 + (lp or 512)
    objs = []
    for n in range(h['num_objects']):
        vs, base, flags, pmi, pmn, _ = struct.unpack_from('<6I', d, le+h['object_table_off']+24*n)
        objs.append(dict(num=n+1, virtual_size=vs, base=base, flags=flags, page_map_index=pmi, page_count=pmn))
    pages = []
    for p in range(h['num_pages']):
        e = d[le+h['object_page_map_off']+4*p: le+h['object_page_map_off']+4*p+4]
        # LE: 3-byte big-endian page number (1-based) + 1 byte type
        pnum = (e[0]<<16)|(e[1]<<8)|e[2]; ptype = e[3]
        size = h['page_size'] if p+1 < h['num_pages'] else h['last_page_size']
        foff = mz + h['data_pages_off'] + (pnum-1)*h['page_size']
        pages.append(dict(index=p+1, page_num=pnum, type=ptype, file_off=foff, size=size))
    for o in objs:
        o['pages'] = []
        for k in range(o['page_count']):
            pg = pages[o['page_map_index']-1+k]
            lin = o['base'] + k*h['page_size']
            o['pages'].append(dict(linear=lin, file_off=pg['file_off'], size=pg['size'], le_page=pg['index'], type=pg['type']))
        o['file_bytes'] = sum(p['size'] for p in o['pages'])
        o['file_start'] = o['pages'][0]['file_off'] if o['pages'] else None
        o['file_end'] = o['pages'][-1]['file_off']+o['pages'][-1]['size'] if o['pages'] else None
        o['contiguous'] = all(o['pages'][i+1]['file_off']==o['pages'][i]['file_off']+o['pages'][i]['size'] for i in range(len(o['pages'])-1))
        o['bss_bytes'] = max(0, o['virtual_size']-o['file_bytes'])
        o['flags_decoded'] = [n for b,n in [(1,'READ'),(2,'WRITE'),(4,'EXEC'),(8,'RESOURCE'),(0x10,'DISCARD'),(0x20,'SHARED'),(0x40,'PRELOAD'),(0x80,'INVALID'),(0x2000,'BIG/USE32')] if o['flags']&b]
    # fixups
    fpt = le + h['fixup_page_table_off']; frt = le + h['fixup_record_table_off']
    offs = struct.unpack_from('<%dI' % (h['num_pages']+1), d, fpt)
    fixups = []
    def page_obj(p):  # 0-based LE page -> (obj, page index within obj)
        for o in objs:
            if o['page_map_index']-1 <= p < o['page_map_index']-1+o['page_count']:
                return o, p-(o['page_map_index']-1)
    for p in range(h['num_pages']):
        pos = frt + offs[p]; end = frt + offs[p+1]
        o, k = page_obj(p)
        page_lin = o['base'] + k*h['page_size']
        while pos < end:
            src, flg = d[pos], d[pos+1]; pos += 2
            if src & 0x20:
                cnt = d[pos]; pos += 1; srcoffs = None
            else:
                cnt = 1; srcoffs = [struct.unpack_from('<h', d, pos)[0]]; pos += 2
            tt = flg & 3
            if tt != 0: raise SystemExit('unsupported fixup target type %d at page %d' % (tt, p))
            if flg & 0x40: tobj = struct.unpack_from('<H', d, pos)[0]; pos += 2
            else: tobj = d[pos]; pos += 1
            stype = src & 0xF
            if stype == 2:  # 16-bit selector: no offset
                toff = 0
            elif flg & 0x10: toff = struct.unpack_from('<I', d, pos)[0]; pos += 4
            else: toff = struct.unpack_from('<H', d, pos)[0]; pos += 2
            if srcoffs is None:
                srcoffs = list(struct.unpack_from('<%dh' % cnt, d, pos)); pos += 2*cnt
            tbase = objs[tobj-1]['base']
            for so in srcoffs:
                fixups.append(dict(src_lin=page_lin+so, src_obj=o['num'], type=stype, tgt_obj=tobj, tgt_lin=tbase+toff))
    # entry table (bundles)
    entries = []; pos = le + h['entry_table_off']; ordn = 1
    while d[pos] != 0:
        cnt, btype = d[pos], d[pos+1]; pos += 2
        if btype == 0: ordn += cnt; continue
        obj = struct.unpack_from('<H', d, pos)[0]; pos += 2
        for _ in range(cnt):
            if btype == 3:
                fl, off = struct.unpack_from('<BI', d, pos); pos += 5
                entries.append(dict(ordinal=ordn, obj=obj, off=off)); 
            elif btype == 1: fl, off = struct.unpack_from('<BH', d, pos); pos += 3; entries.append(dict(ordinal=ordn, obj=obj, off=off))
            else: raise SystemExit('entry bundle type %d' % btype)
            ordn += 1
    # resident names
    names = []; pos = le + h['resident_names_off']
    while d[pos]:
        l = d[pos]; names.append((d[pos+1:pos+1+l].decode('latin1'), struct.unpack_from('<H', d, pos+1+l)[0])); pos += 3+l
    from collections import Counter
    return dict(file=path, file_size=len(d), stub_mz_off=0, stub_size_from_mz_header=stub_size, bound_mz_off=mz, le_off=le,
                header=h, objects=objs, entries=entries, resident_names=names,
                fixup_count=len(fixups), fixup_type_counts=dict(Counter(f['type'] for f in fixups)),
                entry_linear=objs[h['eip_object']-1]['base']+h['eip'], stack_linear=objs[h['esp_object']-1]['base']+h['esp']), fixups, d

def lin2off(info, lin):
    for o in info['objects']:
        for p in o['pages']:
            if p['linear'] <= lin < p['linear']+p['size']:
                return p['file_off'] + lin - p['linear']
    return None  # BSS / not in file

def off2lin(info, off):
    for o in info['objects']:
        for p in o['pages']:
            if p['file_off'] <= off < p['file_off']+p['size']:
                return p['linear'] + off - p['file_off']
    return None

if __name__ == '__main__':
    info, fixups, d = parse(sys.argv[1])
    out = sys.argv[2] if len(sys.argv) > 2 else None
    h = info['header']
    print('bound MZ @%#x  LE @%#x  pages=%d pagesize=%#x lastpage=%#x  data_pages_off=%#x (abs %#x)' % (
        info['bound_mz_off'], info['le_off'], h['num_pages'], h['page_size'], h['last_page_size'], h['data_pages_off'], info['bound_mz_off']+h['data_pages_off']))
    print('entry %d:%08X (lin %#x)  stack %d:%08X (lin %#x)' % (h['eip_object'], h['eip'], info['entry_linear'], h['esp_object'], h['esp'], info['stack_linear']))
    for o in info['objects']:
        print('obj%d base=%#x vsize=%#x flags=%#x %s pages=%d (map idx %d) file %#x-%#x (%#x bytes, contiguous=%s) bss=%#x' % (
            o['num'], o['base'], o['virtual_size'], o['flags'], '|'.join(o['flags_decoded']), o['page_count'], o['page_map_index'],
            o['file_start'], o['file_end'], o['file_bytes'], o['contiguous'], o['bss_bytes']))
    print('fixups:', info['fixup_count'], info['fixup_type_counts'], ' entries:', info['entries'], ' resnames:', info['resident_names'])
    if out:
        json.dump(dict(info=info, fixups=fixups), open(out, 'w'), indent=1)
