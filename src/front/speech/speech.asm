; Speech engine: sample slots, the speech bank, sample memory (PC only).
bits 32
%include "hockey.inc"
section s_832BC progbits alloc exec nowrite align=1
extern __CHK, __CHP, __STOSD, _dos_close_, _dos_open_, _dos_read_, _fmemmove_, _os_handle_3
extern addtimer, AllocMemBlock, SpeechInitMode, cursndbank, FreeClip_ret, FreeMemBlock, lseek_, musichandle
extern F64_BankPercent, F64_BankRate5512, F64_BankRate11025, F64_SlotPercent, F64_SlotRate11025, RemoveTimerCallback, samplereq, SayNhlIntro
extern speechbank, speechchannel, speechcopybuf, speechcopylen, speechinit, speechq, str_SampleMemMan, str_Sentence
extern str_SpeechBank, str_Speechbuf, strncpy_, AllocMemHandleLocked, PushMemDescriptorLocked, MemDescPtr, PlayDigiPtr, PlayDigiPtrLoop
extern StopDigiChannel, UnpackTo
global SpeechTimerTick, ClearSpeechSlot, ResetSpeechQueue, InitSpeechSlots, ResetSampleReq, InitSpeech, ShutdownSpeech, ShutdownSpeech_ret6
global ShutdownSpeech_ret5, SpeechIsInit, SpeechBusy, SpeechIdle, MusicChanReset2, SpeechStopQueue, MusicChanCmd3, MusicChanReset
global Swap16, ReadBE24, ReadBE24_ret, ReadCString, OpenSpeechBank, OpenSpeechBank_ret, SpeechSlotSize, ReadSpeechSample
global LoadSpeechSlot, PlaceSpeechSlot, StrEqNoCase, FindFreeSpeechSlot, FindLoadedSpeechSlot, FindSpeechSlot, SpeechSlotLoaded, IsSampleRequested
global RequestSample, FreeUnrequestedSamples, MoveSampleMem, CompactSpeechSlot, MakeSampleRoom, EnsureSampleRoom, CompactSpeechMem
;-----------------------------------------------------------------------------
; SpeechTimerTick                              832BC  95 PC, medium confidence
; Timer callback installed by InitSpeech (addtimer): counts down and starts
; next queued speech sample
;-----------------------------------------------------------------------------
; C: src/front/speech/ShutdownSpeech.c (SpeechTimerTick)
%ifdef CBUILD
%include "c/front/speech/ShutdownSpeech.SpeechTimerTick.inc"
%else
SpeechTimerTick:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        cmp dword [speechinit], byte 0
        je near ShutdownSpeech_ret5
        mov eax, dword [speechq]
        mov ebx, dword [byte eax+05Ch]
        test ebx, ebx
        je short .1
        lea ecx, [byte ebx-01h]
        mov dword [byte eax+05Ch], ecx
.1:
        mov eax, dword [speechq]
        cmp dword [byte eax+060h], byte 0
        je near ShutdownSpeech_ret5
        mov edi, dword [byte eax+050h]
        test edi, edi
        je short .2
        lea ecx, [byte edi-01h]
        mov dword [byte eax+050h], ecx
        jmp near ShutdownSpeech_ret5
.2:
        mov ecx, dword [byte eax+058h]
        lea edx, [byte ecx+01h]
        mov dword [byte eax+058h], edx
        mov edx, dword [speechq]
        cmp ecx, dword [byte edx+054h]
        jge near .5
        mov eax, ecx
        mov ecx, dword [edx+eax*4]
        cmp ecx, byte 0FFFFFFFFh
        jne short .3
        mov dword [byte edx+060h], edi
        jmp near ShutdownSpeech_ret5
.3:
        mov eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 2
        sub eax, ecx
        add eax, eax
        mov ebx, dword [speechbank]
        add eax, ebx
        mov esi, dword [byte eax+0Eh]
        mov ecx, dword [byte eax+016h]
        mov ebx, dword [byte eax+01Eh]
        mov dword [byte edx+050h], ebx
        mov edx, dword [speechchannel]
        inc edx
        mov dword [speechchannel], edx
        mov ebx, edx
        and ebx, byte 1
        mov dword [speechchannel], ebx
        cmp byte [byte eax+0Dh], 47h
        jne short .4
        push byte 7Fh
        push dword 2B11h
        mov edx, dword [musichandle]
        mov eax, esi
        call PlayDigiPtr
        jmp near ShutdownSpeech_ret5
.4:
        add ecx, ecx
        push byte 7Fh
        push dword 2B11h
        mov edx, dword [musichandle]
        mov eax, esi
        call PlayDigiPtrLoop
        jmp near ShutdownSpeech_ret5
.5:
        mov dword [byte edx+060h], edi
        mov eax, dword [speechbank]
        mov edx, dword [speechq]
        mov eax, dword [dword eax+03B70h]
        mov dword [byte edx+05Ch], eax
        jmp near ShutdownSpeech_ret5
