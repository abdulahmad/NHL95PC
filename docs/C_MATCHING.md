# C matching decompilation

Goal: rewrite the game's Watcom C functions as C that compiles to **exactly** the original bytes, function by
function, while the EXE keeps building byte-identical. Progress: [C_PROGRESS.md](../C_PROGRESS.md).

## How a C function replaces its asm

```
src/c/<segment>/<Func>.c ──wcc386 10.0 GA (DOSBox)──▶ build/c/<segment>/<Func>.obj (OMF)
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
  10.0a `DOS4GW.EXE` and `W32RUN.EXE`; `WATCOM_ROOT` defaults to `tools/watcom`). `make CBUILD=0` builds the asm
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

1. Pick a compiled-C function in a game segment (library segments stay asm; starts with `push dword N` / `call __CHK`; not hand-written asm like `randomd0`,
   `vtoa`). Check its block has no jumps into other functions (shared tails) and that the previous function does
   not fall into it (see "Tail calls" below); otherwise take the whole group into one file.
2. Read the asm, its comment, its `name_map_94.csv` row and the Genesis routine (93G, else 94G; not 95G). Write
   `src/c/<segment>/<Func>.c`:
   * `#include "nhl95.h"`, then a comment on **every** function: address, Genesis name and file (or "PC only"),
     what it does, arguments and result. Bring the asm comments over (block comment and the per-line ones).
   * Names: the asm labels for functions and globals, the `structs.inc` field names, Genesis names for constants
     (`consts.h`). Source order is 93G, else 94G, else behaviour. NHL95Genesis is a loose reference only.
     Locals by what they hold.
   * Name the auto globals this function uses (`byte_` / `word_` / `dword_`) from the same stores in that
     Genesis routine, with `tools/rename_symbol.py`, before the final `cdiff`. A label that is a known object's
     field takes that field's name (`pucktemp1` is `puckstruct+temp1`). A nosplit column keeps its own label.
     Do not fold a label that `globals.h` declares into `BASE+k`.
   * Add the prototype to `protos.h` (grouped by segment, address in the comment).
3. `python3 tools/cdiff.py src/c/<segment>/<Func>.c` compiles it and prints compiled vs original side by side
   (`!` differs, `~` same instruction but a different relocation target or immediate); exit 0 and `MATCH` when
   the bytes, the fixup targets and the size agree. Iterate.
4. `python3 tools/cc.py mark src/c/<segment>/<Func>.c [--end NextLabel]` (`--end` for a multi-function file; a
   label that does not exist runs to the end of the segment). `make` must MATCH, and `make CBUILD=0` too.
5. `python3 tools/c_progress.py` (updates `C_PROGRESS.md` and `tools/c_functions.csv`; keep a reason in the notes
   column for a non-matching draft). Commit the C file, the asm marker, the headers, the progress files.

`tools/cc.py unmark` removes a marker (for example to merge a function into a multi-function file).

**Compile speed.** Objects are cached by a sha1 of the compiler, the flags, the .c file (with its name) and the
headers it includes (`~/.cache/nhl95pc-cc`; `NHL95_NOCACHE=1` recompiles). DOSBox runs the compiler on the
dynamic core at a fixed 2,000,000 cycles (`NHL95_CC_CPU` overrides the `[cpu]` lines; `cycles=max` ramps up over
the first seconds of each run and takes twice as long). A tool that compiles many candidates should call
`cc.compile_many(items)` (one DOSBox run per 16 sources, `NHL95_CC_BATCH`) or `cc.compile_parallel(items, jobs)`
(that, on several DOSBox processes at once) instead of `compile_c` per candidate: tools/permute_decls.py and
tools/scope_decls.py do. `cc.py compile A.c B.c ...` does the same from the shell.

**The compiler state.** wcc386 can compile the same source differently after other files in the same DOSBox run
(DrawBevelBox matched after most files but not fresh; HANDOFF step 3. The state can come from an earlier
function of the same file too: after FitPlayerName, the function before it in the EXE, in one file it matches
fresh, and that is how it is built now). `make` compiles each file in its own run, so
only the fresh result counts. So `compile_many` caches only the first object of each run, and permute.py
compiles a match again alone before it counts it. A score from a batched run can be off for the few
state-sensitive drafts (DrawBevelBox, DrawPanel3D): check one with tools/state_probe.py. The cause is known: one
instruction field the code generator reads without setting decides whether a long basic block is split
([WCC_INTERNALS.md](WCC_INTERNALS.md) "The compiler state"); `tools/wccre/state_scan.py` scores drafts in both
states.

**Inside the compiler.** [WCC_INTERNALS.md](WCC_INTERNALS.md): wcc386 runs in a CPU emulator
(`tools/wccre/emucc.py`, the same objects as DOSBox), and `tools/wccre/regdump.py FILE.c` prints, per function,
every variable's register-allocation savings and the register it got. Registers go to variables in order of
(loop-weighted) savings; declaration order only breaks ties, and an unstable sort reorders those.

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

## The compiler: 10.0 GA (default), 10.0 LA (fallback)

The reference compiler is **Watcom C/C++32 10.0 GA** `wcc386` (31 May 1994, `tools/watcom/dosga`), the compiler
HOCKEY.EXE was built with: its clib3r matches the EXE best (124 modules against 121 for 10.0a and 110 for LA, and
it is the only version with `scnf` and `grownear` exact), and it compiled 10 LA near misses to the EXE bytes as
they were. Until 2026-10-22 the reference was **10.0 LA** (`tools/watcom/dosla` with the 10.0a DOS/4GW), the only
10.0 build known then; it stays in the repo:

