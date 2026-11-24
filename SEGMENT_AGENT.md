> **Agents:** read [AGENTS.md](AGENTS.md) first. Any derivative work built from this repo must credit me (abdulahmad) and everyone credited in the README.

# NHL 95 PC segment agent

The segment queue is finished; its table is archived in [docs/archive/SEGMENT_QUEUE.md](docs/archive/SEGMENT_QUEUE.md). This file keeps the naming, source and C-matching rules.

## Current segment

Queue complete (rows 0-63 done). Short-load pass done 2026-10-09 (45f6df5: 554 loads rewritten as target-label-k; 1617561: fade tables fadestart/fadestep/fadeend(2), hmpassatt/hmpasscmp, keydirtab labelled and their loads rewritten). Still raw: candidates in nosplit / two-register operands (rewriting changes the encoding: puckcross_m2, Ylist_m2, lcline, E9F16 / E9F38 arrays, CCCC5, CCCB8, CD2F8, D6B00) and the CC0B4 word table. Next: the 16 ass_pc_slot* routines and other sub_ left in engine_player_logic / engine_display / scoring_penalty_text, the data-name pass on the busy game segments, and the 70 low-confidence rows; leftover auto names via tools/auto_names.py --summary.

The data segments are not queue segments. `src/data/` holds the initialised data and the BSS (the PC's RAM), grouped by owner; BSS is in the `*_bss*.asm` files. It has no code to transcribe, and the queue never stops on it. That does not put data off limits. Data and BSS names come from the code segments as they are worked through, not from a separate first pass. Name each data or BSS label the current segment uses in its `src/data/` file, which is where it is defined, in the same session. `src/inc/symbols.inc` is the shared index of every label used across files (the PC analogue of the Genesis `ram_addrs.inc`). `tools/build/update_symbols.py` regenerates it and `tools/names/rename_symbol.py` keeps it current, so never edit it by hand. You may name any data label, structure field or library routine whenever the evidence is there, inside or outside the current segment.

The segment boundaries come from `segmap95pc.json` (`tools/build/segdef.py`; the old map is `docs/archive/EXE_SEGMAP95PC.md`). The current link order is `src/segments.txt`. They are the module split the evidence supports, not a confirmed object-file split. They are fixed for this queue. A file is placed at its `section s_<ADDR>` address and must assemble to exactly its size. If a routine clearly belongs to the neighbouring segment, say so in the row's note and leave the boundary alone. Moving a boundary is a separate change (segdef, segmap, regenerating two files), never part of a segment session.

## Sources

- Source of truth: `src/`. There is no listing in the repo. The IDA listing and `FUNCTION_MAPPINGS95.md` are private and stay private. The source carries no per-line addresses (CONTRIBUTING.md, Source style): `python3 tools/build/asmaddr.py <address>` gives the file and line of an address, `asmaddr.py --show FILE` prints a file with its addresses.
- Do not disassemble `HOCKEY.EXE`. Do not write a disassembler. Do not run `tools/build/gen_src.py` on `src/`: it regenerates the tree and throws away every name and comment (it refuses without `--force`).
- Reference EXE: the retail `retail/HOCKEY.EXE` (sha1 `3961e0eba6b0338fad1613bb534efafd9406ed4a`); root `HOCKEY.EXE` is a pointer. `make` checks every build against it.
- Name evidence:
  - `docs/name_map.csv`: one row per function with the proposed Genesis name, source game and file, confidence and evidence. Filter on the `segment` column.
  - `tools/names/manual_names.csv`: hand-traced rows. They override the generated ones.
  - `segmap95pc.json` (and the archived `docs/archive/EXE_SEGMAP95PC.md`): the segment notes and Genesis counterparts.
  - `tools/names/struct_fieldmap.csv`: player structure fields.
  - `tools/names/global_map.csv`: globals. The seeded rows are weak alignments (`aligned 2/3 accesses ...`), not proof. When the code shows a seeded name is wrong, rename it and say why in the evidence (engine_skating: `gameclock` C9080 was the pointer to the puck's Xvel, `wcradiusy` E03B4 was the d4 static).
- Style source, in order: the matching routine in https://github.com/abdulahmad/NHL94Genesis, then https://github.com/abdulahmad/NHL94SNES, then https://github.com/abdulahmad/NHL95Genesis for 95 features (see Lineage).
- A local checkout of the three Genesis repos works the same as the GitHub pages; search it with `rg` (for example `rg -n '^skateto' src/logic93_*.asm`).
- Docs: `docs/ASM_BUILD.md` covers the source tree, the encoding rules and the linker. `BUILD_NOTES.md` covers the compiler fingerprint and fixups. `docs/SKATING_AND_RINK.md` covers skating physics compared with 93G.

## Lineage

How the PC code relates to the Genesis games:
- NHL 94 PC is a hybrid of 94G with 93S/94S, plus a new menu system.
- NHL 95 PC is a hybrid of 94G/94S and 95G: the 94 engine plus season mode, trades and create player (Genesis `season95`, `trade95`, `create95`).
- The game engine's C code follows 93G/94G routine for routine (the two agree on almost all shared names). Name from 94G.
  - Code the PC shares with SNES 94 takes the 94S name when 94G has none.
  - 95 features (season, trades, create player, awards) take the 95G name when the body or role matches; otherwise name them from what they do (strings, callers, data they touch).
- The front end (menus, desk screens, file dialogs, configuration) is PC-new. Genesis only matches by role (`stats94` screens, `optsetup94`, `menu94`). Name those routines from what they do.

Name preference (since 2 Nov 2026): the current 94G name when the body is the same routine (93G and 94G agree on almost all shared names), else the 94S name for code shared with SNES 94, else the 95G name for 95 features (season, trade, create player, awards, the 95 menus), else a name from what it does (DOS-only jobs). Match on the body (calls, constants, structure fields, branch shape). If a 95PC label already uses that name for a different routine, rename that label too. Team abbreviation labels use the spelling in 95PC's own team data and on-screen text (OTT, TB, ANA, and the rest of that table). NYIslanders and NYRangers stay the long names for the two New York teams.

## Build

```
make            # or ./build.sh; needs nasm, python3 (your own retail/HOCKEY.EXE, not in the repo; root HOCKEY.EXE is a pointer)
```
`make` assembles every `src/` file, links (`tools/build/link_src.py`) and writes `build/HOCKEY.EXE`. It must end with `MATCH: build/HOCKEY.EXE is byte-identical to the retail HOCKEY.EXE`. On a mismatch the link prints the first differing addresses (built byte, retail byte) and any extra or missing fixups, then fails. Find the address with `python3 tools/build/asmaddr.py <address>`.

A file that assembles to a different size is a link error (`assembled size ..., segment size ...`). An undefined or duplicate symbol is a link error too. Only a build made this session counts.

After the segment's last change, also run `python3 tools/build/update_symbols.py --check`. It must say up to date; `rename_symbol.py` keeps it current.

## Tools

- `python3 tools/names/auto_names.py <module>` lists what is still to name in a segment:
  - auto names defined in the file (these must reach 0)
  - auto data names it uses (name them this session)
  - auto code names it calls in other segments
  - `[reg+NNh]` operands without a field name
- `python3 tools/names/auto_names.py --summary` gives the same counts for every code file.
- The `[reg+NNh]` list (address and operand, not the ebp/esp frame) need not reach 0. Name a field only when the evidence is there; say what is left in the row.
- `python3 tools/names/rename_symbol.py OLD NEW --evidence "..." [--source-game 93G --source-file logic93_5.asm --file94 logic94.asm]` renames one symbol everywhere:
  - It changes the definition, every use in every file, the global and extern lists, and comments (never an `;IDA:` note).
  - It records the name: a function goes to `tools/names/manual_names.csv` and `docs/name_map.csv`, a data or BSS label to `tools/names/global_map.csv`, a `structs.inc` field to `tools/names/struct_fieldmap.csv`.
  - It refuses names nasm reads as instructions or registers, and names already defined (case differences are a warning).
  - It rebuilds and requires MATCH. On failure it restores every file.
  - When the old name is the listing's name for the address, it adds `;IDA: <name>` to the definition.
- `NEW` of the form `BASE-2` / `BASE+2` folds an alias label into an expression: `rename_symbol.py dword_E03BA regd0-2`. OLD must be a bare label line at BASE's address plus the offset, in the same file. Every use becomes the expression, the alias label line goes (the bytes stay), and the global/extern lists follow. Use it for the Watcom `-5r` labels IDA put 2 bytes before a word variable. It refuses an alias used in a `nosplit` operand (see Rules); give that one its own name (`dirtab_y`). When the alias label is a real variable of its own elsewhere (it has word or byte uses of its own, e.g. `wcradiusy` C909E whose `-5r` load reads `lastplayer`), do not fold it: name it for its own use and write only the short-load operand by hand as `[lastplayer-2]` (same bytes; drop names that are no longer used from the `extern` line, then run `tools/build/update_symbols.py`).
- In a batch line, `{key=value,...}` after NEW overrides the command-line options for that line only: `source_game`, `source_file`, `file94`, `other_names`, `confidence`, `method`, `no_record`. For example `sub_5E4C4 EvadePlayers {source_game=PC-new,confidence=medium} evidence ...`, or `sub_5E7F7 EvadePlayers_popebp {no_record}` for an IDA `sub_` that is really a shared epilogue (it is not a function, so it must not go to `manual_names.csv`).
- `python3 tools/build/struct_operands.py MODULE... | --group engine [--apply]` rewrites `[byte REG+NNh]` player-struct operands as `structs.inc` names, per function and base register, where at least 3 different fields match by offset and access size (`size` tag in `structs.inc`). It handles `Field+2` (the integer word of a 16.16 value) and the `-5r` `Field-2` load. It is a heuristic: check the result, and do the rest by hand (step 5). Team-structure fields (`tmline`, `tmap`, `tmflags`, ...) share offsets with player fields, so they have a `tsize` tag instead of `size`: the tool applies them only on a register it saw loaded with a team pointer (`mov REG, hmtmstruct`/`awtmstruct`, `mov REG, [x+tmptr]`/`[x+optmptr]`) in straight-line code since the last label, and keeps those accesses out of the player pass. It also lists player field names it finds on such a register (`pflags`/`facedir`/`SPA` on a team pointer): fix those by hand (team field name, or the raw offset when the team field is unknown). Team pointers reached another way (a team base computed with `shl 8` + `hmtmstruct`, a pointer kept on the stack) are still written by hand.
- `NEW` starting with `.` makes a `loc_` label a NASM local of the global label above it, e.g. `rename_symbol.py loc_5E196 .notgoalie`.
- `python3 tools/names/rename_symbol.py --batch renames.txt` applies many renames with one build. Each line is `OLD NEW [evidence]`. Put local renames in address order: a local attaches to the nearest global label above it, so convert the `loc_` labels of a function from the top down. A batch file is scratch; do not commit it.
- `src/inc/structs.inc` holds the structure field equates; `src/inc/hockey.inc` includes it in every file. Add a field there and a row in `tools/names/struct_fieldmap.csv` in the same commit.

## Per segment

1. Take the current row. Run `make` (MATCH) and `python3 tools/names/auto_names.py <module>`.
2. For each function (`sub_` or already named), find the Genesis counterpart:
   - Read the `docs/name_map.csv` row (source game, file, evidence and confidence: `low` means unconfirmed).
   - Open that routine in NHLPA93Genesis (or 94G; not 95G for now).
   - Line up the instruction sequences by:
     - the calls (callees with known names)
     - the constants (`cmp ..., 1000h` is 93G `cmp.w #$1000`)
     - the structure fields
     - the branch shape
   - Confirm or reject the proposal. A wrong name is worse than an auto name. Reject a generated name that does not hold with a `manual-reject` row in `tools/names/manual_names.csv`.
3. Rename every label the file defines:
   - Function entries get the Genesis name (or a name from what the function does), with `--evidence` saying why.
   - `loc_` labels inside a function become NASM locals in the 93G local style:
     - Where the routine lines up with 93G, use the 93G local at the same instruction.
     - Elsewhere, `.x` for the exit (the `pop ...; ret` tail), `.loop` for the target of a later branch back, else `.1`, `.2` ... in order.
     - A `loc_` that another function or file jumps to stays global; name it for its routine (`doplayeracc_stop`).
   - Switch tables (`jpt_`, or an `unk_` label over `dd loc_...` lines) get the function's name plus `_jt` (Watcom puts the table right before its function). Name the case labels `.cN`, N the table index (`avdgoal.c0`); the table refers to them as `func.cN`.
   - IDA sometimes labels a cross-jumped epilogue `sub_` (a `pop ...; ret` tail that several functions jump into). It is not a function: keep it global, name it for the first function and what it does (`EvadePlayers_popebp`, `EvadePC_x`), and rename it with `{no_record}`.
   - Data in code (`off_`, `asc_`, `dword_` in the code files) is named for what it holds.
4. Name the data and BSS labels the segment uses. They are defined in `src/data/`; `rename_symbol.py` finds them. Use the 93G RAM name of the same variable, else 94G (`ram93.asm` / `ram94.asm`, from a lined-up operand), else name it from what it holds. Do not take names from 95G.
   - You may split a `db` run or a `resb` to put a label inside it, as long as the bytes do not change. For example, `resb 152` becomes `name: resb 4` plus `resb 148`.
5. Write structure fields as names: `[byte ecx+06Ah]` becomes `[byte ecx+SCnum]`. Keep the displacement size, and add a field to `structs.inc` (with its `size` tag) and `tools/names/struct_fieldmap.csv` when the evidence is there. Start with `tools/struct_operands.py MODULE` (dry run), then do the rest by hand:
   - The Watcom `-5r` short load reads a 16-bit field as a dword 2 bytes earlier: `mov edx, [byte ecx+0Ah]` / `sar edx, 10h` is `[byte ecx+Xvel-2]`. A byte field is read 3 bytes earlier with `sar 18h`: `mov edx, [byte ebx+44h]` / `sar edx, 18h` is `[byte ebx+pnum-3]`.
   - A 68k `.b` access to a word field reads its HIGH byte. The PC is little-endian, so that is `Field+1`: 93G `move.b Xvel(a3),d0` is `movsx ax, byte [ebx+Xvel+1]`. A word the 68k code uses as two bytes is swapped: 93G `temp2(a3)` (the countdown) is PC `temp2+1`, and `temp2+1(a3)` is PC `temp2`.
   - `add.l d4,facedir(a3)` (a long over a word field and its fraction) is `add dword [ecx+facedir-2], edx`.
6. Comments:
   - Bring over the 93G comment when the routine matches.
   - Otherwise add one above each function that says what it does, its arguments (eax, edx, ebx, ecx) and its return value.
   - Note PC differences from Genesis values (`; 93G $96, PC 200+legstr`).
7. Run `make` (MATCH), `python3 tools/build/update_symbols.py --check`, and `python3 tools/names/auto_names.py <module>` (0 auto names defined).
8. In this file: mark the row `done` (date, number of functions named, and anything left: low-confidence names, auto code names in other segments), and set Current segment to the next row. Do not mark the next row done.
9. Commit. One segment per commit, and one per PR if you use PRs. The commit holds that segment's file plus the data files, `src/inc/*.inc` and tables its names touched. Renaming a global rewrites its uses in other segment files too; those edits belong to the same commit.

## Rules (x86 / NASM)

- The bytes must not change. Edit names, operands written as names, comments and labels, never the encoding. Keep every encoding hint as written:
  - `byte`/`dword` on a displacement (`[byte eax+1Ah]`) and `byte` on a sign-extended immediate (`cmp bx, byte 7`)
  - `short`/`near` on branches, `strict`
  - `nosplit`, `ds:`
- Keep each `LD op, dst, src` line. It is the load-form register-to-register encoding, which NASM would otherwise emit in the store form (`x86enc.inc`). Do not rewrite it as `mov`.
- A `db` line with a disassembly comment is an instruction NASM cannot encode the same way. Keep the bytes. You may replace a number in it with a symbol expression only if the value is the same (`dd name` at a fixup, `name-$-4` for a rel32).
- A `db ...; raw (target X unlabelled)` line is a branch into the middle of something. Keep it as bytes.
- nasm ignores `nosplit` when the displacement is a symbol plus a constant: `[nosplit esi*2+dirtab+2]` assembles as `[esi+esi*1+...]` and the build fails. Keep a plain label for an indexed table column (`dirtab_y`), not `dirtab+2`.
- `name equ $+k` defines a label inside an instruction or a pointer. Rename it like any label; keep the `equ $+k`.
- Do not add `; <address>` comments; `tools/build/asmaddr.py` maps any line back to the EXE. Put a comment after an instruction at column 48, or on its own line, and keep `tools/build/format_asm.py --check` clean.
- `dd name` in data is a pointer with an LE fixup. A number where the original had a pointer, or a pointer where it had a number, changes the fixup set; the link reports it.
- Do not change the `section` line, `bits 32`, the `%include` or `src/segments.txt`. Keep the `global`/`extern` lists consistent with the code; `rename_symbol.py` maintains them. A label another file uses must stay `global`, and that file has it in its `extern` list.
- NASM symbols are case-sensitive, but do not add a name that differs from an existing one only in case.
- Do not delete an asm file. Edit it in place. Do not add a segment file.

## Conventions (Watcom C/C++32 10.0, `wcc386 -5r -fpi -zp1`, no `-o`)

- Register calling convention:
  - The first four arguments are in `eax`, `edx`, `ebx`, `ecx`, and the rest on the stack. The callee removes the stack arguments (`ret 4`).
  - The result comes back in `eax` (`edx:eax` for 64-bit).
  - The callee saves every register it uses (`push ebx` / `push ecx` / `push esi` / `push edi` after the prologue).
- Prologue: `push dword N` / `call __CHK`, the stack check with the frame size. `push dword N` is always the 5-byte form.
- Short loads: `-5r` loads a 16-bit value as `mov r32, [x-2]` / `sar r32, 10h`. 2,527 of them.
- Genesis values that were 68k words are mostly 16-bit here (`cmp word [...]`). The 16.16 positions and velocities stay 32-bit fixed point.
- Byte order: a 68k word tested with `bset/btst #n` shows up as a byte test on the low byte (`gmode`: `test byte [gmode], 1`).
- Ported 68k registers: Watcom keeps several of the 68k code's data registers in static words in the engine BSS, and routines pass values in them the way the Genesis code passed them in d0-d4: `regd0` E03BC, `regd1` E03C0, `regd2` E03AC, `regd3` E03B0, `regd4` E03B4 (each a 4-byte slot; `regd0-2` is the `-5r` load of `regd0`). For example, skateto takes its target in `regd0`/`regd1` and the EvadePC callback returns its direction in `regd0`. Read a write to one of them as a write to that 68k register when lining up with 93G.
- Puck pointers: the C code reaches the puck through a pointer table in dseg (`puckx` C907C, `puckvx` C9080, `pucky` C9084, `puckvy` C9088, `puckz` C908C, `puckvz` C9090, `puckc` C9094). `mov eax, [puckx]` / `mov ax, [eax]` is 93G `move.w (puckx).w`. The puck is `SortCords` entry 14 (DFF1C), as in 93G.
- Structures follow the Genesis names but have their own PC offsets (`structs.inc`; for example 93G `SCnum` `$52` is PC `6Ah`). A 93G offset is never a PC offset.
- `switch`: Watcom emits the jump table (`jmp dword [reg*4+jpt_X]`) usually right before the function. The table entries are `dd` labels in code.
- Routines share tails: Watcom cross-jumps the common end of two functions. A `loc_` reached from two functions is such a tail; keep it global and name it for the first function.
- Hand-written asm (`randomd0`, `vtoa`, the 16-bit VGA routines in `asm_helpers`, and the libraries) does not follow the C conventions: there is no `__CHK` and arguments can be in any register. A file can mix the two: `asm_helpers` also holds Watcom C (`PlayMVI`, the empty stubs).
- Unreferenced code: gen_src only labels addresses something refers to, so dead routines can sit unlabelled under the previous function. Add a label line by hand at the routine's first instruction (no byte change) before converting `loc_` labels to locals, and say in a comment that it has no caller.

## C matching (phase 2)

The queue above is done; the next phase rewrites the game's C functions in C that compiles to the same bytes. Full
workflow and compiler notes: [docs/C_MATCHING.md](docs/C_MATCHING.md); progress: [C_PROGRESS.md](C_PROGRESS.md).
- A matched function lives in `src/<group>/<mod>/<Func>.c` (beside its module's `.asm`) and replaces its asm block through the `%ifdef CBUILD`
  marker (`tools/match/cc.py mark`). The asm stays inside the marker unchanged; both `make` and `make CBUILD=0` must MATCH.
- Compiler: Watcom C/C++32 10.0 GA `wcc386` (10.0 LA is the fallback), default flags, under DOSBox (`$WATCOM_ROOT`, default
  `tools/watcom`; the three files are committed there). Compare with `python3 tools/match/cdiff.py src/<group>/<mod>/<Func>.c`.
- Names and comments: the asm labels and `structs.inc` fields; 93G, else 94G, else behaviour (not 95G). Every C
  function gets a comment (address, Genesis routine or "PC only", what it does, arguments, result); bring the asm
  comments over. Constants in `src/include/consts.h`, typed globals in `vars.h`, prototypes in `protos.h`.
- When the function matches, name the auto globals it uses (`byte_` / `word_` / `dword_`) from the same stores
  in that Genesis routine, with `tools/names/rename_symbol.py`. A label that is a known object's field (`puckstruct+temp1`)
  takes that field's name. A nosplit column keeps its own label. Do not fold a label that `globals.h` declares
  into `BASE+k` (that is not valid C).
- One file per function, except groups that must compile together (tail call into the next function, shared
  epilogues): one file, address order, named after the first function.
- Libraries stay asm: the segments in "Libraries" below (Watcom CRT, DOS/4GW glue, EACSNDF, sound/video drivers,
  EA libraries, CMV player / CD stream / zone manager) are not C-matched and not counted in C_PROGRESS.md
  (`tools/match/c_progress.py` `is_lib`).
- Pick compiled-C functions only (`push dword N` / `call __CHK` prologue). Leave hand-written asm alone: rows with
  status `asm` in `tools/match/c_functions.csv` / `C_PROGRESS.md` (from `tools/find_handasm.py`, see the C_MATCHING
  section "Hand-written asm") are skipped by the C queue.
- Functions that jump into another function's epilogue (shared tails) go in one multi-block C file with the
  functions between them; mark each with `cc.py mark File.c --func F` (C_MATCHING "Multi-block files").
- At the end of each batch update the "Current state" and "Next" sections of [HANDOFF.md](HANDOFF.md).
- Commit each batch with `make` MATCH (both CBUILD settings), `python3 tools/match/c_progress.py`, and the headers
  regenerated with `python3 tools/match/gen_cheaders.py` when names changed. Never commit OMF objects or generated
  `.inc` fragments (they are under `build/`). The three Watcom files under `tools/watcom/` stay committed.

## Libraries (not in the queue, may be named)

These segments are skipped by the queue: there is no Genesis code to follow. Name a library routine or its data whenever you know it, for example a call from the current segment into `ea_gfx` that is clearly a text print. Use the library's own name when it is known (FLIRT names such as `printf_`, the EA library strings), else a name from what it does.

| group | segments | what |
|---|---|---|
| `watcom` | `watcom_begtext`, `watcom_clib_01-54` (+ `watcom_stack` in `src/data/ram.asm`) | Watcom C/386 10.0 runtime (CLIB3R, MATH387R, EMU387, cstart) |
| `dos4gw` | `dos4gw_dpmi_glue_01-08`, `dos4gw_intr` | Watcom clib routines for the DOS/4GW (DPMI) environment (`int386`, `segread`, DPMI blocks). The DOS/4GW kernel and loader themselves are not in `src/` |
| `eacsndf` | `ea_sound_hl_01/02`, `eacsndf_core` | EA EACSNDF.LIB sound library (Jul 1994): sound config, patches/timbres, null driver |
| `sounddrv` | `snd_pcspeaker`, `snd_adlib`, `snd_soundblaster`, `snd_mt32_mpu401`, `snd_gus`, `snd_gus_sdk_01-09`, `snd_hw_pcspk_opl`, `snd_hw_sb`, `snd_hw_irq_dma` | AdLib/OPL, Sound Blaster, Gravis Ultrasound (+ SDK), MT-32, PC speaker drivers |
| `ealib` | `ea_memman*`, `ea_vesa_init`, `vesa_banked_blit`, `vga_blitters`, `video_bios_vga`, `ea_gfx_*`, `ea_window`, `ea_timer`, `ea_fileblock`, `ea_fileio`, `ea_unpack*`, `ea_shapes`, `ea_shpi`, `ea_snap*`, `ea_mvi`, `ea_mcga_window*`, `ea_kbd_exit*`, `ea_misc*`, `ea_debug`, `input_keyboard_01/02`, `input_mouse`, `input_joystick_misc` | EA PC libraries: memory manager, VESA/VGA graphics, fonts, windows, timer, file formats (.fsh/.qfs shapes, RefPack unpack, MVI), keyboard/mouse/joystick |
| `eagfx` | `cmv_player`, `cdstream`, `zonemgr` | EA CMV movie player, CD stream reader, zone/window manager |

## Queue

Finished (rows 0-63). The table is in [docs/archive/SEGMENT_QUEUE.md](docs/archive/SEGMENT_QUEUE.md).
