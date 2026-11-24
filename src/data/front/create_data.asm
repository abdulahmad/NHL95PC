; Initialised data of front/create (src/front/create).
bits 32
%include "hockey.inc"
section s_D0D68 progbits alloc noexec write align=1
extern str_X
global str_ThereIsNoSpace, str_TheSelectedPlayer, str_NotEnoughSpaceTo2, str_AddAllSelectedPlayers, str_ErrorWhileMakingNew, str_NewPlayer, str_NotAddedToDatabases, str_Move
global str_ToFreeAgentList, str_CreateAPlayerOr, str_Player4, str_Goalie3, btn_CreateFreeAgent, str_SavingDatabases, newskaterdefaults, newskatershoots
global skaterratingmin, skaterratingmax, newgoaliedefaults, newgoalieglove, goalieratingmin, goalieratingmax, str_InsufficientDiskSpace4, str_ToCreateAFree
global str_XXXKbytesOfFree, msg_FreeAgentDiskSpace
str_ThereIsNoSpace:                             ; string 'There is no space to add'; used by MoveToOtherRoster
        db 054h,068h,065h,072h,065h,020h,069h,073h,020h,06Eh,06Fh,020h,073h,070h,061h,063h
        db 065h,020h,074h,06Fh,020h,061h,064h,064h,00h
str_TheSelectedPlayer:                          ; string 'the selected player'; used by MoveToOtherRoster
        db 074h,068h,065h,020h,073h,065h,06Ch,065h,063h,074h,065h,064h,020h,070h,06Ch,061h
        db 079h,065h,072h,00h
str_NotEnoughSpaceTo2:                          ; string 'There is not enough space to'; used by
                                                ; MoveToOtherRoster
        db 054h,068h,065h,072h,065h,020h,069h,073h,020h,06Eh,06Fh,074h,020h,065h,06Eh,06Fh
        db 075h,067h,068h,020h,073h,070h,061h,063h,065h,020h,074h,06Fh,00h
str_AddAllSelectedPlayers:                      ; string 'add all selected players'; used by MoveToOtherRoster
        db 061h,064h,064h,020h,061h,06Ch,06Ch,020h,073h,065h,06Ch,065h,063h,074h,065h,064h
        db 020h,070h,06Ch,061h,079h,065h,072h,073h,00h,04Eh,06Fh,074h,020h,065h,06Eh,06Fh
        db 075h,067h,068h,074h,020h,064h,069h,073h,06Bh,020h,073h,070h,061h,063h,065h,00h
        db 04Eh,06Fh,074h,020h,065h,06Eh,06Fh,075h,067h,068h,074h,020h,06Dh,065h,06Dh,06Fh
        db 072h,079h,00h,074h,06Fh,020h,064h,065h,06Ch,065h,074h,065h,020h,070h,06Ch,061h
        db 079h,065h,072h,073h,021h,00h,074h,06Fh,020h,061h,064h,064h,020h,070h,06Ch,061h
        db 079h,065h,072h,073h,021h,00h
str_ErrorWhileMakingNew:                        ; string 'Error while making new databases!'; used by
                                                ; CreateFreeAgent
        db 045h,072h,072h,06Fh,072h,020h,077h,068h,069h,06Ch,065h,020h,06Dh,061h,06Bh,069h
        db 06Eh,067h,020h,06Eh,065h,077h,020h,064h,061h,074h,061h,062h,061h,073h,065h,073h
        db 021h,00h
str_NewPlayer:                                  ; string 'New player'; used by CreateFreeAgent
        db 04Eh,065h,077h,020h,070h,06Ch,061h,079h,065h,072h,00h
str_NotAddedToDatabases:                        ; string ' not added to databases!'; used by CreateFreeAgent
        db 020h,06Eh,06Fh,074h,020h,061h,064h,064h,065h,064h,020h,074h,06Fh,020h,064h,061h
        db 074h,061h,062h,061h,073h,065h,073h,021h,00h,050h,06Ch,061h,079h,065h,072h,020h
        db 06Eh,06Fh,074h,020h,064h,065h,06Ch,065h,074h,065h,064h,020h,066h,072h,06Fh,06Dh
        db 020h,064h,061h,074h,061h,062h,061h,073h,065h,073h,021h,00h
str_Move:                                       ; string 'Move'; used by MoveToFreeAgents
        db 04Dh,06Fh,076h,065h,00h
str_ToFreeAgentList:                            ; string 'to Free Agent List?'; used by MoveToFreeAgents
        db 074h,06Fh,020h,046h,072h,065h,065h,020h,041h,067h,065h,06Eh,074h,020h,04Ch,069h
        db 073h,074h,03Fh,00h,074h,06Fh,020h,052h,06Fh,073h,074h,065h,072h,020h,031h,03Fh
        db 00h,074h,06Fh,020h,052h,06Fh,073h,074h,065h,072h,020h,032h,03Fh,00h
str_CreateAPlayerOr:                            ; string 'Create a player or goalie.'; used by CreateFreeAgent
        db 043h,072h,065h,061h,074h,065h,020h,061h,020h,070h,06Ch,061h,079h,065h,072h,020h
        db 06Fh,072h,020h,067h,06Fh,061h,06Ch,069h,065h,02Eh,00h
str_Player4:                                    ; "Player" string literal
        db 050h,06Ch,061h,079h,065h,072h,00h
