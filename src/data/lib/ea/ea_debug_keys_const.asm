; Strings and constants of src/lib/ea/ea_debug_keys.asm, in link order.
bits 32
%include "hockey.inc"
section s_C470C progbits alloc noexec write align=1
global str_DateTimeFmt, str_2d02d02d2
str_DateTimeFmt:                                ; Date format string used by FormatDateTime
        db 025h,030h,032h,064h,02Dh,025h,033h,073h,02Dh,025h,030h,032h,064h,00h,00h,065h
str_2d02d02d2:                                  ; string '%2d:%02d:%02d'; used by FormatDateTime
        db 025h,032h,064h,03Ah,025h,030h,032h,064h,03Ah,025h,030h,032h,064h,00h,00h,00h
