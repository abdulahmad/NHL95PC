# Function matching accept-list for native (historical)

**Superseded.** This is the 2026-11-06 advisor snapshot (52 PASS / 10 FAIL-parked / 29 accepted-for-native-link / 18 snapshot-required-before-M2). FAIL-park and accept-for-link are not resting states any more. The live bar is `check.py` PASS on the current source sha for every leftover unmarked draft. Table below is history; do not treat it as a done list.

Advisor moment 3 (2026-11-06): every leftover unmarked draft has one disposition. `check.py` was not re-run for this list. Verdict source: latest `tools/equiv/results.csv` row per function. Draft pool: 109 `nonmatching` rows in `tools/match/c_functions.csv`. Recut names: Gameloop, assonetimer, checkpuckcoll_ccx.

`c_progress.py` FUNCTIONAL was **49** when this list was signed (PASS rows whose file sha1 still matches). Three stale-hash rows were advisor PASS as well (52 total). Unit 1 of the 107-PASS plan stamps those three onto the current file sha without Unicorn.

No `abort()` stubs. No `cc.py mark`. Asm, drafts, `DRAFT:` notes, UNSURE entries and history rows stay so byte-match can resume. PRs #294–#299 that landed this file stay merged.

## Counts

| Disposition | n |
|---|---:|
| PASS | 52 |
| FAIL-parked | 10 |
| accepted-for-native-link | 29 |
| accepted-for-native-link + snapshot-required-before-M2 | 18 |
| **Sum** | **109** |

Near-miss engine rows (InProgress, DrawRinkOverlays, checkgoal, SkateToSpot) are inside the snapshot count, not a fifth bucket.

## Stale-hash PASS (signed PASS, do not re-run)

- **avdgoal** (`src/engine/skate/EvadePlayers.c`). Latest row PASS, 3000 cases, sha `53e0b37a` (commit e4ab4913). Current file sha `9d4a0533`. The `avdgoal` function bytes are identical. The file hash moved because `StopNA` became `stopna` in `dostop` / `stopna`, plus a header comment. `avdgoal` does not call that function.
- **NetCollide** (`src/engine/collide/PassLaneChk.c`). Latest row PASS, 3000 cases, sha `558cd470` (still the file at e7753097). Current file sha `e9be3972`. NetCollide's code is identical. The file hash moved because the sibling `checkpuckcoll` was renamed `checkpuckcoll_ccx`. The only nearby text change is that name in the puckstick comment.
- **ReplayStep** (`src/engine/replay/ReplayStep.c`). Latest row PASS, 769 cases (above the 500-case floor; no coverage miss in the row), logged sha `ff1810c9`. That sha matches no committed blob. It was logged against `src/c/046_644A8_engine_display/ReplayStep.c` and the path was rewritten later without a new hash. Against the functional-PASS commit (b9a14118, file sha `1cd1db9f`), the current file differs by exactly 20 bytes: `CrowdNoiseUpdate` → `Crowd_Noise` in the define, the undef, the prototype, and the call. `Crowd_Noise` is EXE `594CD`, the same entry the old name was. The store-order fix (`word_E9FB0 = camx`, `word_E9FB2 = camy`) is unchanged. `DrawRinkSideObjects` in the same file PASSes on the current sha.

## FAIL-parked (do not link these C bodies)

Asm stays in the build. These ten are not accepted for native link. Old 8 were already parked; FillDressedSlots and RunPlayerPickMenu stay parked. Not reopened.

## Exhibition M2

Exhibition M2 must not start until every function tagged `snapshot-required-before-M2` has a DOSBox-X entry snapshot, or a later `check.py` PASS. That set is the 17 engine NEEDS-REVIEW drafts under 85% plus TitleScreen (18). Native link may start for every accepted row, including that set: they link, and they are not `abort()` stubs. The snapshot wait is a native-plan input. FAIL-parked C is not linked. Gameloop is PASS and does not block M2.

## Signed table (109)

Coverage for a PASS row is not stored. A PASS means the latest row did not flag coverage under 85% or mostly trapped. Uncovered ranges are the CSV text.

