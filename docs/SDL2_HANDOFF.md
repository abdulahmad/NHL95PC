# SDL2 port: handoff (2026-10-26)

Branch `sdl2-port`. Read `docs/SDL2_PORT.md` first (how the port works and its State section), then this.

## Where things are

The Windows build (`port/build-win.sh`, MSYS2 MINGW32) runs the real game: intro, front end, exhibition games, the demo, and all sound
modes (none, PC speaker, AdLib, Sound Blaster, MT-32 through Munt, Gravis UltraSound) were listened to on the author's PC. Run it from
the game folder; the program finds the Gravis patches (`..\ULTRASND`) and the MT-32 ROMs (`roms` next to the exe) by itself.

## Joystick (done, checked only with a fake stick)

`port/input.c`: the PC game port 201h from the first two SDL game controllers or joysticks (stick A, stick B). Axis bits stay set for a number
of reads (20 to 220) after a write to 201h, not for a time (the game counts loop iterations with interrupts off, and a trapped read is slow).
Buttons are the active-low bits 4 to 7. Left stick or direction pad, A/X and B/Y.

- Checked: with `NHL95_JOY="0,0,0,0"` (a fake centred stick) the game shows its own calibration screen after the intro, the puck follows
  scripted corner positions (`NHL95_KEYS="39000:@joy=-100,-100,0,0 ..."`), a button press ends the calibration, and the calibrated stick
  moves the pointer on the desk.
- **Not checked: a real pad**, and playing a game with it (player 1 / player 2 controls are chosen in the game's Game menu). Things to try:
  hot-plugging, a pad with odd axes, two pads for two players, the calibration being kept between runs (the game saves it in its settings).
- `NHL95_NOJOY=1` turns the joystick off (some PCs list odd HID devices as joysticks and the game would ask to calibrate each start).

## Next, as asked: video (not started)

Now: `port/video.c` keeps the 8-bit frame, converts it with the palette to 32-bit once per frame (about 0.3 ms) and gives it to SDL's
accelerated renderer (nearest filter, vsync, logical size 640x480; 320x200 is shown as 320x240 for its non-square pixels). Modes: 320x200
(mode 13h) in games, 640x480 (VESA 101h) in the front end, about 50 and 10 to 40 different images a second respectively (`NHL95_STATS=1`
prints the screen size and the number of different images per second).

Wanted: bilinear (or better) filtering for the 640x480 screens; for 320x200 a 3x integer nearest-neighbour scale, then a bilinear
stretch to the window at the correct aspect ratio; Alt+Enter for borderless ("desktop") fullscreen. SDL2's renderer cannot run custom
shaders; "sharp bilinear" (integer prescale, then linear stretch) is possible with a render target; anything better (bicubic, Lanczos, CRT
looks) needs an OpenGL or Direct3D path with a shader.

## Other open items

- Linux: the Windows work was not built there. The Linux build probably needs the same fix as Windows (the game's zero-filled data sections
  were folded into `.bss`, which broke the GUS driver's table clearing; see `port/build-win.sh`).
- Digital audio in MT-32 mode (the original game plays only music there; the author would like the digital sound too).
- Gameplay with the keyboard has not been checked in detail.
- Later (unchanged): manual goalie, automatic line changes, key bindings, four players, rollback netcode (see `docs/SDL2_PORT.md`).

## Diagnosing a machine

`nhl95-audio.log` (next to the exe) and Ctrl+F11 (records the mixed sound to `nhl95-capture-N.wav`) work without any setting; `NHL95_TRACE`,
`NHL95_STATS`, `NHL95_KEYS`, `NHL95_DUMP`, `NHL95_WAV` are described in `docs/SDL2_PORT.md`.
