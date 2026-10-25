#!/usr/bin/env python3
"""deal_lanes.py - write docs/LANES_CURRENT.md for the current round.

  python3 tools/deal_lanes.py [--history docs/draft_history.csv] [--ranked docs/ranked_drafts.txt]

File ownership stays with the segment lane (001-037 Mhopkinsinc, 038-066 StaticEck2026). A C file is
never split across contributors. A draft whose owner has two consecutive no-gain attempts under GA is
offered, with its whole C file and its history, to the other contributor. A draft with two no-gain
attempts from each contributor, and no newer tool that applies to its cause, goes on the Escalations
list for Abdul (lane T). The result is a pure function of the history, the cause column and the tool
dates, so running it again on the same tree rewrites the same file.

The board (docs/board/*.md, one message per file: From / To / Date / Claims / Releases headers, then the text)
goes at the top: the active claims (a function claimed and not released, until its date) and the newest
messages in full, so every agent sees them when it reads this file before a batch.
"""
import argparse, csv, os, subprocess, sys
from collections import defaultdict
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
OUT = os.path.join(ROOT, 'docs/LANES_CURRENT.md')

# cause word -> tools that can move a draft of that cause. The date is the commit that added the file.
TOOLS = [
    ('tools/wccre/regdump.py', 'register', 'regdump'),
    ('tools/wccre/regsolve.py', 'register', 'regsolve'),
    ('tools/wccre/declsearch.py', 'slot', 'declsearch'),
    ('tools/wccre/slotdump.py', 'slot', 'slotdump'),
]
OWNERS = {1: ('Mhopkinsinc', 'Mark'), 2: ('StaticEck2026', 'StaticEck')}


def lane_of(segment):
    n = int(segment[:3])
    return 1 if n <= 37 else 2


def tool_added(path):
    """ISO time of the commit that added path, or None when the file is not in git yet"""
    if not os.path.exists(os.path.join(ROOT, path)):
        return None
    out = subprocess.check_output(
        ['git', 'log', '--diff-filter=A', '--format=%cI', '--', path], cwd=ROOT, text=True)
    lines = [x for x in out.splitlines() if x]
    return lines[-1] if lines else None


def load_history(path):
    if not os.path.exists(path):
        return []
    return list(csv.DictReader(open(path, newline='')))


def load_ranked(path):
    scores = {}
    if not os.path.exists(path):
        return scores
    for ln in open(path):
        parts = ln.split()
        if len(parts) < 4:
            continue
        scores[(parts[2], parts[3])] = (int(parts[0]), int(parts[1]))
    return scores


def attempted(row):
    """a PR that says the function was not reached did not try a shape"""
    return 'not reached' not in (row.get('shapes_tried') or '').lower()


def no_gain(row):
    before, after = int(row['score_before']), int(row['score_after'])
    return after >= before and after != 0


def by_person(history, func):
    out = defaultdict(list)
    for r in history:
        if r['function'] == func and (r.get('compiler') or 'GA') == 'GA' and attempted(r):
            out[r['contributor']].append(r)
    return out


def streak(rows):
    n = 0
    for r in rows:
        n = n + 1 if no_gain(r) else 0
    return n


def cause_of(text):
    return (text or '').split(' ')[0]


def new_tool(cause, rows, added):
    """a tool for this cause that landed after the last attempt, and that the attempts do not already name"""
    if not rows:
        return None
    last = max(r['date'] for r in rows)
    tried = ' '.join(r.get('shapes_tried') or '' for r in rows).lower()
    for path, applies, name in TOOLS:
        when = added.get(path)
        if applies != cause or not when:
            continue
        if when[:10] <= last:
            continue
        if name.lower() in tried:
            continue
        return name
    return None


def decide(func, owner, history, added, cause):
    """'stay', 'offer' or 'escalate', plus the tool that blocked an escalation"""
    people = by_person(history, func)
    owner_rows = people.get(owner, [])
    other = [r for who, rs in people.items() if who != owner for r in rs]
    other_by = defaultdict(list)
    for r in other:
        other_by[r['contributor']].append(r)
    owner_stuck = streak(owner_rows) >= 2
    others_stuck = [who for who, rs in other_by.items() if streak(rs) >= 2]
    if owner_stuck and others_stuck:
        tool = new_tool(cause, owner_rows + other, added)
        if tool:
            return 'offer', tool
        return 'escalate', None
    if owner_stuck:
        return 'offer', None
    return 'stay', None


