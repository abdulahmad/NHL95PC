# Lanes: two contributors in parallel

Snapshot of 2026-10-23: **932 / 1,084** compiled-C game functions matched under Watcom 10.0 GA, **152** drafts left.
Contributors: MHopkins (Mhopkinsinc) and StaticECK. They split the drafts by segment, and each can run several
agents in their own worktrees. The rule in [AGENTS.md](../AGENTS.md) points here.

## The plan in short

1. **One integration repo:** upstream `abdulahmad/NHL95PC` `main`. Both contributors open PRs into it, and nobody
   works off a fork's `main` any more.
2. **Two lanes by segment:**
   * Lane 1: segments 001-037, 72 drafts.
   * Lane 2: segments 038-066, 80 drafts.

   The two lanes are balanced on weighted difficulty. The lanes swap after each round.
3. **CI:** it runs `make fullcheck` on every PR and on every push to `main`. A PR is merged only when it is green.
4. **Lane PRs carry only code and per-function notes.** A small bookkeeping PR after each round updates the
   generated progress files.

## Owner notes

* `main` is protected (no deletions, no force pushes, PRs required, status check `fullcheck` required) and takes
  merge commits only (no squash or rebase): every commit is verified to build MATCH on its own.

**Day to day:**

* Merge green PRs, or let the lane owners do it (if the ruleset allows 0 approvals).
* Look closer at PRs that change headers (`src/c/include/`) or `tools/`, because they can affect the other lane.
* If GitHub reports a conflict in `tools/permute_log.csv` or `docs/unsure_tried.csv`, the PR author merges upstream
  `main` into the branch locally and pushes. The union merge in `.gitattributes` resolves these files locally;
  GitHub's merge button may not apply it.
* If CI on `main` goes red, fix that before merging anything else.

## For contributors: setup

1. **Set up the toolchain** as in HANDOFF.md section 1, in WSL or Linux: nasm, DOSBox 0.74, Python 3 with
   capstone. The compiler is in the repo.
2. **Clone upstream** and check that both of these end in `MATCH`:

   ```
   git clone https://github.com/abdulahmad/NHL95PC ~/work/NHL95PC && cd ~/work/NHL95PC
   make fullcheck
   NHL95_CC_CACHE=$(mktemp -d) make fullcheck     # fresh compile cache
   ```

   MHopkins: fast-forward the existing clone to upstream `main` and branch from there.
3. **Per batch,** branch from fresh upstream `main`, with one worktree per agent:

   ```
   git fetch origin
   git worktree add ~/work/np-1a -b lane1a/batch1 origin/main
   ```

   Push the branch and open a PR into `abdulahmad/NHL95PC` `main`. After it merges, delete the branch and start the
   next batch from fresh `main`.
4. **If `main` moved under an open PR,** merge `main` into the branch. Do not rebase a pushed branch, and never
   force-push.

## Lanes

| Lane | Proposed owner | Segments | Drafts | 15 or fewer | 16-100 | over 100 |
|---|---|---|---:|---:|---:|---:|
| 1 | MHopkins | 001-037 (frontend, menus, stats, desk, calendar, rosters, trades, schedule, engine init / player logic) | 72 | 31 | 28 | 13 |
| 2 | StaticECK | 038-066 (engine input, physics, skating, penalties, display; create player, line editor, replay, speech, playoffs) | 80 | 23 | 50 | 7 |

Swap the owners if you prefer; the lanes swap after each round anyway.

* **Why by segment:** a match commit touches only `src/c/<seg>/X.c` and its marker in `src/cseg01/<seg>.asm`.
  Shared exits, cross-jumps and module files only interact inside a segment or between neighbouring segments.
* **No file crosses the lane boundary:** no C file in `tools/c_functions.csv` marks functions in both lanes.
* **No duplicated permuter work:** each lane's `permute.py` history covers only its own functions.

Each lane also splits in two for parallel agents:

* Lane 1: 1a = 001-023 (32 drafts), 1b = 024-037 (40).
* Lane 2: 2a = 038-046 (40), 2b = 047-066 (40).

One agent per sub-lane and worktree.

The scores are aligned differing-instruction counts from `tools/rank_drafts.py` (`build/permute/ranked_ga18.txt`).
The notes in UNSURE.md sometimes count a little differently. Rerun `rank_drafts.py` at the start of each round.

## Rules for lane PRs

* **Stay in your lane's segments.** If a fix needs the other lane's files, say so in the PR and agree on it first.
* **A lane PR contains:**
  * C files.
  * Segment asm markers (`cc.py mark`).
  * UNSURE notes for its own functions, in their own commit, written inside each function's entry rather than as a
    new section at the end of the file.
  * Its `permute.py` log rows.
