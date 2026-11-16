; The AdLib driver.
bits 32
%include "hockey.inc"
section s_9DE9C progbits alloc exec nowrite align=1
extern __GETDS, MidiTickCount, AdlibVoices, AdlibChanState
extern memcpy_, GetPatchEntry, FixedMulRound, OplFlush, OplLoadVoice, OplHwInit, OplHwClose, OplDetect
extern OplOpen, OplNoteFNum, OplVolumeLevel, OplVelocityLevel, TableSin, MidiOutQueue
global AdlibDetect, AdlibOpen, AdlibInit, AdlibClose, AdlibService, AdlibLoadTimbre, AdlibNoteOff, AdlibController
global AdlibProgramChange, AdlibPitchBend, AdlibVoiceSetup, AdlibVoiceRelease, AdlibVoiceResetEnvelopes, AdlibEnvelopeJumpTable, AdlibEnvelopeStep, AdlibEnvelopeStep
global AdlibStartLfo, AdlibStepLfo, AdlibStartPitchEnv, AdlibStepPitchEnv, AdlibMidi, AdlibApplyModulation, AdlibModulationJumps, AdlibModulationJumps
global AdlibUpdateVoice, AdlibWriteVoice, AdlibNoteOn
AdlibDetect:
        push ds
        call __GETDS
        call OplDetect
        pop ds
        ret
AdlibOpen:
        push ds
        call __GETDS
        mov edx, dword [byte esp+08h]
        push edx
        call OplOpen
        add esp, byte 4
        pop ds
        ret
AdlibInit:
        push ds
        call __GETDS
        push esi
        push edi
        mov word [AdlibVoices+052Ah], 1FFh
        xor ebx, ebx
        mov word [AdlibVoices+0528h], bx
        mov word [AdlibVoices+0526h], bx
        xor edx, edx
        jmp short .2
.1:
        xor ebx, ebx
        mov bx, dx
        mov eax, ebx
        shl eax, 4
        sub eax, ebx
        add eax, eax
        mov ecx, AdlibVoices
        add ecx, eax
        mov dword [nosplit ebx*4+AdlibChanState], ecx
        xor ebx, ebx
        mov dword [dword eax+AdlibVoices], ebx
        xor esi, esi
        mov word [dword eax+AdlibVoices+014h], si
        xor edi, edi
        mov word [dword eax+AdlibVoices+018h], di
        mov word [dword eax+AdlibVoices+016h], 1FFh
        mov byte [dword eax+AdlibVoices+01Ah], 9
        mov byte [dword eax+AdlibVoices+01Bh], 0FFh
        mov word [dword eax+AdlibVoices+01Ch], 64h
        inc edx
.2:
        cmp dx, byte 10h
        jb short .1
        xor edx, edx
        mov cl, 0FFh
        jmp short .4
.3:
        xor eax, eax
        mov ax, dx
        imul eax, byte 56h
        mov byte [dword eax+AdlibVoices+026Eh], cl
        mov word [dword eax+AdlibVoices+0228h], dx
        inc edx
.4:
        cmp dx, byte 9
        jb short .3
        mov ecx, dword [byte esp+010h]
        push ecx
        call OplHwInit
        add esp, byte 4
        pop edi
        pop esi
        pop ds
        ret
AdlibClose:
        push ds
        call __GETDS
        call OplHwClose
        pop ds
        ret
AdlibService:
        push ds
        call __GETDS
        push esi
        push edi
        xor edi, edi
        mov esi, 1
        jmp near .6
.1:
        movsx eax, si
        movsx edx, word [AdlibVoices+0528h]
        test eax, edx
        je short .5
        xor eax, eax
        mov ax, di
        imul eax, byte 56h
        mov ecx, AdlibVoices+0220h
        add ecx, eax
        cmp word [byte ecx+028h], byte 0
        jne short .2
        lea edx, [byte ecx+08h]
        mov eax, dword [byte ecx+04h]
        mov ebx, 1
        call AdlibVoiceResetEnvelopes
        mov eax, esi
        not eax
        and word [AdlibVoices+0528h], ax
        and word [AdlibVoices+0526h], ax
        or word [AdlibVoices+052Ah], si
        mov edx, dword [ecx]
        and word [byte edx+014h], ax
        mov ecx, dword [ecx]
        and word [byte ecx+018h], ax
        jmp short .5
.2:
        mov bx, word [byte ecx+054h]
        cmp bx, byte 1
        jge short .3
        xor eax, eax
        jmp short .4
.3:
        movsx eax, bx
        dec eax
.4:
        mov word [byte ecx+054h], ax
        lea edx, [byte ecx+08h]
        mov eax, dword [byte ecx+04h]
        call AdlibWriteVoice
.5:
        add esi, esi
        inc edi
.6:
        cmp di, byte 9
        jb near .1
        call OplFlush
        pop edi
        pop esi
        pop ds
        ret
AdlibLoadTimbre:
        push ebx
        push ecx
        push esi
        push edi
        mov esi, eax
        mov edi, edx
        xor eax, eax
        mov al, byte [byte esi+01Bh]
        push eax
        call GetPatchEntry
        add esp, byte 4
        test eax, eax
        je short .1
        mov edx, dword [byte eax+010h]
        mov bl, byte [byte esi+01Bh]
        mov byte [byte edi+04Eh], bl
        mov dword [byte edi+04h], edx
        mov dword [byte edi+050h], eax
        mov dl, byte [byte eax+06h]
        mov byte [byte esi+01Ah], dl
        mov dx, word [byte eax+02h]
        and dh, 1
        mov word [byte esi+016h], dx
        xor edx, edx
        mov dl, byte [byte eax+0Ch]
        shl edx, 4
        mov word [byte esi+01Ch], dx
        mov word [byte edi+054h], dx
        mov dl, byte [byte eax+08h]
        mov byte [byte esi+011h], dl
        mov dl, byte [byte eax+09h]
        mov byte [byte esi+013h], dl
        mov al, byte [byte eax+0Ah]
        mov byte [byte esi+012h], al
.1:
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
AdlibNoteOff:
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 4
        mov byte [esp], dl
        movzx esi, al
        mov esi, dword [nosplit esi*4+AdlibChanState]
        mov di, word [byte esi+014h]
        xor edx, edx
        mov ebx, 1
        jmp short .4
.1:
        movsx eax, bx
        movsx ecx, di
        test eax, ecx
        je short .3
        movsx eax, dx
        imul eax, byte 56h
        add eax, AdlibVoices+0220h
        cmp esi, dword [eax]
        jne short .3
        mov cl, byte [esp]
        cmp cl, byte [byte eax+04Fh]
        jne short .3
        cmp word [byte esi+0Ah], byte 0
        je short .2
        or word [byte esi+018h], bx
        jmp short .5
