; The desk menu: lines, statistics, penalties, scoring, and scratches.
bits 32
%include "hockey.inc"
section s_CEF43 progbits alloc noexec write align=1
extern DeskHomeLines, DeskVisitorLines, DeskGameStats, DeskPenaltySummary, DeskScoringSummary, DeskTeamScratches, StatsSourceMenu, str_VisitingTeam2
extern str_GameStatistics, str_PenaltySummary, str_ScoringSummary, str_TeamScratches, str_StatisticsType8
global menuact_homelines, menuact_visitorlines, DeskGameStatsMenu, DeskStatsTypeMenu
menuact_homelines:                              ; SetSideControls: action slot of the home lines item
                                                ; (DeskHomeLines or 0); used by PreGameScreen, SetSideControls
        dd DeskHomeLines
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
        db 06Eh,00h,00h,00h,024h,00h,00h,00h
        dd str_VisitingTeam2
menuact_visitorlines:                           ; SetSideControls: action slot of the visitor lines item
                                                ; (DeskVisitorLines or 0); used by PreGameScreen,
                                                ; SetSideControls
        dd DeskVisitorLines
        db 00h,00h,00h,00h,00h,00h,00h,00h
DeskGameStatsMenu:                              ; Sports desk pull-down: game statistics and summaries
        db 00h,00h,00h,00h,00h,00h,00h,00h,08Ch,00h,00h,00h,011h,00h,00h,00h
        dd str_GameStatistics
        dd DeskGameStats
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
        db 08Ch,00h,00h,00h,023h,00h,00h,00h
        dd str_PenaltySummary
        dd DeskPenaltySummary
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h
        db 08Ch,00h,00h,00h,035h,00h,00h,00h
        dd str_ScoringSummary
        dd DeskScoringSummary
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,036h,00h,00h,00h
        db 08Ch,00h,00h,00h,048h,00h,00h,00h
        dd str_TeamScratches
        dd DeskTeamScratches
        db 00h,00h,00h,00h,00h,00h,00h,00h
DeskStatsTypeMenu:                              ; Sports desk Statistics pull-down: statistics type
        db 00h,00h,00h,00h,00h,00h,00h,00h,08Ch,00h,00h,00h,011h,00h,00h,00h
        dd str_StatisticsType8
        db 00h,00h,00h,00h
        dd StatsSourceMenu
