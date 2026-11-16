; Watcom C runtime. Stack checks and the library routines the compiled code calls.
bits 32
%include "hockey.inc"
section s_92D21 progbits alloc exec nowrite align=1
extern __set_errno_dos_, CharClassTable
global stricmp_, unlink_, atoi_
stricmp_:
        push ebx
.1:
        mov bl, byte [eax]
        mov bh, byte [edx]
        cmp bl, 41h
        jb short .2
        cmp bl, 5Ah
        ja short .2
        add bl, 20h
.2:
        cmp bh, 41h
        jb short .3
        cmp bh, 5Ah
        ja short .3
        add bh, 20h
.3:
        cmp bl, bh
        jne short .4
        test bh, bh
        je short .4
        inc eax
        inc edx
        jmp short .1
.4:
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
        jge short .1
        and eax, 0FFFFh
        call __set_errno_dos_
        pop edx
        ret
.1:
        xor eax, eax
        pop edx
        ret
        db 00h,00h,00h
atoi_:	;IDA: unknown_libname_4
        push ebx
        push ecx
        push edx
.1:
        mov dl, byte [eax]
        inc dl
        and edx, 0FFh
        test byte [dword edx+CharClassTable], 2
        je short .2
        inc eax
        jmp short .1
.2:
        mov cl, byte [eax]
        cmp cl, 2Bh
        je short .3
        cmp cl, 2Dh
        jne short .4
.3:
        inc eax
.4:
        xor ebx, ebx
.5:
        mov dl, byte [eax]
        inc dl
        and edx, 0FFh
        test byte [dword edx+CharClassTable], 20h
        je short .6
        imul ebx, byte 0Ah
        xor edx, edx
        mov dl, byte [eax]
        add ebx, edx
        inc eax
        sub ebx, byte 30h
        jmp short .5
.6:
        cmp cl, 2Dh
        jne short .7
        neg ebx
.7:
        mov eax, ebx
        pop edx
        pop ecx
        pop ebx
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
