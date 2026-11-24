; Strings and constants of front/stats_cards (src/front/stats_cards), in link order.
bits 32
%include "hockey.inc"
section s_C0D52 progbits alloc noexec write align=1
global str_PORTR, str_Pstatbar3, str_Pst1, str_Pst22, str_PlayerStats, str_SS2, str_D2, str_Center2
global str_Defense, str_LeftWing2, str_RightWing2, str_GP2, str_G2, str_A2, str_Pt2, str_PIM2
global str_PlusMinus2, str_PPG2, str_SHG2, str_Shots2, str_Pct2, str_Ratings2, str_Shoots2, str_L2
global str_R, str_GloveLeft, str_GloveRight, str_StickLeft, str_StickRight, str_PuckControl, str_Speed2, str_Agility2
global str_Weight2, str_OffensiveAwareness2, str_DefensiveAwareness2, str_PORTR2, str_Pstatbar4, str_Pst12, str_Pst23, str_PlayerStats2
global str_SS3, str_DGoalie, str_GP3, str_Min2, str_GAA2, str_W2, str_L4, str_T2
global str_SO2, str_EN2, str_SA, str_Pct3, str_Ratings3, str_GloveHand2, str_L3, str_R2
global str_WesternConference3, str_EasternConference3, str_TeamScoring, str_TeamDefense, str_TeamPenaltyKilling, str_TeamPowerPlay, str_TeamPenalties, str_TeamStandings
global str_spW, str_SpL4, str_SpT, str_GF2, str_GA4, str_TSH, str_PPGA, str_PCT5
global str_BlankTeamColumn, str_ADV, str_PPG3, str_PIM5, str_AVG, str_PTS, str_WINS
str_PORTR:                                      ; string 'PORTR'; used by SkaterStatsCard
        db 050h,04Fh,052h,054h,052h,00h
str_Pstatbar3:                                  ; string 'pstatbar'; used by SkaterStatsCard
        db 070h,073h,074h,061h,074h,062h,061h,072h,00h
str_Pst1:                                       ; string 'pst1'; used by SkaterStatsCard
        db 070h,073h,074h,031h,00h
str_Pst22:                                      ; string 'pst2'; used by SkaterStatsCard
        db 070h,073h,074h,032h,00h
str_PlayerStats:                                ; string 'Player Stats'; used by SkaterStatsCard
        db 050h,06Ch,061h,079h,065h,072h,020h,053h,074h,061h,074h,073h,00h
str_SS2:                                        ; string '%s %s'; used by SkaterStatsCard
        db 025h,073h,020h,025h,073h,00h
str_D2:                                         ; string '%d '; used by SkaterStatsCard
        db 025h,064h,020h,00h
str_Center2:                                    ; string 'Center'; used by SkaterStatsCard
        db 043h,065h,06Eh,074h,065h,072h,00h
str_Defense:                                    ; string 'Defense'; used by SkaterStatsCard
        db 044h,065h,066h,065h,06Eh,073h,065h,00h
str_LeftWing2:                                  ; string 'Left Wing'; used by SkaterStatsCard
        db 04Ch,065h,066h,074h,020h,057h,069h,06Eh,067h,00h
str_RightWing2:                                 ; string 'Right Wing'; used by SkaterStatsCard
        db 052h,069h,067h,068h,074h,020h,057h,069h,06Eh,067h,00h
str_GP2:                                        ; string 'GP'; used by SkaterStatsCard
        db 047h,050h,00h
str_G2:                                         ; string ' G'; used by SkaterStatsCard
        db 020h,020h,047h,00h
str_A2:                                         ; string ' A'; used by SkaterStatsCard
        db 020h,020h,041h,00h
str_Pt2:                                        ; string ' Pt'; used by SkaterStatsCard
        db 020h,050h,074h,00h
str_PIM2:                                       ; string 'PIM'; used by SkaterStatsCard
        db 050h,049h,04Dh,00h
str_PlusMinus2:                                 ; " +/-"; used by SkaterStatsCard
        db 020h,02Bh,02Fh,02Dh,00h
str_PPG2:                                       ; string 'PPG'; used by SkaterStatsCard
        db 050h,050h,047h,00h
str_SHG2:                                       ; string 'SHG'; used by SkaterStatsCard
        db 053h,048h,047h,00h
