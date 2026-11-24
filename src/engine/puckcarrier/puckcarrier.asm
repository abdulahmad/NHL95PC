; Puck carrier assignments: carry, pass or shoot, nearest player, faceoff entry.
bits 32
%include "hockey.inc"
%include "spa.inc"
section s_4C6F3 progbits alloc exec nowrite align=1
extern __CHK, assgoalie, assgoalie_popebp, assinsert, asspuckc_postab2, asspuckc_postab2_y, assreplace, check4bench
extern check4check, checkob, chk4lc, chk4pass, chk4shot, donothing, fofdata2, GetHot
extern gmode, gmode2, penshotplayer, puckc, pucktemp1, puckvx, puckvy, puckx
extern pucky, randomd0, regd0, regd1, regd2, regd3, regd4, SetShotMode
extern SetSPA, sflags, sfx, ShotMode, shotongoal, skateto, skatetopuck, SortCords
extern threat, vtoa
global asspuckc, BehindNetMateDir, asspuckc_chkdir, assnearest, assshoot, assshoot_ret, assfaceoff, assexit
global assfaceoffpl
;-----------------------------------------------------------------------------
; asspuckc                                              4C6F3  94G logic94.asm
; asstab 10h (player has the puck): checkob, chk4lc, chk4shot, chk4pass, then
; skateto with asspuckc_chkdir as the collision routine.
;-----------------------------------------------------------------------------
; C: src/engine/puckcarrier/asspuckc.c
%ifdef CBUILD
%include "c/engine/puckcarrier/asspuckc.inc"
%else
asspuckc:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push edi
        mov ebx, eax
        mov eax, dword [puckc]
        movsx ax, byte [eax]
        cmp ax, word [byte ebx+SCnum]
        je short .2
.1:
        mov eax, ebx
        call assexit
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.2:
        mov ah, byte [byte ebx+pflags]
        test ah, 20h
        jne near .x
        test byte [gmode], 1
        je short .3
        mov eax, ebx
        call donothing
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.3:
        test ah, 8
        jne short asspuckc.1
        test ah, 2
        je short .4
        mov ch, ah
        and ch, 0FDh
        mov byte [byte ebx+pflags], ch
        mov word [byte ebx+04Ch], 0
        mov word [byte ebx+temp1], 0
        mov word [byte ebx+temp2], 8
        mov eax, 4
        call randomd0
        mov word [byte ebx+temp3], ax
        xor ecx, ecx
        mov word [threat], cx
.4:
        mov al, byte [byte ebx+027h]
        dec al
        mov byte [byte ebx+027h], al
        test al, al
        jge near .8
        mov al, byte [byte ebx+059h]
        mov byte [byte ebx+027h], al
        mov eax, ebx
        call checkob
        cmp dword [shotongoal], byte 0
        je short .7
        cmp word [byte ebx+Ypos+2], byte 0
        jge short .5
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
        neg eax
        jmp short .6
.5:
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
.6:
        cmp eax, byte 70h
        jge short .7
        mov edx, 2Eh
        mov eax, ebx
        call assreplace
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.7:
        mov eax, ebx
        call chk4lc
        test ax, ax
        jne near .x
        mov eax, ebx
        call chk4shot
        test ax, ax
        jne near .x
        mov eax, ebx
        call chk4pass
        test ax, ax
        jne near .x
.8:
        test byte [gmode2], 80h
        je short .9
        mov ax, word [byte ebx+position]
        dec eax
        jmp short .10
.9:
        mov ax, word [byte ebx+temp3]
        add eax, 6
.10:
        mov word [regd0], ax
        mov ax, word [regd0]
        add eax, eax
        mov word [regd0], ax
        mov eax, dword [regd0-2]
        sar eax, 10h
        mov dx, word [nosplit eax*2+asspuckc_postab2_y]
        mov word [regd1], dx
        mov ax, word [nosplit eax*2+asspuckc_postab2]
        mov word [regd0], ax
        test byte [byte ebx+pflags], 80h
        jne short .11
        mov edi, eax
        neg edi
        mov word [regd0], di
        neg word [regd1]
.11:
        mov eax, dword [ebx]
        sar eax, 10h
        mov edx, dword [regd0-2]
        sar edx, 10h
        sub eax, edx
        test eax, eax
        jge short .12
        neg eax
