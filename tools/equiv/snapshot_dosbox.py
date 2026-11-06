#!/usr/bin/env python3
"""DOSBox-X entry snapshots for leftover NR drafts (107-PASS Unit 6).

This VM has no play session. Abdul captures on his machine; this script writes the
debugger commands and loads the dumps into check.py --play-snaps.

  python3 tools/equiv/snapshot_dosbox.py queue
  python3 tools/equiv/snapshot_dosbox.py script SkateToSpot > build/equiv/snapshots/SkateToSpot.dbg
  python3 tools/equiv/snapshot_dosbox.py load dumps.jsonl
  python3 tools/equiv/check.py src/engine/logic/SkateToSpot.c --func SkateToSpot --seg engine/logic --play-snaps dumps.jsonl --force --budget 600

Dump format (JSONL, one hit per line): function, regs (eax..ebp), args (dwords above the
return address), pages {linear_page_hex: hex-or-base64 of 4 KB}. See docs/SNAPSHOTS.md.
"""
import argparse, csv, json, os, sys, hashlib, base64
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, HERE); sys.path.insert(0, os.path.join(ROOT, 'tools'))
import image
from collections import OrderedDict

# Capture order: near-miss engine, rest of engine NR, TitleScreen, front/PC by coverage, FAIL last.
QUEUE = [
    'SkateToSpot', 'checkpuckcoll_ccx', 'DrawRinkOverlays', 'InProgress', 'assthreestars',
    'PenGoalStuff', 'wallcoll', 'StarCompare', 'PassLaneChk', 'assonetimer', 'assrefgoalpa',
    'FillDressedSlots', 'PickForLineSlot', 'CanBlockShot', 'assgoalie', 'checkgoal', 'checkcheck',
    'TitleScreen', 'DrawCalendarDay', 'POAfterGame', 'InstantReplay', 'ExportTeamToFloppy',
    'MoveToOtherRoster', 'EditRosters', 'RunTeamPickMenu', 'RandomizeSchedule', 'RunPlayerPickMenu',
    'TradeScreenLoop', 'EditTextField', 'RunMenu', 'ReplaySaveHilight', 'GameSummaryScreen',
    'CopyHumanTeamDBs', 'TradePlayers', 'PlayoffTreeMenu', 'LeagueTeamSelect', 'DbLineEditorLoop',
    'GameLineEditorLoop', 'CalendarScreen', 'PlayLeagueGame', 'PostGameToTeamDb', 'SimulateGame',
    'PickAwardWinners', 'EditSkaterRating', 'EditGoalieRating', 'FixJerseyConflict', 'ExecuteTrade',
    'RosterPanelClick', 'POSeedTeams', 'SeedPlayoffRound3', 'DrawListItems', 'ListDialog',
    'SportsDesk', 'SimPlayoffRound1',
]

def csv_row(func):
    for r in csv.DictReader(open(os.path.join(ROOT, 'tools', 'match', 'c_functions.csv'))):
        if r['function'] == func:
            return r
    raise SystemExit('not in c_functions.csv: %s' % func)

def cmd_queue(_):
    img = image.load(); lab = img.labels()
    for i, n in enumerate(QUEUE, 1):
        r = csv_row(n)
        addr = lab.get(n) or int(r['address'], 16)
        print('%2d  %s  %s  label=%#x  %s' % (i, n, r['segment'], addr, r['c_file']))

def cmd_script(a):
    img = image.load(); r = csv_row(a.func)
    addr = img.labels().get(a.func) or int(r['address'], 16)
    nstack = 8
    print('# DOSBox-X debugger commands for %s (linear %#x).' % (a.func, addr))
    print('# Load HOCKEY.EXE under DOS/4GW so linear addresses match tools/equiv/image.py.')
    print('# On hit: dump regs, 8 stack dwords, data pages; append one JSONL line; C to continue.')
    print('BPLINEAR %#x' % addr)
    print('# --- at the breakpoint, record ---')
    sample = {
        'function': a.func,
        'eip': '0x%x' % addr,
        'regs': {reg: '0x0' for reg in ('eax', 'ebx', 'ecx', 'edx', 'esi', 'edi', 'ebp', 'esp')},
        'args': ['0x0'] * nstack,
        'pages': {'0xc0000': '<4096-byte hex or base64>'},
    }
    print('# JSONL template:')
    print('# ' + json.dumps(sample, separators=(',', ':')))

def _blob(s):
    s = s.strip().replace(' ', '').replace('\n', '')
    if not s:
        return b''
    try:
        return bytes.fromhex(s)
    except ValueError:
        return base64.b64decode(s)

def cmd_load(a):
    n = 0
    by = {}
    for line in open(a.path):
        line = line.strip()
        if not line or line.startswith('#'):
            continue
        o = json.loads(line)
        fn = o.get('function')
        if not fn or 'regs' not in o:
            raise SystemExit('bad dump line: %s' % line[:80])
        pages = o.get('pages') or {}
        for k, v in pages.items():
            b = _blob(v)
            if len(b) not in (0, 4096) and len(b) < 4:
                raise SystemExit('%s page %s is %d bytes (want 4 KB or a short patch)' % (fn, k, len(b)))
        by.setdefault(fn, 0); by[fn] += 1; n += 1
    print('%d dumps, %d functions' % (n, len(by)))
    for fn, c in sorted(by.items()):
        print('  %s %d' % (fn, c))
    missing = [x for x in QUEUE if x not in by]
    if missing:
        print('still needed (%d): %s' % (len(missing), ', '.join(missing[:20]) + ('...' if len(missing) > 20 else '')))

def load_play_snaps(path, func):
    """JSONL -> [(argbuf, run.State)] for check.py --play-snaps. Imported by check.py."""
    import run
    ARG, ARG_SIZE = 0x6000000, 0x10000
    out = []
    for line in open(path):
        line = line.strip()
        if not line or line.startswith('#'):
            continue
        o = json.loads(line)
        if o.get('function') != func:
            continue
        def num(x):
            return int(x, 0) if isinstance(x, str) else int(x)
        regs = {k: num(v) for k, v in o.get('regs', {}).items() if k != 'esp'}
        args = [num(x) for x in o.get('args', [])]
        patches = {}
        buf = bytes(ARG_SIZE)
        for k, v in (o.get('pages') or {}).items():
            addr = num(k); b = _blob(v)
            if addr == ARG:
                buf = (b + bytes(ARG_SIZE))[:ARG_SIZE]
            else:
                patches[addr] = b
        out.append((buf, run.State(regs=regs, args=args, patches=patches, script=None)))
    return out

def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest='cmd', required=True)
    sub.add_parser('queue', help='print capture order with labels')
    p = sub.add_parser('script', help='print DOSBox-X breakpoint commands for one function')
    p.add_argument('func')
    p = sub.add_parser('load', help='validate a JSONL dump file')
    p.add_argument('path')
    a = ap.parse_args(argv)
    if a.cmd == 'queue':
        return cmd_queue(a)
    if a.cmd == 'script':
        return cmd_script(a)
    if a.cmd == 'load':
        return cmd_load(a)

if __name__ == '__main__':
    main()
