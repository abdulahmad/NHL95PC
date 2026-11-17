; EA sound: start-up, music banks, patches, timbres and songs.
bits 32
%include "hockey.inc"
section s_8EB5B progbits alloc exec nowrite align=1
extern __GETDS, _makepath_, _splitpath_, ActiveSongCount, AddExitHandler, addtimer, bcopy, DefaultSampleInfo
extern DigiFadeAccum, DigiFadeChannel, DigiFadeDriver, DigiFadeLevel, DigiFadeStep, FillMem, FreeMemBlock, MemDescPtr
extern MemDescSize, MidiChannelBits, MidiChannelUsed, MidiChanVolume, MidiMusicEnabled, MidiOutQueue, MidiSfxEnabled, MidiTickCount
extern MusicBankHeader, MusicBankPatchNum, MusicBankTimbreCount, MusicBankTimbreNums, MusicPatchFile, MusicTimbreFiles, MusicTimbreSizes, PatchFile
extern PlayPatchHandle, PushMemDescriptorLocked, RemoveTimerCallback, ResizeMemHandleUnlocked, SampleChunkSize, SampleTable, SampleTableSize, SeqNoteOffSlot
extern SeqNoteOn, SeqQueueCommand, SeqSendController, SeqSendPitchBend, SeqSendProgram, SeqService, SeqTrackFlags, SeqTrackPos
extern SeqTracks, SeqUpdate, SndBigEndian, SndDriverCall, SndDriverHandle, SndHandleClose, sndhandlecount, SndHandlePlayDigi
extern SndHandleSetTrack, SndHandleType, SndInitDone, SndLoadFile, SndLoadFile2, SndTimerHandle, SongRecords, SongRelease
extern SongReleasedFlag, SongTable, sprintf_, str_03sFF03dPAT, str_03sFF03dTIM, str_CFG2, str_EmptyExt, str_KMS2
extern str_SCN, str_VHDR, strlen_, TimbreBanks
global SndInit, SndShutdown, SndClearTables, LoadMusicBank, FreeMusicBank, LoadPatchFile, FreeSoundBlock, LoadTimbreFile
global AddTimbreBank, FreeTimbreFile, RemoveTimbreBank, LinkPatchTimbres, GetPatchEntry, GetPatchTimbre, LoadSample, FreeSample
global FindSongSlot, PlaySong, StartSongTracks, FindFreeTrack, FindFreeMidiChannel, LoadAndPlaySong, StartSong, PlayPatch
global PlayPatchFull, ReleaseAllVoices, StopSongId, ReleaseSong, SongFinished, SongReleased, EnableMidiSfx, DisableMidiSfx
global EnableMidiMusic, DisableMidiMusic, LoadDigiFile, FindSubstring, PlayDigiBlock, PlayDigiBlockLoop, PlayDigiPtr, PlayDigiPtrLoop
global SndQuery, StopDigiChannel, SetDigiChannelVolume, QueryDigiChannel, MidiProgramChange, MidiSetVolume, MidiPitchBend, MidiNoteOn
global MidiNoteOff, SetSoundByteOrder, FindSoundChunk, ReplaceFileExt, FreeMemPtr, ReleaseMemPtr, SwapBytes16, SwapBytes32
global SetPalette
;-----------------------------------------------------------------------------
; SndInit                                      8EB5B  95 PC, medium confidence
; Sound library start: shuts down first, adds the sound timer callback and
; the exit handler once
;-----------------------------------------------------------------------------
SndInit:
        push ebx
        push ecx
        push edx
        call SndShutdown
        push SeqService
        call addtimer
        add esp, byte 4
        cmp byte [SndInitDone], 0
        jne short .1
        push SndShutdown
        call AddExitHandler
        add esp, byte 4
        mov byte [SndInitDone], 1
.1:
        xor eax, eax
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; SndShutdown                                  8EB93  95 PC, medium confidence
; Removes the sound timer, closes every driver handle, frees the songs and
; the music bank, clears the tables
;-----------------------------------------------------------------------------
SndShutdown:
        push ebx
        push ecx
        push edx
        push SeqService
        call RemoveTimerCallback
        add esp, byte 4
        mov edx, dword [sndhandlecount]
        jmp short .2
.1:
        xor eax, eax
        mov al, dl
        call SndHandleClose
.2:
        dec edx
        test edx, edx
        jge short .1
        xor edx, edx
.3:
        mov eax, edx
        shl eax, 2
        sub eax, edx
        mov eax, dword [nosplit eax*8+SampleTable]
        call FreeSample
        inc edx
        cmp edx, byte 0Dh
        jl short .3
        call FreeMusicBank
        call SndClearTables
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; SndClearTables                               8EBE2  95 PC, medium confidence
; Clears the track, voice, timbre bank, MIDI channel, song and digital
; channel tables
;-----------------------------------------------------------------------------
SndClearTables:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        xor eax, eax
        jmp short .2
.1:
        movsx edx, ax
        imul edx, byte 54h
        mov byte [dword edx+SeqTracks], al
        xor bl, bl
        mov byte [dword edx+SeqTrackFlags], bl
        xor ebx, ebx
        mov dword [dword edx+SeqTrackPos], ebx
        inc eax
.2:
        cmp ax, 18h
        jl short .1
        xor eax, eax
        jmp short .4
.3:
        movsx ebx, ax
        mov edx, ebx
        shl edx, 2
        sub edx, ebx
        xor ecx, ecx
        mov dword [nosplit edx*4+SongRecords], ecx
        inc eax
.4:
        cmp ax, 20h
        jl short .3
        xor eax, eax
        jmp short .6
.5:
        movsx edx, ax
        xor esi, esi
        mov dword [nosplit edx*4+TimbreBanks], esi
        inc eax
.6:
        cmp ax, 0Ah
        jl short .5
        xor eax, eax
        jmp short .8
.7:
        movsx edx, ax
        xor bh, bh
        mov byte [dword edx+MidiChannelUsed], bh
        inc eax
.8:
        cmp ax, 10h
        jl short .7
        xor eax, eax
        jmp short .10
.9:
        movsx ebx, ax
        mov edx, ebx
        shl edx, 2
        sub edx, ebx
        xor edi, edi
        mov dword [nosplit edx*8+SampleTable], edi
        mov dword [nosplit edx*8+SampleTableSize], edi
        mov dword [nosplit edx*8+SongTable], edi
        inc eax
