; The penalty buffer, how excited the crowd is, and the period clock.
bits 32
%include "hockey.inc"
section s_E9A11 nobits alloc noexec write align=1
global Ylist_m2, PBnum, PenBuf_pl_m2, PenBuf, PenBuf_pl
global iflags, icingPlayer, curevent, curevent_b1, curevent_b2, curevent_b3, curevent_b4, curevent_b5
global curevent_b6, curevent_b7, curevent_b8, curevent_b9, curevent_b10, goalevent, goalevent_b1, goalevent_b2
global goalevent_b3, goalevent_b4, OOlist, defsort_d, dressflags, dressflags_aw, offsort_fwd
global rpl_flip, rpl_jersey, rpl_pos, rpl_pos_b1, rpl_c1player, rpl_c2player, rpl_puckc, rpl_pbnum
global rpl_pbnum_b1, rpl_objstep, rpl_objstep_b1, PenBuf_m5, PenBuf_m2, SpeechPatchNext, UnusedEventWord
global gwgteam, gwgplayer, startm_m2, seqtimer
global rinkobjused_m2, defertab, defertab_a1, defertab_a2, defertab_a3, defertab_a4, defertab_a5, defertab_a6
global defertab_fn, lineslotmark, linesortidx, dressedskaters, rpl_x_e14_m2, rpl_x_e14, rpl_x_e16
global rpl_y_e14_m2, rpl_y_e14, rpl_y_e16, rpl_frame_e14_m2, rpl_frame_e14, rpl_flip_m3, rpl_jersey_m3, rpl_pos_m3
global rpl_puckz_m2, rpl_c1player_m3, rpl_puckc_m3, rpl_objstep_m3, rpl_ysort, ltx, gsumqueue, offsort_c
global defsort_r, offsort_d, defsort_c, offsort_l, defsort_l, offsort_r, defsort_fwd, Ylist
global OOlistpos, UnusedSpeechWord, joysampling_save, UnusedCrowdWord, MaxCwdExciteLvl, NumCwdExciteLvl, CwdExciteLvl, UnusedCrowdWordHi
global periodendtime, penevteam, GoalState, ovlsteptimer, ovlstepidx, PerTimeTotal, lj2, lj1
global lasttouch, lty, startm, starpl, lastimpact, rinkobjused, dressedfwds, dresseddefs
global rpl_x, rpl_x_e15, rpl_y, rpl_y_e15, rpl_frame, rpl_frame_e15, rpl_puckz, rpl_puckunused
global rpl_camx, rpl_camy, rpl_objframe
PenBuf_m5:                                      ; used by chkprogress_go
        resb 2
        resb 1
PenBuf_m2:                                      ; PenBuf-2: -5r short-load base; used by InProgress
        resb 1
PenBuf_pl_m2:                                   ; PenBuf_pl-2: the player byte of the entry before
                                                ; (PostPenaltyEvent); used by PostPenaltyEvent
        resb 1
PenBuf:                                         ; used by AddPenalty2, ClearPenaltyBuffer, DebugMonitor ...
        resb 1
PenBuf_pl:                                      ; used by AddPenalty2, ClearPenaltyBuffer, DebugMonitor ...
        resb 63
Ylist_m2:                                       ; used by checkpuckcoll
        resb 2
Ylist:                                          ; used by SprSort, SprSort_test, checkcoll ...
        resb 34
OOlistpos:                                      ; used by ClearSortCords, LoadGameState, SprSort_test ...
        resb 34
UnusedSpeechWord:                               ; Reset to -1 for each game; otherwise unused; used by
                                                ; LoadGameState, ResetGameVars, SaveGameState
        resb 2
SpeechPatchNext:                                ; Speech patch header: next (set to 0 at start up); used by
                                                ; LoadGameState, ResetGameVars, SaveGameState ...
        resb 2
joysampling_save:                               ; used by ClockTick, Gameloop, HandleHotKey ...
        resb 2
