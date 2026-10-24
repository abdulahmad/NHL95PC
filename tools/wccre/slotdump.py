#!/usr/bin/env python3
"""slotdump.py - show how wcc386 10.0 GA orders the stack slots of a C file's locals, from inside the compiler.

  python3 tools/wccre/slotdump.py src/c/<seg>/<File>.c [--func NAME] [--count NAME=N ...] [--all]

Runs the compiler in the emulator (tools/wccre/emucc.py, with the file's own cflags) and hooks the three sorts
that decide the stack slots. All three go through SortList (+64FC3) and its Shell sort (+64F44; not stable):

  use-count sort  comparator +57A0B, called at +57AE7 after register allocation (once or twice per function):
                  names with temp flag 100h (+2B bit 0) last; names with a conflict first, by the conflict's
                  loop-weighted use count (conflict +14, added up by +579E0) descending (unsigned); names without
                  a conflict by id (+24) descending (signed)
  size sort       TempAllocBefore +53EDE, in AssignOtherLocals +53E4D (Names[N_TEMP] +7E778 up to LastTemp
                  +7E798): temp flag 200h (+2B bit 1) first, then size (+8) ascending, then the parts of one
                  variable (same id) by offset (+10) descending

AssignOtherLocals then hands out the slots in the size sort's order, from the top of the frame down; a later name
reuses an earlier slot when their live ranges do not overlap. The location (+20) is a negative offset from the top
of the locals; under -od (an ebp frame) it is the [ebp-n] offset, else the slot is [esp + frame + location] at
push depth 0, the frame being CurrProc (+7E764) +2C + +30 + +0C (a parameter homed by a push gets its location
at the prologue, +4D0B6). Under -od AssignOtherLocals runs once per statement block and sorts only the new names.

For every function it prints the names that get a stack slot, in hand-out order: size, the use count the
use-count sorts saw, whether the name has a conflict, its position (1-based) in each sort's output, its
location and its slot. Every sort is also redone in Python (a copy of +64F44 and the comparators) and checked
against the compiler's list.

--count NAME=N (repeatable) asks which slots NAME would get with another use count. A second compile writes N
into NAME's conflict before each use-count sort; the compiler sorts and hands out the slots, and its positions /
slots are printed to the right of the compiled ones (* = another slot). The Python copy also redoes the three
sorts from the first compile's lists with the count replaced, without compiling, and says whether it predicts the
same hand-out order (it did in every case tried, with one and with two use-count sorts; the conflicts are rebuilt
between two use-count sorts, so the count is looked up by name in each).
--all lists every name (register names and the parts of a variable too), not only the stack slots."""
import argparse, os, struct, sys, tempfile
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, HERE)
import wccemu, emucc, regdump
from unicorn import UC_HOOK_CODE
from unicorn import x86_const as X

B = wccemu.BASE
GA = dict(sort_list=0x64FC3, use_before=0x57A0B, use_sorted=0x57AEC, temp_before=0x53EDE, temp_sorted=0x53E78,
          other_locals=0x53E4D, other_locals_ret=0x53F54, parm_home=0x4D0B6,
          curr_proc=0x7E764, names_temp=0x7E778, last_temp=0x7E798)
NO_LOCATION = 0x7FFFFFFF


# --- Python copy of the sorts -------------------------------------------------------------------------------

def shell_sort(arr, before):
    """ShellSort (+64F44): gap = gap / 2 + adjust (adjust 0, 1, 0, ...; the first gap is length / 2); at each gap
    compare-exchange arr[p] / arr[p + gap] left to right (exchange when before(arr[p + gap], arr[p])) and repeat
    the pass until it exchanges nothing; stop after the gap-1 passes"""
    arr = list(arr)
    gap, adjust = len(arr), 1
    while True:
        adjust = 1 if adjust == 0 else 0
        gap = (gap >> 1) + adjust
        while True:
            swapped = False
            for p in range(0, len(arr) - gap):
                if before(arr[p + gap], arr[p]):
                    arr[p], arr[p + gap] = arr[p + gap], arr[p]
                    swapped = True
            if not swapped:
                break
        if gap == 1:
            return arr


def use_before(a, b):
    """+57A0B"""
    if a['f1'] != b['f1']:
        return not a['f1']
    if (a['conf'] != 0) != (b['conf'] != 0):
        return a['conf'] != 0
    if a['conf']:
        return a['count'] > b['count']
    return a['id'] > b['id']


