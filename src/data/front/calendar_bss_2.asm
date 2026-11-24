; BSS of front/calendar (src/front/calendar): the module's second run in link order.
bits 32
%include "hockey.inc"
section s_DDD28 nobits alloc noexec write align=1
global calselday, calredraw, calselmonth
calselday:                                      ; day of the selected game; used by CalendarScreen,
                                                ; DrawCalendarDay
        resb 4
calredraw:                                      ; CalendarScreen: set to redraw the month; used by
                                                ; CalStandingsMenu_player2, CalTeamStatsScreen_common,
                                                ; CalendarScreen
        resb 4
calselmonth:                                    ; month of the selected game (1-based); used by
                                                ; CalendarScreen, DrawCalendarDay
        resb 4
