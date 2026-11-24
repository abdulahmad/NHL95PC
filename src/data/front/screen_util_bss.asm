; BSS of front/screen_util (src/front/screen_util).
bits 32
%include "hockey.inc"
section s_DC8D0 nobits alloc noexec write align=1
global dirtyrectptr, awayremap, awayremap_e43, awayremap_eC0, awayremap_eFF, homeremap
dirtyrectptr:                                   ; per-page rect list ptr (AddDirtyRect); used by AddDirtyRect
        resb 8
awayremap:                                      ; 256-byte colour remap table of the visiting team
                                                ; (LoadTeamPalette builds it from AWAYPALS.BIN, DrawSprite
                                                ; loads it); used by DrawHudPanel, DrawSprite, DrawTradeScreen
                                                ; ...
        resb 67
awayremap_e43:                                  ; awayremap+43h: entry 43h of the visitors' remap table; used
                                                ; by DrawHudPanel
        resb 125
awayremap_eC0:                                  ; awayremap+C0h: entry C0h of the visitors' remap table; used
                                                ; by DrawSprite
        resb 63
awayremap_eFF:                                  ; awayremap+FFh: entry FFh of the visitors' remap table; used
                                                ; by DrawHudPanel
        resb 1
homeremap:                                      ; 256-byte colour remap table of the home team
                                                ; (LoadTeamPalette builds it from HOMEPALS.BIN); used by
                                                ; DrawHudPanel, DrawLockerRoom, DrawSprite ...
        resb 5
