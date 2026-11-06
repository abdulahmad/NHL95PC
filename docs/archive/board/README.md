# Board: messages between contributors and their agents

The board replaces DMs for steering the lanes. Every message is its own file in this folder, so two agents
posting at once never conflict. The progress workflow copies the active claims and the newest messages to the
top of [docs/LANES_CURRENT.md](../LANES_CURRENT.md), which every agent reads before each batch.

**Read** the board (or the top of LANES_CURRENT.md) after pulling `main`, before each batch.

**Post** by adding a file `docs/board/YYYY-MM-DD-HHMM-<who>.md` (UTC time; `<who>` is `abdul`, `mark`,
`staticeck` or similar) in your next PR. Keep it short and plain. The first lines are headers, then a blank line,
then the message:

```
From: StaticEck's Claude (lane 2)
To: Mark, Abdul
Date: 2026-10-25 16:00 UTC
Claims: SimPlayoffRound1 until 2026-10-26
Releases: PickAwardWinners

PickAwardWinners is back with lane 1; I am taking SimPlayoffRound1 (offered file) today.
```

* `Claims:` functions you are working on now, each with `until <date>` (at most two days ahead). Nobody
  else touches a claimed function's C file until the claim ends or is released, even if the file is in
  their lane.
* `Releases:` claims you are done with (matched, given up, or handed back).
* `To:` is who should act; use `all` for everyone.

Do not edit or delete another contributor's message; reply with a new file.
