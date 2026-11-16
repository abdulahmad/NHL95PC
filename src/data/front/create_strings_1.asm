; Messages from Edit Rosters and Create Player: incomplete lines, jersey conflicts, and which hand a player uses.
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
str_Prez2:
        db 070h,072h,065h,07Ah,032h,00h
str_Pal:
        db 021h,070h,061h,06Ch,00h
str_ea:
        db 065h,061h,020h,020h,00h
str_Uar:
        db 075h,061h,072h,00h
str_Uarm:
        db 075h,061h,072h,06Dh,00h
str_TheJerseyNumber2d:
        db 054h,068h,065h,020h,06Ah,065h,072h,073h,065h,079h,020h,06Eh,075h,06Dh,062h,065h
        db 072h,020h,025h,032h,064h,020h,069h,073h,020h,061h,06Ch,072h,065h,061h,064h,079h
        db 020h,075h,073h,065h,064h,021h,00h
str_PleaseEnterANew:
        db 050h,06Ch,065h,061h,073h,065h,020h,065h,06Eh,074h,065h,072h,020h,061h,020h,06Eh
        db 065h,077h,020h,06Ah,065h,072h,073h,065h,079h,020h,06Eh,075h,06Dh,062h,065h,072h
        db 020h,066h,06Fh,072h,00h
str_Menubuff:
        db 06Dh,065h,06Eh,075h,062h,075h,066h,066h,00h
str_TheDatabaseHasNot:
        db 054h,068h,065h,020h,064h,061h,074h,061h,062h,061h,073h,065h,020h,068h,061h,073h
        db 020h,06Eh,06Fh,074h,020h,062h,065h,065h,06Eh,020h,073h,061h,076h,065h,064h,02Eh
        db 00h
str_AreYouSureYou:
        db 041h,072h,065h,020h,079h,06Fh,075h,020h,073h,075h,072h,065h,020h,079h,06Fh,075h
        db 020h,077h,061h,06Eh,074h,020h,074h,06Fh,020h,065h,078h,069h,074h,03Fh,00h,00h
        db 00h
str_GP9:
        db 047h,050h,00h
str_spG2:
        db 020h,020h,047h,00h
str_spA2:
        db 020h,020h,041h,00h
str_Pt4:
        db 020h,050h,074h,00h
str_PIM7:
        db 050h,049h,04Dh,00h
str_PlusMinus6:
        db 020h,02Bh,02Fh,02Dh,00h
str_PPG4:
        db 050h,050h,047h,00h
str_SHG4:
        db 053h,048h,047h,00h
str_Shots6:
        db 053h,068h,06Fh,074h,073h,00h
str_Pct8:
        db 020h,020h,050h,063h,074h,00h
str_Shoots3:
        db 053h,068h,06Fh,06Fh,074h,073h,00h
str_Speed3:
        db 053h,070h,065h,065h,064h,00h
str_Agility3:
        db 041h,067h,069h,06Ch,069h,074h,079h,00h
str_Weight3:
        db 057h,065h,069h,067h,068h,074h,00h
str_ShotPower2:
        db 053h,068h,06Fh,074h,020h,050h,06Fh,077h,065h,072h,00h
str_Checking3:
        db 043h,068h,065h,063h,06Bh,069h,06Eh,067h,00h
str_StickHandling2:
        db 053h,074h,069h,063h,06Bh,048h,061h,06Eh,064h,06Ch,069h,06Eh,067h,00h
str_Accuracy2:
        db 041h,063h,063h,075h,072h,061h,063h,079h,00h
str_Passing3:
        db 050h,061h,073h,073h,069h,06Eh,067h,00h
str_OffensiveAwareness3:
        db 04Fh,066h,066h,065h,06Eh,073h,069h,076h,065h,020h,041h,077h,061h,072h,065h,06Eh
        db 065h,073h,073h,00h
str_DefensiveAwareness3:
        db 044h,065h,066h,065h,06Eh,073h,069h,076h,065h,020h,041h,077h,061h,072h,065h,06Eh
        db 065h,073h,073h,00h
str_Aggressiveness2:
        db 041h,067h,067h,072h,065h,073h,073h,069h,076h,065h,06Eh,065h,073h,073h,00h
