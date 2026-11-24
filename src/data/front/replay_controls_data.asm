; Initialised data of front/replay_controls (src/front/replay_controls).
bits 32
%include "hockey.inc"
section s_D1B0B progbits alloc noexec write align=1
extern str_BOS1, str_BOS22, str_BOS23, str_BOS3, str_BUF22, str_CAL1, str_CAL2, str_CAL3
extern str_CGY22, str_CHIC1, str_CHIC2, str_CHIC3, str_DET1, str_DET22, str_ED1, str_HART1
extern str_HART2, str_HART22, str_HART23, str_HART3, str_LA1, str_LA4, str_LA42, str_LI2
extern str_LI3, str_MON1, str_MON12, str_MON2, str_MON3, str_MON32, str_NJER2, str_NY3
extern str_PHIL1, str_PHIL2, str_PITTS1, str_PITTS2, str_PITTS3, str_PITTS4, str_QU1, str_ROCKDITI2
extern str_SHK1, str_SHK2, str_SHK7, str_SHK8, str_SL1, str_SL2, str_SL3, str_TB22
extern str_TOR1, str_TOR22, str_VAN1, str_VAN3, str_WASH3, str_WINN2
global rockcuefiles, teamrockcuetbl, rockcuepool, str_CANADA, str_USA, teamtunefiles, teamtunepathsel, rockcuepathsel
global gadgetrects, gadgetrect_y0, gadgetrect_x1, gadgetrect_y1, str_InsufficientDiskSpaceTo2, str_SaveHilights, str_CurrentHilightNotSaved, msg_NoHilightSpace
global str_ThereAreNoHilights
rockcuefiles:                                   ; cue file name pointers; used by LoadRockMusic
        dd str_BOS1
        dd str_BOS22
        dd str_BOS3
        dd str_HART2
        dd str_BUF22
        dd str_CAL1
        dd str_CAL2
        dd str_CAL3
        dd str_CHIC1
        dd str_CHIC2
        dd str_CHIC3
        dd str_DET1
        dd str_DET22
        dd str_ED1
        dd str_HART1
        dd str_HART22
        dd str_HART3
        dd str_LA1
        dd str_LA4
        dd str_MON1
        dd str_MON2
        dd str_MON3
        dd str_HART23
        dd str_NJER2
        dd str_LI2
        dd str_LI3
        dd str_NY3
        dd str_PHIL1
        dd str_PHIL2
        dd str_CGY22
        dd str_PITTS1
        dd str_PITTS2
        dd str_PITTS3
        dd str_PITTS4
        dd str_QU1
        dd str_SL1
        dd str_SL2
        dd str_SL3
        dd str_SHK1
        dd str_SHK2
        dd str_MON12
        dd str_MON32
        dd str_LA42
        dd str_SHK7
        dd str_SHK8
        dd str_BOS23
        dd str_TB22
        dd str_TOR1
        dd str_TOR22
        dd str_VAN1
        dd str_VAN3
        dd str_WASH3
        dd str_WINN2
teamrockcuetbl equ $+1
        dd str_ROCKDITI2
        db 01h,00h,02h,0FFh,01Fh,01h,04h,0Fh,0Fh,04h,01Fh,0FFh,05h,07h,05h,07h
        db 06h,06h,08h,0Ah,09h,08h,01Fh,02Bh,0Bh,0Ch,0Ah,0FFh,01Fh,0Ch,0Dh,01h
        db 01h,0FFh,01Fh,0FFh,0Eh,010h,0Fh,010h,01Fh,0Eh,011h,011h,0Ah,07h,0FFh,012h
        db 01h,018h,018h,0FFh,01Fh,0FFh,0Ch,015h,0Ch,014h,01Fh,013h,0Fh,017h,0Fh,0FFh
        db 01Fh,0Bh,0Fh,018h,0Fh,019h,01Fh,019h,01h,01Ah,0Fh,0FFh,01Fh,0FFh,0Fh,034h
        db 0Ch,0FFh,01Fh,0FFh,01Bh,01Ch,01Bh,06h,01Fh,06h,01Eh,020h,01Eh,021h,01Fh,021h
        db 022h,06h,022h,0FFh,01Fh,06h,023h,024h,024h,023h,01Fh,025h,026h,027h,013h,015h
        db 012h,02Bh,01h,02Eh,02Eh,0FFh,01Fh,0FFh,02Fh,02Fh,030h,0FFh,01Fh,0FFh,031h,026h
        db 032h,0FFh,01Fh,0FFh,0Ch,033h,0Ch,0FFh,01Fh,0Ch,0Fh,034h,0Ch,0FFh,01Fh,0FFh
        db 011h,02Fh,032h,0FFh,06h,02Bh,0Fh,020h,032h,0FFh,01Fh,013h,026h,06h,013h,015h
        db 012h,02Bh,01h,01Ah,0Fh,0FFh,01Fh,0FFh
