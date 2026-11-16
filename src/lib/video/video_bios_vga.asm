; VGA BIOS calls.
bits 32
%include "hockey.inc"
section s_B3E4A progbits alloc exec nowrite align=1
extern cpuinfo_b0, cpuinfo_b1, SavedTextMode, SavedTextPage, SavedTextRows, KbdRepeatDelay, HotkeyScanTable, HotkeyModTable
extern AngleOctantTable, cliprect_x0, cliprect_x1, cliprect_y0, cliprect_y1, GraphicsReady, cpuinfo_d0, cpuinfo_d1
extern ScreenWidth, ScreenHeight, DrawClipLeft, DrawClipRight, BackBufferWidth, RetraceTimeout, PrintfSavedEbx, PrintfSavedEcx
extern PrintfSavedEdx, PrintfSavedEsi, PrintfSavedEdi, PrintfSavedReturn, RetraceMode, KbdKeyTranslate, KbdRepeatTick, HotkeyNesting
extern HotkeyFuncTable, RectFillMaxShades, CosTable, CosTableFine, CosTableEnd, CosTableTail, GetTicks, VgaBlitKeyedAtOwnPos
extern mousepollfn, RectFillPatternPtrs, printf_, ClearScreenColour, ReadJoystickPorts, AddExitHandler, KbdGetKey, TicksSince
extern SavedTextColumns, KbdLastKey, KbdPrevKey, KbdHeldKey
global PrintfSaveRegs, SaveTextMode, RestoreTextMode, DetectCPU, FillMem, ZeroMem, ResetHotkeyState, KbdGetKeyQuiet
global PollHotkeys, SetupRectFillBlend, SetupRectFill, SetupRectFill, SetupRectFillJumpTable, SetupRectFillJumpTable, RectFillClipLeftJumpTable, RectFillClipLeftJumpTable
global RectFillClipBottomJumpTable, RectFillClipBottomJumpTable, RectFillClipRightJumpTable, RectFillClipRightJumpTable, RectFillClipRightJumpTable, RectFillStepJumpTable, RectFillStepJumpTable, RectFillStepJumpTable
global RectFillStepJumpTable, AngleFromDelta, AngleFromDeltaJumpTable, TableSin, TableCos, DispatchHotkey, RegisterHotkey, SetTextMode
global VgaSetPalette, SetScreenTarget, SetClipWindow, ResetRetraceTimeout, WaitRetrace, WaitRetraceStart, WaitRetraceEnd, InRetrace
global VgaBlitKeyedHot
PrintfSaveRegs:
        mov dword [PrintfSavedEbx], ebx
        mov dword [PrintfSavedEcx], ecx
        mov dword [PrintfSavedEdx], edx
        mov dword [PrintfSavedEsi], esi
        mov dword [PrintfSavedEdi], edi
        pop dword [PrintfSavedReturn]
        call printf_
        push dword [PrintfSavedReturn]
        mov ebx, dword [PrintfSavedEbx]
        mov ecx, dword [PrintfSavedEcx]
        mov edx, dword [PrintfSavedEdx]
        mov esi, dword [PrintfSavedEsi]
        mov edi, dword [PrintfSavedEdi]
        ret
SaveTextMode:
        cmp byte [SavedTextMode], 0
        jne short .1
        mov ah, 0Fh
        int 10h
        mov byte [SavedTextMode], al
        mov al, byte [0410h]
        mov byte [SavedTextPage], al
        mov ax, word [044Ah]
        mov word [SavedTextColumns], ax
        mov al, byte [0484h]
        mov byte [SavedTextRows], al
        push RestoreTextMode
        call AddExitHandler
        add esp, byte 4
.1:
        ret
RestoreTextMode:
        pusha
        cmp byte [SavedTextMode], 0
        je short .3
        mov al, byte [SavedTextPage]
        mov byte [0410h], al
        LD xor, ah, ah
        mov al, byte [SavedTextMode]
        int 10h
        cmp byte [SavedTextMode], 3
        jne short .1
        cmp word [SavedTextColumns], byte 50h
        jne short .1
        cmp byte [SavedTextRows], 2Ah
        jb short .1
        cmp byte [SavedTextRows], 32h
        ja short .1
        mov ax, 1112h
        LD xor, bx, bx
        int 10h
.1:
        mov al, byte [SavedTextPage]
        mov byte [0410h], al
        and al, 30h
        cmp al, 30h
        jne short .2
        push byte 0
        call ClearScreenColour
        add esp, byte 4
.2:
        mov ah, 0Bh
        LD xor, bx, bx
        int 10h
        mov byte [SavedTextMode], 0
.3:
        popa
        ret
        db 00h,00h,00h
DetectCPU:
        pushfw
        mov dword [cpuinfo_d0], 1
        pushfw
        pop bx
        or bx, 7000h
        push bx
        popfw
        pushfw
        pop bx
        and bx, 7000h
        je short .1
        mov dword [cpuinfo_d1], 1
        smsw eax
        and ax, byte 1
        mov byte [cpuinfo_b1], al
        LD mov, edx, esp
        and esp, byte 0FFFFFFFCh
        pushf
        pop eax
        LD mov, ecx, eax
        xor eax, 40000h
        push eax
        popf
        pushf
        pop eax
        LD xor, eax, ecx
        shr eax, 12h
        and ax, byte 1
        mov byte [cpuinfo_b0], al
        LD mov, esp, edx
