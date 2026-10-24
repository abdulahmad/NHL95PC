#!/usr/bin/env python3
"""regsolve.py - rank source edits by how close they come to the EXE's registers.

  python3 tools/wccre/regsolve.py src/c/<seg>/<File>.c FUNC
  python3 tools/wccre/regsolve.py --validate [--limit N]

For one draft it compiles the file in the emulator and reads the register allocator the way
regdump.py does, plus the conflict list before SortList (+64FC3) when the comparator is
ConfBefore (+56A48). GA's order is use-count savings, weighted by loop depth (a block's weight
at +4F998: depth 0 counts 1, one loop x10, two loops x100), with ties broken by the unstable
Shell sort (docs/WCC_INTERNALS.md). This replays that sort and checks the replay against the
compiler's sorted list.

It then ranks three kinds of edit by how many named variables would land on the register the
EXE uses (majority vote over aligned instructions that differ only in registers):

  * swapping two declarations that tie, which is the only declaration-order change that can
    move a register pick
  * a savings bump of +1, +10 or +100 on a variable that picks too late (one more reference
    at loop depth 0, 1 or 2)
  * dropping one temporary that sits in a tie

The bump and the dropped temporary are predictions. A bump is usually a dead-variable reuse or
an extra use, which AGENTS.md escalates rather than marks, so this tool does not emit that
source. A declaration swap is rewritten with declsearch.rewrite and compiled with cc.py, one
file per DOSBox run. A score is claimed only when that compile's permute.py score dropped.
Nothing is written back and nothing is marked.

--validate runs the register-cause drafts whose ranked score is 15 or less. It prints each
function's owner and does not edit those C files.

Validation on 2026-10-24, all 20 of those drafts: the Shell-sort replay matched the compiler's
sorted list every time. No declaration swap that the replay ranked above the current order
improved a permute.py score. The swaps it would have compiled had already been tried under GA
(ReassignCtlPlayer dx/pl, changeplayer dx/dy and dx/d, ExportTeamToFloppy ext2/ext, PlayMVI x/y)
and were skipped. Savings bumps are printed as predictions and are not compiled: making one is
usually a dead-variable reuse, which is escalated rather than marked.
"""
import argparse, collections, os, re, sys, tempfile
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, HERE); sys.path.insert(0, os.path.join(ROOT, 'tools'))
import regdump, slotdump, declsearch, emucc, cc, cdiff, permute, classify_diff
from unicorn import UC_HOOK_CODE
from unicorn import x86_const as X

B = regdump.B
CONF_BEFORE = 0x56A48
SORT_LIST = 0x64FC3
BUMPS = (1, 10, 100)   # +4F998 at loop depth 0, 1 and 2


def conf_before(a, b):
    """ConfBefore (+56A48): unsigned savings, higher first."""
    return (a['savings'] & 0xFFFFFFFF) > (b['savings'] & 0xFFFFFFFF)


WIDTH = {}
for _full, _parts in (
        ('EAX', ('EAX', 'AX', 'AL', 'AH')),
        ('EBX', ('EBX', 'BX', 'BL', 'BH')),
        ('ECX', ('ECX', 'CX', 'CL', 'CH')),
        ('EDX', ('EDX', 'DX', 'DL', 'DH')),
        ('ESI', ('ESI', 'SI')),
        ('EDI', ('EDI', 'DI')),
        ('EBP', ('EBP', 'BP'))):
    for _p in _parts:
        WIDTH[_p] = _full


def same_family(a, b):
    """EAX and AX are the same register. A width difference is not a different assignment."""
    if not a or not b:
        return False
    return WIDTH.get(a, a) == WIDTH.get(b, b)


def reg_aliases(name):
    u = name.upper()
    out = {u}
    if len(u) == 3 and u[0] == 'E':
        out.add(u[1:])
    return out


