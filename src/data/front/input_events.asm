; Menu titles for Sports Central, and the mouse and joystick event queue.
bits 32
%include "hockey.inc"
section s_CD9D0 progbits alloc noexec write align=1
extern StatsMenuStandings, StatsMenuTeamScoring, StatsMenuTeamDefense, StatsMenuPenaltyKilling, StatsMenuPowerPlay, StatsMenuTeamPenalties, StatsMenuPoints, StatsMenuGoals
extern StatsMenuAssists, StatsMenuPPGoals, StatsMenuSHGoals, StatsMenuPlusMinus, StatsMenuPIM, StatsMenuShootPct, StatsMenuGAA, StatsMenuGoalieWins
extern StatsMenuSavePct, DeskBackToGame, DeskToSportsDesk, DeskReturnConfirm, DeskExitGame, MenuOpenSaved, MenuExit, MenuNewExhibition
extern MenuNewLeague, MenuAddTeam, MenuRemoveTeam, MenuLeagueSettings, MenuRebuildDbs, MenuMergeUpdateDbs, MenuMergeLeagueFiles, MenuUpdateTeamDbs
extern MenuTradePlayers, MenuLeagueHilights, MenuImportDbs, MenuCentralRegistry, MenuExhibitionSettings, MenuP1ControlsExh, MenuP2ControlsExh, MenuP1ControlsInGame
extern MenuP2ControlsInGame, LockerRoomScreen, MenuSoundSettings, MenuSaveGame, CreatePlayoffs, EasnStandingsMenu, StatsSourceMenu, DeskReplayMenu
extern DeskTeamLinesMenu, DeskGameStatsMenu, DeskStatsTypeMenu
global str_LAAtMTL, modesetlabel, str_SportsCentral2, str_PlayoffTree2
global str_Return, str_SportsCentral, str_LeagueCalendar, str_PlayoffTree, str_BroadcastBooth, str_IntermissionDesk, str_RinkSide
global joycalx, joycaly, inputinstalled, ptrstep, InputResetWord, inputqcount, inputqtail
global inputqhead, inputpolldiv, InputQueueSpare, joybtnheld, enterheld, lastmousebtns, lastmousex, lastmousey
global mainmenubar, menuact_export, menuact_nextlg, menusub_lgmgr, menuact_nextpo
global menuact_posettings, menuact_pohilights, statsmenu_srccnt, menutext_deskreturn, menutext_desktodesk, str_File, str_Game6, str_Statistics3
global str_Open5, str_FileMenuDivider, str_NewExhibitionGame, str_NewPlayOffSeries, str_NextPlayOffGame, str_PlayOffSettings, str_PlayOffHilights, str_NewLeague
global str_ImportDatabases, str_ExportDatabases, str_NextLeagueGame, str_LeagueManager, str_CentralRegistry, str_Exit, str_GameLabel, str_Dashes2
global str_Player1Controls2, str_Player2Controls2, str_ExhibitionSettings, str_PlayOffSettings2, str_SoundSettings, str_Dashes3, str_HomeTeamGoalie, str_sp00XXXXXXXXXXXXXXXXX
global str_sp00XXXXXXXXXXXXXXXXX2, str_spNONE, str_VisitingTeamGoalie, str_sp00XXXXXXXXXXXXXXXXX3, str_sp00XXXXXXXXXXXXXXXXX4, str_spNONE2, str_GoalieItemTmpl, str_Action
global str_Game7, str_InstantReplay, str_LineEditor, str_Statistics4, str_GameSummary, str_BackToGame, str_SaveGame2, str_SportsDesk
global str_Exit2, str_GoToReplay, str_HomeTeam2, str_VisitingTeam2, str_GameStatistics, str_PenaltySummary, str_ScoringSummary, str_TeamScratches
global str_LeagueMenuDivider, str_MergeLeagueFiles, str_RemoveTeamFromLeague, str_AddTeamToLeague, str_TradePlayers, str_RebuildDataBases, str_MergeAndUpdateTeam, str_UpdateTeamsDataBases
global str_ChangeLeaguePlaySettings, str_LeagueHilights, str_File2, str_Settings4, str_Statistics5, str_PlayNextGame, str_ReturnToSportsCentral2, str_StatisticsType8
global str_Standings2, str_TeamsSortedBy2, str_PlayersSortedBy2, str_GoaliesSortedBy2, str_Scoring, str_Defense4, str_PenaltyKilling2, str_PowerPlay2
global str_Penalties, str_Points, str_Goals, str_Assists2, str_PowerPlayGoals, str_ShorthandedGoals, str_PlusMinus4, str_PenaltyMinutes
global str_ShootingPercentage, str_GoalsAgainstAverage, str_Wins2, str_SavePercentage, str_StatisticsType, str_LineEditor2, str_Roster, str_PlayerStatistics
global str_SaveTheseLines, str_UseTheseLines, str_UseOriginalLines, str_UseDefaultLines, str_SaveAsDefaultLines, str_DressPlayer, str_ScratchPlayer, str_ShowPlayerStatistics
global str_LineEditor3, str_PlayerStatistics2, str_Cancel4, str_UseTheseLines2, str_UseOriginalLines2, str_UseDefaultLines2, str_SaveAsDefaultLines2, str_LineEditor4
global str_StatisticsType2, str_ReturnTo, str_SportsDesk2, str_ReturnTo2, str_Roster3, str_StatisticsType3, str_TeamRoster, str_OverallStandings
global str_ShowTeamRoster, str_ReturnTo3, str_PlayerStatistics3, str_StatisticsType4, str_ShowPlayerStatisticsAnd, str_ReturnTo4, str_StatisticsType5, str_TeamsSortedBy
global str_StatisticsType6, str_PlayersSortedBy, str_StatisticsType7, str_GoaliesSortedBy, str_Print, str_OutputCurrentData, filemenu, leaguemgrmenu
global gamemenu, statsmenu, TeamStatsSortMenu, SkaterStatsSortMenu, GoalieStatsSortMenu, deskmenubar, deskmenubar_lg, DeskFileMenu
global DeskLeagueFileMenu, DeskSettingsMenu
joycalx:
        db 01Dh,01h,00h,00h,01Dh,01h,00h,00h,09Dh,01h,00h,00h,09Dh,01h,00h,00h
        db 09Dh,01h,00h,00h,01Dh,01h,00h,00h,09Bh,00h,00h,00h,09Bh,00h,00h,00h
        db 09Bh,00h,00h,00h
