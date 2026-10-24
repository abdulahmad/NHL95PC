# Prompt

Paste this into a new session for the C phase. One agent per lane worktree (docs/LANES.md).

```text
You're working on the NHL 95 PC (DOS) decompilation in this repo: matching C compiled with Watcom 10.0 wcc386. Work as one agent in your own lane worktree, one task at a time, and stay in your lane's segments (docs/LANES.md). Do not start extra agents or workers in this worktree.

Setup: install nasm, make, capstone and DOSBox if they're missing, then confirm `python3 tools/rebuild_exe.py verify` prints MATCH and `python3 tools/cc.py check` passes. Read AGENTS.md, HANDOFF.md (the speed-up plan is at the top of section 4), docs/C_MATCHING.md and docs/UNSURE.md before doing anything else.

Where things stand: 709 / 1084 functions matched. The 305 non-matching drafts (171 KB) are bigger than the matched code (156 KB), and most are register-pick near-misses, so hand iteration is the bottleneck.

Order of work. Do not start a step until the one before it is finished or its limit has been hit.
1. Untouched functions (~80). Most end in another function's shared tail: find the tail's owner and add the function to the owner's C file, marked with `cc.py mark FILE.c --func F --seg STEM`. HANDOFF section 4 lists the known owners. Limit: 10 minutes per function, at most 2 attempts. If it doesn't match, keep the draft, record exactly what you tried in docs/UNSURE.md and move on.
2. Faster compiles. Each check boots DOSBox once per file. Batch several functions into one DOSBox run and cache results by a hash of the source text. Measure seconds per candidate before and after. Limit: 2 hours. If there is no 2x speedup by then, keep what works and move on.
3. Build tools/permute.py (tools/permute_decls.py only tries declaration order and has found nothing). It takes one function's C file and applies small transforms: statement reordering, int vs short vs unsigned locals, locals declared in inner blocks (tools/scope_decls.py), splitting or merging expressions, adding or removing temporaries. It compiles each candidate through the existing cc.py / cdiff.py path, scores it by byte differences and keeps the best. Log every attempt (function, transform, diff count) to a CSV and never repeat a logged attempt. Per function it stops at a match, or after 2000 candidates, 30 minutes, or 300 candidates in a row with no improvement, whichever comes first. One search at a time. Run it first on the parked Group 1 register near-misses in HANDOFF, then on the other drafts, smallest diff first. Limit for building the tool: one day. If it has matched nothing by then, report back before continuing.
4. Turn the "do not retry" shapes in docs/UNSURE.md into structured rows (function, transform tried, result) that the permuter reads and skips.
5. Leftovers: at most 2 permuter runs per unmatched function, ever, then record it in UNSURE. Functions that cannot be matched (split or overlapping ones) become hand-asm like the existing 13, so the build stays byte-exact.

Rules:
- Every commit must build MATCH with `make` and `make CBUILD=0`; run `make fullcheck` before every push. Main only takes byte-identical changes.
- Make small commits, one per function or batch. Never force-push.
- Never retry a shape already listed in docs/UNSURE.md.
- Names: 93G first, then 94G, else a name from behaviour, with the evidence in the comment. Batch renames with tools/rename_symbol.py --batch.
- Every C function gets a comment: address, Genesis routine (or PC only), what it does, its arguments and its result.
- At the end of each batch, run `python3 tools/c_progress.py`, update HANDOFF.md's current state, next steps and Unsure sections, commit and push.
```
