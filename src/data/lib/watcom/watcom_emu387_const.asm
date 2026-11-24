; Strings and constants of src/lib/watcom/watcom_emu387.asm, in link order.
bits 32
%include "hockey.inc"
section s_C4B30 progbits alloc noexec write align=1
global str_RATIONALDOS4G
str_RATIONALDOS4G:                              ; "RATIONAL DOS/4G" string literal; used by __hook387
        db 052h,041h,054h,049h,04Fh,04Eh,041h,04Ch,020h,044h,04Fh,053h,02Fh,034h,047h,00h
