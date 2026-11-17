; Gravis UltraSound: audio streams.
bits 32
%include "hockey.inc"
section s_ADEE9 progbits alloc exec nowrite align=1
extern getenv_, GusAllocVoice, GusChanBendCents, GusChanBendRange, GusChanExpression, GusChannelNotesOff, GusChanRpnLsb, GusChanRpnMsb
extern GusChanVolume, GusClaimVoiceCallbacks, GusClearMixBuffer, GusDataHighPort, GusDataLowPort, GusDownload, GusDramPort, GusEnvConfig
extern GusEnvVarName, GusFillCount, GusFillDest, GusFillScratch, GusMixAdd8, GusPitchTable, GusPoke, GusRegSelectPort
extern GusSetChannelBend, GusSetChannelModulation, GusSetChannelPan, GusSetChannelVolume, GusSetSustain, GusStreamActive, GusStreamBufShift, GusStreamBufSize
extern GusStreamBusyLeft, GusStreamBusyRight, GusStreamCardEnd, GusStreamCardLeft, GusStreamCardRight, GusStreamChannels, GusStreamEndHi, GusStreamEndLo
extern GusStreamHalfShift, GusStreamHalfSize, GusStreamLeftBuf, GusStreamLeftPending, GusStreamLoopHi, GusStreamLoopLo, GusStreamNoOp, GusStreamQuarterLog2
extern GusStreamQuarterSize, GusStreamRightBuf, GusStreamRightPending, GusStreamStartHi, GusStreamStartLo, GusStreamState, GusStreamStepsChan0, GusStreamStepsChan1
extern GusStreamStepsChan2, GusStreamStepsChan3, GusStreamTable, GusStreamVoiceLeft, GusStreamVoiceRight, GusVoiceSelectPort, inp_, MixVolumeTable
extern NotePitchTable, outp_, strtoul_
global GusFillStreamBuffer, GusStreamVoiceIrq, GusServiceStream, GusStartStream, GusStopStream, GusStreamStart, GusStreamIdle, GusStreamPlayNote
global GusStreamRelease, GusStreamStop, GusStreamSetVolume, GusStreamSetBend, GusStreamSetRate, GusStreamSetSample, GusStreamApplyBend, GusStreamBusy
global GusStreamGetVolume, GusGetEnvConfig, GusProbePort, GusMidiPitchBend, GusMidiController
;-----------------------------------------------------------------------------
; GusFillStreamBuffer                             ADEE9  95 PC, low confidence
; Mixes the software stream channels into one half of the GUS stream buffer
;-----------------------------------------------------------------------------
GusFillStreamBuffer:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFF0h
        push esi
        push edi
        push ebx
        LD or, eax, eax
        jne short .2
        mov eax, dword [GusStreamLeftBuf]
        mov dword [GusFillCount], eax
        cmp dword [GusStreamState], byte 0
        je short .1
        mov dword [GusStreamLeftPending], 2
        jmp short .4
.1:
        cmp dword [GusStreamLeftPending], byte 0
        je near .71
        dec dword [GusStreamLeftPending]
        jmp short .4
.2:
        mov eax, dword [GusStreamRightBuf]
        mov dword [GusFillCount], eax
        cmp dword [GusStreamState], byte 0
        je short .3
        mov dword [GusStreamRightPending], 2
        jmp short .4
.3:
        cmp dword [GusStreamRightPending], byte 0
        je near .71
        dec dword [GusStreamLeftPending]
        jmp short .4
.4:
        mov ebx, dword [GusFillCount]
        mov ecx, dword [GusStreamQuarterSize]
        call GusClearMixBuffer
        cmp byte [GusStreamChannels], 0
        je near .20
        cmp byte [GusStreamChannels+0Ch], 0
        jne near .11
        mov edx, dword [GusStreamChannels+040h]
        mov eax, dword [GusStreamChannels+044h]
        mov ecx, dword [GusStreamQuarterLog2]
        shld edx, eax, cl
        shl eax, cl
        add eax, dword [GusStreamChannels+03Ch]
        adc edx, dword [GusStreamChannels+038h]
        cmp edx, dword [GusStreamChannels+028h]
        jae short .6
        mov eax, dword [GusStreamChannels+038h]
        LD mov, esi, eax
        mov dword [byte ebp-010h], esi
        mov ecx, dword [GusStreamChannels+03Ch]
        mov edi, dword [GusStreamChannels+040h]
        mov edx, dword [GusStreamChannels+044h]
        mov ebx, GusStreamStepsChan0
        mov eax, dword [GusStreamQuarterSize]
        push dword [GusFillCount]
        call GusMixAdd8
        add esp, byte 4
.5:
        mov dword [GusStreamChannels+03Ch], ecx
        sub esi, dword [byte ebp-010h]
        add dword [GusStreamChannels+038h], esi
        jmp near .20
.6:
        mov dword [byte ebp-04h], 0
.7:
        mov eax, dword [GusStreamChannels+038h]
        mov ebx, dword [GusStreamChannels+028h]
        LD sub, ebx, eax
        mov dword [byte ebp-08h], ebx
        LD mov, esi, eax
        mov dword [byte ebp-010h], eax
        add eax, dword [byte ebp-08h]
        mov dword [byte ebp-0Ch], eax
        mov ecx, dword [GusStreamChannels+03Ch]
        mov edi, dword [GusStreamChannels+040h]
        mov edx, dword [GusStreamChannels+044h]
.8:
        movzx eax, byte [esi]
        mov ebx, GusStreamStepsChan0
        mov ax, word [ebx+eax*2]
        mov ebx, dword [byte ebp-04h]
        shl ebx, 1
        add ebx, dword [GusFillCount]
        add word [ebx], ax
        inc dword [byte ebp-04h]
        LD add, ecx, edx
        LD adc, esi, edi
        cmp esi, dword [byte ebp-0Ch]
        jae short .9
        mov eax, dword [GusStreamQuarterSize]
        cmp eax, dword [byte ebp-04h]
        jne short .8
        jmp short .5
.9:
        cmp dword [GusStreamChannels], byte 1
        jne short .10
        cmp dword [GusStreamChannels+010h], byte 0
        je short .10
        mov eax, dword [GusStreamChannels+024h]
        mov dword [GusStreamChannels+03Ch], ecx
        mov dword [GusStreamChannels+038h], eax
        mov eax, dword [GusStreamQuarterSize]
        cmp dword [byte ebp-04h], eax
        jne near .7
        jmp near .20
.10:
        mov dword [GusStreamChannels], 0
        jmp near .20
.11:
        mov esi, dword [GusStreamChannels+038h]
        mov ecx, dword [GusStreamChannels+028h]
        LD sub, ecx, esi
        cmp ecx, dword [GusStreamChannels+054h]
        jbe short .12
        mov ecx, dword [GusStreamChannels+054h]
.12:
        LD add, ecx, esi
        mov dword [byte ebp-04h], ecx
        LD xor, ecx, ecx
        LD xor, edx, edx
        mov dl, byte [GusStreamChannels+04Ch]
        mov edi, dword [GusFillCount]
.13:
        mov eax, dword [GusStreamChannels+02Ch]
        cmp eax, 10000h
        je short .15
.14:
        movzx ebx, byte [esi]
        mov bx, word [nosplit ebx*2+MixVolumeTable]
        LD add, dl, bl
        mov ax, word [nosplit edx*2+GusStreamStepsChan0]
        add word [edi+ecx*2], ax
        inc ecx
        add word [edi+ecx*2], ax
        inc ecx
        LD add, dl, bh
        mov ax, word [nosplit edx*2+GusStreamStepsChan0]
        add word [edi+ecx*2], ax
        inc ecx
        add word [edi+ecx*2], ax
        inc ecx
        inc esi
        cmp esi, dword [byte ebp-04h]
        jb short .14
        jmp short .16
