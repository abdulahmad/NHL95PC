; Short strings for the schedule and playoff screens, and the home-team palette file.
bits 32
%include "hockey.inc"
section s_C1A26 progbits alloc noexec write align=1
global str_Show, str_Statistics, str_HOMEPALS, str_easndesk, str_bangpal, str_LLST, str_LLSN, str_extnum
global str_saved, str_sche, str_Sch, str_gameset, str_KbytesFree
str_Show:                                       ; string 'Show '; used by TradePlayers
        db 053h,068h,06Fh,077h,020h,00h
str_Statistics:                                 ; string ' Statistics...'; used by TradePlayers
        db 020h,053h,074h,061h,074h,069h,073h,074h,069h,063h,073h,02Eh,02Eh,02Eh,00h,00h
str_HOMEPALS:                                   ; string 'HOMEPALS'; used by LoadHomePals
        db 048h,04Fh,04Dh,045h,050h,041h,04Ch,053h,00h,00h,00h,00h
str_easndesk:                                   ; string 'easndesk'; used by AddHumanTeam, RemoveHumanTeam
        db 065h,061h,073h,06Eh,064h,065h,073h,06Bh,00h
str_bangpal:                                    ; string '!pal'; used by AddHumanTeam, RemoveHumanTeam
        db 021h,070h,061h,06Ch,00h,00h,00h
str_LLST:                                       ; string 'LLST'; used by BuildLeagueList
        db 04Ch,04Ch,053h,054h,00h
str_LLSN:                                       ; string 'LLSN'; used by BuildLeagueList
        db 04Ch,04Ch,053h,04Eh,00h
str_extnum:                                     ; string '.%02d'; used by CopyHumanTeamDBs
        db 02Eh,025h,030h,032h,064h,00h
str_saved:                                      ; string 'saved'; used by SaveLeagueGameRef
        db 073h,061h,076h,065h,064h,00h,00h,00h
str_sche:                                       ; string 'sche'; used by BuildPlayoffs
        db 073h,063h,068h,065h,00h
str_Sch:                                        ; string 'Sch'; used by AdvancePlayoffs
        db 053h,063h,068h,00h,00h,00h,00h
str_gameset:                                    ; string 'game.set'; used by CreateNewLeague
        db 067h,061h,06Dh,065h,02Eh,073h,065h,074h,00h
str_KbytesFree:                                 ; string '%4d Kbytes of free disk space.'; used by
                                                ; CreateNewLeague
        db 025h,034h,064h,020h,04Bh,062h,079h,074h,065h,073h,020h,06Fh,066h,020h,066h,072h
        db 065h,065h,020h,064h,069h,073h,06Bh,020h,073h,070h,061h,063h,065h,02Eh,00h
