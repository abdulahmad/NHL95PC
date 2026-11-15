; The frame of a period. Who has the puck, the clock, line changes, goals,
; bench energy, and the loop that runs every player's assignment.
bits 32
%include "hockey.inc"
section s_59D9A progbits alloc exec nowrite align=1
extern __CHK, AddPenalty, AddPenalty2, assinsert, assreplace, asstab, awlinetab, awroster
extern awscore, awteamrec, awtmglstats, awtmgoalie, awtmlcnt, awtmline, awtmlines, awtmpbox
extern awtmplstats, awtmptrF2, awtmroster, awtmsort, awtmstruct, bannermsg, bannertimer, priolist
extern HotStickList, HotStickList_y, cupceremony, hmtmcoach_d2, hmtmcoach_d3, hmtmcoachflags, hmtmcoachmode, awtmcoach_d2
extern awtmcoach_d3, awtmcoachflags, awtmcoachmode, refasslist, refweight, reflegstr, reflegspd, byte_E038A
extern goalevent, defsort_d, offsort_fwd, c1playernum, c2playernum, camx, camx_m2, camy
extern checkcoll, checkwindow, ChkGoalies, ChkShotStat, ClearPenaltyBuffer, cliprect_y0, cliprect_y1, clockticks
extern collflag, cont1team, cont2team, crowdlevel, curperiod, CwdExciteLvl, DecayCrowdLevel, doinput
extern DrawCallBanner, DrawFrameSprite, DrawPanelLine, DrawPanelScore, DrawRinkEndArt, DrawRinkObjects, DrawSpriteNumber, DrawTextOverlay
extern ds2list, markframes_e1, playsuspended, dword_CCC9E, sublist_m2, sublist_defl_m3, dword_CCD4F, dword_D30BC
extern dword_D30C0, hmplstats, hmtmextra, hmtmnear, hmtmcoachenergy, hmtmplattr, hmtmglattr, awtmnear
extern awtmcoachenergy, awtmplattr, awtmglattr, SumCwdExciteLvl, dword_E03A8, regd3_m2, dword_E9A9E, dword_E9AB6
extern EndPenaltyShot, energywarn, exitgame, fadeinpending, fodir1, fodir2, fox, foy
extern gameclock, gameopts, gameover, gmode, gmode2, gsp, hmlinetab, hmroster
extern hmscore, hmteamrec, hmtmglstats, hmtmgoalie, hmtmlcnt, hmtmline, hmtmlines, hmtmpbox
extern hmtmplstats, hmtmptrF2, hmtmroster, hmtmsort, hmtmstruct, HotList, HotList_y, IntermissionPC
extern IsCupClinched, joysampling, joysampling_save, lastplayer, lastsfx, lasttouch, lcblink, lcboxon
extern lcline, lcrequest, lldisp, lldispodd, ltack, ltx, lty, mousex
extern mousey, musicon, coachlinetab, onetimerflag, OOlist, OOlistpos, ovlseq, ovltimer
extern pad1dev, pad2dev, PaOneMinuteLeft, PBnum, PenaltyManager, PenBuf, Pencntdwn, PenGoalStuff
extern penshotfox, penshotfoy, penshotlive, penshotmode, penshotplayer, penshotstart, penshotteam, penshottimer
extern periodendtime, PerTimeTab, PerTimeTotal, PlayCrowdSample, PlList, priolist_m1, puckc, puckcross
extern puckstruct, puckvx, puckvy, puckx, pucky, puckz, randomd0, ReadJoy1
extern ReadJoy2, recbpr, RefStep, regd0, regd1, regd2, regd3, regd4
extern ReplayRecordReset, replaystart, rinkscrollx, rinkscrolly, SetBoxDoorObject, SetPenaltyStrength, Setplass_alist, sflags
extern sflags3, sfx, shotongoal, shotontarget, shotplayer, shownumbers, SortCords, sortobj15
extern SPAtab, SortIndices, sub_B340B, SetClipWindow, sublist, Sweepcheck, threat, sublist_defl
extern hmglattr, awglattr, hmplattr, awplattr, awplstats, hmglstats, awglstats, offsort_d
extern defsort_fwd, UpdatePowerPlayFlags, updatereplay, vecdist, vtoa, word_CBC44, injurystop, Pencntdwn2
extern restoreteams_pdsttab, hmtmnearpl, hmtmgoaliesc, awtmextra, awtmnearpl, awtmgoaliesc, refposition, word_E03A0
extern regd5, MaxCwdExciteLvl, NumCwdExciteLvl, word_E9AB0, xc1, yc1, yleader, Ylist
global SetSPA, SprSort_loop, SprSort_test, changeplayer, changeplayer_ret5, restorepl, AvgCline, CompLine
global getlinee_pp, getlinee_sum, TeamLineEnergy, getlinee, findpc, findpc_ret6, findpc_ret5, GetHot
global GetHotStick, GetHotOrStick, SetCoachMode, InitCoachModes, UpdateCoachModes, PenTeamScored, Goal, GiveControl
global Setplass, setplayer, reenergizeteam, clearteams, restoreteams, GetPeriodTime, ResetClock, ClearSortCords
global defaultsprites_0, TryAddPlayerToList, SetPlList, setpersonel, StartPer, DoGameFrame, RestoreBenchEnergy, updatecrowdf
global periodicevents, updateplayers, updateanim, freezewindow, cleargamevars, DrawRinkOverlays, setupice, clockcont_0
global ClockTick, SprSortVert, SprSort, GameOver, SetExitGame, SetupTeamForIntermission, Intermission, PeriodOver_sp
global PeriodOver, ResetBench, resetplstuff, StartGame, forceteams, forcepldata
;-----------------------------------------------------------------------------
; SetSPA                                                59D9A  94G logic94.asm
;-----------------------------------------------------------------------------
; C: src/engine/hockey/SetSPA.c
%ifdef CBUILD
%include "c/engine/hockey/SetSPA.inc"
%else
SetSPA:
        push dword 4
        call __CHK
        cmp dx, word [byte eax+SPA]
        je short .x
        mov word [byte eax+SPAnum], 0
        mov word [byte eax+SPA], dx
        mov word [byte eax+SPAcnt], 0FFFFh
.x:
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SprSort_loop                                                    59DBB  95 PC
;-----------------------------------------------------------------------------
; C: src/engine/hockey/SetSPA.c (SprSort_loop)
%ifdef CBUILD
%include "c/engine/hockey/SetSPA.SprSort_loop.inc"
%else
SprSort_loop:
        lea esi, [byte eax+02h]
        test byte [sflags], 80h
        je short .1
        mov dx, word [byte ecx+02h]
        jmp short .2
.1:
        mov dx, word [byte ecx+06h]
.2:
        mov word [eax], dx
        mov eax, esi
        add ecx, 80h
        inc ebx
SprSort_test:
        cmp bx, byte 11h
        jl short SprSort_loop
.1:
        xor dh, dh
        mov byte [byte esp+08h], dh
        mov eax, OOlist
        xor dl, dl
        xor ebx, ebx
        jmp short .4
.2:
        mov ecx, eax
        movsx si, byte [eax]
        mov word [byte esp+04h], si
        inc eax
        movsx si, byte [eax]
        mov word [esp], si
        movsx esi, byte [ecx]
        movsx ecx, byte [eax]
        inc edx
        mov si, word [nosplit esi*2+Ylist]
        cmp si, word [nosplit ecx*2+Ylist]
        jle short .3
        mov cl, byte [byte esp+04h]
        mov byte [eax], cl
        mov cl, byte [esp]
        mov byte [byte eax-01h], cl
        mov ecx, dword [byte esp+02h]
        sar ecx, 10h
        mov word [nosplit ecx*2+OOlistpos], dx
        mov esi, edx
        dec esi
        mov ecx, dword [byte esp-02h]
        sar ecx, 10h
        mov word [nosplit ecx*2+OOlistpos], si
        mov byte [byte esp+08h], 1
.3:
        inc ebx
.4:
        cmp bx, byte 10h
        jl short SprSort_test.2
        cmp byte [byte esp+08h], 0
        jne short SprSort_test.1
        add esp, byte 0Ch
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; changeplayer                                        59E69  93G logic93_1.asm
; Human control moves to the best teammate (Sweepcheck); restorepl gives
; the old player his assignment back. Callers: input, physics, player logic, assignments.
;-----------------------------------------------------------------------------
changeplayer:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        mov ebp, eax
        mov dword [byte esp+04h], edx
        mov edx, dword [puckvx]
        movsx edx, word [edx]
        sar edx, 8
        mov eax, dword [puckx]
        movsx eax, word [eax]
        add eax, edx
        mov word [esp], ax
        mov edx, dword [puckvy]
        movsx edx, word [edx]
        sar edx, 8
        mov eax, dword [pucky]
        movsx eax, word [eax]
        add eax, edx
        mov word [byte esp+08h], ax
        mov edi, 0FFFFFFFFh
        cmp word [byte esp+04h], byte 0
        je short .1
        mov ax, word [cont2team]
        jmp short .2
.1:
        mov ax, word [cont1team]
.2:
        cmp ax, 1
        je short .3
        mov eax, SortCords+300h
        jmp short .4
.3:
        mov eax, SortCords
.4:
        mov dx, word [byte ebp+06Ah]
        mov word [byte esp+0Ch], dx
        mov edx, 6
.5:
        cmp word [byte eax+position], byte 0
        jle short .8
        test byte [byte eax+pflags2], 4
        jne short .8
        test byte [byte eax+pflags], 20h
        jne short .8
        mov ecx, dword [eax]
        sar ecx, 10h
        mov ebx, dword [byte esp-02h]
        sar ebx, 10h
        sub ebx, ecx
        mov esi, dword [byte eax+Ypos]
        sar esi, 10h
        mov ecx, dword [byte esp+06h]
        sar ecx, 10h
        sub ecx, esi
        imul ebx, ebx
        imul ecx, ecx
        add ebx, ecx
        cmp ebx, edi
        ja short .8
        mov si, word [byte eax+SCnum]
        cmp word [byte esp+04h], byte 0
        je short .6
        mov cx, word [c1playernum]
        jmp short .7
.6:
        mov cx, word [c2playernum]
