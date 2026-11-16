; Reading the joystick.
bits 32
%include "hockey.inc"
section s_B300C progbits alloc exec nowrite align=1
extern __GETDS, atexit_, JoyButtonBits, JoyPortMask, JoyButtons, JoyButtonsPrev, JoyDirection, joyedgedir
extern byte_D4244, byte_D4245, byte_D4246, byte_D4280, cliprect_x0, cliprect_x1, cliprect_y0, cliprect_y1
extern BiosKeyFunc, SavedBreakOffset, BreakCallFunc, ScreenWidth, JoyRawX1, JoyRawY1, JoyRawX2, JoyRawY2
extern JoyAxisY2, JoyAxisMask, JoyX1Threshold, JoyX1Min, JoyX1Center, JoyX1Max, JoyX1Settle, JoyY1Min
extern JoyY1Max, JoyY1Threshold, JoyY1MinSeen, JoyY1Center, JoyY1MaxSeen, JoyY1Settle, JoyX2Min, JoyX2Max
extern JoyXScale, JoyYScale, dword_D41FC, dword_D4200, dword_D4204, dword_D4208, dword_D420C, dword_D4210
extern dword_D4214, dword_D4218, dword_D421C, dword_D4220, dword_D4224, dword_D4228, dword_D422C, dword_D4230
extern dword_D4234, dword_D4238, dword_D423C, dword_D4240, dword_D4248, dword_D424C, dword_D4250, dword_D4254
extern dword_D4258, dword_D425C, dword_D4260, dword_D4264, dword_D4268, dword_D426C, dword_D4270, dword_D4274
extern dword_D4278, dword_D427C, exit_, FatalError, joyenablemask, KbdIdleHook, FillRect, DosGetVector
extern DosSetVector, tickcount, tickdeadline, ticklast, str_LocateshapeSHAPENOTFOUND, SavedBreakSelector, BreakDataSelector
global ReturnZero, ClearNumLock, InstallBreakHandler, RemoveBreakHandler, FindShape, FindShapeQuiet, FindShapeQuiet, CalibrateJoystick
global ReadJoystickPorts, JoyResetCentres, JoyButtonMap, JoyScaledX, AddExitHandler, ExitProgram, ReadJoyRaw, JoyDefaultCalib1
global JoyDefaultCalib2, Joy2ScaledX, ClearScreen, GetTicks, TicksSince, TicksSinceLastCall, ResetTicks, SetTickDeadline
global WaitTickDeadline, TickDeadlinePassed, WaitTicks, KbdGetKey, PollKey, KbdPeekKey, WaitKey, KbdFlush
global KbdIdleWait, SaveDrawState, RestoreDrawState, bcopy
ReturnZero:
        LD xor, eax, eax
        ret
        db 00h
ClearNumLock:
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
        call dword [cs:BreakCallFunc]
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
InstallBreakHandler:
        push ebp
        LD mov, ebp, esp
        mov eax, dword [byte ebp+08h]
        mov dword [BreakCallFunc], eax
        mov ax, cs
        mov word [BreakDataSelector], ax
        cmp word [SavedBreakSelector], byte 0
        jne short .1
        db 0BBh,024h,00h,00h,00h                ; insn: mov ebx,24h
        db 0E8h                                 ; insn: call 0009864Ch
        dd DosGetVector-$-4
        mov dword [SavedBreakOffset], eax
        mov word [SavedBreakSelector], dx
        mov ebx, 24h
        mov dx, cs
        mov eax, ClearNumLock
        call DosSetVector
        push RemoveBreakHandler
        call AddExitHandler
        add esp, byte 4
.1:
        leave
        ret
RemoveBreakHandler:
        pusha
        mov ebx, 24h
        mov dx, word [SavedBreakSelector]
        mov eax, dword [SavedBreakOffset]
        LD or, dx, dx
        je short .1
        call DosSetVector
        mov word [SavedBreakSelector], 0
.1:
        popa
        ret
        db 00h,00h
FindShape:
        mov ebx, str_LocateshapeSHAPENOTFOUND
        jmp short FindShapeQuiet+02h
FindShapeQuiet:
        LD xor, ebx, ebx
        mov edx, dword [byte esp+04h]
        mov eax, dword [byte esp+08h]
        mov eax, dword [eax]
        mov ecx, dword [byte edx+08h]
        add edx, byte 10h
        LD or, ecx, ecx
        jle short .2
