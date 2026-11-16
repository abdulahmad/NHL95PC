; Drawing shapes from a shape file.
bits 32
%include "hockey.inc"
section s_98B30 progbits alloc exec nowrite align=1
extern abs_, str_RemovewindowROWSPACE, str_FshVshQfsQvs, str_Vsh, str_Qvs, SeqQueueCount, SeqTickCount, SeqServiceBusy
extern byte_F1704, byte_F1705, byte_F1784, byte_F188C, byte_F188D, byte_F188E, byte_F1A1C, byte_F234D
extern byte_F234E, RowTableBuffer, SeqQueueHead, sndhandlecount, SongReleasedFlag, MidiMusicEnabled, SndTimerHandle, MidiTickCount
extern dword_EDAA8, dword_F1888, dword_F1890, dword_F189C, dword_F22FC, FatalError, stricmp_, AllocMemBlockEx
extern PushMemDescriptorLocked, FindCachedFile, GetPatchEntry, StopDigiChannel, SndHandleService, SndDriverCall, SndHandleMidi, DrawShapeQuad
extern SplitFileExt, LoadPackedCore, ConvertShapeBank, ConvertShapeBankInPlace, ShapeWidth, ShapeHeight, unk_F1884, unk_F21FC
extern ActiveSongCount
global DrawShapeStretched, DrawShapeStretchedAt, FillRowTable, removewindow, LoadFileCached, SeqService, SeqUpdate, SeqUpdate
global SeqStepTrack, SeqSendController, SeqNoteOffSlot, SeqChannelNotesOff, SeqSendPitchBend, SeqNoteOn, SeqQueueCommand, SeqFlushQueue
global SeqSendProgram, jpt_998DD, SeqReadEvent, SeqReadEvent, SeqReadEvent, PeekDword, PeekWord
DrawShapeStretched:
        push esi
        push edi
        push ebp
        sub esp, byte 34h
        mov ebp, dword [byte esp+044h]
        mov esi, dword [byte esp+048h]
        push ebp
        call ShapeWidth
        mov edi, eax
        add esp, byte 4
        push ebp
        call ShapeHeight
        add esp, byte 4
        mov ebx, 1
        mov dword [byte esp+018h], ebx
        mov dword [byte esp+01Ch], ebx
        sub edi, byte 3
        mov dword [byte esp+020h], edi
        mov dword [byte esp+024h], ebx
        mov dword [byte esp+030h], edi
        mov dword [byte esp+028h], edi
        lea edi, [byte eax-03h]
        mov dword [byte esp+02Ch], edi
        push esi
        lea eax, [byte esp+01Ch]
        push eax
        push ebp
        call DrawShapeQuad
        add esp, byte 0Ch
        mov eax, dword [byte esp+030h]
        mov dword [byte esp+018h], eax
        mov dword [byte esp+01Ch], edi
        mov eax, 1
        mov dword [byte esp+020h], eax
        mov dword [byte esp+024h], edi
        mov dword [byte esp+028h], eax
        mov dword [byte esp+02Ch], eax
        mov eax, dword [byte esi+010h]
        mov dword [esp], eax
        mov eax, dword [byte esi+014h]
        mov dword [byte esp+04h], eax
        mov eax, dword [byte esi+018h]
        mov dword [byte esp+08h], eax
        mov eax, dword [byte esi+01Ch]
        mov dword [byte esp+0Ch], eax
        mov eax, dword [esi]
        mov dword [byte esp+010h], eax
        mov eax, dword [byte esi+04h]
        mov dword [byte esp+014h], eax
        mov eax, esp
        push eax
        lea eax, [byte esp+01Ch]
        push eax
        push ebp
        call DrawShapeQuad
        add esp, byte 0Ch
        add esp, byte 34h
        pop ebp
        pop edi
        pop esi
        ret
        db 08Dh,040h,00h