.1:
        popfw
        ret
        db 00h
FillMem:
        push ebp
        LD mov, ebp, esp
        push edi
        mov edx, dword [byte ebp+010h]
        LD mov, dh, dl
        shrd eax, edx, 10h
        LD mov, ax, dx
        jmp short ZeroMem+06h
ZeroMem:
        push ebp
        LD mov, ebp, esp
        push edi
        LD xor, eax, eax
        cld
        mov edi, dword [byte ebp+08h]
        mov ecx, dword [byte ebp+0Ch]
        shr ecx, 2
        rep stosd
        mov ecx, dword [byte ebp+0Ch]
        and ecx, byte 3
        rep stosb
        pop edi
        leave
        ret
        db 00h
ResetHotkeyState:
        mov dword [RetraceMode], 0
        ret
        db 00h
KbdGetKeyQuiet:
        call KbdGetKey
        LD or, ax, ax
        je short .2
        ret
        call KbdGetKey
        LD or, ax, ax
        je short .2
        push eax
        call DispatchHotkey
        add esp, byte 4
        ret
        call KbdGetKey
        LD or, ax, ax
        je short .1
        push eax
        call DispatchHotkey
        add esp, byte 4
        ret
.1:
        call dword [mousepollfn]
        shl ax, 4
        jne short .3
.2:
        call ReadJoystickPorts
.3:
        LD mov, bx, ax
        test ax, 30h
        je short .4
        mov ax, 0Dh
        jmp short .5
.4:
        and ebx, byte 0Fh
        mov eax, dword [nosplit ebx*2+KbdKeyTranslate]
.5:
        cmp ax, word [KbdLastKey]
        jne short .8
        LD or, ax, ax
        jne short .7
.6:
        LD xor, ax, ax
        ret
.7:
        push dword [KbdRepeatTick]
        call TicksSince
        add esp, byte 4
        cmp ax, word [KbdHeldKey]
        jl short .6
        mov ax, 0Fh
        mov word [KbdHeldKey], ax
        jmp short .9
.8:
        cmp ax, word [KbdPrevKey]
        jne short .10
        dec byte [KbdRepeatDelay]
        jg short .6
        mov word [KbdLastKey], ax
        mov ax, 46h
        mov word [KbdHeldKey], ax
.9:
        call GetTicks
        mov dword [KbdRepeatTick], eax
        mov ax, word [KbdLastKey]
        ret
.10:
        mov byte [KbdRepeatDelay], 3
        mov word [KbdPrevKey], ax
        jmp short .6
PollHotkeys:
        call KbdGetKey
        LD or, eax, eax
        je short .1
        push eax
        call DispatchHotkey
        add esp, byte 4
.1:
        ret
        db 00h,00h
SetupRectFillBlend:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFF8h
        push esi
        push edi
        mov byte [byte ebp-05h], 1
        jmp short SetupRectFill+0Ch
SetupRectFill:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFF8h
        push esi
        push edi
        mov byte [byte ebp-05h], 0
        mov esi, dword [byte ebp+018h]
        mov dword [byte esi+034h], 0FFh
        LD xor, eax, eax
        mov dword [esi], eax
        mov dword [byte esi+08h], eax
        mov dword [byte esi+020h], eax
        mov dword [byte esi+024h], eax
        mov dword [byte esi+028h], eax
        mov dword [byte esi+02Ch], eax
        mov eax, dword [byte ebp+0Ch]
        mov ebx, dword [byte ebp+014h]
        mov ecx, dword [byte ebp+08h]
        mov edx, dword [byte ebp+010h]
        LD cmp, eax, ebx
        jg short .1
        mov dword [byte esi+04h], ecx
        mov dword [byte esi+0Ch], eax
        mov dword [byte esi+010h], edx
        mov dword [byte esi+014h], ebx
        jmp short .2
.1:
        mov dword [byte esi+04h], edx
        mov dword [byte esi+0Ch], ebx
        mov dword [byte esi+010h], ecx
        mov dword [byte esi+014h], eax
.2:
        jne short SetupRectFill+05Ah
        jmp near RectFillStepJumpTable+01BFh
        LD xor, edx, edx
        cmp byte [byte ebp-05h], 0
        jne short .11
        mov eax, dword [byte esi+0Ch]
        mov ebx, dword [cliprect_y0]
        mov ecx, dword [cliprect_y1]
        LD cmp, eax, ecx
        jl short .3
        mov dl, 8
        jmp near RectFillClipRightJumpTable+014Ah
.3:
        LD cmp, eax, ebx
        jge short .4
        or dh, 4
.4:
        mov eax, dword [byte esi+014h]
        LD cmp, eax, ebx
        jge short .5
        mov dl, 4
        jmp near RectFillClipRightJumpTable+014Ah
.5:
        LD cmp, eax, ecx
        jl short .6
        or dl, 8
.6:
        mov ebx, dword [cliprect_x0]
        mov ecx, dword [cliprect_x1]
        mov eax, dword [byte esi+04h]
        LD cmp, eax, ebx
        jge short .7
        or dh, 2
.7:
        LD cmp, eax, ecx
        jl short .8
        or dh, 1
.8:
        mov eax, dword [byte esi+010h]
        LD cmp, eax, ebx
        jge short .9
        or dl, 2
.9:
        LD cmp, eax, ecx
        jl short .10
        or dl, 1
