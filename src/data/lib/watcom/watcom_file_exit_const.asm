; Strings and constants of src/lib/watcom/watcom_file_exit.asm, in link order.
bits 32
%include "hockey.inc"
section s_C4B00 progbits alloc noexec write align=1
global str_NotEnoughMemoryTo
str_NotEnoughMemoryTo:                          ; "Not enough memory to allocate file structures\r\n" string
                                                ; literal; used by __InitFiles_
        db 04Eh,06Fh,074h,020h,065h,06Eh,06Fh,075h,067h,068h,020h,06Dh,065h,06Dh,06Fh,072h
        db 079h,020h,074h,06Fh,020h,061h,06Ch,06Ch,06Fh,063h,061h,074h,065h,020h,066h,069h
        db 06Ch,065h,020h,073h,074h,072h,075h,063h,074h,075h,072h,065h,073h,0Dh,0Ah,00h
