; The Gravis Ultrasound SDK.
bits 32
%include "hockey.inc"
section s_AA210 progbits alloc exec nowrite align=1
extern str_GF1PATCH110, str_110, GusIrqLatchBits, GusVolumeCurve, GusMidiReady, GusDmaLatchBits, GusMidiInitFlag, GusDramSized
extern GusMidiVoices, GusMidiVoiceNote, GusMidiVoiceVelocity
extern GusWaveVoiceFlags, GusPlayDmaChannel, GusIrqLatch, GusRecordDmaChannel, GusMidiIrq, GusWaveIrq, GusOpenCount, GusPitchTable
extern GusNoteFreqTable, GusNoteFreqUpper, GusFreqDivisor, inp_, inpw_
extern outp_, outpw_, strcmp_, strncmp_, GusProbePort, GusDosRead, GusDosClose, GusDosSeek
extern GusDosOpen, GusHookIrq, GusUnhookIrq, GusDownload, GusDramDmaDone, GusCalcVoiceAddrs, GusClearIrqState, GusEnterCritical
extern GusLeaveCritical, GusWaveIrqHandler, GusMidiIrqHandler, GusDelay, GusSetBasePort, GusClearCallbacks, GusClaimVoiceCallbacks, GusClaimTimerCallbacks
extern GusRunInitTable, GusStartTimer2, GusStopTimer2, GusAllocVoice, GusReleaseVoice, GusAddVoicePriority, GusPeek, GusPoke
extern GusTestDramBank, GusWaveVoices, GusBasePort, GusIrqStatusPort, GusIrqLatchPort, GusDmaLatchPort, GusVoiceSelectPort, GusRegSelectPort
extern GusDataLowPort, GusDataHighPort, GusDramSize, GusDosResult
extern GusIrqFlags, GusActiveVoices
global GusReadPatchHeader, GusLoadPatch, GusUnloadPatch, GusSetPatchFlags, GusStopDmaAndTimers, GusUnhookIrqs, GusHookIrqs, GusOpenCard
global GusStopAllVoices, GusOpen, GusClose, GusSetIrqDmaLatches, GusResetVoices, GusMidiInit, GusVoiceUpdateVolume, GusSetChannelVolume
global GusSetChannelBend, GusSetMasterVolume, GusSetChannelModulation, GusVibratoJumpTable, GusVibratoTick, GusStartVibratoTimer, GusStopVibratoTimer, GusVoiceSetVibrato
global GusVoiceSetEnvelope, GusScaleRatio, GusNoteFrequency, GusVoiceStopRamp, GusVoiceStopWave, GusStopNoteVoices, GusMidiNoteOn, GusMidiNoteOff
global GusSetSustain, GusVoiceWaveEnd, GusVoiceRampEnd, GusStopPatchVoices, GusForgetPatch, GusSetChannelPatch, GusSetChannelPan, GusChannelNotesOff
global GusPokeBlock, GusPeekBlock, GusSizeDram, GusDramAlloc, GusDramFree, GusDramFreeTotal, GusDramLargestFree, GusMixAdd8
global GusClearMixBuffer
GusReadPatchHeader:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push esi
        mov esi, edx
        call GusDosOpen
        mov ecx, eax
        test eax, eax
        jge short .1
        mov edx, eax
        mov word [GusDosResult], ax
        neg edx
        mov eax, 10h
        mov word [GusDosResult], dx
        jmp near .7
.1:
        cmp eax, byte 0FFFFFFFFh
        jne short .2
        mov eax, 11h
        lea esp, [byte ebp-0Ch]
        pop esi
        pop ecx
        pop ebx
        pop ebp
        ret
.2:
        mov ebx, 81h
        call GusDosRead
        cmp ax, 81h
        je short .3
        mov eax, ecx
        call GusDosClose
        mov eax, 0Eh
        lea esp, [byte ebp-0Ch]
        pop esi
        pop ecx
        pop ebx
        pop ebp
        ret
.3:
        mov edx, str_GF1PATCH110
        mov ebx, 8
        mov eax, esi
        call strncmp_
        test eax, eax
        je short .4
        mov eax, ecx
        call GusDosClose
        mov eax, 0Eh
        lea esp, [byte ebp-0Ch]
        pop esi
        pop ecx
        pop ebx
        pop ebp
        ret
.4:
        mov edx, str_110
        lea eax, [byte esi+08h]
        call strcmp_
        test eax, eax
        jge short .5
        mov eax, ecx
        call GusDosClose
        mov eax, 0Fh
        lea esp, [byte ebp-0Ch]
        pop esi
        pop ecx
        pop ebx
        pop ebp
        ret
.5:
        mov ebx, 3Fh
        lea edx, [dword esi+081h]
        mov eax, ecx
        call GusDosRead
        cmp ax, 3Fh
        je short .6
        mov eax, ecx
        call GusDosClose
        mov eax, 0Eh
        lea esp, [byte ebp-0Ch]
        pop esi
        pop ecx
        pop ebx
        pop ebp
        ret
.6:
        mov eax, ecx
        call GusDosClose
        xor eax, eax
.7:
        lea esp, [byte ebp-0Ch]
        pop esi
        pop ecx
        pop ebx
        pop ebp
        ret
        db 090h
GusLoadPatch:
        push ebp
        mov ebp, esp
        push esi
        push edi
        sub esp, 0BCh
        mov esi, eax
        mov dword [byte ebp-024h], ebx
        mov dword [byte ebp-018h], ecx
        mov eax, dword [byte ebp+0Ch]
        xor ebx, ebx
        cmp bx, word [byte edx+055h]
        jb short .1
        xor eax, eax
        jmp short .3
.1:
        add eax, byte 49h
        inc ebx
        mov dword [byte eax-035h], 0
        cmp bx, word [byte edx+055h]
        jb short .1
        xor eax, eax
        jmp short .3
.2:
        mov ecx, dword [byte ebp-024h]
        lea ebx, [nosplit eax*4+00h]
        add ebx, ecx
        inc eax
        mov dword [byte ebx+02h], 0
.3:
        xor ebx, ebx
        mov bl, byte [dword edx+097h]
        cmp eax, ebx
        jb short .2
        mov eax, dword [byte ebp-024h]
        mov word [byte eax+01Ah], 400h
        mov eax, esi
        mov dword [byte ebp-01Ch], ebx
        call GusDosOpen
        mov esi, eax
        mov edi, eax
        test eax, eax
        jge short .4
        mov word [GusDosResult], ax
        neg esi
        mov eax, 10h
        mov word [GusDosResult], si
        jmp near .33
.4:
        cmp eax, byte 0FFFFFFFFh
        jne short .5
        mov eax, 11h
        lea esp, [byte ebp-08h]
        pop edi
        pop esi
        pop ebp
        ret 0Ch
.5:
        mov edx, 0C0h
        xor ebx, ebx
        call GusDosSeek
        xor edx, edx
        mov dx, ax
        test edx, edx
        je short .6
        mov eax, esi
        call GusDosClose
        mov eax, edx
        lea esp, [byte ebp-08h]
        pop edi
        pop esi
        pop ebp
        ret 0Ch
.6:
        mov dword [byte ebp-034h], edx
        mov dword [byte ebp-014h], edx
        jmp near .32
.7:
        lea edx, [byte ebp-064h]
        mov ebx, 2Fh
        mov eax, edi
        call GusDosRead
        and eax, 0FFFFh
        cmp eax, byte 2Fh
        je short .8
        mov eax, edi
        call GusDosClose
        mov eax, dword [byte ebp-024h]
        call GusUnloadPatch
        mov eax, 0Eh
        lea esp, [byte ebp-08h]
        pop edi
        pop esi
        pop ebp
        ret 0Ch
.8:
        mov esi, dword [byte ebp-014h]
        mov edx, dword [byte ebp-024h]
        add esi, esi
        mov ah, byte [byte ebp-064h]
        add esi, edx
        test ah, ah
        je short .9
        mov edx, dword [byte ebp-034h]
        dec edx
        lea eax, [nosplit edx*8+00h]
        add eax, edx
        shl eax, 3
        add eax, edx
        mov edx, dword [byte ebp-014h]
        mov ecx, dword [byte ebp-024h]
        shl edx, 2
        mov ebx, dword [byte ebp+0Ch]
        add edx, ecx
        add eax, ebx
        mov dword [byte edx+02h], eax
        mov ax, word [byte esi+010h]
        mov word [byte esi+012h], ax
        jmp near .31
.9:
        mov al, byte [byte ebp-05Eh]
        mov word [byte esi+012h], ax
        xor al, al
        mov esi, dword [byte ebp+0Ch]
        mov dword [byte ebp-010h], eax
        jmp near .30
.10:
        lea edx, [dword ebp-0C4h]
        mov ebx, 60h
        mov eax, edi
        call GusDosRead
        and eax, 0FFFFh
        cmp eax, byte 60h
        je short .11
        mov eax, edi
        call GusDosClose
        mov eax, dword [byte ebp-024h]
        call GusUnloadPatch
        mov eax, 0Eh
        lea esp, [byte ebp-08h]
        pop edi
        pop esi
        pop ebp
        ret 0Ch
.11:
        cmp word [byte ebp-010h], byte 0
        jne short .12
        mov eax, dword [byte ebp-014h]
        mov edx, dword [byte ebp-024h]
        shl eax, 2
        add eax, edx
        mov dword [byte eax+02h], esi
.12:
        mov eax, dword [dword ebp-0B8h]
        mov dword [esi], eax
        mov eax, dword [dword ebp-0B4h]
        mov dword [byte esi+04h], eax
        mov al, byte [dword ebp-0BDh]
        mov byte [byte esi+034h], al
        mov eax, dword [dword ebp-0AEh]
        mov dword [byte esi+08h], eax
        mov eax, dword [dword ebp-0AAh]
        mov dword [byte esi+0Ch], eax
        mov eax, dword [dword ebp-0A6h]
        mov dword [byte esi+010h], eax
        mov al, byte [dword ebp-0A0h]
        mov byte [byte esi+035h], al
        mov eax, dword [dword ebp-08Ch]
        mov word [byte esi+018h], ax
        mov eax, dword [dword ebp-08Ah]
        mov word [byte esi+01Ch], ax
        mov al, byte [dword ebp-093h]
        mov byte [byte esi+042h], al
        mov al, byte [dword ebp-092h]
        mov byte [byte esi+043h], al
        mov al, byte [dword ebp-091h]
        mov byte [byte esi+044h], al
        mov al, byte [dword ebp-090h]
        mov byte [byte esi+045h], al
        mov al, byte [dword ebp-08Fh]
        mov byte [byte esi+046h], al
        mov al, byte [dword ebp-08Eh]
        mov byte [byte esi+047h], al
        mov al, byte [dword ebp-08Dh]
        mov byte [byte esi+048h], al
        mov eax, dword [dword ebp-0B0h]
        mov word [byte esi+01Ah], ax
        mov eax, dword [dword ebp-0BCh]
        mov dword [byte esi+030h], eax
        xor eax, eax
        jmp short .14
.13:
        inc eax
        mov bl, byte [dword eax+ebp-0A0h]
        mov byte [byte esi+eax+035h], bl
        mov bl, byte [dword eax+ebp-09Ah]
        mov byte [byte esi+eax+03Bh], bl
.14:
        cmp eax, byte 6
        jb short .13
        mov eax, dword [byte esi+030h]
        mov dl, byte [byte ebp+010h]
        mov dword [byte ebp-028h], eax
        test dl, 1
        je short .15
        test byte [byte esi+048h], 1
        je short .15
        shr eax, 1
        jmp short .16
.15:
        mov eax, dword [byte ebp-028h]
.16:
        call GusDramAlloc
        mov dword [byte ebp-02Ch], eax
        mov ebx, dword [byte ebp-02Ch]
        test ebx, ebx
        jne short .17
        mov eax, edi
        call GusDosClose
        mov eax, dword [byte ebp-024h]
        call GusUnloadPatch
        mov eax, 6
        lea esp, [byte ebp-08h]
        pop edi
        pop esi
        pop ebp
        ret 0Ch
.17:
        mov dword [byte esi+014h], ebx
.18:
        mov ecx, dword [byte ebp-028h]
        test ecx, ecx
        je near .28
        xor eax, eax
        mov ax, word [byte ebp+08h]
        cmp eax, ecx
        jbe short .19
        mov eax, ecx
.19:
        xor ecx, ecx
        mov ebx, dword [byte ebp-028h]
        mov cx, ax
        mov edx, dword [byte ebp-018h]
        sub ebx, ecx
        mov dword [byte ebp-0Ch], eax
        mov dword [byte ebp-028h], ebx
        xor ebx, ebx
        mov edx, dword [edx]
        mov bx, ax
        mov eax, edi
        call GusDosRead
        and eax, 0FFFFh
        cmp eax, ecx
        je short .20
        mov eax, edi
        call GusDosClose
        mov eax, dword [byte ebp-024h]
        call GusUnloadPatch
        mov eax, 0Eh
        lea esp, [byte ebp-08h]
        pop edi
        pop esi
        pop ebp
        ret 0Ch
.20:
        test byte [byte ebp+010h], 1
        je short .23
        test byte [byte esi+048h], 1
        je short .23
        mov eax, 1
        xor edx, edx
        jmp short .22
.21:
        mov ebx, dword [byte ebp-018h]
        mov ebx, dword [ebx]
        lea ecx, [ebx+eax]
        add ebx, edx
        mov dword [byte ebp-030h], ebx
        mov bl, byte [ecx]
        mov ecx, dword [byte ebp-030h]
        add eax, byte 2
        inc edx
        mov byte [ecx], bl
.22:
        xor ebx, ebx
        mov bx, word [byte ebp-0Ch]
        cmp eax, ebx
        jb short .21
        shr bx, 1
        mov dword [byte ebp-0Ch], ebx
.23:
        call GusDramDmaDone
        mov edx, eax
        test eax, eax
        jne short .26
        mov cl, byte [byte ebp+010h]
        xor al, al
        test cl, 1
        jne short .24
        test byte [byte esi+048h], 1
        je short .24
        mov al, 40h
