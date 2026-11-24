; Strings and constants of front/playoff_menu (src/front/playoff_menu), in link order.
bits 32
%include "hockey.inc"
section s_C3A68 progbits alloc noexec write align=1
global str_Pointer, str_Menubuff2, str_PlayoffsHaveNotBeen, str_Pstatbar2, str_Rst1, str_Rst2, str_Scuparrw, str_WesternConference
global str_EasternConference, str_fmtcsp, str_D, str_Aup1, str_Aup2, str_Aup3, str_Midl, str_space5
global str_Adn3, str_Adn2, str_Adn1
str_Pointer:                                    ; string 'Pointer'; used by PlayoffTreeMenu
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h
str_Menubuff2:                                  ; string 'menubuff'; used by PlayoffTreeMenu
        db 06Dh,065h,06Eh,075h,062h,075h,066h,066h,00h
str_PlayoffsHaveNotBeen:                        ; string 'Playoffs have not been seeded yet'; used by
                                                ; DrawPlayoffTree
        db 050h,06Ch,061h,079h,06Fh,066h,066h,073h,020h,068h,061h,076h,065h,020h,06Eh,06Fh
        db 074h,020h,062h,065h,065h,06Eh,020h,073h,065h,065h,064h,065h,064h,020h,079h,065h
        db 074h,00h
str_Pstatbar2:                                  ; string 'pstatbar'; used by DrawPlayoffTree
        db 070h,073h,074h,061h,074h,062h,061h,072h,00h
str_Rst1:                                       ; string 'rst1'; used by DrawPlayoffTree
        db 072h,073h,074h,031h,00h
str_Rst2:                                       ; string 'rst2'; used by DrawPlayoffTree
        db 072h,073h,074h,032h,00h
str_Scuparrw:                                   ; string 'scuparrw'; used by DrawPlayoffTree
        db 073h,063h,075h,070h,061h,072h,072h,077h,00h
str_WesternConference:                          ; string 'Western Conference'; used by DrawPlayoffTree
        db 057h,065h,073h,074h,065h,072h,06Eh,020h,043h,06Fh,06Eh,066h,065h,072h,065h,06Eh
        db 063h,065h,00h
str_EasternConference:                          ; string 'Eastern Conference'; used by DrawPlayoffTree
        db 045h,061h,073h,074h,065h,072h,06Eh,020h,043h,06Fh,06Eh,066h,065h,072h,065h,06Eh
        db 063h,065h,00h
str_fmtcsp:                                     ; string '%c '; used by DrawPlayoffTree
        db 025h,063h,020h,00h
str_D:                                          ; string '%d'; used by DrawPlayoffTree
        db 025h,064h,00h
str_Aup1:                                       ; string 'aup1'; used by DrawPlayoffTree
        db 061h,075h,070h,031h,00h
str_Aup2:                                       ; string 'aup2'; used by DrawPlayoffTree
        db 061h,075h,070h,032h,00h
str_Aup3:                                       ; string 'aup3'; used by DrawPlayoffTree
        db 061h,075h,070h,033h,00h
str_Midl:                                       ; string 'midl'; used by DrawPlayoffTree
        db 06Dh,069h,064h,06Ch,00h
str_space5:                                     ; string of two spaces; used by DrawPlayoffTree
        db 020h,020h,00h
str_Adn3:                                       ; string 'adn3'; used by DrawPlayoffTree
        db 061h,064h,06Eh,033h,00h
str_Adn2:                                       ; string 'adn2'; used by DrawPlayoffTree
        db 061h,064h,06Eh,032h,00h
str_Adn1:                                       ; string 'adn1'; used by DrawPlayoffTree
        db 061h,064h,06Eh,031h,00h,00h,00h
