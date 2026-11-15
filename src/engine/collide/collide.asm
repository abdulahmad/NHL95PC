; Contact and the puck. Checks, passes, shots, and collisions with players,
; the boards, the goal, and the goalie's stick.
bits 32
%include "hockey.inc"
section s_53294 progbits alloc exec nowrite align=1
extern __CHK, a2touchpuck, Acheck, AddPenalty, AddPenalty2, assexit, assinsert, assreplace
extern AvgCline, awshotcnt, awtmap, awtmstruct, bannermsg, bannertimer, blockspd, blockspd_y
extern regd1_b1, c1playernum, c2playernum, camx, camy, CanBlockShot, CanRemovePlayer, changeplayer
extern clockticks, collflag, CompLine, cont1team, cont2team, CountShotOnGoal, crowdlevel, CwdExciteLvl
extern dirtab, dirtab_y, doplayeracc, nethit, checkinglist_m2, regd3_m2, regd5_m2, regd0_m3
extern regd1_m3, dword_E9A9E, dword_E9AB6, EndPenaltyShot, fox, foy, gameclock, gameopts
extern GetHot, GetHotOrStick, GetHotStick, GiveControl, gmode, gmode2, Goal, gsp
extern hmshotcnt, hmtmap, hmtmstruct, iflags, imul32, lastplayer, lasttouch, ltack
extern lty, goaliemenuflags, goaliemenuflags_e02, onetimerflag, OOlist, OOlistpos, pad1dev, PassCompleted
extern passdir, passplayer, passspeed, PBnum, PenBuf, penshotctl, penshotlive, penshotmode
extern penshotplayer, penshotstart, PerTimeTotal, PostInjuryEvent, puckc, puckcross, puckcross_m2, puckflip
extern pucknopuck, puckvx, puckvy, puckvz, puckx, pucky, puckz, QuickShotChk
extern randomd0, regd0, regd1, regd2, regd3, regd4, RemoveFromLines, restorepl
extern SetBoxDoorObject, setpersonel, SetSPA, sflags, sflags3, sfx, ShotLaneOpen, shotongoal
extern shotontarget, shotplayer, shotsets, shotsetz, SortCords, Stop4Pen, sub_93470, threat
extern vecdist, vtoa, wcradiusx, wcradiusy, refhitcount, injurystop, FallDown_pinxr, FallDown_pinxl
extern FallDown_pinyt, FallDown_pinyb, FallDown_pinxr2, FallDown_pinxl2, word_E03A0, regd5, lastimpact, xc1
extern yc1, Ylist, Ylist_m2
global ToFixed, Sweepcheck, burst, BlockShotDive, TryBlockShot, check4check, checkagr, FacingBoards
global checkcheck, checkgoalp, checkint, checkob, checkob_ret5a, checkob_ret5, SkillForAnim, ChkDelayedOffside
global checkpuckcoll_ccx, checkpuckcoll, CheckBump, GetLowestPen, chk4lc, chk4lc_shoot, PassLaneChk, PassLaneChk_ret5a
global PassLaneChk_ret5, ScatterPass, dopass, dopass_ret6, passmode, setpassmode, passtoa0, chk4pass
global chk4shot, CompShoot, ChkOffsides, MarkTwoLinePlayers, ChkShotStat, setInjuryType, NetCollide, FallDown
global Bcheck, holdcheck, puckbody, PuckIChk, puckshadow, puckglue, puckgoalie, puckstick
global SetShotMode, ShotMode, Findhittype, deflect, shotdiradj, doshot, newcheck, checkcoll
global checkwallcoll, checkgoal, wallcoll, wallcollb, checkplcoll, checkcx, CPgoalie, ChkGoalies
global ReturnGoalies, ChkPullGoalieLate
;-----------------------------------------------------------------------------
; ToFixed                                                         53294  95 PC
; Eax << 16 (integer to 16.16); passtoa0 calls it
;-----------------------------------------------------------------------------
; C: src/engine/collide/ToFixed.c
%ifdef CBUILD
%include "c/engine/collide/ToFixed.inc"
%else
ToFixed:
        push dword 4
        call __CHK
        shl eax, 10h
        ret
%endif ; C
;-----------------------------------------------------------------------------
; Sweepcheck                         532A2  94G logic94.asm, medium confidence
;-----------------------------------------------------------------------------
; C: src/engine/collide/Sweepcheck.c
%ifdef CBUILD
%include "c/engine/collide/Sweepcheck.inc"
%else
Sweepcheck:
        push dword 8
        call __CHK
        push edx
        or byte [byte eax+044h], 20h
        mov edx, 589h
        call SetSPA
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; burst                                               532BD  93G logic93_1.asm
; Manual trace: CCh energy cost, energy>>7 dir-vector push, same constants as
; 93G burst
;-----------------------------------------------------------------------------
; C: src/engine/collide/checkob.c (burst)
%ifdef CBUILD
%include "c/engine/collide/checkob.burst.inc"
%else
burst:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov edx, dword [byte eax+044h]
        sar edx, 18h
        mov ebx, dword [byte eax+06Ch]
        mov dx, word [byte ebx+edx*2+tmpde]
        mov word [regd0], dx
        test byte [gameopts], 4
        je short .3
        mov dx, word [regd0]
        sub edx, 0CCh
        mov word [regd0], dx
        test dx, dx
        jge short .1
        xor edx, edx
        jmp short .2
.1:
        mov edx, dword [regd0-2]
        sar edx, 10h
.2:
        mov ebx, edx
        mov edx, dword [byte eax+044h]
        sar edx, 18h
        mov ecx, dword [byte eax+06Ch]
        mov word [byte ecx+edx*2+tmpde], bx
        cmp word [regd0], byte 0
        jge short .3
        xor esi, esi
        mov word [regd0], si
.3:
        mov di, word [regd0]
        sar di, 7
        mov word [regd0], di
        mov edx, dword [byte eax+facedir-2]
        sar edx, 10h
        mov dx, word [nosplit edx*4+dirtab]
        imul edx, edi
        add word [byte eax+Xvel], dx
        mov edx, dword [byte eax+facedir-2]
        sar edx, 10h
        mov dx, word [nosplit edx*4+dirtab_y]
        imul dx, word [regd0]
        add word [byte eax+Yvel], dx
        or byte [byte eax+pflags], 20h
        mov edx, 621h
        call SetSPA
        jmp near checkob_ret5
%endif ; C
;-----------------------------------------------------------------------------
; BlockShotDive                                53387  95 PC, medium confidence
; eax = player, edx = dive direction from CanBlockShot. High puck or fast Zvel: SPA 14ADh /
; 1475h; else a sliding block. blockspd is the X speed and blockspd_y the Y speed for that facing.
;-----------------------------------------------------------------------------
; C: src/engine/collide/BlockShotDive.c
%ifdef CBUILD
%include "c/engine/collide/BlockShotDive.inc"
%else
BlockShotDive:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        mov ebx, edx
        or byte [byte eax+pflags], 20h
        movsx dx, byte [byte eax+052h]
        mov word [byte eax+facedir], dx
        cmp ebx, byte 0Ah
        je short .1
        cmp ebx, byte 3
        jne short .3
.1:
        mov edx, dword [puckz]
        cmp word [edx], byte 3
        jge short .2
        mov ebx, dword [puckvz]
        cmp word [ebx], 7D0h
        jge short .2
        mov ebx, 14ADh
        jmp near .19
.2:
        mov ebx, 1475h
        jmp near .19
.3:
        mov dx, word [byte eax+04Ah]
        mov word [byte eax+facedir], dx
        mov esi, edx
        add esi, edx
        movsx edx, si
        mov dx, word [nosplit edx*2+blockspd_y]
        cmp ebx, byte 3
        jge short .4
        neg edx
.4:
        mov ecx, dword [byte eax+Yvel-2]
        sar ecx, 10h
        movsx edi, dx
        xor edi, ecx
        test edi, edi
        jl short .8
        cmp word [byte eax+Yvel], byte 0
        jge short .5
        neg ecx
.5:
        test dx, dx
        jge short .6
        movsx edi, dx
        neg edi
        jmp short .7
.6:
        movsx edi, dx
.7:
        cmp ecx, edi
        jle short .8
        sar word [byte eax+Yvel], 1
        jmp short .9
.8:
        sar word [byte eax+Yvel], 3
.9:
        add word [byte eax+Yvel], dx
        movsx edx, si
        mov dx, word [nosplit edx*2+blockspd]
        cmp ebx, byte 3
        jge short .10
        neg edx
.10:
        cmp byte [byte eax+065h], 0
        sete cl
        and ecx, 0FFh
        cmp ebx, byte 3
        setl bl
        and ebx, 0FFh
        xor ebx, ecx
        je short .11
        mov ebx, 13C5h
        jmp short .12
.11:
        mov ebx, 141Dh
.12:
        mov ecx, dword [byte eax+Xvel-2]
        sar ecx, 10h
        movsx edi, dx
        xor edi, ecx
        test edi, edi
        jl short .17
        cmp word [byte eax+Xvel], byte 0
        jge short .13
        mov edi, ecx
        neg edi
        jmp short .14
.13:
        mov edi, ecx
.14:
        test dx, dx
        jge short .15
        movsx ecx, dx
        neg ecx
        jmp short .16
.15:
        movsx ecx, dx
.16:
        cmp edi, ecx
        jle short .17
        sar word [byte eax+Xvel], 1
        jmp short .18
.17:
        sar word [byte eax+Xvel], 3
.18:
        add word [byte eax+Xvel], dx
.19:
        movsx edx, bx
        call SetSPA
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; TryBlockShot                                 534BB  95 PC, medium confidence
; Random roll from attribute 5Ah (easier for the human team's opponents,
; gmode2 bits 5/6), then CanBlockShot and BlockShotDive; called from
; check4check
;-----------------------------------------------------------------------------
; C: src/engine/collide/TryBlockShot.c
%ifdef CBUILD
%include "c/engine/collide/TryBlockShot.inc"
%else
TryBlockShot:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov ecx, eax
        mov ebx, 8
        test byte [gmode2], 20h
        je short .1
        mov al, byte [byte ecx+044h]
        and al, 40h
        and eax, 0FFh
        mov dx, word [gmode2]
        xor dh, dh
        and dl, 40h
        movsx edx, dx
        xor eax, edx
        je short .1
        mov ebx, 4
.1:
        xor eax, eax
        mov al, byte [byte ecx+05Ah]
        mov edx, 0Fh
        sub edx, eax
        add ebx, edx
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        cwde
        call randomd0
        cmp ax, 1
        jg short .x
        mov eax, ecx
        call CanBlockShot
        test eax, eax
        je short .x
        mov edx, eax
        mov eax, ecx
        call BlockShotDive
.x:
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; check4check                        53537  94G logic94.asm, medium confidence
;-----------------------------------------------------------------------------
; C: src/engine/collide/checkob.c (check4check)
%ifdef CBUILD
%include "c/engine/collide/checkob.check4check.inc"
%else
check4check:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ecx, eax
        xor eax, eax
        mov al, byte [byte ecx+064h]
        mov edx, 14h
        sub edx, eax
        mov word [regd0], dx
        test byte [gameopts], 1
        je short .1
        mov eax, dword [regd0-2]
        sar eax, 10h
        mov edx, eax
        sar edx, 1
        add eax, edx
        mov word [regd0], ax
.1:
        mov ax, word [regd0]
        add eax, eax
        cwde
        call randomd0
        cmp ax, 8
        jg near checkob_ret5
        cmp word [byte ecx+SCnum], byte 6
        jge short .2
        mov eax, 6
        jmp short .3
.2:
        xor eax, eax
.3:
        shl eax, 7
        mov ebx, SortCords
        add ebx, eax
        mov word [regd2], 6
.4:
        cmp word [byte ebx+position], byte 0
        je near .10
        test byte [byte ebx+pflags], 20h
        jne near .10
        test byte [byte ebx+pflags2], 1
        jne near .10
        mov ax, word [byte ebx+Xpos+2]
        mov dx, word [byte ecx+Xpos+2]
        sub eax, edx
        mov word [regd0], ax
        test ax, ax
        jge short .5
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .6
.5:
        mov eax, dword [regd0-2]
        sar eax, 10h
.6:
        cmp eax, byte 1Eh
        jg near .10
        mov ax, word [byte ebx+Ypos+2]
        mov di, word [byte ecx+Ypos+2]
        sub eax, edi
        mov word [regd1], ax
        test ax, ax
        jge short .7
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .8
.7:
        mov eax, dword [regd1-2]
        sar eax, 10h
.8:
        cmp eax, byte 1Eh
        jg short .10
        mov edx, dword [regd1-2]
        sar edx, 10h
        mov eax, dword [regd0-2]
        sar eax, 10h
        call vtoa
        cmp ax, word [byte ecx+facedir]
        jne short .10
        mov eax, 4
        call randomd0
        test ax, ax
        je short .9
        mov eax, ecx
        call burst
        jmp near checkob_ret5
.9:
        mov edx, ebx
        mov eax, ecx
        call Acheck
        jmp near checkob_ret5
.10:
        add ebx, 80h
        mov si, word [regd2]
        dec si
        mov word [regd2], si
        jne near check4check.4
        mov eax, ecx
        call TryBlockShot
        jmp near checkob_ret5
%endif ; C
;-----------------------------------------------------------------------------
; checkagr                         5369F  94G collide94.asm, medium confidence
;-----------------------------------------------------------------------------
; C: src/engine/collide/checkagr.c
%ifdef CBUILD
%include "c/engine/collide/checkagr.inc"
%else
checkagr:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov edx, eax
        xor eax, eax
        mov al, byte [byte edx+062h]
        mov ebx, 14h
        sub ebx, eax
        mov eax, ebx
        shl eax, 4
        test byte [byte edx+pflags], 8
        je short .1
        add eax, eax
.1:
        mov ecx, dword [edx]
        sar ecx, 10h
        mov ebx, dword [puckx]
        movsx ebx, word [ebx]
        sub ecx, ebx
        mov ebx, ecx
        test ecx, ecx
        jge short .2
        neg ebx
.2:
        cmp ebx, byte 28h
        jg short .4
        mov ecx, dword [byte edx+Ypos]
        sar ecx, 10h
        mov ebx, dword [pucky]
        movsx ebx, word [ebx]
        sub ecx, ebx
        mov ebx, ecx
        test ecx, ecx
        jge short .3
        neg ebx
.3:
        cmp ebx, byte 28h
        jg short .4
        sar ax, 1
.4:
        cmp word [gsp], byte 2
        jle short .5
        shl eax, 3
.5:
        test byte [gameopts+1], 2
        jne short .6
        add eax, eax
.6:
        mov ebx, dword [byte edx+070h]
        mov ecx, dword [byte edx+06Ch]
        mov bx, word [byte ebx+tmap]
        sub bx, word [byte ecx+tmap]
        cmp bx, byte 1
        jl short .7
        shl eax, 2
.7:
        cmp bx, byte 2
        jl short .8
        shl eax, 2
.8:
        test byte [gmode], 8
        je short .9
        mov ebx, dword [puckc]
        cmp byte [ebx], 0
        jl short .9
        cmp word [byte edx+SCnum], byte 6
        setl dl
        mov ebx, edx
        and ebx, 0FFh
        mov edx, dword [puckc]
        cmp byte [edx], 6
        setl dl
        and edx, 0FFh
        xor edx, ebx
        je short .9
        shl eax, 2
.9:
        movsx edx, ax
        mov eax, edx
        sar eax, 1
        add eax, edx
        cwde
        call randomd0
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; FacingBoards                                 5378D  95 PC, medium confidence
; 1 when the player is near the boards or the end boards (|x| > 78h, |y| >
; E8h/F2h) and facing them (facedir); checkcheck uses it
;-----------------------------------------------------------------------------
; C: src/engine/collide/FacingBoards.c
%ifdef CBUILD
%include "c/engine/collide/FacingBoards.inc"
%else
FacingBoards:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov bx, word [byte eax+Xpos+2]
        mov dx, word [byte eax+Ypos+2]
        mov ax, word [byte eax+facedir]
        movsx ecx, bx
        cmp ecx, byte 0FFFFFF88h
        jge short .4
        cmp ax, 6
        je short .3
        cmp dx, 0E8h
        jle short .1
        cmp ax, 7
        je short .3
.1:
        movsx edx, dx
        cmp edx, 0FFFFFF18h
        jge near .8
        cmp ax, 5
.2:
        jne short .8
.3:
        mov eax, 1
        pop edx
        pop ecx
        pop ebx
        ret
.4:
        cmp bx, byte 78h
        jle short .6
        cmp ax, 2
        je short FacingBoards.3
        cmp dx, 0E8h
        jle short .5
        cmp ax, 1
        je short FacingBoards.3
.5:
        movsx edx, dx
        cmp edx, 0FFFFFF18h
        jge short .8
        cmp ax, 3
        jmp short FacingBoards.2
.6:
        cmp dx, 0F2h
        jle short .7
        test ax, ax
        je short FacingBoards.3
.7:
        movsx edx, dx
        cmp edx, 0FFFFFF0Eh
        jge short .8
        cmp ax, 4
        jmp short FacingBoards.2
.8:
        xor eax, eax
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; checkcheck                                          5382C  94G collide94.asm
; Two players in contact: hold (holdcheck), B-check (Bcheck), hits into
; the boards (FacingBoards), penalties (checkagr, AddPenalty), FallDown.
;-----------------------------------------------------------------------------
checkcheck:
        push dword 1Ch
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 8
        mov esi, eax
        mov ecx, edx
        mov dword [esp], ebx
        xor ah, ah
        mov byte [byte esp+04h], ah
        jmp near .46
.1:
        mov dx, word [byte ecx+SPA]
        cmp dx, 639h
        je short .2
        cmp dx, 873h
        jne short .3
.2:
        mov edx, ecx
        mov eax, esi
        call holdcheck
        jmp near .45
.3:
        cmp dx, 589h
        jne short .4
        mov edx, ecx
        mov eax, esi
        call Bcheck
        jmp near .45
.4:
        cmp word [byte esi+SPA], 621h
        jne near .45
        test byte [gmode], 1
        je short .5
        mov word [byte esi+impact], 100h
        mov word [byte ecx+018h], 100h
.5:
        mov ax, word [byte ecx+Ypos+2]
        sub ax, word [byte esi+Ypos+2]
        movsx edx, ax
        mov bx, word [byte ecx+Xpos+2]
        sub bx, word [byte esi+Xpos+2]
        movsx eax, bx
        call vtoa
        mov edi, eax
        mov dx, word [byte esi+facedir]
        mov ebx, eax
        sub ebx, edx
        xor bh, bh
        and bl, 7
        test byte [byte esi+attribute], 8
        je short .6
        mov eax, 8
        sub eax, ebx
        mov ebx, eax
        xor bh, ah
        and bl, 7
.6:
        or byte [byte esi+pflags], 20h
        cmp word [byte ecx+Xpos+2], byte 0
        jge short .7
        mov eax, dword [ecx]
        sar eax, 10h
        neg eax
        jmp short .8
.7:
        mov eax, dword [ecx]
        sar eax, 10h
.8:
        cmp eax, 90h
        jg short .13
        test byte [byte esi+pflags], 80h
        setne al
        mov edx, eax
        and edx, 0FFh
        cmp word [byte esi+Ypos+2], byte 0
        setg al
        and eax, 0FFh
        xor eax, edx
        je short .14
        cmp word [byte ecx+Ypos+2], byte 0
        jge short .9
        mov eax, dword [byte ecx+Ypos]
        sar eax, 10h
        neg eax
        jmp short .10
.9:
        mov eax, dword [byte ecx+Ypos]
        sar eax, 10h
.10:
        sub eax, 0E8h
        cmp eax, byte 3Ch
        jge short .14
        cmp word [byte ecx+Xpos+2], byte 0
        jge short .11
        mov eax, dword [ecx]
        sar eax, 10h
        neg eax
        jmp short .12
.11:
        mov eax, dword [ecx]
        sar eax, 10h
.12:
        cmp eax, byte 50h
        jge short .14
.13:
        mov eax, 14h
        jmp short .15
.14:
        mov eax, 1Eh
.15:
        cmp word [byte ecx+SCnum], byte 10h
        je near .24
        xor edx, edx
        mov dl, byte [byte esi+062h]
        cwde
        call randomd0
        cmp ax, dx
        jge near .24
        movsx eax, bx
        inc eax
        and eax, byte 7
        cmp eax, byte 2
        jg near .24
        mov edx, dword [esi]
        sar edx, 10h
        mov eax, dword [ecx]
        sar eax, 10h
        sub edx, eax
        mov eax, edx
        test edx, edx
        jge short .16
        neg eax
.16:
        cmp eax, byte 14h
        jge near .24
        mov edx, dword [byte esi+Ypos]
        sar edx, 10h
        mov eax, dword [byte ecx+Ypos]
        sar eax, 10h
        sub edx, eax
        mov eax, edx
        test edx, edx
        jge short .17
        neg eax
.17:
        cmp eax, byte 14h
        jge near .24
        cmp word [byte ecx+Xvel], byte 0
        jge short .18
        mov eax, dword [byte ecx+Xvel-2]
        sar eax, 10h
        neg eax
        jmp short .19
.18:
        mov eax, dword [byte ecx+Xvel-2]
        sar eax, 10h
.19:
        cmp eax, 1F4h
        jge short .22
        cmp word [byte ecx+Yvel], byte 0
        jge short .20
        mov eax, dword [byte ecx+Yvel-2]
        sar eax, 10h
        neg eax
        jmp short .21
.20:
        mov eax, dword [byte ecx+Yvel-2]
        sar eax, 10h
.21:
        cmp eax, 1F4h
        jl short .23
.22:
        mov ebp, dword [byte esi+facedir-2]
        sar ebp, 10h
        mov edx, dword [byte ecx+Yvel-2]
        sar edx, 10h
        mov eax, dword [byte ecx+Xvel-2]
        sar eax, 10h
        call vtoa
        cwde
        sub eax, ebp
        add eax, byte 2
        test al, 3
        je short .24
.23:
        mov edx, 0ED7h
        jmp short .25
.24:
        movsx eax, bx
        mov edx, dword [nosplit eax*2+checkinglist_m2]
        sar edx, 10h
.25:
        mov eax, esi
        call SetSPA
        cmp word [byte ecx+position], byte 0
        je near .45
        cmp word [esp], byte 14h
        jl near .45
        test byte [byte esi+pflags], 8
        je short .26
        mov ebx, 0A0h
        jmp short .27
.26:
        mov ebx, 64h
.27:
        test byte [byte ecx+pflags], 8
        setne al
        and eax, 0FFh
        cmp bx, 0A0h
        sete dl
        and edx, 0FFh
        xor eax, edx
        je short .28
        mov ebx, 78h
.28:
        xor edx, edx
        mov dl, byte [byte esi+weight]
        movsx eax, bx
        sub eax, edx
        mov edx, eax
        xor eax, eax
        mov al, byte [byte ecx+056h]
        add edx, eax
        sar edx, 1
        mov eax, dword [byte ecx+016h]
        sar eax, 10h
        sub edx, eax
        mov ebx, edx
        test dx, dx
        jle near .30
        test byte [gmode], 10h
        jne short .29
        mov eax, ecx
        call QuickShotChk
        test eax, eax
        je short .29
        cmp dword [penshotplayer], byte 0
        jl short .30
.29:
        movsx eax, bx
        call randomd0
        xor edx, edx
        mov dl, byte [byte esi+064h]
        cmp ax, dx
        jle short .30
        cmp word [byte ecx+SCnum], byte 10h
        je near .45
        mov eax, esi
        call checkagr
        cmp ax, 4
        jg near .45
        test byte [gmode], 10h
        jne near .45
        mov eax, 2
        call randomd0
        test ax, ax
        setne al
        and eax, 0FFh
        add eax, byte 0Bh
        movsx edx, ax
        mov eax, esi
        call AddPenalty
        jmp near .45
.30:
        cmp word [byte ecx+SCnum], byte 10h
        jne short .31
        test byte [byte esi+pflags], 8
        je near .45
        mov dx, word [refhitcount]
        inc edx
        mov word [refhitcount], dx
        cmp dx, byte 3
        jl near .44
        xor edi, edi
        mov word [refhitcount], di
        mov edx, 16h
        mov eax, esi
        call AddPenalty
        jmp near .44
.31:
        test byte [gmode], 10h
        jne near .44
        mov eax, ecx
        call QuickShotChk
        test eax, eax
        je short .35
        cmp dword [penshotplayer], byte 0
        jge near .44
        mov eax, dword [byte ecx+SCnum-2]
        sar eax, 10h
        mov dword [penshotplayer], eax
        mov eax, dword [c1playernum-2]
        sar eax, 10h
        mov edi, dword [penshotplayer]
        cmp eax, edi
        jne short .32
        mov dword [penshotctl], 1
        jmp short .34
.32:
        jne short .33
        mov dword [penshotctl], 2
        jmp short .34
.33:
        mov dword [penshotctl], 0FFFFFFFFh
.34:
        mov edx, 1Ah
        jmp near .43
.35:
        cmp word [byte ecx+018h], byte 23h
        jle short .36
        mov eax, dword [byte esi+facedir-2]
        sar eax, 10h
        movsx edx, di
        sub edx, eax
        inc edx
        and edx, byte 7
        cmp edx, byte 2
        jg short .36
        mov edx, dword [byte ecx+facedir-2]
        sar edx, 10h
        sub edx, eax
        inc edx
        and edx, byte 7
        cmp edx, byte 2
        jg short .36
        mov eax, ecx
        call FacingBoards
        test ax, ax
        je short .36
        mov eax, esi
        call checkagr
        cmp ax, 14h
        jge short .36
        mov edx, 17h
        jmp near .43
.36:
        mov eax, esi
        call checkagr
        cmp ax, 3
        jg near .44
        cmp word [byte esi+SPA], 0ED7h
        jne short .39
        mov eax, 0Ah
        call randomd0
        cmp ax, 8
        jle short .37
        mov eax, 13h
        jmp short .38
.37:
        mov eax, 0Eh
.38:
        movsx edx, ax
        jmp short .43
.39:
        cmp word [byte ecx+018h], byte 23h
        jle short .40
        mov eax, 4
        call randomd0
        test ax, ax
        jne short .40
        mov edx, 19h
        jmp short .43
.40:
        mov eax, 0Ah
        call randomd0
        cmp ax, 6
        jle short .41
        mov eax, 15h
        jmp short .42
.41:
        mov eax, 0Dh
.42:
        movsx edx, ax
.43:
        mov eax, esi
        call AddPenalty
.44:
        mov edx, ecx
        mov eax, esi
        call FallDown
.45:
        mov eax, ecx
        mov ecx, esi
        mov esi, eax
        inc byte [byte esp+04h]
