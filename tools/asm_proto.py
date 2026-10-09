#!/usr/bin/env python3
"""Prototype: segment -> NASM source with symbolic labels -> assemble -> link (Python) -> bytes + LE fixups -> verify.

  python3 tools/asm_proto.py SEG [SEG ...]        SEG = segment start (hex, e.g. 2970A) or module name
  python3 tools/asm_proto.py --all                every segment in segmap95pc.json (code + initialised data)
  python3 tools/asm_proto.py --eval SEG ...       assembler encoding-fidelity comparison (nasm / OW wasm / JWasm)
  options: --no-listing  analyse without the IDA-derived caches (EXE parts + committed maps only)
           --exe-check   rebuild the whole EXE with the assembled segments + harvested fixups (order_fixups) and sha1-compare
           --no-hints    plain iced NASM text (no db fallbacks, no size hints) to see raw ambiguity counts

Writes build/asm/<NNN>_<ADDR>_<module>.asm (+ .o, .lst) and build/asm/report.json. Needs: nasm, iced-x86 (pip),
build/parts from `rebuild_exe.py extract`. Nothing under build/ is committed.

Per segment the flow is:
  1. fixup_labels.analyse() gives instruction/data elements, symbols and fixups.
  2. Emit NASM: labels for fixup targets, branch targets and function entries; operands that carry an LE fixup
     become symbol references; branches become label references with explicit short/near; data ranges become
     db runs with 'dd sym' at fixup sources. Labels outside the segment are 'extern'.
  3. nasm -O0 -f elf32; the listing gives each element's offset. A small linker (here) applies R_386_32 /
     R_386_PC32 relocations from the global symbol table. R_386_32 relocations become LE fixups
     (src_linear, target_obj, target_offset) and the stored value is the object-relative offset, as wlink does.
  4. Any element whose bytes differ from the original is re-emitted as db (+ dd sym / dd label-$-4 for its
     fixup / rel32 fields) and the segment is assembled again (fixpoint, normally 1-2 rounds).
  5. Verify: bytes == original segment slice, fixup set == LE fixups whose source is in the segment.
"""
import os, sys, re, json, struct, subprocess, bisect, hashlib, random, shutil
from collections import Counter, defaultdict
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import iced_x86 as I
import fixup_labels as FL

ROOT = FL.ROOT
OUT = os.path.join(ROOT, 'build/asm')
TXT = I.Formatter(I.FormatterSyntax.NASM)
CODE_NAME = {getattr(I.Code, n): n for n in dir(I.Code) if not n.startswith('_') and isinstance(getattr(I.Code, n), int)}
REG = {getattr(I.Register, n): n.lower() for n in dir(I.Register) if not n.startswith('_') and isinstance(getattr(I.Register, n), int)}

# ------------------------------------------------------------------------------------------------ naming
class Names:
    def __init__(self, A):
        self.A = A; self.n2a = {}
    def __call__(self, a):
        A = self.A
        if a in A.names: n = A.names[a]
        elif a in A.symname: n = A.symname[a]
        elif A.CB <= a < A.CE: n = ('sub_%05X' if a in A.fentry else 'loc_%05X') % a
        else: n = 'unk_%05X' % a
        self.n2a[n] = a
        return n

# ------------------------------------------------------------------------------------------------ NASM emitter
def nasm_formatter():
    f = I.Formatter(I.FormatterSyntax.NASM)
    f.memory_size_options = I.MemorySizeOptions.ALWAYS
    f.show_branch_size = True
    f.nasm_show_sign_extended_immediate_size = True
    f.uppercase_hex = True
    return f

def hx(v):
    return ('0%Xh' % v) if v >= 0 else ('-0%Xh' % -v)

