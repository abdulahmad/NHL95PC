; The PC speaker driver.
bits 32
%include "hockey.inc"
section s_9D68E progbits alloc exec nowrite align=1
extern __GETDS, abs_, PcSpkVoiceDefaults, _STACKLOW
extern MidiTickCount, GetPatchTimbre, SbNoteOff, SbNoteOn, SbController, SbProgramChange, SbPitchBend
extern PcSpkHwInit, PcSpkHwClose, PcSpkVoiceNote, PcSpkVoiceOff, PcSpkVoiceUpdate, PcSpkOutput, MidiOutQueue, PcSpkVoices
global CMainHook, PcSpkInit, PcSpkClose, PcSpkService, PcSpkNoteOn, PcSpkNoteOff, PcSpkProgramChange, PcSpkUpdateVoices
global PcSpkTimbreUsable, PcSpkMidi, SbMidi
;-----------------------------------------------------------------------------
; CMainHook                                    9D68E  95 PC, medium confidence
; Start-up hook (returns at once)
;-----------------------------------------------------------------------------
CMainHook:
        mov eax, esp
        sub eax, dword [_STACKLOW]
        ret
        db 00h
;-----------------------------------------------------------------------------
; PcSpkInit                                    9D698  95 PC, medium confidence
; PC speaker driver init entry: clears the voices and channels and starts the
; timer
;-----------------------------------------------------------------------------
PcSpkInit:
        push ds
        call __GETDS
        xor eax, eax
        jmp short .2
.1:
        movsx ebx, ax
        mov edx, ebx
        shl edx, 2
        sub edx, ebx
        shl edx, 4
        xor bl, bl
        mov byte [dword edx+PcSpkVoices+01h], bl
        inc eax
.2:
        cmp ax, 10h
        jl short .1
        xor eax, eax
        mov cl, 10h
        jmp short .4
.3:
        movsx edx, ax
        imul edx, byte 4Eh
        xor bh, bh
        mov byte [dword edx+PcSpkVoices+0316h], bh
        mov byte [dword edx+PcSpkVoices+0317h], cl
        inc eax
.4:
        cmp ax, 18h
        jl short .3
        call PcSpkHwInit
        pop ds
        ret
;-----------------------------------------------------------------------------
; PcSpkClose                                   9D6E6  95 PC, medium confidence
; PC speaker driver close entry
;-----------------------------------------------------------------------------
PcSpkClose:
        push ds
        call __GETDS
        call PcSpkHwClose
        pop ds
        ret
;-----------------------------------------------------------------------------
; PcSpkService                                 9D6F3  95 PC, medium confidence
; PC speaker driver timer service entry: steps the voices
;-----------------------------------------------------------------------------
PcSpkService:
        push ds
        call __GETDS
        call PcSpkUpdateVoices
        pop ds
        ret
;-----------------------------------------------------------------------------
; PcSpkNoteOn                                     9D700  95 PC, low confidence
; MIDI note on for the PC speaker; channel 10 drums use their own patches
;-----------------------------------------------------------------------------
PcSpkNoteOn:
        push ds
        call __GETDS
        push esi
        xor eax, eax
        mov al, byte [byte esp+0Ch]
        imul eax, byte 4Eh
        mov esi, PcSpkVoices+0300h
        add esi, eax
        cmp byte [byte esp+0Ch], 9
        je short .1
        mov edx, dword [byte esi+01Eh]
        jmp short .2
.1:
        mov al, byte [byte esp+010h]
        add al, 5Ch
        and eax, 0FFh
        push eax
        call GetPatchTimbre
        add esp, byte 4
        mov edx, eax
        mov byte [byte esp+010h], 3Ch
