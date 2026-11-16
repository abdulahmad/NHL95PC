; Play-Off mode strings: the schedule file, the conferences, and the message that the playoffs are not set up.
bits 32
%include "hockey.inc"
section s_C39B3 progbits alloc noexec write align=1
global str_Palette, str_Embscup, str_Bkgd, str_Embpal, str_BangPal, str_PleaseEnterNewPlay, str_PO, str_fmtSlashDb
global str_GameSet, str_4dKbytesOfFree, str_Temp2, str_ScheduleDb, str_E31, str_E32, str_Db, str_Tied
global str_Schedule, str_GameSav, str_Pointer, str_Menubuff2, str_PlayoffsHaveNotBeen, str_Pstatbar2, str_Rst1, str_Rst2
global str_Scuparrw, str_WesternConference, str_EasternConference, str_fmtcsp, str_Aup1, str_Aup2, str_Aup3, str_Midl
global str_Adn3, str_Adn2, str_Adn1, str_E1, str_E2, str_F1, str_F2, str_space4
global str_D, str_space5
str_Palette:                                    ; string 'palette'; used by CreatePlayoffs, PlayoffModeLoop
        db 070h,061h,06Ch,065h,074h,074h,065h,00h
str_Embscup:                                    ; string 'embscup'; used by CreatePlayoffs, PlayoffModeLoop,
                                                ; PlayoffTreeMenu
        db 065h,06Dh,062h,073h,063h,075h,070h,00h
str_Bkgd:                                       ; string 'bkgd'; used by CreatePlayoffs
        db 062h,06Bh,067h,064h,00h
str_Embpal:                                     ; string 'embpal'; used by CreatePlayoffs, DrawPlayoffTree,
                                                ; POHandleElimination ...
        db 065h,06Dh,062h,070h,061h,06Ch,00h
str_BangPal:                                    ; string '!pal'; used by CreatePlayoffs, DrawPlayoffTree,
                                                ; POHandleElimination ...
        db 021h,070h,061h,06Ch,00h
str_PleaseEnterNewPlay:                         ; string 'Please Enter New Play-Off Name'; used by
                                                ; CreatePlayoffs
        db 050h,06Ch,065h,061h,073h,065h,020h,045h,06Eh,074h,065h,072h,020h,04Eh,065h,077h
        db 020h,050h,06Ch,061h,079h,02Dh,04Fh,066h,066h,020h,04Eh,061h,06Dh,065h,00h
str_PO:                                         ; string '.PO'; used by CreatePlayoffs
        db 02Eh,050h,04Fh,00h
str_fmtSlashDb:                                 ; string '\\%s.db'; used by CreatePlayoffs
        db 05Ch,025h,073h,02Eh,064h,062h,00h
str_GameSet:                                    ; string 'game.set'; used by CreatePlayoffs
        db 067h,061h,06Dh,065h,02Eh,073h,065h,074h,00h
str_4dKbytesOfFree:                             ; string '%4d Kbytes of free disk space.'; used by
                                                ; CreatePlayoffs
        db 025h,034h,064h,020h,04Bh,062h,079h,074h,065h,073h,020h,06Fh,066h,020h,066h,072h
        db 065h,065h,020h,064h,069h,073h,06Bh,020h,073h,070h,061h,063h,065h,02Eh,00h
str_Temp2:                                      ; string 'temp'; used by CreatePlayoffs
        db 074h,065h,06Dh,070h,00h
str_ScheduleDb:                                 ; string 'schedule.db'; used by POCreateSchedule,
                                                ; SaveScheduleDB
        db 073h,063h,068h,065h,064h,075h,06Ch,065h,02Eh,064h,062h,00h
str_E1:                                         ; string 'e1'; used by POSimSeriesTeamWins
        db 065h,031h,00h
str_E2:                                         ; string 'e2'; used by POSimSeriesTeamWins
        db 065h,032h,00h
str_F1:                                         ; string 'f1'; used by POSimSeries
        db 066h,031h,00h
str_F2:                                         ; string 'f2'; used by POSimSeries
        db 066h,032h,00h
str_E31:                                        ; string 'e31'; used by POSimSeriesTo
        db 065h,033h,031h,00h
str_E32:                                        ; string 'e32'; used by POSimSeriesTo
        db 065h,033h,032h,00h
str_Db:                                         ; string '.db'; used by POAfterGame
        db 02Eh,064h,062h,00h
str_Tied:                                       ; string 'tied'; used by POAfterGame
        db 074h,069h,065h,064h,00h
str_Schedule:                                   ; string 'schedule'; used by LoadScheduleDB
        db 073h,063h,068h,065h,064h,075h,06Ch,065h,00h
str_GameSav:                                    ; string 'game.sav'; used by PlayoffModeLoop
        db 067h,061h,06Dh,065h,02Eh,073h,061h,076h,00h
str_space4:                                     ; string ' '; used by PlayoffModeLoop
        db 020h,00h
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
