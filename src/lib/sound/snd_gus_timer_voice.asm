; Gravis UltraSound: timers and voice allocation.
bits 32
%include "hockey.inc"
section s_B19E0 progbits alloc exec nowrite align=1
extern GusActiveVoices, GusDataHighPort, GusDataLowPort, GusDramPort, GusEnterCritical, GusLeaveCritical, GusRegSelectPort, GusSetVoiceCallbacks
extern GusTimer1Count, GusTimer2Count, GusTimerCtrl, GusTimerState, GusVoiceAllocAge, GusVoiceAllocCtrl, GusVoiceAllocMask, GusVoiceIrqBits
extern GusVoicePrioHi, GusVoicePrioLo, GusVoiceStealFn, inp_, outp_, outpw_
global GusResetTimers, GusStartTimer2, GusStartTimer1, GusStopTimer1, GusStopTimer2, GusResetVoiceAlloc, GusAllocVoice, GusReleaseVoice
global GusAddVoicePriority, GusPeek, GusPoke, GusPokeFill, GusTestDramBank
;-----------------------------------------------------------------------------
; GusResetTimers                                  B19E0  95 PC, low confidence
; Clears the timer state
;-----------------------------------------------------------------------------
GusResetTimers:
        push ebp
        mov ebp, esp
        push edx
        mov ah, 1
        xor edx, edx
        mov byte [GusTimerCtrl], ah
        mov dword [GusTimerState], edx
        xor dl, dl
        xor eax, eax
        mov byte [GusVoiceIrqBits], dl
        lea esp, [byte ebp-04h]
        pop edx
        pop ebp
        ret
;-----------------------------------------------------------------------------
; GusStartTimer2                               B1A04  95 PC, medium confidence
; Sets the callback and count for card timer 2 and starts it
;-----------------------------------------------------------------------------
GusStartTimer2:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        mov ebx, eax
        mov ecx, edx
        pushfw
        cli
        call GusEnterCritical
        mov eax, 2
        mov edx, ebx
        call GusSetVoiceCallbacks
        mov ebx, eax
        test eax, eax
        je short .1
        call GusLeaveCritical
        popfw
        mov eax, ebx
        jmp near .2
.1:
        mov edx, 47h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, ecx
        mov ax, word [GusDataHighPort]
        call outp_
        or byte [GusVoiceIrqBits], 8
        xor eax, eax
        mov edx, 45h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor edx, edx
        xor eax, eax
        mov dl, byte [GusVoiceIrqBits]
        mov ax, word [GusDataHighPort]
        call outp_
        mov dl, byte [GusTimerState]
        xor eax, eax
        or dl, 2
        mov ax, word [GusTimer1Count]
        mov byte [GusTimerState], dl
        mov edx, 4
        call outp_
        xor eax, eax
        mov edx, dword [GusTimerState]
        mov ax, word [GusTimer2Count]
        call outp_
        call GusLeaveCritical
        popfw
        xor eax, eax
.2:
        lea esp, [byte ebp-08h]
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Bh,0C0h
;-----------------------------------------------------------------------------
; GusStartTimer1                               B1AC8  95 PC, medium confidence
; Sets the callback and count for card timer 1 and starts it
;-----------------------------------------------------------------------------
GusStartTimer1:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        mov ebx, eax
        mov ecx, edx
        pushfw
        cli
        call GusEnterCritical
        mov eax, 1
        mov edx, ebx
        call GusSetVoiceCallbacks
        mov ebx, eax
        test eax, eax
        je short .1
        call GusLeaveCritical
        popfw
        mov eax, ebx
        jmp near .2
