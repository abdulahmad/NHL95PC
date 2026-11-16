; The Gravis Ultrasound driver.
bits 32
%include "hockey.inc"
section s_9FFCA progbits alloc exec nowrite align=1
extern __CHK, __GETDS, str_PAT, str_ULTRADIR, str_MIDI, str_CULTRASNDMIDI
extern cliprect_x0, cliprect_x1, ScreenWidth, ScreenHeight, MidiTickCount, GusEnvRead, GusCardFound, GusDriverIsOpen
extern GusDigiOpen, GusMusicOpen, GusDriverStreaming, GusPatchFallbacks, GusPatchChannelMask
extern fputchar
extern getenv_, int386x_, memcpy_, memset_, strcat_, strcpy_, GetPatchEntry, PrintString
extern GusReadPatchHeader, GusLoadPatch, GusOpen, GusClose, GusSetMasterVolume, GusMidiNoteOn, GusMidiNoteOff, GusSetChannelPatch
extern GusDramAlloc, GusDramFreeTotal, GusServiceStream, GusStartStream, GusStopStream, GusStreamStart, GusStreamIdle, GusStreamPlayNote
extern GusStreamRelease, GusStreamStop, GusStreamSetVolume, GusStreamSetRate, GusStreamSetSample, GusStreamApplyBend, GusStreamBusy, GusStreamGetVolume
extern GusGetEnvConfig, GusProbePort, GusMidiPitchBend, GusMidiController, SetClipWindow, SetBitmapClip, GusVoiceDefaults, GusPatchNameMap
extern MidiOutQueue, GusPatchState, GusDriverBasePort
global GusAllocDosBuffer, GusFreeDosBuffer, GusLoadMidiPatch, GusStartup, GusDriverClose, GusProbe, GusDetect, GusInitDigi
global GusInitMusic, GusCloseDigi, GusCloseMusic, GusService, GusQuery, GusSetTrack, GusPlayDigi, GusProgramChange
global GusPitchBend, GusStopVoice, GusStartVoice, GusVoiceStartSample, GusVoiceSetVolume, GusSetVoiceOwner, GusVoiceController, GusMusicMidi
global GusDigiMidi, GusNoteOn, GusNoteOff, GusFreeVoice, GusController, PrintStringCentered, ResetClipRect, ResetClipWindow
GusAllocDosBuffer:
        push dword 4Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 30h
        mov ebx, 0Ch
        xor edx, edx
        lea eax, [byte ebp-014h]
        call memset_
        mov word [byte ebp-030h], 100h
        mov word [byte ebp-02Ch], 100h
        lea ecx, [byte ebp-014h]
        lea ebx, [byte ebp-030h]
        lea edx, [byte ebp-030h]
        mov eax, 31h
        call int386x_
        xor eax, eax
        mov ax, word [byte ebp-030h]
        mov dword [GusPatchState+01ED0h], eax
        xor eax, eax
        mov ax, word [byte ebp-024h]
        mov dword [GusPatchState+01ED4h], eax
        mov eax, dword [GusPatchState+01ED0h]
        shl eax, 4
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp-04h]
        add eax, 7FFh
        xor ax, ax
        mov edx, dword [byte ebp-04h]
        xor dx, dx
        cmp edx, eax
        je short .1
        add dword [byte ebp-04h], 800h
.1:
        mov eax, dword [byte ebp-04h]
        add eax, 0FFFFh
        mov dword [byte ebp-08h], eax
        mov eax, dword [byte ebp-08h]
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
GusFreeDosBuffer:
        push dword 44h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 28h
        mov ebx, 0Ch
        xor edx, edx
        lea eax, [byte ebp-0Ch]
        call memset_
        mov word [byte ebp-028h], 101h
        mov ax, word [GusPatchState+01ED4h]
        mov word [byte ebp-01Ch], ax
        lea ecx, [byte ebp-0Ch]
        lea ebx, [byte ebp-028h]
        lea edx, [byte ebp-028h]
        mov eax, 31h
        call int386x_
        mov dword [GusCardFound], 0
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
GusLoadMidiPatch:
        push dword 15Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 134h
        mov dword [byte ebp-018h], 0
        mov eax, dword [GusPatchState+01ED8h]
        mov dword [byte ebp-024h], eax
        mov eax, dword [GusPatchState+01ED8h]
        mov dword [byte ebp-020h], eax
        mov dword [byte ebp-04h], 0
.1:
        cmp dword [byte ebp-04h], 100h
        jl short .3
        jmp short .4
.2:
        inc dword [byte ebp-04h]
        jmp short .1
.3:
        imul eax, dword [byte ebp-04h], byte 1Ch
        mov word [dword eax+GusPatchState], 0
        imul eax, dword [byte ebp-04h], byte 1Ch
        mov dword [dword eax+GusPatchState+02h], 0
        jmp short .2
.4:
        mov cl, byte [GusPatchState+01EC8h]
        mov eax, 1
        shl eax, cl
        test dword [GusPatchChannelMask], eax
        jne short .5
        or byte [byte ebp-018h], 1
.5:
        mov dword [byte ebp-014h], GusPatchNameMap
        mov dword [byte ebp-010h], 0
.6:
        mov eax, dword [byte ebp-014h]
        cmp dword [eax], byte 0FFFFFFFFh
        je near .9
        mov edx, str_CULTRASNDMIDI
        lea eax, [byte ebp-074h]
        call strcpy_
        mov edx, dword [byte ebp-014h]
        add edx, byte 4
        lea eax, [byte ebp-074h]
        call strcat_
        mov edx, str_PAT
        lea eax, [byte ebp-074h]
        call strcat_
        lea edx, [dword ebp-0134h]
        lea eax, [byte ebp-074h]
        call GusReadPatchHeader
        test eax, eax
        jne near .8
        xor eax, eax
        mov ax, word [dword ebp-0DFh]
        add eax, dword [byte ebp-010h]
        cmp eax, byte 0Ah
        jge short .9
        mov eax, dword [byte ebp-014h]
        mov eax, dword [eax]
        mov dword [byte ebp-01Ch], eax
        push dword [byte ebp-018h]
        imul edx, dword [byte ebp-010h], byte 49h
        mov eax, GusPatchState+01EDCh
        add eax, edx
        push eax
        mov eax, 800h
        push eax
        lea ecx, [byte ebp-024h]
        imul ebx, dword [byte ebp-01Ch], byte 1Ch
        mov eax, GusPatchState
        add ebx, eax
        lea edx, [dword ebp-0134h]
        lea eax, [byte ebp-074h]
        call GusLoadPatch
        test eax, eax
        je short .7
        imul eax, dword [byte ebp-01Ch], byte 1Ch
        mov word [dword eax+GusPatchState], 0
        imul eax, dword [byte ebp-01Ch], byte 1Ch
        mov dword [dword eax+GusPatchState+02h], 0
        jmp short .8
.7:
        xor eax, eax
        mov ax, word [dword ebp-0DFh]
        add dword [byte ebp-010h], eax
.8:
        add dword [byte ebp-014h], byte 0Eh
        jmp near .6
.9:
        mov dword [byte ebp-04h], 0