.15:
        movzx ebx, byte [esi]
        mov bx, word [nosplit ebx*2+MixVolumeTable]
        LD add, dl, bl
        mov ax, word [nosplit edx*2+GusStreamStepsChan0]
        add word [edi+ecx*2], ax
        inc ecx
        LD add, dl, bh
        mov ax, word [nosplit edx*2+GusStreamStepsChan0]
        add word [edi+ecx*2], ax
        inc ecx
        inc esi
        cmp esi, dword [byte ebp-04h]
        jb short .15
.16:
        cmp esi, dword [GusStreamChannels+028h]
        je short .17
        mov byte [GusStreamChannels+04Ch], dl
        mov dword [GusStreamChannels+038h], esi
        jmp short .20
.17:
        cmp dword [GusStreamChannels], byte 1
        jne short .19
        cmp dword [GusStreamChannels+010h], byte 0
        je short .19
        mov dl, byte [GusStreamChannels+050h]
        mov byte [GusStreamChannels+04Ch], dl
        mov eax, dword [GusStreamChannels+038h]
        add eax, dword [GusStreamChannels+054h]
        LD sub, eax, esi
        LD or, eax, eax
        je short .18
        mov esi, dword [GusStreamChannels+024h]
        LD add, eax, esi
        mov dword [byte ebp-04h], eax
        jmp near .13
.18:
        mov eax, dword [GusStreamChannels+024h]
        mov dword [GusStreamChannels+038h], eax
        jmp short .20
.19:
        mov dword [GusStreamChannels], 0
.20:
        cmp byte [GusStreamChannels+0258h], 0
        je near .36
        cmp byte [GusStreamChannels+0264h], 0
        jne near .27
        mov edx, dword [GusStreamChannels+0298h]
        mov eax, dword [GusStreamChannels+029Ch]
        mov ecx, dword [GusStreamQuarterLog2]
        shld edx, eax, cl
        shl eax, cl
        add eax, dword [GusStreamChannels+0294h]
        adc edx, dword [GusStreamChannels+0290h]
        cmp edx, dword [GusStreamChannels+0280h]
        jae short .22
        mov eax, dword [GusStreamChannels+0290h]
        LD mov, esi, eax
        mov dword [byte ebp-010h], esi
        mov ecx, dword [GusStreamChannels+0294h]
        mov edi, dword [GusStreamChannels+0298h]
        mov edx, dword [GusStreamChannels+029Ch]
        mov ebx, GusStreamStepsChan1
        mov eax, dword [GusStreamQuarterSize]
        push dword [GusFillCount]
        call GusMixAdd8
        add esp, byte 4
.21:
        mov dword [GusStreamChannels+0294h], ecx
        sub esi, dword [byte ebp-010h]
        add dword [GusStreamChannels+0290h], esi
        jmp near .36
.22:
        mov dword [byte ebp-04h], 0
.23:
        mov eax, dword [GusStreamChannels+0290h]
        mov ebx, dword [GusStreamChannels+0280h]
        LD sub, ebx, eax
        mov dword [byte ebp-08h], ebx
        LD mov, esi, eax
        mov dword [byte ebp-010h], eax
        add eax, dword [byte ebp-08h]
        mov dword [byte ebp-0Ch], eax
        mov ecx, dword [GusStreamChannels+0294h]
        mov edi, dword [GusStreamChannels+0298h]
        mov edx, dword [GusStreamChannels+029Ch]
.24:
        movzx eax, byte [esi]
        mov ebx, GusStreamStepsChan1
        mov ax, word [ebx+eax*2]
        mov ebx, dword [byte ebp-04h]
        shl ebx, 1
        add ebx, dword [GusFillCount]
        add word [ebx], ax
        inc dword [byte ebp-04h]
        LD add, ecx, edx
        LD adc, esi, edi
        cmp esi, dword [byte ebp-0Ch]
        jae short .25
        mov eax, dword [GusStreamQuarterSize]
        cmp eax, dword [byte ebp-04h]
        jne short .24
        jmp short .21
.25:
        cmp dword [GusStreamChannels+0258h], byte 1
        jne short .26
        cmp dword [GusStreamChannels+0268h], byte 0
        je short .26
        mov eax, dword [GusStreamChannels+027Ch]
        mov dword [GusStreamChannels+0294h], ecx
        mov dword [GusStreamChannels+0290h], eax
        mov eax, dword [GusStreamQuarterSize]
        cmp dword [byte ebp-04h], eax
        jne near .23
        jmp near .36
.26:
        mov dword [GusStreamChannels+0258h], 0
        jmp near .36
.27:
        mov esi, dword [GusStreamChannels+0290h]
        mov ecx, dword [GusStreamChannels+0280h]
        LD sub, ecx, esi
        cmp ecx, dword [GusStreamChannels+02ACh]
        jbe short .28
        mov ecx, dword [GusStreamChannels+02ACh]
.28:
        LD add, ecx, esi
        mov dword [byte ebp-04h], ecx
        LD xor, ecx, ecx
        LD xor, edx, edx
        mov dl, byte [GusStreamChannels+02A4h]
        mov edi, dword [GusFillCount]
.29:
        mov eax, dword [GusStreamChannels+0284h]
        cmp eax, 10000h
        je short .31
.30:
        movzx ebx, byte [esi]
        mov bx, word [nosplit ebx*2+MixVolumeTable]
        LD add, dl, bl
        mov ax, word [nosplit edx*2+GusStreamStepsChan1]
        add word [edi+ecx*2], ax
        inc ecx
        add word [edi+ecx*2], ax
        inc ecx
        LD add, dl, bh
        mov ax, word [nosplit edx*2+GusStreamStepsChan1]
        add word [edi+ecx*2], ax
        inc ecx
        add word [edi+ecx*2], ax
        inc ecx
        inc esi
        cmp esi, dword [byte ebp-04h]
        jb short .30
        jmp short .32
.31:
        movzx ebx, byte [esi]
        mov bx, word [nosplit ebx*2+MixVolumeTable]
        LD add, dl, bl
        mov ax, word [nosplit edx*2+GusStreamStepsChan1]
        add word [edi+ecx*2], ax
        inc ecx
        LD add, dl, bh
        mov ax, word [nosplit edx*2+GusStreamStepsChan1]
        add word [edi+ecx*2], ax
        inc ecx
        inc esi
        cmp esi, dword [byte ebp-04h]
        jb short .31
.32:
        cmp esi, dword [GusStreamChannels+0280h]
        je short .33
        mov byte [GusStreamChannels+02A4h], dl
        mov dword [GusStreamChannels+0290h], esi
        jmp short .36
.33:
        cmp dword [GusStreamChannels+0258h], byte 1
        jne short .35
        cmp dword [GusStreamChannels+0268h], byte 0
        je short .35
        mov dl, byte [GusStreamChannels+02A8h]
        mov byte [GusStreamChannels+02A4h], dl
        mov eax, dword [GusStreamChannels+0290h]
        add eax, dword [GusStreamChannels+02ACh]
        LD sub, eax, esi
        LD or, eax, eax
        je short .34
        mov esi, dword [GusStreamChannels+027Ch]
        LD add, eax, esi
        mov dword [byte ebp-04h], eax
        jmp near .29
.34:
        mov eax, dword [GusStreamChannels+027Ch]
        mov dword [GusStreamChannels+0290h], eax
        jmp short .36
.35:
        mov dword [GusStreamChannels+0258h], 0
