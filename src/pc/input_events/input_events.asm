; Joystick calibration, the mouse and keyboard event queue, drawing a menu bar, and polling the devices.
bits 32
%include "hockey.inc"
section s_6B093 progbits alloc exec nowrite align=1
extern __CHK, addtimer, attdb, attdb_size, byte_D416A, careerdb, careerdb_size, carteamsdb
extern carteamsdb_size, ctlavailmask, dword_C4CFC, dword_C71E0, cursndbank, dword_CDA24, dword_CDA38, enterheld
extern facount, FadePalStep, falist, falistsel, FreeLeagueDbsMem, FreeMemBlock, InitSpeechSlots, inputev
extern inputinstalled, inputpolldiv, inputqcount, inputqhead, inputqtail, inputqueue, inputrepeat, joybtnheld
extern joycalactive, joycalposthook, joycalprehook, joycalx, joycaly, joyenablemask, keydb, keydb_size
extern KeyDbPtr, lastinputdir, lastmousebtns, lastmousex, lastmousey, leaguedbnames, MakePath, memcpy_
extern memset_, mousebtns, mousepollfn, MouseSetPos, mousex, mousey, musicon, PollKey
extern PrintShadowText, ptrstep, ptrupdatefn, RemoveTimerCallback, RunEditRosters, scrpitch, seasondb, seasondb_size
extern SetTextColors, speechbank, str_dot, str_Joycal, str_Left, str_LEFTJOYSTICK, str_Pal24, str_Puck
extern str_PuckBack, str_RIGHTJOYSTICK, str_Rite, str_Scrn3, str_space, strcat_, AllocMemBlock, PushMemDescriptorLocked
extern LoadBank, sub_8E8A0, TextSetColors, TextSaveState, TextRestoreState, TextSetFont, FillRect, DrawArtOpaque
extern sub_9121C, DrawArt, DrawShape, GrabBlock, PrintString, sub_92CD0, GetFileSize, RemoveKeyboardHandler
extern KeyDown, InitMouse, FindShape, sub_B30F4, JoyButtonMap, ReadJoyRaw, sub_B384E, sub_B387E
extern ClearScreen, KbdGetKey, VgaSetPalette, SetScreenTarget, sub_B4C61, FillRectColor, TeamRecPtr, teamsdb
extern teamsdb_size, unk_C27F5, DefaultFont
global JoystickCalScreen, CalLeftJoystick, CalLeftJoystick_common, CalRightJoystick, GetInputEvent, ClearInputQueue, InputInstall, InputRemove
global EventToPointer, DrawMenuBar, DrawMenuDropdown, DrawMenuDropdown_ret, DrawMenuBox, PrintMenuText, PrintMenuTextGrey, PrintMenuTextGrey_common
global PrintMenuTextGrey_ret, PrintMenuTextAlt, DrawMenuItemSel, DrawMenuItemSel_common, DrawMenuItemSel_ret, DrawMenuItemNorm, MenuHitTest, InputPollTick
global PollMouseEvent, PollJoystickEvent, PollKeyboardEvent
;-----------------------------------------------------------------------------
; JoystickCalScreen                                               6B093  95 PC
; (stick, shift, mask, title): "joycal" screen with the left / right stick
; picture; moves the puck to the position of the stick direction (joycalx /
; joycaly) until a button; Esc / failure clears the stick from joyenablemask
;-----------------------------------------------------------------------------
; C: src/pc/input_events/JoystickCalScreen.c
%ifdef CBUILD
%include "c/pc/input_events/JoystickCalScreen.inc"
%else
JoystickCalScreen:
        push dword 368h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, 34Ch
        mov dword [joycalactive], 1
        call dword [joycalprehook]
        cmp dword [dword esp+0364h], byte 0
        je short .1
        call sub_B387E
        jmp short .2
.1:
        call sub_B384E
.2:
        push byte 0
        push byte 0
        call TextSetColors
        add esp, byte 8
        call ReadJoyRaw
        mov cl, byte [dword esp+0360h]
        sar eax, cl
        test al, 30h
        jne near .9
        lea eax, [dword esp+0300h]
        push eax
        call TextSaveState
        add esp, byte 4
        push DefaultFont
        call TextSetFont
        add esp, byte 4
        call SetScreenTarget
        push byte 0
        call ClearScreen
        add esp, byte 4
        mov ebx, 300h
        xor edx, edx
        mov eax, esp
        call memset_
        mov eax, esp
        push eax
        push dword 100h
        push byte 0
        call VgaSetPalette
        add esp, byte 0Ch
        push byte 0
        push str_Joycal
        call LoadBank
        mov esi, eax
        add esp, byte 8
        mov dword [dword esp+0340h], eax
        push str_Scrn3
        push eax
        call FindShape
        add esp, byte 8
        push eax
        call sub_9121C
        add esp, byte 4
        cmp dword [dword esp+0364h], byte 0
        je short .3
        push str_Rite
        jmp short .4
