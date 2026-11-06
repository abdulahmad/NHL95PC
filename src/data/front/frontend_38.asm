; The penalty names shown on the game summary.
bits 32
%include "hockey.inc"
section s_CD304 progbits alloc noexec write align=1
extern PenaltyList, unk_C1B49, unk_C1B4A, unk_C1B53, unk_C1B5C, unk_C1B6A, unk_C1B72, unk_C1B7B
extern unk_C1B88, unk_C1B90, unk_C1B9D, unk_C1BA6, unk_C1BAF, unk_C1BC1, unk_C1BD6
global penaltynames
penaltynames:
dd PenaltyList
dd unk_C1B49
dd unk_C1B4A
dd unk_C1B53
dd PenaltyList
dd unk_C1B5C
dd unk_C1B6A
dd unk_C1B72
dd unk_C1B7B
dd unk_C1B88
dd unk_C1B90
dd unk_C1B9D
dd unk_C1BA6
dd unk_C1BAF
dd unk_C1BC1
dd unk_C1B9D
dd unk_C1BA6
dd unk_C1BD6