%endif ; C
;-----------------------------------------------------------------------------
; ClearSpeechSlot                              833C5  95 PC, medium confidence
; Zeroes fields 0,0Dh,0Eh..22h of a speech slot struct
;-----------------------------------------------------------------------------
; C: src/front/speech/ClearSpeechSlot.c
%ifdef CBUILD
%include "c/front/speech/ClearSpeechSlot.inc"
%else
ClearSpeechSlot:
        push dword 4
        call __CHK
        mov byte [eax], 0
        mov byte [byte eax+0Dh], 0
        mov dword [byte eax+0Eh], 0
        mov dword [byte eax+012h], 0
        mov dword [byte eax+016h], 0
        mov dword [byte eax+01Eh], 0
        mov dword [byte eax+022h], 0
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ResetSpeechQueue                             833FA  95 PC, medium confidence
; Fills 20 queue entries with -1 and clears counters +50h..+60h
;-----------------------------------------------------------------------------
; C: src/front/speech/ResetSpeechQueue.c
%ifdef CBUILD
%include "c/front/speech/ResetSpeechQueue.inc"
%else
ResetSpeechQueue:
        push dword 0Ch
        call __CHK
        push ecx
        push edx
        mov eax, dword [speechq]
        mov dword [byte eax+060h], 0
        mov eax, dword [speechq]
        mov ecx, 14h
        mov edx, 0FFFFFFFFh
        call __STOSD
        mov eax, dword [speechq]
        mov dword [byte eax+054h], 0
        mov eax, dword [speechq]
        mov dword [byte eax+058h], 0
        mov eax, dword [speechq]
        mov dword [byte eax+050h], 0
        mov eax, dword [speechq]
        mov dword [byte eax+05Ch], 0
        pop edx
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; InitSpeechSlots                              83459  95 PC, medium confidence
; Clears 400 38-byte slots in speechbank, sets mem limit (arg-1388h), allocs
; 'speechbuf'
;-----------------------------------------------------------------------------
; C: src/front/speech/InitSpeechSlots.c
%ifdef CBUILD
%include "c/front/speech/InitSpeechSlots.inc"
%else
InitSpeechSlots:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        mov ecx, eax
        xor edx, edx
.1:
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        mov ebx, dword [speechbank]
        add eax, ebx
        call ClearSpeechSlot
        inc edx
        cmp edx, 190h
        jl short InitSpeechSlots.1
        mov eax, dword [speechbank]
        lea edx, [dword ecx-01388h]
        mov dword [dword eax+03B68h], edx
        mov edx, dword [cursndbank]
        push edx
        push ecx
        push str_Speechbuf
        call AllocMemHandleLocked
        add esp, byte 0Ch
        mov edx, dword [speechbank]
        mov dword [dword edx+03B60h], eax
        mov eax, dword [speechbank]
        mov ebx, dword [dword eax+03B60h]
        push ebx
        call MemDescPtr
        add esp, byte 4
        mov edx, dword [speechbank]
        mov dword [dword edx+03B64h], eax
        mov eax, dword [speechbank]
        mov dword [dword eax+03B6Ch], 0
        mov eax, dword [speechbank]
        mov dword [dword eax+03B74h], 0
        mov eax, dword [speechbank]
        mov dword [dword eax+03B70h], 0
        mov eax, dword [speechbank]
        mov dword [dword eax+03B78h], 0
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ResetSampleReq                               83520  95 PC, medium confidence
; Clears 20 13-byte names and counters +104h..+10Ch of samplereq
;-----------------------------------------------------------------------------
; C: src/front/speech/ResetSampleReq.c
%ifdef CBUILD
%include "c/front/speech/ResetSampleReq.inc"
%else
ResetSampleReq:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        xor edx, edx
.1:
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        lea ebx, [edx+eax]
        mov eax, dword [samplereq]
        mov byte [ebx+eax], 0
        inc edx
        cmp edx, byte 14h
        jl short ResetSampleReq.1
        mov eax, dword [samplereq]
        mov dword [dword eax+010Ch], 0
        mov eax, dword [samplereq]
        mov dword [dword eax+0108h], 0
        mov eax, dword [samplereq]
        mov dword [dword eax+0104h], 0
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; InitSpeech                                   8357A  95 PC, medium confidence
; Allocs 'sentence' queue, 'sample mem man', 'speech bank', InitSpeechSlots,
; installs SpeechTimerTick, sets speechinit
;-----------------------------------------------------------------------------
; C: src/front/speech/InitSpeech.c
%ifdef CBUILD
%include "c/front/speech/InitSpeech.inc"
%else
InitSpeech:
        push dword 1Ch
        call __CHK
        push esi
        push edi
        sub esp, byte 4
        mov byte [esp], al
        mov esi, edx
        call SpeechIsInit
        test eax, eax
        jne near .x
        mov al, byte [esp]
        mov byte [SpeechInitMode], al
        xor edx, edx
        mov dword [speechchannel], edx
        mov dword [speechcopybuf], ebx
        mov dword [speechcopylen], ecx
        mov ebx, dword [cursndbank]
        push ebx
        push byte 64h
        push str_Sentence
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [speechq], eax
        call ResetSpeechQueue
        mov ecx, dword [cursndbank]
        push ecx
        push dword 110h
        push str_SampleMemMan
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [samplereq], eax
        call ResetSampleReq
        mov edi, dword [cursndbank]
        push edi
        push dword 3B93h
        push str_SpeechBank
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [speechbank], eax
        mov eax, esi
        call InitSpeechSlots
        push SpeechTimerTick
        call addtimer
        add esp, byte 4
        mov dword [speechinit], 1
.x:
        add esp, byte 4
        pop edi
        pop esi
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ShutdownSpeech                               8363C  95 PC, medium confidence
; Removes timer callback, closes bank file, frees buffers, clears speechinit;
; called by SetSoundDevice
;-----------------------------------------------------------------------------
; C: src/front/speech/ShutdownSpeech.c
%ifdef CBUILD
%include "c/front/speech/ShutdownSpeech.inc"
%else
ShutdownSpeech:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        cmp dword [speechinit], byte 0
        je short ShutdownSpeech_ret6
        push SpeechTimerTick
        call RemoveTimerCallback
        add esp, byte 4
        mov eax, dword [speechbank]
        cmp dword [dword eax+03B78h], byte 0
        je short .1
        mov eax, dword [dword eax+03B7Ch]
        call _dos_close_