.7:
        cmp si, cx
        je short .8
        mov edi, ebx
        mov word [byte esp+0Ch], si
.8:
        add eax, 80h
        dec dx
        jne short changeplayer.5
        cmp word [byte esp+04h], byte 0
        je short .9
        mov ax, word [c2playernum]
        jmp short .10
.9:
        mov ax, word [c1playernum]
.10:
        mov edi, dword [byte esp+0Ch]
        cmp ax, di
        jne short .11
        mov eax, ebp
        call Sweepcheck
        jmp short .13
.11:
        cmp word [byte esp+04h], byte 0
        jne short .12
        cmp di, word [c1playernum]
        je short .13
        mov edx, dword [c1playernum-2]
        sar edx, 10h
        mov eax, dword [byte esp+0Ah]
        sar eax, 10h
        call restorepl
        mov word [c1playernum], ax
        jmp short .13
.12:
        cmp di, word [c2playernum]
        je short .13
        mov edx, dword [c2playernum-2]
        sar edx, 10h
        mov eax, dword [byte esp+0Ah]
        sar eax, 10h
        call restorepl
        mov word [c2playernum], ax
.13:
        add esp, byte 10h
changeplayer_ret5:
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; restorepl                        59FE1  93G logic93_1.asm, medium confidence
; eax = new controlled player, edx = old one.
;-----------------------------------------------------------------------------
; C: src/engine/hockey/restorepl.c
%ifdef CBUILD
%include "c/engine/hockey/restorepl.inc"
%else
restorepl:
        push dword 0Ch
        call __CHK
        push ebx
        push ecx
        mov ebx, eax
        test dx, dx
        jl short .2
        cmp dx, byte 0Bh
        jg short .2
        movsx eax, dx
        shl eax, 7
        add eax, SortCords
        test byte [byte eax+045h], 8
        je short .1
        mov eax, edx
        pop ecx
        pop ebx
        ret
.1:
        mov ch, byte [byte eax+044h]
        and ch, 0F5h
        mov dl, ch
        or dl, 2
        mov byte [byte eax+044h], dl
.2:
        test bx, bx
        jl short .3
        cmp bx, byte 0Bh
        jg short .3
        movsx eax, bx
        shl eax, 7
        or byte [dword eax+SortCords+44h], 8
.3:
        mov eax, ebx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; AvgCline                         5A03B  94G penalty94.asm, medium confidence
; 93G AvgCline: average energy of the current line of team eax (walks tmsort
; F6h); used by chk4lc (54AF9) and CompLine
;-----------------------------------------------------------------------------
; C: src/engine/hockey/AvgCline.c
%ifdef CBUILD
%include "c/engine/hockey/AvgCline.inc"
%else
AvgCline:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov esi, eax
        mov eax, dword [dword eax+tmsort]
        xor edx, edx
        mov dword [regd0], edx
        xor ecx, ecx
        mov edx, 6
.1:
        cmp word [byte eax+01Ah], byte 0
        jle short .2
        mov ebx, dword [byte eax+044h]
        sar ebx, 18h
        mov ebx, dword [byte esi+ebx*2+044h]
        sar ebx, 10h
        add dword [regd0], ebx
        inc ecx
.2:
        add eax, 80h
        dec dx
        jne short AvgCline.1
        test cx, cx
        je short .x
        movsx ebx, cx
        mov eax, dword [regd0]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        mov word [regd0], ax
.x:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CompLine                         5A0A3  93G logic93_3.asm, medium confidence
; (find good line for comp to switch to). eax = other team, edx = team.
; tmap difference picks the power-play penalty-kill lines, getlinee compares line energies, tmline/tmlcnt take
; the result (DrawPanelLine is called on a change). Callers: chk4lc and puckfaceoff.
;-----------------------------------------------------------------------------
; C: src/engine/hockey/CompLine.c
%ifdef CBUILD
%include "c/engine/hockey/CompLine.inc"
%else
CompLine:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 8
        mov esi, eax
        mov ebx, edx
        mov di, word [byte edx+036h]
        sub di, word [byte eax+036h]
        je short .3
        mov ecx, 4
        test di, di
        jge short .1
        mov ecx, 6
.1:
        movsx edx, cx
        mov eax, ebx
        call getlinee
        mov esi, eax
        cmp ax, 0F33h
        jge short .2
        mov edi, ecx
        inc edi
        movsx edx, di
        mov eax, ebx
        call getlinee
        cmp si, ax
        jge short .2
        mov ecx, edi
.2:
        mov word [byte ebx+temp3], cx
        jmp near .19
.3:
        mov ah, byte [dword ebx+0D4h]
        test ah, 1
        je near .9
        mov cx, word [byte ebx+temp3]
        test byte [gmode], 1
        je short .6
        cmp cx, byte 4
        jge short .6
        test ah, 40h
        jne short .6
        mov eax, ebx
        call AvgCline
        mov ax, word [byte ebx+facedir]
        cmp ax, word [byte esi+036h]
        jne short .4
        mov eax, dword [dword ebx+0D6h]
        jmp short .5
.4:
        mov eax, 0F33h
.5:
        xor edx, edx
        mov dx, word [regd0]
        cmp edx, eax
        ja near .x
.6:
        cmp cx, byte 3
        jle short .7
        mov ecx, 3
.7:
        cmp byte [dword ebx+0D5h], 6
        jne short .11
        cmp cx, byte 4
        jl short .8
        cmp cx, byte 5
        jle short .11
.8:
        mov ecx, 3
        jmp short .11
.9:
        mov cx, word [byte esi+02Ah]
        cmp cx, byte 6
        jl short .10
        sub ecx, byte 6
        jmp short .11
.10:
        cmp cx, byte 4
        jl short .11
        sub ecx, byte 4
.11:
        cmp byte [dword ebx+0D5h], 1
        jne short .12
        test byte [dword ebx+0D4h], 80h
        je short .12
        add ecx, byte 4
.12:
        mov eax, dword [dword ebx+0D2h]
        sar eax, 18h
        movsx esi, cx
        shl esi, 2
        mov eax, dword [nosplit eax*4+coachlinetab]
        add esi, eax
        mov ecx, 0FFFFFFFFh
        mov ax, word [byte ebx+temp3]
        mov word [esp], ax
        mov edx, dword [byte esp-02h]
        sar edx, 10h
        mov eax, ebx
        call getlinee
        mov dword [byte esp+04h], eax
        xor edi, edi
        jmp short .15
.13:
        movsx cx, byte [esi]
        inc esi
        test cx, cx
        jl short .16
        movsx edx, cx
        mov eax, ebx
        call getlinee
        movsx edx, ax
        cmp edx, dword [dword ebx+0D6h]
        ja short .16
        cmp ax, word [byte esp+04h]
        jle short .14
        mov dword [byte esp+04h], eax
        mov word [esp], cx
.14:
        mov ecx, 0FFFFFFFFh
        inc edi
.15:
        cmp di, byte 4
        jl short CompLine.13
.16:
        test cx, cx
        jge short .17
        mov ecx, dword [esp]
.17:
        cmp cx, word [byte ebx+temp3]
        je short .19
        mov word [byte ebx+temp3], cx
        cmp byte [dword ebx+0D5h], 1
        jne short .18
        cmp cx, byte 2
        jne short .18
        xor byte [dword ebx+0D4h], 80h
.18:
        cmp cx, byte 4
        jge short .19
        mov di, word [byte ebx+temp4]
        inc edi
        mov word [byte ebx+temp4], di
        cmp di, byte 3
        jl short .19
        mov edx, edi
        sub edx, byte 3
        mov word [byte ebx+temp4], dx
.19:
        movsx edx, cx
        cmp ebx, awtmstruct
        sete al
        xor ah, ah
        cwde
        call DrawPanelLine
        and byte [dword ebx+0D4h], 0BFh
.x:
        add esp, byte 8
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; getlinee_pp                                                     5A288  95 PC
;-----------------------------------------------------------------------------
; C: src/engine/hockey/CompLine.c (getlinee_pp)
%ifdef CBUILD
%include "c/engine/hockey/CompLine.getlinee_pp.inc"
%else
getlinee_pp:
        cmp dx, byte 6
        jge short .1
        mov ebx, dword [dword eax+tmlines]
        movsx eax, dx
        lea edx, [byte eax-04h]
        mov eax, edx
        shl eax, 2
        add eax, edx
        add ebx, byte 12h
        add eax, ebx
        mov edi, 5
        jmp short getlinee_sum
.1:
        mov edx, dword [dword eax+tmlines]
        movsx eax, cx
        shl eax, 2
        sub eax, byte 18h
        add edx, byte 1Ch
        add eax, edx
        mov edi, 4
getlinee_sum:
        xor ecx, ecx
        xor edx, edx
        jmp short .2
.1:
        xor ebx, ebx
        mov bl, byte [eax]
        inc eax
        add cx, word [byte esi+ebx*2+046h]
        inc edx
.2:
        cmp dx, di
        jl short getlinee_sum.1
        movsx edx, cx
        movsx ebx, di
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; TeamLineEnergy                               5A2EE  95 PC, medium confidence
; Energy of team line for the stats screens (file_utils caller); wraps
; LineEnergy
;-----------------------------------------------------------------------------
; C: src/engine/hockey/CompLine.c (TeamLineEnergy)
%ifdef CBUILD
%include "c/engine/hockey/CompLine.TeamLineEnergy.inc"
%else
TeamLineEnergy:
        push dword 4
        call __CHK
        test ax, ax
        jle short .1
        mov eax, awtmstruct
        jmp short .2
.1:
        mov eax, hmtmstruct
.2:
        movsx edx, dx
%endif ; C
;-----------------------------------------------------------------------------
; getlinee                                     5A30C  95 PC, medium confidence
; {source_game=93G,source_file=penalty93_2.asm,confidence=medium} 93G
; getlinee (d0 = line number, a2 = team: energy level of this line); called
; by CompLine and TeamLineEnergy
;-----------------------------------------------------------------------------
; C: src/engine/hockey/CompLine.c (getlinee)
%ifdef CBUILD
%include "c/engine/hockey/CompLine.getlinee.inc"
%else
getlinee:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        mov esi, eax
        mov ecx, edx
        cmp dx, byte 4
        jge near getlinee_pp
        movsx edx, dx
        mov eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, dword [dword esi+tmlines]
        add eax, edx
        mov edi, 3
        jmp short getlinee_sum
