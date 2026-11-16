; Tables the scoring text adds up, and the picture list the animation player steps through.
bits 32
%include "hockey.inc"
section s_DEB78 nobits alloc noexec write align=1
global rinkobjs_b3, plcareerpts, plseasongoals, plseasonpts, ovlstepart, ovlstepart_e21, ovlstepart_e30, rinkobjs
global rinkobjs_w2, SaveStateSpare, SaveStatePad
plcareerpts:                                    ; per player +4: career points before this game; used by
                                                ; ChkScorerMilestone, LoadTeamRoster
        resb 4
plseasongoals:                                  ; per player +8: season goals before this game; used by
                                                ; BuildEventLines, ChkScorerMilestone, LoadTeamRoster
        resb 4
plseasonpts:                                    ; per player +0Ch: season points before this game; used by
                                                ; ChkScorerMilestone, LoadTeamRoster
        resb 788
rinkobjs:                                       ; rink-side object slots, 20 x 12 bytes (SetRinkObject sets
                                                ; one, DecayCrowdLevel animates them, DrawRinkObjects draws
                                                ; them); used by DecayCrowdLevel, DrawRinkObjects,
                                                ; LoadGameState ...
        resb 2
rinkobjs_w2:                                    ; rinkobjs+2; used by SaveGameState
        resb 1
rinkobjs_b3:                                    ; rinkobjs+3; used by updatereplay
        resb 237
SaveStateSpare:                                 ; Word only saved and restored with the game state; used by
                                                ; LoadGameState, SaveGameState
        resb 4
SaveStatePad:                                   ; Second word only saved and restored with the game state;
                                                ; used by LoadGameState, SaveGameState
        resb 4
ovlstepart:                                     ; art pointer per overlay step, drawn by DrawTextOverlay; used
                                                ; by DrawTextOverlay, Gameloop, LoadTeamPPV ...
        resb 84
ovlstepart_e21:                                 ; ovlstepart+4*21; used by DrawTextOverlay
        resb 36
ovlstepart_e30:                                 ; ovlstepart+4*30; used by DrawTextOverlay
        resb 8
