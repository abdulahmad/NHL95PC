; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_98683 progbits alloc exec nowrite align=1
extern __EnterWVIDEO_, MemLockHandleStore, WriteConsoleMessage
global __fatal_runtime_error_, DefaultFpeHandler, MemLockHandleInit, MemLock
__fatal_runtime_error_:
        push ebx
        push ecx
        mov ebx, eax
        mov ecx, edx
        mov edx, ds
        call __EnterWVIDEO_
        test eax, eax
        jne short .1
        mov eax, ebx
        mov edx, ecx
        call WriteConsoleMessage
.1:
        pop ecx
        pop ebx
        ret
DefaultFpeHandler:
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
MemLockHandleInit:
        xor edx, edx
        mov dword [MemLockHandleStore], edx
        mov eax, MemLockHandleStore
        ret
        db 08Bh,0C0h
MemLock:	;IDA: unknown_libname_22
        mov eax, dword [byte esp+04h]
        mov dword [eax], 1
        ret
        db 090h
