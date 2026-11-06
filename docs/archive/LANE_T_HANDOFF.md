# Lane T handoff (2026-10-26)

Abdul is out of usage until Friday. Lane T (Abdul's Claude) stops here; this file hands its work to Mark
(lane 1) and StaticEck (lane 2). The plan is the one on the board (`docs/board/2026-10-26-1427-abdul.md`).
State: 976 of 1084 matched; 108 drafts left (56 at 20 differing or fewer).

## What we learned today (read this first)

An in-depth look at one draft (JoystickCalScreen, 11) showed why the tools have not been matching:

1. **The compiler model is exact.** The Python replay of the savings sort (`slotdump.shell_sort`) gives the
   compiler's own order, so "which conflict list gives this order" can be computed.
2. **The old tie targets were too strict.** tieorder reported a whole forced order of a run (9 swaps for
   JoystickCalScreen); only one pair matters (t55 before t54). Fixed (abdulahmad/NHL95PC#241): tieorder now prints
   `minimal target:` and targetsearch aims only at it. A second fix (#242) tells apart temporaries with the same
   defining instruction (both JoystickCalScreen temporaries are `cnv [0+t53]u2`).
3. **The search still cannot produce the edit.** With the right target, targetsearch ran 1065 candidates on
   JoystickCalScreen: none puts t55 before t54 without changing the code; ten hand edits neither (logged in
   docs/draft_history.csv). The missing piece is guessing the natural C the original had: judgment, not compute.
   That is the job for the Fable run below.

## The Fable run (StaticEck volunteered)

Five drafts where forcing one pair of tied conflicts gives the EXE bytes exactly. Each needs a natural source
edit (AGENTS.md rules: no tie-breaker copy, no dead-variable reuse, no no-op cast, no goto, no volatile) that
gives that pair order and leaves every other instruction the same.

| Draft | File | Now | Minimal target (pass 0) | The two conflicts |
|---|---|---|---|---|
| JoystickCalScreen | src/c/050_6B093_joystick_calibration/JoystickCalScreen.c | 11 | t55 before t54 | L59 the two size factors `((short *)s.shape)[3]` (t55) and `[2]` (t54) of the PuckBack size |
| NetCollide | src/c/040_53294_engine_physics_ai/PassLaneChk.c | 22 | t21 before t20 | L230 the two ABS temporaries: t21 = ABS(ux), t20 = ABS(uy), compared `if (t20 >= t21)` |
| POInitSchedule | src/c/064_86696_season_playoffs/POCreateSchedule.c | 6 | t8 before t10 | t10 = L94 `po + t7` address in the loop; run tieorder for t8 |
| PenGoalStuff | src/c/045_614C2_scoring_penalty_text/InProgress.c | 19 | t75 before t79 | L336: t75 = the byte address `t74 + t65`, t79 = its byte read (`cnv [0+t75]u1`) |
| EditTextField | src/c/023_2FDD1_misc_dialogs/EditTextField.c | 7 | parameter x before w (savings 3) | the EXE has x in EBP; with x reused as the insert state it matches (dead-variable reuse, rejected) |

PickAwardWinners (5) was still being searched; run tieorder on it first (`--minutes 25`).
checkpuckcoll (0 only with the dead height h reused for the body frame; its own local: 99) is the harder
follow-up of the same kind.

### How to work one draft

```
python3 tools/wccre/tieorder.py SRC FUNC --minutes 20        # prints `minimal target: A before B`
python3 tools/wccre/irdump.py SRC FUNC --pass 0              # what A and B are (line, instruction)
python3 tools/wccre/tieinverse.py SRC FUNC A B               # which conflict-list changes give A before B
python3 tools/wccre/targetsearch.py SRC FUNC --minutes 30    # scores edits: differing, other, unmet target
```

`tieinverse.py` (new) replays the sort for the current draft and lists every single change of the conflict
list that works: dropping one conflict, adding one at a place (with the savings that work), moving one. For
JoystickCalScreen: dropping any of 17 conflicts works (t45 / t46 / t96 of the L57 memcpy, t98 / t99 of the
L81-82 calls, the globals shift / side / prev / back / s, ...), and adding one works anywhere from L59 back to
L45. So the list is easy to change; the hard part is an edit that changes it **without changing the code**.

A candidate is right when targetsearch prints `0 other` and `0 unmet` (then the byte count follows); confirm a
match with `make fullcheck` before committing it. Log every attempt in docs/draft_history.csv. Check after the
first two or three drafts: if none matches, stop and keep the allocation.

## Other lane T threads, now yours

* **The sweep (plan step 1).** Every small register / slot draft through tieorder (now with minimal targets)
  and targetsearch. Only POInitSchedule and JoystickCalScreen ran, both before the fixes. Worth rerunning only
  if the Fable run shows which edits work.
* **ResetGameVars (20):** not a tie and not the late picks (latepick.py shows the EXE's registers already). The
  difference is a later pass that keeps or drops the zero / -1 loads (board 2026-10-26-0340).
* **TreeSeriesWinner (35):** under -od the slots follow creation order; what makes the EXE create the return
  temporary t4 first and the parameters in register order is open (board 2026-10-26-0315).
* **DrawListItem (6):** matching it also frees DrawListItems (0), two functions for one (Mark).
* **Decision still with Abdul (Friday):** tie-breaker copies and dead-variable reuse stay rejected; accepting
  them as tagged matches would give checkpuckcoll and EditTextField at once.
* Lane T holds no claims. The worktrees and scratch files were in Abdul's session and are gone with it.
