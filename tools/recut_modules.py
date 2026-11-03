#!/usr/bin/env python3
"""recut_modules.py - re-cut the code files of src/cseg01 to the PC programmers' own modules (alignment step F4).

  python3 tools/recut_modules.py [--dry-run]

The EXE was linked from Watcom C modules, each one unbroken stretch of code. Shared exits, shared string literals,
the literal pool order and C files that only match together prove which functions shared a source file
(docs/MODULE_LAYOUT.md). This tool moves the file boundaries to those modules and renames files after the job they
do (a 95G file name where the file does that 95G job). Only text moves: every byte stays where it is.

What it changes, from the PLAN below:
  src/cseg01/**.asm     the code of all files concatenated in link order and cut again; each new file gets its
                        header, `section s_<start>`, and `extern` / `global` lines recomputed from what it defines
                        and uses (including the labels its C fragments in build/c use, so run a CBUILD=1 build first)
  src/segments.txt      the code rows (start, end, size, module, file)
  segmap95pc.json       the cseg01 list (what rebuild_exe.py extract slices build/parts by)
  src/c/**.c            a C file follows the asm file that holds its own function (the file's stem); every
                        `%include "c/..."` and `; C: src/c/...` line, tools/c_functions.csv and other text that
                        names the C file follow it
Run `make fullcheck` after: both builds must print MATCH. The legacy segdef.py / module_map.csv (step F2b inputs)
describe the layout before this step."""
import argparse, csv, glob, json, os, re, subprocess, sys
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, 'src')

# starts of today's files that go away (their code joins the file before)
REMOVE = ['pc/gamesave_io', 'front/stats_team', 'pc/asset_loading', 'front/scoreboard', 'front/title',
          'pc/palette_fx', 'pc/temp_files', 'pc/import_export', 'front/trade', 'engine/logic', 'engine/faceoff',
          'pc/database_save', 'front/create', 'front/team_select', 'front/highlights', 'pc/sound_config',
          'front/speech', 'front/announcer']
# new starts: a new file begins with this function (and the jump table / padding / C switch in front of it)
CUTS = [('PickAwardWinners', 'front/awards'), ('IndexPhotoBank', 'pc/asset_loading'),
        ('DrawPanelScore', 'front/scoreboard'), ('RunDemoGame', 'front/title'),
        ('AddHumanTeam', 'front/league_teams'), ('assboxenter', 'engine/logic'),
        ('TakePlayerFromBox', 'engine/faceoff'), ('GetPeriodTimeRemaining', 'engine/penalty'),
        ('DitherRect', 'engine/overlay'), ('ReplayRecordReset', 'engine/replay'),
        ('MenuCentralRegistry', 'pc/league_db'), ('RunEditRosters', 'front/create'),
        ('GameLineEditor', 'front/game_lines'), ('MenuSoundSettings', 'pc/sound_config'),
        ('SpeechTimerTick', 'front/announcer')]
# today's starts that stay, under a new name
RENAME = {'pc/output_files': 'front/desk_stats', 'front/labels': 'front/screen_util',
          'front/stats_easn': 'front/stats_screens', 'front/schedule_league': 'front/league_tree',
          'front/arena_logos': 'front/pregame', 'front/setup': 'front/summary', 'pc/misc_dialogs': 'pc/dialogs',
          'front/season_setup': 'front/league_setup', 'front/roster': 'front/trade', 'front/schedule': 'front/season',
          'front/optsetup': 'front/simgame', 'engine/init': 'engine/intro', 'engine/penalty': 'engine/gamelog',
          'engine/video': 'engine/lines', 'pc/joystick_calibration': 'pc/input_events',
          'engine/replay': 'front/replay_controls', 'pc/demo_savegame': 'front/savegame',
          'front/season': 'front/playoff_mode', 'pc/allfiles_coach': 'pc/file_locations'}
