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
pacman -S --needed mingw-w64-i686-gcc mingw-w64-i686-SDL2 nasm make python
port/build-win.sh
```

The result is `build/win/hockey-win32.exe` and `SDL2.dll`. Run it in the folder with the game's data, or set `NHL95_ROOT`. A Windows image
may have only 96 sections, so the build folds the sources' 304 sections into `.text`, `.data` and `.bss`. The program must be 32-bit:
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
`NHL95_DUMP=/dir` (with `SDL_VIDEODRIVER=dummy`) writes a PPM of the screen about twice a second; `port/where.py ADDR` maps a runtime address
to the original address and the asm around it.

## State (2026-10-25)

Works with a stub `NHL.CFG` and `ALLFILES.TXT` and no other data: C start-up, the EA memory manager, file-location setup, hooking of the
timer and keyboard interrupts, the VESA mode set at 640x480 with bank switching, and the first asset loads (which fail on the missing files).
Not yet seen with the real game data, so everything after the first asset load is untested.

Not done: sound (the game's drivers talk to the OPL, Sound Blaster, GUS and PC speaker; the plan is to replace the high-level sound calls
with an SDL2 mixer), joystick (SDL game controller instead of port 201h), the CD-ROM and movie player, fullscreen and scaling options.

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
