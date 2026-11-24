; BSS of front/menu (src/front/menu).
bits 32
%include "hockey.inc"
section s_DCFD8 nobits alloc noexec write align=1
global menuremap, menuremap2, printfbuf
menuremap:                                      ; remap table; used by InitMenuRemap
        resb 128
menuremap2:                                     ; second half/remap table written in identity mode; used by
                                                ; InitMenuRemap
        resb 128
printfbuf:                                      ; sprintf scratch for screen text; used by GoalieStatsCard,
                                                ; LeadersScreen, SkaterStatsCard ...
        resb 40
