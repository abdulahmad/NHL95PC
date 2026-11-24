; Strings and constants of src/lib/ea/ea_unpackf_blit.asm, in link order.
bits 32
%include "hockey.inc"
section s_C48FC progbits alloc noexec write align=1
global str_Unpackf, str_Unpacking, str_Fsh, str_3sh, str_SHPI, str_SHPM
str_Unpackf:                                    ; "unpackf" string literal; used by DrawArtAnyFormat
        db 075h,06Eh,070h,061h,063h,06Bh,066h,00h
str_Unpacking:                                  ; "unpacking...\n" string literal; used by DrawArtAnyFormat
        db 075h,06Eh,070h,061h,063h,06Bh,069h,06Eh,067h,02Eh,02Eh,02Eh,0Ah,00h,00h,00h
str_Fsh:                                        ; ".fsh" string literal
        db 02Eh,066h,073h,068h,00h,020h,076h,06Fh
str_3sh:                                        ; ".3sh" string literal
        db 02Eh,033h,073h,068h,00h,066h,061h,072h
str_SHPI:                                       ; "SHPI" string literal
        db 053h,048h,050h,049h,00h,031h,02Ch,020h
str_SHPM:                                       ; "SHPM" string literal
        db 053h,048h,050h,04Dh,00h,020h,076h,06Fh
