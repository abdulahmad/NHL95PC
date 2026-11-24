; The game loop: clock, periods, frame, crowd, sprite sort, intermission, game over.
bits 32
%include "hockey.inc"
%include "spa.inc"
section s_5B9D1 progbits alloc exec nowrite align=1
extern __CHK, AddPenalty2, assinsert, assreplace, asstab, awscore, awtmgoaliesc, awtmnear
extern awtmnearpl, awtmstruct, bannermsg, bannertimer, LinePlayersAway, c1playernum, c2playernum, camx
extern camy, changeplayer_ret5, checkcoll, checkwindow, ChkGoalies, ClearPenaltyBuffer, clearteams, cliprect_y0
extern cliprect_y1, clockticks, collflag, cont1team, cont2team, Crowdlevel, cupceremony, curperiod
extern CwdExciteLvl, DecayCrowdLevel, defsort_d, defsort_fwd, doinput, DrawCallBanner, DrawFrameSprite, DrawRinkEndArt
extern DrawRinkObjects, DrawSpriteNumber, DrawTextOverlay, ds2list, AimArrowFrames_m2, DrawClipLeft, DrawClipRight, GameVarsClear
extern SpeechPatchNext, EndPenaltyShot, energywarn, exitgame, fadeinpending, findpc, findpc_ret5, findpc_ret6
extern fodir1, fodir2, fox, foy, gameclock, gameopts, gameover, gmode
extern gmode2, goalevent, gsp, hmscore, hmtmgoaliesc, hmtmnear, hmtmnearpl, hmtmstruct
extern InitCoachModes, IntermissionPC, IsCupClinched, joysampling, joysampling_save, lastsfx, lcblink, lcboxon
extern lcline, lcrequest, lldisp, lldispodd, ltack, markframes_e1, MaxCwdExciteLvl, mousex
extern mousey, MusicOn, NumCwdExciteLvl, offsort_d, offsort_fwd, OOlist, OOlistpos, ovlseq
extern ovltimer, pad1dev, pad2dev, PaOneMinuteLeft, PBnum, PenaltyManager, PenBuf, PenCntDwn
extern PenCntDwn2, penshotlive, penshotmode, penshotplayer, penshotstart, penshotteam, penshottimer, periodendtime
extern PerTimeTab, PerTimeTotal, playsuspended, PlList, priolist, priolist_m1, puckc, puckstruct
extern puckx, pucky, puckz, randomd0, ReadJoy1, ReadJoy2, recbpr, reenergizeteam
extern refasslist, reflegspd, reflegstr, refposition, RefStep, refweight, regd0, regd1
extern regd2, regd3, regd4, regd5, ReplayRecordReset, replaystart, restoreteams, rinkscrollx
extern rinkscrolly, SetBoxDoorObject, SetClipWindow, SetPenaltyStrength, Setplass, setplayer, SetSPA, sflags
extern sflags3, sfx, shotongoal, shotontarget, shotplayer, shownumbers, SortCords, SortIndices
extern sortobj15, SPAlist, SprSort_loop, SprSort_test, JoyButtonMap, sublist, sublist_defl, sublist_defl_m3
extern sublist_m2, SumCwdExciteLvl, threat, UpdateCoachModes, UpdatePowerPlayFlags, updatereplay, vecdist, vtoa
extern SortPending, LastShooterTeam, xc1, yc1, yleader, Ylist
global GetPeriodTime, ResetClock, ClearSortCords, defaultsprites_0, TryAddPlayerToList, SetPlList, setpersonel, StartPer
global DoGameFrame, RestoreBenchEnergy, updatecrowdf, periodicevents, updateplayers, updateanim, freezewindow, cleargamevars
global DrawRinkOverlays, setupice, clockcont_0, ClockTick, SprSortVert, SprSort, GameOver, SetExitGame
global SetupTeamForIntermission, Intermission, PeriodOver_sp, PeriodOver, ResetBench, resetplstuff, StartGame, forceteams
global forcepldata
;-----------------------------------------------------------------------------
; GetPeriodTime                  5B9D1  93G hockey93_01.asm, medium confidence
; GetPeriodTime: period length from the option table CBC4A
;-----------------------------------------------------------------------------
; C: src/engine/hockey/GetPeriodTime.c
%ifdef CBUILD
%include "c/engine/hockey/GetPeriodTime.inc"
%else
GetPeriodTime:
        push dword 4
        call __CHK
        mov eax, dword [gameopts]
        shl eax, 14h
        shr eax, 1Eh
        mov ax, word [nosplit eax*2+PerTimeTab]
        test byte [gameopts+1], 2
        je short .x
        cmp dword [curperiod], byte 3
        jle short .x
        mov ax, word [PerTimeTab]
.x:
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ResetClock                                        5BA07  93G hockey93_01.asm
; gameclock = PerTimeTotal = GetPeriodTime, clockticks = 0,
; periodendtime = gameclock - random(length/2), clock stopped (gmode bit 0).
;-----------------------------------------------------------------------------
; C: src/engine/hockey/ResetClock.c
%ifdef CBUILD
%include "c/engine/hockey/ResetClock.inc"
%else
ResetClock:
        push dword 8
        call __CHK
        push edx
        call GetPeriodTime
        mov word [gameclock], ax
        xor edx, edx
        mov word [clockticks], dx
        mov word [PerTimeTotal], ax
        cwde
        sar eax, 1
        cwde
        call randomd0
        mov dx, word [gameclock]
        sub edx, eax
        mov word [periodendtime], dx
        or byte [gmode], 1
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ClearSortCords                               5BA4E  95 PC, medium confidence
; Zeroes the SortCords objects
;-----------------------------------------------------------------------------
; C: src/engine/hockey/ClearSortCords.c
%ifdef CBUILD
%include "c/engine/hockey/ClearSortCords.inc"
%else
ClearSortCords:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        xor ecx, ecx
        jmp short .4
.1:
        movsx eax, cx
        shl eax, 7
        add eax, SortCords
        xor edx, edx
        jmp short .3
.2:
        mov byte [eax], 0
        inc eax
        inc edx
.3:
        movsx ebx, dx
        cmp ebx, 80h
        jb short ClearSortCords.2
        inc ecx
.4:
        cmp cx, byte 11h
        jl short ClearSortCords.1
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; defaultsprites_0                                      5BA89  94G setup94.asm
; Zeroes the remaining sprite objects (second loop of defaultsprites)
;-----------------------------------------------------------------------------
; C: src/engine/control/findpc.c (defaultsprites_0)
%ifdef CBUILD
%include "c/engine/control/findpc.defaultsprites_0.inc"
%else
defaultsprites_0:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        call ClearSortCords
        mov edx, ds2list
        mov eax, SortCords
        mov esi, OOlist
        mov edi, OOlistpos
        xor ebx, ebx
.1:
        mov word [byte eax+SCnum], bx
        mov byte [byte eax+pnum], 0FFh
        mov byte [byte eax+newpos], 0FFh
        mov cl, byte [byte eax+newpos]
        mov byte [byte eax+newpnum], cl
        mov cx, word [edx]
        mov word [byte eax+Xpos+2], cx
        add edx, byte 2
        mov cx, word [edx]
        mov word [byte eax+Ypos+2], cx
        add edx, byte 2
        mov cx, word [edx]
        mov word [byte eax+Zpos+2], cx
        add edx, byte 2
        mov cx, word [edx]
        mov word [byte eax+frame], cx
        add edx, byte 2
        mov cx, word [edx]
        mov word [byte eax+054h], cx
        add edx, byte 2
        mov cx, word [edx]
        mov word [byte eax+radiusx], cx
        add edx, byte 2
        mov cx, word [edx]
        mov word [byte eax+radiusy], cx
        add edx, byte 2
        mov cl, byte [edx]
        mov byte [byte eax+asslist], cl
        add edx, byte 2
        mov cl, byte [edx]
        mov byte [byte eax+pflags], cl
        add edx, byte 2
        test cl, 40h
        je short .2
        mov ecx, awtmstruct
        jmp short .3
.2:
        mov ecx, hmtmstruct
.3:
        mov dword [byte eax+tmptr], ecx
        test byte [byte eax+pflags], 40h
        jne short .4
        mov ecx, awtmstruct
        jmp short .5
.4:
        mov ecx, hmtmstruct
.5:
        mov dword [byte eax+optmptr], ecx
        mov word [byte eax+temp5], 0
        mov byte [esi], bl
        mov word [edi], bx
        inc esi
        add edi, byte 2
        add eax, 80h
        inc ebx
        cmp bx, byte 11h
        jne near defaultsprites_0.1
        mov word [SortCords+836h], 2
        mov ebx, 0FFFFFFFFh
        mov word [refposition], bx
        mov byte [refweight], 7
        mov ah, 0Fh
        mov byte [reflegstr], ah
        mov byte [reflegspd], ah
        mov word [RefStep], bx
        call SprSort
        jmp near findpc_ret5
