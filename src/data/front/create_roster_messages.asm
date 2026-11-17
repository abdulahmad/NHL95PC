; Messages from Edit Rosters and Create Player: incomplete lines, jersey conflicts, and which hand a player
; uses.
bits 32
%include "hockey.inc"
section s_C28C4 progbits alloc noexec write align=1
global str_Prez2, str_Pal, str_ea, str_Uar, str_Uarm, str_TheJerseyNumber2d, str_PleaseEnterANew, str_Menubuff
global str_TheDatabaseHasNot, str_AreYouSureYou, str_ErrorsFoundInDatabases, str_TheForwardLinesAre, str_TheDefenceLinesAre, str_ThePowerPlayLines, str_ThePenaltyKillingLines, str_TheGoalieLinesAre
global str_TheExtraAttackerLines, str_NotEnoughPlayers, str_NotEnoughGoalies, str_NotEnoughForwards, str_NotEnoughDefence, str_Shoots, str_spL, str_spR
global str_GloveHand, str_EnterANewRating, str_RatingRange, str_ShootsLeftOrRight, str_NotEnoughRatingUnits, str_GloveHandLeftOr, str_Prez22, str_Pal2
global str_ea2, str_Pstatbar, str_Pst2, str_FreeAgent, str_fmtSS, str_fmtD, str_Center, str_Defence
global str_LeftWing, str_RightWing, str_Goalie, str_RatingUnitsAvailable3d, str_Temp, str_ErrDiskFree, str_3dKbytesOfFree, str_NotEnoughSpaceTo
global str_ANewFreeAgent, str_EnterNewPlayerName, str_EnterNewGoalieName, str_EnterAPositionFor, str_LCRD, str_EnterAJerseyNumber, str_NotEnoughSpaceFA, str_InTheFreeAgent
global str_ForAllSelectedPlayers, str_TheNumberOfSelected, str_PlayersAndGoalies, str_Players, str_Goalies, str_MustBeTheSame, str_EnterNameOfPlayer, str_FreeAgentList
global str_ChooseWhichTeamTo, str_IsAlreadyDisplayedOn, str_Roster2, str_Roster1, str_DoesNotExist, fp_1000, fp_84, fp_300
global fp_390, fp_200, fp_100, fp_m50, fp_500, fp_90, fp_10, fp_70
global fp_30, fp_58, fp_347, F64_RatingNinety, F64_RatingTenth, str_GP9, str_spG2, str_spA2
global str_Pt4, str_PIM7, str_PlusMinus6, str_PPG4, str_SHG4, str_Shots6, str_Pct8, str_Shoots3
global str_Speed3, str_Agility3, str_Weight3, str_ShotPower2, str_Checking3, str_StickHandling2, str_Accuracy2, str_Passing3
global str_OffensiveAwareness3, str_DefensiveAwareness3, str_Aggressiveness2, str_Endurance2, str_ShootPassBias2, str_Faceoffs2, str_Min6, str_GA6
global str_GAA5, str_spW3, str_SpL6, str_SpT3, str_SO3, str_EN3, str_SA5, str_GloveHand3
global str_GloveLeft2, str_GloveRight2, str_StickLeft2, str_StickRight2, str_PuckControl2, str_PenaltyKilling3, str_PowerPlay3, str_Shooting2
global str_Skating2, str_Defence2, str_Goaltending2, str_OverAll2, str_Cancel6, str_Create, str_X, str_L9
global str_R5
str_Prez2:                                      ; string 'prez2'; used by DrawEditRosters
        db 070h,072h,065h,07Ah,032h,00h
str_Pal:                                        ; string '!pal'; used by DrawEditRosters
        db 021h,070h,061h,06Ch,00h
str_ea:                                         ; string 'ea '; used by DrawEditRosters
        db 065h,061h,020h,020h,00h
str_Uar:                                        ; string 'uar'; used by LoadRosterList_faloop
        db 075h,061h,072h,00h
str_Uarm:                                       ; string 'uarm'; used by LoadRosterList_faloop
        db 075h,061h,072h,06Dh,00h
