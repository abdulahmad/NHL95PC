; Strings and constants of pc/league_settings (src/pc/league_settings), in link order.
bits 32
%include "hockey.inc"
section s_C32BC progbits alloc noexec write align=1
global str_BKGD, str_Setting5, str_Dbox2, str_Music, str_Sound, str_DigitizedSpeech, str_Setting3, str_Pointer15
str_BKGD:                                       ; string 'BKGD'; used by EditPlayoffSettings,
                                                ; LeagueSettingsDlg, MenuLeagueSettingsEdit ...
        db 042h,04Bh,047h,044h,00h
str_Setting5:                                   ; string 'setting5'; used by DrawLeagueSetDlgSel,
                                                ; MenuShowLeagueSettings2
        db 073h,065h,074h,074h,069h,06Eh,067h,035h,00h
str_Dbox2:                                      ; string 'dbox'; used by DrawLeagueSetDlg,
                                                ; DrawLeagueSetDlgSel, MenuShowLeagueSettings2
        db 064h,062h,06Fh,078h,00h
str_Music:                                      ; string 'Music'; used by DrawLeagueSetDlg,
                                                ; DrawLeagueSetDlgSel, MenuShowLeagueSettings2
        db 04Dh,075h,073h,069h,063h,00h
str_Sound:                                      ; string 'Sound'; used by DrawLeagueSetDlg,
                                                ; DrawLeagueSetDlgSel, MenuShowLeagueSettings2
        db 053h,06Fh,075h,06Eh,064h,00h
str_DigitizedSpeech:                            ; string 'Digitized Speech'; used by DrawLeagueSetDlg,
                                                ; DrawLeagueSetDlgSel, MenuShowLeagueSettings2
        db 044h,069h,067h,069h,074h,069h,07Ah,065h,064h,020h,053h,070h,065h,065h,063h,068h
        db 00h
str_Setting3:                                   ; string 'setting3'; used by DrawLeagueSetDlg,
                                                ; DrawLeagueSetDlgSel
        db 073h,065h,074h,074h,069h,06Eh,067h,033h,00h
str_Pointer15:                                  ; string 'Pointer'; used by LeagueSetEditLoop,
                                                ; LeagueSetViewLoop
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h,00h,00h,00h
