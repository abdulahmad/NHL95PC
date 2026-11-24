; What each player is trying to do. The assignment table: wings, centres, defence, the goalie,
; the puck carrier, the referee, and the shootout path.
bits 32
%include "hockey.inc"
%include "spa.inc"
section s_499D8 progbits alloc exec nowrite align=1
extern __CHK, ass_popx, asscentero_dedata, asscentero_dedata_xrand, asscentero_dedata_y, asscentero_dedata_yrand, assexit, assinsert
extern assrefwhistle, assreplace, assscore_dancecnt, asswingo_dedata, asswingo_dedata_xrand, asswingo_dedata_y, asswingo_dedata_yrand, doorpflags3
extern c1playernum, camx, camy, changeplayer, check4bench, check4check, ChkPullGoalieLate, doorpflags
extern doortemp1, doplayeracc, EvadePC, gmode, gmode2, gsp, ovltimer, PaSpeechBusy
extern PBnum, PenCntDwn, PerTimeTotal, playeracc, puckc, puckshadow, puckstruct, puckvy
extern puckx, pucky, randomd0, regd0, regd1, regd2, regd3, regd4
extern RemoveFromLines, SetBoxDoorObject, Setplass, setplayer, SetSPA, shotplayer, skateto, SkateToSpot
extern SortCords, sortobj15, SprSort, vtoa
global assboxenter, assbenchside, assdefo, assdefd, asswingd, asswingd_skate0, asswingd_skateto, asswingo
global asswingo_evade, asscenterd, asscentero, donothing, assstanley, assscore, asseben, assleaveice
global asspenalty, assdopen, assepen, assbench
;-----------------------------------------------------------------------------
; assboxenter                                     499D8  95 PC, low confidence
; Asstab 2Ah: PenCntDwn 12Ch; skates to x -91h,y 6, then seats the player in
; the box (pflags 20h, tmpde 800h, SetBoxDoorObject)
;
; and opens the box door sprite (sortobj15)
;-----------------------------------------------------------------------------
; C: src/engine/logic/assboxenter.c
%ifdef CBUILD
%include "c/engine/logic/assboxenter.inc"
%else
assboxenter:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov ebx, eax
        mov word [PenCntDwn], 12Ch
        test byte [byte eax+pflags], 20h
        jne near .x
        mov dl, byte [byte ebx+pflags]
        test dl, 2
        je short .1
        mov dh, dl
        and dh, 0FDh
        mov byte [byte ebx+pflags], dh
        mov word [byte ebx+temp2], 8
        mov word [byte ebx+temp4], 6
        mov word [byte ebx+temp3], 0FF6Fh
        mov word [byte ebx+temp1], 0
        mov word [byte ebx+temp5], 0
.1:
        mov cx, word [byte ebx+temp1]
        cmp cx, byte 64h
        jne near .2
        cmp cx, word [doortemp1]
        jne near .x
        mov word [doortemp1], 0C8h
        xor al, al
        mov byte [doorpflags3], al
        or byte [doorpflags], 20h
        mov edx, SPAgvcup
        mov eax, sortobj15
        call SetSPA
        and byte [byte ebx+attribute], 0F7h
        mov word [byte ebx+frame], 165h
        mov word [byte ebx+facedir], 2
        mov byte [byte ebx+046h], 0
        or byte [byte ebx+pflags], 20h
        mov edx, SPAgetcup
        mov eax, ebx
        call SetSPA
        mov eax, dword [byte ebx+044h]
        sar eax, 18h
        mov edx, dword [byte ebx+tmptr]
        mov word [byte edx+eax*2+tmpde], 800h
        mov eax, ebx
        call assexit
        test byte [byte ebx+pflags], 40h
        setne al
        and eax, 0FFh
        call SetBoxDoorObject
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.2:
        mov esi, ecx
        dec esi
        mov word [byte ebx+temp1], si
        test si, si
        jge near .8
        mov eax, esi
        add eax, 8
        mov word [byte ebx+temp1], ax
        mov ax, word [byte ebx+Ypos+2]
        mov dx, word [byte ebx+temp4]
        sub eax, edx
        mov word [regd1], ax
        mov ax, word [byte ebx+Xpos+2]
        mov cx, word [byte ebx+temp3]
        sub eax, ecx
        mov word [regd0], ax
        cmp word [regd1], byte 0
        jge short .3
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .4
.3:
        mov eax, dword [regd1-2]
        sar eax, 10h
.4:
        cmp eax, byte 4
        jg near .8
        cmp word [regd0], byte 4
        jg near .8
        mov ax, word [byte ebx+temp4]
        mov word [byte ebx+Ypos+2], ax
        mov ax, word [byte ebx+temp3]
        mov word [byte ebx+Xpos+2], ax
        mov word [byte ebx+Yvel], 0
        mov word [byte ebx+Xvel], 0
        mov edx, SPAglide
        mov eax, ebx
        call SetSPA
        or byte [byte ebx+pflags], 4
        mov ax, word [byte ebx+facedir]
        cmp ax, 6
        je short .7
        cmp ax, 7
        jge short .5
        cmp ax, 2
        jle short .5
        mov eax, 1
        jmp short .6
.5:
        mov eax, 0FFFFFFFFh
.6:
        mov edx, dword [byte ebx+facedir-2]
        sar edx, 10h
        add eax, edx
        and eax, byte 7
        mov word [byte ebx+facedir], ax
.7:
        cmp word [byte ebx+facedir], byte 6
        jne short .x
        mov word [byte ebx+temp1], 64h
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.8:
        test byte [byte ebx+pflags], 4
        jne short .x
        mov ax, word [byte ebx+temp3]
        mov word [regd0], ax
        mov ax, word [byte ebx+temp4]
        mov word [regd1], ax
        xor edx, edx
        mov eax, ebx
        call SkateToSpot
.x:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assbenchside                                    49BC2  95 PC, low confidence
; Asstab 2Bh (clockcont_0): when the camera is at the left boards (camx <=
; -20h, |camy| <= 14h) places the sprite at x -0BEh,y 3
;
; and plays bench-side animations 0E97h / 0EB5h; waits on PaSpeechBusy
;-----------------------------------------------------------------------------
; C: src/engine/logic/assbenchside.c
%ifdef CBUILD
%include "c/engine/logic/assbenchside.inc"
%else
assbenchside:
        push dword 10h
        call __CHK
        push ebx
        push edx
        push edi
        mov ebx, eax
        test byte [byte eax+044h], 2
        je near .4
        mov eax, ebx
        call puckshadow
        call PaSpeechBusy
        test eax, eax
        jne near .x
        cmp word [ovltimer], 100h
        jne short .1
        mov word [ovltimer], 258h
