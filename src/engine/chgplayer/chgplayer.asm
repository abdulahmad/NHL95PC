; Animation set and the controlled player change (94G chgplayer94).
bits 32
%include "hockey.inc"
section s_59D9A progbits alloc exec nowrite align=1
extern __CHK, c1playernum, c2playernum, cont1team, cont2team, OOlist, OOlistpos, puckvx
extern puckvy, puckx, pucky, sflags, SortCords, Sweepcheck, Ylist
global SetSPA, SprSort_loop, SprSort_test, changeplayer, changeplayer_ret5, restorepl
;-----------------------------------------------------------------------------
; SetSPA                                                59D9A  94G logic94.asm
; Genesis comment (logic94.asm): set sprite animation on struct a3. d1 = new
; animation
;-----------------------------------------------------------------------------
; C: src/engine/chgplayer/SetSPA.c
%ifdef CBUILD
%include "c/engine/chgplayer/SetSPA.inc"
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
; Entry into SprSort's copy loop (y, or x when sfhor, of each sort object to
; Ylist).
;-----------------------------------------------------------------------------
; C: src/engine/chgplayer/SetSPA.c (SprSort_loop)
%ifdef CBUILD
%include "c/engine/chgplayer/SetSPA.SprSort_loop.inc"
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
; C: src/engine/chgplayer/restorepl.c
%ifdef CBUILD
%include "c/engine/chgplayer/restorepl.inc"
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