.24:
        test byte [byte esi+048h], 2
        je short .25
        or al, 80h
.25:
        xor ecx, ecx
        mov cl, al
        xor eax, eax
        push byte 1
        mov ax, word [byte ebp-0Ch]
        mov ebx, dword [byte ebp-02Ch]
        mov dword [byte ebp-020h], eax
        mov eax, dword [byte ebp-018h]
        mov edx, dword [byte ebp-020h]
        call GusDownload
        mov edx, eax
        test eax, eax
        je short .27
.26:
        mov eax, edi
        call GusDosClose
        mov eax, dword [byte ebp-024h]
        call GusUnloadPatch
        mov eax, edx
        lea esp, [byte ebp-08h]
        pop edi
        pop esi
        pop ebp
        ret 0Ch
.27:
        call GusDramDmaDone
        mov edx, eax
        test eax, eax
        jne short .26
        mov eax, dword [byte ebp-020h]
        add dword [byte ebp-02Ch], eax
        jmp near .18
.28:
        test byte [byte ebp+010h], 1
        je short .29
        test byte [byte esi+048h], 1
        je short .29
        mov eax, dword [esi]
        shr eax, 1
        mov ebx, dword [byte esi+030h]
        mov dword [esi], eax
        shr ebx, 1
        mov edx, dword [byte esi+04h]
        mov dword [byte esi+030h], ebx
        shr edx, 1
        mov bl, byte [byte esi+048h]
        mov dword [byte esi+04h], edx
        and bl, 0FEh
        mov byte [byte esi+048h], bl
.29:
        mov ecx, dword [byte ebp-010h]
        inc ecx
        mov eax, esi
        mov dword [byte ebp-010h], ecx
        mov ecx, dword [byte ebp-034h]
        call GusCalcVoiceAddrs
        inc ecx
        add esi, byte 49h
        mov dword [byte ebp-034h], ecx
.30:
        mov al, byte [byte ebp-05Eh]
        mov edx, dword [byte ebp-010h]
        xor ah, ah
        cmp ax, dx
        ja near .10
.31:
        mov esi, dword [byte ebp-014h]
        mov eax, dword [byte ebp-034h]
        inc esi
        inc eax
        mov dword [byte ebp-014h], esi
        mov dword [byte ebp-034h], eax
.32:
        mov eax, dword [byte ebp-014h]
        cmp eax, dword [byte ebp-01Ch]
        jb near .7
        mov eax, edi
        mov edx, dword [byte ebp-024h]
        call GusDosClose
        mov eax, dword [byte ebp-01Ch]
        mov word [edx], ax
        xor eax, eax
.33:
        lea esp, [byte ebp-08h]
        pop edi
        pop esi
        pop ebp
        ret 0Ch
        db 08Dh,040h,00h
GusUnloadPatch:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov edx, eax
        pushfw
        cli
        call GusEnterCritical
        mov eax, edx
        call GusStopPatchVoices
        xor ecx, ecx
        jmp short .5
.1:
        mov ebx, dword [byte edx+ecx*4+02h]
        xor esi, esi
        jmp short .4
.2:
        mov edi, dword [byte ebx+014h]
        test edi, edi
        je short .3
        mov eax, edi
        call GusDramFree
        mov dword [byte ebx+014h], 0
.3:
        inc esi
        add ebx, byte 49h
.4:
        mov eax, dword [byte edx+ecx*2+010h]
        sar eax, 10h
        cmp esi, eax
        jl short .2
        inc ecx
.5:
        mov eax, dword [byte edx-02h]
        sar eax, 10h
        cmp ecx, eax
        jl short .1
        mov eax, edx
        mov word [edx], 0
        call GusForgetPatch
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-014h]
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Dh,040h,00h
GusSetPatchFlags:
        push ebp
        mov ebp, esp
        mov word [byte eax+01Ah], dx
        mov esp, ebp
        pop ebp
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h
GusStopDmaAndTimers:
        push ebp
        mov ebp, esp
        push edx
        xor eax, eax
        mov edx, 41h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 45h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 49h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov ax, word [GusIrqStatusPort]
        call inp_
        xor eax, eax
        mov edx, 41h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov ax, word [GusDataHighPort]
        call inp_
        xor eax, eax
        mov edx, 49h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov ax, word [GusDataHighPort]
        call inp_
        xor eax, eax
        mov edx, 8Fh
        mov ax, word [GusRegSelectPort]
        call outp_
        xor edx, edx
.1:
        xor eax, eax
        mov ax, word [GusDataHighPort]
        inc edx
        call inp_
        cmp edx, byte 20h
        jl short .1
        lea esp, [byte ebp-04h]
        pop edx
        pop ebp
        ret
        db 090h
GusUnhookIrqs:
        push ebp
        mov ebp, esp
        push ebx
        mov ebx, eax
        mov eax, edx
        cmp ebx, edx
        je short .1
        call GusUnhookIrq
.1:
        mov eax, ebx
        call GusUnhookIrq
        lea esp, [byte ebp-04h]
        pop ebx
        pop ebp
        ret
        db 08Bh,0C0h
GusHookIrqs:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push esi
        mov esi, eax
        mov ebx, GusWaveIrqHandler
        mov ecx, cs
        call GusHookIrq
        cmp esi, edx
        je short .1
        mov ebx, GusMidiIrqHandler
        mov eax, edx
        mov ecx, cs
        call GusHookIrq
.1:
        lea esp, [byte ebp-0Ch]
        pop esi
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Bh,0C0h
GusOpenCard:
        push ebp
        mov ebp, esp
        push esi
        sub esp, byte 4
        mov esi, eax
        mov byte [byte ebp-08h], dl
        mov bh, cl
        mov ecx, dword [byte ebp+0Ch]
        pushfw
        cli
        mov eax, esi
        call GusSetBasePort
        mov edx, eax
        test eax, eax
        je short .1
        popfw
        mov eax, edx
        jmp near .4
.1:
        call GusClearIrqState
        call GusClearCallbacks
        xor eax, eax
        mov al, byte [byte ebp-08h]
        cmp byte [dword eax+GusIrqLatchBits], 0
        jne short .2
        popfw
        mov eax, 2
        lea esp, [byte ebp-04h]
        pop esi
        pop ebp
        ret 8
.2:
        mov byte [GusWaveIrq], al
        xor eax, eax
        mov al, bl
        cmp byte [dword eax+GusIrqLatchBits], 0
        jne short .3
        popfw
        mov eax, 2
        lea esp, [byte ebp-04h]
        pop esi
        pop ebp
        ret 8
.3:
        mov byte [GusMidiIrq], bl
        mov al, byte [byte ebp+08h]
        mov byte [GusPlayDmaChannel], bh
        mov byte [GusRecordDmaChannel], al
        mov eax, ecx
        xor edx, edx
        call GusResetVoices
        mov dl, byte [GusMidiIrq]
        xor eax, eax
        mov al, byte [GusWaveIrq]
        call GusHookIrqs
        popfw
        xor eax, eax
.4:
        lea esp, [byte ebp-04h]
        pop esi
        pop ebp
        ret 8
        db 08Dh,040h,00h
GusStopAllVoices:
        push ebp
        mov ebp, esp
        push ebx
        push edx
        pushfw
        cli
        call GusEnterCritical
        xor ebx, ebx
        cmp bx, word [GusActiveVoices]
        jb short .1
        xor ebx, ebx
        jmp near .5
.1:
        xor eax, eax
        xor edx, edx
        mov ax, word [GusVoiceSelectPort]
        mov dx, bx
        call outp_
        xor eax, eax
        mov edx, 0Dh
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        call GusDelay
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        call GusDelay
        xor eax, eax
        mov edx, 89h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov ax, word [GusDataLowPort]
        call inpw_
        shr eax, 8
        cmp eax, byte 5
        jbe short .2
        xor eax, eax
        mov edx, 7
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 5
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 6
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 1
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 0Dh
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 40h
        mov ax, word [GusDataHighPort]
        call outp_
.2:
        inc ebx
        cmp bx, word [GusActiveVoices]
        jb near .1
        xor ebx, ebx
        jmp short .5
.3:
        xor eax, eax
        xor edx, edx
        mov ax, word [GusVoiceSelectPort]
        mov dx, bx
        call outp_
.4:
        xor eax, eax
        mov edx, 8Dh
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov ax, word [GusDataHighPort]
        call inp_
        test al, 3
        je short .4
        xor eax, eax
        xor edx, edx
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        call GusDelay
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        inc ebx
        call outp_
.5:
        cmp bx, word [GusActiveVoices]
        jb short .3
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-08h]
        pop edx
        pop ebx
        pop ebp
        ret
        db 090h
GusOpen:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        push esi
        mov esi, eax
        mov edx, dword [GusOpenCount]
        test edx, edx
        je short .1
        lea ebx, [byte edx+01h]
        xor eax, eax
        mov dword [GusOpenCount], ebx
        jmp near .4
.1:
        xor edx, edx
        mov word [GusIrqFlags], dx
        pushfw
        cli
        xor eax, eax
        mov ax, word [byte esi+02h]
        call GusProbePort
        test eax, eax
        jne short .2
        popfw
        mov eax, 0Ah
        lea esp, [byte ebp-010h]
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
.2:
        mov byte [GusIrqLatch], 3
        xor edx, edx
        mov dl, byte [GusIrqLatch]
        xor eax, eax
        mov ax, word [byte esi+02h]
        xor ecx, ecx
        call outp_
        xor eax, eax
        xor ebx, ebx
        mov ax, word [esi]
        mov cl, byte [byte esi+07h]
        push eax
        xor eax, eax
        mov bl, byte [byte esi+05h]
        mov al, byte [byte esi+06h]
        xor edx, edx
        push eax
        xor eax, eax
        mov dl, byte [byte esi+04h]
        mov ax, word [byte esi+02h]
        call GusOpenCard
        mov edx, eax
        test eax, eax
        je short .3
        popfw
        mov eax, edx
        lea esp, [byte ebp-010h]
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
.3:
        call GusSetIrqDmaLatches
        mov bx, word [GusIrqFlags]
        or bl, 1
        mov word [GusIrqFlags], bx
        inc dword [GusOpenCount]
        popfw
        call GusRunInitTable
        test eax, eax
        jne short .4
        and byte [GusIrqLatch], 0FDh
        xor edx, edx
        mov dl, byte [GusIrqLatch]
        mov ax, word [byte esi+02h]
        call outp_
        xor eax, eax
.4:
        lea esp, [byte ebp-010h]
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 090h
GusClose:
        push ebp
        mov ebp, esp
        push ebx
        push edx
        mov dx, word [GusIrqFlags]
        test dl, 1
        jne short .1
        mov eax, 5
        jmp short .3
.1:
        mov edx, dword [GusOpenCount]
        dec edx
        mov dword [GusOpenCount], edx
        jne short .2
        pushfw
        cli
        call GusStopAllVoices
        call GusStopDmaAndTimers
        mov dl, byte [GusMidiIrq]
        xor eax, eax
        mov al, byte [GusWaveIrq]
        call GusUnhookIrqs
        popfw
        mov bx, word [GusIrqFlags]
        and bl, 0FEh
        mov word [GusIrqFlags], bx
.2:
        xor eax, eax
.3:
        lea esp, [byte ebp-08h]
        pop edx
        pop ebx
        pop ebp
        ret
        db 08Bh,0C0h
GusSetIrqDmaLatches:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        xor eax, eax
        mov al, byte [GusWaveIrq]
        mov bl, byte [dword eax+GusIrqLatchBits]
        mov al, byte [GusWaveIrq]
        cmp al, byte [GusMidiIrq]
        jne short .1
        or bl, 40h
        jmp short .2
.1:
        xor eax, eax
        mov al, byte [GusMidiIrq]
        mov al, byte [dword eax+GusIrqLatchBits]
        shl al, 3
        or bl, al
.2:
        xor eax, eax
        mov al, byte [GusPlayDmaChannel]
        mov dl, byte [GusRecordDmaChannel]
        mov cl, byte [dword eax+GusDmaLatchBits]
        cmp al, dl
        jne short .3
        or cl, 40h
        jmp short .4
.3:
        xor eax, eax
        mov al, dl
        mov al, byte [dword eax+GusDmaLatchBits]
        shl al, 3
        or cl, al
.4:
        pushfw
        cli
        xor eax, eax
        mov edx, 5
        mov ax, word [GusDmaLatchPort]
        call outp_
        xor edx, edx
        mov dl, byte [GusIrqLatch]
        xor eax, eax
        mov ax, word [GusBasePort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusIrqLatchPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDmaLatchPort]
        call outp_
        xor edx, edx
        mov dl, byte [GusIrqLatch]
        xor eax, eax
        mov ax, word [GusBasePort]
        call outp_
        mov al, cl
        xor edx, edx
        or al, 80h
        mov dl, al
        xor eax, eax
        mov ax, word [GusIrqLatchPort]
        call outp_
        mov al, byte [GusIrqLatch]
        or al, 40h
        xor edx, edx
        mov dl, al
        xor eax, eax
        mov ax, word [GusBasePort]
        call outp_
        xor eax, eax
        and ebx, 0FFh
        mov ax, word [GusIrqLatchPort]
        mov edx, ebx
        call outp_
        xor edx, edx
        mov dl, byte [GusIrqLatch]
        xor eax, eax
        mov ax, word [GusBasePort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusIrqLatchPort]
        mov dl, cl
        call outp_
        mov al, byte [GusIrqLatch]
        or al, 40h
        xor edx, edx
        mov dl, al
        xor eax, eax
        mov ax, word [GusBasePort]
        call outp_
        xor eax, eax
        mov edx, ebx
        mov ax, word [GusIrqLatchPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDmaLatchPort]
        call outp_
        or byte [GusIrqLatch], 8
        xor edx, edx
        mov dl, byte [GusIrqLatch]
        xor eax, eax
        mov ax, word [GusBasePort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDmaLatchPort]
        call outp_
        popfw
        lea esp, [byte ebp-0Ch]
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Bh,0C0h
GusResetVoices:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        mov ebx, eax
        cmp eax, byte 0Eh
        jge short .1
        mov ebx, 0Eh
