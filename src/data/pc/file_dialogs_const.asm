; Strings and constants of pc/file_dialogs (src/pc/file_dialogs), in link order.
bits 32
%include "hockey.inc"
section s_C1430 progbits alloc noexec write align=1
global str_NHL, str_PO2, str_LP, str_OpenBut, str_None, str_Del, str_Open, str_Can
global str_Noar, str_Up, str_Down, str_Arro, str_Gtno, str_Gtex, str_Gtlp, str_Gtpo
global str_Buf, str_Nhl, str_fek1, str_GsummaryDb3, str_fek2, str_fek3, str_fek4, str_fek5
global str_fek6, str_fek7, str_fek8, str_feh7, str_Gsummary, str_Sav, str_Db2, str_feA1
global str_PoGameSav, str_fel1, str_feA2, str_LpGameSav, str_fel2, str_Open2, str_Delete, str_Done
global str_Exhibition, str_Playoffs, str_League, str_Lp, str_Po, str_Nhl2, str_Dialogbx, str_Dbox
global str_Pointer5, str_fec6, str_Po2, str_ScheduleDb2, str_Lp2, str_GameSet3, str_fed2, str_fedd2
global str_fed3, str_fed4, str_GameSav3
str_NHL:                                        ; string '.NHL'; used by savefileexts
        db 02Eh,04Eh,048h,04Ch,00h
str_PO2:                                        ; string '.PO'; used by savefileexts
        db 02Eh,050h,04Fh,00h
str_LP:                                         ; string '.LP'; used by savefileexts
        db 02Eh,04Ch,050h,00h
str_OpenBut:                                    ; string 'open_but'; used by LoadFileDlgShapes
        db 06Fh,070h,065h,06Eh,05Fh,062h,075h,074h,00h
str_None:                                       ; string 'none'; used by LoadFileDlgShapes
        db 06Eh,06Fh,06Eh,065h,00h
str_Del:                                        ; string 'del '; used by LoadFileDlgShapes
        db 064h,065h,06Ch,020h,00h
str_Open:                                       ; string 'open'; used by LoadFileDlgShapes
        db 06Fh,070h,065h,06Eh,00h
str_Can:                                        ; string 'can '; used by LoadFileDlgShapes
        db 063h,061h,06Eh,020h,00h
str_Noar:                                       ; string 'noar'; used by LoadFileDlgShapes
        db 06Eh,06Fh,061h,072h,00h
str_Up:                                         ; string 'up '; used by LoadFileDlgShapes
        db 075h,070h,020h,020h,00h
str_Down:                                       ; string 'down'; used by LoadFileDlgShapes
        db 064h,06Fh,077h,06Eh,00h
str_Arro:                                       ; string 'arro'; used by LoadFileDlgShapes
        db 061h,072h,072h,06Fh,00h
str_Gtno:                                       ; string 'gtno'; used by LoadFileDlgShapes
        db 067h,074h,06Eh,06Fh,00h
str_Gtex:                                       ; string 'gtex'; used by LoadFileDlgShapes
        db 067h,074h,065h,078h,00h
str_Gtlp:                                       ; string 'gtlp'; used by LoadFileDlgShapes
        db 067h,074h,06Ch,070h,00h
str_Gtpo:                                       ; string 'gtpo'; used by LoadFileDlgShapes
        db 067h,074h,070h,06Fh,00h
str_Buf:                                        ; string 'buf'; used by MenuOpenSaved
        db 062h,075h,066h,00h
str_Nhl:                                        ; string '.nhl'; used by MenuOpenSaved, SelectSavedFile
        db 02Eh,06Eh,068h,06Ch,00h
str_fek1:                                       ; FatalError code (file_dialogs); used by MenuOpenSaved
        db 06Bh,031h,00h
str_GsummaryDb3:                                ; string 'gsummary.db'; used by MenuOpenSaved
        db 067h,073h,075h,06Dh,06Dh,061h,072h,079h,02Eh,064h,062h,00h
str_fek2:                                       ; FatalError code (file_dialogs); used by MenuOpenSaved
        db 06Bh,032h,00h
str_fek3:                                       ; FatalError code (file_dialogs); used by MenuOpenSaved
        db 06Bh,033h,00h
str_fek4:                                       ; FatalError code (file_dialogs); used by MenuOpenSaved
        db 06Bh,034h,00h
str_fek5:                                       ; FatalError code (file_dialogs); used by MenuOpenSaved
        db 06Bh,035h,00h
str_fek6:                                       ; FatalError code (file_dialogs); used by MenuOpenSaved
        db 06Bh,036h,00h
str_fek7:                                       ; FatalError code (file_dialogs); used by MenuOpenSaved
        db 06Bh,037h,00h
