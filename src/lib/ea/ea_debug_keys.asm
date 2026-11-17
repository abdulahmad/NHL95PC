; EA debug console: date stamps, free file names and debug key input.
bits 32
%include "hockey.inc"
section s_9602E progbits alloc exec nowrite align=1
extern _dos_getdate_, _dos_gettime_, DebugLastKey, DebugWaitKey, FindFirstFile, KbdFlush, MonthNameTable, ReturnFalse
extern sprintf_, str_2d02d02d2, str_DateTimeFmt, ToUpperChar
global FormatDateTime, NextFreeFileName, DebugGetKeyUpper, DebugPressAnyKey, DebugKbdFlush, DebugFlushAndWait
        db 08Bh,0C0h
;-----------------------------------------------------------------------------
; FormatDateTime                               96030  95 PC, medium confidence
; Formats the current DOS date and time as strings
;-----------------------------------------------------------------------------
FormatDateTime:
        push ebx
        push ecx
        push esi
        sub esp, byte 0Ch
        mov ebx, eax
        mov ecx, edx
        mov eax, esp
        call _dos_getdate_
        lea eax, [byte esp+08h]
        call _dos_gettime_
        xor edx, edx
        mov dx, word [byte esp+02h]
        mov esi, 64h
        mov eax, edx
        sar edx, 1Fh
        idiv esi
        push edx
        xor eax, eax
        mov al, byte [byte esp+05h]
        mov edx, dword [nosplit eax*4+MonthNameTable]
        push edx
        xor eax, eax
        mov al, byte [byte esp+08h]
        push eax
        push str_DateTimeFmt
        push ebx
        call sprintf_
        add esp, byte 14h
        xor eax, eax
        mov al, byte [byte esp+0Ah]
        push eax
        xor eax, eax
        mov al, byte [byte esp+0Dh]
        push eax
        xor eax, eax
        mov al, byte [byte esp+010h]
        push eax
        push str_2d02d02d2
        push ecx
        call sprintf_
        add esp, byte 14h
        add esp, byte 0Ch
        pop esi
        pop ecx
        pop ebx
        ret
        db 090h
;-----------------------------------------------------------------------------
; NextFreeFileName                             960AC  95 PC, medium confidence
; Fills in the ?? of a file name pattern with the first number not in use
;-----------------------------------------------------------------------------
NextFreeFileName:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov dword [esp], eax
        xor edi, edi
        cmp byte [eax], 3Fh
        je short .2
.1:
        inc eax
        inc edi
        cmp byte [eax], 3Fh
        jne short .1
.2:
        xor esi, esi
        mov ebp, eax
.3:
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        mov ebx, 0Ah
        idiv ebx
        and eax, 0FFh
        add eax, byte 30h
        mov byte [byte ebp+00h], al
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ebx
        xor eax, eax
        mov al, dl
        add eax, byte 30h
        mov byte [byte ebp+01h], al
        mov edx, dword [esp]
        push edx
        call FindFirstFile
        add esp, byte 4
        test eax, eax
        je short .4
        inc esi
        cmp esi, byte 64h
        jl short .3
.4:
        cmp esi, byte 64h
        jl short .5
        add edi, dword [esp]
        mov byte [byte edi+01h], 78h
        mov al, byte [byte edi+01h]
        mov byte [edi], al
.5:
        mov eax, 1
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; DebugGetKeyUpper                                9612C  95 PC, low confidence
; Waits for a key and returns it in upper case
;-----------------------------------------------------------------------------
DebugGetKeyUpper:
        push ebx
        push ecx
        push edx
        call ReturnFalse
        call DebugWaitKey
        mov dword [DebugLastKey], eax
        pop edx
        pop ecx
        pop ebx
        ret
        db 08Bh,0C0h
;-----------------------------------------------------------------------------
; DebugPressAnyKey                                96144  95 PC, low confidence
; Flushes the keyboard, waits for a key and returns it in upper case
;-----------------------------------------------------------------------------
DebugPressAnyKey:
        push ebx
        push ecx
        push edx
        call ReturnFalse
        call DebugKbdFlush
        call DebugFlushAndWait
        push eax
        call ToUpperChar
        add esp, byte 4
        pop edx
        pop ecx
        pop ebx
        ret
        db 090h
;-----------------------------------------------------------------------------
; DebugKbdFlush                                   96164  95 PC, low confidence
; Flushes the keyboard buffer
;-----------------------------------------------------------------------------
DebugKbdFlush:
        push ebx
        push ecx
        push edx
        call KbdFlush
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; DebugFlushAndWait                               96170  95 PC, low confidence
; Flushes the keyboard and waits for a key
;-----------------------------------------------------------------------------
DebugFlushAndWait:
        push ebx
        push ecx
        push edx
        call KbdFlush
.1:
        call DebugGetKeyUpper
        test eax, eax
        je short .1
        pop edx
        pop ecx
        pop ebx
        ret