DrawShapeStretchedAt:
        push esi
        push edi
        push ebp
        sub esp, byte 34h
        mov edi, dword [byte esp+048h]
        mov esi, dword [byte esp+04Ch]
        mov edx, dword [byte esp+044h]
        push edx
        call ShapeWidth
        mov dword [byte esp+034h], eax
        add esp, byte 4
        mov ebx, dword [byte esp+044h]
        push ebx
        call ShapeHeight
        mov ebp, eax
        add esp, byte 4
        mov ecx, 1
        mov dword [esp], ecx
        mov dword [byte esp+04h], ecx
        mov eax, dword [byte esp+030h]
        sub eax, byte 2
        mov dword [byte esp+08h], eax
        mov dword [byte esp+0Ch], ecx
        mov dword [byte esp+030h], eax
        mov dword [byte esp+010h], eax
        sub ebp, byte 2
        mov dword [byte esp+014h], ebp
        mov eax, dword [esi]
        mov eax, dword [edi+eax*8]
        mov dword [byte esp+018h], eax
        mov eax, dword [esi]
        mov eax, dword [byte edi+eax*8+04h]
        mov dword [byte esp+01Ch], eax
        mov eax, dword [byte esi+04h]
        mov eax, dword [edi+eax*8]
        mov dword [byte esp+020h], eax
        mov eax, dword [byte esi+04h]
        mov eax, dword [byte edi+eax*8+04h]
        mov dword [byte esp+024h], eax
        mov eax, dword [byte esi+08h]
        mov eax, dword [edi+eax*8]
        mov dword [byte esp+028h], eax
        mov eax, dword [byte esi+08h]
        mov eax, dword [byte edi+eax*8+04h]
        mov dword [byte esp+02Ch], eax
        lea eax, [byte esp+018h]
        push eax
        lea eax, [byte esp+04h]
        push eax
        mov ebx, dword [byte esp+04Ch]
        push ebx
        call DrawShapeQuad
        add esp, byte 0Ch
        mov eax, dword [byte esp+030h]
        mov dword [esp], eax
        mov dword [byte esp+04h], ebp
        mov ecx, 1
        mov dword [byte esp+08h], ecx
        mov dword [byte esp+0Ch], ebp
        mov dword [byte esp+010h], ecx
        mov dword [byte esp+014h], ecx
        mov eax, dword [byte esi+08h]
        mov eax, dword [edi+eax*8]
        mov dword [byte esp+018h], eax
        mov eax, dword [byte esi+08h]
        mov eax, dword [byte edi+eax*8+04h]
        mov dword [byte esp+01Ch], eax
        mov eax, dword [byte esi+0Ch]
        mov eax, dword [edi+eax*8]
        mov dword [byte esp+020h], eax
        mov eax, dword [byte esi+0Ch]
        mov eax, dword [byte edi+eax*8+04h]
        mov dword [byte esp+024h], eax
        mov eax, dword [esi]
        mov eax, dword [edi+eax*8]
        mov dword [byte esp+028h], eax
        mov eax, dword [esi]
        mov eax, dword [byte edi+eax*8+04h]
        mov dword [byte esp+02Ch], eax
        lea eax, [byte esp+018h]
        push eax
        lea eax, [byte esp+04h]
        push eax
        mov edx, dword [byte esp+04Ch]
        push edx
        call DrawShapeQuad
        add esp, byte 0Ch
        add esp, byte 34h
        pop ebp
        pop edi
        pop esi
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
FillRowTable:
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov ecx, eax
        mov edi, edx
        mov esi, ebx
        xor ebx, ebx
        mov eax, dword [RowTableBuffer]
        cmp eax, dword [dword_EDAA8]
        jae short .4
        mov edx, ecx
        add edx, edi
        mov dword [esp], edx
.1:
        mov edx, dword [eax]
        cmp edx, esi
        jl short .3
        cmp dword [byte eax+04h], byte 0
        jbe short .2
        cmp ecx, dword [byte eax+08h]
        jne short .3
        mov ebp, dword [byte eax+0Ch]
        cmp ebp, dword [esp]
        jne short .3
        inc dword [byte eax+04h]
        add eax, byte 8
        jmp near .10
.2:
        test ebx, ebx
        jne short .3
        mov ebx, eax
.3:
        shl edx, 2
        add edx, byte 8
        add eax, edx
        cmp eax, dword [dword_EDAA8]
        jb short .1
.4:
        test ebx, ebx
        je short .9
        mov eax, dword [ebx]
        lea edx, [byte esi+08h]
        cmp eax, edx
        jge short .5
        mov esi, eax
        jmp short .6
.5:
        mov edx, eax
        sub edx, esi
        sub edx, byte 2
        mov dword [byte ebx+esi*4+08h], edx
        mov dword [byte ebx+esi*4+0Ch], 0
.6:
        mov dword [ebx], esi
        add ebx, byte 4
        mov dword [ebx], 1
        xor edx, edx
        add ebx, byte 4
        test esi, esi
        jle short .8
        mov eax, ebx
.7:
        mov dword [eax], ecx
        add ecx, edi
        add eax, byte 4
        inc edx
        cmp edx, esi
        jl short .7
.8:
        mov eax, ebx
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
.9:
        xor eax, eax
.10:
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
        db 090h
removewindow:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov edx, eax
        mov ebx, dword [byte eax+04h]
        dec ebx
        mov dword [byte eax+04h], ebx
        test ebx, ebx
        ja short .5
        mov esi, dword [RowTableBuffer]
        xor edi, edi
        cmp esi, eax
        jae short .2
.1:
        mov edi, esi
        mov eax, dword [esi]
        add eax, byte 2
        shl eax, 2
        add esi, eax
        cmp esi, edx
        jb short .1
.2:
        cmp esi, edx
        je short .3
        push str_RemovewindowROWSPACE
        call FatalError
        add esp, byte 4
