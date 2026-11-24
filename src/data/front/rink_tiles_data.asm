; Initialised data of front/rink_tiles (src/front/rink_tiles).
bits 32
%include "hockey.inc"
section s_C7298 progbits alloc noexec write align=1
global rinkarenas, rinktilebm, rinkbm, rinkfileidx, currink, rinkscrollx, rinkscrolly, str_Yes
global str_No4, str_DoYouWishToUse, str_CurrentDbOr, str_OriginalNHLDb, str_Current, str_Original, dbchoicelines, dbchoicebtns
global str_AllTheTeamsAre
rinkarenas:                                     ; 12-byte arena entries: abbrev[4] ("BOS"), map x, y, second
                                                ; map x, y (FFFFh none); used by LoadRink
        db 042h,04Fh
        db 053h,00h
        db 015h,00h
        db 026h,00h
        db 0FFh,0FFh,0FFh,0FFh,042h,055h,046h,00h,016h,00h,024h,00h,0FFh,0FFh,0FFh,0FFh
        db 043h,047h,059h,00h,016h,00h,025h,00h,0FFh,0FFh,0FFh,0FFh,043h,048h,049h,00h
        db 016h,00h,025h,00h,0FFh,0FFh,0FFh,0FFh,044h,045h,054h,00h,015h,00h,025h,00h
        db 0FFh,0FFh,0FFh,0FFh,045h,044h,04Dh,00h,016h,00h,02Ch,00h,019h,00h,023h,00h
        db 048h,046h,044h,00h,016h,00h,025h,00h,0FFh,0FFh,0FFh,0FFh,04Ch,041h,020h,00h
        db 020h,00h,02Dh,00h,0Fh,00h,022h,00h,04Dh,049h,04Eh,00h,015h,00h,025h,00h
        db 0FFh,0FFh,0FFh,0FFh,04Dh,054h,04Ch,00h,016h,00h,025h,00h,0FFh,0FFh,0FFh,0FFh
        db 04Eh,04Ah,020h,00h,01Eh,00h,02Dh,00h,011h,00h,022h,00h,04Eh,059h,049h,00h
        db 016h,00h,026h,00h,0FFh,0FFh,0FFh,0FFh,04Eh,059h,052h,00h,016h,00h,024h,00h
        db 0FFh,0FFh,0FFh,0FFh,04Fh,054h,054h,00h,015h,00h,026h,00h,0FFh,0FFh,0FFh,0FFh
        db 050h,048h,049h,00h,016h,00h,025h,00h,0FFh,0FFh,0FFh,0FFh,050h,049h,054h,00h
        db 0Dh,00h,01Fh,00h,022h,00h,030h,00h,051h,055h,045h,00h,016h,00h,024h,00h
        db 0FFh,0FFh,0FFh,0FFh,053h,054h,04Ch,00h,015h,00h,024h,00h,0FFh,0FFh,0FFh,0FFh
        db 053h,04Ah,020h,00h,015h,00h,026h,00h,0FFh,0FFh,0FFh,0FFh,054h,042h,020h,00h
        db 016h,00h,026h,00h,0FFh,0FFh,0FFh,0FFh,054h,04Fh,052h,00h,016h,00h,026h,00h
        db 0FFh,0FFh,0FFh,0FFh,056h,041h,04Eh,00h,015h,00h,024h,00h,0FFh,0FFh,0FFh,0FFh
        db 057h,053h,048h,00h,016h,00h,025h,00h,0FFh,0FFh,0FFh,0FFh,057h,050h,047h,00h
        db 015h,00h,026h,00h,0FFh,0FFh,0FFh,0FFh,041h,04Eh,048h,00h,015h,00h,025h,00h
        db 0FFh,0FFh,0FFh,0FFh,046h,04Ch,04Fh,00h,015h,00h,025h,00h,0FFh,0FFh,0FFh,0FFh
rinktilebm:                                     ; rink bitmap built by LoadRink; used by BlitTileMap,
                                                ; FreeRinkGfx, LoadRink
        db 00h,00h,00h,00h
