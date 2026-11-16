; Controls dialogs: who plays which team, for exhibition, league, playoffs and in game (PC only).
bits 32
%include "hockey.inc"
section s_7C852 progbits alloc exec nowrite align=1
extern __CHK, AllocMemBlock, c1playernum, c2playernum, cddriveptr, ClearInputQueue, cont1team, cont2team
extern ctl1dev, ctl1side, ctl1team, ctl2dev, ctl2side, ctl2team, ctlavailmask, ctlboxrect1
extern ctlboxrect2, ctldlgalt, ctldlgrects, DrawArt, DrawArtMasked, dword_ED364, fileoncd, FillRect
extern FindShape, FreeMemBlock, gameclock, gamemode, GetInputEvent, gmode, goaliemenuflags, goaliemenuflags_e02
extern GrabBlock, gsp, hmscore, hmtmap, hmtmflags, hmtmline, hmtmstruct, HomeTeam
extern lcblink, lcboxon, LoadBank, MakePath, MouseRead, pad1dev, pointerspr, PrintString
extern ptrupdatefn, puckasslist, puckc, puckstruct, pucktemp1, puckvx, puckvy, puckx
extern pucky, PutBlock, restorepl, samesideflag, scpflags2, setbits, SetColorRemap, setpersonel
extern SetSideControls, SortCords, str_BKGD4, str_Dbox5, str_JoystickOne, str_JoystickTwo, str_OneS, str_PlayerImg
extern str_Pointer18, str_TheKeyboard, str_TheMouse, str_TwoS, SetScreenTarget, FillRectColor, teamcitynames, TextSetColors
extern VisTeam, WriteCurModeState
global DrawCtlBoxOn, DrawCtlBox_common, DrawCtlBoxOff, MenuP1ControlsExh, MenuP2ControlsExh, ControlsDlgExh, ControlsDlg_done, MenuP1ControlsLeague
global MenuP2ControlsLeague, ControlsDlgLeague, MenuP1ControlsInGame, ControlsDlgInGame, MenuP2ControlsInGame, CtlSwapScoreFix, CtlSwapTeamFlag, ReassignCtlPlayer
global ClearCtlBlink, ControlsDlgInGame_side, ControlsDlgInGame_setside, ControlsDlg_ret0C, ControlsDlg_ret, ControlsDlg_ret0, MenuP1ControlsPlayoff, MenuP2ControlsPlayoff
global ControlsDlgPlayoff, DrawControlsDlg, DrawControlsOpts, CtlDlgHitTest, DrawCtlBoxes, ControlsDlgLoop, SetCtlTeams
;-----------------------------------------------------------------------------
; DrawCtlBoxOn                                 7C852  95 PC, medium confidence
; Draws selected box frame (colours by ctldlgalt)
;-----------------------------------------------------------------------------
; C: src/pc/controls_dlg/MenuP1ControlsInGame.c (DrawCtlBoxOn)
%ifdef CBUILD
%include "c/pc/controls_dlg/MenuP1ControlsInGame.DrawCtlBoxOn.inc"
%else
DrawCtlBoxOn:
        push dword 30h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov esi, eax
        cmp dword [ctldlgalt], byte 0
        je short .1
        mov edi, 40h
        mov ebp, 42h
        jmp short .2
.1:
        mov edi, 0FAh
        mov ebp, 0F8h
.2:
        push ebp
        mov eax, dword [byte esi+04h]
        add eax, byte 13h
        push eax
        mov eax, dword [esi]
        add eax, byte 0Ah
        push eax
        mov edx, dword [byte esi+0Ch]
        add edx, byte 12h
        push edx
        push eax
        call FillRectColor
        add esp, byte 14h
        push ebp
        mov ebp, dword [byte esi+04h]
        add ebp, byte 13h
        push ebp
        mov eax, dword [byte esi+08h]
        add eax, byte 9
        push eax
        push ebp
        mov eax, dword [esi]
        add eax, byte 0Ah
        push eax
        call FillRectColor
        add esp, byte 14h
        push edi
        mov eax, dword [byte esi+0Ch]
        add eax, byte 13h
        push eax
        mov ebp, dword [byte esi+08h]
        add ebp, byte 0Ah
        push ebp
        mov eax, dword [byte esi+04h]
        add eax, byte 14h
        push eax
        push ebp
        call FillRectColor
        add esp, byte 14h
        push edi
DrawCtlBox_common:
        mov edi, dword [byte esi+0Ch]
        add edi, byte 13h
        push edi
        mov eax, dword [esi]
        add eax, byte 0Bh
        push eax
        push edi
        mov eax, dword [byte esi+08h]
        add eax, byte 0Ah
        push eax
        call FillRectColor
        add esp, byte 14h
        jmp near ControlsDlg_ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawCtlBoxOff                                7C901  95 PC, medium confidence
; Draws unselected box frame
;-----------------------------------------------------------------------------
; C: src/pc/controls_dlg/MenuP1ControlsInGame.c (DrawCtlBoxOff)
%ifdef CBUILD
%include "c/pc/controls_dlg/MenuP1ControlsInGame.DrawCtlBoxOff.inc"
%else
DrawCtlBoxOff:
        push dword 30h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov esi, eax
        cmp dword [ctldlgalt], byte 0
        je short .1
        mov edi, 40h
        mov ebp, 42h
        jmp short .2
.1:
        mov edi, 0FAh
        mov ebp, 0F8h
.2:
        push edi
        mov eax, dword [byte esi+04h]
        add eax, byte 13h
        push eax
        mov eax, dword [esi]
        add eax, byte 0Ah
        push eax
        mov edx, dword [byte esi+0Ch]
        add edx, byte 12h
        push edx
        push eax
        call FillRectColor
        add esp, byte 14h
        push edi
        mov edi, dword [byte esi+04h]
        add edi, byte 13h
        push edi
        mov eax, dword [byte esi+08h]
        add eax, byte 9
        push eax
        push edi
        mov eax, dword [esi]
        add eax, byte 0Ah
        push eax
        call FillRectColor
        add esp, byte 14h
        push ebp
        mov eax, dword [byte esi+0Ch]
        add eax, byte 13h
        push eax
        mov edi, dword [byte esi+08h]
        add edi, byte 0Ah
        push edi
        mov eax, dword [byte esi+04h]
        add eax, byte 14h
        push eax
        push edi
        call FillRectColor
        add esp, byte 14h
        push ebp
        jmp near DrawCtlBox_common
