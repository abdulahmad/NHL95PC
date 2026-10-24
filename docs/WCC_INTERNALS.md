# wcc386 10.0 GA internals

How the reference compiler works inside, and the tools that look into it. Workflow: [C_MATCHING.md](C_MATCHING.md).

The compiler is not decompiled. Its code generator is Watcom's, and Open Watcom's source of it
(github.com/open-watcom/open-watcom-v2, `bld/cg`) is a close descendant: the GA routines named below were found
in the binary and read against that source, and every one checked so far does what the Open Watcom code does.
Open Watcom has later changes (comments dated Nov 1994 and later), so the binary is the reference when they
disagree.

## The binary and the emulator (tools/wccre)

`WCC386.EXE` is three programs in one file:

1. an MZ stub ("This program requires W32RUN.EXE to be in your PATH"),
2. a small OS/2 LX loader (`tools/wccre/lx_load.py` parses it: 3 pages, imports from DOSCALLS / KBDCALLS),
3. the compiler, in Watcom's "CF" format (`tools/wccre/cf_load.py`): a flat 32-bit image linked at 0 with a
   relocation table. GA: image at file offset 2200h, 80E30h bytes, 90000h of memory, entry +2FD30h.

Under DOS, W32RUN.EXE (a DOS/4GW program) loads the CF image; under OS/2 the LX loader does. Either way the
program asks for system services through one far-callable "int 21h" entry with DOS register conventions (carry
set = error, code in eax). The LX loader's dispatcher lists the only 24 functions it may use (open, create,
read, write, seek, close, delete, rename, ioctl 0, allocate, find first / next, get / set file time, current
directory, true name, date, time, console). In GA every call goes through one stub, image +2FE03h.

`tools/wccre/wccemu.py` runs the CF image in the unicorn CPU emulator and does those int 21h functions in
Python (files under a host directory as drive C:). No DOSBox, no DOS/4GW:

* `python3 tools/wccre/emucc.py compile SRC.c` compiles a project C file the way `cc.py` lays it out for DOSBox
  (S000.C, headers in INC\ with 8.3 upper-case names, INCLUDE=C:\INC, no options). About 1.3 s per file.
* `python3 tools/wccre/emucc.py validate [--jobs 8]` compiles every C file that has a DOSBox object in the
  `cc.py` cache and compares the two objects (dependency comments aside: they hold file times). First run:
  703 of 703 the same; later 711 of 711, also with `--fill 0xCC` (garbage instead of zeros in fresh memory)
  and with the heap moved (`--heap-skew 0x123450 --heap-align 16`).
* `emucc.compile_session([(src, obj), ...])` compiles several files one after another in the same emulated
  memory, as one DOSBox run does (see "The compiler state" below).
* `python3 tools/wccre/ghidra_wcc.py` decompiles the whole image with Ghidra (headless) at the emulator's load
  address (`wccemu.BASE` = 400000h, so image offset = address - 400000h) into `build/wccre/ghidra/all.c`: a
  reading aid, about 3,350 functions.

Needs the `unicorn` Python package (2.1.4 tested; without pip, unzip the manylinux wheel from PyPI into
`~/.local/lib/python3.12/site-packages`, as capstone was installed).

## Register allocation (tools/wccre/regdump.py)

`python3 tools/wccre/regdump.py src/c/<seg>/<File>.c` compiles the file in the emulator and prints, for every
allocation pass of every function, each variable and code-generator temporary (`tN`) in the order it is given a
register, with its savings and what it got:

```
pass 1: 24 conflicts                       (DrawListItem, draft)
  x              size 4  savings     11  -> ESI
  w              size 4  savings      9  -> EDI
  c              size 4  savings      9  -> EDX
  y              size 4  savings      6  -> BP
  text           size 4  savings      6  -> memory
  ...
```

The GA routines (image offsets) and what they do, as in Open Watcom `bld/cg/c/regalloc.c` / `regsave.c`:

| GA | Open Watcom | what |
|---|---|---|
| +5694C | `AssignConflicts` | one pass: `CalcSavings` (+4F9BC) for every conflict, `ConstSavings`, sort, then in that order: savings 0 -> `InMemory` (+56840), else `GiveRegister` (+56888) |
| +56A48 | `ConfBefore` | `c1->savings > c2->savings` (unsigned) |
| +64FC3 / +64F44 | `SortList` / `ShellSort` | the sort: a Shell sort, **not stable** |
| +56528 | `GiveBestReg` | picks the register (below); returns the register set in eax (+568BD) |
| +53EDE | `TempAllocBefore` | stack slot order (below) |
| +E210 / +18334 | `FEName` / `SymGetPtr` | front-end symbol -> name (regdump reads names this way) |

