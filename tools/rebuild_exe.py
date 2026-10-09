#!/usr/bin/env python3
"""rebuild_exe.py - split HOCKEY.EXE (NHL 95 PC) into structured parts and rebuild it byte-for-byte.

  rebuild_exe.py split  [HOCKEY.EXE] [build/parts]     explode EXE into parts (+ segment slices from segmap95pc.json)
  rebuild_exe.py build  [build/parts] [build/HOCKEY.EXE] reassemble from parts only (never reads the original)
  rebuild_exe.py extract [HOCKEY.EXE] [build/parts]    check the EXE's sha1, then split (same as split)
  rebuild_exe.py verify                                 extract + build + sha1/byte compare + fixup experiments

HOCKEY.EXE is not in the repo. Copy your own retail NHL 95 PC HOCKEY.EXE to the repo root
(1,179,067 bytes, sha1 3961e0eba6b0338fad1613bb534efafd9406ed4a).

What is regenerated vs. kept opaque (see BUILD_NOTES.md):
  * DOS/16M loader stub      : MZ header + relocation table -> JSON (re-serialised); load-module body = opaque blob
  * 'BW' DOS/4GW Pro kernel  : opaque blob (Rational Systems 3rd-party binary)
  * Watcom wstub             : MZ header + relocs -> JSON, e_lfanew recomputed from layout; body = opaque blob
  * LE header                : every field from JSON; all table offsets / sizes / page counts / last-page size /
                               data_pages_off are RECOMPUTED from the tables and asserted against the recorded values
  * object table, page map, resident names, entry table, import tables: regenerated from JSON
  * fixup page table + fixup record table: regenerated from fixups.tsv = list of
        (chunk, src_linear, target_object, target_offset)  in linker insertion order,
    using the wlink algorithm (per-page lists in 512-byte blocks, newest block first; a 32-bit fixup that
    straddles a page end is also emitted in the next page with a negative source offset).
  * object pages             : concatenation of segment slices (cseg01/*.bin, dseg02/*.bin) listed in segmap95pc.json
                               + obj1 page-padding (zeros) + zero fill to page-aligned data_pages_off.
"""
import sys, os, json, struct, hashlib, functools
from collections import OrderedDict

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
PAGE = 0x1000
RELOC_BLOCK = 512   # wlink RELOC_PAGE_SIZE
EXPECTED_SIZE = 1179067
EXPECTED_SHA1 = '3961e0eba6b0338fad1613bb534efafd9406ed4a'

def check_exe(exe):
    if not os.path.isfile(exe):
        sys.exit('%s not found. Copy your own NHL 95 PC HOCKEY.EXE to the repo root (it is not in the repo).' % exe)
    d = open(exe, 'rb').read(); h = hashlib.sha1(d).hexdigest()
    if len(d) != EXPECTED_SIZE or h != EXPECTED_SHA1:
        sys.exit('%s: %d bytes, sha1 %s. Expected %d bytes, sha1 %s.' % (exe, len(d), h, EXPECTED_SIZE, EXPECTED_SHA1))
    print('HOCKEY.EXE ok: %d bytes, sha1 %s' % (len(d), h))

# ----------------------------------------------------------------------------------------------- MZ
MZ_FIELDS = ['e_magic', 'e_cblp', 'e_cp', 'e_crlc', 'e_cparhdr', 'e_minalloc', 'e_maxalloc', 'e_ss', 'e_sp',
             'e_csum', 'e_ip', 'e_cs', 'e_lfarlc', 'e_ovno']

def mz_split(blob, has_lfanew=False):
    f = OrderedDict(zip(MZ_FIELDS, struct.unpack_from('<14H', blob, 0)))
    hdr_len = f['e_cparhdr'] * 16
    rel_off, nrel = f['e_lfarlc'], f['e_crlc']
    h = OrderedDict(fields=f)
    ext_end = rel_off
    if has_lfanew:
        h['e_lfanew'] = struct.unpack_from('<I', blob, 0x3C)[0]
        h['ext_1c_3c'] = blob[0x1C:0x3C].hex()
        ext_start = 0x40
    else:
        ext_start = 0x1C
    h['ext'] = blob[ext_start:rel_off].hex()
    h['relocs'] = ['%04X:%04X' % (s, o) for o, s in (struct.unpack_from('<HH', blob, rel_off + 4 * i) for i in range(nrel))]
    h['hdr_tail'] = blob[rel_off + 4 * nrel:hdr_len].hex()
    return h, blob[hdr_len:]

