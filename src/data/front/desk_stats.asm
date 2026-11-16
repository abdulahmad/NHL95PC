; Scoreboard sprites, the statistics sort orders, and the away roster.
bits 32
%include "hockey.inc"
section s_DB7EC nobits alloc noexec write align=1
global awroster, awrosterjersey, hmgoalieidx, hmscratch, UnusedStateFlag, UnusedStateMode, UnusedStateSpare
global GameRecordDay, UnusedStateByte, hmteamrec_skaters, hmteamrec_goalies, s1font, schedgameidx, pointerspr
global linesprites, hudhundstep, penaltydigits, PenaltyBlankDigit, hmpanelspr, awpanelspr, scoredigits, scrbrdshapes
global clockdigits, clockcolon, cupseries, titlesample, statsteamorder, statsmenuresult, sfpal2, sfpal1
global StatsLastSel, statsnumgoalies, statsskaterorder, statsgoalieorder, RosterFromStandings, leaguestatsmode, statsgoalieplr, statsnumskaters
global statsskaterplr, playofftree, hmteamrec, TeamRecLines, awteamrec
global hmlinetab, hmglstats, awglstats, hmlineind, awlineind, statsscreenpal, hmglstats_w2
global hmglstats_w4, hmglstats_w8, hmglstats_w14
awroster:
        resb 5
awrosterjersey:
        resb 1087
hmteamrec:
        resb 5
        resb 71
hmteamrec_skaters:
        resb 100
hmteamrec_goalies:
        resb 12
        resb 48
TeamRecLines:
        resb 508
awteamrec:
        resb 5
        resb 183
        resb 556
hmlinetab:
        resb 36
hmgoalieidx:
        resb 1
        resb 3
hmscratch:
        resb 8
s1font:
        resb 4
schedgameidx:
        resb 4
pointerspr:
        resb 6
        resb 2
hmglstats:
        resb 2
hmglstats_w2:
        resb 2
hmglstats_w4:
        resb 4
hmglstats_w8:
        resb 6
hmglstats_w14:
        resb 4
awglstats:
        resb 18
UnusedStateFlag:
        resb 1
UnusedStateMode:
        resb 1
UnusedStateSpare:
        resb 1
GameRecordDay:
        resb 1
UnusedStateByte:
        resb 4
linesprites:
        resb 32
hudhundstep:
        resb 4
penaltydigits:
        resb 40
PenaltyBlankDigit:
        resb 4
hmpanelspr:
        resb 4
awpanelspr:
        resb 4
scoredigits:
        resb 44
scrbrdshapes:
        resb 4
hmlineind:
        resb 12
awlineind:
        resb 12
clockdigits:
        resb 40
clockcolon:
        resb 4
cupseries:
        resb 4
titlesample:
        resb 4
statsscreenpal:
        resb 768
statsteamorder:
        resb 104
statsmenuresult:
        resb 4
sfpal2:
        resb 4
sfpal1:
        resb 4
StatsLastSel:
        resb 4
statsnumgoalies:
        resb 4
statsskaterorder:
        resb 100
statsgoalieorder:
        resb 20
RosterFromStandings:
        resb 4
leaguestatsmode:
        resb 4
statsgoalieplr:
        resb 20
statsnumskaters:
        resb 4
statsskaterplr:
        resb 100
playofftree:
        resb 4
