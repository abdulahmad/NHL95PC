; Strings and constants of front/menu (src/front/menu), in link order.
bits 32
%include "hockey.inc"
section s_C0B54 progbits alloc noexec write align=1
global str_PointerMenu, str_menubuff, str_PacificDivision, str_CentralDivision, str_NortheastDivision, str_AtlanticDivision, str_Season3, str_Playoff3
global str_RegSeason, str_Playoff4, str_Actual, str_Accumulated, str_embnhl, str_embscup, str_careerdb, str_seasondb
global str_carteamsdb, str_teamsdb, str_sfh, str_shape
str_PointerMenu:                                ; string; used by RunMenu, RunPlayerPickMenu, RunTeamPickMenu
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h
str_menubuff:                                   ; string; used by RunMenu, RunPlayerPickMenu, RunTeamPickMenu
        db 06Dh,065h,06Eh,075h,062h,075h,066h,066h,00h,00h,00h,00h
str_PacificDivision:                            ; "Pacific Division" string literal
        db 050h,061h,063h,069h,066h,069h,063h,020h,044h,069h,076h,069h,073h,069h,06Fh,06Eh
        db 00h
str_CentralDivision:                            ; "Central Division" string literal
        db 043h,065h,06Eh,074h,072h,061h,06Ch,020h,044h,069h,076h,069h,073h,069h,06Fh,06Eh
        db 00h
str_NortheastDivision:                          ; "Northeast Division" string literal
        db 04Eh,06Fh,072h,074h,068h,065h,061h,073h,074h,020h,044h,069h,076h,069h,073h,069h
        db 06Fh,06Eh,00h
str_AtlanticDivision:                           ; "Atlantic Division" string literal
        db 041h,074h,06Ch,061h,06Eh,074h,069h,063h,020h,044h,069h,076h,069h,073h,069h,06Fh
        db 06Eh,00h
str_Season3:                                    ; "Season:" string literal
        db 053h,065h,061h,073h,06Fh,06Eh,03Ah,00h
str_Playoff3:                                   ; "Playoff:" string literal
        db 050h,06Ch,061h,079h,06Fh,066h,066h,03Ah,00h
str_RegSeason:                                  ; "reg. season" string literal
        db 072h,065h,067h,02Eh,020h,073h,065h,061h,073h,06Fh,06Eh,00h
str_Playoff4:                                   ; "playoff " string literal
        db 070h,06Ch,061h,079h,06Fh,066h,066h,020h,020h,020h,020h,00h
str_Actual:                                     ; "actual " string literal
        db 061h,063h,074h,075h,061h,06Ch,020h,020h,020h,020h,020h,00h
str_Accumulated:                                ; "accumulated" string literal
        db 061h,063h,063h,075h,06Dh,075h,06Ch,061h,074h,065h,064h,00h
str_embnhl:                                     ; string
        db 065h,06Dh,062h,06Eh,068h,06Ch,00h
str_embscup:                                    ; string
        db 065h,06Dh,062h,073h,063h,075h,070h,00h
str_careerdb:                                   ; string
        db 063h,061h,072h,065h,065h,072h,02Eh,064h,062h,00h
str_seasondb:                                   ; string
        db 073h,065h,061h,073h,06Fh,06Eh,02Eh,064h,062h,00h
str_carteamsdb:                                 ; string
        db 063h,061h,072h,074h,065h,061h,06Dh,073h,02Eh,064h,062h,00h
str_teamsdb:                                    ; string
        db 074h,065h,061h,06Dh,073h,02Eh,064h,062h,00h
str_sfh:                                        ; string; used by LoadShapeByTag
        db 073h,066h,068h,00h
str_shape:                                      ; string; used by LoadShapeByTag
        db 073h,068h,061h,070h,065h,00h,00h,00h
