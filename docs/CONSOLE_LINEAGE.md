# NHL '95 PC compared with the other versions

For each feature: is 95 PC (DOS, 1994) the same as 94 PC (DOS "NHL Hockey", 1993), the 94 consoles and the 95
consoles, and if not, how it differs. Under each answer is the code that shows it: the routine, table or data file in
each repo. Files are paths in this repo, or in [NHL94PC](https://github.com/abdulahmad/NHL94PC),
[NHL94Genesis](https://github.com/abdulahmad/NHL94Genesis) (94G), [NHL94SNES](https://github.com/abdulahmad/NHL94SNES)
(94S), [NHL95Genesis](https://github.com/abdulahmad/NHL95Genesis) (95G) and
[NHL95SNES](https://github.com/abdulahmad/NHL95SNES) (95S). The follow-up to the 94 PC page,
[NHL94PC `docs/CONSOLE_LINEAGE.md`](https://github.com/abdulahmad/NHL94PC/blob/main/docs/CONSOLE_LINEAGE.md), which
compares 94 PC with the 93 and 94 consoles; the physics units are the same as there.

95 PC's evidence is this repo's decompilation of `HOCKEY.EXE` (`src/`) and the retail data files (`TEAMS.DB`,
`KEY.DB`, `.KMS` / `.CFG`, `.IFF`). Addresses are the linear addresses in the routine headers; labels are the repo's
current names. A label taken from a console game doesn't by itself mean the code is the same: under `docs/RULES.md`,
the DOS season, trade, create-player and awards screens share strings and labels with 95G but not code. 95S naming is
still early (its animation table is only partly named and its physics weren't traced), so most 95 console answers
lean on 95G. "Not found" means the search of that repo found nothing. "Data" means a string, table or data file shows
it but the logic wasn't traced. Written 2026-11-24.

## At a glance

"New" means 95 PC has it and 94 PC doesn't. "95 PC only" means none of the four console games has it
(and 94 PC doesn't either); "94 and 95 PC only" means both PC games have it and no console game does. "Missing on
95 PC" means the console games have it and 95 PC doesn't. Where 94G and 94S (or 95G and 95S) differ, the section says which.

| Feature | 94 PC | 94 consoles | 95 consoles |
|---|---|---|---|
| Fighting | Same (none) | Same (none) | Same (none) |
| Board, bench, cross-checks | New | Same idea | Same idea |
| One-timers | Same | Same as 94S | Not compared |
| Fake one-timer | New | 95 PC only | 95 PC only |
| Fake shot | New | 95 PC only | Different |
| Shot blocking | New | 95 PC only | Different |
| Drop pass | New | 95 PC only | Different |
| Practice (2-on-2) | Same (none) | Same (none) | Missing on 95 PC |
| Penalty shots | New | Same idea | Same idea |
| Shootout | Same (none) | Missing on 95 PC | Missing on 95 PC |
| Goalie poke check | New | Same idea as 94S | Same idea as 95S |
| Goalie knee hold | New | 95 PC only | 95 PC only |
| Goalie falls | New | 95 PC only | Same (two of three) |
| Manual goalie | Same | Missing on 95 PC | Missing on 95 PC |
| More than 2 players | Same (none) | Missing on 95 PC | Different |
| Penalties | Adds 4 | Different | Different |
| Line changes | Same | Not compared | Not compared |
| In-game team stats | Changed | Different | Different |
| Roster tools | New | 95 PC only | Same idea |
| Trades | Same | Not compared | Different |
| Awards | Same, subtitles new | 94 and 95 PC only | Different |
| Divisions, rosters | Changed | Different | Same |
| Skating physics | Changed | Different | Different |
| Announcer, video | Changed | 94 and 95 PC only | 94 and 95 PC only |
| Music | Same, adds `.IFF` | Same as 94S | Not compared |

## Fighting

- **95 PC: none.** `checkcx` (58DC7, src/engine/collide/checkcx.c) calls only `newcheck`, `checkint`, `checkcheck`,
  then `vtoa` / `doplayeracc`. `asstab` slot 20 (src/data/engine/faceoff_hockey.asm), the 94 `assfight` slot, is
  `assstarskate`. No fight animation in the SPA list and no fight penalty.
- **vs 94 PC: same (none).**
- **vs 94 consoles: same (none).** Fighting was a 93 feature (93G / 93S). 94G's `checkfight` is a bare `rts`; 94S keeps
  the fight penalties and rating but has no fight code.
- **vs 95 consoles: same (none).** 95G's `assfight` is a bare `rts`; no fight code was found in 95S.

## Board checks, bench check, cross-check

- **95 PC:** `FallDown` (562DB, src/engine/bodycheck/FallDown.c) picks `SPAboardfront/back/left/right` and
  `SPAbenchcheckl/r` near the boards and gives a boarding penalty (types 0x18 / 0x14) on a board fall. `checkcheck`
  (5382C, src/engine/checking/checkcheck.c) plays `SPAcrosscheck` with a Cross-checking or Roughing penalty.
- **vs 94 PC: new.** 94 PC's `FallDown` uses only the fall, flip, stumble and injury animations.
- **vs 94 consoles and 95 consoles: same idea.** 94G, 94S, 95G and 95S all have them. 94G's `SPAinjuryfall` is still
  missing on 95 PC.

## One-timers

- **95 PC:** `assonetimer` (50B55, src/engine/input/input.asm) still builds the vector to goal and calls `Findhittype`
  (src/engine/puckphys/Findhittype.c) for forehand / backhand. `OneTimerChk` and `asspassrec` call it as in 94 PC.
- **vs 94 PC: same.** 94 PC has the same `assonetimer` with `Findhittype` (NHL94PC src/engine/input.asm).
- **vs 94 SNES: same design.** 94S's `asspassrec` picks the forehand or backhand one-timer with `Findhittype`
  (src/routines/logic/assignments/asspassrec.asm: `SPAonetimerf` / `SPAonetimerb`).
- **vs 95 consoles:** not compared.

## Fake one-timer

- **95 PC:** `ShotMode` (578FA, src/engine/puckphys/ShotMode.c): a release (`regd1` bit 0x10 / 0x40) before wind-up
  frame 10 of a one-timer switches to `SPAfakeonetimef` / `SPAfakeonetimeb` and no shot is taken (the same abort as
  the fake shot below).
- **vs 94 PC: new.**
- **vs the consoles: 95 PC only.** No console game has a fake one-timer animation.

## Fake shot

- **95 PC:** C, pressed by the carrier (not the goalie), calls `SetShotMode` (src/engine/puckphys/SetShotMode.c), the
  wind-up. Every frame `ShotMode` (578FA) shoots (`doshot`) from wind-up frame 0Eh. Before frame 10, a new B press (or
  A) ends the wind-up with no shot: it clears `sflags` bit 3, never reaches `doshot`, and switches the animation to
  `SPAfakeshotf` / `SPAfakeshotb` (`SPAfakeonetimef` / `b` in a one-timer wind-up). The routine header calls these
  the follow-through, so the "fake" is an early abort of the wind-up rather than a separate deke animation. How it
  looks in a real game wasn't checked.
- **vs 94 PC: new.** A wind-up always ends in a shot.
- **vs 94 consoles: 95 PC only.** 94G and 94S have none.
- **vs 95 Genesis: same idea, different trigger.** 95G's fake shot is "A released in the attacking zone"
  (`input95.asm`), with the same `SPAfakeshotf` name. That 95 PC copies 95G is inferred from the name.
- **vs 95 SNES: missing there.** 95S's `ShotMode` (src/routines/engine/logic/assshoot.asm) has no exit without a shot:
  it shoots at frame `$18`, and its only other branch (a flag in `d2` bit `$80`) jumps the wind-up forward to `$1C`
  and shoots sooner.

## Shot blocking

- **95 PC:** players dive or drop to block shots: `CanBlockShot` (4FFEE, src/engine/input/CanBlockShot.c),
  `TryBlockShot` (src/engine/checking/TryBlockShot.c), `BlockShotDive` (53387, src/engine/checking/BlockShotDive.c)
  and four animations, `SPAblockfront`, `SPAblockknee`, `SPAblockleft`, `SPAblockright`. `Holdplayer`
  (src/engine/input/Holdplayer.c) holds an opponent in reach, else dives (`CanBlockShot`, `BlockShotDive`), else
  checks.
- **vs 94 PC: new.**
- **vs 94 consoles: 95 PC only.** 94G and 94S have no shot blocking.
- **vs 95 Genesis: different.** 95G has `CanBlock` / `chkblock` and one block animation (`SPAblock`); 95 PC's four
  animations and its routines are its own. 95S: not found by name.

## Drop pass

- **95 PC: contextual.** A pass aimed at a teammate trailing the carrier in the attacking zone, with the shooting lane
  blocked, leaves the puck almost dead on the ice (`PassLaneChk`, `ScatterPass`, src/engine/pass/). There is no drop
  animation: `dopass` still plays `SPApassf` / `SPApassb`, which is why no drop pass was found by name before. Traced
  in code, not played. Details below.
- **vs 94 PC: new.** 94 PC's `dopass` (28BB:0B96, NHL94PC src/engine/physics.asm) goes straight from the receiver search
  to `passtoa0` or the `passdir` pass. It has no lane check, no `passlane` byte and no `ScatterPass`.
- **vs 94 consoles: 95 PC only.**
- **vs 95 Genesis: different.** 95G's drop pass is a button move, A with the d-pad back (`GameFlags` bit 1,
  `input95.asm` `dopass`): a flat pass at a quarter of the speed, with `nopuck` 18h and its own animation
  (`SPAdroppass` / `SPApassb2`).
- **vs 95 SNES: missing there.** 95S's `dopass` (src/routines/engine/input/dopass.asm) has a fixed `nopuck` of 10h
  and no drop branch.

### How the drop pass works

The buttons: `ReadJoy1` / `ReadJoy2` (src/engine/input/ReadJoy1.c) give `doinput` (504DA) three game buttons, `regd1`
bit 0x10 (B), 0x20 (C) and 0x40 (A). B passes and C shoots (the routines below); which physical button or key sets
each bit: not confirmed in code.

1. B, pressed by the carrier, calls `setpassmode` (551AF): `passdir` = facing. While B is held, `passmode` (5514E)
   takes the stick direction as `passdir`. On the release it calls `dopass` (54DF4, src/engine/pass/dopass.c).
2. `dopass` picks the receiver: the closest skater on the team (not a goalie, not unavailable) whose direction from the
   puck is within one 45° step of `passdir`. One straight along `passdir` is preferred (the others get + 0x10000).
3. A human passer (`pflags` bit 3) with a receiver goes through `PassLaneChk` (54C09). When that returns 1, `dopass`
   calls `ScatterPass` (54D63) and stops. Otherwise it is a normal pass (`passtoa0`, 551CF), or, with no receiver, the
   puck goes along `passdir` at the pass speed plus the passer's velocity.
4. The computer uses the same drop: `chk4pass` (55493, src/engine/pass/checkob.c) stores `PassLaneChk`'s result in the
   passer's `passlane` byte, and `dopass` then calls `ScatterPass` for it.

`PassLaneChk` returns 1 only when every test in this table holds:

| Test | Needed |
|---|---|
| Passer | Not the goalie |
| Shot lane | `ShotLaneOpen` (64102) returns 0: an opposing skater is between the carrier and the net |
| Passer's y | Past the attacking blue line (4Eh), no deeper than 76h |
| Receiver's y | Nearer the blue line than the passer (behind him) |
| Both | Skating toward the attacked end (y velocity sign) |
| Gap | At most 3Ch in y and 28h in x |
| Receiver's heading | Within one 45° step of the direction to the passer |

- It also compares the signs of (passer y - 4Eh) and (receiver y + the high byte of his y velocity - 4Eh). Both ends
  use +4Eh, so this only rules anything out at the +y end. Whether that was meant: not confirmed in code.
- The check exits when `ShotLaneOpen` returns 1, which it does for an open lane, so a drop pass needs the lane blocked.

`ScatterPass` is the drop:

- The puck's z speed is 0 (no lift).
- Its x and y speeds are each `randomd0((12h - passacc) x 14h)`. `randomd0(n)` is 0 to n - 1
  (src/engine/asm_helpers/asm_helpers.asm), and a skater's `passacc` is 0-15 (`changeplayer`), so each is under 360,
  and never negative. Skater top speeds are 5400-8400 (`MaxSpeed`), so the puck stays almost where it was let go,
  creeping a little toward +x / +y. A better passer leaves it deader.
- The passer can't touch the puck for 28h frames (`nopuck`; a normal pass is 10h). The receiver gets assignment 13h
  (take the pass) and skates onto it, and the team's pass count goes up.

## Practice mode (2-on-2)

- **95 PC: none.** No practice string or label.
- **vs 94 PC and 94 consoles: same (none).** 94G and 94S have none.
- **vs 95 Genesis: missing on 95 PC.** 95G has Practice Mode (`setup95.asm` play modes; `sflags9` bit 7). Each side gets
  0, 1 or 2 skaters (`PracticePlayersTbl`, `PrintPracticePlayers`), and `PullPracticePlayers` (`goal95.asm`) takes the
  rest off the ice. There is no icing, every rush counts as a breakaway, and `PracticeGoalies` sets the goalie mode
  for a side with a pad and no skaters. The word "Jam" wasn't found in 95G's strings.
- **vs 95 SNES: missing on 95 PC.** 95S has the same mode (`PracticeOptions`: Home Players / Visitor Players; Data).

## Penalty shots

- **95 PC:** `holdcheck` (56B79, src/engine/bodycheck/holdcheck.c) and `Bcheck` (56A54, src/engine/bodycheck/Bcheck.c)
  call `QuickShotChk` (6427F, src/engine/penalty/QuickShotChk.c): if the fouled player is a human puck carrier with a
  shot on goal from near the net, `AddPenalty` gets type 0x1A "Penalty Shot" instead of the foul, so there is no box
  time. `InProgress` then runs `StartPenaltyShot` (64398) and `SetupPenaltyShot` (63F72). The shooter is
  `asspenshooter` (4FAE8, src/engine/shootoutpath/asspenshooter.c) on the 94G path code (`ShootoutPathData`,
  `StartShootoutPath`, `NextPathPoint`). The clock is held (`ClockTick` 5DC10, `penshottimer`). `doshot` gives the
  shot at least skater speed + 0x1F4 while `penshotlive` is set. The referee has `SPArefpenshot` / `assrefpenshot` and
  the announcer `SayPenaltyShot` / `PaPenaltyShot`. Whether the foul has to be from behind: not confirmed in code.
- **vs 94 PC: new.** 94 PC's `checkcheck` calls `AddPenalty` with no breakaway test.
- **vs 94 consoles: same idea, different trigger.** 94G and 94S have `PenShotChk`. 94G uses a breakaway flag and a
  penalty-shot form of each penalty; 95 PC uses one penalty type.
- **vs 95 consoles: same idea.** 95G and 95S have it too.

## Shootout

- **95 PC: none.** No "Shootout" string. `PeriodOver` (src/engine/hockey/PeriodOver.c): game state 3 is sudden-death
  overtime and 4 is game over; `gameopts.fullot` makes overtime full length. The labels and comments that say shootout
  (`clockcont_0`, the `checkwindow` "gsp 4 shootout" comment, the `shootoutpath` module) are names carried over from
  94G. That path code runs the penalty shot.
- **vs 94 PC: same (none).**
- **vs 94 consoles and 95 consoles: missing on 95 PC.** They all have one: 94G (`shootout94.asm`), 94S, 95G
  (`shootout95.asm`) and 95S (`ShootoutWonBy`).

## Goalie AI and animations

- **Poke check, 95 PC:** `assgoalie` (src/engine/goalie/assgoalie.c) plays `SPAgoaliepoke` when the puck carrier is
  within 0x23 and a random byte is under 10. **vs 94 PC: new.** **vs 94S and 95S: same idea** (their `assgoalie` has
  `SPAgpoke`; the likeness is inferred). **vs 94G and 95G:** missing there.
- **Knee hold, 95 PC:** `assgoalie` holds the puck on the knee when an attacker is close (`SPAgokneehold`,
  `SPAgoalieknee`). **vs 94 PC: new. vs the consoles: 95 PC only.**
- **Falls on hard shots, 95 PC:** `puckgoalie` (57096, src/engine/puckphys/puckgoalie.c) picks from the `gofallback` ..
  `gofallstick` range on hard shots (`SPAgofallback`, `SPAgofallglove`, `SPAgofallstick`). **vs 94 PC: new. vs 95G:
  same for the first two** (same names in 95G); `gofallstick` is 95 PC only.
- **Wall animations:** `SPAgwallleft` / `SPAgwallright` are still in the SPA list (Data). **vs 94 PC and 94S: same.**
- **94G's goalie animations** (`SPAghighl/r`, `SPAgslambot/top`, `SPAgstick2l/r`) are in neither PC game's SPA list.
- How often the CPU goalie's poke check and knee hold fire wasn't measured.

## Manual goalie control

- **95 PC:** a human takes the goalie only while he holds the puck (`dopass`, 54DF4). No manual-goalie menu string.
- **vs 94 PC: same.**
- **vs 94 consoles: missing on 95 PC.** 94G has a "Manual Goalie" option (`menu94.asm`); 94S an Automatic / Manual goalie
  option (`GoalieOptionText`).
- **vs 95 Genesis: missing on 95 PC.** 95G has a MANUAL GOALIE / AUTO GOALIE pause option (`pause95.asm`). 95S: not
  checked.

## Number of players

- **95 PC: two in a game.** Only `cont1team` / `cont2team`. Both can be on the same team: `StartPer`
  (src/engine/control/findpc.c) gives pad 2 the player before pad 1's when `cont2team` equals `cont1team`. A league can
  have several human teams ("Select human controlled teams" in the league setup; Data).
- **vs 94 PC: same.**
- **vs 94 consoles: missing on 95 PC.** 94G has "4 Way" play (`optsetup94.asm`); 94S up to five pads with the MultiPlayer
  5 multitap (`Multi5ConnectCheck`, `cont1team`-`cont5team`).
- **vs 95 Genesis: missing on 95 PC.** 95G has `FourWayPlay`.
- **vs 95 SNES: same in effect.** 95S has all the multitap code but switches it off (below).

### 95S multitap

The 95S code has the full 94S multitap support (`Multi5Init`, `Multi5Bios`, five pads, `cont1team`-`cont5team`, the
five-pad icons in `ShowConnectedPads`), but the connect check never reports a multitap. The table compares the two
connect checks, NHL94SNES src/routines/middle/Multi5ConnectCheck.asm and NHL95SNES
src/routines/engine/middle/Multi5ConnectCheck.asm:

| | 94S | 95S |
|---|---|---|
| Routine | `Multi5ConnectCheck`, bank $9B | $C36F88 |
| Port 1 found | `lda #$80` / `sta mp5connect` (line 44) | `lda #$00` / `sta` (line 43) |
| Port 2 found | `lda #$40` / `tsb mp5connect` (line 53) | `lda #$00` / `sta` (line 52) |

- The signature reads and the compares before these stores are the same. With `mp5connect` always 0, `Multi5Init` and
  `Multi5Bios` always clear bit 0 of `mp5present`, so pads 3-5 are never read. One value per port was changed, rather
  than the code removed, which matches what Abdul heard.
- The NHL94 forums thread "NHL 95-97 5 player mod"
  (https://forum.nhl94.com/index.php?/topic/38177-nhl-95-97-5-player-mod/) covers it. The Cutting Room Floor's NHL 95
  (SNES) page (https://tcrf.net/NHL_95_(SNES)) gives the same two operands, $C36FD9 and $C36FEC, set to $40 to turn it
  back on. Those are the two `lda #$00` operands. The NHL95 Discord couldn't be searched.

## Penalties and injuries

- **95 PC:** the 94 PC list (Roughing, Charging, Slashing, Cross-checking, Hooking, Tripping, Interference, Holding,
  Abuse of Official, Checking from Behind) plus High-sticking, Boarding, Elbowing and Penalty Shot (penalty name
  strings; Data). New referee signals `SPArefelbow` and `SPArefhistick`; boarding comes from `FallDown` (Code).
- **vs 94 PC: adds four.**
- **vs 94G and 95G: different.** High-sticking, Boarding and Elbowing are not in their penalty lists, which instead
  still list the unused Fighting penalties. The Penalty Shot follows 94 (see Penalty shots).
- **Injuries: same as 94 PC.** An injured skater's top-speed index is cut to 1/8 (`pflags2` bit 6, `playeracc`
  5EDAD).

## Line changes and starting lines

- **95 PC: same as 94 PC.** The same routines are in both games, as listed in the table. Only with line changes on
  (`gameopts` bit 2). The fatigue drain per tick is bigger (see Skating and shooting physics).
- **vs the consoles:** not compared.

The table gives each part's 95 PC routine and address, then the 94 PC address of the same routine:

| Part | 95 PC | 94 PC |
|---|---|---|
| Open the box (A, carrier) | `SetLCmode` 4D9FC | 2519:2436 |
| The box | `lineinput` 4FD8E | 2C24:0050 |
| Take a choice | `lcfound` / `getlchoice` | 2C24:0608 / 05C0 |
| F1-F4, F5-F8 | `HandleHotKey` 1118F, `lcselect` | 1E7E:01DC |
| Computer | `chk4lc` 54AF9 | 28BB:0AA0 |
| Off to the bench | `check4bench` 52BB6 | 2164:0FC4 |

- The box has one button: the highlighted choice moves every 60 frames and blinks every 12, and a press takes it.
- F1-F4 (team 1) and F5-F8 (team 2) pick a line directly. `lcselect` (src/engine/input/lcselect.c) takes choices 0-3
  at even strength and 0-1 when the strengths differ, which it maps to the special-team lines (+4 short-handed, +6
  power play, per its header).
- The computer changes when the puck is in its own half below the blue line, 1 time in 4, with checks on the penalty
  clock (`chk4lc`).
- `check4bench` sends each replaced skater to the bench (assignment 0Bh), and the new one comes on. Whether they
  visibly go over the boards wasn't checked.
- A team's lines: four forward lines, three defence pairs, two power-play units, two penalty-kill units, two goalies
  and two extra attackers (`CheckDatabases`, src/front/dbcheck/CheckDatabases.c; `DbLineEditorLoop`,
  src/front/lines/DbLineEditorLoop.c).
- Starting lines are set in the Line Editor: "Save These Lines", "Use These Lines", "Use Original Lines", "Use Default
  Lines", "Save As Default Lines", "Dress Player", "Scratch Player" (src/data/front/input_events.asm; Data). 94 PC has
  the same editor ("Use Original NHL Lines", "Use My Default Lines", NHL94PC src/data/far/menu_text.asm).

## AI roles

- **95 PC:** the centre, wing and defence role routines are `asscentero`, `asswingo` and the defence ones
  (src/engine/logic/logic.asm). That the centre fills the middle lane and the wings stay to their sides: not
  confirmed in code.
- **vs the others:** not compared.

## In-game team stats

- **95 PC: 12 rows:** 94 PC's 8 plus One Timers, Power Play Minutes, Power Play Shots, Offensive Faceoffs Won (stat
  name strings; Data).
- **vs 94 PC: changed.** 94 PC has 8 rows (the 93 list).
- **vs 94G and 95G: different.** 94G has 16 rows, 95G 15 (`stats95.asm` `TeamStatTextTbl`). "Offensive Faceoffs Won"
  is in neither.

## Season, league and roster tools

- **95 PC:** the same modes as 94 PC ("'93 - '94 Season"), plus a free-agent roster editor: "Edit Roster 1" / "Edit
  Roster 2", "Free Agents ...", "Find Player ...", "Move to Free Agent List" (release, `MoveToFreeAgents`,
  src/front/roster_edit/MoveToFreeAgents.c) and "Create Free Agent ..." (`CreateFreeAgent` / `CreatePlayerLoop`,
  src/front/create/, ratings from a "Rating Units" pool, src/data/front/create_const.asm,
  create_data.asm).
- **vs 94 PC: free agents, create player and release are new;** exhibition games and trades are unchanged. 94 PC has
  league, season, playoffs, Exhibition Game, Trade Players, dress / scratch players, import / export databases and
  "'92 - '93 Season" (menu strings "New Exhibition Game ...", "Trade Players ... ", "Select first player to trade.",
  "Team Scratches ...", "Import Databases ..." in NHL94PC src/data/far/menu_text.asm and team_choice_text.asm). It has
  no free-agent, create-player, release or rating-units string or label (`HOCKEY.EXE` holds the strings; its overlays
  hold none). (Data)
- **vs 94 consoles: 95 PC only.** None of these is in 94G or 94S.
- **vs 95 Genesis: same idea, own code.** 95G has the same set (`create95.asm`: "Create Player, Sign Free Agents,
  Release Players", also from a points pool); 95 PC's code is its own (`docs/RULES.md` F3).

## Trades

- **95 PC:** the team picker for trades (`LeagueTeamSelect` 38B4F, mode 10h, src/front/league_setup/league_setup.asm)
  accepts a pick only when that team's human flag (+17h of its entry) is set, for both picks, so a computer team can't
  be traded with. `TradePlayers` (40183, src/front/trade/TradePlayers.c) refuses to trade when the league has only one
  human team, asks both teams' passwords and closes trading on March 22, or after 1092 games played (26 x 84 / 2).
  `ExecuteTrade` (3E390) swaps up to two pairs of players, one for one. No count limit and no general-manager step
  were found.
- **vs 94 PC: same.** 94 PC's `TradePlayers` also refuses with one human team, asks both passwords and closes on
  March 20, or after 1008 games played (24 teams x 84 / 2), with no count limit. So both have an 84-game season. 94 PC's
  team picker wasn't traced.
- **vs 95 Genesis: different.** 95G allows up to three players a side, checks the roster rules (17-25 players, 2-3
  goalies, 9-15 forwards, 6-15 defencemen, `CheckTrade`) and lets the general manager evaluate or a player propose
  (`EvaluateTrade`, `trade95.asm`).

## Awards

- **95 PC:** the same 10 awards as 94 PC, each now with a subtitle: Most Valuable Player, Points Leader, Best
  Defenseman, Best Defensive Forward, Best Goalkeeper, Best Goals Against Average, Best Rookie, Best Regular Season
  Record, Most Valuable Player in the Playoffs, Most 3 Star Selections (src/data/front/main_const.asm;
  `PickAwardWinners` 1205D). Whether the winner rules changed wasn't compared.
- **vs 94 PC: same list, subtitles new.** 94 PC has Hart, Art Ross, Norris, Selke, Vezina, Jennings, Calder,
  Presidents, Conn Smythe, EA Sports Cup (NHL94PC `AwardNamePtrs`, `AwardKinds`, `AwardWinner`..`AwardWinner9`,
  `ShowAwardScreens`, src/data/dgroup.asm), and no subtitle strings.
- **vs 94 consoles: 94 and 95 PC only.** 94G and 94S have no awards; 94 PC had season awards first.
- **vs 95 Genesis: different.** 95G's awards are new in 95 (`awards95.asm`): 9 awards, Hart, Norris, Vezina, Art Ross,
  Jennings, Pearson, Selke, Presidents, Conn Smythe, with no Calder or EA Sports Cup. 95G also prints a description
  under each award ("Most Valuable Player", "Best Defenseman", "Best Goalkeeper", "Best Defensive Forward"), so the 95 PC
  subtitles look like 95G's (inferred). The wording differs in places (95G "Most Points", 95 PC "Points Leader").

## Teams, divisions and rosters

All from `TEAMS.DB`, `KEY.DB` and name lists (Data):

- **Teams:** 26 NHL teams plus Western and Eastern All-Stars (`TEAMS.DB`: 28 records of 744 bytes): Dallas Stars in
  the old Minnesota slot, Anaheim Mighty Ducks and Florida Panthers added. 94 PC has 24 NHL teams plus two All-Star
  teams (1992-93: Minnesota North Stars, no Anaheim or Florida). **Same as the 95 consoles** (the 1993-94 NHL).
- **Divisions and conferences:** Atlantic, Northeast, Central, Pacific; Eastern and Western (the 1993-94
  realignment), from the division byte in `TEAMS.DB` and the name strings. 94 PC has Patrick, Adams, Norris, Smythe;
  Wales and Campbell. **Same as 95G / 95S.**
- **Roster size:** 22-26 per team, 630 roster places (`KEY.DB`: 674 records of 52 bytes). 94 PC: 26-28 per team.
- **Roster date:** end of 1993-94 (94 PC: end of 1992-93). 1993-94 rookies are there (Daigle, Pronger, Arnott,
  Brodeur, Renberg, R. Niedermayer, Yashin); the January 1994 trades (Sutter and Butcher to QUE, Duchesne to STL) and
  March 1994 deadline moves (Gartner to TOR, Anderson and MacTavish to NYR, Kasatonov and Nedved to STL) are in. The
  June 28, 1994 Sundin-Clark trade isn't (Clark is still TOR, Sundin QUE). No 1994-95 rookies (Forsberg, Kariya).
- **Same player on the same team as:** 94 PC 345 of 630 (55%); 94G 56%; 94S 56%; 95G 613 of 630 (97%), 616 (98%)
  after hand-checking three spelling misses (Volek, Karpovtsev, Burakovsky); 95S 97%. This is a fuzzy name match per
  team (a subsequence or a similarity ratio over 0.85), so a percentage can be off by a few players. The same rule
  run on 94 PC vs 94G gives 89%; the 94 PC page's exact match gave 85%.
- **vs 95G:** every 95G player is in 95 PC except Ottawa's Darcy Loewen and Steve Konroyd. 95 PC has these that 95G
  doesn't: Sullivan (CGY), Dirk (CHI), Vujtek (EDM), Dufresne (LA), Racicot (MTL), Huard, Ruzicka, Quinn, Madeley
  (OTT), Patterson (PIT), Wolanin (QUE), Glynn, Lafayette (VAN), Bergland (WSH).
- **All-Star teams:** the January 1994 All-Star Game, the same 23 East and 21 West players as 95G (95S lacks Larry
  Murphy). 94 PC has the 1993 All-Star Game.
- **Ratings:** the same rating lists as 94 PC (rating name strings). Skaters: Speed, Agility, Weight, Shot Power,
  Checking, StickHandling, Accuracy, Passing, Off. / Def. Awareness, Aggressiveness, Endurance, Shoot/Pass Bias,
  Faceoffs. Goalies: Glove Left / Right, Stick Left / Right, Puck Control, Speed, Agility, Weight, Off. / Def.
  Awareness. Rating values weren't compared: the `ATT.DB` record layout isn't mapped yet.

## Announcer, video and credits

- **95 PC:** 49 announcer routines (`Pa` / `Say`), against 61 in 94 PC. CD video clips (54 `.CMV`, "Video Provided
  By: NHL Productions") and a VESA high-resolution mode (`VSAHKY50`) (data files and strings; Data).
- **vs the consoles: 94 and 95 PC only.** No play-by-play code found in 94G or 95G.
- **Credits** (credit pages in src/data/front/scoreboard_data.asm): Lead Programmer Lance Wall; Programmers
  Victoria Wong, Robert Penner, Kurt Kennett; Producer & Design Ken Sayler; Composer Michael J. Sokyrka; Audio
  Programmers Alan Stewart, Iain Macanulty; a SportsDesk announcer (Michael Donovan) and a rink announcer (Bruce
  Jamieson); "Ratings by John Rosasco and Neil Smith of the New York Rangers".

## Animation (SPA) list compared with 94 PC

The groups below are 95 PC's animations that 94 PC doesn't have, plus 94G's that neither PC game has:

| Group | Animations | Matches |
|---|---|---|
| New, also in 94G / 94S / 95G / 95S | `SPAbenchcheckl/r`, `SPAboardfront/back/left/right`, `SPAcrosscheck` | 94 |
| New, also in 95G | `SPAfakeshotf/b`, `SPAgofallback`, `SPAgofallglove` | 95 |
| New, 95 PC only | `SPAblockfront/knee/left/right`, `SPAfakeonetimef/b`, `SPAgoalieknee`, `SPAgoaliepoke`, `SPAgofallstick`, `SPAgokneehold`, `SPArefelbow`, `SPArefhistick`, `SPArefpenshot` | none (the poke check matches 94S `SPAgpoke` in purpose, not by name) |
| In 94G but in neither PC game | `SPAghighl/r`, `SPAgslambot/top`, `SPAgstick2l/r`, `SPAinjuryfall` | — |

## Skating and shooting physics

- **95 PC: the 94 PC engine, retuned.** Both PC games run 24 game steps per game second, one `DoGameFrame` per step
  (`ClockTick` 5DC10 counts 0x18 steps per clock second; `RunGameFrames` 1149A). The consoles multiply by a frame-step
  factor `d7`; the PC games don't.
- **vs 94 PC: changed.** Faster skating and acceleration, harder stops that scale with agility, quicker goalies, a
  bigger fatigue drain and a new velocity cap. The rink, friction, gravity, turning, shooting and the shot tables are
  unchanged.
- **vs 95 Genesis: different.** None of these values come from 95G, though they push the same way (faster skating).
  95S physics weren't traced.

The 93 / 94 console and 94 PC values are from the 94 PC page. The 95G column is from `skate95.asm` and
`input95.asm` (`doshot`), compared only for these rows. Every row was read in code:

| Item | 94 PC | 95 PC | 95G |
|---|---|---|---|
| Rink walls and corner (`checkwallcoll` 582C9) | x 160, y 264, corner radius 64 | Same (0xA0, 0x108, 0x40); not 94G's $88 / $12A / $40 | 152, 312, corner 0x4C |
| Position step | velocity x 16 | Same (`regd4` = 0x10) | — |
| Friction | >> 6 skating, >> 9 off | Same | >> 5 (a goalie not skating >> 4) |
| Gravity (puck) | 96 | Same | — |
| Velocity cap | None | New: skaters (`SCnum` < 12) held to ±0x3E80 (16000) per axis in `updateplayers` (5C40F) | — |
| Acceleration base (`dirtab`) | 175 (124 diagonal) | 200 (141 diagonal), the 93 / 94 console `runspeed` | 240 |
| Agility pre-factor | (agility + 48) >> 6 | Same | — |
| Acceleration factor (`playeracc` 5EDAD) | Skater 32 - weight/8 + agility; goalie + agility + 8 | Skater same; goalie + agility + 0x14 (20) | (96 - weight/4 + agility) / 2, >> 5; halved for a goalie unless joystick-driven or skating |
| Top-speed table | `MaxSpeed` (with `MaxSpeed_w2` for the high word): sqrt of 4800 + 220n - n², 4800 to 7875 | `MaxSpeed`: sqrt of exactly 5400 + 230n - 2n², 5400 to 8400 | ((n + 20) x 325)², 6500 to 11375 (94G uses x 275) |
| Referee top-speed index | Fixed 0xF | 0xF, or 0xC while play is on and the referee is at \|y\| ≥ 0x74 | — |
| Stopping (`stopna`) | 150 | 200 + agility; goalie 200 + 3 x agility | 150 |
| Turning (`doplayeracc`) | $300 - speed², minimum $180 | Same | — |
| Energy drain | 1 tick in 128, -33 | 1 in 128, -40 (0x28); above 0xC00 topped up by endurance (unsigned) and capped at 0x1000; below 0xC00 clamped at 0 | -33 + endurance / 2, none with line changes off |
| Shot (`doshot` 57C0B) | See below | Same, except the penalty-shot speed floor (skater speed + 0x1F4) | Shot power halved with an odd-value interpolation, one-timer minimum $1F, x cap $98, vector $44, target y $10B; also perfect with the goalie pulled or in a shootout |
| Shot x-offset table | `shotsets` | Same (0, $C, $10, …, the 93 `.shotsets` values) | ±$E |

- The velocity cap is above every top speed in the table, so it probably only catches collision kicks (inferred).
- Top speed is faster: +12.5% at the bottom, +6.7% at the top. The index is still (leg speed x energy) >> 12; injured
  1/8.
- Stopping that scales with agility is like 94S's ($70 + agility) x d7 (inferred); the values are 95 PC only. The
  referee index and the goalie acceleration change are 95 PC only.
- The shot, the same in both PC games: a $5249 constant; backhand -25%; shot-power boosts (+2 above 12 when closer
  than 500; +1 above 14 / 13 / 10); a perfect shot at distance ≤ 200 when rnd(16 + accuracy) > 14 (accuracy +1 above
  14 / 13); always perfect in highlight mode; aim error ((speed / 16 - accuracy + 16) x distance) >> 6, halved inside
  250; x error cap 0xA0 (160), y 0x3C; aim vector x 0x3B (59); target y 0xE8 (232); lift $B33, cap $1800.
- 94 PC's physics are in turn the 93-era formulas (weight / 8, no 94 or 95 shot-power halving).
- 94 PC formerly labelled the speed and shot tables `AccelFactors` and `ShotSpeeds`; it now uses the same names as
  95 PC, `MaxSpeed` and `shotsets` ([NHL94PC PR #83](https://github.com/abdulahmad/NHL94PC/pull/83)).

## Rink size, aspect ratio and per-axis scale

- **95 PC: the 94 PC rink and the per-pixel rule.** On the Genesis and on both PC games one game unit is one pixel on
  both axes, and the physics treat x (across the rink) and y (along it) the same. Nothing scales by feet or by pixel
  aspect ratio per axis. The 94 PC rink was redrawn wider and shorter in pixels, and the 94 PC speeds were rescaled the same
  way on both axes; 95 PC undoes part of 94 PC's speed cut. The full workings are on the 94 PC page
  ([Rink size, aspect ratio and per-axis scale](https://github.com/abdulahmad/NHL94PC/blob/main/docs/CONSOLE_LINEAGE.md#rink-size-aspect-ratio-and-per-axis-scale)).
- Drawing: `DrawFrameSprite` (src/front/main/DrawFrameSprite.c) puts a sprite at x + 0xC0, 0x140 - y, minus the
  scroll; `DrawRinkOverlays` (5CE12) lifts the puck by z x 3 / 2, as the Genesis does.
- Playfield: `ThreeStarsLoop` (48333) sets the zone screen to 0x140 x 0xA8, so it's 320 x 168 above a 32-line score
  bar, with scroll y = 0x140 - 0x54 - camy, as in 94 PC.
- Rink: `checkwallcoll` (582C9) 0xA0 / 0x108 / corner 0x40; blue line 0x4E and goal line 0xE8
  (src/engine/input/CanBlockShot.c, src/engine/pass/dopass.c), all as in 94 PC.
- **vs 95 Genesis: different.** 95G has its own rink (152 / 312, corner 0x4C; 3.58 and 3.12 units per foot), still one
  unit per pixel (`find3d`, `middle95.asm`).

The table sets 95 PC against 93G / 94G. Feet are from the 1992-93 NHL rink (200 x 85 ft; goal lines 11 ft from the
boards, blue lines 60 ft out from them):

| | 93G / 94G | 95 PC | 95 PC / Gen |
|---|---|---|---|
| Side boards (x) | ±136 | ±160 | 1.176 |
| End boards (y) | ±298 | ±264 | 0.886 |
| Units per foot, x | 3.20 | 3.76 | 1.18 |
| Units per foot, y | 2.98 | 2.64 | 0.89 |
| One screen shows | 256 x 224 | 320 x 168 | |
| Push (`dirtab`) | 200 | 200 | 1 |
| Top speed | 5500-9625 | 5400-8400 | 0.98-0.87 |
| Shot vector | $44 | 0x3B | 0.868 |
| Pass, no receiver | from `dirtab` | from `dirtab` | 1 |
| Pass to a teammate | $78 | $78 | 1 |

- The pass rows: `dopass` (54DF4) sets pass speed (passing x 4) + 0xA0 as on the Genesis. A pass with no receiver
  multiplies it by `dirtab`, which is now 200 (94 PC: 175, so 0.875). `passtoa0` (551CF) uses the $78 time factor.
- At top speed, skating end to end takes 0.90-1.02 times as many game steps as on the Genesis, and board to board
  1.20-1.35 times (94 PC: 1.02-1.08 and 1.35-1.44). For the same speed a 95 PC skater still covers 30% fewer feet across
  the ice than along it (2.64 / 3.76 units per foot); on the Genesis it's 7%. Stopping (200 + agility) and the
  velocity cap are new values, not a rescale. Shots keep 94 PC's 0x3B (0.868).
- Open: speeds are compared per game step, not per real second (frame rates and d7 weren't measured).

## Music

- **Organ tunes and menu songs: same as 94 PC.** All 71 `.KMS` tunes and their `.CFG` files are byte-identical to
  94 PC (file comparison, 142 files); only `SND.CFG` differs. They are the Dieter Ruehle organ set (the 94 SNES set,
  per the 94 PC page) and the FM / MT-32 menu songs.
- **Ruehle credit:** no Ruehle credit string found in 95 PC (94 PC has "Organ Music / Dieter Ruehle"); the credit pages
  name Michael J. Sokyrka (composer) and Alan Stewart, Iain Macanulty (audio programmers), even though the 94 PC organ
  tunes are kept byte for byte.
- **Organ cue per team: a 95 PC only reshuffle.** `teamrockcuetbl` has 6 cues per team; names are in `rockcuefiles`
  (src/data/front/replay_controls_data.asm), loaded by `LoadRockMusic` (7DC8B). 7 of 53 file names changed. BUF1,
  NJER1, PHIL3, SHK3, SHK5, SHK6 and TB1 are no longer named (the files are still shipped). HART2, MON1, MON3, LA4 and
  BOS2 now appear twice. One slot names CGY2, which has no file, and no team row or random pick uses it. Team rows:
  BUF, NYI, OTT and WPG BUF1 → HART2; NJ and NYR NJER1 → HART2; PHI PHIL3 → CAL2; SJ SHK3 / 5 / 6 → MON1 / MON3 / LA4;
  TB TB1 → BOS2. New ANA row LA1, TOR1, VAN3, none, CAL2, SHK7. New FLA row HART2, PITTS3, VAN3, none, PITTS2, MON1.
  Other teams unchanged. (Data)
- **Digitized music: new, 95 PC only.** 22 digitized `.IFF` recordings (8SVX, 22050 Hz). With music on, `TITLE30.IFF`
  replaces `ADTITLE.KMS` at the title (`RunDemoGame` 15D6B) and `AWASONG.IFF` replaces `ADAWARDS` at the awards
  (`PickAwardWinners` 1205D). Others include GAMESUM, MAINDESK and CALENDAR. The `.IFF` tunes weren't compared note
  for note with the `.KMS` tunes.

## Box features

What the code has for each line on the 95 PC box (and the console boxes where they bear on it):

- **"New moves: fake shots, drop passes, laying down on D":** all in the code. Fake shot and shot blocking, as on the
  95G box (see Fake shot, Shot blocking); the drop pass is 95 PC only (see Drop pass).
- **Penalty shots ("get caught dropping an opponent to the ice on a break and he'll go one-on-one with your
  goalie"):** new for 95 PC, in code (see Penalty shots). The 94G, 94S and 94 Sega CD boxes already list penalty
  shots, and 94G / 94S have `PenShotChk`.
- **"Line changes", "line change over the bench", "set starting lines":** in the code, all already in 94 PC (see Line
  changes).
- **"Unlimited trades":** no count limit was found, which was already so in 94 PC (see Trades).
- **84-game season (listed as new on the 95 boxes):** both PC games' trade deadlines assume 84 games (see Trades).
- **95G's "G.M. approval":** `EvaluateTrade` (`trade95.asm`); 95 PC has no general-manager step.
- **95G's "new play modes: play 2 on 2 'Jam' with just 4 skaters":** Practice Mode in 95G's code (see Practice
  mode); 95 PC doesn't have it.
- **95S "1-2 players":** what ships, since the multitap check is switched off (see 95S multitap).

## What this means

- 95 PC is built on the 94 PC engine, not ported from 95 Genesis. The physics changes are tuning, not 95G's values.
- From the 94 consoles it finally gets board, bench and cross-checks, penalty shots (on the 94G path code) and a CPU
  goalie poke check like 94S's. It doesn't take the 94 consoles' shootout, manual-goalie option or 4-player mode, or
  95G's practice (2-on-2) mode. Its drop pass isn't 95G's button move but its own contextual one. It has no fighting,
  but neither do the 94 / 95 consoles.
- From the 95 consoles it gets the 1993-94 season: Anaheim, Florida and Dallas, the new divisions and conferences,
  near-95G rosters and the 95G All-Stars. It also gets a fake / aborted shot, shot blocking, goalie falls and the
  95G-style roster tools (create player, free agents, release). The code for all of these is 95 PC's own. The season,
  playoffs, exhibition games, trades and the 10-award list were already in 94 PC; 95 PC only adds 95G-style
  subtitles to the award screens.
- Its own additions: the contextual drop pass, the fake one-timer, four shot-block animations, the goalie knee hold,
  high-sticking, boarding and elbowing penalties, a 12-row stats screen, more speech, CD video, VESA high resolution
  and digitized music.

## Limits

- 95S: the animation table is only partly named (57 entries) and its physics weren't traced. Rosters were compared.
- 95G physics were compared only for the rows listed.
- `ATT.DB` (rating values) isn't mapped, so ratings weren't compared player by player.
- The `.IFF` music wasn't compared with the `.KMS` tunes.
- The drop pass and the fake shot were traced in code, not played.
