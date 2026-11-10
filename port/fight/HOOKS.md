# Fight hooks: what 95 PC still has, and how hooks.c joins rules.c to the game

Notes for `port/fight/hooks.c` (not written yet). Found 2026-11-09 by reading the asm and C in `src/`.

## What 95 PC kept from 93's fights

`pflags2` bit 0 is 93's `pf2fight`, and 95 PC still honours it:

- `CanBlockShot` (input.asm 4FEEE): a joystick player with it gets no `doplayeracc`.
- `checkob` (collide.asm 535C8), `FallDown` (562FF), 56A85, 56BAA: such a player is left out of collisions and
  falls.
- `checkcx` (58F40, 58F4E): `impactp` is not overwritten.
- `updateplayers` time-on-ice loop (hockey.asm 5AFBE): skipped.
- the puck's `pflags2` bit 0 (`puckpflags2`, skate.asm 5EA74): players face `xc1`/`yc1`.
- faceoffs clear it (faceoff.asm 5212D, logic.asm 4DAA9), with `gmode` bit 0 and `gmode2` bits 0 and 2.
- `pflags2` bit 6 still cuts the top speed to 1/8 (the injured fighter).

Not kept: `checkfight`, `SetInst`, `assfight`, `afwatch`, the Fighting penalties and their names (the penalty
name list ends at Checking from Behind and Penalty Shot), and any fight frames.

## Hook points

- **Start**: `checkcx` calls `checkcheck` at 58F99 (`call` rel32, eax = esi, edx = ecx, ebx = impact), after the
  impacts are added. That is where 93 ran `checkfight`. Patch the call to a thunk that calls `checkcheck`
  and then `fight_check(esi, ecx)`. esi and ecx survive `checkcheck`.
- **Each frame**: the main loop calls `updateplayers` at 5C1D3. Patch that call to a thunk that runs
  `fight_pass` for the fighters (copy in, pass, copy velocities and facing back), then `updateplayers`
  (it moves them by their velocity and applies friction, as rules_test's stand-in does).
- **Assignments**: `assinsert(p, a)` (main.asm 2653, eax = player, edx = slot) pushes onto the 8-entry ring,
  and the old one comes back when `assnum` goes +1. During the fight, the fighters get slot 0 (`rtss`, nothing)
  so their AI keeps off them, and the puck gets 26 (`pucknothing`). Watchers: 93's `afwatch` has no 95 PC slot,
  so the first version gives them nothing (they glide to a stop and face `xc1`/`yc1` through the puck's bit).
- **Penalties**: `AddPenalty2(p, pen)` (penalty.asm 102) puts the penalty in `PenBuf`. `penmintab` has 5-minute
  entries at 23 to 25, but there is no name or banner for Fighting. The name tables (`word_CD39C` banner
  index, the names in data engine_06) need two new entries, Fighting and Instigator, or the first version uses
  Roughing (2 minutes) as a stand-in. `Stop4Pen` stops play (gmode bit 0, whistle, faceoff spot).
- **Injury**: `setInjuryType` (collide.asm 3756) and `FallDown` (4113). 95 PC's injured player leaves the game
  through them; the bloody frames are 93's FA_INJURY.
- **Sound**: `punch_play(low)` (punch.c) on FE_PUNCH_HIGH / FE_PUNCH_LOW.

## Drawing

The 93 frames are not in 95 PC's sprite set. They are drawn in true colour over the converted frame in
video.c, at the fighter's screen spot (95 PC's camera transform of Xpos and Ypos). The colours are
`f93_palette` with `f93_pc95_colours`. The 95 PC sprite of a fighter is hidden while the 93 one is drawn.
Open questions for the screen check: the scale (95 PC's skaters are drawn larger than 93's 320 x 224 ones),
and whether a fighter drawn on top hides a 95 PC player who should be in front.

## Stages

1. Start, run and end a fight with 95 PC's own sprites (no 93 frames yet), punches heard, Roughing as the
   penalty, the Fights option on the Game page.
2. The 93 frames drawn in true colour, with the glove sprite and the bloody injury.
3. Fighting and Instigator penalties with their own names, the crowd and the banner, team-colour option.