.1:
        add edx, byte 8
        cmp eax, dword [byte edx-08h]
        loopne .1
        jne short .2
        mov eax, dword [byte edx-04h]
        add eax, dword [byte esp+04h]
        ret
.2:
        LD or, ebx, ebx
        je short .3
        push dword [byte esp+08h]
        push ebx
        call FatalError
.3:
        LD xor, eax, eax
        ret
CalibrateJoystick:
        push ebp
        push esi
        push edi
        LD xor, eax, eax
        mov ah, byte [JoyPortMask]
        mov ecx, 2710h
        mov edx, 201h
        LD xor, ebx, ebx
        LD mov, ebp, ebx
        LD mov, esi, ebx
        LD mov, edi, ebx
        cli
        out dx, al
        jmp short .2
.1:
        shr al, 1
        adc ebp, byte 0
        shr al, 1
        adc esi, byte 0
        shr al, 1
        adc edi, byte 0
        shr al, 1
        adc ebx, byte 0
.2:
        in al, dx
        test ah, al
        loopne .1
        sti
        jcxz .4
.3:
        shr al, 4
        mov byte [JoyButtonBits], al
        mov dword [JoyRawX1], ebp
        mov dword [JoyRawY1], esi
        mov dword [JoyRawX2], edi
        mov dword [JoyRawY2], ebx
        pop edi
        pop esi
        pop ebp
        ret
.4:
        LD mov, ah, al
        not ah
        and ah, 0Fh
        mov byte [JoyPortMask], ah
        jmp short .3
        db 00h,00h,00h
ReadJoystickPorts:
        mov byte [JoyDirection], 0
        test byte [joyenablemask], 1
        je near .26
        mov dx, 201h
        in al, dx
        and al, 30h
        mov byte [JoyButtonsPrev], al
        mov bl, 3
        mov dword [JoyAxisY2], 50h
        mov dword [JoyAxisMask], 50h
        cli
        out dx, al
        mov ecx, 14h
.1:
        loop .1
        LD xor, ecx, ecx
.2:
        in al, dx
        LD and, al, bl
        LD xor, al, bl
        jne short .3
        inc ecx
        cmp ecx, 0FA0h
        jl short .2
        jmp short .6
.3:
        test al, 1
        jne short .5
.4:
        test al, 2
        je short .2
        mov dword [JoyAxisMask], ecx
        and bl, 1
        jne short .2
        jmp short .6
.5:
        mov dword [JoyAxisY2], ecx
        and bl, 2
        jne short .4
.6:
        sti
        mov eax, dword [JoyAxisY2]
        cmp eax, dword [JoyX1Threshold]
        jge short .10
        dec dword [JoyX1Settle]
        jle short .7
        cmp eax, dword [JoyX1Min]
        jl near .13
        mov dword [JoyX1Min], eax
        jmp near .13
.7:
        mov ebx, dword [JoyX1Min]
        mov dword [JoyX1Threshold], ebx
        mov ebx, dword [JoyX1Center]
.8:
        sub ebx, dword [JoyX1Threshold]
        jle short .9
        LD xor, edx, edx
        mov eax, 4000h
        div ebx
        mov dword [JoyXScale], eax
.9:
        LD mov, eax, ebx
        mov dx, 201h
        shr eax, 1
        LD mov, ebx, eax
        shr ebx, 1
        add eax, dword [JoyX1Threshold]
        LD add, eax, ebx
        mov dword [JoyY1Max], eax
        LD sub, eax, ebx
        LD sub, eax, ebx
        mov dword [JoyY1Min], eax
        mov eax, dword [JoyAxisY2]
        jmp short .12
.10:
        cmp eax, dword [JoyX1Center]
        jle short .12
        dec dword [JoyX1Settle]
        jle short .11
        cmp eax, dword [JoyX1Max]
        jge short .13
        mov dword [JoyX1Max], eax
        jmp short .13
.11:
        mov ebx, dword [JoyX1Max]
        mov dword [JoyX1Center], ebx
        jmp short .8
.12:
        mov dword [JoyX1Settle], 14h
        mov dword [JoyX1Max], 4E20h
        mov dword [JoyX1Min], 0
