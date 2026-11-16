; The Gravis Ultrasound SDK.
bits 32
%include "hockey.inc"
section s_B12A0 progbits alloc exec nowrite align=1
extern __GETDS, GusMidiIrq, GusWaveIrq, GusVoiceIrqBits, dword_D87A0, GusMidiIrqCount, GusTimerCallback, GusDmaDoneCallback
extern GusRecordDoneCallback, GusWaveCallback, GusVolumeCallback, GusTimer1Callback, GusTimer2Callback, GusWaveIrqCallback, GusVolumeIrqCallback, dword_D87D0
extern dword_D87D4, inp_, outp_, GusSendEoi, GusBasePort, GusIrqStatusPort, word_D876C, word_D876E
extern GusRegSelectPort, GusDataHighPort, GusDramPort, GusIrqFlags, GusCriticalDepth
global sub_B12A0, loc_B12DD, loc_B12EC, loc_B1311, sub_B131C, loc_B1358, loc_B1365, loc_B1392
global GusDelay, loc_B13AF, GusSetBasePort, loc_B13E7, loc_B13EF, loc_B13F6, loc_B13FB, GusClearCallbacks
global GusClaimCallback, loc_B146B, loc_B1476, loc_B147B, GusClaimVoiceCallback, loc_B1493, loc_B149E, loc_B14A3
global GusSetDmaCallbacks, loc_B14DA, loc_B14DC, sub_B14E4, loc_B1512, loc_B1514, sub_B151C, loc_B154A
global loc_B154C, GusSetVoiceCallbacks, loc_B1573, loc_B158F, loc_B1594, sub_B1598, loc_B15B1, sub_B15B8
global loc_B15D1, sub_B15D8, loc_B15F1, GusMidiIrqService, loc_B1646, loc_B166D, GusReadIrqSource, loc_B16A9
global loc_B16B3, GusServiceIrq, loc_B16D8, loc_B16F3, loc_B1706, loc_B1735, loc_B1772, loc_B17B9
global loc_B1813, loc_B186E, loc_B1877, loc_B18C7, loc_B18DC, loc_B18F1, loc_B18F3, loc_B1902
global loc_B1917, loc_B192C, loc_B192E, loc_B1938
sub_B12A0:
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
        je short loc_B12DD
        mov bx, word [GusIrqFlags]
        or bl, 2
        mov word [GusIrqFlags], bx
        jmp short loc_B1311
loc_B12DD:
        mov ax, word [GusCriticalDepth]
        inc word [GusCriticalDepth]
        push ds
        pop es
loc_B12EC:
        and word [GusIrqFlags], byte 0FFFDh
        call GusServiceIrq
        test word [GusIrqFlags], 2
        jne short loc_B12EC
        mov ax, word [GusCriticalDepth]
        dec word [GusCriticalDepth]
loc_B1311:
        pop gs
        pop fs
        pop es
        pop ds
        popa
        iret
        db 08Dh,040h,00h
sub_B131C:
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
        je short loc_B1358
        mov dx, word [GusIrqFlags]
        or dl, 8
        mov word [GusIrqFlags], dx
        jmp short loc_B1392
loc_B1358:
        mov eax, dword [dword_D87A0]
        inc dword [dword_D87A0]
        push ds
        pop es
loc_B1365:
        mov bx, word [GusIrqFlags]
        and bl, 0F7h
        mov word [GusIrqFlags], bx
        call GusMidiIrqService
        mov cx, word [GusIrqFlags]
        test cl, 8
        jne short loc_B1365
        mov eax, dword [dword_D87A0]
        dec dword [dword_D87A0]
loc_B1392:
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
loc_B13AF:
        in al, dx
        loopne loc_B13AF
        pop edx
        pop ecx
        ret
GusSetBasePort:
        push ebx
        push ecx
        push esi
        cmp eax, 210h
        jb short loc_B13F6
        nop
        nop
        nop
        nop
        cmp eax, 260h
        ja short loc_B13F6
        nop
        nop
        nop
        nop
        movzx ebx, word [GusBasePort]
        LD sub, eax, ebx
        je short loc_B13EF
        nop
        nop
        nop
        nop
        mov esi, GusBasePort
        mov ecx, 0Dh
loc_B13E7:
        add word [esi], ax
        add esi, byte 2
        loop loc_B13E7
loc_B13EF:
        LD xor, eax, eax
        jmp short loc_B13FB
        db 090h,090h,090h
