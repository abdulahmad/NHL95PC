; BSS of pc/database_dialogs (src/pc/database_dialogs).
bits 32
%include "hockey.inc"
section s_EC6B8 nobits alloc noexec write align=1
global dblistcur, dblisttemp, dblisttempnames, dblistorig, curdbname
dblistcur:                                      ; list struct (58h): count, sel +4, top +8, last visible +0Ch,
                                                ; names[16] +10h; current DB; used by DeleteSelectedDb,
                                                ; DrawDbDialog, ScanDbFiles
        resb 4
        resb 4
        resb 4
        resb 4
        resb 72
dblisttemp:                                     ; temporary (.DBX) list struct; used by DrawDbDialog,
                                                ; OpenSelectedDb, ScanDbFiles
        resb 4
        resb 4
        resb 4
        resb 4
dblisttempnames:                                ; dblisttemp names[16] (own label, nosplit operand); used by
                                                ; OpenSelectedDb, ScanDbFiles
        resb 72
dblistorig:                                     ; original (.ORG) list struct; used by DeleteSelectedDb,
                                                ; DrawDbDialog, ScanDbFiles
        resb 4
        resb 4
        resb 4
        resb 4
        resb 72
curdbname:                                      ; current database name ("Current" or .DBX name); used by
                                                ; DrawDatabaseName, MenuSaveDbs, MenuSaveDbsAs ...
        resb 32
