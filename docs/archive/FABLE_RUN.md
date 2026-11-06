# The Fable run: five drafts one tie pair away

For StaticEck's Fable session (lane 2). Background: docs/LANE_T_HANDOFF.md. Read AGENTS.md first.

For each draft below, forcing ONE pair of tied register conflicts into the other order makes the function
compile to the EXE bytes exactly. The tools find the pair but not the source change that gives it (1065
targetsearch candidates on JoystickCalScreen, none). Your job is the judgment part: the natural C the original
programmer most likely wrote, which gives that pair order and leaves every other instruction the same.

| Draft | File | Off | Pair needed (pass 0) |
|---|---|---|---|
| JoystickCalScreen | src/c/050_6B093_joystick_calibration/JoystickCalScreen.c | 11 | t55 before t54: L59, the size factors `((short *)s.shape)[3]` (t55) and `[2]` (t54) |
| NetCollide | src/c/040_53294_engine_physics_ai/PassLaneChk.c | 22 | t21 before t20: L230, t21 = ABS(ux), t20 = ABS(uy), `if (t20 >= t21)` |
| POInitSchedule | src/c/064_86696_season_playoffs/POCreateSchedule.c | 6 | t8 before t10: t10 = L94 `po + t7` in the loop |
| PenGoalStuff | src/c/045_614C2_scoring_penalty_text/InProgress.c | 19 | t75 before t79: L336, t75 = byte address `t74 + t65`, t79 = its byte read |
| EditTextField | src/c/023_2FDD1_misc_dialogs/EditTextField.c | 7 | parameter x before w at savings 3 (EXE has x in EBP; x reused as the insert state matches but is dead-variable reuse, rejected) |

## Steps for one draft

1. `python3 tools/wccre/tieorder.py SRC FUNC --minutes 20`: confirms `minimal target: A before B`.
2. `python3 tools/wccre/irdump.py SRC FUNC --pass 0`: what A and B are (block, line, instruction).
3. `python3 tools/wccre/tieinverse.py SRC FUNC A B`: which conflict-list changes would give A before B
   (drop one conflict, add one at a place, move one). JoystickCalScreen: dropping any of 17 conflicts works,
   adding one anywhere from L59 back to L45. The list is easy to change; the hard part is changing it
   without changing the code.
4. Read the C and the diff (`python3 tools/cdiff.py SRC --func FUNC`), and docs/draft_history.csv for what
   was already tried. Try edits; score each with `python3 tools/wccre/targetsearch.py SRC FUNC --minutes 5`.
   Right means `0 other` (only registers differ) and `0 unmet` (the pair is right); then differing goes to 0.
5. On a match: post a claim on the board, `make fullcheck` (MATCH both builds), commit
   `MATCHED <function>`, one small PR each, score line in the body.

## Rules

* No tie-breaker copies, dead-variable reuse, no-op casts, goto, volatile, wrong return types or hand-asm.
  A match that needs one is an escalation (docs/ESCALATIONS.md), not a match.
* Watcom 10.0 GA, no new -od.
* Log every attempt in docs/draft_history.csv (shape tried, score).
* Never run scoring tools in the checkout where `make fullcheck` is running.

## Budget

Do JoystickCalScreen and NetCollide first. If neither matches, stop: post what you learned (which edits moved
the pair, which changed the code) on the board and in draft_history, and end the run. If one matches, go on.
