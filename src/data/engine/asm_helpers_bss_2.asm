; BSS of engine/asm_helpers (src/engine/asm_helpers): the module's second run in link order.
bits 32
%include "hockey.inc"
section s_EDA04 nobits alloc noexec write align=1
global vgapage
vgapage:                                        ; vgaflip toggles it 0/1 and shows page 0B00h or 4400h; used
                                                ; by AddDirtyRect, BlitClipRect, vgaflip
        resb 4