```
make                       # 10.0 GA (WATCOM_VER=ga, the default)
make WATCOM_VER=la         # 10.0 LA, e.g. to see whether a draft matched under LA
WATCOM_VER=la python3 tools/cdiff.py FILE --func F
python3 tools/cc.py version
```

Switching recompiles the C (a `build/watcom.<ver>` stamp) and the compile cache keys include the version. The
matched C is tuned for GA, so `make WATCOM_VER=la` is not byte-identical (on the switch tree 810 of the 828
GA-matched functions also match under LA). GA and LA compile almost all game code identically: 749 of the 766
blocks matched under LA gave the same bytes under GA. Where they differ it is register and slot choices, and the
LA-tuned shapes were re-tuned with the usual tools: declaration order (Endfaceoff, FormatPlayerName, MessageBox,
WriteLeagueInfo, main_), an int temporary dropped (checkagr: `n += n >> 1; return randomd0(n);`), an existing
local used as the loop counter (FallDown), operand order (sub_4C8BD), a byte local for a byte value
(POSeedConfFinals, DrawControlsOpts), and AskDatabaseChoice's plain first draft (the `(k - k)` trick it needed under
LA is gone). Still GA drafts: PickAwardWinners (one sum: GA gives `xor eax,eax / mov al,[x] / lea esi,[edx+eax]`,
the EXE `movzx esi,byte [x] / add esi,edx`, which LA produces from the same C) and OpenSpeechBank (docs/UNSURE.md).
The learnings below were found under LA; they hold under GA unless noted.

## Compiler learnings (Watcom C/C++32 10.0, `wcc386` with no options)

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
* **`if ((A && B) || C) return 0` shares one epilogue**: a false A jumps to the C test, a true B jumps to
  `xor eax, eax`, and C falling through uses that same return (check4bench). Two separate `if`s duplicate it.
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
  A named local keeps that register on a path where the value is dead, so the other arm cannot reuse it.
  DrawPanelClock tests `hudclockmin` directly: the load stays in edx for the minutes arm (`mov eax, edx` into
  the divide) and the zero-minute arm reuses edx for the colon sprite. An `int m = hudclockmin` left the colon in ebp.
