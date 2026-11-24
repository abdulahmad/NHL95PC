; BSS of pc/dialogs (src/pc/dialogs).
bits 32
%include "hockey.inc"
section s_DD678 nobits alloc noexec write align=1
global dlgsavex, dlgsavey, editcurw, editpos, editmaxw, editbuf, editcuron, edity
global editx
dlgsavex:                                       ; string ''; used by RestoreDialogBg, SaveDialogBg
        resb 16
dlgsavey:                                       ; string ''; used by RestoreDialogBg, SaveDialogBg
        resb 4
editcurw:                                       ; string ''; used by DrawEditCursor, EditTextField
        resb 4
editpos:                                        ; string ''; used by DrawEditCursor, DrawEditText,
                                                ; EditTextField
        resb 4
editmaxw:                                       ; string ''; used by DrawEditText, EditTextField
        resb 4
editbuf:                                        ; string ''; used by DrawEditCursor, DrawEditText,
                                                ; EditTextField
        resb 4
editcuron:                                      ; string ''; used by DrawEditCursor, EditTextField
        resb 4
edity:                                          ; string ''; used by DrawEditCursor, DrawEditText,
                                                ; EditTextField
        resb 4
editx:                                          ; string ''; used by DrawEditCursor, DrawEditText,
                                                ; EditTextField
        resb 2
        resb 2