.3:
        mov eax, dword [esi]
        add eax, byte 2
        shl eax, 2
        add eax, esi
        cmp eax, dword [dword_EDAA8]
        jae short .4
        cmp dword [byte eax+04h], byte 0
        ja short .4
        mov eax, dword [eax]
        add eax, byte 2
        add dword [esi], eax
.4:
        test edi, edi
        je short .5
        cmp dword [byte edi+04h], byte 0
        ja short .5
        mov eax, dword [esi]
        add eax, byte 2
        add dword [edi], eax
.5:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
        db 00h,00h,00h
LoadFileCached:
        push esi
        push edi
        push ebp
        sub esp, byte 64h
        mov ebp, dword [byte esp+078h]
        mov edi, dword [byte esp+07Ch]
        push str_FshVshQfsQvs
        lea eax, [byte esp+04h]
        push eax
        mov edx, dword [byte esp+07Ch]
        push edx
        call SplitFileExt
        mov esi, eax
        add esp, byte 0Ch
        mov eax, esp
        push eax
        call FindCachedFile
        add esp, byte 4
        test eax, eax
        jne near .3
        mov edx, str_Vsh
        mov eax, esi
        call stricmp_
        test eax, eax
        je short .1
        mov edx, str_Qvs
        mov eax, esi
        call stricmp_
        test eax, eax
        jne short .2
.1:
        push edi
        mov eax, ebp
        xor al, 20h
        push eax
        lea eax, [byte esp+08h]
        push eax
        call LoadPackedCore
        mov esi, eax
        add esp, byte 0Ch
        test eax, eax
        je short .3
        mov ebx, dword [eax]
        push ebx
        call ConvertShapeBankInPlace
        add esp, byte 4
        push edi
        push ebp
        push eax
        lea eax, [byte esp+0Ch]
        push eax
        call AllocMemBlockEx
        mov edi, eax
        add esp, byte 10h
        mov ecx, dword [eax]
        push ecx
        mov ebp, dword [esi]
        push ebp
        call ConvertShapeBank
        add esp, byte 8
        push esi
        call PushMemDescriptorLocked
        add esp, byte 4
        mov eax, edi
        jmp short .3
.2:
        push edi
        push ebp
        lea eax, [byte esp+08h]
        push eax
        call LoadPackedCore
        add esp, byte 0Ch
.3:
        add esp, byte 64h
        pop ebp
        pop edi
        pop esi
        ret
SeqService:
        push edx
        mov ah, byte [SeqServiceBusy]
        test ah, ah
        jne short .1
        cmp word [ActiveSongCount], byte 0
        jne short .1
        cmp dword [sndhandlecount], byte 0
        je short .1
        mov dl, ah
        inc dl
        mov byte [SeqServiceBusy], dl
        call SeqUpdate
        dec byte [SeqServiceBusy]
.1:
        pop edx
        ret
SeqUpdate:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        xor ecx, ecx
        inc byte [SeqTickCount]
.1:
        mov eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 2
        mov ebx, dword_F22FC
        add ebx, eax
        cmp dword [ebx], byte 0
        je short .3
        mov eax, dword [byte ebx+08h]
        mov esi, dword [byte ebx+04h]
        sub esi, eax
        mov dword [byte ebx+04h], esi
        sar esi, 18h
        cmp esi, dword [ebx]
        je short .3
        mov eax, ecx
        shl eax, 18h
        mov edx, esi
        shl edx, 10h
        add eax, byte 32h
        add edx, eax
        xor eax, eax
        mov al, byte [byte ebx+010h]
        call SndDriverCall
        test esi, esi
        jg short .2
        mov eax, dword [byte ebx+0Ch]
        mov edx, ecx
        call StopDigiChannel
        xor esi, esi
.2:
        mov dword [ebx], esi
.3:
        inc ecx
        cmp ecx, byte 4
        jl short .1
        cmp dword [SndTimerHandle], byte 0
        jl short .4
        xor eax, eax
        mov al, byte [SndTimerHandle]
        mov edx, 8
        call SndDriverCall
        test eax, eax
        je short .4
        xor eax, eax
        mov al, byte [SndTimerHandle]
        call SndHandleService
.4:
        xor ecx, ecx
        jmp short .7
.5:
        cmp ecx, dword [SndTimerHandle]
        je short .6
        xor eax, eax
        mov al, cl
        call SndHandleService
.6:
        inc ecx
.7:
        cmp ecx, dword [sndhandlecount]
        jl short .5
        call SeqFlushQueue
        cmp dword [SongReleasedFlag], byte 0
        jne near .13
        mov ebx, byte_F1A1C
        xor ecx, ecx
