; Strings and constants of src/lib/ea/ea_timer.asm, in link order.
bits 32
%include "hockey.inc"
section s_C3F5C progbits alloc noexec write align=1
global str_AddtimerLISTFULL
str_AddtimerLISTFULL:                           ; "addtimer - LIST FULL\n" string literal; used by addtimer
        db 061h,064h,064h,074h,069h,06Dh,065h,072h,020h,02Dh,020h,04Ch,049h,053h,054h,020h
        db 046h,055h,04Ch,04Ch,0Ah,00h,00h,00h
