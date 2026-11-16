; Hardware access for the PC speaker and the OPL chip.
bits 32
%include "hockey.inc"
section s_A65E8 progbits alloc exec nowrite align=1
extern byte_D6770, byte_D6774, byte_D6775, byte_D6776, byte_D6777, byte_D6778, byte_D6785, byte_D6786
extern byte_D6787, byte_D6788, byte_D6789, byte_D678C, byte_D678D, byte_D678E, byte_D678F, byte_D6790
extern byte_D679A, byte_D67A8, dword_D67A0, dword_D67A4, unk_D67B4, unk_D68FC, unk_D691C, unk_D699C
extern unk_D69B9, unk_D69FF, unk_D6A1F, unk_D6A9F, unk_D6ABC, word_D6608, word_D677B, word_D677D
extern word_D677F, word_D6781, word_D6783, word_D679C, word_D67F4, word_D683C, word_D687C
global PcSpkHwInit, PcSpkHwClose, PcSpkSilence, PcSpkVoiceNote, loc_A6664, loc_A6670, PcSpkVoiceOff, PcSpkVoiceUpdate
global loc_A6692, loc_A66BA, loc_A66C9, loc_A66E0, loc_A6715, loc_A6745, loc_A6754, loc_A6763
global PcSpkOutput, loc_A678D, loc_A67A6, loc_A67AF, loc_A67FD, loc_A680A, loc_A6812, loc_A6830
global loc_A6836, loc_A6844, loc_A684A, OplWrite, loc_A6861, loc_A6877, OplReset, loc_A6888
global loc_A68A9, loc_A68B8, OplFlush, loc_A68DD, loc_A68EA, loc_A6900, loc_A690D, loc_A6923
global loc_A6935, loc_A694D, OplSetReg, loc_A697D, loc_A6982, OplGetReg, loc_A699B, OplLoadVoice
global loc_A69B0, loc_A69C0, loc_A69D5, OplHwInit, OplHwClose, OplDetect, OplOpen, loc_A6A40
global OplProbe, loc_A6A89, loc_A6A92, loc_A6ABB, OplCalibrate, loc_A6AEC, loc_A6B14, loc_A6B29
global OplNoteFNum, OplVolumeLevel, OplVelocityLevel
PcSpkHwInit:
        mov al, 0B6h
        out 43h, al
        call PcSpkSilence
        mov al, 7Fh
        mov byte [byte_D6785], al
        mov byte [byte_D6786], al
        mov byte [byte_D6787], al
        mov byte [byte_D6788], al
        mov byte [byte_D6789], al
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
        mov byte [byte_D6775], al
        mov byte [byte_D6776], al
        mov byte [byte_D6777], al
        mov byte [byte_D6778], al
        ret
PcSpkVoiceNote:
        push ebp
        LD mov, ebp, esp
        cmp dword [byte ebp+08h], byte 0
        je short loc_A6670
        push esi
        LD xor, eax, eax
        mov al, byte [byte ebp+010h]
        mov ebx, dword [byte ebp+0Ch]
        mov byte [byte ebx+03h], al
        cmp al, 0FFh
        je short loc_A6664
        shl eax, 1
        LD mov, esi, eax
        mov ax, word [dword esi+word_D6608]
        mov ebx, dword [byte ebp+0Ch]
        mov word [byte ebx+04h], ax
        mov word [byte ebx+06h], ax
loc_A6664:
        mov esi, dword [byte ebp+08h]
        mov al, 0FFh
        mov byte [dword esi+byte_D6774], al
        pop esi
loc_A6670:
        leave
        ret
PcSpkVoiceOff:
        db 055h                                 ; insn: push ebp
        LD mov, ebp, esp
        push esi
        mov esi, dword [byte ebp+08h]
        LD xor, al, al
        mov byte [dword esi+byte_D6774], al
        pop esi
        leave
        ret