str_fek8:                                       ; FatalError code (file_dialogs); used by MenuOpenSaved
        db 06Bh,038h,00h
str_feh7:                                       ; FatalError code (file_dialogs); used by MenuOpenSaved
        db 068h,037h,00h
str_Gsummary:                                   ; string 'gsummary'; used by MenuOpenSaved
        db 067h,073h,075h,06Dh,06Dh,061h,072h,079h,00h
str_Sav:                                        ; string '.sav'; used by MenuOpenSaved
        db 02Eh,073h,061h,076h,00h
str_Db2:                                        ; string '.db'; used by MenuOpenSaved
        db 02Eh,064h,062h,00h
str_feA1:                                       ; FatalError code (file_dialogs); used by MenuOpenSaved
        db 041h,031h,00h
str_PoGameSav:                                  ; string '.po\\game.sav'; used by MenuOpenSaved
        db 02Eh,070h,06Fh,05Ch,067h,061h,06Dh,065h,02Eh,073h,061h,076h,00h
str_fel1:                                       ; FatalError code (file_dialogs); used by MenuOpenSaved
        db 06Ch,031h,00h
str_feA2:                                       ; FatalError code (file_dialogs); used by MenuOpenSaved
        db 041h,032h,00h
str_LpGameSav:                                  ; string '.lp\\game.sav'; used by MenuOpenSaved
        db 02Eh,06Ch,070h,05Ch,067h,061h,06Dh,065h,02Eh,073h,061h,076h,00h
str_fel2:                                       ; FatalError code (file_dialogs); used by MenuOpenSaved
        db 06Ch,032h,00h
str_Open2:                                      ; string 'Open'; used by DrawFileDlgTabs
        db 04Fh,070h,065h,06Eh,00h
str_Delete:                                     ; string 'Delete'; used by DrawFileDlgTabs
        db 044h,065h,06Ch,065h,074h,065h,00h
str_Done:                                       ; string 'Done'; used by DrawFileDlgTabs
        db 044h,06Fh,06Eh,065h,00h
str_Exhibition:                                 ; string 'Exhibition'; used by DrawFileDlgTabs
        db 045h,078h,068h,069h,062h,069h,074h,069h,06Fh,06Eh,00h
str_Playoffs:                                   ; string 'Playoffs'; used by DrawFileDlgTabs
        db 050h,06Ch,061h,079h,06Fh,066h,066h,073h,00h
str_League:                                     ; string 'League'; used by DrawFileDlgTabs
        db 04Ch,065h,061h,067h,075h,065h,00h
str_Lp:                                         ; string '*.lp'; used by ScanSavedGames
        db 02Ah,02Eh,06Ch,070h,00h
str_Po:                                         ; string '*.po'; used by ScanSavedGames
        db 02Ah,02Eh,070h,06Fh,00h
str_Nhl2:                                       ; string '*.nhl'; used by ScanSavedGames
        db 02Ah,02Eh,06Eh,068h,06Ch,00h
str_Dialogbx:                                   ; string 'dialogbx'; used by DrawFileDlg
        db 064h,069h,061h,06Ch,06Fh,067h,062h,078h,00h
str_Dbox:                                       ; string 'dbox'; used by DrawFileDlg
        db 064h,062h,06Fh,078h,00h
str_Pointer5:                                   ; string 'Pointer'; used by RunFileDlg
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h
str_fec6:                                       ; FatalError code (file_dialogs); used by DeleteSavedGame
        db 063h,036h,00h
str_Po2:                                        ; string '.po'; used by SelectSavedFile
        db 02Eh,070h,06Fh,00h
str_ScheduleDb2:                                ; string 'schedule.db'; used by SelectSavedFile
        db 073h,063h,068h,065h,064h,075h,06Ch,065h,02Eh,064h,062h,00h
str_Lp2:                                        ; string '.lp'; used by SelectSavedFile
        db 02Eh,06Ch,070h,00h
str_GameSet3:                                   ; string 'game.set'; used by ReadGameSettings
        db 067h,061h,06Dh,065h,02Eh,073h,065h,074h,00h
str_fed2:                                       ; FatalError code (file_dialogs); used by ReadGameSettings
        db 064h,032h,00h
str_fedd2:                                      ; FatalError code (file_dialogs); used by ReadGameSettings
        db 064h,064h,032h,00h
str_fed3:                                       ; FatalError code (file_dialogs); used by ReadGameSettings
        db 064h,033h,00h
str_fed4:                                       ; FatalError code (file_dialogs); used by ReadGameSettings
        db 064h,034h,00h
str_GameSav3:                                   ; string 'game.sav'; used by ReadGameSettings
        db 067h,061h,06Dh,065h,02Eh,073h,061h,076h,00h,00h,00h