%endif ; C
;-----------------------------------------------------------------------------
; findpc                                                5A341  94G logic94.asm
; The 94G findpc: where and when the puck crosses each goal line (puckcross),
; called from pucknorm
;-----------------------------------------------------------------------------
; C: src/engine/hockey/findpc.c
%ifdef CBUILD
%include "c/engine/hockey/findpc.inc"
%else
findpc:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov esi, puckcross
        mov edi, 0E8h
        mov ecx, 0A0h
        xor edx, edx
        mov dword [esp], edx
        jmp near .6
.1:
        mov edx, dword [pucky]
        mov ax, word [edx]
        mov edx, edi
        sub edx, eax
        movsx ebp, dx
        mov ebx, dword [puckvy]
        cmp word [ebx], byte 0
        je near .4
        mov edx, ebp
        shl edx, 0Ch
        movsx ebx, word [ebx]
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov ebx, eax
        test eax, eax
        jl short .4
        cmp eax, 10000h
        jge short .4
        mov word [byte esi+02h], ax
        mov edx, dword [puckvx]
        movsx edx, word [edx]
        imul edx, ebp
        mov ebx, dword [puckvy]
        movsx ebx, word [ebx]
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov ebx, eax
        cmp eax, 10000h
        jge short .4
        mov edx, dword [puckx]
        add bx, word [edx]
        cmp bx, 0A0h
        jl short .2
        mov edx, ecx
        add edx, ecx
        sub edx, ebx
        mov bx, dx
.2:
        neg ecx
        cmp bx, cx
        jg short .3
        mov edx, ecx
        add edx, ecx
        sub edx, ebx
        mov bx, dx
.3:
        neg ecx
        mov word [esi], bx
        jmp short .5
.4:
        mov word [byte esi+02h], 0FFFFh
.5:
        neg edi
        inc dword [esp]
        add esi, byte 4
.6:
        cmp word [esp], byte 2
        jl near findpc.1
        add esp, byte 4
findpc_ret6:
        pop ebp
findpc_ret5:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; GetHot                             5A425  94G logic94.asm, medium confidence
;-----------------------------------------------------------------------------
; C: src/engine/hockey/findpc.c (GetHot)
%ifdef CBUILD
%include "c/engine/hockey/findpc.GetHot.inc"
%else
GetHot:
        push dword 10h
        call __CHK
        push ebx
        push edx
        push esi
        mov edx, eax
        xor ebx, ebx
        mov word [regd1], bx
        mov word [regd0], bx
        mov ax, word [byte eax+012h]
        test ax, ax
        jl short .x
        cmp ax, 468h
        jge short .x
        cmp ax, 378h
        jl short .1
        db 081h,0E8h,0F4h,00h,00h,00h           ; insn: sub eax,0F4h
        jmp short .2
.1:
        cmp ax, 283h
        jg short .x
.2:
        cmp ax, 2DAh
        jl short .3
        sub eax, byte 46h
        jmp short .4
.3:
        cmp ax, 293h
        jg short .x
.4:
        add eax, eax
        cwde
        movsx bx, byte [dword eax+HotList]
        mov word [regd0], bx
        movsx ax, byte [dword eax+HotList_y]
        mov word [regd1], ax
        test byte [byte edx+055h], 8
        je short .x
        mov esi, ebx
        neg esi
        mov word [regd0], si
.x:
        pop esi
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; GetHotStick                                  5A4AD  95 PC, medium confidence
; GetHot variant with the stick-position table CC7A4
;-----------------------------------------------------------------------------
; C: src/engine/hockey/GetHotStick.c
%ifdef CBUILD
%include "c/engine/hockey/GetHotStick.inc"
%else
GetHotStick:
        push dword 10h
        call __CHK
        push ebx
        push edx
        push esi
        mov edx, eax
        xor ebx, ebx
        mov word [regd1], bx
        mov word [regd0], bx
        mov ax, word [byte eax+012h]
        test ax, ax
        jl short .x
        cmp ax, 196h
        jl short .1
        cmp ax, 219h
        jle short .2
.1:
        cmp ax, 3CEh
        jl short .x
        cmp ax, 44Fh
        jg short .x
.2:
        cmp ax, 3CEh
        jl short .3
        db 081h,0E8h,0B4h,01h,00h,00h           ; insn: sub eax,1B4h
.3:
        db 081h,0E8h,096h,01h,00h,00h           ; insn: sub eax,196h
        add eax, eax
        cwde
        movsx bx, byte [dword eax+HotStickList]
        mov word [regd0], bx
        movsx ax, byte [dword eax+HotStickList_y]
        mov word [regd1], ax
        test byte [byte edx+055h], 8
        je short .x
        mov esi, ebx
        neg esi
        mov word [regd0], si
.x:
        pop esi
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; GetHotOrStick                                5A534  95 PC, medium confidence
; GetHot or GetHotStick depending on the player; physics caller
;-----------------------------------------------------------------------------
; C: src/engine/hockey/GetHotOrStick.c
%ifdef CBUILD
%include "c/engine/hockey/GetHotOrStick.inc"
%else
GetHotOrStick:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov edx, eax
        call GetHotStick
        mov bx, word [regd0]
        mov cx, word [regd1]
        mov eax, edx
        call GetHot
        mov dx, word [regd0]
        sub ebx, edx
        mov word [regd0], bx
        mov bx, word [regd1]
        sub ecx, ebx
        mov word [regd1], cx
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SetCoachMode                                 5A581  95 PC, medium confidence
; Sets a team's coach AI mode (team D2h..D6h fields)
;-----------------------------------------------------------------------------
; C: src/engine/hockey/SetCoachMode.c
%ifdef CBUILD
%include "c/engine/hockey/SetCoachMode.inc"
%else
SetCoachMode:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov edx, eax
        mov ax, word [hmscore]
        sub ax, word [awscore]
        test edx, edx
        jne short .3
        movsx ebx, ax
        mov dl, byte [hmtmcoachflags]
        and dl, 0FEh
        cmp ebx, byte 0FFFFFFFFh
        jge short .1
        mov byte [hmtmcoachflags], dl
        mov byte [hmtmcoachmode], 5
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        cmp ax, 3
        jle short .2
        mov dword [hmtmcoachenergy], 0D9Ah
        mov byte [hmtmcoachflags], dl
        mov byte [hmtmcoachmode], 4
        mov byte [hmtmcoach_d2], 3
        mov byte [hmtmcoach_d3], 2
        pop edx
        pop ecx
        pop ebx
        ret
.2:
        mov dword [hmtmcoachenergy], 0CCCh
        xor ch, ch
        mov byte [hmtmcoachmode], ch
        mov byte [hmtmcoachflags], dl
        pop edx
        pop ecx
        pop ebx
        ret
.3:
        mov dl, byte [awtmcoachflags]
        or dl, 1
        cmp ax, 1
        jle short .4
        mov byte [awtmcoachflags], dl
        mov byte [awtmcoachmode], 8
        pop edx
        pop ecx
        pop ebx
        ret
.4:
        cwde
        cmp eax, byte 0FFFFFFFDh
        jge short .5
        mov dword [awtmcoachenergy], 0D9Ah
        mov byte [awtmcoach_d2], 3
        mov byte [awtmcoach_d3], 2
        jmp short .6
.5:
        mov dword [awtmcoachenergy], 0CCCh
.6:
        mov byte [awtmcoachflags], dl
        mov byte [awtmcoachmode], 1
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; InitCoachModes                               5A669  95 PC, medium confidence
; Resets both teams' coach AI modes at period start (StartPer)
;-----------------------------------------------------------------------------
; C: src/engine/hockey/InitCoachModes.c
%ifdef CBUILD
%include "c/engine/hockey/InitCoachModes.inc"
%else
InitCoachModes:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push edi
        xor ah, ah
        mov byte [awtmcoachflags], ah
        mov byte [hmtmcoachflags], ah
        mov dh, 3
        mov byte [hmtmcoach_d2], dh
        mov bl, 2
        mov byte [hmtmcoach_d3], bl
        mov byte [awtmcoach_d2], dh
        mov byte [awtmcoach_d3], bl
        mov edx, dword [curperiod]
        cmp edx, byte 3
        jle short .1
        mov edi, 0D9Ah
        mov dword [hmtmcoachenergy], edi
        mov byte [hmtmcoachmode], bl
        mov dword [awtmcoachenergy], edi
        mov byte [awtmcoachflags], 1
        mov byte [awtmcoachmode], 8
        jmp short .3
.1:
        jne short .2
        xor eax, eax
        call SetCoachMode
        mov eax, 1
        call SetCoachMode
        jmp short .3
.2:
        mov ecx, 0CCCh
        mov dword [hmtmcoachenergy], ecx
        mov byte [hmtmcoachmode], ah
        mov dword [awtmcoachenergy], ecx
        mov byte [awtmcoachflags], 81h
        mov byte [awtmcoachmode], 1
.3:
        xor edx, edx
        mov word [awtmlcnt], dx
        mov word [awtmline], dx
        mov word [hmtmlcnt], dx
        mov word [hmtmline], dx
        test byte [gameopts], 4
        je short .x
        cmp word [cont1team], byte 1
        je short .4
        cmp word [cont2team], byte 1
        je short .4
        mov word [hmtmlcnt], 2
.4:
        cmp word [cont1team], byte 2
        je short .x
        cmp word [cont2team], byte 2
        je short .x
        mov word [awtmline], 3
        mov word [awtmlcnt], 2
.x:
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; UpdateCoachModes                             5A77C  95 PC, medium confidence
; coach AI, once a second from ClockTick. Picks each team's mode (team D2h..D6h) from the
; score difference, time left and penalties (details not traced).
;-----------------------------------------------------------------------------
; C: src/engine/hockey/UpdateCoachModes.c
%ifdef CBUILD
%include "c/engine/hockey/UpdateCoachModes.inc"
%else
UpdateCoachModes:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        test byte [gmode], 10h
        jne near .x
        mov dx, word [hmscore]
        sub dx, word [awscore]
        cmp dword [curperiod], byte 2
        jne near .6
        cmp word [gameclock], 258h
        jg near .6
        mov bl, byte [hmtmcoachmode]
        xor eax, eax
        call SetCoachMode
        cmp bl, byte [hmtmcoachmode]
        je short .1
        or byte [hmtmcoachflags], 40h
