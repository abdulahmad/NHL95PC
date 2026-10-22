#!/usr/bin/env python3
"""unsure_rows.py - turn the "tried / do not retry" shapes of docs/UNSURE.md into rows of docs/unsure_tried.csv.

  python3 tools/unsure_rows.py [--check]

Two kinds of rows (func, transform, shape, result, cc):
* one per shape of a bullet's "Tried:" list, with an empty transform: `shape` is the UNSURE wording, `result` the
  outcome given with it (a line count, "no change", "worse", ...). A record only.
* one per shape anywhere in the bullet that tools/permute.py would generate, with `transform` its transform prefix:
  declaration orders of named locals (movedecl / swapdecl), a named local's integer type, the result type, a local
  moved into its block, a temporary inlined. Only prefixes that name one of the draft's current permute.py
  candidates are kept. permute.py skips every candidate whose transform starts with one of its function's prefixes.
`cc` is the compiler the shapes were tried under: `ga` for a bullet that names 10.0 GA (or sits under a heading that
does), else `la` (every entry from before the switch to 10.0 GA on 2026-10-22). permute.py only skips the rows of
the compiler it runs. Rows filled in by hand (or kept from an earlier run) survive a rerun: the CSV is merged, never
overwritten. --check only prints what would be added."""
import os, re, csv, sys, argparse
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
SRC = os.path.join(ROOT, 'docs', 'UNSURE.md'); OUT = os.path.join(ROOT, 'docs', 'unsure_tried.csv')
FIELDS = ['func', 'transform', 'shape', 'result', 'cc']


def bullets(text):
    """(function name, bullet text, compiler) for every bullet that starts with a function name"""
    head = ''
    for l in text.split('\n'):
        if l.startswith('#'): head = l
        m = re.match(r'^\s*\*\s+`?([A-Za-z_]\w*)`?(?:\s*/\s*`?[A-Za-z_]\w*`?)*\s*(\([^)]*\))?\s*:\s*(.*)$', l)
        if m and not m.group(1)[0].islower() or (m and re.match(r'^[a-z]\w*[A-Z0-9]|^[a-z]+\d|^ass|^chk|^check|^get|^set|^do|^puck|^skate|^wall|^upd|^per|^face|^opp', m.group(1))):
            yield m.group(1), m.group(3), 'ga' if '10.0 GA' in head or '10.0 GA' in l else 'la'


def split_shapes(t):
    """split a "Tried:" list at `; ` and at `, ` before a new shape, never inside `code`"""
    parts, cur, code = [], '', False
    k = 0
    while k < len(t):
        c = t[k]
        if c == '`': code = not code
        if not code and t.startswith('; ', k):
            parts.append(cur); cur = ''; k += 2; continue
        if not code and t.startswith(', ', k) and re.match(r'(?:a|an|the|plus|declaring|moving|swapping|with|without)\b', t[k + 2:]):
            parts.append(cur); cur = ''; k += 2; continue
        cur += c; k += 1
    return parts + [cur]


def shapes(body):
    """the tried shapes of one bullet: [(shape, result)]"""
    out = []
    for m in re.finditer(r'(?:Tried|tried)(?: so far)?:?\s+(.*?)(?:\.\s+(?:Do not retry|Not retried|None of)|$)', body):
        t = m.group(1).strip()
        if not t: continue
        for part in split_shapes(t):
            part = part.strip().rstrip('.')
            if len(part) < 4: continue
            r = re.search(r'\(([^()]*?(?:\d+|no change|worse|same|better|lines?|bytes?)[^()]*)\)\s*$', part)
            out.append((part, r.group(1) if r else ''))
    if not out and re.search(r'[Dd]o not retry', body):
        m = re.search(r'([A-Z][a-z]+) shapes', body)
        out.append(((m.group(0) if m else 'shapes listed in docs/UNSURE.md') + ' (not itemized)', ''))
    return out


TYPES = r'unsigned short|unsigned char|signed char|unsigned|short|int|char|long'


