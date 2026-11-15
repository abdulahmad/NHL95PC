; The master-database prompt, and the message about the player files.
bits 32
%include "hockey.inc"
section s_C7DEA progbits alloc noexec write align=1
extern str_Yes, str_No4, str_MasterDatabasesFor, str_MustBeMergedFirst, str_DoYouWantTo4
global msg_MasterDB_arg, msg_MasterDB, str_PlayersDatabasesFor, str_MustBeUpdatedFirst, str_DoYouWantTo6, playerdbsmsg, btn_MasterDB
global str_MasterDatabasesFor2, str_MustBeCompletelyMerged, str_PlayersDatabasesMustBe, str_DoYouWishTo
msg_MasterDB:
dd str_MasterDatabasesFor
msg_MasterDB_arg:
db 00h,00h,00h,00h
dd str_MustBeMergedFirst
dd str_DoYouWantTo4
str_PlayersDatabasesFor:
db 050h,06Ch,061h,079h,065h,072h,073h,020h,064h,061h,074h,061h,062h,061h,073h,065h
db 073h,020h,066h,06Fh,072h,00h
str_MustBeUpdatedFirst:
db 06Dh,075h,073h,074h,020h,062h,065h,020h,075h,070h,064h,061h,074h,065h,064h,020h
db 066h,069h,072h,073h,074h,021h,00h
str_DoYouWantTo6:
db 044h,06Fh,020h,079h,06Fh,075h,020h,077h,061h,06Eh,074h,020h,074h,06Fh,020h,075h
db 070h,064h,061h,074h,065h,03Fh,00h
playerdbsmsg:
dd str_PlayersDatabasesFor
db 00h,00h,00h,00h
dd str_MustBeUpdatedFirst
dd str_DoYouWantTo6
btn_MasterDB:
db 010h,00h,00h,00h,05Ch,00h,00h,00h,050h,00h,00h,00h,014h,00h,00h,00h
db 00h,00h,00h,00h,05h,00h,00h,00h
dd str_Yes
db 0F0h,0FFh,0FFh,0FFh,05Ch,00h,00h,00h,050h,00h,00h,00h,014h,00h,00h,00h
db 00h,00h,00h,00h,06h,00h,00h,00h
dd str_No4
str_MasterDatabasesFor2:
db 04Dh,061h,073h,074h,065h,072h,020h,064h,061h,074h,061h,062h,061h,073h,065h,073h
db 020h,066h,06Fh,072h,00h
str_MustBeCompletelyMerged:
db 06Dh,075h,073h,074h,020h,062h,065h,020h,063h,06Fh,06Dh,070h,06Ch,065h,074h,065h
db 06Ch,079h,020h,06Dh,065h,072h,067h,065h,064h,020h,061h,06Eh,064h,00h
str_PlayersDatabasesMustBe:
db 070h,06Ch,061h,079h,065h,072h,073h,020h,064h,061h,074h,061h,062h,061h,073h,065h
db 073h,020h,06Dh,075h,073h,074h,020h,062h,065h,020h,075h,070h,064h,061h,074h,065h
db 064h,020h,066h,069h,072h,073h,074h,021h,00h
str_DoYouWishTo:
db 044h,06Fh,020h,079h,06Fh,075h,020h,077h,069h,073h,068h,020h,074h,06Fh,020h,064h
db 06Fh,020h,06Dh,065h,072h,067h,065h,020h,061h,06Eh,064h,020h,075h,070h,064h,061h
db 074h,065h,03Fh,02Eh,00h
