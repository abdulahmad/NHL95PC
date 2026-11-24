; The puck, the sorted sprite list, and the pointer into the replay tape.
bits 32
%include "hockey.inc"
section s_DF7CA nobits alloc noexec write align=1
global awtmpbox, awtmcoach_d2, awtmcoach_d3, awtmcoachflags, awtmcoachmode, scpflags2
global SortCordsOvlFlag, puckasslist, puckpflags2, doorZpos2, doorpflags, doorpflags3, refasslist, refweight
global reflegstr, reflegspd, milestonesaid, milestonesaid_b1, milestonesaid_b3, textline1, textline2, textline3
global textline4, textline5, PlList, LinePlayersAway, fofdata2_b3, fofdata2_b7, regd1_b1, awtmcoachenergy
global awtmlines, awtmplattr, awtmglattr, awtmplstats, awtmglstats, awtmroster, awtmptrF2, awtmsort
global puckcross_m2, sctemp4, puckstruct
global sortobj15, SumCwdExciteLvl, photoptrsf, RinkSideShape, RinkSideShapeFlipped
global ovlartbank, ovlscript, fofdata2_m2, recbpr, replayplay, GameVarsClear
global regd3_m2, regd5_m2, regd0_m3, regd1_m3, SortCords
global sortobj11, regd4, awtmgoaliesc, puckcross
global puckcross2, puckcross6
global pucktemp1, pucknopuck
global doortemp1, refYpos2, refXvel, refYvel, refframe
global refposition, reftemp1, reftemp3, reftemp4, reftemp5, milestonesaid_b2, lcrequest
global lcreqchoice, fofdata2, fofdata2_w2, fofdata2_w4, fofdata2_w6, fofdata
global fofdata_w2, LastShooterTeam, regd2, regd3, regd5, regd0, regd1
awtmpbox:                                       ; awtmstruct+tmboxlist; used by clearteams
        resb 28
awtmcoach_d2:                                   ; awtmstruct+D2h; used by Goal, InitCoachModes, SetCoachMode
                                                ; ...
        resb 1
awtmcoach_d3:                                   ; awtmstruct+D3h; used by Goal, InitCoachModes, SetCoachMode
                                                ; ...
        resb 1
awtmcoachflags:                                 ; awtmstruct+D4h; used by InitCoachModes, SetCoachMode,
                                                ; UpdateCoachModes ...
        resb 1
awtmcoachmode:                                  ; awtmstruct+D5h; used by InitCoachModes, SetCoachMode,
                                                ; UpdateCoachModes
        resb 1
awtmcoachenergy:                                ; awtmstruct+D6h; used by InitCoachModes, SetCoachMode,
                                                ; UpdateCoachModes
        resb 4
awtmlines:                                      ; visitor line table pointer (awtmstruct+DAh); used by
                                                ; LoadGameState, PostGameToTeamDb, clearteams
        resb 4
awtmplattr:                                     ; awtmstruct+DEh: pointer to awplattr; used by LoadGameState,
                                                ; clearteams
        resb 4
awtmglattr:                                     ; awtmstruct+E2h: pointer to awglattr; used by LoadGameState,
                                                ; clearteams
        resb 4
awtmplstats:                                    ; awtmstruct+tmplstats (E6h): pointer to away skater stats,
                                                ; loaded by DumpStatsLog; used by DumpStatsLog, LoadGameState,
                                                ; clearteams
        resb 4
awtmglstats:                                    ; awtmstruct+tmglstats; used by LoadGameState, clearteams
        resb 4
awtmroster:                                     ; visitor roster pointer (awtmstruct+EEh); used by
                                                ; LoadGameState, clearteams
        resb 4
awtmptrF2:                                      ; visitor team struct +F2h data pointer (clearteams sets
                                                ; awteamrec); role not identified; used by LoadGameState,
                                                ; clearteams
        resb 4
awtmsort:                                       ; visitor tmsort pointer (awtmstruct+F6h); used by
                                                ; LoadGameState, clearteams
        resb 4
awtmgoaliesc:                                   ; awtmstruct+FAh: player index of the visitors' goalie on the
                                                ; ice; used by updateplayers
        resb 4
puckcross_m2:                                   ; puckcross-2: the -5r load dword [edx*2+puckcross_m2] / sar
                                                ; 10h reads puckcross[edx]; nosplit use, so not folded; used
                                                ; by CanBlockShot, ChkDelayedOffside
        resb 2
