; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_B00E4 progbits alloc exec nowrite align=1
global strrchr_, loc_B00EA, loc_B00F0
strrchr_:
        push ebx
        push ecx
        mov cl, dl
        xor ebx, ebx
loc_B00EA:
        cmp cl, byte [eax]
        jne short loc_B00F0
        mov ebx, eax
loc_B00F0:
        mov edx, eax
        mov ch, byte [edx]
        inc eax
        test ch, ch
        jne short loc_B00EA
        mov eax, ebx
        pop ecx
        pop ebx
        ret
        db 00h,00h
