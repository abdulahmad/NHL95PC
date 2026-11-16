; Mode settings dialog (PC only).
bits 32
%include "hockey.inc"
section s_7B39C progbits alloc exec nowrite align=1
extern __CHK, acptspr, AllocMemBlock, awtmflags, awtmpde, cddriveptr, chkoffspr, chkonspr
extern ClearInputQueue, CrowdNoiseOff, CrowdNoiseReset, dlggreys, DrawArt, DrawSettingsHeading, fdlg_cancel, fileoncd
extern FindShape, FreeMemBlock, gamemode, gameopts, GetInputEvent, GrabBlock, hmtmflags, hmtmpde
extern lcblink, lcboxon, LoadBank, LoadSettingsShapes, MakePath, modesetrects, MouseRead, musichandle
extern musicon, musicslot, pointerspr, PrintString, ptrupdatefn, PutBlock, scpflags2, setbits
extern settingsfile, SndQuery, songdata, sounddev, str_BKGD2, str_Dbox3, str_DigitizedSpeech2, str_Music2
extern str_Pointer16, str_Setting4, str_Setting7, str_Sound2, sub_8F963, sub_8F96E, sub_8F979, sub_8F984
extern sub_8FB8E, sub_8FCDF, sub_91284, SetScreenTarget, TextSetColors, VgaSetPalette, WriteCurModeState
global SettingsStub, MenuModeSettings, ModeSettings_epilogue, DrawModeSetDlg, ModeOptsToBits, ModeSetHitTest, DrawModeSetChecks, ModeSetViewLoop
global ModeSetEditLoop
;-----------------------------------------------------------------------------
; SettingsStub                                                    7B39C  95 PC
; Empty __CHK/ret, unreferenced
;-----------------------------------------------------------------------------
; C: src/pc/mode_settings/SettingsStub.c
%ifdef CBUILD
%include "c/pc/mode_settings/SettingsStub.inc"
%else
SettingsStub:
        push dword 4
        call __CHK
        ret
%endif ; C
;-----------------------------------------------------------------------------
; MenuModeSettings                             7B3A7  95 PC, medium confidence
; Menu action "xxxxxxxxxxx Settings ..." (mode name patched); gamemode 2 ->
; view only
;-----------------------------------------------------------------------------
; C: src/pc/mode_settings/MenuModeSettings.c
%ifdef CBUILD
%include "c/pc/mode_settings/MenuModeSettings.inc"
%else
MenuModeSettings:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        call SetScreenTarget
        call LoadSettingsShapes
        push byte 20h
        push dword 0E935h
        push str_BKGD2
        call AllocMemBlock
        add esp, byte 0Ch
        mov ebp, eax
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov word [byte eax+04h], 0D6h
        mov word [byte eax+06h], 101h
        push byte 13h
        push byte 0Ah
        push eax
        call GrabBlock
        add esp, byte 0Ch
        call DrawModeSetDlg
        call ModeOptsToBits
        cmp dword [gamemode], byte 2
        jne short .1
        call ModeSetViewLoop
        jmp short .2
.1:
        call ModeSetEditLoop
.2:
        push byte 13h
        push byte 0Ah
        push ebp
        call PutBlock
        add esp, byte 0Ch
        test byte [gameopts], 4
        jne short .7
        xor edx, edx
        mov word [lcblink+2], dx
        mov word [lcblink], dx
        mov word [lcboxon+2], dx
        mov word [lcboxon], dx
        xor eax, eax
        jmp short .4
.3:
        movsx edx, ax
        shl edx, 7
        and byte [dword edx+scpflags2], 0F7h
        inc eax
.4:
        cmp ax, 0Ch
        jl short MenuModeSettings.3
        and byte [hmtmflags], 0FDh
        and byte [awtmflags], 0FDh
        xor eax, eax
        mov edi, 1000h
        jmp short .6
.5:
        movsx edx, ax
        mov word [nosplit edx*2+awtmpde], di
        mov word [nosplit edx*2+hmtmpde], di
        inc eax
.6:
        cmp ax, 1Ch
        jl short MenuModeSettings.5
.7:
        test byte [gameopts], 40h
        je short .8
        call sub_8F979
        jmp short .9
.8:
        call sub_8F984
.9:
        test byte [gameopts], 80h
        je short .10
        call sub_8F963
        jmp short .11
.10:
        call sub_8F96E
