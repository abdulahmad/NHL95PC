; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_9C563 progbits alloc exec nowrite align=1
extern __fprtf_, __prtf_
global mem_putc__0, vsprintf_, j___fprtf_
mem_putc__0:
        push ebx
        push ecx
        mov bl, dl
        mov edx, dword [eax]
        lea ecx, [byte edx+01h]
        mov dword [eax], ecx
        mov byte [edx], bl
        inc dword [byte eax+010h]
        pop ecx
        pop ebx
        ret
vsprintf_:
        push ecx
        push esi
        mov esi, eax
        mov ecx, mem_putc__0
        call __prtf_
        mov byte [esi+eax], 0
        pop esi
        pop ecx
        ret
        db 00h
j___fprtf_:
        jmp near __fprtf_
        db 00h,00h,00h
