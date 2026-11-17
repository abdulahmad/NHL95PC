; Edit Rosters menu slots for free agents, lines, and moving a player to the other roster.
bits 32
%include "hockey.inc"
section s_D0151 progbits alloc noexec write align=1
extern ShowFreeAgents, EditTeamLines, CreateFreeAgent, FindPlayer, LineEdDone, MenuLineEdCancel, RosterPacificMenu, RosterCentralMenu
extern RosterNortheastMenu, RosterAtlanticMenu, EditRostersFileMenu, str_FreeAgents2, str_FindPlayer, str_Pacific, str_Central, str_Northeast
extern str_Atlantic, Roster1TeamMenu
global roster1divmenus, roster2divmenus, menu_r1_tofa, menu_r1_toroster2, menu_r2_tofa, menu_r2_toroster1, menu_r1_freeagents, menu_r2_freeagents
global menu_r1_editlines, menu_r2_editlines, Roster2TeamMenu, str_MoveToFreeAgent, str_MoveToRoster2, str_MoveToRoster1, str_CreateFreeAgent, str_EditTeamLines
global EditRoster1Menu, EditRoster2Menu, str_File3, str_Roster12, str_Roster22, str_EditRoster1, str_EditRoster2, editrostersmenubar
global str_Done5, str_Cancel8, DbLinesFileMenu, str_DressPlayer2, str_ScratchPlayer2, DbLinesPlayerMenu
roster1divmenus:                                ; Roster 1 menu: per division (Central, Northeast, Atlantic,
                                                ; Pacific) the submenu item table; team items' handlers (+14h)
                                                ; are SelectRosterTeam or 0; used by SelectRosterTeam,
                                                ; SetRosterTeamMenus, ShowFreeAgents
        dd RosterPacificMenu
        db 06h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h,066h,00h,00h,00h
        db 023h,00h,00h,00h
        dd str_Central
        db 00h,00h,00h,00h
        dd RosterCentralMenu
        db 06h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h,066h,00h,00h,00h
        db 035h,00h,00h,00h
        dd str_Northeast
        db 00h,00h,00h,00h
        dd RosterNortheastMenu
        db 07h,00h,00h,00h,00h,00h,00h,00h,036h,00h,00h,00h,066h,00h,00h,00h
        db 047h,00h,00h,00h
        dd str_Atlantic
        db 00h,00h,00h,00h
        dd RosterAtlanticMenu
        db 07h,00h,00h,00h,00h,00h,00h,00h,048h,00h,00h,00h,066h,00h,00h,00h
        db 059h,00h,00h,00h
        dd str_FreeAgents2
menu_r1_freeagents:                             ; handler slot of 'Free Agents ...' in the Roster 1 menu
                                                ; (ShowFreeAgents or 0); used by SelectRosterTeam,
                                                ; SetRosterTeamMenus, ShowFreeAgents
        dd ShowFreeAgents
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,05Ah,00h,00h,00h
        db 066h,00h,00h,00h,06Ch,00h,00h,00h
        dd str_FindPlayer
        dd FindPlayer
        db 00h,00h,00h,00h,00h,00h,00h,00h
Roster2TeamMenu:                                ; Edit rosters pull-down for roster 2: the four division team
                                                ; lists
        db 00h,00h,00h,00h,00h,00h,00h,00h,066h,00h,00h,00h,011h,00h,00h,00h
        dd str_Pacific
        db 00h,00h,00h,00h
roster2divmenus:                                ; Roster 2 menu division table, as roster1divmenus; used by
                                                ; SelectRosterTeam, SetRosterTeamMenus, ShowFreeAgents
        dd RosterPacificMenu
        db 06h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h,066h,00h,00h,00h
        db 023h,00h,00h,00h
        dd str_Central
        db 00h,00h,00h,00h
        dd RosterCentralMenu
        db 06h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h,066h,00h,00h,00h
        db 035h,00h,00h,00h
        dd str_Northeast
        db 00h,00h,00h,00h
        dd RosterNortheastMenu
        db 07h,00h,00h,00h,00h,00h,00h,00h,036h,00h,00h,00h,066h,00h,00h,00h
        db 047h,00h,00h,00h
        dd str_Atlantic
        db 00h,00h,00h,00h
        dd RosterAtlanticMenu
        db 07h,00h,00h,00h,00h,00h,00h,00h,048h,00h,00h,00h,066h,00h,00h,00h
        db 059h,00h,00h,00h
        dd str_FreeAgents2
