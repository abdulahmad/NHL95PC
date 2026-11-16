; The Gravis Ultrasound SDK.
bits 32
%include "hockey.inc"
section s_B07D0 progbits alloc exec nowrite align=1
extern _dos_close_, _dos_getvect_, _dos_open_, _dos_read_, _dos_setvect_, GusDmaPageTable, GusDmaLatchBits, GusDmaReady
extern GusPlayDmaChannel, GusRecordDmaChannel, GusDmaControl, GusIrqOldHandler, GusDmaBusy, GusDmaLeft, GusDmaChunkSize, GusDmaDone
extern inp_, lseek_, outp_, outpw_, GusDelay, GusSetDmaCallbacks, GusServiceIrq, GusPokeFill
extern GusConvertAddr16, GusDmaChannels, GusIrqVectorTable, GusIrqOldSelector, GusIrqStatusPort, GusRegSelectPort, GusDataLowPort, GusDataHighPort
extern GusIrqPending, GusVoiceRateTable, GusDosResult, GusIrqFlags, GusActiveVoices, GusCriticalDepth, GusDmaChunkLo, GusDmaChunkHi
extern GusDmaFlags
global GusSetupDmaChannel, GusProgramDma, GusMaskDma, GusDmaCount, GusDosRead, GusDosClose, GusDosSeek, GusDosOpen
global GusSetVect, GusGetVect, GusHookIrq, GusUnhookIrq, GusSendEoi, GusInitPlayDma, GusInitRecordDma, GusInitDma
global GusStartDramDma, GusDownload, GusDmaNextChunk, GusDramDmaDone, GusDmaIdle, GusStopDma, GusCalcVoiceAddrs, GusClearIrqState
global GusEnterCritical, GusTryEnterCritical, GusLeaveCritical
GusSetupDmaChannel:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push esi
        mov ebx, eax
        shl eax, 4
        add eax, ebx
        add eax, GusDmaChannels
        mov word [byte eax+0Fh], dx
        mov ebx, edx
        and bl, 3
        xor bh, dh
        cmp edx, byte 3
        jg short .1
        mov word [byte eax+09h], 0Ah
        mov word [byte eax+0Bh], 0Bh
        mov word [byte eax+0Dh], 0Ch
        mov ecx, ebx
        add ecx, ebx
        mov word [byte eax+05h], cx
        mov cx, word [byte eax+05h]
        or cl, 1
        jmp short .2
.1:
        mov word [byte eax+09h], 0D4h
        mov word [byte eax+0Bh], 0D6h
        mov word [byte eax+0Dh], 0D8h
        mov ecx, ebx
        shl ecx, 2
        mov esi, ecx
        or esi, 0C0h
        mov word [byte eax+05h], si
        or cl, 0C2h
.2:
        mov word [byte eax+07h], cx
        mov byte [byte eax+01h], bl
        or bl, 4
        mov byte [eax], bl
        mov dl, byte [nosplit edx*2+GusDmaPageTable]
        mov byte [byte eax+02h], dl
        lea esp, [byte ebp-0Ch]
        pop esi
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Dh,040h,00h
GusProgramDma:
        push ebp
        mov ebp, esp
        push esi
        sub esp, byte 10h
        mov esi, ebx
        mov ebx, eax
        shl ebx, 4
        add ebx, eax
        add ebx, GusDmaChannels
        mov ax, word [byte ebx+0Fh]
        and al, 3
        xor ah, ah
        or esi, eax
        cmp word [byte ebx+0Fh], byte 4
        jb short .1
        sub edx, byte 2
        mov eax, edx
        shr eax, 1
        mov byte [byte ebp-0Ch], al
        xor eax, eax
        shr edx, 9
        mov ax, word [byte ebp+08h]
        mov byte [byte ebp-014h], dl
        mov edx, eax
        sar edx, 1
        sar eax, 9
        mov byte [byte ebp-010h], dl
        mov byte [byte ebp-08h], al
        test cl, 1
        je short .2
        mov ah, al
        or ah, 80h
        mov byte [byte ebp-08h], ah
        jmp short .2
.1:
        mov al, dl
        dec al
        mov byte [byte ebp-0Ch], al
        lea eax, [byte edx-01h]
        shr eax, 8
        mov byte [byte ebp-014h], al
        mov al, byte [byte ebp+08h]
        mov byte [byte ebp-010h], al
        xor eax, eax
        mov ax, word [byte ebp+08h]
        sar eax, 8
        mov byte [byte ebp-08h], al
