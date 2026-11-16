; VGA BIOS calls.
bits 32
%include "hockey.inc"
section s_B3E4A progbits alloc exec nowrite align=1
extern cpuinfo_b0, cpuinfo_b1, SavedTextMode, SavedTextPage, SavedTextRows, byte_D4FE8, byte_D545C, byte_D54DC
extern byte_D6074, cliprect_x0, cliprect_x1, cliprect_y0, cliprect_y1, GraphicsReady, cpuinfo_d0, cpuinfo_d1
extern ScreenWidth, dword_D30A8, dword_D30BC, dword_D30C0, BackBufferWidth, dword_D429C, PrintfSavedEbx, PrintfSavedEcx
extern PrintfSavedEdx, PrintfSavedEsi, PrintfSavedEdi, PrintfSavedReturn, dword_D4FA0, dword_D4FA4, dword_D4FEB, dword_D5562
extern dword_D5566, dword_D5678, dword_D5D78, dword_D6178, dword_D6578, dword_D7178, GetTicks, loc_B4D0C
extern mousepollfn, off_D567C, printf_, ClearScreenColour, ReadJoystickPorts, AddExitHandler, KbdGetKey, TicksSince
extern SavedTextColumns, word_D4FE4, word_D4FE6, word_D4FE9
global PrintfSaveRegs, SaveTextMode, loc_B3ED7, RestoreTextMode, loc_B3F23, loc_B3F3D, loc_B3F4B, DetectCPU
global loc_B3FAC, FillMem, ZeroMem, loc_B3FC8, sub_B3FE0, sub_B3FEC, loc_B401F, loc_B402B
global loc_B4030, loc_B403F, loc_B4049, loc_B4057, loc_B405B, loc_B407E, loc_B409F, loc_B40B0
global PollHotkeys, loc_B40D1, SetupRectFillBlend, SetupRectFill, loc_B40EE, loc_B4129, loc_B4135, loc_B413C
global loc_B415E, loc_B4165, loc_B4173, loc_B417A, loc_B4190, loc_B4197, loc_B41A1, loc_B41A8
global loc_B41B3, loc_B41C3, loc_B41C8, loc_B41DC, loc_B41E8, loc_B41EA, loc_B4204, loc_B4211
global loc_B421C, loc_B4222, loc_B4228, loc_B4238, loc_B423E, loc_B4242, loc_B4246, jpt_B4253
global loc_B4293, loc_B4299, jpt_B42B2, loc_B42D6, loc_B42DE, loc_B42E9, loc_B42F4, loc_B4306
global loc_B4318, loc_B4341, loc_B435B, loc_B4384, jpt_B439E, loc_B43C2, loc_B43CA, loc_B43D5
global loc_B43E0, loc_B4408, loc_B442B, loc_B4441, loc_B4452, loc_B4456, loc_B447D, jpt_B4488
global loc_B44AC, loc_B44C8, loc_B44E4, loc_B4503, loc_B451A, loc_B4521, loc_B4558, loc_B455A
global loc_B458F, loc_B45CD, loc_B45D2, loc_B45F9, loc_B460F, loc_B4621, loc_B463E, loc_B4658
global loc_B465B, loc_B4662, jpt_B466E, loc_B4692, loc_B469C, loc_B46B8, loc_B46D5, loc_B4705
global loc_B4740, loc_B4780, loc_B47B3, loc_B47C1, loc_B47D1, loc_B47E7, loc_B47F5, loc_B4800
global loc_B480B, loc_B481A, loc_B4828, loc_B482D, loc_B4839, loc_B4847, loc_B485F, loc_B4870
global loc_B487B, loc_B488F, loc_B48AD, loc_B48C3, loc_B48D4, loc_B48E7, loc_B48EC, loc_B4908
global loc_B4911, loc_B4929, loc_B4935, loc_B4945, loc_B4948, loc_B494D, loc_B497F, loc_B499A
global loc_B49A7, loc_B49B7, loc_B49BA, AngleFromDelta, loc_B49D4, loc_B49DD, loc_B49E8, loc_B4A00
global unk_B4A0C, loc_B4A2C, loc_B4A33, loc_B4A35, loc_B4A3E, loc_B4A45, loc_B4A49, loc_B4A50
global loc_B4A57, sub_B4A60, sub_B4A66, loc_B4A6C, loc_B4A7E, loc_B4A8C, loc_B4A96, DispatchHotkey
global loc_B4AC2, loc_B4ADA, loc_B4AEA, loc_B4AF2, sub_B4AFD, loc_B4B0D, loc_B4B1E, loc_B4B20
global loc_B4B27, loc_B4B39, loc_B4B3B, SetTextMode, VgaSetPalette, loc_B4BA0, SetScreenTarget, SetClipWindow
global loc_B4BDE, loc_B4BE8, loc_B4BF6, loc_B4C04, sub_B4C28, WaitRetrace, loc_B4C48, loc_B4C4F
global loc_B4C56, sub_B4C61, loc_B4C6B, loc_B4C72, sub_B4C84, loc_B4C8E, loc_B4C95, sub_B4CA7
global sub_B4CB4
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
        jne short loc_B3ED7
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
loc_B3ED7:
        ret