def mz_join(h, body, total_size=None, lfanew=None):
    f = dict(h['fields'])
    b = bytearray(struct.pack('<14H', *[f[k] for k in MZ_FIELDS]))
    if 'e_lfanew' in h:
        b += bytes.fromhex(h['ext_1c_3c'])
        b += struct.pack('<I', lfanew if lfanew is not None else h['e_lfanew'])
    b += bytes.fromhex(h['ext'])
    assert len(b) == f['e_lfarlc'] and len(h['relocs']) == f['e_crlc']
    for r in h['relocs']:
        s, o = (int(x, 16) for x in r.split(':'))
        b += struct.pack('<HH', o, s)
    b += bytes.fromhex(h['hdr_tail'])
    assert len(b) == f['e_cparhdr'] * 16
    out = bytes(b) + body
    # MZ size fields must describe the image (consistency check, not regeneration)
    sz = (f['e_cp'] - 1) * 512 + (f['e_cblp'] or 512)
    return out, sz

# ----------------------------------------------------------------------------------------------- LE
# full LE header layout (0xAC bytes used by wlink; header area is 0xC4 = object_table_off)
LE_HDR = [
 (0x00,'2s','sig'),(0x02,'B','byte_order'),(0x03,'B','word_order'),(0x04,'I','format_level'),
 (0x08,'H','cpu'),(0x0A,'H','os'),(0x0C,'I','module_version'),(0x10,'I','module_flags'),
 (0x14,'I','num_pages'),(0x18,'I','eip_object'),(0x1C,'I','eip'),(0x20,'I','esp_object'),(0x24,'I','esp'),
 (0x28,'I','page_size'),(0x2C,'I','last_page_size'),(0x30,'I','fixup_section_size'),(0x34,'I','fixup_checksum'),
 (0x38,'I','loader_section_size'),(0x3C,'I','loader_checksum'),(0x40,'I','object_table_off'),(0x44,'I','num_objects'),
 (0x48,'I','object_page_map_off'),(0x4C,'I','iter_pages_off'),(0x50,'I','resource_table_off'),(0x54,'I','num_resources'),
 (0x58,'I','resident_names_off'),(0x5C,'I','entry_table_off'),(0x60,'I','module_directives_off'),(0x64,'I','num_module_directives'),
 (0x68,'I','fixup_page_table_off'),(0x6C,'I','fixup_record_table_off'),(0x70,'I','import_module_table_off'),
 (0x74,'I','num_import_modules'),(0x78,'I','import_proc_table_off'),(0x7C,'I','per_page_checksum_off'),
 (0x80,'I','data_pages_off'),(0x84,'I','num_preload_pages'),(0x88,'I','nonresident_names_off'),(0x8C,'I','nonresident_names_len'),
 (0x90,'I','nonresident_names_checksum'),(0x94,'I','auto_ds_object'),(0x98,'I','debug_info_off'),(0x9C,'I','debug_info_len'),
 (0xA0,'I','num_instance_preload'),(0xA4,'I','num_instance_demand'),(0xA8,'I','heap_size')]
LE_HDR_END = 0xAC
DERIVED = ['num_pages','last_page_size','fixup_section_size','loader_section_size','object_table_off','num_objects',
           'object_page_map_off','resource_table_off','resident_names_off','entry_table_off','fixup_page_table_off',
           'fixup_record_table_off','import_module_table_off','import_proc_table_off','data_pages_off']

def parse_fixup_records(d, frt, offs, npages):
    """-> per page list of (src_off, tgt_obj, tgt_off) in file order; asserts the simple encoding used by wlink here."""
    pages = []
    for p in range(npages):
        pos, end, recs = frt + offs[p], frt + offs[p + 1], []
        while pos < end:
            s, f = d[pos], d[pos + 1]
            assert s == 0x07 and f in (0x00, 0x10), (p, s, f)   # 32-bit offset, internal ref, 8-bit obj#
            so = struct.unpack_from('<h', d, pos + 2)[0]; t = d[pos + 4]
            if f & 0x10: to = struct.unpack_from('<I', d, pos + 5)[0]; pos += 9
            else:        to = struct.unpack_from('<H', d, pos + 5)[0]; pos += 7
            recs.append((so, t, to))
        pages.append(recs)
    return pages

