; Puck state routines: normal, nothing, unflip.
bits 32
%include "hockey.inc"
section s_4D6B4 progbits alloc exec nowrite align=1
extern __CHK, a2touchpuck, AddPenalty2, ass_popx, assrefwhistle, awtmnear, checkpuckcoll, ChkOffsides
extern EndPenaltyShot, findpc, GetHot, gmode, hmtmnear, MarkTwoLinePlayers, penshotlive, penshotteam
extern psendcount, puckc, puckcross, puckcross2, puckcross6, PuckIChk, puckvy, puckx
extern pucky, regd0, regd1, SortCords
global pucknorm_body, pucknorm, pucknothing, puckunflip
;-----------------------------------------------------------------------------
; pucknorm_body                                         4D6B4  94G logic94.asm
; Body of pucknorm after the new-assignment part; ends in ass_popx: the puck's
; normal assignment.
;
; Count down the two line-crossing timers (puckcross) and every 5 ticks
; recompute them (temp1, findpc).
;
; A carried puck is pulled a quarter of the way toward its carrier's hot spot
; (a2touchpuck, GetHot into regd0 / regd1) and takes his velocity. Then the
; ice / offside / two-line checks (PuckIChk, ChkOffsides, MarkTwoLinePlayers).
;
; While the clock runs: a carried puck resets temp2 (78h) and the penalty-shot
; send count (psendcount); a loose one on a live penalty shot moving back
; toward the shooter's own end (puckvy by penshotteam
;
; and the gmode bit 1 rink flip) for 1Eh ticks ends the shot (EndPenaltyShot).
;
; A puck that has stopped (same position as last tick), outside the middle (x
; A3h, y 10Eh) or with hmtmnear / awtmnear at 14h or less, counts temp2 down
; and at 0 calls a delay of game (AddPenalty2 3); a moving one resets temp2.
;
; A puck almost still on the ice (z speed below 100h, z 0) is put flat
; (puckunflip); then the collisions (checkpuckcoll). p: the puck. No result.
;-----------------------------------------------------------------------------
; C: src/engine/referee/assrefwhistle.c (pucknorm_body)
%ifdef CBUILD
%include "c/engine/referee/assrefwhistle.pucknorm_body.inc"
%else
pucknorm_body:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ebx, eax
        dec word [puckcross2]
        dec word [puckcross6]
        mov si, word [byte eax+026h]
        dec esi
        mov word [byte eax+026h], si
        test si, si
        jge short .1
        mov eax, esi
        add eax, 5
        mov word [byte ebx+temp1], ax
        mov eax, ebx
        call findpc
.1:
        mov edx, dword [puckc]
        mov ah, byte [edx]
        test ah, ah
        jl short .2
        movsx eax, ah
        shl eax, 7
        mov edx, SortCords
        add edx, eax
        mov eax, edx
        call a2touchpuck
        mov eax, edx
        call GetHot
        mov eax, dword [edx]
        sar eax, 10h
        mov ecx, dword [regd0-2]
        sar ecx, 10h
        add ecx, eax
        mov eax, dword [ebx]
        sar eax, 10h
        sub ecx, eax
        sar ecx, 2
        add eax, ecx
        mov word [byte ebx+Xpos+2], ax
        mov eax, dword [byte edx+Ypos]
        sar eax, 10h
        mov ecx, dword [regd1-2]
        sar ecx, 10h
        add ecx, eax
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
        sub ecx, eax
        sar ecx, 2
        add eax, ecx
        mov word [byte ebx+Ypos+2], ax
        mov ax, word [byte edx+Xvel]
        mov word [byte ebx+Xvel], ax
        mov ax, word [byte edx+Yvel]
        mov word [byte ebx+Yvel], ax
.2:
        call PuckIChk
        mov eax, ebx
        call ChkOffsides
        mov eax, ebx
        call MarkTwoLinePlayers
        mov dl, byte [gmode]
        test dl, 1
        jne near .14
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jl short .4
        xor esi, esi
        mov dword [psendcount], esi
.3:
        mov word [byte ebx+temp2], 78h
        jmp near .14
.4:
        test dl, 2
        sete al
        and eax, 0FFh
        xor eax, dword [penshotteam]
        cmp dword [penshotlive], byte 0
        je short .7
        test eax, eax
        jne short .5
        mov edx, dword [puckvy]
        cmp word [edx], byte 0
        jge short .6
