# SDL2 port (branch `sdl2-port`)

The game runs through SDL2 on Linux and on Windows without changing the byte-exact sources in `src/`. `make sdl2` assembles the same
NASM sources (`make CBUILD=0`, as `elf32` objects) and links them with the host in `port/` into `build/hockey-linux`, a 32-bit Linux
program. `make sdl2-win` (or `port/setup-win.sh`) does the same with `win32` objects and mingw-w64 into `build/win/hockey-win32.exe`,
a 32-bit Windows program. Both run the same host code; only `port/plat_linux.c` and `port/plat_win.c` differ.
`main` still only takes byte-identical changes; this branch adds `port/`, this file and the `sdl2` target.

## How it works

The game is a flat 32-bit program written for DOS/4GW. It does four things Linux does not allow, and the host answers each:

| the game does | the host |
|---|---|
| `int 21h`, `int 31h`, `int 10h`, `int 33h`, `int 16h`, `int 2Fh` | the instruction faults (SIGSEGV); `port/emu.c` decodes it and `port/dos.c` / `port/video.c` / `port/input.c` answer like DOS, DPMI, the VESA BIOS and the mouse driver (files are opened below `$NHL95_ROOT`, default the current directory, with the DOS path turned into a case-insensitive host path) |
| `in` / `out`, `cli` / `sti` | the same fault (a signal on Linux, a vectored exception on Windows); `port/ports.c` has the VGA DAC (3C7-3C9), the retrace bit (3DA), the PIT (40h, 43h), the keyboard (60h, 64h), the speaker and joystick ports |
| hooks IRQ 0 (timer) and IRQ 1 (keyboard) with `int 21h/25h` | `port/irq.c`: the main thread signals the game thread (Windows: suspends it and edits its context) and the handler makes the interrupted code "take" the interrupt (an iret frame is pushed so the game's handler returns through a stub); the tick rate follows the PIT divisor the game programs |
| draws into the VGA window at `0xA0000` and switches banks with `int 10h 4F05h` | `port/video.c` keeps the whole frame buffer, saves and loads the window on a bank switch, and the main thread turns it into an SDL texture (palette from the DAC) about 60 times a second |

Threads: the main thread owns SDL (window, events, timer ticks, presentation); the game runs in a second thread. The signal handlers use their
own stack because the game's `esp` is not aligned for the C library.

Routines that cannot work on a PC emulated this way are replaced at their entry by a jump to host code (`port/overrides.c`): the floating
point emulator hook (the CPU has an FPU), the CPU test that leaves the alignment-check flag set, the VESA probe (the game ran an external
program for it; the host fills in the same tables), and the video mode save and restore (BIOS data area).

`port/cstart.c` does what the Watcom `_cstart_` does with DOS/4GW (program segment prefix, environment, command line) for a flat process, then
the C library start-up runs as in the original.

DOS memory (`0x10000`-`0xFFFFF`) is mapped at the same addresses, like under DOS/4GW. DPMI blocks are placed below 2 GB (the Watcom heap compares
addresses as signed numbers) and at most 32 MB each (the EA memory manager takes the biggest block it can get).

## Windows

```
port/setup-win.sh                    # from Linux or WSL: installs mingw-w64 and nasm, downloads SDL2 for mingw, builds
# or, in an MSYS2 "MINGW32" shell:
pacman -S --needed mingw-w64-i686-gcc mingw-w64-i686-SDL2 mingw-w64-i686-pkgconf nasm make python
port/build-win.sh
```

The result is `build/win/hockey-win32.exe` and `SDL2.dll`. Run it in the folder with the game's data, or set `NHL95_ROOT`. A Windows image
may have only 96 sections, so the build folds the sources' 304 sections into `.text` and `.data` (the zero-filled sections too, as zeros: the
game's data segment has to stay one contiguous block in the original order, because the GUS driver clears a table from one symbol up to the
next). The program must be 32-bit:
the game's code is 32-bit and runs natively. Windows reports `int 21h` and friends as an access violation or a privileged-instruction
exception, which the vectored handler in `plat_win.c` turns into the same emulation calls. The game's `__setenvp_` is stubbed because it
would load FS (the thread information block) with a DOS/4GW selector. Tested under Wine only so far.

## Build and run (Linux)

```
# or just: port/setup.sh /path/to/game/files
sudo dpkg --add-architecture i386 && sudo apt update
sudo apt install gcc-multilib libsdl2-dev:i386 nasm make python3
make sdl2
cd /path/to/NHL95/game/files        # the directory with NHL.CFG, ALLFILES.TXT and the game data
/path/to/nhl95pc/build/hockey-linux # or NHL95_ROOT=/path/to/game/files
```

The game's data files are not in this repository. Debug helpers: `NHL95_TRACE=1` logs every interrupt and port access;
`NHL95_STATS=1` prints every 2 s how many traps (int, in, out, cli, sti, pushf, popf) the game made by opcode, port and int 21h function, the time spent in them, the game thread's user and kernel CPU time, `video_present` timing and the game's tick rate against the PIT rate; `NHL95_KEYS="ms:Key[/hold] ..."` presses keys at given times (SDL key names);
`NHL95_DUMP=/dir` (with `SDL_VIDEODRIVER=dummy`) writes a PPM of the screen about twice a second; `port/where.py ADDR` maps a runtime address
to the original address and the asm around it.

