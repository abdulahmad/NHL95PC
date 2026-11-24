; Initialised data of pc/dialogs (src/pc/dialogs).
bits 32
%include "hockey.inc"
section s_C71CC progbits alloc noexec write align=1
global boxfillcolor, boxlitecolor, boxshadecolor, dlgtextfg, dlgtextbg, EditRostersState, dlgsavebuf, listscroll
boxfillcolor:                                   ; DrawBevelBox fill; used by CreatePlayoffs, DrawBevelBox,
                                                ; DrawButton ...
        db 02Ah,00h,00h,00h
boxlitecolor:                                   ; DrawBevelBox top/left; used by CreatePlayoffs, DrawBevelBox,
                                                ; DrawButton ...
        db 03Fh,00h,00h,00h
boxshadecolor:                                  ; DrawBevelBox bottom/right; used by CreatePlayoffs,
                                                ; DrawBevelBox, DrawButton ...
        db 017h,00h,00h,00h
dlgtextfg:                                      ; string '?'; used by CreatePlayoffs, DrawListItem,
                                                ; DrawTeamGridName ...
        db 03Fh,00h,00h,00h
dlgtextbg:                                      ; string ''; used by CreatePlayoffs, DrawListItem,
                                                ; DrawTeamGridName ...
        db 00h,00h,00h,00h
EditRostersState:                               ; Cleared before the roster editor runs from the central
                                                ; registry; used by MenuCentralRegistry
        db 00h,00h,00h,00h
dlgsavebuf:                                     ; DBOX screen save; used by MergeLeagueFiles, RestoreDialogBg,
                                                ; SaveDialogBg
        db 00h,00h,00h,00h
listscroll:                                     ; ListDialog scroll bar (30h-byte struct); used by ListDialog
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h
