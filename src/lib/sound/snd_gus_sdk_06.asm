; The Gravis Ultrasound SDK.
bits 32
%include "hockey.inc"
section s_B12A0 progbits alloc exec nowrite align=1
extern __GETDS, GusMidiIrq, GusWaveIrq, GusVoiceIrqBits, dword_D87A0, GusMidiIrqCount, GusTimerCallback, GusDmaDoneCallback
extern GusRecordDoneCallback, GusWaveCallback, GusVolumeCallback, GusTimer1Callback, GusTimer2Callback, GusWaveIrqCallback, GusVolumeIrqCallback, GusMidiXmitCallback
extern GusMidiRecvCallback, inp_, outp_, GusSendEoi, GusBasePort, GusIrqStatusPort, GusMidiControlPort, GusMidiDataPort
extern GusRegSelectPort, GusDataHighPort, GusDramPort, GusIrqFlags, GusCriticalDepth
global GusWaveIrqHandler, GusMidiIrqHandler, GusDelay, GusSetBasePort, GusClearCallbacks, GusClaimCallback, GusClaimVoiceCallback, GusSetDmaCallbacks
global GusClaimVoiceCallbacks, GusClaimTimerCallbacks, GusSetVoiceCallbacks, GusClaimMidiRecvCallback, GusClaimMidiXmitCallback, GusClaimTimerCallback, GusMidiIrqService, GusReadIrqSource
global GusServiceIrq
GusWaveIrqHandler:
        pusha
        push ds
        push es
        push fs
        push gs
        mov ebp, esp
        cld
        call __GETDS
        xor ah, ah
        mov al, byte [GusWaveIrq]
        and eax, 0FFFFh
        call GusSendEoi
        cmp word [GusCriticalDepth], byte 0
        je short .1
        mov bx, word [GusIrqFlags]
        or bl, 2
        mov word [GusIrqFlags], bx
        jmp short .3
.1:
        mov ax, word [GusCriticalDepth]
        inc word [GusCriticalDepth]
        push ds
        pop es
.2:
        and word [GusIrqFlags], byte 0FFFDh
        call GusServiceIrq
        test word [GusIrqFlags], 2
        jne short .2
        mov ax, word [GusCriticalDepth]
        dec word [GusCriticalDepth]
.3:
        pop gs
        pop fs
        pop es
        pop ds
        popa
        iret
        db 08Dh,040h,00h
GusMidiIrqHandler:
        pusha
        push ds
        push es
        push fs
        push gs
        mov ebp, esp
        cld
        call __GETDS
        xor ah, ah
        mov al, byte [GusMidiIrq]
        and eax, 0FFFFh
        call GusSendEoi
        cmp dword [dword_D87A0], byte 0
        je short .1
        mov dx, word [GusIrqFlags]
        or dl, 8
        mov word [GusIrqFlags], dx
        jmp short .3
.1:
        mov eax, dword [dword_D87A0]
        inc dword [dword_D87A0]
        push ds
        pop es
.2:
        mov bx, word [GusIrqFlags]
        and bl, 0F7h
        mov word [GusIrqFlags], bx
        call GusMidiIrqService
        mov cx, word [GusIrqFlags]
        test cl, 8
        jne short .2
        mov eax, dword [dword_D87A0]
        dec dword [dword_D87A0]
.3:
        pop gs
        pop fs
        pop es
        pop ds
        popa
        iret
        db 00h,00h,00h,00h,00h,00h,00h
GusDelay:
        push ecx
        push edx
        mov ecx, 0Ah
        mov dx, word [GusDramPort]
.1:
        in al, dx
        loopne .1
        pop edx
        pop ecx
        ret
GusSetBasePort:
        push ebx
        push ecx
        push esi
        cmp eax, 210h
        jb short .3
        nop
        nop
        nop
        nop
        cmp eax, 260h
        ja short .3
        nop
        nop
        nop
        nop
        movzx ebx, word [GusBasePort]
        LD sub, eax, ebx
        je short .2
        nop
        nop
        nop
        nop
        mov esi, GusBasePort
        mov ecx, 0Dh