.10:
        test dh, dl
        je short .11
        LD and, dl, dh
        jmp near RectFillClipRightJumpTable+014Ah
.11:
        LD or, dl, dh
        movzx edx, dl
        mov dword [byte ebp-04h], edx
        mov ecx, dword [byte esi+014h]
        sub ecx, dword [byte esi+0Ch]
        jno short .13
.12:
        jmp near RectFillStepJumpTable+027Eh
.13:
        mov edx, dword [byte esi+010h]
        sub edx, dword [byte esi+04h]
        jo short .12
        jne short .14
        inc ecx
        mov dword [byte esi+018h], ecx
        mov byte [byte esi+034h], 2
        jmp short SetupRectFill+0164h
.14:
        jl short .21
        LD cmp, edx, ecx
        jb short .19
        je short .20
        mov byte [byte esi+034h], 8
.15:
        db 087h,0CAh                            ; insn: xchg ecx,edx
.16:
        cmp ecx, dword [RectFillMaxShades]
        jge short .17
        LD mov, ebx, ecx
        mov ebx, dword [nosplit ebx*4+RectFillPatternPtrs]
        mov ax, word [ebx+edx*2]
        shl eax, 10h
        jmp short .18
.17:
        LD xor, eax, eax
        div ecx
        LD mov, ebx, ecx
        shr ebx, 1
        LD sub, ebx, edx
        adc eax, byte 0
.18:
        mov dword [byte esi+030h], eax
        inc ecx
        jo short .12
        mov dword [byte esi+018h], ecx
        jmp short SetupRectFill+0164h
.19:
        mov byte [byte esi+034h], 6
        jmp short .16
.20:
        mov byte [byte esi+034h], 4
        jmp short .24
.21:
        neg edx
        jo short .12
        LD cmp, edx, ecx
        jb short .22
        je short .23
        mov byte [byte esi+034h], 7
        jmp short .15
.22:
        mov byte [byte esi+034h], 5
        jmp short .16
.23:
        mov byte [byte esi+034h], 3
.24:
        inc ecx
        mov dword [byte esi+018h], ecx
        mov ebx, dword [byte ebp-04h]
        je short SetupRectFillJumpTable+040h
        jmp dword [nosplit cs:ebx*4+SetupRectFillJumpTable]
SetupRectFillJumpTable:
        dd SetupRectFillJumpTable+040h
        dd RectFillClipRightJumpTable+01DAh
        dd RectFillClipBottomJumpTable+0DFh
        dd RectFillClipBottomJumpTable+0DFh
        dd .1
        dd .1
        dd .1
        dd .1
        dd RectFillClipLeftJumpTable+0D2h
        dd RectFillClipLeftJumpTable+0D2h
        dd RectFillClipLeftJumpTable+0D2h
        dd RectFillClipLeftJumpTable+0D2h
        dd .1
        dd .1
        dd .1
        dd .1
        LD xor, eax, eax
        pop edi
        pop esi
        leave
        ret
.1:
        mov eax, dword [byte esi+0Ch]
        mov ecx, dword [cliprect_y0]
        mov dword [byte esi+0Ch], ecx
        LD sub, ecx, eax
        mov bl, byte [byte esi+034h]
        jmp dword [nosplit cs:ebx*4+RectFillClipLeftJumpTable]
RectFillClipLeftJumpTable:
        db 00h,00h,00h,00h,00h,00h,00h,00h
        dd .1
        dd .2
        dd .3
        dd .4
        dd .5
        dd .6
        dd .8
.1:
        sub dword [byte esi+018h], ecx
        jmp near RectFillStepJumpTable+0145h
.2:
        sub dword [byte esi+04h], ecx
        sub dword [byte esi+018h], ecx
        jmp near RectFillStepJumpTable+0145h
.3:
        add dword [byte esi+04h], ecx
        sub dword [byte esi+018h], ecx
        jmp near RectFillStepJumpTable+0145h
.4:
        mov eax, dword [byte esi+030h]
        mul ecx
        sub dword [esi], eax
        sbb dword [byte esi+04h], edx
        sub dword [byte esi+018h], ecx
        jmp near RectFillStepJumpTable+0145h
.5:
        mov eax, dword [byte esi+030h]
        mul ecx
        add dword [esi], eax
        adc dword [byte esi+04h], edx
        sub dword [byte esi+018h], ecx
        jmp near RectFillStepJumpTable+0145h
.6:
        mov dword [byte esi+0Ch], eax
        LD mov, edx, ecx
        LD xor, eax, eax
        mov ecx, dword [byte esi+030h]
        div ecx
        shr ecx, 1
        LD sub, ecx, edx
        adc eax, byte 0
        sub dword [byte esi+04h], eax
        sub dword [byte esi+018h], eax
        jle short .7
        mul dword [byte esi+030h]
        add dword [byte esi+08h], eax
        adc dword [byte esi+0Ch], edx
        jmp near RectFillStepJumpTable+0145h
.7:
        mov dword [byte esi+018h], 1
        mov eax, dword [cliprect_y0]
        mov dword [byte esi+0Ch], eax
        mov eax, dword [byte esi+010h]
        mov dword [byte esi+04h], eax
        jmp near RectFillStepJumpTable+0145h
