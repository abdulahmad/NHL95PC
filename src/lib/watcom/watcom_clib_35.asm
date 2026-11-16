; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_9D307 progbits alloc exec nowrite align=1
extern __cnvs2d_, loc_A313F, off_D5668, off_D566C, InitFpuFlags, DefaultControlWord
global __setEFGfmt_, __sys_init_387_emulator, loc_9D333, loc_9D33C
__setEFGfmt_:
        push ebx
        push edx
        mov edx, loc_A313F
        mov ebx, __cnvs2d_
        mov dword [off_D5668], edx
        mov dword [off_D566C], ebx
        pop edx
        pop ebx
        ret
__sys_init_387_emulator:
        push es
        push ecx
        push ebx
        push edx
        fninit
        push eax
        fnstcw word [esp]
        pop eax
        cmp ah, 3
        je short loc_9D333
        inc ebp
loc_9D333:
        or ebp, ebp
        je short loc_9D33C
        call InitFpuFlags
loc_9D33C:
        wait
        fninit
        fldcw word [DefaultControlWord]
        fldz
        fldz
        fldz
        fldz
        pop edx
        pop ebx
        pop ecx
        pop es
        ret
