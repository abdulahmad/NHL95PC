; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_98683 progbits alloc exec nowrite align=1
extern __EnterWVIDEO_, dword_EDEFC, WriteConsoleMessage
global __fatal_runtime_error_, loc_9869D, nullsub_7, sub_986B0, MemLock
__fatal_runtime_error_:
        push ebx
        push ecx
        mov ebx, eax
        mov ecx, edx
        mov edx, ds
        call __EnterWVIDEO_
        test eax, eax
        jne short loc_9869D
        mov eax, ebx
        mov edx, ecx
        call WriteConsoleMessage
loc_9869D:
        pop ecx
        pop ebx
        ret
nullsub_7:
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
sub_986B0:
        xor edx, edx
        mov dword [dword_EDEFC], edx
        mov eax, dword_EDEFC
        ret
        db 08Bh,0C0h
MemLock:	;IDA: unknown_libname_22
        mov eax, dword [byte esp+04h]
        mov dword [eax], 1
        ret
        db 090h
