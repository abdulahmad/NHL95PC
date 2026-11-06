# Functional-equivalence plan for the last drafts

Status: finish bar closed. Every leftover draft is PASS, FAIL-parked, or advisor-accepted for native ([FUNCTIONAL_ACCEPT.md](FUNCTIONAL_ACCEPT.md)). See [FUNCTIONAL_HANDOFF.md](FUNCTIONAL_HANDOFF.md). Next *native* unit is gcc smoke (native F4), not a functional unit. Steps 10–11 (`FUNCTIONAL=1`, nightly) stay later.
Each step below is done on its own, in order, and stops for Abdul's approval before the next one starts.

## Why

977 of 1,084 functions are byte-matched. The ~109 drafts left (about 176 KB of code, many of them the biggest
functions) are mostly register-allocator near-misses: 68 rows have cause `register`, 28 `size`, 11 `slot`
(`tools/match/c_functions.csv`). The C in those drafts is usually already the right program; only Watcom's register
choice differs. Closing that last gap by hand needs top-tier models and lots of time.

So for these drafts we change the bar from **bit-identical** to **proven to behave the same**: run the original
asm and the compiled draft side by side in a CPU emulator from the same starting state and require identical
observable results over thousands of cases. A draft that passes is marked `FUNCTIONAL`. It is a different,
weaker claim than `MATCH`, and the docs and progress counts keep the two apart.

What does not change:

* `main` still only takes byte-identical builds. `make` and `make CBUILD=0` must MATCH. FUNCTIONAL drafts stay
  unmarked (no `cc.py mark`), so the default build keeps their asm.
* Matching work by lanes 1 and 2 goes on as before. A FUNCTIONAL draft can still be matched later and moves to
  `MATCH`.
* The 13 hand-asm functions stay asm and are out of scope.

## How the check works

`tools/equiv/` (lane T), driven by `python3 tools/equiv/check.py src/{engine,front,pc}/<mod>/<F>.c --func F`:

1. **Image.** Load `HOCKEY.EXE`'s LE objects at their linear addresses with fixups applied (reuse
   `tools/build/le_parse.py`; `tools/match/wccre/lx_load.py` already does this for LX) into Unicorn. This gives the real
   code and the initial data image (dseg02).
2. **Original side.** The function's original bytes run in place at their EXE address.
3. **C side.** `tools/match/cc.py compile` the draft (existing DOSBox path, cached by source hash), read the OMF with
   `tools/match/cobj.py`, place the code in a scratch region and resolve its fixups to the same label addresses the
   asm uses (`cdiff.py` already maps labels). Both sides therefore see the same globals and the same callees.
4. **Inputs.** One case = a starting state: argument registers (Watcom passes `eax, edx, ebx, ecx`, then the
   stack), the other registers, and data memory. Sources, in order of cost:
   * the static data image plus random and edge values (0, -1, 1, maximums, boundaries) for arguments and for
     the globals and struct fields the function reads (found from the asm's memory operands);
   * later, real states captured at the function's entry from the game running in DOSBox-X (step 9).
5. **Callees.** Every call that leaves the function hits a stub: log the target and its arguments, return a
   value from a per-case script so both sides get the same answers in the same order. `__CHK` is a no-op stub.
   One function is tested at a time.
6. **Compare.** At `ret`: `eax` (and `edx` for 64-bit returns), every register the original preserves, every
   write to memory outside the function's own stack frame (address, size, value, in order), and the call log.
   Any difference fails the case and prints the first diff in a few lines.
7. **Trap, don't hide.** Port I/O, `int`, self-modifying code, reads of memory nothing wrote (uninitialised
   locals) and flag-dependent results are reported as `NEEDS-REVIEW`, not silently passed. Example:
   `SeriesLength` returns whatever `esi` held when no games were played; the draft's uninitialised `len` may not.
8. **Pass rule.** `FUNCTIONAL` = N cases (start at 2,000; the advisor confirms N in step 6) with zero diffs and
   no unreviewed traps. Results are logged to `tools/equiv/results.csv` (function, source hash, cases, result,
   first diff) and a passed source hash is never re-run.

Optional for short pure-maths functions later: symbolic proof (angr) for all inputs. Final check, much later:
a `FUNCTIONAL=1` build plus whole-game replay against retail, which is the same harness the native ports and
rollback netplay need.

