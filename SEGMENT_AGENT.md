# NHL 95 PC segment agent

This file is the queue. Do not rewrite it as a whole file. Edit the current row in place. Do not append a history entry.

## Current segment

`engine_assign_faceoff`, `src/cseg01/039_50AFE_engine_assign_faceoff.asm`, `50AFE-53293` (10134 bytes). Watcom C. 93G logic93_4 puckfaceoff/puckfaceoff2/asspassrec, logic93_1 check4bench, 94G onetimer94 assonetimer 50B55.

The data segments are not queue segments. `src/dseg02/*.asm` holds the initialised data and the BSS, the PC's RAM. It has no code to transcribe, and the queue never stops on it. That does not put data off limits. Data and BSS names come from the code segments as they are worked through, not from a separate first pass. Name each data or BSS label the current segment uses in its `src/dseg02` file, which is where it is defined, in the same session. `src/inc/symbols.inc` is the shared index of every label used across files (the PC analogue of the Genesis `ram_addrs.inc`). `tools/update_symbols.py` regenerates it and `tools/rename_symbol.py` keeps it current, so never edit it by hand. You may name any data label, structure field or library routine whenever the evidence is there, inside or outside the current segment.

The segment boundaries come from `segmap95pc.json` (`tools/segdef.py`, `EXE_SEGMAP95PC.md`). They are the module split the evidence supports, not a confirmed object-file split. They are fixed for this queue. A file is placed at its `section s_<ADDR>` address and must assemble to exactly its size. If a routine clearly belongs to the neighbouring segment, say so in the row's note and leave the boundary alone. Moving a boundary is a separate change (segdef, segmap, regenerating two files), never part of a segment session.

## Sources

