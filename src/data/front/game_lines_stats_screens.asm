; Line-editor menu actions: use these lines, save them, scratch a player, or dress him.
bits 32
%include "hockey.inc"
section s_CF00B progbits alloc noexec write align=1
extern DeskSetExit1, DeskSetExit2, DeskSetExit3, DeskSetExit3b, ShowPlayerStatsItem, OutputCurrentData, GameStandingsMenu, MenuUseTheseLines
extern MenuLineEdCancel, MenuUseOriginalLines, MenuUseDefaultLines, MenuGameShowPlayerStats, MenuReturnToLineEditor, GameScratchPlayer, GameDressPlayer, MenuSaveDefaultLines
extern MenuSaveTheseLines, StatsSourceMenu, str_Action, str_Game7, str_InstantReplay, str_LineEditor, str_Statistics4, str_GameSummary
extern str_Standings2, str_TeamsSortedBy2, str_PlayersSortedBy2, str_GoaliesSortedBy2, str_LineEditor2, str_Roster, str_PlayerStatistics, str_SaveTheseLines
extern str_UseTheseLines, str_UseOriginalLines, str_UseDefaultLines, str_SaveAsDefaultLines, str_DressPlayer, str_ScratchPlayer, str_ShowPlayerStatistics, str_LineEditor3
extern str_PlayerStatistics2, str_Cancel4, str_UseTheseLines2, str_UseOriginalLines2, str_UseDefaultLines2, str_SaveAsDefaultLines2, str_LineEditor4, str_StatisticsType2
extern str_ReturnTo, str_SportsDesk2, str_ReturnTo2, str_Roster3, str_StatisticsType3, str_TeamRoster, str_OverallStandings, str_ShowTeamRoster
extern str_ReturnTo3, str_PlayerStatistics3, str_StatisticsType4, str_ShowPlayerStatisticsAnd, str_ReturnTo4, str_StatisticsType5, str_TeamsSortedBy, str_StatisticsType6
extern str_PlayersSortedBy, str_StatisticsType7, str_GoaliesSortedBy, str_Print, str_OutputCurrentData, TeamStatsSortMenu, SkaterStatsSortMenu, GoalieStatsSortMenu
extern DeskFileMenu, DeskSettingsMenu, DeskReplayMenu, DeskTeamLinesMenu, DeskGameStatsMenu, DeskStatsTypeMenu
global deskstatsmenu_srccnt, gameplstatsmenubar_srccnt, StatsReturnRight, standingsmenubar_srccnt, StandingsReturnRight, RosterReturnStandingsRight, RosterReturnDeskRight, PlayerCardReturnRosterRight
global PlayerCardReturnStandingsRight, PlayerCardReturnDeskRight, rostermenubar_srccnt, teamstatsmenubar_srccnt, skaterstatsmenubar_srccnt, goaliestatsmenubar_srccnt, menuact_uselines2, menuact_savedeflines2
global menuact_gamedress, menuact_gamescratch, menuact_uselines, menuact_savedeflines, menuact_savelines, StatsReturnText, StandingsReturnText, RosterReturnDeskText
global PlayerCardReturnDeskText, StandingsRosterAction, pregamelinesmenubar, PregameLinesMenu, GameRosterMenu, ShowPlayerStatsMenu, desklinesmenubar, DeskLinesEditMenu
global tradelinesmenubar, TradeLinesMenu, gameplstatsmenubar, GameStatsReturnMenu, StatsReturnMenu, PrintMenu, standingsmenubar, StandingsReturnMenu
global RosterReturnMenu, PlayerCardReturnMenu, StandingsRosterMenu, rostermenubar, RosterPlayerMenu, playercardmenubar, teamstatsmenubar, skaterstatsmenubar
global goaliestatsmenubar
deskstatsmenu_srccnt:
        db 02h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h,08Ch,00h,00h,00h
        db 023h,00h,00h,00h
        dd str_Standings2
        dd GameStandingsMenu
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
        db 03h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02Eh,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_Action
        db 00h,00h,00h,00h
        dd DeskFileMenu
        db 04h,00h,00h,00h,02Fh,00h,00h,00h,00h,00h,00h,00h,05Ah,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_Game7
        db 00h,00h,00h,00h
        dd DeskSettingsMenu
        db 04h,00h,00h,00h,05Bh,00h,00h,00h,00h,00h,00h,00h,0C5h,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_InstantReplay
        db 00h,00h,00h,00h
        dd DeskReplayMenu
        db 01h,00h,00h,00h,0C6h,00h,00h,00h,00h,00h,00h,00h,013h,01h,00h,00h
        db 012h,00h,00h,00h
        dd str_LineEditor
        db 00h,00h,00h,00h
        dd DeskTeamLinesMenu
        db 02h,00h,00h,00h,014h,01h,00h,00h,00h,00h,00h,00h,059h,01h,00h,00h
        db 012h,00h,00h,00h
        dd str_Statistics4
        db 00h,00h,00h,00h
        dd DeskStatsTypeMenu
        db 05h,00h,00h,00h,05Ah,01h,00h,00h,00h,00h,00h,00h,0C7h,01h,00h,00h
        db 012h,00h,00h,00h
        dd str_GameSummary
        db 00h,00h,00h,00h
        dd DeskGameStatsMenu
        db 03h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,04Dh,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_LineEditor2
        db 00h,00h,00h,00h
        dd PregameLinesMenu
        db 04h,00h,00h,00h,04Eh,00h,00h,00h,00h,00h,00h,00h,080h,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_Roster
        db 00h,00h,00h,00h
        dd GameRosterMenu
        db 02h,00h,00h,00h,081h,00h,00h,00h,00h,00h,00h,00h,0F7h,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_PlayerStatistics
        db 00h,00h,00h,00h
        dd ShowPlayerStatsMenu
        db 01h,00h,00h,00h
