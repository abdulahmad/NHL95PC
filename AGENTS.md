# Agent and contributor rules

Standing rules for work on this repo. Details: [HANDOFF.md](HANDOFF.md), [SEGMENT_AGENT.md](SEGMENT_AGENT.md), [docs/C_MATCHING.md](docs/C_MATCHING.md), [docs/LANES.md](docs/LANES.md).

* **`main` only takes byte-identical changes.** Every commit must build `MATCH` with `make` and with `make CBUILD=0`. The reference compiler is Watcom 10.0 GA (the `make` default); 10.0 LA is only a fallback (`make WATCOM_VER=la`). Run `make fullcheck` before pushing.
* **Small, verified commits** per function or per batch. Tool and doc changes go in their own commits.
* **Never force-push.** Do not rebase a pushed branch. Merge `main` in.
* **Lanes.** Read [docs/LANES_CURRENT.md](docs/LANES_CURRENT.md) before each batch and work only the C files it assigns you. Segment ownership stays per lane ([docs/LANES.md](docs/LANES.md)): lane 1 Mhopkinsinc (001-037), lane 2 StaticEck2026 (038-066). Lane T is Abdul: `tools/`, `tools/wccre` and escalation decisions. One agent per worktree. A C file is never split across contributors.
* **Before each draft,** read its section in `docs/LANES_CURRENT.md`, its rows in `docs/draft_history.csv` and its entry in [docs/UNSURE.md](docs/UNSURE.md). Never repeat a shape already tried under 10.0 GA.
* **Timebox** each function to 8-10 minutes. Leave the draft.
* **Register picks: look before you sweep.** On a draft whose registers or stack slots differ, run `tools/wccre/regdump.py FILE.c` and `tools/wccre/declsearch.py FILE.c` before a manual try, and `tools/wccre/tieorder.py FILE.c FUNC` when the registers differ: it says whether a tie order explains the draft, which one, and which declaration moves reach it. Registers go by savings order, not declaration order ([docs/WCC_INTERNALS.md](docs/WCC_INTERNALS.md)).
* **History.** Append one row to `docs/draft_history.csv`: function, contributor, date, compiler (`GA`), score before, score after, shapes tried. A match is score after `0`.
* **Renames** go in `docs/pending_renames.txt` (`tools/rename_symbol.py --batch` format). Do not rename in the tree. The progress workflow applies the file.
* **Generated files.** Do not edit `C_PROGRESS.md`, `tools/c_functions.csv`, `docs/ranked_drafts.txt`, `docs/LANES_CURRENT.md`, or the counts between the `nhl95` marker comments in `README.md` and `HANDOFF.md`. The progress workflow regenerates them after `fullcheck` passes on `main`.
* **PR body.** One machine-readable line per function: `score: Func before->after` (a match is `->0`).
* **ESCALATE** these shapes instead of marking the function: `goto`, a no-op cast, a file-local `volatile`, dead-variable reuse, a wrong return type. Say so in the history row and the PR. Do not silently accept them.
* **Tie-breaker copies are not matches.** A local that only holds a value for one store, or only seeds another variable, changes the register allocator's tie order wherever it sits, so it is not evidence of the original ([docs/ESCALATIONS.md](docs/ESCALATIONS.md)). Do not mark a function with one and do not commit one in a draft: describe it in the draft's comment and the history row, and keep the natural shape. A copy is fine when the variable is used more than once or has a role of its own.
* **Hand-asm** only with Abdul's approval. Do not convert a draft to hand-asm yourself.
* **Keep the Unsure list** ([docs/UNSURE.md](docs/UNSURE.md)) with what was tried; follow the Unsure plan in HANDOFF. Never retry a listed shape. Exception: entries that do not name 10.0 GA were tried under 10.0 LA; `tools/permute.py` retries those under GA by itself (its log and skip rows are per compiler), and a hand retry needs a new reason.
* **No numbered prefixes on new file names** (existing segment `NNN_*` names stay).
* **Names:** 93G when the body matches, else 94G, else a name from behaviour. NHL95Genesis is a loose reference only, not a naming source. Team abbreviations follow 95PC's own spellings (e.g. TB, OTT).
* Never commit listings, `ref/`, `build/`, objects or generated `.inc` fragments. The retail `HOCKEY.EXE` and the Watcom files under `tools/watcom/` (10.0 GA in `dosga/`, the 10.0 LA fallback in `dosla/` with `w10a/`) are committed on purpose.

Credits: see [README.md](README.md).
