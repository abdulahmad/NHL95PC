; Which roster rows are selected, whether the database needs saving, and the edit-rosters messages.
bits 32
%include "hockey.inc"
section s_EA994 nobits alloc noexec write align=1
global roster2slot, rostersel, rosterselgoalies, roster2selgoalies, rosterlistkeys, rosterteamrec, roster2teamrec
global dbdirty, rostergstat, rosterpstat, msglines, falisttop, editptrspr
global editrosters_exit, roster2list, rosterteamcopy
rosterlistkeys:                                 ; Player key table read by the roster move and create routines
                                                ; (indexed by two registers); used by MoveToFreeAgents,
                                                ; MoveToOtherRoster, SelectMatchingPlayers
        resb 752
roster2list:                                    ; Second roster list (4-byte records like rosterlist); used by
                                                ; SwapSelectedPlayers
        resb 2
roster2slot:                                    ; Slot byte of each second roster list record; used by
                                                ; SwapSelectedPlayers
        resb 754
rosterteamrec:                                  ; per panel pointer to the team's TEAMS.DB record (2E8h
                                                ; bytes); EditTeamLines copies it; used by CopyRoster1Rec,
                                                ; DrawEditRosters, EditTeamLines ...
        resb 4
roster2teamrec:                                 ; Team record pointer of the second roster; used by
                                                ; SwapSelectedPlayers
        resb 4
rostersel:                                      ; selection flags of the two team panels, 1Ch bytes each; used
                                                ; by DrawRosterList, FindPlayer, LoadRosterList_team ...
        resb 25
rosterselgoalies:                               ; Selection flags of the roster 1 goalies (rostersel entries
                                                ; 25 to 27); used by SwapSelectedPlayers
        resb 3
        resb 25
roster2selgoalies:                              ; Selection flags of the roster 2 goalies (rostersel entries
                                                ; 53 to 55); used by SwapSelectedPlayers
        resb 3
rosterteamcopy:                                 ; Copy of a roster team record (2E8h bytes) made by
                                                ; CopyRoster1Rec; used by CopyRoster1Rec
        resb 3248
dbdirty:                                        ; database edited since last save; used by CreateFreeAgent,
                                                ; EditRosters, LoadDbsFromDir ...
        resb 4
rostergstat:                                    ; gstat buffer (goalie stats); used by CmpRosterGoalies,
                                                ; MenuShowPlayerStats, ShowRosterStats
        resb 4
rosterpstat:                                    ; pstat buffer (skater stats) for ShowRosterStats; used by
                                                ; CmpRosterSkaters, MenuShowPlayerStats, ShowRosterStats
        resb 4
msglines:                                       ; line-pointer table the roster editor fills for MessageBox /
                                                ; the input dialog (InputDialog); used by AskLeftRight,
                                                ; CheckRosterComplete, CreateFreeAgent ...
        resb 4
        resb 4
        resb 40
falisttop:                                      ; roster editor: first shown entry of the free-agent list;
                                                ; used by DrawRosterList, EditRosters, LoadRosterList_faloop
                                                ; ...
        resb 504
editptrspr:                                     ; enlarged copy of the pointer sprite; used by
                                                ; CreatePlayerLoop, DbLineEditorLoop, EditRosters ...
        resb 4
editrosters_exit:                               ; EditRostersReturn sets -1; EditRosters leaves its loop on
                                                ; it; used by EditRosters, EditRostersReturn, RunEditRosters
        resb 2072
