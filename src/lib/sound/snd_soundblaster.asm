; The Sound Blaster driver.
bits 32
%include "hockey.inc"
section s_9F226 progbits alloc exec nowrite align=1
extern __GETDS, str_BLASTER, dword_D524C, dword_D5250, dword_D525C, dword_F3462, dword_F34DC, getenv_
extern int386x_, memset_, outp_, GetPatchEntry, strtoul_, SbMixRateDiv, SbMixerOpen, SbMixerClose
extern SbStreamPlayNote, SbStreamRelease, SbStreamStop, SbStreamSetVolume, SbStreamSetRate, SbStreamSetSample, SbStreamStart, SbStreamIdle
extern SbStreamGetVolume, SbStreamApplyBend, SbMixChannels, SbDmaHalfReady, SbSetStereo, unk_D522E, unk_D5254, unk_D5258
extern unk_F3534, word_F3454, word_F3456, word_F345C, word_F3538, word_F354A, word_F3714, word_F3716
extern word_F3718
global ParseBlasterEnv, ParseHexValue, SbPopArgsReturn, SbOpen, SbInit, SbClose, SbService, SbQuery
global SbSetTrack, SbPlayDigi, SbNoteOff, SbNoteOn, SbStartVoice, SbVoiceStartSample, SbVoiceSetVolume, SbController
global SbVoiceController, SbSetVoiceOwner, SbFreeVoice, SbStopVoice, SbProgramChange, SbPitchBend, SbAllocDosBuffer, SbFreeDosBuffer
global SbSetMixerVolumes
ParseBlasterEnv:
        push ds
        call __GETDS
        sub esp, byte 10h
        xor edx, edx
        mov dword [byte esp+0Ch], edx
        mov dword [byte esp+08h], edx
        mov dword [byte esp+04h], 0FFFFFFFFh
        mov dword [esp], 9
        mov eax, str_BLASTER
        call getenv_
        mov ecx, eax
        test eax, eax
        je near .13
.1:
        mov ah, byte [ecx]
        test ah, ah
        je near .13
        mov al, ah
        cmp ah, 56h
        jb short .3
        jbe near .8
        cmp ah, 64h
        jb short .2
        jbe near .9
        cmp ah, 69h
        jb near .12
        jbe short .7
        cmp ah, 76h
        je short .8
        jmp near .12
.2:
        cmp ah, 61h
        je short .5
        jmp near .12
.3:
        cmp ah, 44h
        jb short .4
        jbe short .9
        cmp ah, 49h
        je short .7
        jmp near .12
.4:
        cmp ah, 41h
        jne near .12
.5:
        inc ecx
        mov ebx, 10h
        lea edx, [byte esp+0Ch]
.6:
        mov eax, ecx
        jmp short .11
.7:
        inc ecx
        mov ebx, 0Ah
        lea edx, [byte esp+08h]
        jmp short .6
.8:
        inc ecx
        mov ebx, 0Ah
        mov edx, esp
        mov eax, ecx
        call ParseHexValue
        add ecx, eax
        mov edx, dword [esp]
        mov eax, dword [byte esp+0Ch]
        call SbSetMixerVolumes
        jmp short .12
.9:
        cmp byte [byte ecx+01h], 45h
        jne short .10
        cmp byte [byte ecx+02h], 72h
        jne short .10
        cmp byte [byte ecx+03h], 46h
        jne short .10
        lea eax, [byte ecx+04h]
        mov ebx, 0Ah
        mov edx, unk_D5254
        jmp short .11
.10:
        inc ecx
        mov ebx, 0Ah
        lea edx, [byte esp+04h]
        mov eax, ecx
.11:
        call ParseHexValue
        add ecx, eax
.12:
        cmp byte [ecx], 0
        je near .1
        inc ecx
        jmp near .1
.13:
        mov eax, dword [byte esp+04h]
        mov dword [dword_D524C], eax
        mov eax, dword [byte esp+08h]
        shl eax, 10h
        add eax, dword [byte esp+0Ch]
        add esp, byte 10h
        pop ds
        ret
