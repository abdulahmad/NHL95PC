; The random seed, the assignment table, and the live game flags, puck, and penalty tables.
bits 32
%include "hockey.inc"
section s_C9078 progbits alloc noexec write align=1
extern assstarskate, assthreestars, assleaveice, assrefatdot, assreffollow, assrefsignal, assrefgoalpa, assrefdrop
extern assrefgoalline, assrefwhistle, assintrostand, assintroline, asstakeposition, assleavebox, assbenchwait, assboxenter
extern assbenchside, assrefpenshot, asspsclear, asspenshooter, assbench, asscenterd, asscentero, assdefd
extern assdefo, assdopen, asseben, assepen, assfaceoff, assfaceoffpl, assgoalie, assgoalietopuck
extern assnearest, asspassrec, asspenalty, asspuckc, assscore, assshoot, assstanley, asswingd
extern asswingo, puckfaceoff, puckfaceoff2, pucknorm, pucknothing, puckshadow, rtss
extern ReplayBuffer, puckstruct
global seed, asstab, sflags, gmode2, pendelaytab
global pendelaytab_e13, penmintab, pendelay2tab, pendelay2tab_e4, priolist_m1, priolist, apl, collflag
global dirtab, wcradiusy, yleader, sflags3, cont2team, HomeTeam, penmintab_m3, shownumbers
global bannertimer, puckvx, gmode, replaystart, puckx, pucky, puckvy
global puckz, puckc, camx_m2, coachlinetab, lastplayer, puckvz, threat, SPAtab
global CoachRotateFour, CoachRotateThree, CoachRotateThreeTop, CoachRotateFourEven, CoachRotateFourMixed, CoachRotateThreeEven, CoachSpecialUnits, CoachRotateTwo
global CoachRotateTwoDeep, CoachRotateFourShort, CoachRotateThreeShort, ds2list, wcradiusx, camx, camy, shotplayer
global passdir, passspeed, passplayer, xc1, yc1, fox, foy, fodir1
global fodir2, c1playernum, c2playernum, cont1team, VisTeam, PenCntDwn, Penaltytimer, refsignal
global RefStep, RefPen, penaltysc, gsp, gameclock, clockticks, dirtab_y
global debugstep, SortPending, exitgame, gameover, PerTimeTab, energywarn, lcblink
global lcblinktime, lcsel, lcsel_aw, lcline, lctimer
global lcboxon, ObjInitFrame, ObjInitAttr, puckfaceoff2_ptab, puckfaceoff2_ptab_y, ovltimer
global refhitcount, fadeinpending, injurystop, bannermsg, ovlseq, ovlstep
replaystart:                                    ; used by LoadGameState, PlayHilight, ReplayFirstFrame ...
        dd ReplayBuffer
puckx:                                          ; used by CanBlockShot, CountPuckThreat, DrawRinkOverlays ...
        dd puckstruct+2
puckvx:                                         ; used by ReassignCtlPlayer, ScatterPass, SetupPenaltyShot ...
        dd puckstruct+0Ch
pucky:                                          ; used by CanBlockShot, CheckBump, ChkDelayedOffside ...
        dd puckstruct+6
puckvy:                                         ; used by CanBlockShot, ReassignCtlPlayer, ScatterPass ...
        dd puckstruct+0Eh
puckz:                                          ; used by BlockShotDive, DrawRinkOverlays, Endfaceoff ...
        dd puckstruct+0Ah
puckvz:                                         ; aligned 3/5 accesses in dopass, doshot, passtoa0; used by
                                                ; BlockShotDive, DebugMonitor, ScatterPass ...
        dd puckstruct+10h
puckc:
camx_m2 equ $+2
        dd puckstruct+042h
camx:                                           ; camera x (LockScroll copies it into xc1); used by
                                                ; DebugMonitor, DrawRinkOverlays, DrawRinkSideObjects ...
        db 00h,00h
camy:                                           ; camera y (LockScroll copies it into yc1); used by
                                                ; DebugMonitor, DrawRinkOverlays, DrawRinkSideObjects ...
        db 00h,00h
wcradiusx:                                      ; aligned 2/3 accesses in checkgoal, checkwallcoll; used by
                                                ; checkcoll, checkgoal, checkgoalp ...
        db 00h,00h
wcradiusy:                                      ; used by checkcoll, checkgoal, checkgoalp ...
        db 00h,00h
shotplayer:                                     ; doshot stores the shooter SCnum here; 95 doshot writes
                                                ; shotplayer and assscore compares it with SCnum; used by
                                                ; CanBlockShot, ChkShotStat, Goal ...
        db 00h,00h
lastplayer:                                     ; dopass and doshot store the carrier SCnum here; 95 writes
                                                ; lastplayer; used by GiveControl, LoadGameState,
                                                ; ResetGameVars ...
        db 00h,00h
passdir:                                        ; used by LoadGameState, ResetGameVars, SaveGameState ...
        db 00h,00h
passspeed:                                      ; dopass stores passacc*2+$A0 here and doshot scales it by
                                                ; $5249; 95 passspeed; used by LoadGameState, ResetGameVars,
                                                ; SaveGameState ...
        db 00h,00h
passplayer:                                     ; used by LoadGameState, PassCompleted, ResetGameVars ...
        db 00h,00h
threat:                                         ; aligned 2/3 accesses in assgoalie, chk4pass; used by
                                                ; CountPuckThreat, LoadGameState, ResetGameVars ...
        db 00h,00h
xc1:                                            ; used by DebugMonitor, LoadGameState, PreGameIntro ...
        db 00h,00h
yc1:                                            ; used by DebugMonitor, LoadGameState, PreGameIntro ...
        db 00h,00h
yleader:                                        ; used by LoadGameState, SaveGameState, StartHL2 ...
        db 00h,00h
fox:                                            ; used by Goal, LoadGameState, PlacePlayersAtStart ...
        db 00h,00h
foy:                                            ; used by ChkPullGoalieLate, Goal, LoadGameState ...
        db 00h,00h
fodir1:                                         ; used by Endfaceoff, LoadGameState, SaveGameState ...
        db 00h,00h
fodir2:                                         ; used by Endfaceoff, LoadGameState, SaveGameState ...
        db 00h,00h
collflag:                                       ; aligned 2/3 accesses in Bcheck, holdcheck; used by Bcheck,
                                                ; Goal, LoadGameState ...
        db 00h
gmode:                                          ; used by AddPenalty, BuildEventLines, CheckBump ...
        db 00h
sflags:                                         ; used by AddPenalty2, CheckBump, InProgress ...
        db 00h,00h
gmode2:                                         ; game-state flag word beside gmode (saved with the game,
                                                ; cleared/restored by the frame driver); bit 7 also selects
                                                ; the referee's signalling animations; meaning of the other
                                                ; bits unknown; used by ChkShotStat, DebugMonitor, Endfaceoff
                                                ; ...
        db 00h,00h
sflags3:                                        ; used by CrowdOnStoppage, Endfaceoff, LoadGameState ...
        db 00h,00h
c1playernum:                                    ; used by Bcheck, DebugMonitor, DrawRinkOverlays ...
        db 0FFh
        db 0FFh
c2playernum:                                    ; used by DebugMonitor, DrawRinkOverlays, GiveControl ...
        db 0FFh
        db 0FFh
cont1team:                                      ; used by ChkGoalies, ChkPullGoalieLate, ClearCtlBlink ...
        db 00h,00h
cont2team:                                      ; used by ChkGoalies, ClearCtlBlink, ControlsDlgInGame_setside
                                                ; ...
        db 00h,00h
HomeTeam:                                       ; used by ControlsDlgLoop, DeskGoToReplay, DeskReloadGame ...
        db 0Ch,00h
VisTeam:                                        ; used by ControlsDlgLoop, DrawControlsDlg,
                                                ; DrawGameLineJerseys ...
        db 015h,00h
PenCntDwn:                                      ; used by DebugMonitor, LoadGameState, ResetGameVars ...
        db 0FFh,0FFh
Penaltytimer:                                   ; used by LoadGameState, ResetGameVars, SaveGameState ...
        db 00h,00h
refsignal:                                      ; used by DebugMonitor, LoadGameState, ResetGameVars ...
        db 00h,00h
RefStep:                                        ; used by ClearSortCords, DebugMonitor, InProgress ...
        db 0FFh
        db 0FFh
RefPen:                                         ; used by CrowdOnStoppage, LoadGameState, ResetGameVars ...
        db 00h,00h
penaltysc:                                      ; sort object number of the player the referee's call is
                                                ; about, -1 none: InProgress sets it from the penalty buffer,
                                                ; QueueGoalieNote and assrefgoalpa read it; used by
                                                ; InProgress, LoadGameState, QueueGoalieNote ...
        db 0FFh,0FFh
gsp:                                            ; used by CPgoalie, ChkPullGoalieLate, CrowdOnStoppage ...
        db 00h,00h
gameclock:                                      ; used by CPgoalie, ChkPullGoalieLate, ClockTick ...
        db 00h,00h
clockticks:                                     ; ticks within the current gameclock second (reloaded with 18h
                                                ; by ClockTick); used by ClockTick, DebugMonitor,
                                                ; ForceStartLineup ...
        db 00h,00h
dirtab:                                         ; used by Endfaceoff, burst, dopass ...
        db 00h,00h
dirtab_y:                                       ; used by Endfaceoff, burst, playeracc
        db 0C8h,00h,08Dh,00h,08Dh,00h,0C8h,00h,00h,00h,08Dh,00h,073h,0FFh,00h,00h
        db 038h,0FFh,073h,0FFh,073h,0FFh,038h,0FFh,00h,00h,073h,0FFh,08Dh,00h
seed:                                           ; used by LoadGameState, PreGameIntro, RunDemoGame ...
        db 021h,043h
        db 0CDh,0ABh
pendelaytab:                                    ; used by checkfornewpen
        db 00h,0Ah,0Ah,03h,01h,00h,01h,01h,01h,0Ah,0Ah,04h,04h
pendelaytab_e13:                                ; pendelaytab+0Dh: entry 13, checkfornewpen uses it for a
                                                ; penalty shot; used by checkfornewpen
        db 04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,04h,01h
penmintab_m3:                                   ; penmintab-3: -5r byte-load base
        db 00h,01h,01h
penmintab:                                      ; used by AddPenalty2, InProgress, PenGoalStuff ...
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,00h,02h,02h,02h,02h,02h
        db 02h,02h,02h,02h,02h,02h,0FFh,05h,05h,05h,00h,00h,00h,00h,00h
pendelay2tab:                                   ; checkfornewpen: second delay per penalty, x 32 frames, the
                                                ; minimum for PenCntDwn2; used by checkfornewpen
        db 00h,02h,02h,02h
pendelay2tab_e4:                                ; pendelay2tab+4: entry 4, used for a penalty shot; used by
                                                ; checkfornewpen
        db 02h,00h,02h,04h,02h,06h,02h,02h,02h,02h,02h,02h,02h,02h,02h,02h
        db 02h,02h,02h,02h,02h,02h,02h,00h,02h,02h,02h
asstab:                                         ; used by updateplayers
        dd rtss
        dd assdefo
        dd assdefd
        dd asswingd
        dd asswingo
        dd asscenterd
        dd asscentero
        dd assscore
        dd assstanley
        dd asseben
        dd assepen
        dd assbench
        dd asspenalty
        dd assdopen
        dd assgoalie
        dd assgoalietopuck
        dd asspuckc
        dd assnearest
        dd assshoot
        dd asspassrec
        dd assstarskate
        dd assthreestars
        dd assfaceoff
        dd assfaceoffpl
        dd pucknorm
        dd puckshadow
        dd pucknothing
        dd puckfaceoff
        dd puckfaceoff2
        dd assleaveice
        dd assrefatdot
        dd assreffollow
        dd assrefsignal
        dd assrefgoalpa
        dd assrefdrop
        dd assrefgoalline
        dd assrefwhistle
        dd assintrostand
        dd assintroline
        dd asstakeposition
        dd assleavebox
        dd assbenchwait
        dd assboxenter
        dd assbenchside
        dd assrefpenshot
        dd asspsclear
        dd asspenshooter
