; Reading the joystick.
bits 32
%include "hockey.inc"
section s_B300C progbits alloc exec nowrite align=1
extern __GETDS, atexit_, byte_D4168, byte_D416A, byte_D4174, byte_D4175, byte_D4176, joyedgedir
extern byte_D4244, byte_D4245, byte_D4246, byte_D4280, cliprect_x0, cliprect_x1, cliprect_y0, cliprect_y1
extern BiosKeyFunc, dword_D3090, dword_D3096, ScreenWidth, dword_D4158, dword_D415C, dword_D4160, dword_D4164
extern JoyAxisY2, JoyAxisMask, JoyX1Threshold, dword_D417B, JoyX1Center, dword_D4183, dword_D4187, dword_D418B
extern dword_D418F, JoyY1Threshold, dword_D4197, JoyY1Center, dword_D419F, dword_D41A3, dword_D41A7, dword_D41AB
extern JoyXScale, JoyYScale, dword_D41FC, dword_D4200, dword_D4204, dword_D4208, dword_D420C, dword_D4210
extern dword_D4214, dword_D4218, dword_D421C, dword_D4220, dword_D4224, dword_D4228, dword_D422C, dword_D4230
extern dword_D4234, dword_D4238, dword_D423C, dword_D4240, dword_D4248, dword_D424C, dword_D4250, dword_D4254
extern dword_D4258, dword_D425C, dword_D4260, dword_D4264, dword_D4268, dword_D426C, dword_D4270, dword_D4274
extern dword_D4278, dword_D427C, exit_, FatalError, joyenablemask, KbdIdleHook, FillRect, DosGetVector
extern DosSetVector, tickcount, tickdeadline, ticklast, unk_8E870, word_D3094, word_D309A
global sub_B300C, sub_B3010, sub_B3036, loc_B3089, sub_B308B, loc_B30B0, FindShape, FindShapeQuiet
global loc_B30BD, loc_B30D1, loc_B30E3, loc_B30F1, sub_B30F4, loc_B3115, loc_B3129, loc_B3132
global loc_B3156, ReadJoystickPorts, loc_B31A5, loc_B31A9, loc_B31BB, loc_B31BF, loc_B31D0, loc_B31DB
global loc_B3207, loc_B3219, loc_B322F, loc_B3258, loc_B3277, loc_B3285, loc_B32A3, loc_B32BE
global loc_B32E9, loc_B32FB, loc_B3311, loc_B333A, loc_B3346, loc_B3365, loc_B3373, loc_B3391
global loc_B33A8, loc_B33BA, loc_B33C1, loc_B33C7, loc_B33D2, JoyResetCentres, JoyButtonMap, sub_B3421
global loc_B3430, loc_B3449, AddExitHandler, sub_B345D, ReadJoyRaw, loc_B3471, loc_B34B1, loc_B34B5
global loc_B34C7, loc_B34CB, loc_B34CF, loc_B34D3, loc_B34E4, loc_B34F1, loc_B34FE, loc_B3509
global loc_B3518, loc_B3532, loc_B3548, loc_B3573, loc_B3593, loc_B35A1, loc_B35B5, loc_B35CC
global loc_B35E6, loc_B35FC, loc_B3627, loc_B3630, loc_B3650, loc_B365E, loc_B3672, loc_B3689
global loc_B369C, loc_B36A5, loc_B36B3, loc_B36CD, loc_B36E3, loc_B370E, loc_B372E, loc_B373C
global loc_B3750, loc_B3767, loc_B3781, loc_B3797, loc_B37C2, loc_B37CB, loc_B37EB, loc_B37F9
global loc_B380D, loc_B3824, loc_B3838, loc_B3845, sub_B384E, sub_B387E, sub_B38AE, loc_B38BD
global loc_B38DC, loc_B38FB, loc_B391A, ClearScreen, GetTicks, TicksSince, TicksSinceLastCall, ResetTicks
global SetTickDeadline, WaitTickDeadline, TickDeadlinePassed, WaitTicks, loc_B39C3, KbdGetKey, loc_B39DE, loc_B39EC
global PollKey, sub_B39F3, loc_B3A01, loc_B3A07, WaitKey, KbdFlush, sub_B3A2F, loc_B3A47
global loc_B3A59, loc_B3A70, SaveDrawState, RestoreDrawState, bcopy, loc_B3ADF
sub_B300C:
        LD xor, eax, eax
        ret
        db 00h
