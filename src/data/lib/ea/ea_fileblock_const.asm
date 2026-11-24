; Strings and constants of src/lib/ea/ea_fileblock.asm, in link order.
bits 32
%include "hockey.inc"
section s_C3FD8 progbits alloc noexec write align=1
global str_SavefileblockaOPENFAILEDFOR, str_Jan, str_Feb2, str_Mar, str_Apr, str_May2, str_Jun, str_Jul
global str_Aug, str_Sep, str_Oct, str_Nov, str_Dec
str_SavefileblockaOPENFAILEDFOR:                ; "savefileblocka - OPEN FAILED FOR FILE <%s>\n" string
                                                ; literal; used by savefileblocka
        db 073h,061h,076h,065h,066h,069h,06Ch,065h,062h,06Ch,06Fh,063h,06Bh,061h,020h,02Dh
        db 020h,04Fh,050h,045h,04Eh,020h,046h,041h,049h,04Ch,045h,044h,020h,046h,04Fh,052h
        db 020h,046h,049h,04Ch,045h,020h,03Ch,025h,073h,03Eh,0Ah,00h
str_Jan:                                        ; "Jan" string literal
        db 04Ah,061h,06Eh,00h
str_Feb2:                                       ; "Feb" string literal
        db 046h,065h,062h,00h
str_Mar:                                        ; "Mar" string literal
        db 04Dh,061h,072h,00h
str_Apr:                                        ; "Apr" string literal
        db 041h,070h,072h,00h
str_May2:                                       ; "May" string literal
        db 04Dh,061h,079h,00h
str_Jun:                                        ; "Jun" string literal
        db 04Ah,075h,06Eh,00h
str_Jul:                                        ; "Jul" string literal
        db 04Ah,075h,06Ch,00h
str_Aug:                                        ; "Aug" string literal
        db 041h,075h,067h,00h
str_Sep:                                        ; "Sep" string literal
        db 053h,065h,070h,00h
str_Oct:                                        ; "Oct" string literal
        db 04Fh,063h,074h,00h
str_Nov:                                        ; "Nov" string literal
        db 04Eh,06Fh,076h,00h
str_Dec:                                        ; "Dec" string literal
        db 044h,065h,063h,00h
