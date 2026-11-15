; The timer shared by the game and the libraries.
bits 32
%include "hockey.inc"
section s_8E3DC progbits alloc exec nowrite align=1
extern __GETDS, __STOSD, _dos_getvect_, _dos_setvect_, str_AddtimerLISTFULL, FatalError, oldint8off, oldint8sel
extern slowtickcount, strncmp_, strncpy_, sub_91FA4, sub_98B30, sub_B3454, sub_B3ABC, tickcount
extern timercallbacks
global sub_8E3DC, sub_8E3E4, sub_8E3F8, sub_8E40C, sub_8E424, loc_8E42F, loc_8E440, loc_8E443
global loc_8E449, sub_8E44C, TimerISR, loc_8E473, loc_8E484, loc_8E4B0, loc_8E4B8, addtimer
global loc_8E4CB, loc_8E4D6, loc_8E4E9, sub_8E4F3, RemoveTimerCallback, loc_8E507, loc_8E511, loc_8E523
global CountTimerCallbacks, loc_8E52C, loc_8E536, MaskTimerKbdIrq, RestoreTimer, loc_8E56A, loc_8E5A5, loc_8E5A8
global InstallTimer, UnmaskTimerKbdIrq, sub_8E624, sub_8E6A8, sub_8E6CC, sub_8E714, sub_8E738, sub_8E780
sub_8E3DC:
        mov eax, dword [byte esp+04h]
        ret
        db 08Dh,040h,00h
sub_8E3E4:
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        jmp near strncpy_
        db 08Dh,040h,00h
sub_8E3F8:
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ebx, dword [byte esp+0Ch]
        jmp near strncmp_
        db 08Dh,040h,00h
sub_8E40C:
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ebx, dword [byte esp+08h]
        push ebx
        mov ecx, dword [byte esp+010h]
        push ecx
        call sub_B3ABC
        add esp, byte 0Ch
        ret
sub_8E424:
        mov eax, dword [byte esp+04h]
        mov edx, eax
        cmp byte [eax], 0
        je short loc_8E449
loc_8E42F:
        mov cl, byte [eax]
        cmp cl, 5Ch
        je short loc_8E440
        cmp cl, 3Ah
        je short loc_8E440
        cmp cl, 2Fh
        jne short loc_8E443
loc_8E440:
        lea edx, [byte eax+01h]
loc_8E443:
        inc eax
        cmp byte [eax], 0
        jne short loc_8E42F
loc_8E449:
        mov eax, edx
        ret
sub_8E44C:
        mov edx, dword [byte esp+04h]
        push edx
        call sub_8E424
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
loc_8E473:
        cmp dword [dword edx+timercallbacks], byte 0
        je short loc_8E484
        mov eax, edx
        call dword [dword eax+timercallbacks]
loc_8E484:
        add edx, byte 4
        cmp edx, byte 20h
        jne short loc_8E473
        mov ebx, 5
        mov eax, dword [tickcount]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        test edx, edx
        jne short loc_8E4B0
        inc dword [slowtickcount]
        pushf
        call far [oldint8off]
        jmp short loc_8E4B8
loc_8E4B0:
        mov al, 20h
        mov edx, 20h
        out dx, al
loc_8E4B8:
        pop gs
        pop fs
        pop es
        pop ds
        popa
        iret
addtimer:
        xor eax, eax
        cmp dword [timercallbacks], byte 0
        jne short loc_8E4D6
loc_8E4CB:
        mov edx, dword [byte esp+04h]
        mov dword [dword eax+timercallbacks], edx
        ret
loc_8E4D6:
        add eax, byte 4
        cmp eax, byte 20h
        jge short loc_8E4E9
        cmp dword [dword eax+timercallbacks], byte 0
        je short loc_8E4CB
        jmp short loc_8E4D6
loc_8E4E9:
        push str_AddtimerLISTFULL
        call FatalError
sub_8E4F3:
        add esp, byte 4
        ret
        db 090h