.36:
        cmp byte [GusStreamChannels+04B0h], 0
        je near .52
        cmp byte [GusStreamChannels+04BCh], 0
        jne near .43
        mov edx, dword [GusStreamChannels+04F0h]
        mov eax, dword [GusStreamChannels+04F4h]
        mov ecx, dword [GusStreamQuarterLog2]
        shld edx, eax, cl
        shl eax, cl
        add eax, dword [GusStreamChannels+04ECh]
        adc edx, dword [GusStreamChannels+04E8h]
        cmp edx, dword [GusStreamChannels+04D8h]
        jae short .38
        mov eax, dword [GusStreamChannels+04E8h]
        LD mov, esi, eax
        mov dword [byte ebp-010h], esi
        mov ecx, dword [GusStreamChannels+04ECh]
        mov edi, dword [GusStreamChannels+04F0h]
        mov edx, dword [GusStreamChannels+04F4h]
        mov ebx, GusStreamStepsChan2
        mov eax, dword [GusStreamQuarterSize]
        push dword [GusFillCount]
        call GusMixAdd8
        add esp, byte 4
.37:
        mov dword [GusStreamChannels+04ECh], ecx
        sub esi, dword [byte ebp-010h]
        add dword [GusStreamChannels+04E8h], esi
        jmp near .52
.38:
        mov dword [byte ebp-04h], 0
.39:
        mov eax, dword [GusStreamChannels+04E8h]
        mov ebx, dword [GusStreamChannels+04D8h]
        LD sub, ebx, eax
        mov dword [byte ebp-08h], ebx
        LD mov, esi, eax
        mov dword [byte ebp-010h], eax
        add eax, dword [byte ebp-08h]
        mov dword [byte ebp-0Ch], eax
        mov ecx, dword [GusStreamChannels+04ECh]
        mov edi, dword [GusStreamChannels+04F0h]
        mov edx, dword [GusStreamChannels+04F4h]
.40:
        movzx eax, byte [esi]
        mov ebx, GusStreamStepsChan2
        mov ax, word [ebx+eax*2]
        mov ebx, dword [byte ebp-04h]
        shl ebx, 1
        add ebx, dword [GusFillCount]
        add word [ebx], ax
        inc dword [byte ebp-04h]
        LD add, ecx, edx
        LD adc, esi, edi
        cmp esi, dword [byte ebp-0Ch]
        jae short .41
        mov eax, dword [GusStreamQuarterSize]
        cmp eax, dword [byte ebp-04h]
        jne short .40
        jmp short .37
.41:
        cmp dword [GusStreamChannels+04B0h], byte 1
        jne short .42
        cmp dword [GusStreamChannels+04C0h], byte 0
        je short .42
        mov eax, dword [GusStreamChannels+04D4h]
        mov dword [GusStreamChannels+04ECh], ecx
        mov dword [GusStreamChannels+04E8h], eax
        mov eax, dword [GusStreamQuarterSize]
        cmp dword [byte ebp-04h], eax
        jne near .39
        jmp near .52
.42:
        mov dword [GusStreamChannels+04B0h], 0
        jmp near .52
.43:
        mov esi, dword [GusStreamChannels+04E8h]
        mov ecx, dword [GusStreamChannels+04D8h]
        LD sub, ecx, esi
        cmp ecx, dword [GusStreamChannels+0504h]
        jbe short .44
        mov ecx, dword [GusStreamChannels+0504h]
.44:
        LD add, ecx, esi
        mov dword [byte ebp-04h], ecx
        LD xor, ecx, ecx
        LD xor, edx, edx
        mov dl, byte [GusStreamChannels+04FCh]
        mov edi, dword [GusFillCount]
.45:
        mov eax, dword [GusStreamChannels+04DCh]
        cmp eax, 10000h
        je short .47
.46:
        movzx ebx, byte [esi]
        mov bx, word [nosplit ebx*2+MixVolumeTable]
        LD add, dl, bl
        mov ax, word [nosplit edx*2+GusStreamStepsChan2]
        add word [edi+ecx*2], ax
        inc ecx
        add word [edi+ecx*2], ax
        inc ecx
        LD add, dl, bh
        mov ax, word [nosplit edx*2+GusStreamStepsChan2]
        add word [edi+ecx*2], ax
        inc ecx
        add word [edi+ecx*2], ax
        inc ecx
        inc esi
        cmp esi, dword [byte ebp-04h]
        jb short .46
        jmp short .48
.47:
        movzx ebx, byte [esi]
        mov bx, word [nosplit ebx*2+MixVolumeTable]
        LD add, dl, bl
        mov ax, word [nosplit edx*2+GusStreamStepsChan2]
        add word [edi+ecx*2], ax
        inc ecx
        LD add, dl, bh
        mov ax, word [nosplit edx*2+GusStreamStepsChan2]
        add word [edi+ecx*2], ax
        inc ecx
        inc esi
        cmp esi, dword [byte ebp-04h]
        jb short .47
.48:
        cmp esi, dword [GusStreamChannels+04D8h]
        je short .49
        mov byte [GusStreamChannels+04FCh], dl
        mov dword [GusStreamChannels+04E8h], esi
        jmp short .52
.49:
        cmp dword [GusStreamChannels+04B0h], byte 1
        jne short .51
        cmp dword [GusStreamChannels+04C0h], byte 0
        je short .51
        mov dl, byte [GusStreamChannels+0500h]
        mov byte [GusStreamChannels+04FCh], dl
        mov eax, dword [GusStreamChannels+04E8h]
        add eax, dword [GusStreamChannels+0504h]
        LD sub, eax, esi
        LD or, eax, eax
        je short .50
        mov esi, dword [GusStreamChannels+04D4h]
        LD add, eax, esi
        mov dword [byte ebp-04h], eax
        jmp near .45
.50:
        mov eax, dword [GusStreamChannels+04D4h]
        mov dword [GusStreamChannels+04E8h], eax
        jmp short .52
.51:
        mov dword [GusStreamChannels+04B0h], 0
.52:
        cmp byte [GusStreamChannels+0708h], 0
        je near .68
        cmp byte [GusStreamChannels+0714h], 0
        jne near .59
        mov edx, dword [GusStreamChannels+0748h]
        mov eax, dword [GusStreamChannels+074Ch]
        mov ecx, dword [GusStreamQuarterLog2]
        shld edx, eax, cl
        shl eax, cl
        add eax, dword [GusStreamChannels+0744h]
        adc edx, dword [GusStreamChannels+0740h]
        cmp edx, dword [GusStreamChannels+0730h]
        jae short .54
        mov eax, dword [GusStreamChannels+0740h]
        LD mov, esi, eax
        mov dword [byte ebp-010h], esi
        mov ecx, dword [GusStreamChannels+0744h]
        mov edi, dword [GusStreamChannels+0748h]
        mov edx, dword [GusStreamChannels+074Ch]
        mov ebx, GusStreamStepsChan3
        mov eax, dword [GusStreamQuarterSize]
        push dword [GusFillCount]
        call GusMixAdd8
        add esp, byte 4
.53:
        mov dword [GusStreamChannels+0744h], ecx
        sub esi, dword [byte ebp-010h]
        add dword [GusStreamChannels+0740h], esi
        jmp near .68
.54:
        mov dword [byte ebp-04h], 0
.55:
        mov eax, dword [GusStreamChannels+0740h]
        mov ebx, dword [GusStreamChannels+0730h]
        LD sub, ebx, eax
        mov dword [byte ebp-08h], ebx
        LD mov, esi, eax
        mov dword [byte ebp-010h], eax
        add eax, dword [byte ebp-08h]
        mov dword [byte ebp-0Ch], eax
        mov ecx, dword [GusStreamChannels+0744h]
        mov edi, dword [GusStreamChannels+0748h]
        mov edx, dword [GusStreamChannels+074Ch]
