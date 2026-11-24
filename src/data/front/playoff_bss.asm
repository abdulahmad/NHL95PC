; BSS of front/playoff (src/front/playoff).
bits 32
%include "hockey.inc"
section s_DD120 nobits alloc noexec write align=1
global statspal
statspal:                                       ; saved 300h palette; used by DrawPhotoWithPal,
                                                ; EasnStandingsMenu_player2, GameSkaterStatsScreen ...
        resb 4