GA's `conflict_node`: +0 next, +8 name, +C start block, +10 register tree, +14 savings, +1C available,
+54 state. `name` (N_TEMP): +4 class (2), +5 type class, +8 size, +14 front-end symbol handle (0 for a code
generator temporary), +24 id, +2A temp flags.

What decides a variable's register:

1. **Savings, not declaration order.** Every variable and temporary is a *conflict*. `CalcSavings` adds, for
   each instruction in its live range, a gain per use and per definition (a use as the first operand of an
   instruction whose result is a register counts twice; a definition from a register adds a use), weighted by the
   loop depth of the block (each loop level multiplies by a factor), minus the loads and stores a register copy
   would need around calls when the variable must also live in memory (its address is taken, or it is used in
   another block and memory is needed). Conflicts are given registers in **descending savings**: the variable
   with the most (loop-weighted) uses chooses first.
2. **Ties are ordered by an unstable sort.** The conflict list is built by prepending (newest first) and then
   Shell-sorted (gap = gap / 2 + adjust, adjust alternating 0 / 1). Equal savings keep no fixed relative order:
   where two tied variables end up depends on the list's length and on every other entry. This is why
   declaration order "works" only sometimes, and why an unrelated statement that adds or removes a temporary
   can move two other variables' registers (the "one-slot register-cycle shift" of several UNSURE entries).
3. **The register itself.** `GiveBestReg` walks the candidate registers of the variable's type in their table
   order, skips any that conflict (live at the same time, or reserved), and takes the one that creates the most
   `mov r, r` / `op r, x -> r` instructions (`CountRegMoves`); on a tie it prefers a register already given out
   in this function (no extra push / pop) over a new one; otherwise the first in table order.
4. **Memory.** Savings 0 (or no register left) puts the conflict in memory (a stack slot).

So to move a variable to another register: change the savings order (how often and where in loops each one is
used), not the declaration order, unless regdump shows the two tied. Example: in the DrawListItem draft, x (11) and
w (9) choose before y (6) and take ESI / EDI; the EXE has y in EDI and w in EBP, so in the original y outranked w.

## Stack slots (tools/wccre/slotdump.py)

After register allocation the names that need memory (locals left in memory, spilled temporaries, arrays and
structures) get their slots from the order of `Names[N_TEMP]` (+7E778), the list of all variables and
temporaries. The list is sorted three times, always with the same unstable Shell sort (`SortList` +64FC3 /
`ShellSort` +64F44):

1. **By use count** (comparator +57A0B, called at +57AE7; once per function, twice in some, e.g. PreGameScreen).
   Just before the sort, +57A5B walks every instruction and, for each operand and result that is a variable or
   temporary, adds a loop-weighted 1 (+4F998, the weight of the block; a reference inside TeamRosterScreen's
   loops counts 10) to its conflict's +14, the savings field. The count is taken on the instruction stream before
   the final register substitution, so `n++` still counts n twice. Order: names with a conflict first, by count
   **descending** (unsigned); names without a conflict (arrays, structures, other names that were never
   register candidates) after them, by id (+24) descending; names with temp flag 100h (+2B bit 0) last. The conflicts are rebuilt between
   two such sorts (their memory reused), so the counts are recomputed for the second.
2. **By size** (`TempAllocBefore` +53EDE, in `AssignOtherLocals` +53E4D): temp flag 200h (+2B bit 1, far-pointer
   halves) first, then **size ascending** (shorts before ints: the "-od puts short locals above int locals"
   rule), then the parts of one variable by offset descending. It sorts the list down to `LastTemp` (+7E798).

