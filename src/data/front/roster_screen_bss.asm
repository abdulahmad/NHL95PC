; BSS of front/roster_screen (src/front/roster_screen).
bits 32
%include "hockey.inc"
section s_DC6B8 nobits alloc noexec write align=1
global statsnumgoalies, statsskaterorder, statsgoalieorder, RosterFromStandings, leaguestatsmode, statsgoalieplr, statsnumskaters, statsskaterplr
statsnumgoalies:                                ; goalie count; used by PlayerFromMouseY, RunPlayerPickMenu,
                                                ; TeamRosterScreen
        resb 4
statsskaterorder:                               ; sorted skater list (qsort CompareSkaterStats); used by
                                                ; RunPlayerPickMenu, ShowRosterStats, TeamRosterScreen
        resb 100
statsgoalieorder:                               ; sorted goalie list (qsort CompareGoalieStats); used by
                                                ; RunPlayerPickMenu, ShowRosterStats, TeamRosterScreen
        resb 20
RosterFromStandings:                            ; Set when the team roster screen is opened from a standings
                                                ; or stats menu; picks the roster layout; used by
                                                ; CalStandingsMenu_roster, EasnStandingsMenu_roster,
                                                ; GameStandingsMenu_roster ...
        resb 4
leaguestatsmode:                                ; set while the stats screens run from the league (calendar)
                                                ; rather than a game: the stats menus then load their own
                                                ; palettes; used by CalGoalieStatsScreen,
                                                ; CalSkaterStatsScreen, CalStandingsMenu ...
        resb 4
statsgoalieplr:                                 ; goalie -> statsplayerbuf index; used by RunPlayerPickMenu,
                                                ; ShowRosterStats, TeamRosterScreen
        resb 20
statsnumskaters:                                ; skater count; used by PlayerFromMouseY, RunPlayerPickMenu,
                                                ; TeamRosterScreen
        resb 4
statsskaterplr:                                 ; skater -> statsplayerbuf index; used by RunPlayerPickMenu,
                                                ; ShowRosterStats, TeamRosterScreen
        resb 100
