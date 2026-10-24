#!/usr/bin/env python3
"""seed_draft_history.py - build docs/draft_history.csv from merged lane-round PR titles and bodies.

  python3 tools/seed_draft_history.py [--out docs/draft_history.csv]

Reads `gh pr list` (merged PRs from #22 on, the first two-lane round) and the round-start scores in
docs/LANES.md at 9dcb1203 (PR #21). One row per function per PR. Day-to-day rows are appended by the lane
agents (the file is union-merged). This script is the one-shot seed: it refuses to overwrite an existing
file unless `--force` is passed, and the progress workflow does not run it. Compiler is GA: this round is
entirely under Watcom 10.0 GA.
"""
import argparse, csv, io, json, os, re, subprocess, sys
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
BASELINE = '9dcb1203'
FIELDS = ['function', 'contributor', 'date', 'compiler', 'score_before', 'score_after', 'shapes_tried']


def baseline_scores():
    text = subprocess.check_output(['git', 'show', '%s:docs/LANES.md' % BASELINE], cwd=ROOT, text=True)
    scores = {}
    for m in re.finditer(r'^\| \d{3}_[^|]+ \| ([A-Za-z_][A-Za-z0-9_]*) \| (\d+) \|', text, re.M):
        scores[m.group(1)] = int(m.group(2))
    return scores


def function_names():
    import csv as _csv
    names = set()
    with open(os.path.join(ROOT, 'tools/c_functions.csv'), newline='') as f:
        for r in _csv.DictReader(f):
            for part in r['function'].split():
                names.add(part)
    names |= set(baseline_scores())
    return names


def prs():
    raw = subprocess.check_output(
        ['gh', 'pr', 'list', '--state', 'merged', '--limit', '80',
         '--json', 'number,title,body,mergedAt,author'], cwd=ROOT, text=True)
    rows = [p for p in json.loads(raw) if p['number'] >= 22 and p['author']['login'] in
            ('Mhopkinsinc', 'StaticEck2026')]
    rows.sort(key=lambda p: (p['mergedAt'], p['number']))
    return rows


def split_top(s):
    """split on commas that are not inside parentheses"""
    out, buf, depth = [], [], 0
    for ch in s:
        if ch == '(':
            depth += 1
        elif ch == ')' and depth:
            depth -= 1
        if ch == ',' and depth == 0:
            out.append(''.join(buf).strip()); buf = []
        else:
            buf.append(ch)
    if buf:
        out.append(''.join(buf).strip())
    return [x for x in out if x]


def strip_score(piece, names):
    """'ShowCredits', 'SelectSavedFile 15', 'GameStatsScreen 20 (note)' -> (name, score or None, rest)"""
    piece = piece.strip().lstrip('*').strip()
    m = re.match(r'\*?\*?([A-Za-z_][A-Za-z0-9_]*)\*?\*?(?:\s+(\d+))?\b(.*)$', piece)
    if not m or m.group(1) not in names:
        return None
    rest = m.group(3).strip().lstrip(':').strip()
    return m.group(1), (int(m.group(2)) if m.group(2) else None), rest


ARROW = re.compile(
    r'(?<![A-Za-z0-9_])([A-Za-z_][A-Za-z0-9_]*)(?:\s*/\s*([A-Za-z_][A-Za-z0-9_]*))?\s+'
    r'(\d+)\s*(?:/\s*(\d+))?\s*->\s*(\d+)(?:\s*/\s*(\d+))?')


def arrows(text, names):
    """[(name, before, after, shapes)] from 'A 12 -> 3' and 'A / B 57 / 58 -> 30 / 28'"""
    out = []
    for m in ARROW.finditer(text):
        a, b = m.group(1), m.group(2)
        if a not in names:
            continue
        tail = text[m.end():m.end() + 220]
        tail = re.split(r'\n\s*\*|,\s*\*?\*?[A-Z]', tail)[0]
        tail = re.sub(r'\s+', ' ', tail).strip(' .;')
        shape = tail[:240]
        out.append((a, int(m.group(3)), int(m.group(5)), shape))
        if b and b in names and m.group(4) and m.group(6):
            out.append((b, int(m.group(4)), int(m.group(6)), shape))
    return out