%endif ; C
;-----------------------------------------------------------------------------
; MenuP1ControlsExh                            7C993  95 PC, medium confidence
; "Player 1 Controls ..." exhibition menu, eax=0
;-----------------------------------------------------------------------------
; C: src/pc/controls_dlg/MenuP1ControlsInGame.c (MenuP1ControlsExh)
%ifdef CBUILD
%include "c/pc/controls_dlg/MenuP1ControlsInGame.MenuP1ControlsExh.inc"
%else
MenuP1ControlsExh:
        push dword 4
        call __CHK
        xor eax, eax
        jmp short ControlsDlgExh
%endif ; C
;-----------------------------------------------------------------------------
; MenuP2ControlsExh                            7C9A1  95 PC, medium confidence
; "Player 2 Controls ..." exhibition menu, eax=1
;-----------------------------------------------------------------------------
; C: src/pc/controls_dlg/MenuP1ControlsInGame.c (MenuP2ControlsExh)
%ifdef CBUILD
%include "c/pc/controls_dlg/MenuP1ControlsInGame.MenuP2ControlsExh.inc"
%else
MenuP2ControlsExh:
        push dword 4
        call __CHK
        mov eax, 1
;-----------------------------------------------------------------------------
; ControlsDlgExh                               7C9B0  95 PC, medium confidence
; Controller dialog (player image, Mouse/Joystick/Keyboard)
;-----------------------------------------------------------------------------
ControlsDlgExh:
        push dword 2Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov ebp, eax
        push byte 20h
        push dword 8C31h
        push str_BKGD4
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [esp], eax
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov word [byte eax+04h], 98h
        mov word [byte eax+06h], 0ECh
        push byte 13h
        push byte 0Ah
        push eax
        call GrabBlock
        add esp, byte 0Ch
        cmp dword [gamemode], byte 2
        sete al
        and eax, 0FFh
        call DrawControlsDlg
        mov eax, ebp
        call DrawControlsOpts
        mov eax, ebp
        call ControlsDlgLoop
        push byte 13h
        push byte 0Ah
        mov ebx, dword [byte esp+08h]
        push ebx
        call PutBlock
        add esp, byte 0Ch
        mov ecx, dword [esp]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        xor esi, esi
        mov dword [ctldlgalt], esi
ControlsDlg_done:
        xor eax, eax
        add esp, byte 4
        jmp near ControlsDlg_ret
%endif ; C
;-----------------------------------------------------------------------------
; MenuP1ControlsLeague                         7CA53  95 PC, medium confidence
; "Player 1 Controls ..." league menu
;-----------------------------------------------------------------------------
; C: src/pc/controls_dlg/MenuP1ControlsInGame.c (MenuP1ControlsLeague)
%ifdef CBUILD
%include "c/pc/controls_dlg/MenuP1ControlsInGame.MenuP1ControlsLeague.inc"
%else
MenuP1ControlsLeague:
        push dword 4
        call __CHK
        xor eax, eax
        jmp short ControlsDlgLeague
%endif ; C
;-----------------------------------------------------------------------------
; MenuP2ControlsLeague                         7CA61  95 PC, medium confidence
; "Player 2 Controls ..." league menu
;-----------------------------------------------------------------------------
; C: src/pc/controls_dlg/MenuP1ControlsInGame.c (MenuP2ControlsLeague)
%ifdef CBUILD
%include "c/pc/controls_dlg/MenuP1ControlsInGame.MenuP2ControlsLeague.inc"
%else
MenuP2ControlsLeague:
        push dword 4
        call __CHK
        mov eax, 1
;-----------------------------------------------------------------------------
; ControlsDlgLeague                            7CA70  95 PC, medium confidence
; Controller dialog, league variant
;-----------------------------------------------------------------------------
ControlsDlgLeague:
        push dword 2Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        push eax
        push byte 20h
        push dword 8C31h
        push str_BKGD4
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
        mov word [byte eax+04h], 98h
        mov word [byte eax+06h], 0ECh
        push byte 13h
        push byte 0Ah
        push eax
        call GrabBlock
        add esp, byte 0Ch
        xor eax, eax
        call DrawControlsDlg
        mov eax, dword [esp]
        call DrawControlsOpts
        mov eax, dword [esp]
        call ControlsDlgLoop
        push byte 13h
        push byte 0Ah
        push ebp
        call PutBlock
        add esp, byte 0Ch
        push ebp
        call FreeMemBlock
        add esp, byte 4
        xor edx, edx
        mov dword [ctldlgalt], edx
        jmp near ControlsDlg_done
%endif ; C
;-----------------------------------------------------------------------------
; MenuP1ControlsInGame                         7CAF7  95 PC, medium confidence
; "Player 1 Controls ..." in-game menu
;-----------------------------------------------------------------------------
; C: src/pc/controls_dlg/MenuP1ControlsInGame.c
%ifdef CBUILD
%include "c/pc/controls_dlg/MenuP1ControlsInGame.inc"
%else
MenuP1ControlsInGame:
        push dword 4
        call __CHK
        xor eax, eax
;-----------------------------------------------------------------------------
; ControlsDlgInGame                            7CB03  95 PC, medium confidence
; Controller dialog; afterwards updates cont1team/cont2team, samesideflag
;-----------------------------------------------------------------------------
ControlsDlgInGame:
        push dword 34h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 0Ch
        mov ebp, eax
        xor edx, edx
        mov dword [byte esp+04h], edx
        push byte 20h
        push dword 8C31h
        push str_BKGD4
        call AllocMemBlock
        mov dword [byte esp+0Ch], eax
        add esp, byte 0Ch
        mov dword [byte esp+08h], eax
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov word [byte eax+04h], 98h
        mov word [byte eax+06h], 0ECh
        push byte 13h
        push byte 0Ah
        push eax
        call GrabBlock
        add esp, byte 0Ch
        xor eax, eax
        call DrawControlsDlg
        mov eax, ebp
        call DrawControlsOpts
        mov eax, ebp
        call ControlsDlgLoop
        push byte 13h
        push byte 0Ah
        mov ecx, dword [byte esp+08h]
        push ecx
        call PutBlock
        add esp, byte 0Ch
        mov eax, ebp
        shl eax, 2
        cmp dword [dword eax+ctl1team], byte 0
        jge near ControlsDlgInGame_side
        xor edx, edx
        jmp near ControlsDlgInGame_setside
