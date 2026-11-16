; Reading the joystick.
bits 32
%include "hockey.inc"
section s_B300C progbits alloc exec nowrite align=1
extern __GETDS, atexit_, JoyButtonBits, JoyPortMask, JoyButtons, JoyButtonsPrev, JoyDirection, joyedgedir
extern JoyRawButtons, Joy1RawDirection, Joy2RawDirection, JoyDirLookup, cliprect_x0, cliprect_x1, cliprect_y0, cliprect_y1
extern BiosKeyFunc, SavedBreakOffset, BreakCallFunc, ScreenWidth, JoyRawX1, JoyRawY1, JoyRawX2, JoyRawY2
extern JoyAxisY2, JoyAxisMask, JoyX1Threshold, JoyX1Min, JoyX1Center, JoyX1Max, JoyX1Settle, JoyY1Min
extern JoyY1Max, JoyY1Threshold, JoyY1MinSeen, JoyY1Center, JoyY1MaxSeen, JoyY1Settle, JoyX2Min, JoyX2Max
extern JoyXScale, JoyYScale, Joy2RawX, Joy2RawY, Joy2XMin, Joy2XMax, Joy2XCenter, Joy2XSettle
extern Joy2XMinSeen, Joy2XMaxSeen, Joy2YMin, Joy2YMax, Joy2YCenter, Joy2YSettle, Joy2YMinSeen, Joy2YMaxSeen
extern Joy2XScale, Joy2YScale, Joy1RawX, Joy1RawY, Joy1XMin, Joy1XMax, Joy1XCenter, Joy1XSettle
extern Joy1XMinSeen, Joy1XMaxSeen, Joy1YMin, Joy1YMax, Joy1YCenter, Joy1YSettle, Joy1YMinSeen, Joy1YMaxSeen
extern Joy1XScale, Joy1YScale, exit_, FatalError, joyenablemask, KbdIdleHook, FillRect, DosGetVector
extern DosSetVector, tickcount, tickdeadline, ticklast, str_LocateshapeSHAPENOTFOUND, SavedBreakSelector, BreakDataSelector
global ReturnZero, ClearNumLock, InstallBreakHandler, RemoveBreakHandler, FindShape, FindShapeQuiet, FindShapeQuiet, CalibrateJoystick
global ReadJoystickPorts, JoyResetCentres, JoyButtonMap, JoyScaledX, AddExitHandler, ExitProgram, ReadJoyRaw, JoyDefaultCalib1
global JoyDefaultCalib2, Joy2ScaledX, ClearScreen, GetTicks, TicksSince, TicksSinceLastCall, ResetTicks, SetTickDeadline
global WaitTickDeadline, TickDeadlinePassed, WaitTicks, KbdGetKey, PollKey, KbdPeekKey, WaitKey, KbdFlush
global KbdIdleWait, SaveDrawState, RestoreDrawState, bcopy
;-----------------------------------------------------------------------------
; ReturnZero                                   B300C  95 PC, medium confidence
; Returns 0; default for the joystick and mouse hooks
;-----------------------------------------------------------------------------
ReturnZero:
        LD xor, eax, eax
        ret
        db 00h
;-----------------------------------------------------------------------------
; ClearNumLock                                 B3010  95 PC, medium confidence
; Clears the BIOS Num Lock flag; followed by the real-mode Ctrl-Break stub
; that calls the installed handler
;-----------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------
; InstallBreakHandler                          B3036  95 PC, medium confidence
; Hooks the critical-error vector and registers its removal at exit
;-----------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------
; RemoveBreakHandler                                              B308B  95 PC
; Frees the DOS memory of the Ctrl-Break callback and clears its selector
;-----------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------
; FindShape                                    B30B4  95 PC, medium confidence
; Graphics library: find the named art in a bank (bank, name), returns its
; pointer; 243 calls
;-----------------------------------------------------------------------------
FindShape:
        mov ebx, str_LocateshapeSHAPENOTFOUND
        jmp short FindShapeQuiet+02h
