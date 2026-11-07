# Overbar

> **Making a port, fork or other derivative work from this repo? You must credit abdulahmad and everyone credited here, clearly, in your own repo and in every release.** See [NOTICE](NOTICE) and [Credits](#credits-and-derivative-works).

A **host harness** around retro game ports: one menu model, one scaler, two shells (overlay + native file menus). Not an NHL-only toolkit — first clients are the NHL 94 Genesis / SNES C ports and the 94/95/96 PC SDL2 ports.

This is **v1**: the standalone skeleton. Game-port wiring is a later unit. Host-only; no game-logic edits.

## What v1 is

| Piece | Status |
|---|---|
| `LICENSE` + `NOTICE` | MIT (PulseMan-copied files keep the pulseman authors; Abdul credit block in NOTICE) |
| Menu model | Shared tree (Resume, Video, Sound, Input, Capture, Online Play, Keys, Quit) plus addon slots |
| Overlay | PulseMan `mdrt_menu` pages. `` ` `` and **F11** toggle; **F12** stats. Controller Back still opens it |
| File menus | Win32/GTK/Cocoa **stubs**. Bar only in windowed desktop; overlay always available; handheld / KMSDRM overlay-only |
| Scaler dest-rect | nhl95pc `sdl2-port` `video_view` approach: 4:3 dest **as if 240 lines existed**; source stays 224. No 8+8 black blit |
| Default look | Desktop: **VRR**, Fit, Sharp **1X** (hi-res) / **3X** (lo-res). Handheld / KMSDRM: same Fit + Sharp at **60 Hz**, vsync on |
| Scale Mode | Sharp / CRT Monitor / MiSTer / RetroArch / Scale2x / Scale3x / MMPX 2x / 4x / xBR 2x / 3x / 4x. Overlay shows **only that mode’s options** and live-previews |
| SNES Picture | **No Native 1:1.** Always the 240-high 4:3 DAR (PAR 5:4 on 256×224) |

Looks (MiSTer GLES shaders, Lottes, shipped shaders, Capture GIF, netplay) land in later units. Pixel-art magnifiers are listed; the filters themselves still live in PulseMan until copied. CRT / MiSTer / RetroArch stay on the Video page on a handheld; if the present cannot run them the overlay says it fell back to Sharp.

## Handheld / PortMaster / RG35XX

`ob_profile_from_env` treats PortMaster (`CFW_NAME`, `PORTMASTER`, `OVERBAR_HANDHELD`) and Anbernic names (`RG35XX*`) plus SDL `kmsdrm` / `rpi` / `mali` / `vivante` as handheld. First launch is **60 Hz + vsync**, not VRR. The file-menu bar stays off. Present is **SDL_Renderer** (GLES2 if the driver offers it). Desktop OpenGL is never required and is never picked on a handheld. `ob_present_apply_hints` sets `SDL_RENDER_DRIVER=opengles2` before `SDL_Init` so KMSDRM does not look for libGL.

The game ports ship the PortMaster zip/control files. This repo is the host they link.

## Build

Needs a C99 compiler. No SDL for the v1 tests.

```
make test
```

`liboverbar.a` is what a game port will link. A client:

1. `ob_present_apply_hints(ob_profile_from_env())` then `SDL_Init`
2. `ob_host_init` with the port and `ob_profile_detect(SDL_GetCurrentVideoDriver(), ob_handheld_env())`
3. `ob_host_load_ini` (missing file writes L15 defaults once)
4. Each frame: `ob_view_from_host` + `ob_view` for the dest rect; SDL_Renderer copy (or `ob_present_sdl_*` when built with `OVERBAR_SDL`); `ob_overlay_draw` if open
5. Keys: `ob_overlay_toggle_key` / `ob_stats_toggle_key` (do not bind overlay to Esc)
6. Windowed desktop: `ob_filemenu_wanted` then the later Win32/GTK/Cocoa bar; handheld / KMSDRM / fullscreen: overlay only

## Scaling (L5)

The window’s destination rectangle is **4:3 as if the picture were 240 lines tall**. The source texture stays `W×224`. The scaler does not draw 8+8 (or 11+8) black rows into that texture.

| Source | Dest 4:3 of a 240-line canvas | Pixel PAR |
|---|---|---|
| 256×224 (H32, SNES) | width = height × 4/3 | **5:4** |
| 320×224 (H40) | width = height × 4/3 | **1.0** |
| 256×224 stretched to 4:3 using height 224 | **wrong** | ≈1.167 |
| 320×224 stretched to 4:3 using height 224 | **wrong** | ≈0.933 |

VGA ports (94/95/96 PC) keep `dar_h = src_h` (200 or 480). 31 kHz line-doubles the **unit**, not the texture.

## Keys (L13)

| Key | Host |
|---|---|
| `` ` `` (grave) | Overlay |
| F11 | Overlay (same) |
| F12 | Stats |
| Controller Back | Overlay |
| Esc | **Not** overlay (PC in-game pause / the game) |

GIF record is not F11 (Capture page). Screenshot is not F12.

## Layout

```
include/overbar/overbar.h   public API
include/mdrt/menu.h         PulseMan overlay menu (copied)
src/                        menu model, overlay, file-menu stubs, scaler, present, defaults
third_party/pulseman/       copied PulseMan menu.c (original copyright)
licenses/                   third-party texts
shaders/                    user-dropped RetroArch shaders (L10; not shipped)
mister/                     MiSTer data lands later
tests/                      dest-rect, defaults, keys, Scale Mode, overlay
```

## Credits and derivative works

This host includes files from [PulseMan](https://github.com/1nputs/pulseman), MIT License, Copyright (c) 2026 The pulseman authors.

Additional host work: Copyright (c) 2026 abdulahmad and contributors.

This project is a derivative of Abdul Ahmad's NHL disassemblies and C ports ([github.com/abdulahmad](https://github.com/abdulahmad)). Credit: **abdulahmad**, and everyone listed in the "Credits and derivative works" section of the relevant game repo README (**chaos**, **StaticEck**, **McMarkis (Mhopkinsinc)**, **Drezz**; special thanks to **smozoma** and **kingraph** where that README lists them). Carry this block in release notes and in any text file shipped inside a release archive.

If you build anything from this repo, put that credit near the top of your README and in every release. See [NOTICE](NOTICE).