.8:
        mov dword [byte esi+0Ch], eax
        LD mov, edx, ecx
        LD xor, eax, eax
        mov ecx, dword [byte esi+030h]
        div ecx
        shr ecx, 1
        LD sub, ecx, edx
        adc eax, byte 0
        add dword [byte esi+04h], eax
        sub dword [byte esi+018h], eax
        jle short .7
        mul dword [byte esi+030h]
        add dword [byte esi+08h], eax
        adc dword [byte esi+0Ch], edx
        jmp near RectFillStepJumpTable+0145h
        mov ecx, dword [byte esi+014h]
        mov edx, dword [cliprect_y1]
        dec edx
        mov dword [byte esi+014h], edx
        LD sub, ecx, edx
        mov bl, byte [byte esi+034h]
        jmp dword [nosplit cs:ebx*4+RectFillClipBottomJumpTable]
RectFillClipBottomJumpTable:
        db 00h,00h,00h,00h,00h,00h,00h,00h
        dd .1
        dd .2
        dd .3
        dd .4
        dd .5
        dd .6
        dd .9
.1:
        sub dword [byte esi+018h], ecx
        jmp near RectFillStepJumpTable+0153h
.2:
        add dword [byte esi+010h], ecx
        sub dword [byte esi+018h], ecx
        jmp near RectFillStepJumpTable+0153h
.3:
        sub dword [byte esi+010h], ecx
        sub dword [byte esi+018h], ecx
        jmp near RectFillStepJumpTable+0153h
.4:
        mov edx, dword [byte esi+018h]
        LD sub, edx, ecx
        mov dword [byte esi+018h], edx
        dec edx
        mov eax, dword [byte esi+030h]
        mul edx
        mov ebx, dword [esi]
        mov ecx, dword [byte esi+04h]
        LD sub, ebx, eax
        LD sbb, ecx, edx
        add ebx, 80000000h
        adc ecx, byte 0
        mov dword [byte esi+010h], ecx
        jmp near RectFillStepJumpTable+0153h
.5:
        mov edx, dword [byte esi+018h]
        LD sub, edx, ecx
        mov dword [byte esi+018h], edx
        dec edx
        mov eax, dword [byte esi+030h]
        mul edx
        add eax, dword [esi]
        adc edx, dword [byte esi+04h]
        add eax, 80000000h
        adc edx, byte 0
        mov dword [byte esi+010h], edx
        jmp near RectFillStepJumpTable+0153h
.6:
        LD xor, eax, eax
        sub eax, dword [byte esi+08h]
        sbb edx, dword [byte esi+0Ch]
        jl short .8
        mov ecx, dword [byte esi+030h]
        div ecx
        shr ecx, 1
        LD sub, ecx, edx
        adc eax, byte 0
.7:
        mov edx, dword [byte esi+04h]
        LD sub, edx, eax
        mov dword [byte esi+010h], edx
        inc eax
        mov dword [byte esi+018h], eax
        jmp near RectFillStepJumpTable+0153h
.8:
        LD xor, eax, eax
        jmp short .7
.9:
        LD xor, eax, eax
        sub eax, dword [byte esi+08h]
        sbb edx, dword [byte esi+0Ch]
        jl short .8
        mov ecx, dword [byte esi+030h]
        div ecx
        shr ecx, 1
        LD sub, ecx, edx
        adc eax, byte 0
        mov edx, dword [byte esi+04h]
        LD add, edx, eax
        mov dword [byte esi+010h], edx
        inc eax
        mov dword [byte esi+018h], eax
        jmp near RectFillStepJumpTable+0153h
        mov bl, byte [byte esi+034h]
        jmp dword [nosplit cs:ebx*4+RectFillClipRightJumpTable]
RectFillClipRightJumpTable:
        db 00h,00h,00h,00h,00h,00h,00h,00h
        dd .10
        dd .1
        dd .2
        dd .3
        dd .6
        dd .8
        dd .9
.1:
        mov ecx, dword [cliprect_x0]
        mov eax, dword [byte esi+010h]
        mov dword [byte esi+010h], ecx
        LD sub, ecx, eax
        add dword [byte esi+024h], ecx
        sub dword [byte esi+018h], ecx
        sub dword [byte esi+014h], ecx
        jmp near RectFillStepJumpTable+01ACh
.2:
        mov eax, dword [byte esi+04h]
        mov ecx, dword [cliprect_x0]
        mov dword [byte esi+04h], ecx
        LD sub, ecx, eax
        add dword [byte esi+020h], ecx
        add dword [byte esi+0Ch], ecx
        sub dword [byte esi+018h], ecx
        jmp near RectFillStepJumpTable+01ACh
.3:
        mov eax, dword [esi]
        mov edx, dword [byte esi+04h]
        mov ecx, dword [cliprect_x0]
        mov dword [byte esi+010h], ecx
        LD sub, edx, ecx
        jl short .5
        mov ecx, dword [byte esi+030h]
        div ecx
        shr ecx, 1
        LD sub, ecx, edx
        adc eax, byte 0
        inc eax
.4:
        mov ecx, dword [byte esi+018h]
        mov dword [byte esi+018h], eax
        LD sub, ecx, eax
        add dword [byte esi+024h], ecx
        dec eax
        add eax, dword [byte esi+0Ch]
        mov dword [byte esi+014h], eax
        jmp near RectFillStepJumpTable+01ACh
.5:
        mov eax, 1
        jmp short .4
