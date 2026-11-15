; Who the pad controls: nearest player, hot player, stick (94G logic94).
bits 32
%include "hockey.inc"
section s_5A341 progbits alloc exec nowrite align=1
extern __CHK, HotList, HotList_y, HotStickList, HotStickList_y, puckcross, puckvx, puckvy
extern puckx, pucky, regd0, regd1
global findpc, findpc_ret6, findpc_ret5, GetHot, GetHotStick, GetHotOrStick
;-----------------------------------------------------------------------------
; findpc                                                5A341  94G logic94.asm
; The 94G findpc: where and when the puck crosses each goal line (puckcross),
; called from pucknorm
;-----------------------------------------------------------------------------
; C: src/engine/control/findpc.c
%ifdef CBUILD
%include "c/engine/control/findpc.inc"
%else
findpc:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov esi, puckcross
        mov edi, 0E8h
        mov ecx, 0A0h
        xor edx, edx
        mov dword [esp], edx
        jmp near .6
.1:
        mov edx, dword [pucky]
        mov ax, word [edx]
        mov edx, edi
        sub edx, eax
        movsx ebp, dx
        mov ebx, dword [puckvy]
        cmp word [ebx], byte 0
        je near .4
        mov edx, ebp
        shl edx, 0Ch
        movsx ebx, word [ebx]
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov ebx, eax
        test eax, eax
        jl short .4
        cmp eax, 10000h
        jge short .4
        mov word [byte esi+02h], ax
        mov edx, dword [puckvx]
        movsx edx, word [edx]
        imul edx, ebp
        mov ebx, dword [puckvy]
        movsx ebx, word [ebx]
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov ebx, eax
        cmp eax, 10000h
        jge short .4
        mov edx, dword [puckx]
        add bx, word [edx]
        cmp bx, 0A0h
        jl short .2
        mov edx, ecx
        add edx, ecx
        sub edx, ebx
        mov bx, dx
.2:
        neg ecx
        cmp bx, cx
        jg short .3
        mov edx, ecx
        add edx, ecx
        sub edx, ebx
        mov bx, dx
.3:
        neg ecx
        mov word [esi], bx
        jmp short .5
.4:
        mov word [byte esi+02h], 0FFFFh
.5:
        neg edi
        inc dword [esp]
        add esi, byte 4
.6:
        cmp word [esp], byte 2
        jl near findpc.1
        add esp, byte 4
findpc_ret6:
        pop ebp
findpc_ret5:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; GetHot                             5A425  94G logic94.asm, medium confidence
;-----------------------------------------------------------------------------
; C: src/engine/control/findpc.c (GetHot)
%ifdef CBUILD
%include "c/engine/control/findpc.GetHot.inc"
%else
GetHot:
        push dword 10h
        call __CHK
        push ebx
        push edx
        push esi
        mov edx, eax
        xor ebx, ebx
        mov word [regd1], bx
        mov word [regd0], bx
        mov ax, word [byte eax+012h]
        test ax, ax
        jl short .x
        cmp ax, 468h
        jge short .x
        cmp ax, 378h
        jl short .1
        db 081h,0E8h,0F4h,00h,00h,00h           ; insn: sub eax,0F4h
        jmp short .2
.1:
        cmp ax, 283h
        jg short .x
.2:
        cmp ax, 2DAh
        jl short .3
        sub eax, byte 46h
        jmp short .4
.3:
        cmp ax, 293h
        jg short .x
.4:
        add eax, eax
        cwde
        movsx bx, byte [dword eax+HotList]
        mov word [regd0], bx
        movsx ax, byte [dword eax+HotList_y]
        mov word [regd1], ax
        test byte [byte edx+055h], 8
        je short .x
        mov esi, ebx
        neg esi
        mov word [regd0], si
.x:
        pop esi
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; GetHotStick                                  5A4AD  95 PC, medium confidence
; GetHot variant with the stick-position table CC7A4
;-----------------------------------------------------------------------------
; C: src/engine/control/GetHotStick.c
%ifdef CBUILD
%include "c/engine/control/GetHotStick.inc"
%else
GetHotStick:
        push dword 10h
        call __CHK
        push ebx
        push edx
        push esi
        mov edx, eax
        xor ebx, ebx
        mov word [regd1], bx
        mov word [regd0], bx
        mov ax, word [byte eax+012h]
        test ax, ax
        jl short .x
        cmp ax, 196h
        jl short .1
        cmp ax, 219h
        jle short .2
.1:
        cmp ax, 3CEh
        jl short .x
        cmp ax, 44Fh
        jg short .x
.2:
        cmp ax, 3CEh
        jl short .3
        db 081h,0E8h,0B4h,01h,00h,00h           ; insn: sub eax,1B4h
.3:
        db 081h,0E8h,096h,01h,00h,00h           ; insn: sub eax,196h
        add eax, eax
        cwde
        movsx bx, byte [dword eax+HotStickList]
        mov word [regd0], bx
        movsx ax, byte [dword eax+HotStickList_y]
        mov word [regd1], ax
        test byte [byte edx+055h], 8
        je short .x
        mov esi, ebx
        neg esi
        mov word [regd0], si
.x:
        pop esi
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; GetHotOrStick                                5A534  95 PC, medium confidence
; GetHot or GetHotStick depending on the player; physics caller
;-----------------------------------------------------------------------------
; C: src/engine/control/GetHotOrStick.c
%ifdef CBUILD
%include "c/engine/control/GetHotOrStick.inc"
%else
GetHotOrStick:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov edx, eax
        call GetHotStick
        mov bx, word [regd0]
        mov cx, word [regd1]
        mov eax, edx
        call GetHot
        mov dx, word [regd0]
        sub ebx, edx
        mov word [regd0], bx
        mov bx, word [regd1]
        sub ecx, ebx
        mov word [regd1], cx
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
