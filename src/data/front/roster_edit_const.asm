; Strings and constants of front/roster_edit (src/front/roster_edit), in link order.
bits 32
%include "hockey.inc"
section s_C2EE3 progbits alloc noexec write align=1
global str_NotEnoughSpaceFA, str_InTheFreeAgent, str_ForAllSelectedPlayers, str_TheNumberOfSelected, str_PlayersAndGoalies, str_Players, str_Goalies, str_MustBeTheSame
global str_EnterNameOfPlayer, str_FreeAgentList, str_ChooseWhichTeamTo, str_IsAlreadyDisplayedOn, str_Roster2, str_Roster1, str_DoesNotExist
str_NotEnoughSpaceFA:                           ; string 'There is not enough space'; used by MoveToFreeAgents
        db 054h,068h,065h,072h,065h,020h,069h,073h,020h,06Eh,06Fh,074h,020h,065h,06Eh,06Fh
        db 075h,067h,068h,020h,073h,070h,061h,063h,065h,00h
str_InTheFreeAgent:                             ; string 'in the free agent list'; used by MoveToFreeAgents
        db 069h,06Eh,020h,074h,068h,065h,020h,066h,072h,065h,065h,020h,061h,067h,065h,06Eh
        db 074h,020h,06Ch,069h,073h,074h,00h
str_ForAllSelectedPlayers:                      ; string 'for all selected players'; used by MoveToFreeAgents
        db 066h,06Fh,072h,020h,061h,06Ch,06Ch,020h,073h,065h,06Ch,065h,063h,074h,065h,064h
        db 020h,070h,06Ch,061h,079h,065h,072h,073h,00h,00h,00h,00h
str_TheNumberOfSelected:                        ; string 'The number of selected '; used by
                                                ; SwapSelectedPlayers
        db 054h,068h,065h,020h,06Eh,075h,06Dh,062h,065h,072h,020h,06Fh,066h,020h,073h,065h
        db 06Ch,065h,063h,074h,065h,064h,020h,00h
str_PlayersAndGoalies:                          ; string 'players and goalies'; used by SwapSelectedPlayers
        db 070h,06Ch,061h,079h,065h,072h,073h,020h,061h,06Eh,064h,020h,067h,06Fh,061h,06Ch
        db 069h,065h,073h,00h
str_Players:                                    ; string 'players'; used by SwapSelectedPlayers
        db 070h,06Ch,061h,079h,065h,072h,073h,00h
str_Goalies:                                    ; string 'goalies'; used by SwapSelectedPlayers
        db 067h,06Fh,061h,06Ch,069h,065h,073h,00h
str_MustBeTheSame:                              ; string 'must be the same on both teams!'; used by
                                                ; SwapSelectedPlayers
        db 06Dh,075h,073h,074h,020h,062h,065h,020h,074h,068h,065h,020h,073h,061h,06Dh,065h
        db 020h,06Fh,06Eh,020h,062h,06Fh,074h,068h,020h,074h,065h,061h,06Dh,073h,021h,00h
str_EnterNameOfPlayer:                          ; string 'Enter name of player to find:'; used by FindPlayer
        db 045h,06Eh,074h,065h,072h,020h,06Eh,061h,06Dh,065h,020h,06Fh,066h,020h,070h,06Ch
        db 061h,079h,065h,072h,020h,074h,06Fh,020h,066h,069h,06Eh,064h,03Ah,00h
str_FreeAgentList:                              ; string 'Free Agent List'; used by FindPlayer
        db 046h,072h,065h,065h,020h,041h,067h,065h,06Eh,074h,020h,04Ch,069h,073h,074h,00h
str_ChooseWhichTeamTo:                          ; string 'Choose which team to display'; used by FindPlayer
        db 043h,068h,06Fh,06Fh,073h,065h,020h,077h,068h,069h,063h,068h,020h,074h,065h,061h
        db 06Dh,020h,074h,06Fh,020h,064h,069h,073h,070h,06Ch,061h,079h,00h
str_IsAlreadyDisplayedOn:                       ; string 'is already displayed on'; used by FindPlayer
        db 069h,073h,020h,061h,06Ch,072h,065h,061h,064h,079h,020h,064h,069h,073h,070h,06Ch
        db 061h,079h,065h,064h,020h,06Fh,06Eh,00h
str_Roster2:                                    ; string 'Roster 2'; used by FindPlayer
        db 052h,06Fh,073h,074h,065h,072h,020h,032h,00h
str_Roster1:                                    ; string 'Roster 1'; used by FindPlayer
        db 052h,06Fh,073h,074h,065h,072h,020h,031h,00h
str_DoesNotExist:                               ; string 'does not exist!'; used by FindPlayer
        db 064h,06Fh,065h,073h,020h,06Eh,06Fh,074h,020h,065h,078h,069h,073h,074h,021h,00h
        db 00h,00h,00h