.3:
        push str_Left
.4:
        push esi
        call FindShape
        add esp, byte 8
        mov dword [dword esp+0344h], eax
        mov ebp, dword [dword esp+0344h]
        push ebp
        call DrawShape
        add esp, byte 4
        push str_Pal24
        mov eax, dword [dword esp+0344h]
        push eax
        call FindShape
        add esp, byte 8
        lea edx, [byte eax+010h]
        mov ebx, 300h
        mov eax, esp
        call memcpy_
        push str_Puck
        mov edx, dword [dword esp+0344h]
        push edx
        call FindShape
        mov esi, eax
        add esp, byte 8
        mov dword [dword esp+0344h], eax
        push byte 0
        mov edx, dword [byte eax+02h]
        sar edx, 10h
        mov eax, dword [byte eax+04h]
        sar eax, 10h
        imul eax, edx
        add eax, byte 11h
        push eax
        push str_PuckBack
        call AllocMemBlock
        add esp, byte 0Ch
        mov ebp, eax
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov ebx, 10h
        mov edx, esp
        xor eax, eax
        call FadePalStep
        mov esi, 0FFFFFFFFh
.5:
        call KbdGetKey
        test eax, eax
        je short .6
        mov eax, dword [dword esp+035Ch]
        not eax
        and dword [joyenablemask], eax
        jmp near .8
.6:
        call ReadJoyRaw
        mov cl, byte [dword esp+0360h]
        sar eax, cl
        mov dword [dword esp+0348h], eax
        test byte [dword esp+0348h], 30h
        jne near .8
        mov ebx, dword [dword esp+0348h]
        push ebx
        call JoyButtonMap
        add esp, byte 4
        mov dword [dword esp+0348h], eax
        cmp eax, esi
        je short JoystickCalScreen.5
        call sub_B4C61
        cmp esi, byte 0FFFFFFFFh
        je short .7
        mov ecx, dword [nosplit esi*4+joycaly]
        push ecx
        mov edi, dword [nosplit esi*4+joycalx]
        push edi
        push ebp
        call DrawArtOpaque
        add esp, byte 0Ch
.7:
        mov esi, dword [dword esp+0348h]
        mov eax, dword [nosplit esi*4+joycaly]
        push eax
        mov edx, dword [nosplit esi*4+joycalx]
        push edx
        push ebp
        call GrabBlock
        add esp, byte 0Ch
        mov ebx, dword [nosplit esi*4+joycaly]
        push ebx
        mov ecx, dword [nosplit esi*4+joycalx]
        push ecx
        mov esi, dword [dword esp+034Ch]
        push esi
        call DrawArt
        add esp, byte 0Ch
        mov esi, dword [dword esp+0348h]
        push byte 14h
        push byte 0
        push unk_C27F5
        call PrintString
        add esp, byte 0Ch
        jmp near JoystickCalScreen.5
.8:
        push ebp
        call FreeMemBlock
        add esp, byte 4
        mov ebp, dword [dword esp+0340h]
        push ebp
        call FreeMemBlock
        add esp, byte 4
        mov ebx, 10h
        mov edx, esp
        mov eax, 1
        call FadePalStep
        lea eax, [dword esp+0300h]
        push eax
        call TextRestoreState
        add esp, byte 4
        jmp short .10
.9:
        mov eax, dword [dword esp+035Ch]
        not eax
        and dword [joyenablemask], eax
.10:
        call dword [joycalposthook]
        xor eax, eax
        mov dword [joycalactive], eax
        add esp, 34Ch
        pop ebp
        pop edi
        pop esi
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CalLeftJoystick                                                 6B35C  95 PC
; JoystickCalScreen(1, 0, 0, "LEFT JOYSTICK") (no refs; startup calls
; JoystickCalScreen directly)
;-----------------------------------------------------------------------------
; C: src/pc/input_events/CalLeftJoystick.c
%ifdef CBUILD
%include "c/pc/input_events/CalLeftJoystick.inc"
%else
CalLeftJoystick:
        push dword 14h
        call __CHK
        push str_LEFTJOYSTICK
        push byte 0
        push byte 0
        push byte 1
CalLeftJoystick_common:
        call JoystickCalScreen
        add esp, byte 10h
        ret
;-----------------------------------------------------------------------------
; CalRightJoystick                                                6B37A  95 PC
; JoystickCalScreen(2, 8, 1, "RIGHT JOYSTICK") (no refs)
;-----------------------------------------------------------------------------
CalRightJoystick:
        push dword 14h
        call __CHK
        push str_RIGHTJOYSTICK
        push byte 1
        push byte 8
        push byte 2
        jmp short CalLeftJoystick_common