.10:
        mov eax, dword [byte ebp-04h]
        shl eax, 2
        cmp dword [dword eax+GusPatchFallbacks], byte 0FFFFFFFFh
        je short .12
        mov eax, dword [byte ebp-04h]
        inc dword [byte ebp-04h]
        shl eax, 2
        mov eax, dword [dword eax+GusPatchFallbacks]
        mov dword [byte ebp-08h], eax
        mov eax, dword [byte ebp-04h]
        inc dword [byte ebp-04h]
        shl eax, 2
        mov eax, dword [dword eax+GusPatchFallbacks]
        mov dword [byte ebp-0Ch], eax
        imul eax, dword [byte ebp-08h], byte 1Ch
        cmp word [dword eax+GusPatchState], byte 0
        jne short .11
        mov ebx, 1Ch
        imul edx, dword [byte ebp-0Ch], byte 1Ch
        mov eax, GusPatchState
        add edx, eax
        imul eax, dword [byte ebp-08h], byte 1Ch
        mov ecx, GusPatchState
        add eax, ecx
        call memcpy_
.11:
        jmp short .10
.12:
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
GusStartup:
        push dword 38h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 10h
        cmp dword [GusDriverIsOpen], byte 0
        jne near .13
        push byte 0
        call GusProbe
        add esp, byte 4
        test ax, ax
        je near .13
        call GusAllocDosBuffer
        mov dword [GusPatchState+01ED8h], eax
        mov word [GusPatchState+01C00h], 1Ch
        cmp byte [GusPatchState+01C04h], 7
        jbe short .2
        cmp byte [GusPatchState+01C05h], 7
        ja short .1
        mov al, byte [GusPatchState+01C05h]
        mov byte [byte ebp-04h], al
        mov al, byte [GusPatchState+01C04h]
        mov byte [GusPatchState+01C05h], al
        mov al, byte [byte ebp-04h]
        mov byte [GusPatchState+01C04h], al
        jmp short .2
.1:
        mov byte [GusPatchState+01C04h], 5
.2:
        mov eax, GusPatchState+01C00h
        call GusOpen
        test eax, eax
        jne near .13
        mov eax, 7Fh
        call GusSetMasterVolume
        mov dword [GusDriverIsOpen], 1
        mov dword [GusPatchState+01EC8h], 0
        call GusDramFreeTotal
        mov dword [byte ebp-08h], eax
.3:
        cmp dword [byte ebp-08h], 40000h
        jle short .4
        inc dword [GusPatchState+01EC8h]
        sub dword [byte ebp-08h], 40000h
        jmp short .3
.4:
        mov eax, 801h
        call GusDramAlloc
        mov dword [GusPatchState+01ECCh], eax
        mov eax, str_ULTRADIR
        call getenv_
        mov dword [byte ebp-010h], eax
        cmp dword [byte ebp-010h], byte 0
        je short .5
        mov edx, dword [byte ebp-010h]
        mov eax, str_CULTRASNDMIDI
        call strcpy_
        mov edx, str_MIDI
        mov eax, str_CULTRASNDMIDI
        call strcat_
.5:
        call GusLoadMidiPatch
        push dword 800h
        push dword [GusPatchState+01ECCh]
        push dword [GusPatchState+01ED8h]
        call GusStartStream
        add esp, byte 0Ch
        mov word [GusPatchState+021B8h], 0Fh
        mov word [GusPatchState+021BAh], 0
        mov word [GusPatchState+021B6h], 0
        mov dword [byte ebp-0Ch], 0
.6:
        cmp dword [byte ebp-0Ch], byte 4
        jl short .8
        jmp short .9
.7:
        inc dword [byte ebp-0Ch]
        jmp short .6
.8:
        mov cl, byte [byte ebp-0Ch]
        mov eax, 1
        shl eax, cl
        imul edx, dword [byte ebp-0Ch], byte 22h
        mov word [dword edx+GusPatchState+01C08h], ax
        imul edx, dword [byte ebp-0Ch], byte 22h
        mov eax, dword [byte ebp-0Ch]
        mov word [dword edx+GusPatchState+01C0Ah], ax
        imul edx, dword [byte ebp-0Ch], byte 22h
        mov dword [dword edx+GusPatchState+01C16h], GusVoiceDefaults
        jmp short .7
.9:
        mov dword [byte ebp-0Ch], 0
.10:
        cmp dword [byte ebp-0Ch], byte 10h
        jl short .12
        jmp short .13
.11:
        inc dword [byte ebp-0Ch]
        jmp short .10
.12:
        imul esi, dword [byte ebp-0Ch], byte 1Eh
        mov ecx, 7
        lea edi, [dword esi+GusPatchState+01C90h]
        mov esi, GusVoiceDefaults
        rep movsd
        movsw
        jmp short .11
.13:
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
GusDriverClose:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 0
        cmp dword [GusDriverIsOpen], byte 0
        je short .1
        cmp dword [GusDriverStreaming], byte 0
        je short .2
.1:
        jmp short .3
.2:
        cmp dword [GusMusicOpen], byte 0
        je short .4
.3:
        jmp short .5
.4:
        cmp dword [GusDigiOpen], byte 0
        je short .6
.5:
        jmp short .7
.6:
        call GusClose
        call GusFreeDosBuffer
        mov dword [GusCardFound], 0
        mov dword [GusDriverIsOpen], 0
        call GusStopStream
.7:
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
GusProbe:
        push dword 18h
        call __CHK
        push ds
        call __GETDS
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 4
        cmp dword [GusCardFound], byte 0
        jne short .4
        cmp dword [GusEnvRead], byte 0
        jne short .2
        mov eax, GusPatchState+01C00h
        call GusGetEnvConfig
        test eax, eax
        jne short .1
        mov dword [byte ebp-04h], 0
        jmp short .5
.1:
        mov dword [GusEnvRead], 1
.2:
        xor eax, eax
        mov ax, word [GusDriverBasePort]
        call GusProbePort
        test eax, eax
        jne short .3
        mov dword [byte ebp-04h], 0
        jmp short .5
.3:
        mov dword [GusCardFound], 1
.4:
        mov dword [byte ebp-04h], 1
.5:
        mov eax, dword [byte ebp-04h]
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ds
        ret
GusDetect:
        push dword 18h
        call __CHK
        push ds
        call __GETDS
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 4
        mov eax, GusPatchState+01C00h
        call GusGetEnvConfig
        test eax, eax
        jne short .1
        mov dword [byte ebp-04h], 0
        jmp short .2
.1:
        mov dword [GusEnvRead], 1
        xor eax, eax
        mov al, byte [GusPatchState+01C04h]
        shl eax, 10h
        mov edx, eax
        xor eax, eax
        mov ax, word [GusDriverBasePort]
        or edx, eax
        mov dword [byte ebp-04h], edx
.2:
        mov eax, dword [byte ebp-04h]
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ds
        ret
GusInitDigi:
        push dword 14h
        call __CHK
        push ds
        call __GETDS
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 0
        cmp dword [GusDriverStreaming], byte 0
        jne short .1
        call GusStartup
        mov dword [GusDriverStreaming], 1
.1:
        pop ebp
        pop edi
        pop esi
        pop ds
        ret
GusInitMusic:
        push dword 14h
        call __CHK
        push ds
        call __GETDS
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 0
        cmp dword [GusMusicOpen], byte 0
        jne short .1
        call GusStartup
        mov dword [GusMusicOpen], 1
.1:
        pop ebp
        pop edi
        pop esi
        pop ds
        ret
GusCloseDigi:
        push dword 14h
        call __CHK
        push ds
        call __GETDS
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 0
        cmp dword [GusDriverStreaming], byte 0
        je short .1
        mov dword [GusDriverStreaming], 0
        call GusDriverClose
