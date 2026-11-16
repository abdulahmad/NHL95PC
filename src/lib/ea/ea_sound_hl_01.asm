; The high-level sound library. Starting a driver and playing a sample.
bits 32
%include "hockey.inc"
section s_8EB5B progbits alloc exec nowrite align=1
extern __GETDS, _makepath_, _splitpath_, addtimer, str_SCN, str_03sFF03dPAT, str_03sFF03dTIM, str_KMS2
extern str_CFG2, str_VHDR, byte_D41CC, byte_D41CD, byte_F1A1C, byte_F1A1D, byte_F1D61, byte_F234D
extern byte_F23BC, byte_F23CC, byte_F23CD, byte_F23CF, byte_F23E0, SndHandleType, dword_D41CE, dword_D41EA
extern sndhandlecount, dword_D4F8A, dword_D4F8E, dword_D4F92, SndTimerHandle, dword_D4F9A, dword_EDCFC, dword_EDD00
extern dword_EDD04, dword_EDE34, dword_EDE5C, dword_F189C, dword_F18A4, dword_F1A1E, dword_F22FC, dword_F2300
extern dword_F2304, dword_F2308, dword_F230C, dword_F23EA, dword_F23EE, dword_F2416, FreeMemBlock, RemoveTimerCallback
extern SndLoadFile, SndLoadFile2, sprintf_, strlen_, sub_8D144, PushMemDescriptorLocked, MemDescPtr, MemDescSize
extern SndDriverHandle, SndHandleClose, SndDriverCall, SndHandleSetTrack, SndHandlePlayDigi, sub_98F11, sub_98F46, sub_99522
extern sub_99620, sub_996B0, sub_99700, sub_997B7, sub_998A0, AddExitHandler, bcopy, FillMem
extern unk_C3FD5, unk_D41D2, unk_F21FC, word_D4F68, word_D4F88
global SndInit, loc_8EB8D, SndShutdown, loc_8EBAB, loc_8EBB4, loc_8EBBB, SndClearTables, loc_8EBEB
global loc_8EC08, loc_8EC12, loc_8EC26, loc_8EC30, loc_8EC3D, loc_8EC47, loc_8EC53, loc_8EC5D
global loc_8EC7F, loc_8EC89, loc_8EC9D, LoadMusicBank, loc_8ECDE, loc_8ED0A, loc_8ED6F, loc_8ED73
global loc_8EDB8, loc_8EDB9, loc_8EDCB, FreeMusicBank, loc_8EDE2, loc_8EE06, loc_8EE2B, LoadPatchFile
global FreeSoundBlock, LoadTimbreFile, loc_8EE8B, loc_8EE90, loc_8EED5, loc_8EEF5, loc_8EEFF, loc_8EF2F
global loc_8EF36, loc_8EF43, loc_8EF47, loc_8EF4A, AddTimbreBank, loc_8EF56, loc_8EF6D, FreeTimbreFile
global RemoveTimbreBank, loc_8EF98, loc_8EFB1, LinkPatchTimbres, loc_8EFDB, loc_8F008, loc_8F011, loc_8F01B
global loc_8F01C, loc_8F029, loc_8F02B, loc_8F05C, loc_8F074, loc_8F095, loc_8F0A5, loc_8F0AB
global loc_8F0B5, loc_8F0CF, GetPatchEntry, loc_8F0E7, loc_8F0EB, GetPatchTimbre, loc_8F127, LoadSample
global loc_8F151, loc_8F158, loc_8F19C, loc_8F1F2, loc_8F1F4, loc_8F1F7, loc_8F1F8, FreeSample
global loc_8F244, FindSongSlot, loc_8F24D, loc_8F262, PlaySong, StartSongTracks, loc_8F2D7, loc_8F2F8
global loc_8F38D, loc_8F3F3, loc_8F413, loc_8F420, loc_8F42B, FindFreeTrack, loc_8F43D, loc_8F447
global loc_8F44F, FindFreeMidiChannel, loc_8F45B, loc_8F47E, loc_8F47F, loc_8F48A, LoadAndPlaySong, loc_8F4A0
global StartSong, loc_8F4BD, PlayPatch, loc_8F4D7, loc_8F4E1, loc_8F4F1, loc_8F526, loc_8F52B
global loc_8F592, loc_8F609, loc_8F616, PlayPatchFull, ReleaseAllVoices, loc_8F64F, loc_8F66B, loc_8F66C
global loc_8F679, StopSongId, loc_8F694, loc_8F6B2, loc_8F6CD, loc_8F6D4, loc_8F6E2, loc_8F6ED
global loc_8F6F1, loc_8F70D, loc_8F767, loc_8F76B, loc_8F7A2, ReleaseSong, loc_8F7C6, loc_8F7F6
global loc_8F7FA, SongFinished, loc_8F824, loc_8F834, loc_8F838, loc_8F83E, SongReleased, loc_8F85C
global loc_8F86C, loc_8F870, loc_8F876, loc_8F88D, loc_8F8A5, loc_8F8A9, loc_8F8E6, loc_8F909
global loc_8F90A, loc_8F929, loc_8F94F, loc_8F950, EnableMidiSfx, DisableMidiSfx, EnableMidiMusic, DisableMidiMusic
global LoadDigiFile, loc_8F9F6, loc_8FA46, loc_8FA83, loc_8FAD8, loc_8FAE0, loc_8FAE6, loc_8FAEA
global FindSubstring, loc_8FB08, loc_8FB16, loc_8FB18, loc_8FB1C, PlayDigiBlock, loc_8FB72, loc_8FB87
global PlayDigiBlockLoop, PlayDigiPtr, loc_8FC2E, loc_8FC31, PlayDigiPtrLoop, SndQuery, loc_8FC96, loc_8FC9C
global StopDigiChannel, loc_8FCDC, SetDigiChannelVolume, loc_8FCF8, loc_8FD5F, QueryDigiChannel, loc_8FD82, MidiProgramChange
global loc_8FDAE, MidiSetVolume, loc_8FDE1, MidiPitchBend, loc_8FE18, MidiNoteOn, loc_8FE4B, MidiNoteOff
global loc_8FE7F, SetSoundByteOrder, FindSoundChunk, loc_8FEAD, loc_8FEBE, loc_8FEC2, ReplaceFileExt, FreeMemPtr
global loc_8FF39, ReleaseMemPtr, loc_8FF59, SwapBytes16, SwapBytes32, SetPalette, loc_8FFCB
SndInit:
        push ebx
        push ecx
        push edx
        call SndShutdown
        push sub_98F11
        call addtimer
        add esp, byte 4
        cmp byte [byte_D41CC], 0
        jne short loc_8EB8D
        push SndShutdown
        call AddExitHandler
        add esp, byte 4
        mov byte [byte_D41CC], 1
loc_8EB8D:
        xor eax, eax
        pop edx
        pop ecx
        pop ebx
        ret
SndShutdown:
        push ebx
        push ecx
        push edx
        push sub_98F11
        call RemoveTimerCallback
        add esp, byte 4
        mov edx, dword [sndhandlecount]
        jmp short loc_8EBB4
loc_8EBAB:
        xor eax, eax
        mov al, dl
        call SndHandleClose
loc_8EBB4:
        dec edx
        test edx, edx
        jge short loc_8EBAB
        xor edx, edx
