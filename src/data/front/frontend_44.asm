; Line-editor menu actions: use these lines, save them, scratch a player, or dress him.
bits 32
%include "hockey.inc"
section s_CF00B progbits alloc noexec write align=1
extern DeskSetExit1, DeskSetExit2, DeskSetExit3, DeskSetExit3b, ShowPlayerStatsItem, OutputCurrentData, GameStandingsMenu, MenuUseTheseLines
extern MenuLineEdCancel, MenuUseOriginalLines, MenuUseDefaultLines, MenuGameShowPlayerStats, MenuReturnToLineEditor, GameScratchPlayer, GameDressPlayer, MenuSaveDefaultLines
extern MenuSaveTheseLines, unk_C67B1, str_Action, str_Game7, str_InstantReplay, str_LineEditor, str_Statistics4, str_GameSummary
extern str_Standings2, unk_CDF64, unk_CDF76, unk_CDF8A, str_LineEditor2, str_Roster, str_PlayerStatistics, str_SaveTheseLines
extern str_UseTheseLines, str_UseOriginalLines, str_UseDefaultLines, str_SaveAsDefaultLines, str_DressPlayer, str_ScratchPlayer, str_ShowPlayerStatistics, str_LineEditor3
extern str_PlayerStatistics2, str_Cancel4, str_UseTheseLines2, str_UseOriginalLines2, str_UseDefaultLines2, str_SaveAsDefaultLines2, str_LineEditor4, str_StatisticsType2
extern str_ReturnTo, str_SportsDesk2, str_ReturnTo2, str_Roster3, str_StatisticsType3, str_TeamRoster, str_OverallStandings, str_ShowTeamRoster
extern str_ReturnTo3, str_PlayerStatistics3, str_StatisticsType4, str_ShowPlayerStatisticsAnd, str_ReturnTo4, str_StatisticsType5, str_TeamsSortedBy, str_StatisticsType6
extern str_PlayersSortedBy, str_StatisticsType7, str_GoaliesSortedBy, str_Print, str_OutputCurrentData, unk_CE96F, unk_CEA2F, unk_CEB2F
extern unk_CECAF, unk_CED6F, unk_CEF0F, unk_CEF2F, unk_CEF6F, unk_CEFEF
global dword_CF00B, dword_CF4CB, dword_CF517, dword_CF5AB, dword_CF5D7, dword_CF5F7, dword_CF617, dword_CF637
global dword_CF657, dword_CF677, dword_CF70B, dword_CF7CB, dword_CF84B, dword_CF8CB, menuact_uselines2, menuact_savedeflines2
global menuact_gamedress, menuact_gamescratch, menuact_uselines, menuact_savedeflines, menuact_savelines, off_CF51F, off_CF5DF, off_CF61F
global off_CF67F, off_CF6A3, unk_CF1AF, unk_CF20F, unk_CF28F, unk_CF2CF, unk_CF2EF, unk_CF32F
global unk_CF3CF, unk_CF42F, unk_CF48F, unk_CF4CF, unk_CF50F, unk_CF52F, unk_CF54F, unk_CF5CF
global unk_CF5EF, unk_CF62F, unk_CF68F, unk_CF6AF, unk_CF72F, unk_CF74F, unk_CF78F, unk_CF80F
global unk_CF88F
dword_CF00B:
db 02h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h,08Ch,00h,00h,00h
db 023h,00h,00h,00h
dd str_Standings2
dd GameStandingsMenu
db 00h,00h,00h,00h,01h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h
db 08Ch,00h,00h,00h,035h,00h,00h,00h
dd unk_CDF64
db 00h,00h,00h,00h
dd unk_CE96F
db 06h,00h,00h,00h,00h,00h,00h,00h,036h,00h,00h,00h,08Ch,00h,00h,00h
db 047h,00h,00h,00h
dd unk_CDF76
db 00h,00h,00h,00h
dd unk_CEA2F
db 08h,00h,00h,00h,00h,00h,00h,00h,048h,00h,00h,00h,08Ch,00h,00h,00h
db 05Ah,00h,00h,00h
dd unk_CDF8A
db 00h,00h,00h,00h
dd unk_CEB2F
db 03h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02Eh,00h,00h,00h
db 012h,00h,00h,00h
dd str_Action
db 00h,00h,00h,00h
dd unk_CECAF
db 04h,00h,00h,00h,02Fh,00h,00h,00h,00h,00h,00h,00h,05Ah,00h,00h,00h
db 012h,00h,00h,00h
dd str_Game7
db 00h,00h,00h,00h
dd unk_CED6F
db 04h,00h,00h,00h,05Bh,00h,00h,00h,00h,00h,00h,00h,0C5h,00h,00h,00h
db 012h,00h,00h,00h
dd str_InstantReplay
db 00h,00h,00h,00h
dd unk_CEF0F
db 01h,00h,00h,00h,0C6h,00h,00h,00h,00h,00h,00h,00h,013h,01h,00h,00h
db 012h,00h,00h,00h
dd str_LineEditor
db 00h,00h,00h,00h
dd unk_CEF2F
db 02h,00h,00h,00h,014h,01h,00h,00h,00h,00h,00h,00h,059h,01h,00h,00h
db 012h,00h,00h,00h
dd str_Statistics4
db 00h,00h,00h,00h
dd unk_CEFEF
db 05h,00h,00h,00h,05Ah,01h,00h,00h,00h,00h,00h,00h,0C7h,01h,00h,00h
db 012h,00h,00h,00h
dd str_GameSummary
db 00h,00h,00h,00h
dd unk_CEF6F
db 03h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,04Dh,00h,00h,00h
db 012h,00h,00h,00h
dd str_LineEditor2
db 00h,00h,00h,00h
dd unk_CF20F
db 04h,00h,00h,00h,04Eh,00h,00h,00h,00h,00h,00h,00h,080h,00h,00h,00h
db 012h,00h,00h,00h
dd str_Roster
db 00h,00h,00h,00h
dd unk_CF28F
db 02h,00h,00h,00h,081h,00h,00h,00h,00h,00h,00h,00h,0F7h,00h,00h,00h
db 012h,00h,00h,00h
dd str_PlayerStatistics
db 00h,00h,00h,00h
dd unk_CF2CF
db 01h,00h,00h,00h
unk_CF1AF:
db 00h,00h,00h,00h,00h,00h,00h,00h,04Dh,00h,00h,00h,012h,00h,00h,00h
dd str_LineEditor2
db 00h,00h,00h,00h
dd unk_CF20F
db 04h,00h,00h,00h,04Eh,00h,00h,00h,00h,00h,00h,00h,080h,00h,00h,00h
db 012h,00h,00h,00h
dd str_Roster
db 00h,00h,00h,00h
dd unk_CF28F
db 02h,00h,00h,00h,081h,00h,00h,00h,00h,00h,00h,00h,0F7h,00h,00h,00h
db 012h,00h,00h,00h
dd str_PlayerStatistics
db 00h,00h,00h,00h
dd unk_CF2CF
db 01h,00h,00h,00h
unk_CF20F:
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
unk_CF28F:
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
unk_CF2CF:
db 00h,00h,00h,00h,00h,00h,00h,00h,09Ch,00h,00h,00h,012h,00h,00h,00h
dd str_ShowPlayerStatistics
dd MenuGameShowPlayerStats
db 00h,00h,00h,00h,00h,00h,00h,00h
unk_CF2EF:
db 00h,00h,00h,00h,00h,00h,00h,00h,04Dh,00h,00h,00h,012h,00h,00h,00h
dd str_LineEditor3
db 00h,00h,00h,00h
dd unk_CF32F
db 05h,00h,00h,00h,04Eh,00h,00h,00h,00h,00h,00h,00h,0C4h,00h,00h,00h
db 012h,00h,00h,00h
dd str_PlayerStatistics2
db 00h,00h,00h,00h
dd unk_CF2CF
db 01h,00h,00h,00h
unk_CF32F:
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
unk_CF3CF:
db 00h,00h,00h,00h,00h,00h,00h,00h,04Dh,00h,00h,00h,012h,00h,00h,00h
dd str_LineEditor2
db 00h,00h,00h,00h
dd unk_CF42F
db 03h,00h,00h,00h,04Eh,00h,00h,00h,00h,00h,00h,00h,080h,00h,00h,00h
db 012h,00h,00h,00h
dd str_Roster
db 00h,00h,00h,00h
dd unk_CF28F
db 02h,00h,00h,00h,081h,00h,00h,00h,00h,00h,00h,00h,0F7h,00h,00h,00h
db 012h,00h,00h,00h
dd str_PlayerStatistics
db 00h,00h,00h,00h
dd unk_CF2CF
db 01h,00h,00h,00h
unk_CF42F:
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
unk_CF48F:
db 00h,00h,00h,00h,00h,00h,00h,00h,045h,00h,00h,00h,012h,00h,00h,00h
dd str_ReturnTo
db 00h,00h,00h,00h
dd unk_CF4CF
db 01h,00h,00h,00h,046h,00h,00h,00h,00h,00h,00h,00h,0AEh,00h,00h,00h
db 012h,00h,00h,00h
dd str_StatisticsType2
db 00h,00h,00h,00h
dd unk_C67B1
dword_CF4CB:
db 04h,00h,00h,00h
unk_CF4CF:
db 00h,00h,00h,00h,00h,00h,00h,00h,04Dh,00h,00h,00h,012h,00h,00h,00h
dd str_LineEditor4
dd MenuReturnToLineEditor
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 046h,00h,00h,00h,012h,00h,00h,00h
dd str_ReturnTo
db 00h,00h,00h,00h
dd unk_CF50F
db 01h,00h,00h,00h
unk_CF50F:
db 00h,00h,00h,00h,00h,00h,00h,00h
dword_CF517:
db 053h,00h,00h,00h,012h,00h,00h,00h
off_CF51F:
dd str_SportsDesk2
dd DeskSetExit1
db 00h,00h,00h,00h,00h,00h,00h,00h
unk_CF52F:
db 00h,00h,00h,00h,00h,00h,00h,00h,09Ah,00h,00h,00h,012h,00h,00h,00h
dd str_OutputCurrentData
dd OutputCurrentData
db 00h,00h,00h,00h,00h,00h,00h,00h
unk_CF54F:
db 00h,00h,00h,00h,00h,00h,00h,00h,045h,00h,00h,00h,012h,00h,00h,00h
dd str_ReturnTo2
db 00h,00h,00h,00h
dd unk_CF5CF
db 01h,00h,00h,00h,046h,00h,00h,00h,00h,00h,00h,00h,078h,00h,00h,00h
db 012h,00h,00h,00h
dd str_Roster3
db 00h,00h,00h,00h
dd unk_CF68F
db 01h,00h,00h,00h,079h,00h,00h,00h,00h,00h,00h,00h,0E0h,00h,00h,00h
db 012h,00h,00h,00h
dd str_StatisticsType3
db 00h,00h,00h,00h
dd unk_C67B1
dword_CF5AB:
db 04h,00h,00h,00h,0E1h,00h,00h,00h,00h,00h,00h,00h,06h,01h,00h,00h
db 012h,00h,00h,00h
dd str_Print
db 00h,00h,00h,00h
dd unk_CF52F
db 01h,00h,00h,00h
unk_CF5CF:
db 00h,00h,00h,00h,00h,00h,00h,00h
dword_CF5D7:
db 054h,00h,00h,00h,012h,00h,00h,00h
off_CF5DF:
dd str_SportsDesk2
dd DeskSetExit1
db 00h,00h,00h,00h,00h,00h,00h,00h
unk_CF5EF:
db 00h,00h,00h,00h,00h,00h,00h,00h
dword_CF5F7:
db 07Dh,00h,00h,00h,011h,00h,00h,00h
dd str_OverallStandings
dd DeskSetExit2
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
dword_CF617:
db 07Dh,00h,00h,00h,023h,00h,00h,00h
off_CF61F:
dd str_SportsDesk2
dd DeskSetExit1
db 00h,00h,00h,00h,00h,00h,00h,00h
unk_CF62F:
db 00h,00h,00h,00h,00h,00h,00h,00h
dword_CF637:
db 07Dh,00h,00h,00h,011h,00h,00h,00h
dd str_TeamRoster
dd DeskSetExit3
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
dword_CF657:
db 07Dh,00h,00h,00h,023h,00h,00h,00h
dd str_OverallStandings
dd DeskSetExit2
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h
dword_CF677:
db 07Dh,00h,00h,00h,036h,00h,00h,00h
off_CF67F:
dd str_SportsDesk2
dd DeskSetExit1
db 00h,00h,00h,00h,00h,00h,00h,00h
unk_CF68F:
db 00h,00h,00h,00h,00h,00h,00h,00h,07Fh,00h,00h,00h,012h,00h,00h,00h
dd str_ShowTeamRoster
off_CF6A3:
dd DeskSetExit3b
db 00h,00h,00h,00h,00h,00h,00h,00h
unk_CF6AF:
db 00h,00h,00h,00h,00h,00h,00h,00h,045h,00h,00h,00h,012h,00h,00h,00h
dd str_ReturnTo3
db 00h,00h,00h,00h
dd unk_CF5EF
db 02h,00h,00h,00h,046h,00h,00h,00h,00h,00h,00h,00h,0BBh,00h,00h,00h
db 012h,00h,00h,00h
dd str_PlayerStatistics3
db 00h,00h,00h,00h
dd unk_CF72F
db 01h,00h,00h,00h,0BCh,00h,00h,00h,00h,00h,00h,00h,023h,01h,00h,00h
db 012h,00h,00h,00h
dd str_StatisticsType4
db 00h,00h,00h,00h
dd unk_C67B1
dword_CF70B:
db 04h,00h,00h,00h,024h,01h,00h,00h,00h,00h,00h,00h,049h,01h,00h,00h
db 012h,00h,00h,00h
dd str_Print
db 00h,00h,00h,00h
dd unk_CF52F
db 01h,00h,00h,00h
unk_CF72F:
db 00h,00h,00h,00h,00h,00h,00h,00h,0FFh,00h,00h,00h,012h,00h,00h,00h
dd str_ShowPlayerStatisticsAnd
dd ShowPlayerStatsItem
db 00h,00h,00h,00h,00h,00h,00h,00h
unk_CF74F:
db 00h,00h,00h,00h,00h,00h,00h,00h,045h,00h,00h,00h,012h,00h,00h,00h
dd str_ReturnTo4
db 00h,00h,00h,00h
dd unk_CF62F
db 03h,00h,00h,00h,046h,00h,00h,00h,00h,00h,00h,00h,06Bh,00h,00h,00h
db 012h,00h,00h,00h
dd str_Print
db 00h,00h,00h,00h
dd unk_CF52F
db 01h,00h,00h,00h
unk_CF78F:
db 00h,00h,00h,00h,00h,00h,00h,00h,045h,00h,00h,00h,012h,00h,00h,00h
dd str_ReturnTo4
db 00h,00h,00h,00h
dd unk_CF50F
db 01h,00h,00h,00h,046h,00h,00h,00h,00h,00h,00h,00h,0ADh,00h,00h,00h
db 012h,00h,00h,00h
dd str_StatisticsType5
db 00h,00h,00h,00h
dd unk_C67B1
dword_CF7CB:
db 04h,00h,00h,00h,0AEh,00h,00h,00h,00h,00h,00h,00h,021h,01h,00h,00h
db 012h,00h,00h,00h
dd str_TeamsSortedBy
db 00h,00h,00h,00h
dd unk_CE96F
db 06h,00h,00h,00h,022h,01h,00h,00h,00h,00h,00h,00h,047h,01h,00h,00h
db 012h,00h,00h,00h
dd str_Print
db 00h,00h,00h,00h
dd unk_CF52F
db 01h,00h,00h,00h
unk_CF80F:
db 00h,00h,00h,00h,00h,00h,00h,00h,045h,00h,00h,00h,012h,00h,00h,00h
dd str_ReturnTo4
db 00h,00h,00h,00h
dd unk_CF50F
db 01h,00h,00h,00h,046h,00h,00h,00h,00h,00h,00h,00h,0ADh,00h,00h,00h
db 012h,00h,00h,00h
dd str_StatisticsType6
db 00h,00h,00h,00h
dd unk_C67B1
dword_CF84B:
db 04h,00h,00h,00h,0AEh,00h,00h,00h,00h,00h,00h,00h,02Bh,01h,00h,00h
db 012h,00h,00h,00h
dd str_PlayersSortedBy
db 00h,00h,00h,00h
dd unk_CEA2F
db 08h,00h,00h,00h,02Ch,01h,00h,00h,00h,00h,00h,00h,051h,01h,00h,00h
db 012h,00h,00h,00h
dd str_Print
db 00h,00h,00h,00h
dd unk_CF52F
db 01h,00h,00h,00h
unk_CF88F:
db 00h,00h,00h,00h,00h,00h,00h,00h,045h,00h,00h,00h,012h,00h,00h,00h
dd str_ReturnTo4
db 00h,00h,00h,00h
dd unk_CF50F
db 01h,00h,00h,00h,046h,00h,00h,00h,00h,00h,00h,00h,0ADh,00h,00h,00h
db 012h,00h,00h,00h
dd str_StatisticsType7
db 00h,00h,00h,00h
dd unk_C67B1
dword_CF8CB:
db 04h,00h,00h,00h,0AEh,00h,00h,00h,00h,00h,00h,00h,02Bh,01h,00h,00h
db 012h,00h,00h,00h
dd str_GoaliesSortedBy
db 00h,00h,00h,00h
dd unk_CEB2F
db 03h,00h,00h,00h,02Ch,01h,00h,00h,00h,00h,00h,00h,051h,01h,00h,00h
db 012h,00h,00h,00h
dd str_Print
db 00h,00h,00h,00h
dd unk_CF52F
db 01h,00h,00h,00h
