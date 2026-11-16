; Scoreboard sprites, the statistics sort orders, and the away roster.
bits 32
%include "hockey.inc"
section s_DB7EC nobits alloc noexec write align=1
global awroster, awrosterjersey, hmgoalieidx, hmscratch, UnusedStateFlag, UnusedStateMode, UnusedStateSpare
global GameRecordDay, UnusedStateByte, hmteamrec_skaters, hmteamrec_goalies, s1font, schedgameidx, pointerspr
global linesprites, hudhundstep, penaltydigits, PenaltyBlankDigit, hmpanelspr, awpanelspr, scoredigits, scrbrdshapes
global clockdigits, clockcolon, cupseries, titlesample, statsteamorder, statsmenuresult, sfpal2, sfpal1
global StatsLastSel, statsnumgoalies, statsskaterorder, statsgoalieorder, RosterFromStandings, leaguestatsmode, statsgoalieplr, statsnumskaters
global statsskaterplr, playofftree, hmteamrec, TeamRecLines, awteamrec
global hmlinetab, hmglstats, awglstats, hmlineind, awlineind, statsscreenpal, hmglstats_w2
global hmglstats_w4, hmglstats_w8, hmglstats_w14
awroster:                                       ; visitor roster records (awtmstruct+tmroster), as hmroster;
                                                ; used by LoadGameState, LoadGameTeams, SetupGoalieMenu ...
        resb 5
awrosterjersey:                                 ; Jersey number byte of each away roster record (39-byte
                                                ; records; pairs with hmrosterjersey); used by PlayHilight,
                                                ; SaveHilight
        resb 1087
hmteamrec:                                      ; TEAMS.DB record (2E8h bytes) of the home team for this game
                                                ; (LoadGameTeams); used by BuildEventLines,
                                                ; DrawLineEditorScreen, EditTeamLines ...
        resb 5
        resb 71
hmteamrec_skaters:                              ; hmteamrec+4Ch: the 25 skater ids of the team record
                                                ; (LoadGameRoster, LoadTeamRoster); used by
                                                ; GameSummaryScreen_period, LoadGameRoster, LoadTeamRoster ...
        resb 100
hmteamrec_goalies:                              ; hmteamrec+0B0h: the 3 goalie ids of the team record; used by
                                                ; LoadGameRoster, LoadTeamRoster
        resb 12
        resb 48
TeamRecLines:                                   ; Line set at +0ECh of each team record copy (stride 2E8h per
                                                ; side); the save lines menus write it; used by
                                                ; MenuSaveDefaultLines, MenuSaveTheseLines_x
        resb 508
awteamrec:                                      ; TEAMS.DB record (2E8h bytes) of the visiting team
                                                ; (LoadGameTeams); used by HilightSaveToDlg, LoadGameState,
                                                ; LoadGameTeams ...
        resb 5
        resb 183
        resb 556
hmlinetab:                                      ; home line table (30h bytes; tmlines of hmtmstruct, set by
                                                ; clearteams); SetupTeamLines / RemoveFromLines fill it,
                                                ; StartHL2 saves and restores it; used by BuildDefaultLines,
                                                ; CanFillLineSlot, DeskHomeLines ...
        resb 36
hmgoalieidx:                                    ; roster slots of the two home goalies (SetupGoalieMenu); used
                                                ; by SetupGoalieMenu
        resb 1
        resb 3
hmscratch:                                      ; 8 scratched home roster slots (64h = none) (LoadGameTeams);
                                                ; used by LoadGameTeams
        resb 8
s1font:                                         ; handle from OpenArtArchiveErr for s1.vfn loaded in main
                                                ; startup; used by DeskGoToReplay, DrawSettingsHeading,
                                                ; FormatPlayerName ...
        resb 4
schedgameidx:                                   ; schedule game index of the current game (444h + playoff game
                                                ; number); set by PlayoffModeLoop and temp_files; used by
                                                ; GameSummaryScreen_period, MenuNewExhibition, PlayLeagueGame
                                                ; ...
        resb 4
