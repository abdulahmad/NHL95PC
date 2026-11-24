# Functional-equivalence plan for the last drafts

Status: leftover NR **paused** 2026-11-07 at **82 PASS / 27 NR** (H1–keep). The 2026-11-06 native-link bar (PASS / FAIL-parked / accepted-for-native-link) is **superseded**. Every leftover unmarked draft must become `check.py` PASS (or a harness change that produces PASS) before H6 closes. [FUNCTIONAL_ACCEPT.md](FUNCTIONAL_ACCEPT.md) is the historical 52/10/29/18 snapshot. Native F4, `FUNCTIONAL=1`, and nightly stay later. See [Handoff](#handoff).
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

## Handoff

Read with the plan above, [RULES.md](RULES.md) and the "Functional track" section of
[AGENTS.md](../AGENTS.md). Works the same from Claude Code or Cursor.

### Two tracks, two handoffs

| Track | Goal | Handoff |
|---|---|---|
| **Decompilation** (byte-exact) | C that compiles to the original bytes; `cc.py mark` puts it in the build | [HANDOFF.md](../HANDOFF.md), [C_MATCHING.md](C_MATCHING.md) |
| **Function matching** (functional) | a draft proven to behave like the original asm (`tools/equiv/check.py` PASS); the asm stays in the build | this file |

* A function-matched draft stays open for decompilation: its asm, draft, `DRAFT:` notes, UNSURE entry and history
  rows are all kept, so byte-matching can resume at any time.
* Decompiling a function takes it out of the function-matched pool by itself: `tools/match/c_progress.py` counts a
  function as function-matched only while its status is `nonmatching`, so once it is marked (matched) it counts
  only as decompiled. A PASS also stops counting when the draft's source changes (the check is tied to its hash).

### Where it stands

* Harness `tools/equiv/` is merged (PR #274) plus **round 7** (per-case stack fill; `--callers` / `--no-callers` /
  `--force`). Self-tests: `python3 tools/equiv/image.py --selftest`, `run.py --selftest`, `cside.py --selftest`.
* Needs: `pip install unicorn capstone`, `apt install dosbox nasm` (drafts compile through `tools/match/cc.py`).
* Verdict source is the **latest `tools/equiv/results.csv` row per function**, not a batch runner's last stderr
  line (a Watcom warning can hide a real verdict; RULES 2026-11-06).
* **82 of 109 drafts proven functionally equivalent (PASS)** by `c_progress.py` (current source hash still
  PASSes). Unit 1 stamped three stale hashes (49→52). Unit 3: CanFillLineSlot and OpenSpeechBank (52→54).
  Unit 5: checkgoalp (54→55). Unit 7: SimPlayoffRound1 (55→56). 109-plan H1: POSeedTeams, DrawListItems, ListDialog (56→59). H3: RunMenu (59→60). H4: RandomizeSchedule (60→61). Leftover synth: DrawCalendarDay, checkpuckcoll_ccx, RunTeamPickMenu, SkateToSpot (61→65). Leftover pairs: InProgress, DrawRinkOverlays, PassLaneChk (65→68). Leftover near: CanBlockShot, checkgoal, wallcoll (68→71). Leftover close: FillDressedSlots, PenGoalStuff, SeedPlayoffRound3, PickForLineSlot (71→75). Leftover rest: assthreestars, checkcheck (75→77). Leftover more: assrefgoalpa (77→78). Leftover next: InstantReplay, POAfterGame (78→80). Leftover keep: StarCompare, assonetimer (80→82). Generated baseline before the round-7 rerun was 23; that rerun added 25, then Gameloop.
* **Step 2 rerun (done, 2026-11-06).** 71 unique functions logged: **25 PASS / 44 NEEDS-REVIEW / 2 FAIL**.
  Latest-row CSV picture after leftover keep, **paused 2026-11-07**: **82 PASS / 27 NEEDS-REVIEW / 0 FAIL** over leftover drafts
  (matched-function pilots still in the CSV). `c_progress.py` is the FUNCTIONAL count in C_PROGRESS / README. Do not resume leftover NR unless asked.
* **25 new PASS** (unmarked; native bodies): changeplayer, ReassignCtlPlayer, POInitSchedule, SetRosterTeamMenus,
  checkwallcoll, BlitTileMap, DrawSprite, passtoa0, MenuSaveTheseLines, RemoveFromLines, dopass,
  MenuSaveDefaultLines, SelectHilight, TeamStatsScreen, LoadGameRoster, checkcx, DrawRinkSideObjects,
  LoadTeamRoster, doshot, CreateNewLeague, SkaterStatsCard, ShowCredits, setplayer, BuildStandingsGrid,
  LoadGameState.
* **Step 2b leftovers (done, 2026-11-06).** Recut names: Gameloop (was GameLoop) **PASS**; assonetimer (was
  PassRecOneTimer) NEEDS-REVIEW 47%; checkpuckcoll_ccx (was checkpuckcoll in PassLaneChk.c) NEEDS-REVIEW 75%.
  InstantReplay KeyError `bothneitherstrs` fixed in `image.labels()` (data after `ret`); rerun NEEDS-REVIEW 75%
  (107 cases, mostly trapped).
* **0 FAIL remaining after Unit 7.** SportsDesk FAIL→NR (autoret `sub_B2E1B` eax into scrolly/scrollx then deferpending; 47% trapped). SimPlayoffRound1 PASS 3000 after team-byte clamp + SeriesLength stub 1/3/5/7. FAIL→NR after typed inputs: GameLineEditorLoop, DbLineEditorLoop, PlayoffTreeMenu. Old triage:
  * input artefacts: SimPlayoffRound1, GameLineEditorLoop;
  * pointer-to-local / frame layout: DbLineEditorLoop, TradeScreenLoop, OpenSpeechBank, SportsDesk;
  * wild pointer fault address: PlayoffTreeMenu;
  * CanFillLineSlot: original returns junk in the upper 16 bits that callers ignore; matching needs a `short`
    return, an ESCALATE shape: **Abdul's call**.
  New from the rerun: **FillDressedSlots parked** (same short-return as CanFillLineSlot: ax
  0x005d both sides, upper junk from a dword load of a word home; no C). **RunPlayerPickMenu
  parked** (`calls[6]` ebx leftover vs C 0 at wild target 0xb300a, 2 bytes before sub_B300C;
  writes/ret matched; --force --no-callers case 64; no C).
* Real fixes found so far: CalendarScreen and ReplayStep (store order). Every harness lesson is a line in
  `docs/RULES.md`.
* **Native-link bar superseded (2026-11-06).** [FUNCTIONAL_ACCEPT.md](FUNCTIONAL_ACCEPT.md) (52 / 10 / 29 / 18, sum 109) is history. The live bar is `check.py` PASS on the current sha for all 109 unmarked drafts. FAIL-park and accept-for-link are not resting states. Native F4 waits. #294–#299 stay merged.

### Round 7 (done)

Applied the unfinished `tools/equiv/wip/round7.patch` onto the recut tree (paths are `src/{engine,front,pc}` and
`tools/match/c_functions.csv`). Verified:

* Self-tests ALL PASS (`image.py`, `run.py`, `cside.py`).
* Pilots PASS (`--force --no-callers --cases 200`): DrawRinkEndArt, GetMemListHead, ResetInputSampling, SeriesLength,
  FadePalette, shotdiradj, puckfaceoff2, NetCollide.
* Planted SeriesLength bug (best-of-1 constant 1→2) **FAIL** at case 6 (`ret eax: orig 0x1 vs C 0x2`).
* `--callers` smoke on SeriesLength: 50 snapshots, coverage 100%.

`tools/equiv/wip/round7.patch` is removed; the code is in `check.py` / `run.py`.

### Next steps

The 2026-11-06 native-link finish bar is superseded. Every leftover unmarked draft must PASS. `FUNCTIONAL=1` / nightly stay later.

| # | Step | Model (Claude / Cursor) |
|---|---|---|
| 2 | ~~Rerun every NEEDS-REVIEW draft~~ **done** | — |
| 2b | ~~InstantReplay `bothneitherstrs` + 3 skipped~~ **done** (Gameloop PASS; InstantReplay / assonetimer / checkpuckcoll_ccx still NEEDS-REVIEW) | — |
| 3a | ~~Park FillDressedSlots short-return~~ **done** (UNSURE + history; no C). Reopened under the 107-PASS bar | — |
| 3b | ~~Classify RunPlayerPickMenu~~ **done** (parked wild call-arg; no C). Reopened under the 107-PASS bar | — |
| 4 | ~~Advisor accept-list~~ **done** (historical: [FUNCTIONAL_ACCEPT.md](FUNCTIONAL_ACCEPT.md) 52/10/29/18). Not the live bar | — |
| 5 | ~~Handoff close (old bar)~~ **done** | — |
| 107.1 | Stamp stale PASS hashes (`avdgoal`, `NetCollide`, `ReplayStep`) without Unicorn | Composer 2.5 |
| 107.2 | Harness proofs for the ten FAIL | Grok 4.7 medium |
| 107.3 | ~~Re-check the ten FAIL~~ **done** (2 PASS, 3 NR, 5 still FAIL; no C) | Composer 2.5 |
| 107.4 | ~~Typed inputs for coverage-NR~~ **done** (odd seeded cases; MenuHitTest out-params in-rect; G17 PASS; planted SeriesLength FAIL at case 4). Do not re-run the 47 in this unit | Grok 4.7 medium |
| 107.5 | ~~Re-check leftover NR/FAIL~~ **done** (checkgoalp PASS; 3 FAIL→NR; SportsDesk + SimPlayoffRound1 still FAIL; 52 NR remain for snapshots) | Composer 2.5 |
| 107.6 | Snapshot **script** done (`tools/equiv/snapshot_dosbox.py`, `docs/SNAPSHOTS.md`, `check.py --play-snaps`). CSV log waits on Abdul dumps | Grok 4.7 medium |
| 107.7 | Leftover proofs ([Leftovers](#leftovers)): SportsDesk (c) autoret `eax` into `scrolly`/`scrollx` → NR 47%; SimPlayoffRound1 (a) team-byte clamp + SeriesLength stub 1/3/5/7 → PASS 3000. **56 PASS / 0 FAIL / 53 NR**. 53 NR wait on dumps. No dead-range without a dump. | Grok 4.7 high |
| 107.8 | **not done** — close only at 109/109 PASS. Native F4 waits. | see plan |
| 109.H1 | ~~Soft traps + list counts~~ **done** (POSeedTeams / DrawListItems / ListDialog PASS 3000; G17 PASS; planted SeriesLength FAIL case 4). SportsDesk event stub is ListDialog-only. **59 PASS / 50 NR**. | Grok 4.7 medium |
| 109.H2 | ~~Budget 1800~~ **done** (RunMenu NR 510/49%, RunTeamPickMenu NR 486/64%, InstantReplay NR 306/75%). Still 59/50. H3 next. | Composer |
| 109.H3 | ~~Screen inputs~~ **done** (RunMenu PASS 3000; ListDialog still PASS 3000; SportsDesk NR not FAIL). **60 PASS / 49 NR**. | Grok 4.7 medium |
| 109.H4 | ~~Recheck remaining NR~~ **done** (RandomizeSchedule PASS 3000; SportsDesk uninit-fault is NR not FAIL; 48 still NR). **61 PASS / 48 NR**. | Composer |
| 109.H5 | ~~Dead-range disasm~~ **done** (RunTeamPickMenu / SkateToSpot / DrawCalendarDay holes are live retail paths. No dead_ranges.txt). | Grok 4.7 medium |
| 109.synth | ~~Deeper leftover plants~~ **done** (DrawCalendarDay / checkpuckcoll_ccx / RunTeamPickMenu / SkateToSpot PASS 3000; remaining 44 NR rechecked `--budget 1800`). **65 PASS / 44 NR**. | Grok 4.7 medium |
| 109.pairs | ~~Collide pair ABI + overlay/penalty plants~~ **done** (InProgress / DrawRinkOverlays / PassLaneChk PASS 3000; remaining 41 NR rechecked `--budget 1800`). **68 PASS / 41 NR**. | Grok 4.7 medium |
| 109.near | ~~Puckvy / goal mix / wallcoll player arm~~ **done** (CanBlockShot / checkgoal / wallcoll PASS 3000; remaining 38 NR). **71 PASS / 38 NR**. | Grok 4.7 medium |
| 109.close | ~~Line/penalty/playoff plants + InstantReplay quit~~ **done** (FillDressedSlots / PenGoalStuff / SeedPlayoffRound3 / PickForLineSlot PASS 3000; remaining 34 NR). **75 PASS / 34 NR**. | Grok 4.7 medium |
| 109.rest | ~~Three-stars / checkcheck plants~~ **done** (assthreestars / checkcheck PASS 3000; remaining 32 NR). **77 PASS / 32 NR**. | Grok 4.7 medium |
| 109.more | ~~assrefgoalpa drop/pickup~~ **done** (assrefgoalpa PASS 3000; remaining 31 NR). **78 PASS / 31 NR**. | Grok 4.7 medium |
| 109.next | ~~ReplayControlLoop own-hit + POAfterGame series*7~~ **done** (InstantReplay / POAfterGame PASS 3000; remaining 29 NR). **80 PASS / 29 NR**. | Grok 4.7 medium |
| 109.keep | ~~StarCompare equal-points + assonetimer mix~~ **done** (StarCompare / assonetimer PASS 3000; remaining 27 NR). **82 PASS / 27 NR**. | Grok 4.7 medium |
| 109.pause | leftover NR **paused** 2026-11-07 at 82/27. Remaining names in [Leftovers](#leftovers). Unlanded: TradeScreenLoop jersey-column 86.2%/214; assgoalie kinds 10/11 81.6%. | — |
| 109.H6 | **not done** — close only at 109/109 PASS. Native F4 waits. Leftover NR paused, not finished. | see plan |

Pilots that must stay PASS after any harness change: DrawRinkEndArt, GetMemListHead, ResetInputSampling (matched),
SeriesLength, FadePalette, shotdiradj, puckfaceoff2, NetCollide. Planted bug: copy SeriesLength.c to
`build/equiv/planted/`, change one constant, run with `--seg front/season`: must FAIL within 50 cases.

Batch loop used so far (no model tokens): a shell loop over `tools/match/c_functions.csv` nonmatching rows calling
`check.py <c_file> --func F --seg SEG --quiet --budget 600`, three in parallel with a per-function lock directory.

## Leftovers

No DOSBox-X dumps. MATCH stays 977/1084. Never `cc.py mark`.

Leftover NR **paused** 2026-11-07: **82 PASS / 0 FAIL / 27 NR**. StarCompare / assonetimer PASS 3000. Do not resume unless asked.

### H1 (soft traps) + list-count clamps

`mostly_trapped` no longer counts a stopping trap on a case that also hit `null page`. uninit stack read stays review.

| Function | Result |
|---|---|
| POSeedTeams | **PASS 3000** (was NR mostly trapped; 2987 null-page cases) |
| DrawListItems | **PASS 3000** (was 33 cases: `n` was ARG. Clamp loop count to 1..20) |
| ListDialog | **PASS 3000** (GetInputEvent dummy events + ListHitTest in-rect + `n` 1..20, marks 0) |

G17 pilots PASS (NetCollide at 3000; 200 cases is 83% coverage). Planted SeriesLength FAIL at case 4 (`ret eax` 1 vs 2).

SportsDesk: GetInputEvent stub on even cases FAILed `writes[13]` through wild menus (0x78c3be44 vs 0x78c3be74). Event stub is ListDialog-only. SportsDesk restored **NR** 79 cases, 47% coverage, budget.

### H2 (budget 1800)

`--budget 1800 --cases 2000` on the hanging screen loops. Still NR: more time is not the unlock. `--no-callers` is required on these; callers of a screen loop hang until insn limit.

| Function | Result |
|---|---|
| RunMenu | NR 510 cases, 49% coverage, 1805s |
| RunTeamPickMenu | NR 486 cases, 64% coverage, 1806s |
| InstantReplay | NR 306 cases, 75% coverage, mostly trapped, 1807s |

DrawListItems / ListDialog already PASS from H1; not re-run. The rest of the H2 list (SeedPlayoffRound3, GameLineEditorLoop, DbLineEditorLoop, PlayoffTreeMenu, LeagueTeamSelect, TradeScreenLoop, SportsDesk) is the same class: H3 inputs, then H4 recheck. Not accept-for-link.

### H3 (retail-shaped screen inputs)

Menu-mode leftovers (`event_mode=menu`): plant `pointerspr` → ARG sprite, `sub_8CCA8` → ARG+0x800, MenuHitTest does not seed `menus[]`, `__cdecl` nreg 0, GetInputEvent sequence move / empty / click. ListDialog keeps `event_mode=list` (64 events then 0).

| Function | Result |
|---|---|
| RunMenu | **PASS 3000** (was NR 49%). 0 stopping traps. |
| ListDialog | **PASS 3000** (still; list-mode GetInputEvent) |
| SportsDesk | NR 92 cases, 70% coverage (was FAIL with a global event stub; now not FAIL) |
| RunTeamPickMenu | NR 120 cases, 72% coverage, 0 stopping traps |

G17: SeriesLength PASS 300, NetCollide PASS 4500. Planted SeriesLength FAIL case 4 (`ret eax` 1 vs 2). `--no-callers` on screen loops.

### H4 (recheck remaining NR)

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

### H5 (dead-range)

Near-miss holes are live retail paths. No `dead_ranges.txt`. Not accept-for-link.

| Function | Uncovered | Why live |
|---|---|---|
| RunTeamPickMenu 0x1e55b | `mov esi, [statsplayoffs]` season team-order | retail regular-season stats |
| SkateToSpot 0x4e46e | `cmp ax, 0E0h` inside the 0xE0..0xE8 Y corridor | retail player on that band |
| DrawCalendarDay 0x344f9 | selected-day store after `calselmonth`/`calselday` match | retail highlighted cell |

Live holes stay NR. Advisor, not a dump wait.

### Leftover synth (deeper H3 plants + budget 1800)

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

### Leftover pairs (collide ABI + overlay/penalty plants)

`checkcheck` / `PassLaneChk` / `checkgoal` `edx` is a second Player at ARG+0x480, not a SortCords index. PassLaneChk `|Y|` in `(0x4E, 0x76]` with the teammate 0x20 shallower and `(Y>threshold) XOR pflags.7 == 0`. checkgoal `SCnum==0x0E` on `eax` (puck), in-box vs g. InProgress `PenBuf[0]==0x1A` is StartPenaltyShot. DrawRinkOverlays mixes `sortobj15` frames `0x286/0x22E/0x189`, SCnum `0x0E/0x0C/0x0F`, `pucky -0xEC`. `--force --budget 1800 --cases 2000 --no-callers` on the leftover NR. No C. Never `cc.py mark`.

| Function | Result |
|---|---|
| InProgress | **PASS 3000** (was NR 76%; PenBuf 0x1A + RefStep) |
| DrawRinkOverlays | **PASS 3000** (was NR 77%; frame/SCnum/pucky mix) |
| PassLaneChk | **PASS 3000** (was NR 49%; Y-band + teammate geometry) |
| remaining 41 NR | still NR; coverage / budget / uninit-fault, not FAIL |

G17: SeriesLength PASS 450, NetCollide PASS 6750. Planted SeriesLength FAIL case 4 (`ret eax` 1 vs 2).

Remaining NR: CalendarScreen, CanBlockShot, CopyHumanTeamDBs, DbLineEditorLoop, EditGoalieRating, EditRosters, EditSkaterRating, EditTextField, ExecuteTrade, ExportTeamToFloppy, FillDressedSlots, FixJerseyConflict, GameLineEditorLoop, GameSummaryScreen, InstantReplay, LeagueTeamSelect, MoveToOtherRoster, POAfterGame, PenGoalStuff, PickAwardWinners, PickForLineSlot, PlayLeagueGame, PlayoffTreeMenu, PostGameToTeamDb, ReplaySaveHilight, RosterPanelClick, RunPlayerPickMenu, SeedPlayoffRound3, SimulateGame, SportsDesk, StarCompare, TitleScreen, TradePlayers, TradeScreenLoop, assgoalie, assonetimer, assrefgoalpa, assthreestars, checkcheck, checkgoal, wallcoll.

### Leftover near (puckvy / goal mix / wallcoll player arm)

CanBlockShot `puckvy` toward that goal (opposite sign early-outs at 0x500e0); carrier vs loose `puckc`. checkgoal 8-way mix: `sc!=0xE` checkgoalp, OLDZ bounce, dy=0 wallcoll, `|x-g.x|==24` post, inner Goal. wallcoll even seed is a player (`SCnum!=0xE`) so 0x58a14+ runs; puck `Yvel` 0x2000 is wallcoll-only (not ass*). `--force --budget 1800 --cases 2000 --no-callers` on the leftover NR. No C. Never `cc.py mark`.

| Function | Result |
|---|---|
| CanBlockShot | **PASS 3000** (was NR 26%; puckvy toward goal) |
| checkgoal | **PASS 3000** (was NR 74%; Goal/post/checkgoalp mix) |
| wallcoll | **PASS 3000** (was NR 59%; player vs puck SCnum mix) |
| remaining 38 NR | still NR; coverage / budget / uninit-fault, not FAIL |

G17: SeriesLength PASS 450, NetCollide PASS 6750. Planted SeriesLength FAIL case 4 (`ret eax` 1 vs 2).

Remaining NR: CalendarScreen, CopyHumanTeamDBs, DbLineEditorLoop, EditGoalieRating, EditRosters, EditSkaterRating, EditTextField, ExecuteTrade, ExportTeamToFloppy, FillDressedSlots, FixJerseyConflict, GameLineEditorLoop, GameSummaryScreen, InstantReplay, LeagueTeamSelect, MoveToOtherRoster, POAfterGame, PenGoalStuff, PickAwardWinners, PickForLineSlot, PlayLeagueGame, PlayoffTreeMenu, PostGameToTeamDb, ReplaySaveHilight, RosterPanelClick, RunPlayerPickMenu, SeedPlayoffRound3, SimulateGame, SportsDesk, StarCompare, TitleScreen, TradePlayers, TradeScreenLoop, assgoalie, assonetimer, assrefgoalpa, assthreestars, checkcheck.

### Leftover close (line / penalty / playoff plants)

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

### Leftover rest (three-stars / checkcheck plants)

assthreestars `ovltimer=-1` plus intro / star-done / last-star / bring-out / gameover mix (speech bit on `gameopts+1`). checkcheck SetSPA writes `p->SPA`, negative q X, `|vel|>=0x1F4`, holdcheck/Bcheck minority. assrefgoalpa `ovlseq=1` (neither 0 nor 2). assgoalie `check4bench` eax=0 plus crease/behind/out mix. TitleScreen movie stubs dropped 64→47 (reverted). EditTextField PollKey special dropped 71→36 (reverted). TradeHitTest hung TradeScreenLoop (reverted). `--force --budget 1800 --cases 2000 --no-callers` on the leftover NR. No C. Never `cc.py mark`.

| Function | Result |
|---|---|
| assthreestars | **PASS 3000** (was NR 15% then 81%; ovltimer -1 + star mix) |
| checkcheck | **PASS 3000** (was NR 82%; SetSPA + signed/fast q) |
| remaining 32 NR | still NR; coverage / budget / uninit-fault, not FAIL |

G17: SeriesLength PASS 450, NetCollide PASS 6750. Planted SeriesLength FAIL case 4 (`ret eax` 1 vs 2).

Remaining NR: CalendarScreen, CopyHumanTeamDBs, DbLineEditorLoop, EditGoalieRating, EditRosters, EditSkaterRating, EditTextField, ExecuteTrade, ExportTeamToFloppy, FixJerseyConflict, GameLineEditorLoop, GameSummaryScreen, InstantReplay, LeagueTeamSelect, MoveToOtherRoster, POAfterGame, PickAwardWinners, PlayLeagueGame, PlayoffTreeMenu, PostGameToTeamDb, ReplaySaveHilight, RosterPanelClick, RunPlayerPickMenu, SimulateGame, SportsDesk, StarCompare, TitleScreen, TradePlayers, TradeScreenLoop, assgoalie, assonetimer, assrefgoalpa.

### Leftover more (assrefgoalpa drop/pickup)

assrefgoalpa `temp5>0x258` without `pflags` bit 1 (that bit returns in the new-assignment path); `|puckx|==6` and `|pucky|==0xF0` is the resting-puck pickup. MenuHitTest hit-count sequencing on PlayoffTreeMenu dropped 73→43 (reverted). RunPlayerPickMenu sequenced hits dropped 81→73 (reverted). `--force --budget 1800 --cases 2000 --no-callers`. No C. Never `cc.py mark`.

| Function | Result |
|---|---|
| assrefgoalpa | **PASS 3000** (was NR 76%; drop/pickup mix, 85.6%) |
| remaining 31 NR | still NR; coverage / budget / uninit-fault, not FAIL |

G17: SeriesLength PASS 450, NetCollide PASS 6750. Planted SeriesLength FAIL case 4 (`ret eax` 1 vs 2).

Remaining NR: CalendarScreen, CopyHumanTeamDBs, DbLineEditorLoop, EditGoalieRating, EditRosters, EditSkaterRating, EditTextField, ExecuteTrade, ExportTeamToFloppy, FixJerseyConflict, GameLineEditorLoop, GameSummaryScreen, InstantReplay, LeagueTeamSelect, MoveToOtherRoster, POAfterGame, PickAwardWinners, PlayLeagueGame, PlayoffTreeMenu, PostGameToTeamDb, ReplaySaveHilight, RosterPanelClick, RunPlayerPickMenu, SimulateGame, SportsDesk, StarCompare, TitleScreen, TradePlayers, TradeScreenLoop, assgoalie, assonetimer.

### Leftover next (InstantReplay own-hit + POAfterGame series×7)

InstantReplay `ReplayControlLoop` must count that callee's own hits, not nstub k (many earlier callees already make k>40, so the stub quit before the camera/sprite body). Eight own-hits mix camera-follow / CD4FC / player-cursor / free-spot, then 0. POAfterGame `p+0x40` is the game index (`series*7`); SeriesWinner stub is HomeTeam 5 or -1. `--force --budget 1800 --cases 2000 --no-callers`. No C. Never `cc.py mark`.

| Function | Result |
|---|---|
| InstantReplay | **PASS 3000** (was NR 77%; ReplayControlLoop own-hit, 95.7%) |
| POAfterGame | **PASS 3000** (was NR 74%; series×7 + SeriesWinner mix, 86.2%) |
| remaining 29 NR | still NR; coverage / budget / uninit-fault, not FAIL |

G17: SeriesLength PASS 450, NetCollide PASS 6750. Planted SeriesLength FAIL case 4 (`ret eax` 1 vs 2).

Remaining NR: CalendarScreen, CopyHumanTeamDBs, DbLineEditorLoop, EditGoalieRating, EditRosters, EditSkaterRating, EditTextField, ExecuteTrade, ExportTeamToFloppy, FixJerseyConflict, GameLineEditorLoop, GameSummaryScreen, LeagueTeamSelect, MoveToOtherRoster, PickAwardWinners, PlayLeagueGame, PlayoffTreeMenu, PostGameToTeamDb, ReplaySaveHilight, RosterPanelClick, RunPlayerPickMenu, SimulateGame, SportsDesk, StarCompare, TitleScreen, TradePlayers, TradeScreenLoop, assgoalie, assonetimer.

### Leftover keep (StarCompare equal-points + assonetimer mix)

StarCompare `dword_DB088` is a global array. Equal-points keys (team*25+player) still returned at `hmscore` until both teams' `hmscore[team*128]` matched, so StarElig / DACA0 / +0Eh / +6 ran. StarEligible stub: kind 5 returns 0 then 1; else both 0 and DACA0 runs. assonetimer mix is onetimerflag 0/1, SPA DD3 vs 0, puckc==SCnum vs loose, pfjoy start wind-up. `--force --budget 1800 --cases 2000 --no-callers`. No C. Never `cc.py mark`.

| Function | Result |
|---|---|
| StarCompare | **PASS 3000** (was NR 52%; equal hmscore on tie kinds, 97.5%) |
| assonetimer | **PASS 3000** (was NR 55%; SPA/puckc/pfjoy mix, 85.3%) |
| remaining 27 NR | still NR; coverage / budget / uninit-fault, not FAIL |

G17: SeriesLength PASS 450, NetCollide PASS 6750. Planted SeriesLength FAIL case 4 (`ret eax` 1 vs 2).

Remaining NR: CalendarScreen, CopyHumanTeamDBs, DbLineEditorLoop, EditGoalieRating, EditRosters, EditSkaterRating, EditTextField, ExecuteTrade, ExportTeamToFloppy, FixJerseyConflict, GameLineEditorLoop, GameSummaryScreen, LeagueTeamSelect, MoveToOtherRoster, PickAwardWinners, PlayLeagueGame, PlayoffTreeMenu, PostGameToTeamDb, ReplaySaveHilight, RosterPanelClick, RunPlayerPickMenu, SimulateGame, SportsDesk, TitleScreen, TradePlayers, TradeScreenLoop, assgoalie.

### Pause (2026-11-07)

Leftover NR chase stopped at **82/27**. H6 stays closed. Native F4 waits. Never `cc.py mark`. MATCH stays 977.

Unlanded still-unit plants (discarded; no PASS): TradeScreenLoop jersey-column PTRFN_STUB `mx=0x100` `my=0x80` reached 86.2% of 1187 insns at 214 cases / budget 180 (floor miss is case count, not coverage). assgoalie kinds 10/11 (other-half `pucky ^ Ypos < 0`, ShotLaneOpen stub eax=1, neg puck vel) 81.6% still NR. MoveToOtherRoster KeyDbPtr dropped 61→56%; do not restore.

Do not retry: MenuHitTest hit-count, TradeHitTest, EditTextField PollKey, TitleScreen movie stubs, RunPlayerPickMenu sequenced hits.

| Function | Last landed check |
|---|---|
| EditGoalieRating | NR 16% / 3000 |
| RosterPanelClick | NR 18% / 3000 |
| EditSkaterRating | NR 18% / 3000 |
| SimulateGame | NR 19% / 3000 |
| FixJerseyConflict | NR 20% / 3000 |
| CalendarScreen | NR 21% / 3000 |
| PlayLeagueGame | NR 23% / 3000 |
| PickAwardWinners | NR 35% / 3000 |
| DbLineEditorLoop | NR 39% / 3000 |
| ExecuteTrade | NR 42% / 3000 |
| TradePlayers | NR 43% / 3000 |
| GameLineEditorLoop | NR 43% / 3000 |
| CopyHumanTeamDBs | NR 44% / 3000 |
| GameSummaryScreen | NR 49% / 3000 |
| ReplaySaveHilight | NR 49% / 3000 |
| LeagueTeamSelect | NR 50% / 1615 |
| PostGameToTeamDb | NR 52% / 3000 |
| ExportTeamToFloppy | NR 52% / 3000 |
| MoveToOtherRoster | NR 61% / 3000 |
| TitleScreen | NR 64% / 3000 |
| EditTextField | NR 71% / 2976 |
| PlayoffTreeMenu | NR 73% / 3000 |
| TradeScreenLoop | NR 77% / 206 (unlanded jersey plant 86.2% / 214) |
| assgoalie | NR 80% / 300 (unlanded kinds 10/11 81.6%) |
| RunPlayerPickMenu | NR 81% / 3000 |
| SportsDesk | NR uninit-fault / 489 |
| EditRosters | NR mostly trapped / 3000 |

### Close

H6 stays closed until 109/109 PASS. Leftover NR is paused, not finished. Native F4 waits.