ParseHexValue:
        push ecx
        push esi
        push edi
        sub esp, byte 0Ch
        mov esi, eax
        mov edi, edx
        xor ecx, ecx
.1:
        lea eax, [esi+ecx]
        mov dl, byte [eax]
        test dl, dl
        je short .2
        cmp dl, 20h
        je short .2
        mov byte [esp+ecx], dl
        inc ecx
        jmp short .1
.2:
        xor al, al
        mov byte [esp+ecx], al
        lea edx, [byte esp+08h]
        mov eax, esp
        call strtoul_
        mov dword [edi], eax
        mov eax, ecx
SbPopArgsReturn:
        add esp, byte 0Ch
        pop edi
        pop esi
        pop ecx
        ret
SbOpen:
        push ds
        call __GETDS
        push esi
        cmp dword [byte esp+0Ch], byte 0
        je near .3
        mov ebx, dword_D525C
        mov edx, unk_D5258
        mov eax, 40h
        call SbAllocDosBuffer
        mov esi, eax
        mov edx, eax
        and edx, 0FFFFh
        cmp edx, 0FE00h
        jle short .1
        and eax, 0F0000h
        lea esi, [dword eax+010000h]
.1:
        mov ebx, 200h
        mov edx, 80h
        mov eax, esi
        call memset_
        push dword 200h
        push esi
        mov ebx, dword [dword_D524C]
        push ebx
        mov ecx, dword [byte esp+018h]
        push ecx
        call SbMixerOpen
        add esp, byte 10h
        movsx eax, al
        cmp eax, byte 0FFFFFFFFh
        je short .2
        mov dword [dword_D5250], esi
        mov eax, 1
        pop esi
        pop ds
        ret
.2:
        xor esi, esi
        mov dword [dword_D5250], esi
.3:
        xor eax, eax
        pop esi
        pop ds
        ret
SbInit:
        push ds
        call __GETDS
        push esi
        push edi
        cmp dword [dword_D5250], byte 0
        je short .3
        mov word [word_F3716], 0Fh
        xor ebx, ebx
        mov word [word_F3718], bx
        mov word [word_F3714], bx
        xor eax, eax
        mov ebx, unk_D522E
.1:
        mov cl, al
        mov edx, 1
        shl edx, cl
        mov ecx, edx
        mov edx, eax
        shl edx, 4
        add edx, eax
        mov word [nosplit edx*2+word_F3454], cx
        mov word [nosplit edx*2+word_F3456], ax
        mov dword [nosplit edx*2+dword_F3462], ebx
        inc eax
        cmp eax, byte 4
        jl short .1
        xor eax, eax
.2:
        mov edx, eax
        shl edx, 4
        sub edx, eax
        mov ecx, 7
        lea edi, [nosplit edx*2+unk_F3534]
        mov esi, unk_D522E
        rep movsd
        movsw
        inc eax
        cmp eax, byte 10h
        jl short .2
.3:
        pop edi
        pop esi
        pop ds
        ret
SbClose:
        push ds
        call __GETDS
        cmp dword [dword_D5250], byte 0
        je short .1
        call SbMixerClose
        mov eax, dword [dword_D525C]
        call SbFreeDosBuffer
        xor ebx, ebx
        mov dword [dword_D5250], ebx
.1:
        pop ds
        ret
SbService:
        push ds
        call __GETDS
        push esi
        push edi
        sub esp, byte 4
        xor edi, edi
        mov dword [esp], 1
        jmp short .5
.1:
        mov esi, edi
        shl esi, 4
        add esi, edi
        add esi, esi
        add esi, word_F3454
        movsx edx, word [esp]
        movsx eax, word [word_F3714]
        test edx, eax
        je short .2
        push edi
        call SbStreamIdle
        add esp, byte 4
        test ax, ax
        je short .2
        mov eax, esi
        call SbFreeVoice
.2:
        mov bx, word [byte esi+06h]
        cmp bx, byte 1
        jge short .3
        mov word [byte esi+06h], 0
        jmp short .4
