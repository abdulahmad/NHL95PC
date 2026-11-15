; The messages that ask for the league disk, and that say the disk is the wrong one.
bits 32
%include "hockey.inc"
section s_C7569 progbits alloc noexec write align=1
extern str_Yes, str_No4, str_CanNotReadDatabases
global str_FromLeague, msg_InsertDisk_arg, msg_WrongDisk_arg, lgreaderrmsg, str_ThatNameHasAlready, msg_NameTaken
global str_DiskError, str_AbortRetryOrIgnore, str_ThatFloppyDiskIs, str_InsertDiskFor, str_InAnyDriveAnd, str_PressAKey, notforlgmsg, msg_InsertDisk
global str_ThatDiskIsFor, str_AreYouSureYou2, msg_WrongDisk, btn_WrongDisk, str_ThereAreNoLeagues, str_ThereIsAlreadyA, str_DoYouWantTo2
lgreaderrmsg:
        dd str_CanNotReadDatabases
        db 00h,00h,00h,00h
str_ThatNameHasAlready:
        db 054h,068h,061h,074h,020h,06Eh,061h,06Dh,065h,020h,068h,061h,073h,020h,061h,06Ch
        db 072h,065h,061h,064h,079h,020h,062h,065h,065h,06Eh,020h,075h,073h,065h,064h,021h
        db 00h
msg_NameTaken:
        dd str_ThatNameHasAlready
str_DiskError:
        db 044h,069h,073h,06Bh,020h,045h,072h,072h,06Fh,072h,00h
str_AbortRetryOrIgnore:
        db 041h,062h,06Fh,072h,074h,02Ch,020h,052h,065h,074h,072h,079h,020h,06Fh,072h,020h
        db 049h,067h,06Eh,06Fh,072h,065h,00h
        dd str_DiskError
        dd str_AbortRetryOrIgnore
str_ThatFloppyDiskIs:
        db 054h,068h,061h,074h,020h,066h,06Ch,06Fh,070h,070h,079h,020h,064h,069h,073h,06Bh
        db 020h,069h,073h,020h,06Eh,06Fh,074h,020h,066h,06Fh,072h,00h
str_InsertDiskFor:
        db 049h,06Eh,073h,065h,072h,074h,020h,064h,069h,073h,06Bh,020h,066h,06Fh,072h,00h
str_InAnyDriveAnd:
        db 069h,06Eh,020h,061h,06Eh,079h,020h,064h,072h,069h,076h,065h,020h,061h,06Eh,064h
        db 00h
str_PressAKey:
        db 070h,072h,065h,073h,073h,020h,061h,020h,06Bh,065h,079h,00h
notforlgmsg:
        dd str_ThatFloppyDiskIs
        db 00h,00h,00h,00h
msg_InsertDisk:
        dd str_InsertDiskFor
msg_InsertDisk_arg:
        db 00h,00h,00h,00h
        dd str_InAnyDriveAnd
        dd str_PressAKey
str_ThatDiskIsFor:
        db 054h,068h,061h,074h,020h,064h,069h,073h,06Bh,020h,069h,073h,020h,066h,06Fh,072h
        db 00h
str_FromLeague:
        db 020h,066h,072h,06Fh,06Dh,020h,074h,068h,065h,020h,06Ch,065h,061h,067h,075h,065h
        db 020h,00h
str_AreYouSureYou2:
        db 041h,072h,065h,020h,079h,06Fh,075h,020h,073h,075h,072h,065h,020h,079h,06Fh,075h
        db 020h,077h,061h,06Eh,074h,020h,074h,06Fh,020h,06Fh,076h,065h,072h,077h,072h,069h
        db 074h,065h,020h,069h,074h,03Fh,00h
msg_WrongDisk:
        dd str_ThatDiskIsFor
msg_WrongDisk_arg:
        db 00h,00h,00h,00h
        dd str_AreYouSureYou2
btn_WrongDisk:
        db 010h,00h,00h,00h,050h,00h,00h,00h,060h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_Yes
        db 0F0h,0FFh,0FFh,0FFh,050h,00h,00h,00h,060h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,06h,00h,00h,00h
        dd str_No4
        db 020h,066h,072h,06Fh,06Dh,020h,074h,068h,065h,020h,00h
str_ThereAreNoLeagues:
        db 054h,068h,065h,072h,065h,020h,061h,072h,065h,020h,06Eh,06Fh,020h,06Ch,065h,061h
        db 067h,075h,065h,073h,021h,00h
        dd str_ThereAreNoLeagues
str_ThereIsAlreadyA:
        db 054h,068h,065h,072h,065h,020h,069h,073h,020h,061h,06Ch,072h,065h,061h,064h,079h
        db 020h,061h,020h,06Ch,065h,061h,067h,075h,065h,020h,077h,069h,074h,068h,020h,074h
        db 068h,061h,074h,020h,06Eh,061h,06Dh,065h,021h,00h
str_DoYouWantTo2:
        db 044h,06Fh,020h,079h,06Fh,075h,020h,077h,061h,06Eh,074h,020h,074h,06Fh,020h,072h
        db 065h,070h,06Ch,061h,063h,065h,020h,069h,074h,020h,077h,069h,074h,068h,020h,061h
        db 020h,06Eh,065h,077h,020h,06Ch,065h,061h,067h,075h,065h,03Fh,00h