UnusedCrowdWord:                                ; Crowd word cleared by ResetGameVars and kept in saved games;
                                                ; used by LoadGameState, ResetGameVars, SaveGameState
        resb 2
MaxCwdExciteLvl:                                ; used by LoadGameState, ResetGameVars, SaveGameState ...
        resb 2
NumCwdExciteLvl:                                ; used by LoadGameState, ResetGameVars, SaveGameState ...
        resb 2
CwdExciteLvl:                                   ; crowd excitement level (updatecrowdf); used by AddPenalty2,
                                                ; ChkShotStat, FallDown ...
        resb 2
UnusedCrowdWordHi:                              ; Second crowd word cleared by ResetGameVars and kept in saved
                                                ; games; used by LoadGameState, ResetGameVars, SaveGameState
        resb 2
periodendtime:                                  ; used by CrowdOnStoppage, LoadGameState, ResetClock ...
        resb 2
penevteam:                                      ; PostPenaltyEvent: team of the running penalty event, picks
                                                ; the wording; -1 after the faceoff; used by LoadGameState,
                                                ; PostPenaltyEvent, ResetGameVars ...
        resb 2
GoalState:                                      ; Goal state; used by Goal, LoadGameState, SaveGameState ...
        resb 2
ovlsteptimer:                                   ; frames left in the current overlay step (from
                                                ; ovlsteptime[ovlseq]); used by LoadGameState, LoadTeamPPV,
                                                ; SaveGameState ...
        resb 2
ovlstepidx:                                     ; index of the current step in the overlay script, advanced by
                                                ; UpdateTextOverlay; used by LoadGameState, LoadTeamPPV,
                                                ; SaveGameState ...
        resb 2
UnusedEventWord:                                ; Word cleared by ResetGameVars and kept in saved games; dword
                                                ; reads shifted right 17 give half of the word after it; used
                                                ; by CrowdOnStoppage, LoadGameState, ResetGameVars ...
        resb 1
        resb 1
PerTimeTotal:                                   ; used by DrawRinkOverlays, ForceStartLineup,
                                                ; GetPeriodTimeRemaining ...
        resb 2
PBnum:                                          ; aligned 2/3 accesses in assdopen, asspenalty; used by
                                                ; AddPenalty, DrawRinkOverlays, FallDown ...
        resb 1
        resb 1
lj2:                                            ; used by LoadGameState, ReadJoy2, SaveGameState
        resb 2
lj1:                                            ; used by LoadGameState, ReadJoy1, SaveGameState
        resb 2
iflags:                                         ; used by LoadGameState, PuckIChk, SaveGameState ...
        resb 1
icingPlayer:                                    ; used by StartHL2, a2touchpuck
        resb 1
lasttouch:                                      ; SCnum of the player who last touched the puck (written by
                                                ; the player logic puck code); Goal / PenTeamScored compare it
                                                ; with 6 for the team, ChkDelayedOffside penalizes
                                                ; SortCords[lasttouch]; used by ChkDelayedOffside,
                                                ; ChkOffsides, ChkTwoLinePass ...
        resb 2
lty:                                            ; used by ChkTwoLinePass, EndPenaltyShot, Goal ...
        resb 2
ltx:                                            ; aligned 2/2 accesses in Stop4Pen, a2touchpuck; used by
                                                ; EndPenaltyShot, Goal, LoadGameState ...
        resb 2
curevent:                                       ; the event being posted, 11 bytes: byte 0 type (1 goal, 3
                                                ; injury, -1 none); BuildEventLines turns it into the five
                                                ; text lines; used by BuildEventLines, LoadGameState,
                                                ; PostGoalEvent ...
        resb 1
curevent_b1:                                    ; curevent+1; used by BuildEventLines, PostGoalEvent,
                                                ; PostInjuryEvent ...
        resb 1
curevent_b2:                                    ; curevent+2; used by BuildEventLines, PostGoalEvent,
                                                ; PostInjuryEvent ...
        resb 1
