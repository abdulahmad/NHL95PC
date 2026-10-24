#!/usr/bin/env python3
"""declsearch.py - search the declaration order of a function's locals for the EXE's stack slots.

  python3 tools/wccre/declsearch.py src/c/<seg>/<File>.c FUNC [--iters N] [--restarts N] [--seed N]
                                    [--keep NAME,...] [--conflicts] [--all] [--confirm N] [--write]

Names without a register conflict (arrays, structures, address-taken scalars) leave the use-count sort by id, and
the ids of a block's locals follow its declaration order (the first declared gets the highest); names with a
conflict leave it by use count, and only equal counts keep an order that depends on where the declarations put
them in the sort's input. The size sort and the hand-out then fix the slots (docs/WCC_INTERNALS.md "Stack
slots"). All three sorts are one unstable Shell sort, so where every entry sits in the input matters, and the
slots of the names in memory are a function of the declaration order that slotdump's Python copy of the sorts
computes without compiling.

1. Compiles the file in the emulator (slotdump.compile_dump): the sorts' lists and every name's slot. The movable
   declarations (one name and no initializer, or a structure defined in place, at the top of a block) are those
   of the names in memory without a conflict; --conflicts adds the names in memory with one (spilled scalars:
   only their ties move, and a move can change registers), --all every declaration. A reorder keeps the
   declaration places of a block and permutes the movable names among them: the k-th place keeps its entry's
   position in the use-count sort's input and its id, and the name it now declares takes both (the name's other
   entries, e.g. the 2-byte part of an int passed as a short, keep their positions and take its new id).
2. Reads the EXE's slot of each local from a -d1 compile aligned with the EXE (slot_solver's line numbers,
   classify_diff's alignment): each aligned pair of instructions with a stack operand, on a source line that
   names the local, whose compiled operand falls in the local's compiled slot, votes for its EXE slot (EXE operand
   - compiled operand + the compiled location; the EXE's own sub esp corrects an esp frame of another size); the
   most common vote wins.
3. Searches: hill climbing on (locals in their EXE slot, total slot distance) with moves and swaps of the movable
   names (--keep names are never picked, so they keep their relative order), from the current order and from
   --restarts random ones; every order of the movable names when there are at most 5040. Once every slot is the
   EXE's, the climb walks on among orders that keep them. The slots of an order come from an integer copy of
   slotdump.resort (checked against it first) and a copy of the hand-out: from the top of the frame down,
   4-byte aligned, a variable's parts in its slot, a parameter homed by a push outside it, a name that shared a
   slot in the compile sharing it again (checked against the compile of the current order).
4. Confirms the --confirm best orders, one per order of the conflict names out of the use-count sorts (a
   register allocation runs between two such sorts, so equal slots can still come with other registers), each
   tidied (neighbours swapped back toward the current order while the slots hold): an emulator compile (the
   slots the compiler gives, and whether the model predicted them) and a fresh cc.py compile, scored as
   permute.py scores (differing instructions, size difference) and as classify_diff counts (differing, of them
   stack slots). --write writes the best confirmed order back when its permute.py score beats the current
   file's.

LeagueTeamSelect (the order before c00cdf94) 102 -> 53 differing with all 32 slots read the EXE's, TradeScreenLoop
(before 5ce4cc44) 183 -> 88 (by classify_diff 148 -> 51, no stack slot left), TeamRosterScreen (--conflicts)
23 -> MATCH; ExecuteTrade: no order of traded, s, kb gives their EXE slots (kb and traded differ in use count)."""
import argparse, collections, difflib, itertools, math, os, random, re, sys, tempfile, shutil
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, HERE); sys.path.insert(0, os.path.join(ROOT, 'tools'))
import slotdump as sd
import cc, cdiff, cobj, permute, classify_diff, slot_solver

DECL_NAME = re.compile(r'([A-Za-z_]\w*)\s*(?:\[[^\]]*\]\s*)*;')
SUB_ESP = re.compile(r'^sub esp, (0x[0-9a-f]+|\d+)')
NOLOC = sd.NO_LOCATION


# --- the source -------------------------------------------------------------------------------------------------

