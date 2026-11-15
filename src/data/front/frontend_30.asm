; Calendar menus, the league team-select menu, and which weekday each month starts on.
bits 32
%include "hockey.inc"
section s_C8445 progbits alloc noexec write align=1
extern CalStandingsMenu, CalNextMonth, CalPrevMonth, CalReturn, TeamSelDone, TeamSelCancel, MenuLeagueSettingsEdit, MenuShowLeagueSettings
extern MenuShowLeagueSettings2, MenuP1ControlsLeague, MenuP2ControlsLeague, unk_C67B1, str_StatisticsType8, str_Standings2, str_TeamsSortedBy2, str_PlayersSortedBy2
extern str_GoaliesSortedBy2, unk_CE96F, unk_CEA2F, unk_CEB2F
global monthdays, curleague, monthfirstday_m1, monthfirstday, teamselsetslot, calnextslot, calprevslot, unk_C846A
global str_Player1Controls, str_Player2Controls, str_ShowLeagueSettings, unk_C854F, str_NextMonth, str_PrevMonth, str_ReturnToSportsCentral, calplaymenu
global str_Play3, str_Game5, str_Statistics2, calmenubar, str_ShowLeagueSettings2, lgsetshowmenu, str_LeagueSettings, lgsetmenu
global str_Done3, str_Cancel3, teamselmenu, str_Select, str_Settings2, teamselmenubar, unk_C87B8
monthdays:
db 01Fh,01Ch,01Fh,01Eh,01Fh,01Eh,01Fh,01Fh,01Eh,01Fh,01Eh,01Fh
curleague:
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
monthfirstday_m1:
db 00h
monthfirstday:
db 06h,02h,02h,05h,00h,03h,05h,01h,04h,05h,01h,03h
unk_C846A:
db 00h,00h,00h,00h,00h,00h,00h,00h,08Ch,00h,00h,00h,011h,00h,00h,00h
dd str_StatisticsType8
db 00h,00h,00h,00h
dd unk_C67B1
db 05h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h,08Ch,00h,00h,00h
db 023h,00h,00h,00h
dd str_Standings2
dd CalStandingsMenu
db 00h,00h,00h,00h,01h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h
db 08Ch,00h,00h,00h,035h,00h,00h,00h
dd str_TeamsSortedBy2
db 00h,00h,00h,00h
dd unk_CE96F
db 05h,00h,00h,00h,00h,00h,00h,00h,036h,00h,00h,00h,08Ch,00h,00h,00h
db 047h,00h,00h,00h
dd str_PlayersSortedBy2
db 00h,00h,00h,00h
dd unk_CEA2F
db 08h,00h,00h,00h,00h,00h,00h,00h,048h,00h,00h,00h,08Ch,00h,00h,00h
db 05Ah,00h,00h,00h
dd str_GoaliesSortedBy2
db 00h,00h,00h,00h
dd unk_CEB2F
db 03h,00h,00h,00h
str_Player1Controls:
db 050h,06Ch,061h,079h,065h,072h,020h,031h,020h,043h,06Fh,06Eh,074h,072h,06Fh,06Ch
db 073h,020h,02Eh,02Eh,02Eh,00h
str_Player2Controls:
db 050h,06Ch,061h,079h,065h,072h,020h,032h,020h,043h,06Fh,06Eh,074h,072h,06Fh,06Ch
db 073h,020h,02Eh,02Eh,02Eh,00h
str_ShowLeagueSettings:
db 053h,068h,06Fh,077h,020h,04Ch,065h,061h,067h,075h,065h,020h,053h,065h,074h,074h
db 069h,06Eh,067h,073h,020h,02Eh,02Eh,02Eh,00h
unk_C854F:
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
str_NextMonth:
db 04Eh,065h,078h,074h,020h,06Dh,06Fh,06Eh,074h,068h,00h
str_PrevMonth:
db 050h,072h,065h,076h,069h,06Fh,075h,073h,020h,06Dh,06Fh,06Eh,074h,068h,00h
str_ReturnToSportsCentral:
db 052h,065h,074h,075h,072h,06Eh,020h,074h,06Fh,020h,053h,070h,06Fh,072h,074h,073h
db 020h,043h,065h,06Eh,074h,072h,061h,06Ch,00h
calplaymenu:
db 00h,00h,00h,00h,00h,00h,00h,00h,0A9h,00h,00h,00h,011h,00h,00h,00h
dd str_NextMonth
calnextslot:
dd CalNextMonth
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
db 0A9h,00h,00h,00h,023h,00h,00h,00h
dd str_PrevMonth
calprevslot:
dd CalPrevMonth
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h
db 0A9h,00h,00h,00h,036h,00h,00h,00h
dd str_ReturnToSportsCentral
dd CalReturn
db 00h,00h,00h,00h,00h,00h,00h,00h
str_Play3:
db 050h,06Ch,061h,079h,00h
str_Game5:
db 047h,061h,06Dh,065h,00h
str_Statistics2:
db 053h,074h,061h,074h,069h,073h,074h,069h,063h,073h,00h
calmenubar:
db 00h,00h,00h,00h,00h,00h,00h,00h,025h,00h,00h,00h,012h,00h,00h,00h
dd str_Play3
db 00h,00h,00h,00h
dd calplaymenu
db 03h,00h,00h,00h,026h,00h,00h,00h,00h,00h,00h,00h,051h,00h,00h,00h
db 012h,00h,00h,00h
dd str_Game5
db 00h,00h,00h,00h
dd unk_C854F
db 03h,00h,00h,00h,052h,00h,00h,00h,00h,00h,00h,00h,097h,00h,00h,00h
db 012h,00h,00h,00h
dd str_Statistics2
db 00h,00h,00h,00h
dd unk_C846A
db 05h,00h,00h,00h
str_ShowLeagueSettings2:
db 053h,068h,06Fh,077h,020h,04Ch,065h,061h,067h,075h,065h,020h,073h,065h,074h,074h
db 069h,06Eh,067h,073h,00h
lgsetshowmenu:
db 00h,00h,00h,00h,00h,00h,00h,00h,097h,00h,00h,00h,012h,00h,00h,00h
dd str_ShowLeagueSettings2
dd MenuShowLeagueSettings
db 00h,00h,00h,00h,00h,00h,00h,00h
str_LeagueSettings:
db 04Ch,065h,061h,067h,075h,065h,020h,073h,065h,074h,074h,069h,06Eh,067h,073h,00h
lgsetmenu:
db 00h,00h,00h,00h,00h,00h,00h,00h,070h,00h,00h,00h,012h,00h,00h,00h
dd str_LeagueSettings
dd MenuLeagueSettingsEdit
db 00h,00h,00h,00h,00h,00h,00h,00h
str_Done3:
db 044h,06Fh,06Eh,065h,00h
str_Cancel3:
db 043h,061h,06Eh,063h,065h,06Ch,00h
teamselmenu:
db 00h,00h,00h,00h,00h,00h,00h,00h,034h,00h,00h,00h,011h,00h,00h,00h
dd str_Done3
dd TeamSelDone
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
db 034h,00h,00h,00h,024h,00h,00h,00h
dd str_Cancel3
dd TeamSelCancel
db 00h,00h,00h,00h,00h,00h,00h,00h
str_Select:
db 053h,065h,06Ch,065h,063h,074h,00h
str_Settings2:
db 053h,065h,074h,074h,069h,06Eh,067h,073h,00h
teamselmenubar:
db 00h,00h,00h,00h,00h,00h,00h,00h,031h,00h,00h,00h,012h,00h,00h,00h
dd str_Select
db 00h,00h,00h,00h
dd teamselmenu
db 02h,00h,00h,00h,032h,00h,00h,00h,00h,00h,00h,00h,06Fh,00h,00h,00h
db 012h,00h,00h,00h
dd str_Settings2
db 00h,00h,00h,00h
teamselsetslot:
dd lgsetmenu
db 01h,00h,00h,00h
unk_C87B8:
db 00h,00h,00h,00h,00h,00h,00h,00h
