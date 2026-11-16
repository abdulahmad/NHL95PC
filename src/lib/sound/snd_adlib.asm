; The AdLib driver.
bits 32
%include "hockey.inc"
section s_9DE9C progbits alloc exec nowrite align=1
extern __GETDS, byte_F2F42, byte_F2F43, byte_F3196, byte_F3197, dword_D4F9A, dword_F2F28, dword_F3108
extern memcpy_, GetPatchEntry, FixedMulRound, OplFlush, OplLoadVoice, OplHwInit, OplHwClose, OplDetect
extern OplOpen, OplNoteFNum, OplVolumeLevel, OplVelocityLevel, TableSin, unk_F21FC, unk_F3148, word_F2F3C
extern word_F2F3E, word_F2F40, word_F2F44, word_F3150, word_F344E, word_F3450, word_F3452
global AdlibDetect, AdlibOpen, AdlibInit, loc_9DEE3, loc_9DF3A
global loc_9DF46, loc_9DF5C, AdlibClose, AdlibService, loc_9DF94, loc_9DFEF
global loc_9DFFD, loc_9E001, loc_9E010, loc_9E013, AdlibLoadTimbre, loc_9E082, AdlibNoteOff, loc_9E0A8
global loc_9E0D6, loc_9E0EE, loc_9E0F1, loc_9E0F7, AdlibController, loc_9E13B, loc_9E149, loc_9E15A
global loc_9E178, loc_9E180, loc_9E196, loc_9E1AB, loc_9E1BC, loc_9E1E7, loc_9E20D, loc_9E210
global loc_9E218, loc_9E21D, loc_9E222, loc_9E232, loc_9E27B, loc_9E27E, loc_9E284, AdlibProgramChange
global AdlibPitchBend, AdlibVoiceSetup, loc_9E2F7, loc_9E309, loc_9E31B, AdlibVoiceRelease, loc_9E383, AdlibVoiceResetEnvelopes
global loc_9E39C, loc_9E3BB, loc_9E3C6, loc_9E40F, jpt_9E414, AdlibEnvelopeStep, loc_9E448, loc_9E463
global loc_9E484, loc_9E4A5, loc_9E4B8, loc_9E4C9, loc_9E4D2, AdlibStartLfo, loc_9E506, AdlibStepLfo
global loc_9E516, loc_9E52B, loc_9E53F, loc_9E55D, loc_9E58D, loc_9E596, loc_9E599, AdlibStartPitchEnv
global AdlibStepPitchEnv, loc_9E5E4, loc_9E5F7, loc_9E5FD, loc_9E601, loc_9E641, loc_9E653, loc_9E666
global loc_9E66A, loc_9E66D, AdlibMidi, loc_9E6BD, loc_9E6C9, loc_9E6D1, loc_9E701
global loc_9E708, loc_9E720, loc_9E783, loc_9E788, loc_9E79F, loc_9E7A4, loc_9E7BA, loc_9E7D6
global loc_9E7EF, loc_9E7F1, loc_9E80C, loc_9E81F, loc_9E848, loc_9E84D, AdlibApplyModulation, AdlibModulationJumps
global loc_9E89A, loc_9E8C5, loc_9E8F9, loc_9E908, loc_9E91A, loc_9E921, loc_9E94E, loc_9E97A
global loc_9E9A2, loc_9E9CD, loc_9EA0F, loc_9EA37, loc_9EA7A, loc_9EAA0, AdlibUpdateVoice, loc_9EB14
global loc_9EB61, loc_9EB97, AdlibWriteVoice, loc_9EC4D, loc_9ECE0, AdlibNoteOn, loc_9ED20, loc_9ED25
global loc_9ED36, loc_9ED3C, loc_9ED5B, loc_9ED67, loc_9ED6F, loc_9ED9E, loc_9EDA0, loc_9EDB6
global loc_9EDDB, loc_9EDE0, loc_9EE64, loc_9EE69, loc_9EE7A, loc_9EE91, loc_9EED2, loc_9EEDA
global loc_9EEE3, loc_9EEE5, loc_9EF91, loc_9EFBA, loc_9EFC2, loc_9EFCB, loc_9EFCD, loc_9F08F
global loc_9F12B, loc_9F13D, loc_9F155, loc_9F179, loc_9F182, loc_9F18B, loc_9F1BA, loc_9F1BC
global loc_9F1D2, loc_9F1D4, loc_9F21F
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
        mov word [word_F3452], 1FFh
        xor ebx, ebx
        mov word [word_F3450], bx
        mov word [word_F344E], bx
        xor edx, edx
        jmp short loc_9DF3A
