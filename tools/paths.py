"""Repo root and import path for the split tools tree (build/match/equiv/names)."""
import os, sys
TOOLS = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(TOOLS)
SUBS = (
    'match',
    'build',
    'names',
    'equiv',
    'ghidra',
    os.path.join('match', 'wccre'),
)

def add_path():
    for sub in SUBS:
        p = os.path.join(TOOLS, sub)
        if os.path.isdir(p) and p not in sys.path:
            sys.path.insert(0, p)
    if TOOLS not in sys.path:
        sys.path.append(TOOLS)

add_path()

def hockey_exe():
    for rel in ('retail/HOCKEY.EXE', 'HOCKEY.EXE'):
        p = os.path.join(ROOT, rel)
        if os.path.isfile(p):
            return p
    return os.path.join(ROOT, 'retail/HOCKEY.EXE')
