; BSS of front/team_db (src/front/team_db).
bits 32
%include "hockey.inc"
section s_DABF0 nobits alloc noexec write align=1
global awlinetab, awgoalieidx, awscratch, gsummarypath, hmglattr, awglattr, hmplattr, hmplattr_b13
global awplattr, awplattr_b13, hmplstats_m2, hmplstats, hmplstats_w2, hmplstats_w4, hmplstats_w6, hmplstats_w8
global hmplstats_w10, hmplstats_w12, hmplstats_w14, awplstats, hmroster, hmrosterjersey, hmrosterpos, awroster
global awrosterjersey, hmteamrec, hmteamrec_skaters, hmteamrec_goalies, TeamRecLines, awteamrec, hmlinetab, hmgoalieidx
global hmscratch, s1font
awlinetab:                                      ; visitor line table (tmlines of awtmstruct), as hmlinetab;
                                                ; used by BuildDefaultLines, CanFillLineSlot, DeskVisitorLines
                                                ; ...
        resb 36
awgoalieidx:                                    ; roster slots of the two visiting goalies; used by
                                                ; SetupGoalieMenu
        resb 1
        resb 3
awscratch:                                      ; 8 scratched visiting roster slots (64h = none); used by
                                                ; LoadGameTeams
        resb 8
gsummarypath:                                   ; path of the league gsummary.db (MakeGSummaryPath,
                                                ; InitGameSummary); used by AppendGSumRecord, InitGameSummary,
                                                ; MakeGSummaryPath ...
        resb 32
hmglattr:                                       ; home goalie attribute records, 3 x 10h bytes, filled by
                                                ; LoadTeamRoster; clearteams points hmtmglattr here; used by
                                                ; LoadGameState, LoadTeamRoster, clearteams
        resb 48
awglattr:                                       ; visitor goalie attribute records (hmglattr+30h); used by
                                                ; LoadGameState, clearteams
        resb 48
hmplattr:                                       ; home skater attribute records, 25 x 14h bytes, filled by
                                                ; LoadTeamRoster; clearteams points hmtmplattr here; used by
                                                ; BuildDefaultLines, LoadGameState, LoadTeamRoster ...
        resb 19
hmplattr_b13:                                   ; hmplattr+13h: byte 13h of a skater attribute record,
                                                ; Endfaceoff indexes it [pnum*14h]; used by Endfaceoff
        resb 481
awplattr:                                       ; visitor skater attribute records (hmplattr + 25*14h); used
                                                ; by LoadGameState, clearteams
        resb 19
awplattr_b13:                                   ; awplattr+13h; used by Endfaceoff
        resb 479
hmplstats_m2:                                   ; hmplstats-2: -5r short-load base
        resb 2
hmplstats:                                      ; home skater game stats, 25 x 10h bytes (words g, a, pen,
                                                ; +/-, ppg, shg, eng, sht); clearteams points hmtmplstats
                                                ; here; used by BuildEventLines, ChkScorerMilestone,
                                                ; InitGameSummary ...
        resb 2
hmplstats_w2:                                   ; hmplstats+2: stats word 1 of a skater record (g, a, pen,
                                                ; +/-, ppg, shg, eng, sht); used by ChkScorerMilestone,
                                                ; InitGameSummary, PickThreeStars ...
        resb 2
hmplstats_w4:                                   ; hmplstats+4: stats word 2 of a skater record (g, a, pen,
                                                ; +/-, ppg, shg, eng, sht); used by InitGameSummary,
                                                ; PostGameToTeamDb
        resb 2
hmplstats_w6:                                   ; hmplstats+6: stats word 3 of a skater record (g, a, pen,
                                                ; +/-, ppg, shg, eng, sht); used by InitGameSummary,
                                                ; PostGameToTeamDb
        resb 2
hmplstats_w8:                                   ; hmplstats+8: stats word 4 of a skater record (g, a, pen,
                                                ; +/-, ppg, shg, eng, sht); used by InitGameSummary,
                                                ; PostGameToTeamDb
        resb 2
