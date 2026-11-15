; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_91350 progbits alloc exec nowrite align=1
extern __STOSB
global memset_
memset_:
        push eax
        push ecx
        mov dh, dl
        shl edx, 8
        mov dl, dh
        shl edx, 8
        mov dl, dh
        mov ecx, ebx
        call __STOSB
        pop ecx
        pop eax
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h
