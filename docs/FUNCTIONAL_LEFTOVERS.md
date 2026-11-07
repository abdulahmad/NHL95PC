# Leftover proofs (109-plan)

No DOSBox-X dumps. MATCH stays 977/1084. Never `cc.py mark`.

Live leftover after H3: **60 PASS / 0 FAIL / 49 NR**. RunMenu PASS 3000.

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

## NEEDS-REVIEW (49)

H4: `--force --budget 1800 --cases 2000 --no-callers` on remaining NR. Dead-range still needs a disasm proof (H5).

## Close

Unit 8 / H6 stays closed until 109/109 PASS.
