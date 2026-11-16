; IRQ and DMA setup for the sound cards.
bits 32
%include "hockey.inc"
section s_A9C9C progbits alloc exec nowrite align=1
extern __GETDS, SbCardDmaPage, SbCardDmaAddr, SbCardDmaLength, SbCardDmaActive, SbCardPort, SbCardIrq, SbCardDma
extern SbCardRate, SbCardHighSpeed, SbCardPicMask, SbCardPicMask2, SbCardIrqHooked, SbCardOldIsr, SbCardOldIsrSel, SbDmaPagePorts
global SbHookIrq, SbUnhookIrq, SbIrqHandler, SbDspWrite, SbDspRead, SbCardClose, SbDspReset, SbDspVersion
global SbCardOpen, SbStopDma, SbDmaCount, SbSetStereo
;-----------------------------------------------------------------------------
; SbHookIrq                                    A9C9C  95 PC, medium confidence
; Installs the Sound Blaster interrupt handler and unmasks its IRQ
;-----------------------------------------------------------------------------
SbHookIrq:
        pushf
        cli
        push es
        mov byte [SbCardIrqHooked], al
        add al, 8
        cmp al, 0Fh
        jbe short .1
        add al, 60h
.1:
        mov ah, 35h
        int 21h
        o16 mov word [SbCardOldIsrSel], es
        mov dword [SbCardOldIsr], ebx
        pop es
        push ds
        mov ax, cs
        mov ds, ax
        mov al, byte [SbCardIrqHooked]
        add al, 8
        cmp al, 0Fh
        jbe short .2
        add al, 60h
.2:
        mov ah, 25h
        int 21h
        pop ds
        mov al, 20h
        out 20h, al
        jmp short .3
.3:
        jmp short .4
.4:
        out 0A0h, al
        jmp short .5
.5:
        jmp short .6
.6:
        mov cl, byte [SbCardIrqHooked]
        mov ah, 1
        cmp cl, 8
        jb short .11
        sub cl, 8
        shl ah, cl
        not ah
        in al, 21h
        jmp short .7
.7:
        jmp short .8
.8:
        LD and, al, ah
        out 21h, al
        jmp short .9
.9:
        jmp short .10
.10:
        popf
        ret
.11:
        shl ah, cl
        not ah
        in al, 21h
        jmp short .12
.12:
        jmp short .13
.13:
        LD and, al, ah
        out 21h, al
        jmp short .14
.14:
        jmp short .15
.15:
        popf
        ret
;-----------------------------------------------------------------------------
; SbUnhookIrq                                  A9D1D  95 PC, medium confidence
; Masks the Sound Blaster IRQ and restores the old handler
;-----------------------------------------------------------------------------
SbUnhookIrq:
        mov al, byte [SbCardIrqHooked]
        LD or, al, al
        je short .2
        pushf
        cli
        add al, 8
        cmp al, 0Fh
        jbe short .1
        add al, 60h
.1:
        push ds
        mov edx, dword [SbCardOldIsr]
        o16 mov ds, word [SbCardOldIsrSel]
        mov ah, 25h
        int 21h
        pop ds
        LD xor, al, al
        mov byte [SbCardIrqHooked], al
        popf
.2:
        ret
;-----------------------------------------------------------------------------
; SbIrqHandler                                 A9D4C  95 PC, medium confidence
; Sound Blaster interrupt handler: acknowledges the DSP, mixes the next half
; buffer and ends the interrupt
;-----------------------------------------------------------------------------
SbIrqHandler:
        pushf
        pusha
        push ds
        call __GETDS
        movzx edx, word [SbCardPort]
        add edx, byte 0Eh
        in al, dx
        jmp short .1
.1:
        jmp short .2
.2:
        cmp byte [SbCardHighSpeed], 1
        je short .20
        mov ah, 14h
        movzx edx, word [SbCardPort]
        add edx, byte 0Ch
        mov ecx, 3E8h
.3:
        in al, dx
        jmp short .4
.4:
        jmp short .5
.5:
        and al, 80h
        loopne .3
        stc
        jne short .8
        LD mov, al, ah
        out dx, al
        jmp short .6
.6:
        jmp short .7
.7:
        clc
.8:
        mov ah, 0FFh
        movzx edx, word [SbCardPort]
        add edx, byte 0Ch
        mov ecx, 3E8h
.9:
        in al, dx
        jmp short .10
.10:
        jmp short .11
.11:
        and al, 80h
        loopne .9
        stc
        jne short .14
        LD mov, al, ah
        out dx, al
        jmp short .12
