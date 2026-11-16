; Taking a snapshot of the screen.
bits 32
%include "hockey.inc"
section s_9D521 progbits alloc exec nowrite align=1
extern _Extender, FpuSystemFlags, OldFpuVectorOffset, OldFpuVectorSelector, FpuCr0Bits
global EmuRestoreFpuVector, loc_9D548, loc_9D55B, EmuRestoreRealVector, sub_9D57D, loc_9D582
EmuRestoreFpuVector:
        mov cl, 7
        mov ax, 2504h
        mov edx, dword [OldFpuVectorOffset]
        push ds
        o16 mov ds, word [OldFpuVectorSelector]
        int 21h
        pop ds
        cmp byte [_Extender], 3
        jl short loc_9D548
        call EmuRestoreRealVector
        jmp short loc_9D55B
loc_9D548:
        mov ecx, cr0
        and ecx, byte 0FFFFFFF9h
        mov dx, word [FpuCr0Bits]
        or cx, dx
        mov cr0, ecx
loc_9D55B:
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
sub_9D57D:
        wait
        fnsave [eax]
        wait
        ret
loc_9D582:
        frstor [eax]
        wait
        ret