RestoreTextMode:
        pusha
        cmp byte [SavedTextMode], 0
        je short loc_B3F4B
        mov al, byte [SavedTextPage]
        mov byte [0410h], al
        LD xor, ah, ah
        mov al, byte [SavedTextMode]
        int 10h
        cmp byte [SavedTextMode], 3
        jne short loc_B3F23
        cmp word [SavedTextColumns], byte 50h
        jne short loc_B3F23
        cmp byte [SavedTextRows], 2Ah
        jb short loc_B3F23
        cmp byte [SavedTextRows], 32h
        ja short loc_B3F23
        mov ax, 1112h
        LD xor, bx, bx
        int 10h
loc_B3F23:
        mov al, byte [SavedTextPage]
        mov byte [0410h], al
        and al, 30h
        cmp al, 30h
        jne short loc_B3F3D
        push byte 0
        call ClearScreenColour
        add esp, byte 4
loc_B3F3D:
        mov ah, 0Bh
        LD xor, bx, bx
        int 10h
        mov byte [SavedTextMode], 0
loc_B3F4B:
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
        je short loc_B3FAC
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
loc_B3FAC:
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
        jmp short loc_B3FC8
ZeroMem:
        push ebp
        LD mov, ebp, esp
        push edi
        LD xor, eax, eax
loc_B3FC8:
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
sub_B3FE0:
        mov dword [dword_D4FA0], 0
        ret
        db 00h
sub_B3FEC:
        call KbdGetKey
        LD or, ax, ax
        je short loc_B402B
        ret
        call KbdGetKey
        LD or, ax, ax
        je short loc_B402B
        push eax
        call DispatchHotkey
        add esp, byte 4
        ret
        call KbdGetKey
        LD or, ax, ax
        je short loc_B401F
        push eax
        call DispatchHotkey
        add esp, byte 4
        ret
loc_B401F:
        call dword [mousepollfn]
        shl ax, 4
        jne short loc_B4030
loc_B402B:
        call ReadJoystickPorts
loc_B4030:
        LD mov, bx, ax
        test ax, 30h
        je short loc_B403F
        mov ax, 0Dh
        jmp short loc_B4049
loc_B403F:
        and ebx, byte 0Fh
        mov eax, dword [nosplit ebx*2+dword_D4FA4]
loc_B4049:
        cmp ax, word [word_D4FE4]
        jne short loc_B407E
        LD or, ax, ax
        jne short loc_B405B
loc_B4057:
        LD xor, ax, ax
        ret
loc_B405B:
        push dword [dword_D4FEB]
        call TicksSince
        add esp, byte 4
        cmp ax, word [word_D4FE9]
        jl short loc_B4057
        mov ax, 0Fh
        mov word [word_D4FE9], ax
        jmp short loc_B409F
loc_B407E:
        cmp ax, word [word_D4FE6]
        jne short loc_B40B0
        dec byte [byte_D4FE8]
        jg short loc_B4057
        mov word [word_D4FE4], ax
        mov ax, 46h
        mov word [word_D4FE9], ax
loc_B409F:
        call GetTicks
        mov dword [dword_D4FEB], eax
        mov ax, word [word_D4FE4]
        ret
loc_B40B0:
        mov byte [byte_D4FE8], 3
        mov word [word_D4FE6], ax
        jmp short loc_B4057
PollHotkeys:
        call KbdGetKey
        LD or, eax, eax
        je short loc_B40D1
        push eax
        call DispatchHotkey
        add esp, byte 4
loc_B40D1:
        ret
        db 00h,00h
SetupRectFillBlend:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFF8h
        push esi
        push edi
        mov byte [byte ebp-05h], 1
        jmp short loc_B40EE
SetupRectFill:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFF8h
        push esi
        push edi
        mov byte [byte ebp-05h], 0
loc_B40EE:
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
        jg short loc_B4129
        mov dword [byte esi+04h], ecx
        mov dword [byte esi+0Ch], eax
        mov dword [byte esi+010h], edx
        mov dword [byte esi+014h], ebx
        jmp short loc_B4135
loc_B4129:
        mov dword [byte esi+04h], edx
        mov dword [byte esi+0Ch], ebx
        mov dword [byte esi+010h], ecx
        mov dword [byte esi+014h], eax
loc_B4135:
        jne short loc_B413C
        jmp near loc_B482D