.46:
        cmp byte [byte esp+04h], 2
        jl near checkcheck.1
        add esp, byte 8
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
;-----------------------------------------------------------------------------
; checkgoalp                       53CE5  94G collide94.asm, medium confidence
;-----------------------------------------------------------------------------
checkgoalp:
        push dword 14h
        call __CHK
        push esi
        push edi
        mov edi, eax
        mov si, word [byte eax+06Ah]
        cmp si, byte 0Bh
        jle short .1
        cmp si, byte 10h
        jne near .x
.1:
        sub cx, word [byte edx+Ypos+2]
        sub bx, word [byte edx+Xpos+2]
        cmp word [byte edx+SCnum], byte 0Ch
        jne short .2
        movsx esi, cx
        mov eax, dword [wcradiusy-2]
        sar eax, 10h
        add eax, esi
        cmp eax, byte 0FFFFFFDEh
        jl near .x
        jmp short .3
.2:
        movsx esi, cx
        mov eax, dword [wcradiusy-2]
        sar eax, 10h
        sub esi, eax
        cmp esi, byte 22h
        jge near .x
.3:
        test bx, bx
        jge short .4
        movsx eax, bx
        neg eax
        jmp short .5
.4:
        movsx eax, bx
.5:
        mov esi, dword [wcradiusx-2]
        sar esi, 10h
        sub eax, esi
        cmp eax, byte 40h
        jge near .x
        mov eax, ecx
        neg eax
        mov word [regd0], ax
        mov word [regd1], bx
        movsx esi, bx
        imul esi, esi
        sar esi, 2
        cmp esi, 100h
        jg near .x
        movsx eax, cx
        imul eax, eax
        add eax, eax
        add eax, esi
        cmp eax, 100h
        jg near .x
        cmp word [byte edi+06Ah], byte 10h
        je short .6
        mov eax, edi
        call CheckBump
        test ax, ax
        jne near .x
.6:
        movsx eax, cx
        push eax
        movsx eax, bx
        push eax
        call vecdist
        add esp, byte 8
        mov ebx, eax
        inc ebx
        mov edx, dword [regd0-2]
        sar edx, 10h
        shl edx, 8
        xor esi, esi
        mov si, bx
        mov eax, edx
        sar edx, 1Fh
        idiv esi
        mov word [regd0], ax
        cmp ax, 0FFh
        jle short .7
        mov word [regd0], 0FFh
.7:
        mov eax, dword [regd0-2]
        sar eax, 10h
        cmp eax, 0FFFFFF01h
        jge short .8
        mov word [regd0], 0FF01h
.8:
        mov edx, dword [regd1-2]
        sar edx, 10h
        shl edx, 8
        xor esi, esi
        mov si, bx
        mov eax, edx
        sar edx, 1Fh
        idiv esi
        mov word [regd1], ax
        cmp ax, 0FFh
        jle short .9
        mov word [regd1], 0FFh
.9:
        mov eax, dword [regd1-2]
        sar eax, 10h
        cmp eax, 0FFFFFF01h
        jge short .10
        mov word [regd1], 0FF01h
.10:
        mov dword [nethit], 1
        mov eax, edi
        call wallcoll
.x:
        pop edi
        pop esi
        ret
;-----------------------------------------------------------------------------
; checkint                         53E6A  94G collide94.asm, medium confidence
; 93G checkint (interference penalty): checkagr-style roll with randomd0,
; AddPenalty, FallDown; called from checkcx
;-----------------------------------------------------------------------------
; C: src/engine/collide/checkint.c
%ifdef CBUILD
%include "c/engine/collide/checkint.inc"
%else
checkint:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        sub esp, byte 4
        mov ebx, eax
        mov ecx, edx
        xor ah, ah
        mov byte [esp], ah
        jmp near .7
.1:
        cmp word [byte ecx+position], byte 0
        jne near .6
        test byte [gmode], 1
        jne near .6
        mov eax, dword [puckc]
        movsx ax, byte [eax]
        cmp ax, word [byte ebx+SCnum]
        je short .2
        cmp word [byte ebx+impact], byte 19h
        jle near .6
.2:
        cmp word [byte ebx+impact], byte 2
        jle near .6
        mov edx, ebx
        mov eax, ecx
        call FallDown
        mov dx, word [lastimpact]
        cmp dx, byte 8
        jl near .6
        mov eax, dword [puckc]
        movsx ax, byte [eax]
        cmp ax, word [byte ebx+SCnum]
        jne short .3
        cmp dx, byte 0Ah
        jl near .6
.3:
        cmp word [byte ecx+Ypos+2], byte 0
        jge short .4
        mov eax, dword [byte ecx+Ypos]
        sar eax, 10h
        neg eax
        jmp short .5
.4:
        mov eax, dword [byte ecx+Ypos]
        sar eax, 10h
.5:
        cmp eax, 0A0h
        jl short .6
        cmp word [byte ebx+SCnum], byte 10h
        je short .6
        mov eax, dword [byte ebx+044h]
        sar eax, 18h
        mov edx, dword [byte ebx+tmptr]
        mov eax, dword [byte edx+eax*2+tmpdst-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFDh
        jle short .6
        cmp word [byte ecx+impact], byte 1Eh
        jle short .6
        test byte [byte ebx+pflags2], 10h
        jne short .6
        xor eax, eax
        mov al, byte [byte ebx+062h]
        mov edx, 14h
        sub edx, eax
        movsx eax, dx
        call randomd0
        cmp ax, 2
        jg short .6
        test byte [gmode], 10h
        jne short .6
        test byte [byte ecx+06h], 4
        jne short .6
        mov edx, 11h
        mov eax, ebx
        call AddPenalty
.6:
        mov eax, ebx
        mov ebx, ecx
        mov ecx, eax
        inc byte [esp]
.7:
        cmp byte [esp], 2
        jl near checkint.1
        add esp, byte 4
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; checkob                            53F8C  94G logic94.asm, medium confidence
;-----------------------------------------------------------------------------
checkob:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 4
        mov edi, eax
        xor edx, edx
        mov dword [esp], edx
        xor ebx, ebx
        test byte [gameopts], 2
        je near checkob_ret5a
        cmp dword [penshotlive], byte 0
        jne near checkob_ret5a
        cmp dword [penshotstart], byte 0
        jne near checkob_ret5a
        cmp word [byte edi+SCnum], byte 6
        jge short .1
        xor eax, eax
        jmp short .2
.1:
        mov eax, 6
.2:
        shl eax, 7
        add eax, SortCords
        test byte [byte edi+pflags], 80h
        jne short .8
        mov ecx, dword [byte edi+Ypos]
        sar ecx, 10h
        cmp ecx, byte 0FFFFFFAEh
        jle short .3
        cmp word [byte edi+Yvel], byte 0
        jg short .3
        mov ebx, 4
.3:
        lea esi, [byte ebx+04Eh]
        neg esi
        mov ecx, dword [pucky]
        movsx ecx, word [ecx]
        cmp esi, ecx
        jg near .13
        xor dl, dl
        jmp short .7
.4:
        cmp word [byte eax+01Ah], byte 0
        jl short .6
        mov ecx, dword [byte eax+04h]
        sar ecx, 10h
        lea esi, [byte ebx+04Eh]
        neg esi
        cmp esi, ecx
        jle short .6
.5:
        mov dword [esp], 1
        jmp short .13
.6:
        add eax, 80h
        inc dl
.7:
        cmp dl, 6
        jl short checkob.4
        jmp short .13
.8:
        cmp word [byte edi+Ypos+2], byte 52h
        jge short .9
        cmp word [byte edi+Yvel], byte 0
        jl short .9
        mov ebx, 4
.9:
        mov ecx, dword [pucky]
        movsx ecx, word [ecx]
        lea esi, [byte ebx+04Eh]
        cmp esi, ecx
        jl short .13
        xor dl, dl
        jmp short .12
.10:
        cmp word [byte eax+01Ah], byte 0
        jl short .11
        mov ecx, dword [byte eax+04h]
        sar ecx, 10h
        lea esi, [byte ebx+04Eh]
        cmp esi, ecx
        jl short checkob.5
.11:
        add eax, 80h
        inc dl
.12:
        cmp dl, 6
        jl short checkob.10
.13:
        cmp word [esp], byte 0
        je short .14
        mov bh, byte [gmode2]
        test bh, 80h
        jne near checkob_ret5a
        mov cl, bh
        or cl, 80h
        mov byte [gmode2], cl
        cmp word [bannermsg], byte 4
        jge near checkob_ret5a
        test byte [byte edi+pflags], 80h
        setne al
        mov ebx, eax
        and ebx, 0FFh
        mov eax, dword [pucky]
        cmp word [eax], byte 0
        setl al
        and eax, 0FFh
        xor eax, ebx
        je short checkob_ret5a
        mov word [bannermsg], 4
        xor edx, edx
        mov word [bannertimer], dx
        jmp short checkob_ret5a
.14:
        mov dh, byte [gmode2]
        test dh, 80h
        je short checkob_ret5a
        mov bl, dh
        and bl, 7Fh
        mov byte [gmode2], bl
        cmp word [bannermsg], byte 4
        jne short checkob_ret5a
        cmp word [bannertimer], byte 0
        jne short checkob_ret5a
        mov word [bannermsg], 0FFFFh
checkob_ret5a:
        add esp, byte 4
checkob_ret5:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; SkillForAnim                                    54134  95 PC, low confidence
; Returns the stick-handling attribute byte (5Dh / 62h / 65h) that fits the
; player's current animation (SPA codes 0B1h, 0C9h, 0E1h, 101h, 119h, 11D5h,
; 121Dh); checkpuckcoll
;-----------------------------------------------------------------------------
; C: src/engine/collide/checkob.c (SkillForAnim)
%ifdef CBUILD
%include "c/engine/collide/checkob.SkillForAnim.inc"
%else
SkillForAnim:
        push dword 8
        call __CHK
        push edx
        mov dx, word [byte eax+038h]
        cmp dx, 101h
        jb short .2
        jbe near .11
        cmp dx, 11D5h
        jb short .1
        jbe short .4
        cmp dx, 121Dh
        je near .11
        jmp near .12
.1:
        cmp dx, 119h
        je short .8
        jmp near .12
.2:
        cmp dx, 0C9h
        jb short .3
        jbe short .4
        cmp dx, 0E1h
        je short .4
        jmp short .12
.3:
        cmp dx, 0B1h
        je short .7
        jmp short .12
.4:
        cmp byte [byte eax+065h], 0
        jne short .6
.5:
        mov al, byte [byte eax+05Dh]
        jmp short .13
.6:
        mov al, byte [byte eax+062h]
        jmp short .13
.7:
        cmp byte [byte eax+065h], 0
        jne short SkillForAnim.5
        jmp short SkillForAnim.6
.8:
        cmp byte [byte eax+065h], 0
        jne short .10
.9:
        mov al, byte [byte eax+061h]
        jmp short .13
.10:
        mov al, byte [byte eax+05Fh]
        jmp short .13
.11:
        cmp byte [byte eax+065h], 0
        jne short SkillForAnim.9
        jmp short SkillForAnim.10
.12:
        mov al, byte [byte eax+05Bh]
.13:
        and eax, 0FFh
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ChkDelayedOffside                            541CA  95 PC, medium confidence
; Offsides option: the flagged team touches the puck in the zone -> AddPenalty2 8 on
; SortCords[lasttouch], returns 1. Called from checkpuckcoll_ccx before puckstick puckgoalie.
;-----------------------------------------------------------------------------
; C: src/engine/collide/ChkDelayedOffside.c
%ifdef CBUILD
%include "c/engine/collide/ChkDelayedOffside.inc"
%else
ChkDelayedOffside:
        push dword 8
        call __CHK
        push edx
        test byte [gameopts], 2
        jne short .2
.1:
        xor eax, eax
        pop edx
        ret
.2:
        test byte [gmode], 10h
        jne short ChkDelayedOffside.1
        cmp dword [penshotlive], byte 0
        jne short ChkDelayedOffside.1
        cmp dword [penshotstart], byte 0
        jne short ChkDelayedOffside.1
        mov edx, dword [pucky]
        movsx edx, word [edx]
        test edx, edx
        jge short .3
        neg edx
.3:
        cmp edx, 0E8h
        jg short ChkDelayedOffside.1
        test byte [byte eax+pflags], 80h
        je short .4
        mov edx, 2
        jmp short .5
.4:
        xor edx, edx
.5:
        mov edx, dword [nosplit edx*2+puckcross_m2]
        sar edx, 10h
        test edx, edx
        jge short .6
        neg edx
.6:
        cmp edx, byte 2Ch
        jg short ChkDelayedOffside.1
        mov edx, dword [byte eax+optmptr]
        test byte [byte edx+tmflags], 10h
        je short ChkDelayedOffside.1
        cmp word [byte eax+SCnum], byte 6
        setl al
        mov edx, eax
        and edx, 0FFh
        cmp word [lasttouch], byte 6
        setl al
        and eax, 0FFh
        cmp eax, edx
        jne short .7
        xor eax, edx
        pop edx
        ret
.7:
        mov eax, dword [lasttouch-2]
        sar eax, 10h
        shl eax, 7
        add eax, SortCords
        mov edx, 8
        call AddPenalty2
        mov eax, 1
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; checkpuckcoll_ccx                                   5428A  94G collide94.asm
; The per-object puck test (stick, body, goalie): the 94G local
; checkpuckcoll.ccx; 94S checkpuckcoll_ccx
;-----------------------------------------------------------------------------
checkpuckcoll_ccx:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        mov ecx, eax
        mov eax, dword [puckc]
        movsx ax, byte [eax]
        cmp dx, ax
        je near PassLaneChk_ret5
        cmp dx, byte 0Bh
        jle short .1
        cmp dx, byte 10h
        jne near PassLaneChk_ret5
.1:
        movsx eax, dx
        shl eax, 7
        mov ebx, SortCords
        add ebx, eax
        test byte [byte ebx+pflags], 4
        jne near PassLaneChk_ret5
        cmp word [byte ebx+03Eh], byte 0
        jne near PassLaneChk_ret5
        test byte [byte ebx+pflags2], 4
        jne near .22
        cmp word [byte ebx+position], byte 0
        jne near .22
        mov eax, ebx
        call SkillForAnim
        mov edi, eax
        mov eax, dword [puckvx]
        mov dx, word [eax]
        test dx, dx
        jge short .2
        movsx edx, dx
        neg edx
        jmp short .3
.2:
        movsx edx, dx
.3:
        mov eax, dword [puckvy]
        mov si, word [eax]
        test si, si
        jge short .4
        movsx eax, si
        neg eax
        jmp short .5
.4:
        movsx eax, si
.5:
        add eax, edx
        mov esi, eax
        test ax, ax
        jne short .6
        mov esi, 1
.6:
        movsx eax, di
        shl eax, 0Bh
        movsx esi, si
        lea edx, [dword eax-0FA0h]
        mov eax, edx
        sar edx, 1Fh
        idiv esi
        mov edi, eax
        test ax, ax
        jge short .7
        xor edi, eax
.7:
        cmp di, byte 4
        jle short .8
        mov edi, 4
.8:
        mov eax, ebx
        call GetHotOrStick
        cmp word [regd0], byte 0
        jge short .9
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .10
.9:
        mov eax, dword [regd0-2]
        sar eax, 10h
.10:
        mov word [regd2], ax
        mov edx, dword [regd2-2]
        sar edx, 10h
        shl edx, 2
        mov esi, 3
        mov eax, edx
        sar edx, 1Fh
        idiv esi
        mov word [regd4], ax
        cmp word [regd1], byte 0
        jge short .11
        mov esi, dword [regd1-2]
        sar esi, 10h
        neg esi
        jmp short .12
.11:
        mov esi, dword [regd1-2]
        sar esi, 10h
.12:
        movsx edx, si
        shl edx, 2
        mov ebp, 3
        mov eax, edx
        sar edx, 1Fh
        idiv ebp
        mov word [regd3], ax
        add word [regd2], di
        mov eax, ebx
        call GetHot
        mov edx, dword [puckx]
        mov ax, word [byte ebx+Xpos+2]
        sub ax, word [edx]
        mov dx, word [regd0]
        add edx, eax
        mov word [regd0], dx
        test dx, dx
        jge short .13
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .14
.13:
        mov eax, dword [regd0-2]
        sar eax, 10h
.14:
        mov word [regd0], ax
        cmp ax, word [regd2]
        jge near .21
        mov edx, dword [pucky]
        mov ax, word [byte ebx+Ypos+2]
        sub ax, word [edx]
        mov dx, word [regd1]
        add edx, eax
        mov word [regd1], dx
        test dx, dx
        jge short .15
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .16
.15:
        mov eax, dword [regd1-2]
        sar eax, 10h
.16:
        mov word [regd1], ax
        cmp ax, word [regd2]
        jge near .21
        mov dx, word [regd4]
        add edx, esi
        cmp dx, byte 5
        jle short .17
        movsx eax, dx
        jmp short .18
.17:
        mov eax, 5
.18:
        mov edx, eax
        add edx, edi
        mov eax, dword [puckz]
        cmp dx, word [eax]
        jl near .21
        mov dx, word [regd4]
        sub esi, edx
        mov edx, esi
        sub edx, edi
        test dx, dx
        jl short .19
        cmp dx, word [eax]
        jge near .21
.19:
        mov edx, dword [regd0-2]
        sar edx, 10h
        imul edx, edx
        mov eax, dword [regd1-2]
        sar eax, 10h
        imul eax, eax
        add edx, eax
        mov dword [regd0], edx
        mov eax, dword [regd2-2]
        sar eax, 10h
        imul eax, eax
        mov dword [regd1], eax
        cmp word [byte ecx+03Eh], byte 0
        jle short .20
        mov ebp, eax
        sar ebp, 2
        mov dword [regd1], ebp
.20:
        mov ax, word [regd1]
        cmp ax, word [regd0]
        jl near .21
        mov eax, ebx
        call ChkDelayedOffside
        mov edx, ebx
        mov eax, ecx
        call puckstick
.21:
        cmp word [byte ebx+position], byte 0
        jne near .33
        mov ax, word [byte ebx+Xpos+2]
        mov dx, word [byte ecx+02h]
        sub eax, edx
        mov word [regd0], ax
        test ax, ax
        jge near .29
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp near .30
.22:
        test byte [byte ebx+pflags2], 4
        jne short checkpuckcoll_ccx.21
        cmp word [byte ebx+position], byte 0
        jl short checkpuckcoll_ccx.21
        cmp dx, byte 10h
        je short checkpuckcoll_ccx.21
        cmp word [byte ecx+0Ah], byte 5
        jg short checkpuckcoll_ccx.21
        cmp word [byte ecx+010h], 200h
        jg short checkpuckcoll_ccx.21
        mov eax, ebx
        call GetHot
        mov ax, word [byte ebx+Xpos+2]
        sub ax, word [byte ecx+02h]
        mov dx, word [regd0]
        add edx, eax
        mov word [regd0], dx
        test dx, dx
        jge short .23
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .24
.23:
        mov eax, dword [regd0-2]
        sar eax, 10h
.24:
        cmp eax, byte 0Eh
        jg near checkpuckcoll_ccx.21
        mov ax, word [byte ebx+Ypos+2]
        sub ax, word [byte ecx+06h]
        mov dx, word [regd1]
        add edx, eax
        mov word [regd1], dx
        test dx, dx
        jge short .25
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .26
.25:
        mov eax, dword [regd1-2]
        sar eax, 10h
.26:
        cmp eax, byte 0Eh
        jg near checkpuckcoll_ccx.21
        mov edx, dword [regd0-2]
        sar edx, 10h
        imul edx, edx
        mov eax, dword [regd1-2]
        sar eax, 10h
        imul eax, eax
        add edx, eax
        mov dword [regd0], edx
        mov dword [regd1], 0C4h
        cmp word [byte ecx+03Eh], byte 0
        jle short .27
        sar word [regd1], 2
.27:
        mov eax, dword [regd0]
        cmp eax, dword [regd1]
        ja near checkpuckcoll_ccx.21
        mov dx, word [byte ebx+012h]
        cmp dx, 430h
        jl short .28
        cmp dx, 44Fh
        jg short .28
        cmp eax, byte 24h
        ja near checkpuckcoll_ccx.21
.28:
        mov edx, ebx
        mov eax, ecx
        call puckstick
        jmp near PassLaneChk_ret5
.29:
        mov eax, dword [regd0-2]
        sar eax, 10h
.30:
        cmp eax, byte 0Ah
        jg near PassLaneChk_ret5
        mov ax, word [byte ebx+Ypos+2]
        mov di, word [byte ecx+06h]
        sub eax, edi
        mov word [regd1], ax
        test ax, ax
        jge short .31
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .32
.31:
        mov eax, dword [regd1-2]
        sar eax, 10h
.32:
        cmp eax, byte 0Ah
        jg near PassLaneChk_ret5
        mov edx, dword [regd0-2]
        sar edx, 10h
        imul edx, edx
        mov eax, dword [regd1-2]
        sar eax, 10h
        imul eax, eax
        add eax, edx
        cmp eax, byte 64h
        ja near PassLaneChk_ret5
        mov eax, ebx
        call ChkDelayedOffside
        mov edx, ebx
        mov eax, ecx
        call puckgoalie
        jmp near PassLaneChk_ret5
.33:
        mov dx, word [byte ebx+012h]
        cmp dx, 431h
        jl near .40
        cmp dx, 44Fh
        jg near .40
        test dl, 1
        je near .40
        mov eax, dword [puckz]
        cmp word [eax], byte 8
        jge near .40
        mov eax, ebx
        call GetHotStick
        mov ax, word [regd0]
        sar ax, 1
        mov word [regd0], ax
        sar word [regd1], 1
        test ax, ax
        jge short .34
        mov edi, dword [regd0-2]
        sar edi, 10h
        neg edi
        jmp short .35
.34:
        mov edi, dword [regd0-2]
        sar edi, 10h
.35:
        mov ax, word [byte ebx+Xpos+2]
        sub ax, word [byte ecx+02h]
        mov si, word [regd0]
        add esi, eax
        mov word [regd0], si
        test si, si
        jge short .36
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .37
.36:
        mov eax, dword [regd0-2]
        sar eax, 10h
.37:
        movsx esi, di
        cmp eax, esi
        jg short .40
        mov ax, word [byte ebx+Ypos+2]
        sub ax, word [byte ecx+06h]
        mov si, word [regd1]
        add esi, eax
        mov word [regd1], si
        test si, si
        jge short .38
        mov esi, dword [regd1-2]
        sar esi, 10h
        neg esi
        jmp short .39
.38:
        mov esi, dword [regd1-2]
        sar esi, 10h
.39:
        movsx eax, di
        cmp esi, eax
        jg short .40
        mov edi, dword [regd0-2]
        sar edi, 10h
        imul edi, edi
        mov esi, dword [regd1-2]
        sar esi, 10h
        imul esi, esi
        add edi, esi
        mov dword [regd0], edi
        imul eax, eax
        cmp eax, edi
        jae near .46
.40:
        mov edi, 8
        mov esi, 40h
        cmp dx, 44Fh
        jle short .41
        mov edi, 10h
        mov esi, 100h
.41:
        mov ax, word [byte ebx+Xpos+2]
        mov dx, word [byte ecx+02h]
        sub eax, edx
        mov word [regd0], ax
        test ax, ax
        jge short .42
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .43
.42:
        mov eax, dword [regd0-2]
        sar eax, 10h
.43:
        movsx edx, di
        cmp eax, edx
        jg near PassLaneChk_ret5
        mov ax, word [byte ebx+Ypos+2]
        mov dx, word [byte ecx+06h]
        sub eax, edx
        mov word [regd1], ax
        test ax, ax
        jge short .44
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .45
.44:
        mov eax, dword [regd1-2]
        sar eax, 10h
.45:
        movsx edx, di
        cmp eax, edx
        jg near PassLaneChk_ret5
        mov edx, dword [regd0-2]
        sar edx, 10h
        imul edx, edx
        mov eax, dword [regd1-2]
        sar eax, 10h
        imul eax, eax
        add edx, eax
        mov dword [regd0], edx
        movsx eax, si
        cmp eax, edx
        jb near PassLaneChk_ret5
.46:
        mov edx, ebx
        mov eax, ecx
        call puckbody
        jmp near PassLaneChk_ret5
;-----------------------------------------------------------------------------
; checkpuckcoll                                       548AC  94G collide94.asm
; The 94G checkpuckcoll step for step: stop past y 190h, return above Z 16,
; walk the OOlist up and down within 40 and test each object (.ccx)
;-----------------------------------------------------------------------------
; C: src/engine/collide/checkpuckcoll.c
%ifdef CBUILD
%include "c/engine/collide/checkpuckcoll.inc"
%else
checkpuckcoll:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov ebx, eax
        cmp word [byte eax+06h], byte 0
        jge short .1
        mov eax, dword [byte eax+04h]
        sar eax, 10h
        neg eax
        jmp short .2
.1:
        mov eax, dword [byte eax+04h]
        sar eax, 10h
.2:
        cmp eax, 190h
        jle short .3
        mov word [byte ebx+Yvel], 0
        mov ax, word [byte ebx+Yvel]
        mov word [byte ebx+Xvel], ax
.3:
        cmp word [byte ebx+0Ah], byte 10h
        jg near .x
        mov ecx, dword [byte ebx+SCnum-2]
        sar ecx, 10h
        mov cx, word [nosplit ecx*2+OOlistpos]
        jmp short .5
.4:
        movsx eax, cx
        movsx dx, byte [dword eax+OOlist+1]
        mov eax, dword [dword eax+OOlist-2]
        sar eax, 18h
        mov esi, dword [nosplit eax*2+Ylist_m2]
        sar esi, 10h
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
        sub esi, eax
        cmp esi, byte 28h
        jg short .6
        movsx edx, dx
        mov eax, ebx
        call checkpuckcoll_ccx
        inc ecx
.5:
        cmp cx, byte 10h
        jne short checkpuckcoll.4
.6:
        mov ecx, dword [byte ebx+SCnum-2]
        sar ecx, 10h
        mov cx, word [nosplit ecx*2+OOlistpos]
        test cx, cx
        je short .x
.7:
        movsx eax, cx
        movsx dx, byte [dword eax+OOlist-1]
        mov eax, dword [dword eax+OOlist-4]
        sar eax, 18h
        mov eax, dword [nosplit eax*2+Ylist_m2]
        sar eax, 10h
        mov esi, dword [byte ebx+Ypos]
        sar esi, 10h
        sub esi, eax
        cmp esi, byte 28h
        jg short .x
        movsx edx, dx
        mov eax, ebx
        call checkpuckcoll_ccx
        dec cx
        jne short checkpuckcoll.7
.x:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CheckBump                        54990  94G collide94.asm, medium confidence
;-----------------------------------------------------------------------------
; C: src/engine/collide/CheckBump.c
%ifdef CBUILD
%include "c/engine/collide/CheckBump.inc"
%else
CheckBump:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push esi
        mov ebx, eax
        mov eax, 20h
        call randomd0
        test ax, ax
        jne near .10
        mov eax, dword [pucky]
        mov ax, word [eax]
        sub ax, word [byte edx+Ypos+2]
        test ax, ax
        jge short .1
        cwde
        neg eax
        jmp short .2