%endif ; C
;-----------------------------------------------------------------------------
; GetInputEvent                                                   6B391  95 PC
; Pops the next 13-byte event from the 32-entry input queue (inputqueue), 0
; if empty
;-----------------------------------------------------------------------------
; C: src/pc/input_events/GetInputEvent.c
%ifdef CBUILD
%include "c/pc/input_events/GetInputEvent.inc"
%else
GetInputEvent:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        mov edx, dword [inputqcount]
        test edx, edx
        jne short .1
        xor eax, eax
        pop edx
        pop ebx
        ret
.1:
        lea ebx, [byte edx-01h]
        mov dword [inputqcount], ebx
        mov eax, dword [inputqtail]
        inc eax
        and eax, byte 1Fh
        mov dword [inputqtail], eax
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        add eax, inputqueue
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ClearInputQueue                                                 6B3D7  95 PC
; Resets the input queue and held-button flags
;-----------------------------------------------------------------------------
; C: src/pc/input_events/ClearInputQueue.c
%ifdef CBUILD
%include "c/pc/input_events/ClearInputQueue.inc"
%else
ClearInputQueue:
        push dword 8
        call __CHK
        push edx
        xor edx, edx
        mov dword [inputqcount], edx
        mov dword [inputqtail], 1Fh
        mov dword [inputqhead], edx
        mov dword [dword_CDA38], edx
        mov dword [joybtnheld], edx
        mov dword [enterheld], edx
        xor eax, eax
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; InputInstall                                                    6B410  95 PC
; Detects the mouse (ctlavailmask bit 0), installs InputPollTick as timer
; callback, clears the queue, ptrupdatefn = EventToPointer
;-----------------------------------------------------------------------------
; C: src/pc/input_events/InputInstall.c
%ifdef CBUILD
%include "c/pc/input_events/InputInstall.inc"
%else
InputInstall:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        call InitMouse
        test eax, eax
        je short .1
        or byte [ctlavailmask], 1
        jmp short .2
.1:
        and byte [ctlavailmask], 0FEh
.2:
        cmp dword [inputinstalled], byte 0
        jne short .x
        call RemoveKeyboardHandler
        xor ebx, ebx
        mov dword [dword_CDA24], ebx
        mov dword [ptrstep], ebx
        mov dword [inputinstalled], 1
        push InputPollTick
        call addtimer
        add esp, byte 4
        call ClearInputQueue
        mov dword [ptrupdatefn], EventToPointer
.x:
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; InputRemove                                                     6B47C  95 PC
; Removes the InputPollTick timer callback
;-----------------------------------------------------------------------------
; C: src/pc/input_events/InputRemove.c
%ifdef CBUILD
%include "c/pc/input_events/InputRemove.inc"
%else
InputRemove:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        cmp dword [inputinstalled], byte 0
        je short .x
        xor ebx, ebx
        mov dword [dword_CDA24], ebx
        mov dword [ptrstep], ebx
        push InputPollTick
        call RemoveTimerCallback
        add esp, byte 4
        xor esi, esi
        mov dword [inputinstalled], esi
.x:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; EventToPointer                                                  6B4BB  95 PC
; (event, x*, y*): mouse events set the pointer position, joystick / key
; events step it with acceleration (8 << repeat/5), clamped to 0..275h /
; 0..1D5h, MouseSetPos; returns the buttons
;-----------------------------------------------------------------------------
; C: src/pc/input_events/EventToPointer.c
%ifdef CBUILD
%include "c/pc/input_events/EventToPointer.inc"
%else
EventToPointer:
        push dword 1Ch
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, eax
        mov edi, edx
        mov esi, ebx
        cmp dword [eax], byte 1
        jne short .4
        mov eax, dword [byte eax+05h]
        mov dword [edi], eax
        mov eax, dword [byte ebp+09h]
        mov dword [ebx], eax
        mov eax, dword [edi]
        test eax, eax
        jge short .1
        mov dword [edi], 0
        jmp short .2
.1:
        cmp eax, 275h
        jle short .2
        mov dword [edi], 275h
.2:
        mov ebx, dword [esi]
        test ebx, ebx
        jge short .3
        mov dword [esi], 0
        jmp near .14
.3:
        cmp ebx, 1D5h
        jle near .14
        mov dword [esi], 1D5h
        jmp near .14
.4:
        cmp dword [inputrepeat], byte 1Eh
        jl short .5
        mov dword [inputrepeat], 1Dh
.5:
        mov ebx, 5
        mov eax, dword [inputrepeat]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        mov cl, al
        mov eax, 8
        shl eax, cl
        mov dword [ptrstep], eax
        test byte [byte ebp+05h], 8
        je short .6
        mov eax, dword [ptrstep]
        sub dword [edi], eax
.6:
        test byte [byte ebp+05h], 4
        je short .7
        mov eax, dword [ptrstep]
        add dword [edi], eax
.7:
        test byte [byte ebp+05h], 1
        je short .8
        mov eax, dword [ptrstep]
        sub dword [esi], eax
.8:
        test byte [byte ebp+05h], 2
        je short .9
        mov eax, dword [ptrstep]
        add dword [esi], eax
