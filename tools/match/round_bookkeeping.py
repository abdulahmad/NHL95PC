#!/usr/bin/env python3
"""round_bookkeeping.py - regenerate the progress files agents do not edit by hand.

  python3 tools/match/round_bookkeeping.py [--jobs N]

Runs tools/match/c_progress.py, tools/match/draft_causes.py and tools/match/rank_drafts.py (the ranked list is
docs/ranked_drafts.txt). Updates the counts between the nhl95-* marker comments in README.md and
HANDOFF.md (README: bit-perfect matched and functionally matched). Applies docs/pending_renames.txt with tools/names/rename_symbol.py --batch when it has any
rename lines, then leaves only the header, and regenerates the progress files again. Writes
docs/WORK_QUEUE.md with tools/match/work_queue.py. Runs `make` before scoring the drafts. Does not commit. The progress workflow runs
`make fullcheck` after this.
"""
import argparse, os, re, subprocess, sys
HERE = os.path.dirname(os.path.abspath(__file__))
_td = HERE
while os.path.basename(_td) != 'tools' and _td != os.path.dirname(_td):
    _td = os.path.dirname(_td)
if _td not in sys.path:
    sys.path.insert(0, _td)
import paths
ROOT = paths.ROOT
RENAMES = os.path.join(ROOT, 'docs/pending_renames.txt')
HEADER = """# Renames for the next progress run. One rename per line, in the tools/names/rename_symbol.py --batch format:
#   OLD NEW [{key=value,...}] evidence text
# A line starting with # is a comment. PRs append lines here and do not rename in the tree.
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
    f = re.search(r'(\d+) of them proven functionally equivalent', text)
    return matched, total, pct, drafts, (f.group(1) if f else '0')


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
    matched, total, pct, drafts, functional = counts()
    readme = os.path.join(ROOT, 'README.md')
    replace_marker(readme, 'nhl95-readme-count', '%s of %s functions are a bit-perfect match.' % (matched, total))
    replace_marker(readme, 'nhl95-readme-functional', '%s of %d remaining functions are confirmed to be a functional match.'
                   % (functional, int(total) - int(matched)))
    replace_marker(readme, 'nhl95-readme-functional-total', '%d of %s functions are a functional match.'
                   % (int(matched) + int(functional), total))
    replace_marker(os.path.join(ROOT, 'HANDOFF.md'), 'nhl95-handoff-matched',
                   '%s / %s' % (format(int(matched), ','), format(int(total), ',')))
    replace_marker(os.path.join(ROOT, 'HANDOFF.md'), 'nhl95-handoff-pct', pct + '%')
    replace_marker(os.path.join(ROOT, 'HANDOFF.md'), 'nhl95-handoff-drafts', drafts)
    print('counts: %s / %s (%s%%), %s drafts, %s functionally matched' % (matched, total, pct, drafts, functional))


def progress(jobs):
    # draft_causes.py and rank_drafts.py compare with the EXE through cdiff, which reads build/parts and the label
    # addresses in build/obj: build the current tree first (after any renames), or every draft scores as an error
    run(['make', '-j%d' % jobs])
    run([sys.executable, 'tools/match/c_progress.py'])
    run([sys.executable, 'tools/match/draft_causes.py', '--jobs', str(jobs)])
    run([sys.executable, 'tools/match/rank_drafts.py', '--jobs', str(jobs), '--out', 'docs/ranked_drafts.txt'])
    update_numbers()


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--jobs', type=int, default=4)
    a = ap.parse_args()
    os.chdir(ROOT)
    progress(a.jobs)
    lines = rename_lines()
    if lines:
        run([sys.executable, 'tools/names/rename_symbol.py', '--batch', 'docs/pending_renames.txt'])
        open(RENAMES, 'w').write(HEADER)
        progress(a.jobs)
    elif not os.path.exists(RENAMES):
        open(RENAMES, 'w').write(HEADER)
    run([sys.executable, 'tools/match/work_queue.py'])


if __name__ == '__main__':
    main()