.1:
        cmp ebx, byte 20h
        jle short .2
        mov ebx, 20h
.2:
        mov edx, 20h
        pushfw
        cli
        mov word [GusActiveVoices], dx
        xor eax, eax
        mov edx, 4Ch
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        call outp_
        call GusDelay
        call GusDelay
        xor eax, eax
        mov edx, 4Ch
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 1
        mov ax, word [GusDataHighPort]
        call outp_
        call GusDelay
        call GusDelay
        xor eax, eax
        mov edx, 0Eh
        mov ax, word [GusRegSelectPort]
        call outp_
        mov al, byte [GusActiveVoices]
        dec al
        xor edx, edx
        or al, 0C0h
        mov dl, al
        xor eax, eax
        mov ax, word [GusDataHighPort]
        xor ecx, ecx
        call outp_
        call GusStopDmaAndTimers
        jmp near .4
.3:
        xor eax, eax
        xor edx, edx
        mov ax, word [GusVoiceSelectPort]
        mov dx, cx
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 0Dh
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        call GusDelay
        xor eax, eax
        xor edx, edx
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 0Dh
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 2
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataLowPort]
        call outpw_
        xor eax, eax
        mov edx, 3
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataLowPort]
        call outpw_
        xor eax, eax
        mov edx, 4
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataLowPort]
        call outpw_
        xor eax, eax
        mov edx, 5
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataLowPort]
        call outpw_
        xor eax, eax
        mov edx, 6
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 3Fh
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 7
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 5
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 8
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 0FBh
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 9
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 500h
        mov ax, word [GusDataLowPort]
        call outpw_
        xor eax, eax
        mov edx, 0Ah
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataLowPort]
        call outpw_
        xor eax, eax
        mov edx, 0Bh
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 6000h
        mov ax, word [GusDataLowPort]
        inc ecx
        call outpw_
.4:
        cmp cx, word [GusActiveVoices]
        jb near .3
        call GusStopDmaAndTimers
        mov word [GusActiveVoices], bx
        xor eax, eax
        mov edx, 0Eh
        mov ax, word [GusRegSelectPort]
        call outp_
        mov al, byte [GusActiveVoices]
        dec al
        xor edx, edx
        or al, 0C0h
        mov dl, al
        xor eax, eax
        mov ax, word [GusDataHighPort]
        call outp_
        call GusStopDmaAndTimers
        xor eax, eax
        mov edx, 4Ch
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 7
        mov ax, word [GusDataHighPort]
        call outp_
        call GusDelay
        call GusDelay
        popfw
        lea esp, [byte ebp-0Ch]
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 00h,00h,00h,00h,00h,00h,00h
GusMidiInit:
        push ebp
        mov ebp, esp
        push ebx
        push edx
        mov ah, 1
        xor edx, edx
        mov byte [GusMidiInitFlag], ah
        mov byte [GusMidiReady], ah
        mov eax, GusWaveVoices
        jmp short .2
.1:
        add eax, byte 21h
        mov byte [byte eax-0Eh], 0
        mov byte [byte eax-0Dh], 0
        mov byte [byte eax-0Ch], 40h
        mov byte [byte eax-05h], 7Fh
        mov word [byte eax-010h], 0FFh
        mov byte [byte eax-07h], 1
        inc edx
        mov byte [byte eax-0Bh], 0
.2:
        cmp edx, byte 20h
        jl short .1
        mov eax, GusMidiVoices+080h
        xor edx, edx
        jmp short .4
.3:
        mov byte [eax], 0
        mov byte [byte eax+01h], 64h
        mov word [byte eax+02h], 400h
        mov dword [byte eax+04h], 0
        mov byte [byte eax+09h], 0
        mov byte [byte eax+0Ah], 0
        mov byte [byte eax+0Bh], 0
        mov byte [byte eax+0Ch], 0
        mov byte [byte eax+0Dh], 0
        mov byte [byte eax+0Eh], 0
        inc edx
        mov byte [byte eax+08h], 10h
        add eax, byte 10h
.4:
        cmp edx, byte 20h
        jl short .3
        mov ebx, 7Fh
        xor edx, edx
        mov eax, GusVoiceRampEnd
        mov word [GusMidiVoices+07A2h], dx
        mov word [GusMidiVoices+07A0h], bx
        call GusClaimTimerCallbacks
        test eax, eax
        jne short .5
        mov eax, GusVoiceWaveEnd
        call GusClaimVoiceCallbacks
        test eax, eax
        je short .6
.5:
        mov eax, 8
.6:
        lea esp, [byte ebp-08h]
        pop edx
        pop ebx
        pop ebp
        ret
        db 08Bh,0C0h
GusVoiceUpdateVolume:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 10h
        mov ecx, eax
        pushfw
        cli
        mov ebx, ecx
        call GusEnterCritical
        mov eax, ebx
        shl eax, 5
        add eax, ebx
        mov ebx, GusWaveVoices
        add ebx, eax
        cmp byte [GusMidiReady], 0
        je short .1
        xor eax, eax
        mov al, byte [byte ebx+01Ch]
        movzx esi, byte [dword eax+GusVolumeCurve]
        mov eax, dword [GusMidiVoices+07A0h-2]
        sar eax, 10h
        add eax, byte 40h
        imul eax, esi
        mov dl, byte [dword edx+GusVolumeCurve]
        and edx, 0FFh
        jmp short .2
.1:
        xor eax, eax
        mov esi, dword [GusMidiVoices+07A0h-2]
        mov al, byte [byte ebx+01Ch]
        sar esi, 10h
        add eax, 80h
        add esi, byte 40h
        imul eax, esi
        add edx, 80h
.2:
        imul edx, eax
        mov esi, 0BE41h
        mov eax, edx
        sar edx, 1Fh
        idiv esi
        mov word [byte ebx+011h], ax
        mov eax, dword [ebx]
        cmp byte [byte eax+044h], 0
        jne short .3
        xor eax, eax
        mov al, byte [byte ebx+01Dh]
        shl eax, 4
        cmp byte [dword eax+GusMidiVoices+08Ch], 0
        je short .4
.3:
        xor edx, edx
        mov eax, ecx
        mov dl, byte [byte ebx+01Dh]
        call GusVoiceSetEnvelope
.4:
        xor eax, eax
        mov edx, ecx
        mov ax, word [GusVoiceSelectPort]
        call outp_
        mov edx, 0Dh
        mov cl, byte [byte ebx+015h]
        xor eax, eax
        and cl, 47h
        mov ax, word [GusRegSelectPort]
        mov byte [byte ebx+015h], cl
        call outp_
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        call GusDelay
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 89h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov ax, word [GusDataLowPort]
        call inpw_
        sar eax, 4
        movzx esi, byte [byte ebx+01Bh]
        mov ch, byte [byte ebx+016h]
        mov dword [byte ebp-01Ch], eax
        test ch, ch
        jne near .9
        mov al, byte [byte ebx+01Fh]
        cmp al, byte [byte ebx+020h]
        je short .7
        cmp esi, byte 3
        jne short .5
        mov eax, dword [ebx]
        test byte [byte eax+048h], 20h
        je short .5
        test byte [byte ebx+013h], 2
        jne short .7
.5:
        xor edx, edx
        xor eax, eax
        mov dl, byte [byte ebx+01Fh]
        mov al, byte [byte ebx+020h]
        mov ecx, edx
        mov edx, dword [byte ebp-01Ch]
        sub ecx, eax
        shl eax, 4
        sub edx, eax
        shl edx, 0Ah
        shl ecx, 4
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov dword [byte ebx+04h], eax
        test eax, eax
        jge short .6
        imul eax, byte 0FFFFFFFFh
        mov dword [byte ebx+04h], eax
        jmp short .8
.6:
        jne short .8
.7:
        mov dword [byte ebx+04h], 400h
.8:
        cmp dword [byte ebx+04h], 400h
        jle short .9
        mov dword [byte ebx+04h], 400h
.9:
        test esi, esi
        jne short .10
        mov eax, dword [ebx]
        mov dword [byte ebp-014h], esi
        xor edx, edx
        mov al, byte [byte eax+03Ch]
        and eax, 0FFh
        mov dx, word [byte ebx+011h]
        imul eax, edx
        mov ecx, 0FFh
        xor edx, edx
        div ecx
        mov ecx, eax
        jmp near .16
.10:
        cmp esi, byte 6
        jl short .11
        mov edx, dword [ebx]
        mov dl, byte [byte edx+041h]
        xor eax, eax
        and edx, 0FFh
        mov ax, word [byte ebx+011h]
        imul eax, edx
        mov ecx, 0FFh
        xor edx, edx
        div ecx
        mov ecx, eax
        jmp near .15
.11:
        cmp esi, byte 3
        jne short .13
        mov eax, dword [ebx]
        test byte [byte eax+048h], 20h
        je short .13
        test byte [byte ebx+013h], 2
        je short .12
        xor edx, edx
        xor eax, eax
        mov dl, byte [byte ebx+01Eh]
        mov ax, word [byte ebx+011h]
        imul eax, edx
        mov ecx, 0FFh
        xor edx, edx
        div ecx
        mov dword [byte ebp-014h], eax
        mov ecx, eax
        jmp short .16
.12:
        mov al, byte [byte esi+eax+03Ch]
        xor edi, edi
        and eax, 0FFh
        mov di, word [byte ebx+011h]
        imul eax, edi
        mov ecx, 0FFh
        xor edx, edx
        div ecx
        mov ecx, eax
        xor eax, eax
        mov al, byte [byte ebx+01Eh]
        jmp short .14
.13:
        mov eax, dword [ebx]
        add eax, esi
        mov dword [byte ebp-020h], eax
        xor edi, edi
        mov edx, dword [byte ebp-020h]
        xor eax, eax
        mov di, word [byte ebx+011h]
        mov al, byte [byte edx+03Ch]
        imul eax, edi
        mov ecx, 0FFh
        xor edx, edx
        div ecx
        mov edx, dword [byte ebp-020h]
        mov ecx, eax
        xor eax, eax
        mov al, byte [byte edx+03Bh]
.14:
        imul eax, edi
        xor edx, edx
        mov edi, 0FFh
        div edi
.15:
        mov dword [byte ebp-014h], eax
.16:
        cmp ecx, byte 5
        jae short .17
        mov ecx, 5
.17:
        cmp dword [byte ebp-014h], byte 5
        jae short .18
        mov dword [byte ebp-014h], 5
.18:
        mov edi, dword [byte ebp-014h]
        mov edx, ecx
        mov eax, dword [byte ebx+04h]
        sub edx, edi
        imul edx, eax
        add edx, 200h
        mov eax, edx
        sar edx, 1Fh
        shl edx, 0Ah
        LD sbb, eax, edx
        sar eax, 0Ah
        lea edx, [edi+eax]
        mov dword [byte ebp-018h], edx
        cmp edx, 0FBh
        jbe short .19
        mov dword [byte ebp-018h], 0FBh
        jmp short .20
.19:
        cmp edx, byte 5
        jae short .20
        mov dword [byte ebp-018h], 5
.20:
        mov edi, dword [byte ebp-01Ch]
        shr edi, 4
        mov eax, dword [byte ebp-018h]
        mov dword [byte ebp-01Ch], edi
        cmp eax, edi
        jae short .21
        or byte [byte ebx+015h], 40h
        xor eax, eax
        mov edx, 7
        mov ax, word [GusRegSelectPort]
        call outp_
        xor edx, edx
        xor eax, eax
        mov dl, byte [byte ebp-018h]
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 8
        mov ax, word [GusRegSelectPort]
        call outp_
        xor edx, edx
        xor eax, eax
        mov dl, byte [byte ebp-01Ch]
        jmp short .23
.21:
        jbe short .24
        cmp esi, byte 3
        jle short .22
        mov dword [byte ebp-018h], edi
        jmp short .24
.22:
        and byte [byte ebx+015h], 0BFh
        xor eax, eax
        mov edx, 7
        mov ax, word [GusRegSelectPort]
        call outp_
        xor edx, edx
        xor eax, eax
        mov dl, byte [byte ebp-01Ch]
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 8
        mov ax, word [GusRegSelectPort]
        call outp_
        xor edx, edx
        xor eax, eax
        mov dl, byte [byte ebp-018h]
.23:
        mov ax, word [GusDataHighPort]
        call outp_
.24:
        mov eax, dword [byte ebp-018h]
        cmp eax, dword [byte ebp-01Ch]
        je short .25
        mov al, byte [byte ebp-014h]
        mov byte [byte ebx+020h], al
        xor eax, eax
        mov edx, 6
        mov ax, word [GusRegSelectPort]
        mov byte [byte ebx+01Fh], cl
        call outp_
        xor eax, eax
        mov edx, 43h
        mov ax, word [GusDataHighPort]
        call outp_
.25:
        mov al, byte [byte ebx+01Bh]
        mov dl, byte [byte ebx+015h]
        inc al
        or dl, 20h
        mov byte [byte ebx+016h], al
        mov byte [byte ebx+015h], dl
        xor eax, eax
        mov edx, 0Dh
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ebx+015h]
        call outp_
        call GusDelay
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ebx+015h]
        call outp_
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-010h]
        pop edi
        pop esi
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Dh,040h,00h
GusSetChannelVolume:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push esi
        sub esp, byte 4
        mov dword [byte ebp-010h], eax
        mov ebx, edx
        cmp edx, byte 1
        jae short .1
        mov ebx, 1
        jmp short .2
.1:
        cmp edx, byte 7Fh
        jbe short .2
        mov ebx, 7Fh
.2:
        pushfw
        cli
        mov ecx, dword [byte ebp-010h]
        call GusEnterCritical
        shl ecx, 4
        mov esi, GusWaveVoices
        mov byte [dword ecx+GusMidiVoices+081h], bl
        xor ecx, ecx
        jmp short .5
.3:
        test byte [byte esi+013h], 1
        je short .4
        mov dl, byte [byte ebp-010h]
        cmp dl, byte [byte esi+01Dh]
        jne short .4
        mov eax, ecx
        mov edx, ebx
        call GusVoiceUpdateVolume
