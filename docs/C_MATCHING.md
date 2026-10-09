# C matching decompilation

Goal: rewrite the game's Watcom C functions as C that compiles to **exactly** the original bytes, function by
function, while the EXE keeps building byte-identical. Progress: [C_PROGRESS.md](../C_PROGRESS.md).

## How a C function replaces its asm

```
src/c/<segment>/<Func>.c ──wcc386 10.0 LA (DOSBox)──▶ build/c/<segment>/<Func>.obj (OMF)
        tools/cc.py compile                                   │ tools/cc.py frag (tools/cobj.py reads the OMF)
                                                              ▼
src/cseg01/<segment>.asm  %include "c/<segment>/<Func>.inc" ◀── build/c/<segment>/<Func>.inc  (db + dd label fixups)
        │ nasm -DCBUILD
        ▼
build/obj → tools/link_src.py → build/HOCKEY.EXE → sha1 check (the same check as the asm build)
```

* `<segment>` is the stem of the asm file (`042_59D9A_engine_core`); `<Func>` is the asm label of the first function.
* In the asm, the function is wrapped (by `tools/cc.py mark`):
  ```
  ; C: src/c/042_59D9A_engine_core/SetSPA.c
  %ifdef CBUILD
  %include "c/042_59D9A_engine_core/SetSPA.inc"
  %else
  SetSPA:
  push dword 4	; 59D9A
  ...                       (the original asm, unchanged: the build without the compiler uses it)
  %endif ; C
  ```
  The asm comments above the label stay outside the block; the asm inside stays as the reference and fallback.
* The fragment is the compiled `_TEXT` as `db` lines. Each fixup becomes `dd label+k` (32-bit offset) or
  `dd (label+k)-($+4)` (rel32 call/jmp), so the linker produces the same LE fixups as the asm. Every label of the
  asm block (the function, its `.x`/`.1` locals, mid-function entry points other code jumps to) is re-emitted at
  its original offset (from the `; <address>` comments), so the rest of the segment assembles unchanged.
* `make` sets `CBUILD=1` when the toolchain is found (`python3 tools/cc.py check`: dosbox, `$WATCOM_ROOT/dosla/WCC386.EXE`,
  10.0a `DOS4GW.EXE` and `W32RUN.EXE`; `WATCOM_ROOT` defaults to `~/watcom`). `make CBUILD=0` builds the asm
  fallback. **Both must MATCH.** Switching CBUILD rebuilds the objects (stamp `build/cbuild.N`).
* Only *marked* C files are built by `make`. A C file without the marker is a non-matching draft.
* Name decoration: wcc386 emits functions as `Name_` and data as `_Name`; `tools/cobj.py` maps them back to the asm
  labels (a decorated name that exists as an asm label, such as the library's `strcpy_`, is kept).
* Limits today: the C file may only produce code (`_TEXT`). String literals, `static` data and switch tables in
  `CONST`/`_DATA` are refused by `cobj.py` (they live in dseg02, not next to the code). Jump tables that Watcom puts
  in `_TEXT` work (fixups to the block itself).

## Headers (`src/c/include`, 8.3 names: the compiler runs under DOS)

| header | what | edited by |
|---|---|---|
| `nhl95.h` | the one include of every C file | hand |
| `types.h` | `s8 u8 s16 u16 s32 u32`, `NULL`, `HIWORD(x)` (integer word of a 16.16 value) | hand |
| `consts.h` | SPA animation numbers, flag bits (`pfrev`, `pf2aip`, `gmclock` ...) with their Genesis names | hand |
| `vars.h` | typed globals that override the inferred type (`gameopts` bitfields, `hmtmstruct`/`awtmstruct` as `Team`, replay pointers ...) | hand |
| `protos.h` | prototypes: every matched function, and asm functions whose signature is known | hand |
| `structs.h` | `Player` (80h) and `Team` (100h) from `src/inc/structs.inc`; gaps are `pad_XX` bytes; `OFS_*` macros | `tools/gen_cheaders.py` |
| `globals.h` | `extern` for every dseg02 label (type inferred from the asm accesses; `[]` when indexed) | `tools/gen_cheaders.py` |
| `asmfuncs.h` | `extern void Name();` for every code label (unprototyped: register args still work) | `tools/gen_cheaders.py` |

Run `python3 tools/gen_cheaders.py` (after `make`, it reads `build/obj`) whenever a label is renamed, a field is added
to `structs.inc`, or a name is added to `vars.h` / `protos.h` (the generated headers skip those names). Struct field
types: `size b` is `signed char`, `size w` `short`, `size d` `int`; overrides in `CTYPE` in the tool.

## Workflow (one function)

1. Pick a compiled-C function (starts with `push dword N` / `call __CHK`; not hand-written asm like `randomd0`,
   `vtoa`). Check its block has no jumps into other functions (shared tails) and that the previous function does
   not fall into it (see "Tail calls" below); otherwise take the whole group into one file.
2. Read the asm, its comment, its `name_map_94.csv` row and the 93G/94G routine. Write
   `src/c/<segment>/<Func>.c`:
   * `#include "nhl95.h"`, then a comment on **every** function: address, Genesis name and file (or "PC only"),
     what it does, arguments and result. Bring the asm comments over (block comment and the per-line ones).
   * Names: the asm labels for functions and globals, the `structs.inc` field names, Genesis names for constants
     (`consts.h`). No 95G names. Locals by what they hold.
   * Add the prototype to `protos.h` (grouped by segment, address in the comment).
3. `python3 tools/cdiff.py src/c/<segment>/<Func>.c` compiles it and prints compiled vs original side by side
   (`!` differs, `~` same instruction but a different relocation target or immediate); exit 0 and `MATCH` when
   the bytes, the fixup targets and the size agree. Iterate.
4. `python3 tools/cc.py mark src/c/<segment>/<Func>.c [--end NextLabel]` (`--end` for a multi-function file; a
   label that does not exist runs to the end of the segment). `make` must MATCH, and `make CBUILD=0` too.
5. `python3 tools/c_progress.py` (updates `C_PROGRESS.md` and `tools/c_functions.csv`; keep a reason in the notes
   column for a non-matching draft). Commit the C file, the asm marker, the headers, the progress files.

`tools/cc.py unmark` removes a marker (for example to merge a function into a multi-function file).

## Multi-block files (shared exits)

Watcom merges identical function tails (`pop edi / pop esi / ... / ret`) across one source file: a later function
jumps (`jmp near`) into an earlier function's epilogue when it is more than 127 bytes away. In the EXE this shows
as a jump from one function into another's `_popedi`/`_ret` label (StopNA into EvadePlayers, about 14 engine_core
functions into `calcpuckcross_ret5/6` and `changeplayer_ret5`: the original was one source file per segment).

