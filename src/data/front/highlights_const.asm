; Strings and constants of front/highlights (src/front/highlights), in link order.
bits 32
%include "hockey.inc"
section s_C3444 progbits alloc noexec write align=1
global str_K1, str_backslash4, str_HI, str_F12, str_CantOpenFile, str_F3, str_F4, str_dot4
global str_HLTL, str_HLT, str_HLTS
str_K1:                                         ; string 'k1'; used by SaveHilight
        db 06Bh,031h,00h
str_backslash4:                                 ; string backslash; used by SaveHilight
        db 05Ch,00h
str_HI:                                         ; string '.HI'; used by SaveHilight
        db 02Eh,048h,049h,00h
str_F12:                                        ; string 'f1'; used by SaveHilight
        db 066h,031h,00h
str_CantOpenFile:                               ; string "Can not open `%s' file\n"; used by SaveHilight
        db 043h,061h,06Eh,020h,06Eh,06Fh,074h,020h,06Fh,070h,065h,06Eh,020h,060h,025h,073h
        db 027h,020h,066h,069h,06Ch,065h,0Ah,00h
str_F3:                                         ; string 'f3'; used by SaveHilight
        db 066h,033h,00h
str_F4:                                         ; string 'f4'; used by SaveHilight
        db 066h,034h,00h,00h,00h
str_dot4:                                       ; string '.' (TeamFromHiName separator); used by
                                                ; TeamFromHiName
        db 02Eh,00h
str_HLTL:                                       ; string 'HLTL'; used by SelectHilight
        db 048h,04Ch,054h,04Ch,00h
str_HLT:                                        ; string 'HLT'; used by SelectHilight
        db 048h,04Ch,054h,00h
str_HLTS:                                       ; string 'HLTS'; used by SelectHilight
        db 048h,04Ch,054h,053h,00h
