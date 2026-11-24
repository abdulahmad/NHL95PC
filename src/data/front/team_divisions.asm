; Which division and conference each team is in.
bits 32
%include "hockey.inc"
section s_C5519 progbits alloc noexec write align=1
global teamdivflags, teamconf, confteams, poconf2teams, str_InsufficientDiskSpace3
teamdivflags:                                   ; per team: >>1 gives the divisionteams row (4 counted as 3);
                                                ; SetSeriesTeams uses 2-3-2 when two teams' flags OR to 3;
                                                ; used by DrawLockerRoom, GetPlayoffSeeds, LoadCupFinalSeries
                                                ; ...
        db 04h,00h,00h,00h,04h,00h,00h,00h,01h,00h,00h,00h,02h,00h,00h,00h
        db 02h,00h,00h,00h,01h,00h,00h,00h,04h,00h,00h,00h,01h,00h,00h,00h
        db 02h,00h,00h,00h,04h,00h,00h,00h,08h,00h,00h,00h,08h,00h,00h,00h
        db 08h,00h,00h,00h,04h,00h,00h,00h,08h,00h,00h,00h,04h,00h,00h,00h
        db 04h,00h,00h,00h,02h,00h,00h,00h,01h,00h,00h,00h,08h,00h,00h,00h
        db 02h,00h,00h,00h,01h,00h,00h,00h,08h,00h,00h,00h,02h,00h,00h,00h
        db 01h,00h,00h,00h,08h,00h,00h,00h
teamconf:                                       ; conference flags per team (3 = west divisions 1|2, 0Ch =
                                                ; east divisions 4|8); POSeedTeams / POInitSchedule; used by
                                                ; DrawPlayoffTree, POCreateSchedule, POInitSchedule ...
        db 0Ch,00h,00h,00h,0Ch,00h,00h,00h,03h,00h,00h,00h,03h,00h,00h,00h
        db 03h,00h,00h,00h,03h,00h,00h,00h,0Ch,00h,00h,00h,03h,00h,00h,00h
        db 03h,00h,00h,00h,0Ch,00h,00h,00h,0Ch,00h,00h,00h,0Ch,00h,00h,00h
        db 0Ch,00h,00h,00h,0Ch,00h,00h,00h,0Ch,00h,00h,00h,0Ch,00h,00h,00h
        db 0Ch,00h,00h,00h,03h,00h,00h,00h,03h,00h,00h,00h,0Ch,00h,00h,00h
        db 03h,00h,00h,00h,03h,00h,00h,00h,0Ch,00h,00h,00h,03h,00h,00h,00h
        db 03h,00h,00h,00h,0Ch,00h,00h,00h
confteams:                                      ; the 26 teams ordered by conference (12 west then 14 east);
                                                ; POPickConfTeams picks from it; used by GetPlayoffSeeds,
                                                ; POPickConfTeams
        db 018h,00h,00h,00h,02h,00h,00h,00h,05h,00h,00h,00h,07h,00h,00h,00h
        db 012h,00h,00h,00h,015h,00h,00h,00h,03h,00h,00h,00h,08h,00h,00h,00h
        db 04h,00h,00h,00h,011h,00h,00h,00h,014h,00h,00h,00h,017h,00h,00h,00h
poconf2teams:                                   ; GetPlayoffSeeds: team numbers of the second conference; used
                                                ; by GetPlayoffSeeds
        db 00h,00h,00h,00h,01h,00h,00h,00h,06h,00h,00h,00h,09h,00h,00h,00h
        db 0Dh,00h,00h,00h,0Fh,00h,00h,00h,010h,00h,00h,00h,019h,00h,00h,00h
        db 0Ah,00h,00h,00h,0Bh,00h,00h,00h,0Ch,00h,00h,00h,0Eh,00h,00h,00h
        db 013h,00h,00h,00h,016h,00h,00h,00h,00h,00h,00h
str_InsufficientDiskSpace3:                     ; "Insufficient disk space available to" string literal
        db 049h,06Eh,073h,075h,066h,066h,069h,063h,069h,065h,06Eh,074h,020h,064h,069h,073h
        db 06Bh,020h,073h,070h,061h,063h,065h,020h,061h,076h,061h,069h,06Ch,061h,062h,06Ch
        db 065h,020h,074h,06Fh,00h
