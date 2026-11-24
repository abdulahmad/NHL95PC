; Initialised data of front/dbcheck (src/front/dbcheck).
bits 32
%include "hockey.inc"
section s_D0C5C progbits alloc noexec write align=1
extern str_Cancel6, str_Create, str_No4, str_Yes
global str_Two, str_Continue, str_Stop2, btn_DBError, PosBitMasks
str_Two:                                        ; string '2'; used by CreatePlayerLoop, DrawCreatePlayer
        db 032h,00h,00h,00h,0B8h,01h,00h,00h,03Fh,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_Cancel6
        db 0Fh,02h,00h,00h,0B8h,01h,00h,00h,03Fh,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_Create
str_Continue:                                   ; "Continue" string literal
        db 043h,06Fh,06Eh,074h,069h,06Eh,075h,065h,00h
str_Stop2:                                      ; "Stop" string literal
        db 053h,074h,06Fh,070h,00h
btn_DBError:                                    ; database error screen: its two buttons; used by
                                                ; DrawDBErrorsScreen, ShowDBError
        db 014h,00h,00h,00h,0C2h,01h,00h,00h,050h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_Continue
        db 01Ch,02h,00h,00h,0C2h,01h,00h,00h,050h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_Stop2
PosBitMasks:                                    ; One bit per position (1 2 4 8 ...) used by CheckTeamLines
        db 01h,00h,00h,00h,02h,00h,00h,00h,04h,00h,00h,00h,08h,00h,00h,00h
        db 010h,00h,00h,00h,020h,00h,00h,00h,040h,00h,00h,00h,080h,00h,00h,00h
        db 00h,01h,00h,00h,00h,02h,00h,00h,046h,072h,065h,065h,020h,041h,067h,065h
        db 06Eh,074h,020h,050h,06Ch,061h,079h,065h,072h,073h,00h,077h,069h,06Ch,06Ch,020h
        db 062h,065h,020h,064h,065h,06Ch,065h,074h,065h,064h,02Eh,00h,043h,06Fh,06Eh,074h
        db 069h,06Eh,075h,065h,03Fh,00h,08h,00h,00h,00h,03Ch,00h,00h,00h,025h,00h
        db 00h,00h,014h,00h,00h,00h,00h,00h,00h,00h,05h,00h,00h,00h
        dd str_No4
        db 0F8h,0FFh,0FFh,0FFh,03Ch,00h,00h,00h,025h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,06h,00h,00h,00h
        dd str_Yes