loc_9DEE3:
        xor ebx, ebx
        mov bx, dx
        mov eax, ebx
        shl eax, 4
        sub eax, ebx
        add eax, eax
        mov ecx, dword_F2F28
        add ecx, eax
        mov dword [nosplit ebx*4+dword_F3108], ecx
        xor ebx, ebx
        mov dword [dword eax+dword_F2F28], ebx
        xor esi, esi
        mov word [dword eax+word_F2F3C], si
        xor edi, edi
        mov word [dword eax+word_F2F40], di
        mov word [dword eax+word_F2F3E], 1FFh
        mov byte [dword eax+byte_F2F42], 9
        mov byte [dword eax+byte_F2F43], 0FFh
        mov word [dword eax+word_F2F44], 64h
        inc edx
loc_9DF3A:
        cmp dx, byte 10h
        jb short loc_9DEE3
        xor edx, edx
        mov cl, 0FFh
        jmp short loc_9DF5C
loc_9DF46:
        xor eax, eax
        mov ax, dx
        imul eax, byte 56h
        mov byte [dword eax+byte_F3196], cl
        mov word [dword eax+word_F3150], dx
        inc edx
loc_9DF5C:
        cmp dx, byte 9
        jb short loc_9DF46
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
        jmp near loc_9E013
loc_9DF94:
        movsx eax, si
        movsx edx, word [word_F3450]
        test eax, edx
        je short loc_9E010
        xor eax, eax
        mov ax, di
        imul eax, byte 56h
        mov ecx, unk_F3148
        add ecx, eax
        cmp word [byte ecx+028h], byte 0
        jne short loc_9DFEF
        lea edx, [byte ecx+08h]
        mov eax, dword [byte ecx+04h]
        mov ebx, 1
        call AdlibVoiceResetEnvelopes
        mov eax, esi
        not eax
        and word [word_F3450], ax
        and word [word_F344E], ax
        or word [word_F3452], si
        mov edx, dword [ecx]
        and word [byte edx+014h], ax
        mov ecx, dword [ecx]
        and word [byte ecx+018h], ax
        jmp short loc_9E010
loc_9DFEF:
        mov bx, word [byte ecx+054h]
        cmp bx, byte 1
        jge short loc_9DFFD
        xor eax, eax
        jmp short loc_9E001
loc_9DFFD:
        movsx eax, bx
        dec eax
loc_9E001:
        mov word [byte ecx+054h], ax
        lea edx, [byte ecx+08h]
        mov eax, dword [byte ecx+04h]
        call AdlibWriteVoice
loc_9E010:
        add esi, esi
        inc edi
loc_9E013:
        cmp di, byte 9
        jb near loc_9DF94
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
        je short loc_9E082
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
loc_9E082:
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
        mov esi, dword [nosplit esi*4+dword_F3108]
        mov di, word [byte esi+014h]
        xor edx, edx
        mov ebx, 1
        jmp short loc_9E0F1
loc_9E0A8:
        movsx eax, bx
        movsx ecx, di
        test eax, ecx
        je short loc_9E0EE
        movsx eax, dx
        imul eax, byte 56h
        add eax, unk_F3148
        cmp esi, dword [eax]
        jne short loc_9E0EE
        mov cl, byte [esp]
        cmp cl, byte [byte eax+04Fh]
        jne short loc_9E0EE
        cmp word [byte esi+0Ah], byte 0
        je short loc_9E0D6
        or word [byte esi+018h], bx
        jmp short loc_9E0F7
loc_9E0D6:
        or word [word_F344E], bx
        sar word [byte eax+054h], 1
        lea edx, [byte eax+08h]
        mov eax, dword [byte eax+04h]
        call AdlibVoiceRelease
        jmp short loc_9E0F7
loc_9E0EE:
        add ebx, ebx
        inc edx
loc_9E0F1:
        cmp dx, byte 9
        jl short loc_9E0A8
loc_9E0F7:
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
        mov ecx, dword [nosplit ecx*4+dword_F3108]
        lea esi, [byte ecx+04h]
        cmp dl, 40h
        jb short loc_9E149
        jbe near loc_9E1BC
        cmp dl, 5Bh
        jb short loc_9E13B
        jbe near loc_9E21D
        cmp dl, 7Bh
        je near loc_9E222
        jmp near loc_9E284
loc_9E13B:
        cmp dl, 5Ah
        je near loc_9E218
        jmp near loc_9E284
loc_9E149:
        cmp dl, 7
        jb short loc_9E15A
        jbe short loc_9E180
        cmp dl, 0Ah
        je short loc_9E196
        jmp near loc_9E284
loc_9E15A:
        cmp dl, 1
        jne near loc_9E284
        xor ah, ah
        mov al, bl
        imul eax, dword 82h
        cmp ax, 4000h
        jb short loc_9E178
        mov eax, 4000h
