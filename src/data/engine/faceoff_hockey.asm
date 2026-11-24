; The random seed, the assignment table, and the live game flags, puck, and penalty tables.
bits 32
%include "hockey.inc"
section s_C9078 progbits alloc noexec write align=1
extern assbench, assbenchside, assbenchwait, assboxenter, asscenterd, asscentero, assdefd, assdefo
extern assdopen, asseben, assepen, assfaceoff, assfaceoffpl, assgoalie, assgoalietopuck, assintroline
extern assintrostand, assleavebox, assleaveice, assnearest, asspassrec, asspenalty, asspenshooter, asspsclear
extern asspuckc, assrefatdot, assrefdrop, assreffollow, assrefgoalline, assrefgoalpa, assrefpenshot, assrefsignal
extern assrefwhistle, assscore, assshoot, assstanley, assstarskate, asstakeposition, assthreestars, asswingd
extern asswingo, puckfaceoff, puckfaceoff2, pucknorm, pucknothing, puckshadow, puckstruct, ReplayBuffer
extern rtss
global replaystart, puckx, puckvx, pucky, puckvy, puckz, puckvz, puckc
global camx_m2, camx, camy, wcradiusx, wcradiusy, shotplayer, lastplayer, passdir
global passspeed, passplayer, threat, xc1, yc1, yleader, fox, foy
global fodir1, fodir2, collflag, gmode, sflags, gmode2, sflags3, c1playernum
global c2playernum, cont1team, cont2team, HomeTeam, VisTeam, PenCntDwn, Penaltytimer, refsignal
global RefStep, RefPen, penaltysc, gsp, gameclock, clockticks, dirtab, dirtab_y
global seed, pendelaytab, pendelaytab_e13, penmintab_m3, penmintab, pendelay2tab, pendelay2tab_e4, asstab
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
