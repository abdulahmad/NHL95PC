; The trade deadline, generating the schedule, and the disk-full messages.
bits 32
%include "hockey.inc"
section s_C8C26 progbits alloc noexec write align=1
extern str_TheTradingDeadlineHas, str_NoMoreTradingIs
global str_KbytesFreeLine, playoffbuf, leaguedbsizes, LgGameSetFlag, msg_TradeDeadline, msg_GenSchedule, msg_NoDiskSpace, str_GeneratingRandomSchedule
global str_PleaseWait2, str_InsufficientDiskSpaceTo4, str_ANewLeagueYou, str_DiskDriveFullCan, msg_DiskFull
msg_TradeDeadline:
        dd str_TheTradingDeadlineHas
        dd str_NoMoreTradingIs
        db 00h,00h
str_GeneratingRandomSchedule:
        db 047h,065h,06Eh,065h,072h,061h,074h,069h,06Eh,067h,020h,072h,061h,06Eh,064h,06Fh
        db 06Dh,020h,073h,063h,068h,065h,064h,075h,06Ch,065h,02Eh,00h
str_PleaseWait2:
        db 050h,06Ch,065h,061h,073h,065h,020h,077h,061h,069h,074h,02Eh,00h
msg_GenSchedule:
        dd str_GeneratingRandomSchedule
        dd str_PleaseWait2
playoffbuf:
        db 00h,00h,00h,00h,00h,00h,00h
str_InsufficientDiskSpaceTo4:
        db 049h,06Eh,073h,075h,066h,066h,069h,063h,069h,065h,06Eh,074h,020h,064h,069h,073h
        db 06Bh,020h,073h,070h,061h,063h,065h,020h,074h,06Fh,020h,073h,065h,074h,075h,070h
        db 00h
str_ANewLeagueYou:
        db 061h,020h,06Eh,065h,077h,020h,04Ch,065h,061h,067h,075h,065h,02Ch,020h,079h,06Fh
        db 075h,020h,072h,065h,071h,075h,069h,072h,065h,020h,00h
str_KbytesFreeLine:
        db 058h,058h,058h,058h,020h,04Bh,062h,079h,074h,065h,073h,020h,06Fh,066h,020h,066h
        db 072h,065h,065h,020h,064h,069h,073h,06Bh,020h,073h,070h,061h,063h,065h,02Eh,020h
        db 020h,020h,020h,00h
msg_NoDiskSpace:
        dd str_InsufficientDiskSpaceTo4
        dd str_ANewLeagueYou
        dd str_KbytesFreeLine
str_DiskDriveFullCan:
        db 044h,069h,073h,06Bh,020h,064h,072h,069h,076h,065h,020h,046h,075h,06Ch,06Ch,02Eh
        db 020h,043h,061h,06Eh,020h,06Eh,06Fh,074h,020h,063h,072h,065h,061h,074h,065h,020h
        db 061h,020h,06Eh,065h,077h,020h,06Ch,065h,061h,067h,075h,065h,02Eh,00h
msg_DiskFull:
        dd str_DiskDriveFullCan
