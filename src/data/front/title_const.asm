; Strings and constants of front/title (src/front/title), in link order.
bits 32
%include "hockey.inc"
section s_C085A progbits alloc noexec write align=1
global str_Eascrn, str_Pal4, str_Scrn2, str_Msk1, str_MASK, str_Iff2, str_Title30, str_Mttitle
global str_Adtitle, str_Cmv, str_Title, str_Pioneer1, str_Pl2, str_Pl1, str_Bkgd3, str_Pioneer2
global str_Pioneer4, str_Pioneer3, str_FlaD, str_Pion, str_Pio, str_Eaopen, str_Easports, str_Backwin
global str_Credits, str_Rockditi, str_Shp0
str_Eascrn:                                     ; string 'eascrn'; used by TitleScreen
        db 065h,061h,073h,063h,072h,06Eh,00h
str_Pal4:                                       ; string '!pal'; used by RunIntro, ShowCredits, TitleScreen
        db 021h,070h,061h,06Ch,00h
str_Scrn2:                                      ; string 'scrn'; used by RunIntro, TitleScreen
        db 073h,063h,072h,06Eh,00h
str_Msk1:                                       ; string 'msk1'; used by TitleScreen
        db 06Dh,073h,06Bh,031h,00h
str_MASK:                                       ; string 'MASK'; used by TitleScreen
        db 04Dh,041h,053h,04Bh,00h
str_Iff2:                                       ; string '.iff'; used by RunIntro, ShowCredits, TitleScreen
        db 02Eh,069h,066h,066h,00h
str_Title30:                                    ; string 'title30'; used by TitleScreen
        db 074h,069h,074h,06Ch,065h,033h,030h,00h
str_Mttitle:                                    ; string 'mttitle'; used by TitleScreen
        db 06Dh,074h,074h,069h,074h,06Ch,065h,00h
str_Adtitle:                                    ; string 'adtitle'; used by ShowCredits, TitleScreen
        db 061h,064h,074h,069h,074h,06Ch,065h,00h
str_Cmv:                                        ; string '.cmv'; used by TitleScreen
        db 02Eh,063h,06Dh,076h,00h
str_Title:                                      ; string 'title'; used by TitleScreen
        db 074h,069h,074h,06Ch,065h,00h
str_Pioneer1:                                   ; string 'pioneer1'; used by RunIntro
        db 070h,069h,06Fh,06Eh,065h,065h,072h,031h,00h
str_Pl2:                                        ; string '!pl2'; used by RunIntro
        db 021h,070h,06Ch,032h,00h
str_Pl1:                                        ; string '!pl1'; used by RunIntro
        db 021h,070h,06Ch,031h,00h
str_Bkgd3:                                      ; string 'bkgd'; used by RunIntro, ShowCredits
        db 062h,06Bh,067h,064h,00h
str_Pioneer2:                                   ; string 'pioneer2'; used by RunIntro
        db 070h,069h,06Fh,06Eh,065h,065h,072h,032h,00h
str_Pioneer4:                                   ; string 'pioneer4'; used by RunIntro
        db 070h,069h,06Fh,06Eh,065h,065h,072h,034h,00h
str_Pioneer3:                                   ; string 'pioneer3'; used by RunIntro
        db 070h,069h,06Fh,06Eh,065h,065h,072h,033h,00h
str_FlaD:                                       ; string 'fla%d'; used by RunIntro
        db 066h,06Ch,061h,025h,064h,00h
str_Pion:                                       ; string 'pion'; used by RunIntro
        db 070h,069h,06Fh,06Eh,00h
str_Pio:                                        ; string '!pio'; used by RunIntro
        db 021h,070h,069h,06Fh,00h
str_Eaopen:                                     ; string 'eaopen'; used by RunIntro
        db 065h,061h,06Fh,070h,065h,06Eh,00h
str_Easports:                                   ; string 'easports'; used by RunIntro
        db 065h,061h,073h,070h,06Fh,072h,074h,073h,00h
str_Backwin:                                    ; string 'backwin'; used by ShowCredits
        db 062h,061h,063h,06Bh,077h,069h,06Eh,00h
str_Credits:                                    ; string 'credits'; used by ShowCredits
        db 063h,072h,065h,064h,069h,074h,073h,00h
str_Rockditi:                                   ; string 'rockditi'; used by ShowCredits
        db 072h,06Fh,063h,06Bh,064h,069h,074h,069h,00h
str_Shp0:                                       ; string 'shp0'; used by ShowCredits
        db 073h,068h,070h,030h,00h,00h,00h