.12:
        cmp eax, byte 0Ch
        jg short .14
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
        mov edx, dword [regd1-2]
        sar edx, 10h
        sub eax, edx
        test eax, eax
        jge short .13
        neg eax
.13:
        cmp eax, byte 0Ch
        jg short .14
        mov eax, 4
        call randomd0
        mov word [byte ebx+temp3], ax
.14:
        mov edx, asspuckc_chkdir
        mov eax, ebx
        call skateto
.x:
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; BehindNetMateDir                               4C8BD  95 PC, low confidence
; With p's predicted spot (position + velocity 512) deep in its own end (|y|
; AAh..E8h on p's own side, |x| <= 50h) and its current assignment slot
;
; (byte +1Eh + assnum) not 11h: when the team's player slot +FAh is set, and
; regd1.w is within 20 (checked twice - the EXE tests regd1 rather than the
; gaps), regd0.w = vtoa of the gap to that player's predicted spot.
;-----------------------------------------------------------------------------
; C: src/engine/puckcarrier/BehindNetMateDir.c
%ifdef CBUILD
%include "c/engine/puckcarrier/BehindNetMateDir.inc"
%else
BehindNetMateDir:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        sub esp, byte 4
        mov edx, dword [byte eax+0Ah]
        sar edx, 19h
        mov ebx, dword [eax]
        sar ebx, 10h
        add ebx, edx
        mov ecx, dword [byte eax+0Ch]
        sar ecx, 19h
        mov edx, dword [byte eax+Ypos]
        sar edx, 10h
        add edx, ecx
        mov ecx, dword [byte eax+assnum-2]
        sar ecx, 10h
        cmp byte [byte ecx+eax+01Eh], 11h
        je near .x
        test byte [byte eax+pflags], 80h
        setne cl
        and ecx, 0FFh
        cmp word [byte eax+Ypos+2], byte 0
        setl byte [esp]
        movzx esi, byte [esp]
        xor ecx, esi
        jne near .x
        test edx, edx
        jge short .1
        mov ecx, edx
        neg ecx
        jmp short .2
.1:
        mov ecx, edx
.2:
        cmp ecx, 0AAh
        jl near .x
        test edx, edx
        jge short .3
        mov ecx, edx
        neg ecx
        jmp short .4
.3:
        mov ecx, edx
.4:
        cmp ecx, 0E8h
        jg near .x
        test ebx, ebx
        jge short .5
        mov ecx, ebx
        neg ecx
        jmp short .6
.5:
        mov ecx, ebx
.6:
        cmp ecx, byte 50h
        jg near .x
        mov eax, dword [byte eax+06Ch]
        mov eax, dword [dword eax+0F8h]
        sar eax, 10h
        test eax, eax
        jl near .x
        shl eax, 7
        add eax, SortCords
        mov esi, dword [byte eax+0Ah]
        sar esi, 19h
        mov ecx, dword [eax]
        sar ecx, 10h
        add ecx, esi
        sub ebx, ecx
        cmp word [regd1], byte 0
        jge short .7
        mov ecx, dword [regd1-2]
        sar ecx, 10h
        neg ecx
        jmp short .8
.7:
        mov ecx, dword [regd1-2]
        sar ecx, 10h
.8:
        cmp ecx, byte 14h
        jg short .x
        mov ecx, dword [byte eax+0Ch]
        sar ecx, 19h
        mov eax, dword [byte eax+Ypos]
        sar eax, 10h
        add eax, ecx
        sub edx, eax
        cmp word [regd1], byte 0
        jge short .9
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .10
.9:
        mov eax, dword [regd1-2]
        sar eax, 10h
.10:
        cmp eax, byte 14h
        jg short .x
        movsx edx, dx
        movsx eax, bx
        call vtoa
        mov word [regd0], ax
.x:
        add esp, byte 4
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; asspuckc_chkdir                  4C9FD  93G logic93_3.asm, medium confidence
; asspuckc .chkdir: the skateto collision routine asspuckc passes (mov
; edx, asspuckc_chkdir), picks a direction with vtoa / randomd0
;-----------------------------------------------------------------------------
; C: src/engine/puckcarrier/asspuckc_chkdir.c
%ifdef CBUILD
%include "c/engine/puckcarrier/asspuckc_chkdir.inc"
%else
asspuckc_chkdir:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push edi
        mov ecx, eax
        movsx ax, byte [regd0]
        mov word [regd0], ax
        mov edx, dword [byte ecx+0Ah]
        sar edx, 18h
        mov eax, dword [puckx]
        movsx eax, word [eax]
        add eax, edx
        mov word [regd2], ax
        mov edx, dword [byte ecx+0Ch]
        sar edx, 18h
        mov eax, dword [pucky]
        movsx eax, word [eax]
        add eax, edx
        mov word [regd3], ax
        xor edx, edx
        mov word [threat], dx
        mov ebx, 6
        mov word [regd4], bx
        cmp bx, word [byte ecx+SCnum]
        jle short .1
        mov eax, 6
        jmp short .2
