; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_A6B87 progbits alloc exec nowrite align=1
extern _environ, strnicmp_
global getenv_, loc_A6BB3, loc_A6BCF, loc_A6BD2, loc_A6BD8, loc_A6BDA
getenv_:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov ebp, eax
        mov esi, dword [_environ]
        test esi, esi
        je short loc_A6BD8
        test eax, eax
        je short loc_A6BD8
        mov edi, eax
        push es
        mov eax, ds
        mov es, eax
        sub ecx, ecx
        dec ecx
        xor eax, eax
        repne scasb
        not ecx
        dec ecx
        pop es
        mov edi, ecx
        jmp short loc_A6BD2
loc_A6BB3:
        mov eax, ecx
        mov edx, ebp
        mov ebx, edi
        call strnicmp_
        test eax, eax
        jne short loc_A6BCF
        cmp byte [ecx+edi], 3Dh
        jne short loc_A6BCF
        lea eax, [byte edi+01h]
        add eax, ecx
        jmp short loc_A6BDA
loc_A6BCF:
        add esi, byte 4
loc_A6BD2:
        mov ecx, dword [esi]
        test ecx, ecx
        jne short loc_A6BB3
loc_A6BD8:
        xor eax, eax
loc_A6BDA:
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