loc_9E178:
        mov word [esi], ax
        jmp near loc_9E284
loc_9E180:
        xor eax, eax
        mov al, bl
        push eax
        call OplVelocityLevel
        add esp, byte 4
        mov word [byte esi+02h], ax
        jmp near loc_9E284
loc_9E196:
        xor ah, ah
        mov al, bl
        imul eax, dword 82h
        cmp ax, 4000h
        jb short loc_9E1AB
        mov eax, 4000h
loc_9E1AB:
        cwde
        add eax, eax
        sub eax, 4000h
        mov word [byte esi+04h], ax
        jmp near loc_9E284
loc_9E1BC:
        test bl, 40h
        setne al
        xor ah, ah
        mov word [byte esi+06h], ax
        test ax, ax
        jne near loc_9E284
        mov ax, word [byte ecx+018h]
        mov dword [esp], eax
        mov word [byte ecx+018h], 0
        xor esi, esi
        mov edi, 1
        jmp short loc_9E210
loc_9E1E7:
        movsx eax, di
        movsx edx, word [esp]
        test eax, edx
        je short loc_9E20D
        xor eax, eax
        mov ax, si
        imul eax, byte 56h
        xor edx, edx
        mov dl, byte [dword eax+byte_F3197]
        xor eax, eax
        mov al, byte [byte esp+04h]
        call AdlibNoteOff
loc_9E20D:
        add edi, edi
        inc esi
loc_9E210:
        cmp si, byte 9
        jb short loc_9E1E7
        jmp short loc_9E284
loc_9E218:
        mov byte [byte esi+0Ah], bl
        jmp short loc_9E284
loc_9E21D:
        mov byte [byte esi+0Bh], bl
        jmp short loc_9E284
loc_9E222:
        mov ax, word [byte ecx+014h]
        mov dword [esp], eax
        xor esi, esi
        mov edi, 1
        jmp short loc_9E27E
loc_9E232:
        movsx edx, di
        movsx eax, word [esp]
        test edx, eax
        je short loc_9E27B
        xor eax, eax
        mov ax, si
        imul eax, byte 56h
        add eax, unk_F3148
        lea edx, [byte eax+08h]
        mov eax, dword [byte eax+04h]
        mov ebx, 1
        call AdlibVoiceResetEnvelopes
        mov eax, edi
        not eax
        and word [word_F3450], ax
        and word [word_F344E], ax
        or word [word_F3452], di
        and word [byte ecx+014h], ax
        and word [byte ecx+018h], ax
loc_9E27B:
        add edi, edi
        inc esi
loc_9E27E:
        cmp si, byte 9
        jb short loc_9E232
loc_9E284:
        add esp, byte 8
        pop edi
        pop esi
        pop ecx
        ret
AdlibProgramChange:
        and eax, 0FFh
        mov eax, dword [nosplit eax*4+dword_F3108]
        mov byte [byte eax+01Bh], dl
        ret
AdlibPitchBend:
        and eax, 0FFh
        mov eax, dword [nosplit eax*4+dword_F3108]
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
        je short loc_9E2F7
        mov ax, word [byte edi+014h]
        mov word [byte esi+022h], ax
        mov ax, word [byte edi+012h]
        mov word [byte esi+024h], ax
        test ax, ax
        sete al
        and eax, 0FFh
        inc eax
        mov byte [byte esi+026h], al
loc_9E2F7:
        cmp word [byte edi+022h], byte 0
        je short loc_9E309
        lea edx, [byte esi+028h]
        lea eax, [byte edi+024h]
        call AdlibStartPitchEnv
loc_9E309:
        cmp word [byte edi+032h], byte 0
        je short loc_9E31B
        lea edx, [byte esi+036h]
        lea eax, [byte edi+034h]
        call AdlibStartLfo
loc_9E31B:
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
        je short loc_9E383
        mov byte [byte edx+026h], 5
loc_9E383:
        mov byte [byte edx+01Eh], 0
        mov ax, word [byte eax+04Ah]
        mov word [byte edx+020h], ax
        ret
AdlibVoiceResetEnvelopes:
        push ecx
        cmp word [byte eax+010h], byte 0
        je short loc_9E39C
        mov byte [byte edx+026h], 0
loc_9E39C:
        mov word [byte edx+022h], 0
        cmp word [byte eax+022h], byte 0
        je short loc_9E3BB
        mov byte [byte edx+02Ch], 0
        mov word [byte edx+02Ah], 0
        mov cx, word [byte edx+02Ah]
        mov word [byte edx+028h], cx
loc_9E3BB:
        cmp word [byte eax+032h], byte 0
        je short loc_9E3C6
        mov byte [byte edx+038h], 0