.5:
        test eax, eax
        je short .7
        mov eax, dword [puckvy]
        cmp word [eax], byte 0
        jg short .7
.6:
        mov edi, dword [psendcount]
        inc edi
        mov dword [psendcount], edi
        cmp edi, byte 1Eh
        jl short .8
        call EndPenaltyShot
        xor eax, eax
        mov dword [psendcount], eax
        jmp short .8
.7:
        xor esi, esi
        mov dword [psendcount], esi
.8:
        mov ax, word [byte ebx+Xpos+2]
        cmp ax, word [byte ebx+OldXpos+2]
        jne short pucknorm_body.3
        mov ax, word [byte ebx+Ypos+2]
        cmp ax, word [byte ebx+OldYpos+2]
        jne short pucknorm_body.3
        mov edx, dword [puckx]
        mov cx, word [edx]
        test cx, cx
        jge short .9
        movsx eax, cx
        neg eax
        jmp short .10
.9:
        movsx eax, cx
.10:
        cmp eax, 0A3h
        jge short .13
        mov edx, dword [pucky]
        mov si, word [edx]
        test si, si
        jge short .11
        movsx edx, si
        neg edx
        jmp short .12
.11:
        movsx edx, si
.12:
        cmp edx, 10Eh
        jge short .13
        cmp dword [hmtmnear], byte 14h
        jle short .13
        cmp dword [awtmnear], byte 14h
        jg near pucknorm_body.3
.13:
        mov di, word [byte ebx+temp2]
        dec edi
        mov word [byte ebx+temp2], di
        test di, di
        jge short .14
        mov edx, 3
        mov eax, ebx
        call AddPenalty2
.14:
        cmp word [byte ebx+Zvel], byte 0
        jge short .15
        mov eax, dword [byte ebx+Zvel-2]
        sar eax, 10h
        neg eax
        jmp short .16
.15:
        mov eax, dword [byte ebx+Zvel-2]
        sar eax, 10h
.16:
        cmp eax, 100h
        jge short .17
        cmp word [byte ebx+Zpos+2], byte 0
        jne short .17
        mov eax, ebx
        call puckunflip
.17:
        mov eax, ebx
        call checkpuckcoll
        jmp near ass_popx
%endif ; C
;-----------------------------------------------------------------------------
; pucknorm                                              4D8C7  94G logic94.asm
; Assignment table slot 18h: clears pfna; clr temp1(+26h);
; temp2(+28h)=$78; then calls the body pucknorm_body
;-----------------------------------------------------------------------------
; C: src/engine/puck/pucknorm.c
%ifdef CBUILD
%include "c/engine/puck/pucknorm.inc"
%else
pucknorm:
        push dword 8
        call __CHK
        push edx
        mov dl, byte [byte eax+pflags]
        test dl, 2
        je short .1
        mov dh, dl
        and dh, 0FDh
        mov byte [byte eax+pflags], dh
        mov word [byte eax+temp1], 0
        mov word [byte eax+temp2], 78h
        xor edx, edx
        mov dword [psendcount], edx
.1:
        call pucknorm_body
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; pucknothing                        4D8FD  94G logic94.asm, medium confidence
; Assignment table slot 1Ah: the puck with nothing to do
;-----------------------------------------------------------------------------
; C: src/engine/puck/pucknothing.c
%ifdef CBUILD
%include "c/engine/puck/pucknothing.inc"
%else
pucknothing:
        push dword 4
        call __CHK
;-----------------------------------------------------------------------------
; puckunflip                         4D907  94G logic94.asm, medium confidence
; End of a puck flip: mid-flip (SPAnum 4..11) toggles facedir bit 1; facedir
; bit 2 set; SPAnum 0, SPAcnt -1.
;-----------------------------------------------------------------------------
; C: src/engine/puck/puckunflip.c
%ifdef CBUILD
%include "c/engine/puck/puckunflip.inc"
%else
puckunflip:
        push dword 8
        call __CHK
        push edx
        mov dx, word [byte eax+03Ah]
        cmp dx, byte 4
        jl short .1
        cmp dx, byte 0Ch
        jge short .1
        xor byte [byte eax+036h], 2
.1:
        or byte [byte eax+036h], 4
        mov word [byte eax+03Ah], 0
        mov word [byte eax+03Ch], 0FFFFh
        pop edx
        ret
%endif ; C
%endif ; C