# header comment of every file whose contents change (the others keep theirs)
HEADER = {
 'front/main': 'Start-up and the in-game pads. Memory and disk checks, keyboard, joystick and mouse, hot keys,\n'
               'the frame loop, the palette fade, and the game loop that launches a game.',
 'front/awards': 'End-of-season trophies. Picking the winners, the award screens, the summary of who won each one,\n'
                 'and the ceremony (95G front/awards95). One module: they share PickAwardWinners\' exit.',
 'pc/asset_loading': 'Loading a game. Player photos, rink graphics, and a clean set of game variables.',
 'pc/file_utils': 'Files. Opening and copying the databases, the record readers and writers, and checking free disk space.',
 'front/scoreboard': 'The scoreboard drawn during a game: the score, the clock, the line energy and penalty bars,\n'
                     'and the Stanley Cup final series. One module: the panel functions share UpdateHudPanel\'s exit.',
 'front/title': 'The title. The demo that runs from the title screen, the Pioneer and EA Sports logos, the title screen,\n'
                'the credits, and the text drawn over them (95G front/title95).',
 'front/desk_stats': 'Sports Central\'s statistics menu. Writing the current screen out as a text file, the desk exits,\n'
                     'and one action for each team, skater and goalie category. One module (shared exits).',
 'front/desk_main': 'Sports Central. The front-end menu loop, saving or restoring which mode you are in, and the File and\n'
                    'League Manager menus: a new exhibition or league, trades, imports, and the next game. One module.',
 'front/calendar': 'The league calendar, stepping to the next or previous month, playing a league game, posting the result\n'
                   'into the team files, and the team grid used while setting a league up.',
 'front/trade': 'The Trade Players screen, including the check that two players are not given the same jersey number,\n'
                'and making the trade (95G front/trade95).',
 'front/league_teams': 'Adding or removing a human team, the master password, the league info file, and copying that\n'
                       'team\'s files.',
 'engine/intro': 'The skate-out before the puck drops, and the three stars after the game. One module: the stars\n'
                 'share PreGameIntro\'s exits.',
 'engine/logic': 'What each player is trying to do. The assignment table: wings, centres, defence, the goalie,\n'
                 'the puck carrier, the referee, and the shootout path (95G engine/logic95).',
 'engine/input': 'What the pads do during a game: the timer queue that records buttons between frames, skating,\n'
                 'passing and shooting input, line changes, the one-timer and receiving a pass (95G engine/input95).',
 'engine/faceoff': 'Faceoffs and the penalty shot. Who lines up, when the puck is dropped, and the penalty-shot\n'
                   'assignments (95G engine/faceoff95).',
 'engine/gamelog': 'The rink objects, the deferred calls, and the game log: the summary records and the goal, assist,\n'
                   'penalty and injury events that the summary screens read.',
 'engine/penalty': 'Penalties. The time left in the period, calling a penalty, the box, who is released, the power play,\n'
                   'and the penalty shot (95G engine/penalty95).',
 'engine/lines': 'Building lines. Sorting the players by position, the default lines, filling and refilling each slot,\n'
                 'and which players can be removed (95G engine/lines95).',
 'engine/overlay': 'Drawing over the rink. The window onto the ice, the text overlays, the referee\'s call and goalie\n'
                   'banners, and the team palettes.',
 'engine/replay': 'Recording and stepping instant replay, and the objects at the side of the rink (95G engine/replay95).',
 'pc/input_events': 'Joystick calibration, the mouse and keyboard event queue, drawing a menu bar, and polling the devices.',
 'pc/league_db': 'The league databases. The Central Registry menu, the free agent and roster lists, loading, saving and\n'
                 'freeing the databases in memory, and the record pointers.',
 'front/create': 'Edit Rosters and Create Player. The roster panel, lines, free agents, ratings, which hand a player\n'
                 'shoots with, and his jersey number (95G front/create95).',
 'front/lines': 'The league line editor from Edit Rosters. Scratch, dress, and the roster printout.',
 'front/game_lines': 'The in-game line editor: jerseys, using or saving a set of lines, and whether the roster is complete.\n'
                     'One module, with its own copies of the line editor strings.',
 'front/replay_controls': 'The instant-replay panel and its gadgets, the rock music played for a team, and saving a\n'
                          'highlight and playing one back from the reel. One module (DrawGadgetButton\'s exit).',
 'front/lockerroom': 'The pre-game locker room and the settings art.',
 'pc/sound_config': 'Choosing a sound card: the dialog, and writing that choice to NHL.CFG.',
 'front/announcer': 'The announcer. The timer that feeds the speech queue, the speech bank, loading samples into memory\n'
                    'and finding a free slot, and building a sentence from clips for a goal, a penalty, a score, and the\n'
                    'playoff round. One module (ShutdownSpeech\'s exits).',
}

