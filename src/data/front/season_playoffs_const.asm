; Strings and constants of front/season_playoffs (src/front/season_playoffs), in link order.
bits 32
%include "hockey.inc"
section s_C1A70 progbits alloc noexec write align=1
global str_sche, str_Sch, str_gameset, str_KbytesFree
str_sche:                                       ; string 'sche'; used by BuildPlayoffs
        db 073h,063h,068h,065h,00h
str_Sch:                                        ; string 'Sch'; used by AdvancePlayoffs
        db 053h,063h,068h,00h,00h,00h,00h
str_gameset:                                    ; string 'game.set'; used by CreateNewLeague
        db 067h,061h,06Dh,065h,02Eh,073h,065h,074h,00h
str_KbytesFree:                                 ; string '%4d Kbytes of free disk space.'; used by
                                                ; CreateNewLeague
        db 025h,034h,064h,020h,04Bh,062h,079h,074h,065h,073h,020h,06Fh,066h,020h,066h,072h
        db 065h,065h,020h,064h,069h,073h,06Bh,020h,073h,070h,061h,063h,065h,02Eh,00h