PcSpkVoiceUpdate:
        push ebp
        LD mov, ebp, esp
        mov ebx, dword [byte ebp+0Ch]
        cmp byte [byte ebx+01h], 0
        jne short loc_A6692
        leave
        ret
loc_A6692:
        push esi
        push ecx
        mov ebx, dword [byte ebp+014h]
        cmp byte [byte ebx+035h], 1
        jne short loc_A66BA
        mov ebx, dword [byte ebp+0Ch]
        LD xor, eax, eax
        mov al, byte [byte ebx+022h]
        add al, byte [byte ebx+03h]
        mov byte [byte_D6770], al
        shl eax, 1
        LD mov, esi, eax
        movzx ecx, word [dword esi+word_D6608]
        jmp short loc_A66C9
loc_A66BA:
        mov ebx, dword [byte ebp+0Ch]
        movzx ecx, word [byte ebx+04h]
        mov al, byte [byte ebx+03h]
        mov byte [byte_D6770], al
loc_A66C9:
        mov ebx, dword [byte ebp+014h]
        movsx eax, byte [byte ebx+011h]
        neg eax
        LD add, ecx, eax
        mov ebx, dword [byte ebp+010h]
        cmp word [byte ebx+026h], byte 0
        jne short loc_A66E0
        jmp short loc_A6745
loc_A66E0:
        jl short loc_A6715
        LD xor, eax, eax
        mov al, byte [byte_D6770]
        mov ebx, dword [byte ebp+014h]
        add al, byte [byte ebx+012h]
        shl eax, 1
        LD mov, esi, eax
        movzx eax, word [nosplit esi*1+word_D6608]
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
        jmp short loc_A6745
loc_A6715:
        LD xor, eax, eax
        mov al, byte [byte_D6770]
        mov ebx, dword [byte ebp+014h]
        sub al, byte [byte ebx+012h]
        shl eax, 1
        LD mov, esi, eax
        movzx eax, word [dword esi+word_D6608]
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
loc_A6745:
        mov ebx, dword [byte ebp+014h]
        cmp byte [byte ebx+028h], 2
        jne short loc_A6754
        mov ebx, dword [byte ebp+0Ch]
        add ecx, dword [byte ebx+01Ch]
loc_A6754:
        mov ebx, dword [byte ebp+014h]
        cmp byte [byte ebx+019h], 2
        jne short loc_A6763
        mov ebx, dword [byte ebp+0Ch]
        add ecx, dword [byte ebx+014h]
loc_A6763:
        mov eax, dword [byte ebp+08h]
        shl eax, 1
        LD mov, esi, eax
        mov word [dword esi+word_D677B], cx
        mov ebx, dword [byte ebp+0Ch]
        mov dword [byte ebx+06h], ecx
        pop ecx
        pop esi
        leave
        ret
PcSpkOutput:
        mov al, byte [byte_D6774]
        mov byte [byte_D678C], al
        push esi
        mov ecx, 4
        LD mov, esi, ecx
loc_A678D:
        cmp byte [dword esi+byte_D6785], 0
        je short loc_A67A6
        mov al, byte [nosplit esi*1+byte_D6774]
        mov byte [nosplit esi*1+byte_D678C], al
        jmp short loc_A67AF
loc_A67A6:
        LD xor, al, al
        mov byte [nosplit esi*1+byte_D678C], al
loc_A67AF:
        dec esi
        loop loc_A678D
        pop esi
        mov al, byte [byte_D678C]
        cmp al, 0
        jne near loc_A684A
        mov bl, byte [byte_D678F]
        mov cl, byte [byte_D6790]
        LD xor, al, al
        LD or, al, bl
        LD or, al, cl
        je short loc_A6812
        mov al, byte [byte_D679A]
        and al, 2
        je short loc_A67FD
        mov bl, byte [byte_D678D]
        mov cl, byte [byte_D678E]
        LD xor, al, al
        LD or, al, bl
        LD or, al, cl
        jne short loc_A6812
        mov bl, byte [byte_D678F]
        mov cl, byte [byte_D6790]