str_TheJerseyNumber2d:                          ; string 'The jersey number %2d is already used!'; used by
                                                ; FixJerseyNumber
        db 054h,068h,065h,020h,06Ah,065h,072h,073h,065h,079h,020h,06Eh,075h,06Dh,062h,065h
        db 072h,020h,025h,032h,064h,020h,069h,073h,020h,061h,06Ch,072h,065h,061h,064h,079h
        db 020h,075h,073h,065h,064h,021h,00h
str_PleaseEnterANew:                            ; string 'Please enter a new jersey number for'; used by
                                                ; FixJerseyNumber
        db 050h,06Ch,065h,061h,073h,065h,020h,065h,06Eh,074h,065h,072h,020h,061h,020h,06Eh
        db 065h,077h,020h,06Ah,065h,072h,073h,065h,079h,020h,06Eh,075h,06Dh,062h,065h,072h
        db 020h,066h,06Fh,072h,00h
str_Menubuff:                                   ; string 'menubuff'; used by EditRosters
        db 06Dh,065h,06Eh,075h,062h,075h,066h,066h,00h
str_TheDatabaseHasNot:                          ; string 'The database has not been saved.'; used by
                                                ; EditRosters
        db 054h,068h,065h,020h,064h,061h,074h,061h,062h,061h,073h,065h,020h,068h,061h,073h
        db 020h,06Eh,06Fh,074h,020h,062h,065h,065h,06Eh,020h,073h,061h,076h,065h,064h,02Eh
        db 00h
str_AreYouSureYou:                              ; string 'Are you sure you want to exit?'; used by EditRosters
        db 041h,072h,065h,020h,079h,06Fh,075h,020h,073h,075h,072h,065h,020h,079h,06Fh,075h
        db 020h,077h,061h,06Eh,074h,020h,074h,06Fh,020h,065h,078h,069h,074h,03Fh,00h,00h
        db 00h
str_GP9:                                        ; "GP" string literal
        db 047h,050h,00h
str_spG2:                                       ; string ' G'
        db 020h,020h,047h,00h
str_spA2:                                       ; string ' A'
        db 020h,020h,041h,00h
str_Pt4:                                        ; " Pt" string literal
        db 020h,050h,074h,00h
str_PIM7:                                       ; "PIM" string literal
        db 050h,049h,04Dh,00h
str_PlusMinus6:                                 ; string ' +/-'
        db 020h,02Bh,02Fh,02Dh,00h
str_PPG4:                                       ; "PPG" string literal
        db 050h,050h,047h,00h
str_SHG4:                                       ; "SHG" string literal
        db 053h,048h,047h,00h
str_Shots6:                                     ; "Shots" string literal
        db 053h,068h,06Fh,074h,073h,00h
str_Pct8:                                       ; " Pct" string literal
        db 020h,020h,050h,063h,074h,00h
str_Shoots3:                                    ; "Shoots" string literal
        db 053h,068h,06Fh,06Fh,074h,073h,00h
str_Speed3:                                     ; "Speed" string literal
        db 053h,070h,065h,065h,064h,00h
str_Agility3:                                   ; "Agility" string literal
        db 041h,067h,069h,06Ch,069h,074h,079h,00h
str_Weight3:                                    ; "Weight" string literal
        db 057h,065h,069h,067h,068h,074h,00h
str_ShotPower2:                                 ; "Shot Power" string literal
        db 053h,068h,06Fh,074h,020h,050h,06Fh,077h,065h,072h,00h
str_Checking3:                                  ; "Checking" string literal
        db 043h,068h,065h,063h,06Bh,069h,06Eh,067h,00h
str_StickHandling2:                             ; "StickHandling" string literal
        db 053h,074h,069h,063h,06Bh,048h,061h,06Eh,064h,06Ch,069h,06Eh,067h,00h
str_Accuracy2:                                  ; "Accuracy" string literal
        db 041h,063h,063h,075h,072h,061h,063h,079h,00h
str_Passing3:                                   ; "Passing" string literal
        db 050h,061h,073h,073h,069h,06Eh,067h,00h
