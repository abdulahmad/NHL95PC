; Strings and constants of pc/config_cfg (src/pc/config_cfg), in link order.
bits 32
%include "hockey.inc"
section s_C1942 progbits alloc noexec write align=1
global str_NHL2, str_R3, str_CannotOpenNhlCfg, str_fmt4x
str_NHL2:                                       ; string 'NHL'; used by LoadNhlCfg
        db 04Eh,048h,04Ch,00h
str_R3:                                         ; string 'r'; used by LoadNhlCfg
        db 072h,00h
str_CannotOpenNhlCfg:                           ; string 'cannot open nhl.cfg'; used by LoadNhlCfg
        db 063h,061h,06Eh,06Eh,06Fh,074h,020h,06Fh,070h,065h,06Eh,020h,06Eh,068h,06Ch,02Eh
        db 063h,066h,067h,00h
str_fmt4x:                                      ; string "%4x "; used by LoadNhlCfg
        db 025h,034h,078h,0Ah,00h,00h,00h,00h