puckcross:                                      ; calcpuckcross result: where/when the puck crosses each goal
                                                ; line (2 records after the team structs); used by Goal,
                                                ; LoadGameState, SaveGameState ...
        resb 2
puckcross2:                                     ; used by StartHL2, pucknorm_body
        resb 1
        resb 3
puckcross6:                                     ; used by StartHL2, pucknorm_body
        resb 1
        resb 1
SortCords:                                      ; used by AllInPlace, BehindNetMateDir, CanBlockShot ...
        resb 2
        resb 2
        resb 2
        resb 20
        resb 18
sctemp4:                                        ; SortCords+temp4: assintroline walks the 12 players with
                                                ; stride 80h; used by assintroline
        resb 2
        resb 16
        resb 6
        resb 1
scpflags2:                                      ; SortCords+pflags2; MenuModeSettings clears bit 3 of each of
                                                ; the 12 players, stride 80h; used by ClearCtlBlink,
                                                ; MenuModeSettings, PenGoalStuff
        resb 30
SortCordsOvlFlag:                               ; Player byte at +63h of the SortCords objects (indexed by
                                                ; object times 128): set by the puck physics; the referee
                                                ; clears it and loads overlay 8; used by assrefgoalpa
        resb 669
        resb 640
sortobj11:                                      ; SortCords entry 11 (SortCords+580h), the last player;
                                                ; PreGameIntro walks down from it; used by PreGameIntro
        resb 128
        resb 2
        resb 4
        resb 6
        resb 2
        resb 242
puckstruct:                                     ; used by ControlsDlgInGame_setside, DrawRinkOverlays,
                                                ; EndPenaltyShot ...
        resb 2
        resb 2
        resb 2
        resb 2
        resb 2
        resb 2
        resb 2
        resb 2
        resb 2
        resb 8
        resb 4
puckasslist:                                    ; puckstruct+asslist; ControlsDlgInGame indexes it by the
                                                ; puck's assnum; used by ControlsDlgInGame_setside, doinput
        resb 8
pucktemp1:                                      ; puckstruct+temp1; the penalty path stores 1C20h and
                                                ; assfaceoffpl compares it with 10h, as 95 puck temp1; used by
                                                ; ControlsDlgInGame_setside, assfaceoffpl, chkprogress_go ...
        resb 2
        resb 22
pucknopuck:                                     ; puckstruct+nopuck; ScatterPass clears it, the same
                                                ; absolute-field pattern as puckpflags2; used by ScatterPass,
                                                ; passtoa0
        resb 4
        resb 3
puckpflags2:                                    ; used by skateto
        resb 15
        resb 44
sortobj15:                                      ; SortCords entry 15 (SortCords+780h), the sort object after
                                                ; the puck; used by DrawRinkObjects, DrawRinkOverlays,
                                                ; assboxenter ...
        resb 2
        resb 2
        resb 2
        resb 4
doorZpos2:                                      ; sortobj15+Zpos+2: recorded by updatereplay; used by
                                                ; updatereplay
        resb 6
        resb 2
        resb 20
doortemp1:                                      ; sortobj15+temp1; assboxenter waits until the penalty-box
                                                ; door is ready; used by assboxenter
        resb 18
        resb 12
doorpflags:                                     ; sortobj15+pflags; assboxenter sets bit 5 as the door closes;
                                                ; used by assboxenter
        resb 2
doorpflags3:                                    ; Door object pflags3 byte; cleared by assboxenter when the
                                                ; door closes; used by assboxenter
        resb 14
        resb 44
        resb 2
        resb 4
refYpos2:                                       ; SortCords entry 16, the referee: Ypos+2, the integer y
                                                ; (absolute field, as puckpflags2 / doortemp1); used by
                                                ; PreGameIntro, StartHL2, StartThreeStars ...
        resb 6
refXvel:                                        ; SortCords entry 16, the referee: Xvel (absolute field, as
                                                ; puckpflags2 / doortemp1); used by Endfaceoff, PreGameIntro,
                                                ; StartHL2 ...
        resb 2
refYvel:                                        ; SortCords entry 16, the referee: Yvel (absolute field, as
                                                ; puckpflags2 / doortemp1); used by PreGameIntro, StartHL2,
                                                ; StartThreeStars
        resb 4
