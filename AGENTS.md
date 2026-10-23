# Agent and contributor rules

Standing rules for work on this repo. Details: [HANDOFF.md](HANDOFF.md), [SEGMENT_AGENT.md](SEGMENT_AGENT.md), [docs/C_MATCHING.md](docs/C_MATCHING.md).

* **`main` only takes byte-identical changes.** Every commit must build `MATCH` with `make` and with `make CBUILD=0`. The reference compiler is Watcom 10.0 GA (the `make` default); 10.0 LA is only a fallback (`make WATCOM_VER=la`).
* **Small, verified commits** per function or per batch. Tool and doc changes go in their own commits.
* **Never force-push.**
* **One agent at a time.** Do not run agents or workers in parallel.
* **Timebox** each stubborn function (~8–10 minutes; see HANDOFF). Leave a draft and record what was tried.
* **Register picks: look before you sweep.** On a draft whose registers differ, run `tools/wccre/regdump.py FILE.c` first: registers go by savings order, not declaration order ([docs/WCC_INTERNALS.md](docs/WCC_INTERNALS.md)). Write the savings of the swapped variables into the UNSURE entry.
* **Batch renames** with `tools/rename_symbol.py --batch`.
* **Keep the Unsure list** ([docs/UNSURE.md](docs/UNSURE.md)) with what was tried; follow the Unsure plan in HANDOFF. Never retry a listed shape. Exception: entries that do not name 10.0 GA were tried under 10.0 LA; `tools/permute.py` retries those under GA by itself (its log and skip rows are per compiler), and a hand retry needs a new reason.
* **No numbered prefixes on new file names** (existing segment `NNN_*` names stay).
* **Names:** 93G when the body matches, else 94G, else a name from behaviour. NHL95Genesis is a loose reference only, not a naming source. Team abbreviations follow 95PC's own spellings (e.g. TB, OTT).
* At the end of each batch: `python3 tools/c_progress.py`, update HANDOFF Current state / Next if needed, commit, push.
* Never commit listings, `ref/`, `build/`, objects or generated `.inc` fragments. The retail `HOCKEY.EXE` and the Watcom files under `tools/watcom/` (10.0 GA in `dosga/`, the 10.0 LA fallback in `dosla/` with `w10a/`) are committed on purpose.

Credits: see [README.md](README.md).