curevent_b3:                                    ; curevent+3; used by BuildEventLines, PostGoalEvent,
                                                ; PostInjuryEvent ...
        resb 1
curevent_b4:                                    ; curevent+4; used by BuildEventLines, PostGoalEvent,
                                                ; PostInjuryEvent ...
        resb 1
curevent_b5:                                    ; curevent+5; used by BuildEventLines, PostGoalEvent,
                                                ; PostInjuryEvent ...
        resb 1
curevent_b6:                                    ; curevent+6; used by BuildEventLines, PostGoalEvent,
                                                ; PostInjuryEvent ...
        resb 1
curevent_b7:                                    ; curevent+7; used by BuildEventLines, PostGoalEvent,
                                                ; PostPenaltyEvent
        resb 1
curevent_b8:                                    ; curevent+8; used by BuildEventLines, PostGoalEvent
        resb 1
curevent_b9:                                    ; curevent+9; used by PostGoalEvent
        resb 1
curevent_b10:                                   ; curevent+0Ah; used by PostGoalEvent
        resb 1
goalevent:                                      ; PostGoalEvent's copy of the goal event for the announcer:
                                                ; byte 0 is 1 until assrefgoalpa has called the goal (PaGoal),
                                                ; then -1; used by LoadGameState, PostGoalEvent, ResetGameVars
                                                ; ...
        resb 1
goalevent_b1:                                   ; goalevent+1, read by assrefgoalpa for PaGoal; used by
                                                ; assrefgoalpa
        resb 1
goalevent_b2:                                   ; goalevent+2; used by assrefgoalpa
        resb 1
goalevent_b3:                                   ; goalevent+3; used by assrefgoalpa
        resb 1
goalevent_b4:                                   ; goalevent+4; used by assrefgoalpa
        resb 3
        resb 1
        resb 1
        resb 1
        resb 1
OOlist:                                         ; used by ClearSortCords, DrawRinkOverlays, LoadGameState ...
        resb 1
        resb 17
gwgteam:                                        ; three stars: winning team (0 home / 1 away, -1 if tied); set
                                                ; by PickThreeStars; used by PickThreeStars, StarCompare
        resb 2
        resb 2
gwgplayer:                                      ; three stars: the winning team's player from team field 2Eh
                                                ; (likely the game-winning goal scorer); StarCompare gives him
                                                ; +2; used by PickThreeStars, StarCompare
        resb 2
startm_m2:                                      ; used by assthreestars
        resb 2
startm:                                         ; three-stars list, team of star i (word, stride 4, 3 entries;
                                                ; -1 = empty); AddStar / PickThreeStars fill it, assthreestars
                                                ; reads it; used by AddStar, PickThreeStars, PostGameToTeamDb
                                                ; ...
        resb 2
starpl:                                         ; three-stars list, player index of star i (word, stride 4);
                                                ; pairs with startm; used by AddStar, PickThreeStars,
                                                ; PostGameToTeamDb ...
        resb 10
seqtimer:                                       ; used by PreGameIntro, StartThreeStars, ThreeStarsLoop_tick
                                                ; ...
        resb 36
lastimpact:                                     ; strength of the last player collision (checkcx stores the
                                                ; impact); checkint, newcheck and setInjuryType compare it;
                                                ; used by checkcx, checkint, newcheck ...
        resb 2
rinkobjused_m2:                                 ; rinkobjused-2: -5r short-load base; used by DecayCrowdLevel
        resb 2
rinkobjused:                                    ; bit set of the rink object ids now in a slot (SetRinkObject
                                                ; sets, DecayCrowdLevel picks a free one); used by
                                                ; DecayCrowdLevel, LoadGameState, ResetGameVars ...
        resb 32
gsumqueue:                                      ; queued game summary records, 11 bytes each, at most 8
                                                ; (PostGoalEvent/PostPenaltyEvent/PostInjuryEvent add,
                                                ; FlushGSumQueue empties); used by FlushGSumQueue,
                                                ; PostGoalEvent, PostInjuryEvent ...
        resb 88