.2:
        or word [AdlibVoices+0526h], bx
        sar word [byte eax+054h], 1
        lea edx, [byte eax+08h]
        mov eax, dword [byte eax+04h]
        call AdlibVoiceRelease
        jmp short .5
.3:
        add ebx, ebx
        inc edx
.4:
        cmp dx, byte 9
        jl short .1
.5:
        add esp, byte 4
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
AdlibController:
        push ecx
        push esi
        push edi
        sub esp, byte 8
        mov byte [byte esp+04h], al
        xor ecx, ecx
        mov cl, al
        mov ecx, dword [nosplit ecx*4+AdlibChanState]
        lea esi, [byte ecx+04h]
        cmp dl, 40h
        jb short .2
        jbe near .8
        cmp dl, 5Bh
        jb short .1
        jbe near .13
        cmp dl, 7Bh
        je near .14
        jmp near .18
.1:
        cmp dl, 5Ah
        je near .12
        jmp near .18
.2:
        cmp dl, 7
        jb short .3
        jbe short .5
        cmp dl, 0Ah
        je short .6
        jmp near .18
.3:
        cmp dl, 1
        jne near .18
        xor ah, ah
        mov al, bl
        imul eax, dword 82h
        cmp ax, 4000h
        jb short .4
        mov eax, 4000h
.4:
        mov word [esi], ax
        jmp near .18
.5:
        xor eax, eax
        mov al, bl
        push eax
        call OplVelocityLevel
        add esp, byte 4
        mov word [byte esi+02h], ax
        jmp near .18
.6:
        xor ah, ah
        mov al, bl
        imul eax, dword 82h
        cmp ax, 4000h
        jb short .7
        mov eax, 4000h
.7:
        cwde
        add eax, eax
        sub eax, 4000h
        mov word [byte esi+04h], ax
        jmp near .18
.8:
        test bl, 40h
        setne al
        xor ah, ah
        mov word [byte esi+06h], ax
        test ax, ax
        jne near .18
        mov ax, word [byte ecx+018h]
        mov dword [esp], eax
        mov word [byte ecx+018h], 0
        xor esi, esi
        mov edi, 1
        jmp short .11
.9:
        movsx eax, di
        movsx edx, word [esp]
        test eax, edx
        je short .10
        xor eax, eax
        mov ax, si
        imul eax, byte 56h
        xor edx, edx
        mov dl, byte [dword eax+AdlibVoices+026Fh]
        xor eax, eax
        mov al, byte [byte esp+04h]
        call AdlibNoteOff
.10:
        add edi, edi
        inc esi
.11:
        cmp si, byte 9
        jb short .9
        jmp short .18
.12:
        mov byte [byte esi+0Ah], bl
        jmp short .18
.13:
        mov byte [byte esi+0Bh], bl
        jmp short .18
.14:
        mov ax, word [byte ecx+014h]
        mov dword [esp], eax
        xor esi, esi
        mov edi, 1
        jmp short .17
.15:
        movsx edx, di
        movsx eax, word [esp]
        test edx, eax
        je short .16
        xor eax, eax
        mov ax, si
        imul eax, byte 56h
        add eax, AdlibVoices+0220h
        lea edx, [byte eax+08h]
        mov eax, dword [byte eax+04h]
        mov ebx, 1
        call AdlibVoiceResetEnvelopes
        mov eax, edi
        not eax
        and word [AdlibVoices+0528h], ax
        and word [AdlibVoices+0526h], ax
        or word [AdlibVoices+052Ah], di
        and word [byte ecx+014h], ax
        and word [byte ecx+018h], ax
.16:
        add edi, edi
        inc esi
.17:
        cmp si, byte 9
        jb short .15
.18:
        add esp, byte 8
        pop edi
        pop esi
        pop ecx
        ret
AdlibProgramChange:
        and eax, 0FFh
        mov eax, dword [nosplit eax*4+AdlibChanState]
        mov byte [byte eax+01Bh], dl
        ret
AdlibPitchBend:
        and eax, 0FFh
        mov eax, dword [nosplit eax*4+AdlibChanState]
        add eax, byte 4
        add edx, edx
        mov word [byte eax+08h], dx
        ret
AdlibVoiceSetup:
        push esi
        push edi
        sub esp, byte 8
        mov edi, eax
        mov esi, edx
        mov byte [esp], bl
        mov byte [byte esp+04h], cl
        lea edx, [byte eax+02h]
        lea eax, [byte esi+02h]
        mov ebx, 0Dh
        call memcpy_
        cmp word [byte edi+010h], byte 0
        je short .1
        mov ax, word [byte edi+014h]
        mov word [byte esi+022h], ax
        mov ax, word [byte edi+012h]
        mov word [byte esi+024h], ax
        test ax, ax
        sete al
        and eax, 0FFh
        inc eax
        mov byte [byte esi+026h], al
.1:
        cmp word [byte edi+022h], byte 0
        je short .2
        lea edx, [byte esi+028h]
        lea eax, [byte edi+024h]
        call AdlibStartPitchEnv
.2:
        cmp word [byte edi+032h], byte 0
        je short .3
        lea edx, [byte esi+036h]
        lea eax, [byte edi+034h]
        call AdlibStartLfo
.3:
        mov word [byte esi+01Ch], 0
        mov ax, word [byte esi+01Ch]
        mov word [byte esi+01Ah], ax
        mov byte [byte esi+01Eh], 0
        mov al, byte [esp]
        mov byte [byte esi+019h], al
        mov byte [byte esi+018h], al
        mov dl, al
        mov eax, dword [byte esi+042h]
        movsx di, byte [byte eax+0Dh]
        push byte 0
        xor eax, eax
        mov al, dl
        push eax
        call OplNoteFNum
        add esp, byte 8
        add eax, edi
        mov word [byte esi+014h], ax
        xor eax, eax
        mov al, byte [byte esp+04h]
        push eax
        call OplVolumeLevel
        add esp, byte 4
        mov word [byte esi+010h], ax
        mov byte [byte esi+01Eh], 1
        mov word [byte esi+020h], 0FFFFh
        add esp, byte 8
        pop edi
        pop esi
        ret
AdlibVoiceRelease:
        cmp word [byte eax+010h], byte 0
        je short .1
        mov byte [byte edx+026h], 5
.1:
        mov byte [byte edx+01Eh], 0
        mov ax, word [byte eax+04Ah]
        mov word [byte edx+020h], ax
        ret
AdlibVoiceResetEnvelopes:
        push ecx
        cmp word [byte eax+010h], byte 0
        je short .1
        mov byte [byte edx+026h], 0
.1:
        mov word [byte edx+022h], 0
        cmp word [byte eax+022h], byte 0
        je short .2
        mov byte [byte edx+02Ch], 0
        mov word [byte edx+02Ah], 0
        mov cx, word [byte edx+02Ah]
        mov word [byte edx+028h], cx