.4:
        inc ecx
        add esi, byte 21h
.5:
        xor eax, eax
        mov ax, word [GusActiveVoices]
        cmp ecx, eax
        jb short .3
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-0Ch]
        pop esi
        pop ecx
        pop ebx
        pop ebp
        ret
        db 090h
GusSetChannelBend:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 4
        mov dword [byte ebp-014h], eax
        mov edi, edx
        pushfw
        cli
        call GusEnterCritical
        mov ecx, GusWaveVoices
        xor esi, esi
        jmp near .5
.1:
        test byte [byte ecx+013h], 1
        je short .4
        mov dh, byte [byte ebp-014h]
        cmp dh, byte [byte ecx+01Dh]
        jne short .4
        xor edx, edx
        mov dx, word [byte ecx+08h]
        imul edx, edi
        sar edx, 0Ah
        mov word [byte ecx+0Ah], dx
        mov edx, dword [ecx]
        cmp byte [byte edx+047h], 0
        jne short .2
        cmp byte [dword eax+GusMidiVoices+089h], 0
        je short .3
.2:
        mov edx, 1
        mov ebx, dword [byte ebp-014h]
        mov eax, esi
        call GusVoiceSetVibrato
.3:
        xor eax, eax
        mov edx, esi
        mov ax, word [GusVoiceSelectPort]
        call outp_
        xor eax, eax
        mov edx, 1
        mov ax, word [GusRegSelectPort]
        call outp_
        xor edx, edx
        xor eax, eax
        mov dx, word [byte ecx+0Ah]
        mov ax, word [GusDataLowPort]
        add edx, edx
        call outpw_
.4:
        inc esi
        add ecx, byte 21h
.5:
        xor edx, edx
        mov dx, word [GusActiveVoices]
        mov eax, dword [byte ebp-014h]
        shl eax, 4
        cmp esi, edx
        jb near .1
        mov word [dword eax+GusMidiVoices+082h], di
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-010h]
        pop edi
        pop esi
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Dh,040h,00h
GusSetMasterVolume:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        cmp eax, byte 1
        jge short .1
        mov eax, 1
        jmp short .2
.1:
        cmp eax, byte 7Fh
        jle short .2
        mov eax, 7Fh
.2:
        mov ecx, GusWaveVoices
        mov word [GusMidiVoices+07A0h], ax
        pushfw
        cli
        call GusEnterCritical
        xor ebx, ebx
        jmp short .5
.3:
        test byte [byte ecx+013h], 1
        je short .4
        xor eax, eax
        mov al, byte [byte ecx+01Dh]
        shl eax, 4
        xor edx, edx
        mov dl, byte [dword eax+GusMidiVoices+081h]
        mov eax, ebx
        call GusVoiceUpdateVolume
.4:
        inc ebx
        add ecx, byte 21h
.5:
        xor eax, eax
        mov ax, word [GusActiveVoices]
        cmp ebx, eax
        jb short .3
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-0Ch]
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 090h
GusSetChannelModulation:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 10h
        mov dword [byte ebp-018h], eax
        test edx, edx
        jne short .1
        mov dword [byte ebp-01Ch], edx
        jmp short .2
.1:
        mov ecx, edx
        shl ecx, 4
        sub ecx, edx
        add ecx, ecx
        mov edx, ecx
        mov eax, ecx
        sar edx, 1Fh
        shl edx, 7
        LD sbb, eax, edx
        sar eax, 7
        add eax, byte 2
        mov ebx, 0C8h
        mov dword [byte ebp-01Ch], eax
.2:
        mov esi, dword [byte ebp-018h]
        shl esi, 4
        pushfw
        cli
        add esi, GusMidiVoices+080h
        call GusEnterCritical
        xor eax, eax
        mov byte [byte esi+0Bh], 0
        mov ecx, GusWaveVoices
        mov al, byte [byte esi+09h]
        mov byte [byte esi+0Ah], bl
        mov dword [byte ebp-020h], eax
        mov al, byte [byte ebp-01Ch]
        xor edi, edi
        mov byte [byte esi+09h], al
        jmp near .14
.3:
        test byte [byte ecx+013h], 1
        je near .13
        mov dl, byte [byte ebp-018h]
        cmp dl, byte [byte ecx+01Dh]
        jne near .13
        cmp dword [byte ebp-020h], byte 0
        jne short .4
        mov eax, dword [ecx]
        cmp byte [byte eax+047h], 0
        je short .5
.4:
        mov eax, 1
        jmp short .6
.5:
        xor eax, eax
.6:
        mov edx, eax
        cmp dword [byte ebp-01Ch], byte 0
        jne short .7
        mov eax, dword [ecx]
        cmp byte [byte eax+047h], 0
        je short .8
.7:
        mov eax, 1
        jmp short .9
.8:
        xor eax, eax
.9:
        test edx, edx
        setne dl
        and edx, 0FFh
        mov dword [byte ebp-014h], edx
        test eax, eax
        setne dl
        and edx, 0FFh
        xor edx, dword [byte ebp-014h]
        je short .11
        test eax, eax
        je short .10
        mov dx, word [GusMidiVoices+07A2h]
        mov ebx, edx
        inc ebx
        mov word [GusMidiVoices+07A2h], bx
        test dx, dx
        jne short .10
        call GusStartVibratoTimer
        jmp short .11
.10:
        test eax, eax
        jne short .11
        mov dx, word [GusMidiVoices+07A2h]
        dec dx
        mov word [GusMidiVoices+07A2h], dx
        jne short .11
        call GusStopVibratoTimer
.11:
        mov eax, dword [ecx]
        cmp byte [byte eax+047h], 0
        jne short .12
        cmp byte [byte esi+09h], 0
        je short .13
.12:
        mov edx, dword [byte ebp-01Ch]
        mov ebx, dword [byte ebp-018h]
        test edx, edx
        sete al
        xor edx, edx
        mov dl, al
        mov eax, edi
        call GusVoiceSetVibrato
.13:
        inc edi
        add ecx, byte 21h
.14:
        xor eax, eax
        mov ax, word [GusActiveVoices]
        cmp edi, eax
        jb near .3
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-010h]
        pop edi
        pop esi
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Bh,0C0h
GusVibratoJumpTable:
        dd GusVibratoTick+083h
        dd GusVibratoTick+068h
        dd GusVibratoTick+074h
        dd GusVibratoTick+078h
GusVibratoTick:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ebx, GusWaveVoices
        xor esi, esi
        jmp near .5
.1:
        test byte [byte ebx+013h], 1
        je near .4
        mov eax, dword [ebx]
        cmp byte [byte eax+047h], 0
        jne short .2
        xor eax, eax
        mov al, byte [byte ebx+01Dh]
        shl eax, 4
        cmp byte [dword eax+GusMidiVoices+089h], 0
        je near .4
.2:
        mov edx, dword [byte ebx+0Ah]
        xor eax, eax
        sar edx, 10h
        mov al, byte [byte ebx+017h]
        imul eax, edx
        xor ecx, ecx
        mov cl, byte [byte ebx+01Ah]
        xor edx, edx
        div ecx
        mov ecx, eax
        mov al, byte [byte ebx+019h]
        cmp al, 3
        ja short GusVibratoTick+083h
        and eax, 0FFh
        jmp dword [nosplit cs:eax*4+GusVibratoJumpTable]
        mov eax, dword [byte ebx+0Ah]
        sar eax, 10h
        sub eax, ecx
        mov ecx, eax
        jmp short GusVibratoTick+083h
        neg ecx
        jmp short GusVibratoTick+083h
        mov eax, dword [byte ebx+0Ah]
        sar eax, 10h
        sub eax, ecx
        imul ecx, eax, byte 0FFFFFFFFh
        cmp byte [byte ebx+018h], 0
        je short .3
        mov eax, dword [ebx]
        mov dl, byte [byte eax+045h]
        test dl, dl
        je short .3
        mov al, dl
        mov dl, byte [byte ebx+018h]
        and eax, 0FFh
        movzx edi, dl
        dec dl
        sub eax, edi
        mov byte [byte ebx+018h], dl
        mov edx, ecx
        imul edx, eax
        mov eax, dword [ebx]
        xor ecx, ecx
        mov cl, byte [byte eax+045h]
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov ecx, eax
.3:
        xor eax, eax
        mov edx, esi
        mov ax, word [GusVoiceSelectPort]
        call outp_
        xor eax, eax
        mov edx, 1
        mov ax, word [GusRegSelectPort]
        call outp_
        xor edx, edx
        mov dx, word [byte ebx+0Ah]
        xor eax, eax
        add edx, ecx
        mov ax, word [GusDataLowPort]
        add edx, edx
        call outpw_
        mov dh, byte [byte ebx+017h]
        inc dh
        mov cl, byte [byte ebx+01Ah]
        mov byte [byte ebx+017h], dh
        cmp dh, cl
        jb short .4
        xor edx, edx
        mov dl, byte [byte ebx+019h]
        inc edx
        mov ecx, 4
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov byte [byte ebx+017h], 0
        mov byte [byte ebx+019h], dl
.4:
        inc esi
        add ebx, byte 21h
.5:
        xor eax, eax
        mov ax, word [GusActiveVoices]
        cmp esi, eax
        jb near .1
        xor eax, eax
        lea esp, [byte ebp-014h]
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 090h
GusStartVibratoTimer:
        push ebp
        mov ebp, esp
        push edx
        mov eax, GusVibratoTick
        mov edx, 0BBh
        call GusStartTimer2
        lea esp, [byte ebp-04h]
        pop edx
        pop ebp
        ret
        db 08Dh,040h,00h
GusStopVibratoTimer:
        push ebp
        mov ebp, esp
        call GusStopTimer2
        mov esp, ebp
        pop ebp
        ret
GusVoiceSetVibrato:
        push ebp
        mov ebp, esp
        push ecx
        push esi
        push edi
        sub esp, byte 18h
        mov ecx, eax
        mov dword [byte ebp-018h], edx
        mov eax, ebx
        mov ebx, ecx
        shl ebx, 5
        shl eax, 4
        add ebx, ecx
        add eax, GusMidiVoices+080h
        add ebx, GusWaveVoices
        movzx esi, byte [byte eax+09h]
        mov ecx, dword [ebx]
        test esi, esi
        je short .1
        xor edx, edx
        mov dl, byte [byte eax+0Ah]
        mov al, byte [byte eax+0Bh]
        and eax, 0FFh
        jmp short .2
.1:
        movzx esi, byte [byte ecx+047h]
        xor eax, eax
        xor edx, edx
        mov al, byte [byte ecx+045h]
        mov dl, byte [byte ecx+046h]
.2:
        mov dword [byte ebp-014h], eax
        imul eax, edx, dword 91Eh
        mov ecx, 64h
        add eax, 1388h
        xor edx, edx
        div ecx
        mov ecx, eax
        lea edi, [nosplit eax*4+00h]
        xor edx, edx
        mov eax, 0B0E9h
        div edi
        xor edx, edx
        mov byte [byte ebx+01Ah], al
        mov eax, 0B0E9h
        div edi
        add ecx, ecx
        lea eax, [byte ebx+01Ah]
        cmp edx, ecx
        seta dl
        and edx, 0FFh
        add byte [eax], dl
        cmp byte [byte ebx+01Ah], 0
        jne short .3
        mov byte [byte ebx+01Ah], 1
.3:
        mov ecx, 15h
        mov eax, esi
        xor edx, edx
        div ecx
        mov edi, 0Ch
        xor edx, edx
        mov ecx, eax
        div edi
        mov dword [byte ebp-01Ch], edx
        lea edi, [byte ecx+01h]
        mov edx, 0Ch
        mov eax, edi
        mov dword [byte ebp-010h], edx
        xor edx, edx
        div dword [byte ebp-010h]
        mov eax, 0Ch
        mov dword [byte ebp-020h], edx
        mov dword [byte ebp-010h], eax
        xor edx, edx
        mov eax, ecx
        mov ecx, dword [byte ebp-010h]
        div ecx
        mov ecx, eax
        mov eax, 0Ch
        xor edx, edx
        mov dword [byte ebp-010h], eax
        mov eax, edi
        div dword [byte ebp-010h]
        mov edx, dword [byte ebp-01Ch]
        mov edx, dword [nosplit edx*4+GusPitchTable]
        shl edx, cl
        mov dword [byte ebp-024h], edx
        mov edx, dword [byte ebp-020h]
        mov cl, al
        mov edi, dword [nosplit edx*4+GusPitchTable]
        mov eax, esi
        shl edi, cl
        xor edx, edx
        mov ecx, 15h
        div ecx
        mov eax, dword [byte ebp-024h]
        sub edi, eax
        mov eax, edi
        imul eax, edx
        xor edx, edx
        div ecx
        add eax, dword [byte ebp-024h]
        xor edx, edx
        mov dx, word [byte ebx+0Ah]
        imul edx, eax
        xor eax, eax
        shr edx, 0Ah
        mov ax, word [byte ebx+0Ah]
        sub edx, eax
        mov eax, edx
        shr eax, 1
        mov ecx, dword [byte ebp-018h]
        mov word [byte ebx+0Ch], ax
        test ecx, ecx
        je short .4
        mov byte [byte ebx+017h], 0
        mov al, byte [byte ebp-014h]
        mov byte [byte ebx+019h], 0
        mov byte [byte ebx+018h], al
.4:
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
        db 090h
GusVoiceSetEnvelope:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 8
        mov ecx, edx
        mov ebx, GusWaveVoices
        mov edi, GusMidiVoices+080h
        mov edx, eax
        shl ecx, 4
        shl eax, 5
        add edi, ecx
        xor ecx, ecx
        add eax, edx
        mov cl, byte [byte edi+0Ch]
        add ebx, eax
        test ecx, ecx
        je short .1
        movzx edi, byte [byte edi+0Dh]
        jmp short .2
.1:
        mov edi, dword [ebx]
        mov cl, byte [byte edi+044h]
        movzx edi, byte [byte edi+043h]