.56:
        movzx eax, byte [esi]
        mov ebx, GusStreamStepsChan3
        mov ax, word [ebx+eax*2]
        mov ebx, dword [byte ebp-04h]
        shl ebx, 1
        add ebx, dword [GusFillCount]
        add word [ebx], ax
        inc dword [byte ebp-04h]
        LD add, ecx, edx
        LD adc, esi, edi
        cmp esi, dword [byte ebp-0Ch]
        jae short .57
        mov eax, dword [GusStreamQuarterSize]
        cmp eax, dword [byte ebp-04h]
        jne short .56
        jmp short .53
.57:
        cmp dword [GusStreamChannels+0708h], byte 1
        jne short .58
        cmp dword [GusStreamChannels+0718h], byte 0
        je short .58
        mov eax, dword [GusStreamChannels+072Ch]
        mov dword [GusStreamChannels+0744h], ecx
        mov dword [GusStreamChannels+0740h], eax
        mov eax, dword [GusStreamQuarterSize]
        cmp dword [byte ebp-04h], eax
        jne near .55
        jmp near .68
.58:
        mov dword [GusStreamChannels+0708h], 0
        jmp near .68
.59:
        mov esi, dword [GusStreamChannels+0740h]
        mov ecx, dword [GusStreamChannels+0730h]
        LD sub, ecx, esi
        cmp ecx, dword [GusStreamChannels+075Ch]
        jbe short .60
        mov ecx, dword [GusStreamChannels+075Ch]
.60:
        LD add, ecx, esi
        mov dword [byte ebp-04h], ecx
        LD xor, ecx, ecx
        LD xor, edx, edx
        mov dl, byte [GusStreamChannels+0754h]
        mov edi, dword [GusFillCount]
.61:
        mov eax, dword [GusStreamChannels+0734h]
        cmp eax, 10000h
        je short .63
.62:
        movzx ebx, byte [esi]
        mov bx, word [nosplit ebx*2+MixVolumeTable]
        LD add, dl, bl
        mov ax, word [nosplit edx*2+GusStreamStepsChan3]
        add word [edi+ecx*2], ax
        inc ecx
        add word [edi+ecx*2], ax
        inc ecx
        LD add, dl, bh
        mov ax, word [nosplit edx*2+GusStreamStepsChan3]
        add word [edi+ecx*2], ax
        inc ecx
        add word [edi+ecx*2], ax
        inc ecx
        inc esi
        cmp esi, dword [byte ebp-04h]
        jb short .62
        jmp short .64
.63:
        movzx ebx, byte [esi]
        mov bx, word [nosplit ebx*2+MixVolumeTable]
        LD add, dl, bl
        mov ax, word [nosplit edx*2+GusStreamStepsChan3]
        add word [edi+ecx*2], ax
        inc ecx
        LD add, dl, bh
        mov ax, word [nosplit edx*2+GusStreamStepsChan3]
        add word [edi+ecx*2], ax
        inc ecx
        inc esi
        cmp esi, dword [byte ebp-04h]
        jb short .63
.64:
        cmp esi, dword [GusStreamChannels+0730h]
        je short .65
        mov byte [GusStreamChannels+0754h], dl
        mov dword [GusStreamChannels+0740h], esi
        jmp short .68
.65:
        cmp dword [GusStreamChannels+0708h], byte 1
        jne short .67
        cmp dword [GusStreamChannels+0718h], byte 0
        je short .67
        mov dl, byte [GusStreamChannels+0758h]
        mov byte [GusStreamChannels+0754h], dl
        mov eax, dword [GusStreamChannels+0740h]
        add eax, dword [GusStreamChannels+075Ch]
        LD sub, eax, esi
        LD or, eax, eax
        je short .66
        mov esi, dword [GusStreamChannels+072Ch]
        LD add, eax, esi
        mov dword [byte ebp-04h], eax
        jmp near .61
.66:
        mov eax, dword [GusStreamChannels+072Ch]
        mov dword [GusStreamChannels+0740h], eax
        jmp short .68
.67:
        mov dword [GusStreamChannels+0708h], 0
.68:
        mov ebx, dword [GusFillCount]
        mov ecx, dword [GusStreamQuarterSize]
        call GusStreamNoOp
        mov eax, dword [GusFillCount]
        mov dword [GusFillScratch], eax
        mov dword [GusFillDest], eax
        cmp eax, dword [GusStreamLeftBuf]
        jne short .69
        LD mov, esi, eax
        movzx edx, byte [esi]
        mov eax, dword [GusStreamCardEnd]
        call GusPoke
        movzx edx, byte [byte esi+01h]
        mov eax, dword [GusStreamCardEnd]
        inc eax
        call GusPoke
        mov ebx, dword [GusStreamCardLeft]
        jmp short .70
.69:
        mov ebx, dword [GusStreamCardRight]
.70:
        mov eax, 1
        push eax
        mov eax, GusFillScratch
        mov edx, dword [GusStreamHalfSize]
        mov ecx, 41h
        call GusDownload
.71:
        pop ebx
        pop edi
        pop esi
        leave
        ret
;-----------------------------------------------------------------------------
; GusStreamVoiceIrq                               AE903  95 PC, low confidence
; Voice interrupt callback for the stream voices: loops them back to the
; buffer start
;-----------------------------------------------------------------------------
GusStreamVoiceIrq:
        cmp dword [GusStreamActive], byte 0
        je near .3
        cmp eax, dword [GusStreamVoiceLeft]
        je short .1
        cmp eax, dword [GusStreamVoiceRight]
        jne near .3
        pushf
        cli
        mov dx, word [GusVoiceSelectPort]
        mov al, byte [GusStreamVoiceRight]
        out dx, al
        mov al, 0
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov al, 3
        mov dx, word [GusDataHighPort]
        out dx, al
        push ax
        push dx
        mov dx, word [GusDramPort]
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        pop dx
        pop ax
        out dx, al
        popf
        mov dword [GusStreamBusyLeft], 1
        jmp short .2
.1:
        pushf
        cli
        mov dx, word [GusVoiceSelectPort]
        mov al, byte [GusStreamVoiceRight]
        out dx, al
        mov al, 0Bh
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov ax, word [GusStreamLoopLo]
        mov dx, word [GusDataLowPort]
        out dx, ax
        mov al, 0Ah
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov ax, word [GusStreamLoopHi]
        mov dx, word [GusDataLowPort]
        out dx, ax
        mov al, 0
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov al, 24h
        mov dx, word [GusDataHighPort]
        out dx, al
        push ax
        push dx
        mov dx, word [GusDramPort]
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        pop dx
        pop ax
        out dx, al
        popf
        mov dword [GusStreamBusyRight], 1
.2:
        mov eax, 1
        ret
.3:
        LD xor, eax, eax
        ret
;-----------------------------------------------------------------------------
; GusServiceStream                             AE9EB  95 PC, medium confidence
; Refills every streaming channel that its voice interrupt flagged
;-----------------------------------------------------------------------------
GusServiceStream:
        cmp dword [GusStreamBusyLeft], byte 0
        je short .1
        LD xor, eax, eax
        call GusFillStreamBuffer
        mov dword [GusStreamBusyLeft], 0
.1:
        cmp dword [GusStreamBusyRight], byte 0
        je short .2
        mov eax, 1
        call GusFillStreamBuffer
        mov dword [GusStreamBusyRight], 0
.2:
        ret
;-----------------------------------------------------------------------------
; GusStartStream                               AEA23  95 PC, medium confidence
; Sets up the double-buffered stream in card memory, loads both halves and
; starts the looping voices
;-----------------------------------------------------------------------------
GusStartStream:
        push ebp
        LD mov, ebp, esp
        push ebx
        push esi
        push edi
        pushf
        cli
        mov ecx, 4
        LD xor, esi, esi