.1:
        mov edx, 46h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, ecx
        mov ax, word [GusDataHighPort]
        call outp_
        or byte [GusVoiceIrqBits], 4
        xor eax, eax
        mov edx, 45h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor edx, edx
        xor eax, eax
        mov dl, byte [GusVoiceIrqBits]
        mov ax, word [GusDataHighPort]
        call outp_
        mov dl, byte [GusTimerState]
        xor eax, eax
        or dl, 1
        mov ax, word [GusTimer1Count]
        mov byte [GusTimerState], dl
        mov edx, 4
        call outp_
        xor eax, eax
        mov edx, dword [GusTimerState]
        mov ax, word [GusTimer2Count]
        call outp_
        call GusLeaveCritical
        popfw
        xor eax, eax
.2:
        lea esp, [byte ebp-08h]
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Bh,0C0h
;-----------------------------------------------------------------------------
; GusStopTimer1                                B1B8C  95 PC, medium confidence
; Stops card timer 1
;-----------------------------------------------------------------------------
GusStopTimer1:
        push ebp
        mov ebp, esp
        push edx
        pushfw
        cli
        call GusEnterCritical
        mov eax, 1
        xor edx, edx
        call GusSetVoiceCallbacks
        mov ah, byte [GusVoiceIrqBits]
        mov dl, byte [GusTimerState]
        and ah, 0FBh
        and dl, 0FEh
        mov byte [GusVoiceIrqBits], ah
        mov byte [GusTimerState], dl
        xor eax, eax
        mov edx, 45h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor edx, edx
        xor eax, eax
        mov dl, byte [GusVoiceIrqBits]
        mov ax, word [GusDataHighPort]
        call outp_
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-04h]
        pop edx
        pop ebp
        ret
        db 08Bh,0C0h
;-----------------------------------------------------------------------------
; GusStopTimer2                                B1BF8  95 PC, medium confidence
; Stops card timer 2
;-----------------------------------------------------------------------------
GusStopTimer2:
        push ebp
        mov ebp, esp
        push edx
        pushfw
        cli
        call GusEnterCritical
        mov eax, 2
        xor edx, edx
        call GusSetVoiceCallbacks
        mov ah, byte [GusVoiceIrqBits]
        mov dl, byte [GusTimerState]
        and ah, 0F7h
        and dl, 0FDh
        mov byte [GusVoiceIrqBits], ah
        mov byte [GusTimerState], dl
        xor eax, eax
        mov edx, 45h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor edx, edx
        xor eax, eax
        mov dl, byte [GusVoiceIrqBits]
        mov ax, word [GusDataHighPort]
        call outp_
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-04h]
        pop edx
        pop ebp
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
;-----------------------------------------------------------------------------
; GusResetVoiceAlloc                              B1C70  95 PC, low confidence
; Marks every voice free
;-----------------------------------------------------------------------------
GusResetVoiceAlloc:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        mov ah, 1
        xor edx, edx
        xor ebx, ebx
        mov byte [GusVoiceAllocCtrl], ah
        mov dword [GusVoiceAllocMask], edx
        jmp short .2
.1:
        xor edx, edx
        mov dx, bx
        lea eax, [nosplit edx*4+00h]
        sub eax, edx
        xor ecx, ecx
        mov dword [nosplit eax*4+GusVoicePrioLo], ecx
        inc ebx
        mov dword [nosplit eax*4+GusVoicePrioHi], ecx
.2:
        cmp bx, word [GusActiveVoices]
        jb short .1
        xor eax, eax
        lea esp, [byte ebp-0Ch]
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
;-----------------------------------------------------------------------------
; GusAllocVoice                                   B1CBC  95 PC, low confidence
; Finds a free voice or steals one
;-----------------------------------------------------------------------------
GusAllocVoice:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 0Ch
        mov esi, eax
        mov edi, edx
        pushfw
        cli
        call GusEnterCritical
        mov edx, 0FFFFFFFFh
        mov ebx, 1
        mov dword [byte ebp-018h], edx
        mov dword [byte ebp-014h], ebx
        xor ebx, ebx
        jmp near .6
