; Settings dialogs for the league, the playoffs, an exhibition, and which controller each side uses.
bits 32
%include "hockey.inc"
section s_7A13A progbits alloc exec nowrite align=1
extern __CHK, acptspr, awtmflags, awtmpde, c1playernum, c2playernum, cddriveptr, chkoffspr
extern chkonspr, ClearInputQueue, cont1team, cont2team, CrowdNoiseOff, CrowdNoiseReset, ctl1dev, ctl1side
extern ctl1team, ctl2dev, ctl2side, ctl2team, ctlavailmask, ctldlgalt, ctldlgrects, DrawSettingsHeading
extern hmtmtouch3, dword_ED364, exhsetrects, exhstate, fdlg_cancel, fileoncd, FreeMemBlock, gameclock
extern gamemode, gameopts, GetInputEvent, gmode, gsp, hmscore, hmtmap, hmtmflags
extern hmtmline, hmtmpde, hmtmstruct, HomeTeam, lcblink, lcboxon, leaguesetimg, leaguesetrects
extern LoadModeState, LoadSettingsShapes, MakePath, modesetrects, musichandle, musicon, musicslot, na01spr
extern na03spr, na05spr, goaliemenuflags, goaliemenuflags_e02, pad1dev, pg01spr, pg03spr, pg05spr
extern pg07spr, pl05spr, pl10spr, pl20spr, pointerspr, postate, ptrupdatefn, puckasslist
extern puckc, puckstruct, pucktemp1, puckvx, puckvy, puckx, pucky, restorepl
extern samesideflag, SaveModeState, scpflags2, seriesgameno, setbits, setpersonel, SetSideControls, settingsfile
extern sflags3, songdata, SortCords, sounddev, str_BKGD, str_BKGD2, str_BKGD3, str_BKGD4
extern str_Dbox2, str_Dbox3, str_Dbox4, str_Dbox5, str_DigitizedSpeech, str_DigitizedSpeech2, str_DigitizedSpeech3, str_JoystickOne
extern str_JoystickTwo, str_Music, str_Music2, str_Music3, str_OneS, str_PlayerImg, str_Pointer15, str_Pointer16
extern str_Pointer17, str_Pointer18, str_Setting3, str_Setting4, str_Setting5, str_Setting6, str_Setting7, str_Sound
extern str_Sound2, str_Sound3, str_TheKeyboard, str_TheMouse, str_TwoS, AllocMemBlock, LoadBank, TextSetColors
extern sub_8F963, sub_8F96E, sub_8F979, sub_8F984, sub_8FB8E, SndQuery, sub_8FCDF, PutBlock
extern FillRect, sub_91284, DrawArt, GrabBlock, PrintString, sub_91FE0, DrawArtMasked, sub_96440
extern MouseRead, FindShape, VgaSetPalette, sub_B4BA8, SetColorRemap, sub_B4FAC, teamcitynames, dlggreys
extern ctlboxrect1, ctlboxrect2, VisTeam, WriteCurModeState, WriteModeState
global LeagueSettingsDlg, LeagueSettingsDlg_ret4, LeagueSettingsDlg_ret, LeagueSettingsDlg_ret0, MenuPlayoffSettings, MenuPlayoffSettings_edit, SettingsDlgClose, EditPlayoffSettings
global MenuLeagueSettingsEdit, MenuShowLeagueSettings, MenuShowLeagueSettings2, DrawLeagueSetDlgSel, SetLeagueSetImage, DrawLeagueSetDlg, LeagueOptsToBits_jt, LeagueOptsToBits
global LeagueOptsToBits_n1, LeagueOptsToBits_n2, LeagueOptsToBits_n3, LeagueOptsToBits_n4, LeagueOptsToBits_n0, LeagueSetHitTest, DrawLeagueSetChecks, LeagueSetViewLoop
global LeagueSetEditLoop, SettingsStub, MenuModeSettings, ModeSettings_epilogue, DrawModeSetDlg, ModeOptsToBits, ModeSetHitTest, DrawModeSetChecks
global ModeSetViewLoop, ModeSetEditLoop, MenuExhibitionSettings, ExhSettings_ret, ExhOptsToBits, DrawExhSetChecks, DrawExhSetDlg, ExhSetHitTest
global ExhSetEditLoop, DrawCtlBoxOn, DrawCtlBox_common, DrawCtlBoxOff, MenuP1ControlsExh, MenuP2ControlsExh, ControlsDlgExh, ControlsDlg_done
global MenuP1ControlsLeague, MenuP2ControlsLeague, ControlsDlgLeague, MenuP1ControlsInGame, ControlsDlgInGame, MenuP2ControlsInGame, CtlSwapScoreFix, CtlSwapTeamFlag
global ReassignCtlPlayer, ClearCtlBlink, ControlsDlgInGame_side, ControlsDlgInGame_setside, ControlsDlg_ret0C, ControlsDlg_ret, ControlsDlg_ret0, MenuP1ControlsPlayoff
global MenuP2ControlsPlayoff, ControlsDlgPlayoff, DrawControlsDlg, DrawControlsOpts, CtlDlgHitTest, DrawCtlBoxes, ControlsDlgLoop, SetCtlTeams
;-----------------------------------------------------------------------------
; LeagueSettingsDlg                            7A13A  95 PC, medium confidence
; Called by MenuLeagueSettings; BKGD+setting3 dialog, preserves seriesgameno
;-----------------------------------------------------------------------------
; C: src/pc/settings_dialogs/LeagueSettingsDlg.c
%ifdef CBUILD
%include "c/pc/settings_dialogs/LeagueSettingsDlg.inc"
%else
LeagueSettingsDlg:
        push dword 2Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov esi, dword [seriesgameno]
        mov dword [esp], esi
        xor edx, edx
        mov dword [seriesgameno], edx
        call LoadSettingsShapes
        call sub_B4BA8
        push byte 20h
        push dword 1436Bh
        push str_BKGD
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
        mov word [byte eax+04h], 0E6h
        mov word [byte eax+06h], 152h
        push byte 13h
        push byte 0Ah
        push eax
        call GrabBlock
        add esp, byte 0Ch
        xor eax, eax
        call DrawLeagueSetDlg
        call LeagueOptsToBits
        mov eax, 1
        call LeagueSetEditLoop
        push byte 13h
        push byte 0Ah
        push ebp
        call PutBlock
        add esp, byte 0Ch
        push ebp
        call FreeMemBlock
        add esp, byte 4
        mov ebx, dword [settingsfile]
        push ebx
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov dword [settingsfile], ecx
        mov esi, dword [esp]
        mov dword [seriesgameno], esi
        xor eax, eax