loc_9E3C6:
        mov word [byte edx+036h], 0
        mov byte [byte edx+01Eh], 0
        mov word [byte edx+020h], 0
        test ebx, ebx
        je short loc_9E40F
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
loc_9E40F:
        pop ecx
        ret
        db 08Dh,040h,00h
jpt_9E414:
        dd loc_9E448
        dd loc_9E463
        dd loc_9E484
        dd loc_9E4A5
        dd loc_9E4B8
AdlibEnvelopeStep:
        push ebx
        push ecx
        push esi
        push edi
        mov bl, byte [byte edx+04h]
        dec bl
        cmp bl, 4
        ja near loc_9E4D2
        and ebx, 0FFh
        jmp dword [nosplit cs:ebx*4+jpt_9E414]
loc_9E448:
        mov si, word [byte edx+02h]
        dec esi
        mov word [byte edx+02h], si
        test si, si
        jg near loc_9E4D2
        mov byte [byte edx+04h], 2
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
loc_9E463:
        mov bx, word [byte eax+04h]
        mov di, word [edx]
        add edi, ebx
        mov word [edx], di
        mov cx, word [byte eax+06h]
        cmp di, cx
        jl short loc_9E4D2
        mov word [edx], cx
        mov byte [byte edx+04h], 3
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
loc_9E484:
        mov bx, word [byte eax+08h]
        mov cx, word [edx]
        sub ecx, ebx
        mov word [edx], cx
        mov si, word [byte eax+0Ah]
        cmp cx, si
        jg short loc_9E4D2
        mov word [edx], si
        mov byte [byte edx+04h], 4
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
loc_9E4A5:
        mov ax, word [byte eax+0Ch]
        mov si, word [edx]
        sub esi, eax
        mov word [edx], si
        test si, si
        jg short loc_9E4D2
        jmp short loc_9E4C9
loc_9E4B8:
        mov ax, word [byte eax+0Eh]
        mov bx, word [edx]
        sub ebx, eax
        mov word [edx], bx
        test bx, bx
        jg short loc_9E4D2
loc_9E4C9:
        mov word [edx], 0
        mov byte [byte edx+04h], 0
loc_9E4D2:
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
        je short loc_9E506
        mov byte [byte edx+02h], 1
        pop ebx
        ret
loc_9E506:
        mov byte [byte edx+02h], 2
        call AdlibStepLfo
        pop ebx
        ret
AdlibStepLfo:
        push ebx
        push ecx
        push edi
        mov ebx, eax
loc_9E516:
        mov al, byte [byte edx+02h]
        cmp al, 1
        jb near loc_9E599
        jbe short loc_9E52B
        cmp al, 2
        je short loc_9E53F
        pop edi
        pop ecx
        pop ebx
        ret
loc_9E52B:
        mov di, word [byte edx+04h]
        dec edi
        mov word [byte edx+04h], di
        test di, di
        jg short loc_9E599
        mov byte [byte edx+02h], 2
        jmp short loc_9E516
loc_9E53F:
        mov cx, word [byte edx+06h]
        dec ecx
        mov word [byte edx+06h], cx
        test cx, cx
        jg short loc_9E55D
        mov byte [byte edx+02h], 0
        mov word [byte edx+0Ah], 0
        mov ax, word [byte edx+0Ah]
        jmp short loc_9E596
loc_9E55D:
        mov di, word [byte edx+08h]
        dec edi
        mov word [byte edx+08h], di
        test di, di
        jg short loc_9E599
        xor eax, eax
        mov al, byte [byte ebx+03h]
        mov word [byte edx+08h], ax
        mov cx, word [byte edx+0Ah]
        inc ecx
        mov word [byte edx+0Ah], cx
        xor eax, eax
        mov al, byte [byte ebx+02h]
        cmp ax, cx
        jg short loc_9E58D
        mov word [byte edx+0Ah], 0
loc_9E58D:
        movsx eax, word [byte edx+0Ah]
        mov ax, word [byte ebx+eax*2+06h]
loc_9E596:
        mov word [edx], ax
loc_9E599:
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
        jb near loc_9E641
        jbe short loc_9E5E4
        cmp al, 2
        je short loc_9E601
        jmp short loc_9E641
loc_9E5E4:
        mov ax, word [byte edx+06h]
        cmp ax, word [edi]
        jl short loc_9E641
        mov ax, word [byte esi+06h]
        cmp ax, word [byte edi+02h]
        jl short loc_9E5FD
loc_9E5F7:
        mov byte [byte esi+04h], 0
        jmp short loc_9E641
loc_9E5FD:
        mov byte [byte esi+04h], 2
loc_9E601:
        mov ax, word [byte esi+06h]
        cmp ax, word [byte edi+02h]
        jge short loc_9E5F7
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
loc_9E641:
        mov ax, word [byte esi+02h]
        mov bx, word [byte edi+06h]
        cmp ax, bx
        jle short loc_9E653
        mov word [esi], bx
        jmp short loc_9E66D
