; Strings and constants of pc/mode_settings (src/pc/mode_settings), in link order.
bits 32
%include "hockey.inc"
section s_C3300 progbits alloc noexec write align=1
global str_BKGD2, str_Setting7, str_Setting4, str_Dbox3, str_Music2, str_Sound2, str_DigitizedSpeech2, str_Pointer16
str_BKGD2:                                      ; string 'BKGD'; used by MenuModeSettings
        db 042h,04Bh,047h,044h,00h
str_Setting7:                                   ; string 'setting7'; used by DrawModeSetDlg
        db 073h,065h,074h,074h,069h,06Eh,067h,037h,00h
str_Setting4:                                   ; string 'setting4'; used by DrawModeSetDlg
        db 073h,065h,074h,074h,069h,06Eh,067h,034h,00h
str_Dbox3:                                      ; string 'dbox'; used by DrawModeSetDlg
        db 064h,062h,06Fh,078h,00h
str_Music2:                                     ; string 'Music'; used by DrawModeSetDlg, ModeOptsToBits
        db 04Dh,075h,073h,069h,063h,00h
str_Sound2:                                     ; string 'Sound'; used by DrawModeSetDlg, ModeOptsToBits
        db 053h,06Fh,075h,06Eh,064h,00h
str_DigitizedSpeech2:                           ; string 'Digitized Speech'; used by DrawModeSetDlg,
                                                ; ModeOptsToBits
        db 044h,069h,067h,069h,074h,069h,07Ah,065h,064h,020h,053h,070h,065h,065h,063h,068h
        db 00h
str_Pointer16:                                  ; string 'Pointer'; used by ModeSetEditLoop, ModeSetViewLoop
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h,00h,00h,00h
