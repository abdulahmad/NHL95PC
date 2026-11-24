; BSS of engine/asm_helpers (src/engine/asm_helpers).
bits 32
%include "hockey.inc"
section s_DD70C nobits alloc noexec write align=1
global bgscrolly8
bgscrolly8:                                     ; background top row in 8-line units in the circular VRAM
                                                ; background buffer (vgacopy_bg, vgacopy_bgfull: *8 rows /
                                                ; *300h bytes); used by vgacopy_bg, vgacopy_bgfull
        resb 4
