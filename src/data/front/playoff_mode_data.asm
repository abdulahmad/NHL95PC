; Initialised data of front/playoff_mode (src/front/playoff_mode).
bits 32
%include "hockey.inc"
section s_D2864 progbits alloc noexec write align=1
extern str_SDD3
global podbsizes, PoGameSetFlag, poseriesfmt, str_ThereIsAlreadyA3, str_DoYouWantTo7, msg_POExists, str_AnErrorWasEncountered, str_SettingUpThePlayoffs
global str_PlayoffSeriesHasNot, str_Created, msg_POSetupError, str_PleaseWait3, str_SettingUpPlayOffs, msg_POSettingUp, str_InsufficientDiskSpaceTo5, str_APlayoffSeriesYou
global msg_PODiskSpace_arg, msg_PODiskSpace, seriesgameno, str_YourTeamHasBeen, str_FromThePlayOffs, str_WishToSeeThe, str_OfThePlayOffs, str_TheEliminated
global msg_POTeamOut_arg, str_HaveBeenEliminatedFrom, str_ThePlayOffs, str_TheContinue, msg_POTeamOut_arg2, str_WillContinueToThe, str_Series, str_YES2
global str_NO5, str_GeneratingTheFinalResults, msg_POHumanOut, msg_POTeamOut, msg_POGenFinal, btn_POHumanOut, poslotx, posloty
global KeyReleaseBase
podbsizes:                                      ; CreatePlayoffs: database sizes passed to GetLeagueDBSizes /
                                                ; DiskSpaceShort; used by CreatePlayoffs
        db 026h,00h,00h,00h,01Eh,00h,00h,00h,0Fh,00h,00h,00h,03h,00h,00h,00h
        db 015h,00h,00h,00h,023h,00h,00h,00h,08h,00h,00h,00h,02h,00h,00h,00h
PoGameSetFlag:                                  ; Last podbsizes entry; cleared when the playoff GAMESET file
                                                ; already exists; used by CreatePlayoffs
        db 01h,00h,00h,00h,00h,00h,00h,00h
poseriesfmt:                                    ; POAfterGame: pointer to the series score format '%s %d-%d';
                                                ; used by POAfterGame
        dd str_SDD3
str_ThereIsAlreadyA3:                           ; "There is already a Play-Off with that name!" string literal
        db 054h,068h,065h,072h,065h,020h,069h,073h,020h,061h,06Ch,072h,065h,061h,064h,079h
        db 020h,061h,020h,050h,06Ch,061h,079h,02Dh,04Fh,066h,066h,020h,077h,069h,074h,068h
        db 020h,074h,068h,061h,074h,020h,06Eh,061h,06Dh,065h,021h,00h
str_DoYouWantTo7:                               ; "Do you want to replace it with a new Play-Off?" string
                                                ; literal
        db 044h,06Fh,020h,079h,06Fh,075h,020h,077h,061h,06Eh,074h,020h,074h,06Fh,020h,072h
        db 065h,070h,06Ch,061h,063h,065h,020h,069h,074h,020h,077h,069h,074h,068h,020h,061h
        db 020h,06Eh,065h,077h,020h,050h,06Ch,061h,079h,02Dh,04Fh,066h,066h,03Fh,00h
msg_POExists:                                   ; message box line table; used by CreatePlayoffs
        dd str_ThereIsAlreadyA3
        dd str_DoYouWantTo7
str_AnErrorWasEncountered:                      ; string "An Error Was Encountered While"; not referenced by
                                                ; name
        db 041h,06Eh,020h,045h,072h,072h,06Fh,072h,020h,057h,061h,073h,020h,045h,06Eh,063h
        db 06Fh,075h,06Eh,074h,065h,072h,065h,064h,020h,057h,068h,069h,06Ch,065h,00h
str_SettingUpThePlayoffs:                       ; "Setting Up The Playoffs." string literal
        db 053h,065h,074h,074h,069h,06Eh,067h,020h,055h,070h,020h,054h,068h,065h,020h,050h
        db 06Ch,061h,079h,06Fh,066h,066h,073h,02Eh,00h