def history_lines(func, history):
    lines = []
    for r in history:
        if r['function'] != func:
            continue
        shape = (r.get('shapes_tried') or '').replace('**', '').replace('\n', ' ').strip()
        lines.append('- %s %s->%s (%s, %s, %s) %s' % (
            r['function'], r['score_before'], r['score_after'], r['date'], r['contributor'],
            r.get('compiler') or 'GA', shape))
    return lines or ['- (no GA history rows)']


def file_table(files, ranked):
    lines = ['| C file | Function | Score | Cause |', '|---|---|---:|---|']
    for path, info in files:
        for i, d in enumerate(info['drafts']):
            sc = ranked.get((d['function'], path))
            score = '' if sc is None else str(sc[0])
            show = path if i == 0 else ''
            lines.append('| %s | %s | %s | %s |' % (show, d['function'], score, d['cause']))
    return lines


BOARD = os.path.join(ROOT, 'docs/board')
BOARD_SHOW = 6


def board_messages():
    """[(file name, {header: value}, text)] of docs/board, oldest first (the names start with the UTC date)"""
    out = []
    if not os.path.isdir(BOARD): return out
    for fn in sorted(os.listdir(BOARD)):
        if not fn.endswith('.md') or fn.lower() == 'readme.md': continue
        head, _, body = open(os.path.join(BOARD, fn)).read().partition('\n\n')
        hdr = {}
        for ln in head.split('\n'):
            k, sep, v = ln.partition(':')
            if sep: hdr[k.strip().lower()] = v.strip()
        out.append((fn, hdr, body.strip()))
    return out


def board_claims(msgs):
    """{function: (who, until)} still claimed: the last claim of each function, unless a later message of the
    same sender releases it (a claim past its date is shown as expired)"""
    claims = {}
    for fn, hdr, body in msgs:
        who = hdr.get('from', fn)
        for part in [x.strip() for x in hdr.get('releases', '').split(',') if x.strip()]:
            claims.pop(part.split()[0], None)
        for part in [x.strip() for x in hdr.get('claims', '').split(',') if x.strip()]:
            w = part.split()
            claims[w[0]] = (who, w[-1] if len(w) >= 3 and w[1] == 'until' else '?')
    return claims