.2:
        xor edx, edx
        pushfw
        cli
        mov dl, byte [ebx]
        xor eax, eax
        mov ax, word [byte ebx+09h]
        call outp_
        xor edx, edx
        xor eax, eax
        mov dx, si
        mov ax, word [byte ebx+0Bh]
        call outp_
        xor eax, eax
        mov ax, word [byte ebx+0Dh]
        xor edx, edx
        call outp_
        xor edx, edx
        xor eax, eax
        mov dl, byte [byte ebp-010h]
        mov ax, word [byte ebx+05h]
        call outp_
        xor edx, edx
        xor eax, eax
        mov dl, byte [byte ebp-08h]
        mov ax, word [byte ebx+05h]
        call outp_
        xor edx, edx
        xor eax, eax
        mov dx, cx
        mov al, byte [byte ebx+02h]
        call outp_
        xor eax, eax
        mov ax, word [byte ebx+0Dh]
        xor edx, edx
        call outp_
        xor edx, edx
        xor eax, eax
        mov dl, byte [byte ebp-0Ch]
        mov ax, word [byte ebx+07h]
        call outp_
        xor edx, edx
        xor eax, eax
        mov dl, byte [byte ebp-014h]
        mov ax, word [byte ebx+07h]
        call outp_
        xor edx, edx
        mov dl, byte [byte ebx+01h]
        xor eax, eax
        mov ax, word [byte ebx+09h]
        call outp_
        popfw
        lea esp, [byte ebp-04h]
        pop esi
        pop ebp
        ret 4
GusMaskDma:
        push ebp
        mov ebp, esp
        push edx
        mov edx, eax
        shl eax, 4
        add eax, edx
        add eax, GusDmaChannels
        xor edx, edx
        mov dl, byte [eax]
        mov ax, word [byte eax+09h]
        and eax, 0FFFFh
        call outp_
        lea esp, [byte ebp-04h]
        pop edx
        pop ebp
        ret
GusDmaCount:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        mov ebx, eax
        shl eax, 4
        add eax, ebx
        mov ebx, GusDmaChannels
        add ebx, eax
        pushfw
        cli
        xor eax, eax
        mov ax, word [byte ebx+0Dh]
        xor edx, edx
        call outp_
        xor eax, eax
        mov ax, word [byte ebx+07h]
        call inp_
        mov edx, eax
        xor eax, eax
        mov ax, word [byte ebx+07h]
        call inp_
        mov ecx, eax
        popfw
        mov al, cl
        xor ah, ah
        and eax, 0FFFFh
        xor dh, dh
        shl eax, 8
        and edx, 0FFFFh
        add eax, edx
        inc eax
        and eax, 0FFFFh
        cmp word [byte ebx+0Fh], byte 4
        jb short .1
        add eax, eax
.1:
        lea esp, [byte ebp-0Ch]
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Dh,040h,00h
GusDosRead:
        push ebp
        mov ebp, esp
        push ecx
        push esi
        sub esp, byte 4
        lea esi, [byte ebp-0Ch]
        push esi
        xor esi, esi
        mov ecx, ds
        mov si, bx
        mov ebx, edx
        mov edx, esi
        call _dos_read_
        mov word [GusDosResult], ax
        mov eax, dword [byte ebp-0Ch]
        lea esp, [byte ebp-08h]
        pop esi
        pop ecx
        pop ebp
        ret
GusDosClose:
        push ebp
        mov ebp, esp
        call _dos_close_
        mov word [GusDosResult], ax
        test ax, ax
        je short .1
        mov eax, 10h
.1:
        mov esp, ebp
        pop ebp
        ret
GusDosSeek:
        push ebp
        mov ebp, esp
        call lseek_
        test eax, eax
        jge short .1
        mov eax, 10h
        mov esp, ebp
        pop ebp
        ret
.1:
        xor eax, eax
        mov esp, ebp
        pop ebp
        ret
        db 090h
GusDosOpen:
        push ebp
        mov ebp, esp
        push ebx
        push edx
        sub esp, byte 4
        lea ebx, [byte ebp-0Ch]
        xor edx, edx
        call _dos_open_
        mov word [GusDosResult], ax
        test ax, ax
        jne short .1
        mov eax, dword [byte ebp-0Ch]
        jmp short .2
.1:
        cwde
        neg eax
.2:
        lea esp, [byte ebp-08h]
        pop edx
        pop ebx
        pop ebp
        ret
