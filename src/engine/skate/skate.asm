; Skating. How a player accelerates, steers, and stops, including the goalie,
; and how he picks a path around other players and the net.
bits 32
%include "hockey.inc"
%include "spa.inc"
section s_5E16D progbits alloc exec nowrite align=1
extern __CHK, dirtab, dirtab_y, doplayeracc_ftab, gameopts, GetHot, gmode, gmode2
extern imul32, MaxSpeed, puckc, puckpflags2, puckvx, puckvy, puckx, pucky
extern randomd0, refsignal, regd0, regd1, regd2, regd3, regd4, SetSPA
extern SortCords, Sweepcheck, vecdist, vtoa, xc1, yc1
global doplayeracc, EvadePlayers, EvadePlayers_popebp, EvadePlayers_popedi, EvadePC, EvadePC_x, skateto, skatetopuck
global playeracc, avdgoal_box, avdgoal_jt, avdgoal, dostop, stopna, goalieacc, noturn0
;-----------------------------------------------------------------------------
; doplayeracc                        5E16D  94G logic94.asm, medium confidence
; player gets acc. in a direction (player a3 gets acc. in d0 dir). eax =
; player struct, edx = direction (low nibble: 0-7 skate, 8 none, 9 stop).
;
; No result. Goalie -> goalieacc. Picks the glide animation, turns facedir by
; doplayeracc_ftab at a rate of $300-speed (min $180), sets/clears pfrev
; (skating backwards in own zone), then playeracc.
;
; PC: struct 10h (the referee) has its own animations.
;-----------------------------------------------------------------------------
; C: src/engine/skate/doplayeracc.c
%ifdef CBUILD
%include "c/engine/skate/doplayeracc.inc"
%else
doplayeracc:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 0Ch
        mov ecx, eax
        mov ebx, edx
        cmp word [byte eax+position], byte 0    ; goalie is special
        jne short .1
        movsx edx, bx
        call goalieacc
        jmp near .x
.1:
        test byte [byte eax+pflags], 10h
        je short .2
        mov esi, SPAglideback                           ; SPAglideback
        jmp short .d0
.2:
        cmp word [byte ecx+SCnum], byte 10h
        jne short .5
        cmp word [refsignal], byte 0
        jne short .3
        mov dl, byte [gmode]
        test dl, 1
        jne short .4
        test byte [gmode2], 80h
        jne short .3
        test dl, 8
        je short .4
.3:
        mov esi, SPAarmupglide                          ; referee glide, signalling
        jmp short .d0
.4:
        mov esi, SPArefglide                          ; referee glide
        jmp short .d0
.5:
        mov esi, SPAglide                           ; SPAglide
.d0:
        xor bh, bh
        and bl, 0Fh
        cmp bx, byte 7                          ; cmp #7: 0-7 = skate
        jle short .d1
        cmp bx, byte 9                          ; 9 = stop
        jne short .cgl
        mov edx, dword [byte ecx+Xvel-2]
        sar edx, 10h
        mov eax, dword [byte ecx+Yvel-2]
        sar eax, 10h
        or eax, edx
        je short .cgl
        mov eax, ecx
        call dostop
        jmp near .x
.cgl:
        test byte [byte ecx+pflags2], 2
        jne near .x                             ; pf2aip: animation in progress
        movsx edx, si
        mov eax, ecx
        call SetSPA
        jmp near .x
.d1:
        mov word [byte esp+08h], bx
        mov eax, dword [puckc]
        movsx ax, byte [eax]
        cmp ax, word [byte ecx+SCnum]           ; player has the puck: .clrrev
        je near .clrrev
        mov eax, dword [puckx]
        mov ax, word [eax]
        mov di, word [byte ecx+Xpos+2]
        sub eax, edi
        mov word [byte esp+04h], ax
        mov ax, word [byte ecx+Ypos+2]
        mov edx, dword [puckvy]
        movsx dx, byte [byte edx+01h]           ; puckvy high byte (d1)
        mov dword [esp], edx
        mov edx, dword [pucky]
        mov dx, word [edx]
        mov edi, dword [esp]
        add edi, edx
        sub edi, eax
        test byte [byte ecx+pflags], 80h        ; pfgoal
        jne short .c1
        neg word [byte esp+04h]
        neg eax
        neg edi
        xor bl, 4
.c1:
        test byte [byte ecx+pflags], 10h
        jne short .inrev
        test ax, ax                             ; skate back in own zone only
        jge near .clrrev
        cmp bx, byte 4
        jne near .clrrev
        movsx edx, di
        mov eax, dword [byte esp+02h]
        sar eax, 10h
        call vtoa
        cwde
        inc eax
        and eax, byte 7
        cmp eax, byte 2
        jg near .clrrev
.inrev:
        test byte [byte ecx+pflags], 10h        ; pfrev
        je short .rev
        sub ebx, byte 3
        xor bh, bh
        and bl, 7
        cmp bx, byte 2
        jg short .clrrev
        movsx edx, di
        mov eax, dword [byte esp+02h]
        sar eax, 10h
        call vtoa
        cwde
        add eax, byte 2
        and eax, byte 7
        cmp eax, byte 4
        jg short .clrrev
.rev:
        test byte [byte ecx+pflags], 10h
        jne short .done
        cmp word [byte ecx+SCnum], byte 10h
        je short .done
        test byte [gmode], 1
        jne short .done
        mov edx, dword [byte ecx+Yvel-2]
        sar edx, 10h
        mov eax, dword [byte ecx+Xvel-2]
        sar eax, 10h
        mov ebx, edx
        or ebx, eax
        je short .setrev
        call vtoa
        cwde
        mov edx, dword [byte esp+06h]
        sar edx, 10h
        sub eax, edx
        inc eax
        and eax, byte 7
        cmp eax, byte 2
        jg short .done
.setrev:
        or byte [byte ecx+pflags], 10h          ; bset pfrev
        jmp short .done
.clrrev:
        and byte [byte ecx+pflags], 0EFh        ; bclr pfrev
.done:
        mov eax, dword [byte esp+08h]
        sub ax, word [byte ecx+facedir]
        xor ah, ah
        and al, 7
        movsx edx, ax
        cmp dword [nosplit edx*4+doplayeracc_ftab], byte 0 ; doplayeracc_ftab: 0 = no turn
        jne short .6
        mov ebx, dword [byte ecx+facedir-2]
        sar ebx, 10h
        mov eax, ecx
        call noturn0
        jmp near .x
.6:
        mov ebx, dword [byte ecx+Xvel-2]
        sar ebx, 10h
        mov edx, dword [byte ecx+Yvel-2]
        sar edx, 10h
        imul ebx, ebx
        imul edx, edx
        add edx, ebx
        sar edx, 10h
        mov dword [regd3], edx
        mov dx, word [regd3]
        mov ebx, 300h                           ; turn rate $300-speed
        sub ebx, edx
        mov word [regd4], bx
        cmp bx, 180h                            ; at least $180
        jge short .iok
        mov word [regd4], 180h
.iok:
        movsx edx, ax
        mov ebx, dword [regd4-2]
        sar ebx, 10h
        mov edx, dword [nosplit edx*4+doplayeracc_ftab]
        imul ebx, edx
        mov dword [regd4], ebx
        test byte [byte ecx+pflags], 10h
        je short .i0
        neg dword [regd4]
.i0:
        mov edx, dword [regd4]
        add dword [byte ecx+facedir-2], edx     ; add.l d4,facedir(a3)
        and word [byte ecx+facedir], byte 7
        cmp word [regd3], byte 14h              ; speed > 20: turn animation
        jbe near .s3
        cwde
        cmp dword [nosplit eax*4+doplayeracc_ftab], byte 0
        setl al
        mov edx, eax
        and edx, 0FFh
        test byte [byte ecx+attribute], 8       ; attribute bit 3 (flipped)
        setne al
        and eax, 0FFh
        xor eax, edx
        je short .s2
        cmp word [byte ecx+SCnum], byte 10h
        jne short .9
        cmp word [refsignal], byte 0
        jne short .7
        mov bh, byte [gmode]
        test bh, 1
        jne short .8
        test byte [gmode2], 80h
        jne short .7
        test bh, 8
        je short .8
.7:
        mov esi, SPAarmupturnl                          ; referee turn, signalling
        jmp short .13
.8:
        mov esi, SPArefturnl
        jmp short .13