.12:
        jmp short .13
.13:
        clc
.14:
        movzx edx, word [SbCardPort]
        add edx, byte 0Ch
        mov ecx, 3E8h
.15:
        in al, dx
        jmp short .16
.16:
        jmp short .17
.17:
        and al, 80h
        loopne .15
        stc
        jne short .20
        LD mov, al, ah
        out dx, al
        jmp short .18
.18:
        jmp short .19
.19:
        clc
.20:
        mov al, 20h
        out 0A0h, al
        jmp short .21
.21:
        jmp short .22
.22:
        out 20h, al
        jmp short .23
.23:
        jmp short .24
.24:
        pop ds
        popa
        popf
        iret
;-----------------------------------------------------------------------------
; SbDspWrite                                   A9DEB  95 PC, medium confidence
; Writes a byte to the DSP once it is ready
;-----------------------------------------------------------------------------
SbDspWrite:
        movzx edx, word [SbCardPort]
        add edx, byte 0Ch
        mov ecx, 3E8h
.1:
        in al, dx
        jmp short .2
.2:
        jmp short .3
.3:
        and al, 80h
        loopne .1
        stc
        jne short .6
        LD mov, al, ah
        out dx, al
        jmp short .4
.4:
        jmp short .5
.5:
        clc
.6:
        ret
;-----------------------------------------------------------------------------
; SbDspRead                                    A9E0F  95 PC, medium confidence
; Reads a byte from the DSP once one is waiting
;-----------------------------------------------------------------------------
SbDspRead:
        movzx edx, word [SbCardPort]
        add edx, byte 0Eh
        mov ecx, 3E8h
.1:
        in al, dx
        jmp short .2
.2:
        jmp short .3
.3:
        and al, 80h
        loope .1
        stc
        je short .6
        sub edx, byte 4
        in al, dx
        jmp short .4
.4:
        jmp short .5
.5:
        clc
.6:
        ret
;-----------------------------------------------------------------------------
; SbCardClose                                  A9E34  95 PC, medium confidence
; Stops the DMA, restores the PIC masks and resets the DSP
;-----------------------------------------------------------------------------
SbCardClose:
        call SbStopDma
        mov al, byte [SbCardPicMask]
        out 21h, al
        jmp short .1
.1:
        jmp short .2
.2:
        mov al, byte [SbCardPicMask2]
        out 0A1h, al
        jmp short .3
.3:
        jmp short .4
.4:
        call SbDspReset
        ret
;-----------------------------------------------------------------------------
; SbDspReset                                   A9E55  95 PC, medium confidence
; Resets the DSP and waits for its AAh answer
;-----------------------------------------------------------------------------
SbDspReset:
        movzx edx, word [SbCardPort]
        add edx, byte 0Eh
        in al, dx
        jmp short .1
.1:
        jmp short .2
.2:
        movzx edx, word [SbCardPort]
        add edx, byte 6
        mov al, 1
        out dx, al
        jmp short .3
.3:
        jmp short .4
.4:
        pushf
        push ecx
        mov ecx, 14h
.5:
        jmp short .6
.6:
        jmp short .7
.7:
        push eax
        pop eax
        loop .5
        pop ecx
        popf
        pushf
        push ecx
        mov ecx, 14h
.8:
        jmp short .9
.9:
        jmp short .10
.10:
        push eax
        pop eax
        loop .8
        pop ecx
        popf
        pushf
        push ecx
        mov ecx, 14h
.11:
        jmp short .12
.12:
        jmp short .13
.13:
        push eax
        pop eax
        loop .11
        pop ecx
        popf
        dec al
        out dx, al
        jmp short .14
.14:
        jmp short .15
.15:
        pushf
        push ecx
        mov ecx, 14h
.16:
        jmp short .17
.17:
        jmp short .18
.18:
        push eax
        pop eax
        loop .16
        pop ecx
        popf
        pushf
        push ecx
        mov ecx, 14h
.19:
        jmp short .20
.20:
        jmp short .21
.21:
        push eax
        pop eax
        loop .19
        pop ecx
        popf
        pushf
        push ecx
        mov ecx, 14h
.22:
        jmp short .23
.23:
        jmp short .24
.24:
        push eax
        pop eax
        loop .22
        pop ecx
        popf
        mov ecx, 3E8h
.25:
        push ecx
        movzx edx, word [SbCardPort]
        add edx, byte 0Eh
        mov ecx, 3E8h
.26:
        in al, dx
        jmp short .27
