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
* Verdict source is the **latest `tools/equiv/results.csv` row per function**, not a batch runner's last stderr
  line (a Watcom warning can hide a real verdict; RULES 2026-11-06).
* **77 of 109 drafts proven functionally equivalent (PASS)** by `c_progress.py` (current source hash still
  PASSes). Unit 1 stamped three stale hashes (49→52). Unit 3: CanFillLineSlot and OpenSpeechBank (52→54).
  Unit 5: checkgoalp (54→55). Unit 7: SimPlayoffRound1 (55→56). 109-plan H1: POSeedTeams, DrawListItems, ListDialog (56→59). H3: RunMenu (59→60). H4: RandomizeSchedule (60→61). Leftover synth: DrawCalendarDay, checkpuckcoll_ccx, RunTeamPickMenu, SkateToSpot (61→65). Leftover pairs: InProgress, DrawRinkOverlays, PassLaneChk (65→68). Leftover near: CanBlockShot, checkgoal, wallcoll (68→71). Leftover close: FillDressedSlots, PenGoalStuff, SeedPlayoffRound3, PickForLineSlot (71→75). Leftover rest: assthreestars, checkcheck (75→77). Generated baseline before the round-7 rerun was 23; that rerun added 25, then Gameloop.
* **Step 2 rerun (done, 2026-11-06).** 71 unique functions logged: **25 PASS / 44 NEEDS-REVIEW / 2 FAIL**.
  Latest-row CSV picture after leftover rest: **77 PASS / 32 NEEDS-REVIEW / 0 FAIL** over leftover drafts
  (matched-function pilots still in the CSV). `c_progress.py` is the FUNCTIONAL count in C_PROGRESS / README.
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

## Round 7 (done)

Applied the unfinished `tools/equiv/wip/round7.patch` onto the recut tree (paths are `src/{engine,front,pc}` and
`tools/match/c_functions.csv`). Verified:

* Self-tests ALL PASS (`image.py`, `run.py`, `cside.py`).
* Pilots PASS (`--force --no-callers --cases 200`): DrawRinkEndArt, GetMemListHead, ResetInputSampling, SeriesLength,
  FadePalette, shotdiradj, puckfaceoff2, NetCollide.
* Planted SeriesLength bug (best-of-1 constant 1→2) **FAIL** at case 6 (`ret eax: orig 0x1 vs C 0x2`).
* `--callers` smoke on SeriesLength: 50 snapshots, coverage 100%.

`tools/equiv/wip/round7.patch` is removed; the code is in `check.py` / `run.py`.

## Next steps

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
| 107.7 | Leftover proofs ([FUNCTIONAL_LEFTOVERS.md](FUNCTIONAL_LEFTOVERS.md)): SportsDesk (c) autoret `eax` into `scrolly`/`scrollx` → NR 47%; SimPlayoffRound1 (a) team-byte clamp + SeriesLength stub 1/3/5/7 → PASS 3000. **56 PASS / 0 FAIL / 53 NR**. 53 NR wait on dumps. No dead-range without a dump. | Grok 4.7 high |
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
| 109.H6 | **not done** — close only at 109/109 PASS. Native F4 waits. | see plan |

Pilots that must stay PASS after any harness change: DrawRinkEndArt, GetMemListHead, ResetInputSampling (matched),
SeriesLength, FadePalette, shotdiradj, puckfaceoff2, NetCollide. Planted bug: copy SeriesLength.c to
`build/equiv/planted/`, change one constant, run with `--seg front/season`: must FAIL within 50 cases.

Batch loop used so far (no model tokens): a shell loop over `tools/match/c_functions.csv` nonmatching rows calling
`check.py <c_file> --func F --seg SEG --quiet --budget 600`, three in parallel with a per-function lock directory.