.1:
        pop ebp
        pop edi
        pop esi
        pop ds
        ret
GusCloseMusic:
        push dword 14h
        call __CHK
        push ds
        call __GETDS
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 0
        cmp dword [GusMusicOpen], byte 0
        je short .1
        mov dword [GusMusicOpen], 0
        call GusDriverClose
.1:
        pop ebp
        pop edi
        pop esi
        pop ds
        ret
GusService:
        push dword 3Ch
        call __CHK
        push ds
        call __GETDS
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 14h
        mov dword [byte ebp-0Ch], 0
        mov dword [byte ebp-04h], 1
.1:
        cmp dword [byte ebp-0Ch], byte 4
        jl short .3
        jmp short .7
.2:
        inc dword [byte ebp-0Ch]
        shl dword [byte ebp-04h], 1
        jmp short .1
.3:
        imul eax, dword [byte ebp-0Ch], byte 22h
        mov edx, GusPatchState+01C08h
        add edx, eax
        mov dword [byte ebp-08h], edx
        mov edx, dword [byte ebp-06h]
        sar edx, 10h
        mov eax, dword [GusPatchState+021B6h-2]
        sar eax, 10h
        test edx, eax
        je short .4
        push dword [byte ebp-0Ch]
        call GusStreamIdle
        add esp, byte 4
        test eax, eax
        je short .4
        mov eax, dword [byte ebp-08h]
        call GusFreeVoice
.4:
        mov eax, dword [byte ebp-08h]
        cmp word [byte eax+06h], byte 1
        jge short .5
        mov eax, dword [byte ebp-08h]
        mov word [byte eax+06h], 0
        jmp short .6
.5:
        mov eax, dword [byte ebp-08h]
        dec word [byte eax+06h]
.6:
        jmp short .2
.7:
        mov dword [byte ebp-0Ch], 0
.8:
        cmp dword [byte ebp-0Ch], byte 4
        jl short .10
        jmp short .12
.9:
        inc dword [byte ebp-0Ch]
        jmp short .8
.10:
        imul eax, dword [byte ebp-0Ch], byte 16h
        mov edx, GusPatchState+01E70h
        add edx, eax
        mov dword [byte ebp-010h], edx
        mov eax, dword [byte ebp-010h]
        cmp word [byte eax+0Ah], byte 0
        je short .11
        mov eax, dword [byte ebp-010h]
        mov eax, dword [eax]
        mov dword [byte ebp-014h], eax
        mov eax, dword [byte ebp-010h]
        mov eax, dword [byte eax+0Eh]
        sar eax, 10h
        push eax
        mov eax, dword [byte ebp-014h]
        mov eax, dword [byte eax+02h]
        sar eax, 10h
        push eax
        push byte 0
        push byte 0
        push dword [byte ebp-0Ch]
        call GusStreamApplyBend
        add esp, byte 14h
.11:
        jmp short .9
.12:
        call GusServiceStream
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ds
        ret
GusQuery:
        push dword 28h
        call __CHK
        push ds
        call __GETDS
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 0Ch
        cmp dword [GusDriverIsOpen], byte 0
        je near .10
        mov eax, dword [byte ebp+014h]
        mov dword [byte ebp-0Ch], eax
        cmp word [byte ebp-0Ch], byte 9
        jb short .1
        cmp word [byte ebp-0Ch], byte 9
        jbe short .5
        cmp word [byte ebp-0Ch], byte 0Ah
        jbe short .6
        cmp word [byte ebp-0Ch], byte 32h
        je short .7
        jmp near .8
        jmp near .8
.1:
        cmp word [byte ebp-0Ch], byte 7
        jb short .2
        cmp word [byte ebp-0Ch], byte 7
        jbe short .3
        jmp short .4
.2:
        jmp short .8
.3:
        mov dword [byte ebp-04h], 56h
        jmp short .9
.4:
        call GusStreamBusy
        mov dword [byte ebp-04h], eax
        jmp short .9
.5:
        mov eax, dword [byte ebp+014h]
        sar eax, 10h
        push eax
        call GusStreamIdle
        add esp, byte 4
        mov dword [byte ebp-04h], eax
        jmp short .9
.6:
        mov eax, dword [byte ebp+014h]
        sar eax, 10h
        push eax
        call GusStreamGetVolume
        add esp, byte 4
        mov dword [byte ebp-04h], eax
        jmp short .9
.7:
        mov eax, dword [byte ebp+014h]
        sar eax, 10h
        and eax, 0FFh
        push eax
        mov eax, dword [byte ebp+014h]
        sar eax, 18h
        push eax
        call GusStreamSetVolume
        add esp, byte 8
        mov dword [byte ebp-04h], 0FFFFFFFFh
        jmp short .9
.8:
        mov dword [byte ebp-04h], 0FFFFFFFFh
.9:
        jmp short .11
.10:
        mov dword [byte ebp-04h], 0FFFFFFFFh
.11:
        mov eax, dword [byte ebp-04h]
        mov dword [byte ebp-08h], eax
        mov eax, dword [byte ebp-08h]
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ds
        ret
GusSetTrack:
        push dword 14h
        call __CHK
        push ds
        call __GETDS
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 0
        mov edx, dword [byte ebp+012h]
        sar edx, 10h
        imul edx, byte 1Eh
        mov eax, dword [byte ebp+018h]
        mov word [dword edx+GusPatchState+01C94h], ax
        pop ebp
        pop edi
        pop esi
        pop ds
        ret
GusPlayDigi:
        push dword 34h
        call __CHK
        push ds
        call __GETDS
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 0
        cmp dword [GusDriverIsOpen], byte 0
        je short .1
        push dword [byte ebp+034h]
        push dword [byte ebp+030h]
        push dword [byte ebp+02Ch]
        push dword [byte ebp+028h]
        push dword [byte ebp+024h]
        push dword [byte ebp+020h]
        mov eax, dword [byte ebp+018h]
        add eax, dword [byte ebp+01Ch]
        push eax
        mov eax, dword [byte ebp+012h]
        sar eax, 10h
        push eax
        call GusStreamStart
        add esp, byte 20h
.1:
        pop ebp
        pop edi
        pop esi
        pop ds
        ret
GusProgramChange:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 0Ch
        mov dword [byte ebp-08h], eax
        mov dword [byte ebp-04h], edx
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        imul edx, eax, byte 1Eh
        mov eax, GusPatchState+01C90h
        add eax, edx
        mov dword [byte ebp-0Ch], eax
        xor eax, eax
        mov al, byte [byte ebp-04h]
        push eax
        call GetPatchEntry
        mov edx, eax
        add esp, byte 4
        mov eax, dword [byte ebp-0Ch]
        mov dword [byte eax+0Eh], edx
        mov eax, dword [byte ebp-0Ch]
        cmp dword [byte eax+0Eh], byte 0
        je short .3
        mov eax, dword [byte ebp-0Ch]
        mov eax, dword [byte eax+0Eh]
        mov edx, dword [byte eax+010h]
        mov eax, dword [byte ebp-0Ch]
        mov dword [byte eax+0Ah], edx
        cmp word [byte ebp-08h], byte 9
        je short .1
        mov eax, dword [byte ebp-0Ch]
        mov eax, dword [byte eax+0Eh]
        xor edx, edx
        mov dl, byte [byte eax+06h]
        mov eax, dword [byte ebp-0Ch]
        mov word [byte eax+08h], dx
        jmp short .2