.1:
        mov eax, 1
        mov ecx, ebx
        shl eax, cl
        mov ecx, eax
        mov eax, dword [GusVoiceAllocMask]
        test ecx, eax
        jne short .2
        mov edx, eax
        or edx, ecx
        mov dword [GusVoiceAllocMask], edx
        and ebx, 0FFFFh
        lea eax, [nosplit ebx*4+00h]
        sub eax, ebx
        mov edx, dword [GusVoiceAllocAge]
        mov dword [nosplit eax*4+GusVoicePrioHi], esi
        mov dword [nosplit eax*4+GusVoicePrioLo], edx
        inc edx
        mov dword [nosplit eax*4+GusVoiceStealFn], edi
        mov dword [GusVoiceAllocAge], edx
        call GusLeaveCritical
        popfw
        mov eax, ebx
        jmp near .9
.2:
        xor eax, eax
        mov ax, bx
        mov dword [byte ebp-01Ch], eax
        mov ecx, dword [byte ebp-01Ch]
        shl eax, 2
        sub eax, ecx
        shl eax, 2
        mov ecx, dword [dword eax+GusVoicePrioHi]
        cmp ecx, dword [byte ebp-014h]
        jb short .5
        ja short .3
        mov ecx, dword [byte ebp-018h]
        cmp ecx, dword [dword eax+GusVoicePrioLo]
        jbe short .4
.3:
        xor ecx, ecx
        mov cx, bx
        lea eax, [nosplit ecx*4+00h]
        sub eax, ecx
        mov eax, dword [nosplit eax*4+GusVoicePrioLo]
        mov edx, ecx
        mov dword [byte ebp-018h], eax
.4:
        xor eax, eax
        mov ax, bx
        mov dword [byte ebp-01Ch], eax
        mov ecx, dword [byte ebp-01Ch]
        shl eax, 2
        sub eax, ecx
        mov eax, dword [nosplit eax*4+GusVoicePrioHi]
        mov dword [byte ebp-014h], eax
.5:
        inc ebx
.6:
        cmp bx, word [GusActiveVoices]
        jb near .1
        cmp edx, byte 0FFFFFFFFh
        je short .8
        lea eax, [nosplit edx*4+00h]
        sub eax, edx
        shl eax, 2
        cmp dword [dword eax+GusVoiceStealFn], byte 0
        je short .7
        mov ebx, eax
        mov eax, edx
        call dword [dword ebx+GusVoiceStealFn]
.7:
        mov eax, 1
        mov cl, dl
        shl eax, cl
        mov ecx, dword [GusVoiceAllocMask]
        or ecx, eax
        lea eax, [nosplit edx*4+00h]
        sub eax, edx
        mov ebx, dword [GusVoiceAllocAge]
        mov dword [nosplit eax*4+GusVoicePrioHi], esi
        mov dword [GusVoiceAllocMask], ecx
        mov dword [nosplit eax*4+GusVoicePrioLo], ebx
        inc ebx
        mov dword [nosplit eax*4+GusVoiceStealFn], edi
        mov dword [GusVoiceAllocAge], ebx
.8:
        call GusLeaveCritical
        popfw
        mov eax, edx
.9:
        lea esp, [byte ebp-010h]
        pop edi
        pop esi
        pop ecx
        pop ebx
        pop ebp
        ret
        db 090h
;-----------------------------------------------------------------------------
; GusReleaseVoice                                 B1E2C  95 PC, low confidence
; Marks a voice free
;-----------------------------------------------------------------------------
GusReleaseVoice:
        push ebp
        mov ebp, esp
        push ecx
        push edx
        mov ecx, eax
        pushfw
        cli
        call GusEnterCritical
        mov eax, 1
        shl eax, cl
        mov ecx, eax
        mov edx, dword [GusVoiceAllocMask]
        not ecx
        and edx, ecx
        mov dword [GusVoiceAllocMask], edx
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-08h]
        pop edx
        pop ecx
        pop ebp
        ret
        db 08Bh,0C0h