loc_9E653:
        movsx eax, bx
        neg eax
        movsx edx, word [byte esi+02h]
        cmp edx, eax
        jge short loc_9E666
        mov eax, ebx
        neg eax
        jmp short loc_9E66A
loc_9E666:
        mov ax, word [byte esi+02h]
loc_9E66A:
        mov word [esi], ax
loc_9E66D:
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
        mov eax, unk_F21FC
        mov edx, dword [dword_D4F9A]
        add edx, eax
        mov dword [byte ebp-020h], edx
        add dword [dword_D4F9A], byte 4
        mov eax, dword [byte ebp-020h]
        mov dword [byte ebp-01Ch], eax
        mov eax, dword [byte ebp+018h]
        mov dword [byte ebp-018h], eax
loc_9E6BD:
        cmp word [byte ebp+014h], byte 0
        ja short loc_9E6D1
        jmp near loc_9E84D
loc_9E6C9:
        dec dword [byte ebp+014h]
        inc dword [byte ebp-018h]
        jmp short loc_9E6BD
loc_9E6D1:
        mov eax, dword [byte ebp-018h]
        mov al, byte [eax]
        mov byte [byte ebp-08h], al
        test byte [byte ebp-08h], 80h
        je short loc_9E720
        mov al, byte [byte ebp-08h]
        and al, 0F0h
        mov byte [byte ebp-0Ch], al
        mov al, byte [byte ebp-08h]
        and al, 0Fh
        mov byte [byte ebp-04h], al
        mov al, byte [byte ebp-08h]
        and al, 0F0h
        cmp al, 0C0h
        jne short loc_9E701
        mov dword [byte ebp-024h], 1
        jmp short loc_9E708
loc_9E701:
        mov dword [byte ebp-024h], 2
loc_9E708:
        mov al, byte [byte ebp-024h]
        mov byte [byte ebp-010h], al
        mov dword [byte ebp-014h], 0
        mov eax, dword [byte ebp-020h]
        mov dword [byte ebp-01Ch], eax
        jmp near loc_9E848
loc_9E720:
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
        jne near loc_9E848
        mov dword [byte ebp-014h], 0
        mov eax, dword [byte ebp-020h]
        mov dword [byte ebp-01Ch], eax
        mov al, byte [byte ebp-0Ch]
        mov byte [byte ebp-028h], al
        cmp byte [byte ebp-028h], 0B0h
        jb short loc_9E788
        cmp byte [byte ebp-028h], 0B0h
        jbe near loc_9E7F1
        cmp byte [byte ebp-028h], 0C0h
        jb short loc_9E783
        cmp byte [byte ebp-028h], 0C0h
        jbe near loc_9E80C
        cmp byte [byte ebp-028h], 0E0h
        je near loc_9E81F
        jmp near loc_9E848
loc_9E783:
        jmp near loc_9E848
loc_9E788:
        cmp byte [byte ebp-028h], 80h
        jb short loc_9E79F
        cmp byte [byte ebp-028h], 80h
        jbe short loc_9E7A4
        cmp byte [byte ebp-028h], 90h
        je short loc_9E7BA
        jmp near loc_9E848
loc_9E79F:
        jmp near loc_9E848
loc_9E7A4:
        mov eax, dword [byte ebp-020h]
        xor edx, edx
        mov dl, byte [eax]
        xor eax, eax
        mov al, byte [byte ebp-04h]
        call AdlibNoteOff
        jmp near loc_9E848
loc_9E7BA:
        mov eax, dword [byte ebp-020h]
        cmp byte [byte eax+01h], 0
        jne short loc_9E7D6
        mov eax, dword [byte ebp-020h]
        xor edx, edx
        mov dl, byte [eax]
        xor eax, eax
        mov al, byte [byte ebp-04h]
        call AdlibNoteOff
        jmp short loc_9E7EF
loc_9E7D6:
        mov eax, dword [byte ebp-020h]
        xor ebx, ebx
        mov bl, byte [byte eax+01h]
        mov eax, dword [byte ebp-020h]
        xor edx, edx
        mov dl, byte [eax]
        xor eax, eax
        mov al, byte [byte ebp-04h]
        call AdlibNoteOn
loc_9E7EF:
        jmp short loc_9E848
loc_9E7F1:
        mov eax, dword [byte ebp-020h]
        xor ebx, ebx
        mov bl, byte [byte eax+01h]
        mov eax, dword [byte ebp-020h]
        xor edx, edx
        mov dl, byte [eax]
        xor eax, eax
        mov al, byte [byte ebp-04h]
        call AdlibController
        jmp short loc_9E848
