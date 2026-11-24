; BSS of pc/file_dialogs (src/pc/file_dialogs).
bits 32
%include "hockey.inc"
section s_DD124 nobits alloc noexec write align=1
global exhfiles, exhfilenames, pofiles, pofilenames, lgfiles, lgfilenames, savefname, fdlg_tabexh
global fdlg_none, fdlg_tabpo, fdlg_open, fdlg_del, fdlg_up, fdlg_cancel, fdlg_tabnone, fdlg_down
global fdlgtab, fdlg_arrow, fdlg_tablp, fdlg_noarrow, fdlgmask
exhfiles:                                       ; *.nhl list block (90h); used by DeleteSavedGame,
                                                ; DrawFileDlg, MenuOpenSaved ...
        resb 4
        resb 4
        resb 4
        resb 4
exhfilenames:                                   ; *.nhl name pointer array (exhfiles+10h); used by
                                                ; MenuOpenSaved, ScanSavedGames, SelectSavedFile
        resb 128
pofiles:                                        ; *.po list block; used by DeleteSavedGame, DrawFileDlg,
                                                ; MenuOpenSaved ...
        resb 4
        resb 4
        resb 4
        resb 4
pofilenames:                                    ; *.po name pointer array; used by MenuOpenSaved,
                                                ; ScanSavedGames, SelectSavedFile
        resb 128
lgfiles:                                        ; *.lp list block; used by DeleteSavedGame, DrawFileDlg,
                                                ; MenuOpenSaved ...
        resb 4
        resb 4
        resb 4
        resb 4
lgfilenames:                                    ; *.lp name pointer array; used by MenuOpenSaved,
                                                ; ScanSavedGames, SelectSavedFile
        resb 128
savefname:                                      ; current save file name buffer (also database_dialogs); used
                                                ; by ScanDbFiles, ScanSavedGames
        resb 8
        resb 856
fdlg_tabexh:                                    ; "gtex" shape; used by DrawDbDialogButtons, DrawDbList_n1,
                                                ; DrawFileDlgList_n1 ...
        resb 4
fdlg_none:                                      ; "none" shape; used by DbDialogLoop, LoadDbDialogShapes,
                                                ; LoadFileDlgShapes ...
        resb 4
fdlg_tabpo:                                     ; "gtpo" shape; used by DrawDbDialogButtons, DrawDbList_n1,
                                                ; DrawFileDlgList_n1 ...
        resb 4
fdlg_open:                                      ; "open" shape; used by DbDialogLoop, LoadDbDialogShapes,
                                                ; LoadFileDlgShapes ...
        resb 4
fdlg_del:                                       ; "del " shape; used by DbDialogLoop, LoadDbDialogShapes,
                                                ; LoadFileDlgShapes ...
        resb 4
fdlg_up:                                        ; "up " shape; used by DbDialogLoop, LoadDbDialogShapes,
                                                ; LoadFileDlgShapes ...
        resb 4
fdlg_cancel:                                    ; "can " shape; used by DbDialogLoop, ExhSetEditLoop,
                                                ; LeagueSetEditLoop ...
        resb 4
fdlg_tabnone:                                   ; "gtno" shape; used by DrawFileDlgTabs, LoadDbDialogShapes,
                                                ; LoadFileDlgShapes
        resb 4
fdlg_down:                                      ; "down" shape; used by DbDialogLoop, LoadDbDialogShapes,
                                                ; LoadFileDlgShapes ...
        resb 4
fdlgtab:                                        ; current tab 0 exhibition / 1 playoffs / 2 league; used by
                                                ; DbDialogLoop, DeleteSavedGame, DeleteSelectedDb ...
        resb 4
fdlg_arrow:                                     ; "arro" shape; used by DrawFileDlgList_n1, DrawFileDlgTabs,
                                                ; LoadDbDialogShapes ...
        resb 4
fdlg_tablp:                                     ; "gtlp" shape; used by DrawDbDialogButtons, DrawDbList_n1,
                                                ; DrawFileDlgList_n1 ...
        resb 4
fdlg_noarrow:                                   ; "noar" shape; used by DbDialogLoop, DrawDbDialogButtons,
                                                ; DrawFileDlgList_n1 ...
        resb 4
fdlgmask:                                       ; visible-row / button mask; used by DbDialogLoop,
                                                ; DeleteSavedGame, DeleteSelectedDb ...
        resb 1
        resb 3