.1:
        mov ebx, dword [nosplit esi*4+GusStreamTable]
        mov dword [byte ebx+04h], 0FFh
        inc esi
        loop .1
        mov eax, dword [byte ebp+010h]
        mov dword [GusStreamBufSize], eax
        shr eax, 1
        mov dword [GusStreamHalfSize], eax
        shr eax, 1
        mov dword [GusStreamQuarterSize], eax
        mov eax, 1
        mov dword [GusStreamQuarterLog2], 0
.2:
        shl eax, 1
        inc dword [GusStreamQuarterLog2]
        cmp eax, dword [GusStreamQuarterSize]
        jb short .2
        mov eax, dword [GusStreamQuarterLog2]
        inc eax
        mov dword [GusStreamHalfShift], eax
        inc eax
        mov dword [GusStreamBufShift], eax
        mov eax, dword [byte ebp+08h]
        mov dword [GusStreamLeftBuf], eax
        add eax, dword [GusStreamHalfSize]
        mov dword [GusStreamRightBuf], eax
        push es
        push ds
        pop es
        mov edi, dword [byte ebp+08h]
        mov ecx, dword [GusStreamQuarterSize]
        cld
        rep stosd
        pop es
        mov eax, dword [byte ebp+0Ch]
        mov dword [GusStreamCardLeft], eax
        push ebx
        LD mov, ebx, eax
        and ebx, 0FFFC000h
        and eax, 3FFFh
        shr eax, 1
        LD or, eax, ebx
        shl eax, 9
        pop ebx
        mov dword [GusStreamLoopLo], eax
        mov eax, dword [byte ebp+0Ch]
        add eax, dword [GusStreamHalfSize]
        mov dword [GusStreamCardRight], eax
        push ebx
        LD mov, ebx, eax
        and ebx, 0FFFC000h
        and eax, 3FFFh
        shr eax, 1
        LD or, eax, ebx
        shl eax, 9
        pop ebx
        mov dword [GusStreamStartLo], eax
        mov eax, dword [byte ebp+0Ch]
        add eax, dword [GusStreamBufSize]
        mov dword [GusStreamCardEnd], eax
        push ebx
        LD mov, ebx, eax
        and ebx, 0FFFC000h
        and eax, 3FFFh
        shr eax, 1
        LD or, eax, ebx
        shl eax, 9
        pop ebx
        mov dword [GusStreamEndLo], eax
        mov dword [GusStreamState], 0
        mov dword [GusStreamLeftPending], 1
        mov dword [GusStreamRightPending], 1
        mov esi, dword [GusStreamCardLeft]
.3:
        LD xor, edx, edx
        LD mov, eax, esi
        call GusPoke
        inc esi
        cmp esi, dword [GusStreamCardEnd]
        jbe short .3
        LD xor, edx, edx
        LD mov, eax, esi
        call GusPoke
        mov eax, GusStreamVoiceIrq
        call GusClaimVoiceCallbacks
        LD xor, eax, eax
        LD xor, edx, edx
        call GusAllocVoice
        mov dword [GusStreamVoiceLeft], eax
        LD xor, eax, eax
        LD xor, edx, edx
        call GusAllocVoice
        mov dword [GusStreamVoiceRight], eax
        mov dx, word [GusVoiceSelectPort]
        mov al, byte [GusStreamVoiceLeft]
        out dx, al
        mov al, 1
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov ax, 400h
        mov dx, word [GusDataLowPort]
        out dx, ax
        mov al, 3
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov ax, word [GusStreamLoopLo]
        mov dx, word [GusDataLowPort]
        out dx, ax
        mov al, 2
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov ax, word [GusStreamLoopHi]
        mov dx, word [GusDataLowPort]
        out dx, ax
        mov al, 0Bh
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov ax, word [GusStreamLoopLo]
        mov dx, word [GusDataLowPort]
        out dx, ax
        mov al, 0Ah
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov ax, word [GusStreamLoopHi]
        mov dx, word [GusDataLowPort]
        out dx, ax
        mov al, 5
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov ax, word [GusStreamEndLo]
        mov dx, word [GusDataLowPort]
        out dx, ax
        mov al, 4
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov ax, word [GusStreamEndHi]
        mov dx, word [GusDataLowPort]
        out dx, ax
        mov al, 0
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov al, 2Ch
        mov dx, word [GusDataHighPort]
        out dx, al
        push ax
        push dx
        mov dx, word [GusDramPort]
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        pop dx
        pop ax
        out dx, al
        mov al, 9
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov ax, 0FFFFh
        mov dx, word [GusDataLowPort]
        out dx, ax
        mov dx, word [GusRegSelectPort]
        mov al, 0Ch
        out dx, al
        mov dx, word [GusDataHighPort]
        mov al, 7
        out dx, al
        mov dx, word [GusVoiceSelectPort]
        mov al, byte [GusStreamVoiceRight]
        out dx, al
        mov al, 1
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov ax, 400h
        mov dx, word [GusDataLowPort]
        out dx, ax
        mov al, 9
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov ax, 0
        mov dx, word [GusDataLowPort]
        out dx, ax
        mov al, 3
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov ax, word [GusStreamLoopLo]
        mov dx, word [GusDataLowPort]
        out dx, ax
        mov al, 2
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov ax, word [GusStreamLoopHi]
        mov dx, word [GusDataLowPort]
        out dx, ax
        mov al, 5
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov ax, word [GusStreamStartLo]
        mov dx, word [GusDataLowPort]
        out dx, ax
        mov al, 4
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov ax, word [GusStreamStartHi]
        mov dx, word [GusDataLowPort]
        out dx, ax
        pushf
        cli
        mov dx, word [GusVoiceSelectPort]
        mov al, byte [GusStreamVoiceRight]
        out dx, al
        mov al, 0Bh
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov ax, word [GusStreamLoopLo]
        mov dx, word [GusDataLowPort]
        out dx, ax
        mov al, 0Ah
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov ax, word [GusStreamLoopHi]
        mov dx, word [GusDataLowPort]
        out dx, ax
        mov al, 0
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov al, 24h
        mov dx, word [GusDataHighPort]
        out dx, al
        push ax
        push dx
        mov dx, word [GusDramPort]
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        pop dx
        pop ax
        out dx, al
        popf
        mov dword [GusStreamState], 0Fh
        mov dword [GusStreamActive], 1
        popf
        pop edi
        pop esi
        pop ebx
        leave
        ret
;-----------------------------------------------------------------------------
; GusStopStream                                   AEDBC  95 PC, low confidence
; Stops the two GUS stream voices
;-----------------------------------------------------------------------------
GusStopStream:
        pushf
        cli
        cmp dword [GusStreamActive], byte 0
        je near .1
        mov dword [GusStreamState], 0
        pushf
        cli
        mov dx, word [GusVoiceSelectPort]
        mov al, byte [GusStreamVoiceRight]
        out dx, al
        mov al, 0
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov al, 3
        mov dx, word [GusDataHighPort]
        out dx, al
        push ax
        push dx
        mov dx, word [GusDramPort]
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        pop dx
        pop ax
        out dx, al
        popf
        mov dx, word [GusVoiceSelectPort]
        mov al, byte [GusStreamVoiceLeft]
        out dx, al
        mov al, 0
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov al, 3
        mov dx, word [GusDataHighPort]
        out dx, al
        push ax
        push dx
        mov dx, word [GusDramPort]
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        pop dx
        pop ax
        out dx, al
        mov dword [GusStreamActive], 0
