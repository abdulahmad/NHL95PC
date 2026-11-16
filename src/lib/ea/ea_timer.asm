; The timer shared by the game and the libraries.
bits 32
%include "hockey.inc"
section s_8E3DC progbits alloc exec nowrite align=1
extern __GETDS, __STOSD, _dos_getvect_, _dos_setvect_, str_AddtimerLISTFULL, FatalError, oldint8off, oldint8sel
extern slowtickcount, strncmp_, strncpy_, FixedMulRound, DrawShapeStretched, AddExitHandler, bcopy, tickcount
extern timercallbacks
global ReturnPointerArg, StrCopyN, StrCompareN, MemCopyArgs, FileNamePart, FileNameOnly, TimerISR, addtimer
global RemoveTimerCallback, CountTimerCallbacks, MaskTimerKbdIrq, RestoreTimer, InstallTimer, UnmaskTimerKbdIrq, DrawShapeScaled, DrawShapeScaledAtOwnPos
global DrawShapeScaledHotspot, DrawShapeZoomedAtOwnPos, DrawShapeZoomedHotspot, DrawShapeZoomed
;-----------------------------------------------------------------------------
; ReturnPointerArg                                8E3DC  95 PC, low confidence
; Returns its argument (unused)
;-----------------------------------------------------------------------------
ReturnPointerArg:
        mov eax, dword [byte esp+04h]
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; StrCopyN                                     8E3E4  95 PC, medium confidence
; Strncpy wrapper with stack arguments
;-----------------------------------------------------------------------------
StrCopyN:
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        jmp near strncpy_
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; StrCompareN                                  8E3F8  95 PC, medium confidence
; Strncmp wrapper with stack arguments
;-----------------------------------------------------------------------------
StrCompareN:
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        jmp near strncmp_
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; MemCopyArgs                                     8E40C  95 PC, low confidence
; Copies memory (bcopy with destination first, stack arguments)
;-----------------------------------------------------------------------------
MemCopyArgs:
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+08h]
        push ebx
        mov ecx, dword [byte esp+010h]
        push ecx
        call bcopy
        add esp, byte 0Ch
        ret
;-----------------------------------------------------------------------------
; FileNamePart                                 8E424  95 PC, medium confidence
; Returns the part of a path after its last backslash, colon or slash
;-----------------------------------------------------------------------------
FileNamePart:
        mov eax, dword [byte esp+04h]
        mov edx, eax
        cmp byte [eax], 0
        je short .4
.1:
        mov cl, byte [eax]
        cmp cl, 5Ch
        je short .2
        cmp cl, 3Ah
        je short .2
        cmp cl, 2Fh
        jne short .3
.2:
        lea edx, [byte eax+01h]
.3:
        inc eax
        cmp byte [eax], 0
        jne short .1
.4:
        mov eax, edx
        ret
;-----------------------------------------------------------------------------
; FileNameOnly                                 8E44C  95 PC, medium confidence
; Stack-argument wrapper of FileNamePart
;-----------------------------------------------------------------------------
FileNameOnly:
        mov edx, dword [byte esp+04h]
        push edx
        call FileNamePart
        add esp, byte 4
        ret
        db 08Bh,0C0h
;-----------------------------------------------------------------------------
; TimerISR                                                        8E45C  95 PC
; Int 08h handler installed by InstallTimer (8E5F8 _dos_setvect_(8)): pusha +
; segment regs, __GETDS, inc tickcount,
;
; calls every non-null timercallbacks slot (8 dwords), then on every 5th tick
; incs slowtickcount and far-calls
;
; the saved vector (oldint8off/oldint8sel), else EOI (out 20h,20h); iret
;-----------------------------------------------------------------------------
TimerISR:
        pusha
        push ds
        push es
        push fs
        push gs
        mov ebp, esp
        cld
        call __GETDS
        inc dword [tickcount]
        xor edx, edx
.1:
        cmp dword [dword edx+timercallbacks], byte 0
        je short .2
        mov eax, edx
        call dword [dword eax+timercallbacks]
.2:
        add edx, byte 4
        cmp edx, byte 20h
        jne short .1
        mov ebx, 5
        mov eax, dword [tickcount]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        test edx, edx
        jne short .3
        inc dword [slowtickcount]
        pushf
        call far [oldint8off]
        jmp short .4
.3:
        mov al, 20h
        mov edx, 20h
        out dx, al
.4:
        pop gs
        pop fs
        pop es
        pop ds
        popa
        iret
;-----------------------------------------------------------------------------
; addtimer                                                        8E4C0  95 PC
; Adds a routine to the timer callback list
;-----------------------------------------------------------------------------
addtimer:
        xor eax, eax
        cmp dword [timercallbacks], byte 0
        jne short .2
.1:
        mov edx, dword [byte esp+04h]
        mov dword [dword eax+timercallbacks], edx
        ret