.6:
        mov edx, dword [cliprect_x0]
        LD xor, eax, eax
        sub eax, dword [esi]
        sbb edx, dword [byte esi+04h]
        jl short .7
        mov ecx, dword [byte esi+030h]
        div ecx
        shr ecx, 1
        LD sub, ecx, edx
        adc eax, byte 0
        add dword [byte esi+0Ch], eax
        add dword [byte esi+020h], eax
        sub dword [byte esi+018h], eax
        jle near .10
        mul dword [byte esi+030h]
        add dword [esi], eax
        adc dword [byte esi+04h], edx
        jmp near RectFillStepJumpTable+01ACh
.7:
        jmp short .10
.8:
        mov eax, dword [byte esi+04h]
        mov edx, dword [cliprect_x0]
        mov dword [byte esi+010h], edx
        LD sub, eax, edx
        LD mov, ecx, eax
        inc ecx
        mov dword [byte esi+018h], ecx
        mul dword [byte esi+030h]
        add eax, dword [byte esi+08h]
        adc edx, dword [byte esi+0Ch]
        add eax, 80000000h
        adc edx, byte 0
        mov eax, dword [byte esi+014h]
        LD sub, eax, edx
        mov dword [byte esi+014h], edx
        add dword [byte esi+024h], eax
        jmp near RectFillStepJumpTable+01ACh
.9:
        mov ecx, dword [byte esi+04h]
        mov eax, dword [cliprect_x0]
        mov dword [byte esi+04h], eax
        LD sub, eax, ecx
        sub dword [byte esi+018h], eax
        mul dword [byte esi+030h]
        mov ebx, dword [byte esi+08h]
        mov ecx, dword [byte esi+0Ch]
        LD add, eax, ebx
        LD adc, edx, ecx
        mov dword [byte esi+08h], eax
        mov dword [byte esi+0Ch], edx
        add ebx, 80000000h
        adc ecx, byte 0
        add eax, 80000000h
        adc edx, byte 0
        LD sub, edx, ecx
        add dword [byte esi+020h], edx
        jmp near RectFillStepJumpTable+01ACh
.10:
        mov edx, 2
        mov byte [byte esi+035h], dl
        mov dword [byte esi+018h], 0
        mov al, byte [byte esi+035h]
        test al, 4
        je short .11
        mov ebx, dword [cliprect_y0]
        mov dword [byte esi+0Ch], ebx
        mov dword [byte esi+08h], 0
        dec ebx
        mov dword [byte esi+014h], ebx
        jmp short .16
.11:
        test al, 8
        je short .12
        mov ebx, dword [cliprect_y1]
        mov dword [byte esi+0Ch], ebx
        mov dword [byte esi+08h], 0
        jmp short .16
.12:
        mov ecx, dword [byte esi+014h]
        cmp ecx, dword [cliprect_y1]
        jl short .13
        mov ecx, dword [cliprect_y1]
        dec ecx
.13:
        mov edx, dword [byte esi+0Ch]
        mov ebx, dword [byte esi+08h]
        add ebx, 80000000h
        adc edx, byte 0
        cmp edx, dword [cliprect_y0]
        jge short .14
        mov edx, dword [cliprect_y0]
.14:
        mov dword [byte esi+0Ch], edx
        mov dword [byte esi+08h], 0
        LD sub, ecx, edx
        dec edx
        inc ecx
        mov dword [byte esi+014h], edx
        test al, 2
        je short .15
        add dword [byte esi+024h], ecx
        jmp short .16
.15:
        add dword [byte esi+02Ch], ecx
.16:
        movzx eax, al
        pop edi
        pop esi
        leave
        ret
        movzx ebx, byte [byte esi+034h]
        jmp dword [nosplit cs:ebx*4+RectFillStepJumpTable]
RectFillStepJumpTable:
        db 00h,00h,00h,00h,00h,00h,00h,00h
        dd .1
        dd .2
        dd .3
        dd .4
        dd .5
        dd .6
        dd .7
.1:
        mov edx, 1
        jmp near RectFillClipRightJumpTable+014Ah
.2:
        mov ecx, dword [byte esi+04h]
        mov eax, dword [cliprect_x1]
        dec eax
        mov dword [byte esi+04h], eax
        LD sub, ecx, eax
        add dword [byte esi+0Ch], ecx
        sub dword [byte esi+018h], ecx
        add dword [byte esi+028h], ecx
        jmp near SetupRectFillJumpTable+040h
.3:
        mov ecx, dword [cliprect_x1]
        dec ecx
        mov eax, dword [byte esi+010h]
        mov dword [byte esi+010h], ecx
        LD sub, eax, ecx
        add dword [byte esi+02Ch], eax
        sub dword [byte esi+018h], eax
        sub dword [byte esi+014h], eax
        jmp near SetupRectFillJumpTable+040h
.4:
        mov eax, dword [esi]
        mov edx, dword [byte esi+04h]
        sub edx, dword [cliprect_x1]
        inc edx
        mov ecx, dword [byte esi+030h]
        div ecx
        shr ecx, 1
        LD sub, ecx, edx
        adc eax, byte 0
        sub dword [byte esi+018h], eax
        jle short .1
        add dword [byte esi+0Ch], eax
        add dword [byte esi+028h], eax
        mul dword [byte esi+030h]
        sub dword [esi], eax
        sbb dword [byte esi+04h], edx
        jmp near SetupRectFillJumpTable+040h
