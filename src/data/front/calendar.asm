; Calendar layout, the trade-screen buttons, and the messages when a merge or an export fails.
bits 32
%include "hockey.inc"
section s_C88E2 progbits alloc noexec write align=1
extern str_A5, str_DriveB, StatsSourceMenu, TradeStatsReturnMenu, str_StatisticsType, str_ReturnTo
global teamstartlag, greyramp, tradestatsmenubar_srccnt, calcolx, calrowy, calendarshapes
global gridcellbuf, tradebtnx, tradebtny, masteronlymsg, mergeincompletemsg, updateerrmsg
global exporterrmsg, unequaltrademsg, tradestatsmenubar, str_TheDatabasesCanOnly, str_OnTheMasterCopy, str_TheMasterControllerFor, str_MustBeImportedFirst, masterctlmsg
global str_WarningMergeNotCompleted, str_LeagueCanNotBe, str_TheMergeIsComplete, str_ErrorWhileUpdating, str_PlayersDatabases, str_ErrorWhileMergingDatabases, mergeerrmsg, str_ImportingMasterDatabases
global importmastermsg, str_ErrorWhileExportingPlayer, str_PlayerNotExported, drivebtns, str_ThereMustBeAn, str_NumberOfPlayersSelected, str_OnBothTeams, str_TheTradingDeadlineHas
global str_NoMoreTradingIs
tradestatsmenubar:                              ; menu bar ('Return To') of TradeShowStats and
                                                ; FixJerseyConflict; used by TradeShowStats
        db 00h,00h,00h,00h,00h,00h,00h,00h,045h,00h,00h,00h,012h,00h,00h,00h
        dd str_ReturnTo
        db 00h,00h,00h,00h
        dd TradeStatsReturnMenu
        db 01h,00h,00h,00h,046h,00h,00h,00h,00h,00h,00h,00h,0AEh,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_StatisticsType
        db 00h,00h,00h,00h
        dd StatsSourceMenu
tradestatsmenubar_srccnt:                       ; Item count of the statistics source pull-down under the
                                                ; trade statistics menu bar; used by SetupStatsSourceMenu_all
        db 04h,00h,00h,00h
teamstartlag:                                   ; per-team start-time lag in periods (0-3) used to stagger the
                                                ; other-games scoreboard; used by PickOtherGames,
                                                ; UpdateOtherScores
        db 00h,00h,02h,01h,00h,02h,00h,03h,01h,00h,00h,00h,00h,00h,00h,00h
        db 00h,01h,03h,00h,00h,03h,00h,01h,03h,00h,00h,00h,00h,00h,03Fh,019h
        db 019h,019h,019h,03Fh,032h,00h,00h,03Fh,03Fh,03Fh,00h,032h,00h,03Fh,034h,00h
        db 018h,00h,00h,02Ah,00h,00h,03Bh,00h,00h,03Bh,03Bh,03Bh
calcolx:                                        ; 7 day-column x positions; used by CalendarScreen,
                                                ; DrawCalendarDay
        db 052h,00h,00h,00h,0A1h,00h,00h,00h,0F1h,00h,00h,00h,040h,01h,00h,00h
        db 090h,01h,00h,00h,0DFh,01h,00h,00h
        db 02Eh,02h,00h,00h
calrowy:                                        ; 6 week-row y positions; used by CalendarScreen,
                                                ; DrawCalendarDay
        db 044h,00h,00h,00h,085h,00h,00h,00h,0C7h,00h,00h,00h,09h,01h,00h,00h
        db 04Bh,01h,00h,00h
        db 08Ch,01h,00h,00h
calendarshapes:                                 ; "calendar" shape file handle; used by CalendarScreen,
                                                ; FreeCalendarIfLowMem, LoadCalendarShapes
        db 00h,00h,00h,00h,00h,00h
gridcellbuf:                                    ; "back" save of a grid cell; used by RestoreGridCellBg,
                                                ; SaveGridCellBg
        db 00h,00h,00h,00h
str_TheDatabasesCanOnly:                        ; "The databases can only be merged" string literal
        db 054h,068h,065h,020h,064h,061h,074h,061h,062h,061h,073h,065h,073h,020h,063h,061h
        db 06Eh,020h,06Fh,06Eh,06Ch,079h,020h,062h,065h,020h,06Dh,065h,072h,067h,065h,064h
        db 00h
