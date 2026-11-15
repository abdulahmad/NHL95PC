; The penalty names shown on the game summary.
bits 32
%include "hockey.inc"
section s_CD304 progbits alloc noexec write align=1
extern PenaltyList, unk_C1B49, str_Charging, str_Slashing, str_CrossChecking, str_Hooking, str_Tripping, str_Interference
extern str_Holding, str_HighSticking, str_Boarding, str_Elbowing, str_AbuseOfOfficial, str_CheckingFromBehind, str_PenaltyShot2
global penaltynames
penaltynames:
dd PenaltyList
dd unk_C1B49
dd str_Charging
dd str_Slashing
dd PenaltyList
dd str_CrossChecking
dd str_Hooking
dd str_Tripping
dd str_Interference
dd str_Holding
dd str_HighSticking
dd str_Boarding
dd str_Elbowing
dd str_AbuseOfOfficial
dd str_CheckingFromBehind
dd str_Boarding
dd str_Elbowing
dd str_PenaltyShot2