defertab:                                       ; deferred call queue, 20h bytes per entry (QueueDeferredCall
                                                ; / RunDeferredCalls): argument 0 (eax); used by
                                                ; QueueDeferredCall, RunDeferredCalls
        resb 4
defertab_a1:                                    ; defertab+4: argument 1 (edx); used by QueueDeferredCall,
                                                ; RunDeferredCalls
        resb 4
defertab_a2:                                    ; defertab+8: argument 2 (ebx); used by QueueDeferredCall,
                                                ; RunDeferredCalls
        resb 4
defertab_a3:                                    ; defertab+0Ch: argument 3 (ecx); used by QueueDeferredCall,
                                                ; RunDeferredCalls
        resb 4
defertab_a4:                                    ; defertab+10h: first stack argument; used by
                                                ; QueueDeferredCall, RunDeferredCalls
        resb 4
defertab_a5:                                    ; defertab+14h: second stack argument; used by
                                                ; QueueDeferredCall, RunDeferredCalls
        resb 4
defertab_a6:                                    ; defertab+18h: third stack argument; used by
                                                ; QueueDeferredCall, RunDeferredCalls
        resb 4
defertab_fn:                                    ; defertab+1Ch: the function to call; used by
                                                ; QueueDeferredCall, RunDeferredCalls
        resb 100
lineslotmark:                                   ; 25 dwords: 1 for each player found in a line slot
                                                ; (BuildDefaultLines, SetupTeamLines, the sorts); used by
                                                ; SetupTeamLines, SortNonDefPlayers, SortPlayersByPos
        resb 97
        resb 3
linesortidx:                                    ; SortPlayersByPos / SortNonDefPlayers: the 25 roster indices
                                                ; sorted by lineslotmark; used by SortNonDefPlayers,
                                                ; SortPlayersByPos
        resb 100
offsort_c:                                      ; BuildDefaultLines: 25 bytes per team, roster players of
                                                ; position C sorted by the first rating table; used by
                                                ; BuildDefaultLines, PickForLineSlot
        resb 50
defsort_r:                                      ; BuildDefaultLines: 25 bytes per team, roster players of
                                                ; position R sorted by the second rating table; used by
                                                ; BuildDefaultLines, PickForLineSlot
        resb 50
offsort_d:                                      ; BuildDefaultLines: 25 bytes per team, roster players of
                                                ; position D sorted by the first rating table
                                                ; (SortPlayersByPos 'D'); used by BuildDefaultLines,
                                                ; PickForLineSlot, SetPlList
        resb 50
defsort_c:                                      ; BuildDefaultLines: 25 bytes per team, roster players of
                                                ; position C sorted by the second rating table; used by
                                                ; BuildDefaultLines, PickForLineSlot
        resb 50
defsort_d:                                      ; BuildDefaultLines: 25 bytes per team, roster players of
                                                ; position D sorted by the second rating table; used by
                                                ; BuildDefaultLines, CanRemovePlayer, PickForLineSlot ...
        resb 50
offsort_l:                                      ; BuildDefaultLines: 25 bytes per team, roster players of
                                                ; position L sorted by the first rating table; used by
                                                ; BuildDefaultLines, PickForLineSlot
        resb 50
dressflags:                                     ; dressed flag per roster player, 25 per team
                                                ; (BuildDefaultLines sets, NormalizeDressFlags makes them 0/1,
                                                ; CanFillLineSlot tests 2); used by BuildDefaultLines,
                                                ; CanFillLineSlot, FillDressedSlots ...
        resb 25
dressflags_aw:                                  ; dressflags+25: the visitors; used by NormalizeDressFlags
        resb 25
offsort_fwd:                                    ; BuildDefaultLines: 25 bytes per team, roster players other
                                                ; than defencemen sorted by the first rating table
                                                ; (SortNonDefPlayers); used by BuildDefaultLines,
                                                ; CanRemovePlayer, PickExtraSkater ...
        resb 50
