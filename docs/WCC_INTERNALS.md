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

## Stack slots

Memory for temporaries (and locals that need it) is laid out after `Names[N_TEMP]` is sorted with
`TempAllocBefore` (+53EDE), the same unstable Shell sort: temporaries used as far-pointer halves first, then by
**size ascending** (shorts before ints: the "-od puts short locals above int locals" rule), then the parts of one
variable by offset. Equal sizes keep the unstable sort's order. A temporary whose live range does not overlap
an earlier one's reuses its slot (`ReUsableStack`).

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
