; Offsides and two-line pass at the blue and red lines, the puck flip (94G logic94).
bits 32
%include "hockey.inc"
section s_4DCDD progbits alloc exec nowrite align=1
extern __CHK, AddPenalty, awtmap, gameopts, gmode, gmode2, hmtmap, icingPlayer
extern iflags, lasttouch, ltx, lty, penshotlive, penshotstart, puckunflip, pucky
extern regd0, SetSPA, SortCords
global a2offsides, ChkTwoLinePass, a2touchpuck, puckflip
;-----------------------------------------------------------------------------
; a2offsides                         4DCDD  94G logic94.asm, medium confidence
;-----------------------------------------------------------------------------
; C: src/engine/offsides/a2offsides.c
%ifdef CBUILD
%include "c/engine/offsides/a2offsides.inc"
%else
a2offsides:
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
        cmp dword [penshotlive], byte 0
        jne short a2offsides.1
        cmp dword [penshotstart], byte 0
        jne short a2offsides.1
        mov edx, dword [pucky]
        mov dx, word [edx]
        mov word [regd0], dx
        test byte [byte eax+044h], 80h
        jne short .3
        neg word [regd0]
.3:
        cmp word [regd0], byte 4Eh
        jl short a2offsides.1
        mov edx, dword [byte eax+06Ch]
        test byte [byte edx+tmflags], 10h
        je short a2offsides.1
        test byte [gmode], 10h
        jne short a2offsides.1
        mov edx, 8
        call AddPenalty
        mov eax, 1
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ChkTwoLinePass                               4DD51  95 PC, medium confidence
; Two-line pass option (gameopts bit 3, not in highlight mode): receiver eax
; was past the red line (pflags2 bit 7 from MarkTwoLinePlayers, or on the
; attacking side) and the pass came from a teammate in his own half
; (lasttouch): returns 1 for a two-line pass whistle; called by a2touchpuck
;-----------------------------------------------------------------------------
; C: src/engine/offsides/ChkTwoLinePass.c
%ifdef CBUILD
%include "c/engine/offsides/ChkTwoLinePass.inc"
%else
ChkTwoLinePass:
        push dword 10h
        call __CHK
        push ebx
        push edx
        push esi
        test byte [gmode], 10h
        je short .2
.1:
        xor eax, eax
        pop esi
        pop edx
        pop ebx
        ret
.2:
        test byte [gameopts], 8
        je short ChkTwoLinePass.1
        test byte [byte eax+pflags2], 80h
        jne short .3
        test byte [byte eax+pflags], 80h
        sete dl
        mov ebx, edx
        and ebx, 0FFh
        mov edx, dword [pucky]
        cmp word [edx], byte 0
        setg dl
        and edx, 0FFh
        xor edx, ebx
        jne short ChkTwoLinePass.1
.3:
        mov dx, word [byte eax+SCnum]
        mov si, word [lasttouch]
        cmp dx, si
        je short ChkTwoLinePass.1
        cmp dx, byte 6
        setl dl
        mov ebx, edx
        and ebx, 0FFh
        cmp si, byte 6
        setl dl
        and edx, 0FFh
        xor edx, ebx
        jne short ChkTwoLinePass.1
        test byte [byte eax+pflags], 80h
        jne short .4
        cmp word [lty], byte 4Eh
        jl short ChkTwoLinePass.1
        cmp word [byte eax+Ypos+2], byte 0
        jle short .5
        jmp near ChkTwoLinePass.1
.4:
        mov edx, dword [lty-2]
        sar edx, 10h
        cmp edx, byte 0FFFFFFB2h
        jg near ChkTwoLinePass.1
        cmp word [byte eax+Ypos+2], byte 0
        jl near ChkTwoLinePass.1