rockcuepool:                                    ; 18 random cue ids; used by LoadRockMusic
        db 010h,00h,00h,00h,019h,00h,00h,00h,021h,00h,00h,00h,02Bh,00h,00h,00h
        db 02Ch,00h,00h,00h,035h,00h,00h,00h,011h,00h,00h,00h,012h,00h,00h,00h
        db 013h,00h,00h,00h,015h,00h,00h,00h,01Ch,00h,00h,00h,01Eh,00h,00h,00h
        db 020h,00h,00h,00h,025h,00h,00h,00h,02Eh,00h,00h,00h,02Fh,00h,00h,00h
        db 032h,00h,00h,00h,034h,00h,00h,00h
str_CANADA:                                     ; "CANADA" string literal
        db 043h,041h,04Eh,041h,044h,041h,00h
str_USA:                                        ; "USA" string literal
        db 055h,053h,041h,00h
teamtunefiles:                                  ; team tune file name pointers; used by LoadRockMusic
        dd str_CANADA
        dd str_USA
teamtunepathsel:                                ; per-tune path flag index; used by LoadRockMusic
        db 042h,00h,00h,00h,0B0h,01h,00h,00h
rockcuepathsel:                                 ; used by LoadRockMusic
        db 02Fh,00h,00h,00h,031h,00h,00h,00h,033h,00h,00h,00h,09Bh,00h,00h,00h
        db 039h,00h,00h,00h,03Bh,00h,00h,00h,03Dh,00h,00h,00h,03Fh,00h,00h,00h
        db 04Dh,00h,00h,00h,04Fh,00h,00h,00h,051h,00h,00h,00h,060h,00h,00h,00h
        db 062h,00h,00h,00h,06Ch,00h,00h,00h,099h,00h,00h,00h,09Bh,00h,00h,00h
        db 09Dh,00h,00h,00h,0E0h,00h,00h,00h,0E2h,00h,00h,00h,0F0h,00h,00h,00h
        db 0F2h,00h,00h,00h,0F4h,00h,00h,00h,09Bh,00h,00h,00h,0Ah,01h,00h,00h
        db 0E4h,00h,00h,00h,0E6h,00h,00h,00h,0Dh,01h,00h,00h,022h,01h,00h,00h
        db 024h,01h,00h,00h,03Dh,00h,00h,00h,030h,01h,00h,00h,032h,01h,00h,00h
        db 034h,01h,00h,00h,035h,01h,00h,00h,056h,01h,00h,00h,089h,01h,00h,00h
        db 08Bh,01h,00h,00h,08Dh,01h,00h,00h,079h,01h,00h,00h,07Bh,01h,00h,00h
        db 0F0h,00h,00h,00h,0F4h,00h,00h,00h,0E2h,00h,00h,00h,083h,01h,00h,00h
        db 085h,01h,00h,00h,031h,00h,00h,00h,09Ch,01h,00h,00h,0A6h,01h,00h,00h
        db 0A8h,01h,00h,00h,0B4h,01h,00h,00h,0B6h,01h,00h,00h,0B8h,01h,00h,00h
        db 0BAh,01h,00h,00h,061h,01h,00h,00h,00h,00h
gadgetrects:                                    ; gadget button rects (28-byte entries) x0; used by
                                                ; DrawGadgetButton, GadgetHitTest
        db 09Fh,00h,00h,00h
gadgetrect_y0:                                  ; rect y0 (own label: nosplit); used by DrawGadgetButton,
                                                ; GadgetHitTest
        db 0ACh,00h,00h,00h