str_OnTheMasterCopy:                            ; "on the master copy of the league" string literal
        db 06Fh,06Eh,020h,074h,068h,065h,020h,06Dh,061h,073h,074h,065h,072h,020h,063h,06Fh
        db 070h,079h,020h,06Fh,066h,020h,074h,068h,065h,020h,06Ch,065h,061h,067h,075h,065h
        db 00h
masteronlymsg:                                  ; "The databases can only be merged on the master copy of the
                                                ; league"; used by MergeLeagueFiles
        dd str_TheDatabasesCanOnly
        dd str_OnTheMasterCopy
        db 00h,00h,00h,00h
str_TheMasterControllerFor:                     ; "The master controller for the league" string literal
        db 054h,068h,065h,020h,06Dh,061h,073h,074h,065h,072h,020h,063h,06Fh,06Eh,074h,072h
        db 06Fh,06Ch,06Ch,065h,072h,020h,066h,06Fh,072h,020h,074h,068h,065h,020h,06Ch,065h
        db 061h,067h,075h,065h,00h
str_MustBeImportedFirst:                        ; "must be imported first!" string literal
        db 06Dh,075h,073h,074h,020h,062h,065h,020h,069h,06Dh,070h,06Fh,072h,074h,065h,064h
        db 020h,066h,069h,072h,073h,074h,021h,00h
masterctlmsg:                                   ; "The master controller for the league" <name>; used by
                                                ; MergeLeagueFiles
        dd str_TheMasterControllerFor
        db 00h,00h,00h,00h
        dd str_MustBeImportedFirst
str_WarningMergeNotCompleted:                   ; "Warning! Merge not completed!" string literal
        db 057h,061h,072h,06Eh,069h,06Eh,067h,021h,020h,04Dh,065h,072h,067h,065h,020h,06Eh
        db 06Fh,074h,020h,063h,06Fh,06Dh,070h,06Ch,065h,074h,065h,064h,021h,00h
str_LeagueCanNotBe:                             ; "League can not be used until" string literal
        db 04Ch,065h,061h,067h,075h,065h,020h,063h,061h,06Eh,020h,06Eh,06Fh,074h,020h,062h
        db 065h,020h,075h,073h,065h,064h,020h,075h,06Eh,074h,069h,06Ch,00h
str_TheMergeIsComplete:                         ; "the merge is complete!" string literal
        db 074h,068h,065h,020h,06Dh,065h,072h,067h,065h,020h,069h,073h,020h,063h,06Fh,06Dh
        db 070h,06Ch,065h,074h,065h,021h,00h
mergeincompletemsg:                             ; "Warning! Merge not completed! ..."; used by
                                                ; MergeLeagueFiles
        dd str_WarningMergeNotCompleted
        dd str_LeagueCanNotBe
        dd str_TheMergeIsComplete
str_ErrorWhileUpdating:                         ; "Error while updating" string literal
        db 045h,072h,072h,06Fh,072h,020h,077h,068h,069h,06Ch,065h,020h,075h,070h,064h,061h
        db 074h,069h,06Eh,067h,00h
str_PlayersDatabases:                           ; "players databases!" string literal
        db 070h,06Ch,061h,079h,065h,072h,073h,020h,064h,061h,074h,061h,062h,061h,073h,065h
        db 073h,021h,00h
updateerrmsg:                                   ; "Error while updating players databases!"; used by
                                                ; ImportMasterLeague, RebuildLeagueDbs, UpdateTeamDbs
        dd str_ErrorWhileUpdating
        dd str_PlayersDatabases
str_ErrorWhileMergingDatabases:                 ; "Error while merging databases!" string literal
        db 045h,072h,072h,06Fh,072h,020h,077h,068h,069h,06Ch,065h,020h,06Dh,065h,072h,067h
        db 069h,06Eh,067h,020h,064h,061h,074h,061h,062h,061h,073h,065h,073h,021h,00h
mergeerrmsg:                                    ; "Error while merging databases!"; used by MergeLeagueFiles
        dd str_ErrorWhileMergingDatabases