.9:
        mov ebx, dword [edi]
        test ebx, ebx
        jge short .10
        mov dword [edi], 0
        jmp short .11
.10:
        cmp ebx, 275h
        jle short .11
        mov dword [edi], 275h
.11:
        mov eax, dword [esi]
        test eax, eax
        jge short .12
        mov dword [esi], 0
        jmp short .13
.12:
        cmp eax, 1D5h
        jle short .13
        mov dword [esi], 1D5h
.13:
        mov ebx, dword [esi]
        push ebx
        mov ecx, dword [edi]
        push ecx
        call MouseSetPos
        add esp, byte 8
        mov eax, dword [edi]
        mov dword [mousex], eax
        mov eax, dword [esi]
        mov dword [mousey], eax
.14:
        xor eax, eax
        mov al, byte [byte ebp+04h]
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawMenuBar                                  6B5E4  95 PC, medium confidence
; Draws the boxes and labels of a menu bar (32-byte items, label +10h) and
; the rest of the bar to x 27Fh
;-----------------------------------------------------------------------------
; C: src/pc/input_events/DrawMenuBar.c
%ifdef CBUILD
%include "c/pc/input_events/DrawMenuBar.inc"
%else
DrawMenuBar:
        push dword 28h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 4
        push eax
        push edx
        mov ebp, ebx
        mov dword [byte esp+08h], ecx
        push dword 0FFh
        push ebx
        call TextSetColors
        add esp, byte 8
        xor edx, edx
        mov eax, ebp
        call SetTextColors
        xor edi, edi
        jmp short .2
.1:
        mov ebx, dword [byte esp+01Ch]
        push ebx
        mov ecx, dword [byte esp+0Ch]
        push ecx
        push ebp
        mov esi, edi
        shl esi, 5
        add esi, dword [byte esp+010h]
        mov ecx, dword [byte esi+0Ch]
        mov ebx, dword [byte esi+08h]
        mov eax, dword [esi]
        xor edx, edx
        call DrawMenuBox
        mov ebx, dword [byte esi+010h]
        mov eax, dword [esi]
        add eax, byte 3
        mov edx, 2
        call PrintMenuText
        inc edi
.2:
        cmp edi, dword [esp]
        jl short DrawMenuBar.1
        mov edx, dword [byte esp+01Ch]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        push ebp
        mov eax, dword [byte esp+0Ch]
        shl eax, 5
        add eax, dword [byte esp+010h]
        mov ecx, dword [byte eax-014h]
        mov eax, dword [byte eax-018h]
        inc eax
        mov ebx, 27Fh
        xor edx, edx
        call DrawMenuBox
        add esp, byte 0Ch
        pop ebp
        pop edi
        pop esi
        ret 4
%endif ; C
;-----------------------------------------------------------------------------
; DrawMenuDropdown                             6B684  95 PC, medium confidence
; Draws a drop-down box and its items, items without action / submenu (+14h /
; +18h) greyed
;-----------------------------------------------------------------------------
; C: src/pc/input_events/DrawMenuDropdown.c
%ifdef CBUILD
%include "c/pc/input_events/DrawMenuDropdown.inc"
%else
DrawMenuDropdown:
        push dword 28h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 0Ch
        mov ebp, eax
        mov dword [esp], edx
        mov dword [byte esp+04h], ebx
        mov dword [byte esp+08h], ecx
        mov edx, dword [byte esp+024h]
        push edx
        mov ebx, dword [byte esp+024h]
        push ebx
        mov ecx, dword [byte esp+024h]
        push ecx
        mov eax, dword [byte esp+0Ch]
        shl eax, 5
        mov ecx, dword [byte eax+ebp-014h]
        mov esi, dword [byte esp+014h]
        add ecx, esi
        mov ebx, dword [byte eax+ebp-018h]
        mov edi, dword [byte esp+010h]
        add ebx, edi
        mov edx, dword [byte ebp+04h]
        add edx, esi
        mov eax, dword [byte ebp+00h]
        add eax, edi
        call DrawMenuBox
        cmp dword [byte ebp+014h], byte 0
        jne short .1
        cmp dword [byte ebp+018h], byte 0
        jne short .1
        push dword 0FFh
        mov edi, dword [byte esp+028h]
        push edi
        call TextSetColors
        add esp, byte 8
        xor edx, edx
        mov eax, edi
        call SetTextColors
        mov ebx, dword [byte ebp+010h]
        mov edx, dword [byte ebp+04h]
        add edx, byte 2
        add edx, esi
        mov eax, dword [byte ebp+00h]
        add eax, byte 3
        add eax, dword [byte esp+04h]
        call PrintMenuTextGrey
        jmp short .2