.1:
        mov eax, dword [byte ebp-0Ch]
        mov word [byte eax+08h], 4
.2:
        mov edx, dword [byte ebp-0Ch]
        mov eax, dword [byte edx+0Eh]
        mov ax, word [byte eax+02h]
        and eax, 0Fh
        mov edx, dword [byte ebp-0Ch]
        mov word [byte edx+04h], ax
        mov eax, dword [byte ebp-04h]
        mov edx, dword [byte ebp-0Ch]
        mov word [byte edx+06h], ax
.3:
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
GusPitchBend:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 8
        mov dword [byte ebp-08h], eax
        mov dword [byte ebp-04h], edx
        mov edx, dword [byte ebp-0Ah]
        sar edx, 10h
        imul edx, byte 1Eh
        mov eax, dword [byte ebp-04h]
        mov word [dword edx+GusPatchState+01CA6h], ax
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
GusStopVoice:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 8
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp-06h]
        sar eax, 10h
        imul eax, byte 16h
        mov edx, GusPatchState+01E70h
        add edx, eax
        mov dword [byte ebp-08h], edx
        mov eax, dword [byte ebp-08h]
        mov word [byte eax+0Ah], 0
        mov eax, dword [byte ebp-06h]
        sar eax, 10h
        push eax
        call GusStreamStop
        add esp, byte 4
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
GusStartVoice:
        push dword 24h
        call __CHK
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 10h
        mov dword [byte ebp-0Ch], eax
        mov dword [byte ebp-08h], edx
        mov dword [byte ebp-04h], ebx
        mov dword [byte ebp-010h], ecx
        mov eax, dword [byte ebp+010h]
        mov eax, dword [eax]
        sar eax, 10h
        call GusStopVoice
        mov eax, dword [byte ebp+010h]
        mov dx, word [eax]
        not edx
        mov eax, dword [byte ebp+010h]
        mov eax, dword [byte eax+0Eh]
        and word [eax], dx
        mov eax, dword [byte ebp+010h]
        mov eax, dword [byte eax+0Eh]
        mov edx, dword [byte ebp+010h]
        mov dx, word [edx]
        not edx
        and word [byte eax+02h], dx
        mov eax, dword [byte ebp-010h]
        mov edx, dword [byte ebp+010h]
        mov dword [byte edx+0Eh], eax
        mov eax, dword [byte ebp-010h]
        mov dx, word [byte eax+06h]
        mov eax, dword [byte ebp+010h]
        mov word [byte eax+0Ch], dx
        mov eax, dword [byte ebp-010h]
        mov edx, dword [byte eax+0Ah]
        mov eax, dword [byte ebp+010h]
        mov dword [byte eax+012h], edx
        mov eax, dword [byte ebp-010h]
        mov edx, dword [byte eax+0Eh]
        mov eax, dword [byte ebp+010h]
        mov dword [byte eax+016h], edx
        mov edx, dword [byte ebp+010h]
        mov edx, dword [byte edx+016h]
        xor eax, eax
        mov al, byte [byte edx+0Dh]
        cwde
        push eax
        mov eax, dword [byte ebp+010h]
        mov eax, dword [byte eax+016h]
        movsx ax, byte [byte eax+0Ah]
        movsx ecx, ax
        mov eax, dword [byte ebp+010h]
        mov eax, dword [byte eax+016h]
        movsx ax, byte [byte eax+08h]
        movsx ebx, ax
        mov edx, dword [byte ebp+010h]
        mov edx, dword [byte edx+012h]
        mov eax, dword [byte ebp+010h]
        mov eax, dword [eax]
        sar eax, 10h
        call GusVoiceStartSample
        mov eax, dword [byte ebp+010h]
        mov eax, dword [byte eax+016h]
        mov al, byte [byte eax+0Ch]
        xor ah, ah
        mov edx, dword [byte ebp+010h]
        shl eax, 6
        mov word [byte edx+06h], ax
        mov eax, dword [byte ebp-08h]
        mov edx, dword [byte ebp+010h]
        mov word [byte edx+08h], ax
        mov eax, dword [byte ebp-04h]
        mov edx, dword [byte ebp+010h]
        mov word [byte edx+0Ah], ax
        mov eax, dword [byte ebp+010h]
        mov ax, word [eax]
        not eax
        and word [GusPatchState+021B8h], ax
        mov eax, dword [byte ebp+010h]
        mov ax, word [eax]
        or word [GusPatchState+021BAh], ax
        mov eax, dword [byte ebp+010h]
        mov ax, word [eax]
        not eax
        and word [GusPatchState+021B6h], ax
        mov eax, dword [byte ebp+010h]
        mov dx, word [eax]
        mov eax, dword [byte ebp-010h]
        or word [eax], dx
        mov eax, dword [byte ebp+010h]
        mov ax, word [eax]
        not eax
        mov edx, dword [byte ebp-010h]
        and word [byte edx+02h], ax
        mov edx, dword [byte ebp-010h]
        add edx, byte 12h
        mov eax, dword [byte ebp+010h]
        mov eax, dword [eax]
        sar eax, 10h
        call GusSetVoiceOwner
        mov ebx, dword [byte ebp-06h]
        sar ebx, 10h
        mov eax, dword [byte ebp-010h]
        mov eax, dword [byte eax+0Eh]
        movsx ax, byte [byte eax+07h]
        add eax, dword [byte ebp-0Ch]
        movsx edx, ax
        mov eax, dword [byte ebp+010h]
        mov eax, dword [eax]
        sar eax, 10h
        call GusVoiceSetVolume
        mov eax, dword [byte ebp-010h]
        movsx ax, byte [byte eax+015h]
        movsx ebx, ax
        mov edx, 1
        mov eax, dword [byte ebp+010h]
        mov eax, dword [eax]
        sar eax, 10h
        call GusVoiceController
        mov eax, dword [byte ebp-010h]
        movsx ax, byte [byte eax+012h]
        movsx ebx, ax
        mov edx, 7
        mov eax, dword [byte ebp+010h]
        mov eax, dword [eax]
        sar eax, 10h
        call GusVoiceController
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        ret 4
GusVoiceStartSample:
        push dword 3Ch
        call __CHK
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 18h
        mov dword [byte ebp-0Ch], eax
        mov dword [byte ebp-014h], edx
        mov dword [byte ebp-08h], ebx
        mov dword [byte ebp-04h], ecx
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        imul eax, byte 16h
        mov edx, GusPatchState+01E70h
        add edx, eax
        mov dword [byte ebp-018h], edx
        mov eax, dword [byte ebp-014h]
        mov edx, dword [byte ebp-018h]
        mov dword [byte edx+04h], eax
        mov eax, dword [byte ebp-08h]
        mov edx, dword [byte ebp-018h]
        mov word [byte edx+012h], ax
        mov eax, dword [byte ebp-04h]
        mov edx, dword [byte ebp-018h]
        mov word [byte edx+010h], ax
        mov eax, dword [byte ebp+010h]
        mov edx, dword [byte ebp-018h]
        mov word [byte edx+014h], ax
        mov eax, dword [byte ebp-014h]
        add eax, byte 10h
        mov dword [byte ebp-010h], eax
        mov eax, dword [byte ebp-010h]
        mov ax, word [byte eax+02h]
        and eax, 0FFFFh
        push eax
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        push eax
        call GusStreamSetRate
        add esp, byte 8
        mov eax, dword [byte ebp-010h]
        push dword [byte eax+0Ch]
        mov eax, dword [byte ebp-010h]
        push dword [byte eax+08h]
        mov eax, dword [byte ebp-010h]
        push dword [byte eax+04h]
        mov eax, dword [byte ebp-014h]
        push dword [byte eax+0Ch]
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        push eax
        call GusStreamSetSample
        add esp, byte 14h
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        ret 4
GusVoiceSetVolume:
        push dword 38h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 18h
        mov dword [byte ebp-0Ch], eax
        mov dword [byte ebp-010h], edx
        mov dword [byte ebp-04h], ebx
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        imul eax, byte 16h
        mov edx, GusPatchState+01E70h
        add edx, eax
        mov dword [byte ebp-014h], edx
        mov eax, dword [byte ebp-010h]
        mov edx, dword [byte ebp-014h]
        mov word [byte edx+0Ch], ax
        mov eax, dword [byte ebp-014h]
        mov dx, word [byte eax+0Ch]
        mov eax, dword [byte ebp-014h]
        mov word [byte eax+0Eh], dx
        mov eax, dword [byte ebp-014h]
        mov word [byte eax+0Ah], 3
        mov eax, dword [byte ebp-014h]
        mov eax, dword [byte eax+012h]
        sar eax, 10h
        mov edx, dword [byte ebp-06h]
        sar edx, 10h
        add eax, edx
        cmp eax, byte 7Fh
        jge short .1
        mov eax, dword [byte ebp-014h]
        mov eax, dword [byte eax+012h]
        sar eax, 10h
        mov edx, dword [byte ebp-06h]
        sar edx, 10h
        add edx, eax
        mov dword [byte ebp-018h], edx
        jmp short .2