def mem_operand(ins, prefix_txt, disp_txt, hints=True):
    parts = []
    if ins.memory_base != I.Register.NONE: parts.append(REG[ins.memory_base])
    if ins.memory_index != I.Register.NONE:
        sc = ins.memory_index_scale
        parts.append(REG[ins.memory_index] + ('*%d' % sc if (sc != 1 or ins.memory_base == I.Register.NONE) else ''))
    inner = '+'.join(parts)
    ds = ins.memory_displ_size
    if disp_txt is not None:
        inner = (inner + ('' if disp_txt.startswith('-') else '+') + disp_txt) if inner else disp_txt
    hint = ''
    if hints and ins.memory_base != I.Register.NONE:
        hint = {1: 'byte ', 4: 'dword '}.get(ds, '')
    if ins.memory_base == I.Register.NONE and ins.memory_index != I.Register.NONE: hint = 'nosplit '
    seg = REG[ins.segment_prefix] + ':' if ins.segment_prefix != I.Register.NONE else ''
    return '%s[%s%s%s]' % (prefix_txt, hint, seg, inner)

def insn_text(ins, fx_fields, lab, f, hints=True, brlab=None):
    """fx_fields: {'disp': target_lin, 'imm': target_lin} for fields carrying an LE fixup"""
    ops = []
    for k in range(f.operand_count(ins)):
        oi = f.get_instruction_operand(ins, k)
        t = f.format_operand(ins, k)
        if oi is None: ops.append(t); continue
        kind = ins.op_kind(oi)
        if kind in (I.OpKind.NEAR_BRANCH32, I.OpKind.NEAR_BRANCH16):
            nm = (brlab or lab)(ins.near_branch_target)
            cn = CODE_NAME[ins.code]
            if ins.is_call_near or 'LOOP' in cn or 'JECXZ' in cn or 'JCXZ' in cn: ops.append(nm)
            else: ops.append(('short ' if 'REL8' in cn else 'near ') + nm)
        elif kind == I.OpKind.MEMORY:
            pre = t[:t.index('[')] if '[' in t else ''
            if 'disp' in fx_fields: d = lab(fx_fields['disp'])
            elif ins.memory_displ_size: 
                v = ins.memory_displacement
                if ins.memory_base != I.Register.NONE or ins.memory_index != I.Register.NONE:
                    v = v - (1 << 32) if v & 0x80000000 else v
                d = hx(v)
            else: d = None
            ops.append(mem_operand(ins, pre, d, hints))
        elif kind in (I.OpKind.IMMEDIATE32, ) and 'imm' in fx_fields:
            ops.append(lab(fx_fields['imm']))
        else:
            ops.append(t)
    mn = f.format_mnemonic(ins)
    if mn.startswith('notrack '): mn = mn[8:]     # iced spells a DS prefix on an indirect branch as CET 'notrack'
    return mn + (' ' + ', '.join(ops) if ops else '')

def db_fallback(addr, raw, fx_here, rel32, lab):
    """bytes as db, with 'dd sym' for fixup fields and 'dd label-$-4' for a rel32 branch field"""
    out = []; i = 0; run = []
    def flush():
        if run: out.append('db ' + ','.join(hx(b) for b in run)); run.clear()
    while i < len(raw):
        a = addr + i
        if a in fx_here: flush(); out.append('dd ' + lab(fx_here[a])); i += 4; continue
        if rel32 and a == rel32[0]: flush(); out.append('dd %s-$-4' % lab(rel32[1])); i += 4; continue
        run.append(raw[i]); i += 1
    flush()
    return out

HEADER = '; %s %05X-%05X  generated by tools/asm_proto.py (do not edit)'