.27:
        jmp short .28
.28:
        and al, 80h
        loope .26
        stc
        je short .31
        sub edx, byte 4
        in al, dx
        jmp short .29
.29:
        jmp short .30
.30:
        clc
.31:
        pop ecx
        cmp al, 0AAh
        loopne .25
        stc
        jne short .32
        clc
.32:
        LD sbb, eax, eax
        rol eax, 1
        ret
;-----------------------------------------------------------------------------
; SbDspVersion                                 A9F1A  95 PC, medium confidence
; Asks the DSP for its version (command E1h)
;-----------------------------------------------------------------------------
SbDspVersion:
        push eax
        push ebx
        mov ah, 0E1h
        call SbDspWrite
        mov ecx, 4E20h
.1:
        pushf
        push ecx
        mov ecx, 14h
.2:
        jmp short .3
.3:
        jmp short .4
.4:
        push eax
        pop eax
        loop .2
        pop ecx
        popf
        loop .1
        LD xor, eax, eax
        call SbDspRead
        LD mov, ah, al
        call SbDspRead
        LD mov, ebx, eax
        cmp eax, 201h
        jb short .6
        cmp eax, 400h
        jb short .5
        mov eax, 5622h
        mov dword [SbCardRate], eax
        mov byte [SbCardHighSpeed], 0
        jmp short .7
.5:
        mov eax, 5622h
        mov dword [SbCardRate], eax
        mov byte [SbCardHighSpeed], 1
        jmp short .7
.6:
        mov eax, 2B11h
        mov dword [SbCardRate], eax
        mov byte [SbCardHighSpeed], 0
.7:
        pop ebx
        pop eax
        ret
;-----------------------------------------------------------------------------
; SbCardOpen                                      A9F93  95 PC, low confidence
; Stores the port, IRQ and DMA channel, saves the PIC masks, resets the DSP
; and starts output
;-----------------------------------------------------------------------------
SbCardOpen:
        push ebp
        LD mov, ebp, esp
        in al, 21h
        mov byte [SbCardPicMask], al
        in al, 0A1h
        mov byte [SbCardPicMask2], al
        LD xor, al, al
        mov byte [SbCardIrqHooked], al
        mov eax, dword [byte ebp+08h]
        mov word [SbCardPort], ax
        mov eax, dword [byte ebp+0Ch]
        mov byte [SbCardIrq], al
        mov eax, dword [byte ebp+010h]
        mov byte [SbCardDma], al
        call SbDspReset
        jae short .1
        leave
        ret
.1:
        call SbDspVersion
        mov ebx, dword [SbCardRate]
        LD or, ebx, ebx
        je short .2
        LD xor, edx, edx
        mov eax, 0F424000h
        div ebx
        neg eax
        LD mov, ebx, eax
        mov ah, 40h
        call SbDspWrite
        jb short .2
        LD mov, ah, bh
        call SbDspWrite
.2:
        LD sbb, eax, eax
        rol eax, 1
        jae short .3
        leave
        ret
.3:
        mov ah, 0D1h
        call SbDspWrite
        LD sbb, eax, eax
        rol eax, 1
        jae short .4
        leave
        ret
.4:
        mov eax, dword [byte ebp+018h]
        mov word [SbCardDmaLength], ax
        mov eax, dword [byte ebp+014h]
        mov word [SbCardDmaAddr], ax
        shr eax, 10h
        mov byte [SbCardDmaPage], al
        mov al, byte [SbCardDmaActive]
        LD or, al, al
        jne near .35
        mov al, 1
        mov byte [SbCardDmaActive], al
        mov al, byte [SbCardIrq]
        mov edx, SbIrqHandler
        call SbHookIrq
        cli
        LD xor, edx, edx
        mov al, byte [SbCardDma]
        or al, 4
        out 0Ah, al
        jmp short .5
.5:
        jmp short .6
.6:
        mov al, byte [SbCardDma]
        or al, 58h
        out 0Bh, al
        jmp short .7
.7:
        jmp short .8
.8:
        out 0Ch, al
        jmp short .9
.9:
        jmp short .10
.10:
        mov dl, byte [SbCardDma]
        shl dl, 1
        mov ax, word [SbCardDmaAddr]
        out dx, al
        jmp short .11
.11:
        jmp short .12
.12:
        LD mov, al, ah
        out dx, al
        jmp short .13
.13:
        jmp short .14
.14:
        LD xor, ebx, ebx
        mov bl, byte [SbCardDma]
        mov dl, byte [dword ebx+SbDmaPagePorts]
        mov al, byte [SbCardDmaPage]
        out dx, al
        jmp short .15