* **-od, one array, and the hidden return temporary**: with `-od`, each short or int local is 4 bytes and they are
  allocated from ebp downward in declaration order. The parameters and the hidden `return 0` temporary come after
  those scalars. One array leaves parameter `a` at the lower address and the return temporary just above it
  (LoadLeagueTree; LoadPlayoffModeTree's original, `a` at ebp-30h and the return at ebp-2Ch). Two or three arrays
  swap those two slots. Joining the regions into one buffer keeps every other address and restores that order:
  LoadPlayoffModeTree's unused 64 bytes, the 32-byte path and the 8-byte schedule record are one `unsigned char buf[104]`
  (`buf + 64` is the path, `buf + 96` is the record). `return 0;` is the hidden temporary. An explicit `int ret = 0; return ret;`
  copies into a second slot and does not match.
* **-od puts short locals above int locals**: the shorts take the slots from ebp-4 down in declaration order and
  the ints follow; unused locals still get slots. TeamFromMouse's loop counter is at ebp-0Ch, so it is the third
  of six shorts (five unused); with int padding around it, it moved to ebp-4. TeamFromMouse is the last function
  of segment 017 and is `-od` like segment 018 after it; the rest of 017 is optimised.
* **A volatile int through a pointer compares in memory**: `if (*(volatile int *)sel >= 0)` is `cmp dword [esi], 0` / `jl`. A plain `*sel >= 0` loads it (`mov eax,[esi]` / `test eax,eax`) and hoists the later `*sel * 27` into that register (MenuShowPlayerStats). `side * 0x2F4` is the shift chain (`shl` / `sub` / `shl`); `side * 0x2DC` is `imul`.
* **A copied register argument and a stack pointer swap ebp and edi** when both a frame and a later loop are present. `button = art` after `DrawMenuBar` put art in ebp and the stack pointer in edi, and only while that pointer was not reused as the next loop counter. With DrawTradeScreen's roster loop the copy spilled (`push edx`, cookie 0x64). A named `int *` for the same stack pointer did the same. Leaving the register argument in its parameter kept art in ebp and cookie 0x60, and the half-index took edi, so the stack pointer was reloaded.
* **A named cdecl argument is loaded into eax**: `song = songdata; sub_8D2F0(song)` is the 5-byte `mov eax,[songdata] / push eax`. `sub_8D2F0(songdata)` is `mov esi,[songdata] / push esi`, and `songdata = 0` after it is `xor edi,edi` (RunEditRosters).
* **Eight score bytes compared to 0xFF**: `g[4] != 0xFF || g[0x2E] != 0xFF || ...` with the pointer in ecx and the counter in ebx is `mov ah,[ecx+4]` / `cmp ah,0FFh`, then `mov dl` / `cmp dl,ah`, `mov dh`, `mov al`, and the rest `cmp reg,[mem]` (POSeedRound2). Named `unsigned char` temps take al, ah, dh, dl instead. `rem = i % div; rem += rem; rem += day` is `add edx,edx` / `add edx,[day]`; `(i % div) * 2 + day` is `lea eax,[edx+edx]`. `for (; i < 8; i++)` after `i = 0; k = 0;` is the leading `jmp` to the test. One int used as both that remainder and a later counter spills a dword.
* **A just-stored global is still in eax**: `dword_D0C10 = dword_EBCA4; dword_D0C04 = (dword_D0BFC - 4) * dword_D0C10 / dword_D0C18` multiplies in edx by that leftover eax and sign-divides. `*(volatile int *)&dword_D0C10` is the memory operand of `imul eax, [dword_D0C10]`, and `(unsigned)product / (unsigned)divisor` is `xor edx, edx` / `div` (DrawRosterList). The `for` increment `n++, i++` is `inc edi` then `inc esi`.
* **One MakePath with a ternary hoists the shared arguments**: writing `MakePath` in both arms of `fileoncd[n] == 1` repeats `xor ecx, ecx` / `mov ebx, name` (DrawCreatePlayer, 608 vs 587). `MakePath(buf, fileoncd[0x1C3] == 1 ? (char *)cddriveptr : 0, name, 0)` hoists ecx and ebx in front of the compare. A switch on the position byte with `default: goto shown;` past the shared `strcat`, and no `pos = 0`, keeps the compare tree (G, L, R, then C, D) without a leading `xor edx, edx`.
* **Finish a sprite-size multiply before the call**: `sub_8CCA8(name, ((((short *)pointerspr)[2] << 2) + 4) * (((short *)pointerspr)[3] + 1) + 0x11, 0x20)` pushes `0x20` before the multiply (RunMessageBox). Assigning that product to a local first finishes the arithmetic, then pushes `0x20`. The left factor stays in edx (`[2] << 2`, then `+ 4` after the right factor) and the right factor (`[3] + 1`) stays in eax, with the pointer loaded into eax. Naming `w` and `h` and shifting `w` first puts the pointer in edx.
* **A second local keeps the return constant in eax**: `if (gamemode == 0) r = 2; else r = picked; return r` is `mov eax, 2` / `jmp` / `mov eax, esi` (LockerRoomScreen). `picked = 2; return picked` writes the 2 into the register that already holds the other result (`mov esi, 2`, 626 vs 628).
* **The same-day arm falls through**: `if (DateKey(game[0], game[1]) <= date)` is `jg` to the later-day arm (SimScheduleDay). Writing the later-day test first is `jle` and puts that arm ahead of the same-day body. Copy the teams pointer before clearing the stop flag; the other way round zeros the flag first. The club index is `((id << 4) - id) * 2` so the `* 2` stays in the address.
* **A zero return right after a compare falls through**: `if (diff <= 0) return 0;` with `diff` just copied (`mov eax, ecx`) is `jg` over `xor eax, ecx` / `pop` / `ret` (ChkPullGoalieLate). `if (diff > 0) { ... } return 0;` puts the body first and jumps to the zero return. A later `return 0` that is the same `xor eax, eax` epilogue is a jump to the first one; inverting the last compare so the zero return sits at the bottom pulls every earlier return there too (ChkDelayedOffside, 208 vs 192).
* **A switch on a re-read global**: `while (deskexit != 1) switch (deskexit)` is `mov edx, [deskexit]` / `cmp edx, 1` /
  `je` / `lea eax, [edx-2]` (the load is reused and the table index built in eax). `while ((d = deskexit) != 1)
  switch (d)` loads into eax and indexes in place (`sub eax, 2`), which also moves the registers of every case
  (CalStandingsMenu, GameStandingsMenu).
* **Zero arguments after an error test**: right after `err = f(...); if (!err)`, five zero MessageBox arguments
  written as `0` are `push eax` x5 (the call result known to be 0). Written as `err` they go through a copy
  (`mov edx, eax` / `push edx`); the EXE's `push esi` x5 elsewhere is `err` itself (MergeLeagueFiles).
* **Shared chains come from repeated source**: when one branch of the EXE jumps into the middle of another branch's
  `if (!err) err = ...` chain, write the chain in both branches; Watcom cross-jumps the second copy into the first.
  When the EXE keeps the last call of two branches separate before one shared call (two `WriteLeagueTeamEntry`
  then one `FileClose`), put the shared call at the end of each branch: with one copy after the `if / else`
  Watcom merges the two last calls instead (ImportPlayerTeam). The same move did not keep POHandleElimination's
  two `RestoreDialogBg` calls apart.
* **Plain locals rather than a frame struct** when the EXE spills: a struct whose members have their address taken (`&s.w`) makes every member look clobbered by calls, so a pointer kept there is reloaded after each call and its sums are not kept, and the register pressure moves (a stack argument went into ebp). Plain locals let Watcom choose the spill slots itself; their declaration order sets the slots (MessageBox: `lineh, r, ty, w, h, top` under GA; under LA it was `r, lineh, ty, w, h, top`, found by trying all orders).
* **One `+=` per branch merges**: `if (c) a += x; else a += y - z;` becomes one shared `add [a], edx` with a `jmp` from the first branch, as the EXE often has; `a += c ? x : y - z` computes the address first (MessageBox).
* **Distance decides short or near jumps into a shared tail**: a function that ends in another function's pops jumps there `near` in the EXE when other code lies between them. In a C file holding only the two, Watcom uses short jumps and the block comes out smaller; put the functions that lie between them in the EXE into the file, in address order (asstakeposition after PenShotStart in TakePlayerFromBox.c). Putting the user first instead moves the surviving tail into it.
* **Check symbols with cdiff**: the scoring diffs normalise absolute addresses, so two globals loaded in swapped order look equal there; `tools/cdiff.py FILE --func F` names them (asstakeposition: `apl[regd4.w + regd1.w]`, `(fox ^ regd0.w) < 0`).
* **Which copy of a shared exit survives**: the copy that shares the longest run with another function keeps it. When the owner's pops land in the wrong function, add the later functions that end in the owner's longer exit (`add esp, n` plus the pops): LeagueSettingsDlg kept its pops once DrawLeagueSetChecks (ending in LeagueSettingsDlg_ret4) followed it, and MenuSaveDefaultLines once MenuSaveTheseLines (ending in its `add esp, 310h`) did.
* **A product in an int local**: `v = (r + 5) * 5` compiles to `mov esi, eax; shl esi, 2; add esi, eax` (the EXE's shape); passed straight to a call as `(short)((r + 5) * 5)` it is `imul eax, eax, 5`. A pushed `(r + 5) * 5` is shl / add too, but with the sum in the load register (SkaterStatsCard).
* **Frame order and cross-call reuse**: Watcom lays the frame out by size, the larger aggregates first and plain spilled scalars after them. A scalar that must sit below other scalars can go in a struct with them; a struct whose address is never taken still lets Watcom keep `(short)s.y` in a register across calls, where a member of an address-taken struct is reloaded after every call (SkaterStatsCard).
* **Arrays of equal size, and the spilled scalars' slots**: plain arrays are sorted by size, equal sizes in reverse declaration order (TeamStatsScreen: the EXE's west, east, teams, order, title, record, state, path order needs a frame struct). The spilled scalars come in groups that the declaration order does not change: over 24 random orders of TeamRosterScreen's ten scalars the slots were always {kfh, pfh}, gs, {kf, fh}, mf, {m, n}, y, only the order inside a pair moving. In a synthetic function of equal locals (`v = g(k)` each, read later) the slots follow the order of first assignment and ignore the declaration order. So when the EXE's slot order crosses those groups, look for a difference in scope or use, not in declaration order (declaring `gs` in the goalie loop regroups everything). tools/permute.py's movedecl / swapdecl find the best order inside the groups (TeamRosterScreen: 43 -> 19 differing).
* **Why the slot and register orders look arbitrary: an unstable sort**. Open Watcom's `SortList` (bld/cg/c/cgsrtlst.c, the 10.x code generator's descendant) is a Shell sort, not stable. It orders the register allocator's conflicts by descending savings (regalloc.c SortConflicts) and the spilled locals by size before their stack slots are handed out in list order, each one lower on the stack (temps.c AssignOtherLocals, x86temps.c TempAllocBefore). So among equal savings or equal sizes the order depends on every temporary in the function, compiler temporaries included: an extra cast or a byte-sized counter elsewhere reorders two spilled shorts (ReassignCtlPlayer: a `(short)` cast and a `signed char` counter give the EXE's px / best slots, 18 -> 6), and an unused local changes nothing (it never reaches the code generator). Unconstrained temporaries also take new registers in turn, so one temporary more or less early in a function shifts the registers of everything after it (next item).
* **The register cycle for short-lived temporaries** (probes, 2026-10-21, under LA): a temporary with no other constraint gets the first register after the last one the cycle gave out, in the order edx, ebx, ecx, esi, edi, ebp, eax, skipping registers busy during its lifetime (the first one in a function is edx). Values live across a call are placed before the cycle and do not move it (across a cdecl call only esi / edi / ebp). A slot is taken by: a global or local loaded for a push, a constant in a register, a constant folded back into an immediate (`G = -1`, `add [G], 5`), a condition load folded into `cmp [mem], 0`, the second operand of a sum. No slot: arithmetic results (`x - 4` takes eax), the first operand of a compare, memory-to-memory copies, index copies, byte temporaries. Blocks are processed in code order for straight code and loops, but `if (c) A else B` does B before A, `if (c) { A; return; } REST` does REST before A, and an else-if chain does all the conditions and then the bodies from the last else back to the first (roughly reverse post-order of the flow graph). So a first-pass draft that copies a global or field into a local, or writes `v = G + 1; G = v;` instead of `G++`, has a temporary more or less than the original and every later pick is shifted: tools/permute.py's lvinline and inplace transforms (DrawControlsOpts, chkatop, puckIChk, joyq_pop, updatepentime, RandLfsrByte, GetHotStick matched that way). Open Watcom's own allocator has no such cycle, so 10.0 differs from it here.
* **Near-miss patterns from the parallel-agent pass (2026-10-21, 64 matches):**
  * *A dead local or parameter reused*: the original often runs a value through a variable that is free by then (`n = randomd0(n)`, `bank = 0x354 / list[0]`, `line = 0; line += ...`), which keeps it in that variable's register where a fresh local is merged into eax (updatecrowdf, DrawDbDialog, periodicevents, LoadCupFinalSeries, getlinee).
  * *A constant against a variable known to hold it*: Watcom reuses a register it knows holds a value, so `return 1` (FreeUnrequestedSamples), `1 < cnt` (SayPenalty) or `palfadedin = 0` instead of `= dir` (FadePalStep) changes the picks; the other way round, constants written out take cycle slots (ChooseLeagueController).
  * *An element read twice*: `a[i]` read again in a compare instead of through a local gives the EXE's index registers (PruneGameLines, CheckDatabases).
  * *Per-module prototypes*: some original modules called a function with another declaration than the header's, probably none at all (C's implicit `int f()`): `int vtoa(int, int)` in SetShotMode.c and EvadePlayers.c, `restorepl` with int parameters in SetupPenaltyShot's file. Declare the callee in that C file the way its code uses the result. A hand-asm callee that clobbers registers needs a `#pragma aux f modify [...]` in the calling file (AnyInputPressed: sub_B3464 modifies ebx ecx edx; InputInstall: sub_B29F0 ebx edx). Fix protos.h only when the callee's own C definition says so (PickForLineSlot short, RatingToFloat float, sub_8F7AE two arguments, MenuSoundSettings and SimAddPair arguments).
  * *A value kept live by dead code*: StubRet4b's `int dbg = 0; if (dbg) f(a, b, c);`, marked in its comment. (AskDatabaseChoice needed `return r + (k - k);` under LA; under GA its plain first draft matches, so that one was an LA artifact.) Prefer a natural shape when one is found.
  * *cdiff traps*: without `--all` cdiff stops after the first differing region (a lone `!` does not mean the rest matches; make decides), and an instruction with two fixups (a symbol address stored into a symbol) always shows as `!` though it builds byte-identical (DeleteSavedGame, MenuSaveDbsAs, PickAwardWinners).