.2:
        cmp word [byte eax+032h], byte 0
        je short .3
        mov byte [byte edx+038h], 0
.3:
        mov word [byte edx+036h], 0
        mov byte [byte edx+01Eh], 0
        mov word [byte edx+020h], 0
        test ebx, ebx
        je short .4
        lea eax, [byte edx+02h]
        and byte [byte eax+0Ch], 0DFh
        mov bh, byte [byte eax+03h]
        and bh, 0F0h
        mov cl, bh
        or cl, 0Eh
        mov byte [byte eax+03h], cl
        mov ch, byte [byte eax+08h]
        and ch, 0F0h
        mov bl, ch
        or bl, 0Eh
        mov byte [byte eax+08h], bl
        push eax
        movsx eax, word [edx]
        push eax
        call OplLoadVoice
        add esp, byte 8
        call OplFlush
.4:
        pop ecx
        ret
        db 08Dh,040h,00h
AdlibEnvelopeJumpTable:
        dd AdlibEnvelopeStep+020h
        dd AdlibEnvelopeStep+03Bh
        dd AdlibEnvelopeStep+05Ch
        dd AdlibEnvelopeStep+07Dh
        dd AdlibEnvelopeStep+090h
AdlibEnvelopeStep:
        push ebx
        push ecx
        push esi
        push edi
        mov bl, byte [byte edx+04h]
        dec bl
        cmp bl, 4
        ja near .2
        and ebx, 0FFh
        jmp dword [nosplit cs:ebx*4+AdlibEnvelopeJumpTable]
        mov si, word [byte edx+02h]
        dec esi
        mov word [byte edx+02h], si
        test si, si
        jg near .2
        mov byte [byte edx+04h], 2
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
        mov bx, word [byte eax+04h]
        mov di, word [edx]
        add edi, ebx
        mov word [edx], di
        mov cx, word [byte eax+06h]
        cmp di, cx
        jl short .2
        mov word [edx], cx
        mov byte [byte edx+04h], 3
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
        mov bx, word [byte eax+08h]
        mov cx, word [edx]
        sub ecx, ebx
        mov word [edx], cx
        mov si, word [byte eax+0Ah]
        cmp cx, si
        jg short .2
        mov word [edx], si
        mov byte [byte edx+04h], 4
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
        mov ax, word [byte eax+0Ch]
        mov si, word [edx]
        sub esi, eax
        mov word [edx], si
        test si, si
        jg short .2
        jmp short .1
        mov ax, word [byte eax+0Eh]
        mov bx, word [edx]
        sub ebx, eax
        mov word [edx], bx
        test bx, bx
        jg short .2
.1:
        mov word [edx], 0
        mov byte [byte edx+04h], 0
.2:
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
AdlibStartLfo:
        push ebx
        mov word [edx], 0
        mov bx, word [byte eax+04h]
        mov word [byte edx+06h], bx
        xor ebx, ebx
        mov bl, byte [byte eax+03h]
        mov word [byte edx+08h], bx
        mov word [byte edx+0Ah], 0FFFFh
        mov bx, word [eax]
        mov word [byte edx+04h], bx
        test bx, bx
        je short .1
        mov byte [byte edx+02h], 1
        pop ebx
        ret
.1:
        mov byte [byte edx+02h], 2
        call AdlibStepLfo
        pop ebx
        ret
AdlibStepLfo:
        push ebx
        push ecx
        push edi
        mov ebx, eax
.1:
        mov al, byte [byte edx+02h]
        cmp al, 1
        jb near .7
        jbe short .2
        cmp al, 2
        je short .3
        pop edi
        pop ecx
        pop ebx
        ret
.2:
        mov di, word [byte edx+04h]
        dec edi
        mov word [byte edx+04h], di
        test di, di
        jg short .7
        mov byte [byte edx+02h], 2
        jmp short .1
.3:
        mov cx, word [byte edx+06h]
        dec ecx
        mov word [byte edx+06h], cx
        test cx, cx
        jg short .4
        mov byte [byte edx+02h], 0
        mov word [byte edx+0Ah], 0
        mov ax, word [byte edx+0Ah]
        jmp short .6
.4:
        mov di, word [byte edx+08h]
        dec edi
        mov word [byte edx+08h], di
        test di, di
        jg short .7
        xor eax, eax
        mov al, byte [byte ebx+03h]
        mov word [byte edx+08h], ax
        mov cx, word [byte edx+0Ah]
        inc ecx
        mov word [byte edx+0Ah], cx
        xor eax, eax
        mov al, byte [byte ebx+02h]
        cmp ax, cx
        jg short .5
        mov word [byte edx+0Ah], 0
.5:
        movsx eax, word [byte edx+0Ah]
        mov ax, word [byte ebx+eax*2+06h]
.6:
        mov word [edx], ax
.7:
        pop edi
        pop ecx
        pop ebx
        ret
AdlibStartPitchEnv:
        push ebx
        mov word [byte edx+0Ch], 0
        mov bx, word [byte edx+0Ch]
        mov word [byte edx+06h], bx
        mov word [byte edx+02h], bx
        mov word [edx], bx
        mov bx, word [byte eax+04h]
        mov word [byte edx+08h], bx
        mov ax, word [byte eax+0Ah]
        mov word [byte edx+0Ah], ax
        mov byte [byte edx+04h], 1
        pop ebx
        ret
AdlibStepPitchEnv:
        push ebx
        push ecx
        push esi
        push edi
        mov edi, eax
        mov esi, edx
        mov al, byte [byte edx+04h]
        cmp al, 1
        jb near .5
        jbe short .1
        cmp al, 2
        je short .4
        jmp short .5
.1:
        mov ax, word [byte edx+06h]
        cmp ax, word [edi]
        jl short .5
        mov ax, word [byte esi+06h]
        cmp ax, word [byte edi+02h]
        jl short .3
.2:
        mov byte [byte esi+04h], 0
        jmp short .5
.3:
        mov byte [byte esi+04h], 2
.4:
        mov ax, word [byte esi+06h]
        cmp ax, word [byte edi+02h]
        jge short .2
        mov ax, word [byte esi+0Ah]
        mov dx, word [byte esi+0Ch]
        add edx, eax
        mov word [byte esi+0Ch], dx
        mov eax, edx
        and eax, 0FFFFh
        sar eax, 6
        push eax
        call TableSin
        add esp, byte 4
        push eax
        movsx eax, word [byte esi+08h]
        shl eax, 2
        push eax
        call FixedMulRound
        add esp, byte 8
        mov word [byte esi+02h], ax
.5:
        mov ax, word [byte esi+02h]
        mov bx, word [byte edi+06h]
        cmp ax, bx
        jle short .6
        mov word [esi], bx
        jmp short .9