;-----------------------------------------------------------------------------
; FindShapeQuiet                               B30BB  95 PC, medium confidence
; Finds a shape by id in a shape bank (bank, &id); returns 0 when it is
; missing
;-----------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------
; CalibrateJoystick                               B30F4  95 PC, low confidence
; Times the four joystick axes on port 201h and keeps the button bits
;-----------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------
; ReadJoystickPorts                            B3168  95 PC, medium confidence
; Reads the joystick buttons and axes by timing the port
;-----------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------
; JoyResetCentres                              B33DB  95 PC, medium confidence
; Resets the joystick centres and enables the first joystick
;-----------------------------------------------------------------------------
JoyResetCentres:
        mov byte [joyenablemask], 1
        mov dword [JoyX1Threshold], 50h
        mov dword [JoyX1Center], 0
        mov dword [JoyY1Threshold], 50h
        mov dword [JoyY1Center], 0
        ret
;-----------------------------------------------------------------------------
; JoyButtonMap                                 B340B  95 PC, medium confidence
; Maps joystick button bits to pad buttons through a table
;-----------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------
; JoyScaledX                                      B3421  95 PC, low confidence
; Joystick 1 X scaled to -31..+31
;-----------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------
; AddExitHandler                               B3454  95 PC, medium confidence
; Registers an exit handler
;-----------------------------------------------------------------------------
AddExitHandler:
        mov eax, dword [byte esp+04h]
        jmp near atexit_
;-----------------------------------------------------------------------------
; ExitProgram                                  B345D  95 PC, medium confidence
; Exits with code 0
;-----------------------------------------------------------------------------
ExitProgram:
        LD xor, eax, eax
        call exit_
;-----------------------------------------------------------------------------
; ReadJoyRaw                                   B3464  95 PC, medium confidence
; Joystick library: read the raw joystick bits (joyrawbits)
;-----------------------------------------------------------------------------
ReadJoyRaw:
        mov bl, byte [joyenablemask]
        LD or, bl, bl
        jne short .1
        LD xor, eax, eax
        ret
.1:
        mov byte [Joy1RawDirection], 0
        mov byte [Joy2RawDirection], 0
        mov dx, 201h
        in al, dx
        mov byte [JoyRawButtons], al
        LD xor, bh, bh
        mov bl, byte [dword ebx+JoyDirLookup]
        mov ax, 50h
        cwde
        mov dword [Joy1RawX], eax
        mov dword [Joy1RawY], eax
        mov dword [Joy2RawX], eax
        mov dword [Joy2RawY], eax
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
        mov dword [Joy2RawY], ecx
        and bl, 7
        jne short .3
        jmp short .11
.8:
        mov dword [Joy1RawX], ecx
        and bl, 0Eh
        jne short .5
        jmp short .11
.9:
        mov dword [Joy1RawY], ecx
        and bl, 0Dh
        jne short .6
        jmp short .11
.10:
        mov dword [Joy2RawX], ecx
        and bl, 0Bh
        jne short .7
.11:
        sti
        test byte [joyenablemask], 1
        jne short .12
        jmp near .29
.12:
        mov ebx, dword [Joy1RawX]
        cmp ebx, dword [Joy1XMin]
        jge short .15
        mov dword [Joy1XMin], ebx
        mov ebx, dword [Joy1XMax]
.13:
        sub ebx, dword [Joy1XMin]
        jle short .14
        LD xor, edx, edx
        mov eax, 4000h
        div ebx
        mov dword [Joy1XScale], eax
.14:
        LD mov, eax, ebx
        mov edx, 201h
        shr eax, 1
        LD mov, ebx, eax
        shr ebx, 1
        add eax, dword [Joy1XMin]
        LD add, eax, ebx
        mov dword [Joy1XMaxSeen], eax
        LD sub, eax, ebx
        LD sub, eax, ebx
        mov dword [Joy1XMinSeen], eax
        mov ebx, dword [Joy1RawX]
        jmp short .17
.15:
        cmp ebx, dword [Joy1XMax]
        jle short .17
        dec dword [Joy1XSettle]
        je short .16
        cmp ebx, dword [Joy1XCenter]
        jge short .18
        mov dword [Joy1XCenter], ebx
        jmp short .18
.16:
        mov ebx, dword [Joy1XCenter]
        mov dword [Joy1XMax], ebx
        jmp short .13
.17:
        mov dword [Joy1XSettle], 8
        mov dword [Joy1XCenter], 4E20h
.18:
        cmp ebx, dword [Joy1XMinSeen]
        jl short .22
        cmp ebx, dword [Joy1XMaxSeen]
        jl short .19
        or byte [Joy1RawDirection], 4