.10:
        cmp ax, 0Dh
        jl short .9
        xor eax, eax
        jmp short .12
.11:
        movsx ebx, ax
        mov edx, ebx
        shl edx, 2
        add edx, ebx
        xor ecx, ecx
        mov dword [nosplit edx*4+DigiFadeLevel], ecx
        inc eax
.12:
        cmp ax, 4
        jl short .11
        xor esi, esi
        mov dword [PatchFile], esi
        mov dword [sndhandlecount], esi
        mov dword [SndTimerHandle], 0FFFFFFFFh
        jmp near LoadSample+0BDh
;-----------------------------------------------------------------------------
; LoadMusicBank                                   8ECC0  95 PC, low confidence
; Loads a .SCN music bank: its header, the PAT patch file and the TIM timbre
; files
;-----------------------------------------------------------------------------
LoadMusicBank:
        push ebx
        push ecx
        push esi
        sub esp, byte 14h
        mov ecx, eax
        mov esi, edx
        call FreeMusicBank
        cmp byte [ecx], 0
        jne short .1
        mov eax, 0FFFFFFFBh
        jmp near .7
.1:
        mov ebx, esp
        mov edx, str_SCN
        mov eax, ecx
        call ReplaceFileExt
        mov edx, esp
        mov eax, 1
        call SndLoadFile2
        mov dword [byte esp+010h], eax
        test eax, eax
        jne short .2
        mov eax, 0FFFFFFFFh
        jmp near .7