str_OffensiveAwareness3:                        ; "Offensive Awareness" string literal
        db 04Fh,066h,066h,065h,06Eh,073h,069h,076h,065h,020h,041h,077h,061h,072h,065h,06Eh
        db 065h,073h,073h,00h
str_DefensiveAwareness3:                        ; "Defensive Awareness" string literal
        db 044h,065h,066h,065h,06Eh,073h,069h,076h,065h,020h,041h,077h,061h,072h,065h,06Eh
        db 065h,073h,073h,00h
str_Aggressiveness2:                            ; "Aggressiveness" string literal
        db 041h,067h,067h,072h,065h,073h,073h,069h,076h,065h,06Eh,065h,073h,073h,00h
str_Endurance2:                                 ; "Endurance" string literal
        db 045h,06Eh,064h,075h,072h,061h,06Eh,063h,065h,00h
str_ShootPassBias2:                             ; "Shoot/Pass Bias" string literal
        db 053h,068h,06Fh,06Fh,074h,02Fh,050h,061h,073h,073h,020h,042h,069h,061h,073h,00h
str_Faceoffs2:                                  ; "Faceoffs" string literal
        db 046h,061h,063h,065h,06Fh,066h,066h,073h,00h
str_Min6:                                       ; " Min" string literal
        db 020h,04Dh,069h,06Eh,00h
str_GA6:                                        ; " GA" string literal
        db 020h,020h,047h,041h,00h
str_GAA5:                                       ; " GAA" string literal
        db 020h,020h,047h,041h,041h,00h
str_spW3:                                       ; string ' W'
        db 020h,057h,00h
str_SpL6:                                       ; string ' L'
        db 020h,04Ch,00h
str_SpT3:                                       ; string ' T'
        db 020h,054h,00h
str_SO3:                                        ; "SO" string literal
        db 053h,04Fh,00h
str_EN3:                                        ; "EN" string literal
        db 045h,04Eh,00h
str_SA5:                                        ; " SA" string literal
        db 020h,020h,020h,053h,041h,00h
str_GloveHand3:                                 ; "Glove Hand" string literal
        db 047h,06Ch,06Fh,076h,065h,020h,048h,061h,06Eh,064h,00h
str_GloveLeft2:                                 ; "Glove Left" string literal
        db 047h,06Ch,06Fh,076h,065h,020h,04Ch,065h,066h,074h,00h
str_GloveRight2:                                ; "Glove Right" string literal
        db 047h,06Ch,06Fh,076h,065h,020h,052h,069h,067h,068h,074h,00h
str_StickLeft2:                                 ; "Stick Left" string literal
        db 053h,074h,069h,063h,06Bh,020h,04Ch,065h,066h,074h,00h
str_StickRight2:                                ; "Stick Right" string literal
        db 053h,074h,069h,063h,06Bh,020h,052h,069h,067h,068h,074h,00h
str_PuckControl2:                               ; "Puck Control" string literal
        db 050h,075h,063h,06Bh,020h,043h,06Fh,06Eh,074h,072h,06Fh,06Ch,00h
str_PenaltyKilling3:                            ; "Penalty Killing" string literal
        db 050h,065h,06Eh,061h,06Ch,074h,079h,020h,04Bh,069h,06Ch,06Ch,069h,06Eh,067h,00h
str_PowerPlay3:                                 ; "Power Play" string literal
        db 050h,06Fh,077h,065h,072h,020h,050h,06Ch,061h,079h,00h
str_Shooting2:                                  ; "Shooting" string literal
        db 053h,068h,06Fh,06Fh,074h,069h,06Eh,067h,00h
str_Skating2:                                   ; "Skating" string literal
        db 053h,06Bh,061h,074h,069h,06Eh,067h,00h
str_Defence2:                                   ; "Defence" string literal
        db 044h,065h,066h,065h,06Eh,063h,065h,00h
str_Goaltending2:                               ; "Goaltending" string literal
        db 047h,06Fh,061h,06Ch,074h,065h,06Eh,064h,069h,06Eh,067h,00h
str_OverAll2:                                   ; "Over all" string literal
        db 04Fh,076h,065h,072h,020h,061h,06Ch,06Ch,00h
