; EA helpers: restore the FPU vectors, save the 8087 state.
bits 32
%include "hockey.inc"
section s_9D521 progbits alloc exec nowrite align=1
extern _Extender, FpuCr0Bits, FpuSystemFlags, OldFpuVectorOffset, OldFpuVectorSelector
global EmuRestoreFpuVector, EmuRestoreRealVector, __save_8087_
;-----------------------------------------------------------------------------
; EmuRestoreFpuVector                          9D521  95 PC, medium confidence
; Puts back the original coprocessor-missing vector and CR0 coprocessor bits
; when the emulator shuts down
;-----------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------
; EmuRestoreRealVector                         9D55C  95 PC, medium confidence
; Restores the saved real-mode vector through the DOS extender
;-----------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------
; __save_8087_                                                    9D57D  95 PC
; Run-time library: saves the FPU state
;-----------------------------------------------------------------------------
__save_8087_:
        wait
        fnsave [eax]
        wait
        ret
        frstor [eax]
        wait
        ret
