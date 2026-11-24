; Strings and constants of src/lib/watcom/watcom_fprintf.asm, in link order.
bits 32
%include "hockey.inc"
section s_C472C progbits alloc noexec write align=1
global str_ColonSpace
str_ColonSpace:                                 ; Colon and space printed by perror; used by perror_
        db 03Ah,020h,00h,00h