str_Shots2:                                     ; string 'Shots'; used by SkaterStatsCard
        db 053h,068h,06Fh,074h,073h,00h
str_Pct2:                                       ; string ' Pct'; used by SkaterStatsCard
        db 020h,020h,050h,063h,074h,00h
str_Ratings2:                                   ; string 'Ratings:'; used by SkaterStatsCard
        db 052h,061h,074h,069h,06Eh,067h,073h,03Ah,00h
str_Shoots2:                                    ; string 'Shoots'; used by SkaterStatsCard
        db 053h,068h,06Fh,06Fh,074h,073h,00h
str_L2:                                         ; string ' L'; used by SkaterStatsCard
        db 020h,020h,04Ch,00h
str_R:                                          ; string ' R'; used by SkaterStatsCard
        db 020h,020h,052h,00h,00h,00h
str_GloveLeft:                                  ; "Glove Left" string literal
        db 047h,06Ch,06Fh,076h,065h,020h,04Ch,065h,066h,074h,00h
str_GloveRight:                                 ; "Glove Right" string literal
        db 047h,06Ch,06Fh,076h,065h,020h,052h,069h,067h,068h,074h,00h
str_StickLeft:                                  ; "Stick Left" string literal
        db 053h,074h,069h,063h,06Bh,020h,04Ch,065h,066h,074h,00h
str_StickRight:                                 ; "Stick Right" string literal
        db 053h,074h,069h,063h,06Bh,020h,052h,069h,067h,068h,074h,00h
str_PuckControl:                                ; "Puck Control" string literal
        db 050h,075h,063h,06Bh,020h,043h,06Fh,06Eh,074h,072h,06Fh,06Ch,00h
str_Speed2:                                     ; "Speed" string literal
        db 053h,070h,065h,065h,064h,00h
str_Agility2:                                   ; "Agility" string literal
        db 041h,067h,069h,06Ch,069h,074h,079h,00h
str_Weight2:                                    ; "Weight" string literal
        db 057h,065h,069h,067h,068h,074h,00h
str_OffensiveAwareness2:                        ; "Offensive Awareness" string literal
        db 04Fh,066h,066h,065h,06Eh,073h,069h,076h,065h,020h,041h,077h,061h,072h,065h,06Eh
        db 065h,073h,073h,00h
str_DefensiveAwareness2:                        ; "Defensive Awareness" string literal
        db 044h,065h,066h,065h,06Eh,073h,069h,076h,065h,020h,041h,077h,061h,072h,065h,06Eh
        db 065h,073h,073h,00h
str_PORTR2:                                     ; string 'PORTR'; used by GoalieStatsCard
        db 050h,04Fh,052h,054h,052h,00h
str_Pstatbar4:                                  ; string 'pstatbar'; used by GoalieStatsCard
        db 070h,073h,074h,061h,074h,062h,061h,072h,00h
str_Pst12:                                      ; string 'pst1'; used by GoalieStatsCard
        db 070h,073h,074h,031h,00h
str_Pst23:                                      ; string 'pst2'; used by GoalieStatsCard
        db 070h,073h,074h,032h,00h
str_PlayerStats2:                               ; string 'Player Stats'; used by GoalieStatsCard
        db 050h,06Ch,061h,079h,065h,072h,020h,053h,074h,061h,074h,073h,00h
str_SS3:                                        ; string '%s %s'; used by GoalieStatsCard
        db 025h,073h,020h,025h,073h,00h
str_DGoalie:                                    ; string '%d Goalie'; used by GoalieStatsCard
        db 025h,064h,020h,047h,06Fh,061h,06Ch,069h,065h,00h
str_GP3:                                        ; string 'GP'; used by GoalieStatsCard
        db 047h,050h,00h
str_Min2:                                       ; string ' Min'; used by GoalieStatsCard
        db 020h,04Dh,069h,06Eh,00h
str_GAA2:                                       ; string ' GAA'; used by GoalieStatsCard
        db 020h,020h,047h,041h,041h,00h
str_W2:                                         ; string ' W'; used by GoalieStatsCard
        db 020h,057h,00h
str_L4:                                         ; string ' L'; used by GoalieStatsCard
        db 020h,04Ch,00h
str_T2:                                         ; string ' T'; used by GoalieStatsCard
        db 020h,054h,00h
