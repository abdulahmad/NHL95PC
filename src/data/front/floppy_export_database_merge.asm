; Calendar menus, the league team-select menu, and which weekday each month starts on.
bits 32
%include "hockey.inc"
section s_C8445 progbits alloc noexec write align=1
extern CalStandingsMenu, CalNextMonth, CalPrevMonth, CalReturn, TeamSelDone, TeamSelCancel, MenuLeagueSettingsEdit, MenuShowLeagueSettings
extern MenuShowLeagueSettings2, MenuP1ControlsLeague, MenuP2ControlsLeague, StatsSourceMenu, str_StatisticsType8, str_Standings2, str_TeamsSortedBy2, str_PlayersSortedBy2
extern str_GoaliesSortedBy2, TeamStatsSortMenu, SkaterStatsSortMenu, GoalieStatsSortMenu
global monthdays, curleague, monthfirstday_m1, monthfirstday, teamselsetslot, calnextslot, calprevslot, CalStatsMenu
global str_Player1Controls, str_Player2Controls, str_ShowLeagueSettings, CalSettingsMenu, str_NextMonth, str_PrevMonth, str_ReturnToSportsCentral, calplaymenu
global str_Play3, str_Game5, str_Statistics2, calmenubar, str_ShowLeagueSettings2, lgsetshowmenu, str_LeagueSettings, lgsetmenu
global str_Done3, str_Cancel3, teamselmenu, str_Select, str_Settings2, teamselmenubar, TradeStatsMenu
monthdays:                                      ; 31,28,31,30,31,30,31,31,30,31,30,31; used by CalendarScreen,
                                                ; DrawCalendarDay
        db 01Fh,01Ch,01Fh,01Eh,01Fh,01Eh,01Fh,01Fh,01Eh,01Fh,01Eh,01Fh
curleague:                                      ; current league path: every league routine builds
                                                ; <curleague>\PINFO.DB, TEAMS.DB, SCHEDULE.DB from it and
                                                ; strips it at '.' for message text; used by AddHumanTeam,
                                                ; CheckGameDiskSpace, CheckMasterPassword ...
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
monthfirstday_m1:                               ; the same table indexed by 1-based month (monthfirstday-1);
                                                ; used by CalendarScreen
        db 00h
monthfirstday:                                  ; weekday (Mon = 0) of the 1st of each month, 0-based month;
                                                ; used by CalendarScreen, DrawCalendarDay
        db 06h,02h,02h,05h,00h,03h,05h,01h,04h,05h,01h,03h
CalStatsMenu:                                   ; Calendar menu bar pull-down: statistics type and sort orders
        db 00h,00h,00h,00h,00h,00h,00h,00h,08Ch,00h,00h,00h,011h,00h,00h,00h
        dd str_StatisticsType8
        db 00h,00h,00h,00h
        dd StatsSourceMenu
        db 05h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h,08Ch,00h,00h,00h
        db 023h,00h,00h,00h
        dd str_Standings2
        dd CalStandingsMenu
        db 00h,00h,00h,00h,01h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h
        db 08Ch,00h,00h,00h,035h,00h,00h,00h
        dd str_TeamsSortedBy2
        db 00h,00h,00h,00h
        dd TeamStatsSortMenu
        db 05h,00h,00h,00h,00h,00h,00h,00h,036h,00h,00h,00h,08Ch,00h,00h,00h
        db 047h,00h,00h,00h
        dd str_PlayersSortedBy2
        db 00h,00h,00h,00h
        dd SkaterStatsSortMenu
        db 08h,00h,00h,00h,00h,00h,00h,00h,048h,00h,00h,00h,08Ch,00h,00h,00h
        db 05Ah,00h,00h,00h
        dd str_GoaliesSortedBy2
        db 00h,00h,00h,00h
        dd GoalieStatsSortMenu
        db 03h,00h,00h,00h
str_Player1Controls:                            ; "Player 1 Controls ..." string literal
        db 050h,06Ch,061h,079h,065h,072h,020h,031h,020h,043h,06Fh,06Eh,074h,072h,06Fh,06Ch
        db 073h,020h,02Eh,02Eh,02Eh,00h
str_Player2Controls:                            ; "Player 2 Controls ..." string literal
        db 050h,06Ch,061h,079h,065h,072h,020h,032h,020h,043h,06Fh,06Eh,074h,072h,06Fh,06Ch
        db 073h,020h,02Eh,02Eh,02Eh,00h
str_ShowLeagueSettings:                         ; "Show League Settings ..." string literal
        db 053h,068h,06Fh,077h,020h,04Ch,065h,061h,067h,075h,065h,020h,053h,065h,074h,074h
        db 069h,06Eh,067h,073h,020h,02Eh,02Eh,02Eh,00h
CalSettingsMenu:                                ; Calendar menu bar pull-down: player controls and league
                                                ; settings
        db 00h,00h,00h,00h,00h,00h,00h,00h,0A7h,00h,00h,00h,011h,00h,00h,00h
        dd str_Player1Controls
        dd MenuP1ControlsLeague
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
        db 0A7h,00h,00h,00h,023h,00h,00h,00h
        dd str_Player2Controls
        dd MenuP2ControlsLeague
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h
        db 0A7h,00h,00h,00h,036h,00h,00h,00h
        dd str_ShowLeagueSettings
        dd MenuShowLeagueSettings2
        db 00h,00h,00h,00h,00h,00h,00h,00h
str_NextMonth:                                  ; string 'Next month'
        db 04Eh,065h,078h,074h,020h,06Dh,06Fh,06Eh,074h,068h,00h
