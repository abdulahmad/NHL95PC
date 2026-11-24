; Strings and constants of src/lib/cmv_player.asm, in link order.
bits 32
%include "hockey.inc"
section s_C09A0 progbits alloc noexec write align=1
global str_CmvMemBlock, str_CmvPalette
str_CmvMemBlock:                                ; "cmv mem block" string literal; used by CmvCreate
        db 063h,06Dh,076h,020h,06Dh,065h,06Dh,020h,062h,06Ch,06Fh,063h,06Bh,00h
str_CmvPalette:                                 ; "cmv palette" string literal; used by CmvReadHeader
        db 063h,06Dh,076h,020h,070h,061h,06Ch,065h,074h,074h,065h,00h,00h,00h
