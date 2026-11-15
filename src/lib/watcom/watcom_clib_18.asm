; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_92EF9 progbits alloc exec nowrite align=1
extern __fsetbits_, byte_C4C70
global _fstrcspn_, loc_92F0F, loc_92F31, loc_92F3A
_fstrcspn_:
        push esi
        push es
        sub esp, byte 20h
        mov es, edx
        mov esi, eax
        mov eax, esp
        mov edx, ds
        call __fsetbits_
        xor ebx, ebx
        jmp short loc_92F31
loc_92F0F:
        mov edx, eax
        shr edx, 3
        mov dl, byte [esp+edx]
        and eax, byte 7
        and edx, 0FFh
        mov al, byte [dword eax+byte_C4C70]
        and eax, 0FFh
        test edx, eax
        jne short loc_92F3A
        inc ebx
        inc esi
loc_92F31:
        xor eax, eax
        mov al, byte [es:esi]
        test eax, eax
        jne short loc_92F0F
loc_92F3A:
        mov eax, ebx
        add esp, byte 20h
        pop es
        pop esi
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
