#!/usr/bin/env python3
"""Turn the LE fixups into symbolic labels.

Inputs (all derived from your own HOCKEY.EXE; nothing here is committed):
  build/parts/            from `rebuild_exe.py extract` (segment slices, le_fixups.tsv, manifest.json)
  segmap95pc.json, name_map_94.csv, tools/global_map.csv (committed)
  tools/funcs.pkl, tools/lst_index.pkl (optional, from the IDA listing: extra function starts, data item extents,
                          and an instruction-boundary cross-check). The tool works without them.

Outputs (build/labels/, gitignored):
  symbols.tsv  one row per fixup target: lin, obj, offset, name, named/auto, class, subclass, flags, n_refs, parent
  sites.tsv    one row per fixup (26,790 unique sources): src, segment, site kind, insn addr, insn text, field, target, symbol
  tables.tsv   jump tables (code object) and pointer tables (data object)
  stats.json   counts (also printed)

Classes:  code_func  (function entry)        code_mid (inside a function: switch case / branch target / other)
          code_table (switch jump table data in the code object)     data (subclass ptr_table/string/scalar/bss)

Library use: `import fixup_labels as FL; A = FL.analyse()` gives the same tables plus the decoded instruction stream
(A.insns) used by tools/asm_proto.py.
"""
import os, sys, csv, json, re, bisect, pickle
from collections import Counter, defaultdict
import iced_x86 as I

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..')
PAGE = 0x1000

# ------------------------------------------------------------------------------------------------ loading
def load_parts(parts):
    man = json.load(open(os.path.join(parts, 'manifest.json')))
    L = json.load(open(os.path.join(parts, 'le.json')))
    objs = {}
    for n, o in enumerate(L['objects'], 1):
        objs[n] = dict(base=o['base'], vsize=o['virtual_size'], img=bytearray())
    for s in man['segments']:
        o = objs[s['obj']]
        assert o['base'] + len(o['img']) == int(s['start'], 16) or s['bytes'] == 0
        o['img'] += open(os.path.join(parts, s['file']), 'rb').read() if s['file'] else bytes(s['bytes'])
    fx = []
    for ln in open(os.path.join(parts, 'le_fixups.tsv')):
        if ln.startswith('#') or not ln.strip(): continue
        c, s, t, to = ln.split(); fx.append((int(c), int(s, 16), int(t), int(to, 16)))
    return objs, fx

def ident(n):
    """sanitise a name-map name into an assembler identifier"""
    n = n.strip()
    if '::' in n:   # demangled C++ name (FLIRT): drop cv/return-type words and the argument list, '::' -> '__'
        n = n.split('(')[0].split()[-1].replace('::', '__')
    else:
        n = n.split(' ')[0]
    n = re.sub(r'[^A-Za-z0-9_@$?]', '_', n)
    if n and n[0].isdigit(): n = '_' + n
    return n

RESERVED = None
def reserved():
    global RESERVED
    if RESERVED is None:
        RESERVED = {k.lower() for k in dir(I.Mnemonic) if not k.startswith('_')}
        RESERVED |= {k.lower() for k in dir(I.Register) if not k.startswith('_')}
        RESERVED |= {'byte', 'word', 'dword', 'qword', 'tword', 'ptr', 'offset', 'near', 'far', 'short', 'strict', 'seg',
                     'wrt', 'abs', 'rel', 'times', 'equ', 'const', 'flat', 'size', 'length', 'type', 'this', 'st', 'a', 'b'}
    return RESERVED

class Analysis: pass