%endif ; C
;-----------------------------------------------------------------------------
; MenuP2ControlsInGame                         7CB9F  95 PC, medium confidence
; "Player 2 Controls ..." in-game menu
;-----------------------------------------------------------------------------
; C: src/pc/controls_dlg/MenuP1ControlsInGame.c (MenuP2ControlsInGame)
%ifdef CBUILD
%include "c/pc/controls_dlg/MenuP1ControlsInGame.MenuP2ControlsInGame.inc"
%else
MenuP2ControlsInGame:
        push dword 4
        call __CHK
        mov eax, 1
        jmp near ControlsDlgInGame
%endif ; C
;-----------------------------------------------------------------------------
; CtlSwapScoreFix                                 7CBB3  95 PC, low confidence
; Adjusts hmtmstruct+38h flags after controller change, uses score diff
;-----------------------------------------------------------------------------
; C: src/pc/controls_dlg/MenuP1ControlsInGame.c (CtlSwapScoreFix)
%ifdef CBUILD
%include "c/pc/controls_dlg/MenuP1ControlsInGame.CtlSwapScoreFix.inc"
%else
CtlSwapScoreFix:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov edx, eax
        shl eax, 8
        add eax, hmtmstruct
        cmp word [byte eax+038h], byte 0
        jge near .x
        mov bl, byte [byte eax+038h]
        test bl, 0F0h
        je near .x
        mov bh, bl
        and bh, 0Fh
        mov byte [byte eax+038h], bh
        test edx, edx
        sete bl
        and ebx, 0FFh
        shl ebx, 8
        mov ecx, dword [dword ebx+hmscore-2]
        sar ecx, 10h
        mov ebx, dword [byte eax+0Eh]
        sar ebx, 10h
        sub ecx, ebx
        mov ebx, ecx
        test ecx, ecx
        jle short .1
        cmp ecx, byte 2
        jg short .1
        cmp word [gsp], byte 2
        jne short .1
        cmp word [gameclock], byte 3Ch
        jle short .x
.1:
        mov cl, byte [gmode]
        test cl, 1
        jne short .2
        mov ebx, dword [puckc]
        mov ch, byte [ebx]
        test ch, ch
        jl short .2
        cmp ch, 6
        setl bl
        and ebx, 0FFh
        xor ebx, edx
        je short .2
        test cl, 8
        jne short .x
.2:
        mov byte [byte eax+039h], 0
        mov ebx, edx
        shl edx, 2
        sub edx, ebx
        mov ebx, dword [nosplit edx*4+goaliemenuflags_e02]
        mov byte [ebx], 2
        mov bx, word [byte eax+038h]
        xor bh, bh
        and bl, 0Fh
        movsx ebx, bx
        shl ebx, 2
        mov edx, dword [dword ebx+edx*4+goaliemenuflags]
        mov byte [edx], 1
        call setpersonel
.x:
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CtlSwapTeamFlag                                 7CC8A  95 PC, low confidence
; Sets hmtmstruct+38h high nibble depending on puck possession
;-----------------------------------------------------------------------------
; C: src/pc/controls_dlg/MenuP1ControlsInGame.c (CtlSwapTeamFlag)
%ifdef CBUILD
%include "c/pc/controls_dlg/MenuP1ControlsInGame.CtlSwapTeamFlag.inc"
%else
CtlSwapTeamFlag:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov ebx, eax
        shl eax, 8
        add eax, hmtmstruct
        cmp word [byte eax+038h], byte 0
        jge short .x
        test byte [byte eax+038h], 0F0h
        jne short .x
        test byte [gmode], 1
        jne short .1
        mov edx, dword [puckc]
        mov cl, byte [edx]
        test cl, cl
        jl short .1
        cmp cl, 6
        setl dl
        and edx, 0FFh
        xor ebx, edx
        je short .1
        test byte [gmode], 8
        jne short .x
.1:
        or word [byte eax+038h], byte 0FFF0h
.x:
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ReassignCtlPlayer                            7CCE5  95 PC, medium confidence
; Re-picks c1/c2playernum for cont1team/cont2team
;-----------------------------------------------------------------------------
ReassignCtlPlayer:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 0Ch
        push eax
        test eax, eax
        je short .1
        mov edx, cont2team
        mov eax, c2playernum
        jmp short .2
.1:
        mov edx, cont1team
        mov eax, c1playernum
.2:
        mov bx, word [edx]
        test bx, bx
        jne short .3
        movsx eax, word [eax]
        cmp eax, byte 0FFFFFFFFh
        je near .15
        mov word [byte esp+08h], 0FFFFh
        jmp near .13
.3:
        cmp bx, byte 1
        jne short .4
        mov si, word [eax]
        test si, si
        jl short .4
        cmp si, byte 5
        jle near .15
.4:
        cmp word [edx], byte 2
        jne short .5
        mov cx, word [eax]
        cmp cx, byte 6
        jl short .5
        cmp cx, byte 0Bh
        jle near .15
.5:
        mov eax, dword [puckvx]
        movsx ecx, word [eax]
        sar ecx, 8
        mov eax, dword [puckx]
        movsx eax, word [eax]
        add ecx, eax
        mov word [byte esp+04h], cx
        mov eax, dword [puckvy]
        movsx ecx, word [eax]
        sar ecx, 8
        mov eax, dword [pucky]
        movsx eax, word [eax]
        add eax, ecx
        mov word [byte esp+0Ch], ax
        mov edi, 10000000h
        cmp word [edx], byte 1
        jne short .6
        mov eax, SortCords
        jmp short .7
.6:
        mov eax, SortCords+300h
.7:
        mov ebx, 6
.8:
        cmp word [byte eax+01Ah], byte 0
        jl near .12
        test byte [byte eax+045h], 4
        jne near .12
        test byte [byte eax+044h], 20h
        jne short .12
        mov edx, dword [eax]
        sar edx, 10h
        mov ecx, dword [byte esp+02h]
        sar ecx, 10h
        sub ecx, edx
        mov edx, dword [byte eax+04h]
        sar edx, 10h
        mov esi, dword [byte esp+0Ah]
        sar esi, 10h
        sub esi, edx
        mov edx, esi
        imul ecx, ecx
        imul edx, esi
        add edx, ecx
        mov ecx, dword [puckc]
        movsx cx, byte [ecx]
        cmp cx, word [byte eax+06Ah]
        jne short .9
        mov edx, 0FFFFFFFFh
.9:
        cmp edx, edi
        jg short .12
        mov cx, word [byte eax+06Ah]
        cmp dword [esp], byte 0
        je short .10
        mov si, word [c1playernum]
        jmp short .11
.10:
        mov si, word [c2playernum]
.11:
        cmp cx, si
        je short .12
        mov edi, edx
        mov word [byte esp+08h], cx
