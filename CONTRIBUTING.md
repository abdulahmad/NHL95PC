# Contributing to NHL 95 PC

A bit-perfect disassembly of NHL Hockey 95 for DOS, with C matching under Watcom 10.0 GA.

Read [AGENTS.md](AGENTS.md) first (gates, units, credit, C-matching rules). Who decides names and folders, and learned
corrections: [docs/RULES.md](docs/RULES.md). Where this repo stands: [HANDOFF.md](HANDOFF.md).

Work stays on `claude/project-thread-ggw7zu`. Do not branch from `main` and do not merge to `main`. PRs from that
branch are for review only.

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
- Do not commit listings, `ref/`, `build/`, objects or generated `.inc` fragments. The retail `HOCKEY.EXE` and the
  Watcom files under `tools/watcom/` are committed on purpose.