class Capture(regdump.RegDump):
    """regdump's passes, plus the pre-sort conflict list of each ConfBefore sort."""

    def __init__(self, emu):
        self.pending = None
        regdump.RegDump.__init__(self, emu)
        self.uc.hook_add(UC_HOOK_CODE, self.on_conf_sort, begin=B + SORT_LIST, end=B + SORT_LIST)

    def proc_name(self):
        try:
            return self.sym_name(self.u16(self.u32(self.u32(B + 0x7E764) + 0x80) + 8))
        except Exception:
            return None

    def on_conf_sort(self, uc, addr, size, _):
        if self.emu.r(X.UC_X86_REG_EBX) - B != CONF_BEFORE:
            return
        conf, items, seen = self.emu.r(X.UC_X86_REG_EAX), [], set()
        while conf and conf not in seen and len(items) < 20000:
            seen.add(conf)
            items.append(self.describe(conf))
            conf = self.u32(conf)
        self.pending = dict(func=self.proc_name(), before=items)

    def on_sorted(self, uc, addr, size, _):
        regdump.RegDump.on_sorted(self, uc, addr, size, _)
        if self.pending is not None and self.passes:
            self.passes[-1]['before'] = self.pending['before']
            self.passes[-1]['func'] = self.pending['func']
            self.pending = None


def compile_emu(src):
    holder = {}

    def setup(emu):
        holder['d'] = Capture(emu)

    tmp = tempfile.mktemp(suffix='.obj')
    ok, out, emu = emucc.compile_c(src, tmp, cc.src_flags(src), setup=setup)
    if os.path.exists(tmp):
        os.remove(tmp)
    return ok, out, holder.get('d')


def assigned(p):
    """conflict address -> register name, for conflicts that received a register."""
    out = {}
    for c in p['confs']:
        r = p['result'].get(c['conf'])
        if isinstance(r, int) and r:
            out[c['conf']] = regdump.regname(r)
    return out


def replay_ok(p):
    before = p.get('before')
    if not before:
        return False
    got = [c['conf'] for c in slotdump.shell_sort(before, conf_before)]
    return got == [c['conf'] for c in p['confs']]


def reg_owners(p):
    """register alias -> the one named variable that received it, when there is exactly one."""
    got = assigned(p)
    by = collections.defaultdict(set)
    for c in p['confs']:
        if not c.get('label') or c['label'].startswith('t') and c['label'][1:].isdigit():
            continue
        name = got.get(c['conf'])
        if not name or '+' in name:
            continue
        for a in reg_aliases(name):
            by[a].add(c['label'])
    return {r: next(iter(labs)) for r, labs in by.items() if len(labs) == 1}


def desired_votes(src, obj, func, owners):
    """(variable -> Counter of EXE registers, operand-order diffs).

    A register-classified pair whose two sides use the same registers in a different order is a
    compare or operand flip, not a variable in the wrong register. Those are counted and not voted.
    """
    c = cdiff.compare(src, obj, func)
    C, O = c['ctexts'], c['otexts']
    sm = __import__('difflib').SequenceMatcher(None, [classify_diff.key(x) for x in C],
                                               [classify_diff.key(x) for x in O], autojunk=False)
    votes = collections.defaultdict(collections.Counter)
    n_flip = 0
    for tag, i1, i2, j1, j2 in sm.get_opcodes():
        n = min(i2 - i1, j2 - j1)
        for a, b in zip(C[i1:i1 + n], O[j1:j1 + n]):
            if classify_diff.kind(a, b) != 'register':
                continue
            ia, ib = classify_diff.base(a)[0], classify_diff.base(b)[0]
            ra = [x.upper() for x in re.findall(classify_diff.REG, ia)]
            rb = [x.upper() for x in re.findall(classify_diff.REG, ib)]
            if sorted(ra) == sorted(rb):
                if ra != rb:
                    n_flip += 1
                continue
            for x, y in zip(ra, rb):
                var = owners.get(x)
                if var and x != y and not same_family(x, y):
                    votes[var][y] += 1
    return votes, n_flip