.1:
        xor eax, eax
.2:
        shl eax, 7
        mov ebx, SortCords
        add ebx, eax
.3:
        mov eax, dword [byte ebx+0Ah]
        sar eax, 18h
        mov edx, dword [ebx]
        sar edx, 10h
        add edx, eax
        mov eax, dword [regd2-2]
        sar eax, 10h
        sub edx, eax
        mov word [regd1], dx
        test dx, dx
        jge short .4
        mov edx, dword [regd1-2]
        sar edx, 10h
        neg edx
        jmp short .5
.4:
        mov edx, dword [regd1-2]
        sar edx, 10h
.5:
        cmp edx, byte 19h
        jg near .8
        mov eax, dword [byte ebx+0Ch]
        sar eax, 18h
        mov edx, dword [byte ebx+04h]
        sar edx, 10h
        add eax, edx
        mov edx, dword [regd3-2]
        sar edx, 10h
        sub eax, edx
        mov word [regd1], ax
        test ax, ax
        jge short .6
        mov edx, dword [regd1-2]
        sar edx, 10h
        neg edx
        jmp short .7
.6:
        mov edx, dword [regd1-2]
        sar edx, 10h
.7:
        cmp edx, byte 19h
        jg short .8
        inc word [threat]
        mov ax, word [byte ecx+Ypos+2]
        sub ax, word [byte ebx+06h]
        movsx edx, ax
        mov ax, word [byte ecx+Xpos+2]
        sub ax, word [byte ebx+02h]
        cwde
        call vtoa
        mov word [regd0], ax
        mov dx, word [byte ecx+facedir]
        xor dl, 4
        mov word [regd1], dx
        cmp ax, dx
        jne short .8
        mov eax, 2
        call randomd0
        add ax, word [regd0]
        xor ah, ah
        and al, 7
        mov word [regd0], ax
.8:
        add ebx, 80h
        mov di, word [regd4]
        dec di
        mov word [regd4], di
        jne near asspuckc_chkdir.3
        test byte [byte ecx+pflags], 80h
        setne al
        and eax, 0FFh
        cmp word [byte ecx+Ypos+2], byte 0
        setl dl
        and edx, 0FFh
        xor eax, edx
        jne near .x
        cmp word [regd3], byte 0
        jge short .9
        mov eax, dword [regd3-2]
        sar eax, 10h
        neg eax
        jmp short .10
.9:
        mov eax, dword [regd3-2]
        sar eax, 10h
.10:
        cmp eax, 0AAh
        jl near .x
        cmp word [regd3], byte 0
        jge short .11
        mov eax, dword [regd3-2]
        sar eax, 10h
        neg eax
        jmp short .12
.11:
        mov eax, dword [regd3-2]
        sar eax, 10h
.12:
        cmp eax, 0E8h
        jg near .x
        cmp word [regd2], byte 0
        jge short .13
        mov eax, dword [regd2-2]
        sar eax, 10h
        neg eax
        jmp short .14
.13:
        mov eax, dword [regd2-2]
        sar eax, 10h
.14:
        cmp eax, byte 50h
        jg near .x
        mov eax, dword [byte ecx+06Ch]
        mov ax, word [dword eax+0FAh]
        mov word [regd4], ax
        test ax, ax
        jl near .19
        mov ebx, dword [regd4-2]
        sar ebx, 10h
        shl ebx, 7
        add ebx, SortCords
        mov edx, dword [byte ebx+0Ah]
        sar edx, 18h
        mov eax, dword [ebx]
        sar eax, 10h
        add edx, eax
        mov eax, dword [regd2-2]
        sar eax, 10h
        sub edx, eax
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
        cmp eax, byte 14h
        jg short .19
        mov edx, dword [byte ebx+0Ch]
        sar edx, 18h
        mov eax, dword [byte ebx+04h]
        sar eax, 10h
        add eax, edx
        mov edx, dword [regd3-2]
        sar edx, 10h
        sub eax, edx
        mov word [regd4], ax
        cmp word [regd1], byte 0
        jge short .17
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .18
.17:
        mov eax, dword [regd1-2]
        sar eax, 10h