pregamelinesmenubar:
        db 00h,00h,00h,00h,00h,00h,00h,00h,04Dh,00h,00h,00h,012h,00h,00h,00h
        dd str_LineEditor2
        db 00h,00h,00h,00h
        dd PregameLinesMenu
        db 04h,00h,00h,00h,04Eh,00h,00h,00h,00h,00h,00h,00h,080h,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_Roster
        db 00h,00h,00h,00h
        dd GameRosterMenu
        db 02h,00h,00h,00h,081h,00h,00h,00h,00h,00h,00h,00h,0F7h,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_PlayerStatistics
        db 00h,00h,00h,00h
        dd ShowPlayerStatsMenu
        db 01h,00h,00h,00h
PregameLinesMenu:
        db 00h,00h,00h,00h,00h,00h,00h,00h,098h,00h,00h,00h,011h,00h,00h,00h
        dd str_UseTheseLines
menuact_uselines2:
        dd MenuUseTheseLines
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
        db 098h,00h,00h,00h,023h,00h,00h,00h
        dd str_UseOriginalLines
        dd MenuUseOriginalLines
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h
        db 098h,00h,00h,00h,035h,00h,00h,00h
        dd str_UseDefaultLines
        dd MenuUseDefaultLines
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,036h,00h,00h,00h
        db 098h,00h,00h,00h,048h,00h,00h,00h
        dd str_SaveAsDefaultLines
menuact_savedeflines2:
        dd MenuSaveDefaultLines
        db 00h,00h,00h,00h,00h,00h,00h,00h
GameRosterMenu:
        db 00h,00h,00h,00h,00h,00h,00h,00h,068h,00h,00h,00h,011h,00h,00h,00h
        dd str_DressPlayer
menuact_gamedress:
        dd GameDressPlayer
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
        db 068h,00h,00h,00h,024h,00h,00h,00h
        dd str_ScratchPlayer
menuact_gamescratch:
        dd GameScratchPlayer
        db 00h,00h,00h,00h,00h,00h,00h,00h
ShowPlayerStatsMenu:
        db 00h,00h,00h,00h,00h,00h,00h,00h,09Ch,00h,00h,00h,012h,00h,00h,00h
        dd str_ShowPlayerStatistics
        dd MenuGameShowPlayerStats
        db 00h,00h,00h,00h,00h,00h,00h,00h
