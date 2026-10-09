# NHL 95 PC (HOCKEY.EXE) – rebuild + toolchain notes

All paths are relative to the repo root. The historic Watcom compilers live outside the repo (default `~/watcom`, override with `WATCOM_ROOT=...`). They are not committed.

## 1. Byte-exact rebuild (`tools/rebuild_exe.py`)

```
python3 tools/rebuild_exe.py extract [EXE] [PARTS]   # check sha1, then split -> build/parts (same as split)
python3 tools/rebuild_exe.py verify     # split -> build/parts, build -> build/HOCKEY.EXE, compare + fixup experiments
python3 tools/rebuild_exe.py split  [EXE] [PARTS]
python3 tools/rebuild_exe.py build  [PARTS] [OUT]   # uses only the parts dir; never reads the original EXE
```

Result: **MATCH**. Rebuilt file is 1,179,067 bytes, sha1 `3961e0eba6b0338fad1613bb534efafd9406ed4a` (same as the original).

### Parts layout (`build/parts/`, 2.3 MB)
| part | form | regenerated / opaque |
|---|---|---|
| `stub/dos16m_mz.json` + `dos16m_body.bin` | DOS/16M loader MZ header (14 fields, 0x4E relocs, header tail) | header **regenerated** from JSON; load-module body **opaque blob** (Rational 3rd-party code) |
| `stub/dos4gw_bw.bin` | 'BW' DOS/4GW Pro kernel (4GWPRO.EXP May 19 1994) | **opaque blob** |
| `stub/wstub_mz.json` + `wstub_body.bin` | Watcom wstub MZ header + relocs | header **regenerated**, `e_lfanew` **recomputed** from layout; body is an opaque blob |
| `le.json` | full LE header (all 46 fields), object table, resident names (`hockey`), empty entry table, import tables (1 zero byte) | **regenerated**. 15 derived header fields are recomputed from the tables and asserted equal to the recorded values: num_pages, last_page_size, every table offset, fixup/loader section sizes, data_pages_off (512-aligned, bound-MZ relative) |
| page map | – | **regenerated** (sequential 1..193, type 0) |
| `le_fixups.tsv` | 26,790 rows `chunk, src_linear, target_obj, target_offset`, kept in linker insertion order | fixup page table + record table **regenerated** (see below) |
| `cseg01/NNN_ADDR_module.bin` (198), `dseg02/...` (107) | segment slices from segmap95pc.json | object pages = concatenation of the slices + obj1 0x77A zero pad + zero fill up to data_pages_off |
| `manifest.json` | slice order, sizes, source sha1 | – |

Only three things stay opaque: the third-party DOS/16M loader body, the BW DOS/4GW kernel, and the wstub body. Everything belonging to the LE is generated from structured data.

### Fixups: what was found
* All 26,809 records have the same simple shape. Source type 07 (32-bit offset), internal reference, 8-bit object number. flags=0x10 (32-bit target offset) exactly when target_offset > 0xFFFF; otherwise flags=0x00 with a 16-bit target offset. No chained-source lists, no imports.
* The 32-bit value stored at each source in the page image is the **object-relative** target offset, not a linear address. A data label at linear EDA0C is stored as 0x2DA0C. All 26,790 rows check out against the image.
* Straddling fixups: 19 fixups cross a 4 KB page end. wlink writes each one twice: once in its own page and again in the next page with a negative source offset (-1 to -3). 26,790 unique + 19 duplicates = 26,809. The rebuild creates the duplicates on its own.
* **Record order is not sorted.** It follows the Open Watcom wlink algorithm (`bld/wl/c/reloc.c`, `DoWriteReloc`/`DumpRelocList`). Each page's relocations are appended to 512-byte blocks, and a new block is put at the head of the list, so the file holds the **blocks in reverse order, each block in insertion order**. I verified this on every page: blocks are full to 504–512 bytes, and records are 7 or 9 bytes.
* Insertion order is the order wlink met the fixups. That is object-module order, then one chunk per OMF data/fixup record. Inside a chunk the offsets run descending (3,589 chunks). A few chunks have one out-of-place entry, probably switch tables or forward references, so the order cannot be derived just by sorting.

### Bonus: regenerating fixups from (src, target obj, target offset)
* **Works.** `rebuild_exe.py verify` shuffles the fixup set randomly and drops the chunk ids. It then re-orders the set with the recorded order table (`order_fixups()`, keyed by source address), rebuilds, and gets **MATCH**.
* Without any order information (just sorted by source address), the file is the same size and all header fields are identical, but 143,803 bytes in the fixup record table differ. The order is the only extra information needed.
* For an assembler-based build: collect the absolute 32-bit relocations from the assembler output as (src_linear, target_obj, target_offset), call `order_fixups(set, build/parts/le_fixups.tsv)`, and feed the result to `build()`. New or moved fixups are appended as new chunks, which gives a valid but non-identical EXE. A real wcc386 + wlink 10.0 build would reproduce the order by itself only if the OMF record splitting matched too.

## 2. Compiler fingerprint

### Verdict
**Watcom C/C++32 10.0 GA (mid-1994)**, the release between 10.0 "Limited Availability" (March 1994) and 10.0a (CD dated 22 Sep 1994). Game C code was built with **plain `wcc386` defaults**:
`-5r` (Pentium register calling convention), `-fpi` (inline x87 with emulator), `-zp1`, `-mf`, stack checking ON (no `-s`), and **no `-o` options** (no -ox/-oneatx/-otexan/-or/-ol/-os/-ot/-oi). Linked with wlink as a DOS/4GW LE, without debug info. Hand-written asm modules (e.g. randomd0 at 8C230: 16-bit mul code, `align 10h`) are separate.
Confidence: version family 10.0 = very high. GA rather than 10.0a/LA = high. Flags = high for the stack-check, opt-level, -5r, -oi and calling-convention parts; medium for -zp1 (inferred); -oa/-ob/-oc/-oe/-om/-on/-op could not be told apart from the defaults by these tests.