| function | file | bucket | coverage % | callers note | traps note | disposition | M2 note |
|---|---|---|---|---|---|---|---|
| avdgoal | src/engine/skate/EvadePlayers.c | engine | — (PASS bar; file sha stale) | — | — | PASS | File sha stale. avdgoal body is byte-identical to the 3000-case PASS (sha 53e0b37a). File hash moved because sibling StopNA was renamed stopna (dostop/stopna) and a header comment changed. Do not re-run. c_progress will not count it. |
| changeplayer | src/engine/hockey/changeplayer.c | engine | — (PASS bar) | — | — | PASS | — |
| checkcx | src/engine/collide/checkcx.c | engine | — (PASS bar) | — | — | PASS | — |
| checkob | src/engine/collide/checkob.c | engine | — (PASS bar) | — | — | PASS | — |
| checkplcoll | src/engine/collide/checkplcoll.c | engine | — (PASS bar) | — | — | PASS | — |
| checkwallcoll | src/engine/collide/checkwallcoll.c | engine | — (PASS bar) | — | — | PASS | — |
| ChkScorerMilestone | src/engine/gamelog/ChkScorerMilestone.c | engine | — (PASS bar) | — | — | PASS | — |
| dopass | src/engine/collide/dopass.c | engine | — (PASS bar) | — | — | PASS | — |
| doshot | src/engine/collide/dopass.c | engine | — (PASS bar) | — | — | PASS | — |
| DrawRinkSideObjects | src/engine/replay/ReplayStep.c | engine | — (PASS bar) | — | — | PASS | — |
| NetCollide | src/engine/collide/PassLaneChk.c | engine | — (PASS bar; file sha stale) | — | — | PASS | File sha stale. NetCollide code is identical to the 3000-case PASS (sha 558cd470). File hash moved because sibling checkpuckcoll was renamed checkpuckcoll_ccx (comment only on the following puckstick note). Do not re-run. c_progress will not count it. |
| passtoa0 | src/engine/collide/passtoa0.c | engine | — (PASS bar) | — | — | PASS | — |
| puckfaceoff | src/engine/faceoff/puckfaceoff.c | engine | — (PASS bar) | — | — | PASS | — |
| puckfaceoff2 | src/engine/faceoff/puckfaceoff.c | engine | — (PASS bar) | — | — | PASS | — |
| RemoveFromLines | src/engine/lines/RemoveFromLines.c | engine | — (PASS bar) | — | — | PASS | — |
| ReplayStep | src/engine/replay/ReplayStep.c | engine | — (PASS bar; file sha stale) | — | — | PASS | File sha stale. Logged PASS sha ff1810 (769 cases) was never a committed blob. Versus the functional-PASS commit, the only statement change is CrowdNoiseUpdate→Crowd_Noise, the same EXE entry 594CD (four sites, 20 bytes, the whole file delta). Store-order fix intact. Do not re-run. c_progress will not count it. |
| setplayer | src/engine/hockey/changeplayer.c | engine | — (PASS bar) | — | — | PASS | — |
| shotdiradj | src/engine/collide/dopass.c | engine | — (PASS bar) | — | — | PASS | — |
| updatereplay | src/engine/replay/updatereplay.c | engine | — (PASS bar) | — | — | PASS | — |
| BlitTileMap | src/front/rink_tiles/BlitTileMap.c | front | — (PASS bar) | — | — | PASS | — |
| BuildStandingsGrid | src/front/league_setup/BuildStandingsGrid.c | front | — (PASS bar) | — | — | PASS | — |
| CreateNewLeague | src/front/season/CreateNewLeague.c | front | — (PASS bar) | — | — | PASS | — |
| DrawAwardsSummary | src/front/awards/PickAwardWinners.c | front | — (PASS bar) | — | — | PASS | — |
| DrawLockerJersey | src/front/lockerroom/DrawPanel3D.c | front | — (PASS bar) | — | — | PASS | — |
| DrawSprite | src/front/screen_util/DrawSprite.c | front | — (PASS bar) | — | — | PASS | — |
| EasnGoalieStatsScreen | src/front/stats_screens/EasnGoalieStatsScreen.c | front | — (PASS bar) | — | — | PASS | — |
| FadePalette | src/front/main/FadePalette.c | front | — (PASS bar) | — | — | PASS | — |
| Gameloop | src/front/main/Gameloop.c | front | — (PASS bar) | — | — | PASS | Recut of GameLoop. Current file sha matches the CSV PASS (998 cases). Not accept-for-link. Does not block M2. |
| LoadGameRoster | src/front/game_lines/LoadGameRoster.c | front | — (PASS bar) | — | — | PASS | — |
| LoadTeamRoster | src/front/team_db/LoadTeamRoster.c | front | — (PASS bar) | — | — | PASS | — |
| MenuGameShowPlayerStats | src/front/game_lines/MenuSaveDefaultLines.c | front | — (PASS bar) | — | — | PASS | — |
| MenuSaveDefaultLines | src/front/game_lines/MenuSaveDefaultLines.c | front | — (PASS bar) | — | — | PASS | — |
| MenuSaveTheseLines | src/front/game_lines/MenuSaveDefaultLines.c | front | — (PASS bar) | — | — | PASS | — |
| POHandleElimination | src/front/playoff_mode/POHandleElimination.c | front | — (PASS bar) | — | — | PASS | — |
| POInitSchedule | src/front/playoff_mode/POCreateSchedule.c | front | — (PASS bar) | — | — | PASS | — |
| SelectHilight | src/front/replay_controls/SelectHilight.c | front | — (PASS bar) | — | — | PASS | — |
| SelectRosterTeam | src/front/create/RunEditRosters.c | front | — (PASS bar) | — | — | PASS | — |
| SeriesLength | src/front/season/SeriesLength.c | front | — (PASS bar) | — | — | PASS | — |
| SetRosterTeamMenus | src/front/create/SetRosterTeamMenus.c | front | — (PASS bar) | 84%→100% (10 snaps) | — | PASS | — |
| SetupStatsSourceMenu | src/front/screen_util/SetupStatsSourceMenu.c | front | — (PASS bar) | — | — | PASS | — |
| ShowCredits | src/front/title/RunDemoGame.c | front | — (PASS bar) | — | — | PASS | — |
| ShowRosterStats | src/front/lines/ShowRosterStats.c | front | — (PASS bar) | — | — | PASS | — |
| SkaterStatsCard | src/front/stats/SkaterStatsCard.c | front | — (PASS bar) | — | — | PASS | — |
| SwapSelectedPlayers | src/front/create/SwapSelectedPlayers.c | front | — (PASS bar) | — | — | PASS | — |
| TeamStatsScreen | src/front/stats/TeamStatsScreen.c | front | — (PASS bar) | — | — | PASS | — |
| TreeSeriesWinner | src/front/league_tree/TreeSeriesWinner.c | front | — (PASS bar) | — | — | PASS | — |
| DrawListItem | src/pc/dialogs/DrawListItem.c | pc | — (PASS bar) | — | — | PASS | — |
| LoadGameState | src/pc/game_saveload/SaveGameState.c | pc | — (PASS bar) | — | — | PASS | — |
| PlacePlayersAtStart | src/pc/asset_loading/PlacePlayersAtStart.c | pc | — (PASS bar) | — | — | PASS | — |
| ReassignCtlPlayer | src/pc/settings_dialogs/MenuP1ControlsInGame.c | pc | — (PASS bar) | — | — | PASS | — |
| ResetGameVars | src/pc/asset_loading/ResetGameVars.c | pc | — (PASS bar) | — | — | PASS | — |
| SelectSavedFile | src/pc/file_dialogs/SelectSavedFile.c | pc | — (PASS bar) | — | — | PASS | — |
| CanFillLineSlot | src/engine/lines/CanFillLineSlot.c | engine | — | — | — | FAIL-parked | short-return (eax 0xffff0000 vs C 0); Abdul. Parked. Do not link this C. |
| FillDressedSlots | src/engine/lines/CanFillLineSlot.c | engine | — | — | — | FAIL-parked | short-return, ax 0x005d both sides, upper junk; no C. Parked. Do not link this C. |
| DbLineEditorLoop | src/front/lines/DbLineEditorLoop.c | front | — | — | — | FAIL-parked | frame layout (pointer-to-local). Parked. Do not link this C. |
| GameLineEditorLoop | src/front/game_lines/GameLineEditorLoop.c | front | — | — | — | FAIL-parked | input artefact. Parked. Do not link this C. |
| OpenSpeechBank | src/front/announcer/OpenSpeechBank.c | front | — | — | — | FAIL-parked | frame layout (pointer-to-local). Parked. Do not link this C. |
| PlayoffTreeMenu | src/front/playoff_mode/PlayoffTreeMenu.c | front | — | — | — | FAIL-parked | wild pointer (fault address). Parked. Do not link this C. |
| RunPlayerPickMenu | src/front/menu/RunMenu.c | front | — | — | — | FAIL-parked | wild call-arg ebx at 0xb300a vs C 0; writes and ret matched; no C. Parked. Do not link this C. |
| SimPlayoffRound1 | src/front/season/SimPlayoffRound1.c | front | — | — | — | FAIL-parked | input artefact (out-of-range index). Parked. Do not link this C. |
| SportsDesk | src/front/desk/SportsDesk.c | front | — | — | — | FAIL-parked | frame layout (pointer-to-local). Parked. Do not link this C. |
| TradeScreenLoop | src/front/trade/TradeScreenLoop.c | front | — | — | — | FAIL-parked | frame layout (pointer-to-local). Parked. Do not link this C. |
| assgoalie | src/engine/logic/assgoalie.c | engine | 17% uncovered 0x4b7e3-0x4b7e3 0x4b8d1-0x4b97c 0x4b98e-0x4c53e 0x4c5e3-0x4c5eb | 17%→17% (0 snaps) | — | accepted-for-native-link + snapshot-required-before-M2 | Engine under 85%. Link now (no abort stub). Exhibition M2 waits on a DOSBox-X entry snapshot or a later PASS. |
| assonetimer | src/engine/input/CanBlockShot.c | engine | 47% uncovered 0x50bd5-0x50d83 | 46%→47% (2000 snaps) | — | accepted-for-native-link + snapshot-required-before-M2 | Engine under 85%. Link now (no abort stub). Exhibition M2 waits on a DOSBox-X entry snapshot or a later PASS. |
| assrefgoalpa | src/engine/logic/assgoalie.c | engine | 52% uncovered 0x4f037-0x4f090 0x4f169-0x4f1de 0x4f2b0-0x4f31e 0x4f346-0x4f3b5 0x4f40b-0x4f592 | 52%→52% (0 snaps) | — | accepted-for-native-link + snapshot-required-before-M2 | Engine under 85%. Link now (no abort stub). Exhibition M2 waits on a DOSBox-X entry snapshot or a later PASS. |
| assthreestars | src/engine/intro/FadeOutPalCycle.c | engine | 50% uncovered 0x497b6-0x498f7 0x49907-0x499cb | 50%→50% (0 snaps) | — | accepted-for-native-link + snapshot-required-before-M2 | Engine under 85%. Link now (no abort stub). Exhibition M2 waits on a DOSBox-X entry snapshot or a later PASS. |
| CanBlockShot | src/engine/input/CanBlockShot.c | engine | 26% uncovered 0x500b4-0x5032f | 26%→26% (2000 snaps) | — | accepted-for-native-link + snapshot-required-before-M2 | Engine under 85%. Link now (no abort stub). Exhibition M2 waits on a DOSBox-X entry snapshot or a later PASS. |
| checkcheck | src/engine/collide/checkcheck.c | engine | 10% uncovered 0x53861-0x5386a 0x53876-0x5387f 0x53890-0x53cc3 | 10%→10% (4 snaps) | — | accepted-for-native-link + snapshot-required-before-M2 | Engine under 85%. Link now (no abort stub). Exhibition M2 waits on a DOSBox-X entry snapshot or a later PASS. |
| checkgoal | src/engine/collide/checkgoal.c | engine | 79% uncovered 0x586db-0x58795 | 12%→79% (2000 snaps) | — | accepted-for-native-link + snapshot-required-before-M2 | Near-miss, still under 85%. No further --budget. Link now (no abort stub). Exhibition M2 waits on a DOSBox-X entry snapshot or a later PASS. |
| checkgoalp | src/engine/collide/checkgoalp.c | engine | 51% uncovered 0x53d16-0x53d2c 0x53db9-0x53e62 | 51%→51% (2000 snaps) | — | accepted-for-native-link + snapshot-required-before-M2 | Engine under 85%. Link now (no abort stub). Exhibition M2 waits on a DOSBox-X entry snapshot or a later PASS. |
| checkpuckcoll_ccx | src/engine/collide/PassLaneChk.c | engine | 75% uncovered 0x545c4-0x5466b 0x54704-0x547eb | 71%→75% (2000 snaps) | — | accepted-for-native-link + snapshot-required-before-M2 | Engine under 85%. Link now (no abort stub). Exhibition M2 waits on a DOSBox-X entry snapshot or a later PASS. |
| DrawRinkOverlays | src/engine/hockey/changeplayer.c | engine | 79% uncovered 0x5d1f7-0x5d21a 0x5d2fe-0x5d395 0x5d450-0x5d4fb 0x5d524-0x5d583 0x5d5ed-0x5d60b | 77%→79% (2000 snaps) | — | accepted-for-native-link + snapshot-required-before-M2 | Near-miss, still under 85%. No further --budget. Link now (no abort stub). Exhibition M2 waits on a DOSBox-X entry snapshot or a later PASS. |
| InProgress | src/engine/penalty/InProgress.c | engine | 77% uncovered 0x62f69-0x62f7d 0x63050-0x630e6 0x63243-0x63243 0x63351-0x633d8 | 77%→77% (1085 snaps) | — | accepted-for-native-link + snapshot-required-before-M2 | Near-miss, still under 85%. No further --budget. Link now (no abort stub). Exhibition M2 waits on a DOSBox-X entry snapshot or a later PASS. |
| PassLaneChk | src/engine/collide/PassLaneChk.c | engine | 51% uncovered 0x54c99-0x54d55 | 51%→51% (15 snaps) | — | accepted-for-native-link + snapshot-required-before-M2 | Engine under 85%. Link now (no abort stub). Exhibition M2 waits on a DOSBox-X entry snapshot or a later PASS. |
| PenGoalStuff | src/engine/penalty/InProgress.c | engine | 66% uncovered 0x63eae-0x63eae 0x63ec5-0x63f63 | 66%→66% (11 snaps) | — | accepted-for-native-link + snapshot-required-before-M2 | Engine under 85%. Link now (no abort stub). Exhibition M2 waits on a DOSBox-X entry snapshot or a later PASS. |
| PickForLineSlot | src/engine/lines/PickForLineSlot.c | engine | 44% uncovered 0x64f7b-0x64ff6 0x65005-0x65087 0x65096-0x65119 0x65167-0x651a5 0x6521c-0x6525a | 44%→44% (2000 snaps) | — | accepted-for-native-link + snapshot-required-before-M2 | Engine under 85%. Link now (no abort stub). Exhibition M2 waits on a DOSBox-X entry snapshot or a later PASS. |
| SkateToSpot | src/engine/logic/SkateToSpot.c | engine | 83% uncovered 0x4e46e-0x4e528 0x4e629-0x4e630 0x4e68b-0x4e692 | 80%→83% (2000 snaps) | — | accepted-for-native-link + snapshot-required-before-M2 | Near-miss, still under 85%. No further --budget. Link now (no abort stub). Exhibition M2 waits on a DOSBox-X entry snapshot or a later PASS. |
| StarCompare | src/engine/intro/StarCompare.c | engine | 52% uncovered 0x4892b-0x48931 0x4893b-0x48975 0x48984-0x4898a 0x489d8-0x48ab9 | 52%→52% (0 snaps) | — | accepted-for-native-link + snapshot-required-before-M2 | Engine under 85%. Link now (no abort stub). Exhibition M2 waits on a DOSBox-X entry snapshot or a later PASS. |
| wallcoll | src/engine/collide/dopass.c | engine | 53% uncovered 0x58857-0x58a0f | 53%→53% (2000 snaps) | — | accepted-for-native-link + snapshot-required-before-M2 | Engine under 85%. Link now (no abort stub). Exhibition M2 waits on a DOSBox-X entry snapshot or a later PASS. |
| TitleScreen | src/front/title/RunDemoGame.c | front | 65% uncovered 0x1622b-0x16248 0x16411-0x165c4 0x165f5-0x16632 0x16642-0x16647 0x16666-0x1666c | 65%→65% (0 snaps) | — | accepted-for-native-link + snapshot-required-before-M2 | M2-path (front). Do not FAIL for 65% coverage. Link now. Exhibition M2 waits on a DOSBox-X entry snapshot or a later PASS. |
| CalendarScreen | src/front/calendar/CalendarScreen.c | front | 21% uncovered 0x34ba5-0x34be0 0x34c57-0x34c8b 0x34d08-0x34d55 0x34d63-0x35f15 0x35f95-0x35fa4 | 21%→21% (0 snaps) | — | accepted-for-native-link | Front/PC off the exhibition skate path (menu, dialog, season, trade, awards, floppy, or replay UI). Snapshots optional (M3). Does not block M2. Link now. |
| CopyHumanTeamDBs | src/front/league_teams/CopyHumanTeamDBs.c | front | 62% uncovered 0x41664-0x4166d 0x41677-0x417a2 0x417c2-0x417e7 0x4187f-0x418a4 0x418aa-0x418da | 62%→62% (0 snaps) | — | accepted-for-native-link | Front/PC off the exhibition skate path (menu, dialog, season, trade, awards, floppy, or replay UI). Snapshots optional (M3). Does not block M2. Link now. |
| DrawCalendarDay | src/front/calendar/DrawCalendarDay.c | front | 80% uncovered 0x3451d-0x34675 | 80%→80% (0 snaps) | mostly trapped | accepted-for-native-link | Front/PC off the exhibition skate path (menu, dialog, season, trade, awards, floppy, or replay UI). Snapshots optional (M3). Does not block M2. Link now. |
| EditGoalieRating | src/front/create/EditSkaterRating.c | front | 16% uncovered 0x6ffe8-0x70233 0x70256-0x70256 | 16%→16% (0 snaps) | — | accepted-for-native-link | Front/PC off the exhibition skate path (menu, dialog, season, trade, awards, floppy, or replay UI). Snapshots optional (M3). Does not block M2. Link now. |
| EditRosters | src/front/create/EditRosters.c | front | 58% uncovered 0x6e3c6-0x6e409 0x6e4d3-0x6e4f9 0x6e527-0x6e56f 0x6e660-0x6e91c 0x6ea37-0x6ea97 | 58%→58% (2000 snaps) | mostly trapped | accepted-for-native-link | Front/PC off the exhibition skate path (menu, dialog, season, trade, awards, floppy, or replay UI). Snapshots optional (M3). Does not block M2. Link now. |
| EditSkaterRating | src/front/create/EditSkaterRating.c | front | 18% uncovered 0x6fcdf-0x6ff38 | 18%→18% (904 snaps) | — | accepted-for-native-link | Front/PC off the exhibition skate path (menu, dialog, season, trade, awards, floppy, or replay UI). Snapshots optional (M3). Does not block M2. Link now. |
| ExecuteTrade | src/front/trade/ExecuteTrade.c | front | 25% uncovered 0x3e465-0x3e656 0x3e67c-0x3e7a3 | 25%→25% (0 snaps) | — | accepted-for-native-link | Front/PC off the exhibition skate path (menu, dialog, season, trade, awards, floppy, or replay UI). Snapshots optional (M3). Does not block M2. Link now. |
| FixJerseyConflict | src/front/trade/FixJerseyConflict.c | front | 20% uncovered 0x3e0d2-0x3e37d | 20%→20% (0 snaps) | — | accepted-for-native-link | Front/PC off the exhibition skate path (menu, dialog, season, trade, awards, floppy, or replay UI). Snapshots optional (M3). Does not block M2. Link now. |
| GameSummaryScreen | src/front/summary/GameSummaryScreen.c | front | 61% uncovered 0x2dcc4-0x2dfbd 0x2e08e-0x2e164 0x2e54e-0x2e5ca 0x2e5df-0x2ea4b 0x2eee5-0x2f051 | 45%→61% (2000 snaps) | — | accepted-for-native-link | Front/PC off the exhibition skate path (menu, dialog, season, trade, awards, floppy, or replay UI). Snapshots optional (M3). Does not block M2. Link now. |
| InstantReplay | src/front/replay_controls/DrawGadgetButton.c | front | 75% uncovered 0x7e4cd-0x7e558 0x7e56b-0x7e5dc 0x7e6d7-0x7e7e1 | 75%→75% (2000 snaps) ; budget 107 cases | mostly trapped | accepted-for-native-link | Front/PC off the exhibition skate path (menu, dialog, season, trade, awards, floppy, or replay UI). Snapshots optional (M3). Does not block M2. Link now. |
| LeagueTeamSelect | src/front/league_setup/LeagueTeamSelect.c | front | 45% uncovered 0x39292-0x3941b 0x394ca-0x39916 0x39949-0x399e5 0x39b2f-0x39c5a 0x39c9b-0x3a02e | 45%→45% (0 snaps) | mostly trapped | accepted-for-native-link | Front/PC off the exhibition skate path (menu, dialog, season, trade, awards, floppy, or replay UI). Snapshots optional (M3). Does not block M2. Link now. |
| MoveToOtherRoster | src/front/create/MoveToOtherRoster.c | front | 41% uncovered 0x6f30c-0x6f47d 0x6f500-0x6f503 0x6f514-0x6f514 0x6f546-0x6f5ff 0x6f685-0x6f6a0 | 41%→41% (0 snaps) | — | accepted-for-native-link | Front/PC off the exhibition skate path (menu, dialog, season, trade, awards, floppy, or replay UI). Snapshots optional (M3). Does not block M2. Link now. |
| PickAwardWinners | src/front/awards/PickAwardWinners.c | front | 15% uncovered 0x1212f-0x1215e 0x12181-0x127fb | 15%→15% (2000 snaps) | — | accepted-for-native-link | Front/PC off the exhibition skate path (menu, dialog, season, trade, awards, floppy, or replay UI). Snapshots optional (M3). Does not block M2. Link now. |
| PlayLeagueGame | src/front/calendar/PlayLeagueGame.c | front | 26% uncovered 0x36ce8-0x36d09 0x36d99-0x36dbe 0x36dc7-0x36df5 0x36e08-0x36ef1 0x37071-0x37a66 | 26%→26% (2000 snaps) | — | accepted-for-native-link | Front/PC off the exhibition skate path (menu, dialog, season, trade, awards, floppy, or replay UI). Snapshots optional (M3). Does not block M2. Link now. |
| POAfterGame | src/front/playoff_mode/POSeedRound2.c | front | 72% uncovered 0x888cd-0x888ea 0x88a2b-0x88ac8 0x88ad6-0x88b72 0x88ca0-0x88d7a 0x8904e-0x89081 | 72%→72% (0 snaps) | — | accepted-for-native-link | Front/PC off the exhibition skate path (menu, dialog, season, trade, awards, floppy, or replay UI). Snapshots optional (M3). Does not block M2. Link now. |
| POSeedTeams | src/front/playoff_mode/POSeedRound2.c | front | — | — | mostly trapped | accepted-for-native-link | Front/PC off the exhibition skate path (menu, dialog, season, trade, awards, floppy, or replay UI). Snapshots optional (M3). Does not block M2. Link now. |
| PostGameToTeamDb | src/front/calendar/PostGameToTeamDb.c | front | 30% uncovered 0x36396-0x363c6 0x363e9-0x365f9 0x36668-0x36741 0x367b7-0x368bd 0x3694d-0x36b21 | 30%→30% (2000 snaps) | — | accepted-for-native-link | Front/PC off the exhibition skate path (menu, dialog, season, trade, awards, floppy, or replay UI). Snapshots optional (M3). Does not block M2. Link now. |
| RandomizeSchedule | src/front/season/RandomizeSchedule.c | front | 56% uncovered 0x42406-0x42596 0x425e2-0x425f9 | 56%→56% (0 snaps) | — | accepted-for-native-link | Front/PC off the exhibition skate path (menu, dialog, season, trade, awards, floppy, or replay UI). Snapshots optional (M3). Does not block M2. Link now. |
| ReplaySaveHilight | src/front/replay_controls/ReplaySaveHilight.c | front | 49% uncovered 0x7f103-0x7f105 0x7f39d-0x7f41d 0x7f468-0x7f719 | 49%→49% (0 snaps) | — | accepted-for-native-link | Front/PC off the exhibition skate path (menu, dialog, season, trade, awards, floppy, or replay UI). Snapshots optional (M3). Does not block M2. Link now. |
| RosterPanelClick | src/front/create/RosterPanelClick.c | front | 75% uncovered 0x6dafa-0x6dafa 0x6db4a-0x6db95 0x6dbd5-0x6dbda 0x6dc65-0x6dc94 0x6dca8-0x6dcb0 | 75%→75% (2 snaps) | — | accepted-for-native-link | Front/PC off the exhibition skate path (menu, dialog, season, trade, awards, floppy, or replay UI). Snapshots optional (M3). Does not block M2. Link now. |
| RunMenu | src/front/menu/RunMenu.c | front | 54% uncovered 0x1d87c-0x1d8bf 0x1d9c8-0x1da38 0x1dac0-0x1ddb1 0x1dee5-0x1df00 | 54%→54% (2000 snaps) | mostly trapped | accepted-for-native-link | Front/PC off the exhibition skate path (menu, dialog, season, trade, awards, floppy, or replay UI). Snapshots optional (M3). Does not block M2. Link now. |
| RunTeamPickMenu | src/front/menu/RunMenu.c | front | 80% uncovered 0x1e169-0x1e1b5 0x1e306-0x1e308 0x1e544-0x1e54b 0x1e5fa-0x1e605 0x1e716-0x1e985 | 75%→80% (1643 snaps) | mostly trapped | accepted-for-native-link | Front/PC off the exhibition skate path (menu, dialog, season, trade, awards, floppy, or replay UI). Snapshots optional (M3). Does not block M2. Link now. |
| SeedPlayoffRound3 | src/front/season/SimPlayoffRound1.c | front | 34% uncovered 0x43fbf-0x43fdc 0x43fe8-0x43ffc 0x440e3-0x440e7 0x44106-0x443b1 | 34%→34% (0 snaps) ; budget 41 cases | mostly trapped | accepted-for-native-link | Front/PC off the exhibition skate path (menu, dialog, season, trade, awards, floppy, or replay UI). Snapshots optional (M3). Does not block M2. Link now. |
| SimulateGame | src/front/simgame/SimulateGame.c | front | 19% uncovered 0x455c0-0x45a63 0x45a91-0x45ddf 0x45e52-0x47197 0x4721c-0x472b4 0x47733-0x47839 | 19%→19% (2000 snaps) | — | accepted-for-native-link | Front/PC off the exhibition skate path (menu, dialog, season, trade, awards, floppy, or replay UI). Snapshots optional (M3). Does not block M2. Link now. |
| TradePlayers | src/front/trade/TradePlayers.c | front | 43% uncovered 0x403c9-0x40729 | 42%→43% (2000 snaps) | — | accepted-for-native-link | Front/PC off the exhibition skate path (menu, dialog, season, trade, awards, floppy, or replay UI). Snapshots optional (M3). Does not block M2. Link now. |
| DrawListItems | src/pc/dialogs/DrawListItem.c | pc | — | budget 38 cases | — | accepted-for-native-link | Front/PC off the exhibition skate path (menu, dialog, season, trade, awards, floppy, or replay UI). Snapshots optional (M3). Does not block M2. Link now. |
| EditTextField | src/pc/dialogs/EditTextField.c | pc | 65% uncovered 0x317db-0x31809 0x31858-0x31878 0x31882-0x318ae 0x318bc-0x318ea 0x31986-0x319ac | 65%→65% (28 snaps) | mostly trapped | accepted-for-native-link | Front/PC off the exhibition skate path (menu, dialog, season, trade, awards, floppy, or replay UI). Snapshots optional (M3). Does not block M2. Link now. |
| ExportTeamToFloppy | src/pc/database_merge/ExportTeamToFloppy.c | pc | 59% uncovered 0x3bcdf-0x3bd13 0x3bd2e-0x3bdb1 0x3c02c-0x3c066 0x3c077-0x3c09f 0x3c26c-0x3c2e5 | 59%→59% (0 snaps) ; budget 96 cases | — | accepted-for-native-link | Front/PC off the exhibition skate path (menu, dialog, season, trade, awards, floppy, or replay UI). Snapshots optional (M3). Does not block M2. Link now. |
| ListDialog | src/pc/dialogs/ListDialog.c | pc | 85% uncovered 0x3079e-0x307dd 0x30846-0x3084e 0x308e5-0x30903 0x3093d-0x30967 0x309b4-0x309e1 | 84%→85% (57 snaps) ; budget 364 cases | mostly trapped | accepted-for-native-link | Never PASS by fiat. 85% is mostly trapped (364 cases); equal-trap agreement is not a PASS. Dialog. Snapshots optional (M3). Link now. |

Signed: functional-track advisor, moment 3, 2026-11-06. Every one of the 109 is in exactly one disposition. Sum 52 + 10 + 29 + 18 = 109.