.1:
        mov ecx, dword [speechq]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [speechbank]
        mov esi, dword [dword eax+03B60h]
        push esi
        call PushMemDescriptorLocked
        add esp, byte 4
        mov edi, dword [speechbank]
        push edi
        call FreeMemBlock
        add esp, byte 4
        mov ebp, dword [samplereq]
        push ebp
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        mov dword [speechinit], eax
ShutdownSpeech_ret6:
        pop ebp
ShutdownSpeech_ret5:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SpeechIsInit                                 836CA  95 PC, medium confidence
; Returns speechinit != 0
;-----------------------------------------------------------------------------
; C: src/front/speech/SpeechIsInit.c
%ifdef CBUILD
%include "c/front/speech/SpeechIsInit.inc"
%else
SpeechIsInit:
        push dword 4
        call __CHK
        cmp dword [speechinit], byte 0
        setne al
        and eax, 0FFh
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SpeechBusy                                   836E4  95 PC, medium confidence
; Speechinit and (queue active or delay pending)
;-----------------------------------------------------------------------------
; C: src/front/speech/SpeechBusy.c
%ifdef CBUILD
%include "c/front/speech/SpeechBusy.inc"
%else
SpeechBusy:
        push dword 4
        call __CHK
        cmp dword [speechinit], byte 0
        je short .3
        mov eax, dword [speechq]
        cmp dword [byte eax+060h], byte 0
        je short .2
.1:
        mov eax, 1
        ret
.2:
        cmp dword [byte eax+05Ch], byte 0
        jne short SpeechBusy.1
.3:
        xor eax, eax
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SpeechIdle                                   83711  95 PC, medium confidence
; Speechinit and queue idle
;-----------------------------------------------------------------------------
; C: src/front/speech/SpeechIdle.c
%ifdef CBUILD
%include "c/front/speech/SpeechIdle.inc"
%else
SpeechIdle:
        push dword 4
        call __CHK
        cmp dword [speechinit], byte 0
        jne short .2
.1:
        xor eax, eax
        ret
.2:
        mov eax, dword [speechq]
        cmp dword [byte eax+060h], byte 0
        jne short SpeechIdle.1
        cmp dword [byte eax+05Ch], byte 0
        jne short SpeechIdle.1
        mov eax, 1
        ret
%endif ; C
;-----------------------------------------------------------------------------
; MusicChanReset2                              8373E  95 PC, medium confidence
; Wrapper around MusicChanReset
;-----------------------------------------------------------------------------
; C: src/front/speech/MusicChanReset2.c
%ifdef CBUILD
%include "c/front/speech/MusicChanReset2.inc"
%else
MusicChanReset2:
        push dword 4
        call __CHK
        call MusicChanReset
;-----------------------------------------------------------------------------
; SpeechStopQueue                              8374D  95 PC, medium confidence
; Clears queue active flag, sets hold delay from bank +3B70h
;-----------------------------------------------------------------------------
SpeechStopQueue:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        cmp dword [speechinit], byte 0
        je short .x
        mov eax, dword [speechq]
        mov dword [byte eax+060h], 0
        mov eax, dword [speechq]
        mov ebx, dword [speechbank]
        mov edx, dword [byte eax+050h]
        mov ecx, dword [dword ebx+03B70h]
        add edx, ecx
        mov dword [byte eax+05Ch], edx
.x:
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; MusicChanCmd3                                8378C  95 PC, medium confidence
; StopDigiChannel(musichandle, 3)
;-----------------------------------------------------------------------------
; C: src/front/speech/MusicChanCmd3.c
%ifdef CBUILD
%include "c/front/speech/MusicChanCmd3.inc"
%else
MusicChanCmd3:
        push dword 8
        call __CHK
        push edx
        mov eax, dword [musichandle]
        mov edx, 3
        call StopDigiChannel
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; MusicChanReset                               837A8  95 PC, medium confidence
; When speechinit: StopDigiChannel(musichandle,0) then (musichandle,1)
;-----------------------------------------------------------------------------
; C: src/front/speech/MusicChanReset.c
%ifdef CBUILD
%include "c/front/speech/MusicChanReset.inc"
%else
MusicChanReset:
        push dword 8
        call __CHK
        push edx
        cmp dword [speechinit], byte 0
        je short .x
        mov eax, dword [musichandle]
        xor edx, edx
        call StopDigiChannel
        mov eax, dword [musichandle]
        mov edx, 1
        call StopDigiChannel
.x:
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; Swap16                                       837D9  95 PC, medium confidence
; Byte-swap 16-bit value
;-----------------------------------------------------------------------------
; C: src/front/speech/Swap16.c
%ifdef CBUILD
%include "c/front/speech/Swap16.inc"
%else
Swap16:
        push dword 8
        call __CHK
        push edx
        mov edx, eax
        and edx, 0FFh
        shl edx, 8
        shr eax, 8
        and eax, 0FFh
        or eax, edx
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ReadBE24                                     837FB  95 PC, medium confidence
; Reads three bytes big-endian from a DOS handle
;-----------------------------------------------------------------------------
; C: src/front/speech/ShutdownSpeech.c (ReadBE24)
%ifdef CBUILD
%include "c/front/speech/ShutdownSpeech.ReadBE24.inc"
%else
ReadBE24:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        sub esp, byte 8
        mov esi, eax
        xor ah, ah
        mov byte [byte esp+07h], ah
        mov ebx, esp
        push ebx
        mov edx, 1
        mov ecx, ds
        lea ebx, [byte esp+0Ah]
        mov eax, esi
        call _dos_read_
        mov ebx, esp
        push ebx
        mov edx, 1
        mov ecx, ds
        lea ebx, [byte esp+09h]
        mov eax, esi
        call _dos_read_
        mov ebx, esp
        push ebx
        mov edx, 1
        mov ecx, ds
        lea ebx, [byte esp+08h]
        mov eax, esi
        call _dos_read_
        mov eax, dword [byte esp+04h]
