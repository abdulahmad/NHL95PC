# Tie-order survey (lane T, 2026-10-24/25)

`tools/wccre/tieorder.py --minutes 10` on the near-miss register drafts, as they stood on main then (scores are
differing instructions, the draft's baseline -> the best forced tie order). A forced order of 0 means the rest of
the source is right and only the order of tied conflicts differs: reach it with a natural edit (AGENTS.md: no
tie-breaker copies), using the explanation's block / line hints (docs/WCC_INTERNALS.md, "How the conflict list is
built") and `tools/wccre/tiesearch.py`. A partial gain means a tie is part of the difference. Ten minutes is
not exhaustive: "no gain" means none was found, not that none exists. Rerun before relying on a line: the drafts
have moved on since.

**A tie order gives the EXE bytes (0):** POInitSchedule 6, JoystickCalScreen 11, PenGoalStuff 19, NetCollide 22;
matched since: CreateFreeAgent 5, DrawGameLineJerseys 11 (both by declaration order or a natural edit), and the
already-matched controls QueueSpeechClip and calcpuckcross.

**Partial:** SkateToSpot 8 -> 2, checkcx 18 -> 2, FixJerseyConflict 16 -> 12, MenuSaveDefaultLines 17 -> 11,
MenuSaveTheseLines 19 -> 13, RandomizeSchedule 14 -> 11, PassLaneChk 12 -> 9, changeplayer 10 -> 9, POSeedTeams
22 -> 17, MoveToOtherRoster 27 -> 23.

**No gain in 10 minutes:** checkgoal 1, SimPlayoffRound2 3, TitleScreen 3, TradePlayers 3, ShowCredits 4,
PickAwardWinners 5 (lane 2 later found a forced order of 0 with a longer run), BlitTileMap 5, DrawListItem 6,
assbench 6, ExecuteTrade 7, FadePalette 7, ListDialog 7, SelectMatchingPlayers 7, SelectHilight 7, SkaterStatsCard
7, checkob 2, CopyHumanTeamDBs 9, ReassignCtlPlayer 9, RosterPanelClick 9, SimPlayoffRound1 9, SeriesLength 10,
ExportTeamToFloppy 11, GameStatsScreen 11, wallcoll 11, CreateNewLeague 12, DrawAwardsSummary 12, checkplcoll 13,
SeedPlayoffRound3 14, checkwallcoll 15, dopass 15, MenuGameShowPlayerStats 16, ShowAwardScreens 19,
FillDressedSlots 20, PickForLineSlot 20, ResetGameVars 20, ShowRosterStats 20, InstantReplay 22, updatereplay 22,
LockerRoomLoop 23, shotdiradj 23, checkgoalp 27, PlayLeagueGame 28, DrawLockerJersey 29, checkcheck 31,
DrawCalendarDay 32, TreeSeriesWinner 35, ChkScorerMilestone 36, EditTextField 36, RemoveFromLines 59.

Not ties (from the tieorder runs and diagnosis): checkob (operand order), checkplcoll (parameter homes), FadePalette
(16-bit), checkgoal (the 16-bit negate needs its own register: `short z` shares y's, `int z` sign-extends).

`tiesearch.py` (natural edits toward the forced order), POInitSchedule: no match in 55 minutes (best 10 differing,
all register-only, 7 of 9 swaps unsatisfied); the focused version (edits near the swaps' lines first) is twice as
fast per step.