def emit_segment(A, seg, lab, fallback=set(), hints=True):
    s0, s1, mod, ob = seg
    f = nasm_formatter()
    els = []          # (addr, len, kind)
    phys_end = A.objs[ob]['base'] + len(A.objs[ob]['img'])
    lines = [HEADER % (mod, s0, s1), 'bits 32', '%include "x86enc.inc"']
    secflags = 'progbits alloc exec nowrite align=1' if ob == 1 else \
               ('progbits alloc noexec write align=1' if s0 < phys_end else 'nobits alloc noexec write align=1')
    lines.append('section %s %s' % ('s_%05X' % s0, secflags))
    fx_in = {s: A.tgt[s] for s in A.tgt if s0 <= s < s1}
    # label addresses inside the segment
    labels = set(t for t in A.tgt.values() if s0 <= t < s1)
    labels |= {a for a in A.fentry if s0 <= a < s1}
    labels |= {a for a in A.names if s0 <= a < s1}
    labels |= {t for t in A.branch_targets if s0 <= t < s1}
    interior = {}     # labels that fall inside an instruction (overlapping-code tricks / branches into data)
    labels.add(s0)
    refs = set()
    body = []; elmap = {}
    def L(a):
        n = lab(a); refs.add(a); return n
    def put_labels(a):
        if a in labels: body.append('%s:' % lab(a))
    # elements
    if ob == 1:
        elems = [(a, n, k, ins) for a, n, k, ins in A.insns if s0 <= a < s1]
    else:
        elems = [(s0, s1 - s0, 'data', None)]
    for a, n, k, ins in elems:
        raw = A.byte(a, n)
        if k == 'data':
            # split data at labels and fixup sources; runs of up to 16 bytes
            p = a; e = min(a + n, phys_end)
            while p < e:
                put_labels(p)
                if p in fx_in:
                    for q in (1, 2, 3):     # a label inside a pointer (target in the middle of a fixup dword)
                        if p + q in labels: body.append('%s equ $+%d' % (lab(p + q), q))
                    body.append('dd %s' % L(fx_in[p])); els.append((p, 4, 'dd', len(body))); p += 4; continue
                q = p + 1
                while q < e and q - p < 16 and q not in labels and q not in fx_in: q += 1
                body.append('db ' + ','.join(hx(b) for b in A.byte(p, q - p))); els.append((p, q - p, 'db', len(body))); p = q
            # BSS (whole segment, or the tail of one): labels + reserved space. A fixup dword that straddles the end
            # of the initialised data has already been emitted whole (p > e).
            gap = 'resb %d' if s0 >= phys_end else 'times %d db 0'      # nobits section / zero tail of a progbits one
            for l in sorted(l for l in labels if p <= l < a + n):
                if l > p: body.append(gap % (l - p)); p = l
                put_labels(l)
            if a + n > p: body.append(gap % (a + n - p))
            continue
        put_labels(a)
        for q in range(a + 1, a + n):
            if q in labels: body.append('%s equ $+%d' % (lab(q), q - a)); interior[q] = a
        fxf = {}
        dec = I.Decoder(32, raw, ip=a); i2 = dec.decode(); co = dec.get_constant_offsets(i2)
        for s, T in fx_in.items():
            if a <= s < a + n:
                if co.displacement_size == 4 and a + co.displacement_offset == s: fxf['disp'] = T
                elif co.immediate_size == 4 and a + co.immediate_offset == s: fxf['imm'] = T
                else: fxf['bad'] = T
        is_br = ins.is_call_near or ins.is_jmp_short_or_near or ins.is_jcc_short_or_near or ins.is_loop or ins.is_loopcc or ins.is_jcx_short
        if is_br and s0 <= ins.near_branch_target < s1 and ins.near_branch_target not in labels:
            # branch into the middle of something (e.g. data decoded as code): keep the raw bytes; the relative
            # displacement stays correct because the layout of the segment is reproduced exactly
            body.append('db ' + ','.join(hx(b) for b in raw) + '\t; %05X raw (target %05X unlabelled)' % (a, ins.near_branch_target))
            for s, T in fx_in.items(): assert not (a <= s < a + n)
            els.append((a, n, 'dbf', len(body))); continue
        m = re.match(r'(ADD|OR|ADC|SBB|AND|SUB|XOR|CMP|MOV)_R(8|16|32)_RM(8|16|32)$', CODE_NAME[ins.code])
        if a in fallback and m and ins.op_kind(1) == I.OpKind.REGISTER and not fxf and n == (3 if m.group(2) == '16' else 2):
            body.append('LD %s, %s, %s\t; %05X' % (m.group(1).lower(), REG[ins.op_register(0)], REG[ins.op_register(1)], a))
            els.append((a, n, 'ld', len(body))); continue
        if a in fallback or 'bad' in fxf:
            rel32 = None
            if is_br and 'REL8' not in CODE_NAME[ins.code]:
                rel32 = (a + n - 4, ins.near_branch_target); refs.add(ins.near_branch_target)
            if is_br and 'REL8' in CODE_NAME[ins.code]:
                tgt = ins.near_branch_target
                body.append('db ' + ','.join(hx(b) for b in raw[:-1]) + ', %s-($+%d)' % (L(tgt), n))
                els.append((a, n, 'dbf', len(body))); continue
            fb = db_fallback(a, raw, {s: T for s, T in fx_in.items() if a <= s < a + n}, rel32, L)
            fb[0] += '\t; %05X %s' % (a, ' '.join(TXT.format(ins).split()))
            for t in fb:
                body.append(t)
            for s, T in fx_in.items():
                if a <= s < a + n: refs.add(T)
            els.append((a, n, 'dbf', len(body) - (len(db_fallback(a, raw, {s: T for s, T in fx_in.items() if a <= s < a + n}, rel32, lab)) - 1)))
            continue
        for T in fxf.values(): refs.add(T)
        if is_br: refs.add(ins.near_branch_target)
        body.append(insn_text(ins, fxf, lab, f, hints) + '\t; %05X' % a)
        els.append((a, n, 'insn', len(body)))
    ext = sorted({lab(t) for t in refs if not (s0 <= t < s1)})
    glob = sorted({lab(t) for t in labels})
    hdr = lines + ['extern ' + ', '.join(ext[i:i + 8]) for i in range(0, len(ext), 8)] + \
          ['global ' + ', '.join(glob[i:i + 8]) for i in range(0, len(glob), 8)]
    off = len(hdr)
    return '\n'.join(hdr + body) + '\n', [(a, n, k, ln + off) for a, n, k, ln in els]

