; Initialised data of front/summary (src/front/summary).
bits 32
%include "hockey.inc"
section s_C70EC progbits alloc noexec write align=1
global str_NoScoring, str_NoPenalties, str_gsScore, str_gsShots, str_gsPowerPlay, str_gsPenalties, str_gsFaceoffsWon, str_gsBodyChecks
global str_gsAttackZone, str_gsPassing, str_gsOneTimers, str_gsPPMinutes, str_gsPPShots, str_gsOffFaceoffs, gamestatlabels
str_NoScoring:                                  ; string 'No Scoring.'; used by GameSummaryScreen_period
        db 04Eh,06Fh,020h,053h,063h,06Fh,072h,069h,06Eh,067h,02Eh,00h
str_NoPenalties:                                ; string 'No Penalties.'; used by GameSummaryScreen_period
        db 04Eh,06Fh,020h,050h,065h,06Eh,061h,06Ch,074h,069h,065h,073h,02Eh,00h,00h,00h
str_gsScore:                                    ; string 'Score'
        db 053h,063h,06Fh,072h,065h,00h
str_gsShots:                                    ; string 'Shots'
        db 053h,068h,06Fh,074h,073h,00h
str_gsPowerPlay:                                ; string 'Power play'
        db 050h,06Fh,077h,065h,072h,020h,070h,06Ch,061h,079h,00h
str_gsPenalties:                                ; string 'Penalties'
        db 050h,065h,06Eh,061h,06Ch,074h,069h,065h,073h,00h
str_gsFaceoffsWon:                              ; string 'Faceoffs won'
        db 046h,061h,063h,065h,06Fh,066h,066h,073h,020h,077h,06Fh,06Eh,00h
str_gsBodyChecks:                               ; string 'Body checks'
        db 042h,06Fh,064h,079h,020h,063h,068h,065h,063h,06Bh,073h,00h
str_gsAttackZone:                               ; string 'Attack zone'
        db 041h,074h,074h,061h,063h,06Bh,020h,07Ah,06Fh,06Eh,065h,00h
str_gsPassing:                                  ; string 'Passing'
        db 050h,061h,073h,073h,069h,06Eh,067h,00h
str_gsOneTimers:                                ; string 'One Timers'
        db 04Fh,06Eh,065h,020h,054h,069h,06Dh,065h,072h,073h,00h
str_gsPPMinutes:                                ; string 'Power Play Minutes'
        db 050h,06Fh,077h,065h,072h,020h,050h,06Ch,061h,079h,020h,04Dh,069h,06Eh,075h,074h
        db 065h,073h,00h
str_gsPPShots:                                  ; string 'Power Play Shots'
        db 050h,06Fh,077h,065h,072h,020h,050h,06Ch,061h,079h,020h,053h,068h,06Fh,074h,073h
        db 00h
str_gsOffFaceoffs:                              ; string 'Offensive Faceoffs won'
        db 04Fh,066h,066h,065h,06Eh,073h,069h,076h,065h,020h,046h,061h,063h,065h,06Fh,066h
        db 066h,073h,020h,077h,06Fh,06Eh,00h
gamestatlabels:                                 ; 12 GameStatsScreen row labels; used by GameStatsScreen
        dd str_gsScore
        dd str_gsShots
        dd str_gsOneTimers
        dd str_gsPowerPlay
        dd str_gsPPMinutes
        dd str_gsPPShots
        dd str_gsPenalties
        dd str_gsFaceoffsWon
        dd str_gsOffFaceoffs
        dd str_gsBodyChecks
        dd str_gsAttackZone
        dd str_gsPassing