str_SO2:                                        ; string 'SO'; used by GoalieStatsCard
        db 053h,04Fh,00h
str_EN2:                                        ; string 'EN'; used by GoalieStatsCard
        db 045h,04Eh,00h
str_SA:                                         ; string ' SA'; used by GoalieStatsCard
        db 020h,020h,020h,053h,041h,00h
str_Pct3:                                       ; string ' Pct'; used by GoalieStatsCard
        db 020h,020h,050h,063h,074h,00h
str_Ratings3:                                   ; string 'Ratings:'; used by GoalieStatsCard
        db 052h,061h,074h,069h,06Eh,067h,073h,03Ah,00h
str_GloveHand2:                                 ; string 'Glove Hand'; used by GoalieStatsCard
        db 047h,06Ch,06Fh,076h,065h,020h,048h,061h,06Eh,064h,00h
str_L3:                                         ; string ' L'; used by GoalieStatsCard
        db 020h,020h,04Ch,00h
str_R2:                                         ; string ' R'; used by GoalieStatsCard
        db 020h,020h,052h,00h,00h
str_WesternConference3:                         ; "Western Conference" string literal
        db 057h,065h,073h,074h,065h,072h,06Eh,020h,043h,06Fh,06Eh,066h,065h,072h,065h,06Eh
        db 063h,065h,00h
str_EasternConference3:                         ; "Eastern Conference" string literal
        db 045h,061h,073h,074h,065h,072h,06Eh,020h,043h,06Fh,06Eh,066h,065h,072h,065h,06Eh
        db 063h,065h,00h
str_TeamScoring:                                ; " Team Scoring" string literal
        db 020h,054h,065h,061h,06Dh,020h,053h,063h,06Fh,072h,069h,06Eh,067h,00h
str_TeamDefense:                                ; " Team Defense" string literal
        db 020h,054h,065h,061h,06Dh,020h,044h,065h,066h,065h,06Eh,073h,065h,00h
str_TeamPenaltyKilling:                         ; " Team Penalty Killing" string literal
        db 020h,054h,065h,061h,06Dh,020h,050h,065h,06Eh,061h,06Ch,074h,079h,020h,04Bh,069h
        db 06Ch,06Ch,069h,06Eh,067h,00h
str_TeamPowerPlay:                              ; " Team Power Play" string literal
        db 020h,054h,065h,061h,06Dh,020h,050h,06Fh,077h,065h,072h,020h,050h,06Ch,061h,079h
        db 00h
str_TeamPenalties:                              ; " Team Penalties" string literal
        db 020h,054h,065h,061h,06Dh,020h,050h,065h,06Eh,061h,06Ch,074h,069h,065h,073h,00h
str_TeamStandings:                              ; " Team Standings" string literal
        db 020h,054h,065h,061h,06Dh,020h,053h,074h,061h,06Eh,064h,069h,06Eh,067h,073h,00h
str_spW:                                        ; string ' W'
        db 020h,057h,00h
str_SpL4:                                       ; string ' L'
        db 020h,04Ch,00h
str_SpT:                                        ; string ' T'
        db 020h,054h,00h
str_GF2:                                        ; " GF" string literal
        db 020h,047h,046h,00h
str_GA4:                                        ; " GA" string literal
        db 020h,047h,041h,00h
str_TSH:                                        ; "TSH" string literal
        db 054h,053h,048h,00h
str_PPGA:                                       ; "PPGA" string literal
        db 050h,050h,047h,041h,00h
str_PCT5:                                       ; " PCT" string literal
        db 020h,020h,050h,043h,054h,00h
str_BlankTeamColumn:                            ; Empty team statistics column header
        db 00h
str_ADV:                                        ; "ADV" string literal
        db 041h,044h,056h,00h
str_PPG3:                                       ; "PPG" string literal
        db 050h,050h,047h,00h
str_PIM5:                                       ; " PIM" string literal
        db 020h,050h,049h,04Dh,00h
str_AVG:                                        ; " AVG" string literal
        db 020h,020h,041h,056h,047h,00h
str_PTS:                                        ; "PTS" string literal
        db 050h,054h,053h,00h
str_WINS:                                       ; "WINS" string literal
        db 057h,049h,04Eh,053h,00h