## State (2026-10-26, Windows, native)

Runs with the real game data (the installed game folder, or a copy of it with the CD's files, is the current directory; `NHL95_CD` names a
separate folder with the CD's files). Works: start-up, the intro (Pioneer, EA, the title movie), the front end with the menu bar driven by the
keyboard (arrow keys move the pointer, Return clicks), File > New Exhibition Game, starting and playing a game, the attract-mode demo. Sound,
all checked by listening on the author's machine: no sound, PC speaker, AdLib, Sound Blaster, MT-32 (Munt) and Gravis UltraSound (the American
anthem plays correctly). Not yet checked: keyboard play in detail, joystick, Linux (the Windows work was not built there; the Linux data layout
probably has the same zero-filled-section problem as the Windows one had), fullscreen and scaling options.

Files the program looks for beyond the game folder (so that it runs "raw", with nothing set): the game's files in the folder above the game
folder and in the folder of the program and above it (the Gravis patches `C:\ULTRASND\MIDI`, which the game opens as `./ULTRASND/MIDI/HOMEORG.PAT`),
and the MT-32 ROMs (`MT32_CONTROL.ROM`, `MT32_PCM.ROM`) in `NHL95_MT32_ROMS`, the game folder, a `roms` folder next to the program, or the folders
above (a message box says so when they are missing).

Windows specifics found on the way: DOS memory 0x10000-0xFFFFF is part of the image (linked at 0x10000, section `.lowmem`), reads below 0x10000
are redone on a buffer, `pushf`/`popf` of the game are `int3` (flagops.h) so that the game's interrupt flag (not the CPU's) is kept, the host
data is read-only (`NHL95_NOROPROTECT=1` to switch that off), a timer tick the game could not take is queued, and the game's data segment is one
contiguous block in the original order (zero-filled sections are folded into `.data`).

Sound emulation notes: the Sound Blaster and the GUS run by the clock (`sb_pump`, `gus_pump`), not by the audio device's callbacks, because the
game's drivers read the playback position and take interrupts from it; in the game the GUS is used twice: voices 0 and 1 are a ring buffer for the
game's own mixer (digital sound, speech), and the other voices play the organ patch natively for the anthem (the music driver releases a note by a
volume ramp and frees the voice when the ramp-end interrupt arrives, so the ramp speed matters: the ramp step is 16 register units per rate
unit, as in DOSBox). The interrupt-queue semantics of GF1 register 8Fh and the voice-control acknowledge are modelled.

Debugging: `NHL95_TRACE=1`, `NHL95_STATS=1` (traps, ticks, `video_present` timing), `NHL95_KEYS="ms:Key ms:@x,y ms:@click"` (scripted input),
`NHL95_DUMP`, `NHL95_WAV`; `port/where.py` maps a runtime address (set `NM` to the nm of the toolchain). `CRASH ...` lines come from the last
exception handler. Without any setting, the program appends to `nhl95-audio.log` next to it while a sound card is in use (refill and interrupt
timing, slow DOS calls, the music files the game opens, native GUS voice activity), and **Ctrl+F11** records the mixed sound to
`nhl95-capture-N.wav` (the window title says so): that is how sound problems on a machine are diagnosed without a debugger.

Joystick: the PC game port (201h) is emulated from the first two SDL game controllers or joysticks found (stick A and B; left stick or
direction pad, A/X and B/Y as the two buttons). The game then shows its own calibration screen once (move the puck to all corners, back to the
centre, press a button; any key ignores the stick). Axis timing is a number of port reads, not time. `NHL95_NOJOY=1` turns it off;
`NHL95_JOY="x,y,b1,b2"` and `ms:@joy=x,y,b1,b2` in `NHL95_KEYS` fake a stick for tests. Checked here with the fake stick (calibration, menu
pointer), not with a real pad.

Not done: digital audio in MT-32 mode (the game plays only music there), fullscreen and scaling options.

## Next steps (in the order asked for)

1. Finish the SDL2 port against the real data: assets, sound, joystick.
2. Manual goalie, 3. automatic line changes, 4. custom keyboard bindings, 5. four players, 6. rollback netcode. These change game logic, so
   they belong in C functions of `src/c` that are compiled for the host (the byte-exact build keeps the matched originals). Rollback needs the
   whole game state in one block: the game's data segment is a single contiguous region, so it can be saved and restored once the input
   sampling is separated from the frame step.

## Sound

The sound hardware is emulated at the I/O-port level, so the game's own drivers (PC speaker, AdLib, Sound Blaster, MT-32 on an
MPU-401, Gravis UltraSound) run unchanged and the device you pick in the game's sound setup is the device that plays.

