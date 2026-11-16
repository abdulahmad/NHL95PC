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
ReturnPointerArg:
        mov eax, dword [byte esp+04h]
        ret
        db 08Dh,040h,00h
StrCopyN:
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        jmp near strncpy_
        db 08Dh,040h,00h
StrCompareN:
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        jmp near strncmp_
        db 08Dh,040h,00h
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
FileNameOnly:
        mov edx, dword [byte esp+04h]
        push edx
        call FileNamePart
        add esp, byte 4
        ret
        db 08Bh,0C0h
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