.13:
        cmp eax, dword [JoyY1Min]
        jl near .18
        cmp eax, dword [JoyY1Max]
        jl short .14
        or byte [JoyDirection], 4
.14:
        mov eax, dword [JoyAxisMask]
        cmp eax, dword [JoyY1Threshold]
        jae short .19
        dec dword [JoyY1Settle]
        jle short .15
        cmp eax, dword [JoyY1MinSeen]
        jl near .22
        mov dword [JoyY1MinSeen], eax
        jmp near .22
.15:
        mov ebx, dword [JoyY1MinSeen]
        mov dword [JoyY1Threshold], ebx
        mov ebx, dword [JoyY1Center]
.16:
        sub ebx, dword [JoyY1Threshold]
        jle short .17
        LD xor, edx, edx
        mov eax, 4000h
        div ebx
        mov dword [JoyYScale], eax
.17:
        LD mov, eax, ebx
        mov dx, 201h
        shr eax, 1
        LD mov, ebx, eax
        shr ebx, 1
        add eax, dword [JoyY1Threshold]
        LD add, eax, ebx
        mov dword [JoyX2Max], eax
        LD sub, eax, ebx
        LD sub, eax, ebx
        mov dword [JoyX2Min], eax
        mov eax, dword [JoyAxisMask]
        jmp short .21
.18:
        or byte [JoyDirection], 8
        jmp near .14
.19:
        cmp eax, dword [JoyY1Center]
        jle short .21
        dec dword [JoyY1Settle]
        je short .20
        cmp eax, dword [JoyY1MaxSeen]
        jge short .22
        mov dword [JoyY1MaxSeen], eax
        jmp short .22
.20:
        mov ebx, dword [JoyY1MaxSeen]
        mov dword [JoyY1Center], ebx
        jmp short .16
.21:
        mov dword [JoyY1Settle], 14h
        mov dword [JoyY1MaxSeen], 4E20h
        mov dword [JoyY1MinSeen], 0
.22:
        cmp eax, dword [JoyX2Min]
        jb short .27
        cmp eax, dword [JoyX2Max]
        jb short .23
        or byte [JoyDirection], 2
.23:
        in al, dx
        and al, 30h
        cmp al, byte [JoyButtonsPrev]
        je short .24
        mov al, byte [JoyButtons]
        jmp short .25
.24:
        xor al, 30h
        mov byte [JoyButtons], al
.25:
        or byte [JoyDirection], al
.26:
        mov al, byte [JoyDirection]
        LD xor, ah, ah
        movzx eax, ax
        ret
.27:
        or byte [JoyDirection], 1
        jmp short .23
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
JoyScaledX:
        mov eax, dword [JoyAxisY2]
        sub eax, dword [JoyX1Threshold]
        jge short .1
        LD xor, eax, eax
.1:
        mul dword [JoyXScale]
        sub eax, byte 1Fh
        ret
        mov eax, dword [JoyAxisMask]
        sub eax, dword [JoyY1Threshold]
        jge short .2
        LD xor, eax, eax
.2:
        mul dword [JoyYScale]
        sub eax, byte 1Fh
        ret
        db 00h
AddExitHandler:
        mov eax, dword [byte esp+04h]
        jmp near atexit_
ExitProgram:
        LD xor, eax, eax
        call exit_
ReadJoyRaw:
        mov bl, byte [joyenablemask]
        LD or, bl, bl
        jne short .1
        LD xor, eax, eax
        ret
.1:
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
.2:
        loop .2
        LD xor, ecx, ecx
.3:
        in al, dx
        LD and, al, bl
        LD xor, al, bl
        jne short .4
        inc ecx
        cmp ecx, 0FA0h
        jl short .3
        jmp short .11
.4:
        test al, 1
        jne short .8
.5:
        test al, 2
        jne short .9
.6:
        test al, 4
        jne short .10
.7:
        test al, 8
        je short .3
        mov dword [dword_D4200], ecx
        and bl, 7
        jne short .3
        jmp short .11
.8:
        mov dword [dword_D423C], ecx
        and bl, 0Eh
        jne short .5
        jmp short .11
.9:
        mov dword [dword_D4240], ecx
        and bl, 0Dh
        jne short .6
        jmp short .11
