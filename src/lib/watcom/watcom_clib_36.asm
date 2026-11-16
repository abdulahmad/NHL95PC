; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_9D4A7 progbits alloc exec nowrite align=1
extern __unhook387, _Extender, Is8087, __real87, FpuFlags, EmuRestoreFpuVector, EmuRestoreRealVector, EmuHookFlags
extern FpuCr0Bits
global __sys_fini_387_emulator
;-----------------------------------------------------------------------------
; __sys_fini_387_emulator                                       9D4A7  library
; Run-time library: removes the x87 emulator
;-----------------------------------------------------------------------------
__sys_fini_387_emulator:
        cmp byte [__real87], 1
        je short .1
        ret
.1:
        push ecx
        push ebx
        push edx
        mov al, byte [_Extender]
        cmp byte [Is8087], 0
        je short .2
        call EmuRestoreRealVector
        jmp short .6
.2:
        cmp al, 9
        jne short .3
        mov eax, 0E02h
        mov ebx, 0
        mov ecx, dword [FpuFlags]
        call dword [byte ecx+030h]
        jmp short .6
.3:
        cmp al, 0
        jne short .4
        mov ax, word [FpuCr0Bits]
        mov ah, 0F3h
        int 21h
        jmp short .6
.4:
        cmp al, 1
        jne short .5
        mov dx, word [EmuHookFlags]
        sub eax, eax
        call __unhook387
        jmp short .6
.5:
        sub edx, edx
        call __unhook387
        cmp al, 1
        je short .6
        call EmuRestoreFpuVector
.6:
        mov byte [__real87], 0
        pop edx
        pop ebx
        pop ecx
        ret
