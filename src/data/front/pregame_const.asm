; Strings and constants of front/pregame (src/front/pregame), in link order.
bits 32
%include "hockey.inc"
section s_C1370 progbits alloc noexec write align=1
global str_Apal, str_Pal10, str_Arena, str_Pal11, str_Rink, str_Srlogo, str_SAtS, str_D4
global str_Pointer4, str_Iff4, str_Scouting, str_Screen, str_Ctlogo, str_Logohome, str_Logoaway, str_Ctbkgd
global str_Bkgd4, str_Pal12, str_Cttitle1, str_Def, str_Fowa, str_Scra, str_Tlu, str_Top
global str_Indus030, str_GIPK, str_Iff5, str_Tonights, str_Injured
str_Apal:                                       ; string 'apal'; used by PreGameScreen
        db 061h,070h,061h,06Ch,00h
str_Pal10:                                      ; string 'Pal'; used by PreGameScreen, PreGameScreen_homelines
        db 050h,061h,06Ch,00h
str_Arena:                                      ; string 'arena'; used by PreGameScreen
        db 061h,072h,065h,06Eh,061h,00h
str_Pal11:                                      ; string '!pal'; used by PreGameScreen
        db 021h,070h,061h,06Ch,00h
str_Rink:                                       ; string 'rink'; used by PreGameScreen
        db 072h,069h,06Eh,06Bh,00h
str_Srlogo:                                     ; string 'srlogo'; used by PreGameScreen
        db 073h,072h,06Ch,06Fh,067h,06Fh,00h
str_SAtS:                                       ; string '%s at %s'; used by PreGameScreen
        db 025h,073h,020h,020h,020h,061h,074h,020h,020h,020h,025h,073h,00h
str_D4:                                         ; string '%d'; used by PreGameScreen
        db 025h,064h,00h
str_Pointer4:                                   ; string 'Pointer'; used by PreGameScreen
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h
str_Iff4:                                       ; string '.iff'; used by PreGameScreen
        db 02Eh,069h,066h,066h,00h
str_Scouting:                                   ; string 'scouting'; used by PreGameScreen
        db 073h,063h,06Fh,075h,074h,069h,06Eh,067h,00h
str_Screen:                                     ; string 'Screen'; used by PreGameScreen_awaylines,
                                                ; PreGameScreen_homelines
        db 053h,063h,072h,065h,065h,06Eh,00h,00h,00h,00h
str_Ctlogo:                                     ; string 'ctlogo'; used by TonightsGameScreen
        db 063h,074h,06Ch,06Fh,067h,06Fh,00h
str_Logohome:                                   ; string 'logohome'; used by TonightsGameScreen
        db 06Ch,06Fh,067h,06Fh,068h,06Fh,06Dh,065h,00h
str_Logoaway:                                   ; string 'logoaway'; used by TonightsGameScreen
        db 06Ch,06Fh,067h,06Fh,061h,077h,061h,079h,00h
str_Ctbkgd:                                     ; string 'ctbkgd'; used by TonightsGameScreen
        db 063h,074h,062h,06Bh,067h,064h,00h
str_Bkgd4:                                      ; string 'bkgd'; used by TonightsGameScreen
        db 062h,06Bh,067h,064h,00h
str_Pal12:                                      ; string '!pal'; used by TonightsGameScreen
        db 021h,070h,061h,06Ch,00h
str_Cttitle1:                                   ; string 'cttitle1'; used by TonightsGameScreen
        db 063h,074h,074h,069h,074h,06Ch,065h,031h,00h
str_Def:                                        ; string 'def '; used by TonightsGameScreen
        db 064h,065h,066h,020h,00h
str_Fowa:                                       ; string 'fowa'; used by TonightsGameScreen
        db 066h,06Fh,077h,061h,00h
str_Scra:                                       ; string 'scra'; used by TonightsGameScreen
        db 073h,063h,072h,061h,00h
str_Tlu:                                        ; string 'tlu '; used by TonightsGameScreen
        db 074h,06Ch,075h,020h,00h
str_Top:                                        ; string 'top '; used by TonightsGameScreen
        db 074h,06Fh,070h,020h,00h
str_Indus030:                                   ; string 'indus030'; used by TonightsGameScreen
        db 069h,06Eh,064h,075h,073h,030h,033h,030h,00h
str_GIPK:                                       ; string 'GIPK'; used by TonightsGameScreen
        db 047h,049h,050h,04Bh,00h
str_Iff5:                                       ; string '.iff'; used by TonightsGameScreen
        db 02Eh,069h,066h,066h,00h
str_Tonights:                                   ; string 'tonights'; used by TonightsGameScreen
        db 074h,06Fh,06Eh,069h,067h,068h,074h,073h,00h
str_Injured:                                    ; string 'Injured'; used by TonightsGameScreen
        db 049h,06Eh,06Ah,075h,072h,065h,064h,00h