joycaly:
        db 0E6h,00h,00h,00h,096h,00h,00h,00h,096h,00h,00h,00h,0E6h,00h,00h,00h
        db 036h,01h,00h,00h,036h,01h,00h,00h,036h,01h,00h,00h,0E6h,00h,00h,00h
        db 096h,00h,00h,00h,00h,00h,00h,00h
inputinstalled:
        db 00h,00h,00h,00h
ptrstep:
        db 00h,00h,00h,00h
InputResetWord:
        db 00h,00h,00h,00h
inputqcount:
        db 00h,00h,00h,00h
inputqtail:
        db 01Fh,00h,00h,00h
inputqhead:
        db 00h,00h,00h,00h
inputpolldiv:
        db 0Ah,00h,00h,00h
InputQueueSpare:
        db 00h,00h,00h,00h
joybtnheld:
        db 00h,00h,00h,00h
enterheld:
        db 00h,00h,00h,00h
lastmousebtns:
        db 00h,00h,00h,00h
lastmousex:
        db 00h,00h,00h,00h
lastmousey:
        db 00h,00h,00h,00h
str_File:
        db 046h,069h,06Ch,065h,00h
str_Game6:
        db 047h,061h,06Dh,065h,00h
str_Statistics3:
        db 053h,074h,061h,074h,069h,073h,074h,069h,063h,073h,00h
str_Open5:
        db 04Fh,070h,065h,06Eh,020h,02Eh,02Eh,02Eh,00h
str_FileMenuDivider:
        db 02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh
        db 02Dh,02Dh,02Dh,02Dh,00h
str_NewExhibitionGame:
        db 04Eh,065h,077h,020h,045h,078h,068h,069h,062h,069h,074h,069h,06Fh,06Eh,020h,047h
        db 061h,06Dh,065h,020h,02Eh,02Eh,02Eh,00h
str_NewPlayOffSeries:
        db 04Eh,065h,077h,020h,050h,06Ch,061h,079h,02Dh,04Fh,066h,066h,020h,053h,065h,072h
        db 069h,065h,073h,020h,02Eh,02Eh,02Eh,00h
str_NextPlayOffGame:
        db 04Eh,065h,078h,074h,020h,050h,06Ch,061h,079h,02Dh,04Fh,066h,066h,020h,047h,061h
        db 06Dh,065h,020h,02Eh,02Eh,02Eh,00h
str_PlayOffSettings:
        db 050h,06Ch,061h,079h,02Dh,04Fh,066h,066h,020h,053h,065h,074h,074h,069h,06Eh,067h
        db 073h,020h,02Eh,02Eh,02Eh,00h
str_PlayOffHilights:
        db 050h,06Ch,061h,079h,02Dh,04Fh,066h,066h,020h,048h,069h,06Ch,069h,067h,068h,074h
        db 073h,020h,02Eh,02Eh,02Eh,00h
str_NewLeague:
        db 04Eh,065h,077h,020h,04Ch,065h,061h,067h,075h,065h,020h,02Eh,02Eh,02Eh,00h
str_ImportDatabases:
        db 049h,06Dh,070h,06Fh,072h,074h,020h,044h,061h,074h,061h,062h,061h,073h,065h,073h
        db 020h,02Eh,02Eh,02Eh,00h
str_ExportDatabases:
        db 045h,078h,070h,06Fh,072h,074h,020h,044h,061h,074h,061h,062h,061h,073h,065h,073h
        db 020h,02Eh,02Eh,02Eh,00h
str_NextLeagueGame:
        db 04Eh,065h,078h,074h,020h,04Ch,065h,061h,067h,075h,065h,020h,047h,061h,06Dh,065h
        db 020h,02Eh,02Eh,02Eh,00h
str_LeagueManager:
        db 04Ch,065h,061h,067h,075h,065h,020h,04Dh,061h,06Eh,061h,067h,065h,072h,020h,03h
        db 00h
str_CentralRegistry:
        db 043h,065h,06Eh,074h,072h,061h,06Ch,020h,052h,065h,067h,069h,073h,074h,072h,079h
        db 020h,02Eh,02Eh,02Eh,00h
str_Exit:
        db 045h,078h,069h,074h,00h
str_GameLabel:
        db 047h,061h,06Dh,065h,03Ah,020h
str_LAAtMTL:
        db 04Ch,041h
        db 020h,020h,061h,074h,020h
        db 04Dh,054h
        db 04Ch,020h,02Eh,02Eh,02Eh,00h
str_Dashes2:
        db 02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh
        db 02Dh,02Dh,02Dh,00h
str_Player1Controls2:
        db 050h,06Ch,061h,079h,065h,072h,020h,031h,020h,043h,06Fh,06Eh,074h,072h,06Fh,06Ch
        db 073h,020h,02Eh,02Eh,02Eh,00h
str_Player2Controls2:
        db 050h,06Ch,061h,079h,065h,072h,020h,032h,020h,043h,06Fh,06Eh,074h,072h,06Fh,06Ch
        db 073h,020h,02Eh,02Eh,02Eh,00h
str_ExhibitionSettings:
        db 045h,078h,068h,069h,062h,069h,074h,069h,06Fh,06Eh,020h,053h,065h,074h,074h,069h
        db 06Eh,067h,073h,020h,02Eh,02Eh,02Eh,00h
modesetlabel:
        db 078h,078h,078h,078h,078h,078h,078h
        db 078h,078h,078h
        db 078h
        db 020h,053h,065h,074h,074h,069h,06Eh,067h,073h,020h,02Eh,02Eh,02Eh,00h
str_PlayOffSettings2:
        db 050h,06Ch,061h,079h,02Dh,04Fh,066h,066h,020h,053h,065h,074h,074h,069h,06Eh,067h
        db 073h,020h,02Eh,02Eh,02Eh,00h
