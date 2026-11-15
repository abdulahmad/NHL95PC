; Shootout skate paths and the penalty shooter (94G shootoutpath94).
bits 32
%include "hockey.inc"
section s_4F990 progbits alloc exec nowrite align=1
extern __CHK, assexit, donothing, doshot, Findhittype, gmode, passdir, passspeed
extern pspathdir, pspathside, puckc, randomd0, regd0, regd1, SetSPA, ShootoutPathData
extern ShootoutPathData_end, ShootoutPathData_y, skateto, sopathend, sopathpoint, sopathx, sopathy, updateanim
extern vtoa
global rtss, NextPathPoint, StartShootoutPath, asspenshooter
;-----------------------------------------------------------------------------
; rtss                             4F990  94G collide94.asm, medium confidence
; Asstab slot 0; field alignment n/a of 0 known-field accesses; content rank
; 1/34 vs other slot routines; 0 known Genesis callees present, 0 missing, 0
; extra
;-----------------------------------------------------------------------------
; C: src/engine/shootoutpath/rtss.c
%ifdef CBUILD
%include "c/engine/shootoutpath/rtss.inc"
%else
rtss:
        push dword 4
        call __CHK
        ret
%endif ; C
;-----------------------------------------------------------------------------
; NextPathPoint               4F99B  94G shootoutpath94.asm, medium confidence
; Same role as 94G shootoutpath94 NextPathPoint: advances the path index
; (sopathpoint) and loads the next point x/y/end from the 3-dword table
; ShootoutPathData (x negated by the path side); called by asspenshooter
;-----------------------------------------------------------------------------
; C: src/engine/shootoutpath/NextPathPoint.c
%ifdef CBUILD
%include "c/engine/shootoutpath/NextPathPoint.inc"
%else
NextPathPoint:
        push dword 8
        call __CHK
        push edx
        mov edx, dword [sopathpoint]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, eax
        mov eax, dword [nosplit eax*4+ShootoutPathData]
        cmp dword [pspathside], byte 0
        jge short .1
        neg eax
.1:
        mov dword [sopathx], eax
        mov eax, edx
        mov edx, dword [nosplit edx*4+ShootoutPathData_y]
        mov dword [sopathy], edx
        mov eax, dword [nosplit eax*4+ShootoutPathData_end]
        mov dword [sopathend], eax
        inc dword [sopathpoint]
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; StartShootoutPath           4F9EF  94G shootoutpath94.asm, medium confidence
; Role match: starts the shootout / penalty shot skate path (PC builds the
; path, 94G picks one)
;-----------------------------------------------------------------------------
; C: src/engine/shootoutpath/StartShootoutPath.c
%ifdef CBUILD
%include "c/engine/shootoutpath/StartShootoutPath.inc"
%else
StartShootoutPath:
        push dword 0Ch
        call __CHK
        push ebx
        push ecx
        mov ebx, eax
        cmp edx, byte 27h
        jl near .8
        mov edx, dword [eax]
        sar edx, 10h
        test edx, edx
        jge short .1
        neg edx
.1:
        cmp edx, byte 14h
        jle short .2
        xor ecx, ecx
        mov dword [sopathx], ecx
        mov dword [pspathside], ecx
        jmp short .7
.2:
        mov edx, 2Ch
        mov eax, 4
        call randomd0
        test ax, ax
        je short .3
        cmp byte [byte ebx+065h], 0
        je short .5
        jmp short .4
.3:
        mov eax, 10h
        call randomd0
        cmp ax, 8
        jge short .5
.4:
        mov edx, 0FFFFFFD4h
.5:
        test byte [byte ebx+044h], 80h
        jne short .6
        neg edx
.6:
        mov dword [sopathx], edx
        mov dword [pspathside], edx
.7:
        mov dword [sopathpoint], 2
        mov dword [sopathy], 97h
        mov dword [sopathend], 66h
        pop ecx
        pop ebx
        ret
.8:
        mov edx, 3Ah
        mov eax, 4
        call randomd0
        test ax, ax
        je short .9
        cmp byte [byte ebx+065h], 0
        je short .11
        jmp short .10
.9:
        mov eax, 10h
        call randomd0
        cmp ax, 8
        jge short .11
.10:
        mov edx, 0FFFFFFC6h
.11:
        test byte [byte ebx+044h], 80h
        jne short .12
        neg edx
