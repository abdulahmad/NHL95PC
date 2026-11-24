; Strings and constants of front/team_stats (src/front/team_stats), in link order.
bits 32
%include "hockey.inc"
section s_C0FA6 progbits alloc noexec write align=1
global str_Teams, str_Addsort, str_Pstatbar5, str_Pst24, str_StatsUnavailable, str_GP4, str_ANA2, str_MightyDucksOfAnaheim
global str_Dashes39, str_Dashes36
str_Teams:                                      ; string 'teams'; used by TeamStatsScreen
        db 074h,065h,061h,06Dh,073h,00h
str_Addsort:                                    ; string 'addsort'; used by TeamStatsScreen
        db 061h,064h,064h,073h,06Fh,072h,074h,00h
str_Pstatbar5:                                  ; string 'pstatbar'; used by TeamStatsScreen_keyPen
        db 070h,073h,074h,061h,074h,062h,061h,072h,00h
str_Pst24:                                      ; string 'pst2'; used by TeamStatsScreen_keyPen
        db 070h,073h,074h,032h,00h
str_StatsUnavailable:                           ; string 'Stats Unavailable'; used by TeamStatsScreen_keyPen
        db 053h,074h,061h,074h,073h,020h,055h,06Eh,061h,076h,061h,069h,06Ch,061h,062h,06Ch
        db 065h,00h
str_GP4:                                        ; string 'GP'; used by TeamStatsScreen_keyPen
        db 047h,050h,00h
str_ANA2:                                       ; string 'ANA'; used by TeamStatsScreen_keyPen
        db 041h,04Eh,041h,00h
str_MightyDucksOfAnaheim:                       ; string 'Mighty Ducks of Anaheim'; used by
                                                ; TeamStatsScreen_keyPen
        db 04Dh,069h,067h,068h,074h,079h,020h,044h,075h,063h,06Bh,073h,020h,06Fh,066h,020h
        db 041h,06Eh,061h,068h,065h,069h,06Dh,00h
str_Dashes39:                                   ; 39 dashes; used by TeamStatsScreen_keyPen
        db 02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh
        db 02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh
        db 02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,00h
str_Dashes36:                                   ; 36 dashes; used by TeamStatsScreen_keyPen
        db 02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh
        db 02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh
        db 02Dh,02Dh,02Dh,02Dh,00h
