# NHL '95 PC compared with NHL '94 PC and the 94 and 95 console games

This page lists what changed from NHL '94 PC (DOS "NHL Hockey", 1993) to NHL '95 PC (DOS, 1994). For each change it says
whether it matches something already in the 94 console games, something new in the 95 console games, or neither (PC-only).
It is the follow-up to the 94 PC page,
[NHL94PC `docs/CONSOLE_LINEAGE.md`](https://github.com/abdulahmad/NHL94PC/blob/main/docs/CONSOLE_LINEAGE.md),
which compares 94 PC with the 93 and 94 consoles. The physics units and confidence levels here are the same as on that page.

Sources:

- 95 PC: this repo's decompilation of `HOCKEY.EXE` (`src/`) and the retail data files (`TEAMS.DB`, `KEY.DB`, `.KMS` / `.CFG`, `.IFF`)
- 94 PC: [NHL94PC](https://github.com/abdulahmad/NHL94PC) and the retail data files
- 94 consoles: [NHL94Genesis](https://github.com/abdulahmad/NHL94Genesis) (94G) and [NHL94SNES](https://github.com/abdulahmad/NHL94SNES) (94S)
- 95 consoles: [NHL95Genesis](https://github.com/abdulahmad/NHL95Genesis) (95G) and [NHL95SNES](https://github.com/abdulahmad/NHL95SNES) (95S).
  95S naming is still early: its animation table is only partly named and its physics weren't traced, so most "follows"
  calls lean on 95G.
- 95 PC manual: Abdul's scan. The "With the Puck" page is quoted for the controls.
- Box claims: Abdul's transcription of the back of each EA NHL box, 92 to 96. Box text is marketing, so it is quoted as
  "the box says". Where the box and the code disagree, the code wins.

Addresses are the linear addresses in this repo's routine headers. Labels are the repo's current names. A label taken from
a console game doesn't by itself mean the code is the same: under `docs/RULES.md`, the DOS season, trade, create-player and
awards screens share strings and labels with 95G but not code.

Confidence levels:

- **Code**: the routine or table was read and compared.
- **Data**: a string, data file or table shows it, but the logic wasn't traced.
- **Inferred**: a judgement from the code or data. The reasoning is given in the row.
- **Not found**: searched for and absent. That is strong evidence but not proof.

"Follows" means:

- **94**: 94 PC didn't have it, but the 94 consoles did.
- **95**: new in the 95 consoles too.
- **PC-only**: no matching feature found in any of the four console games.
- **Unchanged**: same as 94 PC.

## Feature table

| Feature | 94 PC | 95 PC | Follows | Evidence | Confidence |
|---|---|---|---|---|---|
| **Fighting** | None | **None** | Unchanged, and in line with the consoles: fighting was a 93 feature (93G / 93S). 94G (`checkfight` is a bare `rts`), 94S (fight penalties and rating kept, no fight code) and 95G (`assfight` is a bare `rts`) have none, and no fight code was found in 95S. 95 PC isn't missing anything a 94 / 95 console had | `checkcx` (58DC7) calls only `newcheck`, `checkint`, `checkcheck`, then `vtoa` / `doplayeracc`. `asstab` slot 20, the 94 `assfight` slot, is `assstarskate`. No fight animation in the SPA list and no fight penalty | Code |
| **Board checks, bench check, cross-check** | No: `FallDown` uses only the fall, flip, stumble and injury animations | **Yes** | **94** (94G, 94S, 95G and 95S all have them) | `FallDown` (`src/engine/bodycheck/FallDown.c`, 562DB) picks `SPAboardfront/back/left/right` and `SPAbenchcheckl/r` near the boards and gives a boarding penalty (types 0x18 / 0x14) on a board fall. `checkcheck` (5382C, `checkcheck.c`) plays `SPAcrosscheck` with a Cross-checking or Roughing penalty. 94G's `SPAinjuryfall` is still missing | Code |
| **One-timers** | Yes, the 94 SNES design: `assonetimer` with `Findhittype` forehand/backhand | **Same design** | Unchanged (94S) | `assonetimer` (50B55) still builds the vector to goal and calls `Findhittype`. `OneTimerChk` and `asspassrec` call it as in 94 PC | Code |
| **Fake one-timer** | None | **New:** `SPAfakeonetimef` / `SPAfakeonetimeb` | PC-only (the consoles have no fake one-timer animation) | `ShotMode` (578FA, `src/engine/puckphys/ShotMode.c`): a release (`regd1` bit 0x10 / 0x40) before wind-up frame 10 of a one-timer switches to the fake one-timer animation and no shot is taken (the same abort as the slap shot below) | Code |
| **Fake / aborted slap shot** | None: a wind-up always ends in a shot | **New:** releasing before wind-up frame 10 cancels the shot and plays `SPAfakeshotf` / `SPAfakeshotb` | **95** in effect (95G has a fake shot, "A released in the attacking zone" in `input95.asm`, with the same `SPAfakeshotf` name; 94G / 94S / 94 PC have none). The PC trigger is its own: the manual says hold BUTTON 2 (shoot), then press BUTTON 1 before the wind-up completes. The 95 PC and 95G boxes both list fake shots as new. 95S has none, and its box doesn't claim one: its `ShotMode` (`assshoot.asm`) has no exit without `doshot` | `ShotMode` (578FA): a new BUTTON 1 press (`regd1` bit 0x10, or 0x40) before wind-up frame 10 clears the shot mode, never reaches `doshot`, and switches the slap-shot animations to these. The routine header calls them the follow-through, so the "fake" is an early abort of the wind-up rather than a separate deke animation. See [Passing, shooting and line changes](#passing-shooting-and-line-changes). How it looks in play wasn't checked | Code (logic); Inferred (that it copies 95G) |
| **Shot blocking** | None | **New:** players dive or drop to block shots | **95** (95G has `CanBlock` / `chkblock` / `SPAblock`; 94G / 94S have no shot blocking; 95S not found by name). This is what the 95 PC and 95G boxes call "laying down on D" | `CanBlockShot` (4FFEE), `TryBlockShot`, `BlockShotDive` (53387) and four animations `SPAblockfront`, `SPAblockknee`, `SPAblockleft`, `SPAblockright`. 95G has one block animation; the PC's four and its routines are its own | Code; Inferred (the 95G likeness) |
| **Drop pass** | **None.** `dopass` (28BB:0B96) always passes to a teammate or along `passdir`; no branch leaves the puck behind | **Yes, contextual.** Aim a pass at a teammate trailing the carrier in the attacking zone and the puck is left almost dead on the ice. The manual: "A pass to a trailing teammate is executed as a 'drop' pass, where the puck simply remains stationary on the ice." | **PC-only.** The box is right to list "drop passes" as new. 95G's drop pass is a different move: A with the d-pad back (`GameFlags` bit 1, `input95.asm`) makes a flat, quarter-speed pass with its own animation (`SPAdroppass` / `SPApassb2`). 95S has none: its `dopass` has no drop branch | `dopass` (54DF4) calls `PassLaneChk` (54C09) for a human passer's target and, when it passes, `ScatterPass` (54D63) instead of `passtoa0`. The puck gets no lift and x / y speeds below 360, against 5400-8400 skater top speeds. No new animation (`SPApassf` / `SPApassb`). See [Passing, shooting and line changes](#passing-shooting-and-line-changes). Not checked in play | Code |
| **Practice mode / 2-on-2 ("Jam")** | None | **None** (no practice string or label) | Not taken from the consoles | The 95G box says "new play modes: play 2 on 2 'Jam' with just 4 skaters". In the code this is **Practice Mode** (`setup95.asm` play modes; `sflags9` bit 7). Each side gets 0, 1 or 2 skaters (`PracticePlayersTbl`, `PrintPracticePlayers`), and `PullPracticePlayers` (`goal95.asm`) takes the rest off the ice. There is no icing, every rush counts as a breakaway, and `PracticeGoalies` sets the goalie mode for a side with a pad and no skaters. The word "Jam" wasn't found in 95G's strings. 95S has the same mode (`PracticeOptions`: Home Players / Visitor Players). 94G and 94S have none. The manuals confirm 0-2: "up to two skaters (plus goalie) per side" (95G manual PDF p.8; 95S manual PDF p.5) | Code (95G); Data (95S); Manual |
| **Penalty shots** | None (`checkcheck` calls `AddPenalty` with no breakaway test) | **Yes** | **94** (94G / 94S `PenShotChk`; 95G / 95S too), with a PC trigger. The box says "New in 95: get caught dropping an opponent to the ice on a break and he'll go one-on-one with your goalie". That's new for the PC, but the 94G, 94S and 94 Sega CD boxes already list penalty shots | `holdcheck` (56B79) and `Bcheck` (56A54) call `QuickShotChk` (6427F): if the fouled player is a human puck carrier with a shot on goal from near the net, `AddPenalty` gets type 0x1A "Penalty Shot" instead of the foul. `InProgress` then runs `StartPenaltyShot` (64398) and `SetupPenaltyShot` (63F72). The shooter is `asspenshooter` (4FAE8) on the 94G path code (`ShootoutPathData`, `StartShootoutPath`, `NextPathPoint`). The clock is held (`ClockTick` 5DC10, `penshottimer`). `doshot` gives the shot at least skater speed + 0x1F4 while `penshotlive` is set. The referee has `SPArefpenshot` / `assrefpenshot` and the announcer `SayPenaltyShot` / `PaPenaltyShot`. 94G instead uses a breakaway flag and penalty-shot forms of each penalty; 95 PC uses one penalty type | Code |
| **Shootout** | None | **Not found** | Not taken from the consoles, which all have one: 94G (`shootout94.asm`), 94S, 95G (`shootout95.asm`) and 95S (`ShootoutWonBy`) | No "Shootout" string. `PeriodOver` (`src/engine/hockey/PeriodOver.c`): game state 3 is sudden-death overtime and 4 is game over; `gameopts.fullot` makes overtime full length. The labels and comments that say shootout (`clockcont_0`, the `checkwindow` "gsp 4 shootout" comment, the `shootoutpath` module) are names carried over from 94G. That path code runs the penalty shot | Code (absence) |
| **Goalie poke check (CPU)** | None | **New:** `SPAgoaliepoke` | **94** (94S / 95S `assgoalie` has `SPAgpoke`; 94G / 95G don't) | `assgoalie` (`src/engine/goalie/assgoalie.c`) pokes when the puck carrier is within 0x23 and a random byte is under 10 | Code; Inferred (the 94S likeness) |
| **Goalie freezes puck / knee drop** | None | **New:** `SPAgokneehold`, `SPAgoalieknee` | PC-only | `assgoalie` holds the puck on the knee when an attacker is close | Code |
| **Goalie falls on hard shots** | None | **New:** `SPAgofallback`, `SPAgofallglove`, `SPAgofallstick` | **95** for the first two (same names in 95G); `gofallstick` is PC-only | `puckgoalie` (57096) picks from the `gofallback`..`gofallstick` range on hard shots | Code; Inferred (the 95G likeness) |
| **Goalie wall animations** | Yes (94S `SPAgwall*`) | **Yes** | Unchanged (94S) | `SPAgwallleft` / `SPAgwallright` still in the SPA list | Data |
| **94G goalie animations** (`SPAghighl/r`, `SPAgslambot/top`, `SPAgstick2l/r`) | None | **None** | Unchanged (not taken from 94G) | Not in the 95 PC SPA list | Not found |
| **Manual goalie control** | Only when the goalie has the puck | **Same** | Unchanged; not taken from the consoles. 94G ("Manual Goalie" option, `menu94.asm`), 94S (Automatic / Manual goalie option, `GoalieOptionText`) and 95G (MANUAL GOALIE / AUTO GOALIE pause option, `pause95.asm`) let a player control the goalie; 95S not checked | `dopass` (54DF4): a human takes the goalie only while he holds the puck. No manual-goalie menu string | Code (absence of a toggle) |
| **Players per game** | 2 | **2** in a game; a league can have several human teams | Unchanged; not taken from the consoles. 94G ("4 Way" play, `optsetup94.asm`), 94S (up to 5 pads with the MultiPlayer 5 multitap, `Multi5ConnectCheck`, `cont1team`-`cont5team`), and 95G (`FourWayPlay`) support more than 2 players. 95S has all the multitap code but switches it off: see [95S multitap](#95s-multitap). The 95S box says only "1 to 2 players", which is what ships | `cont1team` / `cont2team` only; "Select human controlled teams" in the league setup | Code / Data |
| **Penalties** | Roughing, Charging, Slashing, Cross-checking, Hooking, Tripping, Interference, Holding, Abuse of Official, Checking from Behind | **Adds** High-sticking, Boarding, Elbowing, Penalty Shot | PC-only for High-sticking, Boarding and Elbowing (not in the 94G or 95G penalty lists, which instead still list the unused Fighting penalties). The Penalty Shot follows 94 | Penalty name strings; new referee signals `SPArefelbow` and `SPArefhistick`; boarding from `FallDown` | Data (lists); Code (boarding) |
| **Injuries** | Yes | **Yes**; an injured skater's top-speed index is cut to 1/8 (`pflags2` bit 6) | Unchanged | `playeracc` (5EDAD) | Code |
| **Fatigue and line changes** | Yes, option: the line change box, F1-F8 keys, computer changes, a line editor | **Same**, option (`gameopts` bit 2); the drain per tick is bigger (see physics) | Unchanged. The box's "line changes", "line change over the bench" and "set starting lines" were all already in 94 PC | `playeracc` energy code; the line-change routines are in both games (see [Passing, shooting and line changes](#passing-shooting-and-line-changes)) | Code |
| **Pull goalie, offsides, two-line pass** | Yes | **Yes** | Unchanged | Option and referee strings in both games | Data |
| **In-game team stats** | 8 rows (the 93 list) | **12 rows:** the 8, plus One Timers, Power Play Minutes, Power Play Shots, Offensive Faceoffs Won | **94-like** but not the console list: 94G has 16 rows, 95G 15 (`stats95.asm` `TeamStatTextTbl`). "Offensive Faceoffs Won" isn't in either | Stat name strings | Data |
| **Season / league mode** | Yes: league, season, playoffs, Exhibition Game, Trade Players, dress / scratch players, import / export databases, "'92 - '93 Season" (menu strings "New Exhibition Game ...", "Trade Players ... ", "Select first player to trade.", "Team Scratches ...", "Import Databases ..." in NHL94PC `src/data/far/menu_text.asm` and `team_choice_text.asm`) | **Same modes, plus a free-agent roster editor:** "'93 - '94 Season"; "Edit Roster 1" / "Edit Roster 2", "Free Agents ...", "Find Player ...", "Move to Free Agent List" (release, `MoveToFreeAgents`) and "Create Free Agent ..." (`CreateFreeAgent` / `CreatePlayerLoop`, ratings from a "Rating Units" pool, `src/data/front/create_free_agent_messages.asm`, `create_data.asm`). Exhibition and trades are unchanged from 94 PC | Free agents, create player and release are new in 95 PC. They are **95**: the 95G franchise set (`create95.asm`: "Create Player, Sign Free Agents, Release Players", also from a points pool), none of which is in 94G / 94S or 94 PC. The code is PC's own (`docs/RULES.md` F3). Trades and exhibition games were already in 94 PC. **Trades:** the box says "unlimited trades". That is true only in the sense that no count limit was found, which was already so in 94 PC. **Trades are only between human teams:** 95 PC's team picker for trades (`LeagueTeamSelect` 38B4F, mode 10h) accepts a pick only when that team's human flag (+17h of its entry) is set, for both picks, so a computer team can't be traded with. 94 PC's picker wasn't traced. Both PC games refuse to trade when the league has only one human team, ask both teams' passwords and close trading at a deadline. In 94 PC (`TradePlayers`) the deadline is March 20, or 1008 games played (24 teams x 84 / 2). In 95 PC (`TradePlayers` 40183) it is March 22, or 1092 games played (26 x 84 / 2). So both have an 84-game season, which the 95 boxes list as new. `ExecuteTrade` (3E390) swaps up to two pairs of players, one for one. No general-manager evaluation step was found. 95G instead allows up to three players a side, checks the roster rules (17-25 players, 2-3 goalies, 9-15 forwards, 6-15 defensemen, `CheckTrade`) and lets the general manager evaluate or a player propose (`EvaluateTrade`, `trade95.asm`), the box's "G.M. approval" | Front-end strings in both games: no free-agent, create-player, release or rating-units string or label in NHL94PC (`HOCKEY.EXE` holds the strings; its overlays hold none) | Data; Code (that the bodies differ) |
| **Awards** | **10 awards:** Hart, Art Ross, Norris, Selke, Vezina, Jennings, Calder, Presidents, Conn Smythe, EA Sports Cup (NHL94PC `AwardNamePtrs`, `AwardKinds`, `AwardWinner`..`AwardWinner9`, `ShowAwardScreens`, `src/data/dgroup.asm`) | **The same 10**, now each with a subtitle: Most Valuable Player, Points Leader, Best Defenseman, Best Defensive Forward, Best Goalkeeper, Best Goals Against Average, Best Rookie, Best Regular Season Record, Most Valuable Player in the Playoffs, Most 3 Star Selections (`src/data/front/awards_title.asm`) | The award list is unchanged from 94 PC, which had season awards before the consoles: 94G / 94S have none, and 95G's are new in 95 (`awards95.asm`, 9 awards: Hart, Norris, Vezina, Art Ross, Jennings, Pearson, Selke, Presidents, Conn Smythe; no Calder or EA Sports Cup). The subtitles are new in 95 PC and look like **95**: 95G prints a description under each award ("Most Valuable Player", "Best Defenseman", "Best Goalkeeper", "Best Defensive Forward"); the wording differs in places (95G "Most Points", 95 PC "Points Leader") | Award strings and tables in both PC games and 95G; `PickAwardWinners` (1205D). No subtitle strings in 94 PC. Whether the winner rules changed wasn't compared | Data; Inferred (the 95G likeness) |
| **Divisions and conferences** | Patrick, Adams, Norris, Smythe; Wales and Campbell | **Atlantic, Northeast, Central, Pacific; Eastern and Western** (the 1993-94 realignment) | **95** (as in 95G / 95S) | Division byte in `TEAMS.DB` and the name strings | Data |
| **Announcer speech** | Yes (61 `Pa` / `Say` routines) | **Yes** (49 routines); credits a SportsDesk announcer (Michael Donovan) and a rink announcer (Bruce Jamieson) | PC-only (no play-by-play code found in 94G or 95G) | Routine names and credit strings | Data |
| **Video and display** | — | CD video clips (54 `.CMV`, "Video Provided By: NHL Productions"); VESA high-resolution mode (`VSAHKY50`) | PC-only | Data files and strings | Data |
| **Ratings credit** | — | "Ratings by John Rosasco and Neil Smith of the New York Rangers" | PC-only | Credits string | Data |

### Animation (SPA) list, 95 PC compared with 94 PC

| Group | Animations | Matches |
|---|---|---|
| New, also in 94G / 94S / 95G / 95S | `SPAbenchcheckl/r`, `SPAboardfront/back/left/right`, `SPAcrosscheck` | 94 |
| New, also in 95G | `SPAfakeshotf/b`, `SPAgofallback`, `SPAgofallglove` | 95 |
| New, PC-only | `SPAblockfront/knee/left/right`, `SPAfakeonetimef/b`, `SPAgoalieknee`, `SPAgoaliepoke`, `SPAgofallstick`, `SPAgokneehold`, `SPArefelbow`, `SPArefhistick`, `SPArefpenshot` | none (the goalie poke check matches 94S `SPAgpoke` in purpose, not by name) |
| In 94G but in neither PC game | `SPAghighl/r`, `SPAgslambot/top`, `SPAgstick2l/r`, `SPAinjuryfall` | — |

## Passing, shooting and line changes

The 95 PC box says "new moves: fake shots, drop passes, laying down on D" and lists "line changes", "line change over the
bench" and "set starting lines". The manual's "With the Puck" page says: "To pass the puck, press BUTTON 1, aim the pass
with the joystick, then release the button. A pass to a trailing teammate is executed as a 'drop' pass, where the puck
simply remains stationary on the ice." It also gives the fake shot (hold BUTTON 2, then press BUTTON 1 before the windup
completes) and line changes (BUTTONS 1 and 2 together).

In the code, `ReadJoy1` / `ReadJoy2` give `doinput` (504DA) three game buttons: `regd1` bit 0x10 (B), 0x20 (C) and
0x40 (A). The manual's wording matches B = BUTTON 1 (pass), C = BUTTON 2 (shoot) and A = both together. That mapping
comes from the manual and the routines below; the code that turns joystick buttons into these bits wasn't traced.

### Drop pass

The pass path, all in `src/engine/pass/` (Code):

1. B, pressed by the carrier, calls `setpassmode` (551AF): `passdir` = facing. While B is held, `passmode` (5514E) takes
   the stick direction as `passdir`. On the release it calls `dopass` (54DF4).
2. `dopass` picks the receiver: the closest skater on the team (not a goalie, not unavailable) whose direction from the
   puck is within one 45° step of `passdir`. One straight along `passdir` is preferred (the others get + 0x10000).
3. A human passer (`pflags` bit 3) with a receiver goes through `PassLaneChk` (54C09). When that returns 1, `dopass`
   calls `ScatterPass` (54D63) and stops. Otherwise it is a normal pass (`passtoa0`, 551CF), or, with no receiver, the
   puck goes along `passdir` at the pass speed plus the passer's velocity.
4. The computer uses the same drop: `chk4pass` (55493) stores `PassLaneChk`'s result in the passer's `passlane` byte, and
   `dopass` then calls `ScatterPass` for it.

`PassLaneChk` returns 1 only when all of these hold:

| Test | Needed |
|---|---|
| Passer | Not the goalie |
| Shot lane | `ShotLaneOpen` (64102) returns 0: an opposing skater is between the carrier and the net |
| Passer's y | Past the attacking blue line (4Eh), no deeper than 76h |
| Receiver's y | Nearer the blue line than the passer (behind him) |
| Both | Skating toward the attacked end (y velocity sign) |
| Gap | At most 3Ch in y and 28h in x |
| Receiver's heading | Within one 45° step of the direction to the passer |

It also compares the signs of (passer y - 4Eh) and (receiver y + the high byte of his y velocity - 4Eh). Both ends use
+4Eh, so this only rules anything out at the +y end. Whether that was meant wasn't checked (Inferred). The check
exits when `ShotLaneOpen` returns 1, which it does for an open lane, so a drop pass needs the lane blocked.

`ScatterPass` is the drop:

- The puck's z speed is 0 (no lift).
- Its x and y speeds are each `randomd0((12h - passacc) x 14h)`. `randomd0(n)` is 0 to n - 1 (`asm_helpers.asm`), and a
  skater's `passacc` is 0-15 (`changeplayer`), so each is under 360, and never negative. For scale, skater top speeds
  are 5400-8400 (`MaxSpeed`). So the puck stays almost where it was let
  go, creeping a little toward +x / +y. A better passer leaves it deader.
- The passer can't touch the puck for 28h frames (`nopuck`; a normal pass is 10h). The receiver gets assignment 13h
  (take the pass) and skates onto it, and the team's pass count goes up.

There is no drop-pass animation: `dopass` still plays `SPApassf` / `SPApassb`. That is why no drop pass was found by
name before.

94 PC has none of this. Its `dopass` (28BB:0B96, NHL94PC `engine/physics.asm`) goes straight from the receiver search to
`passtoa0` or the `passdir` pass. It has no lane check, no `passlane` byte and no `ScatterPass`. 95G's drop pass is
a button move (A with the d-pad back): a flat pass at a quarter of the speed, with `nopuck` 18h and its own animation
(`input95.asm` `dopass`). 95S's `dopass` (`src/routines/engine/input/dopass.asm`) has a fixed `nopuck` of 10h and
no drop branch.

### Fake shot

C, pressed by the carrier (not the goalie), calls `SetShotMode` (the wind-up). Every frame, `ShotMode` (578FA)
shoots (`doshot`) from wind-up frame 0Eh. Before frame 10, a new B press (or A) ends the wind-up with no shot: it clears
`sflags` bit 3 and switches the animation to `SPAfakeshotf` / `SPAfakeshotb` (`SPAfakeonetimef` / `b` in a one-timer
wind-up). That is the manual's "hold BUTTON 2 then press BUTTON 1". 95G's fake shot is "A released in the attacking
zone" (`input95.asm`). 95S's `ShotMode` (`src/routines/engine/logic/assshoot.asm`) has no exit without a shot: it
shoots at frame `$18`, and its only other branch (a flag in `d2` bit `$80`) jumps the wind-up forward to `$1C` - frame
and shoots sooner. (Code)

### Line changes and starting lines

Unchanged from 94 PC. The same routines are in both games (Code):

| Part | 95 PC | 94 PC |
|---|---|---|
| Open the box (A, carrier) | `SetLCmode` 4D9FC | 2519:2436 |
| The box | `lineinput` 4FD8E | 2C24:0050 |
| Take a choice | `lcfound` / `getlchoice` | 2C24:0608 / 05C0 |
| F1-F4, F5-F8 | `HandleHotKey` 1118F, `lcselect` | 1E7E:01DC |
| Computer | `chk4lc` 54AF9 | 28BB:0AA0 |
| Off to the bench | `check4bench` 52BB6 | 2164:0FC4 |

- Only with line changes on (`gameopts` bit 2).
- The box has one button: the highlighted choice moves every 60 frames and blinks every 12, and a press takes it.
- F1-F4 (team 1) and F5-F8 (team 2) pick a line directly. `lcselect` takes choices 0-3 at even strength and 0-1 when
  the strengths differ, which it maps to the special-team lines (+4 short-handed, +6 power play, per its header).
- The computer changes when the puck is in its own half below the blue line, 1 time in 4, with checks on the penalty
  clock (`chk4lc`).
- `check4bench` sends each replaced skater to the bench (assignment 0Bh), and the new one comes on. Whether they visibly
  go over the boards wasn't checked.
- Starting lines are set in the Line Editor: "Save These Lines", "Use These Lines", "Use Original Lines", "Use Default
  Lines", "Save As Default Lines", "Dress Player", "Scratch Player" (`src/data/front/input_events.asm`). 94 PC has the
  same editor ("Use Original NHL Lines", "Use My Default Lines", NHL94PC `data/far/menu_text.asm`). (Data)

### 95S multitap

The 95S box says "1-2 players". The code has the full 94S multitap support (`Multi5Init`, `Multi5Bios`, five pads,
`cont1team`-`cont5team`, the five-pad icons in `ShowConnectedPads`), but the connect check never reports a multitap
(Code):

| | 94S | 95S |
|---|---|---|
| Routine | `Multi5ConnectCheck`, bank $9B | $C36F88 |
| Port 1 found | `lda #$80` / `sta mp5connect` (line 44) | `lda #$00` / `sta` (line 43) |
| Port 2 found | `lda #$40` / `tsb mp5connect` (line 53) | `lda #$00` / `sta` (line 52) |

The files are NHL94SNES `src/routines/middle/Multi5ConnectCheck.asm` and NHL95SNES
`src/routines/engine/middle/Multi5ConnectCheck.asm`. The signature reads and the compares before these stores are the
same. With `mp5connect` always 0, `Multi5Init` and `Multi5Bios` always clear bit 0 of `mp5present`, so pads 3-5 are
never read. This matches what Abdul heard: one value per port was changed,
rather than the code removed. The NHL94 forums thread "NHL 95-97 5 player mod"
(https://forum.nhl94.com/index.php?/topic/38177-nhl-95-97-5-player-mod/) covers it. The Cutting Room Floor's NHL 95
(SNES) page (https://tcrf.net/NHL_95_(SNES)) gives the same two operands, $C36FD9 and $C36FEC, set to $40 to turn it
back on. That fits the 95S code: those are the two `lda #$00` operands. The NHL95 Discord couldn't be searched.

## Teams and rosters

| Item | 94 PC | 95 PC | Follows | Evidence | Confidence |
|---|---|---|---|---|---|
| Teams | 24 NHL teams plus two All-Star teams (1992-93: Minnesota North Stars, no Anaheim or Florida) | **26 NHL teams plus Western and Eastern All-Stars**: Dallas Stars in the old Minnesota slot, Anaheim Mighty Ducks and Florida Panthers added | **95** (the 1993-94 NHL) | `TEAMS.DB`: 28 records of 744 bytes | Data |
| Roster size | 26-28 per team | **22-26 per team**, 630 roster places (`KEY.DB`: 674 records of 52 bytes) | — | `KEY.DB`, `TEAMS.DB` | Data |
| Roster date | End of 1992-93 | **End of 1993-94**: 1993-94 rookies are there (Daigle, Pronger, Arnott, Brodeur, Renberg, R. Niedermayer, Yashin); the January 1994 trades (Sutter and Butcher to QUE, Duchesne to STL) and March 1994 deadline moves (Gartner to TOR, Anderson and MacTavish to NYR, Kasatonov and Nedved to STL) are in. The June 28, 1994 Sundin-Clark trade isn't (Clark is still TOR, Sundin QUE). No 1994-95 rookies (Forsberg, Kariya) | **95** | Roster names | Data |
| Same player on the same team as … | — | 94 PC: 345 of 630 (55%). 94G: 56%. 94S: 56%. 95G: 613 of 630 (97%), 616 (98%) after hand-checking three spelling misses (Volek, Karpovtsev, Burakovsky). 95S: 97% | **95** (95G / 95S) | Fuzzy name match per team (same rule run on 94 PC vs 94G gives 89%; the 94 PC page's exact match gave 85%) | Data |
| Differences from 95G | — | Every 95G player is in 95 PC except Ottawa's Darcy Loewen and Steve Konroyd. 95 PC has these that 95G doesn't: Sullivan (CGY), Dirk (CHI), Vujtek (EDM), Dufresne (LA), Racicot (MTL), Huard, Ruzicka, Quinn, Madeley (OTT), Patterson (PIT), Wolanin (QUE), Glynn, Lafayette (VAN), Bergland (WSH) | — | Name lists | Data |
| All-Star teams | The 1993 All-Star Game | **The January 1994 All-Star Game**: same 23 East and 21 West players as 95G (95S lacks Larry Murphy) | **95** (95G) | `KEY.DB` All-Star rosters | Data |
| Ratings set | Skaters: Speed, Agility, Weight, Shot Power, Checking, StickHandling, Accuracy, Passing, Off. / Def. Awareness, Aggressiveness, Endurance, Shoot/Pass Bias, Faceoffs. Goalies: Glove Left / Right, Stick Left / Right, Puck Control, Speed, Agility, Weight, Off. / Def. Awareness | **Same lists** | Unchanged | Rating name strings in both games | Data |
| Rating values | — | Not compared: the `ATT.DB` record layout isn't mapped yet | — | — | — |

## Skating and shooting physics

Units are as on the 94 PC page. Both PC games run 24 game steps per game second, one `DoGameFrame` per step
(`ClockTick` 5DC10 counts 0x18 steps per clock second; `RunGameFrames` 1149A). The consoles multiply by a frame-step factor `d7`;
the PC games don't.

The 93 / 94 console and 94 PC values come from the 94 PC page. The 95G values come from the 95G disassembly
(`skate95.asm`, `puckphys95.asm`) and were only compared where listed. 95S physics weren't traced.

| Item | 94 PC | 95 PC | Change | 95G (for comparison) | Confidence |
|---|---|---|---|---|---|
| Rink walls and corner (`checkwallcoll` 582C9) | x 160, y 264, corner radius 64 | **Same** (0xA0, 0x108, 0x40) | Unchanged (the 94 PC rink, not 94G's $88 / $12A / $40) | 152, 312, corner 0x4C | Code |
| Position step | velocity x 16 | **Same** (`regd4` = 0x10) | Unchanged | — | Code |
| Friction | >> 6 skating, >> 9 off | **Same** | Unchanged | >> 5 (a goalie not skating >> 4) | Code |
| Gravity (puck) | 96 | **96** | Unchanged | — | Code |
| Velocity cap | None | **Skaters (`SCnum` < 12) held to ±0x3E80 (16000) per axis** in `updateplayers` (5C40F) | PC-only. It's above every top speed in the table, so it probably only catches collision kicks | — | Code; Inferred (purpose) |
| Acceleration base (`dirtab`) | 175 (124 diagonal) | **200 (141 diagonal)** | Now the 93 / 94 console `runspeed` | 240 | Code |
| Agility pre-factor | (agility + 48) >> 6 | **Same** | Unchanged | — | Code |
| Acceleration factor (`playeracc` 5EDAD) | Skater 32 - weight/8 + agility; goalie + agility + 8 | **Skater same; goalie + agility + 0x14 (20)** | PC-only goalie change | (96 - weight/4 + agility) / 2, >> 5; halved for a goalie unless joystick-driven or skating | Code |
| Top-speed table | `MaxSpeed` (with `MaxSpeed_w2` for the high word): sqrt of 4800 + 220n - n², 4800 to 7875 | **`MaxSpeed`: sqrt of exactly 5400 + 230n - 2n², 5400 to 8400** | Faster: +12.5% at the bottom, +6.7% at the top. Index is still (leg speed x energy) >> 12; injured 1/8 | ((n + 20) x 325)², 6500 to 11375 (94G uses x 275) | Code |
| Referee top-speed index | Fixed 0xF | **0xF, or 0xC while play is on and the referee is at \|y\| ≥ 0x74** | PC-only | — | Code |
| Stopping (`stopna`) | 150 | **200 + agility; goalie 200 + 3 x agility** | PC-only values. Scaling with agility is like 94S ($70 + agility) x d7 | 150 | Code; Inferred (the 94S likeness) |
| Turning (`doplayeracc.c`) | $300 - speed², minimum $180 | **Same** | Unchanged | — | Code |
| Energy drain | 1 tick in 128, -33 | **1 in 128, -40 (0x28)**. Above 0xC00 it is topped up by endurance (unsigned) and capped at 0x1000; below 0xC00 it is clamped at 0 | Bigger drain | -33 + endurance / 2, none with line changes off | Code |
| Shot (`doshot` 57C0B) | $5249 constant; backhand -25%; shot-power boosts (+2 above 12 when closer than 500; +1 above 14 / 13 / 10); perfect shot at distance ≤ 200 when rnd(16 + accuracy) > 14 (accuracy +1 above 14 / 13); always perfect in highlight mode; aim error ((speed / 16 - accuracy + 16) x distance) >> 6, halved inside 250; x error cap 0xA0 (160), y 0x3C; aim vector x 0x3B (59); target y 0xE8 (232); lift $B33, cap $1800 | **Identical**, except the penalty-shot speed floor (skater speed + 0x1F4) | Unchanged | Shot power halved with an odd-value interpolation, one-timer minimum $1F, x cap $98, vector $44, target y $10B; also perfect with the goalie pulled or in a shootout | Code |
| Shot x-offset table | `shotsets` | **`shotsets`: identical** (0, $C, $10, …, the 93 `.shotsets` values) | Unchanged | ±$E | Code |

94 PC formerly labelled these tables `AccelFactors` and `ShotSpeeds`; it now uses the same names as 95 PC, `MaxSpeed` and `shotsets` ([NHL94PC PR #83](https://github.com/abdulahmad/NHL94PC/pull/83)).

## Rink size, aspect ratio and per-axis scale

The 94 PC page has the full workings
([Rink size, aspect ratio and per-axis scale](https://github.com/abdulahmad/NHL94PC/blob/main/docs/CONSOLE_LINEAGE.md#rink-size-aspect-ratio-and-per-axis-scale)).
In short: on the Genesis and on both PC games one game unit is one pixel on both axes, and the physics treat x
(across the rink) and y (along it) the same. Nothing scales by feet or by pixel aspect ratio per axis. The PC rink was
redrawn wider and shorter in pixels, and the PC speeds were rescaled the same way on both axes. 95 PC keeps the 94 PC
rink and the per-pixel rule, and undoes part of 94 PC's speed cut. Everything here is **Code** unless marked.

- Drawing: `DrawFrameSprite` (`src/front/main/DrawFrameSprite.c`) puts a sprite at x + 0xC0, 0x140 - y, minus the
  scroll; `DrawRinkOverlays` (5CE12) lifts the puck by z x 3 / 2, as the Genesis does.
- Playfield: `ThreeStarsLoop` (48333) sets the zone screen to 0x140 x 0xA8, so it's 320 x 168 above a 32-line score
  bar, with scroll y = 0x140 - 0x54 - camy, as in 94 PC.
- Rink: `checkwallcoll` (582C9) 0xA0 / 0x108 / corner 0x40; blue line 0x4E and goal line 0xE8 (`CanBlockShot.c`,
  `dopass.c`), all as in 94 PC.

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

Feet are from the 1992-93 NHL rink (200 x 85 ft; goal lines 11 ft from the boards, blue lines 60 ft out from them).
The pass rows: `dopass` (54DF4) sets pass speed (passing x 4) + 0xA0 as on the Genesis. A pass with no receiver
multiplies it by `dirtab`, which is now 200 (94 PC: 175, so 0.875). `passtoa0` (551CF) uses the $78 time factor.

What it means: at top speed, skating end to end takes 0.90-1.02 times as many game steps as on the Genesis, and board
to board 1.20-1.35 times (94 PC: 1.02-1.08 and 1.35-1.44). For the same speed a PC skater still covers 30% fewer feet
across the ice than along it (2.64 / 3.76 units per foot); on the Genesis it's 7%. Stopping (200 + agility) and the
velocity cap are new values, not a rescale. Shots keep 94 PC's 0x3B (0.868).

For comparison, 95G has its own rink (152 / 312, corner 0x4C; 3.58 and 3.12 units per foot), still one unit per pixel
(`find3d`, `middle95.asm`).

Open: speeds are compared per game step, not per real second (frame rates and d7 weren't measured).

## Music

| Item | 94 PC | 95 PC | Follows | Evidence | Confidence |
|---|---|---|---|---|---|
| Organ tunes and menu songs (`.KMS` / `.CFG`) | 71 tunes: the Dieter Ruehle organ set (the 94 SNES set, per the 94 PC page) and the FM / MT-32 menu songs | **All 71 `.KMS` and their `.CFG` files are byte-identical to 94 PC.** Only `SND.CFG` differs | Unchanged (94S organ set) | File comparison, 142 files | Data |
| Ruehle credit | "Organ Music / Dieter Ruehle" string | No Ruehle credit string found (the music credit is Alan Stewart). The manual's credits don't name him either: "Composer: Michael J. Sokyrka", "Audio Programmers: Alan Stewart, Iain Macanulty" | — | Strings; Manual (credits) | Not credited |
| Which organ cue plays for each team (`teamrockcuetbl`, 6 cues per team; names in `rockcuefiles`, `src/data/front/lockerroom_announcer.asm`, loaded by `LoadRockMusic` 7DC8B) | 94 PC table | **7 of 53 file names changed.** BUF1, NJER1, PHIL3, SHK3, SHK5, SHK6 and TB1 are no longer named (the files are still shipped). HART2, MON1, MON3, LA4 and BOS2 now appear twice. One slot names CGY2, which has no file and no team row or random pick uses it. Team rows: BUF, NYI, OTT and WPG BUF1 → HART2; NJ and NYR NJER1 → HART2; PHI PHIL3 → CAL2; SJ SHK3 / 5 / 6 → MON1 / MON3 / LA4; TB TB1 → BOS2. New ANA row LA1, TOR1, VAN3, none, CAL2, SHK7. New FLA row HART2, PITTS3, VAN3, none, PITTS2, MON1. Other teams unchanged | PC-only reshuffle | Table comparison | Data |
| Digitized music | None | **New: 22 digitized `.IFF` recordings (8SVX, 22050 Hz).** With music on, `TITLE30.IFF` replaces `ADTITLE.KMS` at the title (`RunDemoGame` 15D6B) and `AWASONG.IFF` replaces `ADAWARDS` at the awards (`PickAwardWinners` 1205D). Others include GAMESUM, MAINDESK and CALENDAR | PC-only | Code and data files | Code / Data |

The `.IFF` tunes weren't compared note for note with the `.KMS` tunes.

## What the 95 PC manual says

The public scan of the 95 PC manual (archive.org item ea-nhl94-nhl95-nhl96-nhl97-ibm-pc-dos-win-scans), cited by printed
page where its contents page gives one:

- **Players:** Head to Head Competition and Two Player Cooperative, two humans on the same team (p.5).
- **The AI the manual describes:** "The center fills the middle lane, the wings stay to their respective sides, and the
  defensemen hang back" (Controlling Your Team, p.6-7). That is the baseline the 96 PC cover-D and penalty-kill code
  changes.
- **Fake shot:** hold BUTTON 2, then press BUTTON 1 (Controlling Your Team).
- **Shot block:** "press BUTTONS 1&2 simultaneously when the active defender is in front of the shooter. If the shooter
  does not actually shoot the puck, the defender performs a hook or a hold" (Controlling Your Team). The keyboard page
  gives ALT + SPACEBAR while the shooter is in his windup.
- **Penalty shot:** a player on a breakaway brought down from behind gets a penalty shot; "No penalty box time is
  assessed against the offending team" (Penalty Shots, p.12).
- **Lines:** the Line Editor (p.12-13) offers four forward lines, three defence pairs, two penalty-killing and two
  power-play lines. A roster must hold four forward lines, three defensive lines, two power play lines, two penalty
  killing lines, two extra attackers and two goalies (Central Registry, p.21).
- **Credits:** Lead Programmer Lance Wall; Programmers Victoria Wong, Robert Penner, Kurt Kennett; Producer & Design
  Ken Sayler; Composer Michael J. Sokyrka. The same core programmers are credited on 96 PC.
- **Drop pass:** "A pass to a trailing teammate is executed as a 'drop' pass" (Controlling Your Team, p.6-7). That
  is the contextual `PassLaneChk` / `ScatterPass` drop described above, not a separate button.
- The manual has no shootout, practice mode, fighting, skill level or manual goalie.

## What this means

- 95 PC is built on the 94 PC engine, not ported from 95 Genesis. The rink, friction, gravity, turning, shooting and the shot
  tables are unchanged from 94 PC. 94 PC's physics are in turn the 93-era formulas (weight / 8, no 94 or 95 shot-power
  halving). The physics changes are tuning: faster skating and acceleration, harder stops that scale with agility,
  quicker goalies, a bigger fatigue drain and a new velocity cap. None of these values come from 95G, though they push
  the same way 95G did (faster skating).
- From the 94 consoles it finally gets board, bench and cross-checks, penalty shots (on the 94G path code) and a CPU goalie poke
  check like 94S's. It doesn't take the 94 consoles' shootout, manual-goalie option or 4-player mode, or 95G's practice (2-on-2 "Jam") mode. Its drop pass isn't 95G's button move but its own contextual one. (It has no fighting
  either, but neither do the 94 / 95 consoles: fighting was dropped after 93.)
- From the 95 consoles it gets the 1993-94 season: Anaheim, Florida and Dallas, the new divisions and conferences, near-95G
  rosters and the 95G All-Stars. It also gets a fake / aborted shot, shot blocking, goalie falls and the 95G-style roster
  features (create player, free agents, release). The code for all of these is PC's own. The season, playoffs, exhibition
  games, trades and the 10-award list were already in 94 PC; 95 PC only adds 95G-style subtitles to the award screens.
- Its own additions: the contextual drop pass, the fake one-timer, four shot-block animations, the goalie knee hold, high-sticking, boarding and elbowing
  penalties, a 12-row stats screen, more speech, CD video, VESA high resolution and digitized music.

## Limits

- 95S: the animation table is only partly named (57 entries) and its physics weren't traced. Rosters were compared.
- 95G physics were compared only for the rows listed.
- `ATT.DB` (rating values) isn't mapped, so ratings weren't compared player by player.
- The roster overlap uses fuzzy name matching (a subsequence or a similarity ratio over 0.85), so a percentage can be off by a few players.
- The `.IFF` music wasn't compared with the `.KMS` tunes. Ruehle isn't credited in the 95 PC strings or in the manual's
  credits, even though the 94 PC organ tunes are kept byte for byte.
- The drop pass and the fake shot were traced in code, not played. Whether the fake shot plays as a fake in a real game, and how often the CPU goalie's poke check and knee hold fire, wasn't
  measured.
