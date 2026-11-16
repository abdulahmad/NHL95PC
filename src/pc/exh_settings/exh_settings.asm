; Exhibition settings dialog (PC only).
bits 32
%include "hockey.inc"
section s_7BEBB progbits alloc exec nowrite align=1
extern __CHK, acptspr, AllocMemBlock, cddriveptr, chkoffspr, chkonspr, ClearInputQueue, dlggreys
extern DrawArt, DrawSettingsHeading, exhsetrects, fdlg_cancel, fileoncd, FindShape, FreeMemBlock, gamemode
extern gameopts, GetInputEvent, GrabBlock, LoadBank, LoadSettingsShapes, MakePath, MouseRead, musichandle
extern musicon, musicslot, pl05spr, pl10spr, pl20spr, pointerspr, PrintString, ptrupdatefn
extern PutBlock, setbits, settingsfile, SndQuery, songdata, sounddev, str_BKGD3, str_Dbox4
extern str_DigitizedSpeech3, str_Music3, str_Pointer17, str_Setting6, str_Sound3, EnableMidiSfx, DisableMidiSfx, EnableMidiMusic
extern DisableMidiMusic, PlayDigiBlockLoop, SetDigiChannelVolume, DrawArtKeyFF, DrawShapeClippedKeyed, SetScreenTarget, TextSetColors, VgaSetPalette
extern WriteCurModeState
global MenuExhibitionSettings, ExhSettings_ret, ExhOptsToBits, DrawExhSetChecks, DrawExhSetDlg, ExhSetHitTest, ExhSetEditLoop
;-----------------------------------------------------------------------------
; MenuExhibitionSettings                       7BEBB  95 PC, medium confidence
; Menu action "Exhibition Settings ..."
;-----------------------------------------------------------------------------
; C: src/pc/exh_settings/MenuExhibitionSettings.c
%ifdef CBUILD
%include "c/pc/exh_settings/MenuExhibitionSettings.inc"
%else
MenuExhibitionSettings:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        call LoadSettingsShapes
        push byte 20h
        push dword 10AA5h
        push str_BKGD3
        call AllocMemBlock
        mov ebp, eax
        add esp, byte 0Ch
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov word [byte eax+04h], 0D6h
        mov word [byte eax+06h], 129h
        push byte 13h
        push byte 0Ah
        push eax
        call GrabBlock
        add esp, byte 0Ch
        call SetScreenTarget
        call DrawExhSetDlg
        call ExhOptsToBits
        call ExhSetEditLoop
        push byte 13h
        push byte 0Ah
        push ebp
        call PutBlock
        add esp, byte 0Ch
        push ebp
        call FreeMemBlock
        add esp, byte 4
        mov edx, dword [settingsfile]
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor ebx, ebx
        mov dword [settingsfile], ebx
        xor eax, eax
;-----------------------------------------------------------------------------
; ExhSettings_ret                                                 7BF4F  95 PC
; Lone ret, unreferenced
;-----------------------------------------------------------------------------
ExhSettings_ret:
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ExhOptsToBits                                7BF56  95 PC, medium confidence
; Gameopts -> setbits (exhibition)
;-----------------------------------------------------------------------------
; C: src/pc/exh_settings/MenuExhibitionSettings.c (ExhOptsToBits)
%ifdef CBUILD
%include "c/pc/exh_settings/MenuExhibitionSettings.ExhOptsToBits.inc"
%else
ExhOptsToBits:
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
        mov eax, dword [gameopts]
        shl eax, 14h
        shr eax, 1Eh
        cmp eax, byte 1
        jb short .7
        jbe short .9
        cmp eax, byte 2
        je short .8
        jmp short .11
.7:
        test eax, eax
        je short .10
        jmp short .11
.8:
        or byte [setbits+1], 2
        jmp short .11
.9:
        or byte [setbits+1], 4
        jmp short .11
.10:
        or byte [setbits+1], 8