* **A lane PR does not contain** `C_PROGRESS.md`, `tools/c_functions.csv`, `HANDOFF.md` or `README.md`. They go in
  the bookkeeping PR.
* **Headers** (`src/c/include/`): their own commit, called out in the PR description. A header change, such as a
  function's result type, can change code in the other lane.
* **Renames:** list them in the PR description and leave them out of the code. The bookkeeping PR runs them in one
  `tools/rename_symbol.py --batch`.
* **Tool changes** (`cc.py`, `permute.py`, `tools/wccre`): their own PR.
* **Every commit** builds MATCH with `make` and `make CBUILD=0`. Use small commits per function or per batch.
* **The usual matching rules** (AGENTS.md, HANDOFF):
  * Timebox each function to about 8-10 minutes.
  * Run `tools/wccre/regdump.py` first on a register-pick draft.
  * Never retry a shape that UNSURE lists under GA.
  * Reject `permute.py` finds that go against the EXE's statement order.
* **Read each draft's DRAFT comment and its UNSURE entry before starting.** Known flags:
  * assbench (lane 1): a no-op `& 0xFF` mask to remove before marking.
  * LeadersScreen (lane 1): a `goto done` for the EXE's loop rotation; judge it before marking.
  * ExecuteTrade (lane 1): matched only with an `unsigned short` result, which its caller rules out.
  * InProgress (lane 2): word_CBC44 declared `extern volatile short` in that file only.
* **Known dependencies:**
  * DrawListItems (lane 1) already compiles to the EXE bytes but waits for DrawListItem.
  * CreatePlayoffs and POAfterGame (lane 2) end in the matched POSeedRound2's exit.

## Rounds, bookkeeping and rotation

* **A round** is one pass of each lane over its drafts, or a fixed time box (a few days), whichever comes first.
* **Bookkeeping PR,** at the end of a round, by MHopkins (who has done it so far) unless agreed otherwise:
  * `python3 tools/c_progress.py` and `tools/draft_causes.py`.
  * The HANDOFF Current state / Next.
  * The README numbers.
  * The batched renames.
* **Then** rerun `rank_drafts.py` and swap the lanes. A different person, prompt or model on the same draft has
  found matches before (FindFreeSpeechSlot and FindLoadedSpeechSlot after two Claude passes, SetSoundDevice).
* **Optional tooling track:** 57 drafts are within 15 differing instructions, mostly register picks. A tool that
  reads the register each variable needs from the EXE, and ranks source edits by how they move the savings, could
  unlock several at once. Tools go in their own PR.
* **"Done":** HANDOFF step 5 says unmatchable functions (split or overlapping) become hand-asm, so the build stays
  byte-exact. Agree on a cutoff (for example, N passes with no gain) so the last few drafts do not drag on.

## Lane lists

Sorted by segment, then by differing instructions.

### Lane 1a: segments 001-023 (32 drafts)

