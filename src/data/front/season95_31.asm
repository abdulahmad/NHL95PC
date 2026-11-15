; The button on the trade statistics dialog.
bits 32
%include "hockey.inc"
section s_C87C0 progbits alloc noexec write align=1
extern TradeShowStats, TradeDone, TradeCancel, MenuReturnToLineEditor, unk_C17F0, unk_C87B8
global menuwidth_trade1, menutext_trade1, menuwidth_trade2, menutext_trade2, str_Done4, str_Cancel7, unk_C8804, str_Trade
global str_PlayerStatistics5, btn_TradeStats, str_Trade2, unk_C88C2
menuwidth_trade1:
db 0BAh,00h,00h,00h,011h,00h,00h,00h
menutext_trade1:
db 00h,00h,00h,00h
dd TradeShowStats
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
menuwidth_trade2:
db 0BAh,00h,00h,00h,024h,00h,00h,00h
menutext_trade2:
db 00h,00h,00h,00h
dd TradeShowStats
db 00h,00h,00h,00h,00h,00h,00h,00h
str_Done4:
db 044h,06Fh,06Eh,065h,00h
str_Cancel7:
db 043h,061h,06Eh,063h,065h,06Ch,00h
unk_C8804:
db 00h,00h,00h,00h,00h,00h,00h,00h,034h,00h,00h,00h,011h,00h,00h,00h
dd str_Done4
dd TradeDone
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
db 034h,00h,00h,00h,024h,00h,00h,00h
dd str_Cancel7
dd TradeCancel
db 00h,00h,00h,00h,00h,00h,00h,00h
str_Trade:
db 054h,072h,061h,064h,065h,00h
str_PlayerStatistics5:
db 050h,06Ch,061h,079h,065h,072h,020h,053h,074h,061h,074h,069h,073h,074h,069h,063h
db 073h,00h
btn_TradeStats:
db 0BFh,00h,00h,00h,00h,00h,00h,00h,0EFh,00h,00h,00h,012h,00h,00h,00h
dd unk_C17F0
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0F0h,00h,00h,00h
db 00h,00h,00h,00h,01Bh,01h,00h,00h,012h,00h,00h,00h
dd str_Trade
db 00h,00h,00h,00h
dd unk_C8804
db 02h,00h,00h,00h,01Ch,01h,00h,00h,00h,00h,00h,00h,091h,01h,00h,00h
db 012h,00h,00h,00h
dd str_PlayerStatistics5
db 00h,00h,00h,00h
dd unk_C87B8
db 02h,00h,00h,00h
str_Trade2:
db 054h,072h,061h,064h,065h,00h
unk_C88C2:
db 00h,00h,00h,00h,00h,00h,00h,00h,02Bh,00h,00h,00h,012h,00h,00h,00h
dd str_Trade2
dd MenuReturnToLineEditor
db 00h,00h,00h,00h,00h,00h,00h,00h