.5:
        mov edx, dword [cliprect_x1]
        dec edx
        mov dword [byte esi+010h], edx
        LD xor, eax, eax
        sub eax, dword [esi]
        sbb edx, dword [byte esi+04h]
        jl near .1
        mov ecx, dword [byte esi+030h]
        div ecx
        shr ecx, 1
        LD sub, ecx, edx
        adc eax, byte 0
        inc eax
        mov ecx, dword [byte esi+018h]
        mov dword [byte esi+018h], eax
        LD sub, ecx, eax
        add dword [byte esi+02Ch], ecx
        dec eax
        add eax, dword [byte esi+0Ch]
        mov dword [byte esi+014h], eax
        jmp near SetupRectFillJumpTable+040h
.6:
        mov eax, dword [byte esi+04h]
        mov ecx, dword [cliprect_x1]
        dec ecx
        LD sub, eax, ecx
        mov dword [byte esi+04h], ecx
        sub dword [byte esi+018h], eax
        mul dword [byte esi+030h]
        mov ebx, dword [byte esi+08h]
        mov ecx, dword [byte esi+0Ch]
        LD add, eax, ebx
        LD adc, edx, ecx
        mov dword [byte esi+08h], eax
        mov dword [byte esi+0Ch], edx
        add ebx, 80000000h
        adc ecx, byte 0
        add eax, 80000000h
        adc edx, byte 0
        LD sub, edx, ecx
        add dword [byte esi+028h], edx
        jmp near SetupRectFillJumpTable+040h
.7:
        mov eax, dword [cliprect_x1]
        LD mov, ecx, eax
        dec ecx
        mov dword [byte esi+010h], ecx
        sub eax, dword [byte esi+04h]
        mov dword [byte esi+018h], eax
        dec eax
        mul dword [byte esi+030h]
        add eax, dword [byte esi+08h]
        adc edx, dword [byte esi+0Ch]
        add eax, 80000000h
        adc edx, byte 0
        mov eax, dword [byte esi+014h]
        LD sub, eax, edx
        mov dword [byte esi+014h], edx
        add dword [byte esi+02Ch], eax
        jmp near SetupRectFillJumpTable+040h
        test dword [byte ebp-04h], 8
        je short RectFillStepJumpTable+0153h
        jmp near RectFillClipLeftJumpTable+0D2h
        LD xor, edx, edx
        mov eax, dword [byte esi+04h]
        cmp eax, dword [cliprect_x0]
        jge short .8
        or dh, 2
.8:
        mov ebx, dword [esi]
        add ebx, 80000000h
        adc eax, byte 0
        cmp eax, dword [cliprect_x1]
        jl short .9
        or dh, 1
.9:
        mov eax, dword [byte esi+010h]
        cmp eax, dword [cliprect_x0]
        jge short .10
        or dl, 2
.10:
        cmp eax, dword [cliprect_x1]
        jl short .11
        or dl, 1
.11:
        test dh, dl
        je short .12
        LD and, dl, dh
        jmp near RectFillClipRightJumpTable+014Ah
.12:
        LD or, dl, dh
        je short .13
        movzx edx, dl
        mov dword [byte ebp-04h], edx
        jmp near SetupRectFill+0164h
        test dword [byte ebp-04h], 1
        je short .13
        jmp near RectFillClipRightJumpTable+01DAh
.13:
        jmp near SetupRectFillJumpTable+040h
        mov byte [byte esi+034h], 1
        LD cmp, ecx, edx
        jne short .14
        mov byte [byte esi+034h], 9
.14:
        jle short .15
        mov byte [byte esi+034h], 0
        mov dword [byte esi+04h], edx
        mov dword [byte esi+010h], ecx
        db 087h,0CAh                            ; insn: xchg ecx,edx
.15:
        cmp byte [byte ebp-05h], 0
        jne short .17
        mov ebx, dword [cliprect_y0]
        LD cmp, eax, ebx
        jge short .18
        mov al, 4
        mov dword [byte esi+0Ch], ebx
        mov dword [byte esi+014h], ebx
.16:
        mov byte [byte esi+035h], al
        mov dword [byte esi+018h], 0
        movzx eax, al
        pop edi
        pop esi
        leave
        ret
.17:
        LD sub, edx, ecx
        inc edx
        mov dword [byte esi+018h], edx
        jmp near SetupRectFillJumpTable+040h
.18:
        mov ebx, dword [cliprect_y1]
        LD cmp, eax, ebx
        jl short .19
        mov al, 8
        mov dword [byte esi+0Ch], ebx
        mov dword [byte esi+014h], ebx
        jmp short .16
.19:
        LD mov, eax, edx
        LD sub, eax, ecx
        inc eax
        mov dword [byte esi+018h], eax
        cmp edx, dword [cliprect_x0]
        jge short .20
        dec dword [byte esi+014h]
        mov dword [byte esi+024h], 1
        mov al, 2
        jmp short .16
.20:
        cmp ecx, dword [cliprect_x1]
        jl short .21
        dec dword [byte esi+014h]
        mov dword [byte esi+02Ch], 1
        mov al, 1
        jmp short .16
.21:
        mov eax, dword [cliprect_x0]
        LD mov, ebx, eax
        LD sub, eax, ecx
        jle short .22
        mov dword [byte esi+04h], ebx
        sub dword [byte esi+018h], eax