.8:
        mov dl, byte [byte ebx+01h]
        test dl, dl
        je short .10
        test dl, 8
        je short .9
        mov eax, dword [byte ebx+06h]
        mov dl, byte [byte eax+015h]
        mov dh, byte [SeqTickCount]
        cmp dl, dh
        je short .9
        mov byte [byte eax+015h], dh
        mov eax, dword [byte ebx+06h]
        mov dx, word [byte eax+0Eh]
        test dx, dx
        je short .9
        movzx ebp, byte [byte eax+010h]
        mov esi, edx
        movsx edx, dx
        dec esi
        mov word [byte eax+0Eh], si
        mov eax, edx
        call abs_
        mov edx, ebp
        imul edx, eax
        mov esi, dword [byte ebx+06h]
        movsx edi, word [byte esi+0Ch]
        mov eax, edx
        sar edx, 1Fh
        idiv edi
        mov byte [byte esi+011h], al
.9:
        mov eax, ebx
        call SeqStepTrack
.10:
        add ebx, byte 54h
        inc ecx
        cmp ecx, byte 18h
        jl short .8
        mov ebx, dword_F189C
        xor ecx, ecx
.11:
        cmp byte [byte ebx+05h], 0FFh
        jne short .12
        mov esi, dword [byte ebx+08h]
        dec esi
        mov dword [byte ebx+08h], esi
        jne short .12
        mov eax, ebx
        call SeqNoteOffSlot
.12:
        add ebx, byte 0Ch
        inc ecx
        cmp ecx, byte 20h
        jl short .11
.13:
        cmp dword [SndTimerHandle], byte 0
        jl short SeqUpdate+017Eh
        xor eax, eax
        mov al, byte [SndTimerHandle]
        mov edx, 8
        call SndDriverCall
        test eax, eax
        je short SeqUpdate+017Eh
        xor eax, eax
        mov al, byte [SndTimerHandle]
        call SndHandleService
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
SeqStepTrack:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov esi, eax
        cmp dword [byte eax+0Ah], byte 0
        je near .42
        mov edi, unk_F21FC
        mov ebx, dword [MidiTickCount]
        add edi, ebx
        lea ecx, [byte ebx+04h]
        mov dword [MidiTickCount], ecx
        mov byte [edi], 80h
        test byte [byte eax+01h], 8
        je near .6
        mov eax, dword [byte esi+06h]
        cmp word [byte eax+0Eh], byte 0
        jne short .4
        mov edx, dword_F189C
        xor ebx, ebx
        jmp short .3
.1:
        mov eax, dword [edx]
        cmp eax, dword [byte esi+02h]
        jne short .2
        mov al, byte [byte edx+05h]
        cmp al, byte [esi]
        jne short .2
        mov eax, edx
        call SeqNoteOffSlot
.2:
        add edx, byte 0Ch
        inc ebx
.3:
        cmp bx, byte 20h
        jl short .1
        mov al, byte [byte esi+050h]
        or al, 0B0h
        mov byte [edi], al
        mov byte [byte edi+01h], 7Bh
        mov byte [byte edi+02h], 0
        xor eax, eax
        mov al, byte [byte esi+051h]
        mov ebx, edi
        mov edx, 3
        call SeqQueueCommand
        mov dword [byte esi+0Ah], 0
        mov byte [byte esi+01h], 0
        jmp near .41
.4:
        movsx edx, word [byte eax+0Ch]
        movsx eax, word [byte eax+0Eh]
        call abs_
        cmp eax, edx
        jne short .5
        mov eax, dword [byte esi+06h]
        mov dl, byte [byte eax+010h]
        mov byte [byte eax+011h], dl
        and byte [byte esi+01h], 0F7h
        jmp short .6