str_SoundSettings:
        db 053h,06Fh,075h,06Eh,064h,020h,053h,065h,074h,074h,069h,06Eh,067h,073h,020h,02Eh
        db 02Eh,02Eh,00h
str_Dashes3:
        db 02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh
        db 02Dh,02Dh,02Dh,02Dh,02Dh,00h
str_HomeTeamGoalie:
        db 048h,06Fh,06Dh,065h,020h,054h,065h,061h,06Dh,020h,047h,06Fh,061h,06Ch,069h,065h
        db 020h,03h,00h
str_sp00XXXXXXXXXXXXXXXXX:
        db 02h,020h,030h,030h,020h,058h,02Eh,020h,058h,058h,058h,058h,058h,058h,058h,058h
        db 058h,058h,058h,058h,058h,058h,058h,058h,00h
str_sp00XXXXXXXXXXXXXXXXX2:
        db 02h,020h,030h,030h,020h,058h,02Eh,020h,058h,058h,058h,058h,058h,058h,058h,058h
        db 058h,058h,058h,058h,058h,058h,058h,058h,00h
str_spNONE:
        db 02h,020h,04Eh,04Fh,04Eh,045h,00h
str_VisitingTeamGoalie:
        db 056h,069h,073h,069h,074h,069h,06Eh,067h,020h,054h,065h,061h,06Dh,020h,047h,06Fh
        db 061h,06Ch,069h,065h,020h,03h,00h
str_sp00XXXXXXXXXXXXXXXXX3:
        db 02h,020h,030h,030h,020h,058h,02Eh,020h,058h,058h,058h,058h,058h,058h,058h,058h
        db 058h,058h,058h,058h,058h,058h,058h,058h,00h
str_sp00XXXXXXXXXXXXXXXXX4:
        db 02h,020h,030h,030h,020h,058h,02Eh,020h,058h,058h,058h,058h,058h,058h,058h,058h
        db 058h,058h,058h,058h,058h,058h,058h,058h,00h
str_spNONE2:
        db 02h,020h,04Eh,04Fh,04Eh,045h,00h
str_GoalieItemTmpl:
        db 02h,020h,030h,030h,020h,058h,02Eh,020h,058h,058h,058h,058h,058h,058h,058h,058h
        db 058h,058h,058h,058h,058h,058h,058h,058h,00h
str_Action:
        db 041h,063h,074h,069h,06Fh,06Eh,00h
str_Game7:
        db 047h,061h,06Dh,065h,00h
str_InstantReplay:
        db 049h,06Eh,073h,074h,061h,06Eh,074h,020h,052h,065h,070h,06Ch,061h,079h,00h
str_LineEditor:
        db 04Ch,069h,06Eh,065h,020h,045h,064h,069h,074h,06Fh,072h,00h
str_Statistics4:
        db 053h,074h,061h,074h,069h,073h,074h,069h,063h,073h,00h
str_GameSummary:
        db 047h,061h,06Dh,065h,020h,053h,075h,06Dh,06Dh,061h,072h,079h,00h
str_BackToGame:
        db 042h,061h,063h,06Bh,020h,074h,06Fh,020h,047h,061h,06Dh,065h,00h
str_SaveGame2:
        db 053h,061h,076h,065h,020h,047h,061h,06Dh,065h,020h,02Eh,02Eh,02Eh,00h
str_SportsDesk:
        db 053h,070h,06Fh,072h,074h,073h,020h,044h,065h,073h,06Bh,00h
str_SportsCentral2:
        db 053h,070h,06Fh,072h,074h,073h,020h,043h,065h,06Eh,074h,072h,061h,06Ch,00h
str_PlayoffTree2:
        db 050h,06Ch,061h,079h,06Fh,066h,066h,020h,054h,072h,065h,065h,00h
str_Return:
        db 052h,065h,074h,075h,072h,06Eh,00h
str_Exit2:
        db 045h,078h,069h,074h,00h
str_GoToReplay:
        db 047h,06Fh,020h,054h,06Fh,020h,052h,065h,070h,06Ch,061h,079h,020h,02Eh,02Eh,02Eh
        db 00h
str_HomeTeam2:
        db 048h,06Fh,06Dh,065h,020h,054h,065h,061h,06Dh,020h,02Eh,02Eh,02Eh,00h
str_VisitingTeam2:
        db 056h,069h,073h,069h,074h,069h,06Eh,067h,020h,054h,065h,061h,06Dh,020h,02Eh,02Eh
        db 02Eh,00h
str_GameStatistics:
        db 047h,061h,06Dh,065h,020h,053h,074h,061h,074h,069h,073h,074h,069h,063h,073h,020h
        db 02Eh,02Eh,02Eh,00h
str_PenaltySummary:
        db 050h,065h,06Eh,061h,06Ch,074h,079h,020h,053h,075h,06Dh,06Dh,061h,072h,079h,020h
        db 02Eh,02Eh,02Eh,00h
str_ScoringSummary:
        db 053h,063h,06Fh,072h,069h,06Eh,067h,020h,053h,075h,06Dh,06Dh,061h,072h,079h,020h
        db 02Eh,02Eh,02Eh,00h
str_TeamScratches:
        db 054h,065h,061h,06Dh,020h,053h,063h,072h,061h,074h,063h,068h,065h,073h,020h,02Eh
        db 02Eh,02Eh,00h
str_LeagueMenuDivider:
        db 02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh
        db 02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh
        db 02Dh,00h
str_MergeLeagueFiles:
        db 04Dh,065h,072h,067h,065h,020h,04Ch,065h,061h,067h,075h,065h,020h,046h,069h,06Ch
        db 065h,073h,020h,02Eh,02Eh,02Eh,00h
str_RemoveTeamFromLeague:
        db 052h,065h,06Dh,06Fh,076h,065h,020h,054h,065h,061h,06Dh,020h,046h,072h,06Fh,06Dh
        db 020h,04Ch,065h,061h,067h,075h,065h,020h,02Eh,02Eh,02Eh,00h