loc_A67FD:
        cmp bl, 0
        je short loc_A680A
        mov ax, word [word_D6781]
        jmp short loc_A6836
loc_A680A:
        mov ax, word [word_D6783]
        jmp short loc_A6836
loc_A6812:
        mov bl, byte [byte_D678D]
        cmp bl, 0
        jne short loc_A6830
        mov cl, byte [byte_D678E]
        cmp cl, 0
        je short loc_A6844
        mov ax, word [word_D677F]
        jmp short loc_A6836
loc_A6830:
        mov ax, word [word_D677D]
loc_A6836:
        out 42h, al
        LD mov, al, ah
        out 42h, al
        in al, 61h
        or al, 3
        out 61h, al
        jmp short loc_A684A
loc_A6844:
        in al, 61h
        and al, 0FEh
        out 61h, al
loc_A684A:
        mov al, byte [byte_D679A]
        inc al
        mov byte [byte_D679A], al
        ret
        db 00h
OplWrite:
        out dx, al
        push eax
        push ecx
        mov ecx, dword [dword_D67A0]
loc_A6861:
        in al, dx
        loop loc_A6861
        pop ecx
        pop eax
        inc dx
        db 086h,0C4h                            ; insn: xchg al,ah
        out dx, al
        db 086h,0C4h                            ; insn: xchg al,ah
        dec dx
        push eax
        push ecx
        mov ecx, dword [dword_D67A4]
loc_A6877:
        in al, dx
        loop loc_A6877
        pop ecx
        pop eax
        ret
OplReset:
        LD xor, eax, eax
        mov al, 1
        mov dx, word [word_D679C]
loc_A6888:
        call OplWrite
        inc al
        cmp al, 0F6h
        jne short loc_A6888
        mov al, 1
        mov ah, 20h
        call OplWrite
        push esi
        LD xor, eax, eax
        mov ebx, unk_D68FC
        mov esi, unk_D69FF
loc_A68A9:
        mov byte [ebx], ah
        mov byte [esi], ah
        inc ebx
        inc esi
        inc al
        jne short loc_A68A9
        pop esi
        mov al, 80h
        mov ah, 0Eh
loc_A68B8:
        call OplSetReg
        inc al
        cmp al, 95h
        jle short loc_A68B8
        call OplFlush
        ret
OplFlush:
        mov dx, word [word_D679C]
        push esi
        mov al, 20h
        mov ebx, unk_D691C
        mov esi, unk_D6A1F
loc_A68DD:
        mov ah, byte [ebx]
        mov cl, byte [esi]
        LD cmp, ah, cl
        je short loc_A68EA
        call OplWrite
loc_A68EA:
        mov byte [esi], ah
        inc ebx
        inc esi
        inc al
        cmp al, 96h
        jne short loc_A68DD
        mov al, 0BDh
        mov ebx, unk_D69B9
        mov esi, unk_D6ABC
loc_A6900:
        mov ah, byte [ebx]
        mov cl, byte [esi]
        LD cmp, ah, cl
        je short loc_A690D
        call OplWrite
loc_A690D:
        mov byte [esi], ah
        inc ebx
        inc esi
        inc al
        cmp al, 0F6h
        jne short loc_A6900
        mov al, 0A0h
        mov ebx, unk_D699C
        mov esi, unk_D6A9F
loc_A6923:
        mov ah, byte [ebx]
        mov cl, byte [esi]
        LD cmp, ah, cl
        jne short loc_A6935
        mov ah, byte [byte ebx+010h]
        mov cl, byte [byte esi+010h]
        LD cmp, ah, cl
        je short loc_A694D
loc_A6935:
        add al, 10h
        mov ah, byte [byte ebx+010h]
        call OplWrite
        mov byte [byte esi+010h], ah
        sub al, 10h
        mov ah, byte [ebx]
        call OplWrite
        mov byte [esi], ah
