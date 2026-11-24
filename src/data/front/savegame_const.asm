; Strings and constants of front/savegame (src/front/savegame), in link order.
bits 32
%include "hockey.inc"
section s_C38F8 progbits alloc noexec write align=1
global str_GsummaryDb4, str_AGameYouRequire, str_DemoNhl, str_H2, str_h3, str_Gsummary3, str_H4, str_h5
global str_h6, str_h7, str_AGameYouRequire2, str_GameSav5, str_H1, str_Db4, str_Sav3, str_A32
global str_Pointer22, str_Savegame, str_Prmt, str_Dialog, str_Nhl3, str_Err1, str_SDD3
str_GsummaryDb4:                                ; string 'gsummary.db'; used by MenuSaveGame
        db 067h,073h,075h,06Dh,06Dh,061h,072h,079h,02Eh,064h,062h,00h
str_AGameYouRequire:                            ; string 'a game, you require %3d Kbytes'; used by
                                                ; MenuSaveGame
        db 061h,020h,067h,061h,06Dh,065h,02Ch,020h,079h,06Fh,075h,020h,072h,065h,071h,075h
        db 069h,072h,065h,020h,025h,033h,064h,020h,04Bh,062h,079h,074h,065h,073h,00h
str_DemoNhl:                                    ; string 'demo.nhl'; used by MenuSaveGame
        db 064h,065h,06Dh,06Fh,02Eh,06Eh,068h,06Ch,00h
str_H2:                                         ; string 'h2'; used by MenuSaveGame
        db 068h,032h,00h
str_h3:                                         ; string 'h3': MenuSaveGame fatal error tag; used by
                                                ; MenuSaveGame
        db 068h,033h,00h
str_Gsummary3:                                  ; string 'gsummary'; used by MenuSaveGame
        db 067h,073h,075h,06Dh,06Dh,061h,072h,079h,00h
str_H4:                                         ; string 'h4'; used by MenuSaveGame
        db 068h,034h,00h
str_h5:                                         ; string 'h5': MenuSaveGame fatal error tag; used by
                                                ; MenuSaveGame
        db 068h,035h,00h
str_h6:                                         ; string 'h6': MenuSaveGame fatal error tag; used by
                                                ; MenuSaveGame
        db 068h,036h,00h
str_h7:                                         ; string 'h7': MenuSaveGame fatal error tag; used by
                                                ; MenuSaveGame
        db 068h,037h,00h
str_AGameYouRequire2:                           ; string 'a game, you require %3d Kbytes'; used by
                                                ; MenuSaveGame
        db 061h,020h,067h,061h,06Dh,065h,02Ch,020h,079h,06Fh,075h,020h,072h,065h,071h,075h
        db 069h,072h,065h,020h,025h,033h,064h,020h,04Bh,062h,079h,074h,065h,073h,00h
str_GameSav5:                                   ; string 'game.sav'; used by MenuSaveGame
        db 067h,061h,06Dh,065h,02Eh,073h,061h,076h,00h
str_H1:                                         ; string 'h1'; used by MenuSaveGame
        db 068h,031h,00h
str_Db4:                                        ; string '.db'; used by MenuSaveGame
        db 02Eh,064h,062h,00h
str_Sav3:                                       ; string '.sav'; used by MenuSaveGame
        db 02Eh,073h,061h,076h,00h
str_A32:                                        ; string 'A3'; used by MenuSaveGame
        db 041h,033h,00h
str_Pointer22:                                  ; string 'pointer'; used by SaveGameNameDlg
        db 070h,06Fh,069h,06Eh,074h,065h,072h,00h
str_Savegame:                                   ; string 'savegame'; used by SaveGameNameDlg
        db 073h,061h,076h,065h,067h,061h,06Dh,065h,00h
str_Prmt:                                       ; string 'prmt'; used by SaveGameNameDlg
        db 070h,072h,06Dh,074h,00h
str_Dialog:                                     ; string 'dialog'; used by SaveGameNameDlg
        db 064h,069h,061h,06Ch,06Fh,067h,00h
str_Nhl3:                                       ; string '.nhl'; used by SaveGameNameDlg
        db 02Eh,06Eh,068h,06Ch,00h
str_Err1:                                       ; string 'err1'; used by SaveGameNameDlg
        db 065h,072h,072h,031h,00h,00h,00h,00h
str_SDD3:                                       ; string '%s %d - %d'
        db 025h,073h,020h,025h,064h,020h,02Dh,020h,025h,064h,00h