str_AddTeamToLeague:
        db 041h,064h,064h,020h,054h,065h,061h,06Dh,020h,074h,06Fh,020h,04Ch,065h,061h,067h
        db 075h,065h,020h,02Eh,02Eh,02Eh,00h
str_TradePlayers:
        db 054h,072h,061h,064h,065h,020h,050h,06Ch,061h,079h,065h,072h,073h,020h,02Eh,02Eh
        db 02Eh,020h,00h
str_RebuildDataBases:
        db 052h,065h,062h,075h,069h,06Ch,064h,020h,044h,061h,074h,061h,042h,061h,073h,065h
        db 073h,020h,02Eh,02Eh,02Eh,00h
str_MergeAndUpdateTeam:
        db 04Dh,065h,072h,067h,065h,020h,061h,06Eh,064h,020h,055h,070h,064h,061h,074h,065h
        db 020h,054h,065h,061h,06Dh,020h,044h,061h,074h,061h,062h,061h,073h,065h,073h,020h
        db 02Eh,02Eh,02Eh,00h
str_UpdateTeamsDataBases:
        db 055h,070h,064h,061h,074h,065h,020h,054h,065h,061h,06Dh,073h,020h,044h,061h,074h
        db 061h,042h,061h,073h,065h,073h,020h,02Eh,02Eh,02Eh,00h
str_ChangeLeaguePlaySettings:
        db 043h,068h,061h,06Eh,067h,065h,020h,04Ch,065h,061h,067h,075h,065h,020h,050h,06Ch
        db 061h,079h,020h,053h,065h,074h,074h,069h,06Eh,067h,073h,020h,02Eh,02Eh,02Eh,00h
str_LeagueHilights:
        db 04Ch,065h,061h,067h,075h,065h,020h,048h,069h,06Ch,069h,067h,068h,074h,073h,020h
        db 02Eh,02Eh,02Eh,00h
str_File2:
        db 046h,069h,06Ch,065h,00h
str_Settings4:
        db 053h,065h,074h,074h,069h,06Eh,067h,073h,00h
str_Statistics5:
        db 053h,074h,061h,074h,069h,073h,074h,069h,063h,073h,00h
str_PlayNextGame:
        db 050h,06Ch,061h,079h,020h,04Eh,065h,078h,074h,020h,047h,061h,06Dh,065h,020h,02Eh
        db 02Eh,02Eh,00h
str_ReturnToSportsCentral2:
        db 052h,065h,074h,075h,072h,06Eh,020h,054h,06Fh,020h,053h,070h,06Fh,072h,074h,073h
        db 020h,043h,065h,06Eh,074h,072h,061h,06Ch,00h
str_StatisticsType8:
        db 053h,074h,061h,074h,069h,073h,074h,069h,063h,073h,020h,054h,079h,070h,065h,020h
        db 03h,00h
str_Standings2:
        db 053h,074h,061h,06Eh,064h,069h,06Eh,067h,073h,020h,02Eh,02Eh,02Eh,00h
str_TeamsSortedBy2:
        db 054h,065h,061h,06Dh,073h,020h,053h,06Fh,072h,074h,065h,064h,020h,042h,079h,020h
        db 03h,00h
str_PlayersSortedBy2:
        db 050h,06Ch,061h,079h,065h,072h,073h,020h,053h,06Fh,072h,074h,065h,064h,020h,042h
        db 079h,020h,03h,00h
str_GoaliesSortedBy2:
        db 047h,06Fh,061h,06Ch,069h,065h,073h,020h,053h,06Fh,072h,074h,065h,064h,020h,042h
        db 079h,020h,03h,00h
str_Scoring:
        db 053h,063h,06Fh,072h,069h,06Eh,067h,020h,02Eh,02Eh,02Eh,00h
str_Defense4:
        db 044h,065h,066h,065h,06Eh,073h,065h,020h,02Eh,02Eh,02Eh,00h
str_PenaltyKilling2:
        db 050h,065h,06Eh,061h,06Ch,074h,079h,020h,04Bh,069h,06Ch,06Ch,069h,06Eh,067h,020h
        db 02Eh,02Eh,02Eh,00h
str_PowerPlay2:
        db 050h,06Fh,077h,065h,072h,020h,050h,06Ch,061h,079h,020h,02Eh,02Eh,02Eh,00h
str_Penalties:
        db 050h,065h,06Eh,061h,06Ch,074h,069h,065h,073h,020h,02Eh,02Eh,02Eh,00h
str_Points:
        db 050h,06Fh,069h,06Eh,074h,073h,020h,02Eh,02Eh,02Eh,00h
str_Goals:
        db 047h,06Fh,061h,06Ch,073h,020h,02Eh,02Eh,02Eh,00h
str_Assists2:
        db 041h,073h,073h,069h,073h,074h,073h,020h,02Eh,02Eh,02Eh,00h
str_PowerPlayGoals:
        db 050h,06Fh,077h,065h,072h,020h,050h,06Ch,061h,079h,020h,047h,06Fh,061h,06Ch,073h
        db 020h,02Eh,02Eh,02Eh,00h
str_ShorthandedGoals:
        db 053h,068h,06Fh,072h,074h,068h,061h,06Eh,064h,065h,064h,020h,047h,06Fh,061h,06Ch
        db 073h,020h,02Eh,02Eh,02Eh,00h
str_PlusMinus4:
        db 050h,06Ch,075h,073h,02Fh,04Dh,069h,06Eh,075h,073h,020h,02Eh,02Eh,02Eh,00h
str_PenaltyMinutes:
        db 050h,065h,06Eh,061h,06Ch,074h,079h,020h,04Dh,069h,06Eh,075h,074h,065h,073h,020h
        db 02Eh,02Eh,02Eh,00h
str_ShootingPercentage:
        db 053h,068h,06Fh,06Fh,074h,069h,06Eh,067h,020h,050h,065h,072h,063h,065h,06Eh,074h
        db 061h,067h,065h,020h,02Eh,02Eh,02Eh,00h
str_GoalsAgainstAverage:
        db 047h,06Fh,061h,06Ch,073h,020h,041h,067h,061h,069h,06Eh,073h,074h,020h,041h,076h
        db 065h,072h,061h,067h,065h,020h,02Eh,02Eh,02Eh,00h