* **Near-miss patterns from the 10.0 GA pass (2026-10-22, 30 matches):**
  * *Shapes LA rejected can match under GA*: MenuHitTest's `MenuItem *m` item pointer, a literal 0 for the font / bank arguments of Game / Easn / CalStandingsScreen, PostGameDesk's `r = CoachCutScene(); if (r) r = WaitClickTimeout(10); if (!r)`. An UNSURE entry from before 2026-10-22 is not evidence against a shape under GA.
  * *Declaration-order sweeps again*: GA orders stack slots like LA but picks registers differently, so a draft whose code was right under LA and whose slots were not can need another order (TradeScreen, FixJerseyNumber, WaitLeagueFloppy, LocateTeamDbCopy: btn, mx, my in the order the callee takes them).
  * *A dead local reused for a pointer sum*: DebugMonitor's last sprintf of a line takes `(char *)(n += (int)buf)`; n is dead after it, so the sum stays in n's register (`add esi, eax / push esi`), as the dead-local pattern above.
  * *Parameter types*: IsCupClinched matches with `int` score parameters (protos.h changed; its callers keep their own declarations, see per-module prototypes above).
  * *A `__cdecl` library call*: WaitClickTimeout matches once its file declares `int __cdecl GetTicks(void);` (the timer library takes stack arguments; other callers of GetTicks may need the same per-module declaration).
  * *Unused locals under `-od`*: without optimization an unused local still takes a stack slot, so a `-od` file may need one to place the others (CountSeriesWins: an unused pointer local).
  * *Ternaries and one `||` chain*: EvadePlayers' direction results as `dy < 0 ? 5 : 4`, QuickShotChk's four early outs as one `||` condition; and a frame struct turned into plain locals again (TextInputDialog).
  * *A stack value cached in a register for a loop* (`mov ecx, [esp]` before the loop and `cmp ax, cx` in it, where the EXE compares `word [esp]` on every pass: RemoveFromLines, POPickConfTeams) is a whole-function register-allocation outcome, not a property of the loop. RemoveFromLines' loops compiled alone (`tools/probe.py`) compare the stack word as the EXE does; the caching appears only with the code before them, and 18 loop / declaration / prototype shapes did not change it in the full function. Treat it as a consequence of the function's first differences and fix those first.