.1:
        add word [esi], ax
        add esi, byte 2
        loop .1
.2:
        LD xor, eax, eax
        jmp short .4
        db 090h,090h,090h
.3:
        mov eax, 1
.4:
        pop esi
        pop ecx
        pop ebx
        ret
        db 00h
GusClearCallbacks:
        push ebp
        mov ebp, esp
        push edx
        xor edx, edx
        mov dword [GusTimerCallback], edx
        mov dword [GusDmaDoneCallback], edx
        mov dword [GusRecordDoneCallback], edx
        mov dword [GusWaveCallback], edx
        mov dword [GusVolumeCallback], edx
        mov dword [GusTimer1Callback], edx
        mov dword [GusTimer2Callback], edx
        mov dword [GusWaveIrqCallback], edx
        mov dword [GusVolumeIrqCallback], edx
        mov dword [GusMidiXmitCallback], edx
        mov dword [GusMidiRecvCallback], edx
        mov dword [GusVoiceIrqBits], edx
        mov dword [GusMidiIrqCount], edx
        lea esp, [byte ebp-04h]
        pop edx
        pop ebp
        ret
        db 08Bh,0C0h
GusClaimCallback:
        push ebp
        mov ebp, esp
        push ebx
        mov ebx, eax
        cmp dword [eax], byte 0
        je short .1
        test edx, edx
        jne short .2
.1:
        pushfw
        cli
        mov dword [ebx], edx
        popfw
        xor eax, eax
        jmp short .3
.2:
        mov eax, 1
.3:
        lea esp, [byte ebp-04h]
        pop ebx
        pop ebp
        ret
        db 08Dh,040h,00h
GusClaimVoiceCallback:
        push ebp
        mov ebp, esp
        push ebx
        mov ebx, eax
        cmp dword [eax], byte 0
        je short .1
        test edx, edx
        jne short .2
.1:
        pushfw
        cli
        mov dword [ebx], edx
        popfw
        xor eax, eax
        jmp short .3
.2:
        mov eax, 1
.3:
        lea esp, [byte ebp-04h]
        pop ebx
        pop ebp
        ret
        db 08Dh,040h,00h
GusSetDmaCallbacks:
        push ebp
        mov ebp, esp
        push ebx
        push edx
        mov ebx, eax
        mov eax, GusDmaDoneCallback
        mov edx, ebx
        call GusClaimCallback
        test eax, eax
        je short .1
        mov eax, GusRecordDoneCallback
        mov edx, ebx
        call GusClaimCallback
        test eax, eax
        je short .1
        mov eax, 8
        jmp short .2
.1:
        xor eax, eax
.2:
        lea esp, [byte ebp-08h]
        pop edx
        pop ebx
        pop ebp
        ret
        db 090h
GusClaimVoiceCallbacks:
        push ebp
        mov ebp, esp
        push ebx
        push edx
        mov ebx, eax
        mov eax, GusWaveCallback
        mov edx, ebx
        call GusClaimCallback
        test eax, eax
        je short .1
        mov eax, GusVolumeCallback
        mov edx, ebx
        call GusClaimCallback
        test eax, eax
        je short .1
        mov eax, 8
        jmp short .2
.1:
        xor eax, eax
.2:
        lea esp, [byte ebp-08h]
        pop edx
        pop ebx
        pop ebp
        ret
        db 090h
GusClaimTimerCallbacks:
        push ebp
        mov ebp, esp
        push ebx
        push edx
        mov ebx, eax
        mov eax, GusTimer1Callback
        mov edx, ebx
        call GusClaimCallback
        test eax, eax
        je short .1
        mov eax, GusTimer2Callback
        mov edx, ebx
        call GusClaimCallback
        test eax, eax
        je short .1
        mov eax, 8
        jmp short .2
.1:
        xor eax, eax
.2:
        lea esp, [byte ebp-08h]
        pop edx
        pop ebx
        pop ebp
        ret
        db 090h
