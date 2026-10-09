# Skating and rink: NHL 95 PC vs. NHLPA 93 Genesis

A short summary of what is known so far about skating physics and rink geometry in NHL 95 PC
`HOCKEY.EXE`, compared with NHLPA 93 Genesis (93G). Addresses are linear addresses in the LE code
object (cseg01, base `0x10000`), the same ones used in `EXE_SEGMAP95PC.md` and `name_map_94.csv`.

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
| Acceleration factor | `(agility + 48) / 64` | |
| Stop deceleration | `200 + agility` | `150` |
| Velocity cap | ±16000 | |
| Fatigue | 40 | 33 |
| Update rate | fixed 60 Hz | |

PC top speeds are lower and in a narrower band than 93G. Acceleration and stopping scale with agility.

## Rink geometry

| Item | NHL 95 PC | 93 Genesis |
| --- | --- | --- |
| Side boards | 160 | 136 |
| End boards | 264 | 298 |
| Goal lines | 232 | 264 |
| Blue lines | 78 | 88 |
| Shots (x value) | 59 | 68 |
| Passing | unchanged | |

The PC rink is wider and shorter than 93G in game units. These are true world coordinates. There is
no display scaling layer between the simulation and the screen.
