; Initialised data of front/leaders (src/front/leaders).
bits 32
%include "hockey.inc"
section s_C6BE8 progbits alloc noexec write align=1
extern CmpAssists, CmpGAA, CmpGoalieWins, CmpGoals, CmpPIM, CmpPlusMinus, CmpPoints, CmpPPGoals
extern CmpSavePct, CmpSHGoals, CmpShootPct, str_AssistLeaders, str_AVG2, str_BlankLeaderColumn, str_GA5, str_GoalLeaders
extern str_GoalsAgainstAverageLeaders, str_GoaltenderWinLeaders, str_LSSCEDDB, str_MIN5, str_Pct6, str_PCT7, str_PenaltyMinuteLeaders, str_PIM6
extern str_PlusMinus5, str_PlusMinusLeaders, str_PointLeaders, str_PowerPlayGoalLeaders, str_PP2, str_Pt3, str_SA4, str_SavePercentageLeaders
extern str_SCHEDULEDB3, str_SHG3, str_ShootingPercentageLeaders, str_ShorthandedGoalLeaders, str_Shots5, str_spA, str_spG, str_SpL5
extern str_SpT2, str_spW2
global leadersortfns, leadertitles, leadercolhdrs, leadercolhdrs_c1, leadercolhdrs_c2, leadercolhdrs_c3, leadercolhdrs_c4, potreeround_m2
global potreeround
leadersortfns:                                  ; leader comparators by statscategory; used by LeadersScreen
        dd CmpPoints
        dd CmpGoals
        dd CmpAssists
        dd CmpPPGoals
        dd CmpSHGoals
        dd CmpPlusMinus
        dd CmpPIM
        dd CmpShootPct
        dd CmpGAA
        dd CmpGoalieWins
        dd CmpSavePct
leadertitles:                                   ; " Point Leaders" .. " Save Percentage Leaders"; used by
                                                ; LeadersScreen
        dd str_PointLeaders
        dd str_GoalLeaders
        dd str_AssistLeaders
        dd str_PowerPlayGoalLeaders
        dd str_ShorthandedGoalLeaders
        dd str_PlusMinusLeaders
        dd str_PenaltyMinuteLeaders
        dd str_ShootingPercentageLeaders
        dd str_GoalsAgainstAverageLeaders
        dd str_GoaltenderWinLeaders
        dd str_SavePercentageLeaders
leadercolhdrs:                                  ; LeadersScreen: column header strings, five per category;
                                                ; first column; used by LeadersScreen
        dd str_spG
leadercolhdrs_c1:                               ; leadercolhdrs+4: second column; used by LeadersScreen
        dd str_spA
leadercolhdrs_c2:                               ; leadercolhdrs+8: third column; used by LeadersScreen
        dd str_Pt3
leadercolhdrs_c3:                               ; leadercolhdrs+0Ch: fourth column; used by LeadersScreen
        dd str_BlankLeaderColumn
leadercolhdrs_c4:                               ; leadercolhdrs+10h: fifth column; used by LeadersScreen
        dd str_BlankLeaderColumn
        dd str_spG
        dd str_spA
        dd str_Pt3
        dd str_BlankLeaderColumn
        dd str_BlankLeaderColumn
        dd str_spG
        dd str_spA
        dd str_Pt3
        dd str_BlankLeaderColumn
        dd str_BlankLeaderColumn
        dd str_spG
        dd str_spA
        dd str_Pt3
        dd str_PP2
        dd str_BlankLeaderColumn
        dd str_spG
        dd str_spA
        dd str_Pt3
        dd str_SHG3
        dd str_BlankLeaderColumn
        dd str_spG
        dd str_spA
        dd str_Pt3
        dd str_PlusMinus5
        dd str_BlankLeaderColumn
        dd str_spG
        dd str_spA
        dd str_Pt3
        dd str_PIM6
        dd str_BlankLeaderColumn
        dd str_spG
        dd str_spA
        dd str_Pt3
        dd str_Shots5
        dd str_Pct6
        dd str_MIN5
        dd str_GA5
        dd str_AVG2
        dd str_BlankLeaderColumn
        dd str_BlankLeaderColumn
        dd str_MIN5
        dd str_spW2
        dd str_SpL5
        dd str_SpT2
        dd str_BlankLeaderColumn
        dd str_MIN5
        dd str_GA5
        dd str_SA4
        dd str_PCT7
        dd str_BlankLeaderColumn
        dd str_LSSCEDDB
potreeround_m2 equ $+2
        dd str_SCHEDULEDB3
potreeround:                                    ; PlayoffTreeMenu: the round the playoff tree shows; the tree
                                                ; is redrawn when it changes; used by PlayoffTreeMenu
        db 070h,0FFh