.18:
        cmp eax, byte 14h
        jg short .19
        mov ax, word [regd4]
        neg eax
        movsx edx, ax
        mov ax, word [regd1]
        neg eax
        cwde
        call vtoa
        mov word [regd0], ax
.19:
        cmp word [regd2], byte 0
        jge short .20
        mov eax, dword [regd2-2]
        sar eax, 10h
        neg eax
        jmp short .21
.20:
        mov eax, dword [regd2-2]
        sar eax, 10h
.21:
        cmp eax, byte 1Eh
        jg short .x
        test byte [byte ecx+pflags], 80h
        je short .22
        mov edx, 0FFFFFF24h
        jmp short .23
.22:
        mov edx, 0DCh
.23:
        mov ax, word [regd3]
        mov ebx, edx
        sub ebx, eax
        mov word [regd1], bx
        test bx, bx
        jge short .24
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .25
.24:
        mov eax, dword [regd1-2]
        sar eax, 10h
.25:
        cmp eax, byte 14h
        jg short .x
        mov ax, word [byte ecx+Ypos+2]
        sub eax, edx
        movsx edx, ax
        mov eax, dword [ecx]
        sar eax, 10h
        call vtoa
        mov word [regd0], ax
.x:
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assnearest                         4CD4B  94G logic94.asm, medium confidence
; Assignment table slot 11h: the player nearest the puck goes after it
;-----------------------------------------------------------------------------
; C: src/engine/goalie/assgoalie.c (assnearest)
%ifdef CBUILD
%include "c/engine/goalie/assgoalie.assnearest.inc"
%else
assnearest:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 0Ch
        mov ebx, eax
        mov esi, eax
        mov eax, dword [byte eax+06Ch]
        mov dword [byte esp+04h], eax
        mov ah, byte [byte ebx+pflags]
        test ah, 2
        je short .1
        mov dl, ah
        and dl, 0FDh
        mov byte [byte ebx+pflags], dl
        mov word [byte ebx+temp1], 0
        mov word [byte ebx+temp2], 8
        mov word [byte ebx+temp3], 0
.1:
        mov eax, dword [puckc]
        movsx ax, byte [eax]
        cmp ax, word [byte ebx+SCnum]
        jne short .3
        cmp word [byte ebx+position], byte 0
        jne short .2
        mov eax, ebx
        call assgoalie
        jmp near .60
.2:
        test byte [byte ebx+pflags], 8
        jne near .60
        mov edx, 10h
        mov eax, ebx
        call assinsert
        jmp near .60
.3:
        mov dh, byte [byte ebx+027h]
        dec dh
        mov byte [byte ebx+027h], dh
        test dh, dh
        jge near .33
        mov al, byte [byte ebx+aioff]
        mov byte [byte ebx+027h], al
        mov eax, dword [byte esp+04h]
        mov dword [byte eax+03Ah], 0
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jl short .4
        cmp word [byte ebx+SCnum], byte 6
        setl al
        xor edx, edx
        mov dl, al
        mov eax, dword [puckc]
        cmp byte [eax], 6
        setl al
        and eax, 0FFh
        cmp eax, edx
        jne short .4
        mov eax, dword [puckc]
        movsx eax, byte [eax]
        shl eax, 7
        mov esi, SortCords
        add esi, eax
        jmp near .15
.4:
        mov ax, word [byte ebx+SCnum]
        mov dword [byte esp+08h], eax
        mov cx, word [byte ebx+Ypos+2]
        mov dword [regd2], 0FFFFFFFFh
        mov edi, 6
        mov word [regd4], di
        cmp di, word [byte ebx+SCnum]
        jle short .5
        xor eax, eax
        jmp short .6
.5:
        mov eax, 6
.6:
        shl eax, 7
        mov edx, SortCords
        add edx, eax
        mov eax, dword [byte ebx+SCnum-2]
        sar eax, 10h
        cmp eax, dword [penshotplayer]
        je near .14