loc_B413C:
        LD xor, edx, edx
        cmp byte [byte ebp-05h], 0
        jne short loc_B41B3
        mov eax, dword [byte esi+0Ch]
        mov ebx, dword [cliprect_y0]
        mov ecx, dword [cliprect_y1]
        LD cmp, eax, ecx
        jl short loc_B415E
        mov dl, 8
        jmp near loc_B45D2
loc_B415E:
        LD cmp, eax, ebx
        jge short loc_B4165
        or dh, 4
loc_B4165:
        mov eax, dword [byte esi+014h]
        LD cmp, eax, ebx
        jge short loc_B4173
        mov dl, 4
        jmp near loc_B45D2
loc_B4173:
        LD cmp, eax, ecx
        jl short loc_B417A
        or dl, 8
loc_B417A:
        mov ebx, dword [cliprect_x0]
        mov ecx, dword [cliprect_x1]
        mov eax, dword [byte esi+04h]
        LD cmp, eax, ebx
        jge short loc_B4190
        or dh, 2
loc_B4190:
        LD cmp, eax, ecx
        jl short loc_B4197
        or dh, 1
loc_B4197:
        mov eax, dword [byte esi+010h]
        LD cmp, eax, ebx
        jge short loc_B41A1
        or dl, 2
loc_B41A1:
        LD cmp, eax, ecx
        jl short loc_B41A8
        or dl, 1
loc_B41A8:
        test dh, dl
        je short loc_B41B3
        LD and, dl, dh
        jmp near loc_B45D2
loc_B41B3:
        LD or, dl, dh
        movzx edx, dl
        mov dword [byte ebp-04h], edx
        mov ecx, dword [byte esi+014h]
        sub ecx, dword [byte esi+0Ch]
        jno short loc_B41C8
loc_B41C3:
        jmp near loc_B48EC
loc_B41C8:
        mov edx, dword [byte esi+010h]
        sub edx, dword [byte esi+04h]
        jo short loc_B41C3
        jne short loc_B41DC
        inc ecx
        mov dword [byte esi+018h], ecx
        mov byte [byte esi+034h], 2
        jmp short loc_B4246
loc_B41DC:
        jl short loc_B4228
        LD cmp, edx, ecx
        jb short loc_B421C
        je short loc_B4222
        mov byte [byte esi+034h], 8
loc_B41E8:
        db 087h,0CAh                            ; insn: xchg ecx,edx
loc_B41EA:
        cmp ecx, dword [dword_D5678]
        jge short loc_B4204
        LD mov, ebx, ecx
        mov ebx, dword [nosplit ebx*4+off_D567C]
        mov ax, word [ebx+edx*2]
        shl eax, 10h
        jmp short loc_B4211
loc_B4204:
        LD xor, eax, eax
        div ecx
        LD mov, ebx, ecx
        shr ebx, 1
        LD sub, ebx, edx
        adc eax, byte 0
loc_B4211:
        mov dword [byte esi+030h], eax
        inc ecx
        jo short loc_B41C3
        mov dword [byte esi+018h], ecx
        jmp short loc_B4246
loc_B421C:
        mov byte [byte esi+034h], 6
        jmp short loc_B41EA
loc_B4222:
        mov byte [byte esi+034h], 4
        jmp short loc_B4242
loc_B4228:
        neg edx
        jo short loc_B41C3
        LD cmp, edx, ecx
        jb short loc_B4238
        je short loc_B423E
        mov byte [byte esi+034h], 7
        jmp short loc_B41E8
loc_B4238:
        mov byte [byte esi+034h], 5
        jmp short loc_B41EA
loc_B423E:
        mov byte [byte esi+034h], 3
loc_B4242:
        inc ecx
        mov dword [byte esi+018h], ecx
loc_B4246:
        mov ebx, dword [byte ebp-04h]
        je short loc_B4293
        jmp dword [nosplit cs:ebx*4+jpt_B4253]
jpt_B4253:
        dd loc_B4293
        dd loc_B4662
        dd loc_B447D
        dd loc_B447D
        dd loc_B4299
        dd loc_B4299
        dd loc_B4299
        dd loc_B4299
        dd loc_B4384
        dd loc_B4384
        dd loc_B4384
        dd loc_B4384
        dd loc_B4299
        dd loc_B4299
        dd loc_B4299
        dd loc_B4299
loc_B4293:
        LD xor, eax, eax
        pop edi
        pop esi
        leave
        ret
loc_B4299:
        mov eax, dword [byte esi+0Ch]
        mov ecx, dword [cliprect_y0]
        mov dword [byte esi+0Ch], ecx
        LD sub, ecx, eax
        mov bl, byte [byte esi+034h]
        jmp dword [nosplit cs:ebx*4+jpt_B42B2]
