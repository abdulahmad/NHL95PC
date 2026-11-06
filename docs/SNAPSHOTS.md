# DOSBox-X entry snapshots (functional Unit 6)

Leftover NR drafts need real entry states. Synthetic cases and `--callers` already ran; many added 0 snapshots. This file is the capture recipe. The dumps live **outside git** (they contain RAM from a running retail EXE).

This VM has no play session. Abdul captures on his machine. The agent consumes the JSONL with `check.py --play-snaps`.

## Capture

1. Run retail `HOCKEY.EXE` under DOSBox-X so linear addresses match `tools/equiv/image.py` (DOS/4GW, the committed EXE).
2. Print the queue and a breakpoint script:

```
python3 tools/equiv/snapshot_dosbox.py queue
python3 tools/equiv/snapshot_dosbox.py script SkateToSpot
```

3. In the DOSBox-X debugger: `BPLINEAR` at the printed label. Play until it hits (exhibition for engine names; the matching front screen for menus).
4. On each hit, append one JSONL line (regs, 8 stack dwords above the return address, dirty 4 KB data pages). Continue. A handful of hits per function is enough to start; more is better.
5. Validate, then hand the file to the agent (do not commit it):

```
python3 tools/equiv/snapshot_dosbox.py load dumps.jsonl
```

## JSONL

One object per line:

```json
{"function":"SkateToSpot","eip":"0x4e3c0","regs":{"eax":"0x1","ebx":"0x2","ecx":"0x3","edx":"0x4","esi":"0x5","edi":"0x6","ebp":"0x7"},"args":["0x0","0x0"],"pages":{"0xc0000":"<4096-byte hex or base64>"}}
```

`pages` keys are linear bases. Values are hex (no `0x`) or standard base64. A page may be shorter than 4 KB when it is a small patch.

## Consume

```
python3 tools/equiv/check.py src/engine/logic/SkateToSpot.c --func SkateToSpot --seg engine/logic --play-snaps dumps.jsonl --force --budget 600
```

`--play-snaps` runs after the seeded / mutated / callers cases. Re-check **only still-NR names**. Budget-starved names (`DrawListItems`, `SeedPlayoffRound3`, `ExportTeamToFloppy`, `InstantReplay`, `ListDialog`) keep `--budget 600`.

## Order

Near-miss engine first (`SkateToSpot` 82, `checkpuckcoll_ccx` 84, `DrawRinkOverlays` 79, `InProgress` 76), then the rest of the engine NR, then `TitleScreen`, then front/PC by coverage, then the two FAIL (`SportsDesk`, `SimPlayoffRound1`). Full list: `python3 tools/equiv/snapshot_dosbox.py queue`.

## Dead ranges

If a snapshot set still leaves a range uncovered, disasm it. Only a range unreachable under every retail invariant for that entry goes in `tools/equiv/dead_ranges.txt` with a proof, and `check.py` then treats those insns as covered. Live uncovered ranges go to the advisor, not to accept-for-link.