.2:
        mov eax, dword [ebx]
        mov al, byte [byte eax+03Eh]
        xor edx, edx
        and eax, 0FFh
        mov dx, word [byte ebx+011h]
        imul eax, edx
        mov esi, 0FFh
        xor edx, edx
        div esi
        lea edx, [byte ecx+01h]
        mov ecx, edx
        shr ecx, 3
        shr edx, 4
        mov dword [byte ebp-014h], ecx
        mov ecx, eax
        sub ecx, edx
        cmp ecx, byte 5
        jae short .3
        lea eax, [byte edx+05h]
.3:
        lea ecx, [eax+edx]
        mov dword [byte ebp-018h], ecx
        mov ecx, dword [byte ebp-014h]
        mov esi, dword [byte ebp-018h]
        and ecx, byte 1
        add esi, ecx
        cmp esi, 0FBh
        jbe short .4
        mov eax, 0FBh
        sub eax, edx
        sub eax, ecx
.4:
        mov ah, al
        sub ah, dl
        mov byte [byte ebx+0Eh], ah
        mov ah, byte [byte ebp-014h]
        add al, dl
        and ah, 1
        xor edx, edx
        add al, ah
        mov dl, al
        mov byte [byte ebx+0Fh], al
        xor eax, eax
        mov al, byte [byte ebx+0Eh]
        sub edx, eax
        xor esi, esi
        shl edx, 4
        mov si, word [GusActiveVoices]
        imul edi, dword 91Eh
        shl esi, 4
        imul esi, edx
        mov eax, 4C4B40h
        add edi, 1388h
        xor edx, edx
        div edi
        xor ecx, ecx
        imul edi, eax, dword 186A0h
        jmp short .6
.5:
        cmp esi, edi
        ja short .7
        shl esi, 3
        inc ecx
.6:
        cmp ecx, byte 3
        jbe short .5
.7:
        cmp ecx, byte 3
        jbe short .8
        mov ecx, 3
.8:
        mov eax, edi
        shr eax, 1
        xor edx, edx
        add eax, esi
        div edi
        mov byte [byte ebx+010h], al
        cmp al, 3Fh
        jbe short .9
        mov byte [byte ebx+010h], 3Fh
.9:
        mov al, cl
        mov dl, byte [byte ebx+010h]
        shl al, 6
        or dl, al
        mov byte [byte ebx+010h], dl
        lea esp, [byte ebp-010h]
        pop edi
        pop esi
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Bh,0C0h
GusScaleRatio:
        push ebp
        mov ebp, esp
        push ecx
        push esi
        mov esi, eax
        mov ecx, edx
        pushfw
        cli
        call GusEnterCritical
        mov eax, edx
        shl ebx, 9
        sar eax, 1
        xor edx, edx
        add eax, ebx
        div ecx
        mov ebx, eax
        mov eax, esi
        shl ebx, 9
        shr eax, 1
        xor edx, edx
        add eax, ebx
        div esi
        mov ebx, eax
        call GusLeaveCritical
        popfw
        mov eax, ebx
        lea esp, [byte ebp-08h]
        pop esi
        pop ecx
        pop ebp
        ret
        db 090h
GusNoteFrequency:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        xor ebx, ebx
        mov bx, word [byte eax+018h]
        mov ax, word [byte eax+01Ch]
        sub edx, ebx
        and eax, 0FFFFh
        imul edx, eax
        mov ecx, edx
        sar edx, 0Ah
        add edx, ebx
        and ecx, 3FFh
        test edx, edx
        jge short .1
        xor edx, edx
.1:
        cmp edx, 80h
        jl short .2
        mov eax, dword [GusFreqDivisor]
        jmp short .4
.2:
        mov eax, dword [nosplit edx*4+GusNoteFreqTable]
        mov ebx, dword [nosplit edx*4+GusNoteFreqUpper]
        cmp edx, byte 5Fh
        jl short .3
        sar eax, 5
        sub ebx, eax
        imul ebx, ecx
        sar ebx, 0Ah
        add eax, ebx
        shl eax, 5
        lea esp, [byte ebp-08h]
        pop ecx
        pop ebx
        pop ebp
        ret
.3:
        sub ebx, eax
        imul ecx, ebx
        sar ecx, 0Ah
        add eax, ecx
.4:
        lea esp, [byte ebp-08h]
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Bh,0C0h
GusVoiceStopRamp:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        mov edx, eax
        pushfw
        cli
        call GusEnterCritical
        mov eax, edx
        mov ebx, eax
        shl ebx, 5
        add ebx, eax
        add ebx, GusWaveVoices
        mov ah, byte [byte ebx+013h]
        test ah, 1
        je near .1
        mov cl, ah
        and cl, 0F1h
        xor eax, eax
        mov ch, cl
        mov byte [byte ebx+013h], cl
        or ch, 0Ch
        mov ax, word [GusVoiceSelectPort]
        mov byte [byte ebx+013h], ch
        call outp_
        xor eax, eax
        mov edx, 0Dh
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        call GusDelay
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 89h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov ax, word [GusDataLowPort]
        call inpw_
        shr eax, 8
        cmp eax, byte 5
        jbe near .1
        xor eax, eax
        mov edx, 7
        mov ax, word [GusRegSelectPort]
        mov byte [byte ebx+015h], 40h
        call outp_
        xor eax, eax
        mov edx, 5
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 6
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 3Fh
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 0Dh
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ebx+015h]
        call outp_
        call GusDelay
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ebx+015h]
        call outp_
.1:
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-0Ch]
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
GusVoiceStopWave:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        mov ebx, eax
        pushfw
        cli
        mov ecx, ebx
        call GusEnterCritical
        mov eax, ecx
        shl eax, 5
        add eax, ecx
        mov ecx, GusWaveVoices
        add ecx, eax
        test byte [byte ecx+013h], 1
        je near .3
        xor eax, eax
        mov edx, ebx
        mov ax, word [GusVoiceSelectPort]
        call outp_
.1:
        xor eax, eax
        mov edx, 8Dh
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov ax, word [GusDataHighPort]
        call inp_
        test al, 3
        je short .1
        xor eax, eax
        xor edx, edx
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        call GusDelay
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        mov byte [byte ecx+013h], 0
        mov eax, ebx
        mov byte [byte ecx+016h], 0
        xor dl, dl
        call GusReleaseVoice
        mov byte [nosplit ebx*4+GusMidiVoices], dl
        mov byte [nosplit ebx*4+GusMidiVoiceNote], dl
        mov eax, dword [ecx]
        cmp byte [byte eax+047h], 0
        jne short .2
        xor eax, eax
        mov al, byte [byte ecx+01Dh]
        shl eax, 4
        cmp byte [dword eax+GusMidiVoices+089h], 0
        je short .3
.2:
        mov dx, word [GusMidiVoices+07A2h]
        dec dx
        mov word [GusMidiVoices+07A2h], dx
        jne short .3
        call GusStopVibratoTimer
.3:
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-0Ch]
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Bh,0C0h
GusStopNoteVoices:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        push esi
        mov ecx, eax
        pushfw
        cli
        call GusEnterCritical
        xor edx, edx
.1:
        lea ebx, [nosplit edx*2+00h]
        mov eax, dword [dword ebx+ecx*8+GusMidiVoices+069Eh]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        je short .2
        call GusVoiceStopRamp
.2:
        inc edx
        cmp edx, byte 4
        jl short .1
        xor edx, edx
.3:
        lea eax, [nosplit edx*2+00h]
        mov ebx, dword [dword eax+ecx*8+GusMidiVoices+069Eh]
        sar ebx, 10h
        cmp ebx, byte 0FFFFFFFFh
        je short .4
        mov eax, ebx
        mov esi, ebx
        shl eax, 5
        test byte [dword esi+eax+GusWaveVoiceFlags], 1
        je short .4
        mov eax, ebx
        call GusVoiceStopWave
.4:
        inc edx
        cmp edx, byte 4
        jl short .3
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-010h]
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Bh,0C0h
GusMidiNoteOn:
        push ebp
        mov ebp, esp
        push esi
        push edi
        sub esp, byte 38h
        mov edi, eax
        mov dword [byte ebp-02Ch], edx
        mov dword [byte ebp-01Ch], ebx
        mov dword [byte ebp-014h], ecx
        test ecx, ecx
        jne short .1
        mov edx, dword [byte ebp+08h]
        mov eax, ebx
        call GusMidiNoteOff
        jmp near .39
.1:
        mov eax, dword [byte ebp+08h]
        mov edx, GusMidiVoices+080h
        shl eax, 4
        add edx, eax
        mov dword [byte ebp-010h], edx
        test edi, edi
        jne short .2
        mov edi, dword [byte edx+04h]
.2:
        test edi, edi
        je near .39
        pushfw
        cli
        call GusEnterCritical
        mov ebx, 0FFFFFFFFh
        mov eax, dword [byte edi-02h]
        xor ecx, ecx
        sar eax, 10h
        mov dword [byte ebp-040h], ebx
        mov dword [byte ebp-018h], ecx
        mov dword [byte ebp-020h], eax
        mov eax, dword [byte ebp-018h]
        cmp eax, dword [byte ebp-020h]
        jl short .3
        xor edx, edx
        jmp near .38
.3:
        mov eax, dword [byte ebp-018h]
        mov dword [byte ebp+eax*4-040h], 0FFFFFFFFh
        mov esi, dword [byte edi+eax*4+02h]
        cmp word [byte esi+01Ch], 400h
        je short .4
        mov edx, dword [byte ebp-01Ch]
        mov eax, esi
        call GusNoteFrequency
        mov ebx, eax
        jmp short .5
.4:
        mov ebx, dword [byte ebp-01Ch]
        mov ebx, dword [nosplit ebx*4+GusNoteFreqTable]
.5:
        cmp word [byte edi+01Ah], 400h
        je short .8
        xor ecx, ecx
        cmp ebx, 80000h
        jl short .6
        sar ebx, 4
        mov ecx, 1
        cmp ebx, 80000h
        jl short .6
        mov ecx, 2
        sar ebx, 4
.6:
        xor eax, eax
        mov ax, word [byte edi+01Ah]
        imul ebx, eax
        add ebx, 200h
        shr ebx, 0Ah
        test ecx, ecx
        je short .7
        shl ebx, 4
        dec ecx
.7:
        test ecx, ecx
        je short .8
        shl ebx, 4
.8:
        mov eax, dword [byte ebp-018h]
        mov eax, dword [byte edi+eax*2+010h]
        sar eax, 10h
        xor edx, edx
        mov dword [byte ebp-024h], eax
        jmp short .11
.9:
        mov eax, dword [byte esi+0Ch]
        lea ecx, [byte esi+049h]
        cmp ebx, eax
        jg short .10
        cmp ebx, dword [byte esi+08h]
        jl short .10
        mov eax, dword [byte ebp-024h]
        dec eax
        cmp edx, eax
        jge short .12
        cmp ebx, dword [byte ecx+0Ch]
        jg short .12
        cmp ebx, dword [byte ecx+08h]
        jl short .12
.10:
        mov esi, ecx
        inc edx
.11:
        cmp edx, dword [byte ebp-024h]
        jl short .9
.12:
        cmp edx, dword [byte ebp-024h]
        je near .31
        mov eax, dword [byte ebp-02Ch]
        mov edx, GusStopNoteVoices
        call GusAllocVoice
        mov edx, eax
        mov dword [byte ebp-028h], eax
        cmp eax, byte 0FFFFFFFFh
        je near .31
        mov eax, dword [byte ebp-018h]
        mov dword [byte ebp+eax*4-040h], edx
        mov al, byte [byte ebp-01Ch]
        xor ah, ah
        mov byte [nosplit edx*4+GusMidiVoiceNote], al
        mov byte [nosplit edx*4+GusMidiVoices], ah
        mov al, byte [byte ebp+08h]
        mov byte [nosplit edx*4+GusMidiVoiceVelocity], al
        mov eax, edx
        shl edx, 5
        mov ecx, GusWaveVoices
        add edx, eax
        add ecx, edx
        mov al, byte [byte ebp+08h]
        mov edx, dword [byte ebp-014h]
        mov byte [byte ecx+01Dh], al
        cmp edx, byte 1
        jge short .13
        mov dword [byte ebp-014h], 1
        jmp short .14
.13:
        cmp edx, byte 7Fh
        jle short .14
        mov dword [byte ebp-014h], 7Fh
.14:
        mov al, byte [byte ebp-014h]
        mov dl, byte [GusMidiReady]
        mov byte [byte ecx+01Ch], al
        test dl, dl
        je short .15
        mov edx, dword [byte ebp-014h]
        xor eax, eax
        mov al, byte [dword edx+GusVolumeCurve]
        mov dword [byte ebp-030h], eax
        mov eax, dword [GusMidiVoices+07A0h-2]
        sar eax, 10h
        mov edx, dword [byte ebp-030h]
        add eax, byte 40h
        imul edx, eax
        mov eax, dword [byte ebp-010h]
        mov dword [byte ebp-0Ch], edx
        mov al, byte [byte eax+01h]
        and eax, 0FFh
        mov dword [byte ebp-030h], eax
        mov edx, dword [byte ebp-030h]
        xor eax, eax
        mov al, byte [dword edx+GusVolumeCurve]
        mov edx, dword [byte ebp-0Ch]
        imul edx, eax
        jmp short .16
.15:
        mov eax, dword [GusMidiVoices+07A0h-2]
        mov edx, dword [byte ebp-014h]
        sar eax, 10h
        add edx, 80h
        add eax, byte 40h
        imul edx, eax
        mov dword [byte ebp-0Ch], edx
        mov edx, dword [byte ebp-010h]
        xor eax, eax
        mov al, byte [byte edx+01h]
        lea edx, [dword eax+080h]
        imul edx, dword [byte ebp-0Ch]
.16:
        mov dword [byte ebp-0Ch], 0BE41h
        mov eax, edx
        sar edx, 1Fh
        idiv dword [byte ebp-0Ch]
        mov word [byte ecx+011h], ax
        xor eax, eax
        mov dword [ecx], esi
        mov ax, word [byte esi+02Eh]
        mov edx, dword [byte esi+010h]
        call GusScaleRatio
        mov word [byte ecx+08h], ax
        mov eax, dword [byte ebp-010h]
        cmp word [byte eax+02h], 400h
        jne short .17
        mov ax, word [byte ecx+08h]
        jmp short .18
