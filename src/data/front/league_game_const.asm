; Strings and constants of front/league_game (src/front/league_game), in link order.
bits 32
%include "hockey.inc"
section s_C1853 progbits alloc noexec write align=1
global str_02d, str_GSUMMARY, str_Pal18, str_Temp5, str_Easndesk2, str_GAME, str_SAV
str_02d:                                        ; string '.%02d'; used by MakeTeamDbFmt, PlayLeagueGame
        db 02Eh,025h,030h,032h,064h,00h
str_GSUMMARY:                                   ; string 'GSUMMARY'; used by PostGameToTeamDb
        db 047h,053h,055h,04Dh,04Dh,041h,052h,059h,00h
str_Pal18:                                      ; string 'Pal'; used by PlayLeagueGame
        db 050h,061h,06Ch,00h
str_Temp5:                                      ; string 'temp'; used by PlayLeagueGame
        db 074h,065h,06Dh,070h,00h
str_Easndesk2:                                  ; string 'easndesk'; used by PlayLeagueGame
        db 065h,061h,073h,06Eh,064h,065h,073h,06Bh,00h
str_GAME:                                       ; string 'GAME'; used by PlayLeagueGame
        db 047h,041h,04Dh,045h,00h
str_SAV:                                        ; string '.SAV'; used by PlayLeagueGame
        db 02Eh,053h,041h,056h,00h,00h,00h