loc_9E80C:
        mov eax, dword [byte ebp-020h]
        xor edx, edx
        mov dl, byte [eax]
        xor eax, eax
        mov al, byte [byte ebp-04h]
        call AdlibProgramChange
        jmp short loc_9E848
loc_9E81F:
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
loc_9E848:
        jmp near loc_9E6C9
loc_9E84D:
        sub dword [dword_D4F9A], byte 4
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
        jmp short loc_9E89A
        db 08Bh,0C0h
AdlibModulationJumps:
        dd loc_9E8C5
        dd loc_9E8F9
        dd loc_9E908
        dd loc_9EAA0
        dd loc_9E94E
        dd loc_9EAA0
        dd loc_9E9CD
        dd loc_9E97A
        dd loc_9E9A2
loc_9E89A:
        mov eax, dword [byte ebp-014h]
        add eax, byte 10h
        mov dword [byte ebp-010h], eax
        mov eax, dword [byte ebp-08h]
        dec eax
        mov dword [byte ebp-01Ch], eax
        cmp word [byte ebp-01Ch], byte 8
        ja near loc_9EAA0
        xor eax, eax
        mov ax, word [byte ebp-01Ch]
        shl eax, 2
        db 02Eh,0FFh,0A0h                       ; insn: jmp dword [cs:eax+8E876h]
        dd AdlibModulationJumps
loc_9E8C5:
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
        jmp near loc_9EAA0
loc_9E8F9:
        mov eax, dword [byte ebp-0Ch]
        mov edx, dword [byte ebp-010h]
        add word [byte edx+06h], ax
        jmp near loc_9EAA0
loc_9E908:
        cmp word [byte ebp-0Ch], byte 0
        jge short loc_9E91A
        movsx eax, word [byte ebp-0Ch]
        neg eax
        mov dword [byte ebp-020h], eax
        jmp short loc_9E921
loc_9E91A:
        movsx eax, word [byte ebp-0Ch]
        mov dword [byte ebp-020h], eax
loc_9E921:
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
        jmp near loc_9EAA0
loc_9E94E:
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
        jmp near loc_9EAA0
loc_9E97A:
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
        jmp near loc_9EAA0
loc_9E9A2:
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
        jmp near loc_9EAA0
loc_9E9CD:
        cmp word [byte ebp-0Ch], byte 0
        jle short loc_9EA37
        mov eax, dword [byte ebp-010h]
        cmp word [byte eax+0Ah], byte 0
        jne short loc_9EA0F
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
loc_9EA0F:
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
        jmp short loc_9EAA0
loc_9EA37:
        cmp word [byte ebp-0Ch], byte 0
        jge short loc_9EAA0
        mov eax, dword [byte ebp-010h]
        cmp word [byte eax+0Ch], byte 0
        jne short loc_9EA7A
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
loc_9EA7A:
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
loc_9EAA0:
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
        je short loc_9EB14
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
loc_9EB14:
        mov eax, dword [byte ebp-04h]
        movsx ecx, word [byte eax+08h]
        mov ebx, 7
        mov edx, dword [byte ebp-08h]
        mov eax, dword [byte ebp-0Ch]
        call AdlibApplyModulation
        mov eax, dword [byte ebp-0Ch]
        cmp word [byte eax+010h], byte 0
        je short loc_9EB61
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
loc_9EB61:
        mov eax, dword [byte ebp-0Ch]
        cmp word [byte eax+022h], byte 0
        je short loc_9EB97
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
loc_9EB97:
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
        jne short loc_9EC4D
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
loc_9EC4D:
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
        jle short loc_9ECE0
        mov eax, dword [byte ebp-010h]
        dec word [byte eax+020h]
loc_9ECE0:
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
        mov eax, dword [dword eax+dword_F3108]
        mov dword [byte ebp-038h], eax
        cmp byte [byte ebp-04h], 9
        jne short loc_9ED36
        cmp byte [byte ebp-0Ch], 24h
        jb short loc_9ED20
        cmp byte [byte ebp-0Ch], 64h
        jb short loc_9ED25
loc_9ED20:
        jmp near loc_9F21F
loc_9ED25:
        mov al, byte [byte ebp-0Ch]
        add al, 5Ch
        mov edx, dword [byte ebp-038h]
        mov byte [byte edx+01Bh], al
        mov byte [byte ebp-010h], 3Ch
        jmp short loc_9ED3C
loc_9ED36:
        mov al, byte [byte ebp-0Ch]
        mov byte [byte ebp-010h], al
loc_9ED3C:
        mov eax, dword [byte ebp-038h]
        mov ax, word [byte eax+014h]
        mov dword [byte ebp-01Ch], eax
        mov dword [byte ebp-020h], 2710h
        mov dword [byte ebp-028h], 0
        mov dword [byte ebp-024h], 1