GusSetVoiceCallbacks:
        push ebp
        mov ebp, esp
        cmp eax, byte 1
        jne short .1
        mov eax, GusWaveIrqCallback
        call GusClaimVoiceCallback
        test eax, eax
        je short .3
        mov eax, 8
        mov esp, ebp
        pop ebp
        ret
.1:
        cmp eax, byte 2
        jne short .2
        mov eax, GusVolumeIrqCallback
        call GusClaimVoiceCallback
        test eax, eax
        je short .3
        mov eax, 8
        mov esp, ebp
        pop ebp
        ret
.2:
        mov eax, 0Dh
.3:
        mov esp, ebp
        pop ebp
        ret
GusClaimMidiRecvCallback:
        push ebp
        mov ebp, esp
        push edx
        mov edx, eax
        mov eax, GusMidiRecvCallback
        call GusClaimVoiceCallback
        test eax, eax
        je short .1
        mov eax, 8
.1:
        lea esp, [byte ebp-04h]
        pop edx
        pop ebp
        ret
        db 090h
GusClaimMidiXmitCallback:
        push ebp
        mov ebp, esp
        push edx
        mov edx, eax
        mov eax, GusMidiXmitCallback
        call GusClaimVoiceCallback
        test eax, eax
        je short .1
        mov eax, 8
.1:
        lea esp, [byte ebp-04h]
        pop edx
        pop ebp
        ret
        db 090h
GusClaimTimerCallback:
        push ebp
        mov ebp, esp
        push edx
        mov edx, eax
        mov eax, GusTimerCallback
        call GusClaimVoiceCallback
        test eax, eax
        je short .1
        mov eax, 8
.1:
        lea esp, [byte ebp-04h]
        pop edx
        pop ebp
        ret
        db 090h
GusMidiIrqService:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        push edi
        sub esp, byte 4
        pushfw
        cli
        inc dword [GusMidiIrqCount]
        xor eax, eax
        mov ax, word [GusIrqStatusPort]
        call inp_
        mov edx, eax
        mov dword [byte ebp-014h], eax
        test al, 3
        je short .2
        xor eax, eax
        mov ax, word [GusMidiControlPort]
        call inp_
        mov ebx, eax
        mov ecx, eax
        test dl, 1
        je short .1
        cmp dword [GusMidiXmitCallback], byte 0
        je short .1
        call dword [GusMidiXmitCallback]
.1:
        test byte [byte ebp-014h], 2
        je short .2
        xor eax, eax
        mov ax, word [GusMidiDataPort]
        call inp_
        mov edi, dword [GusMidiRecvCallback]
        mov edx, eax
        test edi, edi
        je short .2
        mov eax, ecx
        call dword [GusMidiRecvCallback]
.2:
        dec dword [GusMidiIrqCount]
        popfw
        lea esp, [byte ebp-010h]
        pop edi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Bh,0C0h
GusReadIrqSource:
        push ebp
        mov ebp, esp
        push ebx
        push edx
        xor eax, eax
        cli
        mov ax, word [GusIrqStatusPort]
        call inp_
        mov ebx, eax
        mov edx, eax
        mov al, byte [GusMidiIrq]
        cmp al, byte [GusWaveIrq]
        je short .1
        and bl, 0FCh
        mov edx, ebx
.1:
        test dl, 3
        je short .2
        call GusMidiIrqService
.2:
        mov eax, edx
        lea esp, [byte ebp-08h]
        pop edx
        pop ebx
        pop ebp
        ret
GusServiceIrq:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        push esi
        push edi
        pushfw
        cli
        mov ax, word [GusCriticalDepth]
        inc word [GusCriticalDepth]
        xor edi, edi
        xor esi, esi
.1:
        call GusReadIrqSource
        mov ebx, eax
        test eax, eax
        jne short .2
        mov cx, word [GusIrqFlags]
        test cl, 4
        je near .18
.2:
        test bl, 80h
        jne short .3
        mov ax, word [GusIrqFlags]
        test al, 4
        je near .6
