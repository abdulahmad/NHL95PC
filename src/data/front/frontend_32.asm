; Calendar layout, the trade-screen buttons, and the messages when a merge or an export fails.
bits 32
%include "hockey.inc"
section s_C88E2 progbits alloc noexec write align=1
extern str_A5, unk_C1936, unk_C67B1, unk_C88C2, str_StatisticsType, str_ReturnTo
global teamstartlag, greyramp, dword_C891E, calcolx, calrowy, calendarshapes
global gridcellbuf, tradebtnx, tradebtny, masteronlymsg, mergeincompletemsg, updateerrmsg
global exporterrmsg, unequaltrademsg, tradestatsmenubar, str_TheDatabasesCanOnly, str_OnTheMasterCopy, str_TheMasterControllerFor, str_MustBeImportedFirst, masterctlmsg
global str_WarningMergeNotCompleted, str_LeagueCanNotBe, str_TheMergeIsComplete, str_ErrorWhileUpdating, str_PlayersDatabases, str_ErrorWhileMergingDatabases, mergeerrmsg, str_ImportingMasterDatabases
global importmastermsg, str_ErrorWhileExportingPlayer, str_PlayerNotExported, drivebtns, str_ThereMustBeAn, str_NumberOfPlayersSelected, str_OnBothTeams, str_TheTradingDeadlineHas
global str_NoMoreTradingIs
tradestatsmenubar:
db 00h,00h,00h,00h,00h,00h,00h,00h,045h,00h,00h,00h,012h,00h,00h,00h
dd str_ReturnTo
db 00h,00h,00h,00h
dd unk_C88C2
db 01h,00h,00h,00h,046h,00h,00h,00h,00h,00h,00h,00h,0AEh,00h,00h,00h
db 012h,00h,00h,00h
dd str_StatisticsType
db 00h,00h,00h,00h
dd unk_C67B1
dword_C891E:
db 04h,00h,00h,00h
teamstartlag:
db 00h,00h,02h,01h,00h,02h,00h,03h,01h,00h,00h,00h,00h,00h,00h,00h
db 00h,01h,03h,00h,00h,03h,00h,01h,03h,00h,00h,00h,00h,00h,03Fh,019h
db 019h,019h,019h,03Fh,032h,00h,00h,03Fh,03Fh,03Fh,00h,032h,00h,03Fh,034h,00h
db 018h,00h,00h,02Ah,00h,00h,03Bh,00h,00h,03Bh,03Bh,03Bh
calcolx:
db 052h,00h,00h,00h,0A1h,00h,00h,00h,0F1h,00h,00h,00h,040h,01h,00h,00h
db 090h,01h,00h,00h,0DFh,01h,00h,00h
db 02Eh,02h,00h,00h
calrowy:
db 044h,00h,00h,00h,085h,00h,00h,00h,0C7h,00h,00h,00h,09h,01h,00h,00h
db 04Bh,01h,00h,00h
db 08Ch,01h,00h,00h
calendarshapes:
db 00h,00h,00h,00h,00h,00h
gridcellbuf:
db 00h,00h,00h,00h
str_TheDatabasesCanOnly:
db 054h,068h,065h,020h,064h,061h,074h,061h,062h,061h,073h,065h,073h,020h,063h,061h
db 06Eh,020h,06Fh,06Eh,06Ch,079h,020h,062h,065h,020h,06Dh,065h,072h,067h,065h,064h
db 00h
str_OnTheMasterCopy:
db 06Fh,06Eh,020h,074h,068h,065h,020h,06Dh,061h,073h,074h,065h,072h,020h,063h,06Fh
db 070h,079h,020h,06Fh,066h,020h,074h,068h,065h,020h,06Ch,065h,061h,067h,075h,065h
db 00h
masteronlymsg:
dd str_TheDatabasesCanOnly
dd str_OnTheMasterCopy
db 00h,00h,00h,00h
str_TheMasterControllerFor:
db 054h,068h,065h,020h,06Dh,061h,073h,074h,065h,072h,020h,063h,06Fh,06Eh,074h,072h
db 06Fh,06Ch,06Ch,065h,072h,020h,066h,06Fh,072h,020h,074h,068h,065h,020h,06Ch,065h
db 061h,067h,075h,065h,00h
str_MustBeImportedFirst:
db 06Dh,075h,073h,074h,020h,062h,065h,020h,069h,06Dh,070h,06Fh,072h,074h,065h,064h
db 020h,066h,069h,072h,073h,074h,021h,00h
masterctlmsg:
dd str_TheMasterControllerFor
db 00h,00h,00h,00h
dd str_MustBeImportedFirst
str_WarningMergeNotCompleted:
db 057h,061h,072h,06Eh,069h,06Eh,067h,021h,020h,04Dh,065h,072h,067h,065h,020h,06Eh
db 06Fh,074h,020h,063h,06Fh,06Dh,070h,06Ch,065h,074h,065h,064h,021h,00h
str_LeagueCanNotBe:
db 04Ch,065h,061h,067h,075h,065h,020h,063h,061h,06Eh,020h,06Eh,06Fh,074h,020h,062h
db 065h,020h,075h,073h,065h,064h,020h,075h,06Eh,074h,069h,06Ch,00h
str_TheMergeIsComplete:
db 074h,068h,065h,020h,06Dh,065h,072h,067h,065h,020h,069h,073h,020h,063h,06Fh,06Dh
db 070h,06Ch,065h,074h,065h,021h,00h
mergeincompletemsg:
dd str_WarningMergeNotCompleted
dd str_LeagueCanNotBe
dd str_TheMergeIsComplete
str_ErrorWhileUpdating:
db 045h,072h,072h,06Fh,072h,020h,077h,068h,069h,06Ch,065h,020h,075h,070h,064h,061h
db 074h,069h,06Eh,067h,00h
str_PlayersDatabases:
db 070h,06Ch,061h,079h,065h,072h,073h,020h,064h,061h,074h,061h,062h,061h,073h,065h
db 073h,021h,00h
updateerrmsg:
dd str_ErrorWhileUpdating
dd str_PlayersDatabases
str_ErrorWhileMergingDatabases:
db 045h,072h,072h,06Fh,072h,020h,077h,068h,069h,06Ch,065h,020h,06Dh,065h,072h,067h
db 069h,06Eh,067h,020h,064h,061h,074h,061h,062h,061h,073h,065h,073h,021h,00h
mergeerrmsg:
dd str_ErrorWhileMergingDatabases
str_ImportingMasterDatabases:
db 049h,06Dh,070h,06Fh,072h,074h,069h,06Eh,067h,020h,04Dh,061h,073h,074h,065h,072h
db 020h,044h,061h,074h,061h,062h,061h,073h,065h,073h,02Eh,00h
importmastermsg:
dd str_ImportingMasterDatabases
str_ErrorWhileExportingPlayer:
db 045h,072h,072h,06Fh,072h,020h,077h,068h,069h,06Ch,065h,020h,065h,078h,070h,06Fh
db 072h,074h,069h,06Eh,067h,020h,070h,06Ch,061h,079h,065h,072h,021h,00h
str_PlayerNotExported:
db 050h,06Ch,061h,079h,065h,072h,020h,06Eh,06Fh,074h,020h,065h,078h,070h,06Fh,072h
db 074h,065h,064h,021h,00h
exporterrmsg:
dd str_ErrorWhileExportingPlayer
dd str_PlayerNotExported
db 00h
drivebtns:
db 08h,00h,00h,00h,018h,00h,00h,00h,020h,00h,00h,00h,0Ah,00h,00h,00h
db 00h,00h,00h,00h,05h,00h,00h,00h
dd str_A5
db 0F8h,0FFh,0FFh,0FFh,018h,00h,00h,00h,020h,00h,00h,00h,0Ah,00h,00h,00h
db 00h,00h,00h,00h,06h,00h,00h,00h
dd unk_C1936
greyramp:
db 00h,017h,02Ah,03Fh
tradebtnx:
db 0E6h,00h,00h,00h
tradebtny:
db 080h,00h,00h,00h,0E6h,00h,00h,00h,0F0h,00h,00h,00h,068h,01h,00h,00h
db 080h,00h,00h,00h,068h,01h,00h,00h,0F0h,00h,00h,00h
str_ThereMustBeAn:
db 054h,068h,065h,072h,065h,020h,06Dh,075h,073h,074h,020h,062h,065h,020h,061h,06Eh
db 020h,065h,071h,075h,061h,06Ch,00h
str_NumberOfPlayersSelected:
db 06Eh,075h,06Dh,062h,065h,072h,020h,06Fh,066h,020h,070h,06Ch,061h,079h,065h,072h
db 073h,020h,073h,065h,06Ch,065h,063h,074h,065h,064h,00h
str_OnBothTeams:
db 06Fh,06Eh,020h,062h,06Fh,074h,068h,020h,074h,065h,061h,06Dh,073h,021h,00h
unequaltrademsg:
dd str_ThereMustBeAn
dd str_NumberOfPlayersSelected
dd str_OnBothTeams
str_TheTradingDeadlineHas:
db 054h,068h,065h,020h,074h,072h,061h,064h,069h,06Eh,067h,020h,064h,065h,061h,064h
db 06Ch,069h,06Eh,065h,020h,068h,061h,073h,020h,070h,061h,073h,073h,065h,064h,021h
db 00h
str_NoMoreTradingIs:
db 04Eh,06Fh,020h,06Dh,06Fh,072h,065h,020h,074h,072h,061h,064h,069h,06Eh,067h,020h
db 069h,073h,020h,061h,06Ch,06Ch,06Fh,077h,065h,064h,021h,00h