| Segment | Function | Differing | C file |
|---|---|---:|---|
| 001_10010_main_startup | FadePalette | 7 | FadePalette.c |
| 002_1167B_gamesave_io | PickAwardWinners | 5 | PickAwardWinners.c |
| 002_1167B_gamesave_io | DrawAwardsSummary | 12 | PickAwardWinners.c |
| 002_1167B_gamesave_io | ShowAwardScreens | 31 | PickAwardWinners.c |
| 002_1167B_gamesave_io | GameLoop | 62 | GameLoop.c |
| 004_13320_asset_loading | PlacePlayersAtStart | 15 | PlacePlayersAtStart.c |
| 004_13320_asset_loading | ResetGameVars | 25 | ResetGameVars.c |
| 006_150C6_scoreboard_gfx | ShowCredits | 4 | RunDemoGame.c |
| 006_150C6_scoreboard_gfx | RunIntro | 5 | RunDemoGame.c |
| 006_150C6_scoreboard_gfx | TitleScreen | 13 | RunDemoGame.c |
| 010_18D7F_frontend_desk | SportsDesk | 632 | SportsDesk.c |
| 013_1BBCC_key_team_db | LoadTeamRoster | 72 | LoadTeamRoster.c |
| 014_1CC3D_frontend_labels | SetupStatsSourceMenu | 42 | SetupStatsSourceMenu.c |
| 014_1CC3D_frontend_labels | DrawSprite | 78 | DrawSprite.c |
| 015_1D6E8_menu_system | RunMenu | 146 | RunMenu.c |
| 015_1D6E8_menu_system | RunPlayerPickMenu | 158 | RunMenu.c |
| 015_1D6E8_menu_system | RunTeamPickMenu | 212 | RunMenu.c |
| 016_20016_easn_stats | EasnGoalieStatsScreen | 12 | EasnGoalieStatsScreen.c |
| 017_21CDE_player_stats | SkaterStatsCard | 7 | SkaterStatsCard.c |
| 017_21CDE_player_stats | TeamRosterScreen | 23 | TeamRosterScreen.c |
| 017_21CDE_player_stats | LeadersScreen | 123 | LeadersScreen.c |
| 017_21CDE_player_stats | TeamStatsScreen | 132 | TeamStatsScreen.c |
| 019_2970A_league_schedule | TreeSeriesWinner | 35 | TreeSeriesWinner.c |
| 020_29F18_arena_logos | PreGameScreen | 52 | PreGameScreen.c |
| 021_2B7B7_file_dialogs | SelectSavedFile | 15 | SelectSavedFile.c |
| 022_2D346_game_setup | PickOtherGames | 15 | PickOtherGames.c |
| 022_2D346_game_setup | GameStatsScreen | 20 | GameStatsScreen.c |
| 022_2D346_game_setup | GameSummaryScreen | 320 | GameSummaryScreen.c |
| 023_2FDD1_misc_dialogs | DrawListItems | 0 | DrawListItem.c |
| 023_2FDD1_misc_dialogs | ListDialog | 7 | ListDialog.c |
| 023_2FDD1_misc_dialogs | DrawListItem | 11 | DrawListItem.c |
| 023_2FDD1_misc_dialogs | EditTextField | 110 | EditTextField.c |

### Lane 1b: segments 024-037 (40 drafts)

| Segment | Function | Differing | C file |
|---|---|---:|---|
| 024_31AB5_main_desk | MainDeskLoop | 72 | MainDeskLoop.c |
| 026_3377C_rink_tiles | BlitTileMap | 5 | BlitTileMap.c |
| 026_3377C_rink_tiles | LoadRink | 14 | LoadRink.c |
| 027_33FFD_calendar | DrawCalendarDay | 44 | DrawCalendarDay.c |
| 027_33FFD_calendar | CalendarScreen | 319 | CalendarScreen.c |
| 028_35FB9_import_export | HighlightGridCell | 12 | HighlightGridCell.c |
| 028_35FB9_import_export | PlayLeagueGame | 28 | PlayLeagueGame.c |
| 028_35FB9_import_export | PostGameToTeamDb | 130 | PostGameToTeamDb.c |
| 029_380E9_league_setup | BuildStandingsGrid | 41 | BuildStandingsGrid.c |
| 029_380E9_league_setup | LeagueTeamSelect | 102 | LeagueTeamSelect.c |
| 030_3A9AA_database_merge | ExportTeamToFloppy | 11 | ExportTeamToFloppy.c |
| 032_3DC2C_roster_jersey | ExecuteTrade | 15 | ExecuteTrade.c |
| 032_3DC2C_roster_jersey | FixJerseyConflict | 20 | FixJerseyConflict.c |
| 032_3DC2C_roster_jersey | TradeHitTest | 21 | TradeHitTest.c |
| 032_3DC2C_roster_jersey | TradeDone | 22 | TradeDone.c |
| 032_3DC2C_roster_jersey | DrawTradeScreen | 46 | DrawTradeScreen.c |
| 032_3DC2C_roster_jersey | TradeScreenLoop | 183 | TradeScreenLoop.c |
| 033_40183_trades | TradePlayers | 3 | TradePlayers.c |
| 033_40183_trades | CopyHumanTeamDBs | 21 | CopyHumanTeamDBs.c |
| 034_41B80_schedule | SeedPlayoffFinal | 4 | SimPlayoffRound1.c |
| 034_41B80_schedule | SeriesLength | 10 | SeriesLength.c |
| 034_41B80_schedule | CreateNewLeague | 12 | CreateNewLeague.c |
| 034_41B80_schedule | SeedPlayoffRound3 | 14 | SimPlayoffRound1.c |
| 034_41B80_schedule | RandomizeSchedule | 15 | RandomizeSchedule.c |
| 034_41B80_schedule | SimPlayoffRound3 | 20 | SimPlayoffRound1.c |
| 034_41B80_schedule | SimPlayoffRound2 | 22 | SimPlayoffRound1.c |
| 034_41B80_schedule | SimPlayoffRound1 | 28 | SimPlayoffRound1.c |
| 035_45282_options_settings | ShowLoadingScreen | 5 | ShowLoadingScreen.c |
| 035_45282_options_settings | SimulateGame | 592 | SimulateGame.c |
| 036_47C31_engine_init | PickThreeStars | 32 | FadeOutPalCycle.c |
| 036_47C31_engine_init | assthreestars | 44 | FadeOutPalCycle.c |
| 037_4842A_engine_player_logic | assreffollow | 4 | assrefwhistle.c |
| 037_4842A_engine_player_logic | assshoot | 4 | assshoot.c |
| 037_4842A_engine_player_logic | SkateToSpot | 5 | SkateToSpot.c |
| 037_4842A_engine_player_logic | ass_pc_slot20 | 6 | ass_pc_slot20.c |
| 037_4842A_engine_player_logic | assintroline | 15 | assintroline.c |
| 037_4842A_engine_player_logic | assbench | 22 | assbench.c |
| 037_4842A_engine_player_logic | assgoalie | 25 | assgoalie.c |
| 037_4842A_engine_player_logic | assrefgoalpa | 67 | assgoalie.c |
| 037_4842A_engine_player_logic | StarCompare | 81 | StarCompare.c |

