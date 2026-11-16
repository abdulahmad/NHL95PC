; NHL.CFG, ALLFILES.TXT, and the file names for the coach's cut scene.
bits 32
%include "hockey.inc"
section s_C3B0C progbits alloc noexec write align=1
global str_NhlCfg, str_CantOpenNhlCfg2, str_ALLFILESTXT, str_ALLFILESTXT2, str_CouldNotOpenALLFILES, str_S9, str_Coachcut, str_Scrn4
global str_Pal29, str_Iff13, str_Coach, str_Clip04d, str_Cmv2, str_ModeR
str_ModeR:                                      ; string 'r': fopen mode InitFileLocations opens NHL.CFG with;
                                                ; used by InitFileLocations
        db 072h,00h
str_NhlCfg:                                     ; string 'nhl.cfg'; used by InitFileLocations
        db 06Eh,068h,06Ch,02Eh,063h,066h,067h,00h
str_CantOpenNhlCfg2:                            ; string 'cannot open nhl.cfg'; used by InitFileLocations
        db 063h,061h,06Eh,06Eh,06Fh,074h,020h,06Fh,070h,065h,06Eh,020h,06Eh,068h,06Ch,02Eh
        db 063h,066h,067h,00h
str_ALLFILESTXT:                                ; string ':ALLFILES.TXT'; used by InitFileLocations
        db 03Ah,041h,04Ch,04Ch,046h,049h,04Ch,045h,053h,02Eh,054h,058h,054h,00h
str_ALLFILESTXT2:                               ; string 'ALLFILES.TXT'; used by InitFileLocations
        db 041h,04Ch,04Ch,046h,049h,04Ch,045h,053h,02Eh,054h,058h,054h,00h
str_CouldNotOpenALLFILES:                       ; string 'Could not open ALLFILES.TXT file.'; used by
                                                ; InitFileLocations
        db 043h,06Fh,075h,06Ch,064h,020h,06Eh,06Fh,074h,020h,06Fh,070h,065h,06Eh,020h,041h
        db 04Ch,04Ch,046h,049h,04Ch,045h,053h,02Eh,054h,058h,054h,020h,066h,069h,06Ch,065h
        db 02Eh,00h
str_S9:                                         ; string '%s '; used by InitFileLocations
        db 025h,073h,0Ah,00h,00h
str_Coachcut:                                   ; string 'coachcut'; used by CoachCutScene
        db 063h,06Fh,061h,063h,068h,063h,075h,074h,00h
str_Scrn4:                                      ; string 'scrn'; used by CoachCutScene
        db 073h,063h,072h,06Eh,00h
str_Pal29:                                      ; string '!pal'; used by CoachCutScene
        db 021h,070h,061h,06Ch,00h
str_Iff13:                                      ; string '.iff'; used by CoachCutScene
        db 02Eh,069h,066h,066h,00h
str_Coach:                                      ; string 'coach'; used by CoachCutScene
        db 063h,06Fh,061h,063h,068h,00h
str_Clip04d:                                    ; string 'clip%04d'; used by CoachCutScene
        db 063h,06Ch,069h,070h,025h,030h,034h,064h,00h
str_Cmv2:                                       ; string '.cmv'; used by CoachCutScene
        db 02Eh,063h,06Dh,076h,00h