.5:
        mov eax, dword [byte esi+06h]
        mov bx, word [byte eax+0Eh]
        test bx, bx
        je short .6
        movsx edx, word [byte eax+0Ch]
        movsx eax, bx
        call abs_
        cmp eax, edx
        je short .6
        xor edx, edx
        mov dl, byte [byte esi+050h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        xor ebx, ebx
        mov bl, byte [dword eax+byte_F234D]
        mov edx, 7
        mov eax, esi
        call SeqSendController
.6:
        add word [byte esi+04Ah], 80h
.7:
        mov ax, word [byte esi+04Ah]
        cmp ax, word [byte esi+04Ch]
        jl near .41
        cmp dword [byte esi+0Ah], byte 0
        je near .41
        mov edx, dword_F189C
        xor ebx, ebx
        jmp short .10
.8:
        mov al, byte [byte edx+05h]
        cmp al, byte [esi]
        jne short .9
        mov ebp, dword [byte edx+08h]
        dec ebp
        mov dword [byte edx+08h], ebp
        jne short .9
        mov eax, edx
        call SeqNoteOffSlot
.9:
        add edx, byte 0Ch
        inc ebx
.10:
        cmp bx, byte 20h
        jl short .8
        mov edx, dword [byte esi+0Eh]
        test edx, edx
        je short .11
        lea ecx, [byte edx-01h]
        mov dword [byte esi+0Eh], ecx
        jmp near .40
.11:
        cmp dword [byte esi+0Ah], byte 0
        je near .40
.12:
        cmp dword [byte esi+0Eh], byte 0
        jne near .39
        mov ebx, dword [byte esi+0Ah]
        test ebx, ebx
        je near .39
        mov edx, ebx
        mov eax, unk_F1884
        call SeqReadEvent
        xor eax, eax
        mov al, byte [byte_F188E]
        mov ebp, dword [byte esi+0Ah]
        add ebp, eax
        mov dword [byte esi+0Ah], ebp
        mov al, byte [byte_F188C]
        cmp al, 0D9h
        jb near .34
        mov dl, byte [byte_F188D]
        cmp al, 0E2h
        jb short .15
        jbe near .24
        cmp al, 0E5h
        jb short .14
        jbe near .33
        cmp al, 0E8h
        jb short .13
        jbe near .27
        cmp al, 0EAh
        je short .17
        jmp near .38
.13:
        cmp al, 0E6h
        je near .20
        jmp near .38
.14:
        cmp al, 0E3h
        jbe near .25
        jmp near .26
.15:
        cmp al, 0DCh
        jb short .16
        jbe near .30
        cmp al, 0DDh
        jbe near .23
        cmp al, 0DFh
        je near .29
        jmp near .38
.16:
        cmp al, 0D9h
        jb near .38
        cmp al, 0DAh
        jbe short .18
        jmp short .22
.17:
        mov byte [byte esi+04Eh], dl
        jmp near .38
.18:
        mov bh, byte [byte esi+031h]
        test bh, bh
        je short .19
        xor eax, eax
        mov al, bh
        mov eax, dword [byte esi+eax*4+032h]
        mov dword [byte esi+0Ah], eax
        dec byte [byte esi+031h]
        jmp near .38
.19:
        mov dword [byte esi+0Ah], 0
        mov dword [byte esi+02h], 0
        mov byte [byte esi+01h], bh
        jmp near .38
.20:
        mov cl, byte [byte esi+031h]
        inc cl
        mov byte [byte esi+031h], cl
        xor eax, eax
        mov al, cl
        mov edx, dword [byte esi+0Ah]
        mov dword [byte esi+eax*4+032h], edx
        mov eax, dword [dword_F1888]
        add eax, byte 4
.21:
        mov dword [byte esi+0Ah], eax
        jmp near .38
.22:
        mov byte [byte esi+031h], 0
        mov byte [byte esi+030h], 0
        mov eax, dword [byte esi+032h]
        jmp short .21
.23:
        and edx, 0FFh
        mov eax, dword [byte esi+02h]
        call SeqChannelNotesOff
        jmp near .38
.24:
        xor eax, eax
        mov al, byte [byte esi+030h]
        mov dword [byte esi+eax*4+018h], ebp
        dec dl
        xor eax, eax
        mov al, byte [byte esi+030h]
        mov byte [byte esi+eax+012h], dl
        inc byte [byte esi+030h]
        jmp near .38
.25:
        mov ch, byte [byte esi+030h]
        test ch, ch
        je near .38
        xor eax, eax
        mov al, ch
        mov eax, dword [byte esi+eax*4+014h]
        mov dword [byte esi+0Ah], eax
        xor eax, eax
        mov al, byte [byte esi+030h]
        mov dl, byte [byte esi+eax+011h]
        mov dh, dl
        dec dh
        mov byte [byte esi+eax+011h], dh
        test dl, dl
        jne near .38
        dec byte [byte esi+030h]
        jmp near .38
.26:
        mov byte [byte esi+052h], dl
        jmp near .38
.27:
        xor eax, eax
        mov al, byte [byte_F188E]
        sub eax, byte 4
        xor edx, edx
        mov dx, ax
        xor eax, eax
        mov al, byte [byte esi+051h]
        mov ebx, byte_F1784
.28:
        call SndHandleMidi
        jmp near .38
.29:
        test byte [byte esi+01h], 8
        jne near .38
        xor ebx, ebx
        mov bl, byte [dword_F1888]
        and edx, 0FFh
        mov eax, esi
        call SeqSendController
        jmp near .38
.30:
        mov byte [byte esi+04Fh], dl
        mov al, byte [byte esi+050h]
        or al, 0C0h
        mov byte [edi], al
        mov byte [byte edi+01h], dl
        xor eax, eax
        mov al, dl
        push eax
        call GetPatchEntry
        add esp, byte 4
        mov edx, eax
        test eax, eax
        je short .32
        mov bl, byte [byte eax+0Fh]
        test bl, 80h
        je short .31
        mov al, bl
        and al, 7Fh
        mov byte [byte esi+051h], al
        jmp short .32
.31:
        mov byte [byte esi+051h], 7Fh
.32:
        xor eax, eax
        mov al, byte [byte esi+051h]
        mov ebx, edi
        mov edx, 2
        jmp short .28
.33:
        movsx edx, word [dword_F1888]
        mov eax, esi
        call SeqSendPitchBend
        jmp near .38
.34:
        cmp al, 80h
        jae short .35
        mov al, byte [byte esi+052h]
        mov byte [byte_F188D], al
.35:
        mov dl, byte [byte_F188C]
        and dl, 7Fh
        mov byte [byte_F188C], dl
        cmp byte [byte esi+050h], 9
        je short .36
        mov eax, dword [byte esi+06h]
        mov al, byte [byte eax+013h]
        mov bl, dl
        add bl, al
        mov byte [byte_F188C], bl
.36:
        cmp dword [MidiMusicEnabled], byte 0
        je short .38
        mov al, byte [byte esi+051h]
        mov byte [esp], al
        cmp byte [byte esi+050h], 9
        jne short .37
        mov al, byte [byte_F188C]
        add al, 5Ch
        and eax, 0FFh
        push eax
        call GetPatchEntry
        add esp, byte 4
        test eax, eax
        je short .37
        mov al, byte [byte eax+0Fh]
        and al, 7Fh
        mov byte [esp], al
.37:
        mov edx, dword [byte esi+02h]
        push edx
        xor eax, eax
        mov al, byte [esi]
        push eax
        xor eax, eax
        mov al, byte [byte esp+08h]
        push eax
        xor ecx, ecx
        mov cl, byte [byte esi+050h]
        mov ebx, dword [dword_F1888]
        xor edx, edx
        mov dl, byte [byte_F188D]
        xor eax, eax
        mov al, byte [byte_F188C]
        call SeqNoteOn
.38:
        mov ebx, dword [byte esi+0Ah]
        test ebx, ebx
        je near .12
        mov edx, ebx
        mov eax, dword_F1890
        call SeqReadEvent
        mov eax, dword [dword_F1890]
        mov dword [byte esi+0Eh], eax
        jmp near .12
.39:
        dec dword [byte esi+0Eh]
.40:
        mov ax, word [byte esi+04Ch]
        sub word [byte esi+04Ah], ax
        jmp near .7
.41:
        sub dword [MidiTickCount], byte 4
.42:
        add esp, byte 4
        jmp near SeqUpdate+017Eh
SeqSendController:
        push ecx
        push esi
        push edi
        push ebp
        mov ecx, eax
        mov esi, unk_F21FC
        mov edi, dword [MidiTickCount]
        add esi, edi
        lea ebp, [byte edi+04h]
        mov dword [MidiTickCount], ebp
        mov al, byte [byte eax+050h]
        or al, 0B0h
        mov byte [esi], al
        mov byte [byte esi+01h], dl
        cmp dl, 7
        jb near .4
        jbe short .1
        cmp dl, 0Ah
        je short .2
        jmp near .4
.1:
        xor edx, edx
        mov dl, byte [byte ecx+050h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        mov byte [dword eax+byte_F234D], bl
        mov eax, dword [byte ecx+06h]
        xor edx, edx
        mov dl, byte [byte eax+011h]
        xor eax, eax
        mov al, bl
        imul edx, eax
        mov ebx, 7Fh
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov bl, al
        cmp al, 7Fh
        jbe short .4
        mov bl, 7Fh
        jmp short .4
.2:
        xor edx, edx
        mov dl, byte [byte ecx+050h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        mov byte [dword eax+byte_F234E], bl
        mov eax, dword [byte ecx+06h]
        mov dl, byte [byte eax+012h]
        cmp dl, 3Fh
        jbe short .3
        mov al, dl
        and eax, 0FFh
        and ebx, 0FFh
        mov edx, 7Fh
        sub edx, ebx
        sub eax, byte 3Fh
        imul edx, eax
        mov edi, 3Fh
        mov eax, edx
        sar edx, 1Fh
        idiv edi
        add ebx, eax
        jmp short .4
.3:
        xor edx, edx
        mov dl, byte [byte eax+012h]
        mov eax, 3Fh
        sub eax, edx
        mov edx, eax
        and ebx, 0FFh
        imul edx, ebx
        mov edi, 3Fh
        mov eax, edx
        sar edx, 1Fh
        idiv edi
        sub ebx, eax
.4:
        mov byte [byte esi+02h], bl
        xor eax, eax
        mov al, byte [byte ecx+051h]
        mov ebx, esi
        mov edx, 3
        call SndHandleMidi
        sub dword [MidiTickCount], byte 4
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
SeqNoteOffSlot:
        push ebx
        push ecx
        push edx
        push esi
        mov ecx, eax
        mov ebx, unk_F21FC
        mov edx, dword [MidiTickCount]
        add ebx, edx
        lea esi, [byte edx+04h]
        mov dword [MidiTickCount], esi
        mov al, byte [byte eax+06h]
        or al, 80h
        mov byte [ebx], al
        mov al, byte [byte ecx+04h]
        mov byte [byte ebx+01h], al
        mov byte [byte ebx+02h], 0
        xor eax, eax
        mov al, byte [byte ecx+07h]
        mov edx, 3
        call SndHandleMidi
        mov dword [ecx], 0
        sub dword [MidiTickCount], byte 4
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
SeqChannelNotesOff:
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 4
        mov edi, eax
        mov byte [esp], dl
        mov ebx, byte_F1A1C
        xor ecx, ecx
        movzx esi, byte [esp]
        jmp short .3
.1:
        cmp edi, dword [byte ebx+02h]
        jne short .2
        mov eax, 7D00h
        mov edx, eax
        sar edx, 1Fh
        idiv esi
        mov word [byte ebx+04Ch], ax
.2:
        add ebx, byte 54h
        inc ecx
.3:
        cmp cx, byte 18h
        jl short .1
        xor eax, eax
        add esp, byte 4
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
SeqSendPitchBend:
        push ebx
        push ecx
        push esi
        mov ecx, edx
        mov ebx, unk_F21FC
        mov edx, dword [MidiTickCount]
        add ebx, edx
        lea esi, [byte edx+04h]
        mov dword [MidiTickCount], esi
        mov dl, byte [byte eax+050h]
        or dl, 0E0h
        mov byte [ebx], dl
        mov byte [byte ebx+01h], 0
        movsx edx, cx
        sar edx, 8
        and edx, byte 7Fh
        mov byte [byte ebx+02h], dl
        mov al, byte [byte eax+051h]
        and eax, 0FFh
        mov edx, 3
        call SndHandleMidi
        sub dword [MidiTickCount], byte 4
        pop esi
        pop ecx
        pop ebx
        ret
SeqNoteOn:
        push esi
        push edi
        sub esp, byte 8
        mov byte [esp], al
        mov byte [byte esp+04h], dl
        mov esi, ebx
        mov dl, cl
        mov ebx, unk_F21FC
        add ebx, dword [MidiTickCount]
        mov eax, dword_F189C
        xor ecx, ecx
        add dword [MidiTickCount], byte 4
.1:
        cmp dword [eax], byte 0
        jne short .5
        mov edi, dword [byte esp+01Ch]
        mov dword [eax], edi
        mov dh, byte [esp]
        mov byte [byte eax+04h], dh
        mov dh, byte [byte esp+018h]
        mov byte [byte eax+05h], dh
        mov byte [byte eax+06h], dl
        mov dh, byte [byte esp+014h]
        mov byte [byte eax+07h], dh
        test esi, esi
        jbe short .2
        mov dword [byte eax+08h], esi
        jmp short .3
.2:
        mov dword [byte eax+08h], 1
.3:
        or dl, 90h
        mov byte [ebx], dl
        mov al, byte [esp]
        mov byte [byte ebx+01h], al
        mov al, byte [byte esp+04h]
        mov byte [byte ebx+02h], al
        cmp byte [byte esp+018h], 0FFh
        je short .4
        xor eax, eax
        mov al, byte [byte esp+014h]
        mov edx, 3
        call SndHandleMidi
        jmp short .6
.4:
        xor eax, eax
        mov al, byte [byte esp+014h]
        mov edx, 3
        call SeqQueueCommand
        jmp short .6
.5:
        add eax, byte 0Ch
        inc ecx
        cmp ecx, byte 20h
        jl short .1
        mov ecx, 0FFFFFFFFh
.6:
        sub dword [MidiTickCount], byte 4
        mov eax, ecx
        add esp, byte 8
        pop edi
        pop esi
        ret 0Ch
SeqQueueCommand:
        push ecx
        push esi
        mov cl, al
        cmp byte [SeqQueueCount], 0
        jne short .3
        movsx eax, dx
        mov esi, dword [SeqQueueHead]
        add eax, esi
        cmp eax, 80h
        jge short .3
        mov byte [dword esi+byte_F1704], cl
        inc word [ActiveSongCount]
        inc byte [SeqQueueCount]
        lea eax, [byte esi+01h]
        mov dword [SeqQueueHead], eax
.1:
        test dx, dx
        je short .2
        mov esi, ebx
        mov eax, dword [SeqQueueHead]
        inc ebx
        lea ecx, [byte eax+01h]
        mov dword [SeqQueueHead], ecx
        mov cl, byte [esi]
        mov byte [dword eax+byte_F1704], cl
        dec edx
        jmp short .1
.2:
        dec byte [SeqQueueCount]
        dec word [ActiveSongCount]
.3:
        pop esi
        pop ecx
        ret
SeqFlushQueue:
        push ebx
        push ecx
        push edx
        push esi
        cmp dword [SeqQueueHead], byte 0
        je short .3
        mov ah, byte [SeqQueueCount]
        test ah, ah
        jne short .3
        xor ecx, ecx
        mov dl, ah
        inc dl
        mov byte [SeqQueueCount], dl
.1:
        mov esi, 3
        movsx eax, cx
        mov al, byte [dword eax+byte_F1705]
        and al, 0F0h
        cmp al, 0C0h
        jne short .2
        mov esi, 2
.2:
        movsx eax, cx
        lea ebx, [byte eax+01h]
        add ebx, byte_F1704
        xor edx, edx
        mov dx, si
        mov al, byte [dword eax+byte_F1704]
        and eax, 0FFh
        call SndHandleMidi
        inc esi
        add ecx, esi
        movsx eax, cx
        cmp eax, dword [SeqQueueHead]
        jl short .1
        xor ecx, ecx
        mov dword [SeqQueueHead], ecx
        dec byte [SeqQueueCount]
.3:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
SeqSendProgram:
        push ecx
        push esi
        mov ah, bl
        mov ebx, unk_F21FC
        mov ecx, dword [MidiTickCount]
        add ebx, ecx
        lea esi, [byte ecx+04h]
        mov dword [MidiTickCount], esi
        or dl, 0C0h
        mov byte [ebx], dl
        mov byte [byte ebx+01h], ah
        and eax, 0FFh
        mov edx, 2
        call SndHandleMidi
        sub dword [MidiTickCount], byte 4
        pop esi
        pop ecx
        ret
        db 08Bh,0C0h
jpt_998DD:
        dd SeqReadEvent+0AAh
        dd SeqReadEvent+0AAh
        dd SeqReadEvent+0AAh
        dd SeqReadEvent+080h
        dd SeqReadEvent+080h
        dd SeqReadEvent+080h
        dd SeqReadEvent+087h
        dd SeqReadEvent+080h
        dd SeqReadEvent+080h
        dd SeqReadEvent+080h
        dd SeqReadEvent+0AAh
        dd SeqReadEvent+080h
        dd SeqReadEvent+098h
        dd SeqReadEvent+06Ch
        dd SeqReadEvent+063h
        dd SeqReadEvent+04Dh
        dd SeqReadEvent+080h
        dd SeqReadEvent+080h
SeqReadEvent:
        push ebx
        push ecx
        push esi
        sub esp, byte 4
        mov ebx, eax
        mov dword [esp], edx
        mov dword [eax], 0
.1:
        mov al, byte [edx]
        and al, 7Fh
        and eax, 0FFh
        mov esi, dword [ebx]
        shl esi, 7
        add esi, eax
        mov dword [ebx], esi
        mov eax, edx
        inc edx
        test byte [eax], 80h
        jne short .1
        mov al, byte [edx]
        mov byte [byte ebx+08h], al
        mov ch, al
        inc edx
        sub al, 0D9h
        cmp al, 11h
        ja near SeqReadEvent+0AAh
        and eax, 0FFh
        lea esi, [byte edx+01h]
        jmp dword [nosplit cs:eax*4+jpt_998DD]
        xor eax, eax
        jmp short .3
.2:
        mov cl, byte [byte edx+eax+01h]
        mov byte [dword eax+byte_F1784], cl
        inc eax
.3:
        movzx esi, byte [edx]
        cmp eax, esi
        jl short .2
        xor eax, eax
        mov al, byte [edx]
        add edx, eax
.4:
        inc edx
        jmp short SeqReadEvent+0AAh
        mov al, byte [edx]
        mov byte [byte ebx+09h], al
        mov eax, esi
        call PeekDword
        mov dword [byte ebx+04h], eax
        lea edx, [byte esi+04h]
        jmp short SeqReadEvent+0AAh
        mov al, byte [edx]
        mov byte [byte ebx+09h], al
        jmp short .4
        mov al, byte [edx]
        mov byte [byte ebx+09h], al
        xor eax, eax
        mov al, byte [esi]
        mov dword [byte ebx+04h], eax
        lea edx, [byte esi+01h]
        jmp short SeqReadEvent+0AAh
        mov eax, edx
        call PeekWord
        and eax, 0FFFFh
        mov dword [byte ebx+04h], eax
        add edx, byte 2
        cmp ch, 0D9h
        jae short .6
        mov al, byte [edx]
        mov byte [byte ebx+09h], al
        mov dword [byte ebx+04h], 0
        inc edx
.5:
        mov eax, dword [byte ebx+04h]
        shl eax, 7
        mov cl, byte [edx]
        and cl, 7Fh
        movzx esi, cl
        add eax, esi
        mov dword [byte ebx+04h], eax
        mov eax, edx
        inc edx
        test byte [eax], 80h
        jne short .5
.6:
        mov al, byte [esp]
        sub dl, al
        mov byte [byte ebx+0Ah], dl
        add esp, byte 4
        pop esi
        pop ecx
        pop ebx
        ret
PeekDword:
        mov eax, dword [eax]
        ret
PeekWord:
        mov ax, word [eax]
        ret