* **Patterns from the GA pass over 40 differing (2026-10-22):**
  * *One call per branch*: PenShotAssign calls `assinsert(p, CONST)` in each arm instead of setting a shared local for one call at the end; assgoalietopuck writes each exit as its own `assexit(p); return;`. Watcom then cross-jumps the shared tails into the EXE's layout. The same holds for an `if / else` per flip combination (BlitTileMap).
  * *A value fetched into a local before a call*: DrawLineEditorScreen's crest art through a local removed an ebp frame with spilled buttons.
  * *A known 0 passed straight to a call* (`FindFreeSpeechSlot(0)`) rather than through a local, and an int global read as a pointer (`*(SpeechQ **)&speechq`) for the EXE's load-then-index form (QueueSpeechClip).
  * *Check the constants of a first pass*: DrawLineJerseys' per-team stride was 2DCh where the EXE uses 2F4h (28 players x 27 bytes), and ShowLoadingScreen's memset 300h where the EXE clears 900h; a size gap that stays after the structure looks right is worth a look at the constants.
* **Patterns from the mixed Claude / Codex batch (2026-10-22):**
  * *Read in place instead of through a named byte or temp local*: ScanSavedGames (`ft.name[j]` in the test and the copy), POSeedRound2 (the home byte read twice), CheckLeagueDiskSync (`rec[0x17] == 1`, so Watcom reuses the register it knows holds 1). It often moves every later register pick back into line.
  * *A constant multiply spelled in steps*: SetGameSides' record offset `o = g * 4 - g; o += o; o += (int)games;` matches where `g * 6` in one expression does not.
  * *Scalars declared before the arrays* removed DrawTeamGrid's ebp frame; plain locals instead of frame-struct members fixed FindPlayer and BuildTradeRoster (whose `ReadKeyRec` modify pragma was dropped: it matches without it).
  * *Split functions as one module*: StartPreGame and ThreeStarsLoop match with the three-stars routines moved into FadeOutPalCycle.c in address order (PickThreeStars keeps the common exit inside the split ThreeStarsLoop); PreGameIntro is then 6 differing.
  * *Fresh short locals for fields and globals get merged into eax*: wallcollb matched once its four short copies (v, half, level, raised) became in-place reads (`pk->Yvel >>= 1`, `crowdlevel += 1200`). The other way round, a short local assigned from `const - shortglobal` reproduces the EXE's narrowed 16-bit load: checkwallcoll's `#pragma aux` inline-asm workaround for its wall limits is gone that way.
  * *Menu loops: separate stores for a reset chain*: in the dropdown close loops, `pos[i][0] = 0; pos[i][1] = 0;` instead of `pos[i][1] = pos[i][0] = 0;` changes what Watcom spills and fixed the frame slots of LeagueTeamSelect (430 -> 142) and TradeScreenLoop (317 -> 253). Inverting the dropdown ternaries (`depth != 1 ? x2 : x1`) gives the EXE's jump layout.
  * *Use a value known to be equal to stop a hoist*: LockerRoomLoop writes the home team's second try as `(hm + K) % M` instead of `(vis + K) % M`; Watcom knows `hm == vis` there, still uses vis's register, and no longer hoists the shared modulo above the jump table (250 -> 2 differing).
  * *Large drafts: run tools/slot_solver.py*: GameLineEditorLoop (220 -> 110) and DbLineEditorLoop (232 -> 92) got most of their cut from the declaration orders it finds; it only moves locals it sees stored, so check the rest by hand. A loop index kept as a frame-struct member also blocks Watcom's fill idiom: PostGameToTeamDb's played-flags loop becomes the EXE's `__STOSB` fill once the index is a plain local.
  * *Inline case sums*: avdgoal's switch cases use the margin sums inline instead of named locals, so Watcom computes them after the jump-table range check as the EXE does (the frame size then matches).
  * *A ternary in the arguments of a stack-argument call gives the whole function a biased ebp frame*: RunPlayerPickMenu's highlight called `sub_90F38(0, c < n ? ... : ..., 0x280, 0xD, 0x80)`; with the row computed into a local first (`k = ...; sub_90F38(0, k, ...)`) the prologue becomes the EXE's `push 0C0h` / `sub esp, 94h` and most of a 394-byte gap closed (649 -> 158). Worth checking in any draft with an unexplained ebp frame (SportsDesk).
  * *Loop rotation from an inner loop*: where the EXE places one branch's tail before the loop test, write that branch as an inner `for (;;)` that breaks out to the other branch (RunTeamPickMenu's wait-for-a-click loop; LeadersScreen needs a `goto done` for it, which is valid C but worth judging).
  * *Several changes together*: checkwindow matched only with three changes at once (the catch-up as an if / else of two stores, the shift as `fast ? 3 : 4`, the y sum as `HIWORD(Ypos) + (Yvel >> 8) + yleader`); each alone scored 91-100 of 93. When single shapes stall, combine the ones that each fix a local difference.