def parse(text, func):
    """(params, [(block's brace line, [(first line, last line, name)])]): FUNC's parameters and the declarations
    at the top of each block of its body that can move: one name, no initializer, or a structure defined in place
    (`struct {` ... `} name;`)"""
    lines = text.split('\n'); b0, b1 = permute.body(lines, func)
    k = b0
    while not re.match(r'^[A-Za-z_].*\b%s\s*\(' % re.escape(func), lines[k]): k -= 1
    sig = ' '.join(permute.strip(l) for l in lines[k:b0])
    sig = sig[sig.index('(', sig.index(func)) + 1:sig.rindex(')')]
    params = set(m.group(1) for m in (re.search(r'([A-Za-z_]\w*)\s*(?:\[[^\]]*\]\s*)*$', p.strip())
                                      for p in sig.split(',')) if m)
    blocks, stack, comment = collections.OrderedDict(), [], False   # stack: [brace line, in its declarations, code]
    k = b0 - 1
    while k < b1:
        k += 1
        s = lines[k]
        if comment:
            if '*/' not in s: continue
            s, comment = s[s.index('*/') + 2:], False
        s = permute.strip(s)
        if '/*' in s: s, comment = s[:s.index('/*')], True
        t = s.strip()
        if not t or t.startswith('#'): continue
        if stack and stack[-1][1]:
            if permute.is_decl(s):
                if '=' not in t and ',' not in t and not re.match(r'(static|extern|typedef)\b', t):
                    blocks.setdefault(stack[-1][0], []).append((k, k, DECL_NAME.search(t).group(1)))
                continue
            if re.match(r'(struct|union)\s*(\w+\s*)?\{$', t):
                j, depth = k, 0
                while j <= b1:
                    depth += permute.strip(lines[j]).count('{') - permute.strip(lines[j]).count('}')
                    if depth == 0: break
                    j += 1
                m = re.match(r'\s*\}\s*([A-Za-z_]\w*)\s*(?:\[[^\]]*\]\s*)*;\s*$', permute.strip(lines[j]))
                if m:
                    blocks.setdefault(stack[-1][0], []).append((k, j, m.group(1))); k = j
                    continue
            stack[-1][1] = False
        code = not re.search(r'\b(struct|union|enum)\b|=', t)
        for ch in t:
            if ch == '{':
                c = code and (not stack or stack[-1][2])
                stack.append([k, c, c])
            elif ch == '}' and stack:
                stack.pop()
    return params, list(blocks.items())


def rewrite(text, model, order):
    """the text with each block's movable declarations in `order` (the other lines in place)"""
    L = text.split('\n')
    unit = dict((nm, L[u[0]:u[1] + 1]) for b in model.blocks for u, nm in zip(b['units'], b['names']))
    for b, o in sorted(zip(model.blocks, order), key=lambda x: -x[0]['units'][0][0]):
        us = b['units']; out = []
        for k, (u, nm) in enumerate(zip(us, o)):
            out += unit[nm]
            if k + 1 < len(us): out += L[u[1] + 1:us[k + 1][0]]
        L[us[0][0]:us[-1][1] + 1] = out
    return '\n'.join(L)


def shell_lt(arr, K):
    """slotdump.shell_sort with before(a, b) = K[a] < K[b]"""
    n = len(arr); gap, adjust = n, 1
    while True:
        adjust ^= 1
        gap = (gap >> 1) + adjust
        while True:
            swapped = False
            for p in range(n - gap):
                a, b = arr[p], arr[p + gap]
                if K[b] < K[a]:
                    arr[p], arr[p + gap] = b, a; swapped = True
            if not swapped: break
        if gap == 1: return arr


def shell_temp(arr, K, ids, offs):
    """slotdump.shell_sort with TempAllocBefore: K = (not f2, size), then the same id by offset descending"""
    n = len(arr); gap, adjust = n, 1
    while True:
        adjust ^= 1
        gap = (gap >> 1) + adjust
        while True:
            swapped = False
            for p in range(n - gap):
                a, b = arr[p], arr[p + gap]
                kb, ka = K[b], K[a]
                if kb < ka or (kb == ka and ids[a] == ids[b] and offs[b] > offs[a]):
                    arr[p], arr[p + gap] = b, a; swapped = True
            if not swapped: break
        if gap == 1: return arr


# --- the model ----------------------------------------------------------------------------------------------------