.11:
        call DrawExhSetChecks
        push dword 0FFh
        push dword 0F8h
        call TextSetColors
        add esp, byte 8
        cmp byte [musicon], 0
        jne short .12
        push dword 0D6h
        push byte 60h
        push str_DigitizedSpeech3
        call PrintString
        add esp, byte 0Ch
.12:
        cmp dword [sounddev], byte 10h
        jne short .x
        push dword 0AAh
        push byte 60h
        push str_Music3
        call PrintString
        add esp, byte 0Ch
        push dword 0C0h
        push byte 60h
        push str_Sound3
        call PrintString
        add esp, byte 0Ch
.x:
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawExhSetChecks                             7C0B9  95 PC, medium confidence
; Checkbox draw over exhsetrects
;-----------------------------------------------------------------------------
; C: src/pc/exh_settings/MenuExhibitionSettings.c (DrawExhSetChecks)
%ifdef CBUILD
%include "c/pc/exh_settings/MenuExhibitionSettings.DrawExhSetChecks.inc"
%else
DrawExhSetChecks:
        push dword 2Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov esi, exhsetrects
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
        jl short DrawExhSetChecks.1
        mov eax, dword [setbits]
        and eax, 0E00h
        cmp eax, 400h
        jb short .5
        jbe short .6
        cmp eax, 800h
        je short .7
        jmp short .9
.5:
        cmp eax, 200h
        jne short .9
        mov eax, dword [byte esi+04h]
        add eax, byte 13h
        push eax
        mov eax, dword [esi]
        add eax, byte 0Ah
        push eax
        mov edi, dword [pl20spr]
        push edi
        jmp short .8
.6:
        mov eax, dword [byte esi+04h]
        add eax, byte 13h
        push eax
        mov eax, dword [esi]
        add eax, byte 0Ah
        push eax
        mov esi, dword [pl10spr]
        push esi
        jmp short .8
.7:
        mov eax, dword [byte esi+04h]
        add eax, byte 13h
        push eax
        mov eax, dword [esi]
        add eax, byte 0Ah
        push eax
        mov ecx, dword [pl05spr]
        push ecx
.8:
        call PutBlock
        add esp, byte 0Ch
.9:
        add esp, byte 4
        jmp near ExhSettings_ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawExhSetDlg                                7C1AC  95 PC, medium confidence
; Setting6 + dbox dialog
;-----------------------------------------------------------------------------
; C: src/pc/exh_settings/DrawExhSetDlg.c
%ifdef CBUILD
%include "c/pc/exh_settings/DrawExhSetDlg.inc"
%else
DrawExhSetDlg:
        push dword 40h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        sub esp, byte 20h
        call SetScreenTarget
        xor ecx, ecx
        mov ebx, str_Setting6
        cmp byte [fileoncd+0176h], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
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
        push str_Dbox4
        push eax
        call FindShape
        add esp, byte 8
        push eax
        call DrawArtKeyFF
        add esp, byte 0Ch
        push esi
        call FreeMemBlock
        add esp, byte 4
        cmp dword [sounddev], byte 10h
        jne short .3
        push dword 0AAh
        push byte 60h
        push str_Music3
        call PrintString
        add esp, byte 0Ch
        push dword 0C0h
        push byte 60h
        push str_Sound3
        call PrintString
        add esp, byte 0Ch
.3:
        cmp byte [musicon], 0
        jne short .4
        push dword 0D6h
        push byte 60h
        push str_DigitizedSpeech3
        call PrintString
        add esp, byte 0Ch
.4:
        push dword 0FAh
        mov ecx, dword [gamemode]
        mov ebx, 6
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
; ExhSetHitTest                                7C28D  95 PC, medium confidence
; Hit-test over exhsetrects
;-----------------------------------------------------------------------------
; C: src/pc/exh_settings/ExhSetHitTest.c
%ifdef CBUILD
%include "c/pc/exh_settings/ExhSetHitTest.inc"
%else
ExhSetHitTest:
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
        cmp ecx, dword [dword eax+exhsetrects]
        jl near .5
        cmp ecx, dword [dword eax+exhsetrects+8]
        jg short .5
        cmp esi, dword [dword eax+exhsetrects+4]
        jl short .5
        cmp esi, dword [dword eax+exhsetrects+0Ch]
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
        cmp edx, byte 17h
        jl short ExhSetHitTest.1
