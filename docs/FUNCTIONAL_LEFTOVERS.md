# Leftover proofs (107-PASS Unit 7)

Advisor moment 3 after Unit 6. Dumps are still missing. Unit 8 does **not** close: FUNCTIONAL is 56, not 109.
Allowed outcomes: (a) one more harness rule that then PASSes, (b) dead-range PASS with disasm proof,
(c) confirmed C bug → fixer max 3, (d) **not** accept-for-link.

## FAIL (0 remaining)

| Function | Outcome | Result |
|---|---|---|
| SportsDesk | **(c)** C fixer, `SportsDesk.c` only | Autoret exit at `1992A` now stores `sub_B2E1B`'s `eax` into `scrolly` (`DD6AA`), then `scrollx`, then zeros `deferpending` (`C5840`). The `r == 1` path at `19D2F` still only clears `deferpending`. **FAIL→NR** 47% mostly trapped (116 cases). Unmarked (MATCH shape scored 455 on the 192 base). |
| SimPlayoffRound1 | **(a)** harness, no C | Team-index bytes clamped to `[0, 26)` on every ARG pointer in args and regs (eax is sched). SeriesLength stub eax is a real best-of (1, 3, 5, 7). **PASS 3000**. |

## NEEDS-REVIEW (52)

None are dead-range-provable without dumps. One-byte holes can be live instructions (`sar` at `5462E` in `checkpuckcoll_ccx`, store at `344F9` in `DrawCalendarDay`, `jmp` at `63243` in `InProgress`). `check.py` has no dead-range list yet; Unit 6 said only a range unreachable under every retail invariant after a dump goes in `tools/equiv/dead_ranges.txt`.

Wait on Abdul DOSBox-X dumps (`docs/SNAPSHOTS.md`). Callers already stuck on the near-miss engine names:

- `checkpuckcoll_ccx` 84%, `SkateToSpot` 82%, `DrawRinkOverlays` 79%, `InProgress` 76%

Front near-miss with no caller snapshots: `DrawCalendarDay` 80%, `POAfterGame` 74%, `InstantReplay` 74% trapped.

Budget-starved (do not lower the 500-case floor): `DrawListItems` 33, `SeedPlayoffRound3` 38, `ListDialog` 351, `GameLineEditorLoop` 167, `DbLineEditorLoop` 186, `PlayoffTreeMenu` 119. Give `DrawListItems` a longer budget once after dumps; if it still cannot reach 500 agreeing cases it waits with the others.

## Close

Unit 8 stays closed. Native F4 waits until every leftover draft PASSes `check.py` on its current source hash. MATCH stays 977/1084. Never `cc.py mark`.