# ------------------------------------------------------------------------------------------------ ELF32 reader + linker
from link_src import read_elf      # shared with the src/ linker

def link_segment(objpath, seg, lab_n2a, A):
    """returns (bytes, fixups[(src, tobj, toff)])"""
    s0, s1, mod, ob = seg
    d, secs, syms, rels = read_elf(objpath)
    si = next(i for i, s in enumerate(secs) if s['name'] == 's_%05X' % s0)
    sec = secs[si]
    buf = bytearray(d[sec['off']:sec['off'] + sec['size']]) if sec['type'] != 8 else bytearray(sec['size'])
    fixups = []
    for o, symi, typ in rels.get(si, []):
        sy = syms[symi]
        if sy['shndx'] == 0: S = lab_n2a[sy['name']]                   # extern
        elif sy['shndx'] == si: S = s0 + sy['value']                   # section / local symbol
        else: raise ValueError('reloc against foreign section %r' % sy)
        P = s0 + o
        if typ == 23:    # R_386_PC8 (short branch to a label in another segment)
            v = S + struct.unpack_from('<b', buf, o)[0] - P
            # out of range only while an earlier element still has the wrong length; the per-element check fixes that
            struct.pack_into('<B', buf, o, v & 0xFF); continue
        Aadd = struct.unpack_from('<i', buf, o)[0]
        if typ == 1:     # R_386_32 -> LE internal fixup
            v = S + Aadd
            tobj = 1 if A.CB <= v < A.CE else 2
            toff = v - A.objs[tobj]['base']
            struct.pack_into('<I', buf, o, toff)
            fixups.append((P, tobj, toff))
        elif typ == 2:   # R_386_PC32 -> resolved, no LE fixup (same object)
            struct.pack_into('<I', buf, o, (S + Aadd - P) & 0xFFFFFFFF)
        else: raise ValueError('reloc type %d' % typ)
    return bytes(buf), fixups

def nasm_listing_offsets(lst):
    off = {}
    for ln in open(lst, encoding='latin1'):
        if re.match(r'.{32}<\d+>', ln): continue          # lines from %include / macro expansion
        m = re.match(r'\s*(\d+) ([0-9A-F]{8}) ', ln)
        if m and int(m.group(1)) not in off: off[int(m.group(1))] = int(m.group(2), 16)
    return off