LeagueSettingsDlg_ret4:
        add esp, byte 4
LeagueSettingsDlg_ret:
        pop ebp
LeagueSettingsDlg_ret0:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; MenuPlayoffSettings                          7A1FC  95 PC, medium confidence
; Menu action for "Play-Off Settings ..."; draws setting dialog with playoff
; flag
;-----------------------------------------------------------------------------
; C: src/pc/settings_dialogs/LeagueSettingsDlg.c (MenuPlayoffSettings)
%ifdef CBUILD
%include "c/pc/settings_dialogs/LeagueSettingsDlg.MenuPlayoffSettings.inc"
%else
MenuPlayoffSettings:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        call LoadSettingsShapes
        call sub_B4BA8
        push byte 20h
        push dword 1436Bh
        push str_BKGD
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
        mov word [byte eax+04h], 0E6h
        mov word [byte eax+06h], 152h
        push byte 13h
        push byte 0Ah
        push eax
        call GrabBlock
        add esp, byte 0Ch
        mov eax, 1
        call DrawLeagueSetDlg
        call LeagueOptsToBits
        xor eax, eax
MenuPlayoffSettings_edit:
        call LeagueSetEditLoop
;-----------------------------------------------------------------------------
; SettingsDlgClose                             7A268  95 PC, medium confidence
; Shared tail: restore screen, clear D20A8
;-----------------------------------------------------------------------------
SettingsDlgClose:
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
        jmp near LeagueSettingsDlg_ret
%endif ; C
;-----------------------------------------------------------------------------
; EditPlayoffSettings                          7A29C  95 PC, medium confidence
; Swaps exhstate/postate via Save/LoadModeState around settings edit; called
; by SelectSavedFile/CreatePlayoffs
;-----------------------------------------------------------------------------
; C: src/pc/settings_dialogs/LeagueSettingsDlg.c (EditPlayoffSettings)
%ifdef CBUILD
%include "c/pc/settings_dialogs/LeagueSettingsDlg.EditPlayoffSettings.inc"
%else
EditPlayoffSettings:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        call LoadSettingsShapes
        call sub_B4BA8
        push byte 20h
        push dword 1436Bh
        push str_BKGD
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
        mov word [byte eax+04h], 0E6h
        mov word [byte eax+06h], 152h
        push byte 13h
        push byte 0Ah
        push eax
        call GrabBlock
        add esp, byte 0Ch
        mov eax, exhstate
        call SaveModeState
        mov eax, postate
        call LoadModeState
        xor eax, eax
        call DrawLeagueSetDlg
        call LeagueOptsToBits
        mov eax, 1
        call LeagueSetEditLoop
        mov eax, postate
        call WriteModeState
        mov eax, exhstate
        call LoadModeState
        jmp near SettingsDlgClose
%endif ; C
;-----------------------------------------------------------------------------
; MenuLeagueSettingsEdit                       7A335  95 PC, medium confidence
; Menu action "League settings": DrawLeagueSetDlgSel + edit loop
;-----------------------------------------------------------------------------
; C: src/pc/settings_dialogs/LeagueSettingsDlg.c (MenuLeagueSettingsEdit)
%ifdef CBUILD
%include "c/pc/settings_dialogs/LeagueSettingsDlg.MenuLeagueSettingsEdit.inc"
%else
MenuLeagueSettingsEdit:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        call sub_B4BA8
        call LoadSettingsShapes
        push byte 20h
        push dword 1436Bh
        push str_BKGD
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
        mov word [byte eax+04h], 0E6h
        mov word [byte eax+06h], 152h
        push byte 13h
        push byte 0Ah
        push eax
        call GrabBlock
        add esp, byte 0Ch
        call DrawLeagueSetDlgSel
        call LeagueOptsToBits
        mov eax, 1
        jmp near MenuPlayoffSettings_edit
%endif ; C
;-----------------------------------------------------------------------------
; MenuShowLeagueSettings                       7A39F  95 PC, medium confidence
; Menu action "Show League settings": view-only loop
;-----------------------------------------------------------------------------
; C: src/pc/settings_dialogs/LeagueSettingsDlg.c (MenuShowLeagueSettings)
%ifdef CBUILD
%include "c/pc/settings_dialogs/LeagueSettingsDlg.MenuShowLeagueSettings.inc"
%else
MenuShowLeagueSettings:
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
        push dword 1436Bh
        push str_BKGD
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
        mov word [byte eax+04h], 0E6h
        mov word [byte eax+06h], 152h
        push byte 13h
        push byte 0Ah
        push eax
        call GrabBlock
        add esp, byte 0Ch
        call DrawLeagueSetDlgSel
        call LeagueOptsToBits
        call LeagueSetViewLoop
        jmp near SettingsDlgClose
