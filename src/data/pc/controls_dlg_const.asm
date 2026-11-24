; Strings and constants of pc/controls_dlg (src/pc/controls_dlg), in link order.
bits 32
%include "hockey.inc"
section s_C337C progbits alloc noexec write align=1
global str_BKGD4, str_PlayerImg, str_Dbox5, str_OneS, str_TwoS, str_TheMouse, str_JoystickOne, str_JoystickTwo
global str_TheKeyboard, str_Pointer18
str_BKGD4:                                      ; string 'BKGD'; used by ControlsDlgExh, ControlsDlgInGame,
                                                ; ControlsDlgLeague ...
        db 042h,04Bh,047h,044h,00h
str_PlayerImg:                                  ; string 'player'; used by DrawControlsDlg
        db 070h,06Ch,061h,079h,065h,072h,00h
str_Dbox5:                                      ; string 'dbox'; used by DrawControlsDlg
        db 064h,062h,06Fh,078h,00h
str_OneS:                                       ; string "One's"; used by DrawControlsOpts
        db 04Fh,06Eh,065h,027h,073h,00h
str_TwoS:                                       ; string "Two's"; used by DrawControlsOpts
        db 054h,077h,06Fh,027h,073h,00h
str_TheMouse:                                   ; string 'The Mouse'; used by DrawControlsOpts
        db 054h,068h,065h,020h,04Dh,06Fh,075h,073h,065h,00h
str_JoystickOne:                                ; string 'Joystick One'; used by DrawControlsOpts
        db 04Ah,06Fh,079h,073h,074h,069h,063h,06Bh,020h,04Fh,06Eh,065h,00h
str_JoystickTwo:                                ; string 'Joystick Two'; used by DrawControlsOpts
        db 04Ah,06Fh,079h,073h,074h,069h,063h,06Bh,020h,054h,077h,06Fh,00h
str_TheKeyboard:                                ; string 'The Keyboard'; used by DrawControlsOpts
        db 054h,068h,065h,020h,04Bh,065h,079h,062h,06Fh,061h,072h,064h,00h
str_Pointer18:                                  ; string 'Pointer'; used by ControlsDlgLoop
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h,00h,00h