sub_B3010:
        sti
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        push ds
        push es
        push fs
        push gs
        call __GETDS
        call dword [cs:dword_D3096]
        pop gs
        pop fs
        pop es
        pop ds
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        iret
sub_B3036:
        push ebp
        LD mov, ebp, esp
        mov eax, dword [byte ebp+08h]
        mov dword [dword_D3096], eax
        mov ax, cs
        mov word [word_D309A], ax
        cmp word [word_D3094], byte 0
        jne short loc_B3089
        db 0BBh,024h,00h,00h,00h                ; insn: mov ebx,24h
        db 0E8h                                 ; insn: call 0009864Ch
        dd DosGetVector-$-4
        mov dword [dword_D3090], eax
        mov word [word_D3094], dx
        mov ebx, 24h
        mov dx, cs
        mov eax, sub_B3010
        call DosSetVector
        push sub_B308B
        call AddExitHandler
        add esp, byte 4
loc_B3089:
        leave
        ret
sub_B308B:
        pusha
        mov ebx, 24h
        mov dx, word [word_D3094]
        mov eax, dword [dword_D3090]
        LD or, dx, dx
        je short loc_B30B0
        call DosSetVector
        mov word [word_D3094], 0
loc_B30B0:
        popa
        ret
        db 00h,00h
FindShape:
        mov ebx, unk_8E870
        jmp short loc_B30BD
FindShapeQuiet:
        LD xor, ebx, ebx
loc_B30BD:
        mov edx, dword [byte esp+04h]
        mov eax, dword [byte esp+08h]
        mov eax, dword [eax]
        mov ecx, dword [byte edx+08h]
        add edx, byte 10h
        LD or, ecx, ecx
        jle short loc_B30E3
loc_B30D1:
        add edx, byte 8
        cmp eax, dword [byte edx-08h]
        loopne loc_B30D1
        jne short loc_B30E3
        mov eax, dword [byte edx-04h]
        add eax, dword [byte esp+04h]
        ret
loc_B30E3:
        LD or, ebx, ebx
        je short loc_B30F1
        push dword [byte esp+08h]
        push ebx
        call FatalError
loc_B30F1:
        LD xor, eax, eax
        ret
sub_B30F4:
        push ebp
        push esi
        push edi
        LD xor, eax, eax
        mov ah, byte [byte_D416A]
        mov ecx, 2710h
        mov edx, 201h
        LD xor, ebx, ebx
        LD mov, ebp, ebx
        LD mov, esi, ebx
        LD mov, edi, ebx
        cli
        out dx, al
        jmp short loc_B3129
loc_B3115:
        shr al, 1
        adc ebp, byte 0
        shr al, 1
        adc esi, byte 0
        shr al, 1
        adc edi, byte 0
        shr al, 1
        adc ebx, byte 0
loc_B3129:
        in al, dx
        test ah, al
        loopne loc_B3115
        sti
        jcxz loc_B3156
loc_B3132:
        shr al, 4
        mov byte [byte_D4168], al
        mov dword [dword_D4158], ebp
        mov dword [dword_D415C], esi
        mov dword [dword_D4160], edi
        mov dword [dword_D4164], ebx
        pop edi
        pop esi
        pop ebp
        ret
loc_B3156:
        LD mov, ah, al
        not ah
        and ah, 0Fh
        mov byte [byte_D416A], ah
        jmp short loc_B3132
        db 00h,00h,00h
