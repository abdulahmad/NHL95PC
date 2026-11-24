; Strings and constants of front/stats_screens (src/front/stats_screens), in link order.
bits 32
%include "hockey.inc"
section s_C0C34 progbits alloc noexec write align=1
global str_embpal, str_Pal6, str_tstat, str_keys, str_pstat, str_gstat, str_embpal2, str_Pal7
global str_easndesk2, str_tstat2, str_keys2, str_pstat2, str_gstat2, str_calendar, str_embpal3, str_Pal8
global str_tstat3, str_keys3, str_pstat3, str_gstat3, str_Speed, str_Agility, str_Weight, str_ShotPower
global str_Checking2, str_StickHandling, str_Accuracy, str_Passing2, str_OffensiveAwareness, str_DefensiveAwareness, str_Aggressiveness, str_Endurance
global str_ShootPassBias, str_Faceoffs
str_embpal:                                     ; string; used by GameGoalieStatsScreen,
                                                ; GameSkaterStatsScreen, GameStandingsMenu ...
        db 065h,06Dh,062h,070h,061h,06Ch,00h
str_Pal6:                                       ; string; used by GameGoalieStatsScreen,
                                                ; GameSkaterStatsScreen, GameStandingsMenu ...
        db 021h,070h,061h,06Ch,00h
str_tstat:                                      ; string; used by GameStandingsMenu
        db 074h,073h,074h,061h,074h,00h
str_keys:                                       ; string; used by GameStandingsMenu
        db 06Bh,065h,079h,073h,00h
str_pstat:                                      ; string; used by GameStandingsMenu
        db 070h,073h,074h,061h,074h,00h
str_gstat:                                      ; string; used by GameStandingsMenu
        db 067h,073h,074h,061h,074h,00h,00h
str_embpal2:                                    ; string; used by EasnGoalieStatsScreen_common,
                                                ; EasnGoalieStatsScreen_m, EasnSkaterStatsScreen_m ...
        db 065h,06Dh,062h,070h,061h,06Ch,00h
str_Pal7:                                       ; string; used by EasnGoalieStatsScreen_common,
                                                ; EasnGoalieStatsScreen_m, EasnSkaterStatsScreen_m ...
        db 021h,070h,061h,06Ch,00h
str_easndesk2:                                  ; string; used by EasnGoalieStatsScreen_m,
                                                ; EasnSkaterStatsScreen_m
        db 065h,061h,073h,06Eh,064h,065h,073h,06Bh,00h
str_tstat2:                                     ; string; used by EasnStandingsMenu_m
        db 074h,073h,074h,061h,074h,00h
str_keys2:                                      ; string; used by EasnStandingsMenu_m
        db 06Bh,065h,079h,073h,00h
str_pstat2:                                     ; string; used by EasnStandingsMenu_m
        db 070h,073h,074h,061h,074h,00h
str_gstat2:                                     ; string; used by EasnStandingsMenu_m
        db 067h,073h,074h,061h,074h,00h
str_calendar:                                   ; string; used by LoadCalendarShapes
        db 063h,061h,06Ch,065h,06Eh,064h,061h,072h,00h
str_embpal3:                                    ; string; used by CalGoalieStatsScreen, CalSkaterStatsScreen,
                                                ; CalStandingsMenu ...
        db 065h,06Dh,062h,070h,061h,06Ch,00h
str_Pal8:                                       ; string; used by CalGoalieStatsScreen, CalSkaterStatsScreen,
                                                ; CalStandingsMenu ...
        db 021h,070h,061h,06Ch,00h
str_tstat3:                                     ; string; used by CalStandingsMenu
        db 074h,073h,074h,061h,074h,00h
str_keys3:                                      ; string; used by CalStandingsMenu
        db 06Bh,065h,079h,073h,00h
str_pstat3:                                     ; string; used by CalStandingsMenu
        db 070h,073h,074h,061h,074h,00h
str_gstat3:                                     ; string; used by CalStandingsMenu
        db 067h,073h,074h,061h,074h,00h
str_Speed:                                      ; "Speed" string literal
        db 053h,070h,065h,065h,064h,00h
str_Agility:                                    ; "Agility" string literal
        db 041h,067h,069h,06Ch,069h,074h,079h,00h
str_Weight:                                     ; "Weight" string literal
        db 057h,065h,069h,067h,068h,074h,00h
str_ShotPower:                                  ; "Shot Power" string literal
        db 053h,068h,06Fh,074h,020h,050h,06Fh,077h,065h,072h,00h
str_Checking2:                                  ; "Checking" string literal
        db 043h,068h,065h,063h,06Bh,069h,06Eh,067h,00h
str_StickHandling:                              ; "StickHandling" string literal
        db 053h,074h,069h,063h,06Bh,048h,061h,06Eh,064h,06Ch,069h,06Eh,067h,00h
str_Accuracy:                                   ; "Accuracy" string literal
        db 041h,063h,063h,075h,072h,061h,063h,079h,00h
str_Passing2:                                   ; "Passing" string literal
        db 050h,061h,073h,073h,069h,06Eh,067h,00h
str_OffensiveAwareness:                         ; "Offensive Awareness" string literal
        db 04Fh,066h,066h,065h,06Eh,073h,069h,076h,065h,020h,041h,077h,061h,072h,065h,06Eh
        db 065h,073h,073h,00h
str_DefensiveAwareness:                         ; "Defensive Awareness" string literal
        db 044h,065h,066h,065h,06Eh,073h,069h,076h,065h,020h,041h,077h,061h,072h,065h,06Eh
        db 065h,073h,073h,00h
str_Aggressiveness:                             ; "Aggressiveness" string literal
        db 041h,067h,067h,072h,065h,073h,073h,069h,076h,065h,06Eh,065h,073h,073h,00h
str_Endurance:                                  ; "Endurance" string literal
        db 045h,06Eh,064h,075h,072h,061h,06Eh,063h,065h,00h
str_ShootPassBias:                              ; "Shoot/Pass Bias" string literal
        db 053h,068h,06Fh,06Fh,074h,02Fh,050h,061h,073h,073h,020h,042h,069h,061h,073h,00h
str_Faceoffs:                                   ; "Faceoffs" string literal
        db 046h,061h,063h,065h,06Fh,066h,066h,073h,00h