menu_r2_freeagents:                             ; handler slot of 'Free Agents ...' in the Roster 2 menu; used
                                                ; by SelectRosterTeam, SetRosterTeamMenus, ShowFreeAgents
        dd ShowFreeAgents
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,05Ah,00h,00h,00h
        db 066h,00h,00h,00h,06Ch,00h,00h,00h
        dd str_FindPlayer
        dd FindPlayer
        db 00h,00h,00h,00h,00h,00h,00h,00h
str_MoveToFreeAgent:                            ; "Move to Free Agent List" string literal
        db 04Dh,06Fh,076h,065h,020h,074h,06Fh,020h,046h,072h,065h,065h,020h,041h,067h,065h
        db 06Eh,074h,020h,04Ch,069h,073h,074h,00h
str_MoveToRoster2:                              ; "Move to Roster 2" string literal
        db 04Dh,06Fh,076h,065h,020h,074h,06Fh,020h,052h,06Fh,073h,074h,065h,072h,020h,032h
        db 00h
str_MoveToRoster1:                              ; "Move to Roster 1" string literal
        db 04Dh,06Fh,076h,065h,020h,074h,06Fh,020h,052h,06Fh,073h,074h,065h,072h,020h,031h
        db 00h
str_CreateFreeAgent:                            ; "Create Free Agent ..." string literal
        db 043h,072h,065h,061h,074h,065h,020h,046h,072h,065h,065h,020h,041h,067h,065h,06Eh
        db 074h,020h,02Eh,02Eh,02Eh,00h
str_EditTeamLines:                              ; "Edit Team Lines ..." string literal
        db 045h,064h,069h,074h,020h,054h,065h,061h,06Dh,020h,04Ch,069h,06Eh,065h,073h,020h
        db 02Eh,02Eh,02Eh,00h
EditRoster1Menu:                                ; Edit rosters pull-down for roster 1: move to free agents or
                                                ; to roster 2
        db 00h,00h,00h,00h,00h,00h,00h,00h,0A9h,00h,00h,00h,011h,00h,00h,00h
        dd str_MoveToFreeAgent
menu_r1_tofa:                                   ; Edit Roster 1 'Move to Free Agent List' handler slot
                                                ; (MoveToFreeAgents or 0); used by FindPlayer,
                                                ; LoadRosterList_faloop, LoadRosterList_team ...
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 012h,00h,00h,00h,0A9h,00h,00h,00h,023h,00h,00h,00h
        dd str_MoveToRoster2
menu_r1_toroster2:                              ; Edit Roster 1 'Move to Roster 2' handler slot
                                                ; (MoveToOtherRoster or 0); used by FindPlayer,
                                                ; LoadRosterList_faloop, LoadRosterList_team ...
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 024h,00h,00h,00h,0A9h,00h,00h,00h,035h,00h,00h,00h
        dd str_CreateFreeAgent
        dd CreateFreeAgent
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,036h,00h,00h,00h
        db 0A9h,00h,00h,00h,048h,00h,00h,00h
        dd str_EditTeamLines
menu_r1_editlines:                              ; Edit Roster 1 'Edit Team Lines ...' handler slot
                                                ; (EditTeamLines or 0); used by SelectRosterTeam,
                                                ; SetRosterTeamMenus, ShowFreeAgents
        dd EditTeamLines
        db 00h,00h,00h,00h,00h,00h,00h,00h
EditRoster2Menu:                                ; Edit rosters pull-down for roster 2: move to free agents or
                                                ; to roster 1
        db 00h,00h,00h,00h,00h,00h,00h,00h,0A9h,00h,00h,00h,011h,00h,00h,00h
        dd str_MoveToFreeAgent
menu_r2_tofa:                                   ; Edit Roster 2 'Move to Free Agent List' handler slot; used
                                                ; by FindPlayer, LoadRosterList_faloop, LoadRosterList_team
                                                ; ...
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 012h,00h,00h,00h,0A9h,00h,00h,00h,023h,00h,00h,00h
        dd str_MoveToRoster1
