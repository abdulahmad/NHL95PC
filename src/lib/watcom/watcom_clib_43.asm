; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_A6B87 progbits alloc exec nowrite align=1
extern _environ, strnicmp_
global getenv_
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
        je short .4
        test eax, eax
        je short .4
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
        jmp short .3
.1:
        mov eax, ecx
        mov edx, ebp
        mov ebx, edi
        call strnicmp_
        test eax, eax
        jne short .2
        cmp byte [ecx+edi], 3Dh
        jne short .2
        lea eax, [byte edi+01h]
        add eax, ecx
        jmp short .5
.2:
        add esi, byte 4
.3:
        mov ecx, dword [esi]
        test ecx, ecx
        jne short .1
.4:
        xor eax, eax
.5:
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