`AssignOtherLocals` then hands out the slots in that final order, **from the top of the frame down**. A name
whose live range does not overlap an earlier name's reuses that slot (`ReUsableStack`): in PreGameScreen t158
and t231 share [esp+63Ch]. The location (+20) is a negative offset from the top of the locals: with an esp
frame the slot is [esp + frame + location] at push depth 0, the frame being `CurrProc` (+7E764) +2C + +30 +
+0C; a parameter homed by a `push` after the `sub esp` gets its location only at the prologue (+4D0B6:
TeamRosterScreen's team is [esp+0]). With an ebp frame (-od) the location is the [ebp-n] offset itself. Under -od
`AssignOtherLocals` runs once per statement block and each run sorts only the names new since the last one, so
the slots follow the blocks.

The slot order is not the count order. The size sort is a Shell sort over the whole list (in TeamRosterScreen
225 names), and equal sizes do not keep their order: gs leaves the use-count sort 10th and the size sort 106th,
behind mf (65th, count 3). But it is a fixed function of the use-count order, so changing one count moves the
slots in a way that can be computed.

**Why declaration order can only swap tied pairs.** Declaration order changes the order in which the names come
into the use-count sort, not their counts. Names with a conflict come out ordered by count whatever their input
order, so only names with equal counts can trade places: in TeamRosterScreen m / n (63), idx / gs (60) and
pfh / kfh (42) are the only pairs that five declaration orders flipped. To move a slot, change the count: how
often, and inside how many loops, the variable is referenced.

`python3 tools/wccre/slotdump.py src/c/<seg>/<File>.c [--func NAME] [--count NAME=N ...]` prints, per function,
the names with a slot in hand-out order with their size, count, position after each sort, location and slot,
and checks a Python copy of the three sorts against the compiler's lists. `--count NAME=N` compiles again with
the count written into the conflict before each use-count sort and shows the slots the compiler then hands out
next to the compiled ones (the Python copy's prediction from the first compile's lists is checked against it).
TeamRosterScreen's n has 63 references; with 50:

```
  name    size  count conf  use1  size location slot       |  use1  size location slot
  m          4     63  yes     7    46       -8 [esp+408h] |     7    46       -8 [esp+408h]
  n          4     63  yes     8    47      -12 [esp+404h] |    11   107      -32 [esp+3F0h]  *
  idx        4     60  yes     9    48      -16 [esp+400h] |     8    47      -12 [esp+404h]  *
  gs         4     60  yes    10   106      -32 [esp+3F0h] |     9    48      -16 [esp+400h]  *
```

n [esp+3F0h], idx 404h, gs 400h are the EXE's slots: the original has one loop-weighted reference to n fewer
than the draft (any count from 43 to 60 gives the same slots).

## The compiler state: one field the compiler never sets

wcc386 can compile the same source differently after other programs in the same DOSBox session, and after
other functions in the same file (C_MATCHING "The compiler state"). The cause is one uninitialized read, found
with the emulator (the old standalone DrawBevelBox draft, 69 differing fresh, 0 after a warm-up compile;
bisecting the warm-up's leftover heap came down to one byte):

* `BlkTooBig` (GA +38F97; Open Watcom `bld/cg/c/makeblk.c`) is called at statement boundaries. It ends the
  current basic block when `InsId - CurrBlock->first_instruction->id >= 75` (`INS_PER_BLOCK`).
* `id` (+34h of an instruction) is set only by `AddIns` (`id = ++InsId`). `NewIns` (GA +387D5) allocates from a
  free list and does not set it, so an instruction that starts a block without going through `AddIns` keeps
  whatever its memory held.
* Fresh memory holds 0, so `InsId - 0 >= 75` once the function is past 75 instructions: the block is split. A
  large positive leftover (an old pointer, or the id of an instruction recycled from an earlier function of the
  same file) makes the difference negative: no split. Block boundaries change the live ranges and so the
  register allocation and the code.
* Constant garbage does not show it: 0x00, 0xCC and 0xFF read as 0 or negative (split, the fresh result); a
  fill such as 0x40 (40404040h) gives the warm result.

`emucc.compile_c(src, obj, fill=0x40)` compiles in that warm state; `python3 tools/wccre/state_scan.py` scores
functions both ways. Results (2026-10-23, 928 matched): of the 711 files with cached objects only DrawPanel3D.c
compiles differently warm, and DrawPanel3D itself matches fresh (53 differing warm), so the EXE was built in the
fresh-like state there. Of the 156 drafts, two score differently warm and none matches: FixJerseyConflict
20 (+2 bytes) fresh -> 16 (right size) warm, SimulateGame 592 -> 627. The compiler state does not explain the
remaining drafts.