ReadBE24_ret:
        add esp, byte 8
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ReadCString                                  8385F  95 PC, medium confidence
; Reads bytes from a DOS handle until NUL
;-----------------------------------------------------------------------------
; C: src/front/speech/ReadCString.c
%ifdef CBUILD
%include "c/front/speech/ReadCString.inc"
%else
ReadCString:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 4
        mov esi, eax
        mov edi, edx
.1:
        mov eax, esp
        push eax
        mov ecx, ds
        mov edx, 1
        mov ebx, esi
        mov eax, edi
        call _dos_read_
        mov eax, esi
        inc esi
        cmp byte [eax], 0
        jne short ReadCString.1
        add esp, byte 4
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; OpenSpeechBank                               83897  95 PC, medium confidence
; Opens bank file (skips if same name), reads index of sample names / offsets
; / sizes into speechbank slots
;-----------------------------------------------------------------------------
OpenSpeechBank:
        push dword 40h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 24h
        mov esi, eax
        mov edi, edx
        cmp dword [speechinit], byte 0
        je near .10
        mov eax, dword [speechbank]
        cmp dword [dword eax+03B78h], byte 0
        je short .1
        lea edx, [dword eax+03B80h]
        mov eax, esi
        call StrEqNoCase
        test eax, eax
        jne near .10
        mov eax, dword [speechbank]
        mov eax, dword [dword eax+03B7Ch]
        call _dos_close_
.1:
        lea ebx, [byte esp+010h]
        xor edx, edx
        mov eax, esi
        call _dos_open_
        mov eax, dword [speechbank]
        add eax, 3B80h
        mov ebx, 0Dh
        mov edx, esi
        call strncpy_
        mov edx, dword [speechbank]
        mov eax, dword [byte esp+010h]
        mov dword [dword edx+03B7Ch], eax
        mov eax, dword [speechbank]
        mov dword [dword eax+03B70h], edi
        mov eax, dword [speechbank]
        mov dword [dword eax+03B78h], 1
        mov eax, dword [speechbank]
        mov dword [dword eax+03B6Ch], 0
        mov eax, dword [speechbank]
        mov dword [dword eax+03B74h], 0
        lea eax, [byte esp+08h]
        push eax
        mov edx, 2
        mov ecx, ds
        lea ebx, [byte esp+024h]
        mov eax, dword [byte esp+014h]
        call _dos_read_
        mov eax, dword [byte esp+01Eh]
        sar eax, 10h
        call Swap16
        mov edx, dword [speechbank]
        mov word [dword edx+03B8Dh], ax
        lea eax, [byte esp+08h]
        push eax
        mov edx, 2
        mov ecx, ds
        lea ebx, [byte esp+018h]
        mov eax, dword [byte esp+014h]
        call _dos_read_
        mov eax, dword [byte esp+012h]
        sar eax, 10h
        call Swap16
        mov edx, eax
        mov eax, dword [speechbank]
        mov word [dword eax+03B8Fh], dx
        lea eax, [byte esp+08h]
        push eax
        mov edx, 2
        mov ecx, ds
        lea ebx, [byte esp+020h]
        mov eax, dword [byte esp+014h]
        call _dos_read_
        mov eax, dword [byte esp+01Ah]
        sar eax, 10h
        call Swap16
        mov edx, dword [speechbank]
        mov word [dword edx+03B91h], ax
        xor esi, esi
        jmp short .3
.2:
        mov edi, esi
        shl edi, 2
        add edi, esi
        shl edi, 2
        sub edi, esi
        add edi, edi
        mov dword [byte edi+eax+0Eh], 0
        mov eax, dword [byte esp+010h]
        call ReadBE24
        mov edx, eax
        mov eax, dword [speechbank]
        mov dword [byte edi+eax+012h], edx
        mov eax, dword [byte esp+010h]
        call ReadBE24
        mov edx, dword [speechbank]
        mov dword [byte edx+edi+01Ah], eax
        mov eax, dword [speechbank]
        add eax, edi
        mov edx, dword [byte esp+010h]
        call ReadCString
        mov eax, dword [speechbank]
        mov dword [byte edi+eax+022h], 0
        inc esi
.3:
        mov eax, dword [speechbank]
        mov edx, dword [dword eax+03B8Fh]
        sar edx, 10h
        cmp esi, edx
        jl short OpenSpeechBank.2
        xor esi, esi
        jmp near .7