.7:
        cmp word [byte edx+position], byte 0
        jle near .13
        cmp word [byte edx+03Eh], byte 0
        jne near .13
        test byte [byte edx+pflags2], 4
        jne near .13
        mov eax, dword [byte edx+assnum-2]
        sar eax, 10h
        cmp byte [byte edx+eax+01Eh], 13h
        je near .13
        cmp word [byte edx+Ypos+2], byte 0
        jge short .8
        mov eax, dword [byte edx+Ypos]
        sar eax, 10h
        neg eax
        jmp short .9
.8:
        mov eax, dword [byte edx+Ypos]
        sar eax, 10h
.9:
        cmp eax, 0E8h
        jge short .12
        test byte [byte ebx+pflags], 80h
        je short .10
        cmp cx, word [byte edx+Ypos+2]
        jge short .11
.10:
        test byte [byte ebx+pflags], 80h
        jne short .12
        cmp cx, word [byte edx+Ypos+2]
        jg short .12
.11:
        mov ax, word [byte edx+SCnum]
        mov dword [byte esp+08h], eax
        mov cx, word [byte edx+Ypos+2]
.12:
        mov eax, edx
        call GetHot
        mov ebp, dword [edx]
        sar ebp, 10h
        mov eax, dword [regd0-2]
        sar eax, 10h
        add ebp, eax
        mov eax, dword [puckx]
        movsx edi, word [eax]
        sub ebp, edi
        mov edi, ebp
        mov eax, dword [puckvx]
        movsx eax, word [eax]
        sar eax, 6
        sub edi, eax
        mov word [regd0], di
        mov eax, dword [regd0-2]
        sar eax, 10h
        imul eax, eax
        mov dword [regd0], eax
        mov edi, dword [byte edx+Ypos]
        sar edi, 10h
        mov eax, dword [regd1-2]
        sar eax, 10h
        add eax, edi
        mov dword [esp], eax
        mov eax, dword [pucky]
        movsx edi, word [eax]
        mov eax, dword [esp]
        sub eax, edi
        mov edi, eax
        mov eax, dword [puckvy]
        movsx eax, word [eax]
        sar eax, 6
        sub edi, eax
        mov word [regd1], di
        mov eax, dword [regd1-2]
        sar eax, 10h
        imul eax, eax
        mov dword [regd1], eax
        mov ebp, dword [regd0]
        add ebp, eax
        mov dword [regd0], ebp
        cmp ebp, dword [regd2]
        ja short .13
        mov dword [regd2], ebp
        mov esi, edx
.13:
        add edx, 80h
        mov ax, word [regd4]
        dec ax
        mov word [regd4], ax
        jne near assnearest.7
.14:
        mov ebp, dword [regd2]
        test ebp, ebp
        jl short .16
        mov edx, dword [byte esp+04h]
        mov dword [byte edx+03Ah], ebp
.15:
        cmp esi, ebx
        je short .16
        test byte [gmode], 1
        jne short .16
        cmp word [byte esi+position], byte 0
        jle short .16
        test byte [byte esi+pflags2], 4
        jne short .16
        and byte [byte esi+pflags], 0FEh
        mov edx, 11h
        mov eax, esi
        call assinsert
        mov eax, ebx
        call assexit
        jmp near .60
.16:
        test byte [byte ebx+pflags], 20h
        jne near .60
        mov dword [regd1], 2
        mov dx, word [regd2]
        cmp dx, 190h
        jle near .23
        cmp dx, 0E10h
        jg short .21
        mov eax, dword [puckvx]
        mov si, word [eax]
        test si, si
        jge short .17
        movsx eax, si
        neg eax
        jmp short .18
.17:
        movsx eax, si
.18:
        cmp eax, 1F4h
        jge short .21
        mov eax, dword [puckvy]
        mov di, word [eax]
        test di, di
        jge short .19
        movsx eax, di
        neg eax
        jmp short .20
.19:
        movsx eax, di
.20:
        cmp eax, 1F4h
        jl short .23
.21:
        mov ax, word [byte ebx+position]
        cmp ax, 2
        jle near .24
        test byte [byte ebx+pflags], 80h
        je short .22
        cmp ax, 4Eh
        jg short .23
