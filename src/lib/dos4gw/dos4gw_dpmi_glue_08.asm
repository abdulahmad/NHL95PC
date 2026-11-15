; DOS/4GW glue. DPMI memory blocks and interrupt calls.
bits 32
%include "hockey.inc"
section s_A2B95 progbits alloc exec nowrite align=1
extern _Extender, _ExtenderSubtype, _curbrk, _STACKTOP, sub_9D66B
global sbrk_, loc_A2BAE, loc_A2BBD, loc_A2BF7, loc_A2BF9, loc_A2C08, loc_A2C19, loc_A2C24
global loc_A2C2B, loc_A2C42, loc_A2C4E, __brk_, loc_A2C7F, loc_A2CA9, loc_A2CAF, loc_A2CBB
global loc_A2CCD, loc_A2CE2, loc_A2CF8, loc_A2CFE, loc_A2D0C
sbrk_:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ecx, eax
        cmp byte [_Extender], 1
        jne short loc_A2BAE
        cmp byte [_ExtenderSubtype], 0
        je short loc_A2BBD
loc_A2BAE:
        mov dh, byte [_Extender]
        cmp dh, 9
        jne near loc_A2C2B
loc_A2BBD:
        test ecx, ecx
        jle short loc_A2C19
        add ecx, 0FFFh
        mov al, byte [_Extender]
        and cx, 0F000h
        cmp al, 1
        jne short loc_A2BF9
        mov eax, ecx
        sar eax, 10h
        mov ebx, eax
        mov ah, 5
        mov al, 1
        int 31h
        sbb eax, eax
        inc eax
        je short loc_A2BF7
        mov ax, bx
        shl eax, 10h
        mov ax, cx
        mov word [eax], di
        mov word [byte eax+02h], si
loc_A2BF7:
        jmp short loc_A2C08
loc_A2BF9:
        mov ebx, ecx
        mov eax, 80004800h
        int 21h
        sbb ebx, ebx
        not ebx
        and eax, ebx
loc_A2C08:
        test eax, eax
        jne short loc_A2C4E
        call sub_9D66B
        mov dword [eax], 5
        jmp short loc_A2C24
loc_A2C19:
        call sub_9D66B
        mov dword [eax], 9
loc_A2C24:
        mov eax, 0FFFFFFFFh
        jmp short loc_A2C4E
loc_A2C2B:
        cmp dh, 2
        jb short loc_A2C42
        cmp dh, 8
        ja short loc_A2C42
        xor eax, eax
        mov eax, ds
        lsl eax, eax
        inc eax
        mov dword [_curbrk], eax
loc_A2C42:
        mov eax, dword [_curbrk]
        add eax, ecx
        call __brk_
loc_A2C4E:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
__brk_:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push es
        push ebp
        push eax
        cmp eax, dword [_STACKTOP]
        jb short loc_A2CBB
        cmp byte [_Extender], 0
        jne short loc_A2CCD
        mov ebp, dword [esp]
        add ebp, byte 0Fh
        shr ebp, 4
        test ebp, ebp
        jne short loc_A2C7F
        mov ebp, 0FFFFFFFh
loc_A2C7F:
        xor ebx, ebx
        mov eax, ds
        mov bx, ax
        mov ah, 0EDh
        int 21h
        shl eax, 1Fh
        and edi, 0FFFFh
        or edi, eax
        test edi, edi
        jge short loc_A2CA9
        mov es, edi
        mov ebx, ebp
        mov ah, 4Ah
        int 21h
        rcl eax, 1
        ror eax, 1
        test eax, eax
        jl short loc_A2CBB
loc_A2CA9:
        mov eax, ds
        mov es, eax
        mov ebx, ebp
loc_A2CAF:
        mov ah, 4Ah
        int 21h
        rcl eax, 1
        ror eax, 1
        test eax, eax
        jge short loc_A2CFE
loc_A2CBB:
        call sub_9D66B
        mov dword [eax], 5
        mov eax, 0FFFFFFFFh
        jmp short loc_A2D0C
loc_A2CCD:
        mov ebx, dword [esp]
        add ebx, 0FFFh
        shr ebx, 0Ch
        test ebx, ebx
        jne short loc_A2CE2
        mov ebx, 0FFFFFh
loc_A2CE2:
        mov dl, byte [_Extender]
        cmp dl, 1
        jne short loc_A2CF8
        cmp dl, byte [_ExtenderSubtype]
        jne short loc_A2CF8
        shl ebx, 8
loc_A2CF8:
        mov eax, ds
        mov es, eax
        jmp short loc_A2CAF
loc_A2CFE:
        mov ebx, dword [esp]
        mov eax, dword [_curbrk]
        mov dword [_curbrk], ebx
loc_A2D0C:
        add esp, byte 4
        pop ebp
        pop es
        jmp near loc_A2C4E