.1:
        mov bl, byte [awtmcoachmode]
        mov eax, 1
        call SetCoachMode
        cmp bl, byte [awtmcoachmode]
        je short .2
        or byte [awtmcoachflags], 40h
.2:
        cmp word [gameclock], 258h
        jne near .x
        movsx eax, dx
        cmp eax, byte 0FFFFFFFFh
        jge short .4
        mov ah, byte [hmtmcoach_d2]
        cmp ah, 4
        jae short .3
        mov bl, ah
        inc bl
        mov byte [hmtmcoach_d2], bl
.3:
        mov bh, byte [hmtmcoach_d3]
        cmp bh, 1
        jbe short .4
        mov cl, bh
        dec cl
        mov byte [hmtmcoach_d3], cl
.4:
        cmp dx, byte 1
        jle near .x
        mov ch, byte [awtmcoach_d2]
        cmp ch, 4
        jae short .5
        mov al, ch
        inc al
        mov byte [awtmcoach_d2], al
.5:
        mov ah, byte [awtmcoach_d3]
        cmp ah, 1
        jbe near .x
        mov dl, ah
        dec dl
        mov byte [awtmcoach_d3], dl
        pop edx
        pop ecx
        pop ebx
        ret
.6:
        cmp dword [curperiod], byte 3
        jne near .x
        mov bl, byte [hmtmcoachmode]
        cmp word [gameclock], byte 3Ch
        jg short .8
        movsx eax, dx
        cmp eax, byte 0FFFFFFFFh
        jg short .8
.7:
        mov dword [hmtmcoachenergy], 0B33h
        or byte [hmtmcoachflags], 1
        mov byte [hmtmcoachmode], 6
        jmp short .11
.8:
        cmp word [gameclock], byte 78h
        jg short .9
        movsx eax, dx
        cmp eax, byte 0FFFFFFFFh
        jl short UpdateCoachModes.7
.9:
        cmp word [gameclock], 0B4h
        jg short .12
        movsx eax, dx
        cmp eax, byte 0FFFFFFFFh
        jg short .12
.10:
        mov dword [hmtmcoachenergy], 0B33h
        or byte [hmtmcoachflags], 1
        mov byte [hmtmcoachmode], 7
.11:
        mov byte [hmtmcoach_d2], 4
        mov byte [hmtmcoach_d3], 1
        jmp near .18
.12:
        cmp word [gameclock], 12Ch
        jg short .13
        movsx eax, dx
        cmp eax, byte 0FFFFFFFFh
        jl short UpdateCoachModes.10
.13:
        cmp word [gameclock], 258h
        jg short .17
        movsx eax, dx
        cmp eax, byte 0FFFFFFFFh
        jge short .14
        mov dword [hmtmcoachenergy], 0B33h
        or byte [hmtmcoachflags], 1
        mov byte [hmtmcoachmode], 0Ah
        jmp short UpdateCoachModes.11
.14:
        cmp dx, byte 2
        jle short .15
        mov dword [hmtmcoachenergy], 0CCCh
        jmp short .16
.15:
        mov dword [hmtmcoachenergy], 0D9Ah
.16:
        and byte [hmtmcoachflags], 0FEh
        mov cl, 3
        mov byte [hmtmcoachmode], cl
        mov byte [hmtmcoach_d2], cl
        mov byte [hmtmcoach_d3], 2
        jmp short .18
.17:
        xor eax, eax
        call SetCoachMode
.18:
        cmp bl, byte [hmtmcoachmode]
        je short .19
        or byte [hmtmcoachflags], 40h
.19:
        mov bl, byte [awtmcoachmode]
        cmp word [gameclock], byte 3Ch
        jg short .21
        cmp dx, byte 1
        jl short .21
.20:
        mov dword [awtmcoachenergy], 0B33h
        or byte [awtmcoachflags], 1
        mov byte [awtmcoachmode], 6
        jmp short .24
.21:
        cmp word [gameclock], byte 78h
        jg short .22
        cmp dx, byte 1
        jg short UpdateCoachModes.20
.22:
        cmp word [gameclock], 0B4h
        jg short .25
        cmp dx, byte 1
        jle short .25
.23:
        mov dword [awtmcoachenergy], 0B33h
        or byte [awtmcoachflags], 1
        mov byte [awtmcoachmode], 7
.24:
        mov byte [awtmcoach_d2], 4
        mov byte [awtmcoach_d3], 1
        jmp near .31
.25:
        cmp word [gameclock], 12Ch
        jg short .26
        cmp dx, byte 1
        jg short UpdateCoachModes.23
.26:
        cmp word [gameclock], 258h
        jg short .30
        cmp dx, byte 1
        jle short .27
        mov dword [awtmcoachenergy], 0B33h
        or byte [awtmcoachflags], 1
        mov byte [awtmcoachmode], 0Ah
        jmp short UpdateCoachModes.24
.27:
        movsx eax, dx
        cmp eax, byte 0FFFFFFFEh
        jge short .28
        mov dword [awtmcoachenergy], 0CCCh
        mov byte [awtmcoachmode], 9
        jmp short .29
.28:
        mov dword [awtmcoachenergy], 0D9Ah
        mov byte [awtmcoachmode], 8
.29:
        or byte [awtmcoachflags], 1
        mov byte [awtmcoach_d2], 3
        mov byte [awtmcoach_d3], 2
        jmp short .31
.30:
        mov eax, 1
        call SetCoachMode
.31:
        cmp bl, byte [awtmcoachmode]
        je short .x
        or byte [awtmcoachflags], 40h
.x:
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; PenTeamScored                                5AAAE  95 PC, medium confidence
; During a delayed penalty (gmode bit 3): 1 if the scoring team has a skater
; with pflags2 bit 4 (caused a penalty), else 0. Goal then disallows the goal.
;-----------------------------------------------------------------------------
; C: src/engine/hockey/PenTeamScored.c
%ifdef CBUILD
%include "c/engine/hockey/PenTeamScored.inc"
%else
PenTeamScored:
        push dword 8
        call __CHK
        push edx
        test byte [gmode], 8
        je near .4
        mov eax, dword [pucky]
        cmp word [eax], byte 0
        setl al
        mov edx, eax
        and edx, 0FFh
        test byte [gmode], 2
        setne al
        and eax, 0FFh
        xor eax, edx
        cmp word [lasttouch], byte 6
        setl dl
        and edx, 0FFh
        xor edx, eax
        je short .4
        test eax, eax
        je short .1
        mov eax, 6
.1:
        shl eax, 7
        add eax, SortCords
        xor edx, edx
.2:
        cmp word [byte eax+01Ah], byte 0
        jl short .3
        test byte [byte eax+045h], 10h
        je short .3
        mov eax, 1
        pop edx
        ret
.3:
        inc edx
        add eax, 80h
        cmp edx, byte 6
        jl short PenTeamScored.2
.4:
        xor eax, eax
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; Goal                                         5AB36  95 PC, medium confidence
; (puck in goal). eax = the goal struct the puck went into.
; esi = scoring team, ebp = the other (puck Ypos sign xor gmdir). Puck stopped in the net, assreplace
; puck 1Ah. Offside (tmflags bit 4) -> AddPenalty 8 + AddPenalty2 1Bh; PenTeamScored (delayed penalty) -> no goal
; else tmscore+1 and the scoring bookkeeping (goal/assist counts, PenGoalStuff).
;-----------------------------------------------------------------------------
; C: src/engine/hockey/findpc.c (Goal)
%ifdef CBUILD
%include "c/engine/hockey/findpc.Goal.inc"
%else
Goal:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 8
        mov ecx, eax
        mov edi, puckstruct
        cmp word [puckstruct+6], byte 0
        setl al
        xor ah, ah
        mov edx, eax
        test byte [gmode], 2
        setne al
        xor dl, al
        mov word [byte esp+04h], dx
        test dx, dx
        jle short .1
        mov esi, awtmstruct
        jmp short .2
.1:
        mov esi, hmtmstruct
.2:
        cmp word [byte esp+04h], byte 0
        sete al
        and eax, 0FFh
        je short .3
        mov ebp, awtmstruct
        jmp short .4
.3:
        mov ebp, hmtmstruct
.4:
        test byte [gmode], 1
        jne short .5
        call PenTeamScored
        test eax, eax
        jne short .5
        test byte [byte esi+tmflags], 10h
        je near .11
.5:
        xor ah, ah
        mov byte [collflag], ah
        mov word [byte edi+Xvel], 0
        mov ax, word [byte edi+Xpos+2]
        cmp ax, word [byte ecx+02h]
        jge short .6
        mov eax, 0FFFFFFFAh
        jmp short .7
.6:
        mov eax, 6
.7:
        mov edx, dword [ecx]
        sar edx, 10h
        add eax, edx
        mov word [byte edi+Xpos+2], ax
        mov word [byte edi+Yvel], 0
        cmp word [byte ecx+06h], byte 0
        jge short .8
        mov eax, 0FFFFFFFCh
        jmp short .9
.8:
        mov eax, 4
.9:
        mov edx, dword [byte ecx+04h]
        sar edx, 10h
        add eax, edx
        mov word [byte edi+Ypos+2], ax
        mov word [byte edi+010h], 600h
        mov word [byte edi+0Ah], 0
        mov dl, 0FFh
        mov byte [puckcross+3], dl
        mov byte [puckcross+7], dl
        or byte [byte edi+pflags], 4
        test byte [gmode], 1
        jne near .60
        mov edx, 1Ah
        mov eax, edi
        call assreplace
        test byte [byte esi+tmflags], 10h
        je short .10
        mov eax, dword [dword esi+tmsort]
        mov edx, 8
        call AddPenalty
.10:
        mov eax, dword [dword ebp+tmsort]
        mov edx, 1Bh
        call AddPenalty2
        jmp near .60