leaguedbsizes:
        db 026h,00h,00h,00h,01Eh,00h,00h,00h,0Fh,00h,00h,00h,03h,00h,00h,00h
        db 015h,00h,00h,00h,023h,00h,00h,00h,08h,00h,00h,00h,026h,00h,00h,00h
        db 01Eh,00h,00h,00h,0Fh,00h,00h,00h,03h,00h,00h,00h,015h,00h,00h,00h
        db 023h,00h,00h,00h,08h,00h,00h,00h,026h,00h,00h,00h,01Eh,00h,00h,00h
        db 0Fh,00h,00h,00h,03h,00h,00h,00h,015h,00h,00h,00h,023h,00h,00h,00h
        db 08h,00h,00h,00h,026h,00h,00h,00h,01Eh,00h,00h,00h,0Fh,00h,00h,00h
        db 03h,00h,00h,00h,015h,00h,00h,00h,023h,00h,00h,00h,08h,00h,00h,00h
        db 026h,00h,00h,00h,01Eh,00h,00h,00h,0Fh,00h,00h,00h,03h,00h,00h,00h
        db 015h,00h,00h,00h,023h,00h,00h,00h,08h,00h,00h,00h,026h,00h,00h,00h
        db 01Eh,00h,00h,00h,0Fh,00h,00h,00h,03h,00h,00h,00h,015h,00h,00h,00h
        db 023h,00h,00h,00h,08h,00h,00h,00h,026h,00h,00h,00h,01Eh,00h,00h,00h
        db 0Fh,00h,00h,00h,03h,00h,00h,00h,015h,00h,00h,00h,023h,00h,00h,00h
        db 08h,00h,00h,00h,026h,00h,00h,00h,01Eh,00h,00h,00h,0Fh,00h,00h,00h
        db 03h,00h,00h,00h,015h,00h,00h,00h,023h,00h,00h,00h,08h,00h,00h,00h
        db 026h,00h,00h,00h,01Eh,00h,00h,00h,0Fh,00h,00h,00h,03h,00h,00h,00h
        db 015h,00h,00h,00h,023h,00h,00h,00h,08h,00h,00h,00h,026h,00h,00h,00h
        db 01Eh,00h,00h,00h,0Fh,00h,00h,00h,03h,00h,00h,00h,015h,00h,00h,00h
        db 023h,00h,00h,00h,08h,00h,00h,00h,026h,00h,00h,00h,01Eh,00h,00h,00h
        db 0Fh,00h,00h,00h,03h,00h,00h,00h,015h,00h,00h,00h,023h,00h,00h,00h
        db 08h,00h,00h,00h,026h,00h,00h,00h,01Eh,00h,00h,00h,0Fh,00h,00h,00h
        db 03h,00h,00h,00h,015h,00h,00h,00h,023h,00h,00h,00h,08h,00h,00h,00h
        db 026h,00h,00h,00h,01Eh,00h,00h,00h,0Fh,00h,00h,00h,03h,00h,00h,00h
        db 015h,00h,00h,00h,023h,00h,00h,00h,08h,00h,00h,00h,026h,00h,00h,00h
        db 01Eh,00h,00h,00h,0Fh,00h,00h,00h,03h,00h,00h,00h,015h,00h,00h,00h
        db 023h,00h,00h,00h,08h,00h,00h,00h,026h,00h,00h,00h,01Eh,00h,00h,00h
        db 0Fh,00h,00h,00h,03h,00h,00h,00h,015h,00h,00h,00h,023h,00h,00h,00h
        db 08h,00h,00h,00h,026h,00h,00h,00h,01Eh,00h,00h,00h,0Fh,00h,00h,00h
        db 03h,00h,00h,00h,015h,00h,00h,00h,023h,00h,00h,00h,08h,00h,00h,00h
        db 026h,00h,00h,00h,01Eh,00h,00h,00h,0Fh,00h,00h,00h,03h,00h,00h,00h
        db 015h,00h,00h,00h,023h,00h,00h,00h,08h,00h,00h,00h,026h,00h,00h,00h
        db 01Eh,00h,00h,00h,0Fh,00h,00h,00h,03h,00h,00h,00h,015h,00h,00h,00h
        db 023h,00h,00h,00h,08h,00h,00h,00h,026h,00h,00h,00h,01Eh,00h,00h,00h
        db 0Fh,00h,00h,00h,03h,00h,00h,00h,015h,00h,00h,00h,023h,00h,00h,00h
        db 08h,00h,00h,00h,026h,00h,00h,00h,01Eh,00h,00h,00h,0Fh,00h,00h,00h
        db 03h,00h,00h,00h,015h,00h,00h,00h,023h,00h,00h,00h,08h,00h,00h,00h
        db 026h,00h,00h,00h,01Eh,00h,00h,00h,0Fh,00h,00h,00h,03h,00h,00h,00h
        db 015h,00h,00h,00h,023h,00h,00h,00h,08h,00h,00h,00h,026h,00h,00h,00h
        db 01Eh,00h,00h,00h,0Fh,00h,00h,00h,03h,00h,00h,00h,015h,00h,00h,00h
        db 023h,00h,00h,00h,08h,00h,00h,00h,026h,00h,00h,00h,01Eh,00h,00h,00h
        db 0Fh,00h,00h,00h,03h,00h,00h,00h,015h,00h,00h,00h,023h,00h,00h,00h
        db 08h,00h,00h,00h,026h,00h,00h,00h,01Eh,00h,00h,00h,0Fh,00h,00h,00h
        db 03h,00h,00h,00h,015h,00h,00h,00h,023h,00h,00h,00h,08h,00h,00h,00h
        db 026h,00h,00h,00h,01Eh,00h,00h,00h,0Fh,00h,00h,00h,03h,00h,00h,00h
        db 015h,00h,00h,00h,023h,00h,00h,00h,08h,00h,00h,00h,026h,00h,00h,00h
        db 01Eh,00h,00h,00h,0Fh,00h,00h,00h,03h,00h,00h,00h,015h,00h,00h,00h
        db 023h,00h,00h,00h,08h,00h,00h,00h,026h,00h,00h,00h,01Eh,00h,00h,00h
        db 0Fh,00h,00h,00h,03h,00h,00h,00h,015h,00h,00h,00h,023h,00h,00h,00h
        db 08h,00h,00h,00h,01h,00h,00h,00h,02h,00h,00h,00h
LgGameSetFlag:
        db 01h,00h,00h,00h,00h,00h,00h,00h,00h,00h