str_Cancel6:                                    ; "Cancel" string literal
        db 043h,061h,06Eh,063h,065h,06Ch,00h
str_Create:                                     ; "Create" string literal
        db 043h,072h,065h,061h,074h,065h,00h
str_X:                                          ; string 'X'
        db 058h,00h,00h,00h,00h
str_ErrorsFoundInDatabases:                     ; string 'Errors found in databases!'; used by
                                                ; DrawDBErrorsScreen
        db 045h,072h,072h,06Fh,072h,073h,020h,066h,06Fh,075h,06Eh,064h,020h,069h,06Eh,020h
        db 064h,061h,074h,061h,062h,061h,073h,065h,073h,021h,00h
str_TheForwardLinesAre:                         ; string 'The forward lines are not complete on '; used by
                                                ; CheckTeamLines
        db 054h,068h,065h,020h,066h,06Fh,072h,077h,061h,072h,064h,020h,06Ch,069h,06Eh,065h
        db 073h,020h,061h,072h,065h,020h,06Eh,06Fh,074h,020h,063h,06Fh,06Dh,070h,06Ch,065h
        db 074h,065h,020h,06Fh,06Eh,020h,00h
str_TheDefenceLinesAre:                         ; string 'The defence lines are not complete on '; used by
                                                ; CheckTeamLines
        db 054h,068h,065h,020h,064h,065h,066h,065h,06Eh,063h,065h,020h,06Ch,069h,06Eh,065h
        db 073h,020h,061h,072h,065h,020h,06Eh,06Fh,074h,020h,063h,06Fh,06Dh,070h,06Ch,065h
        db 074h,065h,020h,06Fh,06Eh,020h,00h
str_ThePowerPlayLines:                          ; string 'The power play lines are not complete on '; used by
                                                ; CheckTeamLines
        db 054h,068h,065h,020h,070h,06Fh,077h,065h,072h,020h,070h,06Ch,061h,079h,020h,06Ch
        db 069h,06Eh,065h,073h,020h,061h,072h,065h,020h,06Eh,06Fh,074h,020h,063h,06Fh,06Dh
        db 070h,06Ch,065h,074h,065h,020h,06Fh,06Eh,020h,00h
str_ThePenaltyKillingLines:                     ; string 'The penalty killing lines are not complete on ';
                                                ; used by CheckTeamLines
        db 054h,068h,065h,020h,070h,065h,06Eh,061h,06Ch,074h,079h,020h,06Bh,069h,06Ch,06Ch
        db 069h,06Eh,067h,020h,06Ch,069h,06Eh,065h,073h,020h,061h,072h,065h,020h,06Eh,06Fh
        db 074h,020h,063h,06Fh,06Dh,070h,06Ch,065h,074h,065h,020h,06Fh,06Eh,020h,00h
str_TheGoalieLinesAre:                          ; string 'The goalie lines are not complete on '; used by
                                                ; CheckTeamLines
        db 054h,068h,065h,020h,067h,06Fh,061h,06Ch,069h,065h,020h,06Ch,069h,06Eh,065h,073h
        db 020h,061h,072h,065h,020h,06Eh,06Fh,074h,020h,063h,06Fh,06Dh,070h,06Ch,065h,074h
        db 065h,020h,06Fh,06Eh,020h,00h
str_TheExtraAttackerLines:                      ; string 'The extra attacker lines are not complete on '; used
                                                ; by CheckTeamLines
        db 054h,068h,065h,020h,065h,078h,074h,072h,061h,020h,061h,074h,074h,061h,063h,06Bh
        db 065h,072h,020h,06Ch,069h,06Eh,065h,073h,020h,061h,072h,065h,020h,06Eh,06Fh,074h
        db 020h,063h,06Fh,06Dh,070h,06Ch,065h,074h,065h,020h,06Fh,06Eh,020h,00h
str_NotEnoughPlayers:                           ; string 'There are not enough players on '; used by
                                                ; CheckTeamLines
        db 054h,068h,065h,072h,065h,020h,061h,072h,065h,020h,06Eh,06Fh,074h,020h,065h,06Eh
        db 06Fh,075h,067h,068h,020h,070h,06Ch,061h,079h,065h,072h,073h,020h,06Fh,06Eh,020h
        db 00h
