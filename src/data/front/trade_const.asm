; Strings and constants of front/trade (src/front/trade), in link order.
bits 32
%include "hockey.inc"
section s_C1964 progbits alloc noexec write align=1
global str_Temp6, str_Tstat, str_Keys2, str_Pstat2, str_Gstat2, str_Embpal3, str_Pal21, str_Donepal
global str_TheJerseyNumber2d2, str_EnterJerseyNumberFor, str_Pal22, str_C2dS, str_HOMEPALS2, str_Embnhl2, str_Bkgd9, str_Pntr2
global str_Pointer10, str_Menubuff7, str_S12, str_Lineditp, str_Shrt, str_Show, str_Statistics, str_HOMEPALS
global str_easndesk, str_bangpal, str_LLST, str_LLSN, str_extnum, str_saved
str_Temp6:                                      ; string 'temp'; used by TradeScreen, TradeShowStats
        db 074h,065h,06Dh,070h,00h
str_Tstat:                                      ; string 'tstat'; used by TradeShowStats
        db 074h,073h,074h,061h,074h,00h
str_Keys2:                                      ; string 'keys'; used by TradeShowStats
        db 06Bh,065h,079h,073h,00h
str_Pstat2:                                     ; string 'pstat'; used by TradeShowStats
        db 070h,073h,074h,061h,074h,00h
str_Gstat2:                                     ; string 'gstat'; used by TradeShowStats
        db 067h,073h,074h,061h,074h,00h
str_Embpal3:                                    ; string 'embpal'; used by DrawTradeScreen, TradeShowStats
        db 065h,06Dh,062h,070h,061h,06Ch,00h
str_Pal21:                                      ; string '!pal'; used by DrawTradeScreen, TradeShowStats
        db 021h,070h,061h,06Ch,00h
str_Donepal:                                    ; string 'donepal'; used by FixJerseyConflict, TradeDone
        db 064h,06Fh,06Eh,065h,070h,061h,06Ch,00h
str_TheJerseyNumber2d2:                         ; string 'The jersey number %2d is already used on %s!'; used
                                                ; by FixJerseyConflict
        db 054h,068h,065h,020h,06Ah,065h,072h,073h,065h,079h,020h,06Eh,075h,06Dh,062h,065h
        db 072h,020h,025h,032h,064h,020h,069h,073h,020h,061h,06Ch,072h,065h,061h,064h,079h
        db 020h,075h,073h,065h,064h,020h,06Fh,06Eh,020h,025h,073h,021h,00h
str_EnterJerseyNumberFor:                       ; string 'Enter jersey number for %s'; used by
                                                ; FixJerseyConflict
        db 045h,06Eh,074h,065h,072h,020h,06Ah,065h,072h,073h,065h,079h,020h,06Eh,075h,06Dh
        db 062h,065h,072h,020h,066h,06Fh,072h,020h,025h,073h,00h
str_Pal22:                                      ; string 'Pal'; used by DrawTradeScreen, ExecuteTrade
        db 050h,061h,06Ch,00h
str_C2dS:                                       ; string '%c %2d %s'; used by DrawTradeRow, DrawTradeScreen
        db 025h,063h,020h,025h,032h,064h,020h,025h,073h,00h
str_HOMEPALS2:                                  ; string 'HOMEPALS'; used by LoadTradeTeamPals
        db 048h,04Fh,04Dh,045h,050h,041h,04Ch,053h,00h
str_Embnhl2:                                    ; string 'embnhl'; used by DrawTradeScreen
        db 065h,06Dh,062h,06Eh,068h,06Ch,00h
str_Bkgd9:                                      ; string 'bkgd'; used by DrawTradeScreen
        db 062h,06Bh,067h,064h,00h
str_Pntr2:                                      ; string 'pntr'; used by TradeScreenLoop
        db 070h,06Eh,074h,072h,00h
str_Pointer10:                                  ; string 'Pointer'; used by TradeScreenLoop
        db 050h,06Fh,069h,06Eh,074h,065h,072h,00h
str_Menubuff7:                                  ; string 'menubuff'; used by TradeScreenLoop
        db 06Dh,065h,06Eh,075h,062h,075h,066h,066h,00h
str_S12:                                        ; string 's1'; used by TradeScreen
        db 073h,031h,00h
str_Lineditp:                                   ; string 'lineditp'; used by TradeScreen
        db 06Ch,069h,06Eh,065h,064h,069h,074h,070h,00h
str_Shrt:                                       ; string 'shrt'; used by TradeScreen
        db 073h,068h,072h,074h,00h
str_Show:                                       ; string 'Show '; used by TradePlayers
        db 053h,068h,06Fh,077h,020h,00h
str_Statistics:                                 ; string ' Statistics...'; used by TradePlayers
        db 020h,053h,074h,061h,074h,069h,073h,074h,069h,063h,073h,02Eh,02Eh,02Eh,00h,00h
str_HOMEPALS:                                   ; string 'HOMEPALS'; used by LoadHomePals
        db 048h,04Fh,04Dh,045h,050h,041h,04Ch,053h,00h,00h,00h,00h
str_easndesk:                                   ; string 'easndesk'; used by AddHumanTeam, RemoveHumanTeam
        db 065h,061h,073h,06Eh,064h,065h,073h,06Bh,00h
str_bangpal:                                    ; string '!pal'; used by AddHumanTeam, RemoveHumanTeam
        db 021h,070h,061h,06Ch,00h,00h,00h
str_LLST:                                       ; string 'LLST'; used by BuildLeagueList
        db 04Ch,04Ch,053h,054h,00h
str_LLSN:                                       ; string 'LLSN'; used by BuildLeagueList
        db 04Ch,04Ch,053h,04Eh,00h
str_extnum:                                     ; string '.%02d'; used by CopyHumanTeamDBs
        db 02Eh,025h,030h,032h,064h,00h
str_saved:                                      ; string 'saved'; used by SaveLeagueGameRef
        db 073h,061h,076h,065h,064h,00h,00h,00h
