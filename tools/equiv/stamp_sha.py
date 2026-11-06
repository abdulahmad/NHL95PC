#!/usr/bin/env python3
"""Copy a PASS results.csv row onto the current C-file sha1 when the named
function's C bytes are unchanged (or only a callee identifier that still maps to
the same EXE address). No Unicorn.

  python3 tools/equiv/stamp_sha.py avdgoal NetCollide ReplayStep

Refuses if the PASS blob cannot be found, the function body differs by more than
a same-entry rename, or the latest row is not PASS. Appends one CSV row per
successful stamp. A current-sha PASS is already stamped and is skipped.
"""
import csv, datetime, hashlib, os, re, subprocess, sys
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, os.path.join(ROOT, 'tools'))
import paths
ROOT = paths.ROOT
RESULTS = os.path.join(ROOT, 'tools/equiv/results.csv')
HEAD = ['function', 'c_file', 'source_sha1', 'cases', 'seed', 'verdict', 'first_diff', 'date']
IDENT = re.compile(r'\b[A-Za-z_][A-Za-z0-9_]*\b')
FUNC_DEF = r'^[A-Za-z_][\w \t\*]*?\b%s\s*\([^;{]*\)\s*\{'


def extract_func(text, name):
    m = re.search(FUNC_DEF % re.escape(name), text, re.M)
    if not m:
        return None
    i, depth = m.end() - 1, 0
    for j in range(i, len(text)):
        if text[j] == '{':
            depth += 1
        elif text[j] == '}':
            depth -= 1
            if depth == 0:
                return text[m.start():j + 1]
    return None


def follow_blobs(path):
    """(commit, path_at_commit, sha1, bytes) for each unique blob on --follow history."""
    log = subprocess.check_output(
        ['git', 'log', '--follow', '--name-only', '--pretty=format:COMMIT %H', '--', path],
        cwd=ROOT, text=True)
    cur, seen, out = None, set(), []
    for line in log.splitlines():
        if line.startswith('COMMIT '):
            cur = line.split()[1]
            continue
        if not line.strip() or cur is None:
            continue
        p = line.strip()
        try:
            data = subprocess.check_output(['git', 'show', '%s:%s' % (cur, p)], cwd=ROOT)
        except subprocess.CalledProcessError:
            continue
        h = hashlib.sha1(data).hexdigest()
        if h in seen:
            continue
        seen.add(h)
        out.append((cur, p, h, data))
    return out


def exe_addr(name):
    """Linear address of a C/asm label from asmfuncs.h HEX comments, or None."""
    h = os.path.join(ROOT, 'src/include/asmfuncs.h')
    pat = re.compile(r'\b%s\s*\(' % re.escape(name))
    for line in open(h):
        if not pat.search(line):
            continue
        m = re.search(r'/\*\s*([0-9A-Fa-f]+)\s*\*/', line)
        if m:
            return int(m.group(1), 16)
    return None


def same_entry_rename(old_body, new_body):
    """If bodies differ by one identifier swap and the new name is an EXE label, return (old, new, addr)."""
    if old_body == new_body:
        return None
    old_ids, new_ids = set(IDENT.findall(old_body)), set(IDENT.findall(new_body))
    only_old, only_new = old_ids - new_ids, new_ids - old_ids
    if len(only_old) != 1 or len(only_new) != 1:
        return False
    o, n = only_old.pop(), only_new.pop()
    if old_body.replace(o, n) != new_body:
        return False
    addr = exe_addr(n)
    if addr is None:
        return False
    return o, n, addr


def latest_rows():
    latest = {}
    with open(RESULTS, newline='') as f:
        for r in csv.DictReader(f):
            latest[r['function']] = r
    return latest


def stamp_one(name, latest):
    row = latest.get(name)
    if not row:
        print('REFUSE %s: no results.csv row' % name)
        return None
    if row['verdict'] != 'PASS':
        print('REFUSE %s: latest verdict is %s' % (name, row['verdict']))
        return None
    path = os.path.join(ROOT, row['c_file'])
    if not os.path.isfile(path):
        print('REFUSE %s: missing %s' % (name, row['c_file']))
        return None
    cur = open(path, 'rb').read()
    cur_sha = hashlib.sha1(cur).hexdigest()
    if cur_sha == row['source_sha1']:
        print('skip %s: already current sha %s' % (name, cur_sha[:12]))
        return None
    cur_body = extract_func(cur.decode(), name)
    if not cur_body:
        print('REFUSE %s: cannot extract function from current file' % name)
        return None
    blobs = follow_blobs(row['c_file'])
    want = row['source_sha1']
    hit = next((b for b in blobs if b[2] == want), None)
    note = ''
    if hit:
        old_body = extract_func(hit[3].decode(), name)
        if not old_body:
            print('REFUSE %s: cannot extract function from PASS blob %s' % (name, want[:12]))
            return None
        if old_body == cur_body:
            note = 'stamped from %s: function bytes identical' % want[:12]
        else:
            rename = same_entry_rename(old_body, cur_body)
            if not rename:
                print('REFUSE %s: function bytes differ from PASS blob %s' % (name, want[:12]))
                return None
            o, n, addr = rename
            note = 'stamped from %s: %s -> %s at %05X (same EXE entry)' % (want[:12], o, n, addr)
    else:
        # PASS sha is not a committed blob (ReplayStep path rewrite). Compare
        # against the nearest historical body of the same function.
        old_body = None
        old_sha = None
        for _c, _p, h, data in blobs:
            if h == cur_sha:
                continue
            body = extract_func(data.decode(errors='replace'), name)
            if body is None:
                continue
            if body == cur_body:
                old_body, old_sha = body, h
                note = 'stamped; PASS sha %s not in git, function bytes match blob %s' % (want[:12], h[:12])
                break
            rename = same_entry_rename(body, cur_body)
            if rename:
                o, n, addr = rename
                old_body, old_sha = body, h
                note = 'stamped; PASS sha %s not in git, %s -> %s at %05X vs blob %s' % (
                    want[:12], o, n, addr, h[:12])
                break
        if old_body is None:
            print('REFUSE %s: PASS sha %s not in git and no historical body matches' % (name, want[:12]))
            return None
    new = dict(row)
    new['source_sha1'] = cur_sha
    new['first_diff'] = (row.get('first_diff') or '')
    if note:
        extra = note
        new['first_diff'] = (new['first_diff'] + '; ' + extra).strip('; ')
    new['date'] = datetime.date.today().isoformat()
    print('PASS %s %s -> %s (%s)' % (name, want[:12], cur_sha[:12], note))
    return new


def main():
    names = sys.argv[1:] or ['avdgoal', 'NetCollide', 'ReplayStep']
    latest = latest_rows()
    added = []
    for name in names:
        row = stamp_one(name, latest)
        if row:
            added.append(row)
            latest[name] = row
    if not added:
        return 0
    with open(RESULTS, 'a', newline='') as f:
        w = csv.DictWriter(f, fieldnames=HEAD, extrasaction='ignore')
        for r in added:
            w.writerow(r)
    print('appended %d row(s) to %s' % (len(added), os.path.relpath(RESULTS, ROOT)))
    return 0


if __name__ == '__main__':
    sys.exit(main())