.1:
        popf
        ret
;-----------------------------------------------------------------------------
; GusStreamStart                                  AEE54  95 PC, low confidence
; Starts a sample on a software stream channel (rate, volume, sample, note)
;-----------------------------------------------------------------------------
GusStreamStart:
        push ebp
        LD mov, ebp, esp
        push ebx
        push esi
        push edi
        pushf
        cli
        mov esi, dword [byte ebp+08h]
        cmp esi, byte 4
        jae near .4
        mov esi, dword [nosplit esi*4+GusStreamTable]
        mov eax, dword [byte ebp+01Ch]
        cmp eax, byte 0
        jne short .1
        push dword [byte ebp+08h]
        call GusStreamRelease
        pop eax
        popf
        pop edi
        pop esi
        pop ebx
        leave
        ret
.1:
        push dword [byte ebp+01Ch]
        push dword [byte ebp+08h]
        call GusStreamSetRate
        add sp, byte 8
        push dword [byte ebp+020h]
        push dword [byte ebp+08h]
        call GusStreamSetVolume
        add sp, byte 8
        push dword [byte ebp+018h]
        push dword [byte ebp+014h]
        push dword [byte ebp+010h]
        push dword [byte ebp+0Ch]
        push dword [byte ebp+08h]
        call GusStreamSetSample
        add sp, byte 14h
        LD xor, eax, eax
        mov byte [byte esi+04Ch], al
        mov byte [byte esi+050h], al
        mov eax, dword [byte ebp+024h]
        mov byte [byte esi+0Ch], al
        LD or, eax, eax
        je short .3
        cmp dword [byte ebp+014h], byte 0
        je short .3
        mov edi, dword [byte ebp+0Ch]
        LD xor, edx, edx
        LD xor, ecx, ecx
        LD xor, eax, eax
.2:
        mov al, byte [edi]
        mov bx, word [nosplit eax*2+MixVolumeTable]
        inc edi
        LD add, dl, bl
        LD add, dl, bh
        inc ecx
        cmp ecx, dword [byte ebp+014h]
        jb short .2
        mov byte [byte esi+050h], dl
.3:
        push byte 7Fh
        push dword 0FFh
        push dword [byte ebp+08h]
        call GusStreamPlayNote
        add sp, byte 0Ch
.4:
        popf
        pop edi
        pop esi
        pop ebx
        leave
        ret
;-----------------------------------------------------------------------------
; GusStreamIdle                                AEF0E  95 PC, medium confidence
; Returns 1 when a software stream channel is not playing
;-----------------------------------------------------------------------------
GusStreamIdle:
        push ebp
        LD mov, ebp, esp
        push ecx
        mov esi, dword [byte ebp+08h]
        cmp esi, byte 4
        jae short .1
        mov esi, dword [nosplit esi*4+GusStreamTable]
        cmp dword [esi], byte 0
        jne short .2
.1:
        mov eax, 1
        pop ecx
        leave
        ret
.2:
        LD xor, eax, eax
        pop ecx
        leave
        ret
;-----------------------------------------------------------------------------
; GusStreamPlayNote                               AEF33  95 PC, low confidence
; Sets the note of a stream channel, works out its step and starts it
;-----------------------------------------------------------------------------
GusStreamPlayNote:
        push ebp
        LD mov, ebp, esp
        push esi
        mov eax, dword [byte ebp+010h]
        mov esi, dword [byte ebp+08h]
        cmp esi, byte 4
        jae short .3
        mov esi, dword [nosplit esi*4+GusStreamTable]
        LD xor, ebx, ebx
        mov bl, byte [byte ebp+0Ch]
        mov dword [byte esi+08h], ebx
        cmp bl, 0FFh
        je short .1
        mov eax, dword [nosplit ebx*4+NotePitchTable]
        mul dword [byte esi+02Ch]
        and eax, 0FFFF0000h
        and edx, 0FFFFh
        mov dword [byte esi+040h], edx
        mov dword [byte esi+044h], eax
        mov dword [byte esi+030h], edx
        mov dword [byte esi+034h], eax
.1:
        mov eax, dword [byte esi+018h]
        mov dword [byte esi+024h], eax
        mov eax, dword [byte esi+01Ch]
        cmp dword [byte esi+010h], byte 0
        jne short .2
        mov eax, dword [byte esi+020h]
.2:
        mov dword [byte esi+028h], eax
        mov eax, dword [byte esi+014h]
        mov dword [byte esi+038h], eax
        mov dword [byte esi+03Ch], 0
        mov dword [esi], 1
.3:
        pop esi
        leave
        ret
;-----------------------------------------------------------------------------
; GusStreamRelease                                AEFA2  95 PC, low confidence
; Lets a stream channel play out to its end
;-----------------------------------------------------------------------------
GusStreamRelease:
        push ebp
        LD mov, ebp, esp
        push esi
        mov esi, dword [byte ebp+08h]
        cmp esi, byte 4
        jae short .1
        cmp esi, byte 1
        jle short .1
        mov esi, dword [nosplit esi*4+GusStreamTable]
        mov eax, dword [byte esi+01Ch]
        mov dword [byte esi+028h], eax
        mov dword [esi], 0
.1:
        pop esi
        leave
        ret
;-----------------------------------------------------------------------------
; GusStreamStop                                AEFC9  95 PC, medium confidence
; Stops a software stream channel
;-----------------------------------------------------------------------------
GusStreamStop:
        push ebp
        LD mov, ebp, esp
        push esi
        mov esi, dword [byte ebp+08h]
        cmp esi, byte 4
        jae short .1
        cmp esi, byte 1
        jle short .1
        mov esi, dword [nosplit esi*4+GusStreamTable]
        mov dword [esi], 0
.1:
        pop esi
        leave
        ret
;-----------------------------------------------------------------------------
; GusStreamSetVolume                              AEFEA  95 PC, low confidence
; Sets the volume of a stream channel and rebuilds its volume tables
;-----------------------------------------------------------------------------
GusStreamSetVolume:
        push ebp
        LD mov, ebp, esp
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        cmp esi, byte 4
        jae short .2
        mov esi, dword [nosplit esi*4+GusStreamTable]
        mov al, byte [byte ebp+0Ch]
        cmp al, byte [byte esi+04h]
        je short .2
        mov byte [byte esi+04h], al
        shl al, 1
        and eax, 0FFh
        lea edi, [byte esi+058h]
        LD mov, esi, eax
        LD xor, eax, eax
        LD xor, ebx, ebx
        sub ebx, dword [byte ebp+0Ch]
        shl ebx, 8
        LD mov, edx, eax
        shr edx, 1
        mov word [edi], dx
        LD mov, edx, ebx
        shr edx, 1
        mov word [dword edi+0100h], dx
        add edi, byte 2
        mov ecx, 7Fh
.1:
        LD add, eax, esi
        LD mov, edx, eax
        shr edx, 1
        mov word [edi], dx
        LD add, ebx, esi
        LD mov, edx, ebx
        shr edx, 1
        mov word [dword edi+0100h], dx
        add edi, byte 2
        loop .1
.2:
        pop edi
        pop esi
        leave
        ret
;-----------------------------------------------------------------------------
; GusStreamSetBend                                AF058  95 PC, low confidence
; Stores the pitch bend of a stream channel
;-----------------------------------------------------------------------------
GusStreamSetBend:
        push ebp
        LD mov, ebp, esp
        push esi
        movzx esi, word [byte ebp+08h]
        cmp esi, byte 4
        jae short .1
        mov esi, dword [nosplit esi*4+GusStreamTable]
        movsx eax, word [byte ebp+0Ch]
        mov dword [byte esi+048h], eax