rinkbm:                                         ; used by EnsureFreeMemory, FreeRinkGfx, LoadRink ...
        db 00h,00h,00h,00h
rinkfileidx:                                    ; used by LoadRink
        db 02Ch,00h,00h,00h,035h,00h,00h,00h,048h,00h,00h,00h,04Ah,00h,00h,00h
        db 05Dh,00h,00h,00h,06Eh,00h,00h,00h,09Eh,00h,00h,00h,0DDh,00h,00h,00h
        db 0EBh,00h,00h,00h,0FDh,00h,00h,00h,05h,01h,00h,00h,0Eh,01h,00h,00h
        db 010h,01h,00h,00h,012h,01h,00h,00h,01Fh,01h,00h,00h,02Dh,01h,00h,00h
        db 057h,01h,00h,00h,092h,01h,00h,00h,086h,01h,00h,00h,097h,01h,00h,00h
        db 0A3h,01h,00h,00h,0B1h,01h,00h,00h,0BFh,01h,00h,00h,0BCh,01h,00h,00h
        db 025h,00h,00h,00h,093h,00h,00h,00h
currink:                                        ; rink loaded in rinktilebm (-1 none); used by FreeRinkGfx,
                                                ; LoadRink
        db 0FFh,0FFh,0FFh,0FFh
rinkscrollx:                                    ; last SetRinkScroll x (negated; +3E8h forces a redraw); used
                                                ; by Gameloop, HandleHotKey, InstantReplay ...
        db 00h,00h,00h,00h
rinkscrolly:                                    ; last SetRinkScroll y; used by Gameloop, HandleHotKey,
                                                ; InstantReplay ...
        db 00h,00h,00h,00h
str_Yes:                                        ; "Yes" string literal
        db 059h,065h,073h,00h
str_No4:                                        ; "No" string literal
        db 04Eh,06Fh,00h
str_DoYouWishToUse:                             ; string 'Do you wish to use your'
        db 044h,06Fh,020h,079h,06Fh,075h,020h,077h,069h,073h,068h,020h,074h,06Fh,020h,075h
        db 073h,065h,020h,079h,06Fh,075h,072h,00h
str_CurrentDbOr:                                ; string 'Current database or the'
        db 043h,075h,072h,072h,065h,06Eh,074h,020h,064h,061h,074h,061h,062h,061h,073h,065h
        db 020h,06Fh,072h,020h,074h,068h,065h,00h
str_OriginalNHLDb:                              ; string 'Original NHL database?'
        db 04Fh,072h,069h,067h,069h,06Eh,061h,06Ch,020h,04Eh,048h,04Ch,020h,064h,061h,074h
        db 061h,062h,061h,073h,065h,03Fh,00h
str_Current:                                    ; string 'Current'
        db 043h,075h,072h,072h,065h,06Eh,074h,00h
str_Original:                                   ; string 'Original'
        db 04Fh,072h,069h,067h,069h,06Eh,061h,06Ch,00h
dbchoicelines:                                  ; 3 prompt lines; used by AskDatabaseChoice
        dd str_DoYouWishToUse
        dd str_CurrentDbOr
        dd str_OriginalNHLDb
dbchoicebtns:                                   ; 2 buttons (Current / Original); used by AskDatabaseChoice
        db 010h,00h,00h,00h,050h,00h,00h,00h,060h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,05h,00h,00h,00h
        dd str_Current
        db 0F0h,0FFh,0FFh,0FFh,050h,00h,00h,00h,060h,00h,00h,00h,014h,00h,00h,00h
        db 00h,00h,00h,00h,06h,00h,00h,00h
        dd str_Original
str_AllTheTeamsAre:                             ; "All the teams are already human" string literal
        db 041h,06Ch,06Ch,020h,074h,068h,065h,020h,074h,065h,061h,06Dh,073h,020h,061h,072h
        db 065h,020h,061h,06Ch,072h,065h,061h,064h,079h,020h,068h,075h,06Dh,061h,06Eh,00h