.3:
        xor eax, eax
        mov edx, 41h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov ax, word [GusDataHighPort]
        call inp_
        test al, 40h
        jne short .4
        mov dx, word [GusIrqFlags]
        test dl, 4
        je short .5
.4:
        mov cx, word [GusIrqFlags]
        and cl, 0FBh
        mov word [GusIrqFlags], cx
        cmp dword [GusDmaDoneCallback], byte 0
        je short .5
        mov eax, 1
        call dword [GusDmaDoneCallback]
        test eax, eax
        jne short .5
        cmp dword [GusRecordDoneCallback], byte 0
        je short .5
        mov eax, 1
        call dword [GusRecordDoneCallback]
.5:
        xor eax, eax
        mov edx, 49h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov ax, word [GusDataHighPort]
        call inp_
        test al, 40h
        je short .6
        cmp dword [GusDmaDoneCallback], byte 0
        je short .6
        xor eax, eax
        call dword [GusDmaDoneCallback]
        test eax, eax
        jne short .6
        cmp dword [GusRecordDoneCallback], byte 0
        je short .6
        call dword [GusRecordDoneCallback]
.6:
        test bl, 4
        je short .7
        xor eax, eax
        mov edx, 45h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, dword [GusVoiceIrqBits]
        mov ax, word [GusDataHighPort]
        and dl, 0FBh
        call outp_
        xor eax, eax
        mov edx, dword [GusVoiceIrqBits]
        mov ax, word [GusDataHighPort]
        call outp_
        cmp dword [GusWaveIrqCallback], byte 0
        je short .7
        call dword [GusWaveIrqCallback]
        test eax, eax
        je short .7
        xor eax, eax
        mov dword [GusWaveIrqCallback], eax
.7:
        test bl, 8
        je short .8
        xor eax, eax
        mov edx, 45h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, dword [GusVoiceIrqBits]
        mov ax, word [GusDataHighPort]
        and dl, 0F7h
        call outp_
        xor eax, eax
        mov edx, dword [GusVoiceIrqBits]
        mov ax, word [GusDataHighPort]
        call outp_
        cmp dword [GusVolumeIrqCallback], byte 0
        je short .8
        call dword [GusVolumeIrqCallback]
        test eax, eax
        je short .8
        xor ecx, ecx
        mov dword [GusVolumeIrqCallback], ecx
.8:
        test bl, 60h
        je near .1
.9:
        cli
        xor eax, eax
        mov edx, 8Fh
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov ax, word [GusDataHighPort]
        call inp_
        mov ch, al
        mov al, ch
        and al, 0C0h
        cmp al, 0C0h
        je near .1
        mov al, ch
        mov ebx, 1
        and al, 1Fh
        xor edx, edx
        mov cl, al
        mov dl, al
        shl ebx, cl
        test ch, 80h
        jne short .13
        test edi, ebx
        je short .10
        mov eax, ebx
        not eax
        and edi, eax
        jmp short .13
.10:
        cmp dword [GusWaveCallback], byte 0
        je short .11
        mov eax, edx
        call dword [GusWaveCallback]
        test eax, eax
        jne short .12
.11:
        cmp dword [GusVolumeCallback], byte 0
        je short .13
        mov eax, edx
        call dword [GusVolumeCallback]
        test eax, eax
        je short .13
.12:
        or edi, ebx
.13:
        test ch, 40h
        jne short .17
        test esi, ebx
        je short .14
        not ebx
        and esi, ebx
        jmp short .17
.14:
        cmp dword [GusTimer1Callback], byte 0
        je short .15
        mov eax, edx
        call dword [GusTimer1Callback]
        test eax, eax
        jne short .16
.15:
        cmp dword [GusTimer2Callback], byte 0
        je short .17
        mov eax, edx
        call dword [GusTimer2Callback]
        test eax, eax
        je short .17
.16:
        or esi, ebx
.17:
        call GusReadIrqSource
        jmp near .9
.18:
        mov ax, word [GusCriticalDepth]
        dec word [GusCriticalDepth]
        popfw
        lea esp, [byte ebp-014h]
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
