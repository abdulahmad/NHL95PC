#!/usr/bin/env python3
"""find_handasm.py - flag game functions that look hand-written in asm (not wcc386 output), so the C queue skips them.

  python3 tools/find_handasm.py [--list]     writes tools/handasm.csv, prints counts (and the list with --list)

Scope: the game segments of cseg01 (001-066 without cmv_player, cdstream, zonemgr; the Watcom C library, EA libraries, DOS/4GW glue and sound/video
drivers after them are library code and not scanned). A function is a non-local label that starts after an
unconditional ret/jmp (or at the segment start); a non-local label reached by falling through is a mid-function
entry of the function before it.

Signals (each row lists the ones it has):
  nochk     no `push N / call __CHK` prologue. Every function wcc386 10.0 compiled for this game has it (stack
            checks are on), so this alone makes a function 'asm'.
  insn:X    an instruction wcc386 10.0 does not generate in plain C: pusha/popa, pushf/popf, 16-bit push/pop,
            enter, loop/jcxz, lods/stos/scas/cmps without rep, in/out, int, cli/sti, clc/stc/cmc, xchg, bt*,
            rcl/rcr, lahf/sahf, daa/das/aaa/aam, bswap, 16-bit mul/div.
  midcall   other code calls a non-local label inside it (wcc386 only jumps into another function's pop/ret tail,
            it never calls into the middle of one).
  stackargs no prologue and reads arguments from [esp+4..] / [ebp+8..] (not the Watcom register convention).
Status: 'asm' = nochk plus a strong signal (port I/O, 16-bit push/pop, loop, lds, pusha, int, string ops without
rep, cli/sti, midcall: confidence high), or any nochk function of the asm_helpers segment
(confidence segment). 'nochk' = no __CHK and nothing else: C compiled without stack checks (main_startup's
Read*Pad use the Watcom register convention) or a piece of a function reached through a pointer table; review
by hand (weak signals like cld, das or stackargs there are mostly case blocks or data disassembled as code,
e.g. stand_tmpl2, LeadersScreen_colSavePct). 'inline' = __CHK and an insn:X signal (C with #pragma aux / inline asm). Only 'asm' leaves the C queue;
none of these count in the C_PROGRESS denominator (that counts __CHK functions only).
tools/c_progress.py reads tools/handasm.csv and lists these functions with status 'asm'."""
import os, re, sys, csv, glob
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import cc
OUT = os.path.join(ROOT, 'tools/handasm.csv')
# (sahf is not here: Watcom emits fnstsw ax / sahf after every float compare.)
NEVER = re.compile(r'^(pushad?|popad?|pushfd?|popfd?|enter|loopn?[ez]?|jcxz|jecxz|lods[bwd]|stos[bwd]|scas[bwd]|cmps[bwd]|'
                   r'in|out|ins[bwd]|outs[bwd]|int|into|cli|sti|clc|stc|cmc|cld|std|xchg|bt|bts|btr|btc|rcl|rcr|lahf|'
                   r'daa|das|aaa|aas|aam|aad|bswap|xlatb?|hlt|iretd?|retf|lds|les|lfs|lgs|lss)$')

def insns(asm):
    """[(kind, text, addr)] kind: 'label' / 'ins' (comments, directives and data skipped)"""
    out = []
    for l in open(asm).read().split('\n'):
        m = cc.LABEL.match(l)
        if m: out.append(('label', m.group(1), None)); continue
        a = cc.ADDR.search(l)
        if a:
            t = l.split(';')[0].strip()
            if t.startswith('LD '): t = t[3:].replace(',', ' ', 1)
            out.append(('ins', t, int(a.group(1), 16)))
    return out

def refs():
    """names called, jumped to, or referenced as data / immediates anywhere in the source"""
    called, jumped, other = set(), set(), set()
    for asm in glob.glob(os.path.join(ROOT, 'src/cseg01/*.asm')) + glob.glob(os.path.join(ROOT, 'src/dseg02/*.asm')):
        code = '/cseg01/' in asm
        for l in open(asm):
            t = l.split(';')[0].strip()
            if not t or re.match(r'^(global|extern|%)', t): continue
            m = re.match(r'^call\s+(?:near\s+)?([A-Za-z_][\w$?@]*)$', t)
            if m: called.add(m.group(1)); continue
            m = re.match(r'^j\w+\s+(?:short\s+|near\s+)?([A-Za-z_][\w$?@]*)$', t)
            if m: jumped.add(m.group(1)); continue
            if code and t.startswith('dd '): jumped.update(re.findall(r'[A-Za-z_][\w$?@]*', t[3:])); continue
            for n in re.findall(r'\b([A-Za-z_][\w$?@]*)\b', t.split(None, 1)[1] if ' ' in t else ''): other.add(n)
    return called, jumped, other