ReadJoystickPorts:
        mov byte [byte_D4176], 0
        test byte [joyenablemask], 1
        je near loc_B33C7
        mov dx, 201h
        in al, dx
        and al, 30h
        mov byte [byte_D4175], al
        mov bl, 3
        mov dword [JoyAxisY2], 50h
        mov dword [JoyAxisMask], 50h
        cli
        out dx, al
        mov ecx, 14h
loc_B31A5:
        loop loc_B31A5
        LD xor, ecx, ecx
loc_B31A9:
        in al, dx
        LD and, al, bl
        LD xor, al, bl
        jne short loc_B31BB
        inc ecx
        cmp ecx, 0FA0h
        jl short loc_B31A9
        jmp short loc_B31DB
loc_B31BB:
        test al, 1
        jne short loc_B31D0
loc_B31BF:
        test al, 2
        je short loc_B31A9
        mov dword [JoyAxisMask], ecx
        and bl, 1
        jne short loc_B31A9
        jmp short loc_B31DB
loc_B31D0:
        mov dword [JoyAxisY2], ecx
        and bl, 2
        jne short loc_B31BF
loc_B31DB:
        sti
        mov eax, dword [JoyAxisY2]
        cmp eax, dword [JoyX1Threshold]
        jge short loc_B3258
        dec dword [dword_D4187]
        jle short loc_B3207
        cmp eax, dword [dword_D417B]
        jl near loc_B32A3
        mov dword [dword_D417B], eax
        jmp near loc_B32A3
loc_B3207:
        mov ebx, dword [dword_D417B]
        mov dword [JoyX1Threshold], ebx
        mov ebx, dword [JoyX1Center]
loc_B3219:
        sub ebx, dword [JoyX1Threshold]
        jle short loc_B322F
        LD xor, edx, edx
        mov eax, 4000h
        div ebx
        mov dword [JoyXScale], eax
loc_B322F:
        LD mov, eax, ebx
        mov dx, 201h
        shr eax, 1
        LD mov, ebx, eax
        shr ebx, 1
        add eax, dword [JoyX1Threshold]
        LD add, eax, ebx
        mov dword [dword_D418F], eax
        LD sub, eax, ebx
        LD sub, eax, ebx
        mov dword [dword_D418B], eax
        mov eax, dword [JoyAxisY2]
        jmp short loc_B3285
loc_B3258:
        cmp eax, dword [JoyX1Center]
        jle short loc_B3285
        dec dword [dword_D4187]
        jle short loc_B3277
        cmp eax, dword [dword_D4183]
        jge short loc_B32A3
        mov dword [dword_D4183], eax
        jmp short loc_B32A3
loc_B3277:
        mov ebx, dword [dword_D4183]
        mov dword [JoyX1Center], ebx
        jmp short loc_B3219
loc_B3285:
        mov dword [dword_D4187], 14h
        mov dword [dword_D4183], 4E20h
        mov dword [dword_D417B], 0
loc_B32A3:
        cmp eax, dword [dword_D418B]
        jl near loc_B333A
        cmp eax, dword [dword_D418F]
        jl short loc_B32BE
        or byte [byte_D4176], 4
loc_B32BE:
        mov eax, dword [JoyAxisMask]
        cmp eax, dword [JoyY1Threshold]
        jae short loc_B3346
        dec dword [dword_D41A3]
        jle short loc_B32E9
        cmp eax, dword [dword_D4197]
        jl near loc_B3391
        mov dword [dword_D4197], eax
        jmp near loc_B3391
loc_B32E9:
        mov ebx, dword [dword_D4197]
        mov dword [JoyY1Threshold], ebx
        mov ebx, dword [JoyY1Center]
loc_B32FB:
        sub ebx, dword [JoyY1Threshold]
        jle short loc_B3311
        LD xor, edx, edx
        mov eax, 4000h
        div ebx
        mov dword [JoyYScale], eax
