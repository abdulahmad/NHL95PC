; League setup prompts: who controls the league, import and export, and removing a team.
bits 32
%include "hockey.inc"
section s_C7868 progbits alloc noexec write align=1
extern str_Yes, str_No4, str_DoYouReallyWantToRemove
global str_SelectATeamTo, str_SelectATeamTo2, str_WhoWillControlThe, str_MustBeImportedFrom, str_MustBeExportedTo, forceexportmsg
global notexportedmsg
global insavegamemsg, importdiskmsg, removeteammsg, removeteambtns, str_PutDiskWithLeague, str_ImportInAnyDrive, str_ErrorWhileImportingLeague
global importerrmsg, str_ErrorWhileExportingLeague, str_IncorrectPassword, unk_C7965, str_HasNotBeenImported, str_DoYouWantTo3, forceexportbtns, str_DoYouWantToExport
global str_ToAFloppyDisk, exportmsg, yesnobtns, str_TheLeague, str_BeforeAGameCanBePlayed, leaguediskmsg, str_TheLeague2, str_AlreadyExistsFor
global lgexistsformsg, str_HasNotBeenExported, str_IsInASave, str_AndCanNotBe, str_TheGameIsFinished, str_CopyingDatabasesFor
removeteammsg:
dd str_DoYouReallyWantToRemove
db 00h,00h,00h,00h
removeteambtns:
db 010h,00h,00h,00h,03Ch,00h,00h,00h,028h,00h,00h,00h,014h,00h,00h,00h
db 00h,00h,00h,00h,05h,00h,00h,00h
dd str_Yes
db 0F0h,0FFh,0FFh,0FFh,03Ch,00h,00h,00h,028h,00h,00h,00h,014h,00h,00h,00h
db 00h,00h,00h,00h,06h,00h,00h,00h
dd str_No4
str_SelectATeamTo:
db 053h,065h,06Ch,065h,063h,074h,020h,061h,020h,074h,065h,061h,06Dh,020h,074h,06Fh
db 020h,070h,06Ch,061h,079h,02Eh,00h
str_SelectATeamTo2:
db 053h,065h,06Ch,065h,063h,074h,020h,061h,020h,074h,065h,061h,06Dh,020h,074h,06Fh
db 020h,065h,078h,070h,06Fh,072h,074h,02Eh,00h
str_PutDiskWithLeague:
db 050h,075h,074h,020h,064h,069h,073h,06Bh,020h,077h,069h,074h,068h,020h,06Ch,065h
db 061h,067h,075h,065h,020h,074h,06Fh,00h
str_ImportInAnyDrive:
db 069h,06Dh,070h,06Fh,072h,074h,020h,069h,06Eh,020h,061h,06Eh,079h,020h,064h,072h
db 069h,076h,065h,02Eh,00h
importdiskmsg:
dd str_PutDiskWithLeague
dd str_ImportInAnyDrive
str_ErrorWhileImportingLeague:
db 045h,072h,072h,06Fh,072h,020h,077h,068h,069h,06Ch,065h,020h,069h,06Dh,070h,06Fh
db 072h,074h,069h,06Eh,067h,020h,06Ch,065h,061h,067h,075h,065h,021h,00h
importerrmsg:
dd str_ErrorWhileImportingLeague
str_ErrorWhileExportingLeague:
db 045h,072h,072h,06Fh,072h,020h,077h,068h,069h,06Ch,065h,020h,065h,078h,070h,06Fh
db 072h,074h,069h,06Eh,067h,020h,06Ch,065h,061h,067h,075h,065h,021h,00h
dd str_ErrorWhileExportingLeague
str_IncorrectPassword:
db 049h,06Eh,063h,06Fh,072h,072h,065h,063h,074h,020h,070h,061h,073h,073h,077h,06Fh
db 072h,064h,021h,00h
unk_C7965:
dd str_IncorrectPassword
str_WhoWillControlThe:
db 057h,068h,06Fh,020h,077h,069h,06Ch,06Ch,020h,063h,06Fh,06Eh,074h,072h,06Fh,06Ch
db 020h,074h,068h,065h,020h,06Ch,065h,061h,067h,075h,065h,03Fh,00h
str_HasNotBeenImported:
db 068h,061h,073h,020h,06Eh,06Fh,074h,020h,062h,065h,065h,06Eh,020h,069h,06Dh,070h
db 06Fh,072h,074h,065h,064h,020h,066h,06Fh,072h,00h
str_DoYouWantTo3:
db 044h,06Fh,020h,079h,06Fh,075h,020h,077h,061h,06Eh,074h,020h,074h,06Fh,020h,066h
db 06Fh,072h,063h,065h,020h,061h,06Eh,020h,065h,078h,070h,06Fh,072h,074h,03Fh,00h
forceexportmsg:
db 00h,00h,00h,00h
dd str_HasNotBeenImported
db 00h,00h,00h,00h
dd str_DoYouWantTo3
forceexportbtns:
db 010h,00h,00h,00h,078h,00h,00h,00h,028h,00h,00h,00h,014h,00h,00h,00h
db 00h,00h,00h,00h,05h,00h,00h,00h
dd str_Yes
db 0F0h,0FFh,0FFh,0FFh,078h,00h,00h,00h,028h,00h,00h,00h,014h,00h,00h,00h
db 00h,00h,00h,00h,06h,00h,00h,00h
dd str_No4
str_DoYouWantToExport:
db 044h,06Fh,020h,079h,06Fh,075h,020h,077h,061h,06Eh,074h,020h,074h,06Fh,020h,065h
db 078h,070h,06Fh,072h,074h,00h
str_ToAFloppyDisk:
db 074h,06Fh,020h,061h,020h,066h,06Ch,06Fh,070h,070h,079h,020h,064h,069h,073h,06Bh
db 03Fh,00h
exportmsg:
dd str_DoYouWantToExport
db 00h,00h,00h,00h
dd str_ToAFloppyDisk
yesnobtns:
db 010h,00h,00h,00h,044h,00h,00h,00h,060h,00h,00h,00h,014h,00h,00h,00h
db 00h,00h,00h,00h,05h,00h,00h,00h
dd str_Yes
db 0F0h,0FFh,0FFh,0FFh,044h,00h,00h,00h,060h,00h,00h,00h,014h,00h,00h,00h
db 00h,00h,00h,00h,06h,00h,00h,00h
dd str_No4
str_TheLeague:
db 054h,068h,065h,020h,06Ch,065h,061h,067h,075h,065h,00h
str_BeforeAGameCanBePlayed:
db 062h,065h,066h,06Fh,072h,065h,020h,061h,020h,067h,061h,06Dh,065h,020h,063h,061h
db 06Eh,020h,062h,065h,020h,070h,06Ch,061h,079h,065h,064h,021h,00h
str_MustBeImportedFrom:
db 06Dh,075h,073h,074h,020h,062h,065h,020h,069h,06Dh,070h,06Fh,072h,074h,065h,064h
db 020h,066h,072h,06Fh,06Dh,020h,074h,068h,065h,020h,064h,069h,073h,06Bh,020h,066h
db 06Fh,072h,00h
str_MustBeExportedTo:
db 06Dh,075h,073h,074h,020h,062h,065h,020h,065h,078h,070h,06Fh,072h,074h,065h,064h
db 020h,074h,06Fh,020h,074h,068h,065h,020h,064h,069h,073h,06Bh,020h,066h,06Fh,072h
db 00h
leaguediskmsg:
dd str_TheLeague
db 00h,00h,00h,00h
db 00h,00h,00h,00h
db 00h,00h,00h,00h
dd str_BeforeAGameCanBePlayed
str_TheLeague2:
db 054h,068h,065h,020h,06Ch,065h,061h,067h,075h,065h,00h
str_AlreadyExistsFor:
db 061h,06Ch,072h,065h,061h,064h,079h,020h,065h,078h,069h,073h,074h,073h,020h,066h
db 06Fh,072h,00h
lgexistsformsg:
dd str_TheLeague2
db 00h,00h,00h,00h
dd str_AlreadyExistsFor
db 00h,00h,00h,00h
str_HasNotBeenExported:
db 068h,061h,073h,020h,06Eh,06Fh,074h,020h,062h,065h,065h,06Eh,020h,065h,078h,070h
db 06Fh,072h,074h,065h,064h,020h,066h,06Fh,072h,020h,074h,068h,065h,020h,06Ch,065h
db 061h,067h,075h,065h,00h
notexportedmsg:
db 00h,00h,00h,00h
dd str_HasNotBeenExported
db 00h,00h,00h,00h
str_IsInASave:
db 069h,073h,020h,069h,06Eh,020h,061h,020h,073h,061h,076h,065h,020h,067h,061h,06Dh
db 065h,020h,069h,06Eh,020h,074h,068h,065h,020h,06Ch,065h,061h,067h,075h,065h,00h
str_AndCanNotBe:
db 061h,06Eh,064h,020h,063h,061h,06Eh,020h,06Eh,06Fh,074h,020h,062h,065h,020h,069h
db 06Dh,070h,06Fh,072h,074h,065h,064h,020h,075h,06Eh,074h,069h,06Ch,00h
str_TheGameIsFinished:
db 074h,068h,065h,020h,067h,061h,06Dh,065h,020h,069h,073h,020h,066h,069h,06Eh,069h
db 073h,068h,065h,064h,021h,00h
insavegamemsg:
db 00h,00h,00h,00h
dd str_IsInASave
db 00h,00h,00h,00h
dd str_AndCanNotBe
dd str_TheGameIsFinished
str_CopyingDatabasesFor:
db 043h,06Fh,070h,079h,069h,06Eh,067h,020h,064h,061h,074h,061h,062h,061h,073h,065h
db 073h,020h,066h,06Fh,072h,00h
