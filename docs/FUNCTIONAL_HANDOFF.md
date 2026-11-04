# Function matching (functional track): handoff (paused 2026-11-02)

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

* Harness `tools/equiv/` is merged (PR #274): `image.py`, `run.py`, `cside.py`, `check.py`, `results.csv`.
  Self-tests: `python3 tools/equiv/run.py --selftest`, `python3 tools/equiv/cside.py --selftest`.
* Needs: `pip install unicorn capstone`, `apt install dosbox nasm` (drafts compile through `tools/match/cc.py`).
* **25 of 109 drafts proven functionally equivalent (PASS).** `python3 tools/match/c_progress.py` reports the count
  separately from matched.
* **75 NEEDS-REVIEW**: no difference found, but random inputs reach too little of the code (coverage under 85%),
  most cases trap, or uninitialised stack reads.
* **8 FAIL**, all triaged, none a confirmed draft bug:
  * input artefacts (wild index or out-param): SimPlayoffRound1, GameLineEditorLoop;
  * pointer-to-local bytes differ by frame layout (likely harness): DbLineEditorLoop, TradeScreenLoop,
    OpenSpeechBank, SportsDesk;
  * wild pointer fault address: PlayoffTreeMenu;
  * CanFillLineSlot: original returns junk in the upper 16 bits that callers ignore; matching needs a `short`
    return, an ESCALATE shape: **Abdul's call**.
* Real fixes found so far: CalendarScreen and ReplayStep (store order). Every harness lesson is a line in
  `docs/RULES.md`.

## In progress when paused: harness round 7 (not merged)

`tools/equiv/wip/round7.patch` (apply with `git apply`, then run the self-tests and the pilots). Unfinished, untested:

1. Per-case random stack fill, so an uninitialised read whose outputs still compare equal is info, not review.
2. Caller-driven entry states (`check.py --callers`): run the function's real callers from the EXE in the
   emulator and snapshot the state when they reach the function. An automated stand-in for DOSBox-X snapshots,
   aimed at the 75 low-coverage drafts.

## Next steps, in order (one per session, stop for approval)

| # | Step | Model (Claude / Cursor) |
|---|---|---|
| 1 | Finish round 7 from the patch; verify pilots PASS and the planted bug FAILs (see RULES.md) | Sonnet / Grok 4.7 medium |
| 2 | Rerun every NEEDS-REVIEW draft: 3 parallel, `--cases 2000 --budget 600 --quiet` (plain script, no model) | none, then Haiku / Composer 2.5 to log |
| 3 | Triage any new FAIL: fixer, max 3 tries each, no tie-breaker copies (AGENTS.md) | Sonnet / Grok 4.7 medium |
| 4 | Advisor pass on what is still NEEDS-REVIEW: accept, or plan step 9 (DOSBox-X snapshots, needs Abdul) | Opus / Grok 4.7 high, once |
| 5 | Steps 10-11 of the plan (FUNCTIONAL=1 build, nightly check) | see FUNCTIONAL_PLAN.md |

Pilots that must stay PASS after any harness change: DrawRinkEndArt, GetMemListHead, ResetInputSampling (matched),
SeriesLength, FadePalette, shotdiradj, puckfaceoff2, NetCollide. Planted bug: copy SeriesLength.c to
`build/equiv/planted/`, change one constant, run with `--seg front/schedule`: must FAIL within 50 cases.

Batch loop used so far (no model tokens): a shell loop over `tools/match/c_functions.csv` nonmatching rows calling
`check.py <c_file> --func F --seg SEG --quiet --budget 600`, three in parallel with a per-function lock directory.