desklinesmenubar:
        db 00h,00h,00h,00h,00h,00h,00h,00h,04Dh,00h,00h,00h,012h,00h,00h,00h
        dd str_LineEditor3
        db 00h,00h,00h,00h
        dd DeskLinesEditMenu
        db 05h,00h,00h,00h,04Eh,00h,00h,00h,00h,00h,00h,00h,0C4h,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_PlayerStatistics2
        db 00h,00h,00h,00h
        dd ShowPlayerStatsMenu
        db 01h,00h,00h,00h
DeskLinesEditMenu:
        db 00h,00h,00h,00h,00h,00h,00h,00h,098h,00h,00h,00h,011h,00h,00h,00h
        dd str_Cancel4
        dd MenuLineEdCancel
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
        db 098h,00h,00h,00h,023h,00h,00h,00h
        dd str_UseTheseLines2
menuact_uselines:
        dd MenuUseTheseLines
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h
        db 098h,00h,00h,00h,035h,00h,00h,00h
        dd str_UseOriginalLines2
        dd MenuUseOriginalLines
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,036h,00h,00h,00h
        db 098h,00h,00h,00h,047h,00h,00h,00h
        dd str_UseDefaultLines2
        dd MenuUseDefaultLines
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,048h,00h,00h,00h
        db 098h,00h,00h,00h,05Ah,00h,00h,00h
        dd str_SaveAsDefaultLines2
menuact_savedeflines:
        dd MenuSaveDefaultLines
        db 00h,00h,00h,00h,00h,00h,00h,00h
tradelinesmenubar:
        db 00h,00h,00h,00h,00h,00h,00h,00h,04Dh,00h,00h,00h,012h,00h,00h,00h
        dd str_LineEditor2
        db 00h,00h,00h,00h
        dd TradeLinesMenu
        db 03h,00h,00h,00h,04Eh,00h,00h,00h,00h,00h,00h,00h,080h,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_Roster
        db 00h,00h,00h,00h
        dd GameRosterMenu
        db 02h,00h,00h,00h,081h,00h,00h,00h,00h,00h,00h,00h,0F7h,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_PlayerStatistics
        db 00h,00h,00h,00h
        dd ShowPlayerStatsMenu
        db 01h,00h,00h,00h
TradeLinesMenu:
        db 00h,00h,00h,00h,00h,00h,00h,00h,098h,00h,00h,00h,011h,00h,00h,00h
        dd str_SaveTheseLines
menuact_savelines:
        dd MenuSaveTheseLines
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
        db 098h,00h,00h,00h,023h,00h,00h,00h
        dd str_UseOriginalLines
        dd MenuUseOriginalLines
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h
        db 098h,00h,00h,00h,036h,00h,00h,00h
        dd str_UseDefaultLines
        dd MenuUseDefaultLines
        db 00h,00h,00h,00h,00h,00h,00h,00h
gameplstatsmenubar:
        db 00h,00h,00h,00h,00h,00h,00h,00h,045h,00h,00h,00h,012h,00h,00h,00h
        dd str_ReturnTo
        db 00h,00h,00h,00h
        dd GameStatsReturnMenu
        db 01h,00h,00h,00h,046h,00h,00h,00h,00h,00h,00h,00h,0AEh,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_StatisticsType2
        db 00h,00h,00h,00h
        dd StatsSourceMenu
gameplstatsmenubar_srccnt:
        db 04h,00h,00h,00h
GameStatsReturnMenu:
        db 00h,00h,00h,00h,00h,00h,00h,00h,04Dh,00h,00h,00h,012h,00h,00h,00h
        dd str_LineEditor4
        dd MenuReturnToLineEditor
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 046h,00h,00h,00h,012h,00h,00h,00h
        dd str_ReturnTo
        db 00h,00h,00h,00h
        dd StatsReturnMenu
        db 01h,00h,00h,00h
StatsReturnMenu:
        db 00h,00h,00h,00h,00h,00h,00h,00h
StatsReturnRight:
        db 053h,00h,00h,00h,012h,00h,00h,00h
StatsReturnText:
        dd str_SportsDesk2
        dd DeskSetExit1
        db 00h,00h,00h,00h,00h,00h,00h,00h