.9:
        mov esi, SPAturnl                           ; SPAturnl
        jmp short .13
.s2:
        cmp word [byte ecx+SCnum], byte 10h
        jne short .12
        cmp word [refsignal], byte 0
        jne short .10
        mov dl, byte [gmode]
        test dl, 1
        jne short .11
        test byte [gmode2], 80h
        jne short .10
        test dl, 8
        je short .11
.10:
        mov esi, SPAarmupturnr
        jmp short .13
.11:
        mov esi, SPArefturnr
        jmp short .13
.12:
        mov esi, SPAturnr                           ; SPAturnr
.13:
        or byte [byte ecx+pflags2], 2           ; bset pf2aip
.s3:
        movsx edx, si
        mov eax, ecx
        call SetSPA
        cmp word [regd3], byte 2                ; cmp #2,d3: bhi noturn
        jbe short .x
        test byte [byte ecx+pflags], 10h
        je short .14
        mov ax, word [byte ecx+facedir]
        xor al, 4                               ; noturn inline: reverse the acc. when skating backwards
        cwde
        jmp short .15
.14:
        mov eax, dword [byte ecx+facedir-2]
        sar eax, 10h
.15:
        movsx edx, ax
        mov eax, ecx
        call playeracc                          ; playeracc
.x:
        add esp, byte 0Ch
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; EvadePlayers                                 5E4C4  95 PC, medium confidence
; skateto collision routine. eax = player struct. Behind the net (|Ypos|>F2h,
; |Xpos|<32h): regd0 = a direction round the net from the Xpos/Yvel signs.
;
; Else for every other SortCords entry (0-14, not the goalies 12/13): if the
; predicted x and y gaps (pos + Xvel/Yvel high byte) are both within 28h and
; the closest so far, regd0 = a sidestep direction from vtoa of the gap.
;
; No result.
;-----------------------------------------------------------------------------
; C: src/engine/skate/EvadePlayers.c
%ifdef CBUILD
%include "c/engine/skate/EvadePlayers.inc"
%else
EvadePlayers:
        push dword 30h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 14h
        mov ebx, eax
        test byte [byte eax+pflags2], 20h
        jne near .x
        cmp word [byte ebx+Ypos+2], byte 0
        jge short .1
        mov esi, dword [byte ebx+Ypos]
        sar esi, 10h
        neg esi
        jmp short .2
.1:
        mov esi, dword [byte ebx+Ypos]
        sar esi, 10h
.2:
        cmp si, 0A2h
        jle near .11
        cmp si, 0F2h
        jle near .11
        cmp word [byte ebx+Xpos+2], byte 0
        jge short .3
        mov eax, dword [ebx]
        sar eax, 10h
        neg eax
        jmp short .4
.3:
        mov eax, dword [ebx]
        sar eax, 10h
.4:
        cmp eax, byte 32h
        jge near .11
        cmp word [byte ebx+Ypos+2], byte 0
        jle short .9
        cmp word [byte ebx+Yvel], byte 0
        jle short .6
        cmp word [byte ebx+Xpos+2], byte 0
        jge short .5
        mov eax, 7
        jmp short .7
.5:
        mov eax, 1
        jmp short .7
.6:
        cmp word [byte ebx+Xpos+2], byte 0
        jge short .8
        mov eax, 6
.7:
        mov word [regd0], ax
        jmp near .x
.8:
        mov eax, 2
        jmp short EvadePlayers.7
.9:
        cmp word [byte ebx+Yvel], byte 0
        jge short EvadePlayers.6
        cmp word [byte ebx+Xpos+2], byte 0
        jge short .10
        mov eax, 5
        jmp short EvadePlayers.7
.10:
        mov eax, 3
        jmp short EvadePlayers.7
.11:
        mov word [byte esp+010h], 64h
        mov ecx, SortCords
        xor edi, edi
        jmp near .26
.loop:
        cmp di, byte 0Ch
        je near .next
        cmp di, byte 0Dh
        je near .next
        cmp di, byte 0Eh
        jne short .12
        cmp word [byte esp+010h], byte 50h
        jle near .next
.12:
        mov dx, word [byte ebx+Xpos+2]
        mov si, word [byte ecx+Xpos+2]
        sub edx, esi
        mov word [regd2], dx
        movsx ax, byte [byte ebx+Xvel+1]
        mov dword [byte esp+0Ch], eax
        movsx ax, byte [byte ecx+Xvel+1]
        mov esi, dword [byte esp+0Ch]
        sub esi, eax
        mov eax, esi
        mov esi, edx
        add esi, eax
        mov word [regd2], si
        test si, si
        jge short .13
        mov eax, dword [regd2-2]
        sar eax, 10h
        neg eax
        jmp short .14
.13:
        mov eax, dword [regd2-2]
        sar eax, 10h
.14:
        mov word [regd2], ax
        cmp ax, 28h
        jg near .next
        mov si, word [byte ebx+Ypos+2]
        mov ax, word [byte ecx+Ypos+2]
        sub esi, eax
        mov word [regd1], si
        movsx ax, byte [byte ebx+Yvel+1]
        mov dword [byte esp+0Ch], eax
        movsx ax, byte [byte ecx+Yvel+1]
        mov dword [byte esp+08h], eax
        mov eax, dword [byte esp+0Ch]
        sub eax, dword [byte esp+08h]
        add eax, esi
        mov word [regd1], ax
        test ax, ax
        jge short .15
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .16
.15:
        mov eax, dword [regd1-2]
        sar eax, 10h
.16:
        mov dword [byte esp+04h], eax
        mov eax, dword [byte esp+04h]
        mov word [regd1], ax
        cmp ax, 28h
        jg near .next
        mov eax, dword [regd2-2]
        sar eax, 10h
        mov ebp, dword [regd1-2]
        sar ebp, 10h
        add ebp, eax
        mov eax, dword [byte esp+0Eh]
        sar eax, 10h
        cmp eax, ebp
        jle near .next
        mov ax, word [regd2]
        add ax, word [regd1]
        mov word [byte esp+010h], ax
        movsx eax, si
        movsx edx, dx
        mov dword [esp], edx
        mov edx, eax
        mov eax, dword [esp]
        call vtoa
        mov word [regd0], ax
        mov edx, dword [ebx]
        sar edx, 10h
        cmp edx, 0FFFFFF7Eh
        jge short .19
        cmp ax, 4
        jle near .next
        cmp ax, 8
.17:
        jge near .next
        cmp word [byte ecx+Yvel], byte 0
        je short .18
        mov eax, 4
        jmp near .25
.18:
        xor eax, eax
        jmp near .25
.19:
        cmp word [byte ebx+Xpos+2], 82h
        jle short .20
        test ax, ax
        jle near .next
        cmp ax, 4
        jmp short EvadePlayers.17
.20:
        cmp edx, byte 0FFFFFF9Ch
        jle short .23
        cmp word [byte ebx+Xpos+2], byte 0
        jge short .23
        test ax, ax
        jle near .next
        cmp ax, 4
        jge near .next
        mov edx, 8
        sub edx, eax
        mov word [regd0], dx
        cmp dx, byte 6
        jne short .21
        cmp word [byte ecx+Yvel], byte 0
        je short .21
        test si, si
        setl al
        and eax, 0FFh
        add eax, byte 4
        jmp near .25
.21:
        test si, si
        jg short .22
        xor eax, eax
        jmp near .25
.22:
        mov eax, 7
        jmp short .25
.23:
        mov ax, word [byte ebx+Xpos+2]
        cmp ax, 64h
        jge short .next
        test ax, ax
        jl short .next
        mov ax, word [regd0]
        cmp ax, 4
        jle short .next
        cmp ax, 8
        jge short .next
        mov eax, 8
        mov dx, word [regd0]
        sub eax, edx
        mov word [regd0], ax
        cmp ax, 2
        jne short .24
        cmp word [byte ecx+Yvel], byte 0
        je short .24
        test si, si
        setge al
        and eax, 0FFh
        add eax, byte 3
        jmp short .25
.24:
        test si, si
        setg al
        and eax, 0FFh
.25:
        mov word [regd0], ax
.next:
        inc edi
        add ecx, 80h
.26:
        cmp di, byte 0Fh
        jl near EvadePlayers.loop
.x:
        add esp, byte 14h
EvadePlayers_popebp:
        pop ebp
