# NHL 95 PC online season — v2 (player-facing)

Implementing on **`cursor/seamless-online-season`**, cut from current `cursor/overbar-95pc-6801`. PR into `cursor/overbar-95pc-6801`; do not merge. v1 (`95pc-online-season-plan.md`) is the floppy/call map; this is the player-facing flow.

Never `main`, never `sdl2-port`, never force-push. No 96 modem. Overbar stays generic; NHL folders stay in `port/season.c`. Never PulseMan. Do not touch lineup / `fputchar`.

Tip when written: `eb4048bf`. Import fix #365 is in (`ba75ef97`). Overbar pin **`82363b4`**.

---

## How it should feel when done

Host makes a league, once:

1. **New League** as today. For each human team: **this computer** or **another computer**. That is the only “export” question. A and B = this computer. C and D = another computer (bob, dee, …).
2. **Online → Host.** Friends **Connect**.
3. Each friend opens **Season → Pick a team** and chooses **Edmonton - bob** (team name, not a file). After that, that machine *is* that team.
4. Anyone opens the **calendar** and picks a game. Host vs a friend in the room is online. A vs CPU / A vs B / C vs D after the other team’s DBs are on this PC is local. Play. The result is on every copy that needs it. Open the calendar again; that game is gone.

No **Import Databases**. No **Merge & Update**. No **insert a disk**. No **typed filename**. No **Export team as a file** / **Sync league** click on the happy path. Overlay Season is “who has which team,” not a mailroom.

The original floppy let you **export** C, **import** onto D, **Merge & Update**, and play both teams on one PC. That is still C vs D. The game now does those three File steps in the background whenever the copies need them. (If someone is offline, overlay file take/give can stay as a fallback. Happy path never uses it.)

---

## What is unfriendly today

Abdul already has create + export. After pick, the guest is told to do the 1994 mail steps by hand.

| Today the player must | Why it feels wrong |
|---|---|
| New League “export this team?” then later **File > Import Databases > Player** on the client | Pick already chose Edmonton. Import is a second, DOS-shaped copy of the same fact. #365 made that import *able* to work; it is still a required click. |
| Overlay hint: “Load: File > Import Databases > Player” | We are pointing at the sports-desk File menu, not Overbar, and at a 1994 databases dialog. |
| Overlay **Sync league** after import, which then said **no disk in the drive** | Sync is mail-the-disk with extra steps. Empty A: is a floppy error. |
| Overlay **Team 5 / Team 12** instead of Oilers / Rangers on the guest | Pick worked; the guest still does not see the league the host sees. |
| Later: **insert the other team’s disk** to play a human vs human | Every two-human game, including online, still asks for a floppy even if a copy is already there. |
| Overlay **Export / Import / Take** a `.obt` | Filenames. The 1994 workaround, still in the room UI. |
| C vs D meant export / import / Merge & Update by hand | That *is* C vs D. The clicks are the problem, not the databases. |

v2 does not add more overlay rows. It **removes** those clicks until the calendar is the only play action.

---

## What can stay

**New League: this computer vs another computer.** That is how the host says A and B live here and C and D are for friends. It is setup, not mail. Virtual A: already eats the host’s export write so there is no real floppy.

Online **Host / Connect** stays (one room) for the league: pick, files, and the background export / import / merge. Friends do not host their own **league**. After C and D have taken their teams they play each other **on their own**: the other team’s databases show up on this PC (export from one, import and Merge & Update on the other), then PlayGame is local, like A vs B. The season host is not a player, not a spectator, and not in that hockey game.

---

## Target

| Team | Machine | New League |
|---|---|---|
| A | Host | This computer |
| B | Host | This computer |
| C | Client 1 | Another computer |
| D | Client 2 | Another computer |

Games:

- Host, local: A vs CPU, B vs CPU, A vs B (two pads)
- Online: A vs C, A vs D, B vs C, B vs D
- Client local: C vs CPU, D vs CPU
- Local on one guest PC: C vs D (export / import / Merge & Update in the background, then two pads)

A vs CPU / B vs CPU / A vs B must **not** start an online session just because the room is up.

---

## Phases (what the player does / which click dies)

One PR per phase onto `cursor/overbar-95pc-6801`. Laptop proof, then merge. `port/build-win.sh` on port changes. Warn before a listen. Separate copies, different exe names, never close Abdul’s game. No simulated desktop input. No `NHL95_AUTOSKIP`.

### Phase 0 — Confirm the current build (no code)

**Player:** Host creates the league (A+B here, C for bob). Client connects, picks Edmonton/bob. Then, *as today*, Import Player and Sync.

**Pass:** Import does not error; no “no disk”; names are team names. **Fail:** fix import; do not start phase 1.

**Click that dies:** none. This is the unfriendly baseline.

### Phase 1 — Host plays from the calendar

**Player:** Host, no friend needed. Calendar: A vs CPU, B vs CPU, A vs B.

**Pass:** all three finish; the game is off the calendar; no insert-disk.