jpt_B42B2:
        db 00h,00h,00h,00h,00h,00h,00h,00h
        dd loc_B42D6
        dd loc_B42DE
        dd loc_B42E9
        dd loc_B42F4
        dd loc_B4306
        dd loc_B4318
        dd loc_B435B
loc_B42D6:
        sub dword [byte esi+018h], ecx
        jmp near loc_B47B3
loc_B42DE:
        sub dword [byte esi+04h], ecx
        sub dword [byte esi+018h], ecx
        jmp near loc_B47B3
loc_B42E9:
        add dword [byte esi+04h], ecx
        sub dword [byte esi+018h], ecx
        jmp near loc_B47B3
loc_B42F4:
        mov eax, dword [byte esi+030h]
        mul ecx
        sub dword [esi], eax
        sbb dword [byte esi+04h], edx
        sub dword [byte esi+018h], ecx
        jmp near loc_B47B3
loc_B4306:
        mov eax, dword [byte esi+030h]
        mul ecx
        add dword [esi], eax
        adc dword [byte esi+04h], edx
        sub dword [byte esi+018h], ecx
        jmp near loc_B47B3
loc_B4318:
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
        jle short loc_B4341
        mul dword [byte esi+030h]
        add dword [byte esi+08h], eax
        adc dword [byte esi+0Ch], edx
        jmp near loc_B47B3
loc_B4341:
        mov dword [byte esi+018h], 1
        mov eax, dword [cliprect_y0]
        mov dword [byte esi+0Ch], eax
        mov eax, dword [byte esi+010h]
        mov dword [byte esi+04h], eax
        jmp near loc_B47B3
loc_B435B:
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
        jle short loc_B4341
        mul dword [byte esi+030h]
        add dword [byte esi+08h], eax
        adc dword [byte esi+0Ch], edx
        jmp near loc_B47B3
loc_B4384:
        mov ecx, dword [byte esi+014h]
        mov edx, dword [cliprect_y1]
        dec edx
        mov dword [byte esi+014h], edx
        LD sub, ecx, edx
        mov bl, byte [byte esi+034h]
        jmp dword [nosplit cs:ebx*4+jpt_B439E]
jpt_B439E:
        db 00h,00h,00h,00h,00h,00h,00h,00h
        dd loc_B43C2
        dd loc_B43CA
        dd loc_B43D5
        dd loc_B43E0
        dd loc_B4408
        dd loc_B442B
        dd loc_B4456
loc_B43C2:
        sub dword [byte esi+018h], ecx
        jmp near loc_B47C1
loc_B43CA:
        add dword [byte esi+010h], ecx
        sub dword [byte esi+018h], ecx
        jmp near loc_B47C1
loc_B43D5:
        sub dword [byte esi+010h], ecx
        sub dword [byte esi+018h], ecx
        jmp near loc_B47C1
loc_B43E0:
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
        jmp near loc_B47C1
loc_B4408:
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
        jmp near loc_B47C1
loc_B442B:
        LD xor, eax, eax
        sub eax, dword [byte esi+08h]
        sbb edx, dword [byte esi+0Ch]
        jl short loc_B4452
        mov ecx, dword [byte esi+030h]
        div ecx
        shr ecx, 1
        LD sub, ecx, edx
        adc eax, byte 0
loc_B4441:
        mov edx, dword [byte esi+04h]
        LD sub, edx, eax
        mov dword [byte esi+010h], edx
        inc eax
        mov dword [byte esi+018h], eax
        jmp near loc_B47C1
loc_B4452:
        LD xor, eax, eax
        jmp short loc_B4441
loc_B4456:
        LD xor, eax, eax
        sub eax, dword [byte esi+08h]
        sbb edx, dword [byte esi+0Ch]
        jl short loc_B4452
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
        jmp near loc_B47C1
loc_B447D:
        mov bl, byte [byte esi+034h]
        jmp dword [nosplit cs:ebx*4+jpt_B4488]
jpt_B4488:
        db 00h,00h,00h,00h,00h,00h,00h,00h
        dd loc_B45CD
        dd loc_B44AC
        dd loc_B44C8
        dd loc_B44E4
        dd loc_B4521
        dd loc_B455A
        dd loc_B458F
loc_B44AC:
        mov ecx, dword [cliprect_x0]
        mov eax, dword [byte esi+010h]
        mov dword [byte esi+010h], ecx
        LD sub, ecx, eax
        add dword [byte esi+024h], ecx
        sub dword [byte esi+018h], ecx
        sub dword [byte esi+014h], ecx
        jmp near loc_B481A