str_Wins2:
        db 057h,069h,06Eh,073h,020h,02Eh,02Eh,02Eh,00h
str_SavePercentage:
        db 053h,061h,076h,065h,020h,050h,065h,072h,063h,065h,06Eh,074h,061h,067h,065h,020h
        db 02Eh,02Eh,02Eh,00h
str_StatisticsType:
        db 053h,074h,061h,074h,069h,073h,074h,069h,063h,073h,020h,054h,079h,070h,065h,00h
str_LineEditor2:
        db 04Ch,069h,06Eh,065h,020h,045h,064h,069h,074h,06Fh,072h,00h
str_Roster:
        db 052h,06Fh,073h,074h,065h,072h,00h
str_PlayerStatistics:
        db 050h,06Ch,061h,079h,065h,072h,020h,053h,074h,061h,074h,069h,073h,074h,069h,063h
        db 073h,00h
str_SaveTheseLines:
        db 053h,061h,076h,065h,020h,054h,068h,065h,073h,065h,020h,04Ch,069h,06Eh,065h,073h
        db 00h
str_UseTheseLines:
        db 055h,073h,065h,020h,054h,068h,065h,073h,065h,020h,04Ch,069h,06Eh,065h,073h,00h
str_UseOriginalLines:
        db 055h,073h,065h,020h,04Fh,072h,069h,067h,069h,06Eh,061h,06Ch,020h,04Ch,069h,06Eh
        db 065h,073h,00h
str_UseDefaultLines:
        db 055h,073h,065h,020h,044h,065h,066h,061h,075h,06Ch,074h,020h,04Ch,069h,06Eh,065h
        db 073h,00h
str_SaveAsDefaultLines:
        db 053h,061h,076h,065h,020h,041h,073h,020h,044h,065h,066h,061h,075h,06Ch,074h,020h
        db 04Ch,069h,06Eh,065h,073h,00h
str_DressPlayer:
        db 044h,072h,065h,073h,073h,020h,050h,06Ch,061h,079h,065h,072h,00h
str_ScratchPlayer:
        db 053h,063h,072h,061h,074h,063h,068h,020h,050h,06Ch,061h,079h,065h,072h,00h
str_ShowPlayerStatistics:
        db 053h,068h,06Fh,077h,020h,050h,06Ch,061h,079h,065h,072h,020h,053h,074h,061h,074h
        db 069h,073h,074h,069h,063h,073h,00h
str_LineEditor3:
        db 04Ch,069h,06Eh,065h,020h,045h,064h,069h,074h,06Fh,072h,00h
str_PlayerStatistics2:
        db 050h,06Ch,061h,079h,065h,072h,020h,053h,074h,061h,074h,069h,073h,074h,069h,063h
        db 073h,00h
str_Cancel4:
        db 043h,061h,06Eh,063h,065h,06Ch,00h
str_UseTheseLines2:
        db 055h,073h,065h,020h,054h,068h,065h,073h,065h,020h,04Ch,069h,06Eh,065h,073h,00h
str_UseOriginalLines2:
        db 055h,073h,065h,020h,04Fh,072h,069h,067h,069h,06Eh,061h,06Ch,020h,04Ch,069h,06Eh
        db 065h,073h,00h
str_UseDefaultLines2:
        db 055h,073h,065h,020h,044h,065h,066h,061h,075h,06Ch,074h,020h,04Ch,069h,06Eh,065h
        db 073h,00h
str_SaveAsDefaultLines2:
        db 053h,061h,076h,065h,020h,041h,073h,020h,044h,065h,066h,061h,075h,06Ch,074h,020h
        db 04Ch,069h,06Eh,065h,073h,00h
str_LineEditor4:
        db 04Ch,069h,06Eh,065h,020h,045h,064h,069h,074h,06Fh,072h,00h
str_StatisticsType2:
        db 053h,074h,061h,074h,069h,073h,074h,069h,063h,073h,020h,054h,079h,070h,065h,00h
str_ReturnTo:
        db 052h,065h,074h,075h,072h,06Eh,020h,054h,06Fh,00h
str_SportsDesk2:
        db 053h,070h,06Fh,072h,074h,073h,020h,044h,065h,073h,06Bh,00h
str_SportsCentral:
        db 053h,070h,06Fh,072h,074h,073h,020h,043h,065h,06Eh,074h,072h,061h,06Ch,00h
str_LeagueCalendar:
        db 04Ch,065h,061h,067h,075h,065h,020h,043h,061h,06Ch,065h,06Eh,064h,061h,072h,00h
str_PlayoffTree:
        db 050h,06Ch,061h,079h,06Fh,066h,066h,020h,054h,072h,065h,065h,00h
str_BroadcastBooth:
        db 042h,072h,06Fh,061h,064h,063h,061h,073h,074h,020h,042h,06Fh,06Fh,074h,068h,00h
str_IntermissionDesk:
        db 049h,06Eh,074h,065h,072h,06Dh,069h,073h,073h,069h,06Fh,06Eh,020h,044h,065h,073h
        db 06Bh,00h
str_RinkSide:
        db 052h,069h,06Eh,06Bh,020h,053h,069h,064h,065h,00h
str_ReturnTo2:
        db 052h,065h,074h,075h,072h,06Eh,020h,054h,06Fh,00h
str_Roster3:
        db 052h,06Fh,073h,074h,065h,072h,00h
str_StatisticsType3:
        db 053h,074h,061h,074h,069h,073h,074h,069h,063h,073h,020h,054h,079h,070h,065h,00h
str_TeamRoster:
        db 054h,065h,061h,06Dh,020h,052h,06Fh,073h,074h,065h,072h,00h
str_OverallStandings:
        db 04Fh,076h,065h,072h,061h,06Ch,06Ch,020h,053h,074h,061h,06Eh,064h,069h,06Eh,067h
        db 073h,00h
str_ShowTeamRoster:
        db 053h,068h,06Fh,077h,020h,054h,065h,061h,06Dh,020h,052h,06Fh,073h,074h,065h,072h
        db 00h
