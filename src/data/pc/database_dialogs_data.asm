; Initialised data of pc/database_dialogs (src/pc/database_dialogs).
bits 32
%include "hockey.inc"
section s_D1084 progbits alloc noexec write align=1
extern dblistcur, dblistorig, dblisttemp
global dbdlgrects, dbtablists, str_ConfirmDeletionOfThe2, deldbmsg
dbdlgrects:                                     ; [16] hit rects x1, y1, x2, y2 (rows at +0A0h); used by
                                                ; DbDialogHitTest, DbDialogLoop, DrawDbDialog ...
        db 0Eh,00h,00h,00h
        db 033h,00h,00h,00h
        db 01Ah,00h,00h,00h
        db 03Dh,00h,00h,00h,0Eh,00h,00h,00h,094h,00h,00h,00h,01Ah,00h,00h,00h
        db 09Eh,00h,00h,00h,019h,00h,00h,00h,0ACh,00h,00h,00h,04Bh,00h,00h,00h
        db 0BCh,00h,00h,00h,060h,00h,00h,00h,0ACh,00h,00h,00h,092h,00h,00h,00h
        db 0BCh,00h,00h,00h,0A7h,00h,00h,00h,0ACh,00h,00h,00h,0D9h,00h,00h,00h
        db 0BCh,00h,00h,00h,099h,00h,00h,00h,038h,00h,00h,00h,0E4h,00h,00h,00h
        db 049h,00h,00h,00h,099h,00h,00h,00h,050h,00h,00h,00h,0E4h,00h,00h,00h
        db 061h,00h,00h,00h,099h,00h,00h,00h,068h,00h,00h,00h,0E4h,00h,00h,00h
        db 079h,00h,00h,00h
        db 0Fh,00h,00h,00h
        db 041h,00h,00h,00h
        db 019h,00h,00h,00h
        db 090h,00h,00h,00h
        db 086h,00h,00h,00h
        db 09h,00h,00h,00h
        db 0E9h,00h,00h,00h
        db 01Ah,00h,00h,00h
        db 025h,00h,00h,00h
        db 03Bh,00h,00h,00h
        db 082h,00h,00h,00h
        db 046h,00h,00h,00h,025h,00h,00h,00h,04Bh,00h,00h,00h,082h,00h,00h,00h
        db 056h,00h,00h,00h,025h,00h,00h,00h,05Bh,00h,00h,00h,082h,00h,00h,00h
        db 066h,00h,00h,00h,025h,00h,00h,00h,06Bh,00h,00h,00h,082h,00h,00h,00h
        db 076h,00h,00h,00h,025h,00h,00h,00h,07Bh,00h,00h,00h,082h,00h,00h,00h
        db 086h,00h,00h,00h,025h,00h,00h,00h,08Bh,00h,00h,00h,082h,00h,00h,00h
        db 096h,00h,00h,00h
dbtablists:                                     ; list struct per tab (cur, orig, temp); used by DbDialogLoop,
                                                ; DrawDbDialog
        dd dblistcur
        dd dblistorig
        dd dblisttemp
str_ConfirmDeletionOfThe2:                      ; "Confirm deletion of the database:" string literal
        db 043h,06Fh,06Eh,066h,069h,072h,06Dh,020h,064h,065h,06Ch,065h,074h,069h,06Fh,06Eh
        db 020h,06Fh,066h,020h,074h,068h,065h,020h,064h,061h,074h,061h,062h,061h,073h,065h
        db 03Ah,00h
deldbmsg:                                       ; "Confirm deletion of the database:" <name>; used by
                                                ; DeleteSelectedDb
        dd str_ConfirmDeletionOfThe2
        db 00h,00h,00h,00h,00h,00h
