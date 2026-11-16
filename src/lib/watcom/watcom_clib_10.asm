; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_90AC4 progbits alloc exec nowrite align=1
extern __prtf_, TextWidthN
global fputchar, mem_putc_, sprintf_, memcpy_
fputchar:
        push dword 200h
        mov edx, dword [byte esp+08h]
        push edx
        call TextWidthN
        add esp, byte 8
        ret
mem_putc_:
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
sprintf_:
        push ebx
        push ecx
        push edx
        sub esp, byte 4
        lea eax, [byte esp+01Ch]
        mov edx, dword [byte esp+018h]
        mov ebx, esp
        mov ecx, mem_putc_
        mov dword [esp], eax
        mov eax, dword [byte esp+014h]
        call __prtf_
        mov edx, dword [byte esp+014h]
        mov byte [edx+eax], 0
        add esp, byte 4
        pop edx
        pop ecx
        pop ebx
        ret
        db 00h,00h,00h,00h,00h,00h
memcpy_:
        push ecx
        push esi
        push edi
        mov edi, eax
        mov esi, edx
        mov ecx, ebx
        push es
        mov eax, ds
        mov es, eax
        push edi
        mov eax, ecx
        shr ecx, 2
        repne movsd
        LD mov, cl, al
        and cl, 3
        repne movsb
        pop edi
        pop es
        mov eax, edi
        pop edi
        pop esi
        pop ecx
        db 0C3h                                 ; insn: ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