loc_9ED5B:
        cmp word [byte ebp-028h], byte 9
        jb short loc_9ED6F
        jmp near loc_9EE69
loc_9ED67:
        inc dword [byte ebp-028h]
        shl dword [byte ebp-024h], 1
        jmp short loc_9ED5B
loc_9ED6F:
        xor eax, eax
        mov ax, word [byte ebp-028h]
        imul eax, byte 56h
        mov edx, unk_F3148
        add edx, eax
        mov dword [byte ebp-03Ch], edx
        movsx edx, word [byte ebp-024h]
        movsx eax, word [word_F3450]
        test edx, eax
        je short loc_9ED9E
        mov eax, dword [byte ebp-03Ch]
        mov ax, word [byte eax+054h]
        cmp ax, word [byte ebp-020h]
        jl short loc_9EDA0
loc_9ED9E:
        jmp short loc_9EDB6
loc_9EDA0:
        mov eax, dword [byte ebp-03Ch]
        mov ax, word [byte eax+054h]
        mov dword [byte ebp-020h], eax
        mov eax, dword [byte ebp-03Ch]
        mov dword [byte ebp-034h], eax
        mov eax, dword [byte ebp-024h]
        mov dword [byte ebp-018h], eax
loc_9EDB6:
        movsx edx, word [byte ebp-024h]
        movsx eax, word [byte ebp-01Ch]
        test edx, eax
        je near loc_9EE64
        mov eax, dword [byte ebp-038h]
        mov edx, dword [byte ebp-03Ch]
        cmp eax, dword [edx]
        jne short loc_9EDDB
        mov al, byte [byte ebp-0Ch]
        mov edx, dword [byte ebp-03Ch]
        cmp al, byte [byte edx+04Fh]
        je short loc_9EDE0
loc_9EDDB:
        jmp near loc_9EE64
loc_9EDE0:
        mov ebx, 1
        mov edx, dword [byte ebp-03Ch]
        add edx, byte 8
        mov eax, dword [byte ebp-03Ch]
        mov eax, dword [byte eax+04h]
        call AdlibVoiceResetEnvelopes
        mov eax, dword [byte ebp-024h]
        or word [word_F3450], ax
        mov eax, dword [byte ebp-024h]
        not eax
        and word [word_F3452], ax
        mov eax, dword [byte ebp-024h]
        not eax
        and word [word_F344E], ax
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
        jmp near loc_9F21F
loc_9EE64:
        jmp near loc_9ED67
loc_9EE69:
        mov dword [byte ebp-02Ch], 0
        mov eax, dword [byte ebp-038h]
        mov ax, word [byte eax+014h]
        mov dword [byte ebp-024h], eax
loc_9EE7A:
        cmp word [byte ebp-024h], byte 0
        je short loc_9EE91
        inc dword [byte ebp-02Ch]
        mov eax, dword [byte ebp-024h]
        neg eax
        and eax, dword [byte ebp-024h]
        xor dword [byte ebp-024h], eax
        jmp short loc_9EE7A
loc_9EE91:
        mov eax, dword [byte ebp-038h]
        mov al, byte [byte eax+01Ah]
        and eax, 0FFh
        xor edx, edx
        mov dx, word [byte ebp-02Ch]
        cmp edx, eax
        jge near loc_9EF91
        mov ax, word [word_F3452]
        mov edx, dword [byte ebp-038h]
        and ax, word [byte edx+016h]
        mov dword [byte ebp-014h], eax
        cmp word [byte ebp-014h], byte 0
        je near loc_9EF91
        mov eax, dword [byte ebp-014h]
        mov dword [byte ebp-024h], eax
        mov dword [byte ebp-028h], 0
loc_9EED2:
        test byte [byte ebp-024h], 1
        je short loc_9EEE3
        jmp short loc_9EEE5
loc_9EEDA:
        inc dword [byte ebp-028h]
        sar word [byte ebp-024h], 1
        jmp short loc_9EED2
loc_9EEE3:
        jmp short loc_9EEDA
loc_9EEE5:
        xor eax, eax
        mov ax, word [byte ebp-028h]
        imul eax, byte 56h
        mov edx, unk_F3148
        add edx, eax
        mov dword [byte ebp-03Ch], edx
        mov eax, dword [byte ebp-014h]
        neg eax
        mov edx, dword [byte ebp-014h]
        and edx, eax
        mov word [byte ebp-024h], dx
        mov eax, dword [byte ebp-024h]
        not eax
        and word [word_F3452], ax
        mov eax, dword [byte ebp-024h]
        not eax
        and word [word_F344E], ax
        mov eax, dword [byte ebp-024h]
        or word [word_F3450], ax
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
        jmp near loc_9F12B
