; Shooting decision, offsides check after a shot, shot stats, injuries.
bits 32
%include "hockey.inc"
section s_55804 progbits alloc exec nowrite align=1
extern __CHK, assreplace, awshotcnt, awtmstruct, camx, checkob, checkob_ret5, chk4lc
extern chk4lc_shoot, clockticks, CountShotOnGoal, Crowdlevel, CwdExciteLvl, gameclock, gameopts, gmode
extern gmode2, hmshotcnt, hmtmstruct, injurystop, lastimpact, lasttouch, penshotlive, penshotstart
extern PerTimeTotal, PostInjuryEvent, puckx, pucky, randomd0, regd0, regd1, regd3
extern regd4, regd5, RemoveFromLines, sflags, sfx, shotplayer, SortCords, threat
extern vtoa, xc1, yc1
global chk4shot, CompShoot, ChkOffsides, MarkTwoLinePlayers, ChkShotStat, setInjuryType
;-----------------------------------------------------------------------------
; chk4shot                                              55804  94G logic94.asm
; (computer looks for a shot). regd4 = 20h - spodds; shot lane test; jumps to
; chk4lc_shoot (CompShoot) to shoot.
;-----------------------------------------------------------------------------
; C: src/engine/pass/checkob.c (chk4shot)
%ifdef CBUILD
%include "c/engine/pass/checkob.chk4shot.inc"
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
; C: src/engine/shoot/CompShoot.c
%ifdef CBUILD
%include "c/engine/shoot/CompShoot.inc"
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
; C: src/engine/pass/checkob.c (ChkOffsides)
%ifdef CBUILD
%include "c/engine/pass/checkob.ChkOffsides.inc"
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
; the team past the red line (Ypos sign by gmode bit 1),
;
; clears it on the others; ChkTwoLinePass (from a2touchpuck) reads the flag
;-----------------------------------------------------------------------------
; C: src/engine/shoot/MarkTwoLinePlayers.c
%ifdef CBUILD
%include "c/engine/shoot/MarkTwoLinePlayers.inc"
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
; If the shot flag (gmode2 bit 4) was set: clear it, Crowdlevel +100,
; shot counts for the shooter and the goalie.
;-----------------------------------------------------------------------------
; C: src/engine/pass/checkob.c (ChkShotStat)
%ifdef CBUILD
%include "c/engine/pass/checkob.ChkShotStat.inc"
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
        mov si, word [Crowdlevel]
        cmp si, 3E8h
        jg short .1
        mov edi, esi
        add edi, byte 64h
        mov word [Crowdlevel], di
        cmp di, 3E8h
        jle short .1
        mov word [Crowdlevel], 3E8h
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
; C: src/engine/pass/checkob.c (setInjuryType)
%ifdef CBUILD
%include "c/engine/pass/checkob.setInjuryType.inc"
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
        mov dx, word [Crowdlevel]
        cmp dx, 3E8h
        jg short .1
        mov ebx, edx
        add ebx, 12Ch
        mov word [Crowdlevel], bx
        cmp bx, 3E8h
        jle short .1
        mov word [Crowdlevel], 3E8h
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
