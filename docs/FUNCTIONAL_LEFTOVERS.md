# Leftover proofs (109-plan)

No DOSBox-X dumps. MATCH stays 977/1084. Never `cc.py mark`.

Live leftover after keep plants: **82 PASS / 0 FAIL / 27 NR**. StarCompare / assonetimer PASS 3000.

## H1 (soft traps) + list-count clamps

`mostly_trapped` no longer counts a stopping trap on a case that also hit `null page`. uninit stack read stays review.

| Function | Result |
|---|---|
| POSeedTeams | **PASS 3000** (was NR mostly trapped; 2987 null-page cases) |
| DrawListItems | **PASS 3000** (was 33 cases: `n` was ARG. Clamp loop count to 1..20) |
| ListDialog | **PASS 3000** (GetInputEvent dummy events + ListHitTest in-rect + `n` 1..20, marks 0) |

G17 pilots PASS (NetCollide at 3000; 200 cases is 83% coverage). Planted SeriesLength FAIL at case 4 (`ret eax` 1 vs 2).

SportsDesk: GetInputEvent stub on even cases FAILed `writes[13]` through wild menus (0x78c3be44 vs 0x78c3be74). Event stub is ListDialog-only. SportsDesk restored **NR** 79 cases, 47% coverage, budget.

## H2 (budget 1800)

`--budget 1800 --cases 2000` on the hanging screen loops. Still NR: more time is not the unlock. `--no-callers` is required on these; callers of a screen loop hang until insn limit.

| Function | Result |
|---|---|
| RunMenu | NR 510 cases, 49% coverage, 1805s |
| RunTeamPickMenu | NR 486 cases, 64% coverage, 1806s |
| InstantReplay | NR 306 cases, 75% coverage, mostly trapped, 1807s |

DrawListItems / ListDialog already PASS from H1; not re-run. The rest of the H2 list (SeedPlayoffRound3, GameLineEditorLoop, DbLineEditorLoop, PlayoffTreeMenu, LeagueTeamSelect, TradeScreenLoop, SportsDesk) is the same class: H3 inputs, then H4 recheck. Not accept-for-link.

## H3 (retail-shaped screen inputs)

Menu-mode leftovers (`event_mode=menu`): plant `pointerspr` → ARG sprite, `sub_8CCA8` → ARG+0x800, MenuHitTest does not seed `menus[]`, `__cdecl` nreg 0, GetInputEvent sequence move / empty / click. ListDialog keeps `event_mode=list` (64 events then 0).

| Function | Result |
|---|---|
| RunMenu | **PASS 3000** (was NR 49%). 0 stopping traps. |
| ListDialog | **PASS 3000** (still; list-mode GetInputEvent) |
| SportsDesk | NR 92 cases, 70% coverage (was FAIL with a global event stub; now not FAIL) |
| RunTeamPickMenu | NR 120 cases, 72% coverage, 0 stopping traps |

G17: SeriesLength PASS 300, NetCollide PASS 4500. Planted SeriesLength FAIL case 4 (`ret eax` 1 vs 2). `--no-callers` on screen loops.

## H4 (recheck remaining NR)

`--force --budget 1800 --cases 2000 --no-callers` on all 49 leftover NR. One new PASS. SportsDesk both-fault at case 488 (`orig 0xa5a5a5a5` vs C) is review, not a C store/call FAIL. No C. Never `cc.py mark`.

| Function | Result |
|---|---|
| RandomizeSchedule | **PASS 3000** (was NR 56%) |
| SportsDesk | NR 489 cases, 76% (uninit-fault address is review) |
| RunTeamPickMenu | NR 3000 cases, 82% |
| SkateToSpot | NR 3000 cases, 82% |
| DrawCalendarDay | NR 3000 cases, 80% |
| checkpuckcoll_ccx | NR 3000 cases, 79% |
| TradeScreenLoop | NR 2228 cases, 77% |
| PlayoffTreeMenu | NR 3000 cases, 73% |
| InstantReplay | NR 204 cases, 74%, mostly trapped, budget |
| others (39) | still NR; coverage holes, not FAIL |

G17: SeriesLength PASS 300, NetCollide PASS 4500. Planted SeriesLength FAIL case 4 (`ret eax` 1 vs 2).

