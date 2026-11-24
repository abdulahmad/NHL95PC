; BSS of front/summary (src/front/summary).
bits 32
%include "hockey.inc"
section s_DD66C nobits alloc noexec write align=1
global hmcrestbmp, vscrestbmp
hmcrestbmp:                                     ; home crest bitmap (crestnames[HomeTeam]); used by
                                                ; GameSummaryScreen, GameSummaryScreen_period
        resb 4
vscrestbmp:                                     ; visitor crest bitmap; used by GameSummaryScreen,
                                                ; GameSummaryScreen_period
        resb 8