loc_B44C8:
        mov eax, dword [byte esi+04h]
        mov ecx, dword [cliprect_x0]
        mov dword [byte esi+04h], ecx
        LD sub, ecx, eax
        add dword [byte esi+020h], ecx
        add dword [byte esi+0Ch], ecx
        sub dword [byte esi+018h], ecx
        jmp near loc_B481A
loc_B44E4:
        mov eax, dword [esi]
        mov edx, dword [byte esi+04h]
        mov ecx, dword [cliprect_x0]
        mov dword [byte esi+010h], ecx
        LD sub, edx, ecx
        jl short loc_B451A
        mov ecx, dword [byte esi+030h]
        div ecx
        shr ecx, 1
        LD sub, ecx, edx
        adc eax, byte 0
        inc eax
loc_B4503:
        mov ecx, dword [byte esi+018h]
        mov dword [byte esi+018h], eax
        LD sub, ecx, eax
        add dword [byte esi+024h], ecx
        dec eax
        add eax, dword [byte esi+0Ch]
        mov dword [byte esi+014h], eax
        jmp near loc_B481A
loc_B451A:
        mov eax, 1
        jmp short loc_B4503
loc_B4521:
        mov edx, dword [cliprect_x0]
        LD xor, eax, eax
        sub eax, dword [esi]
        sbb edx, dword [byte esi+04h]
        jl short loc_B4558
        mov ecx, dword [byte esi+030h]
        div ecx
        shr ecx, 1
        LD sub, ecx, edx
        adc eax, byte 0
        add dword [byte esi+0Ch], eax
        add dword [byte esi+020h], eax
        sub dword [byte esi+018h], eax
        jle near loc_B45CD
        mul dword [byte esi+030h]
        add dword [esi], eax
        adc dword [byte esi+04h], edx
        jmp near loc_B481A
loc_B4558:
        jmp short loc_B45CD
loc_B455A:
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
        jmp near loc_B481A
loc_B458F:
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
        jmp near loc_B481A
loc_B45CD:
        mov edx, 2
loc_B45D2:
        mov byte [byte esi+035h], dl
        mov dword [byte esi+018h], 0
        mov al, byte [byte esi+035h]
        test al, 4
        je short loc_B45F9
        mov ebx, dword [cliprect_y0]
        mov dword [byte esi+0Ch], ebx
        mov dword [byte esi+08h], 0
        dec ebx
        mov dword [byte esi+014h], ebx
        jmp short loc_B465B
loc_B45F9:
        test al, 8
        je short loc_B460F
        mov ebx, dword [cliprect_y1]
        mov dword [byte esi+0Ch], ebx
        mov dword [byte esi+08h], 0
        jmp short loc_B465B
loc_B460F:
        mov ecx, dword [byte esi+014h]
        cmp ecx, dword [cliprect_y1]
        jl short loc_B4621
        mov ecx, dword [cliprect_y1]
        dec ecx
loc_B4621:
        mov edx, dword [byte esi+0Ch]
        mov ebx, dword [byte esi+08h]
        add ebx, 80000000h
        adc edx, byte 0
        cmp edx, dword [cliprect_y0]
        jge short loc_B463E
        mov edx, dword [cliprect_y0]
loc_B463E:
        mov dword [byte esi+0Ch], edx
        mov dword [byte esi+08h], 0
        LD sub, ecx, edx
        dec edx
        inc ecx
        mov dword [byte esi+014h], edx
        test al, 2
        je short loc_B4658
        add dword [byte esi+024h], ecx
        jmp short loc_B465B
loc_B4658:
        add dword [byte esi+02Ch], ecx
loc_B465B:
        movzx eax, al
        pop edi
        pop esi
        leave
        ret
loc_B4662:
        movzx ebx, byte [byte esi+034h]
        jmp dword [nosplit cs:ebx*4+jpt_B466E]
jpt_B466E:
        db 00h,00h,00h,00h,00h,00h,00h,00h
        dd loc_B4692
        dd loc_B469C
        dd loc_B46B8
        dd loc_B46D5
        dd loc_B4705
        dd loc_B4740
        dd loc_B4780
loc_B4692:
        mov edx, 1
        jmp near loc_B45D2
loc_B469C:
        mov ecx, dword [byte esi+04h]
        mov eax, dword [cliprect_x1]
        dec eax
        mov dword [byte esi+04h], eax
        LD sub, ecx, eax
        add dword [byte esi+0Ch], ecx
        sub dword [byte esi+018h], ecx
        add dword [byte esi+028h], ecx
        jmp near loc_B4293
loc_B46B8:
        mov ecx, dword [cliprect_x1]
        dec ecx
        mov eax, dword [byte esi+010h]
        mov dword [byte esi+010h], ecx
        LD sub, eax, ecx
        add dword [byte esi+02Ch], eax
        sub dword [byte esi+018h], eax
        sub dword [byte esi+014h], eax
        jmp near loc_B4293