loc_8EBBB:
        mov eax, edx
        shl eax, 2
        sub eax, edx
        mov eax, dword [nosplit eax*8+dword_EDCFC]
        call FreeSample
        inc edx
        cmp edx, byte 0Dh
        jl short loc_8EBBB
        call FreeMusicBank
        call SndClearTables
        pop edx
        pop ecx
        pop ebx
        ret
SndClearTables:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        xor eax, eax
        jmp short loc_8EC08
loc_8EBEB:
        movsx edx, ax
        imul edx, byte 54h
        mov byte [dword edx+byte_F1A1C], al
        xor bl, bl
        mov byte [dword edx+byte_F1A1D], bl
        xor ebx, ebx
        mov dword [dword edx+dword_F1A1E], ebx
        inc eax
loc_8EC08:
        cmp ax, 18h
        jl short loc_8EBEB
        xor eax, eax
        jmp short loc_8EC26
loc_8EC12:
        movsx ebx, ax
        mov edx, ebx
        shl edx, 2
        sub edx, ebx
        xor ecx, ecx
        mov dword [nosplit edx*4+dword_F189C], ecx
        inc eax
loc_8EC26:
        cmp ax, 20h
        jl short loc_8EC12
        xor eax, eax
        jmp short loc_8EC3D
loc_8EC30:
        movsx edx, ax
        xor esi, esi
        mov dword [nosplit edx*4+dword_EDE34], esi
        inc eax
loc_8EC3D:
        cmp ax, 0Ah
        jl short loc_8EC30
        xor eax, eax
        jmp short loc_8EC53
loc_8EC47:
        movsx edx, ax
        xor bh, bh
        mov byte [dword edx+byte_F23BC], bh
        inc eax
loc_8EC53:
        cmp ax, 10h
        jl short loc_8EC47
        xor eax, eax
        jmp short loc_8EC7F
loc_8EC5D:
        movsx ebx, ax
        mov edx, ebx
        shl edx, 2
        sub edx, ebx
        xor edi, edi
        mov dword [nosplit edx*8+dword_EDCFC], edi
        mov dword [nosplit edx*8+dword_EDD00], edi
        mov dword [nosplit edx*8+dword_EDD04], edi
        inc eax
loc_8EC7F:
        cmp ax, 0Dh
        jl short loc_8EC5D
        xor eax, eax
        jmp short loc_8EC9D
loc_8EC89:
        movsx ebx, ax
        mov edx, ebx
        shl edx, 2
        add edx, ebx
        xor ecx, ecx
        mov dword [nosplit edx*4+dword_F22FC], ecx
        inc eax
loc_8EC9D:
        cmp ax, 4
        jl short loc_8EC89
        xor esi, esi
        mov dword [dword_EDE5C], esi
        mov dword [sndhandlecount], esi
        mov dword [SndTimerHandle], 0FFFFFFFFh
        jmp near loc_8F1F8
LoadMusicBank:
        push ebx
        push ecx
        push esi
        sub esp, byte 14h
        mov ecx, eax
        mov esi, edx
        call FreeMusicBank
        cmp byte [ecx], 0
        jne short loc_8ECDE
        mov eax, 0FFFFFFFBh
        jmp near loc_8EDCB
loc_8ECDE:
        mov ebx, esp
        mov edx, str_SCN
        mov eax, ecx
        call ReplaceFileExt
        mov edx, esp
        mov eax, 1
        call SndLoadFile2
        mov dword [byte esp+010h], eax
        test eax, eax
        jne short loc_8ED0A
        mov eax, 0FFFFFFFFh
        jmp near loc_8EDCB
