# Assembly build: symbolic labels for the LE fixups, and the asm toolchain

Status (Oct 2026): **the EXE builds from committed NASM sources.** All 304 segments (198 code, 106 data, of which
72 have initialised bytes and 34 are BSS only) are in `src/` as NASM source with symbolic labels. `make` (or
`./build.sh`) assembles them, links them with a small Python linker, re-orders the harvested fixups like wlink and
writes a `HOCKEY.EXE` with the original sha1 `3961e0eba6b0338fad1613bb534efafd9406ed4a`.

Like the Genesis sister repos (NHL94Genesis commits its full disassembly under `src/`), the source tree is committed.
It contains the game's code and data as assembler text. The only parts taken from your `HOCKEY.EXE` at build time are
the third-party stubs (DOS/16M loader, DOS/4GW kernel, Watcom wstub), the LE header fields and the fixup record order.

## 0. Committed source tree and one-command build

```
cp /path/to/HOCKEY.EXE .        # your retail EXE (sha1 3961e0eb…), never committed
make -j8                        # or: ./build.sh [path/to/HOCKEY.EXE]
# ... MATCH: build/HOCKEY.EXE is byte-identical to the retail HOCKEY.EXE
```
Needs `nasm` (2.15 or newer; tested with 2.16.03) and Python 3. No iced-x86, no listing, no Genesis sources.

| path | what |
|---|---|
| `src/cseg01/NNN_ADDR_module.asm` (198) | code object, one file per segment of `segmap95pc.json`, one NASM section `s_<ADDR>` per file |
| `src/dseg02/NNN_ADDR_module.asm` (106) | data object: `db`/`dd sym` for initialised data, `resb` (nobits section) for BSS, labels in both |
| `src/inc/x86enc.inc` | the `LD op, dst, src` macro (load-form reg,reg encodings), included by every file |
| `src/inc/symbols.inc` | reference table of the 6,755 cross-segment symbols: address, name, defining file, number of users |
| `src/segments.txt` | link list: object, start, end, initialised bytes, module, file |

Build steps (`Makefile`; `build.sh` does the same without make):
1. `rebuild_exe.py extract HOCKEY.EXE build/parts`: checks the sha1 and extracts the stubs, `le.json` and
   `le_fixups.tsv`. It also writes the segment slices, but the link does not use them.
2. `nasm -O0 -f elf32 -I src/inc/` for every file → `build/obj/**.o`.
3. `tools/link_src.py`. Each section `s_<ADDR>` is placed at `ADDR`, and globals are resolved by name across all
   objects. `R_386_32` becomes an LE fixup (the stored value is object-relative), and `PC32`/`PC8` are resolved in
   place. A segment that assembles to a different size, or has non-zero BSS bytes, is an error. The segment slices go
   to `build/link/`; stubs and `le.json` are copied from the extract.
4. The fixup **set** comes from the relocations only. `order_fixups()` sorts it into wlink record order using the
   EXE's table. The linker also reports how the set differs from the EXE's (0 missing, 0 extra today).
5. `rebuild_exe.build()` → `build/HOCKEY.EXE`, then a sha1 check. The exit status is 1 (and make removes the file)
   on mismatch.

Editing: the segment layout is fixed. Each section is placed at its original address, and `segments.txt` gives its
size. A change must keep the segment the same size (for example, replace an instruction with one of the same length,
or pad with `nop`). Moving code between segments needs `segmap95pc.json` + `gen_src.py` changes. A changed fixup
target just works. A new fixup source is appended as a new chunk by `order_fixups()`, so the EXE stays valid but no
longer matches the sha1.

Regenerating `src/` (maintainers; overwrites hand edits):
```
python3 tools/rebuild_exe.py extract && python3 tools/gen_src.py      # needs iced-x86 + the listing caches for names
```
`gen_src.py` runs the `asm_proto.py` emitter on every segment and assembles each one. It checks bytes and fixups
against the EXE before writing. The output is deterministic: a second run gives identical files.
`--no-listing` works too, but gives fewer function names and a few more fallbacks.