loc_B3311:
        LD mov, eax, ebx
        mov dx, 201h
        shr eax, 1
        LD mov, ebx, eax
        shr ebx, 1
        add eax, dword [JoyY1Threshold]
        LD add, eax, ebx
        mov dword [dword_D41AB], eax
        LD sub, eax, ebx
        LD sub, eax, ebx
        mov dword [dword_D41A7], eax
        mov eax, dword [JoyAxisMask]
        jmp short loc_B3373
loc_B333A:
        or byte [byte_D4176], 8
        jmp near loc_B32BE
loc_B3346:
        cmp eax, dword [JoyY1Center]
        jle short loc_B3373
        dec dword [dword_D41A3]
        je short loc_B3365
        cmp eax, dword [dword_D419F]
        jge short loc_B3391
        mov dword [dword_D419F], eax
        jmp short loc_B3391
loc_B3365:
        mov ebx, dword [dword_D419F]
        mov dword [JoyY1Center], ebx
        jmp short loc_B32FB
loc_B3373:
        mov dword [dword_D41A3], 14h
        mov dword [dword_D419F], 4E20h
        mov dword [dword_D4197], 0
loc_B3391:
        cmp eax, dword [dword_D41A7]
        jb short loc_B33D2
        cmp eax, dword [dword_D41AB]
        jb short loc_B33A8
        or byte [byte_D4176], 2
loc_B33A8:
        in al, dx
        and al, 30h
        cmp al, byte [byte_D4175]
        je short loc_B33BA
        mov al, byte [byte_D4174]
        jmp short loc_B33C1
loc_B33BA:
        xor al, 30h
        mov byte [byte_D4174], al
loc_B33C1:
        or byte [byte_D4176], al
loc_B33C7:
        mov al, byte [byte_D4176]
        LD xor, ah, ah
        movzx eax, ax
        ret
loc_B33D2:
        or byte [byte_D4176], 1
        jmp short loc_B33A8
JoyResetCentres:
        mov byte [joyenablemask], 1
        mov dword [JoyX1Threshold], 50h
        mov dword [JoyX1Center], 0
        mov dword [JoyY1Threshold], 50h
        mov dword [JoyY1Center], 0
        ret
JoyButtonMap:
        push ebp
        LD mov, ebp, esp
        mov ebx, dword [byte ebp+08h]
        and ebx, byte 0Fh
        mov al, byte [dword ebx+joyedgedir]
        LD xor, ah, ah
        movzx eax, ax
        leave
        ret
sub_B3421:
        mov eax, dword [JoyAxisY2]
        sub eax, dword [JoyX1Threshold]
        jge short loc_B3430
        LD xor, eax, eax
loc_B3430:
        mul dword [JoyXScale]
        sub eax, byte 1Fh
        ret
        mov eax, dword [JoyAxisMask]
        sub eax, dword [JoyY1Threshold]
        jge short loc_B3449
        LD xor, eax, eax
loc_B3449:
        mul dword [JoyYScale]
        sub eax, byte 1Fh
        ret
        db 00h
AddExitHandler:
        mov eax, dword [byte esp+04h]
        jmp near atexit_
sub_B345D:
        LD xor, eax, eax
        call exit_
ReadJoyRaw:
        mov bl, byte [joyenablemask]
        LD or, bl, bl
        jne short loc_B3471
        LD xor, eax, eax
        ret
loc_B3471:
        mov byte [byte_D4245], 0
        mov byte [byte_D4246], 0
        mov dx, 201h
        in al, dx
        mov byte [byte_D4244], al
        LD xor, bh, bh
        mov bl, byte [dword ebx+byte_D4280]
        mov ax, 50h
        cwde
        mov dword [dword_D423C], eax
        mov dword [dword_D4240], eax
        mov dword [dword_D41FC], eax
        mov dword [dword_D4200], eax
        cli
        out dx, al
        mov ecx, 14h
loc_B34B1:
        loop loc_B34B1
        LD xor, ecx, ecx
