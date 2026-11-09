# NHLPA 93 fights for the SDL2 port

95 PC's own code for NHLPA 93's fights and bloody injuries (plan: the "Bring NHLPA 93 fights and blood to 95 PC" doc).
Built from the [NHLPA93Genesis](https://github.com/abdulahmad/NHLPA93Genesis) disassembly by abdulahmad, with thanks to
chaos, StaticEck, McMarkis (Mhopkinsinc) and Drezz, and special thanks to smozoma and kingraph.

- `rom93.c`: finds your NHLPA 93 Genesis ROM (Rev 0, A or B, any file name) beside the program or in the game folder,
  and reads the glove, fight and injury frames (with the blood), the team colours and the punch sample from it.
  Nothing from 93 is in this repository.
- `punch.c`: the punch, mixed into the port's sound at the two rates the 93 sound driver plays it (high 4780 Hz, low
  6454 Hz: measured by running 93's 68000 and Z80 sound drivers in NHL9XStudio).
- `rules.c`: a C copy of 93's checkfight, SetInst, fightinput, assfight and chkhit and the fight animations, on two
  fighters of its own; the game's random numbers drive it, so fights replay the same and online play stays in step.

Not yet in the build: the hooks that start a fight from a check in 95 PC, draw the frames (in true colour, over a
marker colour in the game's picture), call the penalties and pick the bloody injury. Those need the game running.

Tests: `sh port/fight_test.sh <folder with your NHLPA 93 ROMs>` (the ROM tests skip without one).
