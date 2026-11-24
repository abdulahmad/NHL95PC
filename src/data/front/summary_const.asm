; Strings and constants of front/summary (src/front/summary), in link order.
bits 32
%include "hockey.inc"
section s_C1574 progbits alloc noexec write align=1
global str_Indus0302, str_Ctlogo2, str_Ctbkgd2, str_Bkgd5, str_Pal13, str_Cttitle2, str_Summ2, str_OtShape
global str_Per1, str_Per2, str_Per3, str_Top2, str_Cttitle12, str_Def2, str_Fowa2, str_Scra2
global str_Tlu2, str_Cttitle3, str_Ots, str_Colm, str_Gsummary2, str_Iff6, str_Gamesum, str_Mtsum
global str_Adsum, str_D6, str_1st2, str_2nd2, str_3rd2, str_OT, str_FinalOT, str_Final
global str_Period, str_Injured2, str_EVNT, str_PRDS, str_S3, str_D5, str_St, str_Nd
global str_Rd, str_Th, str_SH, str_PP, str_02d02d, str_S2, str_CommaSp, str_RParen2
global str_SS4, str_DMinS, str_ShotsOnGoal, str_SDD, str_Ctbkgd3, str_Pal14, str_Bkgd6, str_Cttitle32
global str_Colm2, str_Gsta, str_Ctlogo3, str_D7, str_DD, str_D02d2, str_DDD, str_Iff7
global str_Leaguetm, str_Mtsum2, str_Adsum2
str_Indus0302:                                  ; string 'indus030'; used by GameSummaryScreen
        db 069h,06Eh,064h,075h,073h,030h,033h,030h,00h
str_Ctlogo2:                                    ; string 'ctlogo'; used by GameSummaryScreen
        db 063h,074h,06Ch,06Fh,067h,06Fh,00h
str_Ctbkgd2:                                    ; string 'ctbkgd'; used by GameSummaryScreen
        db 063h,074h,062h,06Bh,067h,064h,00h
str_Bkgd5:                                      ; string 'bkgd'; used by GameSummaryScreen
        db 062h,06Bh,067h,064h,00h
str_Pal13:                                      ; string '!pal'; used by GameSummaryScreen
        db 021h,070h,061h,06Ch,00h
str_Cttitle2:                                   ; string 'cttitle2'; used by GameSummaryScreen
        db 063h,074h,074h,069h,074h,06Ch,065h,032h,00h
str_Summ2:                                      ; string 'summ'; used by GameSummaryScreen
        db 073h,075h,06Dh,06Dh,00h
str_OtShape:                                    ; string 'ot '; used by GameSummaryScreen
        db 06Fh,074h,020h,020h,00h
str_Per1:                                       ; string 'per1'; used by GameSummaryScreen
        db 070h,065h,072h,031h,00h
str_Per2:                                       ; string 'per2'; used by GameSummaryScreen
        db 070h,065h,072h,032h,00h
str_Per3:                                       ; string 'per3'; used by GameSummaryScreen
        db 070h,065h,072h,033h,00h
str_Top2:                                       ; string 'top '; used by GameSummaryScreen
        db 074h,06Fh,070h,020h,00h
str_Cttitle12:                                  ; string 'cttitle1'; used by GameSummaryScreen
        db 063h,074h,074h,069h,074h,06Ch,065h,031h,00h
str_Def2:                                       ; string 'def '; used by GameSummaryScreen
        db 064h,065h,066h,020h,00h
str_Fowa2:                                      ; string 'fowa'; used by GameSummaryScreen
        db 066h,06Fh,077h,061h,00h
str_Scra2:                                      ; string 'scra'; used by GameSummaryScreen
        db 073h,063h,072h,061h,00h
str_Tlu2:                                       ; string 'tlu '; used by GameSummaryScreen
        db 074h,06Ch,075h,020h,00h
str_Cttitle3:                                   ; string 'cttitle3'; used by GameSummaryScreen
        db 063h,074h,074h,069h,074h,06Ch,065h,033h,00h
str_Ots:                                        ; string 'ots '; used by GameSummaryScreen
        db 06Fh,074h,073h,020h,00h
str_Colm:                                       ; string 'colm'; used by GameSummaryScreen
        db 063h,06Fh,06Ch,06Dh,00h
str_Gsummary2:                                  ; string 'gsummary'; used by GameSummaryScreen
        db 067h,073h,075h,06Dh,06Dh,061h,072h,079h,00h
str_Iff6:                                       ; string '.iff'; used by GameSummaryScreen
        db 02Eh,069h,066h,066h,00h
str_Gamesum:                                    ; string 'gamesum'; used by GameSummaryScreen
        db 067h,061h,06Dh,065h,073h,075h,06Dh,00h
str_Mtsum:                                      ; string 'mtsum'; used by GameSummaryScreen
        db 06Dh,074h,073h,075h,06Dh,00h
str_Adsum:                                      ; string 'adsum'; used by GameSummaryScreen
        db 061h,064h,073h,075h,06Dh,00h
str_D6:                                         ; string '%d'; used by GameSummaryScreen
        db 025h,064h,00h
str_1st2:                                       ; string '1st'; used by GameSummaryScreen_p1
        db 031h,073h,074h,00h
str_2nd2:                                       ; string '2nd'; used by GameSummaryScreen_p2
        db 032h,06Eh,064h,00h
str_3rd2:                                       ; string '3rd'; used by GameSummaryScreen_p3
        db 033h,072h,064h,00h
