; Play-Off mode messages for disk space and for a setup that failed.
bits 32
%include "hockey.inc"
section s_D2864 progbits alloc noexec write align=1
extern str_SDD3
global msg_PODiskSpace_arg, dword_D2884, poseriesfmt, msg_POExists, msg_POSetupError, msg_POSettingUp, msg_PODiskSpace, podbsizes
global str_ThereIsAlreadyA3, str_DoYouWantTo7, str_AnErrorWasEncountered, str_SettingUpThePlayoffs, str_PlayoffSeriesHasNot, str_Created, str_PleaseWait3, str_SettingUpPlayOffs
global str_InsufficientDiskSpaceTo5, str_APlayoffSeriesYou
podbsizes:
db 026h,00h,00h,00h,01Eh,00h,00h,00h,0Fh,00h,00h,00h,03h,00h,00h,00h
db 015h,00h,00h,00h,023h,00h,00h,00h,08h,00h,00h,00h,02h,00h,00h,00h
dword_D2884:
db 01h,00h,00h,00h,00h,00h,00h,00h
poseriesfmt:
dd str_SDD3
str_ThereIsAlreadyA3:
db 054h,068h,065h,072h,065h,020h,069h,073h,020h,061h,06Ch,072h,065h,061h,064h,079h
db 020h,061h,020h,050h,06Ch,061h,079h,02Dh,04Fh,066h,066h,020h,077h,069h,074h,068h
db 020h,074h,068h,061h,074h,020h,06Eh,061h,06Dh,065h,021h,00h
str_DoYouWantTo7:
db 044h,06Fh,020h,079h,06Fh,075h,020h,077h,061h,06Eh,074h,020h,074h,06Fh,020h,072h
db 065h,070h,06Ch,061h,063h,065h,020h,069h,074h,020h,077h,069h,074h,068h,020h,061h
db 020h,06Eh,065h,077h,020h,050h,06Ch,061h,079h,02Dh,04Fh,066h,066h,03Fh,00h
msg_POExists:
dd str_ThereIsAlreadyA3
dd str_DoYouWantTo7
str_AnErrorWasEncountered:
db 041h,06Eh,020h,045h,072h,072h,06Fh,072h,020h,057h,061h,073h,020h,045h,06Eh,063h
db 06Fh,075h,06Eh,074h,065h,072h,065h,064h,020h,057h,068h,069h,06Ch,065h,00h
str_SettingUpThePlayoffs:
db 053h,065h,074h,074h,069h,06Eh,067h,020h,055h,070h,020h,054h,068h,065h,020h,050h
db 06Ch,061h,079h,06Fh,066h,066h,073h,02Eh,00h
str_PlayoffSeriesHasNot:
db 050h,06Ch,061h,079h,06Fh,066h,066h,020h,053h,065h,072h,069h,065h,073h,020h,048h
db 061h,073h,020h,04Eh,06Fh,074h,020h,042h,065h,065h,06Eh,00h
str_Created:
db 043h,072h,065h,061h,074h,065h,064h,02Eh,00h
msg_POSetupError:
dd str_AnErrorWasEncountered
dd str_SettingUpThePlayoffs
dd str_PlayoffSeriesHasNot
dd str_Created
str_PleaseWait3:
db 050h,06Ch,065h,061h,073h,065h,020h,057h,061h,069h,074h,02Eh,00h
str_SettingUpPlayOffs:
db 053h,065h,074h,074h,069h,06Eh,067h,020h,055h,070h,020h,050h,06Ch,061h,079h,02Dh
db 04Fh,066h,066h,073h,02Eh,00h
msg_POSettingUp:
dd str_PleaseWait3
dd str_SettingUpPlayOffs
str_InsufficientDiskSpaceTo5:
db 049h,06Eh,073h,075h,066h,066h,069h,063h,069h,065h,06Eh,074h,020h,064h,069h,073h
db 06Bh,020h,073h,070h,061h,063h,065h,020h,074h,06Fh,020h,073h,065h,074h,075h,070h
db 00h
str_APlayoffSeriesYou:
db 061h,020h,050h,06Ch,061h,079h,06Fh,066h,066h,020h,053h,065h,072h,069h,065h,073h
db 02Ch,020h,079h,06Fh,075h,020h,072h,065h,071h,075h,069h,072h,065h,020h,00h
msg_PODiskSpace_arg:
db 058h,058h,058h,058h,020h,04Bh,062h,079h,074h,065h,073h,020h,06Fh,066h,020h,066h
db 072h,065h,065h,020h,064h,069h,073h,06Bh,020h,073h,070h,061h,063h,065h,02Eh,020h
db 020h,020h,020h,00h
msg_PODiskSpace:
dd str_InsufficientDiskSpaceTo5
dd str_APlayoffSeriesYou
dd msg_PODiskSpace_arg