def enc_fixup(so, t, to):
    if to > 0xFFFF: return struct.pack('<BBhBI', 0x07, 0x10, so, t, to)
    return struct.pack('<BBhBH', 0x07, 0x00, so, t, to)

def unblock(recs):
    """Invert wlink block packing for one page: file order = blocks newest-first, each block (<=512 bytes) in
    insertion order, every block except the newest full (next record would not fit). Returns insertion order."""
    sz = [len(enc_fixup(*r)) for r in recs]; n = len(recs)
    sys.setrecursionlimit(100000)
    @functools.lru_cache(None)
    def f(i, pf):
        if i == n: return ()
        s = 0
        for e in range(i + 1, n + 1):
            s += sz[e - 1]
            if s > RELOC_BLOCK: break
            if RELOC_BLOCK - s < pf:
                sub = f(e, sz[i])
                if sub is not None: return ((i, e),) + sub
        return None
    if not n: return []
    s = 0
    for e in range(1, n + 1):
        s += sz[e - 1]
        if s > RELOC_BLOCK: break
        sub = f(e, sz[0])
        if sub is not None:
            out = []
            for a, b in reversed(((0, e),) + sub): out += recs[a:b]
            return out
    raise SystemExit('cannot unblock fixup page')

def pack_page(ins):
    """wlink DoWriteReloc + DumpRelocList: insertion order -> file bytes for one page."""
    blocks = []
    for r in ins:
        b = enc_fixup(*r)
        if not blocks or RELOC_BLOCK - len(blocks[0]) < len(b):
            blocks.insert(0, bytearray())
        blocks[0] += b
    return b''.join(blocks)

def page_base(objs, p):
    for o in objs:
        if o['page_map_index'] - 1 <= p < o['page_map_index'] - 1 + o['page_count']:
            return o, o['base'] + (p - (o['page_map_index'] - 1)) * PAGE

def fixups_to_global(objs, pages_ins):
    """Per-page insertion orders -> one global linker-order list of (chunk, src_lin, tobj, toff).
    A 'chunk' is a run of descending source offsets (Watcom emits each object-record's fixups in descending order;
    chunks mostly ascend). Pages are independent lists, so the global order is page by page; the only coupling is a
    fixup straddling a page end, which wlink writes into both pages (the copy in page p+1 has a negative offset).
    Such a copy is dropped (it is regenerated) and its chunk is moved so it is emitted at the start of page p+1."""
    page_runs = []
    for p, ins in enumerate(pages_ins):
        o, base = page_base(objs, p)
        runs = []
        for so, t, to in ins:
            if runs and base + so < runs[-1][-1][0]: runs[-1].append((base + so, t, to))
            else: runs.append([(base + so, t, to)])
        page_runs.append((base, runs))
    for p in range(1, len(page_runs)):
        base, runs = page_runs[p]
        for ri, run in enumerate(runs):
            if run[-1][0] < base:                      # ends with a straddle duplicate
                dup = run.pop()
                assert all(x[0] >= base for x in run)
                prev_runs = page_runs[p - 1][1]
                assert prev_runs and prev_runs[-1][0] == dup, ('straddler not last chunk of previous page', p)
                run.extend(prev_runs.pop())            # chunk = page p+1 part + page p part (starts with straddler)
    out, ci = [], 0
    for base, runs in page_runs:
        for run in runs:
            if not run: continue
            for s, t, to in run: out.append((ci, s, t, to))
            ci += 1
    return out