%endif ; C
;-----------------------------------------------------------------------------
; TryAddPlayerToList                           5BB9E  95 PC, medium confidence
; Adds a roster player to PlList (E0384) if not already there
;-----------------------------------------------------------------------------
; C: src/engine/hockey/TryAddPlayerToList.c
%ifdef CBUILD
%include "c/engine/hockey/TryAddPlayerToList.inc"
%else
TryAddPlayerToList:
        push dword 8
        call __CHK
        push ecx
        mov ecx, edx
        movsx edx, dx
        add edx, edx
        add edx, eax
        cmp word [byte edx+tmpdst], byte 0
        jg short .1
        mov eax, dword [byte edx+tmpdst-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFDh
        jg short .2
.1:
        xor eax, eax
        pop ecx
        ret
.2:
        mov eax, 5
        jmp short .5
.3:
        cmp ax, bx
        je short .4
        movsx edx, ax
        movsx dx, byte [dword edx+PlList]
        cmp cx, dx
        je short TryAddPlayerToList.1
.4:
        dec eax
.5:
        test ax, ax
        jge short TryAddPlayerToList.3
        movsx edx, bx
        mov byte [dword edx+PlList], cl
        mov eax, 1
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SetPlList                                    5BBFA  95 PC, medium confidence
; Builds the player list for the line/stat screens via TryAddPlayerToList
;-----------------------------------------------------------------------------
; C: src/engine/control/findpc.c (SetPlList)
%ifdef CBUILD
%include "c/engine/control/findpc.SetPlList.inc"
%else
SetPlList:
        push dword 30h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 14h
        mov esi, eax
        xor edx, edx
        mov word [byte esp+04h], dx
        mov ax, word [byte eax+02Ah]
        mov word [byte esp+0Ch], ax
        mov ebp, dword [dword esi+tmlines]
        xor eax, eax
        mov bl, 0FFh
        jmp short .2
.1:
        movsx edx, ax
        mov byte [dword edx+PlList], bl
        inc eax
.2:
        cmp ax, 6
        jl short SetPlList.1
        cmp dword [penshotmode], byte 0
        je short .3
        cmp esi, awtmstruct
        sete al
        xor edx, edx
        mov dl, al
        cmp edx, dword [penshotteam]
        jne short .4
.3:
        cmp word [byte esi+SPA], byte 0
        jge short .4
        mov word [byte esp+04h], 1
        jmp short .5
.4:
        mov word [byte esi+temp5], 0FFFFh
.5:
        mov di, word [byte esi+facedir]
.6:
        dec edi
        test di, di
        jl near .13
        movsx edx, di
        mov ebx, dword [byte esp+02h]
        sar ebx, 10h
        movsx ax, byte [dword edx+ebx+priolist]
        mov word [byte esp+08h], ax
        mov al, byte [dword edx+ebx+priolist]
        mov byte [dword edx+LinePlayersAway], al
        mov eax, dword [byte esp+08h]
        test ax, ax
        jne short .10
        mov ebx, dword [byte esp+06h]
        sar ebx, 10h
        mov ecx, dword [nosplit ebx*2+sublist_m2]
        sar ecx, 10h
        mov ebx, dword [byte esi+SPA-2]
.7:
        sar ebx, 10h
        mov ebx, dword [dword ecx+ebx+sublist_defl_m3]
        sar ebx, 18h
.8:
        mov al, byte [ebx+ebp]
.9:
        mov byte [dword edx+PlList], al
        jmp short SetPlList.6
.10:
        cmp ax, 6
        jne short .11
        mov al, byte [byte ebp+026h]
        jmp short SetPlList.9
.11:
        cmp word [byte esp+0Ch], byte 4
        jge short .12
        cmp ax, 2
        jg short .12
        mov ebx, dword [byte esp+06h]
        sar ebx, 10h
        mov ecx, dword [nosplit ebx*2+sublist_m2]
        sar ecx, 10h
        mov ebx, dword [byte esi+02Ah]
        jmp short SetPlList.7
.12:
        mov edx, dword [byte esp+06h]
        sar edx, 10h
        mov edx, dword [nosplit edx*2+sublist_m2]
        sar edx, 10h
        mov ebx, dword [byte esp+0Ah]
        sar ebx, 10h
        mov ebx, dword [dword edx+ebx+sublist_defl_m3]
        sar ebx, 18h
        movsx edx, di
        jmp short SetPlList.8
.13:
        mov edi, 5
        jmp near .30
.14:
        movsx ebx, di
        movsx cx, byte [dword ebx+PlList]
        test cx, cx
        jl near .29
        movsx ax, byte [dword ebx+LinePlayersAway]
        mov word [byte esp+08h], ax
        movsx ecx, cx
        lea edx, [ecx+ecx]
        add edx, esi
        mov eax, dword [byte edx+tmpdst-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFDh
        jle short .15
        cmp word [byte edx+tmpdst], byte 0
        jg short .15
        mov edx, dword [byte esi+facedir-2]
        sar edx, 10h
        sub edx, byte 2
        cmp ebx, edx
        jl near .28
        mov edx, ecx
        mov eax, esi
        call TryAddPlayerToList
        test ax, ax
        jne near .28
.15:
        mov edx, dword [byte esp+06h]
        sar edx, 10h
        mov ecx, dword [nosplit edx*2+sublist_m2]
        sar ecx, 10h
        add ecx, sublist_defl
.16:
        mov al, byte [ecx]
        mov byte [byte esp+010h], al
        inc ecx
        test al, al
        jge near .27
        cmp esi, awtmstruct
        sete dl
        xor dh, dh
        mov eax, edx
        mov ebx, dword [byte esp+08h]
        cmp bx, byte 6
        je short .17
        cmp word [byte esp+0Ch], byte 6
        jge short .20
.17:
        mov edx, dword [byte esp+08h]
        cmp dx, byte 1
        je short .18
        cmp dx, byte 2
        jne short .19
.18:
        movsx ebx, ax
        mov edx, ebx
        shl edx, 2
        sub edx, ebx
        shl edx, 3
        add edx, ebx
        add edx, offsort_d
        jmp short .23
.19:
        movsx ebx, ax
        mov edx, ebx
        shl edx, 2
        sub edx, ebx
        shl edx, 3
        add edx, ebx
        add edx, offsort_fwd
        jmp short .23
.20:
        cmp bx, byte 1
        je short .21
        cmp bx, byte 2
        jne short .22
.21:
        movsx ebx, ax
        mov edx, ebx
        shl edx, 2
        sub edx, ebx
        shl edx, 3
        add edx, ebx
        add edx, defsort_d
        jmp short .23
.22:
        movsx ebx, dx
        mov edx, ebx
        shl edx, 2
        sub edx, ebx
        shl edx, 3
        add edx, ebx
        add edx, defsort_fwd
.23:
        mov dword [esp], edx
        xor ecx, ecx
.24:
        movsx edx, cx
        add edx, dword [esp]
        mov al, byte [edx]
        mov byte [byte esp+010h], al
        inc ecx
        test al, al
        jge short .26
        mov ecx, 18h
.25:
        mov byte [byte esp+010h], cl
        dec ecx
        test cx, cx
        jl short .28
        movsx ebx, di
        mov edx, dword [byte esp+0Dh]
        sar edx, 18h
        mov eax, esi
        call TryAddPlayerToList
        test ax, ax
        je short SetPlList.25
.26:
        movsx ebx, di
        mov edx, dword [byte esp+0Dh]
        sar edx, 18h
        mov eax, esi
        call TryAddPlayerToList
        test ax, ax
        je short SetPlList.24
        jmp short .28
.27:
        mov edx, dword [byte esp+0Dh]
        sar edx, 18h
        mov al, byte [edx+ebp]
        mov byte [byte esp+010h], al
        movsx ebx, di
        mov edx, dword [byte esp+0Dh]
        sar edx, 18h
        mov eax, esi
        call TryAddPlayerToList
        test ax, ax
        je near SetPlList.16
.28:
        cmp word [byte esp+08h], byte 6
        jne short .29
        movsx edx, di
        movsx ax, byte [dword edx+PlList]
        mov word [byte esi+temp5], ax
.29:
        dec edi
.30:
        test di, di
        jge near SetPlList.14
        add esp, byte 14h
        jmp near findpc_ret6
%endif ; C
;-----------------------------------------------------------------------------
; setpersonel                      5BEF4  94G collide94.asm, medium confidence
; Set the personnel of team t: clear newpos / newpnum of the team's 6 sort
; objects, build PlList (SetPlList: pnum per wanted player, -1 none,
;
; the new positions at PlList+6 = LinePlayersAway). Pass 1: a wanted player
; already on the ice keeps his sort object (newpos from the list, newpnum =
; pnum).
;
; Pass 2: each remaining wanted player takes the last free sort object
; (newpnum < 0), stopping at the first one with a position; a sort object
; without a position (off the ice) first gets assignment assbenchwait
;
; and position 5. Used entries of PlList are set to -1.
;-----------------------------------------------------------------------------
; C: src/engine/control/findpc.c (setpersonel)
%ifdef CBUILD
%include "c/engine/control/findpc.setpersonel.inc"
%else
setpersonel:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 4
        mov edi, eax
        mov esi, 6
        mov eax, dword [dword eax+tmsort]
.1:
        mov byte [byte eax+newpos], 0FFh
        mov byte [byte eax+newpnum], 0FFh
        add eax, 80h
        dec si
        jne short setpersonel.1
        mov eax, edi
        call SetPlList
        mov esi, 5
.2:
        movsx eax, si
        movsx ax, byte [dword eax+PlList]
        mov word [esp], ax
        test ax, ax
        jl short .6
        mov eax, dword [dword edi+tmsort]
        xor edx, edx
        sub eax, 80h
        jmp short .5
.3:
        add eax, 80h
        movsx cx, byte [byte eax+047h]
        cmp cx, word [esp]
        jne short .4
        movsx edx, si
        mov cl, byte [dword edx+LinePlayersAway]
        mov byte [byte eax+newpos], cl
        mov cl, byte [esp]
        mov byte [byte eax+newpnum], cl
        mov byte [dword edx+PlList], 0FFh
        jmp short .6
.4:
        inc edx
.5:
        cmp dx, byte 6
        jl short setpersonel.3
.6:
        dec esi
        cmp si, byte 0FFFFh
        jne short setpersonel.2
        mov esi, 5
.7:
        movsx eax, si
        movsx ax, byte [dword eax+PlList]
        mov word [esp], ax
        test ax, ax
        jl short .13
        mov eax, dword [dword edi+tmsort]
        xor edx, edx
        sub eax, 80h
        jmp short .10
.8:
        add eax, 80h
        cmp byte [byte eax+newpnum], 0
        jge short .9
        mov ebx, eax
        cmp word [byte eax+position], byte 0
        jge short .11
.9:
        inc edx
.10:
        cmp dx, byte 6
        jl short setpersonel.8
.11:
        cmp word [byte ebx+position], byte 0
        jge short .12
        mov edx, 29h
        mov eax, ebx
        call assreplace
        mov word [byte ebx+position], 5
.12:
        movsx eax, si
        mov dl, byte [dword eax+LinePlayersAway]
        mov byte [byte ebx+newpos], dl
        mov dl, byte [esp]
        mov byte [byte ebx+newpnum], dl
        mov byte [dword eax+PlList], 0FFh
.13:
        dec esi
        cmp si, byte 0FFFFh
        jne short setpersonel.7
        add esp, byte 4
        jmp near findpc_ret5
%endif ; C
;-----------------------------------------------------------------------------
; StartPer                                          5C010  93G hockey93_01.asm
; setupice, ResetClock, no controlled players, center faceoff, InitCoachModes,
; then DoGameFrame.
;-----------------------------------------------------------------------------
; C: src/engine/control/findpc.c (StartPer)
%ifdef CBUILD
%include "c/engine/control/findpc.StartPer.inc"
%else
StartPer:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        xor edx, edx
        mov word [lcrequest+2], dx
        mov word [lcrequest], dx
        call InitCoachModes
        mov word [SpeechPatchNext], dx
        call setupice
        call ResetClock
        mov si, word [cont1team]
        cmp si, byte 1
        jne short .1
        mov word [c1playernum], 2
        jmp short .2
.1:
        cmp si, byte 2
        jne short .2
        mov word [c1playernum], 8
.2:
        mov bx, word [cont2team]
        test bx, bx
        je short .5
        cmp bx, word [cont1team]
        jne short .3
        mov ax, word [c1playernum]
        dec eax
        mov word [c2playernum], ax
        jmp short .5
.3:
        cmp bx, byte 1
        jne short .4
        mov word [c2playernum], 2
        jmp short .5
.4:
        cmp bx, byte 2
        jne short .5
        mov word [c2playernum], 8
.5:
        mov byte [goalevent], 0FFh
        mov ebx, 0FFFFFFFFh
        mov word [bannermsg], bx
        xor ecx, ecx
        mov word [bannertimer], cx
        mov word [ovltimer], bx
        xor edx, edx
        mov dword [penshotmode], edx
        mov dword [penshotlive], edx
        mov dword [penshotstart], edx
        mov dword [shotontarget], edx
        xor edi, edi
        mov dword [shotongoal], edx
        mov dword [penshotplayer], 0FFFFFFFFh
        xor edi, edx
        mov word [fox], di
        xor eax, eax
        mov word [foy], ax
        mov edx, 1Bh
        mov eax, puckstruct
        call assreplace
        cmp word [gsp], byte 0
        je short .6
        mov word [Crowdlevel], cx
.6:
        or byte [gmode2], 4
        and byte [sflags], 0AFh
        mov eax, dword [replaystart]
        mov dword [recbpr], eax
        call ReplayRecordReset
        mov word [lastsfx], 0FFFFh
        call DoGameFrame
        call DoGameFrame
        mov word [CwdExciteLvl], 10h
        cmp word [gsp], byte 2
        jge short .7
        or byte [sflags3], 80h
.7:
        mov eax, dword [puckc]
        mov byte [eax], 0FFh
        xor eax, eax
        mov word [camy], ax
        mov word [camx], ax
        mov word [yleader], ax
        mov word [yc1], ax
        mov word [xc1], ax
        mov word [fadeinpending], 1
        add dword [rinkscrollx], 3E8h
        add dword [rinkscrolly], 3E8h
        jmp near findpc_ret5
%endif ; C
;-----------------------------------------------------------------------------
; DoGameFrame                       5C1C4  94G hockey94.asm, medium confidence
; One frame of play: periodic events, player update, rink window, then replay
; recording (updatereplay, tail call).
;-----------------------------------------------------------------------------
; C: src/engine/hockey/DoGameFrame.c
%ifdef CBUILD
%include "c/engine/hockey/DoGameFrame.inc"
%else
DoGameFrame:
        push dword 4
        call __CHK
        call periodicevents
        call updateplayers
        call checkwindow
        jmp near updatereplay
%endif ; C
;-----------------------------------------------------------------------------
; RestoreBenchEnergy                                   5C1E2  94G hockey94.asm
; RestoreBenchEnergy: once a second with line changes on, bench
; players (tmpdst -2) gain energy, capped
;-----------------------------------------------------------------------------
; C: src/engine/hockey/RestoreBenchEnergy.c
%ifdef CBUILD
%include "c/engine/hockey/RestoreBenchEnergy.inc"
%else
RestoreBenchEnergy:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        test byte [gameopts], 4
        je short .x
        xor esi, esi
        mov ecx, hmtmstruct
        jmp short .4
.1:
        mov edx, 1Bh
.2:
        movsx eax, dx
        add eax, eax
        add eax, ecx
        mov ebx, dword [byte eax+07Ch]
        sar ebx, 10h
        cmp ebx, byte 0FFFFFFFEh
        jne short .3
        mov bx, word [byte eax+046h]
        add ebx, byte 8
        mov word [byte eax+046h], bx
        cmp bx, 1000h
        jle short .3
        mov word [byte eax+046h], 1000h
.3:
        dec edx
        test dx, dx
        jge short RestoreBenchEnergy.2
        mov ecx, awtmstruct
        inc esi
.4:
        cmp si, byte 2
        jl short RestoreBenchEnergy.1
.x:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; updatecrowdf                   5C248  93G hockey93_01.asm, medium confidence
; updatecrowdf: crowd excitement level E9AA8 rises/decays, random crowd
; sfx
;-----------------------------------------------------------------------------
; C: src/engine/hockey/updatecrowdf.c
%ifdef CBUILD
%include "c/engine/hockey/updatecrowdf.inc"
%else
updatecrowdf:
        push dword 10h
        call __CHK
        push ecx
        push edx
        push edi
        mov ax, word [CwdExciteLvl]
        cmp ax, word [MaxCwdExciteLvl]
        jle short .1
        mov word [MaxCwdExciteLvl], ax
.1:
        mov eax, dword [CwdExciteLvl-2]
        sar eax, 10h
        add dword [SumCwdExciteLvl], eax
        inc word [NumCwdExciteLvl]
        mov cx, word [CwdExciteLvl]
        dec ecx
        mov word [CwdExciteLvl], cx
        test cx, cx
        jge short .2
        xor edi, edi
        mov word [CwdExciteLvl], di
.2:
        test byte [gmode], 1
        je short .x
        cmp word [Crowdlevel], 258h
        jle short .x
        mov edx, dword [Crowdlevel-2]
        sar edx, 10h
        mov eax, 3E8h
        sub eax, edx
        mov edx, eax
        sar edx, 1Fh
        shl edx, 2
        LD sbb, eax, edx
        sar eax, 2
        mov edx, eax
        cmp eax, byte 19h
        jge short .3
        mov edx, 19h
.3:
        movsx eax, dx
        call randomd0
        movsx edx, ax
        test edx, edx
        jne short .4
        mov eax, 0A6h
        jmp short .5
.4:
        cmp edx, byte 1
        jne short .x
        mov eax, 96h
.5:
        call sfx
.x:
        pop edi
        pop edx
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; periodicevents                                    5C302  93G hockey93_01.asm
; Clock at 0 -> horn (sfx 90h), freezewindow, clockcont_0. Once a
; second (lldisp, 18h frames): updatecrowdf, RestoreBenchEnergy, the stats/energy checks.
;-----------------------------------------------------------------------------
; C: src/engine/hockey/periodicevents.c
%ifdef CBUILD
%include "c/engine/hockey/periodicevents.inc"
%else
periodicevents:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        call PenaltyManager
        call DecayCrowdLevel
        test byte [gmode], 1
        jne short .1
        cmp word [gameclock], byte 0
        jne short .1
        cmp word [clockticks], byte 0
        jne short .1
        mov eax, 90h
        call sfx
        call freezewindow
        call clockcont_0
.1:
        cmp word [SortPending], byte 0
        jne near .x
        mov dl, byte [lldisp]
        dec dl
        mov byte [lldisp], dl
        test dl, dl
        jge near .x
        mov bl, dl
        add bl, 18h
        mov byte [lldisp], bl
        xor byte [lldispodd], 1
        call ChkGoalies
        call updatecrowdf
        call RestoreBenchEnergy
        test byte [gmode], 1
        jne short .2
        call UpdatePowerPlayFlags
.2:
        test byte [gameopts], 4
        je near .x
        xor ebx, ebx
        mov eax, hmtmstruct
        jmp short .6
.3:
        mov eax, dword [dword eax+tmsort]
        mov edx, 6
.4:
        cmp word [byte eax+01Ah], byte 0
        jl short .5
        cmp byte [byte eax+043h], 0
        jl short .5
        cmp dword [penshotmode], byte 0
        jne short .5
        test byte [lldispodd], 1
        je short .5
        movsx eax, bx
        mov word [nosplit eax*2+energywarn], 1
        pop edx
        pop ebx
        ret
.5:
        add eax, 80h
        dec dx
        jne short periodicevents.4
        movsx eax, bx
        mov word [nosplit eax*2+energywarn], dx
        mov eax, awtmstruct
        inc ebx
.6:
        cmp bx, byte 2
        jl short periodicevents.3
.x:
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; updateplayers                     5C40F  94G replay94.asm, medium confidence
; updateplayers: run every
; sort object for a frame. PC first: playsuspended = 1 while the clock is
;
; stopped for a highlight (gmode bit 7), or with no replay (gmode2 bit 0), no
; penalty countdown or queued penalty, overlay state refasslist[...] not 20h
; / 23h and the overlay idle (ovlseq 0 or 2, ovltimer outside 0-FFh); else 0.
;
; Then for the 12 players: the puck distance (vecdist, word 4Eh), direction
; (vtoa, byte 52h) and the quarter vector squared (word 50h); per team the
; goalie's SCnum (word FAh) and the nearest available skater (dword 3Eh, word
;
; 42h; reset to FFFFh / -1 first). Then for objects 0-10h (players off the
; ice skipped, object 10h kept): the old position, updateanim, nopuck and
; word 40h counted down, a goalie's frames on ice (tmglstats word 0) in line
;
; change mode; outside the injury / fight anims the velocity: friction (>> 6,
; >> 9 with pflags bit 0) on the ice, players capped at 3E80h, the move by
; 10h * v, and gravity on z with a bounce (sfx ABh for slow ones); the
;
; controlled players' joypads and doinput, the current assignment's routine
; (asstab), a goalie without the puck kept out of the posts (x 2Ch-30h, y
; C1h-C5h on either side), the wall values cleared, checkcoll when it moved
;
; (always for the puck), impact counted down by 2 into limpact. Last the puck
; is kept inside the boards (|x| <= A0h low, y -104h..108h on the ice) while
; carried, frame 18Ah. No result.
;-----------------------------------------------------------------------------
; C: src/engine/control/findpc.c (updateplayers)
%ifdef CBUILD
%include "c/engine/control/findpc.updateplayers.inc"
%else
updateplayers:
        push dword 30h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 0Ch
        mov eax, dword [refposition]
        sar eax, 10h
        movsx ax, byte [dword eax+refasslist]
        mov dword [byte esp+08h], eax
        mov ah, byte [gmode]
        test ah, 1
        je near .5
        test ah, 80h
        jne near .4
        test byte [gmode2], 1
        jne near .5
        cmp word [PenCntDwn], byte 0
        jge short .5
        cmp byte [PenBuf], 0
        jne short .5
        mov ebx, dword [byte esp+08h]
        cmp bx, byte 20h
        je short .5
        cmp bx, byte 23h
        je short .5
        mov si, word [ovlseq]
        cmp si, byte 2
        je short .1
        test si, si
        je short .1
        mov ax, word [ovltimer]
        test ax, ax
        jl short .1
        cmp ax, 100h
        jl short .2
.1:
        mov eax, 1
        jmp short .3
.2:
        xor eax, eax
.3:
        test eax, eax
        je short .5
.4:
        mov eax, 1
        jmp short .6
.5:
        xor eax, eax
.6:
        mov dword [playsuspended], eax
        mov esi, SortCords
        mov ebx, 0FFFFFFFFh
        mov word [hmtmgoaliesc], bx
        mov edx, 0FFFFh
        mov dword [hmtmnear], edx
        mov word [hmtmnearpl], bx
        mov word [awtmgoaliesc], bx
        mov dword [awtmnear], edx
        mov word [awtmnearpl], bx
        xor edx, edx
        mov dword [byte esp+08h], edx
        jmp near .10
.7:
        mov edi, dword [byte esi+tmptr]
        mov edx, dword [esi]
        sar edx, 10h
        mov eax, dword [puckx]
        movsx eax, word [eax]
        sub eax, edx
        mov dword [byte esp+04h], eax
        mov edx, dword [byte esi+Ypos]
        sar edx, 10h
        mov eax, dword [pucky]
        movsx eax, word [eax]
        sub eax, edx
        mov dword [esp], eax
        push eax
        mov ebp, dword [byte esp+08h]
        push ebp
        call vecdist
        add esp, byte 8
        mov word [byte esi+puckdist], ax
        mov edx, dword [byte esp-02h]
        sar edx, 10h
        mov eax, dword [byte esp+02h]
        sar eax, 10h
        call vtoa
        mov byte [byte esi+puckdir], al
        mov eax, ebp
        sar eax, 2
        mov dword [byte esp+04h], eax
        sar dword [esp], 2
        mov edx, dword [byte esp+04h]
        imul edx, edx
        mov eax, dword [esp]
        imul eax, eax
        add edx, eax
        mov word [byte esi+050h], dx
        mov cx, word [byte esi+position]
        test cx, cx
        jne short .8
        mov eax, dword [byte esp+08h]
        mov word [dword edi+0FAh], ax
        jmp short .9
.8:
        jle short .9
        test byte [byte esi+pflags2], 4
        jne short .9
        test byte [byte esi+pflags], 20h
        jne short .9
        mov eax, dword [byte esi+04Eh]
        sar eax, 10h
        cmp eax, dword [byte edi+03Eh]
        jge short .9
        mov dword [byte edi+03Eh], eax
        mov eax, dword [byte esp+08h]
        mov word [byte edi+042h], ax
.9:
        inc dword [byte esp+08h]
        add esi, 80h
.10:
        cmp word [byte esp+08h], byte 0Ch
        jl near updateplayers.7
        mov esi, SortCords
        xor ecx, ecx
        mov dword [byte esp+08h], ecx
        mov ebp, 1
        jmp near .49
.11:
        mov eax, dword [esi]
        mov dword [byte esi+OldXpos], eax
        mov eax, dword [byte esi+Ypos]
        mov dword [byte esi+OldYpos], eax
        mov eax, dword [byte esi+Zpos]
        mov dword [byte esi+OldZpos], eax
        cmp word [byte esi+position], byte 0
        jge short .12
        cmp word [byte esi+SCnum], byte 10h
        jne near .48
.12:
        mov eax, esi
        call updateanim
        mov dx, word [byte esi+nopuck]
        dec edx
        mov word [byte esi+nopuck], dx
        test dx, dx
        jge short .13
        mov word [byte esi+nopuck], 0
.13:
        mov cx, word [byte esi+040h]
        dec ecx
        mov word [byte esi+040h], cx
        test cx, cx
        jge short .14
        mov word [byte esi+040h], 0
.14:
        cmp word [byte esi+SCnum], byte 10h
        je short .15
        test byte [sflags3], 40h
        je short .15
        mov bl, byte [byte esi+pnum]
        test bl, bl
        jl short .15
        mov edi, dword [byte esi+tmptr]
        cmp word [byte esi+position], byte 0
        jne short .15
        cmp bl, 19h
        jl short .15
        test byte [gmode], 10h
        jne short .15
        mov edx, dword [byte esi+044h]
        sar edx, 18h
        sub edx, byte 19h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, dword [dword edi+tmglstats]
        inc word [edx+eax*2]
.15:
        mov cx, word [byte esi+SPA]
        cmp cx, SPAinjury1
        je near .35
        cmp cx, SPAboardback
        jl short .16
        cmp cx, SPAbenchcheckl
        jle near .35
.16:
        mov word [regd4], 10h
        cmp word [byte esi+Zpos+2], byte 0
        jne near .30
        test byte [byte esi+pflags], 1
        je short .17
        mov dword [regd2], 9
        jmp short .18
.17:
        mov dword [regd2], 6
.18:
        mov ax, word [byte esi+Xvel]
        mov word [regd0], ax
        test ax, ax
        je near .24
        mov ecx, dword [regd2-2]
        sar ecx, 10h
        mov edi, eax
        sar di, cl
        mov word [regd0], di
        test di, di
        jne short .19
        mov dword [regd0], ebp
.19:
        mov ax, word [regd0]
        mov dx, word [byte esi+Xvel]
        sub edx, eax
        mov word [byte esi+Xvel], dx
        cmp word [byte esi+SCnum], byte 0Ch
        jge short .24
        test dx, dx
        jge short .20
        mov eax, dword [byte esi+Xvel-2]
        sar eax, 10h
        neg eax
        jmp short .21
.20:
        mov eax, dword [byte esi+Xvel-2]
        sar eax, 10h
.21:
        cmp eax, 3E80h
        jle short .24
        cmp word [byte esi+Xvel], byte 0
        jle short .22
        mov eax, 3E80h
        jmp short .23
.22:
        mov eax, 0FFFFC180h
.23:
        mov word [byte esi+Xvel], ax
.24:
        mov ax, word [byte esi+Yvel]
        mov word [regd0], ax
        test ax, ax
        je near .30
        mov ecx, dword [regd2-2]
        sar ecx, 10h
        mov edx, eax
        sar dx, cl
        mov word [regd0], dx
        test dx, dx
        jne short .25
        mov dword [regd0], 1
.25:
        mov ax, word [regd0]
        mov cx, word [byte esi+Yvel]
        sub ecx, eax
        mov word [byte esi+Yvel], cx
        cmp word [byte esi+SCnum], byte 0Ch
        jge short .30
        test cx, cx
        jge short .26
        mov eax, dword [byte esi+Yvel-2]
        sar eax, 10h
        neg eax
        jmp short .27
.26:
        mov eax, dword [byte esi+Yvel-2]
        sar eax, 10h
.27:
        cmp eax, 3E80h
        jle short .30
        cmp word [byte esi+Yvel], byte 0
        jle short .28
        mov eax, 3E80h
        jmp short .29
.28:
        mov eax, 0FFFFC180h
.29:
        mov word [byte esi+Yvel], ax
.30:
        mov ax, word [byte esi+Xvel]
        mov word [regd0], ax
        test ax, ax
        je short .31
        mov edx, dword [regd0-2]
        sar edx, 10h
        mov eax, dword [regd4-2]
        sar eax, 10h
        imul eax, edx
        add dword [esi], eax
.31:
        mov ax, word [byte esi+Yvel]
        mov word [regd0], ax
        test ax, ax
        je short .32
        mov edx, dword [regd0-2]
        sar edx, 10h
        mov eax, dword [regd4-2]
        sar eax, 10h
        imul eax, edx
        add dword [byte esi+Ypos], eax
.32:
        mov di, word [byte esi+Zpos+2]
        test di, di
        jl near .35
        jne short .33
        cmp word [byte esi+Zvel], byte 0
        je near .35
.33:
        imul ax, word [regd4], byte 6
        sub word [byte esi+Zvel], ax
        mov eax, dword [byte esi+Zvel-2]
        sar eax, 10h
        mov edx, dword [regd4-2]
        sar edx, 10h
        imul edx, eax
        mov dword [regd0], edx
        mov ecx, dword [byte esi+Zpos]
        add ecx, edx
        mov dword [byte esi+Zpos], ecx
        test ecx, ecx
        jge short .35
        mov dword [byte esi+Zpos], 0
        mov di, word [byte esi+Zvel]
        neg edi
        mov eax, edi
        sar ax, 1
        mov word [byte esi+Zvel], ax
        movsx ax, byte [byte esi+011h]
        mov edx, 5
        sub edx, eax
        mov word [regd0], dx
        test dx, dx
        jge short .34
        xor ebx, ebx
        mov word [regd0], bx
.34:
        cmp word [regd0], byte 3
        jg short .35
        mov eax, 0ABh
        call sfx
.35:
        mov ax, word [byte esi+SCnum]
        mov word [LastShooterTeam], ax
        cmp ax, word [c1playernum]
        jne short .36
        call ReadJoy1
        xor edx, edx
        jmp short .37
.36:
        cmp ax, word [c2playernum]
        jne short .38
        call ReadJoy2
        mov edx, 2
.37:
        mov eax, esi
        call doinput
.38:
        mov eax, dword [byte esi+assnum-2]
        sar eax, 10h
        mov eax, dword [byte esi+eax+01Bh]
        sar eax, 18h
        test eax, eax
        je short .39
        mov edx, eax
        shl edx, 2
        mov eax, esi
        call dword [dword edx+asstab]
.39:
        mov bx, word [byte esi+SCnum]
        cmp bx, byte 0Ch
        jge near .45
        test byte [gmode], 1
        jne near .45
        mov cx, word [byte esi+position]
        test cx, cx
        jne near .45
        mov eax, dword [puckc]
        movsx ax, byte [eax]
        cmp ax, bx
        je near .45
        test byte [byte esi+048h], 1
        jne near .45
        mov eax, dword [esi]
        sar eax, 10h
        cmp eax, byte 0FFFFFFD5h
        jl short .40
        mov ax, word [byte esi+Xpos+2]
        cmp ax, 2Ch
        jl short .42
        cmp ax, 31h
        jge short .42
        mov word [byte esi+Xpos+2], 2Bh
        jmp short .41
.40:
        cmp eax, byte 0FFFFFFCFh
        jl short .42
        mov word [byte esi+Xpos+2], 0FFD5h
.41:
        mov word [byte esi+Xvel], cx
.42:
        mov bx, word [byte esi+Ypos+2]
        test bx, bx
        jl short .43
        cmp bx, 0C1h
        jl short .45
        cmp bx, 0C6h
        jge short .45
        mov word [byte esi+Ypos+2], 0C6h
        jmp short .44
.43:
        mov eax, dword [byte esi+Ypos]
        sar eax, 10h
        cmp eax, 0FFFFFF3Bh
        jl short .45
        cmp eax, 0FFFFFF40h
        jge short .45
        mov word [byte esi+Ypos+2], 0FF3Ah
.44:
        mov word [byte esi+Yvel], 0
.45:
        mov word [byte esi+Wallcos], 0
        mov word [byte esi+Wallsin], 0
        mov ax, word [byte esi+Xpos+2]
        mov word [regd2], ax
        mov ax, word [byte esi+Ypos+2]
        mov word [regd3], ax
        mov ax, word [byte esi+OldXpos+2]
        cmp ax, word [regd2]
        jne short .46
        mov ax, word [byte esi+OldYpos+2]
        cmp ax, word [regd3]
        jne short .46
        cmp word [byte esi+SCnum], byte 0Eh
        jne short .47
.46:
        mov ebx, dword [regd3-2]
        sar ebx, 10h
        mov edx, dword [regd2-2]
        sar edx, 10h
        mov eax, esi
        call checkcoll
.47:
        mov di, word [byte esi+impact]
        sub edi, byte 2
        mov word [byte esi+impact], di
        test di, di
        jge short .48
        mov word [byte esi+impact], 0
.48:
        mov ax, word [byte esi+impact]
        mov word [byte esi+limpact], ax
        inc dword [byte esp+08h]
        add esi, 80h
.49:
        cmp word [byte esp+08h], byte 11h
        jl near updateplayers.11
        mov eax, dword [puckz]
        cmp word [eax], byte 18h
        jge short .54
        mov eax, dword [puckx]
        mov si, word [eax]
        test si, si
        jge short .50
        movsx eax, si
        neg eax
        jmp short .51
.50:
        movsx eax, si
.51:
        cmp eax, 0A0h
        jle short .54
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jl short .54
        mov eax, dword [puckx]
        cmp word [eax], byte 0
        jge short .52
        mov eax, 0FFFFFF60h
        jmp short .53
.52:
        mov eax, 0A0h
.53:
        mov edx, eax
        mov eax, dword [puckx]
        mov word [eax], dx
        mov word [puckstruct+12h], 18Ah
.54:
        mov eax, dword [puckz]
        cmp word [eax], byte 0
        jg short .58
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jl short .58
        mov eax, dword [pucky]
        movsx edx, word [eax]
        cmp edx, 0FFFFFEFCh
        jl short .55
        cmp word [eax], 108h
        jle short .58
.55:
        mov eax, dword [pucky]
        cmp word [eax], byte 0
        jge short .56
        mov eax, 0FFFFFEFCh
        jmp short .57
.56:
        mov eax, 108h
.57:
        mov edx, eax
        mov eax, dword [pucky]
        mov word [eax], dx
        mov word [puckstruct+12h], 18Ah
.58:
        add esp, byte 0Ch
        jmp near findpc_ret6
%endif ; C
;-----------------------------------------------------------------------------
; updateanim                                           5CAEF  94G replay94.asm
; updateanim: step SPAnum/SPAcnt through the SPA table (C921D), SetSPA
; when an animation ends
;-----------------------------------------------------------------------------
; C: src/engine/control/findpc.c (updateanim)
%ifdef CBUILD
%include "c/engine/control/findpc.updateanim.inc"
%else
updateanim:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ebx, eax
        cmp word [byte eax+SPA], byte 0
        jne short .1
        and byte [byte eax+pflags], 0DFh
        and byte [byte eax+pflags2], 0FDh
        jmp near findpc_ret5
.1:
        mov ax, word [byte eax+facedir]
        test byte [sflags], 80h
        je short .3
        mov cx, word [byte ebx+SCnum]
        cmp cx, byte 0Ch
        jl short .2
        cmp cx, byte 10h
        jne short .3
.2:
        sub eax, byte 2
        xor ah, ah
        and al, 7
.3:
        test byte [byte ebx+055h], 8
        je short .4
        mov edx, 8
        sub edx, eax
        mov eax, edx
        xor ah, dh
        and al, 7
.4:
        mov edx, dword [byte ebx+SPA-2]
        sar edx, 10h
        add edx, edx
        add edx, SPAlist
        mov di, word [edx]
        and edi, 8000h
        test ax, ax
        je short .5
        movsx esi, ax
        movsx esi, word [edx+esi*2]
        jmp short .6
.5:
        mov ax, word [edx]
        and ah, 7Fh
        movsx esi, ax
.6:
        add esi, esi
        add esi, byte 10h
        add edx, esi
        mov ax, word [byte ebx+SPAnum]
        movsx esi, ax
        add esi, esi
        add esi, edx
        mov cx, word [esi]
        cmp word [byte ebx+SPAcnt], byte 0
        jl near .9
        mov si, word [byte ebx+SPAcnt]
        dec esi
        mov word [byte ebx+SPAcnt], si
        test si, si
        jge near .11
        add word [byte ebx+SPAnum], byte 2
        add eax, 2
        movsx esi, ax
        cmp word [byte edx+esi*2-02h], byte 0
        jge short .8
        mov word [byte ebx+SPAnum], 0
        mov ax, word [byte ebx+SPAnum]
        and byte [byte ebx+pflags], 0DFh
        and byte [byte ebx+pflags2], 0FDh
        mov si, word [byte ebx+SPA]
        cmp si, SPAbenchcheckr
        jl short .7
        cmp si, SPAbenchcheckl
        jg short .7
        mov word [byte ebx+Yvel], 0
        mov ax, word [byte ebx+Yvel]
        mov word [byte ebx+Xvel], ax
        mov word [byte ebx+Xpos+2], 0FF60h
        mov word [byte ebx+facedir], 2
        or byte [byte ebx+pflags], 20h
        mov edx, SPAwallright
        mov eax, ebx
        call SetSPA
        jmp near findpc_ret5
.7:
        test di, di
        jne short .8
        mov word [byte ebx+SPA], di
.8:
        movsx esi, ax
        mov ax, word [byte edx+esi*2+02h]
        test ax, ax
        jge short .10
        neg eax
        jmp short .10
.9:
        mov ax, word [byte esi+02h]
        test ax, ax
        jge short .10
        neg eax
.10:
        mov word [byte ebx+SPAcnt], ax
.11:
        mov al, byte [byte ebx+046h]
        dec al
        mov byte [byte ebx+046h], al
        test al, al
        jge near findpc_ret5
        mov byte [byte ebx+046h], 0
        cmp cx, word [byte ebx+012h]
        je near findpc_ret5
        mov word [byte ebx+012h], cx
        cmp cx, 112h
        jl short .12
        cmp cx, 14Eh
        jg short .12
        movsx edx, cx
        sub edx, 112h
        test dl, 3
        je near .16
.12:
        cmp cx, 207h
        jl short .13
        cmp cx, 215h
        jg short .13
        test cl, 1
        jne near .16
.13:
        cmp cx, 315h
        jl short .14
        cmp cx, 32Ah
        jg short .14
        movsx edx, cx
        mov esi, 3
        mov eax, edx
        sar edx, 1Fh
        idiv esi
        test edx, edx
        je near .16
.14:
        cmp cx, 38Ah
        jl short .15
        cmp cx, 3ADh
        jg short .15
        movsx edx, cx
        sub edx, 38Ah
        mov esi, 5
        mov eax, edx
        sar edx, 1Fh
        idiv esi
        test edx, edx
        je short .16
.15:
        cmp cx, 36Fh
        je short .16
        cmp cx, 373h
        je short .16
        cmp cx, 377h
        je short .16
        cmp cx, 3BFh
        je short .16
        cmp cx, 3C3h
        je short .16
        cmp cx, 3CEh
        je short .16
        cmp cx, 3D1h
        jne short .17
.16:
        mov eax, 0B3h
        call sfx
.17:
        mov byte [byte ebx+046h], 4
        jmp near findpc_ret5
%endif ; C
;-----------------------------------------------------------------------------
; freezewindow                                          5CD25  94G logic94.asm
; Freezes the camera: xc1/yc1 = the camera position, sets sfslock
;-----------------------------------------------------------------------------
; C: src/engine/hockey/freezewindow.c
%ifdef CBUILD
%include "c/engine/hockey/freezewindow.inc"
%else
freezewindow:
        push dword 4
        call __CHK
        mov ax, word [camx]
        mov word [xc1], ax
        mov ax, word [camy]
        mov word [yc1], ax
        or byte [sflags], 40h
        ret
%endif ; C
;-----------------------------------------------------------------------------
; cleargamevars                                5CD4F  95 PC, medium confidence
; Clears per-game globals before StartGame
;-----------------------------------------------------------------------------
; C: src/engine/hockey/cleargamevars.c
%ifdef CBUILD
%include "c/engine/hockey/cleargamevars.inc"
%else
cleargamevars:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        xor edx, edx
        mov dword [GameVarsClear], edx
        mov dword [LastShooterTeam], edx
        mov dword [regd5], edx
        mov dword [regd4], edx
        mov dword [regd3], edx
        mov dword [regd2], edx
        mov dword [regd1], edx
        mov dword [regd0], edx
        xor edx, edx
        mov word [xc1], dx
        xor ebx, ebx
        mov word [yc1], dx
        mov word [yleader], dx
        mov word [fox], dx
        mov word [foy], dx
        xor eax, eax
        mov word [fodir1], dx
        mov word [fodir2], dx
        xor ah, dh
        mov byte [collflag], ah
        mov word [threat], dx
        mov word [lldispodd], dx
        mov word [ltack], dx
        mov word [lastsfx], 0FFFFh
        xor dl, dl
        mov byte [gmode], dl
        xor al, bl
        mov word [sflags], ax
        xor dh, dh
        mov word [gmode2], dx
        mov word [sflags3], bx
        call ClearPenaltyBuffer
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawRinkOverlays                             5CE12  95 PC, medium confidence
; Draws the rink overlay sprites (penalty box markers per PBnum, period
; marks) through DrawFrameSprite
;-----------------------------------------------------------------------------
DrawRinkOverlays:
        push dword 6Ch
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, byte 3Ch
        push eax
        push edx
        mov ax, word [c1playernum]
        mov word [byte ebp-014h], ax
        mov ax, word [c2playernum]
        mov word [byte ebp-010h], ax
        cmp dword [playsuspended], byte 0
        je short .1
        mov edx, 0FFFFFFFFh
        mov word [byte ebp-010h], dx
        mov word [byte ebp-014h], dx
.1:
        mov eax, dword [camx-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFF0h
        jle near .8
        cmp word [camy], byte 50h
        jge short .4
        mov eax, dword [camy-2]
        sar eax, 10h
        cmp eax, 0FFFFFF6Ch
        jle short .4
        xor edi, edi
        jmp short .3
.2:
        push byte 0
        mov eax, edi
        add eax, 3
        imul eax, byte 0FFFFFFF5h
        movsx ebx, ax
        xor ecx, ecx
        mov edx, 0B3h
        mov eax, 17Eh
        call DrawFrameSprite
        inc edi
.3:
        movsx ax, byte [PBnum]
        cmp di, ax
        jge short .4
        cmp di, byte 3
        jl short DrawRinkOverlays.2
.4:
        mov eax, dword [camy-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFB5h
        jle short .8
        cmp word [camy], 0B1h
        jge short .8
        mov eax, dword [PerTimeTotal]
        sar eax, 18h
        dec eax
        cmp eax, byte 2
        jl short .5
        mov eax, 2
.5:
        mov edi, eax
        jmp short .7
.6:
        push byte 1
        mov eax, edi
        add eax, 3
        imul eax, byte 0Bh
        movsx ebx, ax
        xor ecx, ecx
        mov edx, 0B3h
        mov eax, 17Eh
        call DrawFrameSprite
        dec edi
.7:
        test di, di
        jge short DrawRinkOverlays.6
.8:
        call DrawRinkObjects
        mov eax, dword [camy-2]
        sar eax, 10h
        cmp eax, 0FFFFFF50h
        jge short .9
        mov ax, word [cliprect_y1]
        mov word [byte ebp-04h], ax
        push dword 244h
        mov ebx, dword [cliprect_y0]
        push ebx
        mov ecx, dword [DrawClipRight]
        push ecx
        mov esi, dword [DrawClipLeft]
        push esi
        call SetClipWindow
        add esp, byte 10h
.9:
        xor edi, edi
        jmp short .11
.10:
        movsx edx, di
        xor ebx, ebx
        mov dword [byte ebp+edx*4-030h], ebx
        mov dword [byte ebp+edx*4-03Ch], edx
        inc edi
.11:
        cmp di, byte 3
        jl short DrawRinkOverlays.10
        mov eax, dword [puckc]
        mov dl, byte [eax]
        test dl, dl
        jl short .12
        movsx eax, dl
        shl eax, 7
        mov eax, dword [dword eax+SortCords+4]
        sar eax, 10h
        mov dword [byte ebp-028h], eax
.12:
        cmp word [byte ebp-014h], byte 0
        jl short .13
        mov eax, dword [byte ebp-016h]
        sar eax, 10h
        shl eax, 7
        mov eax, dword [dword eax+SortCords+4]
        sar eax, 10h
        mov dword [byte ebp-030h], eax
.13:
        cmp word [byte ebp-010h], byte 0
        jl short .14
        mov eax, dword [byte ebp-012h]
        sar eax, 10h
        shl eax, 7
        mov eax, dword [dword eax+SortCords+4]
        sar eax, 10h
        mov dword [byte ebp-02Ch], eax
.14:
        lea eax, [byte ebp-03Ch]
        push eax
        lea eax, [byte ebp-030h]
        push eax
        push byte 3
        call SortIndices
        add esp, byte 0Ch
        xor edx, edx
        mov word [byte ebp-0Ch], dx
        jmp near .30
.15:
        mov edi, dword [byte ebp-0Eh]
        sar edi, 10h
        mov di, word [byte ebp+edi*4-03Ch]
        cmp di, byte 2
        jne short .16
        mov eax, dword [puckc]
        mov bh, byte [eax]
        test bh, bh
        jl near .29
        movsx eax, bh
        shl eax, 7
        mov esi, SortCords
        push byte 0
        mov ebx, dword [byte esi+eax+04h]
        sar ebx, 10h
        mov edx, dword [esi+eax]
        sar edx, 10h
        mov eax, dword [markframes_e1]
        sar eax, 10h
        xor ecx, ecx
        jmp near .28
.16:
        test di, di
        je short .17
        mov eax, dword [byte ebp-010h]
        jmp short .18
.17:
        mov eax, dword [byte ebp-014h]
.18:
        test ax, ax
        jl near .29
        test di, di
        je short .19
        mov eax, dword [byte ebp-010h]
        jmp short .20
.19:
        mov eax, dword [byte ebp-014h]
.20:
        cwde
        shl eax, 7
        mov esi, SortCords
        add esi, eax
        mov eax, dword [byte esi+frame-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        je near .29
        mov cx, word [byte esi+Xpos+2]
        mov ax, word [byte esi+Ypos+2]
        xor ebx, ebx
        mov edx, dword [byte ebp-046h]
        sar edx, 10h
        lea esi, [dword edx+0A8h]
        mov dword [byte ebp-024h], esi
        mov esi, 140h
        sub esi, dword [byte ebp-024h]
        mov dword [byte ebp-024h], esi
        movsx esi, ax
        mov dword [byte ebp-018h], esi
        cmp esi, dword [byte ebp-024h]
        jge short .21
        mov eax, dword [byte ebp-044h]
        add eax, 0A8h
        mov edx, 140h
        sub edx, eax
        mov eax, edx
        mov ebx, 2
        jmp short .22
.21:
        mov esi, 140h
        sub esi, edx
        mov edx, esi
        cmp edx, dword [byte ebp-018h]
        jg short .22
        mov eax, 140h
        sub eax, dword [byte ebp-044h]
        inc eax
        mov ebx, 1
.22:
        mov edx, 0C0h
        sub edx, dword [byte ebp-040h]
        mov esi, 140h
        sub esi, edx
        mov dword [byte ebp-08h], esi
        test bx, bx
        je short .24
        mov edx, dword [byte ebp-042h]
        sar edx, 10h
        mov esi, 0C0h
        sub esi, edx
        mov dword [byte ebp-024h], esi
        mov esi, 140h
        sub esi, dword [byte ebp-024h]
        mov dword [byte ebp-024h], esi
        movsx esi, cx
        mov dword [byte ebp-01Ch], esi
        mov esi, dword [byte ebp-024h]
        sub esi, byte 0Ch
        mov dword [byte ebp-024h], esi
        mov esi, dword [byte ebp-01Ch]
        cmp esi, dword [byte ebp-024h]
        jl short .23
        mov ecx, dword [byte ebp-08h]
        sub ecx, byte 0Dh
        or bl, 4
        jmp short .26
.23:
        sub edx, 0B4h
        cmp edx, esi
        jle short .26
        mov ecx, dword [byte ebp-040h]
        sub ecx, 0B4h
        or bl, 8
        jmp short .26
.24:
        mov edx, dword [byte ebp-042h]
        sar edx, 10h
        mov esi, 0C0h
        sub esi, edx
        mov dword [byte ebp-024h], esi
        mov esi, 140h
        sub esi, dword [byte ebp-024h]
        mov dword [byte ebp-024h], esi
        movsx esi, cx
        cmp esi, dword [byte ebp-024h]
        jl short .25
        mov ecx, dword [byte ebp-08h]
        dec ecx
        mov ebx, 4
        jmp short .26
.25:
        sub edx, 0C0h
        cmp edx, esi
        jle short .26
        mov ecx, dword [byte ebp-040h]
        sub ecx, 0C0h
        mov ebx, 8
.26:
        test bx, bx
        je short .27
        push byte 0
        mov edx, ebx
        xor dh, bh
        and dl, 8
        movsx esi, dx
        cwde
        mov dword [byte ebp-024h], eax
        movsx eax, cx
        mov dword [byte ebp-020h], eax
        movsx eax, bx
        push eax
        call JoyButtonMap
        add esp, byte 4
        lea edx, [eax+eax]
        movsx eax, di
        shl eax, 4
        mov eax, dword [dword edx+eax+markframes_e1]
        sar eax, 10h
        mov ecx, esi
        mov ebx, dword [byte ebp-024h]
        mov edx, dword [byte ebp-020h]
        jmp short .28
.27:
        push byte 0
        movsx ebx, ax
        movsx edx, cx
        movsx eax, di
        mov eax, dword [nosplit eax*2+PenCntDwn2]
        sar eax, 10h
        xor ecx, ecx
.28:
        call DrawFrameSprite
.29:
        inc word [byte ebp-0Ch]
.30:
        cmp word [byte ebp-0Ch], byte 3
        jl near DrawRinkOverlays.15
        mov esi, sortobj15
        mov cx, word [sortobj15+12h]
        cmp cx, 284h
        jl short .31
        cmp cx, 288h
        jg short .31
        push byte 0
        cmp word [sortobj15+2], byte 0
        setl al
        xor ah, ah
        movsx ecx, ax
        mov ebx, dword [byte esi+Ypos]
        sar ebx, 10h
        mov edx, dword [esi]
        sar edx, 10h
        mov eax, dword [byte esi+frame-2]
        sar eax, 10h
        jmp short .34
.31:
        cmp word [byte esi+frame], 189h
        jne short .32
        mov eax, dword [puckz]
        cmp word [eax], byte 0
        jl short .32
        mov eax, dword [puckc]
        cmp byte [eax], 10h
        jne short .33
.32:
        cmp word [byte esi+Ypos+2], byte 0
        jl short .35
        mov cx, word [byte esi+frame]
        cmp cx, 22Ah
        jl short .35
        cmp cx, 237h
        jg short .35
.33:
        push byte 0
        mov ebx, dword [byte esi+Ypos]
        sar ebx, 10h
        mov edx, dword [esi]
        sar edx, 10h
        mov eax, dword [byte esi+frame-2]
        sar eax, 10h
        xor ecx, ecx
.34:
        call DrawFrameSprite
.35:
        mov eax, dword [puckc]
        cmp byte [eax], 10h
        je short .38
        sub esi, 80h
        mov bx, word [byte esi+Zpos+2]
        test bx, bx
        jne short .36
        push byte 0
        mov ebx, dword [byte esi+Ypos]
        sar ebx, 10h
        jmp short .37
.36:
        jle short .38
        push byte 0
        mov edx, dword [byte esi+Zpos]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, eax
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov edx, dword [byte esi+Ypos]
        sar edx, 10h
        add eax, edx
        movsx ebx, ax
.37:
        mov edx, dword [esi]
        sar edx, 10h
        mov eax, dword [byte esi+frame-2]
        sar eax, 10h
        xor ecx, ecx
        call DrawFrameSprite
.38:
        mov edi, 10h
        jmp near .58
.39:
        movsx eax, di
        mov eax, dword [dword eax+OOlist-3]
        sar eax, 18h
        shl eax, 7
        mov esi, SortCords
        add esi, eax
        mov ax, word [byte esi+SCnum]
        cmp ax, 0Fh
        je near .57
        cmp ax, 0Eh
        jne near .43
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jge near .57
        mov eax, dword [puckz]
        cmp word [eax], byte 0
        jle near .57
        mov eax, dword [pucky]
        mov cx, word [eax]
        cmp cx, 0E8h
        jge near .57
        movsx eax, cx
        cmp eax, 0FFFFFF18h
        jg short .42
        cmp eax, 0FFFFFF10h
        jl short .42
        mov eax, dword [puckx]
        mov dx, word [eax]
        test dx, dx
        jge short .40
        movsx eax, dx
        neg eax
        jmp short .41
.40:
        movsx eax, dx
.41:
        cmp eax, byte 14h
        jg short .42
        mov eax, dword [puckz]
        cmp word [eax], byte 0Dh
        jl near .57
.42:
        push byte 0
        mov edx, dword [byte esi+Zpos]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, eax
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov edx, dword [byte esi+Ypos]
        sar edx, 10h
        add eax, edx
        movsx ebx, ax
        mov edx, dword [esi]
        sar edx, 10h
        mov eax, dword [byte esi+010h]
        jmp near .56
.43:
        cmp word [byte esi+position], byte 0
        jge short .44
        cmp ax, 10h
        jne near .57
.44:
        mov eax, dword [byte esi+frame-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        je short .48
        cmp word [byte esi+SCnum], byte 0Ch
        jge short .48
        mov eax, dword [puckc]
        movsx ax, byte [eax]
        mov dx, word [byte esi+SCnum]
        cmp ax, dx
        je short .45
        cmp dx, word [byte ebp-014h]
        je short .45
        cmp dx, word [byte ebp-010h]
        jne short .46
.45:
        mov ecx, dword [byte esi+position-2]
        sar ecx, 10h
        xor ebx, ebx
        mov bl, byte [byte esi+rostnum]
        mov edx, dword [byte esi+Ypos]
        sar edx, 10h
        mov eax, dword [esi]
        sar eax, 10h
        jmp short .47
.46:
        cmp dword [shownumbers], byte 0
        je short .48
        xor ebx, ebx
        mov bl, byte [byte esi+rostnum]
        mov edx, dword [byte esi+Ypos]
        sar edx, 10h
        mov eax, dword [esi]
        sar eax, 10h
        mov ecx, 0FFFFFFFFh
.47:
        call DrawSpriteNumber
.48:
        cmp word [byte esi+SCnum], byte 6
        jge short .49
        push byte 0
        jmp short .50
.49:
        push byte 1
.50:
        test byte [byte esi+attribute], 8
        setne al
        xor ah, ah
        movsx ecx, ax
        mov ebx, dword [byte esi+Ypos]
        sar ebx, 10h
        mov edx, dword [esi]
        sar edx, 10h
        mov eax, dword [byte esi+frame-2]
        sar eax, 10h
        call DrawFrameSprite
        cmp word [byte esi+SCnum], byte 0Ch
        jne near .57
        mov eax, dword [puckc]
        cmp byte [eax], 10h
        je near .57
        mov eax, dword [puckx]
        mov bx, word [eax]
        test bx, bx
        jge short .51
        movsx eax, bx
        neg eax
        jmp short .52
.51:
        movsx eax, bx
.52:
        cmp eax, byte 6
        jne short .53
        mov eax, dword [pucky]
        cmp word [eax], 0F0h
        je short .55
.53:
        mov edx, dword [byte esi+Ypos]
        sar edx, 10h
        mov eax, dword [pucky]
        movsx eax, word [eax]
        add edx, byte 6
        cmp eax, edx
        jg short .57
        mov eax, dword [puckz]
        cmp word [eax], byte 0Dh
        jl short .57
        mov edx, dword [esi]
        sar edx, 10h
        mov eax, dword [puckx]
        movsx eax, word [eax]
        sub eax, edx
        test eax, eax
        jge short .54
        neg eax
.54:
        cmp eax, byte 18h
        jge short .57
.55:
        push byte 0
        mov eax, dword [puckz]
        movsx edx, word [eax]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, eax
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov edx, eax
        mov eax, dword [pucky]
        movsx eax, word [eax]
        add eax, edx
        movsx ebx, ax
        mov eax, dword [puckx]
        movsx edx, word [eax]
        mov eax, dword [puckstruct+10h]
.56:
        sar eax, 10h
        xor ecx, ecx
        call DrawFrameSprite
.57:
        dec edi
.58:
        test di, di
        jge near DrawRinkOverlays.39
        mov eax, dword [pucky]
        movsx eax, word [eax]
        cmp eax, 0FFFFFF18h
        jg near .61
        cmp eax, 0FFFFFF14h
        jl short .61
        mov eax, dword [puckx]
        mov dx, word [eax]
        test dx, dx
        jge short .59
        movsx eax, dx
        neg eax
        jmp short .60
.59:
        movsx eax, dx
.60:
        cmp eax, byte 14h
        jg short .61
        mov eax, dword [puckz]
        mov bx, word [eax]
        cmp bx, byte 0Dh
        jl short .61
        push byte 0
        movsx edx, bx
        mov eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, eax
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov edx, dword [pucky]
        movsx edx, word [edx]
        add eax, edx
        movsx ebx, ax
        mov eax, dword [puckx]
        movsx edx, word [eax]
        mov eax, dword [puckstruct+10h]
        sar eax, 10h
        xor ecx, ecx
        call DrawFrameSprite
.61:
        mov eax, dword [camy-2]
        sar eax, 10h
        cmp eax, 0FFFFFF50h
        jge short .62
        mov eax, dword [byte ebp-06h]
        sar eax, 10h
        push eax
        mov edi, dword [cliprect_y0]
        push edi
        mov eax, dword [DrawClipRight]
        push eax
        mov edx, dword [DrawClipLeft]
        push edx
        call SetClipWindow
        add esp, byte 10h
.62:
        mov eax, dword [camy-2]
        sar eax, 10h
        cmp eax, 0FFFFFF70h
        jge short .63
        call DrawRinkEndArt
.63:
        cmp word [sortobj15+6], byte 0
        jge short .64
        mov si, word [sortobj15+12h]
        cmp si, 22Ah
        jl short .64
        cmp si, 237h
        jg short .64
        push byte 0
        mov ebx, dword [sortobj15+4]
        sar ebx, 10h
        mov edx, dword [sortobj15]
        sar edx, 10h
        mov eax, dword [sortobj15+10h]
        sar eax, 10h
        xor ecx, ecx
        call DrawFrameSprite
.64:
        mov eax, dword [pucky]
        movsx eax, word [eax]
        cmp eax, 0FFFFFEF8h
        jge short .67
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jge short .67
        mov ax, word [puckstruct+0Ah]
        test ax, ax
        jne short .65
        push byte 0
        mov ebx, dword [puckstruct+4]
        sar ebx, 10h
        jmp short .66
.65:
        jle short .67
        push byte 0
        mov edx, dword [puckstruct+8]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, eax
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov edx, dword [puckstruct+4]
        sar edx, 10h
        add eax, edx
        movsx ebx, ax
.66:
        mov edx, dword [puckstruct]
        sar edx, 10h
        mov eax, dword [puckstruct+10h]
        sar eax, 10h
        xor ecx, ecx
        call DrawFrameSprite
.67:
        cmp word [ovltimer], byte 0
        jl short .68
        call DrawTextOverlay
.68:
        mov eax, dword [bannermsg-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        je short .69
        call DrawCallBanner
        mov cx, word [bannertimer]
        test cx, cx
        jle short .69
        mov esi, ecx
        dec esi
        mov word [bannertimer], si
        test si, si
        jg short .69
        xor eax, eax
        mov word [bannertimer], ax
        mov word [bannermsg], 0FFFFh
.69:
        cmp byte [pad1dev], 1
        je short .70
        cmp byte [pad2dev], 1
        jne near .77
.70:
        cmp dword [curperiod], byte 0FFFFFFFFh
        je near .77
        cmp dword [playsuspended], byte 0
        jne near .77
        cmp byte [pad1dev], 1
        jne short .71
        mov eax, dword [byte ebp-014h]
        jmp short .72
.71:
        mov eax, dword [byte ebp-010h]
.72:
        mov edi, eax
        cwde
        cmp eax, byte 0FFFFFFFFh
        je near .77
        mov edx, dword [mousex]
        sub edx, 0A0h
        imul edx, edx
        mov eax, dword [mousey]
        sub eax, byte 64h
        imul eax, eax
        add eax, edx
        cmp eax, 9C4h
        jge short .73
        xor eax, eax
        xor ecx, ecx
        mov ebx, 8
        jmp short .74
.73:
        mov eax, 64h
        sub ax, word [mousey]
        movsx edx, ax
        mov ax, word [mousex]
        db 081h,0E8h,0A0h,00h,00h,00h           ; insn: sub eax,0A0h
        cwde
        call vtoa
        mov ebx, eax
        mov ax, word [mousex]
        db 081h,0E8h,0A0h,00h,00h,00h           ; insn: sub eax,0A0h
        cwd
        shl dx, 2
        LD sbb, ax, dx
        sar ax, 2
        mov ecx, eax
        mov edx, 64h
        mov esi, dword [mousey]
        sub edx, esi
        mov eax, edx
        sar edx, 1Fh
        shl edx, 2
        LD sbb, eax, edx
        sar eax, 2
.74:
        movsx edx, di
        shl edx, 7
        add cx, word [dword edx+SortCords+2]
        add ax, word [dword edx+SortCords+6]
        push byte 0
        cmp bx, byte 4
        jle short .75
        cmp bx, byte 8
        jge short .75
        mov edx, 1
        jmp short .76
.75:
        xor edx, edx
.76:
        movsx edx, dx
        movsx edi, ax
        movsx esi, cx
        movsx eax, bx
        mov eax, dword [nosplit eax*4+AimArrowFrames_m2]
        sar eax, 10h
        mov ecx, edx
        mov ebx, edi
        mov edx, esi
        call DrawFrameSprite
.77:
        mov esp, ebp
        jmp near changeplayer_ret5
;-----------------------------------------------------------------------------
; setupice                       5D7F7  93G hockey93_06.asm, medium confidence
; setupice role: per-period rink setup, gmdir flips pfgoal of the
; players, defaultsprites2
;-----------------------------------------------------------------------------
; C: src/engine/hockey/setupice.c
%ifdef CBUILD
%include "c/engine/hockey/setupice.inc"
%else
setupice:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        and byte [sflags], 0FEh
        xor edx, edx
        mov word [camx], dx
        mov word [camy], dx
        call defaultsprites_0
        test byte [gmode], 2
        je short .3
        mov eax, SortCords
        xor edx, edx
        jmp short .2
.1:
        xor byte [byte eax+044h], 80h
        inc edx
        add eax, 80h
.2:
        cmp dx, byte 0Ch
        jl short setupice.1
.3:
        mov bh, 0FFh
        mov byte [c1playernum+1], bh
        mov byte [c2playernum+1], bh
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; clockcont_0                    5D852  93G hockey93_01.asm, medium confidence
; (end of period). Puck assinsert 18h; periods 1-2 -> PeriodOver path
; later periods compare hmscore/awscore for overtime shootout game over. Also called from puckfaceoff.
;-----------------------------------------------------------------------------
; C: src/engine/control/findpc.c (clockcont_0)
%ifdef CBUILD
%include "c/engine/control/findpc.clockcont_0.inc"
%else
clockcont_0:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov edx, 18h
        mov eax, puckstruct
        call assinsert
        cmp word [gsp], byte 2
        jge short .1
        mov edx, 1
        mov eax, puckstruct
        jmp near .31
.1:
        mov word [regd0], 7
        mov edx, dword [awscore-2]
        sar edx, 10h
        mov eax, dword [hmscore-2]
        sar eax, 10h
        call IsCupClinched
        test eax, eax
        je short .2
        mov word [regd0], 8
.2:
        mov ecx, SortCords
        mov ax, word [hmscore]
        mov si, word [awscore]
        sub ax, si
        mov word [regd1], ax
        jne near .8
        cmp word [gsp], byte 3
        jne near .7
        test byte [gameopts+1], 2
        je near .7
        call ClearPenaltyBuffer
        mov di, word [Crowdlevel]
        cmp di, 4B0h
        jg short .3
        mov eax, edi
        add eax, 384h
        mov word [Crowdlevel], ax
        cmp ax, 4B0h
        jle short .3
        mov word [Crowdlevel], 4B0h
.3:
        or byte [gmode], 41h
        xor esi, esi
        mov word [regd2], si
        add word [CwdExciteLvl], byte 28h
        jmp short .5
.4:
        mov eax, dword [regd2-2]
        sar eax, 10h
        shl eax, 7
        and byte [dword eax+SortCords+44h], 0F7h
        mov esi, ebx
        inc esi
        mov word [regd2], si
.5:
        mov bx, word [regd2]
        cmp bx, byte 0Ch
        jl short clockcont_0.4
        mov edx, 2
.6:
        mov eax, ecx
        jmp near .31
.7:
        mov edx, 1
        jmp short clockcont_0.6
.8:
        mov edx, 0FFFFFFFFh
        mov word [c2playernum], dx
        mov word [c1playernum], dx
        mov eax, dword [puckc]
        mov byte [eax], 0FFh
        mov eax, dword [puckstruct+1Ah]
        sar eax, 10h
        add eax, puckstruct
        cmp byte [byte eax+01Eh], 18h
        jne short .9
        mov edx, 1Ah
        mov eax, puckstruct
        call assreplace
.9:
        xor ecx, ecx
        mov word [regd2], cx
        jmp short .11
.10:
        mov eax, dword [regd2-2]
        sar eax, 10h
        shl eax, 7
        and byte [dword eax+SortCords+44h], 0F7h
        inc word [regd2]
.11:
        cmp word [regd2], byte 0Ch
        jl short clockcont_0.10
        cmp word [regd1], byte 0
        jge short .12
        mov eax, 6
        jmp short .13
.12:
        xor eax, eax
.13:
        shl eax, 7
        mov ecx, SortCords
        add ecx, eax
        cmp word [regd1], byte 0
        setl al
        and eax, 0FFh
        call SetBoxDoorObject
        cmp word [regd0], byte 8
        jne near .17
        mov byte [cupceremony], 1
        or byte [gmode], 80h
        mov edx, 2Bh
        mov eax, sortobj15
        call assinsert
        mov esi, 9C40h
        mov di, word [byte ecx+SCnum]
        xor eax, eax
        mov word [regd2], ax
        jmp short .16
.14:
        cmp word [byte ecx+position], byte 0
        jle short .15
        mov eax, dword [ecx]
        sar eax, 10h
        add eax, 91h
        mov edx, dword [byte ecx+Ypos]
        sar edx, 10h
        sub edx, byte 6
        imul eax, eax
        imul edx, edx
        add eax, edx
        cmp eax, esi
        jg short .15
        mov esi, eax
        mov di, word [byte ecx+SCnum]
.15:
        inc word [regd2]
        add ecx, 80h
.16:
        cmp word [regd2], byte 6
        jl short clockcont_0.14
.17:
        cmp word [regd1], byte 0
        jge short .18
        mov eax, 6
        jmp short .19
.18:
        xor eax, eax
.19:
        shl eax, 7
        mov ecx, SortCords
        add ecx, eax
        mov word [shotplayer], 0FFFFh
        xor eax, eax
        mov word [regd1], ax
        mov word [regd2], 6
.20:
        mov ax, word [byte ecx+position]
        test ax, ax
        jle short .23
        cmp word [regd0], byte 8
        jne short .22
        cmp di, word [byte ecx+SCnum]
        jne short .22
        mov edx, 8
        mov eax, ecx
        call assinsert
        mov edx, 2Ah
.21:
        mov eax, ecx
        call assinsert
        jmp near .27
.22:
        mov edx, 7
        jmp short clockcont_0.21
.23:
        jge short .27
        mov esi, dword [byte ecx+06Ch]
        movsx bx, byte [dword esi+tmboxlist]
        test bx, bx
        jl short .27
        cmp word [regd1], byte 0
        je short .24
        mov eax, 3
        jmp short .25
.24:
        mov eax, 5
.25:
        mov word [byte ecx+position], ax
        inc word [regd1]
        mov edx, 7
        mov eax, ecx
        call assinsert
        movsx edx, bx
        mov eax, ecx
        call setplayer
        mov ebx, 1
.26:
        movsx eax, bx
        mov dl, byte [dword esi+eax+0B6h]
        mov byte [dword esi+eax+0B5h], dl
        test dl, dl
        jl short .27
        inc ebx
        jmp short clockcont_0.26
.27:
        add ecx, 80h
        mov ax, word [regd2]
        dec ax
        mov word [regd2], ax
        jne near clockcont_0.20
        call ClearPenaltyBuffer
        mov ax, word [hmscore]
        cmp ax, word [awscore]
        jle short .29
        mov ax, word [Crowdlevel]
        cmp ax, 5DCh
        jg short .28
        mov edx, eax
        add edx, 3E8h
        mov word [Crowdlevel], dx
        cmp dx, 5DCh
        jle short .28
        mov word [Crowdlevel], 5DCh
.28:
        cmp word [regd0], byte 8
        jne short .30
        add word [Crowdlevel], 320h
        jmp short .30
.29:
        cmp word [Crowdlevel], 320h
        jge short .30
        mov word [Crowdlevel], 320h
.30:
        or byte [gmode], 41h
        add word [CwdExciteLvl], byte 28h
        mov edx, 2
        mov eax, ecx
.31:
        call AddPenalty2
        jmp near findpc_ret5
%endif ; C
;-----------------------------------------------------------------------------
; ClockTick                                    5DC10  95 PC, medium confidence
; run from the main loop.
;
; Counts clockticks (18h per second) and gameclock down; horn sfx 97h at 60 s
; (unless music plays), UpdateCoachModes each second. Debug playback
; (penshotlive) ends via EndPenaltyShot.
;-----------------------------------------------------------------------------
; C: src/engine/hockey/ClockTick.c
%ifdef CBUILD
%include "c/engine/hockey/ClockTick.inc"
%else
ClockTick:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push edi
        cmp dword [penshotlive], byte 0
        je short .1
        mov edi, dword [penshottimer]
        dec edi
        mov dword [penshottimer], edi
        test edi, edi
        jg near .x
        call EndPenaltyShot
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        cmp word [gameclock], byte 0
        jne short .2
        cmp word [clockticks], byte 0
        je near .x
.2:
        mov cx, word [clockticks]
        dec ecx
        mov word [clockticks], cx
        test cx, cx
        jge near .x
        mov di, word [gameclock]
        test di, di
        jle short .3
        mov edx, edi
        dec edx
        mov word [gameclock], dx
        mov ebx, ecx
        add ebx, byte 18h
        mov word [clockticks], bx
        jmp short .4
.3:
        xor eax, eax
        mov word [clockticks], ax
.4:
        mov cx, word [gameclock]
        cmp cx, byte 3Dh
        je short .5
        cmp cx, byte 3Ch
        jne short .8
.5:
        cmp byte [MusicOn], 0
        je short .6
        test byte [gameopts+1], 1
        jne short .7
.6:
        mov eax, 97h
        call sfx
        jmp short .8
.7:
        cmp word [gameclock], byte 3Ch
        jne short .8
        mov dx, word [joysampling]
        mov word [joysampling_save], dx
        xor ebx, ebx
        mov dword [joysampling], ebx
        call PaOneMinuteLeft
        mov edx, dword [joysampling_save-2]
        sar edx, 10h
        mov dword [joysampling], edx
.8:
        mov edx, dword [gameclock-2]
        sar edx, 10h
        mov ebx, 3Ch
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        test edx, edx
        jne short .x
        cmp dword [curperiod], byte 3
        jne short .9
        mov ax, word [gameclock]
        cmp ax, 3Ch
        je short .10
        cmp ax, 78h
        je short .10
        cmp ax, 0B4h
        je short .10
        cmp ax, 12Ch
        je short .10
        cmp ax, 258h
        je short .10
.9:
        cmp dword [curperiod], byte 2
        jne short .x
        cmp word [gameclock], 258h
        jne short .x
.10:
        call UpdateCoachModes
.x:
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SprSortVert                                  5DD6B  95 PC, medium confidence
; Clears sfhor and falls into SprSort
;-----------------------------------------------------------------------------
; C: src/engine/chgplayer/SetSPA.c (SprSortVert)
%ifdef CBUILD
%include "c/engine/chgplayer/SetSPA.SprSortVert.inc"
%else
SprSortVert:
        push dword 4
        call __CHK
        and byte [sflags], 7Fh
;-----------------------------------------------------------------------------
; SprSort                                           5DD7C  93G hockey93_06.asm
; Copies each sort object's y (x when sfhor) to Ylist (SprSort_loop), then bubble
; sorts OOlist by Ylist and records each object's position in OOlistpos.
;-----------------------------------------------------------------------------
SprSort:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        sub esp, byte 0Ch
        mov eax, Ylist
        mov ecx, SortCords
        xor ebx, ebx
        jmp near SprSort_test
%endif ; C
;-----------------------------------------------------------------------------
; GameOver                       5DD9E  93G hockey93_06.asm, medium confidence
; Game over: sets the main-loop request flag CBC48 (IntermissionStart when
; gsp = 4)
;-----------------------------------------------------------------------------
; C: src/engine/hockey/GameOver.c
%ifdef CBUILD
%include "c/engine/hockey/GameOver.inc"
%else
GameOver:
        push dword 4
        call __CHK
        cmp word [gameover], byte 0
        jne short .x
        mov word [gameover], 1
.x:
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SetExitGame                                  5DDBC  95 PC, medium confidence
; Sets the main-loop request flag CBC46 (assignment caller)
;-----------------------------------------------------------------------------
; C: src/engine/hockey/SetExitGame.c
%ifdef CBUILD
%include "c/engine/hockey/SetExitGame.inc"
%else
SetExitGame:
        push dword 4
        call __CHK
        cmp word [exitgame], byte 0
        jne short .x
        mov word [exitgame], 1
.x:
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SetupTeamForIntermission                          5DDDA  93G penalty93_2.asm
; SetupTeamForIntermission: ResetBench, reenergizeteam both teams, tmline
; 0/3/5 by tmap difference
;-----------------------------------------------------------------------------
; C: src/engine/hockey/SetupTeamForIntermission.c
%ifdef CBUILD
%include "c/engine/hockey/SetupTeamForIntermission.inc"
%else
SetupTeamForIntermission:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        call ResetBench
        xor ecx, ecx
        mov edx, hmtmstruct
        mov ebx, awtmstruct
        jmp short .4
.1:
        mov eax, edx
        call reenergizeteam
        mov word [byte edx+02Ah], 0
        test byte [gameopts], 4
        je short .3
        mov ax, word [byte edx+036h]
        sub ax, word [byte ebx+036h]
        je short .3
        test ax, ax
        jle short .2
        mov word [byte edx+02Ah], 4
        jmp short .3
.2:
        mov word [byte edx+02Ah], 6
.3:
        mov edx, awtmstruct
        mov ebx, hmtmstruct
        inc ecx
.4:
        cmp cx, byte 2
        jl short SetupTeamForIntermission.1
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; Intermission                   5DE42  93G penalty93_2.asm, medium confidence
; Intermission start: SetupTeamForIntermission and clear the SortCords
; positions
;-----------------------------------------------------------------------------
; C: src/engine/hockey/Intermission.c
%ifdef CBUILD
%include "c/engine/hockey/Intermission.inc"
%else
Intermission:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        call SetupTeamForIntermission
        xor eax, eax
        jmp short .2
.1:
        movsx edx, ax
        shl edx, 7
        xor ebx, ebx
        mov word [dword edx+SortCords+2], bx
        inc eax
.2:
        cmp ax, 11h
        jl short Intermission.1
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; PeriodOver_sp                                         5DE70  94G setup94.asm
; gsp 4 -> GameOver; else Intermission, StartPer, SetPenaltyStrength.
;-----------------------------------------------------------------------------
; C: src/engine/hockey/PeriodOver_sp.c
%ifdef CBUILD
%include "c/engine/hockey/PeriodOver_sp.inc"
%else
PeriodOver_sp:
        push dword 4
        call __CHK
        cmp word [gsp], byte 4
        je near GameOver
        call Intermission
        cmp word [gsp], byte 0
        jle short .1
        call IntermissionPC
.1:
        call StartPer
        jmp near SetPenaltyStrength
%endif ; C
;-----------------------------------------------------------------------------
; PeriodOver                                        5DEA6  93G hockey93_06.asm
; Line change box reset, gsp+1, gmdir flips; after the 3rd period:
; overtime (gameopts+1 bit 1 = playoffs) or game over (gsp 4) unless tied; then PeriodOver_sp.
;-----------------------------------------------------------------------------
; C: src/engine/hockey/PeriodOver.c
%ifdef CBUILD
%include "c/engine/hockey/PeriodOver.inc"
%else
PeriodOver:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push edi
        xor edx, edx
        mov word [energywarn+2], dx
        mov word [energywarn], dx
        mov word [lcblink+2], dx
        mov word [lcblink], dx
        mov edi, 0FFFFFFFFh
        mov word [lcline+2], di
        mov word [lcline], di
        mov word [lcboxon+2], dx
        mov word [lcboxon], dx
        mov eax, dword [exitgame-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        je near .3
        mov ah, byte [gmode]
        xor ah, 2
        mov byte [gmode], ah
        mov cx, word [gsp]
        inc ecx
        mov word [gsp], cx
        cmp cx, byte 3
        jl short .3
        jle short .1
        mov word [gsp], 3
        test byte [gameopts+1], 2
        je short .2
        mov word [gsp], 4
        jmp short .2
.1:
        test byte [gameopts+1], 2
        je short .2
        mov dh, ah
        xor dh, 2
        mov byte [gmode], dh
.2:
        mov ax, word [hmscore]
        mov bx, word [awscore]
        sub ax, bx
        mov word [regd0], ax
        je short .3
        mov word [gsp], 4
.3:
        call PeriodOver_sp
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ResetBench                                          5DF86  94G collide94.asm
; Per team: PBnum = players with penalty time left (tmpdst > 0), all others
; not dressed back to the bench (tmpdst -2, roster status 3).
;-----------------------------------------------------------------------------
; C: src/engine/control/findpc.c (ResetBench)
%ifdef CBUILD
%include "c/engine/control/findpc.ResetBench.inc"
%else
ResetBench:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        xor edi, edi
        mov ecx, hmtmstruct
        jmp near .7
.1:
        movsx eax, di
        xor dl, dl
        mov byte [dword eax+PBnum], dl
        mov edx, 1Bh
        jmp short .6
.2:
        movsx ebx, dx
        lea eax, [ebx+ebx]
        add eax, ecx
        mov si, word [byte eax+tmpdst]
        test si, si
        jle short .4
        test byte [byte eax+tmpdst+1], 10h
        je short .3
        test si, 7FFh
        je short .5
.3:
        movsx eax, di
        inc byte [dword eax+PBnum]
        jmp short .5
.4:
        mov esi, dword [byte eax+tmpdst-2]
        sar esi, 10h
        cmp esi, byte 0FFFFFFFDh
        jle short .5
        mov word [byte eax+tmpdst], 0FFFEh
        mov eax, ebx
        shl eax, 2
        add eax, ebx
        shl eax, 3
        sub eax, ebx
        mov ebx, dword [dword ecx+tmroster]
        mov byte [ebx+eax], 3
.5:
        dec edx
.6:
        test dx, dx
        jge short ResetBench.2
        mov ecx, awtmstruct
        inc edi
.7:
        cmp di, byte 2
        jl short ResetBench.1
        jmp near findpc_ret5
%endif ; C
;-----------------------------------------------------------------------------
; resetplstuff                       5E01A  94G setup94.asm, medium confidence
; For both teams clear tmflags bit 4, and for the 6 SortCords entries of the
; team: pflags2 0; a player on the ice (position >= 0) gets SPA 289h, nopuck
;
; and impact 0 and pflags bits 0, 2-5 cleared.
;-----------------------------------------------------------------------------
; C: src/engine/hockey/resetplstuff.c
%ifdef CBUILD
%include "c/engine/hockey/resetplstuff.inc"
%else
resetplstuff:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        xor esi, esi
        mov ebx, hmtmstruct
        jmp short .5
.1:
        and byte [byte ebx+tmflags], 0EFh
        mov ebx, dword [dword ebx+tmsort]
        xor ecx, ecx
        jmp short .4
.2:
        mov byte [byte ebx+pflags2], 0
        cmp word [byte ebx+position], byte 0
        jl short .3
        mov edx, SPAglide
        mov eax, ebx
        call SetSPA
        mov word [byte ebx+03Eh], 0
        mov ax, word [byte ebx+03Eh]
        mov word [byte ebx+018h], ax
        and byte [byte ebx+pflags], 0C2h
.3:
        add ebx, 80h
        inc ecx
.4:
        cmp cx, byte 6
        jl short resetplstuff.2
        mov ebx, awtmstruct
        inc esi
.5:
        cmp si, byte 2
        jl short resetplstuff.1
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; StartGame                      5E086  93G hockey93_01.asm, medium confidence
; role. cleargamevars, clearteams, gsp = 0, restoreteams, PeriodOver_sp.
;-----------------------------------------------------------------------------
; C: src/engine/hockey/StartGame.c
%ifdef CBUILD
%include "c/engine/hockey/StartGame.inc"
%else
StartGame:
        push dword 8
        call __CHK
        push edx
        call cleargamevars
        call clearteams
        xor edx, edx
        mov word [gsp], dx
        call restoreteams
        call PeriodOver_sp
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; forceteams                                   5E0B0  95 PC, medium confidence
; Setpersonel + forcepldata for both teams
;-----------------------------------------------------------------------------
; C: src/engine/hockey/forceteams.c
%ifdef CBUILD
%include "c/engine/hockey/forceteams.inc"
%else
forceteams:
        push dword 4
        call __CHK
        mov eax, hmtmstruct
        call setpersonel
        mov eax, hmtmstruct
        call forcepldata
        mov eax, awtmstruct
        call setpersonel
        mov eax, awtmstruct
;-----------------------------------------------------------------------------
; forcepldata                                         5E0DD  94G collide94.asm
; (no skating on/off, faceoffs only). eax = team: newpos -> position,
; Setplass, center gets anearest (11h), tmpdst -1, setplayer with newpnum.
;-----------------------------------------------------------------------------
; C: src/engine/hockey/forcepldata.c
%ifdef CBUILD
%include "c/engine/hockey/forcepldata.inc"
%else
forcepldata:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov ecx, eax
        mov ebx, dword [dword eax+tmsort]
        mov esi, 6
.1:
        movsx ax, byte [byte ebx+newpos]
        mov word [byte ebx+position], ax
        test ax, ax
        jl short .3
        mov eax, ebx
        call Setplass
        cmp word [byte ebx+position], byte 4
        jne short .2
        mov edx, 11h
        mov eax, ebx
        call assinsert
.2:
        mov eax, dword [byte ebx+040h]
        sar eax, 18h
        mov word [byte ecx+eax*2+tmpdst], 0FFFFh
        mov edx, dword [byte ebx+040h]
        sar edx, 18h
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 3
        sub eax, edx
        mov edx, dword [dword ecx+tmroster]
        mov byte [edx+eax], 4
        mov edx, dword [byte ebx+040h]
        sar edx, 18h
        mov eax, ebx
        call setplayer
.3:
        mov byte [byte ebx+newpnum], 0FFh
        mov byte [byte ebx+newpos], 0FFh
        add ebx, 80h
        dec si
        jne short forcepldata.1
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
%endif ; C
