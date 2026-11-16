; The MT-32 and MPU-401 driver.
bits 32
%include "hockey.inc"
section s_9FD94 progbits alloc exec nowrite align=1
extern __GETDS, byte_D5279, byte_D527A, dword_D5260, dword_D5264, dword_D5268, dword_D526C, dword_D5270
extern dword_D5274
global Mpu401Detect, Mpu401Open, Mpu401Init, Mpu401Close, loc_9FE46, Mpu401Reset, Mpu401Command, loc_9FEBE
global loc_9FECC, loc_9FED3, loc_9FEDE, loc_9FEEC, loc_9FF00, loc_9FF02, Mpu401Delay, loc_9FF11
global loc_9FF17, loc_9FF1D, loc_9FF23, loc_9FF27, loc_9FF2B, loc_9FF31, loc_9FF35, loc_9FF3B
global loc_9FF3F, loc_9FF4B, loc_9FF51, Mpu401ReadData, loc_9FF60, loc_9FF6E, loc_9FF77, Mpu401WriteData
global loc_9FF86, loc_9FF94, loc_9FF9E, Mpu401Midi, loc_9FFB2, loc_9FFC1
Mpu401Detect:
        mov eax, 70330h
        ret
Mpu401Open:
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
        call Mpu401Command
        push byte 24h
        call Mpu401Delay
        add esp, byte 8
        call Mpu401ReadData
        mov eax, 3Fh
        push eax
        call Mpu401Command
        add esp, byte 4
        inc eax
        leave
        ret
Mpu401Init:
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
        call Mpu401Reset
        popfw
        leave
        ret
Mpu401Close:
        pusha
        mov ebx, 0B0h
        mov ecx, 10h
loc_9FE46:
        db 051h                                 ; insn: push ecx
        db 053h                                 ; insn: push ebx
        call Mpu401WriteData
        push byte 7Bh
        call Mpu401WriteData
        push byte 0
        call Mpu401WriteData
        add esp, byte 0Ch
        pop ecx
        inc ebx
        loop loc_9FE46
        push dword 0FFh
        call Mpu401Command
        push byte 9
        call Mpu401Delay
        push dword 0FFh
        call Mpu401Command
        push byte 9
        call Mpu401Delay
        add esp, byte 10h
        mov eax, dword [dword_D5270]
        or eax, dword [dword_D5274]
        popa
        ret
Mpu401Reset:
        push dword 0FFh
        call Mpu401Command
        push byte 9
        call Mpu401Delay
        push byte 3Fh
        call Mpu401Command
        add esp, byte 0Ch
        ret
Mpu401Command:
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
Mpu401Delay:
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
Mpu401ReadData:
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
Mpu401WriteData:
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
Mpu401Midi:
        push ds
        call __GETDS
        push esi
        push edi
        mov edi, dword [byte esp+010h]
        mov esi, dword [byte esp+014h]
        jmp short loc_9FFC1
loc_9FFB2:
        xor eax, eax
        mov al, byte [esi]
        push eax
        call Mpu401WriteData
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