.1:
        push dword 0FFh
        mov edx, dword [byte esp+020h]
        push edx
        call TextSetColors
        add esp, byte 8
        xor edx, edx
        mov eax, dword [byte esp+01Ch]
        call SetTextColors
        mov ebx, dword [byte ebp+010h]
        mov edx, dword [byte ebp+04h]
        add edx, byte 2
        add edx, dword [byte esp+08h]
        mov eax, dword [byte ebp+00h]
        add eax, byte 3
        add eax, dword [byte esp+04h]
        call PrintMenuText
.2:
        mov edi, 1
        jmp near .6
.3:
        mov esi, edi
        shl esi, 5
        add esi, ebp
        cmp dword [byte esi+014h], byte 0
        jne short .4
        cmp dword [byte esi+018h], byte 0
        jne short .4
        push dword 0FFh
        mov eax, dword [byte esp+028h]
        push eax
        call TextSetColors
        add esp, byte 8
        xor edx, edx
        mov eax, dword [byte esp+024h]
        call SetTextColors
        mov ebx, dword [byte esi+010h]
        mov edx, dword [byte esi+04h]
        inc edx
        add edx, dword [byte esp+08h]
        mov eax, dword [esi]
        add eax, byte 3
        add eax, dword [byte esp+04h]
        call PrintMenuTextGrey
        jmp short .5
.4:
        push dword 0FFh
        mov ebx, dword [byte esp+020h]
        push ebx
        call TextSetColors
        add esp, byte 8
        xor edx, edx
        mov eax, dword [byte esp+01Ch]
        call SetTextColors
        mov esi, edi
        shl esi, 5
        mov ebx, dword [byte esi+ebp+010h]
        mov edx, dword [byte esi+ebp+04h]
        inc edx
        add edx, dword [byte esp+08h]
        mov eax, dword [esi+ebp]
        add eax, byte 3
        add eax, dword [byte esp+04h]
        call PrintMenuText
.5:
        inc edi
.6:
        cmp edi, dword [esp]
        jl near DrawMenuDropdown.3
        add esp, byte 0Ch
DrawMenuDropdown_ret:
        pop ebp
        pop edi
        pop esi
        ret 0Ch
;-----------------------------------------------------------------------------
; DrawMenuBox                                  6B7FC  95 PC, medium confidence
; (x1, y1, x2, y2, fill, light, dark): fill rect plus four edge lines
;-----------------------------------------------------------------------------
DrawMenuBox:
        push dword 28h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov edi, eax
        mov esi, edx
        mov dword [esp], ebx
        mov ebp, ecx
        mov edx, dword [byte esp+018h]
        push edx
        mov eax, ecx
        sub eax, esi
        inc eax
        push eax
        mov eax, ebx
        sub eax, edi
        inc eax
        push eax
        push esi
        push edi
        call FillRect
        add esp, byte 14h
        mov ebx, dword [byte esp+014h]
        push ebx
        push esi
        mov eax, dword [byte esp+08h]
        dec eax
        push eax
        push esi
        push edi
        call FillRectColor
        add esp, byte 14h
        mov ecx, dword [byte esp+014h]
        push ecx
        lea eax, [byte ebp-01h]
        push eax
        push edi
        push esi
        push edi
        call FillRectColor
        add esp, byte 14h
        mov eax, dword [byte esp+01Ch]
        push eax
        push ebp
        mov edx, dword [byte esp+08h]
        push edx
        inc esi
        push esi
        push edx
        call FillRectColor
        add esp, byte 14h
        mov ecx, dword [byte esp+01Ch]
        push ecx
        push ebp
        mov esi, dword [byte esp+08h]
        push esi
        push ebp
        inc edi
        push edi
        call FillRectColor
        add esp, byte 14h
        add esp, byte 4
        jmp near DrawMenuDropdown_ret
%endif ; C
;-----------------------------------------------------------------------------
; PrintMenuText                                6B88E  95 PC, medium confidence
; Copies up to 79 chars and PrintShadowText
;-----------------------------------------------------------------------------
; C: src/pc/input_events/PrintMenuText.c
%ifdef CBUILD
%include "c/pc/input_events/PrintMenuText.inc"
%else
PrintMenuText:
        push dword 5Ch
        call __CHK
        push ecx
        push esi
        sub esp, byte 50h
        mov ecx, eax
        mov esi, edx
        xor eax, eax
        jmp short .2
.1:
        mov dl, byte [edx]
        mov byte [esp+eax], dl
        inc eax
.2:
        lea edx, [ebx+eax]
        cmp byte [edx], 0
        je short .3
        cmp eax, byte 4Fh
        jl short PrintMenuText.1
.3:
        mov dl, byte [ebx+eax]
        mov byte [esp+eax], dl
        mov ebx, esp
        mov edx, esi
        mov eax, ecx
        call PrintShadowText
        jmp short PrintMenuTextGrey_ret
;-----------------------------------------------------------------------------
; PrintMenuTextGrey                            6B8CB  95 PC, medium confidence
; Copies up to 79 chars and prints with PrintString (disabled item)
;-----------------------------------------------------------------------------
PrintMenuTextGrey:
        push dword 68h
        call __CHK
        push ecx
        push esi
        sub esp, byte 50h
        mov ecx, eax
        mov esi, edx
        xor eax, eax
        jmp short .2
