; Strings and constants of engine/intro (src/engine/intro), in link order.
bits 32
%include "hockey.inc"
section s_C1B2C progbits alloc noexec write align=1
global str_EASports, str_StarFmt, str_NoStar, str_RoughingTitle
str_EASports:                                   ; "EA Sports" (three-stars caption, assthreestars); used by
                                                ; assthreestars
        db 045h,041h,020h,053h,070h,06Fh,072h,074h,073h,00h
str_StarFmt:                                    ; "%s Star" sprintf format, filled with str_1st/2nd/3rd by
                                                ; assthreestars; used by assthreestars
        db 025h,073h,020h,053h,074h,061h,072h,00h
str_NoStar:                                     ; Empty string pushed when a three stars line has no star
                                                ; text; used by assthreestars
        db 00h,00h
str_RoughingTitle:                              ; "Roughing" string literal, the first penalty name string;
                                                ; not referenced by name
        db 052h,06Fh,075h,067h,068h,069h,06Eh,067h,00h