.22:
        test byte [byte ebx+pflags], 80h
        jne short .24
        mov eax, dword [byte ebx+position-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFB2h
        jge short .24
.23:
        sub word [regd1], byte 2
        cmp word [byte ebx+position], byte 2
        jg short .24
        mov ax, word [byte ebx+SCnum]
        cmp ax, word [byte esp+08h]
        je near .33
        xor eax, eax
        mov al, byte [byte ebx+aggress]
        mov edx, 32h
        sub edx, eax
        xor eax, eax
        mov al, byte [byte ebx+checking]
        sub edx, eax
        mov eax, edx
        xor edx, edx
        mov dl, byte [byte ebx+aidef]
        sub eax, edx
        mov edx, eax
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        cwde
        call randomd0
        test ax, ax
        jne near .33
.24:
        mov eax, dword [puckvx]
        mov dx, word [eax]
        test dx, dx
        jge short .25
        movsx eax, dx
        neg eax
        jmp short .26
.25:
        movsx eax, dx
.26:
        cmp eax, 1F4h
        jge short .29
        mov eax, dword [puckvy]
        mov cx, word [eax]
        test cx, cx
        jge short .27
        movsx eax, cx
        neg eax
        jmp short .28
.27:
        movsx eax, cx
.28:
        cmp eax, 1F4h
        jge short .29
        dec word [regd1]
.29:
        test byte [gmode2], 20h
        je short .30
        sub word [regd1], byte 2
        mov al, byte [byte ebx+pflags]
        and al, 40h
        xor edx, edx
        mov dl, al
        mov ax, word [gmode2]
        xor ah, ah
        and al, 40h
        cwde
        xor eax, edx
        je short .30
        add dword [regd1], byte 4
.30:
        cmp word [regd1], byte 0
        jge short .31
        xor eax, eax
        mov al, byte [byte ebx+checking]
        mov edx, 14h
        sub edx, eax
        mov eax, edx
        mov ecx, dword [regd1-2]
        sar ecx, 10h
        neg ecx
        sar eax, cl
        jmp short .32
.31:
        xor eax, eax
        mov al, byte [byte ebx+checking]
        mov edx, 14h
        sub edx, eax
        mov eax, edx
        mov cx, word [regd1]
        shl eax, cl
.32:
        mov word [regd0], ax
        mov eax, dword [regd0-2]
        sar eax, 10h
        call randomd0
        cmp ax, 1
        ja short .33
        mov word [byte ebx+temp3], 12Ch
.33:
        mov dl, byte [byte ebx+pflags]
        test dl, 20h
        jne near .60
        test byte [gmode], 1
        je short .34
        mov eax, ebx
        call check4bench
        test ax, ax
        jne near .60
        mov eax, ebx
        call donothing
        jmp near .60
.34:
        test dl, 8
        jne near .60
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jl short .35
        mov dx, word [byte ebx+temp3]
        dec edx
        mov word [byte ebx+temp3], dx
        test dx, dx
        jl short .36
.35:
        mov eax, ebx
        call skatetopuck
        jmp near .59
.36:
        mov word [byte ebx+temp3], 0
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
        mov edx, dword [regd0-2]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, eax
        sar edx, 1Fh
        shl edx, 2
        LD sbb, eax, edx
        sar eax, 2
        mov word [regd0], ax
        test byte [byte ebx+pflags], 80h
        je short .37
        mov eax, 0FFFFFF2Ch
        jmp short .38
.37:
        mov eax, 0D4h
.38:
        mov edx, dword [regd1-2]
        sar edx, 10h
        sub eax, edx
        sar eax, 1
        add eax, edx
        mov word [regd1], ax
        mov eax, dword [pucky]
        mov si, word [eax]
        test si, si
        jge short .39
        movsx eax, si
        neg eax
        jmp short .40
.39:
        movsx eax, si
.40:
        cmp word [regd1], byte 0
        jge short .41
        mov edx, dword [regd1-2]
        sar edx, 10h
        neg edx
        jmp short .42
.41:
        mov edx, dword [regd1-2]
        sar edx, 10h
.42:
        cmp edx, eax
        jle near .58
        mov eax, dword [puckx]
        mov dx, word [eax]
        test dx, dx
        jge short .43
        movsx eax, dx
        neg eax
        jmp short .44
.43:
        movsx eax, dx
.44:
        cmp eax, byte 41h
        jge near .58
        mov eax, dword [pucky]
        movsx edx, word [eax]
        mov eax, dword [regd1-2]
        sar eax, 10h
        sub eax, edx
        test eax, eax
        jge short .45
        neg eax
.45:
        cmp eax, byte 14h
        jle near .58
        cmp word [regd0], byte 0
        jge short .46
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .47
.46:
        mov eax, dword [regd0-2]
        sar eax, 10h
.47:
        cmp eax, byte 14h
        jge short .51
        cmp word [regd1], byte 0
        jge short .48
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .49
.48:
        mov eax, dword [regd1-2]
        sar eax, 10h
.49:
        cmp eax, 0C8h
        jle near .58
        cmp word [regd1], byte 0
        jge short .50
        mov eax, 0FFFFFF38h
        jmp near .57
.50:
        mov eax, 0C8h
        jmp short .57
.51:
        cmp word [regd0], byte 0
        jge short .52
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .53
.52:
        mov eax, dword [regd0-2]
        sar eax, 10h
.53:
        cmp eax, byte 28h
        jge short .58
        cmp word [regd1], byte 0
        jge short .54
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .55
.54:
        mov eax, dword [regd1-2]
        sar eax, 10h
.55:
        cmp eax, 0D2h
        jle short .58
        cmp word [regd1], byte 0
        jge short .56
        mov eax, 0FFFFFF2Eh
        jmp short .57
.56:
        mov eax, 0D2h
.57:
        mov word [regd1], ax
.58:
        xor edx, edx
        mov eax, ebx
        call skateto
.59:
        mov eax, ebx
        call check4check
.60:
        add esp, byte 0Ch
        jmp near assgoalie_popebp
%endif ; C
;-----------------------------------------------------------------------------
; assshoot                           4D3F8  94G logic94.asm, medium confidence
; Assignment table slot 12h: the player taking a shot
;-----------------------------------------------------------------------------
; C: src/engine/puckcarrier/assshoot.c
%ifdef CBUILD
%include "c/engine/puckcarrier/assshoot.inc"
%else
assshoot:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push edi
        mov edx, eax
        test byte [byte eax+pflags], 20h
        jne near .11
        mov bl, byte [byte edx+pflags]
        test bl, 2
        je short .1
        mov ah, bl
        and ah, 0FDh
        mov byte [byte edx+pflags], ah
        mov eax, edx
        call SetShotMode
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        test byte [sflags], 8
        jne short .2
        mov eax, edx
        call assexit
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.2:
        xor ebx, ebx
        mov word [regd2], bx
        mov cx, word [byte edx+temp2]
        dec ecx
        mov word [byte edx+temp2], cx
        test cx, cx
        jge short .3
        or byte [regd2], 20h
.3:
        mov di, word [byte edx+04Ch]
        dec edi
        mov word [byte edx+04Ch], di
        test di, di
        jge short .4
        mov word [byte edx+04Ch], 0
.4:
        cmp word [byte edx+Ypos+2], byte 0
        jge short .5
        mov eax, dword [byte edx+Ypos]
        sar eax, 10h
        neg eax
        jmp short .6
.5:
        mov eax, dword [byte edx+Ypos]
        sar eax, 10h
.6:
        cmp eax, 9Eh
        jge short .9
        cmp word [byte edx+Ypos+2], byte 0
        jge short .7
        mov eax, dword [byte edx+Ypos]
        sar eax, 10h
        neg eax
        jmp short .8
.7:
        mov eax, dword [byte edx+Ypos]
        sar eax, 10h
.8:
        cmp eax, byte 53h
        jle short .9
        mov eax, dword [byte edx+070h]
        cmp dword [byte eax+03Eh], byte 24h
        jge short .9
        cmp word [byte edx+04Ch], byte 0
        jne short .9
        mov eax, 14h
        call randomd0
        test ax, ax
        jne short .9
        mov word [byte edx+04Ch], 12Ch
        or byte [regd1], 10h
        jmp short .10
.9:
        and byte [regd1], 0AFh
.10:
        mov eax, edx
        call ShotMode
.11:
        pop edi
        pop edx
        pop ecx
        pop ebx
assshoot_ret:
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assfaceoff                         4D4F0  94G logic94.asm, medium confidence
; Assignment table slot 16h: take a faceoff position
;-----------------------------------------------------------------------------
; C: src/engine/puckcarrier/assshoot.c (assfaceoff)
%ifdef CBUILD
%include "c/engine/puckcarrier/assshoot.assfaceoff.inc"
%else
assfaceoff:
        push dword 4
        call __CHK
        test byte [byte eax+pflags], 20h
        jne short assshoot_ret
        test byte [gmode2], 1
        jne short assshoot_ret
%endif ; C
;-----------------------------------------------------------------------------
; assexit                                               4D509  94G logic94.asm
; assexit: finish the current assignment of player p.
;
; Steps to the next entry of the player's 8-deep assignment stack (assnum + 1,
; wrapped to 0-7) and sets pflags bit 1 ('new assignment') so the assignment
; dispatcher starts it on the next pass. p: the player. No result.
;-----------------------------------------------------------------------------
; C: src/engine/puckcarrier/assshoot.c (assexit)
%ifdef CBUILD
%include "c/engine/puckcarrier/assshoot.assexit.inc"
%else
assexit:
        push dword 8
        call __CHK
        push edx
        mov dx, word [byte eax+01Ch]
        inc edx
        xor dh, dh
        and dl, 7
        mov word [byte eax+01Ch], dx
        or byte [byte eax+044h], 2
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assfaceoffpl                                        4D528  95G faceoff95.asm
; assfaceoffpl: the faceoff participant. pflags bit 5 returns; faceoff flag
; clear calls assexit; bit 1 clears temp1 and sets the faceoff frame
;-----------------------------------------------------------------------------
; C: src/engine/puckcarrier/assfaceoffpl.c
%ifdef CBUILD
%include "c/engine/puckcarrier/assfaceoffpl.inc"
%else
assfaceoffpl:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov ebx, eax
        test byte [byte eax+pflags], 20h
        jne near .x
        test byte [gmode2], 1
        jne short .1
        mov word [byte ebx+nopuck], 14h
        mov eax, ebx
        call assexit
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        mov dh, byte [byte ebx+pflags]
        test dh, 2
        je short .5
        mov cl, dh
        and cl, 0FDh
        mov byte [byte ebx+pflags], cl
        mov word [byte ebx+temp1], 0
        cmp word [byte ebx+facedir], byte 0
        je short .2
        mov eax, 167h
        jmp short .3