loc_9EF91:
        mov ax, word [word_F344E]
        mov edx, dword [byte ebp-038h]
        and ax, word [byte edx+016h]
        mov dword [byte ebp-030h], eax
        cmp word [byte ebp-030h], byte 0
        je near loc_9F08F
        mov eax, dword [byte ebp-030h]
        mov word [byte ebp-024h], ax
        mov dword [byte ebp-028h], 0
loc_9EFBA:
        test byte [byte ebp-024h], 1
        je short loc_9EFCB
        jmp short loc_9EFCD
loc_9EFC2:
        inc dword [byte ebp-028h]
        sar word [byte ebp-024h], 1
        jmp short loc_9EFBA
loc_9EFCB:
        jmp short loc_9EFC2
loc_9EFCD:
        xor eax, eax
        mov ax, word [byte ebp-028h]
        imul eax, byte 56h
        mov edx, unk_F3148
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
        and word [word_F3452], ax
        mov eax, dword [byte ebp-024h]
        not eax
        and word [word_F344E], ax
        mov eax, dword [byte ebp-024h]
        or word [word_F3450], ax
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
        jmp near loc_9F12B
loc_9F08F:
        mov ebx, 1
        mov edx, dword [byte ebp-034h]
        add edx, byte 8
        mov eax, dword [byte ebp-034h]
        mov eax, dword [byte eax+04h]
        call AdlibVoiceResetEnvelopes
        mov eax, dword [byte ebp-018h]
        not eax
        and word [word_F3452], ax
        mov eax, dword [byte ebp-018h]
        not eax
        and word [word_F344E], ax
        mov eax, dword [byte ebp-018h]
        or word [word_F3450], ax
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
loc_9F12B:
        mov dword [byte ebp-02Ch], 0
        mov eax, dword [byte ebp-038h]
        mov ax, word [byte eax+014h]
        mov word [byte ebp-024h], ax
loc_9F13D:
        cmp word [byte ebp-024h], byte 0
        je short loc_9F155
        inc dword [byte ebp-02Ch]
        mov eax, dword [byte ebp-024h]
        neg eax
        and eax, dword [byte ebp-024h]
        xor word [byte ebp-024h], ax
        jmp short loc_9F13D
loc_9F155:
        xor eax, eax
        mov ax, word [byte ebp-02Ch]
        inc eax
        cmp eax, byte 9
        jl near loc_9F21F
        mov dword [byte ebp-020h], 2710h
        mov dword [byte ebp-028h], 0
        mov word [byte ebp-024h], 1
loc_9F179:
        cmp word [byte ebp-028h], byte 9
        jb short loc_9F18B
        jmp short loc_9F1D4
loc_9F182:
        dec dword [byte ebp-028h]
        shl word [byte ebp-024h], 1
        jmp short loc_9F179
loc_9F18B:
        xor eax, eax
        mov ax, word [byte ebp-028h]
        imul eax, byte 56h
        mov edx, unk_F3148
        add edx, eax
        mov dword [byte ebp-03Ch], edx
        movsx edx, word [byte ebp-024h]
        movsx eax, word [word_F3450]
        test edx, eax
        je short loc_9F1BA
        mov eax, dword [byte ebp-03Ch]
        mov ax, word [byte eax+054h]
        cmp ax, word [byte ebp-020h]
        jl short loc_9F1BC
loc_9F1BA:
        jmp short loc_9F1D2
loc_9F1BC:
        mov eax, dword [byte ebp-03Ch]
        mov ax, word [byte eax+054h]
        mov dword [byte ebp-020h], eax
        mov eax, dword [byte ebp-03Ch]
        mov dword [byte ebp-034h], eax
        mov eax, dword [byte ebp-024h]
        mov dword [byte ebp-018h], eax
loc_9F1D2:
        jmp short loc_9F182
loc_9F1D4:
        xor ebx, ebx
        mov edx, dword [byte ebp-034h]
        add edx, byte 8
        mov eax, dword [byte ebp-034h]
        mov eax, dword [byte eax+04h]
        call AdlibVoiceResetEnvelopes
        mov eax, dword [byte ebp-018h]
        not eax
        and word [word_F3452], ax
        mov eax, dword [byte ebp-018h]
        not eax
        and word [word_F344E], ax
        mov eax, dword [byte ebp-018h]
        or word [word_F3450], ax
        mov eax, dword [byte ebp-018h]
        mov edx, dword [byte ebp-038h]
        or word [byte edx+014h], ax
        mov edx, dword [byte ebp-018h]
        not edx
        mov eax, dword [byte ebp-038h]
        and word [byte eax+018h], dx
loc_9F21F:
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
