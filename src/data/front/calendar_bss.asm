; BSS of front/calendar (src/front/calendar).
bits 32
%include "hockey.inc"
section s_DD794 nobits alloc noexec write align=1
global calexit, teamselresult, traderesult, calmonth
calexit:                                        ; set by CalReturn; used by CalReturn, CalendarScreen
        resb 4
teamselresult:                                  ; 1 Done / -1 Cancel; used by LeagueTeamSelect, TeamSelCancel,
                                                ; TeamSelDone
        resb 4
traderesult:                                    ; trade screen result (Done / Cancel); used by TradeCancel,
                                                ; TradeDone, TradeScreenLoop
        resb 4
calmonth:                                       ; calendar month 0-11; used by CalNextMonth, CalPrevMonth,
                                                ; CalendarScreen
        resb 4