str_ReturnTo3:
        db 052h,065h,074h,075h,072h,06Eh,020h,054h,06Fh,00h
str_PlayerStatistics3:
        db 050h,06Ch,061h,079h,065h,072h,020h,053h,074h,061h,074h,069h,073h,074h,069h,063h
        db 073h,00h
str_StatisticsType4:
        db 053h,074h,061h,074h,069h,073h,074h,069h,063h,073h,020h,054h,079h,070h,065h,00h
str_ShowPlayerStatisticsAnd:
        db 053h,068h,06Fh,077h,020h,050h,06Ch,061h,079h,065h,072h,020h,053h,074h,061h,074h
        db 069h,073h,074h,069h,063h,073h,020h,041h,06Eh,064h,020h,041h,074h,074h,072h,069h
        db 062h,075h,074h,065h,073h,00h
str_ReturnTo4:
        db 052h,065h,074h,075h,072h,06Eh,020h,054h,06Fh,00h,053h,074h,061h,074h,069h,073h
        db 074h,069h,063h,073h,020h,054h,079h,070h,065h,00h
str_StatisticsType5:
        db 053h,074h,061h,074h,069h,073h,074h,069h,063h,073h,020h,054h,079h,070h,065h,00h
str_TeamsSortedBy:
        db 054h,065h,061h,06Dh,073h,020h,053h,06Fh,072h,074h,065h,064h,020h,042h,079h,00h
str_StatisticsType6:
        db 053h,074h,061h,074h,069h,073h,074h,069h,063h,073h,020h,054h,079h,070h,065h,00h
str_PlayersSortedBy:
        db 050h,06Ch,061h,079h,065h,072h,073h,020h,053h,06Fh,072h,074h,065h,064h,020h,042h
        db 079h,00h
str_StatisticsType7:
        db 053h,074h,061h,074h,069h,073h,074h,069h,063h,073h,020h,054h,079h,070h,065h,00h
str_GoaliesSortedBy:
        db 047h,06Fh,061h,06Ch,069h,065h,073h,020h,053h,06Fh,072h,074h,065h,064h,020h,042h
        db 079h,00h
str_Print:
        db 050h,072h,069h,06Eh,074h,00h
str_OutputCurrentData:
        db 04Fh,075h,074h,070h,075h,074h,020h,043h,075h,072h,072h,065h,06Eh,074h,020h,044h
        db 061h,074h,061h,020h,02Eh,02Eh,02Eh,00h,052h,061h,064h,061h,072h,027h,073h,020h
        db 043h,06Ch,069h,070h,073h,00h
mainmenubar:
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 020h,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_File
        db 00h,00h,00h,00h
        dd filemenu
        db 012h,00h,00h,00h,021h,00h,00h,00h,00h,00h,00h,00h,04Ch,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_Game6
        db 00h,00h,00h,00h
        dd gamemenu
        db 07h,00h,00h,00h,04Dh,00h,00h,00h,00h,00h,00h,00h,092h,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_Statistics3
        db 00h,00h,00h,00h
        dd statsmenu
        db 05h,00h,00h,00h
filemenu:
        db 00h,00h,00h,00h,00h,00h,00h,00h,0A5h,00h,00h,00h,011h,00h,00h,00h
        dd str_Open5
        dd MenuOpenSaved
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
        db 0A5h,00h,00h,00h,023h,00h,00h,00h
        dd str_FileMenuDivider
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 024h,00h,00h,00h,0A5h,00h,00h,00h,035h,00h,00h,00h
        dd str_NewExhibitionGame
        dd MenuNewExhibition
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,036h,00h,00h,00h
        db 0A5h,00h,00h,00h,047h,00h,00h,00h
        dd str_FileMenuDivider
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 048h,00h,00h,00h,0A5h,00h,00h,00h,059h,00h,00h,00h
        dd str_NewLeague
        dd MenuNewLeague
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,05Ah,00h,00h,00h
        db 0A5h,00h,00h,00h,06Bh,00h,00h,00h
        dd str_ImportDatabases
        dd MenuImportDbs
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,06Ch,00h,00h,00h
        db 0A5h,00h,00h,00h,07Dh,00h,00h,00h
        dd str_ExportDatabases
menuact_export:
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 07Eh,00h,00h,00h,0A5h,00h,00h,00h,08Fh,00h,00h,00h
        dd str_NextLeagueGame
menuact_nextlg:
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 090h,00h,00h,00h,0A5h,00h,00h,00h,0A1h,00h,00h,00h
        dd str_LeagueManager
        db 00h,00h,00h,00h
menusub_lgmgr:
        db 00h,00h,00h,00h,0Dh,00h,00h,00h,00h,00h,00h,00h,0A2h,00h,00h,00h
        db 0A5h,00h,00h,00h,0B3h,00h,00h,00h
        dd str_FileMenuDivider
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 0B4h,00h,00h,00h,0A5h,00h,00h,00h,0C5h,00h,00h,00h
        dd str_NewPlayOffSeries
        dd CreatePlayoffs
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0C6h,00h,00h,00h
        db 0A5h,00h,00h,00h,0D7h,00h,00h,00h
        dd str_NextPlayOffGame
menuact_nextpo:
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 0D8h,00h,00h,00h,0A5h,00h,00h,00h,0E9h,00h,00h,00h
        dd str_PlayOffSettings
menuact_posettings:
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 0EAh,00h,00h,00h,0A5h,00h,00h,00h,0FBh,00h,00h,00h
        dd str_PlayOffHilights
menuact_pohilights:
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 0FCh,00h,00h,00h,0A5h,00h,00h,00h,0Dh,01h,00h,00h
        dd str_FileMenuDivider
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 0Eh,01h,00h,00h,0A5h,00h,00h,00h,01Fh,01h,00h,00h
        dd str_CentralRegistry
        dd MenuCentralRegistry
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,020h,01h,00h,00h
        db 0A5h,00h,00h,00h,031h,01h,00h,00h
        dd str_FileMenuDivider
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 032h,01h,00h,00h,0A5h,00h,00h,00h,044h,01h,00h,00h
        dd str_Exit
        dd MenuExit
        db 00h,00h,00h,00h,00h,00h,00h,00h