loc_8ED0A:
        push eax
        call MemDescSize
        add esp, byte 4
        push eax
        push byte_F23CC
        mov edx, dword [byte esp+018h]
        push edx
        call MemDescPtr
        add esp, byte 4
        push eax
        call bcopy
        add esp, byte 0Ch
        lea eax, [byte esp+010h]
        call ReleaseMemPtr
        xor eax, eax
        mov al, byte [byte_F23CD]
        push eax
        push esi
        push str_03sFF03dPAT
        lea eax, [byte esp+0Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        mov eax, esp
        call LoadPatchFile
        mov dword [dword_F23EA], eax
        test eax, eax
        jne short loc_8ED6F
        call FreeMusicBank
        mov eax, 0FFFFFFFEh
        jmp short loc_8EDCB
loc_8ED6F:
        xor ebx, ebx
        jmp short loc_8EDB9
loc_8ED73:
        xor eax, eax
        mov al, byte [dword ebx+byte_F23E0]
        push eax
        push esi
        push str_03sFF03dTIM
        lea eax, [byte esp+0Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        mov ecx, ebx
        shl ecx, 2
        mov edx, dword_F2416
        add edx, ecx
        mov eax, esp
        call LoadTimbreFile
        mov dword [dword ecx+dword_F23EE], eax
        test eax, eax
        jne short loc_8EDB8
        call FreeMusicBank
        mov eax, 0FFFFFFFDh
        jmp short loc_8EDCB
loc_8EDB8:
        inc ebx
loc_8EDB9:
        xor eax, eax
        mov al, byte [byte_F23CF]
        cmp ebx, eax
        jl short loc_8ED73
        call LinkPatchTimbres
        xor eax, eax
loc_8EDCB:
        add esp, byte 14h
        pop esi
        pop ecx
        pop ebx
        ret
FreeMusicBank:
        push ecx
        push edx
        push esi
        cmp byte [byte_F23CC], 4
        jne short loc_8EE2B
        xor ecx, ecx
        jmp short loc_8EE06
loc_8EDE2:
        mov edx, dword [nosplit ecx*4+dword_F2416]
        mov eax, dword [nosplit ecx*4+dword_F23EE]
        call FreeTimbreFile
        xor esi, esi
        mov dword [nosplit ecx*4+dword_F23EE], esi
        mov dword [nosplit ecx*4+dword_F2416], esi
        inc ecx
loc_8EE06:
        xor eax, eax
        mov al, byte [byte_F23CF]
        cmp ecx, eax
        jl short loc_8EDE2
        mov eax, dword [dword_F23EA]
        call FreeSoundBlock
        xor edx, edx
        mov dword [dword_F23EA], edx
        xor dl, dl
        mov byte [byte_F23CC], dl
loc_8EE2B:
        pop esi
        pop edx
        pop ecx
        ret
LoadPatchFile:
        push edx
        mov edx, eax
        mov eax, 2
        call SndLoadFile
        mov dword [dword_EDE5C], eax
        pop edx
        ret
FreeSoundBlock:
        push eax
        mov eax, esp
        call FreeMemPtr
        add esp, byte 4
        ret
LoadTimbreFile:
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 0Ch
        push edx
        mov dword [edx], 0
        mov edx, eax
        mov eax, 3
        call SndLoadFile
        mov dword [byte esp+04h], eax
        test eax, eax
        je near loc_8EF47
        call AddTimbreBank
        cmp byte [byte_D41CD], 0
        je short loc_8EE8B
        mov edx, 6769642Eh
        jmp short loc_8EE90
loc_8EE8B:
        mov edx, 2E646967h
loc_8EE90:
        mov eax, dword [byte esp+04h]
        call FindSoundChunk
        test eax, eax
        je near loc_8EF43
        mov edx, eax
        mov eax, 4
        call SndLoadFile2
        mov edx, dword [esp]
        mov dword [edx], eax
        test eax, eax
        je near loc_8EF43
        mov eax, dword [byte esp+04h]
        mov ax, word [byte eax+04h]
        mov dword [byte esp+0Ch], eax
        mov edi, dword [byte esp+04h]
        add edi, byte 6
        xor ebx, ebx
        mov dword [byte esp+08h], ebx
        jmp short loc_8EF36
loc_8EED5:
        mov edx, dword [edi]
        mov eax, dword [byte esp+04h]
        call FindSoundChunk
        mov esi, eax
        cmp byte [eax], 6
        jne short loc_8EF2F
        cmp byte [byte_D41CD], 0
        je short loc_8EEF5
        mov ebp, dword [byte eax+02h]
        jmp short loc_8EEFF
loc_8EEF5:
        mov eax, dword [byte eax+02h]
        call SwapBytes32
        mov ebp, eax
loc_8EEFF:
        mov eax, dword [esp]
        mov edx, dword [eax]
        push edx
        call MemDescPtr
        add esp, byte 4
        mov edx, ebp
        call FindSoundChunk
        test eax, eax
        je short loc_8EF2F
        mov word [byte esi+0Ah], 0
        mov dword [byte esi+0Ch], eax
        mov byte [byte esi+010h], 0
        mov byte [byte esi+011h], 0
        mov word [byte esi+012h], 2B11h
loc_8EF2F:
        add edi, byte 4
        inc dword [byte esp+08h]
loc_8EF36:
        xor eax, eax
        mov ax, word [byte esp+0Ch]
        cmp eax, dword [byte esp+08h]
        jg short loc_8EED5
loc_8EF43:
        mov eax, dword [byte esp+04h]
loc_8EF47:
        add esp, byte 10h
loc_8EF4A:
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
AddTimbreBank:
        push ebx
        push edx
        mov ebx, eax
        xor eax, eax
loc_8EF56:
        mov edx, eax
        shl edx, 2
        cmp dword [dword edx+dword_EDE34], byte 0
        jne short loc_8EF6D
        mov dword [dword edx+dword_EDE34], ebx
        pop edx
        pop ebx
        ret
loc_8EF6D:
        inc eax
        cmp eax, byte 0Ah
        jl short loc_8EF56
        pop edx
        pop ebx
        ret
FreeTimbreFile:
        push eax
        push edx
        call RemoveTimbreBank
        lea eax, [byte esp+04h]
        call FreeMemPtr
        mov eax, esp
        call ReleaseMemPtr
        add esp, byte 8
        ret
RemoveTimbreBank:
        push ebx
        push edx
        push esi
        mov ebx, eax
        xor eax, eax
loc_8EF98:
        mov edx, eax
        shl edx, 2
        cmp ebx, dword [dword edx+dword_EDE34]
        jne short loc_8EFB1
        xor esi, esi
        mov dword [dword edx+dword_EDE34], esi
        pop esi
        pop edx
        pop ebx
        ret
loc_8EFB1:
        inc eax
        cmp eax, byte 0Ah
        jl short loc_8EF98
        pop esi
        pop edx
        pop ebx
        ret
LinkPatchTimbres:
        push ebx
        push ecx
        push edx
        push ebp
        sub esp, byte 8
        cmp dword [dword_EDE5C], byte 0
        je near loc_8F0CF
        xor ebx, ebx
        mov dword [esp], ebx
        inc word [word_D4F88]
loc_8EFDB:
        xor eax, eax
        mov al, byte [esp]
        push eax
        call GetPatchEntry
        add esp, byte 4
        mov ebx, eax
        test eax, eax
        je near loc_8F0B5
        mov dl, byte [byte eax+0Fh]
        test dl, 80h
        jne near loc_8F0B5
        cmp dl, 3
        jne short loc_8F029
        xor eax, eax
        jmp short loc_8F01C
loc_8F008:
        cmp byte [dword eax+SndHandleType], 3
        jne short loc_8F01B
loc_8F011:
        or al, 80h
        mov byte [byte ebx+0Fh], al
        jmp near loc_8F0B5
loc_8F01B:
        inc eax
loc_8F01C:
        cmp eax, dword [sndhandlecount]
        jl short loc_8F008
        jmp near loc_8F0B5
loc_8F029:
        xor ecx, ecx
loc_8F02B:
        cmp dword [nosplit ecx*4+dword_EDE34], byte 0
        je near loc_8F0AB
        cmp byte [byte_D41CD], 0
        je short loc_8F05C
        mov byte [byte esp+04h], 80h
        mov al, byte [ebx]
        mov byte [byte esp+05h], al
        xor al, al
        mov byte [byte esp+06h], al
        mov al, byte [byte ebx+01h]
        mov byte [byte esp+07h], al
        jmp short loc_8F074
loc_8F05C:
        mov byte [byte esp+07h], 80h
        mov al, byte [ebx]
        mov byte [byte esp+06h], al
        xor dl, dl
        mov byte [byte esp+05h], dl
        mov al, byte [byte ebx+01h]
        mov byte [byte esp+04h], al
loc_8F074:
        mov eax, dword [nosplit ecx*4+dword_EDE34]
        mov edx, dword [byte esp+04h]
        call FindSoundChunk
        mov dword [byte ebx+010h], eax
        test eax, eax
        je short loc_8F0AB
        xor eax, eax
        mov ebp, dword [sndhandlecount]
        jmp short loc_8F0A5
loc_8F095:
        mov cl, byte [byte ebx+0Fh]
        cmp cl, byte [dword eax+SndHandleType]
        je near loc_8F011
        inc eax
loc_8F0A5:
        cmp eax, ebp
        jl short loc_8F095
        jmp short loc_8F0B5
loc_8F0AB:
        inc ecx
        cmp ecx, byte 0Ah
        jl near loc_8F02B
loc_8F0B5:
        mov ebx, dword [esp]
        inc ebx
        mov dword [esp], ebx
        cmp ebx, 100h
        jl near loc_8EFDB
        dec word [word_D4F88]
loc_8F0CF:
        add esp, byte 8
        pop ebp
        pop edx
        pop ecx
        pop ebx
        ret
GetPatchEntry:
        push ds
        call __GETDS
        mov edx, dword [dword_EDE5C]
        test edx, edx
        jne short loc_8F0EB
loc_8F0E7:
        xor eax, eax
        pop ds
        ret
loc_8F0EB:
        mov ebx, edx
        xor eax, eax
        mov al, byte [byte esp+08h]
        add eax, edx
        cmp byte [byte eax+02h], 0
        je short loc_8F0E7
        xor edx, edx
        mov dl, byte [byte eax+02h]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        add ebx, 102h
        add eax, ebx
        pop ds
        ret
GetPatchTimbre:
        push ds
        call __GETDS
        cmp dword [dword_EDE5C], byte 0
        jne short loc_8F127
        xor eax, eax
        pop ds
        ret
loc_8F127:
        xor eax, eax
        mov al, byte [byte esp+08h]
        push eax
        call GetPatchEntry
        add esp, byte 4
        mov eax, dword [byte eax+010h]
        pop ds
        ret
LoadSample:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        mov ebp, eax
        xor eax, eax
        call FindSongSlot
        test eax, eax
        jge short loc_8F158
loc_8F151:
        xor eax, eax
        jmp near loc_8F1F4
loc_8F158:
        mov ecx, eax
        shl ecx, 2
        sub ecx, eax
        mov eax, ecx
        shl eax, 3
        mov ecx, 6
        lea edi, [dword eax+dword_EDCFC]
        mov esi, unk_D41D2
        rep movsd
        mov ecx, dword_EDCFC
        add ecx, eax
        mov edx, dword [dword_D41CE]
        inc edx
        mov dword [dword_D41CE], edx
        cmp edx, 200h
        ja short loc_8F19C
        mov dword [dword_D41CE], 200h
loc_8F19C:
        mov eax, dword [dword_D41CE]
        mov dword [ecx], eax
        mov ebx, esp
        mov edx, str_KMS2
        mov eax, ebp
        call ReplaceFileExt
        mov edx, esp
        mov eax, 5
        call SndLoadFile
        mov dword [byte ecx+04h], eax
        test eax, eax
        je short loc_8F1F4
        mov ebx, esp
        mov edx, str_CFG2
        mov eax, ebp
        call ReplaceFileExt
        mov edx, esp
        mov eax, 6
        call SndLoadFile
        mov dword [byte ecx+08h], eax
        test eax, eax
        jne short loc_8F1F2
        lea eax, [byte ecx+04h]
        call FreeMemPtr
        jmp near loc_8F151
loc_8F1F2:
        mov eax, dword [ecx]
loc_8F1F4:
        add esp, byte 10h
loc_8F1F7:
        pop ebp
loc_8F1F8:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
FreeSample:
        push ebx
        push edx
        mov edx, eax
        cmp eax, 200h
        jb short loc_8F244
        call StopSongId
        mov eax, edx
        call FindSongSlot
        test eax, eax
        jl short loc_8F244
        mov edx, eax
        shl eax, 2
        sub eax, edx
        mov edx, eax
        shl edx, 3
        mov ebx, dword_EDCFC
        add ebx, edx
        lea eax, [byte ebx+04h]
        call FreeMemPtr
        lea eax, [byte ebx+08h]
        call FreeMemPtr
        xor ebx, ebx
        mov dword [dword edx+dword_EDCFC], ebx
loc_8F244:
        pop edx
        pop ebx
        ret
FindSongSlot:
        push ecx
        push edx
        mov ecx, eax
        xor edx, edx
loc_8F24D:
        mov eax, edx
        shl eax, 2
        sub eax, edx
        cmp ecx, dword [nosplit eax*8+dword_EDCFC]
        jne short loc_8F262
        mov eax, edx
        pop edx
        pop ecx
        ret
loc_8F262:
        inc edx
        cmp edx, byte 0Dh
        jl short loc_8F24D
        mov eax, 0FFFFFFFFh
        pop edx
        pop ecx
        ret
PlaySong:
        push ebx
        xor ebx, ebx
        call StartSong
        pop ebx
        ret
StartSongTracks:
        mov ebx, eax
        shl eax, 2
        sub eax, ebx
        shl eax, 3
        mov ebx, dword_EDCFC
        add ebx, eax
        mov dword [byte esp+010h], ebx
        mov eax, edx
        call SndDriverHandle
        mov dword [byte esp+018h], eax
        test eax, eax
        jl near loc_8F4BD
        mov eax, dword [byte ebx+04h]
        mov dword [byte esp+08h], eax
        mov dword [byte esp+0Ch], eax
        mov eax, dword [byte ebx+08h]
        mov dword [byte esp+014h], eax
        mov eax, dword [byte esp+08h]
        mov al, byte [byte eax+01h]
        mov byte [byte esp+024h], al
        mov eax, dword [byte esp+08h]
        mov al, byte [byte eax+06h]
        mov byte [byte esp+020h], al
        xor ah, ah
        mov byte [byte esp+028h], ah
        inc word [word_D4F88]
loc_8F2D7:
        cmp byte [byte esp+020h], 0
        je near loc_8F420
        call FindFreeTrack
        mov esi, eax
        mov edi, eax
        test eax, eax
        jne short loc_8F2F8
        mov dword [byte esp+04h], eax
        jmp near loc_8F420
loc_8F2F8:
        mov al, byte [eax]
        mov byte [byte esp+01Ch], al
        push byte 0
        push byte 54h
        push esi
        call FillMem
        add esp, byte 0Ch
        mov al, byte [byte esp+01Ch]
        mov byte [esi], al
        mov eax, dword [byte esp+04h]
        mov dword [byte esi+02h], eax
        mov eax, dword [byte esp+010h]
        mov dword [byte esi+06h], eax
        xor ebx, ebx
        mov bl, byte [byte esp+028h]
        lea eax, [ebx+ebx]
        add eax, dword [byte esp+08h]
        mov ax, word [byte eax+08h]
        and eax, 0FFFFh
        mov edx, dword [byte esp+0Ch]
        add edx, eax
        mov dword [byte esi+0Ah], edx
        mov dword [byte esi+032h], edx
        xor ecx, ecx
        mov cl, byte [byte esp+024h]
        mov eax, 7D00h
        mov edx, eax
        sar edx, 1Fh
        idiv ecx
        mov word [byte esi+04Ch], ax
        mov ecx, dword [byte esp+014h]
        test ecx, ecx
        je near loc_8F3F3
        shl ebx, 4
        add ecx, byte 8
        add ecx, ebx
        xor eax, eax
        mov ax, word [ecx]
        call FindFreeMidiChannel
        mov byte [byte esi+050h], al
        xor eax, eax
        mov al, byte [byte esi+050h]
        cmp eax, byte 0FFFFFFFFh
        jne short loc_8F38D
        xor edi, esi
        mov dword [byte esp+04h], edi
        jmp near loc_8F420
loc_8F38D:
        mov al, byte [byte esp+018h]
        mov byte [byte esi+051h], al
        mov ebx, dword [byte ecx+02h]
        xor edx, edx
        mov dl, byte [byte esi+050h]
        movzx ebp, al
        mov eax, ebp
        call SndHandleSetTrack
        xor ebx, ebx
        mov bl, byte [byte ecx+0Ch]
        xor edx, edx
        mov dl, byte [byte esi+050h]
        mov eax, ebp
        call sub_998A0
        xor ebx, ebx
        mov edx, 1
        mov eax, esi
        call sub_99522
        xor ebx, ebx
        mov bl, byte [byte ecx+06h]
        mov edx, 7
        mov eax, esi
        call sub_99522
        xor ebx, ebx
        mov bl, byte [byte ecx+07h]
        mov edx, 0Ah
        mov eax, esi
        call sub_99522
        mov edx, 4000h
        mov eax, esi
        call sub_996B0
loc_8F3F3:
        mov byte [byte edi+01h], 1
        cmp dword [esp], byte 0
        jle short loc_8F413
        or byte [byte edi+01h], 8
        mov edx, dword [byte edi+06h]
        mov word [byte edx+0Eh], 0FFFFh
        mov ecx, dword [byte edi+06h]
        mov al, byte [byte ecx+011h]
        mov byte [byte ecx+010h], al
loc_8F413:
        dec byte [byte esp+020h]
        inc byte [byte esp+028h]
        jmp near loc_8F2D7
loc_8F420:
        mov eax, dword [byte esp+04h]
        dec word [word_D4F88]
loc_8F42B:
        add esp, byte 2Ch
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
FindFreeTrack:
        push edx
        mov eax, byte_F1A1C
        xor edx, edx
        jmp short loc_8F447
loc_8F43D:
        cmp byte [byte eax+01h], 0
        je short loc_8F44F
        add eax, byte 54h
        inc edx
loc_8F447:
        cmp dx, byte 18h
        jl short loc_8F43D
        xor eax, eax
loc_8F44F:
        pop edx
        ret
FindFreeMidiChannel:
        push ebx
        push ecx
        push edx
        push esi
        mov esi, eax
        xor eax, eax
        jmp short loc_8F47F
loc_8F45B:
        movsx edx, ax
        mov bx, word [nosplit edx*2+word_D4F68]
        and ebx, 0FFFFh
        xor ecx, ecx
        mov cx, si
        test ecx, ebx
        je short loc_8F47E
        cmp byte [dword edx+byte_F23BC], 0
        je short loc_8F48A
loc_8F47E:
        inc eax
loc_8F47F:
        cmp ax, 10h
        jl short loc_8F45B
        mov eax, 0FFFFFFFFh
loc_8F48A:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
LoadAndPlaySong:
        push ebx
        call LoadSample
        test eax, eax
        je short loc_8F4A0
        xor ebx, ebx
        call StartSong
loc_8F4A0:
        pop ebx
        ret
        call LoadSample
StartSong:
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 24h
        push eax
        push ebx
        call FindSongSlot
        test eax, eax
        jge near StartSongTracks
loc_8F4BD:
        xor eax, eax
        jmp near loc_8F42B
PlayPatch:
        push ecx
        push esi
        push edi
        sub esp, byte 8
        push eax
        mov esi, edx
        mov byte [byte esp+08h], bl
        cmp ax, 100h
        jb short loc_8F4E1
loc_8F4D7:
        mov eax, 0FFFFFFFFh
        jmp near loc_8F616
loc_8F4E1:
        cmp dword [dword_D4F8E], byte 0
        jne short loc_8F4F1
        xor eax, eax
        jmp near loc_8F616
loc_8F4F1:
        xor eax, eax
        mov al, byte [esp]
        push eax
        call GetPatchEntry
        add esp, byte 4
        test eax, eax
        je short loc_8F4D7
        mov dl, byte [byte eax+0Fh]
        and dl, 7Fh
        test esi, esi
        jne short loc_8F52B
        mov dh, byte [byte eax+0Eh]
        test dh, dh
        je short loc_8F526
        mov al, dh
        and eax, 0FFh
        mov esi, eax
        shl esi, 2
        sub esi, eax
        add esi, esi
        jmp short loc_8F52B
loc_8F526:
        mov esi, 0A0h
loc_8F52B:
        mov ecx, unk_F21FC
        mov ebx, dword [dword_D4F9A]
        add ecx, ebx
        lea edi, [byte ebx+04h]
        mov dword [dword_D4F9A], edi
        mov ebx, dword [esp]
        cmp bx, 80h
        jb short loc_8F592
        mov byte [ecx], 0B9h
        mov byte [byte ecx+01h], 7
        mov al, byte [byte esp+08h]
        mov byte [byte ecx+02h], al
        movzx edi, dl
        mov eax, ebx
        sub eax, byte 74h
        mov word [esp], ax
        mov ebx, ecx
        mov edx, 3
        mov eax, edi
        call sub_997B7
        push dword 0FFh
        push dword 0FFh
        push edi
        xor eax, eax
        mov al, byte [byte esp+0Ch]
        mov ecx, 9
        mov ebx, esi
        mov edx, 7Fh
        jmp short loc_8F609
loc_8F592:
        mov eax, dword [dword_D41EA]
        add eax, byte 0Ch
        mov dword [byte esp+04h], eax
        mov eax, dword [dword_D41EA]
        inc eax
        and eax, byte 3
        mov dword [dword_D41EA], eax
        mov al, byte [byte esp+04h]
        or al, 0C0h
        mov byte [ecx], al
        mov al, byte [esp]
        mov byte [byte ecx+01h], al
        movzx edi, dl
        mov ebx, ecx
        mov edx, 2
        mov eax, edi
        call sub_997B7
        mov al, byte [byte esp+04h]
        or al, 0B0h
        mov byte [ecx], al
        mov byte [byte ecx+01h], 7
        mov al, byte [byte esp+08h]
        mov byte [byte ecx+02h], al
        mov ebx, ecx
        mov edx, 3
        mov eax, edi
        call sub_997B7
        push dword 0FFh
        push dword 0FFh
        push edi
        xor ecx, ecx
        mov cl, byte [byte esp+010h]
        mov ebx, esi
        mov edx, 7Fh
        mov eax, 24h
loc_8F609:
        call sub_99700
        cwde
        sub dword [dword_D4F9A], byte 4
loc_8F616:
        add esp, byte 0Ch
        pop edi
        pop esi
        pop ecx
        ret
PlayPatchFull:
        push ebx
        push edx
        and eax, 0FFFFh
        mov ebx, 7Fh
        xor edx, edx
        call PlayPatch
        pop edx
        pop ebx
        ret
ReleaseAllVoices:
        push ebx
        push ecx
        push edx
        cmp dword [dword_D4F8E], byte 0
        je short loc_8F679
        xor edx, edx
        inc word [word_D4F88]
        mov ecx, 1
        jmp short loc_8F66C
loc_8F64F:
        movsx ebx, dx
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 2
        cmp dword [dword eax+dword_F189C], byte 0
        je short loc_8F66B
        mov dword [dword eax+dword_F18A4], ecx
loc_8F66B:
        inc edx
loc_8F66C:
        cmp dx, byte 20h
        jl short loc_8F64F
        dec word [word_D4F88]
loc_8F679:
        pop edx
        pop ecx
        pop ebx
        ret
StopSongId:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov ebp, eax
        cmp eax, byte 0FFFFFFFFh
        jne short loc_8F694
        mov eax, 0FFFFFFFFh
        jmp near loc_8F1F7
loc_8F694:
        inc word [word_D4F88]
        cmp eax, 100h
        jae short loc_8F6D4
        cmp dword [dword_D4F8E], byte 0
        jne short loc_8F6B2
        xor eax, eax
        jmp near loc_8F1F7
loc_8F6B2:
        shl eax, 2
        sub eax, ebp
        shl eax, 2
        cmp dword [dword eax+dword_F18A4], byte 0
        je short loc_8F6CD
        mov dword [dword eax+dword_F18A4], 1
loc_8F6CD:
        xor eax, eax
        jmp near loc_8F7A2
loc_8F6D4:
        mov ecx, dword_F189C
        mov esi, byte_F1A1C
        xor edi, edi
        jmp short loc_8F6F1
loc_8F6E2:
        cmp ebp, dword [ecx]
        jne short loc_8F6ED
        mov eax, ecx
        call sub_99620
loc_8F6ED:
        add ecx, byte 0Ch
        inc edi
loc_8F6F1:
        cmp di, byte 20h
        jl short loc_8F6E2
        mov ecx, unk_F21FC
        add ecx, dword [dword_D4F9A]
        xor edi, edi
        add dword [dword_D4F9A], byte 4
        jmp short loc_8F76B
loc_8F70D:
        cmp ebp, dword [byte esi+02h]
        jne short loc_8F767
        mov al, byte [byte esi+050h]
        or al, 0B0h
        mov byte [ecx], al
        mov byte [byte ecx+01h], 7Bh
        mov byte [byte ecx+02h], 0
        mov al, byte [byte esi+051h]
        and al, 7Fh
        and eax, 0FFh
        mov ebx, ecx
        mov edx, 3
        call sub_997B7
        mov al, byte [byte esi+050h]
        or al, 0B0h
        mov byte [ecx], al
        mov byte [byte ecx+01h], 7
        mov byte [byte ecx+02h], 0
        mov al, byte [byte esi+051h]
        and al, 7Fh
        and eax, 0FFh
        mov ebx, ecx
        mov edx, 3
        call sub_997B7
        mov byte [byte esi+01h], 0
        mov dword [byte esi+02h], 0
loc_8F767:
        add esi, byte 54h
        inc edi
loc_8F76B:
        cmp di, byte 18h
        jl short loc_8F70D
        mov byte [ecx], 0B9h
        mov byte [byte ecx+01h], 7
        mov byte [byte ecx+02h], 7Fh
        mov al, byte [byte_F1D61]
        and al, 7Fh
        and eax, 0FFh
        mov ebx, ecx
        mov edx, 3
        call sub_997B7
        call sub_98F46
        xor eax, eax
        sub dword [dword_D4F9A], byte 4
loc_8F7A2:
        dec word [word_D4F88]
        jmp near loc_8F1F7
ReleaseSong:
        push ebx
        push ecx
        push esi
        push edi
        mov esi, eax
        mov edi, edx
        mov eax, byte_F1A1C
        xor ebx, ebx
        inc word [word_D4F88]
        jmp short loc_8F7FA
loc_8F7C6:
        cmp esi, dword [byte eax+02h]
        jne short loc_8F7F6
        mov dl, byte [byte eax+01h]
        test dl, dl
        je short loc_8F7F6
        mov dh, dl
        or dh, 8
        mov byte [byte eax+01h], dh
        mov edx, dword [byte eax+06h]
        mov word [byte edx+0Ch], di
        mov edx, dword [byte eax+06h]
        mov cx, word [byte edx+0Ch]
        dec ecx
        mov word [byte edx+0Eh], cx
        mov edx, dword [byte eax+06h]
        mov cl, byte [byte edx+011h]
        mov byte [byte edx+010h], cl
loc_8F7F6:
        add eax, byte 54h
        inc ebx
loc_8F7FA:
        cmp bx, byte 18h
        jl short loc_8F7C6
        dec word [word_D4F88]
        xor eax, eax
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
SongFinished:
        push ebx
        push edx
        mov ebx, eax
        cmp dword [sndhandlecount], byte 0
        je short loc_8F83E
        mov eax, byte_F1A1C
        xor edx, edx
        jmp short loc_8F838
loc_8F824:
        cmp ebx, dword [byte eax+02h]
        jne short loc_8F834
        cmp byte [byte eax+01h], 0
        je short loc_8F834
        xor eax, eax
        pop edx
        pop ebx
        ret
loc_8F834:
        add eax, byte 54h
        inc edx
loc_8F838:
        cmp dx, byte 18h
        jl short loc_8F824
loc_8F83E:
        mov eax, 1
        pop edx
        pop ebx
        ret
SongReleased:
        push ebx
        push edx
        mov ebx, eax
        cmp dword [sndhandlecount], byte 0
        je short loc_8F876
        mov eax, byte_F1A1C
        xor edx, edx
        jmp short loc_8F870
loc_8F85C:
        cmp ebx, dword [byte eax+02h]
        jne short loc_8F86C
        test byte [byte eax+01h], 8
        je short loc_8F86C
        xor eax, eax
        pop edx
        pop ebx
        ret
loc_8F86C:
        add eax, byte 54h
        inc edx
loc_8F870:
        cmp dx, byte 18h
        jl short loc_8F85C
loc_8F876:
        mov eax, 1
        pop edx
        pop ebx
        ret
        push ebx
        push ecx
        mov ecx, eax
        mov bl, dl
        mov eax, byte_F1A1C
        xor edx, edx
        jmp short loc_8F8A9
loc_8F88D:
        cmp ecx, dword [byte eax+02h]
        jne short loc_8F8A5
        mov bh, byte [byte eax+050h]
        cmp bl, bh
        jne short loc_8F8A5
        cmp bh, bh
        jne short loc_8F8A5
        mov al, byte [byte eax+04Eh]
        xor ah, ah
        pop ecx
        pop ebx
        ret
loc_8F8A5:
        add eax, byte 54h
        inc edx
loc_8F8A9:
        cmp dx, byte 18h
        jl short loc_8F88D
        mov eax, 0FFFFFFFFh
        pop ecx
        pop ebx
        ret
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov ecx, unk_F21FC
        mov edx, dword [dword_D4F9A]
        add ecx, edx
        mov esi, byte_F1A1C
        mov dword [dword_D4F8A], 1
        xor edi, edi
        lea ebp, [byte edx+04h]
        mov dword [dword_D4F9A], ebp
        jmp short loc_8F90A
loc_8F8E6:
        cmp byte [byte esi+01h], 0
        je short loc_8F909
        mov al, byte [byte esi+050h]
        or al, 0B0h
        mov byte [ecx], al
        mov byte [byte ecx+01h], 7
        mov byte [byte ecx+02h], 0
        mov ebx, ecx
        mov edx, 3
        xor eax, eax
        call sub_997B7
loc_8F909:
        inc edi
loc_8F90A:
        cmp di, byte 18h
        jl short loc_8F8E6
        sub dword [dword_D4F9A], byte 4
        jmp near loc_8F1F7
        push ebx
        push ecx
        push edx
        push esi
        mov ecx, byte_F1A1C
        xor esi, esi
        jmp short loc_8F950
loc_8F929:
        cmp byte [byte ecx+01h], 0
        je short loc_8F94F
        xor edx, edx
        mov dl, byte [byte ecx+050h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        xor ebx, ebx
        mov bl, byte [dword eax+byte_F234D]
        mov edx, 7
        mov eax, ecx
        call sub_99522
loc_8F94F:
        inc esi
loc_8F950:
        cmp si, byte 18h
        jl short loc_8F929
        xor edx, edx
        mov dword [dword_D4F8A], edx
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
EnableMidiSfx:
        mov dword [dword_D4F8E], 1
        ret
DisableMidiSfx:
        push edx
        xor edx, edx
        mov dword [dword_D4F8E], edx
        pop edx
        ret
EnableMidiMusic:
        mov dword [dword_D4F92], 1
        ret
DisableMidiMusic:
        push edx
        xor edx, edx
        mov dword [dword_D4F92], edx
        pop edx
        ret
LoadDigiFile:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 5Ch
        mov edx, eax
        mov eax, 7
        call SndLoadFile2
        mov dword [byte esp+054h], eax
        test eax, eax
        je near loc_8FAEA
        push eax
        call MemDescPtr
        add esp, byte 4
        mov edi, eax
        xor dl, dl
        mov byte [byte esp+044h], dl
        mov byte [byte esp+045h], dl
        xor esi, esi
        mov edx, dword [eax]
        cmp edx, 4D524F46h
        jne short loc_8FA46
        lea ebx, [byte eax+04h]
        mov edx, str_VHDR
        mov eax, ebx
        call FindSubstring
        mov esi, eax
        test eax, eax
        jge short loc_8F9F6
        lea eax, [byte esp+054h]
        call ReleaseMemPtr
        xor eax, eax
        jmp near loc_8FAEA
loc_8F9F6:
        add eax, ebx
        push byte 18h
        lea edx, [byte esp+030h]
        push edx
        push eax
        call bcopy
        add esp, byte 0Ch
        add esi, byte 24h
        xor eax, eax
        mov ax, word [byte esp+03Ch]
        call SwapBytes16
        mov word [byte esp+046h], ax
        mov eax, dword [byte esp+030h]
        call SwapBytes32
        mov edx, eax
        mov dword [byte esp+04Ch], eax
        mov eax, dword [byte esp+034h]
        call SwapBytes32
        mov dword [byte esp+050h], eax
        add edx, eax
        mov dword [byte esp+048h], edx
        xor bh, bh
        mov byte [byte esp+058h], bh
        jmp short loc_8FA83
loc_8FA46:
        cmp edx, 46464952h
        jne short loc_8FA83
        push byte 2Ch
        lea edx, [byte esp+04h]
        push edx
        push eax
        call bcopy
        add esp, byte 0Ch
        mov esi, 2Ch
        mov eax, dword [byte esp+018h]
        mov word [byte esp+046h], ax
        mov eax, dword [byte esp+028h]
        mov dword [byte esp+048h], eax
        xor edx, edx
        mov dword [byte esp+04Ch], edx
        mov dword [byte esp+050h], edx
        mov byte [byte esp+058h], 80h
loc_8FA83:
        mov ecx, dword [byte esp+054h]
        push ecx
        call MemDescSize
        add esp, byte 4
        sub eax, esi
        push eax
        lea ebp, [byte edi+010h]
        push ebp
        lea eax, [edi+esi]
        push eax
        call bcopy
        add esp, byte 0Ch
        mov eax, dword [byte esp+054h]
        push eax
        call MemDescSize
        add esp, byte 4
        sub eax, esi
        add eax, byte 10h
        push eax
        mov edx, dword [byte esp+058h]
        push edx
        call sub_8D144
        add esp, byte 8
        lea esi, [byte esp+044h]
        movsd
        movsd
        movsd
        movsd
        cmp byte [byte esp+058h], 0
        je short loc_8FAE6
        mov eax, ebp
        xor edx, edx
        jmp short loc_8FAE0
loc_8FAD8:
        mov bl, byte [byte esp+058h]
        xor byte [eax], bl
        inc eax
        inc edx
loc_8FAE0:
        cmp edx, dword [byte esp+048h]
        jb short loc_8FAD8
loc_8FAE6:
        mov eax, dword [byte esp+054h]
loc_8FAEA:
        add esp, byte 5Ch
        jmp near loc_8F1F7
FindSubstring:
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        mov ebx, eax
        mov edi, edx
        mov eax, edx
        call strlen_
        mov ebp, eax
        xor eax, eax
        xor esi, esi
loc_8FB08:
        mov cl, byte [ebx]
        cmp cl, byte [edi+eax]
        jne short loc_8FB16
        inc eax
        cmp eax, ebp
        je short loc_8FB1C
        jmp short loc_8FB18
loc_8FB16:
        xor eax, eax
loc_8FB18:
        inc ebx
        inc esi
        jmp short loc_8FB08
loc_8FB1C:
        lea eax, [byte esi+01h]
        jmp near loc_8EF4A
PlayDigiBlock:
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov edi, eax
        mov eax, edx
        mov esi, ebx
        mov ebp, ecx
        test edi, edi
        je short loc_8FB87
        call SndDriverHandle
        mov dword [esp], eax
        test eax, eax
        jl short loc_8FB87
        push edi
        call MemDescPtr
        add esp, byte 4
        mov edi, esi
        mov edx, edi
        shl edx, 2
        add edx, edi
        xor ebx, ebx
        mov dword [nosplit edx*4+dword_F22FC], ebx
        push ebx
        push ebp
        xor edx, edx
        mov dx, word [byte eax+02h]
        push edx
        mov ecx, dword [byte eax+0Ch]
        push ecx
        mov edi, dword [byte eax+08h]
        push edi
        mov ebp, dword [byte eax+04h]
        push ebp
loc_8FB72:
        movzx edi, byte [byte esp+018h]
        mov ecx, 10h
        mov ebx, eax
        mov edx, esi
        mov eax, edi
        call SndHandlePlayDigi
loc_8FB87:
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        ret
PlayDigiBlockLoop:
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov edi, eax
        mov eax, edx
        mov esi, ebx
        mov ebp, ecx
        test edi, edi
        je short loc_8FB87
        call SndDriverHandle
        mov dword [esp], eax
        test eax, eax
        jl short loc_8FB87
        push edi
        call MemDescPtr
        add esp, byte 4
        mov edi, esi
        mov edx, edi
        shl edx, 2
        add edx, edi
        xor ebx, ebx
        mov dword [nosplit edx*4+dword_F22FC], ebx
        push byte 1
        push ebp
        xor edx, edx
        mov dx, word [byte eax+02h]
        push edx
        mov edx, dword [byte eax+0Ch]
        shr edx, 1
        push edx
        mov edx, dword [byte eax+08h]
        shr edx, 1
        push edx
        mov edx, dword [byte eax+04h]
        shr edx, 1
        push edx
        jmp short loc_8FB72
PlayDigiPtr:
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov esi, eax
        mov eax, edx
        mov edx, ebx
        test esi, esi
        je short loc_8FC2E
        call SndDriverHandle
        mov dword [esp], eax
        test eax, eax
        jl short loc_8FC2E
        mov eax, ebx
        shl eax, 2
        add eax, ebx
        xor ebx, ebx
        mov dword [nosplit eax*4+dword_F22FC], ebx
        push ebx
        mov edi, dword [byte esp+01Ch]
        push edi
        mov ebp, dword [byte esp+01Ch]
        push ebp
        push ebx
        push ebx
        push ecx
        xor eax, eax
        mov al, byte [byte esp+018h]
        xor ecx, ecx
        mov ebx, esi
        call SndHandlePlayDigi
loc_8FC2E:
        add esp, byte 4
loc_8FC31:
        pop ebp
        pop edi
        pop esi
        ret 8
PlayDigiPtrLoop:
        push esi
        push edi
        push ebp
        mov esi, eax
        mov eax, edx
        mov edi, ebx
        mov edx, ecx
        test esi, esi
        je short loc_8FC31
        call SndDriverHandle
        mov ecx, eax
        test eax, eax
        jl short loc_8FC31
        mov eax, ebx
        shl eax, 2
        add eax, ebx
        xor ebx, ebx
        mov dword [nosplit eax*4+dword_F22FC], ebx
        push byte 1
        mov ebp, dword [byte esp+018h]
        push ebp
        mov eax, dword [byte esp+018h]
        push eax
        push ebx
        push ebx
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        push eax
        xor eax, eax
        mov al, cl
        xor ecx, ecx
        mov ebx, esi
        mov edx, edi
        call SndHandlePlayDigi
        jmp short loc_8FC31
SndQuery:
        cmp eax, dword [sndhandlecount]
        jge short loc_8FC96
        test eax, eax
        jge short loc_8FC9C
loc_8FC96:
        mov eax, 0FFFFFFFFh
        ret
loc_8FC9C:
        shl edx, 10h
        add edx, byte 9
        and eax, 0FFh
        jmp near SndDriverCall
StopDigiChannel:
        push ebx
        push ecx
        call SndDriverHandle
        mov ecx, eax
        test eax, eax
        jl short loc_8FCDC
        push byte 0
        push byte 0
        push byte 0
        push byte 0
        push byte 0
        push byte 0
        lea eax, [byte edx+01h]
        shl eax, 0Ch
        lea ebx, [dword eax+0FFh]
        xor eax, eax
        mov al, cl
        xor ecx, ecx
        call SndHandlePlayDigi
loc_8FCDC:
        pop ecx
        pop ebx
        ret
SetDigiChannelVolume:
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov ecx, eax
        mov esi, edx
        mov dword [esp], ebx
        test ebx, ebx
        jne short loc_8FCF8
        call StopDigiChannel
        jmp short loc_8FD5F
loc_8FCF8:
        call SndDriverHandle
        mov edi, eax
        test eax, eax
        jl short loc_8FD5F
        shl edx, 10h
        add edx, byte 0Ah
        and eax, 0FFh
        call SndDriverCall
        mov ebp, eax
        shl eax, 18h
        mov ebx, esi
        shl ebx, 2
        add ebx, esi
        mov dword [nosplit ebx*4+dword_F2300], eax
        mov esi, ebp
        mov eax, esi
        shl eax, 7
        add eax, esi
        shl eax, 3
        mov edx, eax
        shl edx, 0Eh
        add edx, eax
        mov eax, edx
        sar edx, 1Fh
        mov esi, dword [esp]
        idiv esi
        mov dword [nosplit ebx*4+dword_F2304], eax
        mov dword [nosplit ebx*4+dword_F22FC], ebp
        mov dword [nosplit ebx*4+dword_F2308], ecx
        mov dword [nosplit ebx*4+dword_F230C], edi
loc_8FD5F:
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
QueryDigiChannel:
        push ebx
        call SndDriverHandle
        mov ebx, eax
        test eax, eax
        jl short loc_8FD82
        shl edx, 10h
        add edx, byte 33h
        xor eax, eax
        mov al, bl
        call SndDriverCall
loc_8FD82:
        pop ebx
        ret
MidiProgramChange:
        sub esp, byte 4
        cmp eax, dword [sndhandlecount]
        jge short loc_8FDAE
        test eax, eax
        jl short loc_8FDAE
        or dl, 0C0h
        mov byte [esp], dl
        mov byte [byte esp+01h], bl
        and eax, 0FFh
        mov ebx, esp
        mov edx, 2
        call sub_997B7
loc_8FDAE:
        add esp, byte 4
        ret
MidiSetVolume:
        sub esp, byte 4
        cmp eax, dword [sndhandlecount]
        jge short loc_8FDE1
        test eax, eax
        jl short loc_8FDE1
        or dl, 0B0h
        mov byte [esp], dl
        mov byte [byte esp+01h], 7
        mov byte [byte esp+02h], bl
        and eax, 0FFh
        mov ebx, esp
        mov edx, 3
        call sub_997B7
loc_8FDE1:
        add esp, byte 4
        ret
MidiPitchBend:
        sub esp, byte 4
        cmp eax, dword [sndhandlecount]
        jge short loc_8FE18
        test eax, eax
        jl short loc_8FE18
        or dl, 0E0h
        mov byte [esp], dl
        xor ah, ah
        mov byte [byte esp+01h], ah
        and bl, 7Fh
        mov byte [byte esp+02h], bl
        and eax, 0FFh
        mov ebx, esp
        mov edx, 3
        call sub_997B7
loc_8FE18:
        add esp, byte 4
        ret
MidiNoteOn:
        sub esp, byte 4
        cmp eax, dword [sndhandlecount]
        jge short loc_8FE4B
        test eax, eax
        jl short loc_8FE4B
        or dl, 90h
        mov byte [esp], dl
        mov byte [byte esp+01h], bl
        mov byte [byte esp+02h], 7Fh
        and eax, 0FFh
        mov ebx, esp
        mov edx, 3
        call sub_997B7
loc_8FE4B:
        add esp, byte 4
        ret
MidiNoteOff:
        sub esp, byte 4
        cmp eax, dword [sndhandlecount]
        jge short loc_8FE7F
        test eax, eax
        jl short loc_8FE7F
        or dl, 80h
        mov byte [esp], dl
        mov byte [byte esp+01h], bl
        xor ah, ah
        mov byte [byte esp+02h], ah
        and eax, 0FFh
        mov ebx, esp
        mov edx, 3
        call sub_997B7
loc_8FE7F:
        add esp, byte 4
        ret
SetSoundByteOrder:
        mov byte [byte_D41CD], al
        ret
FindSoundChunk:
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        mov esi, edx
        lea ebx, [byte eax+04h]
        add eax, byte 6
        xor edx, edx
        mov dx, word [ebx]
        mov ecx, edx
        shl ecx, 2
        lea ebp, [eax+ecx]
        shl edx, 3
        lea edi, [eax+edx]
        xor edx, edx
        jmp short loc_8FEC2
loc_8FEAD:
        cmp esi, dword [eax]
        jne short loc_8FEBE
        mov eax, edx
        mov eax, dword [byte ebp+eax*4+00h]
        add eax, edi
        jmp near loc_8EF4A
loc_8FEBE:
        inc edx
        add eax, byte 4
loc_8FEC2:
        xor ecx, ecx
        mov cx, word [ebx]
        cmp edx, ecx
        jl short loc_8FEAD
        xor eax, eax
        jmp near loc_8EF4A
ReplaceFileExt:
        push ecx
        push esi
        push edi
        sub esp, 0B0h
        mov edi, edx
        mov esi, ebx
        lea edx, [dword esp+098h]
        push edx
        lea ecx, [dword esp+08Ch]
        lea ebx, [byte esp+04h]
        lea edx, [dword esp+0A8h]
        call _splitpath_
        push edi
        lea ecx, [dword esp+08Ch]
        mov ebx, unk_C3FD5
        mov edx, ebx
        mov eax, esi
        call _makepath_
        add esp, 0B0h
        pop edi
        pop esi
        pop ecx
        ret
FreeMemPtr:
        push ebx
        push ecx
        push edx
        push esi
        mov esi, eax
        mov edx, dword [eax]
        test edx, edx
        je short loc_8FF39
        push edx
        call FreeMemBlock
        add esp, byte 4
        mov dword [esi], 0
loc_8FF39:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
ReleaseMemPtr:
        push ebx
        push ecx
        push edx
        push esi
        mov esi, eax
        mov edx, dword [eax]
        test edx, edx
        je short loc_8FF59
        push edx
        call PushMemDescriptorLocked
        add esp, byte 4
        mov dword [esi], 0
loc_8FF59:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
SwapBytes16:
        push edx
        mov edx, eax
        xor dh, ah
        and edx, 0FFFFh
        shl edx, 8
        xor al, al
        and eax, 0FFFFh
        sar eax, 8
        add edx, eax
        mov eax, edx
        pop edx
        ret
SwapBytes32:
        push ebx
        push edx
        mov ebx, eax
        and ebx, 0FFh
        shl ebx, 18h
        mov edx, eax
        and edx, 0FF00h
        shl edx, 8
        add edx, ebx
        mov ebx, eax
        and ebx, 0FF0000h
        shr ebx, 8
        add edx, ebx
        and eax, 0FF000000h
        shr eax, 18h
        add eax, edx
        pop edx
        pop ebx
        ret
SetPalette:
        push ebp
        LD mov, ebp, esp
        push edi
        mov edi, dword [byte ebp+010h]
        mov edx, 3C7h
        mov eax, dword [byte ebp+08h]
        out dx, al
        mov ebx, dword [byte ebp+0Ch]
        lea ecx, [ebx+ebx*2]
        mov edx, 3C9h
loc_8FFCB:
        in al, dx
        stosb
        loop loc_8FFCB
        pop edi
        leave
        ret
        db 00h,00h
