#!/usr/bin/env python3
"""round_bookkeeping.py - regenerate the progress files the lane agents do not edit.

  python3 tools/round_bookkeeping.py [--jobs N]

Runs tools/c_progress.py, tools/draft_causes.py and tools/rank_drafts.py (the ranked list is
docs/ranked_drafts.txt). Updates the counts between the nhl95-* marker comments in README.md and
HANDOFF.md. Applies docs/pending_renames.txt with tools/rename_symbol.py --batch when it has any
rename lines, then leaves only the header, and regenerates the progress files again. Writes
docs/LANES_CURRENT.md with tools/deal_lanes.py. Runs `make` before scoring the drafts. Does not commit. The progress workflow runs
`make fullcheck` after this.
"""
import argparse, os, re, subprocess, sys
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
RENAMES = os.path.join(ROOT, 'docs/pending_renames.txt')
HEADER = """# Renames for the next progress run. One rename per line, in the tools/rename_symbol.py --batch format:
#   OLD NEW [{key=value,...}] evidence text
# A line starting with # is a comment. Lane PRs append lines here and do not rename in the tree.
# The progress workflow applies this file and then leaves only this header.
"""


def run(cmd):
    print('+ ' + ' '.join(cmd))
    subprocess.check_call(cmd, cwd=ROOT)


def rename_lines():
    if not os.path.exists(RENAMES):
        return []
    out = []
    for ln in open(RENAMES):
        if ln.lstrip().startswith('#') or not ln.strip():
            continue
        out.append(ln)
    return out


def counts():
    text = open(os.path.join(ROOT, 'C_PROGRESS.md')).read().splitlines()[6]
    m = re.search(r'\*\*(\d+) / (\d+)\*\* compiled-C game functions matched \(([\d.]+)%\).+?(\d+) non-matching drafts', text)
    if not m:
        sys.exit('round_bookkeeping: cannot read the counts from C_PROGRESS.md')
    matched, total, pct, drafts = m.group(1), m.group(2), m.group(3), m.group(4)
    return matched, total, pct, drafts


def replace_marker(path, name, value):
    text = open(path).read()
    pat = re.compile(r'(<!-- %s:start -->)(.*?)(<!-- %s:end -->)' % (name, name), re.S)
    if not pat.search(text):
        sys.exit('round_bookkeeping: %s has no marker %s' % (path, name))
    new, n = pat.subn(lambda m: m.group(1) + value + m.group(3), text, count=1)
    if n != 1:
        sys.exit('round_bookkeeping: %s marker %s matched %d times' % (path, name, n))
    open(path, 'w').write(new)


def update_numbers():
    matched, total, pct, drafts = counts()
    replace_marker(os.path.join(ROOT, 'README.md'), 'nhl95-readme-count',
                   '%s of %s functions matched.' % (matched, total))
    replace_marker(os.path.join(ROOT, 'HANDOFF.md'), 'nhl95-handoff-matched',
                   '%s / %s' % (format(int(matched), ','), format(int(total), ',')))
    replace_marker(os.path.join(ROOT, 'HANDOFF.md'), 'nhl95-handoff-pct', pct + '%')
    replace_marker(os.path.join(ROOT, 'HANDOFF.md'), 'nhl95-handoff-drafts', drafts)
    print('counts: %s / %s (%s%%), %s drafts' % (matched, total, pct, drafts))


def progress(jobs):
    # draft_causes.py and rank_drafts.py compare with the EXE through cdiff, which reads build/parts and the label
    # addresses in build/obj: build the current tree first (after any renames), or every draft scores as an error
    run(['make', '-j%d' % jobs])
    run([sys.executable, 'tools/c_progress.py'])
    run([sys.executable, 'tools/draft_causes.py', '--jobs', str(jobs)])
    run([sys.executable, 'tools/rank_drafts.py', '--jobs', str(jobs), '--out', 'docs/ranked_drafts.txt'])
    update_numbers()


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--jobs', type=int, default=4)
    a = ap.parse_args()
    os.chdir(ROOT)
    progress(a.jobs)
    lines = rename_lines()
    if lines:
        run([sys.executable, 'tools/rename_symbol.py', '--batch', 'docs/pending_renames.txt'])
        open(RENAMES, 'w').write(HEADER)
        progress(a.jobs)
    elif not os.path.exists(RENAMES):
        open(RENAMES, 'w').write(HEADER)
    run([sys.executable, 'tools/deal_lanes.py'])


if __name__ == '__main__':
    main()