| Device | Emulation |
| --- | --- |
| PC speaker | PIT channel 2 + port 61h square wave (`speaker.c`) |
| AdLib / Sound Blaster FM | [Nuked-OPL3](https://github.com/nukeykt/Nuked-OPL3) with the OPL timers (`opl.c`) |
| Sound Blaster / Pro | DSP, mixer, 8237 DMA, PIC IRQs; single-cycle, auto-init and direct 8-bit output (`sb.c`, `dma.c`) |
| Roland MT-32 | MPU-401 UART port + [Munt](https://github.com/munt/munt) (`mpu.c`) |
| Gravis UltraSound | GF1: 32 voices, 1 MB RAM, ramps, loops, timers, DMA upload (`gus.c`) |

* `port/fetch-deps.sh` (run by the build scripts) clones Nuked-OPL3 and Munt into `port/third_party` (both LGPL, not committed).
* **MT-32 needs the ROM images** `MT32_CONTROL.ROM` and `MT32_PCM.ROM`, which are not distributed. Put them in the game folder, in
  `roms/`, or point `NHL95_MT32_ROMS` at their folder. Without them the MT-32 choice is silent.
* Hardware settings default to `BLASTER=A220 I7 D1 T3`, MPU-401 at 330h and `ULTRASND=240,1,1,5,5`; set those variables on the
  host to change them. `NHL95_SOUND=none` disables all sound hardware.
* `NHL95_WAV=file.wav` records the mix. `NHL95_SOUNDTEST=1` drives AdLib, Sound Blaster and the GUS through their ports and exits,
  printing PASS/FAIL (useful without the game's data files).
* Not yet verified against the game itself (the data files aren't in the repository): in particular the GUS and MT-32 paths.

## Mouse behaviour

The game draws its own pointers (the hockey glove in the menus and the replay, a green pointer in play when a player has the mouse as a control
device), so the Windows pointer is hidden where the game draws one and shown elsewhere. The game's pointer follows the Windows pointer exactly:
the host works out the mouse movement the game's mouse routine needs to put its pointer under the Windows one (`port/input.c`).

| Screen | Windows pointer | May leave the 4:3 picture and the window |
|---|---|---|
| Hi-res (640x480) with the hockey glove | hidden while over the 4:3 picture and the window has focus | yes |
| Hi-res without the glove (splash screens, loading, Tonight's Lineup, ...) | always shown | yes |
| Lo-res (320x200): replay | hidden while over the 4:3 picture and the window has focus | yes |
| Lo-res: gameplay, either player has the mouse as a control device | hidden while the window has focus | no: kept on the 4:3 picture |

In fullscreen the Windows pointer is always kept on the 4:3 picture, and hidden wherever the rules above hide it. The Windows pointer menu
(Display) can force it always shown or always hidden.

How the host knows (`cursor_update` in `port/input.c`):

* Hi-res glove: the menus ask for an input event (`GetInputEvent`) every time round their loop, even when there is none, and move the pointer (`EventToPointer`)
  when there is one. The first instruction of both is replaced by an int3 (`port/emu.c`) that notes the time, so "the game asked for input in the
  last 0.3 s" means a menu with a glove is on the screen, moving the mouse or not. The splash screens and the loading screens never ask.
* Lo-res replay and other menus: the game gives the mouse driver a range other than the whole screen (the pointer's size is taken off it),
  or runs `EventToPointer`.
* Lo-res play with the mouse: `pad1dev` or `pad2dev` is 1 (the mouse), `curperiod` is not -1 (a game is running) and `dword_CCC9C`, which
  the game sets while it is paused or replaying, is 0. The pointer is then confined with `SDL_SetWindowMouseRect`.

### MT-32 with digital sound (not finished)

The original game treats the MT-32 like an AdLib: only MIDI. Its other devices have a second, digital sound driver (`SetSoundDevice`: music driver 2 FM,
4 MT-32, 5 Ultrasound; digital driver 3 Sound Blaster, 6 Ultrasound) and `musicon`, which lets the rest of the game play digital music, speech and
effects. `mt32_digital` in `port/overrides.c` (off unless `NHL95_MT32_DIGITAL=1`) patches the MT-32 branch at start-up (the code is checked first) to set up
the Sound Blaster's digital driver as well, with a scene file it makes (`MT32DIGI.SCN`: the MT-32 patch map and the digital timbres) and `musicon`.
`sounddev` stays 8, so the MT*.KMS songs stay the MT-32's. State: the digital music of the splash and title screens, the speech and the effects play;
the game crashes at the national anthem, and the MIDI notes are silent with the digital timbre table loaded (`NHL95_MT32_TIMS` picks the tables).

### Skipping the splash screens

A key or a mouse button pressed before the front end skips the screen that is showing: the pioneer screens, the EA Sports screen or the title screen, one at a time (`intro_skip`, `port/input.c`; the skip of a screen ends when the game starts the next one, which `port/emu.c` sees at `InitSpeechSlots` and `TitleScreen`):
the game's waits are cut to nothing (`SetTickDeadline` and `WaitTicks` in `port/overrides.c`), its clock, the retrace and the sound devices run fast,
the digital music is reported finished, and F12 (nothing in the game uses it) is pressed now and then for the title screen's "any key". It ends when
the menus ask for input. The loading picture (`ShowLoadingScreen`) is not shown; `NHL95_LOADSCREEN=1` brings it back.