.1:
        mov dl, byte [edx]
        mov byte [esp+eax], dl
        inc eax
.2:
        lea edx, [ebx+eax]
        cmp byte [edx], 0
        je short .3
        cmp eax, byte 4Fh
        jl short PrintMenuTextGrey.1
.3:
        mov dl, byte [ebx+eax]
        mov byte [esp+eax], dl
        push esi
        push ecx
        lea eax, [byte esp+08h]
        push eax
        call PrintString
PrintMenuTextGrey_common:
        add esp, byte 0Ch
PrintMenuTextGrey_ret:
        add esp, byte 50h
        pop esi
        pop ecx
        ret
;-----------------------------------------------------------------------------
; PrintMenuTextAlt                             6B910  95 PC, medium confidence
; Copies up to 79 chars to a local buffer and prints with sub_92CD0 (shares
; PrintMenuTextGrey tail); no refs
;-----------------------------------------------------------------------------
PrintMenuTextAlt:
        push dword 68h
        call __CHK
        push ecx
        push esi
        sub esp, byte 50h
        mov ecx, eax
        mov esi, edx
        xor eax, eax
        jmp short .2
.1:
        mov dl, byte [edx]
        mov byte [esp+eax], dl
        inc eax
.2:
        lea edx, [ebx+eax]
        cmp byte [edx], 0
        je short .3
        cmp eax, byte 4Fh
        jl short PrintMenuTextAlt.1
.3:
        mov dl, byte [ebx+eax]
        mov byte [esp+eax], dl
        push esi
        push ecx
        lea eax, [byte esp+08h]
        push eax
        call sub_92CD0
        jmp short PrintMenuTextGrey_common
%endif ; C
;-----------------------------------------------------------------------------
; DrawMenuItemSel                              6B94E  95 PC, medium confidence
; Fills an enabled menu item with the selected colour and redraws its label
;-----------------------------------------------------------------------------
; C: src/pc/input_events/DrawMenuItemSel.c
%ifdef CBUILD
%include "c/pc/input_events/DrawMenuItemSel.inc"
%else
DrawMenuItemSel:
        push dword 28h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov esi, eax
        mov edi, edx
        mov ebp, ebx
        mov dword [esp], ecx
        cmp dword [byte eax+014h], byte 0
        jne short .1
        cmp dword [byte eax+018h], byte 0
        je short DrawMenuItemSel_ret
.1:
        mov eax, dword [byte esi+08h]
        sub eax, dword [esi]
        lea ebx, [byte eax-02h]
        mov eax, dword [byte esi+0Ch]
        mov edx, dword [byte esi+04h]
        sub eax, edx
        mov edx, eax
        mov ecx, dword [byte esi+04h]
        test ecx, ecx
        sete al
        and eax, 0FFh
        sub edx, eax
        mov eax, dword [esi]
        inc eax
        add edi, eax
        add ebp, ecx
        test ecx, ecx
        sete al
        and eax, 0FFh
        add ebp, eax
        mov eax, dword [byte esp+014h]
DrawMenuItemSel_common:
        push eax
        push edx
        push ebx
        push ebp
        push edi
        call FillRect
        add esp, byte 14h
        push dword 0FFh
        mov edx, dword [byte esp+04h]
        push edx
        call TextSetColors
        add esp, byte 8
        xor edx, edx
        mov eax, dword [esp]
        call SetTextColors
        mov ebx, dword [byte esi+010h]
        lea edx, [byte ebp+01h]
        lea eax, [byte edi+02h]
        call PrintMenuText
DrawMenuItemSel_ret:
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        ret 8
%endif ; C
;-----------------------------------------------------------------------------
; DrawMenuItemNorm                             6B9EB  95 PC, medium confidence
; Same with the normal colour
;-----------------------------------------------------------------------------
; C: src/pc/input_events/DrawMenuItemSel.c (DrawMenuItemNorm)
%ifdef CBUILD
%include "c/pc/input_events/DrawMenuItemSel.DrawMenuItemNorm.inc"
%else
DrawMenuItemNorm:
        push dword 28h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov esi, eax
        mov edi, edx
        mov ebp, ebx
        mov dword [esp], ecx
        cmp dword [byte eax+014h], byte 0
        jne short .1
        cmp dword [byte eax+018h], byte 0
        je short DrawMenuItemSel_ret
.1:
        mov eax, dword [byte esi+08h]
        sub eax, dword [esi]
        lea ebx, [byte eax-02h]
        mov eax, dword [byte esi+0Ch]
        mov edx, dword [byte esi+04h]
        sub eax, edx
        mov edx, eax
        mov ecx, dword [byte esi+04h]
        test ecx, ecx
        sete al
        and eax, 0FFh
        sub edx, eax
        mov eax, dword [esi]
        inc eax
        add edi, eax
        add ebp, ecx
        test ecx, ecx
        sete al
        and eax, 0FFh
        add ebp, eax
        mov eax, dword [byte esp+018h]
        jmp near DrawMenuItemSel_common