- Source of truth: `src/`. There is no listing in the repo. The IDA listing and `FUNCTION_MAPPINGS95.md` are private and stay private. Every instruction line ends with `; <address>`, which is the address in the EXE. Search `src/` for an address to find its line.
- Do not disassemble `HOCKEY.EXE`. Do not write a disassembler. Do not run `tools/gen_src.py` on `src/`: it regenerates the tree and throws away every name and comment (it refuses without `--force`).
- Reference EXE: your retail `HOCKEY.EXE` in the repo root (sha1 `3961e0eba6b0338fad1613bb534efafd9406ed4a`). It is never committed. `make` checks every build against it.
- Name evidence:
  - `name_map_94.csv`: one row per function with the proposed Genesis name, source game and file, confidence and evidence. Filter on the `segment` column.
  - `tools/manual_names.csv`: hand-traced rows. They override the generated ones.
  - `EXE_SEGMAP95PC.md` and `segmap95pc.json`: the segment notes and Genesis counterparts.
  - `tools/struct_fieldmap.csv`: player structure fields.
  - `tools/global_map.csv`: globals. The seeded rows are weak alignments (`aligned 2/3 accesses ...`), not proof. When the code shows a seeded name is wrong, rename it and say why in the evidence (engine_skating: `gameclock` C9080 was the pointer to the puck's Xvel, `wcradiusy` E03B4 was the d4 static).
- Style source: the matching routine in https://github.com/abdulahmad/NHLPA93Genesis (`src/logic93_*.asm`, `hockey93_*.asm`, `penalty93_*.asm` ...). Use https://github.com/abdulahmad/NHL94Genesis for what 94 added. Use https://github.com/abdulahmad/NHL95Genesis (listing `lst/nhl95.bin.lst`) for what 95 added.
- A local checkout of the three Genesis repos works the same as the GitHub pages; search it with `rg` (for example `rg -n '^skateto' src/logic93_*.asm`).
- Docs: `docs/ASM_BUILD.md` covers the source tree, the encoding rules and the linker. `BUILD_NOTES.md` covers the compiler fingerprint and fixups. `docs/SKATING_AND_RINK.md` covers skating physics compared with 93G.

## Lineage

How the PC code relates to the Genesis games:
- NHL 94 PC was ported from NHLPA 93 Genesis, plus some NHL 94 Genesis additions and a new menu system.
- NHL 95 PC is NHL 94 PC plus NHL 94 and 95 Genesis additions: season mode, trades and create player (Genesis `season95`, `trade95`, `create95`).
- The game engine's C code mostly follows 93G, routine for routine. Look there first.
  - Use 94G for one-timers, breakaways, the extra assignment slots (asstab slots 30 and up) and `doinput_ispc`.
  - Use 95G for the season code.
- The front end (menus, desk screens, file dialogs, configuration) is PC-new. Genesis only matches by role (`stats94` screens, `optsetup94`, `menu94`). Name those routines from what they do.

Name preference: a 93G name when the body is the same routine, else the 94G name, else the 95G name, else a name from what it does. This is the same order `tools/matcher.py` uses.

## Build

```
make            # or ./build.sh; needs nasm, python3 and your HOCKEY.EXE in the repo root
```
`make` assembles every `src/` file, links (`tools/link_src.py`) and writes `build/HOCKEY.EXE`. It must end with `MATCH: build/HOCKEY.EXE is byte-identical to the retail HOCKEY.EXE`. On a mismatch the link prints the first differing addresses (built byte, retail byte) and any extra or missing fixups, then fails. Find the address in the `; <address>` comments.

A file that assembles to a different size is a link error (`assembled size ..., segment size ...`). An undefined or duplicate symbol is a link error too. Only a build made this session counts.

After the segment's last change, also run `python3 tools/update_symbols.py --check`. It must say up to date; `rename_symbol.py` keeps it current.

## Tools

- `python3 tools/auto_names.py <module>` lists what is still to name in a segment:
  - auto names defined in the file (these must reach 0)
  - auto data names it uses (name them this session)
  - auto code names it calls in other segments
  - `[reg+NNh]` operands without a field name
- `python3 tools/auto_names.py --summary` gives the same counts for every code file.
- The `[reg+NNh]` list (address and operand, not the ebp/esp frame) need not reach 0. Name a field only when the evidence is there; say what is left in the row.
- `python3 tools/rename_symbol.py OLD NEW --evidence "..." [--source-game 93G --source-file logic93_5.asm --file94 checks94.asm]` renames one symbol everywhere:
  - It changes the definition, every use in every file, the global and extern lists, and comments (never an `;IDA:` note).
  - It records the name: a function goes to `tools/manual_names.csv` and `name_map_94.csv`, a data or BSS label to `tools/global_map.csv`, a `structs.inc` field to `tools/struct_fieldmap.csv`.
  - It refuses names nasm reads as instructions or registers, and names already defined (case differences are a warning).
  - It rebuilds and requires MATCH. On failure it restores every file.
  - When the old name is the listing's name for the address, it adds `;IDA: <name>` to the definition.
- `NEW` of the form `BASE-2` / `BASE+2` folds an alias label into an expression: `rename_symbol.py dword_E03BA regd0-2`. OLD must be a bare label line at BASE's address plus the offset, in the same file. Every use becomes the expression, the alias label line goes (the bytes stay), and the global/extern lists follow. Use it for the Watcom `-5r` labels IDA put 2 bytes before a word variable. It refuses an alias used in a `nosplit` operand (see Rules); give that one its own name (`dirtab_y`). When the alias label is a real variable of its own elsewhere (it has word or byte uses of its own, e.g. `wcradiusy` C909E whose `-5r` load reads `lastplayer`), do not fold it: name it for its own use and write only the short-load operand by hand as `[lastplayer-2]` (same bytes; drop names that are no longer used from the `extern` line, then run `tools/update_symbols.py`).
- In a batch line, `{key=value,...}` after NEW overrides the command-line options for that line only: `source_game`, `source_file`, `file94`, `other_names`, `confidence`, `method`, `no_record`. For example `sub_5E4C4 EvadePlayers {source_game=PC-new,confidence=medium} evidence ...`, or `sub_5E7F7 EvadePlayers_popebp {no_record}` for an IDA `sub_` that is really a shared epilogue (it is not a function, so it must not go to `manual_names.csv`).
- `python3 tools/struct_operands.py MODULE... | --group engine [--apply]` rewrites `[byte REG+NNh]` player-struct operands as `structs.inc` names, per function and base register, where at least 3 different fields match by offset and access size (`size` tag in `structs.inc`). It handles `Field+2` (the integer word of a 16.16 value) and the `-5r` `Field-2` load. It is a heuristic: check the result, and do the rest by hand (step 5). It knows only the player structure. Team-structure fields (`tmline`, `tmap`, `tmflags`, ...) on a register loaded from `[reg+tmptr]` / `[reg+optmptr]` share offsets with player fields, so they have no `size` tag and are written by hand; a register loaded that way and named `pflags`/`temp3`/`facedir` is a mistake to fix.
- `NEW` starting with `.` makes a `loc_` label a NASM local of the global label above it, e.g. `rename_symbol.py loc_5E196 .notgoalie`.
- `python3 tools/rename_symbol.py --batch renames.txt` applies many renames with one build. Each line is `OLD NEW [evidence]`. Put local renames in address order: a local attaches to the nearest global label above it, so convert the `loc_` labels of a function from the top down. A batch file is scratch; do not commit it.
- `src/inc/structs.inc` holds the structure field equates; `src/inc/hockey.inc` includes it in every file. Add a field there and a row in `tools/struct_fieldmap.csv` in the same commit.

## Per segment

1. Take the current row. Run `make` (MATCH) and `python3 tools/auto_names.py <module>`.
2. For each function (`sub_` or already named), find the Genesis counterpart:
   - Read the `name_map_94.csv` row (source game, file, evidence and confidence: `low` means unconfirmed).
   - Open that routine in NHLPA93Genesis (or 94G or 95G).
   - Line up the instruction sequences by:
     - the calls (callees with known names)
     - the constants (`cmp ..., 1000h` is 93G `cmp.w #$1000`)
     - the structure fields
     - the branch shape
   - Confirm or reject the proposal. A wrong name is worse than an auto name. Reject a generated name that does not hold with a `manual-reject` row in `tools/manual_names.csv`.
3. Rename every label the file defines:
   - Function entries get the Genesis name (or a name from what the function does), with `--evidence` saying why.
   - `loc_` labels inside a function become NASM locals in the 93G local style:
     - Where the routine lines up with 93G, use the 93G local at the same instruction.
     - Elsewhere, `.x` for the exit (the `pop ...; ret` tail), `.loop` for the target of a later branch back, else `.1`, `.2` ... in order.
     - A `loc_` that another function or file jumps to stays global; name it for its routine (`doplayeracc_stop`).
   - Switch tables (`jpt_`, or an `unk_` label over `dd loc_...` lines) get the function's name plus `_jt` (Watcom puts the table right before its function). Name the case labels `.cN`, N the table index (`avdgoal.c0`); the table refers to them as `func.cN`.
   - IDA sometimes labels a cross-jumped epilogue `sub_` (a `pop ...; ret` tail that several functions jump into). It is not a function: keep it global, name it for the first function and what it does (`EvadePlayers_popebp`, `EvadePC_x`), and rename it with `{no_record}`.
   - Data in code (`off_`, `asc_`, `dword_` in cseg01) is named for what it holds.
4. Name the data and BSS labels the segment uses. They are defined in `src/dseg02`; `rename_symbol.py` finds them. Use the 93G RAM name of the same variable (`ram93.asm`, from a lined-up 93G operand), else name it from what it holds.
   - You may split a `db` run or a `resb` to put a label inside it, as long as the bytes do not change. For example, `resb 152` becomes `name: resb 4` plus `resb 148`.
5. Write structure fields as names: `[byte ecx+06Ah]` becomes `[byte ecx+SCnum]`. Keep the displacement size, and add a field to `structs.inc` (with its `size` tag) and `tools/struct_fieldmap.csv` when the evidence is there. Start with `tools/struct_operands.py MODULE` (dry run), then do the rest by hand:
   - The Watcom `-5r` short load reads a 16-bit field as a dword 2 bytes earlier: `mov edx, [byte ecx+0Ah]` / `sar edx, 10h` is `[byte ecx+Xvel-2]`. A byte field is read 3 bytes earlier with `sar 18h`: `mov edx, [byte ebx+44h]` / `sar edx, 18h` is `[byte ebx+pnum-3]`.
   - A 68k `.b` access to a word field reads its HIGH byte. The PC is little-endian, so that is `Field+1`: 93G `move.b Xvel(a3),d0` is `movsx ax, byte [ebx+Xvel+1]`. A word the 68k code uses as two bytes is swapped: 93G `temp2(a3)` (the countdown) is PC `temp2+1`, and `temp2+1(a3)` is PC `temp2`.
   - `add.l d4,facedir(a3)` (a long over a word field and its fraction) is `add dword [ecx+facedir-2], edx`.
6. Comments:
   - Bring over the 93G comment when the routine matches.
   - Otherwise add one above each function that says what it does, its arguments (eax, edx, ebx, ecx) and its return value.
   - Note PC differences from Genesis values (`; 93G $96, PC 200+legstr`).
7. Run `make` (MATCH), `python3 tools/update_symbols.py --check`, and `python3 tools/auto_names.py <module>` (0 auto names defined).
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
- Keep the `; <address>` comment at the end of every instruction line. It maps the line back to the EXE. Put your comments on their own lines or after it.
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

## Libraries (not in the queue, may be named)

These segments are skipped by the queue: there is no Genesis code to follow. Name a library routine or its data whenever you know it, for example a call from the current segment into `ea_gfx` that is clearly a text print. Use the library's own name when it is known (FLIRT names such as `printf_`, the EA library strings), else a name from what it does.

| group | segments | what |
|---|---|---|
| `watcom` | `watcom_begtext`, `watcom_clib_01-54` (+ `watcom_stack` in dseg02) | Watcom C/386 10.0 runtime (CLIB3R, MATH387R, EMU387, cstart) |
| `dos4gw` | `dos4gw_dpmi_glue_01-08`, `dos4gw_intr` | Watcom clib routines for the DOS/4GW (DPMI) environment (`int386`, `segread`, DPMI blocks). The DOS/4GW kernel and loader themselves are not in `src/` |
| `eacsndf` | `ea_sound_hl_01/02`, `eacsndf_core` | EA EACSNDF.LIB sound library (Jul 1994): sound config, patches/timbres, null driver |
| `sounddrv` | `snd_pcspeaker`, `snd_adlib`, `snd_soundblaster`, `snd_mt32_mpu401`, `snd_gus`, `snd_gus_sdk_01-09`, `snd_hw_pcspk_opl`, `snd_hw_sb`, `snd_hw_irq_dma` | AdLib/OPL, Sound Blaster, Gravis Ultrasound (+ SDK), MT-32, PC speaker drivers |
| `ealib` | `ea_memman*`, `ea_vesa_init`, `vesa_banked_blit`, `vga_blitters`, `video_bios_vga`, `ea_gfx_*`, `ea_window`, `ea_timer`, `ea_fileblock`, `ea_fileio`, `ea_unpack*`, `ea_shapes`, `ea_shpi`, `ea_snap*`, `ea_mvi`, `ea_mcga_window*`, `ea_kbd_exit*`, `ea_misc*`, `ea_debug`, `input_keyboard_01/02`, `input_mouse`, `input_joystick_misc` | EA PC libraries: memory manager, VESA/VGA graphics, fonts, windows, timer, file formats (.fsh/.qfs shapes, RefPack unpack, MVI), keyboard/mouse/joystick |
| `eagfx` | `cmv_player`, `cdstream`, `zonemgr` | EA CMV movie player, CD stream reader, zone/window manager |

## Queue

The first row that is not `done` is the current segment. The order is engine first, from small and well understood to large, then the season code, then the front end in EXE order. Auto names are `defined in the file / data names used`, from `tools/auto_names.py` at the time the queue was written. Bytes and ranges are from `src/segments.txt`. The range end is the last byte.

| # | File | Status | Range | Bytes | Funcs | Auto names | Genesis / role |
|---|---|---|---|---|---|---|---|
| 1 | `cseg01/043_5E16D_engine_skating.asm` | done 2026-10-09: 12 functions named (6 new: EvadePlayers, EvadePC, skatetopuck, playeracc, avdgoal_box, avdgoal; 6 confirmed), 2 shared tails, avdgoal_jt, 253 locals, 22 data labels, 7 struct fields; left: 30 [reg+NNh] operands (stack frame, team struct via +6Ch/+70h, byte +52h), avdgoal_box/EvadePlayers are PC-new (medium) | 5E16D-5FB02 | 6550 | 14 | 260 / 22 | 93G logic93_5 movement block: doplayeracc 5E16D, skateto 5E93B, skatetopuck 5EB17, playeracc 5EDAD, dostop 5F745, StopNA 5F82A, goalieacc 5F8B2, noturn0 5F98A; avdgoal 5F151 |
| 2 | `cseg01/066_8BEDB_asm_helpers.asm` | done 2026-10-09: 22 functions named (PlayMVI, SelectScreenBM, SelectRinkBM, SaveSS, SetDrawBitmap (lib B4F70), vgacopy_bg, 6 empty stubs stub_8C1B7..stub_8C223, 8 added labels on unreferenced VGA routines vgacopy_rect..vgacopy_pages; randomd0, vtoa confirmed), 1 shared tail, 50 locals (vtoa .0-.3 as 93G), 17 data labels (vtoa_dt, screenbm, rinkbm, scrpitch, scrollx/y, vgapage, bgscrolly8/x, musicon, songdata, musichandle, musicslot, saved_ss; folds StanleyCupTimer+2, musicslot-3); left: 29 auto code names in cmv_player/cdstream/timer/sound libs, 3 [esi+NNh] in the 16-bit VGA code (not struct fields). 8C290-8C8E7 is dead 16-bit-frame code, not a mode set | 8BEDB-8C94B | 2673 | 13 | 62 / 15 | Hand asm: randomd0 8C230 (93G middle93_1 / 94G video94), vtoa 8C8E8 (93G logic93_5 / 94G checks94), MVI player, VGA mode set 8C290 |
| 3 | `cseg01/038_4FCE8_engine_input.asm` | done 2026-10-09: 16 functions (15 named + Acheck confirmed): doinput (was doinput_ispc: it is the whole 93G doinput), lineinput, faceoffinput, holdplayer, getlchoice, lcfound, Readjoy1/2 (93G); PC-new joyq_pop/flush/peek (timer-ISR input queue), CanBlockShot (shot-block dive check), OppInReach, lcselect (line change by number), CenterMouse; also passmode 5514E and MouseSetPos B2DB4 outside; 96 locals, 2 shared tails; 33 data names (input queue, lj1/lj2, lastplayer, passdir, passplayer, fodir1/2, sflags, c1/c2playernum, cont1/2team, line change box lc*, linenext, lchoicetab; folds lcblinktime+2, lcreqchoice-2; wcradiusy C909E fixed); struct: impactp, impact, tmptr, optmptr + team fields tmline/tmlcnt/tmap/tmflags (no size tag). Left: 11 data (CC0F0, CC0F4 one-timer flag, CC118/CC128 'ps<>' in debug_dump, CCC9C, DF812, DFF36/DFF3A/DFF42, E9A9E, CBC60 (= lcline-2 but nosplit)), [esi+4Ah/4Ch/4Fh] fields, sub_53387 (dive), sub_59E69 (changeplayer), sub_59FE1, sub_4D938 (opens the lc box), sub_14AFE | 4FCE8-50AFD | 3606 | 16 | 112 / 56 | 94G input94 doinput_ispc 504DA, 93G logic93_1 doinput; input ring buffer, pad latch, line change / pass / shot helpers |
| 4 | `cseg01/042_59D9A_engine_core.asm` | done 2026-10-09: 48 functions named (+8 confirmed: SetSPA, GetHot, Setplass, setpersonel, updateplayers, DoGameFrame, resetplstuff, forcepldata). 93G: changeplayer, restorepl, CompLine (first named chk4lc, fixed in engine_physics_ai), AvgCline, getlinee, Goal (5AB36: tmscore+1, offside / delayed-penalty no-goal), setplayer, reenergizeteam, restoreteams, GetPeriodTime, ResetClock, defaultsprites2, StartPer, updatecrowdf, periodicevents, updateanim, setupice, clockcont_0, SprSort, GameOver, SetupTeamForIntermission, Intermission, IntermissionStart, PeriodOver, ResetBench, StartGame. PC-new: TeamLineEnergy, calcpuckcross, GetHotStick/GetHotOrStick, coach AI SetCoachMode/InitCoachModes/UpdateCoachModes, PenTeamScored, GiveControl, clearteams, ClearSortCords, TryAddPlayerToList/SetPlList, RestBench, LockScroll, cleargamevars, DrawRinkOverlays, ClockTick, SprSortVert, SetExitGame (low), forceteams; 6 shared tails; 544 locals; 62 data names/folds (hm/awtmstruct, scores, tmline/tmlcnt/tmsort/tmroster/tmlines/tmptrF2 globals, gsp, gameclock, clockticks, PerTimeTotal, periodendtime, CwdExciteLvl, lldisp, puckcross, puckstruct (+folds), sortobj15, camx/camy, PlList, SPAtab, ds2list); Ylist/OOlist/OOlistpos seeds corrected; team fields tmscore/tmpdst/tmlines/tmroster/tmsort added. Left: 135 auto data names (team fields D2h-F2h, debug CC1xx, rink/overlay tables), 190 unnamed [reg+NNh] operands (struct_operands fit only setplayer), coach mode details, updateplayers body comments | 59D9A-5E16C | 17363 | 57 | 593 / 230 | 93G logic93_5 SetSPA 59D9A / GetHot, hockey93_02 updateplayers 5C40F (asstab dispatch), updateanim, setpersonel, bench/line resets |
| 5 | `cseg01/040_53294_engine_physics_ai.asm` | done 2026-10-09: 34 functions named (+ existing Sweepcheck, burst, check4check, checkagr, checkgoalp, checkob, checkpuckcoll, CheckBump, dopass, passmode, setpassmode, passtoa0, holdcheck, puckshadow, puckglue, puckgoalie, puckstick, SetShotMode, ShotMode, Findhittype, deflect, checkgoalp_CalcGoalShotDir, checkplcoll, wallcollb, CPgoalie). 93G: checkcheck, checkint, chk4lc (fixes engine_core: 5A0A3 is CompLine), chk4pass, chk4shot, CompShoot, ChkOffsides, ChkShotStat, setInjuryType, FallDown, Bcheck, puckbody, puckIChk, doshot, newcheck, checkcoll, checkwallcoll, checkgoal, wallcoll, checkcx, ChkGoalies, ReturnGoalies. PC-new: ToFixed, BlockShotDive/TryBlockShot (shot-block dive), FacingBoards, ChkDelayedOffside, PuckCheckColl, ChkPullGoalieLate; low: SkillForAnim, PenTimeDiff, MarkOffsidePlayers, PassLaneChk; 6 shared tails; 726 locals; data iflags, lasttouch (+[lasttouch-2] short loads), crowdlevel, puckcross_m2, hmtmap/awtmap; team field tmpde. Left: sub_54D63 (pass launch with random puck velocity, called by dopass), sub_5601D (FallDown helper, distances to +-60h/+-CAh), 46 auto data names (CCBxx/CCCxx tables, debug CC1xx, E03Ax pass vars), 296 unnamed [reg+NNh] operands | 53294-59492 | 25087 | 60 | 754 / 94 | 93G logic93_1 / hockey93_03-05: burst 532BD, check4check, checkcheck, dopass, passtoa0, FallDown, puckstick/puckglue/puckgoalie, doshot, checkcoll |
| 6 | `cseg01/039_50AFE_engine_assign_faceoff.asm` | not done | 50AFE-53293 | 10134 | 18 | 298 / 119 | 93G logic93_4 puckfaceoff/puckfaceoff2/asspassrec, logic93_1 check4bench, 94G onetimer94 assonetimer 50B55 |
| 7 | `cseg01/037_4842A_engine_player_logic.asm` | not done | 4842A-4FCE7 | 30910 | 67 | 952 / 214 | asstab targets (table C9161): 93G logic93_2-5 assignments (29 slots) + 94G onetimer/breakaway/goalie additions (7) |
| 8 | `cseg01/041_59493_engine_sound_iface.asm` | not done | 59493-59D99 | 2311 | 30 | 91 / 19 | 93G sound93 / 94G sound94 sfx and song triggers; EACSNDF callbacks, music, speech/announcer wrappers |
| 9 | `cseg01/045_614C2_scoring_penalty_text.asm` | not done | 614C2-644A7 | 12262 | 43 | 338 / 193 | 93G penalty93 / 94G penalty94: AddPenalty, Stop4Pen, penalty manager 637B5-63BF8; goal/assist/penalty text, stat hooks |
| 10 | `cseg01/046_644A8_engine_display.asm` | not done | 644A8-688A3 | 17404 | 29 | 531 / 182 | 93G video93 / 94G display94 (role): ticker/messages, setInjuryType, checkwindow, rink palettes, updatereplay |
| 11 | `cseg01/048_69336_game_frame.asm` | not done | 69336-6A032 | 3325 | 1 | 39 / 121 | one 0xCFD-byte in-game driver, 56 callees; 93G hockey93_02 main loop / penalty93_2 StartHL2 (role, unverified) |
| 12 | `cseg01/036_47C31_engine_init.asm` | not done | 47C31-48429 | 2041 | 4 | 44 / 79 | in-game init helpers; 93G hockey93_01 / 94G hockey94, setup94 (role) |
| 13 | `cseg01/044_5FB03_game_state_saveload.asm` | not done | 5FB03-614C1 | 6591 | 3 | 72 / 204 | PC-new: in-game save/load (Error Saving/Loading Game) |
| 14 | `cseg01/047_688A4_debug_dump.asm` | not done | 688A4-69335 | 2706 | 2 | 48 / 118 | PC-new: debug state dump to stats.log (puckc, gmclock, gmpen, tmstructs, sortcords) |
| | **season95 (new in 95; Genesis season95 / trade95 / create95)** | | | | | | |
| 15 | `cseg01/033_40183_trades.asm` | not done | 40183-41B7F | 6653 | 13 | 124 / 79 | trades / human team selection / free agents (Select two teams for trading) ; NEW in 95 (Genesis trade95) |
| 16 | `cseg01/034_41B80_schedule.asm` | not done | 41B80-45281 | 14082 | 24 | 352 / 68 | season schedule (sche/Sch), human team selection ; NEW in 95 (Genesis trade95 schedule half) |
| 17 | `cseg01/052_6D2F8_create_player.asm` | not done | 6D2F8-71F0B | 19476 | 41 | 473 / 211 | player editor: ratings, shoots/glove hand, jersey, free-agent creation ; NEW in 95 (Genesis create95) |
| 18 | `cseg01/064_86696_season_playoffs.asm` | not done | 86696-8BAAE | 21529 | 30 | 560 / 179 | season / playoff tree, schedule.db, Stanley Cup screens ; NEW in 95 (Genesis season95) / data94 playoff tree (role) |
| | **front end (PC-new menus; Genesis only by role)** | | | | | | |
| 19 | `cseg01/001_10010_main_startup.asm` | not done | 10010-1167A | 5739 | 24 | 217 / 122 | main_ (disk/memory checks, DPMI DOS-mem probe via int386 31h), keyboard/joystick input mapping, screen helpers ; hockey94 Begin (role only) |
| 20 | `cseg01/002_1167B_gamesave_io.asm` | not done | 1167B-12848 | 4558 | 6 | 98 / 97 | save-game / .PPV / game.sav / .DB file handling |
| 21 | `cseg01/003_12849_team_stats_screen.asm` | not done | 12849-1331F | 2775 | 2 | 44 / 47 | team stats tables (GP/Min/GAA/SO/Shots/Pct; ANA Mighty Ducks) ; stats94 (role only) |
| 22 | `cseg01/004_13320_asset_loading.asm` | not done | 13320-1431D | 4094 | 13 | 99 / 163 | palette / screen / HILIGHT / numshp / rink-end overlay (.PPV/.VFN) loaders |
| 23 | `cseg01/005_1431E_file_utils.asm` | not done | 1431E-150C5 | 3496 | 27 | 105 / 41 | path building, disk-space checks, gsummary.db |
| 24 | `cseg01/006_150C6_scoreboard_gfx.asm` | not done | 150C6-1609E | 4057 | 13 | 97 / 75 | scoreboard / crest graphics (scrbrd2, srb3, crests4), Stanley Cup text |
| 25 | `cseg01/007_1609F_title_intro.asm` | not done | 1609F-17815 | 6007 | 14 | 140 / 70 | EA / Pioneer / title screens, MVI movie hooks (MVIh/MVIe/MVIf) ; title94 (role only) |
| 26 | `cseg01/008_17816_output_files.asm` | not done | 17816-17DFB | 1510 | 11 | 33 / 31 | output file (.OUT) writing, free-space prompts |
| 27 | `cseg01/009_17DFC_palette_fx.asm` | not done | 17DFC-18D7E | 3971 | 20 | 39 / 14 | 17 near-identical SfPal1/SfPal2 palette fade/cycle routines |
| 28 | `cseg01/010_18D7F_frontend_desk.asm` | not done | 18D7F-1AC24 | 7846 | 25 | 133 / 86 | output file name prompt, EA desk (eadesk), return/exit confirmation dialogs |
| 29 | `cseg01/013_1BBCC_key_team_db.asm` | not done | 1BBCC-1CC3C | 4209 | 9 | 100 / 116 | teams / key.db handling, gsummary |
| 30 | `cseg01/014_1CC3D_frontend_labels.asm` | not done | 1CC3D-1D6E7 | 2731 | 10 | 90 / 89 | scoreboard tiles, season titles, Sports Central menu labels |
| 31 | `cseg01/015_1D6E8_menu_system.asm` | not done | 1D6E8-20015 | 10542 | 10 | 240 / 41 | menu framework (Pointer / menubuff), season title strings ; menu94 (role only) |
| 32 | `cseg01/016_20016_easn_stats.asm` | not done | 20016-21CDD | 7368 | 18 | 122 / 63 | EASN stats screens (embpal, tstat, keys, pstat, gstat) ; stats94 (role only) |
| 33 | `cseg01/017_21CDE_player_stats.asm` | not done | 21CDE-2707F | 21410 | 20 | 523 / 181 | player stats / portraits / sort (PORTR, pstatbar, addsort, trad) ; stats94 (role only) |
| 34 | `cseg01/018_27080_standings_playoffs.asm` | not done | 27080-29709 | 9866 | 7 | 263 / 85 | standings, conferences, playoff seeding screens |
| 35 | `cseg01/019_2970A_league_schedule.asm` | not done | 2970A-29F17 | 2062 | 6 | 75 / 18 | LSSCHED schedule loading/drawing |
| 36 | `cseg01/020_29F18_arena_logos.asm` | not done | 29F18-2B7B6 | 6303 | 2 | 114 / 76 | arena / rink / team logo screens |
| 37 | `cseg01/021_2B7B7_file_dialogs.asm` | not done | 2B7B7-2D345 | 7055 | 13 | 207 / 149 | Open/Delete/Done file dialogs (*.nhl, *.po, *.lp), dialog boxes |
| 38 | `cseg01/022_2D346_game_setup.asm` | not done | 2D346-2FDD0 | 10891 | 5 | 201 / 133 | pre-game setup / matchup screen (indus030, ctlogo, No Penalties, game.set) |
| 39 | `cseg01/023_2FDD1_misc_dialogs.asm` | not done | 2FDD1-31AB4 | 7396 | 28 | 206 / 40 | misc dialog/menu helpers (.DB/.ORG, DBOX) |
| 40 | `cseg01/024_31AB5_main_desk.asm` | not done | 31AB5-32DA8 | 4852 | 6 | 102 / 58 | main desk / tonight screen (maindesk, tonights, easndesk), game.set |
| 41 | `cseg01/025_32DA9_temp_files.asm` | not done | 32DA9-3377B | 2515 | 16 | 51 / 40 | temp file / palette save/restore |
| 42 | `cseg01/026_3377C_rink_tiles.asm` | not done | 3377C-33FFC | 2177 | 5 | 54 / 34 | rink .til / TILES loader, CRESTS3 |
| 43 | `cseg01/027_33FFD_calendar.asm` | not done | 33FFD-35FB8 | 8124 | 7 | 120 / 56 | league calendar screens (calendar, callogo) |
| 44 | `cseg01/028_35FB9_import_export.asm` | not done | 35FB9-380E8 | 8496 | 10 | 197 / 118 | import/export, GSUMMARY game summaries |
| 45 | `cseg01/029_380E9_league_setup.asm` | not done | 380E9-3A9A9 | 10433 | 22 | 165 / 57 | league creation, master controller passwords |
| 46 | `cseg01/030_3A9AA_database_merge.asm` | not done | 3A9AA-3DB40 | 12695 | 18 | 252 / 107 | player database merge/import/export (PINFO, PLAYER, GAME, SAV) |
| 47 | `cseg01/031_3DB41_config_cfg.asm` | not done | 3DB41-3DC2B | 235 | 1 | 6 / 7 | nhl.cfg reader |
| 48 | `cseg01/032_3DC2C_roster_jersey.asm` | not done | 3DC2C-40182 | 9559 | 14 | 177 / 88 | roster / jersey number editing (HOMEPALS) |
| 49 | `cseg01/035_45282_options_settings.asm` | not done | 45282-47C30 | 10671 | 5 | 201 / 25 | option set screens (pset), load ; optsetup94 (role only) |
| 50 | `cseg01/050_6B093_joystick_calibration.asm` | not done | 6B093-6C2F8 | 4710 | 25 | 140 / 76 | joystick calibration screens (LEFT/RIGHT JOYSTICK) |
| 51 | `cseg01/051_6C2F9_database_save.asm` | not done | 6C2F9-6D2F7 | 4095 | 18 | 75 / 76 | save databases, free disk space, Free Agents list |
| 52 | `cseg01/053_71F0C_database_dialogs.asm` | not done | 71F0C-737A9 | 6302 | 13 | 160 / 116 | database open/delete dialogs (*.db/*.org/*.dbx) |
| 53 | `cseg01/054_737AA_line_editor_rosters.asm` | not done | 737AA-78345 | 19356 | 24 | 446 / 162 | line editor / rosters (scratch, dress, roster printout) ; stats94 line editor (role only) |
| 54 | `cseg01/055_78346_team_select.asm` | not done | 78346-7A139 | 7668 | 16 | 175 / 88 | team selection / lineups / logos |
| 55 | `cseg01/056_7A13A_settings_dialogs.asm` | not done | 7A13A-7DC8A | 15185 | 52 | 435 / 148 | settings dialogs: Music/Sound/Digitized Speech, controllers |
| 56 | `cseg01/057_7DC8B_gadgets_replay.asm` | not done | 7DC8B-7F723 | 6809 | 11 | 185 / 95 | rock music cues, gadget UI (instant replay controls) ; replay94 (role only) |
| 57 | `cseg01/058_7F724_highlights.asm` | not done | 7F724-8034A | 3111 | 9 | 49 / 65 | highlight reel save/load (.HI) |
| 58 | `cseg01/059_8034B_settings_lockerroom.asm` | not done | 8034B-8291D | 9683 | 17 | 175 / 159 | game settings summary, locker room / jerseys |
| 59 | `cseg01/060_8291E_sound_config.asm` | not done | 8291E-83458 | 2875 | 6 | 83 / 58 | sound card selection and nhl.cfg (MT32HOCK) |
| 60 | `cseg01/061_83459_speech.asm` | not done | 83459-842B9 | 3681 | 31 | 96 / 19 | speech buffers / sample memory |
| 61 | `cseg01/062_842BA_announcer.asm` | not done | 842BA-85923 | 5738 | 33 | 162 / 82 | play-by-play / PA announcer sentence builder (.cor/.bar/.int) |
| 62 | `cseg01/063_85924_demo_savegame.asm` | not done | 85924-86695 | 3442 | 6 | 49 / 47 | demo game, save game dialogs |
| 63 | `cseg01/065_8BAAF_allfiles_coach.asm` | not done | 8BAAF-8BEDA | 1068 | 2 | 27 / 24 | ALLFILES.TXT check, coach screen |