def temp_before(a, b):
    """TempAllocBefore (+53EDE)"""
    if a['f2'] != b['f2']:
        return bool(a['f2'])
    if a['size'] != b['size']:
        return a['size'] < b['size']
    return a['id'] == b['id'] and a['off'] > b['off']


def addrs(L): return [n['addr'] for n in L]


def resort(f, counts=None):
    """redo f's sorts in Python. counts: {name: use count} to replace. -> (outputs of the use-count sorts,
    outputs of the size sorts, problems): a later sort's input is its hooked input with the tail that came from
    the previous sort replaced by the simulated order"""
    probs = []
    pres, prev_hook, prev_sim = [], None, None
    for k, s in enumerate(f['pres']):
        inp = s['before']
        if prev_sim is not None:
            inp = splice(inp, prev_hook, prev_sim, probs, 'use-count sort %d' % (k + 1))
        if counts:
            # the conflicts are rebuilt between two use-count sorts (and their memory reused): look them up in each
            confs = dict((n['conf'], counts[n['label']]) for n in inp if n['label'] in counts and n['conf'])
            inp = [dict(n, count=confs[n['conf']]) if n['conf'] in confs else n for n in inp]
        out = shell_sort(inp, use_before)
        pres.append(out)
        prev_hook, prev_sim = s['after'], out
    sizes = []
    for k, s in enumerate(f['sizes']):
        inp = s['before']
        if k == 0 and prev_sim is not None:
            inp = splice(inp, prev_hook, prev_sim, probs, 'size sort')
        sizes.append(shell_sort(inp, temp_before))
    return pres, sizes, probs


def splice(inp, prev_hook, prev_sim, probs, what):
    """inp's names that came out of the previous sort (prev_hook, in that order) -> prev_sim's order"""
    ph = addrs(prev_hook)
    pos = dict((a, i) for i, a in enumerate(ph))
    keep = [n for n in inp if n['addr'] in pos]
    if [n['addr'] for n in keep] != [a for a in ph if a in set(n['addr'] for n in keep)]:
        probs.append('%s: its input does not keep the previous sort\'s order' % what)
        return inp
    byaddr = dict((n['addr'], n) for n in keep)
    order = iter([byaddr[n['addr']] for n in prev_sim if n['addr'] in byaddr])
    return [next(order) if n['addr'] in pos else n for n in inp]


# --- the hooks -----------------------------------------------------------------------------------------------