.17:
        mov ebx, dword [byte ebp-010h]
        xor eax, eax
        xor edx, edx
        mov ax, word [byte ecx+08h]
        mov dx, word [byte ebx+02h]
        imul eax, edx
        shr eax, 0Ah
.18:
        mov word [byte ecx+0Ah], ax
        xor eax, eax
        mov edx, dword [byte ebp-028h]
        mov ax, word [GusVoiceSelectPort]
        call outp_
        xor eax, eax
        mov edx, 1
        mov ax, word [GusRegSelectPort]
        call outp_
        xor edx, edx
        xor eax, eax
        mov dx, word [byte ecx+0Ah]
        mov ax, word [GusDataLowPort]
        add edx, edx
        call outpw_
        xor eax, eax
        mov edx, 0Ch
        mov ax, word [GusRegSelectPort]
        call outp_
        mov eax, dword [byte ebp-010h]
        cmp byte [byte eax+08h], 10h
        je short .19
        xor edx, edx
        mov dl, byte [byte eax+08h]
        xor eax, eax
        mov ax, word [GusDataHighPort]
        jmp short .20
.19:
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte esi+035h]
.20:
        call outp_
        mov byte [byte ecx+014h], 0
        mov byte [byte ecx+015h], 0
        test byte [byte esi+048h], 4
        je short .21
        or byte [byte ecx+014h], 8
.21:
        test byte [byte esi+048h], 1
        je short .22
        or byte [byte ecx+014h], 4
.22:
        test byte [byte esi+048h], 8
        je short .23
        or byte [byte ecx+014h], 10h
.23:
        test byte [byte esi+048h], 10h
        je short .24
        mov edx, 0Bh
        mov bh, byte [byte ecx+014h]
        xor eax, eax
        or bh, 40h
        mov ax, word [GusRegSelectPort]
        mov byte [byte ecx+014h], bh
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataLowPort]
        mov dx, word [byte esi+02Ah]
        call outpw_
        xor eax, eax
        mov edx, 0Ah
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataLowPort]
        mov dx, word [byte esi+02Ch]
        jmp short .25
.24:
        xor eax, eax
        mov edx, 0Bh
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataLowPort]
        mov dx, word [byte esi+01Eh]
        call outpw_
        xor eax, eax
        mov edx, 0Ah
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataLowPort]
        mov dx, word [byte esi+020h]
.25:
        call outpw_
        xor eax, eax
        mov edx, 3
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataLowPort]
        mov dx, word [byte esi+022h]
        call outpw_
        xor eax, eax
        mov edx, 2
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataLowPort]
        mov dx, word [byte esi+024h]
        call outpw_
        xor eax, eax
        mov edx, 5
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataLowPort]
        mov dx, word [byte esi+026h]
        call outpw_
        xor eax, eax
        mov edx, 4
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataLowPort]
        mov dx, word [byte esi+028h]
        call outpw_
        xor eax, eax
        mov edx, 6
        mov ax, word [GusRegSelectPort]
        mov byte [byte ecx+01Bh], 0
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte esi+036h]
        call outp_
        xor eax, eax
        mov edx, 7
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 5
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 8
        mov ax, word [GusRegSelectPort]
        call outp_
        xor edx, edx
        xor eax, eax
        mov dl, byte [byte esi+03Ch]
        mov ax, word [byte ecx+011h]
        imul eax, edx
        mov ebx, 0FFh
        xor edx, edx
        div ebx
        mov edx, eax
        cmp eax, byte 5
        jae short .26
        mov edx, 5
.26:
        mov byte [byte ecx+01Eh], 0
        xor eax, eax
        mov byte [byte ecx+020h], 0
        mov ax, word [GusDataHighPort]
        mov byte [byte ecx+01Fh], dl
        call outp_
        or byte [byte ecx+015h], 20h
        cmp byte [byte esi+047h], 0
        jne short .27
        mov eax, dword [byte ebp-010h]
        cmp byte [byte eax+09h], 0
        je short .28
.27:
        mov eax, dword [byte ebp-028h]
        mov edx, 1
        mov ebx, dword [byte ebp+08h]
        call GusVoiceSetVibrato
        mov ax, word [GusMidiVoices+07A2h]
        mov edx, eax
        inc edx
        mov word [GusMidiVoices+07A2h], dx
        test ax, ax
        jne short .28
        call GusStartVibratoTimer
.28:
        cmp byte [byte esi+044h], 0
        jne short .29
        mov eax, dword [byte ebp-010h]
        cmp byte [byte eax+0Ch], 0
        je short .30
.29:
        mov eax, dword [byte ebp-028h]
        mov edx, dword [byte ebp+08h]
        call GusVoiceSetEnvelope
.30:
        mov edx, 0Dh
        xor eax, eax
        mov byte [byte ecx+013h], 1
        mov ax, word [GusRegSelectPort]
        mov byte [byte ecx+016h], 0
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ecx+015h]
        call outp_
        call GusDelay
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ecx+015h]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ecx+014h]
        call outp_
        call GusDelay
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ecx+014h]
        call outp_
.31:
        inc dword [byte ebp-018h]
        mov eax, dword [byte ebp-018h]
        cmp eax, dword [byte ebp-020h]
        jl near .3
        xor edx, edx
        jmp short .38
.32:
        cmp dword [byte ebp+edx*4-040h], byte 0FFFFFFFFh
        je short .37
        xor ebx, ebx
        jmp short .34
.33:
        lea esi, [nosplit ebx*2+00h]
        mov eax, dword [byte ebp+edx*4-040h]
        mov cx, word [byte ebp+ebx*4-040h]
        inc ebx
        mov word [dword esi+eax*8+GusMidiVoices+06A0h], cx
.34:
        cmp ebx, dword [byte ebp-020h]
        jl short .33
        jmp short .36
.35:
        lea eax, [nosplit ebx*2+00h]
        mov ecx, dword [byte ebp+edx*4-040h]
        mov esi, 0FFFFFFFFh
        inc ebx
        mov word [dword eax+ecx*8+GusMidiVoices+06A0h], si
.36:
        cmp ebx, byte 4
        jl short .35
.37:
        inc edx
.38:
        cmp edx, dword [byte ebp-020h]
        jl short .32
        call GusLeaveCritical
        popfw
.39:
        lea esp, [byte ebp-08h]
        pop edi
        pop esi
        pop ebp
        ret 4
        db 08Dh,040h,00h
GusMidiNoteOff:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 0Ch
        mov dword [byte ebp-01Ch], eax
        pushfw
        cli
        call GusEnterCritical
        mov eax, edx
        shl eax, 4
        test byte [dword eax+GusMidiVoices+080h], 1
        je short .3
        xor ecx, ecx
.1:
        lea ebx, [nosplit ecx*4+00h]
        mov ah, byte [byte ebp-01Ch]
        cmp ah, byte [dword ebx+GusMidiVoiceNote]
        jne short .2
        cmp dl, byte [dword ebx+GusMidiVoiceVelocity]
        jne short .2
        or byte [dword ebx+GusMidiVoices], 1
.2:
        inc ecx
        cmp ecx, byte 20h
        jl short .1
        jmp near .22
.3:
        xor esi, esi
.4:
        lea eax, [nosplit esi*4+00h]
        mov bh, byte [byte ebp-01Ch]
        cmp bh, byte [dword eax+GusMidiVoiceNote]
        jne short .5
        cmp dl, byte [dword eax+GusMidiVoiceVelocity]
        je short .6
.5:
        inc esi
        cmp esi, byte 20h
        jl short .4
.6:
        cmp esi, byte 20h
        je near .22
        xor edi, edi
.7:
        lea eax, [nosplit edi*2+00h]
        mov ecx, dword [dword eax+esi*8+GusMidiVoices+069Eh]
        sar ecx, 10h
        cmp ecx, byte 0FFFFFFFFh
        je near .21
        mov ebx, ecx
        shl ebx, 5
        mov edx, 20h
        add ebx, ecx
        mov eax, ecx
        add ebx, GusWaveVoices
        call GusAddVoicePriority
        mov al, byte [byte ebx+013h]
        test al, 1
        je near .21
        test al, 4
        jne near .21
        mov dl, byte [nosplit ecx*4+GusMidiVoices]
        xor dh, dh
        and dl, 0FEh
        mov byte [nosplit ecx*4+GusMidiVoiceNote], dh
        mov byte [nosplit ecx*4+GusMidiVoices], dl
        mov al, byte [byte ebx+013h]
        and al, 0F9h
        mov ah, al
        mov byte [byte ebx+013h], al
        or ah, 4
        mov byte [byte ebx+013h], ah
        mov eax, dword [ebx]
        test byte [byte eax+048h], 40h
        jne near .10
        xor eax, eax
        mov edx, ecx
        mov ax, word [GusVoiceSelectPort]
        call outp_
        mov dh, byte [byte ebx+014h]
        and dh, 0D7h
        mov al, dh
        mov byte [byte ebx+014h], dh
        or al, 20h
        mov byte [byte ebx+014h], al
        mov eax, dword [ebx]
        test byte [byte eax+048h], 10h
        je short .8
        xor eax, eax
        mov edx, 3
        mov ax, word [GusRegSelectPort]
        call outp_
        mov eax, dword [ebx]
        mov ax, word [byte eax+01Eh]
        and eax, 0FFFFh
        mov dword [byte ebp-018h], eax
        xor eax, eax
        mov edx, dword [byte ebp-018h]
        mov ax, word [GusDataLowPort]
        call outpw_
        xor eax, eax
        mov edx, 2
        mov ax, word [GusRegSelectPort]
        call outp_
        mov eax, dword [ebx]
        mov ax, word [byte eax+020h]
        jmp short .9
.8:
        xor eax, eax
        mov edx, 5
        mov ax, word [GusRegSelectPort]
        call outp_
        mov eax, dword [ebx]
        mov ax, word [byte eax+02Ah]
        and eax, 0FFFFh
        mov dword [byte ebp-018h], eax
        xor eax, eax
        mov edx, dword [byte ebp-018h]
        mov ax, word [GusDataLowPort]
        call outpw_
        xor eax, eax
        mov edx, 4
        mov ax, word [GusRegSelectPort]
        call outp_
        mov eax, dword [ebx]
        mov ax, word [byte eax+02Ch]
.9:
        and eax, 0FFFFh
        mov dword [byte ebp-018h], eax
        xor eax, eax
        mov edx, dword [byte ebp-018h]
        mov ax, word [GusDataLowPort]
        call outpw_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ebx+014h]
        call outp_
        call GusDelay
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ebx+014h]
        call outp_
.10:
        mov eax, dword [ebx]
        mov dh, byte [byte eax+048h]
        test dh, 40h
        je short .11
        test dh, 80h
        je near .13
.11:
        xor eax, eax
        mov edx, 0Dh
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        call GusDelay
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        mov dh, byte [byte ebx+015h]
        mov byte [byte ebx+01Bh], 5
        xor eax, eax
        or dh, 60h
        mov ax, word [GusRegSelectPort]
        mov cl, dh
        mov byte [byte ebx+015h], dh
        and cl, 0E7h
        mov edx, 89h
        mov byte [byte ebx+015h], cl
        call outp_
        xor eax, eax
        mov ax, word [GusDataLowPort]
        call inpw_
        and eax, 0FFFFh
        sar eax, 8
        mov ch, byte [byte ebx+01Eh]
        mov word [byte ebp-014h], ax
        test ch, ch
        jne short .12
        xor eax, eax
        mov ax, word [byte ebx+011h]
        mov dword [byte ebp-018h], eax
        xor eax, eax
        mov ax, word [byte ebp-014h]
        mov ecx, eax
        shl ecx, 8
        sub ecx, eax
        xor edx, edx
        mov eax, ecx
        div dword [byte ebp-018h]
        mov byte [byte ebx+01Eh], al
.12:
        mov al, byte [byte ebp-014h]
        mov byte [byte ebx+020h], al
        xor eax, eax
        mov edx, 6
        mov ax, word [GusRegSelectPort]
        mov byte [byte ebx+01Fh], 5
        call outp_
        mov edx, dword [ebx]
        mov dl, byte [byte edx+03Bh]
        xor eax, eax
        and edx, 0FFh
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 7
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 5
        jmp near .19
.13:
        test dh, 20h
        je near .21
        xor eax, eax
        mov edx, ecx
        mov ax, word [GusVoiceSelectPort]
        call outp_
        xor eax, eax
        mov edx, 0Dh
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        call GusDelay
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        cmp byte [byte ebx+01Bh], 3
        jae short .14
        mov byte [byte ebx+01Bh], 3
.14:
        mov cl, byte [byte ebx+015h]
        mov edx, 6
        or cl, 20h
        xor eax, eax
        mov ch, cl
        mov byte [byte ebx+015h], cl
        and ch, 0E7h
        mov ax, word [GusRegSelectPort]
        mov byte [byte ebx+015h], ch
        call outp_
        mov edx, dword [ebx]
        mov dl, byte [byte edx+039h]
        xor eax, eax
        and edx, 0FFh
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 89h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov ax, word [GusDataLowPort]
        call inpw_
        mov word [byte ebp-014h], ax
        shr ax, 8
        mov word [byte ebp-014h], ax
        cmp byte [byte ebx+01Eh], 0
        jne short .15
        xor eax, eax
        mov ax, word [byte ebx+011h]
        mov dword [byte ebp-018h], eax
        xor eax, eax
        mov ax, word [byte ebp-014h]
        mov ecx, eax
        shl ecx, 8
        sub ecx, eax
        xor edx, edx
        mov eax, ecx
        div dword [byte ebp-018h]
        mov byte [byte ebx+01Eh], al