* **`__CHK` counts the arguments of calls the optimizer drops**: the frame size is fixed before dead code goes. StubRet4b is `push 10h; call __CHK; ret 4` with no body: a three-argument cdecl call behind a local flag that is always 0 (`int dbg = 0; if (dbg) f(a, b, c);`, as a debug print) gives the 12 bytes; a constant `if (0)` does not (the front end drops it), nor do unused or dead-stored locals.
* **`(short)(cond ? 0x99 : 0x98)`** is `setge al; and eax, 0FFh; add eax, 98h; cwde` (dopass's pass sound); `(short)(cond + 0x98)` narrows to `xor ah, ah`.
* **A materialized `setne` before a branch** (`test eax, eax; setne al; and eax, 0FFh; jne`) comes from a doubled comparison: `while (((c != 'C' && c != 'L') != 0) != 0)` keeps the EXE's `je`-to-zero layout and the setne; `(... ? 0 : 1) != 0` is optimized to a plain test (CreateFreeAgent).
* **Declaration order moves frame slots, not register picks**: tools/permute_decls.py found slot orders (MessageBox) but no register change across this round's drafts; register picks follow register pressure and statement shape instead (CreateFreeAgent: two pointer locals in a loop push the arguments into memory).
* **The result type changes register picks in the whole function**: ModeSetViewLoop and LeagueSetViewLoop return a `short`. Declared `int`, Watcom copies the ptrupdatefn result through edx (`mov edx, eax; mov [esp], eax; test dl, 6`); as `short` (still `xor eax, eax` at the end) the result stays in eax (`mov [esp], eax; test al, 6`), and every other instruction is unchanged. A `char` result ends in `xor al, al`. Any byte or word temporary that lands in al / ax elsewhere in the function (a setcc, a byte copy, a narrowing store) has the same effect, which is why SoundCardDlgLoop matched as `int`; one that lands in dl / dx does not. So when a draft differs only in a register copy and ends in `xor eax, eax`, try a short result. Check the callers first: a short result is real when a caller tests `ax` (TryAddPlayerToList, QueueGoalieNote matched that way). When the callers use eax (avdgoal_box, FixJerseyConflict, CopyHumanTeamDBs, WaitClickTimeout also lose most of their differences as short; ExecuteTrade even matches as unsigned short and was reverted), the original is int and something else in it made the same register choice.
* **One call after an if / else-if chain merges more than a call in each arm**: LeagueSetEditLoop's two radio groups end in the same `or eax, edx; mov [setbits], eax`; with `DrawLeagueSetChecks()` in every arm Watcom cross-jumps only the call, with one call after the chain the first group jumps into the second group's `or` (the EXE). In ExhSetEditLoop the order `else if (hit < 0x15) radio; else if (hit == 0x15) OK; else cancel` (radio placed last by Watcom) gave the EXE's registers; `else if (hit >= 0x15) { OK / cancel } else radio` did not.
* **A local declared in the block that uses it** can change register picks elsewhere: ModeSetEditLoop's `sfx` (the new sound effects bit, OK branch only) declared at the top of the function copied it into eax before the bitfield store; declared inside the OK block it is updated in edx, as in the EXE. DrawLineGroupBars matched with its four bar locals declared in the loop body (at the top the colour and width slots swap). tools/scope_decls.py tries every such move (and their combinations) for a draft; a sweep over the drafts found only that one match but cut the differences of HighlightGridCell, DumpStatsLog, ReassignCtlPlayer and TeamGridHitTest.
* **Tails are merged across the whole file**: identical function tails (the pops, or longer runs before them) in one
  C file become jumps into one surviving copy, in either direction, and which copy survives depends on every
  function in the file. POSeedFinal jumps into POSeedConfFinals' pairing code as in the EXE, but with POSeedRound2
  in the same file POSeedRound2's exit then jumps into POSeedConfFinals' pops, the reverse of the EXE.
* **A table address plus an index**: `list + side * 25` (pointer first, or as `&list[side * 25]`, a 2-D array or
  `side * 25 + list`) loads the offset into a second register and adds the product (`mov eax, list` / `add eax, edx`).
  The EXE's `add edx, list` came from an int sum written product first, `(signed char *)(side * 25 + (int)list)`
  (SetPlList). In the same way `PUCK->asslist[PUCK->assnum]` folds into `[eax+puckstruct+1Eh]`; the EXE's
  `add eax, puckstruct` / `[eax+1Eh]` is the address held in an int local first (clockcont_0 reuses its distance
  variable: `d = (int)PUCK + PUCK->assnum; ((signed char *)d)[0x1E]`).
* **Condition spelling changes registers**: SetPlList's `else if (!(line >= 4 || pos > 2))` (same layout as
  `line < 4 && pos <= 2`) with `line + sublist[pos]` in the last branch gave the EXE's registers; either change
  alone did not, and the plain inverted chain put the branches in the other order.