.11:
        cmp dword [penshotlive], byte 0
        je short .12
        mov eax, dword [byte esp+02h]
        sar eax, 10h
        cmp eax, dword [penshotteam]
        je short .12
        call EndPenaltyShot
        jmp near .60
.12:
        inc word [byte esi+tmscore]
        mov cx, word [lasttouch]
        cmp cx, byte 6
        setl al
        mov edx, eax
        and edx, 0FFh
        mov eax, dword [byte esp+02h]
        sar eax, 10h
        xor eax, edx
        je short .13
        or byte [gmode2], 10h
        mov word [shotplayer], cx
.13:
        call ChkShotStat
        mov eax, 9Ch
        call sfx
        call freezewindow
        cmp word [byte esp+04h], byte 0
        jne short .15
        mov cx, word [crowdlevel]
        add ecx, 320h
        mov word [crowdlevel], cx
        cmp cx, 7D0h
        jle short .14
        mov word [crowdlevel], 7D0h
.14:
        cmp word [crowdlevel], 708h
        jge short .16
        mov word [crowdlevel], 708h
        jmp short .16
.15:
        cmp word [crowdlevel], 320h
        jge short .16
        mov word [crowdlevel], 320h
.16:
        mov eax, dword [byte esp+02h]
        sar eax, 10h
        call SetBoxDoorObject
        cmp word [byte esp+04h], byte 0
        jne short .20
        test byte [gameopts+1], 1
        je short .17
        cmp byte [musicon], 0
        jne short .18
.17:
        mov eax, 1
        jmp short .19
.18:
        xor eax, eax
.19:
        test eax, eax
        je short .20
        mov eax, 3
        call PlayCrowdSample
.20:
        cmp word [byte esp+04h], byte 1
        jne short .21
        add word [CwdExciteLvl], byte 0Ah
        jmp short .22
.21:
        add word [CwdExciteLvl], byte 1Eh
.22:
        mov ax, word [byte esi+facedir]
        mov dx, word [byte ebp+036h]
        cmp ax, dx
        jge short .23
        mov word [word_E9AB0], 2
        jmp short .25
.23:
        jle short .24
        mov word [word_E9AB0], 4
        jmp short .25
.24:
        mov word [word_E9AB0], 1
.25:
        cmp word [byte ebp+038h], byte 0
        jge short .26
        or byte [word_E9AB0], 8
.26:
        test byte [gmode], 10h
        jne near .44
        mov cx, word [byte esi+Wallcos]
        xor ch, ch
        cmp cx, byte 19h
        jge short .27
        movsx eax, cx
        shl eax, 4
        mov edx, dword [dword esi+0E6h]
        inc word [edx+eax]
.27:
        mov ax, word [byte esi+facedir]
        mov dx, word [byte ebp+036h]
        cmp ax, dx
        jle short .28
        movsx eax, cx
        shl eax, 4
        mov edx, dword [dword esi+0E6h]
        inc word [byte edx+eax+08h]
        jmp short .29
.28:
        jge short .29
        movsx edx, cx
        shl edx, 4
        mov eax, dword [dword esi+0E6h]
        inc word [byte edx+eax+0Ah]
.29:
        cmp word [byte ebp+038h], byte 0
        jge short .30
        movsx eax, cx
        shl eax, 4
        mov edx, dword [dword esi+0E6h]
        inc word [byte edx+eax+0Ch]
.30:
        cmp dword [penshotmode], byte 0
        je short .31
        inc word [byte esi+022h]
        jmp short .32
.31:
        cmp dword [shotongoal], byte 0
        je short .32
        inc word [byte esi+01Eh]
.32:
        mov ecx, dword [byte esp+02h]
        sar ecx, 10h
        mov eax, 1
        shl eax, cl
        test dword [onetimerflag], eax
        je short .33
        inc word [byte esi+position]
.33:
        mov cx, word [byte esi+Wallsin]
        test cx, cx
        jl short .35
        cmp cx, byte 19h
        jge short .34
        movsx eax, cx
        shl eax, 4
        mov edx, dword [dword esi+0E6h]
        inc word [byte edx+eax+02h]
.34:
        mov cx, word [byte esi+034h]
        test cx, cx
        jl short .35
        cmp cx, byte 19h
        jge short .35
        movsx eax, cx
        shl eax, 4
        mov edx, dword [dword esi+0E6h]
        inc word [byte edx+eax+02h]
.35:
        cmp word [byte ebp+038h], byte 0
        jl short .36
        mov edx, dword [dword ebp+tmlines]
        mov eax, dword [byte ebp+036h]
        sar eax, 10h
        xor ecx, ecx
        mov cl, byte [byte edx+eax+024h]
        sub ecx, byte 19h
        test cx, cx
        jl short .36
        cmp cx, byte 3
        jge short .36
        movsx edx, cx
        mov eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, dword [dword ebp+0EAh]
        inc word [byte edx+eax*2+04h]
.36:
        cmp dword [penshotlive], byte 0
        jne near .42
        mov ax, word [byte ebp+036h]
        cmp ax, word [byte esi+facedir]
        jl short .41
        mov ebx, dword [dword esi+tmsort]
        mov eax, dword [dword ebp+tmsort]
        xor ecx, ecx
        jmp short .40
.37:
        cmp word [byte ebx+position], byte 0
        jle short .38
        mov edx, dword [byte ebx+044h]
        sar edx, 18h
        shl edx, 4
        mov dword [esp], edx
        mov edx, dword [dword esi+0E6h]
        add edx, dword [esp]
        inc word [byte edx+06h]
.38:
        cmp word [byte eax+01Ah], byte 0
        jle short .39
        mov edx, dword [byte eax+044h]
        sar edx, 18h
        shl edx, 4
        mov dword [esp], edx
        mov edx, dword [dword ebp+0E6h]
        add edx, dword [esp]
        dec word [byte edx+06h]
.39:
        inc ecx
        add ebx, 80h
        add eax, 80h
.40:
        cmp cx, byte 6
        jl short Goal.37
.41:
        mov eax, dword [byte esp+02h]
        sar eax, 10h
        call PenGoalStuff
        jmp short .43
.42:
        xor ecx, ecx
        mov word [lty], cx
        mov word [ltx], cx
        mov word [foy], cx
        mov word [fox], cx
.43:
        xor ecx, ecx
        mov dword [shotongoal], ecx
        mov dword [onetimerflag], ecx
.44:
        mov edx, dword [byte esi+0Eh]
        sar edx, 10h
        mov eax, dword [byte esp+02h]
        sar eax, 10h
        call DrawPanelScore
        mov ebx, dword [dword esi+tmsort]
        mov ecx, 6
.45:
        cmp word [byte ebx+position], byte 0
        jle short .48
        test byte [byte ebx+pflags2], 1
        jne short .48
        and byte [byte ebx+pflags], 0FBh
        mov eax, dword [byte ebx+assnum-2]
        sar eax, 10h
        cmp byte [byte ebx+eax+01Eh], 2Dh
        jne short .46
        mov word [byte edi+temp5], 0
        mov edx, 28h
        mov eax, ebx
        call assinsert
        mov edx, 7
        mov eax, ebx
        call assinsert
        mov edx, 9
        jmp short .47
.46:
        mov edx, 7
.47:
        mov eax, ebx
        call assinsert
.48:
        add ebx, 80h
        dec cx
        jne short Goal.45
        xor dh, dh
        mov byte [collflag], dh
        mov word [byte edi+Xvel], cx
        cmp word [byte edi+Xpos+2], byte 0
        jge short .49
        mov eax, 0FFFFFFFAh
        jmp short .50
.49:
        mov eax, 6
.50:
        mov word [byte edi+Xpos+2], ax
        mov word [byte edi+Yvel], 0
        cmp word [byte edi+Ypos+2], byte 0
        jge short .51
        mov eax, 0FFFFFF10h
        jmp short .52
.51:
        mov eax, 0F0h
.52:
        mov word [byte edi+Ypos+2], ax
        mov word [byte edi+010h], 600h
        mov word [byte edi+0Ah], 0
        mov bl, 0FFh
        mov byte [puckcross+3], bl
        mov byte [puckcross+7], bl
        or byte [byte edi+pflags], 4
        mov edx, 1Ah
        mov eax, edi
        call assreplace
        lea eax, [dword edi+080h]
        mov edx, 7FDh
        call SetSPA
        mov eax, dword [dword ebp+tmsort]
        mov edx, 7
        call AddPenalty2
        test byte [gmode], 10h
        jne short .53
        call EndPenaltyShot
        mov edx, 1Fh
        mov eax, SortCords+800h
        call assreplace
        xor edx, edx
        mov dword [penshotfoy], edx
        mov dword [penshotfox], edx
.53:
        test byte [gmode], 10h
        jne near .60
        mov cx, word [hmscore]
        sub cx, word [awscore]
        movsx eax, cx
        cmp eax, byte 0FFFFFFFDh
        jge short .54
        cmp byte [hmtmcoach_d2], 1
        jbe short .54
        cmp word [cont1team], byte 1
        je short .54
        cmp word [cont2team], byte 1
        je short .54
        mov dl, byte [hmtmgoalie]
        test dl, 1
        jne short .54
        mov dh, dl
        xor dh, 1
        mov byte [hmtmgoalie], dh
.54:
        movsx eax, cx
        cmp eax, byte 0FFFFFFFFh
        jge short .55
        mov bl, byte [hmtmcoach_d2]
        cmp bl, 1
        jbe short .55
        mov bh, bl
        dec bh
        mov byte [hmtmcoach_d2], bh
.55:
        cmp cx, byte 1
        jge short .56
        mov al, byte [hmtmcoach_d3]
        cmp al, 1
        jbe short .56
        mov ah, al
        dec ah
        mov byte [hmtmcoach_d3], ah
.56:
        cmp cx, byte 3
        jle short .57
        cmp byte [awtmcoach_d2], 1
        jbe short .57
        cmp word [cont1team], byte 2
        je short .57
        cmp word [cont2team], byte 2
        je short .57
        mov dh, byte [awtmgoalie]
        test dh, 1
        jne short .57
        mov bl, dh
        xor bl, 1
        mov byte [awtmgoalie], bl