str_Endurance2:
        db 045h,06Eh,064h,075h,072h,061h,06Eh,063h,065h,00h
str_ShootPassBias2:
        db 053h,068h,06Fh,06Fh,074h,02Fh,050h,061h,073h,073h,020h,042h,069h,061h,073h,00h
str_Faceoffs2:
        db 046h,061h,063h,065h,06Fh,066h,066h,073h,00h
str_Min6:
        db 020h,04Dh,069h,06Eh,00h
str_GA6:
        db 020h,020h,047h,041h,00h
str_GAA5:
        db 020h,020h,047h,041h,041h,00h
str_spW3:
        db 020h,057h,00h
str_SpL6:
        db 020h,04Ch,00h
str_SpT3:
        db 020h,054h,00h
str_SO3:
        db 053h,04Fh,00h
str_EN3:
        db 045h,04Eh,00h
str_SA5:
        db 020h,020h,020h,053h,041h,00h
str_GloveHand3:
        db 047h,06Ch,06Fh,076h,065h,020h,048h,061h,06Eh,064h,00h
str_GloveLeft2:
        db 047h,06Ch,06Fh,076h,065h,020h,04Ch,065h,066h,074h,00h
str_GloveRight2:
        db 047h,06Ch,06Fh,076h,065h,020h,052h,069h,067h,068h,074h,00h
str_StickLeft2:
        db 053h,074h,069h,063h,06Bh,020h,04Ch,065h,066h,074h,00h
str_StickRight2:
        db 053h,074h,069h,063h,06Bh,020h,052h,069h,067h,068h,074h,00h
str_PuckControl2:
        db 050h,075h,063h,06Bh,020h,043h,06Fh,06Eh,074h,072h,06Fh,06Ch,00h
str_PenaltyKilling3:
        db 050h,065h,06Eh,061h,06Ch,074h,079h,020h,04Bh,069h,06Ch,06Ch,069h,06Eh,067h,00h
str_PowerPlay3:
        db 050h,06Fh,077h,065h,072h,020h,050h,06Ch,061h,079h,00h
str_Shooting2:
        db 053h,068h,06Fh,06Fh,074h,069h,06Eh,067h,00h
str_Skating2:
        db 053h,06Bh,061h,074h,069h,06Eh,067h,00h
str_Defence2:
        db 044h,065h,066h,065h,06Eh,063h,065h,00h
str_Goaltending2:
        db 047h,06Fh,061h,06Ch,074h,065h,06Eh,064h,069h,06Eh,067h,00h
str_OverAll2:
        db 04Fh,076h,065h,072h,020h,061h,06Ch,06Ch,00h
str_Cancel6:
        db 043h,061h,06Eh,063h,065h,06Ch,00h
str_Create:
        db 043h,072h,065h,061h,074h,065h,00h
str_X:
        db 058h,00h,00h,00h,00h
str_ErrorsFoundInDatabases:
        db 045h,072h,072h,06Fh,072h,073h,020h,066h,06Fh,075h,06Eh,064h,020h,069h,06Eh,020h
        db 064h,061h,074h,061h,062h,061h,073h,065h,073h,021h,00h
str_TheForwardLinesAre:
        db 054h,068h,065h,020h,066h,06Fh,072h,077h,061h,072h,064h,020h,06Ch,069h,06Eh,065h
        db 073h,020h,061h,072h,065h,020h,06Eh,06Fh,074h,020h,063h,06Fh,06Dh,070h,06Ch,065h
        db 074h,065h,020h,06Fh,06Eh,020h,00h
str_TheDefenceLinesAre:
        db 054h,068h,065h,020h,064h,065h,066h,065h,06Eh,063h,065h,020h,06Ch,069h,06Eh,065h
        db 073h,020h,061h,072h,065h,020h,06Eh,06Fh,074h,020h,063h,06Fh,06Dh,070h,06Ch,065h
        db 074h,065h,020h,06Fh,06Eh,020h,00h
str_ThePowerPlayLines:
        db 054h,068h,065h,020h,070h,06Fh,077h,065h,072h,020h,070h,06Ch,061h,079h,020h,06Ch
        db 069h,06Eh,065h,073h,020h,061h,072h,065h,020h,06Eh,06Fh,074h,020h,063h,06Fh,06Dh
        db 070h,06Ch,065h,074h,065h,020h,06Fh,06Eh,020h,00h
