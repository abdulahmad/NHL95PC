; Collision tests: players, boards, goal, the wall bounce.
bits 32
%include "hockey.inc"
%include "spa.inc"
section s_58084 progbits alloc exec nowrite align=1
extern __CHK, AddPenalty2, checkcheck, checkgoalp, checkint, collflag, Crowdlevel, CwdExciteLvl
extern dopass_ret6, doplayeracc, EndPenaltyShot, GetHot, gmode, gmode2, Goal, lastimpact
extern lasttouch, ltack, lty, nethit, onetimerflag, OOlist, OOlistpos, passplayer
extern puckc, puckflip, pucky, randomd0, regd0, regd1, regd1_b1, regd2
extern regd3, regd3_m2, regd4, regd5, SetSPA, sflags, sfx, shotongoal
extern SortCords, vecdist, vtoa, wcradiusx, wcradiusy, LastShooterTeam, Ylist
global newcheck, checkcoll, checkwallcoll, checkgoal, wallcoll, wallcollb, checkplcoll, checkcx
;-----------------------------------------------------------------------------
; newcheck                       58084  93G hockey93_03.asm, medium confidence
; newcheck: random check sound (sfx, randomd0); called from checkcx and
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
        cmp bx, SPAboardback
        jl short .4
        cmp bx, SPAbenchcheckl
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
; checkwallcoll: vecdist against the corner radius, wallcollb, checkgoal
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
; checkgoal (coll with goal/net): checkgoalp for players, Goal for the
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
        mov di, word [Crowdlevel]
        cmp di, 4B0h
        jg short .7
        mov eax, edi
        add eax, 1F4h
        mov word [Crowdlevel], ax
        cmp ax, 4B0h
        jle short .7
        mov word [Crowdlevel], 4B0h
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
; wallcoll (bounce off a wall with cos/sin): randomd0, puckflip, sfx;
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
; Check for the puck over the wall (called from checkwallcoll). Not the puck
; (SCnum 0Eh), or Zpos up to 12h: wallcoll.
;
; Zpos above 1Dh, or above 12h with Ypos below F8h: out of play.
;
; Otherwise only at |Xpos| 28h-38h with Yvel >= FA0h and lty >= 26h (else
; wallcoll): halve Yvel, SPA 821h on the next struct (the glass) at x 3Fh -40h
; (by the puck's side), y 10Bh, sfx AEh, Crowdlevel +1200 (max 1500)
;
; and CwdExciteLvl +15, then out of play.
;
; Out of play: sfslock (sflags bit 6), pfnc (pflags bit 2), attribute bit 15
; when Ypos < 0, the next struct's frame -1 and, while the clock runs, penalty
; 3 for the last player to touch the puck (lasttouch); the penalty shot ends.
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
        mov edx, SPAbglass
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
        mov dx, word [Crowdlevel]
        cmp dx, 5DCh
        jg short .11
        mov ecx, edx
        add ecx, 4B0h
        mov word [Crowdlevel], cx
        cmp cx, 5DCh
        jle short .11
        mov word [Crowdlevel], 5DCh
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
; check collision with other players. d2/d3
; = x/y cords, a3 = struct. Walk
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
        mov word [LastShooterTeam], ax
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