.3:
        mov ecx, ebx
        dec ecx
        mov word [byte esi+06h], cx
.4:
        mov esi, dword [esp]
        add esi, esi
        mov dword [esp], esi
        inc edi
.5:
        cmp edi, byte 4
        jl short .1
        xor edi, edi
        jmp short .8
.6:
        imul esi, edi, byte 16h
        add esi, dword_F34DC
        cmp word [byte esi+0Ah], byte 0
        je short .7
        mov eax, dword [esi]
        movsx esi, word [byte esi+010h]
        push esi
        movsx eax, word [byte eax+04h]
        push eax
        push byte 0
        push byte 0
        push edi
        call SbStreamApplyBend
        add esp, byte 14h
.7:
        inc edi
.8:
        cmp edi, byte 4
        jl short .6
        call SbMixChannels
        add esp, byte 4
        pop edi
        pop esi
        pop ds
        ret
SbQuery:
        push ds
        call __GETDS
        push esi
        mov edx, dword [byte esp+0Ch]
        cmp dx, byte 9
        jb short .2
        jbe short .5
        cmp dx, byte 32h
        jb short .1
        jbe short .8
        cmp dx, byte 33h
        je near .10
        jmp near .9
.1:
        cmp dx, byte 0Ah
        je short .6
        jmp near .9
.2:
        cmp dx, byte 7
        jb short .9
        ja short .4
        call SbMixRateDiv
.3:
        movsx esi, ax
        mov eax, esi
        pop esi
        pop ds
        ret
.4:
        call SbDmaHalfReady
        jmp short .3
.5:
        movsx esi, word [byte esp+0Eh]
        push esi
        call SbStreamIdle
        add esp, byte 4
        jmp short .3
.6:
        movsx eax, word [byte esp+0Eh]
        push eax
        call SbStreamGetVolume
        mov esi, eax
.7:
        add esp, byte 4
        mov eax, esi
        pop esi
        pop ds
        ret
.8:
        mov esi, dword [byte esp+0Ch]
        sar esi, 10h
        and esi, 0FFh
        push esi
        mov esi, dword [byte esp+010h]
        sar esi, 18h
        push esi
        call SbStreamSetVolume
        add esp, byte 8
.9:
        mov esi, 0FFFFFFFFh
        mov eax, esi
        pop esi
        pop ds
        ret
.10:
        movsx eax, word [byte esp+0Eh]
        push eax
        call SbSetStereo
        jmp short .7
SbSetTrack:
        push ds
        call __GETDS
        movsx edx, word [byte esp+08h]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        mov edx, dword [byte esp+0Ch]
        mov word [nosplit eax*2+word_F3538], dx
        pop ds
        ret
SbPlayDigi:
        push ds
        call __GETDS
        push esi
        push edi
        push ebp
        mov edx, dword [byte esp+034h]
        push edx
        mov ebx, dword [byte esp+034h]
        push ebx
        mov ecx, dword [byte esp+034h]
        push ecx
        mov esi, dword [byte esp+034h]
        push esi
        mov edi, dword [byte esp+034h]
        push edi
        mov ebp, dword [byte esp+034h]
        push ebp
        mov eax, dword [byte esp+030h]
        add eax, dword [byte esp+034h]
        push eax
        movsx eax, word [byte esp+030h]
        push eax
        call SbStreamStart
        add esp, byte 20h
        pop ebp
        pop edi
        pop esi
        pop ds
        ret
SbNoteOff:
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 4
        push edx
        movsx ecx, ax
        mov eax, ecx
        shl eax, 4
        sub eax, ecx
        add eax, eax
        mov edi, unk_F3534
        add edi, eax
        mov ax, word [edi]
        mov dword [byte esp+04h], eax
        xor edx, edx
        mov ebx, 1
        jmp near .4
.1:
        movsx ecx, bx
        movsx eax, word [byte esp+04h]
        test ecx, eax
        je short .3
        movsx esi, dx
        mov eax, esi
        shl eax, 4
        add eax, esi
        add eax, eax
        add eax, word_F3454
        cmp edi, dword [byte eax+0Eh]
        jne short .3
        mov ecx, dword [esp]
        cmp cx, word [byte eax+08h]
        jne short .3
        cmp byte [byte edi+014h], 0
        je short .2
        or word [byte edi+02h], bx
        jmp short .5
