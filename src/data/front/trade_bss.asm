; BSS of front/trade (src/front/trade).
bits 32
%include "hockey.inc"
section s_DDD74 nobits alloc noexec write align=1
global tradeclick, traderemap1, traderemap2, tradecursor, traderoster, tradejersey, tradeslot, jerseymsg
global tradeside, tradebitmap, MergeResult
tradeclick:                                     ; [2] last clicked row per side (-1 none); used by
                                                ; TradeScreen, TradeScreenLoop
        resb 4
        resb 4
traderemap1:                                    ; colour remap of team 1 (homeremap); used by DrawTradeScreen,
                                                ; TradeScreenLoop
        resb 4
traderemap2:                                    ; colour remap of team 2 (awayremap); used by DrawTradeScreen
        resb 4
tradecursor:                                    ; [2] cursor row per side (-1 none); used by DrawTradeRow,
                                                ; DrawTradeScreen, TradeScreen ...
        resb 4
        resb 4
traderoster:                                    ; [2][28] 16h-byte trade entries (side 2 at +268h); used by
                                                ; DrawTradeRow, DrawTradeScreen, TradeScreen ...
        resb 1
tradejersey:                                    ; traderoster entry +1 jersey (indexed with two registers,
                                                ; kept as its own label); used by DrawTradeRow,
                                                ; DrawTradeScreen, TradeScreenLoop
        resb 1
tradeslot:                                      ; traderoster entry +2 roster slot (two-register index, own
                                                ; label); used by FindTradeSlot, TradeScreenLoop
        resb 614
        resb 616
jerseymsg:                                      ; one-line message table (sprintf buffer) for the jersey
                                                ; conflict; used by FixJerseyConflict
        resb 4
tradeside:                                      ; active side (0 / 1, -1 none); used by TradeScreen,
                                                ; TradeScreenLoop
        resb 4
tradebitmap:                                    ; the 640 x 480 bitmap of the trade screen (TradePlayers makes
                                                ; it); used by DrawTradeScreen, TradePlayers, TradeScreen
        resb 1
        resb 3
MergeResult:                                    ; Result byte of the league file merge and human team dialogs;
                                                ; used by AddHumanTeam, AdvancePlayoffs, BuildPlayoffs ...
        resb 4