## H5 (dead-range)

Near-miss holes are live retail paths. No `dead_ranges.txt`. Not accept-for-link.

| Function | Uncovered | Why live |
|---|---|---|
| RunTeamPickMenu 0x1e55b | `mov esi, [statsplayoffs]` season team-order | retail regular-season stats |
| SkateToSpot 0x4e46e | `cmp ax, 0E0h` inside the 0xE0..0xE8 Y corridor | retail player on that band |
| DrawCalendarDay 0x344f9 | selected-day store after `calselmonth`/`calselday` match | retail highlighted cell |

Live holes stay NR. Advisor, not a dump wait.

## Leftover synth (deeper H3 plants + budget 1800)

Calendar games in regs (Watcom `eax` month, `edx` crests, `ecx` games; 4 stack args), skate mix (boards / goal-line / close / far / signed world / `|dx|,|dy|` in 8..24 with `|vel| > 0x9C4`), collide SortCords goalie `pos=0` + stick frame `0x431` + signed puck vel, `statsplayoffs` + `event_mode=menu_pick`. `--force --budget 1800 --cases 2000 --no-callers` on the leftover NR. No C. Never `cc.py mark`.

| Function | Result |
|---|---|
| DrawCalendarDay | **PASS 3000** (was NR 80%; 93.7% coverage) |
| checkpuckcoll_ccx | **PASS 3000** (was NR 79%; 97.3% coverage) |
| RunTeamPickMenu | **PASS 3000** (was NR 82%; 85.9% coverage) |
| SkateToSpot | **PASS 3000** (was NR 82%; 94.8% coverage) |
| remaining 44 NR | still NR; coverage / budget / uninit-fault, not FAIL |

G17: SeriesLength PASS 300, NetCollide PASS 4500. Planted SeriesLength FAIL case 4 (`ret eax` 1 vs 2). RunMenu still PASS 85.1% at 600 (not re-logged).

Remaining NR: CalendarScreen, CanBlockShot, CopyHumanTeamDBs, DbLineEditorLoop, DrawRinkOverlays, EditGoalieRating, EditRosters, EditSkaterRating, EditTextField, ExecuteTrade, ExportTeamToFloppy, FillDressedSlots, FixJerseyConflict, GameLineEditorLoop, GameSummaryScreen, InProgress, InstantReplay, LeagueTeamSelect, MoveToOtherRoster, POAfterGame, PassLaneChk, PenGoalStuff, PickAwardWinners, PickForLineSlot, PlayLeagueGame, PlayoffTreeMenu, PostGameToTeamDb, ReplaySaveHilight, RosterPanelClick, RunPlayerPickMenu, SeedPlayoffRound3, SimulateGame, SportsDesk, StarCompare, TitleScreen, TradePlayers, TradeScreenLoop, assgoalie, assonetimer, assrefgoalpa, assthreestars, checkcheck, checkgoal, wallcoll.

## Leftover pairs (collide ABI + overlay/penalty plants)

`checkcheck` / `PassLaneChk` / `checkgoal` `edx` is a second Player at ARG+0x480, not a SortCords index. PassLaneChk `|Y|` in `(0x4E, 0x76]` with the teammate 0x20 shallower and `(Y>threshold) XOR pflags.7 == 0`. checkgoal `SCnum==0x0E` on `eax` (puck), in-box vs g. InProgress `PenBuf[0]==0x1A` is StartPenaltyShot. DrawRinkOverlays mixes `sortobj15` frames `0x286/0x22E/0x189`, SCnum `0x0E/0x0C/0x0F`, `pucky -0xEC`. `--force --budget 1800 --cases 2000 --no-callers` on the leftover NR. No C. Never `cc.py mark`.

| Function | Result |
|---|---|
| InProgress | **PASS 3000** (was NR 76%; PenBuf 0x1A + RefStep) |
| DrawRinkOverlays | **PASS 3000** (was NR 77%; frame/SCnum/pucky mix) |
| PassLaneChk | **PASS 3000** (was NR 49%; Y-band + teammate geometry) |
| remaining 41 NR | still NR; coverage / budget / uninit-fault, not FAIL |