.6:
        xor edx, edx
        mov eax, edx
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ExhSetEditLoop                               7C317  95 PC, medium confidence
; Editing pointer loop
;-----------------------------------------------------------------------------
; C: src/pc/exh_settings/MenuExhibitionSettings.c (ExhSetEditLoop)
%ifdef CBUILD
%include "c/pc/exh_settings/MenuExhibitionSettings.ExhSetEditLoop.inc"
%else
ExhSetEditLoop:
        push dword 40h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 18h
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
        push str_Pointer17
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
        mov esi, dword [gameopts]
        shl esi, 19h
        shr esi, 1Fh
        call ClearInputQueue
.1:
        xor edi, edi
        mov dword [byte esp+04h], edi
.2:
        call GetInputEvent
        test eax, eax
        je short .3
        lea ebx, [byte esp+08h]
        lea edx, [byte esp+0Ch]
        call dword [ptrupdatefn]
        mov dword [byte esp+04h], eax
        test al, 6
        je short ExhSetEditLoop.2
.3:
        test byte [byte esp+04h], 6
        jne short .6
        mov eax, dword [byte esp+0Ch]
        cmp eax, dword [byte esp+014h]
        jne short .4
        mov eax, dword [byte esp+08h]
        cmp eax, dword [byte esp+010h]
        je short ExhSetEditLoop.1
.4:
        mov eax, dword [byte esp+010h]
        push eax
        mov eax, dword [byte esp+018h]
        sub eax, byte 4
        push eax
        push ebp
        call PutBlock
        add esp, byte 0Ch
        mov edx, dword [byte esp+08h]
        push edx
        mov eax, dword [byte esp+010h]
        sub eax, byte 4
        push eax
        push ebp
        call GrabBlock
        add esp, byte 0Ch
        mov ebx, dword [byte esp+08h]
        push ebx
        mov eax, dword [byte esp+010h]
        sub eax, byte 4
        push eax
        mov ecx, dword [pointerspr]
        push ecx
.5:
        call DrawArt
        add esp, byte 0Ch
        mov eax, dword [byte esp+0Ch]
        mov dword [byte esp+014h], eax
        mov eax, dword [byte esp+08h]
        mov dword [byte esp+010h], eax
        jmp near ExhSetEditLoop.1
.6:
        mov eax, dword [byte esp+014h]
        sub eax, byte 4
        mov dl, byte [byte esp+04h]
        test dl, 2
        je near .29
        mov ebx, dword [byte esp+010h]
        push ebx
        push eax
        push ebp
        call PutBlock
        add esp, byte 0Ch
        mov ebx, esp
        mov edx, dword [byte esp+08h]
        mov eax, dword [byte esp+0Ch]
        call ExhSetHitTest
        test eax, eax
        je near .28
        mov ecx, dword [esp]
        cmp ecx, byte 12h
        jge near .10
        mov ebx, 2
        mov eax, ecx
        mov edx, ecx
        sar edx, 1Fh
        idiv ebx
        test edx, edx
        je short .8
        cmp byte [musicon], 0
        jne short .7
        cmp ecx, byte 11h
        je near .27
.7:
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
        jmp near .27
.8:
        cmp byte [musicon], 0
        jne short .9
        cmp dword [esp], byte 10h
        je near .27
.9:
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
        jmp near .27
.10:
        cmp ecx, byte 15h
        jl near .26
        jne near .23
        push dword 120h
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
        mov cl, bl
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
        mov dh, bl
        test bl, 8
        setne al
        and eax, byte 1
        and byte [gameopts], 0F7h
        shl eax, 3
        or dword [gameopts], eax
        test cl, 10h
        setne al
        and eax, byte 1
        and byte [gameopts], 0EFh
        shl eax, 4
        or dword [gameopts], eax
        mov ch, dh
        test ch, 20h
        setne al
        and eax, byte 1
        and byte [gameopts], 0DFh
        shl eax, 5
        or dword [gameopts], eax
        cmp dword [sounddev], byte 10h
        je short .11
        test ch, 40h
        setne al
        and eax, byte 1
        and byte [gameopts], 0BFh
        shl eax, 6
        or dword [gameopts], eax
        test ch, 80h
        setne al
        and eax, byte 1
        and byte [gameopts], 7Fh
        shl eax, 7
        or dword [gameopts], eax