%endif ; C
;-----------------------------------------------------------------------------
; MenuShowLeagueSettings2                      7A404  95 PC, medium confidence
; Menu action "Show League Settings ...": setting5 image + view loop
;-----------------------------------------------------------------------------
; C: src/pc/settings_dialogs/LeagueSettingsDlg.c (MenuShowLeagueSettings2)
%ifdef CBUILD
%include "c/pc/settings_dialogs/LeagueSettingsDlg.MenuShowLeagueSettings2.inc"
%else
MenuShowLeagueSettings2:
        push dword 50h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 28h
        call LoadSettingsShapes
        call sub_B4BA8
        xor ecx, ecx
        mov ebx, str_Setting5
        cmp byte [fileoncd+0175h], 1
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
        mov dword [byte esp+028h], eax
        add esp, byte 8
        push str_Dbox2
        push eax
        call FindShape
        mov ebp, eax
        add esp, byte 8
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
        push str_BKGD
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [byte esp+024h], eax
        mov edi, eax
        mov esi, ebp
        movsd
        movsd
        movsd
        movsd
        movsb
        push byte 13h
        push byte 0Ah
        push eax
        call GrabBlock
        add esp, byte 0Ch
        push byte 13h
        push byte 0Ah
        push ebp
        call DrawArt
        add esp, byte 0Ch
        mov ebx, dword [byte esp+020h]
        push ebx
        call FreeMemBlock
        add esp, byte 4
        push dword 0FFh
        push dword 0F8h
        call TextSetColors
        add esp, byte 8
        cmp dword [sounddev], byte 10h
        jne short .3
        push dword 0AAh
        push byte 68h
        push str_Music
        call PrintString
        add esp, byte 0Ch
        push dword 0C0h
        push byte 68h
        push str_Sound
        call PrintString
        add esp, byte 0Ch
.3:
        cmp byte [musicon], 0
        jne short .4
        push dword 0D6h
        push byte 68h
        push str_DigitizedSpeech
        call PrintString
        add esp, byte 0Ch
.4:
        push dword 0FAh
        mov ecx, dword [gamemode]
        mov ebx, 5
        mov edx, 13h
        mov eax, 0Ah
        call DrawSettingsHeading
        call LeagueOptsToBits
        call LeagueSetViewLoop
        push byte 13h
        push byte 0Ah
        mov esi, dword [byte esp+02Ch]
        push esi
        call PutBlock
        add esp, byte 0Ch
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov ebp, dword [settingsfile]
        push ebp
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        mov dword [settingsfile], eax
        add esp, byte 28h
        jmp near LeagueSettingsDlg_ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawLeagueSetDlgSel                          7A57E  95 PC, medium confidence
; Draws setting5 or setting3 dialog depending on leaguesetimg
;-----------------------------------------------------------------------------
; C: src/pc/settings_dialogs/DrawLeagueSetDlgSel.c
%ifdef CBUILD
%include "c/pc/settings_dialogs/DrawLeagueSetDlgSel.inc"
%else
DrawLeagueSetDlgSel:
        push dword 44h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push ebp
        mov ebp, esp
        sub esp, byte 20h
        call sub_B4BA8
        mov edx, dword [leaguesetimg]
        test edx, edx
        je short .2
        xor ecx, ecx
        mov ebx, str_Setting5
        cmp byte [fileoncd+0175h], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .3
.1:
        xor edx, edx
        jmp short .3
.2:
        xor ecx, ecx
        mov ebx, str_Setting3
        cmp byte [fileoncd+0173h], 1
        jne short .3
        mov edx, dword [cddriveptr]
.3:
        lea eax, [byte ebp-020h]
        call MakePath
        push byte 0
        lea eax, [byte ebp-020h]
        push eax
        call LoadBank
        mov esi, eax
        add esp, byte 8
        push byte 13h
        push byte 0Ah
        push str_Dbox2
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
        jne short .4
        push dword 0AAh
        push byte 68h
        push str_Music
        call PrintString
        add esp, byte 0Ch
        push dword 0C0h
        push byte 68h
        push str_Sound
        call PrintString
        add esp, byte 0Ch
.4:
        cmp byte [musicon], 0
        jne short .5
        push dword 0D6h
        push byte 68h
        push str_DigitizedSpeech
        call PrintString
        add esp, byte 0Ch
.5:
        push dword 0FAh
        mov ecx, dword [gamemode]
        cmp dword [leaguesetimg], byte 0
        je short .6
        mov ebx, 5
        jmp short .7
.6:
        mov ebx, 3
.7:
        mov edx, 13h
        mov eax, 0Ah
        call DrawSettingsHeading
        call sub_B4BA8
        xor eax, eax
        mov esp, ebp
        pop ebp
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SetLeagueSetImage                            7A6AD  95 PC, medium confidence
; Stores eax to leaguesetimg; called by MenuNewLeague/MenuNextLeagueGame
;-----------------------------------------------------------------------------
; C: src/pc/settings_dialogs/SetLeagueSetImage.c
%ifdef CBUILD
%include "c/pc/settings_dialogs/SetLeagueSetImage.inc"
%else
SetLeagueSetImage:
        push dword 4
        call __CHK
        mov dword [leaguesetimg], eax
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawLeagueSetDlg                             7A6BD  95 PC, medium confidence
; Loads setting3 + dbox, greys Music/Sound/Digitized Speech when unavailable
;-----------------------------------------------------------------------------
; C: src/pc/settings_dialogs/LeagueSettingsDlg.c (DrawLeagueSetDlg)
%ifdef CBUILD
%include "c/pc/settings_dialogs/LeagueSettingsDlg.DrawLeagueSetDlg.inc"
%else
DrawLeagueSetDlg:
        push dword 144h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, 120h
        mov esi, eax
        call sub_B4BA8
        xor eax, eax