.12:
        add eax, 80h
        dec bx
        jne near ReassignCtlPlayer.8
.13:
        cmp dword [esp], byte 0
        jne short .14
        mov eax, dword [byte esp+08h]
        cmp ax, word [c1playernum]
        je short .15
        mov edx, dword [c1playernum-2]
        sar edx, 10h
        mov eax, dword [byte esp+06h]
        sar eax, 10h
        call restorepl
        mov word [c1playernum], ax
        jmp short .15
.14:
        mov eax, dword [byte esp+08h]
        cmp ax, word [c2playernum]
        je short .15
        mov edx, dword [c2playernum-2]
        sar edx, 10h
        mov eax, dword [byte esp+06h]
        sar eax, 10h
        call restorepl
        mov word [c2playernum], ax
.15:
        add esp, byte 10h
        jmp near ControlsDlg_ret0
;-----------------------------------------------------------------------------
; ClearCtlBlink                                7CEA1  95 PC, medium confidence
; Clears lcblink/lcboxon and player flags for released sides
;-----------------------------------------------------------------------------
; C: src/pc/controls_dlg/MenuP1ControlsInGame.c (ClearCtlBlink)
%ifdef CBUILD
%include "c/pc/controls_dlg/MenuP1ControlsInGame.ClearCtlBlink.inc"
%else
ClearCtlBlink:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        xor ebx, ebx
        mov edi, 4
        mov esi, 6
.1:
        test ebx, ebx
        setne al
        and eax, 0FFh
        inc eax
        mov edx, dword [cont1team-2]
        sar edx, 10h
        cmp edx, eax
        je near .9
        mov edx, dword [cont2team-2]
        sar edx, 10h
        cmp edx, eax
        je near .9
        xor edx, edx
        mov word [nosplit ebx*2+lcblink], dx
        mov word [nosplit ebx*2+lcboxon], dx
        test ebx, ebx
        je short .3
        mov eax, 6
.2:
        mov edx, eax
        shl edx, 7
        and byte [dword edx+scpflags2], 0F7h
        inc eax
        cmp eax, byte 0Ch
        jl short ClearCtlBlink.2
        jmp short .5
.3:
        xor eax, eax
.4:
        mov edx, eax
        shl edx, 7
        and byte [dword edx+scpflags2], 0F7h
        inc eax
        cmp eax, byte 6
        jl short ClearCtlBlink.4
.5:
        mov eax, ebx
        shl eax, 8
        and byte [dword eax+hmtmflags], 0FDh
        test ebx, ebx
        sete al
        and eax, 0FFh
        shl eax, 8
        mov edx, dword [dword eax+hmtmap-2]
        sar edx, 10h
        mov eax, ebx
        shl eax, 8
        mov ecx, dword [dword eax+hmtmap-2]
        sar ecx, 10h
        sub edx, ecx
        mov ecx, edx
        mov edx, dword [dword eax+hmtmline-2]
        sar edx, 10h
        test ecx, ecx
        jle short .6
        cmp edx, byte 6
        jge short .6
        mov word [dword eax+hmtmline], si
.6:
        test ecx, ecx
        jge short .8
        cmp edx, byte 5
        jg short .7
        cmp edx, byte 4
        jge short .8
.7:
        mov eax, ebx
        shl eax, 8
        mov word [dword eax+hmtmline], di
.8:
        test ecx, ecx
        jne short .9
        cmp edx, byte 3
        jl short .9
        mov eax, ebx
        shl eax, 8
        xor edx, edx
        mov word [dword eax+hmtmline], dx
.9:
        inc ebx
        cmp ebx, byte 2
        jl near ClearCtlBlink.1
        jmp near ControlsDlg_ret0
%endif ; C
;-----------------------------------------------------------------------------
; ControlsDlgInGame_side                       7CFB9  95 PC, medium confidence
; Code label inside ControlsDlgInGame: pick side 1/2
;-----------------------------------------------------------------------------
; C: src/pc/controls_dlg/MenuP1ControlsInGame.c (ControlsDlgInGame_side)
%ifdef CBUILD
%include "c/pc/controls_dlg/MenuP1ControlsInGame.ControlsDlgInGame_side.inc"
%else
ControlsDlgInGame_side:
        cmp dword [dword eax+ctl1side], byte 0
        jne short .1
        mov edx, 1
        jmp short ControlsDlgInGame_setside
.1:
        mov edx, 2
ControlsDlgInGame_setside:
        mov ecx, dword [cont1team-2]
        sar ecx, 10h
        mov ebx, dword [cont2team-2]
        sar ebx, 10h
        test ebp, ebp
        je short .1
        mov word [cont2team], dx
        jmp short .2
.1:
        mov word [cont1team], dx
.2:
        cmp dword [ctl1team], byte 0
        jl short .3
        cmp dword [ctl2team], byte 0
        jl short .3
        mov eax, dword [ctl1side]
        cmp eax, dword [ctl2side]
        jne short .3
        mov dword [samesideflag], 1
        jmp short .4
.3:
        xor eax, eax
        mov dword [samesideflag], eax
.4:
        mov eax, dword [nosplit ebp*4+ctl1dev]
        cmp eax, byte 4
        jb short .5
        jbe short .8
        cmp eax, byte 8
        jb short .11
        jbe short .9
        cmp eax, byte 10h
        je short .10
        jmp short .11
.5:
        cmp eax, byte 1
        jb short .11
        jbe short .6
        cmp eax, byte 2
        je short .7
        jmp short .11
.6:
        mov byte [dword ebp+pad1dev], 1
        jmp short .11
.7:
        mov byte [dword ebp+pad1dev], 2
        jmp short .11
.8:
        mov byte [dword ebp+pad1dev], 4
        jmp short .11
.9:
        mov byte [dword ebp+pad1dev], 8
        jmp short .11
.10:
        xor ah, ah
        mov byte [dword ebp+pad1dev], ah
.11:
        mov eax, ebp
        call ReassignCtlPlayer
        call ClearCtlBlink
        mov eax, dword [puckstruct+1Ah]
        sar eax, 10h
        cmp byte [dword eax+puckasslist], 1Bh
        jne short .12
        cmp edx, byte 1
        jne short .12
        cmp ecx, edx
        je short .12
        cmp ebx, edx
        je short .12
        xor edx, edx
        mov word [pucktemp1], dx
.12:
        mov edx, 1
.13:
        cmp ecx, edx
        je short .14
        cmp ebx, edx
        jne short .15