loc_B34B5:
        in al, dx
        LD and, al, bl
        LD xor, al, bl
        jne short loc_B34C7
        inc ecx
        cmp ecx, 0FA0h
        jl short loc_B34B5
        jmp short loc_B3509
loc_B34C7:
        test al, 1
        jne short loc_B34E4
loc_B34CB:
        test al, 2
        jne short loc_B34F1
loc_B34CF:
        test al, 4
        jne short loc_B34FE
loc_B34D3:
        test al, 8
        je short loc_B34B5
        mov dword [dword_D4200], ecx
        and bl, 7
        jne short loc_B34B5
        jmp short loc_B3509
loc_B34E4:
        mov dword [dword_D423C], ecx
        and bl, 0Eh
        jne short loc_B34CB
        jmp short loc_B3509
loc_B34F1:
        mov dword [dword_D4240], ecx
        and bl, 0Dh
        jne short loc_B34CF
        jmp short loc_B3509
loc_B34FE:
        mov dword [dword_D41FC], ecx
        and bl, 0Bh
        jne short loc_B34D3
loc_B3509:
        sti
        test byte [joyenablemask], 1
        jne short loc_B3518
        jmp near loc_B36A5
loc_B3518:
        mov ebx, dword [dword_D423C]
        cmp ebx, dword [dword_D4248]
        jge short loc_B3573
        mov dword [dword_D4248], ebx
        mov ebx, dword [dword_D424C]
loc_B3532:
        sub ebx, dword [dword_D4248]
        jle short loc_B3548
        LD xor, edx, edx
        mov eax, 4000h
        div ebx
        mov dword [dword_D4278], eax
loc_B3548:
        LD mov, eax, ebx
        mov edx, 201h
        shr eax, 1
        LD mov, ebx, eax
        shr ebx, 1
        add eax, dword [dword_D4248]
        LD add, eax, ebx
        mov dword [dword_D425C], eax
        LD sub, eax, ebx
        LD sub, eax, ebx
        mov dword [dword_D4258], eax
        mov ebx, dword [dword_D423C]
        jmp short loc_B35A1
loc_B3573:
        cmp ebx, dword [dword_D424C]
        jle short loc_B35A1
        dec dword [dword_D4254]
        je short loc_B3593
        cmp ebx, dword [dword_D4250]
        jge short loc_B35B5
        mov dword [dword_D4250], ebx
        jmp short loc_B35B5
loc_B3593:
        mov ebx, dword [dword_D4250]
        mov dword [dword_D424C], ebx
        jmp short loc_B3532
loc_B35A1:
        mov dword [dword_D4254], 8
        mov dword [dword_D4250], 4E20h
loc_B35B5:
        cmp ebx, dword [dword_D4258]
        jl short loc_B3627
        cmp ebx, dword [dword_D425C]
        jl short loc_B35CC
        or byte [byte_D4245], 4
loc_B35CC:
        mov ebx, dword [dword_D4240]
        cmp ebx, dword [dword_D4260]
        jae short loc_B3630
        mov dword [dword_D4260], ebx
        mov ebx, dword [dword_D4264]
loc_B35E6:
        sub ebx, dword [dword_D4260]
        jle short loc_B35FC
        LD xor, edx, edx
        mov eax, 4000h
        div ebx
        mov dword [dword_D427C], eax
loc_B35FC:
        LD mov, eax, ebx
        mov edx, 201h
        shr eax, 1
        LD mov, ebx, eax
        shr ebx, 1
        add eax, dword [dword_D4260]
        LD add, eax, ebx
        mov dword [dword_D4274], eax
        LD sub, eax, ebx
        LD sub, eax, ebx
        mov dword [dword_D4270], eax
        mov ebx, dword [dword_D4240]
        jmp short loc_B365E
loc_B3627:
        or byte [byte_D4245], 8
        jmp short loc_B35CC
