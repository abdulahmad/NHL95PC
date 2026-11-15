; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_92D21 progbits alloc exec nowrite align=1
extern __set_errno_dos_, byte_C4B6C
global stricmp_, loc_92D22, loc_92D33, loc_92D40, loc_92D4C, unlink_, loc_92D75, unknown_libname_4
global loc_92D7F, loc_92D95, loc_92DA1, loc_92DA2, loc_92DA4, loc_92DC6, loc_92DCD
stricmp_:
        push ebx
loc_92D22:
        mov bl, byte [eax]
        mov bh, byte [edx]
        cmp bl, 41h
        jb short loc_92D33
        cmp bl, 5Ah
        ja short loc_92D33
        add bl, 20h
loc_92D33:
        cmp bh, 41h
        jb short loc_92D40
        cmp bh, 5Ah
        ja short loc_92D40
        add bh, 20h
loc_92D40:
        cmp bl, bh
        jne short loc_92D4C
        test bh, bh
        je short loc_92D4C
        inc eax
        inc edx
        jmp short loc_92D22
loc_92D4C:
        xor edx, edx
        xor eax, eax
        mov dl, bl
        mov al, bh
        sub edx, eax
        mov eax, edx
        pop ebx
        ret
unlink_:
        push edx
        mov edx, eax
        mov ah, 41h
        int 21h
        rcl eax, 1
        ror eax, 1
        test eax, eax
        jge short loc_92D75
        and eax, 0FFFFh
        call __set_errno_dos_
        pop edx
        ret
loc_92D75:
        xor eax, eax
        pop edx
        ret
        db 00h,00h,00h
unknown_libname_4:
        push ebx
        push ecx
        push edx
loc_92D7F:
        mov dl, byte [eax]
        inc dl
        and edx, 0FFh
        test byte [dword edx+byte_C4B6C], 2
        je short loc_92D95
        inc eax
        jmp short loc_92D7F
loc_92D95:
        mov cl, byte [eax]
        cmp cl, 2Bh
        je short loc_92DA1
        cmp cl, 2Dh
        jne short loc_92DA2
loc_92DA1:
        inc eax
loc_92DA2:
        xor ebx, ebx
loc_92DA4:
        mov dl, byte [eax]
        inc dl
        and edx, 0FFh
        test byte [dword edx+byte_C4B6C], 20h
        je short loc_92DC6
        imul ebx, byte 0Ah
        xor edx, edx
        mov dl, byte [eax]
        add ebx, edx
        inc eax
        sub ebx, byte 30h
        jmp short loc_92DA4
loc_92DC6:
        cmp cl, 2Dh
        jne short loc_92DCD
        neg ebx
loc_92DCD:
        mov eax, ebx
        pop edx
        pop ecx
        pop ebx
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