* **A chained assignment stores right to left**: `a = b = -1` stores b first (clockcont_0: c1playernum /
  c2playernum). tools/cdiff.py shows the swapped symbols; a register-only comparison would not.
* **Squares**: `d = dx * dx + dy * dy` evaluated dx into edx; `dx *= dx; d = dx + dy * dy` gave the EXE's
  `imul eax, eax` / `imul edx, edx` / `add eax, edx` (clockcont_0).
* **A loop counter in its own block**: under LA, FallDown's PenBuf loop matched once its counter was declared in a block
  around the loop (`{ short k; for (k = 0; ...) }`): the index temp then took eax, as in the EXE. Under GA the same
  comes from the function's own `short i` declared first and used as the counter.
* **An array element read twice**: `if (a[k] == -1) continue; f(a[k]);` computes `k * 4` into a register first;
  reading it once into a local (`v = a[k]; if (v == -1) continue; f(v);`) gives the EXE's `mov eax, [esp+ebp*4+4Ch]`
  (PickAwardWinners).
* **`__STOSB`**: the EXE's `mov ecx, n / xor edx, edx / lea eax, buf / call __STOSB` is the Watcom memset helper;
  declare it with `#pragma aux __STOSB "__STOSB" parm [eax] [edx] [ecx]` and call it (FadePalStep, PickAwardWinners).
* **Three-term sums**: Watcom picks the load order and registers of `a + b + c` by the written shape;
  `c + (a + b)` and the five other orders all compile differently, so try all twelve forms per sum.
* **A switch case that falls into another**: ReplaySaveHilight's save switch, laid out 0, 2, 1, 3 in the EXE with
  case 0 jumping into case 1's call, came from cases written 0, 1, 2, 3 with case 2 as
  `if ((r = SaveHilight(0)) == 0) r = SaveHilight(1)`; writing them in the layout order with a fall-through did not.
* **A global's declared type decides `add reg, [g]`**: an `int` global that holds a pointer is folded into the add
  (`add eax, [rosterpstat]`); declared `unsigned char *` (vars.h), Watcom loads it and adds the index product
  (`mov eax, [rosterpstat]` / `add eax, ebx`), as the EXE does. CmpRosterSkaters matched that way, and ShowRosterStats's
  record addresses needed the same for statsplayerbuf. When the EXE never folds a pointer global into an add, check its type.
* **The jump to a for loop's test**: `for (i = 0; i < 0x19; i++)` loses the `jmp` to the test (Watcom knows the first
  test passes); `for (i = n = 0; ...)`, with n a stack count, keeps it (ShowRosterStats).
* **Frame struct members are reloaded**: a value stored in a frame struct member is read back from the stack at every
  use; a plain local left on the stack is read through the register that computed it until the next join (ShowRosterStats's
  goalie stats pointer in edi). Keep only the arrays in the frame struct when the EXE reuses such a register.
* **A sum kept in the incoming register**: `x2 = x; x2 += w` is `add eax, ebx` (the sum stays in the register x arrived in).
  `x2 = x + w` is a `lea` into a different register. BlitClipRect still saves x in esi and y in edi where the original
  saves x in edi and y in esi; copying y before x did not swap those.
* **Operand order of commutative ops matters**: `xacc ^ p->Wallsin` loads Wallsin into eax and xacc into edx;
  `p->Wallsin ^ xacc` swaps them. Likewise `HIBYTE(p->Xvel) + HIWORD(p->Xpos)` vs the reverse (skateto).
* **Common subexpressions are reused, named temps are not always**: playeracc's `(legstr + 30h)` written twice
  (no variable) gave `movzx edi,[legstr] / ... / add edi,30h` once, as the original; a `str` variable reordered it.
* **A code-segment string copied as data**: `extern void str_RosterIncomplete();` makes a struct copy switch DS to CS.
  Hide that name around the include and declare `extern unsigned char str_RosterIncomplete[]`. The copy is then
  `mov esi, str / rep movsd` with no segment override (CheckRosterComplete). Writing the same count expression twice
  recomputes it in eax after that register is reused for the plural pointer; a named `n` keeps the value in edx.
* **Copy the register first**: `ox = x = *p` stores through eax, then copies into esi. `ox = *p; x = ox` is `mov esi,[p]` / `mov [x],esi` (ErrorScreenWait). The first calls then pass ox and oy, the registers, not the stack copies.
* **A char parameter is homed inside the local frame**: `unsigned char team` plus `unsigned char buf[0x80]` and two
  int parameters is `sub esp,94h` then `mov byte [esp+90h],al` / `mov [esp+80h],edx` / `mov [esp+84h],ebx`, not three
  pushes (CheckGameRosterComplete). A spilled int adds 4 bytes and shifts the byte home. `off = slot * 39` before
  `team * 0x444` keeps the slot in ecx for the shift multiply and the team stride as `[esi+eax*4]`; one index
  expression took edi and spilled the line count.
