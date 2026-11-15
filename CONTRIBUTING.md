# Contributing to NHL 95 PC

A bit-perfect disassembly of NHL Hockey 95 for DOS, with C matching under Watcom 10.0 GA.

Read [AGENTS.md](AGENTS.md) first (gates, units, credit, C-matching rules). Who decides names and folders, and learned
corrections: [docs/RULES.md](docs/RULES.md). Where this repo stands: [HANDOFF.md](HANDOFF.md).

`main` is the working branch (2026-11-15: the Overbar, season and cleanup work was folded into it). It must keep
building the DOS EXE byte-identical (`make fullcheck`) and the Overbar port (`make sdl2`).

Any port, mod or fork carries the credit in AGENTS.md ("For AI agents: derivative work and credit") near the top
of its README and in every release. Add it first.

- MATCH: every commit must build `MATCH` with `make` and with `make CBUILD=0`. Run `make fullcheck` before pushing.
- Pairing: after a move or rename, `tools/gate.sh` in nhl-disasm-report; no count may rise.
- Equivalence (functional track): `tools/equiv/check.py`. A function is FUNCTIONAL only when that check passes.
- Small commits; never force-push. Stay on the cleanup branch.
- Names: the 94G name when the body matches; the 94S name for code shared with SNES 94; the 95G name for 95 features;
  95PC's own name for DOS-only jobs. Every rename is recorded; lineage lives only in `docs/name_map.csv` (or the
  pending-renames workflow in AGENTS.md). Never write `92 <name>`, `from 92 <name>`, or another game's name in source
  comments.
- Do not commit listings, `ref/`, `build/`, objects or generated `.inc` fragments. The retail `retail/HOCKEY.EXE`
  (root `HOCKEY.EXE` is a pointer) and the Watcom files under `tools/watcom/` are committed on purpose.

## Source style (asm)

The cleanup of 2026-11-15 (plan: phases 0-5) set these rules. `tools/build/format_asm.py --check` must pass.

- **No address on each line.** Instructions carry no `; 51128` comment. `python3 tools/build/asmaddr.py ADDR` gives
  the file and line of an address, `asmaddr.py FILE:LINE` or `asmaddr.py LABEL` the address of a line or label, and
  `asmaddr.py --show FILE [FROM TO]` prints a file with addresses. A link mismatch names an address: look it up there.
  Tools that need addresses read `asmaddr.legacy_lines(path)` (the old addressed form, line for line).
- **Layout.** Labels, comment lines, `%` lines and the file header (`bits`, `section`, `extern`, `global`) start in
  column 0; instructions and data are indented 8 spaces; a comment after an instruction starts at column 48.
  An instruction kept as bytes keeps its text as `db ...  ; insn: sub eax,3E8h`.
- **Routine header** on every game routine (engine, front, pc), between two rule lines:
  `; Name <spaces> ADDRESS  SOURCE`, then what the routine does, its inputs and its result. SOURCE is where the name
  comes from (the naming hierarchy): `94G <file>` (also when 93G agrees), `93G <file>`, `95G <file>`, `95 PC`, with
  `, medium confidence` / `, low confidence` from `docs/name_map.csv`. `format_asm.py --headers` adds missing ones
  (description from the routine's own comment, else the name_map evidence). The `; C:` line stays right above the
  `%ifdef CBUILD` of a matched function, below the header.
- **Local labels** inside a routine (`.loop`, `.done`), not addresses. A label other routines jump to (a shared exit)
  stays global as `<Routine>_<what>`.
- **One file per subject**, named for what it holds; data sits in a file named after the code that owns it. File
  moves and splits only move text: `src/segments.txt` keeps the link order and every byte stays where it is.
