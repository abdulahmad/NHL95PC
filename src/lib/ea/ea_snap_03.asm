; Taking a snapshot of the screen.
bits 32
%include "hockey.inc"
section s_9D521 progbits alloc exec nowrite align=1
extern _Extender, dword_D5194, dword_D51D4, word_D51D8, word_D51DA
global EmuRestoreFpuVector, loc_9D548, loc_9D55B, EmuRestoreRealVector, sub_9D57D, loc_9D582
EmuRestoreFpuVector:
        mov cl, 7
        mov ax, 2504h
        mov edx, dword [dword_D51D4]
        push ds
        o16 mov ds, word [word_D51D8]
        int 21h
        pop ds
        cmp byte [_Extender], 3
        jl short loc_9D548
        call EmuRestoreRealVector
        jmp short loc_9D55B
loc_9D548:
        mov ecx, cr0
        and ecx, byte 0FFFFFFF9h
        mov dx, word [word_D51DA]
        or cx, dx
        mov cr0, ecx
loc_9D55B:
        ret
EmuRestoreRealVector:
        xor ebx, ebx
        lea edx, [dword_D5194]
        mov ax, 2535h
        int 21h
        xor ecx, ecx
        mov cx, word [word_D51DA]
        mov dword [dword_D5194], ecx
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
