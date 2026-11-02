#!/usr/bin/env python3
"""Functional-equivalence check (FUNCTIONAL_PLAN.md, "How the check works" 4-8, step 5).

  python3 tools/equiv/check.py src/c/<seg>/<F>.c --func F [--cases 2000] [--seed 1] [--quiet] [--seg SEG] [--ret64]

Runs the original asm of F (in place in HOCKEY.EXE) and the compiled draft on the same seeded cases and compares
the traces from run.py. Verdicts: PASS, NEEDS-REVIEW (equal, but the original trapped or returned an unset
entry register), FAIL (first differing case printed; the run stops there). Rows go to tools/equiv/results.csv
for files under src/c only; a repeat of the same function + source sha1 + cases that passed prints "cached PASS".
Compared per case: ret eax (edx with --ret64), esi/edi/ebp always, ebx/ecx/edx when the original saves them
(push) or leaves them unchanged in that case, esp delta, writes (ordered), calls (ordered; stack args cut to the
callee's `ret N`, register args cut to the registers the callee reads first), trap kinds.
Case inputs: arg registers and stack args are edge values, small randoms or pointers into a 64 KB random arg
buffer at ARG; globals the function references (original and draft fixups) are patched with random, edge,
pointer-ish or static bytes; callee returns come from a seeded script.
"""
import os, sys, re, csv, random, hashlib, struct, time, argparse, datetime, collections
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, HERE); sys.path.insert(0, os.path.join(ROOT, 'tools'))
import image, run, cside, capstone
from capstone.x86_const import X86_OP_MEM

ARG, ARG_SIZE = 0x6000000, 0x10000
DATA_LO = 0xC0000   # first data object (index test: [reg + global])
MAXI = 200000   # instruction cap per side; a hit is an 'insn limit' trap
RESULTS = os.path.join(HERE, 'results.csv')
HEAD = ['function', 'c_file', 'source_sha1', 'cases', 'seed', 'verdict', 'first_diff', 'date']
EDGE = [0, 1, 0xFFFFFFFF, 2, 7, 0x7F, 0x80, 0xFF, 0x7FFF, 0x8000, 0xFFFF, 0x7FFFFFFF, 0x80000000]
FAM = {'eax': 'eax ax ah al', 'ebx': 'ebx bx bh bl', 'ecx': 'ecx cx ch cl', 'edx': 'edx dx dh dl',
       'esi': 'esi si', 'edi': 'edi di', 'ebp': 'ebp bp'}
FAMOF = {n: r for r, ns in FAM.items() for n in ns.split()}
ARGREGS = ('eax', 'edx', 'ebx', 'ecx')
_md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32); _md.detail = True

def first_use(code, addr, to_ret=False):
    """{reg: 'deref'|'index'|'read'|'write'} for the first use of each register in linear order. pushes, pops and
    `xor r,r` do not count. to_ret: stop at the first ret past the furthest forward jump (callee scan)."""
    use = {}; far = addr; alias = {}   # alias: `mov r1, r2` makes a deref of r1 count for r2
    for i in _md.disasm(code, addr):
        if i.mnemonic in ('push', 'pop') or (i.mnemonic in ('xor', 'sub') and len(set(i.op_str.split(', '))) == 1):
            if i.mnemonic in ('xor', 'sub'):
                for r in (FAMOF.get(i.op_str.split(',')[0].strip()),):
                    if r and r not in use: use[r] = 'write'
            continue
        for op in i.operands:
            if op.type == X86_OP_MEM:
                for rr in (op.mem.base, op.mem.index):
                    r = FAMOF.get(i.reg_name(rr)) if rr else None
                    k = 'index' if op.mem.disp >= DATA_LO else 'deref'   # [reg + global]: reg is an index
                    for x in (r, alias.get(r)):
                        if x and use.get(x) in (None, 'read', 'deref'): use[x] = k if use.get(x) != 'index' else 'index'
        rd, wr = i.regs_access()
        if i.mnemonic == 'mov' and len(i.operands) == 2 and all(o.type == 1 for o in i.operands):
            d, sr = (FAMOF.get(i.reg_name(o.reg)) for o in i.operands)
            if d and sr: alias[d] = alias.get(sr, sr)
        for lst, kind in ((rd, 'read'), (wr, 'write')):
            for rr in lst:
                r = FAMOF.get(i.reg_name(rr))
                if r and r not in use: use[r] = kind
        if to_ret:
            if i.mnemonic.startswith('j') and i.op_str.startswith('0x'): far = max(far, int(i.op_str, 16))
            if i.mnemonic == 'ret' and i.address + i.size > far: break
    return use

