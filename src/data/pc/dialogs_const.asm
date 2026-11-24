; Strings and constants of pc/dialogs (src/pc/dialogs), in link order.
bits 32
%include "hockey.inc"
section s_C1710 progbits alloc noexec write align=1
global str_Pointer6, str_DBOX, str_Dot, str_Space
str_Pointer6:                                   ; string 'Pointer'; used by ListDialog, RunMessageBox
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h
str_DBOX:                                       ; string 'DBOX'; used by SaveDialogBg
        db 044h,042h,04Fh,058h,00h,00h,00h,00h
str_Dot:                                        ; string '.'; used by DrawEditCursor, DrawEditText
        db 02Eh,00h
str_Space:                                      ; string ' '; used by DrawEditCursor
        db 020h,00h