LABEL = re.compile(r'^([A-Za-z_][\w@$?]*):')
ADDR = re.compile(r';\s*([0-9A-F]{5})\s*$')
TOK = re.compile(r'[A-Za-z_][\w@$?]*')


def git(*a):
    return subprocess.run(['git'] + list(a), cwd=ROOT, check=True, capture_output=True, text=True).stdout


def data_size(l):
    """bytes of a db / dd / dw line without an address (padding, jump tables)"""
    s = l.split(';')[0].strip()
    if s.startswith('db '):
        n = 0
        for it in re.findall(r"'[^']*'|[^,]+", s[3:]):
            it = it.strip()
            n += len(it) - 2 if it.startswith("'") else 1
        return n
    if s.startswith('dd '): return 4 * len(s[3:].split(','))
    if s.startswith('dw '): return 2 * len(s[3:].split(','))
    return 0


def read_rows():
    return [l.split() for l in open(os.path.join(SRC, 'segments.txt')) if l[:1] in '12']


def parse(path):
    """(header comment lines, extern names, global names, body lines)"""
    L = open(path).read().split('\n')
    if L and L[-1] == '': L = L[:-1]
    hdr, ext, glb = [], [], []
    k = 0
    while k < len(L) and L[k].startswith(';'): hdr.append(L[k]); k += 1
    while k < len(L) and (L[k] in ('bits 32', '%include "hockey.inc"') or L[k].startswith(('section ', 'extern ', 'global '))):
        if L[k].startswith('extern '): ext += [x.strip() for x in L[k][7:].split(',')]
        if L[k].startswith('global '): glb += [x.strip() for x in L[k][7:].split(',')]
        k += 1
    return hdr, ext, glb, L[k:]


def cut_index(body, label):
    """index in body of the first line that belongs to the function starting at label: back over its C switch,
    `; C:` line, comments, jump tables and padding, up to the previous block's %endif or addressed line"""
    i = next((k for k, l in enumerate(body) if l == label + ':'), None)
    if i is None: return None
    k = i
    while k > 0:
        p = body[k - 1]
        if ADDR.search(p) or p.startswith('%endif'): break
        k -= 1
    return k


