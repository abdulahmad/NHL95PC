; The open database buffers, and the roster and free-agent lists.
bits 32
%include "hockey.inc"
section s_D075E progbits alloc noexec write align=1
extern RosterStatsSeasonMenu, RosterStatsReturnMenu, str_PlayerStatistics6, str_Display
global str_TMP, rosterteam, rosterisfa, falist, falistsel, facount
global seasondb, careerdb, carteamsdb, keydb, teamsdb, attdb, seasondb_size, careerdb_size
global carteamsdb_size, keydb_size, teamsdb_size, attdb_size, rosterstatsmenubar, str_C4
rosterstatsmenubar:                             ; menu bar of ShowRosterStats / MenuShowPlayerStats; used by
                                                ; MenuShowPlayerStats, ShowRosterStats
        db 00h,00h,00h,00h,00h,00h,00h,00h,075h,00h,00h,00h,012h,00h,00h,00h
        dd str_PlayerStatistics6
        db 00h,00h,00h,00h
        dd RosterStatsReturnMenu
        db 01h,00h,00h,00h,076h,00h,00h,00h,00h,00h,00h,00h,0BEh,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_Display
        db 00h,00h,00h,00h
        dd RosterStatsSeasonMenu
        db 02h,00h,00h,00h
rosterteam:                                     ; team shown in Edit Rosters panel 0/1 (FFh = free-agent
                                                ; list); SelectRosterTeam / ShowFreeAgents set it; used by
                                                ; DbLineEditorLoop, DrawLineJerseys, EditTeamLines ...
        db 0Ch
        db 015h,07Dh,00h,00h,00h,0B7h,01h,00h,00h
rosterisfa:                                     ; per panel: 1 when it shows the free-agent list; used by
                                                ; DrawRosterList, DrawRosterTitle, EditRosters ...
        db 00h
        db 00h
falist:                                         ; free-agent list (1Bh bytes per player) built by
                                                ; LoadRosterList; used by BuildFreeAgentList, DrawRosterList,
                                                ; EditTeamLines ...
        db 00h,00h,00h,00h
falistsel:                                      ; free-agent selection flags (one byte per entry); used by
                                                ; CountSelected, DrawRosterList, EditTeamLines ...
        db 00h,00h,00h,00h
facount:                                        ; number of free agents (KEY.DB entries with team FFh); used
                                                ; by BuildFreeAgentList, CountSelected, CreateFreeAgent ...
        db 00h,00h,00h,00h
str_TMP:                                        ; string '.TMP'; used by CreateFreeAgent, DeleteTempDatabases,
                                                ; LoadTempDatabases
        db 02Eh,054h,04Dh,050h,00h
seasondb:                                       ; buffer of the loaded <league>\SEASON.DB
                                                ; (UpdateSeasonSchedule loads it from leaguedbnames+14h, saves
                                                ; it back with WriteFile, frees it); size in seasondb_size;
                                                ; used by AdvancePlayoffs, BuildPlayoffs, FinishPlayoffs_r4
                                                ; ...
        db 00h,00h,00h,00h
careerdb:                                       ; buffer of the loaded CAREER.DB (leaguedbnames+4) in
                                                ; UpdateSeasonSchedule; used by CareerDbPtr_common,
                                                ; FreeLeagueDbsMem, LoadDbsFromDir ...
        db 00h,00h,00h,00h
carteamsdb:                                     ; buffer of CARTEAMS.DB (LoadTempDatabases loads
                                                ; leaguedbnames+0Ch into it); CarTeamRecPtr indexes it by team
                                                ; * 4Ch; used by CarTeamRecPtr, FreeLeagueDbsMem,
                                                ; LoadDbsFromDir ...
        db 00h,00h,00h,00h
keydb:                                          ; buffer of the loaded KEY.DB (leaguedbnames+0) in
                                                ; UpdateSeasonSchedule; used by BuildFreeAgentList,
                                                ; FindPlayer, FreeLeagueDbsMem ...
        db 00h,00h,00h,00h
teamsdb:                                        ; buffer of TEAMS.DB (leaguedbnames+10h); TeamRecPtr indexes
                                                ; it by team * 2E8h; used by FreeLeagueDbsMem, LoadDbsFromDir,
                                                ; LoadLeagueDbsMem ...
        db 00h,00h,00h,00h
attdb:                                          ; buffer of ATT.DB (leaguedbnames+8) in LoadTempDatabases;
                                                ; used by AttDbPtr, FreeLeagueDbsMem, LoadDbsFromDir ...
        db 00h,00h,00h,00h
seasondb_size:                                  ; size of SEASON.DB from GetFileSize, passed with seasondb to
                                                ; the save call; used by AdvancePlayoffs, BuildPlayoffs,
                                                ; CreateFreeAgent ...
        db 00h,00h,00h,00h
careerdb_size:                                  ; size of CAREER.DB; used by CreateFreeAgent,
                                                ; FreeLeagueDbsMem, LoadDbsFromDir ...
        db 00h,00h,00h,00h
carteamsdb_size:                                ; size of CARTEAMS.DB (GetFileSize after the load); used by
                                                ; CreateFreeAgent, FreeLeagueDbsMem, LoadDbsFromDir ...
        db 00h,00h,00h,00h
keydb_size:                                     ; size of KEY.DB; used by BuildFreeAgentList, CreateFreeAgent,
                                                ; FindPlayer ...
        db 00h,00h,00h,00h
teamsdb_size:                                   ; size of TEAMS.DB; used by CreateFreeAgent, FreeLeagueDbsMem,
                                                ; LoadDbsFromDir ...
        db 00h,00h,00h,00h
attdb_size:                                     ; size of ATT.DB; used by CreateFreeAgent, FreeLeagueDbsMem,
                                                ; LoadDbsFromDir ...
        db 00h,00h,00h,00h
str_C4:                                         ; string '%c'; used by DrawRosterList
        db 025h,063h,00h,04Eh,061h,06Dh,065h,03Ah,020h,025h,073h,020h,025h,073h,00h,025h
        db 073h,020h,025h,073h,00h,025h,073h,020h,041h,06Ch,06Ch,020h,053h,074h,061h,072h
        db 020h,054h,065h,061h,06Dh,00h,043h,061h,072h,065h,065h,072h,03Ah,00h