GusSetVect:
        push ebp
        mov ebp, esp
        call _dos_setvect_
        mov esp, ebp
        pop ebp
        ret
GusGetVect:
        push ebp
        mov ebp, esp
        call _dos_getvect_
        mov esp, ebp
        pop ebp
        ret
GusHookIrq:
        push ebp
        mov ebp, esp
        push edx
        push esi
        push edi
        sub esp, byte 4
        mov dword [byte ebp-010h], eax
        mov edi, ecx
        mov esi, ebx
        mov ecx, dword [byte ebp-010h]
        xor ebx, ebx
        pushfw
        cli
        mov bx, word [nosplit ecx*8+GusIrqVectorTable]
        mov eax, ebx
        call GusGetVect
        mov word [nosplit ecx*8+GusIrqOldSelector], dx
        mov dword [nosplit ecx*8+GusIrqOldHandler], eax
        mov eax, ebx
        mov ecx, edi
        mov ebx, esi
        call GusSetVect
        mov cl, byte [byte ebp-010h]
        mov dl, 1
        and cl, 7
        shl dl, cl
        mov ebx, dword [byte ebp-010h]
        not dl
        cmp ebx, byte 7
        jg short .1
        mov eax, 21h
        call inp_
        and eax, 0FFh
        and edx, 0FFh
        and edx, eax
        mov eax, 21h
        jmp short .2
.1:
        mov eax, 0A1h
        call inp_
        and eax, 0FFh
        and edx, 0FFh
        and edx, eax
        mov eax, 0A1h
.2:
        call outp_
        popfw
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop edx
        pop ebp
        ret
        db 08Bh,0C0h
GusUnhookIrq:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        mov ebx, eax
        pushfw
        cli
        cmp ebx, byte 2
        je short .3
        mov cl, bl
        mov dl, 1
        and cl, 7
        shl dl, cl
        cmp ebx, byte 7
        jg short .1
        mov eax, 21h
        call inp_
        and eax, 0FFh
        and edx, 0FFh
        or edx, eax
        mov eax, 21h
        jmp short .2
.1:
        mov eax, 0A1h
        call inp_
        and eax, 0FFh
        and edx, 0FFh
        or edx, eax
        mov eax, 0A1h
.2:
        call outp_
.3:
        xor eax, eax
        mov cx, word [nosplit ebx*8+GusIrqOldSelector]
        mov ax, word [nosplit ebx*8+GusIrqVectorTable]
        mov ebx, dword [nosplit ebx*8+GusIrqOldHandler]
        call GusSetVect
        popfw
        lea esp, [byte ebp-0Ch]
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Dh,040h,00h
GusSendEoi:
        push ebp
        mov ebp, esp
        push edx
        cmp ax, 7
        jbe short .1
        mov eax, 0A0h
        mov edx, 20h
        call outp_
.1:
        mov eax, 20h
        mov edx, eax
        call outp_
        lea esp, [byte ebp-04h]
        pop edx
        pop ebp
        ret
        db 00h
GusInitPlayDma:
        push ebp
        mov ebp, esp
        push edx
        mov edx, eax
        cmp byte [dword eax+GusDmaLatchBits], 0
        jne short .1
        mov al, 3
        jmp short .2
.1:
        xor eax, eax
        call GusSetupDmaChannel
        xor al, al
.2:
        lea esp, [byte ebp-04h]
        pop edx
        pop ebp
        ret
        db 08Bh,0C0h
GusInitRecordDma:
        push ebp
        mov ebp, esp
        push edx
        mov edx, eax
        cmp byte [dword eax+GusDmaLatchBits], 0
        jne short .1
        mov al, 3
        jmp short .2
.1:
        mov eax, 1
        call GusSetupDmaChannel
        xor al, al
.2:
        lea esp, [byte ebp-04h]
        pop edx
        pop ebp
        ret
        db 08Dh,040h,00h
GusInitDma:
        push ebp
        mov ebp, esp
        mov byte [GusDmaReady], 1
        xor eax, eax
        mov al, byte [GusPlayDmaChannel]
        call GusInitPlayDma
        test al, al
        je short .1
        and eax, 0FFh
        mov esp, ebp
        pop ebp
        ret
.1:
        xor eax, eax
        mov al, byte [GusRecordDmaChannel]
        call GusInitRecordDma
        test al, al
        je short .2
        and eax, 0FFh
        mov esp, ebp
        pop ebp
        ret