G17: SeriesLength PASS 450, NetCollide PASS 6750. Planted SeriesLength FAIL case 4 (`ret eax` 1 vs 2).

Remaining NR: CalendarScreen, CanBlockShot, CopyHumanTeamDBs, DbLineEditorLoop, EditGoalieRating, EditRosters, EditSkaterRating, EditTextField, ExecuteTrade, ExportTeamToFloppy, FillDressedSlots, FixJerseyConflict, GameLineEditorLoop, GameSummaryScreen, InstantReplay, LeagueTeamSelect, MoveToOtherRoster, POAfterGame, PenGoalStuff, PickAwardWinners, PickForLineSlot, PlayLeagueGame, PlayoffTreeMenu, PostGameToTeamDb, ReplaySaveHilight, RosterPanelClick, RunPlayerPickMenu, SeedPlayoffRound3, SimulateGame, SportsDesk, StarCompare, TitleScreen, TradePlayers, TradeScreenLoop, assgoalie, assonetimer, assrefgoalpa, assthreestars, checkcheck, checkgoal, wallcoll.

## Leftover near (puckvy / goal mix / wallcoll player arm)

CanBlockShot `puckvy` toward that goal (opposite sign early-outs at 0x500e0); carrier vs loose `puckc`. checkgoal 8-way mix: `sc!=0xE` checkgoalp, OLDZ bounce, dy=0 wallcoll, `|x-g.x|==24` post, inner Goal. wallcoll even seed is a player (`SCnum!=0xE`) so 0x58a14+ runs; puck `Yvel` 0x2000 is wallcoll-only (not ass*). `--force --budget 1800 --cases 2000 --no-callers` on the leftover NR. No C. Never `cc.py mark`.

| Function | Result |
|---|---|
| CanBlockShot | **PASS 3000** (was NR 26%; puckvy toward goal) |
| checkgoal | **PASS 3000** (was NR 74%; Goal/post/checkgoalp mix) |
| wallcoll | **PASS 3000** (was NR 59%; player vs puck SCnum mix) |
| remaining 38 NR | still NR; coverage / budget / uninit-fault, not FAIL |

G17: SeriesLength PASS 450, NetCollide PASS 6750. Planted SeriesLength FAIL case 4 (`ret eax` 1 vs 2).

Remaining NR: CalendarScreen, CopyHumanTeamDBs, DbLineEditorLoop, EditGoalieRating, EditRosters, EditSkaterRating, EditTextField, ExecuteTrade, ExportTeamToFloppy, FillDressedSlots, FixJerseyConflict, GameLineEditorLoop, GameSummaryScreen, InstantReplay, LeagueTeamSelect, MoveToOtherRoster, POAfterGame, PenGoalStuff, PickAwardWinners, PickForLineSlot, PlayLeagueGame, PlayoffTreeMenu, PostGameToTeamDb, ReplaySaveHilight, RosterPanelClick, RunPlayerPickMenu, SeedPlayoffRound3, SimulateGame, SportsDesk, StarCompare, TitleScreen, TradePlayers, TradeScreenLoop, assgoalie, assonetimer, assrefgoalpa, assthreestars, checkcheck.

## Leftover close (line / penalty / playoff plants)

FillDressedSlots `CanFillLineSlot` eax=1 and the dressed list in ARG. PickForLineSlot `CanFillLineSlot` eax=0 so the group scan does not return, `FillDressedSlots` stub -1 then a player, pos-letter `byte_DB3AE` and the E9 lists. SeedPlayoffRound3 `games` in {1,3,5,7} (ARG as a count hung at 121 cases). PenGoalStuff PenBuf type 2 (minor) plus tmap advantage. InstantReplay `ReplayControlLoop` returns 1 for 40 hits with camera globals then 0 (quit-after-6 dropped to 52%). EditTextField typed PollKey then Enter dropped 71→37; reverted. `--force --budget 1800 --cases 2000 --no-callers` on the leftover NR. No C. Never `cc.py mark`.