defsort_l:                                      ; BuildDefaultLines: 25 bytes per team, roster players of
                                                ; position L sorted by the second rating table; used by
                                                ; BuildDefaultLines, PickForLineSlot
        resb 50
offsort_r:                                      ; BuildDefaultLines: 25 bytes per team, roster players of
                                                ; position R sorted by the first rating table; used by
                                                ; BuildDefaultLines, PickForLineSlot
        resb 50
defsort_fwd:                                    ; BuildDefaultLines: 25 bytes per team, roster players other
                                                ; than defencemen sorted by the second rating table
                                                ; (SortNonDefPlayers); used by BuildDefaultLines,
                                                ; PickForLineSlot, SetPlList
        resb 50
dressedfwds:                                    ; BuildDefaultLines / RemoveFromLines: count of dressed
                                                ; forwards (offsort_fwd); used by CanFillLineSlot,
                                                ; FillDressedSlots, RemoveFromLines ...
        resb 2
dresseddefs:                                    ; BuildDefaultLines / RemoveFromLines: count of dressed
                                                ; defencemen (defsort_d); used by CanFillLineSlot,
                                                ; FillDressedSlots, RemoveFromLines ...
        resb 2
dressedskaters:                                 ; dressedfwds + dresseddefs; CanFillLineSlot stops dressing at
                                                ; 18; used by DrawRinkSideObjects, FillDressedSlots,
                                                ; InstantReplay ...
        resb 2
rpl_x:                                          ; replay frame unpacked by ReplayStep, drawn by
                                                ; DrawRinkSideObjects: x per object (17 words);
                                                ; PickNearestPlayer searches it; used by DrawRinkSideObjects,
                                                ; InstantReplay, ReplayStep
        resb 26
rpl_x_e14_m2:                                   ; rpl_x_e14-2: -5r short-load base
        resb 2
rpl_x_e14:                                      ; rpl_x+2*14: x of object 14; used by DrawRinkSideObjects
        resb 2
rpl_x_e15:                                      ; rpl_x+2*15: x of object 15; used by DrawRinkSideObjects
        resb 2
rpl_x_e16:                                      ; rpl_x+2*16: x of object 16; used by DrawRinkSideObjects,
                                                ; InstantReplay, PickNearestPlayer ...
        resb 2
rpl_y:                                          ; replay frame unpacked by ReplayStep, drawn by
                                                ; DrawRinkSideObjects: y per object (17 words); used by
                                                ; DrawRinkSideObjects, InstantReplay, ReplayStep
        resb 26
rpl_y_e14_m2:                                   ; rpl_y_e14-2: -5r short-load base
        resb 2
rpl_y_e14:                                      ; rpl_y+2*14: y of object 14; used by DrawRinkSideObjects
        resb 2
rpl_y_e15:                                      ; rpl_y+2*15: y of object 15; used by DrawRinkSideObjects
        resb 2
rpl_y_e16:                                      ; rpl_y+2*16: y of object 16; used by DrawRinkSideObjects
        resb 2
rpl_frame:                                      ; replay frame unpacked by ReplayStep, drawn by
                                                ; DrawRinkSideObjects: frame per object (17 words); used by
                                                ; DrawRinkSideObjects, ReplayStep
        resb 26
rpl_frame_e14_m2:                               ; rpl_frame_e14-2: -5r short-load base
        resb 2
rpl_frame_e14:                                  ; rpl_frame+2*14: frame of object 14; used by
                                                ; DrawRinkSideObjects
        resb 2
rpl_frame_e15:                                  ; rpl_frame+2*15: frame of object 15; used by
                                                ; DrawRinkSideObjects
        resb 1
rpl_flip_m3:                                    ; rpl_flip-3: -5r byte-load base
        resb 3
rpl_flip:                                       ; replay frame unpacked by ReplayStep, drawn by
                                                ; DrawRinkSideObjects: flip byte per object (17 bytes); used
                                                ; by DrawRinkSideObjects, ReplayStep
        resb 14