.12:
        mov dword [sopathx], edx
        mov dword [pspathside], edx
        mov dword [sopathy], 3Ch
        mov dword [sopathend], 1Eh
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; asspenshooter                                4FAE8  95 PC, medium confidence
; Asstab 2Eh (asspuckc, SetupPenaltyShot): penalty-shot carrier: assexit if
; not carrying; PickShotAim, then dekes and shoots on the goal (passdir,
; passspeed)
;-----------------------------------------------------------------------------
; C: src/engine/shootoutpath/asspenshooter.c
%ifdef CBUILD
%include "c/engine/shootoutpath/asspenshooter.inc"
%else
asspenshooter:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov ebx, eax
        mov edx, dword [puckc]
        movsx ax, byte [edx]
        cmp ax, word [byte ebx+SCnum]
        je short .2
.1:
        mov eax, ebx
        call assexit
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.2:
        mov ah, byte [byte ebx+pflags]
        test ah, 8
        jne short asspenshooter.1
        test ah, 20h
        jne near .x
        test byte [gmode], 1
        je short .3
        mov edx, 289h
        mov eax, ebx
        call SetSPA
        mov word [byte ebx+03Eh], 3Ch
        mov eax, ebx
        call donothing
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.3:
        mov ecx, dword [byte ebx+Ypos]
        sar ecx, 10h
        test ah, 80h
        jne short .4
        neg ecx
.4:
        mov ah, byte [byte ebx+pflags]
        test ah, 2
        je short .5
        mov dl, ah
        and dl, 0FDh
        mov byte [byte ebx+pflags], dl
        mov word [byte ebx+temp1], 0
        mov byte [byte ebx+029h], 0
        mov byte [byte ebx+028h], 8
        xor edx, edx
        mov dword [sopathpoint], edx
        mov eax, 4
        call randomd0
        mov word [byte ebx+temp3], ax
        mov edx, ecx
        mov eax, ebx
        call StartShootoutPath
.5:
        mov esi, dword [sopathend]
        test esi, esi
        jge near .13
        mov ecx, dword [byte ebx+facedir-2]
        sar ecx, 10h
        sub ecx, dword [pspathdir]
        je near .14
        inc ecx
        and ecx, byte 7
        cmp ecx, byte 3
        jl short .6
        mov eax, 4
        call randomd0
        test ax, ax
        je short .7
.6:
        cmp ecx, byte 3
        jge near .14
        mov eax, 20h
        call randomd0
        test ax, ax
        jne near .14
.7:
        mov eax, 2
        call randomd0
        movsx ecx, ax
        add ecx, byte 2
        cmp dword [pspathside], byte 0
        jge short .8
        add ecx, byte 3
.8:
        mov word [passdir], cx
        mov word [passspeed], 14h
        mov ax, word [byte ebx+Xpos+2]
        neg eax
        mov word [regd0], ax
        test byte [byte ebx+pflags], 80h
        jne short .9
        mov eax, 0FFFFFF18h
        jmp short .10
.9:
        mov eax, 0E8h
.10:
        mov edx, dword [byte ebx+Ypos]
        sar edx, 10h
        sub eax, edx
        mov word [regd1], ax
        mov edx, dword [regd1-2]
        sar edx, 10h
        mov eax, dword [regd0-2]
        sar eax, 10h
        call vtoa
        movsx ecx, ax
        movsx edx, cx
        mov eax, ebx
        call Findhittype
        test ax, ax
        je short .11
        mov eax, 0DD3h
        jmp short .12
.11:
        mov eax, 0E2Bh
.12:
        movsx edx, ax
        mov eax, ebx
        call SetSPA
        mov eax, ebx
        call updateanim
        mov word [byte ebx+SPAcnt], 2
        mov eax, ebx
        call doshot
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.13:
        cmp ecx, esi
        jl short .14
        call NextPathPoint
        mov eax, dword [byte ebx+facedir-2]
        sar eax, 10h
        mov dword [pspathdir], eax
.14:
        mov ax, word [sopathx]
        mov word [regd0], ax
        mov ax, word [sopathy]
        mov word [regd1], ax
        test byte [byte ebx+pflags], 80h
        jne short .15
        mov ecx, eax
        neg ecx
        mov word [regd1], cx
.15:
        sub byte [byte ebx+029h], 2
        xor edx, edx
        mov eax, ebx
        call skateto
.x:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
