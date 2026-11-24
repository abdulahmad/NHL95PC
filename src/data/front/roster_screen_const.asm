; Strings and constants of front/roster_screen (src/front/roster_screen), in link order.
bits 32
%include "hockey.inc"
section s_C1040 progbits alloc noexec write align=1
global str_KeyDb, str_Pstatbar6, str_Pst25, str_S, str_Trad, str_Regi, str_MightyDucksOfAnaheim2, str_Pos
global str_No, str_Name, str_GP5, str_G3, str_A3, str_PT, str_Shots3, str_PIM3
global str_PlusMinus3, str_C, str_Min3, str_GAA3, str_W3, str_L5, str_T3, str_GA
global str_SA2, str_PCT, str_PointLeaders, str_GoalLeaders, str_AssistLeaders, str_PowerPlayGoalLeaders, str_ShorthandedGoalLeaders, str_PlusMinusLeaders
global str_PenaltyMinuteLeaders, str_ShootingPercentageLeaders, str_GoalsAgainstAverageLeaders, str_GoaltenderWinLeaders, str_SavePercentageLeaders, str_spG, str_spA, str_Pt3
global str_BlankLeaderColumn, str_PP2, str_SHG3, str_PlusMinus5, str_PIM6, str_Shots5, str_Pct6, str_MIN5
global str_GA5, str_AVG2, str_spW2, str_SpL5, str_SpT2, str_SA4, str_PCT7
str_KeyDb:                                      ; string 'key.db'; used by TeamRosterScreen
        db 06Bh,065h,079h,02Eh,064h,062h,00h
str_Pstatbar6:                                  ; string 'pstatbar'; used by TeamRosterScreen
        db 070h,073h,074h,061h,074h,062h,061h,072h,00h
str_Pst25:                                      ; string 'pst2'; used by TeamRosterScreen
        db 070h,073h,074h,032h,00h
str_S:                                          ; string '%s'; used by TeamRosterScreen
        db 025h,073h,00h
str_Trad:                                       ; string 'trad'; used by TeamRosterScreen
        db 074h,072h,061h,064h,00h
str_Regi:                                       ; string 'regi'; used by TeamRosterScreen
        db 072h,065h,067h,069h,00h
str_MightyDucksOfAnaheim2:                      ; string 'Mighty Ducks of Anaheim'; used by TeamRosterScreen
        db 04Dh,069h,067h,068h,074h,079h,020h,044h,075h,063h,06Bh,073h,020h,020h,06Fh,066h
        db 020h,041h,06Eh,061h,068h,065h,069h,06Dh,00h
str_Pos:                                        ; string 'Pos'; used by TeamRosterScreen
        db 050h,06Fh,073h,00h
str_No:                                         ; string 'No'; used by TeamRosterScreen
        db 04Eh,06Fh,00h
str_Name:                                       ; string 'Name'; used by TeamRosterScreen
        db 04Eh,061h,06Dh,065h,00h
str_GP5:                                        ; string 'GP'; used by TeamRosterScreen
        db 047h,050h,00h
str_G3:                                         ; string ' G'; used by TeamRosterScreen
        db 020h,020h,047h,00h
str_A3:                                         ; string ' A'; used by TeamRosterScreen
        db 020h,020h,041h,00h
str_PT:                                         ; string ' PT'; used by TeamRosterScreen
        db 020h,050h,054h,00h
str_Shots3:                                     ; string 'Shots'; used by TeamRosterScreen
        db 053h,068h,06Fh,074h,073h,00h
str_PIM3:                                       ; string 'PIM'; used by TeamRosterScreen
        db 050h,049h,04Dh,00h
str_PlusMinus3:                                 ; " +/-"; used by TeamRosterScreen
        db 020h,02Bh,02Fh,02Dh,00h
str_C:                                          ; string '%c'; used by TeamRosterScreen
        db 025h,063h,00h
str_Min3:                                       ; string ' Min'; used by TeamRosterScreen
        db 020h,04Dh,069h,06Eh,00h
str_GAA3:                                       ; string ' GAA'; used by TeamRosterScreen
        db 020h,020h,047h,041h,041h,00h
str_W3:                                         ; string ' W'; used by TeamRosterScreen
        db 020h,057h,00h
str_L5:                                         ; string ' L'; used by TeamRosterScreen
        db 020h,04Ch,00h
str_T3:                                         ; string ' T'; used by TeamRosterScreen
        db 020h,054h,00h
str_GA:                                         ; string ' GA'; used by TeamRosterScreen
        db 020h,047h,041h,00h
str_SA2:                                        ; string ' SA'; used by TeamRosterScreen
        db 020h,020h,053h,041h,00h
str_PCT:                                        ; string ' PCT'; used by TeamRosterScreen
        db 020h,020h,050h,043h,054h,00h,00h
