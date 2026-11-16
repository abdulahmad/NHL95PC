; Messages while merging an old copy, a new floppy, or an imported league.
bits 32
%include "hockey.inc"
section s_C7C1D progbits alloc noexec write align=1
extern str_Yes, str_No4, str_ThatFloppyDiskHas, str_OldCopyOfThe
global str_IsAlreadyMerged, str_HasNotBeenMerged, oldcopymsg, newfloppymsg, importtypemsg
global lgexistsmsg, str_AreYouSureYou3, str_UseANewFloppy, newfloppybtns, str_ImportMasterCopyOf, str_ImportForPlayerOn, str_Master, str_Player3
global importtypebtns, str_CanNotImportMaster, str_TheLeagueAlreadyExists, str_TheLeague3, mergestatemsg, str_MasterDatabasesFor, str_MustBeMergedFirst, str_DoYouWantTo4
oldcopymsg:                                     ; "That floppy disk has an old copy of the league" <name>;
                                                ; used by ImportPlayerTeam, LocateTeamDbCopy
        dd str_ThatFloppyDiskHas
        dd str_OldCopyOfThe
        db 00h,00h,00h,00h
str_AreYouSureYou3:                             ; "Are you sure you want to" string literal
        db 041h,072h,065h,020h,079h,06Fh,075h,020h,073h,075h,072h,065h,020h,079h,06Fh,075h
        db 020h,077h,061h,06Eh,074h,020h,074h,06Fh,00h
str_UseANewFloppy:                              ; "use a new floppy disk?" string literal
        db 075h,073h,065h,020h,061h,020h,06Eh,065h,077h,020h,066h,06Ch,06Fh,070h,070h,079h
        db 020h,064h,069h,073h,06Bh,03Fh,00h
newfloppymsg:                                   ; "Are you sure you want to use a new floppy disk?"; used by
                                                ; ExportTeamToFloppy
        dd str_AreYouSureYou3
        dd str_UseANewFloppy
newfloppybtns:                                  ; Yes / No; used by ExportTeamToFloppy
        db 010h,00h,00h,00h,03Ch,00h,00h,00h,028h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_Yes
        db 0F0h,0FFh,0FFh,0FFh,03Ch,00h,00h,00h,028h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,06h,00h,00h,00h
        dd str_No4
str_ImportMasterCopyOf:                         ; "Import master copy of league or" string literal
        db 049h,06Dh,070h,06Fh,072h,074h,020h,06Dh,061h,073h,074h,065h,072h,020h,063h,06Fh
        db 070h,079h,020h,06Fh,066h,020h,06Ch,065h,061h,067h,075h,065h,020h,06Fh,072h,00h
str_ImportForPlayerOn:                          ; "import for player on floppy disk?" string literal
        db 069h,06Dh,070h,06Fh,072h,074h,020h,066h,06Fh,072h,020h,070h,06Ch,061h,079h,065h
        db 072h,020h,06Fh,06Eh,020h,066h,06Ch,06Fh,070h,070h,079h,020h,064h,069h,073h,06Bh
        db 03Fh,00h
str_Master:                                     ; "Master" string literal
        db 04Dh,061h,073h,074h,065h,072h,00h
str_Player3:                                    ; "Player" string literal
        db 050h,06Ch,061h,079h,065h,072h,00h
importtypemsg:                                  ; "Import master copy of league or import for player on floppy
                                                ; disk?"; used by ImportDbs
        dd str_ImportMasterCopyOf
        dd str_ImportForPlayerOn
importtypebtns:                                 ; Master / Player; used by ImportDbs
        db 010h,00h,00h,00h,03Ch,00h,00h,00h,060h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_Master
        db 0F0h,0FFh,0FFh,0FFh,03Ch,00h,00h,00h,060h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,06h,00h,00h,00h
        dd str_Player3
str_CanNotImportMaster:                         ; "Can not import master league!" string literal
        db 043h,061h,06Eh,020h,06Eh,06Fh,074h,020h,069h,06Dh,070h,06Fh,072h,074h,020h,06Dh
        db 061h,073h,074h,065h,072h,020h,06Ch,065h,061h,067h,075h,065h,021h,00h
str_TheLeagueAlreadyExists:                     ; "The league already exists!" string literal
        db 054h,068h,065h,020h,06Ch,065h,061h,067h,075h,065h,020h,061h,06Ch,072h,065h,061h
        db 064h,079h,020h,065h,078h,069h,073h,074h,073h,021h,00h
lgexistsmsg:                                    ; "Can not import master league! The league already exists!";
                                                ; used by ImportMasterLeague
        dd str_CanNotImportMaster
        dd str_TheLeagueAlreadyExists
str_TheLeague3:                                 ; "The league" string literal
        db 054h,068h,065h,020h,06Ch,065h,061h,067h,075h,065h,00h
str_IsAlreadyMerged:                            ; string 'is already merged.'; used by MergeLeagueFiles
        db 069h,073h,020h,061h,06Ch,072h,065h,061h,064h,079h,020h,06Dh,065h,072h,067h,065h
        db 064h,02Eh,00h
str_HasNotBeenMerged:                           ; string 'has not been merged.'; used by UpdateTeamDbs
        db 068h,061h,073h,020h,06Eh,06Fh,074h,020h,062h,065h,065h,06Eh,020h,06Dh,065h,072h
        db 067h,065h,064h,02Eh,00h
mergestatemsg:                                  ; "The league" <name> "is already merged." / "has not been
                                                ; merged."; used by MergeLeagueFiles, UpdateTeamDbs
        dd str_TheLeague3
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h
str_MasterDatabasesFor:                         ; "Master databases for" string literal
        db 04Dh,061h,073h,074h,065h,072h,020h,064h,061h,074h,061h,062h,061h,073h,065h,073h
        db 020h,066h,06Fh,072h,00h
str_MustBeMergedFirst:                          ; "must be merged first!" string literal
        db 06Dh,075h,073h,074h,020h,062h,065h,020h,06Dh,065h,072h,067h,065h,064h,020h,066h
        db 069h,072h,073h,074h,021h,00h
str_DoYouWantTo4:                               ; "Do you want to merge?" string literal
        db 044h,06Fh,020h,079h,06Fh,075h,020h,077h,061h,06Eh,074h,020h,074h,06Fh,020h,06Dh
        db 065h,072h,067h,065h,03Fh,00h
