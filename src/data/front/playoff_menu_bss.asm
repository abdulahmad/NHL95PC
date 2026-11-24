; BSS of front/playoff_menu (src/front/playoff_menu).
bits 32
%include "hockey.inc"
section s_DC7B8 nobits alloc noexec write align=1
global playofftree, playofftree_p1, pochampion
playofftree:                                    ; playoff tree slots: 16 round-1, 8 round-2, 4
                                                ; conference-final, 2 final team numbers (1Ah = empty) shown
                                                ; by DrawPlayoffTree; used by CalStandingsMenu,
                                                ; CalStandingsMenu_player2, DrawPlayoffTree ...
        resb 4
playofftree_p1:                                 ; playofftree+4 (second team of each pair; separate data file
                                                ; so not folded); used by LoadLeagueTree, POAfterGame,
                                                ; POHandleElimination ...
        resb 116
pochampion:                                     ; playoff tree slot 30: SeriesWinner of the final (1Ah until
                                                ; decided); used by LoadLeagueTree, LoadPlayoffModeTree,
                                                ; POAfterGame ...
        resb 4