.2:
        mov eax, GusDmaNextChunk
        call GusSetDmaCallbacks
        test eax, eax
        je short .3
        mov eax, 8
        mov esp, ebp
        pop ebp
        ret
.3:
        mov dword [GusDmaBusy], eax
        mov esp, ebp
        pop ebp
        ret
GusStartDramDma:
        push ebp
        mov ebp, esp
        push esi
        mov esi, eax
        xor si, ax
        shr esi, 10h
        mov word [GusDmaChunkHi], si
        mov word [GusDmaChunkLo], ax
        mov dword [GusDmaLeft], edx
        mov eax, dword [byte ebp+08h]
        mov word [GusDmaFlags], ax
        xor edx, edx
        mov dword [GusDmaChunkSize], edx
        mov dword [GusDmaDone], edx
        mov dl, cl
        mov ah, byte [byte ebp+08h]
        or dl, 4
        test ah, 1
        je short .2
        test cl, 4
        jne short .1
        cmp byte [GusPlayDmaChannel], 4
        jb short .1
        mov eax, ebx
        call GusConvertAddr16
        mov cl, dl
        mov ebx, eax
.1:
        xor eax, eax
        mov edx, 42h
        mov ax, word [GusRegSelectPort]
        shr ebx, 4
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataLowPort]
        mov dx, bx
        call outpw_
        jmp short .3
.2:
        cmp byte [GusRecordDmaChannel], 4
        jb short .3
        mov eax, ebx
        call GusConvertAddr16
        mov cl, dl
.3:
        or cl, 21h
        mov byte [GusDmaControl], cl
        xor eax, eax
        mov ax, word [byte ebp+08h]
        call GusDmaNextChunk
        lea esp, [byte ebp-04h]
        pop esi
        pop ebp
        ret 4
        db 090h
GusDownload:
        push ebp
        mov ebp, esp
        push esi
        push edi
        sub esp, byte 14h
        mov dword [byte ebp-01Ch], eax
        mov esi, edx
        mov dword [byte ebp-010h], ebx
        mov byte [byte ebp-0Ch], cl
        pushfw
        cli
        call GusEnterCritical
        cmp dword [GusDmaBusy], byte 0
        je short .1
        call GusLeaveCritical
        popfw
        mov eax, 7
        jmp near .9
.1:
        mov dword [GusDmaBusy], 1
        mov eax, dword [byte ebp-01Ch]
        mov eax, dword [byte eax+04h]
        mov edi, dword [byte ebp-01Ch]
        mov dword [byte ebp-014h], eax
        mov ah, byte [byte ebp+08h]
        mov edi, dword [edi]
        test ah, 1
        je near .7
        cmp byte [GusPlayDmaChannel], 4
        jb short .4
        test byte [byte ebp-014h], 1
        je short .4
        test byte [byte ebp-010h], 1
        jne short .4
.2:
        test esi, esi
        je short .3
        mov edx, dword [byte ebp-010h]
        mov eax, edi
        xor ecx, ecx
        mov ebx, esi
        mov cl, byte [byte ebp-0Ch]
        call GusPokeFill
.3:
        mov dx, word [GusIrqFlags]
        or dl, 4
        mov word [GusIrqFlags], dx
        jmp short .8
.4:
        mov eax, dword [byte ebp-010h]
        and al, 1Fh
        xor ah, ah
        test ax, ax
        je short .6
        mov ecx, 20h
        sub ecx, eax
        mov eax, ecx
        xor ecx, ecx
        mov cx, ax
        cmp ecx, esi
        jbe short .5
        mov eax, esi
.5:
        xor ecx, ecx
        mov cl, byte [byte ebp-0Ch]
        and eax, 0FFFFh
        mov dword [byte ebp-018h], eax
        mov edx, dword [byte ebp-010h]
        mov ebx, dword [byte ebp-018h]
        mov eax, edi
        call GusPokeFill
        mov ecx, dword [byte ebp-018h]
        mov edx, dword [byte ebp-014h]
        sub esi, ecx
        add edx, ecx
        add edi, ecx
        mov dword [byte ebp-014h], edx
.6:
        cmp esi, byte 20h
        jb short .2
.7:
        mov ebx, dword [byte ebp-010h]
        xor eax, eax
        mov edx, esi
        mov ax, word [byte ebp+08h]
        xor ecx, ecx
        push eax
        mov cl, byte [byte ebp-0Ch]
        mov eax, dword [byte ebp-014h]
        call GusStartDramDma
