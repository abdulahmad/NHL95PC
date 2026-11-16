; Hardware access for the PC speaker and the OPL chip.
bits 32
%include "hockey.inc"
section s_A65E8 progbits alloc exec nowrite align=1
extern PcSpkState, PcSpkVoiceLevel
extern PcSpkOutLevel
extern OplOperatorOffsets, OplRegDelay, OplDataDelay, OplDefaultVoice, OplRegShadow
extern PcSpkVoiceTable
extern OplPort, OplFNumTable, OplVolumeTable, OplVelocityTable
global PcSpkHwInit, PcSpkHwClose, PcSpkSilence, PcSpkVoiceNote, PcSpkVoiceOff, PcSpkVoiceUpdate, PcSpkOutput, OplWrite
global OplReset, OplFlush, OplSetReg, OplGetReg, OplLoadVoice, OplHwInit, OplHwClose, OplDetect
global OplOpen, OplProbe, OplCalibrate, OplNoteFNum, OplVolumeLevel, OplVelocityLevel
PcSpkHwInit:
        mov al, 0B6h
        out 43h, al
        call PcSpkSilence
        mov al, 7Fh
        mov byte [PcSpkState+015h], al
        mov byte [PcSpkState+016h], al
        mov byte [PcSpkState+017h], al
        mov byte [PcSpkState+018h], al
        mov byte [PcSpkState+019h], al
        mov eax, 5
        ret
PcSpkHwClose:
        call PcSpkSilence
        ret
PcSpkSilence:
        in al, 61h
        and al, 0FCh
        out 61h, al
        LD xor, al, al
        mov byte [PcSpkState+05h], al
        mov byte [PcSpkState+06h], al
        mov byte [PcSpkState+07h], al
        mov byte [PcSpkState+08h], al
        ret
PcSpkVoiceNote:
        push ebp
        LD mov, ebp, esp
        cmp dword [byte ebp+08h], byte 0
        je short .2
        push esi
        LD xor, eax, eax
        mov al, byte [byte ebp+010h]
        mov ebx, dword [byte ebp+0Ch]
        mov byte [byte ebx+03h], al
        cmp al, 0FFh
        je short .1
        shl eax, 1
        LD mov, esi, eax
        mov ax, word [dword esi+PcSpkVoiceTable]
        mov ebx, dword [byte ebp+0Ch]
        mov word [byte ebx+04h], ax
        mov word [byte ebx+06h], ax
.1:
        mov esi, dword [byte ebp+08h]
        mov al, 0FFh
        mov byte [dword esi+PcSpkVoiceLevel], al
        pop esi
.2:
        leave
        ret
PcSpkVoiceOff:
        db 055h                                 ; insn: push ebp
        LD mov, ebp, esp
        push esi
        mov esi, dword [byte ebp+08h]
        LD xor, al, al
        mov byte [dword esi+PcSpkVoiceLevel], al
        pop esi
        leave
        ret
PcSpkVoiceUpdate:
        push ebp
        LD mov, ebp, esp
        mov ebx, dword [byte ebp+0Ch]
        cmp byte [byte ebx+01h], 0
        jne short .1
        leave
        ret
.1:
        push esi
        push ecx
        mov ebx, dword [byte ebp+014h]
        cmp byte [byte ebx+035h], 1
        jne short .2
        mov ebx, dword [byte ebp+0Ch]
        LD xor, eax, eax
        mov al, byte [byte ebx+022h]
        add al, byte [byte ebx+03h]
        mov byte [PcSpkState], al
        shl eax, 1
        LD mov, esi, eax
        movzx ecx, word [dword esi+PcSpkVoiceTable]
        jmp short .3
.2:
        mov ebx, dword [byte ebp+0Ch]
        movzx ecx, word [byte ebx+04h]
        mov al, byte [byte ebx+03h]
        mov byte [PcSpkState], al
.3:
        mov ebx, dword [byte ebp+014h]
        movsx eax, byte [byte ebx+011h]
        neg eax
        LD add, ecx, eax
        mov ebx, dword [byte ebp+010h]
        cmp word [byte ebx+026h], byte 0
        jne short .4
        jmp short .6
