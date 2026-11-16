; Reading the mouse.
bits 32
%include "hockey.inc"
section s_B2D38 progbits alloc exec nowrite align=1
extern mouseminx, mouseminy, mousemaxx, mousemaxy, MouseDeltaX, MouseButtonState, MouseForceTwoButtons, MousePresent
extern PointerCount, MouseButtons, ViewScreenWidth, ViewScreenHeight, mousebtns, mousepollfn, mousex, mousey
extern HidePointerKeepHook, HidePointerHook, ShowPointerHook, AddExitHandler, MouseSavedSensX, MouseSavedSensY, MouseSavedThreshold
global MouseReadButtons, MouseSetSensitivity, MouseSetSensitivityDefault, MouseSetPos, MouseRead, MouseSetXRange, SetViewRect, MouseReadMotion
global PointerCountUp, PointerCountDown, MouseRestoreSensitivity, InitMouse
;-----------------------------------------------------------------------------
; MouseReadButtons                             B2D38  95 PC, medium confidence
; Reads the mouse buttons through the mouse driver
;-----------------------------------------------------------------------------
MouseReadButtons:
        LD xor, eax, eax
        dec dword [MouseButtonState]
        jne short .1
        cmp dword [MousePresent], byte 1
        jb short .1
        ja short .2
        mov eax, 3
        int 33h
        movsx eax, bx
.1:
        inc dword [MouseButtonState]
        ret
.2:
        mov eax, 3
        int 33h
        and eax, byte 1
        and ebx, byte 2
        LD or, eax, ebx
        inc dword [MouseButtonState]
        ret
;-----------------------------------------------------------------------------
; MouseSetSensitivity                          B2D74  95 PC, medium confidence
; Sets the mouse sensitivity (int 33h, 1Ah) when a mouse is present
;-----------------------------------------------------------------------------
MouseSetSensitivity:
        push ebp
        LD mov, ebp, esp
        cmp dword [MousePresent], byte 0
        je short .1
        mov ax, 1Ah
        mov bx, word [byte ebp+08h]
        mov cx, word [byte ebp+0Ch]
        mov dx, word [byte ebp+010h]
        int 33h
.1:
        leave
        ret
;-----------------------------------------------------------------------------
; MouseSetSensitivityDefault                   B2D94  95 PC, medium confidence
; Sets mouse sensitivity with the default double-speed threshold
;-----------------------------------------------------------------------------
MouseSetSensitivityDefault:
        push ebp
        LD mov, ebp, esp
        cmp dword [MousePresent], byte 0
        je short .1
        mov ax, 1Ah
        mov bx, word [byte ebp+08h]
        mov cx, word [byte ebp+0Ch]
        mov dx, 40h
        int 33h
.1:
        leave
        ret
;-----------------------------------------------------------------------------
; MouseSetPos                                  B2DB4  95 PC, medium confidence
; Input_mouse lib: stores the two stack args as the mouse x/y (D302C/D3030),
; read back by MouseRead
;-----------------------------------------------------------------------------
MouseSetPos:
        push ebp
        LD mov, ebp, esp
        mov eax, dword [byte ebp+08h]
        mov edx, dword [byte ebp+0Ch]
        mov dword [mousex], eax
        mov dword [mousey], edx
        leave
        ret
;-----------------------------------------------------------------------------
; MouseRead                                    B2DCA  95 PC, medium confidence
; Mouse library: read buttons and position (btn, y, x)
;-----------------------------------------------------------------------------
MouseRead:
        push ebp
        LD mov, ebp, esp
        call MouseReadMotion
        db 08Bh,05Dh,08h                        ; insn: mov ebx,[ebp+8]
        db 089h,03h                             ; insn: mov [ebx],eax
        mov ecx, dword [mousex]
        mov ebx, dword [byte ebp+0Ch]
        mov dword [ebx], ecx
        mov edx, dword [mousey]
        mov ebx, dword [byte ebp+010h]
        mov dword [ebx], edx
        leave
        ret
;-----------------------------------------------------------------------------
; MouseSetXRange                               B2DEF  95 PC, medium confidence
; Sets the mouse X range; the Y range setter follows unlabelled
;-----------------------------------------------------------------------------
MouseSetXRange:
        push ebp
        LD mov, ebp, esp
        mov eax, dword [byte ebp+08h]
        mov edx, dword [byte ebp+0Ch]
        mov dword [mouseminx], eax
        mov dword [mousemaxx], edx
        leave
        ret
        push ebp
        LD mov, ebp, esp
        mov eax, dword [byte ebp+08h]
        mov edx, dword [byte ebp+0Ch]
        mov dword [mouseminy], eax
        mov dword [mousemaxy], edx
        leave
        ret