.15:
        mov al, byte [byte ebp-014h]
        mov byte [byte ebx+020h], al
        mov eax, dword [ebx]
        mov al, byte [byte eax+03Fh]
        cmp al, byte [byte ebp-014h]
        jbe near .17
        mov dl, byte [byte ebx+015h]
        xor eax, eax
        and dl, 0BFh
        mov ax, word [GusRegSelectPort]
        mov byte [byte ebx+015h], dl
        mov edx, 7
        call outp_
        xor edx, edx
        xor eax, eax
        mov dx, word [byte ebp-014h]
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 8
        mov ax, word [GusRegSelectPort]
        call outp_
        mov eax, dword [ebx]
        mov al, byte [byte eax+03Fh]
        xor edx, edx
        and eax, 0FFh
        mov dx, word [byte ebx+011h]
        imul eax, edx
        mov ecx, 0FFh
        xor edx, edx
        div ecx
        mov ecx, eax
        cmp eax, byte 5
        jae short .16
        mov ecx, 5
.16:
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, cl
        mov byte [byte ebx+01Fh], cl
        jmp short .20
.17:
        mov dh, byte [byte ebx+015h]
        xor eax, eax
        or dh, 40h
        mov ax, word [GusRegSelectPort]
        mov byte [byte ebx+015h], dh
        mov edx, 7
        call outp_
        mov edx, dword [ebx]
        mov dl, byte [byte edx+03Fh]
        xor eax, eax
        and edx, 0FFh
        mov ax, word [byte ebx+011h]
        imul eax, edx
        mov ecx, 0FFh
        xor edx, edx
        div ecx
        mov ecx, eax
        cmp eax, byte 5
        jae short .18
        mov ecx, 5
.18:
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, cl
        mov byte [byte ebx+01Fh], cl
        call outp_
        xor eax, eax
        mov edx, 8
        mov ax, word [GusRegSelectPort]
        call outp_
        xor edx, edx
        xor eax, eax
        mov dx, word [byte ebp-014h]
.19:
        mov ax, word [GusDataHighPort]
.20:
        call outp_
        xor eax, eax
        mov edx, 0Dh
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ebx+015h]
        call outp_
        call GusDelay
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ebx+015h]
        call outp_
.21:
        inc edi
        cmp edi, byte 4
        jl near .7
.22:
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-010h]
        pop edi
        pop esi
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Bh,0C0h
GusSetSustain:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        mov ecx, eax
        pushfw
        cli
        call GusEnterCritical
        mov eax, ecx
        shl eax, 4
        test edx, edx
        je short .1
        or byte [dword eax+GusMidiVoices+080h], 1
        jmp short .5
.1:
        mov dh, byte [dword eax+GusMidiVoices+080h]
        and dh, 0FEh
        xor ebx, ebx
        mov byte [dword eax+GusMidiVoices+080h], dh
        jmp short .4
.2:
        lea eax, [nosplit ebx*4+00h]
        cmp cl, byte [dword eax+GusMidiVoiceVelocity]
        jne short .3
        test byte [dword eax+GusMidiVoices], 1
        je short .3
        cmp byte [dword eax+GusMidiVoiceNote], 0
        je short .3
        xor edx, edx
        mov al, byte [dword eax+GusMidiVoiceNote]
        mov dl, cl
        and eax, 0FFh
        call GusMidiNoteOff
.3:
        inc ebx
.4:
        xor eax, eax
        mov ax, word [GusActiveVoices]
        cmp ebx, eax
        jb short .2
.5:
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-08h]
        pop ecx
        pop ebx
        pop ebp
        ret
GusVoiceWaveEnd:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        mov ebx, eax
        mov ecx, eax
        shl ecx, 5
        add ecx, eax
        add ecx, GusWaveVoices
        test byte [byte ecx+013h], 1
        je short .2
        mov dl, byte [byte ecx+014h]
        xor eax, eax
        and dl, 5Fh
        mov ax, word [GusVoiceSelectPort]
        mov byte [byte ecx+014h], dl
        mov edx, ebx
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ecx+014h]
        call outp_
        call GusDelay
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ecx+014h]
        call outp_
        test byte [byte ecx+013h], 8
        je short .1
        cmp byte [byte ecx+01Bh], 0
        je short .1
        mov eax, ebx
        call GusVoiceStopRamp
        mov eax, ebx
        call GusVoiceStopWave
.1:
        mov eax, 1
        jmp short .3
.2:
        xor eax, eax
.3:
        lea esp, [byte ebp-0Ch]
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Bh,0C0h
GusVoiceRampEnd:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        push esi
        sub esp, byte 0Ch
        mov edx, eax
        mov ebx, eax
        shl ebx, 5
        add ebx, eax
        add ebx, GusWaveVoices
        test byte [byte ebx+013h], 1
        je near .19
        mov cl, byte [byte ebx+015h]
        xor eax, eax
        and cl, 5Fh
        mov ax, word [GusVoiceSelectPort]
        mov byte [byte ebx+015h], cl
        call outp_
        xor eax, eax
        mov edx, 0Dh
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        call GusDelay
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 89h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov ax, word [GusDataLowPort]
        call inpw_
        and eax, 0FFFFh
        sar eax, 8
        mov ch, byte [byte ebx+016h]
        mov byte [byte ebp-018h], al
        test ch, ch
        je short .1
        mov al, ch
        dec al
        mov byte [byte ebx+01Bh], al
        mov al, 1
        mov byte [byte ebx+016h], 0
        mov byte [byte ebp-014h], al
        jmp short .2
.1:
        mov dl, byte [byte ebx+01Bh]
        inc dl
        mov byte [byte ebp-014h], ch
        mov byte [byte ebx+01Bh], dl
.2:
        xor ecx, ecx
        mov cl, byte [byte ebx+01Bh]
        cmp ecx, byte 6
        jl near .6
        cmp byte [byte ebp-014h], 0
        jne short .3
        mov al, byte [byte ebx+01Fh]
        mov byte [byte ebx+020h], al
.3:
        mov cl, byte [byte ebx+013h]
        mov al, byte [byte ebx+014h]
        and cl, 0F1h
        and al, 0D7h
        mov byte [byte ebx+013h], cl
        mov ah, al
        mov byte [byte ebx+014h], al
        or ah, 20h
        mov ch, cl
        mov byte [byte ebx+014h], ah
        or ch, 0Ch
        mov eax, dword [ebx]
        mov byte [byte ebx+013h], ch
        test byte [byte eax+048h], 10h
        je short .4
        xor eax, eax
        mov edx, 3
        mov ax, word [GusRegSelectPort]
        call outp_
        mov edx, dword [ebx]
        mov dx, word [byte edx+01Eh]
        xor eax, eax
        and edx, 0FFFFh
        mov ax, word [GusDataLowPort]
        call outpw_
        xor eax, eax
        mov edx, 2
        mov ax, word [GusRegSelectPort]
        call outp_
        mov edx, dword [ebx]
        mov dx, word [byte edx+020h]
        jmp short .5
.4:
        xor eax, eax
        mov edx, 5
        mov ax, word [GusRegSelectPort]
        call outp_
        mov edx, dword [ebx]
        mov dx, word [byte edx+02Ah]
        xor eax, eax
        and edx, 0FFFFh
        mov ax, word [GusDataLowPort]
        call outpw_
        xor eax, eax
        mov edx, 4
        mov ax, word [GusRegSelectPort]
        call outp_
        mov edx, dword [ebx]
        mov dx, word [byte edx+02Ch]
.5:
        xor eax, eax
        and edx, 0FFFFh
        mov ax, word [GusDataLowPort]
        call outpw_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ebx+014h]
        call outp_
        call GusDelay
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ebx+014h]
        jmp near .17
.6:
        cmp ecx, byte 3
        jne near .11
        mov eax, dword [ebx]
        test byte [byte eax+048h], 20h
        je near .11
        mov al, byte [byte ebx+013h]
        test al, 4
        jne near .11
        mov ah, al
        or ah, 2
        mov dl, byte [byte ebp-014h]
        mov byte [byte ebx+013h], ah
        test dl, dl
        jne short .7
        mov al, byte [byte ebx+01Fh]
        mov byte [byte ebx+020h], al
.7:
        mov eax, dword [ebx]
        mov al, byte [byte eax+03Eh]
        mov byte [byte ebx+01Eh], al
        mov eax, dword [ebx]
        cmp byte [byte eax+044h], 0
        jne short .8
        xor eax, eax
        mov al, byte [byte ebx+01Dh]
        shl eax, 4
        cmp byte [dword eax+GusMidiVoices+08Ch], 0
        je near .18
.8:
        xor eax, eax
        mov edx, 89h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov ax, word [GusDataLowPort]
        call inpw_
        and eax, 0FFFFh
        xor edx, edx
        sar eax, 4
        mov dl, byte [byte ebx+0Eh]
        and eax, 0FFFFh
        cmp eax, edx
        jle short .9
        or byte [byte ebx+015h], 40h
        jmp short .10
.9:
        and byte [byte ebx+015h], 0BFh
.10:
        xor eax, eax
        mov edx, 6
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ebx+010h]
        call outp_
        xor eax, eax
        mov edx, 7
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ebx+0Eh]
        call outp_
        xor eax, eax
        mov edx, 8
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ebx+0Fh]
        call outp_
        or byte [byte ebx+015h], 18h
        jmp near .18
.11:
        mov dl, byte [byte ebx+015h]
        xor eax, eax
        or dl, 20h
        mov ax, word [GusRegSelectPort]
        mov byte [byte ebx+015h], dl
        mov edx, 6
        call outp_
        mov eax, dword [ebx]
        xor edx, edx
        mov dl, byte [byte ecx+eax+036h]
        xor eax, eax
        mov ax, word [GusDataHighPort]
        call outp_
        cmp byte [byte ebp-014h], 0
        je short .12
        mov al, byte [byte ebx+01Fh]
        xor ah, ah
        mov word [byte ebp-01Ch], ax
        jmp short .14
.12:
        mov al, byte [byte ebx+01Fh]
        mov byte [byte ebx+020h], al
        mov eax, dword [ebx]
        mov al, byte [byte ecx+eax+03Ch]
        xor edx, edx
        and eax, 0FFh
        mov dx, word [byte ebx+011h]
        imul eax, edx
        mov ecx, 0FFh
        xor edx, edx
        div ecx
        mov word [byte ebp-01Ch], ax
        cmp ax, 5
        jae short .13
        mov word [byte ebp-01Ch], 5
.13:
        mov al, byte [byte ebp-01Ch]
        mov byte [byte ebx+01Fh], al
.14:
        mov al, byte [byte ebp-018h]
        mov esi, dword [byte ebp-01Ch]
        xor ah, ah
        cmp ax, si
        jb short .15
        mov edx, 7
        mov cl, byte [byte ebx+015h]
        xor eax, eax
        or cl, 40h
        mov ax, word [GusRegSelectPort]
        mov byte [byte ebx+015h], cl
        jmp short .16
.15:
        mov edx, 8
        mov ch, byte [byte ebx+015h]
        xor eax, eax
        and ch, 0BFh
        mov ax, word [GusRegSelectPort]
        mov byte [byte ebx+015h], ch
.16:
        call outp_
        xor edx, edx
        xor eax, eax
        mov dl, byte [byte ebp-01Ch]
        mov ax, word [GusDataHighPort]
.17:
        call outp_
.18:
        xor eax, eax
        mov edx, 0Dh
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ebx+015h]
        call outp_
        call GusDelay
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ebx+015h]
        call outp_
        mov eax, 1
        lea esp, [byte ebp-010h]
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
.19:
        xor eax, eax
        lea esp, [byte ebp-010h]
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Bh,0C0h
GusStopPatchVoices:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 14h
        mov edx, eax
        pushfw
        cli
        mov ebx, GusWaveVoices
        call GusEnterCritical
        mov dword [byte ebp-01Ch], ebx
        xor ebx, ebx
        jmp short .8
.1:
        mov eax, dword [byte ebp-01Ch]
        test byte [byte eax+013h], 1
        je short .7
        mov eax, dword [byte edx-02h]
        sar eax, 10h
        mov dword [byte ebp-028h], eax
        xor eax, eax
        jmp short .5
.2:
        mov ecx, dword [byte edx+eax*2+010h]
        mov esi, dword [byte edx+eax*4+02h]
        sar ecx, 10h
.3:
        mov dword [byte ebp-020h], esi
        test ecx, ecx
        je short .4
        mov edi, dword [byte ebp-01Ch]
        mov esi, dword [byte ebp-020h]
        cmp esi, dword [edi]
        je short .4
        add esi, byte 49h
        dec ecx
        jmp short .3
.4:
        test ecx, ecx
        jne short .6
        inc eax
.5:
        cmp eax, dword [byte ebp-028h]
        jl short .2
.6:
        cmp eax, dword [byte ebp-028h]
        je short .7
        mov eax, ebx
        call GusVoiceStopRamp
.7:
        mov esi, dword [byte ebp-01Ch]
        add esi, byte 21h
        inc ebx
        mov dword [byte ebp-01Ch], esi
.8:
        xor eax, eax
        mov ax, word [GusActiveVoices]
        cmp ebx, eax
        jb short .1
        mov ecx, GusWaveVoices
        xor ebx, ebx
        jmp short .16
.9:
        test byte [byte ecx+013h], 1
        je short .15
        mov eax, dword [byte edx-02h]
        sar eax, 10h
        mov dword [byte ebp-024h], eax
        xor eax, eax
        jmp short .13
.10:
        mov esi, dword [byte edx+eax*2+010h]
        sar esi, 10h
        mov dword [byte ebp-018h], esi
        mov esi, dword [byte edx+eax*4+02h]
.11:
        cmp dword [byte ebp-018h], byte 0
        je short .12
        cmp esi, dword [ecx]
        je short .12
        mov edi, dword [byte ebp-018h]
        dec edi
        add esi, byte 49h
        mov dword [byte ebp-018h], edi
        jmp short .11
.12:
        cmp dword [byte ebp-018h], byte 0
        jne short .14
        inc eax
.13:
        cmp eax, dword [byte ebp-024h]
        jl short .10
.14:
        cmp eax, dword [byte ebp-024h]
        je short .15
        mov eax, ebx
        call GusVoiceStopWave
.15:
        inc ebx
        add ecx, byte 21h