.19:
        mov ebx, dword [Joy1RawY]
        cmp ebx, dword [Joy1YMin]
        jae short .23
        mov dword [Joy1YMin], ebx
        mov ebx, dword [Joy1YMax]
.20:
        sub ebx, dword [Joy1YMin]
        jle short .21
        LD xor, edx, edx
        mov eax, 4000h
        div ebx
        mov dword [Joy1YScale], eax
.21:
        LD mov, eax, ebx
        mov edx, 201h
        shr eax, 1
        LD mov, ebx, eax
        shr ebx, 1
        add eax, dword [Joy1YMin]
        LD add, eax, ebx
        mov dword [Joy1YMaxSeen], eax
        LD sub, eax, ebx
        LD sub, eax, ebx
        mov dword [Joy1YMinSeen], eax
        mov ebx, dword [Joy1RawY]
        jmp short .25
.22:
        or byte [Joy1RawDirection], 8
        jmp short .19
.23:
        cmp ebx, dword [Joy1YMax]
        jle short .25
        dec dword [Joy1YSettle]
        je short .24
        cmp ebx, dword [Joy1YCenter]
        jge short .26
        mov dword [Joy1YCenter], ebx
        jmp short .26
.24:
        mov ebx, dword [Joy1YCenter]
        mov dword [Joy1YMax], ebx
        jmp short .20
.25:
        mov dword [Joy1YSettle], 8
        mov dword [Joy1YCenter], 4E20h
.26:
        cmp ebx, dword [Joy1YMinSeen]
        jb short .28
        cmp ebx, dword [Joy1YMaxSeen]
        jb short .27
        or byte [Joy1RawDirection], 2
.27:
        in al, dx
        and al, byte [JoyRawButtons]
        and al, 30h
        xor al, 30h
        or byte [Joy1RawDirection], al
        jmp short .29
.28:
        or byte [Joy1RawDirection], 1
        jmp short .27
.29:
        test byte [joyenablemask], 2
        jne short .30
        jmp near .46
.30:
        mov ebx, dword [Joy2RawX]
        cmp ebx, dword [Joy2XMin]
        jge short .33
        mov dword [Joy2XMin], ebx
        mov ebx, dword [Joy2XMax]
.31:
        sub ebx, dword [Joy2XMin]
        jle short .32
        LD xor, edx, edx
        mov eax, 4000h
        div ebx
        mov dword [Joy2XScale], eax
.32:
        LD mov, eax, ebx
        mov edx, 201h
        shr eax, 1
        LD mov, ebx, eax
        shr ebx, 1
        add eax, dword [Joy2XMin]
        LD add, eax, ebx
        mov dword [Joy2XMaxSeen], eax
        LD sub, eax, ebx
        LD sub, eax, ebx
        mov dword [Joy2XMinSeen], eax
        mov ebx, dword [Joy2RawX]
        jmp short .35
.33:
        cmp ebx, dword [Joy2XMax]
        jle short .35
        dec dword [Joy2XSettle]
        je short .34
        cmp ebx, dword [Joy2XCenter]
        jge short .36
        mov dword [Joy2XCenter], ebx
        jmp short .36
.34:
        mov ebx, dword [Joy2XCenter]
        mov dword [Joy2XMax], ebx
        jmp short .31
.35:
        mov dword [Joy2XSettle], 8
        mov dword [Joy2XCenter], 4E20h
.36:
        cmp ebx, dword [Joy2XMinSeen]
        jl short .40
        cmp ebx, dword [Joy2XMaxSeen]
        jl short .37
        or byte [Joy2RawDirection], 4
.37:
        mov ebx, dword [Joy2RawY]
        cmp ebx, dword [Joy2YMin]
        jae short .41
        mov dword [Joy2YMin], ebx
        mov ebx, dword [Joy2YMax]
.38:
        sub ebx, dword [Joy2YMin]
        jle short .39
        LD xor, edx, edx
        mov eax, 4000h
        div ebx
        mov dword [Joy2YScale], eax
.39:
        LD mov, eax, ebx
        mov edx, 201h
        shr eax, 1
        LD mov, ebx, eax
        shr ebx, 1
        add eax, dword [Joy2YMin]
        LD add, eax, ebx
        mov dword [Joy2YMaxSeen], eax
        LD sub, eax, ebx
        LD sub, eax, ebx
        mov dword [Joy2YMinSeen], eax
        mov ebx, dword [Joy2RawY]
        jmp short .43
