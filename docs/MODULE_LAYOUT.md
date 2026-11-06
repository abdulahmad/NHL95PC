# Module layout: how the NHL 95 PC programmers probably laid out their source

The analysis behind the file layout of `src/cseg01` (step F4).

## Short answer

* **Yes, bigger groups make sense, but they should be the PC's own groups, not 95G's.** The EXE was linked from Watcom C modules, and each module is still one unbroken stretch of code. The compiler left clues that show which functions shared a `.c` file. Those clues prove 84 multi-function modules in the game code, holding 821 of its 1,163 functions. The largest one has 57 functions.
* **The PC modules don't follow the 95G files.** For example, the proven module `burst` .. `ReturnGoalies` (now `engine/collide.asm`) is one C file. It holds routines that 95G keeps in `collide95` (20), `input95` (10), `logic95` (7) and `penalty95` (4). If we filed each function under its 95G (or 94G) file, as on the card I sent earlier, we would tear real modules apart. That's why I'm changing my recommendation (see the end).
* **The current 95PC files are cut in the wrong places in 17 spots.** In each spot, one proven module runs across two files, so 12 groups of current files should be joined. Several other files hold more than one module.

## The clues

| clue | why it shows one module | count |
|---|---|---|
| shared exit: a jump into another function's tail (`X_popx`, `X_ret`, `loc_` inside it) | Watcom merges tails only inside one compilation unit | 402 pairs |
| one string literal used by two functions | each module has its own literal pool | 4,065 data labels read, 1,316 in the literal pool |
| literal pool order | the linker puts each module's literals (CONST) in link order, so a later function that uses an earlier literal must be in the same module | used as a check (0 conflicts) |
| matched C files with more than one function | 76 matched `.c` files hold 2+ functions, and they only match when built together | 76 files |
| the same string text stored twice | Watcom keeps one copy per module, so two copies mean two modules | 147 pairs: only 2 clash with the rules above |

None of this can prove where a module **ends**. Of the duplicate-string pairs, only 6 pin down an exact boundary. So these are minimum groups: two neighbouring groups might still be one file.

## The joins of current files (corrected in the review below)

Each row is one proven module that runs across these current files:

| files to join | proof |
|---|---|
| front/main + pc/gamesave_io + front/stats_team + pc/asset_loading | shared exits (HandleHotKey_ret, PickAwardWinners_x), the awards C file |
| pc/file_utils + front/scoreboard + front/title | shared exits, DrawHudPanel and RunDemoGame C files |
| pc/output_files + pc/palette_fx | shared exits, one C file |
| front/desk_main + pc/temp_files | MainDeskLoop's shared exits |
| front/calendar + pc/import_export | a shared literal |
| engine/init + engine/logic | intro and three stars: FadeOutPalCycle's C file |
| engine/input + engine/faceoff | lineinput .. asspassrec |
| pc/joystick_calibration + pc/database_save + front/create | shared exits, one C file |
| front/lines (from GameLineEditor) + front/team_select | shared literals. A moved cut, not a join: the league line editor is its own module (review) |
| engine/replay + front/highlights | DrawGadgetButton's C file |
| pc/sound_config + front/speech + front/announcer | one speech module (ShutdownSpeech.c) |

## What the engine probably looked like (EXE order)

These are the proven groups plus the single functions between them, named by what they do:

| EXE range | likely PC module | holds | 95G files its functions come from |
|---|---|---|---|
| 47C31-499D7 | pre-game intro, three stars | FadeOutPalCycle .. assthreestars (15) | PC only |
| 499D8-4FCE7 | assignments | assboxenter, assdefd .. assrefgoalline (47), asspenshooter | logic95, faceoff95 |
| 4FCE8-51114 | input, line changes | joyq_*, lineinput .. asspassrec (17) | lines95, input95, control95, video95 |
| 51115-53293 | faceoff | TakePlayerFromBox .. asstakeposition (10), assrefpenshot | faceoff95 |
| 53294-59492 | puck, pass, shot and CPU control | burst .. ReturnGoalies (57), ChkPullGoalieLate | collide95, input95, logic95, penalty95 |
| 59493-59D99 | sound, crowd and announcer hooks | SndLoadFile, Crowd_Noise, Pa* | sound95 |
| 59D9A-5E16C | players, game setup, periods | SetSPA .. ResetBench (51), StartGame | middle95, players95, goal95, hockey95 |
| 5E16D-5FB02 | skating | doplayeracc, EvadePlayers .. stopna (9), goalieacc | skate95, logic95 |
| 614C2-644A7 | rink objects, deferred calls, penalties, penalty shot | RunDeferredCalls .. (13), InProgress .. ShotLaneOpen (16) | penalty95, lines95 |
| 644A8-6733x | lines, banners, team palette | BuildDefaultLines .. (11), checkwindow .. DrawCallBanner (6) | PC only, goal95 |
| 67564-69335 | replay steps | ReplayRecordReset .. ReplayStep | PC only |