.4:
        mov edi, esi
        shl edi, 2
        add edi, esi
        shl edi, 2
        sub edi, esi
        add edi, edi
        mov ebp, dword [byte edi+eax+012h]
        xor ebx, ebx
        mov edx, ebp
        mov eax, dword [byte esp+010h]
        call lseek_
        lea eax, [byte esp+08h]
        push eax
        mov edx, 2
        mov ecx, ds
        lea ebx, [byte esp+01Ch]
        mov eax, dword [byte esp+014h]
        call _dos_read_
        mov eax, dword [byte esp+018h]
        xor ah, ah
        xor edx, edx
        mov dx, word [byte esp+018h]
        sar edx, 8
        mov dword [byte esp+018h], edx
        cmp ax, 47h
        jne short .5
        lea edx, [byte ebp+06h]
        xor ebx, ebx
        mov eax, dword [byte esp+010h]
        call lseek_
        lea eax, [byte esp+08h]
        push eax
        mov edx, 2
        mov ecx, ds
        lea ebx, [byte esp+010h]
        mov eax, dword [byte esp+014h]
        call _dos_read_
        mov eax, dword [byte esp+0Ch]
        call Swap16
        sub eax, byte 5
        mov dword [byte esp+0Ch], eax
        mov edx, dword [speechbank]
        mov dword [byte edx+edi+016h], eax
        mov dword [esp], eax
        xor ebp, ebp
        mov dword [byte esp+04h], ebp
        fild qword [esp]
        fmul qword [F64_BankPercent]
        fdiv qword [F64_BankRate11025]
        call __CHP
        fistp qword [esp]
        mov edx, dword [speechbank]
        mov eax, dword [esp]
        mov dword [byte edx+edi+01Eh], eax
        mov eax, dword [speechbank]
        mov byte [byte edi+eax+0Dh], 47h
        jmp short .6
.5:
        mov edx, dword [speechbank]
        mov eax, dword [byte edx+edi+01Ah]
        mov dword [byte esp+0Ch], eax
        mov dword [byte edx+edi+016h], eax
        mov dword [esp], eax
        xor ecx, ecx
        mov dword [byte esp+04h], ecx
        fild qword [esp]
        fmul qword [F64_BankPercent]
        fdiv qword [F64_BankRate5512]
        call __CHP
        fistp qword [esp]
        mov edx, dword [speechbank]
        mov eax, dword [esp]
        sub eax, byte 1Ah
        mov dword [byte edx+edi+01Eh], eax
        mov eax, dword [speechbank]
        mov byte [byte edi+eax+0Dh], 0FFh
.6:
        inc esi
.7:
        mov eax, dword [speechbank]
        mov edx, dword [dword eax+03B8Fh]
        sar edx, 10h
        cmp esi, edx
        jl near OpenSpeechBank.4
        mov esi, edx
        jmp short .9
.8:
        mov eax, esi
        shl eax, 2
        add eax, esi
        shl eax, 2
        sub eax, esi
        add eax, eax
        mov edx, dword [speechbank]
        add eax, edx
        call ClearSpeechSlot
        inc esi
.9:
        cmp esi, 190h
        jl short OpenSpeechBank.8
.10:
        add esp, byte 24h
OpenSpeechBank_ret:
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; SpeechSlotSize                               83BC7  95 PC, medium confidence
; Size field (+16h) of slot, 0 for -1
;-----------------------------------------------------------------------------
; C: src/front/speech/SpeechSlotSize.c
%ifdef CBUILD
%include "c/front/speech/SpeechSlotSize.inc"
%else
SpeechSlotSize:
        push dword 8
        call __CHK
        push edx
        cmp eax, byte 0FFFFFFFFh
        jne short .1
        xor eax, eax
        pop edx
        ret
.1:
        mov edx, eax
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, dword [speechbank]
        mov eax, dword [byte edx+eax*2+016h]
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ReadSpeechSample                             83BF3  95 PC, medium confidence
; Seeks bank file and reads sample bytes into speech buffer
;-----------------------------------------------------------------------------
; C: src/front/speech/OpenSpeechBank.c (ReadSpeechSample)
%ifdef CBUILD
%include "c/front/speech/OpenSpeechBank.ReadSpeechSample.inc"
%else
ReadSpeechSample:
        push dword 38h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 14h
        mov ecx, eax
        mov esi, edx
        shl eax, 2
        add eax, ecx
        shl eax, 2
        sub eax, ecx
        add eax, eax
        mov edx, dword [speechbank]
        add eax, edx
        mov edi, dword [byte eax+01Ah]
        mov edx, dword [dword edx+03B7Ch]
        mov dword [esp], edx
        mov edx, dword [byte eax+012h]
        mov dword [byte esp+0Ch], edx
        mov eax, dword [byte eax+016h]
        mov dword [byte esp+08h], eax
        push esi
        call _os_handle_3
        mov ebp, eax
        add esp, byte 4
        mov esi, eax
        mov eax, dword [byte esp+08h]
        sub eax, edi
        add eax, 1388h
        lea edx, [eax+ebp]
        mov dword [byte esp+010h], edx
        xor ebx, ebx
        mov edx, dword [byte esp+0Ch]
        mov eax, dword [esp]
        call lseek_
        lea eax, [byte esp+04h]
        push eax
        mov ecx, ds
        mov edx, edi
        mov ebx, dword [byte esp+014h]
        mov eax, dword [byte esp+04h]
        call _dos_read_
        push edi
        push ebp
        mov edx, dword [byte esp+018h]
        push edx
        call UnpackTo
        add esp, byte 0Ch
        mov ecx, eax
        xor bl, bl
        xor edx, edx
        jmp short .2
.1:
        mov bh, byte [byte edx+esi+05h]
        add bh, bl
        mov byte [edx+esi], bh
        add bl, byte [byte edx+esi+05h]
        inc edx
.2:
        lea eax, [byte ecx-05h]
        cmp edx, eax
        jl short ReadSpeechSample.1
        add esp, byte 14h
        jmp near OpenSpeechBank_ret
%endif ; C
;-----------------------------------------------------------------------------
; LoadSpeechSlot                               83CAE  95 PC, medium confidence
; Places slot after previous one and reads its data
;-----------------------------------------------------------------------------
; C: src/front/speech/ShutdownSpeech.c (LoadSpeechSlot)
%ifdef CBUILD
%include "c/front/speech/ShutdownSpeech.LoadSpeechSlot.inc"
%else
LoadSpeechSlot:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        sub esp, byte 8
        mov ebx, eax
        test eax, eax
        jne short .1
        mov edx, dword [speechbank]
        mov edx, dword [dword edx+03B64h]
        jmp short .2