;-----------------------------------------------------------------------------
; GusAddVoicePriority                             B1E64  95 PC, low confidence
; Adds to a voice's priority value
;-----------------------------------------------------------------------------
GusAddVoicePriority:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        mov ecx, eax
        mov ebx, edx
        pushfw
        cli
        mov edx, ecx
        call GusEnterCritical
        lea eax, [nosplit edx*4+00h]
        sub eax, edx
        add dword [nosplit eax*4+GusVoicePrioHi], ebx
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-08h]
        pop ecx
        pop ebx
        pop ebp
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
;-----------------------------------------------------------------------------
; GusPeek                                                         B1EA0  95 PC
; Reads one byte of card memory
;-----------------------------------------------------------------------------
GusPeek:
        push ebp
        mov ebp, esp
        push ebx
        push edx
        mov ebx, eax
        pushfw
        cli
        call GusEnterCritical
        xor eax, eax
        mov edx, 43h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, ebx
        mov ax, word [GusDataLowPort]
        call outpw_
        shr ebx, 10h
        xor eax, eax
        mov edx, 44h
        mov ax, word [GusRegSelectPort]
        and ebx, 0FFh
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, bl
        call outp_
        xor eax, eax
        mov ax, word [GusDramPort]
        call inp_
        mov ebx, eax
        call GusLeaveCritical
        popfw
        mov al, bl
        lea esp, [byte ebp-08h]
        pop edx
        pop ebx
        pop ebp
        ret
        db 090h
;-----------------------------------------------------------------------------
; GusPoke                                                         B1F1C  95 PC
; Writes one byte of card memory
;-----------------------------------------------------------------------------
GusPoke:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        mov ebx, eax
        mov cl, dl
        pushfw
        cli
        call GusEnterCritical
        xor eax, eax
        mov edx, 43h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, ebx
        mov ax, word [GusDataLowPort]
        call outpw_
        shr ebx, 10h
        xor eax, eax
        mov edx, 44h
        mov ax, word [GusRegSelectPort]
        and ebx, 0FFh
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, bl
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDramPort]
        mov dl, cl
        call outp_
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-08h]
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; GusPokeFill                                  B1F9C  95 PC, medium confidence
; Writes a run of bytes (optionally sign-flipped) into card memory through
; the register ports
;-----------------------------------------------------------------------------
GusPokeFill:
        push ebp
        mov ebp, esp
        push esi
        sub esp, byte 10h
        mov esi, eax
        mov al, cl
        mov ah, cl
        and ah, 40h
        mov ecx, edx
        mov byte [byte ebp-08h], ah
        shr edx, 10h
        xor ah, ah
        mov byte [byte ebp-014h], dl
        mov byte [byte ebp-010h], ah
        test al, 80h
        je short .1
        mov al, 80h
        jmp short .2
.1:
        xor al, al
.2:
        mov byte [byte ebp-0Ch], al
        pushfw
        cli
        call GusEnterCritical
.3:
        test ebx, ebx
        je near .8
        xor eax, eax
        mov edx, 44h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor edx, edx
        xor eax, eax
        mov dl, byte [byte ebp-014h]
        mov ax, word [GusDataHighPort]
        call outp_
        inc byte [byte ebp-014h]
.4:
        xor eax, eax
        mov edx, 43h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataLowPort]
        mov dx, cx
        inc esi
        call outpw_
        mov ah, byte [byte ebp-0Ch]
        mov dl, byte [byte ebp-08h]
        mov al, byte [byte esi-01h]
        inc ecx
        xor ah, al
        test dl, dl
        je short .6
        cmp byte [byte ebp-010h], 0
        je short .5
        mov al, ah
.5:
        xor byte [byte ebp-010h], 1
        jmp short .7
.6:
        mov al, ah
