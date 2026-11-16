; The button on the trade statistics dialog.
bits 32
%include "hockey.inc"
section s_C87C0 progbits alloc noexec write align=1
extern TradeShowStats, TradeDone, TradeCancel, MenuReturnToLineEditor, TradeLabelText, TradeStatsMenu
global menuwidth_trade1, menutext_trade1, menuwidth_trade2, menutext_trade2, str_Done4, str_Cancel7, TradeFileMenu, str_Trade
global str_PlayerStatistics5, btn_TradeStats, str_Trade2, TradeStatsReturnMenu
menuwidth_trade1:                               ; TradePlayers: width slot of the first team's trade menu
                                                ; item; used by TradePlayers
        db 0BAh,00h,00h,00h,011h,00h,00h,00h
menutext_trade1:                                ; TradePlayers: text slot of the first team's trade menu item;
                                                ; used by TradePlayers
        db 00h,00h,00h,00h
        dd TradeShowStats
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
menuwidth_trade2:                               ; TradePlayers: width slot of the second team's trade menu
                                                ; item; used by TradePlayers
        db 0BAh,00h,00h,00h,024h,00h,00h,00h
menutext_trade2:                                ; TradePlayers: text slot of the second team's trade menu
                                                ; item; used by TradePlayers
        db 00h,00h,00h,00h
        dd TradeShowStats
        db 00h,00h,00h,00h,00h,00h,00h,00h
str_Done4:                                      ; "Done" string literal
        db 044h,06Fh,06Eh,065h,00h
str_Cancel7:                                    ; "Cancel" string literal
        db 043h,061h,06Eh,063h,065h,06Ch,00h
TradeFileMenu:                                  ; Trade screen pull-down: done and cancel
        db 00h,00h,00h,00h,00h,00h,00h,00h,034h,00h,00h,00h,011h,00h,00h,00h
        dd str_Done4
        dd TradeDone
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
        db 034h,00h,00h,00h,024h,00h,00h,00h
        dd str_Cancel7
        dd TradeCancel
        db 00h,00h,00h,00h,00h,00h,00h,00h
str_Trade:                                      ; "Trade" string literal
        db 054h,072h,061h,064h,065h,00h
str_PlayerStatistics5:                          ; "Player Statistics" string literal
        db 050h,06Ch,061h,079h,065h,072h,020h,053h,074h,061h,074h,069h,073h,074h,069h,063h
        db 073h,00h
btn_TradeStats:                                 ; button table for the TradePlayers team picker (the two 'Show
                                                ; <city> Statistics...' buttons); used by TradePlayers
        db 0BFh,00h,00h,00h,00h,00h,00h,00h,0EFh,00h,00h,00h,012h,00h,00h,00h
        dd TradeLabelText
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0F0h,00h,00h,00h
        db 00h,00h,00h,00h,01Bh,01h,00h,00h,012h,00h,00h,00h
        dd str_Trade
        db 00h,00h,00h,00h
        dd TradeFileMenu
        db 02h,00h,00h,00h,01Ch,01h,00h,00h,00h,00h,00h,00h,091h,01h,00h,00h
        db 012h,00h,00h,00h
        dd str_PlayerStatistics5
        db 00h,00h,00h,00h
        dd TradeStatsMenu
        db 02h,00h,00h,00h
str_Trade2:                                     ; "Trade" string literal
        db 054h,072h,061h,064h,065h,00h
TradeStatsReturnMenu:                           ; Trade statistics pull-down: return to the trade screen
        db 00h,00h,00h,00h,00h,00h,00h,00h,02Bh,00h,00h,00h,012h,00h,00h,00h
        dd str_Trade2
        dd MenuReturnToLineEditor
        db 00h,00h,00h,00h,00h,00h,00h,00h