```
python3 tools/rebuild_exe.py extract                 # build/parts from your HOCKEY.EXE
python3 tools/fixup_labels.py                        # build/labels/{symbols,sites,tables}.tsv + stats
python3 tools/asm_proto.py 2970A 8FFD4 CD304         # selected segments -> build/asm/*.asm/.o/.lst + report.json
python3 tools/asm_proto.py --all --exe-check         # every segment, then rebuild the EXE from them and sha1-check
python3 tools/asm_proto.py --eval --all              # nasm vs OW wasm vs JWasm encoding comparison -> build/asm/eval.json
```
Add `--no-listing` to either tool to ignore `tools/funcs.pkl` / `tools/lst_index.pkl` (then only the EXE parts plus
the committed `segmap95pc.json`, `name_map_94.csv` and `tools/global_map.csv` are used). Requirements: `nasm` (2.16),
`pip install iced-x86`. For `--eval`: OW 2.0 `wasm` (`$WASM`, default `~/watcom/ow2/binl64/wasm`) and JWasm 2.21
(`$JWASM`). JWasm builds from github.com/Baron-von-Riedesel/JWasm with `make -f GccUnix.mak`. UASM master does not
build on Linux right now (missing `direct.h`, old-style C), so it was not evaluated. It is a JWasm fork with the same
MASM syntax limits.

## 1. Fixup targets as labels (`tools/fixup_labels.py`)

Inputs: `build/parts` (the segment slices + `le_fixups.tsv`), `segmap95pc.json`, `name_map_94.csv`,
`tools/global_map.csv`, and optionally `tools/funcs.pkl` / `tools/lst_index.pkl`.

* **Symbol per fixup target.** The name comes from `name_map_94.csv` (proposed name, else a non-`sub_` IDA name) or
  `global_map.csv`, made assembler-safe and unique. Otherwise it is an auto name keyed by linear address:
  `sub_` (function entry), `loc_` (inside a function), `jpt_` (switch table), `off_` (pointer table), `asc_`
  (string referenced as an immediate), `dword_`/`word_`/`byte_`/`qword_`/`tbyte_` (size of the memory operands that
  reference it), `unk_`.
* **Flags.** `mid_function` (code target that is not a function entry; `parent` = `func+off`), `mid_item` (inside a
  pointer table, or inside an IDA data item when the listing is available), `not_insn_boundary`.
* **Per-fixup source site.** Instruction disp32, instruction imm32, switch-table entry in code, other data dword in
  code, data pointer-table entry, or plain data dword. Code sites record the instruction address and text.
* **Code decoding.** iced-x86 linear sweep per segment. It restarts at known boundaries: function starts, fixup
  targets in code, and branch targets (the branch-target set is iterated until it settles). Data ranges in code are
  switch tables (`jmp [reg*4+tab]`, `FF 24 xx`, with a fixup on the table), IDA data/align items (listing only),
  and any run of stride-4 fixup sources that the sweep could not put on an instruction operand. That last rule is
  iterated to a fixpoint. Every one of the 26,790 fixups lands on an operand field or a table/data dword. With the
  listing caches, all 192,331 instructions IDA decoded are also found by the sweep. The 8,667 extra ones are mostly
  FLIRT-collapsed library functions, which have no items in the listing.

### Statistics (with listing caches; `tools/fixup_stats.json`)

| | count |
|---|---|
| fixup records (unique + 19 page-straddle duplicates) | 26,809 (26,790 + 19) |
| distinct targets | **6,776**: 92 named, 6,684 auto |
| code_func (function entry) | 459 (71 named): 355 listing/name-map/`__CHK` prologue, 33 only via direct-call targets |
| code_mid (inside a function) | 285: 194 switch cases, 84 code-pointer-table targets (hand-asm dispatch), 7 other |
| code_table (data in the code object) | 121: 46 switch jump tables (398 entries), 75 other data-in-code items |
| data | 5,911 (21 named): 3,312 scalar/array, 1,267 strings, 195 pointer tables, 1,137 BSS |
| flags | 285 mid_function, 293 mid_item |
| source sites | 19,279 insn disp32, 4,945 insn imm32, 398 switch-table entries, 161 other code-data dwords, 1,638 data pointer-table entries, 369 lone data dwords |
| pointer tables in data | 289 runs (114 data-pointer, 15 code-pointer, 160 mixed = struct arrays with pointers) |

Few targets are named because most named functions are reached by relative `call`s, which carry no LE fixup.
The asm output labels every function entry and branch target as well, using the name map wherever it has a name.

Without the listing caches: the same 6,776 targets, but function entries come only from the name map, direct-call
targets and `push N / call __CHK` prologues. That gives 314 code_func / 493 code_mid / 58 code_table targets, and
the switch-table length rule is less precise. The asm round trip still matches (see below).

## 2. Toolchain choice: NASM + a tiny include + a Python linker

