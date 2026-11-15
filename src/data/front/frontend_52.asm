; Dialog colours, and the buttons on the save-database box.
bits 32
%include "hockey.inc"
section s_D0B16 progbits alloc noexec write align=1
extern str_Yes, str_No4
global dlgfillcol, dlgedgecol1, dlgedgecol2, dlgedgecol3, dlgbevelcol1, dlgbevelcol2, fascrollbar_len, fascrollbar_thumb
global fascrollbar_top, fascrollbar_count, dword_D0C20, str_OK, str_Cancel5, btn_EditRosters, btn_RosterList, fascrollbar
global savedbbtns
dlgfillcol:
        db 041h,00h,00h,00h
dlgedgecol1:
        db 040h,00h,00h,00h
dlgedgecol2:
        db 042h,00h,00h,00h
dlgedgecol3:
        db 041h,00h,00h,00h
dlgbevelcol1:
        db 040h,00h,00h,00h
dlgbevelcol2:
        db 042h,00h,00h,00h,0A9h,01h,00h,00h,0B0h,00h,00h,00h,0A9h,01h,00h,00h
        db 0BDh,00h,00h,00h,0A9h,01h,00h,00h,0CAh,00h,00h,00h,0A9h,01h,00h,00h
        db 0D7h,00h,00h,00h,0A9h,01h,00h,00h,0E4h,00h,00h,00h,0A9h,01h,00h,00h
        db 0F1h,00h,00h,00h,0A9h,01h,00h,00h,0FEh,00h,00h,00h,0A9h,01h,00h,00h
        db 0Bh,01h,00h,00h,09Ch,0FFh,0FFh,0FFh,09Ch,0FFh,0FFh,0FFh
str_OK:
        db 04Fh,04Bh,00h
str_Cancel5:
        db 043h,061h,06Eh,063h,065h,06Ch,00h
btn_EditRosters:
        db 0D2h,00h,00h,00h,036h,01h,00h,00h,048h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_OK
        db 06Bh,01h,00h,00h,036h,01h,00h,00h,048h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_Cancel5
btn_RosterList:
        db 03Ah,01h,00h,00h,024h,00h,00h,00h,0Ch,00h,00h,00h,0Ah,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h,00h,00h,00h,00h,03Ah,01h,00h,00h
        db 0D2h,01h,00h,00h,0Ch,00h,00h,00h,0Ah,00h,00h,00h,00h,00h,00h,00h
        db 05h,00h,00h,00h,00h,00h,00h,00h
fascrollbar:
        db 03Ah,01h,00h,00h,02Eh,00h,00h,00h,0Ch,00h,00h,00h
fascrollbar_len:
        db 0A4h,01h,00h,00h,00h,00h,00h,00h
fascrollbar_thumb:
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
fascrollbar_top:
        db 00h,00h,00h,00h,00h,00h,00h,00h
fascrollbar_count:
        db 00h,00h,00h,00h,00h,00h,00h,00h
dword_D0C20:
        db 00h,00h,00h,00h
savedbbtns:
        db 08h,00h,00h,00h,01Ch,00h,00h,00h,028h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_No4
        db 0F8h,0FFh,0FFh,0FFh,01Ch,00h,00h,00h,028h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,06h,00h,00h,00h
        dd str_Yes