.11:
        push ebp
        call FreeMemBlock
        add esp, byte 4
        mov ebx, dword [settingsfile]
        push ebx
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov dword [settingsfile], ecx
        xor eax, eax
;-----------------------------------------------------------------------------
; ModeSettings_epilogue                                           7B4E5  95 PC
; Unreferenced pop/ret epilogue
;-----------------------------------------------------------------------------
ModeSettings_epilogue:
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawModeSetDlg                               7B4EC  95 PC, medium confidence
; Setting7 (gamemode 2) or setting4 dialog
;-----------------------------------------------------------------------------
; C: src/pc/mode_settings/DrawModeSetDlg.c
%ifdef CBUILD
%include "c/pc/mode_settings/DrawModeSetDlg.inc"
%else
DrawModeSetDlg:
        push dword 40h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        sub esp, byte 20h
        cmp dword [gamemode], byte 2
        jne short .2
        xor ecx, ecx
        mov ebx, str_Setting7
        cmp byte [fileoncd+0177h], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .4
.1:
        xor edx, edx
        jmp short .4
.2:
        xor ecx, ecx
        mov ebx, str_Setting4
        cmp byte [fileoncd+0174h], 1
        jne short .3
        mov edx, dword [cddriveptr]
        jmp short .4
.3:
        xor edx, edx
.4:
        mov eax, esp
        call MakePath
        push byte 0
        lea eax, [byte esp+04h]
        push eax
        call LoadBank
        mov esi, eax
        add esp, byte 8
        push byte 13h
        push byte 0Ah
        push str_Dbox3
        push eax
        call FindShape
        add esp, byte 8
        push eax
        call sub_91284
        add esp, byte 0Ch
        push esi
        call FreeMemBlock
        add esp, byte 4
        push dword 0FFh
        push dword 0F8h
        call TextSetColors
        add esp, byte 8
        cmp dword [sounddev], byte 10h
        jne short .5
        push dword 0AAh
        push byte 60h
        push str_Music2
        call PrintString
        add esp, byte 0Ch
        push dword 0C0h
        push byte 60h
        push str_Sound2
        call PrintString
        add esp, byte 0Ch
.5:
        cmp byte [musicon], 0
        jne short .6
        push dword 0D6h
        push byte 60h
        push str_DigitizedSpeech2
        call PrintString
        add esp, byte 0Ch
.6:
        call SetScreenTarget
        push dword 0FAh
        mov ecx, dword [gamemode]
        mov ebx, 4
        mov edx, 13h
        mov eax, 0Ah
        call DrawSettingsHeading
        add esp, byte 20h
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ModeOptsToBits                               7B604  95 PC, medium confidence
; Gameopts -> setbits (mode settings)
;-----------------------------------------------------------------------------
; C: src/pc/mode_settings/ModeOptsToBits.c
%ifdef CBUILD
%include "c/pc/mode_settings/ModeOptsToBits.inc"
%else
ModeOptsToBits:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        mov eax, dword [gameopts]
        shl eax, 1Eh
        shr eax, 1Fh
        add eax, eax
        mov edx, dword [gameopts]
        and edx, byte 1
        or edx, eax
        mov eax, dword [gameopts]
        shl eax, 1Dh
        shr eax, 1Fh
        shl eax, 2
        or edx, eax
        mov eax, dword [gameopts]
        shl eax, 1Ch
        shr eax, 1Fh
        shl eax, 3
        or edx, eax
        mov eax, dword [gameopts]
        shl eax, 1Bh
        shr eax, 1Fh
        shl eax, 4
        or edx, eax
        mov eax, dword [gameopts]
        shl eax, 1Ah
        shr eax, 1Fh
        shl eax, 5
        or edx, eax
        test byte [sounddev], 10h
        je short .1
        xor eax, eax
        jmp short .2
.1:
        mov eax, dword [gameopts]
        shl eax, 19h
        shr eax, 1Fh
        shl eax, 6
.2:
        or edx, eax
        test byte [sounddev], 10h
        je short .3
        xor eax, eax
        jmp short .4
.3:
        mov eax, dword [gameopts]
        shl eax, 18h
        shr eax, 1Fh
        shl eax, 7
.4:
        or edx, eax
        test byte [sounddev], 22h
        je short .5
        mov eax, dword [gameopts]
        shl eax, 17h
        shr eax, 1Fh
        shl eax, 8
        jmp short .6