str_NotEnoughGoalies:                           ; string 'There are not enough goalies on '; used by
                                                ; CheckTeamLines
        db 054h,068h,065h,072h,065h,020h,061h,072h,065h,020h,06Eh,06Fh,074h,020h,065h,06Eh
        db 06Fh,075h,067h,068h,020h,067h,06Fh,061h,06Ch,069h,065h,073h,020h,06Fh,06Eh,020h
        db 00h
str_NotEnoughForwards:                          ; string 'There are not enough forwards on '; used by
                                                ; CheckTeamLines
        db 054h,068h,065h,072h,065h,020h,061h,072h,065h,020h,06Eh,06Fh,074h,020h,065h,06Eh
        db 06Fh,075h,067h,068h,020h,066h,06Fh,072h,077h,061h,072h,064h,073h,020h,06Fh,06Eh
        db 020h,00h
str_NotEnoughDefence:                           ; string 'There are not enough defence on '; used by
                                                ; CheckTeamLines
        db 054h,068h,065h,072h,065h,020h,061h,072h,065h,020h,06Eh,06Fh,074h,020h,065h,06Eh
        db 06Fh,075h,067h,068h,020h,064h,065h,066h,065h,06Eh,063h,065h,020h,06Fh,06Eh,020h
        db 00h,00h
fp_1000:                                        ; float constant 1000.0 of RandomizeNewRatings; used by
                                                ; RandomizeNewRatings
        db 00h,00h,07Ah,044h
fp_84:                                          ; float constant 84.0 of RandomizeNewRatings; used by
                                                ; RandomizeNewRatings
        db 00h,00h,0A8h,042h
fp_300:                                         ; float constant 300.0 of RandomizeNewRatings; used by
                                                ; RandomizeNewRatings
        db 00h,00h,096h,043h
fp_390:                                         ; float constant 390.0 of RandomizeNewRatings; used by
                                                ; RandomizeNewRatings
        db 00h,00h,0C3h,043h
fp_200:                                         ; float constant 200.0 of RandomizeNewRatings; used by
                                                ; RandomizeNewRatings
        db 00h,00h,048h,043h
fp_100:                                         ; float constant 100.0 of RandomizeNewRatings; used by
                                                ; RandomizeNewRatings
        db 00h,00h,0C8h,042h
fp_m50:                                         ; float constant -50.0 of RandomizeNewRatings; used by
                                                ; RandomizeNewRatings
        db 00h,00h,048h,0C2h
fp_500:                                         ; float constant 500.0 of RandomizeNewRatings; used by
                                                ; RandomizeNewRatings
        db 00h,00h,0FAh,043h
fp_90:                                          ; float constant 90.0 of RandomizeNewRatings; used by
                                                ; RandomizeNewRatings
        db 00h,00h,0B4h,042h
fp_10:                                          ; float constant 10.0 of RandomizeNewRatings; used by
                                                ; RandomizeNewRatings
        db 00h,00h,020h,041h
fp_70:                                          ; float constant 70.0 of RandomizeNewRatings; used by
                                                ; RandomizeNewRatings
        db 00h,00h,08Ch,042h
fp_30:                                          ; float constant 30.0 of RandomizeNewRatings; used by
                                                ; RandomizeNewRatings
        db 00h,00h,0F0h,041h
fp_58:                                          ; float constant 58.0 of RandomizeNewRatings; used by
                                                ; RandomizeNewRatings
        db 00h,00h,068h,042h
F64_RatingNinety:                               ; Double 0.9 used by RandomizeNewRatings
        db 0CDh,0CCh,0CCh,0CCh,0CCh,0CCh,0ECh,03Fh
F64_RatingTenth:                                ; Double 0.1 used by RandomizeNewRatings
        db 09Ah,099h,099h,099h,099h,099h,0B9h,03Fh
fp_347:                                         ; float constant 347.0 of RandomizeNewRatings; used by
                                                ; RandomizeNewRatings
        db 00h,080h,0ADh,043h
