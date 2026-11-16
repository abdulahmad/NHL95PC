; The MT-32 and MPU-401 driver.
bits 32
%include "hockey.inc"
section s_9FD94 progbits alloc exec nowrite align=1
extern __GETDS, Mpu401Irq, Mpu401IrqMask, Mpu401DataPort, Mpu401StatusPort, Mpu401RxCount, Mpu401RxMask, Mpu401OldIsr
extern Mpu401OldIsrSel
global Mpu401Detect, Mpu401Open, Mpu401Init, Mpu401Close, Mpu401Reset, Mpu401Command, Mpu401Delay, Mpu401ReadData
global Mpu401WriteData, Mpu401Midi
;-----------------------------------------------------------------------------
; Mpu401Detect                                 9FD94  95 PC, medium confidence
; MPU-401 driver detect entry: returns port 330h, IRQ 7
;-----------------------------------------------------------------------------
Mpu401Detect:
        mov eax, 70330h
        ret
;-----------------------------------------------------------------------------
; Mpu401Open                                   9FD9A  95 PC, medium confidence
; MPU-401 driver open entry: resets the port and enters UART mode
;-----------------------------------------------------------------------------
Mpu401Open:
        push ebp
        LD mov, ebp, esp
        movzx eax, word [byte ebp+08h]
        mov dword [Mpu401DataPort], eax
        inc eax
        mov dword [Mpu401StatusPort], eax
        movzx eax, word [byte ebp+0Ah]
        mov byte [Mpu401Irq], al
        LD mov, cl, al
        mov al, 1
        shl al, cl
        mov byte [Mpu401IrqMask], al
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
;-----------------------------------------------------------------------------
; Mpu401Init                                   9FDEA  95 PC, medium confidence
; MPU-401 driver init entry
;-----------------------------------------------------------------------------
Mpu401Init:
        push ebp
        LD mov, ebp, esp
        movzx eax, word [byte ebp+08h]
        mov dword [Mpu401DataPort], eax
        inc eax
        mov dword [Mpu401StatusPort], eax
        movzx eax, word [byte ebp+0Ah]
        mov byte [Mpu401Irq], al
        LD mov, cl, al
        mov al, 1
        shl al, cl
        mov byte [Mpu401IrqMask], al
        pushfw
        cli
        mov eax, 0
        mov dword [Mpu401RxCount], eax
        mov eax, 0FFh
        mov dword [Mpu401RxMask], eax
        mov eax, dword [Mpu401OldIsr]
        or eax, dword [Mpu401OldIsrSel]
        call Mpu401Reset
        popfw
        leave
        ret
;-----------------------------------------------------------------------------
; Mpu401Close                                  9FE3B  95 PC, medium confidence
; MPU-401 driver close entry: turns every channel's notes off and resets the
; port
;-----------------------------------------------------------------------------
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
        mov eax, dword [Mpu401OldIsr]
        or eax, dword [Mpu401OldIsrSel]
        popa
        ret
;-----------------------------------------------------------------------------
; Mpu401Reset                                  9FE94  95 PC, medium confidence
; Resets the MPU-401 and puts it back in UART mode
;-----------------------------------------------------------------------------
Mpu401Reset:
        push dword 0FFh
        call Mpu401Command
        push byte 9
        call Mpu401Delay
        push byte 3Fh
        call Mpu401Command
        add esp, byte 0Ch
        ret
;-----------------------------------------------------------------------------
; Mpu401Command                                9FEB0  95 PC, medium confidence
; Sends a command to the MPU-401 and waits for its acknowledge
;-----------------------------------------------------------------------------
Mpu401Command:
        push ebp
        LD mov, ebp, esp
        mov edx, dword [Mpu401StatusPort]
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
        mov edx, dword [Mpu401StatusPort]
        mov ecx, 0FFh
.4:
        in al, dx
        LD or, al, al
        jge short .5
        loop .4
        mov eax, 0FFFFFFFFh
        jmp short .6
.5:
        mov edx, dword [Mpu401DataPort]
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
;-----------------------------------------------------------------------------
; Mpu401Delay                                     9FF04  95 PC, low confidence
; Waits a number of PIT channel 2 cycles
;-----------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------
; Mpu401ReadData                               9FF55  95 PC, medium confidence
; Reads a byte from the MPU-401 data port
;-----------------------------------------------------------------------------
Mpu401ReadData:
        mov edx, dword [Mpu401StatusPort]
        mov ecx, 0FFh
.1:
        in al, dx
        LD or, al, al
        jge short .2
        loop .1
        mov eax, 0FFFFFFFFh
        jmp short .3
.2:
        mov edx, dword [Mpu401DataPort]
        LD xor, eax, eax
        in al, dx
.3:
        ret
;-----------------------------------------------------------------------------
; Mpu401WriteData                              9FF78  95 PC, medium confidence
; Writes a byte to the MPU-401 data port
;-----------------------------------------------------------------------------
Mpu401WriteData:
        push ebp
        LD mov, ebp, esp
        mov edx, dword [Mpu401StatusPort]
        mov ecx, 0FFh
.1:
        in al, dx
        test al, 40h
        je short .2
        loop .1
        mov eax, 0FFFFFFFFh
        jmp short .3
.2:
        mov edx, dword [Mpu401DataPort]
        mov eax, dword [byte ebp+08h]
        out dx, al
.3:
        leave
        ret
;-----------------------------------------------------------------------------
; Mpu401Midi                                   9FFA0  95 PC, medium confidence
; MPU-401 driver MIDI entry: sends a run of MIDI bytes
;-----------------------------------------------------------------------------
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
