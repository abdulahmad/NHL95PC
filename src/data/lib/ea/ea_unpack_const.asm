; Strings and constants of src/lib/ea/ea_unpack.asm, in link order.
bits 32
%include "hockey.inc"
section s_C47B8 progbits alloc noexec write align=1
global str_Copyright, str_UnpackINVALIDPACKCODE
str_Copyright:                                  ; "Copyright" string literal; used by SkipCopyrightHeader
        db 043h,06Fh,070h,079h,072h,069h,067h,068h,074h,00h,020h,066h
str_UnpackINVALIDPACKCODE:                      ; "unpack - INVALID PACK CODE (%x)\n" string literal; used by
                                                ; unpack
        db 075h,06Eh,070h,061h,063h,06Bh,020h,02Dh,020h,049h,04Eh,056h,041h,04Ch,049h,044h
        db 020h,050h,041h,043h,04Bh,020h,043h,04Fh,044h,045h,020h,028h,025h,078h,029h,0Ah
        db 00h,00h,00h,00h