.1:
        lea edx, [byte eax-01h]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        mov edx, dword [speechbank]
        add eax, edx
        mov edx, dword [byte eax+0Eh]
        add edx, dword [byte eax+016h]
.2:
        mov eax, ebx
        shl eax, 2
        add eax, ebx
        shl eax, 2
        sub eax, ebx
        lea ecx, [eax+eax]
        mov eax, dword [speechbank]
        mov dword [byte ecx+eax+0Eh], edx
        mov eax, ebx
        call ReadSpeechSample
        mov edx, eax
        mov eax, dword [speechbank]
        mov dword [byte ecx+eax+016h], edx
        mov eax, dword [speechbank]
        mov ebx, dword [dword eax+03B70h]
        mov dword [esp], edx
        xor esi, esi
        mov dword [byte esp+04h], esi
        fild qword [esp]
        fmul qword [F64_SlotPercent]
        fdiv qword [F64_SlotRate11025]
        call __CHP
        fistp qword [esp]
        mov esi, dword [esp]
        sub esi, ebx
        mov dword [byte ecx+eax+01Eh], esi
        mov eax, dword [speechbank]
        mov dword [byte ecx+eax+022h], 1
        mov eax, dword [speechbank]
        add dword [dword eax+03B6Ch], edx
        mov eax, dword [speechbank]
        inc dword [dword eax+03B74h]
        jmp near ReadBE24_ret
%endif ; C
;-----------------------------------------------------------------------------
; PlaceSpeechSlot                                 83D78  95 PC, low confidence
; Places slot after previous one and reads header
;-----------------------------------------------------------------------------
; C: src/front/speech/ShutdownSpeech.c (PlaceSpeechSlot)
%ifdef CBUILD
%include "c/front/speech/ShutdownSpeech.PlaceSpeechSlot.inc"
%else
PlaceSpeechSlot:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 8
        mov edx, eax
        test eax, eax
        jne short .1
        mov ebp, dword [speechbank]
        mov ebp, dword [dword ebp+03B64h]
        jmp short .2
.1:
        lea esi, [byte eax-01h]
        mov eax, esi
        shl eax, 2
        add eax, esi
        shl eax, 2
        sub eax, esi
        mov esi, dword [speechbank]
        mov ebp, dword [byte esi+eax*2+0Eh]
        add ebp, dword [byte esi+eax*2+016h]
.2:
        mov esi, edx
        shl esi, 2
        add esi, edx
        shl esi, 2
        sub esi, edx
        mov eax, dword [speechbank]
        mov dword [byte eax+esi*2+0Eh], ebp
        mov eax, dword [speechbank]
        mov edi, dword [dword eax+03B7Ch]
        mov edx, dword [byte eax+esi*2+01Ah]
        mov dword [byte esp+04h], edx
        mov edx, dword [byte eax+esi*2+012h]
        xor ebx, ebx
        mov eax, edi
        call lseek_
        mov eax, esp
        push eax
        mov ecx, ds
        mov edx, dword [byte esp+08h]
        mov ebx, ebp
        mov eax, edi
        call _dos_read_
        mov eax, dword [speechbank]
        mov dword [byte eax+esi*2+022h], 1
        mov edx, dword [speechbank]
        mov eax, dword [esp]
        add dword [dword edx+03B6Ch], eax
        mov eax, dword [speechbank]
        inc dword [dword eax+03B74h]
        add esp, byte 8
        jmp near ShutdownSpeech_ret6
%endif ; C
;-----------------------------------------------------------------------------
; StrEqNoCase                                  83E32  95 PC, medium confidence
; Case-insensitive string equality (1 = equal)
;-----------------------------------------------------------------------------
; C: src/front/speech/StrEqNoCase.c
%ifdef CBUILD
%include "c/front/speech/StrEqNoCase.inc"
%else
StrEqNoCase:
        push dword 0Ch
        call __CHK
        push ebx
        push ecx
.1:
        cmp byte [eax], 0
        jne short .2
        cmp byte [edx], 0
        je short .3
.2:
        movsx ebx, byte [eax]
        and ebx, 0DFh
        movsx ecx, byte [edx]
        and ecx, 0DFh
        inc eax
        inc edx
        cmp ebx, ecx
        je short StrEqNoCase.1
        xor eax, eax
        pop ecx
        pop ebx
        ret
.3:
        mov eax, 1
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; FindFreeSpeechSlot                           83E6D  95 PC, medium confidence
; First slot from index with state 0, else -1
;-----------------------------------------------------------------------------
; C: src/front/speech/FindFreeSpeechSlot.c
%ifdef CBUILD
%include "c/front/speech/FindFreeSpeechSlot.inc"
%else
FindFreeSpeechSlot:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        mov edx, eax
        mov ebx, dword [speechbank]
        jmp short .3
.1:
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        cmp dword [byte ebx+eax*2+022h], byte 0
        jne short .2
        mov eax, edx
        pop edx
        pop ebx
        ret
.2:
        inc edx
.3:
        cmp edx, 190h
        jl short FindFreeSpeechSlot.1
        mov eax, 0FFFFFFFFh
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; FindLoadedSpeechSlot                         83EAC  95 PC, medium confidence
; First slot from index with state 1, else -1
;-----------------------------------------------------------------------------
; C: src/front/speech/FindLoadedSpeechSlot.c
%ifdef CBUILD
%include "c/front/speech/FindLoadedSpeechSlot.inc"
%else
FindLoadedSpeechSlot:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        mov edx, eax
        mov ebx, dword [speechbank]
        jmp short .3