.14:
        mov eax, dword [cont1team-2]
        sar eax, 10h
        cmp eax, edx
        je short .15
        mov eax, dword [cont2team-2]
        sar eax, 10h
        cmp eax, edx
        je short .15
        cmp edx, byte 2
        sete al
        and eax, 0FFh
        call CtlSwapScoreFix
        jmp short .17
.15:
        cmp ecx, edx
        je short .17
        cmp ebx, edx
        je short .17
        mov eax, dword [cont1team-2]
        sar eax, 10h
        cmp eax, edx
        je short .16
        mov eax, dword [cont2team-2]
        sar eax, 10h
        cmp eax, edx
        jne short .17
.16:
        cmp edx, byte 2
        sete al
        and eax, 0FFh
        call CtlSwapTeamFlag
.17:
        inc edx
        cmp edx, byte 2
        jle short ControlsDlgInGame_setside.13
        mov edi, dword [byte esp+08h]
        push edi
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [byte esp+04h]
ControlsDlg_ret0C:
        add esp, byte 0Ch
ControlsDlg_ret:
        pop ebp
ControlsDlg_ret0:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; MenuP1ControlsPlayoff                        7D137  95 PC, medium confidence
; "Player 1 Controls ..." playoff menu
;-----------------------------------------------------------------------------
; C: src/pc/controls_dlg/MenuP1ControlsInGame.c (MenuP1ControlsPlayoff)
%ifdef CBUILD
%include "c/pc/controls_dlg/MenuP1ControlsInGame.MenuP1ControlsPlayoff.inc"
%else
MenuP1ControlsPlayoff:
        push dword 4
        call __CHK
        xor eax, eax
        jmp short ControlsDlgPlayoff
%endif ; C
;-----------------------------------------------------------------------------
; MenuP2ControlsPlayoff                        7D145  95 PC, medium confidence
; "Player 2 Controls ..." playoff menu
;-----------------------------------------------------------------------------
; C: src/pc/controls_dlg/MenuP1ControlsInGame.c (MenuP2ControlsPlayoff)
%ifdef CBUILD
%include "c/pc/controls_dlg/MenuP1ControlsInGame.MenuP2ControlsPlayoff.inc"
%else
MenuP2ControlsPlayoff:
        push dword 4
        call __CHK
        mov eax, 1
;-----------------------------------------------------------------------------
; ControlsDlgPlayoff                           7D154  95 PC, medium confidence
; Controller dialog, playoff variant
;-----------------------------------------------------------------------------
ControlsDlgPlayoff:
        push dword 30h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        push eax
        push byte 20h
        push dword 8C31h
        push str_BKGD4
        call AllocMemBlock
        mov ebp, eax
        add esp, byte 0Ch
        mov dword [byte esp+04h], eax
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov word [byte eax+04h], 98h
        mov word [byte eax+06h], 0ECh
        push byte 13h
        push byte 0Ah
        push eax
        call GrabBlock
        add esp, byte 0Ch
        mov eax, 1
        call DrawControlsDlg
        mov eax, dword [esp]
        call DrawControlsOpts
        mov eax, dword [esp]
        call ControlsDlgLoop
        push byte 13h
        push byte 0Ah
        push ebp
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [esp]
        shl eax, 2
        cmp dword [dword eax+ctl1team], byte 0
        jge short .1
        xor eax, eax
        jmp short .3
.1:
        cmp dword [dword eax+ctl1side], byte 0
        jne short .2
        mov eax, 1
        jmp short .3
.2:
        mov eax, 2
.3:
        cmp dword [esp], byte 0
        je short .4
        mov word [cont2team], ax
        jmp short .5
.4:
        mov word [cont1team], ax
.5:
        cmp dword [ctl1team], byte 0
        jl short .6
        cmp dword [ctl2team], byte 0
        jl short .6
        mov eax, dword [ctl1side]
        cmp eax, dword [ctl2side]
        jne short .6
        mov dword [samesideflag], 1
        jmp short .7
.6:
        xor eax, eax
        mov dword [samesideflag], eax
.7:
        mov ebx, dword [byte esp+04h]
        push ebx
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        add esp, byte 8
        jmp near ControlsDlg_ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawControlsDlg                              7D254  95 PC, medium confidence
; BKGD/player/dbox with teamcitynames
;-----------------------------------------------------------------------------
; C: src/pc/controls_dlg/MenuP1ControlsInGame.c (DrawControlsDlg)
%ifdef CBUILD
%include "c/pc/controls_dlg/MenuP1ControlsInGame.DrawControlsDlg.inc"
%else
DrawControlsDlg:
        push dword 14Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, 120h
        mov esi, eax
        call SetScreenTarget
        xor eax, eax
.1:
        mov byte [esp+eax], al
        inc eax
        cmp eax, 100h
        jl short DrawControlsDlg.1
        mov dword [ctldlgalt], esi
        test esi, esi
        je short .2
        mov byte [dword esp+0FAh], 40h
        mov byte [dword esp+0F9h], 41h
        mov byte [dword esp+0F8h], 42h
        mov byte [dword esp+0F7h], 43h
.2:
        mov eax, esp
        push eax
        call SetColorRemap
        add esp, byte 4
        xor ecx, ecx
        mov ebx, str_PlayerImg
        cmp byte [fileoncd+0138h], 1
        jne short .3
        mov edx, dword [cddriveptr]
        jmp short .4
.3:
        xor edx, edx
.4:
        lea eax, [dword esp+0100h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0104h]
        push eax
        call LoadBank
        mov edi, eax
        add esp, byte 8
        push byte 13h
        push byte 0Ah
        push str_Dbox5
        push eax
        call FindShape
        add esp, byte 8
        push eax
        call DrawArtMasked
        add esp, byte 0Ch
        push edi
        call FreeMemBlock
        add esp, byte 4
        test esi, esi
        je short .5
        push dword 0FFh
        push byte 40h
        jmp short .6
.5:
        push dword 0FFh
        push dword 0FAh