.2:
        test edx, edx
        je near .3
        mov eax, edx
        call PcSpkTimbreUsable
        mov ecx, eax
        cwde
        cmp eax, byte 0FFFFFFFFh
        je near .3
        mov ebx, eax
        shl eax, 2
        sub eax, ebx
        shl eax, 4
        add eax, PcSpkVoices
        mov dword [byte eax+010h], edx
        mov bl, byte [byte esp+0Ch]
        mov byte [eax], bl
        mov dword [byte eax+02Ah], esi
        mov byte [byte eax+01h], 1
        mov byte [byte eax+016h], 1
        mov ebx, dword [byte eax+010h]
        mov bx, word [byte ebx+01Ch]
        mov word [byte eax+014h], bx
        mov bl, byte [byte esi+024h]
        mov byte [byte eax+02h], bl
        mov dword [byte eax+08h], 0
        mov dword [byte eax+0Ch], 64h
        mov bx, word [byte edx+02Ah]
        mov word [byte eax+018h], bx
        mov bx, word [byte edx+02Ch]
        mov word [byte eax+01Ah], bx
        mov bx, word [byte edx+030h]
        mov word [byte eax+024h], bx
        mov word [byte eax+01Ch], 0
        mov bl, byte [byte edx+034h]
        mov byte [byte eax+026h], bl
        mov byte [byte eax+027h], 0
        mov bx, word [byte edx+036h]
        mov word [byte eax+01Eh], bx
        mov bx, word [byte edx+038h]
        mov word [byte eax+020h], bx
        mov byte [byte eax+028h], 0
        mov byte [byte eax+022h], 0
        mov byte [byte eax+029h], 0
        mov byte [byte eax+02Eh], cl
        mov bl, byte [byte esp+010h]
        mov bh, byte [byte edx+010h]
        mov dl, bl
        add dl, bh
        movsx edx, dl
        push edx
        push eax
        mov al, cl
        and eax, 0FFh
        push eax
        call PcSpkVoiceNote
        add esp, byte 0Ch
.3:
        pop esi
        pop ds
        ret
;-----------------------------------------------------------------------------
; PcSpkNoteOff                                    9D805  95 PC, low confidence
; MIDI note off for the PC speaker: releases the note's voice
;-----------------------------------------------------------------------------
PcSpkNoteOff:
        push ds
        call __GETDS
        mov bh, byte [byte esp+08h]
        mov bl, byte [byte esp+0Ch]
        mov eax, PcSpkVoices
        xor edx, edx
        jmp short .3
.1:
        cmp byte [byte eax+01h], 0
        je short .2
        cmp bl, byte [byte eax+03h]
        jne short .2
        cmp bh, byte [eax]
        je short .4
.2:
        inc edx
.3:
        cmp dx, byte 10h
        jl short .1
.4:
        cmp dx, byte 10h
        jge short .6
        mov byte [byte eax+01h], 2
        xor edx, edx
        mov dl, byte [eax]
        imul edx, byte 4Eh
        cmp byte [dword edx+PcSpkVoices+0325h], 0
        je short .5
        mov byte [byte eax+016h], 3
        pop ds
        ret
.5:
        mov byte [byte eax+016h], 4
.6:
        pop ds
        ret
;-----------------------------------------------------------------------------
; PcSpkProgramChange                           9D858  95 PC, medium confidence
; MIDI program change for the PC speaker: sets the timbre of a channel
;-----------------------------------------------------------------------------
PcSpkProgramChange:
        push ds
        call __GETDS
        xor eax, eax
        mov al, byte [byte esp+0Ch]
        push eax
        call GetPatchTimbre
        mov edx, eax
        add esp, byte 4
        xor eax, eax
        mov al, byte [byte esp+08h]
        imul eax, byte 4Eh
        mov dword [dword eax+PcSpkVoices+031Eh], edx
        pop ds
        ret
;-----------------------------------------------------------------------------
; PcSpkUpdateVoices                               9D880  95 PC, low confidence
; Steps the envelope and pitch of every PC speaker voice and plays the
; loudest
;-----------------------------------------------------------------------------
PcSpkUpdateVoices:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 4
        mov esi, PcSpkVoices
        xor edx, edx
        mov dword [esp], edx
        jmp near .17
.1:
        cmp byte [byte esi+01h], 0
        je near .16
        inc dword [byte esi+08h]
        mov edi, dword [byte esi+010h]
        cmp byte [byte esi+016h], 1
        jne short .3
        mov ax, word [byte edi+020h]
        mov bx, word [byte esi+014h]
        add ebx, eax
        mov word [byte esi+014h], bx
        mov cx, word [byte edi+01Eh]
        cmp bx, cx
        jl short .3
        mov word [byte esi+014h], cx
        cmp cx, word [byte edi+024h]
        jg short .2
        mov byte [byte esi+016h], 3
        jmp short .3
.2:
        mov byte [byte esi+016h], 2
