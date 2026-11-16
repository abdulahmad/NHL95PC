; The free-space line on the Edit Rosters screen.
bits 32
%include "hockey.inc"
section s_D0F80 progbits alloc noexec write align=1
global str_XXXKbytesOfFree, newskatershoots, newgoalieglove, msg_FreeAgentDiskSpace, newskaterdefaults, skaterratingmin, skaterratingmax, newgoaliedefaults
global goalieratingmin, goalieratingmax, str_InsufficientDiskSpace4, str_ToCreateAFree
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