.2:
        add eax, byte 4
        cmp eax, byte 20h
        jge short .3
        cmp dword [dword eax+timercallbacks], byte 0
        je short .1
        jmp short .2
.3:
        push str_AddtimerLISTFULL
        call FatalError
        add esp, byte 4
        ret
        db 090h
;-----------------------------------------------------------------------------
; RemoveTimerCallback                                             8E4F8  95 PC
; Clears the timercallbacks slot equal to the stack argument (8 slots); the
; counterpart of addtimer (InputRemove, ShutdownSpeech, FadeOutPalCycle,
;
; cdstream)
;-----------------------------------------------------------------------------
RemoveTimerCallback:
        push esi
        mov edx, dword [byte esp+08h]
        xor eax, eax
        cmp edx, dword [timercallbacks]
        jne short .2
.1:
        xor esi, esi
        mov dword [dword eax+timercallbacks], esi
        pop esi
        ret
.2:
        add eax, byte 4
        cmp eax, byte 20h
        jge short .3
        cmp edx, dword [dword eax+timercallbacks]
        je short .1
        jmp short .2
.3:
        pop esi
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; CountTimerCallbacks                          8E528  95 PC, medium confidence
; Returns the number of non-null timercallbacks slots (8); no caller in the
; EXE
;-----------------------------------------------------------------------------
CountTimerCallbacks:
        xor edx, edx
        xor eax, eax
.1:
        cmp dword [dword eax+timercallbacks], byte 0
        je short .2
        inc edx
.2:
        add eax, byte 4
        cmp eax, byte 20h
        jne short .1
        mov eax, edx
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; MaskTimerKbdIrq                                                 8E544  95 PC
; In al,21h / or al,3 / out 21h: masks IRQ0 (timer) and IRQ1 (keyboard) at the
; master PIC; used by InstallTimer and RestoreTimer around the vector swap
;-----------------------------------------------------------------------------
MaskTimerKbdIrq:
        push edx
        mov edx, 21h
        sub eax, eax
        in al, dx
        or al, 3
        out dx, al
        pop edx
        ret
        db 08Bh,0C0h
;-----------------------------------------------------------------------------
; RestoreTimer                                                    8E554  95 PC
; When a vector is saved: masks IRQ0/1, _dos_setvect_(8) back to
; oldint8off/oldint8sel, PIT channel 0 divisor 0 (18.2 Hz),
;
; clears the saved vector, unmasks; the atexit handler InstallTimer registers
;-----------------------------------------------------------------------------
RestoreTimer:
        push ebx
        push ecx
        push edx
        cmp dword [oldint8off], byte 0
        jne short .1
        cmp word [oldint8sel], byte 0
        je short .2
.1:
        call MaskTimerKbdIrq
        mov cx, word [oldint8sel]
        mov ebx, dword [oldint8off]
        mov eax, 8
        call _dos_setvect_
        xor al, al
        mov edx, 40h
        out dx, al
        out dx, al
        xor ebx, ebx
        mov word [oldint8sel], bx
        xor ebx, ebx
        mov dword [oldint8off], ebx
        call UnmaskTimerKbdIrq
.2:
        pop edx
        pop ecx
        pop ebx
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; InstallTimer                                                    8E5AC  95 PC
; Allocates the timer stack, masks the timer and installs the timer interrupt
;-----------------------------------------------------------------------------
InstallTimer:
        mov ecx, 8
        xor edx, edx
        mov eax, timercallbacks
        call __STOSD
        cmp dword [oldint8off], byte 0
        jne short RestoreTimer+054h
        cmp word [oldint8sel], byte 0
        jne short RestoreTimer+054h
        call MaskTimerKbdIrq
        mov eax, 8
        call _dos_getvect_
        mov word [oldint8sel], dx
        mov dword [oldint8off], eax
        mov al, 9Ch
        mov edx, 40h
        out dx, al
        mov al, 2Eh
        out dx, al
        mov ecx, cs
        mov ebx, TimerISR
        mov eax, 8
        call _dos_setvect_
        push RestoreTimer
        call AddExitHandler
        add esp, byte 4
;-----------------------------------------------------------------------------
; UnmaskTimerKbdIrq                                               8E614  95 PC
; In al,21h / and al,0FCh / out 21h: unmasks IRQ0 and IRQ1; tail of
; InstallTimer, called by RestoreTimer
;-----------------------------------------------------------------------------
UnmaskTimerKbdIrq:
        push edx
        mov edx, 21h
        sub eax, eax
        in al, dx
        and al, 0FCh
        out dx, al
        pop edx
        ret
        db 08Bh,0C0h
