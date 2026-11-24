; Strings and constants of front/calendar (src/front/calendar), in link order.
bits 32
%include "hockey.inc"
section s_C17F4 progbits alloc noexec write align=1
global str_Boxr, str_Boxb, str_Bkgd7, str_02d9D, str_Home, str_Away, str_D8, str_W5
global str_SDD2, str_L7, str_T5, str_Pal17, str_Calendar, str_Callogo, str_Iff9, str_Pointer8
global str_Menubuff5
str_Boxr:                                       ; string 'boxr'; used by DrawCalendarDay
        db 062h,06Fh,078h,072h,00h
str_Boxb:                                       ; string 'boxb'; used by DrawCalendarDay
        db 062h,06Fh,078h,062h,00h
str_Bkgd7:                                      ; string 'bkgd'; used by DrawCalendarDay
        db 062h,06Bh,067h,064h,00h
str_02d9D:                                      ; string '%02d9%d'; used by DrawCalendarDay
        db 025h,030h,032h,064h,039h,025h,064h,00h
str_Home:                                       ; string 'Home'; used by DrawCalendarDay
        db 048h,06Fh,06Dh,065h,00h
str_Away:                                       ; string 'Away'; used by DrawCalendarDay
        db 041h,077h,061h,079h,00h
str_D8:                                         ; string '%d'; used by DrawCalendarDay
        db 025h,064h,00h
str_W5:                                         ; string 'W'; used by DrawCalendarDay
        db 057h,00h
str_SDD2:                                       ; string '%s:%d-%d'; used by DrawCalendarDay
        db 025h,073h,03Ah,025h,064h,02Dh,025h,064h,00h
str_L7:                                         ; string 'L'; used by DrawCalendarDay
        db 04Ch,00h
str_T5:                                         ; string 'T'; used by DrawCalendarDay
        db 054h,00h
str_Pal17:                                      ; string '!pal'; used by ApplyShapePalette, PlayLeagueGame
        db 021h,070h,061h,06Ch,00h
str_Calendar:                                   ; string 'calendar'; used by CalendarScreen
        db 063h,061h,06Ch,065h,06Eh,064h,061h,072h,00h
str_Callogo:                                    ; string 'callogo'; used by CalendarScreen
        db 063h,061h,06Ch,06Ch,06Fh,067h,06Fh,00h
str_Iff9:                                       ; string '.iff'; used by CalendarScreen
        db 02Eh,069h,066h,066h,00h
str_Pointer8:                                   ; string 'Pointer'; used by CalendarScreen
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h
str_Menubuff5:                                  ; string 'menubuff'; used by CalendarScreen
        db 06Dh,065h,06Eh,075h,062h,075h,066h,066h,00h
