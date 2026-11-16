; Play-Off elimination messages, and the drive letter of the CD.
bits 32
%include "hockey.inc"
section s_D2A6C progbits alloc noexec write align=1
extern str_YourTeamHasBeen, str_FromThePlayOffs, str_WishToSeeThe, str_OfThePlayOffs, str_TheEliminated
global msg_POTeamOut_arg, msg_POTeamOut_arg2, KeyReleaseBase, cddrivestr, vtoa_dt, poslotx, posloty, cddriveptr
global msg_POHumanOut, msg_POTeamOut, msg_POGenFinal, str_HaveBeenEliminatedFrom, str_ThePlayOffs, str_TheContinue, str_WillContinueToThe, str_Series
global str_YES2, str_NO5, str_GeneratingTheFinalResults, btn_POHumanOut
msg_POTeamOut_arg:                              ; msg_POTeamOut fill-in string pointer for the message box;
                                                ; used by POAfterGame
        db 02Eh,02Eh,02Eh,02Eh,02Ch,02Eh,02Eh,02Eh,02Eh,02Ch,02Eh,02Eh,02Eh,02Eh,02Ch,02Eh
        db 02Eh,02Eh,02Eh,02Ch,02Eh,00h
str_HaveBeenEliminatedFrom:                     ; "have been eliminated from" string literal
        db 068h,061h,076h,065h,020h,062h,065h,065h,06Eh,020h,065h,06Ch,069h,06Dh,069h,06Eh
        db 061h,074h,065h,064h,020h,066h,072h,06Fh,06Dh,00h
str_ThePlayOffs:                                ; "the play-offs." string literal
        db 074h,068h,065h,020h,070h,06Ch,061h,079h,02Dh,06Fh,066h,066h,073h,02Eh,00h
str_TheContinue:                                ; Message text: The (before the team that continues)
        db 054h,068h,065h,020h
msg_POTeamOut_arg2:                             ; message box line table; used by POAfterGame
        db 02Eh,02Eh,02Eh,02Eh,02Eh,02Eh,02Eh,02Eh,02Eh,02Eh,02Eh,02Eh,02Eh,02Eh,02Eh,02Eh
        db 02Eh,02Eh,02Eh,02Eh,02Eh,00h
str_WillContinueToThe:                          ; "will continue to the next" string literal
        db 077h,069h,06Ch,06Ch,020h,063h,06Fh,06Eh,074h,069h,06Eh,075h,065h,020h,074h,06Fh
        db 020h,074h,068h,065h,020h,06Eh,065h,078h,074h,00h
str_Series:                                     ; "series." string literal
        db 073h,065h,072h,069h,065h,073h,02Eh,00h
str_YES2:                                       ; "YES" string literal
        db 059h,045h,053h,00h
str_NO5:                                        ; "NO" string literal
        db 04Eh,04Fh,00h
str_GeneratingTheFinalResults:                  ; "Generating the final results." string literal
        db 047h,065h,06Eh,065h,072h,061h,074h,069h,06Eh,067h,020h,074h,068h,065h,020h,066h
        db 069h,06Eh,061h,06Ch,020h,072h,065h,073h,075h,06Ch,074h,073h,02Eh,00h
msg_POHumanOut:                                 ; message box line table; used by POHandleElimination
        dd str_YourTeamHasBeen
        dd str_FromThePlayOffs
        dd str_WishToSeeThe
        dd str_OfThePlayOffs
msg_POTeamOut:                                  ; message box line table; used by POHandleElimination
        dd str_TheEliminated
        dd str_HaveBeenEliminatedFrom
        dd str_ThePlayOffs
        dd str_TheContinue
        dd str_WillContinueToThe
        dd str_Series
msg_POGenFinal:                                 ; message box line table; used by POHandleElimination
        dd str_GeneratingTheFinalResults
btn_POHumanOut:                                 ; string '\x10'; used by DeleteSavedGame, DeleteSelectedDb,
                                                ; DeskExitGame ...
        db 010h,00h,00h,00h,04Eh,00h,00h,00h,028h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_NO5
        db 0F0h,0FFh,0FFh,0FFh,04Eh,00h,00h,00h,028h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,06h,00h,00h,00h
        dd str_YES2
poslotx:                                        ; POHiliteSlot: x of each playoff tree slot; used by
                                                ; POHiliteSlot
        db 012h,00h,00h,00h,0B5h,00h,00h,00h,05Ah,01h,00h,00h,0FCh,01h,00h,00h
        db 0FCh,01h,00h,00h,05Ah,01h,00h,00h,0B5h,00h,00h,00h,012h,00h,00h,00h
        db 012h,00h,00h,00h,0B5h,00h,00h,00h,05Ah,01h,00h,00h,0FCh,01h,00h,00h
        db 0FCh,01h,00h,00h,05Ah,01h,00h,00h,0B5h,00h,00h,00h,012h,00h,00h,00h
        db 02Eh,00h,00h,00h,0DAh,00h,00h,00h,0DAh,00h,00h,00h,02Eh,00h,00h,00h
        db 03Eh,01h,00h,00h,0EAh,01h,00h,00h,0EAh,01h,00h,00h,03Eh,01h,00h,00h
        db 046h,00h,00h,00h,046h,00h,00h,00h,0C4h,01h,00h,00h,0C4h,01h,00h,00h
        db 04h,01h,00h,00h,04h,01h,00h,00h,04h,01h,00h,00h
posloty:                                        ; POHiliteSlot: y of each playoff tree slot; used by
                                                ; POHiliteSlot
        db 048h,00h,00h,00h,048h,00h,00h,00h,048h,00h,00h,00h,048h,00h,00h,00h
        db 048h,00h,00h,00h,048h,00h,00h,00h,048h,00h,00h,00h,048h,00h,00h,00h
        db 07Eh,01h,00h,00h,07Eh,01h,00h,00h,07Eh,01h,00h,00h,07Eh,01h,00h,00h
        db 07Eh,01h,00h,00h,07Eh,01h,00h,00h,07Eh,01h,00h,00h,07Eh,01h,00h,00h
        db 097h,00h,00h,00h,097h,00h,00h,00h,097h,00h,00h,00h,097h,00h,00h,00h
        db 031h,01h,00h,00h,031h,01h,00h,00h,031h,01h,00h,00h,031h,01h,00h,00h
        db 0E3h,00h,00h,00h,0E3h,00h,00h,00h,0E3h,00h,00h,00h,0E3h,00h,00h,00h
KeyReleaseBase:                                 ; Key state table less 80h so a release scan code (bit 7 set)
                                                ; indexes the right key; used by KeyboardIrqHandler
        db 0D1h,00h,00h,00h,0D1h,00h,00h,00h,0D1h,00h,00h,00h
cddrivestr:                                     ; 'a:' drive string, letter patched from nhl.cfg; used by
                                                ; InitFileLocations
        db 061h,03Ah,00h
cddriveptr:                                     ; pointer to cddrivestr, MakePath prefix for CD files; used by
                                                ; AddHumanTeam, AwardsCeremony, CalGoalieStatsScreen ...
        dd cddrivestr
        db 00h,01h,00h,00h,00h
vtoa_dt:                                        ; used by vtoa
        db 01h,07h,03h,05h,00h,00h,04h,04h,02h,06h,02h,06h,01h,07h,03h,05h