refframe:                                       ; SortCords entry 16, the referee: frame (absolute field, as
                                                ; puckpflags2 / doortemp1); used by PreGameIntro,
                                                ; StartThreeStars
        resb 8
refposition:                                    ; SortCords entry 16, the referee: position (absolute field,
                                                ; as puckpflags2 / doortemp1); used by ClearSortCords,
                                                ; updateplayers
        resb 4
refasslist:                                     ; SortCords entry 16, the referee: asslist, indexed by his
                                                ; assnum (absolute field, as puckpflags2 / doortemp1); used by
                                                ; updateplayers
        resb 8
reftemp1:                                       ; SortCords entry 16, the referee: temp1 (absolute field, as
                                                ; puckpflags2 / doortemp1); used by PreGameIntro,
                                                ; StartThreeStars
        resb 4
reftemp3:                                       ; SortCords entry 16, the referee: temp3 (absolute field, as
                                                ; puckpflags2 / doortemp1); used by PreGameIntro,
                                                ; StartThreeStars, checkwindow
        resb 2
reftemp4:                                       ; SortCords entry 16, the referee: temp4 (absolute field, as
                                                ; puckpflags2 / doortemp1); used by PreGameIntro,
                                                ; StartThreeStars
        resb 2
reftemp5:                                       ; SortCords entry 16, the referee: temp5 (absolute field, as
                                                ; puckpflags2 / doortemp1); used by PreGameIntro
        resb 8
        resb 32
refweight:                                      ; SortCords entry 16, the referee: weight (absolute field, as
                                                ; puckpflags2 / doortemp1); used by ClearSortCords
        resb 1
reflegstr:                                      ; SortCords entry 16, the referee: legstr (absolute field, as
                                                ; puckpflags2 / doortemp1); used by ClearSortCords
        resb 1
reflegspd:                                      ; SortCords entry 16, the referee: legspd (absolute field, as
                                                ; puckpflags2 / doortemp1); used by ClearSortCords
        resb 40
SumCwdExciteLvl:                                ; used by LoadGameState, ResetGameVars, SaveGameState ...
        resb 4
photoptrsf:                                     ; 69h picture pointers into photobankf (LoadPhotoBankF); used
                                                ; by DrawRinkObjects, DrawRinkSideObjects, LoadPhotoBankF
        resb 384
RinkSideShape:                                  ; Photo bank shape (entry 96 of photoptrsf) drawn at the side
                                                ; object slots; used by DrawRinkObjects, DrawRinkSideObjects
        resb 16
RinkSideShapeFlipped:                           ; Photo bank shape (entry 100 of photoptrsf) drawn flipped at
                                                ; the side object slots; used by DrawRinkObjects,
                                                ; DrawRinkSideObjects
        resb 20
ovlartbank:                                     ; the loaded art bank of the running overlay sequence
                                                ; (LoadTeamPPV loads it, Gameloop/PlayGame free it); used by
                                                ; EnsureFreeMemory, FreeGameMemory, Gameloop ...
        resb 4
ovlscript:                                      ; pointer to the loaded overlay script bytes (cleared when the
                                                ; sequence ends); used by LoadGameState, LoadTeamPPV,
                                                ; UpdateTextOverlay
        resb 4
milestonesaid:                                  ; ChkScorerMilestone: flag bytes so a milestone is announced
                                                ; once; ResetGameVars clears the four; used by
                                                ; ChkScorerMilestone, LoadGameState, ResetGameVars ...
        resb 1
milestonesaid_b1:                               ; milestonesaid+1; used by ChkScorerMilestone, ResetGameVars
        resb 1
milestonesaid_b2:                               ; milestonesaid+2; used by LoadGameState, ResetGameVars,
                                                ; SaveGameState
        resb 1
milestonesaid_b3:                               ; milestonesaid+3; used by ResetGameVars
        resb 1
textline1:                                      ; 60-byte text line buffer (sprintf target in BuildEventLines,
                                                ; drawn by DrawTextOverlay when non-empty); used by
                                                ; BuildEventLines, DrawTextOverlay, PreGameIntro ...
        resb 60
textline2:                                      ; 60-byte text line buffer (FormatPlayerName target in
                                                ; BuildEventLines); used by BuildEventLines, DrawTextOverlay,
                                                ; PreGameIntro ...
        resb 60
