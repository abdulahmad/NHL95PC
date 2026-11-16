; The playoff tree, and which team won the cup.
bits 32
%include "hockey.inc"
section s_DC7BC nobits alloc noexec write align=1
global playofftree_p1, pochampion
playofftree_p1:                                 ; playofftree+4 (second team of each pair; separate data file
                                                ; so not folded); used by LoadLeagueTree, POAfterGame,
                                                ; POHandleElimination ...
        resb 116
pochampion:                                     ; playoff tree slot 30: SeriesWinner of the final (1Ah until
                                                ; decided); used by LoadLeagueTree, LoadPlayoffModeTree,
                                                ; POAfterGame ...
        resb 4
