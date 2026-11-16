; Dialog colours, and the buttons on the save-database box.
bits 32
%include "hockey.inc"
section s_D0B16 progbits alloc noexec write align=1
extern str_Yes, str_No4
global dlgfillcol, dlgedgecol1, dlgedgecol2, dlgedgecol3, dlgbevelcol1, dlgbevelcol2, fascrollbar_len, fascrollbar_thumb
global fascrollbar_top, fascrollbar_count, FaListScrolls, str_OK, str_Cancel5, btn_EditRosters, btn_RosterList, fascrollbar
global savedbbtns
dlgfillcol:                                     ; DrawDlgFrame interior fill colour (FillRect fill); callers
                                                ; save/set it around InputDialog, GameLineEditor,
                                                ; TradePlayers; used by DbLineEditor, DrawDlgFrame,
                                                ; GameLineEditor ...
        db 041h,00h,00h,00h
dlgedgecol1:                                    ; DrawDlgFrame colour for the outer bottom/right edge lines;
                                                ; used by DbLineEditor, DrawDlgFrame, GameLineEditor ...
        db 040h,00h,00h,00h
dlgedgecol2:                                    ; DrawDlgFrame colour for the outer top/left edge lines; used
                                                ; by DbLineEditor, DrawDlgFrame, GameLineEditor ...
        db 042h,00h,00h,00h
dlgedgecol3:                                    ; DrawDlgFrame colour for the second frame ring; used by
                                                ; DbLineEditor, DrawDlgFrame, GameLineEditor ...
        db 041h,00h,00h,00h
dlgbevelcol1:                                   ; DrawDlgFrame bevel colour (drawn only when the bevel arg is
                                                ; set); used by DbLineEditor, DrawDlgFrame, GameLineEditor ...
        db 040h,00h,00h,00h
dlgbevelcol2:                                   ; DrawDlgFrame second bevel colour (drawn only when the bevel
                                                ; arg is set); used by DbLineEditor, DrawDlgFrame,
                                                ; GameLineEditor ...
        db 042h,00h,00h,00h,0A9h,01h,00h,00h,0B0h,00h,00h,00h,0A9h,01h,00h,00h
        db 0BDh,00h,00h,00h,0A9h,01h,00h,00h,0CAh,00h,00h,00h,0A9h,01h,00h,00h
        db 0D7h,00h,00h,00h,0A9h,01h,00h,00h,0E4h,00h,00h,00h,0A9h,01h,00h,00h
        db 0F1h,00h,00h,00h,0A9h,01h,00h,00h,0FEh,00h,00h,00h,0A9h,01h,00h,00h
        db 0Bh,01h,00h,00h,09Ch,0FFh,0FFh,0FFh,09Ch,0FFh,0FFh,0FFh
str_OK:                                         ; "OK" string literal
        db 04Fh,04Bh,00h
str_Cancel5:                                    ; "Cancel" string literal
        db 043h,061h,06Eh,063h,065h,06Ch,00h
btn_EditRosters:                                ; Edit Rosters screen: its two buttons; used by
                                                ; DrawEditRosters, EditRosters
        db 0D2h,00h,00h,00h,036h,01h,00h,00h,048h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_OK
        db 06Bh,01h,00h,00h,036h,01h,00h,00h,048h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_Cancel5
btn_RosterList:                                 ; DrawRosterList: the two list buttons; used by
                                                ; DrawRosterList, EditRosters
        db 03Ah,01h,00h,00h,024h,00h,00h,00h,0Ch,00h,00h,00h,0Ah,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h,00h,00h,00h,00h,03Ah,01h,00h,00h
        db 0D2h,01h,00h,00h,0Ch,00h,00h,00h,0Ah,00h,00h,00h,00h,00h,00h,00h
        db 05h,00h,00h,00h,00h,00h,00h,00h
fascrollbar:                                    ; Edit Rosters: scroll bar of the free agent list; used by
                                                ; DrawRosterList, EditRosters, LoadRosterList_faloop
        db 03Ah,01h,00h,00h,02Eh,00h,00h,00h,0Ch,00h,00h,00h
fascrollbar_len:                                ; fascrollbar+0Ch: bar length; used by DrawRosterList
        db 0A4h,01h,00h,00h,00h,00h,00h,00h
fascrollbar_thumb:                              ; fascrollbar+14h: thumb position, (len-4)*top/count; used by
                                                ; DrawRosterList
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
fascrollbar_top:                                ; fascrollbar+20h: list top (falisttop); used by
                                                ; DrawRosterList, EditRosters
        db 00h,00h,00h,00h,00h,00h,00h,00h
fascrollbar_count:                              ; fascrollbar+28h: range the thumb position divides by; used
                                                ; by DrawRosterList
        db 00h,00h,00h,00h,00h,00h,00h,00h
FaListScrolls:                                  ; Set when the free agent list has more than 28 players and
                                                ; needs a scroll bar; used by DrawRosterList, EditRosters,
                                                ; LoadRosterList_faloop ...
        db 00h,00h,00h,00h
savedbbtns:                                     ; string '\x08'; used by MenuSaveDbs
        db 08h,00h,00h,00h,01Ch,00h,00h,00h,028h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_No4
        db 0F8h,0FFh,0FFh,0FFh,01Ch,00h,00h,00h,028h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,06h,00h,00h,00h
        dd str_Yes