.3:
        cmp byte [byte esi+016h], 2
        jne short .4
        mov ax, word [byte edi+022h]
        mov bx, word [byte esi+014h]
        sub ebx, eax
        mov word [byte esi+014h], bx
        cmp bx, word [byte edi+024h]
        jg short .4
        mov byte [byte esi+016h], 3
        mov ax, word [byte edi+024h]
        mov word [byte esi+014h], ax
.4:
        cmp byte [byte esi+016h], 3
        jne short .5
        cmp word [byte edi+024h], byte 0
        jne short .5
        mov byte [byte esi+016h], 4
.5:
        cmp byte [byte esi+016h], 4
        jne short .6
        mov ax, word [byte edi+026h]
        mov dx, word [byte esi+014h]
        sub edx, eax
        mov word [byte esi+014h], dx
        test dx, dx
        jg short .6
        mov word [byte esi+014h], 0
        mov byte [byte esi+016h], 0
        mov byte [byte esi+01h], 0
        xor eax, eax
        mov al, byte [esi]
        imul eax, byte 4Eh
        dec byte [dword eax+PcSpkVoices+0316h]
        xor eax, eax
        mov al, byte [byte esi+02Eh]
        push eax
        call PcSpkVoiceOff
        add esp, byte 4
.6:
        cmp byte [byte edi+028h], 0
        je near .12
        mov cx, word [byte esi+018h]
        test cx, cx
        je short .7
        mov ebx, ecx
        dec ebx
        mov word [byte esi+018h], bx
        jmp near .12
.7:
        mov ax, word [byte esi+01Ah]
        test ax, ax
        je near .12
        cmp ax, 7FFFh
        je short .8
        mov ebx, eax
        dec ebx
        mov word [byte esi+01Ah], bx
.8:
        mov al, byte [byte esi+027h]
        test al, al
        jne near .11
        mov al, byte [byte edi+029h]
        mov byte [byte esi+027h], al
        cmp byte [byte esi+026h], 2
        jne short .10
        mov ax, word [byte esi+024h]
        sub word [byte esi+01Ch], ax
        xor edx, edx
        mov dx, word [byte edi+02Eh]
        movsx eax, word [byte esi+01Ch]
        call abs_
        cmp eax, edx
        jl short .12
        test byte [byte edi+034h], 1
        je short .9
        mov byte [byte esi+026h], 1
        jmp short .12
.9:
        mov word [byte esi+01Ch], 0
        jmp short .12
.10:
        mov ax, word [byte esi+024h]
        mov cx, word [byte esi+01Ch]
        add ecx, eax
        mov word [byte esi+01Ch], cx
        xor edx, edx
        mov dx, word [byte edi+02Eh]
        movsx eax, cx
        call abs_
        cmp eax, edx
        jl short .12
        test byte [byte edi+034h], 2
        je short .9
        mov byte [byte esi+026h], 2
        jmp short .12
.11:
        mov ah, al
        dec ah
        mov byte [byte esi+027h], ah
.12:
        cmp byte [byte edi+035h], 0
        je short .15
        mov cx, word [byte esi+01Eh]
        test cx, cx
        je short .13
        mov ebx, ecx
        dec ebx
        mov word [byte esi+01Eh], bx
        jmp short .15
.13:
        mov ax, word [byte esi+020h]
        test ax, ax
        je short .15
        mov edx, eax
        dec edx
        mov word [byte esi+020h], dx
        mov cl, byte [byte esi+028h]
        test cl, cl
        je short .14
        mov ch, cl
        dec ch
        mov byte [byte esi+028h], ch
        jmp short .15
.14:
        mov al, byte [byte edi+03Ah]
        mov byte [byte esi+028h], al
        mov al, byte [byte esi+029h]
        mov ah, al
        and ah, 7
        xor edx, edx
        mov dl, ah
        inc al
        mov byte [byte esi+029h], al
        mov al, byte [byte edx+edi+03Bh]
        mov byte [byte esi+022h], al
.15:
        mov ebx, dword [byte esi+010h]
        push ebx
        mov ecx, dword [byte esi+02Ah]
        push ecx
        push esi
        xor eax, eax
        mov al, byte [byte esi+02Eh]
        push eax
        call PcSpkVoiceUpdate
        add esp, byte 10h
.16:
        add esi, byte 30h
        inc dword [esp]
