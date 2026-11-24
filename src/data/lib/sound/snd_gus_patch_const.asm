; Strings and constants of src/lib/sound/snd_gus_patch.asm, in link order.
bits 32
%include "hockey.inc"
section s_C4B40 progbits alloc noexec write align=1
global str_GF1PATCH110, str_110, str_ULTRASND
str_GF1PATCH110:                                ; "GF1PATCH110" string literal; used by GusReadPatchHeader
        db 047h,046h,031h,050h,041h,054h,043h,048h,031h,031h,030h,00h
str_110:                                        ; string '110'; used by GusReadPatchHeader
        db 031h,031h,030h,00h
str_ULTRASND:                                   ; "ULTRASND" string literal
        db 055h,04Ch,054h,052h,041h,053h,04Eh,044h,00h,00h,00h,00h
