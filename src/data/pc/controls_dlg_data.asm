; Initialised data of pc/controls_dlg (src/pc/controls_dlg).
bits 32
%include "hockey.inc"
section s_D195C progbits alloc noexec write align=1
global ctldlgrects, ctlboxrect1, ctlboxrect2, ctldlgalt, str_BOS1, str_BOS22, str_BOS3, str_HART2
global str_BUF22, str_CAL1, str_CAL2, str_CAL3, str_CHIC1, str_CHIC2, str_CHIC3, str_DET1
global str_DET22, str_ED1, str_HART1, str_HART22, str_HART3, str_LA1, str_LA4, str_MON1
global str_MON2, str_MON3, str_HART23, str_NJER2, str_LI2, str_LI3, str_NY3, str_PHIL1
global str_PHIL2, str_CGY22, str_PITTS1, str_PITTS2, str_PITTS3, str_PITTS4, str_QU1, str_SL1
global str_SL2, str_SL3, str_SHK1, str_SHK2, str_MON12, str_MON32, str_LA42, str_SHK7
global str_SHK8, str_BOS23, str_TB22, str_TOR1, str_TOR22, str_VAN1, str_VAN3, str_WASH3
global str_WINN2, str_ROCKDITI2
ctldlgrects:                                    ; rects; used by CtlDlgHitTest, DrawControlsDlg,
                                                ; DrawControlsOpts ...
        db 010h,00h,00h,00h
        db 021h,00h,00h,00h
        db 087h,00h,00h,00h
        db 032h,00h,00h,00h
        db 010h,00h,00h,00h
        db 037h,00h,00h,00h
        db 087h,00h,00h,00h
        db 048h,00h,00h,00h
        db 01Bh,00h,00h,00h
        db 065h,00h,00h,00h,07Ch,00h,00h,00h,076h,00h,00h,00h
        db 01Bh,00h,00h,00h
        db 07Ah,00h,00h,00h,07Ch,00h,00h,00h,08Bh,00h,00h,00h
        db 01Bh,00h,00h,00h
        db 08Fh,00h,00h,00h,07Ch,00h,00h,00h,0A0h,00h,00h,00h
        db 01Bh,00h,00h,00h
        db 0A4h,00h,00h,00h,07Ch,00h,00h,00h,0B5h,00h,00h,00h,01Bh,00h,00h,00h
        db 0B9h,00h,00h,00h,07Ch,00h,00h,00h,0CAh,00h,00h,00h
ctlboxrect1:                                    ; ControlsDlgLoop: rectangle of the first highlighted box;
                                                ; used by ControlsDlgLoop
        db 0Eh,00h,00h,00h,0D4h,00h,00h,00h,03Fh,00h,00h,00h,0E4h,00h,00h,00h
ctlboxrect2:                                    ; ControlsDlgLoop: rectangle of the second highlighted box;
                                                ; used by ControlsDlgLoop
        db 058h,00h,00h,00h,0D4h,00h,00h,00h,089h,00h,00h,00h,0E4h,00h,00h,00h
ctldlgalt:                                      ; alternate colour flag for controller dialog; used by
                                                ; ControlsDlgExh, ControlsDlgLeague, DrawControlsDlg ...
        db 00h,00h,00h,00h
str_BOS1:                                       ; "BOS1" string literal
        db 042h,04Fh,053h,031h,00h
str_BOS22:                                      ; "BOS2" string literal
        db 042h,04Fh,053h,032h,00h
str_BOS3:                                       ; "BOS3" string literal
        db 042h,04Fh,053h,033h,00h
str_HART2:                                      ; "HART2" string literal
        db 048h,041h,052h,054h,032h,00h
str_BUF22:                                      ; "BUF2" string literal
        db 042h,055h,046h,032h,00h
str_CAL1:                                       ; "CAL1" string literal
        db 043h,041h,04Ch,031h,00h
str_CAL2:                                       ; "CAL2" string literal
        db 043h,041h,04Ch,032h,00h
str_CAL3:                                       ; "CAL3" string literal
        db 043h,041h,04Ch,033h,00h
str_CHIC1:                                      ; "CHIC1" string literal
        db 043h,048h,049h,043h,031h,00h
str_CHIC2:                                      ; "CHIC2" string literal
        db 043h,048h,049h,043h,032h,00h
str_CHIC3:                                      ; "CHIC3" string literal
        db 043h,048h,049h,043h,033h,00h
str_DET1:                                       ; "DET1" string literal
        db 044h,045h,054h,031h,00h
