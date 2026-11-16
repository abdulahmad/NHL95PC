; Watcom runtime constants.
bits 32
%include "hockey.inc"
section s_C4AB4 progbits alloc noexec write align=1
global str_Bat, str_Com, str_Exe, str_COMSPEC, str_CMD, str_COMMAND, str_FloatingPointSupportNot, str_NotEnoughMemoryTo
global str_RATIONALDOS4G, str_GF1PATCH110, str_110, str_Inf, str_Nan, F64_neg1_floor_, str_DotBackslash
global str_ULTRASND
str_DotBackslash:
        db 02Eh,05Ch,00h
str_Bat:
        db 02Eh,062h,061h,074h,00h
str_Com:
        db 02Eh,063h,06Fh,06Dh,00h
str_Exe:
        db 02Eh,065h,078h,065h,00h
str_COMSPEC:
        db 043h,04Fh,04Dh,053h,050h,045h,043h,00h
str_CMD:
        db 043h,04Dh,044h,00h
str_COMMAND:
        db 043h,04Fh,04Dh,04Dh,041h,04Eh,044h,00h,00h,00h
str_FloatingPointSupportNot:
        db 046h,06Ch,06Fh,061h,074h,069h,06Eh,067h,02Dh,070h,06Fh,069h,06Eh,074h,020h,073h
        db 075h,070h,070h,06Fh,072h,074h,020h,06Eh,06Fh,074h,020h,06Ch,06Fh,061h,064h,065h
        db 064h,0Dh,0Ah,00h
str_NotEnoughMemoryTo:
        db 04Eh,06Fh,074h,020h,065h,06Eh,06Fh,075h,067h,068h,020h,06Dh,065h,06Dh,06Fh,072h
        db 079h,020h,074h,06Fh,020h,061h,06Ch,06Ch,06Fh,063h,061h,074h,065h,020h,066h,069h
        db 06Ch,065h,020h,073h,074h,072h,075h,063h,074h,075h,072h,065h,073h,0Dh,0Ah,00h
str_RATIONALDOS4G:
        db 052h,041h,054h,049h,04Fh,04Eh,041h,04Ch,020h,044h,04Fh,053h,02Fh,034h,047h,00h
str_GF1PATCH110:
        db 047h,046h,031h,050h,041h,054h,043h,048h,031h,031h,030h,00h
str_110:
        db 031h,031h,030h,00h
str_ULTRASND:
        db 055h,04Ch,054h,052h,041h,053h,04Eh,044h,00h,00h,00h,00h
str_Inf:
        db 069h,06Eh,066h,00h
str_Nan:
        db 06Eh,061h,06Eh,00h
F64_neg1_floor_:
        db 00h,00h,00h,00h,00h
        db 00h,0F0h,0BFh