.6:
        call TextSetColors
        add esp, byte 8
        mov edi, dword [ctldlgrects]
        add edi, byte 0Bh
        mov esi, dword [ctldlgrects+4]
        add esi, byte 14h
        mov eax, dword [ctldlgrects+8]
        add eax, byte 0Ah
        sub eax, edi
        mov edx, dword [ctldlgrects+0Ch]
        add edx, byte 13h
        sub edx, esi
        mov ebx, dword [dword esp+0F6h]
        sar ebx, 18h
        push ebx
        push edx
        push eax
        push esi
        push edi
        call FillRect
        add esp, byte 14h
        push esi
        add edi, byte 3
        push edi
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        mov edx, dword [nosplit eax*4+teamcitynames]
        push edx
        call PrintString
        add esp, byte 0Ch
        mov edi, dword [ctldlgrects+10h]
        add edi, byte 0Bh
        mov esi, dword [ctldlgrects+14h]
        add esi, byte 14h
        mov eax, dword [ctldlgrects+18h]
        add eax, byte 0Ah
        sub eax, edi
        mov edx, dword [ctldlgrects+1Ch]
        add edx, byte 13h
        sub edx, esi
        mov ebx, dword [dword esp+0F6h]
        sar ebx, 18h
        push ebx
        push edx
        push eax
        push esi
        push edi
        call FillRect
        add esp, byte 14h
        push esi
        add edi, byte 3
        push edi
        mov eax, dword [VisTeam-2]
        sar eax, 10h
        mov ebx, dword [nosplit eax*4+teamcitynames]
        push ebx
        call PrintString
        add esp, byte 0Ch
        add esp, 120h
        jmp near ControlsDlg_ret0
%endif ; C
;-----------------------------------------------------------------------------
; DrawControlsOpts                             7D3F0  95 PC, medium confidence
; One's/Two's, The Mouse/Joystick One/Two/The Keyboard by ctlavailmask
;-----------------------------------------------------------------------------
; C: src/pc/controls_dlg/MenuP1ControlsInGame.c (DrawControlsOpts)
%ifdef CBUILD
%include "c/pc/controls_dlg/MenuP1ControlsInGame.DrawControlsOpts.inc"
%else
DrawControlsOpts:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov esi, eax
        cmp dword [ctldlgalt], byte 0
        je short .1
        push dword 0FFh
        push byte 40h
        jmp short .2
.1:
        push dword 0FFh
        push dword 0FAh
.2:
        call TextSetColors
        add esp, byte 8
        test esi, esi
        jne short .3
        push byte 20h
        push byte 4Ah
        push str_OneS
        jmp short .4
.3:
        push byte 20h
        push byte 4Ah
        push str_TwoS
.4:
        call PrintString
        add esp, byte 0Ch
        xor ebx, ebx
        mov dword [setbits], ebx
        mov eax, dword [ctlavailmask]
        and eax, byte 1
        shl eax, 2
        or ax, 1C3h
        mov edx, dword [ctlavailmask]
        shl edx, 1Eh
        shr edx, 1Fh
        shl edx, 3
        or edx, eax
        mov eax, dword [ctlavailmask]
        shl eax, 1Dh
        shr eax, 1Fh
        shl eax, 4
        or edx, eax
        mov eax, dword [ctlavailmask]
        shl eax, 1Ch
        shr eax, 1Fh
        shl eax, 5
        or edx, eax
        mov dword [dword_ED364], edx
        test esi, esi
        sete al
        and eax, 0FFh
        cmp dword [nosplit eax*4+ctl1dev], byte 10h
        je short .5
        test esi, esi
        sete al
        and eax, 0FFh
        mov eax, dword [nosplit eax*4+ctl1dev]
        shl eax, 2
        not eax
        mov edi, edx
        and edi, eax
        mov dword [dword_ED364], edi
.5:
        mov eax, esi
        shl eax, 2
        mov ebp, dword [dword eax+ctl1team]
        test ebp, ebp
        jge short .7
        cmp ebp, byte 0FFFFFFFFh
        jne short .6
        mov dword [setbits], 41h
        jmp short .8
.6:
        cmp ebp, byte 0FFFFFFFEh
        jne short .8
        mov dword [setbits], 42h
        jmp short .8
.7:
        cmp dword [dword eax+ctl1side], byte 0
        setne al
        and eax, 0FFh
        inc eax
        mov dword [setbits], eax
        mov eax, dword [nosplit esi*4+ctl1dev]
        shl eax, 2
        test dword [dword_ED364], eax
        je short .8
        or dword [setbits], eax
.8:
        xor edx, edx
.9:
        mov cl, dl
        mov ebx, 1
        shl ebx, cl
        mov eax, edx
        shl eax, 4
        add eax, ctldlgrects
        test dword [setbits], ebx
        je short .10
        call DrawCtlBoxOn
        jmp short .11
.10:
        call DrawCtlBoxOff
.11:
        inc edx
        cmp edx, byte 9
        jl short DrawControlsOpts.9
        cmp dword [ctldlgalt], byte 0
        je short .12
        push dword 0FFh
        push byte 42h
        jmp short .13
.12:
        push dword 0FFh
        push dword 0F8h
.13:
        call TextSetColors
        add esp, byte 8
        test byte [dword_ED364], 4
        jne short .14
        mov eax, dword [ctldlgrects+24h]
        add eax, byte 14h
        push eax
        mov eax, dword [ctldlgrects+20h]
        add eax, byte 19h
        push eax
        push str_TheMouse
        call PrintString
        add esp, byte 0Ch
.14:
        test byte [dword_ED364], 8
        jne short .15
        mov eax, dword [ctldlgrects+34h]
        add eax, byte 14h
        push eax
        mov eax, dword [ctldlgrects+30h]
        add eax, byte 12h
        push eax
        push str_JoystickOne
        call PrintString
        add esp, byte 0Ch
.15:
        test byte [dword_ED364], 10h
        jne short .16
        mov eax, dword [ctldlgrects+44h]
        add eax, byte 14h
        push eax
        mov eax, dword [ctldlgrects+40h]
        add eax, byte 11h
        push eax
        push str_JoystickTwo
        call PrintString
        add esp, byte 0Ch
.16:
        test byte [dword_ED364], 20h
        jne near ControlsDlg_ret
        mov eax, dword [ctldlgrects+54h]
        add eax, byte 14h
        push eax
        mov eax, dword [ctldlgrects+50h]
        add eax, byte 0Fh
        push eax
        push str_TheKeyboard
        call PrintString
        jmp near ControlsDlg_ret0C
%endif ; C
;-----------------------------------------------------------------------------
; CtlDlgHitTest                                7D61F  95 PC, medium confidence
; Hit-test 9 rects at ctldlgrects
;-----------------------------------------------------------------------------
; C: src/pc/controls_dlg/CtlDlgHitTest.c
%ifdef CBUILD
%include "c/pc/controls_dlg/CtlDlgHitTest.inc"
%else
CtlDlgHitTest:
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
        cmp ecx, dword [dword eax+ctldlgrects]
        jl short .2
        cmp ecx, dword [dword eax+ctldlgrects+8]
        jg short .2
        cmp esi, dword [dword eax+ctldlgrects+4]
        jl short .2
        cmp esi, dword [dword eax+ctldlgrects+0Ch]
        jg short .2
        mov dword [ebx], edx
        mov eax, 1
        pop esi
        pop ecx
        ret