.22:
        LD mov, eax, edx
        mov ebx, dword [cliprect_x1]
        dec ebx
        LD sub, eax, ebx
        jle short .23
        sub dword [byte esi+018h], eax
        mov dword [byte esi+010h], ebx
.23:
        jmp near SetupRectFillJumpTable+040h
        mov ecx, dword [byte esi+014h]
        sar ecx, 1
        mov eax, dword [byte esi+0Ch]
        sar eax, 1
        LD sub, ecx, eax
        sar ecx, 1
        mov edx, dword [byte esi+010h]
        sar edx, 1
        mov eax, dword [byte esi+04h]
        sar eax, 1
        LD sub, edx, eax
        sar edx, 1
.24:
        cmp dword [byte esi+0Ch], 0FFFFC180h
        jg short .30
.25:
        mov eax, dword [byte esi+0Ch]
        LD add, eax, ecx
        mov dword [byte esi+0Ch], eax
        LD mov, ebx, eax
        sub eax, dword [cliprect_y0]
        jle short .29
        LD cmp, eax, ecx
        jle short .26
        LD mov, eax, ecx
.26:
        sub ebx, dword [cliprect_y1]
        jle short .27
        LD sub, eax, ebx
        jle short .29
.27:
        mov ebx, dword [byte esi+04h]
        cmp ebx, dword [cliprect_x0]
        jge short .28
        add dword [byte esi+020h], eax
        jmp short .29
.28:
        add dword [byte esi+028h], eax
.29:
        add dword [byte esi+04h], edx
        jmp short .24
.30:
        cmp dword [byte esi+014h], 3E80h
        jge short .31
        cmp dword [byte esi+04h], 0FFFFC180h
        jle short .25
        cmp dword [byte esi+04h], 3E80h
        jge short .25
        cmp dword [byte esi+010h], 0FFFFC180h
        jle short .31
        cmp dword [byte esi+010h], 3E80h
        jge short .31
        jmp near SetupRectFill+05Ah
.31:
        mov eax, dword [byte esi+014h]
        LD sub, eax, ecx
        mov dword [byte esi+014h], eax
        LD mov, ebx, eax
        sub eax, dword [cliprect_y1]
        inc eax
        jge short .35
        neg eax
        LD cmp, eax, ecx
        jle short .32
        LD mov, eax, ecx
.32:
        sub ebx, dword [cliprect_y0]
        inc ebx
        jge short .33
        LD add, eax, ebx
        jle short .35
.33:
        mov ebx, dword [byte esi+010h]
        cmp ebx, dword [cliprect_x0]
        jge short .34
        add dword [byte esi+024h], eax
        jmp short .35
.34:
        add dword [byte esi+02Ch], eax
.35:
        sub dword [byte esi+010h], edx
        jmp short .30
        db 00h
AngleFromDelta:
        push ebp
        LD mov, ebp, esp
        LD xor, ebx, ebx
        mov ecx, dword [byte ebp+0Ch]
        mov edx, dword [byte ebp+08h]
        LD or, ecx, ecx
        jge short .1
        or ebx, byte 8
        neg ecx
.1:
        LD or, edx, edx
        jge short .2
        or ebx, byte 10h
        neg edx
.2:
        LD cmp, edx, ecx
        jl short .3
        je short .4
        db 087h,0CAh                            ; insn: xchg ecx,edx
        or ebx, byte 4
.3:
        LD xor, eax, eax
        div ecx
        shr eax, 18h
        adc eax, byte 0
        movzx eax, byte [dword eax+AngleOctantTable]
        jmp dword [dword cs:ebx+AngleFromDeltaJumpTable]
.4:
        mov eax, 80h
        jmp dword [dword cs:ebx+AngleFromDeltaJumpTable]
AngleFromDeltaJumpTable:
        dd .2
        dd .1
        dd .3
        dd .4
        dd .5
        dd .6
        dd .7
        dd .8
.1:
        neg eax
        add eax, 100h
.2:
        leave
        ret
.3:
        neg eax
        add eax, 200h
        leave
        ret
.4:
        add eax, 100h
        leave
        ret
.5:
        neg eax
        leave
        ret
.6:
        sub eax, 100h
        leave
        ret
.7:
        sub eax, 200h
        leave
        ret
.8:
        neg eax
        sub eax, 100h
        leave
        ret
TableSin:
        mov eax, dword [byte esp+04h]
        jmp short TableCos+06h
TableCos:
        mov eax, dword [byte esp+04h]
        inc ah
        movzx eax, ax
        and ah, 3
        jnp short .1
        jne short .3
        mov eax, dword [nosplit eax*4+CosTableFine]
        ret
.1:
        dec ah
        jne short .2
        neg eax
        mov eax, dword [nosplit eax*4+CosTableEnd]
        ret
.2:
        mov eax, dword [nosplit eax*4+CosTable]
        neg eax
        ret
.3:
        neg eax
        mov eax, dword [nosplit eax*4+CosTableTail]
        neg eax
        ret
        db 00h,00h
DispatchHotkey:
        push ebp
        LD mov, ebp, esp
        dec dword [HotkeyNesting]
        jne short .4
        mov ebx, dword [byte ebp+08h]
        LD or, bl, bl
        je short .2
        and ebx, byte 7Fh
        mov dword [byte ebp+08h], ebx
        mov bl, byte [dword ebx+HotkeyScanTable]