str_ImportingMasterDatabases:                   ; "Importing Master Databases." string literal
        db 049h,06Dh,070h,06Fh,072h,074h,069h,06Eh,067h,020h,04Dh,061h,073h,074h,065h,072h
        db 020h,044h,061h,074h,061h,062h,061h,073h,065h,073h,02Eh,00h
importmastermsg:                                ; "Importing Master Databases."; used by ImportMasterLeague
        dd str_ImportingMasterDatabases
str_ErrorWhileExportingPlayer:                  ; "Error while exporting player!" string literal
        db 045h,072h,072h,06Fh,072h,020h,077h,068h,069h,06Ch,065h,020h,065h,078h,070h,06Fh
        db 072h,074h,069h,06Eh,067h,020h,070h,06Ch,061h,079h,065h,072h,021h,00h
str_PlayerNotExported:                          ; "Player not exported!" string literal
        db 050h,06Ch,061h,079h,065h,072h,020h,06Eh,06Fh,074h,020h,065h,078h,070h,06Fh,072h
        db 074h,065h,064h,021h,00h
exporterrmsg:                                   ; "Error while exporting player! Player not exported!"; used
                                                ; by ExportTeamToFloppy
        dd str_ErrorWhileExportingPlayer
        dd str_PlayerNotExported
        db 00h
drivebtns:                                      ; A / B; used by SelectFloppyDrive
        db 08h,00h,00h,00h,018h,00h,00h,00h,020h,00h,00h,00h,0Ah,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_A5
        db 0F8h,0FFh,0FFh,0FFh,018h,00h,00h,00h,020h,00h,00h,00h,0Ah,00h,00h,00h
        db 00h,00h,00h,00h,06h,00h,00h,00h
        dd str_DriveB
greyramp:                                       ; 4 VGA grey levels (0,17h,2Ah,3Fh) for palette entries 0-3;
                                                ; used by LoadNhlCfg
        db 00h,017h,02Ah,03Fh
tradebtnx:                                      ; [4] x of the trade screen buttons (8-byte x,y pairs); used
                                                ; by DrawTradeScreen, TradeHitTest, TradeScreenLoop
        db 0E6h,00h,00h,00h
tradebtny:                                      ; [4] y of the trade screen buttons; used by DrawTradeScreen,
                                                ; TradeHitTest, TradeScreenLoop
        db 080h,00h,00h,00h,0E6h,00h,00h,00h,0F0h,00h,00h,00h,068h,01h,00h,00h
        db 080h,00h,00h,00h,068h,01h,00h,00h,0F0h,00h,00h,00h
str_ThereMustBeAn:                              ; "There must be an equal" string literal
        db 054h,068h,065h,072h,065h,020h,06Dh,075h,073h,074h,020h,062h,065h,020h,061h,06Eh
        db 020h,065h,071h,075h,061h,06Ch,00h
str_NumberOfPlayersSelected:                    ; "number of players selected" string literal
        db 06Eh,075h,06Dh,062h,065h,072h,020h,06Fh,066h,020h,070h,06Ch,061h,079h,065h,072h
        db 073h,020h,073h,065h,06Ch,065h,063h,074h,065h,064h,00h
str_OnBothTeams:                                ; "on both teams!" string literal
        db 06Fh,06Eh,020h,062h,06Fh,074h,068h,020h,074h,065h,061h,06Dh,073h,021h,00h
unequaltrademsg:                                ; "There must be an equal number of players selected on both
                                                ; teams!"; used by TradeDone
        dd str_ThereMustBeAn
        dd str_NumberOfPlayersSelected
        dd str_OnBothTeams
str_TheTradingDeadlineHas:                      ; "The trading deadline has passed!" string literal
        db 054h,068h,065h,020h,074h,072h,061h,064h,069h,06Eh,067h,020h,064h,065h,061h,064h
        db 06Ch,069h,06Eh,065h,020h,068h,061h,073h,020h,070h,061h,073h,073h,065h,064h,021h
        db 00h
str_NoMoreTradingIs:                            ; "No more trading is allowed!" string literal
        db 04Eh,06Fh,020h,06Dh,06Fh,072h,065h,020h,074h,072h,061h,064h,069h,06Eh,067h,020h
        db 069h,073h,020h,061h,06Ch,06Ch,06Fh,077h,065h,064h,021h,00h