.4:
        jl short .5
        LD xor, eax, eax
        mov al, byte [PcSpkState]
        mov ebx, dword [byte ebp+014h]
        add al, byte [byte ebx+012h]
        shl eax, 1
        LD mov, esi, eax
        movzx eax, word [nosplit esi*1+PcSpkVoiceTable]
        neg eax
        LD add, eax, ecx
        mov ebx, dword [byte ebp+010h]
        movzx edx, word [byte ebx+026h]
        mul edx
        push ebx
        mov ebx, 1F80h
        div ebx
        pop ebx
        LD sub, ecx, eax
        jmp short .6
.5:
        LD xor, eax, eax
        mov al, byte [PcSpkState]
        mov ebx, dword [byte ebp+014h]
        sub al, byte [byte ebx+012h]
        shl eax, 1
        LD mov, esi, eax
        movzx eax, word [dword esi+PcSpkVoiceTable]
        LD sub, eax, ecx
        mov ebx, dword [byte ebp+010h]
        movzx edx, word [byte ebx+026h]
        neg edx
        mul edx
        push ebx
        mov ebx, 1F80h
        div ebx
        pop ebx
        LD add, ecx, eax
.6:
        mov ebx, dword [byte ebp+014h]
        cmp byte [byte ebx+028h], 2
        jne short .7
        mov ebx, dword [byte ebp+0Ch]
        add ecx, dword [byte ebx+01Ch]
.7:
        mov ebx, dword [byte ebp+014h]
        cmp byte [byte ebx+019h], 2
        jne short .8
        mov ebx, dword [byte ebp+0Ch]
        add ecx, dword [byte ebx+014h]
.8:
        mov eax, dword [byte ebp+08h]
        shl eax, 1
        LD mov, esi, eax
        mov word [dword esi+PcSpkState+0Bh], cx
        mov ebx, dword [byte ebp+0Ch]
        mov dword [byte ebx+06h], ecx
        pop ecx
        pop esi
        leave
        ret
PcSpkOutput:
        mov al, byte [PcSpkVoiceLevel]
        mov byte [PcSpkOutLevel], al
        push esi
        mov ecx, 4
        LD mov, esi, ecx
.1:
        cmp byte [dword esi+PcSpkState+015h], 0
        je short .2
        mov al, byte [nosplit esi*1+PcSpkVoiceLevel]
        mov byte [nosplit esi*1+PcSpkOutLevel], al
        jmp short .3
.2:
        LD xor, al, al
        mov byte [nosplit esi*1+PcSpkOutLevel], al
.3:
        dec esi
        loop .1
        pop esi
        mov al, byte [PcSpkOutLevel]
        cmp al, 0
        jne near .10
        mov bl, byte [PcSpkState+01Fh]
        mov cl, byte [PcSpkState+020h]
        LD xor, al, al
        LD or, al, bl
        LD or, al, cl
        je short .6
        mov al, byte [PcSpkState+02Ah]
        and al, 2
        je short .4
        mov bl, byte [PcSpkState+01Dh]
        mov cl, byte [PcSpkState+01Eh]
        LD xor, al, al
        LD or, al, bl
        LD or, al, cl
        jne short .6
        mov bl, byte [PcSpkState+01Fh]
        mov cl, byte [PcSpkState+020h]
.4:
        cmp bl, 0
        je short .5
        mov ax, word [PcSpkState+011h]
        jmp short .8
.5:
        mov ax, word [PcSpkState+013h]
        jmp short .8
.6:
        mov bl, byte [PcSpkState+01Dh]
        cmp bl, 0
        jne short .7
        mov cl, byte [PcSpkState+01Eh]
        cmp cl, 0
        je short .9
        mov ax, word [PcSpkState+0Fh]
        jmp short .8
.7:
        mov ax, word [PcSpkState+0Dh]
.8:
        out 42h, al
        LD mov, al, ah
        out 42h, al
        in al, 61h
        or al, 3
        out 61h, al
        jmp short .10
.9:
        in al, 61h
        and al, 0FEh
        out 61h, al
.10:
        mov al, byte [PcSpkState+02Ah]
        inc al
        mov byte [PcSpkState+02Ah], al
        ret
        db 00h
OplWrite:
        out dx, al
        push eax
        push ecx
        mov ecx, dword [OplRegDelay]