.2:
        or word [word_F3714], bx
        sar word [byte eax+06h], 1
        imul eax, esi, byte 16h
        add eax, dword_F34DC
        mov word [byte eax+0Ah], 1
        cmp dx, byte 1
        jle short .5
        push esi
        call SbStreamRelease
        add esp, byte 4
        jmp short .5
.3:
        add ebx, ebx
        inc edx
.4:
        cmp dx, byte 4
        jl short .1
.5:
        add esp, byte 8
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
SbNoteOn:
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 14h
        mov esi, eax
        mov dword [byte esp+08h], edx
        mov dword [byte esp+0Ch], ebx
        cwde
        mov edx, eax
        shl edx, 4
        sub edx, eax
        add edx, edx
        mov ecx, unk_F3534
        add ecx, edx
        cmp si, byte 9
        jne short .1
        mov edx, dword [byte esp+08h]
        cmp dx, byte 24h
        jl near .17
        cmp dx, byte 64h
        jge near .17
        add edx, byte 5Ch
        movsx edx, dx
        call SbProgramChange
        mov dword [byte esp+010h], 3Ch
        jmp short .2
.1:
        mov eax, dword [byte esp+08h]
        mov dword [byte esp+010h], eax
.2:
        cmp word [byte ecx+04h], byte 0
        je near .17
        cmp word [byte ecx+08h], byte 0
        je near .17
        mov edi, 7D00h
        mov dword [byte esp+04h], word_F3454
        xor ebx, ebx
        mov eax, 1
        jmp near .6
.3:
        movsx esi, bx
        mov edx, esi
        shl edx, 4
        add edx, esi
        add edx, edx
        add edx, word_F3454
        movsx esi, ax
        mov dword [esp], esi
        movsx esi, word [word_F3718]
        and esi, dword [esp]
        movsx ebp, word [byte ecx+04h]
        test esi, ebp
        je short .4
        mov si, word [byte edx+06h]
        cmp di, si
        jle short .4
        mov edi, esi
        mov dword [byte esp+04h], edx
.4:
        movsx esi, word [ecx]
        mov dword [esp], esi
        movsx esi, ax
        and esi, dword [esp]
        movsx ebp, word [byte ecx+04h]
        test esi, ebp
        je short .5
        cmp ecx, dword [byte edx+0Eh]
        jne short .5
        mov esi, dword [byte esp+08h]
        cmp si, word [byte edx+08h]
        jne short .5
        push edx
        movsx ebx, word [byte esp+010h]
        movsx edx, si
        jmp near .16
.5:
        add eax, eax
        inc ebx
.6:
        cmp bx, byte 4
        jl short .3
        xor ebx, ebx
        mov ax, word [ecx]
.7:
        test ax, ax
        je short .8
        mov edx, eax
        neg edx
        and edx, eax
        xor eax, edx
        inc ebx
        jmp short .7
.8:
        cmp bx, word [byte ecx+08h]
        jge short .12
        mov ax, word [word_F3716]
        and ax, word [byte ecx+04h]
        je short .12
        mov edx, eax
        neg edx
        and eax, edx
        mov ebx, 0FFFFFFFFh
        jmp short .10
.9:
        sar ax, 1
        inc ebx
.10:
        test ax, ax
        jne short .9
.11:
        movsx eax, bx
        mov edx, eax
        shl edx, 4
        add edx, eax
        add edx, edx
        add edx, word_F3454
        push edx
        movsx ebx, word [byte esp+010h]
        movsx edx, word [byte esp+0Ch]
        jmp short .16
.12:
        mov ax, word [word_F3714]
        and ax, word [byte ecx+04h]
        je short .15
        mov edx, eax
        neg edx
        and eax, edx
        mov ebx, 0FFFFFFFFh
        jmp short .14