.1:
        mov byte [esp+eax], al
        inc eax
        cmp eax, 100h
        jl short DrawLeagueSetDlg.1
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
        mov ebx, str_Setting3
        cmp byte [fileoncd+0173h], 1
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
        push str_Dbox2
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
        push byte 42h
        jmp short .6
.5:
        push dword 0FFh
        push dword 0F8h
.6:
        call TextSetColors
        add esp, byte 8
        cmp dword [sounddev], byte 10h
        jne short .7
        push dword 0AAh
        push byte 68h
        push str_Music
        call PrintString
        add esp, byte 0Ch
        push dword 0C0h
        push byte 68h
        push str_Sound
        call PrintString
        add esp, byte 0Ch
.7:
        cmp byte [musicon], 0
        jne short .8
        push dword 0D6h
        push byte 68h
        push str_DigitizedSpeech
        call PrintString
        add esp, byte 0Ch
.8:
        mov ebx, dword [gamemode]
        cmp ebx, byte 1
        jne short .12
        mov ecx, dword [seriesgameno]
        cmp ecx, byte 5
        jl short .9
        push dword 125h
        push dword 85h
        mov ebx, dword [na05spr]
        push ebx
        jmp short .11
.9:
        cmp ecx, byte 3
        jl short .10
        push dword 125h
        push dword 85h
        mov edx, dword [na03spr]
        push edx
        jmp short .11
.10:
        cmp ecx, ebx
        jl short .12
        push dword 125h
        push dword 85h
        mov eax, dword [na01spr]
        push eax
.11:
        call sub_91FE0
        add esp, byte 0Ch
.12:
        test esi, esi
        je short .13
        push byte 40h
        jmp short .14
.13:
        push dword 0FAh
.14:
        mov ecx, dword [gamemode]
        mov ebx, 3
        mov edx, 13h
        mov eax, 0Ah
        call DrawSettingsHeading
        add esp, 120h
        jmp near LeagueSettingsDlg_ret0
%endif ; C
        db 08Dh,040h,00h
LeagueOptsToBits_jt:
        dd LeagueOptsToBits_n1
        dd LeagueOptsToBits_n0
        dd LeagueOptsToBits_n2
        dd LeagueOptsToBits_n0
        dd LeagueOptsToBits_n3
        dd LeagueOptsToBits_n0
        dd LeagueOptsToBits_n4
;-----------------------------------------------------------------------------
; LeagueOptsToBits                             7A88E  95 PC, medium confidence
; Packs gameopts bitfields into setbits
;-----------------------------------------------------------------------------
; C: src/pc/settings_dialogs/LeagueOptsToBits.c
%ifdef CBUILD
%include "c/pc/settings_dialogs/LeagueOptsToBits.inc"
%else
LeagueOptsToBits:
        push dword 8
        call __CHK
        push edx
        mov edx, dword [gameopts]
        shl edx, 1Eh
        shr edx, 1Fh
        add edx, edx
        mov eax, dword [gameopts]
        and eax, byte 1
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
        mov eax, dword [gameopts]
        shl eax, 11h
        shr eax, 1Dh
        dec eax
        cmp eax, byte 6
        ja short LeagueOptsToBits_n0
        jmp dword [nosplit cs:eax*4+LeagueOptsToBits_jt]
LeagueOptsToBits_n1:
        or byte [setbits+1], 10h
        jmp short LeagueOptsToBits_n0
LeagueOptsToBits_n2:
        or byte [setbits+1], 20h
        jmp short LeagueOptsToBits_n0
LeagueOptsToBits_n3:
        or byte [setbits+1], 40h
        jmp short LeagueOptsToBits_n0
LeagueOptsToBits_n4:
        or byte [setbits+1], 80h
LeagueOptsToBits_n0:
        call DrawLeagueSetChecks
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; LeagueSetHitTest                             7A9C8  95 PC, medium confidence
; Mouse hit-test over 27 rects at leaguesetrects
;-----------------------------------------------------------------------------
; C: src/pc/settings_dialogs/LeagueSetHitTest.c
%ifdef CBUILD
%include "c/pc/settings_dialogs/LeagueSetHitTest.inc"
%else
LeagueSetHitTest:
        push dword 10h
        call __CHK
        push ecx
        push esi
        push ebp
        mov ecx, eax
        mov esi, edx
        xor edx, edx
        lea ecx, [byte eax-06h]
        sub esi, byte 13h
.1:
        mov eax, edx
        shl eax, 4
        cmp ecx, dword [dword eax+leaguesetrects]
        jl short .2
        cmp ecx, dword [dword eax+leaguesetrects+8]
        jg short .2
        cmp esi, dword [dword eax+leaguesetrects+4]
        jl short .2
        cmp esi, dword [dword eax+leaguesetrects+0Ch]
        jle short .3
.2:
        inc edx
        cmp edx, byte 1Bh
        jl short LeagueSetHitTest.1
.3:
        cmp edx, byte 1Bh
        je near .11
        cmp edx, byte 10h
        jb short .5
        cmp edx, byte 11h
        jbe short .7
        cmp edx, byte 16h
        jb short .4
        jbe short .9
        cmp edx, byte 17h
        je near .12
        jmp near .13
.4:
        cmp edx, byte 15h
        je short .8
        jmp near .13
