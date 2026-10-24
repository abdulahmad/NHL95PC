# Escalations

Structural drafts for Abdul (lane T). Lane agents do not mark these, and they do not turn one into
hand-asm. A recommended ruling is a proposal. The function stays as it is until Abdul decides.

The shapes AGENTS.md calls ESCALATE (a `goto`, a no-op cast, a file-local `volatile`, dead-variable
reuse, a wrong return type) are in this list when a current draft depends on one. An ordinary
register or slot miss is not an escalation: it stays with the owner in
[LANES_CURRENT.md](LANES_CURRENT.md).

## DrawListItems, waiting on DrawListItem

`DrawListItems` in `src/c/023_2FDD1_misc_dialogs/DrawListItem.c` (lane 1, Mhopkinsinc) compiles to the
EXE bytes: ranked score 0. It is unmarked because it branches into `DrawListItem`, which is still a
draft (6 differing). Marking `DrawListItems` alone would point the include at a tail that is not the
matched block.

**Recommended ruling:** leave `DrawListItems` unmarked until `DrawListItem` matches. Mark both in the
same commit. Do not hand-asm either function. This is a dependency, not a bad shape, so lane 1 keeps
`DrawListItem`.

## CreatePlayoffs and POAfterGame, shared exit

Both live in `src/c/064_86696_season_playoffs/POSeedRound2.c` (lane 2, StaticEck2026) and end in
`POSeedRound2_x`, the exit of the matched `POSeedRound2`. Watcom keeps that exit in one function of
the file. Moving either draft to its own file, or marking it while the exit still belongs to
`POSeedRound2`, changes the matched function.

**Recommended ruling:** keep both drafts in `POSeedRound2.c`. Do not split the file across
contributors and do not hand-asm them. Further register and slot edits stay with lane 2. Mark a
draft only when its body matches and the shared exit still lands on `POSeedRound2` as in the EXE.

## LoadRosterList and chkprogress, splits

`LoadRosterList` (lane 2): the entry is marked with `LoadBothRosterLists`, and the body pieces
(`LoadRosterList_fa`, `LoadRosterList_team`, and the loops under them) are still asm. `chkprogress`
(lane 2, `InProgress.c`): the EXE splits it. The entry follows `PenaltyManager`, which falls into
it, and `chkprogress_go` / `chkprogress_x` follow `InProgress`. `c_progress.py` counts each as a
draft even though the entry is marked.

**Recommended ruling:** do not mark the remaining pieces, and do not convert either function to
hand-asm to make the count move. A split waits for a splice that keeps the EXE's layout. Until that
exists, both stay drafts and stay in their own files (one file, one owner).

## EditTextField and LeadersScreen, goto

`EditTextField` (`src/c/023_2FDD1_misc_dialogs/EditTextField.c`, lane 1) is 36 differing, cause
`register 31/35`. The round that cut it from 62 reduced 21 `goto`s to 4. The ones left rotate the
loop the way the EXE's block order does (the key poll is the test, the handlers are the body).
`LeadersScreen` (`src/c/017_21CDE_player_stats/LeadersScreen.c`, lane 1) uses `goto done` for the
same kind of rotation and is 84 differing.

**Recommended ruling:** do not mark either while a `goto` is still in the function. A `goto` is an
ESCALATE shape, not a silent match. When the only remaining difference is that one rotated loop,
bring it back to Abdul rather than marking it in a lane PR. Extra `goto`s, beyond the single
rotation the EXE has, stay rejected. Neither function is at that point today.

## ExecuteTrade, return type

`ExecuteTrade` (`src/c/032_3DC2C_roster_jersey/ExecuteTrade.c`, lane 1) once compiled to the EXE
bytes as `unsigned short`. Its caller `TradePlayers` uses `eax`, so a 16-bit result is the wrong
type and was reverted. The draft is a slot near-miss (`int` result, spilled `traded` / `kb`).

**Recommended ruling:** the result stays `int`. Do not mark an `unsigned short` `ExecuteTrade`. The
near-miss stays an ordinary lane 1 draft, not an escalation, as long as the result type is `int`.

## assbench, no-op mask

`assbench` (`src/c/037_4842A_engine_player_logic/assbench.c`, lane 1) is 22 differing. The swap test
is `((p->newpnum < 0x19) & 0xFF) ^ (p->newpos == 0)`. The compare is 0 or 1, so `& 0xFF` does not
change the value. The EXE widens with `mov edx, eax` / `and edx, 0FFh`, which is a real byte
extend, not a mask on a boolean.

**Recommended ruling:** reject the mask. Do not mark `assbench` while it is there. Taking it off is
lane 1's edit, and it is not by itself a match. Do not hand-asm the function to keep the mask.

## InProgress, file-local volatile

`InProgress` (`src/c/045_614C2_scoring_penalty_text/InProgress.c`, lane 2) is 88 differing. The file
declares `extern volatile short word_CBC44` so the `goto` loop re-reads it; a plain `short` is loaded
once into `cx`. The same file also has a function-local `volatile int m` so `d - m` is not folded.
Both are volatile used to force a reload. The `extern` is in this file only.

**Recommended ruling:** do not mark `InProgress` with either volatile. A file-local volatile is an
ESCALATE shape. Lane 2 should look for a reload the compiler cannot fold (a call, or a split of the
loop) before this comes back. Until that shape exists, leave the draft. Do not hand-asm it.

## OpenSpeechBank, stack layout

`OpenSpeechBank` (`src/c/061_83459_speech/OpenSpeechBank.c`, lane 2) is 11 differing, same size. The
frame that matches the EXE puts the `int` locals and the `short nsamples` in a fixed order (`w1`
before `fh`, `unsigned short type`, `int c`). That order is ordinary GA slot assignment
([WCC_INTERNALS.md](WCC_INTERNALS.md)), not a non-idiomatic shape. What is left is the first header
store (C copies through `eax` / `edx`; the EXE keeps the value in `ax`) and the type-byte shift.

**Recommended ruling:** not an escalation. Lane 2 keeps it. The declaration order that reproduces
the frame may stay. Do not hand-asm it, and do not accept a no-op cast or a wrong-width `type` just
to clear the last 11 instructions.