.6:
        movsx eax, bx
        neg eax
        movsx edx, word [byte esi+02h]
        cmp edx, eax
        jge short .7
        mov eax, ebx
        neg eax
        jmp short .8
.7:
        mov ax, word [byte esi+02h]
.8:
        mov word [esi], ax
.9:
        inc word [byte esi+06h]
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
AdlibMidi:
        push ds
        call __GETDS
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 28h
        mov byte [byte ebp-0Ch], 0C0h
        mov byte [byte ebp-010h], 1
        mov byte [byte ebp-04h], 0
        mov dword [byte ebp-014h], 0
        mov eax, MidiOutQueue
        mov edx, dword [MidiTickCount]
        add edx, eax
        mov dword [byte ebp-020h], edx
        add dword [MidiTickCount], byte 4
        mov eax, dword [byte ebp-020h]
        mov dword [byte ebp-01Ch], eax
        mov eax, dword [byte ebp+018h]
        mov dword [byte ebp-018h], eax
.1:
        cmp word [byte ebp+014h], byte 0
        ja short .3
        jmp near .18
.2:
        dec dword [byte ebp+014h]
        inc dword [byte ebp-018h]
        jmp short .1
.3:
        mov eax, dword [byte ebp-018h]
        mov al, byte [eax]
        mov byte [byte ebp-08h], al
        test byte [byte ebp-08h], 80h
        je short .6
        mov al, byte [byte ebp-08h]
        and al, 0F0h
        mov byte [byte ebp-0Ch], al
        mov al, byte [byte ebp-08h]
        and al, 0Fh
        mov byte [byte ebp-04h], al
        mov al, byte [byte ebp-08h]
        and al, 0F0h
        cmp al, 0C0h
        jne short .4
        mov dword [byte ebp-024h], 1
        jmp short .5
.4:
        mov dword [byte ebp-024h], 2
.5:
        mov al, byte [byte ebp-024h]
        mov byte [byte ebp-010h], al
        mov dword [byte ebp-014h], 0
        mov eax, dword [byte ebp-020h]
        mov dword [byte ebp-01Ch], eax
        jmp near .17
.6:
        mov al, byte [byte ebp-08h]
        mov edx, dword [byte ebp-01Ch]
        mov byte [edx], al
        inc dword [byte ebp-01Ch]
        inc dword [byte ebp-014h]
        xor eax, eax
        mov ax, word [byte ebp-014h]
        xor edx, edx
        mov dl, byte [byte ebp-010h]
        cmp eax, edx
        jne near .17
        mov dword [byte ebp-014h], 0
        mov eax, dword [byte ebp-020h]
        mov dword [byte ebp-01Ch], eax
        mov al, byte [byte ebp-0Ch]
        mov byte [byte ebp-028h], al
        cmp byte [byte ebp-028h], 0B0h
        jb short .8
        cmp byte [byte ebp-028h], 0B0h
        jbe near .14
        cmp byte [byte ebp-028h], 0C0h
        jb short .7
        cmp byte [byte ebp-028h], 0C0h
        jbe near .15
        cmp byte [byte ebp-028h], 0E0h
        je near .16
        jmp near .17
.7:
        jmp near .17
.8:
        cmp byte [byte ebp-028h], 80h
        jb short .9
        cmp byte [byte ebp-028h], 80h
        jbe short .10
        cmp byte [byte ebp-028h], 90h
        je short .11
        jmp near .17
.9:
        jmp near .17
.10:
        mov eax, dword [byte ebp-020h]
        xor edx, edx
        mov dl, byte [eax]
        xor eax, eax
        mov al, byte [byte ebp-04h]
        call AdlibNoteOff
        jmp near .17
.11:
        mov eax, dword [byte ebp-020h]
        cmp byte [byte eax+01h], 0
        jne short .12
        mov eax, dword [byte ebp-020h]
        xor edx, edx
        mov dl, byte [eax]
        xor eax, eax
        mov al, byte [byte ebp-04h]
        call AdlibNoteOff
        jmp short .13
.12:
        mov eax, dword [byte ebp-020h]
        xor ebx, ebx
        mov bl, byte [byte eax+01h]
        mov eax, dword [byte ebp-020h]
        xor edx, edx
        mov dl, byte [eax]
        xor eax, eax
        mov al, byte [byte ebp-04h]
        call AdlibNoteOn
.13:
        jmp short .17
.14:
        mov eax, dword [byte ebp-020h]
        xor ebx, ebx
        mov bl, byte [byte eax+01h]
        mov eax, dword [byte ebp-020h]
        xor edx, edx
        mov dl, byte [eax]
        xor eax, eax
        mov al, byte [byte ebp-04h]
        call AdlibController
        jmp short .17
.15:
        mov eax, dword [byte ebp-020h]
        xor edx, edx
        mov dl, byte [eax]
        xor eax, eax
        mov al, byte [byte ebp-04h]
        call AdlibProgramChange
        jmp short .17
.16:
        mov eax, dword [byte ebp-020h]
        mov al, byte [byte eax+01h]
        xor ah, ah
        shl eax, 7
        mov edx, eax
        mov eax, dword [byte ebp-020h]
        mov al, byte [eax]
        xor ah, ah
        add eax, edx
        db 081h,0E8h,00h,020h,00h,00h           ; insn: sub eax,2000h
        movsx edx, ax
        xor eax, eax
        mov al, byte [byte ebp-04h]
        call AdlibPitchBend
.17:
        jmp near .2
.18:
        sub dword [MidiTickCount], byte 4
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ds
        ret
AdlibApplyModulation:
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 20h
        mov dword [byte ebp-018h], eax
        mov dword [byte ebp-014h], edx
        mov dword [byte ebp-08h], ebx
        mov dword [byte ebp-0Ch], ecx
        jmp short AdlibModulationJumps+024h
        db 08Bh,0C0h
AdlibModulationJumps:
        dd .1
        dd .2
        dd .3
        dd .13
        dd .6
        dd .13
        dd .9
        dd .7
        dd .8
        mov eax, dword [byte ebp-014h]
        add eax, byte 10h
        mov dword [byte ebp-010h], eax
        mov eax, dword [byte ebp-08h]
        dec eax
        mov dword [byte ebp-01Ch], eax
        cmp word [byte ebp-01Ch], byte 8
        ja near .13
        xor eax, eax
        mov ax, word [byte ebp-01Ch]
        shl eax, 2
        db 02Eh,0FFh,0A0h                       ; insn: jmp dword [cs:eax+8E876h]
        dd AdlibModulationJumps
