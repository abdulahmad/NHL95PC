# Function matching (functional track): handoff

Read with [FUNCTIONAL_PLAN.md](FUNCTIONAL_PLAN.md), [RULES.md](RULES.md) and the "Functional track" section of
[AGENTS.md](../AGENTS.md). Works the same from Claude Code or Cursor.

## Two tracks, two handoffs

| Track | Goal | Handoff |
|---|---|---|
| **Decompilation** (byte-exact) | C that compiles to the original bytes; `cc.py mark` puts it in the build | [HANDOFF.md](../HANDOFF.md), [C_MATCHING.md](C_MATCHING.md) |
| **Function matching** (functional) | a draft proven to behave like the original asm (`tools/equiv/check.py` PASS); the asm stays in the build | this file |

* A function-matched draft stays open for decompilation: its asm, draft, `DRAFT:` notes, UNSURE entry and history
  rows are all kept, so byte-matching can resume at any time.
* Decompiling a function takes it out of the function-matched pool by itself: `tools/match/c_progress.py` counts a
  function as function-matched only while its status is `nonmatching`, so once it is marked (matched) it counts
  only as decompiled. A PASS also stops counting when the draft's source changes (the check is tied to its hash).

## Where it stands

* Harness `tools/equiv/` is merged (PR #274) plus **round 7** (per-case stack fill; `--callers` / `--no-callers` /
  `--force`). Self-tests: `python3 tools/equiv/image.py --selftest`, `run.py --selftest`, `cside.py --selftest`.
* Needs: `pip install unicorn capstone`, `apt install dosbox nasm` (drafts compile through `tools/match/cc.py`).
* **25 of 109 drafts proven functionally equivalent (PASS).** `python3 tools/match/c_progress.py` reports the count
  separately from matched.
* **75 NEEDS-REVIEW**: no difference found, but random inputs reach too little of the code (coverage under 85%),
  most cases trap, or (before round 7) uninitialised stack reads. Round 7 turns equal-output uninit reads into info
  and auto-runs callers when coverage is under 85%. **Those 75 have not been re-run yet.**
* **8 FAIL**, all triaged, none a confirmed draft bug:
  * input artefacts (wild index or out-param): SimPlayoffRound1, GameLineEditorLoop;
  * pointer-to-local bytes differ by frame layout (likely harness): DbLineEditorLoop, TradeScreenLoop,
    OpenSpeechBank, SportsDesk;
  * wild pointer fault address: PlayoffTreeMenu;
  * CanFillLineSlot: original returns junk in the upper 16 bits that callers ignore; matching needs a `short`
    return, an ESCALATE shape: **Abdul's call**.
* Real fixes found so far: CalendarScreen and ReplayStep (store order). Every harness lesson is a line in
  `docs/RULES.md`.

## Round 7 (done)

Applied the unfinished `tools/equiv/wip/round7.patch` onto the recut tree (paths are `src/{engine,front,pc}` and
`tools/match/c_functions.csv`). Verified:

* Self-tests ALL PASS (`image.py`, `run.py`, `cside.py`).
* Pilots PASS (`--force --no-callers --cases 200`): DrawRinkEndArt, GetMemListHead, ResetInputSampling, SeriesLength,
  FadePalette, shotdiradj, puckfaceoff2, NetCollide.
* Planted SeriesLength bug (best-of-1 constant 1→2) **FAIL** at case 6 (`ret eax: orig 0x1 vs C 0x2`).
* `--callers` smoke on SeriesLength: 50 snapshots, coverage 100%.

`tools/equiv/wip/round7.patch` is removed; the code is in `check.py` / `run.py`.

## Next steps, in order (one per session, stop for approval)

| # | Step | Model (Claude / Cursor) |
|---|---|---|
| 2 | Rerun every NEEDS-REVIEW draft: 3 parallel, `--cases 2000 --budget 600 --quiet` (plain script, no model) | none, then Haiku / Composer 2.5 to log |
| 3 | Triage any new FAIL: fixer, max 3 tries each, no tie-breaker copies (AGENTS.md) | Sonnet / Grok 4.7 medium |
| 4 | Advisor pass on what is still NEEDS-REVIEW: accept, or plan step 9 (DOSBox-X snapshots, needs Abdul) | Opus / Grok 4.7 high, once |
| 5 | Steps 10-11 of the plan (FUNCTIONAL=1 build, nightly check) | see FUNCTIONAL_PLAN.md |

Pilots that must stay PASS after any harness change: DrawRinkEndArt, GetMemListHead, ResetInputSampling (matched),
SeriesLength, FadePalette, shotdiradj, puckfaceoff2, NetCollide. Planted bug: copy SeriesLength.c to
`build/equiv/planted/`, change one constant, run with `--seg front/season`: must FAIL within 50 cases.

Batch loop used so far (no model tokens): a shell loop over `tools/match/c_functions.csv` nonmatching rows calling
`check.py <c_file> --func F --seg SEG --quiet --budget 600`, three in parallel with a per-function lock directory.
