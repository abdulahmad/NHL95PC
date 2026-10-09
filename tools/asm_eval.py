#!/usr/bin/env python3
"""Assembler encoding-fidelity comparison (called by `asm_proto.py --eval SEG ...`).

Every decoded instruction of the given segments is assembled on its own (one section / segment per instruction) by
  * nasm 2.16  (-O0, ELF32)       text from asm_proto.insn_text (explicit short/near, byte/dword displacement and
                                   sign-extended-immediate hints, nosplit)
  * OW wasm 2.0 (OMF)             MASM text from iced's MASM formatter + 'short'/'near ptr' branches
  * JWasm 2.21 (ELF32)            same MASM text
and the result is compared with the original bytes (LE fixup fields masked: they are relocations, filled by the
linker). Branch targets are written as $+delta, fixup fields as an external symbol + offset (so the assembler
must emit a full 32-bit field, as with a real label). Results go to build/asm/eval.json.
"""
import os, re, json, subprocess, struct, shutil
from collections import Counter
import iced_x86 as I
import asm_proto as P
import omf

WASM = os.environ.get('WASM', os.path.expanduser('~/watcom/ow2/binl64/wasm'))
JWASM = os.environ.get('JWASM', shutil.which('jwasm') or 'jwasm')

def samples(A, segs):
    out = []
    for s0, s1, mod, ob in segs:
        if ob != 1: continue
        for a, n, k, ins in A.insns:
            if s0 <= a < s1 and k == 'insn':
                fx = {}
                dec = I.Decoder(32, A.byte(a, n), ip=a); i2 = dec.decode(); co = dec.get_constant_offsets(i2)
                bad = False
                for q in range(a, a + n):
                    if q in A.tgt:
                        T = A.tgt[q]
                        if co.displacement_size == 4 and a + co.displacement_offset == q: fx['disp'] = T
                        elif co.immediate_size == 4 and a + co.immediate_offset == q: fx['imm'] = T
                        else: bad = True
                if not bad: out.append((a, n, ins, fx, mod))
    return out

def ext(A, T):
    o = 1 if T < A.DB else 2
    return T - A.objs[o]['base']

def nasm_lines(A, S):
    f = P.nasm_formatter(); L = ['bits 32', 'extern XD']
    for i, (a, n, ins, fx, mod) in enumerate(S):
        L.append('section i%d progbits exec align=1' % i)
        L.append(P.insn_text(ins, fx, lambda T: 'XD+0%Xh' % ext(A, T), f, True, brlab=lambda t, a=a: '$%+d' % (t - a)))
    return L

def masm_text(A, a, ins, fx):
    f = I.Formatter(I.FormatterSyntax.MASM)
    f.memory_size_options = I.MemorySizeOptions.ALWAYS; f.masm_add_ds_prefix32 = True; f.uppercase_hex = True
    ops = []
    for k in range(f.operand_count(ins)):
        oi = f.get_instruction_operand(ins, k); t = f.format_operand(ins, k)
        kind = ins.op_kind(oi) if oi is not None else None
        if kind == I.OpKind.NEAR_BRANCH32:
            cn = P.CODE_NAME[ins.code]; d = ins.near_branch_target - a
            if ins.is_call_near or 'LOOP' in cn or 'JECXZ' in cn: ops.append('$%+d' % d)
            else: ops.append(('short ' if 'REL8' in cn else 'near ptr ') + '$%+d' % d)
        elif kind == I.OpKind.MEMORY and 'disp' in fx:
            pre = t[:t.index('[')] if '[' in t else t[:t.index(':') + 1] if 'ds:' in t else ''
            regs = []
            if ins.memory_base != I.Register.NONE: regs.append(P.REG[ins.memory_base])
            if ins.memory_index != I.Register.NONE: regs.append(P.REG[ins.memory_index] + '*%d' % ins.memory_index_scale)
            pre = re.sub(r'\w\w:$', '', pre)
            seg = P.REG[ins.segment_prefix] + ':' if ins.segment_prefix != I.Register.NONE else ''
            ops.append('%s%s[%s]' % (pre, seg, '+'.join(regs + ['XD+0%Xh' % ext(A, fx['disp'])])))
        elif kind == I.OpKind.IMMEDIATE32 and 'imm' in fx:
            ops.append('offset XD+0%Xh' % ext(A, fx['imm']))
        else: ops.append(t)
    mn = f.format_mnemonic(ins)
    if mn.startswith('notrack '): mn = mn[8:]
    return mn + (' ' + ','.join(ops) if ops else '')

def masm_lines(A, S, elf=False):
    L = ['.586p', '.387', '.model flat' if elf else '', 'extrn XD:byte']
    for i, (a, n, ins, fx, mod) in enumerate(S):
        L += ['I%d segment use32 byte public \'CODE\'' % i, masm_text(A, a, ins, fx), 'I%d ends' % i]
    L.append('end')
    return L

def compare(A, S, got):
    res = []; fails = Counter(); ex = {}
    for i, (a, n, ins, fx, mod) in enumerate(S):
        g = got.get(i)
        o = A.byte(a, n)
        mask = set()
        for q in range(a, a + n):
            if q in A.tgt: mask |= {q - a + k for k in range(4)}
        if g is None: ok = False; why = 'rejected'
        elif len(g) != n: ok = False; why = 'length %d->%d' % (n, len(g))
        else:
            ok = all(g[k] == o[k] for k in range(n) if k not in mask); why = 'bytes'
        if not ok:
            key = '%s (%s)' % (P.CODE_NAME[ins.code], why)
            fails[key] += 1; ex.setdefault(key, (('%05X' % a), o.hex(), g.hex() if g else None))
        res.append(ok)
    return sum(res), fails, ex

