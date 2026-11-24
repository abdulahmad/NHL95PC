; Strings and constants of front/create (src/front/create), in link order.
bits 32
%include "hockey.inc"
section s_C2CAC progbits alloc noexec write align=1
global fp_1000, fp_84, fp_300, fp_390, fp_200, fp_100, fp_m50, fp_500
global fp_90, fp_10, fp_70, fp_30, fp_58, F64_RatingNinety, F64_RatingTenth, fp_347
global str_Shoots, str_spL, str_spR, str_GloveHand, str_L9, str_R5, str_EnterANewRating, str_RatingRange
global str_ShootsLeftOrRight, str_NotEnoughRatingUnits, str_GloveHandLeftOr, str_Prez22, str_Pal2, str_ea2, str_Pstatbar, str_Pst2
global str_FreeAgent, str_fmtSS, str_fmtD, str_Center, str_Defence, str_LeftWing, str_RightWing, str_Goalie
global str_RatingUnitsAvailable3d, str_Temp, str_ErrDiskFree, str_3dKbytesOfFree, str_NotEnoughSpaceTo, str_ANewFreeAgent, str_EnterNewPlayerName, str_EnterNewGoalieName
global str_EnterAPositionFor, str_LCRD, str_EnterAJerseyNumber
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
