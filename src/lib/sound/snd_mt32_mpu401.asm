; The MT-32 and MPU-401 driver.
bits 32
%include "hockey.inc"
section s_9FD94 progbits alloc exec nowrite align=1
extern __GETDS, byte_D5279, byte_D527A, dword_D5260, dword_D5264, dword_D5268, dword_D526C, dword_D5270
extern dword_D5274
global Mpu401Detect, Mpu401Open, Mpu401Init, Mpu401Close, Mpu401Reset, Mpu401Command, Mpu401Delay, Mpu401ReadData
global Mpu401WriteData, Mpu401Midi
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
.1:
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
        loop .1
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
.1:
        in al, dx
        test al, 40h
        je short .2
        loop .1
        mov eax, 0FFFFFFFFh
        jmp short .7
.2:
        pushfw
        cli
        mov eax, dword [byte ebp+08h]
        out dx, al
.3:
        mov edx, dword [dword_D5264]
        mov ecx, 0FFh
.4:
        in al, dx
        LD or, al, al
        jge short .5
        loop .4
        mov eax, 0FFFFFFFFh
        jmp short .6
.5:
        mov edx, dword [dword_D5260]
        in al, dx
        cmp al, 0FEh
        mov eax, 0
        je short .6
        int 0Ah
        jmp short .3
.6:
        popfw
.7:
        leave
        ret
Mpu401Delay:
        push ebp
        LD mov, ebp, esp
        mov ecx, dword [byte ebp+08h]
        pushfw
        cli
        in al, 61h
        jmp short .1
.1:
        and al, 0FEh
        out 61h, al
        jmp short .2
.2:
        mov al, 0B6h
        out 43h, al
        jmp short .3
.3:
        LD xor, al, al
        out 42h, al
        jmp short .4
.4:
        out 42h, al
        jmp short .5
.5:
        in al, 61h
        jmp short .6
.6:
        or al, 1
        out 61h, al
        jmp short .7
.7:
        in al, 42h
        jmp short .8
.8:
        in al, 42h
        LD or, al, al
        js short .7
.9:
        in al, 42h
        jmp short .10
.10:
        in al, 42h
        LD or, al, al
        jns short .9
        loop .7
        in al, 61h
        jmp short .11
.11:
        and al, 0FEh
        out 61h, al
        jmp short .12
.12:
        popfw
        leave
        ret
Mpu401ReadData:
        mov edx, dword [dword_D5264]
        mov ecx, 0FFh
.1:
        in al, dx
        LD or, al, al
        jge short .2
        loop .1
        mov eax, 0FFFFFFFFh
        jmp short .3
.2:
        mov edx, dword [dword_D5260]
        LD xor, eax, eax
        in al, dx
.3:
        ret
Mpu401WriteData:
        push ebp
        LD mov, ebp, esp
        mov edx, dword [dword_D5264]
        mov ecx, 0FFh
.1:
        in al, dx
        test al, 40h
        je short .2
        loop .1
        mov eax, 0FFFFFFFFh
        jmp short .3
.2:
        mov edx, dword [dword_D5260]
        mov eax, dword [byte ebp+08h]
        out dx, al
.3:
        leave
        ret
Mpu401Midi:
        push ds
        call __GETDS
        push esi
        push edi
        mov edi, dword [byte esp+010h]
        mov esi, dword [byte esp+014h]
        jmp short .2
.1:
        xor eax, eax
        mov al, byte [esi]
        push eax
        call Mpu401WriteData
        add esp, byte 4
        dec edi
        inc esi
.2:
        test di, di
        ja short .1
        pop edi
        pop esi
        pop ds
        ret
