; Body checks: sweep check, burst, shot blocks, check aggression and the check decision (94G collide94 / logic94).
bits 32
%include "hockey.inc"
section s_53294 progbits alloc exec nowrite align=1
extern __CHK, Acheck, AddPenalty, Bcheck, blockspd, blockspd_y, c1playernum, CanBlockShot
extern CheckBump, checkinglist_m2, checkob, checkob_ret5, dirtab, dirtab_y, FallDown, gameopts
extern gmode, gmode2, gsp, holdcheck, lastimpact, nethit, penshotctl, penshotplayer
extern puckc, puckvz, puckx, pucky, puckz, QuickShotChk, randomd0, refhitcount
extern regd0, regd1, regd2, SetSPA, SortCords, vecdist, vtoa, wallcoll
extern wcradiusx, wcradiusy
global ToFixed, Sweepcheck, burst, BlockShotDive, TryBlockShot, check4check, checkagr, FacingBoards
global checkcheck, checkgoalp, checkint
;-----------------------------------------------------------------------------
; ToFixed                                                         53294  95 PC
; Eax << 16 (integer to 16.16); passtoa0 calls it
;-----------------------------------------------------------------------------
; C: src/engine/checking/ToFixed.c
%ifdef CBUILD
%include "c/engine/checking/ToFixed.inc"
%else
ToFixed:
        push dword 4
        call __CHK
        shl eax, 10h
        ret
%endif ; C
;-----------------------------------------------------------------------------
; Sweepcheck                         532A2  94G logic94.asm, medium confidence
; Genesis comment (logic94.asm): start sweep check on player a3
;-----------------------------------------------------------------------------
; C: src/engine/checking/Sweepcheck.c
%ifdef CBUILD
%include "c/engine/checking/Sweepcheck.inc"
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
; C: src/engine/pass/checkob.c (burst)
%ifdef CBUILD
%include "c/engine/pass/checkob.burst.inc"
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
; C: src/engine/checking/BlockShotDive.c
%ifdef CBUILD
%include "c/engine/checking/BlockShotDive.inc"
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
; C: src/engine/checking/TryBlockShot.c
%ifdef CBUILD
%include "c/engine/checking/TryBlockShot.inc"
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
; check4check (53537; 93G logic93 check4check, "look for good opportunity for
; checking opponent"): the odds are 20 - p's checking rating (93G aggress),
; half again with penalties on (gameopts bit 0); a roll of randomd0(twice
; that) over 8 (93G: over 3) skips. Otherwise walk the six opponents: one on
; the ice (position), not animation-locked (pfalock) and not fighting
; (pflags2 bit 0), within 30 in x and y, straight ahead of p (vtoa of the
; offset equals facedir) gets checked: 1 in 4 Acheck, else burst. PC: with
; nobody to check, p may try to block a shot (TryBlockShot). regd0-regd2 hold
; the 68k d0-d2. p: the player. No result.
;-----------------------------------------------------------------------------
; C: src/engine/pass/checkob.c (check4check)
%ifdef CBUILD
%include "c/engine/pass/checkob.check4check.inc"
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
; Random roll for an aggressive act (fight penalty) by p: range (20 -
; aggress) * 16, doubled with pflags bit 3, halved within 40 of the puck in
; both x and y, x8 after the second period, doubled without gameopts bit 9,
; x4 per power-play man down (other tmap - own tmap >= 1, >= 2) and x4
; against the puck carrier's team during a stoppage; randomd0 of 1.5 times
; that. Returns 0 for a hit.
;-----------------------------------------------------------------------------
; C: src/engine/checking/checkagr.c
%ifdef CBUILD
%include "c/engine/checking/checkagr.inc"
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
; C: src/engine/checking/FacingBoards.c
%ifdef CBUILD
%include "c/engine/checking/FacingBoards.inc"
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
; Genesis comment (collide94.asm): check for player a3 collision with
; goal/net a2. Entered from checkgoal.
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
; C: src/engine/checking/checkint.c
%ifdef CBUILD
%include "c/engine/checking/checkint.inc"
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
