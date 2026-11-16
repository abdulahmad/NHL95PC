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

## Comments

Adapted from NHL94SNES CONTRIBUTING.md (sections 4 and 5) for the PC sources. `python3 tools/build/check_comments.py`
checks these rules (`--summary` gives a count per rule); it must not report more problems after your change than
before it, and a file you finish must come out clean. A comment-only change must not change a byte (MATCH).

What to write:

- **Every routine** has a header between two rule lines: `; Name <spaces> ADDRESS  SOURCE`, then what it does,
  what it takes (registers, stack arguments, globals it reads) and what it returns or changes. Say where it is called
  from when that explains it. Library routines too: a Watcom or EA library routine says what the library call does.
- **Every variable declaration** has a comment on its label line: data and BSS labels, tables, strings, equates and
  structure fields. Say what it holds: units, range, flag bits, what one table entry is and how many there are, and
  which routines own it. A string says where it is shown or used.
- **Every file** starts with a header that says what the file holds and how it relates to its neighbours. It does not
  list the routines in order.
- Routines read as a story when you work on them: a short comment for each step (3 to 8 instructions), what the
  registers hold, why a branch is taken, where the flow falls through.
- Anything not obvious gets a comment: magic numbers, bit tests (name the flag), x87 stack use, shared tails, code
  kept as bytes, self-modifying code.
- Only write what you checked in the code. If you cannot tell why something is done, describe what the instructions
  do or write "probably". Never invent names.

What not to write:

- No IDA names (`sub_`, `loc_`, `unk_`, `dword_`, `byte_`, `off_`, `asc_`, `jpt_` ...). Write the real name.
- No raw addresses or structure offsets in comments: write the name (`PUCKX`, not `168CD8h`) or say what the value
  means. The only addresses allowed are the ADDRESS field of a routine header and the address range of a file header.
- No other game's names (`94G`, `NHL 95`, `96 PC`, `Genesis` ...). Lineage lives only in `docs/name_map.csv`; the
  SOURCE field of a routine header is the one place it shows.
- No source-file or segment names, no history (`was X`, `renamed from`): that is in git and `docs/name_map.csv`.

Layout (the 2026-11-15 cleanup layout, not the SNES tabs):

- Labels, comment lines and `%` lines start in column 0; instructions and data are indented 8 spaces.
- A comment after an instruction or on a label line starts at column 48, or one space after code that reaches past it.
  Its continuation lines start at column 48 too.
- No comment line is wider than 110 columns (data lines aside).
- A comment that explains one instruction goes to its right, not on its own line above it. A comment on its own line
  is a block header for the steps below it.
- A header or block comment has paragraphs of at most 3 lines, separated by a `;` line. Keep headers short: what
  the routine is for, its inputs and result, and the few notes nobody could guess.