.1:
        cwde
.2:
        cmp eax, byte 28h
        jg near .10
        mov cx, word [byte ebx+0Ch]
        mov ax, word [byte ebx+0Eh]
        test cx, cx
        jge short .3
        movsx esi, cx
        neg esi
        jmp short .4
.3:
        movsx esi, cx
.4:
        cmp esi, 1B58h
        jg short .7
        test ax, ax
        jge short .5
        movsx esi, ax
        neg esi
        jmp short .6
.5:
        movsx esi, ax
.6:
        cmp esi, 1B58h
        jle short .10
.7:
        movsx esi, cx
        sar esi, 2
        mov word [byte edx+Xvel], si
        cwde
        sar eax, 2
        mov word [byte edx+Yvel], ax
        mov word [byte ebx+0Ch], 0
        mov word [byte ebx+0Eh], 0
        or byte [sflags], 40h
        test byte [gmode], 1
        je short .9
.8:
        mov eax, 1
        pop esi
        pop ecx
        pop ebx
        ret
.9:
        mov edx, 1Eh
        mov eax, ebx
        call AddPenalty2
        jmp short CheckBump.8
.10:
        xor eax, eax
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; GetLowestPen                                        54A53  94G penalty94.asm
; Same algorithm as 94G penalty94 GetLowestPen (IDA CalcPenTime): shorthanded
; team from tmap, walks its box list (+0B6h) summing the non-coincidental
; tmpdst (+7Eh, &3FFFh) time steps, then compares with the power-play team's
; list; returns the power-play time left
;-----------------------------------------------------------------------------
; C: src/engine/collide/checkob.c (GetLowestPen)
%ifdef CBUILD
%include "c/engine/collide/checkob.GetLowestPen.inc"
%else
GetLowestPen:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ax, word [hmtmap]
        sub ax, word [awtmap]
        test ax, ax
        jle short .1
        mov esi, hmtmstruct
        mov edi, awtmstruct
        jmp short .3
.1:
        jl short .2
        xor eax, eax
        jmp near checkob_ret5
.2:
        mov esi, awtmstruct
        mov edi, hmtmstruct
.3:
        xor ecx, ecx
        xor ebx, ebx
        lea edx, [dword edi+0B6h]
.4:
        movsx ax, byte [edx]
        inc edx
        test ax, ax
        jl short .5
        cwde
        mov ax, word [byte edi+eax*2+07Eh]
        test ax, ax
        jl short GetLowestPen.4
        and ah, 3Fh
        sub eax, ecx
        add ebx, eax
        mov ecx, eax
        jmp short GetLowestPen.4
.5:
        cmp word [byte esi+tmap], byte 6
        jne short .7
.6:
        mov eax, ebx
        jmp near checkob_ret5
.7:
        sub ebx, ecx
        lea edx, [dword esi+0B6h]
.8:
        movsx ax, byte [edx]
        inc edx
        test ax, ax
        jl short GetLowestPen.6
        cwde
        mov ax, word [byte esi+eax*2+07Eh]
        test ax, ax
        jl short GetLowestPen.8
        and ah, 3Fh
        cmp bx, ax
        jl short GetLowestPen.6
        mov eax, ebx
        add eax, ecx
        jmp near checkob_ret5
%endif ; C
;-----------------------------------------------------------------------------
; chk4lc                                              54AF9  93G logic93_3.asm
; (see if computer should call line change). Puck in own half below the blue line,
; 1 in 4, not pflags2 bit 3; PC adds clock penalty checks (GetLowestPen). Then CompLine, setpersonel and
; chk4lc_shoot: CompShoot dumps the puck. Returns 1 when it did.
;-----------------------------------------------------------------------------
; C: src/engine/collide/checkob.c (chk4lc)
%ifdef CBUILD
%include "c/engine/collide/checkob.chk4lc.inc"
%else
chk4lc:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ecx, eax
        test byte [gameopts], 4
        je near .3
        cmp dword [penshotlive], byte 0
        jne near .3
        mov ebx, dword [pucky]
        mov ax, word [ebx]
        mov word [regd0], ax
        test byte [byte ecx+pflags], 80h
        jne short .1
        mov edx, eax
        neg edx
        mov word [regd0], dx
.1:
        mov bx, word [regd0]
        test bx, bx
        jl short .3
        cmp bx, byte 4Eh
        jg short .3
        mov eax, 4
        call randomd0
        test ax, ax
        jne short .3
        test byte [byte ecx+pflags2], 8
        jne short .3
        mov ebx, dword [byte ecx+tmptr]
        mov esi, dword [byte ecx+optmptr]
        mov dx, word [byte ebx+tmap]
        sub dx, word [byte esi+tmap]
        test byte [dword ebx+0D4h], 40h
        je short .4
        cmp word [gameclock], byte 0Fh
        jl short .3
.2:
        test dx, dx
        je short .8
        call GetLowestPen
        cmp ax, 0Fh
        jge short .8
.3:
        xor eax, eax
        jmp near checkob_ret5
.4:
        mov eax, ebx
        call AvgCline
        mov ax, word [gameclock]
        cmp ax, 0Fh
        jl short chk4lc.3
        cmp ax, 1Eh
        jge short .5
        cmp word [regd0], 800h
        ja short chk4lc.3
.5:
        test dx, dx
        je short .6
        mov eax, 0F33h
        jmp short .7
.6:
        mov eax, dword [dword ebx+0D6h]
.7:
        xor edi, edi
        mov di, word [regd0]
        cmp edi, eax
        ja short chk4lc.3
        jmp short chk4lc.2
.8:
        mov edx, ebx
        mov eax, esi
        call CompLine
        mov eax, ebx
        call setpersonel
chk4lc_shoot:
        mov eax, ecx
        call CompShoot
        mov eax, 1
        jmp near checkob_ret5
%endif ; C
;-----------------------------------------------------------------------------
; PassLaneChk                                     54C09  95 PC, low confidence
; Pass target check for passer eax / receiver edx: 0 when the passer is the
; goalie, when ShotLaneOpen says no, or when the receiver is on the wrong
; side of the blue line (4Eh by pfgoal); then a vtoa lane test; used by
; chk4pass and dopass
;-----------------------------------------------------------------------------
PassLaneChk:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov ecx, eax
        mov ebx, edx
        test byte [byte eax+044h], 80h
        setne al
        movzx edi, al
        mov edx, edi
        cmp word [byte ecx+position], byte 0
        jne short .2
.1:
        xor eax, eax
        jmp near PassLaneChk_ret5a
.2:
        call ShotLaneOpen
        test eax, eax
        jne short PassLaneChk.1
        mov esi, dword [byte ebx+Ypos]
        sar esi, 10h
        mov eax, dword [byte ecx+Ypos]
        sar eax, 10h
        test edi, edi
        je short .3
        mov edi, 4Eh
        jmp short .4
.3:
        mov edi, 0FFFFFFB2h
.4:
        cmp eax, edi
        setg byte [esp]
        movzx edi, byte [esp]
        xor edi, edx
        jne short PassLaneChk.1
        test eax, eax
        jge short .5
        mov edi, eax
        neg edi
        jmp short .6
.5:
        mov edi, eax
.6:
        test esi, esi
        jge short .7
        mov ebp, esi
        neg ebp
        jmp short .8
.7:
        mov ebp, esi
.8:
        cmp edi, ebp
        jle short PassLaneChk.1
        test eax, eax
        jge short .9
        mov edi, eax
        neg edi
        jmp short .10
.9:
        mov edi, eax
.10:
        cmp edi, byte 76h
        jg short PassLaneChk.1
        test edx, edx
        je short .11
        cmp word [byte ebx+Yvel], byte 0
        jl short PassLaneChk.1
        cmp word [byte ecx+Yvel], byte 0
        jl short PassLaneChk.1
.11:
        test edx, edx
        jne short .12
        cmp word [byte ebx+Yvel], byte 0
        jg near PassLaneChk.1
        cmp word [byte ecx+Yvel], byte 0
        jg near PassLaneChk.1
.12:
        mov edx, dword [byte ebx+0Ch]
        sar edx, 18h
        add edx, esi
        lea edi, [byte eax-04Eh]
        sub edx, byte 4Eh
        xor edx, edi
        test edx, edx
        jl near PassLaneChk.1
        sub esi, eax
        test esi, esi
        jge short .13
        neg esi
.13:
        cmp esi, byte 3Ch
        jg near PassLaneChk.1
        mov eax, dword [ecx]
        sar eax, 10h
        mov esi, dword [ebx]
        sar esi, 10h
        sub eax, esi
        mov esi, eax
        test eax, eax
        jge short .14
        neg esi
.14:
        cmp esi, byte 28h
        jg near PassLaneChk.1
        mov edx, dword [byte ebx+Yvel-2]
        sar edx, 10h
        mov eax, dword [byte ebx+Xvel-2]
        sar eax, 10h
        call vtoa
        movsx esi, ax
        cmp esi, byte 8
        jne short .15
        mov esi, dword [byte ebx+facedir-2]
        sar esi, 10h
.15:
        mov ax, word [byte ecx+Ypos+2]
        sub ax, word [byte ebx+Ypos+2]
        movsx edx, ax
        mov ax, word [byte ecx+Xpos+2]
        sub ax, word [byte ebx+Xpos+2]
        cwde
        call vtoa
        cwde
        sub esi, eax
        lea eax, [byte esi+01h]
        and eax, byte 7
        cmp eax, byte 3
        jge near PassLaneChk.1
        mov eax, 1
PassLaneChk_ret5a:
        add esp, byte 4
PassLaneChk_ret5:
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; ScatterPass                                     54D63  95 PC, low confidence
; (player, receiver): counts a pass attempt (team +26h, hmpassatt) unless
; replay, sets passplayer, receiver gets asstab 13h (asspassrec), puck gets
; random vx/vy scaled by (12h - passing skill +5Dh)*14h
;-----------------------------------------------------------------------------
; C: src/engine/collide/ScatterPass.c
%ifdef CBUILD
%include "c/engine/collide/ScatterPass.inc"
%else
ScatterPass:
        push dword 0Ch
        call __CHK
        push ebx
        push esi
        mov ebx, eax
        mov eax, edx
        mov word [byte ebx+03Eh], 28h
        test byte [gmode], 10h
        jne short .1
        mov edx, dword [byte ebx+06Ch]
        inc word [byte edx+026h]
.1:
        mov dx, word [byte eax+06Ah]
        mov word [passplayer], dx
        mov byte [byte ebx+053h], 0
        mov edx, 13h
        call assinsert
        mov eax, dword [puckvz]
        mov word [eax], 0
        xor eax, eax
        mov al, byte [byte ebx+05Dh]
        mov edx, 12h
        sub edx, eax
        imul eax, edx, byte 14h
        cwde
        call randomd0
        mov edx, dword [puckvx]
        mov word [edx], ax
        xor eax, eax
        mov al, byte [byte ebx+05Dh]
        mov edx, 12h
        sub edx, eax
        imul eax, edx, byte 14h
        cwde
        call randomd0
        mov edx, dword [puckvy]
        mov word [edx], ax
        xor esi, esi
        mov word [pucknopuck], si
        pop esi
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; dopass                             54DF4  94G logic94.asm, medium confidence
;-----------------------------------------------------------------------------
dopass:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 0Ch
        mov ecx, eax
        xor edx, edx
        mov dword [onetimerflag], edx
        and byte [sflags], 0FBh
        mov eax, dword [puckc]
        mov byte [eax], 0FFh
        mov word [byte ecx+03Eh], 10h
        mov ax, word [byte ecx+SCnum]
        mov word [lastplayer], ax
        test byte [byte ecx+pflags], 8
        jne short .2
        cmp byte [byte ecx+053h], 0
        je short .2
        mov eax, dword [byte ecx+046h]
        sar eax, 10h
        shl eax, 7
        mov edx, SortCords
        add edx, eax
.1:
        mov eax, ecx
        call ScatterPass
        jmp near .23
.2:
        cmp word [byte ecx+position], byte 0
        jne short .3
        mov word [byte esp+08h], 8
        jmp short .4
.3:
        xor eax, eax
        mov al, byte [byte ecx+05Dh]
        mov word [byte esp+08h], ax
.4:
        mov eax, dword [byte esp+08h]
        shl eax, 2
        add eax, 0A0h
        mov word [passspeed], ax
        cmp word [byte ecx+SCnum], byte 6
        jge short .5
        xor eax, eax
        jmp short .6
.5:
        mov eax, 6
.6:
        shl eax, 7
        mov ebx, SortCords
        add ebx, eax
        mov dword [byte esp+04h], 0FFFFFFFFh
        xor ebp, ebp
        mov word [byte esp+08h], 6
.7:
        cmp ecx, ebx
        je near .11
        cmp word [byte ebx+position], byte 0
        jle near .11
        test byte [byte ebx+pflags2], 4
        jne short .11
        mov edi, dword [puckx]
        mov si, word [byte ebx+Xpos+2]
        sub si, word [edi]
        movsx edi, si
        mov eax, dword [pucky]
        mov si, word [byte ebx+Ypos+2]
        sub si, word [eax]
        movsx esi, si
        mov edx, esi
        mov eax, edi
        call vtoa
        sub ax, word [passdir]
        xor ah, ah
        and al, 7
        cmp ax, 1
        jle short .8
        cmp ax, 7
        jne short .11
.8:
        imul edi, edi
        imul esi, esi
        add esi, edi
        test ax, ax
        jne short .9
        xor eax, eax
        jmp short .10
.9:
        mov eax, 10000h
.10:
        add esi, eax
        mov dword [esp], esi
        cmp esi, dword [byte esp+04h]
        ja short .11
        mov dword [byte esp+04h], esi
        mov ebp, ebx
.11:
        add ebx, 80h
        mov esi, dword [byte esp+08h]
        dec si
        mov word [byte esp+08h], si
        jne near dopass.7
        test ebp, ebp
        je short .13
        test byte [byte ecx+pflags], 8
        je short .12
        mov edx, ebp
        mov eax, ecx
        call PassLaneChk
        test eax, eax
        je short .12
        mov edx, ebp
        jmp near dopass.1
.12:
        mov eax, ebp
        call passtoa0
        jmp near .14
.13:
        mov edi, dword [passspeed-2]
        sar edi, 10h
        mov esi, dword [passdir-2]
        sar esi, 10h
        mov esi, dword [nosplit esi*4+dirtab]
        sar esi, 10h
        imul esi, edi
        shl esi, 0Ah
        mov dword [esp], esi
        mov ebx, 0BB8h
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ebx
        mov dword [esp], eax
        mov edx, dword [esp]
        add dx, word [byte ecx+Yvel]
        mov eax, dword [puckvy]
        mov word [eax], dx
        mov esi, dword [passdir-2]
        sar esi, 10h
        mov esi, dword [nosplit esi*4+clockticks]
        sar esi, 10h
        imul esi, edi
        shl esi, 0Ah
        mov dword [esp], esi
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ebx
        mov dword [esp], eax
        mov edx, dword [esp]
        add dx, word [byte ecx+Xvel]
        mov eax, dword [puckvx]
        mov word [eax], dx
        mov eax, 1000h
        call randomd0
        mov edx, eax
        mov eax, dword [puckvz]
        mov word [eax], dx
.14:
        cmp word [byte ecx+position], byte 0
        jne near .20
        test byte [byte ecx+pflags], 80h
        sete al
        mov edx, eax
        and edx, 0FFh
        mov eax, dword [puckvy]
        cmp word [eax], byte 0
        setl al
        and eax, 0FFh
        xor eax, edx
        je short .15
        mov eax, dword [puckvy]
        mov dx, word [eax]
        neg edx
        mov word [eax], dx
.15:
        mov word [byte esp+08h], 1B9h
        or byte [byte ecx+pflags2], 2
        test byte [byte ecx+pflags], 8
        je near .22
        test ebp, ebp
        je short .17
        test byte [byte ebp+044h], 8
        jne short .17
        mov ax, word [byte ecx+SCnum]
        mov dx, word [c1playernum]
        cmp ax, dx
        jne short .16
        cmp dx, word [byte ebp+06Ah]
        je near .22
        mov edx, dword [c1playernum-2]
        sar edx, 10h
        mov eax, dword [byte ebp+068h]
        sar eax, 10h
        call restorepl
        mov word [c1playernum], ax
        jmp near .22
.16:
        mov ax, word [byte ebp+06Ah]
        cmp ax, word [c2playernum]
        je near .22
        mov edx, dword [c2playernum-2]
        sar edx, 10h
        mov eax, dword [byte ebp+068h]
        sar eax, 10h
        call restorepl
        mov word [c2playernum], ax
        jmp short .22
.17:
        mov ax, word [byte ecx+SCnum]
        cmp ax, word [c1playernum]
        jne short .18
        xor eax, eax
        jmp short .19
.18:
        mov eax, 2
.19:
        movsx edx, ax
        mov eax, ecx
        call changeplayer
        jmp short .22
.20:
        mov edx, dword [puckvy]
        movsx edx, word [edx]
        mov eax, dword [puckvx]
        movsx eax, word [eax]
        call vtoa
        movsx edx, ax
        mov eax, ecx
        call Findhittype
        test ax, ax
        jne short .21
        mov word [byte esp+08h], 389h
        jmp short .22
.21:
        mov word [byte esp+08h], 3C1h
.22:
        mov edx, dword [byte esp+06h]
        sar edx, 10h
        mov eax, ecx
        call SetSPA
        or byte [byte ecx+pflags], 20h
        mov eax, dword [puckvz]
        cmp byte [byte eax+01h], 6
        setge al
        and eax, 0FFh
        add eax, 98h
        cwde
        call sfx
.23:
        add esp, byte 0Ch
dopass_ret6:
        pop ebp
        jmp near checkob_ret5
;-----------------------------------------------------------------------------
; passmode                                              5514E  94G logic94.asm
; As 93G passmode: B changed (regd2 bit 4) -> dopass, else dpad&7 -> passdir
;-----------------------------------------------------------------------------
; C: src/engine/collide/passmode.c
%ifdef CBUILD
%include "c/engine/collide/passmode.inc"
%else
passmode:
        push dword 8
        call __CHK
        push edx
        test byte [regd2], 10h
        jne short .1
        test byte [regd0], 8
        jne short .x
        mov dx, word [regd0]
        xor dh, dh
        and dl, 7
        mov word [passdir], dx
        or byte [regd0], 8
        test byte [byte eax+044h], 8
        je short .1
        mov dx, word [byte eax+06Ah]
        cmp dx, word [c1playernum]
        setne dl
        and edx, 0FFh
        cmp byte [dword edx+pad1dev], 1
        je short .x
.1:
        call dopass
.x:
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; setpassmode                        551AF  94G logic94.asm, medium confidence
;-----------------------------------------------------------------------------
; C: src/engine/collide/setpassmode.c
%ifdef CBUILD
%include "c/engine/collide/setpassmode.inc"
%else
setpassmode:
        push dword 4
        call __CHK
        mov ax, word [byte eax+036h]
        xor ah, ah
        and al, 7
        mov word [passdir], ax
        or byte [sflags], 4
        ret
%endif ; C
;-----------------------------------------------------------------------------
; passtoa0                           551CF  94G logic94.asm, medium confidence
;-----------------------------------------------------------------------------
passtoa0:
        push dword 38h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 1Ch
        mov esi, eax
        test byte [gmode], 10h
        jne short .1
        mov eax, dword [byte esi+06Ch]
        inc word [byte eax+026h]
.1:
        mov ax, word [byte esi+SCnum]
        mov word [passplayer], ax
        mov edx, 13h
        mov eax, esi
        call assinsert
        mov eax, esi
        call GetHot
        mov dx, word [regd0]
        add dx, word [byte esi+Xpos+2]
        mov eax, dword [puckx]
        mov cx, word [eax]
        sub edx, ecx
        mov word [byte esp+014h], dx
        mov ecx, dword [byte esp+012h]
        sar ecx, 12h
        mov dx, word [regd1]
        add dx, word [byte esi+Ypos+2]
        mov eax, dword [pucky]
        mov bx, word [eax]
        sub edx, ebx
        mov word [byte esp+010h], dx
        mov edi, dword [byte esp+0Eh]
        sar edi, 12h
        mov edx, dword [byte esi+Xvel-2]
        sar edx, 10h
        mov eax, edx
        shl eax, 4
        sub eax, edx
        shl eax, 4
        sar eax, 10h
        mov word [esp], ax
        mov edx, dword [byte esi+Yvel-2]
        sar edx, 10h
        mov eax, edx
        shl eax, 4
        sub eax, edx
        shl eax, 4
        sar eax, 10h
        mov word [byte esp+0Ch], ax
        mov eax, dword [esp]
        imul eax, ecx
        mov edx, dword [byte esp+0Ch]
        imul edx, edi
        add eax, edx
        add eax, eax
        mov word [byte esp+08h], ax
        mov eax, dword [passdir]
        sar eax, 12h
        mov ebx, eax
        mov edx, dword [byte esp-02h]
        sar edx, 10h
        imul edx, edx
        mov eax, dword [byte esp+0Ah]
        sar eax, 10h
        imul eax, eax
        add edx, eax
        movsx eax, bx
        imul eax, eax
        sub edx, eax
        mov word [byte esp+018h], dx
        movsx edx, cx
        imul edx, edx
        movsx ecx, di
        imul ecx, ecx
        add ecx, edx
        mov edx, dword [byte esp+016h]
        sar edx, 10h
        imul ecx, edx
        shl ecx, 2
        mov eax, dword [byte esp+06h]
        sar eax, 10h
        imul eax, eax
        sub eax, ecx
        mov ecx, eax
        test eax, eax
        jle short .2
        push eax
        call sub_93470
        add esp, byte 4
        mov ecx, eax
        jmp short .3
.2:
        xor ecx, eax
.3:
        mov edi, dword [byte esp+018h]
        sar di, 2
        mov word [byte esp+018h], di
        test di, di
        jne short .4
        mov word [byte esp+018h], 1
.4:
        xor ebx, ebx
        jmp short .6
.5:
        mov word [byte esp+04h], cx
        neg ecx
        mov eax, dword [byte esp+02h]
        sar eax, 10h
        mov edx, dword [byte esp+06h]
        sar edx, 10h
        sub eax, edx
        mov edx, eax
        mov edi, dword [byte esp+016h]
        sar edi, 10h
        sar edx, 1Fh
        idiv edi
        mov word [byte esp+04h], ax
        test ax, ax
        jge short .7
        inc ebx
.6:
        cmp bx, byte 2
        jl short passtoa0.5
.7:
        cmp word [byte esp+04h], byte 0
        jg short .8
        mov word [byte esp+04h], 1
.8:
        cmp word [byte esp+04h], byte 18h
        jle short .9
        mov word [byte esp+04h], 18h
.9:
        cmp word [byte esp+04h], byte 0Ch
        jge short .10
        mov eax, dword [byte esp+02h]
        sar eax, 10h
        jmp short .11
.10:
        mov eax, 0Ch
.11:
        movsx bx, al
        cmp bx, byte 6
        jle short .12
        movsx edi, bx
        lea edx, [byte edi+01h]
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov ecx, eax
        mov eax, edi
        mov edx, edi
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        cwde
        call randomd0
        cwde
        add eax, ecx
        mov ebx, eax
.12:
        mov eax, dword [puckvz]
        mov byte [byte eax+01h], bl
        mov al, byte [byte esp+04h]
        shl al, 3
        sub al, 0Ah
        mov byte [byte esi+027h], al
        mov eax, dword [byte esi+024h]
        sar eax, 18h
        sub eax, byte 6
        mov word [pucknopuck], ax
        mov edx, dword [byte esp+02h]
        sar edx, 10h
        mov ecx, dword [byte esp-02h]
        sar ecx, 10h
        imul ecx, edx
        sar ecx, 1
        mov eax, dword [byte esp+012h]
        sar eax, 10h
        add ecx, eax
        mov dword [regd0], ecx
        mov eax, dword [puckx]
        mov ax, word [eax]
        mov bx, word [regd0]
        add eax, ebx
        mov word [byte esi+temp3], ax
        mov eax, dword [byte esp+0Ah]
        sar eax, 10h
        imul edx, eax
        sar edx, 1
        mov eax, dword [byte esp+0Eh]
        sar eax, 10h
        add edx, eax
        mov dword [regd1], edx
        mov eax, dword [pucky]
        mov ax, word [eax]
        mov cx, word [regd1]
        add eax, ecx
        mov word [byte esi+temp4], ax
        mov esi, dword [byte esp+04h]
        imul eax, esi, byte 78h
        mov word [byte esp+04h], ax
        mov eax, dword [regd0]
        call ToFixed
        mov edx, eax
        mov ecx, dword [byte esp+02h]
        sar ecx, 10h
        sar edx, 1Fh
        idiv ecx
        mov esi, eax
        mov eax, dword [puckvx]
        mov word [eax], si
        mov eax, dword [regd1]
        call ToFixed
        mov edx, eax
        sar edx, 1Fh
        idiv ecx
        mov esi, eax
        mov eax, dword [puckvy]
        mov word [eax], si
        add esp, byte 1Ch
        jmp near checkob_ret5
;-----------------------------------------------------------------------------
; chk4pass                                              55493  94G logic94.asm
; (computer looks for a good pass): threat spodds roll, target by vtoa
; (PassLaneChk), dopass, assexit.
;-----------------------------------------------------------------------------
; C: src/engine/collide/checkob.c (chk4pass)
%ifdef CBUILD
%include "c/engine/collide/checkob.chk4pass.inc"
%else
chk4pass:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ebx, eax
        mov byte [byte eax+053h], 0
        mov dx, word [threat]
        test dx, dx
        jne short .1
        xor ah, ah
        mov al, byte [byte ebx+05Fh]
        add eax, 10h
        cwde
        call randomd0
        cmp ax, 9
        jg near .29
.1:
        mov eax, 6
        call randomd0
        mov word [regd0], ax
        cmp word [byte ebx+SCnum], byte 6
        jl short .2
        add eax, 6
        mov word [regd0], ax
.2:
        mov ax, word [regd0]
        cmp ax, word [byte ebx+SCnum]
        jne short .4
.3:
        xor edx, edx
        jmp near .29
.4:
        mov ecx, dword [regd0-2]
        sar ecx, 10h
        shl ecx, 7
        add ecx, SortCords
        cmp word [byte ecx+position], byte 0
        jle short chk4pass.3
        test byte [byte ecx+pflags2], 4
        jne short chk4pass.3
        test byte [byte ecx+pflags], 20h
        jne short chk4pass.3
        cmp word [byte ebx+position], byte 0
        je near .17
        test byte [byte ebx+pflags], 80h
        setne al
        mov edx, eax
        and edx, 0FFh
        mov eax, dword [pucky]
        cmp word [eax], byte 0
        setg al
        and eax, 0FFh
        xor eax, edx
        je near .17
        mov edx, dword [puckx]
        mov di, word [edx]
        test di, di
        jge short .5
        movsx eax, di
        neg eax
        jmp short .6