.40:
        or byte [Joy2RawDirection], 8
        jmp short .37
.41:
        cmp ebx, dword [Joy2YMax]
        jle short .43
        dec dword [Joy2YSettle]
        je short .42
        cmp ebx, dword [Joy2YCenter]
        jge short .44
        mov dword [Joy2YCenter], ebx
        jmp short .44
.42:
        mov ebx, dword [Joy2YCenter]
        mov dword [Joy2YMax], ebx
        jmp short .38
.43:
        mov dword [Joy2YSettle], 8
        mov dword [Joy2YCenter], 4E20h
.44:
        cmp ebx, dword [Joy2YMinSeen]
        jb short .47
        cmp ebx, dword [Joy2YMaxSeen]
        jb short .45
        or byte [Joy2RawDirection], 2
.45:
        in al, dx
        and al, byte [JoyRawButtons]
        and al, 0C0h
        xor al, 0C0h
        shr al, 2
        or byte [Joy2RawDirection], al
.46:
        mov al, byte [Joy1RawDirection]
        mov ah, byte [Joy2RawDirection]
        cwde
        ret
.47:
        or byte [Joy2RawDirection], 1
        jmp short .45
;-----------------------------------------------------------------------------
; JoyDefaultCalib1                                B384E  95 PC, low confidence
; Enables joystick 1 with the default calibration
;-----------------------------------------------------------------------------
JoyDefaultCalib1:
        or byte [joyenablemask], 1
        mov dword [Joy1XMin], 50h
        mov dword [Joy1XMax], 0
        mov dword [Joy1YMin], 50h
        mov dword [Joy1YMax], 0
        ret
;-----------------------------------------------------------------------------
; JoyDefaultCalib2                                B387E  95 PC, low confidence
; Enables joystick 2 with the default calibration
;-----------------------------------------------------------------------------
JoyDefaultCalib2:
        or byte [joyenablemask], 2
        mov dword [Joy2XMin], 50h
        mov dword [Joy2XMax], 0
        mov dword [Joy2YMin], 50h
        mov dword [Joy2YMax], 0
        ret
;-----------------------------------------------------------------------------
; Joy2ScaledX                                     B38AE  95 PC, low confidence
; Second joystick X scaled to -31..+31
;-----------------------------------------------------------------------------
Joy2ScaledX:
        mov eax, dword [Joy1RawX]
        sub eax, dword [Joy1XMin]
        jge short .1
        LD xor, eax, eax
.1:
        mul dword [Joy1XScale]
        LD mov, al, ah
        LD mov, ah, dl
        sub ax, byte 1Fh
        cwde
        ret
        mov eax, dword [Joy1RawY]
        sub eax, dword [Joy1YMin]
        jge short .2
        LD xor, eax, eax
.2:
        mul dword [Joy1YScale]
        LD mov, al, ah
        LD mov, ah, dl
        sub ax, byte 1Fh
        cwde
        ret
        mov eax, dword [Joy2RawX]
        sub eax, dword [Joy2XMin]
        jge short .3
        LD xor, eax, eax
.3:
        mul dword [Joy2XScale]
        LD mov, al, ah
        LD mov, ah, dl
        sub ax, byte 1Fh
        cwde
        ret
        mov eax, dword [Joy2RawY]
        sub eax, dword [Joy2YMin]
        jge short .4
        LD xor, eax, eax
.4:
        mul dword [Joy2YScale]
        LD mov, al, ah
        LD mov, ah, dl
        sub ax, byte 1Fh
        cwde
        ret
        db 00h,00h
;-----------------------------------------------------------------------------
; ClearScreen                                  B392C  95 PC, medium confidence
; Graphics library: clear the screen to a colour
;-----------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------
; GetTicks                                                        B395C  95 PC
; Returns tickcount (the 100 Hz TimerISR count)
;-----------------------------------------------------------------------------
GetTicks:
        mov eax, dword [tickcount]
        ret
;-----------------------------------------------------------------------------
; TicksSince                                                      B3962  95 PC
; Cdecl: returns tickcount minus the stack argument
;-----------------------------------------------------------------------------
TicksSince:
        mov ecx, dword [byte esp+04h]
        mov eax, dword [tickcount]
        LD sub, eax, ecx
        ret
