; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_98A81 progbits alloc exec nowrite align=1
extern _environ, spawnve_
global spawnl_, strncmp_
;-----------------------------------------------------------------------------
; spawnl_                                                       98A81  library
; C run-time: runs a program with an argument list
;-----------------------------------------------------------------------------
spawnl_:
        push ebx
        push ecx
        push edx
        mov eax, dword [byte esp+010h]
        mov edx, dword [byte esp+014h]
        lea ebx, [byte esp+018h]
        mov ecx, dword [_environ]
        call spawnve_
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; strncmp_                                                      98A9F  library
; Run-time library strncmp: compares at most n characters
;-----------------------------------------------------------------------------
strncmp_:
        push ecx
.1:
        test ebx, ebx
        jne short .3
.2:
        xor eax, eax
        pop ecx
        ret
.3:
        mov cl, byte [eax]
        mov ch, byte [edx]
        cmp cl, ch
        je short .4
        xor ebx, ebx
        xor eax, eax
        mov bl, cl
        mov al, ch
        sub ebx, eax
        mov eax, ebx
        pop ecx
        ret
.4:
        cmp byte [eax], 0
        je short .2
        inc eax
        inc edx
        dec ebx
        jmp short .1
