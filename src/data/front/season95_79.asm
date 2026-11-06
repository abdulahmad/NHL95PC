; The playoff tree, and which team won the cup.
bits 32
%include "hockey.inc"
section s_DC7BC nobits alloc noexec write align=1
global playofftree_p1, pochampion
playofftree_p1:
resb 116
pochampion:
resb 4
