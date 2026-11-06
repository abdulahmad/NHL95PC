# Leftover proofs (109-plan)

No DOSBox-X dumps. MATCH stays 977/1084. Never `cc.py mark`.

Live leftover after H2: **59 PASS / 0 FAIL / 50 NR**. H2 did not add a PASS.

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

## NEEDS-REVIEW (50)

Coverage holes remain. H3 (retail-shaped pointerspr / GetInputEvent / cdecl nreg / MenuHitTest in-param) then H4 recheck. Dead-range still needs a disasm proof (H5).

## Close

Unit 8 / H6 stays closed until 109/109 PASS.