;-----------------------------------------------------------------------------
; TicksSinceLastCall                                              B396E  95 PC
; Returns tickcount - ticklast and stores tickcount in ticklast
; (frontend_desk, gamesave_io GameLoop)
;-----------------------------------------------------------------------------
TicksSinceLastCall:
        mov ebx, dword [ticklast]
        mov eax, dword [tickcount]
        mov dword [ticklast], eax
        LD sub, eax, ebx
        ret
;-----------------------------------------------------------------------------
; ResetTicks                                                      B3981  95 PC
; Tickcount = 0; no caller in the EXE
;-----------------------------------------------------------------------------
ResetTicks:
        LD xor, eax, eax
        mov dword [tickcount], eax
        ret
;-----------------------------------------------------------------------------
; SetTickDeadline                                                 B3989  95 PC
; Cdecl: tickdeadline = tickcount + the stack argument; paired with
; WaitTickDeadline (CrowdFadeOut, FadeOutPalCycle, ShowLoadingScreen,
;
; SetScreenSize)
;-----------------------------------------------------------------------------
SetTickDeadline:
        mov eax, dword [byte esp+04h]
        add eax, dword [tickcount]
        mov dword [tickdeadline], eax
        ret
;-----------------------------------------------------------------------------
; WaitTickDeadline                                                B3999  95 PC
; Busy-waits while tickcount - tickdeadline is negative
;-----------------------------------------------------------------------------
WaitTickDeadline:
        mov eax, dword [tickcount]
        sub eax, dword [tickdeadline]
        js short WaitTickDeadline
        ret
;-----------------------------------------------------------------------------
; TickDeadlinePassed                                              B39A7  95 PC
; Returns 1 when tickcount >= tickdeadline (unsigned sub / sbb / inc), else 0
;-----------------------------------------------------------------------------
TickDeadlinePassed:
        mov ebx, dword [tickcount]
        sub ebx, dword [tickdeadline]
        LD sbb, eax, eax
        inc eax
        ret
;-----------------------------------------------------------------------------
; WaitTicks                                                       B39B7  95 PC
; Cdecl: busy-waits until tickcount reaches tickcount-at-entry + the stack
; argument; no caller in the EXE
;-----------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------
; KbdGetKey                                    B39D0  95 PC, medium confidence
; Reads a key from the keyboard, or 0 when none is waiting
;-----------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------
; PollKey                                      B39ED  95 PC, medium confidence
; Jmp through the keyboard read vector KbdIdleHook (returns 0 when no key);
; DebugMonitor's non-stepping key read
;-----------------------------------------------------------------------------
PollKey:
        jmp dword [KbdIdleHook]
;-----------------------------------------------------------------------------
; KbdPeekKey                                                      B39F3  95 PC
; Returns the next key without removing it, or 0
;-----------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------
; WaitKey                                      B3A18  95 PC, medium confidence
; Loops calling the keyboard read vector KbdIdleHook until it returns
; non-zero; DebugMonitor uses it in single-step mode
;-----------------------------------------------------------------------------
WaitKey:
        call dword [KbdIdleHook]
        LD or, ax, ax
        je short WaitKey
        ret
;-----------------------------------------------------------------------------
; KbdFlush                                     B3A24  95 PC, medium confidence
; Reads keys until none are left; followed by the timed wait for a key
;-----------------------------------------------------------------------------
KbdFlush:
        call KbdGetKey
        LD or, ax, ax
        jne short KbdFlush
        ret
;-----------------------------------------------------------------------------
; KbdIdleWait                                     B3A2F  95 PC, low confidence
; Calls the keyboard idle hook until it returns a key or the tick deadline
; passes
;-----------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------
; SaveDrawState                                B3A88  95 PC, medium confidence
; Copies the drawing state (screen sizes, clip rectangle, target) into a
; buffer
;-----------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------
; RestoreDrawState                             B3AA1  95 PC, medium confidence
; Copies a saved drawing state back
;-----------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------
; bcopy                                        B3ABC  95 PC, medium confidence
; (src, dst, n): copies n bytes, backwards when they overlap (BSD order)
;-----------------------------------------------------------------------------
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
