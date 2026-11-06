# Leftover proofs (109-plan H1)

No DOSBox-X dumps. MATCH stays 977/1084. Never `cc.py mark`.

Live leftover after H1: **59 PASS / 0 FAIL / 50 NR**.

## H1 (soft traps) + list-count clamps

`mostly_trapped` no longer counts a stopping trap on a case that also hit `null page`. uninit stack read stays review.

| Function | Result |
|---|---|
| POSeedTeams | **PASS 3000** (was NR mostly trapped; 2987 null-page cases) |
| DrawListItems | **PASS 3000** (was 33 cases: `n` was ARG. Clamp loop count to 1..20) |
| ListDialog | **PASS 3000** (GetInputEvent dummy events + ListHitTest in-rect + `n` 1..20, marks 0) |

G17 pilots PASS (NetCollide at 3000; 200 cases is 83% coverage). Planted SeriesLength FAIL at case 4 (`ret eax` 1 vs 2).

SportsDesk: GetInputEvent stub on even cases FAILed `writes[13]` through wild menus (0x78c3be44 vs 0x78c3be74). Event stub is ListDialog-only. SportsDesk restored **NR** 79 cases, 47% coverage, budget.

## NEEDS-REVIEW (50)

Coverage holes and budget-starved screen loops remain. H2 (`--budget 1800` on the named screen loops) and H3 (collide indices already in; menu event stubs not yet, except ListDialog) then H4 recheck. Dead-range still needs a disasm proof (H5). Not accept-for-link.

## Close

Unit 8 / H6 stays closed until 109/109 PASS.