%endif ; C
;-----------------------------------------------------------------------------
; MenuHitTest                                  6BA4D  95 PC, medium confidence
; (levels, x, y, ...): finds the open menu level and item under the point,
; top level first
;-----------------------------------------------------------------------------
; C: src/pc/input_events/MenuHitTest.c
%ifdef CBUILD
%include "c/pc/input_events/MenuHitTest.inc"
%else
MenuHitTest:
        push dword 14h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov edi, eax
        mov ebp, edx
        mov dword [esp], ebx
        mov esi, ecx
        lea edi, [byte eax+04h]
        jmp near .6
.1:
        mov eax, esi
        shl eax, 2
        add eax, dword [esp]
        cmp dword [eax], byte 0
        je short .5
        xor ebx, ebx
        jmp short .4
.2:
        add eax, dword [esp]
        mov edx, ebx
        shl edx, 5
        mov eax, dword [eax]
        add eax, edx
        mov edx, esi
        shl edx, 3
        add edx, dword [byte esp+018h]
        mov ecx, dword [edx]
        add ecx, dword [eax]
        cmp edi, ecx
        jl short .3
        mov ecx, dword [edx]
        add ecx, dword [byte eax+08h]
        cmp edi, ecx
        jg short .3
        mov ecx, dword [byte edx+04h]
        add ecx, dword [byte eax+04h]
        cmp ebp, ecx
        jl short .3
        mov edx, dword [byte edx+04h]
        add edx, dword [byte eax+0Ch]
        cmp ebp, edx
        jg short .3
        mov eax, dword [byte esp+01Ch]
        mov dword [eax], esi
        mov eax, dword [byte esp+020h]
        mov dword [eax], ebx
        mov eax, 1
        jmp short .x
.3:
        inc ebx
.4:
        mov eax, esi
        shl eax, 2
        mov edx, dword [byte esp+014h]
        cmp ebx, dword [edx+eax]
        jl short MenuHitTest.2
.5:
        dec esi
.6:
        test esi, esi
        jge short MenuHitTest.1
        xor eax, eax
.x:
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        ret 10h
%endif ; C
;-----------------------------------------------------------------------------
; InputPollTick                                                   6BAEB  95 PC
; Timer callback, every 5 ticks: PollMouseEvent / PollJoystickEvent /
; PollKeyboardEvent by ctlavailmask, tracks direction repeat, queues the
; event
;-----------------------------------------------------------------------------
InputPollTick:
        push edx
        push esi
        push ebp
        xor eax, eax
        mov edx, dword [inputpolldiv]
        dec edx
        mov dword [inputpolldiv], edx
        jne near .x
        mov dword [inputpolldiv], 5
        test byte [ctlavailmask], 1
        je short .1
        mov eax, inputev
        call PollMouseEvent
.1:
        test eax, eax
        jne short .3
        mov dh, byte [ctlavailmask]
        test dh, 2
        jne short .2
        test dh, 4
        je short .3
.2:
        mov eax, inputev
        call PollJoystickEvent
.3:
        test eax, eax
        jne short .4
        test byte [ctlavailmask], 8
        je short .4
        mov eax, inputev
        call PollKeyboardEvent
.4:
        test eax, eax
        jne short .5
        mov dword [lastinputdir], eax
        mov dword [inputrepeat], eax
        pop ebp
        pop esi
        pop edx
        ret
.5:
        cmp dword [inputev], byte 1
        jne short .6
        xor edx, edx
        mov dword [lastinputdir], edx
        mov dword [inputrepeat], edx
        jmp short .8
.6:
        xor eax, eax
        mov al, byte [inputev+5]
        cmp eax, dword [lastinputdir]
        jne short .7
        inc dword [inputrepeat]
        jmp short .8
.7:
        xor ebp, ebp
        mov dword [inputrepeat], ebp
        mov dword [lastinputdir], eax
.8:
        cmp dword [inputqcount], byte 20h
        je near .x
        mov edx, dword [inputqhead]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        mov esi, dword [inputev]
        cmp esi, byte 1
        jne short .9
        mov dword [dword eax+inputqueue], esi
        mov dl, byte [inputev+4]
        mov byte [dword eax+inputqueue+4], dl
        mov edx, dword [inputev+5]
        mov dword [dword eax+inputqueue+5], edx
        mov edx, dword [inputev+9]
        mov dword [dword eax+inputqueue+9], edx
        jmp short .10
.9:
        mov dword [dword eax+inputqueue], esi
        mov dl, byte [inputev+4]
        mov byte [dword eax+inputqueue+4], dl
        mov dl, byte [inputev+5]
        mov byte [dword eax+inputqueue+5], dl