.1:
        pop esi
        leave
        ret
;-----------------------------------------------------------------------------
; GusStreamSetRate                                AF076  95 PC, low confidence
; Sets the sample rate of a stream channel (step against 22050 Hz)
;-----------------------------------------------------------------------------
GusStreamSetRate:
        push ebp
        LD mov, ebp, esp
        push esi
        mov esi, dword [byte ebp+08h]
        cmp esi, byte 4
        jae short .3
        mov esi, dword [nosplit esi*4+GusStreamTable]
        mov ecx, 5622h
        LD xor, edx, edx
        mov eax, dword [byte ebp+0Ch]
        div ecx
        mov dword [byte esi+040h], eax
        mov dword [byte esi+030h], eax
        LD mov, ebx, eax
        LD xor, eax, eax
        div ecx
        mov dword [byte esi+044h], eax
        mov dword [byte esi+034h], eax
        and eax, 0FFFF0000h
        LD or, eax, ebx
        ror eax, 10h
        mov dword [byte esi+02Ch], eax
        mov eax, dword [byte esi+02Ch]
        cmp eax, 10000h
        je short .1
        mov eax, dword [GusStreamQuarterSize]
        shr eax, 2
        jmp short .2
.1:
        mov eax, dword [GusStreamQuarterSize]
        shr eax, 1
.2:
        mov dword [byte esi+054h], eax
.3:
        pop esi
        leave
        ret
;-----------------------------------------------------------------------------
; GusStreamSetSample                              AF0D5  95 PC, low confidence
; Sets the start, loop start and loop length of a stream channel's sample
;-----------------------------------------------------------------------------
GusStreamSetSample:
        push ebp
        LD mov, ebp, esp
        push esi
        mov esi, dword [byte ebp+08h]
        cmp esi, byte 4
        jae short .1
        mov esi, dword [nosplit esi*4+GusStreamTable]
        LD xor, eax, eax
        mov byte [byte esi+0Ch], al
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte esi+014h], eax
        mov ebx, dword [byte ebp+010h]
        LD add, ebx, eax
        mov dword [byte esi+020h], ebx
        mov ebx, dword [byte ebp+014h]
        LD add, ebx, eax
        mov dword [byte esi+018h], ebx
        add ebx, dword [byte ebp+018h]
        mov dword [byte esi+01Ch], ebx
        mov eax, dword [byte ebp+018h]
        mov dword [byte esi+010h], eax
.1:
        pop esi
        leave
        ret
;-----------------------------------------------------------------------------
; GusStreamApplyBend                              AF112  95 PC, low confidence
; Applies a pitch bend to a stream channel's step
;-----------------------------------------------------------------------------
GusStreamApplyBend:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFFCh
        push esi
        push edi
        mov eax, dword [byte ebp+0Ch]
        mov esi, dword [byte ebp+08h]
        cmp esi, byte 4
        jae short .4
        mov esi, dword [nosplit esi*4+GusStreamTable]
        mov ebx, dword [byte esi+08h]
        mov byte [byte ebp-01h], bl
        mov edi, dword [byte esi+034h]
        or edi, dword [byte esi+030h]
        ror edi, 10h
        add edi, dword [byte ebp+010h]
        cmp dword [byte ebp+014h], byte 0
        je short .3
        LD xor, ebx, ebx
        mov bl, byte [byte ebp-01h]
        add bl, byte [byte ebp+018h]
        mov eax, dword [nosplit ebx*4+NotePitchTable]
        mul dword [byte esi+02Ch]
        shl edx, 10h
        shr eax, 10h
        LD or, eax, edx
        LD sub, eax, edi
        mov edx, dword [byte ebp+014h]
        cmp edx, byte 0
        jg short .1
        jl short .2
.1:
        mul edx
        shr eax, 0Eh
        shl edx, 12h
        LD or, eax, edx
        LD add, edi, eax
        jmp short .3
.2:
        neg edx
        mul edx
        shr eax, 0Eh
        shl edx, 12h
        LD or, eax, edx
        LD sub, edi, eax
.3:
        LD mov, ecx, edi
        shl edi, 10h
        mov dword [byte esi+044h], edi
        shr ecx, 10h
        mov dword [byte esi+040h], ecx
.4:
        pop edi
        pop esi
        leave
        ret
;-----------------------------------------------------------------------------
; GusStreamBusy                                AF198  95 PC, medium confidence
; Returns non-zero while either streaming channel is still playing
;-----------------------------------------------------------------------------
GusStreamBusy:
        mov eax, dword [GusStreamBusyLeft]
        or eax, dword [GusStreamBusyRight]
        ret
;-----------------------------------------------------------------------------
; GusStreamGetVolume                           AF1A4  95 PC, medium confidence
; Returns the volume of a stream channel
;-----------------------------------------------------------------------------
GusStreamGetVolume:
        push ebp
        LD mov, ebp, esp
        push esi
        mov esi, dword [byte ebp+08h]
        cmp esi, byte 4
        jae short .1
        mov esi, dword [nosplit esi*4+GusStreamTable]
        movzx eax, byte [byte esi+04h]
        pop esi
        leave
        ret
.1:
        LD xor, eax, eax
        pop esi
        leave
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
;-----------------------------------------------------------------------------
; GusGetEnvConfig                              AF1D0  95 PC, medium confidence
; Reads the ULTRASND environment variable and parses base port, DMA channels
; and IRQs into the card config
;-----------------------------------------------------------------------------
GusGetEnvConfig:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        mov ecx, eax
        mov eax, dword [GusEnvVarName]
        call getenv_
        mov edx, eax
        mov dword [GusEnvConfig], eax
        test eax, eax
        je near .6
        mov edx, GusEnvConfig
        mov ebx, 10h
        call strtoul_
        mov word [byte ecx+02h], ax
        mov eax, dword [GusEnvConfig]
        cmp byte [eax], 2Ch
        jne short .1
        inc eax
        mov dword [GusEnvConfig], eax
.1:
        mov edx, GusEnvConfig
        mov ebx, 0Ah
        mov eax, dword [GusEnvConfig]
        call strtoul_
        mov byte [byte ecx+07h], al
        mov eax, dword [GusEnvConfig]
        cmp byte [eax], 2Ch
        jne short .2
        inc eax
        mov dword [GusEnvConfig], eax
.2:
        mov edx, GusEnvConfig
        mov ebx, 0Ah
        mov eax, dword [GusEnvConfig]
        call strtoul_
        mov byte [byte ecx+06h], al
        mov eax, dword [GusEnvConfig]
        cmp byte [eax], 2Ch
        jne short .3
        inc eax
        mov dword [GusEnvConfig], eax
.3:
        mov edx, GusEnvConfig
        mov ebx, 0Ah
        mov eax, dword [GusEnvConfig]
        call strtoul_
        mov byte [byte ecx+04h], al
        mov eax, dword [GusEnvConfig]
        cmp byte [eax], 2Ch
        jne short .4
        inc eax
        mov dword [GusEnvConfig], eax
.4:
        mov edx, GusEnvConfig
        mov ebx, 0Ah
        mov eax, dword [GusEnvConfig]
        call strtoul_
        mov dx, word [byte ecx+02h]
        mov byte [byte ecx+05h], al
        test dx, dx
        je short .5
        cmp byte [byte ecx+06h], 0
        je short .5
        cmp byte [byte ecx+07h], 0
        je short .5
        cmp byte [byte ecx+04h], 0
        je short .5
        cmp byte [byte ecx+05h], 0
        je short .5
        mov eax, 1
        jmp short .6
.5:
        xor eax, eax