.5:
        movsx eax, di
.6:
        cmp eax, byte 32h
        jg near .17
        mov edx, dword [pucky]
        mov ax, word [edx]
        test ax, ax
        jge short .7
        cwde
        neg eax
        jmp short .8
.7:
        cwde
.8:
        cmp eax, 0ACh
        jle near .17
        mov edx, dword [pucky]
        mov si, word [edx]
        test si, si
        jge short .9
        movsx eax, si
        neg eax
        jmp short .10
.9:
        movsx eax, si
.10:
        cmp eax, 0EBh
        jl near chk4pass.3
        mov ax, word [byte ecx+Xpos+2]
        mov word [regd0], ax
        mov ax, word [byte ecx+Ypos+2]
        mov word [regd1], ax
        cmp word [regd0], byte 0
        jge short .11
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .12
.11:
        mov eax, dword [regd0-2]
        sar eax, 10h
.12:
        cmp eax, byte 3Ch
        jl near chk4pass.3
        mov eax, dword [puckx]
        movsx edx, word [eax]
        mov eax, dword [regd0-2]
        sar eax, 10h
        xor eax, edx
        test eax, eax
        jge short .17
        mov edx, dword [pucky]
        mov ax, word [edx]
        test ax, ax
        jge short .13
        cwde
        neg eax
        jmp short .14
.13:
        cwde
.14:
        lea edx, [dword eax-0E8h]
        cmp word [regd1], byte 0
        jge short .15
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .16
.15:
        mov eax, dword [regd1-2]
        sar eax, 10h
.16:
        sub eax, 0E8h
        xor eax, edx
        test eax, eax
        jl near chk4pass.3
.17:
        mov ax, word [byte ecx+Ypos+2]
        mov word [regd0], ax
        mov ax, word [byte ebx+Ypos+2]
        mov word [regd1], ax
        test byte [byte ebx+pflags], 80h
        jne short .18
        neg word [regd0]
        neg word [regd1]
.18:
        test byte [gameopts], 2
        je short .19
        mov edx, dword [regd0-2]
        sar edx, 10h
        mov eax, dword [regd1-2]
        sar eax, 10h
        sub eax, byte 4Eh
        sub edx, byte 4Eh
        xor eax, edx
        test eax, eax
        jge short .19
        mov edx, ecx
        mov eax, ebx
        call PassLaneChk
        mov byte [byte ebx+053h], al
        test al, al
        je near chk4pass.3
        jmp short .20