RemoveTimerCallback:
        push esi
        mov edx, dword [byte esp+08h]
        xor eax, eax
        cmp edx, dword [timercallbacks]
        jne short loc_8E511
loc_8E507:
        xor esi, esi
        mov dword [dword eax+timercallbacks], esi
        pop esi
        ret
loc_8E511:
        add eax, byte 4
        cmp eax, byte 20h
        jge short loc_8E523
        cmp edx, dword [dword eax+timercallbacks]
        je short loc_8E507
        jmp short loc_8E511
loc_8E523:
        pop esi
        ret
        db 08Dh,040h,00h
CountTimerCallbacks:
        xor edx, edx
        xor eax, eax
loc_8E52C:
        cmp dword [dword eax+timercallbacks], byte 0
        je short loc_8E536
        inc edx
loc_8E536:
        add eax, byte 4
        cmp eax, byte 20h
        jne short loc_8E52C
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
        jne short loc_8E56A
        cmp word [oldint8sel], byte 0
        je short loc_8E5A5
loc_8E56A:
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
loc_8E5A5:
        pop edx
        pop ecx
        pop ebx
loc_8E5A8:
        ret
        db 08Dh,040h,00h
InstallTimer:
        mov ecx, 8
        xor edx, edx
        mov eax, timercallbacks
        call __STOSD
        cmp dword [oldint8off], byte 0
        jne short loc_8E5A8
        cmp word [oldint8sel], byte 0
        jne short loc_8E5A8
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
        call sub_B3454
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
sub_8E624:
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
        call sub_91FA4
        mov esi, eax
        add esp, byte 8
        mov eax, dword [byte ebp+04h]
        sar eax, 10h
        push eax
        mov ebx, dword [byte esp+034h]
        push ebx
        call sub_91FA4
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
        call sub_98B30
        add esp, byte 8
        add esp, byte 20h
        pop ebp
        pop edi
        pop esi
        ret
        db 08Dh,040h,00h
sub_8E6A8:
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
        call sub_8E624
        add esp, byte 10h
        ret
        db 08Dh,040h,00h
sub_8E6CC:
        push esi
        push edi
        mov edi, dword [byte esp+0Ch]
        mov esi, dword [byte esp+010h]
        mov eax, dword [byte esi+06h]
        sar eax, 10h
        push eax
        push edi
        call sub_91FA4
        add esp, byte 8
        mov edx, dword [byte esp+018h]
        sub edx, eax
        push edx
        mov eax, dword [byte esi+06h]
        sar eax, 10h
        push eax
        push edi
        call sub_91FA4
        add esp, byte 8
        mov edx, dword [byte esp+018h]
        sub edx, eax
        push edx
        push esi
        push edi
        call sub_8E624
        add esp, byte 10h
        pop edi
        pop esi
        ret
        db 08Dh,040h,00h
sub_8E714:
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
        call sub_8E624
        add esp, byte 10h
        ret
        db 08Dh,040h,00h
sub_8E738:
        push esi
        push edi
        mov edi, dword [byte esp+0Ch]
        mov esi, dword [byte esp+010h]
        mov eax, dword [byte esi+06h]
        sar eax, 10h
        push eax
        push edi
        call sub_91FA4
        add esp, byte 8
        mov edx, dword [byte esp+018h]
        sub edx, eax
        push edx
        mov eax, dword [byte esi+06h]
        sar eax, 10h
        push eax
        push edi
        call sub_91FA4
        add esp, byte 8
        mov edx, dword [byte esp+018h]
        sub edx, eax
        push edx
        push esi
        push edi
        call sub_8E624
        add esp, byte 10h
        pop edi
        pop esi
        ret
        db 08Dh,040h,00h
sub_8E780:
        push esi
        mov edx, dword [byte esp+014h]
        push edx
        mov ebx, dword [byte esp+014h]
        push ebx
        mov ecx, dword [byte esp+014h]
        push ecx
        mov esi, dword [byte esp+014h]
        push esi
        call sub_8E624
        add esp, byte 10h
        pop esi
        ret
        db 00h