.57:
        cmp cx, byte 1
        jle short .58
        mov bh, byte [awtmcoach_d2]
        cmp bh, 1
        jbe short .58
        mov al, bh
        dec al
        mov byte [awtmcoach_d2], al
.58:
        movsx eax, cx
        cmp eax, byte 0FFFFFFFFh
        jle short .59
        mov ah, byte [awtmcoach_d3]
        cmp ah, 1
        jbe short .59
        mov dl, ah
        dec dl
        mov byte [awtmcoach_d3], dl
.59:
        call UpdateCoachModes
.60:
        add esp, byte 8
        jmp near findpc_ret6
%endif ; C
;-----------------------------------------------------------------------------
; GiveControl                                  5B1CE  95 PC, medium confidence
; Physics caller: gives the human the player who got the puck (restorepl)
;-----------------------------------------------------------------------------
; C: src/engine/hockey/GiveControl.c
%ifdef CBUILD
%include "c/engine/hockey/GiveControl.inc"
%else
GiveControl:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        cmp ax, word [c1playernum]
        je near .x
        mov bx, word [c2playernum]
        cmp ax, bx
        je near .x
        cmp ax, 6
        setge dl
        xor dh, dh
        inc edx
        mov word [regd1], dx
        cmp bx, word [lastplayer]
        je short .3
        mov dx, word [cont1team]
        mov cx, word [regd1]
        cmp dx, cx
        jne short .1
        cmp ax, word [c1playernum]
        je short .x
        jmp short .4
.1:
        cmp cx, word [cont2team]
        jne short .x
.2:
        cmp ax, bx
        je short .x
        mov edx, dword [c2playernum-2]
        sar edx, 10h
        cwde
        call restorepl
        mov word [c2playernum], ax
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.3:
        mov dx, word [cont2team]
        mov si, word [regd1]
        cmp dx, si
        je short GiveControl.2
        cmp si, word [cont1team]
        jne short .x
        cmp ax, word [c1playernum]
        je short .x
.4:
        mov edx, dword [c1playernum-2]
        sar edx, 10h
        cwde
        call restorepl
        mov word [c1playernum], ax
.x:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; Setplass                         5B298  94G collide94.asm, medium confidence
;-----------------------------------------------------------------------------
; C: src/engine/hockey/Setplass.c
%ifdef CBUILD
%include "c/engine/hockey/Setplass.inc"
%else
Setplass:
        push dword 8
        call __CHK
        push edx
        mov dx, word [byte eax+01Ah]
        test dx, dx
        jl short .x
        cmp dx, byte 6
        jg short .x
        movsx edx, dx
        mov edx, dword [dword edx+dword_CCC9E]
        sar edx, 18h
        call assreplace
.x:
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; setplayer                                         5B2C5  93G hockey93_05.asm
; (bring player onto the ice and set his stats). eax = sort object, edx = roster
; number. pnum = edx, tmpdst entry -1 (ice), roster status byte 4, then the attribute bytes from the roster record.
;-----------------------------------------------------------------------------
setplayer:
        push dword 34h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 1Ch
        mov ebx, eax
        mov word [byte esp+08h], dx
        mov ah, byte [byte eax+045h]
        and ah, 0BFh
        mov byte [byte ebx+pflags2], ah
        cmp word [byte ebx+SCnum], byte 6
        jl short .1
        mov eax, awtmstruct
        jmp short .2
.1:
        mov eax, hmtmstruct
.2:
        mov ecx, eax
        mov dl, byte [byte esp+08h]
        mov byte [byte ebx+pnum], dl
        mov edx, dword [byte esp+06h]
        sar edx, 10h
        mov ax, word [byte eax+edx*2+tmpdst]
        mov word [regd1], ax
        test ax, ax
        jl short .3
        mov edx, 0Ah
        jmp short .4
