; Strings and constants of src/lib/ea/ea_shapes.asm, in link order.
bits 32
%include "hockey.inc"
section s_C481C progbits alloc noexec write align=1
global str_RemovewindowROWSPACE, str_FshVshQfsQvs, str_Vsh, str_Qvs, str_EACSNDFLIBJul28
str_RemovewindowROWSPACE:                       ; "removewindow - ROW SPACE CORRUPTED\n" string literal; used
                                                ; by removewindow
        db 072h,065h,06Dh,06Fh,076h,065h,077h,069h,06Eh,064h,06Fh,077h,020h,02Dh,020h,052h
        db 04Fh,057h,020h,053h,050h,041h,043h,045h,020h,043h,04Fh,052h,052h,055h,050h,054h
        db 045h,044h,0Ah,00h
str_FshVshQfsQvs:                               ; ".fsh.vsh.qfs.qvs" string literal; used by LoadFileCached
        db 02Eh,066h,073h,068h,02Eh,076h,073h,068h,02Eh,071h,066h,073h,02Eh,071h,076h,073h
        db 00h,072h,020h,02Ah
str_Vsh:                                        ; ".vsh" string literal; used by LoadFileCached
        db 02Eh,076h,073h,068h,00h,020h,020h,063h
str_Qvs:                                        ; ".qvs" string literal; used by LoadFileCached
        db 02Eh,071h,076h,073h,00h,00h,00h,00h
str_EACSNDFLIBJul28:                            ; "EACSNDF.LIB Jul 28 1994 11:01:25" string literal
        db 045h,041h,043h,053h,04Eh,044h,046h,02Eh,04Ch,049h,042h,020h,04Ah,075h,06Ch,020h
        db 032h,038h,020h,031h,039h,039h,034h,020h,031h,031h,03Ah,030h,031h,03Ah,032h,035h
        db 00h,00h,00h,00h