rpl_jersey_m3:                                  ; rpl_jersey-3: -5r byte-load base
        resb 3
rpl_jersey:                                     ; replay frame unpacked by ReplayStep, drawn by
                                                ; DrawRinkSideObjects: jersey byte per player (12 bytes); used
                                                ; by DrawRinkSideObjects, ReplayStep
        resb 9
rpl_pos_m3:                                     ; rpl_pos-3: -5r byte-load base
        resb 3
rpl_pos:                                        ; replay frame unpacked by ReplayStep, drawn by
                                                ; DrawRinkSideObjects: position byte per player (12 bytes);
                                                ; used by DrawRinkSideObjects, ReplayStep
        resb 1
rpl_pos_b1:                                     ; rpl_pos+1; used by ReplayStep
        resb 9
rpl_puckz_m2:                                   ; rpl_puckz-2: -5r short-load base
        resb 2
rpl_puckz:                                      ; replay frame unpacked by ReplayStep, drawn by
                                                ; DrawRinkSideObjects: puck height; used by
                                                ; DrawRinkSideObjects, ReplayStep
        resb 1
rpl_c1player_m3:                                ; rpl_c1player-3: -5r byte-load base
        resb 1
rpl_puckunused:                                 ; Byte read after the puck height in each replay frame;
                                                ; written by ReplayStep and never read; used by ReplayStep
        resb 1
rpl_puckc_m3:                                   ; rpl_puckc-3: -5r byte-load base
        resb 1
rpl_c1player:                                   ; replay frame unpacked by ReplayStep, drawn by
                                                ; DrawRinkSideObjects: controlled player of pad 1; used by
                                                ; DrawRinkSideObjects, ReplayStep
        resb 1
rpl_c2player:                                   ; replay frame unpacked by ReplayStep, drawn by
                                                ; DrawRinkSideObjects: controlled player of pad 2; used by
                                                ; DrawRinkSideObjects, ReplayStep
        resb 1
rpl_puckc:                                      ; replay frame unpacked by ReplayStep, drawn by
                                                ; DrawRinkSideObjects: puck carrier; used by
                                                ; DrawRinkSideObjects, ReplayStep
        resb 1
rpl_pbnum:                                      ; replay frame unpacked by ReplayStep, drawn by
                                                ; DrawRinkSideObjects: penalty box count, first team; used by
                                                ; DrawRinkSideObjects, ReplayStep
        resb 1
rpl_pbnum_b1:                                   ; rpl_pbnum+1: penalty box count, second team; used by
                                                ; DrawRinkSideObjects, ReplayStep
        resb 1
rpl_camx:                                       ; replay frame unpacked by ReplayStep, drawn by
                                                ; DrawRinkSideObjects: camera x (ReplayStep stores it with
                                                ; camx); used by ReplayStep
        resb 2
rpl_camy:                                       ; replay frame unpacked by ReplayStep, drawn by
                                                ; DrawRinkSideObjects: camera y; used by ReplayStep
        resb 2
rpl_objframe:                                   ; replay frame unpacked by ReplayStep, drawn by
                                                ; DrawRinkSideObjects: frame per rink object (18 words); used
                                                ; by DrawRinkSideObjects, ReplayStep
        resb 37
rpl_objstep_m3:                                 ; rpl_objstep-3: -5r byte-load base
        resb 3
rpl_objstep:                                    ; replay frame unpacked by ReplayStep, drawn by
                                                ; DrawRinkSideObjects: animation step per rink object; used by
                                                ; DrawRinkSideObjects, ReplayStep
        resb 1
rpl_objstep_b1:                                 ; rpl_objstep+1; used by ReplayStep
        resb 19
rpl_ysort:                                      ; ReplayStep: the 17 replay objects' indices sorted by y; used
                                                ; by DrawRinkSideObjects, ReplayStep
        resb 68
