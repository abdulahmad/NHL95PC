; Penalties. The time left in the period, calling a penalty, the box, who is released, the power play,
; and the penalty shot.
bits 32
%include "hockey.inc"
section s_62CD7 progbits alloc exec nowrite align=1
extern __CHK, assinsert, assreplace, awgoalcnt, awscore, awtmap, awtmflags, awtmstruct
extern bannermsg, bannertimer, pendelaytab_e13, pendelay2tab, pendelay2tab_e4, rinkobjanim, rinkobjanim_b1, hmtmcoachflags
extern awtmcoachflags, milestonesaid, milestonesaid_b1, PenBuf_pl_m2, curevent, curevent_b1, curevent_b2, curevent_b3
extern curevent_b4, curevent_b5, curevent_b6, curevent_b7, curevent_b8, curevent_b9, curevent_b10, goalevent
extern c1playernum, c2playernum, CanRemovePlayer, clockticks, CloseTextOverlay, cont1team, cont2team, Crowdlevel
extern curperiod, CwdExciteLvl, defercount, deferpending, DrawFrameSprite, DrawSprite, penmintab_m3, apl
extern goalienotebits, sideobjpos, hmplstats_m2, hmplstats, plcareergoals, plcareerpts, plseasongoals, plseasonpts
extern hmtmtouch2, hmtmtouch3, RinkSideShape, RinkSideShapeFlipped, PenBuf_m2, SpeechPatchNext, rinkobjused_m2, defertab
extern defertab_a1, defertab_a2, defertab_a3, defertab_a4, defertab_a5, defertab_a6, defertab_fn, FatalError
extern FileClose, FileOpenRW, FileWriteAt, fox, foy, fputchar, gameclock, gamemode
extern gameopts, gmode, gmode2, gsp, gsummarypath, gsumqcount, hmgoalcnt, hmroster
extern hmrosterjersey, hmscore, hmteamrec, hmtmap, hmtmflags, hmtmgoalie, hmtmlines, hmtmstruct
extern HomeTeam, joysampling, joysampling_save, lastsfx, LoadTeamPPV, lseek_, ltx, lty
extern MenuCallbackTrue, MenuCallbackTrue2, MusicOn, pennametab, ovlseq, ovltimer, PanelAddPenalty, PanelRemovePenalty
extern PaPenalty, PaPenaltyShot, PaSpeechBusy, PBnum, penaltynames, Penaltytimer, PenBuf, PenBuf_m5
extern PenBuf_pl, PenCntDwn, pendelaytab, penmintab, penshotfox, penshotfoy, penshotlive, penshotmode
extern penshotplayer, penshotpnum, penshotstart, penshotteam, penshottimer, periodendtime, PerTimeTotal, photoptrsf
extern PlayCrowdSample, PostPenaltyEvent, priolist_m1, puckc, puckstruct, pucktemp1, puckvx, puckvy
extern puckvz, puckx, pucky, puckz, randomd0, RefPen, refsignal, RefStep
extern regd1, regd2, regd3, restorepl, s1font, scor2font, scpflags2, Setplass
extern setplayer, sflags, sflags3, sfx, shotongoal, shotontarget, SortCords, sortobj15
extern sprintf_, str_02d02dSInjury, str_02d02dSPenalty, str_Assists, str_B3, str_B4, str_B5, str_B6
extern str_B7, str_B8, str_DMinutes, str_FmtClockEvent, str_FmtNumFirstLast, str_FmtNumInitialLast, str_FmtNumName, str_FmtNumNameSuffix
extern str_FmtParenD, str_GameMisconduct, str_GoneFor1Period, str_GoneForTheGame, str_PenaltyShot, str_PPTag, str_S8, str_ServedByD
extern str_SHTag, str_ToBeTakenBy, str_Unassisted, strcpy_, strlen_, TextSetFont, teamabbrevs, textline1
extern textline2, textline3, textline4, textline5, str_NoPenalty, gsumheader, gsumtail, gsumqueue
extern UpdateTextOverlay, vecdist, VisTeam, gsumcount, penaltysc, SortPending, injurystop, PenCntDwn2
extern rinkobjdefs, penbannertab, hmplstats_w2, rinkobjs, hmtmtouch1, penevteam, rinkobjused, yleader
global GetPeriodTimeRemaining, AddPenalty, AddPenalty2, SetPA, InProgress, InProgress_popebp, InProgress_popx, chkprogress_go
global chkprogress_x, Stop4Pen, checkfornewpen, releasepl, chkatop, updatepentime_ut_chk, updatepentime_ut, updatePPTeamTime
global updatepentime, PenaltyManager, chkprogress, UpdatePowerPlayFlags, ClearPenaltyBuffer, PenGoalStuff, SetupPenaltyShot, ShotLaneOpen
global QuickShotChk, CountShotOnGoal, StartPenaltyShot, EndPenaltyShot
;-----------------------------------------------------------------------------
; GetPeriodTimeRemaining                              62CD7  94G collide94.asm
; GetPeriodTimeRemaining: (gsp << 14 | PerTimeTotal) - gameclock, for
; the scoring and penalty summaries
;-----------------------------------------------------------------------------
; C: src/engine/penalty/GetPeriodTimeRemaining.c
%ifdef CBUILD
%include "c/engine/penalty/GetPeriodTimeRemaining.inc"
%else
GetPeriodTimeRemaining:
        push dword 4
        call __CHK
        mov ax, word [gsp]
        shl eax, 0Eh
        add ax, word [PerTimeTotal]
        sub ax, word [gameclock]
        ret
%endif ; C
;-----------------------------------------------------------------------------
; AddPenalty                       62CF9  94G penalty94.asm, medium confidence
; Call penalty pen on player p (AddPenalty2) unless the clock is stopped, p is
; SCnum 10h or a penalty shot is on.
;
; Penalty 6 always goes through; 8 (offside) only with the offsides option,
; 1Dh (two-line pass) only with that option; the others need the penalties
; option (gameopts bit 0), fewer than 8 players in p's team's box (PBnum)
;
; and CanRemovePlayer.
;-----------------------------------------------------------------------------
; C: src/engine/penalty/AddPenalty.c
%ifdef CBUILD
%include "c/engine/penalty/AddPenalty.inc"
%else
AddPenalty:
        push dword 8
        call __CHK
        push ebx
        mov ebx, eax
        test byte [gmode], 1
        jne near .x
        cmp word [byte ebx+06Ah], byte 10h
        je near .x
        cmp dword [penshotlive], byte 0
        jne short .x
        cmp dx, byte 6
        je short .4
        cmp dx, byte 8
        jne short .1
        test byte [gameopts], 2
        jmp short .3
.1:
        cmp dx, byte 1Dh
        jne short .2
        test byte [gameopts], 8
        jmp short .3
.2:
        test byte [gameopts], 1
        je short .x
        test byte [byte ebx+044h], 40h
        setne al
        and eax, 0FFh
        cmp byte [dword eax+PBnum], 8
        jge short .x
        mov eax, ebx
        call CanRemovePlayer
        test eax, eax
.3:
        je short .x
.4:
        movsx edx, dx
        mov eax, ebx
        call AddPenalty2
