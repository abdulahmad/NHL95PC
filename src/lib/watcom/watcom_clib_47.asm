; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_B00E4 progbits alloc exec nowrite align=1
global strrchr_
;-----------------------------------------------------------------------------
; strrchr_                                                      B00E4  library
; Run-time library strrchr: the last place of a character in a string
;-----------------------------------------------------------------------------
strrchr_:
        push ebx
        push ecx
        mov cl, dl
        xor ebx, ebx
.1:
        cmp cl, byte [eax]
        jne short .2
        mov ebx, eax
.2:
        mov edx, eax
        mov ch, byte [edx]
        inc eax
        test ch, ch
        jne short .1
        mov eax, ebx
        pop ecx
        pop ebx
        ret
        db 00h,00h
