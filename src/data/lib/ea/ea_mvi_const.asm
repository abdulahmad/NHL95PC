; Strings and constants of src/lib/ea/ea_mvi.asm, in link order.
bits 32
%include "hockey.inc"
section s_C4730 progbits alloc noexec write align=1
global str_FrameRate3dFrames, str_Width3dHeight3d, str_Colours3d1stColour, str_Mvipal, str_DATABUFFER
str_FrameRate3dFrames:                          ; "Frame Rate: %3d Frames: %3d Block Size: %3d\n" string
                                                ; literal; used by MviPrintInfo
        db 046h,072h,061h,06Dh,065h,020h,052h,061h,074h,065h,03Ah,020h,025h,033h,064h,020h
        db 046h,072h,061h,06Dh,065h,073h,03Ah,020h,025h,033h,064h,020h,042h,06Ch,06Fh,063h
        db 06Bh,020h,053h,069h,07Ah,065h,03Ah,020h,025h,033h,064h,0Ah,00h,06Dh,065h,02Ch
str_Width3dHeight3d:                            ; "Width: %3d Height: %3d\n" string literal; used by
                                                ; MviPrintInfo
        db 057h,069h,064h,074h,068h,03Ah,020h,025h,033h,064h,020h,020h,020h,020h,020h,020h
        db 048h,065h,069h,067h,068h,074h,03Ah,020h,025h,033h,064h,0Ah,00h,063h,064h,065h
str_Colours3d1stColour:                         ; "Colours: %3d 1st Colour: %3d\n" string literal; used by
                                                ; MviPrintInfo
        db 043h,06Fh,06Ch,06Fh,075h,072h,073h,03Ah,020h,025h,033h,064h,020h,020h,020h,020h
        db 031h,073h,074h,020h,043h,06Fh,06Ch,06Fh,075h,072h,03Ah,020h,025h,033h,064h,0Ah
        db 00h,066h,069h,072h
str_Mvipal:                                     ; "mvipal" string literal; used by MviLoadPalette
        db 06Dh,076h,069h,070h,061h,06Ch,00h,020h
str_DATABUFFER:                                 ; "DATABUFFER" string literal; used by MviOpen
        db 044h,041h,054h,041h,042h,055h,046h,046h,045h,052h,00h,00h
