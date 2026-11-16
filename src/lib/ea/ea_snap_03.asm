; Taking a snapshot of the screen.
bits 32
%include "hockey.inc"
section s_9D521 progbits alloc exec nowrite align=1
extern _Extender, FpuSystemFlags, OldFpuVectorOffset, OldFpuVectorSelector, FpuCr0Bits
global EmuRestoreFpuVector, EmuRestoreRealVector, __save_8087_
EmuRestoreFpuVector:
        mov cl, 7
        mov ax, 2504h
        mov edx, dword [OldFpuVectorOffset]
        push ds
        o16 mov ds, word [OldFpuVectorSelector]
        int 21h
        pop ds
        cmp byte [_Extender], 3
        jl short .1
        call EmuRestoreRealVector
        jmp short .2
.1:
        mov ecx, cr0
        and ecx, byte 0FFFFFFF9h
        mov dx, word [FpuCr0Bits]
        or cx, dx
        mov cr0, ecx
.2:
        ret
EmuRestoreRealVector:
        xor ebx, ebx
        lea edx, [FpuSystemFlags]
        mov ax, 2535h
        int 21h
        xor ecx, ecx
        mov cx, word [FpuCr0Bits]
        mov dword [FpuSystemFlags], ecx
        inc ebx
        int 21h
        ret
__save_8087_:
        wait
        fnsave [eax]
        wait
        ret
        frstor [eax]
        wait
        ret
