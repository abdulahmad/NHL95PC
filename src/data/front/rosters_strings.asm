; The roster statistics menu: regular season, playoffs, and back to the line editor.
bits 32
%include "hockey.inc"
section s_D05F4 progbits alloc noexec write align=1
extern MenuRegSeasonStats, MenuPlayoffStats, MenuReturnToLineEditor, DbLinesFileMenu, DbLinesPlayerMenu, DbLinesStatsMenu, str_LineEditor5, str_Roster4
extern str_PlayerStatistics4
global dblinesmenubar, str_RegularSeasonStatistics, str_PlayOffStatistics, RosterStatsSeasonMenu, str_ReturnToLineEditor, RosterStatsReturnMenu, str_PlayerStatistics6, str_Display
dblinesmenubar:                                 ; menu bar of the database line editor (EditTeamLines); used
                                                ; by EditTeamLines
        db 00h,00h,00h,00h,00h,00h,00h,00h,04Dh,00h,00h,00h,012h,00h,00h,00h
        dd str_LineEditor5
        db 00h,00h,00h,00h
        dd DbLinesFileMenu
        db 02h,00h,00h,00h,04Eh,00h,00h,00h,00h,00h,00h,00h,080h,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_Roster4
        db 00h,00h,00h,00h
        dd DbLinesPlayerMenu
        db 02h,00h,00h,00h,081h,00h,00h,00h,00h,00h,00h,00h,0F7h,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_PlayerStatistics4
        db 00h,00h,00h,00h
        dd DbLinesStatsMenu
        db 01h,00h,00h,00h
str_RegularSeasonStatistics:                    ; "Regular Season Statistics ..." string literal
        db 052h,065h,067h,075h,06Ch,061h,072h,020h,053h,065h,061h,073h,06Fh,06Eh,020h,053h
        db 074h,061h,074h,069h,073h,074h,069h,063h,073h,020h,02Eh,02Eh,02Eh,00h
str_PlayOffStatistics:                          ; "Play-Off Statistics ..." string literal
        db 050h,06Ch,061h,079h,02Dh,04Fh,066h,066h,020h,053h,074h,061h,074h,069h,073h,074h
        db 069h,063h,073h,020h,02Eh,02Eh,02Eh,00h
RosterStatsSeasonMenu:                          ; Roster statistics pull-down: regular season or playoff
                                                ; statistics
        db 00h,00h,00h,00h,00h,00h,00h,00h,0BFh,00h,00h,00h,011h,00h,00h,00h
        dd str_RegularSeasonStatistics
        dd MenuRegSeasonStats
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
        db 0BFh,00h,00h,00h,024h,00h,00h,00h
        dd str_PlayOffStatistics
        dd MenuPlayoffStats
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h
str_ReturnToLineEditor:                         ; "Return To Line Editor" string literal
        db 052h,065h,074h,075h,072h,06Eh,020h,054h,06Fh,020h,04Ch,069h,06Eh,065h,020h,045h
        db 064h,069h,074h,06Fh,072h,00h
RosterStatsReturnMenu:                          ; Roster statistics pull-down: return to line editor
        db 00h,00h,00h,00h,00h,00h,00h,00h,08Fh,00h,00h,00h,012h,00h,00h,00h
        dd str_ReturnToLineEditor
        dd MenuReturnToLineEditor
        db 00h,00h,00h,00h,00h,00h,00h,00h
str_PlayerStatistics6:                          ; "Player Statistics" string literal
        db 050h,06Ch,061h,079h,065h,072h,020h,053h,074h,061h,074h,069h,073h,074h,069h,063h
        db 073h,00h
str_Display:                                    ; "Display ..." string literal
        db 044h,069h,073h,070h,06Ch,061h,079h,020h,02Eh,02Eh,02Eh,00h
