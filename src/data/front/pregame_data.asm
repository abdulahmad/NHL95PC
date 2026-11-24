; Initialised data of front/pregame (src/front/pregame).
bits 32
%include "hockey.inc"
section s_C6E7E progbits alloc noexec write align=1
extern str_AwayLines, str_Cancel, str_HomeLines, str_Play
global pregamebuttons, str_PenaltyKilling, str_PowerPlay, str_Shooting, str_Skating, str_Passing, str_Defense2, str_Checking
global str_Goaltending, str_Overall, scoutcatnames, scoutcatidx
pregamebuttons:                                 ; 4 x 1Ch buttons (x, y, w, h, .., text); used by
                                                ; PreGameScreen
        db 030h,00h,00h,00h,0BCh,01h,00h,00h,064h,00h,00h,00h,018h,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_AwayLines
        db 0C4h,00h,00h,00h,0BCh,01h,00h,00h,064h,00h,00h,00h,018h,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_Play
        db 058h,01h,00h,00h,0BCh,01h,00h,00h,064h,00h,00h,00h,018h,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_Cancel
        db 0ECh,01h,00h,00h,0BCh,01h,00h,00h,064h,00h,00h,00h,018h,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_HomeLines
str_PenaltyKilling:                             ; string
        db 050h,065h,06Eh,061h,06Ch,074h,079h,020h,04Bh,069h,06Ch,06Ch,069h,06Eh,067h,00h
str_PowerPlay:                                  ; string
        db 050h,06Fh,077h,065h,072h,020h,050h,06Ch,061h,079h,00h
str_Shooting:                                   ; string
        db 053h,068h,06Fh,06Fh,074h,069h,06Eh,067h,00h
str_Skating:                                    ; string
        db 053h,06Bh,061h,074h,069h,06Eh,067h,00h
str_Passing:                                    ; string
        db 050h,061h,073h,073h,069h,06Eh,067h,00h
str_Defense2:                                   ; string
        db 044h,065h,066h,065h,06Eh,073h,065h,00h
str_Checking:                                   ; string
        db 043h,068h,065h,063h,06Bh,069h,06Eh,067h,00h
str_Goaltending:                                ; string
        db 047h,06Fh,061h,06Ch,074h,065h,06Eh,064h,069h,06Eh,067h,00h
str_Overall:                                    ; string
        db 04Fh,076h,065h,072h,020h,061h,06Ch,06Ch,00h
scoutcatnames:                                  ; Penalty Killing .. Over all (9); used by PreGameScreen
        dd str_PenaltyKilling
        dd str_PowerPlay
        dd str_Shooting
        dd str_Skating
        dd str_Passing
        dd str_Defense2
        dd str_Checking
        dd str_Goaltending
        dd str_Overall
scoutcatidx:                                    ; team rating index per scouting category; used by
                                                ; PreGameScreen
        db 00h,01h,04h,05h,06h,07h,08h,0Ah,0Bh,00h,00h,00h
