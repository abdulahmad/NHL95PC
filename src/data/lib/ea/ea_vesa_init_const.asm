; Strings and constants of src/lib/ea/ea_vesa_init.asm, in link order.
bits 32
%include "hockey.inc"
section s_C3DB4 progbits alloc noexec write align=1
global str_EavesaCom, str_CUtilEavesaCom, str_InitgraphicsEAVESACOM, str_CEavesaDat, str_InitgraphicsNEWVERSIONOF, str_VESA, str_InitgraphicsINITMEMMAN, str_InitgraphicsINVALIDSCREEN
global str_VESAVideoBiosDriver
str_EavesaCom:                                  ; "eavesa.com" string literal; used by ProbeVesa
        db 065h,061h,076h,065h,073h,061h,02Eh,063h,06Fh,06Dh,00h,04Dh
str_CUtilEavesaCom:                             ; "c:\util\eavesa.com" string literal; used by ProbeVesa
        db 063h,03Ah,05Ch,075h,074h,069h,06Ch,05Ch,065h,061h,076h,065h,073h,061h,02Eh,063h
        db 06Fh,06Dh,00h,06Ch
str_InitgraphicsEAVESACOM:                      ; "initgraphics - EAVESA.COM REQUIRED IN PATH.\nPlease copy
                                                ; EAVESA.COM to" string literal; used by ProbeVesa
        db 069h,06Eh,069h,074h,067h,072h,061h,070h,068h,069h,063h,073h,020h,02Dh,020h,045h
        db 041h,056h,045h,053h,041h,02Eh,043h,04Fh,04Dh,020h,052h,045h,051h,055h,049h,052h
        db 045h,044h,020h,049h,04Eh,020h,050h,041h,054h,048h,02Eh,0Ah,050h,06Ch,065h,061h
        db 073h,065h,020h,063h,06Fh,070h,079h,020h,045h,041h,056h,045h,053h,041h,02Eh,043h
        db 04Fh,04Dh,020h,074h,06Fh,020h,079h,06Fh,075h,072h,020h,073h,079h,073h,074h,065h
        db 06Dh,02Eh,0Ah,00h
str_CEavesaDat:                                 ; "c:\eavesa.dat" string literal; used by ProbeVesa
        db 063h,03Ah,05Ch,065h,061h,076h,065h,073h,061h,02Eh,064h,061h,074h,00h,074h,020h
str_InitgraphicsNEWVERSIONOF:                   ; "initgraphics - NEW VERSION OF EAVESA.COM REQUIRED.\nPlease
                                                ; install EAV" string literal; used by ProbeVesa
        db 069h,06Eh,069h,074h,067h,072h,061h,070h,068h,069h,063h,073h,020h,02Dh,020h,04Eh
        db 045h,057h,020h,056h,045h,052h,053h,049h,04Fh,04Eh,020h,04Fh,046h,020h,045h,041h
        db 056h,045h,053h,041h,02Eh,043h,04Fh,04Dh,020h,052h,045h,051h,055h,049h,052h,045h
        db 044h,02Eh,0Ah,050h,06Ch,065h,061h,073h,065h,020h,069h,06Eh,073h,074h,061h,06Ch
        db 06Ch,020h,045h,041h,056h,045h,053h,041h,02Eh,043h,04Fh,04Dh,020h,061h,06Eh,064h
        db 020h,072h,065h,072h,075h,06Eh,02Eh,0Ah,00h,069h,074h,067h
str_VESA:                                       ; "VESA" string literal; used by ProbeVesa
        db 056h,045h,053h,041h,00h,063h,073h,020h
str_InitgraphicsINITMEMMAN:                     ; "initgraphics - INITMEMMAN REQUIRED BEFORE INITGRAPHICS\n"
                                                ; string literal; used by initgraphics
        db 069h,06Eh,069h,074h,067h,072h,061h,070h,068h,069h,063h,073h,020h,02Dh,020h,049h
        db 04Eh,049h,054h,04Dh,045h,04Dh,04Dh,041h,04Eh,020h,052h,045h,051h,055h,049h,052h
        db 045h,044h,020h,042h,045h,046h,04Fh,052h,045h,020h,049h,04Eh,049h,054h,047h,052h
        db 041h,050h,048h,049h,043h,053h,0Ah,00h
str_InitgraphicsINVALIDSCREEN:                  ; "initgraphics - INVALID SCREEN SIZE (%d,%d)\n" string
                                                ; literal; used by initgraphics
        db 069h,06Eh,069h,074h,067h,072h,061h,070h,068h,069h,063h,073h,020h,02Dh,020h,049h
        db 04Eh,056h,041h,04Ch,049h,044h,020h,053h,043h,052h,045h,045h,04Eh,020h,053h,049h
        db 05Ah,045h,020h,028h,025h,064h,02Ch,025h,064h,029h,0Ah,00h
str_VESAVideoBiosDriver:                        ; "VESA video bios driver required.\nPlease install a driver
                                                ; for your vid" string literal; used by initgraphics
        db 056h,045h,053h,041h,020h,076h,069h,064h,065h,06Fh,020h,062h,069h,06Fh,073h,020h
        db 064h,072h,069h,076h,065h,072h,020h,072h,065h,071h,075h,069h,072h,065h,064h,02Eh
        db 0Ah,050h,06Ch,065h,061h,073h,065h,020h,069h,06Eh,073h,074h,061h,06Ch,06Ch,020h
        db 061h,020h,064h,072h,069h,076h,065h,072h,020h,066h,06Fh,072h,020h,079h,06Fh,075h
        db 072h,020h,076h,069h,064h,065h,06Fh,020h,063h,061h,072h,064h,020h,061h,06Eh,064h
        db 020h,072h,065h,072h,075h,06Eh,02Eh,0Ah,00h,00h,00h,00h