str_PrevMonth:                                  ; string 'Previous month'
        db 050h,072h,065h,076h,069h,06Fh,075h,073h,020h,06Dh,06Fh,06Eh,074h,068h,00h
str_ReturnToSportsCentral:                      ; string 'Return to Sports Central'
        db 052h,065h,074h,075h,072h,06Eh,020h,074h,06Fh,020h,053h,070h,06Fh,072h,074h,073h
        db 020h,043h,065h,06Eh,074h,072h,061h,06Ch,00h
calplaymenu:                                    ; calendar Play menu (Next month / Previous month / Return to
                                                ; Sports Central)
        db 00h,00h,00h,00h,00h,00h,00h,00h,0A9h,00h,00h,00h,011h,00h,00h,00h
        dd str_NextMonth
calnextslot:                                    ; "Next month" action slot (cleared at the last month); used
                                                ; by CalNextMonth, CalPrevMonth, CalendarScreen
        dd CalNextMonth
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
        db 0A9h,00h,00h,00h,023h,00h,00h,00h
        dd str_PrevMonth
calprevslot:                                    ; "Previous month" action slot; used by CalNextMonth,
                                                ; CalPrevMonth, CalendarScreen
        dd CalPrevMonth
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h
        db 0A9h,00h,00h,00h,036h,00h,00h,00h
        dd str_ReturnToSportsCentral
        dd CalReturn
        db 00h,00h,00h,00h,00h,00h,00h,00h
str_Play3:                                      ; "Play" string literal
        db 050h,06Ch,061h,079h,00h
str_Game5:                                      ; "Game" string literal
        db 047h,061h,06Dh,065h,00h
str_Statistics2:                                ; "Statistics" string literal
        db 053h,074h,061h,074h,069h,073h,074h,069h,063h,073h,00h
calmenubar:                                     ; calendar menu bar (Play / Game / Statistics); used by
                                                ; CalendarScreen
        db 00h,00h,00h,00h,00h,00h,00h,00h,025h,00h,00h,00h,012h,00h,00h,00h
        dd str_Play3
        db 00h,00h,00h,00h
        dd calplaymenu
        db 03h,00h,00h,00h,026h,00h,00h,00h,00h,00h,00h,00h,051h,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_Game5
        db 00h,00h,00h,00h
        dd CalSettingsMenu
        db 03h,00h,00h,00h,052h,00h,00h,00h,00h,00h,00h,00h,097h,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_Statistics2
        db 00h,00h,00h,00h
        dd CalStatsMenu
        db 05h,00h,00h,00h
str_ShowLeagueSettings2:                        ; "Show League settings" string literal
        db 053h,068h,06Fh,077h,020h,04Ch,065h,061h,067h,075h,065h,020h,073h,065h,074h,074h
        db 069h,06Eh,067h,073h,00h
lgsetshowmenu:                                  ; "Show League settings"; used by LeagueTeamSelect
        db 00h,00h,00h,00h,00h,00h,00h,00h,097h,00h,00h,00h,012h,00h,00h,00h
        dd str_ShowLeagueSettings2
        dd MenuShowLeagueSettings
        db 00h,00h,00h,00h,00h,00h,00h,00h
str_LeagueSettings:                             ; "League settings" string literal
        db 04Ch,065h,061h,067h,075h,065h,020h,073h,065h,074h,074h,069h,06Eh,067h,073h,00h
lgsetmenu:                                      ; "League settings"; used by LeagueTeamSelect
        db 00h,00h,00h,00h,00h,00h,00h,00h,070h,00h,00h,00h,012h,00h,00h,00h
        dd str_LeagueSettings
        dd MenuLeagueSettingsEdit
        db 00h,00h,00h,00h,00h,00h,00h,00h
str_Done3:                                      ; "Done" string literal
        db 044h,06Fh,06Eh,065h,00h
str_Cancel3:                                    ; "Cancel" string literal
        db 043h,061h,06Eh,063h,065h,06Ch,00h
teamselmenu:                                    ; Select menu (Done / Cancel)
        db 00h,00h,00h,00h,00h,00h,00h,00h,034h,00h,00h,00h,011h,00h,00h,00h
        dd str_Done3
        dd TeamSelDone
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
        db 034h,00h,00h,00h,024h,00h,00h,00h
        dd str_Cancel3
        dd TeamSelCancel
        db 00h,00h,00h,00h,00h,00h,00h,00h
str_Select:                                     ; "Select" string literal
        db 053h,065h,06Ch,065h,063h,074h,00h
str_Settings2:                                  ; "Settings" string literal
        db 053h,065h,074h,074h,069h,06Eh,067h,073h,00h
teamselmenubar:                                 ; team select menu bar (Select / Settings); used by
                                                ; LeagueTeamSelect
        db 00h,00h,00h,00h,00h,00h,00h,00h,031h,00h,00h,00h,012h,00h,00h,00h
        dd str_Select
        db 00h,00h,00h,00h
        dd teamselmenu
        db 02h,00h,00h,00h,032h,00h,00h,00h,00h,00h,00h,00h,06Fh,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_Settings2
        db 00h,00h,00h,00h
teamselsetslot:                                 ; Settings submenu slot (lgsetmenu, lgsetshowmenu or none);
                                                ; used by LeagueTeamSelect
        dd lgsetmenu
        db 01h,00h,00h,00h
TradeStatsMenu:                                 ; Trade screen pull-down under Player Statistics
        db 00h,00h,00h,00h,00h,00h,00h,00h
