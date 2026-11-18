; Goal scored: control, pass assignment, team energy, team resets.
bits 32
%include "hockey.inc"
%include "spa.inc"
section s_5AAAE progbits alloc exec nowrite align=1
extern __CHK, AddPenalty, AddPenalty2, assinsert, assreplace, awglattr, awglstats, awlinetab
extern awplattr, awplstats, awroster, awscore, awteamrec, awtmcoach_d2, awtmcoach_d3, awtmextra
extern awtmglattr, awtmglstats, awtmgoalie, awtmlines, awtmpbox, awtmplattr, awtmplstats, awtmptrF2
extern awtmroster, awtmsort, awtmstruct, c1playernum, c2playernum, changeplayer_ret5, ChkShotStat, collflag
extern cont1team, cont2team, Crowdlevel, CwdExciteLvl, DrawPanelScore, Setplass_alist_m3, UnusedEventWord, EndPenaltyShot
extern findpc, findpc_ret5, findpc_ret6, fox, foy, freezewindow, gameclock, gameopts
extern gmode, gmode2, gsp, hmglattr, hmglstats, hmlinetab, hmplattr, hmplstats
extern hmroster, hmscore, hmteamrec, hmtmcoach_d2, hmtmcoach_d3, hmtmextra, hmtmglattr, hmtmglstats
extern hmtmgoalie, hmtmlines, hmtmpbox, hmtmplattr, hmtmplstats, hmtmptrF2, hmtmroster, hmtmsort
extern hmtmstruct, lastplayer, lasttouch, ltx, lty, MusicOn, onetimerflag, PenGoalStuff
extern penshotfox, penshotfoy, penshotlive, penshotmode, penshotteam, PlayCrowdSample, puckcross, puckstruct
extern pucky, regd1, restorepl, restoreteams_pdsttab, SetBoxDoorObject, Setplass_alist, SetSPA, sfx
extern shotongoal, shotplayer, SortCords, UpdateCoachModes, GoalState
global PenTeamScored, Goal, GiveControl, Setplass, setplayer, reenergizeteam, clearteams, restoreteams
;-----------------------------------------------------------------------------
; PenTeamScored                                5AAAE  95 PC, medium confidence
; During a delayed penalty (gmode bit 3): 1 if the scoring team has a skater
; with pflags2 bit 4 (caused a penalty), else 0. Goal then disallows the goal.
;-----------------------------------------------------------------------------
; C: src/engine/goal/PenTeamScored.c
%ifdef CBUILD
%include "c/engine/goal/PenTeamScored.inc"
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
; (puck in goal). eax = the goal struct the puck went into. esi = scoring
; team, ebp = the other (puck Ypos sign xor gmdir).
;
; Puck stopped in the net, assreplace puck 1Ah.
;
; Offside (tmflags bit 4) -> AddPenalty 8 + AddPenalty2 1Bh; PenTeamScored
; (delayed penalty) -> no goal else tmscore+1 and the scoring bookkeeping
; (goal/assist counts, PenGoalStuff).
;-----------------------------------------------------------------------------
; C: src/engine/control/findpc.c (Goal)
%ifdef CBUILD
%include "c/engine/control/findpc.Goal.inc"
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
        mov cx, word [Crowdlevel]
        add ecx, 320h
        mov word [Crowdlevel], cx
        cmp cx, 7D0h
        jle short .14
        mov word [Crowdlevel], 7D0h
.14:
        cmp word [Crowdlevel], 708h
        jge short .16
        mov word [Crowdlevel], 708h
        jmp short .16
.15:
        cmp word [Crowdlevel], 320h
        jge short .16
        mov word [Crowdlevel], 320h
.16:
        mov eax, dword [byte esp+02h]
        sar eax, 10h
        call SetBoxDoorObject
        cmp word [byte esp+04h], byte 0
        jne short .20
        test byte [gameopts+1], 1
        je short .17
        cmp byte [MusicOn], 0
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
        mov word [GoalState], 2
        jmp short .25
.23:
        jle short .24
        mov word [GoalState], 4
        jmp short .25
.24:
        mov word [GoalState], 1
.25:
        cmp word [byte ebp+038h], byte 0
        jge short .26
        or byte [GoalState], 8
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
        mov edx, SPAsiren
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
; C: src/engine/goal/GiveControl.c
%ifdef CBUILD
%include "c/engine/goal/GiveControl.inc"
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
; Set player p's initial assignment from his position: for positions 0-6,
; assreplace(p, Setplass_alist[position]) (goalie: assgoalie, defence:
;
; assdefd, wings: asswingd, centre: asscenterd). Other positions (negative, or
; above 6 on the PC) are left alone.
;-----------------------------------------------------------------------------
; C: src/engine/goal/Setplass.c
%ifdef CBUILD
%include "c/engine/goal/Setplass.inc"
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
        mov edx, dword [dword edx+Setplass_alist_m3]
        sar edx, 18h
        call assreplace
.x:
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; setplayer                                         5B2C5  93G hockey93_05.asm
; (bring player onto the ice and set his stats). eax = sort object, edx =
; roster number. pnum = edx, tmpdst entry -1 (ice), roster status byte 4,
;
; then the attribute bytes from the roster record.
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
        mov eax, dword [UnusedEventWord]
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
; reenergizeteam: refill energy of the whole roster (1000h)
;-----------------------------------------------------------------------------
; C: src/engine/control/findpc.c (reenergizeteam)
%ifdef CBUILD
%include "c/engine/control/findpc.reenergizeteam.inc"
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
; C: src/engine/goal/clearteams.c
%ifdef CBUILD
%include "c/engine/goal/clearteams.inc"
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
; C: src/engine/goal/restoreteams.c
%ifdef CBUILD
%include "c/engine/goal/restoreteams.inc"
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