.2:
        push eax
        call MemDescSize
        add esp, byte 4
        push eax
        push MusicBankHeader
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
        mov al, byte [MusicBankPatchNum]
        push eax
        push esi
        push str_03sFF03dPAT
        lea eax, [byte esp+0Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        mov eax, esp
        call LoadPatchFile
        mov dword [MusicPatchFile], eax
        test eax, eax
        jne short .3
        call FreeMusicBank
        mov eax, 0FFFFFFFEh
        jmp short .7
.3:
        xor ebx, ebx
        jmp short .6
.4:
        xor eax, eax
        mov al, byte [dword ebx+MusicBankTimbreNums]
        push eax
        push esi
        push str_03sFF03dTIM
        lea eax, [byte esp+0Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        mov ecx, ebx
        shl ecx, 2
        mov edx, MusicTimbreSizes
        add edx, ecx
        mov eax, esp
        call LoadTimbreFile
        mov dword [dword ecx+MusicTimbreFiles], eax
        test eax, eax
        jne short .5
        call FreeMusicBank
        mov eax, 0FFFFFFFDh
        jmp short .7
.5:
        inc ebx
.6:
        xor eax, eax
        mov al, byte [MusicBankTimbreCount]
        cmp ebx, eax
        jl short .4
        call LinkPatchTimbres
        xor eax, eax
.7:
        add esp, byte 14h
        pop esi
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; FreeMusicBank                                   8EDD2  95 PC, low confidence
; Frees the timbre files and the patch file of the loaded music bank
;-----------------------------------------------------------------------------
FreeMusicBank:
        push ecx
        push edx
        push esi
        cmp byte [MusicBankHeader], 4
        jne short .3
        xor ecx, ecx
        jmp short .2
.1:
        mov edx, dword [nosplit ecx*4+MusicTimbreSizes]
        mov eax, dword [nosplit ecx*4+MusicTimbreFiles]
        call FreeTimbreFile
        xor esi, esi
        mov dword [nosplit ecx*4+MusicTimbreFiles], esi
        mov dword [nosplit ecx*4+MusicTimbreSizes], esi
        inc ecx
.2:
        xor eax, eax
        mov al, byte [MusicBankTimbreCount]
        cmp ecx, eax
        jl short .1
        mov eax, dword [MusicPatchFile]
        call FreeSoundBlock
        xor edx, edx
        mov dword [MusicPatchFile], edx
        xor dl, dl
        mov byte [MusicBankHeader], dl
.3:
        pop esi
        pop edx
        pop ecx
        ret
;-----------------------------------------------------------------------------
; LoadPatchFile                                   8EE2F  95 PC, low confidence
; Loads the patch file of a music bank
;-----------------------------------------------------------------------------
LoadPatchFile:
        push edx
        mov edx, eax
        mov eax, 2
        call SndLoadFile
        mov dword [PatchFile], eax
        pop edx
        ret
;-----------------------------------------------------------------------------
; FreeSoundBlock                                  8EE43  95 PC, low confidence
; Frees the memory block whose handle is passed by value
;-----------------------------------------------------------------------------
FreeSoundBlock:
        push eax
        mov eax, esp
        call FreeMemPtr
        add esp, byte 4
        ret
;-----------------------------------------------------------------------------
; LoadTimbreFile                                  8EE4F  95 PC, low confidence
; Loads a timbre file and its digital sample data, and links each timbre to
; its sample
;-----------------------------------------------------------------------------
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
        je near .9
        call AddTimbreBank
        cmp byte [SndBigEndian], 0
        je short .1
        mov edx, 6769642Eh
        jmp short .2
.1:
        mov edx, 2E646967h
.2:
        mov eax, dword [byte esp+04h]
        call FindSoundChunk
        test eax, eax
        je near .8
        mov edx, eax
        mov eax, 4
        call SndLoadFile2
        mov edx, dword [esp]
        mov dword [edx], eax
        test eax, eax
        je near .8
        mov eax, dword [byte esp+04h]
        mov ax, word [byte eax+04h]
        mov dword [byte esp+0Ch], eax
        mov edi, dword [byte esp+04h]
        add edi, byte 6
        xor ebx, ebx
        mov dword [byte esp+08h], ebx
        jmp short .7
.3:
        mov edx, dword [edi]
        mov eax, dword [byte esp+04h]
        call FindSoundChunk
        mov esi, eax
        cmp byte [eax], 6
        jne short .6
        cmp byte [SndBigEndian], 0
        je short .4
        mov ebp, dword [byte eax+02h]
        jmp short .5
.4:
        mov eax, dword [byte eax+02h]
        call SwapBytes32
        mov ebp, eax
.5:
        mov eax, dword [esp]
        mov edx, dword [eax]
        push edx
        call MemDescPtr
        add esp, byte 4
        mov edx, ebp
        call FindSoundChunk
        test eax, eax
        je short .6
        mov word [byte esi+0Ah], 0
        mov dword [byte esi+0Ch], eax
        mov byte [byte esi+010h], 0
        mov byte [byte esi+011h], 0
        mov word [byte esi+012h], 2B11h
.6:
        add edi, byte 4
        inc dword [byte esp+08h]
.7:
        xor eax, eax
        mov ax, word [byte esp+0Ch]
        cmp eax, dword [byte esp+08h]
        jg short .3
.8:
        mov eax, dword [byte esp+04h]
.9:
        add esp, byte 10h
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; AddTimbreBank                                   8EF50  95 PC, low confidence
; Puts a timbre file in the first free slot of the 10-entry bank list
;-----------------------------------------------------------------------------
AddTimbreBank:
        push ebx
        push edx
        mov ebx, eax
        xor eax, eax
.1:
        mov edx, eax
        shl edx, 2
        cmp dword [dword edx+TimbreBanks], byte 0
        jne short .2
        mov dword [dword edx+TimbreBanks], ebx
        pop edx
        pop ebx
        ret
.2:
        inc eax
        cmp eax, byte 0Ah
        jl short .1
        pop edx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; FreeTimbreFile                                  8EF76  95 PC, low confidence
; Removes a timbre file from the bank list and frees it and its samples
;-----------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------
; RemoveTimbreBank                                8EF91  95 PC, low confidence
; Clears the bank list slot that holds a timbre file
;-----------------------------------------------------------------------------
RemoveTimbreBank:
        push ebx
        push edx
        push esi
        mov ebx, eax
        xor eax, eax
.1:
        mov edx, eax
        shl edx, 2
        cmp ebx, dword [dword edx+TimbreBanks]
        jne short .2
        xor esi, esi
        mov dword [dword edx+TimbreBanks], esi
        pop esi
        pop edx
        pop ebx
        ret
.2:
        inc eax
        cmp eax, byte 0Ah
        jl short .1
        pop esi
        pop edx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; LinkPatchTimbres                                8EFBB  95 PC, low confidence
; Finds the timbre of each of the 256 patches in the loaded banks
;-----------------------------------------------------------------------------
LinkPatchTimbres:
        push ebx
        push ecx
        push edx
        push ebp
        sub esp, byte 8
        cmp dword [PatchFile], byte 0
        je near .14
        xor ebx, ebx
        mov dword [esp], ebx
        inc word [ActiveSongCount]
.1:
        xor eax, eax
        mov al, byte [esp]
        push eax
        call GetPatchEntry
        add esp, byte 4
        mov ebx, eax
        test eax, eax
        je near .13
        mov dl, byte [byte eax+0Fh]
        test dl, 80h
        jne near .13
        cmp dl, 3
        jne short .6
        xor eax, eax
        jmp short .5
.2:
        cmp byte [dword eax+SndHandleType], 3
        jne short .4
.3:
        or al, 80h
        mov byte [byte ebx+0Fh], al
        jmp near .13
.4:
        inc eax
.5:
        cmp eax, dword [sndhandlecount]
        jl short .2
        jmp near .13
.6:
        xor ecx, ecx
.7:
        cmp dword [nosplit ecx*4+TimbreBanks], byte 0
        je near .12
        cmp byte [SndBigEndian], 0
        je short .8
        mov byte [byte esp+04h], 80h
        mov al, byte [ebx]
        mov byte [byte esp+05h], al
        xor al, al
        mov byte [byte esp+06h], al
        mov al, byte [byte ebx+01h]
        mov byte [byte esp+07h], al
        jmp short .9
.8:
        mov byte [byte esp+07h], 80h
        mov al, byte [ebx]
        mov byte [byte esp+06h], al
        xor dl, dl
        mov byte [byte esp+05h], dl
        mov al, byte [byte ebx+01h]
        mov byte [byte esp+04h], al
.9:
        mov eax, dword [nosplit ecx*4+TimbreBanks]
        mov edx, dword [byte esp+04h]
        call FindSoundChunk
        mov dword [byte ebx+010h], eax
        test eax, eax
        je short .12
        xor eax, eax
        mov ebp, dword [sndhandlecount]
        jmp short .11
.10:
        mov cl, byte [byte ebx+0Fh]
        cmp cl, byte [dword eax+SndHandleType]
        je near .3
        inc eax
.11:
        cmp eax, ebp
        jl short .10
        jmp short .13
.12:
        inc ecx
        cmp ecx, byte 0Ah
        jl near .7
.13:
        mov ebx, dword [esp]
        inc ebx
        mov dword [esp], ebx
        cmp ebx, 100h
        jl near .1
        dec word [ActiveSongCount]
.14:
        add esp, byte 8
        pop ebp
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; GetPatchEntry                                   8F0D7  95 PC, low confidence
; (patch): the patch file entry of a patch number, 0 when none
;-----------------------------------------------------------------------------
GetPatchEntry:
        push ds
        call __GETDS
        mov edx, dword [PatchFile]
        test edx, edx
        jne short .2
.1:
        xor eax, eax
        pop ds
        ret
.2:
        mov ebx, edx
        xor eax, eax
        mov al, byte [byte esp+08h]
        add eax, edx
        cmp byte [byte eax+02h], 0
        je short .1
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
;-----------------------------------------------------------------------------
; GetPatchTimbre                                  8F114  95 PC, low confidence
; (patch): the timbre a patch uses
;-----------------------------------------------------------------------------
GetPatchTimbre:
        push ds
        call __GETDS
        cmp dword [PatchFile], byte 0
        jne short .1
        xor eax, eax
        pop ds
        ret
.1:
        xor eax, eax
        mov al, byte [byte esp+08h]
        push eax
        call GetPatchEntry
        add esp, byte 4
        mov eax, dword [byte eax+010h]
        pop ds
        ret
;-----------------------------------------------------------------------------
; LoadSample                                   8F13B  95 PC, medium confidence
; Sound library: load the sample file at path, returns its handle
;-----------------------------------------------------------------------------
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
        jge short .2
.1:
        xor eax, eax
        jmp near .5
.2:
        mov ecx, eax
        shl ecx, 2
        sub ecx, eax
        mov eax, ecx
        shl eax, 3
        mov ecx, 6
        lea edi, [dword eax+SampleTable]
        mov esi, DefaultSampleInfo
        rep movsd
        mov ecx, SampleTable
        add ecx, eax
        mov edx, dword [SampleChunkSize]
        inc edx
        mov dword [SampleChunkSize], edx
        cmp edx, 200h
        ja short .3
        mov dword [SampleChunkSize], 200h
.3:
        mov eax, dword [SampleChunkSize]
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
        je short .5
        mov ebx, esp
        mov edx, str_CFG2
        mov eax, ebp
        call ReplaceFileExt
        mov edx, esp
        mov eax, 6
        call SndLoadFile
        mov dword [byte ecx+08h], eax
        test eax, eax
        jne short .4
        lea eax, [byte ecx+04h]
        call FreeMemPtr
        jmp near .1
.4:
        mov eax, dword [ecx]
.5:
        add esp, byte 10h
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; FreeSample                                   8F1FE  95 PC, medium confidence
; Sound library: free a sample loaded by LoadSample
;-----------------------------------------------------------------------------
FreeSample:
        push ebx
        push edx
        mov edx, eax
        cmp eax, 200h
        jb short .1
        call StopSongId
        mov eax, edx
        call FindSongSlot
        test eax, eax
        jl short .1
        mov edx, eax
        shl eax, 2
        sub eax, edx
        mov edx, eax
        shl edx, 3
        mov ebx, SampleTable
        add ebx, edx
        lea eax, [byte ebx+04h]
        call FreeMemPtr
        lea eax, [byte ebx+08h]
        call FreeMemPtr
        xor ebx, ebx
        mov dword [dword edx+SampleTable], ebx
.1:
        pop edx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; FindSongSlot                                    8F247  95 PC, low confidence
; The song table slot (0-12) that holds a song id, -1 when none
;-----------------------------------------------------------------------------
FindSongSlot:
        push ecx
        push edx
        mov ecx, eax
        xor edx, edx
.1:
        mov eax, edx
        shl eax, 2
        sub eax, edx
        cmp ecx, dword [nosplit eax*8+SampleTable]
        jne short .2
        mov eax, edx
        pop edx
        pop ecx
        ret
.2:
        inc edx
        cmp edx, byte 0Dh
        jl short .1
        mov eax, 0FFFFFFFFh
        pop edx
        pop ecx
        ret
;-----------------------------------------------------------------------------
; PlaySong                                        8F270  95 PC, low confidence
; Starts a loaded song once
;-----------------------------------------------------------------------------
PlaySong:
        push ebx
        xor ebx, ebx
        call StartSong
        pop ebx
        ret
;-----------------------------------------------------------------------------
; StartSongTracks                                 8F27A  95 PC, low confidence
; Body of StartSong: gives each track of the song a free track slot and MIDI
; channel and starts it
;-----------------------------------------------------------------------------
StartSongTracks:
        mov ebx, eax
        shl eax, 2
        sub eax, ebx
        shl eax, 3
        mov ebx, SampleTable
        add ebx, eax
        mov dword [byte esp+010h], ebx
        mov eax, edx
        call SndDriverHandle
        mov dword [byte esp+018h], eax
        test eax, eax
        jl near StartSong+016h
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
        inc word [ActiveSongCount]
.1:
        cmp byte [byte esp+020h], 0
        je near .6
        call FindFreeTrack
        mov esi, eax
        mov edi, eax
        test eax, eax
        jne short .2
        mov dword [byte esp+04h], eax
        jmp near .6
.2:
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
        je near .4
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
        jne short .3
        xor edi, esi
        mov dword [byte esp+04h], edi
        jmp near .6
.3:
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
        call SeqSendProgram
        xor ebx, ebx
        mov edx, 1
        mov eax, esi
        call SeqSendController
        xor ebx, ebx
        mov bl, byte [byte ecx+06h]
        mov edx, 7
        mov eax, esi
        call SeqSendController
        xor ebx, ebx
        mov bl, byte [byte ecx+07h]
        mov edx, 0Ah
        mov eax, esi
        call SeqSendController
        mov edx, 4000h
        mov eax, esi
        call SeqSendPitchBend
.4:
        mov byte [byte edi+01h], 1
        cmp dword [esp], byte 0
        jle short .5
        or byte [byte edi+01h], 8
        mov edx, dword [byte edi+06h]
        mov word [byte edx+0Eh], 0FFFFh
        mov ecx, dword [byte edi+06h]
        mov al, byte [byte ecx+011h]
        mov byte [byte ecx+010h], al
.5:
        dec byte [byte esp+020h]
        inc byte [byte esp+028h]
        jmp near .1
.6:
        mov eax, dword [byte esp+04h]
        dec word [ActiveSongCount]
        add esp, byte 2Ch
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
;-----------------------------------------------------------------------------
; FindFreeTrack                                   8F433  95 PC, low confidence
; The first unused track slot of the 24, 0 when none
;-----------------------------------------------------------------------------
FindFreeTrack:
        push edx
        mov eax, SeqTracks
        xor edx, edx
        jmp short .2
.1:
        cmp byte [byte eax+01h], 0
        je short .3
        add eax, byte 54h
        inc edx
.2:
        cmp dx, byte 18h
        jl short .1
        xor eax, eax
.3:
        pop edx
        ret
;-----------------------------------------------------------------------------
; FindFreeMidiChannel                             8F451  95 PC, low confidence
; The first free MIDI channel of the 16 that a mask allows, -1 when none
;-----------------------------------------------------------------------------
FindFreeMidiChannel:
        push ebx
        push ecx
        push edx
        push esi
        mov esi, eax
        xor eax, eax
        jmp short .3
.1:
        movsx edx, ax
        mov bx, word [nosplit edx*2+MidiChannelBits]
        and ebx, 0FFFFh
        xor ecx, ecx
        mov cx, si
        test ecx, ebx
        je short .2
        cmp byte [dword edx+MidiChannelUsed], 0
        je short .4
.2:
        inc eax
.3:
        cmp ax, 10h
        jl short .1
        mov eax, 0FFFFFFFFh
.4:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; LoadAndPlaySong                                 8F48F  95 PC, low confidence
; Loads a song and starts it
;-----------------------------------------------------------------------------
LoadAndPlaySong:
        push ebx
        call LoadSample
        test eax, eax
        je short .1
        xor ebx, ebx
        call StartSong
.1:
        pop ebx
        ret
        call LoadSample
;-----------------------------------------------------------------------------
; StartSong                                       8F4A7  95 PC, low confidence
; (song, loops): starts a loaded song through StartSongTracks
;-----------------------------------------------------------------------------
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
        xor eax, eax
        jmp near StartSongTracks+01B1h
;-----------------------------------------------------------------------------
; PlayPatch                                       8F4C4  95 PC, low confidence
; Plays a patch as a sound effect note on the MIDI driver
;-----------------------------------------------------------------------------
PlayPatch:
        push ecx
        push esi
        push edi
        sub esp, byte 8
        push eax
        mov esi, edx
        mov byte [byte esp+08h], bl
        cmp ax, 100h
        jb short .2
.1:
        mov eax, 0FFFFFFFFh
        jmp near .8
.2:
        cmp dword [MidiSfxEnabled], byte 0
        jne short .3
        xor eax, eax
        jmp near .8
.3:
        xor eax, eax
        mov al, byte [esp]
        push eax
        call GetPatchEntry
        add esp, byte 4
        test eax, eax
        je short .1
        mov dl, byte [byte eax+0Fh]
        and dl, 7Fh
        test esi, esi
        jne short .5
        mov dh, byte [byte eax+0Eh]
        test dh, dh
        je short .4
        mov al, dh
        and eax, 0FFh
        mov esi, eax
        shl esi, 2
        sub esi, eax
        add esi, esi
        jmp short .5
.4:
        mov esi, 0A0h
.5:
        mov ecx, MidiOutQueue
        mov ebx, dword [MidiTickCount]
        add ecx, ebx
        lea edi, [byte ebx+04h]
        mov dword [MidiTickCount], edi
        mov ebx, dword [esp]
        cmp bx, 80h
        jb short .6
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
        call SeqQueueCommand
        push dword 0FFh
        push dword 0FFh
        push edi
        xor eax, eax
        mov al, byte [byte esp+0Ch]
        mov ecx, 9
        mov ebx, esi
        mov edx, 7Fh
        jmp short .7
.6:
        mov eax, dword [PlayPatchHandle]
        add eax, byte 0Ch
        mov dword [byte esp+04h], eax
        mov eax, dword [PlayPatchHandle]
        inc eax
        and eax, byte 3
        mov dword [PlayPatchHandle], eax
        mov al, byte [byte esp+04h]
        or al, 0C0h
        mov byte [ecx], al
        mov al, byte [esp]
        mov byte [byte ecx+01h], al
        movzx edi, dl
        mov ebx, ecx
        mov edx, 2
        mov eax, edi
        call SeqQueueCommand
        mov al, byte [byte esp+04h]
        or al, 0B0h
        mov byte [ecx], al
        mov byte [byte ecx+01h], 7
        mov al, byte [byte esp+08h]
        mov byte [byte ecx+02h], al
        mov ebx, ecx
        mov edx, 3
        mov eax, edi
        call SeqQueueCommand
        push dword 0FFh
        push dword 0FFh
        push edi
        xor ecx, ecx
        mov cl, byte [byte esp+010h]
        mov ebx, esi
        mov edx, 7Fh
        mov eax, 24h
.7:
        call SeqNoteOn
        cwde
        sub dword [MidiTickCount], byte 4
.8:
        add esp, byte 0Ch
        pop edi
        pop esi
        pop ecx
        ret
;-----------------------------------------------------------------------------
; PlayPatchFull                                   8F61D  95 PC, low confidence
; Plays a patch at full volume
;-----------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------
; ReleaseAllVoices                                8F633  95 PC, low confidence
; Marks every playing patch voice for release
;-----------------------------------------------------------------------------
ReleaseAllVoices:
        push ebx
        push ecx
        push edx
        cmp dword [MidiSfxEnabled], byte 0
        je short .4
        xor edx, edx
        inc word [ActiveSongCount]
        mov ecx, 1
        jmp short .3
.1:
        movsx ebx, dx
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 2
        cmp dword [dword eax+SongRecords], byte 0
        je short .2
        mov dword [dword eax+SongRelease], ecx
.2:
        inc edx
.3:
        cmp dx, byte 20h
        jl short .1
        dec word [ActiveSongCount]
.4:
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; StopSongId                                      8F67D  95 PC, low confidence
; Stops a patch voice or every track of a song, all notes off
;-----------------------------------------------------------------------------
StopSongId:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov ebp, eax
        cmp eax, byte 0FFFFFFFFh
        jne short .1
        mov eax, 0FFFFFFFFh
        jmp near LoadSample+0BCh
.1:
        inc word [ActiveSongCount]
        cmp eax, 100h
        jae short .4
        cmp dword [MidiSfxEnabled], byte 0
        jne short .2
        xor eax, eax
        jmp near LoadSample+0BCh
.2:
        shl eax, 2
        sub eax, ebp
        shl eax, 2
        cmp dword [dword eax+SongRelease], byte 0
        je short .3
        mov dword [dword eax+SongRelease], 1
.3:
        xor eax, eax
        jmp near .11
.4:
        mov ecx, SongRecords
        mov esi, SeqTracks
        xor edi, edi
        jmp short .7
.5:
        cmp ebp, dword [ecx]
        jne short .6
        mov eax, ecx
        call SeqNoteOffSlot
.6:
        add ecx, byte 0Ch
        inc edi
.7:
        cmp di, byte 20h
        jl short .5
        mov ecx, MidiOutQueue
        add ecx, dword [MidiTickCount]
        xor edi, edi
        add dword [MidiTickCount], byte 4
        jmp short .10
.8:
        cmp ebp, dword [byte esi+02h]
        jne short .9
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
        call SeqQueueCommand
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
        call SeqQueueCommand
        mov byte [byte esi+01h], 0
        mov dword [byte esi+02h], 0
.9:
        add esi, byte 54h
        inc edi
.10:
        cmp di, byte 18h
        jl short .8
        mov byte [ecx], 0B9h
        mov byte [byte ecx+01h], 7
        mov byte [byte ecx+02h], 7Fh
        mov al, byte [SeqTracks+0345h]
        and al, 7Fh
        and eax, 0FFh
        mov ebx, ecx
        mov edx, 3
        call SeqQueueCommand
        call SeqUpdate
        xor eax, eax
        sub dword [MidiTickCount], byte 4
.11:
        dec word [ActiveSongCount]
        jmp near LoadSample+0BCh
;-----------------------------------------------------------------------------
; ReleaseSong                                     8F7AE  95 PC, low confidence
; (song, fade): sets the release count of a song's tracks
;-----------------------------------------------------------------------------
ReleaseSong:
        push ebx
        push ecx
        push esi
        push edi
        mov esi, eax
        mov edi, edx
        mov eax, SeqTracks
        xor ebx, ebx
        inc word [ActiveSongCount]
        jmp short .3
.1:
        cmp esi, dword [byte eax+02h]
        jne short .2
        mov dl, byte [byte eax+01h]
        test dl, dl
        je short .2
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
.2:
        add eax, byte 54h
        inc ebx
.3:
        cmp bx, byte 18h
        jl short .1
        dec word [ActiveSongCount]
        xor eax, eax
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; SongFinished                                    8F80E  95 PC, low confidence
; 1 when no track of the song is playing
;-----------------------------------------------------------------------------
SongFinished:
        push ebx
        push edx
        mov ebx, eax
        cmp dword [sndhandlecount], byte 0
        je short .4
        mov eax, SeqTracks
        xor edx, edx
        jmp short .3
.1:
        cmp ebx, dword [byte eax+02h]
        jne short .2
        cmp byte [byte eax+01h], 0
        je short .2
        xor eax, eax
        pop edx
        pop ebx
        ret
.2:
        add eax, byte 54h
        inc edx
.3:
        cmp dx, byte 18h
        jl short .1
.4:
        mov eax, 1
        pop edx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; SongReleased                                    8F846  95 PC, low confidence
; 1 when no track of the song is in its release
;-----------------------------------------------------------------------------
SongReleased:
        push ebx
        push edx
        mov ebx, eax
        cmp dword [sndhandlecount], byte 0
        je short .4
        mov eax, SeqTracks
        xor edx, edx
        jmp short .3
.1:
        cmp ebx, dword [byte eax+02h]
        jne short .2
        test byte [byte eax+01h], 8
        je short .2
        xor eax, eax
        pop edx
        pop ebx
        ret
.2:
        add eax, byte 54h
        inc edx
.3:
        cmp dx, byte 18h
        jl short .1
.4:
        mov eax, 1
        pop edx
        pop ebx
        ret
        push ebx
        push ecx
        mov ecx, eax
        mov bl, dl
        mov eax, SeqTracks
        xor edx, edx
        jmp short .7
.5:
        cmp ecx, dword [byte eax+02h]
        jne short .6
        mov bh, byte [byte eax+050h]
        cmp bl, bh
        jne short .6
        cmp bh, bh
        jne short .6
        mov al, byte [byte eax+04Eh]
        xor ah, ah
        pop ecx
        pop ebx
        ret
.6:
        add eax, byte 54h
        inc edx
.7:
        cmp dx, byte 18h
        jl short .5
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
        mov ecx, MidiOutQueue
        mov edx, dword [MidiTickCount]
        add ecx, edx
        mov esi, SeqTracks
        mov dword [SongReleasedFlag], 1
        xor edi, edi
        lea ebp, [byte edx+04h]
        mov dword [MidiTickCount], ebp
        jmp short .10
.8:
        cmp byte [byte esi+01h], 0
        je short .9
        mov al, byte [byte esi+050h]
        or al, 0B0h
        mov byte [ecx], al
        mov byte [byte ecx+01h], 7
        mov byte [byte ecx+02h], 0
        mov ebx, ecx
        mov edx, 3
        xor eax, eax
        call SeqQueueCommand
.9:
        inc edi
.10:
        cmp di, byte 18h
        jl short .8
        sub dword [MidiTickCount], byte 4
        jmp near LoadSample+0BCh
        push ebx
        push ecx
        push edx
        push esi
        mov ecx, SeqTracks
        xor esi, esi
        jmp short .13
.11:
        cmp byte [byte ecx+01h], 0
        je short .12
        xor edx, edx
        mov dl, byte [byte ecx+050h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        xor ebx, ebx
        mov bl, byte [dword eax+MidiChanVolume]
        mov edx, 7
        mov eax, ecx
        call SeqSendController
.12:
        inc esi
.13:
        cmp si, byte 18h
        jl short .11
        xor edx, edx
        mov dword [SongReleasedFlag], edx
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; EnableMidiSfx                                   8F963  95 PC, low confidence
; Lets patches play as sound effects
;-----------------------------------------------------------------------------
EnableMidiSfx:
        mov dword [MidiSfxEnabled], 1
        ret
;-----------------------------------------------------------------------------
; DisableMidiSfx                                  8F96E  95 PC, low confidence
; Stops patches playing as sound effects
;-----------------------------------------------------------------------------
DisableMidiSfx:
        push edx
        xor edx, edx
        mov dword [MidiSfxEnabled], edx
        pop edx
        ret
;-----------------------------------------------------------------------------
; EnableMidiMusic                                 8F979  95 PC, low confidence
; Lets the song tracks play notes
;-----------------------------------------------------------------------------
EnableMidiMusic:
        mov dword [MidiMusicEnabled], 1
        ret
;-----------------------------------------------------------------------------
; DisableMidiMusic                                8F984  95 PC, low confidence
; Stops the song tracks playing notes
;-----------------------------------------------------------------------------
DisableMidiMusic:
        push edx
        xor edx, edx
        mov dword [MidiMusicEnabled], edx
        pop edx
        ret
;-----------------------------------------------------------------------------
; LoadDigiFile                                    8F98F  95 PC, low confidence
; Loads a digital sound file, reads its header (RIFF or EA) and decodes the
; samples
;-----------------------------------------------------------------------------
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
        je near .7
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
        jne short .2
        lea ebx, [byte eax+04h]
        mov edx, str_VHDR
        mov eax, ebx
        call FindSubstring
        mov esi, eax
        test eax, eax
        jge short .1
        lea eax, [byte esp+054h]
        call ReleaseMemPtr
        xor eax, eax
        jmp near .7
.1:
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
        jmp short .3
.2:
        cmp edx, 46464952h
        jne short .3
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
.3:
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
        call ResizeMemHandleUnlocked
        add esp, byte 8
        lea esi, [byte esp+044h]
        movsd
        movsd
        movsd
        movsd
        cmp byte [byte esp+058h], 0
        je short .6
        mov eax, ebp
        xor edx, edx
        jmp short .5
.4:
        mov bl, byte [byte esp+058h]
        xor byte [eax], bl
        inc eax
        inc edx
.5:
        cmp edx, dword [byte esp+048h]
        jb short .4
.6:
        mov eax, dword [byte esp+054h]
.7:
        add esp, byte 5Ch
        jmp near LoadSample+0BCh
;-----------------------------------------------------------------------------
; FindSubstring                                   8FAF2  95 PC, low confidence
; The position just after the first match of a string inside another
;-----------------------------------------------------------------------------
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
.1:
        mov cl, byte [ebx]
        cmp cl, byte [edi+eax]
        jne short .2
        inc eax
        cmp eax, ebp
        je short .4
        jmp short .3
.2:
        xor eax, eax
.3:
        inc ebx
        inc esi
        jmp short .1
.4:
        lea eax, [byte esi+01h]
        jmp near LoadTimbreFile+0FBh
;-----------------------------------------------------------------------------
; PlayDigiBlock                                   8FB24  95 PC, low confidence
; Plays a loaded digital sample on a driver channel
;-----------------------------------------------------------------------------
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
        je short PlayDigiBlock+063h
        call SndDriverHandle
        mov dword [esp], eax
        test eax, eax
        jl short PlayDigiBlock+063h
        push edi
        call MemDescPtr
        add esp, byte 4
        mov edi, esi
        mov edx, edi
        shl edx, 2
        add edx, edi
        xor ebx, ebx
        mov dword [nosplit edx*4+DigiFadeLevel], ebx
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
        movzx edi, byte [byte esp+018h]
        mov ecx, 10h
        mov ebx, eax
        mov edx, esi
        mov eax, edi
        call SndHandlePlayDigi
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        ret
;-----------------------------------------------------------------------------
; PlayDigiBlockLoop                               8FB8E  95 PC, low confidence
; Plays a loaded digital sample on a driver channel, looping
;-----------------------------------------------------------------------------
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
        je short PlayDigiBlock+063h
        call SndDriverHandle
        mov dword [esp], eax
        test eax, eax
        jl short PlayDigiBlock+063h
        push edi
        call MemDescPtr
        add esp, byte 4
        mov edi, esi
        mov edx, edi
        shl edx, 2
        add edx, edi
        xor ebx, ebx
        mov dword [nosplit edx*4+DigiFadeLevel], ebx
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
        jmp short PlayDigiBlock+04Eh
;-----------------------------------------------------------------------------
; PlayDigiPtr                                     8FBE5  95 PC, low confidence
; Plays digital sample data at a pointer on a driver channel
;-----------------------------------------------------------------------------
PlayDigiPtr:
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov esi, eax
        mov eax, edx
        mov edx, ebx
        test esi, esi
        je short .1
        call SndDriverHandle
        mov dword [esp], eax
        test eax, eax
        jl short .1
        mov eax, ebx
        shl eax, 2
        add eax, ebx
        xor ebx, ebx
        mov dword [nosplit eax*4+DigiFadeLevel], ebx
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
.1:
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        ret 8
;-----------------------------------------------------------------------------
; PlayDigiPtrLoop                                 8FC37  95 PC, low confidence
; Plays digital sample data at a pointer on a driver channel, looping
;-----------------------------------------------------------------------------
PlayDigiPtrLoop:
        push esi
        push edi
        push ebp
        mov esi, eax
        mov eax, edx
        mov edi, ebx
        mov edx, ecx
        test esi, esi
        je short PlayDigiPtr+04Ch
        call SndDriverHandle
        mov ecx, eax
        test eax, eax
        jl short PlayDigiPtr+04Ch
        mov eax, ebx
        shl eax, 2
        add eax, ebx
        xor ebx, ebx
        mov dword [nosplit eax*4+DigiFadeLevel], ebx
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
        jmp short PlayDigiPtr+04Ch
;-----------------------------------------------------------------------------
; SndQuery                                     8FC8A  95 PC, medium confidence
; EA sound library: query a sound handle (handle, what); what 3 = has its
; digital music finished
;-----------------------------------------------------------------------------
SndQuery:
        cmp eax, dword [sndhandlecount]
        jge short .1
        test eax, eax
        jge short .2
.1:
        mov eax, 0FFFFFFFFh
        ret
.2:
        shl edx, 10h
        add edx, byte 9
        and eax, 0FFh
        jmp near SndDriverCall
;-----------------------------------------------------------------------------
; StopDigiChannel                                 8FCAC  95 PC, low confidence
; Stops a digital channel of a driver
;-----------------------------------------------------------------------------
StopDigiChannel:
        push ebx
        push ecx
        call SndDriverHandle
        mov ecx, eax
        test eax, eax
        jl short .1
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
.1:
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; SetDigiChannelVolume                            8FCDF  95 PC, low confidence
; (handle, channel, volume): sets the volume of a digital channel, stops it
; at 0
;-----------------------------------------------------------------------------
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
        jne short .1
        call StopDigiChannel
        jmp short .2
.1:
        call SndDriverHandle
        mov edi, eax
        test eax, eax
        jl short .2
        shl edx, 10h
        add edx, byte 0Ah
        and eax, 0FFh
        call SndDriverCall
        mov ebp, eax
        shl eax, 18h
        mov ebx, esi
        shl ebx, 2
        add ebx, esi
        mov dword [nosplit ebx*4+DigiFadeAccum], eax
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
        mov dword [nosplit ebx*4+DigiFadeStep], eax
        mov dword [nosplit ebx*4+DigiFadeLevel], ebp
        mov dword [nosplit ebx*4+DigiFadeChannel], ecx
        mov dword [nosplit ebx*4+DigiFadeDriver], edi
.2:
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
;-----------------------------------------------------------------------------
; QueryDigiChannel                                8FD67  95 PC, low confidence
; Driver function 33h for a channel
;-----------------------------------------------------------------------------
QueryDigiChannel:
        push ebx
        call SndDriverHandle
        mov ebx, eax
        test eax, eax
        jl short .1
        shl edx, 10h
        add edx, byte 33h
        xor eax, eax
        mov al, bl
        call SndDriverCall
.1:
        pop ebx
        ret
;-----------------------------------------------------------------------------
; MidiProgramChange                            8FD84  95 PC, medium confidence
; Sends a MIDI program change
;-----------------------------------------------------------------------------
MidiProgramChange:
        sub esp, byte 4
        cmp eax, dword [sndhandlecount]
        jge short .1
        test eax, eax
        jl short .1
        or dl, 0C0h
        mov byte [esp], dl
        mov byte [byte esp+01h], bl
        and eax, 0FFh
        mov ebx, esp
        mov edx, 2
        call SeqQueueCommand
.1:
        add esp, byte 4
        ret
;-----------------------------------------------------------------------------
; MidiSetVolume                                8FDB2  95 PC, medium confidence
; Sends a MIDI channel volume controller
;-----------------------------------------------------------------------------
MidiSetVolume:
        sub esp, byte 4
        cmp eax, dword [sndhandlecount]
        jge short .1
        test eax, eax
        jl short .1
        or dl, 0B0h
        mov byte [esp], dl
        mov byte [byte esp+01h], 7
        mov byte [byte esp+02h], bl
        and eax, 0FFh
        mov ebx, esp
        mov edx, 3
        call SeqQueueCommand
.1:
        add esp, byte 4
        ret
;-----------------------------------------------------------------------------
; MidiPitchBend                                8FDE5  95 PC, medium confidence
; Sends a MIDI pitch bend
;-----------------------------------------------------------------------------
MidiPitchBend:
        sub esp, byte 4
        cmp eax, dword [sndhandlecount]
        jge short .1
        test eax, eax
        jl short .1
        or dl, 0E0h
        mov byte [esp], dl
        xor ah, ah
        mov byte [byte esp+01h], ah
        and bl, 7Fh
        mov byte [byte esp+02h], bl
        and eax, 0FFh
        mov ebx, esp
        mov edx, 3
        call SeqQueueCommand
.1:
        add esp, byte 4
        ret
;-----------------------------------------------------------------------------
; MidiNoteOn                                   8FE1C  95 PC, medium confidence
; Sends a MIDI note on at full velocity
;-----------------------------------------------------------------------------
MidiNoteOn:
        sub esp, byte 4
        cmp eax, dword [sndhandlecount]
        jge short .1
        test eax, eax
        jl short .1
        or dl, 90h
        mov byte [esp], dl
        mov byte [byte esp+01h], bl
        mov byte [byte esp+02h], 7Fh
        and eax, 0FFh
        mov ebx, esp
        mov edx, 3
        call SeqQueueCommand
.1:
        add esp, byte 4
        ret
;-----------------------------------------------------------------------------
; MidiNoteOff                                  8FE4F  95 PC, medium confidence
; Sends a MIDI note off
;-----------------------------------------------------------------------------
MidiNoteOff:
        sub esp, byte 4
        cmp eax, dword [sndhandlecount]
        jge short .1
        test eax, eax
        jl short .1
        or dl, 80h
        mov byte [esp], dl
        mov byte [byte esp+01h], bl
        xor ah, ah
        mov byte [byte esp+02h], ah
        and eax, 0FFh
        mov ebx, esp
        mov edx, 3
        call SeqQueueCommand
.1:
        add esp, byte 4
        ret
;-----------------------------------------------------------------------------
; SetSoundByteOrder                               8FE83  95 PC, low confidence
; Sets the byte order flag of the sound files
;-----------------------------------------------------------------------------
SetSoundByteOrder:
        mov byte [SndBigEndian], al
        ret
;-----------------------------------------------------------------------------
; FindSoundChunk                                  8FE89  95 PC, low confidence
; Finds a chunk by id in a sound bank's directory
;-----------------------------------------------------------------------------
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
        jmp short .3
.1:
        cmp esi, dword [eax]
        jne short .2
        mov eax, edx
        mov eax, dword [byte ebp+eax*4+00h]
        add eax, edi
        jmp near LoadTimbreFile+0FBh
.2:
        inc edx
        add eax, byte 4
.3:
        xor ecx, ecx
        mov cx, word [ebx]
        cmp edx, ecx
        jl short .1
        xor eax, eax
        jmp near LoadTimbreFile+0FBh
;-----------------------------------------------------------------------------
; ReplaceFileExt                               8FED2  95 PC, medium confidence
; Builds a file name with another extension (splitpath and makepath)
;-----------------------------------------------------------------------------
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
        mov ebx, str_EmptyExt
        mov edx, ebx
        mov eax, esi
        call _makepath_
        add esp, 0B0h
        pop edi
        pop esi
        pop ecx
        ret
;-----------------------------------------------------------------------------
; FreeMemPtr                                   8FF1E  95 PC, medium confidence
; Frees the memory block a pointer variable holds and clears it
;-----------------------------------------------------------------------------
FreeMemPtr:
        push ebx
        push ecx
        push edx
        push esi
        mov esi, eax
        mov edx, dword [eax]
        test edx, edx
        je short .1
        push edx
        call FreeMemBlock
        add esp, byte 4
        mov dword [esi], 0
.1:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; ReleaseMemPtr                                   8FF3E  95 PC, low confidence
; Releases the memory descriptor a pointer variable holds and clears it
;-----------------------------------------------------------------------------
ReleaseMemPtr:
        push ebx
        push ecx
        push edx
        push esi
        mov esi, eax
        mov edx, dword [eax]
        test edx, edx
        je short .1
        push edx
        call PushMemDescriptorLocked
        add esp, byte 4
        mov dword [esi], 0
.1:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; SwapBytes16                                  8FF5E  95 PC, medium confidence
; Swaps the two bytes of a word
;-----------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------
; SwapBytes32                                  8FF7C  95 PC, medium confidence
; Reverses the four bytes of a dword
;-----------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------
; SetPalette                                   8FFB0  95 PC, medium confidence
; Graphics library: set palette colours (first, count, rgb)
;-----------------------------------------------------------------------------
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
.1:
        in al, dx
        stosb
        loop .1
        pop edi
        leave
        ret
        db 00h,00h
