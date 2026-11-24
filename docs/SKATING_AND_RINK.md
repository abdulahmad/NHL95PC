# Skating and rink: NHL 95 PC vs. NHLPA 93 Genesis

A short summary of what is known so far about skating physics and rink geometry in NHL 95 PC
`HOCKEY.EXE`, compared with NHLPA 93 Genesis (93G). Addresses are linear addresses in the LE code
object (cseg01, base `0x10000`), the same ones used in `EXE_SEGMAP95PC.md` and `docs/name_map.csv`.

## Skating code

| Routine | Address | Role |
| --- | --- | --- |
| `skateto` | `5E93B` | Steer a player toward a target point |
| `playeracc` | `5EDAD` | Player acceleration / velocity update |
| `doplayeracc` | `5E16D` | Applies acceleration for one player |
| `dostop` | `5F745` | Stopping (deceleration) |
| `StopNA` | `5F82A` | Stop, no animation change |
| `goalieacc` | `5F8B2` | Goalie acceleration |
| `burst` | `532BD` | Speed burst |
| `updateplayers` | `5C40F` | Per-frame player update loop |

## Skating physics findings

| Item | NHL 95 PC | 93 Genesis |
| --- | --- | --- |
| Top speed range (by rating) | 5400 to 8400 | 5500 to 9625 |
| Acceleration | `(agility + 48) / 64` pre-factor on the push | `dir * (32 - (weight >> 3) + agility) >> 5`, no `(agility + 48) / 64` pre-factor |
| Push at agility 0 | 150 | 200 |
| Stop deceleration | `200 + agility` | `150` |
| Velocity cap | ±16000 | none |
| Fatigue | 40 | 33 |
| Timing | fixed step, no frame multiplier; 24 game steps per game-clock second, same as 94 PC (`ClockTick` `5DC10` reloads `clockticks` with `0x18` per second; `RunGameFrames` `1149A` runs one `ClockTick` per `DoGameFrame`) | variable step: 16 × vblanks elapsed per loop (`d7`) |

PC top speeds are lower and in a narrower band than 93G. On PC, acceleration is scaled by an extra `(agility + 48) / 64` factor and stopping scales with agility. Genesis has no speed cap, and it scales each step by the number of vblanks that passed. PC uses the same step every frame and runs 24 game steps per game-clock second, as 94 PC does.

## Rink geometry

| Item | NHL 95 PC | 93 Genesis |
| --- | --- | --- |
| Side boards | 160 | 136 |
| End boards | 264 | 298 |
| Goal lines | 232 | 264 |
| Blue lines | 78 | 88 |
| Shot vector multiplier (x and y alike) | x59 (0x3B) | x68 ($44) |
| Passing | as 93G: $78 to a teammate, `dirtab` 200 with no receiver | |
| Playfield on screen | 320 x 168 (score bar below) | 256 x 224 |

The PC rink is wider and shorter than 93G in game units. These are true world coordinates. There is
no display scaling layer between the simulation and the screen: one unit is one pixel on both axes on PC and on
Genesis (`DrawFrameSprite`: x + 0xC0, 0x140 - y; Genesis `find3d`), and the physics treat x and y alike. The shot
multiplier was cut by about the length ratio (59/68 = 0.868; 264/298 = 0.886), the same on both axes. Against the
1992-93 rink (200 x 85 ft) that is 3.76 units per foot across and 2.64 along on PC, 3.20 and 2.98 on 93G. See
`docs/CONSOLE_LINEAGE.md`, "Rink size, aspect ratio and per-axis scale".

Credits: see README.