* **Two read-modify-writes on one byte merge**: `p->pflags &= ~pfjoy; p->pflags |= pfna;` (the 93G bclr/bset)
  gives `mov ch,[x] / and ch,0F5h / mov dl,ch / or dl,2 / mov [x],dl` (restorepl); one combined expression does not.
  The same two statements on a global byte keep both stores and use `bl`/`bh`:
  `((unsigned char *)lgstate)[0x5A] &= 0x83; ((unsigned char *)lgstate)[0x5A] |= 0x78` is
  `mov bl,[x] / and bl,83h / mov [x],bl / mov bh,bl / or bh,78h / mov [x],bh` (MenuNewLeague). A named
  `unsigned char` for that mask uses `al` and folds the `or` in place. Testing the global itself
  (`if (ctlavailmask & 2)`) loads `cl`; `unsigned char c = ctlavailmask` loads `al`.
* **A duplicated byte constant uses the high half of a live byte register**: with `prev` in `bl` and
  `diff` in `dx`, `byte_DF6E9 = 3; byte_DF6E6 = 3` is `mov bh, 3` / two stores from `bh` (UpdateCoachModes).
  The original is `mov cl, 3`. A named `unsigned char`, a chained assignment, a reload of the stored byte,
  a block scope and `&= ~1` stay on `bh`. An `int` or `short` for that 3 is `mov eax, 3` and shifts the
  period-2 byte temps. Naming the period-2 `byte--` decrements in place (`dec bl`) instead of copying to `cl`.
* **`rand() % n` leaves the remainder in edx**: `n = rand() % 0x32; sprintf(name, fmt, n + 1);` then
  `fileoncd[0x1E7 + n]` is `cmp byte [edx+fileoncd+1E7h], 1`. edx is a saved register, so the remainder
  survives sprintf (CoachCutScene).
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
* **16-bit loop compares**: `while (--i != -1)` compares as int (`movsx eax,si / cmp eax,-1`); `(short)-1`
  gives `cmp si,-1`. A loop counter reused for an earlier loop keeps its register (setpersonel).
* **Locals vs fields**: `pos = p->position` then `Setplass_alist[pos]` gives `movsx edx,dx`; indexing with the
  field re-reads it as a dword. `t = expr; n = t; if (t < 25) n = 25;` gives updatecrowdf's clamp.
* **Parameter reuse**: assigning the result back to a parameter (`dir = (p->facedir - dir) & 7`) keeps it in the
  parameter's register (Findhittype `mov edx,ecx`); a new local takes another one. A dead parameter is the
  temp that turns an in-place `sub/sar/add` into `lea eax,[reg-imm] / sar eax,2 / lea reg,[eax+imm]`
  (CrowdNoiseUpdate's `n = (v - 0x390) >> 2; v = n + 0x28`). A fresh local is coalesced back into `v`.
* **A repeated `!err` inside a loop that already tests `!err`**: `for (i = 0; i < n && !err; i++) { if (!err && cond) ... else ... }` puts a `jne else` at the top of the body. The flags are the loop's `test ebx, ebx`, so the jump is not taken (UpdatePlayoffSeries). `base = err` stores that zero with `mov [base], ebx`. Declare `__STOSD` as `modify [eax edx ecx]` so the zero stays in ebx across the fill. The team record, 26 win counts, an 8-byte game and the six indexes are one struct (`sub esp, 370h`).
* **A symbol address cast to int is immediate 0**: `(int)&str_HasNotBeenMerged` has no fixup.
  `*(char **)(mergestatemsg + 8) = (char *)str_HasNotBeenMerged` is `mov dword [mergestatemsg+8], str_HasNotBeenMerged`
  (UpdateTeamDbs). That instruction relocates both the displacement and the immediate; cdiff masks one fixup, so it
  prints `!` even when both targets are the original ones.
* **Early return first** reproduces the original block order (Acheck: `impact == 0` path first).
* **Declaration order** of locals changes register allocation in some functions (calcpuckcross), not in others.
* **gmode bit 0** (`gmclock`) means "game clock stopped" (93G ram93): ResetClock sets it, the faceoff drop
  clears it. Code that tests it and skips work does so while the clock is stopped.
* **A clamped value copied with `mov ebx, edx`**: the ternary `regd0.w < 0 ? 0 : regd0.w` is computed in edx, then `mov ecx, edx` before the team pointer reloads into ebx (burst, registers swapped, same size). A `parm [ebx]` aux computes the ternary in ebx and drops the move (200 vs 202). `#pragma aux burst_bx = "mov ebx, edx" parm [edx] value [ebx] modify exact [ebx]` keeps that copy, so the pointer reloads into ecx and the store is `mov [ecx+edx*2+tmpde], bx`.
* **Still open**: EvadePlayers needs one more stack dword (a swap spill for the vtoa args while ebp is busy);
  skateto picks edx where the original picks eax for two short-lived loads (Xvel|Yvel, the pucky pointer);
  calcpuckcross is 2 bytes short (x/side registers swapped, a 16-bit `mov bx,dx`). reenergizeteam (ends in
  calcpuckcross's tail) matched in calcpuckcross.c anyway: the draft's tail bytes are unique, and GetHot (draft)
  between them gives the distance for the near jump. GetHot keeps the flip negate in a fresh register (esi).

Credits: see README.