str_ThePenaltyKillingLines:
        db 054h,068h,065h,020h,070h,065h,06Eh,061h,06Ch,074h,079h,020h,06Bh,069h,06Ch,06Ch
        db 069h,06Eh,067h,020h,06Ch,069h,06Eh,065h,073h,020h,061h,072h,065h,020h,06Eh,06Fh
        db 074h,020h,063h,06Fh,06Dh,070h,06Ch,065h,074h,065h,020h,06Fh,06Eh,020h,00h
str_TheGoalieLinesAre:
        db 054h,068h,065h,020h,067h,06Fh,061h,06Ch,069h,065h,020h,06Ch,069h,06Eh,065h,073h
        db 020h,061h,072h,065h,020h,06Eh,06Fh,074h,020h,063h,06Fh,06Dh,070h,06Ch,065h,074h
        db 065h,020h,06Fh,06Eh,020h,00h
str_TheExtraAttackerLines:
        db 054h,068h,065h,020h,065h,078h,074h,072h,061h,020h,061h,074h,074h,061h,063h,06Bh
        db 065h,072h,020h,06Ch,069h,06Eh,065h,073h,020h,061h,072h,065h,020h,06Eh,06Fh,074h
        db 020h,063h,06Fh,06Dh,070h,06Ch,065h,074h,065h,020h,06Fh,06Eh,020h,00h
str_NotEnoughPlayers:
        db 054h,068h,065h,072h,065h,020h,061h,072h,065h,020h,06Eh,06Fh,074h,020h,065h,06Eh
        db 06Fh,075h,067h,068h,020h,070h,06Ch,061h,079h,065h,072h,073h,020h,06Fh,06Eh,020h
        db 00h
str_NotEnoughGoalies:
        db 054h,068h,065h,072h,065h,020h,061h,072h,065h,020h,06Eh,06Fh,074h,020h,065h,06Eh
        db 06Fh,075h,067h,068h,020h,067h,06Fh,061h,06Ch,069h,065h,073h,020h,06Fh,06Eh,020h
        db 00h
str_NotEnoughForwards:
        db 054h,068h,065h,072h,065h,020h,061h,072h,065h,020h,06Eh,06Fh,074h,020h,065h,06Eh
        db 06Fh,075h,067h,068h,020h,066h,06Fh,072h,077h,061h,072h,064h,073h,020h,06Fh,06Eh
        db 020h,00h
str_NotEnoughDefence:
        db 054h,068h,065h,072h,065h,020h,061h,072h,065h,020h,06Eh,06Fh,074h,020h,065h,06Eh
        db 06Fh,075h,067h,068h,020h,064h,065h,066h,065h,06Eh,063h,065h,020h,06Fh,06Eh,020h
        db 00h,00h
fp_1000:
        db 00h,00h,07Ah,044h
fp_84:
        db 00h,00h,0A8h,042h
fp_300:
        db 00h,00h,096h,043h
fp_390:
        db 00h,00h,0C3h,043h
fp_200:
        db 00h,00h,048h,043h
fp_100:
        db 00h,00h,0C8h,042h
fp_m50:
        db 00h,00h,048h,0C2h
fp_500:
        db 00h,00h,0FAh,043h
fp_90:
        db 00h,00h,0B4h,042h
fp_10:
        db 00h,00h,020h,041h
fp_70:
        db 00h,00h,08Ch,042h
fp_30:
        db 00h,00h,0F0h,041h
fp_58:
        db 00h,00h,068h,042h
F64_RatingNinety:
        db 0CDh,0CCh,0CCh,0CCh,0CCh,0CCh,0ECh,03Fh
F64_RatingTenth:
        db 09Ah,099h,099h,099h,099h,099h,0B9h,03Fh
fp_347:
        db 00h,080h,0ADh,043h
str_Shoots:
        db 053h,068h,06Fh,06Fh,074h,073h,00h
str_spL:
        db 020h,020h,04Ch,00h
str_spR:
        db 020h,020h,052h,00h
str_GloveHand:
        db 047h,06Ch,06Fh,076h,065h,020h,048h,061h,06Eh,064h,00h