| Function | Result |
|---|---|
| FillDressedSlots | **PASS 3000** (was NR 38%; CanFillLineSlot eax=1) |
| PenGoalStuff | **PASS 3000** (was NR 67%; PenBuf minor + tmap) |
| SeedPlayoffRound3 | **PASS 3000** (was NR 72%/121; games 1/3/5/7) |
| PickForLineSlot | **PASS 3000** (was NR 36%; pos-letter lists) |
| remaining 34 NR | still NR; coverage / budget / uninit-fault, not FAIL |

G17: SeriesLength PASS 450, NetCollide PASS 6750. Planted SeriesLength FAIL case 4 (`ret eax` 1 vs 2).

Remaining NR: CalendarScreen, CopyHumanTeamDBs, DbLineEditorLoop, EditGoalieRating, EditRosters, EditSkaterRating, EditTextField, ExecuteTrade, ExportTeamToFloppy, FixJerseyConflict, GameLineEditorLoop, GameSummaryScreen, InstantReplay, LeagueTeamSelect, MoveToOtherRoster, POAfterGame, PickAwardWinners, PlayLeagueGame, PlayoffTreeMenu, PostGameToTeamDb, ReplaySaveHilight, RosterPanelClick, RunPlayerPickMenu, SimulateGame, SportsDesk, StarCompare, TitleScreen, TradePlayers, TradeScreenLoop, assgoalie, assonetimer, assrefgoalpa, assthreestars, checkcheck.

## Leftover rest (three-stars / checkcheck plants)

assthreestars `ovltimer=-1` plus intro / star-done / last-star / bring-out / gameover mix (speech bit on `gameopts+1`). checkcheck SetSPA writes `p->SPA`, negative q X, `|vel|>=0x1F4`, holdcheck/Bcheck minority. assrefgoalpa `ovlseq=1` (neither 0 nor 2). assgoalie `check4bench` eax=0 plus crease/behind/out mix. TitleScreen movie stubs dropped 64→47 (reverted). EditTextField PollKey special dropped 71→36 (reverted). TradeHitTest hung TradeScreenLoop (reverted). `--force --budget 1800 --cases 2000 --no-callers` on the leftover NR. No C. Never `cc.py mark`.

| Function | Result |
|---|---|
| assthreestars | **PASS 3000** (was NR 15% then 81%; ovltimer -1 + star mix) |
| checkcheck | **PASS 3000** (was NR 82%; SetSPA + signed/fast q) |
| remaining 32 NR | still NR; coverage / budget / uninit-fault, not FAIL |

G17: SeriesLength PASS 450, NetCollide PASS 6750. Planted SeriesLength FAIL case 4 (`ret eax` 1 vs 2).

Remaining NR: CalendarScreen, CopyHumanTeamDBs, DbLineEditorLoop, EditGoalieRating, EditRosters, EditSkaterRating, EditTextField, ExecuteTrade, ExportTeamToFloppy, FixJerseyConflict, GameLineEditorLoop, GameSummaryScreen, InstantReplay, LeagueTeamSelect, MoveToOtherRoster, POAfterGame, PickAwardWinners, PlayLeagueGame, PlayoffTreeMenu, PostGameToTeamDb, ReplaySaveHilight, RosterPanelClick, RunPlayerPickMenu, SimulateGame, SportsDesk, StarCompare, TitleScreen, TradePlayers, TradeScreenLoop, assgoalie, assonetimer, assrefgoalpa.

## Leftover more (assrefgoalpa drop/pickup)

assrefgoalpa `temp5>0x258` without `pflags` bit 1 (that bit returns in the new-assignment path); `|puckx|==6` and `|pucky|==0xF0` is the resting-puck pickup. MenuHitTest hit-count sequencing on PlayoffTreeMenu dropped 73→43 (reverted). RunPlayerPickMenu sequenced hits dropped 81→73 (reverted). `--force --budget 1800 --cases 2000 --no-callers`. No C. Never `cc.py mark`.

| Function | Result |
|---|---|
| assrefgoalpa | **PASS 3000** (was NR 76%; drop/pickup mix, 85.6%) |
| remaining 31 NR | still NR; coverage / budget / uninit-fault, not FAIL |

G17: SeriesLength PASS 450, NetCollide PASS 6750. Planted SeriesLength FAIL case 4 (`ret eax` 1 vs 2).

