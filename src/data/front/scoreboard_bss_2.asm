; BSS of front/scoreboard (src/front/scoreboard): the module's second run in link order.
bits 32
%include "hockey.inc"
section s_DCAD7 nobits alloc noexec write align=1
global homeremap_eFF
homeremap_eFF:                                  ; homeremap+FFh: entry FFh of the home remap table; used by
                                                ; DrawHudPanel
        resb 1281