str_PointLeaders:                               ; " Point Leaders" string literal
        db 020h,050h,06Fh,069h,06Eh,074h,020h,04Ch,065h,061h,064h,065h,072h,073h,00h
str_GoalLeaders:                                ; " Goal Leaders" string literal
        db 020h,047h,06Fh,061h,06Ch,020h,04Ch,065h,061h,064h,065h,072h,073h,00h
str_AssistLeaders:                              ; " Assist Leaders" string literal
        db 020h,041h,073h,073h,069h,073h,074h,020h,04Ch,065h,061h,064h,065h,072h,073h,00h
str_PowerPlayGoalLeaders:                       ; " Power Play Goal Leaders" string literal
        db 020h,050h,06Fh,077h,065h,072h,020h,050h,06Ch,061h,079h,020h,047h,06Fh,061h,06Ch
        db 020h,04Ch,065h,061h,064h,065h,072h,073h,00h
str_ShorthandedGoalLeaders:                     ; " Shorthanded Goal Leaders" string literal
        db 020h,053h,068h,06Fh,072h,074h,068h,061h,06Eh,064h,065h,064h,020h,047h,06Fh,061h
        db 06Ch,020h,04Ch,065h,061h,064h,065h,072h,073h,00h
str_PlusMinusLeaders:                           ; " Plus/Minus Leaders" string literal
        db 020h,050h,06Ch,075h,073h,02Fh,04Dh,069h,06Eh,075h,073h,020h,04Ch,065h,061h,064h
        db 065h,072h,073h,00h
str_PenaltyMinuteLeaders:                       ; " Penalty Minute Leaders" string literal
        db 020h,050h,065h,06Eh,061h,06Ch,074h,079h,020h,04Dh,069h,06Eh,075h,074h,065h,020h
        db 04Ch,065h,061h,064h,065h,072h,073h,00h
str_ShootingPercentageLeaders:                  ; " Shooting Percentage Leaders" string literal
        db 020h,053h,068h,06Fh,06Fh,074h,069h,06Eh,067h,020h,050h,065h,072h,063h,065h,06Eh
        db 074h,061h,067h,065h,020h,04Ch,065h,061h,064h,065h,072h,073h,00h
str_GoalsAgainstAverageLeaders:                 ; " Goals Against Average Leaders" string literal
        db 020h,047h,06Fh,061h,06Ch,073h,020h,041h,067h,061h,069h,06Eh,073h,074h,020h,041h
        db 076h,065h,072h,061h,067h,065h,020h,04Ch,065h,061h,064h,065h,072h,073h,00h
str_GoaltenderWinLeaders:                       ; " Goaltender Win Leaders" string literal
        db 020h,047h,06Fh,061h,06Ch,074h,065h,06Eh,064h,065h,072h,020h,057h,069h,06Eh,020h
        db 04Ch,065h,061h,064h,065h,072h,073h,00h
str_SavePercentageLeaders:                      ; " Save Percentage Leaders" string literal
        db 020h,053h,061h,076h,065h,020h,050h,065h,072h,063h,065h,06Eh,074h,061h,067h,065h
        db 020h,04Ch,065h,061h,064h,065h,072h,073h,00h
str_spG:                                        ; string ' G'
        db 020h,020h,047h,00h
str_spA:                                        ; string ' A'
        db 020h,020h,041h,00h
str_Pt3:                                        ; " Pt" string literal
        db 020h,050h,074h,00h
str_BlankLeaderColumn:                          ; Empty league leader column header
        db 00h
str_PP2:                                        ; "PP" string literal
        db 050h,050h,00h
str_SHG3:                                       ; "SHG" string literal
        db 053h,048h,047h,00h
str_PlusMinus5:                                 ; string ' +/-'
        db 020h,02Bh,02Fh,02Dh,00h
str_PIM6:                                       ; "PIM" string literal
        db 050h,049h,04Dh,00h
str_Shots5:                                     ; "Shots" string literal
        db 053h,068h,06Fh,074h,073h,00h
str_Pct6:                                       ; " Pct" string literal
        db 020h,020h,050h,063h,074h,00h
str_MIN5:                                       ; " MIN" string literal
        db 020h,04Dh,049h,04Eh,00h
str_GA5:                                        ; " GA" string literal
        db 020h,047h,041h,00h
str_AVG2:                                       ; " AVG" string literal
        db 020h,020h,041h,056h,047h,00h
str_spW2:                                       ; string ' W'
        db 020h,057h,00h
str_SpL5:                                       ; string ' L'
        db 020h,04Ch,00h
str_SpT2:                                       ; string ' T'
        db 020h,054h,00h
str_SA4:                                        ; " SA" string literal
        db 020h,020h,053h,041h,00h
str_PCT7:                                       ; " PCT" string literal
        db 020h,020h,050h,043h,054h,00h
