; Strings and constants of front/replay_controls (src/front/replay_controls), in link order.
bits 32
%include "hockey.inc"
section s_C33D4 progbits alloc noexec write align=1
global str_MTROCKU, str_SBROCKU, str_ADROCKU, str_ROCKDITI, str_BothTeams, str_NeitherTeams, str_Gadget6, str_Gadget5
global str_Gad1, str_Pointer19, str_SaveTo, str_HilightsReel
str_MTROCKU:                                    ; string 'MTROCKU'; used by LoadRockMusic
        db 04Dh,054h,052h,04Fh,043h,04Bh,055h,00h
str_SBROCKU:                                    ; string 'SBROCKU'; used by LoadRockMusic
        db 053h,042h,052h,04Fh,043h,04Bh,055h,00h
str_ADROCKU:                                    ; string 'ADROCKU'; used by LoadRockMusic
        db 041h,044h,052h,04Fh,043h,04Bh,055h,00h
str_ROCKDITI:                                   ; string 'ROCKDITI'; used by LoadRockMusic
        db 052h,04Fh,043h,04Bh,044h,049h,054h,049h,00h,00h,00h,00h
str_BothTeams:                                  ; string 'Both Teams'; used by bothneitherstrs
        db 042h,06Fh,074h,068h,020h,054h,065h,061h,06Dh,073h,00h
str_NeitherTeams:                               ; string 'Neither Teams'; used by bothneitherstrs
        db 04Eh,065h,069h,074h,068h,065h,072h,020h,054h,065h,061h,06Dh,073h,00h
str_Gadget6:                                    ; string 'gadget6'; used by InstantReplay, ReplaySaveHilight,
                                                ; ReplaySaveHilight_n3
        db 067h,061h,064h,067h,065h,074h,036h,00h
str_Gadget5:                                    ; string 'gadget5'; used by InstantReplay
        db 067h,061h,064h,067h,065h,074h,035h,00h
str_Gad1:                                       ; string 'gad1'; used by InstantReplay, ReplaySaveHilight,
                                                ; ReplaySaveHilight_n3
        db 067h,061h,064h,031h,00h
str_Pointer19:                                  ; string 'Pointer'; used by ReplaySaveHilight
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h
str_SaveTo:                                     ; string 'Save To'; used by HilightSaveToDlg
        db 053h,061h,076h,065h,020h,054h,06Fh,00h
str_HilightsReel:                               ; string 'Hilights Reel'; used by HilightSaveToDlg
        db 048h,069h,06Ch,069h,067h,068h,074h,073h,020h,052h,065h,065h,06Ch,00h