.1:
        mov dword [byte ebp-018h], 7Fh
.2:
        mov eax, dword [byte ebp-018h]
        mov word [byte ebp-08h], ax
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        push eax
        mov eax, dword [byte ebp-012h]
        sar eax, 10h
        push eax
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        push eax
        call GusStreamPlayNote
        add esp, byte 0Ch
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
GusSetVoiceOwner:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 8
        mov dword [byte ebp-04h], eax
        mov dword [byte ebp-08h], edx
        mov edx, dword [byte ebp-06h]
        sar edx, 10h
        imul edx, byte 16h
        mov eax, dword [byte ebp-08h]
        mov dword [dword edx+GusPatchState+01E70h], eax
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
GusVoiceController:
        push dword 2Ch
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 10h
        mov dword [byte ebp-0Ch], eax
        mov dword [byte ebp-04h], edx
        mov dword [byte ebp-08h], ebx
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        imul eax, byte 16h
        mov edx, GusPatchState+01E70h
        add edx, eax
        mov dword [byte ebp-010h], edx
        cmp word [byte ebp-04h], byte 7
        jne short .1
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        push eax
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        push eax
        call GusStreamSetVolume
        add esp, byte 8
.1:
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
GusMusicMidi:
        push dword 40h
        call __CHK
        push ds
        call __GETDS
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 28h
        mov byte [byte ebp-0Ch], 0C0h
        mov byte [byte ebp-08h], 1
        mov byte [byte ebp-04h], 0
        mov dword [byte ebp-014h], 0
        mov eax, MidiOutQueue
        mov edx, dword [MidiTickCount]
        add edx, eax
        mov dword [byte ebp-020h], edx
        add dword [MidiTickCount], byte 4
        mov eax, dword [byte ebp-020h]
        mov dword [byte ebp-01Ch], eax
        cmp dword [GusDriverIsOpen], byte 0
        je near .20
        mov eax, dword [byte ebp+018h]
        mov dword [byte ebp-018h], eax
.1:
        cmp word [byte ebp+014h], byte 0
        jg short .3
        jmp near .20
.2:
        dec dword [byte ebp+014h]
        inc dword [byte ebp-018h]
        jmp short .1
.3:
        xor ah, ah
        mov edx, dword [byte ebp-018h]
        mov al, byte [edx]
        mov word [byte ebp-010h], ax
        test byte [byte ebp-010h], 80h
        je short .6
        mov al, byte [byte ebp-010h]
        and al, 0F0h
        mov byte [byte ebp-0Ch], al
        mov al, byte [byte ebp-010h]
        and al, 0Fh
        mov byte [byte ebp-04h], al
        mov eax, dword [byte ebp-010h]
        and eax, 0F0h
        cmp ax, 0C0h
        jne short .4
        mov dword [byte ebp-024h], 1
        jmp short .5
.4:
        mov dword [byte ebp-024h], 2
.5:
        mov al, byte [byte ebp-024h]
        mov byte [byte ebp-08h], al
        mov dword [byte ebp-014h], 0
        mov eax, dword [byte ebp-020h]
        mov dword [byte ebp-01Ch], eax
        jmp near .19
.6:
        mov al, byte [byte ebp-010h]
        mov edx, dword [byte ebp-01Ch]
        mov byte [edx], al
        inc dword [byte ebp-01Ch]
        inc dword [byte ebp-014h]
        xor eax, eax
        mov ax, word [byte ebp-014h]
        xor edx, edx
        mov dl, byte [byte ebp-08h]
        cmp eax, edx
        jne near .19
        mov dword [byte ebp-014h], 0
        mov eax, dword [byte ebp-020h]
        mov dword [byte ebp-01Ch], eax
        mov al, byte [byte ebp-0Ch]
        mov byte [byte ebp-028h], al
        cmp byte [byte ebp-028h], 0B0h
        jb short .8
        cmp byte [byte ebp-028h], 0B0h
        jbe near .15
        cmp byte [byte ebp-028h], 0C0h
        jb short .7
        cmp byte [byte ebp-028h], 0C0h
        jbe near .16
        cmp byte [byte ebp-028h], 0E0h
        je near .18
        jmp near .19
.7:
        jmp near .19
.8:
        cmp byte [byte ebp-028h], 80h
        jb short .9
        cmp byte [byte ebp-028h], 80h
        jbe short .10
        cmp byte [byte ebp-028h], 90h
        je short .11
        jmp near .19
.9:
        jmp near .19
.10:
        xor edx, edx
        mov dl, byte [byte ebp-04h]
        mov eax, dword [byte ebp-020h]
        mov al, byte [eax]
        and eax, 0FFh
        call GusMidiNoteOff
        jmp near .19
.11:
        mov eax, dword [byte ebp-020h]
        cmp byte [byte eax+01h], 0
        jne short .12
        xor edx, edx
        mov dl, byte [byte ebp-04h]
        mov eax, dword [byte ebp-020h]
        mov al, byte [eax]
        and eax, 0FFh
        call GusMidiNoteOff
        jmp short .14
.12:
        cmp byte [byte ebp-04h], 9
        jne short .13
        push byte 9
        mov eax, dword [byte ebp-020h]
        xor ecx, ecx
        mov cl, byte [byte eax+01h]
        mov eax, dword [byte ebp-020h]
        xor ebx, ebx
        mov bl, byte [eax]
        mov edx, 1
        mov eax, dword [byte ebp-020h]
        mov al, byte [eax]
        and eax, 0FFh
        add eax, 80h
        imul esi, eax, byte 1Ch
        mov eax, GusPatchState
        add eax, esi
        call GusMidiNoteOn
        jmp short .14