loc_B46D5:
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
        jle short loc_B4692
        add dword [byte esi+0Ch], eax
        add dword [byte esi+028h], eax
        mul dword [byte esi+030h]
        sub dword [esi], eax
        sbb dword [byte esi+04h], edx
        jmp near loc_B4293
loc_B4705:
        mov edx, dword [cliprect_x1]
        dec edx
        mov dword [byte esi+010h], edx
        LD xor, eax, eax
        sub eax, dword [esi]
        sbb edx, dword [byte esi+04h]
        jl near loc_B4692
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
        jmp near loc_B4293
loc_B4740:
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
        jmp near loc_B4293
loc_B4780:
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
        jmp near loc_B4293
loc_B47B3:
        test dword [byte ebp-04h], 8
        je short loc_B47C1
        jmp near loc_B4384
loc_B47C1:
        LD xor, edx, edx
        mov eax, dword [byte esi+04h]
        cmp eax, dword [cliprect_x0]
        jge short loc_B47D1
        or dh, 2
loc_B47D1:
        mov ebx, dword [esi]
        add ebx, 80000000h
        adc eax, byte 0
        cmp eax, dword [cliprect_x1]
        jl short loc_B47E7
        or dh, 1
loc_B47E7:
        mov eax, dword [byte esi+010h]
        cmp eax, dword [cliprect_x0]
        jge short loc_B47F5
        or dl, 2
loc_B47F5:
        cmp eax, dword [cliprect_x1]
        jl short loc_B4800
        or dl, 1
loc_B4800:
        test dh, dl
        je short loc_B480B
        LD and, dl, dh
        jmp near loc_B45D2
loc_B480B:
        LD or, dl, dh
        je short loc_B4828
        movzx edx, dl
        mov dword [byte ebp-04h], edx
        jmp near loc_B4246
loc_B481A:
        test dword [byte ebp-04h], 1
        je short loc_B4828
        jmp near loc_B4662
loc_B4828:
        jmp near loc_B4293
loc_B482D:
        mov byte [byte esi+034h], 1
        LD cmp, ecx, edx
        jne short loc_B4839
        mov byte [byte esi+034h], 9
loc_B4839:
        jle short loc_B4847
        mov byte [byte esi+034h], 0
        mov dword [byte esi+04h], edx
        mov dword [byte esi+010h], ecx
        db 087h,0CAh                            ; insn: xchg ecx,edx
loc_B4847:
        cmp byte [byte ebp-05h], 0
        jne short loc_B4870
        mov ebx, dword [cliprect_y0]
        LD cmp, eax, ebx
        jge short loc_B487B
        mov al, 4
        mov dword [byte esi+0Ch], ebx
        mov dword [byte esi+014h], ebx
loc_B485F:
        mov byte [byte esi+035h], al
        mov dword [byte esi+018h], 0
        movzx eax, al
        pop edi
        pop esi
        leave
        ret
loc_B4870:
        LD sub, edx, ecx
        inc edx
        mov dword [byte esi+018h], edx
        jmp near loc_B4293
loc_B487B:
        mov ebx, dword [cliprect_y1]
        LD cmp, eax, ebx
        jl short loc_B488F
        mov al, 8
        mov dword [byte esi+0Ch], ebx
        mov dword [byte esi+014h], ebx
        jmp short loc_B485F
loc_B488F:
        LD mov, eax, edx
        LD sub, eax, ecx
        inc eax
        mov dword [byte esi+018h], eax
        cmp edx, dword [cliprect_x0]
        jge short loc_B48AD
        dec dword [byte esi+014h]
        mov dword [byte esi+024h], 1
        mov al, 2
        jmp short loc_B485F
loc_B48AD:
        cmp ecx, dword [cliprect_x1]
        jl short loc_B48C3
        dec dword [byte esi+014h]
        mov dword [byte esi+02Ch], 1
        mov al, 1
        jmp short loc_B485F
loc_B48C3:
        mov eax, dword [cliprect_x0]
        LD mov, ebx, eax
        LD sub, eax, ecx
        jle short loc_B48D4
        mov dword [byte esi+04h], ebx
        sub dword [byte esi+018h], eax
loc_B48D4:
        LD mov, eax, edx
        mov ebx, dword [cliprect_x1]
        dec ebx
        LD sub, eax, ebx
        jle short loc_B48E7
        sub dword [byte esi+018h], eax
        mov dword [byte esi+010h], ebx
loc_B48E7:
        jmp near loc_B4293
loc_B48EC:
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
loc_B4908:
        cmp dword [byte esi+0Ch], 0FFFFC180h
        jg short loc_B494D
