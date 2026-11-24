; Strings and constants of src/lib/ea/ea_mcga_window.asm, in link order.
bits 32
%include "hockey.inc"
section s_C4888 progbits alloc noexec write align=1
global str_MCGAWINDOW, str_WindowdefOUTOFMEMORY, str_WindowdefBADBLOCK, str_WindowdefadrOUTOFROW
str_MCGAWINDOW:                                 ; "MCGA WINDOW" string literal; used by CreateMcgaWindow
        db 04Dh,043h,047h,041h,020h,057h,049h,04Eh,044h,04Fh,057h,00h
str_WindowdefOUTOFMEMORY:                       ; "windowdef - OUT OF MEMORY\n" string literal; used by
                                                ; CreateMcgaWindow
        db 077h,069h,06Eh,064h,06Fh,077h,064h,065h,066h,020h,02Dh,020h,04Fh,055h,054h,020h
        db 04Fh,046h,020h,04Dh,045h,04Dh,04Fh,052h,059h,0Ah,00h,05Fh
str_WindowdefBADBLOCK:                          ; "windowdef - BAD BLOCK\n" string literal; used by
                                                ; CreateMcgaWindow
        db 077h,069h,06Eh,064h,06Fh,077h,064h,065h,066h,020h,02Dh,020h,042h,041h,044h,020h
        db 042h,04Ch,04Fh,043h,04Bh,0Ah,00h,067h
str_WindowdefadrOUTOFROW:                       ; "windowdefadr - OUT OF ROW SPACE\nrequested: %dx%d\n" string
                                                ; literal; used by CreateMcgaWindow
        db 077h,069h,06Eh,064h,06Fh,077h,064h,065h,066h,061h,064h,072h,020h,02Dh,020h,04Fh
        db 055h,054h,020h,04Fh,046h,020h,052h,04Fh,057h,020h,053h,050h,041h,043h,045h,0Ah
        db 072h,065h,071h,075h,065h,073h,074h,065h,064h,03Ah,020h,025h,064h,078h,025h,064h
        db 0Ah,00h,00h,00h