def wrap(kw, names):
    out = []
    for j in range(0, len(names), 8):
        out.append('%s %s' % (kw, ', '.join(names[j:j + 8])))
    return out


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--dry-run', action='store_true')
    a = ap.parse_args()
    rows = read_rows()
    code = [r for r in rows if r[0] == '1']
    files = [(r, r[5][7:-4]) for r in code]                     # (row, module path)
    old = {}
    for r, m in files: old[m] = parse(os.path.join(SRC, r[5]))
    for m in REMOVE: assert m in old, m
    # the stream: every old body in link order, with its start
    stream = []          # (line, old module)
    starts = []          # (stream index, new module, start address or None, old module whose start it is)
    for r, m in files:
        hdr, ext, glb, body = old[m]
        if m not in REMOVE:
            starts.append((len(stream), RENAME.get(m, m), int(r[1], 16), m))
        stream += [(l, m) for l in body]
    lines = [l for l, _ in stream]
    for lab, new in CUTS:
        idx = [k for k, l in enumerate(lines) if l == lab + ':']
        assert len(idx) == 1, (lab, idx)
        k = idx[0]
        while k > 0 and not (ADDR.search(lines[k - 1]) or lines[k - 1].startswith('%endif')): k -= 1
        assert stream[k][1] == stream[idx[0]][1], 'cut %s crosses an old file boundary' % lab
        # start address: the first addressed line after the cut, less the data bytes in between
        j = k; nbytes = 0
        while not ADDR.search(lines[j]): nbytes += data_size(lines[j]); j += 1
        starts.append((k, new, int(ADDR.search(lines[j]).group(1), 16) - nbytes, None))
    starts.sort()
    names = [s[1] for s in starts]
    assert len(names) == len(set(names)), 'duplicate new file'
    end_code = int(code[-1][2], 16)
    new = []             # (module, start, end, body lines, old modules)
    for i, (k, m, st, om) in enumerate(starts):
        k2 = starts[i + 1][0] if i + 1 < len(starts) else len(stream)
        en = starts[i + 1][2] if i + 1 < len(starts) else end_code
        part = stream[k:k2]
        new.append((m, st, en, [l for l, _ in part], sorted({o for _, o in part}), om))
    # labels: definer of every non-local label (new layout), and old declarations
    defined = {}
    for m, st, en, body, oms, om in new:
        for l in body:
            x = LABEL.match(l)
            if x: defined.setdefault(x.group(1), m)
    allglob_old = set(); allext_old = {}
    for m, (hdr, ext, glb, body) in old.items():
        allglob_old.update(glb); allext_old[m] = ext
    # data and other non-code globals stay declared where they were
    dataglob = set()
    for r in rows:
        if r[0] == '2':
            dataglob.update(parse(os.path.join(SRC, r[5]))[2])

    def inc_tokens(body):
        t = set()
        for l in body:
            x = re.match(r'%include "(c/[^"]+\.inc)"', l.strip())
            if x:
                p = os.path.join(ROOT, 'build', x.group(1))
                if not os.path.isfile(p): sys.exit('%s missing: run a CBUILD=1 build first' % p)
                t.update(TOK.findall(open(p).read()))
        return t

    incnames = set()
    for f in ('structs.inc', 'x86enc.inc'):
        incnames.update(TOK.findall(re.sub(r';.*', '', open(os.path.join(SRC, 'inc', f)).read())))
    uses = {}
    for m, st, en, body, oms, om in new:
        t = set()
        for l in body:
            s = l.split(';')[0]
            if s.startswith('%include'): continue
            t.update(TOK.findall(s))
        t |= inc_tokens(body)
        for o in oms: t.update(allext_old[o])        # what the old files declared (harmless if unused)
        uses[m] = t
    out = {}
    for m, st, en, body, oms, om in new:
        here = {n for n, d in defined.items() if d == m}
        glb = [n for n in dict.fromkeys(n for n, d in defined.items() if d == m)
               if n in allglob_old or any(n in uses[o] for o in uses if o != m)]
        # keep the order of definition
        order = {}
        for l in body:
            x = LABEL.match(l)
            if x and x.group(1) not in order: order[x.group(1)] = len(order)
        glb.sort(key=lambda n: order[n])
        ext = sorted((n for n in uses[m] if n not in here and n not in incnames and (n in defined or n in dataglob or n in allglob_old)),
                     key=lambda n: n.lower())
        if om is not None and m not in HEADER: hdr = old[om][0]
        else:
            assert m in HEADER, 'no header for %s' % m
            hdr = ['; ' + x for x in HEADER[m].split('\n')]
        txt = hdr + ['bits 32', '%include "hockey.inc"', 'section s_%05X progbits alloc exec nowrite align=1' % st]
        txt += wrap('extern', ext) + wrap('global', glb) + body
        out[m] = (st, en, '\n'.join(txt) + '\n')
    # C files: follow the asm file that holds the file's own function
    cmove = {}
    for c in sorted(glob.glob(os.path.join(SRC, 'c/**/*.c'), recursive=True)):
        rel = os.path.relpath(c, os.path.join(SRC, 'c')).replace(os.sep, '/')
        stem, fn = rel.rsplit('/', 1)
        if stem == 'include' or stem.startswith('include/'): continue
        f = fn[:-2]
        d = defined.get(f)
        if d is None:   # file named after a label that is not a function start (e.g. main_): keep with its asm
            d = RENAME.get(stem, stem) if stem not in REMOVE else None
            if d is None: sys.exit('C file %s: no home' % rel)
        if d != stem: cmove['%s/%s' % (stem, f)] = '%s/%s' % (d, f)
    print('%d code files -> %d; %d C files move' % (len(files), len(new), len(cmove)))
    for m, st, en, body, oms, om in new:
        if [m] != oms or RENAME.get(oms[0], oms[0]) != m:
            print('  %-24s %05X-%05X from %s' % (m, st, en, ', '.join(oms)))
    if a.dry_run: return
    # write asm (old files first removed from the index, then the new ones added: git sees the renames)
    for r, m in files: git('rm', '-q', '--cached', 'src/' + r[5]); os.remove(os.path.join(SRC, r[5]))
    pat = re.compile(r'(?<![\w])c/(' + '|'.join(re.escape(k) for k in sorted(cmove, key=len, reverse=True)) + r')(?=[.])') if cmove else None
    for m, (st, en, txt) in out.items():
        if pat: txt = pat.sub(lambda x: 'c/' + cmove[x.group(1)], txt)
        p = os.path.join(SRC, 'cseg01', m + '.asm')
        os.makedirs(os.path.dirname(p), exist_ok=True)
        open(p, 'w').write(txt)
        git('add', p)
    # C files
    for o, n in cmove.items():
        s, d = os.path.join(SRC, 'c', o + '.c'), os.path.join(SRC, 'c', n + '.c')
        os.makedirs(os.path.dirname(d), exist_ok=True)
        git('mv', s, d)
    # segments.txt
    seg = open(os.path.join(SRC, 'segments.txt')).read().split('\n')
    hdrl = [l for l in seg if l.startswith('#')]
    oldmod = {int(r[1], 16): r[4] for r in code}
    newcode = ['1 %05X %05X %d %s %s' % (st, en, en - st, oldmod.get(st, m.replace('/', '_')), 'cseg01/%s.asm' % m)
               for m, (st, en, txt) in out.items()]
    data = [' '.join(r) for r in rows if r[0] == '2']
    open(os.path.join(SRC, 'segments.txt'), 'w').write('\n'.join(hdrl + newcode + data) + '\n')
    # segmap95pc.json
    sm = json.load(open(os.path.join(ROOT, 'segmap95pc.json')))
    base = sm['cseg01'][0]
    off = base['file_start'] - base['start']
    oldseg = {s['start']: s for s in sm['cseg01']}
    lst = []
    for m, (st, en, txt) in out.items():
        s = dict(oldseg.get(st, {}))
        s.update(obj=1, start=st, end=en, module=s.get('module', m.replace('/', '_')), file_start=st + off, file_end=en + off,
                 file_bytes=en - st, size=en - st)
        if st not in oldseg:
            s.update(desc=HEADER.get(m, '').replace('\n', ' '), conf='module evidence', group=m.split('/')[0])
        lst.append(s)
    sm['cseg01'] = lst
    json.dump(sm, open(os.path.join(ROOT, 'segmap95pc.json'), 'w'), indent=1)
    # text that names a moved C file, and c_functions.csv
    if cmove:
        pat2 = re.compile(r'(?<![\w])(' + '|'.join(re.escape(k) for k in sorted(cmove, key=len, reverse=True)) + r')(?=\.(?:c|inc|\w+\.inc)\b)')
        for f in git('ls-files').split('\n'):
            if not f.endswith(('.asm', '.md', '.csv', '.txt', '.c', '.py', '.json')) or f.startswith('src/cseg01/'): continue
            p = os.path.join(ROOT, f)
            if not os.path.isfile(p): continue
            t = open(p, errors='surrogateescape').read()
            t2 = pat2.sub(lambda x: cmove[x.group(1)], t)
            if t2 != t: open(p, 'w', errors='surrogateescape').write(t2)
    cf = os.path.join(ROOT, 'tools/c_functions.csv')
    R = list(csv.DictReader(open(cf, newline='')))
    for r in R:
        fn = r['function'].split()[0]
        if fn in defined: r['segment'] = defined[fn]
    w = csv.DictWriter(open(cf, 'w', newline=''), fieldnames=list(R[0].keys()), lineterminator='\n')
    w.writeheader(); w.writerows(R)


if __name__ == '__main__':
    main()