.5:
        xor eax, eax
.6:
        or edx, eax
        mov dword [setbits], edx
        call DrawModeSetChecks
        push dword 0FFh
        push dword 0F8h
        call TextSetColors
        add esp, byte 8
        cmp dword [sounddev], byte 10h
        jne short .7
        push dword 0AAh
        push byte 60h
        push str_Music2
        call PrintString
        add esp, byte 0Ch
        push dword 0C0h
        push byte 60h
        push str_Sound2
        call PrintString
        add esp, byte 0Ch
.7:
        cmp byte [musicon], 0
        jne short .8
        push dword 0D6h
        push byte 60h
        push str_DigitizedSpeech2
        call PrintString
        add esp, byte 0Ch
.8:
        call SetScreenTarget
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ModeSetHitTest                               7B734  95 PC, medium confidence
; Hit-test over modesetrects
;-----------------------------------------------------------------------------
; C: src/pc/mode_settings/ModeSetHitTest.c
%ifdef CBUILD
%include "c/pc/mode_settings/ModeSetHitTest.inc"
%else
ModeSetHitTest:
        push dword 0Ch
        call __CHK
        push ecx
        push esi
        mov ecx, eax
        mov esi, edx
        xor edx, edx
        lea ecx, [byte eax-06h]
        sub esi, byte 13h
.1:
        mov eax, edx
        shl eax, 4
        cmp ecx, dword [dword eax+modesetrects]
        jl near .5
        cmp ecx, dword [dword eax+modesetrects+8]
        jg short .5
        cmp esi, dword [dword eax+modesetrects+4]
        jl short .5
        cmp esi, dword [dword eax+modesetrects+0Ch]
        jg short .5
        cmp edx, byte 0Ah
        je short .6
        cmp edx, byte 0Bh
        je short .6
        cmp edx, byte 0Ch
        jl short .2
        cmp edx, byte 0Fh
        jg short .2
        cmp dword [sounddev], byte 10h
        je short .6
.2:
        cmp edx, byte 10h
        je short .3
        cmp edx, byte 11h
        jne short .4
.3:
        cmp byte [musicon], 0
        je short .6
.4:
        mov dword [ebx], edx
        mov edx, 1
        mov eax, edx
        pop esi
        pop ecx
        ret
.5:
        inc edx
        cmp edx, byte 14h
        jl short ModeSetHitTest.1
.6:
        xor edx, edx
        mov eax, edx
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawModeSetChecks                            7B7BE  95 PC, medium confidence
; Checkbox draw over modesetrects
;-----------------------------------------------------------------------------
; C: src/pc/mode_settings/DrawModeSetChecks.c
%ifdef CBUILD
%include "c/pc/mode_settings/DrawModeSetChecks.inc"
%else
DrawModeSetChecks:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push ebp
        sub esp, byte 4
        mov esi, modesetrects
        xor edx, edx
        mov dword [esp], edx
.1:
        mov ebx, dword [esp]
        cmp ebx, byte 5
        jne short .2
        lea ecx, [byte ebx+01h]
        mov dword [esp], ecx
        add esi, byte 20h
.2:
        mov cl, byte [esp]
        mov eax, 1
        shl eax, cl
        test dword [setbits], eax
        je short .3
        mov eax, dword [byte esi+04h]
        add eax, byte 13h
        push eax
        mov eax, dword [esi]
        add eax, byte 0Ah
        push eax
        mov eax, dword [chkonspr]
        push eax
        jmp short .4
.3:
        mov eax, dword [byte esi+04h]
        add eax, byte 13h
        push eax
        mov eax, dword [esi]
        add eax, byte 0Ah
        push eax
        mov ebp, dword [chkoffspr]
        push ebp
