# NHL 95 PC

> **Making a mod, hack, port or other derivative work from this repo? You must credit me (abdulahmad) and everyone credited in this repo, clearly, in your own repo and in every release. See [Credits and derivative works](#credits-and-derivative-works).**

> **Work in progress:** this decompilation is unfinished and unpolished, and is being actively worked on. Expect labels, file layout and docs to change.

## 🚧 Current Status

- McMarkis is working on the C decompilation.
- <!-- nhl95-readme-count:start -->975 of 1084 functions matched.<!-- nhl95-readme-count:end -->
- Names come from 93G first, then 94G.

**Picking this up? Start with [HANDOFF.md](HANDOFF.md)** (setup, verify, current state, what to do next).

Bitwise rebuild of NHL 95 for DOS (`HOCKEY.EXE`, EA Sports 1994). The retail EXE is in the repo. The whole EXE builds byte-exact from the NASM sources in `src/`. C matching is in progress: see [C_PROGRESS.md](C_PROGRESS.md).

`HOCKEY.EXE` is a Watcom C/C++32 10.0 program linked as a Linear Executable (LE) and bound to the DOS/4GW Professional extender (Rational DOS/16M loader, then a Watcom wstub, then the LE). The goal is a bit-perfect assembly rebuild first, then a matching C decompilation built with the same compiler.

Sister projects: [NHLPA93Genesis](https://github.com/abdulahmad/NHLPA93Genesis), [NHL94Genesis](https://github.com/abdulahmad/NHL94Genesis), [NHL95Genesis](https://github.com/abdulahmad/NHL95Genesis). NHL 95 PC is a hybrid port of 93G and 94G (NHL 94 PC was ported from NHLPA 93 Genesis plus some 94 Genesis and new menus; NHL 95 PC is that plus further 94/95 Genesis additions). **Name mapping prefers 93G names, then 94G, then a name from behaviour.** NHL95Genesis is only loosely related (a loose reference, not a naming source). The front end is PC-new.

## Retail EXE

The retail `HOCKEY.EXE` is committed at the repo root (same layout the tools expect by default):

| | |
| --- | --- |
| File | `HOCKEY.EXE` |
| Size | 1,179,067 bytes |
| SHA-1 | `3961e0eba6b0338fad1613bb534efafd9406ed4a` |

`.gitignore` keeps the IDA listing (`*.lst`), everything under `build/` (the extracted EXE parts), and the local Genesis source copies (`ref/`) out of commits. The three Watcom files needed for C matching are committed under `tools/watcom/`.


## Build from source

The segment naming queue is finished. The main work is **C matching**: start with [HANDOFF.md](HANDOFF.md) and [docs/C_MATCHING.md](docs/C_MATCHING.md) (progress in [C_PROGRESS.md](C_PROGRESS.md)). Agent standing rules: [AGENTS.md](AGENTS.md).

`python3 tools/rebuild_exe.py verify` needs **Python 3 only** (the committed `HOCKEY.EXE` is enough). Full `make` needs **nasm** (2.15+) and **make**. Matched C (`CBUILD=1`) also needs **DOSBox**; the three Watcom files are already in `tools/watcom/` (see [HANDOFF.md](HANDOFF.md)). Without DOSBox, `make` uses the asm and still matches.

```
make -j8            # or ./build.sh [path/to/HOCKEY.EXE]
```

This assembles the 304 files in `src/` (one per segment: 198 code, 106 data), links them with `tools/link_src.py`, and writes `build/HOCKEY.EXE`. It ends with `MATCH` when the result is byte-identical to the retail EXE; otherwise it fails. From the committed EXE the build takes only the three third-party stubs (DOS/16M loader, DOS/4GW kernel, Watcom wstub), the LE header fields and the fixup record order. Code, data and the fixups themselves come from `src/`. Layout, editing rules and how `src/` is regenerated (`tools/gen_src.py`): [docs/ASM_BUILD.md](docs/ASM_BUILD.md).

## Running the game on a modern PC (SDL2 port)

The branch `sdl2-port` runs the game's own code natively, with the DOS, BIOS, sound, video and input hardware emulated by the host
(`port/`). Build and details: [docs/SDL2_PORT.md](docs/SDL2_PORT.md); state and open items: [docs/SDL2_HANDOFF.md](docs/SDL2_HANDOFF.md).
`src/` is untouched, so `make` still ends with `MATCH`.

* **Start**: run `hockey-win32.exe` (Windows build, `port/build-win.sh`) in the game's folder, or set `NHL95_ROOT`. It finds the game files
  next to the program, in the parent folder, or in `NHL95_CD` (the CD's contents). No setup files needed.
* **Video**: the 8-bit screen is drawn by OpenGL. The 320x200 play screen is enlarged 3x with nearest-neighbour, then filtered with a
  bicubic (Catmull-Rom) filter to any window size; the 640x480 menus are filtered directly. The picture is always 4:3, centred.
  `NHL95_FILTER=nearest|linear|cubic` changes the filter, `NHL95_NOGL=1` uses SDL's renderer. **Alt+Enter** switches between the window
  and borderless fullscreen. The **`** key (tilde) shows or hides the stats display.
* **Window menu and settings** (Windows): the menu bar has Display (60 Hz, 70 Hz, VRR, V-Sync, Stats display, shortcut `), Menus (hi-res) and Gameplay (lo-res). Each has integer scales (1X-4X for the menus, 3X/5X/7X/11X for play, each then scaled to the window with the bicubic filter), CRT scanline looks (light, medium, strong; for play a TV with single scanlines or a line-doubled monitor) and soft CRT looks (a Gaussian beam blended in linear light, with or without an aperture grille). The MiSTer look uses the MiSTer scaler's own files: a horizontal filter, an adaptive scanline filter, a gamma curve and a shadow mask. The files are in [port/mister](port/mister) (see the credits there) and the build copies them next to the program as `mister`; other files, for example from a MiSTer SD card, can be added there with the same layout (`Filters`, `Gamma`, `Shadow_Masks`, `Presets`). The Menus (hi-res) and Gameplay (lo-res) menus each have a "MiSTer filters" submenu, with its own settings: presets (such as JVC, Sony PVM, Trinitron), every horizontal filter, vertical filter, gamma and shadow mask file as a choice, the shadow mask scale, a brightness setting and a reset. the ini keeps the choices (`hires_mister_*` and `lores_mister_*`; the defaults are GS_Sharpness_060, SLA_Dk_030_Br_070, gamma_113 and JVC 001 (Generic)). Choosing a look with scanlines turns on auto crop for that kind of screen, and choosing a plain scale (1X-11X) goes back to fit the window. By default the window draws each new image (VRR) with vsync off. Without the files a plain stand-in is used. The "custom" look is an earlier approximation of the MiSTer look with four values in the ini (`custom_*`). The Display menu also sets whether the Windows pointer is hidden automatically, always shown or always hidden. Scanlines keep the source lines whole and darken between them. Each also has a picture height: fit the window, integer (the biggest whole multiple of the source lines, so every scanline is the same height), integer +1x overscan (the next multiple up, a little cut off) or auto crop (+1x when 10 rows (menus) or 6 rows (game) or fewer are cut off, otherwise integer). The Gameplay (lo-res) menu also has Monitor - 15kHz (single scan, the TV standard) and Monitor - 31kHz (double scan, the VGA standard: the 320x200 picture is doubled to 320x400 before the filter, still shown at 4:3) for every CRT look, not for the plain 3X-11X scales. The choices are saved in `hockey-win32.ini` next to the program, which can also be edited by hand. The stats display (top right) shows frames per second, new images per second, CPU and GPU use. The menu is hidden in fullscreen, and the game pauses while a menu is open.
* **Mouse**: the game's pointer follows the Windows pointer exactly. The Windows pointer is hidden over the 4:3 picture only where the game draws a pointer of its own (the hockey glove in the menus and the replay, the green pointer in play with the mouse as a control device) and shown everywhere else, such as the splash screens. It can leave the picture and the window, except in play with the mouse as a control device, where it is kept on the picture, and in fullscreen. The rules are in [docs/SDL2_PORT.md](docs/SDL2_PORT.md#mouse-behaviour).
* **Input bindings** (Options > Input bindings...): a window with a tab for Joystick One, Joystick Two, Keyboard and The Mouse. Pass / change player (Alt), shoot / speed burst (Space), hold / change line (both together), the arrows, show player numbers (Tab), the team lines (F1-F8), pause (Esc) and replay (R) can each be rebound; a controller or the mouse binds its buttons. Saved in `hockey-win32.ini` under `[input]`. Rebinding only applies in a game, never in the menus.
* **Sound**: none, PC speaker, AdLib, Sound Blaster, MT-32 (with the digital effects of the Sound Blaster, which the original MT-32 mode lacked; Munt; put `MT32_CONTROL.ROM` and `MT32_PCM.ROM` in a `roms` folder next to the
  program) and Gravis Ultrasound (the `ULTRASND` patch folder is found next to the game or program). Choose the card in the game's setup.
* **Joystick**: SDL game controllers answer the game port (201h) as a PC joystick.
* **Diagnostics**: with `NHL95_AUDIO_DEBUG=1` the sound emulation writes `nhl95-audio.log` next to the program and Ctrl+F11 records the sound; `NHL95_TRACE`, `NHL95_STATS`
  and the other test variables are listed in [docs/SDL2_PORT.md](docs/SDL2_PORT.md).

## Byte-exact rebuild from the EXE's own parts

Needs Python 3 only. Run from the repo root.

```
python3 tools/rebuild_exe.py extract   # check HOCKEY.EXE sha1, split it into build/parts/
python3 tools/rebuild_exe.py build     # rebuild build/HOCKEY.EXE from build/parts/ only
python3 tools/rebuild_exe.py verify    # extract + build + sha1 compare (+ fixup-order experiments)
```

`verify` prints `MATCH` and exits 0 when the rebuilt file equals your EXE. `extract` writes the MZ stubs, the LE header and tables as JSON, the 26,790 fixups as `le_fixups.tsv`, and the code/data slices for every segment in `segmap95pc.json` (`build/parts/cseg01/`, `build/parts/dseg02/`). `build` reads only that directory. Only the DOS/16M loader body, the DOS/4GW kernel and the wstub body stay opaque blobs. Details: [BUILD_NOTES.md](BUILD_NOTES.md).

## Segment map

* [EXE_SEGMAP95PC.md](EXE_SEGMAP95PC.md) is the segment map of the code and data objects, with module boundaries, Genesis counterparts and the evidence for each.
* [segmap95pc.json](segmap95pc.json) is the same map in machine-readable form. `rebuild_exe.py` uses it to slice segments.
* [name_map_94.csv](name_map_94.csv) maps each function to a name and source file in the 93/94 Genesis sources, with confidence and evidence. It is generated by `tools/matcher.py`; hand-traced rows live in [tools/manual_names.csv](tools/manual_names.csv) (same columns) and override the generated row at that address, so put manual edits there, not in the CSV. Without a local `FUNCTION_MAPPINGS95.md` the unmatched-row universe is every code function from the listing (`--universe funcs`, 2,577 rows; the named rows are identical).
* `tools/struct_fieldmap.csv` and `tools/global_map.csv` map player-struct fields and globals to their Genesis names.

The analysis scripts in `tools/` (`le_parse.py`, `lst_parse.py`, `build_funcs.py`, `features.py`, `ref93_index.py`, `ref94_index.py`, `segdef.py`, `build_segmap.py`, `sem_features.py`, `sem_match.py`, `matcher.py`, `write_md.py`) regenerate the map. They also need an IDA listing `HOCKEY.EXE.lst` that you make yourself, plus the Genesis sources cloned into `ref/93`, `ref/94` and `ref/95`. Their intermediate `.pkl` caches are not committed. Run order is listed at the top of `EXE_SEGMAP95PC.md`.

## Compiler findings

* **Watcom C/C++32 10.0 GA (mid-1994)**. The runtime is newer than 10.0 LA (Mar 1994) and older than 10.0a (Sep 1994). Library modules match 10.0a CLIB3R except the ones fixed by the 10.0a A-level patch. The copyright string says 1988-1994.
* **The 10.0 GA `wcc386` is in the repo and is the reference compiler** (`tools/watcom/dosga`, from the archive.org Watcom collection; found 2026-10-22). Its clib3r matches the EXE best (GA 124 modules, 10.0a 121, LA 110). Before that, 10.0 LA reproduced game code (8 of 8 test functions byte-exact; 10.0a 6 of 8, because it widens the 16-bit short compares the EXE has). LA is kept: `make WATCOM_VER=la`.
* Flags inferred: `-5r -fpi -zp1` (`-mf`, stack checks on, no `-o` options). Evidence: 2,527 `mov r32,[x-2]; sar r32,10h` short loads (-5r), EMU387 linked (-fpi), unaligned dwords in packed structs (-zp1, medium confidence).

Test harness (needs `dosbox`; `$WATCOM_ROOT` defaults to `tools/watcom`; optional full historic installs elsewhere):

```
tools/wc10.sh ga tools/cc_tests/t1.c ""   # compile with 10.0 GA wcc386 under headless DOSBox -> build/cc/ga/ (la, 10a, 105 need ~/watcom)
tools/sweep.sh la ""                      # compile every cc_tests file, compare with HOCKEY.EXE (tools/cmpobj.py)
python3 tools/libmatch.py $WATCOM_ROOT/w10a/WATCOM/LIB386/DOS/CLIB3R.LIB   # library module matching
```

`tools/cc_tests/targets.txt` lists each test function and the EXE address it should match. `tools/cc_tests/sweep_la.txt` has the flag-sweep results.

## Docs

* [AGENTS.md](AGENTS.md): standing rules for contributors and agents
* [HANDOFF.md](HANDOFF.md): setup, verify, current state, Next, Unsure plan
* [BUILD_NOTES.md](BUILD_NOTES.md): rebuild format, fixup ordering (wlink algorithm), compiler fingerprint, next steps
* [EXE_SEGMAP95PC.md](EXE_SEGMAP95PC.md): segment map
* [docs/SKATING_AND_RINK.md](docs/SKATING_AND_RINK.md): skating physics and rink geometry vs. 93 Genesis
* [docs/C_MATCHING.md](docs/C_MATCHING.md): C matching decompilation (wcc386 10.0 GA → OMF → spliced into the asm build), headers, workflow, compiler learnings; progress in [C_PROGRESS.md](C_PROGRESS.md)
* [docs/ASM_BUILD.md](docs/ASM_BUILD.md): the `src/` tree and `make` build, LE fixups as symbolic labels (`tools/fixup_labels.py`), the NASM toolchain, and the asm emitter (`tools/asm_proto.py`, `tools/gen_src.py`)
* [docs/UNSURE.md](docs/UNSURE.md): capped drafts and what was tried
* [docs/SESSION_LOG.md](docs/SESSION_LOG.md): archived session diary from earlier HANDOFF updates

## Segment naming (queue finished)

The segment naming queue in [SEGMENT_AGENT.md](SEGMENT_AGENT.md) is **complete**. Leftover work there is auto/data names only. [PROMPT.md](PROMPT.md) has the C-matching prompt. Tools:
* `tools/rename_symbol.py` renames a symbol across `src/`, rebuilds (must MATCH) and records the name in the maps.
* `tools/auto_names.py` lists what is still unnamed in a segment.
* `tools/update_symbols.py` regenerates `src/inc/symbols.inc`.

## AI assistance

This project is AI-assisted. The work is directed by a strict ruleset and curated by hand, with the aim of producing correctly labelled and commented code that matches the spirit of what the original source code would have been. We can't guarantee it's perfect, and ultimately this will always be a work in progress. If you see something that needs fixing, raise an issue, or even better, raise a PR.

## Credits and derivative works

Thanks to **chaos**, **StaticEck** and **McMarkis** for help with the disassemblies.

The SDL2 port's MiSTer look (the `mister` folder of filters, gamma curves, shadow masks and presets, and the file formats it reads) comes from the **MiSTer FPGA project**: the scaler's filter files are from [Filters_MiSTer](https://github.com/MiSTer-devel/Filters_MiSTer) (including the adaptive scanline filters by Soltan_G42 and Tonurics), the shadow masks from [ShadowMasks_MiSTer](https://github.com/MiSTer-devel/ShadowMasks_MiSTer) (the JVC masks are by TrashUncle) and the presets from [Presets_MiSTer](https://github.com/MiSTer-devel/Presets_MiSTer). The MiSTer project is GPL-3.0; those files are included unchanged in [port/mister](port/mister) with their credits and links. The soft CRT looks follow the shader by Timothy Lottes, and the Munt library plays the MT-32 sound ([Munt](https://github.com/munt/munt)); the OPL emulation is Nuked-OPL3.

This project is the result of my work (abdulahmad) and the work of the people credited above. If you build anything from it, including mods, ROM or EXE hacks, ports, released forks, tools, or any other derivative work, you must credit us:

- Put the credit in your repo's README, near the top and not buried in a footer, and in the notes of every release you publish, including any text file shipped inside a release archive.
- Name me (abdulahmad) and link to this repository.
- Name everyone credited here: chaos, StaticEck and McMarkis (Mhopkinsinc).
- If you only use part of this repo (docs, a tool, labels, a file format description), the credit still applies.
- If you are unsure, over-credit.

Credit is the condition for using this work. Please do not release a derivative without it.