### Lane 2a: segments 038-046 (40 drafts)

| Segment | Function | Differing | C file |
|---|---|---:|---|
| 038_4FCE8_engine_input | PassRecOneTimer | 34 | CanBlockShot.c |
| 038_4FCE8_engine_input | CanBlockShot | 42 | CanBlockShot.c |
| 039_50AFE_engine_assign_faceoff | assrefpenshot | 7 | assrefpenshot.c |
| 039_50AFE_engine_assign_faceoff | puckfaceoff | 29 | puckfaceoff.c |
| 039_50AFE_engine_assign_faceoff | puckfaceoff2 | 92 | puckfaceoff.c |
| 040_53294_engine_physics_ai | checkob | 2 | checkob.c |
| 040_53294_engine_physics_ai | PassLaneChk | 4 | PassLaneChk.c |
| 040_53294_engine_physics_ai | checkgoal | 8 | checkgoal.c |
| 040_53294_engine_physics_ai | checkplcoll | 13 | checkplcoll.c |
| 040_53294_engine_physics_ai | checkwallcoll | 15 | checkwallcoll.c |
| 040_53294_engine_physics_ai | wallcoll | 16 | dopass.c |
| 040_53294_engine_physics_ai | dopass | 17 | dopass.c |
| 040_53294_engine_physics_ai | checkcx | 20 | checkcx.c |
| 040_53294_engine_physics_ai | shotdiradj | 23 | dopass.c |
| 040_53294_engine_physics_ai | checkgoalp | 27 | checkgoalp.c |
| 040_53294_engine_physics_ai | checkcheck | 32 | checkcheck.c |
| 040_53294_engine_physics_ai | NetCollide | 41 | PassLaneChk.c |
| 040_53294_engine_physics_ai | doshot | 47 | dopass.c |
| 040_53294_engine_physics_ai | passtoa0 | 48 | passtoa0.c |
| 040_53294_engine_physics_ai | checkpuckcoll | 73 | PassLaneChk.c |
| 042_59D9A_engine_core | changeplayer | 10 | changeplayer.c |
| 042_59D9A_engine_core | calcpuckcross | 16 | calcpuckcross.c |
| 042_59D9A_engine_core | StartPer | 34 | calcpuckcross.c |
| 042_59D9A_engine_core | DrawRinkOverlays | 73 | changeplayer.c |
| 042_59D9A_engine_core | setplayer | 98 | changeplayer.c |
| 043_5E16D_engine_skating | doplayeracc | 5 | doplayeracc.c |
| 043_5E16D_engine_skating | avdgoal | 155 | EvadePlayers.c |
| 044_5FB03_game_state_saveload | LoadGameState | 126 | SaveGameState.c |
| 045_614C2_scoring_penalty_text | PenGoalStuff | 19 | InProgress.c |
| 045_614C2_scoring_penalty_text | checkfornewpen | 32 | checkfornewpen.c |
| 045_614C2_scoring_penalty_text | ChkScorerMilestone | 36 | ChkScorerMilestone.c |
| 045_614C2_scoring_penalty_text | InProgress | 88 | InProgress.c |
| 046_644A8_engine_display | DrawTextOverlay | 13 | checkwindow.c |
| 046_644A8_engine_display | FillDressedSlots | 20 | CanFillLineSlot.c |
| 046_644A8_engine_display | PickForLineSlot | 20 | PickForLineSlot.c |
| 046_644A8_engine_display | updatereplay | 26 | updatereplay.c |
| 046_644A8_engine_display | CanFillLineSlot | 31 | CanFillLineSlot.c |
| 046_644A8_engine_display | RemoveFromLines | 40 | RemoveFromLines.c |
| 046_644A8_engine_display | ReplayStep | 46 | ReplayStep.c |
| 046_644A8_engine_display | DrawRinkSideObjects | 118 | ReplayStep.c |