leaguemgrmenu:
        db 00h,00h,00h,00h,00h,00h,00h,00h,0FDh,00h,00h,00h,011h,00h,00h,00h
        dd str_MergeLeagueFiles
        dd MenuMergeLeagueFiles
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
        db 0FDh,00h,00h,00h,023h,00h,00h,00h
        dd str_LeagueMenuDivider
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 024h,00h,00h,00h,0FDh,00h,00h,00h,035h,00h,00h,00h
        dd str_RemoveTeamFromLeague
        dd MenuRemoveTeam
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,036h,00h,00h,00h
        db 0FDh,00h,00h,00h,047h,00h,00h,00h
        dd str_AddTeamToLeague
        dd MenuAddTeam
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,048h,00h,00h,00h
        db 0FDh,00h,00h,00h,059h,00h,00h,00h
        dd str_LeagueMenuDivider
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 05Ah,00h,00h,00h,0FDh,00h,00h,00h,06Bh,00h,00h,00h
        dd str_TradePlayers
        dd MenuTradePlayers
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,06Ch,00h,00h,00h
        db 0FDh,00h,00h,00h,07Dh,00h,00h,00h
        dd str_LeagueMenuDivider
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 07Eh,00h,00h,00h,0FDh,00h,00h,00h,08Fh,00h,00h,00h
        dd str_RebuildDataBases
        dd MenuRebuildDbs
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,090h,00h,00h,00h
        db 0FDh,00h,00h,00h,0A1h,00h,00h,00h
        dd str_MergeAndUpdateTeam
        dd MenuMergeUpdateDbs
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0A2h,00h,00h,00h
        db 0FDh,00h,00h,00h,0B3h,00h,00h,00h
        dd str_ChangeLeaguePlaySettings
        dd MenuLeagueSettings
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0B4h,00h,00h,00h
        db 0FDh,00h,00h,00h,0C5h,00h,00h,00h
        dd str_LeagueHilights
        dd MenuLeagueHilights
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0C6h,00h,00h,00h
        db 0FDh,00h,00h,00h,0D7h,00h,00h,00h
        dd str_LeagueMenuDivider
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 0D8h,00h,00h,00h,0FDh,00h,00h,00h,0EAh,00h,00h,00h
        dd str_UpdateTeamsDataBases
        dd MenuUpdateTeamDbs
        db 00h,00h,00h,00h,00h,00h,00h,00h
gamemenu:
        db 00h,00h,00h,00h,00h,00h,00h,00h,092h,00h,00h,00h,011h,00h,00h,00h
        dd str_GameLabel
        dd LockerRoomScreen
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
        db 092h,00h,00h,00h,023h,00h,00h,00h
        dd str_ExhibitionSettings
        dd MenuExhibitionSettings
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h
        db 092h,00h,00h,00h,035h,00h,00h,00h
        dd str_Dashes2
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 036h,00h,00h,00h,092h,00h,00h,00h,047h,00h,00h,00h
        dd str_Player1Controls2
        dd MenuP1ControlsExh
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,048h,00h,00h,00h
        db 092h,00h,00h,00h,059h,00h,00h,00h
        dd str_Player2Controls2
        dd MenuP2ControlsExh
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,05Ah,00h,00h,00h
        db 092h,00h,00h,00h,06Bh,00h,00h,00h
        dd str_Dashes2
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 06Ch,00h,00h,00h,092h,00h,00h,00h,07Eh,00h,00h,00h
        dd str_SoundSettings
        dd MenuSoundSettings
        db 00h,00h,00h,00h,00h,00h,00h,00h
statsmenu:
        db 00h,00h,00h,00h,00h,00h,00h,00h,08Ch,00h,00h,00h,011h,00h,00h,00h
        dd str_StatisticsType8
        db 00h,00h,00h,00h
        dd StatsSourceMenu
statsmenu_srccnt:
        db 04h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h,08Ch,00h,00h,00h
        db 023h,00h,00h,00h
        dd str_Standings2
        dd EasnStandingsMenu
        db 00h,00h,00h,00h,01h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h
        db 08Ch,00h,00h,00h,035h,00h,00h,00h
        dd str_TeamsSortedBy2
        db 00h,00h,00h,00h
        dd TeamStatsSortMenu
        db 06h,00h,00h,00h,00h,00h,00h,00h,036h,00h,00h,00h,08Ch,00h,00h,00h
        db 047h,00h,00h,00h
        dd str_PlayersSortedBy2
        db 00h,00h,00h,00h
        dd SkaterStatsSortMenu
        db 08h,00h,00h,00h,00h,00h,00h,00h,048h,00h,00h,00h,08Ch,00h,00h,00h
        db 05Ah,00h,00h,00h
        dd str_GoaliesSortedBy2
        db 00h,00h,00h,00h
        dd GoalieStatsSortMenu
        db 03h,00h,00h,00h
TeamStatsSortMenu:
        db 00h,00h,00h,00h,00h,00h,00h,00h,07Ch,00h,00h,00h,011h,00h,00h,00h
        dd str_Standings2
        dd StatsMenuStandings
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
        db 07Ch,00h,00h,00h,023h,00h,00h,00h
        dd str_Scoring
        dd StatsMenuTeamScoring
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h
        db 07Ch,00h,00h,00h,035h,00h,00h,00h
        dd str_Defense4
        dd StatsMenuTeamDefense
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,036h,00h,00h,00h
        db 07Ch,00h,00h,00h,047h,00h,00h,00h
        dd str_PenaltyKilling2
        dd StatsMenuPenaltyKilling
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,048h,00h,00h,00h
        db 07Ch,00h,00h,00h,059h,00h,00h,00h
        dd str_PowerPlay2
        dd StatsMenuPowerPlay
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,05Ah,00h,00h,00h
        db 07Ch,00h,00h,00h,06Ch,00h,00h,00h
        dd str_Penalties
        dd StatsMenuTeamPenalties
        db 00h,00h,00h,00h,00h,00h,00h,00h
