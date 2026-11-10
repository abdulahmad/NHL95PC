# NHL 95 PC (PortMaster)

This port is a derivative of [nhl95pc](https://github.com/abdulahmad/nhl95pc) by **abdulahmad**. Credit: **abdulahmad**, **chaos**, **StaticEck** and **McMarkis (Mhopkinsinc)**. Carry this credit in any fork or release.

Host: **Overbar** (https://github.com/abdulahmad/overbar), PolyForm Noncommercial 1.0.0. Third-party files copied into Overbar keep their own MIT notices (see `licenses/`). The product name is Overbar.

Private zip first. Do not upload to portmaster.games until Abdul says the catalogue is allowed (EA trademarks).

## What this zip is

A **PortMaster** package. Docs and example paths are optimized for **Knulli** on the RG35XX H700 family (Plus, H, SP, 2024). The same zip is the PortMaster package on muOS / ROCKNIX / others: the launch script uses `$directory` from `control.txt`, not a hard-coded Knulli path.

**No aarch64 binary is in this zip.** The desktop trap host is **i386** (`gcc -m32`, NASM in-process). That binary cannot be renamed `nhl95pc.aarch64` and cannot run on the handheld. The shipping CPU is a later **native gcc + HAL** build. Until then, Autoinstall + copy paths work; missing `nhl95pc.aarch64` shows a PortMaster message. Do not box86/qemu.

`HOCKEY.EXE` and CD data are never in the zip. You copy them.

## Game files (you copy)

Retail `HOCKEY.EXE`: 1,179,067 bytes, SHA-1 `3961e0eba6b0338fad1613bb534efafd9406ed4a`.

After PortMaster install on **Knulli**:

```
/userdata/roms/ports/nhl95pc/gamedata/HOCKEY.EXE
/userdata/roms/ports/nhl95pc/gamedata/NHL.CFG
/userdata/roms/ports/nhl95pc/gamedata/   …rest of the installed folder
/userdata/roms/ports/nhl95pc/cd/ALLFILES.TXT
/userdata/roms/ports/nhl95pc/cd/         …CD files (not the .iso)
```

1. Copy the **installed** NHL 95 folder into `gamedata/` (EXE, `NHL.CFG`, HD files that CFG lists).
2. Copy the **CD’s files** (names in `ALLFILES.TXT`) into `cd/`. Not the ISO. Movies/coach CMV live here; splash skip is fine if CMV is missing.

`gamedata/` must stay writable (the game writes `SND.CFG` and season/career DBs there). Host ini and XDG live in `conf/`. Sound Blaster default (`BLASTER=A220 I7 D1 T3`). GUS patches and MT-32 ROMs are not required.

Missing `HOCKEY.EXE` or `NHL.CFG` → on-screen PortMaster message, no hang.

## Install (Knulli)

Prefer Autoinstall. ext4 roms partition if you can (exFAT can surprise PortMaster).

1. Copy `nhl95pc.zip` unextracted to `/userdata/system/.local/share/PortMaster/autoinstall/` (create it if needed; fallback `/userdata/roms/ports/PortMaster/autoinstall/`). Other CFWs: muOS `/mmc/MUOS/PortMaster/autoinstall/`, ROCKNIX `/roms/ports/PortMaster/autoinstall/`.
2. Open **PortMaster** once. It writes `NHL 95 PC.sh` and `nhl95pc/` under `roms/ports/`.
3. Exit so EmulationStation rescans. If the title is missing: Start → Game settings → **Update gamelists**.
4. Copy game files as above. Launch from **Ports**.

Fallback without Autoinstall: unzip so `NHL 95 PC.sh` sits in `roms/ports/` with `nhl95pc/` beside it, `chmod +x` the `.sh` (and `.aarch64` when it exists). Prefer Autoinstall.

`screenshot.png` (4:3, ≥640×480 gameplay) is added after on-device capture.

## Controls

RG35XX Plus (no analog) is the hard case: **d-pad is the glove**.

| Action | Mapping |
|---|---|
| Desk glove | gptokeyb **mouse**: d-pad (H: left stick too) moves the pointer, **A** left-click, **B** right-click |
| Overbar overlay | **Select** (Back). Desktop: `` ` `` / F11. Game pause (Esc / Start) does not open it. |
| Overlay nav | D-pad + A confirm + B back, including the **Online** page (visible; not a play gate) |
| Stats | F12 |
| Quit to EmulationStation | **Select+Start** (PortMaster) |
| On-screen keyboard | F9 by hand. Auto-open only if the last input was a controller (Overbar host) |

Face-button labels on Anbernic are Nintendo-style; PortMaster SDL is Xbox-style. gptk `a` = south.

## Handheld present

60 Hz, vsync on, overlay only (no menu bar), SDL_Renderer / KMSDRM, `NHL95_NOGL=1`. GLES2 renderer if the driver offers it. No desktop OpenGL, no gl4es, no Vulkan.

**Windows desktop:** leftover `PORTMASTER` / `CFW_NAME` / `OVERBAR_HANDHELD` from packing a zip must not force GLES2. The Win32 host scrubs those vars (`win32_scrub_portmaster_env`) before `SDL_Init`, and Overbar `ob_handheld_env()` is 0 on Win32. `_WIN32` is never handheld.

## Pack

From this repo (Overbar pin `8ae849c`):

```
./portmaster/pack.sh                  # layout zip, no binary
./portmaster/pack.sh path/to/nhl95pc.aarch64   # later, when native HAL exists
```

Writes `build/nhl95pc.zip`. Does not copy `gamedata/` or `cd/` contents.
