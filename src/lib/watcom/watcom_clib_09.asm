; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_909E0 progbits alloc exec nowrite align=1
global strnicmp_, loc_909E4, loc_909E8, loc_909EF, loc_90A03, loc_90A16, loc_90A2E
strnicmp_:
        push ecx
        sub esp, byte 4
loc_909E4:
        test ebx, ebx
        jne short loc_909EF
loc_909E8:
        xor eax, eax
        add esp, byte 4
        pop ecx
        ret
loc_909EF:
        mov ch, byte [edx]
        mov cl, byte [eax]
        mov byte [esp], ch
        cmp cl, 41h
        jb short loc_90A03
        cmp cl, 5Ah
        ja short loc_90A03
        add cl, 20h
loc_90A03:
        mov ch, byte [esp]
        cmp ch, 41h
        jb short loc_90A16
        cmp ch, 5Ah
        ja short loc_90A16
        add ch, 20h
        mov byte [esp], ch
loc_90A16:
        mov ch, byte [esp]
        cmp cl, ch
        je short loc_90A2E
        xor edx, edx
        xor eax, eax
        mov dl, cl
        mov al, ch
        sub edx, eax
        mov eax, edx
        add esp, byte 4
        pop ecx
        ret
loc_90A2E:
        test ch, ch
        je short loc_909E8
        inc eax
        inc edx
        dec ebx
        jmp short loc_909E4
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h