.1:
        mov eax, dword [camx-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFE0h
        jg near .x
        cmp word [camy], byte 0
        jge short .2
        mov eax, dword [camy-2]
        sar eax, 10h
        neg eax
        jmp short .3
.2:
        mov eax, dword [camy-2]
        sar eax, 10h
.3:
        cmp eax, byte 14h
        jg near .x
        and byte [byte ebx+pflags], 0FDh
        mov word [byte ebx+Xpos+2], 0FF42h
        mov word [byte ebx+Ypos+2], 3
        mov word [byte ebx+temp1], 0
        mov word [byte ebx+Yvel], 0
        mov ax, word [byte ebx+Yvel]
        mov word [byte ebx+Xvel], ax
        mov byte [byte ebx+046h], 0
        mov word [byte ebx+012h], 362h
        mov edx, SPAbrcup
        mov eax, ebx
        call SetSPA
.4:
        mov di, word [byte ebx+temp1]
        cmp di, byte 64h
        jge short .6
        cmp word [byte ebx+SPA], byte 0
        jne short .5
        mov word [byte ebx+temp1], 64h
        pop edi
        pop edx
        pop ebx
        ret
.5:
        cmp word [byte ebx+SPAnum], byte 4
        jl short .x
        cmp word [byte ebx+SPAcnt], byte 0Bh
        jg short .x
        mov word [byte ebx+Xpos+2], 0FF51h
        pop edi
        pop edx
        pop ebx
        ret
.6:
        cmp di, 0C8h
        jne short .x
        cmp word [byte ebx+012h], 365h
        jne short .x
        cmp word [byte ebx+SPA], byte 0
        jne short .x
        mov eax, 28h
        call randomd0
        test ax, ax
        jne short .x
        mov edx, SPAclap
        mov eax, ebx
        call SetSPA
.x:
        pop edi
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assdefo                                               49CDD  94G logic94.asm
; Assignment table slot 1: a defenceman while his team attacks
;-----------------------------------------------------------------------------
; C: src/engine/logic/assdefo.c
%ifdef CBUILD
%include "c/engine/logic/assdefo.inc"
%else
assdefo:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov ebx, eax
        test byte [byte eax+pflags], 20h
        jne near .x
        mov eax, ebx
        call check4bench
        test ax, ax
        jne near .x
        test byte [gmode], 1
        je short .1
        mov eax, ebx
        call donothing
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        mov dh, byte [byte ebx+pflags]
        test dh, 8
        jne near .x
        test dh, 2
        je short .2
        mov ch, dh
        and ch, 0FDh
        mov byte [byte ebx+pflags], ch
        mov word [byte ebx+temp1], ax
        mov word [byte ebx+temp2], 8
.2:
        mov al, byte [byte ebx+027h]
        dec al
        mov byte [byte ebx+027h], al
        test al, al
        jge near .6
        mov al, byte [byte ebx+05Ah]
        mov byte [byte ebx+027h], al
        mov eax, dword [byte ebx+06Ch]
        test byte [byte eax+tmflags], 10h
        je short .4
.3:
        mov edx, 2
        mov eax, ebx
        call assreplace
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.4:
        mov eax, dword [pucky]
        mov ax, word [eax]
        mov word [regd1], ax
        test byte [byte ebx+pflags], 80h
        jne short .5
        mov edx, eax
        neg edx
        mov word [regd1], dx
.5:
        cmp word [regd1], byte 53h
        jl short assdefo.3
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jl short .6
        cmp word [byte ebx+SCnum], byte 6
        setl al
        xor edx, edx
        mov dl, al
        mov eax, dword [puckc]
        cmp byte [eax], 6
        setl al
        and eax, 0FFh
        xor eax, edx
        jne short assdefo.3
.6:
        cmp word [byte ebx+position], byte 2
        jne short .7
        mov eax, 64h
        jmp short .8
.7:
        mov eax, 0FFFFFF9Ch
.8:
        mov word [regd0], ax
        mov word [regd1], 58h
        test byte [byte ebx+pflags], 80h
        jne short .9
        neg word [regd0]
        mov word [regd1], 0FFA8h
.9:
        mov eax, dword [puckx]
        movsx edx, word [eax]
        mov ecx, dword [regd0-2]
        sar ecx, 10h
        mov esi, edx
        xor esi, ecx
        test esi, esi
        jl short .10
        mov ax, word [eax]
        mov word [regd0], ax
        jmp short .11
.10:
        sar edx, 1
        add edx, ecx
        mov word [regd0], dx
.11:
        mov edx, EvadePC
        mov eax, ebx
        call skateto
.x:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assdefd                                               49E3A  94G logic94.asm
; Assignment table slot 2: a defenceman while his team defends
;-----------------------------------------------------------------------------
; C: src/engine/referee/assrefwhistle.c (assdefd)
%ifdef CBUILD
%include "c/engine/referee/assrefwhistle.assdefd.inc"
%else
assdefd:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ebx, eax
        test byte [byte eax+pflags], 20h
        jne near ass_popx
        mov eax, ebx
        call check4bench
        test ax, ax
        jne near ass_popx
        test byte [gmode], 1
        je short .1
        mov eax, ebx
        call donothing
        jmp near ass_popx
.1:
        mov dh, byte [byte ebx+pflags]
        test dh, 8
        jne near ass_popx
        test dh, 2
        je short .2
        mov ch, dh
        and ch, 0FDh
        mov byte [byte ebx+pflags], ch
        mov word [byte ebx+temp1], ax
        mov word [byte ebx+temp2], 8
.2:
        mov al, byte [byte ebx+027h]
        dec al
        mov byte [byte ebx+027h], al
        test al, al
        jge near .27
        mov al, byte [byte ebx+05Ah]
        mov byte [byte ebx+027h], al
        mov eax, dword [pucky]
        mov ax, word [eax]
        mov word [regd1], ax
        mov eax, dword [puckvy]
        movsx eax, word [eax]
        sar eax, 6
        mov word [regd3], ax
        test byte [byte ebx+pflags], 80h
        jne short .3
        neg word [regd1]
        mov ecx, eax
        neg ecx
        mov word [regd3], cx
.3:
        cmp word [regd3], byte 0
        jge short .4
        xor edi, edi
        mov word [regd3], di
.4:
        mov ax, word [regd1]
        mov dx, word [regd3]
        add edx, eax
        mov word [regd3], dx
        cmp dx, byte 4Eh
        jl near .8
        mov eax, dword [byte ebx+06Ch]
        test byte [byte eax+tmflags], 10h
        jne near .8
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jl near .8
        test byte [gmode2], 20h
        je short .5
        mov al, byte [byte ebx+pflags]
        and al, 40h
        xor edx, edx
        mov dl, al
        mov ax, word [gmode2]
        xor ah, ah
        and al, 40h
        cwde
        xor eax, edx
        jne short .6
.5:
        mov eax, 1
        jmp short .7
.6:
        xor eax, eax
.7:
        test eax, eax
        je short .8
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jl short .8
        cmp word [byte ebx+SCnum], byte 6
        setl al
        mov edx, eax
        and edx, 0FFh
        mov eax, dword [puckc]
        cmp byte [eax], 6
        setl al
        and eax, 0FFh
        cmp eax, edx
        jne short .8
        mov edx, 1
        mov eax, ebx
        call assreplace
        jmp near ass_popx
.8:
        cmp word [byte ebx+position], byte 2
        jne short .9
        mov eax, 50h
        jmp short .10
.9:
        mov eax, 0FFFFFFB0h
.10:
        mov word [byte ebx+temp3], ax
        cmp word [byte ebx+SCnum], byte 6
        jge short .11
        mov eax, 6
        jmp short .12
.11:
        xor eax, eax
.12:
        shl eax, 7
        add eax, SortCords
        mov word [regd2], 6
        test byte [byte ebx+pflags], 80h
        je near .17
        mov word [regd0], 3E8h
.13:
        test byte [byte eax+pflags2], 4
        jne short .15
        cmp word [byte eax+position], byte 0
        jl short .15
        mov dx, word [byte eax+Yvel]
        mov word [regd1], dx
        test dx, dx
        jle short .14
        xor esi, esi
        mov word [regd1], si
.14:
        mov ecx, dword [byte eax+Ypos]
        sar ecx, 10h
        mov edx, dword [regd1-2]
        sar edx, 14h
        add edx, ecx
        mov word [regd1], dx
        cmp dx, word [regd0]
        jg short .15
        mov word [regd0], dx
.15:
        add eax, 80h
        mov dx, word [regd2]
        dec dx
        mov word [regd2], dx
        jne short assdefd.13
        sub word [regd0], byte 32h
        mov eax, dword [regd0-2]
        sar eax, 10h
        cmp eax, 0FFFFFF56h
        jg short .16
        mov word [regd0], 0FF3Dh
.16:
        mov ax, word [regd0]
        mov word [byte ebx+temp4], ax
        jmp near .22
.17:
        mov word [regd0], 0FC18h
.18:
        test byte [byte eax+pflags2], 4
        jne short .20
        cmp word [byte eax+position], byte 0
        jl short .20
        mov dx, word [byte eax+Yvel]
        mov word [regd1], dx
        test dx, dx
        jge short .19
        xor ecx, ecx
        mov word [regd1], cx
.19:
        mov ecx, dword [byte eax+Ypos]
        sar ecx, 10h
        mov edx, dword [regd1-2]
        sar edx, 14h
        add edx, ecx
        mov word [regd1], dx
        cmp dx, word [regd0]
        jl short .20
        mov word [regd0], dx
.20:
        add eax, 80h
        mov di, word [regd2]
        dec di
        mov word [regd2], di
        jne short assdefd.18
        mov cx, word [regd0]
        add ecx, byte 32h
        mov word [regd0], cx
        cmp cx, 0AAh
        jl short .21
        mov word [regd0], 0C3h
.21:
        mov ax, word [regd0]
        mov word [byte ebx+temp4], ax
        neg word [byte ebx+temp3]
.22:
        mov edx, dword [byte ebx+temp3-2]
        sar edx, 10h
        mov eax, dword [puckx]
        movsx eax, word [eax]
        xor eax, edx
        test eax, eax
        jge short .27
        mov word [byte ebx+temp3], 0
        cmp word [regd0], byte 0
        jge short .23
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .24
.23:
        mov eax, dword [regd0-2]
        sar eax, 10h
.24:
        cmp eax, 0C3h
        jne short .27
        cmp word [regd0], byte 0
        jge short .25
        mov eax, 0FFFFFF4Ah
        jmp short .26
.25:
        mov eax, 0B6h
.26:
        mov word [byte ebx+temp4], ax
.27:
        mov ax, word [byte ebx+temp3]
        mov word [regd0], ax
        mov ax, word [byte ebx+temp4]
        mov word [regd1], ax
        mov edx, EvadePC
        mov eax, ebx
        call skateto
        mov eax, ebx
        call check4check
        jmp near ass_popx
%endif ; C
;-----------------------------------------------------------------------------
; asswingd                           4A1A6  94G logic94.asm, medium confidence
; Assignment table slot 3: a winger while his team defends
;-----------------------------------------------------------------------------
; C: src/engine/referee/assrefwhistle.c (asswingd)
%ifdef CBUILD
%include "c/engine/referee/assrefwhistle.asswingd.inc"
%else
asswingd:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ebx, eax
        test byte [byte eax+pflags], 20h
        jne near ass_popx
        mov eax, ebx
        call check4bench
        test ax, ax
        jne near ass_popx
        test byte [gmode], 1
        je short .1
        mov eax, ebx
        call donothing
        jmp near ass_popx
.1:
        mov dh, byte [byte ebx+pflags]
        test dh, 8
        jne near ass_popx
        test dh, 2
        je short .2
        mov ch, dh
        and ch, 0FDh
        mov byte [byte ebx+pflags], ch
        mov word [byte ebx+temp1], ax
        mov word [byte ebx+temp2], 8
.2:
        mov al, byte [byte ebx+027h]
        dec al
        mov byte [byte ebx+027h], al
        test al, al
        jge short .3
        mov al, byte [byte ebx+059h]
        mov byte [byte ebx+027h], al
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jl short .3
        cmp word [byte ebx+SCnum], byte 6
        setl al
        xor edx, edx
        mov dl, al
        mov eax, dword [puckc]
        cmp byte [eax], 6
        setl al
        and eax, 0FFh
        cmp eax, edx
        jne short .3
        mov edx, 4
        mov eax, ebx
        call assreplace
        jmp near ass_popx
.3:
        cmp word [byte ebx+position], byte 5
        jne short .4
        mov eax, 0FFFFFF88h
        jmp short .5
.4:
        mov eax, 78h
.5:
        mov dword [regd0], eax
        mov word [regd1], 8Eh
        mov edi, 44h
        mov word [regd2], di
        test byte [byte ebx+pflags], 80h
        je short .10
        neg word [regd0]
        mov word [regd1], 0FF72h
        mov esi, 0FFFFFFBCh
        mov word [regd2], si
        mov eax, dword [byte ebx+06Ch]
        test byte [byte eax+tmflags], 10h
        je short .6
        mov word [regd1], si
        jmp short .11
.6:
        mov eax, dword [pucky]
        mov di, word [eax]
        cmp di, si
        jl short .8
.7:
        mov word [regd1], di
        jmp short .11
.8:
        mov edx, 0FFFFFF18h
        mov word [regd2], dx
        cmp dx, word [eax]
        jl short .11
.9:
        mov word [regd1], dx
        jmp short .11
.10:
        mov eax, dword [byte ebx+06Ch]
        test byte [byte eax+tmflags], 10h
        jne short asswingd.7
        mov eax, dword [pucky]
        mov dx, word [eax]
        cmp dx, di
        jle short asswingd.9
        mov ecx, 0E8h
        mov word [regd2], cx
        cmp cx, word [eax]
        jg short .11
        mov word [regd1], cx
.11:
        mov eax, dword [puckx]
        movsx ecx, word [eax]
        mov edx, dword [regd0-2]
        sar edx, 10h
        xor edx, ecx
        test edx, edx
        jl short asswingd_skate0
        mov ax, word [eax]
        mov word [regd0], ax
asswingd_skate0:
        xor edx, edx
asswingd_skateto:
        mov eax, ebx
        call skateto
        jmp near ass_popx
%endif ; C
;-----------------------------------------------------------------------------
; asswingo                                              4A343  94G logic94.asm
; Assignment table slot 4: a winger while his team attacks
;-----------------------------------------------------------------------------
; C: src/engine/referee/assrefwhistle.c (asswingo)
%ifdef CBUILD
%include "c/engine/referee/assrefwhistle.asswingo.inc"
%else
asswingo:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ebx, eax
        test byte [byte eax+pflags], 20h
        jne near ass_popx
        mov eax, ebx
        call check4bench
        test ax, ax
        jne near ass_popx
        test byte [gmode], 1
        je short .1
        mov eax, ebx
        call donothing
        jmp near ass_popx
.1:
        mov dh, byte [byte ebx+pflags]
        test dh, 8
        jne near ass_popx
        test dh, 2
        je short .2
        mov ch, dh
        and ch, 0FDh
        mov byte [byte ebx+pflags], ch
        mov byte [byte ebx+02Fh], 0FFh
        mov word [byte ebx+temp1], ax
        mov word [byte ebx+temp2], 8
.2:
        mov al, byte [byte ebx+027h]
        dec al
        mov byte [byte ebx+027h], al
        test al, al
        jge near .7
        mov al, byte [byte ebx+059h]
        mov byte [byte ebx+027h], al
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jl short .3
        cmp word [byte ebx+SCnum], byte 6
        setl al
        mov edx, eax
        and edx, 0FFh
        mov eax, dword [puckc]
        cmp byte [eax], 6
        setl al
        and eax, 0FFh
        xor eax, edx
        je short .3
        mov edx, 3
        mov eax, ebx
        call assreplace
        jmp near ass_popx
.3:
        mov eax, dword [pucky]
        mov ax, word [eax]
        mov word [regd0], ax
        mov edx, dword [puckvy]
        movsx edx, word [edx]
        sar edx, 6
        mov eax, dword [regd0-2]
        sar eax, 10h
        add eax, edx
        mov word [regd3], ax
        test byte [byte ebx+pflags], 80h
        jne short .4
        neg word [regd0]
        mov esi, eax
        neg esi
        mov word [regd3], si
.4:
        xor edx, edx
        mov eax, dword [regd3-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFB2h
        jl short .5
        mov edx, 4
        cmp word [regd0], byte 4Eh
        jl short .5
        mov eax, dword [byte ebx+06Ch]
        test byte [byte eax+tmflags], 10h
        jne short .5
        mov edx, 8
        cmp word [regd3], 0E8h
        jl short .5
        mov edx, 0Ch
.5:
        cmp dx, word [byte ebx+temp5]
        jne short .6
        mov eax, 80h
        call randomd0
        mov word [regd0], ax
        test ax, ax
        jne short .7
.6:
        mov word [byte ebx+temp5], dx
        movsx edx, dx
        mov ax, word [nosplit edx*2+asswingo_dedata_xrand]
        add eax, eax
        cwde
        call randomd0
        sub ax, word [nosplit edx*2+asswingo_dedata_xrand]
        mov cx, word [nosplit edx*2+asswingo_dedata]
        add ecx, eax
        xor eax, eax
        mov al, byte [byte ebx+059h]
        add ecx, eax
        mov word [byte ebx+temp3], cx
        mov ax, word [nosplit edx*2+asswingo_dedata_yrand]
        add eax, eax
        cwde
        call randomd0
        mov di, word [nosplit edx*2+asswingo_dedata_yrand]
        mov ecx, eax
        sub ecx, edi
        mov ax, word [nosplit edx*2+asswingo_dedata_y]
        add ecx, eax
        mov word [byte ebx+temp4], cx
.7:
        mov ax, word [byte ebx+temp3]
        mov word [regd0], ax
        cmp word [byte ebx+position], byte 5
        je short .8
        neg word [regd0]
.8:
        mov ax, word [byte ebx+temp4]
        mov word [regd1], ax
        test byte [byte ebx+pflags], 80h
        jne short asswingo_evade
        neg word [regd0]
        mov esi, eax
        neg esi
        mov word [regd1], si
asswingo_evade:
        mov edx, EvadePC
        jmp near asswingd_skateto
%endif ; C
;-----------------------------------------------------------------------------
; asscenterd                                            4A53A  94G logic94.asm
; Assignment table slot 5: the centre while his team defends
;-----------------------------------------------------------------------------
; C: src/engine/logic/asscenterd.c
%ifdef CBUILD
%include "c/engine/logic/asscenterd.inc"
%else
asscenterd:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov ebx, eax
        test byte [byte eax+pflags], 20h
        jne near .x
        mov eax, ebx
        call check4bench
        test ax, ax
        jne near .x
        test byte [gmode], 1
        je short .1
        mov eax, ebx
        call donothing
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        mov dh, byte [byte ebx+pflags]
        test dh, 8
        jne near .x
        test dh, 2
        je short .2
        mov ch, dh
        and ch, 0FDh
        mov byte [byte ebx+pflags], ch
        mov word [byte ebx+temp1], ax
        mov word [byte ebx+temp2], 8
.2:
        mov al, byte [byte ebx+027h]
        dec al
        mov byte [byte ebx+027h], al
        test al, al
        jge short .3
        mov al, byte [byte ebx+059h]
        mov byte [byte ebx+027h], al
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jl short .3
        cmp word [byte ebx+SCnum], byte 6
        setl al
        mov edx, eax
        and edx, 0FFh
        mov eax, dword [puckc]
        cmp byte [eax], 6
        setl al
        and eax, 0FFh
        cmp eax, edx
        jne short .3
        mov edx, 6
        mov eax, ebx
        call assreplace
        pop edx
        pop ecx
        pop ebx
        ret
.3:
        mov eax, dword [puckx]
        movsx eax, word [eax]
        sar eax, 1
        mov word [regd0], ax
        mov eax, dword [pucky]
        mov ax, word [eax]
        mov word [regd2], ax
        test byte [byte ebx+pflags], 80h
        jne short .4
        mov ecx, eax
        neg ecx
        mov word [regd2], cx
.4:
        mov word [regd1], 0FF8Fh
        mov eax, dword [regd2-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFB2h
        jl short .5
        mov eax, dword [pucky]
        movsx eax, word [eax]
        sub eax, byte 71h
        sar eax, 1
        mov word [regd1], ax
.5:
        test byte [byte ebx+pflags], 80h
        jne short .6
        neg word [regd1]
.6:
        xor edx, edx
        mov eax, ebx
        call skateto
.x:
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; asscentero                                            4A65C  94G logic94.asm
; Assignment table slot 6: the centre while his team attacks
;-----------------------------------------------------------------------------
; C: src/engine/referee/assrefwhistle.c (asscentero)
%ifdef CBUILD
%include "c/engine/referee/assrefwhistle.asscentero.inc"
%else
asscentero:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ebx, eax
        test byte [byte eax+pflags], 20h
        jne near ass_popx
        mov eax, ebx
        call check4bench
        test ax, ax
        jne near ass_popx
        test byte [gmode], 1
        je short .1
        mov eax, ebx
        call donothing
        jmp near ass_popx
.1:
        mov dh, byte [byte ebx+pflags]
        test dh, 8
        jne near ass_popx
        test dh, 2
        je short .2
        mov ch, dh
        and ch, 0FDh
        mov byte [byte ebx+pflags], ch
        mov byte [byte ebx+02Fh], 0FFh
        mov word [byte ebx+temp1], ax
        mov word [byte ebx+temp2], 8
.2:
        mov al, byte [byte ebx+027h]
        dec al
        mov byte [byte ebx+027h], al
        test al, al
        jge near .7
        mov al, byte [byte ebx+059h]
        mov byte [byte ebx+027h], al
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jl short .3
        cmp word [byte ebx+SCnum], byte 6
        setl al
        mov edx, eax
        and edx, 0FFh
        mov eax, dword [puckc]
        cmp byte [eax], 6
        setl al
        and eax, 0FFh
        xor eax, edx
        je short .3
        mov edx, 5
        mov eax, ebx
        call assreplace
        jmp near ass_popx
.3:
        mov eax, dword [pucky]
        mov ax, word [eax]
        mov word [regd0], ax
        test byte [byte ebx+pflags], 80h
        jne short .4
        mov ecx, eax
        neg ecx
        mov word [regd0], cx
.4:
        xor edx, edx
        mov eax, dword [regd0-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFB2h
        jl short .5
        mov edx, 4
        mov si, word [regd0]
        cmp si, byte 4Eh
        jl short .5
        mov eax, dword [byte ebx+06Ch]
        test byte [byte eax+tmflags], 10h
        jne short .5
        mov edx, 8
        cmp si, 0E8h
        jl short .5
        mov edx, 0Ch
.5:
        cmp dx, word [byte ebx+temp5]
        jne short .6
        mov eax, 80h
        call randomd0
        mov word [regd0], ax
        test ax, ax
        jne short .7
.6:
        mov word [byte ebx+temp5], dx
        movsx edx, dx
        mov ax, word [nosplit edx*2+asscentero_dedata_xrand]
        add eax, eax
        cwde
        call randomd0
        sub ax, word [nosplit edx*2+asscentero_dedata_xrand]
        mov cx, word [nosplit edx*2+asscentero_dedata]
        add eax, ecx
        mov word [byte ebx+temp3], ax
        mov ax, word [nosplit edx*2+asscentero_dedata_yrand]
        add eax, eax
        cwde
        call randomd0
        sub ax, word [nosplit edx*2+asscentero_dedata_yrand]
        mov dx, word [nosplit edx*2+asscentero_dedata_y]
        add eax, edx
        mov word [byte ebx+temp4], ax
.7:
        mov ax, word [byte ebx+temp3]
        mov word [regd0], ax
        mov ax, word [byte ebx+temp4]
        mov word [regd1], ax
        test byte [byte ebx+pflags], 80h
        jne near asswingo_evade
        mov edi, eax
        neg edi
        mov word [regd1], di
        jmp near asswingo_evade
%endif ; C
;-----------------------------------------------------------------------------
; donothing                                             4A80E  94G logic94.asm
; donothing: doplayeracc 8 unless pfalock or pfjoycon
;-----------------------------------------------------------------------------
; C: src/engine/logic/donothing.c
%ifdef CBUILD
%include "c/engine/logic/donothing.inc"
%else
donothing:
        push dword 8
        call __CHK
        push edx
        mov dl, byte [byte eax+044h]
        test dl, 20h
        jne short .x
        test dl, 8
        jne short .x
        mov edx, 8
        call doplayeracc
.x:
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assstanley                         4A832  94G logic94.asm, medium confidence
; Assignment table slot 8: the Stanley Cup skate after the final
;-----------------------------------------------------------------------------
; C: src/engine/logic/assstanley.c
%ifdef CBUILD
%include "c/engine/logic/assstanley.inc"
%else
assstanley:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov ebx, eax
        test byte [byte eax+pflags], 20h
        jne near .x
        mov dl, byte [byte ebx+pflags]
        test dl, 2
        je short .1
        mov dh, dl
        and dh, 0FDh
        mov byte [byte ebx+pflags], dh
        mov word [byte ebx+temp3], 0FFB0h
        mov word [byte ebx+temp4], 0
        mov word [byte ebx+temp1], 0
        mov byte [byte ebx+046h], 0
        mov edx, SPAstansk
        mov eax, ebx
        call SetSPA
        mov word [PenCntDwn], 100h
.1:
        cmp word [byte ebx+SPA], byte 0
        jne short .2
        mov eax, dword [byte ebx+044h]
        sar eax, 18h
        mov edx, dword [byte ebx+06Ch]
        mov word [byte edx+eax*2+tmpde], 300h
        mov edx, SPAstanley
        mov eax, ebx
        call SetSPA
.2:
        mov ax, word [byte ebx+temp4]
        sub ax, word [byte ebx+Ypos+2]
        movsx edx, ax
        mov ax, word [byte ebx+temp3]
        sub ax, word [byte ebx+Xpos+2]
        cwde
        call vtoa
        mov word [regd0], ax
        cmp ax, 7
        jg short .x
        mov ax, word [byte ebx+temp1]
        dec eax
        mov word [byte ebx+temp1], ax
        test ax, ax
        jge short .3
        mov ecx, eax
        add ecx, byte 0Ch
        mov word [byte ebx+temp1], cx
        mov ax, word [byte ebx+facedir]
        cmp ax, word [regd0]
        je short .3
        inc eax
        xor ah, ah
        and al, 7
        mov word [byte ebx+facedir], ax
.3:
        mov edx, dword [regd0-2]
        sar edx, 10h
        mov eax, ebx
        call playeracc
.x:
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assscore                                              4A90F  94G logic94.asm
; Assignment table slot 7: goal celebration skate
;-----------------------------------------------------------------------------
; C: src/engine/logic/assscore.c
%ifdef CBUILD
%include "c/engine/logic/assscore.inc"
%else
assscore:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push edi
        mov ebx, eax
        mov eax, dword [puckc]
        movsx dx, byte [eax]
        cmp dx, word [byte ebx+SCnum]
        jne short .1
        mov byte [eax], 0FFh
        mov eax, dword [puckstruct+1Ah]
        sar eax, 10h
        add eax, puckstruct
        cmp byte [byte eax+01Eh], 18h
        jne short .1
        mov edx, 1Ah
        mov eax, puckstruct
        call assreplace
.1:
        test byte [byte ebx+pflags], 20h
        jne near .x
        mov eax, ebx
        call check4bench
        test ax, ax
        jne near .x
        mov cl, byte [byte ebx+pflags]
        test cl, 2
        je near .6
        mov ch, cl
        and ch, 0FDh
        mov byte [byte ebx+pflags], ch
        mov eax, 78h
        call randomd0
        mov word [byte ebx+temp1], ax
        mov word [byte ebx+temp2], 8
        test byte [gmode], 80h
        je short .2
        mov word [byte ebx+temp3], 0FFB0h
        mov word [byte ebx+temp4], 0
        jmp short .5
.2:
        cmp word [camx], byte 0
        jge short .3
        mov eax, 0FFFFFF9Ch
        jmp short .4
.3:
        mov eax, 64h
.4:
        mov word [byte ebx+temp3], ax
        mov ax, word [camy]
        mov word [byte ebx+temp4], ax
        cmp word [camx], byte 0
        jge short .5
        sub eax, byte 37h
        mov word [byte ebx+temp4], ax
.5:
        mov ax, word [byte ebx+SCnum]
        cmp ax, word [shotplayer]
        jne short .6
        xor edx, edx
        mov dword [assscore_dancecnt], edx
.6:
        mov cx, word [byte ebx+temp1]
        dec ecx
        mov word [byte ebx+temp1], cx
        test cx, cx
        jge near .12
        or byte [byte ebx+pflags], 20h
        mov word [regd1], SPAcelebrate
        mov eax, 78h
        call randomd0
        mov word [byte ebx+temp1], ax
        mov ax, word [byte ebx+SCnum]
        cmp ax, word [shotplayer]
        jne short .11
        mov word [regd1], SPApump
        mov ecx, dword [assscore_dancecnt]
        test ecx, ecx
        je short .7
        cmp ecx, byte 3
        jge short .8
        mov eax, 2
        call randomd0
        test ax, ax
        jne short .8
.7:
        mov word [byte ebx+temp1], 0
        inc dword [assscore_dancecnt]
        jmp short .11
.8:
        xor edi, edi
        mov dword [assscore_dancecnt], edi
        cmp word [byte ebx+temp1], byte 1Eh
        jle short .9
        mov eax, dword [byte ebx+temp1-2]
        sar eax, 10h
        jmp short .10
.9:
        mov eax, 1Eh
.10:
        mov word [byte ebx+temp1], ax
.11:
        mov edx, dword [regd1-2]
        sar edx, 10h
        mov eax, ebx
        call SetSPA
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.12:
        test byte [byte ebx+pflags], 8
        jne short .x
        mov ax, word [byte ebx+temp3]
        mov word [regd0], ax
        mov ax, word [byte ebx+temp4]
        mov word [regd1], ax
        xor edx, edx
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
; asseben                                               4AAC2  94G logic94.asm
; Assignment table slot 9: skate to the bench at the end of a period
;-----------------------------------------------------------------------------
; C: src/engine/logic/asseben.c
%ifdef CBUILD
%include "c/engine/logic/asseben.inc"
%else
asseben:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov dl, byte [byte eax+pflags]
        test dl, 20h
        jne near .x
        test dl, 2
        je near .4
        mov cl, dl
        and cl, 0FDh
        mov byte [byte eax+pflags], cl
        mov word [byte eax+Xvel], 0
        mov word [byte eax+Yvel], 0
        mov word [byte eax+048h], 0
        mov dx, word [byte eax+SCnum]
        sub edx, byte 6
        mov word [regd0], dx
        test dx, dx
        jl short .1
        mov ebx, edx
        add ebx, byte 2
        mov word [regd0], bx
.1:
        mov dx, word [regd0]
        imul edx, byte 0Eh
        mov word [byte eax+Ypos+2], dx
        mov word [byte eax+Xpos+2], 0FF60h
        mov word [byte eax+facedir], 2
        mov ch, byte [byte eax+pflags]
        and ch, 0CFh
        mov dl, ch
        or dl, 20h
        mov byte [byte eax+pflags], dl
        cmp word [byte eax+position], byte 0
        jne short .2
        mov edx, SPAgwallright
        jmp short .3
.2:
        mov edx, SPAwallright
.3:
        movsx edx, dx
        call SetSPA
        pop edx
        pop ecx
        pop ebx
        ret
.4:
        mov word [byte eax+facedir], 4
        and byte [byte eax+pflags], 0FBh
        and byte [byte eax+pflags2], 0DBh
        mov word [byte eax+SPA], 0
        mov word [byte eax+Xvel], 1000h
        call assexit
.x:
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assleaveice                                  4AB87  95 PC, medium confidence
; Asstab 1Dh (set by assthreestars, InProgress): skates to the bench gate (x
; -0A8h, y +-1Ch/24h by team), turns, plays the exit animation,
;
; sets pflags 20h (off ice) and RemoveFromLines (gsp<4, not gmode 40h); then
; assreplace 29h
;-----------------------------------------------------------------------------
; C: src/engine/logic/assleaveice.c
%ifdef CBUILD
%include "c/engine/logic/assleaveice.inc"
%else
assleaveice:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push edi
        mov ebx, eax
        test byte [byte eax+pflags], 20h
        jne near .x
        cmp word [byte ebx+temp1], byte 64h
        je near .17
        mov dh, byte [byte ebx+pflags]
        test dh, 2
        je near .6
        mov cl, dh
        and cl, 0FDh
        mov byte [byte ebx+pflags], cl
        or byte [byte ebx+pflags2], 4
        test byte [byte ebx+pflags], 8
        je short .3
        mov ax, word [byte ebx+SCnum]
        cmp ax, word [c1playernum]
        jne short .1
        xor edi, edi
        mov word [regd4], di
        jmp short .2
.1:
        mov word [regd4], 2
.2:
        mov edx, dword [regd4-2]
        sar edx, 10h
        mov eax, ebx
        call changeplayer
.3:
        mov word [byte ebx+temp2], 8
        test byte [byte ebx+pflags], 40h
        jne short .4
        mov eax, 0FFFFFFE4h
        jmp short .5
.4:
        mov eax, 24h
.5:
        mov word [byte ebx+temp4], ax
        mov word [byte ebx+temp3], 0FF58h
        mov word [byte ebx+temp1], 0
        or byte [byte ebx+pflags2], 20h
        mov word [byte ebx+Wallcos], 0
        mov word [byte ebx+Wallsin], 0
.6:
        mov ax, word [byte ebx+temp1]
        dec eax
        mov word [byte ebx+temp1], ax
        test ax, ax
        jge near .16
        mov ecx, eax
        add ecx, byte 8
        mov word [byte ebx+temp1], cx
        mov ax, word [byte ebx+Ypos+2]
        sub ax, word [byte ebx+temp4]
        mov dx, word [byte ebx+Xpos+2]
        mov di, word [byte ebx+temp3]
        sub edx, edi
        mov word [regd0], dx
        test ax, ax
        jge short .7
        cwde
        neg eax
        jmp short .8
.7:
        cwde
.8:
        cmp eax, byte 14h
        jg near .16
        cmp word [regd0], byte 20h
        jg near .16
        cmp word [byte ebx+position], byte 0
        jne short .9
        mov eax, 1
        jmp short .10
.9:
        mov eax, SPAglide
.10:
        mov word [regd1], ax
        mov edx, dword [regd1-2]
        sar edx, 10h
        mov eax, ebx
        call SetSPA
        or byte [byte ebx+pflags], 4
        mov cx, word [byte ebx+facedir]
        cmp cx, byte 4
        je short .13
        jge short .11
        mov eax, 1
        jmp short .12
.11:
        mov eax, 0FFFFFFFFh
.12:
        mov edx, dword [byte ebx+facedir-2]
        sar edx, 10h
        add eax, edx
        and eax, byte 7
        mov word [byte ebx+facedir], ax
.13:
        mov word [byte ebx+Yvel], 0
        mov word [byte ebx+Xvel], 0F800h
        cmp word [regd0], byte 10h
        jg near .x
        mov word [byte ebx+Xvel], 0
        cmp word [byte ebx+facedir], byte 4
        jne near .x
        mov word [byte ebx+Xvel], 0F800h
        mov word [byte ebx+facedir], 2
        cmp word [byte ebx+position], byte 0
        jne short .14
        mov eax, SPAgwallleft
        jmp short .15
.14:
        mov eax, SPAwallleft
.15:
        movsx edx, ax
        mov eax, ebx
        call SetSPA
        or byte [byte ebx+pflags], 20h
        mov word [byte ebx+temp1], 64h
        cmp word [gsp], byte 4
        jge short .x
        test byte [gmode], 40h
        jne short .x
        mov edx, dword [byte ebx+044h]
        sar edx, 18h
        test byte [byte ebx+pflags], 40h
        setne al
        xor ah, ah
        cwde
        call RemoveFromLines
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.16:
        test byte [byte ebx+pflags], 4
        jne short .x
        mov ax, word [byte ebx+temp3]
        mov word [regd0], ax
        mov ax, word [byte ebx+temp4]
        mov word [regd1], ax
        xor edx, edx
        mov eax, ebx
        call skateto
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.17:
        and byte [byte ebx+pflags2], 0EFh
        mov word [byte ebx+012h], 0FFFFh
        mov edx, 29h
        mov eax, ebx
        call assreplace
.x:
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; asspenalty                                            4ADAB  94G logic94.asm
; Assignment table slot 0Ch: the penalised player skates to the penalty box
;-----------------------------------------------------------------------------
; C: src/engine/referee/assrefwhistle.c (asspenalty)
%ifdef CBUILD
%include "c/engine/referee/assrefwhistle.asspenalty.inc"
%else
asspenalty:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ebx, eax
        test byte [byte eax+pflags], 20h
        jne near ass_popx
        mov dl, byte [byte ebx+pflags]
        test dl, 2
        je near .7
        mov dh, dl
        and dh, 0FDh
        mov byte [byte ebx+pflags], dh
        or byte [byte ebx+pflags2], 4
        test byte [byte ebx+pflags], 8
        je short .3
        mov ax, word [byte ebx+SCnum]
        cmp ax, word [c1playernum]
        jne short .1
        xor esi, esi
        mov word [regd4], si
        jmp short .2
.1:
        mov word [regd4], 2
.2:
        mov edx, dword [regd4-2]
        sar edx, 10h
        mov eax, ebx
        call changeplayer
.3:
        mov word [byte ebx+temp2], 8
        test byte [byte ebx+pflags], 40h
        jne short .4
        movsx ax, byte [PBnum]
        mov word [regd1], ax
        mov dword [regd0], 0FFFFFFF5h
        jmp short .5
.4:
        movsx ax, byte [PBnum+1]
        mov word [regd1], ax
        mov dword [regd0], 0Bh
.5:
        mov di, word [regd1]
        and edi, byte 0Fh
        mov word [regd1], di
        cmp di, byte 2
        jle short .6
        mov dword [regd1], 2
.6:
        mov dx, word [regd1]
        add edx, byte 3
        mov word [regd1], dx
        mov eax, edx
        mov cx, word [regd0]
        imul eax, ecx
        mov word [byte ebx+temp4], ax
        mov word [byte ebx+temp3], 0A0h
        mov word [byte ebx+temp1], 0
        or byte [byte ebx+pflags2], 20h
        mov word [byte ebx+Wallcos], 0
        mov word [byte ebx+Wallsin], 0
.7:
        mov ax, word [byte ebx+Ypos+2]
        mov si, word [byte ebx+temp4]
        sub eax, esi
        mov word [regd0], ax
        test ax, ax
        jge short .8
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .9
.8:
        mov eax, dword [regd0-2]
        sar eax, 10h
.9:
        cmp eax, byte 0Ch
        jg near .14
        mov ax, word [byte ebx+Xpos+2]
        mov dx, word [byte ebx+temp3]
        sub eax, edx
        mov word [regd0], ax
        mov eax, dword [regd0-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFE8h
        jl near .14
        mov cx, word [byte ebx+temp1]
        dec ecx
        mov word [byte ebx+temp1], cx
        test cx, cx
        jge near ass_popx
        mov edi, ecx
        add edi, byte 8
        mov word [byte ebx+temp1], di
        or byte [byte ebx+pflags], 4
        mov edx, SPAglide
        mov eax, ebx
        call SetSPA
        mov eax, 4
        mov word [regd2], ax
        mov dx, word [byte ebx+facedir]
        cmp dx, ax
        je short .12
        sub eax, edx
        xor ah, ah
        and al, 7
        mov word [regd2], ax
        cmp ax, 5
        jge short .10
        mov eax, 1
        jmp short .11
.10:
        mov eax, 0FFFFFFFFh
.11:
        mov edx, dword [byte ebx+facedir-2]
        sar edx, 10h
        add eax, edx
        and eax, byte 7
        mov word [byte ebx+facedir], ax
.12:
        mov word [byte ebx+Yvel], 0
        mov word [byte ebx+Xvel], 1000h
        mov eax, dword [regd0-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFF8h
        jl near ass_popx
        mov word [byte ebx+Xvel], 0
        mov ax, word [regd2]
        cmp ax, word [byte ebx+facedir]
        jne near ass_popx
        or byte [byte ebx+pflags], 20h
        mov word [byte ebx+facedir], 2
        mov edx, SPAwallright
        mov eax, ebx
        call SetSPA
        and byte [byte ebx+pflags2], 0EFh
        mov eax, dword [byte ebx+06Ch]
        mov dx, word [byte eax+tmap]
        cmp dx, byte 4
        jle short .13
        mov ecx, edx
        dec ecx
        mov word [byte eax+tmap], cx
.13:
        mov edx, 0Dh
        mov eax, ebx
        call assreplace
        jmp near ass_popx
.14:
        mov ax, word [byte ebx+temp3]
        mov word [regd0], ax
        mov ax, word [byte ebx+temp4]
        mov word [regd1], ax
        jmp near asswingd_skate0
%endif ; C
;-----------------------------------------------------------------------------
; assdopen                                              4AFFB  94G logic94.asm
; asstab 0Dh (player goes to the penalty box). Bumps PBnum (home) or PBnum+1 (away).
;-----------------------------------------------------------------------------
; C: src/engine/logic/assdopen.c
%ifdef CBUILD
%include "c/engine/logic/assdopen.inc"
%else
assdopen:
        push dword 8
        call __CHK
        push edx
        mov dl, byte [byte eax+044h]
        test dl, 20h
        jne short .x
        test dl, 40h
        jne short .1
        inc byte [PBnum]
        jmp short .2
.1:
        inc byte [PBnum+1]
.2:
        mov byte [byte eax+01Bh], 0FFh
        mov word [byte eax+012h], 0FFFFh
.x:
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assepen                                               4B02D  94G logic94.asm
; Assignment table slot 0Ah: a player leaving the penalty box
;-----------------------------------------------------------------------------
; C: src/engine/logic/assepen.c
%ifdef CBUILD
%include "c/engine/logic/assepen.inc"
%else
assepen:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov dl, byte [byte eax+pflags]
        test dl, 20h
        jne near .x
        test dl, 2
        je near .7
        mov cl, dl
        or cl, 4
        mov ch, cl
        and ch, 0EDh
        mov byte [byte eax+pflags], ch
        or byte [byte eax+pflags2], 4
        test byte [byte eax+pflags], 40h
        jne short .3
        mov cl, byte [PBnum]
        dec cl
        mov byte [PBnum], cl
        cmp cl, 2
        jle short .1
        mov ebx, 2
        jmp short .2
.1:
        mov ebx, dword [PBnum-3]
        sar ebx, 18h
.2:
        mov edx, ebx
        shl edx, 2
        sub edx, ebx
        shl edx, 2
        sub edx, ebx
        mov ebx, 0FFFFFFDFh
        sub ebx, edx
        mov word [byte eax+Ypos+2], bx
        jmp short .6
.3:
        mov bl, byte [PBnum+1]
        dec bl
        mov byte [PBnum+1], bl
        cmp bl, 2
        jle short .4
        mov ebx, 2
        jmp short .5
.4:
        mov ebx, dword [PerTimeTotal]
        sar ebx, 18h
.5:
        mov edx, ebx
        shl edx, 2
        sub edx, ebx
        shl edx, 2
        sub edx, ebx
        add edx, byte 21h
        mov word [byte eax+Ypos+2], dx
.6:
        mov word [byte eax+Xvel], 0
        mov word [byte eax+Yvel], 0
        mov word [byte eax+Xpos+2], 9Eh
        mov word [byte eax+facedir], 2
        or byte [byte eax+pflags], 20h
        mov edx, SPAwallleft
        call SetSPA
        call SprSort
        pop edx
        pop ecx
        pop ebx
        ret
.7:
        mov word [byte eax+facedir], 4
        mov byte [byte eax+newpnum], 0FFh
        mov byte [byte eax+newpos], 0FFh
        and byte [byte eax+pflags], 0F3h
        and byte [byte eax+pflags2], 0DBh
        mov word [byte eax+Xvel], 0F000h
        call assexit
.x:
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assbench                                              4B12C  94G logic94.asm
; Assignment table slot 0Bh: a player going to the bench on a line change
;-----------------------------------------------------------------------------
; C: src/engine/logic/assbench.c
%ifdef CBUILD
%include "c/engine/logic/assbench.inc"
%else
assbench:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov ebx, eax
        test byte [byte eax+pflags], 20h
        jne near .x
        cmp word [byte ebx+temp1], byte 64h
        je near .23
        mov eax, ebx
        call check4bench
        test ax, ax
        jne near .x
        test byte [byte ebx+pflags2], 10h
        je short .2
.1:
        mov eax, ebx
        call donothing
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.2:
        test byte [gmode2], 1
        jne short assbench.1
        test byte [gmode], 1
        je short .3
        cmp word [byte ebx+position], byte 0
        jne short .3
        mov eax, dword [byte ebx+tmptr]
        mov eax, dword [byte eax+tmgoalie-2]
        sar eax, 10h
        and eax, 0FFF0h
        cmp eax, 0FF00h
        jne short .3
        test byte [byte ebx+pflags], 40h
        setne al
        and eax, 0FFh
        call ChkPullGoalieLate
        test eax, eax
        jne short .3
        mov byte [byte ebx+newpos], 0FFh
        mov al, byte [byte ebx+newpos]
        mov byte [byte ebx+newpnum], al
        mov edx, 27h
        mov eax, ebx
        call assreplace
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.3:
        mov cl, byte [byte ebx+pflags]
        test cl, 2
        je short .6
        mov ch, cl
        and ch, 0FDh
        mov byte [byte ebx+pflags], ch
        mov word [byte ebx+temp2], 8
        test byte [byte ebx+pflags], 40h
        jne short .4
        mov eax, 0FFFFFFCEh
        jmp short .5
.4:
        mov eax, 41h
.5:
        mov word [byte ebx+temp4], ax
        mov word [byte ebx+temp3], 0FF58h
        mov word [byte ebx+temp1], 0
.6:
        mov al, byte [byte ebx+newpnum]
        cmp al, byte [byte ebx+pnum]
        jne short .8
        and byte [byte ebx+pflags2], 0FBh
        cmp byte [byte ebx+newpnum], 19h
        setl al
        mov edx, eax
        and edx, 0FFh
        mov cl, byte [byte ebx+newpos]
        test cl, cl
        sete al
        and eax, 0FFh
        xor eax, edx
        je short .7
        movsx ax, cl
        mov word [byte ebx+position], ax
.7:
        mov eax, ebx
        call Setplass
        mov byte [byte ebx+newpnum], 0FFh
        mov byte [byte ebx+newpos], 0FFh
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.8:
        cmp word [byte ebx+position], byte 0
        jne short .9
        or byte [byte ebx+048h], 3
.9:
        mov dx, word [byte ebx+temp1]
        dec edx
        mov word [byte ebx+temp1], dx
        test dx, dx
        jge near .19
        mov esi, edx
        add esi, byte 8
        mov word [byte ebx+temp1], si
        mov ax, word [byte ebx+Ypos+2]
        sub ax, word [byte ebx+temp4]
        mov dx, word [byte ebx+Xpos+2]
        mov cx, word [byte ebx+temp3]
        sub edx, ecx
        mov word [regd0], dx
        test ax, ax
        jge short .10
        cwde
        neg eax
        jmp short .11
.10:
        cwde
.11:
        cmp eax, byte 28h
        jg near .19
        cmp word [regd0], byte 20h
        jg near .19
        cmp word [byte ebx+position], byte 0
        jne short .12
        mov eax, 1
        jmp short .13
.12:
        mov eax, SPAglide
.13:
        mov word [regd1], ax
        mov edx, dword [regd1-2]
        sar edx, 10h
        mov eax, ebx
        call SetSPA
        or byte [byte ebx+pflags], 4
        mov dx, word [byte ebx+facedir]
        cmp dx, byte 4
        je short .16
        jge short .14
        mov eax, 1
        jmp short .15
.14:
        mov eax, 0FFFFFFFFh
.15:
        mov edx, dword [byte ebx+facedir-2]
        sar edx, 10h
        add eax, edx
        and eax, byte 7
        mov word [byte ebx+facedir], ax
.16:
        mov word [byte ebx+Yvel], 0
        mov word [byte ebx+Xvel], 0F800h
        cmp word [regd0], byte 10h
        jg near .x
        mov word [byte ebx+Xvel], 0
        cmp word [byte ebx+facedir], byte 4
        jne near .x
        mov word [byte ebx+Xvel], 0F800h
        mov word [byte ebx+facedir], 2
        cmp word [byte ebx+position], byte 0
        jne short .17
        mov eax, SPAgwallleft
        jmp short .18
.17:
        mov eax, SPAwallleft
.18:
        movsx edx, ax
        mov eax, ebx
        call SetSPA
        or byte [byte ebx+pflags], 20h
        mov word [byte ebx+temp1], 64h
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.19:
        test byte [byte ebx+pflags], 4
        jne near .x
        mov ax, word [byte ebx+temp3]
        mov word [regd0], ax
        mov ax, word [byte ebx+temp4]
        mov word [regd1], ax
        test byte [gmode], 1
        jne short .20
        cmp word [byte ebx+position], byte 0
        jne short .21
.20:
        xor edx, edx
        jmp short .22
.21:
        mov edx, EvadePC
.22:
        mov eax, ebx
        call skateto
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.23:
        mov word [byte ebx+frame], 0FFFFh
        mov ecx, dword [byte ebx+tmptr]
        mov eax, dword [byte ebx+044h]
        sar eax, 18h
        add eax, eax
        add eax, ecx
        cmp word [byte eax+07Eh], byte 0
        jg short .24
        mov edx, dword [byte eax+07Ch]
        sar edx, 10h
        cmp edx, byte 0FFFFFFFEh
        jl short .24
        mov word [byte eax+07Eh], 0FFFEh
        mov edx, dword [byte ebx+044h]
        sar edx, 18h
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 3
        sub eax, edx
        mov edx, eax
        mov eax, dword [dword ecx+tmroster]
        mov byte [edx+eax], 3
.24:
        cmp byte [byte ebx+newpnum], 19h
        setl al
        mov edx, eax
        and edx, 0FFh
        mov cl, byte [byte ebx+newpos]
        test cl, cl
        sete al
        and eax, 0FFh
        xor eax, edx
        je short .25
        movsx ax, cl
        mov word [byte ebx+position], ax
.25:
        mov eax, ebx
        call Setplass
        test byte [gmode], 1
        je short .26
        mov word [byte ebx+temp5], 0
        mov edx, 27h
        mov eax, ebx
        call assinsert
.26:
        movsx ax, byte [byte ebx+newpnum]
        mov word [regd3], ax
        mov byte [byte ebx+newpnum], 0FFh
        mov byte [byte ebx+newpos], 0FFh
        mov edx, dword [regd3-2]
        sar edx, 10h
        mov eax, ebx
        call setplayer
.x:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
