; EA memory manager: free a memory block.
bits 32
%include "hockey.inc"
section s_8D2D8 progbits alloc exec nowrite align=1
extern findmemblock, PushMemDescriptorLocked
global FreeMemBlock
;-----------------------------------------------------------------------------
; FreeMemBlock                                                    8D2D8  95 PC
; Memory manager: findmemblock on the pointer and frees the block (under the
; memory lock MemLockHandle); 600+ calls
;-----------------------------------------------------------------------------
FreeMemBlock:
        mov edx, dword [byte esp+04h]
        push edx
        call findmemblock
        add esp, byte 4
        push eax
        call PushMemDescriptorLocked
        add esp, byte 4
        ret
        db 090h
