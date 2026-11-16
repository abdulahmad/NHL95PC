; DOS/4GW glue. DPMI memory blocks and interrupt calls.
bits 32
%include "hockey.inc"
section s_A2B95 progbits alloc exec nowrite align=1
extern _Extender, _ExtenderSubtype, _curbrk, _STACKTOP, ErrnoPtr
global sbrk_, sbrk_, __brk_
sbrk_:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ecx, eax
        cmp byte [_Extender], 1
        jne short .1
        cmp byte [_ExtenderSubtype], 0
        je short .2
.1:
        mov dh, byte [_Extender]
        cmp dh, 9
        jne near .8
.2:
        test ecx, ecx
        jle short .6
        add ecx, 0FFFh
        mov al, byte [_Extender]
        and cx, 0F000h
        cmp al, 1
        jne short .4
        mov eax, ecx
        sar eax, 10h
        mov ebx, eax
        mov ah, 5
        mov al, 1
        int 31h
        sbb eax, eax
        inc eax
        je short .3
        mov ax, bx
        shl eax, 10h
        mov ax, cx
        mov word [eax], di
        mov word [byte eax+02h], si
.3:
        jmp short .5
.4:
        mov ebx, ecx
        mov eax, 80004800h
        int 21h
        sbb ebx, ebx
        not ebx
        and eax, ebx
.5:
        test eax, eax
        jne short sbrk_+0B9h
        call ErrnoPtr
        mov dword [eax], 5
        jmp short .7
.6:
        call ErrnoPtr
        mov dword [eax], 9
.7:
        mov eax, 0FFFFFFFFh
        jmp short sbrk_+0B9h
.8:
        cmp dh, 2
        jb short .9
        cmp dh, 8
        ja short .9
        xor eax, eax
        mov eax, ds
        lsl eax, eax
        inc eax
        mov dword [_curbrk], eax
.9:
        mov eax, dword [_curbrk]
        add eax, ecx
        call __brk_
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
        jb short .4
        cmp byte [_Extender], 0
        jne short .5
        mov ebp, dword [esp]
        add ebp, byte 0Fh
        shr ebp, 4
        test ebp, ebp
        jne short .1
        mov ebp, 0FFFFFFFh
.1:
        xor ebx, ebx
        mov eax, ds
        mov bx, ax
        mov ah, 0EDh
        int 21h
        shl eax, 1Fh
        and edi, 0FFFFh
        or edi, eax
        test edi, edi
        jge short .2
        mov es, edi
        mov ebx, ebp
        mov ah, 4Ah
        int 21h
        rcl eax, 1
        ror eax, 1
        test eax, eax
        jl short .4
.2:
        mov eax, ds
        mov es, eax
        mov ebx, ebp
.3:
        mov ah, 4Ah
        int 21h
        rcl eax, 1
        ror eax, 1
        test eax, eax
        jge short .8
.4:
        call ErrnoPtr
        mov dword [eax], 5
        mov eax, 0FFFFFFFFh
        jmp short .9
.5:
        mov ebx, dword [esp]
        add ebx, 0FFFh
        shr ebx, 0Ch
        test ebx, ebx
        jne short .6
        mov ebx, 0FFFFFh
.6:
        mov dl, byte [_Extender]
        cmp dl, 1
        jne short .7
        cmp dl, byte [_ExtenderSubtype]
        jne short .7
        shl ebx, 8
.7:
        mov eax, ds
        mov es, eax
        jmp short .3
.8:
        mov ebx, dword [esp]
        mov eax, dword [_curbrk]
        mov dword [_curbrk], ebx
.9:
        add esp, byte 4
        pop ebp
        pop es
        jmp near sbrk_+0B9h