def run_one(A, segs):
    os.makedirs(P.OUT, exist_ok=True)
    S = samples(A, segs)
    out = dict(segments=[s[2] for s in segs], instructions=len(S))
    # nasm
    src = os.path.join(P.OUT, 'eval_nasm.asm'); open(src, 'w').write('\n'.join(nasm_lines(A, S)) + '\n')
    lines = nasm_lines(A, S)
    for _ in range(30):
        open(src, 'w').write('\n'.join(lines) + '\n')
        r = subprocess.run(['nasm', '-O0', '-f', 'elf32', src, '-o', src[:-4] + '.o'], capture_output=True, text=True)
        bad = {int(m.group(1)) for m in re.finditer(r':(\d+): error', r.stderr)}
        if r.returncode == 0: break
        for b in bad: lines[b - 1] = '; rejected: ' + lines[b - 1]
    got = {}
    if r.returncode == 0:
        d, secs, syms, rels = P.read_elf(src[:-4] + '.o')
        for s in secs:
            if re.match(r'i\d+$', s['name']): got[int(s['name'][1:])] = d[s['off']:s['off'] + s['size']]
    out['nasm'] = dict(zip(('identical', 'mismatch_kinds', 'examples'), compare(A, S, got)), errors=r.stderr[:500])
    # wasm (OMF) and jwasm (ELF)
    for name, exe, elf in (('wasm', WASM, False), ('jwasm', JWASM, True)):
        if not os.path.exists(exe): out[name] = 'not installed'; continue
        src = os.path.join(P.OUT, 'eval_%s.asm' % name); lines = masm_lines(A, S, elf)
        obj = src[:-4] + '.o'
        cmd = [exe, '-q', '-fpi87', '-e=5000', '-fo=' + obj, src] if name == 'wasm' else [exe, '-q', '-e5000', '-elf', '-Fo' + obj, src]
        rejected = []
        for _ in range(30):     # drop rejected lines until the file assembles (they count as 'rejected')
            open(src, 'w').write('\n'.join(lines) + '\n')
            if os.path.exists(obj): os.remove(obj)
            r = subprocess.run(cmd, capture_output=True, text=True, errors='replace', cwd=P.OUT)   # JWasm drops a .err file in cwd
            bad = {int(m.group(1)) for m in re.finditer(r'\((\d+)\)\s*: (?:Error|error)', r.stdout + r.stderr)}
            insn_lines = {6 + 3 * i for i in range(len(S))}          # 1-based line numbers of the instruction lines
            bad = {b for b in bad if b in insn_lines and not lines[b - 1].startswith(';')}
            if not bad or os.path.exists(obj) and r.returncode == 0: break
            for b in bad:
                rejected.append(lines[b - 1]); lines[b - 1] = '; rejected'
        got = {}
        if os.path.exists(obj):
            if elf:
                d, secs, syms, rels = P.read_elf(obj)
                for s in secs:
                    if re.match(r'I\d+$', s['name']): got[int(s['name'][1:])] = d[s['off']:s['off'] + s['size']]
            else:
                m, _ = omf.parse_module(open(obj, 'rb').read(), 0)
                for s in m['segs']:
                    if re.match(r'I\d+$', s['name']): got[int(s['name'][1:])] = bytes(s['data'])
        out[name] = dict(zip(('identical', 'mismatch_kinds', 'examples'), compare(A, S, got)), errors=(r.stdout + r.stderr)[:800],
                         rejected_lines=len(rejected), rejected_examples=rejected[:15])
    return out

def run(A, segs):
    """per segment (keeps files small), aggregated per segmap group"""
    SM = json.load(open(os.path.join(P.ROOT, 'segmap95pc.json')))
    grp = {s['start']: s['group'] for s in SM['cseg01']}
    tot = {}; per_seg = []
    for seg in segs:
        if seg[3] != 1: continue
        o = run_one(A, [seg]); g = grp.get(seg[0], '?')
        row = dict(segment='%05X' % seg[0], module=seg[2], group=g, n=o['instructions'])
        for k in ('nasm', 'wasm', 'jwasm'):
            if not isinstance(o.get(k), dict): continue
            row[k] = o[k]['identical']
            for key in ('ALL', g):
                t = tot.setdefault(key, dict(n=0)); t.setdefault(k, 0); t.setdefault(k + '_kinds', Counter())
                t[k] += o[k]['identical']; t[k + '_kinds'].update(o[k]['mismatch_kinds'])
        for key in ('ALL', g): tot.setdefault(key, dict(n=0))['n'] += o['instructions']
        per_seg.append(row)
    for key, t in tot.items():
        for k in ('nasm', 'wasm', 'jwasm'):
            if k + '_kinds' in t: t[k + '_kinds'] = dict(t[k + '_kinds'].most_common(12))
    print('%-10s %8s  %-17s %-17s %-17s' % ('group', 'insns', 'nasm', 'wasm', 'jwasm'))
    for key in sorted(tot, key=lambda k: -tot[k]['n']):
        t = tot[key]
        print('%-10s %8d  ' % (key, t['n']) + '  '.join('%7d %7.3f%%' % (t.get(k, 0), 100.0 * t.get(k, 0) / max(1, t['n'])) for k in ('nasm', 'wasm', 'jwasm')))
    json.dump(dict(totals=tot, segments=per_seg), open(os.path.join(P.OUT, 'eval.json'), 'w'), indent=1)