.5:
        mov eax, 1
        pop esi
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; a2touchpuck                                           4DE14  94G logic94.asm
;-----------------------------------------------------------------------------
; C: src/engine/offsides/a2touchpuck.c
%ifdef CBUILD
%include "c/engine/offsides/a2touchpuck.inc"
%else
a2touchpuck:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push edi
        mov ebx, eax
        call ChkTwoLinePass
        mov ecx, eax
        test ax, ax
        jne short .1
        test byte [gmode], 1
        jne short .1
        mov ax, word [byte ebx+Xpos+2]
        mov word [ltx], ax
        mov ax, word [byte ebx+Ypos+2]
        mov word [lty], ax
        mov ax, word [byte ebx+SCnum]
        mov word [lasttouch], ax
.1:
        mov eax, dword [byte ebx+06Ch]
        movsx dx, byte [byte ebx+047h]
        cmp dx, word [byte eax+030h]
        je short .4
        mov dl, byte [byte eax+tmflags]
        test dl, 8
        je short .2
        mov dh, dl
        and dh, 0F7h
        mov byte [byte eax+tmflags], dh
        jmp short .3
.2:
        mov dx, word [byte eax+Wallsin]
        mov word [byte eax+034h], dx
        mov dx, word [byte eax+Wallcos]
        mov word [byte eax+Wallsin], dx
.3:
        movsx dx, byte [byte ebx+047h]
        mov word [byte eax+Wallcos], dx
        cmp dx, word [byte eax+034h]
        jne short .5
        mov byte [byte eax+035h], 0FFh
        jmp short .5
.4:
        mov dl, byte [byte eax+pflags]
        test dl, 8
        je short .5
        mov dh, dl
        and dh, 0F7h
        mov byte [byte eax+pflags], dh
.5:
        cmp word [byte ebx+position], byte 0
        je short .6
        and byte [gmode2], 0EFh
.6:
        mov eax, ebx
        call a2offsides
        test ax, ax
        jne short .7
        test cx, cx
        je short .7
        mov edx, 1Dh
        mov eax, ebx
        call AddPenalty
.7:
        mov ah, byte [iflags]
        test ah, 4
        je short .8
        test ah, 1
        je short .8
        cmp word [byte ebx+position], byte 0
        je short .8
        test byte [byte ebx+pflags], 80h
        setne al
        mov edx, eax
        and edx, 0FFh
        test byte [iflags], 2
        setne al
        and eax, 0FFh
        xor eax, edx
        je short .8
        mov eax, dword [icingPlayer-3]
        sar eax, 18h
        shl eax, 7
        add eax, SortCords
        mov edx, 6
        call AddPenalty
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.8:
        xor ch, ch
        mov byte [iflags], ch
        mov al, byte [byte ebx+06Ah]
        mov byte [icingPlayer], al
        mov eax, dword [pucky]
        mov ax, word [eax]
        mov word [regd0], ax
        test byte [byte ebx+pflags], 80h
        je short .9
        mov byte [iflags], 2
        neg word [regd0]
.9:
        cmp word [regd0], byte 0
        jl short .x
        mov ax, word [hmtmap]
        mov di, word [awtmap]
        sub eax, edi
        mov word [regd0], ax
        test byte [byte ebx+pflags], 40h
        je short .10
        neg eax
        mov word [regd0], ax
.10:
        cmp word [regd0], byte 0
        jl short .x
        or byte [iflags], 4
.x:
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; puckflip                                              4DFA4  94G logic94.asm
;-----------------------------------------------------------------------------
; C: src/engine/offsides/puckflip.c
%ifdef CBUILD
%include "c/engine/offsides/puckflip.inc"
%else
puckflip:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        mov edx, dword [byte eax+Xvel-2]
        sar edx, 10h
        mov ebx, dword [byte eax+Yvel-2]
        sar ebx, 10h
        add edx, ebx
        cmp edx, byte 14h
        jge short .1
        call puckunflip
        pop edx
        pop ebx
        ret
.1:
        mov dx, word [regd0]
        xor dh, dh
        and dl, 1
        xor dx, word [byte eax+facedir]
        xor dh, dh
        and dl, 3
        mov word [byte eax+facedir], dx
        mov word [byte eax+SPAcnt], 0FFFFh
        mov edx, 239h
        call SetSPA
        pop edx
        pop ebx
        ret
%endif ; C
