; Strings and constants of front/playoff (src/front/playoff), in link order.
bits 32
%include "hockey.inc"
section s_C1282 progbits alloc noexec write align=1
global str_Pstatbar8, str_Pst27, str_Standings, str_Western, str_Conference, str_Eastern, str_Team, str_GP7
global str_W4, str_L6, str_T4, str_GF, str_GA2, str_P, str_Pct4, str_Embpal2
global str_Pal9, str_PlayoffsHaveNotBeen2, str_Rst12, str_Rst22, str_Scuparrw2, str_WesternConference2, str_EasternConference2, str_C3
global str_D3, str_Aup12, str_Aup22, str_Aup32, str_Midl2, str_TwoSpaces, str_Adn32, str_Adn22
global str_Adn12
str_Pstatbar8:                                  ; string 'pstatbar'; used by PlayoffTreeScreen,
                                                ; StandingsScreen
        db 070h,073h,074h,061h,074h,062h,061h,072h,00h
str_Pst27:                                      ; string 'pst2'; used by StandingsScreen
        db 070h,073h,074h,032h,00h
str_Standings:                                  ; string ' Standings'; used by PlayoffTreeScreen,
                                                ; StandingsScreen
        db 020h,053h,074h,061h,06Eh,064h,069h,06Eh,067h,073h,00h
str_Western:                                    ; string 'Western'; used by StandingsScreen
        db 057h,065h,073h,074h,065h,072h,06Eh,00h
str_Conference:                                 ; string 'Conference'; used by StandingsScreen
        db 043h,06Fh,06Eh,066h,065h,072h,065h,06Eh,063h,065h,00h
str_Eastern:                                    ; string 'Eastern'; used by StandingsScreen
        db 045h,061h,073h,074h,065h,072h,06Eh,00h
str_Team:                                       ; string 'Team'; used by StandingsScreen
        db 054h,065h,061h,06Dh,00h
str_GP7:                                        ; string 'GP'; used by StandingsScreen
        db 047h,050h,00h
str_W4:                                         ; string ' W'; used by StandingsScreen
        db 020h,057h,00h
str_L6:                                         ; string ' L'; used by StandingsScreen
        db 020h,04Ch,00h
str_T4:                                         ; string ' T'; used by StandingsScreen
        db 020h,054h,00h
str_GF:                                         ; string ' GF'; used by StandingsScreen
        db 020h,047h,046h,00h
str_GA2:                                        ; string ' GA'; used by StandingsScreen
        db 020h,047h,041h,00h
str_P:                                          ; string ' P'; used by StandingsScreen
        db 020h,020h,050h,00h
str_Pct4:                                       ; string ' Pct'; used by StandingsScreen
        db 020h,020h,050h,063h,074h,00h
str_Embpal2:                                    ; string 'embpal'; used by PlayoffTreeScreen
        db 065h,06Dh,062h,070h,061h,06Ch,00h
str_Pal9:                                       ; string '!pal'; used by PlayoffTreeScreen
        db 021h,070h,061h,06Ch,00h
str_PlayoffsHaveNotBeen2:                       ; string 'Playoffs have not been seeded yet'; used by
                                                ; PlayoffTreeScreen
        db 050h,06Ch,061h,079h,06Fh,066h,066h,073h,020h,068h,061h,076h,065h,020h,06Eh,06Fh
        db 074h,020h,062h,065h,065h,06Eh,020h,073h,065h,065h,064h,065h,064h,020h,079h,065h
        db 074h,00h
str_Rst12:                                      ; string 'rst1'; used by PlayoffTreeScreen
        db 072h,073h,074h,031h,00h
str_Rst22:                                      ; string 'rst2'; used by PlayoffTreeScreen
        db 072h,073h,074h,032h,00h
str_Scuparrw2:                                  ; string 'scuparrw'; used by PlayoffTreeScreen
        db 073h,063h,075h,070h,061h,072h,072h,077h,00h
str_WesternConference2:                         ; string 'Western Conference'; used by PlayoffTreeScreen
        db 057h,065h,073h,074h,065h,072h,06Eh,020h,043h,06Fh,06Eh,066h,065h,072h,065h,06Eh
        db 063h,065h,00h
str_EasternConference2:                         ; string 'Eastern Conference'; used by PlayoffTreeScreen
        db 045h,061h,073h,074h,065h,072h,06Eh,020h,043h,06Fh,06Eh,066h,065h,072h,065h,06Eh
        db 063h,065h,00h
str_C3:                                         ; string '%c '; used by PlayoffTreeScreen
        db 025h,063h,020h,00h
str_D3:                                         ; string '%d'; used by PlayoffTreeScreen
        db 025h,064h,00h
str_Aup12:                                      ; string 'aup1'; used by PlayoffTreeScreen
        db 061h,075h,070h,031h,00h
str_Aup22:                                      ; string 'aup2'; used by PlayoffTreeScreen
        db 061h,075h,070h,032h,00h
str_Aup32:                                      ; string 'aup3'; used by PlayoffTreeScreen
        db 061h,075h,070h,033h,00h
str_Midl2:                                      ; string 'midl'; used by PlayoffTreeScreen
        db 06Dh,069h,064h,06Ch,00h
str_TwoSpaces:                                  ; " "; used by PlayoffTreeScreen
        db 020h,020h,00h
str_Adn32:                                      ; string 'adn3'; used by PlayoffTreeScreen
        db 061h,064h,06Eh,033h,00h
str_Adn22:                                      ; string 'adn2'; used by PlayoffTreeScreen
        db 061h,064h,06Eh,032h,00h
str_Adn12:                                      ; string 'adn1'; used by PlayoffTreeScreen
        db 061h,064h,06Eh,031h,00h