.1:
        mov eax, dword [byte ebp-010h]
        mov al, byte [byte eax+08h]
        add al, byte [byte ebp-0Ch]
        mov byte [byte ebp-04h], al
        mov al, byte [byte ebp-04h]
        mov edx, dword [byte ebp-010h]
        mov byte [byte edx+09h], al
        xor eax, eax
        push eax
        xor eax, eax
        mov al, byte [byte ebp-04h]
        push eax
        call OplNoteFNum
        mov edx, eax
        add esp, byte 8
        mov eax, dword [byte ebp-010h]
        mov word [byte eax+06h], dx
        jmp near .13
.2:
        mov eax, dword [byte ebp-0Ch]
        mov edx, dword [byte ebp-010h]
        add word [byte edx+06h], ax
        jmp near .13
.3:
        cmp word [byte ebp-0Ch], byte 0
        jge short .4
        movsx eax, word [byte ebp-0Ch]
        neg eax
        mov dword [byte ebp-020h], eax
        jmp short .5
.4:
        movsx eax, word [byte ebp-0Ch]
        mov dword [byte ebp-020h], eax
.5:
        mov eax, dword [byte ebp-020h]
        mov word [byte ebp-0Ch], ax
        movsx eax, word [byte ebp-0Ch]
        push eax
        mov eax, dword [byte ebp-010h]
        movsx eax, word [byte eax+02h]
        shl eax, 2
        push eax
        call FixedMulRound
        mov edx, eax
        add esp, byte 8
        mov eax, dword [byte ebp-010h]
        mov word [byte eax+02h], dx
        jmp near .13
.6:
        mov eax, dword [byte ebp-018h]
        movsx eax, word [byte eax+02Ch]
        push eax
        movsx eax, word [byte ebp-0Ch]
        push eax
        call FixedMulRound
        mov edx, eax
        add esp, byte 8
        mov eax, dword [byte ebp-018h]
        mov ax, word [byte eax+028h]
        add eax, edx
        mov edx, dword [byte ebp-014h]
        mov word [byte edx+030h], ax
        jmp near .13
.7:
        mov eax, dword [byte ebp-018h]
        mov ax, word [byte eax+02Eh]
        and eax, 0FFFFh
        push eax
        movsx eax, word [byte ebp-0Ch]
        push eax
        call FixedMulRound
        mov edx, eax
        add esp, byte 8
        mov eax, dword [byte ebp-014h]
        mov word [byte eax+032h], dx
        jmp near .13
.8:
        push byte 3Fh
        movsx eax, word [byte ebp-0Ch]
        push eax
        call FixedMulRound
        add esp, byte 8
        mov ah, 3Fh
        sub ah, al
        mov al, ah
        and al, 3Fh
        mov dl, al
        mov eax, dword [byte ebp-014h]
        and byte [byte eax+08h], 0C0h
        mov eax, dword [byte ebp-014h]
        or byte [byte eax+08h], dl
        jmp near .13
.9:
        cmp word [byte ebp-0Ch], byte 0
        jle short .11
        mov eax, dword [byte ebp-010h]
        cmp word [byte eax+0Ah], byte 0
        jne short .10
        mov eax, dword [byte ebp-014h]
        mov eax, dword [byte eax+042h]
        movsx eax, byte [byte eax+0Eh]
        push eax
        mov eax, dword [byte ebp-010h]
        mov al, byte [byte eax+09h]
        and eax, 0FFh
        push eax
        call OplNoteFNum
        mov edx, eax
        add esp, byte 8
        mov eax, dword [byte ebp-010h]
        mov bx, word [byte eax+06h]
        mov eax, dword [byte ebp-010h]
        sub edx, ebx
        mov word [byte eax+0Ah], dx
.10:
        mov eax, dword [byte ebp-010h]
        mov ax, word [byte eax+0Ah]
        and eax, 0FFFFh
        push eax
        movsx eax, word [byte ebp-0Ch]
        shl eax, 2
        push eax
        call FixedMulRound
        mov edx, eax
        add esp, byte 8
        mov eax, dword [byte ebp-010h]
        add word [byte eax+06h], dx
        jmp short .13
.11:
        cmp word [byte ebp-0Ch], byte 0
        jge short .13
        mov eax, dword [byte ebp-010h]
        cmp word [byte eax+0Ch], byte 0
        jne short .12
        mov edx, dword [byte ebp-014h]
        mov eax, dword [byte edx+042h]
        mov al, byte [byte eax+0Eh]
        neg al
        movsx eax, al
        push eax
        mov edx, dword [byte ebp-010h]
        xor eax, eax
        mov al, byte [byte edx+09h]
        push eax
        call OplNoteFNum
        mov edx, eax
        add esp, byte 8
        mov eax, dword [byte ebp-010h]
        mov ax, word [byte eax+06h]
        sub eax, edx
        mov edx, dword [byte ebp-010h]
        mov word [byte edx+0Ch], ax
.12:
        mov eax, dword [byte ebp-010h]
        mov ax, word [byte eax+0Ch]
        and eax, 0FFFFh
        push eax
        movsx eax, word [byte ebp-0Ch]
        shl eax, 2
        push eax
        call FixedMulRound
        mov edx, eax
        add esp, byte 8
        mov eax, dword [byte ebp-010h]
        add word [byte eax+06h], dx
.13:
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        ret
AdlibUpdateVoice:
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 0Ch
        mov dword [byte ebp-0Ch], eax
        mov dword [byte ebp-08h], edx
        mov eax, dword [byte ebp-08h]
        mov eax, dword [byte eax+042h]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp-08h]
        mov dx, word [byte eax+014h]
        mov eax, dword [byte ebp-08h]
        mov word [byte eax+016h], dx
        mov eax, dword [byte ebp-08h]
        mov dx, word [byte eax+010h]
        mov eax, dword [byte ebp-08h]
        mov word [byte eax+012h], dx
        mov eax, dword [byte ebp-0Ch]
        cmp word [byte eax+032h], byte 0
        je short .1
        mov edx, dword [byte ebp-08h]
        add edx, byte 36h
        mov eax, dword [byte ebp-0Ch]
        add eax, byte 34h
        call AdlibStepLfo
        mov eax, dword [byte ebp-08h]
        movsx ecx, word [byte eax+036h]
        mov eax, dword [byte ebp-0Ch]
        xor ebx, ebx
        mov bx, word [byte eax+032h]
        mov edx, dword [byte ebp-08h]
        mov eax, dword [byte ebp-0Ch]
        call AdlibApplyModulation