menu_r2_toroster1:                              ; Edit Roster 2 'Move to Roster 1' handler slot; used by
                                                ; FindPlayer, LoadRosterList_faloop, LoadRosterList_team ...
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 024h,00h,00h,00h,0A9h,00h,00h,00h,035h,00h,00h,00h
        dd str_CreateFreeAgent
        dd CreateFreeAgent
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,036h,00h,00h,00h
        db 0A9h,00h,00h,00h,048h,00h,00h,00h
        dd str_EditTeamLines
menu_r2_editlines:                              ; Edit Roster 2 'Edit Team Lines ...' handler slot; used by
                                                ; SelectRosterTeam, SetRosterTeamMenus, ShowFreeAgents
        dd EditTeamLines
        db 00h,00h,00h,00h,00h,00h,00h,00h
str_File3:                                      ; "File" string literal
        db 046h,069h,06Ch,065h,00h
str_Roster12:                                   ; "Roster 1" string literal
        db 052h,06Fh,073h,074h,065h,072h,020h,031h,00h
str_Roster22:                                   ; "Roster 2" string literal
        db 052h,06Fh,073h,074h,065h,072h,020h,032h,00h
str_EditRoster1:                                ; "Edit Roster 1" string literal
        db 045h,064h,069h,074h,020h,052h,06Fh,073h,074h,065h,072h,020h,031h,00h
str_EditRoster2:                                ; "Edit Roster 2" string literal
        db 045h,064h,069h,074h,020h,052h,06Fh,073h,074h,065h,072h,020h,032h,00h
editrostersmenubar:                             ; menu bar of the Edit Rosters screen; used by
                                                ; DrawDBErrorsScreen, DrawEditRosters, RunEditRosters
        db 00h,00h,00h,00h,00h,00h,00h,00h,020h,00h,00h,00h,012h,00h,00h,00h
        dd str_File3
        db 00h,00h,00h,00h
        dd EditRostersFileMenu
        db 04h,00h,00h,00h,021h,00h,00h,00h,00h,00h,00h,00h,05Ch,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_Roster12
        db 00h,00h,00h,00h
        dd Roster1TeamMenu
        db 06h,00h,00h,00h,05Dh,00h,00h,00h,00h,00h,00h,00h,09Ah,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_Roster22
        db 00h,00h,00h,00h
        dd Roster2TeamMenu
        db 06h,00h,00h,00h,09Bh,00h,00h,00h,00h,00h,00h,00h,0F4h,00h,00h,00h
        db 012h,00h,00h,00h
        dd str_EditRoster1
        db 00h,00h,00h,00h
        dd EditRoster1Menu
        db 04h,00h,00h,00h,0F5h,00h,00h,00h,00h,00h,00h,00h,050h,01h,00h,00h
        db 012h,00h,00h,00h
        dd str_EditRoster2
        db 00h,00h,00h,00h
        dd EditRoster2Menu
        db 04h,00h,00h,00h
str_Done5:                                      ; "Done" string literal
        db 044h,06Fh,06Eh,065h,00h
str_Cancel8:                                    ; "Cancel" string literal
        db 043h,061h,06Eh,063h,065h,06Ch,00h
DbLinesFileMenu:                                ; Database line editor pull-down: done and cancel
        db 00h,00h,00h,00h,00h,00h,00h,00h,034h,00h,00h,00h,011h,00h,00h,00h
        dd str_Done5
        dd LineEdDone
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
        db 034h,00h,00h,00h,024h,00h,00h,00h
        dd str_Cancel8
        dd MenuLineEdCancel
        db 00h,00h,00h,00h,00h,00h,00h,00h
str_DressPlayer2:                               ; "Dress Player" string literal
        db 044h,072h,065h,073h,073h,020h,050h,06Ch,061h,079h,065h,072h,00h
str_ScratchPlayer2:                             ; "Scratch Player" string literal
        db 053h,063h,072h,061h,074h,063h,068h,020h,050h,06Ch,061h,079h,065h,072h,00h
DbLinesPlayerMenu:                              ; Database line editor pull-down: dress player
        db 00h,00h,00h,00h,00h,00h,00h,00h,068h,00h,00h,00h,011h,00h,00h,00h
        dd str_DressPlayer2
