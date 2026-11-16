; Keyboard handlers run on the way out of the program.
bits 32
%include "hockey.inc"
section s_986CC progbits alloc exec nowrite align=1
global TestAndSetFlag, MemUnlock
;-----------------------------------------------------------------------------
; TestAndSetFlag                               986CC  95 PC, medium confidence
; Sets a flag and returns 1, or returns 0 if it was already set
;-----------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------
; MemUnlock                                    986E4  95 PC, medium confidence
; Clears the memory lock
;-----------------------------------------------------------------------------
MemUnlock:
        mov eax, dword [byte esp+04h]
        mov dword [eax], 0
        ret