str_Shoots:                                     ; string 'Shoots'; used by DrawShootsField
        db 053h,068h,06Fh,06Fh,074h,073h,00h
str_spL:                                        ; string ' L'; used by DrawGloveField, DrawShootsField
        db 020h,020h,04Ch,00h
str_spR:                                        ; string ' R'; used by DrawGloveField, DrawShootsField
        db 020h,020h,052h,00h
str_GloveHand:                                  ; string 'Glove Hand'; used by DrawGloveField
        db 047h,06Ch,06Fh,076h,065h,020h,048h,061h,06Eh,064h,00h
str_L9:                                         ; string 'L'; used by AskLeftRight
        db 04Ch,00h
str_R5:                                         ; string 'R', read as a word by AskLeftRight; used by
                                                ; AskLeftRight
        db 052h,00h
str_EnterANewRating:                            ; string 'Enter a new rating:'; used by EditGoalieRating,
                                                ; EditSkaterRating
        db 045h,06Eh,074h,065h,072h,020h,061h,020h,06Eh,065h,077h,020h,072h,061h,074h,069h
        db 06Eh,067h,03Ah,00h
str_RatingRange:                                ; string '%2d < %s < %2d'; used by EditGoalieRating,
                                                ; EditSkaterRating
        db 025h,032h,064h,020h,03Ch,020h,025h,073h,020h,03Ch,020h,025h,032h,064h,00h
str_ShootsLeftOrRight:                          ; string 'Shoots Left or Right?'; used by EditSkaterRating
        db 053h,068h,06Fh,06Fh,074h,073h,020h,04Ch,065h,066h,074h,020h,06Fh,072h,020h,052h
        db 069h,067h,068h,074h,03Fh,00h
str_NotEnoughRatingUnits:                       ; string 'Not enough Rating Units'; used by EditGoalieRating,
                                                ; EditSkaterRating
        db 04Eh,06Fh,074h,020h,065h,06Eh,06Fh,075h,067h,068h,020h,052h,061h,074h,069h,06Eh
        db 067h,020h,055h,06Eh,069h,074h,073h,00h
str_GloveHandLeftOr:                            ; string 'Glove hand Left or Right?'; used by EditGoalieRating
        db 047h,06Ch,06Fh,076h,065h,020h,068h,061h,06Eh,064h,020h,04Ch,065h,066h,074h,020h
        db 06Fh,072h,020h,052h,069h,067h,068h,074h,03Fh,00h
str_Prez22:                                     ; string 'prez2'; used by DrawCreatePlayer
        db 070h,072h,065h,07Ah,032h,00h
str_Pal2:                                       ; string '!pal'; used by DrawCreatePlayer
        db 021h,070h,061h,06Ch,00h
str_ea2:                                        ; string 'ea '; used by DrawCreatePlayer
        db 065h,061h,020h,020h,00h
str_Pstatbar:                                   ; string 'pstatbar'; used by DrawCreatePlayer
        db 070h,073h,074h,061h,074h,062h,061h,072h,00h
str_Pst2:                                       ; string 'pst2'; used by DrawCreatePlayer
        db 070h,073h,074h,032h,00h
str_FreeAgent:                                  ; string 'Free Agent'; used by DrawCreatePlayer
        db 046h,072h,065h,065h,020h,041h,067h,065h,06Eh,074h,00h
str_fmtSS:                                      ; string '%s %s'; used by DrawCreatePlayer
        db 025h,073h,020h,025h,073h,00h
str_fmtD:                                       ; string '%d '; used by DrawCreatePlayer
        db 025h,064h,020h,00h
str_Center:                                     ; string 'Center'; used by DrawCreatePlayer
        db 043h,065h,06Eh,074h,065h,072h,00h
str_Defence:                                    ; string 'Defence'; used by DrawCreatePlayer
        db 044h,065h,066h,065h,06Eh,063h,065h,00h
str_LeftWing:                                   ; string 'Left Wing'; used by DrawCreatePlayer
        db 04Ch,065h,066h,074h,020h,057h,069h,06Eh,067h,00h