.1:
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        cmp dword [byte ebx+eax*2+022h], byte 1
        jne short .2
        mov eax, edx
        pop edx
        pop ebx
        ret
.2:
        inc edx
.3:
        cmp edx, 190h
        jl short FindLoadedSpeechSlot.1
        mov eax, 0FFFFFFFFh
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; FindSpeechSlot                               83EEB  95 PC, medium confidence
; Slot index by sample name, else -1
;-----------------------------------------------------------------------------
; C: src/front/speech/FindSpeechSlot.c
%ifdef CBUILD
%include "c/front/speech/FindSpeechSlot.inc"
%else
FindSpeechSlot:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov ecx, eax
        xor ebx, ebx
.1:
        mov eax, ebx
        shl eax, 2
        add eax, ebx
        shl eax, 2
        sub eax, ebx
        add eax, eax
        mov edx, dword [speechbank]
        add edx, eax
        mov eax, ecx
        call StrEqNoCase
        test eax, eax
        je short .2
        mov eax, ebx
        pop edx
        pop ecx
        pop ebx
        ret
.2:
        inc ebx
        cmp ebx, 190h
        jl short FindSpeechSlot.1
        mov eax, 0FFFFFFFFh
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SpeechSlotLoaded                             83F35  95 PC, medium confidence
; Slot state == 1
;-----------------------------------------------------------------------------
; C: src/front/speech/SpeechSlotLoaded.c
%ifdef CBUILD
%include "c/front/speech/SpeechSlotLoaded.inc"
%else
SpeechSlotLoaded:
        push dword 8
        call __CHK
        push edx
        mov edx, eax
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, dword [speechbank]
        cmp dword [byte edx+eax*2+022h], byte 1
        sete al
        and eax, 0FFh
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; IsSampleRequested                            83F61  95 PC, medium confidence
; Name present in samplereq list
;-----------------------------------------------------------------------------
; C: src/front/speech/IsSampleRequested.c
%ifdef CBUILD
%include "c/front/speech/IsSampleRequested.inc"
%else
IsSampleRequested:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov esi, eax
        xor ebx, ebx
        jmp short .3
.1:
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 2
        add eax, ebx
        lea edx, [ecx+eax]
        mov eax, esi
        call StrEqNoCase
        test eax, eax
        je short .2
        mov eax, 1
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.2:
        inc ebx
.3:
        mov ecx, dword [samplereq]
        cmp ebx, dword [dword ecx+0108h]
        jl short IsSampleRequested.1
        xor eax, eax
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; RequestSample                                83FAF  95 PC, medium confidence
; Adds name to samplereq, loads it if not resident
;-----------------------------------------------------------------------------
; C: src/front/speech/RequestSample.c
%ifdef CBUILD
%include "c/front/speech/RequestSample.inc"
%else
RequestSample:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov ecx, eax
        call IsSampleRequested
        cmp eax, byte 1
        je short .x
        mov edx, dword [samplereq]
        mov esi, dword [dword edx+0108h]
        mov eax, esi
        shl eax, 2
        sub eax, esi
        shl eax, 2
        add eax, esi
        inc esi
        mov dword [dword edx+0108h], esi
        mov edx, dword [samplereq]
        add eax, edx
        mov ebx, 0Dh
        mov edx, ecx
        call strncpy_
        mov eax, ecx
        call FindSpeechSlot
        mov ecx, eax
        cmp eax, byte 0FFFFFFFFh
        je short .1
        call SpeechSlotLoaded
        test eax, eax
        jne short .1
        mov edx, dword [samplereq]
        mov eax, ecx
        call SpeechSlotSize
        add dword [dword edx+0104h], eax
.1:
        mov eax, dword [samplereq]
        inc dword [dword eax+010Ch]
.x:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; FreeUnrequestedSamples                       84036  95 PC, medium confidence
; Frees loaded slots no longer requested, updates used size
;-----------------------------------------------------------------------------
; C: src/front/speech/FreeUnrequestedSamples.c
%ifdef CBUILD
%include "c/front/speech/FreeUnrequestedSamples.inc"
%else
FreeUnrequestedSamples:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov edx, 18Fh
        jmp short .3
.1:
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        lea ebx, [eax+eax]
        mov eax, dword [speechbank]
        add eax, ebx
        mov ecx, dword [byte eax+022h]
        cmp ecx, byte 1
        jne short .2
        call IsSampleRequested
        test eax, eax
        jne short .2
        mov eax, dword [speechbank]
        mov dword [byte ebx+eax+022h], 0
        mov eax, dword [speechbank]
        mov edx, dword [byte ebx+eax+016h]
        sub dword [dword eax+03B6Ch], edx
        mov eax, dword [speechbank]
        mov ebx, ecx
        sub dword [dword eax+03B74h], ecx
        jmp short .4
.2:
        dec edx
.3:
        test edx, edx
        jge short FreeUnrequestedSamples.1
        xor ebx, ebx
.4:
        mov eax, ebx
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; MoveSampleMem                                840A9  95 PC, medium confidence
; Chunked move through speechcopybuf (speechcopylen bytes per step)
;-----------------------------------------------------------------------------
; C: src/front/speech/OpenSpeechBank.c (MoveSampleMem)
%ifdef CBUILD
%include "c/front/speech/OpenSpeechBank.MoveSampleMem.inc"
%else
MoveSampleMem:
        push dword 20h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 8
        mov ebp, eax
        mov dword [esp], edx
        mov edi, ebx
.1:
        test edi, edi
        je short .x
        mov edx, dword [speechcopylen]
        cmp edi, edx
        jbe short .2
        mov esi, edx
        jmp short .3