.1:
        in al, dx
        loop .1
        pop ecx
        pop eax
        inc dx
        db 086h,0C4h                            ; insn: xchg al,ah
        out dx, al
        db 086h,0C4h                            ; insn: xchg al,ah
        dec dx
        push eax
        push ecx
        mov ecx, dword [OplDataDelay]
.2:
        in al, dx
        loop .2
        pop ecx
        pop eax
        ret
OplReset:
        LD xor, eax, eax
        mov al, 1
        mov dx, word [OplPort]
.1:
        call OplWrite
        inc al
        cmp al, 0F6h
        jne short .1
        mov al, 1
        mov ah, 20h
        call OplWrite
        push esi
        LD xor, eax, eax
        mov ebx, OplRegShadow
        mov esi, OplRegShadow+0103h
.2:
        mov byte [ebx], ah
        mov byte [esi], ah
        inc ebx
        inc esi
        inc al
        jne short .2
        pop esi
        mov al, 80h
        mov ah, 0Eh
.3:
        call OplSetReg
        inc al
        cmp al, 95h
        jle short .3
        call OplFlush
        ret
OplFlush:
        mov dx, word [OplPort]
        push esi
        mov al, 20h
        mov ebx, OplRegShadow+020h
        mov esi, OplRegShadow+0123h
.1:
        mov ah, byte [ebx]
        mov cl, byte [esi]
        LD cmp, ah, cl
        je short .2
        call OplWrite
.2:
        mov byte [esi], ah
        inc ebx
        inc esi
        inc al
        cmp al, 96h
        jne short .1
        mov al, 0BDh
        mov ebx, OplRegShadow+0BDh
        mov esi, OplRegShadow+01C0h
.3:
        mov ah, byte [ebx]
        mov cl, byte [esi]
        LD cmp, ah, cl
        je short .4
        call OplWrite
.4:
        mov byte [esi], ah
        inc ebx
        inc esi
        inc al
        cmp al, 0F6h
        jne short .3
        mov al, 0A0h
        mov ebx, OplRegShadow+0A0h
        mov esi, OplRegShadow+01A3h
.5:
        mov ah, byte [ebx]
        mov cl, byte [esi]
        LD cmp, ah, cl
        jne short .6
        mov ah, byte [byte ebx+010h]
        mov cl, byte [byte esi+010h]
        LD cmp, ah, cl
        je short .7
.6:
        add al, 10h
        mov ah, byte [byte ebx+010h]
        call OplWrite
        mov byte [byte esi+010h], ah
        sub al, 10h
        mov ah, byte [ebx]
        call OplWrite
        mov byte [esi], ah
.7:
        inc ebx
        inc esi
        inc al
        cmp al, 0A9h
        jne short .5
        pop esi
        ret
OplSetReg:
        mov dx, word [OplPort]
        cmp al, 20h
        jb short .1
        cmp al, 0F5h
        ja short .1
        push eax
        push ebx
        push ecx
        LD mov, ecx, eax
        LD xor, eax, eax
        LD mov, al, cl
        mov ebx, OplRegShadow
        LD add, ebx, eax
        mov byte [ebx], ch
        pop ecx
        pop ebx
        pop eax
        jmp short .2
.1:
        call OplWrite
.2:
        ret
OplGetReg:
        push ecx
        cmp al, 20h
        jb short .1
        cmp al, 0F5h
        ja short .1
        LD mov, ecx, eax
        LD xor, eax, eax
        LD mov, al, cl
        mov ebx, OplRegShadow
        LD add, ebx, eax
        mov al, byte [ebx]
.1:
        pop ecx
        ret
OplLoadVoice:
        push ebp
        LD mov, ebp, esp
        push si
        cld
        movzx ebx, word [byte ebp+08h]
        cmp ebx, byte 9
        jl short .1
        pop si
        leave
        ret
.1:
        mov cl, byte [dword ebx+OplOperatorOffsets]
        mov esi, OplDefaultVoice
        mov ebx, dword [byte ebp+0Ch]
        mov ch, 0Ah
.2:
        mov ah, byte [ebx]
        inc ebx
        lodsb
        LD add, al, cl
        call OplSetReg
        dec ch
        jne short .2
        movzx ecx, word [byte ebp+08h]
        mov ch, 3