str_RightWing:                                  ; string 'Right Wing'; used by DrawCreatePlayer
        db 052h,069h,067h,068h,074h,020h,057h,069h,06Eh,067h,00h
str_Goalie:                                     ; string 'Goalie'; used by DrawCreatePlayer
        db 047h,06Fh,061h,06Ch,069h,065h,00h
str_RatingUnitsAvailable3d:                     ; string 'Rating Units Available <%3d>'; used by
                                                ; DrawCreatePlayer
        db 052h,061h,074h,069h,06Eh,067h,020h,055h,06Eh,069h,074h,073h,020h,041h,076h,061h
        db 069h,06Ch,061h,062h,06Ch,065h,020h,03Ch,025h,033h,064h,03Eh,00h
str_Temp:                                       ; string 'temp'; used by CreateFreeAgent, CreatePlayerLoop
        db 074h,065h,06Dh,070h,00h
str_ErrDiskFree:                                ; string 'error getting disk space free\n' (CreateFreeAgent);
                                                ; used by CreateFreeAgent
        db 065h,072h,072h,06Fh,072h,020h,067h,065h,074h,074h,069h,06Eh,067h,020h,064h,069h
        db 073h,06Bh,020h,073h,070h,061h,063h,065h,020h,066h,072h,065h,065h,0Ah,00h
str_3dKbytesOfFree:                             ; string '%3d Kbytes of free disk space.'; used by
                                                ; CreateFreeAgent
        db 025h,033h,064h,020h,04Bh,062h,079h,074h,065h,073h,020h,06Fh,066h,020h,066h,072h
        db 065h,065h,020h,064h,069h,073h,06Bh,020h,073h,070h,061h,063h,065h,02Eh,00h
str_NotEnoughSpaceTo:                           ; string 'Not enough space to create'; used by CreateFreeAgent
        db 04Eh,06Fh,074h,020h,065h,06Eh,06Fh,075h,067h,068h,020h,073h,070h,061h,063h,065h
        db 020h,074h,06Fh,020h,063h,072h,065h,061h,074h,065h,00h
str_ANewFreeAgent:                              ; string 'a new free agent.'; used by CreateFreeAgent
        db 061h,020h,06Eh,065h,077h,020h,066h,072h,065h,065h,020h,061h,067h,065h,06Eh,074h
        db 02Eh,00h
str_EnterNewPlayerName:                         ; string 'Enter the name of the new player'; used by
                                                ; CreateFreeAgent
        db 045h,06Eh,074h,065h,072h,020h,074h,068h,065h,020h,06Eh,061h,06Dh,065h,020h,06Fh
        db 066h,020h,074h,068h,065h,020h,06Eh,065h,077h,020h,070h,06Ch,061h,079h,065h,072h
        db 00h
str_EnterNewGoalieName:                         ; string 'Enter the name of the new goalie'; used by
                                                ; CreateFreeAgent
        db 045h,06Eh,074h,065h,072h,020h,074h,068h,065h,020h,06Eh,061h,06Dh,065h,020h,06Fh
        db 066h,020h,074h,068h,065h,020h,06Eh,065h,077h,020h,067h,06Fh,061h,06Ch,069h,065h
        db 00h
str_EnterAPositionFor:                          ; string 'Enter a position for'; used by CreateFreeAgent
        db 045h,06Eh,074h,065h,072h,020h,061h,020h,070h,06Fh,073h,069h,074h,069h,06Fh,06Eh
        db 020h,066h,06Fh,072h,00h
str_LCRD:                                       ; string '(L,C,R,D)'; used by CreateFreeAgent
        db 028h,04Ch,02Ch,043h,02Ch,052h,02Ch,044h,029h,00h
str_EnterAJerseyNumber:                         ; string 'Enter a jersey number for'; used by CreateFreeAgent
        db 045h,06Eh,074h,065h,072h,020h,061h,020h,06Ah,065h,072h,073h,065h,079h,020h,06Eh
        db 075h,06Dh,062h,065h,072h,020h,066h,06Fh,072h,00h
