; League and playoff settings dialogs (PC only).
bits 32
%include "hockey.inc"
section s_7A13A progbits alloc exec nowrite align=1
extern __CHK, acptspr, AllocMemBlock, cddriveptr, chkoffspr, chkonspr, ClearInputQueue, dlggreys
extern DrawArt, DrawArtMasked, DrawSettingsHeading, exhstate, fdlg_cancel, fileoncd, FindShape, FreeMemBlock
extern gamemode, gameopts, GetInputEvent, GrabBlock, leaguesetimg, leaguesetrects, LoadBank, LoadModeState
extern LoadSettingsShapes, MakePath, MouseRead, musichandle, MusicOn, musicslot, na01spr, na03spr
extern na05spr, pg01spr, pg03spr, pg05spr, pg07spr, pl05spr, pl10spr, pl20spr
extern pointerspr, postate, PrintString, ptrupdatefn, PutBlock, SaveModeState, seriesgameno, setbits
extern SetColorRemap, settingsfile, SndQuery, songdata, sounddev, str_BKGD, str_Dbox2, str_DigitizedSpeech
extern str_Music, str_Pointer15, str_Setting3, str_Setting5, str_Sound, EnableMidiSfx, DisableMidiSfx, EnableMidiMusic
extern DisableMidiMusic, PlayDigiBlockLoop, SetDigiChannelVolume, DrawArtKeyFF, DrawArtKeyColour, DrawShapeClippedKeyed, SetScreenTarget, TextSetColors
extern VgaSetPalette, WriteCurModeState, WriteModeState
global LeagueSettingsDlg, LeagueSettingsDlg_ret4, LeagueSettingsDlg_ret, LeagueSettingsDlg_ret0, MenuPlayoffSettings, MenuPlayoffSettings_edit, SettingsDlgClose, EditPlayoffSettings
global MenuLeagueSettingsEdit, MenuShowLeagueSettings, MenuShowLeagueSettings2, DrawLeagueSetDlgSel, SetLeagueSetImage, DrawLeagueSetDlg, LeagueOptsToBits_jt, LeagueOptsToBits
global LeagueOptsToBits_n1, LeagueOptsToBits_n2, LeagueOptsToBits_n3, LeagueOptsToBits_n4, LeagueOptsToBits_n0, LeagueSetHitTest, DrawLeagueSetChecks, LeagueSetViewLoop
global LeagueSetEditLoop
;-----------------------------------------------------------------------------
; LeagueSettingsDlg                            7A13A  95 PC, medium confidence
; Called by MenuLeagueSettings; BKGD+setting3 dialog, preserves seriesgameno
;-----------------------------------------------------------------------------
; C: src/pc/league_settings/LeagueSettingsDlg.c
%ifdef CBUILD
%include "c/pc/league_settings/LeagueSettingsDlg.inc"
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
        call SetScreenTarget
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
; C: src/pc/league_settings/LeagueSettingsDlg.c (MenuPlayoffSettings)
%ifdef CBUILD
%include "c/pc/league_settings/LeagueSettingsDlg.MenuPlayoffSettings.inc"
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
        call SetScreenTarget
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
; C: src/pc/league_settings/LeagueSettingsDlg.c (EditPlayoffSettings)
%ifdef CBUILD
%include "c/pc/league_settings/LeagueSettingsDlg.EditPlayoffSettings.inc"
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
        call SetScreenTarget
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
; C: src/pc/league_settings/LeagueSettingsDlg.c (MenuLeagueSettingsEdit)
%ifdef CBUILD
%include "c/pc/league_settings/LeagueSettingsDlg.MenuLeagueSettingsEdit.inc"
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
        call SetScreenTarget
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
; C: src/pc/league_settings/LeagueSettingsDlg.c (MenuShowLeagueSettings)
%ifdef CBUILD
%include "c/pc/league_settings/LeagueSettingsDlg.MenuShowLeagueSettings.inc"
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
; C: src/pc/league_settings/LeagueSettingsDlg.c (MenuShowLeagueSettings2)
%ifdef CBUILD
%include "c/pc/league_settings/LeagueSettingsDlg.MenuShowLeagueSettings2.inc"
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
        call SetScreenTarget
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
        cmp byte [MusicOn], 0
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
; C: src/pc/league_settings/DrawLeagueSetDlgSel.c
%ifdef CBUILD
%include "c/pc/league_settings/DrawLeagueSetDlgSel.inc"
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
        call SetScreenTarget
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
        call DrawArtKeyFF
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
        cmp byte [MusicOn], 0
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
        call SetScreenTarget
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
; C: src/pc/league_settings/SetLeagueSetImage.c
%ifdef CBUILD
%include "c/pc/league_settings/SetLeagueSetImage.inc"
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
; C: src/pc/league_settings/LeagueSettingsDlg.c (DrawLeagueSetDlg)
%ifdef CBUILD
%include "c/pc/league_settings/LeagueSettingsDlg.DrawLeagueSetDlg.inc"
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
        call SetScreenTarget
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
        cmp byte [MusicOn], 0
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
        call DrawArtKeyColour
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
LeagueOptsToBits_jt:                            ; used by LeagueOptsToBits
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
; C: src/pc/league_settings/LeagueOptsToBits.c
%ifdef CBUILD
%include "c/pc/league_settings/LeagueOptsToBits.inc"
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
; C: src/pc/league_settings/LeagueSetHitTest.c
%ifdef CBUILD
%include "c/pc/league_settings/LeagueSetHitTest.inc"
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
        cmp byte [MusicOn], 0
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
; C: src/pc/league_settings/LeagueSettingsDlg.c (DrawLeagueSetChecks)
%ifdef CBUILD
%include "c/pc/league_settings/LeagueSettingsDlg.DrawLeagueSetChecks.inc"
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
        call DrawArtKeyColour
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
        call DrawArtKeyColour
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
        call DrawArtKeyColour
        add esp, byte 0Ch
        jmp near LeagueSettingsDlg_ret4
%endif ; C
;-----------------------------------------------------------------------------
; LeagueSetViewLoop                            7AC31  95 PC, medium confidence
; Pointer loop without editing (show settings)
;-----------------------------------------------------------------------------
; C: src/pc/league_settings/LeagueSettingsDlg.c (LeagueSetViewLoop)
%ifdef CBUILD
%include "c/pc/league_settings/LeagueSettingsDlg.LeagueSetViewLoop.inc"
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
; C: src/pc/league_settings/LeagueSettingsDlg.c (LeagueSetEditLoop)
%ifdef CBUILD
%include "c/pc/league_settings/LeagueSettingsDlg.LeagueSetEditLoop.inc"
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
        cmp byte [MusicOn], 0
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
        cmp byte [MusicOn], 0
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
        call DrawArtKeyColour
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
        cmp byte [MusicOn], 0
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
        call PlayDigiBlockLoop
.25:
        call EnableMidiMusic
        jmp short .28
.26:
        cmp byte [MusicOn], 0
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
        call SetDigiChannelVolume
.27:
        call DisableMidiMusic
.28:
        test byte [gameopts], 80h
        je short .29
        call EnableMidiSfx
        jmp short .30
.29:
        call DisableMidiSfx
.30:
        call WriteCurModeState
        jmp short .33
.31:
        push dword 148h
        push dword 89h
        mov edi, dword [fdlg_cancel]
        push edi
        call DrawArtKeyColour
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
        call DrawShapeClippedKeyed
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