.2:
        inc edx
        cmp edx, byte 9
        jl short CtlDlgHitTest.1
        xor eax, eax
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawCtlBoxes                                 7D671  95 PC, medium confidence
; Draws 9 boxes on/off by setbits
;-----------------------------------------------------------------------------
; C: src/pc/controls_dlg/DrawCtlBoxes.c
%ifdef CBUILD
%include "c/pc/controls_dlg/DrawCtlBoxes.inc"
%else
DrawCtlBoxes:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        xor edx, edx
.1:
        mov cl, dl
        mov ebx, 1
        shl ebx, cl
        mov eax, edx
        shl eax, 4
        add eax, ctldlgrects
        test dword [setbits], ebx
        je short .2
        call DrawCtlBoxOn
        jmp short .3
.2:
        call DrawCtlBoxOff
.3:
        inc edx
        cmp edx, byte 9
        jl short DrawCtlBoxes.1
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ControlsDlgLoop                              7D6B1  95 PC, medium confidence
; Pointer loop, calls SetSideControls
;-----------------------------------------------------------------------------
; C: src/pc/controls_dlg/MenuP1ControlsInGame.c (ControlsDlgLoop)
%ifdef CBUILD
%include "c/pc/controls_dlg/MenuP1ControlsInGame.ControlsDlgLoop.inc"
%else
ControlsDlgLoop:
        push dword 44h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 18h
        push eax
        lea eax, [byte esp+014h]
        push eax
        lea eax, [byte esp+01Ch]
        push eax
        lea eax, [byte esp+010h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        mov eax, dword [byte esp+018h]
        mov dword [byte esp+010h], eax
        mov eax, dword [byte esp+014h]
        mov dword [byte esp+0Ch], eax
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
        push str_Pointer18
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
        mov edx, dword [byte esp+0Ch]
        push edx
        mov edx, dword [byte esp+014h]
        sub edx, byte 4
        push edx
        push eax
        call GrabBlock
        add esp, byte 0Ch
        mov ebx, dword [byte esp+0Ch]
        push ebx
        mov eax, dword [byte esp+014h]
        sub eax, byte 4
        push eax
        mov ecx, dword [pointerspr]
        push ecx
        call DrawArt
        add esp, byte 0Ch
        call ClearInputQueue
.1:
        xor esi, esi
        mov dword [byte esp+08h], esi
.2:
        call GetInputEvent
        test eax, eax
        je short .3
        lea ebx, [byte esp+0Ch]
        lea edx, [byte esp+010h]
        call dword [ptrupdatefn]
        mov dword [byte esp+08h], eax
        test al, 6
        je short ControlsDlgLoop.2
.3:
        mov ah, byte [byte esp+08h]
        test ah, 2
        jne near .7
        test ah, 4
        jne short .7
        mov eax, dword [byte esp+010h]
        cmp eax, dword [byte esp+018h]
        jne short .4
        mov eax, dword [byte esp+0Ch]
        cmp eax, dword [byte esp+014h]
        je short ControlsDlgLoop.1
.4:
        mov edi, dword [byte esp+014h]
        push edi
        mov eax, dword [byte esp+01Ch]
        sub eax, byte 4
.5:
        push eax
        push ebp
        call PutBlock
        add esp, byte 0Ch
.6:
        mov eax, dword [byte esp+0Ch]
        push eax
        mov eax, dword [byte esp+014h]
        sub eax, byte 4
        push eax
        push ebp
        call GrabBlock
        add esp, byte 0Ch
        mov edx, dword [byte esp+0Ch]
        push edx
        mov eax, dword [byte esp+014h]
        sub eax, byte 4
        push eax
        mov ebx, dword [pointerspr]
        push ebx
        call DrawArt
        add esp, byte 0Ch
        mov eax, dword [byte esp+010h]
        mov dword [byte esp+018h], eax
        mov eax, dword [byte esp+0Ch]
        mov dword [byte esp+014h], eax
        jmp near ControlsDlgLoop.1
.7:
        mov eax, dword [byte esp+018h]
        sub eax, byte 4
        mov dh, byte [byte esp+08h]
        test dh, 2
        je near .30
        mov esi, dword [byte esp+014h]
        push esi
        push eax
        push ebp
        call PutBlock
        add esp, byte 0Ch
        lea ebx, [byte esp+04h]
        mov edx, dword [byte esp+0Ch]
        mov eax, dword [byte esp+010h]
        call CtlDlgHitTest
        test eax, eax
        je short ControlsDlgLoop.6
        mov cl, byte [byte esp+04h]
        mov eax, 1
        shl eax, cl
        mov dword [byte esp+04h], eax
        mov edi, dword [setbits]
        test eax, edi
        jne near ControlsDlgLoop.6
        test dword [dword_ED364], eax
        je near ControlsDlgLoop.6
        cmp eax, byte 10h
        jb short .9
        jbe near .15
        cmp eax, byte 40h
        jb short .8
        jbe near .17
        cmp eax, 80h
        jb near .29
        jbe near .20
        cmp eax, 100h
        je near .18
        jmp near .29
.8:
        cmp eax, byte 20h
        je short .16
        jmp near .29
.9:
        cmp eax, byte 2
        jb short .10
        jbe short .12
        cmp eax, byte 4
        jb near .29
        jbe short .13
        cmp eax, byte 8
        je short .14
        jmp near .29
.10:
        cmp eax, byte 1
        jne near .29
        mov eax, edi
        and al, 0FCh
        or al, 1
.11:
        mov dword [setbits], eax
        jmp near .29
.12:
        mov eax, edi
        and al, 0FCh
        or al, 2
        jmp short ControlsDlgLoop.11
.13:
        mov eax, edi
        and al, 83h
        or al, 4
        jmp short ControlsDlgLoop.11
.14:
        mov eax, edi
        and al, 83h
        or al, 8
        jmp short ControlsDlgLoop.11
.15:
        mov eax, edi
        and al, 83h
        or al, 10h
        jmp short ControlsDlgLoop.11
.16:
        mov eax, edi
        and al, 83h
        or al, 20h
        jmp short ControlsDlgLoop.11
.17:
        mov eax, edi
        and al, 83h
        or al, 40h
        jmp short ControlsDlgLoop.11
.18:
        mov eax, ctlboxrect2
        call DrawCtlBoxOn
.19:
        push ebp
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        add esp, byte 1Ch
        jmp near ControlsDlg_ret
.20:
        mov eax, ctlboxrect1
        call DrawCtlBoxOn
        mov edx, dword [setbits]
        sar edx, 2
        mov eax, dword [esp]
        shl eax, 2
        mov dword [dword eax+ctl1dev], edx
        mov ecx, dword [setbits]
        cmp ecx, byte 41h
        jne near .24
        mov ebx, 0FFFFFFFFh
        mov dword [dword eax+ctl1team], ebx
        xor ecx, ecx
        mov dword [dword eax+ctl1side], ecx
        mov esi, dword [esp]
        test esi, esi
        sete al
        and eax, 0FFh
        cmp ebx, dword [nosplit eax*4+ctl1team]
        jne short .23
        test esi, esi
        sete al
        and eax, 0FFh
        mov dword [nosplit eax*4+ctl1team], 0FFFFFFFEh
.21:
        test esi, esi
.22:
        sete al
        and eax, 0FFh
        mov dword [nosplit eax*4+ctl1side], 1
        jmp near .28
.23:
        test esi, esi
        sete al
        and eax, 0FFh
        cmp dword [nosplit eax*4+ctl1side], byte 0
        jne near .28
        mov edx, dword [VisTeam-2]
        sar edx, 10h
        test esi, esi
        sete al
        and eax, 0FFh
        mov dword [nosplit eax*4+ctl1team], edx
        jmp short ControlsDlgLoop.21
.24:
        cmp ecx, byte 42h
        jne short .25
        mov esi, 0FFFFFFFEh
        mov dword [dword eax+ctl1team], esi
        mov edi, 1
        mov dword [dword eax+ctl1side], edi
        mov edx, dword [esp]
        test edx, edx
        sete al
        and eax, 0FFh
        cmp esi, dword [nosplit eax*4+ctl1team]
        je near .27
        test edx, edx
        sete al
        and eax, 0FFh
        cmp edi, dword [nosplit eax*4+ctl1side]
        jne near .28
        mov edx, dword [HomeTeam-2]
        sar edx, 10h
        mov edi, dword [esp]
        test edi, edi
        sete al
        and eax, 0FFh
        mov dword [nosplit eax*4+ctl1team], edx
        test edi, edi
        sete al
        and eax, 0FFh
        xor ebx, ebx
        mov dword [nosplit eax*4+ctl1side], ebx
        jmp near .28
.25:
        test byte [setbits], 1
        je short .26
        mov edx, dword [HomeTeam-2]
        sar edx, 10h
        mov dword [dword eax+ctl1team], edx
        xor ebx, ebx
        mov dword [dword eax+ctl1side], ebx
        mov ecx, dword [esp]
        test ecx, ecx
        sete al
        and eax, 0FFh
        cmp dword [nosplit eax*4+ctl1team], byte 0FFFFFFFFh
        jne short .28
        test ecx, ecx
        sete al
        and eax, 0FFh
        mov dword [nosplit eax*4+ctl1team], 0FFFFFFFEh
        test ecx, ecx
        jmp near ControlsDlgLoop.22
.26:
        mov edx, dword [VisTeam-2]
        sar edx, 10h
        mov dword [dword eax+ctl1team], edx
        mov dword [dword eax+ctl1side], 1
        mov edx, dword [esp]
        test edx, edx
        sete al
        and eax, 0FFh
        cmp dword [nosplit eax*4+ctl1team], byte 0FFFFFFFEh
        jne short .28
.27:
        test edx, edx
        sete al
        and eax, 0FFh
        mov dword [nosplit eax*4+ctl1team], 0FFFFFFFFh
        test edx, edx
        sete al
        and eax, 0FFh
        xor edx, edx
        mov dword [nosplit eax*4+ctl1side], edx
.28:
        call SetSideControls
        call WriteCurModeState
        jmp near ControlsDlgLoop.19
.29:
        call DrawCtlBoxes
        jmp near ControlsDlgLoop.6
.30:
        test dh, 4
        je short .31
        mov ecx, dword [byte esp+014h]
        push ecx
        push eax
        push ebp
        call PutBlock
        add esp, byte 0Ch
        jmp near ControlsDlgLoop.19
.31:
        mov edi, dword [byte esp+014h]
        push edi
        jmp near ControlsDlgLoop.5
%endif ; C
;-----------------------------------------------------------------------------
; SetCtlTeams                                  7DB67  95 PC, medium confidence
; Sets HomeTeam/VisTeam, ctl1team/ctl1side/ctl2side; called by SetGameSides
;-----------------------------------------------------------------------------
; C: src/pc/controls_dlg/SetCtlTeams.c
%ifdef CBUILD
%include "c/pc/controls_dlg/SetCtlTeams.inc"
%else
SetCtlTeams:
        push dword 8
        call __CHK
        push esi
        mov word [HomeTeam], bx
        mov word [VisTeam], cx
        mov dword [ctl1team], eax
        cmp eax, ebx
        jne short .2
        cmp dword [ctl1dev], byte 10h
        jne short .1
        mov dword [ctl1team], 0FFFFFFFFh
.1:
        xor esi, esi
        mov dword [ctl1side], esi
        jmp short .4
.2:
        cmp dword [ctl1dev], byte 10h
        jne short .3
        mov dword [ctl1team], 0FFFFFFFEh
.3:
        mov dword [ctl1side], 1
.4:
        test edx, edx
        jge short .5
        cmp dword [ctl1side], byte 0
        sete dl
        and edx, 0FFh
        mov dword [ctl2side], edx
        cmp eax, ebx
        setne al
        and eax, 0FFh
        sub eax, byte 2
        mov dword [ctl2team], eax
        mov dword [ctl2dev], 10h
        jmp near .9
.5:
        mov dword [ctl2team], edx
        cmp edx, ebx
        setne al
        and eax, 0FFh
        mov dword [ctl2side], eax
        cmp dword [ctl2dev], byte 10h
        jne near .9
        test byte [ctlavailmask], 2
        je short .6
        cmp dword [ctl1dev], byte 2
        je short .6
        mov dword [ctl2dev], 2
        jmp short .9
.6:
        test byte [ctlavailmask], 4
        je short .7
        cmp dword [ctl1dev], byte 4
        je short .7
        mov dword [ctl2dev], 4
        jmp short .9
.7:
        test byte [ctlavailmask], 8
        je short .8
        cmp dword [ctl1dev], byte 8
        je short .8
        mov dword [ctl2dev], 8
        jmp short .9
.8:
        mov dword [ctl2dev], 1
.9:
        call SetSideControls
        pop esi
        ret
%endif ; C