loc_B3630:
        cmp ebx, dword [dword_D4264]
        jle short loc_B365E
        dec dword [dword_D426C]
        je short loc_B3650
        cmp ebx, dword [dword_D4268]
        jge short loc_B3672
        mov dword [dword_D4268], ebx
        jmp short loc_B3672
loc_B3650:
        mov ebx, dword [dword_D4268]
        mov dword [dword_D4264], ebx
        jmp short loc_B35E6
loc_B365E:
        mov dword [dword_D426C], 8
        mov dword [dword_D4268], 4E20h
loc_B3672:
        cmp ebx, dword [dword_D4270]
        jb short loc_B369C
        cmp ebx, dword [dword_D4274]
        jb short loc_B3689
        or byte [byte_D4245], 2
loc_B3689:
        in al, dx
        and al, byte [byte_D4244]
        and al, 30h
        xor al, 30h
        or byte [byte_D4245], al
        jmp short loc_B36A5
loc_B369C:
        or byte [byte_D4245], 1
        jmp short loc_B3689
loc_B36A5:
        test byte [joyenablemask], 2
        jne short loc_B36B3
        jmp near loc_B3838
loc_B36B3:
        mov ebx, dword [dword_D41FC]
        cmp ebx, dword [dword_D4204]
        jge short loc_B370E
        mov dword [dword_D4204], ebx
        mov ebx, dword [dword_D4208]
loc_B36CD:
        sub ebx, dword [dword_D4204]
        jle short loc_B36E3
        LD xor, edx, edx
        mov eax, 4000h
        div ebx
        mov dword [dword_D4234], eax
loc_B36E3:
        LD mov, eax, ebx
        mov edx, 201h
        shr eax, 1
        LD mov, ebx, eax
        shr ebx, 1
        add eax, dword [dword_D4204]
        LD add, eax, ebx
        mov dword [dword_D4218], eax
        LD sub, eax, ebx
        LD sub, eax, ebx
        mov dword [dword_D4214], eax
        mov ebx, dword [dword_D41FC]
        jmp short loc_B373C
loc_B370E:
        cmp ebx, dword [dword_D4208]
        jle short loc_B373C
        dec dword [dword_D4210]
        je short loc_B372E
        cmp ebx, dword [dword_D420C]
        jge short loc_B3750
        mov dword [dword_D420C], ebx
        jmp short loc_B3750
loc_B372E:
        mov ebx, dword [dword_D420C]
        mov dword [dword_D4208], ebx
        jmp short loc_B36CD
loc_B373C:
        mov dword [dword_D4210], 8
        mov dword [dword_D420C], 4E20h
loc_B3750:
        cmp ebx, dword [dword_D4214]
        jl short loc_B37C2
        cmp ebx, dword [dword_D4218]
        jl short loc_B3767
        or byte [byte_D4246], 4
loc_B3767:
        mov ebx, dword [dword_D4200]
        cmp ebx, dword [dword_D421C]
        jae short loc_B37CB
        mov dword [dword_D421C], ebx
        mov ebx, dword [dword_D4220]
loc_B3781:
        sub ebx, dword [dword_D421C]
        jle short loc_B3797
        LD xor, edx, edx
        mov eax, 4000h
        div ebx
        mov dword [dword_D4238], eax
loc_B3797:
        LD mov, eax, ebx
        mov edx, 201h
        shr eax, 1
        LD mov, ebx, eax
        shr ebx, 1
        add eax, dword [dword_D421C]
        LD add, eax, ebx
        mov dword [dword_D4230], eax
        LD sub, eax, ebx
        LD sub, eax, ebx
        mov dword [dword_D422C], eax
        mov ebx, dword [dword_D4200]
        jmp short loc_B37F9
loc_B37C2:
        or byte [byte_D4246], 8
        jmp short loc_B3767