loc_B13F6:
        mov eax, 1
loc_B13FB:
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
        mov dword [dword_D87D0], edx
        mov dword [dword_D87D4], edx
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
        je short loc_B146B
        test edx, edx
        jne short loc_B1476
loc_B146B:
        pushfw
        cli
        mov dword [ebx], edx
        popfw
        xor eax, eax
        jmp short loc_B147B
loc_B1476:
        mov eax, 1
loc_B147B:
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
        je short loc_B1493
        test edx, edx
        jne short loc_B149E
loc_B1493:
        pushfw
        cli
        mov dword [ebx], edx
        popfw
        xor eax, eax
        jmp short loc_B14A3
loc_B149E:
        mov eax, 1
loc_B14A3:
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
        je short loc_B14DA
        mov eax, GusRecordDoneCallback
        mov edx, ebx
        call GusClaimCallback
        test eax, eax
        je short loc_B14DA
        mov eax, 8
        jmp short loc_B14DC
loc_B14DA:
        xor eax, eax
loc_B14DC:
        lea esp, [byte ebp-08h]
        pop edx
        pop ebx
        pop ebp
        ret
        db 090h
sub_B14E4:
        push ebp
        mov ebp, esp
        push ebx
        push edx
        mov ebx, eax
        mov eax, GusWaveCallback
        mov edx, ebx
        call GusClaimCallback
        test eax, eax
        je short loc_B1512
        mov eax, GusVolumeCallback
        mov edx, ebx
        call GusClaimCallback
        test eax, eax
        je short loc_B1512
        mov eax, 8
        jmp short loc_B1514
loc_B1512:
        xor eax, eax
loc_B1514:
        lea esp, [byte ebp-08h]
        pop edx
        pop ebx
        pop ebp
        ret
        db 090h
sub_B151C:
        push ebp
        mov ebp, esp
        push ebx
        push edx
        mov ebx, eax
        mov eax, GusTimer1Callback
        mov edx, ebx
        call GusClaimCallback
        test eax, eax
        je short loc_B154A
        mov eax, GusTimer2Callback
        mov edx, ebx
        call GusClaimCallback
        test eax, eax
        je short loc_B154A
        mov eax, 8
        jmp short loc_B154C
loc_B154A:
        xor eax, eax
loc_B154C:
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
        jne short loc_B1573
        mov eax, GusWaveIrqCallback
        call GusClaimVoiceCallback
        test eax, eax
        je short loc_B1594
        mov eax, 8
        mov esp, ebp
        pop ebp
        ret
loc_B1573:
        cmp eax, byte 2
        jne short loc_B158F
        mov eax, GusVolumeIrqCallback
        call GusClaimVoiceCallback
        test eax, eax
        je short loc_B1594
        mov eax, 8
        mov esp, ebp
        pop ebp
        ret
loc_B158F:
        mov eax, 0Dh
loc_B1594:
        mov esp, ebp
        pop ebp
        ret
sub_B1598:
        push ebp
        mov ebp, esp
        push edx
        mov edx, eax
        mov eax, dword_D87D4
        call GusClaimVoiceCallback
        test eax, eax
        je short loc_B15B1
        mov eax, 8
loc_B15B1:
        lea esp, [byte ebp-04h]
        pop edx
        pop ebp
        ret
        db 090h
sub_B15B8:
        push ebp
        mov ebp, esp
        push edx
        mov edx, eax
        mov eax, dword_D87D0
        call GusClaimVoiceCallback
        test eax, eax
        je short loc_B15D1
        mov eax, 8
loc_B15D1:
        lea esp, [byte ebp-04h]
        pop edx
        pop ebp
        ret
        db 090h
sub_B15D8:
        push ebp
        mov ebp, esp
        push edx
        mov edx, eax
        mov eax, GusTimerCallback
        call GusClaimVoiceCallback
        test eax, eax
        je short loc_B15F1
        mov eax, 8
loc_B15F1:
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
        je short loc_B166D
        xor eax, eax
        mov ax, word [word_D876C]
        call inp_
        mov ebx, eax
        mov ecx, eax
        test dl, 1
        je short loc_B1646
        cmp dword [dword_D87D0], byte 0
        je short loc_B1646
        call dword [dword_D87D0]