.15:
        jmp short .16
.16:
        mov dl, byte [SbCardDma]
        shl dl, 1
        inc dl
        mov ax, word [SbCardDmaLength]
        dec ax
        out 0Ch, al
        jmp short .17
.17:
        jmp short .18
.18:
        out dx, al
        jmp short .19
.19:
        jmp short .20
.20:
        LD mov, al, ah
        out dx, al
        jmp short .21
.21:
        jmp short .22
.22:
        mov al, byte [SbCardDma]
        out 0Ah, al
        jmp short .23
.23:
        jmp short .24
.24:
        cmp byte [SbCardHighSpeed], 1
        je short .29
        mov ah, 14h
        call SbDspWrite
        jb short .34
        mov ecx, 4E20h
.25:
        pushf
        push ecx
        mov ecx, 14h
.26:
        jmp short .27
.27:
        jmp short .28
.28:
        push eax
        pop eax
        loop .26
        pop ecx
        popf
        loop .25
        mov ah, 0FFh
        call SbDspWrite
        jb short .34
        call SbDspWrite
        jmp short .34
.29:
        mov ah, 48h
        call SbDspWrite
        jb short .34
        mov ecx, 4E20h
.30:
        pushf
        push ecx
        mov ecx, 14h
.31:
        jmp short .32
.32:
        jmp short .33
.33:
        push eax
        pop eax
        loop .31
        pop ecx
        popf
        loop .30
        mov ah, 0FFh
        call SbDspWrite
        jb short .34
        call SbDspWrite
        mov ah, 90h
        call SbDspWrite
.34:
        LD sbb, eax, eax
        rol eax, 1
        sti
        leave
        ret
.35:
        LD xor, eax, eax
        clc
        leave
        ret
;-----------------------------------------------------------------------------
; SbStopDma                                    AA14D  95 PC, medium confidence
; Masks the Sound Blaster DMA channel
;-----------------------------------------------------------------------------
SbStopDma:
        cmp byte [SbCardDmaActive], 0
        clc
        je short .6
        cli
        mov al, byte [SbCardDma]
        or al, 4
        out 0Ah, al
        jmp short .1
.1:
        jmp short .2
.2:
        movzx edx, word [SbCardPort]
        add edx, byte 0Eh
        in al, dx
        jmp short .3
.3:
        jmp short .4
.4:
        LD xor, al, al
        mov byte [SbCardDmaActive], al
        mov al, byte [SbCardIrqHooked]
        LD or, al, al
        je short .6
        call SbUnhookIrq
        mov cl, byte [SbCardIrq]
        cmp cl, 0FFh
        je short .6
        mov ah, 1
        cmp cl, 8
        jb short .5
        sub cl, 8
        shl ah, cl
        in al, 0A1h
        LD or, al, ah
        out 0A1h, al
        jmp short .6
.5:
        shl ah, cl
        in al, 21h
        LD or, al, ah
        out 21h, al
.6:
        sti
        ret
;-----------------------------------------------------------------------------
; SbDmaCount                                   AA1B2  95 PC, medium confidence
; Reads the DMA channel's remaining count
;-----------------------------------------------------------------------------
SbDmaCount:
        LD xor, eax, eax
        movzx edx, byte [SbCardDma]
        shl edx, 1
        inc edx
        in al, dx
        jmp short .1
.1:
        jmp short .2
.2:
        LD mov, ah, al
        in al, dx
        jmp short .3
.3:
        jmp short .4
.4:
        db 086h,0C4h                            ; insn: xchg al,ah
        LD mov, ebx, eax
        movzx eax, word [SbCardDmaLength]
        dec eax
        LD sub, eax, ebx
        ret
;-----------------------------------------------------------------------------
; SbSetStereo                                     AA1D9  95 PC, low confidence
; Sets mixer register 0Eh: stereo output and the output filter
;-----------------------------------------------------------------------------
SbSetStereo:
        push ebp
        LD mov, ebp, esp
        movzx edx, word [SbCardPort]
        add edx, byte 4
        mov al, 0Eh
        out dx, al
        jmp short .1
.1:
        jmp short .2
.2:
        inc edx
        LD xor, eax, eax
        mov ebx, dword [byte ebp+08h]
        LD or, ebx, ebx
        jne short .3
        mov al, 20h
.3:
        out dx, al
        jmp short .4
.4:
        jmp short .5
.5:
        leave
        ret
