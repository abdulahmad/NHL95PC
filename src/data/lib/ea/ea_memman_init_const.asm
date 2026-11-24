; Strings and constants of src/lib/ea/ea_memman_init.asm, in link order.
bits 32
%include "hockey.inc"
section s_C3D88 progbits alloc noexec write align=1
global str_InitmemmanINSUFFICIENTROW
str_InitmemmanINSUFFICIENTROW:                  ; "initmemman - INSUFFICIENT ROW TABLE SPACE\n" string
                                                ; literal; used by initmemman
        db 069h,06Eh,069h,074h,06Dh,065h,06Dh,06Dh,061h,06Eh,020h,02Dh,020h,049h,04Eh,053h
        db 055h,046h,046h,049h,043h,049h,045h,04Eh,054h,020h,052h,04Fh,057h,020h,054h,041h
        db 042h,04Ch,045h,020h,053h,050h,041h,043h,045h,0Ah,00h,00h
