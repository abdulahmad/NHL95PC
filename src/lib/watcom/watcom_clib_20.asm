; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_93284 progbits alloc exec nowrite align=1
extern __setbits_, byte_C4C70
global strcspn_, loc_93296, loc_932B8, loc_932C0
strcspn_:
        push ebx
        push ecx
        sub esp, byte 20h
        mov ebx, eax
        mov eax, esp
        call __setbits_
        xor ecx, ecx
        jmp short loc_932B8
loc_93296:
        mov edx, eax
        shr edx, 3
        mov dl, byte [esp+edx]
        and eax, byte 7
        and edx, 0FFh
        mov al, byte [dword eax+byte_C4C70]
        and eax, 0FFh
        test edx, eax
        jne short loc_932C0
        inc ecx
        inc ebx
loc_932B8:
        xor eax, eax
        mov al, byte [ebx]
        test eax, eax
        jne short loc_93296
loc_932C0:
        mov eax, ecx
        add esp, byte 20h
        pop ecx
        pop ebx
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h