.1:
        dec ebx
        jl short .4
        push edi
        push esi
        call dword [nosplit ebx*4+HotkeyFuncTable]
        pop esi
        pop edi
        LD xor, eax, eax
        inc dword [HotkeyNesting]
        leave
        ret
.2:
        movzx ebx, bh
        cmp ebx, 84h
        jl short .3
        mov ebx, 84h
.3:
        mov bl, byte [dword ebx+HotkeyModTable]
        jmp short .1
.4:
        mov eax, dword [byte ebp+08h]
        inc dword [HotkeyNesting]
        leave
        ret
RegisterHotkey:
        push ebp
        LD mov, ebp, esp
        mov eax, dword [byte ebp+0Ch]
        mov ecx, 40h
        mov ebx, HotkeyFuncTable
.1:
        cmp dword [ebx], eax
        je short .3
        cmp word [ebx], byte 0
        je short .2
        add ebx, byte 4
        loop .1
        leave
        ret
.2:
        mov dword [ebx], eax
.3:
        mov eax, 41h
        LD sub, eax, ecx
.4:
        mov ebx, dword [byte ebp+08h]
        LD or, bl, bl
        je short .6
        cmp ebx, byte 7Fh
        jg short .5
        mov byte [dword ebx+HotkeyScanTable], al
.5:
        leave
        ret
.6:
        movzx ebx, bh
        cmp ebx, 84h
        jg short .5
        mov byte [dword ebx+HotkeyModTable], al
        leave
        ret
        push ebp
        LD mov, ebp, esp
        LD xor, eax, eax
        jmp short .4
        db 00h,00h,00h
SetTextMode:
        push byte 0
        call ClearScreenColour
        add esp, byte 4
        and byte [0410h], 0CFh
        or byte [0410h], 10h
        mov eax, 3
        int 10h
        mov ah, 0Bh
        LD xor, ebx, ebx
        int 10h
        mov dword [GraphicsReady], 0
        ret
VgaSetPalette:
        push ebp
        LD mov, ebp, esp
        push esi
        mov esi, dword [byte ebp+010h]
        mov edx, 3C8h
        mov eax, dword [byte ebp+08h]
        out dx, al
        mov ebx, dword [byte ebp+0Ch]
        inc edx
        cld
        lea ecx, [ebx+ebx*2]
.1:
        lodsb
        out dx, al
        loop .1
        pop esi
        leave
        ret
        db 00h
SetScreenTarget:
        LD mov, edx, edi
        LD mov, eax, esi
        mov esi, BackBufferWidth
        mov edi, ScreenWidth
        mov ecx, 0Ch
        rep movsd
        LD mov, edi, edx
        LD mov, esi, eax
        ret
        db 00h,00h
SetClipWindow:
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        mov ecx, dword [byte esp+0Ch]
        mov ebx, dword [byte esp+010h]
        cmp eax, byte 0
        jge short .1
        mov eax, 0
.1:
        cmp ecx, byte 0
        jge short .2
        mov ecx, 0
.2:
        cmp edx, dword [ScreenWidth]
        jle short .3
        mov edx, dword [ScreenWidth]
.3:
        cmp ebx, dword [ScreenHeight]
        jle short .4
        mov ebx, dword [ScreenHeight]
.4:
        mov dword [cliprect_x0], eax
        mov dword [cliprect_y0], ecx
        mov dword [cliprect_x1], edx
        mov dword [cliprect_y1], ebx
        mov dword [DrawClipLeft], eax
        mov dword [DrawClipRight], edx
        ret
        db 00h
ResetRetraceTimeout:
        mov dword [RetraceTimeout], 2710h
        ret
WaitRetrace:
        mov dx, 3DAh
        mov ecx, dword [RetraceTimeout]
        cmp dword [RetraceMode], byte 1
        jg short .3
        je short .2
.1:
        in al, dx
        test al, 8
        loopne .1
        jecxz ResetRetraceTimeout
.2:
        in al, dx
        test al, 8
        loope .2
        jecxz ResetRetraceTimeout
.3:
        mov dword [RetraceTimeout], 186A0h
        ret
WaitRetraceStart:
        mov dx, 3DAh
        mov ecx, dword [RetraceTimeout]
.1:
        in al, dx
        test al, 8
        loopne .1
        jecxz ResetRetraceTimeout
.2:
        in al, dx
        test al, 8
        loope .2
        jecxz ResetRetraceTimeout
        mov dword [RetraceTimeout], 186A0h
        ret
WaitRetraceEnd:
        mov dx, 3DAh
        mov ecx, dword [RetraceTimeout]
.1:
        in al, dx
        test al, 8
        loope .1
        jecxz ResetRetraceTimeout
.2:
        in al, dx
        test al, 8
        loopne .2
        jecxz ResetRetraceTimeout
        mov dword [RetraceTimeout], 186A0h
        ret
InRetrace:
        mov dx, 3DAh
        in al, dx
        and ax, byte 8
        ret
        db 00h,00h,00h
VgaBlitKeyedHot:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFE0h
        push ds
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov eax, dword [byte ebp+0Ch]
        sub ax, word [byte esi+08h]
        cwde
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp+010h]
        sub ax, word [byte esi+0Ah]
        cwde
        mov dword [byte ebp-08h], eax
        jmp short VgaBlitKeyedAtOwnPos+01Ah