.13:
        xor eax, eax
        mov al, byte [byte ebp-04h]
        push eax
        mov eax, dword [byte ebp-020h]
        xor ecx, ecx
        mov cl, byte [byte eax+01h]
        mov eax, dword [byte ebp-020h]
        xor ebx, ebx
        mov bl, byte [eax]
        mov edx, 1
        xor eax, eax
        call GusMidiNoteOn
.14:
        jmp short .19
.15:
        mov eax, dword [byte ebp-020h]
        xor ebx, ebx
        mov bl, byte [byte eax+01h]
        mov eax, dword [byte ebp-020h]
        xor edx, edx
        mov dl, byte [eax]
        xor eax, eax
        mov al, byte [byte ebp-04h]
        call GusMidiController
        jmp short .19
.16:
        cmp byte [byte ebp-04h], 9
        je short .17
        xor edx, edx
        mov dl, byte [byte ebp-04h]
        mov eax, dword [byte ebp-020h]
        mov al, byte [eax]
        and eax, 0FFh
        imul ebx, eax, byte 1Ch
        mov eax, GusPatchState
        add eax, ebx
        call GusSetChannelPatch
.17:
        jmp short .19
.18:
        mov eax, dword [byte ebp-020h]
        xor ebx, ebx
        mov bl, byte [byte eax+01h]
        mov eax, dword [byte ebp-020h]
        xor edx, edx
        mov dl, byte [eax]
        xor eax, eax
        mov al, byte [byte ebp-04h]
        call GusMidiPitchBend
.19:
        jmp near .2
.20:
        sub dword [MidiTickCount], byte 4
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ds
        ret
GusDigiMidi:
        push dword 3Ch
        call __CHK
        push ds
        call __GETDS
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 28h
        mov byte [byte ebp-0Ch], 0C0h
        mov byte [byte ebp-08h], 1
        mov byte [byte ebp-04h], 0
        mov dword [byte ebp-014h], 0
        mov eax, MidiOutQueue
        mov edx, dword [MidiTickCount]
        add edx, eax
        mov dword [byte ebp-020h], edx
        add dword [MidiTickCount], byte 4
        mov eax, dword [byte ebp-020h]
        mov dword [byte ebp-01Ch], eax
        cmp dword [GusDriverIsOpen], byte 0
        je near .18
        mov eax, dword [byte ebp+018h]
        mov dword [byte ebp-018h], eax
.1:
        cmp word [byte ebp+014h], byte 0
        jg short .3
        jmp near .18
.2:
        dec dword [byte ebp+014h]
        inc dword [byte ebp-018h]
        jmp short .1
.3:
        xor ah, ah
        mov edx, dword [byte ebp-018h]
        mov al, byte [edx]
        mov word [byte ebp-010h], ax
        test byte [byte ebp-010h], 80h
        je short .6
        mov al, byte [byte ebp-010h]
        and al, 0F0h
        mov byte [byte ebp-0Ch], al
        mov al, byte [byte ebp-010h]
        and al, 0Fh
        mov byte [byte ebp-04h], al
        mov eax, dword [byte ebp-010h]
        and eax, 0F0h
        cmp ax, 0C0h
        jne short .4
        mov dword [byte ebp-024h], 1
        jmp short .5
.4:
        mov dword [byte ebp-024h], 2
.5:
        mov al, byte [byte ebp-024h]
        mov byte [byte ebp-08h], al
        mov dword [byte ebp-014h], 0
        mov eax, dword [byte ebp-020h]
        mov dword [byte ebp-01Ch], eax
        jmp near .17
.6:
        mov al, byte [byte ebp-010h]
        mov edx, dword [byte ebp-01Ch]
        mov byte [edx], al
        inc dword [byte ebp-01Ch]
        inc dword [byte ebp-014h]
        xor eax, eax
        mov ax, word [byte ebp-014h]
        xor edx, edx
        mov dl, byte [byte ebp-08h]
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
        mov al, byte [eax]
        xor ah, ah
        movsx edx, ax
        xor eax, eax
        mov al, byte [byte ebp-04h]
        cwde
        call GusNoteOff
        jmp near .17
.11:
        mov eax, dword [byte ebp-020h]
        cmp byte [byte eax+01h], 0
        jne short .12
        mov eax, dword [byte ebp-020h]
        mov al, byte [eax]
        xor ah, ah
        movsx edx, ax
        xor eax, eax
        mov al, byte [byte ebp-04h]
        cwde
        call GusNoteOff
        jmp short .13
.12:
        mov eax, dword [byte ebp-020h]
        mov al, byte [byte eax+01h]
        xor ah, ah
        movsx ebx, ax
        mov eax, dword [byte ebp-020h]
        mov al, byte [eax]
        xor ah, ah
        movsx edx, ax
        xor eax, eax
        mov al, byte [byte ebp-04h]
        cwde
        call GusNoteOn
.13:
        jmp short .17
.14:
        mov eax, dword [byte ebp-020h]
        mov al, byte [byte eax+01h]
        xor ah, ah
        movsx ebx, ax
        mov eax, dword [byte ebp-020h]
        mov al, byte [eax]
        xor ah, ah
        movsx edx, ax
        xor eax, eax
        mov al, byte [byte ebp-04h]
        cwde
        call GusController
        jmp short .17
.15:
        mov eax, dword [byte ebp-020h]
        mov al, byte [eax]
        xor ah, ah
        movsx edx, ax
        xor eax, eax
        mov al, byte [byte ebp-04h]
        cwde
        call GusProgramChange
        jmp short .17
.16:
        mov eax, dword [byte ebp-020h]
        mov al, byte [byte eax+01h]
        xor ah, ah
        shl eax, 8
        db 081h,0E8h,00h,040h,00h,00h           ; insn: sub eax,4000h
        movsx edx, ax
        xor eax, eax
        mov al, byte [byte ebp-04h]
        cwde
        call GusPitchBend
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
GusNoteOn:
        push dword 4Ch
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 34h
        mov dword [byte ebp-024h], eax
        mov dword [byte ebp-020h], edx
        mov dword [byte ebp-028h], ebx
        mov eax, dword [byte ebp-026h]
        sar eax, 10h
        imul eax, byte 1Eh
        mov edx, GusPatchState+01C90h
        add edx, eax
        mov dword [byte ebp-030h], edx
        cmp word [byte ebp-024h], byte 9
        jne short .3
        cmp word [byte ebp-020h], byte 24h
        jl short .1
        cmp word [byte ebp-020h], byte 64h
        jl short .2
.1:
        jmp near .31
.2:
        mov eax, dword [byte ebp-020h]
        add eax, 5Ch
        movsx edx, ax
        mov eax, dword [byte ebp-026h]
        sar eax, 10h
        call GusProgramChange
        mov dword [byte ebp-04h], 3Ch
        jmp short .4
.3:
        mov eax, dword [byte ebp-020h]
        mov dword [byte ebp-04h], eax
.4:
        mov eax, dword [byte ebp-030h]
        cmp word [byte eax+04h], byte 0
        je short .5
        mov eax, dword [byte ebp-030h]
        cmp word [byte eax+08h], byte 0
        jne short .6
.5:
        jmp near .31
.6:
        mov dword [byte ebp-08h], 7D00h
        mov dword [byte ebp-02Ch], GusPatchState+01C08h
        mov dword [byte ebp-010h], 0
        mov dword [byte ebp-014h], 1
.7:
        cmp word [byte ebp-010h], byte 4
        jl short .9
        jmp near .18
.8:
        inc dword [byte ebp-010h]
        shl dword [byte ebp-014h], 1
        jmp short .7