.10:
        mov dword [dword_D41FC], ecx
        and bl, 0Bh
        jne short .7
.11:
        sti
        test byte [joyenablemask], 1
        jne short .12
        jmp near .29
.12:
        mov ebx, dword [dword_D423C]
        cmp ebx, dword [dword_D4248]
        jge short .15
        mov dword [dword_D4248], ebx
        mov ebx, dword [dword_D424C]
.13:
        sub ebx, dword [dword_D4248]
        jle short .14
        LD xor, edx, edx
        mov eax, 4000h
        div ebx
        mov dword [dword_D4278], eax
.14:
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
        jmp short .17
.15:
        cmp ebx, dword [dword_D424C]
        jle short .17
        dec dword [dword_D4254]
        je short .16
        cmp ebx, dword [dword_D4250]
        jge short .18
        mov dword [dword_D4250], ebx
        jmp short .18
.16:
        mov ebx, dword [dword_D4250]
        mov dword [dword_D424C], ebx
        jmp short .13
.17:
        mov dword [dword_D4254], 8
        mov dword [dword_D4250], 4E20h
.18:
        cmp ebx, dword [dword_D4258]
        jl short .22
        cmp ebx, dword [dword_D425C]
        jl short .19
        or byte [byte_D4245], 4
.19:
        mov ebx, dword [dword_D4240]
        cmp ebx, dword [dword_D4260]
        jae short .23
        mov dword [dword_D4260], ebx
        mov ebx, dword [dword_D4264]
.20:
        sub ebx, dword [dword_D4260]
        jle short .21
        LD xor, edx, edx
        mov eax, 4000h
        div ebx
        mov dword [dword_D427C], eax
.21:
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
        jmp short .25
.22:
        or byte [byte_D4245], 8
        jmp short .19
.23:
        cmp ebx, dword [dword_D4264]
        jle short .25
        dec dword [dword_D426C]
        je short .24
        cmp ebx, dword [dword_D4268]
        jge short .26
        mov dword [dword_D4268], ebx
        jmp short .26
.24:
        mov ebx, dword [dword_D4268]
        mov dword [dword_D4264], ebx
        jmp short .20
.25:
        mov dword [dword_D426C], 8
        mov dword [dword_D4268], 4E20h
.26:
        cmp ebx, dword [dword_D4270]
        jb short .28
        cmp ebx, dword [dword_D4274]
        jb short .27
        or byte [byte_D4245], 2
.27:
        in al, dx
        and al, byte [byte_D4244]
        and al, 30h
        xor al, 30h
        or byte [byte_D4245], al
        jmp short .29
.28:
        or byte [byte_D4245], 1
        jmp short .27
.29:
        test byte [joyenablemask], 2
        jne short .30
        jmp near .46
.30:
        mov ebx, dword [dword_D41FC]
        cmp ebx, dword [dword_D4204]
        jge short .33
        mov dword [dword_D4204], ebx
        mov ebx, dword [dword_D4208]
.31:
        sub ebx, dword [dword_D4204]
        jle short .32
        LD xor, edx, edx
        mov eax, 4000h
        div ebx
        mov dword [dword_D4234], eax
.32:
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
        jmp short .35
.33:
        cmp ebx, dword [dword_D4208]
        jle short .35
        dec dword [dword_D4210]
        je short .34
        cmp ebx, dword [dword_D420C]
        jge short .36
        mov dword [dword_D420C], ebx
        jmp short .36
.34:
        mov ebx, dword [dword_D420C]
        mov dword [dword_D4208], ebx
        jmp short .31
.35:
        mov dword [dword_D4210], 8
        mov dword [dword_D420C], 4E20h
.36:
        cmp ebx, dword [dword_D4214]
        jl short .40
        cmp ebx, dword [dword_D4218]
        jl short .37
        or byte [byte_D4246], 4
.37:
        mov ebx, dword [dword_D4200]
        cmp ebx, dword [dword_D421C]
        jae short .41
        mov dword [dword_D421C], ebx
        mov ebx, dword [dword_D4220]
.38:
        sub ebx, dword [dword_D421C]
        jle short .39
        LD xor, edx, edx
        mov eax, 4000h
        div ebx
        mov dword [dword_D4238], eax