.13:
        sar ax, 1
        inc ebx
.14:
        test ax, ax
        jne short .13
        jmp short .11
.15:
        mov edi, dword [byte esp+04h]
        push edi
        movsx ebx, word [byte esp+010h]
        movsx edx, word [byte esp+0Ch]
.16:
        movsx eax, word [byte esp+014h]
        call SbStartVoice
.17:
        add esp, byte 14h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
SbStartVoice:
        push esi
        push edi
        push eax
        push edx
        push ebx
        mov edi, ecx
        mov esi, dword [byte esp+018h]
        movsx eax, word [byte esi+02h]
        call SbStopVoice
        mov dx, word [esi]
        not edx
        mov eax, dword [byte esi+0Eh]
        and word [eax], dx
        mov eax, dword [byte esi+0Eh]
        mov dx, word [esi]
        not edx
        and word [byte eax+02h], dx
        mov dword [byte esi+0Eh], edi
        mov ax, word [byte edi+06h]
        mov word [byte esi+0Ch], ax
        mov eax, dword [byte edi+0Ah]
        mov dword [byte esi+012h], eax
        mov eax, dword [byte edi+0Eh]
        mov dword [byte esi+016h], eax
        xor edx, edx
        mov dl, byte [byte eax+0Dh]
        push edx
        movsx ecx, byte [byte eax+0Ah]
        movsx ebx, byte [byte eax+08h]
        mov edx, dword [byte esi+012h]
        movsx eax, word [byte esi+02h]
        call SbVoiceStartSample
        mov eax, dword [byte esi+016h]
        mov al, byte [byte eax+0Ch]
        xor ah, ah
        shl eax, 6
        mov word [byte esi+06h], ax
        mov eax, dword [byte esp+04h]
        mov word [byte esi+08h], ax
        mov eax, dword [esp]
        mov word [byte esi+0Ah], ax
        mov ax, word [esi]
        not eax
        and word [word_F3716], ax
        mov ax, word [esi]
        or word [word_F3718], ax
        mov ax, word [esi]
        not eax
        and word [word_F3714], ax
        mov ax, word [esi]
        or word [edi], ax
        mov ax, word [esi]
        not eax
        and word [byte edi+02h], ax
        lea edx, [byte edi+012h]
        movsx eax, word [byte esi+02h]
        call SbSetVoiceOwner
        movsx ebx, word [esp]
        mov eax, dword [byte edi+0Eh]
        movsx ax, byte [byte eax+07h]
        add eax, dword [byte esp+08h]
        movsx edx, ax
        movsx eax, word [byte esi+02h]
        call SbVoiceSetVolume
        movsx ebx, byte [byte edi+015h]
        movsx eax, word [byte esi+02h]
        mov edx, 1
        call SbVoiceController
        movsx ebx, byte [byte edi+012h]
        movsx eax, word [byte esi+02h]
        mov edx, 7
        call SbVoiceController
        add esp, byte 0Ch
        pop edi
        pop esi
        ret 4
SbVoiceStartSample:
        push esi
        push edi
        push ebp
        mov edi, edx
        movsx ebp, ax
        imul esi, ebp, byte 16h
        add esi, dword_F34DC
        mov dword [byte esi+04h], edx
        mov word [byte esi+012h], bx
        mov word [byte esi+010h], cx
        mov eax, dword [byte esp+010h]
        mov word [byte esi+014h], ax
        lea esi, [byte edx+010h]
        xor eax, eax
        mov ax, word [byte esi+02h]
        push eax
        push ebp
        call SbStreamSetRate
        add esp, byte 8
        mov edx, dword [byte esi+0Ch]
        push edx
        mov ebx, dword [byte esi+08h]
        push ebx
        mov ecx, dword [byte esi+04h]
        push ecx
        mov esi, dword [byte edi+0Ch]
        push esi
        push ebp
        call SbStreamSetSample
        add esp, byte 14h
        pop ebp
        pop edi
        pop esi
        ret 4