SkaterStatsSortMenu:
        db 00h,00h,00h,00h,00h,00h,00h,00h,09Fh,00h,00h,00h,011h,00h,00h,00h
        dd str_Points
        dd StatsMenuPoints
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
        db 09Fh,00h,00h,00h,023h,00h,00h,00h
        dd str_Goals
        dd StatsMenuGoals
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h
        db 09Fh,00h,00h,00h,035h,00h,00h,00h
        dd str_Assists2
        dd StatsMenuAssists
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,036h,00h,00h,00h
        db 09Fh,00h,00h,00h,047h,00h,00h,00h
        dd str_PowerPlayGoals
        dd StatsMenuPPGoals
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,048h,00h,00h,00h
        db 09Fh,00h,00h,00h,059h,00h,00h,00h
        dd str_ShorthandedGoals
        dd StatsMenuSHGoals
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,05Ah,00h,00h,00h
        db 09Fh,00h,00h,00h,06Bh,00h,00h,00h
        dd str_PlusMinus4
        dd StatsMenuPlusMinus
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,06Ch,00h,00h,00h
        db 09Fh,00h,00h,00h,07Dh,00h,00h,00h
        dd str_PenaltyMinutes
        dd StatsMenuPIM
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,07Eh,00h,00h,00h
        db 09Fh,00h,00h,00h,090h,00h,00h,00h
        dd str_ShootingPercentage
        dd StatsMenuShootPct
        db 00h,00h,00h,00h,00h,00h,00h,00h
GoalieStatsSortMenu:
        db 00h,00h,00h,00h,00h,00h,00h,00h,0ABh,00h,00h,00h,011h,00h,00h,00h
        dd str_GoalsAgainstAverage
        dd StatsMenuGAA
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
        db 0ABh,00h,00h,00h,023h,00h,00h,00h
        dd str_Wins2
        dd StatsMenuGoalieWins
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h
        db 0ABh,00h,00h,00h,036h,00h,00h,00h
        dd str_SavePercentage
        dd StatsMenuSavePct
        db 00h,00h,00h,00h,00h,00h,00h,00h
deskmenubar:
        db 00h,00h,00h,00h,00h,00h,00h,00h,02Eh,00h,00h,00h,012h,00h,00h,00h
        dd str_Action
        db 00h,00h,00h,00h
        dd DeskFileMenu
        db 04h,00h,00h,00h,02Fh,00h,00h,00h,00h,00h,00h,00h,05Ah,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_Game7
        db 00h,00h,00h,00h
        dd DeskSettingsMenu
        db 07h,00h,00h,00h,05Bh,00h,00h,00h,00h,00h,00h,00h,0A0h,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_Statistics4
        db 00h,00h,00h,00h
        dd DeskStatsTypeMenu
        db 05h,00h,00h,00h,0A1h,00h,00h,00h,00h,00h,00h,00h,0EDh,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_LineEditor
        db 00h,00h,00h,00h
        dd DeskTeamLinesMenu
        db 02h,00h,00h,00h,0EEh,00h,00h,00h,00h,00h,00h,00h,058h,01h,00h,00h
        db 012h,00h,00h,00h
        dd str_InstantReplay
        db 00h,00h,00h,00h
        dd DeskReplayMenu
        db 01h,00h,00h,00h,059h,01h,00h,00h,00h,00h,00h,00h,0C6h,01h,00h,00h
        db 012h,00h,00h,00h
        dd str_GameSummary
        db 00h,00h,00h,00h
        dd DeskGameStatsMenu
        db 04h,00h,00h,00h
deskmenubar_lg:
        db 00h,00h,00h,00h,00h,00h,00h,00h,02Eh,00h,00h,00h,012h,00h,00h,00h
        dd str_Action
        db 00h,00h,00h,00h
        dd DeskLeagueFileMenu
        db 02h,00h,00h,00h,02Fh,00h,00h,00h,00h,00h,00h,00h,074h,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_Statistics4
        db 00h,00h,00h,00h
        dd DeskStatsTypeMenu
        db 05h,00h,00h,00h,075h,00h,00h,00h,00h,00h,00h,00h,0E1h,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_GameSummary
        db 00h,00h,00h,00h
        dd DeskGameStatsMenu
        db 04h,00h,00h,00h
DeskFileMenu:
        db 00h,00h,00h,00h,00h,00h,00h,00h,076h,00h,00h,00h,011h,00h,00h,00h
        dd str_BackToGame
        dd DeskBackToGame
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
        db 076h,00h,00h,00h,023h,00h,00h,00h
        dd str_SaveGame2
        dd MenuSaveGame
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h
        db 076h,00h,00h,00h,035h,00h,00h,00h
menutext_deskreturn:
        dd str_SportsDesk
        dd DeskReturnConfirm
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,036h,00h,00h,00h
        db 076h,00h,00h,00h,048h,00h,00h,00h
        dd str_Exit2
        dd DeskExitGame
        db 00h,00h,00h,00h,00h,00h,00h,00h
DeskLeagueFileMenu:
        db 00h,00h,00h,00h,00h,00h,00h,00h,076h,00h,00h,00h,011h,00h,00h,00h
menutext_desktodesk:
        dd str_SportsDesk
        dd DeskToSportsDesk
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
        db 076h,00h,00h,00h,024h,00h,00h,00h
        dd str_Exit2
        dd DeskExitGame
        db 00h,00h,00h,00h,00h,00h,00h,00h
DeskSettingsMenu:
        db 00h,00h,00h,00h,00h,00h,00h,00h,0A9h,00h,00h,00h,011h,00h,00h,00h
        dd str_Player1Controls2
        dd MenuP1ControlsInGame
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
        db 0A9h,00h,00h,00h,023h,00h,00h,00h
        dd str_Player2Controls2
        dd MenuP2ControlsInGame
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h
        db 0A9h,00h,00h,00h,035h,00h,00h,00h
        dd str_Dashes3
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 036h,00h,00h,00h,0A9h,00h,00h,00h,047h,00h,00h,00h
        dd str_HomeTeamGoalie
        db 00h,00h,00h,00h