.39:
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
        jmp short .43
.40:
        or byte [byte_D4246], 8
        jmp short .37
.41:
        cmp ebx, dword [dword_D4220]
        jle short .43
        dec dword [dword_D4228]
        je short .42
        cmp ebx, dword [dword_D4224]
        jge short .44
        mov dword [dword_D4224], ebx
        jmp short .44
.42:
        mov ebx, dword [dword_D4224]
        mov dword [dword_D4220], ebx
        jmp short .38
.43:
        mov dword [dword_D4228], 8
        mov dword [dword_D4224], 4E20h
.44:
        cmp ebx, dword [dword_D422C]
        jb short .47
        cmp ebx, dword [dword_D4230]
        jb short .45
        or byte [byte_D4246], 2
.45:
        in al, dx
        and al, byte [byte_D4244]
        and al, 0C0h
        xor al, 0C0h
        shr al, 2
        or byte [byte_D4246], al
.46:
        mov al, byte [byte_D4245]
        mov ah, byte [byte_D4246]
        cwde
        ret
.47:
        or byte [byte_D4246], 1
        jmp short .45
JoyDefaultCalib1:
        or byte [joyenablemask], 1
        mov dword [dword_D4248], 50h
        mov dword [dword_D424C], 0
        mov dword [dword_D4260], 50h
        mov dword [dword_D4264], 0
        ret
JoyDefaultCalib2:
        or byte [joyenablemask], 2
        mov dword [dword_D4204], 50h
        mov dword [dword_D4208], 0
        mov dword [dword_D421C], 50h
        mov dword [dword_D4220], 0
        ret
Joy2ScaledX:
        mov eax, dword [dword_D423C]
        sub eax, dword [dword_D4248]
        jge short .1
        LD xor, eax, eax
.1:
        mul dword [dword_D4278]
        LD mov, al, ah
        LD mov, ah, dl
        sub ax, byte 1Fh
        cwde
        ret
        mov eax, dword [dword_D4240]
        sub eax, dword [dword_D4260]
        jge short .2
        LD xor, eax, eax
.2:
        mul dword [dword_D427C]
        LD mov, al, ah
        LD mov, ah, dl
        sub ax, byte 1Fh
        cwde
        ret
        mov eax, dword [dword_D41FC]
        sub eax, dword [dword_D4204]
        jge short .3
        LD xor, eax, eax
.3:
        mul dword [dword_D4234]
        LD mov, al, ah
        LD mov, ah, dl
        sub ax, byte 1Fh
        cwde
        ret
        mov eax, dword [dword_D4200]
        sub eax, dword [dword_D421C]
        jge short .4
        LD xor, eax, eax
.4:
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
.1:
        mov ebx, dword [tickcount]
        LD sub, ebx, eax
        js short .1
        ret
        db 00h,00h
KbdGetKey:
        mov ah, 1
        call dword [BiosKeyFunc]
        jne short .1
        LD xor, ax, ax
        ret
.1:
        LD xor, ah, ah
        call dword [BiosKeyFunc]
        LD or, al, al
        je short .2
        LD xor, ah, ah
.2:
        ret
PollKey:
        jmp dword [KbdIdleHook]
KbdPeekKey:
        mov ah, 1
        call dword [BiosKeyFunc]
        jne short .1
        LD xor, ax, ax
        ret
.1:
        LD or, al, al
        je short .2
        LD xor, ah, ah
.2:
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
KbdIdleWait:
        call dword [KbdIdleHook]
        LD or, ax, ax
        jne short .1
        call TickDeadlinePassed
        LD or, ax, ax
        je short KbdIdleWait
        LD xor, ax, ax
.1:
        ret
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFFCh
        call GetTicks
        add eax, dword [byte ebp+08h]
        mov dword [byte ebp-04h], eax
.2:
        LD xor, eax, eax
        call PollKey
        LD or, eax, eax
        jne short .3
        call GetTicks
        sub eax, dword [byte ebp-04h]
        js short .2
        LD xor, eax, eax
.3:
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
        jae short .1
        shr ecx, 2
        rep movsd
        mov ecx, dword [byte ebp+010h]
        and ecx, byte 3
        rep movsb
        pop edi
        pop esi
        leave
        ret
.1:
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