loc_B4911:
        mov eax, dword [byte esi+0Ch]
        LD add, eax, ecx
        mov dword [byte esi+0Ch], eax
        LD mov, ebx, eax
        sub eax, dword [cliprect_y0]
        jle short loc_B4948
        LD cmp, eax, ecx
        jle short loc_B4929
        LD mov, eax, ecx
loc_B4929:
        sub ebx, dword [cliprect_y1]
        jle short loc_B4935
        LD sub, eax, ebx
        jle short loc_B4948
loc_B4935:
        mov ebx, dword [byte esi+04h]
        cmp ebx, dword [cliprect_x0]
        jge short loc_B4945
        add dword [byte esi+020h], eax
        jmp short loc_B4948
loc_B4945:
        add dword [byte esi+028h], eax
loc_B4948:
        add dword [byte esi+04h], edx
        jmp short loc_B4908
loc_B494D:
        cmp dword [byte esi+014h], 3E80h
        jge short loc_B497F
        cmp dword [byte esi+04h], 0FFFFC180h
        jle short loc_B4911
        cmp dword [byte esi+04h], 3E80h
        jge short loc_B4911
        cmp dword [byte esi+010h], 0FFFFC180h
        jle short loc_B497F
        cmp dword [byte esi+010h], 3E80h
        jge short loc_B497F
        jmp near loc_B413C
loc_B497F:
        mov eax, dword [byte esi+014h]
        LD sub, eax, ecx
        mov dword [byte esi+014h], eax
        LD mov, ebx, eax
        sub eax, dword [cliprect_y1]
        inc eax
        jge short loc_B49BA
        neg eax
        LD cmp, eax, ecx
        jle short loc_B499A
        LD mov, eax, ecx
loc_B499A:
        sub ebx, dword [cliprect_y0]
        inc ebx
        jge short loc_B49A7
        LD add, eax, ebx
        jle short loc_B49BA
loc_B49A7:
        mov ebx, dword [byte esi+010h]
        cmp ebx, dword [cliprect_x0]
        jge short loc_B49B7
        add dword [byte esi+024h], eax
        jmp short loc_B49BA
loc_B49B7:
        add dword [byte esi+02Ch], eax
loc_B49BA:
        sub dword [byte esi+010h], edx
        jmp short loc_B494D
        db 00h
AngleFromDelta:
        push ebp
        LD mov, ebp, esp
        LD xor, ebx, ebx
        mov ecx, dword [byte ebp+0Ch]
        mov edx, dword [byte ebp+08h]
        LD or, ecx, ecx
        jge short loc_B49D4
        or ebx, byte 8
        neg ecx
loc_B49D4:
        LD or, edx, edx
        jge short loc_B49DD
        or ebx, byte 10h
        neg edx
loc_B49DD:
        LD cmp, edx, ecx
        jl short loc_B49E8
        je short loc_B4A00
        db 087h,0CAh                            ; insn: xchg ecx,edx
        or ebx, byte 4
loc_B49E8:
        LD xor, eax, eax
        div ecx
        shr eax, 18h
        adc eax, byte 0
        movzx eax, byte [dword eax+byte_D6074]
        jmp dword [dword cs:ebx+unk_B4A0C]
loc_B4A00:
        mov eax, 80h
        jmp dword [dword cs:ebx+unk_B4A0C]
unk_B4A0C:
        dd loc_B4A33
        dd loc_B4A2C
        dd loc_B4A35
        dd loc_B4A3E
        dd loc_B4A45
        dd loc_B4A49
        dd loc_B4A50
        dd loc_B4A57
loc_B4A2C:
        neg eax
        add eax, 100h
loc_B4A33:
        leave
        ret
loc_B4A35:
        neg eax
        add eax, 200h
        leave
        ret
loc_B4A3E:
        add eax, 100h
        leave
        ret
loc_B4A45:
        neg eax
        leave
        ret
loc_B4A49:
        sub eax, 100h
        leave
        ret
loc_B4A50:
        sub eax, 200h
        leave
        ret
loc_B4A57:
        neg eax
        sub eax, 100h
        leave
        ret
sub_B4A60:
        mov eax, dword [byte esp+04h]
        jmp short loc_B4A6C
sub_B4A66:
        mov eax, dword [byte esp+04h]
        inc ah
loc_B4A6C:
        movzx eax, ax
        and ah, 3
        jnp short loc_B4A7E
        jne short loc_B4A96
        mov eax, dword [nosplit eax*4+dword_D6178]
        ret
loc_B4A7E:
        dec ah
        jne short loc_B4A8C
        neg eax
        mov eax, dword [nosplit eax*4+dword_D6578]
        ret
loc_B4A8C:
        mov eax, dword [nosplit eax*4+dword_D5D78]
        neg eax
        ret
loc_B4A96:
        neg eax
        mov eax, dword [nosplit eax*4+dword_D7178]
        neg eax
        ret
        db 00h,00h
