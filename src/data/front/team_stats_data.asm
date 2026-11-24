; Initialised data of front/team_stats (src/front/team_stats).
bits 32
%include "hockey.inc"
section s_C6AE0 progbits alloc noexec write align=1
extern CmpTeamDefense, CmpTeamPenalties, CmpTeamPK, CmpTeamPP, CmpTeamScoring, CmpTeamStandings, str_ADV, str_AVG
extern str_BlankTeamColumn, str_EasternConference3, str_GA4, str_GF2, str_PCT5, str_PIM5, str_PPG3, str_PPGA
extern str_PTS, str_SpL4, str_SpT, str_spW, str_TeamDefense, str_TeamPenalties, str_TeamPenaltyKilling, str_TeamPowerPlay
extern str_TeamScoring, str_TeamStandings, str_TSH, str_WesternConference3, str_WINS
global teamsortfns, westconfteams, eastconfteams, westconfname, eastconfname, teamstattitles, teamcolhdrs
teamsortfns:                                    ; team stats comparators by statscategory; used by
                                                ; TeamStatsScreen_keyPen
        dd CmpTeamScoring
        dd CmpTeamDefense
        dd CmpTeamPK
        dd CmpTeamPP
        dd CmpTeamPenalties
        dd CmpTeamStandings
westconfteams:                                  ; 12 team indices + 63h pad (Western, 12 teams in 94-95); used
                                                ; by TeamStatsScreen_keyPen
        db 04h,00h,00h,00h,02h,00h,00h,00h,014h,00h,00h,00h,08h,00h,00h,00h
        db 011h,00h,00h,00h,03h,00h,00h,00h,015h,00h,00h,00h,012h,00h,00h,00h
        db 018h,00h,00h,00h,07h,00h,00h,00h,05h,00h,00h,00h,017h,00h,00h,00h
        db 063h,00h,00h,00h,063h,00h,00h,00h
eastconfteams:                                  ; 14 team indices (Eastern); used by TeamStatsScreen_keyPen
        db 0Ch,00h,00h,00h,0Fh,00h,00h,00h,0Ah,00h,00h,00h,00h,00h,00h,00h
        db 09h,00h,00h,00h,01h,00h,00h,00h,016h,00h,00h,00h,0Bh,00h,00h,00h
        db 019h,00h,00h,00h,0Eh,00h,00h,00h,010h,00h,00h,00h,013h,00h,00h,00h
        db 06h,00h,00h,00h,0Dh,00h,00h,00h
westconfname:                                   ; -> "Western Conference"; used by TeamStatsScreen_keyPen
        dd str_WesternConference3
eastconfname:                                   ; -> "Eastern Conference"; used by TeamStatsScreen_keyPen
        dd str_EasternConference3
teamstattitles:                                 ; " Team Scoring" .. " Team Standings"; used by
                                                ; TeamStatsScreen_keyPen
        dd str_TeamScoring
        dd str_TeamDefense
        dd str_TeamPenaltyKilling
        dd str_TeamPowerPlay
        dd str_TeamPenalties
        dd str_TeamStandings
teamcolhdrs:                                    ; team stats column header pointers; used by
                                                ; TeamStatsScreen_keyPen
        dd str_spW
        dd str_SpL4
        dd str_SpT
        dd str_GF2
        dd str_spW
        dd str_SpL4
        dd str_SpT
        dd str_GA4
        dd str_TSH
        dd str_PPGA
        dd str_PCT5
        dd str_BlankTeamColumn
        dd str_ADV
        dd str_PPG3
        dd str_PCT5
        dd str_BlankTeamColumn
        dd str_PIM5
        dd str_AVG
        dd str_BlankTeamColumn
        dd str_BlankTeamColumn
        dd str_PTS
        dd str_WINS
        dd str_BlankTeamColumn
        dd str_BlankTeamColumn