EvadePlayers_popedi:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; EvadePC                                             5E7FE  93G logic93_3.asm
; player should avoid the puck carrier (player a3 should avoid the puck carrier if he's on my team).
; eax = player struct; skateto's a0 routine (passed in edx). Result in regd0 (a direction).
;-----------------------------------------------------------------------------
; C: src/engine/skate/EvadePlayers.c (EvadePC)
%ifdef CBUILD
%include "c/engine/skate/EvadePlayers.EvadePC.inc"
%else
EvadePC:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 4
        mov ebx, eax
        mov ecx, dword [puckc]
        mov ah, byte [ecx]
        test ah, ah
        jl near EvadePC_x                       ; no puck handler
        movsx ecx, ah
        shl ecx, 7
        add ecx, SortCords
        mov ax, word [byte ebx+Xpos+2]
        sub ax, word [byte ecx+Xpos+2]
        movsx si, byte [byte ebx+Xvel+1]
        movsx dx, byte [byte ecx+Xvel+1]
        sub esi, edx
        add esi, eax
        mov word [regd2], si
        test si, si
        jge short .1
        mov edx, dword [regd2-2]
        sar edx, 10h
        neg edx
        jmp short .2
.1:
        mov edx, dword [regd2-2]
        sar edx, 10h
.2:
        cmp edx, byte 28h                       ; cmp.w #40,d2
        jg near EvadePC_x
        mov dx, word [byte ebx+Ypos+2]
        sub dx, word [byte ecx+Ypos+2]
        movsx si, byte [byte ebx+Yvel+1]
        mov dword [esp], esi
        movsx si, byte [byte ecx+Yvel+1]
        mov edi, dword [esp]
        sub edi, esi
        mov esi, edi
        add esi, edx
        mov word [regd1], si
        test si, si
        jge short .3
        mov esi, dword [regd1-2]
        sar esi, 10h
        neg esi
        jmp short .4
.3:
        mov esi, dword [regd1-2]
        sar esi, 10h
.4:
        cmp esi, byte 28h
        jg near EvadePC_x
        mov word [regd0], ax
        mov word [regd1], dx
        movsx edx, dx
        cwde
        call vtoa
        mov word [regd0], ax
        test byte [gameopts], 2                 ; gameopts bit 1: offsides on (gmode)
        je short EvadePC_x
        test byte [byte ebx+pflags], 80h
        jne short .5
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
        neg eax
        jmp short .y
.5:
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
.y:
        sub eax, byte 4Eh                       ; subi #$58
        mov word [regd1], ax
        cmp ax, 0Ah                             ; cmp.w #10,d1
        jg short EvadePC_x
        mov eax, dword [regd1-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFCEh                ; cmp.w #-50,d1
        jl short EvadePC_x
        mov ax, word [byte ebx+Xpos+2]
        mov word [regd1], ax
        cmp ax, word [byte ecx+Xpos+2]
        jle short .6
        mov word [regd0], 2
        jmp short EvadePC_x
.6:
        mov word [regd0], 6
EvadePC_x:
        add esp, byte 4
        jmp near EvadePlayers_popedi
%endif ; C
;-----------------------------------------------------------------------------
; skateto                                               5E93B  94G logic94.asm
; player skates to the point regd0/regd1 (;a0 = extra routine for collision
; avoidance, d0/d1 = x/y cord to skate to). eax = player, edx = routine
;
; to call (0 = none), regd0/regd1 = target.
;
; Every 12 ticks (temp2+1 countdown): avdgoal, aim with the velocity lead,
; vtoa (9 = close enough), the routine, keep the direction in temp2; stopped
; with no direction -> face the puck (or xc1/yc1 in a fight).
;
; Then doplayeracc.
;-----------------------------------------------------------------------------
; C: src/engine/skate/EvadePlayers.c (skateto)
%ifdef CBUILD
%include "c/engine/skate/EvadePlayers.skateto.inc"
%else
skateto:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 4
        mov ebx, eax
        mov dword [esp], edx
        mov ah, byte [byte eax+temp2+1]
        dec ah
        mov byte [byte ebx+temp2+1], ah
        test ah, ah
        jge near .ex                            ; only execute every 12/60 sec.
        mov edx, dword [regd0-2]
        sar edx, 10h
        mov ecx, dword [regd1-2]
        sar ecx, 10h
        mov al, ah
        add al, 0Ch
        mov byte [byte ebx+temp2+1], al
        mov eax, ebx
        call avdgoal                            ; avdgoal
        mov esi, dword [byte ebx+Xvel-2]
        sar esi, 18h
        mov eax, dword [ebx]
        sar eax, 10h
        add eax, esi
        mov edi, dword [byte ebx+Yvel-2]
        sar edi, 18h
        mov esi, dword [byte ebx+Ypos]
        sar esi, 10h
        add esi, edi
        sub word [regd0], ax
        sub word [regd1], si
        sub edx, eax
        sub ecx, esi
        test edx, edx
        jge short .1
        neg edx
.1:
        test ecx, ecx
        jge short .2
        neg ecx
.2:
        cmp word [regd0], byte 0
        jge short .3
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .4
.3:
        mov eax, dword [regd0-2]
        sar eax, 10h
.4:
        cmp eax, byte 0Ch
        jg short .vt
        cmp word [regd1], byte 0
        jge short .5
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .6
.5:
        mov eax, dword [regd1-2]
        sar eax, 10h
.6:
        cmp eax, byte 0Ch
        jg short .vt
        cmp edx, byte 0Ch
        jle short .7
        cmp word [byte ebx+Xvel], byte 0
        je short .vt
.7:
        cmp ecx, byte 0Ch
        jle short .8
        cmp word [byte ebx+Yvel], byte 0
        je short .vt
.8:
        mov word [regd0], 9                     ; close enough: no direction
        jmp short .nvt
.vt:
        mov edx, dword [regd1-2]
        sar edx, 10h
        mov eax, dword [regd0-2]
        sar eax, 10h
        call vtoa
        mov word [regd0], ax
.nvt:
        cmp dword [esp], byte 0
        je short .9
        mov eax, ebx
        call dword [esp]                        ; jsr (a0)
.9:
        mov al, byte [regd0]
        mov byte [byte ebx+temp2], al
        cmp word [regd0], byte 7
        jle near .ex
        mov eax, dword [byte ebx+Xvel-2]
        sar eax, 10h
        mov edx, dword [byte ebx+Yvel-2]
        sar edx, 10h
        or eax, edx
        jne near .ex
        test byte [puckpflags2], 1              ; puck in a fight: face xc1/yc1
        je short .10
        mov ax, word [xc1]
        mov word [regd0], ax
        mov ax, word [yc1]
        jmp short .nf
.10:
        mov eax, dword [puckx]
        mov ax, word [eax]
        mov word [regd0], ax
        mov eax, dword [pucky]
        mov ax, word [eax]
.nf:
        mov word [regd1], ax
        mov ax, word [byte ebx+Xpos+2]
        sub word [regd0], ax
        mov ax, word [byte ebx+Ypos+2]
        sub word [regd1], ax
        mov edx, dword [regd1-2]
        sar edx, 10h
        mov eax, dword [regd0-2]
        sar eax, 10h
        call vtoa
        mov dx, word [byte ebx+facedir]         ; face towards puck
        sub dx, ax
        mov word [regd0], dx
        je short .ex
        mov eax, edx
        xor ah, dh
        and al, 4
        cwde
        sar eax, 1
        mov edx, dword [byte ebx+facedir-2]
        sar edx, 10h
        add eax, edx
        dec eax
        and eax, byte 7
        mov word [byte ebx+facedir], ax
.ex:
        mov edx, dword [byte ebx+temp2-3]
        sar edx, 18h
        mov eax, ebx
        call doplayeracc                        ; doplayeracc(temp2 low byte)
        add esp, byte 4
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; skatetopuck                                           5EB17  94G logic94.asm
; player skates to the puck (player a3 should skate to puck). eax = player.
; skatetopuckinit inline (puck pos + half its velocity high byte),
;
; every 10 ticks (goalie 5): avdgoal, aim (PC: straight at the puck when it is
; slow and within 18h, else GetHot + velocity lead), then the sweep check
; (vecdist 900..1444 -> Sweepcheck).
;-----------------------------------------------------------------------------
; C: src/engine/skate/EvadePlayers.c (skatetopuck)
%ifdef CBUILD
%include "c/engine/skate/EvadePlayers.skatetopuck.inc"
%else
skatetopuck:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 4
        mov esi, eax
        mov eax, dword [puckvx]
        movsx eax, byte [byte eax+01h]
        sar eax, 1
        movsx edx, ax
        mov eax, dword [puckx]
        movsx eax, word [eax]
        add eax, edx
        mov word [regd0], ax
        mov eax, dword [puckvy]
        movsx eax, byte [byte eax+01h]
        sar eax, 1
        movsx edx, ax
        mov eax, dword [pucky]
        movsx eax, word [eax]
        add eax, edx
        mov word [regd1], ax
        mov ah, byte [byte esi+temp2+1]
        dec ah
        mov byte [byte esi+temp2+1], ah
        test ah, ah
        jge near .ex
        lea eax, [byte esi+temp2+1]
        cmp word [byte esi+position], byte 0
        jne short .1
        mov ebx, 5
        jmp short .2
.1:
        mov ebx, 0Ah
.2:
        movsx edx, byte [eax]
        add edx, ebx
        mov byte [eax], dl
        mov eax, esi
        call avdgoal
        mov ax, word [regd0]
        mov word [esp], ax
        mov di, word [regd1]
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jl near .7                              ; no puck handler: GetHot path
        mov eax, dword [puckvx]
        mov bx, word [eax]
        test bx, bx
        jge short .3
        movsx eax, bx
        neg eax
        jmp short .4
.3:
        movsx eax, bx
.4:
        cmp eax, 12Ch
        jg short .7
        mov eax, dword [puckvy]
        mov cx, word [eax]
        test cx, cx
        jge short .5
        movsx eax, cx
        neg eax
        jmp short .6
.5:
        movsx eax, cx
.6:
        cmp eax, 12Ch
        jg short .7
        mov edx, dword [byte esi+Ypos]
        sar edx, 10h
        movsx eax, di
        sub eax, edx
        push eax
        mov edx, dword [esi]
        sar edx, 10h
        mov eax, dword [byte esp+02h]
        sar eax, 10h
        sub eax, edx
        push eax
        call vecdist                            ; vecdist(dx,dy)
        add esp, byte 8
        cmp eax, byte 18h
        jbe short .8
.7:
        mov eax, esi
        call GetHot                             ; GetHot
        movsx ax, byte [byte esi+Xvel+1]
        movsx dx, byte [regd0]
        add eax, edx
        mov edx, dword [esp]
        sub edx, eax
        mov ax, word [byte esi+Xpos+2]
        sub edx, eax
        mov word [regd0], dx
        movsx ax, byte [byte esi+Yvel+1]
        movsx dx, byte [regd1]
        add eax, edx
        sub edi, eax
        mov ax, word [byte esi+Ypos+2]
        sub edi, eax
        mov word [regd1], di
        mov edx, dword [regd1-2]
        sar edx, 10h
        mov eax, dword [regd0-2]
        sar eax, 10h
        call vtoa
        jmp short .9
.8:
        movsx ax, byte [byte esi+052h]
.9:
        mov word [regd0], ax
        mov al, byte [regd0]
        mov byte [byte esi+temp2], al
        cmp word [byte esi+position], byte 0    ; goalie skips the sweep check
        je near .ex
        mov edx, dword [puckvy]
        movsx edx, word [edx]
        mov eax, dword [puckvx]
        movsx eax, word [eax]
        call vtoa
        xor al, 4                               ; puck is coming towards players?
        mov word [regd0], ax
        cmp ax, word [byte esi+facedir]
        jne short .15
        mov eax, dword [puckvx]
        mov bx, word [eax]
        test bx, bx
        jge short .10
        movsx eax, bx
        neg eax
        jmp short .11
.10:
        movsx eax, bx
.11:
        cmp eax, 0FA0h
        jge short .14
        mov eax, dword [puckvy]
        mov cx, word [eax]
        test cx, cx
        jge short .12
        movsx eax, cx
        neg eax
        jmp short .13
.12:
        movsx eax, cx
.13:
        cmp eax, 0FA0h
        jl short .15
.14:
        mov eax, 4
        call randomd0
        test ax, ax
        jne near .ex
.15:
        mov eax, dword [puckx]
        mov ax, word [eax]
        mov di, word [byte esi+Xpos+2]
        sub eax, edi
        mov word [regd0], ax
        mov eax, dword [pucky]
        mov ax, word [eax]
        mov dx, word [byte esi+Ypos+2]
        sub eax, edx
        mov word [regd1], ax
        mov edx, dword [regd1-2]
        sar edx, 10h
        mov eax, dword [regd0-2]
        sar eax, 10h
        call vtoa
        cmp ax, word [byte esi+facedir]
        jne short .ex
        mov eax, dword [regd0-2]
        sar eax, 10h
        push eax
        push eax
        call imul32
        mov edi, eax
        add esp, byte 8
        mov eax, dword [regd1-2]
        sar eax, 10h
        push eax
        push eax
        call imul32
        add esp, byte 8
        add edi, eax
        mov dword [regd0], edi
        cmp edi, 384h                           ; 30*30
        jbe short .ex
        cmp edi, 5A4h                           ; 38*38
        ja short .ex
        mov eax, esi
        call Sweepcheck                         ; Sweepcheck
        jmp near EvadePC_x
.ex:
        mov edx, dword [byte esi+temp2-3]
        sar edx, 18h
        mov eax, esi
        call doplayeracc
        jmp near EvadePC_x
%endif ; C
;-----------------------------------------------------------------------------
; playeracc                                             5EDAD  94G logic94.asm
; accelerate player in direction edx (;d2 = direction of acc). eax = player.
; dirtab x/y times (legstr+30h)/64 (PC), wall push test,
;
; accel factor 32-weight/8+legstr (+legstr+20 goalie), max speed check against
; MaxSpeed (referee: fixed 0Fh/0Ch), then the energy drain when fatigue is on
; (getpde/setpde inline).
;-----------------------------------------------------------------------------
; C: src/engine/skate/EvadePlayers.c (playeracc)
%ifdef CBUILD
%include "c/engine/skate/EvadePlayers.playeracc.inc"
%else
playeracc:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        mov ebx, eax
        add edx, edx
        movsx esi, dx
        mov cx, word [nosplit esi*2+dirtab]     ; x inc
        mov si, word [nosplit esi*2+dirtab_y]   ; y inc
        movzx edi, byte [byte eax+legstr]
        movsx edx, cx
        add edi, byte 30h
        imul edx, edi
        mov eax, edx
        sar edx, 1Fh
        shl edx, 6
        LD sbb, eax, edx
        sar eax, 6
        mov ecx, eax
        movsx edx, si
        imul edx, edi
        mov eax, edx
        sar edx, 1Fh
        shl edx, 6
        LD sbb, eax, edx
        sar eax, 6
        mov esi, eax
        cmp word [byte ebx+Wallsin], byte 0     ; wallsin: check acc dir and don't push wall
        je short .nox
        mov eax, dword [byte ebx+Wallsin-2]
        sar eax, 10h
        movsx edx, cx
        xor eax, edx
        test eax, eax
        jge short .nox
        xor ecx, ecx
.nox:
        cmp word [byte ebx+Wallcos], byte 0
        je short .noy
        mov eax, dword [byte ebx+Wallcos-2]
        sar eax, 10h
        movsx edx, si
        xor eax, edx
        test eax, eax
        jl short .noy
        xor esi, esi
.noy:
        xor eax, eax
        mov al, byte [byte ebx+weight]
        sar eax, 3
        movsx edx, ax
        mov eax, 20h
        sub eax, edx
        mov edx, eax
        xor eax, eax
        mov al, byte [byte ebx+legstr]
        add eax, edx
        mov word [regd2], ax
        cmp word [byte ebx+position], byte 0    ; goalie adds legstr again plus 14h
        jne short .ng
        xor ah, ah
        mov al, byte [byte ebx+legstr]
        add eax, 14h
        add word [regd2], ax
.ng:
        movsx eax, cx
        mov edx, dword [regd2-2]
        sar edx, 10h
        imul eax, edx
        sar eax, 5
        mov dword [regd0], eax
        movsx eax, si
        imul edx, eax
        sar edx, 5
        mov dword [regd1], edx
        mov ax, word [byte ebx+Xvel]
        add word [regd0], ax
        mov ax, word [byte ebx+Yvel]
        add word [regd1], ax
        mov edx, dword [regd0-2]
        sar edx, 10h
        imul edx, edx
        mov eax, dword [regd1-2]
        sar eax, 10h
        imul eax, eax
        add edx, eax
        mov dword [regd3], edx
        cmp word [byte ebx+SCnum], byte 10h     ; referee: fixed max speed index
        jne short .5
        test byte [gmode], 1
        je short .3
        cmp word [byte ebx+Ypos+2], byte 0
        jge short .1
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
        neg eax
        jmp short .2
.1:
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
.2:
        cmp eax, byte 74h
        jge short .4
.3:
        mov dword [regd2], 0Fh
        jmp short .6
.4:
        mov dword [regd2], 0Ch
        jmp short .6
.5:
        mov edx, dword [byte ebx+pnum-3]        ; pnum: energy level
        sar edx, 18h
        mov eax, dword [byte ebx+06Ch]
        mov edx, dword [byte eax+edx*2+tmpde-2]
        sar edx, 10h
        xor eax, eax
        mov al, byte [byte ebx+legspd]
        imul eax, edx
        shr eax, 0Ch
        mov dword [regd2], eax
.6:
        mov eax, dword [regd2-2]
        sar eax, 10h
        mov eax, dword [nosplit eax*4+MaxSpeed] ; MaxSpeed[d2]
        mov dword [regd2], eax
        test byte [byte ebx+pflags2], 40h       ; pflags2 bit 6 cuts max speed to 1/8
        je short .ms
        mov esi, eax
        sar esi, 3
        mov dword [regd2], esi
.ms:
        mov eax, dword [regd3]
        cmp eax, dword [regd2]                  ; max speed check
        ja short .sube
        mov ax, word [regd0]
        mov word [byte ebx+Xvel], ax
        mov ax, word [regd1]
        mov word [byte ebx+Yvel], ax
.sube:
        cmp word [byte ebx+SCnum], byte 10h
        je near .x
        test byte [gameopts], 4                 ; gameopts bit 2: fatigue on
        je near .x
        test byte [gmode], 1
        jne near .x
        cmp word [byte ebx+position], byte 0
        je near .x
        mov eax, 80h
        call randomd0                           ; randomd0(80h): 1 in 128 ticks
        mov word [regd0], ax
        test ax, ax
        jne near .x
        mov eax, dword [byte ebx+pnum-3]
        sar eax, 18h
        mov edx, dword [byte ebx+06Ch]
        mov ax, word [byte edx+eax*2+tmpde]
        sub eax, byte 28h                       ; subi.w #$21 (PC 28h)
        mov word [regd0], ax
        cmp ax, 0C00h                           ; cmp.w #$C00,d0
        jge short .9
        test ax, ax
        jge short .7
        xor eax, eax
        jmp short .8
.7:
        mov eax, dword [regd0-2]
        sar eax, 10h
.8:
        mov edx, eax
        mov eax, dword [byte ebx+pnum-3]
        sar eax, 18h
        mov ebx, dword [byte ebx+06Ch]
        mov word [byte ebx+eax*2+tmpde], dx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.9:
        xor eax, eax
        mov al, byte [byte ebx+endurance]
        mov di, word [regd0]
        add edi, eax
        mov word [regd0], di
        cmp di, 1000h                           ; max 1000h
        jle short .10
        mov word [regd0], 1000h
.10:
        cmp word [regd0], byte 0
        jge short .11
        xor edx, edx
        jmp short .12
.11:
        mov edx, dword [regd0-2]
        sar edx, 10h
.12:
        mov ecx, edx
        mov eax, dword [byte ebx+pnum-3]
        sar eax, 18h
        mov edx, dword [byte ebx+06Ch]
        mov word [byte edx+eax*2+tmpde], cx
.x:
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; avdgoal_box                                  5F04E  95 PC, medium confidence
; helper of avdgoal. eax = player, edx/ebx = goal x limits, ecx = goal y,
; [esp+4]/[esp+8] = int* for the side bits of the player and the target
;
; (1/4 x, 2/8 y). Returns eax 1 when the line player->target (regd0/regd1)
; crosses this goal's box, else 0. ret 8.
;-----------------------------------------------------------------------------
; C: src/engine/skate/EvadePlayers.c (avdgoal_box)
%ifdef CBUILD
%include "c/engine/skate/EvadePlayers.avdgoal_box.inc"
%else
avdgoal_box:
        push dword 1Ch
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 0Ch
        mov esi, eax
        mov edi, edx
        mov edx, dword [byte esp+01Ch]
        mov eax, dword [byte esp+020h]
        mov ebp, dword [esi]
        sar ebp, 10h
        mov dword [byte esp+04h], ebp
        mov esi, dword [byte esi+Ypos]
        sar esi, 10h
        mov dword [esp], esi
        mov esi, dword [regd0-2]
        sar esi, 10h
        mov dword [byte esp+08h], esi
        mov esi, dword [regd1-2]
        sar esi, 10h
        mov dword [eax], 0
        mov ebp, dword [eax]
        mov dword [edx], ebp
        cmp edi, dword [esp]
        jle short .1
        mov dword [edx], 4
        cmp esi, edi
        jge short .2
.ret0:
        xor eax, eax
        jmp near .x
.1:
        cmp esi, edi
        jge short .2
        mov dword [eax], 4
.2:
        cmp ebx, dword [esp]
        jle short .3
        cmp esi, ebx
        jl short .4
        mov dword [eax], 1
        jmp short .4
.3:
        mov dword [edx], 1
        cmp esi, ebx
        jge short avdgoal_box.ret0
.4:
        cmp ecx, dword [byte esp+04h]
        jle short .5
        cmp ecx, dword [byte esp+08h]
        jg short .6
        or byte [eax], 2
        jmp short .6
.5:
        or byte [edx], 2
        cmp ecx, dword [byte esp+08h]
        jle short avdgoal_box.ret0
.6:
        neg ecx
        cmp ecx, dword [byte esp+04h]
        jg short .7
        cmp ecx, dword [byte esp+08h]
        jle short .ret1
        or byte [eax], 8
        jmp short .ret1
.7:
        or byte [edx], 8
        cmp ecx, dword [byte esp+08h]
        jg short avdgoal_box.ret0
.ret1:
        mov eax, 1
.x:
        add esp, byte 0Ch
        pop ebp
        pop edi
        pop esi
        ret 8
%endif ; C
        db 08Bh,0C0h
; avdgoal_jt: switch table of avdgoal, indexed by the player's side bits (0-12).
avdgoal_jt:                                     ; used by avdgoal
        dd avdgoal.c0
        dd avdgoal.c1
        dd avdgoal.c2
        dd avdgoal.c3
        dd avdgoal.c4
        dd avdgoal.x
        dd avdgoal.c6
        dd avdgoal.x
        dd avdgoal.c8
        dd avdgoal.c9
        dd avdgoal.x
        dd avdgoal.x
        dd avdgoal.c12
;-----------------------------------------------------------------------------
; avdgoal                          5F151  93G logic93_5.asm, medium confidence
; don't try to skate thru goal (;if d0/d1 cords intersect thru goal then
; provide new d0/d1 cords). eax = player, regd0/regd1 = target,
;
; changed in place. PC rewrite: goal line 0E8h, half-width 2Ch (goalie:
; tighter box), avdgoal_box for each goal, then a 13-case switch on the side
; bits picks the corner to skate to.
;-----------------------------------------------------------------------------
avdgoal:
        push dword 5Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, byte 34h
        push eax
        cmp word [byte eax+position], byte 0    ; goalie or assignment 27h: tighter box
        je short .1
        mov eax, dword [byte eax+assnum-2]
        sar eax, 10h
        add eax, dword [byte ebp-038h]
        cmp byte [byte eax+asslist], 27h
        jne short .2
.1:
        mov eax, 1
        jmp short .3
.2:
        xor eax, eax
.3:
        mov dword [byte ebp-014h], eax
        test eax, eax
        je short .4
        mov esi, 0FFFFFFFAh
        jmp short .5
.4:
        mov esi, 0Ah
.5:
        test byte [gmode], 1                    ; gmclock
        je short .8
        mov eax, dword [byte ebp-038h]
        cmp word [byte eax+SCnum], byte 10h
        jne short .8
        cmp word [regd1], byte 0
        jge short .6
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .7
.6:
        mov eax, dword [regd1-2]
        sar eax, 10h
.7:
        cmp eax, 0E8h
        jge short .8
        mov eax, dword [byte ebp-038h]
        mov eax, dword [byte eax+Ypos]
        sar eax, 10h
        mov edx, dword [regd1-2]
        sar edx, 10h
        xor eax, edx
        test eax, eax
        jge near .x
.8:
        mov edi, dword [byte ebp-038h]
        mov edi, dword [edi]
        sar edi, 10h
        mov eax, dword [byte ebp-038h]
        mov eax, dword [byte eax+Ypos]
        sar eax, 10h
        mov dword [byte ebp-01Ch], eax
        mov eax, dword [regd0-2]
        sar eax, 10h
        mov dword [byte ebp-08h], eax
        mov eax, dword [regd1-2]
        sar eax, 10h
        mov dword [byte ebp-018h], eax
        lea eax, [byte ebp-034h]
        push eax
        lea eax, [byte ebp-030h]
        push eax
        cmp dword [byte ebp-014h], byte 0
        je short .9
        mov eax, 0FFFFFFF8h
        jmp short .10
.9:
        xor eax, eax
.10:
        lea ecx, [byte eax+02Ch]
        mov ebx, 0FCh
        cmp dword [byte ebp-014h], byte 0
        je short .11
        mov edx, 6
        jmp short .12
.11:
        mov edx, 23h
.12:
        mov eax, 0E8h
        sub eax, edx
        mov edx, eax
        mov eax, dword [byte ebp-038h]
        call avdgoal_box
        test eax, eax
        je near .19
        mov edx, 0FDh
        cmp dword [byte ebp-014h], byte 0
        je short .13
        mov eax, 7
        jmp short .14
.13:
        mov eax, 24h
.14:
        mov ebx, 0E8h
        sub ebx, eax
        mov eax, ebx
        neg dword [byte ebp-01Ch]
        neg dword [byte ebp-018h]
        mov dword [byte ebp-020h], 0E8h
        mov ebx, dword [byte ebp-038h]
        test byte [byte ebx+pflags], 80h
        je short .15
        mov ebx, dword [byte ebx+070h]
        jmp short .16
.15:
        mov ebx, dword [byte ebx+06Ch]
.16:
        mov ebx, dword [dword ebx+0F8h]
        sar ebx, 10h
        mov dword [byte ebp-0Ch], ebx
        mov ecx, dword [byte ebp-0Ch]
        test ecx, ecx
        jl short .17
        mov ebx, ecx
        shl ebx, 7
        mov ecx, SortCords
        add ecx, ebx
        mov dword [byte ebp-010h], ecx
.17:
        mov bl, byte [byte ebp-030h]
        test bl, 5
        je short .18
        mov bh, bl
        xor bh, 5
        mov byte [byte ebp-030h], bh
.18:
        mov cl, byte [byte ebp-034h]
        test cl, 5
        je near .28
        mov ch, cl
        xor ch, 5
        mov byte [byte ebp-034h], ch
        jmp near .28
.19:
        lea eax, [byte ebp-034h]
        push eax
        lea eax, [byte ebp-030h]
        push eax
        cmp dword [byte ebp-014h], byte 0
        je short .20
        mov eax, 0FFFFFFF8h
        jmp short .21
.20:
        xor eax, eax
.21:
        lea ecx, [byte eax+02Ch]
        cmp dword [byte ebp-014h], byte 0
        je short .22
        mov eax, 6
        jmp short .23
.22:
        mov eax, 23h
.23:
        lea ebx, [dword eax-0E8h]
        mov edx, 0FFFFFF04h
        mov eax, dword [byte ebp-038h]
        call avdgoal_box
        test eax, eax
        je near .x
        mov edx, 0FFFFFF03h
        cmp dword [byte ebp-014h], byte 0
        je short .24
        mov eax, 7
        jmp short .25
.24:
        mov eax, 24h
.25:
        sub eax, 0E8h
        mov dword [byte ebp-020h], 0FFFFFF18h
        mov ebx, dword [byte ebp-038h]
        test byte [byte ebx+pflags], 80h
        je short .26
        mov ebx, dword [byte ebx+06Ch]
        jmp short .27
.26:
        mov ebx, dword [byte ebx+070h]
.27:
        mov ebx, dword [dword ebx+0F8h]
        sar ebx, 10h
        mov dword [byte ebp-0Ch], ebx
        mov ecx, dword [byte ebp-0Ch]
        test ecx, ecx
        jl short .28
        mov ebx, ecx
        shl ebx, 7
        mov ecx, SortCords
        add ecx, ebx
        mov dword [byte ebp-010h], ecx
.28:
        cmp dword [byte ebp-034h], byte 0
        jne near .53
        cmp dword [byte ebp-01Ch], 0FFFFFF18h
        jl near .45
        cmp dword [byte ebp-014h], byte 0
        je short .36
        cmp dword [byte ebp-018h], 0FFFFFF18h
        jl near .x
        mov word [regd1], ax
        mov ecx, dword [byte ebp-08h]
        test ecx, ecx
        jl short .34
        lea eax, [byte esi+02Ch]
        cmp eax, ecx
        jle short .31
.29:
        mov eax, 2Ch
        add eax, esi
.30:
        mov word [regd0], ax
.31:
        test edi, edi
        jge short .32
        neg edi
.32:
        cmp edi, byte 26h
        jle near .x
.33:
        mov word [regd1], dx
        jmp near .x
.34:
        mov eax, 0FFFFFFD4h
        sub eax, esi
        inc eax
        cmp eax, ecx
        jg short avdgoal.31
.35:
        mov eax, 0FFFFFFD4h
        sub eax, esi
        jmp short avdgoal.30
.36:
        cmp dword [byte ebp-018h], 0FFFFFF18h
        jge short .42
        mov word [regd1], ax
        cmp dword [byte ebp-0Ch], byte 0
        jl short .37
        mov eax, dword [byte ebp-010h]
        mov eax, dword [eax]
        sar eax, 10h
        mov ebx, dword [byte ebp-08h]
        sub ebx, eax
        mov eax, ebx
        mov ebx, edi
        sub ebx, dword [byte ebp-08h]
        xor eax, ebx
        test eax, eax
        jl short .41
.37:
        test edi, edi
        jge short .38
        mov eax, edi
        neg eax
        jmp short .39
.38:
        mov eax, edi
.39:
        lea ebx, [byte esi+02Ch]
        cmp eax, ebx
        jge near .x
.40:
        test edi, edi
        jl short avdgoal.35
        add esi, byte 2Ch
        mov word [regd0], si
        jmp near avdgoal.31
.41:
        mov eax, dword [byte ebp-010h]
        mov eax, dword [eax]
        sar eax, 10h
        cmp edi, eax
        jl short avdgoal.35
        jmp near avdgoal.29
.42:
        cmp dword [byte ebp-0Ch], byte 0
        jl near .x
        cmp edi, dword [byte ebp-08h]
        jge short .44
        mov edx, dword [byte ebp-010h]
        mov edx, dword [edx]
        sar edx, 10h
        cmp edi, edx
        jge near .x
.43:
        mov word [regd1], ax
        jmp near .x
.44:
        mov edx, dword [byte ebp-010h]
        mov edx, dword [byte edx+04h]
        sar edx, 10h
        cmp edi, edx
        jl near .x
        jmp short avdgoal.43
.45:
        cmp dword [byte ebp-018h], 0FFFFFF18h
        jl near .x
        mov ebx, 0FFFFFFD4h
        sub ebx, esi
        inc ebx
        cmp edi, ebx
        jge short .46
        mov edx, 0FFFFFFD4h
        sub edx, esi
        jmp short .50
.46:
        lea ebx, [byte esi+02Ch]
        cmp edi, ebx
        jl short .48
.47:
        mov edx, 2Ch
        add edx, esi
        jmp short .50
.48:
        mov word [regd1], dx
        mov ecx, dword [byte ebp-08h]
        test ecx, ecx
        jl short .49
        lea edx, [byte esi+02Ch]
        cmp edx, ecx
        jle short .51
        jmp short avdgoal.47
.49:
        mov edx, 0FFFFFFD4h
        sub edx, esi
        inc edx
        cmp edx, ecx
        jg short .51
        mov edx, 0FFFFFFD4h
        sub edx, esi
.50:
        mov word [regd0], dx
.51:
        test edi, edi
        jge short .52
        neg edi
.52:
        cmp edi, byte 26h
        jle near .x
        jmp near avdgoal.43
.53:
        mov ecx, dword [byte ebp-030h]
        cmp ecx, byte 0Ch
        ja near .x
        mov ebx, ecx
        shl ebx, 2
        mov dword [byte ebp-02Ch], ebx
        mov ebx, esi
        add ebx, byte 2Ch
        lea ecx, [byte esi+02Ch]
        mov dword [byte ebp-028h], ecx
        mov ecx, 0FFFFFFD4h
        sub ecx, esi
        mov dword [byte ebp-04h], ecx
        mov ecx, 0FFFFFFD4h
        sub ecx, esi
        inc ecx
        mov dword [byte ebp-024h], ecx
        mov ecx, dword [byte ebp-02Ch]
        jmp dword [dword cs:ecx+avdgoal_jt]     ; avdgoal_jt
.c0:
        cmp dword [byte ebp-01Ch], 0FFFFFF18h
        jl near .66
        cmp dword [byte ebp-014h], byte 0
        je short .59
        test byte [byte ebp-034h], 1
        jne near .x
        mov word [regd1], ax
        mov edi, dword [byte ebp-08h]
        test edi, edi
        jl short .56
        lea eax, [byte esi+02Ch]
        cmp eax, edi
.54:
        jle near .x
.55:
        mov eax, 2Ch
        add eax, esi
        jmp near .73
.56:
        mov eax, 0FFFFFFD4h
        sub eax, esi
        inc eax
        cmp eax, edi
.57:
        jg near .x
.58:
        mov eax, 0FFFFFFD4h
        sub eax, esi
        jmp near .73
.59:
        cmp dword [byte ebp-018h], 0FFFFFF18h
        jl short .63
        cmp dword [byte ebp-0Ch], byte 0
        jl short .60
        mov eax, dword [byte ebp-010h]
        mov eax, dword [eax]
        sar eax, 10h
        mov ebx, dword [byte ebp-08h]
        sub ebx, eax
        mov eax, edi
        sub eax, dword [byte ebp-08h]
        xor eax, ebx
        test eax, eax
        jl near avdgoal.41
.60:
        test edi, edi
        jge short .61
        mov eax, edi
        neg eax
        jmp short .62
.61:
        mov eax, edi
.62:
        lea ebx, [byte esi+02Ch]
        cmp eax, ebx
        jge near avdgoal.31
        jmp near avdgoal.40
.63:
        mov eax, dword [byte ebp-020h]
        mov word [regd1], ax
        cmp dword [byte ebp-0Ch], byte 0
        jl short .64
        mov eax, dword [byte ebp-010h]
        mov eax, dword [byte eax+Ypos]
        sar eax, 10h
        cmp edi, eax
        jl short avdgoal.58
        jmp near avdgoal.55
.64:
        mov edx, dword [byte ebp-08h]
        test edx, edx
        jl short .65
        lea eax, [byte esi+02Ch]
        cmp eax, edx
        jmp near avdgoal.54
.65:
        mov eax, 0FFFFFFD4h
        sub eax, esi
        inc eax
        cmp eax, edx
        jmp near avdgoal.57
.66:
        mov eax, 0FFFFFFD4h
        sub eax, esi
        inc eax
        cmp edi, eax
        jl near avdgoal.58
        lea eax, [byte esi+02Ch]
        cmp edi, eax
        jge near avdgoal.55
        mov word [regd1], dx
        mov ecx, dword [byte ebp-08h]
        test ecx, ecx
        jl short .67
        lea eax, [byte esi+02Ch]
        cmp eax, ecx
        jmp near avdgoal.54
.67:
        mov eax, 0FFFFFFD4h
        sub eax, esi
        inc eax
        cmp eax, ecx
        jmp near avdgoal.57
.c1:
        mov word [regd1], ax
        test byte [byte ebp-034h], 4
        jne near .x
        mov edi, dword [byte ebp-08h]
        test edi, edi
        jl short .70
        cmp edi, dword [byte ebp-028h]
.68:
        jge near .x
.69:
        mov word [regd0], bx
        jmp near .x
.70:
        cmp edi, dword [byte ebp-024h]
.71:
        jl near .x
.72:
        mov eax, dword [byte ebp-04h]
.73:
        mov word [regd0], ax
        jmp near .x
.c2:
        mov word [regd0], bx
        test byte [byte ebp-034h], 5
        jne near .x
        jmp near avdgoal.43
.c3:
        cmp dword [byte ebp-034h], byte 8
        je near avdgoal.43
        jmp short avdgoal.69
.c4:
        mov word [regd1], dx
        test byte [byte ebp-034h], 1
        je short .x
        mov edx, dword [byte ebp-08h]
        test edx, edx
        jl short .74
        cmp edx, dword [byte ebp-028h]
        jmp short avdgoal.68
.74:
        cmp edx, dword [byte ebp-024h]
        jmp short avdgoal.71
.c6:
        cmp dword [byte ebp-034h], byte 8
        jne short avdgoal.69
        jmp near avdgoal.33
.c8:
        mov edx, dword [byte ebp-04h]
        mov word [regd0], dx
        test byte [byte ebp-034h], 5
        je short .x
        jmp near avdgoal.43
.c9:
        cmp dword [byte ebp-034h], byte 2
        je near avdgoal.43
        jmp short avdgoal.72
.c12:
        cmp dword [byte ebp-034h], byte 2
        je near avdgoal.33
.x:
        mov esp, ebp
        jmp near EvadePlayers_popebp
;-----------------------------------------------------------------------------
; dostop                                                5F745  94G logic94.asm
; player stops. eax = player. |Xvel| or |Yvel| > 1000h: stop animation (SPAstop, sets pf2aip)
; or SPAglide when skating backwards; then stopna.
;-----------------------------------------------------------------------------
; C: src/engine/skate/EvadePlayers.c (dostop)
%ifdef CBUILD
%include "c/engine/skate/EvadePlayers.dostop.inc"
%else
dostop:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        mov ebx, eax
        cmp word [byte eax+Xvel], byte 0
        jge short .1
        mov eax, dword [byte eax+Xvel-2]
        sar eax, 10h
        neg eax
        jmp short .2
.1:
        mov eax, dword [byte eax+Xvel-2]
        sar eax, 10h
.2:
        cmp eax, 1000h                          ; .slim $1000
        jg short .set
        cmp word [byte ebx+Yvel], byte 0
        jge short .3
        mov eax, dword [byte ebx+Yvel-2]
        sar eax, 10h
        neg eax
        jmp short .4
.3:
        mov eax, dword [byte ebx+Yvel-2]
        sar eax, 10h
.4:
        cmp eax, 1000h
        jle near .na
.set:
        test byte [byte ebx+pflags], 10h
        jne short .8
        or byte [byte ebx+pflags2], 2           ; bset pf2aip
        cmp word [byte ebx+SCnum], byte 10h
        jne short .7
        cmp word [refsignal], byte 0
        jne short .5
        mov al, byte [gmode]
        test al, 1
        jne short .6
        test byte [gmode2], 80h
        jne short .5
        test al, 8
        je short .6
.5:
        mov eax, SPAarmupstop                          ; referee stop, signalling
        jmp short .0
.6:
        mov eax, SPArefstop                          ; referee stop
        jmp short .0
.7:
        mov eax, SPAstop                           ; SPAstop
        jmp short .0
.8:
        cmp word [byte ebx+SCnum], byte 10h
        jne short .11
        cmp word [refsignal], byte 0
        jne short .9
        mov dl, byte [gmode]
        test dl, 1
        jne short .10
        test byte [gmode2], 80h
        jne short .9
        test dl, 8
        je short .10
.9:
        mov eax, SPAarmupglide
        jmp short .0
.10:
        mov eax, SPArefglide
        jmp short .0
.11:
        mov eax, SPAglide                           ; SPAglide
.0:
        movsx edx, ax
        mov eax, ebx
        call SetSPA
.na:
        mov eax, ebx
        call stopna                             ; stop with no anim
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; stopna                                                5F82A  94G logic94.asm
; slow player by a step on each axis, no animation change. eax = player.
; PC step 200+legstr (goalie 200+3*legstr); (150).
;-----------------------------------------------------------------------------
; C: src/engine/skate/EvadePlayers.c (stopna)
%ifdef CBUILD
%include "c/engine/skate/EvadePlayers.stopna.inc"
%else
stopna:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        xor ebx, ebx
        mov bl, byte [byte eax+legstr]
        lea edx, [dword ebx+0C8h]               ; step 200+legstr
        cmp word [byte eax+position], byte 0
        jne short .1
        add ebx, ebx                            ; goalie: +2*legstr
        add edx, ebx
.1:
        mov si, word [byte eax+Xvel]
        test si, si
        jge short .xp
        mov ecx, esi
        add ecx, edx
        mov word [byte eax+Xvel], cx
        test cx, cx
        jle short .y
        jmp short .2
.xp:
        mov edi, esi
        sub edi, edx
        mov word [byte eax+Xvel], di
        test di, di
        jge short .y
.2:
        mov word [byte eax+Xvel], 0
.y:
        mov di, word [byte eax+Yvel]
        test di, di
        jge short .yp
        mov esi, edi
        add esi, edx
        mov word [byte eax+Yvel], si
        test si, si
        jle near EvadePlayers_popedi
        jmp short .3
.yp:
        mov ebx, edi
        sub ebx, edx
        mov word [byte eax+Yvel], bx
        test bx, bx
        jge near EvadePlayers_popedi
.3:
        mov word [byte eax+Yvel], 0
        jmp near EvadePlayers_popedi
%endif ; C
;-----------------------------------------------------------------------------
; goalieacc                                           5F8B2  93G logic93_5.asm
; goalie gets acc. in direction edx. eax = goalie. Turns facedir one step
; toward the direction, SPAgskate, playeracc.
;
; PC: when the clock runs, he has no puck and his assignment is 0Fh, he turns
; toward the direction byte at +52h instead.
;-----------------------------------------------------------------------------
; C: src/engine/skate/goalieacc.c
%ifdef CBUILD
%include "c/engine/skate/goalieacc.inc"
%else
goalieacc:
        push dword 0Ch
        call __CHK
        push ebx
        push ecx
        mov ebx, eax
        xor dh, dh
        and dl, 0Fh
        cmp dx, byte 7
        jle short .d1
        cmp dx, byte 9
        jne short .cgl
        mov eax, dword [byte eax+Xvel-2]
        sar eax, 10h
        mov edx, dword [byte ebx+Yvel-2]
        sar edx, 10h
        or eax, edx
        je short .cgl
        mov eax, ebx
        call stopna                             ; stopna
        pop ecx
        pop ebx
        ret
.cgl:
        test byte [byte ebx+pflags2], 2
        jne near .x
        mov edx, 1                              ; SPAgready
        mov eax, ebx
        call SetSPA
        pop ecx
        pop ebx
        ret
.d1:
        test byte [gmode], 1
        jne short .1
        mov eax, dword [puckc]
        movsx ax, byte [eax]
        cmp ax, word [byte ebx+SCnum]
        je short .1
        mov eax, dword [byte ebx+assnum-2]
        sar eax, 10h
        cmp byte [byte ebx+eax+asslist], 0Fh
        jne short .1
        movsx ax, byte [byte ebx+052h]
        cmp ax, word [byte ebx+facedir]
        je short .spa
        mov eax, dword [byte ebx+facedir-2]
        sar eax, 10h
        mov edx, dword [byte ebx+04Fh]
        sar edx, 18h
        mov ecx, eax
        sub ecx, edx
        mov edx, ecx
        and edx, byte 4
        sar edx, 1
        dec edx
        jmp short .2
.1:
        sub dx, word [byte ebx+facedir]
        je short .spa
        movsx eax, dx
        neg eax
        and eax, byte 4
        sar eax, 1
        mov edx, dword [byte ebx+facedir-2]
        sar edx, 10h
        dec eax
.2:
        add eax, edx
        and eax, byte 7
        mov word [byte ebx+facedir], ax
.spa:
        mov edx, SPAgskate                           ; SPAgskate
        mov eax, ebx
        call SetSPA
        mov edx, dword [byte ebx+facedir-2]
        sar edx, 10h
        mov eax, ebx
        call playeracc                          ; playeracc
.x:
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; noturn0                            5F98A  94G logic94.asm, medium confidence
; doplayeracc when the wanted direction needs no turn. eax = player, edx =
; direction minus facedir (0-7), ebx = facedir.
;
; Skating against the motion -> dostop; else skate animation
; (SPAskate/skatewp/skateback) and the inline noturn (reverse when pfrev),
; then playeracc.
;-----------------------------------------------------------------------------
; C: src/engine/skate/noturn0.c
%ifdef CBUILD
%include "c/engine/skate/noturn0.inc"
%else
noturn0:
        push dword 8
        call __CHK
        push ecx
        mov ecx, eax
        mov word [regd4], 2                     ; moveq #2,d4
        test byte [byte eax+pflags], 10h
        je short .0
        xor dl, 4
        mov word [regd4], 6                     ; addq #4,d4
.0:
        test dx, dx
        je near .nochg
        mov edx, dword [byte ecx+Yvel-2]
        sar edx, 10h
        mov eax, dword [byte ecx+Xvel-2]
        sar eax, 10h
        call vtoa                               ; vtoa(Xvel,Yvel)
        mov word [regd0], ax
        test al, 8                              ; not moving
        jne short .nostop
        sub ax, word [byte ecx+facedir]
        add ax, word [regd4]
        xor ah, ah
        and al, 7
        mov word [regd0], ax
        cmp ax, 4
        jge short .nostop
        mov eax, ecx
        call dostop                             ; dostop
        pop ecx
        ret
.nostop:
        test byte [byte ecx+attribute], 8
        je short .1
        dec word [byte ecx+facedir]
        jmp short .nos0
.1:
        inc word [byte ecx+facedir]
.nos0:
        mov ax, word [byte ecx+facedir]
        xor ah, ah
        and al, 7
        mov word [byte ecx+facedir], ax
        test byte [byte ecx+pflags], 10h
        je short .2
        mov eax, SPAglideback                           ; SPAglideback
        jmp short .6
.2:
        cmp word [byte ecx+SCnum], byte 10h
        jne short .5
        cmp word [refsignal], byte 0
        jne short .3
        mov dh, byte [gmode]
        test dh, 1
        jne short .4
        test byte [gmode2], 80h
        jne short .3
        test dh, 8
        je short .4
.3:
        mov eax, SPAarmupglide
        jmp short .6
.4:
        mov eax, SPArefglide
        jmp short .6
.5:
        mov eax, SPAglide                           ; SPAglide
.6:
        movsx edx, ax
        mov eax, ecx
        call SetSPA
        pop ecx
        ret
.nochg:
        test byte [byte ecx+pflags], 10h
        jne near .12
        cmp word [byte ecx+SCnum], byte 10h
        jne short .9
        cmp word [refsignal], byte 0
        jne short .7
        mov al, byte [gmode]
        test al, 1
        jne short .8
        test byte [gmode2], 80h
        jne short .7
        test al, 8
        je short .8
.7:
        mov eax, SPAarmupskate                          ; referee skate, signalling
        jmp short .ns
.8:
        mov eax, SPArefskate
        jmp short .ns
.9:
        mov edx, dword [puckc]
        movsx ax, byte [edx]
        cmp ax, word [byte ecx+SCnum]
        jne short .10
        mov eax, SPAskatewp                           ; SPAskatewp
        jmp short .ns
.10:
        test byte [byte ecx+pflags2], 40h
        je short .11
        mov eax, SPAstumble                           ; (pflags2 bit 6)
        jmp short .ns
.11:
        mov eax, SPAskate                           ; SPAskate
        jmp short .ns
.12:
        mov eax, SPAskateback                           ; SPAskateback
.ns:
        test byte [byte ecx+pflags2], 2         ; pf2aip
        jne short .noturn
        movsx edx, ax
        mov eax, ecx
        call SetSPA
.noturn:
        test byte [byte ecx+pflags], 10h
        je short .13
        xor bl, 4
.13:
        movsx eax, bx
        movsx edx, ax
        mov eax, ecx
        call playeracc
        pop ecx
        ret
%endif ; C