def skip_prefixes(body):
    """[(phrase, permute.py transform prefix)] for the shapes anywhere in a bullet that the permuter would generate:
    declaration orders of named locals, a named local's integer type, the result type, a local moved into its
    block, a temporary inlined. Candidates only: main() keeps those that name one of the draft's transforms."""
    out = []
    for m in re.finditer(r'declaration orders?(?: of| for)? ((?:`?[A-Za-z_]\w*`?(?:,? and |, | / |,? or )?)+)', body):
        for v in re.findall(r'[A-Za-z_]\w*', m.group(1)):
            if v not in ('and', 'or'): out += [(m.group(0), 'movedecl:%s:' % v), (m.group(0), 'swapdecl:%s:' % v)]
    for m in re.finditer(r'((?:`?[A-Za-z_]\w*`?\s*(?:/|,|and|or)\s*)*`?[A-Za-z_]\w*`?) (?:as|declared) (?:an? )?`?'
                         r'((?:(?:%s)`?(?:\s*(?:/|,|or|and)\s*`?)?)+)' % TYPES, body):
        for v in re.findall(r'[A-Za-z_]\w*', m.group(1)):
            for t in re.findall(TYPES, m.group(2)):
                out.append((m.group(0), 'type:%s:%s' % (v, t.replace(' ', '_'))))
    for m in re.finditer(r'`(%s) ([A-Za-z_]\w*)`' % TYPES, body):
        out.append((m.group(0), 'type:%s:%s' % (m.group(2), m.group(1).replace(' ', '_'))))
    for m in re.finditer(r'\b(?:an? |the )?(%s) (?:local|temporary|temp) for (?:the )?`?([A-Za-z_]\w*)`?' % TYPES, body):
        out.append((m.group(0), 'type:%s:%s' % (m.group(2), m.group(1).replace(' ', '_'))))
    for m in re.finditer(r'\b(?:an? )?`?(%s)`? result\b' % TYPES, body):
        out.append((m.group(0), 'rettype:%s' % m.group(1).replace(' ', '_')))
    for m in re.finditer(r'`?([A-Za-z_]\w*)`? declared in (?:the|its) (?:loop|block|inner block)', body):
        out.append((m.group(0), 'scope:%s@' % m.group(1)))
    for m in re.finditer(r'`?([A-Za-z_]\w*)`? inlined', body):
        out.append((m.group(0), 'temp:%s:inline' % m.group(1)))
    return out


def draft_transforms(func):
    """the names of permute.py's current candidates for a nonmatching draft (empty for anything else)"""
    sys.path.insert(0, HERE)
    import permute
    rows = [r for r in csv.DictReader(open(os.path.join(HERE, 'c_functions.csv'), newline=''))
            if r['function'] == func and r['status'] == 'nonmatching']
    if not rows: return []
    try: return [d for d, _ in permute.neighbours(open(os.path.join(ROOT, rows[0]['c_file'])).read(), func)]
    except (SystemExit, Exception): return []


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('--check', action='store_true'); a = ap.parse_args()
    old = []
    if os.path.exists(OUT): old = list(csv.DictReader(open(OUT, newline='')))
    for r in old: r['cc'] = r.get('cc') or 'la'
    have = {(r['func'], r['transform'], r['shape'], r['cc']) for r in old}
    new = []
    for func, body, ver in bullets(open(SRC).read()):
        for shape, result in shapes(body):
            if (func, '', shape, ver) in have: continue
            have.add((func, '', shape, ver))
            new.append(dict(func=func, transform='', shape=shape, result=result, cc=ver))
        cands = skip_prefixes(body)
        if not cands: continue
        names = draft_transforms(func)
        for phrase, pre in cands:
            if (func, pre, phrase, ver) in have or not any(n.startswith(pre) for n in names): continue
            have.add((func, pre, phrase, ver))
            new.append(dict(func=func, transform=pre, shape=phrase, result='tried (docs/UNSURE.md)', cc=ver))
    if a.check:
        for r in new: print('%s | %s | %s | %s | %s' % (r['func'], r['transform'], r['shape'][:90], r['result'], r['cc']))
        print('%d new rows (%d kept)' % (len(new), len(old)))
        return
    with open(OUT, 'w', newline='') as f:
        w = csv.DictWriter(f, FIELDS, lineterminator='\n'); w.writeheader()
        for r in old + new: w.writerow({k: r.get(k, '') for k in FIELDS})
    print('%s: %d rows (%d new)' % (os.path.relpath(OUT, ROOT), len(old) + len(new), len(new)))


if __name__ == '__main__':
    main()