SbVoiceSetVolume:
        push ecx
        push esi
        mov ecx, eax
        cwde
        imul eax, byte 16h
        add eax, dword_F34DC
        mov word [byte eax+0Ch], dx
        mov word [byte eax+0Eh], dx
        mov word [byte eax+0Ah], 3
        movsx esi, word [byte eax+014h]
        movsx eax, bx
        add eax, esi
        cmp eax, byte 7Fh
        jl short .1
        mov eax, 7Fh
.1:
        cwde
        push eax
        movsx eax, dx
        push eax
        movsx eax, cx
        push eax
        call SbStreamPlayNote
        add esp, byte 0Ch
        pop esi
        pop ecx
        ret
SbController:
        push ecx
        push esi
        push edi
        push eax
        push edx
        push ebx
        movsx edx, ax
        mov eax, edx
        shl eax, 4
        sub eax, edx
        add eax, eax
        mov ebx, unk_F3534
        add ebx, eax
        mov edx, dword [byte esp+04h]
        cmp dx, byte 0Ah
        jb short .1
        jbe short .4
        cmp dx, byte 40h
        jb near .13
        jbe short .5
        cmp dx, byte 7Bh
        je near .9
        jmp near .13
.1:
        cmp dx, byte 1
        jb near .13
        jbe short .2
        cmp dx, byte 7
        je short .3
        jmp near .13
.2:
        mov al, byte [esp]
        mov byte [byte ebx+015h], al
        jmp near .13
.3:
        mov al, byte [esp]
        mov byte [byte ebx+012h], al
        jmp near .13
.4:
        mov al, byte [esp]
        mov byte [byte ebx+013h], al
        jmp near .13
.5:
        mov al, byte [esp]
        mov byte [byte ebx+014h], al
        mov edx, dword [esp]
        test dx, dx
        jne near .13
        mov di, word [byte ebx+02h]
        mov word [byte ebx+02h], dx
        xor ecx, ecx
        mov esi, 1
        jmp short .8
.6:
        movsx edx, si
        movsx eax, di
        test edx, eax
        je short .7
        movsx edx, cx
        mov eax, edx
        shl eax, 4
        add eax, edx
        movsx edx, word [nosplit eax*2+word_F345C]
        movsx eax, word [byte esp+08h]
        call SbNoteOff
.7:
        add esi, esi
        inc ecx
.8:
        cmp cx, byte 4
        jl short .6
        jmp short .13
.9:
        mov di, word [ebx]
        xor ecx, ecx
        mov esi, 1
        jmp short .12
.10:
        movsx edx, si
        movsx eax, di
        test edx, eax
        je short .11
        movsx edx, cx
        mov eax, edx
        shl eax, 4
        add eax, edx
        add eax, eax
        add eax, word_F3454
        call SbFreeVoice
.11:
        add esi, esi
        inc ecx
.12:
        cmp cx, byte 4
        jl short .10
.13:
        mov di, word [ebx]
        xor ecx, ecx
        mov esi, 1
        jmp short .16
.14:
        movsx eax, si
        movsx edx, di
        test eax, edx
        je short .15
        movsx ebx, word [esp]
        movsx edx, word [byte esp+04h]
        movsx eax, cx
        call SbVoiceController
.15:
        add esi, esi
        inc ecx
.16:
        cmp cx, byte 4
        jl short .14
        jmp near SbPopArgsReturn
SbVoiceController:
        push ecx
        cmp dx, byte 7
        jne short .1
        movsx edx, bx
        push edx
        cwde
        push eax
        call SbStreamSetVolume
        add esp, byte 8
.1:
        pop ecx
        ret
SbSetVoiceOwner:
        cwde
        imul eax, byte 16h
        mov dword [dword eax+dword_F34DC], edx
        ret
SbFreeVoice:
        push ebx
        push edx
        mov edx, eax
        movsx eax, word [byte eax+02h]
        call SbStopVoice
        mov word [byte edx+06h], 0
        mov ax, word [edx]
        or word [word_F3716], ax
        mov ax, word [edx]
        not eax
        and word [word_F3718], ax
        mov ax, word [edx]
        not eax
        and word [word_F3714], ax
        mov bx, word [edx]
        not ebx
        mov eax, dword [byte edx+0Eh]
        and word [eax], bx
        mov eax, dword [byte edx+0Eh]
        mov dx, word [edx]
        not edx
        and word [byte eax+02h], dx
        pop edx
        pop ebx
        ret