str_NotEnoughSpaceFA:                           ; string 'There is not enough space'; used by MoveToFreeAgents
        db 054h,068h,065h,072h,065h,020h,069h,073h,020h,06Eh,06Fh,074h,020h,065h,06Eh,06Fh
        db 075h,067h,068h,020h,073h,070h,061h,063h,065h,00h
str_InTheFreeAgent:                             ; string 'in the free agent list'; used by MoveToFreeAgents
        db 069h,06Eh,020h,074h,068h,065h,020h,066h,072h,065h,065h,020h,061h,067h,065h,06Eh
        db 074h,020h,06Ch,069h,073h,074h,00h
str_ForAllSelectedPlayers:                      ; string 'for all selected players'; used by MoveToFreeAgents
        db 066h,06Fh,072h,020h,061h,06Ch,06Ch,020h,073h,065h,06Ch,065h,063h,074h,065h,064h
        db 020h,070h,06Ch,061h,079h,065h,072h,073h,00h,00h,00h,00h
str_TheNumberOfSelected:                        ; string 'The number of selected '; used by
                                                ; SwapSelectedPlayers
        db 054h,068h,065h,020h,06Eh,075h,06Dh,062h,065h,072h,020h,06Fh,066h,020h,073h,065h
        db 06Ch,065h,063h,074h,065h,064h,020h,00h
str_PlayersAndGoalies:                          ; string 'players and goalies'; used by SwapSelectedPlayers
        db 070h,06Ch,061h,079h,065h,072h,073h,020h,061h,06Eh,064h,020h,067h,06Fh,061h,06Ch
        db 069h,065h,073h,00h
str_Players:                                    ; string 'players'; used by SwapSelectedPlayers
        db 070h,06Ch,061h,079h,065h,072h,073h,00h
str_Goalies:                                    ; string 'goalies'; used by SwapSelectedPlayers
        db 067h,06Fh,061h,06Ch,069h,065h,073h,00h
str_MustBeTheSame:                              ; string 'must be the same on both teams!'; used by
                                                ; SwapSelectedPlayers
        db 06Dh,075h,073h,074h,020h,062h,065h,020h,074h,068h,065h,020h,073h,061h,06Dh,065h
        db 020h,06Fh,06Eh,020h,062h,06Fh,074h,068h,020h,074h,065h,061h,06Dh,073h,021h,00h
str_EnterNameOfPlayer:                          ; string 'Enter name of player to find:'; used by FindPlayer
        db 045h,06Eh,074h,065h,072h,020h,06Eh,061h,06Dh,065h,020h,06Fh,066h,020h,070h,06Ch
        db 061h,079h,065h,072h,020h,074h,06Fh,020h,066h,069h,06Eh,064h,03Ah,00h
str_FreeAgentList:                              ; string 'Free Agent List'; used by FindPlayer
        db 046h,072h,065h,065h,020h,041h,067h,065h,06Eh,074h,020h,04Ch,069h,073h,074h,00h
str_ChooseWhichTeamTo:                          ; string 'Choose which team to display'; used by FindPlayer
        db 043h,068h,06Fh,06Fh,073h,065h,020h,077h,068h,069h,063h,068h,020h,074h,065h,061h
        db 06Dh,020h,074h,06Fh,020h,064h,069h,073h,070h,06Ch,061h,079h,00h
str_IsAlreadyDisplayedOn:                       ; string 'is already displayed on'; used by FindPlayer
        db 069h,073h,020h,061h,06Ch,072h,065h,061h,064h,079h,020h,064h,069h,073h,070h,06Ch
        db 061h,079h,065h,064h,020h,06Fh,06Eh,00h
str_Roster2:                                    ; string 'Roster 2'; used by FindPlayer
        db 052h,06Fh,073h,074h,065h,072h,020h,032h,00h
str_Roster1:                                    ; string 'Roster 1'; used by FindPlayer
        db 052h,06Fh,073h,074h,065h,072h,020h,031h,00h
str_DoesNotExist:                               ; string 'does not exist!'; used by FindPlayer
        db 064h,06Fh,065h,073h,020h,06Eh,06Fh,074h,020h,065h,078h,069h,073h,074h,021h,00h
        db 00h,00h,00h