# ------------------------------------------------------------------------------------------------ driver
def build_segment(A, seg, idx, hints=True, max_rounds=12):
    s0, s1, mod, ob = seg
    lab = Names(A)
    base = os.path.join(OUT, '%03d_%05X_%s' % (idx, s0, mod))
    fallback = set(); reasons = Counter(); rounds = 0; nasm_errs = Counter()
    phys_end = A.objs[ob]['base'] + len(A.objs[ob]['img'])
    orig = A.byte(s0, max(0, min(s1, phys_end) - s0))
    for rounds in range(1, max_rounds + 1):
        src, els = emit_segment(A, seg, lab, fallback, hints)
        open(base + '.asm', 'w').write(src)
        r = subprocess.run(['nasm', '-O0', '-I', os.path.join(ROOT, 'src/inc') + '/', '-f', 'elf32', '-l', base + '.lst', base + '.asm', '-o', base + '.o'], capture_output=True, text=True)
        if r.returncode:
            # assembler rejected some lines: fall back on those elements
            bad_lines = {int(m.group(1)) for m in re.finditer(r':(\d+): error', r.stderr)}
            newfb = {a for a, n, k, ln in els if ln in bad_lines and k == 'insn'}
            if not newfb: raise RuntimeError(r.stderr[:2000])
            for a in newfb: reasons['nasm_error'] += 1
            for m in re.finditer(r':(\d+): error: (.*)', r.stderr): nasm_errs[m.group(2)[:60]] += 1
            fallback |= newfb; continue
        # names used for externs
        buf, fx = link_segment(base + '.o', seg, lab.n2a, A)
        offs = nasm_listing_offsets(base + '.lst')
        newfb = set()
        lns = sorted(offs)
        el_off = [(a, n, k, offs.get(ln)) for a, n, k, ln in els]
        for j, (a, n, k, o) in enumerate(el_off):
            if k != 'insn' or o is None: continue
            nxt = el_off[j + 1][3] if j + 1 < len(el_off) else len(buf)
            got = buf[o:o + n] if nxt is None else buf[o:nxt]     # ld-macro lines carry no listing offset
            ins = A.insn_at(a)[3]
            is_br = ins.is_call_near or ins.is_jmp_short_or_near or ins.is_jcc_short_or_near or ins.is_loop or ins.is_loopcc or ins.is_jcx_short
            if is_br:   # displacement may be off only because a label moved; judge opcode bytes + length
                dsz = 1 if 'REL8' in CODE_NAME[ins.code] else 4
                bad = len(got) != n or got[:n - dsz] != A.byte(a, n - dsz)
            else:
                bad = len(got) != n or got != A.byte(a, n)
            if bad:
                newfb.add(a); reasons[classify(A, a, n, got)] += 1
        if not newfb: break
        fallback |= newfb
    # the assembled section covers the whole segment; bytes past the initialised data (BSS) must be zero
    ok_bytes = buf[:len(orig)] == orig and len(buf) == s1 - s0 and not any(buf[len(orig):])
    want = sorted((s, t, to) for _, s, t, to in A.fx if s0 <= s < s1)
    ok_fx = sorted(fx) == want
    nins = sum(1 for a, n, k, ln in els if k == 'insn'); nfb = sum(1 for a, n, k, ln in els if k == 'dbf')
    nld = sum(1 for a, n, k, ln in els if k == 'ld')
    ndata = sum(n for a, n, k, ln in els if k in ('db', 'dd'))
    return dict(segment='%05X' % s0, module=mod, obj=ob, size=s1 - s0, file_bytes=len(orig), rounds=rounds,
                insns=nins + nld + nfb, symbolic_insns=nins, ld_macro_insns=nld, db_fallback_insns=nfb, data_bytes=ndata, fixups=len(want), harvested_fixups=len(fx),
                bytes_match=ok_bytes, fixups_match=ok_fx, fallback_reasons=dict(reasons), nasm_errors=dict(nasm_errs)), buf, fx

def classify(A, a, n, got):
    """why did nasm pick a different encoding? (for the docs' pitfall table)"""
    raw = A.byte(a, n)
    ins = I.Decoder(32, raw, ip=a).decode()
    g = I.Decoder(32, bytes(got) + b'\x90' * 16, ip=a).decode()
    cn = CODE_NAME[ins.code]; gn = CODE_NAME[g.code]
    if cn == gn: return 'same opcode, different ModRM/SIB (%s)' % cn.split('_')[0]
    return '%s -> %s' % (cn, gn)

def resolve_segs(A, args):
    out = []
    for x in args:
        for k, s in enumerate(A.segs):
            if s[2] == x or ('%05X' % s[0]) == x.upper(): out.append((k if s[3] == 1 else k, s))
    return out

def seg_index(A, seg):
    # index within its object (matches build/parts file naming)
    same = [s for s in A.segs if s[3] == seg[3]]
    return same.index(seg)

