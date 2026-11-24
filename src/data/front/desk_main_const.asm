; Strings and constants of front/desk_main (src/front/desk_main), in link order.
bits 32
%include "hockey.inc"
section s_C1724 progbits alloc noexec write align=1
global str_Pointer7, str_Iff8, str_Maindesk, str_Tonights2, str_Easndesk, str_Desk2, str_Pal15, str_Menubuff4
global str_GameSet4, str_Game, str_Set, str_fee2, str_fee3, str_fee4, str_Palette2, str_Temp4
global str_GameSav4
str_Pointer7:                                   ; string 'Pointer'; used by MainDeskLoop
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h
str_Iff8:                                       ; string '.iff'; used by MainDeskLoop
        db 02Eh,069h,066h,066h,00h
str_Maindesk:                                   ; string 'maindesk'; used by MainDeskLoop
        db 06Dh,061h,069h,06Eh,064h,065h,073h,06Bh,00h
str_Tonights2:                                  ; string 'tonights'; used by MainDeskLoop
        db 074h,06Fh,06Eh,069h,067h,068h,074h,073h,00h
str_Easndesk:                                   ; string 'easndesk'; used by MainDeskLoop
        db 065h,061h,073h,06Eh,064h,065h,073h,06Bh,00h
str_Desk2:                                      ; string 'desk'; used by MainDeskLoop
        db 064h,065h,073h,06Bh,00h
str_Pal15:                                      ; string '!pal'; used by MainDeskLoop
        db 021h,070h,061h,06Ch,00h
str_Menubuff4:                                  ; string 'menubuff'; used by MainDeskLoop
        db 06Dh,065h,06Eh,075h,062h,075h,066h,066h,00h
str_GameSet4:                                   ; string 'game.set'; used by WriteModeState
        db 067h,061h,06Dh,065h,02Eh,073h,065h,074h,00h
str_Game:                                       ; string 'game'; used by WriteModeState
        db 067h,061h,06Dh,065h,00h
str_Set:                                        ; string '.set'; used by WriteModeState
        db 02Eh,073h,065h,074h,00h
str_fee2:                                       ; string 'e2'; used by WriteModeState
        db 065h,032h,00h
str_fee3:                                       ; string 'e3'; used by WriteModeState
        db 065h,033h,00h
str_fee4:                                       ; string 'e4'; used by WriteModeState
        db 065h,034h,00h
str_Palette2:                                   ; string 'palette'; used by MenuNewExhibition
        db 070h,061h,06Ch,065h,074h,074h,065h,00h
str_Temp4:                                      ; string 'temp'; used by MenuAddTeam_common,
                                                ; MenuLeagueSettings, MenuMergeLeagueFiles ...
        db 074h,065h,06Dh,070h,00h
str_GameSav4:                                   ; string '\\game.sav'; used by MenuNextLeagueGame
        db 05Ch,067h,061h,06Dh,065h,02Eh,073h,061h,076h,00h,00h,00h