.1:
        mov eax, dword [byte ebp-04h]
        movsx ecx, word [byte eax+08h]
        mov ebx, 7
        mov edx, dword [byte ebp-08h]
        mov eax, dword [byte ebp-0Ch]
        call AdlibApplyModulation
        mov eax, dword [byte ebp-0Ch]
        cmp word [byte eax+010h], byte 0
        je short .2
        mov edx, dword [byte ebp-08h]
        add edx, byte 22h
        mov eax, dword [byte ebp-0Ch]
        add eax, byte 12h
        call AdlibEnvelopeStep
        mov eax, dword [byte ebp-08h]
        movsx ecx, word [byte eax+022h]
        mov eax, dword [byte ebp-0Ch]
        xor ebx, ebx
        mov bx, word [byte eax+010h]
        mov edx, dword [byte ebp-08h]
        mov eax, dword [byte ebp-0Ch]
        call AdlibApplyModulation
.2:
        mov eax, dword [byte ebp-0Ch]
        cmp word [byte eax+022h], byte 0
        je short .3
        mov edx, dword [byte ebp-08h]
        add edx, byte 28h
        mov eax, dword [byte ebp-0Ch]
        add eax, byte 24h
        call AdlibStepPitchEnv
        mov eax, dword [byte ebp-08h]
        movsx ecx, word [byte eax+028h]
        mov eax, dword [byte ebp-0Ch]
        xor ebx, ebx
        mov bx, word [byte eax+022h]
        mov edx, dword [byte ebp-08h]
        mov eax, dword [byte ebp-0Ch]
        call AdlibApplyModulation
.3:
        mov eax, dword [byte ebp-08h]
        mov eax, dword [byte eax+042h]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp-04h]
        movsx ecx, word [eax]
        mov ebx, 5
        mov edx, dword [byte ebp-08h]
        mov eax, dword [byte ebp-0Ch]
        call AdlibApplyModulation
        mov eax, dword [byte ebp-04h]
        movsx ecx, word [byte eax+02h]
        mov ebx, 3
        mov edx, dword [byte ebp-08h]
        mov eax, dword [byte ebp-0Ch]
        call AdlibApplyModulation
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
AdlibWriteVoice:
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 14h
        mov dword [byte ebp-014h], eax
        mov dword [byte ebp-010h], edx
        mov eax, dword [byte ebp-010h]
        add eax, byte 2
        mov dword [byte ebp-0Ch], eax
        mov edx, dword [byte ebp-010h]
        mov eax, dword [byte ebp-014h]
        call AdlibUpdateVoice
        mov eax, dword [byte ebp-0Ch]
        mov al, byte [byte eax+0Ah]
        and al, 1
        cmp al, 1
        jne short .1
        mov eax, dword [byte ebp-014h]
        mov al, byte [byte eax+08h]
        and al, 3Fh
        and eax, 0FFh
        mov edx, 3Fh
        sub edx, eax
        mov eax, edx
        cwde
        push eax
        mov eax, dword [byte ebp-010h]
        movsx eax, word [byte eax+012h]
        shl eax, 2
        push eax
        call FixedMulRound
        add esp, byte 8
        mov ah, 3Fh
        sub ah, al
        mov byte [byte ebp-08h], ah
        mov dl, byte [byte ebp-08h]
        and dl, 3Fh
        mov eax, dword [byte ebp-0Ch]
        and byte [byte eax+06h], 0C0h
        mov eax, dword [byte ebp-0Ch]
        or byte [byte eax+06h], dl
.1:
        mov eax, dword [byte ebp-014h]
        mov al, byte [byte eax+03h]
        and al, 3Fh
        and eax, 0FFh
        mov edx, 3Fh
        sub edx, eax
        mov eax, edx
        cwde
        push eax
        mov eax, dword [byte ebp-010h]
        movsx eax, word [byte eax+012h]
        shl eax, 2
        push eax
        call FixedMulRound
        add esp, byte 8
        mov ah, 3Fh
        sub ah, al
        mov byte [byte ebp-04h], ah
        mov dl, byte [byte ebp-04h]
        and dl, 3Fh
        mov eax, dword [byte ebp-0Ch]
        and byte [byte eax+01h], 0C0h
        mov eax, dword [byte ebp-0Ch]
        or byte [byte eax+01h], dl
        mov eax, dword [byte ebp-010h]
        mov dx, word [byte eax+016h]
        mov eax, dword [byte ebp-0Ch]
        mov word [byte eax+0Bh], dx
        mov eax, dword [byte ebp-010h]
        mov dl, byte [byte eax+01Eh]
        and dl, 1
        mov eax, dword [byte ebp-0Ch]
        and byte [byte eax+0Ch], 0DFh
        shl dl, 5
        mov eax, dword [byte ebp-0Ch]
        or byte [byte eax+0Ch], dl
        mov eax, dword [byte ebp-010h]
        add eax, byte 2
        push eax
        mov eax, dword [byte ebp-010h]
        movsx eax, word [eax]
        push eax
        call OplLoadVoice
        add esp, byte 8
        mov eax, dword [byte ebp-010h]
        cmp word [byte eax+020h], byte 0
        jle short .2
        mov eax, dword [byte ebp-010h]
        dec word [byte eax+020h]
.2:
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
AdlibNoteOn:
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 3Ch
        mov byte [byte ebp-04h], al
        mov byte [byte ebp-0Ch], dl
        mov byte [byte ebp-08h], bl
        xor eax, eax
        mov al, byte [byte ebp-04h]
        shl eax, 2
        mov eax, dword [dword eax+AdlibChanState]
        mov dword [byte ebp-038h], eax
        cmp byte [byte ebp-04h], 9
        jne short .3
        cmp byte [byte ebp-0Ch], 24h
        jb short .1
        cmp byte [byte ebp-0Ch], 64h
        jb short .2
.1:
        jmp near .37
.2:
        mov al, byte [byte ebp-0Ch]
        add al, 5Ch
        mov edx, dword [byte ebp-038h]
        mov byte [byte edx+01Bh], al
        mov byte [byte ebp-010h], 3Ch
        jmp short .4
.3:
        mov al, byte [byte ebp-0Ch]
        mov byte [byte ebp-010h], al
.4:
        mov eax, dword [byte ebp-038h]
        mov ax, word [byte eax+014h]
        mov dword [byte ebp-01Ch], eax
        mov dword [byte ebp-020h], 2710h
        mov dword [byte ebp-028h], 0
        mov dword [byte ebp-024h], 1
.5:
        cmp word [byte ebp-028h], byte 9
        jb short .7
        jmp near .14
.6:
        inc dword [byte ebp-028h]
        shl dword [byte ebp-024h], 1
        jmp short .5
.7:
        xor eax, eax
        mov ax, word [byte ebp-028h]
        imul eax, byte 56h
        mov edx, AdlibVoices+0220h
        add edx, eax
        mov dword [byte ebp-03Ch], edx
        movsx edx, word [byte ebp-024h]
        movsx eax, word [AdlibVoices+0528h]
        test edx, eax
        je short .8
        mov eax, dword [byte ebp-03Ch]
        mov ax, word [byte eax+054h]
        cmp ax, word [byte ebp-020h]
        jl short .9