.11:
        test byte [sounddev], 22h
        je short .12
        test byte [setbits+1], 1
        setne al
        and eax, byte 1
        and byte [gameopts+1], 0FEh
        shl eax, 8
        or dword [gameopts], eax
.12:
        mov edx, dword [setbits]
        and edx, 0E00h
        mov eax, dword [gameopts]
        and ah, 0F3h
        cmp edx, 400h
        jb short .13
        jbe short .14
        cmp edx, 800h
        je short .15
        jmp short .16
.13:
        cmp edx, 200h
        jne short .16
        mov dword [gameopts], eax
        or ah, 8
        jmp short .15
.14:
        mov dword [gameopts], eax
        or ah, 4
.15:
        mov dword [gameopts], eax
.16:
        test byte [gameopts], 40h
        je short .18
        cmp byte [musicon], 0
        je short .17
        cmp dword [songdata], byte 0
        je short .17
        test esi, esi
        jne short .17
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short .17
        mov edx, dword [musichandle]
        mov eax, dword [songdata]
        mov ecx, 7Fh
        mov ebx, 3
        call PlayDigiBlockLoop
.17:
        call EnableMidiMusic
        jmp short .20
.18:
        cmp byte [musicon], 0
        je short .19
        cmp dword [songdata], byte 0
        je short .19
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        jne short .19
        mov eax, dword [musichandle]
        mov ebx, 28h
        mov edx, 3
        call SetDigiChannelVolume
.19:
        call DisableMidiMusic
.20:
        test byte [gameopts], 80h
        je short .21
        call EnableMidiSfx
        jmp short .22
.21:
        call DisableMidiSfx
.22:
        call WriteCurModeState
        jmp short .25
.23:
        push dword 120h
        push dword 81h
        mov edx, dword [fdlg_cancel]
        push edx
.24:
        call PutBlock
        add esp, byte 0Ch
.25:
        push ebp
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        add esp, byte 18h
        jmp near ExhSettings_ret
.26:
        lea eax, [byte ecx-09h]
        mov dword [esp], eax
        mov cl, byte [esp]
        mov edx, 1
        shl edx, cl
        mov eax, dword [setbits]
        and eax, 0F1FFh
        or eax, edx
        mov dword [setbits], eax
.27:
        call DrawExhSetChecks
.28:
        mov eax, dword [byte esp+08h]
        push eax
        mov eax, dword [byte esp+010h]
        sub eax, byte 4
        push eax
        push ebp
        call DrawShapeClippedKeyed
        add esp, byte 0Ch
        mov edx, dword [byte esp+08h]
        push edx
        mov eax, dword [byte esp+010h]
        sub eax, byte 4
        push eax
        mov ebx, dword [pointerspr]
        push ebx
        jmp near ExhSetEditLoop.5
.29:
        test dl, 4
        je short .30
        mov edx, dword [byte esp+010h]
        push edx
        push eax
        push ebp
        jmp short ExhSetEditLoop.24
.30:
        mov edx, dword [byte esp+010h]
        push edx
        push eax
        push ebp
        call PutBlock
        add esp, byte 0Ch
        mov ebx, dword [byte esp+08h]
        push ebx
        mov eax, dword [byte esp+010h]
        sub eax, byte 4
        push eax
        push ebp
        call GrabBlock
        add esp, byte 0Ch
        mov ecx, dword [byte esp+08h]
        push ecx
        mov eax, dword [byte esp+010h]
        sub eax, byte 4
        push eax
        mov edi, dword [pointerspr]
        push edi
        jmp near ExhSetEditLoop.5
%endif ; C
