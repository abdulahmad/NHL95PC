; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_98A81 progbits alloc exec nowrite align=1
extern _environ, sub_A1CF4
global spawnl_, strncmp_, loc_98AA0, loc_98AA4, loc_98AA8, loc_98ABE
spawnl_:
        push ebx
        push ecx
        push edx
        mov eax, dword [byte esp+010h]
        mov edx, dword [byte esp+014h]
        lea ebx, [byte esp+018h]
        mov ecx, dword [_environ]
        call sub_A1CF4
        pop edx
        pop ecx
        pop ebx
        ret
strncmp_:
        push ecx
loc_98AA0:
        test ebx, ebx
        jne short loc_98AA8
loc_98AA4:
        xor eax, eax
        pop ecx
        ret
loc_98AA8:
        mov cl, byte [eax]
        mov ch, byte [edx]
        cmp cl, ch
        je short loc_98ABE
        xor ebx, ebx
        xor eax, eax
        mov bl, cl
        mov al, ch
        sub ebx, eax
        mov eax, ebx
        pop ecx
        ret
loc_98ABE:
        cmp byte [eax], 0
        je short loc_98AA4
        inc eax
        inc edx
        dec ebx
        jmp short loc_98AA0