.8:
        jmp short .10
.9:
        mov eax, dword [byte ebp-03Ch]
        mov ax, word [byte eax+054h]
        mov dword [byte ebp-020h], eax
        mov eax, dword [byte ebp-03Ch]
        mov dword [byte ebp-034h], eax
        mov eax, dword [byte ebp-024h]
        mov dword [byte ebp-018h], eax
.10:
        movsx edx, word [byte ebp-024h]
        movsx eax, word [byte ebp-01Ch]
        test edx, eax
        je near .13
        mov eax, dword [byte ebp-038h]
        mov edx, dword [byte ebp-03Ch]
        cmp eax, dword [edx]
        jne short .11
        mov al, byte [byte ebp-0Ch]
        mov edx, dword [byte ebp-03Ch]
        cmp al, byte [byte edx+04Fh]
        je short .12
.11:
        jmp near .13
.12:
        mov ebx, 1
        mov edx, dword [byte ebp-03Ch]
        add edx, byte 8
        mov eax, dword [byte ebp-03Ch]
        mov eax, dword [byte eax+04h]
        call AdlibVoiceResetEnvelopes
        mov eax, dword [byte ebp-024h]
        or word [AdlibVoices+0528h], ax
        mov eax, dword [byte ebp-024h]
        not eax
        and word [AdlibVoices+052Ah], ax
        mov eax, dword [byte ebp-024h]
        not eax
        and word [AdlibVoices+0526h], ax
        mov edx, dword [byte ebp-024h]
        not edx
        mov eax, dword [byte ebp-038h]
        and word [byte eax+018h], dx
        mov eax, dword [byte ebp-024h]
        mov edx, dword [byte ebp-038h]
        or word [byte edx+014h], ax
        mov edx, dword [byte ebp-03Ch]
        mov eax, dword [byte ebp-038h]
        call AdlibLoadTimbre
        xor ecx, ecx
        mov cl, byte [byte ebp-08h]
        mov eax, dword [byte ebp-03Ch]
        mov eax, dword [byte eax+050h]
        mov al, byte [byte eax+07h]
        add al, byte [byte ebp-010h]
        xor ebx, ebx
        mov bl, al
        mov edx, dword [byte ebp-03Ch]
        add edx, byte 8
        mov eax, dword [byte ebp-03Ch]
        mov eax, dword [byte eax+04h]
        call AdlibVoiceSetup
        jmp near .37
.13:
        jmp near .6
.14:
        mov dword [byte ebp-02Ch], 0
        mov eax, dword [byte ebp-038h]
        mov ax, word [byte eax+014h]
        mov dword [byte ebp-024h], eax
.15:
        cmp word [byte ebp-024h], byte 0
        je short .16
        inc dword [byte ebp-02Ch]
        mov eax, dword [byte ebp-024h]
        neg eax
        and eax, dword [byte ebp-024h]
        xor dword [byte ebp-024h], eax
        jmp short .15
.16:
        mov eax, dword [byte ebp-038h]
        mov al, byte [byte eax+01Ah]
        and eax, 0FFh
        xor edx, edx
        mov dx, word [byte ebp-02Ch]
        cmp edx, eax
        jge near .21
        mov ax, word [AdlibVoices+052Ah]
        mov edx, dword [byte ebp-038h]
        and ax, word [byte edx+016h]
        mov dword [byte ebp-014h], eax
        cmp word [byte ebp-014h], byte 0
        je near .21
        mov eax, dword [byte ebp-014h]
        mov dword [byte ebp-024h], eax
        mov dword [byte ebp-028h], 0
.17:
        test byte [byte ebp-024h], 1
        je short .19
        jmp short .20
.18:
        inc dword [byte ebp-028h]
        sar word [byte ebp-024h], 1
        jmp short .17
.19:
        jmp short .18
.20:
        xor eax, eax
        mov ax, word [byte ebp-028h]
        imul eax, byte 56h
        mov edx, AdlibVoices+0220h
        add edx, eax
        mov dword [byte ebp-03Ch], edx
        mov eax, dword [byte ebp-014h]
        neg eax
        mov edx, dword [byte ebp-014h]
        and edx, eax
        mov word [byte ebp-024h], dx
        mov eax, dword [byte ebp-024h]
        not eax
        and word [AdlibVoices+052Ah], ax
        mov eax, dword [byte ebp-024h]
        not eax
        and word [AdlibVoices+0526h], ax
        mov eax, dword [byte ebp-024h]
        or word [AdlibVoices+0528h], ax
        mov eax, dword [byte ebp-024h]
        mov edx, dword [byte ebp-038h]
        or word [byte edx+014h], ax
        mov edx, dword [byte ebp-024h]
        not edx
        mov eax, dword [byte ebp-038h]
        and word [byte eax+018h], dx
        mov eax, dword [byte ebp-038h]
        mov edx, dword [byte ebp-03Ch]
        mov dword [edx], eax
        mov al, byte [byte ebp-0Ch]
        mov edx, dword [byte ebp-03Ch]
        mov byte [byte edx+04Fh], al
        mov eax, dword [byte ebp-038h]
        add eax, byte 4
        mov edx, dword [byte ebp-03Ch]
        mov dword [byte edx+04Ah], eax
        mov edx, dword [byte ebp-03Ch]
        mov eax, dword [byte ebp-038h]
        call AdlibLoadTimbre
        xor ecx, ecx
        mov cl, byte [byte ebp-08h]
        mov eax, dword [byte ebp-03Ch]
        mov eax, dword [byte eax+050h]
        mov al, byte [byte eax+07h]
        add al, byte [byte ebp-010h]
        xor ebx, ebx
        mov bl, al
        mov edx, dword [byte ebp-03Ch]
        add edx, byte 8
        mov eax, dword [byte ebp-03Ch]
        mov eax, dword [byte eax+04h]
        call AdlibVoiceSetup
        jmp near .27
.21:
        mov ax, word [AdlibVoices+0526h]
        mov edx, dword [byte ebp-038h]
        and ax, word [byte edx+016h]
        mov dword [byte ebp-030h], eax
        cmp word [byte ebp-030h], byte 0
        je near .26
        mov eax, dword [byte ebp-030h]
        mov word [byte ebp-024h], ax
        mov dword [byte ebp-028h], 0
.22:
        test byte [byte ebp-024h], 1
        je short .24
        jmp short .25
.23:
        inc dword [byte ebp-028h]
        sar word [byte ebp-024h], 1
        jmp short .22
.24:
        jmp short .23
