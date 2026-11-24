; Live game state after the sprite animation tables: the player priority list, the line
; change and coach line tables, the overlay and banner state.
bits 32
%include "hockey.inc"
section s_CBC36 progbits alloc noexec write align=1
global priolist_m1, priolist, shownumbers, debugstep, SortPending, exitgame, gameover, PerTimeTab
global energywarn, lcblink, lcblinktime, lcsel, lcsel_aw, lcline, lctimer, lcboxon
global CoachRotateFour, CoachRotateThree, CoachRotateThreeTop, CoachRotateFourEven, CoachRotateFourMixed, CoachRotateThreeEven, CoachSpecialUnits, CoachRotateTwo
global CoachRotateTwoDeep, CoachRotateFourShort, CoachRotateThreeShort, coachlinetab, ds2list, ObjInitFrame, ObjInitAttr, puckfaceoff2_ptab
global puckfaceoff2_ptab_y, apl, ovltimer, refhitcount, fadeinpending, injurystop, bannermsg, bannertimer
global ovlseq, ovlstep
priolist_m1:                                    ; used by releasepl
        db 0FFh
priolist:                                       ; used by SetPlList
        db 00h,01h,02h,04h,03h,05h,06h
shownumbers:                                    ; toggled by HandleHotKey on scan code 0Fh (Tab); while set
                                                ; the frame code draws each player's number (+5Eh) above him
                                                ; with DrawSpriteNumber; used by DrawRinkOverlays,
                                                ; DrawRinkSideObjects, HandleHotKey ...
        db 00h,00h,00h,00h
debugstep:                                      ; only used by DebugMonitor: non-zero prints the per-frame
                                                ; debug lines and waits for a key (WaitKey), '\' toggles it,
                                                ; joyq_flush on toggling off
        db 00h,00h
SortPending:                                    ; used by AddPenalty2, InProgress, LoadGameState ...
        db 00h,00h
exitgame:                                       ; main-loop request flag set by SetExitGame; used by
                                                ; DebugMonitor, Gameloop, IntermissionDesk ...
        db 01h,00h
gameover:                                       ; main-loop request flag set by GameOver; used by
                                                ; DebugMonitor, GameOver, Gameloop ...
        db 01h,00h
PerTimeTab:                                     ; period length table read by GetPeriodTime; used by
                                                ; GetPeriodTime, RunDemoGame
        db 02Ch,01h,058h,02h,0B0h,04h,0B0h,04h
energywarn:                                     ; per-team word (home, away): 1 while one of the team's
                                                ; skaters is exhausted (+43h < 0) on an odd lldispodd frame;
                                                ; DrawEnergyBar draws the bar in 0/7 instead of 67h; used by
                                                ; DrawEnergyBar, LoadGameState, PeriodOver ...
        db 00h,00h
        db 00h,00h
lcblink:                                        ; per team: line change box highlight blink state (toggled
                                                ; every 12 frames by lineinput); cleared with lcboxon when the
                                                ; box closes; used by ClearCtlBlink, DrawLineGroupBars,
                                                ; LoadGameState ...
        db 00h,00h
        db 00h,00h
lcblinktime:                                    ; per team: blink countdown (12 frames) in lineinput; used by
                                                ; LoadGameState, RequestLineChange, ResetGameVars ...
        db 00h,00h
        db 00h,00h
lcsel:                                          ; per team: highlighted line change choice; lineinput passes
                                                ; it to lcfound on a press and advances it every 60 frames mod
                                                ; 4 (mod 2 when lcline > 3); used by LoadGameState,
                                                ; RequestLineChange, ResetGameVars ...
        db 00h,00h
lcsel_aw:                                       ; lcsel+2: the visitors; also lcline-2, the -5r short-load
                                                ; base in lineinput; used by LoadGameState, ResetGameVars,
                                                ; SaveGameState ...
        db 00h,00h
lcline:                                         ; per team: line offered in the line change box, advanced
                                                ; through linenext; the box opener sets it from tmline or
                                                ; getlchoice(1); used by DrawLineGroupBars, LoadGameState,
                                                ; PeriodOver ...
        db 00h,00h
        db 00h,00h
lctimer:                                        ; per team: 60-frame countdown that advances lcsel/lcline in
                                                ; lineinput; used by LoadGameState, RequestLineChange,
                                                ; ResetGameVars ...
        db 00h,00h
        db 00h,00h
lcboxon:                                        ; per team: line change box open (set with lcblink by the box
                                                ; opener RequestLineChange, cleared by lineinput/doinput when
                                                ; a line is chosen); used by ClearCtlBlink, DrawLineGroupBars,
                                                ; LoadGameState ...
        db 00h,00h
        db 00h,00h
