; Taking a snapshot of the screen.
bits 32
%include "hockey.inc"
section s_9D352 progbits alloc exec nowrite align=1
extern __hook387, __8087, _Extender, byte_D4D08, __real87, dword_D41F4, dword_D5194, dword_D51D4
extern sub_A35EC, sub_A365C, word_D41F8, word_D41FA, word_D51D8, word_D51DA
global InitFpuFlags, loc_9D3A4, loc_9D3C8, loc_9D3F0, loc_9D409, loc_9D41C, MakeFpuGate, HookCoprocessorVector
global loc_9D471, loc_9D486, SetSystemFpuFlag
InitFpuFlags:
        mov byte [__8087], 3
        mov byte [__real87], 1
        db 066h,0Fh,01h,025h
        dd word_D51DA
        and word [word_D51DA], byte 6
        sub esp, byte 8
        sidt [esp]
        mov ebx, dword [byte esp+02h]
        add ebx, byte 38h
        add esp, byte 8
        cmp byte [byte_D4D08], 0
        je short loc_9D3A4
        call MakeFpuGate
        o16 mov es, word [word_D41FA]
        mov dword [es:ebx], edx
        mov dword [byte es:ebx+04h], ecx
        call SetSystemFpuFlag
        jmp short loc_9D41C
loc_9D3A4:
        cmp byte [_Extender], 0
        jne short loc_9D3C8
        mov ax, 2507h
        push ds
        mov cx, cs
        mov ds, ecx
        lea edx, [sub_A365C]
        int 21h
        pop ds
        mov al, 4
        mov ah, 0F3h
        int 21h
        jmp short loc_9D41C
loc_9D3C8:
        cmp byte [_Extender], 9
        jne short loc_9D3F0
        call MakeFpuGate
        mov dword [ebx], edx
        mov dword [byte ebx+04h], ecx
        mov eax, 0E02h
        mov ebx, 4
        mov ecx, dword [dword_D41F4]
        call dword [byte ecx+030h]
        jmp short loc_9D41C
loc_9D3F0:
        cmp byte [_Extender], 1
        jne short loc_9D409
        mov dx, word [word_D41F8]
        sub eax, eax
        call __hook387
        jmp short loc_9D41C
loc_9D409:
        sub dx, dx
        sub eax, eax
        call __hook387
        cmp al, 1
        je short loc_9D41C
        call HookCoprocessorVector
loc_9D41C:
        ret
MakeFpuGate:
        lea ecx, [sub_A365C]
        mov dx, cs
        shl edx, 10h
        mov dx, cx
        mov cx, cs
        and cl, 3
        shl cx, 0Dh
        or ch, 8Eh
        ret
HookCoprocessorVector:
        mov cl, 7
        mov ax, 2502h
        int 21h
        mov dword [dword_D51D4], ebx
        o16 mov word [word_D51D8], es
        cmp byte [_Extender], 3
        mov cl, 7
        mov ax, 2504h
        push ds
        push cs
        pop ds
        jl short loc_9D471
        lea edx, [sub_A35EC]
        int 21h
        pop ds
        call SetSystemFpuFlag
        jmp short loc_9D486
loc_9D471:
        lea edx, [sub_A365C]
        int 21h
        pop ds
        mov ecx, cr0
        or ecx, byte 4
        and ecx, byte 0FFFFFFFDh
        mov cr0, ecx
loc_9D486:
        ret
SetSystemFpuFlag:
        xor ebx, ebx
        lea edx, [dword_D5194]
        mov ax, 2535h
        int 21h
        or dword [dword_D5194], byte 4
        and dword [dword_D5194], byte 0FFFFFFFDh
        inc ebx
        int 21h
        ret