pointerspr:                                     ; mouse pointer sprite, bg saved as "Pointer"; used by
                                                ; CalendarScreen, ControlsDlgExh, ControlsDlgInGame ...
        resb 6
        resb 2
hmglstats:                                      ; home goalie game stats, 3 x 6 bytes (words min, sht, sav);
                                                ; clearteams points hmtmglstats here; used by InitGameSummary,
                                                ; LoadGameState, PostGameToTeamDb ...
        resb 2
hmglstats_w2:                                   ; hmglstats+2: shots word; used by InitGameSummary,
                                                ; PickThreeStars, PostGameToTeamDb
        resb 2
hmglstats_w4:                                   ; hmglstats+4: saves word; used by InitGameSummary,
                                                ; PickThreeStars, PostGameToTeamDb
        resb 4
hmglstats_w8:                                   ; hmglstats+8; used by PickThreeStars
        resb 6
hmglstats_w14:                                  ; hmglstats+0Eh; used by PickThreeStars
        resb 4
awglstats:                                      ; visitor goalie game stats (hmglstats+12h); clearteams points
                                                ; awtmglstats here; used by LoadGameState, clearteams
        resb 18
UnusedStateFlag:                                ; Byte only saved and restored with the game state; used by
                                                ; LoadGameState, SaveGameState
        resb 1
UnusedStateMode:                                ; Byte only saved and restored with the game state; used by
                                                ; LoadGameState, SaveGameState
        resb 1
UnusedStateSpare:                               ; Byte only saved and restored with the game state; used by
                                                ; LoadGameState, SaveGameState
        resb 1
GameRecordDay:                                  ; Second byte of the current game record (schedule byte 1);
                                                ; InitGameSummary stores it and LoadTeamRoster compares injury
                                                ; days against it; used by InitGameSummary, LoadGameState,
                                                ; LoadTeamRoster ...
        resb 1
UnusedStateByte:                                ; Saved and restored with the game state; otherwise unused;
                                                ; used by InitGameSummary, LoadGameState, LoadTeamRoster ...
        resb 4
linesprites:                                    ; line indicator shapes (DrawPanelLine); used by DrawHudPanel,
                                                ; DrawPanelLine, LoadScoreboardGfx
        resb 32
hudhundstep:                                    ; used by Gameloop, LoadGameState, StartHL2 ...
        resb 4
penaltydigits:                                  ; digit sprites "2000".."2009"; indexed in DrawPanelPenalties;
                                                ; used by DrawPanelPenalties, LoadScoreboardGfx
        resb 40
PenaltyBlankDigit:                              ; Shape drawn in place of the tens digit when a penalty time
                                                ; is under ten; used by DrawPanelPenalties
        resb 4
hmpanelspr:                                     ; "homp" sprite; used by LoadScoreboardGfx, UpdateHudPanel
        resb 4
awpanelspr:                                     ; "visp" sprite; used by LoadScoreboardGfx, UpdateHudPanel
        resb 4
scoredigits:                                    ; 10 digit shapes for the panel score (DrawPanelScore); used
                                                ; by DrawPanelScore, LoadScoreboardGfx
        resb 44
scrbrdshapes:                                   ; handle returned by OpenArtArchiveErr for scrbrd1.PPV; used
                                                ; by FreeGameMemory, LoadScoreboardGfx, PlayHilight
        resb 4
hmlineind:                                      ; hlin/hpp/hpk sprites; used by LoadScoreboardGfx,
                                                ; UpdateHudPanel
        resb 12
awlineind:                                      ; vlin/vpp/vpk sprites, used by UpdateHudPanel
        resb 12
clockdigits:                                    ; 10 digit shapes for the panel clock (DrawPanelClock,
                                                ; DrawPanelClockDigits); used by DrawPanelClock,
                                                ; DrawPanelClockDigits, LoadScoreboardGfx
        resb 40
