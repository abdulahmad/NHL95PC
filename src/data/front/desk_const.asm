; Strings and constants of front/desk (src/front/desk), in link order.
bits 32
%include "hockey.inc"
section s_C0952 progbits alloc noexec write align=1
global str_PleaseEnterOutputFile, str_Eadesk1d, str_Desk, str_Pal5, str_Pointer2, str_Iff3, str_Pause, str_Menubuff3
str_PleaseEnterOutputFile:                      ; string 'Please enter output file name'; used by
                                                ; OutputCurrentData
        db 050h,06Ch,065h,061h,073h,065h,020h,065h,06Eh,074h,065h,072h,020h,06Fh,075h,074h
        db 070h,075h,074h,020h,066h,069h,06Ch,065h,020h,06Eh,061h,06Dh,065h,00h
str_Eadesk1d:                                   ; string 'eadesk%1d'; used by SportsDesk
        db 065h,061h,064h,065h,073h,06Bh,025h,031h,064h,00h
str_Desk:                                       ; string 'desk'; used by SportsDesk
        db 064h,065h,073h,06Bh,00h
str_Pal5:                                       ; string '!pal'; used by SportsDesk
        db 021h,070h,061h,06Ch,00h
str_Pointer2:                                   ; string 'Pointer'; used by SportsDesk
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h
str_Iff3:                                       ; string '.iff'; used by SportsDesk
        db 02Eh,069h,066h,066h,00h
str_Pause:                                      ; string 'pause'; used by SportsDesk
        db 070h,061h,075h,073h,065h,00h
str_Menubuff3:                                  ; string 'menubuff'; used by SportsDesk
        db 06Dh,065h,06Eh,075h,062h,075h,066h,066h,00h