class Model:
    """the slots of the names in memory as a function of the declaration order, from one emulator compile"""

    def __init__(self, f, params, blocks, everything=False, conflicts=False):
        self.f, self.params = f, params
        self.warn = []
        self.orig = [s['before'] for s in f['pres']] + [s['before'] for s in f['sizes']]
        L0 = self.orig[0]
        final = f['final']
        def full(n): return n['named'] and not n['tflags'] & 2
        # the declared locals in memory: label -> (location, size) of the full entry
        declared = collections.Counter(nm for _, d in blocks for _, _, nm in d)
        self.mem = {}
        for n in sd.handout(f, [s['after'] or [] for s in f['sizes']]):
            fin = final.get(n['addr'])
            if (full(n) and fin and fin['loc'] not in (None, NOLOC) and n['label'] not in params
                    and declared[n['label']] == 1):
                self.mem[n['label']] = (fin['loc'], n['size'])
        self.blocks = []
        for brace, decls in blocks:
            mv = []
            for k, j, nm in decls:
                ix = [i for i, n in enumerate(L0) if n['label'] == nm and full(n)]
                if declared[nm] != 1 or nm in params or len(ix) != 1: continue
                if everything or (nm in self.mem and (conflicts or not L0[ix[0]]['conf'])):
                    mv.append(((k, j), nm, ix[0], L0[ix[0]]['id']))
            if len(mv) < 2: continue
            pos, ids = [x[2] for x in mv], [x[3] for x in mv]
            if pos != sorted(pos) or ids != sorted(ids, reverse=True):
                self.warn.append('block at line %d: the use-count input does not list its names in declaration order'
                                 ' with falling ids; the model assumes it does' % (brace + 1))
            self.blocks.append(dict(units=[x[0] for x in mv], names=[x[1] for x in mv], pos=sorted(pos),
                                    ids=sorted(ids, reverse=True), full=dict((x[1], x[2]) for x in mv)))
        self.movable = set(nm for b in self.blocks for nm in b['names'])
        self.rel = [[(i, n['label']) for i, n in enumerate(L) if n['named'] and n['label'] in self.movable]
                    for L in self.orig]
        self.variants = {}
        self.base = tuple(tuple(b['names']) for b in self.blocks)
        self.learn()
        self.build_fast()
        self.probs = self.handout(self.base)[1]

    def lists(self, order):
        newid, place = {}, {}
        for b, o in zip(self.blocks, order):
            for k, nm in enumerate(o):
                newid[nm] = b['ids'][k]; place[b['pos'][k]] = nm
        out = []
        for li, L in enumerate(self.orig):
            L = list(L)
            for i, lab in self.rel[li]:
                key = (li, i, newid[lab])
                v = self.variants.get(key)
                if v is None: v = self.variants[key] = dict(L[i], id=newid[lab])
                L[i] = v
            if li == 0:
                ents = dict((nm, L[b['full'][nm]]) for b in self.blocks for nm in b['names'])
                for p, nm in place.items(): L[p] = ents[nm]
            out.append(L)
        return out

    def handout(self, order):
        """the hand-out order of an order, with slotdump's resort -> ([name], problems)"""
        L = self.lists(order)
        np_ = len(self.f['pres'])
        g = dict(self.f, pres=[dict(s, before=x) for s, x in zip(self.f['pres'], L[:np_])],
                 sizes=[dict(s, before=x) for s, x in zip(self.f['sizes'], L[np_:])])
        pres, sizes, probs = sd.resort(g)
        return sd.handout(g, sizes), probs

    # the same on integer keys (about 10 times faster; checked against handout() before a search)

    def build_fast(self):
        f = self.f
        U = {}
        for L in self.orig + [s['after'] or [] for s in f['pres'] + f['sizes']]:
            for n in L: U.setdefault(n['addr'], len(U))
        self.U, self.byu = U, {}
        for L in self.orig:
            for n in L: self.byu.setdefault(U[n['addr']], n)
        np_ = len(f['pres'])
        self.fl = []    # per list: (u order, keys, ids, offs, relabelled [(u, label)], spliced positions)
        for li, L in enumerate(self.orig):
            us = [U[n['addr']] for n in L]
            if li < np_: K = dict((U[n['addr']], self.ukey(n, n['id'])) for n in L)
            else: K = dict((U[n['addr']], ((0 if n['f2'] else 1) << 40) + n['size']) for n in L)
            ids = dict((U[n['addr']], n['id']) for n in L); offs = dict((U[n['addr']], n['off']) for n in L)
            rel = [(U[n['addr']], n['label'], n) for n in L if n['named'] and n['label'] in self.movable]
            confs = set(U[n['addr']] for n in L if n['conf'])
            self.fl.append(dict(us=us, K=K, ids=ids, offs=offs, rel=rel, confs=confs))
        # the splices resort does: a later sort's input takes the previous sort's names in the simulated order
        self.splices = {}
        prev = None
        for k, s in enumerate(f['pres']):
            if prev is not None: self.splices[k] = self.splice_plan(k, prev)
            prev = s['after']
        if f['sizes'] and prev is not None: self.splices[np_] = self.splice_plan(np_, prev)
        self.full_u = dict((nm, U[self.orig[0][b['full'][nm]]['addr']]) for b in self.blocks for nm in b['names'])

    def splice_plan(self, li, prev_hook):
        ph = [self.U[n['addr']] for n in prev_hook]
        inp = self.fl[li]['us']
        keep = [u for u in inp if u in set(ph)]
        if keep != [u for u in ph if u in set(keep)]: return None     # resort leaves this input as it is
        return ([p for p, u in enumerate(inp) if u in set(ph)], set(keep))

    @staticmethod
    def ukey(n, nid):
        """+57A0B as one integer (a before b <=> key a < key b)"""
        third = -n['count'] if n['conf'] else -nid
        return (n['f1'] << 40) + ((0 if n['conf'] else 1) << 39) + third + (1 << 34)

    def fast_handout(self, order):
        newid, place = {}, {}
        for b, o in zip(self.blocks, order):
            for k, nm in enumerate(o):
                newid[nm] = b['ids'][k]; place[b['pos'][k]] = nm
        np_ = len(self.f['pres'])
        prev, outs, sig = None, [], []
        for li, fl in enumerate(self.fl):
            arr = list(fl['us'])
            if li == 0:
                for p, nm in place.items(): arr[p] = self.full_u[nm]
            plan = self.splices.get(li) if li <= np_ else None
            if plan and prev is not None:
                it = iter([u for u in prev if u in plan[1]])
                for p in plan[0]: arr[p] = next(it)
            if li < np_:
                K = fl['K']
                if fl['rel']:
                    K = dict(K)
                    for u, lab, n in fl['rel']:
                        if not n['conf']: K[u] = self.ukey(n, newid[lab])
                prev = shell_lt(arr, K)
                sig.append(tuple(u for u in prev if u in fl['confs']))
            else:
                ids = fl['ids']
                if fl['rel']:
                    ids = dict(ids)
                    for u, lab, n in fl['rel']: ids[u] = newid[lab]
                prev = shell_temp(arr, fl['K'], ids, fl['offs'])
                outs.append(prev)
        # the names with a conflict in the order the use-count sorts give them: a register allocation can run
        # between two such sorts, so orders with the same slots can still differ in registers when it changes
        self.last_sig = tuple(sig)
        seen, ho = set(), []
        for L in outs:
            for u in L:
                if u not in seen: seen.add(u); ho.append(self.byu[u])
        return ho


    def slotted(self, n):
        """a name the hand-out gives a slot of its own: not a part, not a stack parameter, not a parameter homed by
        a push (its location, set at the prologue, is below the sub esp area)"""
        fin = self.f['final'].get(n['addr'])
        return (fin is not None and fin['loc'] not in (None, NOLOC) and -self.f['sub'] <= fin['loc'] < 0
                and not n['tflags'] & 2)

    def learn(self):
        """the hand-out copy on the compiled order: which names shared a slot, and whether the copy gives every
        slot the compiler gave"""
        self.owner, top, placed = {}, 0, []
        bad = []
        for n in sd.handout(self.f, [s['after'] or [] for s in self.f['sizes']]):
            if not self.slotted(n): continue
            loc, size = self.f['final'][n['addr']]['loc'], n['size']
            nxt = -((-top + size + 3) // 4 * 4)
            if loc == nxt:
                top = loc; placed.append((n['addr'], loc, size))
            elif loc > nxt:     # inside a slot handed out before: shared (ReUsableStack)
                own = next((a for a, l, s in placed if l <= loc < l + s), None)
                if own is None: bad.append(n['label']); top = min(top, loc)
                else: self.owner[n['addr']] = (own, loc - dict((a, l) for a, l, s in placed)[own])
            else:
                bad.append(n['label']); top = loc; placed.append((n['addr'], loc, size))
        self.learn_bad = bad

    def check_fast(self, orders):
        """the orders (of the given ones) on which the integer copy and slotdump's resort hand out differently"""
        return [o for o in orders if sd.addrs(self.handout(o)[0]) != sd.addrs(self.fast_handout(o))]

    def locations(self, order, slow=False):
        """{label: location} of the declared locals in memory, {addr: location} of every slotted name, problems"""
        ho, probs = self.handout(order) if slow else (self.fast_handout(order), self.probs)
        top, at = 0, {}
        for n in ho:
            if not self.slotted(n): continue
            a = n['addr']
            if a in self.owner and self.owner[a][0] in at:
                at[a] = at[self.owner[a][0]] + self.owner[a][1]
            else:
                top = -((-top + n['size'] + 3) // 4 * 4); at[a] = top
        labs = dict((n['label'], at[n['addr']]) for n in ho if n['addr'] in at and n['named'] and n['label'] in self.mem)
        return labs, at, probs


# --- the EXE's slots ----------------------------------------------------------------------------------------------

def exe_locations(src, func, f, mem, text, work):
    """({local: (EXE location, votes for it, all votes)}, compiled bias, frame note) from a -d1 compile of text"""
    tmp = os.path.join(work, 'd1_' + os.path.basename(src)); open(tmp, 'w').write(text)
    obj = tmp[:-2] + '.obj'
    if not cc.compile_c_raw(tmp, obj, cc.src_flags(tmp, '-d1')):
        raise SystemExit('%s: the -d1 compile failed' % src)
    c = cdiff.compare(tmp, obj, func, asm_src=src)
    C, O = c['ctexts'], c['otexts']
    lines = text.split('\n')
    c0 = cobj.parse(obj, None)['pubs'].get(func, 0)
    ln = slot_solver.linnum(obj)
    starts = sorted(set(l for _, l in ln))
    offs = [x[1] for x in c['rows']]
    def names_at(i):
        a, l = c0 + offs[i], None
        for o, x in ln:
            if o <= a: l = x
            else: break
        if l is None: return set()
        nxt = min(next((x for x in starts if x > l), l + 1), l + 8, len(lines) + 1)
        return set().union(*[permute.ids(lines[k - 1]) for k in range(l, nxt)]) & set(mem)
    sm = difflib.SequenceMatcher(None, [classify_diff.key(x) for x in C], [classify_diff.key(x) for x in O],
                                 autojunk=False)
    pairs = []
    for tag, i1, i2, j1, j2 in sm.get_opcodes():
        for i, j in zip(range(i1, i2), range(j1, j2)):
            a, b = slot_solver.slot(C[i]), slot_solver.slot(O[j])
            if a and b and a[0] == b[0]:
                nm = names_at(i)
                if nm: pairs.append((a, b, nm))
    ebp = bool(f.get('prologue') and f['prologue'][0])
    votes = collections.Counter(a[1] - mem[v][0] for a, b, nm in pairs for v in nm if mem[v][1] <= 4)
    bias = votes.most_common(1)[0][0] if ebp and votes else f['frame']
    def sub(T):
        for t in T[:24]:
            m = SUB_ESP.match(t.split('  ; ')[0].strip())
            if m: return int(m.group(1), 0)
    sc, so = sub(C), sub(O)
    d = so - sc if sc is not None and so is not None else 0
    note = ''
    if d: note = 'the EXE subtracts %Xh from esp, the compile %Xh' % (so, sc)
    by = collections.defaultdict(collections.Counter)
    for a, b, nm in pairs:
        rel = a[1] - bias
        for v in nm:
            lo, size = mem[v]
            if lo <= rel < lo + size: by[v][b[1] - a[1]] += 1
    out = {}
    for v, cnt in by.items():
        delta, k = cnt.most_common(1)[0]
        out[v] = (mem[v][0] + delta - (0 if ebp else d), k, sum(cnt.values()))
    return out, bias, note


# --- the search ---------------------------------------------------------------------------------------------------

def search(model, want, keep, iters, restarts, rng, log):
    """({order: (in their EXE slot, -slot distance)} of every order tried, the scoring function, {order: the
    conflict names' order out of the use-count sorts}). Once every slot is the EXE's, the climb goes on over
    orders that keep them all (orders that differ in the conflict names' order), and no other restart runs."""
    pool, sigs = {}, {}
    def ev(o):
        r = pool.get(o)
        if r is None:
            labs = model.locations(o)[0]
            sigs[o] = model.last_sig
            hit = sum(1 for v, w in want.items() if labs.get(v) == w)
            r = pool[o] = (hit, -sum(abs(labs.get(v, 0) - w) for v, w in want.items()))
        return r
    free = [[nm for nm in b['names'] if nm not in keep] for b in model.blocks]
    def perms(b, names):
        """the orders of a block that keep the --keep names' relative order"""
        fixed = [nm for nm in names if nm in keep]; mv = [nm for nm in names if nm not in keep]
        for slots in itertools.combinations(range(len(names)), len(mv)):
            for p in itertools.permutations(mv):
                o, it, ip = [], iter(p), iter(fixed)
                for k in range(len(names)): o.append(next(it) if k in slots else next(ip))
                yield tuple(o)
    total = 1
    for b in model.blocks:
        n, m = len(b['names']), len([x for x in b['names'] if x not in keep])
        total *= math.factorial(n) // math.factorial(n - m) if m else 1
    best = ev(model.base); log('current order: %d of %d in their EXE slot (distance %d)' % (best[0], len(want), -best[1]))
    if total <= 5040:
        for o in itertools.product(*[list(perms(b, b['names'])) for b in model.blocks]):
            ev(tuple(o))
        log('every order (%d) tried' % len(pool))
        return pool, ev, sigs
    weights = [len(x) for x in free]
    def mutate(o):
        o = [list(x) for x in o]
        bi = rng.choices(range(len(free)), weights)[0]
        x = rng.choice(free[bi]); B = o[bi]
        if rng.random() < 0.5 and len(free[bi]) > 1:
            y = rng.choice([z for z in free[bi] if z != x])
            i, j = B.index(x), B.index(y); B[i], B[j] = B[j], B[i]
        else:
            B.remove(x); B.insert(rng.randrange(len(B) + 1), x)
        return tuple(tuple(z) for z in o)
    def shuffled(o):
        o = [list(x) for x in o]
        for B, fr in zip(o, free):
            for x in fr: B.remove(x)
            for x in rng.sample(fr, len(fr)): B.insert(rng.randrange(len(B) + 1), x)
        return tuple(tuple(z) for z in o)
    for r in range(restarts + 1):
        o = model.base if r == 0 else shuffled(model.base)
        c = ev(o)
        for it in range(iters):
            o2 = mutate(o); c2 = ev(o2)
            if c2 >= c:
                o, c = o2, c2
                if c2 > best:
                    best = c2
                    log('  restart %d, step %d: %d of %d in their EXE slot (distance %d)' % (r, it, c2[0], len(want), -c2[1]))
        if best[0] == len(want) and best[1] == 0: break
    return pool, ev, sigs


def displacement(model, o):
    return sum(abs(k - b['names'].index(nm)) for b, x in zip(model.blocks, o) for k, nm in enumerate(x))


def tidy(model, o, ev, sigs):
    """o with neighbours swapped back toward the current order while the model score and the conflict names'
    order hold (the moves the climb made that the slots do not need)"""
    ix = [dict((nm, k) for k, nm in enumerate(b['names'])) for b in model.blocks]
    sig = sigs[o]
    o = [list(x) for x in o]; c = ev(tuple(tuple(x) for x in o))
    changed = True
    while changed:
        changed = False
        for bi, B in enumerate(o):
            for i in range(len(B) - 1):
                if ix[bi][B[i]] > ix[bi][B[i + 1]]:
                    B[i], B[i + 1] = B[i + 1], B[i]
                    t = tuple(tuple(x) for x in o); c2 = ev(t)
                    if c2 >= c and sigs[t] == sig: c, changed = c2, True
                    else: B[i], B[i + 1] = B[i + 1], B[i]
    return tuple(tuple(x) for x in o)


# --- confirmation -------------------------------------------------------------------------------------------------

def kinds(cand, obj, func, src):
    """(differing, of them stack slots) by classify_diff's alignment and kinds (the count the C_PROGRESS notes
    give)"""
    c = cdiff.compare(cand, obj, func, asm_src=src)
    C, O = c['ctexts'], c['otexts']
    sm = difflib.SequenceMatcher(None, [classify_diff.key(x) for x in C], [classify_diff.key(x) for x in O],
                                 autojunk=False)
    k = collections.Counter()
    for tag, i1, i2, j1, j2 in sm.get_opcodes():
        n = min(i2 - i1, j2 - j1)
        for x, y in zip(C[i1:i1 + n], O[j1:j1 + n]): k[classify_diff.kind(x, y)] += 1
        k['extra'] += max(i2 - i1, j2 - j1) - n
    return sum(v for x, v in k.items() if x != 'same'), k['stack']


def confirm(src, func, text, work, k):
    """(emulator compile's function or None, permute score + kinds() or None) of a candidate text: the
    emulator compile for the slots, a fresh cc.py compile (alone in its DOSBox run, as make compiles) for the
    score"""
    tmp = os.path.join(work, 'c%d_%s' % (k, os.path.basename(src))); open(tmp, 'w').write(text)
    fs = [g for g in sd.compile_dump(tmp) if g['name'] == func]
    obj = tmp[:-2] + '.obj'
    sc = None
    if cc.compile_c_raw(tmp, obj, cc.src_flags(tmp)):
        sc = permute.score(tmp, obj, func, src) + kinds(tmp, obj, func, src)
    return (fs[0] if fs else None), sc


def compiled_locs(model, g):
    """{label: location} of the declared locals in memory in an emulator compile"""
    out = {}
    for n in sd.handout(g, [s['after'] or [] for s in g['sizes']]):
        fin = g['final'].get(n['addr'])
        if n['named'] and not n['tflags'] & 2 and n['label'] in model.mem and fin and fin['loc'] != NOLOC:
            out.setdefault(n['label'], fin['loc'])
    return out


def fmt(sc):
    return '%d differing, size %+d%s (permute.py); %d differing, %d of them stack slots (classify_diff)' % (
        sc[0], sc[1], ', MATCH' if sc[2] else '', sc[4], sc[5])


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('src'); ap.add_argument('func')
    ap.add_argument('--iters', type=int, default=3000, help='steps per climb (default 3000)')
    ap.add_argument('--restarts', type=int, default=8, help='climbs from random orders (default 8)')
    ap.add_argument('--seed', type=int, default=1)
    ap.add_argument('--keep', default='', help='names never moved (they keep their relative order), comma separated')
    ap.add_argument('--all', action='store_true', help="move the register names' declarations too")
    ap.add_argument('--conflicts', action='store_true',
                    help='move the declarations of names in memory that have a register conflict too')
    ap.add_argument('--confirm', type=int, default=3, help='orders to confirm with real compiles (default 3)')
    ap.add_argument('--write', action='store_true', help='write the best confirmed order when it scores better')
    a = ap.parse_args()
    src = os.path.relpath(os.path.abspath(a.src), ROOT); func = a.func
    os.chdir(ROOT)
    text0 = open(src).read()
    work = tempfile.mkdtemp(prefix='declsearch_')
    try:
        f0, sc0 = confirm(src, func, text0, work, 0)
        if f0 is None: raise SystemExit('%s: no function %s in the emulator compile' % (src, func))
        if sc0 is None: raise SystemExit('%s: does not compile' % src)
        params, blocks = parse(text0, func)
        model = Model(f0, params, blocks, a.all, a.conflicts)
        print('%s %s: %s; %s; %d use-count sort%s' % (
            src, func, fmt(sc0), 'ebp frame' if f0['prologue'] and f0['prologue'][0] else 'esp frame %Xh' %
            f0['frame'], len(f0['pres']), 's' * (len(f0['pres']) != 1)))
        for w in model.warn: print('  warning: ' + w)
        if len(f0['sizes']) > 1:
            print('  warning: %d size sorts (-od: one per block); the Python copy chains only the first' % len(f0['sizes']))
        if model.learn_bad:
            print('  warning: the hand-out copy misses the compiled slot of %s' % ', '.join(model.learn_bad))
        base_labs, base_at, probs = model.locations(model.base)
        same = sum(1 for n, (l, s) in model.mem.items() if base_labs.get(n) == l)
        print('  model on the current order: %d of %d declared locals in their compiled slot%s' % (
            same, len(model.mem), '; ' + '; '.join(probs) if probs else ''))
        for b in model.blocks:
            print('  movable (block at line %d): %s' % (b['units'][0][0] + 1, ', '.join(b['names'])))
        if not model.blocks: raise SystemExit('  nothing to move')
        rng = random.Random(a.seed)
        tries = [model.base] + [tuple(tuple(rng.sample(b['names'], len(b['names']))) for b in model.blocks)
                                for _ in range(4)]
        if model.check_fast(tries):
            raise SystemExit('  the integer copy of the sorts differs from slotdump.resort: fix declsearch first')
        want, bias, note = exe_locations(src, func, f0, model.mem, text0, work)
        if note: print('  note: ' + note)
        count = {}      # the use count of the names with a conflict (first use-count sort)
        for n in (f0['pres'][0]['before'] if f0['pres'] else []):
            if n['named'] and n['conf'] and not n['tflags'] & 2: count.setdefault(n['label'], n['count'])
        print('  local         size  count  compiled  EXE   votes (locations from the top of the locals)')
        for v in sorted(want, key=lambda v: -want[v][0]):
            l, s = model.mem[v]
            print('  %-12s %5d %6s  %8d %5d   %d/%d%s%s' % (v, s, count.get(v, '-'), l, want[v][0], want[v][1],
                                                           want[v][2], '' if v in model.movable else '  (not movable)',
                                                           '  ok' if l == want[v][0] else ''))
        nov = sorted(set(model.mem) - set(want))
        if nov: print('  no EXE slot read for: %s' % ', '.join(nov))
        W = dict((v, w[0]) for v, w in want.items())
        keep = set(x for x in a.keep.split(',') if x)
        pool, ev, sigs = search(model, W, keep, a.iters, a.restarts, rng, print)
        rank = lambda o: (pool[o], -displacement(model, o))
        ranked = sorted(pool, key=rank, reverse=True)
        best = pool[ranked[0]]
        print('  best model score: %d of %d in their EXE slot (distance %d), %d orders tried' % (
            best[0], len(W), -best[1], len(pool)))
        # the best order of each conflict-name order, best first
        cands, seen = [], set()
        for o in ranked:
            if len(cands) == a.confirm: break
            if o == model.base or sigs[o] in seen: continue
            seen.add(sigs[o]); t = tidy(model, o, ev, sigs)
            if t != model.base: cands.append(t)
        cands = sorted(set(cands), key=rank, reverse=True)
        results = []
        for k, o in enumerate(cands):
            text = rewrite(text0, model, o)
            g, sc = confirm(src, func, text, work, k + 1)
            mloc = model.locations(o)[0]
            cl = compiled_locs(model, g) if g else {}
            hit = sum(1 for v, w in W.items() if cl.get(v) == w)
            agree = all(cl.get(v) == mloc.get(v) for v in model.mem)
            print('order %d: %s' % (k + 1, ' | '.join(', '.join(x) for x in o)))
            print('  conflict names out of the use-count sorts: %s' % (
                'as in the current file' if sigs[o] == sigs[model.base] else 'in another order (registers may change)'))
            print('  model %d of %d, compile %d of %d in their EXE slot (the model %s the compile)%s' % (
                pool[o][0], len(W), hit, len(W), 'predicts' if agree else 'MISPREDICTS',
                ''.join('; %s %d (EXE %d)' % (v, cl.get(v, 0), w) for v, w in sorted(W.items()) if cl.get(v) != w)[:400]))
            print('  score %s' % (fmt(sc) if sc else 'does not compile'))
            if sc: results.append(((sc[0], sc[1]), k, text))
        print('current: %s' % fmt(sc0))
        if a.write:
            if results and min(results)[0] < (sc0[0], sc0[1]):
                r = min(results)
                with open(src, 'w', newline='\n') as fh: fh.write(r[2])
                print('written order %d to %s (%d differing, size %+d)' % (r[1] + 1, src, r[0][0], r[0][1]))
            else:
                print('not written: no confirmed order scores better than the current file')
    finally:
        shutil.rmtree(work, ignore_errors=True)


if __name__ == '__main__':
    main()
