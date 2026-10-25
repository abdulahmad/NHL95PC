#!/usr/bin/env python3
"""irdump.py - the code generator's instructions of a function, as register allocation sees them.

  python3 tools/wccre/irdump.py src/c/<seg>/<File>.c FUNC [--pass N] [--raw]

Compiles the file in the emulator (tools/wccre) and, when AssignConflicts has sorted FUNC's conflicts (+569B4,
the hook regdump.py uses), walks the blocks and their instructions and prints them, one per line:

  B3 L17 d1  t8 = mov p          (block, C source line, loop depth, result = opcode operands)

so every code generator temporary tN can be traced to the source line and expression that made it, and every
conflict's uses (with loop depth, which weights its savings) can be read off. The conflicts of the pass follow,
in the order the allocator gives out registers (as regdump.py), each with its definition and uses.

GA layouts (image 10.0 GA, checked against Open Watcom bld/cg/h/inslist.h, block.h, name.h):
  instruction  +0 next, +4 prev, +20 source line (u16), +22 opcode (u8), +23 state, +24 table, +28 gen_table,
               +2C zap, +30 result, +38 type class, +39 base type class, +3C flags (compare: true / false
               block index in the low / high nibble), +3F operand count, +44.. operands
  block        +0 the instruction list sentinel (opcode OP_BLOCK), +24 itself, +28 next block, +2C prev block
  name         +0 next, +4 class (0 constant, 1 memory, 2 temp, 3 register, 4 indexed), +5 type class, +8 size;
               constant +10 value; memory +14 front-end symbol (u16); temp +14 symbol (0: a cg temporary), +24 id;
               register +C register set; indexed +C index name, +10 constant offset, +14 base name
GA opcode numbers differ from Open Watcom's (GA has fewer opcodes); OPS lists the ones identified so far."""
import argparse, os, struct, sys
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, HERE); sys.path.insert(0, os.path.join(ROOT, 'tools'))
import regdump, regsolve, emucc, cc

OPS = {0x00: 'nop', 0x01: 'add', 0x03: 'sub', 0x05: 'mul', 0x07: 'div', 0x08: 'mod', 0x09: 'and', 0x0A: 'or',
       0x0B: 'xor', 0x0C: 'shr', 0x0D: 'shl', 0x26: 'mov', 0x30: 'if==', 0x31: 'if!=', 0x32: 'if>', 0x33: 'if<=',
       0x34: 'if<', 0x35: 'if>=',
       0x11: 'neg', 0x12: 'not', 0x24: 'cnv', 0x28: 'lea', 0x2A: 'push', 0x2C: 'parm', 0x2E: 'tst<>', 0x2F: 'tst==',
       0x36: 'call'}
TYPES = ['u1', 'i1', 'u2', 'i2', 'u4', 'i4', 'u8', 'i8', 'cp', 'pt', '--', 'fs', 'fd', 'fl']


class IRDump(regsolve.Capture):
    def __init__(self, emu, func, want_pass=None):
        self.func, self.want_pass, self.fpass, self.dumps = func, want_pass, 0, []
        regsolve.Capture.__init__(self, emu)

    def on_sorted(self, uc, addr, size, _):
        regsolve.Capture.on_sorted(self, uc, addr, size, _)
        if self.proc_name() != self.func: return
        k = self.fpass; self.fpass += 1
        if self.want_pass is not None and k != self.want_pass: return
        p = self.passes[-1]
        self.dumps.append((k, p, self.walk(p)))

    # ---- names
    def name(self, v, labels):
        if not v: return None
        if v in labels: return labels[v]
        try: cls, tc = self.u8(v + 4), self.u8(v + 5)
        except Exception: return '?%x' % v
        if cls == 0:
            x = self.u32(v + 0x10); x = x - (1 << 32) if x >= 1 << 31 else x
            return '%d' % x if -4096 < x < 4096 else '%Xh' % (x & 0xFFFFFFFF)
        if cls == 1:
            return self.sym_name(self.u16(v + 0x14)) or 'mem%x' % v
        if cls == 2:
            s = self.u16(v + 0x14)
            return (self.sym_name(s) if s else None) or 't%d' % self.u32(v + 0x24)
        if cls == 3:
            r = self.u32(v + 0xC)
            return regdump.regname(r) if r else '{}'
        if cls == 4:
            idx, off, base = self.u32(v + 0xC), self.u32(v + 0x10), self.u32(v + 0x14)
            off = off - (1 << 32) if off >= 1 << 31 else off
            s = self.name(idx, labels) if idx else ''
            if base and base != v: s = '%s+%s' % (self.name(base, labels), s) if s else self.name(base, labels)
            if off: s += '%+d' % off
            return '[%s]%s' % (s, TYPES[tc] if tc < len(TYPES) else '')
        return 'n%d@%x' % (cls, v)

    def walk(self, p):
        labels = {c['name']: c['label'] for c in p['confs']}
        blk = self.u32(p['confs'][0]['conf'] + 0xC) if p['confs'] else 0
        if not blk: return []
        while self.u32(blk + 0x2C): blk = self.u32(blk + 0x2C)      # back to the head block
        out, bi, seen = [], 0, set()
        while blk and blk not in seen:
            seen.add(blk)
            ins = self.u32(blk + 4); rows = []
            while ins and ins != blk and len(rows) < 2000:
                op = self.u8(ins + 0x22); n = self.u8(ins + 0x3F)
                ops = [self.name(self.u32(ins + 0x44 + 4 * i), labels) for i in range(min(n, 4))]
                res = self.name(self.u32(ins + 0x30), labels)
                tc = self.u8(ins + 0x38)
                inner = []
                for v in [self.u32(ins + 0x30)] + [self.u32(ins + 0x44 + 4 * i) for i in range(min(n, 4))]:
                    if v and self.u8(v + 4) == 4:
                        for w in (self.u32(v + 0xC), self.u32(v + 0x14)):
                            if w and w != v: inner.append(self.name(w, labels))
                rows.append(dict(addr=ins, line=self.u16(ins + 0x20), op=op, res=res, ops=ops, tc=tc, inner=inner,
                                 res_ptr=self.u32(ins + 0x30), op_ptrs=[self.u32(ins + 0x44 + 4 * i) for i in range(min(n, 4))]))
                ins = self.u32(ins + 4)
            out.append(dict(addr=blk, index=bi, rows=rows, depth=self.u8(blk + 0x50))); bi += 1
            blk = self.u32(blk + 0x28)
        return out