def want_reg(votes):
    out = {}
    for var, cnt in votes.items():
        reg, n = cnt.most_common(1)[0]
        out[var] = reg
    return out


def current_hit(p, want):
    got = assigned(p)
    by_lab = {}
    for c in p['confs']:
        if c.get('label') in want and c['conf'] in got:
            by_lab[c['label']] = got[c['conf']]
    return sum(1 for v, r in want.items() if same_family(by_lab.get(v), r)), by_lab


def movable_blocks(text, func):
    params, blocks = declsearch.parse(text, func)
    return [dict(units=[(a, b) for a, b, n in decls], names=[n for a, b, n in decls])
            for _, decls in blocks if len(decls) >= 2]


def swap_source(text, func, name_a, name_b):
    """declaration swap of two movable locals in one block, or None."""
    blocks = movable_blocks(text, func)
    hit = None
    for b in blocks:
        if name_a in b['names'] and name_b in b['names']:
            hit = b
            break
    if hit is None:
        return None

    class Model(object):
        pass
    m = Model()
    m.blocks = blocks
    order = []
    for b in blocks:
        names = list(b['names'])
        if b is hit:
            i, j = names.index(name_a), names.index(name_b)
            names[i], names[j] = names[j], names[i]
        order.append(tuple(names))
    return declsearch.rewrite(text, m, order)


def score_text(text, func, src):
    """permute.py score of text compiled on its own. None when the compile fails."""
    fd, path = tempfile.mkstemp(suffix='.c')
    os.close(fd)
    obj = path[:-2] + '.obj'
    try:
        open(path, 'w').write(text)
        if not cc.compile_c(path, obj):
            return None
        return permute.score(path, obj, func, src)
    finally:
        for p in (path, obj):
            if os.path.exists(p):
                os.remove(p)


def tried_decl(func, a, b):
    """True when a GA history row or the UNSURE entry already names both locals and a declaration swap."""
    blob = []
    hist = os.path.join(ROOT, 'docs/draft_history.csv')
    if os.path.exists(hist):
        import csv
        for r in csv.DictReader(open(hist, newline='')):
            if r['function'] == func and (r.get('compiler') or 'GA') == 'GA':
                blob.append(r.get('shapes_tried') or '')
    uns = os.path.join(ROOT, 'docs/UNSURE.md')
    if os.path.exists(uns):
        text = open(uns, errors='replace').read()
        for part in text.split('\n* '):
            if part.startswith(func + ' ') or part.startswith(func + '(') or part.startswith(func + ':'):
                blob.append(part)
    hay = '\n'.join(blob).lower()
    if a.lower() not in hay or b.lower() not in hay:
        return False
    return 'decl' in hay or 'swap' in hay