class SlotDump(regdump.RegDump):
    def __init__(self, emu, inject=None):
        """inject: {function: {name: use count}}: write these counts into the names' conflicts (+14) before
        every use-count sort of the function"""
        self.emu, self.uc = emu, emu.uc
        self.funcs = []
        self.inject = inject or {}
        for k, f in (('sort_list', self.on_sort), ('use_sorted', self.on_use_sorted),
                     ('temp_sorted', self.on_temp_sorted), ('other_locals_ret', self.on_other_ret),
                     ('parm_home', self.on_parm)):
            self.uc.hook_add(UC_HOOK_CODE, f, begin=B + GA[k], end=B + GA[k])

    def s32(self, a):
        v = self.u32(a)
        return v - (1 << 32) if v & 0x80000000 else v

    def proc_name(self):
        """CurrProc (+7E764) +80: the procedure's label, +8: its front-end symbol"""
        try:
            return self.sym_name(self.u16(self.u32(self.u32(B + GA['curr_proc']) + 0x80) + 8))
        except Exception:
            return None

    def name(self, nm):
        """an N_TEMP name: +8 size, +C conflict, +10 offset in its variable, +14 front-end symbol, +18 usage,
        +1C alias ring, +20 location, +24 id, +2A temp flags"""
        sym, nid, conf = self.u16(nm + 0x14), self.s32(nm + 0x24), self.u32(nm + 0xC)
        tf = self.u16(nm + 0x2A)
        return dict(addr=nm, label=(self.sym_name(sym) if sym else None) or 't%d' % nid, size=self.s32(nm + 8),
                    id=nid, off=self.s32(nm + 0x10), conf=conf, count=self.u32(conf + 0x14) if conf else None,
                    f1=(tf >> 8) & 1, f2=(tf >> 8) & 2, tflags=tf, loc=self.s32(nm + 0x20), named=bool(sym))

    def walk(self, head):
        out = []
        while head and len(out) < 50000:
            out.append(self.name(head))
            head = self.u32(head)
        return out

    def func(self):
        nm = self.proc_name() or '?'
        if not self.funcs or self.funcs[-1]['name'] != nm:
            self.funcs.append(dict(name=nm, pres=[], sizes=[], final={}, frame=None, parms=0))
        return self.funcs[-1]

    def on_sort(self, uc, addr, size, _):
        fn = self.emu.r(X.UC_X86_REG_EBX) - B
        if fn == GA['use_before']:
            f = self.func()
            want = self.inject.get(f['name'])
            if want:
                for n in self.walk(self.emu.r(X.UC_X86_REG_EAX)):
                    if n['label'] in want and n['conf']:
                        self.uc.mem_write(n['conf'] + 0x14, struct.pack('<I', want[n['label']] & 0xFFFFFFFF))
            f['pres'].append(dict(before=self.walk(self.emu.r(X.UC_X86_REG_EAX)), after=None))
        elif fn == GA['temp_before']:
            self.func()['sizes'].append(dict(before=self.walk(self.emu.r(X.UC_X86_REG_EAX)), after=None))

    def on_use_sorted(self, uc, addr, size, _):
        self.funcs[-1]['pres'][-1]['after'] = self.walk(self.emu.r(X.UC_X86_REG_EAX))

    def on_temp_sorted(self, uc, addr, size, _):
        self.funcs[-1]['sizes'][-1]['after'] = self.walk(self.emu.r(X.UC_X86_REG_EAX))

    def frame(self, f):
        p = self.u32(B + GA['curr_proc'])
        f['frame'] = self.s32(p + 0x2C) + self.s32(p + 0x30) + self.s32(p + 0xC)
        f['sub'] = self.s32(p + 0x2C) + self.s32(p + 0x30)

    def on_other_ret(self, uc, addr, size, _):
        f = self.func()
        for n in self.walk(self.u32(B + GA['names_temp'])):
            f['final'][n['addr']] = n
        self.frame(f)

    def on_parm(self, uc, addr, size, _):
        """a parameter homed by a push: location -= the frame below it, at the prologue (after the body)"""
        f = self.func()
        nm = self.emu.r(X.UC_X86_REG_EAX)
        self.frame(f)
        ebx = -(f['sub'])
        f['parms'] += 1
        if nm in f['final']:
            f['final'][nm] = dict(f['final'][nm], loc=f['final'][nm]['loc'] + ebx if not self.u8(nm + 0x2A) & 0x40
                                  else f['final'][nm]['loc'])


def prologue(obj):
    """{function: (ebp frame?, sub esp amount or None)} from the compiled object's code"""
    import omf, cobj
    from capstone import Cs, CS_ARCH_X86, CS_MODE_32
    m, _ = omf.parse_module(open(obj, 'rb').read(), 0)
    md = Cs(CS_ARCH_X86, CS_MODE_32)
    out = {}
    segs = dict((g['name'], g['data']) for g in m['segs'])
    for nm, sname, off in m['pubs']:
        data = segs.get(sname)
        if data is None: continue
        ebp, sub = False, None
        for i, ins in enumerate(md.disasm(bytes(data[off:off + 64]), off)):
            if ins.mnemonic == 'mov' and ins.op_str == 'ebp, esp': ebp = True
            elif ins.mnemonic == 'sub' and ins.op_str.startswith('esp, '): sub = int(ins.op_str[5:], 0); break
            elif ins.mnemonic not in ('push', 'call') or i > 12: break
        out[cobj.asm_name(nm)] = (ebp, sub)
    return out


def compile_dump(src, inject=None):
    import cc
    holder = {}
    def setup(emu):
        holder['d'] = SlotDump(emu, inject)
    fd, tmp = tempfile.mkstemp(suffix='.obj'); os.close(fd)
    try:
        ok, out, emu = emucc.compile_c(src, tmp, cc.src_flags(src), setup=setup)
        pro = prologue(tmp) if ok else {}
    finally:
        if os.path.exists(tmp): os.remove(tmp)
    if not ok:
        sys.stdout.write(out)
    for f in holder['d'].funcs:
        f['prologue'] = pro.get(f['name'])
    return holder['d'].funcs


# --- the report ----------------------------------------------------------------------------------------------