.7:
        xor edx, edx
        mov dl, al
        xor eax, eax
        mov ax, word [GusDramPort]
        call outp_
        dec ebx
        je near .3
        test cx, cx
        jne short .4
        jmp near .3
.8:
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-04h]
        pop esi
        pop ebp
        ret
;-----------------------------------------------------------------------------
; GusTestDramBank                              B2074  95 PC, medium confidence
; Writes and reads back test bytes to check whether a bank of card memory
; exists
;-----------------------------------------------------------------------------
GusTestDramBank:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 18h
        mov ebx, eax
        mov ecx, eax
        call GusPeek
        xor cl, 20h
        mov byte [byte ebp-028h], al
        mov byte [byte ebp-01Ch], al
        mov eax, ecx
        mov edx, 55h
        call GusPeek
        mov byte [byte ebp-020h], al
        mov byte [byte ebp-018h], al
        mov eax, ebx
        call GusPoke
        mov eax, ecx
        xor edx, edx
        call GusPoke
        mov eax, ebx
        call GusPeek
        cmp al, 55h
        je short .1
        xor al, al
        jmp near .10
.1:
        mov eax, ebx
        xor edx, edx
        call GusPoke
        mov edx, 55h
        mov eax, ecx
        call GusPoke
        mov eax, ebx
        call GusPeek
        test al, al
        je short .2
        xor al, al
        lea esp, [byte ebp-014h]
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
.2:
        mov edx, 0AAh
        mov eax, ebx
        call GusPoke
        mov eax, ecx
        xor edx, edx
        call GusPoke
        mov eax, ebx
        call GusPeek
        cmp al, 0AAh
        je short .3
        xor al, al
        lea esp, [byte ebp-014h]
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
.3:
        mov edx, 0FFh
        mov eax, ebx
        call GusPoke
        mov eax, ecx
        xor edx, edx
        call GusPoke
        mov eax, ebx
        call GusPeek
        cmp al, 0FFh
        je short .4
        xor al, al
        lea esp, [byte ebp-014h]
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
.4:
        cmp ebx, 3FFFFh
        ja short .5
        xor edx, edx
        mov eax, ebx
        mov dl, byte [byte ebp-028h]
        call GusPoke
        xor edx, edx
        mov eax, ecx
        mov dl, byte [byte ebp-020h]
        call GusPoke
        mov al, 1
        lea esp, [byte ebp-014h]
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
.5:
        mov edx, ebx
        shr edx, 12h
        xor edi, edi
        mov dword [byte ebp-02Ch], edx
        jmp short .8
.6:
        cmp di, word [byte ebp-02Ch]
        je short .9
        xor edx, edx
        mov esi, ebx
        mov dx, di
        and esi, 3FFFFh
        shl edx, 12h
        or esi, edx
        mov eax, esi
        mov edx, 0AAh
        call GusPeek
        mov byte [byte ebp-024h], al
        mov eax, esi
        call GusPoke
        mov eax, ecx
        xor edx, edx
        call GusPoke
        mov eax, ebx
        call GusPeek
        cmp al, 0AAh
        jne short .7
        xor edx, edx
        mov eax, ebx
        mov dl, byte [byte ebp-01Ch]
        call GusPoke
        xor edx, edx
        mov eax, ecx
        mov dl, byte [byte ebp-018h]
        call GusPoke
        xor al, al
        lea esp, [byte ebp-014h]
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
.7:
        xor edx, edx
        mov eax, esi
        mov dl, byte [byte ebp-024h]
        inc edi
        call GusPoke
.8:
        cmp di, byte 4
        jne short .6
.9:
        xor edx, edx
        mov eax, ebx
        mov dl, byte [byte ebp-01Ch]
        call GusPoke
        xor edx, edx
        mov eax, ecx
        mov dl, byte [byte ebp-018h]
        call GusPoke
        mov al, 2
.10:
        lea esp, [byte ebp-014h]
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 00h,00h