.9:
        mov eax, dword [byte ebp-012h]
        sar eax, 10h
        imul eax, byte 22h
        mov edx, GusPatchState+01C08h
        add edx, eax
        mov dword [byte ebp-034h], edx
        mov edx, dword [byte ebp-016h]
        sar edx, 10h
        mov eax, dword [GusPatchState+021BAh-2]
        sar eax, 10h
        and edx, eax
        mov eax, dword [byte ebp-030h]
        mov eax, dword [byte eax+02h]
        sar eax, 10h
        test edx, eax
        je short .10
        mov eax, dword [byte ebp-034h]
        mov ax, word [byte eax+06h]
        cmp ax, word [byte ebp-08h]
        jl short .11
.10:
        jmp short .12
.11:
        mov eax, dword [byte ebp-034h]
        mov ax, word [byte eax+06h]
        mov dword [byte ebp-08h], eax
        mov eax, dword [byte ebp-034h]
        mov dword [byte ebp-02Ch], eax
.12:
        mov eax, dword [byte ebp-030h]
        movsx eax, word [eax]
        mov edx, dword [byte ebp-016h]
        sar edx, 10h
        and edx, eax
        mov eax, dword [byte ebp-030h]
        mov eax, dword [byte eax+02h]
        sar eax, 10h
        test edx, eax
        je short .13
        mov eax, dword [byte ebp-030h]
        mov edx, dword [byte ebp-034h]
        cmp eax, dword [byte edx+0Eh]
        je short .14
.13:
        jmp short .15
.14:
        mov eax, dword [byte ebp-020h]
        mov edx, dword [byte ebp-034h]
        cmp ax, word [byte edx+08h]
        je short .16
.15:
        jmp short .17
.16:
        push dword [byte ebp-034h]
        mov ecx, dword [byte ebp-030h]
        mov ebx, dword [byte ebp-02Ah]
        sar ebx, 10h
        mov edx, dword [byte ebp-022h]
        sar edx, 10h
        mov eax, dword [byte ebp-06h]
        sar eax, 10h
        call GusStartVoice
        jmp near .31
.17:
        jmp near .8
.18:
        mov dword [byte ebp-0Ch], 0
        mov eax, dword [byte ebp-030h]
        mov ax, word [eax]
        mov word [byte ebp-014h], ax
.19:
        cmp word [byte ebp-014h], byte 0
        je short .20
        inc dword [byte ebp-0Ch]
        mov eax, dword [byte ebp-014h]
        neg eax
        and eax, dword [byte ebp-014h]
        xor word [byte ebp-014h], ax
        jmp short .19
.20:
        mov eax, dword [byte ebp-0Ch]
        mov edx, dword [byte ebp-030h]
        cmp ax, word [byte edx+08h]
        jge near .25
        mov ax, word [GusPatchState+021B8h]
        mov edx, dword [byte ebp-030h]
        and ax, word [byte edx+04h]
        mov dword [byte ebp-018h], eax
        cmp word [byte ebp-018h], byte 0
        je short .25
        mov eax, dword [byte ebp-018h]
        neg eax
        mov edx, dword [byte ebp-018h]
        and edx, eax
        mov word [byte ebp-014h], dx
        mov word [byte ebp-010h], 0FFFFh
.21:
        cmp word [byte ebp-014h], byte 0
        jne short .23
        jmp short .24
.22:
        inc word [byte ebp-010h]
        sar word [byte ebp-014h], 1
        jmp short .21
.23:
        jmp short .22
.24:
        mov eax, dword [byte ebp-012h]
        sar eax, 10h
        imul eax, byte 22h
        mov edx, GusPatchState+01C08h
        add edx, eax
        mov dword [byte ebp-034h], edx
        push dword [byte ebp-034h]
        mov ecx, dword [byte ebp-030h]
        mov ebx, dword [byte ebp-02Ah]
        sar ebx, 10h
        mov edx, dword [byte ebp-022h]
        sar edx, 10h
        mov eax, dword [byte ebp-06h]
        sar eax, 10h
        call GusStartVoice
        jmp near .31
.25:
        mov ax, word [GusPatchState+021B6h]
        mov edx, dword [byte ebp-030h]
        and ax, word [byte edx+04h]
        mov dword [byte ebp-01Ch], eax
        cmp word [byte ebp-01Ch], byte 0
        je short .30
        mov eax, dword [byte ebp-01Ch]
        neg eax
        mov edx, dword [byte ebp-01Ch]
        and edx, eax
        mov word [byte ebp-014h], dx
        mov word [byte ebp-010h], 0FFFFh
.26:
        cmp word [byte ebp-014h], byte 0
        jne short .28
        jmp short .29
.27:
        inc word [byte ebp-010h]
        sar word [byte ebp-014h], 1
        jmp short .26
.28:
        jmp short .27
.29:
        mov eax, dword [byte ebp-012h]
        sar eax, 10h
        imul eax, byte 22h
        mov edx, GusPatchState+01C08h
        add edx, eax
        mov dword [byte ebp-034h], edx
        push dword [byte ebp-034h]
        mov ecx, dword [byte ebp-030h]
        mov ebx, dword [byte ebp-02Ah]
        sar ebx, 10h
        mov edx, dword [byte ebp-022h]
        sar edx, 10h
        mov eax, dword [byte ebp-06h]
        sar eax, 10h
        call GusStartVoice
        jmp short .31
.30:
        push dword [byte ebp-02Ch]
        mov ecx, dword [byte ebp-030h]
        mov ebx, dword [byte ebp-02Ah]
        sar ebx, 10h
        mov edx, dword [byte ebp-022h]
        sar edx, 10h
        mov eax, dword [byte ebp-06h]
        sar eax, 10h
        call GusStartVoice
        mov dword [byte ebp-02Ch], 0
.31:
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
GusNoteOff:
        push dword 3Ch
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 20h
        mov dword [byte ebp-014h], eax
        mov dword [byte ebp-0Ch], edx
        mov eax, dword [byte ebp-016h]
        sar eax, 10h
        imul eax, byte 1Eh
        mov edx, GusPatchState+01C90h
        add edx, eax
        mov dword [byte ebp-020h], edx
        mov eax, dword [byte ebp-020h]
        mov ax, word [eax]
        mov dword [byte ebp-08h], eax
        mov dword [byte ebp-04h], 0
        mov dword [byte ebp-010h], 1
.1:
        cmp word [byte ebp-04h], byte 4
        jl short .3
        jmp near .9
.2:
        inc dword [byte ebp-04h]
        shl dword [byte ebp-010h], 1
        jmp short .1
.3:
        mov edx, dword [byte ebp-012h]
        sar edx, 10h
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        test edx, eax
        je near .8
        mov eax, dword [byte ebp-06h]
        sar eax, 10h
        imul eax, byte 22h
        mov edx, GusPatchState+01C08h
        add edx, eax
        mov dword [byte ebp-01Ch], edx
        mov eax, dword [byte ebp-020h]
        mov edx, dword [byte ebp-01Ch]
        cmp eax, dword [byte edx+0Eh]
        jne short .4
        mov eax, dword [byte ebp-0Ch]
        mov edx, dword [byte ebp-01Ch]
        cmp ax, word [byte edx+08h]
        je short .5
.4:
        jmp short .8
.5:
        mov eax, dword [byte ebp-020h]
        cmp byte [byte eax+014h], 0
        je short .6
        mov eax, dword [byte ebp-010h]
        mov edx, dword [byte ebp-020h]
        or word [byte edx+02h], ax
        jmp short .7