loc_B1646:
        test byte [byte ebp-014h], 2
        je short loc_B166D
        xor eax, eax
        mov ax, word [word_D876E]
        call inp_
        mov edi, dword [dword_D87D4]
        mov edx, eax
        test edi, edi
        je short loc_B166D
        mov eax, ecx
        call dword [dword_D87D4]
loc_B166D:
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
        je short loc_B16A9
        and bl, 0FCh
        mov edx, ebx
loc_B16A9:
        test dl, 3
        je short loc_B16B3
        call GusMidiIrqService
loc_B16B3:
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
loc_B16D8:
        call GusReadIrqSource
        mov ebx, eax
        test eax, eax
        jne short loc_B16F3
        mov cx, word [GusIrqFlags]
        test cl, 4
        je near loc_B1938
loc_B16F3:
        test bl, 80h
        jne short loc_B1706
        mov ax, word [GusIrqFlags]
        test al, 4
        je near loc_B17B9
loc_B1706:
        xor eax, eax
        mov edx, 41h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov ax, word [GusDataHighPort]
        call inp_
        test al, 40h
        jne short loc_B1735
        mov dx, word [GusIrqFlags]
        test dl, 4
        je short loc_B1772
loc_B1735:
        mov cx, word [GusIrqFlags]
        and cl, 0FBh
        mov word [GusIrqFlags], cx
        cmp dword [GusDmaDoneCallback], byte 0
        je short loc_B1772
        mov eax, 1
        call dword [GusDmaDoneCallback]
        test eax, eax
        jne short loc_B1772
        cmp dword [GusRecordDoneCallback], byte 0
        je short loc_B1772
        mov eax, 1
        call dword [GusRecordDoneCallback]
loc_B1772:
        xor eax, eax
        mov edx, 49h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov ax, word [GusDataHighPort]
        call inp_
        test al, 40h
        je short loc_B17B9
        cmp dword [GusDmaDoneCallback], byte 0
        je short loc_B17B9
        xor eax, eax
        call dword [GusDmaDoneCallback]
        test eax, eax
        jne short loc_B17B9
        cmp dword [GusRecordDoneCallback], byte 0
        je short loc_B17B9
        call dword [GusRecordDoneCallback]
loc_B17B9:
        test bl, 4
        je short loc_B1813
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
        je short loc_B1813
        call dword [GusWaveIrqCallback]
        test eax, eax
        je short loc_B1813
        xor eax, eax
        mov dword [GusWaveIrqCallback], eax
loc_B1813:
        test bl, 8
        je short loc_B186E
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
        je short loc_B186E
        call dword [GusVolumeIrqCallback]
        test eax, eax
        je short loc_B186E
        xor ecx, ecx
        mov dword [GusVolumeIrqCallback], ecx
loc_B186E:
        test bl, 60h
        je near loc_B16D8
loc_B1877:
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
        je near loc_B16D8
        mov al, ch
        mov ebx, 1
        and al, 1Fh
        xor edx, edx
        mov cl, al
        mov dl, al
        shl ebx, cl
        test ch, 80h
        jne short loc_B18F3
        test edi, ebx
        je short loc_B18C7
        mov eax, ebx
        not eax
        and edi, eax
        jmp short loc_B18F3
loc_B18C7:
        cmp dword [GusWaveCallback], byte 0
        je short loc_B18DC
        mov eax, edx
        call dword [GusWaveCallback]
        test eax, eax
        jne short loc_B18F1
loc_B18DC:
        cmp dword [GusVolumeCallback], byte 0
        je short loc_B18F3
        mov eax, edx
        call dword [GusVolumeCallback]
        test eax, eax
        je short loc_B18F3
loc_B18F1:
        or edi, ebx
loc_B18F3:
        test ch, 40h
        jne short loc_B192E
        test esi, ebx
        je short loc_B1902
        not ebx
        and esi, ebx
        jmp short loc_B192E
loc_B1902:
        cmp dword [GusTimer1Callback], byte 0
        je short loc_B1917
        mov eax, edx
        call dword [GusTimer1Callback]
        test eax, eax
        jne short loc_B192C
loc_B1917:
        cmp dword [GusTimer2Callback], byte 0
        je short loc_B192E
        mov eax, edx
        call dword [GusTimer2Callback]
        test eax, eax
        je short loc_B192E
loc_B192C:
        or esi, ebx
loc_B192E:
        call GusReadIrqSource
        jmp near loc_B1877
loc_B1938:
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
