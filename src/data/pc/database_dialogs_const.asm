; Strings and constants of pc/database_dialogs (src/pc/database_dialogs), in link order.
bits 32
%include "hockey.inc"
section s_C3014 progbits alloc noexec write align=1
global str_DSBOX, str_DbBut, str_None2, str_Del2, str_Open3, str_Can2, str_Noar2, str_Up2
global str_Down2, str_Arro2, str_Dbno, str_Dbcu, str_Dbtm, str_Dbor, str_Db3, str_CURRENT
global str_Org, str_ORIGINAL, str_Dbx, str_Open4, str_Delete2, str_Done2, str_Current4, str_Original2
global str_Temporary, str_Dbdialog, str_Pdbx, str_Pointer12, str_DBX2, str_Buf2
str_DSBOX:                                      ; string 'DSBOX'; used by InputDialog
        db 044h,053h,042h,04Fh,058h,00h,00h,00h
str_DbBut:                                      ; string 'db_but'; used by LoadDbDialogShapes
        db 064h,062h,05Fh,062h,075h,074h,00h
str_None2:                                      ; string 'none'; used by LoadDbDialogShapes
        db 06Eh,06Fh,06Eh,065h,00h
str_Del2:                                       ; string 'del '; used by LoadDbDialogShapes
        db 064h,065h,06Ch,020h,00h
str_Open3:                                      ; string 'open'; used by LoadDbDialogShapes
        db 06Fh,070h,065h,06Eh,00h
str_Can2:                                       ; string 'can '; used by LoadDbDialogShapes
        db 063h,061h,06Eh,020h,00h
str_Noar2:                                      ; string 'noar'; used by LoadDbDialogShapes
        db 06Eh,06Fh,061h,072h,00h
str_Up2:                                        ; string 'up '; used by LoadDbDialogShapes
        db 075h,070h,020h,020h,00h
str_Down2:                                      ; string 'down'; used by LoadDbDialogShapes
        db 064h,06Fh,077h,06Eh,00h
str_Arro2:                                      ; string 'arro'; used by LoadDbDialogShapes
        db 061h,072h,072h,06Fh,00h
str_Dbno:                                       ; string 'dbno'; used by LoadDbDialogShapes
        db 064h,062h,06Eh,06Fh,00h
str_Dbcu:                                       ; string 'dbcu'; used by LoadDbDialogShapes
        db 064h,062h,063h,075h,00h
str_Dbtm:                                       ; string 'dbtm'; used by LoadDbDialogShapes
        db 064h,062h,074h,06Dh,00h
str_Dbor:                                       ; string 'dbor'; used by LoadDbDialogShapes
        db 064h,062h,06Fh,072h,00h
str_Db3:                                        ; string '*.db'; used by ScanDbFiles
        db 02Ah,02Eh,064h,062h,00h
str_CURRENT:                                    ; string 'CURRENT'; used by ScanDbFiles
        db 043h,055h,052h,052h,045h,04Eh,054h,00h
str_Org:                                        ; string '*.org'; used by ScanDbFiles
        db 02Ah,02Eh,06Fh,072h,067h,00h
str_ORIGINAL:                                   ; string 'ORIGINAL'; used by ScanDbFiles
        db 04Fh,052h,049h,047h,049h,04Eh,041h,04Ch,00h
str_Dbx:                                        ; string '*.dbx'; used by ScanDbFiles
        db 02Ah,02Eh,064h,062h,078h,00h
str_Open4:                                      ; string 'Open'; used by DrawDbDialogButtons
        db 04Fh,070h,065h,06Eh,00h
str_Delete2:                                    ; string 'Delete'; used by DrawDbDialogButtons
        db 044h,065h,06Ch,065h,074h,065h,00h
str_Done2:                                      ; string 'Done'; used by DrawDbDialogButtons
        db 044h,06Fh,06Eh,065h,00h
str_Current4:                                   ; string 'Current'; used by DrawDbDialogButtons,
                                                ; OpenSelectedDb
        db 043h,075h,072h,072h,065h,06Eh,074h,00h
str_Original2:                                  ; string 'Original'; used by DrawDbDialogButtons,
                                                ; OpenSelectedDb
        db 04Fh,072h,069h,067h,069h,06Eh,061h,06Ch,00h
str_Temporary:                                  ; string 'Temporary'; used by DrawDbDialogButtons
        db 054h,065h,06Dh,070h,06Fh,072h,061h,072h,079h,00h
str_Dbdialog:                                   ; string 'dbdialog'; used by DrawDbDialog
        db 064h,062h,064h,069h,061h,06Ch,06Fh,067h,00h
str_Pdbx:                                       ; string 'pdbx'; used by DrawDbDialog
        db 070h,064h,062h,078h,00h
str_Pointer12:                                  ; string 'Pointer'; used by DbDialogLoop
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h
str_DBX2:                                       ; string '.DBX'; used by DeleteSelectedDb, OpenSelectedDb
        db 02Eh,044h,042h,058h,00h
str_Buf2:                                       ; string 'buf'; used by MenuOpenDatabase
        db 062h,075h,066h,00h