DispatchHotkey:
        push ebp
        LD mov, ebp, esp
        dec dword [dword_D5562]
        jne short loc_B4AF2
        mov ebx, dword [byte ebp+08h]
        LD or, bl, bl
        je short loc_B4ADA
        and ebx, byte 7Fh
        mov dword [byte ebp+08h], ebx
        mov bl, byte [dword ebx+byte_D545C]
loc_B4AC2:
        dec ebx
        jl short loc_B4AF2
        push edi
        push esi
        call dword [nosplit ebx*4+dword_D5566]
        pop esi
        pop edi
        LD xor, eax, eax
        inc dword [dword_D5562]
        leave
        ret
loc_B4ADA:
        movzx ebx, bh
        cmp ebx, 84h
        jl short loc_B4AEA
        mov ebx, 84h
loc_B4AEA:
        mov bl, byte [dword ebx+byte_D54DC]
        jmp short loc_B4AC2
loc_B4AF2:
        mov eax, dword [byte ebp+08h]
        inc dword [dword_D5562]
        leave
        ret
sub_B4AFD:
        push ebp
        LD mov, ebp, esp
        mov eax, dword [byte ebp+0Ch]
        mov ecx, 40h
        mov ebx, dword_D5566
loc_B4B0D:
        cmp dword [ebx], eax
        je short loc_B4B20
        cmp word [ebx], byte 0
        je short loc_B4B1E
        add ebx, byte 4
        loop loc_B4B0D
        leave
        ret
loc_B4B1E:
        mov dword [ebx], eax
loc_B4B20:
        mov eax, 41h
        LD sub, eax, ecx
loc_B4B27:
        mov ebx, dword [byte ebp+08h]
        LD or, bl, bl
        je short loc_B4B3B
        cmp ebx, byte 7Fh
        jg short loc_B4B39
        mov byte [dword ebx+byte_D545C], al
loc_B4B39:
        leave
        ret
loc_B4B3B:
        movzx ebx, bh
        cmp ebx, 84h
        jg short loc_B4B39
        mov byte [dword ebx+byte_D54DC], al
        leave
        ret
        push ebp
        LD mov, ebp, esp
        LD xor, eax, eax
        jmp short loc_B4B27
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
loc_B4BA0:
        lodsb
        out dx, al
        loop loc_B4BA0
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
        jge short loc_B4BDE
        mov eax, 0
loc_B4BDE:
        cmp ecx, byte 0
        jge short loc_B4BE8
        mov ecx, 0
loc_B4BE8:
        cmp edx, dword [ScreenWidth]
        jle short loc_B4BF6
        mov edx, dword [ScreenWidth]
loc_B4BF6:
        cmp ebx, dword [dword_D30A8]
        jle short loc_B4C04
        mov ebx, dword [dword_D30A8]
loc_B4C04:
        mov dword [cliprect_x0], eax
        mov dword [cliprect_y0], ecx
        mov dword [cliprect_x1], edx
        mov dword [cliprect_y1], ebx
        mov dword [dword_D30BC], eax
        mov dword [dword_D30C0], edx
        ret
        db 00h
sub_B4C28:
        mov dword [dword_D429C], 2710h
        ret
WaitRetrace:
        mov dx, 3DAh
        mov ecx, dword [dword_D429C]
        cmp dword [dword_D4FA0], byte 1
        jg short loc_B4C56
        je short loc_B4C4F
loc_B4C48:
        in al, dx
        test al, 8
        loopne loc_B4C48
        jecxz sub_B4C28
loc_B4C4F:
        in al, dx
        test al, 8
        loope loc_B4C4F
        jecxz sub_B4C28
loc_B4C56:
        mov dword [dword_D429C], 186A0h
        ret
sub_B4C61:
        mov dx, 3DAh
        mov ecx, dword [dword_D429C]
loc_B4C6B:
        in al, dx
        test al, 8
        loopne loc_B4C6B
        jecxz sub_B4C28
loc_B4C72:
        in al, dx
        test al, 8
        loope loc_B4C72
        jecxz sub_B4C28
        mov dword [dword_D429C], 186A0h
        ret
sub_B4C84:
        mov dx, 3DAh
        mov ecx, dword [dword_D429C]
loc_B4C8E:
        in al, dx
        test al, 8
        loope loc_B4C8E
        jecxz sub_B4C28
loc_B4C95:
        in al, dx
        test al, 8
        loopne loc_B4C95
        jecxz sub_B4C28
        mov dword [dword_D429C], 186A0h
        ret
sub_B4CA7:
        mov dx, 3DAh
        in al, dx
        and ax, byte 8
        ret
        db 00h,00h,00h
sub_B4CB4:
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
        jmp short loc_B4D0C