str_OT:                                         ; string 'OT'; used by GameSummaryScreen_ot
        db 04Fh,054h,00h
str_FinalOT:                                    ; string 'Final (OT)'; used by GameSummaryScreen_finalot
        db 046h,069h,06Eh,061h,06Ch,020h,028h,04Fh,054h,029h,00h
str_Final:                                      ; string 'Final'; used by GameSummaryScreen_final
        db 046h,069h,06Eh,061h,06Ch,00h
str_Period:                                     ; string ' period'; used by GameSummaryScreen_period
        db 020h,070h,065h,072h,069h,06Fh,064h,00h
str_Injured2:                                   ; string 'Injured'; used by GameSummaryScreen_period
        db 049h,06Eh,06Ah,075h,072h,065h,064h,00h
str_EVNT:                                       ; string 'EVNT'; used by GameSummaryScreen_period
        db 045h,056h,04Eh,054h,00h
str_PRDS:                                       ; string 'PRDS'; used by GameSummaryScreen_period
        db 050h,052h,044h,053h,00h
str_S3:                                         ; string '%s'; used by GameSummaryScreen_period
        db 025h,073h,00h
str_D5:                                         ; string ' (%d'; used by GameSummaryScreen_period
        db 020h,028h,025h,064h,00h
str_St:                                         ; string 'st)'; used by GameSummaryScreen_period
        db 073h,074h,029h,00h
str_Nd:                                         ; string 'nd)'; used by GameSummaryScreen_period
        db 06Eh,064h,029h,00h
str_Rd:                                         ; string 'rd)'; used by GameSummaryScreen_period
        db 072h,064h,029h,00h
str_Th:                                         ; string 'th)'; used by GameSummaryScreen_period
        db 074h,068h,029h,00h
str_SH:                                         ; string ' SH'; used by GameSummaryScreen_period
        db 020h,053h,048h,00h
str_PP:                                         ; string ' PP'; used by GameSummaryScreen_period
        db 020h,050h,050h,00h
str_02d02d:                                     ; string '%02d:%02d'; used by GameSummaryScreen_period
        db 025h,030h,032h,064h,03Ah,025h,030h,032h,064h,00h
str_S2:                                         ; string '(%s'; used by GameSummaryScreen_period
        db 028h,025h,073h,00h
str_CommaSp:                                    ; string ', '; used by GameSummaryScreen_period
        db 02Ch,020h,00h
str_RParen2:                                    ; string ')'; used by GameSummaryScreen_period
        db 029h,00h
str_SS4:                                        ; string '%s %s'; used by GameSummaryScreen_period
        db 025h,073h,020h,020h,020h,020h,025h,073h,00h
str_DMinS:                                      ; string '%d min : %s'; used by GameSummaryScreen_period
        db 025h,064h,020h,06Dh,069h,06Eh,020h,03Ah,020h,025h,073h,00h
str_ShotsOnGoal:                                ; string 'Shots on goal'; used by GameSummaryScreen_period
        db 053h,068h,06Fh,074h,073h,020h,06Fh,06Eh,020h,067h,06Fh,061h,06Ch,00h
str_SDD:                                        ; string '%s %d/%d'; used by GameSummaryScreen_period
        db 025h,073h,020h,025h,064h,02Fh,025h,064h,00h,00h,00h
str_Ctbkgd3:                                    ; string 'ctbkgd'; used by GameStatsScreen
        db 063h,074h,062h,06Bh,067h,064h,00h
str_Pal14:                                      ; string '!pal'; used by GameStatsScreen
        db 021h,070h,061h,06Ch,00h
str_Bkgd6:                                      ; string 'bkgd'; used by GameStatsScreen
        db 062h,06Bh,067h,064h,00h
str_Cttitle32:                                  ; string 'cttitle3'; used by GameStatsScreen
        db 063h,074h,074h,069h,074h,06Ch,065h,033h,00h
str_Colm2:                                      ; string 'colm'; used by GameStatsScreen
        db 063h,06Fh,06Ch,06Dh,00h
str_Gsta:                                       ; string 'gsta'; used by GameStatsScreen
        db 067h,073h,074h,061h,00h
str_Ctlogo3:                                    ; string 'ctlogo'; used by GameStatsScreen
        db 063h,074h,06Ch,06Fh,067h,06Fh,00h
str_D7:                                         ; string '%d'; used by GameStatsScreen
        db 025h,064h,00h
str_DD:                                         ; string '%d/%d'; used by GameStatsScreen
        db 025h,064h,02Fh,025h,064h,00h
str_D02d2:                                      ; string '%d:%02d'; used by GameStatsScreen
        db 025h,064h,03Ah,025h,030h,032h,064h,00h
str_DDD:                                        ; string '%d/%d (%d%%)'; used by GameStatsScreen
        db 025h,064h,02Fh,025h,064h,020h,028h,025h,064h,025h,025h,029h,00h
str_Iff7:                                       ; string '.iff'; used by GameStatsScreen
        db 02Eh,069h,066h,066h,00h
str_Leaguetm:                                   ; string 'leaguetm'; used by GameStatsScreen
        db 06Ch,065h,061h,067h,075h,065h,074h,06Dh,00h
str_Mtsum2:                                     ; string 'mtsum'; used by GameStatsScreen
        db 06Dh,074h,073h,075h,06Dh,00h
str_Adsum2:                                     ; string 'adsum'; used by GameStatsScreen
        db 061h,064h,073h,075h,06Dh,00h,00h