CoachRotateFour:                                ; Coach line table rows: next-line choices for a four-line
                                                ; rotation
        db 02h,01h,00h,03h,00h,03h,02h,01h,03h,02h,01h,00h,01h,00h,03h,02h
CoachRotateThree:                               ; Coach line table rows: three-line rotation with the
                                                ; power-play rows after it
        db 01h,02h,03h,0FFh,02h,00h,03h,0FFh,00h,01h,03h,0FFh,00h,01h,02h,0FFh
        db 01h,02h,03h,0FFh,02h,00h,03h,0FFh,03h,00h,01h,0FFh,00h,01h,02h,0FFh
CoachRotateThreeTop:                            ; Coach line table rows: three lines with the top line first
        db 02h,01h,00h,0FFh,00h,02h,01h,0FFh,01h,02h,00h,0FFh,01h,00h,02h,0FFh
CoachRotateFourEven:                            ; Coach line table rows: four lines in even rotation
        db 02h,01h,00h,03h,00h,01h,02h,03h,03h,02h,01h,00h,01h,00h,03h,02h
CoachRotateFourMixed:                           ; Coach line table rows: four lines in mixed rotation
        db 02h,01h,00h,03h,00h,01h,03h,02h,03h,02h,01h,00h,01h,00h,03h,02h
CoachRotateThreeEven:                           ; Coach line table rows: three lines in even rotation
        db 02h,01h,00h,0FFh,00h,01h,02h,0FFh,02h,01h,00h,0FFh,01h,00h,02h,0FFh
CoachSpecialUnits:                              ; Coach line table rows: special team units only
        db 05h,04h,0FFh,0FFh,04h,05h,0FFh,0FFh,04h,05h,0FFh,0FFh,04h,05h,0FFh,0FFh
CoachRotateTwo:                                 ; Coach line table rows: two lines only
        db 01h,00h,0FFh,0FFh,00h,01h,0FFh,0FFh,00h,01h,0FFh,0FFh,00h,01h,0FFh,0FFh
CoachRotateTwoDeep:                             ; Coach line table rows: two lines with the third line as
                                                ; backup
        db 01h,02h,0FFh,0FFh,02h,00h,0FFh,0FFh,00h,01h,0FFh,0FFh,00h,01h,02h,0FFh
CoachRotateFourShort:                           ; Coach line table rows: four lines with short shifts
        db 01h,02h,03h,0FFh,02h,03h,00h,0FFh,03h,00h,01h,0FFh,00h,01h,02h,0FFh
CoachRotateThreeShort:                          ; Coach line table rows: three lines with short shifts
        db 01h,02h,0FFh,0FFh,00h,02h,0FFh,0FFh,00h,01h,0FFh,0FFh,00h,01h,02h,0FFh
coachlinetab:                                   ; CompLine: pointer per coach mode (tmcoachmode) to its table
                                                ; of 4-byte rows, the lines to try next for each current line;
                                                ; used by CompLine
        dd CoachRotateFour
        dd CoachRotateThree
        dd CoachRotateThreeTop
        dd CoachRotateFourEven
        dd CoachRotateFourMixed
        dd CoachRotateThreeEven
        dd CoachSpecialUnits
        dd CoachRotateTwo
        dd CoachRotateTwoDeep
        dd CoachRotateFourShort
        dd CoachRotateThreeShort
ds2list:                                        ; used by ClearSortCords
        db 060h,0FFh,0F1h,0FFh,00h,00h,0FFh,0FFh,00h,00h
ObjInitFrame:                                   ; Object start table (18 bytes per object): frame word
                                                ; LoadGameState copies into the object; used by LoadGameState
        db 08h,00h
