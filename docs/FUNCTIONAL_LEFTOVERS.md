# Leftover proofs (109-plan)

No DOSBox-X dumps. MATCH stays 977/1084. Never `cc.py mark`.

Live leftover after H4/H5: **61 PASS / 0 FAIL / 48 NR**. RandomizeSchedule PASS 3000.

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

## Close

Unit 8 / H6 stays closed until 109/109 PASS. Native F4 waits.
