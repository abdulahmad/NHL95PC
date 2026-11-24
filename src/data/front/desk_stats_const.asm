; Strings and constants of front/desk_stats (src/front/desk_stats), in link order.
bits 32
%include "hockey.inc"
section s_C0910 progbits alloc noexec write align=1
global str_OUT, str_NeedKbytesFmt2, str_rt, str_wt, str_SfPal1, str_SfPal2
str_OUT:                                        ; string '.OUT'; used by WriteScreenTextFile
        db 02Eh,04Fh,055h,054h,00h
str_NeedKbytesFmt2:                             ; string 'require %2d Kbytes of free disk space.'; used by
                                                ; WriteScreenTextFile
        db 072h,065h,071h,075h,069h,072h,065h,020h,025h,032h,064h,020h,04Bh,062h,079h,074h
        db 065h,073h,020h,06Fh,066h,020h,066h,072h,065h,065h,020h,064h,069h,073h,06Bh,020h
        db 073h,070h,061h,063h,065h,02Eh,00h
str_rt:                                         ; string 'rt'; used by WriteScreenTextFile
        db 072h,074h,00h
str_wt:                                         ; string 'wt'; used by WriteScreenTextFile
        db 077h,074h,00h,00h,00h
str_SfPal1:                                     ; string 'SfPal1'; used by StatsMenuAssists, StatsMenuGAA,
                                                ; StatsMenuGoalieWins ...
        db 053h,066h,050h,061h,06Ch,031h,00h
str_SfPal2:                                     ; string 'SfPal2'; used by StatsMenuAssists, StatsMenuGAA,
                                                ; StatsMenuGoalieWins ...
        db 053h,066h,050h,061h,06Ch,032h,00h