PrintMenu:
        db 00h,00h,00h,00h,00h,00h,00h,00h,09Ah,00h,00h,00h,012h,00h,00h,00h
        dd str_OutputCurrentData
        dd OutputCurrentData
        db 00h,00h,00h,00h,00h,00h,00h,00h
standingsmenubar:
        db 00h,00h,00h,00h,00h,00h,00h,00h,045h,00h,00h,00h,012h,00h,00h,00h
        dd str_ReturnTo2
        db 00h,00h,00h,00h
        dd StandingsReturnMenu
        db 01h,00h,00h,00h,046h,00h,00h,00h,00h,00h,00h,00h,078h,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_Roster3
        db 00h,00h,00h,00h
        dd StandingsRosterMenu
        db 01h,00h,00h,00h,079h,00h,00h,00h,00h,00h,00h,00h,0E0h,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_StatisticsType3
        db 00h,00h,00h,00h
        dd StatsSourceMenu
standingsmenubar_srccnt:
        db 04h,00h,00h,00h,0E1h,00h,00h,00h,00h,00h,00h,00h,06h,01h,00h,00h
        db 012h,00h,00h,00h
        dd str_Print
        db 00h,00h,00h,00h
        dd PrintMenu
        db 01h,00h,00h,00h
StandingsReturnMenu:
        db 00h,00h,00h,00h,00h,00h,00h,00h
StandingsReturnRight:
        db 054h,00h,00h,00h,012h,00h,00h,00h
StandingsReturnText:
        dd str_SportsDesk2
        dd DeskSetExit1
        db 00h,00h,00h,00h,00h,00h,00h,00h
RosterReturnMenu:
        db 00h,00h,00h,00h,00h,00h,00h,00h
RosterReturnStandingsRight:
        db 07Dh,00h,00h,00h,011h,00h,00h,00h
        dd str_OverallStandings
        dd DeskSetExit2
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
RosterReturnDeskRight:
        db 07Dh,00h,00h,00h,023h,00h,00h,00h
RosterReturnDeskText:
        dd str_SportsDesk2
        dd DeskSetExit1
        db 00h,00h,00h,00h,00h,00h,00h,00h
PlayerCardReturnMenu:
        db 00h,00h,00h,00h,00h,00h,00h,00h
PlayerCardReturnRosterRight:
        db 07Dh,00h,00h,00h,011h,00h,00h,00h
        dd str_TeamRoster
        dd DeskSetExit3
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
PlayerCardReturnStandingsRight:
        db 07Dh,00h,00h,00h,023h,00h,00h,00h
        dd str_OverallStandings
        dd DeskSetExit2
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h
PlayerCardReturnDeskRight:
        db 07Dh,00h,00h,00h,036h,00h,00h,00h
PlayerCardReturnDeskText:
        dd str_SportsDesk2
        dd DeskSetExit1
        db 00h,00h,00h,00h,00h,00h,00h,00h
StandingsRosterMenu:
        db 00h,00h,00h,00h,00h,00h,00h,00h,07Fh,00h,00h,00h,012h,00h,00h,00h
        dd str_ShowTeamRoster
StandingsRosterAction:
        dd DeskSetExit3b
        db 00h,00h,00h,00h,00h,00h,00h,00h
rostermenubar:
        db 00h,00h,00h,00h,00h,00h,00h,00h,045h,00h,00h,00h,012h,00h,00h,00h
        dd str_ReturnTo3
        db 00h,00h,00h,00h
        dd RosterReturnMenu
        db 02h,00h,00h,00h,046h,00h,00h,00h,00h,00h,00h,00h,0BBh,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_PlayerStatistics3
        db 00h,00h,00h,00h
        dd RosterPlayerMenu
        db 01h,00h,00h,00h,0BCh,00h,00h,00h,00h,00h,00h,00h,023h,01h,00h,00h
        db 012h,00h,00h,00h
        dd str_StatisticsType4
        db 00h,00h,00h,00h
        dd StatsSourceMenu
rostermenubar_srccnt:
        db 04h,00h,00h,00h,024h,01h,00h,00h,00h,00h,00h,00h,049h,01h,00h,00h
        db 012h,00h,00h,00h
        dd str_Print
        db 00h,00h,00h,00h
        dd PrintMenu
        db 01h,00h,00h,00h