.25:
        xor eax, eax
        mov ax, word [byte ebp-028h]
        imul eax, byte 56h
        mov edx, AdlibVoices+0220h
        add edx, eax
        mov dword [byte ebp-03Ch], edx
        mov ebx, 1
        mov edx, dword [byte ebp-03Ch]
        add edx, byte 8
        mov eax, dword [byte ebp-03Ch]
        mov eax, dword [byte eax+04h]
        call AdlibVoiceResetEnvelopes
        mov eax, dword [byte ebp-030h]
        neg eax
        mov edx, dword [byte ebp-030h]
        and edx, eax
        mov word [byte ebp-024h], dx
        mov eax, dword [byte ebp-024h]
        not eax
        and word [AdlibVoices+052Ah], ax
        mov eax, dword [byte ebp-024h]
        not eax
        and word [AdlibVoices+0526h], ax
        mov eax, dword [byte ebp-024h]
        or word [AdlibVoices+0528h], ax
        mov eax, dword [byte ebp-024h]
        mov edx, dword [byte ebp-038h]
        or word [byte edx+014h], ax
        mov edx, dword [byte ebp-024h]
        not edx
        mov eax, dword [byte ebp-038h]
        and word [byte eax+018h], dx
        mov eax, dword [byte ebp-038h]
        mov edx, dword [byte ebp-03Ch]
        mov dword [edx], eax
        mov al, byte [byte ebp-0Ch]
        mov edx, dword [byte ebp-03Ch]
        mov byte [byte edx+04Fh], al
        mov eax, dword [byte ebp-038h]
        add eax, byte 4
        mov edx, dword [byte ebp-03Ch]
        mov dword [byte edx+04Ah], eax
        mov edx, dword [byte ebp-03Ch]
        mov eax, dword [byte ebp-038h]
        call AdlibLoadTimbre
        xor ecx, ecx
        mov cl, byte [byte ebp-08h]
        mov eax, dword [byte ebp-03Ch]
        mov eax, dword [byte eax+050h]
        mov al, byte [byte eax+07h]
        add al, byte [byte ebp-010h]
        xor ebx, ebx
        mov bl, al
        mov edx, dword [byte ebp-03Ch]
        add edx, byte 8
        mov eax, dword [byte ebp-03Ch]
        mov eax, dword [byte eax+04h]
        call AdlibVoiceSetup
        jmp near .27
.26:
        mov ebx, 1
        mov edx, dword [byte ebp-034h]
        add edx, byte 8
        mov eax, dword [byte ebp-034h]
        mov eax, dword [byte eax+04h]
        call AdlibVoiceResetEnvelopes
        mov eax, dword [byte ebp-018h]
        not eax
        and word [AdlibVoices+052Ah], ax
        mov eax, dword [byte ebp-018h]
        not eax
        and word [AdlibVoices+0526h], ax
        mov eax, dword [byte ebp-018h]
        or word [AdlibVoices+0528h], ax
        mov eax, dword [byte ebp-018h]
        mov edx, dword [byte ebp-038h]
        or word [byte edx+014h], ax
        mov edx, dword [byte ebp-018h]
        not edx
        mov eax, dword [byte ebp-038h]
        and word [byte eax+018h], dx
        mov eax, dword [byte ebp-038h]
        mov edx, dword [byte ebp-034h]
        mov dword [edx], eax
        mov al, byte [byte ebp-0Ch]
        mov edx, dword [byte ebp-034h]
        mov byte [byte edx+04Fh], al
        mov eax, dword [byte ebp-038h]
        add eax, byte 4
        mov edx, dword [byte ebp-034h]
        mov dword [byte edx+04Ah], eax
        mov edx, dword [byte ebp-034h]
        mov eax, dword [byte ebp-038h]
        call AdlibLoadTimbre
        xor ecx, ecx
        mov cl, byte [byte ebp-08h]
        mov eax, dword [byte ebp-034h]
        mov eax, dword [byte eax+050h]
        mov al, byte [byte eax+07h]
        add al, byte [byte ebp-010h]
        xor ebx, ebx
        mov bl, al
        mov edx, dword [byte ebp-034h]
        add edx, byte 8
        mov eax, dword [byte ebp-034h]
        mov eax, dword [byte eax+04h]
        call AdlibVoiceSetup
.27:
        mov dword [byte ebp-02Ch], 0
        mov eax, dword [byte ebp-038h]
        mov ax, word [byte eax+014h]
        mov word [byte ebp-024h], ax
.28:
        cmp word [byte ebp-024h], byte 0
        je short .29
        inc dword [byte ebp-02Ch]
        mov eax, dword [byte ebp-024h]
        neg eax
        and eax, dword [byte ebp-024h]
        xor word [byte ebp-024h], ax
        jmp short .28
.29:
        xor eax, eax
        mov ax, word [byte ebp-02Ch]
        inc eax
        cmp eax, byte 9
        jl near .37
        mov dword [byte ebp-020h], 2710h
        mov dword [byte ebp-028h], 0
        mov word [byte ebp-024h], 1
.30:
        cmp word [byte ebp-028h], byte 9
        jb short .32
        jmp short .36
.31:
        dec dword [byte ebp-028h]
        shl word [byte ebp-024h], 1
        jmp short .30
.32:
        xor eax, eax
        mov ax, word [byte ebp-028h]
        imul eax, byte 56h
        mov edx, AdlibVoices+0220h
        add edx, eax
        mov dword [byte ebp-03Ch], edx
        movsx edx, word [byte ebp-024h]
        movsx eax, word [AdlibVoices+0528h]
        test edx, eax
        je short .33
        mov eax, dword [byte ebp-03Ch]
        mov ax, word [byte eax+054h]
        cmp ax, word [byte ebp-020h]
        jl short .34
.33:
        jmp short .35
.34:
        mov eax, dword [byte ebp-03Ch]
        mov ax, word [byte eax+054h]
        mov dword [byte ebp-020h], eax
        mov eax, dword [byte ebp-03Ch]
        mov dword [byte ebp-034h], eax
        mov eax, dword [byte ebp-024h]
        mov dword [byte ebp-018h], eax
.35:
        jmp short .31
.36:
        xor ebx, ebx
        mov edx, dword [byte ebp-034h]
        add edx, byte 8
        mov eax, dword [byte ebp-034h]
        mov eax, dword [byte eax+04h]
        call AdlibVoiceResetEnvelopes
        mov eax, dword [byte ebp-018h]
        not eax
        and word [AdlibVoices+052Ah], ax
        mov eax, dword [byte ebp-018h]
        not eax
        and word [AdlibVoices+0526h], ax
        mov eax, dword [byte ebp-018h]
        or word [AdlibVoices+0528h], ax
        mov eax, dword [byte ebp-018h]
        mov edx, dword [byte ebp-038h]
        or word [byte edx+014h], ax
        mov edx, dword [byte ebp-018h]
        not edx
        mov eax, dword [byte ebp-038h]
        and word [byte eax+018h], dx
.37:
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