def section_items(body, names):
    """rows from Match / Improved / Unchanged sections: (name, before or None, after or None, shapes, kind)"""
    rows = []
    lines = body.splitlines()
    mode = None
    for i, line in enumerate(lines):
        head = re.match(r'\*\*(Match(?:es)?|Improved drafts?|Not matched, unchanged|Unchanged)[^*]*\*\*\s*(.*)', line)
        if head:
            kind = head.group(1).lower()
            mode = 'match' if kind.startswith('match') else 'improved' if kind.startswith('improved') else 'unchanged'
            rest = head.group(2).strip()
            if rest:
                rows += items_from_text(rest, names, mode)
            continue
        if mode and (line.startswith('**') or line.startswith('##')):
            mode = None
            continue
        if mode and line.strip():
            rows += items_from_text(line, names, mode)
        elif mode and not line.strip():
            # a blank line ends a paragraph list but not a following bullet; keep mode for bullets
            nxt = next((x for x in lines[i + 1:] if x.strip()), '')
            if not nxt.startswith('*') and not nxt.startswith('-'):
                mode = None
    return rows


def items_from_text(text, names, mode):
    out = []
    # bold function: **Name** ... possibly with N -> M
    for m in re.finditer(r'\*\*([A-Za-z_][A-Za-z0-9_]*)\*\*([^\n*]{0,300})', text):
        if m.group(1) not in names:
            continue
        tail = re.sub(r'\s+', ' ', m.group(2)).strip(' :-')
        found = arrows(m.group(1) + ' ' + tail, names)
        if found:
            for name, b, a, shape in found:
                if name == m.group(1):
                    out.append((name, b, a, shape or tail[:240], mode))
        else:
            out.append((m.group(1), None, 0 if mode == 'match' else None, tail[:240], mode))
    if out:
        return out
    for piece in split_top(text):
        # an arrow inside the piece
        found = arrows(piece, names)
        if found:
            for name, b, a, shape in found:
                out.append((name, b, a, shape, mode))
            continue
        got = strip_score(piece, names)
        if not got:
            continue
        name, score, rest = got
        if mode == 'match':
            out.append((name, score, 0, rest[:240] or 'matched', mode))
        elif mode == 'unchanged':
            out.append((name, score, score, rest[:240] or 'unchanged', mode))
        else:
            out.append((name, score, None, rest[:240], mode))
    return out


def seed():
    names = function_names()
    scores = baseline_scores()
    out = []
    for p in prs():
        who = p['author']['login']
        date = p['mergedAt'][:10]
        text = (p['title'] or '') + '\n' + (p['body'] or '')
        found = {}
        for name, b, a, shape, mode in section_items(p['body'] or '', names):
            found[name] = (b, a, shape, mode)
        for name, b, a, shape in arrows(p['title'] or '', names):
            found.setdefault(name, (b, a, shape, 'title'))
        for name, b, a, shape in arrows(p['body'] or '', names):
            if name not in found:
                found[name] = (b, a, shape, 'arrow')
        # "TeamRosterScreen matched" (the bold includes the word, so it is not **Name**)
        for m in re.finditer(r'\*\*([A-Za-z_][A-Za-z0-9_]*) matched\*\*', p['body'] or ''):
            if m.group(1) in names:
                sent = re.sub(r'\s+', ' ', (p['body'] or '')[m.start():m.start() + 240])
                found[m.group(1)] = (None, 0, sent[:240], 'match')
        for name, (b, a, shape, mode) in found.items():
            before = b if b is not None else scores.get(name)
            if before is None:
                continue
            if a is None:
                if mode == 'match':
                    after = 0
                elif mode == 'unchanged':
                    after = before
                else:
                    continue
            else:
                after = a
            shape = shape or ('matched' if after == 0 else 'unchanged' if after == before else '')
            out.append(dict(function=name, contributor=who, date=date, compiler='GA',
                            score_before=before, score_after=after, shapes_tried=shape))
            scores[name] = after
    return out


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--out', default=os.path.join(ROOT, 'docs/draft_history.csv'))
    ap.add_argument('--force', action='store_true', help='overwrite --out even if it already exists')
    a = ap.parse_args()
    if os.path.exists(a.out) and not a.force:
        sys.exit('seed_draft_history: %s exists. Lane agents append rows; pass --force to replace the seed.' % a.out)
    rows = seed()
    buf = io.StringIO()
    w = csv.DictWriter(buf, fieldnames=FIELDS, lineterminator='\n')
    w.writeheader()
    for r in rows:
        w.writerow(r)
    open(a.out, 'w', newline='').write(buf.getvalue())
    print('%s: %d rows' % (os.path.relpath(a.out, ROOT), len(rows)))


if __name__ == '__main__':
    main()