RosterPlayerMenu:
        db 00h,00h,00h,00h,00h,00h,00h,00h,0FFh,00h,00h,00h,012h,00h,00h,00h
        dd str_ShowPlayerStatisticsAnd
        dd ShowPlayerStatsItem
        db 00h,00h,00h,00h,00h,00h,00h,00h
playercardmenubar:
        db 00h,00h,00h,00h,00h,00h,00h,00h,045h,00h,00h,00h,012h,00h,00h,00h
        dd str_ReturnTo4
        db 00h,00h,00h,00h
        dd PlayerCardReturnMenu
        db 03h,00h,00h,00h,046h,00h,00h,00h,00h,00h,00h,00h,06Bh,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_Print
        db 00h,00h,00h,00h
        dd PrintMenu
        db 01h,00h,00h,00h
teamstatsmenubar:
        db 00h,00h,00h,00h,00h,00h,00h,00h,045h,00h,00h,00h,012h,00h,00h,00h
        dd str_ReturnTo4
        db 00h,00h,00h,00h
        dd StatsReturnMenu
        db 01h,00h,00h,00h,046h,00h,00h,00h,00h,00h,00h,00h,0ADh,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_StatisticsType5
        db 00h,00h,00h,00h
        dd StatsSourceMenu
teamstatsmenubar_srccnt:
        db 04h,00h,00h,00h,0AEh,00h,00h,00h,00h,00h,00h,00h,021h,01h,00h,00h
        db 012h,00h,00h,00h
        dd str_TeamsSortedBy
        db 00h,00h,00h,00h
        dd TeamStatsSortMenu
        db 06h,00h,00h,00h,022h,01h,00h,00h,00h,00h,00h,00h,047h,01h,00h,00h
        db 012h,00h,00h,00h
        dd str_Print
        db 00h,00h,00h,00h
        dd PrintMenu
        db 01h,00h,00h,00h
skaterstatsmenubar:
        db 00h,00h,00h,00h,00h,00h,00h,00h,045h,00h,00h,00h,012h,00h,00h,00h
        dd str_ReturnTo4
        db 00h,00h,00h,00h
        dd StatsReturnMenu
        db 01h,00h,00h,00h,046h,00h,00h,00h,00h,00h,00h,00h,0ADh,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_StatisticsType6
        db 00h,00h,00h,00h
        dd StatsSourceMenu
skaterstatsmenubar_srccnt:
        db 04h,00h,00h,00h,0AEh,00h,00h,00h,00h,00h,00h,00h,02Bh,01h,00h,00h
        db 012h,00h,00h,00h
        dd str_PlayersSortedBy
        db 00h,00h,00h,00h
        dd SkaterStatsSortMenu
        db 08h,00h,00h,00h,02Ch,01h,00h,00h,00h,00h,00h,00h,051h,01h,00h,00h
        db 012h,00h,00h,00h
        dd str_Print
        db 00h,00h,00h,00h
        dd PrintMenu
        db 01h,00h,00h,00h
goaliestatsmenubar:
        db 00h,00h,00h,00h,00h,00h,00h,00h,045h,00h,00h,00h,012h,00h,00h,00h
        dd str_ReturnTo4
        db 00h,00h,00h,00h
        dd StatsReturnMenu
        db 01h,00h,00h,00h,046h,00h,00h,00h,00h,00h,00h,00h,0ADh,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_StatisticsType7
        db 00h,00h,00h,00h
        dd StatsSourceMenu
goaliestatsmenubar_srccnt:
        db 04h,00h,00h,00h,0AEh,00h,00h,00h,00h,00h,00h,00h,02Bh,01h,00h,00h
        db 012h,00h,00h,00h
        dd str_GoaliesSortedBy
        db 00h,00h,00h,00h
        dd GoalieStatsSortMenu
        db 03h,00h,00h,00h,02Ch,01h,00h,00h,00h,00h,00h,00h,051h,01h,00h,00h
        db 012h,00h,00h,00h
        dd str_Print
        db 00h,00h,00h,00h
        dd PrintMenu
        db 01h,00h,00h,00h