.8:
        call GusLeaveCritical
        popfw
        xor eax, eax
.9:
        lea esp, [byte ebp-08h]
        pop edi
        pop esi
        pop ebp
        ret 4
        db 090h
GusDmaNextChunk:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        push esi
        mov edx, eax
        cmp dword [GusDmaBusy], byte 0
        jne short .1
        xor eax, eax
        jmp near .8
.1:
        mov eax, dword [GusDmaChunkSize]
        add dword [GusDmaDone], eax
        mov esi, dword [GusDmaLeft]
        test esi, esi
        jne short .2
        mov dword [GusDmaBusy], esi
        xor eax, eax
        lea esp, [byte ebp-010h]
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
.2:
        xor esi, esi
        mov si, word [GusDmaChunkLo]
        mov eax, 10000h
        sub eax, esi
        mov esi, eax
        cmp esi, dword [GusDmaLeft]
        jbe short .3
        mov esi, dword [GusDmaLeft]
.3:
        mov dword [GusDmaChunkSize], esi
        pushfw
        cli
        test dl, 1
        je short .6
        xor eax, eax
        mov ax, word [GusDmaChunkLo]
        xor ecx, ecx
        mov cx, word [GusDmaChunkHi]
        push eax
        test byte [GusDmaControl], 2
        je short .4
        mov eax, 44h
        jmp short .5
.4:
        mov eax, 48h
.5:
        xor ebx, ebx
        mov bx, ax
        mov edx, dword [GusDmaChunkSize]
        xor eax, eax
        call GusProgramDma
        xor eax, eax
        mov edx, 41h
        jmp short .7
.6:
        xor eax, eax
        mov ax, word [GusDmaChunkLo]
        xor ecx, ecx
        mov cx, word [GusDmaChunkHi]
        push eax
        mov edx, dword [GusDmaChunkSize]
        mov eax, 1
        mov ebx, 44h
        call GusProgramDma
        xor eax, eax
        mov edx, 49h
.7:
        mov ax, word [GusRegSelectPort]
        call outp_
        xor edx, edx
        mov dl, byte [GusDmaControl]
        xor eax, eax
        mov ax, word [GusDataHighPort]
        call outp_
        call GusDelay
        popfw
        sub dword [GusDmaLeft], esi
        add word [GusDmaChunkLo], si
        mov ax, word [GusDmaChunkHi]
        inc word [GusDmaChunkHi]
        mov eax, 1
.8:
        lea esp, [byte ebp-010h]
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
GusDramDmaDone:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        pushfw
        cli
        mov edx, 1D4C0h
.1:
        cmp dword [GusDmaBusy], byte 0
        je short .5
        dec edx
        je short .5
        xor eax, eax
        cli
        mov ax, word [GusIrqStatusPort]
        call inp_
        test al, 80h
        jne short .2
        mov bx, word [GusIrqFlags]
        test bl, 4
        je short .3
.2:
        call GusServiceIrq
        cli
.3:
        mov cx, word [GusIrqFlags]
        test cl, 2
        je short .4
        and word [GusIrqFlags], byte 0FFFDh
        jmp short .2
.4:
        call GusDelay
        jmp short .1
.5:
        popfw
        cmp dword [GusDmaBusy], byte 0
        je short .6
        test edx, edx
        jne short .6
        mov eax, 9
        jmp short .7
.6:
        xor eax, eax
.7:
        lea esp, [byte ebp-0Ch]
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 090h
GusDmaIdle:
        push ebp
        mov ebp, esp
        cmp dword [GusDmaBusy], byte 0
        sete al
        and eax, 0FFh
        mov esp, ebp
        pop ebp
        ret
        db 08Bh,0C0h
GusStopDma:
        push ebp
        mov ebp, esp
        push ebx
        push edx
        pushfw
        cli
        cmp dword [GusDmaBusy], byte 0
        je short .1
        xor ebx, ebx
        mov dword [GusDmaBusy], ebx
        xor eax, eax
        call GusMaskDma
        mov eax, 1
        call GusMaskDma
        and byte [GusDmaControl], 0DEh
        xor eax, eax
        mov edx, 41h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor edx, edx
        mov dl, byte [GusDmaControl]
        xor eax, eax
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 49h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor edx, edx
        mov dl, byte [GusDmaControl]
        xor eax, eax
        mov ax, word [GusDataHighPort]
        call outp_