def conflict_info(src, func, want_pass=0):
    """{conflict label: ([defining instructions], [using instructions])} of FUNC's allocation pass, each as
    'B<block>:L<line> <instruction>' (one emulator compile)"""
    import tempfile
    holder = {}
    def setup(emu): holder['d'] = IRDump(emu, func, want_pass)
    tmp = tempfile.mktemp(suffix='.obj')
    emucc.compile_c(src, tmp, cc.src_flags(src), setup=setup)
    if os.path.exists(tmp): os.remove(tmp)
    d = holder.get('d')
    if not d or not d.dumps: return {}
    k, p, blocks = d.dumps[0]
    out, line = {}, 0
    for b in blocks:
        for r in b['rows']:
            if r['line']: line = r['line']
            s = 'B%d:L%d%s %s' % (b['index'], line, '*' * b['depth'], fmt(r))
            if r['res'] and not r['res'].startswith('['): out.setdefault(r['res'], ([], []))[0].append(s)
            for o in set(x for x in r['ops'] + r['inner'] if x and not x.startswith('[')):
                out.setdefault(o, ([], []))[1].append(s)
    return out


def opname(op):
    return OPS.get(op, 'op%02X' % op)


def fmt(r):
    t = TYPES[r['tc']] if r['tc'] < len(TYPES) else '?'
    s = '%s %s' % (opname(r['op']), ', '.join(x or '-' for x in r['ops']))
    return ('%s = %s' % (r['res'], s) if r['res'] else s) + '  :%s' % t


def main():
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('src'); ap.add_argument('func'); ap.add_argument('--pass', dest='p', type=int)
    a = ap.parse_args()
    holder = {}

    def setup(emu): holder['d'] = IRDump(emu, a.func, a.p)
    import tempfile
    tmp = tempfile.mktemp(suffix='.obj')
    ok, out, emu = emucc.compile_c(a.src, tmp, cc.src_flags(a.src), setup=setup)
    if os.path.exists(tmp): os.remove(tmp)
    if not ok: sys.stdout.write(out)
    d = holder['d']
    if not d.dumps: raise SystemExit('%s: no allocation pass for %s' % (a.src, a.func))
    for k, p, blocks in d.dumps:
        print('== %s, allocation pass %d: %d blocks' % (a.func, k, len(blocks)))
        line = 0
        for b in blocks:
            print('B%d%s' % (b['index'], '  loop depth %d' % b['depth'] if b['depth'] else ''))
            for r in b['rows']:
                if r['line']: line = r['line']
                r['cline'] = line
                if r['op'] == 0 and not r['ops'] and not r['res']: continue
                print('  L%-4s %s' % (r['line'] or '.', fmt(r)))
        # conflicts with their definitions and uses
        defs, uses = {}, {}
        for b in blocks:
            for r in b['rows']:
                at = (b['index'], r['cline'], b['depth'])
                if r['res'] and not r['res'].startswith('['): defs.setdefault(r['res'], []).append(at)
                for o in r['ops'] + r['inner']:
                    if o and not o.startswith('['): uses.setdefault(o, []).append(at)
        print('-- conflicts in allocation order (savings, register; defined / used at block:line, * per loop level)')
        for c in p['confs']:
            lab = c['label']; got = regdump.RegDump.__dict__  # noqa
            r = p['result'].get(c['conf'])
            g = '-' if r is None else r if isinstance(r, str) else ('memory' if r == 0 else regdump.regname(r))
            f = lambda l: ' '.join('B%d:L%d%s' % (b_, l_, '*' * d_) for b_, l_, d_ in l[:8]) + (' ...' if len(l) > 8 else '')
            print('  %-10s %6d %-7s def %-24s use %s' % (lab, c['savings'], g, f(defs.get(lab, [])), f(uses.get(lab, []))))


if __name__ == '__main__':
    main()