;-----------------------------------------------------------------------------
; SetViewRect                                  B2E1B  95 PC, medium confidence
; Graphics library: set the view rectangle (x, y, w, h)
;-----------------------------------------------------------------------------
SetViewRect:
        push ebp
        LD mov, ebp, esp
        mov eax, dword [byte ebp+08h]
        mov edx, dword [byte ebp+0Ch]
        mov ebx, dword [byte ebp+010h]
        mov ecx, dword [byte ebp+014h]
        mov dword [mouseminx], eax
        mov dword [mouseminy], edx
        mov dword [mousemaxx], ebx
        mov dword [mousemaxy], ecx
        leave
        ret
;-----------------------------------------------------------------------------
; MouseReadMotion                              B2E43  95 PC, medium confidence
; Mouse library: reads int 33h 0Bh into the pointer state
;-----------------------------------------------------------------------------
MouseReadMotion:
        dec dword [MouseButtonState]
        jne near .5
        mov eax, dword [MousePresent]
        LD or, eax, eax
        je near .5
        mov eax, 0Bh
        int 33h
        movsx ecx, cx
        movsx edx, dx
        mov eax, dword [mousex]
        mov ebx, dword [MouseDeltaX]
        LD add, ebx, ebx
        LD adc, eax, eax
        LD add, ecx, eax
        sar ecx, 1
        rcr ebx, 1
        add edx, dword [mousey]
        cmp ecx, dword [mouseminx]
        jge short .1
        mov ecx, dword [mouseminx]
        LD xor, ebx, ebx
.1:
        cmp ecx, dword [mousemaxx]
        jl short .2
        mov ecx, dword [mousemaxx]
        dec ecx
        LD xor, ebx, ebx
.2:
        cmp edx, dword [mouseminy]
        jge short .3
        mov edx, dword [mouseminy]
.3:
        cmp edx, dword [mousemaxy]
        jl short .4
        mov edx, dword [mousemaxy]
        dec edx
.4:
        mov dword [MouseDeltaX], ebx
        mov dword [mousex], ecx
        mov dword [mousey], edx
        inc dword [MouseButtonState]
        call MouseReadButtons
        dec dword [MouseButtonState]
        mov dword [mousebtns], eax
.5:
        mov eax, dword [mousebtns]
        inc dword [MouseButtonState]
        ret
;-----------------------------------------------------------------------------
; PointerCountUp                               B2EF6  95 PC, medium confidence
; Increments the pointer show count
;-----------------------------------------------------------------------------
PointerCountUp:
        inc dword [PointerCount]
        ret
;-----------------------------------------------------------------------------
; PointerCountDown                             B2EFD  95 PC, medium confidence
; Decrements the pointer show count
;-----------------------------------------------------------------------------
PointerCountDown:
        dec dword [PointerCount]
        ret
;-----------------------------------------------------------------------------
; MouseRestoreSensitivity                                         B2F04  95 PC
; Puts back the mouse sensitivity saved at start-up
;-----------------------------------------------------------------------------
MouseRestoreSensitivity:
        pusha
        mov ax, 1Ah
        mov bx, word [MouseSavedSensX]
        mov cx, word [MouseSavedSensY]
        mov dx, word [MouseSavedThreshold]
        int 33h
        popa
        ret
;-----------------------------------------------------------------------------
; InitMouse                                    B2F22  95 PC, medium confidence
; Finds the mouse, saves its sensitivity, sets its range and the pointer
; routines
;-----------------------------------------------------------------------------
InitMouse:
        mov dword [MousePresent], 0
        mov dword [PointerCount], 0
        mov dword [MouseButtons], 0
        LD xor, eax, eax
        int 33h
        LD or, ax, ax
        je near .2
        inc dword [MousePresent]
        cmp dword [MouseForceTwoButtons], byte 0
        je short .1
        mov dword [MouseButtons], 2
        mov eax, 3
        int 33h
        LD or, ax, ax
        jne short .1
        mov dword [MousePresent], 2
.1:
        push dword [ViewScreenHeight]
        push dword [ViewScreenWidth]
        push byte 0
        push byte 0
        call SetViewRect
        mov eax, dword [ViewScreenHeight]
        shr eax, 2
        mov dword [mousex], eax
        mov eax, dword [ViewScreenWidth]
        shr eax, 2
        mov dword [mousey], eax
        mov ax, 1Bh
        int 33h
        mov word [MouseSavedSensX], bx
        mov word [MouseSavedSensY], cx
        mov word [MouseSavedThreshold], dx
        push byte 40h
        push byte 20h
        push byte 20h
        call MouseSetSensitivity
        mov dword [HidePointerKeepHook], PointerCountDown
        mov dword [HidePointerHook], PointerCountDown
        mov dword [ShowPointerHook], PointerCountUp
        mov dword [mousepollfn], MouseReadMotion
        push MouseRestoreSensitivity
        call AddExitHandler
        add esp, byte 20h
.2:
        mov eax, dword [MousePresent]
        ret