.17:
        xor edx, edx
        mov dx, word [esp]
        xor eax, eax
        mov al, byte [PcSpkVoiceDefaults]
        cmp edx, eax
        jl near .1
        call PcSpkOutput
        add esp, byte 4
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; PcSpkTimbreUsable                               9DA99  95 PC, low confidence
; Returns 1 when a timbre has PC speaker data, otherwise -1
;-----------------------------------------------------------------------------
PcSpkTimbreUsable:
        cmp word [byte eax+0Ch], byte 0
        jne short .1
        mov eax, 0FFFFFFFFh
        ret
.1:
        mov eax, 1
        ret
;-----------------------------------------------------------------------------
; PcSpkMidi                                    9DAAC  95 PC, medium confidence
; PC speaker driver MIDI entry: plays a run of MIDI messages
;-----------------------------------------------------------------------------
PcSpkMidi:
        push ds
        call __GETDS
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 34h
        mov byte [byte ebp-0Ch], 0C0h
        mov byte [byte ebp-010h], 1
        mov byte [byte ebp-04h], 0
        mov dword [byte ebp-014h], 0
        mov eax, MidiOutQueue
        mov edx, dword [MidiTickCount]
        add edx, eax
        mov dword [byte ebp-028h], edx
        add dword [MidiTickCount], byte 4
        mov eax, dword [byte ebp-028h]
        mov dword [byte ebp-02Ch], eax
        mov eax, dword [byte ebp+018h]
        mov dword [byte ebp-024h], eax
.1:
        cmp dword [byte ebp+014h], byte 0
        jg short .3
        jmp near .18
.2:
        dec dword [byte ebp+014h]
        inc dword [byte ebp-024h]
        jmp short .1
.3:
        mov eax, dword [byte ebp-024h]
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
        mov dword [byte ebp-030h], 1
        jmp short .5
.4:
        mov dword [byte ebp-030h], 2
.5:
        mov al, byte [byte ebp-030h]
        mov byte [byte ebp-010h], al
        mov dword [byte ebp-014h], 0
        mov eax, dword [byte ebp-028h]
        mov dword [byte ebp-02Ch], eax
        jmp near .17
.6:
        mov al, byte [byte ebp-08h]
        mov edx, dword [byte ebp-02Ch]
        mov byte [edx], al
        inc dword [byte ebp-02Ch]
        inc dword [byte ebp-014h]
        xor eax, eax
        mov ax, word [byte ebp-014h]
        xor edx, edx
        mov dl, byte [byte ebp-010h]
        cmp eax, edx
        jne near .17
        mov dword [byte ebp-014h], 0
        mov eax, dword [byte ebp-028h]
        mov dword [byte ebp-02Ch], eax
        mov al, byte [byte ebp-0Ch]
        mov byte [byte ebp-034h], al
        cmp byte [byte ebp-034h], 0B0h
        jb short .8
        cmp byte [byte ebp-034h], 0B0h
        jbe near .14
        cmp byte [byte ebp-034h], 0C0h
        jb short .7
        cmp byte [byte ebp-034h], 0C0h
        jbe near .15
        cmp byte [byte ebp-034h], 0E0h
        je near .16
        jmp near .17
.7:
        jmp near .17
.8:
        cmp byte [byte ebp-034h], 80h
        jb short .9
        cmp byte [byte ebp-034h], 80h
        jbe short .10
        cmp byte [byte ebp-034h], 90h
        je short .11
        jmp near .17
.9:
        jmp near .17
.10:
        mov eax, dword [byte ebp-028h]
        mov al, byte [eax]
        and eax, 0FFh
        push eax
        xor eax, eax
        mov al, byte [byte ebp-04h]
        push eax
        call PcSpkNoteOff
        add esp, byte 8
        jmp near .17
.11:
        mov eax, dword [byte ebp-028h]
        cmp byte [byte eax+01h], 0
        jne short .12
        mov eax, dword [byte ebp-028h]
        mov al, byte [eax]
        and eax, 0FFh
        push eax
        xor eax, eax
        mov al, byte [byte ebp-04h]
        push eax
        call PcSpkNoteOff
        add esp, byte 8
        jmp short .13
.12:
        mov eax, dword [byte ebp-028h]
        mov al, byte [byte eax+01h]
        and eax, 0FFh
        push eax
        mov eax, dword [byte ebp-028h]
        mov al, byte [eax]
        and eax, 0FFh
        push eax
        xor eax, eax
        mov al, byte [byte ebp-04h]
        push eax
        call PcSpkNoteOn
        add esp, byte 0Ch