gadgetrect_x1:                                  ; rect x1 (own label: nosplit); used by DrawGadgetButton,
                                                ; GadgetHitTest
        db 0AAh,00h,00h,00h
gadgetrect_y1:                                  ; rect y1 (own label: nosplit); used by DrawGadgetButton,
                                                ; GadgetHitTest
        db 0B4h,00h,00h,00h,092h,02h,00h,00h,08h,00h,00h,00h,01h,00h,00h,00h
        db 0B3h,00h,00h,00h,0ACh,00h,00h,00h,0BEh,00h,00h,00h,0B4h,00h,00h,00h
        db 098h,02h,00h,00h,00h,00h,00h,00h,02h,00h,00h,00h,0C6h,00h,00h,00h
        db 0ACh,00h,00h,00h,0D1h,00h,00h,00h,0B4h,00h,00h,00h,09Eh,02h,00h,00h
        db 01h,00h,00h,00h,03h,00h,00h,00h,0D9h,00h,00h,00h,0ACh,00h,00h,00h
        db 0E4h,00h,00h,00h,0B4h,00h,00h,00h,0A4h,02h,00h,00h,02h,00h,00h,00h
        db 04h,00h,00h,00h,0ECh,00h,00h,00h,0ACh,00h,00h,00h,0F7h,00h,00h,00h
        db 0B4h,00h,00h,00h,0AAh,02h,00h,00h,03h,00h,00h,00h,05h,00h,00h,00h
        db 0FFh,00h,00h,00h,0ACh,00h,00h,00h,0Ah,01h,00h,00h,0B4h,00h,00h,00h
        db 0B0h,02h,00h,00h,04h,00h,00h,00h,06h,00h,00h,00h,09Fh,00h,00h,00h
        db 0B9h,00h,00h,00h,0BEh,00h,00h,00h,0C1h,00h,00h,00h,0B9h,02h,00h,00h
        db 05h,00h,00h,00h,07h,00h,00h,00h,0C6h,00h,00h,00h,0B9h,00h,00h,00h
        db 0E5h,00h,00h,00h,0C1h,00h,00h,00h,0C6h,02h,00h,00h,06h,00h,00h,00h
        db 08h,00h,00h,00h,0ECh,00h,00h,00h,0B9h,00h,00h,00h,0Bh,01h,00h,00h
        db 0C1h,00h,00h,00h,0D2h,02h,00h,00h,07h,00h,00h,00h,00h,00h,00h,00h
        db 0C6h,00h,00h,00h,0B9h,00h,00h,00h,0E5h,00h,00h,00h,0C1h,00h,00h,00h
        db 0C6h,02h,00h,00h,06h,00h,00h,00h,08h,00h,00h,00h
str_InsufficientDiskSpaceTo2:                   ; "Insufficient disk space to" string literal
        db 049h,06Eh,073h,075h,066h,066h,069h,063h,069h,065h,06Eh,074h,020h,064h,069h,073h
        db 06Bh,020h,073h,070h,061h,063h,065h,020h,074h,06Fh,00h
str_SaveHilights:                               ; "save hilights." string literal
        db 073h,061h,076h,065h,020h,068h,069h,06Ch,069h,067h,068h,074h,073h,02Eh,00h
str_CurrentHilightNotSaved:                     ; "Current hilight not saved." string literal
        db 043h,075h,072h,072h,065h,06Eh,074h,020h,068h,069h,06Ch,069h,067h,068h,074h,020h
        db 06Eh,06Fh,074h,020h,073h,061h,076h,065h,064h,02Eh,00h
msg_NoHilightSpace:                             ; message lines 'Insufficient disk space to' / 'save
                                                ; hilights.' / 'Current hilight not saved.'; used by
                                                ; ReplaySaveHilight, ReplaySaveHilight_n3
        dd str_InsufficientDiskSpaceTo2
        dd str_SaveHilights
        dd str_CurrentHilightNotSaved
        db 00h,00h,00h
str_ThereAreNoHilights:                         ; "There are no hilights!" string literal
        db 054h,068h,065h,072h,065h,020h,061h,072h,065h,020h,06Eh,06Fh,020h,068h,069h,06Ch
        db 069h,067h,068h,074h,073h,021h,00h
