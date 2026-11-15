; Edit Rosters actions for dressing and scratching a player.
bits 32
%include "hockey.inc"
section s_D056C progbits alloc noexec write align=1
extern MenuShowPlayerStats, ScratchPlayer, DressPlayer, str_ScratchPlayer2
global menuact_dbdress, menuact_dbscratch, str_ShowPlayerStatistics2, unk_D05AF, str_LineEditor5, str_Roster4, str_PlayerStatistics4
menuact_dbdress:
        dd DressPlayer
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
        db 068h,00h,00h,00h,024h,00h,00h,00h
        dd str_ScratchPlayer2
menuact_dbscratch:
        dd ScratchPlayer
        db 00h,00h,00h,00h,00h,00h,00h,00h
str_ShowPlayerStatistics2:
        db 053h,068h,06Fh,077h,020h,050h,06Ch,061h,079h,065h,072h,020h,053h,074h,061h,074h
        db 069h,073h,074h,069h,063h,073h,00h
unk_D05AF:
        db 00h,00h,00h,00h,00h,00h,00h,00h,09Ch,00h,00h,00h,012h,00h,00h,00h
        dd str_ShowPlayerStatistics2
        dd MenuShowPlayerStats
        db 00h,00h,00h,00h,00h,00h,00h,00h
str_LineEditor5:
        db 04Ch,069h,06Eh,065h,020h,045h,064h,069h,074h,06Fh,072h,00h
str_Roster4:
        db 052h,06Fh,073h,074h,065h,072h,00h
str_PlayerStatistics4:
        db 050h,06Ch,061h,079h,065h,072h,020h,053h,074h,061h,074h,069h,073h,074h,069h,063h
        db 073h,00h