str_DET22:                                      ; "DET2" string literal
        db 044h,045h,054h,032h,00h
str_ED1:                                        ; "ED1" string literal
        db 045h,044h,031h,00h
str_HART1:                                      ; "HART1" string literal
        db 048h,041h,052h,054h,031h,00h
str_HART22:                                     ; "HART2" string literal
        db 048h,041h,052h,054h,032h,00h
str_HART3:                                      ; "HART3" string literal
        db 048h,041h,052h,054h,033h,00h
str_LA1:                                        ; "LA1" string literal
        db 04Ch,041h,031h,00h
str_LA4:                                        ; "LA4" string literal
        db 04Ch,041h,034h,00h
str_MON1:                                       ; "MON1" string literal
        db 04Dh,04Fh,04Eh,031h,00h
str_MON2:                                       ; "MON2" string literal
        db 04Dh,04Fh,04Eh,032h,00h
str_MON3:                                       ; "MON3" string literal
        db 04Dh,04Fh,04Eh,033h,00h
str_HART23:                                     ; "HART2" string literal
        db 048h,041h,052h,054h,032h,00h
str_NJER2:                                      ; "NJER2" string literal
        db 04Eh,04Ah,045h,052h,032h,00h
str_LI2:                                        ; "LI2" string literal
        db 04Ch,049h,032h,00h
str_LI3:                                        ; "LI3" string literal
        db 04Ch,049h,033h,00h
str_NY3:                                        ; "NY3" string literal
        db 04Eh,059h,033h,00h
str_PHIL1:                                      ; "PHIL1" string literal
        db 050h,048h,049h,04Ch,031h,00h
str_PHIL2:                                      ; "PHIL2" string literal
        db 050h,048h,049h,04Ch,032h,00h
str_CGY22:                                      ; "CGY2" string literal
        db 043h,047h,059h,032h,00h
str_PITTS1:                                     ; "PITTS1" string literal
        db 050h,049h,054h,054h,053h,031h,00h
str_PITTS2:                                     ; "PITTS2" string literal
        db 050h,049h,054h,054h,053h,032h,00h
str_PITTS3:                                     ; "PITTS3" string literal
        db 050h,049h,054h,054h,053h,033h,00h
str_PITTS4:                                     ; "PITTS4" string literal
        db 050h,049h,054h,054h,053h,034h,00h
str_QU1:                                        ; "QU1" string literal
        db 051h,055h,031h,00h
str_SL1:                                        ; "SL1" string literal
        db 053h,04Ch,031h,00h
str_SL2:                                        ; "SL2" string literal
        db 053h,04Ch,032h,00h
str_SL3:                                        ; "SL3" string literal
        db 053h,04Ch,033h,00h
str_SHK1:                                       ; "SHK1" string literal
        db 053h,048h,04Bh,031h,00h
str_SHK2:                                       ; "SHK2" string literal
        db 053h,048h,04Bh,032h,00h
str_MON12:                                      ; "MON1" string literal
        db 04Dh,04Fh,04Eh,031h,00h
str_MON32:                                      ; "MON3" string literal
        db 04Dh,04Fh,04Eh,033h,00h
str_LA42:                                       ; "LA4" string literal
        db 04Ch,041h,034h,00h
str_SHK7:                                       ; "SHK7" string literal
        db 053h,048h,04Bh,037h,00h
str_SHK8:                                       ; "SHK8" string literal
        db 053h,048h,04Bh,038h,00h
str_BOS23:                                      ; "BOS2" string literal
        db 042h,04Fh,053h,032h,00h
str_TB22:                                       ; "TB2" string literal
        db 054h,042h,032h,00h
str_TOR1:                                       ; "TOR1" string literal
        db 054h,04Fh,052h,031h,00h
str_TOR22:                                      ; "TOR2" string literal
        db 054h,04Fh,052h,032h,00h
str_VAN1:                                       ; "VAN1" string literal
        db 056h,041h,04Eh,031h,00h
str_VAN3:                                       ; "VAN3" string literal
        db 056h,041h,04Eh,033h,00h
str_WASH3:                                      ; "WASH3" string literal
        db 057h,041h,053h,048h,033h,00h
str_WINN2:                                      ; "WINN2" string literal
        db 057h,049h,04Eh,04Eh,032h,00h
str_ROCKDITI2:                                  ; "ROCKDITI" string literal
        db 052h,04Fh,043h,04Bh,044h,049h,054h,049h,00h