.6:
        lea esp, [byte ebp-0Ch]
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
;-----------------------------------------------------------------------------
; GusProbePort                                 AF2E0  95 PC, medium confidence
; Writes test bytes to a card port and reads them back; returns whether a
; card answers at that base
;-----------------------------------------------------------------------------
GusProbePort:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        mov ebx, eax
        mov ecx, eax
        add ebx, byte 8
        add ecx, byte 0Ah
        and ebx, 0FFFFh
        mov edx, 0AAh
        mov eax, ebx
        call outp_
        and ecx, 0FFFFh
        mov eax, ecx
        call inp_
        cmp eax, 0AAh
        jne short .1
        mov edx, 55h
        mov eax, ebx
        call outp_
        mov eax, ecx
        call inp_
        cmp eax, byte 55h
        jne short .1
        mov eax, 1
        jmp short .2
.1:
        xor eax, eax
.2:
        lea esp, [byte ebp-0Ch]
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 00h
;-----------------------------------------------------------------------------
; GusMidiPitchBend                                AF340  95 PC, low confidence
; Works out a MIDI channel's frequency after a pitch bend
;-----------------------------------------------------------------------------
GusMidiPitchBend:
        push ebp
        mov ebp, esp
        push ecx
        push esi
        push edi
        sub esp, byte 10h
        mov esi, eax
        xor ah, ah
        mov byte [byte ebp-010h], ah
        lea eax, [nosplit esi*4+00h]
        mov ecx, dword [dword eax+GusChanBendRange]
        test ecx, ecx
        je near .2
        shl ebx, 7
        add edx, ebx
        sub edx, 2000h
        imul edx, ecx
        test edx, edx
        jge short .1
        mov bl, 1
        neg edx
        mov byte [byte ebp-010h], bl
.1:
        mov ecx, 2000h
        mov ebx, edx
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        sar ebx, 0Dh
        mov ecx, 0Ch
        mov dword [byte ebp-018h], edx
        mov eax, ebx
        xor edx, edx
        div ecx
        mov eax, 0Ch
        mov edi, edx
        lea ecx, [byte ebx+01h]
        mov dword [byte ebp-014h], eax
        xor edx, edx
        mov eax, ecx
        div dword [byte ebp-014h]
        mov dword [byte ebp-01Ch], edx
        mov dword [byte ebp-014h], 0Ch
        mov eax, ebx
        mov ebx, dword [byte ebp-014h]
        xor edx, edx
        div ebx
        mov ebx, eax
        mov eax, 0Ch
        xor edx, edx
        mov dword [byte ebp-014h], eax
        mov eax, ecx
        div dword [byte ebp-014h]
        mov cl, bl
        mov ebx, dword [nosplit edi*4+GusPitchTable]
        mov edx, dword [byte ebp-01Ch]
        shl ebx, cl
        mov cl, al
        mov eax, dword [nosplit edx*4+GusPitchTable]
        shl eax, cl
        mov edi, dword [byte ebp-018h]
        sub eax, ebx
        imul eax, edi
        shr eax, 0Dh
        mov cl, byte [byte ebp-010h]
        add ebx, eax
        test cl, cl
        je short .3
        mov eax, 100000h
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        mov ebx, eax
        jmp short .3
.2:
        mov ebx, 400h
.3:
        mov eax, esi
        mov edx, ebx
        call GusSetChannelBend
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
;-----------------------------------------------------------------------------
; GusMidiController                               AF428  95 PC, low confidence
; MIDI control change: modulation, data entry, volume, pan, expression,
; sustain, RPN, all notes off
;-----------------------------------------------------------------------------
GusMidiController:
        push ebp
        mov ebp, esp
        push ecx
        push esi
        push edi
        mov ecx, eax
        mov eax, ebx
        cmp edx, byte 2Bh
        jb near .4
        jbe near .21
        lea ebx, [nosplit ecx*4+00h]
        cmp edx, byte 64h
        jb short .2
        jbe near .17
        cmp edx, byte 78h
        jb short .1
        jbe near .20
        cmp edx, byte 79h
        jbe near .19
        cmp edx, byte 7Bh
        jb near .21
        cmp edx, byte 7Fh
        jbe near .20
        jmp near .21
.1:
        cmp edx, byte 65h
        je near .18
        jmp near .21
.2:
        cmp edx, byte 60h
        jb short .3
        jbe near .11
        cmp edx, byte 61h
        je near .12
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
.3:
        cmp edx, byte 40h
        je near .16
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
.4:
        cmp edx, byte 0Ah
        jb short .6
        jbe near .14
        cmp edx, byte 26h
        jb short .5
        jbe near .10
        cmp edx, byte 27h
        je near .21
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
.5:
        cmp edx, byte 0Bh
        je near .15
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
.6:
        cmp edx, byte 6
        jb short .7
        jbe short .8
        cmp edx, byte 7
        je near .13
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
.7:
        cmp edx, byte 1
        jne near .21
        mov edx, ebx
        mov eax, ecx
        call GusSetChannelModulation
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
.8:
        cmp dword [nosplit ecx*4+GusChanRpnMsb], byte 0
        jne near .21
        cmp dword [nosplit ecx*4+GusChanRpnLsb], byte 0
        jne near .21
        cmp eax, byte 18h
        jle short .9
        mov eax, 18h
.9:
        mov dword [nosplit ecx*4+GusChanBendRange], eax
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
.10:
        cmp dword [nosplit ecx*4+GusChanRpnMsb], byte 0
        jne near .21
        cmp dword [nosplit ecx*4+GusChanRpnLsb], byte 0
        jne near .21
        mov dword [nosplit ecx*4+GusChanBendCents], ebx
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
.11:
        cmp dword [dword ebx+GusChanRpnMsb], byte 0
        jne near .21
        cmp dword [dword ebx+GusChanRpnLsb], byte 0
        jne near .21
        add dword [dword ebx+GusChanBendCents], eax
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
.12:
        cmp dword [dword ebx+GusChanRpnMsb], byte 0
        jne near .21
        cmp dword [dword ebx+GusChanRpnLsb], byte 0
        jne near .21
        sub dword [dword ebx+GusChanBendCents], eax
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
.13:
        mov edx, dword [nosplit ecx*4+GusChanExpression]
        imul edx, ebx
        mov dword [nosplit ecx*4+GusChanVolume], ebx
        mov ebx, 7Fh
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov edx, eax
        mov eax, ecx
        call GusSetChannelVolume
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
.14:
        mov edx, ecx
        call GusSetChannelPan
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
.15:
        mov edx, dword [nosplit ecx*4+GusChanVolume]
        imul edx, ebx
        mov dword [nosplit ecx*4+GusChanExpression], ebx
        mov ebx, 7Fh
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov edx, eax
        mov eax, ecx
        call GusSetChannelVolume
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
.16:
        cmp eax, byte 18h
        setge al
        xor edx, edx
        mov dl, al
        mov eax, ecx
        call GusSetSustain
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
.17:
        mov dword [dword ebx+GusChanRpnLsb], eax
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
.18:
        mov dword [dword ebx+GusChanRpnMsb], eax
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
.19:
        mov eax, ecx
        xor edx, edx
        call GusSetSustain
        mov eax, ecx
        xor edx, edx
        mov esi, 64h
        call GusSetChannelModulation
        mov edx, 400h
        mov eax, ecx
        mov edi, 7Fh
        call GusSetChannelBend
        mov eax, ecx
        mov edx, esi
        mov dword [dword ebx+GusChanVolume], esi
        mov dword [dword ebx+GusChanExpression], edi
        call GusSetChannelVolume
        mov edx, 0FFFFFFFFh
        mov eax, ecx
        call GusSetChannelPan
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
.20:
        mov eax, ecx
        call GusChannelNotesOff
.21:
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
