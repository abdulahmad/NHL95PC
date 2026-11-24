; Strings and constants of src/lib/watcom/watcom_ltoa.asm, in link order.
bits 32
%include "hockey.inc"
section s_C4ADC progbits alloc noexec write align=1
global str_FloatingPointSupportNot
str_FloatingPointSupportNot:                    ; "Floating-point support not loaded\r\n" string literal; used
                                                ; by NoFloatSupport
        db 046h,06Ch,06Fh,061h,074h,069h,06Eh,067h,02Dh,070h,06Fh,069h,06Eh,074h,020h,073h
        db 075h,070h,070h,06Fh,072h,074h,020h,06Eh,06Fh,074h,020h,06Ch,06Fh,061h,064h,065h
        db 064h,0Dh,0Ah,00h