def board_section(msgs):
    out = ['## Board', '',
           'Messages and claims from `docs/board/` (how to post: docs/board/README.md). Do not touch the C file of a '
           'function someone else has claimed.', '']
    claims = board_claims(msgs)
    if claims:
        out += ['| Claimed function | By | Until |', '|---|---|---|']
        out += ['| %s | %s | %s |' % (f, w, u) for f, (w, u) in sorted(claims.items())]
        out.append('')
    if not msgs:
        out += ['(no messages)', '']
    for fn, hdr, body in list(reversed(msgs))[:BOARD_SHOW]:
        out += ['**%s** to %s, %s (`docs/board/%s`)' % (hdr.get('from', '?'), hdr.get('to', 'all'),
                                                       hdr.get('date', fn[:15]), fn), '']
        out += ['> ' + ln if ln else '>' for ln in body.split('\n')]
        out.append('')
    if len(msgs) > BOARD_SHOW:
        out += ['%d older message(s) in `docs/board/`.' % (len(msgs) - BOARD_SHOW), '']
    return out


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--history', default=os.path.join(ROOT, 'docs/draft_history.csv'))
    ap.add_argument('--ranked', default=os.path.join(ROOT, 'docs/ranked_drafts.txt'))
    ap.add_argument('--out', default=OUT)
    a = ap.parse_args()
    os.chdir(ROOT)
    history = load_history(a.history)
    ranked = load_ranked(a.ranked)
    added = {path: tool_added(path) for path, _, _ in TOOLS}
    drafts = []
    for r in csv.DictReader(open('tools/c_functions.csv', newline='')):
        if r['status'] != 'nonmatching':
            continue
        lane = lane_of(r['segment'])
        drafts.append(dict(function=r['function'], c_file=r['c_file'], segment=r['segment'],
                           cause=r.get('cause') or '', lane=lane, owner=OWNERS[lane][0]))
    # one decision per draft, then the whole file follows the strongest (escalate > offer > stay)
    rank_decision = {'stay': 0, 'offer': 1, 'escalate': 2}
    files = defaultdict(lambda: dict(drafts=[], decision='stay', lane=None, tool=None))
    for d in drafts:
        decision, tool = decide(d['function'], d['owner'], history, added, cause_of(d['cause']))
        d['decision'] = decision
        bucket = files[d['c_file']]
        bucket['drafts'].append(d)
        bucket['lane'] = d['lane']
        if rank_decision[decision] > rank_decision[bucket['decision']]:
            bucket['decision'] = decision
            bucket['tool'] = tool
        elif decision == 'offer' and tool:
            bucket['tool'] = tool

    def sort_files(items):
        def key(item):
            path, info = item
            scores = [ranked.get((d['function'], path), (9999,))[0] for d in info['drafts']]
            return (min(scores), path)
        return sorted(items, key=key)

    stay = {1: [], 2: []}
    offer = {1: [], 2: []}   # offer[k] is files offered TO lane k
    escal = []
    for path, info in files.items():
        info['drafts'].sort(key=lambda d: ranked.get((d['function'], path), (9999,))[0])
        if info['decision'] == 'escalate':
            escal.append((path, info))
        elif info['decision'] == 'offer':
            offer[3 - info['lane']].append((path, info))
        else:
            stay[info['lane']].append((path, info))

    out = ['# Current lanes', '',
           'Generated by `tools/deal_lanes.py` from `docs/draft_history.csv`, `tools/c_functions.csv` and '
           '`docs/ranked_drafts.txt`. Do not edit this file. Read it, and the draft\'s history and UNSURE entry, '
           'before each draft.', '',
           'A C file has one owner. Segment lanes are the base: 001-037 Mhopkinsinc (lane 1), 038-066 StaticEck2026 '
           '(lane 2). A file whose owner has two consecutive no-gain attempts under GA on one of its drafts is '
           'offered whole to the other contributor, history attached. A draft with two no-gain attempts from each '
           'contributor, and no newer tool for its cause, is an escalation for Abdul (lane T).', '']
    out += board_section(board_messages())
    for lane in (1, 2):
        login, name = OWNERS[lane]
        out += ['## Lane %d — %s (%s)' % (lane, login, name), '',
                'Segments %s. Work every draft in these files; do not take a file from the other lists.'
                % ('001-037' if lane == 1 else '038-066'), '']
        out += file_table(sort_files(stay[lane]), ranked)
        out.append('')
        src = 3 - lane
        src_login = OWNERS[src][0]
        out += ['## Offered to %s' % login, '',
                'These files are in lane %d by segment. %s made two consecutive no-gain attempts on a draft in the '
                'file. Take the whole file. The history is the GA rows so far; do not repeat a shape listed there.'
                % (src, src_login), '']
        if not offer[lane]:
            out += ['(none)', '']
        for path, info in sort_files(offer[lane]):
            note = ' A newer tool applies (`%s`); try that before another manual pass.' % info['tool'] if info['tool'] else ''
            out += ['### `%s`' % path, '', note.strip(), ''] if note else ['### `%s`' % path, '']
            for d in info['drafts']:
                if d['decision'] == 'stay':
                    out.append('%s is in this file (score %s, %s) and comes with it.' % (
                        d['function'], ranked.get((d['function'], path), ('?',))[0], d['cause'] or 'unscored'))
                out.extend(history_lines(d['function'], history))
            out.append('')
    out += ['## Escalations — Abdul (lane T)', '',
            'Two no-gain attempts by each contributor, and no newer tool for the cause. Do not keep trying these '
            'until Abdul rules in `docs/ESCALATIONS.md`.', '']
    if not escal:
        out += ['(none this round)', '']
    for path, info in sort_files(escal):
        out += ['### `%s`' % path, '']
        for d in info['drafts']:
            out.append('%s — %s, owner %s' % (d['function'], d['cause'] or 'unscored', d['owner']))
            out.extend(history_lines(d['function'], history))
        out.append('')
    text = '\n'.join(out).rstrip() + '\n'
    open(a.out, 'w').write(text)
    print('%s: stay %d/%d, offered to 1 %d, offered to 2 %d, escalations %d' % (
        os.path.relpath(a.out, ROOT), len(stay[1]), len(stay[2]), len(offer[1]), len(offer[2]), len(escal)))


if __name__ == '__main__':
    main()
