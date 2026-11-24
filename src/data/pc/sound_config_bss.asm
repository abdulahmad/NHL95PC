; BSS of pc/sound_config (src/pc/sound_config).
bits 32
%include "hockey.inc"
section s_DC9DD nobits alloc noexec write align=1
global homeremap_e05, homeremap_e07, homeremap_e10, homeremap_e11, homeremap_e13, homeremap_e14, homeremap_e16, homeremap_e43
global homeremap_e49, homeremap_e50, homeremap_e51, homeremap_e60, homeremap_eC0, homeremap_eFB, homeremap_eFC, homeremap_eFD
global homeremap_eFE
homeremap_e05:                                  ; homeremap+5h: entry 5h of the home remap table; used by
                                                ; DrawLockerRoom
        resb 2
homeremap_e07:                                  ; homeremap+7h: entry 7h of the home remap table; used by
                                                ; DrawLockerRoom
        resb 9
homeremap_e10:                                  ; homeremap+10h: entry 10h of the home remap table; used by
                                                ; DrawLockerRoom
        resb 1
homeremap_e11:                                  ; homeremap+11h: entry 11h of the home remap table; used by
                                                ; DrawLockerRoom
        resb 2
homeremap_e13:                                  ; homeremap+13h: entry 13h of the home remap table; used by
                                                ; DrawLockerRoom
        resb 1
homeremap_e14:                                  ; homeremap+14h: entry 14h of the home remap table; used by
                                                ; DrawLockerRoom
        resb 2
homeremap_e16:                                  ; homeremap+16h: entry 16h of the home remap table; used by
                                                ; DrawLockerRoom
        resb 45
homeremap_e43:                                  ; homeremap+43h: entry 43h of the home remap table; used by
                                                ; DrawHudPanel
        resb 6
homeremap_e49:                                  ; homeremap+49h: entry 49h of the home remap table; used by
                                                ; DrawLockerRoom
        resb 7
homeremap_e50:                                  ; homeremap+50h: entry 50h of the home remap table; used by
                                                ; DrawLockerRoom
        resb 1
homeremap_e51:                                  ; homeremap+51h: entry 51h of the home remap table; used by
                                                ; DrawLockerRoom
        resb 15
homeremap_e60:                                  ; homeremap+60h: entry 60h of the home remap table; used by
                                                ; DrawLockerRoom
        resb 96
homeremap_eC0:                                  ; homeremap+C0h: entry C0h of the home remap table; used by
                                                ; DrawSprite
        resb 59
homeremap_eFB:                                  ; homeremap+FBh: entry FBh of the home remap table; used by
                                                ; DrawLockerRoom
        resb 1
homeremap_eFC:                                  ; homeremap+FCh: entry FCh of the home remap table; used by
                                                ; DrawLockerRoom
        resb 1
homeremap_eFD:                                  ; homeremap+FDh: entry FDh of the home remap table; used by
                                                ; DrawLockerRoom
        resb 1
homeremap_eFE:                                  ; homeremap+FEh: entry FEh of the home remap table; used by
                                                ; DrawLockerRoom
        resb 1