.19:
        mov dx, word [regd0]
        cmp dx, byte 4Eh
        jg short .21
        mov ax, word [regd1]
        mov esi, edx
        sub esi, eax
        mov word [regd0], si
        mov eax, dword [regd0-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFF1h
        jge short .21
        mov edx, ecx
        mov eax, ebx
        call PassLaneChk
        mov byte [byte ebx+053h], al
        test al, al
        je near chk4pass.3
.20:
        mov ax, word [byte ecx+SCnum]
        mov word [byte ebx+048h], ax
.21:
        test byte [gameopts], 8
        je short .22
        test byte [byte ecx+pflags2], 80h
        je short .22
        mov eax, dword [regd1-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFB2h
        jge short .22
        cmp word [regd0], byte 0
        jg near chk4pass.3
.22:
        mov al, byte [byte ecx+052h]
        xor al, 4
        cbw
        mov word [passdir], ax
        mov eax, dword [byte ecx+04Ch]
        sar eax, 10h
        mov dword [regd2], eax
        cmp word [byte ebx+SCnum], byte 6
        jge short .23
        mov eax, 6
        jmp short .24
.23:
        xor eax, eax
.24:
        shl eax, 7
        mov edx, SortCords
        add edx, eax
        mov word [regd3], 6
.25:
        mov ecx, dword [byte edx+04Ch]
        sar ecx, 10h
        cmp ecx, dword [regd2]
        jg short .28
        mov al, byte [byte edx+052h]
        xor al, 4
        cbw
        mov si, word [passdir]
        sub esi, eax
        mov eax, esi
        inc eax
        xor ah, ah
        and al, 7
        cmp ax, 1
        je near chk4pass.3
        cmp word [byte ebx+position], byte 0
        jne short .28
        cmp ecx, byte 1Eh
        jl near chk4pass.3
        cmp ax, 2
        jg short .26
        cmp ecx, byte 3Ch
        jl near chk4pass.3
.26:
        cmp ax, 3
        je short .27
        cmp ax, 7
        jne short .28
.27:
        cmp ecx, byte 28h
        jl near chk4pass.3
.28:
        add edx, 80h
        mov di, word [regd3]
        dec di
        mov word [regd3], di
        jne short chk4pass.25
        mov eax, ebx
        call dopass
        mov dx, word [byte ebx+position]
        test dx, dx
        je short .29
        mov eax, ebx
        call assexit
        mov edx, 1
.29:
        mov eax, edx
        jmp near checkob_ret5
%endif ; C
;-----------------------------------------------------------------------------
; chk4shot                                              55804  94G logic94.asm
; (computer looks for a shot). regd4 = 20h - spodds; shot lane test; jumps to
; chk4lc_shoot (CompShoot) to shoot.
;-----------------------------------------------------------------------------
; C: src/engine/collide/checkob.c (chk4shot)
%ifdef CBUILD
%include "c/engine/collide/checkob.chk4shot.inc"
%else
chk4shot:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ecx, eax
        mov edx, dword [penshotlive]
        test edx, edx
        jne short .2
        test byte [gmode2], 20h
        je short .1
        mov dl, byte [byte ecx+pflags]
        and dl, 40h
        mov ax, word [gmode2]
        xor ah, ah
        and al, 40h
        cwde
        xor eax, edx
        je short .1
        cmp word [threat], byte 0
        je short .1
        mov eax, 4
        call randomd0
        test ax, ax
        je near chk4lc_shoot
.1:
        cmp word [gameclock], byte 4
        jge short .2
        mov edx, dword [byte ecx+tmptr]
        mov eax, dword [byte ecx+optmptr]
        mov dx, word [byte edx+tmscore]
        cmp dx, word [byte eax+tmscore]
        jl near chk4lc_shoot
.2:
        xor ah, ah
        mov al, byte [byte ecx+05Fh]
        mov edx, 20h
        sub edx, eax
        mov word [regd4], dx
        test byte [byte ecx+pflags], 80h
        jne short .3
        mov eax, 0FFFFFF18h
        jmp short .4
.3:
        mov eax, 0E8h
.4:
        mov word [regd1], ax
        mov eax, dword [pucky]
        mov ax, word [eax]
        sub word [regd1], ax
        mov eax, dword [puckx]
        mov ax, word [eax]
        neg eax
        mov word [regd0], ax
        mov eax, dword [regd0-2]
        sar eax, 10h
        mov esi, eax
        imul esi, eax
        mov edx, dword [regd1-2]
        sar edx, 10h
        mov ebx, edx
        imul ebx, edx
        add ebx, esi
        cmp ebx, 2710h
        ja near .12
        mov ebx, dword [byte ecx+optmptr]
        cmp word [byte ebx+tmgoalie], byte 0
        jge short .6
.5:
        mov word [regd4], 1
        jmp near .13
.6:
        call vtoa
        mov word [regd5], ax
        cmp word [byte ecx+SCnum], byte 6
        jge short .7
        mov eax, 6
        jmp short .8
.7:
        xor eax, eax
.8:
        shl eax, 7
        mov ebx, SortCords
        add ebx, eax
        mov word [regd3], 6
.9:
        cmp word [byte ebx+position], byte 0
        jne short .10
        test byte [byte ebx+pflags2], 2
        je short .11
        jmp short chk4shot.5
.10:
        mov edx, dword [puckx]
        mov ax, word [byte ebx+Xpos+2]
        mov di, word [edx]
        sub eax, edi
        mov word [regd0], ax
        mov edx, dword [pucky]
        mov ax, word [byte ebx+Ypos+2]
        mov si, word [edx]
        sub eax, esi
        mov word [regd1], ax
        mov edx, dword [regd1-2]
        sar edx, 10h
        mov eax, dword [regd0-2]
        sar eax, 10h
        call vtoa
        cmp ax, word [regd5]
        jne short .11
        mov dx, word [regd4]
        add edx, edx
        mov word [regd4], dx
.11:
        add ebx, 80h
        mov ax, word [regd3]
        dec ax
        mov word [regd3], ax
        jne short chk4shot.9
        jmp short .13
.12:
        shl word [regd4], 4
.13:
        mov eax, dword [regd4-2]
        sar eax, 10h
        call randomd0
        cmp ax, 8
        jle short .15
.14:
        xor eax, eax
        jmp near checkob_ret5
.15:
        mov eax, dword [pucky]
        mov ax, word [eax]
        mov word [regd0], ax
        test byte [byte ecx+pflags], 80h
        jne short .16
        mov esi, eax
        neg esi
        mov word [regd0], si
.16:
        mov di, word [regd0]
        test di, di
        jl short chk4shot.14
        mov edx, 0E8h
        sub edx, edi
        mov word [regd1], dx
        test dx, dx
        jl short chk4shot.14
        cmp dword [penshotlive], byte 0
        je short .17
        mov eax, dword [regd0-2]
        sar eax, 10h
        cmp eax, byte 74h
        jl short chk4shot.14
.17:
        test byte [gmode2], 80h
        jne short chk4shot.14
        jmp near chk4lc_shoot
%endif ; C
;-----------------------------------------------------------------------------
; CompShoot                                           55A35  93G logic93_3.asm
; temp2 = swing time (E8h - pucky by pfgoal) 8, max 14h; assreplace ashoot (12h).
;-----------------------------------------------------------------------------
; C: src/engine/collide/CompShoot.c
%ifdef CBUILD
%include "c/engine/collide/CompShoot.inc"
%else
CompShoot:
        push dword 8
        call __CHK
        push edx
        mov edx, dword [pucky]
        mov dx, word [edx]
        mov word [regd0], dx
        test byte [byte eax+044h], 80h
        jne short .1
        neg word [regd0]
.1:
        mov edx, 0E8h
        sub dx, word [regd0]
        and edx, 0FFFFh
        sar edx, 3
        mov word [regd1], dx
        cmp dx, byte 14h
        jge short .2
        mov edx, dword [regd1-2]
        sar edx, 10h
        jmp short .3
.2:
        mov edx, 14h
.3:
        mov word [byte eax+028h], dx
        mov edx, 12h
        call assreplace
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ChkOffsides                      55A9F  93G logic93_5.asm, medium confidence
; ClearOffsidesIfAllPlayers. Offsides option (gameopts bit 1): a team's
; offsides flag (tmflags bit 4) is cleared once none of its skaters is past the blue line (4Eh).
;-----------------------------------------------------------------------------
; C: src/engine/collide/checkob.c (ChkOffsides)
%ifdef CBUILD
%include "c/engine/collide/checkob.ChkOffsides.inc"
%else
ChkOffsides:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov edi, eax
        test byte [gameopts], 2
        je near checkob_ret5
        cmp dword [penshotlive], byte 0
        jne near checkob_ret5
        cmp dword [penshotstart], byte 0
        jne near checkob_ret5
        xor esi, esi
        mov ecx, hmtmstruct
        jmp short .8
.1:
        test byte [byte ecx+044h], 10h
        je short .7
        mov eax, dword [dword ecx+tmsort]
        xor edx, edx
        jmp short .5
.2:
        cmp word [byte eax+position], byte 0
        jl short .4
        mov bx, word [byte eax+Ypos+2]
        mov word [regd0], bx
        test byte [byte eax+pflags], 80h
        jne short .3
        neg word [regd0]
.3:
        cmp word [regd0], byte 4Eh
        jg short .6
.4:
        add eax, 80h
        inc edx
.5:
        cmp dx, byte 6
        jl short ChkOffsides.2
.6:
        cmp dx, byte 6
        jl short .7
        and byte [byte ecx+044h], 0EFh
.7:
        mov ecx, awtmstruct
        inc esi
.8:
        cmp si, byte 2
        jl short ChkOffsides.1
        mov edx, 4Ah
        mov word [regd0], dx
        cmp dx, word [byte edi+06h]
        jg near .15
        cmp dx, word [byte edi+07Ah]
        jle near checkob_ret5
        call CountShotOnGoal
        add word [regd0], byte 0Ah
        test byte [gmode], 2
        je short .9
        mov eax, awtmstruct
        jmp short .10
.9:
        mov eax, hmtmstruct
.10:
        mov ecx, eax
        mov eax, dword [dword eax+tmsort]
        cmp word [byte eax+SCnum], byte 6
        setl dl
        movzx edi, dl
        mov ebx, edi
        cmp word [lasttouch], byte 6
        setl dl
        movzx edi, dl
        xor edi, ebx
        je short .12
.11:
        and byte [byte ecx+044h], 0EFh
        jmp near checkob_ret5
.12:
        mov esi, 6
.13:
        cmp word [byte eax+position], byte 0
        jl short .14
        mov dx, word [regd0]
        cmp dx, word [byte eax+Ypos+2]
        jge short .14
        or byte [byte ecx+044h], 10h
.14:
        add eax, 80h
        dec si
        jne short ChkOffsides.13
        jmp near checkob_ret5
.15:
        mov ecx, 0FFFFFFB6h
        mov word [regd0], cx
        cmp cx, word [byte edi+06h]
        jl near checkob_ret5
        cmp cx, word [byte edi+07Ah]
        jge near checkob_ret5
        call CountShotOnGoal
        sub word [regd0], byte 0Ah
        test byte [gmode], 2
        jne short .16
        mov eax, awtmstruct
        jmp short .17
.16:
        mov eax, hmtmstruct
.17:
        mov ecx, eax
        mov eax, dword [dword eax+tmsort]
        cmp word [byte eax+SCnum], byte 6
        setl dl
        xor ebx, ebx
        mov bl, dl
        cmp word [lasttouch], byte 6
        setl dl
        movzx edi, dl
        xor edi, ebx
        jne near ChkOffsides.11
        mov esi, 6
.18:
        cmp word [byte eax+position], byte 0
        jl short .19
        mov dx, word [regd0]
        cmp dx, word [byte eax+Ypos+2]
        jle short .19
        or byte [byte ecx+044h], 10h
.19:
        add eax, 80h
        dec si
        jne short ChkOffsides.18
        jmp near checkob_ret5
%endif ; C
;-----------------------------------------------------------------------------
; MarkTwoLinePlayers                           55C6F  95 PC, medium confidence
; Two-line pass option (gameopts bit 3): sets pflags2 bit 7 on the skaters of
; the team past the red line (Ypos sign by gmode bit 1), clears it on the
; others; ChkTwoLinePass (from a2touchpuck) reads the flag
;-----------------------------------------------------------------------------
; C: src/engine/collide/MarkTwoLinePlayers.c
%ifdef CBUILD
%include "c/engine/collide/MarkTwoLinePlayers.inc"
%else
MarkTwoLinePlayers:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        mov ebx, eax
        test byte [gameopts], 8
        je near .x
        test byte [gmode], 2
        je short .1
        mov edx, SortCords+300h
        mov eax, SortCords
        jmp short .2
.1:
        mov edx, SortCords
        mov eax, SortCords+300h
.2:
        cmp word [byte ebx+06h], byte 0
        jl short .6
        cmp word [byte ebx+07Ah], byte 0
        jge near .x
        mov ebx, 6
.3:
        cmp word [byte edx+position], byte 0
        jl short .4
        cmp word [byte edx+Ypos+2], byte 0
        jle short .4
        or byte [byte edx+pflags2], 80h
        jmp short .5
.4:
        and byte [byte edx+pflags2], 7Fh
.5:
        and byte [byte eax+pflags2], 7Fh
        add edx, 80h
        add eax, 80h
        dec bx
        jne short MarkTwoLinePlayers.3
        pop edx
        pop ebx
        ret
.6:
        cmp word [byte ebx+07Ah], byte 0
        jl short .x
        mov ebx, 6
.7:
        cmp word [byte eax+position], byte 0
        jl short .8
        cmp word [byte eax+Ypos+2], byte 0
        jge short .8
        or byte [byte eax+pflags2], 80h
        jmp short .9
.8:
        and byte [byte eax+pflags2], 7Fh
.9:
        and byte [byte edx+pflags2], 7Fh
        add edx, 80h
        add eax, 80h
        dec bx
        jne short MarkTwoLinePlayers.7
.x:
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ChkShotStat                                       55D28  93G penalty93_2.asm
; If the shot flag (gmode2 bit 4) was set: clear it, crowdlevel +100,
; shot counts for the shooter and the goalie.
;-----------------------------------------------------------------------------
; C: src/engine/collide/checkob.c (ChkShotStat)
%ifdef CBUILD
%include "c/engine/collide/checkob.ChkShotStat.inc"
%else
ChkShotStat:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ah, byte [gmode2]
        test ah, 10h
        je near checkob_ret5
        mov dl, ah
        and dl, 0EFh
        mov byte [gmode2], dl
        test byte [gmode], 1
        jne near checkob_ret5
        mov eax, dword [shotplayer-2]
        sar eax, 10h
        shl eax, 7
        add eax, SortCords
        test byte [byte eax+pflags], 80h
        setne dl
        mov ebx, edx
        and ebx, 0FFh
        mov edx, dword [pucky]
        cmp word [edx], byte 0
        setg dl
        and edx, 0FFh
        xor edx, ebx
        jne near checkob_ret5
        mov si, word [crowdlevel]
        cmp si, 3E8h
        jg short .1
        mov edi, esi
        add edi, byte 64h
        mov word [crowdlevel], di
        cmp di, 3E8h
        jle short .1
        mov word [crowdlevel], 3E8h
.1:
        add word [CwdExciteLvl], byte 0Ah
        test byte [gmode], 10h
        jne near checkob_ret5
        mov edx, dword [byte eax+tmptr]
        mov ebx, dword [byte eax+optmptr]
        inc word [edx]
        test byte [gmode2], 20h
        je short .2
        mov cx, word [byte edx+tmap]
        cmp cx, word [byte ebx+tmap]
        jle short .2
        inc word [byte edx+06h]
.2:
        test byte [byte eax+pflags], 40h
        jne short .3
        inc byte [hmshotcnt]
        jmp short .4
.3:
        inc byte [awshotcnt]
.4:
        cmp byte [byte eax+pnum], 19h
        jge short .5
        mov ecx, dword [byte eax+044h]
        sar ecx, 18h
        shl ecx, 4
        mov eax, dword [dword edx+0E6h]
        inc word [byte ecx+eax+0Eh]
.5:
        cmp word [byte ebx+038h], byte 0
        jl near checkob_ret5
        mov eax, dword [dword ebx+tmlines]
        mov edx, dword [byte ebx+036h]
        sar edx, 10h
        mov al, byte [byte edx+eax+024h]
        xor ah, ah
        sub eax, byte 19h
        test ax, ax
        jl near checkob_ret5
        cmp ax, 3
        jge near checkob_ret5
        movsx edx, ax
        mov eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, dword [dword ebx+0EAh]
        inc word [byte edx+eax*2+02h]
        jmp near checkob_ret5
%endif ; C
;-----------------------------------------------------------------------------
; setInjuryType                                     55E72  93G hockey93_03.asm
; Player unavailable (pflags2 bit 2), crowd up, sfx A1h, camera locked
; on him (xc1/yc1, sfslock).
;-----------------------------------------------------------------------------
; C: src/engine/collide/checkob.c (setInjuryType)
%ifdef CBUILD
%include "c/engine/collide/checkob.setInjuryType.inc"
%else
setInjuryType:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov esi, eax
        mov ah, byte [byte eax+045h]
        or ah, 4
        mov byte [byte esi+pflags2], ah
        mov dx, word [crowdlevel]
        cmp dx, 3E8h
        jg short .1
        mov ebx, edx
        add ebx, 12Ch
        mov word [crowdlevel], bx
        cmp bx, 3E8h
        jle short .1
        mov word [crowdlevel], 3E8h
.1:
        add word [CwdExciteLvl], byte 1Eh
        mov eax, 0A1h
        call sfx
        mov ax, word [byte esi+Xpos+2]
        mov word [xc1], ax
        mov ax, word [byte esi+Ypos+2]
        mov word [yc1], ax
        mov ax, word [byte esi+Xpos+2]
        cmp ax, word [camx]
        jge short .2
        add word [yc1], byte 32h
.2:
        or byte [sflags], 40h
        mov edx, dword [byte esi+tmptr]
        mov eax, dword [byte esi+044h]
        sar eax, 18h
        mov ebx, eax
        shl ebx, 2
        add ebx, eax
        mov eax, dword [dword edx+0DEh]
        mov al, byte [byte eax+ebx*4+0Fh]
        xor ah, ah
        add eax, 8
        cwde
        call randomd0
        cmp ax, 6
        setg al
        and eax, 0FFh
        mov ecx, eax
        test eax, eax
        jle short .3
        cmp word [lastimpact], byte 2Dh
        jle short .3
        mov eax, dword [byte esi+044h]
        sar eax, 18h
        mov word [byte edx+eax*2+tmpdst], 0FFFCh
        mov eax, dword [byte esi+044h]
        sar eax, 18h
        mov ebx, eax
        shl ebx, 2
        add ebx, eax
        shl ebx, 3
        sub ebx, eax
        mov eax, dword [dword edx+tmroster]
        mov byte [ebx+eax], 1
        jmp short .4
.3:
        mov eax, dword [byte esi+044h]
        sar eax, 18h
        mov word [byte edx+eax*2+07Eh], 0FFFDh
        mov eax, dword [byte esi+044h]
        sar eax, 18h
        mov ebx, eax
        shl ebx, 2
        add ebx, eax
        shl ebx, 3
        sub ebx, eax
        mov eax, dword [dword edx+tmroster]
        mov byte [ebx+eax], 6
        mov ecx, 0FFFFFFFFh
.4:
        mov word [injurystop], 1
        mov eax, dword [PerTimeTotal-2]
        sar eax, 10h
        mov ebx, dword [gameclock-2]
        sar ebx, 10h
        sub eax, ebx
        mov ebx, eax
        cmp word [gameclock], byte 3Ch
        jge short .5
        cmp word [clockticks], byte 0
        je short .5
        lea ebx, [byte eax-01h]
.5:
        push byte 0
        push byte 0
        mov edi, 3Ch
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv edi
        push edx
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv edi
        mov ebx, ecx
        mov edx, dword [byte esi+044h]
        sar edx, 18h
        test byte [byte esi+pflags], 40h
        setne cl
        movzx edi, cl
        mov ecx, eax
        mov eax, edi
        call PostInjuryEvent
        mov edx, dword [byte esi+044h]
        sar edx, 18h
        test byte [byte esi+pflags], 40h
        setne al
        xor ah, ah
        cwde
        call RemoveFromLines
        jmp near checkob_ret5
%endif ; C
;-----------------------------------------------------------------------------
; NetCollide                                      5601D  95 PC, low confidence
; Player near a net (x +-60h, y +-0CAh): when inside the frame snaps the
; player to the net edge for his facing (FallDown_pinxl / CCBEC / CCBFC
; offset tables), stops him and returns the bump animation (0F0Fh / 0F55h /
; 0FE1h)
;-----------------------------------------------------------------------------
NetCollide:
        push dword 2Ch
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 0Ch
        mov esi, eax
        mov ebp, edx
        cmp word [byte eax+02h], byte 0
        jl short .1
        mov eax, 60h
        jmp short .2
.1:
        mov eax, 0FFFFFFA0h
.2:
        mov dword [byte esp+08h], eax
        mov edx, dword [esi]
        sar edx, 10h
        sub edx, eax
        mov dword [esp], edx
        cmp word [byte esi+Ypos+2], byte 0
        jl short .3
        mov eax, 0CAh
        jmp short .4
.3:
        mov eax, 0FFFFFF36h
.4:
        mov edi, eax
        mov edx, dword [byte esi+Ypos]
        sar edx, 10h
        sub edx, eax
        mov dword [byte esp+04h], edx
        push edx
        mov ebx, dword [byte esp+04h]
        push ebx
        call vecdist
        mov ecx, eax
        add esp, byte 8
        cmp eax, byte 18h
        jl near .24
        mov edx, dword [esp]
        shl edx, 8
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov ebx, eax
        sar ebx, 2
        mov edx, dword [byte esp+04h]
        shl edx, 8
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        sar eax, 2
        test eax, eax
        jge short .5
        mov ecx, eax
        neg ecx
        jmp short .6
.5:
        mov ecx, eax
.6:
        test ebx, ebx
        jge short .7
        mov edx, ebx
        neg edx
        jmp short .8
.7:
        mov edx, ebx
.8:
        cmp ecx, edx
        jl near .12
        test edi, edi
        jl near .11
        add ebp, byte 2
        and ebp, byte 7
        cmp ebp, byte 5
        jl near .24
        mov edx, dword [byte esp+08h]
        add edx, ebx
        mov word [byte esi+Xpos+2], dx
        cmp dword [byte esp+08h], byte 0
        jge short .9
        test byte [byte esi+055h], 8
        sete dl
        and edx, 0FFh
        je short .9
        add word [byte esi+Xpos+2], byte 6
.9:
        cmp dword [byte esp+08h], byte 0
        jle short .10
        test byte [byte esi+055h], 8
        je short .10
        sub word [byte esi+Xpos+2], byte 6
.10:
        add eax, edi
        sub eax, byte 8
        mov word [byte esi+Ypos+2], ax
        mov word [byte esi+Xvel], 0
        mov word [byte esi+Yvel], 0
        mov eax, dword [byte esi+facedir-2]
        sar eax, 10h
        mov ax, word [nosplit eax*2+FallDown_pinyt]
        db 081h,0E8h,08h,01h,00h,00h            ; insn: sub eax,108h
        add word [byte esi+Ypos+2], ax
        mov eax, 0F0Fh
        jmp near .25
.11:
        inc ebp
        and ebp, byte 7
        cmp ebp, byte 3
        jge near .24
        mov edx, dword [byte esp+08h]
        add edx, ebx
        mov word [byte esi+Xpos+2], dx
        add eax, edi
        mov word [byte esi+Ypos+2], ax
        mov word [byte esi+Xvel], 0
        mov word [byte esi+Yvel], 0
        mov eax, dword [byte esi+facedir-2]
        sar eax, 10h
        mov ax, word [nosplit eax*2+FallDown_pinyb]
        add eax, 108h
        add word [byte esi+Ypos+2], ax
        mov eax, 0F55h
        jmp near .25
.12:
        cmp dword [byte esp+08h], byte 0
        jl near .18
        cmp ebp, byte 5
        jl near .24
        sub ebx, byte 6
        mov edx, dword [byte esp+08h]
        add edx, ebx
        mov word [byte esi+Xpos+2], dx
        test edi, edi
        jle short .13
        mov edx, 0FFFFFFF6h
        jmp short .14
.13:
        xor edx, edx
.14:
        add eax, edi
        add eax, edx
        mov word [byte esi+Ypos+2], ax
        mov word [byte esi+Xvel], 0
        mov word [byte esi+Yvel], 0
        test byte [byte esi+055h], 8
        je short .15
        mov eax, dword [byte esi+facedir-2]
        sar eax, 10h
        mov edx, 8
        sub edx, eax
        mov eax, edx
        and eax, byte 7
        mov ax, word [nosplit eax*2+FallDown_pinxl]
        add eax, 9Ah
        sub word [byte esi+Xpos+2], ax
        jmp short .16
.15:
        mov eax, dword [byte esi+facedir-2]
        sar eax, 10h
        mov ax, word [nosplit eax*2+FallDown_pinxr]
        db 081h,0E8h,09Ah,00h,00h,00h           ; insn: sub eax,9Ah
        add word [byte esi+Xpos+2], ax
.16:
        test byte [byte esi+055h], 8
        jne near .23
.17:
        mov eax, 0F9Bh
        jmp near .25
.18:
        test ebp, ebp
        je near .24
        dec ebp
        cmp ebp, byte 3
        jge near .24
        add ebx, byte 6
        mov edx, dword [byte esp+08h]
        add edx, ebx
        mov word [byte esi+Xpos+2], dx
        test edi, edi
        jle short .19
        mov edx, 0FFFFFFF6h
        jmp short .20
.19:
        xor edx, edx
.20:
        add eax, edi
        add eax, edx
        mov word [byte esi+Ypos+2], ax
        mov word [byte esi+Xvel], 0
        mov word [byte esi+Yvel], 0
        test byte [byte esi+055h], 8
        je short .21
        mov eax, dword [byte esi+facedir-2]
        sar eax, 10h
        mov edx, 8
        sub edx, eax
        mov eax, edx
        and eax, byte 7
        mov ax, word [nosplit eax*2+FallDown_pinxr]
        db 081h,0E8h,09Ah,00h,00h,00h           ; insn: sub eax,9Ah
        sub word [byte esi+Xpos+2], ax
        jmp short .22
.21:
        mov eax, dword [byte esi+facedir-2]
        sar eax, 10h
        mov ax, word [nosplit eax*2+FallDown_pinxl]
        add eax, 9Ah
        add word [byte esi+Xpos+2], ax
.22:
        test byte [byte esi+055h], 8
        jne near NetCollide.17
.23:
        mov eax, 0FE1h
        jmp short .25
.24:
        mov eax, dword [byte esi+SPA-2]
        sar eax, 10h
.25:
        add esp, byte 0Ch
        jmp near PassLaneChk_ret5
;-----------------------------------------------------------------------------
; FallDown                                            562DB  94G collide94.asm
; A player falls after a hit: fall animation, newcheck, injury (setInjuryType),
; penalty roll (checkagr AddPenalty2).
;-----------------------------------------------------------------------------
; C: src/engine/collide/FallDown.c
%ifdef CBUILD
%include "c/engine/collide/FallDown.inc"
%else
FallDown:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        mov ecx, eax
        mov ebx, edx
        cmp word [byte edx+06Ah], byte 0Bh
        jle short .1
        cmp word [byte ebx+SCnum], byte 10h
        jne near .x
.1:
        test byte [byte ebx+pflags2], 1
        jne near .x
        mov si, word [byte ebx+SPA]
        cmp si, 0A0Bh
        je near .x
        cmp si, 8D3h
        je near .x
        cmp si, 681h
        je near .x
        cmp si, 6D9h
        je near .x
        cmp si, 993h
        je near .x
        cmp si, 13C5h
        je near .x
        cmp si, 141Dh
        je near .x
        cmp word [byte ebx+SCnum], byte 10h
        jne short .4
        cmp si, 0B13h
        je near .x
        or byte [byte ebx+pflags], 20h
        mov edx, 0B13h
        mov eax, ebx
        call SetSPA
        mov di, word [crowdlevel]
        cmp di, 3E8h
        jg short .2
        mov eax, edi
        add eax, 1F4h
        mov word [crowdlevel], ax
        cmp ax, 3E8h
        jle short .2
        mov word [crowdlevel], 3E8h
.2:
        add word [CwdExciteLvl], byte 0Fh
        mov eax, 1
        call newcheck
.3:
        mov eax, 7Dh
        jmp near .55
.4:
        cmp byte [byte ebx+060h], 0Ch
        jb short .5
        mov eax, 10h
        call randomd0
        cwde
        mov edx, dword [byte ebx+016h]
        sar edx, 10h
        add eax, byte 10h
        cmp eax, edx
        jle short .5
        mov word [byte ebx+040h], 3Ch
        mov esi, 8D3h
        jmp near .38
.5:
        cmp word [byte ecx+position], byte 0
        je short .6
        mov eax, dword [byte ecx+06Ch]
        mov dh, byte [gmode]
        test dh, 10h
        jne short .6
        test dh, 1
        jne short .6
        inc word [byte eax+024h]
.6:
        mov word [byte ebx+03Eh], 78h
        mov ax, word [byte ecx+Ypos+2]
        sub ax, word [byte ebx+Ypos+2]
        movsx edx, ax
        mov ax, word [byte ecx+Xpos+2]
        sub ax, word [byte ebx+Xpos+2]
        cwde
        call vtoa
        mov edi, eax
        cmp word [byte ecx+position], byte 0
        je short .7
        cmp word [byte ecx+SCnum], byte 6
        setl al
        mov edx, eax
        and edx, 0FFh
        cmp word [byte ebx+SCnum], byte 6
        setl al
        and eax, 0FFh
        cmp edx, eax
        jne short .8
.7:
        mov si, word [byte ebx+SPA]
        jmp near .27
.8:
        cmp word [byte ebx+Xpos+2], byte 0
        jge short .9
        mov eax, dword [ebx]
        sar eax, 10h
        neg eax
        jmp short .10
.9:
        mov eax, dword [ebx]
        sar eax, 10h
.10:
        cmp eax, byte 60h
        jl short .13
        cmp word [byte ebx+Ypos+2], byte 0
        jge short .11
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
        neg eax
        jmp short .12
.11:
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
.12:
        cmp eax, 0CAh
        jl short .13
        movsx edx, di
        mov eax, ebx
        call NetCollide
        mov esi, eax
        cmp ax, word [byte ebx+SPA]
        jne near .27
.13:
        cmp word [byte ebx+Xpos+2], 80h
        jl near .19
        cmp word [byte ebx+Ypos+2], 0D0h
        jg short .14
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
        cmp eax, 0FFFFFF2Ah
        jge short .15
.14:
        movsx edx, di
        mov eax, ebx
        call NetCollide
        mov esi, eax
        jmp near .27
.15:
        cmp di, byte 5
        jl near .27
        mov word [byte ebx+Xvel], 0
        test byte [byte ebx+055h], 8
        je short .18
        mov esi, 0FE1h
        mov eax, dword [byte ebx+facedir-2]
        sar eax, 10h
        mov edx, 8
        sub edx, eax
        mov eax, edx
        and eax, byte 7
        mov ax, word [nosplit eax*2+FallDown_pinxl]
.16:
        neg eax
.17:
        mov word [byte ebx+Xpos+2], ax
        jmp near .27
.18:
        mov esi, 0F9Bh
        mov eax, dword [byte ebx+facedir-2]
        sar eax, 10h
        mov ax, word [nosplit eax*2+FallDown_pinxr]
        jmp short FallDown.17
.19:
        mov eax, dword [ebx]
        sar eax, 10h
        cmp eax, byte 0FFFFFF80h
        jg near .25
        cmp word [byte ebx+Ypos+2], 0D0h
        jg short FallDown.14
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
        cmp eax, 0FFFFFF2Ah
        jl near FallDown.14
        test di, di
        je near .27
        cmp di, byte 4
        jge near .27
        mov word [byte ebx+Xvel], 0
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
        cmp eax, byte 0FFFFFFACh
        jl short .20
        cmp eax, byte 0FFFFFFF6h
        jl short .21
.20:
        mov dx, word [byte ebx+Ypos+2]
        cmp dx, byte 27h
        jl short .23
        cmp dx, byte 75h
        jge short .23
.21:
        test byte [byte ebx+055h], 8
        je short .22
        mov esi, 1027h
        mov eax, dword [byte ebx+facedir-2]
        sar eax, 10h
        mov edx, 8
        sub edx, eax
        mov eax, edx
        and eax, byte 7
        mov ax, word [nosplit eax*2+FallDown_pinxr2]
        jmp near FallDown.16
.22:
        mov esi, 1055h
        mov eax, dword [byte ebx+facedir-2]
        sar eax, 10h
        mov ax, word [nosplit eax*2+FallDown_pinxl2]
        jmp near FallDown.17
.23:
        test byte [byte ebx+055h], 8
        je short .24
        mov esi, 0F9Bh
        mov eax, dword [byte ebx+facedir-2]
        sar eax, 10h
        mov edx, 8
        sub edx, eax
        mov eax, edx
        and eax, byte 7
        mov ax, word [nosplit eax*2+FallDown_pinxr]
        jmp near FallDown.16
.24:
        mov esi, 0FE1h
        mov eax, dword [byte ebx+facedir-2]
        sar eax, 10h
        mov ax, word [nosplit eax*2+FallDown_pinxl]
        jmp near FallDown.17
.25:
        cmp word [byte ebx+Ypos+2], 0EEh
        jl short .26
        cmp word [byte ebx+Xpos+2], byte 68h
        jg near FallDown.14
        cmp eax, byte 0FFFFFF98h
        jl near FallDown.14
        movsx eax, di
        add eax, byte 2
        and eax, byte 7
        cmp eax, byte 5
        jl short .27
        mov eax, dword [byte ebx+facedir-2]
        sar eax, 10h
        mov ax, word [nosplit eax*2+FallDown_pinyt]
        mov word [byte ebx+Ypos+2], ax
        mov word [byte ebx+Yvel], 0
        mov esi, 0F0Fh
        jmp short .27
.26:
        mov edx, dword [byte ebx+Ypos]
        sar edx, 10h
        cmp edx, 0FFFFFF0Eh
        jg short .27
        cmp word [byte ebx+Xpos+2], byte 68h
        jg near FallDown.14
        cmp eax, byte 0FFFFFF98h
        jl near FallDown.14
        movsx eax, di
        inc eax
        and eax, byte 7
        cmp eax, byte 3
        jge short .27
        mov eax, dword [byte ebx+facedir-2]
        sar eax, 10h
        mov ax, word [nosplit eax*2+FallDown_pinyb]
        mov word [byte ebx+Ypos+2], ax
        mov word [byte ebx+Yvel], 0
        mov esi, 0F55h
.27:
        cmp si, word [byte ebx+SPA]
        jne near .35
        sub di, word [byte ebx+facedir]
        inc edi
        and edi, byte 7
        cmp di, byte 2
        ja short .28
        mov esi, 6D9h
        jmp near .38
.28:
        cmp word [byte ecx+SCnum], byte 0Eh
        jne near .33
        cmp di, byte 3
        je short .29
        cmp di, byte 7
        jne near .33
.29:
        mov esi, 6D9h
        mov di, word [byte ecx+012h]
        cmp di, 44Fh
        jg near .38
        cmp di, 467h
        jg near .38
        cmp dword [penshotplayer], byte 0
        jge near .38
        mov dl, byte [gmode]
        test dl, 1
        jne near .38
        test dl, 10h
        jne near .38
        test byte [gameopts], 10h
        je near .38
        test byte [byte ebx+036h], 3
        jne near .38
        test byte [byte ebx+pflags2], 10h
        jne near .38
        test byte [byte ebx+pflags], 8
        je short .30
        mov eax, 0C8h
        jmp short .31
.30:
        mov eax, 0A0h
.31:
        cwde
        call randomd0
        cmp ax, 14h
        jg near .38
        mov eax, ebx
        call CanRemovePlayer
        test eax, eax
        je near .38
        mov dx, word [crowdlevel]
        cmp dx, 3E8h
        jg short .32
        mov esi, edx
        add esi, 1F4h
        mov word [crowdlevel], si
        cmp si, 3E8h
        jle short .32
        mov word [crowdlevel], 3E8h
.32:
        add word [CwdExciteLvl], byte 0Fh
        or byte [byte ebx+pflags], 20h
        mov edx, 0A0Bh
        mov eax, ebx
        call SetSPA
        mov eax, ebx
        call setInjuryType
        mov edx, 0Ah
        mov eax, ecx
        call AddPenalty2
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.33:
        test byte [byte ebx+036h], 3
        jne short .34
        cmp byte [byte ecx+064h], 0Ah
        jb short .34
        cmp word [byte ecx+SCnum], byte 0Bh
        jg short .34
        mov esi, 993h
        test byte [byte ecx+pflags], 40h
        setne al
        and eax, 0FFh
        call SetBoxDoorObject
        jmp short .38
.34:
        mov esi, 681h
        jmp short .38
.35:
        mov eax, dword [puckc]
        add word [crowdlevel], byte 64h
        movsx ax, byte [eax]
        cmp ax, word [byte ebx+SCnum]
        je short .38
        mov eax, ecx
        call checkagr
        cmp ax, 3
        jg short .38
        cmp si, 0F0Fh
        jl short .38
        cmp si, 0FE1h
        jg short .38
        cmp word [byte ebx+018h], byte 23h
        jle short .36
        mov eax, 18h
        jmp short .37
.36:
        mov eax, 14h
.37:
        movsx edx, ax
        mov eax, ecx
        call AddPenalty
.38:
        or byte [byte ebx+pflags], 20h
        movsx edx, si
        mov eax, ebx
        call SetSPA
        mov eax, dword [byte ebx+assnum-2]
        sar eax, 10h
        cmp byte [byte ebx+eax+01Eh], 12h
        jne short .39
        mov eax, ebx
        call assexit
.39:
        mov di, word [crowdlevel]
        cmp di, 3E8h
        jg short .40
        mov eax, edi
        add eax, 1F4h
        mov word [crowdlevel], ax
        cmp ax, 3E8h
        jle short .40
        mov word [crowdlevel], 3E8h
.40:
        mov eax, dword [puckc]
        add word [CwdExciteLvl], byte 0Fh
        mov dh, byte [eax]
        test dh, dh
        jl short .41
        movsx dx, dh
        cmp dx, word [byte ebx+SCnum]
        je short .44
.41:
        cmp si, 0F0Fh
        jl short .43
        cmp si, 1055h
        jg short .43
        mov eax, 2
.42:
        call newcheck
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.43:
        mov eax, 1
        jmp short FallDown.42
.44:
        mov byte [eax], 0FFh
        cmp dword [penshotplayer], byte 0
        jge near .54
        test byte [gmode], 10h
        jne near .54
        test byte [gameopts], 10h
        je near .54
        cmp word [byte ebx+SPA], 6D9h
        jne near .54
        test byte [byte ebx+036h], 3
        jne near .54
        test byte [byte ebx+pflags2], 10h
        jne near .54
        test byte [byte ebx+pflags], 8
        je short .45
        mov eax, 0C8h
        jmp short .46
.45:
        mov eax, 0A0h
.46:
        cwde
        call randomd0
        cmp ax, word [byte ebx+018h]
        jg near .54
        test byte [gmode], 1
        jne near .54
        mov eax, ebx
        call CanRemovePlayer
        test eax, eax
        je near .54
        or byte [byte ebx+pflags], 20h
        mov edx, 0A0Bh
        mov eax, ebx
        call SetSPA
        mov eax, ebx
        call setInjuryType
        cmp word [byte ecx+position], byte 0
        je short .47
        test byte [gameopts], 1
        je short .47
        test byte [byte ecx+pflags], 40h
        setne al
        and eax, 0FFh
        cmp byte [dword eax+PBnum], 8
        jge short .47
        mov eax, ecx
        call CanRemovePlayer
        test eax, eax
        jne short .48
.47:
        mov edx, 0Ah
        mov eax, ecx
        call AddPenalty2
        jmp near .54
.48:
        mov ax, word [byte ebx+Ypos+2]
        sub ax, word [byte ecx+Ypos+2]
        movsx edx, ax
        mov ax, word [byte ebx+Xpos+2]
        sub ax, word [byte ecx+Xpos+2]
        cwde
        call vtoa
        mov edx, dword [byte ecx+facedir-2]
        sar edx, 10h
        cwde
        sub eax, edx
        inc eax
        and eax, byte 7
        cmp eax, byte 2
        jg short .49
        mov eax, dword [byte ebx+facedir-2]
        sar eax, 10h
        sub eax, edx
        inc eax
        and eax, byte 7
        cmp eax, byte 2
        jg short .49
        mov edx, 17h
        jmp short .50
.49:
        mov edx, 9
.50:
        mov eax, ecx
        call AddPenalty2
        xor edx, edx
        jmp short .53
.51:
        movsx eax, dx
        cmp byte [nosplit eax*2+PenBuf], 0
        jne short .52
        mov eax, edx
        dec eax
        cwde
        call Stop4Pen
.52:
        inc edx
.53:
        cmp dx, byte 20h
        jl short FallDown.51
.54:
        test byte [byte ebx+pflags], 40h
        jne near FallDown.3
        mov eax, 0A0h
.55:
        call sfx
.x:
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; Bcheck                           56A54  94G collide94.asm, medium confidence
; 93G Bcheck: player in the B-check animation hits the other player
; (FallDown, checkagr, AddPenalty)
;-----------------------------------------------------------------------------
; C: src/engine/collide/Bcheck.c
%ifdef CBUILD
%include "c/engine/collide/Bcheck.inc"
%else
Bcheck:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push esi
        mov ebx, eax
        mov ecx, edx
        test byte [byte eax+044h], 20h
        jne near .x
        cmp word [byte ebx+SCnum], byte 10h
        je near .x
        cmp word [byte ebx+position], byte 0
        je near .x
        test byte [byte ebx+pflags2], 1
        jne near .x
        test byte [gameopts], 1
        jne short .1
        test byte [byte ecx+pflags], 8
        je short .1
        xor eax, eax
        mov al, byte [byte ecx+064h]
        mov edx, eax
        add edx, byte 10h
        xor eax, eax
        mov al, byte [byte ebx+057h]
        sub edx, eax
        movsx eax, dx
        call randomd0
        cmp ax, 0Ch
        jl near .x
.1:
        mov esi, dword [byte ecx+facedir-2]
        sar esi, 10h
        mov ax, word [byte ebx+Ypos+2]
        sub ax, word [byte ecx+Ypos+2]
        movsx edx, ax
        mov ax, word [byte ebx+Xpos+2]
        sub ax, word [byte ecx+Xpos+2]
        cwde
        call vtoa
        cwde
        sub eax, esi
        inc eax
        and eax, byte 7
        cmp eax, byte 2
        jg near .x
        mov edx, ebx
        mov eax, ecx
        call FallDown
        mov eax, ebx
        call QuickShotChk
        test eax, eax
        je short .5
        cmp dword [penshotplayer], byte 0
        jge short .7
        mov eax, dword [byte ebx+SCnum-2]
        sar eax, 10h
        mov dword [penshotplayer], eax
        mov eax, dword [c1playernum-2]
        sar eax, 10h
        mov ebx, dword [penshotplayer]
        cmp eax, ebx
        jne short .2
        mov dword [penshotctl], 1
        jmp short .4
.2:
        jne short .3
        mov dword [penshotctl], 2
        jmp short .4
.3:
        mov dword [penshotctl], 0FFFFFFFFh
.4:
        mov edx, 1Ah
        jmp short .6
.5:
        mov eax, ecx
        call checkagr
        cmp ax, 4
        jg short .7
        mov edx, 10h
.6:
        mov eax, ecx
        call AddPenalty
.7:
        mov byte [collflag], 0FFh
.x:
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; holdcheck                        56B79  94G collide94.asm, medium confidence
;-----------------------------------------------------------------------------
; C: src/engine/collide/holdcheck.c
%ifdef CBUILD
%include "c/engine/collide/holdcheck.inc"
%else
holdcheck:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push esi
        mov ebx, eax
        mov ecx, edx
        test byte [byte eax+044h], 20h
        jne near .x
        cmp word [byte ebx+SCnum], byte 10h
        je near .x
        cmp word [byte ebx+position], byte 0
        je near .x
        test byte [byte ebx+pflags2], 1
        jne near .x
        mov esi, dword [byte ecx+facedir-2]
        sar esi, 10h
        mov ax, word [byte ebx+Ypos+2]
        sub ax, word [byte ecx+Ypos+2]
        movsx edx, ax
        mov ax, word [byte ebx+Xpos+2]
        sub ax, word [byte ecx+Xpos+2]
        cwde
        call vtoa
        cwde
        sub eax, esi
        inc eax
        and eax, byte 7
        cmp eax, byte 2
        jg near .x
        mov eax, dword [puckc]
        movsx ax, byte [eax]
        cmp ax, word [byte ebx+SCnum]
        jne short .1
        and byte [sflags], 0F7h
.1:
        mov edx, dword [byte ebx+Xvel-2]
        sar edx, 10h
        mov eax, dword [byte ecx+Xvel-2]
        sar eax, 10h
        add eax, edx
        sar eax, 1
        mov word [byte ebx+Xvel], ax
        mov word [byte ecx+Xvel], ax
        mov edx, dword [byte ebx+Yvel-2]
        sar edx, 10h
        mov eax, dword [byte ecx+Yvel-2]
        sar eax, 10h
        add eax, edx
        sar eax, 1
        mov word [byte ebx+Yvel], ax
        mov word [byte ecx+Yvel], ax
        or byte [byte ebx+pflags], 20h
        mov edx, 669h
        mov eax, ebx
        call SetSPA
        or byte [byte ecx+pflags], 20h
        cmp word [byte ecx+SPA], 639h
        jne short .2
        mov eax, 651h
        jmp short .3
.2:
        mov eax, 88Bh
.3:
        movsx edx, ax
        mov eax, ecx
        call SetSPA
        mov eax, ebx
        call QuickShotChk
        test eax, eax
        je short .7
        cmp dword [penshotplayer], byte 0
        jge near .10
        mov eax, dword [byte ebx+SCnum-2]
        sar eax, 10h
        mov dword [penshotplayer], eax
        mov eax, dword [c1playernum-2]
        sar eax, 10h
        mov ebx, dword [penshotplayer]
        cmp eax, ebx
        jne short .4
        mov dword [penshotctl], 1
        jmp short .6
.4:
        jne short .5
        mov dword [penshotctl], 2
        jmp short .6
.5:
        mov dword [penshotctl], 0FFFFFFFFh
.6:
        mov edx, 1Ah
        mov eax, ecx
        call AddPenalty
        mov eax, dword [puckc]
        mov byte [eax], 0FFh
        mov word [byte ecx+03Eh], 20h
        jmp short .10
.7:
        mov eax, ecx
        call checkagr
        cmp ax, 6
        jg short .10
        cmp word [byte ecx+SPA], 651h
        jne short .8
        mov eax, 12h
        jmp short .9
.8:
        mov eax, 0Fh
.9:
        movsx edx, ax
        mov eax, ecx
        call AddPenalty
.10:
        mov byte [collflag], 0FFh
.x:
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; puckbody                         56D06  94G collide94.asm, medium confidence
; 93G puckbody (puck hits player a2): a2touchpuck, GetHot, puckflip, sfx;
; called from checkpuckcoll
;-----------------------------------------------------------------------------
; C: src/engine/collide/puckbody.c
%ifdef CBUILD
%include "c/engine/collide/puckbody.inc"
%else
puckbody:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        mov ebx, eax
        mov ecx, edx
        mov dx, word [byte eax+012h]
        cmp dx, 430h
        jl short .1
        cmp dx, 467h
        jg short .1
        cmp dx, 44Fh
        jg short .2
        test byte [byte eax+012h], 1
        je short .2
        cmp word [byte ebx+0Ah], byte 8
        jg near .x
        jmp short .2
.1:
        cmp word [byte ebx+0Ah], byte 8
        jg short .2
        mov ax, word [regd0]
        xor ah, ah
        and al, 0Fh
        mov word [regd1], ax
        test ax, ax
        jne near .x
.2:
        cmp word [byte ecx+SCnum], byte 10h
        je short .3
        mov eax, ecx
        call a2touchpuck
.3:
        mov word [byte ebx+010h], 0
        mov word [byte ecx+03Eh], 8
        mov ax, word [byte ebx+02h]
        mov dx, word [byte ecx+Xpos+2]
        sub eax, edx
        mov word [regd0], ax
        mov ax, word [byte ebx+06h]
        mov si, word [byte ecx+Ypos+2]
        sub ax, si
        mov word [regd1], ax
        jne short .4
        mov eax, ecx
        call GetHot
.4:
        mov dx, word [byte ebx+0Ch]
        mov di, word [byte ebx+0Eh]
        mov al, byte [regd0]
        mov byte [byte ebx+0Dh], al
        mov al, byte [regd1]
        mov byte [byte ebx+0Fh], al
        mov eax, ebx
        call puckflip
        cmp word [byte ebx+0Ah], byte 8
        jg short .5
        cmp word [byte ecx+SPA], 84Bh
        je near .x
        mov eax, 0A3h
        call sfx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.5:
        mov esi, 0A3h
        movsx eax, dx
        mov edx, eax
        imul edx, eax
        movsx eax, di
        imul eax, eax
        add eax, edx
        cmp eax, 895440h
        jle short .6
        cmp word [byte ebx+0Ah], byte 0Ch
        jle short .6
        mov esi, 0A2h
        mov edx, ecx
        mov eax, ebx
        call FallDown
.6:
        cmp word [byte ecx+SPA], 84Bh
        je short .7
        movsx eax, si
        call sfx
.7:
        mov dl, byte [byte ecx+pflags]
        test dl, 20h
        jne short .x
        cmp word [byte ecx+SCnum], byte 10h
        je short .x
        mov dh, dl
        or dh, 20h
        mov byte [byte ecx+pflags], dh
        mov edx, 84Bh
        mov eax, ecx
        call SetSPA
.x:
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; PuckIChk                                              56E52  94G logic94.asm
; (icing). iflags bit 2 ifok, bit 0 ifcgl, bit 1 ifdir; loose puck past the goal
; line: |puckx| > 2Ch sets ifcgl (icing), else clears ifok.
;-----------------------------------------------------------------------------
; C: src/engine/collide/PuckIChk.c
%ifdef CBUILD
%include "c/engine/collide/PuckIChk.inc"
%else
PuckIChk:
        push dword 8
        call __CHK
        push ebx
        mov ah, byte [iflags]
        test ah, 4
        je near .x
        test ah, 1
        jne short .x
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jge short .x
        test byte [iflags], 2
        jne short .1
        mov eax, dword [pucky]
        movsx eax, word [eax]
        cmp eax, 0FFFFFF18h
        jge short .x
        jmp short .2
.1:
        mov eax, dword [pucky]
        cmp word [eax], 0E8h
        jl short .x
.2:
        mov eax, dword [puckx]
        mov bx, word [eax]
        test bx, bx
        jge short .3
        movsx eax, bx
        neg eax
        jmp short .4
.3:
        movsx eax, bx
.4:
        cmp eax, byte 2Ch
        jg short .5
        and byte [iflags], 0FBh
        pop ebx
        ret
.5:
        or byte [iflags], 1
.x:
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; puckshadow                         56ECF  94G logic94.asm, medium confidence
; Asstab slot 25; field alignment 100% of 6 known-field accesses; content
; rank 2/34 vs other slot routines; 0 known Genesis callees present, 0
; missing, 0 extra
;-----------------------------------------------------------------------------
; C: src/engine/collide/puckshadow.c
%ifdef CBUILD
%include "c/engine/collide/puckshadow.inc"
%else
puckshadow:
        push dword 8
        call __CHK
        push edx
        cmp word [byte eax+012h], 189h
        jne short .2
        mov edx, dword [puckx]
        mov dx, word [edx]
        mov word [byte eax+Xpos+2], dx
        mov edx, dword [pucky]
        mov dx, word [edx]
        mov word [byte eax+Ypos+2], dx
        mov word [byte eax+0Ah], 0
        test byte [sflags], 80h
        je short .1
        inc word [byte eax+Xpos+2]
        pop edx
        ret
.1:
        inc word [byte eax+Ypos+2]
        pop edx
        ret
.2:
        mov edx, dword [byte eax+010h]
        sar edx, 10h
        cmp edx, byte 0FFFFFFFFh
        je short .x
        cmp word [byte eax+SPA], 7FDh
        jne short .x
        mov word [byte eax+Xpos+2], 0
        mov word [byte eax+Ypos+2], 122h
        mov word [byte eax+0Ah], 0Eh
        mov edx, dword [pucky]
        cmp word [edx], byte 0
        jge short .x
        mov word [byte eax+054h], 8000h
        mov word [byte eax+Ypos+2], 0FEF6h
        dec word [byte eax+0Ah]
.x:
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; puckglue                         56F5A  94G collide94.asm, medium confidence
;-----------------------------------------------------------------------------
; C: src/engine/collide/puckglue.c
%ifdef CBUILD
%include "c/engine/collide/puckglue.inc"
%else
puckglue:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push edi
        mov edx, eax
        mov ax, word [byte eax+06Ah]
        mov word [regd0], ax
        mov bl, byte [regd0]
        mov eax, dword [puckc]
        mov byte [eax], bl
        mov ebx, dword [byte edx+tmptr]
        mov ecx, dword [byte edx+optmptr]
        cmp dword [penshotlive], byte 0
        je short .1
        movsx ax, byte [byte edx+pnum]
        cmp ax, word [byte ebx+030h]
        jne short .1
        call EndPenaltyShot
        xor edi, edi
        mov dword [onetimerflag], edi
        mov dword [shotongoal], edi
.1:
        mov byte [byte ecx+033h], 0FFh
        mov byte [byte ecx+035h], 0FFh
        or byte [byte ecx+044h], 8
        mov cl, byte [sflags3]
        test cl, 10h
        je near .6
        mov ch, cl
        and ch, 0EFh
        mov byte [sflags3], ch
        test byte [gmode], 10h
        jne short .4
        inc word [byte ebx+012h]
        mov eax, dword [pucky]
        cmp word [eax], byte 4Eh
        jle short .2
        test byte [byte edx+pflags], 80h
        jne short .3
.2:
        mov ecx, dword [pucky]
        movsx eax, word [ecx]
        cmp eax, byte 0FFFFFFB2h
        jge short .4
        test byte [byte edx+pflags], 80h
        jne short .4
.3:
        inc word [byte ebx+014h]
.4:
        mov ax, word [crowdlevel]
        cmp ax, 3E8h
        jg short .5
        mov ebx, eax
        add ebx, 0C8h
        mov word [crowdlevel], bx
        cmp bx, 3E8h
        jle short .5
        mov word [crowdlevel], 3E8h
.5:
        test byte [byte edx+pflags], 40h
        jne short .7
        add word [CwdExciteLvl], byte 0Ah
        jmp short .7
.6:
        mov eax, 9Bh
        call sfx
.7:
        mov eax, edx
        call PassCompleted
        and byte [sflags], 0F3h
        cmp word [byte edx+position], byte 0
        jne short .9
        call ChkShotStat
        call EndPenaltyShot
        cmp word [byte edx+SPA], 181h
        jne short .8
        mov word [byte edx+temp5], 5
        jmp short .9
.8:
        mov word [byte edx+temp5], 8Ch
.9:
        mov eax, dword [regd0-2]
        sar eax, 10h
        call GiveControl
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; puckgoalie                       57096  94G collide94.asm, medium confidence
;-----------------------------------------------------------------------------
; C: src/engine/collide/puckgoalie.c
%ifdef CBUILD
%include "c/engine/collide/puckgoalie.inc"
%else
puckgoalie:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 4
        mov ecx, eax
        mov ebx, edx
        xor edx, edx
        mov word [esp], dx
        test byte [gmode], 10h
        jne near .x
        mov word [regd2], dx
        cmp word [byte ecx+0Ah], byte 8
        jg short .1
        mov word [regd2], 2
.1:
        mov ax, word [regd1]
        neg eax
        movsx edx, ax
        mov ax, word [regd0]
        neg eax
        cwde
        call vtoa
        sub ax, word [byte ebx+facedir]
        xor ah, ah
        and al, 7
        mov word [regd0], ax
        test byte [regd0], 3
        jne short .2
        mov eax, 100h
        call randomd0
        mov word [regd0], ax
.2:
        mov ax, word [regd0]
        xor ah, ah
        and al, 4
        cwde
        sar eax, 2
        xor al, 1
        mov edx, eax
        mov eax, dword [regd2-2]
        sar eax, 10h
        add eax, edx
        mov word [regd2], ax
        mov esi, eax
        add esi, eax
        mov word [regd2], si
        test byte [byte ebx+055h], 8
        je short .3
        xor byte [regd2], 2
.3:
        mov ax, word [byte ebx+012h]
        cmp ax, 206h
        jl short .4
        cmp ax, 216h
        jge short .4
        mov eax, dword [puckz]
        cmp word [eax], byte 5
        jge near .x
.4:
        mov byte [byte ebx+063h], 0
        cmp word [dword_E9A9E], byte 0
        jne near .12
        test byte [byte ebx+pflags], 40h
        jne near .12
        test byte [gmode2], 10h
        je near .12
        cmp word [byte ebx+SCnum], byte 6
        setl al
        mov edx, eax
        and edx, 0FFh
        cmp word [shotplayer], byte 6
        setl al
        and eax, 0FFh
        xor eax, edx
        je near .12
        mov eax, dword [shotplayer-2]
        sar eax, 10h
        shl eax, 7
        cmp word [dword eax+SortCords+6], byte 0
        jge short .5
        mov eax, dword [dword eax+SortCords+4]
        sar eax, 10h
        neg eax
        jmp short .6
.5:
        mov eax, dword [dword eax+SortCords+4]
        sar eax, 10h
.6:
        cmp eax, byte 58h
        jle near .12
        mov eax, dword [shotplayer-2]
        sar eax, 10h
        shl eax, 7
        cmp word [dword eax+SortCords+6], byte 0
        setg al
        and eax, 0FFh
        test byte [byte ebx+pflags], 80h
        setne dl
        and edx, 0FFh
        xor eax, edx
        je short .12
        mov eax, dword [puckvy]
        mov si, word [eax]
        test si, si
        jge short .7
        movsx edx, si
        neg edx
        jmp short .8
.7:
        movsx edx, si
.8:
        mov eax, dword [puckvx]
        mov di, word [eax]
        test di, di
        jge short .9
        movsx eax, di
        neg eax
        jmp short .10
.9:
        movsx eax, di
.10:
        add eax, edx
        cmp ax, 4268h
        jg short .11
        cmp ax, 1770h
        jle short .12
        mov ax, word [byte ebx+SPA]
        cmp ax, 119Dh
        jl short .12
        cmp ax, 121Dh
        jg short .12
.11:
        mov word [esp], 1
.12:
        call ChkShotStat
        mov eax, ebx
        call a2touchpuck
        test byte [gmode], 1
        jne short .17
        mov eax, dword [puckvy]
        mov di, word [eax]
        test di, di
        jge short .13
        movsx eax, di
        neg eax
        jmp short .14
.13:
        movsx eax, di
.14:
        cmp eax, 0FA0h
        jle short .17
        test byte [byte ebx+pflags], 40h
        jne short .15
        mov eax, 7Dh
        jmp short .16
.15:
        mov eax, 0A1h
.16:
        call sfx
.17:
        mov eax, dword [puckvy]
        mov dx, word [eax]
        test dx, dx
        jge short .18
        movsx eax, dx
        neg eax
        jmp short .19
.18:
        movsx eax, dx
.19:
        cmp eax, 0BB8h
        jle short .20
        mov eax, 9Dh
        jmp short .21
.20:
        mov eax, 0A3h
.21:
        call sfx
        mov eax, dword [puckc]
        mov dl, byte [eax]
        test dl, dl
        jge near .27
        xor edx, edx
        mov dl, byte [byte ebx+05Bh]
        mov eax, edx
        shl eax, 2
        add edx, eax
        mov eax, edx
        sar edx, 1Fh
        shl edx, 2
        LD sbb, eax, edx
        sar eax, 2
        add eax, byte 2
        shl eax, 9
        cwde
        call randomd0
        add ah, 20h
        mov word [regd0], ax
        mov eax, dword [puckvx]
        mov si, word [eax]
        test si, si
        jge short .22
        movsx eax, si
        neg eax
        jmp short .23
.22:
        movsx eax, si
.23:
        mov edx, dword [regd0-2]
        sar edx, 10h
        cmp eax, edx
        jg near .28
        mov eax, dword [puckvy]
        mov di, word [eax]
        test di, di
        jge short .24
        movsx eax, di
        neg eax
        jmp short .25
.24:
        movsx eax, di
.25:
        mov edx, dword [regd0-2]
        sar edx, 10h
        cmp eax, edx
        jg short .28
        test byte [byte ebx+pflags2], 4
        jne short .28
        mov eax, dword [puckvz]
        mov word [eax], 0
        mov eax, dword [puckz]
        cmp word [eax], byte 8
        jle short .26
        mov word [eax], 8
.26:
        mov eax, dword [puckvx]
        sar word [eax], 2
        mov eax, dword [puckvy]
        sar word [eax], 2
        mov eax, ebx
        call puckglue
        mov al, byte [esp]
        mov byte [byte ebx+063h], al
        jmp near .x
.27:
        movsx edx, dl
        shl edx, 7
        add edx, SortCords
        mov byte [eax], 0FFh
        mov word [byte edx+03Eh], 14h
        mov ax, word [byte edx+06Ah]
        mov word [lastplayer], ax
        and byte [sflags], 0F3h
.28:
        mov eax, dword [puckvz]
        mov word [eax], 0
        mov eax, dword [puckz]
        cmp word [eax], byte 0Ah
        jle short .29
        mov word [eax], 0Ah
.29:
        mov word [byte ebx+03Eh], 0Ah
        mov word [byte ebx+temp4], 4
        mov ax, word [byte ecx+02h]
        mov si, word [byte ebx+Xpos+2]
        sub eax, esi
        mov word [regd0], ax
        mov ax, word [byte ecx+06h]
        mov di, word [byte ebx+Ypos+2]
        sub ax, di
        mov word [regd1], ax
        jne short .30
        mov eax, ebx
        call GetHot
.30:
        cmp word [regd1], byte 0
        jne short .31
        mov esi, 1
        mov word [regd1], si
.31:
        mov edx, dword [byte ebx+Yvel-2]
        sar edx, 10h
        mov eax, dword [regd1-2]
        sar eax, 10h
        xor eax, edx
        test eax, eax
        jl short .32
        neg word [regd1]
.32:
        mov eax, dword [regd0_m3]
        sar eax, 19h
        mov byte [byte ecx+0Dh], al
        mov eax, dword [regd1_m3]
        sar eax, 19h
        mov byte [byte ecx+0Fh], al
        mov eax, ecx
        call puckflip
.x:
        add esp, byte 4
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; puckstick                        57483  94G collide94.asm, medium confidence
;-----------------------------------------------------------------------------
; C: src/engine/collide/PassLaneChk.c (puckstick)
%ifdef CBUILD
%include "c/engine/collide/PassLaneChk.puckstick.inc"
%else
puckstick:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov ebp, eax
        mov esi, edx
        xor edx, edx
        cmp word [byte esi+position], byte 0
        jne near .9
        test byte [gmode], 10h
        jne near PassLaneChk_ret5a
        mov byte [byte esi+063h], 0
        cmp word [dword_E9A9E], byte 0
        jne near .8
        test byte [byte esi+pflags], 40h
        jne near .8
        test byte [gmode2], 10h
        je near .8
        cmp word [byte esi+SCnum], byte 6
        setl al
        mov ebx, eax
        and ebx, 0FFh
        cmp word [shotplayer], byte 6
        setl al
        and eax, 0FFh
        xor eax, ebx
        je near .8
        mov edi, dword [shotplayer-2]
        sar edi, 10h
        shl edi, 7
        cmp word [dword edi+SortCords+6], byte 0
        jge short .1
        mov eax, dword [dword edi+SortCords+4]
        sar eax, 10h
        neg eax
        jmp short .2
.1:
        mov eax, dword [dword edi+SortCords+4]
        sar eax, 10h
.2:
        cmp eax, byte 58h
        jle near .8
        mov eax, dword [shotplayer-2]
        sar eax, 10h
        shl eax, 7
        cmp word [dword eax+SortCords+6], byte 0
        setg al
        mov ebx, eax
        and ebx, 0FFh
        test byte [byte esi+pflags], 80h
        setne al
        and eax, 0FFh
        xor eax, ebx
        je short .8
        mov edi, dword [puckvy]
        mov cx, word [edi]
        test cx, cx
        jge short .3
        movsx eax, cx
        neg eax
        jmp short .4
.3:
        movsx eax, cx
.4:
        cmp eax, 2EE0h
        jg short .7
        mov edi, dword [puckvy]
        mov ax, word [edi]
        test ax, ax
        jge short .5
        cwde
        neg eax
        jmp short .6
.5:
        cwde
.6:
        cmp eax, 1770h
        jle short .8
        mov bx, word [byte esi+SPA]
        cmp bx, 119Dh
        jl short .8
        cmp bx, 121Dh
        jg short .8
.7:
        mov edx, 1
.8:
        call ChkShotStat
.9:
        and byte [byte esi+pflags], 0FEh
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jl near .13
        mov di, word [byte esi+SPA]
        cmp di, 13C5h
        jl short .10
        cmp di, 14ADh
        jle near PassLaneChk_ret5a
.10:
        mov edx, dword [puckc]
        movsx eax, byte [edx]
        shl eax, 7
        mov edi, SortCords
        add edi, eax
        xor eax, eax
        mov al, byte [byte esi+pflags]
        xor edx, edx
        mov dl, byte [byte edi+pflags]
        xor eax, edx
        test al, 40h
        je near PassLaneChk_ret5a
        cmp dword [regd0], byte 24h
        ja near PassLaneChk_ret5a
        cmp word [byte esi+position], byte 0
        je near .12
        cmp word [byte edi+position], byte 0
        je near PassLaneChk_ret5a
        xor eax, eax
        mov al, byte [byte edi+060h]
        push eax
        mov edx, dword [byte edi+044h]
        sar edx, 18h
        add edx, edx
        mov eax, dword [byte edi+tmptr]
        mov eax, dword [byte edx+eax+044h]
        sar eax, 10h
        push eax
        call imul32
        add esp, byte 8
        sar eax, 0Ch
        cwde
        mov dword [esp], eax
        xor eax, eax
        mov al, byte [byte esi+060h]
        push eax
        mov eax, dword [byte esi+044h]
        sar eax, 18h
        mov edx, dword [byte esi+06Ch]
        mov eax, dword [byte edx+eax*2+tmpde-2]
        sar eax, 10h
        push eax
        call imul32
        add esp, byte 8
        sar eax, 0Ch
        movsx edx, ax
        mov eax, dword [esp]
        add eax, byte 20h
        sub eax, edx
        mov word [regd0], ax
        test byte [byte edi+pflags], 8
        je short .11
        test byte [byte esi+pflags], 8
        jne short .11
        mov ebx, dword [regd0-2]
        sar ebx, 10h
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        shl edx, 3
        LD sbb, eax, edx
        sar eax, 3
        add eax, ebx
        mov word [regd0], ax
.11:
        mov eax, dword [regd0-2]
        sar eax, 10h
        call randomd0
        cmp ax, 2
        jg near PassLaneChk_ret5a
.12:
        xor eax, eax
        mov al, byte [byte edi+060h]
        push eax
        mov eax, dword [byte edi+044h]
        sar eax, 18h
        mov edx, dword [byte edi+tmptr]
        mov eax, dword [byte edx+eax*2+tmpde-2]
        sar eax, 10h
        push eax
        call imul32
        add esp, byte 8
        sar eax, 0Ch
        cwde
        add eax, byte 14h
        mov word [byte edi+03Eh], ax
        xor eax, eax
        mov al, byte [byte esi+060h]
        push eax
        mov edx, dword [byte esi+044h]
        sar edx, 18h
        add edx, edx
        mov eax, dword [byte esi+06Ch]
        mov eax, dword [byte edx+eax+044h]
        sar eax, 10h
        push eax
        call imul32
        add esp, byte 8
        sar eax, 0Ch
        cwde
        add eax, byte 14h
        mov word [byte esi+03Eh], ax
        mov ax, word [byte edi+SCnum]
        mov word [lastplayer], ax
        and byte [sflags], 0F3h
        jmp near .20
.13:
        cmp word [byte esi+position], byte 0
        jne short .14
        cmp dword [regd0], byte 40h
        ja near PassLaneChk_ret5a
.14:
        mov eax, dword [puckvx]
        mov ax, word [eax]
        mov word [regd0], ax
        mov eax, dword [puckvy]
        mov ax, word [eax]
        mov word [regd1], ax
        mov ebx, dword [regd0-2]
        sar ebx, 10h
        imul ebx, ebx
        mov eax, dword [regd1-2]
        sar eax, 10h
        imul eax, eax
        add ebx, eax
        mov dword [regd0], ebx
        xor eax, eax
        mov word [regd1], ax
        test byte [gmode2], 10h
        jne short .15
        mov al, byte [byte esi+060h]
        imul eax, dword 2BCh
        mov word [regd1], ax
.15:
        add word [regd1], 32C8h
        mov ebx, dword [regd1-2]
        sar ebx, 10h
        imul ebx, ebx
        mov dword [regd1], ebx
        mov cx, word [byte esi+SPA]
        cmp cx, 13C5h
        jl short .16
        cmp cx, 14ADh
        jle near .19
.16:
        mov eax, dword [regd0]
        cmp eax, dword [regd1]
        jbe short .17
        mov ax, word [byte esi+SCnum]
        cmp ax, word [passplayer]
        jne short .19
        mov eax, 2
        call randomd0
        test ax, ax
        je short .19
.17:
        mov eax, dword [puckvz]
        mov word [eax], 0
        mov eax, esi
        call puckglue
        cmp word [byte esi+position], byte 0
        jne near PassLaneChk_ret5a
        mov ebx, dword [puckz]
        cmp word [ebx], byte 8
        jle short .18
        mov word [ebx], 8
.18:
        mov ebx, dword [puckvx]
        sar word [ebx], 2
        mov ebx, dword [puckvy]
        sar word [ebx], 2
        mov byte [byte esi+063h], dl
        jmp near PassLaneChk_ret5a
.19:
        mov word [byte esi+03Eh], 8
.20:
        mov eax, 99h
        call sfx
        mov eax, esi
        call a2touchpuck
        mov eax, ebp
        call deflect
        jmp near PassLaneChk_ret5a
%endif ; C
;-----------------------------------------------------------------------------
; SetShotMode                        5786E  94G logic94.asm, medium confidence
;-----------------------------------------------------------------------------
; C: src/engine/collide/SetShotMode.c
%ifdef CBUILD
%include "c/engine/collide/SetShotMode.inc"
%else
SetShotMode:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov ebx, eax
        mov word [passdir], 8
        or byte [sflags], 8
        xor ecx, ecx
        mov word [regd0], cx
        test byte [byte ebx+pflags], 80h
        jne short .1
        mov eax, 0FFFFFF10h
        jmp short .2
.1:
        mov eax, 0F0h
.2:
        mov word [regd1], ax
        sub ax, word [byte ebx+Ypos+2]
        movsx edx, ax
        mov ax, word [regd0]
        sub ax, word [byte ebx+Xpos+2]
        cwde
        call vtoa
        mov word [regd0], ax
        mov word [passspeed], 0Fh
        movsx edx, ax
        mov eax, ebx
        call Findhittype
        test ax, ax
        je short .3
        mov edx, 491h
        jmp short .4
.3:
        mov edx, 3F9h
.4:
        mov eax, ebx
        call SetSPA
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ShotMode                           578FA  94G logic94.asm, medium confidence
;-----------------------------------------------------------------------------
; C: src/engine/collide/ShotMode.c
%ifdef CBUILD
%include "c/engine/collide/ShotMode.inc"
%else
ShotMode:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov edx, eax
        cmp word [byte eax+03Ah], byte 0Eh
        jl short .1
        call doshot
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        test byte [regd0], 8
        jne short .2
        mov cx, word [regd0]
        xor ch, ch
        and cl, 7
        mov word [regd0], cx
        mov word [passdir], cx
.2:
        mov si, word [byte edx+SPAnum]
        cmp si, byte 0Ah
        jge near .x
        mov bl, byte [regd1]
        test bl, 10h
        jne short .3
        test bl, 40h
        je short .8
.3:
        and byte [sflags], 0F7h
        or byte [byte edx+pflags], 20h
        mov ax, word [byte edx+SPA]
        cmp ax, 491h
        jb short .4
        jbe short .5
        cmp ax, 0DD3h
        jb near .x
        jbe short .6
        cmp ax, 0E2Bh
        je short .7
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.4:
        cmp ax, 3F9h
        jne short .x
        mov word [byte edx+SPA], 1265h
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.5:
        mov word [byte edx+SPA], 12DDh
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.6:
        mov word [byte edx+SPA], 1355h
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.7:
        mov word [byte edx+SPA], 138Dh
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.8:
        cmp si, byte 8
        jge short .x
        inc word [passspeed]
        cmp byte [byte edx+05Bh], 0Ah
        jae short .9
        mov bx, word [byte edx+SPAnum]
        cmp bx, byte 4
        jle short .9
        mov eax, 0Eh
        sub eax, ebx
        jmp short .10
.9:
        test byte [regd2], 20h
        je short .x
        mov eax, 0Eh
        mov cx, word [byte edx+SPAnum]
        sub eax, ecx
.10:
        mov word [byte edx+SPAnum], ax
.x:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; Findhittype                        579FF  94G logic94.asm, medium confidence
;-----------------------------------------------------------------------------
; C: src/engine/collide/Findhittype.c
%ifdef CBUILD
%include "c/engine/collide/Findhittype.inc"
%else
Findhittype:
        push dword 8
        call __CHK
        push ecx
        mov cx, word [byte eax+036h]
        sub ecx, edx
        mov edx, ecx
        xor dh, ch
        and dl, 7
        test byte [byte eax+055h], 8
        je short .1
        movsx ecx, dx
        mov eax, 1
        shl eax, cl
        test al, 0F0h
        jmp short .2
.1:
        movsx ecx, dx
        mov eax, 1
        shl eax, cl
        test al, 1Eh
.2:
        setne al
        xor ah, ah
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; deflect                                             57A3E  94G collide94.asm
;-----------------------------------------------------------------------------
; C: src/engine/collide/deflect.c
%ifdef CBUILD
%include "c/engine/collide/deflect.inc"
%else
deflect:
        push dword 8
        call __CHK
        push edx
        mov edx, eax
        mov eax, dword [puckc]
        mov byte [eax], 0FFh
        mov eax, 2000h
        call randomd0
        db 081h,0E8h,00h,010h,00h,00h           ; insn: sub eax,1000h
        mov word [byte edx+0Eh], ax
        mov eax, 2000h
        call randomd0
        db 081h,0E8h,00h,010h,00h,00h           ; insn: sub eax,1000h
        mov word [byte edx+0Ch], ax
        mov eax, 1000h
        call randomd0
        mov word [byte edx+010h], ax
        mov word [regd0], ax
        mov eax, edx
        call puckflip
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; shotdiradj                                            57A98  95G input95.asm
; 95G shotdiradj: where a computer player or a one-timer shoots. pflags bit 3
; bails out, then the goalie on that side of SortCords
;-----------------------------------------------------------------------------
shotdiradj:
        push dword 34h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        mov esi, eax
        test byte [byte eax+pflags], 8
        jne near .14
        cmp word [byte esi+06Ah], byte 6
        jge short .1
        mov eax, 6
        jmp short .2
.1:
        xor eax, eax
.2:
        shl eax, 7
        add eax, SortCords
        xor edx, edx
        jmp short .4
.3:
        cmp word [byte eax+position], byte 0
        je short .5
        inc edx
        add eax, 80h
.4:
        cmp dx, byte 6
        jl short shotdiradj.3
.5:
        cmp dx, byte 6
        jne short .6
        mov word [passdir], 8
        jmp near .14
.6:
        mov edx, dword [byte eax+0Ah]
        sar edx, 19h
        mov ebx, dword [eax]
        sar ebx, 10h
        add ebx, edx
        mov edx, dword [puckx]
        movsx edx, word [edx]
        sub ebx, edx
        movsx edx, bx
        mov dword [byte esp+08h], edx
        mov ebx, dword [byte eax+0Ch]
        sar ebx, 19h
        mov edx, dword [byte eax+Ypos]
        sar edx, 10h
        add edx, ebx
        mov eax, dword [pucky]
        movsx eax, word [eax]
        sub edx, eax
        movsx edi, dx
        push edi
        mov edx, dword [byte esp+0Ch]
        push edx
        call vecdist
        add esp, byte 8
        mov word [byte esp+0Ch], ax
        test ax, ax
        jne short .7
        mov eax, 1
        mov word [byte esp+0Ch], ax
.7:
        mov edx, 12h
        mov eax, 0E8h
        test byte [byte esi+044h], 80h
        jne short .8
        mov eax, 0FFFFFF18h
.8:
        mov ecx, dword [puckx]
        movsx ecx, word [ecx]
        movsx edx, dx
        mov dword [esp], edx
        sub edx, ecx
        mov ebx, dword [pucky]
        movsx ebx, word [ebx]
        cwde
        sub eax, ebx
        mov ebx, dword [byte esp+08h]
        imul ebx, eax
        mov dword [byte esp+04h], ebx
        imul edx, edi
        mov eax, ebx
        sub eax, edx
        mov edx, eax
        mov ebp, dword [byte esp+0Ah]
        sar ebp, 10h
        sar edx, 1Fh
        idiv ebp
        mov ebx, eax
        mov edx, dword [esp]
        neg edx
        sub edx, ecx
        imul edx, edi
        mov eax, dword [byte esp+04h]
        sub eax, edx
        mov edx, eax
        sar edx, 1Fh
        idiv ebp
        add ebx, eax
        test bx, bx
        jge short .9
        movsx eax, bx
        neg eax
        jmp short .10
.9:
        movsx eax, bx
.10:
        cmp eax, byte 2Ch
        jle short .11
        xor edi, edi
        mov word [passdir], di
        jmp short .14
.11:
        test byte [byte esi+044h], 80h
        je short .12
        neg ebx
.12:
        test bx, bx
        jl short .13
        mov word [passdir], 2
        jmp short .14
.13:
        mov word [passdir], 6
.14:
        add esp, byte 10h
        jmp near dopass_ret6
;-----------------------------------------------------------------------------
; doshot                                                57C0B  94G logic94.asm
; 93G doshot (stick is at puck so launch puck toward goal): shotdiradj, shot
; speed, sfx, assreplace
;-----------------------------------------------------------------------------
doshot:
        push dword 38h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 14h
        mov esi, eax
        call shotdiradj
        mov ax, word [byte esi+SCnum]
        mov word [shotplayer], ax
        and byte [sflags], 0F7h
        or byte [byte esi+pflags], 20h
        mov eax, dword [puckc]
        movsx ax, byte [eax]
        cmp ax, word [byte esi+SCnum]
        je short .1
        mov bx, word [byte esi+SPA]
        cmp bx, 0DD3h
        je short .1
        cmp bx, 0E2Bh
        je short .1
        mov eax, 99h
        call sfx
        jmp near .40
.1:
        or byte [gmode2], 10h
        mov di, word [byte esi+SPA]
        cmp di, 491h
        je short .2
        cmp di, 0E2Bh
        jne short .3
.2:
        mov word [byte esp+0Ch], 0AAh
        mov eax, dword [passspeed-2]
        sar eax, 10h
        mov edx, eax
        sar edx, 2
        sub eax, edx
        mov word [passspeed], ax
        jmp short .4
.3:
        mov word [byte esp+0Ch], 0AAh
.4:
        xor edx, edx
        mov dl, byte [byte esi+05Bh]
        cmp dx, byte 0Ch
        jle short .9
        cmp word [byte esi+Xpos+2], byte 0
        jge short .5
        mov eax, dword [esi]
        sar eax, 10h
        neg eax
        jmp short .6
.5:
        mov eax, dword [esi]
        sar eax, 10h
.6:
        cmp word [byte esi+Ypos+2], byte 0
        jge short .7
        mov ebx, dword [byte esi+Ypos]
        sar ebx, 10h
        neg ebx
        jmp short .8
.7:
        mov ebx, dword [byte esi+Ypos]
        sar ebx, 10h
.8:
        add eax, ebx
        cmp eax, 1F4h
        jge short .9
        add edx, byte 2
.9:
        cmp dx, byte 0Eh
        jle short .10
        inc edx
.10:
        cmp dx, byte 0Dh
        jle short .11
        inc edx
.11:
        cmp dx, byte 0Ah
        jle short .12
        inc edx
.12:
        movsx eax, dx
        push eax
        mov eax, dword [byte esi+044h]
        sar eax, 18h
        mov edx, dword [byte esi+06Ch]
        mov eax, dword [byte edx+eax*2+tmpde-2]
        sar eax, 10h
        push eax
        call imul32
        add esp, byte 8
        sar eax, 0Ch
        movsx edx, ax
        mov eax, dword [passspeed-2]
        sar eax, 10h
        add edx, byte 14h
        imul eax, edx
        mov word [passspeed], ax
        mov eax, dword [passspeed-2]
        sar eax, 10h
        imul eax, dword 5249h
        shr eax, 10h
        mov word [passspeed], ax
        cmp dword [shotongoal], byte 0
        je short .13
        call ShotLaneOpen
        mov eax, dword [shotontarget]
        mov dword [shotongoal], eax
.13:
        mov eax, dword [passdir]
        sar eax, 14h
        mov edx, 3
        sub edx, eax
        test dx, dx
        jle short .14
        mov word [byte esp+0Ch], 9Ah
.14:
        mov eax, dword [puckc]
        mov byte [eax], 0FFh
        mov word [byte esi+03Eh], 10h
        mov ax, word [byte esi+SCnum]
        mov word [lastplayer], ax
        mov edx, 0E8h
        test byte [byte esi+pflags], 80h
        jne short .15
        mov edx, 0FFFFFF18h
.15:
        mov edi, dword [passdir-2]
        sar edi, 10h
        mov ebx, dword [puckx]
        mov ax, word [nosplit edi*4+shotsets]
        mov cx, word [ebx]
        sub eax, ecx
        mov word [byte esp+08h], ax
        mov eax, dword [pucky]
        mov bx, word [eax]
        sub edx, ebx
        mov word [byte esp+010h], dx
        mov di, word [nosplit edi*4+shotsetz]
        mov eax, dword [byte esp+0Eh]
        sar eax, 10h
        push eax
        mov eax, dword [byte esp+0Ah]
        sar eax, 10h
        push eax
        call vecdist
        add esp, byte 8
        mov ecx, eax
        test ax, ax
        jne short .16
        mov ecx, 1
.16:
        test byte [gmode], 10h
        jne near .27
        xor edx, edx
        mov dl, byte [byte esi+05Ch]
        cmp dx, byte 0Eh
        jle short .17
        inc edx
.17:
        cmp dx, byte 0Dh
        jle short .18
        inc edx
.18:
        cmp cx, 0C8h
        jg short .19
        xor eax, eax
        mov al, byte [byte esi+05Ch]
        add eax, 10h
        cwde
        call randomd0
        cmp ax, 0Eh
        jg near .27
.19:
        mov ebx, dword [passdir]
        sar ebx, 14h
        movsx eax, dx
        sub ebx, eax
        movsx eax, cx
        add ebx, byte 10h
        imul eax, ebx
        and eax, 0FFFFh
        sar eax, 6
        mov ebx, eax
        cmp cx, 0FAh
        jge short .20
        sar bx, 1
.20:
        cmp bx, 0A0h
        jle short .21
        mov ebx, 0A0h
.21:
        mov eax, ebx
        add eax, ebx
        cwde
        call randomd0
        sub eax, ebx
        add word [byte esp+08h], ax
        cmp bx, byte 3Ch
        jle short .22
        mov ebx, 3Ch
.22:
        cmp word [byte esp+010h], byte 0
        jge short .23
        movsx edx, bx
        sar edx, 1
        jmp short .24
.23:
        movsx edx, bx
.24:
        mov eax, edx
        add eax, edx
        mov word [byte esp+04h], ax
        mov eax, dword [byte esp+02h]
        sar eax, 10h
        call randomd0
        sub eax, edx
        mov edx, eax
        add word [byte esp+010h], dx
        movsx ebp, bx
        mov edx, ebp
        sar edx, 1
        cmp cx, 0A0h
        jge short .25
        mov dword [esp], 3
        mov eax, ebp
        mov edx, ebp
        sar edx, 1Fh
        idiv dword [esp]
        mov edx, eax
.25:
        cmp cx, byte 50h
        jge short .26
        movsx eax, bx
        sar eax, 2
        mov edx, eax
.26:
        movsx eax, dx
        call randomd0
        add edi, eax
.27:
        mov edx, dword [passspeed-2]
        sar edx, 10h
        mov eax, edx
        shl eax, 4
        sub eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, dword [byte esp+06h]
        sar edx, 10h
        imul edx, eax
        movsx ebp, cx
        mov eax, edx
        sar edx, 1Fh
        idiv ebp
        mov ebx, eax
        mov eax, dword [puckvx]
        mov word [eax], bx
        mov edx, dword [passspeed-2]
        sar edx, 10h
        mov eax, edx
        shl eax, 4
        sub eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, dword [byte esp+0Eh]
        sar edx, 10h
        imul edx, eax
        mov eax, edx
        sar edx, 1Fh
        idiv ebp
        mov ebx, eax
        mov eax, dword [puckvy]
        mov word [eax], bx
        cmp dword [penshotlive], byte 0
        je near .37
        mov eax, dword [byte esi+Xvel-2]
        sar eax, 10h
        mov edx, dword [puckvx]
        movsx edx, word [edx]
        xor edx, eax
        test edx, edx
        jl short .32
        cmp word [byte esi+Xvel], byte 0
        jge short .28
        mov edx, eax
        neg edx
        jmp short .29
.28:
        mov edx, eax
.29:
        mov eax, dword [puckvx]
        mov bx, word [eax]
        test bx, bx
        jge short .30
        movsx eax, bx
        neg eax
        jmp short .31
.30:
        movsx eax, bx
.31:
        cmp eax, edx
        jge short .32
        mov dx, word [byte esi+Xvel]
        add edx, 1F4h
        mov eax, dword [puckvx]
        mov word [eax], dx
.32:
        mov eax, dword [byte esi+Yvel-2]
        sar eax, 10h
        mov edx, dword [puckvy]
        movsx edx, word [edx]
        xor edx, eax
        test edx, edx
        jl short .37
        cmp word [byte esi+Yvel], byte 0
        jge short .33
        mov edx, eax
        neg edx
        jmp short .34
.33:
        mov edx, eax
.34:
        mov eax, dword [puckvy]
        mov bx, word [eax]
        test bx, bx
        jge short .35
        movsx eax, bx
        neg eax
        jmp short .36
.35:
        movsx eax, bx
.36:
        cmp eax, edx
        jge short .37
        mov dx, word [byte esi+Yvel]
        add edx, 1F4h
        mov eax, dword [puckvy]
        mov word [eax], dx
.37:
        test di, di
        je short .39
        mov ebp, dword [passspeed-2]
        sar ebp, 10h
        mov eax, ebp
        shl eax, 4
        add eax, ebp
        shl eax, 2
        movsx edx, di
        imul eax, edx
        movsx ecx, cx
        xor edx, edx
        div ecx
        mov edi, eax
        imul eax, ecx, dword 0B33h
        xor edx, edx
        div ebp
        add edi, eax
        cmp di, 1800h
        jbe short .38
        mov edi, 1800h
.38:
        mov eax, dword [puckvz]
        mov word [eax], di
.39:
        mov eax, dword [byte esp+0Ah]
        sar eax, 10h
        call sfx
        cmp dword [penshotlive], byte 0
        je short .40
        mov edx, 11h
        mov eax, esi
        call assreplace
.40:
        add esp, byte 14h
        jmp near dopass_ret6
;-----------------------------------------------------------------------------
; newcheck                       58084  93G hockey93_03.asm, medium confidence
; 93G newcheck: random check sound (sfx, randomd0); called from checkcx and
; FallDown
;-----------------------------------------------------------------------------
; C: src/engine/collide/newcheck.c
%ifdef CBUILD
%include "c/engine/collide/newcheck.inc"
%else
newcheck:
        push dword 8
        call __CHK
        push edx
        mov edx, eax
        cmp ax, 2
        jne short .1
        mov eax, 0B1h
        call sfx
.1:
        test dx, dx
        je short .2
        cmp word [lastimpact], byte 20h
        jle short .2
        mov eax, 2
        call randomd0
        test ax, ax
        jne short .2
        mov edx, 93h
        jmp short .4
.2:
        cmp word [ltack], byte 0
        sete dl
        xor dh, dh
        mov word [ltack], dx
        test dx, dx
        je short .3
        mov edx, 0B0h
        jmp short .4
.3:
        mov edx, 0B2h
.4:
        movsx eax, dx
        call sfx
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; checkcoll                                           580F5  94G collide94.asm
; eax = object: wall collision (checkwallcoll) at the hot spot and the stick end,
; then player collisions (checkplcoll). Called from updateplayers.
;-----------------------------------------------------------------------------
; C: src/engine/collide/checkcoll.c
%ifdef CBUILD
%include "c/engine/collide/checkcoll.inc"
%else
checkcoll:
        push dword 14h
        call __CHK
        push ecx
        push esi
        push edi
        sub esp, byte 4
        mov ecx, eax
        mov esi, edx
        mov edi, ebx
        xor edx, edx
        mov dword [nethit], edx
        xor ah, ah
        mov byte [collflag], ah
        test byte [sflags], 80h
        je short .1
        mov edi, esi
        mov esi, ebx
.1:
        test byte [byte ecx+pflags], 4
        jne near .3
        mov ax, word [byte ecx+066h]
        mov word [wcradiusx], ax
        mov ax, word [byte ecx+068h]
        mov word [wcradiusy], ax
        mov ebx, dword [byte ecx+Ypos]
        sar ebx, 10h
        mov edx, dword [ecx]
        sar edx, 10h
        mov eax, ecx
        call checkwallcoll
        mov edx, dword [byte ecx+Wallcos-2]
        sar edx, 10h
        mov eax, dword [byte ecx+Wallsin-2]
        sar eax, 10h
        or eax, edx
        jne short .2
        cmp word [byte ecx+SCnum], byte 0Bh
        jg short .2
        mov eax, ecx
        call GetHot
        mov ebx, 1
        mov word [wcradiusx], bx
        mov word [wcradiusy], bx
        mov ax, word [byte ecx+Ypos+2]
        add ax, word [regd1]
        movsx ebx, ax
        mov ax, word [byte ecx+Xpos+2]
        add ax, word [regd0]
        movsx edx, ax
        mov eax, ecx
        call checkwallcoll
.2:
        movsx ebx, di
        movsx edx, si
        mov eax, ecx
        call checkplcoll
.3:
        cmp byte [collflag], 0
        je short .5
        mov bx, word [byte ecx+SPA]
        cmp bx, 0F0Fh
        jl short .4
        cmp bx, 1055h
        jle near .x
.4:
        mov ax, word [byte ecx+OldXpos+2]
        mov word [byte ecx+Xpos+2], ax
        mov ax, word [byte ecx+07Ah]
        mov word [byte ecx+Ypos+2], ax
        jmp near .x
.5:
        mov ax, word [byte ecx+SCnum]
        mov word [esp], ax
        mov edx, dword [byte esp-02h]
        sar edx, 10h
        mov dx, word [nosplit edx*2+OOlistpos]
.6:
        cmp dx, byte 10h
        je short .7
        movsx eax, dx
        movsx bx, byte [dword eax+OOlist+1]
        mov ecx, dword [dword eax+OOlist-2]
        sar ecx, 18h
        cmp di, word [nosplit ecx*2+Ylist]
        jle short .7
        mov ecx, dword [byte esp-02h]
        sar ecx, 10h
        movsx esi, bx
        mov byte [dword eax+OOlist], bl
        mov bl, byte [esp]
        mov byte [dword eax+OOlist+1], bl
        inc word [nosplit ecx*2+OOlistpos]
        dec word [nosplit esi*2+OOlistpos]
        inc edx
        jmp short checkcoll.6
.7:
        mov edx, dword [byte esp-02h]
        sar edx, 10h
        mov dx, word [nosplit edx*2+OOlistpos]
        test dx, dx
        je short .9
.8:
        movsx eax, dx
        movsx bx, byte [dword eax+OOlist-1]
        mov ecx, dword [dword eax+OOlist-4]
        sar ecx, 18h
        cmp di, word [nosplit ecx*2+Ylist]
        jge short .9
        mov ecx, dword [byte esp-02h]
        sar ecx, 10h
        movsx esi, bx
        mov byte [dword eax+OOlist], bl
        mov bl, byte [esp]
        mov byte [dword eax+OOlist-1], bl
        dec word [nosplit ecx*2+OOlistpos]
        inc word [nosplit esi*2+OOlistpos]
        dec dx
        jne short checkcoll.8
.9:
        mov eax, dword [byte esp-02h]
        sar eax, 10h
        mov word [nosplit eax*2+Ylist], di
.x:
        add esp, byte 4
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; checkwallcoll                                       582C9  94G collide94.asm
; 93G checkwallcoll: vecdist against the corner radius, wallcollb, checkgoal
;-----------------------------------------------------------------------------
checkwallcoll:
        push dword 24h
        call __CHK
        push ecx
        push esi
        push edi
        sub esp, byte 0Ch
        mov esi, eax
        mov word [byte esp+08h], dx
        mov edi, ebx
        mov eax, 0A0h
        mov dx, word [wcradiusx]
        sub eax, edx
        mov dword [byte esp+04h], eax
        mov eax, 108h
        mov bx, word [wcradiusy]
        sub eax, ebx
        mov dword [esp], eax
        mov eax, 40h
        mov ecx, dword [byte esp+04h]
        sub eax, ecx
        mov word [regd4], ax
        mov eax, 40h
        mov edx, dword [esp]
        sub eax, edx
        mov word [regd5], ax
        cmp di, ax
        jle short .1
        mov edx, eax
        neg edx
        mov word [regd5], dx
        cmp di, dx
        jl near .4
.1:
        mov edx, dword [byte esp+08h]
        mov cx, word [regd4]
        cmp dx, cx
        jl short .2
        mov edx, ecx
        neg edx
        mov word [regd4], dx
        mov edx, dword [byte esp+08h]
        cmp dx, word [regd4]
        jle near .3
.2:
        mov ax, word [regd4]
        mov edx, dword [byte esp+08h]
        sub edx, eax
        mov word [regd1], dx
        mov ax, word [regd5]
        mov edx, edi
        sub edx, eax
        mov word [regd0], dx
        mov eax, dword [regd1-2]
        sar eax, 10h
        push eax
        mov eax, dword [regd0-2]
        sar eax, 10h
        push eax
        call vecdist
        add esp, byte 8
        mov word [regd3], ax
        neg word [regd1]
        cmp ax, 40h
        jl short .4
        mov edx, dword [regd0-2]
        sar edx, 10h
        shl edx, 8
        movsx ebx, ax
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov word [regd0], ax
        mov edx, dword [regd1-2]
        sar edx, 10h
        shl edx, 8
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov word [regd1], ax
        mov eax, esi
        call wallcollb
        jmp short .4
.3:
        movsx ecx, di
        mov ebx, dword [byte esp+06h]
        sar ebx, 10h
        cmp ax, word [regd5]
        sete al
        and eax, 0FFh
        add eax, byte 0Ch
        shl eax, 7
        mov edx, SortCords
        add edx, eax
        mov eax, esi
        call checkgoal
.4:
        mov ax, word [byte esi+032h]
        mov cx, word [byte esi+030h]
        or ax, cx
        mov word [regd0], ax
        jne short .x
        mov word [regd0], 100h
        mov word [regd1], ax
        mov ecx, dword [esp]
        cmp di, cx
        jge short .5
        mov eax, ecx
        neg eax
        mov dword [esp], eax
        mov edx, 0FFFFFF00h
        mov word [regd0], dx
        cmp di, ax
        jle short .5
        xor ecx, ecx
        mov word [regd0], cx
        mov word [regd1], dx
        mov eax, dword [byte esp+08h]
        mov edx, dword [byte esp+04h]
        cmp ax, dx
        jge short .5
        mov ebx, edx
        neg ebx
        mov dword [byte esp+04h], ebx
        mov word [regd1], 100h
        cmp ax, bx
        jg short .x
.5:
        mov eax, esi
        call wallcollb
.x:
        add esp, byte 0Ch
        pop edi
        pop esi
        pop ecx
        ret
;-----------------------------------------------------------------------------
; checkgoal                                           584AA  94G collide94.asm
; 93G checkgoal (coll with goal/net): checkgoalp for players, Goal for the
; puck, puckflip / sfx on the frame
;-----------------------------------------------------------------------------
checkgoal:
        push dword 10h
        call __CHK
        push esi
        push edi
        push ebp
        mov esi, eax
        mov edi, edx
        mov eax, ecx
        cmp word [byte esi+0Ah], byte 0Dh
        jg near .x
        cmp word [byte esi+SCnum], byte 0Eh
        je short .1
        movsx ecx, ax
        movsx ebx, bx
        mov edx, edi
        mov eax, esi
        call checkgoalp
        pop ebp
        pop edi
        pop esi
        ret
.1:
        sub bx, word [byte edi+02h]
        mov dx, word [wcradiusx]
        add edx, byte 10h
        mov word [regd4], dx
        cmp bx, dx
        jg near .x
        neg edx
        mov word [regd4], dx
        cmp bx, dx
        jl near .x
        sub ax, word [byte edi+06h]
        mov dx, word [wcradiusy]
        add edx, byte 2
        mov word [regd5], dx
        cmp ax, dx
        jg near .x
        neg edx
        mov word [regd5], dx
        cmp ax, dx
        jl near .x
        mov dx, word [byte esi+07Eh]
        cmp dx, byte 0Dh
        jl short .2
        mov word [byte esi+0Ah], dx
        mov ax, word [byte esi+010h]
        test ax, ax
        jge near .x
        mov edx, eax
        neg edx
        mov ebx, edx
        sar bx, 1
        mov word [byte esi+010h], bx
        pop ebp
        pop edi
        pop esi
        ret
.2:
        mov byte [collflag], 0FFh
        and byte [byte esi+pflags], 7Fh
        mov edx, dword [puckc]
        mov cl, byte [edx]
        test cl, cl
        jl short .4
        movsx ecx, cl
        shl ecx, 7
        add ecx, SortCords
        mov byte [edx], 0FFh
        mov word [byte ecx+03Eh], 8
        mov ebp, dword [pucky]
        mov dx, word [byte ebp+00h]
        mov word [regd1], dx
        test byte [byte ecx+044h], 80h
        jne short .3
        neg word [regd1]
.3:
        cmp word [regd1], byte 0
        jge short .4
        or byte [byte esi+pflags], 80h
.4:
        mov word [regd0], 0FF00h
        mov edx, dword [byte esi+Ypos]
        sub edx, dword [byte esi+078h]
        sar edx, 8
        mov dword [regd1], edx
        test edx, edx
        je near .10
        jle short .5
        mov word [regd0], 100h
        neg word [regd5]
.5:
        add word [regd5], ax
        mov edx, dword [esi]
        sub edx, dword [byte esi+OldXpos]
        sar edx, 8
        mov dword [regd3], edx
        mov ecx, dword [regd5-2]
        sar ecx, 10h
        mov edx, dword [regd3-2]
        sar edx, 10h
        imul edx, ecx
        mov ecx, dword [regd1-2]
        sar ecx, 10h
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov dword [regd5], eax
        cmp eax, 10000h
        jae near .10
        sub bx, word [regd5]
        mov ax, word [regd4]
        cmp bx, ax
        jl near .10
        mov edx, eax
        neg edx
        mov word [regd4], dx
        cmp bx, dx
        jg near .10
        xor ecx, ecx
        mov word [regd1], cx
        mov ax, word [byte esi+Ypos+2]
        mov dx, word [regd0]
        xor eax, edx
        mov word [regd3], ax
        test ax, ax
        jl near .11
        mov eax, edx
        neg eax
        mov word [regd0], ax
        test byte [byte esi+pflags], 80h
        jne near .11
        cmp word [byte esi+0Ah], byte 0Dh
        je short .6
        mov cx, word [regd4]
        dec ecx
        mov word [regd4], cx
        cmp bx, cx
        jg short .6
        mov edx, ecx
        neg edx
        mov word [regd4], dx
        cmp bx, dx
        jl short .6
        mov eax, edi
        call Goal
        pop ebp
        pop edi
        pop esi
        ret
.6:
        and byte [gmode2], 0EFh
        test byte [gmode], 1
        jne short .8
        mov di, word [crowdlevel]
        cmp di, 4B0h
        jg short .7
        mov eax, edi
        add eax, 1F4h
        mov word [crowdlevel], ax
        cmp ax, 4B0h
        jle short .7
        mov word [crowdlevel], 4B0h
.7:
        add word [CwdExciteLvl], byte 28h
.8:
        mov eax, 0ACh
        call sfx
        mov eax, 1000h
        call randomd0
        mov word [regd0], ax
        cmp word [byte esi+Ypos+2], byte 0
        jl short .9
        neg eax
        mov word [regd0], ax
.9:
        mov ax, word [regd0]
        mov word [byte esi+Yvel], ax
        mov eax, 2000h
        call randomd0
        db 081h,0E8h,00h,010h,00h,00h           ; insn: sub eax,1000h
        mov word [byte esi+Xvel], ax
        mov eax, 2000h
        call randomd0
        db 081h,0E8h,00h,010h,00h,00h           ; insn: sub eax,1000h
        mov word [byte esi+010h], ax
        mov eax, esi
        call puckflip
        call EndPenaltyShot
        xor edx, edx
        mov dword [onetimerflag], edx
        mov dword [shotongoal], edx
        pop ebp
        pop edi
        pop esi
        ret
.10:
        xor edi, edi
        mov word [regd0], di
        mov word [regd1], 100h
        mov bx, word [byte esi+Xpos+2]
        sub bx, word [byte esi+OldXpos+2]
        test bx, bx
        jl short .11
        mov word [regd1], 0FF00h
.11:
        mov dword [nethit], 1
        mov eax, esi
        call wallcoll
.x:
        pop ebp
        pop edi
        pop esi
        ret
;-----------------------------------------------------------------------------
; wallcoll                                            587D3  94G collide94.asm
; 93G wallcoll (bounce off a wall with cos/sin): randomd0, puckflip, sfx;
; called from checkgoalp, checkgoal and wallcollb
;-----------------------------------------------------------------------------
wallcoll:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov ebx, eax
        mov ax, word [regd0]
        mov word [byte ebx+Wallcos], ax
        mov ax, word [regd1]
        mov word [byte ebx+Wallsin], ax
        mov eax, dword [byte ebx+Yvel-2]
        sar eax, 10h
        mov edx, dword [regd0-2]
        sar edx, 10h
        mov esi, edx
        imul esi, eax
        mov ecx, dword [byte ebx+Xvel-2]
        sar ecx, 10h
        mov eax, dword [regd1-2]
        sar eax, 10h
        imul ecx, eax
        sub esi, ecx
        sar esi, 8
        movsx ecx, si
        neg ecx
        mov word [regd2], cx
        mov ecx, dword [byte ebx+Xvel-2]
        sar ecx, 10h
        imul ecx, edx
        mov edx, dword [byte ebx+Yvel-2]
        sar edx, 10h
        imul eax, edx
        add eax, ecx
        sar eax, 8
        mov word [regd3], ax
        cmp word [byte ebx+SCnum], byte 0Eh
        jne near .14
        and byte [gmode2], 0EFh
        mov word [passplayer], 0FFFFh
        mov di, word [regd2]
        test di, di
        jl short .1
        xor ebx, ebx
        mov dword [nethit], ebx
        jmp near dopass_ret6
.1:
        mov eax, edi
        sar ax, 2
        mov word [regd2], ax
        mov eax, dword [regd2-2]
        sar eax, 10h
        cmp eax, 0FFFFFC00h
        jg near .9
        mov eax, 800h
        call randomd0
        neg eax
        mov word [byte ebx+010h], ax
        mov eax, ebx
        call puckflip
        cmp dword [nethit], byte 0
        jne near .9
        mov eax, dword [regd2-2]
        sar eax, 1Ah
        add eax, byte 4
        test ax, ax
        jge short .2
        xor eax, eax
.2:
        cmp word [byte ebx+0Ah], byte 0Ah
        ja short .5
        mov edx, dword [puckc]
        cmp byte [edx], 0
        jge near .9
        movsx edx, ax
        mov ecx, 3
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov eax, edx
        cmp dx, byte 2
        jne short .3
        mov eax, 95h
        jmp short .8
.3:
        cmp dx, byte 1
        jne short .4
        mov eax, 7Bh
        jmp short .8
.4:
        mov eax, 0ADh
        jmp short .8
.5:
        mov eax, 3
        call randomd0
        test ax, ax
        jne short .6
        mov eax, 0AFh
        jmp short .8
.6:
        cmp ax, 1
        jne short .7
        mov eax, 0A5h
        jmp short .8
.7:
        mov eax, 0A7h
.8:
        cwde
        call sfx
.9:
        mov eax, dword [regd3_m2]
        sar eax, 16h
        mov cx, word [regd3]
        sub ecx, eax
        mov word [regd3], cx
        sar ax, 1
        mov esi, ecx
        sub esi, eax
        mov word [regd3], si
        mov ecx, dword [regd0-2]
        sar ecx, 10h
        mov edx, dword [regd3-2]
        sar edx, 10h
        imul ecx, edx
        mov edx, dword [regd1-2]
        sar edx, 10h
        mov eax, dword [regd2-2]
        sar eax, 10h
        imul eax, edx
        sub ecx, eax
        sar ecx, 8
        mov word [byte ebx+Xvel], cx
        mov eax, dword [regd1-2]
        sar eax, 10h
        mov edx, dword [regd3-2]
        sar edx, 10h
        imul edx, eax
        mov eax, dword [regd0-2]
        sar eax, 10h
        mov ecx, dword [regd2-2]
        sar ecx, 10h
        imul eax, ecx
        add edx, eax
        sar edx, 8
        mov word [byte ebx+Yvel], dx
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jl short .12
        mov eax, dword [pucky]
        mov di, word [eax]
        test di, di
        jge short .10
        movsx eax, di
        neg eax
        jmp short .11
.10:
        movsx eax, di
.11:
        cmp eax, 0E8h
        jle short .13
.12:
        call EndPenaltyShot
.13:
        xor ebp, ebp
        mov dword [onetimerflag], ebp
        mov dword [shotongoal], ebp
        jmp near .25
.14:
        cmp word [regd2], 3E8h
        jle short .15
        xor esi, esi
        mov dword [nethit], esi
        jmp near dopass_ret6
.15:
        mov eax, dword [regd2-2]
        sar eax, 10h
        cmp eax, 0FFFFF000h
        jg short .16
        cmp word [byte ebx+018h], byte 0Ah
        jl short .16
        cmp dword [nethit], byte 0
        jne short .16
        mov eax, 0B1h
        call sfx
.16:
        sar word [regd2], 2
        mov eax, dword [regd2-2]
        sar eax, 10h
        cmp eax, 0FFFFFC7Ch
        jl short .17
        mov word [regd2], 0FC18h
.17:
        mov ecx, dword [regd0-2]
        sar ecx, 10h
        mov eax, dword [regd3-2]
        sar eax, 10h
        imul ecx, eax
        mov edx, dword [regd1-2]
        sar edx, 10h
        mov eax, dword [regd2-2]
        sar eax, 10h
        imul eax, edx
        sub ecx, eax
        mov eax, ecx
        sar eax, 8
        mov word [byte ebx+Xvel], ax
        mov ecx, dword [regd1-2]
        sar ecx, 10h
        mov eax, dword [regd3-2]
        sar eax, 10h
        imul ecx, eax
        mov edx, dword [regd0-2]
        sar edx, 10h
        mov eax, dword [regd2-2]
        sar eax, 10h
        imul eax, edx
        add eax, ecx
        sar eax, 8
        mov word [byte ebx+Yvel], ax
        cmp dword [nethit], byte 0
        je near .25
        mov eax, dword [byte ebx+OldXpos]
        sar eax, 10h
        cmp eax, byte 0FFFFFFE8h
        jg short .18
        cmp word [byte ebx+Xvel], byte 0
        jg short .19
.18:
        cmp word [byte ebx+OldXpos+2], byte 18h
        jl short .20
        cmp word [byte ebx+Xvel], byte 0
        jge short .20
.19:
        mov word [byte ebx+Xvel], 0
        mov ax, word [byte ebx+OldXpos+2]
        mov word [byte ebx+Xpos+2], ax
.20:
        cmp word [byte ebx+07Ah], byte 0
        jge short .21
        mov eax, 0FFFFFF14h
        jmp short .22
.21:
        mov eax, 0ECh
.22:
        mov ecx, dword [byte ebx+078h]
        sar ecx, 10h
        movsx edx, ax
        add edx, byte 0Ah
        cmp ecx, edx
        jle short .23
        cmp word [byte ebx+Yvel], byte 0
        jl short .24
.23:
        mov edx, dword [byte ebx+078h]
        sar edx, 10h
        cwde
        sub eax, byte 6
        cmp edx, eax
        jge short .25
        cmp word [byte ebx+Yvel], byte 0
        jle short .25
.24:
        mov word [byte ebx+Yvel], 0
        mov ax, word [byte ebx+07Ah]
        mov word [byte ebx+Ypos+2], ax
.25:
        xor edx, edx
        mov dword [nethit], edx
        cmp word [byte ebx+010h], byte 0
        jle near dopass_ret6
        mov word [byte ebx+010h], 0
        jmp near dopass_ret6
;-----------------------------------------------------------------------------
; wallcollb                        58B7F  94G collide94.asm, medium confidence
;-----------------------------------------------------------------------------
; C: src/engine/collide/wallcollb.c
%ifdef CBUILD
%include "c/engine/collide/wallcollb.inc"
%else
wallcollb:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push edi
        mov ebx, eax
        cmp word [byte eax+SCnum], byte 0Eh
        je short .2
.1:
        call wallcoll
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.2:
        mov cx, word [byte eax+0Ah]
        cmp cx, byte 1Dh
        jg near .12
        cmp cx, byte 12h
        jbe short wallcollb.1
        cmp word [byte eax+Ypos+2], 0F8h
        jl near .12
        cmp word [byte eax+Xpos+2], byte 0
        jge short .3
        mov eax, dword [ebx]
        sar eax, 10h
        neg eax
        jmp short .4
.3:
        mov eax, dword [ebx]
        sar eax, 10h
.4:
        cmp eax, byte 28h
        jl short .7
        cmp word [byte ebx+Xpos+2], byte 0
        jge short .5
        mov eax, dword [ebx]
        sar eax, 10h
        neg eax
        jmp short .6
.5:
        mov eax, dword [ebx]
        sar eax, 10h
.6:
        cmp eax, byte 38h
        jg short .7
        mov cx, word [byte ebx+Yvel]
        cmp cx, 0FA0h
        jl short .7
        cmp word [lty], byte 26h
        jge short .8
.7:
        mov eax, ebx
        jmp short wallcollb.1
.8:
        mov edi, ecx
        sar di, 1
        mov word [byte ebx+Yvel], di
        lea eax, [dword ebx+080h]
        mov edx, 821h
        call SetSPA
        cmp word [byte ebx+Xpos+2], byte 0
        jge short .9
        mov eax, 0FFFFFFC0h
        jmp short .10
.9:
        mov eax, 3Fh
.10:
        mov word [dword ebx+082h], ax
        mov word [dword ebx+086h], 10Bh
        mov eax, 0AEh
        call sfx
        mov dx, word [crowdlevel]
        cmp dx, 5DCh
        jg short .11
        mov ecx, edx
        add ecx, 4B0h
        mov word [crowdlevel], cx
        cmp cx, 5DCh
        jle short .11
        mov word [crowdlevel], 5DCh
.11:
        add word [CwdExciteLvl], byte 0Fh
.12:
        or byte [sflags], 40h
        or byte [byte ebx+pflags], 4
        cmp word [byte ebx+Ypos+2], byte 0
        jge short .13
        or byte [byte ebx+055h], 80h
.13:
        mov word [dword ebx+092h], 0FFFFh
        test byte [gmode], 1
        jne short .14
        mov eax, dword [lasttouch-2]
        sar eax, 10h
        shl eax, 7
        add eax, SortCords
        mov edx, 3
        call AddPenalty2
.14:
        call EndPenaltyShot
        xor edx, edx
        mov dword [onetimerflag], edx
        mov dword [shotongoal], edx
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; checkplcoll                      58CE2  94G collide94.asm, medium confidence
;-----------------------------------------------------------------------------
checkplcoll:
        push dword 18h
        call __CHK
        push ecx
        push esi
        push edi
        sub esp, byte 8
        mov edi, eax
        mov word [esp], dx
        mov dword [byte esp+04h], ebx
        test byte [byte eax+045h], 20h
        jne near .x
        mov dx, word [byte edi+06Ah]
        cmp dx, byte 0Bh
        jle short .1
        cmp dx, byte 10h
        jne near .x
.1:
        mov esi, dword [byte edi+068h]
        sar esi, 10h
        mov si, word [nosplit esi*2+OOlistpos]
.2:
        cmp si, byte 10h
        je short .3
        movsx eax, si
        movsx dx, byte [dword eax+OOlist+1]
        mov eax, dword [dword eax+OOlist-2]
        sar eax, 18h
        mov ax, word [nosplit eax*2+Ylist]
        sub eax, dword [byte esp+04h]
        cmp ax, 10h
        jg short .3
        movsx ecx, dx
        movsx ebx, ax
        mov edx, dword [byte esp-02h]
        sar edx, 10h
        mov eax, edi
        call checkcx
        inc esi
        jmp short checkplcoll.2
.3:
        mov esi, dword [byte edi+068h]
        sar esi, 10h
        mov si, word [nosplit esi*2+OOlistpos]
        test si, si
        je short .x
.4:
        movsx eax, si
        movsx dx, byte [dword eax+OOlist-1]
        mov eax, dword [dword eax+OOlist-4]
        sar eax, 18h
        mov ebx, dword [byte esp+04h]
        mov cx, word [nosplit eax*2+Ylist]
        mov eax, ebx
        sub eax, ecx
        cmp ax, 10h
        jg short .x
        movsx ecx, dx
        movsx ebx, ax
        mov edx, dword [byte esp-02h]
        sar edx, 10h
        mov eax, edi
        call checkcx
        dec si
        jne short checkplcoll.4
.x:
        add esp, byte 8
        pop edi
        pop esi
        pop ecx
        ret
;-----------------------------------------------------------------------------
; checkcx                                             58DC7  94G collide94.asm
; Possible collision with one OOlist neighbour: x range and distance, impact,
; newcheck sound, checkint (interference), checkcheck (contact events).
;-----------------------------------------------------------------------------
checkcx:
        push dword 20h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        mov esi, eax
        mov edi, ebx
        movsx eax, cx
        shl eax, 7
        mov ecx, SortCords
        add ecx, eax
        test byte [byte ecx+pflags], 4
        jne near .x
        test byte [byte ecx+pflags2], 20h
        jne near .x
        mov bx, word [byte ecx+SCnum]
        cmp bx, byte 0Bh
        jle short .1
        cmp bx, byte 10h
        jne near .x
.1:
        mov ax, word [byte ecx+Xpos+2]
        mov word [byte esp+0Ch], ax
        test byte [sflags], 80h
        je short .2
        mov ax, word [byte ecx+Ypos+2]
        mov word [byte esp+0Ch], ax
.2:
        mov ebx, dword [byte esp+0Ch]
        sub ebx, edx
        mov word [byte esp+0Ch], bx
        test bx, bx
        jge short .3
        mov eax, dword [byte esp+0Ah]
        sar eax, 10h
        neg eax
        jmp short .4
.3:
        mov eax, dword [byte esp+0Ah]
        sar eax, 10h
.4:
        cmp eax, byte 10h
        jg near .x
        mov eax, dword [byte esp+0Ah]
        sar eax, 10h
        imul eax, eax
        movsx edx, di
        imul edx, edx
        add eax, edx
        mov dword [regd0], eax
        cmp eax, 100h
        jg near .x
        mov dx, word [byte esi+Xvel]
        mov bx, word [byte ecx+Xvel]
        sub edx, ebx
        mov word [byte esp+04h], dx
        mov dx, word [byte esi+Yvel]
        mov di, word [byte ecx+Yvel]
        sub edx, edi
        mov word [byte esp+08h], dx
        mov dx, word [byte ecx+Xpos+2]
        mov ax, word [byte esi+Xpos+2]
        sub edx, eax
        mov word [byte esp+0Ch], dx
        mov di, word [byte ecx+Ypos+2]
        sub di, word [byte esi+Ypos+2]
        movsx ebx, di
        mov eax, dword [byte esp+06h]
        sar eax, 10h
        imul ebx, eax
        mov edx, dword [byte esp+0Ah]
        sar edx, 10h
        mov eax, dword [byte esp+02h]
        sar eax, 10h
        imul eax, edx
        add ebx, eax
        mov dword [regd1], ebx
        test ebx, ebx
        jl near .x
        mov ebp, ebx
        sar ebp, 4
        mov dword [regd1], ebp
        cmp word [byte esi+SCnum], byte 10h
        je short .5
        cmp word [byte ecx+SCnum], byte 10h
        je short .5
        xor edx, edx
        mov dl, byte [byte esi+pflags]
        xor eax, eax
        mov al, byte [byte ecx+pflags]
        xor eax, edx
        test al, 40h
        je near .11
.5:
        mov eax, dword [regd1_b1-3]
        sar eax, 18h
        mov word [regd4], ax
        cmp ax, 5
        jg short .6
        mov dword [regd4], 5
.6:
        mov ax, word [regd4]
        mov word [lastimpact], ax
        add word [byte esi+impact], ax
        mov ax, word [regd4]
        add word [byte ecx+impact], ax
        test byte [byte ecx+pflags2], 1
        jne short .7
        mov ax, word [byte esi+SCnum]
        mov word [byte ecx+impactp], ax
.7:
        test byte [byte esi+pflags2], 1
        jne short .8
        mov ax, word [byte ecx+SCnum]
        mov word [byte esi+impactp], ax
.8:
        cmp word [regd4], byte 14h
        jl short .10
        mov edx, dword [puckc]
        movsx ax, byte [edx]
        cmp ax, word [byte esi+SCnum]
        je short .9
        cmp ax, word [byte ecx+SCnum]
        jne short .10
.9:
        xor eax, eax
        call newcheck
.10:
        mov edx, ecx
        mov eax, esi
        call checkint
        mov ebx, dword [regd4-2]
        sar ebx, 10h
        mov edx, ecx
        mov eax, esi
        call checkcheck
.11:
        mov ax, word [regd1]
        mov word [regd4], ax
        cmp byte [collflag], 0
        jl near .x
        movsx ebx, di
        mov eax, dword [byte esp+02h]
        sar eax, 10h
        mov edx, ebx
        imul edx, eax
        mov edi, dword [byte esp+0Ah]
        sar edi, 10h
        mov eax, dword [byte esp+06h]
        sar eax, 10h
        imul eax, edi
        sub edx, eax
        mov dword [regd0], edx
        mov eax, edx
        sar eax, 4
        mov word [regd5], ax
        xor eax, eax
        mov al, byte [byte esi+weight]
        add eax, 8Ch
        mov word [regd0], ax
        xor eax, eax
        mov al, byte [byte ecx+weight]
        add eax, 8Ch
        mov word [regd1], ax
        xor eax, eax
        mov word [word_E03A0], ax
        mov ax, word [regd0]
        add word [regd1], ax
        mov eax, dword [regd4-2]
        sar eax, 10h
        mov edx, dword [regd0-2]
        sar edx, 10h
        imul edx, eax
        mov ebp, dword [regd1-2]
        sar ebp, 10h
        mov eax, edx
        sar edx, 1Fh
        idiv ebp
        mov dword [regd0], eax
        mov dword [regd1], eax
        mov edx, dword [regd5-2]
        sar edx, 10h
        imul edx, ebx
        imul eax, edi
        add eax, edx
        sar eax, 4
        mov dword [esp], eax
        mov dx, word [byte ecx+Xvel]
        mov eax, dword [esp]
        add edx, eax
        mov word [byte esi+Xvel], dx
        mov eax, dword [regd5-2]
        sar eax, 10h
        imul eax, edi
        mov edx, dword [regd0]
        imul edx, ebx
        sub edx, eax
        sar edx, 4
        mov dword [esp], edx
        mov dx, word [byte ecx+Yvel]
        mov eax, dword [esp]
        add edx, eax
        mov word [byte esi+Yvel], dx
        imul edi, dword [regd1]
        sar edi, 4
        add word [byte ecx+Xvel], di
        imul ebx, dword [regd1]
        sar ebx, 4
        add word [byte ecx+Yvel], bx
        mov byte [collflag], 0FFh
        test byte [gmode], 1
        jne near .x
        xor edx, edx
        mov dl, byte [byte esi+pflags]
        xor eax, eax
        mov al, byte [byte ecx+pflags]
        xor eax, edx
        test al, 40h
        jne near .x
        mov dx, word [byte ecx+Ypos+2]
        sub dx, word [byte esi+Ypos+2]
        movsx ebx, dx
        mov dx, word [byte ecx+Xpos+2]
        sub dx, word [byte esi+Xpos+2]
        movsx eax, dx
        mov edx, ebx
        call vtoa
        mov ebx, eax
        mov word [byte esp+0Ch], ax
        test byte [byte esi+pflags], 8
        jne short .13
        mov dx, word [byte esi+temp4]
        sub dx, word [byte esi+Ypos+2]
        movsx edi, dx
        mov dx, word [byte esi+temp3]
        sub dx, word [byte esi+Xpos+2]
        movsx eax, dx
        mov edx, edi
        call vtoa
        cmp ax, bx
        je short .12
        cmp word [byte esi+Xvel], byte 0
        jne short .13
        cmp word [byte esi+Yvel], byte 0
        jne short .13
        cmp bx, word [byte esi+facedir]
        jne short .13
.12:
        mov al, byte [byte esp+0Ch]
        add al, 2
        and al, 7
        mov byte [byte esi+028h], al
        mov edx, dword [byte esi+025h]
        sar edx, 18h
        mov eax, esi
        call doplayeracc
.13:
        test byte [byte ecx+pflags], 8
        jne short .x
        mov eax, dword [byte esp+0Ch]
        add eax, 4
        xor ah, ah
        and al, 7
        mov word [byte esp+0Ch], ax
        mov dx, word [byte ecx+temp4]
        sub dx, word [byte ecx+Ypos+2]
        movsx ebx, dx
        mov dx, word [byte ecx+temp3]
        sub dx, word [byte ecx+Xpos+2]
        movsx eax, dx
        mov edx, ebx
        call vtoa
        mov edx, dword [byte esp+0Ch]
        cmp ax, dx
        je short .14
        cmp word [byte esi+Xvel], byte 0
        jne short .x
        cmp word [byte esi+Yvel], byte 0
        jne short .x
        cmp dx, word [byte ecx+facedir]
        jne short .x
.14:
        mov al, byte [byte esp+0Ch]
        add al, 2
        and al, 7
        mov byte [byte ecx+028h], al
        mov edx, dword [byte ecx+025h]
        sar edx, 18h
        mov eax, ecx
        call doplayeracc
.x:
        add esp, byte 10h
        pop ebp
        pop edi
        pop esi
        ret
;-----------------------------------------------------------------------------
; CPgoalie                           591C7  94G logic94.asm, medium confidence
;-----------------------------------------------------------------------------
; C: src/engine/collide/CPgoalie.c
%ifdef CBUILD
%include "c/engine/collide/CPgoalie.inc"
%else
CPgoalie:
        push dword 8
        call __CHK
        push ecx
        cmp dword [penshotmode], byte 0
        jne near .x
        mov cx, word [gsp]
        cmp cx, byte 2
        jne near .x
        mov dx, word [byte edx+010h]
        sub dx, word [byte eax+010h]
        test dx, dx
        jle short .x
        cmp dx, cx
        jg short .x
        cmp word [gameclock], byte 3Ch
        jg short .x
        mov edx, dword [dword eax+tmsort]
        test byte [byte edx+044h], 80h
        jne short .1
        neg ebx
.1:
        test bx, bx
        jl short .x
        mov byte [byte eax+039h], 0FFh
        cmp eax, awtmstruct
        sete dl
        xor dh, dh
        mov ebx, edx
        mov dx, word [byte eax+038h]
        xor dh, dh
        and dl, 0Fh
        movsx edx, dx
        mov ecx, edx
        shl ecx, 2
        movsx ebx, bx
        mov edx, ebx
        shl edx, 2
        sub edx, ebx
        mov ebx, dword [dword ecx+edx*4+goaliemenuflags]
        mov byte [ebx], 2
        mov edx, dword [nosplit edx*4+goaliemenuflags_e02]
        mov byte [edx], 1
        call setpersonel
.x:
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ChkGoalies                                          59265  93G logic93_4.asm
; (computer pulls goalie on delayed penalty), once a second from periodicevents.
;-----------------------------------------------------------------------------
; C: src/engine/collide/ChkGoalies.c
%ifdef CBUILD
%include "c/engine/collide/ChkGoalies.inc"
%else
ChkGoalies:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        test byte [gmode], 1
        jne near .x
        xor ecx, ecx
        mov eax, hmtmstruct
        mov esi, awtmstruct
        jmp near .4
.1:
        cmp word [byte eax+038h], byte 0
        jl near .3
        mov edx, dword [puckc]
        mov bl, byte [edx]
        test bl, bl
        jl near .3
        cmp bl, 6
        setl dl
        mov ebx, edx
        and ebx, 0FFh
        test cx, cx
        sete dl
        and edx, 0FFh
        xor edx, ebx
        jne short .3
        test byte [gmode], 8
        je short .2
        mov byte [byte eax+039h], 0FFh
        mov dx, word [byte eax+038h]
        xor dh, dh
        and dl, 0Fh
        movsx ebx, dx
        movsx esi, cx
        mov edx, esi
        shl edx, 2
        sub edx, esi
        shl edx, 2
        mov ebx, dword [dword edx+ebx*4+goaliemenuflags]
        mov byte [ebx], 2
        mov edx, dword [dword edx+goaliemenuflags_e02]
        mov byte [edx], 1
        call setpersonel
        jmp short .3
.2:
        movsx edx, cx
        mov ebx, dword [cont1team-2]
        sar ebx, 10h
        inc edx
        cmp ebx, edx
        je short .3
        mov ebx, dword [cont2team-2]
        sar ebx, 10h
        cmp ebx, edx
        je short .3
        mov ebx, dword [pucky]
        movsx ebx, word [ebx]
        mov edx, esi
        call CPgoalie
.3:
        mov eax, awtmstruct
        mov esi, hmtmstruct
        inc ecx
.4:
        cmp cx, byte 2
        jl near ChkGoalies.1
.x:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ReturnGoalies                                       59352  93G logic93_4.asm
; (computer returns a pulled goalie), from puckfaceoff.
;-----------------------------------------------------------------------------
; C: src/engine/collide/checkob.c (ReturnGoalies)
%ifdef CBUILD
%include "c/engine/collide/checkob.ReturnGoalies.inc"
%else
ReturnGoalies:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 4
        xor ecx, ecx
        mov eax, hmtmstruct
        mov esi, awtmstruct
        jmp near .3
.1:
        test byte [byte eax+038h], 0F0h
        jne short .2
        mov byte [byte eax+039h], 0
        movsx edi, cx
        mov edx, edi
        shl edx, 2
        sub edx, edi
        mov ebx, dword [nosplit edx*4+goaliemenuflags_e02]
        mov byte [ebx], 2
        mov bx, word [byte eax+038h]
        xor bh, bh
        and bl, 0Fh
        mov word [esp], bx
        mov ebx, dword [byte esp-02h]
        sar ebx, 10h
        shl ebx, 2
        mov edx, dword [dword ebx+edx*4+goaliemenuflags]
        mov byte [edx], 1
        mov edx, dword [cont1team-2]
        sar edx, 10h
        inc edi
        cmp edx, edi
        je short .2
        mov edx, dword [cont2team-2]
        sar edx, 10h
        cmp edx, edi
        je short .2
        mov ebx, dword [foy-2]
        sar ebx, 10h
        mov edx, esi
        call CPgoalie
.2:
        mov eax, awtmstruct
        mov esi, hmtmstruct
        inc ecx
.3:
        cmp cx, byte 2
        jl short ReturnGoalies.1
        jmp near checkob_ret5a
%endif ; C
;-----------------------------------------------------------------------------
; ChkPullGoalieLate                            593F5  95 PC, medium confidence
; Player logic caller: 0 unless 3rd period (gsp 2) with at most 60 s left and
; the team is not human-controlled; then a team-struct check (likely the
; score: pull the goalie late, not fully traced)
;-----------------------------------------------------------------------------
; C: src/engine/collide/ChkPullGoalieLate.c
%ifdef CBUILD
%include "c/engine/collide/ChkPullGoalieLate.inc"
%else
ChkPullGoalieLate:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov edx, eax
        shl edx, 8
        add edx, hmtmstruct
        test eax, eax
        sete bl
        and ebx, 0FFh
        shl ebx, 8
        mov ecx, hmtmstruct
        add ecx, ebx
        mov ebx, dword [foy-2]
        sar ebx, 10h
        cmp word [gsp], byte 2
        je short .2
.1:
        xor eax, eax
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.2:
        cmp word [gameclock], byte 3Ch
        jg short ChkPullGoalieLate.1
        mov esi, dword [cont1team-2]
        sar esi, 10h
        inc eax
        cmp esi, eax
        je short ChkPullGoalieLate.1
        je short ChkPullGoalieLate.1
        mov ecx, dword [byte ecx+0Eh]
        sar ecx, 10h
        mov eax, dword [byte edx+0Eh]
        sar eax, 10h
        sub ecx, eax
        mov eax, ecx
        test ecx, ecx
        jg short .4
.3:
        xor eax, ecx
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.4:
        cmp ecx, byte 2
        jg short ChkPullGoalieLate.3
        mov eax, dword [dword edx+tmsort]
        test byte [byte eax+044h], 80h
        jne short .5
        neg ebx
.5:
        test ebx, ebx
        jl short ChkPullGoalieLate.1
        mov eax, 1
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