def global_to_pages(objs, npages, fixups):
    """(chunk, src_lin, tobj, toff) in linker order -> per page insertion order (with straddle duplicates)."""
    pages = [[] for _ in range(npages)]
    lin2page = {}
    for o in objs:
        for k in range(o['page_count']): lin2page[o['base'] // PAGE + k] = (o['page_map_index'] - 1 + k, o['base'] + k * PAGE)
    for _, s, t, to in fixups:
        p, base = lin2page[s // PAGE]
        pages[p].append((s - base, t, to))
        if (s - base) + 4 > PAGE and p + 1 < npages:      # straddles page end -> also in next page
            pages[p + 1].append((s - base - PAGE, t, to))
    return pages

# ----------------------------------------------------------------------------------------------- split
def split(exe, parts):
    d = open(exe, 'rb').read()
    segmap = json.load(open(os.path.join(ROOT, 'segmap95pc.json')))
    os.makedirs(parts, exist_ok=True)
    W = lambda name, data: open(os.path.join(parts, name), 'wb').write(data)
    man = OrderedDict(source=dict(size=len(d), sha1=hashlib.sha1(d).hexdigest()))

    # --- stub 1: DOS/16M loader (MZ at 0)
    f0 = struct.unpack_from('<14H', d, 0)
    stub_end = (f0[2] - 1) * 512 + (f0[1] or 512)
    h, body = mz_split(d[:stub_end])
    os.makedirs(os.path.join(parts, 'stub'), exist_ok=True)
    json.dump(h, open(os.path.join(parts, 'stub/dos16m_mz.json'), 'w'), indent=1)
    W('stub/dos16m_body.bin', body)
    # --- BW kernel: from stub_end to bound MZ (wstub) whose e_lfanew -> LE
    bound = segmap['bound_mz_off']; le = segmap['le_off']
    assert d[stub_end:stub_end + 2] == b'BW' and d[bound:bound + 2] == b'MZ' and d[le:le + 2] == b'LE'
    W('stub/dos4gw_bw.bin', d[stub_end:bound])
    # --- wstub
    h2, body2 = mz_split(d[bound:le], has_lfanew=True)
    assert h2['e_lfanew'] == le - bound
    json.dump(h2, open(os.path.join(parts, 'stub/wstub_mz.json'), 'w'), indent=1)
    W('stub/wstub_body.bin', body2)

    # --- LE header
    hdr = OrderedDict()
    for o, t, k in LE_HDR:
        v = struct.unpack_from('<' + t, d, le + o)[0]
        hdr[k] = v.decode() if isinstance(v, bytes) else v
    assert not any(d[le + LE_HDR_END: le + hdr['object_table_off']]), 'non-zero LE header tail'
    hdr_tail_len = hdr['object_table_off'] - LE_HDR_END
    objs = []
    for n in range(hdr['num_objects']):
        vs, base, flags, pmi, pmn, res = struct.unpack_from('<6I', d, le + hdr['object_table_off'] + 24 * n)
        objs.append(OrderedDict(name='cseg01' if n == 0 else 'dseg02', virtual_size=vs, base=base, flags=flags,
                                page_map_index=pmi, page_count=pmn, reserved=res))
    pmap = []
    for p in range(hdr['num_pages']):
        e = d[le + hdr['object_page_map_off'] + 4 * p: le + hdr['object_page_map_off'] + 4 * p + 4]
        pmap.append(((e[0] << 16) | (e[1] << 8) | e[2], e[3]))
    assert all(pn == i + 1 and ty == 0 for i, (pn, ty) in enumerate(pmap)), 'page map not sequential'
    # resident names
    names, pos = [], le + hdr['resident_names_off']
    while d[pos]:
        l = d[pos]; names.append([d[pos + 1:pos + 1 + l].decode('latin1'), struct.unpack_from('<H', d, pos + 1 + l)[0]]); pos += 3 + l
    assert pos + 1 == le + hdr['entry_table_off']
    entry_raw = []
    pos = le + hdr['entry_table_off']
    assert d[pos] == 0, 'entry table not empty (unsupported)'
    assert pos + 1 == le + hdr['fixup_page_table_off']
    # fixups
    np_ = hdr['num_pages']
    offs = struct.unpack_from('<%dI' % (np_ + 1), d, le + hdr['fixup_page_table_off'])
    frt = le + hdr['fixup_record_table_off']
    assert hdr['fixup_page_table_off'] + 4 * (np_ + 1) == hdr['fixup_record_table_off']
    file_pages = parse_fixup_records(d, frt, offs, np_)
    pages_ins = [unblock(r) for r in file_pages]
    assert all(pack_page(i) == d[frt + offs[p]:frt + offs[p + 1]] for p, i in enumerate(pages_ins))
    glob = fixups_to_global(objs, pages_ins)
    with open(os.path.join(parts, 'le_fixups.tsv'), 'w') as fo:
        fo.write('# chunk\tsrc_linear\ttarget_obj\ttarget_offset   (linker insertion order; target linear = obj base + offset)\n')
        for c, s, t, to in glob: fo.write('%d\t%05X\t%d\t%X\n' % (c, s, t, to))
    imp_mod_off = hdr['import_module_table_off']
    assert imp_mod_off == frt - le + offs[-1] and hdr['num_import_modules'] == 0 and hdr['import_proc_table_off'] == imp_mod_off
    # import proc table: wlink writes a single 0 byte; then zero pad to data pages
    import_proc = d[le + imp_mod_off: le + hdr['fixup_page_table_off'] + hdr['fixup_section_size']]
    data_abs = bound + hdr['data_pages_off']
    assert not any(d[le + hdr['fixup_page_table_off'] + hdr['fixup_section_size']: data_abs])
    le_json = OrderedDict(header=hdr, header_tail_zero_bytes=hdr_tail_len, objects=objs, resident_names=names,
                          entry_table=entry_raw, import_proc_table=import_proc.hex(), data_pages_align=512,
                          note='DERIVED header fields are recomputed by build and asserted equal to the values here',
                          derived_fields=DERIVED)
    json.dump(le_json, open(os.path.join(parts, 'le.json'), 'w'), indent=1)

    # --- object pages from segment slices
    seglist = []
    for oi, (oname, o) in enumerate(zip(('cseg01', 'dseg02'), objs)):
        os.makedirs(os.path.join(parts, oname), exist_ok=True)
        obj_file_start = data_abs + (o['page_map_index'] - 1) * PAGE
        cur = o['base']
        for i, s in enumerate(segmap[oname]):
            assert s['start'] == cur
            end = min(s['end'], o['base'] + o['page_count'] * PAGE)   # BSS is not in the file
            fn = '%s/%03d_%05X_%s.bin' % (oname, i, s['start'], s['module'])
            data = d[obj_file_start + s['start'] - o['base']: obj_file_start + min(end, o['base'] + 10**9) - o['base']]
            # clip to bytes physically in file for this object
            phys_end = (o['base'] + (o['page_count'] - 1) * PAGE + (hdr['last_page_size'] if o is objs[-1] else PAGE))
            data = data[:max(0, min(end, phys_end) - s['start'])]
            W(fn, data)
            seglist.append(dict(obj=oi + 1, start='%05X' % s['start'], end='%05X' % s['end'], file=fn, bytes=len(data)))
            cur = s['end']
        assert cur == o['base'] + o['virtual_size']
        # page padding after vsize (only if the object's file pages extend past vsize)
        phys_end = o['base'] + (o['page_count'] - 1) * PAGE + (hdr['last_page_size'] if o is objs[-1] else PAGE)
        if phys_end > cur:
            pad = d[obj_file_start + cur - o['base']: obj_file_start + phys_end - o['base']]
            assert not any(pad)
            seglist.append(dict(obj=oi + 1, start='%05X' % cur, end='%05X' % phys_end, file=None, bytes=len(pad), zero_pad=True))
    man['segments'] = seglist
    json.dump(man, open(os.path.join(parts, 'manifest.json'), 'w'), indent=1)
    return d

# ----------------------------------------------------------------------------------------------- build
def build(parts, out=None, fixups_tsv=None):
    R = lambda name: open(os.path.join(parts, name), 'rb').read()
    man = json.load(open(os.path.join(parts, 'manifest.json')))
    L = json.load(open(os.path.join(parts, 'le.json')))
    hdr = dict(L['header']); objs = L['objects']

    # stubs
    h1 = json.load(open(os.path.join(parts, 'stub/dos16m_mz.json')))
    stub1, sz1 = mz_join(h1, R('stub/dos16m_body.bin'))
    assert sz1 == len(stub1)
    bw = R('stub/dos4gw_bw.bin')
    h2 = json.load(open(os.path.join(parts, 'stub/wstub_mz.json')))
    body2 = R('stub/wstub_body.bin')
    hdr2_len = h2['fields']['e_cparhdr'] * 16
    lfanew = hdr2_len + len(body2)                     # LE immediately follows the wstub
    wstub, _ = mz_join(h2, body2, lfanew=lfanew)

    # object page bytes
    objdata = {1: bytearray(), 2: bytearray()}
    for s in man['segments']:
        objdata[s['obj']] += (bytes(s['bytes']) if s.get('zero_pad') else R(s['file']))
    # page counts / last page from object data
    calc = {}
    page_idx = 1
    for i, o in enumerate(objs):
        n = len(objdata[i + 1])
        pc = -(-n // PAGE)
        assert pc == o['page_count'] and page_idx == o['page_map_index'], (pc, o)
        if i < len(objs) - 1: assert n == pc * PAGE      # all but last object fill whole pages
        page_idx += pc
    calc['num_pages'] = page_idx - 1
    calc['last_page_size'] = len(objdata[len(objs)]) - (objs[-1]['page_count'] - 1) * PAGE

    # LE tables
    otab = b''.join(struct.pack('<6I', o['virtual_size'], o['base'], o['flags'], o['page_map_index'], o['page_count'], o['reserved']) for o in objs)
    pmap = b''.join(bytes([(p >> 16) & 255, (p >> 8) & 255, p & 255, 0]) for p in range(1, calc['num_pages'] + 1))
    resn = b''.join(bytes([len(n)]) + n.encode('latin1') + struct.pack('<H', o) for n, o in L['resident_names']) + b'\0'
    entry = b'\0'
    # fixups
    fx = []
    for line in open(fixups_tsv or os.path.join(parts, 'le_fixups.tsv')):
        if line.startswith('#') or not line.strip(): continue
        c, s, t, to = line.split()[:4]
        fx.append((int(c), int(s, 16), int(t), int(to, 16)))
    pages = global_to_pages(objs, calc['num_pages'], fx)
    recs, fpt, pos = bytearray(), [], 0
    for ins in pages:
        fpt.append(len(recs)); recs += pack_page(ins)
    fpt.append(len(recs))
    fpt = struct.pack('<%dI' % len(fpt), *fpt)
    impproc = bytes.fromhex(L['import_proc_table'])

    calc['object_table_off'] = LE_HDR_END + L['header_tail_zero_bytes']
    calc['num_objects'] = len(objs)
    calc['object_page_map_off'] = calc['object_table_off'] + len(otab)
    calc['resource_table_off'] = calc['object_page_map_off'] + len(pmap)
    calc['resident_names_off'] = calc['resource_table_off']           # no resources
    calc['entry_table_off'] = calc['resident_names_off'] + len(resn)
    calc['fixup_page_table_off'] = calc['entry_table_off'] + len(entry)
    calc['fixup_record_table_off'] = calc['fixup_page_table_off'] + len(fpt)
    calc['import_module_table_off'] = calc['fixup_record_table_off'] + len(recs)
    calc['import_proc_table_off'] = calc['import_module_table_off']   # no import modules
    end_tables = calc['import_proc_table_off'] + len(impproc)
    calc['fixup_section_size'] = end_tables - calc['fixup_page_table_off']
    calc['loader_section_size'] = end_tables - calc['object_table_off']
    bound_rel_end = len(wstub) + end_tables
    al = L['data_pages_align']
    calc['data_pages_off'] = -(-bound_rel_end // al) * al
    mism = {k: (hdr[k], calc[k]) for k in DERIVED if hdr[k] != calc[k]}
    if mism and fixups_tsv is None: raise SystemExit('derived LE header mismatch: %r' % mism)
    hdr.update(calc)
    hb = bytearray(LE_HDR_END)
    for o, t, k in LE_HDR:
        v = hdr[k].encode() if t == '2s' else hdr[k]
        struct.pack_into('<' + t, hb, o, v)
    le = bytes(hb) + bytes(L['header_tail_zero_bytes']) + otab + pmap + resn + entry + fpt + bytes(recs) + impproc
    le += bytes(calc['data_pages_off'] - len(wstub) - len(le))
    exe = stub1 + bw + wstub + le + bytes(objdata[1]) + bytes(objdata[2])
    if out:
        os.makedirs(os.path.dirname(out) or '.', exist_ok=True)
        open(out, 'wb').write(exe)
    return exe, mism

# ----------------------------------------------------------------------------------------------- fixup re-ordering
def order_fixups(unordered, order_tsv):
    """unordered: iterable of (src_linear, target_obj, target_offset) e.g. harvested from an assembler's relocations.
    Returns (chunk, src, tobj, toff) list in wlink insertion order, using the recorded order in order_tsv (keyed by
    src_linear). Fixups not in the recorded order (new code) are appended in ascending order as their own chunks."""
    rank = {}
    for line in open(order_tsv):
        if line.startswith('#') or not line.strip(): continue
        c, sl = line.split()[:2]; rank[int(sl, 16)] = (len(rank), int(c))
    known, new = [], []
    for s, t, to in unordered:
        (known if s in rank else new).append((s, t, to))
    known.sort(key=lambda x: rank[x[0]][0])
    out = [(rank[s][1], s, t, to) for s, t, to in known]
    nc = max((c for c, *_ in out), default=-1) + 1
    for i, (s, t, to) in enumerate(sorted(new)): out.append((nc + i, s, t, to))
    return out, len(new)

def regen_test(parts):
    """Simulate an assembler-based build: take the fixup SET (shuffled, no order/chunk info), re-order with the
    recorded order table, rebuild, compare."""
    import random
    fx = []
    for line in open(os.path.join(parts, 'le_fixups.tsv')):
        if line.startswith('#'): continue
        c, s, t, to = line.split(); fx.append((int(s, 16), int(t), int(to, 16)))
    random.seed(1); random.shuffle(fx)
    ordered, nnew = order_fixups(fx, os.path.join(parts, 'le_fixups.tsv'))
    tmp = os.path.join(ROOT, 'build/fixups_reordered.tsv')
    with open(tmp, 'w') as fo:
        for c, s, t, to in ordered: fo.write('%d\t%05X\t%d\t%X\n' % (c, s, t, to))
    b, mism = build(parts, None, tmp)
    return b, nnew

# ----------------------------------------------------------------------------------------------- verify
def main():
    cmd = sys.argv[1] if len(sys.argv) > 1 else 'verify'
    exe = os.path.join(ROOT, 'HOCKEY.EXE'); parts = os.path.join(ROOT, 'build/parts'); out = os.path.join(ROOT, 'build/HOCKEY.EXE')
    if cmd in ('split', 'extract'):
        if cmd == 'extract': check_exe(sys.argv[2] if len(sys.argv) > 2 else exe)
        split(sys.argv[2] if len(sys.argv) > 2 else exe, sys.argv[3] if len(sys.argv) > 3 else parts)
        print('split ->', parts)
    elif cmd == 'build':
        b, _ = build(sys.argv[2] if len(sys.argv) > 2 else parts, sys.argv[3] if len(sys.argv) > 3 else out)
        print('built', len(b), 'bytes sha1', hashlib.sha1(b).hexdigest())
    elif cmd == 'verify':
        check_exe(exe)
        orig = split(exe, parts)
        b, _ = build(parts, out)
        h0, h1 = hashlib.sha1(orig).hexdigest(), hashlib.sha1(b).hexdigest()
        print('original sha1', h0, len(orig)); print('rebuilt  sha1', h1, len(b))
        print('MATCH' if b == orig else 'MISMATCH')
        # experiment: fixups given only as a set, re-ordered by source address (no chunk info)
        fx = [l for l in open(os.path.join(parts, 'le_fixups.tsv')) if not l.startswith('#')]
        srt = sorted(fx, key=lambda l: int(l.split()[1], 16))
        tmp = os.path.join(ROOT, 'build/fixups_sorted.tsv')
        open(tmp, 'w').write(''.join('0\t' + '\t'.join(l.split()[1:]) + '\n' for l in srt))
        b2, mism = build(parts, None, tmp)
        nd = sum(1 for x, y in zip(b2, orig) if x != y)
        print('sorted-fixup experiment: same size=%s, differing bytes=%d, derived-field changes=%r' % (len(b2) == len(orig), nd, mism))
        b3, nnew = regen_test(parts)
        print('shuffled fixup set + recorded order table -> %s (sha1 %s)' % ('MATCH' if b3 == orig else 'MISMATCH', hashlib.sha1(b3).hexdigest()))
        sys.exit(0 if b == orig and b3 == orig else 1)
    else:
        print(__doc__)

if __name__ == '__main__':
    main()