loc_A694D:
        inc ebx
        inc esi
        inc al
        cmp al, 0A9h
        jne short loc_A6923
        pop esi
        ret
OplSetReg:
        mov dx, word [word_D679C]
        cmp al, 20h
        jb short loc_A697D
        cmp al, 0F5h
        ja short loc_A697D
        push eax
        push ebx
        push ecx
        LD mov, ecx, eax
        LD xor, eax, eax
        LD mov, al, cl
        mov ebx, unk_D68FC
        LD add, ebx, eax
        mov byte [ebx], ch
        pop ecx
        pop ebx
        pop eax
        jmp short loc_A6982
loc_A697D:
        call OplWrite
loc_A6982:
        ret
OplGetReg:
        push ecx
        cmp al, 20h
        jb short loc_A699B
        cmp al, 0F5h
        ja short loc_A699B
        LD mov, ecx, eax
        LD xor, eax, eax
        LD mov, al, cl
        mov ebx, unk_D68FC
        LD add, ebx, eax
        mov al, byte [ebx]
loc_A699B:
        pop ecx
        ret
OplLoadVoice:
        push ebp
        LD mov, ebp, esp
        push si
        cld
        movzx ebx, word [byte ebp+08h]
        cmp ebx, byte 9
        jl short loc_A69B0
        pop si
        leave
        ret
loc_A69B0:
        mov cl, byte [dword ebx+byte_D67A8]
        mov esi, unk_D67B4
        mov ebx, dword [byte ebp+0Ch]
        mov ch, 0Ah
loc_A69C0:
        mov ah, byte [ebx]
        inc ebx
        lodsb
        LD add, al, cl
        call OplSetReg
        dec ch
        jne short loc_A69C0
        movzx ecx, word [byte ebp+08h]
        mov ch, 3
loc_A69D5:
        mov ah, byte [ebx]
        inc ebx
        lodsb
        LD add, al, cl
        call OplSetReg
        dec ch
        jne short loc_A69D5
        pop si
        leave
        ret
OplHwInit:
        push ebp
        LD mov, ebp, esp
        mov eax, dword [byte ebp+08h]
        mov word [word_D679C], ax
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
        mov word [word_D679C], ax
        mov eax, 20h
        mov dword [dword_D67A0], eax
        mov eax, 8Ch
        mov dword [dword_D67A4], eax
        call OplProbe
        mov eax, 0
        jb short loc_A6A40
        call OplCalibrate
        mov eax, 1
        clc
loc_A6A40:
        leave
        ret
OplProbe:
        push ax
        push cx
        push dx
        mov dx, word [word_D679C]
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
loc_A6A89:
        in al, dx
        and al, 0E0h
        cmp al, 0C0h
        je short loc_A6A92
        loop loc_A6A89
loc_A6A92:
        LD mov, ecx, eax
        mov eax, 6004h
        call OplWrite
        mov eax, 8004h
        call OplWrite
        and bl, 0E0h
        cmp bl, 0
        stc
        jne short loc_A6ABB
        and cl, 0E0h
        cmp cl, 0C0h
        stc
        jne short loc_A6ABB
        clc
loc_A6ABB:
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
        mov dx, word [word_D679C]
        LD xor, eax, eax
loc_A6AEC:
        in al, dx
        loop loc_A6AEC
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
        jne short loc_A6B14
        mov eax, 1
loc_A6B14:
        shl eax, 1
        LD xor, edx, edx
        mov eax, 7530h
        div ecx
        cmp eax, byte 0
        jne short loc_A6B29
        mov eax, 1
loc_A6B29:
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
        movzx eax, word [nosplit eax*2+word_D67F4]
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
        movzx eax, word [dword ebx+word_D683C]
        leave
        ret
OplVelocityLevel:
        push ebp
        LD mov, ebp, esp
        LD xor, ebx, ebx
        mov bl, byte [byte ebp+08h]
        and ebx, byte 7Eh
        movzx eax, word [dword ebx+word_D687C]
        leave
        ret