### Evidence
1. **Copyright string** at lin 8FFD4 (cstart): "WATCOM C/C++32 Run-Time system. (c) Copyright by WATCOM International Corp. 1988-1994". 10.5 says 1988-1995, so 10.5 is ruled out. EACSNDF.LIB is stamped Jul 28 1994.
2. **Library byte matching** (`tools/omf.py` + `tools/libmatch.py`, fixup bytes masked, against cseg01):
   | library | exact modules (bytes) |
   |---|---|
   | 10.0a CLIB3R.LIB (Sep 1994) | **121 (19,238 B)** + 4 near misses |
   | 10.0 LA CLIB3R.LIB (Mar 1994) | 110 (16,074 B) |
   | 10.5 CLIB3R.LIB | 53 |
   | OW 1.9 clib3r | 7 |
   | 10.0a CLIB3S (stack convention) | 13 (tiny asm helpers only) |
   | 10.0a MATH387R / LA MATH387R / 10.5 | 12 / 11 / 7 |
   | EMU387.LIB (all 10.x) | 99.3% (emulator is linked, so `-fpi`) |
   * The modules that do **not** match 10.0a exactly are the ones its A-level patch (`A_LEVEL/README.A`) lists as fixed: scanf '%' counting (`scnf`, which differs right at the `cmp ebx,25h` code), DOS/4G realloc heap corruption (`grownear`), and the `cstrt386` startup. Several modules (nmalloc, nfree, memalloc, nexpand, fputs, stk386 `__CHK`) match 10.0a but **not** LA. So the runtime is newer than LA and older than 10.0a, which means 10.0 GA.
   * The register-convention clib (`clib3r`) is used, and register arguments are visible everywhere (eax, edx, ebx, ecx).
3. **Codegen reproduction** (historic compilers run under headless DOSBox: `tools/wc10.sh`, `tools/sweep.sh`, `tools/cmpobj.py`, tests in `tools/cc_tests/`). I wrote 8 small game functions in C: 8C1C2, 8C1E2 (shared tail via cross-jump), 1431E, 17711, 2C3FF, 4F99B, 14CA0, 59FE1.
   * **10.0 LA `wcc386` with default flags: 8/8 byte-exact** (fixups masked).
   * 10.0a with defaults: 6/8. It cannot produce the EXE's 16-bit short compares (`cmp dx,8`); 10.0a always widens with `movsx`. So the GA compiler still behaves like LA here.
   * Flags that break exact matches: -3r, -s, -ox, -oneatx, -otexan, -or, -ol, -os, -ot, -d2, and -oi (with real `<string.h>`, strcpy/strcat get inlined; the EXE calls strcpy_/strcat_/memset_).
   * -4r and -5r generate the same code for the 8 tests. In general, though, -5r loads shorts as `mov r32,[x-2]; sar r32,10h` and -4r uses `movsx`. The EXE has **2,527** of the `mov/sar 10h` idiom, so the setting is -5r.
   * Other idioms seen: `push N; call __CHK` prologue; callee saves every register it uses; ebp used as a general register (no frame); functions not aligned; cross-function tail merging.
4. **-zp**: the 10.0 default is -zp1 (test struct {char;int;short} has sizeof 7). In the EXE, 296 of 1,350 `dword_` labels sit at addresses that are not a multiple of 4, which fits packed structs.

### Toolchains used (`$WATCOM_ROOT`, default `~/watcom`, 2.2 GB, public downloads only, not in this repo)
* Open Watcom 1.9 (`ow19/`, linux binl works: wcc386, wdis, wlink, dmpobj) and OW 2.0 snapshot (`ow2/`).
* Watcom 10.0a CD (`w10a/`, unpacked tree + A_LEVEL patches), 10.0 LA CD (`wla/`; clib3r/math387r/emu387/wcc386 unpacked with WPACK under DOSBox into `dosla/`), 10.5 CD libs and binaries (`w105/`), 9.5b zip (`w95b/`, WPK-packed, not unpacked).
* Source: archive.org item `watcom-c-cpp-compilers-collection` (and Watcom_C_10.0, which is the same 10.0a disc). **No 10.0 GA binaries are known to exist publicly.** The a-level patch format (bpatch DIFFS) only stores new bytes, so it cannot be run backwards to get GA.

## 3. Next steps
1. Use **10.0 LA `wcc386` (defaults)** as the reference compiler for matching game C code. Re-test against 10.0a if a function fails, and keep a list of LA-vs-GA discrepancies. Keep looking for a 10.0 GA disc (June 1994) to close the gap.
2. Link the libc side from the matched objects: take the 10.0a CLIB3R modules that match exactly, and treat cstrt386/scnf/grownear/sscanf/strspn/fstrspn (GA versions) as binary blobs from the EXE.
3. Assembler-based build: emit per-segment asm → assemble → harvest absolute relocations → `order_fixups()` → `rebuild_exe.build()`. Remember that stored values are **object-relative** offsets.
4. Optionally run real wlink 10.0a/LA on synthetic OBJs to confirm the chunk/FIXUPP-order theory, so a fully native wcc386+wlink path can reproduce the order without the table.
5. Run the remaining -o letter tests (-oe inlining, -om, -op, -oa) on functions that exercise them, plus FP-heavy functions (-fp3 vs -fp5).
