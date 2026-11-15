; Computer line choice: line energy and the next line (94G penalty94).
bits 32
%include "hockey.inc"
section s_5A03B progbits alloc exec nowrite align=1
extern __CHK, awtmstruct, coachlinetab, DrawPanelLine, gmode, hmtmstruct, regd0
global AvgCline, CompLine, getlinee_pp, getlinee_sum, TeamLineEnergy, getlinee
;-----------------------------------------------------------------------------
; AvgCline                         5A03B  94G penalty94.asm, medium confidence
; 93G AvgCline: average energy of the current line of team eax (walks tmsort
; F6h); used by chk4lc (54AF9) and CompLine
;-----------------------------------------------------------------------------
; C: src/engine/autolines/AvgCline.c
%ifdef CBUILD
%include "c/engine/autolines/AvgCline.inc"
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
; C: src/engine/autolines/CompLine.c
%ifdef CBUILD
%include "c/engine/autolines/CompLine.inc"
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
; Entry into getlinee for the power play / penalty kill line choice (shares
; getlinee's code).
;-----------------------------------------------------------------------------
; C: src/engine/autolines/CompLine.c (getlinee_pp)
%ifdef CBUILD
%include "c/engine/autolines/CompLine.getlinee_pp.inc"
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
; C: src/engine/autolines/CompLine.c (TeamLineEnergy)
%ifdef CBUILD
%include "c/engine/autolines/CompLine.TeamLineEnergy.inc"
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
; C: src/engine/autolines/CompLine.c (getlinee)
%ifdef CBUILD
%include "c/engine/autolines/CompLine.getlinee.inc"
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
