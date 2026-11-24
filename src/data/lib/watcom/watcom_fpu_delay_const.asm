; Strings and constants of src/lib/watcom/watcom_fpu_delay.asm, in link order.
bits 32
%include "hockey.inc"
section s_C4A83 progbits alloc noexec write align=1
global str_UnknownError
str_UnknownError:                               ; "unknown error" string literal; used by strerror_
        db 075h,06Eh,06Bh,06Eh,06Fh,077h,06Eh,020h,065h,072h,072h,06Fh,072h,00h,00h,00h
        db 00h