;-----------------------------------------------------------------------------
; DrawShapeScaled                                 8E624  95 PC, low confidence
; Draws a shape scaled by 16.16 factors at a position
;-----------------------------------------------------------------------------
DrawShapeScaled:
        push esi
        push edi
        push ebp
        sub esp, byte 20h
        mov ebp, dword [byte esp+034h]
        mov edi, dword [byte esp+038h]
        mov eax, dword [byte ebp+02h]
        sar eax, 10h
        push eax
        mov edx, dword [byte esp+034h]
        push edx
        call FixedMulRound
        mov esi, eax
        add esp, byte 8
        mov eax, dword [byte ebp+04h]
        sar eax, 10h
        push eax
        mov ebx, dword [byte esp+034h]
        push ebx
        call FixedMulRound
        mov edx, eax
        add esp, byte 8
        mov dword [esp], edi
        mov eax, dword [byte esp+03Ch]
        mov dword [byte esp+04h], eax
        lea eax, [edi+esi]
        mov dword [byte esp+08h], eax
        mov eax, dword [byte esp+03Ch]
        mov dword [byte esp+0Ch], eax
        mov eax, dword [byte esp+08h]
        mov dword [byte esp+010h], eax
        mov eax, dword [byte esp+03Ch]
        add eax, edx
        mov dword [byte esp+014h], eax
        mov dword [byte esp+018h], edi
        mov dword [byte esp+01Ch], eax
        mov eax, esp
        push eax
        push ebp
        call DrawShapeStretched
        add esp, byte 8
        add esp, byte 20h
        pop ebp
        pop edi
        pop esi
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; DrawShapeScaledAtOwnPos                         8E6A8  95 PC, low confidence
; DrawShapeScaled at the shape's own position (unused)
;-----------------------------------------------------------------------------
DrawShapeScaledAtOwnPos:
        mov edx, dword [byte esp+08h]
        mov eax, dword [byte edx+0Ch]
        sar eax, 10h
        push eax
        mov eax, dword [byte edx+0Ah]
        sar eax, 10h
        push eax
        push edx
        mov edx, dword [byte esp+010h]
        push edx
        call DrawShapeScaled
        add esp, byte 10h
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; DrawShapeScaledHotspot                          8E6CC  95 PC, low confidence
; DrawShapeScaled with the scaled hotspot taken off the position (unused)
;-----------------------------------------------------------------------------
DrawShapeScaledHotspot:
        push esi
        push edi
        mov edi, dword [byte esp+0Ch]
        mov esi, dword [byte esp+010h]
        mov eax, dword [byte esi+06h]
        sar eax, 10h
        push eax
        push edi
        call FixedMulRound
        add esp, byte 8
        mov edx, dword [byte esp+018h]
        sub edx, eax
        push edx
        mov eax, dword [byte esi+06h]
        sar eax, 10h
        push eax
        push edi
        call FixedMulRound
        add esp, byte 8
        mov edx, dword [byte esp+018h]
        sub edx, eax
        push edx
        push esi
        push edi
        call DrawShapeScaled
        add esp, byte 10h
        pop edi
        pop esi
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; DrawShapeZoomedAtOwnPos                         8E714  95 PC, low confidence
; Second copy of DrawShapeScaledAtOwnPos (unused)
;-----------------------------------------------------------------------------
DrawShapeZoomedAtOwnPos:
        mov edx, dword [byte esp+08h]
        mov eax, dword [byte edx+0Ch]
        sar eax, 10h
        push eax
        mov eax, dword [byte edx+0Ah]
        sar eax, 10h
        push eax
        push edx
        mov edx, dword [byte esp+010h]
        push edx
        call DrawShapeScaled
        add esp, byte 10h
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; DrawShapeZoomedHotspot                          8E738  95 PC, low confidence
; Second copy of DrawShapeScaledHotspot (unused)
;-----------------------------------------------------------------------------
DrawShapeZoomedHotspot:
        push esi
        push edi
        mov edi, dword [byte esp+0Ch]
        mov esi, dword [byte esp+010h]
        mov eax, dword [byte esi+06h]
        sar eax, 10h
        push eax
        push edi
        call FixedMulRound
        add esp, byte 8
        mov edx, dword [byte esp+018h]
        sub edx, eax
        push edx
        mov eax, dword [byte esi+06h]
        sar eax, 10h
        push eax
        push edi
        call FixedMulRound
        add esp, byte 8
        mov edx, dword [byte esp+018h]
        sub edx, eax
        push edx
        push esi
        push edi
        call DrawShapeScaled
        add esp, byte 10h
        pop edi
        pop esi
        ret
        db 08Dh,040h,00h
;-----------------------------------------------------------------------------
; DrawShapeZoomed                                 8E780  95 PC, low confidence
; Passes its arguments on to DrawShapeScaled (unused)
;-----------------------------------------------------------------------------
DrawShapeZoomed:
        push esi
        mov edx, dword [byte esp+014h]
        push edx
        mov ebx, dword [byte esp+014h]
        push ebx
        mov ecx, dword [byte esp+014h]
        push ecx
        mov esi, dword [byte esp+014h]
        push esi
        call DrawShapeScaled
        add esp, byte 10h
        pop esi
        ret
        db 00h