str_PlayoffSeriesHasNot:                        ; "Playoff Series Has Not Been" string literal
        db 050h,06Ch,061h,079h,06Fh,066h,066h,020h,053h,065h,072h,069h,065h,073h,020h,048h
        db 061h,073h,020h,04Eh,06Fh,074h,020h,042h,065h,065h,06Eh,00h
str_Created:                                    ; "Created." string literal
        db 043h,072h,065h,061h,074h,065h,064h,02Eh,00h
msg_POSetupError:                               ; message box line table; used by CreatePlayoffs
        dd str_AnErrorWasEncountered
        dd str_SettingUpThePlayoffs
        dd str_PlayoffSeriesHasNot
        dd str_Created
str_PleaseWait3:                                ; "Please Wait." string literal
        db 050h,06Ch,065h,061h,073h,065h,020h,057h,061h,069h,074h,02Eh,00h
str_SettingUpPlayOffs:                          ; "Setting Up Play-Offs." string literal
        db 053h,065h,074h,074h,069h,06Eh,067h,020h,055h,070h,020h,050h,06Ch,061h,079h,02Dh
        db 04Fh,066h,066h,073h,02Eh,00h
msg_POSettingUp:                                ; message box line table; used by CreatePlayoffs
        dd str_PleaseWait3
        dd str_SettingUpPlayOffs
str_InsufficientDiskSpaceTo5:                   ; "Insufficient disk space to setup" string literal
        db 049h,06Eh,073h,075h,066h,066h,069h,063h,069h,065h,06Eh,074h,020h,064h,069h,073h
        db 06Bh,020h,073h,070h,061h,063h,065h,020h,074h,06Fh,020h,073h,065h,074h,075h,070h
        db 00h
str_APlayoffSeriesYou:                          ; "a Playoff Series, you require " string literal
        db 061h,020h,050h,06Ch,061h,079h,06Fh,066h,066h,020h,053h,065h,072h,069h,065h,073h
        db 02Ch,020h,079h,06Fh,075h,020h,072h,065h,071h,075h,069h,072h,065h,020h,00h
msg_PODiskSpace_arg:                            ; msg_PODiskSpace fill-in string pointer for the message box;
                                                ; used by CreatePlayoffs
        db 058h,058h,058h,058h,020h,04Bh,062h,079h,074h,065h,073h,020h,06Fh,066h,020h,066h
        db 072h,065h,065h,020h,064h,069h,073h,06Bh,020h,073h,070h,061h,063h,065h,02Eh,020h
        db 020h,020h,020h,00h
msg_PODiskSpace:                                ; message box line table; used by CreatePlayoffs
        dd str_InsufficientDiskSpaceTo5
        dd str_APlayoffSeriesYou
        dd msg_PODiskSpace_arg
seriesgameno:                                   ; game number within the current 7-game series (game index mod
                                                ; 7); used by CreatePlayoffs, DrawLeagueSetDlg,
                                                ; LeagueSetHitTest ...
        db 0FFh,0FFh,0FFh,0FFh
str_YourTeamHasBeen:                            ; "Your team has been eliminated" string literal
        db 059h,06Fh,075h,072h,020h,074h,065h,061h,06Dh,020h,068h,061h,073h,020h,062h,065h
        db 065h,06Eh,020h,065h,06Ch,069h,06Dh,069h,06Eh,061h,074h,065h,064h,00h
str_FromThePlayOffs:                            ; "from the play-offs. Do you" string literal
        db 066h,072h,06Fh,06Dh,020h,074h,068h,065h,020h,070h,06Ch,061h,079h,02Dh,06Fh,066h
        db 066h,073h,02Eh,020h,044h,06Fh,020h,079h,06Fh,075h,00h
str_WishToSeeThe:                               ; "wish to see the final results" string literal
        db 077h,069h,073h,068h,020h,074h,06Fh,020h,073h,065h,065h,020h,074h,068h,065h,020h
        db 066h,069h,06Eh,061h,06Ch,020h,072h,065h,073h,075h,06Ch,074h,073h,00h
str_OfThePlayOffs:                              ; "of the play-offs?" string literal
        db 06Fh,066h,020h,074h,068h,065h,020h,070h,06Ch,061h,079h,02Dh,06Fh,066h,066h,073h
        db 03Fh,00h
str_TheEliminated:                              ; Message text: The (before the eliminated team name)
        db 054h,068h,065h,020h
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
