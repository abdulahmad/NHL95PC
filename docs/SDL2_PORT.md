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

The host menu, overlay and scaler are [Overbar](https://github.com/abdulahmad/overbar), the git submodule `port/overbar`:
clone with `--recurse-submodules`, or run `git submodule update --init` once after a plain clone. The build scripts
read Overbar's file list from `port/overbar/sources.txt`.

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
`NHL95_AUTOLINE=1` turns on the Game page's Auto line changes (96 PC Auto: CompLine at faceoff for a human team, chk4lc on the fly);
`NHL95_GOALIE=1` turns on Manual goalie (96 PC: B-hold takes the goalie, A dives, C a save; 94 Genesis movement);
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
`NHL95_AUTOLINE=1`, `NHL95_GOALIE=1`, `NHL95_DUMP`, `NHL95_WAV`; `port/where.py` maps a runtime address (set `NM` to the nm of the toolchain). `CRASH ...` lines come from the last
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
2. custom keyboard bindings, 3. four players, 4. rollback netcode. These change game logic, so
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

In fullscreen the Windows pointer is always kept on the 4:3 picture, hidden wherever the rules above hide it, and always hidden during a
game (from the face-off to the end, the pause and the replay too), whatever the control devices. The Windows pointer menu
(Display) can force it always shown or always hidden.

How the host knows (`cursor_update` in `port/input.c`):

* Hi-res glove: the menus ask for an input event (`GetInputEvent`) every time round their loop, even when there is none, and move the pointer (`EventToPointer`)
  when there is one. The first instruction of both is replaced by an int3 (`port/emu.c`) that notes the time, so "the game asked for input in the
  last 0.3 s" means a menu with a glove is on the screen, moving the mouse or not. The splash screens and the loading screens never ask.
* Lo-res replay and other menus: the game gives the mouse driver a range other than the whole screen (the pointer's size is taken off it),
  or runs `EventToPointer`.
* Lo-res play with the mouse: `pad1dev` or `pad2dev` is 1 (the mouse), `curperiod` is not -1 (a game is running) and `dword_CCC9C`, which
  the game sets while it is paused or replaying, is 0. The pointer is then confined with `SDL_SetWindowMouseRect`.

### Input bindings

Options > Input bindings... (`port/bindings.c`, `port/bindings_win.c`). Keys are stored as XT scan codes (0x100 added for the extended ones), mouse buttons as SDL numbers, controller buttons as the SDL button plus 2. A key bound to an action sends the game's own key for it; the game's default key of a rebound action stops working. The window is painted by hand (flat dark panel, draggable title bar) and modal: it runs its own message loop in the main thread, so the game stays paused and muted until Apply or Cancel. Hold / change line sends Alt+Space (the Genesis A button). The remap is only on while a game is on (`curperiod != -1`), so menus and text fields keep the normal keys. `NHL95_MENUTRACE=1` prints menu commands and window creation to stderr.

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

### Online play

Two machines play one exhibition game with rollback netcode (`port/netplay.c`, on Overbar's netplay core, `port/overbar/include/overbar/net.h`). The
simulation reads its pads only through the input records of `joyqueue` (pad 1, pad 2, hot key; one per 3 game frames, 20 a second), so both machines
run the same game from the same records. No game state is sent. When the other machine's buttons for a record are late, this machine guesses them
(holding the last ones) and goes on; when the real ones differ, it loads the state it saved before that record and plays the records again, without
drawing, with the right buttons (`ob_net_frame`). `NHL95_LOCKSTEP=1` (on both machines) plays in lockstep instead: a record waits for every machine's buttons.
The original game has no modem, serial or IPX play.

**States.** The game asks for its next record (`nh_peek`, outside any interrupt) with the queue empty: that is the resumable point. `rb_make` takes the
state there: the game's data (on Windows found by symbol: the link folds the sections into `.data` / `.bss`), the DOS memory and DPMI blocks, the queue's
variables, the game's code (it patches itself) and the game thread's stack (`__builtin_setjmp`; `snap_jump` comes back to the same call). Only the pages
that differ from a base copy are stored (`port/snap.c`); the DPMI blocks, which are most of the 68 MB, are `MEM_WRITE_WATCH` memory so only the pages written
since the base are compared (about 11 ms a state). Not part of a state: the sound chips' (a replayed record's sound events play again), the timer's
counters. The test aids are `NHL95_ONLINE=host|join` (arm a session on 127.0.0.1; `NHL95_PORT`), `NHL95_NETSIM="delay,jitter,loss%"`, `NHL95_AUTOPAD=1`
(each pad moves by itself, so guesses go wrong), `NHL95_AUTOSKIP=1` (skips the intro, starts an exhibition game and presses Play by itself) and
`NHL95_SNAPTEST=1` (a state round trip with no network).

**How a session starts.** The Online page's Host / Connect only arms online play. Each player then starts an exhibition game from the game's
own menus; `PlayGame` (main.asm, at its entry) waits there, with the Online page open, until the other machine is there too. The host's
settings then go to the guest: the teams (`HomeTeam`, `VisTeam`), `gamemode` and `gameopts` (period length, penalties, sound options), the
controller sides (`ctl1team`/`ctl1side`, `ctl2team`/`ctl2side`; when the host set up only one player, the guest takes the other team), the
engine's random seed (`seed`, randomd0) and the C library's (`randseed`), `PerTimeTab[0]` and the host's time of day. Both machines then run
`InitGameSummary(0)` again (the game summary, and the rosters from the league database for those teams, as `MenuNewExhibition` did) and
`PlayGame` goes on: the loading, `SetupGame`, the play. The host is pad 1, the guest pad 2; each machine reads its own controller 1 (keyboard,
stick A or stick B; the mouse can't play online). Once the game is over and its three stars have ended, the rest (the post-game desk) is
local; the session ends when `PlayGame` returns, and each machine's own menu settings are put back. A
loaded game, a season or the playoffs are not online (the page says so and stays armed for an exhibition game).

**The records.** `SampleInputTick` is taken over: every 5 ticks this machine's pad and hot key (`ReadControllerPad`, `ReadHotKeys`) go to
`ob_net_step` as its buttons for the next step. Only once that step has both machines' buttons is the merged record put in a queue of
`netplay.c`, which `joyq_peek` / `joyq_pop` read instead of `joyqueue`. A step that is not complete yet is asked again at the next tick (the
timer callback runs inside the game's timer interrupt and never waits); meanwhile `RunGameFrames` finds no record and only draws, as it always
did. `joyq_flush` does nothing in a session (how many records wait at a given moment is not the same on both machines). The input delay is the
Online page's (default 2 steps, 100 ms; up to 10). The main thread polls the socket every pass of its loop. While the overlay is open the game
keeps running (IRQ 0 is raised) and this machine's pad reads as nothing; the sound is muted as usual.

**What is made the same on both machines.**
* `RunGameFrames` runs at most to the end of the record it is on (the frames it could not run come with the next call), and gives back in `edx`
  the frames it really ran. The intro / three stars loop (`ThreeStarsLoop`) counts its timer with that.
* The pre-game intro and the three stars end at the end of their first record (their "press a button" test, in the loop between game frames,
  is answered there; the game's own skip path follows).
* `Crowd_Noise` (called between game frames) gives back what it drew from `seed`.
* `PaSpeechBusy` and `SpeechBusy` say 0: the play does not wait for the announcer, whose timing is the sound card's.
* `IntermissionPC` only moves to the next period: the intermission desk (stats, highlights, the desk's menus) is skipped online.
* DOS get-time (int 21h/2Ch) counts from the host's time by the records run.
* The identity both machines must have: the build (`git describe`), the sound device (`sounddev`) and `musicon` (several game routines draw
  random numbers or wait only with digital sound). The game's data files are not part of it: rosters that differ show as a desync at once.

**Hot keys online.** F1-F8 (line changes), F9 / F10 (goalie) and Tab (numbers) work from either player (the host's wins when both press one at
the same step). Esc (the sports desk), R (instant replay), S and M (sound) are dropped: they open local menus or change local settings. To leave,
use Leave on the Online page; the game then goes on locally, the other player's team played by the computer.

**The desync check.** At the first record and every 60 records (3 s) both machines hash what `SaveGameState` keeps of the players
(`SortCords`, 0x66 bytes of each of the 17), both team structures (0xD4 bytes each), the lines, `seed`, the clock, the period, `lj1`/`lj2` and the
crowd level; a difference ends the session as "desync at step N" on both. No check runs once `gameover` is set.

Not known yet (nothing here could be run): whether anything else between game frames writes the simulation (the check would say), and whether
choices made in the pre-game screen (lines, goalies) are kept in memory the guest does not get; use the defaults there.