.1:
        popfw
        lea esp, [byte ebp-08h]
        pop edx
        pop ebx
        pop ebp
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
GusCalcVoiceAddrs:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        mov ebx, eax
        pushfw
        cli
        call GusEnterCritical
        mov ah, byte [byte ebx+048h]
        mov ecx, dword [byte ebx+014h]
        test ah, 1
        je short .1
        mov eax, ecx
        call GusConvertAddr16
        mov edx, eax
        jmp short .2
.1:
        mov edx, ecx
.2:
        mov eax, edx
        xor ah, dh
        shr edx, 7
        and edx, 1FFFh
        mov word [byte ebx+020h], dx
        and al, 7Fh
        mov edx, dword [ebx]
        shl eax, 9
        add ecx, edx
        mov dl, byte [byte ebx+048h]
        mov word [byte ebx+01Eh], ax
        test dl, 1
        je short .3
        mov eax, ecx
        call GusConvertAddr16
        mov edx, eax
        jmp short .4
.3:
        mov edx, ecx
.4:
        mov eax, edx
        and al, 7Fh
        xor ah, dh
        shl eax, 9
        shr edx, 7
        mov word [byte ebx+022h], ax
        and edx, 1FFFh
        mov al, byte [byte ebx+034h]
        xor ah, ah
        mov word [byte ebx+024h], dx
        and al, 0Fh
        mov dx, word [byte ebx+022h]
        shl eax, 5
        or edx, eax
        mov word [byte ebx+022h], dx
        mov ecx, dword [byte ebx+04h]
        mov eax, dword [byte ebx+014h]
        mov dh, byte [byte ebx+048h]
        add eax, ecx
        test dh, 1
        je short .5
        call GusConvertAddr16
.5:
        mov edx, eax
        mov eax, edx
        and al, 7Fh
        xor ah, dh
        shl eax, 9
        mov word [byte ebx+026h], ax
        mov eax, edx
        shr eax, 7
        and eax, 1FFFh
        mov word [byte ebx+028h], ax
        mov al, byte [byte ebx+034h]
        xor ah, ah
        and al, 0F0h
        mov cx, word [byte ebx+026h]
        add eax, eax
        or ecx, eax
        mov word [byte ebx+026h], cx
        mov cl, byte [byte ebx+048h]
        mov eax, dword [byte ebx+014h]
        test cl, 1
        je short .6
        mov edx, dword [byte ebx+030h]
        sub edx, byte 2
        add eax, edx
        call GusConvertAddr16
        mov edx, eax
        jmp short .7
.6:
        add eax, dword [byte ebx+030h]
        lea edx, [byte eax-01h]
.7:
        mov eax, edx
        and al, 7Fh
        xor ah, dh
        shr edx, 7
        shl eax, 9
        and edx, 1FFFh
        mov word [byte ebx+02Ah], ax
        xor eax, eax
        mov word [byte ebx+02Ch], dx
        mov ax, word [GusActiveVoices]
        mov ax, word [nosplit eax*2+GusVoiceRateTable]
        and eax, 0FFFFh
        xor edx, edx
        xor ecx, ecx
        mov dx, word [byte ebx+01Ah]
        shl eax, 9
        sar edx, 1
        mov cx, word [byte ebx+01Ah]
        add eax, edx
        xor edx, edx
        div ecx
        mov word [byte ebx+02Eh], ax
        call GusLeaveCritical
        popfw
        xor eax, eax
        lea esp, [byte ebp-0Ch]
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 00h
GusClearIrqState:
        mov word [GusIrqPending], 0
        mov word [GusCriticalDepth], 0
        ret
GusEnterCritical:
        inc word [GusCriticalDepth]
        ret
GusTryEnterCritical:
        pushfw
        cli
        cmp word [GusCriticalDepth], byte 0
        jne short .1
        call GusEnterCritical
        mov eax, 1
        jmp short .2
.1:
        LD xor, eax, eax
.2:
        popfw
        ret
        ret
GusLeaveCritical:
        pushfw
        cli
        dec word [GusCriticalDepth]
        cmp word [GusCriticalDepth], byte 0
        jne short .2
        nop
        nop
        nop
        nop
.1:
        test byte [GusIrqFlags], 6
        je short .2
        nop
        nop
        nop
        nop
        and byte [GusIrqFlags], 0FDh
        call GusServiceIrq
        jmp short .1
.2:
        popfw
        ret