def slot_text(f, loc):
    if loc in (None, NO_LOCATION):
        return '-'
    ebp = f['prologue'][0] if f.get('prologue') else False
    if ebp:
        return '[ebp-%Xh]' % -loc if loc < 0 else '[ebp+%Xh]' % loc
    return '[esp+%Xh]' % (f['frame'] + loc)


def handout(f, sizes):
    """the names in hand-out order: the size sorts' outputs one after another"""
    seen, out = set(), []
    for L in sizes:
        for n in L:
            if n['addr'] not in seen:
                seen.add(n['addr']); out.append(n)
    return out


def check(f):
    """Python copy against the hooked lists -> lines"""
    pres, sizes, probs = resort(f)
    lines = []
    for k, s in enumerate(f['pres']):
        same = addrs(shell_sort(s['before'], use_before)) == addrs(s['after'] or [])
        chain = addrs(pres[k]) == addrs(s['after'] or [])
        lines.append('use-count sort %d (+57A0B): %d names; python copy %s%s' % (
            k + 1, len(s['before']), 'same' if same else 'DIFFERS',
            '' if k == 0 else ', chained from sort %d %s' % (k, 'same' if chain else 'DIFFERS')))
    same = [addrs(shell_sort(s['before'], temp_before)) == addrs(s['after'] or []) for s in f['sizes']]
    if len(f['sizes']) == 1:
        chain = addrs(sizes[0]) == addrs(f['sizes'][0]['after'] or [])
        lines.append('size sort (+53EDE): %d names; python copy %s%s' % (
            len(f['sizes'][0]['before']), 'same' if same[0] else 'DIFFERS',
            ', chained from the use-count sorts %s' % ('same' if chain else 'DIFFERS') if f['pres'] else ''))
    elif f['sizes']:
        # -od: AssignOtherLocals runs once per statement block and sorts only the names new since the last run
        lines.append('size sorts (+53EDE): %d runs (one per block), %d names; python copy %s' % (
            len(f['sizes']), sum(len(s['before']) for s in f['sizes']),
            'same in all' if all(same) else 'DIFFERS in runs ' + ', '.join(str(k + 1) for k, x in enumerate(same) if not x)))
    return lines + probs


def positions(lists):
    out = []
    for L in lists:
        out.append(dict((n['addr'], i + 1) for i, n in enumerate(L)))
    return out