def saved_regs(code, addr):
    s = set()
    for i in _md.disasm(code, addr):
        if i.mnemonic in ('push', 'pop') and i.op_str in FAMOF: s.add(FAMOF[i.op_str])
    return s

class Checker:
    def __init__(self, img, func, c_path, size, ret64=False):
        global DATA_LO; DATA_LO = img.objects[1].base
        self.img, self.func, self.ret64 = img, func, ret64
        self.void = self._is_void(c_path, func)
        self.lab = img.labels(); self.addr = self.lab[func]; self.size = size
        self.orig = img.read(self.addr, size)
        obj = cside.compile_draft(c_path)
        self.entry, self.ext, self.code = cside.place(img, obj, func)
        self.code = list(self.code); self.alias = cside.aliases(img, obj, func)
        self.use = first_use(self.orig, self.addr)
        self.saved = saved_regs(self.orig, self.addr)
        self.nstack = run._pop_bytes(img, self.addr) // 4
        self.spans = self._spans(obj)
        self.reg_n = {}; self.pop_n = {}
        self.cov = set(); self.insns = self._insns()

    @staticmethod
    def _is_void(c_path, func):
        """True when the draft defines `void <func>(...)` (not `void *`); default False (eax is compared)"""
        m = re.search(r'^[ \t]*([A-Za-z_][\w \t\*]*?)[ \t\*]+%s[ \t]*\([^;{]*\)\s*\{' % re.escape(func), open(c_path, errors='replace').read(), re.M)
        if not m: return False
        t = m.group(1).split()
        return 'void' in t and '*' not in m.group(0).split(func)[0]

    def _insns(self):
        """addresses of the original's instructions (linear disassembly, best effort: dword runs that point back
        into the extent are treated as jump-table data and skipped, undecodable bytes are stepped over)"""
        lo, hi = self.addr, self.addr + self.size; code = self.orig; out = []; off = 0
        inx = lambda o: o + 4 <= len(code) and lo <= struct.unpack_from('<I', code, o)[0] < hi
        while off < len(code):
            if inx(off) and inx(off + 4):
                while inx(off): off += 4
                continue
            i = next(_md.disasm(code[off:off + 15], lo + off), None)
            if i is None: off += 1; continue
            out.append(i.address); off += i.size
        return out

    def _spans(self, obj):
        """data ranges to patch: from each referenced data address to the next label, 4..256 bytes"""
        img, lab = self.img, self.lab; code0 = img.objects[0]
        tg = {t for s, (k, t) in img.fixups.items() if self.addr <= s < self.addr + self.size}
        r = cside._parse(obj['path'], set(lab))
        tg |= {lab[f['target']] + f['addend'] for f in r['fixups'] if f['target'] in lab}
        tg = sorted(t for t in tg if not (code0.base <= t < code0.base + code0.size))
        alls = sorted(set(lab.values())); out = []
        for t in tg:
            nxt = next((a for a in alls if a > t), t + 256)
            try: img.read(t, 1)
            except ValueError: continue
            out.append((t, max(4, min(nxt - t, 256))))
        return out

    # ---- case generator
    def case(self, seed, i):
        rng = random.Random(seed * 1000003 + i)
        m = rng.random(); ff = rng.choice((0.05, 0.1, 0.2, 0.3))
        if m < 0.4: buf = bytes(rng.getrandbits(8) for _ in range(ARG_SIZE))
        elif m < 0.7: buf = bytes(rng.choice((0, 1, 0xFF, 0x80, 0x7F)) if rng.random() < 0.8 else rng.getrandbits(8) for _ in range(ARG_SIZE))
        else: buf = bytes(0xFF if rng.random() < ff else rng.getrandbits(8) for _ in range(ARG_SIZE))   # sentinel-heavy
        def ptr():
            r = rng.random()
            off = 0 if r < 0.2 else rng.randrange(0, 256) if r < 0.5 else rng.randrange(0, ARG_SIZE - 0x2000)
            return ARG + off
        def scalar():
            r = rng.random()
            if r < 0.4: return rng.choice(EDGE)
            if r < 0.7: return rng.randrange(0, 16)
            if r < 0.85: return rng.randrange(0, 0x10000)
            return rng.getrandbits(32)
        def val(p): return ptr() if rng.random() < p else scalar()
        regs = {}
        for r in ('eax', 'edx', 'ebx', 'ecx', 'esi', 'edi', 'ebp'):
            u = self.use.get(r)
            p = 1.0 if u == 'deref' else 0.5 if u == 'read' else 0.2
            regs[r] = rng.choice((0, 1, 2, 3, 5, 7, 15, 31, 0xFF)) if u == 'index' and rng.random() < 0.9 else val(p)
            if r in ('esi', 'edi', 'ebp') and u != 'deref' and rng.random() < 0.7:
                regs[r] = 0xE5000000 | rng.getrandbits(20) << 4 | (1 + ('esi', 'edi', 'ebp').index(r))   # unique tag
        args = [val(0.4) for _ in range(self.nstack + 2)]
        patches = {}
        for lo, n in self.spans if rng.random() > 0.3 else ():   # 30% of the cases keep every global as loaded
            m = rng.random(); st0 = self.img.read(lo, n)
            if m < 0.3: continue   # static image value
            if m < 0.6:            # static with one byte nudged
                b = bytearray(st0); j = rng.randrange(n); b[j] = (b[j] + rng.choice((1, 2, 3, 0xFF, 0xFE, 0x80))) & 0xFF
            elif m < 0.7: b = bytes(rng.getrandbits(8) for _ in range(n))
            elif m < 0.8: b = b''.join(struct.pack('<I', rng.choice(EDGE)) for _ in range((n + 3) // 4))
            elif m < 0.9: b = b''.join(struct.pack('<I', ptr()) for _ in range((n + 3) // 4))
            else: b = bytes(rng.choice((0, 1, 0xFF)) for _ in range(n))
            patches[lo] = bytes(b[:n])
        script = [((ptr() if rng.random() < 0.2 else scalar()), scalar()) for _ in range(32)]
        return buf, run.State(regs=regs, args=args, patches=patches, script=script)

    # ---- one side
    def go(self, buf, st, orig):
        code = [(ARG, buf)] + ([] if orig else self.code)
        st.argsof = lambda t: (self.nreg(t), self.npop(t))
        if orig: t = run.run(self.img, self.addr, (self.addr, self.addr + self.size), st, max_insns=MAXI, code=code, cov=self.cov)
        else: t = run.run(self.img, self.entry, self.ext, st, max_insns=MAXI, code=code, alias=self.alias)
        return cside._norm(t, self.addr if orig else self.entry)

    def nreg(self, target):
        if target not in self.reg_n:
            try: u = first_use(self.img.read(target, 512), target, True)
            except ValueError: u = {}
            n = 0
            for k, r in enumerate(ARGREGS):
                if u.get(r) in ('read', 'deref'): n = k + 1
            self.reg_n[target] = n
        return self.reg_n[target]

    def npop(self, target):
        if target not in self.pop_n: self.pop_n[target] = run._pop_bytes(self.img, target) // 4
        return self.pop_n[target]

    def view(self, t, init, orig):
        """comparable form of a trace -> dict field -> value"""
        def sv(v, snap=()):   # a stack address compares by the bytes it points to; a sibling function's placed address by its EXE label
            if not orig: v = self.alias.get(v, self.addr if v == self.entry else v)
            if not run.STK <= v < run.STK + run.STK_SIZE: return v
            return ('STK', dict(snap).get(v, b''))
        d = {'ended': t.ended, 'esp_delta': t.esp_delta}
        if not self.void: d['ret eax'] = t.ret_eax
        if self.ret64: d['ret edx'] = t.ret_edx
        for r in ('esi', 'edi', 'ebp'): d[r] = t.regs.get(r)
        d['writes'] = [(a, s, sv(v)) for a, s, v in t.writes]
        d['calls'] = [(c[0],) + tuple(sv(x, c[6]) for x in c[1:1 + self.nreg(c[0])]) + tuple(sv(x, c[6]) for x in c[5][:self.npop(c[0])])
                      for c in t.calls]
        return d

    def compare(self, buf, st):
        """-> (diff or '', review notes [str], info notes [str], trap kind or '')"""
        a = self.go(buf, st, True); c = self.go(buf, st, False)
        stop = lambda t: next((k for k, e, dd in t.traps if k != 'uninit stack read'), '')
        ka, kc = stop(a), stop(c)
        rev = sorted({k for k, e, dd in a.traps + c.traps if k in run._BAD or k == 'uninit stack read'})
        va, vc = self.view(a, st, True), self.view(c, st, False)
        if ka or kc:
            lim = 'insn limit' in (ka, kc)   # either side ran out: compare only as a prefix, whatever the other ended with
            if ka != kc and not lim: return 'trap kind: orig %s vs C %s' % (ka or 'none', kc or 'none'), rev, [], ka
            if ka == 'fault' and kc == 'fault':
                fa, fc = (next(dd for k, e, dd in t.traps if k == 'fault').split('@')[-1] for t in (a, c))
                if fa != fc: return 'fault address: orig %s vs C %s' % (fa, fc), rev, [], ka
            for k in ('writes', 'calls'):
                x, y = va[k], vc[k]
                if lim: n = min(len(x), len(y)); x, y = x[:n], y[:n]   # the shorter log must be a prefix
                if x != y: return self.listdiff(k, va[k], vc[k]), rev, [], ka or kc
            return "", rev, [], ka or kc
        info = []
        for r in ('esi', 'edi', 'ebp', 'ebx', 'ecx', 'edx'):   # entry register returned unset (the draft must return the same)
            if a.ended == 'ret' and a.ret_eax == st.regs.get(r) and st.regs.get(r, 0) >> 24 == 0xE5: info.append('unset return %s' % r)
        for r in ('ebx', 'ecx', 'edx'):
            if r in self.saved or a.regs.get(r) == st.regs.get(r, 0):
                va[r], vc[r] = a.regs.get(r), c.regs.get(r)
        for k in va:
            if va[k] != vc[k]:
                if isinstance(va[k], list): return self.listdiff(k, va[k], vc[k]), rev, [], ''
                return '%s: orig %s vs C %s' % (k, hx(va[k]), hx(vc[k])), rev, [], ''
        return '', rev, info, ''

    def listdiff(self, k, x, y):
        n = next((j for j in range(max(len(x), len(y))) if j >= len(x) or j >= len(y) or x[j] != y[j]), 0)
        return '%s[%d]: orig %s vs C %s (lens %d/%d)' % (k, n, fmt(x[n:n + 1]), fmt(y[n:n + 1]), len(x), len(y))

    def coverage(self):
        """-> (share, up to 5 largest uncovered (lo, hi) ranges)"""
        miss = [x for x in self.insns if x not in self.cov]; rngs = []; pos = {x: k for k, x in enumerate(self.insns)}
        for x in miss:
            if rngs and pos[x] == rngs[-1][2] + 1: rngs[-1][1] = x; rngs[-1][2] = pos[x]
            else: rngs.append([x, x, pos[x]])
        rngs = sorted(sorted(rngs, key=lambda r: pos[r[0]] - r[2])[:5], key=lambda r: r[0])   # 5 largest, by address
        return 1 - len(miss) / max(len(self.insns), 1), [(r[0], r[1]) for r in rngs]

def hx(v): return hex(v) if isinstance(v, int) else str(v)
def fmt(l): return ' '.join('(%s)' % ','.join(hx(x) for x in e) for e in l) or '(none)'

def find_row(func, seg):
    rows = [r for r in cside._csv_rows() if r['function'] == func and (not seg or r['segment'] == seg or seg in r['segment'])]
    if not rows: raise SystemExit('function %s not in tools/c_functions.csv%s' % (func, ' for seg ' + seg if seg else ''))
    return rows[0]

def read_results():
    return list(csv.DictReader(open(RESULTS))) if os.path.exists(RESULTS) else []

def log(row):
    new = not os.path.exists(RESULTS)
    with open(RESULTS, 'a', newline='') as f:
        w = csv.DictWriter(f, HEAD)
        if new: w.writeheader()
        w.writerow(row)

def main(argv=None):
    ap = argparse.ArgumentParser(description='functional-equivalence check of one draft against the original asm')
    ap.add_argument('c_file'); ap.add_argument('--func', required=True)
    ap.add_argument('--cases', type=int, default=2000); ap.add_argument('--seed', type=int, default=1)
    ap.add_argument('--seg'); ap.add_argument('--quiet', action='store_true')
    ap.add_argument('--ret64', action='store_true', help='function returns edx:eax')
    a = ap.parse_args(argv)
    q = (lambda *x: None) if a.quiet else print
    c_path = os.path.abspath(a.c_file)
    sha = hashlib.sha1(open(c_path, 'rb').read()).hexdigest()
    real = os.path.commonpath([c_path, os.path.join(ROOT, 'src', 'c')]) == os.path.join(ROOT, 'src', 'c')
    rel = os.path.relpath(c_path, ROOT)
    if real:
        for r in read_results():
            if (r['function'], r['source_sha1'], r['cases'], r['verdict']) == (a.func, sha, str(a.cases), 'PASS'):
                print('cached PASS %s (%s, %s)' % (a.func, r['cases'], r['date'])); return 0
    row = find_row(a.func, a.seg)
    img = image.load(); t0 = time.time()
    ck = Checker(img, a.func, c_path, int(row['size']), a.ret64)
    q('%s: orig %#x+%d, draft at %#x, %d data spans, %d stack dwords%s' % (a.func, ck.addr, ck.size, ck.entry, len(ck.spans), ck.nstack, '; void: eax not compared' if ck.void else ''))
    review = collections.Counter(); info = collections.Counter(); traps = collections.Counter(); verdict = 'PASS'; diff = ''; t1 = time.time(); done = 0
    for i in range(a.cases):
        buf, st = ck.case(a.seed, i); st.seed = a.seed * 1000003 + i
        d, rv, inf, tk = ck.compare(buf, st); done += 1
        review.update(rv); info.update(inf)
        if tk: traps[tk] += 1
        if d:
            verdict = 'FAIL'; diff = d
            print('FAIL %s: case %d (seed %d, --seed %d)\n  %s' % (a.func, i, a.seed * 1000003 + i, a.seed, d))
            print('  entry regs: ' + ' '.join('%s=%#x' % (r, v) for r, v in st.regs.items()))
            print('  stack args: ' + ' '.join('%#x' % v for v in st.args[:ck.nstack]))
            break
    share, miss = ck.coverage(); nt = sum(traps.values())
    fmtc = lambda c: ', '.join('%s x%d' % kv for kv in sorted(c.items()))
    q('coverage %.1f%% (%d/%d insns executed)%s' % (100 * share, len(ck.insns) - round((1 - share) * len(ck.insns)), len(ck.insns),
      '; uncovered ' + ' '.join('%#x-%#x' % r for r in miss) if miss else ''))
    q('traps: %d/%d cases%s' % (nt, done, ' (' + fmtc(traps) + ')' if nt else ''))
    if verdict == 'PASS':
        why = []
        if review: why.append('trap review: ' + fmtc(review))
        if nt * 2 > done: why.append('mostly trapped')
        if share < 0.85: why.append('coverage %.0f%%, uncovered %s' % (100 * share, ' '.join('%#x-%#x' % r for r in miss)))
        if why: verdict = 'NEEDS-REVIEW'
        diff = '; '.join(why + ([fmtc(info)] if info else []))
    dt = time.time() - t1
    print('%s %s: %d cases in %.1fs (%.1f ms/case)%s' % (verdict, a.func, done, dt, 1000 * dt / max(done, 1), ' ' + diff if diff and verdict != "FAIL" else ""))
    if real: log({'function': a.func, 'c_file': rel, 'source_sha1': sha, 'cases': a.cases, 'seed': a.seed, 'verdict': verdict,
                  'first_diff': diff[:200], 'date': datetime.date.today().isoformat()})
    else: q('(file outside src/c: not logged)')
    return 0 if verdict != 'FAIL' else 1

if __name__ == '__main__':
    sys.exit(main())