.16:
        xor eax, eax
        mov ax, word [GusActiveVoices]
        cmp ebx, eax
        jb short .9
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-014h]
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Bh,0C0h
GusForgetPatch:
        push ebp
        mov ebp, esp
        push ebx
        push edx
        mov ebx, eax
        mov eax, GusMidiVoices+080h
        xor edx, edx
        cmp edx, byte 20h
        jl short .1
        lea esp, [byte ebp-08h]
        pop edx
        pop ebx
        pop ebp
        ret
.1:
        cmp ebx, dword [byte eax+04h]
        jne short .2
        mov dword [byte eax+04h], 0
.2:
        inc edx
        add eax, byte 10h
        cmp edx, byte 20h
        jl short .1
        lea esp, [byte ebp-08h]
        pop edx
        pop ebx
        pop ebp
        ret
        db 08Bh,0C0h
GusSetChannelPatch:
        push ebp
        mov ebp, esp
        shl edx, 4
        mov dword [dword edx+GusMidiVoices+084h], eax
        mov esp, ebp
        pop ebp
        ret
GusSetChannelPan:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push esi
        sub esp, byte 4
        mov ebx, eax
        mov dword [byte ebp-010h], edx
        mov eax, edx
        shl eax, 4
        cmp ebx, byte 0FFFFFFFFh
        jne short .1
        mov byte [dword eax+GusMidiVoices+088h], 10h
        jmp near .5
.1:
        mov esi, GusWaveVoices
        sar ebx, 3
        xor ecx, ecx
        mov byte [dword eax+GusMidiVoices+088h], bl
        pushfw
        cli
        call GusEnterCritical
        jmp short .4
.2:
        test byte [byte esi+013h], 1
        je short .3
        mov ah, byte [byte ebp-010h]
        cmp ah, byte [byte esi+01Dh]
        jne short .3
        xor eax, eax
        mov edx, ecx
        mov ax, word [GusVoiceSelectPort]
        call outp_
        xor eax, eax
        mov edx, 0Ch
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, ebx
        mov ax, word [GusDataHighPort]
        call outp_
.3:
        inc ecx
        add esi, byte 21h
.4:
        xor eax, eax
        mov ax, word [GusActiveVoices]
        cmp ecx, eax
        jb short .2
        call GusLeaveCritical
        popfw
.5:
        lea esp, [byte ebp-0Ch]
        pop esi
        pop ecx
        pop ebx
        pop ebp
        ret
        db 090h
GusChannelNotesOff:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        mov ecx, eax
        pushfw
        cli
        call GusEnterCritical
        mov ebx, GusWaveVoices
        xor edx, edx
        jmp short .3
.1:
        test byte [byte ebx+013h], 1
        je short .2
        cmp cl, byte [byte ebx+01Dh]
        jne short .2
        mov eax, edx
        call GusVoiceStopRamp
.2:
        inc edx
        add ebx, byte 21h
.3:
        xor eax, eax
        mov ax, word [GusActiveVoices]
        cmp edx, eax
        jb short .1
        mov ebx, GusWaveVoices
        xor edx, edx
        jmp short .6
.4:
        test byte [byte ebx+013h], 1
        je short .5
        cmp cl, byte [byte ebx+01Dh]
        jne short .5
        mov eax, edx
        call GusVoiceStopWave
.5:
        inc edx
        add ebx, byte 21h
.6:
        xor eax, eax
        mov ax, word [GusActiveVoices]
        cmp edx, eax
        jb short .4
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-0Ch]
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 00h,00h,00h,00h,00h,00h,00h
GusPokeBlock:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push esi
        mov ebx, eax
        pushfw
        cli
        call GusEnterCritical
        mov esi, edx
        xor ecx, ecx
        jmp short .2
.1:
        mov eax, ebx
        inc esi
        xor edx, edx
        inc ecx
        mov dl, byte [byte esi-01h]
        inc ebx
        call GusPoke
.2:
        cmp ecx, byte 0Fh
        jb short .1
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-0Ch]
        pop esi
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Dh,040h,00h
GusPeekBlock:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        mov ebx, eax
        pushfw
        cli
        call GusEnterCritical
        mov ecx, edx
        xor edx, edx
        jmp short .2
.1:
        mov eax, ebx
        call GusPeek
        inc ecx
        inc edx
        inc ebx
        mov byte [byte ecx-01h], al
.2:
        cmp edx, byte 0Fh
        jb short .1
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-08h]
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Dh,040h,00h
GusSizeDram:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        push esi
        sub esp, byte 10h
        mov byte [GusDramSized], 1
        xor edx, edx
        xor ebx, ebx
        mov word [GusDramSize], dx
.1:
        mov edx, ebx
        shl edx, 12h
        mov eax, edx
        call GusTestDramBank
        test al, al
        je short .2
        mov eax, 1
        mov esi, 0FFFFFFFFh
        mov cl, bl
        mov dword [byte ebp-01Ch], esi
        mov dword [byte ebp-018h], esi
        shl eax, cl
        mov cx, word [GusDramSize]
        xor esi, esi
        or ecx, eax
        mov word [byte ebp-014h], si
        mov word [GusDramSize], cx
        mov ecx, 40000h
        mov eax, edx
        mov dword [byte ebp-020h], ecx
        xor cl, cl
        lea edx, [byte ebp-020h]
        mov byte [byte ebp-012h], cl
        call GusPokeBlock
.2:
        inc ebx
        cmp ebx, byte 4
        jl short .1
        cmp word [GusDramSize], byte 0
        jne short .3
        mov eax, 6
        jmp short .4
.3:
        mov eax, 1Eh
        xor edx, edx
        call GusPoke
        mov eax, 1Fh
        xor edx, edx
        call GusPoke
        xor eax, eax
.4:
        lea esp, [byte ebp-010h]
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 090h
GusDramAlloc:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 24h
        mov esi, eax
        lea esi, [byte eax+01Fh]
        pushfw
        cli
        call GusEnterCritical
        xor edx, edx
        and esi, 0FFFFE0h
        mov dword [byte ebp-018h], edx
        add esi, byte 20h
.1:
        mov cl, byte [byte ebp-018h]
        xor edx, edx
        mov eax, 1
        mov dx, word [GusDramSize]
        shl eax, cl
        test edx, eax
        je near .6
        mov ebx, dword [byte ebp-018h]
        shl ebx, 12h
.2:
        cmp ebx, byte 0FFFFFFFFh
        je near .6
        lea edx, [byte ebp-038h]
        mov eax, ebx
        call GusPeekBlock
        mov ah, byte [byte ebp-02Ah]
        test ah, 1
        jne near .5
        mov ecx, dword [byte ebp-038h]
        cmp esi, ecx
        ja near .5
        mov dl, ah
        or dl, 1
        mov byte [byte ebp-02Ah], dl
        mov edx, ecx
        sub edx, esi
        cmp edx, byte 40h
        jae short .3
        lea edx, [byte ebp-038h]
        mov eax, ebx
        call GusPokeBlock
        call GusLeaveCritical
        popfw
        lea eax, [byte ebx+020h]
        jmp near .7
.3:
        mov eax, dword [byte ebp-034h]
        mov dword [byte ebp-020h], ebx
        mov dword [byte ebp-028h], edx
        xor edx, edx
        mov dword [byte ebp-024h], eax
        mov word [byte ebp-01Ch], dx
        lea eax, [ebx+esi]
        xor dh, dh
        mov dword [byte ebp-034h], eax
        mov byte [byte ebp-01Ah], dh
        mov eax, ebx
        lea edx, [byte ebp-038h]
        mov dword [byte ebp-038h], esi
        call GusPokeBlock
        mov eax, dword [byte ebp-034h]
        lea edx, [byte ebp-028h]
        call GusPokeBlock
        mov esi, dword [byte ebp-024h]
        cmp esi, byte 0FFFFFFFFh
        je short .4
        lea edx, [byte ebp-028h]
        mov eax, esi
        call GusPeekBlock
        mov eax, dword [byte ebp-034h]
        lea edx, [byte ebp-028h]
        mov dword [byte ebp-020h], eax
        mov eax, esi
        call GusPokeBlock
.4:
        call GusLeaveCritical
        popfw
        lea eax, [byte ebx+020h]
        lea esp, [byte ebp-014h]
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
.5:
        mov ebx, dword [byte ebp-034h]
        jmp near .2
.6:
        mov edi, dword [byte ebp-018h]
        inc edi
        mov dword [byte ebp-018h], edi
        cmp edi, byte 4
        jl near .1
        call GusLeaveCritical
        popfw
        xor eax, eax
.7:
        lea esp, [byte ebp-014h]
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Dh,040h,00h
GusDramFree:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        push edi
        sub esp, byte 30h
        mov ebx, eax
        lea edx, [byte ebp-020h]
        lea ebx, [byte eax-020h]
        pushfw
        cli
        call GusEnterCritical
        mov eax, ebx
        call GusPeekBlock
        mov edx, dword [byte ebp-018h]
        cmp edx, byte 0FFFFFFFFh
        je short .2
        mov eax, edx
        lea edx, [byte ebp-040h]
        call GusPeekBlock
        test byte [byte ebp-032h], 1
        jne short .2
        mov eax, dword [byte ebp-020h]
        mov ecx, dword [byte ebp-040h]
        mov ebx, dword [byte ebp-018h]
        add ecx, eax
        mov eax, dword [byte ebp-01Ch]
        mov dword [byte ebp-040h], ecx
        mov dword [byte ebp-03Ch], eax
        cmp eax, byte 0FFFFFFFFh
        je short .1
        lea edx, [byte ebp-030h]
        call GusPeekBlock
        mov eax, dword [byte ebp-03Ch]
        lea edx, [byte ebp-030h]
        mov dword [byte ebp-028h], ebx
        call GusPokeBlock
.1:
        lea edx, [byte ebp-040h]
        mov eax, ebx
        call GusPokeBlock
        lea edx, [byte ebp-020h]
        mov eax, ebx
        call GusPeekBlock
.2:
        mov edi, dword [byte ebp-01Ch]
        cmp edi, byte 0FFFFFFFFh
        je short .3
        lea edx, [byte ebp-030h]
        mov eax, edi
        call GusPeekBlock
        test byte [byte ebp-022h], 1
        jne short .3
        mov eax, dword [byte ebp-030h]
        mov edx, dword [byte ebp-020h]
        add edx, eax
        mov eax, dword [byte ebp-02Ch]
        mov dword [byte ebp-020h], edx
        mov dword [byte ebp-01Ch], eax
        cmp eax, byte 0FFFFFFFFh
        je short .3
        lea edx, [byte ebp-030h]
        call GusPeekBlock
        mov eax, dword [byte ebp-01Ch]
        lea edx, [byte ebp-030h]
        mov dword [byte ebp-028h], ebx
        call GusPokeBlock
.3:
        mov dh, byte [byte ebp-012h]
        and dh, 0FEh
        mov eax, ebx
        mov byte [byte ebp-012h], dh
        lea edx, [byte ebp-020h]
        call GusPokeBlock
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-010h]
        pop edi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 090h
GusDramFreeTotal:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        push esi
        sub esp, byte 10h
        pushfw
        cli
        call GusEnterCritical
        xor esi, esi
        xor ebx, ebx
.1:
        mov eax, 1
        xor edx, edx
        mov cl, bl
        mov dx, word [GusDramSize]
        shl eax, cl
        test edx, eax
        je short .4
        mov eax, ebx
        shl eax, 12h
.2:
        cmp eax, byte 0FFFFFFFFh
        je short .4
        lea edx, [byte ebp-020h]
        call GusPeekBlock
        test byte [byte ebp-012h], 1
        jne short .3
        add esi, dword [byte ebp-020h]
.3:
        mov eax, dword [byte ebp-01Ch]
        jmp short .2
.4:
        inc ebx
        cmp ebx, byte 4
        jl short .1
        call GusLeaveCritical
        popfw
        mov eax, esi
        lea esp, [byte ebp-010h]
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
GusDramLargestFree:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        push esi
        sub esp, byte 10h
        pushfw
        cli
        call GusEnterCritical
        xor esi, esi
        xor ebx, ebx
.1:
        mov eax, 1
        xor edx, edx
        mov cl, bl
        mov dx, word [GusDramSize]
        shl eax, cl
        test edx, eax
        je short .4
        mov eax, ebx
        shl eax, 12h
.2:
        cmp eax, byte 0FFFFFFFFh
        je short .4
        lea edx, [byte ebp-020h]
        call GusPeekBlock
        test byte [byte ebp-012h], 1
        jne short .3
        mov edx, dword [byte ebp-020h]
        cmp esi, edx
        jae short .3
        mov esi, edx
.3:
        mov eax, dword [byte ebp-01Ch]
        jmp short .2
.4:
        inc ebx
        cmp ebx, byte 4
        jl short .1
        call GusLeaveCritical
        popfw
        cmp esi, byte 20h
        jbe short .5
        lea eax, [byte esi-020h]
        jmp short .6
.5:
        xor eax, eax
.6:
        lea esp, [byte ebp-010h]
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
GusMixAdd8:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFF8h
        push ebx
        mov dword [byte ebp-04h], eax
        mov dword [byte ebp-08h], edx
        mov edx, dword [byte ebp+08h]
        cmp eax, byte 40h
        jb near .2
.1:
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        sub dword [byte ebp-04h], byte 40h
        cmp dword [byte ebp-04h], byte 40h
        jae near .1
.2:
        cmp dword [byte ebp-04h], byte 0
        je short .3
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        dec dword [byte ebp-04h]
        jmp short .2
.3:
        mov edx, dword [byte ebp-08h]
        pop ebx
        leave
        ret
GusClearMixBuffer:
        cmp ecx, 100h
        jb near .2
        LD xor, eax, eax
        LD mov, edi, ebx
        mov edx, 8
        add ebx, byte 4
.1:
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        sub ecx, 100h
        cmp ecx, 100h
        jae near .1
.2:
        LD or, ecx, ecx
        je short .5
        cld
        test ecx, 3
        je short .4
        test ecx, 1
        je short .3
        stosb
        test ecx, 2
        je short .4
.3:
        stosw
.4:
        shr ecx, 2
        rep stosd
.5:
        LD mov, ebx, edi
        ret