.2:
        mov esi, edi
.3:
        mov ebx, dword [esp]
        push ebx
        call _os_handle_3
        add esp, byte 4
        push esi
        mov ecx, ds
        mov edx, ds
        mov ebx, dword [speechcopybuf]
        mov dword [byte esp+08h], ebx
        mov ebx, eax
        mov eax, dword [byte esp+08h]
        call _fmemmove_
        push ebp
        call _os_handle_3
        add esp, byte 4
        push esi
        mov ecx, ds
        mov ebx, dword [speechcopybuf]
        mov edx, ds
        call _fmemmove_
        add dword [esp], esi
        add ebp, esi
        sub edi, esi
        jmp short MoveSampleMem.1
.x:
        add esp, byte 8
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CompactSpeechSlot                            84125  95 PC, medium confidence
; Moves a slot's data down next to the previous slot
;-----------------------------------------------------------------------------
; C: src/front/speech/OpenSpeechBank.c (CompactSpeechSlot)
%ifdef CBUILD
%include "c/front/speech/OpenSpeechBank.CompactSpeechSlot.inc"
%else
CompactSpeechSlot:
        push dword 44h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 2Ch
        mov ecx, eax
        mov ebx, edx
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, dword [speechbank]
        mov esi, dword [byte edx+eax*2+0Eh]
        test ecx, ecx
        jne short .1
        mov ebp, dword [dword edx+03B64h]
        jmp short .2
.1:
        lea ebp, [byte ecx-01h]
        mov eax, ebp
        shl eax, 2
        add eax, ebp
        shl eax, 2
        sub eax, ebp
        mov ebp, dword [byte edx+eax*2+0Eh]
        add ebp, dword [byte edx+eax*2+016h]
.2:
        mov eax, ebx
        shl eax, 2
        add eax, ebx
        shl eax, 2
        sub eax, ebx
        add eax, eax
        mov dword [byte esp+028h], eax
        mov ebx, dword [speechbank]
        add ebx, eax
        mov ebx, dword [byte ebx+016h]
        mov edx, esi
        mov eax, ebp
        call MoveSampleMem
        mov edx, ecx
        shl edx, 2
        add edx, ecx
        shl edx, 2
        sub edx, ecx
        add edx, edx
        mov ebx, dword [speechbank]
        lea eax, [ebx+edx]
        mov ecx, 9
        mov edi, esp
        mov esi, eax
        rep movsd
        movsw
        mov esi, dword [byte esp+028h]
        add esi, ebx
        mov ecx, 9
        mov edi, eax
        rep movsd
        movsw
        mov edi, dword [speechbank]
        mov ebx, dword [byte esp+028h]
        add edi, ebx
        mov ecx, 9
        mov esi, esp
        rep movsd
        movsw
        mov eax, dword [speechbank]
        mov dword [byte edx+eax+0Eh], ebp
        mov eax, dword [speechbank]
        add eax, ebx
        mov dword [byte eax+022h], 0
        add esp, byte 2Ch
        jmp near OpenSpeechBank_ret
%endif ; C
;-----------------------------------------------------------------------------
; MakeSampleRoom                               84205  95 PC, medium confidence
; Frees unrequested samples until used + requested fits the limit
;-----------------------------------------------------------------------------
; C: src/front/speech/MakeSampleRoom.c
%ifdef CBUILD
%include "c/front/speech/MakeSampleRoom.inc"
%else
MakeSampleRoom:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        xor edx, edx
        xor ecx, ecx
        mov eax, dword [speechbank]
        mov esi, dword [dword eax+03B68h]
        mov ebx, dword [samplereq]
        mov eax, dword [dword eax+03B6Ch]
        add eax, dword [dword ebx+0104h]
        cmp eax, esi
        jbe short .x
.1:
        call FreeUnrequestedSamples
        mov eax, dword [speechbank]
        mov ebx, dword [samplereq]
        mov eax, dword [dword eax+03B6Ch]
        add eax, dword [dword ebx+0104h]
        cmp eax, esi
        jae short .2
        mov ecx, 1
.2:
        test ecx, ecx
        jne short .x
        inc edx
        cmp edx, 190h
        jl short MakeSampleRoom.1
.x:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; EnsureSampleRoom                             8426F  95 PC, medium confidence
; __CHK wrapper of MakeSampleRoom
;-----------------------------------------------------------------------------
; C: src/front/speech/ShutdownSpeech.c (EnsureSampleRoom)
%ifdef CBUILD
%include "c/front/speech/ShutdownSpeech.EnsureSampleRoom.inc"
%else
EnsureSampleRoom:
        push dword 4
        call __CHK
        call MakeSampleRoom
%endif ; C
;-----------------------------------------------------------------------------
; CompactSpeechMem                             8427E  95 PC, medium confidence
; Walks free/loaded slots compacting data
;-----------------------------------------------------------------------------
; C: src/front/speech/ShutdownSpeech.c (CompactSpeechMem)
%ifdef CBUILD
%include "c/front/speech/ShutdownSpeech.CompactSpeechMem.inc"
%else
CompactSpeechMem:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        xor eax, eax
        call FindFreeSpeechSlot
        mov ebx, eax
        cmp eax, byte 0FFFFFFFFh
        je short .2
.1:
        call FindLoadedSpeechSlot
        mov edx, eax
.2:
        cmp edx, byte 0FFFFFFFFh
        je near FreeClip_ret
        mov eax, ebx
        call CompactSpeechSlot
        mov eax, ebx
        call FindFreeSpeechSlot
        mov ebx, eax
        jmp short CompactSpeechMem.1
%endif ; C