textline3:                                      ; 60-byte text line buffer ('EA Sports' copied in by player
                                                ; logic); used by BuildEventLines, DrawTextOverlay,
                                                ; PreGameIntro ...
        resb 60
lcrequest:                                      ; per team: line change requested by number (PC keys); doinput
                                                ; hands it to lcselect, then clears it; used by Gameloop,
                                                ; HandleHotKey, LoadGameState ...
        resb 2
        resb 2
textline4:                                      ; 60-byte text line buffer, cleared with the others; used by
                                                ; BuildEventLines, DrawTextOverlay, PreGameIntro ...
        resb 60
textline5:                                      ; 60-byte text line buffer, checked by DrawTextOverlay; used
                                                ; by BuildEventLines, DrawTextOverlay, InProgress ...
        resb 58
        resb 2
lcreqchoice:                                    ; per team: the requested line choice passed to lcselect; used
                                                ; by HandleHotKey, LoadGameState, ResetGameVars ...
        resb 2
        resb 2
PlList:                                         ; player list built by SetPlList / TryAddPlayerToList; used by
                                                ; LoadGameState, SaveGameState, SetPlList ...
        resb 6
LinePlayersAway:                                ; used by SetPlList, setpersonel
        resb 4
fofdata2_m2:                                    ; fofdata2-2: -5r short-load base
        resb 2
fofdata2:                                       ; assfaceoffpl writes the stick stance here and at +4 for the
                                                ; other side, the 95 fofdata2 frame/flags pairs; used by
                                                ; Endfaceoff, LoadGameState, SaveGameState ...
        resb 2
fofdata2_w2:                                    ; used by Endfaceoff, puckfaceoff2
        resb 1
fofdata2_b3:                                    ; used by puckfaceoff2
        resb 1
fofdata2_w4:                                    ; used by Endfaceoff, puckfaceoff2
        resb 2
fofdata2_w6:                                    ; used by Endfaceoff, puckfaceoff2
        resb 1
fofdata2_b7:                                    ; used by puckfaceoff2
        resb 1
fofdata:                                        ; used by puckfaceoff2
        resb 2
fofdata_w2:                                     ; used by puckfaceoff2
        resb 2
recbpr:                                         ; used by LoadGameState, PlayHilight, ReplayFirstFrame ...
        resb 4
LastShooterTeam:                                ; used by checkcx, cleargamevars, updateplayers
        resb 4
replayplay:                                     ; used by InstantReplay, ReplayStep
        resb 4
GameVarsClear:                                  ; Dword cleared first by cleargamevars; nothing else uses it;
                                                ; used by cleargamevars
        resb 2
        resb 2
regd2:                                          ; Watcom static for the ported 68k d2 (EvadePlayers/EvadePC x
                                                ; distance, playeracc accel factor and max speed); used by
                                                ; Endfaceoff, EvadePC, EvadePlayers ...
        resb 2
regd3_m2:                                       ; regd3-2: -5r short-load base (also the high word of regd2);
                                                ; used by assgoalie, wallcoll
        resb 2
regd3:                                          ; Watcom static for the ported 68k d3 (doplayeracc and
                                                ; playeracc speed squared); used by ClampYPosition,
                                                ; Endfaceoff, Readjoy_tail ...
        resb 2
        resb 2
regd4:                                          ; used by Endfaceoff, PlacePlayersAtStart, assgoalie ...
        resb 2
regd5_m2:                                       ; regd5-2: -5r short-load base
        resb 2
regd5:                                          ; used by checkcx, checkgoal, checkwallcoll ...
        resb 1
regd0_m3:                                       ; regd0-3: -5r byte-load base; used by ReplayStep, puckgoalie
        resb 1
        resb 2
regd0:                                          ; used by AvgCline, BehindNetMateDir, ChkOffsides ...
        resb 1
regd1_m3:                                       ; regd1-3: -5r byte-load base; as a byte it is regd0+1, the
                                                ; high byte of the regd0 word (test 8); used by ReplayStep,
                                                ; puckgoalie
        resb 1
        resb 2
regd1:                                          ; Watcom static for the ported 68k d1 (target y, new Yvel);
                                                ; used by BehindNetMateDir, ClampYPosition, CompShoot ...
        resb 1
regd1_b1:                                       ; regd1+1: the high byte of the regd1 word; used by
                                                ; ReplayStep, checkcx
        resb 3