.x:
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; AddPenalty2                      62D80  94G penalty94.asm, medium confidence
; Call penalty pen on player p (not in a replay, sflags bit 7, or with
; SortPending): outside a penalty shot raise the banner (penbannertab[pen],
;
; timer 50h unless none 6); major penalties (pen >= 7) raise the crowd (+400
; up to 800; flag 40h side: CwdExciteLvl +20 and sound 7Dh, else A0h).
;
; Then the penalty goes into the first free PenBuf slot (pen, SCnum); a
; penalty with time (penmintab) marks the player (pflags2 bit 4) or, when he
; already has one, frees the slot again.
;-----------------------------------------------------------------------------
; C: src/engine/penalty/AddPenalty2.c
%ifdef CBUILD
%include "c/engine/penalty/AddPenalty2.inc"
%else
AddPenalty2:
        push dword 0Ch
        call __CHK
        push ebx
        push ecx
        mov ebx, eax
        mov ecx, edx
        test byte [sflags], 80h
        jne near .x
        cmp word [SortPending], byte 0
        jne near .x
        cmp dword [penshotstart], byte 0
        jne short .1
        movsx edx, cx
        shl edx, 2
        mov eax, dword [bannermsg-2]
        sar eax, 10h
        cmp eax, dword [dword edx+penbannertab]
        jge short .1
        mov ax, word [dword edx+penbannertab]
        mov word [bannermsg], ax
        mov eax, dword [bannermsg-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        je short .1
        cmp word [bannermsg], byte 6
        je short .1
        mov word [bannertimer], 50h
.1:
        cmp cx, byte 7
        jl short .5
        mov ax, word [Crowdlevel]
        cmp ax, 320h
        jg short .2
        mov edx, eax
        add edx, 190h
        mov word [Crowdlevel], dx
        cmp dx, 320h
        jle short .2
        mov word [Crowdlevel], 320h
.2:
        test byte [byte ebx+044h], 40h
        je short .3
        add word [CwdExciteLvl], byte 14h
        mov eax, 7Dh
        jmp short .4
.3:
        mov eax, 0A0h
.4:
        call sfx
.5:
        xor eax, eax
        jmp short .9
.6:
        movsx edx, ax
        add edx, edx
        cmp byte [dword edx+PenBuf], 0
        jne short .8
        mov byte [dword edx+PenBuf], cl
        mov al, byte [byte ebx+06Ah]
        mov byte [dword edx+PenBuf_pl], al
        movsx eax, cx
        cmp byte [dword eax+penmintab], 0
        je short .x
        mov ch, byte [byte ebx+045h]
        test ch, 10h
        jne short .7
        mov ah, ch
        or ah, 10h
        mov byte [byte ebx+045h], ah
        pop ecx
        pop ebx
        ret
.7:
        xor al, al
        mov byte [dword edx+PenBuf_pl], al
        mov byte [dword edx+PenBuf], al
        pop ecx
        pop ebx
        ret
.8:
        inc eax
.9:
        cmp ax, 20h
        jl short AddPenalty2.6
.x:
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SetPA                          62EA2  93G penalty93_1.asm, medium confidence
; SetPA (start ref animation): RefPen = eax, RefStep = 0;
; PC: no animation for 5 and 1Ch, else the referee sort object
;
; (SortCords+800h) gets assignment 20h (23h for penalty 7) instead of the ref
; window
;-----------------------------------------------------------------------------
; C: src/engine/penalty/SetPA.c
%ifdef CBUILD
%include "c/engine/penalty/SetPA.inc"
%else
SetPA:
        push dword 8
        call __CHK
        push edx
        cmp ax, 5
        je short .x
        cmp ax, 1Ch
        je short .x
        mov word [RefPen], ax
        xor edx, edx
        mov word [RefStep], dx
        cmp ax, 7
        jne short .1
        mov edx, 23h
        jmp short .2
.1:
        mov edx, 20h
.2:
        movsx edx, dx
        mov eax, SortCords+800h
        call assreplace
.x:
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; InProgress                                        62EE9  93G penalty93_1.asm
; InProgress (ref in progress: update graphics, stats and penalty
; information), reached from chkprogress when PenCntDwn < 0; sprintf messages,
;
; assreplace, SetPA
;-----------------------------------------------------------------------------
InProgress:
        push dword 3Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, byte 14h
        cmp word [RefStep], byte 0
        je near .33
        call PaSpeechBusy
        test eax, eax
        jne near .33
.1:
        cmp byte [PenBuf], 0
        jne near .8
        mov bx, word [ovlseq]
        test bx, bx
        je short .2
        cmp bx, byte 2
        je short .2
        cmp word [ovltimer], byte 0
        jge near .33
.2:
        xor esi, esi
        mov edi, hmtmstruct
        jmp short .7
.3:
        mov ebx, 6
        mov edx, 1Bh
        jmp short .6
.4:
        movsx eax, dx
        add eax, eax
        add eax, edi
        cmp word [byte eax+OldZpos+2], byte 0
        jle short .5
        mov cl, byte [byte eax+07Fh]
        and cl, 0DFh
        mov byte [byte eax+07Fh], cl
        test cl, 10h
        jne short .5
        cmp bx, byte 4
        jle short .5
        dec ebx
.5:
        dec edx
.6:
        test dx, dx
        jge short InProgress.4
        mov word [byte edi+036h], bx
        mov edi, awtmstruct
        inc esi
.7:
        cmp si, byte 2
        jl short InProgress.3
        and byte [gmode], 0FBh
        mov eax, dword [puckstruct+1Ah]
        sar eax, 10h
        add eax, puckstruct
        movsx si, byte [byte eax+asslist]
        cmp si, byte 1Bh
        je near .33
        cmp si, byte 1Ch
        je near .33
        mov edx, 1Bh
        mov eax, puckstruct
        call assreplace
        jmp near .33
.8:
        mov esi, 1
        jmp short .10
.9:
        inc esi
.10:
        movsx eax, si
        cmp byte [nosplit eax*2+PenBuf], 0
        jne short InProgress.9
        dec esi
        movsx eax, si
        add eax, eax
        mov dh, byte [dword eax+PenBuf_pl]
        test dh, 80h
        jne short .11
        mov edx, dword [dword eax+PenBuf_pl-3]
        sar edx, 18h
        shl edx, 7
        mov ebx, SortCords
        add ebx, edx
        mov dword [byte ebp-014h], ebx
        cmp word [byte ebx+01Ah], byte 0
        jge near .33
        xor cl, cl
        mov byte [dword eax+PenBuf_pl], cl
        mov byte [dword eax+PenBuf], cl
        jmp near .33
.11:
        mov bl, dh
        and bl, 7Fh
        mov byte [dword eax+PenBuf_pl], bl
        movsx dx, byte [dword eax+PenBuf]
        mov word [byte ebp-08h], dx
        cmp dx, byte 1Ah
        jne near .13
        call StartPenaltyShot
        mov dx, word [PerTimeTotal]
        mov cx, word [gameclock]
        sub edx, ecx
        cmp cx, byte 3Ch
        jge short .12
        cmp word [clockticks], byte 0
        je short .12
        dec edx
.12:
        movsx eax, si
        mov ebx, dword [nosplit eax*2+PenBuf_m2]
        sar ebx, 18h
        shl ebx, 7
        mov ecx, SortCords
        add ecx, ebx
        mov dword [byte ebp-014h], ecx
        xor bh, bh
        mov byte [nosplit eax*2+PenBuf_pl], bh
        mov byte [nosplit eax*2+PenBuf], bh
        push byte 0
        movsx edi, dx
        mov ebx, 3Ch
        mov eax, edi
        mov edx, edi
        sar edx, 1Fh
        idiv ebx
        push edx
        mov eax, edi
        mov edx, edi
        sar edx, 1Fh
        idiv ebx
        push eax
        xor ecx, ecx
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        lea ebx, [byte eax-09h]
        mov edx, dword [byte ebp-014h]
        mov edx, dword [byte edx+044h]
        sar edx, 18h
        mov eax, dword [byte ebp-014h]
        test byte [byte eax+pflags], 40h
        setne al
        and eax, 0FFh
        call PostPenaltyEvent
        jmp near .32
.13:
        mov edi, dword [byte ebp-0Ah]
        sar edi, 10h
        movsx dx, byte [dword edi+penmintab]
        mov word [byte ebp-010h], dx
        test dx, dx
        jg near .18
        jge near .16
        mov eax, dword [dword eax+PenBuf_pl-3]
        sar eax, 18h
        shl eax, 7
        mov edx, SortCords
        add edx, eax
        mov dword [byte ebp-014h], edx
        mov edi, dword [byte edx+06Ch]
        mov ebx, dword [byte edx+044h]
        sar ebx, 18h
        mov eax, ebx
        shl eax, 2
        add eax, ebx
        shl eax, 3
        sub eax, ebx
        mov edx, dword [dword edi+tmroster]
        mov byte [edx+eax], 8
        mov eax, dword [byte ebp-014h]
        mov eax, dword [byte eax+044h]
        sar eax, 18h
        mov eax, dword [byte edi+eax*2+tmpdst-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFDh
        jle short .14
        mov edx, 1Dh
        mov eax, dword [byte ebp-014h]
        call assreplace
.14:
        mov eax, dword [byte ebp-014h]
        mov eax, dword [byte eax+044h]
        sar eax, 18h
        mov word [byte edi+eax*2+07Eh], 0FFFBh
        mov dx, word [PerTimeTotal]
        mov di, word [gameclock]
        sub edx, edi
        cmp di, byte 3Ch
        jge short .15
        cmp word [clockticks], byte 0
        je short .15
        dec edx
.15:
        movsx eax, si
        push eax
        movsx edi, dx
        mov ebx, 3Ch
        mov eax, edi
        mov edx, edi
        sar edx, 1Fh
        idiv ebx
        push edx
        mov eax, edi
        mov edx, edi
        sar edx, 1Fh
        idiv ebx
        push eax
        mov ecx, dword [byte ebp-012h]
        sar ecx, 10h
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        lea ebx, [byte eax-09h]
        mov edx, dword [byte ebp-014h]
        mov edx, dword [byte edx+044h]
        sar edx, 18h
        mov eax, dword [byte ebp-014h]
        test byte [byte eax+pflags], 40h
        setne al
        and eax, 0FFh
        call PostPenaltyEvent
        movsx eax, si
        movsx dx, byte [nosplit eax*2+PenBuf_pl]
        mov word [penaltysc], dx
        xor bl, bl
        mov byte [nosplit eax*2+PenBuf_pl], bl
        mov byte [nosplit eax*2+PenBuf], bl
        jmp near .32
.16:
        movsx dx, bl
        mov word [penaltysc], dx
        xor dl, dl
        mov byte [dword eax+PenBuf_pl], dl
        mov byte [dword eax+PenBuf], dl
        test byte [sflags], 80h
        jne short .17
        cmp word [SortPending], byte 0
        je near .32
.17:
        cmp word [byte ebp-08h], byte 7
        jne near InProgress.1
        jmp near .32
.18:
        mov eax, dword [dword eax+PenBuf_pl-3]
        sar eax, 18h
        shl eax, 7
        mov edx, SortCords
        add edx, eax
        mov dword [byte ebp-014h], edx
        mov edi, dword [byte edx+06Ch]
        inc word [byte edi+tmPenalties]
        mov eax, dword [byte ebp-010h]
        add word [byte edi+tmPenmin], ax
        movsx ax, byte [byte edx+047h]
        mov word [byte ebp-0Ch], ax
        cmp ax, 19h
        jge short .19
        mov edx, dword [byte ebp-0Eh]
        sar edx, 10h
        shl edx, 4
        mov eax, dword [dword edi+tmplstats]
        add eax, edx
        mov edx, dword [byte ebp-010h]
        add word [byte eax+04h], dx
.19:
        mov ebx, dword [byte ebp-012h]
        sar ebx, 10h
        xor edx, edx
        mov eax, dword [byte ebp-014h]
        mov dl, byte [byte eax+rostnum]
        test byte [byte eax+pflags], 40h
        setne al
        xor ah, ah
        cwde
        call PanelAddPenalty
        mov dx, word [PerTimeTotal]
        mov cx, word [gameclock]
        sub edx, ecx
        cmp cx, byte 3Ch
        jge short .20
        cmp word [clockticks], byte 0
        je short .20
        dec edx
.20:
        movsx eax, si
        push eax
        movsx ebx, dx
        mov ecx, 3Ch
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ecx
        push edx
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ecx
        push eax
        mov ecx, dword [byte ebp-012h]
        sar ecx, 10h
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        lea ebx, [byte eax-09h]
        mov edx, dword [byte ebp-014h]
        mov edx, dword [byte edx+044h]
        sar edx, 18h
        mov eax, dword [byte ebp-014h]
        test byte [byte eax+pflags], 40h
        setne byte [byte ebp-04h]
        xor eax, eax
        mov al, byte [byte ebp-04h]
        call PostPenaltyEvent
        mov ecx, dword [byte ebp-010h]
        imul eax, ecx, byte 3Ch
        mov word [byte ebp-010h], ax
        cmp ax, 12Ch
        jne short .21
        or byte [byte ebp-0Fh], 40h
.21:
        or byte [byte ebp-0Fh], 20h
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        mov eax, dword [byte edi+eax*2+07Ch]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFDh
        je short .22
        cmp eax, byte 0FFFFFFFCh
        jne near .27
.22:
        mov eax, dword [dword edi+0F6h]
        mov dword [byte ebp-014h], eax
        xor edx, edx
        jmp short .25
.23:
        mov eax, dword [byte ebp-014h]
        cmp word [byte eax+position], byte 0
        jle short .24
        mov eax, dword [byte eax+044h]
        sar eax, 18h
        mov eax, dword [byte edi+eax*2+07Ch]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        jne short .24
        mov eax, dword [byte ebp-014h]
        test byte [byte eax+pflags2], 10h
        je short .26
.24:
        inc edx
        add dword [byte ebp-014h], 80h
.25:
        cmp dx, byte 6
        jl short InProgress.23
.26:
        cmp dx, byte 6
        je near .33
        mov eax, dword [byte ebp-014h]
        movsx ax, byte [byte eax+pnum]
        mov word [byte ebp-0Ch], ax
        movsx eax, si
        mov dl, byte [nosplit eax*2+PenBuf_pl]
        and dl, 80h
        mov ebx, dword [byte ebp-014h]
        mov dh, byte [byte ebx+06Ah]
        or dl, dh
        mov byte [nosplit eax*2+PenBuf_pl], dl
        xor eax, eax
        mov al, byte [byte ebx+05Eh]
        push eax
        push str_ServedByD
        push textline5
        call sprintf_
        add esp, byte 0Ch
.27:
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        add eax, eax
        add eax, edi
        cmp word [byte eax+OldZpos+2], byte 0
        jl short .28
        test byte [byte eax+07Fh], 10h
        je short .28
        or byte [byte ebp-0Fh], 10h
.28:
        mov ebx, dword [byte ebp-0Eh]
        sar ebx, 10h
        mov eax, ebx
        mov edx, dword [byte ebp-010h]
        mov word [byte edi+eax*2+07Eh], dx
        shl eax, 2
        add eax, ebx
        shl eax, 3
        sub eax, ebx
        mov edx, dword [dword edi+0EEh]
        mov byte [edx+eax], 5
        xor esi, esi
        jmp short .30
.29:
        movsx eax, si
        cmp byte [dword edi+eax+0B6h], 0
        jl short .31
        inc esi
.30:
        cmp si, byte 1Ch
        jl short InProgress.29
.31:
        movsx eax, si
        add edi, eax
        mov al, byte [byte ebp-0Ch]
        mov byte [dword edi+0B6h], al
        mov byte [dword edi+0B7h], 0FFh
        mov edx, 0Ch
        mov eax, dword [byte ebp-014h]
        call assreplace
        mov eax, dword [byte ebp-014h]
        mov ax, word [byte eax+SCnum]
        mov word [penaltysc], ax
.32:
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        call SetPA
.33:
        mov esp, ebp
InProgress_popebp:
        pop ebp
InProgress_popx:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; chkprogress_go                                                  63475  95 PC
; Entry into chkprogress past its first test (PenaltyManager jumps here).
;-----------------------------------------------------------------------------
; C: src/engine/penalty/InProgress.c (chkprogress_go)
%ifdef CBUILD
%include "c/engine/penalty/InProgress.chkprogress_go.inc"
%else
chkprogress_go:
        mov di, word [refsignal]
        dec edi
        mov word [refsignal], di
        test di, di
        jge short .1
        xor edx, edx
        mov word [refsignal], dx
.1:
        mov bx, word [PenCntDwn]
        dec ebx
        mov word [PenCntDwn], bx
        test bx, bx
        jge near chkprogress_x
        and byte [gmode], 0F7h
        xor esi, esi
        mov word [refsignal], si
        xor eax, eax
.2:
        movsx edx, ax
        inc eax
        cmp byte [nosplit edx*2+PenBuf], 0
        je short chkprogress_x
        movsx edx, ax
        mov edx, dword [nosplit edx*2+PenBuf_m5]
        sar edx, 18h
        cmp byte [dword edx+penmintab], 0
        je short chkprogress_go.2
        or byte [gmode2], 4
        mov edi, 0FFFFFFFFh
        mov word [PenCntDwn2], di
        mov word [SortPending], 1
        mov edx, dword [puckc]
        mov byte [edx], 0FFh
        mov edx, 1Ah
        mov eax, puckstruct
        call assinsert
        mov word [pucktemp1], 1C20h
        mov byte [RefStep+1], 0FFh
        xor ebx, ebx
        mov word [refsignal], bx
        cmp word [bannertimer], byte 0
        jne short chkprogress_x
        mov word [bannermsg], di
chkprogress_x:
        pop edi
        pop esi
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; Stop4Pen                         63543  94G penalty94.asm, medium confidence
; Stop play for penalty entry n of PenBuf (penalty, player).
;
; Unless already stopped (gmode bit 0): pick the faceoff spot fox foy - centre
; for 7, the last touch (ltx lty) for 3 1Dh, else the puck; for 8
; (offside-like) the nearer end dot (y +-4Eh) when inside the blue lines,
;
; for 6 the offender's end (y -258h 258h); the penalty shot spot when
; penshotstart.
;
; Clamp x to +-60h and pull deep spots to the end dots (+-60h, y +-B8h); then
; for every queued penalty move the dot out of the offender's zone (y -3Dh /
; 3Dh, x +-100).
;
; Then PenCntDwn 0, gmode bit 2, the whistle (sfx A4h) and the ref (SetPA 5).
;-----------------------------------------------------------------------------
; C: src/engine/penalty/Stop4Pen.c
%ifdef CBUILD
%include "c/engine/penalty/Stop4Pen.inc"
%else
Stop4Pen:
        push dword 0Ch
        call __CHK
        push edx
        push esi
        movsx edx, ax
        mov al, byte [nosplit edx*2+PenBuf]
        mov ah, byte [nosplit edx*2+PenBuf_pl]
        mov dl, byte [gmode]
        test dl, 1
        jne near .23
        mov dh, dl
        or dh, 1
        mov byte [gmode], dh
        xor edx, edx
        mov word [foy], dx
        mov word [fox], dx
        cmp al, 7
        je near .7
        mov dx, word [ltx]
        mov word [fox], dx
        mov dx, word [lty]
        mov word [foy], dx
        cmp al, 3
        je near .7
        cmp al, 1Dh
        je near .7
        mov edx, dword [puckx]
        mov dx, word [edx]
        mov word [fox], dx
        mov edx, dword [pucky]
        mov dx, word [edx]
        mov word [foy], dx
        cmp al, 8
        jne short .4
        test dx, dx
        jge short .1
        mov edx, dword [foy-2]
        sar edx, 10h
        neg edx
        jmp short .2
.1:
        mov edx, dword [foy-2]
        sar edx, 10h
.2:
        cmp edx, byte 4Eh
        jge short .7
        cmp word [foy], byte 0
        jge short .3
        mov edx, 0FFFFFFB2h
        jmp short .6
.3:
        mov edx, 4Eh
        jmp short .6
.4:
        cmp al, 6
        jne short .7
        movsx edx, ah
        shl edx, 7
        add edx, SortCords
        test byte [byte edx+044h], 80h
        je short .5
        mov edx, 0FFFFFDA8h
        jmp short .6
.5:
        mov edx, 258h
.6:
        mov word [foy], dx
.7:
        cmp dword [penshotstart], byte 0
        je short .8
        mov ax, word [penshotfox]
        mov word [fox], ax
        mov ax, word [penshotfoy]
        mov word [foy], ax
.8:
        cmp word [fox], byte 60h
        jl short .9
        mov word [fox], 60h
        jmp short .10
.9:
        mov edx, dword [fox-2]
        sar edx, 10h
        cmp edx, byte 0FFFFFFA0h
        jg short .10
        mov word [fox], 0FFA0h
.10:
        cmp word [foy], 90h
        jl short .13
        cmp word [fox], byte 0
        jge short .11
        mov edx, 0FFFFFFA0h
        jmp short .12
.11:
        mov edx, 60h
.12:
        mov word [fox], dx
        mov word [foy], 0B8h
        jmp short .16
.13:
        mov edx, dword [foy-2]
        sar edx, 10h
        cmp edx, 0FFFFFF70h
        jg short .16
        cmp word [fox], byte 0
        jge short .14
        mov edx, 0FFFFFFA0h
        jmp short .15
.14:
        mov edx, 60h
.15:
        mov word [fox], dx
        mov word [foy], 0FF48h
.16:
        xor eax, eax
        mov esi, 0FFFFFFC3h
.17:
        movsx edx, ax
        mov dl, byte [nosplit edx*2+PenBuf_pl]
        and dl, 7Fh
        movsx edx, dl
        shl edx, 7
        add edx, SortCords
        test byte [byte edx+044h], 80h
        jne short .19
        mov edx, dword [foy-2]
        sar edx, 10h
        cmp edx, byte 0FFFFFFB2h
        jg short .22
        mov word [foy], si
        cmp word [fox], byte 0
        jge short .18
        mov edx, 0FFFFFF9Ch
        jmp short .21
.18:
        mov edx, 64h
        jmp short .21
.19:
        cmp word [foy], byte 4Eh
        jl short .22
        mov word [foy], 3Dh
        cmp word [fox], byte 0
        jge short .20
        mov edx, 0FFFFFF9Ch
        jmp short .21
.20:
        mov edx, 64h
.21:
        mov word [fox], dx
.22:
        inc eax
        movsx edx, ax
        cmp byte [nosplit edx*2+PenBuf], 0
        jne near Stop4Pen.17
.23:
        xor eax, eax
        mov word [PenCntDwn], ax
        or byte [gmode], 4
        mov eax, 0A4h
        call sfx
        mov eax, 5
        call SetPA
        pop esi
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; checkfornewpen                                    637B5  93G penalty93_1.asm
; checkfornewpen: unless sfhor (sflags bit 7): for each PenBuf entry, Stop4Pen
; at once for penalties without minutes (penmintab) or
;
; when the guilty team has the puck, else delayed penalty (gmode bit 3
; gmpendel, SetPA 1Ch); marks the entry called (bit 7) and raises PenCntDwn to
; pendelaytab*32
;-----------------------------------------------------------------------------
; C: src/engine/penalty/checkfornewpen.c
%ifdef CBUILD
%include "c/engine/penalty/checkfornewpen.inc"
%else
checkfornewpen:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        test byte [sflags], 80h
        jne near .x
        mov dx, word [SortPending]
        test dx, dx
        jne near .x
        jmp near .11
.1:
        mov bh, byte [dword eax+PenBuf_pl]
        test byte [gmode], 4
        jne near .5
        movsx eax, bl
        cmp byte [dword eax+penmintab], 0
        je short .4
        mov eax, dword [puckc]
        mov cl, byte [eax]
        test cl, cl
        jl short .2
        cmp cl, 6
        setl al
        mov ecx, eax
        and ecx, 0FFh
        cmp bh, 6
        setl al
        and eax, 0FFh
        xor eax, ecx
        je short .3
.2:
        mov ch, byte [gmode]
        test ch, 8
        jne near .10
        mov al, ch
        or al, 8
        mov byte [gmode], al
        mov eax, 1Ch
        call SetPA
        jmp near .10
.3:
        mov word [refsignal], 28h
        mov eax, dword [bannermsg-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        je short .4
        mov word [bannertimer], 50h
.4:
        movsx eax, dx
        call Stop4Pen
.5:
        movsx eax, dx
        add eax, eax
        mov bh, byte [dword eax+PenBuf_pl]
        test bh, 80h
        jne near .10
        mov cl, bh
        or cl, 80h
        mov byte [dword eax+PenBuf_pl], cl
        movsx eax, bl
        movsx ax, byte [dword eax+pendelaytab]
        shl eax, 5
        cmp ax, word [PenCntDwn]
        jle short .6
        mov word [PenCntDwn], ax
.6:
        cmp word [injurystop], byte 0
        je short .7
        mov word [PenCntDwn], 140h
.7:
        cmp dword [penshotstart], byte 0
        je short .8
        cmp bl, 5
        jne short .8
        movsx ax, byte [pendelay2tab_e4]
        shl eax, 5
        movsx bx, byte [pendelaytab_e13]
        shl ebx, 5
        mov word [PenCntDwn], bx
        jmp short .9
.8:
        movsx eax, bl
        movsx ax, byte [dword eax+pendelay2tab]
        shl eax, 5
.9:
        cmp ax, word [PenCntDwn2]
        jle short .10
        mov word [PenCntDwn2], ax
.10:
        inc edx
.11:
        movsx eax, dx
        add eax, eax
        mov bl, byte [dword eax+PenBuf]
        test bl, bl
        jne near checkfornewpen.1
.x:
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; releasepl                                         6392A  93G penalty93_1.asm
; releasepl: first sort object of the team (tmsort) not on the ice, tmap += 1,
; tmflags bit 0 on both teams, position from priolist (priolist_m1)
;
; by tmgoalie (team+38h) sign, Setplass, setplayer, pflags2 bit 2 (sort object
; +45h); PC also sets bit 6 of team byte D4h on both teams
;-----------------------------------------------------------------------------
; C: src/engine/penalty/releasepl.c
%ifdef CBUILD
%include "c/engine/penalty/releasepl.inc"
%else
releasepl:
        push dword 0Ch
        call __CHK
        push ebx
        push ecx
        mov ebx, dword [dword eax+tmsort]
.1:
        cmp word [byte ebx+01Ah], byte 0
        jl short .2
        add ebx, 80h
        jmp short releasepl.1
.2:
        inc word [byte eax+tmap]
        or byte [hmtmflags], 1
        or byte [awtmflags], 1
        or byte [hmtmcoachflags], 40h
        or byte [awtmcoachflags], 40h
        cmp word [byte eax+tmgoalie], byte 0
        setl cl
        and ecx, 0FFh
        mov eax, dword [byte eax+tmap-2]
        sar eax, 10h
        movsx ax, byte [dword ecx+eax+priolist_m1]
        mov word [byte ebx+01Ah], ax
        mov eax, ebx
        call Setplass
        movsx edx, dx
        mov eax, ebx
        call setplayer
        or byte [byte ebx+045h], 4
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; chkatop                                           639A4  93G penalty93_1.asm
; chkatop (attack time of possession): puck y beyond the blue line picks the
; attacking team (gmode bit 1 flips), tmATOP += 1; skipped in highlight mode
;-----------------------------------------------------------------------------
; C: src/engine/penalty/chkatop.c
%ifdef CBUILD
%include "c/engine/penalty/chkatop.inc"
%else
chkatop:
        push dword 8
        call __CHK
        push edx
        test byte [gmode], 10h
        jne short .x
        mov eax, dword [pucky]
        mov dx, word [eax]
        cmp dx, byte 4Eh
        jle short .1
        xor eax, eax
        jmp short .2
.1:
        movsx eax, dx
        cmp eax, byte 0FFFFFFB2h
        jge short .x
        mov eax, 1
.2:
        test byte [gmode], 2
        je short .3
        xor al, 1
.3:
        test ax, ax
        jle short .4
        mov eax, awtmstruct
        jmp short .5
.4:
        mov eax, hmtmstruct
.5:
        inc word [byte eax+tmATOP]
.x:
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; updatepentime_ut_chk                                639F9  94G penalty94.asm
; The check part of updatepentime_ut
;-----------------------------------------------------------------------------
; C: src/engine/penalty/updatepentime_ut_chk.c
%ifdef CBUILD
%include "c/engine/penalty/updatepentime_ut_chk.inc"
%else
updatepentime_ut_chk:
        push dword 0Ch
        call __CHK
        push ebx
        push ecx
        mov ebx, eax
        movsx edx, dx
        lea eax, [edx+edx]
        add eax, ebx
        mov cx, word [byte eax+tmpdst]
        and ch, 3Fh
        cmp cx, byte 5
        jg short .x
        cmp word [byte eax+tmpdst], byte 0
        jne short .1
        mov eax, ebx
        call releasepl
.1:
        mov eax, 97h
        call sfx
.x:
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; updatepentime_ut                                    63A37  94G penalty94.asm
; Counts down the penalty times and releases players whose time is up
;-----------------------------------------------------------------------------
; C: src/engine/penalty/InProgress.c (updatepentime_ut)
%ifdef CBUILD
%include "c/engine/penalty/InProgress.updatepentime_ut.inc"
%else
updatepentime_ut:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 4
        mov ecx, eax
        mov edx, 2
        mov dword [regd1], edx
        mov ebx, edx
        mov dword [regd3], edx
        xor edi, edi
        xor ebx, edx
        jmp near .5
.1:
        movsx eax, bx
        movsx ax, byte [dword ecx+eax+tmboxlist]
        test ax, ax
        jl near .6
        mov dx, word [regd1]
        dec edx
        mov word [regd1], dx
        test dx, dx
        jl short .4
        movsx edx, di
        mov byte [esp+edx], al
        movsx esi, ax
        lea eax, [esi+esi]
        inc edi
        add eax, ecx
        mov dx, word [byte eax+tmpdst]
        dec edx
        mov word [byte eax+tmpdst], dx
        test dx, 3FFFh
        jne short .4
        mov edx, esi
        shl edx, 2
        add edx, esi
        shl edx, 3
        sub edx, esi
        mov esi, edx
        mov edx, dword [dword ecx+tmroster]
        mov byte [edx+esi], 7
        and byte [byte eax+tmpdst+1], 0BFh
        mov word [regd2], 1
.2:
        mov eax, dword [regd2-2]
        sar eax, 10h
        movsx edx, bx
        add eax, edx
        mov dl, byte [dword ecx+eax+tmboxlist]
        mov byte [dword ecx+eax+0B5h], dl
        test dl, dl
        jl short .3
        inc word [regd2]
        jmp short updatepentime_ut.2
.3:
        dec ebx
.4:
        inc ebx
.5:
        cmp bx, byte 1Ch
        jl near updatepentime_ut.1
.6:
        mov di, word [regd1]
        cmp di, byte 1
        jne short .7
        mov edx, dword [byte esp-03h]
        jmp short .9
.7:
        test di, di
        jne short .8
        mov edx, dword [byte esp-03h]
        sar edx, 18h
        mov eax, ecx
        call updatepentime_ut_chk
        mov edx, dword [byte esp-02h]
        jmp short .9
.8:
        mov eax, dword [regd1-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        jne short .10
        mov edx, dword [byte esp-02h]
.9:
        sar edx, 18h
        mov eax, ecx
        call updatepentime_ut_chk
.10:
        add esp, byte 4
        jmp near InProgress_popx
%endif ; C
;-----------------------------------------------------------------------------
; updatePPTeamTime                                     63B57  94G period94.asm
; When gmode2 bit 5 (power play) is set adds 1 to the power-play team's time
; word (+08h; home unless bit 6); called once a second from updatepentime
;-----------------------------------------------------------------------------
; C: src/engine/penalty/updatePPTeamTime.c
%ifdef CBUILD
%include "c/engine/penalty/updatePPTeamTime.inc"
%else
updatePPTeamTime:
        push dword 4
        call __CHK
        mov ah, byte [gmode2]
        test ah, 20h
        je short .x
        test ah, 40h
        jne short .1
        mov eax, hmtmstruct
        inc word [byte eax+tmpptime]
        ret
.1:
        mov eax, awtmstruct
        inc word [byte eax+tmpptime]
.x:
        ret
%endif ; C
;-----------------------------------------------------------------------------
; updatepentime                                     63B85  93G penalty93_1.asm
; updatepentime: clears sflags3 bit 6 (sflags3), returns while the clock is
; stopped (gmode bit 0) or a penalty shot is live; Penaltytimer -= 1,
;
; at < 0 += 18h, sets the bit, chkatop, (PC) ChkPowerPlayTime,
; ProcessPenaltyList for both teams
;-----------------------------------------------------------------------------
; C: src/engine/penalty/updatepentime.c
%ifdef CBUILD
%include "c/engine/penalty/updatepentime.inc"
%else
updatepentime:
        push dword 8
        call __CHK
        push edx
        mov ah, byte [sflags3]
        and ah, 0BFh
        mov byte [sflags3], ah
        test byte [gmode], 1
        jne short .x
        cmp dword [penshotlive], byte 0
        jne short .x
        mov dx, word [Penaltytimer]
        dec edx
        mov word [Penaltytimer], dx
        test dx, dx
        jge short .x
        mov dh, ah
        or dh, 40h
        mov byte [sflags3], dh
        add word [Penaltytimer], byte 18h
        call chkatop
        call updatePPTeamTime
        mov eax, hmtmstruct
        call updatepentime_ut
        mov eax, awtmstruct
        call updatepentime_ut
.x:
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; PenaltyManager                                    63BF8  93G penalty93_1.asm
; PenaltyManager (called periodically): updatepentime, checkfornewpen,
; then falls into chkprogress; called from the engine core frame
;-----------------------------------------------------------------------------
; C: src/engine/penalty/InProgress.c (PenaltyManager)
%ifdef CBUILD
%include "c/engine/penalty/InProgress.PenaltyManager.inc"
%else
PenaltyManager:
        push dword 4
        call __CHK
        call updatepentime
        call checkfornewpen
;-----------------------------------------------------------------------------
; chkprogress                                       63C0C  93G penalty93_1.asm
; chkprogress (fall-through from PenaltyManager): with gmpen (gmode bit 2):
; PenCntDwn >= 0 -> chkprogress_go, else InProgress; PC first
;
; (clock stopped) calls UpdateTextOverlay and counts PenCntDwn2 down to set
; gmode2 bit 2
;-----------------------------------------------------------------------------
chkprogress:
        push dword 14h
        call __CHK
        push ebx
        push edx
        push esi
        push edi
        test byte [gmode], 1
        je near chkprogress_x
        call UpdateTextOverlay
        mov dx, word [PenCntDwn2]
        test dx, dx
        jl short .1
        mov ebx, edx
        dec ebx
        mov word [PenCntDwn2], bx
        test bx, bx
        jge short .1
        or byte [gmode2], 4
.1:
        test byte [gmode], 4
        je near chkprogress_x
        cmp word [PenCntDwn], byte 0
        jge near chkprogress_go
        call InProgress
        pop edi
        pop esi
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; UpdatePowerPlayFlags                         63C73  95 PC, medium confidence
; Compares hmtmap with awtmap: equal clears gmode2 bit 5; else sets bit 5 and
; bit 6 for the side with fewer skaters
;-----------------------------------------------------------------------------
; C: src/engine/penalty/UpdatePowerPlayFlags.c
%ifdef CBUILD
%include "c/engine/penalty/UpdatePowerPlayFlags.inc"
%else
UpdatePowerPlayFlags:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov eax, awtmstruct
        mov dx, word [hmtmap]
        mov bx, word [awtmap]
        sub dx, bx
        mov ebx, edx
        jne short .1
        and byte [gmode2], 0DFh
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        mov dx, word [gmode2]
        and dl, 9Fh
        test bx, bx
        jle short .2
        mov eax, hmtmstruct
        test byte [gmode2], 40h
        je short .4
        jmp short .3
.2:
        test byte [gmode2], 40h
        jne short .4
        mov word [gmode2], dx
        or dl, 40h
.3:
        mov word [gmode2], dx
.4:
        mov cl, byte [gmode2]
        test cl, 20h
        jne short .x
        mov ch, cl
        or ch, 20h
        mov byte [gmode2], ch
        inc word [byte eax+04h]
        test byte [gmode], 1
        je short .x
        test byte [gameopts+1], 1
        je short .5
        cmp byte [MusicOn], 0
        jne short .6
.5:
        mov edx, 1
        jmp short .7
.6:
        xor edx, edx
.7:
        test edx, edx
        je short .x
        cmp eax, hmtmstruct
        jne short .8
        mov eax, 1
        jmp short .9
.8:
        mov eax, 4
.9:
        call PlayCrowdSample
.x:
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ClearPenaltyBuffer                                63D3C  93G penalty93_1.asm
; ClearPenaltyBuffer: clears the 32 byte pairs of PenBuf (E9A16); called
; from the clock code, PenGoalStuff role code and game_frame
;-----------------------------------------------------------------------------
; C: src/engine/penalty/ClearPenaltyBuffer.c
%ifdef CBUILD
%include "c/engine/penalty/ClearPenaltyBuffer.inc"
%else
ClearPenaltyBuffer:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        xor edx, edx
        jmp short .2
.1:
        movsx eax, dx
        xor bl, bl
        mov byte [nosplit eax*2+PenBuf_pl], bl
        mov byte [nosplit eax*2+PenBuf], bl
        inc edx
.2:
        cmp dx, byte 20h
        jl short ClearPenaltyBuffer.1
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; PenGoalStuff                     63D69  94G penalty94.asm, medium confidence
; After a goal, for the scored-on team: drops finished minor penalties from
; PenBuf (penmintab 2, or 5 / not -1), clears the box flag of released players
;
; and returns a player to the ice when the team is short
;-----------------------------------------------------------------------------
PenGoalStuff:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        push eax
        test ax, ax
        jle short .1
        mov ebp, awtmstruct
        jmp short .2
.1:
        mov ebp, hmtmstruct
.2:
        cmp word [esp], byte 0
        sete al
        and eax, 0FFh
        je short .3
        mov edi, awtmstruct
        jmp short .4
.3:
        mov edi, hmtmstruct
.4:
        xor eax, eax
        xor ebx, ebx
        jmp near .13
.5:
        cmp word [gsp], byte 3
        jne short .6
        mov dx, word [hmscore]
        cmp dx, word [awscore]
        jne short .7
.6:
        mov edx, 1
        jmp short .8
.7:
        xor edx, edx
.8:
        test edx, edx
        je near .10
        movsx ecx, bx
        add ecx, ecx
        mov edx, dword [dword ecx+PenBuf-3]
        sar edx, 18h
        mov esi, dword [dword edx+penmintab-3]
        sar esi, 18h
        cmp esi, byte 0FFFFFFFFh
        je short .9
        cmp byte [dword edx+penmintab], 5
        je short .9
        cmp byte [dword edx+penmintab], 2
        jne short .10
        cmp byte [dword ecx+PenBuf_pl], 6
        setl dl
        mov ecx, edx
        and ecx, 0FFh
        mov edx, dword [byte esp-02h]
        sar edx, 10h
        xor edx, ecx
        je short .10
.9:
        cmp ax, bx
        je short .12
        movsx esi, bx
        movsx edx, ax
        mov cl, byte [nosplit esi*2+PenBuf]
        mov byte [nosplit edx*2+PenBuf], cl
        mov cl, byte [nosplit esi*2+PenBuf_pl]
        mov byte [nosplit edx*2+PenBuf_pl], cl
        inc eax
        jmp short .12
.10:
        movsx edx, bx
        add edx, edx
        mov cl, byte [dword edx+PenBuf_pl]
        test cl, cl
        jl short .11
        cmp cl, 0Ch
        jge short .11
        mov edx, dword [dword edx+PenBuf_pl-3]
        sar edx, 18h
        shl edx, 7
        and byte [dword edx+scpflags2], 0EFh
.11:
        movsx edx, bx
        xor ch, ch
        mov byte [nosplit edx*2+PenBuf_pl], ch
        mov byte [nosplit edx*2+PenBuf], ch
.12:
        inc ebx
.13:
        movsx edx, bx
        cmp byte [nosplit edx*2+PenBuf], 0
        jne near PenGoalStuff.5
        cmp byte [PenBuf], 0
        jne short .14
        cmp word [bannermsg], byte 6
        jne short .14
        mov word [bannermsg], 0FFFFh
.14:
        mov dx, word [byte ebp+036h]
        cmp dx, word [byte edi+036h]
        jle near .20
        xor ebx, ebx
        jmp short .16
.15:
        movsx edx, bx
        movsx ax, byte [dword edx+edi+0B6h]
        test ax, ax
        jl near .20
        movsx edx, ax
        test byte [byte edi+edx*2+07Fh], 40h
        je short .17
        inc ebx
.16:
        cmp bx, byte 1Ch
        jl short PenGoalStuff.15
.17:
        movsx ecx, ax
        mov eax, ecx
        mov word [byte edi+eax*2+07Eh], 0
        mov esi, ecx
        shl esi, 2
        add esi, ecx
        shl esi, 3
        sub esi, ecx
        mov edx, dword [dword edi+0EEh]
        mov byte [edx+esi], 7
        mov edx, ecx
        mov eax, edi
        call releasepl
        mov eax, dword [dword edi+0EEh]
        xor edx, edx
        mov dl, byte [byte esi+eax+05h]
        cmp word [esp], byte 0
        sete al
        xor ah, ah
        cwde
        call PanelRemovePenalty
        mov eax, 1
.18:
        movsx edx, ax
        movsx ecx, bx
        add edx, ecx
        mov cl, byte [dword edx+edi+0B6h]
        mov byte [dword edx+edi+0B5h], cl
        test cl, cl
        jl short .19
        inc eax
        jmp short PenGoalStuff.18
.19:
        inc word [byte ebp+02h]
        or byte [hmtmflags], 1
        or byte [awtmflags], 1
.20:
        add esp, byte 4
        jmp near InProgress_popebp
;-----------------------------------------------------------------------------
; SetupPenaltyShot                             63F72  95 PC, medium confidence
; Stops puck, reassigns puck and shooter (penshotplayer) behaviours, clears
; penalty buffer
;-----------------------------------------------------------------------------
; C: src/engine/penalty/SetupPenaltyShot.c
%ifdef CBUILD
%include "c/engine/penalty/SetupPenaltyShot.inc"
%else
SetupPenaltyShot:
        push dword 10h
        call __CHK
        push ebx
        push edx
        push esi
        mov ebx, dword [puckvz]
        mov word [ebx], 0
        mov ax, word [ebx]
        mov ebx, dword [puckvy]
        mov word [ebx], ax
        mov ebx, dword [puckvx]
        mov word [ebx], ax
        mov ebx, dword [puckz]
        mov word [ebx], ax
        mov ebx, dword [pucky]
        mov word [ebx], ax
        mov edx, dword [puckx]
        mov word [edx], ax
        mov edx, 18h
        mov eax, puckstruct
        call assreplace
        mov ebx, dword [penshotplayer]
        shl ebx, 7
        add ebx, SortCords
        and byte [byte ebx+pflags2], 0DBh
        and byte [byte ebx+pflags], 0FBh
        mov edx, 2Eh
        mov eax, ebx
        call assinsert
        mov edx, 2Eh
        mov eax, ebx
        call assinsert
        mov edx, 2Eh
        mov eax, ebx
        call assinsert
        mov edx, 2Eh
        mov eax, ebx
        call assinsert
        mov edx, 2Eh
        mov eax, ebx
        call assinsert
        mov edx, 2Eh
        mov eax, ebx
        call assinsert
        mov edx, 2Eh
        mov eax, ebx
        call assinsert
        mov edx, 2Eh
        mov eax, ebx
        call assinsert
        cmp dword [penshotteam], byte 0
        sete al
        and eax, 0FFh
        mov edx, dword [cont1team-2]
        sar edx, 10h
        inc eax
        cmp edx, eax
        jne short .1
        mov edx, dword [c1playernum-2]
        sar edx, 10h
        cmp edx, byte 0FFFFFFFFh
        je short .1
        mov eax, 0FFFFFFFFh
        call restorepl
        mov word [c1playernum], ax
.1:
        cmp dword [penshotteam], byte 0
        sete al
        xor edx, edx
        mov dl, al
        mov eax, dword [cont2team-2]
        sar eax, 10h
        inc edx
        cmp eax, edx
        jne short .2
        mov edx, dword [c2playernum-2]
        sar edx, 10h
        cmp edx, byte 0FFFFFFFFh
        je short .2
        mov eax, 0FFFFFFFFh
        call restorepl
        mov word [c2playernum], ax
.2:
        mov ebx, dword [byte ebx+06Ch]
        mov word [byte ebx+034h], 0FFFFh
        mov ax, word [byte ebx+034h]
        mov word [byte ebx+032h], ax
        mov word [byte ebx+tmtouch1], ax
        mov edx, dword [puckc]
        add word [Crowdlevel], byte 64h
        mov al, byte [penshotplayer]
        mov byte [edx], al
        mov esi, 1
        mov dword [penshotlive], esi
        mov dword [penshotstart], esi
        mov dword [penshottimer], 3E8h
        call ClearPenaltyBuffer
        pop esi
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ShotLaneOpen                                    64102  95 PC, low confidence
; Puck carrier: 0 unless no opposing skater stands between him and the net
; (distance to the goal line E8h vs each defender); sets shotontarget
;-----------------------------------------------------------------------------
; C: src/engine/penalty/InProgress.c (ShotLaneOpen)
%ifdef CBUILD
%include "c/engine/penalty/InProgress.ShotLaneOpen.inc"
%else
ShotLaneOpen:
        push dword 2Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 8
        xor edx, edx
        mov dword [shotontarget], edx
        mov eax, dword [puckc]
        mov dl, byte [eax]
        test dl, dl
        jge short .2
.1:
        xor eax, eax
        jmp near .15
.2:
        movsx eax, dl
        shl eax, 7
        mov esi, SortCords
        add esi, eax
        mov ebp, dword [byte esi+Ypos]
        sar ebp, 10h
        mov edi, ebp
        mov eax, dword [esi]
        sar eax, 10h
        test byte [byte esi+pflags], 80h
        je near .8
        test ebp, ebp
        jl short ShotLaneOpen.1
        push eax
        add ebp, byte 4
        sub edi, 0E8h
        push edi
        call vecdist
        add esp, byte 8
        mov dword [byte esp+04h], eax
        xor ecx, ecx
        mov dword [esp], ecx
        xor edi, edi
        cmp word [byte esi+SCnum], byte 6
        jge short .3
        mov eax, 6
        jmp short .4
.3:
        xor eax, eax
.4:
        shl eax, 7
        mov esi, SortCords
        add esi, eax
        jmp short .7
.5:
        cmp word [byte esi+position], byte 0
        jle short .6
        mov edx, dword [esi]
        sar edx, 10h
        mov eax, dword [byte esi+Ypos]
        sar eax, 10h
        cmp eax, ebp
        jg short ShotLaneOpen.1
        cmp word [byte esi+Yvel], byte 0
        jl short .6
        push edx
        sub eax, 0E8h
        push eax
        call vecdist
        add esp, byte 8
        mov edx, dword [byte esp+04h]
        sub edx, dword [esp]
        cmp eax, edx
        jle near ShotLaneOpen.1
.6:
        inc edi
        add esi, 80h
.7:
        cmp edi, byte 6
        jl short ShotLaneOpen.5
        jmp near .14
.8:
        test ebp, ebp
        jg near ShotLaneOpen.1
        push eax
        sub ebp, byte 4
        add edi, 0E8h
        push edi
        call vecdist
        add esp, byte 8
        mov dword [byte esp+04h], eax
        xor ebx, ebx
        mov dword [esp], ebx
        xor edi, edi
        cmp word [byte esi+SCnum], byte 6
        jge short .9
        mov eax, 6
        jmp short .10
.9:
        xor eax, eax
.10:
        shl eax, 7
        mov esi, SortCords
        add esi, eax
        jmp short .13
.11:
        cmp word [byte esi+position], byte 0
        jle short .12
        mov edx, dword [esi]
        sar edx, 10h
        mov eax, dword [byte esi+Ypos]
        sar eax, 10h
        cmp eax, ebp
        jl near ShotLaneOpen.1
        cmp word [byte esi+Yvel], byte 0
        jg short .12
        push edx
        add eax, 0E8h
        push eax
        call vecdist
        add esp, byte 8
        mov edx, dword [byte esp+04h]
        sub edx, dword [esp]
        cmp eax, edx
        jle near ShotLaneOpen.1
.12:
        inc edi
        add esi, 80h
.13:
        cmp edi, byte 6
        jl short ShotLaneOpen.11
.14:
        mov esi, 1
        mov dword [shotontarget], esi
        mov eax, esi
.15:
        add esp, byte 8
        jmp near InProgress_popebp
%endif ; C
;-----------------------------------------------------------------------------
; QuickShotChk                                    6427F  95 PC, low confidence
; Human-controlled carrier with gameopts bit 0, shotongoal set and
; moving/facing toward the net within E4h of the goal line with a goalie in:
;
; re-checks ShotLaneOpen and returns 1
;-----------------------------------------------------------------------------
; C: src/engine/penalty/QuickShotChk.c
%ifdef CBUILD
%include "c/engine/penalty/QuickShotChk.inc"
%else
QuickShotChk:
        push dword 10h
        call __CHK
        push ebx
        push edx
        push esi
        mov edx, eax
        test byte [gmode], 10h
        jne short .1
        test byte [gameopts], 1
        je short .1
        mov eax, dword [puckc]
        movsx ax, byte [eax]
        cmp ax, word [byte edx+SCnum]
        jne short .1
        cmp dword [shotongoal], byte 0
        jne short .2
.1:
        xor eax, eax
        pop esi
        pop edx
        pop ebx
        ret
.2:
        test byte [byte edx+pflags], 80h
        je short .3
        cmp word [byte edx+Yvel], byte 0
        jl short QuickShotChk.1
        mov bx, word [byte edx+facedir]
        cmp bx, byte 2
        jl short .4
        cmp bx, byte 6
        jg short .4
        jmp short QuickShotChk.1
.3:
        cmp word [byte edx+Yvel], byte 0
        jg short QuickShotChk.1
        mov si, word [byte edx+facedir]
        cmp si, byte 2
        jle short QuickShotChk.1
        cmp si, byte 6
        jge short QuickShotChk.1
.4:
        call ShotLaneOpen
        mov eax, dword [shotontarget]
        mov dword [shotongoal], eax
        test eax, eax
        je short .x
        cmp word [byte edx+Ypos+2], byte 0
        jge short .5
        mov eax, dword [byte edx+Ypos]
        sar eax, 10h
        neg eax
        jmp short .6
.5:
        mov eax, dword [byte edx+Ypos]
        sar eax, 10h
.6:
        cmp eax, 0E4h
        jg short QuickShotChk.1
        mov eax, dword [byte edx+070h]
        cmp word [byte eax+tmgoalie], byte 0
        jl short QuickShotChk.1
        mov eax, 1
.x:
        pop esi
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CountShotOnGoal                              64338  95 PC, medium confidence
; ShotLaneOpen decides whether the shot is on goal (shotontarget ->
; shotongoal); if so Crowdlevel +64h and, outside penshotmode,
;
; the shooting team's +1Ch shots count is incremented
;-----------------------------------------------------------------------------
; C: src/engine/penalty/CountShotOnGoal.c
%ifdef CBUILD
%include "c/engine/penalty/CountShotOnGoal.inc"
%else
CountShotOnGoal:
        push dword 8
        call __CHK
        push edx
        call ShotLaneOpen
        mov eax, dword [shotontarget]
        mov dword [shotongoal], eax
        test eax, eax
        je short .3
        add word [Crowdlevel], byte 64h
        cmp dword [penshotmode], byte 0
        jne short .3
        mov eax, dword [puckc]
        cmp byte [eax], 5
        setg al
        and eax, 0FFh
        je short .1
        mov eax, awtmstruct
        jmp short .2
.1:
        mov eax, hmtmstruct
.2:
        mov edx, 1
        inc word [byte eax+01Ch]
        mov eax, edx
        pop edx
        ret
.3:
        xor edx, edx
        mov eax, edx
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; StartPenaltyShot                             64398  95 PC, medium confidence
; Penshotmode=1, saves shooter team / player and two words of state, counts
; the shot
;-----------------------------------------------------------------------------
; C: src/engine/penalty/StartPenaltyShot.c
%ifdef CBUILD
%include "c/engine/penalty/StartPenaltyShot.inc"
%else
StartPenaltyShot:
        push dword 0Ch
        call __CHK
        push ebx
        push esi
        cmp dword [penshotmode], byte 0
        jne near .x
        cmp dword [penshotplayer], byte 5
        setg al
        and eax, 0FFh
        mov dword [penshotteam], eax
        test eax, eax
        jle short .1
        mov eax, awtmstruct
        jmp short .2
.1:
        mov eax, hmtmstruct
.2:
        inc word [byte eax+020h]
        mov ebx, 1
        mov word [hmtmap], bx
        mov word [awtmap], bx
        mov eax, dword [penshotplayer]
        shl eax, 7
        mov eax, dword [dword eax+SortCords+44h]
        sar eax, 18h
        mov dword [penshotpnum], eax
        mov dword [penshotmode], 1
        mov eax, dword [fox-2]
        sar eax, 10h
        mov dword [penshotfox], eax
        mov eax, dword [foy-2]
        sar eax, 10h
        mov dword [penshotfoy], eax
        xor esi, esi
        mov word [fox], si
        mov word [foy], si
.x:
        pop esi
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; EndPenaltyShot                               64439  95 PC, medium confidence
; Clears penshotmode / penshotlive / penshotplayer, AddPenalty2, restores
; state
;-----------------------------------------------------------------------------
; C: src/engine/penalty/EndPenaltyShot.c
%ifdef CBUILD
%include "c/engine/penalty/EndPenaltyShot.inc"
%else
EndPenaltyShot:
        push dword 0Ch
        call __CHK
        push ecx
        push edx
        cmp dword [penshotlive], byte 0
        je short .x
        cmp dword [penshotmode], byte 0
        je short .x
        xor ecx, ecx
        mov dword [penshotmode], ecx
        mov dword [penshotlive], ecx
        mov dword [penshotplayer], 0FFFFFFFFh
        mov edx, 5
        mov eax, puckstruct
        call AddPenalty2
        mov ax, word [penshotfox]
        mov word [ltx], ax
        mov ax, word [penshotfoy]
        mov word [lty], ax
        mov edx, 21h
        mov eax, SortCords+800h
        call assreplace
.x:
        pop edx
        pop ecx
        ret
%endif ; C
