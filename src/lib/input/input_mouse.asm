; Reading the mouse.
bits 32
%include "hockey.inc"
section s_B2D38 progbits alloc exec nowrite align=1
extern mouseminx, mouseminy, mousemaxx, mousemaxy, dword_D2FFC, MouseButtonState, dword_D301C, MousePresent
extern PointerCount, dword_D303C, dword_D3044, dword_D3048, mousebtns, mousepollfn, mousex, mousey
extern off_D306C, off_D3070, off_D3074, AddExitHandler, word_D3004, word_D3006, word_D3008
global MouseReadButtons, MouseSetSensitivity, MouseSetSensitivityDefault, MouseSetPos, MouseRead, MouseSetXRange, SetViewRect, MouseReadMotion
global PointerCountUp, PointerCountDown, MouseRestoreSensitivity, InitMouse
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
MouseSetPos:
        push ebp
        LD mov, ebp, esp
        mov eax, dword [byte ebp+08h]
        mov edx, dword [byte ebp+0Ch]
        mov dword [mousex], eax
        mov dword [mousey], edx
        leave
        ret
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
        mov ebx, dword [dword_D2FFC]
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
        mov dword [dword_D2FFC], ebx
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
PointerCountUp:
        inc dword [PointerCount]
        ret
PointerCountDown:
        dec dword [PointerCount]
        ret
MouseRestoreSensitivity:
        pusha
        mov ax, 1Ah
        mov bx, word [word_D3004]
        mov cx, word [word_D3006]
        mov dx, word [word_D3008]
        int 33h
        popa
        ret
InitMouse:
        mov dword [MousePresent], 0
        mov dword [PointerCount], 0
        mov dword [dword_D303C], 0
        LD xor, eax, eax
        int 33h
        LD or, ax, ax
        je near .2
        inc dword [MousePresent]
        cmp dword [dword_D301C], byte 0
        je short .1
        mov dword [dword_D303C], 2
        mov eax, 3
        int 33h
        LD or, ax, ax
        jne short .1
        mov dword [MousePresent], 2
.1:
        push dword [dword_D3048]
        push dword [dword_D3044]
        push byte 0
        push byte 0
        call SetViewRect
        mov eax, dword [dword_D3048]
        shr eax, 2
        mov dword [mousex], eax
        mov eax, dword [dword_D3044]
        shr eax, 2
        mov dword [mousey], eax
        mov ax, 1Bh
        int 33h
        mov word [word_D3004], bx
        mov word [word_D3006], cx
        mov word [word_D3008], dx
        push byte 40h
        push byte 20h
        push byte 20h
        call MouseSetSensitivity
        mov dword [off_D306C], PointerCountDown
        mov dword [off_D3070], PointerCountDown
        mov dword [off_D3074], PointerCountUp
        mov dword [mousepollfn], MouseReadMotion
        push MouseRestoreSensitivity
        call AddExitHandler
        add esp, byte 20h
.2:
        mov eax, dword [MousePresent]
        ret