def report(f, show_all, sim=None, out=sys.stdout):
    pro = f.get('prologue')
    if pro and pro[0]:
        fr = 'ebp frame'
    else:
        fr = 'esp frame %Xh' % f['frame'] if f['frame'] else 'no frame'
        if f['frame'] is not None and f['parms']:
            fr += ' (sub esp, %Xh + %d pushed parameter%s)' % (f['sub'], f['parms'], 's' * (f['parms'] > 1))
        if pro and pro[1] is not None and pro[1] != f['sub']:
            fr += ' (object: sub esp, %Xh: CHECK)' % pro[1]
    out.write('%s: %s\n' % (f['name'], fr))
    for l in check(f):
        out.write('  ' + l + '\n')
    pos_pre = positions([s['after'] or [] for s in f['pres']])
    pos_size = positions([s['after'] or [] for s in f['sizes']])
    counts = [dict((n['addr'], n['count']) for n in s['before']) for s in f['pres']]
    rows = [n for n in handout(f, [s['after'] or [] for s in f['sizes']])
            if show_all or not (f['final'].get(n['addr'], n)['loc'] == NO_LOCATION or n['tflags'] & 2)]
    if not rows:
        out.write('  no stack slots\n')
        return
    if sim:     # the second compile, with the use counts changed
        sf = sim
        spos_pre = positions([s['after'] or [] for s in sf['pres']])
        spos_size = positions([s['after'] or [] for s in sf['sizes']])
    hdr = '  %-14s %4s %8s %4s' % ('name', 'size', 'count', 'conf')
    hdr += ''.join(' %5s' % ('use%d' % (k + 1)) for k in range(len(f['pres'])))
    hdr += ' %6s %8s %-10s' % ('size', 'location', 'slot')
    if sim:
        hdr += ' | ' + ''.join('%5s ' % ('use%d' % (k + 1)) for k in range(len(f['pres']))) + '%6s %8s %s' % (
            'size', 'location', 'slot')
    out.write(hdr + '\n')
    multi = len(f['sizes']) > 1
    def spos(P, a):
        for k, p in enumerate(P):
            if a in p: return '%d:%d' % (k + 1, p[a]) if multi else str(p[a])
        return '-'
    for n in rows:
        fin = f['final'].get(n['addr'], n)
        cs = [c.get(n['addr']) for c in counts]
        cnt = '/'.join('-' if c is None else str(c) for c in cs) if any(c is not None for c in cs) else '-'
        conf = any(c is not None for c in cs) if f['pres'] else bool(n['conf'])
        line = '  %-14s %4d %8s %4s' % (n['label'], n['size'], cnt, 'yes' if conf else 'no')
        line += ''.join(' %5s' % p.get(n['addr'], '-') for p in pos_pre)
        line += ' %6s %8s %-10s' % (spos(pos_size, n['addr']),
                                     '-' if fin['loc'] == NO_LOCATION else str(fin['loc']), slot_text(f, fin['loc']))
        if sim:
            sn = sf['final'].get(n['addr'])
            sloc = sn['loc'] if sn else NO_LOCATION
            line += ' | ' + ''.join('%5s ' % p.get(n['addr'], '-') for p in spos_pre)
            line += '%6s %8s %s%s' % (spos(spos_size, n['addr']), '-' if sloc == NO_LOCATION else str(sloc),
                                      slot_text(sf, sloc), '' if sloc == fin['loc'] else '  *')
        out.write(line + '\n')


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('src')
    ap.add_argument('--func', help='only this C function')
    ap.add_argument('--count', action='append', default=[], metavar='NAME=N',
                    help="replace NAME's use count in the use-count sorts (repeatable)")
    ap.add_argument('--all', action='store_true', help='every name, not only the stack slots')
    a = ap.parse_args()
    funcs = compile_dump(a.src)
    if a.func:
        funcs = [f for f in funcs if f['name'] == a.func]
        if not funcs:
            raise SystemExit('slotdump: no function %s in %s' % (a.func, a.src))
    want = {}
    for c in a.count:
        k, v = c.split('=')
        want[k] = int(v, 0)
    sims, funcs2 = {}, {}
    if want:
        for f in funcs:
            if any(n['label'] in want and n['conf'] for p in f['pres'] for n in p['before']):
                sims[f['name']] = resort(f, want)
        if sims:
            funcs2 = dict((f['name'], f) for f in compile_dump(a.src, dict((k, want) for k in sims)))
    for f in funcs:
        f2 = funcs2.get(f['name'])
        report(f, a.all, f2)
        out = sys.stdout
        if want and not f2:
            out.write('  --count: nothing to change here (no use-count sort, or no such name with a conflict)\n')
        elif f2:
            missing = [k for k in want if k not in set(n['label'] for p in f['pres'] for n in p['before'] if n['conf'])]
            out.write('  right: a second compile with %s written into the conflicts before each use-count sort'
                      ' (the compiler sorts and hands out the slots); python copy of its sorts: %s\n' % (
                          ' '.join('%s=%d' % kv for kv in want.items() if kv[0] not in missing),
                          'same' if all(' same' in l and 'DIFFERS' not in l for l in check(f2)) else 'DIFFERS'))
            pres, sizes, probs = sims[f['name']]
            mine = [n['addr'] for n in sizes[0]] if sizes else []
            real = addrs(f2['sizes'][0]['after'] or []) if f2['sizes'] else []
            if mine == real:
                out.write("  python prediction from the first compile's lists (no second compile): the same order\n")
            else:
                k = next((i for i, (x, y) in enumerate(zip(mine, real)) if x != y), min(len(mine), len(real)))
                lab = dict((n['addr'], n['label']) for n in sizes[0] + (f2['sizes'][0]['after'] or []))
                why = '; '.join(probs) if probs else (
                    'the new order changed the passes between the sorts (other names or counts); trust the second '
                    'compile')
                out.write("  python prediction from the first compile's lists: differs from the second compile at"
                          " size-sort position %d (python %s, compiler %s): %s\n" % (
                              k + 1, lab.get(mine[k], '-') if k < len(mine) else '-',
                              lab.get(real[k], '-') if k < len(real) else '-', why))
            if missing:
                out.write('  no name %s with a conflict here (names without one are sorted by id)\n'
                          % ', '.join(missing))
        out.write('\n')



if __name__ == '__main__':
    main()