def exe_check(A, results):
    """rebuild the whole EXE with assembled segment bytes + harvested fixups re-ordered by order_fixups()"""
    import rebuild_exe as RB
    parts = os.path.join(ROOT, 'build/parts'); np_ = os.path.join(ROOT, 'build/asm_parts')
    if os.path.isdir(np_): shutil.rmtree(np_)
    shutil.copytree(parts, np_, symlinks=False)
    man = json.load(open(os.path.join(np_, 'manifest.json')))
    replaced = set()
    for seg, buf, fx in results:
        e = next(m for m in man['segments'] if m['file'] and int(m['start'], 16) == seg[0] and m['obj'] == seg[3])
        open(os.path.join(np_, e['file']), 'wb').write(buf[:e['bytes']])
        replaced.add(seg)
    allfx = [(s, t, to) for _, s, t, to in A.fx if not any(a <= s < b for a, b, m, o in replaced)]
    for seg, buf, fx in results: allfx += fx
    random.seed(7); random.shuffle(allfx)
    ordered, nnew = RB.order_fixups(allfx, os.path.join(parts, 'le_fixups.tsv'))
    tsv = os.path.join(np_, 'fixups_from_asm.tsv')
    with open(tsv, 'w') as fo:
        for c, s, t, to in ordered: fo.write('%d\t%05X\t%d\t%X\n' % (c, s, t, to))
    exe, mism = RB.build(np_, os.path.join(ROOT, 'build/HOCKEY_asm.EXE'), tsv)
    h = hashlib.sha1(exe).hexdigest()
    return dict(sha1=h, match=h == '3961e0eba6b0338fad1613bb534efafd9406ed4a', new_fixups=nnew, segments_replaced=len(replaced))

def main():
    import argparse
    ap = argparse.ArgumentParser()
    ap.add_argument('segs', nargs='*'); ap.add_argument('--all', action='store_true'); ap.add_argument('--exe-check', action='store_true')
    ap.add_argument('--no-hints', action='store_true'); ap.add_argument('--eval', action='store_true')
    ap.add_argument('--report', default=os.path.join(OUT, 'report.json'))
    ap.add_argument('--no-listing', action='store_true', help='ignore tools/funcs.pkl / lst_index.pkl (EXE parts + name map only)')
    a = ap.parse_args()
    os.makedirs(OUT, exist_ok=True)
    A = FL.analyse(use_listing=not a.no_listing)
    segs = [s for s in A.segs if s[0] < A.objs[s[3]]['base'] + len(A.objs[s[3]]['img'])] if a.all else [s for _, s in resolve_segs(A, a.segs)]
    if a.eval:
        import asm_eval; asm_eval.run(A, segs); return
    res = []; results = []
    for seg in segs:
        try:
            r, buf, fx = build_segment(A, seg, seg_index(A, seg), hints=not a.no_hints)
        except Exception as e:
            r = dict(segment='%05X' % seg[0], module=seg[2], error=str(e)[:500]); buf = fx = None
        res.append(r)
        if buf is not None and r.get('bytes_match') and r.get('fixups_match'): results.append((seg, buf, fx))
        print(json.dumps(r))
    summ = dict(segments=len(res), matched=sum(1 for r in res if r.get('bytes_match') and r.get('fixups_match')),
                insns=sum(r.get('insns', 0) for r in res), symbolic_insns=sum(r.get('symbolic_insns', 0) for r in res),
                ld_macro_insns=sum(r.get('ld_macro_insns', 0) for r in res), db_fallback_insns=sum(r.get('db_fallback_insns', 0) for r in res),
                fixups=sum(r.get('fixups', 0) for r in res))
    rs = Counter()
    for r in res: rs.update(r.get('fallback_reasons', {}))
    summ['fallback_reasons'] = dict(rs.most_common())
    ne = Counter()
    for r in res: ne.update(r.get('nasm_errors', {}))
    summ['nasm_errors'] = dict(ne.most_common())
    if a.exe_check and results: summ['exe_check'] = exe_check(A, results)
    json.dump(dict(summary=summ, segments=res), open(a.report, 'w'), indent=1)
    print(json.dumps(summ, indent=1))

if __name__ == '__main__':
    main()