str_L9:
        db 04Ch,00h
str_R5:
        db 052h,00h
str_EnterANewRating:
        db 045h,06Eh,074h,065h,072h,020h,061h,020h,06Eh,065h,077h,020h,072h,061h,074h,069h
        db 06Eh,067h,03Ah,00h
str_RatingRange:
        db 025h,032h,064h,020h,03Ch,020h,025h,073h,020h,03Ch,020h,025h,032h,064h,00h
str_ShootsLeftOrRight:
        db 053h,068h,06Fh,06Fh,074h,073h,020h,04Ch,065h,066h,074h,020h,06Fh,072h,020h,052h
        db 069h,067h,068h,074h,03Fh,00h
str_NotEnoughRatingUnits:
        db 04Eh,06Fh,074h,020h,065h,06Eh,06Fh,075h,067h,068h,020h,052h,061h,074h,069h,06Eh
        db 067h,020h,055h,06Eh,069h,074h,073h,00h
str_GloveHandLeftOr:
        db 047h,06Ch,06Fh,076h,065h,020h,068h,061h,06Eh,064h,020h,04Ch,065h,066h,074h,020h
        db 06Fh,072h,020h,052h,069h,067h,068h,074h,03Fh,00h
str_Prez22:
        db 070h,072h,065h,07Ah,032h,00h
str_Pal2:
        db 021h,070h,061h,06Ch,00h
str_ea2:
        db 065h,061h,020h,020h,00h
str_Pstatbar:
        db 070h,073h,074h,061h,074h,062h,061h,072h,00h
str_Pst2:
        db 070h,073h,074h,032h,00h
str_FreeAgent:
        db 046h,072h,065h,065h,020h,041h,067h,065h,06Eh,074h,00h
str_fmtSS:
        db 025h,073h,020h,025h,073h,00h
str_fmtD:
        db 025h,064h,020h,00h
str_Center:
        db 043h,065h,06Eh,074h,065h,072h,00h
str_Defence:
        db 044h,065h,066h,065h,06Eh,063h,065h,00h
str_LeftWing:
        db 04Ch,065h,066h,074h,020h,057h,069h,06Eh,067h,00h
str_RightWing:
        db 052h,069h,067h,068h,074h,020h,057h,069h,06Eh,067h,00h
str_Goalie:
        db 047h,06Fh,061h,06Ch,069h,065h,00h
str_RatingUnitsAvailable3d:
        db 052h,061h,074h,069h,06Eh,067h,020h,055h,06Eh,069h,074h,073h,020h,041h,076h,061h
        db 069h,06Ch,061h,062h,06Ch,065h,020h,03Ch,025h,033h,064h,03Eh,00h
str_Temp:
        db 074h,065h,06Dh,070h,00h
str_ErrDiskFree:
        db 065h,072h,072h,06Fh,072h,020h,067h,065h,074h,074h,069h,06Eh,067h,020h,064h,069h
        db 073h,06Bh,020h,073h,070h,061h,063h,065h,020h,066h,072h,065h,065h,0Ah,00h
str_3dKbytesOfFree:
        db 025h,033h,064h,020h,04Bh,062h,079h,074h,065h,073h,020h,06Fh,066h,020h,066h,072h
        db 065h,065h,020h,064h,069h,073h,06Bh,020h,073h,070h,061h,063h,065h,02Eh,00h
str_NotEnoughSpaceTo:
        db 04Eh,06Fh,074h,020h,065h,06Eh,06Fh,075h,067h,068h,020h,073h,070h,061h,063h,065h
        db 020h,074h,06Fh,020h,063h,072h,065h,061h,074h,065h,00h
str_ANewFreeAgent:
        db 061h,020h,06Eh,065h,077h,020h,066h,072h,065h,065h,020h,061h,067h,065h,06Eh,074h
        db 02Eh,00h
str_EnterNewPlayerName:
        db 045h,06Eh,074h,065h,072h,020h,074h,068h,065h,020h,06Eh,061h,06Dh,065h,020h,06Fh
        db 066h,020h,074h,068h,065h,020h,06Eh,065h,077h,020h,070h,06Ch,061h,079h,065h,072h
        db 00h