.5:
        cmp edx, byte 0Ah
        jb near .13
        cmp edx, byte 0Bh
        jbe short .11
        cmp dword [sounddev], byte 10h
.6:
        jne short .13
        jmp short .11
.7:
        cmp byte [musicon], 0
        jmp short LeagueSetHitTest.6
.8:
        mov ebp, dword [gamemode]
        cmp ebp, byte 1
        jne short .13
        cmp ebp, dword [seriesgameno]
        jg short .13
        jmp short .11
.9:
        cmp dword [gamemode], byte 1
        jne short .13
        cmp dword [seriesgameno], byte 3
.10:
        jl short .13
.11:
        xor edx, edx
        jmp short .14
.12:
        cmp dword [gamemode], byte 1
        jne short .13
        cmp dword [seriesgameno], byte 5
        jmp short LeagueSetHitTest.10
.13:
        mov dword [ebx], edx
        mov edx, 1
.14:
        mov eax, edx
        pop ebp
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawLeagueSetChecks                          7AAAA  95 PC, medium confidence
; Draws chkon/chkoff shapes per setbits bit
;-----------------------------------------------------------------------------
; C: src/pc/settings_dialogs/LeagueSettingsDlg.c (DrawLeagueSetChecks)
%ifdef CBUILD
%include "c/pc/settings_dialogs/LeagueSettingsDlg.DrawLeagueSetChecks.inc"
%else
DrawLeagueSetChecks:
        push dword 2Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov esi, leaguesetrects
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
        call sub_91FE0
        add esp, byte 0Ch
        mov edx, dword [esp]
        inc edx
        mov dword [esp], edx
        add esi, byte 20h
        cmp edx, byte 9
        jl short DrawLeagueSetChecks.1
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
        mov ebp, dword [pl20spr]
        push ebp
        jmp short .8
.6:
        mov eax, dword [byte esi+04h]
        add eax, byte 13h
        push eax
        mov eax, dword [esi]
        add eax, byte 0Ah
        push eax
        mov edi, dword [pl10spr]
        push edi
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
        call sub_91FE0
        add esp, byte 0Ch
.9:
        mov eax, dword [setbits]
        and eax, 0F000h
        add esi, byte 30h
        cmp eax, 2000h
        jb short .10
        jbe short .11
        cmp eax, 4000h
        jb near LeagueSettingsDlg_ret4
        jbe short .12
        cmp eax, 8000h
        je short .13
        jmp near LeagueSettingsDlg_ret4
.10:
        cmp eax, 1000h
        jne near LeagueSettingsDlg_ret4
        mov eax, dword [byte esi+04h]
        add eax, byte 13h
        push eax
        mov eax, dword [esi]
        add eax, byte 0Ah
        push eax
        mov ecx, dword [pg01spr]
        push ecx
        jmp short .14
.11:
        mov eax, dword [byte esi+04h]
        add eax, byte 13h
        push eax
        mov eax, dword [esi]
        add eax, byte 0Ah
        push eax
        mov ebx, dword [pg03spr]
        push ebx
        jmp short .14
.12:
        mov eax, dword [byte esi+04h]
        add eax, byte 13h
        push eax
        mov eax, dword [esi]
        add eax, byte 0Ah
        push eax
        mov edx, dword [pg05spr]
        push edx
        jmp short .14
.13:
        mov eax, dword [byte esi+04h]
        add eax, byte 13h
        push eax
        mov eax, dword [esi]
        add eax, byte 0Ah
        push eax
        mov eax, dword [pg07spr]
        push eax
.14:
        call sub_91FE0
        add esp, byte 0Ch
        jmp near LeagueSettingsDlg_ret4
%endif ; C
;-----------------------------------------------------------------------------
; LeagueSetViewLoop                            7AC31  95 PC, medium confidence
; Pointer loop without editing (show settings)
;-----------------------------------------------------------------------------
; C: src/pc/settings_dialogs/LeagueSettingsDlg.c (LeagueSetViewLoop)
%ifdef CBUILD
%include "c/pc/settings_dialogs/LeagueSettingsDlg.LeagueSetViewLoop.inc"
%else
LeagueSetViewLoop:
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
        call sub_B4BA8
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
        push str_Pointer15
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
        je short LeagueSetViewLoop.2
.3:
        cmp dword [esp], byte 0
        jne short .5
        mov eax, dword [byte esp+08h]
        cmp eax, dword [byte esp+010h]
        jne short .4
        mov eax, dword [byte esp+04h]
        cmp eax, dword [byte esp+0Ch]
        je short LeagueSetViewLoop.1
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
        jmp near LeagueSetViewLoop.1
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
        jmp near LeagueSettingsDlg_ret
%endif ; C
;-----------------------------------------------------------------------------
; LeagueSetEditLoop                            7ADD3  95 PC, medium confidence
; Pointer loop toggling setbits, writes gameopts
;-----------------------------------------------------------------------------
; C: src/pc/settings_dialogs/LeagueSettingsDlg.c (LeagueSetEditLoop)
%ifdef CBUILD
%include "c/pc/settings_dialogs/LeagueSettingsDlg.LeagueSetEditLoop.inc"
%else
LeagueSetEditLoop:
        push dword 44h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 1Ch
        test eax, eax
        je short .1
        push dlggreys
        push byte 4
        push dword 0F7h
        call VgaSetPalette
        add esp, byte 0Ch
.1:
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
        mov eax, dword [gameopts]
        shl eax, 19h
        shr eax, 1Fh
        mov dword [byte esp+018h], eax
        call sub_B4BA8
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
        push str_Pointer15
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
.2:
        xor esi, esi
        mov dword [byte esp+04h], esi