# ------------------------------------------------------------------------------------------------ analysis
def analyse(parts=None, use_listing=True, verbose=False):
    A = Analysis()
    parts = parts or os.path.join(ROOT, 'build/parts')
    objs, fx = load_parts(parts)
    A.objs, A.fx = objs, fx
    SM = json.load(open(os.path.join(ROOT, 'segmap95pc.json')))
    segs = [(s['start'], s['end'], s['module'], s['obj']) for s in SM['cseg01'] + SM['dseg02']]
    A.segs = segs; sst = [s[0] for s in segs]
    def segof(a):
        j = bisect.bisect_right(sst, a) - 1; return segs[j] if j >= 0 and a < segs[j][1] else None
    A.segof = segof
    CB, CE = objs[1]['base'], objs[1]['base'] + objs[1]['vsize']
    DB, DE = objs[2]['base'], objs[2]['base'] + objs[2]['vsize']
    DINIT = DB + len(objs[2]['img'])
    A.CB, A.CE, A.DB, A.DE = CB, CE, DB, DE
    def byte(a, n=1):
        o = objs[1] if a < DB else objs[2]; off = a - o['base']
        return bytes(o['img'][off:off + n]) if off < len(o['img']) else bytes(n)
    A.byte = byte
    def objof(a): return 1 if CB <= a < CE else (2 if DB <= a < DE else 0)
    tgt = {s: objs[t]['base'] + to for _, s, t, to in fx}       # src -> target linear
    A.tgt = tgt
    srcs = sorted(tgt)

    # ---- names
    names = {}; aliases = defaultdict(list); fstarts = set(); nm_src = {}
    for r in csv.DictReader(open(os.path.join(ROOT, 'name_map_94.csv'))):
        a = int(r['pc_address'], 16)
        if CB <= a < CE and r['method'] != 'data': fstarts.add(a)
        n = r['proposed_name'] or ('' if re.match(r'(sub|nullsub|j_sub|loc)_[0-9A-F]+$', r['ida_name']) else r['ida_name'])
        if n: names[a] = ident(n); nm_src[a] = 'name_map'
    for r in csv.DictReader(open(os.path.join(ROOT, 'tools/global_map.csv'))):
        a = int(r['pc_address'], 16); n = ident(r['genesis_symbol'])
        if a in names: aliases[a].append(n)
        else: names[a] = n; nm_src[a] = 'global_map'
    # unique, assembler-safe names
    seen = Counter(); R = reserved()
    for a in sorted(names):
        n = names[a]
        if n.lower() in R: n = n + '_'
        seen[n] += 1
        if seen[n] > 1: n = '%s_%X' % (n, a)
        names[a] = n
    A.names, A.aliases = names, aliases

    # ---- optional listing-derived caches
    funcs_pkl = os.path.join(ROOT, 'tools/funcs.pkl'); lst_pkl = os.path.join(ROOT, 'tools/lst_index.pkl')
    A.have_funcs = use_listing and os.path.isfile(funcs_pkl)
    A.have_lst = use_listing and os.path.isfile(lst_pkl)
    if A.have_funcs:
        for f in pickle.load(open(funcs_pkl, 'rb'))['funcs']:
            if f['kind'] in ('proc', 'collapsed', 'synth') and CB <= f['start'] < CE: fstarts.add(f['start'])
    lst_items = None
    if A.have_lst:
        lst_items = pickle.load(open(lst_pkl, 'rb'))['items']

    # ---- jump tables in the code object: 'jmp dword [reg*4+disp32]' (FF 24 SIB, no base) with a fixup on disp32
    jt_heads = {}
    for s in srcs:
        if CB <= s < CE and CB <= tgt[s] < CE:
            b = byte(s - 3, 3)
            if b[0] == 0xFF and b[1] == 0x24 and (b[2] & 7) == 5 and (b[2] >> 6) == 2:
                jt_heads[tgt[s]] = s - 3
    fset = set(tgt)
    tables = []       # (start, end, kind, nent)
    jt_ranges = []
    heads_sorted = sorted(jt_heads)
    for t in heads_sorted:
        e = t
        while e in fset and CB <= tgt[e] < CE and (e == t or (e not in jt_heads and e not in fstarts)):
            e += 4
        tables.append((t, e, 'jump_table', (e - t) // 4)); jt_ranges.append((t, e))
    jt_ranges.sort(); jts = [r[0] for r in jt_ranges]
    def in_jt(a):
        j = bisect.bisect_right(jts, a) - 1
        return j >= 0 and jt_ranges[j][0] <= a < jt_ranges[j][1]
    case_targets = {tgt[a] for t0, t1 in jt_ranges for a in range(t0, t1, 4)}

    # ---- pointer tables in the data object: runs of >= 2 dword fixup sources at stride 4
    dsrc = [s for s in srcs if DB <= s < DE]
    i = 0
    while i < len(dsrc):
        j = i
        while j + 1 < len(dsrc) and dsrc[j + 1] == dsrc[j] + 4: j += 1
        if j > i:
            ts = [tgt[dsrc[k]] for k in range(i, j + 1)]
            kind = 'code_ptr_table' if all(CB <= x < CE for x in ts) else ('data_ptr_table' if all(DB <= x < DE for x in ts) else 'mixed_ptr_table')
            tables.append((dsrc[i], dsrc[j] + 4, kind, j - i + 1))
        i = j + 1
    tables.sort()
    A.tables = tables
    ptr_ranges = [(t0, t1) for t0, t1, k, n in tables if k != 'jump_table']; pts = [r[0] for r in ptr_ranges]
    def in_ptab(a):
        j = bisect.bisect_right(pts, a) - 1
        return ptr_ranges[j] if j >= 0 and ptr_ranges[j][0] <= a < ptr_ranges[j][1] else None

    # ---- decode the code object, segment by segment (linear sweep; data ranges emitted as data;
    #      resynchronised at known boundaries: function starts, fixup targets in code, branch targets).
    #      Data ranges in code = jump tables + listing data/align items (if the listing is available) + any run of
    #      stride-4 fixup sources that the sweep could not place on an instruction operand (iterated to a fixpoint).
    code_tgts = {t for t in tgt.values() if CB <= t < CE}
    img1 = bytes(objs[1]['img'])
    csrc = [s for s in srcs if CB <= s < CE]
    def runs_containing(bad):
        out = []
        for s in bad:
            k = bisect.bisect_left(csrc, s); i0 = i1 = k
            while i0 > 0 and csrc[i0 - 1] == csrc[i0] - 4: i0 -= 1
            while i1 + 1 < len(csrc) and csrc[i1 + 1] == csrc[i1] + 4: i1 += 1
            out.append((csrc[i0], csrc[i1] + 4))
        return out
    lst_cdata = []
    if lst_items is not None:
        la = sorted(a for a, v in lst_items.items() if v[0] == 'cseg01')
        fs_sorted = sorted(fstarts)
        for k, a in enumerate(la):
            if lst_items[a][1] in ('data', 'align'):
                e = la[k + 1] if k + 1 < len(la) else CE
                q = bisect.bisect_right(fs_sorted, a)
                if q < len(fs_sorted): e = min(e, fs_sorted[q])     # collapsed (FLIRT) functions have no items
                if lst_cdata and lst_cdata[-1][1] == a: lst_cdata[-1] = (lst_cdata[-1][0], e)
                else: lst_cdata.append((a, e))
    def merge(rs):
        out = []
        for a, b in sorted(rs):
            if out and a <= out[-1][1]: out[-1] = (out[-1][0], max(b, out[-1][1]))
            else: out.append((a, b))
        return out
    def sweep(bounds, dranges):
        out = []   # (addr, len, kind, insn or None); kind insn | data
        bl = sorted(bounds); ds = [r[0] for r in dranges]
        for s0, s1, mod, ob in segs:
            if ob != 1: continue
            a = s0
            while a < s1:
                j = bisect.bisect_right(ds, a) - 1
                if j >= 0 and dranges[j][0] <= a < dranges[j][1]:
                    e = min(dranges[j][1], s1); out.append((a, e - a, 'data', None)); a = e; continue
                k = bisect.bisect_right(bl, a); lim = min(s1, bl[k] if k < len(bl) else s1)
                if j + 1 < len(ds): lim = min(lim, ds[j + 1])
                ins = I.Decoder(32, img1[a - CB:lim - CB], ip=a).decode()
                if ins.is_invalid or ins.len == 0 or a + ins.len > lim:
                    out.append((a, 1, 'data', None)); a += 1; continue
                out.append((a, ins.len, 'insn', ins)); a += ins.len
        return out
    def bad_sources(insns):
        st = {a: (n, k, ins) for a, n, k, ins in insns}; sl = sorted(st); bad = []
        for s in csrc:
            j = bisect.bisect_right(sl, s) - 1; b = sl[j]; n, k, ins = st[b]
            if k != 'insn': continue
            dec = I.Decoder(32, img1[b - CB:b - CB + n], ip=b); i2 = dec.decode(); co = dec.get_constant_offsets(i2)
            if not ((co.displacement_size == 4 and b + co.displacement_offset == s) or (co.immediate_size == 4 and b + co.immediate_offset == s)):
                bad.append(s)
        return bad
    bounds = set(fstarts) | code_tgts
    dranges = merge(jt_ranges + lst_cdata)
    fx_interior = {s + k for s in csrc for k in (1, 2, 3)}
    def branch_targets(ins_list):
        out = set()
        for a, n, k, ins in ins_list:
            if k == 'insn' and (ins.is_call_near or ins.is_jmp_short_or_near or ins.is_jcc_short_or_near or ins.is_loop or ins.is_loopcc or ins.is_jcx_short):
                t = ins.near_branch_target
                if CB <= t < CE and t not in fx_interior: out.add(t)
        return out
    br = set()
    for it in range(16):
        insns = sweep(bounds | br, dranges)
        br2 = branch_targets(insns)
        bad = bad_sources(insns)
        if not bad and br2 == br: break
        if bad and (br2 == br or it >= 3):        # let the branch-target boundaries settle first
            dranges = merge(dranges + runs_containing(bad))
        br = br2
    A.branch_targets = br
    A.insns = insns; A.dranges = dranges; A.sweep_iterations = it + 1
    ds_sorted = [r[0] for r in dranges]
    def in_cdata(a):
        j = bisect.bisect_right(ds_sorted, a) - 1
        return j >= 0 and dranges[j][0] <= a < dranges[j][1]
    # tables of code pointers found only through the fixpoint (not 'jmp [reg*4+tab]' switch tables)
    jt_set = {r for r in jt_ranges}
    for r in runs_containing([s for s in csrc if in_cdata(s) and not in_jt(s)]):
        if r not in jt_set:
            ts = [tgt[q] for q in range(r[0], r[1], 4)]
            tables.append((r[0], r[1], 'code_obj_ptr_table' if all(CB <= x < CE for x in ts) else 'code_obj_data_ptrs', len(ts)))
            jt_set.add(r)
    tables.sort()
    ptab_targets = {tgt[q] for t0, t1, k, n in tables if k != 'jump_table' for q in range(t0, t1, 4) if q in tgt}
    call_tgts = set()
    for a, n, k, ins in insns:
        if k == 'insn' and ins.is_call_near and CB <= ins.near_branch_target < CE: call_tgts.add(ins.near_branch_target)
    # Watcom prologue 'push imm; call __CHK' marks a function entry
    chk = next((a for a, n in names.items() if n == '__CHK'), None)
    prolog = set()
    for idx in range(len(insns) - 1):
        a, n, k, ins = insns[idx]; b = insns[idx + 1]
        if k == 'insn' and ins.mnemonic == I.Mnemonic.PUSH and b[2] == 'insn' and b[3].is_call_near and b[3].near_branch_target == chk:
            prolog.add(a)
    fentry = fstarts | call_tgts | prolog
    A.fentry = fentry
    fe_sorted = sorted(fentry)
    istart = {a: (n, k, ins) for a, n, k, ins in insns}
    ist_sorted = sorted(istart)
    def insn_at(a):
        j = bisect.bisect_right(ist_sorted, a) - 1
        if j < 0: return None
        b = ist_sorted[j]; n, k, ins = istart[b]
        return (b, n, k, ins) if b <= a < b + n else None
    A.insn_at = insn_at

    # ---- per-fixup source sites
    fmt = I.Formatter(I.FormatterSyntax.MASM)
    sites = []; site_kind = Counter(); mem_size = defaultdict(Counter); imm_ref = set()
    for _, s, t, to in fx:
        T = objs[t]['base'] + to
        sg = segof(s)
        if DB <= s < DE:
            pt = in_ptab(s)
            kind = 'data_ptr_table_entry' if pt else 'data_dword'
            sites.append((s, sg[2] if sg else '', kind, '', '', '', T, pt[0] if pt else ''))
        else:
            x = insn_at(s)
            if x is None: kind = 'code_unknown'; sites.append((s, sg[2], kind, '', '', '', T, '')); site_kind[kind] += 1; continue
            b, n, k, ins = x
            if k == 'data': kind = 'code_jump_table_entry' if in_jt(s) else 'code_data_dword'; txt = ''; field = ''
            else:
                co = I.Decoder(32, img1[b - CB:b - CB + n], ip=b); ins2 = co.decode(); cofs = co.get_constant_offsets(ins2)
                txt = fmt.format(ins)
                if cofs.displacement_size == 4 and b + cofs.displacement_offset == s:
                    kind = 'insn_disp32'; field = 'disp'
                    # memory operand size (for dword_/word_/byte_ naming)
                    mem_size[T][I.MemorySizeExt.size(ins.memory_size) if hasattr(I, 'MemorySizeExt') else 0] += 1
                elif cofs.immediate_size == 4 and b + cofs.immediate_offset == s:
                    kind = 'insn_imm32'; field = 'imm'; imm_ref.add(T)
                else:
                    kind = 'insn_misaligned'; field = '?'
            sites.append((s, sg[2], kind, '%05X' % b, txt, field, T, ''))
        site_kind[kind] += 1
    A.sites = sites

    # memory operand sizes via a decoder on demand (iced exposes memory_size as enum; map common ones)
    MS = {I.MemorySize.UINT8: 1, I.MemorySize.INT8: 1, I.MemorySize.UINT16: 2, I.MemorySize.INT16: 2, I.MemorySize.UINT32: 4,
          I.MemorySize.INT32: 4, I.MemorySize.DWORD_OFFSET: 4, I.MemorySize.FLOAT32: 4, I.MemorySize.FLOAT64: 8,
          I.MemorySize.INT64: 8, I.MemorySize.UINT64: 8, I.MemorySize.FLOAT80: 10}
    msz = defaultdict(Counter)
    for s, mod, kind, ia, txt, field, T, pt in sites:
        if kind == 'insn_disp32':
            b, n, k, ins = insn_at(s); msz[T][MS.get(ins.memory_size, 0)] += 1

    # ---- data items for mid-item detection
    if lst_items is not None:
        dl = sorted(a for a in lst_items if DB <= a < DE)
        def ditem(a):
            j = bisect.bisect_right(dl, a) - 1
            return dl[j] if j >= 0 else None
    else:
        ditem = None

    def is_string(a):
        if a >= DINIT: return False
        bs = byte(a, 256); z = bs.find(b'\0')
        if z < 3: return False
        return all(32 <= c < 127 or c in (9, 10, 13) for c in bs[:z])

    # ---- symbols for every target
    refs = Counter(T for *_, T, _pt in sites)
    fe_names = {}
    syms = []
    cls_count = Counter(); sub_count = Counter(); named = Counter()
    for T in sorted(refs):
        flags = []; parent = ''
        if CB <= T < CE:
            if T in jt_heads:
                cls, sub = 'code_table', 'jump_table'; auto = 'jpt_%05X' % T
            elif in_jt(T):
                cls, sub = 'code_table', 'jump_table_interior'; auto = 'jpt_%05X' % T; flags.append('mid_item')
            elif in_cdata(T) and T not in fentry:
                cls, sub = 'code_table', 'data_in_code'; auto = 'unk_%05X' % T
            elif T in fentry:
                cls, sub = 'code_func', ('named' if T in names else ('call_target' if T in call_tgts else 'listing_or_prologue'))
                auto = 'sub_%05X' % T
            else:
                cls = 'code_mid'
                sub = 'switch_case' if T in case_targets else ('ptr_table_target' if T in ptab_targets else ('branch_target' if T in br else 'other'))
                auto = 'loc_%05X' % T; flags.append('mid_function')
                j = bisect.bisect_right(fe_sorted, T) - 1
                if j >= 0:
                    f = fe_sorted[j]; parent = '%s+%X' % (names.get(f, 'sub_%05X' % f), T - f)
            x = insn_at(T)
            if cls != 'code_table' and (x is None or x[0] != T or x[2] != 'insn'): flags.append('not_insn_boundary')
        elif DB <= T < DE:
            cls = 'data'
            pt = in_ptab(T)
            if T >= DINIT: sub = 'bss'
            elif pt: sub = 'ptr_table'
            elif is_string(T) and T in imm_ref: sub = 'string'
            else: sub = 'scalar_or_array'
            if pt and pt[0] != T: flags.append('mid_item'); parent = 'off_%05X+%X' % (pt[0], T - pt[0])
            if ditem is not None:
                d0 = ditem(T)
                if d0 is not None and d0 != T:
                    if 'mid_item' not in flags: flags.append('mid_item')
                    parent = parent or '%s+%X' % (names.get(d0, 'unk_%05X' % d0), T - d0)
            sz = msz[T].most_common(1)[0][0] if msz[T] else 0
            if sub == 'ptr_table': auto = 'off_%05X' % T
            elif sub == 'string': auto = 'asc_%05X' % T
            elif sz == 4: auto = 'dword_%05X' % T
            elif sz == 2: auto = 'word_%05X' % T
            elif sz == 1: auto = 'byte_%05X' % T
            elif sz == 8: auto = 'qword_%05X' % T
            elif sz == 10: auto = 'tbyte_%05X' % T
            else: auto = 'unk_%05X' % T
        else:
            cls, sub, auto = 'outside', '', 'unk_%05X' % T
        nm = names.get(T)
        named['named' if nm else 'auto'] += 1
        cls_count[cls] += 1; sub_count[cls + '/' + sub] += 1
        if 'mid_item' in flags: sub_count['flag/mid_item'] += 1
        if 'mid_function' in flags: sub_count['flag/mid_function'] += 1
        if 'not_insn_boundary' in flags: sub_count['flag/not_insn_boundary'] += 1
        syms.append(dict(lin=T, obj=objof(T), off=T - (CB if T < DB else DB), name=nm or auto, named=bool(nm),
                         source=nm_src.get(T, 'auto'), cls=cls, sub=sub, flags=','.join(flags), refs=refs[T], parent=parent,
                         seg=(segof(T) or ('', '', ''))[2], aliases=';'.join(aliases.get(T, []))))
    A.syms = syms
    A.symname = {s['lin']: s['name'] for s in syms}

    # ---- listing cross-check of instruction boundaries
    xc = {}
    if lst_items is not None:
        li = {a for a, v in lst_items.items() if v[0] == 'cseg01' and v[1] == 'insn'}
        mine = {a for a, n, k, ins in insns if k == 'insn'}
        xc = dict(listing_insns=len(li), decoded_insns=len(mine), common=len(li & mine),
                  listing_only=len(li - mine), decoded_only=len(mine - li))
        A.lst_only = sorted(li - mine); A.dec_only = sorted(mine - li)
    straddle = sum(1 for _, s, t, to in fx if (s % PAGE) + 4 > PAGE)
    nd = defaultdict(Counter)
    for s in syms: nd[s['cls']]['named' if s['named'] else 'auto'] += 1
    A.stats = dict(fixup_records=len(fx) + straddle, unique_fixups=len(fx), page_straddles=straddle,
                   targets=len(syms), named=named['named'], auto=named['auto'],
                   per_class={k: dict(total=cls_count[k], **nd[k]) for k in sorted(cls_count)},
                   per_subclass=dict(sorted(sub_count.items())), site_kinds=dict(sorted(site_kind.items())),
                   jump_tables=sum(1 for t in tables if t[2] == 'jump_table'),
                   jump_table_entries=sum(t[3] for t in tables if t[2] == 'jump_table'),
                   ptr_tables=dict(Counter(t[2] for t in tables if t[2] != 'jump_table')),
                   ptr_table_entries=sum(t[3] for t in tables if t[2] != 'jump_table'),
                   function_entries=dict(total=len(fentry), name_map_or_listing=len(fstarts), call_targets=len(call_tgts), chk_prologues=len(prolog)),
                   decoded=dict(Counter(k for a, n, k, ins in insns)), code_data_ranges=len(dranges),
                   code_data_bytes=sum(b - a for a, b in dranges), sweep_iterations=A.sweep_iterations, listing_crosscheck=xc,
                   used_listing=dict(funcs_pkl=A.have_funcs, lst_index_pkl=A.have_lst))
    return A

def write(A, outdir):
    os.makedirs(outdir, exist_ok=True)
    with open(os.path.join(outdir, 'symbols.tsv'), 'w') as f:
        f.write('# lin\tobj\toffset\tname\tnamed\tname_source\tclass\tsubclass\tflags\tn_refs\tparent\tsegment\taliases\n')
        for s in A.syms:
            f.write('%05X\t%d\t%X\t%s\t%d\t%s\t%s\t%s\t%s\t%d\t%s\t%s\t%s\n' % (s['lin'], s['obj'], s['off'], s['name'], s['named'],
                    s['source'], s['cls'], s['sub'], s['flags'], s['refs'], s['parent'], s['seg'], s['aliases']))
    with open(os.path.join(outdir, 'sites.tsv'), 'w') as f:
        f.write('# src\tsegment\tsite_kind\tinsn_addr\tinsn_text\tfield\ttarget\tsymbol\ttable\n')
        for s, mod, kind, ia, txt, field, T, pt in sorted(A.sites):
            f.write('%05X\t%s\t%s\t%s\t%s\t%s\t%05X\t%s\t%s\n' % (s, mod, kind, ia, txt, field, T, A.symname[T], ('%05X' % pt) if pt != '' else ''))
    with open(os.path.join(outdir, 'tables.tsv'), 'w') as f:
        f.write('# start\tend\tkind\tentries\tname\n')
        for t0, t1, k, n in A.tables:
            f.write('%05X\t%05X\t%s\t%d\t%s\n' % (t0, t1, k, n, A.symname.get(t0, ('jpt_%05X' if k == 'jump_table' else 'off_%05X') % t0)))
    json.dump(A.stats, open(os.path.join(outdir, 'stats.json'), 'w'), indent=1)

if __name__ == '__main__':
    import argparse
    ap = argparse.ArgumentParser()
    ap.add_argument('--parts', default=os.path.join(ROOT, 'build/parts'))
    ap.add_argument('--out', default=os.path.join(ROOT, 'build/labels'))
    ap.add_argument('--no-listing', action='store_true', help='ignore tools/funcs.pkl and tools/lst_index.pkl')
    ap.add_argument('--stats', help='also write the stats JSON here (e.g. tools/fixup_stats.json)')
    a = ap.parse_args()
    A = analyse(a.parts, use_listing=not a.no_listing)
    write(A, a.out)
    if a.stats: json.dump(A.stats, open(a.stats, 'w'), indent=1)
    print(json.dumps(A.stats, indent=1))
