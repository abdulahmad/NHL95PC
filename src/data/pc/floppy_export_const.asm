; Strings and constants of pc/floppy_export (src/pc/floppy_export), in link order.
bits 32
%include "hockey.inc"
section s_C1914 progbits alloc noexec write align=1
global str_wildcard, str_ID, str_SET, str_GAME3, str_SAV3, str_02d3, str_L1, str_L22
global str_A5, str_DriveB, str_Game2, str_Sav2
str_wildcard:                                   ; string '*'; used by ExportTeamToFloppy
        db 02Ah,00h
str_ID:                                         ; string 'ID'; used by ExportTeamToFloppy
        db 049h,044h,00h
str_SET:                                        ; string '.SET'; used by ImportDbs, ImportMasterLeague
        db 02Eh,053h,045h,054h,00h
str_GAME3:                                      ; string 'GAME'; used by ImportDbs, ImportMasterLeague
        db 047h,041h,04Dh,045h,00h
str_SAV3:                                       ; string 'SAV'; used by ImportMasterLeague
        db 053h,041h,056h,00h
str_02d3:                                       ; string '.%02d'; used by ExportDbs, ImportPlayerTeam
        db 02Eh,025h,030h,032h,064h,00h
str_L1:                                         ; string 'l1'; used by ImportDbs
        db 06Ch,031h,00h
str_L22:                                        ; string 'l2'; used by ImportDbs
        db 06Ch,032h,00h,00h
str_A5:                                         ; string 'A'
        db 041h,00h
str_DriveB:                                     ; Drive button text: B
        db 042h,00h
str_Game2:                                      ; string 'game'; used by ReadLeagueInfo
        db 067h,061h,06Dh,065h,00h
str_Sav2:                                       ; string '.sav'; used by ReadLeagueInfo
        db 02Eh,073h,061h,076h,00h
