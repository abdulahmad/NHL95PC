; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_909E0 progbits alloc exec nowrite align=1
global strnicmp_
;-----------------------------------------------------------------------------
; strnicmp_                                                     909E0  library
; Run-time library strnicmp: compares at most n characters, ignoring case
;-----------------------------------------------------------------------------
strnicmp_:
        push ecx
        sub esp, byte 4
.1:
        test ebx, ebx
        jne short .3
.2:
        xor eax, eax
        add esp, byte 4
        pop ecx
        ret
.3:
        mov ch, byte [edx]
        mov cl, byte [eax]
        mov byte [esp], ch
        cmp cl, 41h
        jb short .4
        cmp cl, 5Ah
        ja short .4
        add cl, 20h
.4:
        mov ch, byte [esp]
        cmp ch, 41h
        jb short .5
        cmp ch, 5Ah
        ja short .5
        add ch, 20h
        mov byte [esp], ch
.5:
        mov ch, byte [esp]
        cmp cl, ch
        je short .6
        xor edx, edx
        xor eax, eax
        mov dl, cl
        mov al, ch
        sub edx, eax
        mov eax, edx
        add esp, byte 4
        pop ecx
        ret
.6:
        test ch, ch
        je short .2
        inc eax
        inc edx
        dec ebx
        jmp short .1
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h
