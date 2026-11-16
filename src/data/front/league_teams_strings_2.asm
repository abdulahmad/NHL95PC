; The messages shown while copying files and while creating a league.
bits 32
%include "hockey.inc"
section s_C7BD1 progbits alloc noexec write align=1
extern str_CopyingDatabasesFor
global msg_Copying_arg, msg_Copying, str_CreatingLeague, msg_CreatingLeague, str_ThatFloppyDiskHas, str_OldCopyOfThe
msg_Copying:                                    ; message box line table; used by MsgCopyingDatabases
        dd str_CopyingDatabasesFor
msg_Copying_arg:                                ; msg_Copying fill-in string pointer for the message box; used
                                                ; by MsgCopyingDatabases
        db 00h,00h,00h,00h
str_CreatingLeague:                             ; "Creating league." string literal
        db 043h,072h,065h,061h,074h,069h,06Eh,067h,020h,06Ch,065h,061h,067h,075h,065h,02Eh
        db 00h
msg_CreatingLeague:                             ; message box line table; used by CreateNewLeague
        dd str_CreatingLeague
str_ThatFloppyDiskHas:                          ; "That floppy disk has an" string literal
        db 054h,068h,061h,074h,020h,066h,06Ch,06Fh,070h,070h,079h,020h,064h,069h,073h,06Bh
        db 020h,068h,061h,073h,020h,061h,06Eh,00h
str_OldCopyOfThe:                               ; "old copy of the league" string literal
        db 06Fh,06Ch,064h,020h,063h,06Fh,070h,079h,020h,06Fh,066h,020h,074h,068h,065h,020h
        db 06Ch,065h,061h,067h,075h,065h,00h
