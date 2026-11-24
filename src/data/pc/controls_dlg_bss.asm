; BSS of pc/controls_dlg (src/pc/controls_dlg).
bits 32
%include "hockey.inc"
section s_ED364 nobits alloc noexec write align=1
global ControlsDlgFlags
ControlsDlgFlags:                               ; Bit flags the controls dialog builds from its options; used
                                                ; by ControlsDlgLoop, DrawControlsOpts
        resb 4