ObjInitAttr:                                    ; Object start table: attribute word LoadGameState copies into
                                                ; the object; used by LoadGameState
        db 04h,00h,029h,00h,080h,00h,060h,0FFh,0E2h,0FFh,00h,00h,0FFh,0FFh,00h,00h
        db 08h,00h,04h,00h,029h,00h,080h,00h,060h,0FFh,0D3h,0FFh,00h,00h,0FFh,0FFh
        db 00h,00h,08h,00h,04h,00h,029h,00h,080h,00h,060h,0FFh,0C4h,0FFh,00h,00h
        db 0FFh,0FFh,00h,00h,08h,00h,04h,00h,029h,00h,080h,00h,060h,0FFh,0B5h,0FFh
        db 00h,00h,0FFh,0FFh,00h,00h,08h,00h,04h,00h,029h,00h,080h,00h,060h,0FFh
        db 0A6h,0FFh,00h,00h,0FFh,0FFh,00h,00h,08h,00h,04h,00h,029h,00h,080h,00h
        db 060h,0FFh,019h,00h,00h,00h,0FFh,0FFh,01h,00h,08h,00h,04h,00h,029h,00h
        db 040h,00h,060h,0FFh,028h,00h,00h,00h,0FFh,0FFh,01h,00h,08h,00h,04h,00h
        db 029h,00h,040h,00h,060h,0FFh,037h,00h,00h,00h,0FFh,0FFh,01h,00h,08h,00h
        db 04h,00h,029h,00h,040h,00h,060h,0FFh,046h,00h,00h,00h,0FFh,0FFh,01h,00h
        db 08h,00h,04h,00h,029h,00h,040h,00h,060h,0FFh,055h,00h,00h,00h,0FFh,0FFh
        db 01h,00h,08h,00h,04h,00h,029h,00h,040h,00h,060h,0FFh,064h,00h,00h,00h
        db 0FFh,0FFh,01h,00h,08h,00h,04h,00h,029h,00h,040h,00h,00h,00h,0ECh,00h
        db 00h,00h,094h,01h,00h,00h,014h,00h,06h,00h,00h,00h,00h,00h,00h,00h
        db 014h,0FFh,00h,00h,095h,01h,00h,00h,014h,00h,06h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,0FFh,0FFh,00h,00h,05h,00h,05h,00h,018h,00h
        db 01h,00h,00h,00h,00h,00h,00h,00h,0FFh,0FFh,00h,00h,03h,00h,03h,00h
        db 019h,00h,04h,00h,0F1h,0FFh,00h,00h,00h,00h,0BFh,02h,00h,00h,08h,00h
        db 04h,00h,01Eh,00h,00h,00h
puckfaceoff2_ptab:                              ; used by PlacePlayersAtStart, asstakeposition, puckfaceoff2
        db 00h,00h
puckfaceoff2_ptab_y:                            ; puckfaceoff2_ptab+2: the y column; used by
                                                ; PlacePlayersAtStart, asstakeposition, puckfaceoff2
        db 024h,0FFh,0DDh,0FFh,0D3h,0FFh,023h,00h,0D3h,0FFh,0CCh,0FFh,0F6h,0FFh,00h,00h
        db 0F8h,0FFh,034h,00h,0F6h,0FFh,00h,00h,0C9h,0FFh
apl:                                            ; faceoff slot list, the bytes of puckfaceoff2 .apl; used by
                                                ; PlacePlayersAtStart, asstakeposition, puckfaceoff2
        db 00h,01h,02h,03h,04h,05h,06h,00h,00h,01h,05h,03h,04h,02h,00h,00h
        db 00h,03h,05h,01h,04h,00h
        db 00h,00h
ovltimer:                                       ; text overlay slide timer: DrawTextOverlay slides in below
                                                ; 10h, shows at 100h, slides out to 258h; CloseTextOverlay
                                                ; sets 10h/0; used by ChkScorerMilestone, CloseTextOverlay,
                                                ; CrowdOnStoppage ...
        db 0FFh,0FFh
refhitcount:                                    ; checkcheck: checks on the referee (SCnum 10h); the third
                                                ; draws penalty 16h. ResetGameVars clears it; used by
                                                ; LoadGameState, ResetGameVars, SaveGameState ...
        db 00h,00h
fadeinpending:                                  ; set when the pre-game intro is skipped or a game starts; the
                                                ; next game frame fades the palette in and clears it; used by
                                                ; Gameloop, HandleHotKey, LoadGameGfx_common ...
        db 00h,00h
injurystop:                                     ; set by setInjuryType when a player is hurt: the referee
                                                ; stops play and the call countdown is 140h; cleared at the
                                                ; next faceoff; used by LoadGameState, ResetGameVars,
                                                ; SaveGameState ...
        db 00h,00h
bannermsg:                                      ; index into the call banner strings bannerstrs (-1 none); set
                                                ; by offside/icing/faceoff/penalty code, drawn by
                                                ; DrawCallBanner; used by AddPenalty2, DrawRinkOverlays,
                                                ; DrawTextOverlay ...
        db 0FFh,0FFh
bannertimer:                                    ; word: frames left for the call banner (50h typical); cleared
                                                ; with bannermsg; used by AddPenalty2, DrawRinkOverlays,
                                                ; DrawTextOverlay ...
        db 00h,00h
ovlseq:                                         ; current overlay script id (-1 none); UpdateTextOverlay
                                                ; indexes ovlseqtimed / ovlsteptime with it; used by
                                                ; CrowdOnStoppage, DrawTextOverlay, EnsureFreeMemory ...
        db 0FFh,0FFh
ovlstep:                                        ; current overlay script step value (byte of the script at
                                                ; ovlstepidx); DrawTextOverlay and DrawTextOverlay callers
                                                ; read it; used by DrawTextOverlay, Gameloop, LoadGameState
                                                ; ...
        db 0FFh,0FFh