* Put the functions in one C file in address order, named after the first one. Functions between them that are
  not matched yet stay in the file as drafts: they give the distance that makes the compiler emit the near jump.
* Mark each block separately: `cc.py mark File.c` for the first function (includes `c/<seg>/<File>.inc`),
  `cc.py mark File.c --func F` for any other (includes `c/<seg>/<File>.<F>.inc`). Only the matched functions need
  marking; drafts stay asm.
* `frag` cuts F's bytes out of the file's `_TEXT` and rewrites every rel32 branch that leaves the slice as
  `dd (Label+k)-($+4)`: Label+k is the target in a marked block of the file, or, for a draft function, the shared
  ret tail found by its bytes (the bytes up to the next `ret` must occur exactly once in the original function).
  Short branches out of the slice are an error.
* `cdiff.py File.c --func F` compares one function of the file; `c_progress.py` lists one row per marked block and
  one `nonmatching` row per unmarked function (notes key `c_file` or `c_file:Func` in the csv).

## Hand-written asm (status `asm`)

`python3 tools/find_handasm.py [--list]` scans the game segments (001-066, libraries excluded) and writes
`tools/handasm.csv`. Watcom 10.0 C always starts a function with `push N / call __CHK`. A function **without** it
and with a strong hand-asm signal (port `in`/`out`, 16-bit push/pop, `loop`, `lds`/`les`, `pusha`, `int`,
`cli`/`sti`, string ops without `rep`, a call to the middle of a function), or any no-`__CHK` function in
`asm_helpers`, gets status `asm`. `c_progress.py` copies those rows into `tools/c_functions.csv` /
`C_PROGRESS.md` with status `asm` and no C file: the C queue skips them, and they are not in the denominator.
No-`__CHK` functions without a strong signal are listed as `nochk` (review by hand): `main_startup`'s
`Read*Pad` are C compiled without stack checks (Watcom register convention), most of the others are case blocks
or callback pieces of a C function reached through a pointer table, and a few are data disassembled as code
(`stand_tmpl2`). `sahf` is not a signal: Watcom emits `fnstsw ax / sahf` after every float compare.

## Compiler learnings (Watcom C/C++32 10.0 LA, `wcc386` with no options)

* **Flags**: none. `-5r -fpi -zp1 -mf`, stack checks on, no `-o`. Every function so far matched with the defaults.
* **char is unsigned** by default: a plain `char` global is read with `xor edx,edx / mov dl,[x]`; a byte read with
  `movsx` or the `-5r` idiom `mov r,[x-3] / sar r,18h` is `signed char`. Words read with `mov r,[x-2] / sar r,10h`
  are `short`.
* **-zp1** confirmed (`struct {char; int; short;}` has sizeof 7), so `Player`/`Team` are declared with exact
  offsets and pad bytes.
* **Tail calls even without -o**: a call as the last statement of a void function becomes `jmp f`. When `f` is the
  next function in the same source file the `jmp` disappears and the code falls through: pucknothing →
  puckunflip, forceteams → forcepldata (also seen: TeamLineEnergy → getlinee, SprSortVert → SprSort). Such
  groups must be one C file, in address order. A conditional `return f();` becomes `jne f` (PaSpeechBusy).