.13:
        jmp short .17
.14:
        jmp short .17
.15:
        mov eax, dword [byte ebp-028h]
        mov al, byte [eax]
        and eax, 0FFh
        push eax
        xor eax, eax
        mov al, byte [byte ebp-04h]
        push eax
        call PcSpkProgramChange
        add esp, byte 8
        jmp short .17
.16:
        xor ah, ah
        mov edx, dword [byte ebp-028h]
        mov al, byte [edx]
        mov dword [byte ebp-020h], eax
        xor ah, ah
        mov edx, dword [byte ebp-028h]
        mov al, byte [byte edx+01h]
        mov dword [byte ebp-018h], eax
        mov eax, dword [byte ebp-018h]
        shl eax, 7
        mov edx, dword [byte ebp-020h]
        add edx, eax
        mov dword [byte ebp-01Ch], edx
        sub dword [byte ebp-01Ch], 2000h
        shl dword [byte ebp-01Ch], 1
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
;-----------------------------------------------------------------------------
; SbMidi                                       9DC9F  95 PC, medium confidence
; Sound Blaster driver MIDI entry: plays a run of MIDI messages on the
; sampled voices
;-----------------------------------------------------------------------------
SbMidi:
        push ds
        call __GETDS
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 28h
        mov byte [byte ebp-04h], 0C0h
        mov byte [byte ebp-08h], 1
        mov byte [byte ebp-0Ch], 0
        mov dword [byte ebp-014h], 0
        mov eax, MidiOutQueue
        mov edx, dword [MidiTickCount]
        add edx, eax
        mov dword [byte ebp-020h], edx
        add dword [MidiTickCount], byte 4
        mov eax, dword [byte ebp-020h]
        mov dword [byte ebp-018h], eax
        mov eax, dword [byte ebp+018h]
        mov dword [byte ebp-01Ch], eax
.1:
        cmp word [byte ebp+014h], byte 0
        jg short .3
        jmp near .18
.2:
        dec dword [byte ebp+014h]
        inc dword [byte ebp-01Ch]
        jmp short .1
.3:
        xor ah, ah
        mov edx, dword [byte ebp-01Ch]
        mov al, byte [edx]
        mov word [byte ebp-010h], ax
        test byte [byte ebp-010h], 80h
        je short .6
        mov al, byte [byte ebp-010h]
        and al, 0F0h
        mov byte [byte ebp-04h], al
        mov al, byte [byte ebp-010h]
        and al, 0Fh
        mov byte [byte ebp-0Ch], al
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
        mov dword [byte ebp-018h], eax
        jmp near .17
.6:
        mov al, byte [byte ebp-010h]
        mov edx, dword [byte ebp-018h]
        mov byte [edx], al
        inc dword [byte ebp-018h]
        inc dword [byte ebp-014h]
        xor eax, eax
        mov ax, word [byte ebp-014h]
        xor edx, edx
        mov dl, byte [byte ebp-08h]
        cmp eax, edx
        jne near .17
        mov dword [byte ebp-014h], 0
        mov eax, dword [byte ebp-020h]
        mov dword [byte ebp-018h], eax
        mov al, byte [byte ebp-04h]
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
        mov al, byte [byte ebp-0Ch]
        cwde
        call SbNoteOff
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
        mov al, byte [byte ebp-0Ch]
        cwde
        call SbNoteOff
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
        mov al, byte [byte ebp-0Ch]
        cwde
        call SbNoteOn
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
        mov al, byte [byte ebp-0Ch]
        cwde
        call SbController
        jmp short .17
.15:
        mov eax, dword [byte ebp-020h]
        mov al, byte [eax]
        xor ah, ah
        movsx edx, ax
        xor eax, eax
        mov al, byte [byte ebp-0Ch]
        cwde
        call SbProgramChange
        jmp short .17
.16:
        mov eax, dword [byte ebp-020h]
        mov al, byte [byte eax+01h]
        xor ah, ah
        shl eax, 8
        db 081h,0E8h,00h,040h,00h,00h           ; insn: sub eax,4000h
        movsx edx, ax
        xor eax, eax
        mov al, byte [byte ebp-0Ch]
        cwde
        call SbPitchBend
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
