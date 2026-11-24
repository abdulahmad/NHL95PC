; Strings and constants of front/team_db (src/front/team_db), in link order.
bits 32
%include "hockey.inc"
section s_C0A18 progbits alloc noexec write align=1
global str_teams, str_fe1, str_fe2, str_fe3, str_fe4, str_fe5, str_fe7, str_fe8
global str_feB1, str_feB5, str_feB8, str_feD, str_feE, str_feF, str_feG, str_feH
global str_feI, str_feL, str_feM, str_feN, str_feO, str_feP, str_feQ, str_key
global str_fe9, str_feA, str_att, str_feB, str_feC, str_season, str_feJ, str_feK
global str_career, str_backslash3, str_GsummaryDb2
str_teams:                                      ; string 'teams'; used by LoadGameTeams
        db 074h,065h,061h,06Dh,073h,00h
str_fe1:                                        ; FatalError code "1" (key_team_db); used by LoadGameTeams
        db 031h,00h
str_fe2:                                        ; FatalError code "2" (key_team_db); used by LoadGameTeams
        db 032h,00h
str_fe3:                                        ; FatalError code "3" (key_team_db); used by LoadGameTeams
        db 033h,00h
str_fe4:                                        ; FatalError code "4" (key_team_db); used by LoadGameTeams
        db 034h,00h
str_fe5:                                        ; FatalError code "5" (key_team_db); used by LoadGameTeams
        db 035h,00h
str_fe7:                                        ; FatalError code "7" (key_team_db); used by LoadGameTeams
        db 037h,00h
str_fe8:                                        ; FatalError code "8" (key_team_db); used by LoadGameTeams
        db 038h,00h
str_feB1:                                       ; FatalError code "B1" (key_team_db); used by InitGameSummary
        db 042h,031h,00h
str_feB5:                                       ; FatalError code "B5" (key_team_db); used by InitGameSummary
        db 042h,035h,00h
str_feB8:                                       ; FatalError code "B8" (key_team_db); used by InitGameSummary
        db 042h,038h,00h
str_feD:                                        ; FatalError code "D" (key_team_db); used by ReadPlayerRecord
        db 044h,00h
str_feE:                                        ; FatalError code "E" (key_team_db); used by ReadPlayerRecord
        db 045h,00h
str_feF:                                        ; FatalError code "F" (key_team_db); used by ReadPlayerRecord
        db 046h,00h
str_feG:                                        ; FatalError code "G" (key_team_db); used by ReadPlayerRecord
        db 047h,00h
str_feH:                                        ; FatalError code "H" (key_team_db); used by ReadPlayerRecord
        db 048h,00h
str_feI:                                        ; FatalError code "I" (key_team_db); used by ReadPlayerRecord
        db 049h,00h
str_feL:                                        ; FatalError code "L" (key_team_db); used by OpenPlayerDBs,
                                                ; ReadPlayerRecord
        db 04Ch,00h
str_feM:                                        ; FatalError code "M" (key_team_db); used by OpenPlayerDBs,
                                                ; ReadPlayerRecord
        db 04Dh,00h
str_feN:                                        ; FatalError code "N" (key_team_db); used by ReadPlayerRecord
        db 04Eh,00h
str_feO:                                        ; FatalError code "O" (key_team_db); used by ReadPlayerRecord
        db 04Fh,00h
str_feP:                                        ; FatalError code "P" (key_team_db); used by ReadPlayerRecord
        db 050h,00h
str_feQ:                                        ; FatalError code "Q" (key_team_db); used by ReadPlayerRecord
        db 051h,00h
str_key:                                        ; string 'key'; used by OpenPlayerDBs
        db 06Bh,065h,079h,00h
str_fe9:                                        ; FatalError code "9" (key_team_db); used by OpenPlayerDBs
        db 039h,00h
str_feA:                                        ; FatalError code "A" (key_team_db); used by OpenPlayerDBs
        db 041h,00h
str_att:                                        ; string 'att'; used by OpenPlayerDBs
        db 061h,074h,074h,00h
str_feB:                                        ; FatalError code "B" (key_team_db); used by OpenPlayerDBs
        db 042h,00h
str_feC:                                        ; FatalError code "C" (key_team_db); used by OpenPlayerDBs
        db 043h,00h
str_season:                                     ; string 'season'; used by OpenPlayerDBs
        db 073h,065h,061h,073h,06Fh,06Eh,00h
str_feJ:                                        ; FatalError code "J" (key_team_db); used by OpenPlayerDBs
        db 04Ah,00h
str_feK:                                        ; FatalError code "K" (key_team_db); used by OpenPlayerDBs
        db 04Bh,00h
str_career:                                     ; string 'career'; used by OpenPlayerDBs
        db 063h,061h,072h,065h,065h,072h,00h
str_backslash3:                                 ; string '\\'; used by MakeGSummaryPath
        db 05Ch,00h
str_GsummaryDb2:                                ; string 'gsummary.db'; used by MakeGSummaryPath
        db 067h,073h,075h,06Dh,06Dh,061h,072h,079h,02Eh,064h,062h,00h,00h,00h,00h