def rank_function(src, func, compile_swaps=True, max_swaps=4):
    ok, out, cap = compile_emu(src)
    if not ok or cap is None:
        return dict(func=func, src=src, error='emulator compile failed', detail=out[-400:])
    passes = [p for p in cap.passes if p.get('func') == func and p.get('before')]
    if not passes:
        passes = [p for p in cap.passes if p.get('before')]
    if not passes:
        return dict(func=func, src=src, error='no ConfBefore sort captured')
    # a later pass can be two temporaries; the pass that names the locals is the allocation
    def named_n(p):
        return sum(1 for c in p['confs']
                   if c.get('label') and not (c['label'].startswith('t') and c['label'][1:].isdigit()))
    p = max(passes, key=named_n)
    checked = replay_ok(p)
    owners = reg_owners(p)
    fd, obj = tempfile.mkstemp(suffix='.obj')
    os.close(fd)
    try:
        if not cc.compile_c(src, obj):
            return dict(func=func, src=src, error='cc.py compile failed', replay=checked)
        base = permute.score(src, obj, func, src)
        votes, n_flip = desired_votes(src, obj, func, owners)
    finally:
        if os.path.exists(obj):
            os.remove(obj)
    want = want_reg(votes)
    now_hit, now_pred = current_hit(p, want)
    got = assigned(p)
    order = slotdump.shell_sort(p['before'], conf_before)
    text = open(src).read()
    named = []
    for c in p['before']:
        lab = c.get('label')
        if lab and not (lab.startswith('t') and lab[1:].isdigit()) and lab not in named:
            named.append(lab)
    ideas = []
    # declaration swaps: pairs of named locals that tie
    by_save = collections.defaultdict(list)
    for c in p['before']:
        lab = c.get('label')
        if lab and lab in named:
            by_save[(c['savings'] & 0xFFFFFFFF, lab)].append(c)  # unique later
    groups = collections.defaultdict(list)
    seen_lab = set()
    for c in p['before']:
        lab = c.get('label')
        if not lab or lab not in named or lab in seen_lab:
            continue
        seen_lab.add(lab)
        groups[c['savings'] & 0xFFFFFFFF].append(lab)
    for sav, labs in groups.items():
        if len(labs) < 2:
            continue
        for i in range(len(labs)):
            for j in range(i + 1, len(labs)):
                a, b = labs[i], labs[j]
                before = [dict(c) for c in p['before']]
                ia = next(k for k, c in enumerate(before) if c.get('label') == a)
                ib = next(k for k, c in enumerate(before) if c.get('label') == b)
                before[ia], before[ib] = before[ib], before[ia]
                new_order = slotdump.shell_sort(before, conf_before)

                def pos(seq, lab):
                    return next(i for i, c in enumerate(seq) if c.get('label') == lab)
                if pos(new_order, a) == pos(order, a):
                    continue
                # the two exchange the registers they have now; the compile checks it
                pred = dict(now_pred)
                pred[a] = got.get(next(c['conf'] for c in order if c.get('label') == b), 'memory')
                pred[b] = got.get(next(c['conf'] for c in order if c.get('label') == a), 'memory')
                hit = sum(1 for v, r in want.items() if same_family(pred.get(v), r))
                if hit <= now_hit:
                    continue
                ideas.append(dict(kind='decl', names=(a, b), hit=hit, pred=pred,
                                   skipped=tried_decl(func, a, b)))
    # savings bumps that pull a variable ahead of the one holding its desired register
    holder = {}
    for c in p['confs']:
        name = got.get(c['conf'])
        if name and c.get('label'):
            holder.setdefault(name, c['label'])
    for var, reg in want.items():
        if same_family(now_pred.get(var), reg):
            continue
        who = holder.get(reg)
        if not who or who == var:
            continue
        sv = next((c['savings'] & 0xFFFFFFFF) for c in p['before'] if c.get('label') == var)
        sw = next((c['savings'] & 0xFFFFFFFF) for c in p['before'] if c.get('label') == who)
        for bump in BUMPS:
            if (sv + bump) & 0xFFFFFFFF <= sw:
                continue
            before = [dict(c) for c in p['before']]
            for c in before:
                if c.get('label') == var:
                    c['savings'] = (c['savings'] + bump) & 0xFFFFFFFF
            new_order = slotdump.shell_sort(before, conf_before)

            def pos(seq, lab):
                return next((i for i, c in enumerate(seq) if c.get('label') == lab), None)
            if pos(new_order, var) is None or pos(new_order, who) is None:
                break
            if pos(new_order, var) >= pos(new_order, who):
                continue
            # passing the conflict that holds the register: predict the two exchange it
            pred = dict(now_pred)
            pred[var] = reg
            if who in want:
                pred[who] = now_pred.get(var, 'memory')
            hit = sum(1 for v, r in want.items() if same_family(pred.get(v), r))
            if hit > now_hit:
                ideas.append(dict(kind='savings', names=(var, who), bump=bump, hit=hit, pred=pred))
            break
    # drop one temporary that shares a savings value with a mismatched named variable
    temps = [c for c in p['before'] if c.get('label', '').startswith('t') and c['label'][1:].isdigit()]
    seen_t = set()
    for t in temps:
        if t['label'] in seen_t:
            continue
        seen_t.add(t['label'])
        if not any(c.get('label') in want and (c['savings'] & 0xFFFFFFFF) == (t['savings'] & 0xFFFFFFFF)
                   for c in p['before']):
            continue
        before = [c for c in p['before'] if c is not t and c.get('label') != t['label']]
        # keep other conflicts; drop every entry of this temporary id
        before = [c for c in p['before'] if c.get('label') != t['label']]
        new_order = slotdump.shell_sort(before, conf_before)
        # position-sticky against the old list is not the same length; score by re-sorting the
        # named conflicts' relative order only and giving each the register of its new rank
        # among the old named-or-temp order is unreliable across a length change. Rank by whether
        # the named variables' relative order moved toward the desired pick order.
        old_named = [c['label'] for c in order if c.get('label') in want]
        new_named = [c['label'] for c in new_order if c.get('label') in want]
        if new_named == old_named:
            continue
        ideas.append(dict(kind='temp', names=(t['label'],), hit=None, order=new_named))
    ideas.sort(key=lambda d: (-(d['hit'] if d['hit'] is not None else -1), d['kind'] != 'decl'))
    confirmed = []
    if compile_swaps:
        queued = [d for d in ideas if d['kind'] == 'decl' and not d['skipped'] and d['hit'] > now_hit]
        for d in queued[:max_swaps]:
            src_text = swap_source(text, func, d['names'][0], d['names'][1])
            if src_text is None:
                d['compile'] = 'not a movable declaration'
                continue
            sc = score_text(src_text, func, src)
            d['compile'] = sc
            if sc is not None and (sc[0], sc[1]) < (base[0], base[1]):
                confirmed.append(dict(names=d['names'], before=base, after=sc, hit=d['hit']))
    return dict(func=func, src=src, replay=checked, pass_func=p.get('func'),
                nconf=len(p['confs']), want=want, now_hit=now_hit, now_pred=now_pred,
                base=base, ideas=ideas, confirmed=confirmed, votes=votes, n_flip=n_flip)