.2:
        mov eax, 16Ch
.3:
        mov word [byte ebx+frame], ax
        xor edx, edx
        mov eax, ebx
        call SetSPA
        test byte [byte ebx+pflags], 40h
        je short .4
        mov eax, 0Ah
        call randomd0
        add eax, 14h
        mov word [byte ebx+temp5], ax
        jmp short .5
.4:
        mov word [byte ebx+temp5], 28h
.5:
        mov edx, fofdata2
        test byte [byte ebx+pflags], 40h
        je short .6
        add edx, byte 4
.6:
        mov cx, word [byte ebx+frame]
        cmp cx, 169h
        je short .7
        cmp cx, 16Eh
        jne short .8
.7:
        mov word [regd0], 2
        jmp short .12
.8:
        cmp cx, 16Ah
        je short .9
        cmp cx, 16Fh
        jne short .11
.9:
        cmp word [byte ebx+SPAcnt], byte 7
        jne short .10
        test byte [byte ebx+pflags], 40h
        setne al
        and eax, 0FFh
        add eax, 9Eh
        cwde
        call sfx
.10:
        mov word [regd0], 3
        jmp short .12
.11:
        mov word [regd0], 1
.12:
        cmp byte [byte ebx+handed], 0
        jne short .13
        add word [regd0], byte 3
.13:
        mov ax, word [regd0]
        mov word [edx], ax
        test byte [byte ebx+pflags], 8
        jne near .x
        mov al, byte [byte ebx+pflags2]
        test al, 2
        jne near .x
        mov ah, al
        or ah, 2
        mov byte [byte ebx+pflags2], ah
        cmp word [byte ebx+temp5], byte 0
        jge short .14
        cmp word [pucktemp1], byte 10h
        jbe short .15
        mov eax, 8
        call randomd0
        test ax, ax
        je short .15
.14:
        mov dx, word [byte ebx+temp5]
        dec edx
        mov word [byte ebx+temp5], dx
        test dx, dx
        jge short .x
        mov eax, SPAfaceoffr
        jmp short .17
.15:
        mov word [byte ebx+temp5], 0FFFFh
        cmp word [pucktemp1], byte 11h
        jge short .16
        or byte [byte ebx+pflags], 20h
        mov eax, SPAfaceoff
        jmp short .17
.16:
        mov eax, SPAfaceoffpoke
.17:
        movsx edx, ax
        mov eax, ebx
        call SetSPA
.x:
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