.3:
        mov ah, byte [ebx]
        inc ebx
        lodsb
        LD add, al, cl
        call OplSetReg
        dec ch
        jne short .3
        pop si
        leave
        ret
OplHwInit:
        push ebp
        LD mov, ebp, esp
        mov eax, dword [byte ebp+08h]
        mov word [OplPort], ax
        call OplReset
        leave
        ret
OplHwClose:
        call OplReset
        ret
OplDetect:
        mov eax, 388h
        LD xor, edx, edx
        ret
OplOpen:
        push ebp
        LD mov, ebp, esp
        mov eax, dword [byte ebp+08h]
        mov word [OplPort], ax
        mov eax, 20h
        mov dword [OplRegDelay], eax
        mov eax, 8Ch
        mov dword [OplDataDelay], eax
        call OplProbe
        mov eax, 0
        jb short .1
        call OplCalibrate
        mov eax, 1
        clc
.1:
        leave
        ret
OplProbe:
        push ax
        push cx
        push dx
        mov dx, word [OplPort]
        mov eax, 1
        call OplWrite
        mov eax, 6004h
        call OplWrite
        mov eax, 8004h
        call OplWrite
        in al, dx
        LD mov, ebx, eax
        mov eax, 0FF02h
        call OplWrite
        mov eax, 2104h
        call OplWrite
        mov ecx, 0C350h
.1:
        in al, dx
        and al, 0E0h
        cmp al, 0C0h
        je short .2
        loop .1
.2:
        LD mov, ecx, eax
        mov eax, 6004h
        call OplWrite
        mov eax, 8004h
        call OplWrite
        and bl, 0E0h
        cmp bl, 0
        stc
        jne short .3
        and cl, 0E0h
        cmp cl, 0C0h
        stc
        jne short .3
        clc
.3:
        pop dx
        pop cx
        pop ax
        ret
OplCalibrate:
        push ax
        push cx
        push dx
        in al, 61h
        and al, 0FEh
        out 61h, al
        mov al, 0B0h
        out 43h, al
        LD xor, al, al
        out 42h, al
        out 42h, al
        in al, 61h
        or al, 1
        out 61h, al
        mov ecx, 3E8h
        mov dx, word [OplPort]
        LD xor, eax, eax
.1:
        in al, dx
        loop .1
        in al, 61h
        and al, 0FEh
        out 61h, al
        in al, 42h
        db 086h,0C4h                            ; insn: xchg al,ah
        in al, 42h
        db 086h,0C4h                            ; insn: xchg al,ah
        neg eax
        LD mov, ecx, eax
        LD xor, edx, edx
        mov eax, 0EA60h
        div ecx
        cmp eax, byte 0
        jne short .2
        mov eax, 1
.2:
        shl eax, 1
        LD xor, edx, edx
        mov eax, 7530h
        div ecx
        cmp eax, byte 0
        jne short .3
        mov eax, 1
.3:
        shl eax, 1
        pop dx
        pop cx
        pop ax
        ret
OplNoteFNum:
        push ebp
        LD mov, ebp, esp
        LD xor, eax, eax
        LD xor, edx, edx
        mov al, byte [byte ebp+08h]
        mov dh, byte [byte ebp+0Ch]
        mov cl, 0Ch
        div cl
        LD mov, dl, al
        LD mov, al, ah
        LD add, al, dh
        cbw
        cwde
        movzx eax, word [nosplit eax*2+OplFNumTable]
        LD xor, dh, dh
        shl edx, 0Ah
        LD or, eax, edx
        leave
        ret
OplVolumeLevel:
        push ebp
        LD mov, ebp, esp
        LD xor, ebx, ebx
        mov bl, byte [byte ebp+08h]
        and ebx, byte 7Ch
        shr ebx, 1
        movzx eax, word [dword ebx+OplVolumeTable]
        leave
        ret
OplVelocityLevel:
        push ebp
        LD mov, ebp, esp
        LD xor, ebx, ebx
        mov bl, byte [byte ebp+08h]
        and ebx, byte 7Eh
        movzx eax, word [dword ebx+OplVelocityTable]
        leave
        ret
