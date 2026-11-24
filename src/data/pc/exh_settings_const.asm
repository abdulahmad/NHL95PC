; Strings and constants of pc/exh_settings (src/pc/exh_settings), in link order.
bits 32
%include "hockey.inc"
section s_C3344 progbits alloc noexec write align=1
global str_BKGD3, str_DigitizedSpeech3, str_Music3, str_Sound3, str_Setting6, str_Dbox4, str_Pointer17
str_BKGD3:                                      ; string 'BKGD'; used by MenuExhibitionSettings
        db 042h,04Bh,047h,044h,00h
str_DigitizedSpeech3:                           ; string 'Digitized Speech'; used by DrawExhSetDlg,
                                                ; ExhOptsToBits
        db 044h,069h,067h,069h,074h,069h,07Ah,065h,064h,020h,053h,070h,065h,065h,063h,068h
        db 00h
str_Music3:                                     ; string 'Music'; used by DrawExhSetDlg, ExhOptsToBits
        db 04Dh,075h,073h,069h,063h,00h
str_Sound3:                                     ; string 'Sound'; used by DrawExhSetDlg, ExhOptsToBits
        db 053h,06Fh,075h,06Eh,064h,00h
str_Setting6:                                   ; string 'setting6'; used by DrawExhSetDlg
        db 073h,065h,074h,074h,069h,06Eh,067h,036h,00h
str_Dbox4:                                      ; string 'dbox'; used by DrawExhSetDlg
        db 064h,062h,06Fh,078h,00h
str_Pointer17:                                  ; string 'Pointer'; used by ExhSetEditLoop
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h