**Click that dies:** insert-disk for host-only games (if it still appears).

**Still there:** guest Import, guest Sync, insert-disk vs a friend.

### Phase 2 — Friend picks a team and can play

**Player:** Host has the room up. Client connects, picks **Edmonton - bob**. Client opens the **calendar as Edmonton** and plays vs the computer. No sports-desk Import.

**Pass:** pick → play C vs CPU (and later D vs CPU) with no Import Databases.

**Click that dies:** **File > Import Databases > Player**, and the overlay line that tells you to do that.

**Still there:** insert-disk vs a human; overlay Sync.

Under the hood (not shown): first copy is installed as a real league on that machine (`give_as_disk` off; import runs itself). Overlay Season says “Yours: Edmonton.”

### Phase 3 — Host vs a friend, from the calendar

**Player:** Both in the room. Host calendar: A vs C (or B vs C, A vs D, B vs D). Both pick that game. Select-sides, play online. After the game, both calendars drop it once scores have caught up. No insert-disk, no filename.

**Pass:** first **A vs C**, then the other three host-vs-client games. Standings match. No desync.

**Click that dies:** **insert the other team’s disk** for host vs client.

**Still there:** a **Sync** (or a wait) after the game until phase 5 hides it. Prefer a status line (“Updating league…”) over a button if it is cheap; a Sync click is acceptable for this phase only.

**Do not** go online for A vs CPU / A vs B just because someone is connected.

### Phase 4 — Same copies, vs computer again

**Player:** After an online A vs C, host plays A vs CPU; client plays C vs CPU. The A vs C game must not show up again.

**Click that dies:** none extra. This is the check that phase 3 did not break local play.

### Phase 5 — Two friends play each other

**Player:** C and D have already Pick’d their teams. One of them opens **C vs D** on the calendar (or they sit at one PC that has both teams). They do not wait for the season host, and they do not click File > Export / Import / Merge & Update. Afterward that game is gone for them and, once caught up, on the host’s calendar too. Host’s A and B records do not change.

**Pass:** both teams’ databases are on the machine that plays; PlayGame is local (two pads). The season host is not in that match. Export, import, and Merge & Update ran themselves.

**Fail:** any design that requires the season host to enter PlayGame, spectate, begin that match, or be a third pad. Any design that makes C vs D a second online hockey session. Any design that still needs a File menu click.

**Click that dies:** **File > Export Databases, Import Databases, Merge & Update**, and insert-disk for that game.

**Still there:** maybe a Sync click until phase 6 (the host merge of the result also runs itself when a guest is in the room).

**Why this is last:** after pick they have copies. The 1994 mail path (export C, import on D, merge, play here) is the game; the room only carries the files. Example: export from C and import into D to get both teams on the same machine.

Friends never Host their own league for this.

### Phase 6 — Calendar only

**Player:** Join the room → league is current. Play a game → league is current. Overlay Season shows who has A/B/C/D and a one-line status. No Sync button, no Import, no Export file, no disk box.

**Click that dies:** **Sync league** on the happy path.

**Left forever:** New League this-computer vs another-computer. Overlay file take/give only if someone is **not** in the room.

---

## After each phase, in one line

| Phase | The player can | Gone |
|---|---|---|
| 0 | Create, pick, then Import + Sync (today) | — |
| 1 | Host calendar: A/B vs CPU, A vs B | Host insert-disk for those |
| 2 | Friend picks a team, plays vs CPU | Import Databases |
| 3 | Host vs that friend, calendar, online | Insert opponent disk |
| 4 | Vs CPU still works after that | — |
| 5 | Two friends play C vs D on one PC | Export / Import / Merge & Update clicks |
| 6 | Same, no Sync click | Sync button |

---

## v1 → v2

v1 listed `WaitLeagueFloppy`, `savleague2`, `+16h`, `ob_season_mirror_send`. Implementers still do that work; **the player never sees it**. Virtual A:, pick-by-name, #365’s pack, and Overbar’s unused mirror/played are how we remove the clicks, not the product.

Do not bump Overbar off `82363b4`. Phase 5 is export / import / Merge & Update in the background, then local PlayGame. Not a spectator hook, not a season-host match_begin, not a second online session. Do not invent filenames. Do not start 96 modem.

Laptop: two copies for phases 0–4; two guest copies (or one PC with both teams) for 5, plus the host if the room is up. Firewall warning before the first listen.

---

## Out of scope

96 modem. 94/96 PC season. RG35XX. Merge to `main` / `sdl2-port`. Releasing a team to someone else. Changing auto lines / skill during an online game. 4-player season until two-human online is solid.

---

## Implementation

Abdul said implement, including C vs D: once they have taken their teams they play on their own against each other. The key is export / import / Merge & Update of the databases, run in the background, never as File menu clicks. Example: export from C and import into D so both teams are on the same machine. Do not wait. Branch `cursor/seamless-online-season`, PR into `cursor/overbar-95pc-6801`, do not merge that PR.