str_Goalie3:                                    ; "Goalie" string literal
        db 047h,06Fh,061h,06Ch,069h,065h,00h
btn_CreateFreeAgent:                            ; CreateFreeAgent: the two buttons of its message box; used by
                                                ; CreateFreeAgent
        db 08h,00h,00h,00h,01Ch,00h,00h,00h,048h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_Player4
        db 0F8h,0FFh,0FFh,0FFh,01Ch,00h,00h,00h,048h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,06h,00h,00h,00h
        dd str_Goalie3
str_SavingDatabases:                            ; string 'Saving databases.'; used by MenuSaveDbs
        db 053h,061h,076h,069h,06Eh,067h,020h,064h,061h,074h,061h,062h,061h,073h,065h,073h
        db 02Eh,00h,00h,00h,00h,00h,021h,00h,00h,00h,0E9h,00h,00h,00h,014h,00h
        db 00h,00h,014h,00h,00h,00h,00h,00h,00h,00h,05h,00h,00h,00h,00h,00h
        db 00h,00h,0A0h,00h,00h,00h,0E9h,00h,00h,00h,014h,00h,00h,00h,014h,00h
        db 00h,00h,00h,00h,00h,00h,05h,00h,00h,00h,00h,00h,00h,00h,037h,00h
        db 00h,00h,0E9h,00h,00h,00h,065h,00h,00h,00h,014h,00h,00h,00h,00h,00h
        db 00h,00h,05h,00h,00h,00h
        dd str_X
        db 00h
newskaterdefaults:                              ; CreatePlayerLoop: default ratings copied into a new skater;
                                                ; used by CreatePlayerLoop
        db 01h,07h,07h,09h,07h,07h,07h,07h,07h,07h,07h,07h,07h,05h,07h,00h
        db 00h,00h,00h,00h
newskatershoots:                                ; the new skater: shoots L / R byte, right after his ratings;
                                                ; used by CreateFreeAgent, CreatePlayerLoop, DrawShootsField
                                                ; ...
        db 01h,07h,07h,09h,07h,07h,07h,07h,07h,07h,07h,07h,07h,05h,07h,00h
        db 00h,00h,00h,00h
skaterratingmin:                                ; EditSkaterRating: minimum of each skater rating; used by
                                                ; EditSkaterRating
        db 00h,03h,03h,03h,03h,03h,03h,03h,03h,03h,03h,03h,03h,03h,03h,00h
        db 00h,00h,00h,00h
skaterratingmax:                                ; EditSkaterRating: maximum of each skater rating; used by
                                                ; EditSkaterRating
        db 01h,0Eh,0Eh,0Eh,0Eh,0Dh,0Bh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Ah,0Eh,00h
        db 00h,00h,00h,00h
newgoaliedefaults:                              ; CreatePlayerLoop: default ratings copied into a new goalie;
                                                ; used by CreatePlayerLoop
        db 01h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,00h,00h,00h,00h,00h
newgoalieglove:                                 ; the new goalie: glove hand L / R byte, right after his
                                                ; ratings; used by CreateFreeAgent, CreatePlayerLoop,
                                                ; DrawGloveField ...
        db 01h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,00h,00h,00h,00h,00h
goalieratingmin:                                ; EditGoalieRating: minimum of each goalie rating; used by
                                                ; EditGoalieRating
        db 00h,03h,03h,03h,03h,03h,03h,03h,03h,03h,03h,00h,00h,00h,00h,00h
goalieratingmax:                                ; EditGoalieRating: maximum of each goalie rating; used by
                                                ; EditGoalieRating
        db 01h,0Eh,0Eh,0Eh,0Eh,0Ch,0Bh,0Eh,0Ah,0Eh,0Eh,00h,00h,00h,00h,00h
str_InsufficientDiskSpace4:                     ; "Insufficient disk space available" string literal
        db 049h,06Eh,073h,075h,066h,066h,069h,063h,069h,065h,06Eh,074h,020h,064h,069h,073h
        db 06Bh,020h,073h,070h,061h,063h,065h,020h,061h,076h,061h,069h,06Ch,061h,062h,06Ch
        db 065h,00h
str_ToCreateAFree:                              ; "to create a free agent, you require" string literal
        db 074h,06Fh,020h,063h,072h,065h,061h,074h,065h,020h,061h,020h,066h,072h,065h,065h
        db 020h,061h,067h,065h,06Eh,074h,02Ch,020h,079h,06Fh,075h,020h,072h,065h,071h,075h
        db 069h,072h,065h,00h
str_XXXKbytesOfFree:                            ; string 'XXX Kbytes of free disk space. '; used by
                                                ; CreateFreeAgent
        db 058h,058h,058h,020h,04Bh,062h,079h,074h,065h,073h,020h,06Fh,066h,020h,066h,072h
        db 065h,065h,020h,064h,069h,073h,06Bh,020h,073h,070h,061h,063h,065h,02Eh,020h,020h
        db 00h
msg_FreeAgentDiskSpace:                         ; CreateFreeAgent message 'Insufficient disk space' / 'to
                                                ; create a free'; used by CreateFreeAgent
        dd str_InsufficientDiskSpace4
        dd str_ToCreateAFree
        dd str_XXXKbytesOfFree
        db 00h