The PC programmers seem to have grouped the engine by jobs of their own. Each job pulls from several 95G files, the same way 95G pulls from several 94G files.

## What this means for "make them match"

* **Folders follow the PC modules.** One file per reconstructed module, in EXE order. The folder and file names use the 95G or 94G subsystem name where a module is clearly that job (`engine/skate`, `engine/faceoff`, `engine/assign`). Otherwise the name says what the module does (`engine/puckcontrol`).
* **Cross-game matching lives in the names, not the files.** Each function keeps its 94G name. The report already shows where each one lives in 94G, 95G and 94S, and `95pc_engine_files.csv` lists all four homes.
* **No regressions.** It's only text moves: the bytes, the C files and the matched set stay the same. Every step must build MATCH in both builds (CBUILD=1 and 0), and the number of matched functions in `tools/match/c_functions.csv` must stay at 922.

Applied on 2026-11-03 by `tools/build/recut_modules.py` (step F4). The file list it produced is below.

## The file names (game code)

Each row is one new file, in EXE order. **From** says how it's made from today's files:
* **keep**: same file, same name.
* **rename**: same file, new name.
* **join**: today's files merged.
* **move cut**: the boundary with a neighbour moves to where a proven module ends.
* **split**: a topic split inside one file. The compiler evidence allows it but doesn't prove it.

**Name source**: a 95G file name (dropping the `95`) wherever the file does that 95G job. Otherwise a name for the PC's own job, using the folder rule from AGENTS.md: `engine/`, `front/`, `pc/` (DOS-only) and `lib/`. Nothing changes in `lib/`.

Everything here only moves text between files. The bytes, the C files and the 922 matched functions stay the same.

### Engine

| new file | from | holds | name source |
|---|---|---|---|
| `engine/intro` | move cut: `engine/init`, plus the start of `engine/logic` | FadeOutPalCycle, PreGameIntro, the three stars (to assthreestars) | PC job (one proven module) |
| `engine/logic` | move cut | the assignments: assboxenter .. asspenshooter | 95G `logic95` (24 of its named functions) |
| `engine/input` | move cut: `engine/input`, plus the start of `engine/faceoff` | joyq_*, lineinput, doinput, ReadJoy1/2, PassCompleted, assonetimer, asspassrec | 95G `input95` (one proven module up to asspassrec) |
| `engine/faceoff` | move cut | TakePlayerFromBox .. asstakeposition, puckfaceoff, assrefpenshot | 95G `faceoff95` |
| `engine/collide` | keep | burst .. ReturnGoalies: checking, passing, shooting, offsides, puck (one 57-function module) | 95G `collide95` (21; input95 10, logic95 7) |
| `engine/sound` | keep | samples, crowd noise, sfx, the Pa* announcer hooks | 95G `sound95` |
| `engine/hockey` | keep | SetSPA .. forcepldata: players, line energy, coach modes, clock, game frame, setupice | 94G `hockey94` (10) / 95G `players95` (8) |
| `engine/skate` | keep | doplayeracc .. noturn0 | 95G `skate95` |
| `pc/game_saveload` | keep | SaveGameState, LoadGameState | PC job |
| `engine/gamelog` | split from `engine/penalty` | rink objects, deferred calls, the game summary records and events (to QueueGoalieNote) | PC job: it feeds the summary screens |
| `engine/penalty` | split, rest of `engine/penalty` | GetPeriodTimeRemaining, AddPenalty .. ShotLaneOpen, penalty shot | 95G `penalty95` (12) |
| `engine/lines` | split from `engine/video` | SortPlayersByPos .. CanRemovePlayer: building and filling lines | 95G `lines95` (the job) |
| `engine/overlay` | split from `engine/video` | DitherRect, checkwindow, text overlays, call and goalie banners, LoadTeamPalette | PC job |
| `engine/replay` | split from `engine/video` | ReplayRecordReset .. ReplayStep, DrawRinkSideObjects | 95G `replay95` (record and step) |
| `pc/debug_dump` | keep | DebugMonitor, DumpStatsLog | PC job |
| `engine/frame` | keep | StartHL2 | PC job |
| `engine/asm_helpers` | keep | PlayMVI, randomd0, vtoa (hand asm) | PC job |

