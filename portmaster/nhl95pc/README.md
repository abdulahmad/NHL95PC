## Notes

NHL 95 PC on Overbar for PortMaster (RG35XX H700 / muOS first).

This port is a derivative of [nhl95pc](https://github.com/abdulahmad/nhl95pc) by **abdulahmad**. Credit: **abdulahmad**, **chaos**, **StaticEck** and **McMarkis (Mhopkinsinc)**. Host overlay/scaler: Overbar (PulseMan MIT, MiSTer filter data). Carry this credit in any fork or release.

Private zip first. Do not upload to portmaster.games until Abdul says the catalogue is allowed (EA trademarks).

`HOCKEY.EXE` and CD data are never in the zip. Copy the install into `gamedata/` and CD files into `cd/`.

The shipping CPU is **gcc aarch64 of game C** (native HAL), not the i386 trap host on `sdl2-port` and not Unicorn. This tree holds the zip layout and host flags; copy `nhl95pc.aarch64` in when that binary exists.

## Controls

Desk: d-pad moves the pointer, A click, B right-click. Select overlay, Select+Start quit.

## Handheld

60 Hz, vsync on, overlay only, SDL_Renderer / KMSDRM, `NHL95_NOGL=1`. No desktop OpenGL.

## Compile

Later: `make native` in the PortMaster aarch64 builder. `portmaster/pack.sh` assembles the zip.