clockcolon:                                     ; clock separator shape (DrawPanelClock); used by
                                                ; DrawPanelClock, DrawPanelClockDigits
        resb 4
cupseries:                                      ; "Stanley" copy of the 7 Stanley Cup final games during a
                                                ; final game, else 0 (LoadCupFinalSeries, IsCupClinched); used
                                                ; by FreeGameMemory, IsCupClinched, LoadCupFinalSeries
        resb 4
titlesample:                                    ; TitleScreen: handle of the sample it loads and plays; used
                                                ; by TitleScreen
        resb 4
statsscreenpal:                                 ; stats screens: 768-byte palette read and faded to; used by
                                                ; StatsSel9394Season, StatsSelLeague, StatsSel_common
        resb 768
statsteamorder:                                 ; 26 team indices for the team picker; used by
                                                ; CalStandingsScreen, EasnStandingsScreen, GameStandingsScreen
                                                ; ...
        resb 104
statsmenuresult:                                ; StatsMenu*: the result of the screen just run; used by
                                                ; StatsMenuAssists, StatsMenuGAA, StatsMenuGoalieWins ...
        resb 4
sfpal2:                                         ; loaded "SfPal2" fade palette (StatsMenu*); used by
                                                ; StatsMenuAssists, StatsMenuGAA, StatsMenuGoalieWins ...
        resb 4
sfpal1:                                         ; loaded "SfPal1" fade palette (StatsMenu*); used by
                                                ; StatsMenuAssists, StatsMenuGAA, StatsMenuGoalieWins ...
        resb 4
StatsLastSel:                                   ; Statistics screen selection reset to -1 whenever a
                                                ; statistics source is chosen; used by
                                                ; CalStandingsMenu_player, CalStandingsMenu_player2,
                                                ; EasnStandingsMenu_player ...
        resb 4
statsnumgoalies:                                ; goalie count; used by PlayerFromMouseY, RunPlayerPickMenu,
                                                ; TeamRosterScreen
        resb 4
statsskaterorder:                               ; sorted skater list (qsort CompareSkaterStats); used by
                                                ; RunPlayerPickMenu, ShowRosterStats, TeamRosterScreen
        resb 100
statsgoalieorder:                               ; sorted goalie list (qsort CompareGoalieStats); used by
                                                ; RunPlayerPickMenu, ShowRosterStats, TeamRosterScreen
        resb 20
RosterFromStandings:                            ; Set when the team roster screen is opened from a standings
                                                ; or stats menu; picks the roster layout; used by
                                                ; CalStandingsMenu_roster, EasnStandingsMenu_roster,
                                                ; GameStandingsMenu_roster ...
        resb 4
leaguestatsmode:                                ; set while the stats screens run from the league (calendar)
                                                ; rather than a game: the stats menus then load their own
                                                ; palettes; used by CalGoalieStatsScreen,
                                                ; CalSkaterStatsScreen, CalStandingsMenu ...
        resb 4
statsgoalieplr:                                 ; goalie -> statsplayerbuf index; used by RunPlayerPickMenu,
                                                ; ShowRosterStats, TeamRosterScreen
        resb 20
statsnumskaters:                                ; skater count; used by PlayerFromMouseY, RunPlayerPickMenu,
                                                ; TeamRosterScreen
        resb 4
statsskaterplr:                                 ; skater -> statsplayerbuf index; used by RunPlayerPickMenu,
                                                ; ShowRosterStats, TeamRosterScreen
        resb 100
playofftree:                                    ; playoff tree slots: 16 round-1, 8 round-2, 4
                                                ; conference-final, 2 final team numbers (1Ah = empty) shown
                                                ; by DrawPlayoffTree; used by CalStandingsMenu,
                                                ; CalStandingsMenu_player2, DrawPlayoffTree ...
        resb 4
