; Strings and constants of front/rink_tiles (src/front/rink_tiles), in link order.
bits 32
%include "hockey.inc"
section s_C1794 progbits alloc noexec write align=1
global str_Rink2, str_Til, str_InvalidFileSize, str_TILES, str_ErrorLoadingFile, str_Map, str_CRESTS3, str_Pal16
global TradeLabelText
str_Rink2:                                      ; string 'rink'; used by LoadRink
        db 072h,069h,06Eh,06Bh,00h
str_Til:                                        ; string '.til'; used by LoadRink
        db 02Eh,074h,069h,06Ch,00h
str_InvalidFileSize:                            ; string "Invalid file '%s' size %d\n"; used by LoadRink
        db 049h,06Eh,076h,061h,06Ch,069h,064h,020h,066h,069h,06Ch,065h,020h,027h,025h,073h
        db 027h,020h,073h,069h,07Ah,065h,020h,025h,064h,0Ah,00h
str_TILES:                                      ; string 'TILES'; used by LoadRink
        db 054h,049h,04Ch,045h,053h,00h
str_ErrorLoadingFile:                           ; string "Error loading file '%s'\n"; used by LoadRink
        db 045h,072h,072h,06Fh,072h,020h,06Ch,06Fh,061h,064h,069h,06Eh,067h,020h,066h,069h
        db 06Ch,065h,020h,027h,025h,073h,027h,0Ah,00h
str_Map:                                        ; string '.map'; used by LoadRink
        db 02Eh,06Dh,061h,070h,00h,00h,00h,00h
str_CRESTS3:                                    ; string 'CRESTS3'; used by LoadCrestsPalette
        db 043h,052h,045h,053h,054h,053h,033h,00h
str_Pal16:                                      ; string '!pal'; used by LoadCrestsPalette
        db 021h,070h,061h,06Ch,00h,00h,00h,00h
TradeLabelText:                                 ; Empty text of the first item of the trade screen menu bar
        db 00h,00h,00h,00h