hmplstats_w10:                                  ; hmplstats+10: stats word 5 of a skater record (g, a, pen,
                                                ; +/-, ppg, shg, eng, sht); used by InitGameSummary,
                                                ; PostGameToTeamDb
        resb 2
hmplstats_w12:                                  ; hmplstats+12: stats word 6 of a skater record (g, a, pen,
                                                ; +/-, ppg, shg, eng, sht); used by InitGameSummary
        resb 2
hmplstats_w14:                                  ; hmplstats+14: stats word 7 of a skater record (g, a, pen,
                                                ; +/-, ppg, shg, eng, sht); used by InitGameSummary,
                                                ; PostGameToTeamDb
        resb 386
awplstats:                                      ; visitor skater game stats (hmplstats+190h); clearteams
                                                ; points awtmplstats here; used by LoadGameState, clearteams
        resb 400
hmroster:                                       ; home roster records, 27h bytes per player (byte 0 = status:
                                                ; 3 bench, 4 on ice, 7 penalty over); clearteams stores it in
                                                ; hmtmstruct+tmroster; used by BuildDefaultLines,
                                                ; BuildEventLines, CanFillLineSlot ...
        resb 5
hmrosterjersey:                                 ; hmroster entry (27h bytes) +5 jersey; used by
                                                ; BuildEventLines, GameLineEditorLoop, LoadTeamRoster ...
        resb 1
hmrosterpos:                                    ; hmroster entry (27h bytes) +6: the position letter (D, C, L,
                                                ; R, G), as hmrosterjersey is +5; used by CanFillLineSlot,
                                                ; FillDressedSlots, LoadTeamRoster ...
        resb 1086
awroster:                                       ; visitor roster records (awtmstruct+tmroster), as hmroster;
                                                ; used by LoadGameState, LoadGameTeams, SetupGoalieMenu ...
        resb 5
awrosterjersey:                                 ; Jersey number byte of each away roster record (39-byte
                                                ; records; pairs with hmrosterjersey); used by PlayHilight,
                                                ; SaveHilight
        resb 1087
hmteamrec:                                      ; TEAMS.DB record (2E8h bytes) of the home team for this game
                                                ; (LoadGameTeams); used by BuildEventLines,
                                                ; DrawLineEditorScreen, EditTeamLines ...
        resb 5
        resb 71
hmteamrec_skaters:                              ; hmteamrec+4Ch: the 25 skater ids of the team record
                                                ; (LoadGameRoster, LoadTeamRoster); used by
                                                ; GameSummaryScreen_period, LoadGameRoster, LoadTeamRoster ...
        resb 100
hmteamrec_goalies:                              ; hmteamrec+0B0h: the 3 goalie ids of the team record; used by
                                                ; LoadGameRoster, LoadTeamRoster
        resb 12
        resb 48
TeamRecLines:                                   ; Line set at +0ECh of each team record copy (stride 2E8h per
                                                ; side); the save lines menus write it; used by
                                                ; MenuSaveDefaultLines, MenuSaveTheseLines_x
        resb 508
awteamrec:                                      ; TEAMS.DB record (2E8h bytes) of the visiting team
                                                ; (LoadGameTeams); used by HilightSaveToDlg, LoadGameState,
                                                ; LoadGameTeams ...
        resb 5
        resb 183
        resb 556
hmlinetab:                                      ; home line table (30h bytes; tmlines of hmtmstruct, set by
                                                ; clearteams); SetupTeamLines / RemoveFromLines fill it,
                                                ; StartHL2 saves and restores it; used by BuildDefaultLines,
                                                ; CanFillLineSlot, DeskHomeLines ...
        resb 36
hmgoalieidx:                                    ; roster slots of the two home goalies (SetupGoalieMenu); used
                                                ; by SetupGoalieMenu
        resb 1
        resb 3
hmscratch:                                      ; 8 scratched home roster slots (64h = none) (LoadGameTeams);
                                                ; used by LoadGameTeams
        resb 8
s1font:                                         ; handle from OpenArtArchiveErr for s1.vfn loaded in main
                                                ; startup; used by DeskGoToReplay, DrawSettingsHeading,
                                                ; FormatPlayerName ...
        resb 4