.4:
        call PutBlock
        add esp, byte 0Ch
        mov edx, dword [esp]
        inc edx
        mov dword [esp], edx
        add esi, byte 20h
        cmp edx, byte 9
        jl short DrawModeSetChecks.1
        add esp, byte 4
        pop ebp
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ModeSetViewLoop                              7B846  95 PC, medium confidence
; View-only pointer loop
;-----------------------------------------------------------------------------
; C: src/pc/mode_settings/MenuModeSettings.c (ModeSetViewLoop)
%ifdef CBUILD
%include "c/pc/mode_settings/MenuModeSettings.ModeSetViewLoop.inc"
%else
ModeSetViewLoop:
        push dword 3Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 14h
        push dlggreys
        push byte 4
        push dword 0F7h
        call VgaSetPalette
        add esp, byte 0Ch
        lea eax, [byte esp+0Ch]
        push eax
        lea eax, [byte esp+014h]
        push eax
        lea eax, [byte esp+08h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        mov eax, dword [byte esp+010h]
        mov dword [byte esp+08h], eax
        mov eax, dword [byte esp+0Ch]
        mov dword [byte esp+04h], eax
        call SetScreenTarget
        mov eax, dword [pointerspr]
        mov edx, dword [byte eax+02h]
        sar edx, 10h
        mov eax, dword [byte eax+04h]
        sar eax, 10h
        inc eax
        inc edx
        imul eax, edx
        add eax, byte 11h
        push byte 20h
        push eax
        push str_Pointer16
        call AllocMemBlock
        add esp, byte 0Ch
        mov ebp, eax
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov edx, dword [pointerspr]
        mov dx, word [byte edx+04h]
        inc edx
        mov word [byte eax+04h], dx
        mov edx, dword [pointerspr]
        mov dx, word [byte edx+06h]
        inc edx
        mov word [byte eax+06h], dx
        mov edx, dword [byte esp+04h]
        push edx
        mov edx, dword [byte esp+0Ch]
        sub edx, byte 4
        push edx
        push eax
        call GrabBlock
        add esp, byte 0Ch
        mov ebx, dword [byte esp+04h]
        push ebx
        mov eax, dword [byte esp+0Ch]
        sub eax, byte 4
        push eax
        mov ecx, dword [pointerspr]
        push ecx
        call DrawArt
        add esp, byte 0Ch
        call ClearInputQueue
.1:
        xor esi, esi
        mov dword [esp], esi
.2:
        call GetInputEvent
        test eax, eax
        je short .3
        lea ebx, [byte esp+04h]
        lea edx, [byte esp+08h]
        call dword [ptrupdatefn]
        mov dword [esp], eax
        test al, 6
        je short ModeSetViewLoop.2
.3:
        cmp dword [esp], byte 0
        jne short .5
        mov eax, dword [byte esp+08h]
        cmp eax, dword [byte esp+010h]
        jne short .4
        mov eax, dword [byte esp+04h]
        cmp eax, dword [byte esp+0Ch]
        je short ModeSetViewLoop.1
.4:
        mov ecx, dword [byte esp+0Ch]
        push ecx
        mov eax, dword [byte esp+014h]
        sub eax, byte 4
        push eax
        push ebp
        call PutBlock
        add esp, byte 0Ch
        mov esi, dword [byte esp+04h]
        push esi
        mov eax, dword [byte esp+0Ch]
        sub eax, byte 4
        push eax
        push ebp
        call GrabBlock
        add esp, byte 0Ch
        mov edi, dword [byte esp+04h]
        push edi
        mov eax, dword [byte esp+0Ch]
        sub eax, byte 4
        push eax
        mov eax, dword [pointerspr]
        push eax
        call DrawArt
        add esp, byte 0Ch
        mov eax, dword [byte esp+08h]
        mov dword [byte esp+010h], eax
        mov eax, dword [byte esp+04h]
        mov dword [byte esp+0Ch], eax
        jmp near ModeSetViewLoop.1
.5:
        mov edx, dword [byte esp+0Ch]
        push edx
        mov eax, dword [byte esp+014h]
        sub eax, byte 4
        push eax
        push ebp
        call PutBlock
        add esp, byte 0Ch
        push ebp
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        add esp, byte 14h
        jmp near ModeSettings_epilogue
%endif ; C
;-----------------------------------------------------------------------------
; ModeSetEditLoop                              7B9E8  95 PC, medium confidence
; Editing pointer loop
;-----------------------------------------------------------------------------
; C: src/pc/mode_settings/MenuModeSettings.c (ModeSetEditLoop)
%ifdef CBUILD
%include "c/pc/mode_settings/MenuModeSettings.ModeSetEditLoop.inc"
%else
ModeSetEditLoop:
        push dword 44h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 1Ch
        push dlggreys
        push byte 4
        push dword 0F7h
        call VgaSetPalette
        add esp, byte 0Ch
        lea eax, [byte esp+010h]
        push eax
        lea eax, [byte esp+018h]
        push eax
        lea eax, [byte esp+0Ch]
        push eax
        call MouseRead
        add esp, byte 0Ch
        mov eax, dword [byte esp+014h]
        mov dword [byte esp+0Ch], eax
        mov eax, dword [byte esp+010h]
        mov dword [byte esp+08h], eax
        call SetScreenTarget
        mov eax, dword [gameopts]
        shl eax, 19h
        shr eax, 1Fh
        mov dword [byte esp+018h], eax
        mov eax, dword [pointerspr]
        mov edx, dword [byte eax+02h]
        sar edx, 10h
        mov eax, dword [byte eax+04h]
        sar eax, 10h
        inc eax
        inc edx
        imul eax, edx
        add eax, byte 11h
        push byte 20h
        push eax
        push str_Pointer16
        call AllocMemBlock
        add esp, byte 0Ch
        mov ebp, eax
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov edx, dword [pointerspr]
        mov dx, word [byte edx+04h]
        inc edx
        mov word [byte eax+04h], dx
        mov edx, dword [pointerspr]
        mov dx, word [byte edx+06h]
        inc edx
        mov word [byte eax+06h], dx
        mov edx, dword [byte esp+08h]
        push edx
        mov edx, dword [byte esp+010h]
        sub edx, byte 4
        push edx
        push eax
        call GrabBlock
        add esp, byte 0Ch
        mov ebx, dword [byte esp+08h]
        push ebx
        mov eax, dword [byte esp+010h]
        sub eax, byte 4
        push eax
        mov ecx, dword [pointerspr]
        push ecx
        call DrawArt
        add esp, byte 0Ch
        call ClearInputQueue
.1:
        xor esi, esi
        mov dword [byte esp+04h], esi
.2:
        call GetInputEvent
        test eax, eax
        je short .3
        lea ebx, [byte esp+08h]
        lea edx, [byte esp+0Ch]
        call dword [ptrupdatefn]
        mov dword [byte esp+04h], eax
        test al, 6
        je short ModeSetEditLoop.2
.3:
        test byte [byte esp+04h], 6
        jne short .7
        mov eax, dword [byte esp+0Ch]
        cmp eax, dword [byte esp+014h]
        jne short .4
        mov eax, dword [byte esp+08h]
        cmp eax, dword [byte esp+010h]
        je short ModeSetEditLoop.1
.4:
        mov edi, dword [byte esp+010h]
        push edi
        mov eax, dword [byte esp+018h]
        sub eax, byte 4
.5:
        push eax
        push ebp
        call PutBlock
        add esp, byte 0Ch
.6:
        mov eax, dword [byte esp+08h]
        push eax
        mov eax, dword [byte esp+010h]
        sub eax, byte 4
        push eax
        push ebp
        call GrabBlock
        add esp, byte 0Ch
        mov edx, dword [byte esp+08h]
        push edx
        mov eax, dword [byte esp+010h]
        sub eax, byte 4
        push eax
        mov ebx, dword [pointerspr]
        push ebx
        call DrawArt
        add esp, byte 0Ch
        mov eax, dword [byte esp+0Ch]
        mov dword [byte esp+014h], eax
        mov eax, dword [byte esp+08h]
        mov dword [byte esp+010h], eax
        jmp near ModeSetEditLoop.1
.7:
        mov eax, dword [byte esp+014h]
        sub eax, byte 4
        mov dl, byte [byte esp+04h]
        test dl, 2
        je near .27
        mov esi, dword [byte esp+010h]
        push esi
        push eax
        push ebp
        call PutBlock
        add esp, byte 0Ch
        mov ebx, esp
        mov edx, dword [byte esp+08h]
        mov eax, dword [byte esp+0Ch]
        call ModeSetHitTest
        test eax, eax
        je short ModeSetEditLoop.6
        mov edi, dword [esp]
        cmp edi, byte 12h
        jge near .12
        mov ebx, 2
        mov eax, edi
        mov edx, edi
        sar edx, 1Fh
        idiv ebx
        test edx, edx
        je short .9
        cmp byte [musicon], 0
        jne short .8
        cmp edi, byte 11h
        je near .11
.8:
        mov eax, dword [esp]
        mov edx, eax
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov dword [esp], eax
        mov cl, byte [esp]
        mov eax, 1
        shl eax, cl
        not eax
        and dword [setbits], eax
        jmp near .11
.9:
        cmp byte [musicon], 0
        jne short .10
        cmp edi, byte 10h
        je near .11
.10:
        mov eax, dword [esp]
        mov edx, eax
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov dword [esp], eax
        mov cl, byte [esp]
        mov eax, 1
        shl eax, cl
        or dword [setbits], eax
.11:
        call DrawModeSetChecks
        jmp near ModeSetEditLoop.6
.12:
        jne near .24
        push dword 0F8h
        push byte 37h
        mov ebx, dword [acptspr]
        push ebx
        call PutBlock
        add esp, byte 0Ch
        mov bl, byte [setbits]
        test bl, 1
        setne al
        and eax, byte 1
        and byte [gameopts], 0FEh
        or dword [gameopts], eax
        mov bh, bl
        test bl, 2
        setne al
        and eax, byte 1
        and byte [gameopts], 0FDh
        add eax, eax
        or dword [gameopts], eax
        test bl, 4
        setne al
        and eax, byte 1
        and byte [gameopts], 0FBh
        shl eax, 2
        or dword [gameopts], eax
        test bl, 8
        setne al
        and eax, byte 1
        and byte [gameopts], 0F7h
        shl eax, 3
        or dword [gameopts], eax
        test bh, 10h
        setne al
        and eax, byte 1
        and byte [gameopts], 0EFh
        shl eax, 4
        or dword [gameopts], eax
        test byte [setbits], 20h
        setne al
        and eax, byte 1
        and byte [gameopts], 0DFh
        shl eax, 5
        or dword [gameopts], eax
        cmp dword [sounddev], byte 10h
        je short .13
        mov dh, byte [setbits]
        test dh, 40h
        setne al
        and eax, byte 1
        and byte [gameopts], 0BFh
        shl eax, 6
        or dword [gameopts], eax
        test dh, 80h
        setne al
        and eax, byte 1
        and byte [gameopts], 7Fh
        shl eax, 7
        or dword [gameopts], eax
.13:
        test byte [setbits], 80h
        setne al
        and eax, 0FFh
        mov edx, eax
        test byte [gameopts], 80h
        je short .14
        test eax, eax
        jne short .14
        call CrowdNoiseOff
.14:
        mov bh, byte [gameopts]
        test bh, 80h
        jne short .15
        test edx, edx
        je short .15
        and edx, byte 1
        mov ch, bh
        and ch, 7Fh
        mov byte [gameopts], ch
        shl edx, 7
        or dword [gameopts], edx
        call CrowdNoiseReset
        jmp short .16
.15:
        mov eax, edx
        and eax, byte 1
        and byte [gameopts], 7Fh
        shl eax, 7
        or dword [gameopts], eax
.16:
        cmp byte [musicon], 0
        je short .17
        test byte [setbits+1], 1
        setne al
        and eax, byte 1
        and byte [gameopts+1], 0FEh
        shl eax, 8
        or dword [gameopts], eax
.17:
        test byte [gameopts], 40h
        je short .19
        cmp byte [musicon], 0
        je short .18
        cmp dword [songdata], byte 0
        je short .18
        cmp dword [byte esp+018h], byte 0
        jne short .18
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short .18
        mov edx, dword [musichandle]
        mov eax, dword [songdata]
        mov ecx, 7Fh
        mov ebx, 3
        call sub_8FB8E
.18:
        call sub_8F979
        jmp short .21
.19:
        cmp byte [musicon], 0
        je short .20
        cmp dword [songdata], byte 0
        je short .20
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        jne short .20
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 3
        call sub_8FCDF
.20:
        call sub_8F984
.21:
        test byte [gameopts], 80h
        je short .22
        call sub_8F963
        jmp short .23
.22:
        call sub_8F96E
.23:
        call WriteCurModeState
        jmp short .26
.24:
        push dword 0F8h
        push dword 81h
        mov edx, dword [fdlg_cancel]
        push edx
.25:
        call PutBlock
        add esp, byte 0Ch
.26:
        push ebp
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        add esp, byte 1Ch
        jmp near ModeSettings_epilogue
.27:
        test dl, 4
        je short .28
        mov ecx, dword [byte esp+010h]
        push ecx
        push eax
        push ebp
        jmp short ModeSetEditLoop.25
.28:
        mov edi, dword [byte esp+010h]
        push edi
        jmp near ModeSetEditLoop.5
%endif ; C
