; Prompts when a league already exists, which schedule to use, and whether to remove a team.
bits 32
%include "hockey.inc"
section s_C772B progbits alloc noexec write align=1
extern str_Yes, str_No4, str_ThereIsAlreadyA, str_DoYouWantTo2
global msg_LeagueExists, btn_LeagueExists, str_WhichScheduleDoYou, str_9394Season2, str_Random, msg_WhichSchedule, btn_WhichSchedule, str_ErrorWhileUpdatingDatabase
global msg_DbUpdateError, str_ErrorWhileCreatingLeague, msg_CreateError, str_ErrorWhileTradingPlayers, msg_TradeError, str_DoYouReallyWantToRemove
msg_LeagueExists:                               ; message box line table; used by CreateNewLeague
        dd str_ThereIsAlreadyA
        dd str_DoYouWantTo2
btn_LeagueExists:                               ; string '\x10'; used by CreateNewLeague, CreatePlayoffs,
                                                ; EditRosters ...
        db 010h,00h,00h,00h,03Ch,00h,00h,00h,028h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_No4
        db 0F0h,0FFh,0FFh,0FFh,03Ch,00h,00h,00h,028h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,06h,00h,00h,00h
        dd str_Yes
str_WhichScheduleDoYou:                         ; " Which schedule do you want to use? " string literal
        db 020h,020h,057h,068h,069h,063h,068h,020h,073h,063h,068h,065h,064h,075h,06Ch,065h
        db 020h,064h,06Fh,020h,079h,06Fh,075h,020h,077h,061h,06Eh,074h,020h,074h,06Fh,020h
        db 075h,073h,065h,03Fh,020h,020h,00h
str_9394Season2:                                ; "'93 - '94 Season" string literal
        db 027h,039h,033h,020h,02Dh,020h,027h,039h,034h,020h,053h,065h,061h,073h,06Fh,06Eh
        db 00h
str_Random:                                     ; "Random" string literal
        db 052h,061h,06Eh,064h,06Fh,06Dh,00h
msg_WhichSchedule:                              ; message box line table; used by CreateNewLeague
        dd str_WhichScheduleDoYou
btn_WhichSchedule:                              ; string '\x10'; used by CreateNewLeague
        db 010h,00h,00h,00h,030h,00h,00h,00h,0A0h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_9394Season2
        db 0F0h,0FFh,0FFh,0FFh,030h,00h,00h,00h,0A0h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,06h,00h,00h,00h
        dd str_Random
str_ErrorWhileUpdatingDatabase:                 ; "Error while updating database!" string literal
        db 045h,072h,072h,06Fh,072h,020h,077h,068h,069h,06Ch,065h,020h,075h,070h,064h,061h
        db 074h,069h,06Eh,067h,020h,064h,061h,074h,061h,062h,061h,073h,065h,021h,00h
msg_DbUpdateError:                              ; PlayLeagueGame message 'Error while updating database'; used
                                                ; by PlayLeagueGame
        dd str_ErrorWhileUpdatingDatabase
str_ErrorWhileCreatingLeague:                   ; "Error while creating league!" string literal
        db 045h,072h,072h,06Fh,072h,020h,077h,068h,069h,06Ch,065h,020h,063h,072h,065h,061h
        db 074h,069h,06Eh,067h,020h,06Ch,065h,061h,067h,075h,065h,021h,00h
msg_CreateError:                                ; message box line table; used by CreateNewLeague
        dd str_ErrorWhileCreatingLeague
str_ErrorWhileTradingPlayers:                   ; "Error while trading players!" string literal
        db 045h,072h,072h,06Fh,072h,020h,077h,068h,069h,06Ch,065h,020h,074h,072h,061h,064h
        db 069h,06Eh,067h,020h,070h,06Ch,061h,079h,065h,072h,073h,021h,00h
msg_TradeError:                                 ; message box line table; used by TradePlayers
        dd str_ErrorWhileTradingPlayers
str_DoYouReallyWantToRemove:                    ; string 'Do you really want to remove'
        db 044h,06Fh,020h,079h,06Fh,075h,020h,072h,065h,061h,06Ch,06Ch,079h,020h,077h,061h
        db 06Eh,074h,020h,074h,06Fh,020h,072h,065h,06Dh,06Fh,076h,065h,00h