.3:
        call GetInputEvent
        test eax, eax
        je short .4
        lea ebx, [byte esp+08h]
        lea edx, [byte esp+0Ch]
        call dword [ptrupdatefn]
        mov dword [byte esp+04h], eax
        test al, 6
        je short LeagueSetEditLoop.3
.4:
        test byte [byte esp+04h], 6
        jne short .7
        mov eax, dword [byte esp+0Ch]
        cmp eax, dword [byte esp+014h]
        jne short .5
        mov eax, dword [byte esp+08h]
        cmp eax, dword [byte esp+010h]
        je short LeagueSetEditLoop.2
.5:
        mov ebx, dword [byte esp+010h]
        push ebx
        mov eax, dword [byte esp+018h]
        sub eax, byte 4
        push eax
        push ebp
        call PutBlock
        add esp, byte 0Ch
        mov ecx, dword [byte esp+08h]
        push ecx
        mov eax, dword [byte esp+010h]
        sub eax, byte 4
        push eax
        push ebp
        call GrabBlock
        add esp, byte 0Ch
        mov esi, dword [byte esp+08h]
        push esi
        mov eax, dword [byte esp+010h]
        sub eax, byte 4
        push eax
        mov edi, dword [pointerspr]
        push edi
.6:
        call DrawArt
        add esp, byte 0Ch
        mov eax, dword [byte esp+0Ch]
        mov dword [byte esp+014h], eax
        mov eax, dword [byte esp+08h]
        mov dword [byte esp+010h], eax
        jmp near LeagueSetEditLoop.2
.7:
        mov eax, dword [byte esp+014h]
        sub eax, byte 4
        mov dl, byte [byte esp+04h]
        test dl, 2
        je near .38
        mov esi, dword [byte esp+010h]
        push esi
        push eax
        push ebp
        call PutBlock
        add esp, byte 0Ch
        mov ebx, esp
        mov edx, dword [byte esp+08h]
        mov eax, dword [byte esp+0Ch]
        call LeagueSetHitTest
        test eax, eax
        je near .37
        mov edi, dword [esp]
        cmp edi, byte 12h
        jge near .11
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
        je near .36
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
        jmp near .36
.9:
        cmp byte [musicon], 0
        jne short .10
        cmp edi, byte 10h
        je near .36
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
        jmp near .36
.11:
        lea eax, [byte edi-09h]
        mov cl, al
        mov edx, 1
        shl edx, cl
        cmp edi, byte 15h
        jge short .12
        mov dword [esp], eax
        mov eax, dword [setbits]
        and eax, 0F1FFh
        jmp near .35
.12:
        cmp edi, byte 19h
        jl near .34
        jne near .31
        push dword 148h
        push byte 3Fh
        mov eax, dword [acptspr]
        push eax
        call sub_91FE0
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
        test cl, 4
        setne al
        and eax, byte 1
        and byte [gameopts], 0FBh
        shl eax, 2
        or dword [gameopts], eax
        mov dh, byte [setbits]
        test dh, 8
        setne al
        and eax, byte 1
        and byte [gameopts], 0F7h
        shl eax, 3
        or dword [gameopts], eax
        test dh, 10h
        setne al
        and eax, byte 1
        and byte [gameopts], 0EFh
        shl eax, 4
        or dword [gameopts], eax
        test dh, 20h
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
        test byte [sounddev], 22h
        je short .14
        test byte [setbits+1], 1
        setne al
        and eax, byte 1
        and byte [gameopts+1], 0FEh
        shl eax, 8
        or dword [gameopts], eax
.14:
        mov edx, dword [setbits]
        and edx, 0E00h
        mov eax, dword [gameopts]
        and ah, 0F3h
        cmp edx, 400h
        jb short .15
        jbe short .16
        cmp edx, 800h
        je short .17
        jmp short .18
.15:
        cmp edx, 200h
        jne short .18
        mov dword [gameopts], eax
        or ah, 8
        jmp short .17
.16:
        mov dword [gameopts], eax
        or ah, 4
.17:
        mov dword [gameopts], eax
.18:
        mov eax, dword [setbits]
        and eax, 0F000h
        mov edx, dword [gameopts]
        and dh, 8Fh
        cmp eax, 2000h
        jb short .19
        jbe short .21
        cmp eax, 4000h
        jb short .24
        jbe short .22
        cmp eax, 8000h
        je short .23
        jmp short .24
.19:
        cmp eax, 1000h
        jne short .24
        mov dword [gameopts], edx
        or dh, 10h
.20:
        mov dword [gameopts], edx
        jmp short .24
.21:
        mov dword [gameopts], edx
        or dh, 30h
        jmp short LeagueSetEditLoop.20
.22:
        mov dword [gameopts], edx
        or dh, 50h
        jmp short LeagueSetEditLoop.20
.23:
        or byte [gameopts+1], 70h
.24:
        test byte [gameopts], 40h
        je short .26
        cmp byte [musicon], 0
        je short .25
        cmp dword [songdata], byte 0
        je short .25
        cmp dword [byte esp+018h], byte 0
        jne short .25
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short .25
        mov edx, dword [musichandle]
        mov eax, dword [songdata]
        mov ecx, 7Fh
        mov ebx, 3
        call sub_8FB8E
.25:
        call sub_8F979
        jmp short .28
.26:
        cmp byte [musicon], 0
        je short .27
        cmp dword [songdata], byte 0
        je short .27
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        jne short .27
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 3
        call sub_8FCDF
.27:
        call sub_8F984
.28:
        test byte [gameopts], 80h
        je short .29
        call sub_8F963
        jmp short .30
.29:
        call sub_8F96E