loc_B37CB:
        cmp ebx, dword [dword_D4220]
        jle short loc_B37F9
        dec dword [dword_D4228]
        je short loc_B37EB
        cmp ebx, dword [dword_D4224]
        jge short loc_B380D
        mov dword [dword_D4224], ebx
        jmp short loc_B380D
loc_B37EB:
        mov ebx, dword [dword_D4224]
        mov dword [dword_D4220], ebx
        jmp short loc_B3781
loc_B37F9:
        mov dword [dword_D4228], 8
        mov dword [dword_D4224], 4E20h
loc_B380D:
        cmp ebx, dword [dword_D422C]
        jb short loc_B3845
        cmp ebx, dword [dword_D4230]
        jb short loc_B3824
        or byte [byte_D4246], 2
loc_B3824:
        in al, dx
        and al, byte [byte_D4244]
        and al, 0C0h
        xor al, 0C0h
        shr al, 2
        or byte [byte_D4246], al
loc_B3838:
        mov al, byte [byte_D4245]
        mov ah, byte [byte_D4246]
        cwde
        ret
loc_B3845:
        or byte [byte_D4246], 1
        jmp short loc_B3824
sub_B384E:
        or byte [joyenablemask], 1
        mov dword [dword_D4248], 50h
        mov dword [dword_D424C], 0
        mov dword [dword_D4260], 50h
        mov dword [dword_D4264], 0
        ret
sub_B387E:
        or byte [joyenablemask], 2
        mov dword [dword_D4204], 50h
        mov dword [dword_D4208], 0
        mov dword [dword_D421C], 50h
        mov dword [dword_D4220], 0
        ret
sub_B38AE:
        mov eax, dword [dword_D423C]
        sub eax, dword [dword_D4248]
        jge short loc_B38BD
        LD xor, eax, eax
loc_B38BD:
        mul dword [dword_D4278]
        LD mov, al, ah
        LD mov, ah, dl
        sub ax, byte 1Fh
        cwde
        ret
        mov eax, dword [dword_D4240]
        sub eax, dword [dword_D4260]
        jge short loc_B38DC
        LD xor, eax, eax
loc_B38DC:
        mul dword [dword_D427C]
        LD mov, al, ah
        LD mov, ah, dl
        sub ax, byte 1Fh
        cwde
        ret
        mov eax, dword [dword_D41FC]
        sub eax, dword [dword_D4204]
        jge short loc_B38FB
        LD xor, eax, eax
loc_B38FB:
        mul dword [dword_D4234]
        LD mov, al, ah
        LD mov, ah, dl
        sub ax, byte 1Fh
        cwde
        ret
        mov eax, dword [dword_D4200]
        sub eax, dword [dword_D421C]
        jge short loc_B391A
        LD xor, eax, eax
loc_B391A:
        mul dword [dword_D4238]
        LD mov, al, ah
        LD mov, ah, dl
        sub ax, byte 1Fh
        cwde
        ret
        db 00h,00h
ClearScreen:
        mov eax, dword [byte esp+04h]
        push eax
        mov edx, dword [cliprect_y1]
        mov ebx, dword [cliprect_y0]
        LD sub, edx, ebx
        mov eax, dword [cliprect_x1]
        mov ecx, dword [cliprect_x0]
        LD sub, eax, ecx
        push edx
        push eax
        push ebx
        push ecx
        call FillRect
        add sp, byte 14h
        ret
        db 00h,00h
GetTicks:
        mov eax, dword [tickcount]
        ret
TicksSince:
        mov ecx, dword [byte esp+04h]
        mov eax, dword [tickcount]
        LD sub, eax, ecx
        ret
TicksSinceLastCall:
        mov ebx, dword [ticklast]
        mov eax, dword [tickcount]
        mov dword [ticklast], eax
        LD sub, eax, ebx
        ret
ResetTicks:
        LD xor, eax, eax
        mov dword [tickcount], eax
        ret
SetTickDeadline:
        mov eax, dword [byte esp+04h]
        add eax, dword [tickcount]
        mov dword [tickdeadline], eax
        ret
