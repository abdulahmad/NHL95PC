; The MT-32 and MPU-401 driver.
bits 32
%include "hockey.inc"
section s_9FD94 progbits alloc exec nowrite align=1
extern __GETDS, byte_D5279, byte_D527A, dword_D5260, dword_D5264, dword_D5268, dword_D526C, dword_D5270
extern dword_D5274
global sub_9FD94, sub_9FD9A, sub_9FDEA, sub_9FE3B, loc_9FE46, sub_9FE94, sub_9FEB0, loc_9FEBE
global loc_9FECC, loc_9FED3, loc_9FEDE, loc_9FEEC, loc_9FF00, loc_9FF02, sub_9FF04, loc_9FF11
global loc_9FF17, loc_9FF1D, loc_9FF23, loc_9FF27, loc_9FF2B, loc_9FF31, loc_9FF35, loc_9FF3B
global loc_9FF3F, loc_9FF4B, loc_9FF51, sub_9FF55, loc_9FF60, loc_9FF6E, loc_9FF77, sub_9FF78
global loc_9FF86, loc_9FF94, loc_9FF9E, sub_9FFA0, sub_9FFA6, loc_9FFB2, loc_9FFC1
sub_9FD94:
        mov eax, 70330h
        ret
sub_9FD9A:
        push ebp
        LD mov, ebp, esp
        movzx eax, word [byte ebp+08h]
        mov dword [dword_D5260], eax
        inc eax
        mov dword [dword_D5264], eax
        movzx eax, word [byte ebp+0Ah]
        mov byte [byte_D5279], al
        LD mov, cl, al
        mov al, 1
        shl al, cl
        mov byte [byte_D527A], al
        push dword 0FFh
        call sub_9FEB0
        push byte 24h
        call sub_9FF04
        add esp, byte 8
        call sub_9FF55
        mov eax, 3Fh
        push eax
        call sub_9FEB0
        add esp, byte 4
        inc eax
        leave
        ret
sub_9FDEA:
        push ebp
        LD mov, ebp, esp
        movzx eax, word [byte ebp+08h]
        mov dword [dword_D5260], eax
        inc eax
        mov dword [dword_D5264], eax
        movzx eax, word [byte ebp+0Ah]
        mov byte [byte_D5279], al
        LD mov, cl, al
        mov al, 1
        shl al, cl
        mov byte [byte_D527A], al
        pushfw
        cli
        mov eax, 0
        mov dword [dword_D5268], eax
        mov eax, 0FFh
        mov dword [dword_D526C], eax
        mov eax, dword [dword_D5270]
        or eax, dword [dword_D5274]
        call sub_9FE94
        popfw
        leave
        ret
sub_9FE3B:
        pusha
        mov ebx, 0B0h
        mov ecx, 10h
loc_9FE46:
        db 051h                                 ; insn: push ecx
        db 053h                                 ; insn: push ebx
        call sub_9FF78
        push byte 7Bh
        call sub_9FF78
        push byte 0
        call sub_9FF78
        add esp, byte 0Ch
        pop ecx
        inc ebx
        loop loc_9FE46
        push dword 0FFh
        call sub_9FEB0
        push byte 9
        call sub_9FF04
        push dword 0FFh
        call sub_9FEB0
        push byte 9
        call sub_9FF04
        add esp, byte 10h
        mov eax, dword [dword_D5270]
        or eax, dword [dword_D5274]
        popa
        ret
sub_9FE94:
        push dword 0FFh
        call sub_9FEB0
        push byte 9
        call sub_9FF04
        push byte 3Fh
        call sub_9FEB0
        add esp, byte 0Ch
        ret
sub_9FEB0:
        push ebp
        LD mov, ebp, esp
        mov edx, dword [dword_D5264]
        mov ecx, 0FFh
loc_9FEBE:
        in al, dx
        test al, 40h
        je short loc_9FECC
        loop loc_9FEBE
        mov eax, 0FFFFFFFFh
        jmp short loc_9FF02
loc_9FECC:
        pushfw
        cli
        mov eax, dword [byte ebp+08h]
        out dx, al
loc_9FED3:
        mov edx, dword [dword_D5264]
        mov ecx, 0FFh
loc_9FEDE:
        in al, dx
        LD or, al, al
        jge short loc_9FEEC
        loop loc_9FEDE
        mov eax, 0FFFFFFFFh
        jmp short loc_9FF00
loc_9FEEC:
        mov edx, dword [dword_D5260]
        in al, dx
        cmp al, 0FEh
        mov eax, 0
        je short loc_9FF00
        int 0Ah
        jmp short loc_9FED3
loc_9FF00:
        popfw
loc_9FF02:
        leave
        ret
sub_9FF04:
        push ebp
        LD mov, ebp, esp
        mov ecx, dword [byte ebp+08h]
        pushfw
        cli
        in al, 61h
        jmp short loc_9FF11
loc_9FF11:
        and al, 0FEh
        out 61h, al
        jmp short loc_9FF17
loc_9FF17:
        mov al, 0B6h
        out 43h, al
        jmp short loc_9FF1D
loc_9FF1D:
        LD xor, al, al
        out 42h, al
        jmp short loc_9FF23
loc_9FF23:
        out 42h, al
        jmp short loc_9FF27
loc_9FF27:
        in al, 61h
        jmp short loc_9FF2B
loc_9FF2B:
        or al, 1
        out 61h, al
        jmp short loc_9FF31
loc_9FF31:
        in al, 42h
        jmp short loc_9FF35
loc_9FF35:
        in al, 42h
        LD or, al, al
        js short loc_9FF31
loc_9FF3B:
        in al, 42h
        jmp short loc_9FF3F
loc_9FF3F:
        in al, 42h
        LD or, al, al
        jns short loc_9FF3B
        loop loc_9FF31
        in al, 61h
        jmp short loc_9FF4B
loc_9FF4B:
        and al, 0FEh
        out 61h, al
        jmp short loc_9FF51
loc_9FF51:
        popfw
        leave
        ret
sub_9FF55:
        mov edx, dword [dword_D5264]
        mov ecx, 0FFh
loc_9FF60:
        in al, dx
        LD or, al, al
        jge short loc_9FF6E
        loop loc_9FF60
        mov eax, 0FFFFFFFFh
        jmp short loc_9FF77
loc_9FF6E:
        mov edx, dword [dword_D5260]
        LD xor, eax, eax
        in al, dx
loc_9FF77:
        ret
sub_9FF78:
        push ebp
        LD mov, ebp, esp
        mov edx, dword [dword_D5264]
        mov ecx, 0FFh
loc_9FF86:
        in al, dx
        test al, 40h
        je short loc_9FF94
        loop loc_9FF86
        mov eax, 0FFFFFFFFh
        jmp short loc_9FF9E
loc_9FF94:
        mov edx, dword [dword_D5260]
        mov eax, dword [byte ebp+08h]
        out dx, al
loc_9FF9E:
        leave
        ret
sub_9FFA0:
        push ds
        call __GETDS
sub_9FFA6:
        push esi
        push edi
        mov edi, dword [byte esp+010h]
        mov esi, dword [byte esp+014h]
        jmp short loc_9FFC1
loc_9FFB2:
        xor eax, eax
        mov al, byte [esi]
        push eax
        call sub_9FF78
        add esp, byte 4
        dec edi
        inc esi
loc_9FFC1:
        test di, di
        ja short loc_9FFB2
        pop edi
        pop esi
        pop ds
        ret