| | NASM 2.16 (`-O0`, ELF32) | OW `wasm` 2.0 (OMF) | JWasm 2.21 (ELF/OMF) |
|---|---|---|---|
| per-instruction identical encodings, all 200,998 code instructions, before any fallback | **197,025 (98.02%)** | 175,261 (87.20%) | 174,110 (86.62%) |
| Watcom-compiled game code (frontend + engine + season95, 139,692 insns) | **99.6%** | 86.1% | 85.6% |
| force imm32 for a small immediate (`push 4` in every `__CHK` prologue is `68 04000000`) | `strict dword` / long form under `-O0` | no | no |
| force disp8 / disp32 | `[byte ebx+4]`, `[dword ebx+4]` | no | no |
| reg,reg direction (`89 D8` vs `8B C3`) | store form only; load form via `LD` macro (below) | load form only | load form only |
| relocations | ELF `R_386_32` / `PC32` / `PC8`, incl. `dd sym-$-4` | OMF FIXUPP (`tools/omf.py` could be extended) | ELF or OMF |

**Why NASM:**
* It is the only one of the three that can be told the immediate and displacement size.
* Its reg,reg default (store form, opcode `01/29/31/89`) is what `wcc386` emits. The C game code therefore
  round-trips with almost no help: `league_schedule` has 664 instructions with 0 fallbacks.
* The opposite direction (load form `03/2B/33/8B`, which MASM/TASM-assembled library and driver modules use) is
  one macro in `src/inc/x86enc.inc`: `LD op, dst, src`.

GNU as could also express direction (`{load}`/`{store}`) and displacement size (`{disp8}`/`{disp32}`). In a
smoke test I found no pseudo-prefix that forces imm32 for a small value, and the `push N / call __CHK` prologue alone
needs that about 1,200 times. GNU as was not evaluated further.

**Pipeline.** `asm_proto.py` does the following:
1. Emit `bits 32`, `section s_<ADDR>`, `extern`/`global`, a label line per label, one instruction per line, and
   data as `db` runs split at labels, with `dd sym` at fixup sources.
2. `nasm -O0 -f elf32 -l`.
3. `link_segment()` resolves `R_386_32` (each becomes an LE fixup `(src_linear, target_obj, target_offset)`, and the
   stored value is rewritten to the object-relative offset like wlink does) and `R_386_PC32`/`PC8` (cross-segment
   branches; resolved, no LE fixup).
4. Compare each element with the original bytes. The listing gives element offsets; macro/include lines are
   skipped. Mismatches become `LD` or `db` fallbacks, and the segment is assembled again. 1 to 3 rounds.
5. Check bytes == original slice and fixup set == original fixups in that slice.
6. With `--exe-check`: write the slices into `build/asm_parts/`, shuffle all harvested fixups,
   `order_fixups(…, build/parts/le_fixups.tsv)`, `rebuild_exe.build()`, sha1.

## 3. Prototype results

| segment | kind | size | insns | `LD` macro | db fallback | fixups | bytes | fixups |
|---|---|---|---|---|---|---|---|---|
| 2970A `league_schedule` | Watcom C, switch table | 2,078 | 664 | 0 | 0 | 57 | match | match |
| 8FFD4 `watcom_clib_07` (cstart) | library asm, copyright string in code, overlapping branch targets | 896 | 318 | 0 | 16 | 31 | match | match |
| B3E4A `video_bios_vga` | hand asm, 10 tables, data in code | 3,726 | 1,127 | 133 | 3 | 183 | match | match |
| CD304 `data_frontend_38` | data, pointer table | 72 | – | – | – | 18 | match | match |
| CD34C `data_engine_39` | data, 207 pointers | 1,668 | – | – | – | 207 | match | match |
| **all 270 slices** (`--all`) | 198 code + 72 data | whole objects | 200,998 | 3,456 | **113 (0.06%)** | 26,790 | 270/270 | 270/270 |
| **whole EXE** (`--exe-check`) | 270 slices replaced, fixups via `order_fixups()` | | | | | | **sha1 MATCH** | 0 new fixups |

Without the listing caches (`--no-listing`): 270/270 slices match, 3,535 `LD`, 180 db fallbacks, EXE sha1 MATCH.
Per-segment counts: `tools/asm_proto_summary.json`.

## 4. Encoding pitfalls found (and how the emitter handles them)