WaitTickDeadline:
        mov eax, dword [tickcount]
        sub eax, dword [tickdeadline]
        js short WaitTickDeadline
        ret
TickDeadlinePassed:
        mov ebx, dword [tickcount]
        sub ebx, dword [tickdeadline]
        LD sbb, eax, eax
        inc eax
        ret
WaitTicks:
        mov eax, dword [byte esp+04h]
        mov ebx, dword [tickcount]
        LD add, eax, ebx
loc_B39C3:
        mov ebx, dword [tickcount]
        LD sub, ebx, eax
        js short loc_B39C3
        ret
        db 00h,00h
KbdGetKey:
        mov ah, 1
        call dword [BiosKeyFunc]
        jne short loc_B39DE
        LD xor, ax, ax
        ret
loc_B39DE:
        LD xor, ah, ah
        call dword [BiosKeyFunc]
        LD or, al, al
        je short loc_B39EC
        LD xor, ah, ah
loc_B39EC:
        ret
PollKey:
        jmp dword [KbdIdleHook]
sub_B39F3:
        mov ah, 1
        call dword [BiosKeyFunc]
        jne short loc_B3A01
        LD xor, ax, ax
        ret
loc_B3A01:
        LD or, al, al
        je short loc_B3A07
        LD xor, ah, ah
loc_B3A07:
        ret
        mov eax, dword [byte esp+04h]
        mov dword [KbdIdleHook], eax
        ret
        mov eax, dword [KbdIdleHook]
        ret
WaitKey:
        call dword [KbdIdleHook]
        LD or, ax, ax
        je short WaitKey
        ret
KbdFlush:
        call KbdGetKey
        LD or, ax, ax
        jne short KbdFlush
        ret
sub_B3A2F:
        call dword [KbdIdleHook]
        LD or, ax, ax
        jne short loc_B3A47
        call TickDeadlinePassed
        LD or, ax, ax
        je short sub_B3A2F
        LD xor, ax, ax
loc_B3A47:
        ret
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFFCh
        call GetTicks
        add eax, dword [byte ebp+08h]
        mov dword [byte ebp-04h], eax
loc_B3A59:
        LD xor, eax, eax
        call PollKey
        LD or, eax, eax
        jne short loc_B3A70
        call GetTicks
        sub eax, dword [byte ebp-04h]
        js short loc_B3A59
        LD xor, eax, eax
loc_B3A70:
        leave
        ret
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        push ds
        push es
        mov ah, 2
        int 16h
        pop es
        pop ds
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
        db 00h
SaveDrawState:
        push ebp
        LD mov, ebp, esp
        push esi
        push edi
        mov esi, ScreenWidth
        mov edi, dword [byte ebp+08h]
        mov ecx, 18h
        cld
        rep movsd
        pop edi
        pop esi
        leave
        ret
RestoreDrawState:
        push ebp
        LD mov, ebp, esp
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov edi, ScreenWidth
        mov ecx, 18h
        cld
        rep movsd
        pop edi
        pop esi
        leave
        ret
        db 00h,00h
bcopy:
        push ebp
        LD mov, ebp, esp
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        mov edi, dword [byte ebp+0Ch]
        mov ecx, dword [byte ebp+010h]
        LD cmp, edi, esi
        jae short loc_B3ADF
        shr ecx, 2
        rep movsd
        mov ecx, dword [byte ebp+010h]
        and ecx, byte 3
        rep movsb
        pop edi
        pop esi
        leave
        ret
loc_B3ADF:
        std
        lea esi, [byte ecx+esi-04h]
        lea edi, [byte ecx+edi-04h]
        shr ecx, 2
        rep movsd
        mov ecx, dword [byte ebp+010h]
        and ecx, byte 3
        lea esi, [byte esi+03h]
        lea edi, [byte edi+03h]
        rep movsb
        cld
        pop edi
        pop esi
        leave
        ret