SPAtab:                                         ; used by updateanim
        db 00h,00h,00h,080h,012h,00h,024h,00h,036h,00h,048h,00h,05Ah,00h,06Ch,00h
        db 07Eh,00h,096h,01h,0B4h,00h,01Ah,02h,0Ah,00h,01Bh,02h,0Ah,00h,01Ah,02h
        db 0Ah,00h,01Bh,02h,0Ah,00h,096h,01h,0F0h,00h,01Ah,02h,0Ah,00h,01Bh,02h
        db 0Ah,00h,01Ah,02h,0F6h,0FFh,099h,01h,082h,00h,01Ch,02h,0Ah,00h,01Dh,02h
        db 0Ah,00h,01Ch,02h,0Ah,00h,01Dh,02h,0Ah,00h,099h,01h,02Ch,01h,01Ch,02h
        db 0Ah,00h,01Dh,02h,0Ah,00h,01Ch,02h,0F6h,0FFh,09Ch,01h,0D2h,00h,01Eh,02h
        db 0Ah,00h,01Fh,02h,0Ah,00h,01Eh,02h,0Ah,00h,01Fh,02h,0Ah,00h,09Ch,01h
        db 078h,00h,01Eh,02h,0Ah,00h,01Fh,02h,0Ah,00h,01Eh,02h,0F6h,0FFh,09Fh,01h
        db 064h,00h,020h,02h,0Ah,00h,021h,02h,0Ah,00h,020h,02h,0Ah,00h,021h,02h
        db 0Ah,00h,09Fh,01h,0C8h,00h,020h,02h,0Ah,00h,021h,02h,0Ah,00h,020h,02h
        db 0F6h,0FFh,0A2h,01h,0F0h,00h,022h,02h,0Ah,00h,023h,02h,0Ah,00h,022h,02h
        db 0Ah,00h,023h,02h,0Ah,00h,0A2h,01h,03Ch,00h,022h,02h,0Ah,00h,023h,02h
        db 0Ah,00h,022h,02h,0F6h,0FFh,0A5h,01h,0B4h,00h,024h,02h,0Ah,00h,025h,02h
        db 0Ah,00h,024h,02h,0Ah,00h,025h,02h,0Ah,00h,0A5h,01h,0F0h,00h,024h,02h
        db 0Ah,00h,025h,02h,0Ah,00h,024h,02h,0F6h,0FFh,0A8h,01h,078h,00h,026h,02h
        db 0Ah,00h,027h,02h,0Ah,00h,026h,02h,0Ah,00h,027h,02h,0Ah,00h,0A8h,01h
        db 078h,00h,026h,02h,0Ah,00h,027h,02h,0Ah,00h,026h,02h,0F6h,0FFh,0ABh,01h
        db 0B4h,00h,028h,02h,0Ah,00h,029h,02h,0Ah,00h,028h,02h,0Ah,00h,029h,02h
        db 0Ah,00h,0ABh,01h,0B4h,00h,028h,02h,0Ah,00h,029h,02h,0Ah,00h,028h,02h
        db 0F6h,0FFh,00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h
        db 0Eh,00h,096h,01h,0E2h,0FFh,099h,01h,0E2h,0FFh,09Ch,01h,0E2h,0FFh,09Fh,01h
        db 0E2h,0FFh,0A2h,01h,0E2h,0FFh,0A5h,01h,0E2h,0FFh,0A8h,01h,0E2h,0FFh,0ABh,01h
        db 0E2h,0FFh,00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h
        db 0Eh,00h,097h,01h,0E0h,0FFh,09Ah,01h,0E0h,0FFh,09Dh,01h,0E0h,0FFh,0A0h,01h
        db 0E0h,0FFh,0A3h,01h,0E0h,0FFh,0A6h,01h,0E0h,0FFh,0A9h,01h,0E0h,0FFh,0ACh,01h
        db 0E0h,0FFh,00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h
        db 0Eh,00h,098h,01h,0E0h,0FFh,09Bh,01h,0E0h,0FFh,09Eh,01h,0E0h,0FFh,0A1h,01h
        db 0E0h,0FFh,0A4h,01h,0E0h,0FFh,0A7h,01h,0E0h,0FFh,0AAh,01h,0E0h,0FFh,0ADh,01h
        db 0E0h,0FFh,00h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h,012h,00h,014h,00h
        db 016h,00h,016h,02h,04h,00h,017h,02h,08h,00h,016h,02h,0FCh,0FFh,09Bh,01h
        db 0E0h,0FFh,09Eh,01h,0E0h,0FFh,0A1h,01h,0E0h,0FFh,018h,02h,04h,00h,019h,02h
        db 08h,00h,018h,02h,0FCh,0FFh,0A7h,01h,0E0h,0FFh,0AAh,01h,0E0h,0FFh,0ADh,01h
        db 0E0h,0FFh,00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h
        db 0Eh,00h,0D6h,01h,0E0h,0FFh,0D8h,01h,0E0h,0FFh,0DAh,01h,0E0h,0FFh,0DCh,01h
        db 0E0h,0FFh,0DEh,01h,0E0h,0FFh,0E0h,01h,0E0h,0FFh,0E2h,01h,0E0h,0FFh,0E4h,01h
        db 0E0h,0FFh,00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h
        db 0Eh,00h,0D7h,01h,0E0h,0FFh,0D9h,01h,0E0h,0FFh,0DBh,01h,0E0h,0FFh,0DDh,01h
        db 0E0h,0FFh,0DFh,01h,0E0h,0FFh,0E1h,01h,0E0h,0FFh,0E3h,01h,0E0h,0FFh,0E5h,01h
        db 0E0h,0FFh,00h,00h,04h,00h,08h,00h,0Ch,00h,010h,00h,014h,00h,018h,00h
        db 01Ch,00h,0BEh,01h,08h,00h,0BFh,01h,0E0h,0FFh,0C0h,01h,08h,00h,0C1h,01h
        db 0E0h,0FFh,0C0h,01h,08h,00h,0C1h,01h,0E0h,0FFh,0C2h,01h,08h,00h,0C3h,01h
        db 0E0h,0FFh,0C4h,01h,08h,00h,0C5h,01h,0E0h,0FFh,0C6h,01h,08h,00h,0C7h,01h
        db 0E0h,0FFh,0C6h,01h,08h,00h,0C7h,01h,0E0h,0FFh,0C8h,01h,08h,00h,0C9h,01h
        db 0E0h,0FFh,00h,00h,04h,00h,08h,00h,0Ch,00h,010h,00h,014h,00h,018h,00h
        db 01Ch,00h,0CAh,01h,08h,00h,0CBh,01h,0E0h,0FFh,0CCh,01h,08h,00h,0CDh,01h
        db 0E0h,0FFh,0CCh,01h,08h,00h,0CDh,01h,0E0h,0FFh,0CEh,01h,08h,00h,0CFh,01h
        db 0E0h,0FFh,0D0h,01h,08h,00h,0D1h,01h,0E0h,0FFh,0D2h,01h,08h,00h,0D3h,01h
        db 0E0h,0FFh,0D2h,01h,08h,00h,0D3h,01h,0E0h,0FFh,0D4h,01h,08h,00h,0D5h,01h
        db 0E0h,0FFh,00h,00h,06h,00h,0Ch,00h,012h,00h,018h,00h,01Eh,00h,024h,00h
        db 02Ah,00h,06h,02h,08h,00h,07h,02h,030h,00h,06h,02h,0F8h,0FFh,08h,02h
        db 08h,00h,09h,02h,030h,00h,08h,02h,0F8h,0FFh,0Ah,02h,08h,00h,0Bh,02h
        db 030h,00h,0Ah,02h,0F8h,0FFh,0Ch,02h,08h,00h,0Dh,02h,030h,00h,0Ch,02h
        db 0F8h,0FFh,0Eh,02h,08h,00h,0Fh,02h,030h,00h,0Eh,02h,0F8h,0FFh,010h,02h
        db 08h,00h,011h,02h,030h,00h,010h,02h,0F8h,0FFh,012h,02h,08h,00h,013h,02h
        db 030h,00h,012h,02h,0F8h,0FFh,014h,02h,08h,00h,015h,02h,030h,00h,014h,02h
        db 0F8h,0FFh,00h,00h,06h,00h,0Ch,00h,012h,00h,018h,00h,01Eh,00h,024h,00h
        db 02Ah,00h,0AEh,01h,05h,00h,0AFh,01h,08h,00h,0AEh,01h,0F0h,0FFh,0B0h,01h
        db 05h,00h,0B1h,01h,08h,00h,0B0h,01h,0F0h,0FFh,0B2h,01h,05h,00h,0B3h,01h
        db 08h,00h,0B2h,01h,0F0h,0FFh,0B4h,01h,05h,00h,0B5h,01h,08h,00h,0B4h,01h
        db 0F0h,0FFh,0B6h,01h,05h,00h,0B7h,01h,08h,00h,0B6h,01h,0F0h,0FFh,0B8h,01h
        db 05h,00h,0B9h,01h,08h,00h,0B8h,01h,0F0h,0FFh,0BAh,01h,05h,00h,0BBh,01h
        db 08h,00h,0BAh,01h,0F0h,0FFh,0BCh,01h,05h,00h,0BDh,01h,08h,00h,0BCh,01h
        db 0F0h,0FFh,00h,00h,08h,00h,010h,00h,018h,00h,020h,00h,028h,00h,030h,00h
        db 038h,00h,0E6h,01h,0Ah,00h,0E7h,01h,0Ah,00h,0E8h,01h,0Ah,00h,0E9h,01h
        db 0F1h,0FFh,0EAh,01h,0Ah,00h,0EBh,01h,0Ah,00h,0ECh,01h,0Ah,00h,0EDh,01h
        db 0F1h,0FFh,0EEh,01h,0Ah,00h,0EFh,01h,0Ah,00h,0F0h,01h,0Ah,00h,0F1h,01h
        db 0F1h,0FFh,0F2h,01h,0Ah,00h,0F3h,01h,0Ah,00h,0F4h,01h,0Ah,00h,0F5h,01h
        db 0F1h,0FFh,0F6h,01h,0Ah,00h,0F7h,01h,0Ah,00h,0F8h,01h,0Ah,00h,0F9h,01h
        db 0F1h,0FFh,0FAh,01h,0Ah,00h,0FBh,01h,0Ah,00h,0FCh,01h,0Ah,00h,0FDh,01h
        db 0F1h,0FFh,0FEh,01h,0Ah,00h,0FFh,01h,0Ah,00h,00h,02h,0Ah,00h,01h,02h
        db 0F1h,0FFh,02h,02h,0Ah,00h,03h,02h,0Ah,00h,04h,02h,0Ah,00h,05h,02h
        db 0F1h,0FFh,00h,080h,010h,00h,020h,00h,030h,00h,040h,00h,042h,00h,044h,00h
        db 046h,00h,08Bh,01h,04h,00h,08Ch,01h,04h,00h,08Dh,01h,04h,00h,08Eh,01h
        db 04h,00h,08Fh,01h,04h,00h,08Ch,01h,04h,00h,090h,01h,04h,00h,08Ah,01h
        db 0FCh,0FFh,092h,01h,02h,00h,08Ah,01h,02h,00h,091h,01h,02h,00h,08Eh,01h
        db 02h,00h,093h,01h,02h,00h,08Eh,01h,02h,00h,091h,01h,02h,00h,08Ah,01h
        db 0FEh,0FFh,08Dh,01h,02h,00h,08Ch,01h,02h,00h,08Bh,01h,02h,00h,08Ah,01h
        db 02h,00h,090h,01h,02h,00h,08Ch,01h,02h,00h,08Fh,01h,02h,00h,08Eh,01h
        db 0FEh,0FFh,091h,01h,04h,00h,08Ah,01h,04h,00h,092h,01h,04h,00h,08Ah,01h
        db 04h,00h,091h,01h,04h,00h,08Eh,01h,04h,00h,093h,01h,04h,00h,08Eh,01h
        db 0FCh,0FFh,08Ah,01h,00h,0F0h,08Ah,01h,00h,0F0h,08Eh,01h,00h,0F0h,08Eh,01h
        db 00h,0F0h,00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h
        db 0Eh,00h,00h,00h,0F8h,0FFh,05h,00h,0F8h,0FFh,0Ah,00h,0F8h,0FFh,0Fh,00h
        db 0F8h,0FFh,014h,00h,0F8h,0FFh,019h,00h,0F8h,0FFh,01Eh,00h,0F8h,0FFh,023h,00h
        db 0F8h,0FFh,00h,00h,08h,00h,010h,00h,018h,00h,020h,00h,028h,00h,030h,00h
        db 038h,00h,01h,00h,0Ah,00h,02h,00h,0Ah,00h,03h,00h,0Ah,00h,04h,00h
        db 0F6h,0FFh,06h,00h,0Ah,00h,07h,00h,0Ah,00h,08h,00h,0Ah,00h,09h,00h
        db 0F6h,0FFh,0Bh,00h,0Ah,00h,0Ch,00h,0Ah,00h,0Dh,00h,0Ah,00h,0Eh,00h
        db 0F6h,0FFh,010h,00h,0Ah,00h,011h,00h,0Ah,00h,012h,00h,0Ah,00h,013h,00h
        db 0F6h,0FFh,015h,00h,0Ah,00h,016h,00h,0Ah,00h,017h,00h,0Ah,00h,018h,00h
        db 0F6h,0FFh,01Ah,00h,0Ah,00h,01Bh,00h,0Ah,00h,01Ch,00h,0Ah,00h,01Dh,00h
        db 0F6h,0FFh,01Fh,00h,0Ah,00h,020h,00h,0Ah,00h,021h,00h,0Ah,00h,022h,00h
        db 0F6h,0FFh,024h,00h,0Ah,00h,025h,00h,0Ah,00h,026h,00h,0Ah,00h,027h,00h
        db 0F6h,0FFh,00h,00h,08h,00h,010h,00h,018h,00h,020h,00h,028h,00h,030h,00h
        db 038h,00h,029h,00h,0Ah,00h,02Ah,00h,0Ah,00h,02Bh,00h,0Ah,00h,02Ch,00h
        db 0F6h,0FFh,02Eh,00h,0Ah,00h,02Fh,00h,0Ah,00h,030h,00h,0Ah,00h,031h,00h
        db 0F6h,0FFh,033h,00h,0Ah,00h,034h,00h,0Ah,00h,035h,00h,0Ah,00h,036h,00h
        db 0F6h,0FFh,038h,00h,0Ah,00h,039h,00h,0Ah,00h,03Ah,00h,0Ah,00h,03Bh,00h
        db 0F6h,0FFh,03Dh,00h,0Ah,00h,03Eh,00h,0Ah,00h,03Fh,00h,0Ah,00h,040h,00h
        db 0F6h,0FFh,042h,00h,0Ah,00h,043h,00h,0Ah,00h,044h,00h,0Ah,00h,045h,00h
        db 0F6h,0FFh,047h,00h,0Ah,00h,048h,00h,0Ah,00h,049h,00h,0Ah,00h,04Ah,00h
        db 0F6h,0FFh,04Ch,00h,0Ah,00h,04Dh,00h,0Ah,00h,04Eh,00h,0Ah,00h,04Fh,00h
        db 0F6h,0FFh,00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h
        db 0Eh,00h,050h,00h,0F8h,0FFh,051h,00h,0F8h,0FFh,052h,00h,0F8h,0FFh,053h,00h
        db 0F8h,0FFh,054h,00h,0F8h,0FFh,055h,00h,0F8h,0FFh,056h,00h,0F8h,0FFh,057h,00h
        db 0F8h,0FFh,00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h
        db 0Eh,00h,058h,00h,0F8h,0FFh,059h,00h,0F8h,0FFh,05Ah,00h,0F8h,0FFh,05Bh,00h
        db 0F8h,0FFh,05Ch,00h,0F8h,0FFh,05Dh,00h,0F8h,0FFh,05Eh,00h,0F8h,0FFh,05Fh,00h
        db 0F8h,0FFh,00h,080h,04h,00h,08h,00h,0Ch,00h,010h,00h,014h,00h,018h,00h
        db 01Ch,00h,090h,00h,04h,00h,091h,00h,0FCh,0FFh,092h,00h,04h,00h,093h,00h
        db 0FCh,0FFh,094h,00h,04h,00h,095h,00h,0FCh,0FFh,096h,00h,04h,00h,097h,00h
        db 0FCh,0FFh,098h,00h,04h,00h,099h,00h,0FCh,0FFh,09Ah,00h,04h,00h,09Bh,00h
        db 0FCh,0FFh,09Ch,00h,04h,00h,09Dh,00h,0FCh,0FFh,09Eh,00h,04h,00h,09Fh,00h
        db 0FCh,0FFh,00h,00h,06h,00h,0Ch,00h,012h,00h,018h,00h,01Eh,00h,024h,00h
        db 02Ah,00h,063h,00h,04h,00h,064h,00h,04h,00h,065h,00h,0ECh,0FFh,069h,00h
        db 04h,00h,06Ah,00h,04h,00h,06Bh,00h,0ECh,0FFh,06Fh,00h,04h,00h,070h,00h
        db 04h,00h,071h,00h,0ECh,0FFh,075h,00h,04h,00h,076h,00h,04h,00h,077h,00h
        db 0ECh,0FFh,07Bh,00h,04h,00h,07Ch,00h,04h,00h,07Dh,00h,0ECh,0FFh,081h,00h
        db 04h,00h,082h,00h,04h,00h,083h,00h,0ECh,0FFh,087h,00h,04h,00h,088h,00h
        db 04h,00h,089h,00h,0ECh,0FFh,08Dh,00h,04h,00h,08Eh,00h,04h,00h,08Fh,00h
        db 0ECh,0FFh,00h,00h,06h,00h,0Ch,00h,012h,00h,018h,00h,01Eh,00h,024h,00h
        db 02Ah,00h,063h,00h,04h,00h,062h,00h,04h,00h,061h,00h,0ECh,0FFh,069h,00h
        db 04h,00h,068h,00h,04h,00h,067h,00h,0ECh,0FFh,06Fh,00h,04h,00h,06Eh,00h
        db 04h,00h,06Dh,00h,0ECh,0FFh,075h,00h,04h,00h,074h,00h,04h,00h,073h,00h
        db 0ECh,0FFh,07Bh,00h,04h,00h,07Ah,00h,04h,00h,079h,00h,0ECh,0FFh,081h,00h
        db 04h,00h,080h,00h,04h,00h,07Fh,00h,0ECh,0FFh,087h,00h,04h,00h,086h,00h
        db 04h,00h,085h,00h,0ECh,0FFh,08Dh,00h,04h,00h,08Ch,00h,04h,00h,08Bh,00h
        db 0ECh,0FFh,00h,00h,012h,00h,024h,00h,036h,00h,048h,00h,05Ah,00h,06Ch,00h
        db 07Eh,00h,063h,00h,04h,00h,062h,00h,04h,00h,061h,00h,04h,00h,060h,00h
        db 04h,00h,061h,00h,04h,00h,062h,00h,04h,00h,063h,00h,04h,00h,064h,00h
        db 04h,00h,065h,00h,0ECh,0FFh,069h,00h,04h,00h,068h,00h,04h,00h,067h,00h
        db 04h,00h,066h,00h,04h,00h,067h,00h,04h,00h,068h,00h,04h,00h,069h,00h
        db 04h,00h,06Ah,00h,04h,00h,06Bh,00h,0ECh,0FFh,06Fh,00h,04h,00h,06Eh,00h
        db 04h,00h,06Dh,00h,04h,00h,06Ch,00h,04h,00h,06Dh,00h,04h,00h,06Eh,00h
        db 04h,00h,06Fh,00h,04h,00h,070h,00h,04h,00h,071h,00h,0ECh,0FFh,075h,00h
        db 04h,00h,074h,00h,04h,00h,073h,00h,04h,00h,072h,00h,04h,00h,073h,00h
        db 04h,00h,074h,00h,04h,00h,075h,00h,04h,00h,076h,00h,04h,00h,077h,00h
        db 0ECh,0FFh,07Bh,00h,04h,00h,07Ah,00h,04h,00h,079h,00h,04h,00h,078h,00h
        db 04h,00h,079h,00h,04h,00h,07Ah,00h,04h,00h,07Bh,00h,04h,00h,07Ch,00h
        db 04h,00h,07Dh,00h,0ECh,0FFh,081h,00h,04h,00h,080h,00h,04h,00h,07Fh,00h
        db 04h,00h,07Eh,00h,04h,00h,07Fh,00h,04h,00h,080h,00h,04h,00h,081h,00h
        db 04h,00h,082h,00h,04h,00h,083h,00h,0ECh,0FFh,087h,00h,04h,00h,086h,00h
        db 04h,00h,085h,00h,04h,00h,084h,00h,04h,00h,085h,00h,04h,00h,086h,00h
        db 04h,00h,087h,00h,04h,00h,088h,00h,04h,00h,089h,00h,0ECh,0FFh,08Dh,00h
        db 04h,00h,08Ch,00h,04h,00h,08Bh,00h,04h,00h,08Ah,00h,04h,00h,08Bh,00h
        db 04h,00h,08Ch,00h,04h,00h,08Dh,00h,04h,00h,08Eh,00h,04h,00h,08Fh,00h
        db 0ECh,0FFh,00h,00h,012h,00h,024h,00h,036h,00h,048h,00h,05Ah,00h,06Ch,00h
        db 07Eh,00h,063h,00h,04h,00h,064h,00h,04h,00h,065h,00h,04h,00h,065h,00h
        db 04h,00h,065h,00h,04h,00h,064h,00h,04h,00h,063h,00h,04h,00h,062h,00h
        db 04h,00h,061h,00h,0ECh,0FFh,069h,00h,04h,00h,06Ah,00h,04h,00h,06Bh,00h
        db 04h,00h,06Bh,00h,04h,00h,06Bh,00h,04h,00h,06Ah,00h,04h,00h,069h,00h
        db 04h,00h,068h,00h,04h,00h,067h,00h,0ECh,0FFh,06Fh,00h,04h,00h,070h,00h
        db 04h,00h,071h,00h,04h,00h,071h,00h,04h,00h,071h,00h,04h,00h,070h,00h
        db 04h,00h,06Fh,00h,04h,00h,06Eh,00h,04h,00h,06Dh,00h,0ECh,0FFh,075h,00h
        db 04h,00h,076h,00h,04h,00h,077h,00h,04h,00h,077h,00h,04h,00h,077h,00h
        db 04h,00h,076h,00h,04h,00h,075h,00h,04h,00h,074h,00h,04h,00h,073h,00h
        db 0ECh,0FFh,07Bh,00h,04h,00h,07Ch,00h,04h,00h,07Dh,00h,04h,00h,07Dh,00h
        db 04h,00h,07Dh,00h,04h,00h,07Ch,00h,04h,00h,07Bh,00h,04h,00h,07Ah,00h
        db 04h,00h,079h,00h,0ECh,0FFh,081h,00h,04h,00h,082h,00h,04h,00h,083h,00h
        db 04h,00h,083h,00h,04h,00h,083h,00h,04h,00h,082h,00h,04h,00h,081h,00h
        db 04h,00h,080h,00h,04h,00h,07Fh,00h,0ECh,0FFh,087h,00h,04h,00h,088h,00h
        db 04h,00h,089h,00h,04h,00h,089h,00h,04h,00h,089h,00h,04h,00h,088h,00h
        db 04h,00h,087h,00h,04h,00h,086h,00h,04h,00h,085h,00h,0ECh,0FFh,08Dh,00h
        db 04h,00h,08Eh,00h,04h,00h,08Fh,00h,04h,00h,08Fh,00h,04h,00h,08Fh,00h
        db 04h,00h,08Eh,00h,04h,00h,08Dh,00h,04h,00h,08Ch,00h,04h,00h,08Bh,00h
        db 0ECh,0FFh,00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h
        db 0Eh,00h,0A0h,00h,0F8h,0FFh,0A3h,00h,0F8h,0FFh,0A6h,00h,0F8h,0FFh,0A9h,00h
        db 0F8h,0FFh,0ACh,00h,0F8h,0FFh,0AFh,00h,0F8h,0FFh,0B2h,00h,0F8h,0FFh,0B5h,00h
        db 0F8h,0FFh,00h,00h,08h,00h,010h,00h,018h,00h,020h,00h,028h,00h,030h,00h
        db 038h,00h,0A0h,00h,0Ah,00h,0A1h,00h,0Ah,00h,0A0h,00h,0Ah,00h,0A2h,00h
        db 0F6h,0FFh,0A3h,00h,0Ah,00h,0A4h,00h,0Ah,00h,0A3h,00h,0Ah,00h,0A5h,00h
        db 0F6h,0FFh,0A6h,00h,0Ah,00h,0A7h,00h,0Ah,00h,0A6h,00h,0Ah,00h,0A8h,00h
        db 0F6h,0FFh,0A9h,00h,0Ah,00h,0AAh,00h,0Ah,00h,0A9h,00h,0Ah,00h,0ABh,00h
        db 0F6h,0FFh,0ACh,00h,0Ah,00h,0ADh,00h,0Ah,00h,0ACh,00h,0Ah,00h,0AEh,00h
        db 0F6h,0FFh,0AFh,00h,0Ah,00h,0B0h,00h,0Ah,00h,0AFh,00h,0Ah,00h,0B1h,00h
        db 0F6h,0FFh,0B2h,00h,0Ah,00h,0B3h,00h,0Ah,00h,0B2h,00h,0Ah,00h,0B4h,00h
        db 0F6h,0FFh,0B5h,00h,0Ah,00h,0B6h,00h,0Ah,00h,0B5h,00h,0Ah,00h,0B7h,00h
        db 0F6h,0FFh,00h,00h,06h,00h,0Ch,00h,012h,00h,018h,00h,01Eh,00h,024h,00h
        db 02Ah,00h,00h,01h,04h,00h,01h,01h,08h,00h,00h,01h,0FCh,0FFh,02h,01h
        db 04h,00h,03h,01h,08h,00h,02h,01h,0FCh,0FFh,04h,01h,04h,00h,05h,01h
        db 08h,00h,04h,01h,0FCh,0FFh,06h,01h,04h,00h,07h,01h,08h,00h,06h,01h
        db 0FCh,0FFh,08h,01h,04h,00h,09h,01h,08h,00h,08h,01h,0FCh,0FFh,0Ah,01h
        db 04h,00h,0Bh,01h,08h,00h,0Ah,01h,0FCh,0FFh,0Ch,01h,04h,00h,0Dh,01h
        db 08h,00h,0Ch,01h,0FCh,0FFh,0Eh,01h,04h,00h,0Fh,01h,08h,00h,0Eh,01h
        db 0FCh,0FFh,00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h
        db 0Eh,00h,0F0h,00h,0E8h,0FFh,0F1h,00h,0E8h,0FFh,0F2h,00h,0E8h,0FFh,0F3h,00h
        db 0E8h,0FFh,0F4h,00h,0E8h,0FFh,0F5h,00h,0E8h,0FFh,0F6h,00h,0E8h,0FFh,0F7h,00h
        db 0E8h,0FFh,00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h
        db 0Eh,00h,0F8h,00h,0E8h,0FFh,0F9h,00h,0E8h,0FFh,0FAh,00h,0E8h,0FFh,0FBh,00h
        db 0E8h,0FFh,0FCh,00h,0E8h,0FFh,0FDh,00h,0E8h,0FFh,0FEh,00h,0E8h,0FFh,0FFh,00h
        db 0E8h,0FFh,00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h
        db 0Eh,00h,0E0h,00h,0E8h,0FFh,0E1h,00h,0E8h,0FFh,0E2h,00h,0E8h,0FFh,0E3h,00h
        db 0E8h,0FFh,0E4h,00h,0E8h,0FFh,0E5h,00h,0E8h,0FFh,0E6h,00h,0E8h,0FFh,0E7h,00h
        db 0E8h,0FFh,00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h
        db 0Eh,00h,0E8h,00h,0E8h,0FFh,0E9h,00h,0E8h,0FFh,0EAh,00h,0E8h,0FFh,0EBh,00h
        db 0E8h,0FFh,0ECh,00h,0E8h,0FFh,0EDh,00h,0E8h,0FFh,0EEh,00h,0E8h,0FFh,0EFh,00h
        db 0E8h,0FFh,00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h
        db 0Eh,00h,028h,00h,0E8h,0FFh,02Dh,00h,0E8h,0FFh,032h,00h,0E8h,0FFh,037h,00h
        db 0E8h,0FFh,03Ch,00h,0E8h,0FFh,041h,00h,0E8h,0FFh,046h,00h,0E8h,0FFh,04Bh,00h
        db 0E8h,0FFh,00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h
        db 0Eh,00h,058h,01h,0E2h,0FFh,059h,01h,0E2h,0FFh,05Ah,01h,0E2h,0FFh,05Bh,01h
        db 0E2h,0FFh,05Ch,01h,0E2h,0FFh,05Dh,01h,0E2h,0FFh,05Eh,01h,0E2h,0FFh,05Fh,01h
        db 0E2h,0FFh,00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h
        db 0Eh,00h,058h,01h,0E2h,0FFh,059h,01h,0E2h,0FFh,05Ah,01h,0E2h,0FFh,05Bh,01h
        db 0E2h,0FFh,05Ch,01h,0E2h,0FFh,05Dh,01h,0E2h,0FFh,05Eh,01h,0E2h,0FFh,05Fh,01h
        db 0E2h,0FFh,00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h
        db 0Eh,00h,028h,00h,0E2h,0FFh,02Dh,00h,0E2h,0FFh,032h,00h,0E2h,0FFh,037h,00h
        db 0E2h,0FFh,03Ch,00h,0E2h,0FFh,041h,00h,0E2h,0FFh,046h,00h,0E2h,0FFh,04Bh,00h
        db 0E2h,0FFh,00h,00h,0Ah,00h,014h,00h,01Eh,00h,028h,00h,032h,00h,03Ch,00h
        db 046h,00h,030h,01h,06h,00h,031h,01h,06h,00h,032h,01h,064h,00h,033h,01h
        db 08h,00h,050h,01h,0F8h,0FFh,034h,01h,06h,00h,035h,01h,06h,00h,036h,01h
        db 064h,00h,037h,01h,08h,00h,051h,01h,0F8h,0FFh,038h,01h,06h,00h,039h,01h
        db 06h,00h,03Ah,01h,064h,00h,03Bh,01h,08h,00h,052h,01h,0F8h,0FFh,03Ch,01h
        db 06h,00h,03Dh,01h,06h,00h,03Eh,01h,064h,00h,03Fh,01h,08h,00h,053h,01h
        db 0F8h,0FFh,040h,01h,06h,00h,041h,01h,06h,00h,042h,01h,064h,00h,043h,01h
        db 08h,00h,054h,01h,0F8h,0FFh,044h,01h,06h,00h,045h,01h,06h,00h,046h,01h
        db 064h,00h,047h,01h,08h,00h,055h,01h,0F8h,0FFh,048h,01h,06h,00h,049h,01h
        db 06h,00h,04Ah,01h,064h,00h,04Bh,01h,08h,00h,056h,01h,0F8h,0FFh,04Ch,01h
        db 06h,00h,04Dh,01h,06h,00h,04Eh,01h,064h,00h,04Fh,01h,08h,00h,057h,01h
        db 0F8h,0FFh,00h,00h,0Ah,00h,014h,00h,01Eh,00h,028h,00h,032h,00h,03Ch,00h
        db 046h,00h,010h,01h,06h,00h,011h,01h,06h,00h,012h,01h,064h,00h,013h,01h
        db 08h,00h,050h,01h,0F8h,0FFh,014h,01h,06h,00h,015h,01h,06h,00h,016h,01h
        db 064h,00h,017h,01h,08h,00h,051h,01h,0F8h,0FFh,018h,01h,06h,00h,019h,01h
        db 06h,00h,01Ah,01h,064h,00h,01Bh,01h,08h,00h,052h,01h,0F8h,0FFh,01Ch,01h
        db 06h,00h,01Dh,01h,06h,00h,01Eh,01h,064h,00h,01Fh,01h,08h,00h,053h,01h
        db 0F8h,0FFh,020h,01h,06h,00h,021h,01h,06h,00h,022h,01h,064h,00h,023h,01h
        db 08h,00h,054h,01h,0F8h,0FFh,024h,01h,06h,00h,025h,01h,06h,00h,026h,01h
        db 064h,00h,027h,01h,08h,00h,055h,01h,0F8h,0FFh,028h,01h,06h,00h,029h,01h
        db 06h,00h,02Ah,01h,064h,00h,02Bh,01h,08h,00h,056h,01h,0F8h,0FFh,02Ch,01h
        db 06h,00h,02Dh,01h,06h,00h,02Eh,01h,064h,00h,02Fh,01h,08h,00h,057h,01h
        db 0F8h,0FFh,00h,00h,06h,00h,0Ch,00h,012h,00h,018h,00h,01Eh,00h,024h,00h
        db 02Ah,00h,0B8h,00h,0Ch,00h,0B9h,00h,028h,00h,0B8h,00h,0FBh,0FFh,0BAh,00h
        db 0Ch,00h,0BBh,00h,028h,00h,0BAh,00h,0FBh,0FFh,0BCh,00h,0Ch,00h,0BDh,00h
        db 028h,00h,0BCh,00h,0FBh,0FFh,0BEh,00h,0Ch,00h,0BFh,00h,028h,00h,0BEh,00h
        db 0FBh,0FFh,0C0h,00h,0Ch,00h,0C1h,00h,028h,00h,0C0h,00h,0FBh,0FFh,0C2h,00h
        db 0Ch,00h,0C3h,00h,028h,00h,0C2h,00h,0FBh,0FFh,0C4h,00h,0Ch,00h,0C5h,00h
        db 028h,00h,0C4h,00h,0FBh,0FFh,0C6h,00h,0Ch,00h,0C7h,00h,028h,00h,0C6h,00h
        db 0FBh,0FFh,00h,00h,06h,00h,0Ch,00h,012h,00h,018h,00h,01Eh,00h,024h,00h
        db 02Ah,00h,0C8h,00h,08h,00h,0C9h,00h,010h,00h,0C8h,00h,0F8h,0FFh,0CAh,00h
        db 08h,00h,0CBh,00h,010h,00h,0CAh,00h,0F8h,0FFh,0CCh,00h,08h,00h,0CDh,00h
        db 010h,00h,0CCh,00h,0F8h,0FFh,0CEh,00h,08h,00h,0CFh,00h,010h,00h,0CEh,00h
        db 0F8h,0FFh,0D0h,00h,08h,00h,0D1h,00h,010h,00h,0D0h,00h,0F8h,0FFh,0D2h,00h
        db 08h,00h,0D3h,00h,010h,00h,0D2h,00h,0F8h,0FFh,0D4h,00h,08h,00h,0D5h,00h
        db 010h,00h,0D4h,00h,0F8h,0FFh,0D6h,00h,08h,00h,0D7h,00h,010h,00h,0D6h,00h
        db 0F8h,0FFh,00h,00h,06h,00h,06h,00h,0Eh,00h,0Eh,00h,0Eh,00h,0Eh,00h
        db 0Eh,00h,07Ch,01h,08h,00h,07Dh,01h,08h,00h,07Eh,01h,0F8h,0FFh,078h,01h
        db 08h,00h,079h,01h,08h,00h,07Ah,01h,08h,00h,07Bh,01h,0F8h,0FFh,07Bh,01h
        db 08h,00h,07Ah,01h,08h,00h,079h,01h,08h,00h,078h,01h,0F8h,0FFh,00h,00h
        db 06h,00h,06h,00h,0Eh,00h,0Eh,00h,0Eh,00h,0Eh,00h,0Eh,00h,07Eh,01h
        db 08h,00h,07Dh,01h,08h,00h,07Ch,01h,0F8h,0FFh,07Bh,01h,08h,00h,07Ah,01h
        db 08h,00h,079h,01h,08h,00h,078h,01h,0F8h,0FFh,078h,01h,08h,00h,079h,01h
        db 08h,00h,07Ah,01h,08h,00h,07Bh,01h,0F8h,0FFh,00h,00h,06h,00h,06h,00h
        db 06h,00h,06h,00h,06h,00h,06h,00h,06h,00h,06Eh,01h,06h,00h,06Fh,01h
        db 08h,00h,070h,01h,0F8h,0FFh,069h,01h,06h,00h,06Ah,01h,08h,00h,06Bh,01h
        db 0F8h,0FFh,00h,00h,02h,00h,02h,00h,02h,00h,02h,00h,02h,00h,02h,00h
        db 02h,00h,06Dh,01h,0FBh,0FFh,068h,01h,0FBh,0FFh,00h,080h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02Ah,02h,03h,00h,02Bh,02h
        db 03h,00h,02Ch,02h,03h,00h,02Dh,02h,03h,00h,02Eh,02h,03h,00h,02Fh,02h
        db 03h,00h,030h,02h,03h,00h,031h,02h,03h,00h,032h,02h,03h,00h,033h,02h
        db 03h,00h,034h,02h,03h,00h,035h,02h,03h,00h,036h,02h,03h,00h,037h,02h
        db 0FDh,0FFh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,084h,02h,08h,00h,085h,02h,08h,00h,086h,02h,08h,00h,087h,02h
        db 08h,00h,088h,02h,018h,0FCh,00h,080h,02h,00h,04h,00h,06h,00h,08h,00h
        db 0Ah,00h,0Ch,00h,0Eh,00h,0D8h,00h,0E2h,0FFh,0D9h,00h,0E2h,0FFh,0DAh,00h
        db 0E2h,0FFh,0DBh,00h,0E2h,0FFh,0DCh,00h,0E2h,0FFh,0DDh,00h,0E2h,0FFh,0DEh,00h
        db 0E2h,0FFh,0DFh,00h,0E2h,0FFh,00h,00h,04h,00h,08h,00h,0Ch,00h,010h,00h
        db 014h,00h,018h,00h,01Ch,00h,038h,02h,06h,00h,039h,02h,0FAh,0FFh,03Ah,02h
        db 06h,00h,03Bh,02h,0FAh,0FFh,03Ch,02h,06h,00h,03Dh,02h,0FAh,0FFh,03Eh,02h
        db 06h,00h,03Fh,02h,0FAh,0FFh,040h,02h,06h,00h,041h,02h,0FAh,0FFh,042h,02h
        db 06h,00h,043h,02h,0FAh,0FFh,044h,02h,06h,00h,045h,02h,0FAh,0FFh,046h,02h
        db 06h,00h,047h,02h,0FAh,0FFh,00h,00h,02h,00h,04h,00h,06h,00h,08h,00h
        db 0Ah,00h,0Ch,00h,0Eh,00h,048h,02h,0E2h,0FFh,04Ah,02h,0E2h,0FFh,04Ch,02h
        db 0E2h,0FFh,04Eh,02h,0E2h,0FFh,050h,02h,0E2h,0FFh,052h,02h,0E2h,0FFh,054h,02h
        db 0E2h,0FFh,056h,02h,0E2h,0FFh,00h,00h,08h,00h,010h,00h,018h,00h,020h,00h
        db 028h,00h,030h,00h,038h,00h,048h,02h,09h,00h,049h,02h,09h,00h,048h,02h
        db 09h,00h,049h,02h,0F7h,0FFh,04Ah,02h,09h,00h,04Bh,02h,09h,00h,04Ah,02h
        db 09h,00h,04Bh,02h,0F7h,0FFh,04Ch,02h,09h,00h,04Dh,02h,09h,00h,04Ch,02h
        db 09h,00h,04Dh,02h,0F7h,0FFh,04Eh,02h,09h,00h,04Fh,02h,09h,00h,04Eh,02h
        db 09h,00h,04Fh,02h,0F7h,0FFh,050h,02h,09h,00h,051h,02h,09h,00h,050h,02h
        db 09h,00h,051h,02h,0F7h,0FFh,052h,02h,09h,00h,053h,02h,09h,00h,052h,02h
        db 09h,00h,053h,02h,0F7h,0FFh,054h,02h,09h,00h,055h,02h,09h,00h,054h,02h
        db 09h,00h,055h,02h,0F7h,0FFh,056h,02h,09h,00h,057h,02h,09h,00h,056h,02h
        db 09h,00h,057h,02h,0F7h,0FFh,00h,00h,0Ah,00h,014h,00h,01Eh,00h,028h,00h
        db 032h,00h,03Ch,00h,046h,00h,058h,02h,06h,00h,059h,02h,06h,00h,05Ah,02h
        db 08h,00h,059h,02h,06h,00h,058h,02h,0FAh,0FFh,05Bh,02h,06h,00h,05Ch,02h
        db 06h,00h,05Dh,02h,08h,00h,05Ch,02h,06h,00h,05Bh,02h,0FAh,0FFh,05Eh,02h
        db 06h,00h,05Fh,02h,06h,00h,060h,02h,08h,00h,05Fh,02h,06h,00h,05Eh,02h
        db 0FAh,0FFh,061h,02h,06h,00h,062h,02h,06h,00h,063h,02h,08h,00h,062h,02h
        db 06h,00h,061h,02h,0FAh,0FFh,064h,02h,06h,00h,065h,02h,06h,00h,066h,02h
        db 08h,00h,065h,02h,06h,00h,064h,02h,0FAh,0FFh,067h,02h,06h,00h,068h,02h
        db 06h,00h,069h,02h,08h,00h,068h,02h,06h,00h,067h,02h,0FAh,0FFh,06Ah,02h
        db 06h,00h,06Bh,02h,06h,00h,06Ch,02h,08h,00h,06Bh,02h,06h,00h,06Ah,02h
        db 0FAh,0FFh,06Dh,02h,06h,00h,06Eh,02h,06h,00h,06Fh,02h,08h,00h,06Eh,02h
        db 06h,00h,06Dh,02h,0FAh,0FFh,00h,00h,0Ch,00h,018h,00h,024h,00h,030h,00h
        db 03Ch,00h,048h,00h,054h,00h,050h,00h,04h,00h,057h,00h,04h,00h,0Ch,01h
        db 014h,00h,05Fh,00h,04h,00h,058h,00h,04h,00h,059h,00h,0FCh,0FFh,051h,00h
        db 04h,00h,050h,00h,04h,00h,0Eh,01h,014h,00h,058h,00h,04h,00h,059h,00h
        db 04h,00h,05Ah,00h,0FCh,0FFh,052h,00h,04h,00h,051h,00h,04h,00h,00h,01h
        db 014h,00h,059h,00h,04h,00h,05Ah,00h,04h,00h,05Bh,00h,0FCh,0FFh,053h,00h
        db 04h,00h,052h,00h,04h,00h,02h,01h,014h,00h,05Ah,00h,04h,00h,05Bh,00h
        db 04h,00h,05Ch,00h,0FCh,0FFh,054h,00h,04h,00h,053h,00h,04h,00h,04h,01h
        db 014h,00h,05Bh,00h,04h,00h,05Ch,00h,04h,00h,05Dh,00h,0FCh,0FFh,055h,00h
        db 04h,00h,054h,00h,04h,00h,06h,01h,014h,00h,05Ch,00h,04h,00h,05Dh,00h
        db 04h,00h,05Eh,00h,0FCh,0FFh,056h,00h,04h,00h,055h,00h,04h,00h,08h,01h
        db 014h,00h,05Dh,00h,04h,00h,05Eh,00h,04h,00h,05Fh,00h,0FCh,0FFh,057h,00h
        db 04h,00h,056h,00h,04h,00h,0Ah,01h,014h,00h,05Eh,00h,04h,00h,05Fh,00h
        db 04h,00h,058h,00h,0FCh,0FFh,00h,00h,0Eh,00h,01Ch,00h,02Ah,00h,038h,00h
        db 046h,00h,054h,00h,062h,00h,070h,02h,06h,00h,071h,02h,06h,00h,072h,02h
        db 06h,00h,073h,02h,06h,00h,012h,01h,064h,00h,013h,01h,08h,00h,050h,01h
        db 0F8h,0FFh,070h,02h,06h,00h,071h,02h,06h,00h,072h,02h,06h,00h,073h,02h
        db 06h,00h,016h,01h,064h,00h,017h,01h,08h,00h,051h,01h,0F8h,0FFh,070h,02h
        db 06h,00h,071h,02h,06h,00h,072h,02h,06h,00h,073h,02h,06h,00h,01Ah,01h
        db 064h,00h,01Bh,01h,08h,00h,052h,01h,0F8h,0FFh,074h,02h,06h,00h,075h,02h
        db 06h,00h,076h,02h,06h,00h,077h,02h,06h,00h,01Eh,01h,064h,00h,01Fh,01h
        db 08h,00h,053h,01h,0F8h,0FFh,074h,02h,06h,00h,075h,02h,06h,00h,076h,02h
        db 06h,00h,077h,02h,06h,00h,022h,01h,064h,00h,023h,01h,08h,00h,054h,01h
        db 0F8h,0FFh,074h,02h,06h,00h,075h,02h,06h,00h,076h,02h,06h,00h,077h,02h
        db 06h,00h,026h,01h,064h,00h,027h,01h,08h,00h,055h,01h,0F8h,0FFh,074h,02h
        db 06h,00h,075h,02h,06h,00h,076h,02h,06h,00h,077h,02h,06h,00h,02Ah,01h
        db 064h,00h,02Bh,01h,08h,00h,056h,01h,0F8h,0FFh,070h,02h,06h,00h,071h,02h
        db 06h,00h,072h,02h,06h,00h,073h,02h,06h,00h,02Eh,01h,064h,00h,02Fh,01h
        db 08h,00h,057h,01h,0F8h,0FFh,00h,00h,00h,00h,00h,00h,024h,00h,024h,00h
        db 024h,00h,024h,00h,00h,00h,010h,01h,06h,00h,011h,01h,06h,00h,012h,01h
        db 01Eh,00h,078h,02h,0Ah,00h,079h,02h,0Ah,00h,07Ah,02h,0Ah,00h,07Bh,02h
        db 08h,00h,07Ch,02h,08h,00h,07Dh,02h,08h,00h,07Bh,02h,08h,00h,07Ch,02h
        db 08h,00h,07Dh,02h,08h,00h,07Bh,02h,08h,00h,07Ch,02h,08h,00h,07Dh,02h
        db 08h,00h,07Bh,02h,08h,00h,07Ch,02h,08h,00h,07Dh,02h,0ACh,0F4h,020h,01h
        db 06h,00h,021h,01h,06h,00h,022h,01h,01Eh,00h,07Eh,02h,0Ah,00h,07Fh,02h
        db 0Ah,00h,080h,02h,0Ah,00h,081h,02h,08h,00h,082h,02h,08h,00h,083h,02h
        db 08h,00h,081h,02h,08h,00h,082h,02h,08h,00h,083h,02h,08h,00h,081h,02h
        db 08h,00h,082h,02h,08h,00h,083h,02h,08h,00h,081h,02h,08h,00h,082h,02h
        db 08h,00h,083h,02h,0ACh,0F4h,00h,00h,02h,00h,04h,00h,06h,00h,08h,00h
        db 0Ah,00h,0Ch,00h,0Eh,00h,08Ah,02h,0F8h,0FFh,0ADh,02h,0F8h,0FFh,0A8h,02h
        db 0F8h,0FFh,0A3h,02h,0F8h,0FFh,09Eh,02h,0F8h,0FFh,099h,02h,0F8h,0FFh,094h,02h
        db 0F8h,0FFh,08Fh,02h,0F8h,0FFh,00h,00h,08h,00h,010h,00h,018h,00h,020h,00h
        db 028h,00h,030h,00h,038h,00h,08Dh,02h,0Ah,00h,08Eh,02h,0Ah,00h,08Bh,02h
        db 0Ah,00h,08Ch,02h,0F6h,0FFh,0B0h,02h,0Ah,00h,0B1h,02h,0Ah,00h,0AEh,02h
        db 0Ah,00h,0AFh,02h,0F6h,0FFh,0ABh,02h,0Ah,00h,0ACh,02h,0Ah,00h,0A9h,02h
        db 0Ah,00h,0AAh,02h,0F6h,0FFh,0A6h,02h,0Ah,00h,0A7h,02h,0Ah,00h,0A4h,02h
        db 0Ah,00h,0A5h,02h,0F6h,0FFh,0A1h,02h,0Ah,00h,0A2h,02h,0Ah,00h,09Fh,02h
        db 0Ah,00h,0A0h,02h,0F6h,0FFh,09Ch,02h,0Ah,00h,09Dh,02h,0Ah,00h,09Ah,02h
        db 0Ah,00h,09Bh,02h,0F6h,0FFh,097h,02h,0Ah,00h,098h,02h,0Ah,00h,095h,02h
        db 0Ah,00h,096h,02h,0F6h,0FFh,092h,02h,0Ah,00h,093h,02h,0Ah,00h,090h,02h
        db 0Ah,00h,091h,02h,0F6h,0FFh,00h,00h,02h,00h,04h,00h,06h,00h,08h,00h
        db 0Ah,00h,0Ch,00h,0Eh,00h,0F3h,02h,0F8h,0FFh,0F4h,02h,0F8h,0FFh,0F5h,02h
        db 0F8h,0FFh,0F6h,02h,0F8h,0FFh,0F7h,02h,0F8h,0FFh,0F8h,02h,0F8h,0FFh,0F9h,02h
        db 0F8h,0FFh,0FAh,02h,0F8h,0FFh,00h,00h,02h,00h,04h,00h,06h,00h,08h,00h
        db 0Ah,00h,0Ch,00h,0Eh,00h,0FBh,02h,0F8h,0FFh,0FCh,02h,0F8h,0FFh,0FDh,02h
        db 0F8h,0FFh,0FEh,02h,0F8h,0FFh,0FFh,02h,0F8h,0FFh,00h,03h,0F8h,0FFh,01h,03h
        db 0F8h,0FFh,02h,03h,0F8h,0FFh,00h,080h,04h,00h,08h,00h,0Ch,00h,010h,00h
        db 014h,00h,018h,00h,01Ch,00h,03h,03h,04h,00h,04h,03h,0FCh,0FFh,05h,03h
        db 04h,00h,06h,03h,0FCh,0FFh,07h,03h,04h,00h,08h,03h,0FCh,0FFh,09h,03h
        db 04h,00h,0Ah,03h,0FCh,0FFh,0Bh,03h,04h,00h,0Ch,03h,0FCh,0FFh,0Dh,03h
        db 04h,00h,0Eh,03h,0FCh,0FFh,0Fh,03h,04h,00h,010h,03h,0FCh,0FFh,011h,03h
        db 04h,00h,012h,03h,0FCh,0FFh,00h,00h,06h,00h,0Ch,00h,012h,00h,018h,00h
        db 01Eh,00h,024h,00h,02Ah,00h,013h,03h,0Ah,00h,014h,03h,01Ch,00h,015h,03h
        db 0F6h,0FFh,016h,03h,0Ah,00h,017h,03h,01Ch,00h,018h,03h,0F6h,0FFh,019h,03h
        db 0Ah,00h,01Ah,03h,01Ch,00h,01Bh,03h,0F6h,0FFh,01Ch,03h,0Ah,00h,01Dh,03h
        db 01Ch,00h,01Eh,03h,0F6h,0FFh,01Fh,03h,0Ah,00h,020h,03h,01Ch,00h,021h,03h
        db 0F6h,0FFh,022h,03h,0Ah,00h,023h,03h,01Ch,00h,024h,03h,0F6h,0FFh,025h,03h
        db 0Ah,00h,026h,03h,01Ch,00h,027h,03h,0F6h,0FFh,028h,03h,0Ah,00h,029h,03h
        db 01Ch,00h,02Ah,03h,0F6h,0FFh,00h,00h,02h,00h,04h,00h,06h,00h,08h,00h
        db 0Ah,00h,0Ch,00h,0Eh,00h,0CBh,02h,0F8h,0FFh,0EEh,02h,0F8h,0FFh,0E9h,02h
        db 0F8h,0FFh,0E4h,02h,0F8h,0FFh,0E1h,02h,0F8h,0FFh,0DAh,02h,0F8h,0FFh,0D5h,02h
        db 0F8h,0FFh,0D0h,02h,0F8h,0FFh,00h,00h,08h,00h,010h,00h,018h,00h,020h,00h
        db 028h,00h,030h,00h,038h,00h,0CEh,02h,0Ah,00h,0CFh,02h,0Ah,00h,0CCh,02h
        db 0Ah,00h,0CDh,02h,0F6h,0FFh,0F1h,02h,0Ah,00h,0F2h,02h,0Ah,00h,0F0h,02h
        db 0Ah,00h,0EFh,02h,0F6h,0FFh,0ECh,02h,0Ah,00h,0EDh,02h,0Ah,00h,0EAh,02h
        db 0Ah,00h,0EBh,02h,0F6h,0FFh,0E7h,02h,0Ah,00h,0E8h,02h,0Ah,00h,0E5h,02h
        db 0Ah,00h,0E6h,02h,0F6h,0FFh,0E2h,02h,0Ah,00h,0DFh,02h,0Ah,00h,0E0h,02h
        db 0Ah,00h,0E3h,02h,0F6h,0FFh,0DDh,02h,0Ah,00h,0DEh,02h,0Ah,00h,0DBh,02h
        db 0Ah,00h,0DCh,02h,0F6h,0FFh,0D8h,02h,0Ah,00h,0D9h,02h,0Ah,00h,0D6h,02h
        db 0Ah,00h,0D7h,02h,0F6h,0FFh,0D3h,02h,0Ah,00h,0D4h,02h,0Ah,00h,0D1h,02h
        db 0Ah,00h,0D2h,02h,0F6h,0FFh,00h,00h,02h,00h,04h,00h,06h,00h,08h,00h
        db 0Ah,00h,0Ch,00h,0Eh,00h,02Bh,03h,0F8h,0FFh,02Ch,03h,0F8h,0FFh,02Dh,03h
        db 0F8h,0FFh,02Eh,03h,0F8h,0FFh,02Fh,03h,0F8h,0FFh,030h,03h,0F8h,0FFh,031h,03h
        db 0F8h,0FFh,032h,03h,0F8h,0FFh,00h,00h,02h,00h,04h,00h,06h,00h,08h,00h
        db 0Ah,00h,0Ch,00h,0Eh,00h,033h,03h,0F8h,0FFh,034h,03h,0F8h,0FFh,035h,03h
        db 0F8h,0FFh,036h,03h,0F8h,0FFh,037h,03h,0F8h,0FFh,038h,03h,0F8h,0FFh,039h,03h
        db 0F8h,0FFh,03Ah,03h,0F8h,0FFh,00h,080h,04h,00h,08h,00h,0Ch,00h,010h,00h
        db 014h,00h,018h,00h,01Ch,00h,03Bh,03h,04h,00h,03Ch,03h,0FCh,0FFh,03Dh,03h
        db 04h,00h,03Eh,03h,0FCh,0FFh,03Fh,03h,04h,00h,040h,03h,0FCh,0FFh,041h,03h
        db 04h,00h,042h,03h,0FCh,0FFh,043h,03h,04h,00h,044h,03h,0FCh,0FFh,045h,03h
        db 04h,00h,046h,03h,0FCh,0FFh,047h,03h,04h,00h,048h,03h,0FCh,0FFh,049h,03h
        db 04h,00h,04Ah,03h,0FCh,0FFh,00h,00h,02h,00h,04h,00h,06h,00h,08h,00h
        db 0Ah,00h,0Ch,00h,0Eh,00h,0B3h,02h,0F4h,0FFh,0BAh,02h,0F4h,0FFh,0B9h,02h
        db 0F4h,0FFh,0B8h,02h,0F4h,0FFh,0B7h,02h,0F4h,0FFh,0B6h,02h,0F4h,0FFh,0B5h,02h
        db 0F4h,0FFh,0B4h,02h,0F4h,0FFh,00h,00h,04h,00h,08h,00h,0Ch,00h,010h,00h
        db 014h,00h,018h,00h,01Ch,00h,0BBh,02h,08h,00h,0BCh,02h,0E8h,0FFh,0BDh,02h
        db 08h,00h,0BEh,02h,0E8h,0FFh,0BFh,02h,08h,00h,0C0h,02h,0E8h,0FFh,0C1h,02h
        db 08h,00h,0C2h,02h,0E8h,0FFh,0C3h,02h,08h,00h,0C4h,02h,0E8h,0FFh,0C5h,02h
        db 08h,00h,0C6h,02h,0E8h,0FFh,0C7h,02h,08h,00h,0C8h,02h,0E8h,0FFh,0C9h,02h
        db 08h,00h,0CAh,02h,0E8h,0FFh,00h,00h,00h,00h,00h,00h,06h,00h,06h,00h
        db 06h,00h,06h,00h,00h,00h,04Bh,03h,08h,00h,04Ch,03h,08h,00h,0BFh,02h
        db 0F8h,0FFh,04Dh,03h,08h,00h,04Eh,03h,08h,00h,0C7h,02h,0F8h,0FFh,00h,00h
        db 00h,00h,00h,00h,02h,00h,02h,00h,02h,00h,02h,00h,00h,00h,0BFh,02h
        db 0F8h,0FFh,0C7h,02h,0F8h,0FFh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,04Fh,03h,0Ch,00h,05Bh,03h,0Ch,00h,05Ch,03h
        db 018h,00h,04Fh,03h,0F4h,0FFh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,04Fh,03h,0Ch,00h,05Fh,03h,0Ch,00h,060h,03h
        db 0Ch,00h,061h,03h,0Ch,00h,05Fh,03h,0Ch,00h,060h,03h,0Ch,00h,061h,03h
        db 0Ch,00h,04Fh,03h,0F4h,0FFh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,04Fh,03h,0Ch,00h,054h,03h,0Ch,00h,055h,03h
        db 018h,00h,04Fh,03h,0F4h,0FFh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,04Fh,03h,0Ch,00h,056h,03h,0Ch,00h,057h,03h
        db 018h,00h,04Fh,03h,0F4h,0FFh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,04Fh,03h,0Ch,00h,052h,03h,0Ch,00h,053h,03h
        db 018h,00h,04Fh,03h,0F4h,0FFh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,04Fh,03h,0Ch,00h,05Dh,03h,0Ch,00h,05Eh,03h
        db 018h,00h,04Fh,03h,0F4h,0FFh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,04Fh,03h,0Ch,00h,059h,03h,030h,00h,04Fh,03h
        db 0F4h,0FFh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,04Fh,03h,0Ch,00h,058h,03h,030h,00h,04Fh,03h,0F4h,0FFh,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,04Fh,03h
        db 0Ch,00h,05Ah,03h,030h,00h,04Fh,03h,0F4h,0FFh,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,04Fh,03h,0Ch,00h,050h,03h
        db 0Ch,00h,051h,03h,018h,00h,04Fh,03h,0F4h,0FFh,00h,00h,04h,00h,04h,00h
        db 04h,00h,04h,00h,04h,00h,04h,00h,04h,00h,06Eh,01h,06h,00h,06Fh,01h
        db 0F8h,0FFh,069h,01h,06h,00h,06Ah,01h,0F8h,0FFh,00h,00h,00h,00h,00h,00h
        db 00h,00h,08h,00h,08h,00h,08h,00h,08h,00h,074h,01h,08h,00h,075h,01h
        db 08h,00h,076h,01h,08h,00h,077h,01h,0F8h,0FFh,077h,01h,08h,00h,076h,01h
        db 08h,00h,075h,01h,08h,00h,074h,01h,0F8h,0FFh,00h,00h,00h,00h,00h,00h
        db 00h,00h,08h,00h,08h,00h,08h,00h,08h,00h,077h,01h,08h,00h,076h,01h
        db 08h,00h,075h,01h,08h,00h,074h,01h,0F8h,0FFh,074h,01h,08h,00h,075h,01h
        db 08h,00h,076h,01h,08h,00h,077h,01h,0F8h,0FFh,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,071h,01h,01Eh,00h,072h,01h
        db 01Eh,00h,073h,01h,01Eh,00h,072h,01h,01Eh,00h,071h,01h,0C4h,0FFh,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,071h,01h
        db 01Eh,00h,072h,01h,01Eh,00h,073h,01h,01Eh,00h,071h,01h,0C4h,0FFh,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,071h,01h
        db 01Eh,00h,072h,01h,01Eh,00h,073h,01h,01Eh,00h,072h,01h,01Eh,00h,073h,01h
        db 01Eh,00h,071h,01h,0C4h,0FFh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,071h,01h,01Eh,00h,07Ch,01h,02Dh,00h,071h,01h
        db 0C4h,0FFh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,071h,01h,01Eh,00h,07Dh,01h,02Dh,00h,071h,01h,0C4h,0FFh,00h,00h
        db 00h,00h,00h,00h,00h,00h,06h,00h,06h,00h,06h,00h,06h,00h,0BBh,02h
        db 01Eh,00h,0BCh,02h,02Dh,00h,0BBh,02h,0E2h,0FFh,0BDh,02h,01Eh,00h,0BEh,02h
        db 02Dh,00h,0BDh,02h,0E2h,0FFh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,089h,02h,01Eh,00h,0C1h,02h,01Eh,00h,0C2h,02h
        db 01Eh,00h,0C3h,02h,01Eh,00h,0C2h,02h,01Eh,00h,0C3h,02h,01Eh,00h,0C1h,02h
        db 01Eh,00h,089h,02h,0E2h,0FFh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,089h,02h,01Eh,00h,0B2h,02h,01Eh,00h,0C1h,02h
        db 01Eh,00h,089h,02h,0E2h,0FFh,00h,00h,0Ah,00h,014h,00h,01Eh,00h,028h,00h
        db 032h,00h,03Ch,00h,046h,00h,061h,00h,018h,00h,062h,00h,04h,00h,063h,00h
        db 04h,00h,064h,00h,04h,00h,065h,00h,0ECh,0FFh,067h,00h,018h,00h,068h,00h
        db 04h,00h,069h,00h,04h,00h,06Ah,00h,04h,00h,06Bh,00h,0ECh,0FFh,06Dh,00h
        db 018h,00h,06Eh,00h,04h,00h,06Fh,00h,04h,00h,070h,00h,04h,00h,071h,00h
        db 0ECh,0FFh,073h,00h,018h,00h,074h,00h,04h,00h,075h,00h,04h,00h,076h,00h
        db 04h,00h,077h,00h,0ECh,0FFh,079h,00h,018h,00h,07Ah,00h,04h,00h,07Bh,00h
        db 04h,00h,07Ch,00h,04h,00h,07Dh,00h,0ECh,0FFh,07Fh,00h,018h,00h,080h,00h
        db 04h,00h,081h,00h,04h,00h,082h,00h,04h,00h,083h,00h,0ECh,0FFh,085h,00h
        db 018h,00h,086h,00h,04h,00h,087h,00h,04h,00h,088h,00h,04h,00h,089h,00h
        db 0ECh,0FFh,08Bh,00h,018h,00h,08Ch,00h,04h,00h,08Dh,00h,04h,00h,08Eh,00h
        db 04h,00h,08Fh,00h,0ECh,0FFh,00h,00h,0Ah,00h,014h,00h,01Eh,00h,028h,00h
        db 032h,00h,03Ch,00h,046h,00h,065h,00h,018h,00h,064h,00h,04h,00h,063h,00h
        db 04h,00h,062h,00h,04h,00h,061h,00h,0ECh,0FFh,06Bh,00h,018h,00h,06Ah,00h
        db 04h,00h,069h,00h,04h,00h,068h,00h,04h,00h,067h,00h,0ECh,0FFh,071h,00h
        db 018h,00h,070h,00h,04h,00h,06Fh,00h,04h,00h,06Eh,00h,04h,00h,06Dh,00h
        db 0ECh,0FFh,077h,00h,018h,00h,076h,00h,04h,00h,075h,00h,04h,00h,074h,00h
        db 04h,00h,073h,00h,0ECh,0FFh,07Dh,00h,018h,00h,07Ch,00h,04h,00h,07Bh,00h
        db 04h,00h,07Ah,00h,04h,00h,079h,00h,0ECh,0FFh,083h,00h,018h,00h,082h,00h
        db 04h,00h,081h,00h,04h,00h,080h,00h,04h,00h,07Fh,00h,0ECh,0FFh,089h,00h
        db 018h,00h,088h,00h,04h,00h,087h,00h,04h,00h,086h,00h,04h,00h,085h,00h
        db 0ECh,0FFh,08Fh,00h,018h,00h,08Eh,00h,04h,00h,08Dh,00h,04h,00h,08Ch,00h
        db 04h,00h,08Bh,00h,0ECh,0FFh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,065h,01h,010h,00h,066h,01h,010h,00h,068h,03h
        db 020h,00h,066h,01h,0Ch,00h,069h,03h,0Ch,00h,0DCh,00h,0E0h,0FFh,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,062h,03h
        db 0Ch,00h,063h,03h,0Ch,00h,062h,03h,0Ch,00h,063h,03h,0Ch,00h,064h,03h
        db 0FCh,0FFh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,064h,03h,011h,00h,065h,03h,0F4h,0FFh,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,067h,03h,0Ch,00h,066h,03h
        db 0Ch,00h,067h,03h,0Ch,00h,066h,03h,0Ch,00h,067h,03h,0Ch,00h,066h,03h
        db 0Ch,00h,065h,03h,0F4h,0FFh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,06Ah,03h,0Ch,00h,06Bh,03h,0F4h,0FFh,00h,00h
        db 06h,00h,0Ch,00h,012h,00h,018h,00h,01Eh,00h,024h,00h,02Ah,00h,078h,03h
        db 05h,00h,079h,03h,0Ah,00h,078h,03h,0FAh,0FFh,07Ah,03h,05h,00h,07Bh,03h
        db 0Ah,00h,07Ah,03h,0FAh,0FFh,07Ch,03h,05h,00h,07Dh,03h,0Ah,00h,07Ch,03h
        db 0FAh,0FFh,07Eh,03h,05h,00h,07Fh,03h,0Ah,00h,07Eh,03h,0FAh,0FFh,080h,03h
        db 05h,00h,081h,03h,0Ah,00h,080h,03h,0FAh,0FFh,082h,03h,05h,00h,083h,03h
        db 0Ah,00h,082h,03h,0FAh,0FFh,084h,03h,05h,00h,085h,03h,0Ah,00h,084h,03h
        db 0FAh,0FFh,086h,03h,05h,00h,087h,03h,0Ah,00h,086h,03h,0FAh,0FFh,00h,00h
        db 00h,00h,0Ch,00h,016h,00h,020h,00h,02Ah,00h,034h,00h,034h,00h,0B1h,03h
        db 0Ah,00h,089h,03h,0Ah,00h,011h,01h,0Ah,00h,012h,01h,037h,00h,013h,01h
        db 0Ah,00h,050h,01h,0F6h,0FFh,0B4h,03h,0Ah,00h,098h,03h,0Ah,00h,099h,03h
        db 041h,00h,09Ah,03h,0Ah,00h,09Bh,03h,0F6h,0FFh,097h,03h,0Ah,00h,098h,03h
        db 0Ah,00h,099h,03h,041h,00h,09Ah,03h,0Ah,00h,09Bh,03h,0F6h,0FFh,09Ch,03h
        db 0Ah,00h,09Dh,03h,0Ah,00h,09Eh,03h,041h,00h,09Fh,03h,0Ah,00h,0A0h,03h
        db 0F6h,0FFh,0A1h,03h,0Ah,00h,0A2h,03h,0Ah,00h,0A3h,03h,041h,00h,0A4h,03h
        db 0Ah,00h,0A5h,03h,0F6h,0FFh,0BAh,03h,0Ah,00h,0A2h,03h,0Ah,00h,0A3h,03h
        db 041h,00h,0A4h,03h,0Ah,00h,0A5h,03h,0F6h,0FFh,00h,00h,0Ah,00h,014h,00h
        db 01Eh,00h,01Eh,00h,01Eh,00h,02Ah,00h,034h,00h,088h,03h,0Ah,00h,089h,03h
        db 0Ah,00h,08Ah,03h,041h,00h,08Bh,03h,0Ah,00h,08Ch,03h,0F6h,0FFh,092h,03h
        db 0Ah,00h,093h,03h,0Ah,00h,094h,03h,041h,00h,095h,03h,0Ah,00h,096h,03h
        db 0F6h,0FFh,0B5h,03h,0Ah,00h,093h,03h,0Ah,00h,094h,03h,041h,00h,095h,03h
        db 0Ah,00h,096h,03h,0F6h,0FFh,0B6h,03h,0Ah,00h,09Dh,03h,0Ah,00h,021h,01h
        db 0Ah,00h,022h,01h,037h,00h,023h,01h,0Ah,00h,054h,01h,0F6h,0FFh,0BBh,03h
        db 0Ah,00h,0ACh,03h,0Ah,00h,0ADh,03h,041h,00h,0AEh,03h,0Ah,00h,0AFh,03h
        db 0F6h,0FFh,0ABh,03h,0Ah,00h,0ACh,03h,0Ah,00h,0ADh,03h,041h,00h,0AEh,03h
        db 0Ah,00h,0AFh,03h,0F6h,0FFh,00h,00h,0Ah,00h,0Ah,00h,0Ah,00h,016h,00h
        db 020h,00h,02Ah,00h,034h,00h,0B0h,03h,0Ah,00h,0ACh,03h,0Ah,00h,0ADh,03h
        db 041h,00h,0AEh,03h,0Ah,00h,0AFh,03h,0F6h,0FFh,0B3h,03h,0Ah,00h,08Eh,03h
        db 0Ah,00h,019h,01h,0Ah,00h,01Ah,01h,037h,00h,01Bh,01h,0Ah,00h,052h,01h
        db 0F6h,0FFh,0B7h,03h,0Ah,00h,0A2h,03h,0Ah,00h,0A3h,03h,041h,00h,0A4h,03h
        db 0Ah,00h,0A5h,03h,0F6h,0FFh,0A1h,03h,0Ah,00h,0A2h,03h,0Ah,00h,0A3h,03h
        db 041h,00h,0A4h,03h,0Ah,00h,0A5h,03h,0F6h,0FFh,0A6h,03h,0Ah,00h,0A7h,03h
        db 0Ah,00h,0A8h,03h,041h,00h,0A9h,03h,0Ah,00h,0AAh,03h,0F6h,0FFh,0ABh,03h
        db 0Ah,00h,0ACh,03h,0Ah,00h,0ADh,03h,041h,00h,0AEh,03h,0Ah,00h,0AFh,03h
        db 0F6h,0FFh,00h,00h,0Ah,00h,014h,00h,01Eh,00h,028h,00h,032h,00h,032h,00h
        db 032h,00h,0B2h,03h,0Ah,00h,093h,03h,0Ah,00h,094h,03h,041h,00h,095h,03h
        db 0Ah,00h,096h,03h,0F6h,0FFh,092h,03h,0Ah,00h,093h,03h,0Ah,00h,094h,03h
        db 041h,00h,095h,03h,0Ah,00h,096h,03h,0F6h,0FFh,08Dh,03h,0Ah,00h,08Eh,03h
        db 0Ah,00h,08Fh,03h,041h,00h,090h,03h,0Ah,00h,091h,03h,0F6h,0FFh,097h,03h
        db 0Ah,00h,098h,03h,0Ah,00h,099h,03h,041h,00h,09Ah,03h,0Ah,00h,09Bh,03h
        db 0F6h,0FFh,0B8h,03h,0Ah,00h,098h,03h,0Ah,00h,099h,03h,041h,00h,09Ah,03h
        db 0Ah,00h,09Bh,03h,0F6h,0FFh,0B9h,03h,0Ah,00h,0A7h,03h,0Ah,00h,029h,01h
        db 0Ah,00h,02Ah,01h,037h,00h,02Bh,01h,0Ah,00h,056h,01h,0F6h,0FFh,00h,00h
        db 00h,00h,0Ah,00h,0Ah,00h,012h,00h,012h,00h,01Ch,00h,01Ch,00h,0B0h,03h
        db 0Ah,00h,06Ch,03h,0Ah,00h,06Dh,03h,0Ah,00h,06Eh,03h,0Ah,00h,06Fh,03h
        db 0D8h,0FFh,0B3h,03h,0Ah,00h,0C8h,03h,0Ah,00h,0C9h,03h,0Ah,00h,0CAh,03h
        db 0D8h,0FFh,0B7h,03h,0Ah,00h,0C0h,03h,0Ah,00h,0C1h,03h,0Ah,00h,0C2h,03h
        db 0Ah,00h,0C3h,03h,0D8h,0FFh,0BBh,03h,0Ah,00h,0BCh,03h,0Ah,00h,0BDh,03h
        db 0Ah,00h,0BEh,03h,0Ah,00h,0BFh,03h,0D8h,0FFh,00h,00h,00h,00h,0Ah,00h
        db 0Ah,00h,014h,00h,014h,00h,01Eh,00h,01Eh,00h,0B2h,03h,0Ah,00h,070h,03h
        db 0Ah,00h,071h,03h,0Ah,00h,072h,03h,0Ah,00h,073h,03h,0D8h,0FFh,0B5h,03h
        db 0Ah,00h,074h,03h,0Ah,00h,075h,03h,0Ah,00h,076h,03h,0Ah,00h,077h,03h
        db 0D8h,0FFh,0B8h,03h,0Ah,00h,0C4h,03h,0Ah,00h,0C5h,03h,0Ah,00h,0C6h,03h
        db 0Ah,00h,0C7h,03h,0D8h,0FFh,0B9h,03h,0Ah,00h,0CBh,03h,0Ah,00h,0CCh,03h
        db 0Ah,00h,0CDh,03h,0D8h,0FFh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,04Fh,03h,0Ch,00h,0C7h,02h,0Ch,00h,0C8h,02h
        db 018h,00h,0C7h,02h,08h,00h,04Fh,03h,0F4h,0FFh,00h,00h,06h,00h,0Ch,00h
        db 012h,00h,018h,00h,01Eh,00h,024h,00h,02Ah,00h,0D2h,03h,04h,00h,0D3h,03h
        db 0Fh,00h,0D2h,03h,0FAh,0FFh,0D4h,03h,04h,00h,0D5h,03h,0Fh,00h,0D4h,03h
        db 0FAh,0FFh,0D6h,03h,04h,00h,0D7h,03h,0Fh,00h,0D6h,03h,0FAh,0FFh,0D8h,03h
        db 04h,00h,0D9h,03h,0Fh,00h,0D8h,03h,0FAh,0FFh,0DAh,03h,04h,00h,0DBh,03h
        db 0Fh,00h,0DAh,03h,0FAh,0FFh,0DCh,03h,04h,00h,0DDh,03h,0Fh,00h,0DCh,03h
        db 0FAh,0FFh,0DEh,03h,04h,00h,0DFh,03h,0Fh,00h,0DEh,03h,0FAh,0FFh,0E0h,03h
        db 04h,00h,0E1h,03h,0Fh,00h,0E0h,03h,0FAh,0FFh,00h,00h,0Ch,00h,018h,00h
        db 024h,00h,030h,00h,03Ch,00h,048h,00h,054h,00h,0E2h,03h,06h,00h,0E3h,03h
        db 06h,00h,0E4h,03h,014h,00h,0E3h,03h,06h,00h,0E2h,03h,06h,00h,096h,01h
        db 0F8h,0FFh,0E5h,03h,06h,00h,0E6h,03h,06h,00h,0E7h,03h,014h,00h,0E6h,03h
        db 06h,00h,0E5h,03h,06h,00h,099h,01h,0F8h,0FFh,09Ch,01h,06h,00h,0E8h,03h
        db 06h,00h,0E9h,03h,014h,00h,0E8h,03h,06h,00h,09Ch,01h,04h,00h,09Ch,01h
        db 0FCh,0FFh,09Fh,01h,06h,00h,0EAh,03h,06h,00h,0EBh,03h,014h,00h,0EAh,03h
        db 06h,00h,09Fh,01h,04h,00h,09Fh,01h,0FCh,0FFh,0A2h,01h,06h,00h,0ECh,03h
        db 06h,00h,0EDh,03h,014h,00h,0ECh,03h,06h,00h,0A2h,01h,04h,00h,0A2h,01h
        db 0FCh,0FFh,0A5h,01h,06h,00h,0EEh,03h,06h,00h,0EFh,03h,014h,00h,0EEh,03h
        db 06h,00h,0A5h,01h,04h,00h,0A5h,01h,0FCh,0FFh,0A8h,01h,06h,00h,0F0h,03h
        db 06h,00h,0F1h,03h,014h,00h,0F0h,03h,06h,00h,0A8h,01h,04h,00h,0A8h,01h
        db 0FCh,0FFh,0ABh,01h,06h,00h,0F2h,03h,06h,00h,0F3h,03h,014h,00h,0F2h,03h
        db 06h,00h,0ABh,01h,04h,00h,0ABh,01h,0FCh,0FFh,00h,00h,0Ch,00h,018h,00h
        db 024h,00h,030h,00h,03Ch,00h,048h,00h,054h,00h,0E2h,03h,06h,00h,0E3h,03h
        db 06h,00h,0E4h,03h,05Ah,00h,0E3h,03h,06h,00h,0E2h,03h,06h,00h,096h,01h
        db 0FCh,0FFh,0E5h,03h,06h,00h,0E6h,03h,06h,00h,0E7h,03h,05Ah,00h,0E6h,03h
        db 06h,00h,0E5h,03h,06h,00h,099h,01h,0FCh,0FFh,09Ch,01h,06h,00h,0E8h,03h
        db 06h,00h,0E9h,03h,05Ah,00h,0E8h,03h,06h,00h,09Ch,01h,06h,00h,09Ch,01h
        db 0FCh,0FFh,09Fh,01h,06h,00h,0EAh,03h,06h,00h,0EBh,03h,05Ah,00h,0EAh,03h
        db 06h,00h,09Fh,01h,06h,00h,09Fh,01h,0FCh,0FFh,0A2h,01h,06h,00h,0ECh,03h
        db 06h,00h,0EDh,03h,05Ah,00h,0ECh,03h,06h,00h,0A2h,01h,06h,00h,0A2h,01h
        db 0FCh,0FFh,0A5h,01h,06h,00h,0EEh,03h,06h,00h,0EFh,03h,05Ah,00h,0EEh,03h
        db 06h,00h,0A5h,01h,06h,00h,0A5h,01h,0FCh,0FFh,0A8h,01h,06h,00h,0F0h,03h
        db 06h,00h,0F1h,03h,05Ah,00h,0F0h,03h,06h,00h,0A8h,01h,06h,00h,0A8h,01h
        db 0FCh,0FFh,0ABh,01h,06h,00h,0F2h,03h,06h,00h,0F3h,03h,05Ah,00h,0F2h,03h
        db 06h,00h,0ABh,01h,06h,00h,0ABh,01h,0FCh,0FFh,00h,00h,06h,00h,0Ch,00h
        db 012h,00h,018h,00h,01Eh,00h,024h,00h,02Ah,00h,0F4h,03h,08h,00h,0F5h,03h
        db 014h,00h,096h,01h,0FCh,0FFh,0F6h,03h,08h,00h,0F7h,03h,014h,00h,099h,01h
        db 0FCh,0FFh,0F8h,03h,08h,00h,0F9h,03h,014h,00h,09Ch,01h,0FCh,0FFh,0FAh,03h
        db 08h,00h,0FBh,03h,014h,00h,09Fh,01h,0FCh,0FFh,0FCh,03h,08h,00h,0FDh,03h
        db 014h,00h,0A2h,01h,0FCh,0FFh,0FEh,03h,08h,00h,0FFh,03h,014h,00h,0A5h,01h
        db 0FCh,0FFh,00h,04h,08h,00h,01h,04h,014h,00h,0A8h,01h,0FCh,0FFh,02h,04h
        db 08h,00h,03h,04h,014h,00h,0ABh,01h,0FCh,0FFh,00h,00h,08h,00h,010h,00h
        db 018h,00h,020h,00h,028h,00h,030h,00h,038h,00h,04h,04h,04h,00h,05h,04h
        db 04h,00h,06h,04h,014h,00h,096h,01h,0FCh,0FFh,07h,04h,04h,00h,08h,04h
        db 04h,00h,09h,04h,014h,00h,099h,01h,0FCh,0FFh,0Ah,04h,04h,00h,0Bh,04h
        db 04h,00h,0Ch,04h,014h,00h,09Ch,01h,0FCh,0FFh,0Dh,04h,04h,00h,0Eh,04h
        db 04h,00h,0Fh,04h,014h,00h,09Fh,01h,0FCh,0FFh,010h,04h,04h,00h,011h,04h
        db 04h,00h,012h,04h,014h,00h,0A2h,01h,0FCh,0FFh,016h,04h,04h,00h,017h,04h
        db 04h,00h,018h,04h,014h,00h,0A8h,01h,0FCh,0FFh,013h,04h,04h,00h,014h,04h
        db 04h,00h,015h,04h,014h,00h,0A5h,01h,0FCh,0FFh,019h,04h,04h,00h,01Ah,04h
        db 04h,00h,01Bh,04h,014h,00h,0ABh,01h,0FCh,0FFh,00h,00h,08h,00h,010h,00h
        db 018h,00h,020h,00h,028h,00h,030h,00h,038h,00h,01Ch,04h,04h,00h,01Dh,04h
        db 04h,00h,01Eh,04h,014h,00h,096h,01h,0FCh,0FFh,01Fh,04h,04h,00h,020h,04h
        db 04h,00h,021h,04h,014h,00h,099h,01h,0FCh,0FFh,022h,04h,04h,00h,023h,04h
        db 04h,00h,024h,04h,014h,00h,09Ch,01h,0FCh,0FFh,025h,04h,04h,00h,026h,04h
        db 04h,00h,027h,04h,014h,00h,09Fh,01h,0FCh,0FFh,028h,04h,04h,00h,029h,04h
        db 04h,00h,02Ah,04h,014h,00h,0A2h,01h,0FCh,0FFh,02Bh,04h,04h,00h,02Ch,04h
        db 04h,00h,02Dh,04h,014h,00h,0A5h,01h,0FCh,0FFh,02Eh,04h,04h,00h,02Fh,04h
        db 04h,00h,0CEh,03h,014h,00h,0A8h,01h,0FCh,0FFh,0CFh,03h,04h,00h,0D0h,03h
        db 04h,00h,0D1h,03h,014h,00h,0ABh,01h,0FCh,0FFh,00h,00h,0Eh,00h,01Ch,00h
        db 02Ah,00h,038h,00h,046h,00h,054h,00h,062h,00h,063h,00h,04h,00h,062h,00h
        db 04h,00h,061h,00h,04h,00h,060h,00h,04h,00h,061h,00h,04h,00h,062h,00h
        db 04h,00h,00h,00h,0FCh,0FFh,069h,00h,04h,00h,068h,00h,04h,00h,067h,00h
        db 04h,00h,066h,00h,04h,00h,067h,00h,04h,00h,068h,00h,04h,00h,05h,00h
        db 0FCh,0FFh,06Fh,00h,04h,00h,06Eh,00h,04h,00h,06Dh,00h,04h,00h,06Ch,00h
        db 04h,00h,06Dh,00h,04h,00h,06Eh,00h,04h,00h,0Ah,00h,0FCh,0FFh,075h,00h
        db 04h,00h,074h,00h,04h,00h,073h,00h,04h,00h,072h,00h,04h,00h,073h,00h
        db 04h,00h,074h,00h,04h,00h,0Fh,00h,0FCh,0FFh,07Bh,00h,04h,00h,07Ah,00h
        db 04h,00h,079h,00h,04h,00h,078h,00h,04h,00h,079h,00h,04h,00h,07Ah,00h
        db 04h,00h,014h,00h,0FCh,0FFh,081h,00h,04h,00h,080h,00h,04h,00h,07Fh,00h
        db 04h,00h,07Eh,00h,04h,00h,07Fh,00h,04h,00h,080h,00h,04h,00h,019h,00h
        db 0FCh,0FFh,087h,00h,04h,00h,086h,00h,04h,00h,085h,00h,04h,00h,084h,00h
        db 04h,00h,085h,00h,04h,00h,086h,00h,04h,00h,01Eh,00h,0FCh,0FFh,08Dh,00h
        db 04h,00h,08Ch,00h,04h,00h,08Bh,00h,04h,00h,08Ah,00h,04h,00h,08Bh,00h
        db 04h,00h,08Ch,00h,04h,00h,023h,00h,0FCh,0FFh,00h,00h,0Eh,00h,01Ch,00h
        db 02Ah,00h,038h,00h,046h,00h,054h,00h,062h,00h,063h,00h,04h,00h,064h,00h
        db 04h,00h,065h,00h,04h,00h,065h,00h,04h,00h,065h,00h,04h,00h,064h,00h
        db 04h,00h,00h,00h,0FCh,0FFh,069h,00h,04h,00h,06Ah,00h,04h,00h,06Bh,00h
        db 04h,00h,06Bh,00h,04h,00h,06Bh,00h,04h,00h,06Ah,00h,04h,00h,05h,00h
        db 0FCh,0FFh,06Fh,00h,04h,00h,070h,00h,04h,00h,071h,00h,04h,00h,071h,00h
        db 04h,00h,071h,00h,04h,00h,070h,00h,04h,00h,0Ah,00h,0FCh,0FFh,075h,00h
        db 04h,00h,076h,00h,04h,00h,077h,00h,04h,00h,077h,00h,04h,00h,077h,00h
        db 04h,00h,076h,00h,04h,00h,0Fh,00h,0FCh,0FFh,07Bh,00h,04h,00h,07Ch,00h
        db 04h,00h,07Dh,00h,04h,00h,07Dh,00h,04h,00h,07Dh,00h,04h,00h,07Ch,00h
        db 04h,00h,014h,00h,0FCh,0FFh,081h,00h,04h,00h,082h,00h,04h,00h,083h,00h
        db 04h,00h,083h,00h,04h,00h,083h,00h,04h,00h,082h,00h,04h,00h,019h,00h
        db 0FCh,0FFh,087h,00h,04h,00h,088h,00h,04h,00h,089h,00h,04h,00h,089h,00h
        db 04h,00h,089h,00h,04h,00h,088h,00h,04h,00h,01Eh,00h,0FCh,0FFh,08Dh,00h
        db 04h,00h,08Eh,00h,04h,00h,08Fh,00h,04h,00h,08Fh,00h,04h,00h,08Fh,00h
        db 04h,00h,08Eh,00h,04h,00h,023h,00h,0FCh,0FFh,00h,00h,06h,00h,0Ch,00h
        db 012h,00h,018h,00h,01Eh,00h,024h,00h,02Ah,00h,061h,00h,018h,00h,062h,00h
        db 04h,00h,00h,00h,0FCh,0FFh,067h,00h,018h,00h,068h,00h,04h,00h,05h,00h
        db 0FCh,0FFh,06Dh,00h,018h,00h,06Eh,00h,04h,00h,0Ah,00h,0FCh,0FFh,073h,00h
        db 018h,00h,074h,00h,04h,00h,0Fh,00h,0FCh,0FFh,079h,00h,018h,00h,07Ah,00h
        db 04h,00h,014h,00h,0FCh,0FFh,07Fh,00h,018h,00h,080h,00h,04h,00h,019h,00h
        db 0FCh,0FFh,085h,00h,018h,00h,086h,00h,04h,00h,01Eh,00h,0FCh,0FFh,08Bh,00h
        db 018h,00h,08Ch,00h,04h,00h,023h,00h,0FCh,0FFh,00h,00h,06h,00h,0Ch,00h
        db 012h,00h,018h,00h,01Eh,00h,024h,00h,02Ah,00h,065h,00h,018h,00h,064h,00h
        db 04h,00h,00h,00h,0FCh,0FFh,06Bh,00h,018h,00h,06Ah,00h,04h,00h,05h,00h
        db 0FCh,0FFh,071h,00h,018h,00h,070h,00h,04h,00h,0Ah,00h,0FCh,0FFh,077h,00h
        db 018h,00h,076h,00h,04h,00h,0Fh,00h,0FCh,0FFh,07Dh,00h,018h,00h,07Ch,00h
        db 04h,00h,014h,00h,0FCh,0FFh,083h,00h,018h,00h,082h,00h,04h,00h,019h,00h
        db 0FCh,0FFh,089h,00h,018h,00h,088h,00h,04h,00h,01Eh,00h,0FCh,0FFh,08Fh,00h
        db 018h,00h,08Eh,00h,04h,00h,023h,00h,0FCh,0FFh,00h,00h,0Ah,00h,014h,00h
        db 01Eh,00h,028h,00h,032h,00h,03Ch,00h,046h,00h,030h,04h,08h,00h,031h,04h
        db 018h,00h,03Bh,01h,08h,00h,052h,01h,08h,00h,02Dh,00h,0FCh,0FFh,032h,04h
        db 08h,00h,033h,04h,018h,00h,03Fh,01h,08h,00h,053h,01h,08h,00h,032h,00h
        db 0FCh,0FFh,034h,04h,08h,00h,035h,04h,018h,00h,043h,01h,08h,00h,054h,01h
        db 08h,00h,037h,00h,0FCh,0FFh,036h,04h,08h,00h,037h,04h,018h,00h,047h,01h
        db 08h,00h,055h,01h,08h,00h,03Ch,00h,0FCh,0FFh,038h,04h,08h,00h,039h,04h
        db 018h,00h,04Bh,01h,08h,00h,056h,01h,08h,00h,041h,00h,0FCh,0FFh,03Ah,04h
        db 08h,00h,03Bh,04h,018h,00h,04Fh,01h,08h,00h,057h,01h,08h,00h,046h,00h
        db 0FCh,0FFh,03Ch,04h,08h,00h,03Dh,04h,018h,00h,033h,01h,08h,00h,050h,01h
        db 08h,00h,04Bh,00h,0FCh,0FFh,03Eh,04h,08h,00h,03Fh,04h,018h,00h,037h,01h
        db 08h,00h,051h,01h,08h,00h,028h,00h,0FCh,0FFh,00h,00h,0Ah,00h,014h,00h
        db 01Eh,00h,028h,00h,032h,00h,03Ch,00h,046h,00h,040h,04h,08h,00h,041h,04h
        db 018h,00h,04Bh,01h,08h,00h,056h,01h,08h,00h,04Bh,00h,0FCh,0FFh,042h,04h
        db 08h,00h,043h,04h,018h,00h,04Fh,01h,08h,00h,057h,01h,08h,00h,028h,00h
        db 0FCh,0FFh,044h,04h,08h,00h,045h,04h,018h,00h,033h,01h,08h,00h,050h,01h
        db 08h,00h,02Dh,00h,0FCh,0FFh,046h,04h,08h,00h,047h,04h,018h,00h,037h,01h
        db 08h,00h,051h,01h,08h,00h,032h,00h,0FCh,0FFh,048h,04h,08h,00h,049h,04h
        db 018h,00h,03Bh,01h,08h,00h,052h,01h,08h,00h,037h,00h,0FCh,0FFh,04Ah,04h
        db 08h,00h,04Bh,04h,018h,00h,03Fh,01h,08h,00h,053h,01h,08h,00h,03Ch,00h
        db 0FCh,0FFh,04Ch,04h,08h,00h,04Dh,04h,018h,00h,043h,01h,08h,00h,054h,01h
        db 08h,00h,041h,00h,0FCh,0FFh,04Eh,04h,08h,00h,04Fh,04h,018h,00h,047h,01h
        db 08h,00h,055h,01h,08h,00h,046h,00h,0FCh,0FFh,00h,00h,06h,00h,0Ch,00h
        db 012h,00h,018h,00h,01Eh,00h,024h,00h,02Ah,00h,050h,04h,08h,00h,051h,04h
        db 014h,00h,050h,04h,0F8h,0FFh,053h,04h,08h,00h,054h,04h,014h,00h,053h,04h
        db 0F8h,0FFh,056h,04h,08h,00h,057h,04h,014h,00h,056h,04h,0F8h,0FFh,059h,04h
        db 08h,00h,05Ah,04h,014h,00h,059h,04h,0F8h,0FFh,05Ch,04h,08h,00h,05Dh,04h
        db 014h,00h,05Ch,04h,0F8h,0FFh,05Fh,04h,08h,00h,060h,04h,014h,00h,05Fh,04h
        db 0F8h,0FFh,062h,04h,08h,00h,062h,04h,014h,00h,062h,04h,0F8h,0FFh,065h,04h
        db 08h,00h,066h,04h,014h,00h,065h,04h,0F8h,0FFh,00h,00h,06h,00h,0Ch,00h
        db 012h,00h,018h,00h,01Eh,00h,024h,00h,02Ah,00h,051h,04h,08h,00h,052h,04h
        db 018h,00h,051h,04h,0F8h,0FFh,054h,04h,08h,00h,055h,04h,018h,00h,054h,04h
        db 0F8h,0FFh,057h,04h,08h,00h,058h,04h,018h,00h,057h,04h,0F8h,0FFh,05Ah,04h
        db 08h,00h,05Bh,04h,018h,00h,05Ah,04h,0F8h,0FFh,05Dh,04h,08h,00h,05Eh,04h
        db 018h,00h,05Dh,04h,0F8h,0FFh,060h,04h,08h,00h,061h,04h,018h,00h,060h,04h
        db 0F8h,0FFh,062h,04h,08h,00h,064h,04h,018h,00h,062h,04h,0F8h,0FFh,065h,04h
        db 08h,00h,067h,04h,018h,00h,065h,04h,0F8h,0FFh,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,0C1h,02h,0Ch,00h,068h,04h
        db 0Ah,00h,069h,04h,0Ah,00h,06Ah,04h,018h,00h,068h,04h,0Ch,00h,0C1h,02h
        db 0F4h,0FFh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,0C1h,02h,0Ch,00h,06Bh,04h,0Ah,00h,06Ch,04h,0Ah,00h,06Dh,04h
        db 018h,00h,06Bh,04h,0Ch,00h,0C1h,02h,0F4h
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
