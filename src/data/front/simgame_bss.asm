; BSS of front/simgame (src/front/simgame).
bits 32
%include "hockey.inc"
section s_DE26C nobits alloc noexec write align=1
global loadpals, palcyclelock, palcyclephase, palcycledelay
loadpals:                                       ; [3][300h] rotated loading-screen palettes; used by
                                                ; FadeOutPalCycle, LoadScreenPalTick, ShowLoadingScreen
        resb 2304
palcyclelock:                                   ; 1 while the palette cycle is busy / disabled; used by
                                                ; FadeOutPalCycle, LoadScreenPalTick, ShowLoadingScreen
        resb 4
palcyclephase:                                  ; current palette 0..2; used by LoadScreenPalTick,
                                                ; ShowLoadingScreen
        resb 1
palcycledelay:                                  ; ticks until the next palette step (reload 3); used by
                                                ; LoadScreenPalTick, ShowLoadingScreen
        resb 3
