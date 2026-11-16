; Keyboard handlers run on the way out of the program.
bits 32
%include "hockey.inc"
section s_986CC progbits alloc exec nowrite align=1
global TestAndSetFlag, MemUnlock
TestAndSetFlag:
        mov eax, dword [byte esp+04h]
        cmp dword [eax], byte 0
        je short .1
        xor eax, eax
        ret
.1:
        mov dword [eax], 1
        mov eax, 1
        ret
MemUnlock:
        mov eax, dword [byte esp+04h]
        mov dword [eax], 0
        ret