.10:
        mov eax, dword [inputqhead]
        inc eax
        and eax, byte 1Fh
        mov dword [inputqhead], eax
        inc dword [inputqcount]
.x:
        pop ebp
        pop esi
        pop edx
        ret
;-----------------------------------------------------------------------------
; PollMouseEvent                                                  6BC30  95 PC
; Event type 1 when mouse x / y / buttons changed (button release flagged 2)
;-----------------------------------------------------------------------------
PollMouseEvent:
        push ebx
        push ecx
        push edx
        push esi
        mov esi, eax
        call dword [mousepollfn]
        mov eax, dword [lastmousebtns]
        cmp eax, dword [mousebtns]
        jne short .1
        mov eax, dword [lastmousex]
        cmp eax, dword [mousex]
        jne short .1
        mov eax, dword [lastmousey]
        mov ecx, dword [mousey]
        cmp eax, ecx
        jne short .1
        xor eax, ecx
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        mov eax, dword [mousex]
        mov dword [lastmousex], eax
        mov eax, dword [mousey]
        mov dword [lastmousey], eax
        mov dword [esi], 1
        cmp dword [lastmousebtns], byte 0
        je short .2
        cmp dword [mousebtns], byte 0
        jne short .2
        mov eax, 2
        jmp short .3
.2:
        xor eax, eax
.3:
        cmp dword [mousebtns], byte 0
        setne dl
        and edx, 0FFh
        add eax, edx
        mov byte [byte esi+04h], al
        mov eax, dword [mousex]
        mov dword [byte esi+05h], eax
        mov eax, dword [mousey]
        mov dword [byte esi+09h], eax
        mov eax, dword [mousebtns]
        mov dword [lastmousebtns], eax
        mov eax, 1
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; PollJoystickEvent                                               6BCDA  95 PC
; Event type 2 from the joystick bits (directions 0Fh, buttons 30h, release
; flagged)
;-----------------------------------------------------------------------------
PollJoystickEvent:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov esi, eax
        cmp byte [byte_D416A], 0
        je near .5
        call sub_B30F4
        call ReadJoyRaw
        test byte [ctlavailmask], 2
        jne short .1
        sar eax, 8
.1:
        and eax, 0FFh
        jne short .2
        cmp dword [joybtnheld], byte 0
        je short .x
.2:
        mov dword [esi], 2
        test al, 30h
        setne dl
        and edx, 0FFh
        mov byte [byte esi+04h], dl
        cmp dword [joybtnheld], byte 0
        je short .3
        test al, 30h
        jne short .3
        mov dh, dl
        add dh, 2
        mov byte [byte esi+04h], dh
        xor edi, edi
        mov dword [joybtnheld], edi
        jmp short .4
.3:
        test al, 30h
        je short .4
        mov dword [joybtnheld], 1
.4:
        and al, 0Fh
        mov byte [byte esi+05h], al
        mov eax, 1
        jmp short .x
.5:
        xor eax, eax
.x:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; PollKeyboardEvent                                               6BD69  95 PC
; Event type 3 from arrows / numpad (direction bits), Space, Esc, Enter (with
; release) and any key
;-----------------------------------------------------------------------------
PollKeyboardEvent:
        push ebx
        push ecx
        push edx
        push esi
        mov esi, eax
        mov dword [eax], 3
        mov byte [byte eax+05h], 0
        mov byte [byte eax+04h], 0
        push byte 1Dh
        call KeyDown
        add esp, byte 4
        push byte 47h
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .1
        or byte [byte esi+05h], 9
.1:
        push byte 49h
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .2
        or byte [byte esi+05h], 5
.2:
        push byte 4Fh
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .3
        or byte [byte esi+05h], 0Ah
.3:
        push byte 51h
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .4
        or byte [byte esi+05h], 6
.4:
        push byte 48h
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .5
        or byte [byte esi+05h], 1
.5:
        push byte 4Dh
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .6
        or byte [byte esi+05h], 4
.6:
        push byte 50h
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .7
        or byte [byte esi+05h], 2
.7:
        push byte 4Bh
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .8
        or byte [byte esi+05h], 8
.8:
        push byte 39h
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .9
        or byte [byte esi+04h], 8
.9:
        push byte 1
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .10
        or byte [byte esi+04h], 4
.10:
        push byte 1Ch
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .11
        or byte [byte esi+04h], 1
        mov dword [enterheld], 1
        jmp short .12
.11:
        cmp dword [enterheld], byte 0
        je short .12
        or byte [byte esi+04h], 2
        mov dword [enterheld], eax
.12:
        call PollKey
        test eax, eax
        je short .13
        or byte [byte esi+04h], 20h
.13:
        cmp byte [byte esi+04h], 0
        jne short .14
        cmp byte [byte esi+05h], 0
        je short .15
.14:
        mov eax, 1
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.15:
        xor eax, eax
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