def scan():
    called, jumped, other = refs()
    from c_progress import is_lib
    segs = [f for f in sorted(glob.glob(os.path.join(ROOT, 'src/cseg01/*.asm')))
            if 1 <= int(os.path.basename(f)[:3]) <= 66 and not is_lib(os.path.basename(f)[:-4])]
    funcs = []
    for asm in segs:
        cur = None; prev = None
        for kind, t, a in insns(asm):
            if kind == 'label':
                if t.startswith('.'): continue
                # a new function after ret/jmp, unless the label is only a jump (table) target, never called or
                # referenced as a pointer: then it is a case block / tail of the function before it
                inner = t in jumped and t not in called and t not in other
                if cur is None or (prev and re.match(r'^(ret|retn|jmp)\b', prev) and not inner):
                    cur = dict(name=t, seg=os.path.basename(asm)[:-4], ins=[], mids=[], addr=None); funcs.append(cur)
                else: cur['mids'].append(t)
                continue
            if cur is None: continue
            if cur['addr'] is None: cur['addr'] = a
            cur['ins'].append(t); prev = t
    rows = []
    for k, f in enumerate(funcs):
        ins = f['ins']
        if not ins: continue
        nxt = next((g['addr'] for g in funcs[k + 1:] if g['addr'] is not None and g['seg'] == f['seg']), None)
        size = (nxt - f['addr']) if nxt else 0
        chk = len(ins) >= 2 and ins[0].startswith('push dword') and ins[1] == 'call __CHK'
        sig = [] if chk else ['nochk']
        bad = sorted(set(x.split()[0] for x in ins if x.split() and NEVER.match(x.split()[0])))
        bad += sorted(set('16bit-' + x.split()[0] for x in ins if re.match(r'^(push|pop)\s+[a-d]x$|^(push|pop)\s+[sd]i$', x)))
        sig += ['insn:' + b for b in bad]
        if any(m in called for m in f['mids']): sig.append('midcall')
        if not chk and any(re.search(r'\[(byte\s+)?(esp\+0?[48]h?|ebp\+0?[8Cc]h?|ebp\+(byte\s+)?0?[8Cc]h?)\]', x) for x in ins[:12]): sig.append('stackargs')
        helpers = f['seg'].endswith('_asm_helpers')
        strong = [x for x in sig if re.match(r'insn:(16bit-|in$|out$|loop|lds|les|pusha|popa|int$|cli|sti|pushf|popf|enter|ins|outs|lods|stos|scas|cmps|iret|retf|hlt)', x)] + [x for x in sig if x == 'midcall']
        if not chk and (strong or helpers): status = 'asm'; conf = 'high' if strong else 'segment'
        elif not chk: status = 'nochk'; conf = ''
        elif bad: status = 'inline'; conf = ''
        else: continue
        rows.append(dict(function=f['name'], address='%05X' % f['addr'], size=size, segment=f['seg'], status=status,
                         confidence=conf, signals=' '.join(sig)))
    return rows

def main():
    rows = scan()
    with open(OUT, 'w', newline='') as fh:
        w = csv.DictWriter(fh, fieldnames=['function', 'address', 'size', 'segment', 'status', 'confidence', 'signals'], lineterminator='\n')
        w.writeheader(); w.writerows(rows)
    a = [r for r in rows if r['status'] == 'asm']
    print('%d hand-asm functions (%d bytes; %d by signals, %d in asm_helpers); %d no-__CHK functions to review; %d C functions with inline-asm instructions'
          % (len(a), sum(r['size'] for r in a), sum(r['confidence'] == 'high' for r in a), sum(r['confidence'] == 'segment' for r in a),
             sum(r['status'] == 'nochk' for r in rows), sum(r['status'] == 'inline' for r in rows)))
    if '--list' in sys.argv:
        for r in rows: print('%-6s %-6s %s %5d %-28s %-34s %s' % (r['status'], r['confidence'], r['address'], r['size'], r['function'], r['segment'], r['signals']))

if __name__ == '__main__':
    main()
