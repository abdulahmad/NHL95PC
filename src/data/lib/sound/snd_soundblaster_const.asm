; Strings and constants of src/lib/sound/snd_soundblaster.asm, in link order.
bits 32
%include "hockey.inc"
section s_C4A94 progbits alloc noexec write align=1
global str_BLASTER
str_BLASTER:                                    ; "BLASTER" string literal; used by ParseBlasterEnv
        db 042h,04Ch,041h,053h,054h,045h,052h,00h