.30:
        call WriteCurModeState
        jmp short .33
.31:
        push dword 148h
        push dword 89h
        mov edi, dword [fdlg_cancel]
        push edi
        call sub_91FE0
.32:
        add esp, byte 0Ch
.33:
        push ebp
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        add esp, byte 1Ch
        jmp near LeagueSettingsDlg_ret
.34:
        mov dword [esp], eax
        mov eax, dword [setbits]
        and eax, 0FFFh
.35:
        or eax, edx
        mov dword [setbits], eax
.36:
        call DrawLeagueSetChecks
.37:
        mov ebx, dword [byte esp+08h]
        push ebx
        mov eax, dword [byte esp+010h]
        sub eax, byte 4
        push eax
        push ebp
        call sub_96440
        add esp, byte 0Ch
        mov ecx, dword [byte esp+08h]
        push ecx
        mov eax, dword [byte esp+010h]
        sub eax, byte 4
        push eax
        mov esi, dword [pointerspr]
        push esi
        jmp near LeagueSetEditLoop.6
.38:
        test dl, 4
        je short .39
        mov ecx, dword [byte esp+010h]
        push ecx
        push eax
        push ebp
        call PutBlock
        jmp short LeagueSetEditLoop.32
.39:
        mov edi, dword [byte esp+010h]
        push edi
        push eax
        push ebp
        call PutBlock
        add esp, byte 0Ch
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
        jmp near LeagueSetEditLoop.6
%endif ; C
;-----------------------------------------------------------------------------
; SettingsStub                                                    7B39C  95 PC
; Empty __CHK/ret, unreferenced
;-----------------------------------------------------------------------------
; C: src/pc/settings_dialogs/SettingsStub.c
%ifdef CBUILD
%include "c/pc/settings_dialogs/SettingsStub.inc"
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
; C: src/pc/settings_dialogs/MenuModeSettings.c
%ifdef CBUILD
%include "c/pc/settings_dialogs/MenuModeSettings.inc"
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
        call sub_B4BA8
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
; C: src/pc/settings_dialogs/DrawModeSetDlg.c
%ifdef CBUILD
%include "c/pc/settings_dialogs/DrawModeSetDlg.inc"
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
        call sub_B4BA8
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
; C: src/pc/settings_dialogs/ModeOptsToBits.c
%ifdef CBUILD
%include "c/pc/settings_dialogs/ModeOptsToBits.inc"
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
        call sub_B4BA8
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ModeSetHitTest                               7B734  95 PC, medium confidence
; Hit-test over modesetrects
;-----------------------------------------------------------------------------
; C: src/pc/settings_dialogs/ModeSetHitTest.c
%ifdef CBUILD
%include "c/pc/settings_dialogs/ModeSetHitTest.inc"
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
; C: src/pc/settings_dialogs/DrawModeSetChecks.c
%ifdef CBUILD
%include "c/pc/settings_dialogs/DrawModeSetChecks.inc"
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
; C: src/pc/settings_dialogs/MenuModeSettings.c (ModeSetViewLoop)
%ifdef CBUILD
%include "c/pc/settings_dialogs/MenuModeSettings.ModeSetViewLoop.inc"
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
        call sub_B4BA8
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
; C: src/pc/settings_dialogs/MenuModeSettings.c (ModeSetEditLoop)
%ifdef CBUILD
%include "c/pc/settings_dialogs/MenuModeSettings.ModeSetEditLoop.inc"
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
        call sub_B4BA8
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
;-----------------------------------------------------------------------------
; MenuExhibitionSettings                       7BEBB  95 PC, medium confidence
; Menu action "Exhibition Settings ..."
;-----------------------------------------------------------------------------
; C: src/pc/settings_dialogs/MenuExhibitionSettings.c
%ifdef CBUILD
%include "c/pc/settings_dialogs/MenuExhibitionSettings.inc"
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
        call sub_B4BA8
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
; C: src/pc/settings_dialogs/MenuExhibitionSettings.c (ExhOptsToBits)
%ifdef CBUILD
%include "c/pc/settings_dialogs/MenuExhibitionSettings.ExhOptsToBits.inc"
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
; C: src/pc/settings_dialogs/MenuExhibitionSettings.c (DrawExhSetChecks)
%ifdef CBUILD
%include "c/pc/settings_dialogs/MenuExhibitionSettings.DrawExhSetChecks.inc"
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
; C: src/pc/settings_dialogs/DrawExhSetDlg.c
%ifdef CBUILD
%include "c/pc/settings_dialogs/DrawExhSetDlg.inc"
%else
DrawExhSetDlg:
        push dword 40h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        sub esp, byte 20h
        call sub_B4BA8
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
        call sub_91284
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
; C: src/pc/settings_dialogs/ExhSetHitTest.c
%ifdef CBUILD
%include "c/pc/settings_dialogs/ExhSetHitTest.inc"
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
; C: src/pc/settings_dialogs/MenuExhibitionSettings.c (ExhSetEditLoop)
%ifdef CBUILD
%include "c/pc/settings_dialogs/MenuExhibitionSettings.ExhSetEditLoop.inc"
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
        call sub_B4BA8
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
        call sub_8FB8E
.17:
        call sub_8F979
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
        call sub_8FCDF
.19:
        call sub_8F984
.20:
        test byte [gameopts], 80h
        je short .21
        call sub_8F963
        jmp short .22