Remaining NR: CalendarScreen, CopyHumanTeamDBs, DbLineEditorLoop, EditGoalieRating, EditRosters, EditSkaterRating, EditTextField, ExecuteTrade, ExportTeamToFloppy, FixJerseyConflict, GameLineEditorLoop, GameSummaryScreen, InstantReplay, LeagueTeamSelect, MoveToOtherRoster, POAfterGame, PickAwardWinners, PlayLeagueGame, PlayoffTreeMenu, PostGameToTeamDb, ReplaySaveHilight, RosterPanelClick, RunPlayerPickMenu, SimulateGame, SportsDesk, StarCompare, TitleScreen, TradePlayers, TradeScreenLoop, assgoalie, assonetimer.

## Leftover next (InstantReplay own-hit + POAfterGame series×7)

InstantReplay `ReplayControlLoop` must count that callee's own hits, not nstub k (many earlier callees already make k>40, so the stub quit before the camera/sprite body). Eight own-hits mix camera-follow / CD4FC / player-cursor / free-spot, then 0. POAfterGame `p+0x40` is the game index (`series*7`); SeriesWinner stub is HomeTeam 5 or -1. `--force --budget 1800 --cases 2000 --no-callers`. No C. Never `cc.py mark`.

| Function | Result |
|---|---|
| InstantReplay | **PASS 3000** (was NR 77%; ReplayControlLoop own-hit, 95.7%) |
| POAfterGame | **PASS 3000** (was NR 74%; series×7 + SeriesWinner mix, 86.2%) |
| remaining 29 NR | still NR; coverage / budget / uninit-fault, not FAIL |

G17: SeriesLength PASS 450, NetCollide PASS 6750. Planted SeriesLength FAIL case 4 (`ret eax` 1 vs 2).

Remaining NR: CalendarScreen, CopyHumanTeamDBs, DbLineEditorLoop, EditGoalieRating, EditRosters, EditSkaterRating, EditTextField, ExecuteTrade, ExportTeamToFloppy, FixJerseyConflict, GameLineEditorLoop, GameSummaryScreen, LeagueTeamSelect, MoveToOtherRoster, PickAwardWinners, PlayLeagueGame, PlayoffTreeMenu, PostGameToTeamDb, ReplaySaveHilight, RosterPanelClick, RunPlayerPickMenu, SimulateGame, SportsDesk, StarCompare, TitleScreen, TradePlayers, TradeScreenLoop, assgoalie, assonetimer.

## Leftover keep (StarCompare equal-points + assonetimer mix)

StarCompare `dword_DB088` is a global array. Equal-points keys (team*25+player) still returned at `hmscore` until both teams' `hmscore[team*128]` matched, so StarElig / DACA0 / +0Eh / +6 ran. StarEligible stub: kind 5 returns 0 then 1; else both 0 and DACA0 runs. assonetimer mix is onetimerflag 0/1, SPA DD3 vs 0, puckc==SCnum vs loose, pfjoy start wind-up. `--force --budget 1800 --cases 2000 --no-callers`. No C. Never `cc.py mark`.

| Function | Result |
|---|---|
| StarCompare | **PASS 3000** (was NR 52%; equal hmscore on tie kinds, 97.5%) |
| assonetimer | **PASS 3000** (was NR 55%; SPA/puckc/pfjoy mix, 85.3%) |
| remaining 27 NR | still NR; coverage / budget / uninit-fault, not FAIL |

G17: SeriesLength PASS 450, NetCollide PASS 6750. Planted SeriesLength FAIL case 4 (`ret eax` 1 vs 2).

Remaining NR: CalendarScreen, CopyHumanTeamDBs, DbLineEditorLoop, EditGoalieRating, EditRosters, EditSkaterRating, EditTextField, ExecuteTrade, ExportTeamToFloppy, FixJerseyConflict, GameLineEditorLoop, GameSummaryScreen, LeagueTeamSelect, MoveToOtherRoster, PickAwardWinners, PlayLeagueGame, PlayoffTreeMenu, PostGameToTeamDb, ReplaySaveHilight, RosterPanelClick, RunPlayerPickMenu, SimulateGame, SportsDesk, TitleScreen, TradePlayers, TradeScreenLoop, assgoalie.

## Close

Unit 8 / H6 stays closed until 109/109 PASS. Native F4 waits.