### Lane 2b: segments 047-066 (40 drafts)

| Segment | Function | Differing | C file |
|---|---|---:|---|
| 047_688A4_debug_dump | DumpStatsLog | 21 | DebugMonitor.c |
| 048_69336_game_frame | StartHL2 | 51 | StartHL2.c |
| 050_6B093_joystick_calibration | JoystickCalScreen | 18 | JoystickCalScreen.c |
| 051_6C2F9_database_save | SelectRosterTeam | 14 | RunEditRosters.c |
| 052_6D2F8_create_player | CreateFreeAgent | 5 | CreateFreeAgent.c |
| 052_6D2F8_create_player | SelectMatchingPlayers | 7 | SelectMatchingPlayers.c |
| 052_6D2F8_create_player | RosterPanelClick | 9 | RosterPanelClick.c |
| 052_6D2F8_create_player | SetRosterTeamMenus | 11 | SetRosterTeamMenus.c |
| 052_6D2F8_create_player | MoveToOtherRoster | 27 | MoveToOtherRoster.c |
| 052_6D2F8_create_player | SwapSelectedPlayers | 50 | SwapSelectedPlayers.c |
| 052_6D2F8_create_player | EditSkaterRating | 57 | EditSkaterRating.c |
| 052_6D2F8_create_player | EditGoalieRating | 58 | EditSkaterRating.c |
| 052_6D2F8_create_player | EditRosters | 175 | EditRosters.c |
| 054_737AA_line_editor_rosters | ShowRosterStats | 20 | ShowRosterStats.c |
| 054_737AA_line_editor_rosters | LoadGameRoster | 21 | LoadGameRoster.c |
| 054_737AA_line_editor_rosters | DrawLineJerseys | 30 | DrawLineJerseys.c |
| 054_737AA_line_editor_rosters | DbLineEditorLoop | 92 | DbLineEditorLoop.c |
| 054_737AA_line_editor_rosters | GameLineEditorLoop | 110 | GameLineEditorLoop.c |
| 055_78346_team_select | DrawGameLineJerseys | 11 | DrawGameLineJerseys.c |
| 055_78346_team_select | MenuGameShowPlayerStats | 16 | MenuSaveDefaultLines.c |
| 055_78346_team_select | MenuSaveDefaultLines | 17 | MenuSaveDefaultLines.c |
| 055_78346_team_select | MenuSaveTheseLines | 19 | MenuSaveDefaultLines.c |
| 056_7A13A_settings_dialogs | ReassignCtlPlayer | 10 | MenuP1ControlsInGame.c |
| 056_7A13A_settings_dialogs | ControlsDlgLoop | 143 | MenuP1ControlsInGame.c |
| 057_7DC8B_gadgets_replay | ReplayControlLoop | 16 | ReplayControlLoop.c |
| 057_7DC8B_gadgets_replay | InstantReplay | 27 | InstantReplay.c |
| 057_7DC8B_gadgets_replay | ReplaySaveHilight | 35 | ReplaySaveHilight.c |
| 058_7F724_highlights | HilightSaveToDlg | 7 | HilightSaveToDlg.c |
| 058_7F724_highlights | SelectHilight | 7 | SelectHilight.c |
| 059_8034B_settings_lockerroom | LockerRoomLoop | 23 | LockerRoomScreen.c |
| 059_8034B_settings_lockerroom | DrawLockerJersey | 29 | DrawPanel3D.c |
| 061_83459_speech | QueueSpeechClip | 6 | ShutdownSpeech.c |
| 061_83459_speech | OpenSpeechBank | 11 | OpenSpeechBank.c |
| 064_86696_season_playoffs | POInitSchedule | 6 | POCreateSchedule.c |
| 064_86696_season_playoffs | CreatePlayoffs | 11 | POSeedRound2.c |
| 064_86696_season_playoffs | POHandleElimination | 13 | POHandleElimination.c |
| 064_86696_season_playoffs | POSeedTeams | 22 | POSeedRound2.c |
| 064_86696_season_playoffs | POAfterGame | 100 | POSeedRound2.c |
| 064_86696_season_playoffs | PlayoffTreeMenu | 156 | PlayoffTreeMenu.c |
| 066_8BEDB_asm_helpers | PlayMVI | 23 | PlayMVI.c |
