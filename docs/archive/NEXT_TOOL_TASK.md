# Next task: teach the rewrite search StaticEck's rules, then rerun the sweep

For Mark's or StaticEck's agent (normal usage, no Fable needed). Read AGENTS.md, docs/LANE_T_HANDOFF.md and
docs/WCC_INTERNALS.md "What source edits do to the list".

**Why.** The tie tools now give each draft an exact one-pair target (tieorder.py `minimal target`) and the list
changes that would give it (tieinverse.py). The automated search still cannot find the C edit: on
JoystickCalScreen 1065 candidates missed what StaticEck's Fable run found (an `unsigned char` local, #247),
because tools/wccre/rewrites.py has no edit of that kind.

## 1. New rewrites (tools/wccre/rewrites.py, used by targetsearch.py)

Add these to `neighbours()` as natural edits (no casts, no copies of a value already held, no dead reuse):

1. **narrow**: a sub-expression whose use needs only the low byte (or word) of an int, a call result or a
   shifted value tested with a small mask like `(x >> s) & 0x30`, stored first in a new `unsigned char` (or
   `unsigned short`) local declared in the function: `b = f() >> s; if ((b & 0x30) == 0)`. Also
   the type of an existing local narrowed when all its uses need only the low part.
2. **declorder**: move a local's declaration, knowing the names walk lists the locals in reverse declaration
   order (permute.py moves declarations but scores blindly; with a target, prefer the moves that change the
   order of the two target conflicts).
3. **alias16**: for names used as 16 bits (HIWORD / short stores), the order of the first 16-bit use decides
   where they are re-listed; reorder independent statements that hold those first uses.

Check each on JoystickCalScreen's pre-match draft (`git show b008c0a6^:src/c/050_6B093_joystick_calibration/JoystickCalScreen.c`):
targetsearch must find the #247 edit or an equivalent from it.

## 2. Rerun the sweep

For the small drafts (20 differing or fewer) whose cause in tools/c_functions.csv is `register` or `slot`
(about 36, list in docs/board/2026-10-26-1427-abdul.md), on your own lane's files or claimed ones:

```
python3 tools/wccre/tieorder.py SRC FUNC --minutes 20        # minimal target, if a tie order gives 0
python3 tools/wccre/targetsearch.py SRC FUNC --minutes 30    # with the new rewrites
```

Run them in separate git worktrees (each needs one `make` for build/parts), never in a checkout where
`make fullcheck` runs. Log every run in docs/draft_history.csv; commit matches as `MATCHED <function>` after
`make fullcheck`. Report the hit rate on the board after the first 10.