.21:
        call sub_8F96E
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
        call sub_96440
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
;-----------------------------------------------------------------------------
; DrawCtlBoxOn                                 7C852  95 PC, medium confidence
; Draws selected box frame (colours by ctldlgalt)
;-----------------------------------------------------------------------------
; C: src/pc/settings_dialogs/MenuP1ControlsInGame.c (DrawCtlBoxOn)
%ifdef CBUILD
%include "c/pc/settings_dialogs/MenuP1ControlsInGame.DrawCtlBoxOn.inc"
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
        call sub_B4FAC
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
        call sub_B4FAC
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
        call sub_B4FAC
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
        call sub_B4FAC
        add esp, byte 14h
        jmp near ControlsDlg_ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawCtlBoxOff                                7C901  95 PC, medium confidence
; Draws unselected box frame
;-----------------------------------------------------------------------------
; C: src/pc/settings_dialogs/MenuP1ControlsInGame.c (DrawCtlBoxOff)
%ifdef CBUILD
%include "c/pc/settings_dialogs/MenuP1ControlsInGame.DrawCtlBoxOff.inc"
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
        call sub_B4FAC
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
        call sub_B4FAC
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
        call sub_B4FAC
        add esp, byte 14h
        push ebp
        jmp near DrawCtlBox_common
%endif ; C
;-----------------------------------------------------------------------------
; MenuP1ControlsExh                            7C993  95 PC, medium confidence
; "Player 1 Controls ..." exhibition menu, eax=0
;-----------------------------------------------------------------------------
; C: src/pc/settings_dialogs/MenuP1ControlsInGame.c (MenuP1ControlsExh)
%ifdef CBUILD
%include "c/pc/settings_dialogs/MenuP1ControlsInGame.MenuP1ControlsExh.inc"
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
; C: src/pc/settings_dialogs/MenuP1ControlsInGame.c (MenuP2ControlsExh)
%ifdef CBUILD
%include "c/pc/settings_dialogs/MenuP1ControlsInGame.MenuP2ControlsExh.inc"
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
; C: src/pc/settings_dialogs/MenuP1ControlsInGame.c (MenuP1ControlsLeague)
%ifdef CBUILD
%include "c/pc/settings_dialogs/MenuP1ControlsInGame.MenuP1ControlsLeague.inc"
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
; C: src/pc/settings_dialogs/MenuP1ControlsInGame.c (MenuP2ControlsLeague)
%ifdef CBUILD
%include "c/pc/settings_dialogs/MenuP1ControlsInGame.MenuP2ControlsLeague.inc"
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
; C: src/pc/settings_dialogs/MenuP1ControlsInGame.c
%ifdef CBUILD
%include "c/pc/settings_dialogs/MenuP1ControlsInGame.inc"
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
; C: src/pc/settings_dialogs/MenuP1ControlsInGame.c (MenuP2ControlsInGame)
%ifdef CBUILD
%include "c/pc/settings_dialogs/MenuP1ControlsInGame.MenuP2ControlsInGame.inc"
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
; C: src/pc/settings_dialogs/MenuP1ControlsInGame.c (CtlSwapScoreFix)
%ifdef CBUILD
%include "c/pc/settings_dialogs/MenuP1ControlsInGame.CtlSwapScoreFix.inc"
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
; C: src/pc/settings_dialogs/MenuP1ControlsInGame.c (CtlSwapTeamFlag)
%ifdef CBUILD
%include "c/pc/settings_dialogs/MenuP1ControlsInGame.CtlSwapTeamFlag.inc"
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
; C: src/pc/settings_dialogs/MenuP1ControlsInGame.c (ClearCtlBlink)
%ifdef CBUILD
%include "c/pc/settings_dialogs/MenuP1ControlsInGame.ClearCtlBlink.inc"
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
; C: src/pc/settings_dialogs/MenuP1ControlsInGame.c (ControlsDlgInGame_side)
%ifdef CBUILD
%include "c/pc/settings_dialogs/MenuP1ControlsInGame.ControlsDlgInGame_side.inc"
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
; C: src/pc/settings_dialogs/MenuP1ControlsInGame.c (MenuP1ControlsPlayoff)
%ifdef CBUILD
%include "c/pc/settings_dialogs/MenuP1ControlsInGame.MenuP1ControlsPlayoff.inc"
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
; C: src/pc/settings_dialogs/MenuP1ControlsInGame.c (MenuP2ControlsPlayoff)
%ifdef CBUILD
%include "c/pc/settings_dialogs/MenuP1ControlsInGame.MenuP2ControlsPlayoff.inc"
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
; C: src/pc/settings_dialogs/MenuP1ControlsInGame.c (DrawControlsDlg)
%ifdef CBUILD
%include "c/pc/settings_dialogs/MenuP1ControlsInGame.DrawControlsDlg.inc"
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
        call sub_B4BA8
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
; C: src/pc/settings_dialogs/MenuP1ControlsInGame.c (DrawControlsOpts)
%ifdef CBUILD
%include "c/pc/settings_dialogs/MenuP1ControlsInGame.DrawControlsOpts.inc"
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
; C: src/pc/settings_dialogs/CtlDlgHitTest.c
%ifdef CBUILD
%include "c/pc/settings_dialogs/CtlDlgHitTest.inc"
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
; C: src/pc/settings_dialogs/DrawCtlBoxes.c
%ifdef CBUILD
%include "c/pc/settings_dialogs/DrawCtlBoxes.inc"
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
; C: src/pc/settings_dialogs/MenuP1ControlsInGame.c (ControlsDlgLoop)
%ifdef CBUILD
%include "c/pc/settings_dialogs/MenuP1ControlsInGame.ControlsDlgLoop.inc"
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
; C: src/pc/settings_dialogs/SetCtlTeams.c
%ifdef CBUILD
%include "c/pc/settings_dialogs/SetCtlTeams.inc"
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