## Agent practices, mapped onto this task

From the agent-harness notes (Grok chat): cheap workers in tight check-fix loops, an advisor model only at three
moments, a check that a program can fail, retries per failed unit, and a learning edge.

| Practice | Here |
|---|---|
| A check a program can fail | `tools/equiv/check.py` PASS/FAIL. "Looks right" or "the model is confident" never marks a function. |
| Work in units | One function (one draft C file) per unit. A worker gets that file, its asm block and its UNSURE entry, not the whole repo. |
| Cheap model does the loop | Running checks, logging and bookkeeping go to the cheapest tier. Fixing C after a real behaviour diff goes to the mid tier. |
| Advisor at three moments only | Top tier is consulted (1) before a plan locks, (2) after the same failure twice on one function, (3) before a step is called done. Never for routine runs. |
| Retry only the failed unit, max 3 | A FAIL sends back only that function. After 3 failed fixes it is parked in `docs/UNSURE.md` with the diffs, and the advisor sees it at most once. |
| Learning edge | Every confirmed cause (a C idiom that changes behaviour, a harness blind spot) becomes one line in `docs/RULES.md`, which workers read first. |
| Gating by risk | Nothing FUNCTIONAL touches the default build. Abdul approves each step and each merge. |
| Tool-agnostic | `AGENTS.md` stays the single source of rules. `CLAUDE.md` and `.cursor/rules/main.mdc` only point to it, so Claude Code and Cursor can be swapped week to week. Handoff state lives in `HANDOFF.md` and this file. |
| Night shift | A scheduled run of `make fullcheck` plus the equivalence suite that reports and proposes PRs but merges nothing (last step). |

**Model tiers** (from the same chat; names per tool, the job decides the tier):

| Tier | Job | Claude | Cursor |
|---|---|---|---|
| Cheap | Mechanical: docs, stubs, running checks, logging, CSV/bookkeeping | Haiku | Composer 2.5 |
| Mid (code like existing code) | Code that follows a pattern already in the repo | Sonnet | Grok 4.6 medium |
| Mid (new code) | New harness code, unclear behaviour diffs | Sonnet | Grok 4.7 medium |
| Advisor | Only at the three moments above | Opus | Grok 4.7 high |

No fast variants. Escalate one tier at a time.

## Budget rules

* One step at a time, in its own short session, ending in a small PR. Stop for approval.
* A session reads only what its step names (this file, `AGENTS.md`, `docs/RULES.md`, and the files listed in
  the step), not the whole docs tree.
* Check output is compact (verdict plus first diff). Compiles are cached by source hash; passed hashes are never re-run.
* Draft functions are taken smallest first, so the harness is proven on cheap cases before big ones.

## Steps

Each step: goal, model, what "done" means. Rough size is for one session.