.6:
        mov eax, dword [byte ebp-010h]
        or word [GusPatchState+021B6h], ax
        mov eax, dword [byte ebp-01Ch]
        sar word [byte eax+06h], 1
        mov eax, dword [byte ebp-06h]
        sar eax, 10h
        imul eax, byte 16h
        mov edx, GusPatchState+01E70h
        add edx, eax
        mov dword [byte ebp-018h], edx
        mov eax, dword [byte ebp-018h]
        mov word [byte eax+0Ah], 1
        mov eax, dword [byte ebp-06h]
        sar eax, 10h
        push eax
        call GusStreamRelease
        add esp, byte 4
.7:
        jmp short .9
.8:
        jmp near .2
.9:
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
GusFreeVoice:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 4
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp-04h]
        mov eax, dword [eax]
        sar eax, 10h
        call GusStopVoice
        mov eax, dword [byte ebp-04h]
        mov word [byte eax+06h], 0
        mov eax, dword [byte ebp-04h]
        mov ax, word [eax]
        or word [GusPatchState+021B8h], ax
        mov eax, dword [byte ebp-04h]
        mov ax, word [eax]
        not eax
        and word [GusPatchState+021BAh], ax
        mov eax, dword [byte ebp-04h]
        mov ax, word [eax]
        not eax
        and word [GusPatchState+021B6h], ax
        mov eax, dword [byte ebp-04h]
        mov dx, word [eax]
        not edx
        mov eax, dword [byte ebp-04h]
        mov eax, dword [byte eax+0Eh]
        and word [eax], dx
        mov eax, dword [byte ebp-04h]
        mov eax, dword [byte eax+0Eh]
        mov edx, dword [byte ebp-04h]
        mov dx, word [edx]
        not edx
        and word [byte eax+02h], dx
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
GusController:
        push dword 34h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 20h
        mov dword [byte ebp-010h], eax
        mov dword [byte ebp-018h], edx
        mov dword [byte ebp-014h], ebx
        mov eax, dword [byte ebp-012h]
        sar eax, 10h
        imul eax, byte 1Eh
        mov edx, GusPatchState+01C90h
        add edx, eax
        mov dword [byte ebp-01Ch], edx
        mov eax, dword [byte ebp-018h]
        mov dword [byte ebp-020h], eax
        cmp word [byte ebp-020h], byte 0Ah
        jb short .2
        cmp word [byte ebp-020h], byte 0Ah
        jbe short .6
        cmp word [byte ebp-020h], byte 40h
        jb short .1
        cmp word [byte ebp-020h], byte 40h
        jbe short .7
        cmp word [byte ebp-020h], byte 7Bh
        je near .13
        jmp near .18
.1:
        jmp near .18
.2:
        cmp word [byte ebp-020h], byte 1
        jb short .3
        cmp word [byte ebp-020h], byte 1
        jbe short .4
        cmp word [byte ebp-020h], byte 7
        je short .5
        jmp near .18
.3:
        jmp near .18
.4:
        mov al, byte [byte ebp-014h]
        mov edx, dword [byte ebp-01Ch]
        mov byte [byte edx+015h], al
        jmp near .18
.5:
        mov al, byte [byte ebp-014h]
        mov edx, dword [byte ebp-01Ch]
        mov byte [byte edx+012h], al
        jmp near .18
.6:
        mov al, byte [byte ebp-014h]
        mov edx, dword [byte ebp-01Ch]
        mov byte [byte edx+013h], al
        jmp near .18
.7:
        mov al, byte [byte ebp-014h]
        mov edx, dword [byte ebp-01Ch]
        mov byte [byte edx+014h], al
        cmp word [byte ebp-014h], byte 0
        jne short .12
        mov eax, dword [byte ebp-01Ch]
        mov ax, word [byte eax+02h]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp-01Ch]
        mov word [byte eax+02h], 0
        mov dword [byte ebp-08h], 0
        mov dword [byte ebp-0Ch], 1
.8:
        cmp word [byte ebp-08h], byte 4
        jl short .10
        jmp short .12
.9:
        inc dword [byte ebp-08h]
        shl dword [byte ebp-0Ch], 1
        jmp short .8
.10:
        mov edx, dword [byte ebp-0Eh]
        sar edx, 10h
        mov eax, dword [byte ebp-06h]
        sar eax, 10h
        test edx, eax
        je short .11
        mov edx, dword [byte ebp-0Ah]
        sar edx, 10h
        imul edx, byte 22h
        mov edx, dword [dword edx+GusPatchState+01C0Eh]
        sar edx, 10h
        mov eax, dword [byte ebp-012h]
        sar eax, 10h
        call GusNoteOff
.11:
        jmp short .9
.12:
        jmp short .18
.13:
        mov eax, dword [byte ebp-01Ch]
        mov ax, word [eax]
        mov word [byte ebp-04h], ax
        mov word [byte ebp-08h], 0
        mov word [byte ebp-0Ch], 1
.14:
        cmp word [byte ebp-08h], byte 4
        jl short .16
        jmp short .18
.15:
        inc word [byte ebp-08h]
        shl word [byte ebp-0Ch], 1
        jmp short .14
.16:
        mov edx, dword [byte ebp-0Eh]
        sar edx, 10h
        mov eax, dword [byte ebp-06h]
        sar eax, 10h
        test edx, eax
        je short .17
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        imul edx, eax, byte 22h
        mov eax, GusPatchState+01C08h
        add eax, edx
        call GusFreeVoice
.17:
        jmp short .15
.18:
        mov eax, dword [byte ebp-01Ch]
        mov ax, word [eax]
        mov word [byte ebp-04h], ax
        mov word [byte ebp-08h], 0
        mov word [byte ebp-0Ch], 1
.19:
        cmp word [byte ebp-08h], byte 4
        jl short .21
        jmp short .23
.20:
        inc word [byte ebp-08h]
        shl word [byte ebp-0Ch], 1
        jmp short .19
.21:
        mov edx, dword [byte ebp-0Eh]
        sar edx, 10h
        mov eax, dword [byte ebp-06h]
        sar eax, 10h
        test edx, eax
        je short .22
        mov ebx, dword [byte ebp-016h]
        sar ebx, 10h
        mov edx, dword [byte ebp-01Ah]
        sar edx, 10h
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        call GusVoiceController
.22:
        jmp short .20
.23:
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
PrintStringCentered:
        push esi
        push edi
        mov esi, dword [cliprect_x1]
        sub esi, dword [cliprect_x0]
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call fputchar
        add esp, byte 4
        sub esi, eax
        mov eax, esi
        sar eax, 1
        add eax, dword [cliprect_x0]
        mov esi, dword [byte esp+010h]
        push esi
        inc eax
        push eax
        mov edi, dword [byte esp+014h]
        push edi
        call PrintString
        add esp, byte 0Ch
        pop edi
        pop esi
        ret
        db 00h,00h
ResetClipRect:
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte eax+04h]
        push edx
        push byte 0
        mov ebx, dword [eax]
        push ebx
        push byte 0
        push eax
        call SetBitmapClip
        add esp, byte 14h
        ret
        db 08Dh,040h,00h
ResetClipWindow:
        mov edx, dword [ScreenHeight]
        push edx
        push byte 0
        mov ebx, dword [ScreenWidth]
        push ebx
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        ret