1. **reg,reg direction bit.** `ADD/ADC/SUB/SBB/AND/OR/XOR/CMP/MOV r,r` has two encodings. NASM always picks the
   store form. 3,456 instructions (mostly ealib, sound drivers, emulator, Watcom asm) use the load form:
   `LD op, dst, src` from `x86enc.inc`.
2. **Accumulator short forms.** `sub eax, imm32` encoded as `81 E8 id` while NASM picks `2D id` (20 cases), and
   `xchg` operand order / `90+r` forms (≈30): db fallback with the original disassembly as a comment.
3. **Immediate size.** Watcom's prologue `push 4` is `68 04 00 00 00`. NASM `-O0` keeps the long form unless the
   iced `byte` hint (sign-extended imm8 encodings) is present. MASM-family assemblers shrink it (1,064 failures each).
4. **Displacement size.** `[ebp-8]` with disp8 vs disp32. The emitter always writes `[byte …]`/`[dword …]` from
   the original `displ_size`. `[eax*4+x]` needs `nosplit` (NASM would otherwise encode `[eax+eax*1]`-style).
5. **`moffs` forms.** `mov eax,[abs]` as `A1` vs `8B 05`. NASM picks `A1` for eax/al. Mismatches fall back to db.
6. **DS prefix on indirect branches.** iced prints it as CET `notrack`. The emitter strips the word and keeps
   `ds:` inside the memory operand.
7. **Fixups are object-relative.** The stored dword is `target - object_base`, not linear. The linker rewrites it.
   Assembling against absolute `equ` addresses would lose the relocation, so cross-segment labels are `extern`.
8. **Data decoded as code** (strings in cstart, IDA-collapsed library bodies) can produce branches into the middle
   of instructions or fixup fields. Such targets are not used as decode boundaries. Instructions branching to an
   unlabelled spot in the same segment are kept as raw bytes (the segment layout is reproduced exactly, so the
   displacement stays right). Labels that fall inside an instruction or a pointer are defined with `name equ $+k`.
9. **Short branches across segments** are `R_386_PC8` in ELF (addend −1). The linker handles them. While an
   earlier element still has the wrong length they can go out of range. The value is then truncated and the
   per-element check repairs the length on the next round.
10. **wasm needs `-fpi87`** (or `-fp3`) for x87 code. `-fpi` would add emulator fixups (`FIWRQQ`…) that the EXE does
    not have. Both MASM-family assemblers reject `smsw eax` with a 32-bit operand.

## 5. Segment-map issues the prototype exposed (fixed)
* Three switch tables sat at the end of one slice but are dispatched from the next slice: 29F18 (in
  `league_schedule`, used by `arena_logos`), 2D346 (`file_dialogs` / `game_setup`), 78346 (`line_editor_rosters` /
  `team_select`). Watcom emits a switch table **before** its function in 28 of 46 cases. The module boundaries in
  `segdef.py` now start at the table (29F18, 2D346, 78346).
* The last dword fixup of `data_sounddrv_71` (D8B64) ran one byte past the end of the initialised data (D8B67) into
  BSS. `build_segmap.py` now moves the data/BSS split up to the end of any fixup dword that straddles it, so
  `data_sounddrv_71` is D8ACC-D8B68 (155 file bytes + 1 zero byte of BSS, emitted as part of the `dd`). The
  verifier's tolerance for trailing bytes is gone: every segment must assemble to exactly its size. The 21-byte
  BSS piece that was `data_sounddrv_72` (it existed only because of that one byte) is now part of
  `data_frontend_72`, so dseg02 has 106 segments (was 107) and the later data segments are numbered one lower.

## 6. Plan / next steps
1. Done: switch-table boundaries and the D8B64 split (section 5).
2. Done: committed `src/` tree + `make` / `build.sh` (section 0).
3. Prettier operands: emit `parent+off` (e.g. `dword_EDA08+4`) for `mid_item` targets once data item extents
   are curated, plus struct-field names from `tools/struct_fieldmap.csv` for `[reg+disp8]` accesses.
4. Replace the remaining 113 db fallbacks with macros (`ALU_EAX_LONG`, `XCHG_RM` …) so every instruction is
   readable text.
5. Per-function matching: swap one function's asm for `wcc386` (10.0 LA, default flags) output, keep the rest as
   asm. The harvested fixups go through `order_fixups()` (new ones are appended as new chunks; an exact match of
   chunk order needs the real OMF record split).
6. Optional: GNU as backend (`{load}`/`{store}`) to compare, and a wasm/OMF path through `tools/omf.py` if a
   Watcom-native link (wlink) becomes the goal.