| # | Step | Model (Claude / Cursor) | Done when |
|---|---|---|---|
| 0 | This plan (advisor moment 1: before the plan locks). | Opus / Grok 4.7 high | Abdul approves this file. |
| 1 | **Agent rules.** Add to `AGENTS.md` a short "Functional track" section: the three advisor moments, retry-3-failed-unit-only, a worker edits only its unit's C file and its rows. Create `docs/RULES.md` (learning edge, starts nearly empty). Add `.cursor/rules/main.mdc` ("Read and follow AGENTS.md") and `.claude/agents/` worker (Haiku), fixer (Sonnet) and advisor (Opus) definitions. | Haiku / Composer 2.5 | Files in, `make fullcheck` untouched, PR merged. |
| 2 | **Image loader.** `tools/equiv/image.py`: LE objects into Unicorn with fixups applied. Self-test: bytes at 3 known function addresses equal `src/` and a known global's initial value is right. Add `unicorn` to HANDOFF setup. | Sonnet / Grok 4.6 medium | Self-test passes. |
| 3 | **Run one original function.** `tools/equiv/run.py`: entry state in, run to `ret`, call stubs with a log, `__CHK` stub, traps for `in`/`out`/`int`, write log out. Try it on 3 matched functions. | Sonnet / Grok 4.7 medium | Runs end at `ret` with sane logs. |
| 4 | **C side.** Compile a draft through `cc.py`, relocate the `cobj.py` output to a scratch address against the same labels. Sanity check: for a **matched** function the C side and the original give identical results on every case (it must, the bytes are the same). | Sonnet / Grok 4.6 medium | Matched functions compare equal. |
| 5 | **Comparator, case generator, `check.py`.** Pilot on `SeriesLength` (116 bytes, `size` draft) and `FadePalette` (227 bytes, `register` draft). Also a planted bug in a copy of a draft must FAIL. | Sonnet / Grok 4.7 medium | Pilots give a verdict; planted bug caught. |
| 6 | **Advisor review of the harness** (moment 1 again, before the loop locks): blind spots, N, stack-frame rule, traps. Findings go to `docs/RULES.md`. | Opus / Grok 4.7 high | Short review merged; fixes, if any, done by Sonnet. |
| 7 | **FUNCTIONAL status.** `tools/equiv/results.csv` as the list; `tools/match/c_progress.py` shows matched and functional separately (functional never counts as matched). | Haiku / Composer 2.5 | C_PROGRESS shows both counts. |
| 8 | **The loop.** Drafts smallest first, a batch of ~5 per session: cheap worker runs `check.py`; on PASS it logs; on FAIL a Sonnet fixer changes the C for behaviour (not register shape), max 3 tries, then park. Advisor only after the same failure twice. One PR per batch. | Haiku runs, Sonnet fixes / Composer 2.5, Grok 4.7 medium | All drafts PASS or parked. |
| 9 | **Real inputs.** DOSBox-X debugger script that snapshots RAM and registers at a function's entry during play (on Abdul's machine). Feed the snapshots to the drafts that only passed on synthetic input or that sit on game state (engine segments). | Sonnet / Grok 4.7 medium | Snapshots for the engine drafts; re-check passes. |
| 10 | **`FUNCTIONAL=1` build.** Feasibility first: drafts of the same size splice like matched ones; shorter ones pad; longer ones need their mid-function labels moved or the body placed elsewhere with a jump. Advisor before starting. Default build untouched. | Opus plan, then Sonnet / Grok 4.7 high, then 4.7 medium | `make FUNCTIONAL=1` boots and plays. |
| 11 | **Night shift.** Scheduled `make fullcheck` plus `check.py` on all FUNCTIONAL rows; reports regressions, proposes PRs, merges nothing. Advisor moment 3 for the whole track. | Haiku / Composer 2.5 (Opus once to sign off) | Routine runs and reports. |

Whole-game replay (record inputs, compare state every frame against retail) comes after step 11 and is shared
with the ports and netplay work; it is not part of finishing the decompilation.

## Keeping the way back to MATCH open

FUNCTIONAL is a resting state, not a dead end. Everything needed to resume byte-matching later stays in the repo:

* **The original asm never goes away.** A FUNCTIONAL draft stays unmarked, so its block in `src/cseg01/*.asm` is
  still the code `make` builds and the exact reference `tools/match/cdiff.py` diffs against.
* **The draft stays the closest known shape.** A functional fix changes only what behaves differently. Before and
  after it, run `python3 tools/match/cdiff.py` on the file and record both scores in `docs/draft_history.csv`, with what
  changed. A fix that makes the byte score worse says so in the row and in the draft's comment.
* **The diff notes stay.** The draft's `DRAFT:` comment, its `tools/match/c_functions.csv` notes and cause, its
  `docs/UNSURE.md` entry and its history rows are kept and updated, never deleted, when it passes.
* **The proof stays.** `tools/equiv/results.csv` keeps the source hash each verdict was for, so a later edit that
  moves a draft toward a match is re-checked automatically (the hash no longer matches, so it no longer counts).

To resume matching a FUNCTIONAL function: read its `DRAFT:` comment, its `docs/UNSURE.md` entry and its
`docs/draft_history.csv` rows, then follow the normal workflow in `docs/C_MATCHING.md` (`cdiff.py`, `permute.py`,
`tools/match/wccre`). When it matches, `cc.py mark` it as usual: it moves from FUNCTIONAL to matched by itself.

## Risks

* Random inputs miss paths that only real game state reaches: steps 9 and the advisor review cover this.
* Undefined C behaviour and uninitialised reads can differ by luck: the harness traps them (`NEEDS-REVIEW`).
* Floating point: the game links EMU387 (`-fpi`); Unicorn runs x87 natively, so compare FPU state for the few
  functions that use it.
* Split and multi-block functions (shared tails) are tested per entry point, with the shared tail on both sides.
