; Initialised data of pc/league_settings (src/pc/league_settings).
bits 32
%include "hockey.inc"
section s_D14F0 progbits alloc noexec write align=1
global leaguesetrects, dlggreys
leaguesetrects:                                 ; 16-byte rects x0,y0,x1,y1; used by DrawLeagueSetChecks,
                                                ; LeagueSetHitTest
        db 020h,00h,00h,00h
        db 028h,00h,00h,00h
        db 03Ah,00h,00h,00h
        db 038h,00h,00h,00h,03Eh,00h,00h,00h,028h,00h,00h,00h,058h,00h,00h,00h
        db 038h,00h,00h,00h,020h,00h,00h,00h,03Eh,00h,00h,00h,03Ah,00h,00h,00h
        db 04Eh,00h,00h,00h,03Eh,00h,00h,00h,03Eh,00h,00h,00h,058h,00h,00h,00h
        db 04Eh,00h,00h,00h,020h,00h,00h,00h,054h,00h,00h,00h,03Ah,00h,00h,00h
        db 064h,00h,00h,00h,03Eh,00h,00h,00h,054h,00h,00h,00h,058h,00h,00h,00h
        db 064h,00h,00h,00h,020h,00h,00h,00h,06Ah,00h,00h,00h,03Ah,00h,00h,00h
        db 07Ah,00h,00h,00h,03Eh,00h,00h,00h,06Ah,00h,00h,00h,058h,00h,00h,00h
        db 07Ah,00h,00h,00h,020h,00h,00h,00h,080h,00h,00h,00h,03Ah,00h,00h,00h
        db 090h,00h,00h,00h,03Eh,00h,00h,00h,080h,00h,00h,00h,058h,00h,00h,00h
        db 090h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
        db 0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
        db 0FFh,0FFh,0FFh,0FFh,020h,00h,00h,00h,096h,00h,00h,00h,03Ah,00h,00h,00h
        db 0A6h,00h,00h,00h,03Eh,00h,00h,00h,096h,00h,00h,00h,058h,00h,00h,00h
        db 0A6h,00h,00h,00h,020h,00h,00h,00h,0ACh,00h,00h,00h,03Ah,00h,00h,00h
        db 0BCh,00h,00h,00h,03Eh,00h,00h,00h,0ACh,00h,00h,00h,058h,00h,00h,00h
        db 0BCh,00h,00h,00h,020h,00h,00h,00h,0C2h,00h,00h,00h,03Ah,00h,00h,00h
        db 0D2h,00h,00h,00h,03Eh,00h,00h,00h,0C2h,00h,00h,00h,058h,00h,00h,00h
        db 0D2h,00h,00h,00h,07Ch,00h,00h,00h,0EAh,00h,00h,00h,091h,00h,00h,00h
        db 0FAh,00h,00h,00h,096h,00h,00h,00h,0EAh,00h,00h,00h,0ADh,00h,00h,00h
        db 0FAh,00h,00h,00h,0B2h,00h,00h,00h,0EAh,00h,00h,00h,0C9h,00h,00h,00h
        db 0FAh,00h,00h,00h,07Bh,00h,00h,00h,012h,01h,00h,00h,08Ch,00h,00h,00h
        db 022h,01h,00h,00h,092h,00h,00h,00h,012h,01h,00h,00h,0A3h,00h,00h,00h
        db 022h,01h,00h,00h,0A9h,00h,00h,00h,012h,01h,00h,00h,0BAh,00h,00h,00h
        db 022h,01h,00h,00h,0C0h,00h,00h,00h,012h,01h,00h,00h,0D1h,00h,00h,00h
        db 022h,01h,00h,00h,035h,00h,00h,00h,035h,01h,00h,00h,066h,00h,00h,00h
        db 045h,01h,00h,00h,07Fh,00h,00h,00h,035h,01h,00h,00h,0B0h,00h,00h,00h
        db 045h,01h,00h,00h
dlggreys:                                       ; four grey RGB triplets the settings dialogs load at colour
                                                ; F7h; used by ExhSetEditLoop, LeagueSetEditLoop,
                                                ; LeagueSetViewLoop ...
        db 00h,00h,00h,014h,014h,014h,02Eh,02Eh,02Eh,03Fh,03Fh,03Fh
