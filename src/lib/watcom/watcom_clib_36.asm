; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_9D4A7 progbits alloc exec nowrite align=1
extern __unhook387, _Extender, Is8087, __real87, FpuFlags, EmuRestoreFpuVector, EmuRestoreRealVector, EmuHookFlags
extern FpuCr0Bits
global __sys_fini_387_emulator, loc_9D4B1, loc_9D4C9, loc_9D4E2, loc_9D4F2, loc_9D506, loc_9D516
__sys_fini_387_emulator:
        cmp byte [__real87], 1
        je short loc_9D4B1
        ret
loc_9D4B1:
        push ecx
        push ebx
        push edx
        mov al, byte [_Extender]
        cmp byte [Is8087], 0
        je short loc_9D4C9
        call EmuRestoreRealVector
        jmp short loc_9D516
loc_9D4C9:
        cmp al, 9
        jne short loc_9D4E2
        mov eax, 0E02h
        mov ebx, 0
        mov ecx, dword [FpuFlags]
        call dword [byte ecx+030h]
        jmp short loc_9D516
loc_9D4E2:
        cmp al, 0
        jne short loc_9D4F2
        mov ax, word [FpuCr0Bits]
        mov ah, 0F3h
        int 21h
        jmp short loc_9D516
loc_9D4F2:
        cmp al, 1
        jne short loc_9D506
        mov dx, word [EmuHookFlags]
        sub eax, eax
        call __unhook387
        jmp short loc_9D516
loc_9D506:
        sub edx, edx
        call __unhook387
        cmp al, 1
        je short loc_9D516
        call EmuRestoreFpuVector
loc_9D516:
        mov byte [__real87], 0
        pop edx
        pop ebx
        pop ecx
        ret