### Front end

| new file | from | holds | name source |
|---|---|---|---|
| `front/main` | move cut: `front/main`, plus the start of `pc/gamesave_io` | main_, the pad readers, HandleHotKey, Gameloop, PlayGame, assinsert/assreplace | 95G `main95` |
| `front/awards` | join: the end of `pc/gamesave_io`, `front/stats_team`, the start of `pc/asset_loading` | PickAwardWinners, ShowAwardScreens, DrawAwardsSummary, AwardsCeremony | 95G `front/awards95` |
| `pc/asset_loading` | move cut | photo banks, LoadGameGfx, SetupGame | PC job |
| `pc/file_utils` | move cut | MakePath .. GetLeagueDBSizes: file and record I/O | PC job |
| `front/scoreboard` | move cut: the panel functions of `pc/file_utils`, plus `front/scoreboard` | DrawPanelScore .. DrawPanelPenalties, the cup series helpers | PC job (the HUD panel) |
| `front/title` | move cut | RunDemoGame .. ShowCredits, title, intro | 95G `front/title95` |
| `front/desk_stats` | join `pc/output_files` + `pc/palette_fx` | WriteScreenTextFile, DeskSetExit*, StatsSel*, StatsMenu*, FreeDeskBuffers | PC job (the desk's stats menu, one module) |
| `front/desk` | keep | the sports desk | PC job |
| `front/team_db` | keep | LoadGameTeams, rosters, game summary path | PC job |
| `front/screen_util` | rename `front/labels` | DrawSprite*, AddDirtyRect, SetScreenTitle*, stats source menus | PC job (`labels` doesn't describe it) |
| `front/menu` | keep | RunMenu, team and player pick menus | PC job |
| `front/stats_screens` | rename `front/stats_easn` | the Game*, Easn* and Cal* stats and standings screens | PC job |
| `front/stats` | keep | stats cards, team stats, rosters, leaders | 95G `front/stats95` |
| `front/playoff` | keep | StandingsScreen, the playoff tree screen | 95G `engine/playoff95` (the playoff tree screen) |
| `front/league_tree` | rename `front/schedule_league` | LoadPlayoffModeTree, LoadLeagueTree, FitPlayerName, DrawBevelBox | PC job |
| `front/pregame` | rename `front/arena_logos` | PreGameScreen, TonightsGameScreen | PC job |
| `pc/file_dialogs` | keep | the saved game file dialog | PC job |
| `front/summary` | rename `front/setup` | GameSummaryScreen, other scores, GameStatsScreen | 95G `front/summary95` |
| `pc/dialogs` | rename `pc/misc_dialogs` | text input, list, buttons, scroll bars, message box | PC job |
| `front/desk_main` | join `front/desk_main` + `pc/temp_files` | MainDeskLoop and every Menu* item of the main desk | PC job (one module) |
| `front/rink_tiles` | keep | LoadRink, BlitTileMap | PC job |
| `front/calendar` | join `front/calendar` + `pc/import_export` | the calendar, PlayLeagueGame, the team grid | PC job (one module) |
| `front/league_setup` | rename `front/season_setup` | league team select, the season records, passwords | PC job |
| `pc/database_merge` | keep | merge, import, export, floppy | PC job |
| `pc/config_cfg` | keep | LoadNhlCfg | PC job |
| `front/trade` | rename `front/roster`, plus TradePlayers from `front/trade` | the trade screen | 95G `front/trade95` |
| `front/league_teams` | rename the rest of `front/trade` | add or remove human team, league info, copy team databases | PC job |
| `front/season` | rename `front/schedule` | the season schedule, simulating the other games, the season playoffs, CreateNewLeague | 95G `front/season95` |
| `front/simgame` | rename `front/optsetup` | SimulateGame, the loading screen | PC job |
| `pc/input_events` | move cut: the first half of `pc/joystick_calibration` | the joystick calibration, the input event queue, the menu bar, polling | PC job |
| `pc/league_db` | move cut: the end of `pc/joystick_calibration`, plus `pc/database_save` up to RunEditRosters | MenuCentralRegistry, the league databases in memory, save, the record pointers | PC job |
| `front/create` | move cut: from RunEditRosters | edit rosters, create player | 95G `front/create95` |
| `pc/database_dialogs` | keep | the database open dialog | PC job |
| `front/lines` | move cut | the league line editor: DbLineEditor .. PrintLineEdStatus | PC job |
| `front/game_lines` | move cut: from GameLineEditor, plus `front/team_select` | the in-game line editor | PC job (one module) |
| `pc/settings_dialogs` | keep | league, mode, exhibition settings, controls | PC job |
| `front/replay_controls` | join `engine/replay` + `front/highlights` | the replay gadgets, InstantReplay, saving and viewing highlights | PC job (one module) |
| `front/lockerroom` | move cut | the settings shapes, the locker room (to DrawSelBoxOff) | PC job |
| `pc/sound_config` | move cut: the sound card dialog of `front/lockerroom`, plus SoundCardDlgLoop and SetSoundDevice | MenuSoundSettings .. SetSoundDevice | PC job |
| `front/announcer` | join `front/speech` + `front/announcer`, plus the speech start of `pc/sound_config` | the speech queue, the sample cache, every Say* clip | PC job (one speech module) |
| `front/savegame` | rename `pc/demo_savegame` | MenuSaveGame, SaveGameNameDlg, next game | PC job |
| `front/playoff_mode` | rename `front/season` | CreatePlayoffs, the PO* functions, the playoff tree menu: the PC's own Playoffs mode | PC job |
| `pc/file_locations` | rename `pc/allfiles_coach` | InitFileLocations, CoachCutScene | PC job |

### Count

The game code goes from 59 files to 60. Each file now does one job, and no proven module is cut in two.

### Open points

* The `split` rows (summary/penalty, lines/display/replay) follow the topic. The compiler proves that each part's core is one module, but not exactly where one part stops and the next starts. I put each cut between the last function of one proven group and the first of the next.
* `front/scoreboard` and `pc/file_utils` are one proven chain (file_utils ends inside the panel module). I keep them apart at the panel's first function, which the evidence allows.

### Review (2026-11-03)

I checked every cut against the compiler evidence, and every name against the header of the 95G file it borrows from. Ten changes, all applied above:

1. **`front/lines` + `front/team_select` is not one module.** Both line editors have their own copies of `lelogo` and `%c %2d %s`, and Watcom keeps only one copy per module. So it's a moved cut: the league editor stays in `front/lines`, and the in-game editor (from GameLineEditor) becomes `front/game_lines`.
2. **`engine/video` + `pc/debug_dump` was a false join.** My scan had missed DebugMonitor as a function start. `pc/debug_dump` stays as it is.
3. **`engine/summary` is now `engine/gamelog`.** That avoids two `summary` files. The 95G `summary95` is the screen, which is the PC's `front/summary`.
4. **`engine/display` is now `engine/overlay`.** The 95G `display95` places and animates the sprites, and the PC does that in `engine/hockey`.
5. **`front/playoff` keeps its name.** The 95G `playoff95` is the playoff tree screen, which is what this file holds.
6. **`front/schedule` is now `front/season`** (the 95G `season95` plays out the computer's games and the season playoffs). The 95G `schedule95` is only the schedule data.
7. **`front/season` is now `front/playoff_mode`.** It's the PC's own Playoffs mode, which has no 95G file.
8. **`pc/input` is now `pc/input_events`,** so it isn't confused with `engine/input`.
9. **`front/stats_menu` is now `front/desk_stats`,** since it's the sports desk's stats menu.
10. **`front/replay` is now `front/replay_controls`.** `engine/replay` is the record and step side.

What the check confirmed:

* All 15 cross-file links behind the joins and moved cuts are shared exits that jump from one file into a tail in the other (for example, 17 jumps from `assonetimer` into `CanBlockShot_ret5`). The exception is `front/calendar` + `pc/import_export`, which rests on one shared `!pal` string. That still counts: every screen module has its own copy of `!pal` (22 copies in all), so sharing one means sharing a module.
* No proposed cut falls inside a proven module.
* The moves in `pc/sound_config` and `front/lockerroom`, and the topic splits (`engine/gamelog`/`penalty`, `engine/lines`/`overlay`/`replay`), are allowed by the evidence but not proven by it.