SbStopVoice:
        push ebx
        push ecx
        push edx
        cwde
        imul edx, eax, byte 16h
        add edx, dword_F34DC
        mov word [byte edx+0Ah], 0
        push eax
        call SbStreamStop
        add esp, byte 4
        pop edx
        pop ecx
        pop ebx
        ret
SbProgramChange:
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 4
        mov edi, eax
        mov word [esp], dx
        cwde
        mov esi, eax
        shl esi, 4
        sub esi, eax
        add esi, esi
        add esi, unk_F3534
        xor eax, eax
        mov al, byte [esp]
        push eax
        call GetPatchEntry
        add esp, byte 4
        mov dword [byte esi+0Eh], eax
        test eax, eax
        je short .3
        mov eax, dword [byte eax+010h]
        mov dword [byte esi+0Ah], eax
        cmp di, byte 9
        je short .1
        mov eax, dword [byte esi+0Eh]
        mov al, byte [byte eax+06h]
        xor ah, ah
        mov word [byte esi+08h], ax
        jmp short .2
.1:
        mov word [byte esi+08h], 4
.2:
        mov eax, dword [byte esi+0Eh]
        mov ax, word [byte eax+02h]
        xor ah, ah
        and al, 0Fh
        mov word [byte esi+04h], ax
        mov eax, dword [esp]
        mov word [byte esi+06h], ax
.3:
        add esp, byte 4
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
SbPitchBend:
        push ebx
        mov ebx, edx
        movsx edx, ax
        mov eax, edx
        shl eax, 4
        sub eax, edx
        mov word [nosplit eax*2+word_F354A], bx
        pop ebx
        ret
SbAllocDosBuffer:
        push ecx
        push esi
        push edi
        sub esp, byte 28h
        mov ecx, eax
        mov esi, edx
        mov edi, ebx
        mov ebx, 0Ch
        xor edx, edx
        lea eax, [byte esp+01Ch]
        call memset_
        mov word [esp], 100h
        mov word [byte esp+04h], cx
        lea ecx, [byte esp+01Ch]
        mov ebx, esp
        mov edx, esp
        mov eax, 31h
        call int386x_
        xor eax, eax
        mov ax, word [esp]
        mov dword [esi], eax
        xor eax, eax
        mov ax, word [byte esp+0Ch]
        mov dword [edi], eax
        mov eax, dword [esi]
        shl eax, 4
        add esp, byte 28h
        pop edi
        pop esi
        pop ecx
        ret
SbFreeDosBuffer:
        push ebx
        push ecx
        push edx
        sub esp, byte 28h
        mov ecx, eax
        mov ebx, 0Ch
        xor edx, edx
        lea eax, [byte esp+01Ch]
        call memset_
        mov word [esp], 101h
        mov word [byte esp+0Ch], cx
        lea ecx, [byte esp+01Ch]
        mov ebx, esp
        mov edx, esp
        mov eax, 31h
        call int386x_
        add esp, byte 28h
        pop edx
        pop ecx
        pop ebx
        ret
SbSetMixerVolumes:
        push ebx
        push ecx
        push esi
        lea esi, [byte eax+04h]
        lea ecx, [byte eax+05h]
        mov bl, dl
        shl bl, 4
        or bl, dl
        mov edx, 4
        mov eax, esi
        call outp_
        movsx ebx, bl
        mov edx, ebx
        mov eax, ecx
        call outp_
        mov edx, 22h
        mov eax, esi
        call outp_
        mov edx, ebx
        mov eax, ecx
        call outp_
        mov edx, 26h
        mov eax, esi
        call outp_
        mov edx, ebx
        mov eax, ecx
        call outp_
        pop esi
        pop ecx
        pop ebx
        ret
        db 00h