* **Shared epilogues across functions**: StopNA ends with `jmp EvadePlayers_popedi` (the pop/ret tail of
  EvadePlayers), so StopNA can only match in the same file as EvadePlayers.
* **Chained assignments store right to left**: `joyqtick = joyqcount = 0` stores joyqcount first.
* **Branch layout follows the source**: the `if` arm comes first; flip the condition when the arms are swapped
  (updatePPTeamTime needed `(gmode2 & 0x40) == 0`). Small tails (`inc / ret`) are duplicated into both arms.
* **Argument count shows in register choice**: a value kept across calls goes into the first register that is not
  an argument (edx, then ebx, then ecx; esi/edi after). PaPlayerNumber keeps its first argument in ecx, so it
  takes three arguments (eax, edx, ebx) and passes them through to SayPlayerNumber.
* **Bitfields**: a 1-bit field of an `unsigned` bitfield is tested as `test byte [x+n], m`; a 2-bit field is
  extracted with `shl / shr` of the dword (`gameopts.pertime`: `shl eax,14h / shr eax,1Eh`).
* **short loop counters** compare with `cmp cx, 11h`; `do { } while (--n)` with a `short n` gives `dec si / jne`;
  `while (f() == 0) ;` and `do {} while (...)` give the bottom-tested loops seen in the sound wrappers.
* `if ((p->position = p->newpos) >= 0)` gives `movsx ax,byte [newpos] / mov [position],ax / test ax,ax` (forcepldata).
* Unprototyped calls still pass register arguments, but declare the prototype when the result or argument
  widths matter (`short sub_8F80E(int)` gives `test ax,ax`).
* **Declaration order picks registers**: locals get registers in declaration order. restoreteams matched only
  with `unsigned char *r;` declared before `short *dst;` (r took eax, dst edx); playeracc needed `short yacc, xacc;`.
* **Operand order of commutative ops matters**: `xacc ^ p->Wallsin` loads Wallsin into eax and xacc into edx;
  `p->Wallsin ^ xacc` swaps them. Likewise `HIBYTE(p->Xvel) + HIWORD(p->Xpos)` vs the reverse (skateto).
* **Common subexpressions are reused, named temps are not always**: playeracc's `(legstr + 30h)` written twice
  (no variable) gave `movzx edi,[legstr] / ... / add edi,30h` once, as the original; a `str` variable reordered it.
* **Two read-modify-writes on one byte merge**: `p->pflags &= ~pfjoy; p->pflags |= pfna;` (the 93G bclr/bset)
  gives `mov ch,[x] / and ch,0F5h / mov dl,ch / or dl,2 / mov [x],dl` (restorepl); one combined expression does not.
* **Known-zero registers are reused**: after `mov ax,[position] / test ax,ax / jne` the compiler skips the
  `xor ah,ah` it needs later. A `(unsigned short)` cast on the byte (`regd2.w += (unsigned short)p->legstr + 0x14`)
  gave the original `cmp word [position],0` + `xor ah,ah`.
* **`(short)(x >> 3)` then `0x20 - ...`**: write the subtraction first and the byte add last to get
  `movsx edx,ax / mov eax,20h / sub eax,edx / mov edx,eax / mov al,[legstr] / add eax,edx` (playeracc).
* **Counted 68k loops** (`dbf`): `i = 6; do { ... } while (--i != 0);` gives `dec dx / jne` (AvgCline);
  a `for` loop adds a `jmp` to the test. A `for` whose start value already passes the test (`k = 27; k >= 0`)
  still gets the `jmp`; use `do { } while (--k >= 0)` for the bottom-only test (RestBench).
* **The 68k registers** regd0-regd4 are 4-byte statics read both as words and longs: vars.h declares them as
  `Reg68` unions (`.w`, `.l`, `.ul`); `.ul` gives the unsigned `ja` of playeracc's max speed check.
* **Shared tails need the whole file**: StopNA matched only once EvadePlayers and skateto (drafts) were in the
  same file before it, see "Multi-block files".
* **Declaration order** of locals changes register allocation in some functions (calcpuckcross), not in others.
* **gmode bit 0** (`gmclock`) means "game clock stopped" (93G ram93): ResetClock sets it, the faceoff drop
  clears it. Code that tests it and skips work does so while the clock is stopped.
* **Still open**: EvadePlayers needs one more stack dword (a swap spill for the vtoa args while ebp is busy);
  skateto picks edx where the original picks eax for two short-lived loads (Xvel|Yvel, the pucky pointer);
  calcpuckcross is 2 bytes short (x/side registers swapped, a 16-bit `mov bx,dx`). reenergizeteam (ends in
  calcpuckcross's tail) matched in calcpuckcross.c anyway: the draft's tail bytes are unique, and GetHot (draft)
  between them gives the distance for the near jump. GetHot keeps the flip negate in a fresh register (esi).