str_EnterNewGoalieName:
        db 045h,06Eh,074h,065h,072h,020h,074h,068h,065h,020h,06Eh,061h,06Dh,065h,020h,06Fh
        db 066h,020h,074h,068h,065h,020h,06Eh,065h,077h,020h,067h,06Fh,061h,06Ch,069h,065h
        db 00h
str_EnterAPositionFor:
        db 045h,06Eh,074h,065h,072h,020h,061h,020h,070h,06Fh,073h,069h,074h,069h,06Fh,06Eh
        db 020h,066h,06Fh,072h,00h
str_LCRD:
        db 028h,04Ch,02Ch,043h,02Ch,052h,02Ch,044h,029h,00h
str_EnterAJerseyNumber:
        db 045h,06Eh,074h,065h,072h,020h,061h,020h,06Ah,065h,072h,073h,065h,079h,020h,06Eh
        db 075h,06Dh,062h,065h,072h,020h,066h,06Fh,072h,00h
str_NotEnoughSpaceFA:
        db 054h,068h,065h,072h,065h,020h,069h,073h,020h,06Eh,06Fh,074h,020h,065h,06Eh,06Fh
        db 075h,067h,068h,020h,073h,070h,061h,063h,065h,00h
str_InTheFreeAgent:
        db 069h,06Eh,020h,074h,068h,065h,020h,066h,072h,065h,065h,020h,061h,067h,065h,06Eh
        db 074h,020h,06Ch,069h,073h,074h,00h
str_ForAllSelectedPlayers:
        db 066h,06Fh,072h,020h,061h,06Ch,06Ch,020h,073h,065h,06Ch,065h,063h,074h,065h,064h
        db 020h,070h,06Ch,061h,079h,065h,072h,073h,00h,00h,00h,00h
str_TheNumberOfSelected:
        db 054h,068h,065h,020h,06Eh,075h,06Dh,062h,065h,072h,020h,06Fh,066h,020h,073h,065h
        db 06Ch,065h,063h,074h,065h,064h,020h,00h
str_PlayersAndGoalies:
        db 070h,06Ch,061h,079h,065h,072h,073h,020h,061h,06Eh,064h,020h,067h,06Fh,061h,06Ch
        db 069h,065h,073h,00h
str_Players:
        db 070h,06Ch,061h,079h,065h,072h,073h,00h
str_Goalies:
        db 067h,06Fh,061h,06Ch,069h,065h,073h,00h
str_MustBeTheSame:
        db 06Dh,075h,073h,074h,020h,062h,065h,020h,074h,068h,065h,020h,073h,061h,06Dh,065h
        db 020h,06Fh,06Eh,020h,062h,06Fh,074h,068h,020h,074h,065h,061h,06Dh,073h,021h,00h
str_EnterNameOfPlayer:
        db 045h,06Eh,074h,065h,072h,020h,06Eh,061h,06Dh,065h,020h,06Fh,066h,020h,070h,06Ch
        db 061h,079h,065h,072h,020h,074h,06Fh,020h,066h,069h,06Eh,064h,03Ah,00h
str_FreeAgentList:
        db 046h,072h,065h,065h,020h,041h,067h,065h,06Eh,074h,020h,04Ch,069h,073h,074h,00h
str_ChooseWhichTeamTo:
        db 043h,068h,06Fh,06Fh,073h,065h,020h,077h,068h,069h,063h,068h,020h,074h,065h,061h
        db 06Dh,020h,074h,06Fh,020h,064h,069h,073h,070h,06Ch,061h,079h,00h
str_IsAlreadyDisplayedOn:
        db 069h,073h,020h,061h,06Ch,072h,065h,061h,064h,079h,020h,064h,069h,073h,070h,06Ch
        db 061h,079h,065h,064h,020h,06Fh,06Eh,00h
str_Roster2:
        db 052h,06Fh,073h,074h,065h,072h,020h,032h,00h
str_Roster1:
        db 052h,06Fh,073h,074h,065h,072h,020h,031h,00h
str_DoesNotExist:
        db 064h,06Fh,065h,073h,020h,06Eh,06Fh,074h,020h,065h,078h,069h,073h,074h,021h,00h
        db 00h,00h,00h