def lane_of(segment):
    n = int(segment[:3])
    if n <= 37:
        return 1, 'Mhopkinsinc', 'Mark'
    return 2, 'StaticEck2026', 'StaticEck'


def owners_by_func():
    import csv
    out = {}
    for r in csv.DictReader(open(os.path.join(ROOT, 'tools/c_functions.csv'), newline='')):
        out.setdefault(r['function'], []).append(r)
    return out


def validate_targets(limit):
    """register-cause drafts with a ranked score of 15 or less: (score, func, path)."""
    cause = {}
    import csv
    for r in csv.DictReader(open(os.path.join(ROOT, 'tools/c_functions.csv'), newline='')):
        if r['status'] == 'nonmatching' and (r.get('cause') or '').startswith('register'):
            cause[(r['function'], r['c_file'])] = r
    rows = []
    for ln in open(os.path.join(ROOT, 'docs/ranked_drafts.txt')):
        parts = ln.split()
        if len(parts) < 4:
            continue
        score = int(parts[0])
        if score > 15:
            continue
        key = (parts[2], parts[3])
        if key in cause:
            rows.append((score, parts[2], parts[3]))
    rows.sort()
    return rows[:limit] if limit else rows


def format_report(rep, owner=None):
    lines = []
    who = ''
    if owner:
        lane, login, name = owner
        who = '  owner %s (%s, lane %d)' % (login, name, lane)
    if rep.get('error'):
        lines.append('%s  %s%s' % (rep['func'], rep['error'], who))
        return '\n'.join(lines)
    b = rep['base']
    lines.append('%s  %s%s' % (rep['func'], os.path.relpath(rep['src'], ROOT), who))
    lines.append('  score %d sizediff %d   shell-sort replay %s   named register votes %d/%d'
                 % (b[0], b[1], 'ok' if rep['replay'] else 'MISMATCH', rep['now_hit'], len(rep['want'])))
    if rep.get('n_flip'):
        lines.append('  %d aligned diff(s) use the same registers in a different order '
                     '(a compare or operand flip, not a savings-order miss)' % rep['n_flip'])
    if rep['want']:
        bits = []
        for v, r in sorted(rep['want'].items()):
            got = rep['now_pred'].get(v, '-')
            mark = '' if got == r else ' (has %s)' % got
            bits.append('%s->%s%s' % (v, r, mark))
        lines.append('  desired: ' + ', '.join(bits))
    shown = 0
    for d in rep['ideas']:
        if shown >= 8:
            break
        shown += 1
        if d['kind'] == 'decl':
            if d.get('skipped'):
                tail = 'skipped, already tried under GA'
            elif isinstance(d.get('compile'), tuple):
                tail = 'compiled %d -> %d' % (rep['base'][0], d['compile'][0])
            elif d.get('compile') is None and 'compile' in d:
                tail = 'compile failed'
            else:
                tail = d.get('compile') or 'not compiled'
            lines.append('  decl %s / %s   predicted %s/%d   %s' % (
                d['names'][0], d['names'][1], d['hit'], len(rep['want']), tail))
        elif d['kind'] == 'savings':
            lines.append('  savings %s +%d ahead of %s   predicted %s/%d   not compiled '
                         '(a savings edit is usually dead-variable reuse; ESCALATE, do not mark)' % (
                             d['names'][0], d['bump'], d['names'][1], d['hit'], len(rep['want'])))
        else:
            lines.append('  drop temporary %s   named order would change   not compiled' % d['names'][0])
    if not rep['ideas']:
        lines.append('  no tie swap, savings bump or temporary drop predicts a better register order')
    if rep['confirmed']:
        for c in rep['confirmed']:
            lines.append('  IMPROVED by compiling decl %s / %s: %d -> %d' % (
                c['names'][0], c['names'][1], c['before'][0], c['after'][0]))
    else:
        lines.append('  no compiled declaration swap improved the score')
    return '\n'.join(lines)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('src', nargs='?')
    ap.add_argument('func', nargs='?')
    ap.add_argument('--validate', action='store_true')
    ap.add_argument('--limit', type=int, default=0)
    ap.add_argument('--max-swaps', type=int, default=4)
    a = ap.parse_args()
    os.chdir(ROOT)
    if a.validate:
        targets = validate_targets(a.limit)
        info = owners_by_func()
        improved = []
        for score, func, path in targets:
            print('--- %s (%d) ---' % (func, score), flush=True)
            rep = rank_function(path, func, max_swaps=a.max_swaps)
            rows = info.get(func, [{}])
            seg = rows[0].get('segment', path)
            owner = lane_of(seg) if rows[0].get('segment') else None
            print(format_report(rep, owner), flush=True)
            print(flush=True)
            for c in rep.get('confirmed') or []:
                improved.append((func, owner, c))
        print('validated %d register drafts with score <= 15' % len(targets))
        if not improved:
            print('no compiled declaration swap improved a score')
        for func, owner, c in improved:
            login = owner[1] if owner else '?'
            print('IMPROVED %s (%s) decl %s/%s %d -> %d' % (
                func, login, c['names'][0], c['names'][1], c['before'][0], c['after'][0]))
        return
    if not a.src or not a.func:
        ap.error('give FILE.c FUNC, or --validate')
    rep = rank_function(a.src, a.func, max_swaps=a.max_swaps)
    print(format_report(rep))


if __name__ == '__main__':
    main()