.3:
        mov eax, dword [regd1-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFEh
        jne short .5
        mov edx, 9
.4:
        mov eax, ebx
        call assinsert
        and byte [byte ebx+pflags], 0DFh
        mov word [byte ebx+SPA], 0
.5:
        mov edx, dword [byte esp+06h]
        sar edx, 10h
        mov eax, edx
        mov word [byte ecx+eax*2+tmpdst], 0FFFFh
        shl eax, 2
        add eax, edx
        shl eax, 3
        sub eax, edx
        mov edx, dword [dword ecx+tmroster]
        mov byte [edx+eax], 4
        mov eax, dword [dword ecx+0F2h]
        xor dl, dl
        mov byte [byte esp+010h], dl
        mov byte [byte esp+018h], dl
        mov byte [byte esp+0Ch], dl
        mov byte [byte esp+014h], dl
        cmp word [byte ebx+position], byte 0
        je near .19
        test byte [gmode2], 20h
        je near .11
        mov dl, byte [byte ebx+pflags]
        and dl, 40h
        movzx esi, dl
        mov dx, word [gmode2]
        xor dh, dh
        and dl, 40h
        movsx edx, dx
        xor esi, edx
        je short .8
        mov dl, byte [dword eax+02DCh]
        cmp dl, 6
        jbe short .6
        mov edx, 2
        jmp short .7
.6:
        cmp dl, 4
        setae dl
        and edx, 0FFh
.7:
        sub edx, byte 2
        mov dword [byte esp+04h], edx
        mov dl, byte [byte esp+04h]
        mov byte [byte esp+0Ch], dl
        jmp short .11
.8:
        mov dh, byte [dword eax+02DDh]
        cmp dh, 6
        jbe short .9
        mov dword [esp], 2
        jmp short .10
.9:
        cmp dh, 4
        setae dl
        and edx, 0FFh
        mov dword [esp], edx
.10:
        mov dl, byte [esp]
        mov byte [byte esp+014h], dl
.11:
        test byte [byte ebx+pflags], 40h
        jne short .13
        mov dh, byte [dword eax+02DEh]
        cmp dh, 6
        jbe short .12
        mov eax, 2
        jmp short .16
.12:
        cmp dh, 4
        setae al
        and eax, 0FFh
        jmp short .16
.13:
        mov dh, byte [dword eax+02DFh]
        cmp dh, 6
        jbe short .14
        mov eax, 2
        jmp short .15
.14:
        cmp dh, 4
        setae al
        and eax, 0FFh
.15:
        sub eax, byte 2
.16:
        mov byte [byte esp+010h], al
        mov ax, word [gsp]
        cmp ax, 2
        jg short .17
        jne short .19
        mov eax, dword [dword_E9AB6]
        sar eax, 11h
        mov edx, dword [gameclock-2]
        sar edx, 10h
        cmp edx, eax
        jge short .19
.17:
        mov ax, word [hmscore]
        sub ax, word [awscore]
        je short .18
        test byte [byte ebx+pflags], 40h
        sete dl
        and edx, 0FFh
        test ax, ax
        setg al
        and eax, 0FFh
        xor eax, edx
        je short .19
.18:
        mov byte [byte esp+018h], 2
.19:
        mov word [byte ebx+048h], 0
        mov word [byte ebx+04Ch], 0
        mov word [byte ebx+04Ah], 0
        mov byte [byte ebx+053h], 0
        cmp word [byte esp+08h], byte 19h
        jge near .39
        mov esi, dword [byte esp+06h]
        sar esi, 10h
        mov eax, esi
        shl eax, 2
        add eax, esi
        shl eax, 3
        sub eax, esi
        mov edx, dword [dword ecx+tmroster]
        mov al, byte [byte edx+eax+05h]
        mov byte [byte ebx+05Eh], al
        mov eax, esi
        shl eax, 2
        add eax, esi
        shl eax, 2
        mov edx, dword [dword ecx+0DEh]
        add eax, edx
        mov dl, byte [eax]
        mov byte [byte ebx+065h], dl
        mov cl, byte [byte ebx+attribute]
        and cl, 0F7h
        mov byte [byte ebx+attribute], cl
        inc eax
        cmp byte [byte ebx+065h], 0
        jne short .20
        mov dl, cl
        or dl, 8
        mov byte [byte ebx+attribute], dl
.20:
        mov dl, byte [eax]
        mov byte [byte ebx+legspd], dl
        inc eax
        mov dl, byte [eax]
        mov byte [byte ebx+legstr], dl
        inc eax
        lea ecx, [byte ebx+058h]
        cmp byte [byte ebx+legspd], 3
        jae short .21
        xor edx, edx
        mov dl, byte [byte ebx+legspd]
        jmp short .22
.21:
        mov edx, 3
.22:
        movzx esi, byte [ecx]
        mov dword [byte esp+04h], esi
        mov ebp, esi
        sub ebp, edx
        mov dword [byte esp+04h], ebp
        mov dl, byte [byte esp+04h]
        mov byte [ecx], dl
        lea ecx, [byte ebx+057h]
        cmp byte [byte ebx+legstr], 3
        jae short .23
        xor edx, edx
        mov dl, byte [byte ebx+legstr]
        jmp short .24
.23:
        mov edx, 3
.24:
        movzx esi, byte [ecx]
        mov dword [byte esp+04h], esi
        sub esi, edx
        mov dword [byte esp+04h], esi
        mov dl, byte [byte esp+04h]
        mov byte [ecx], dl
        mov dl, byte [eax]
        mov byte [byte ebx+weight], dl
        inc eax
        mov dl, byte [eax]
        mov byte [byte ebx+05Bh], dl
        inc eax
        xor ecx, ecx
        mov cl, byte [eax]
        movsx dx, byte [byte esp+018h]
        inc eax
        add edx, ecx
        test dx, dx
        jge short .25
        xor edx, edx
.25:
        cmp dx, byte 0Fh
        jle short .26
        mov edx, 0Fh
.26:
        mov byte [byte ebx+064h], dl
        xor ecx, ecx
        mov cl, byte [eax]
        movsx dx, byte [byte esp+014h]
        inc eax
        add ecx, edx
        movsx dx, byte [byte esp+0Ch]
        add ecx, edx
        movsx dx, byte [byte esp+010h]
        add edx, ecx
        test dx, dx
        jge short .27
        xor edx, edx
.27:
        cmp dx, byte 0Fh
        jle short .28
        mov edx, 0Fh
.28:
        mov byte [byte ebx+060h], dl
        xor edx, edx
        mov dl, byte [eax]
        movsx cx, byte [byte esp+014h]
        inc eax
        add ecx, edx
        movsx dx, byte [byte esp+0Ch]
        add edx, ecx
        movsx cx, byte [byte esp+010h]
        add edx, ecx
        test dx, dx
        jge short .29
        xor edx, edx
.29:
        cmp dx, byte 0Fh
        jle short .30
        mov edx, 0Fh
.30:
        mov byte [byte ebx+05Ch], dl
        inc eax
        xor ecx, ecx
        mov cl, byte [eax]
        movsx dx, byte [byte esp+014h]
        inc eax
        add ecx, edx
        movsx dx, byte [byte esp+010h]
        add edx, ecx
        test dx, dx
        jge short .31
        xor edx, edx
.31:
        cmp dx, byte 0Fh
        jle short .32
        mov edx, 0Fh
.32:
        mov byte [byte ebx+05Dh], dl
        xor ecx, ecx
        mov cl, byte [eax]
        movsx dx, byte [byte esp+014h]
        inc eax
        add ecx, edx
        movsx dx, byte [byte esp+0Ch]
        add edx, ecx
        movsx cx, byte [byte esp+010h]
        add edx, ecx
        movsx cx, byte [byte esp+018h]
        add edx, ecx
        test dx, dx
        jge short .33
        xor edx, edx
.33:
        cmp dx, byte 0Fh
        jle short .34
        mov edx, 0Fh
.34:
        xor dl, 0Fh
        movsx edx, dx
        add edx, byte 0Fh
        sar edx, 1
        mov byte [byte ebx+059h], dl
        xor ecx, ecx
        mov cl, byte [eax]
        movsx dx, byte [byte esp+010h]
        inc eax
        add edx, ecx
        test dx, dx
        jge short .35
        xor edx, edx
.35:
        cmp dx, byte 0Fh
        jle short .36
        mov edx, 0Fh
.36:
        xor dl, 0Fh
        movsx edx, dx
        add edx, byte 0Fh
        sar edx, 1
        mov byte [byte ebx+05Ah], dl
        mov dl, byte [eax]
        mov byte [byte ebx+062h], dl
        inc eax
        mov dl, byte [eax]
        mov byte [byte ebx+endurance], dl
        inc eax
        mov al, byte [eax]
        xor ah, ah
        movsx dx, byte [byte esp+018h]
        add eax, edx
        add edx, eax
        test dx, dx
        jge short .37
        xor edx, edx
.37:
        cmp dx, byte 0Fh
        jle short .38
        mov edx, 0Fh
.38:
        mov byte [byte ebx+05Fh], dl
        jmp near .49
.39:
        mov esi, dword [byte esp+06h]
        sar esi, 10h
        mov eax, esi
        shl eax, 2
        add eax, esi
        shl eax, 3
        sub eax, esi
        mov edx, dword [dword ecx+tmroster]
        mov al, byte [byte edx+eax+05h]
        mov byte [byte ebx+05Eh], al
        shl esi, 4
        mov edx, dword [dword ecx+0E2h]
        lea eax, [dword esi-0190h]
        add eax, edx
        mov dl, byte [eax]
        mov byte [byte ebx+065h], dl
        mov dl, byte [byte ebx+attribute]
        and dl, 0F7h
        mov byte [byte ebx+attribute], dl
        inc eax
        cmp byte [byte ebx+065h], 0
        jne short .40
        mov cl, dl
        or cl, 8
        mov byte [byte ebx+attribute], cl
.40:
        mov dl, byte [eax]
        mov byte [byte ebx+062h], dl
        inc eax
        mov dl, byte [eax]
        mov byte [byte ebx+05Dh], dl
        inc eax
        mov dl, byte [eax]
        mov byte [byte ebx+05Fh], dl
        inc eax
        mov dl, byte [eax]
        mov byte [byte ebx+endurance], dl
        inc eax
        mov dl, byte [eax]
        mov byte [byte ebx+05Bh], dl
        inc eax
        mov dl, byte [eax]
        mov byte [byte ebx+legspd], dl
        inc eax
        mov dl, byte [eax]
        mov byte [byte ebx+legstr], dl
        inc eax
        lea ecx, [byte ebx+058h]
        cmp byte [byte ebx+legspd], 3
        jae short .41
        xor edx, edx
        mov dl, byte [byte ebx+legspd]
        jmp short .42
.41:
        mov edx, 3
.42:
        movzx esi, byte [ecx]
        mov dword [byte esp+04h], esi
        sub esi, edx
        mov dword [byte esp+04h], esi
        mov dl, byte [byte esp+04h]
        mov byte [ecx], dl
        lea ecx, [byte ebx+057h]
        cmp byte [byte ebx+legstr], 3
        jae short .43
        xor edx, edx
        mov dl, byte [byte ebx+legstr]
        jmp short .44
.43:
        mov edx, 3
.44:
        movzx esi, byte [ecx]
        mov dword [byte esp+04h], esi
        mov edi, esi
        sub edi, edx
        mov dword [byte esp+04h], edi
        mov dl, byte [byte esp+04h]
        mov byte [ecx], dl
        mov dl, byte [eax]
        mov byte [byte ebx+weight], dl
        add eax, byte 2
        xor edx, edx
        mov dl, byte [eax]
        movsx cx, byte [byte esp+014h]
        inc eax
        add ecx, edx
        movsx dx, byte [byte esp+0Ch]
        add ecx, edx
        movsx dx, byte [byte esp+010h]
        add ecx, edx
        movsx dx, byte [byte esp+018h]
        add edx, ecx
        test dx, dx
        jge short .45
        xor edx, edx
.45:
        cmp dx, byte 0Fh
        jle short .46
        mov edx, 0Fh
.46:
        xor dl, 0Fh
        movsx edx, dx
        add edx, byte 0Fh
        sar edx, 1
        mov byte [byte ebx+059h], dl
        mov al, byte [eax]
        xor ah, ah
        movsx dx, byte [byte esp+010h]
        add edx, eax
        test dx, dx
        jge short .47
        xor edx, edx
.47:
        cmp dx, byte 0Fh
        jle short .48
        mov edx, 0Fh
.48:
        xor dl, 0Fh
        movsx eax, dx
        add eax, byte 0Fh
        sar eax, 1
        mov byte [byte ebx+05Ah], al
.49:
        add esp, byte 1Ch
        jmp near changeplayer_ret5
;-----------------------------------------------------------------------------
; reenergizeteam                                      5B826  94G penalty94.asm
; 93G reenergizeteam: refill energy of the whole roster (1000h)
;-----------------------------------------------------------------------------
; C: src/engine/hockey/findpc.c (reenergizeteam)
%ifdef CBUILD
%include "c/engine/hockey/findpc.reenergizeteam.inc"
%else
reenergizeteam:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov esi, eax
        lea ebx, [byte eax+046h]
        xor edx, edx
        jmp short .3
.1:
        mov word [ebx], 1000h
        movsx ecx, dx
        lea eax, [ecx+ecx]
        add ebx, byte 2
        add eax, esi
        mov edi, dword [byte eax+tmpdst-2]
        sar edi, 10h
        cmp edi, byte 0FFFFFFFDh
        jne short .2
        mov word [byte eax+tmpdst], 0FFFEh
        mov eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 3
        sub eax, ecx
        mov ecx, dword [dword esi+tmroster]
        mov byte [ecx+eax], 3
.2:
        inc edx
.3:
        cmp dx, byte 1Ch
        jl short reenergizeteam.1
        jmp near findpc_ret5
%endif ; C
;-----------------------------------------------------------------------------
; clearteams                                   5B881  95 PC, medium confidence
; Zero both team structs (200h bytes) and store their data pointers (tmsort, tmlines, tmroster,...).
;-----------------------------------------------------------------------------
; C: src/engine/hockey/clearteams.c
%ifdef CBUILD
%include "c/engine/hockey/clearteams.inc"
%else
clearteams:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        mov eax, hmtmstruct
        xor edx, edx
        jmp short .2
.1:
        mov byte [eax], 0
        inc eax
        inc edx
.2:
        movsx ebx, dx
        cmp ebx, 200h
        jb short clearteams.1
        xor edx, edx
        mov word [hmtmgoalie], dx
        mov ebx, 0FFFFFFFFh
        mov word [hmtmextra], bx
        mov word [awtmgoalie], dx
        mov word [awtmextra], bx
        mov ah, 0FFh
        mov byte [hmtmpbox], ah
        mov byte [awtmpbox], ah
        mov dword [hmtmsort], SortCords
        mov dword [hmtmplattr], hmplattr
        mov dword [hmtmglattr], hmglattr
        mov dword [hmtmlines], hmlinetab
        mov dword [hmtmplstats], hmplstats
        mov dword [hmtmglstats], hmglstats
        mov dword [hmtmroster], hmroster
        mov dword [hmtmptrF2], hmteamrec
        mov dword [awtmsort], SortCords+300h
        mov dword [awtmplattr], awplattr
        mov dword [awtmglattr], awglattr
        mov dword [awtmlines], awlinetab
        mov dword [awtmplstats], awplstats
        mov dword [awtmglstats], awglstats
        mov dword [awtmroster], awroster
        mov dword [awtmptrF2], awteamrec
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; restoreteams                                      5B97A  93G hockey93_01.asm
; Both teams: tmap = 6, every tmpdst entry = -2 (bench).
;-----------------------------------------------------------------------------
; C: src/engine/hockey/restoreteams.c
%ifdef CBUILD
%include "c/engine/hockey/restoreteams.inc"
%else
restoreteams:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        xor esi, esi
        mov eax, hmtmstruct
        jmp short .4
.1:
        mov word [byte eax+tmap], 6
        lea edx, [byte eax+tmpdst]
        mov eax, dword [dword eax+tmroster]
        xor ebx, ebx
        jmp short .3
.2:
        xor ecx, ecx
        mov cl, byte [eax]
        mov cx, word [nosplit ecx*2+restoreteams_pdsttab]
        mov word [edx], cx
        add edx, byte 2
        inc ebx
        add eax, byte 27h
.3:
        cmp bx, byte 1Ch
        jl short restoreteams.2
        mov eax, awtmstruct
        inc esi
.4:
        cmp si, byte 2
        jl short restoreteams.1
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; GetPeriodTime                  5B9D1  93G hockey93_01.asm, medium confidence
; 93G GetPeriodTime: period length from the option table CBC4A
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
; Zeroes the SortCords objects (93G defaultsprites2 .0 loop)
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
; 94G renamed the 93G defaultsprites2 to defaultsprites_0 (94G name_map)
;-----------------------------------------------------------------------------
; C: src/engine/hockey/findpc.c (defaultsprites_0)
%ifdef CBUILD
%include "c/engine/hockey/findpc.defaultsprites_0.inc"
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
        mov byte [byte eax+047h], 0FFh
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
        mov word [byte eax+0Ah], cx
        add edx, byte 2
        mov cx, word [edx]
        mov word [byte eax+012h], cx
        add edx, byte 2
        mov cx, word [edx]
        mov word [byte eax+054h], cx
        add edx, byte 2
        mov cx, word [edx]
        mov word [byte eax+066h], cx
        add edx, byte 2
        mov cx, word [edx]
        mov word [byte eax+068h], cx
        add edx, byte 2
        mov cl, byte [edx]
        mov byte [byte eax+01Eh], cl
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
        mov dword [byte eax+06Ch], ecx
        test byte [byte eax+pflags], 40h
        jne short .4
        mov ecx, awtmstruct
        jmp short .5
.4:
        mov ecx, hmtmstruct
.5:
        mov dword [byte eax+070h], ecx
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
; C: src/engine/hockey/findpc.c (SetPlList)
%ifdef CBUILD
%include "c/engine/hockey/findpc.SetPlList.inc"
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
        mov byte [dword edx+byte_E038A], al
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
        movsx ax, byte [dword ebx+byte_E038A]
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
;-----------------------------------------------------------------------------
; C: src/engine/hockey/findpc.c (setpersonel)
%ifdef CBUILD
%include "c/engine/hockey/findpc.setpersonel.inc"
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
        mov cl, byte [dword edx+byte_E038A]
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
        mov dl, byte [dword eax+byte_E038A]
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
; C: src/engine/hockey/findpc.c (StartPer)
%ifdef CBUILD
%include "c/engine/hockey/findpc.StartPer.inc"
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
        mov word [dword_E9A9E], dx
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
        mov word [crowdlevel], cx
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
; The 94G RestoreBenchEnergy: once a second with line changes on, bench
; players (tmpdst -2) gain energy, capped (PC +8, 94G +9)
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
; 93G updatecrowdf: crowd excitement level E9AA8 rises/decays, random crowd
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
        cmp word [crowdlevel], 258h
        jle short .x
        mov edx, dword [crowdlevel-2]
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
        cmp word [word_CBC44], byte 0
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
;-----------------------------------------------------------------------------
; C: src/engine/hockey/findpc.c (updateplayers)
%ifdef CBUILD
%include "c/engine/hockey/findpc.updateplayers.inc"
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
        cmp word [Pencntdwn], byte 0
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
        mov edi, dword [byte esi+06Ch]
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
        mov word [byte esi+04Eh], ax
        mov edx, dword [byte esp-02h]
        sar edx, 10h
        mov eax, dword [byte esp+02h]
        sar eax, 10h
        call vtoa
        mov byte [byte esi+052h], al
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
        mov dword [byte esi+078h], eax
        mov eax, dword [byte esi+08h]
        mov dword [byte esi+07Ch], eax
        cmp word [byte esi+position], byte 0
        jge short .12
        cmp word [byte esi+SCnum], byte 10h
        jne near .48
.12:
        mov eax, esi
        call updateanim
        mov dx, word [byte esi+03Eh]
        dec edx
        mov word [byte esi+03Eh], dx
        test dx, dx
        jge short .13
        mov word [byte esi+03Eh], 0
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
        mov bl, byte [byte esi+047h]
        test bl, bl
        jl short .15
        mov edi, dword [byte esi+06Ch]
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
        mov edx, dword [dword edi+0EAh]
        inc word [edx+eax*2]
.15:
        mov cx, word [byte esi+SPA]
        cmp cx, 0A0Bh
        je near .35
        cmp cx, 0F0Fh
        jl short .16
        cmp cx, 1055h
        jle near .35
.16:
        mov word [regd4], 10h
        cmp word [byte esi+0Ah], byte 0
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
        mov di, word [byte esi+0Ah]
        test di, di
        jl near .35
        jne short .33
        cmp word [byte esi+010h], byte 0
        je near .35
.33:
        imul ax, word [regd4], byte 6
        sub word [byte esi+010h], ax
        mov eax, dword [byte esi+0Eh]
        sar eax, 10h
        mov edx, dword [regd4-2]
        sar edx, 10h
        imul edx, eax
        mov dword [regd0], edx
        mov ecx, dword [byte esi+08h]
        add ecx, edx
        mov dword [byte esi+08h], ecx
        test ecx, ecx
        jge short .35
        mov dword [byte esi+08h], 0
        mov di, word [byte esi+010h]
        neg edi
        mov eax, edi
        sar ax, 1
        mov word [byte esi+010h], ax
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
        mov word [word_E03A0], ax
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
        mov ax, word [byte esi+07Ah]
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
        mov di, word [byte esi+018h]
        sub edi, byte 2
        mov word [byte esi+018h], di
        test di, di
        jge short .48
        mov word [byte esi+018h], 0
.48:
        mov ax, word [byte esi+018h]
        mov word [byte esi+016h], ax
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
; 93G updateanim: step SPAnum/SPAcnt through the SPA table (C921D), SetSPA
; when an animation ends
;-----------------------------------------------------------------------------
; C: src/engine/hockey/findpc.c (updateanim)
%ifdef CBUILD
%include "c/engine/hockey/findpc.updateanim.inc"
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
        add edx, SPAtab
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
        cmp si, 1027h
        jl short .7
        cmp si, 1055h
        jg short .7
        mov word [byte ebx+Yvel], 0
        mov ax, word [byte ebx+Yvel]
        mov word [byte ebx+Xvel], ax
        mov word [byte ebx+Xpos+2], 0FF60h
        mov word [byte ebx+facedir], 2
        or byte [byte ebx+pflags], 20h
        mov edx, 7A1h
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
; The 94G freezewindow body: xc1/yc1 = the camera, set sfslock (95G made the
; same rename)
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
        mov dword [dword_E03A8], edx
        mov dword [word_E03A0], edx
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
        mov ecx, dword [dword_D30C0]
        push ecx
        mov esi, dword [dword_D30BC]
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
        mov eax, dword [byte esi+010h]
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
        call sub_B340B
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
        mov eax, dword [nosplit eax*2+Pencntdwn2]
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
        mov eax, dword [byte esi+010h]
        sar eax, 10h
        jmp short .34
.31:
        cmp word [byte esi+012h], 189h
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
        mov cx, word [byte esi+012h]
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
        mov eax, dword [byte esi+010h]
        sar eax, 10h
        xor ecx, ecx
.34:
        call DrawFrameSprite
.35:
        mov eax, dword [puckc]
        cmp byte [eax], 10h
        je short .38
        sub esi, 80h
        mov bx, word [byte esi+0Ah]
        test bx, bx
        jne short .36
        push byte 0
        mov ebx, dword [byte esi+Ypos]
        sar ebx, 10h
        jmp short .37
.36:
        jle short .38
        push byte 0
        mov edx, dword [byte esi+08h]
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
        mov eax, dword [byte esi+010h]
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
        mov edx, dword [byte esi+08h]
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
        mov eax, dword [byte esi+010h]
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
        mov bl, byte [byte esi+05Eh]
        mov edx, dword [byte esi+Ypos]
        sar edx, 10h
        mov eax, dword [esi]
        sar eax, 10h
        jmp short .47
.46:
        cmp dword [shownumbers], byte 0
        je short .48
        xor ebx, ebx
        mov bl, byte [byte esi+05Eh]
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
        test byte [byte esi+055h], 8
        setne al
        xor ah, ah
        movsx ecx, ax
        mov ebx, dword [byte esi+Ypos]
        sar ebx, 10h
        mov edx, dword [esi]
        sar edx, 10h
        mov eax, dword [byte esi+010h]
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
        mov eax, dword [dword_D30C0]
        push eax
        mov edx, dword [dword_D30BC]
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
        mov eax, dword [nosplit eax*4+dword_CCD4F]
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
; 93G setupice role: per-period rink setup, gmdir flips pfgoal of the
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
; C: src/engine/hockey/findpc.c (clockcont_0)
%ifdef CBUILD
%include "c/engine/hockey/findpc.clockcont_0.inc"
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
        mov di, word [crowdlevel]
        cmp di, 4B0h
        jg short .3
        mov eax, edi
        add eax, 384h
        mov word [crowdlevel], ax
        cmp ax, 4B0h
        jle short .3
        mov word [crowdlevel], 4B0h
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
        movsx bx, byte [dword esi+tmpbox]
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
        mov ax, word [crowdlevel]
        cmp ax, 5DCh
        jg short .28
        mov edx, eax
        add edx, 3E8h
        mov word [crowdlevel], dx
        cmp dx, 5DCh
        jle short .28
        mov word [crowdlevel], 5DCh
.28:
        cmp word [regd0], byte 8
        jne short .30
        add word [crowdlevel], 320h
        jmp short .30
.29:
        cmp word [crowdlevel], 320h
        jge short .30
        mov word [crowdlevel], 320h
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
; run from the main loop. Counts clockticks (18h per second) and gameclock down; horn sfx 97h at
; 60 s (unless music plays), UpdateCoachModes each second. Debug playback (penshotlive) ends via EndPenaltyShot.
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
        cmp byte [musicon], 0
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
; C: src/engine/hockey/SetSPA.c (SprSortVert)
%ifdef CBUILD
%include "c/engine/hockey/SetSPA.SprSortVert.inc"
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
; 93G SetupTeamForIntermission: ResetBench, reenergizeteam both teams, tmline
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
; 93G Intermission start: SetupTeamForIntermission and clear the SortCords
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
; C: src/engine/hockey/findpc.c (ResetBench)
%ifdef CBUILD
%include "c/engine/hockey/findpc.ResetBench.inc"
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
        mov edx, 289h
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
