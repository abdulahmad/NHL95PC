; Strings and constants of front/dbcheck (src/front/dbcheck), in link order.
bits 32
%include "hockey.inc"
section s_C2B10 progbits alloc noexec write align=1
global str_ErrorsFoundInDatabases, str_TheForwardLinesAre, str_TheDefenceLinesAre, str_ThePowerPlayLines, str_ThePenaltyKillingLines, str_TheGoalieLinesAre, str_TheExtraAttackerLines, str_NotEnoughPlayers
global str_NotEnoughGoalies, str_NotEnoughForwards, str_NotEnoughDefence
str_ErrorsFoundInDatabases:                     ; string 'Errors found in databases!'; used by
                                                ; DrawDBErrorsScreen
        db 045h,072h,072h,06Fh,072h,073h,020h,066h,06Fh,075h,06Eh,064h,020h,069h,06Eh,020h
        db 064h,061h,074h,061h,062h,061h,073h,065h,073h,021h,00h
str_TheForwardLinesAre:                         ; string 'The forward lines are not complete on '; used by
                                                ; CheckTeamLines
        db 054h,068h,065h,020h,066h,06Fh,072h,077h,061h,072h,064h,020h,06Ch,069h,06Eh,065h
        db 073h,020h,061h,072h,065h,020h,06Eh,06Fh,074h,020h,063h,06Fh,06Dh,070h,06Ch,065h
        db 074h,065h,020h,06Fh,06Eh,020h,00h
str_TheDefenceLinesAre:                         ; string 'The defence lines are not complete on '; used by
                                                ; CheckTeamLines
        db 054h,068h,065h,020h,064h,065h,066h,065h,06Eh,063h,065h,020h,06Ch,069h,06Eh,065h
        db 073h,020h,061h,072h,065h,020h,06Eh,06Fh,074h,020h,063h,06Fh,06Dh,070h,06Ch,065h
        db 074h,065h,020h,06Fh,06Eh,020h,00h
str_ThePowerPlayLines:                          ; string 'The power play lines are not complete on '; used by
                                                ; CheckTeamLines
        db 054h,068h,065h,020h,070h,06Fh,077h,065h,072h,020h,070h,06Ch,061h,079h,020h,06Ch
        db 069h,06Eh,065h,073h,020h,061h,072h,065h,020h,06Eh,06Fh,074h,020h,063h,06Fh,06Dh
        db 070h,06Ch,065h,074h,065h,020h,06Fh,06Eh,020h,00h
str_ThePenaltyKillingLines:                     ; string 'The penalty killing lines are not complete on ';
                                                ; used by CheckTeamLines
        db 054h,068h,065h,020h,070h,065h,06Eh,061h,06Ch,074h,079h,020h,06Bh,069h,06Ch,06Ch
        db 069h,06Eh,067h,020h,06Ch,069h,06Eh,065h,073h,020h,061h,072h,065h,020h,06Eh,06Fh
        db 074h,020h,063h,06Fh,06Dh,070h,06Ch,065h,074h,065h,020h,06Fh,06Eh,020h,00h
str_TheGoalieLinesAre:                          ; string 'The goalie lines are not complete on '; used by
                                                ; CheckTeamLines
        db 054h,068h,065h,020h,067h,06Fh,061h,06Ch,069h,065h,020h,06Ch,069h,06Eh,065h,073h
        db 020h,061h,072h,065h,020h,06Eh,06Fh,074h,020h,063h,06Fh,06Dh,070h,06Ch,065h,074h
        db 065h,020h,06Fh,06Eh,020h,00h
str_TheExtraAttackerLines:                      ; string 'The extra attacker lines are not complete on '; used
                                                ; by CheckTeamLines
        db 054h,068h,065h,020h,065h,078h,074h,072h,061h,020h,061h,074h,074h,061h,063h,06Bh
        db 065h,072h,020h,06Ch,069h,06Eh,065h,073h,020h,061h,072h,065h,020h,06Eh,06Fh,074h
        db 020h,063h,06Fh,06Dh,070h,06Ch,065h,074h,065h,020h,06Fh,06Eh,020h,00h
str_NotEnoughPlayers:                           ; string 'There are not enough players on '; used by
                                                ; CheckTeamLines
        db 054h,068h,065h,072h,065h,020h,061h,072h,065h,020h,06Eh,06Fh,074h,020h,065h,06Eh
        db 06Fh,075h,067h,068h,020h,070h,06Ch,061h,079h,065h,072h,073h,020h,06Fh,06Eh,020h
        db 00h
str_NotEnoughGoalies:                           ; string 'There are not enough goalies on '; used by
                                                ; CheckTeamLines
        db 054h,068h,065h,072h,065h,020h,061h,072h,065h,020h,06Eh,06Fh,074h,020h,065h,06Eh
        db 06Fh,075h,067h,068h,020h,067h,06Fh,061h,06Ch,069h,065h,073h,020h,06Fh,06Eh,020h
        db 00h
str_NotEnoughForwards:                          ; string 'There are not enough forwards on '; used by
                                                ; CheckTeamLines
        db 054h,068h,065h,072h,065h,020h,061h,072h,065h,020h,06Eh,06Fh,074h,020h,065h,06Eh
        db 06Fh,075h,067h,068h,020h,066h,06Fh,072h,077h,061h,072h,064h,073h,020h,06Fh,06Eh
        db 020h,00h
str_NotEnoughDefence:                           ; string 'There are not enough defence on '; used by
                                                ; CheckTeamLines
        db 054h,068h,065h,072h,065h,020h,061h,072h,065h,020h,06Eh,06Fh,074h,020h,065h,06Eh
        db 06Fh,075h,067h,068h,020h,064h,065h,066h,065h,06Eh,063h,065h,020h,06Fh,06Eh,020h
        db 00h,00h
