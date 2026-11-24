; Strings and constants of src/lib/ea/ea_window.asm, in link order.
bits 32
%include "hockey.inc"
section s_C3F74 progbits alloc noexec write align=1
global str_SUBWINDOW, str_SubwindowdefadrOUTOFROW
str_SUBWINDOW:                                  ; "SUBWINDOW" string literal; used by subwindowdefadr
        db 053h,055h,042h,057h,049h,04Eh,044h,04Fh,057h,00h,064h,020h
str_SubwindowdefadrOUTOFROW:                    ; "subwindowdefadr - OUT OF ROW SPACE\n" string literal; used
                                                ; by subwindowdefadr
        db 073h,075h,062h,077h,069h,06Eh,064h,06Fh,077h,064h,065h,066h,061h,064h,072h,020h
        db 02Dh,020h,04Fh,055h,054h,020h,04Fh,046h,020h,052h,04Fh,057h,020h,053h,050h,041h
        db 043h,045h,0Ah,00h
