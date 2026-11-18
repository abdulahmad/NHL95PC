; The pre-game locker room and the settings art.
bits 32
%include "hockey.inc"
section s_8034B progbits alloc exec nowrite align=1
extern __CHK, acptspr, sndcardmissing, homeremap, homeremap_e05, homeremap_e07, homeremap_e10, homeremap_e11
extern homeremap_e13, homeremap_e14, homeremap_e16, homeremap_e49, homeremap_e50, homeremap_e51, homeremap_e60, homeremap_eFB
extern homeremap_eFC, homeremap_eFD, homeremap_eFE, cddriveptr, chkoffspr, chkonspr, ClearInputQueue, cont2team
extern ctl1side, ctl1team, ctl2side, ctl2team, lockerindex, lockerteams, poroundnameidx, lockeracceptx
extern lockeraccepty, lockercancelx, lockercancely, sndtempbuf, FadeOutPalCycle, FadePalStep, fdlg_cancel, fileoncd
extern fputchar, FreeMemBlock, gamemode, gameopts, GetInputEvent, homebckspr, homenamebckspr, HomeTeam
extern kaufmfont, lockerrects, mainfont, MakePath, modesetlabel, MouseSetPos, musichandle, MusicOn
extern musicslot, na01spr, na03spr, na05spr, menutext_deskreturn, menutext_desktodesk, jerseyabbrevs, poroundnames
extern pg01spr, pg03spr, pg05spr, pg07spr, pl05spr, pl10spr, pl20spr, pointerspr
extern PrintOutlinedText, PrintShadowText, ptrupdatefn, s1font, setbits, SetTextColors, settingsfile, ShowLoadingScreen
extern songdata, SoundCardDlgLoop, soundcardrects, sounddev, sprintf_, str_00002, str_Accept, str_Acpt
extern str_ADLib, str_Buffer, str_Canc, str_Cancel2, str_Dbx2, str_Exhibition2, str_ExhibitionGame, str_HomeBck
extern str_HomeNameBck, str_HomeTeam, str_Iff11, str_Jersey, str_JERSH, str_JERSV, str_LAAtMTL, str_League2
extern str_Lockroom, str_MT32, str_Na01, str_Na03, str_Na05, str_Off, str_On, str_P01
extern str_PCSpeaker, str_Pg01, str_Pg03, str_Pg05, str_Pg07, str_Pl05, str_Pl10, str_Pl20
extern str_Playoff, str_PlayoffTree2, str_Pointer20, str_Return, str_Room, str_Settings, str_Settings3, str_ShowLeague
extern str_Sound4, str_SoundBlaster, str_SportsCentral2, str_Temp8, str_TitleBck, str_UltraSound, str_VisBck, str_VisitingTeam
extern str_VisNameBck, str_Vs, strcpy_, strncpy_, AllocMemBlock, PushMemDescriptorLocked, LoadBank, TextSetColors
extern TextSaveState, TextRestoreState, TextSetFont, LoadDigiFile, PlayDigiBlockLoop, SndQuery, SetDigiChannelVolume, SetPalette
extern PutBlock, FillRect, DrawArtOpaque, DrawArtKeyFF, DrawArtKeyFFAtOwnPos, GrabBlock, PrintString, DrawArtKeyColour
extern MouseRead, FindShape, VgaSetPalette, SetScreenTarget, SetColorRemap, FillRectColor, PlotPixel, teamcitynames
extern teamdivflags, titlebckspr, visbckspr, visnamebckspr, VisTeam, WriteCurModeState
global LoadSettingsShapes, DrawSettingsHeading_jt, DrawSettingsHeading, DrawSettingsHeading_n0, DrawSettingsHeading_n1, SetModeMenuLabels, DrawPanel3D, DrawPanel3D_ret
global LockerRoomScreen, LockerRoomScreenEpilogue, DrawLockerRoom, LockerHitTest, DrawLockerJersey, LockerRoomLoop_jt, LockerRoomLoop, LockerRoomLoop_n2
global LockerRoomLoop_n0, LockerRoomLoop_n4, LockerRoomLoop_n1, LockerRoomLoop_n6, LockerRoomLoop_n7, DrawSelBoxOn, DrawSelBox_common, DrawSelBoxOff
;-----------------------------------------------------------------------------
; LoadSettingsShapes                           8034B  95 PC, medium confidence
; Loads "settings" PPV once (settingsfile) and its On/Off/acpt/canc/na/pg/pl
; shapes
;-----------------------------------------------------------------------------
; C: src/front/lockerroom/LoadSettingsShapes.c
%ifdef CBUILD
%include "c/front/lockerroom/LoadSettingsShapes.inc"
%else
LoadSettingsShapes:
        push dword 44h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 20h
        mov edx, dword [settingsfile]
        test edx, edx
        jne near .x
        xor ecx, ecx
        mov ebx, str_Settings
        cmp byte [fileoncd+01C5h], 1
        jne short .1
        mov edx, dword [cddriveptr]
.1:
        mov eax, esp
        call MakePath
        push byte 0
        lea eax, [byte esp+04h]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [settingsfile], eax
        push str_On
        push eax
        call FindShape
        add esp, byte 8
        mov dword [chkonspr], eax
        push str_Off
        mov ebx, dword [settingsfile]
        push ebx
        call FindShape
        add esp, byte 8
        mov dword [chkoffspr], eax
        push str_Acpt
        mov ecx, dword [settingsfile]
        push ecx
        call FindShape
        add esp, byte 8
        mov dword [acptspr], eax
        push str_Canc
        mov esi, dword [settingsfile]
        push esi
        call FindShape
        add esp, byte 8
        mov dword [fdlg_cancel], eax
        push str_Na01
        mov edi, dword [settingsfile]
        push edi
        call FindShape
        add esp, byte 8
        mov dword [na01spr], eax
        push str_Na03
        mov ebp, dword [settingsfile]
        push ebp
        call FindShape
        add esp, byte 8
        mov dword [na03spr], eax
        push str_Na05
        mov eax, dword [settingsfile]
        push eax
        call FindShape
        add esp, byte 8
        mov dword [na05spr], eax
        push str_Pg01
        mov edx, dword [settingsfile]
        push edx
        call FindShape
        add esp, byte 8
        mov dword [pg01spr], eax
        push str_Pg03
        mov ebx, dword [settingsfile]
        push ebx
        call FindShape
        add esp, byte 8
        mov dword [pg03spr], eax
        push str_Pg05
        mov ecx, dword [settingsfile]
        push ecx
        call FindShape
        add esp, byte 8
        mov dword [pg05spr], eax
        push str_Pg07
        mov esi, dword [settingsfile]
        push esi
        call FindShape
        add esp, byte 8
        mov dword [pg07spr], eax
        push str_Pl05
        mov edi, dword [settingsfile]
        push edi
        call FindShape
        add esp, byte 8
        mov dword [pl05spr], eax
        push str_Pl10
        mov ebp, dword [settingsfile]
        push ebp
        call FindShape
        add esp, byte 8
        mov dword [pl10spr], eax
        push str_Pl20
        mov eax, dword [settingsfile]
        push eax
        call FindShape
        add esp, byte 8
        mov dword [pl20spr], eax
.x:
        add esp, byte 20h
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
        db 08Bh,0C0h
DrawSettingsHeading_jt:                         ; used by DrawSettingsHeading
        dd DrawSettingsHeading_n0
        dd DrawSettingsHeading_n1
        dd DrawSettingsHeading_n0
        dd DrawSettingsHeading_n1
;-----------------------------------------------------------------------------
; DrawSettingsHeading                          8050F  95 PC, medium confidence
; Prints Exhibition / Playoff / League heading text in dialog (jump table by
; mode)
;-----------------------------------------------------------------------------
; C: src/front/lockerroom/DrawSettingsHeading.c
%ifdef CBUILD
%include "c/front/lockerroom/DrawSettingsHeading.inc"
%else
DrawSettingsHeading:
        push dword 60h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 44h
        mov esi, eax
        mov edi, edx
        mov dword [byte esp+040h], ebx
        mov ebp, ecx
        mov eax, esp
        push eax
        call TextSaveState
        add esp, byte 4
        mov edx, dword [s1font]
        push edx
        call TextSetFont
        add esp, byte 4
        push dword 0FFh
        mov ebx, dword [byte esp+058h]
        push ebx
        call TextSetColors
        add esp, byte 8
        add edi, byte 16h
        mov eax, dword [byte esp+040h]
        sub eax, byte 3
        cmp eax, byte 3
        ja short DrawSettingsHeading_n1.1
        jmp dword [nosplit cs:eax*4+DrawSettingsHeading_jt]
DrawSettingsHeading_n0:
        add esi, byte 59h
        jmp short DrawSettingsHeading_n1.1
DrawSettingsHeading_n1:
        add esi, byte 51h
.1:
        cmp ebp, byte 1
        jb short .2
        jbe short .3
        cmp ebp, byte 2
        je short .4
        jmp short .6
.2:
        test ebp, ebp
        jne short .6
        push edi
        sub esi, byte 41h
        push esi
        push str_Exhibition2
        jmp short .5
.3:
        push edi
        sub esi, byte 32h
        push esi
        push str_Playoff
        jmp short .5
.4:
        push edi
        sub esi, byte 2Fh
        push esi
        push str_League2
.5:
        call PrintString
        add esp, byte 0Ch
.6:
        mov eax, esp
        push eax
        call TextRestoreState
        add esp, byte 4
        add esp, byte 44h
        pop ebp
        pop edi
        pop esi
        ret 4
%endif ; C
;-----------------------------------------------------------------------------
; SetModeMenuLabels                            805C4  95 PC, medium confidence
; Strcpy mode name + " Settings ..." into the menu label, sets Sports Central
; / Playoff Tree entries
;-----------------------------------------------------------------------------
; C: src/front/lockerroom/SetModeMenuLabels.c
%ifdef CBUILD
%include "c/front/lockerroom/SetModeMenuLabels.inc"
%else
SetModeMenuLabels:
        push dword 10h
        call __CHK
        push ecx
        push edx
        push edi
        cmp eax, byte 1
        jb short .1
        jbe short .2
        cmp eax, byte 2
        je short .3
        pop edi
        pop edx
        pop ecx
        ret
.1:
        test eax, eax
        jne near .x
        mov edx, str_Exhibition2
        mov eax, modesetlabel
        call strcpy_
        mov edx, str_Settings3
        mov eax, modesetlabel+0Ah
        call strcpy_
        mov edi, str_SportsCentral2
        mov dword [menutext_deskreturn], edi
        mov dword [menutext_desktodesk], edi
        pop edi
        pop edx
        pop ecx
        ret
.2:
        mov edx, str_Playoff
        mov eax, modesetlabel
        call strcpy_
        mov edx, str_Settings3
        mov eax, modesetlabel+7
        call strcpy_
        mov ecx, str_PlayoffTree2
        mov dword [menutext_deskreturn], ecx
        mov dword [menutext_desktodesk], ecx
        pop edi
        pop edx
        pop ecx
        ret
.3:
        mov edx, str_ShowLeague
        mov eax, modesetlabel
        call strcpy_
        mov edx, str_Settings3
        mov eax, modesetlabel+0Bh
        call strcpy_
        mov edx, str_Return
        mov dword [menutext_deskreturn], edx
        mov dword [menutext_desktodesk], edx
.x:
        pop edi
        pop edx
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawPanel3D                                  80682  95 PC, medium confidence
; Filled rect (70h) with light 77h / dark 62h edges, optional inner frame
;-----------------------------------------------------------------------------
; C: src/front/lockerroom/DrawPanel3D.c
%ifdef CBUILD
%include "c/front/lockerroom/DrawPanel3D.inc"
%else
DrawPanel3D:
        push dword 38h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 14h
        mov edi, eax
        mov esi, edx
        mov ebp, ebx
        mov dword [byte esp+010h], ecx
        push byte 70h
        mov eax, ecx
        sub eax, edx
        inc eax
        push eax
        mov eax, ebx
        sub eax, edi
        inc eax
        push eax
        push edx
        push edi
        call FillRect
        add esp, byte 14h
        push byte 77h
        push esi
        push ebp
        push esi
        push edi
        call FillRectColor
        add esp, byte 14h
        push byte 77h
        mov edx, dword [byte esp+014h]
        push edx
        push edi
        push esi
        push edi
        call FillRectColor
        add esp, byte 14h
        push byte 62h
        mov ebx, dword [byte esp+014h]
        push ebx
        push ebp
        push esi
        push ebp
        call FillRectColor
        add esp, byte 14h
        push byte 62h
        mov ecx, dword [byte esp+014h]
        push ecx
        push ebp
        push ecx
        push edi
        call FillRectColor
        add esp, byte 14h
        cmp dword [byte esp+024h], byte 0
        je near .1
        push byte 77h
        mov eax, esi
        add eax, byte 2
        mov dword [byte esp+04h], eax
        push eax
        mov eax, edi
        add eax, byte 2
        mov dword [byte esp+0Ch], eax
        push eax
        call PlotPixel
        add esp, byte 0Ch
        push byte 77h
        add esi, byte 3
        push esi
        add edi, byte 3
        push edi
        call PlotPixel
        add esp, byte 0Ch
        push byte 62h
        mov eax, dword [byte esp+04h]
        push eax
        push edi
        call PlotPixel
        add esp, byte 0Ch
        push byte 62h
        push esi
        mov edx, dword [byte esp+0Ch]
        push edx
        call PlotPixel
        add esp, byte 0Ch
        push byte 62h
        mov eax, dword [byte esp+014h]
        sub eax, byte 2
        mov dword [byte esp+0Ch], eax
        push eax
        mov ecx, dword [byte esp+0Ch]
        push ecx
        call PlotPixel
        add esp, byte 0Ch
        push byte 62h
        mov eax, dword [byte esp+014h]
        sub eax, byte 3
        mov dword [byte esp+010h], eax
        push eax
        push edi
        call PlotPixel
        add esp, byte 0Ch
        push byte 77h
        mov edx, dword [byte esp+0Ch]
        push edx
        push edi
        call PlotPixel
        add esp, byte 0Ch
        push byte 77h
        mov ebx, dword [byte esp+010h]
        push ebx
        mov ecx, dword [byte esp+0Ch]
        push ecx
        call PlotPixel
        add esp, byte 0Ch
        push byte 77h
        mov edi, dword [byte esp+04h]
        push edi
        lea edi, [byte ebp-03h]
        push edi
        call PlotPixel
        add esp, byte 0Ch
        push byte 77h
        push esi
        sub ebp, byte 2
        push ebp
        call PlotPixel
        add esp, byte 0Ch
        push byte 62h
        mov eax, dword [byte esp+04h]
        push eax
        push ebp
        call PlotPixel
        add esp, byte 0Ch
        push byte 62h
        push esi
        push edi
        call PlotPixel
        add esp, byte 0Ch
        push byte 62h
        mov edx, dword [byte esp+0Ch]
        push edx
        push edi
        call PlotPixel
        add esp, byte 0Ch
        push byte 62h
        mov ebx, dword [byte esp+010h]
        push ebx
        push ebp
        call PlotPixel
        add esp, byte 0Ch
        push byte 77h
        mov ecx, dword [byte esp+0Ch]
        push ecx
        push ebp
        call PlotPixel
        add esp, byte 0Ch
        push byte 77h
        mov esi, dword [byte esp+010h]
        push esi
        push edi
        call PlotPixel
        add esp, byte 0Ch
.1:
        add esp, byte 14h
DrawPanel3D_ret:
        pop ebp
        pop edi
        pop esi
        ret 4
%endif ; C
;-----------------------------------------------------------------------------
; LockerRoomScreen                             80830  95 PC, medium confidence
; Menu "Game: LA  at MTL ..." pre-game locker room: stops music, loads
; Home/Vis/Name/Title backgrounds, draw + loop
;-----------------------------------------------------------------------------
; C: src/front/lockerroom/LockerRoomScreen.c
%ifdef CBUILD
%include "c/front/lockerroom/LockerRoomScreen.inc"
%else
LockerRoomScreen:
        push dword 368h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, 340h
        cmp byte [MusicOn], 0
        je short .1
        cmp dword [songdata], byte 0
        je short .1
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 3
        call SetDigiChannelVolume
.1:
        mov eax, esp
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, esp
        mov eax, 1
        call FadePalStep
        cmp byte [MusicOn], 0
        je short .3
        cmp dword [songdata], byte 0
        je short .3
.2:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short LockerRoomScreen.2
        mov ecx, dword [songdata]
        push ecx
        call PushMemDescriptorLocked
        add esp, byte 4
        xor esi, esi
        mov dword [songdata], esi
.3:
        call ShowLoadingScreen
        lea eax, [dword esp+0300h]
        push eax
        call TextSaveState
        add esp, byte 4
        push byte 20h
        push dword 1B811h
        push str_HomeBck
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [homebckspr], eax
        push byte 20h
        push dword 1A6F9h
        push str_VisBck
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [visbckspr], eax
        mov esi, dword [pointerspr]
        mov edi, dword [homebckspr]
        movsd
        movsd
        movsd
        movsd
        movsb
        mov esi, dword [pointerspr]
        mov edi, dword [visbckspr]
        movsd
        movsd
        movsd
        movsd
        movsb
        mov eax, dword [homebckspr]
        mov word [byte eax+04h], 140h
        mov eax, dword [visbckspr]
        mov word [byte eax+04h], 138h
        mov eax, dword [homebckspr]
        mov word [byte eax+06h], 160h
        mov eax, dword [visbckspr]
        mov word [byte eax+06h], 15Bh
        push byte 20h
        push dword 0A07h
        push str_HomeNameBck
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [homenamebckspr], eax
        push byte 20h
        push dword 0A07h
        push str_VisNameBck
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [visnamebckspr], eax
        mov esi, dword [pointerspr]
        mov edi, dword [homenamebckspr]
        movsd
        movsd
        movsd
        movsd
        movsb
        mov esi, dword [pointerspr]
        mov edi, dword [visnamebckspr]
        movsd
        movsd
        movsd
        movsd
        movsb
        mov eax, dword [homenamebckspr]
        mov word [byte eax+04h], 0AAh
        mov eax, dword [visnamebckspr]
        mov word [byte eax+04h], 0AAh
        mov eax, dword [homenamebckspr]
        mov word [byte eax+06h], 0Fh
        mov eax, dword [visnamebckspr]
        mov word [byte eax+06h], 0Fh
        push byte 20h
        push dword 35C7h
        push str_TitleBck
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [titlebckspr], eax
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov eax, dword [titlebckspr]
        mov word [byte eax+04h], 226h
        mov eax, dword [titlebckspr]
        mov word [byte eax+06h], 19h
        call DrawLockerRoom
        call LockerRoomLoop
        mov esi, eax
        mov edi, dword [titlebckspr]
        push edi
        call FreeMemBlock
        add esp, byte 4
        mov ebp, dword [homenamebckspr]
        push ebp
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [visnamebckspr]
        push eax
        call FreeMemBlock
        add esp, byte 4
        mov edx, dword [homebckspr]
        push edx
        call FreeMemBlock
        add esp, byte 4
        mov ebx, dword [visbckspr]
        push ebx
        call FreeMemBlock
        add esp, byte 4
        lea eax, [dword esp+0300h]
        push eax
        call TextRestoreState
        add esp, byte 4
        cmp dword [gamemode], byte 0
        jne short .4
        mov eax, 2
        jmp short .5
.4:
        mov eax, esi
.5:
        add esp, 340h
;-----------------------------------------------------------------------------
; LockerRoomScreenEpilogue                                                      80A9D  95 PC
; Lone ret
;-----------------------------------------------------------------------------
LockerRoomScreenEpilogue:
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawLockerRoom                               80AA4  95 PC, medium confidence
; Lockroom image, team names, jerseys, Accept / Cancel, "Exhibition Game"
;-----------------------------------------------------------------------------
; C: src/front/lockerroom/LockerRoomScreen.c (DrawLockerRoom)
%ifdef CBUILD
%include "c/front/lockerroom/LockerRoomScreen.DrawLockerRoom.inc"
%else
DrawLockerRoom:
        push dword 384h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, 354h
        call SetScreenTarget
        xor ecx, ecx
        mov ebx, str_Lockroom
        cmp byte [fileoncd+0E9h], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
        lea eax, [dword esp+0300h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0304h]
        push eax
        call LoadBank
        add esp, byte 8
        mov esi, eax
        push str_P01
        push eax
        call FindShape
        add esp, byte 8
        lea edx, [byte eax+010h]
        xor ebx, ebx
        mov dword [dword esp+0350h], ebx
        mov bh, 3Fh
.3:
        mov eax, dword [dword esp+0350h]
        add eax, edx
        mov ecx, dword [dword esp+0350h]
        cmp ecx, 168h
        jge short .5
        mov bl, byte [eax]
        cmp bl, 3Bh
        jge short .4
        mov al, bl
        add al, 5
        jmp short .6
.4:
        mov byte [esp+ecx], bh
        jmp short .7
.5:
        mov al, byte [eax]
.6:
        mov byte [esp+ecx], al
.7:
        mov edi, dword [dword esp+0350h]
        inc edi
        mov dword [dword esp+0350h], edi
        cmp edi, 180h
        jl short DrawLockerRoom.3
        call FadeOutPalCycle
        push str_Room
        push esi
        call FindShape
        add esp, byte 8
        push eax
        call DrawArtKeyFFAtOwnPos
        add esp, byte 4
        push esi
        call FreeMemBlock
        add esp, byte 4
        push byte 1
        mov ecx, 1E0h
        mov ebx, 27Fh
        mov edx, 1A7h
        xor eax, eax
        call DrawPanel3D
        mov dword [dword esp+0350h], 2
.8:
        push byte 0
        mov eax, dword [dword esp+0354h]
        shl eax, 4
        mov ecx, dword [dword eax+lockerrects+0Ch]
        mov ebx, dword [dword eax+lockerrects+8]
        mov edx, dword [dword eax+lockerrects+4]
        mov eax, dword [dword eax+lockerrects]
        call DrawPanel3D
        mov edx, dword [dword esp+0350h]
        inc edx
        mov dword [dword esp+0350h], edx
        cmp edx, byte 8
        jl short DrawLockerRoom.8
        push byte 11h
        push byte 2Dh
        mov ecx, dword [titlebckspr]
        push ecx
        call GrabBlock
        add esp, byte 0Ch
        push byte 45h
        push byte 0Ah
        mov esi, dword [homebckspr]
        push esi
        call GrabBlock
        add esp, byte 0Ch
        push byte 4Ah
        push dword 146h
        mov edi, dword [visbckspr]
        push edi
        call GrabBlock
        add esp, byte 0Ch
        push byte 2Ch
        push dword 85h
        mov ebp, dword [homenamebckspr]
        push ebp
        call GrabBlock
        add esp, byte 0Ch
        push byte 2Ch
        push dword 152h
        mov eax, dword [visnamebckspr]
        push eax
        call GrabBlock
        add esp, byte 0Ch
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        mov eax, dword [nosplit eax*4+lockerindex]
        mov edx, dword [nosplit eax*4+jerseyabbrevs]
        push edx
        push str_JERSH
        lea eax, [dword esp+0348h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        add eax, eax
        add eax, 0A3h
        mov dword [dword esp+0350h], eax
        xor ecx, ecx
        lea ebx, [dword esp+0340h]
        cmp byte [dword eax+fileoncd], 1
        jne short .9
        mov edx, dword [cddriveptr]
        jmp short .10
.9:
        xor edx, edx
.10:
        lea eax, [dword esp+0300h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0304h]
        push eax
        call LoadBank
        add esp, byte 8
        mov esi, eax
        push str_P01
        push eax
        call FindShape
        add esp, byte 8
        lea edx, [byte eax+010h]
        mov dword [dword esp+0350h], 240h
.11:
        mov eax, dword [dword esp+0350h]
        add eax, edx
        mov bl, byte [eax]
        cmp bl, 3Bh
        jge short .12
        mov al, bl
        add al, 5
        mov ebx, dword [dword esp+0350h]
        mov byte [esp+ebx], al
        jmp short .13
.12:
        mov eax, dword [dword esp+0350h]
        mov byte [esp+eax], 3Fh
.13:
        mov ecx, dword [dword esp+0350h]
        inc ecx
        mov dword [dword esp+0350h], ecx
        cmp ecx, 300h
        jl short DrawLockerRoom.11
        push str_00002
        push esi
        call FindShape
        add esp, byte 8
        push eax
        call DrawArtKeyFFAtOwnPos
        add esp, byte 4
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [VisTeam-2]
        sar eax, 10h
        mov eax, dword [nosplit eax*4+lockerindex]
        mov ebp, dword [nosplit eax*4+jerseyabbrevs]
        push ebp
        push str_JERSV
        lea eax, [dword esp+0348h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov eax, dword [VisTeam-2]
        sar eax, 10h
        add eax, eax
        add eax, 0A4h
        mov dword [dword esp+0350h], eax
        xor ecx, ecx
        lea ebx, [dword esp+0340h]
        cmp byte [dword eax+fileoncd], 1
        jne short .14
        mov edx, dword [cddriveptr]
        jmp short .15
.14:
        xor edx, edx
.15:
        lea eax, [dword esp+0300h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0304h]
        push eax
        call LoadBank
        add esp, byte 8
        mov esi, eax
        push str_P01
        push eax
        call FindShape
        add esp, byte 8
        lea edx, [byte eax+010h]
        mov dword [dword esp+0350h], 180h
.16:
        mov eax, dword [dword esp+0350h]
        add eax, edx
        mov bl, byte [eax]
        cmp bl, 3Bh
        jge short .17
        mov al, bl
        add al, 5
        mov ebx, dword [dword esp+0350h]
        mov byte [esp+ebx], al
        jmp short .18
.17:
        mov eax, dword [dword esp+0350h]
        mov byte [esp+eax], 3Fh
.18:
        mov ebx, dword [dword esp+0350h]
        inc ebx
        mov dword [dword esp+0350h], ebx
        cmp ebx, 240h
        jl short DrawLockerRoom.16
        push str_00002
        push esi
        call FindShape
        add esp, byte 8
        push eax
        call DrawArtKeyFFAtOwnPos
        add esp, byte 4
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov edx, 62h
        mov eax, 77h
        call SetTextColors
        mov dword [dword esp+0350h], 2
.19:
        push byte 70h
        mov eax, dword [dword esp+0354h]
        shl eax, 4
        mov edx, dword [dword eax+lockerrects+0Ch]
        mov edi, dword [dword eax+lockerrects+4]
        sub edx, edi
        dec edx
        push edx
        mov edx, dword [dword eax+lockerrects+8]
        mov ebp, dword [dword eax+lockerrects]
        sub edx, ebp
        dec edx
        push edx
        lea edx, [byte edi+01h]
        push edx
        lea eax, [byte ebp+01h]
        push eax
        call FillRect
        add esp, byte 14h
        mov eax, dword [dword esp+0350h]
        inc eax
        mov dword [dword esp+0350h], eax
        cmp eax, byte 6
        jl short DrawLockerRoom.19
        mov ebx, dword [mainfont]
        push ebx
        call TextSetFont
        add esp, byte 4
        push dword 0FFh
        push byte 77h
        call TextSetColors
        add esp, byte 8
        cmp dword [gamemode], byte 0
        jne short .20
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        mov edx, dword [nosplit eax*4+lockerindex]
        add edx, byte 1Bh
        mov ebx, 1Ch
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov dword [dword esp+0350h], edx
        cmp edx, byte 1Ah
        jl short .22
        mov eax, dword [VisTeam-2]
        sar eax, 10h
        cmp edx, dword [nosplit eax*4+lockerindex]
        jne short .22
        mov edx, dword [dword esp+0350h]
        add edx, byte 1Bh
        jmp short .21
.20:
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        mov edx, dword [nosplit eax*4+lockerindex]
        add edx, byte 19h
        mov ebx, 1Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov dword [dword esp+0350h], edx
        mov eax, dword [VisTeam-2]
        sar eax, 10h
        cmp edx, dword [nosplit eax*4+lockerindex]
        jne short .22
        mov edx, dword [dword esp+0350h]
        add edx, byte 19h
.21:
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov dword [dword esp+0350h], edx
.22:
        mov esi, dword [dword esp+0350h]
        mov esi, dword [nosplit esi*4+jerseyabbrevs]
        mov edi, dword [lockerrects+024h]
        add edi, byte 3
        mov ebp, dword [lockerrects+020h]
        add ebp, dword [lockerrects+028h]
        sar ebp, 1
        push esi
        call fputchar
        add esp, byte 4
        sar eax, 1
        sub ebp, eax
        lea eax, [byte ebp+02h]
        mov ebx, esi
        mov edx, edi
        call PrintShadowText
        cmp dword [gamemode], byte 0
        jne short .23
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        mov edx, dword [nosplit eax*4+lockerindex]
        inc edx
        mov ebx, 1Ch
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov dword [dword esp+0350h], edx
        cmp edx, byte 1Ah
        jl short .25
        mov eax, dword [VisTeam-2]
        sar eax, 10h
        cmp edx, dword [nosplit eax*4+lockerindex]
        jne short .25
        mov edx, dword [dword esp+0350h]
        inc edx
        jmp short .24
.23:
        mov ebx, dword [HomeTeam-2]
        sar ebx, 10h
        mov edx, dword [nosplit ebx*4+lockerindex]
        inc edx
        mov ecx, 1Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov dword [dword esp+0350h], edx
        mov eax, dword [VisTeam-2]
        sar eax, 10h
        cmp edx, dword [nosplit eax*4+lockerindex]
        jne short .25
        lea edx, [byte ebx+01h]
        mov ebx, 1Ah
.24:
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov dword [dword esp+0350h], edx
.25:
        mov esi, dword [dword esp+0350h]
        mov esi, dword [nosplit esi*4+jerseyabbrevs]
        mov edi, dword [lockerrects+034h]
        add edi, byte 3
        mov eax, dword [lockerrects+030h]
        mov ebp, dword [lockerrects+038h]
        add ebp, eax
        sar ebp, 1
        push esi
        call fputchar
        add esp, byte 4
        sar eax, 1
        sub ebp, eax
        lea eax, [byte ebp+02h]
        mov ebx, esi
        mov edx, edi
        call PrintShadowText
        cmp dword [gamemode], byte 0
        jne short .26
        mov eax, dword [VisTeam-2]
        sar eax, 10h
        mov edx, dword [nosplit eax*4+lockerindex]
        add edx, byte 1Bh
        mov ebx, 1Ch
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov dword [dword esp+0350h], edx
        cmp edx, byte 1Ah
        jl short .28
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        cmp edx, dword [nosplit eax*4+lockerindex]
        jne short .28
        mov edx, dword [dword esp+0350h]
        add edx, byte 1Bh
        jmp short .27
.26:
        mov eax, dword [VisTeam-2]
        sar eax, 10h
        mov edx, dword [nosplit eax*4+lockerindex]
        add edx, byte 19h
        mov ebx, 1Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov dword [dword esp+0350h], edx
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        cmp edx, dword [nosplit eax*4+lockerindex]
        jne short .28
        mov edx, dword [dword esp+0350h]
        add edx, byte 19h
        mov ebx, 1Ah
.27:
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov dword [dword esp+0350h], edx
.28:
        mov esi, dword [dword esp+0350h]
        mov esi, dword [nosplit esi*4+jerseyabbrevs]
        mov edi, dword [lockerrects+044h]
        add edi, byte 3
        mov eax, dword [lockerrects+040h]
        mov ebp, dword [lockerrects+048h]
        add ebp, eax
        sar ebp, 1
        push esi
        call fputchar
        add esp, byte 4
        sar eax, 1
        sub ebp, eax
        lea eax, [byte ebp+02h]
        mov ebx, esi
        mov edx, edi
        call PrintShadowText
        cmp dword [gamemode], byte 0
        jne short .29
        mov eax, dword [VisTeam-2]
        sar eax, 10h
        mov edx, dword [nosplit eax*4+lockerindex]
        inc edx
        mov ebx, 1Ch
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov dword [dword esp+0350h], edx
        cmp edx, byte 1Ah
        jl short .31
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        cmp edx, dword [nosplit eax*4+lockerindex]
        jne short .31
        mov edx, dword [dword esp+0350h]
        inc edx
        jmp short .30
.29:
        mov eax, dword [VisTeam-2]
        sar eax, 10h
        mov edx, dword [nosplit eax*4+lockerindex]
        inc edx
        mov ebx, 1Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov dword [dword esp+0350h], edx
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        cmp edx, dword [nosplit eax*4+lockerindex]
        jne short .31
        mov edx, dword [dword esp+0350h]
        inc edx
        mov ebx, 1Ah
.30:
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov dword [dword esp+0350h], edx
.31:
        mov esi, dword [dword esp+0350h]
        mov esi, dword [nosplit esi*4+jerseyabbrevs]
        mov edi, dword [lockerrects+054h]
        add edi, byte 3
        mov eax, dword [lockerrects+050h]
        mov ebp, dword [lockerrects+058h]
        add ebp, eax
        sar ebp, 1
        push esi
        call fputchar
        add esp, byte 4
        sar eax, 1
        sub ebp, eax
        lea eax, [byte ebp+02h]
        mov ebx, esi
        mov edx, edi
        call PrintShadowText
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        mov edx, dword [nosplit eax*4+teamcitynames]
        push edx
        call fputchar
        add esp, byte 4
        mov edx, 12Dh
        sub edx, eax
        mov dword [dword esp+0350h], edx
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        mov ebx, dword [nosplit eax*4+teamcitynames]
        mov edx, 2Ch
        mov eax, dword [dword esp+0350h]
        call PrintOutlinedText
        mov ebx, str_Vs
        mov edx, 2Ch
        mov eax, 13Ah
        call PrintOutlinedText
        mov ebx, dword [VisTeam-2]
        sar ebx, 10h
        mov ebx, dword [nosplit ebx*4+teamcitynames]
        mov edx, 2Ch
        mov eax, 154h
        call PrintOutlinedText
        mov edx, dword [lockeraccepty]
        add edx, byte 3
        mov eax, dword [lockeracceptx]
        add eax, byte 12h
        mov ebx, str_Accept
        call PrintShadowText
        mov edx, dword [lockercancely]
        add edx, byte 3
        mov eax, dword [lockercancelx]
        add eax, byte 12h
        mov ebx, str_Cancel2
        call PrintShadowText
        mov esi, dword [lockerrects+02Ch]
        add esi, byte 5
        mov edi, dword [lockerrects+020h]
        add edi, dword [lockerrects+038h]
        sar edi, 1
        push str_HomeTeam
        call fputchar
        add esp, byte 4
        sar eax, 1
        sub edi, eax
        lea eax, [byte edi+02h]
        mov ebx, str_HomeTeam
        mov edx, esi
        call PrintShadowText
        mov esi, dword [lockerrects+04Ch]
        add esi, byte 5
        mov edi, dword [lockerrects+040h]
        add edi, dword [lockerrects+058h]
        sar edi, 1
        push str_VisitingTeam
        call fputchar
        add esp, byte 4
        sar eax, 1
        sub edi, eax
        lea eax, [byte edi+02h]
        mov ebx, str_VisitingTeam
        mov edx, esi
        call PrintShadowText
        mov esi, dword [kaufmfont]
        push esi
        call TextSetFont
        add esp, byte 4
        cmp dword [gamemode], byte 1
        jne short .32
        mov eax, dword [VisTeam-2]
        sar eax, 10h
        mov edx, dword [HomeTeam-2]
        sar edx, 10h
        mov eax, dword [nosplit eax*4+teamdivflags]
        mov ebp, dword [nosplit edx*4+teamdivflags]
        or eax, ebp
        mov dword [dword esp+0350h], eax
        mov esi, dword [nosplit eax*4+poroundnameidx]
        mov esi, dword [nosplit esi*4+poroundnames]
        push esi
        call fputchar
        add esp, byte 4
        mov edx, 280h
        sub edx, eax
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov ebx, esi
        jmp short .33
.32:
        push str_ExhibitionGame
        call fputchar
        add esp, byte 4
        mov edx, 280h
        sub edx, eax
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov ebx, str_ExhibitionGame
.33:
        mov edx, 12h
        call PrintOutlinedText
        mov eax, dword [mainfont]
        push eax
        call TextSetFont
        add esp, byte 4
        cmp byte [MusicOn], 0
        je short .35
        mov edx, dword [songdata]
        test edx, edx
        jne short .35
        mov ecx, str_Iff11
        mov ebx, str_Jersey
        cmp byte [fileoncd+01DDh], 1
        jne short .34
        mov edx, dword [cddriveptr]
.34:
        lea eax, [dword esp+0300h]
        call MakePath
        lea eax, [dword esp+0300h]
        call LoadDigiFile
        mov dword [songdata], eax
        test eax, eax
        je short .35
        test byte [gameopts], 40h
        je short .35
        mov edx, dword [musichandle]
        mov ecx, 4Ch
        mov ebx, 3
        call PlayDigiBlockLoop
.35:
        mov ebx, 10h
        mov edx, esp
        xor eax, eax
        call FadePalStep
        xor ebx, ebx
        mov dword [dword esp+0350h], ebx
.36:
        mov eax, dword [dword esp+0350h]
        mov dl, byte [dword esp+0350h]
        mov byte [dword eax+homeremap], dl
        lea ecx, [byte eax+01h]
        mov dword [dword esp+0350h], ecx
        cmp ecx, 100h
        jl short DrawLockerRoom.36
        mov byte [homeremap_e10], 2Ch
        mov byte [homeremap_e11], 1
        mov byte [homeremap_e07], 2Fh
        mov byte [homeremap_e13], 32h
        mov byte [homeremap_e14], 3Ah
        mov byte [homeremap_e51], 6Dh
        mov byte [homeremap_e50], 6Eh
        mov byte [homeremap_e49], 19h
        mov byte [homeremap_e16], 51h
        mov byte [homeremap_e60], 18h
        mov bh, 7Fh
        mov byte [homeremap_e05], bh
        mov byte [homeremap_eFB], 7Ch
        mov byte [homeremap_eFC], 7Dh
        mov byte [homeremap_eFD], 7Eh
        mov byte [homeremap_eFE], bh
        push homeremap
        call SetColorRemap
        add esp, byte 4
        add esp, 354h
        jmp near LockerRoomScreenEpilogue
%endif ; C
;-----------------------------------------------------------------------------
; LockerHitTest                                81520  95 PC, medium confidence
; Hit-test 8 rects at lockerrects
;-----------------------------------------------------------------------------
; C: src/front/lockerroom/LockerHitTest.c
%ifdef CBUILD
%include "c/front/lockerroom/LockerHitTest.inc"
%else
LockerHitTest:
        push dword 0Ch
        call __CHK
        push ecx
        push esi
        mov ecx, eax
        mov esi, edx
        xor edx, edx
        lea ecx, [byte eax+04h]
.1:
        mov eax, edx
        shl eax, 4
        cmp ecx, dword [dword eax+lockerrects]
        jl short .2
        cmp ecx, dword [dword eax+lockerrects+8]
        jg short .2
        cmp esi, dword [dword eax+lockerrects+4]
        jl short .2
        cmp esi, dword [dword eax+lockerrects+0Ch]
        jg short .2
        mov dword [ebx], edx
        mov eax, 1
        pop esi
        pop ecx
        ret
.2:
        inc edx
        cmp edx, byte 8
        jl short LockerHitTest.1
        xor eax, eax
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawLockerJersey                             8156F  95 PC, medium confidence
; Loads JER%sH / JER%sV jersey image for team and draws it
;-----------------------------------------------------------------------------
DrawLockerJersey:
        push dword 148h
        call __CHK
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 120h
        push eax
        mov esi, edx
        mov dword [byte ebp-08h], ebx
        mov edi, ecx
        call SetScreenTarget
        mov eax, esi
        mov edx, dword [nosplit eax*4+jerseyabbrevs]
        push edx
        cmp dword [dword ebp-0124h], byte 0
        je short .1
        mov eax, str_JERSV
        jmp short .2
.1:
        mov eax, str_JERSH
.2:
        push eax
        lea eax, [byte ebp-020h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov esi, dword [nosplit esi*4+lockerindex]
        cmp dword [dword ebp-0124h], byte 0
        setne al
        and eax, 0FFh
        add eax, 0A3h
        xor ecx, ecx
        lea ebx, [byte ebp-020h]
        cmp byte [dword eax+esi*2+fileoncd], 1
        jne short .3
        mov edx, dword [cddriveptr]
        jmp short .4
.3:
        xor edx, edx
.4:
        lea eax, [byte ebp-060h]
        call MakePath
        push byte 0
        lea eax, [byte ebp-060h]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [byte ebp-04h], eax
        push str_P01
        push eax
        call FindShape
        add esp, byte 8
        lea edx, [byte eax+010h]
        mov esi, dword [dword ebp-0124h]
        test esi, esi
        je short .8
        xor esi, esi
        mov ch, 3Fh
.5:
        lea eax, [edx+esi]
        mov cl, byte [dword eax+0180h]
        cmp cl, 3Bh
        jge short .6
        mov al, cl
        add al, 5
        mov byte [dword esi+ebp-0120h], al
        jmp short .7
.6:
        mov byte [dword esi+ebp-0120h], ch
.7:
        inc esi
        cmp esi, 0C0h
        jl short DrawLockerJersey.5
        jmp short .12
.8:
        mov bh, 3Fh
.9:
        lea eax, [edx+esi]
        mov bl, byte [dword eax+0240h]
        cmp bl, 3Bh
        jge short .10
        mov al, bl
        add al, 5
        mov byte [dword esi+ebp-0120h], al
        jmp short .11
.10:
        mov byte [dword esi+ebp-0120h], bh
.11:
        inc esi
        cmp esi, 0C0h
        jl short DrawLockerJersey.9
.12:
        cmp dword [dword ebp-0124h], byte 0
        je short .13
        push byte 4Ah
        push dword 146h
        mov ecx, dword [visbckspr]
        push ecx
        call DrawArtOpaque
        add esp, byte 0Ch
        push byte 2Ch
        push dword 152h
        mov esi, dword [visnamebckspr]
        push esi
        call DrawArtOpaque
        add esp, byte 0Ch
        lea eax, [dword ebp-0120h]
        push eax
        push byte 40h
        push dword 80h
        jmp short .14
.13:
        push byte 45h
        push byte 0Ah
        mov edx, dword [homebckspr]
        push edx
        call DrawArtOpaque
        add esp, byte 0Ch
        push byte 2Ch
        push dword 85h
        mov ebx, dword [homenamebckspr]
        push ebx
        call DrawArtOpaque
        add esp, byte 0Ch
        lea eax, [dword ebp-0120h]
        push eax
        push byte 40h
        push dword 0C0h
.14:
        call VgaSetPalette
        add esp, byte 0Ch
        push str_00002
        mov eax, dword [byte ebp-04h]
        push eax
        call FindShape
        add esp, byte 8
        push eax
        call DrawArtKeyFFAtOwnPos
        add esp, byte 4
        mov edx, dword [byte ebp-04h]
        push edx
        call FreeMemBlock
        add esp, byte 4
        push dword 0FFh
        push byte 77h
        call TextSetColors
        add esp, byte 8
        mov edx, 62h
        mov eax, 77h
        call SetTextColors
        cmp dword [gamemode], byte 1
        jne short .15
        push byte 11h
        push byte 2Dh
        mov ecx, dword [titlebckspr]
        push ecx
        call DrawArtOpaque
        add esp, byte 0Ch
        mov esi, dword [kaufmfont]
        push esi
        call TextSetFont
        add esp, byte 4
        mov eax, dword [byte ebp-08h]
        mov esi, dword [nosplit eax*4+poroundnameidx]
        mov esi, dword [nosplit esi*4+poroundnames]
        push esi
        call fputchar
        add esp, byte 4
        mov edx, 280h
        sub edx, eax
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov ebx, esi
        mov edx, 12h
        call PrintOutlinedText
        mov eax, dword [mainfont]
        push eax
        call TextSetFont
        add esp, byte 4
.15:
        cmp dword [gamemode], byte 0
        jne near .21
        mov esi, 2
.16:
        push byte 70h
        mov eax, esi
        shl eax, 4
        mov edx, dword [dword eax+lockerrects+0Ch]
        mov ebx, dword [dword eax+lockerrects+4]
        sub edx, ebx
        dec edx
        push edx
        mov edx, dword [dword eax+lockerrects+8]
        mov ecx, dword [dword eax+lockerrects]
        sub edx, ecx
        dec edx
        push edx
        lea edx, [byte ebx+01h]
        push edx
        lea eax, [byte ecx+01h]
        push eax
        call FillRect
        add esp, byte 14h
        inc esi
        cmp esi, byte 6
        jl short DrawLockerJersey.16
        mov edx, dword [byte ebp+010h]
        add edx, byte 1Bh
        mov ebx, 1Ch
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov esi, edx
        cmp edx, byte 1Ah
        jl short .17
        cmp edx, edi
        jne short .17
        lea edx, [byte edi+01Bh]
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov esi, edx
.17:
        mov esi, dword [nosplit esi*4+jerseyabbrevs]
        mov eax, dword [lockerrects+044h]
        add eax, byte 3
        mov dword [byte ebp-010h], eax
        mov eax, dword [lockerrects+040h]
        add eax, dword [lockerrects+048h]
        sar eax, 1
        mov dword [byte ebp-0Ch], eax
        push esi
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, dword [byte ebp-0Ch]
        sub edx, eax
        lea eax, [byte edx+02h]
        mov ebx, esi
        mov edx, dword [byte ebp-010h]
        call PrintShadowText
        mov edx, dword [byte ebp+010h]
        inc edx
        mov ebx, 1Ch
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov esi, edx
        cmp edx, byte 1Ah
        jl short .18
        cmp edx, edi
        jne short .18
        lea edx, [byte edi+01h]
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov esi, edx
.18:
        mov esi, dword [nosplit esi*4+jerseyabbrevs]
        mov eax, dword [lockerrects+054h]
        add eax, byte 3
        mov dword [byte ebp-010h], eax
        mov eax, dword [lockerrects+050h]
        add eax, dword [lockerrects+058h]
        sar eax, 1
        mov dword [byte ebp-0Ch], eax
        push esi
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, dword [byte ebp-0Ch]
        sub edx, eax
        lea eax, [byte edx+02h]
        mov ebx, esi
        mov edx, dword [byte ebp-010h]
        call PrintShadowText
        mov eax, dword [byte ebp+010h]
        mov eax, dword [nosplit eax*4+lockerteams]
        mov ebx, dword [nosplit eax*4+teamcitynames]
        mov edx, 2Ch
        mov eax, 154h
        call PrintOutlinedText
        lea edx, [byte edi+01Bh]
        mov ebx, 1Ch
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov esi, edx
        cmp edx, byte 1Ah
        jl short .19
        mov ecx, dword [byte ebp+010h]
        cmp edx, ecx
        jne short .19
        lea edx, [byte ecx+01Bh]
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov esi, edx
.19:
        mov esi, dword [nosplit esi*4+jerseyabbrevs]
        mov eax, dword [lockerrects+024h]
        add eax, byte 3
        mov dword [byte ebp-010h], eax
        mov eax, dword [lockerrects+020h]
        add eax, dword [lockerrects+028h]
        sar eax, 1
        mov dword [byte ebp-0Ch], eax
        push esi
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, dword [byte ebp-0Ch]
        sub edx, eax
        lea eax, [byte edx+02h]
        mov ebx, esi
        mov edx, dword [byte ebp-010h]
        call PrintShadowText
        lea edx, [byte edi+01h]
        mov ebx, 1Ch
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov esi, edx
        cmp edx, byte 1Ah
        jl short .20
        mov ebx, dword [byte ebp+010h]
        cmp edx, ebx
        jne short .20
        lea edx, [byte ebx+01h]
        mov ebx, 1Ch
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov esi, edx
.20:
        mov esi, dword [nosplit esi*4+jerseyabbrevs]
        mov eax, dword [lockerrects+034h]
        add eax, byte 3
        mov dword [byte ebp-010h], eax
        mov eax, dword [lockerrects+030h]
        add eax, dword [lockerrects+038h]
        sar eax, 1
        mov dword [byte ebp-0Ch], eax
        push esi
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, dword [byte ebp-0Ch]
        sub edx, eax
        lea eax, [byte edx+02h]
        mov ebx, esi
        mov edx, dword [byte ebp-010h]
        call PrintShadowText
        mov eax, dword [nosplit edi*4+lockerteams]
        mov esi, dword [nosplit eax*4+teamcitynames]
        push esi
        call fputchar
        add esp, byte 4
        mov esi, 12Dh
        sub esi, eax
        mov eax, dword [nosplit edi*4+lockerteams]
        mov ebx, dword [nosplit eax*4+teamcitynames]
        jmp near .27
.21:
        mov esi, 2
.22:
        push byte 70h
        mov eax, esi
        shl eax, 4
        mov edx, dword [dword eax+lockerrects+0Ch]
        mov ebx, dword [dword eax+lockerrects+4]
        sub edx, ebx
        dec edx
        push edx
        mov edx, dword [dword eax+lockerrects+8]
        mov ecx, dword [dword eax+lockerrects]
        sub edx, ecx
        dec edx
        push edx
        lea edx, [byte ebx+01h]
        push edx
        lea eax, [byte ecx+01h]
        push eax
        call FillRect
        add esp, byte 14h
        inc esi
        cmp esi, byte 6
        jl short DrawLockerJersey.22
        mov edx, dword [byte ebp+010h]
        add edx, byte 19h
        mov ebx, 1Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov esi, edx
        cmp edx, edi
        jne short .23
        lea edx, [byte edi+019h]
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov esi, edx
.23:
        mov esi, dword [nosplit esi*4+jerseyabbrevs]
        mov eax, dword [lockerrects+044h]
        add eax, byte 3
        mov dword [byte ebp-010h], eax
        mov eax, dword [lockerrects+040h]
        add eax, dword [lockerrects+048h]
        sar eax, 1
        mov dword [byte ebp-0Ch], eax
        push esi
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, dword [byte ebp-0Ch]
        sub edx, eax
        lea eax, [byte edx+02h]
        mov ebx, esi
        mov edx, dword [byte ebp-010h]
        call PrintShadowText
        mov edx, dword [byte ebp+010h]
        inc edx
        mov ebx, 1Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov esi, edx
        cmp edx, edi
        jne short .24
        lea edx, [byte edi+01h]
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov esi, edx
.24:
        mov esi, dword [nosplit esi*4+jerseyabbrevs]
        mov eax, dword [lockerrects+054h]
        add eax, byte 3
        mov dword [byte ebp-010h], eax
        mov eax, dword [lockerrects+050h]
        add eax, dword [lockerrects+058h]
        sar eax, 1
        mov dword [byte ebp-0Ch], eax
        push esi
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, dword [byte ebp-0Ch]
        sub edx, eax
        lea eax, [byte edx+02h]
        mov ebx, esi
        mov edx, dword [byte ebp-010h]
        call PrintShadowText
        mov eax, dword [byte ebp+010h]
        mov eax, dword [nosplit eax*4+lockerteams]
        mov ebx, dword [nosplit eax*4+teamcitynames]
        mov edx, 2Ch
        mov eax, 154h
        call PrintOutlinedText
        lea edx, [byte edi+019h]
        mov ebx, 1Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov esi, edx
        mov ecx, dword [byte ebp+010h]
        cmp edx, ecx
        jne short .25
        lea edx, [byte ecx+019h]
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov esi, edx
.25:
        mov esi, dword [nosplit esi*4+jerseyabbrevs]
        mov eax, dword [lockerrects+024h]
        add eax, byte 3
        mov dword [byte ebp-010h], eax
        mov eax, dword [lockerrects+020h]
        add eax, dword [lockerrects+028h]
        sar eax, 1
        mov dword [byte ebp-0Ch], eax
        push esi
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, dword [byte ebp-0Ch]
        sub edx, eax
        lea eax, [byte edx+02h]
        mov ebx, esi
        mov edx, dword [byte ebp-010h]
        call PrintShadowText
        lea edx, [byte edi+01h]
        mov ebx, 1Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov esi, edx
        mov ebx, dword [byte ebp+010h]
        cmp edx, ebx
        jne short .26
        lea edx, [byte ebx+01h]
        mov ebx, 1Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov esi, edx
.26:
        mov esi, dword [nosplit esi*4+jerseyabbrevs]
        mov eax, dword [lockerrects+034h]
        add eax, byte 3
        mov dword [byte ebp-0Ch], eax
        mov eax, dword [lockerrects+030h]
        add eax, dword [lockerrects+038h]
        sar eax, 1
        mov dword [byte ebp-010h], eax
        push esi
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, dword [byte ebp-010h]
        sub edx, eax
        lea eax, [byte edx+02h]
        mov ebx, esi
        mov edx, dword [byte ebp-0Ch]
        call PrintShadowText
        mov eax, dword [nosplit edi*4+lockerteams]
        mov esi, dword [nosplit eax*4+teamcitynames]
        push esi
        call fputchar
        add esp, byte 4
        mov esi, 12Dh
        sub esi, eax
        mov ebx, dword [nosplit edi*4+lockerteams]
        mov ebx, dword [nosplit ebx*4+teamcitynames]
.27:
        mov edx, 2Ch
        mov eax, esi
        call PrintOutlinedText
        mov esp, ebp
        jmp near DrawPanel3D_ret
        db 090h
LockerRoomLoop_jt:                              ; used by LockerRoomLoop
        dd LockerRoomLoop_n0
        dd LockerRoomLoop_n1
        dd LockerRoomLoop_n2
        dd LockerRoomLoop_n0
        dd LockerRoomLoop_n4
        dd LockerRoomLoop_n1
        dd LockerRoomLoop_n6
        dd LockerRoomLoop_n7
;-----------------------------------------------------------------------------
; LockerRoomLoop                               81C4E  95 PC, medium confidence
; Pointer loop: jersey swap / accept / cancel, WriteCurModeState
;-----------------------------------------------------------------------------
; C: src/front/lockerroom/LockerRoomScreen.c (LockerRoomLoop)
%ifdef CBUILD
%include "c/front/lockerroom/LockerRoomScreen.LockerRoomLoop.inc"
%else
LockerRoomLoop:
        push dword 348h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, 320h
        mov ebp, dword [HomeTeam-2]
        sar ebp, 10h
        mov ebp, dword [nosplit ebp*4+lockerindex]
        mov eax, dword [VisTeam-2]
        sar eax, 10h
        mov eax, dword [nosplit eax*4+lockerindex]
        mov dword [dword esp+031Ch], eax
        lea eax, [dword esp+0310h]
        push eax
        lea eax, [dword esp+0318h]
        push eax
        lea eax, [dword esp+030Ch]
        push eax
        call MouseRead
        add esp, byte 0Ch
        mov eax, dword [dword esp+0314h]
        mov dword [dword esp+030Ch], eax
        mov eax, dword [dword esp+0310h]
        mov dword [dword esp+0308h], eax
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
        push str_Pointer20
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [dword esp+0318h], eax
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
        mov edx, dword [dword esp+0308h]
        push edx
        mov edx, dword [dword esp+0310h]
        sub edx, byte 4
        push edx
        push eax
        call GrabBlock
        add esp, byte 0Ch
        mov ebx, dword [dword esp+0308h]
        push ebx
        mov eax, dword [dword esp+0310h]
        sub eax, byte 4
        push eax
        mov ecx, dword [pointerspr]
        push ecx
        call DrawArtKeyColour
        add esp, byte 0Ch
        call ClearInputQueue
.1:
        xor esi, esi
        mov dword [dword esp+0304h], esi
.2:
        call GetInputEvent
        test eax, eax
        je short .3
        lea ebx, [dword esp+0308h]
        lea edx, [dword esp+030Ch]
        call dword [ptrupdatefn]
        mov dword [dword esp+0304h], eax
        test al, 6
        je short LockerRoomLoop.2
.3:
        mov ah, byte [dword esp+0304h]
        test ah, 2
        jne near .6
        test ah, 4
        jne near .6
        mov eax, dword [dword esp+030Ch]
        cmp eax, dword [dword esp+0314h]
        jne short .4
        mov eax, dword [dword esp+0308h]
        cmp eax, dword [dword esp+0310h]
        je short LockerRoomLoop.1
.4:
        mov edi, dword [dword esp+0310h]
        push edi
        mov eax, dword [dword esp+0318h]
        sub eax, byte 4
        push eax
        mov eax, dword [dword esp+0320h]
        push eax
        call PutBlock
        add esp, byte 0Ch
        mov edx, dword [dword esp+0308h]
        push edx
        mov eax, dword [dword esp+0310h]
        sub eax, byte 4
        push eax
        mov ebx, dword [dword esp+0320h]
        push ebx
        call GrabBlock
        add esp, byte 0Ch
        mov ecx, dword [dword esp+0308h]
        push ecx
        mov eax, dword [dword esp+0310h]
        sub eax, byte 4
        push eax
        mov esi, dword [pointerspr]
        push esi
.5:
        call DrawArtKeyColour
        add esp, byte 0Ch
        mov eax, dword [dword esp+030Ch]
        mov dword [dword esp+0314h], eax
        mov eax, dword [dword esp+0308h]
        mov dword [dword esp+0310h], eax
        jmp near LockerRoomLoop.1
.6:
        test byte [dword esp+0304h], 2
        je near LockerRoomLoop_n7.4
        mov edx, dword [dword esp+0310h]
        push edx
        mov eax, dword [dword esp+0318h]
        sub eax, byte 4
        push eax
        mov ebx, dword [dword esp+0320h]
        push ebx
        call PutBlock
        add esp, byte 0Ch
        lea ebx, [dword esp+0300h]
        mov edx, dword [dword esp+0308h]
        mov eax, dword [dword esp+030Ch]
        call LockerHitTest
        test eax, eax
        je near LockerRoomLoop_n0.6
        mov ecx, dword [dword esp+0300h]
        cmp ecx, byte 7
        ja near LockerRoomLoop_n0.6
        mov eax, ecx
        jmp dword [nosplit cs:eax*4+LockerRoomLoop_jt]
LockerRoomLoop_n2:
        cmp dword [gamemode], byte 0
        jne short .1
        lea edx, [byte ebp+01Bh]
        mov ebx, 1Ch
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov ebp, edx
        cmp edx, byte 1Ah
        jl short .3
        mov edx, dword [dword esp+031Ch]
        cmp ebp, edx
        jne short .3
        add edx, byte 1Bh
        jmp short .2
.1:
        lea edx, [byte ebp+019h]
        mov ebx, 1Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov ebp, edx
        mov eax, dword [dword esp+031Ch]
        cmp edx, eax
        jne short .3
        lea edx, [byte eax+019h]
.2:
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov ebp, edx
.3:
        mov ebx, dword [dword esp+031Ch]
        push ebx
        mov ebx, dword [nosplit ebx*4+lockerteams]
        mov edx, dword [nosplit ebp*4+lockerteams]
        mov ebx, dword [nosplit ebx*4+teamdivflags]
        or ebx, dword [nosplit edx*4+teamdivflags]
        mov ecx, ebp
        mov edx, ebp
        xor eax, eax
        call DrawLockerJersey
        call ClearInputQueue
        mov esi, dword [dword esp+0308h]
        push esi
        mov edi, dword [dword esp+0310h]
        push edi
        jmp near LockerRoomLoop_n0.5
LockerRoomLoop_n0:
        lea edx, [byte ebp+01h]
        cmp dword [gamemode], byte 0
        jne short .1
        mov ebx, 1Ch
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov ebp, edx
        cmp edx, byte 1Ah
        jl short .3
        mov esi, dword [dword esp+031Ch]
        cmp edx, esi
        jne short .3
        lea edx, [byte esi+01h]
        jmp short .2
.1:
        mov ebx, 1Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov ebp, edx
        mov ecx, dword [dword esp+031Ch]
        cmp edx, ecx
        jne short .3
        lea edx, [byte ecx+01h]
.2:
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov ebp, edx
.3:
        mov edi, dword [dword esp+031Ch]
        push edi
        mov ebx, dword [nosplit edi*4+lockerteams]
        mov edx, dword [nosplit ebp*4+lockerteams]
        mov eax, dword [nosplit ebx*4+teamdivflags]
        mov ebx, dword [nosplit edx*4+teamdivflags]
        or ebx, eax
        mov ecx, ebp
        mov edx, ebp
        xor eax, eax
.4:
        call DrawLockerJersey
        call ClearInputQueue
        mov ecx, dword [dword esp+0308h]
        push ecx
        mov esi, dword [dword esp+0310h]
        push esi
.5:
        call MouseSetPos
        add esp, byte 8
.6:
        mov edi, dword [dword esp+0308h]
        push edi
        mov eax, dword [dword esp+0310h]
        sub eax, byte 4
        push eax
        mov eax, dword [dword esp+0320h]
        push eax
        call GrabBlock
        add esp, byte 0Ch
        mov edx, dword [dword esp+0308h]
        push edx
        mov eax, dword [dword esp+0310h]
        sub eax, byte 4
        push eax
        mov ebx, dword [pointerspr]
        push ebx
        jmp near LockerRoomLoop.5
LockerRoomLoop_n4:
        cmp dword [gamemode], byte 0
        jne short .1
        mov edx, dword [dword esp+031Ch]
        add edx, byte 1Bh
        mov ebx, 1Ch
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov dword [dword esp+031Ch], edx
        cmp edx, byte 1Ah
        jl short .3
        cmp ebp, edx
        jne short .3
        add edx, byte 1Bh
        jmp short .2
.1:
        mov edx, dword [dword esp+031Ch]
        add edx, byte 19h
        mov ebx, 1Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov dword [dword esp+031Ch], edx
        cmp ebp, edx
        jne short .3
        add edx, byte 19h
.2:
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov dword [dword esp+031Ch], edx
.3:
        mov edi, dword [dword esp+031Ch]
        push edi
        mov ebx, dword [nosplit edi*4+lockerteams]
        mov edx, dword [nosplit ebp*4+lockerteams]
        mov eax, dword [nosplit ebx*4+teamdivflags]
        mov ebx, dword [nosplit edx*4+teamdivflags]
        or ebx, eax
        mov ecx, ebp
        mov edx, edi
        mov eax, 1
        jmp near LockerRoomLoop_n0.4
LockerRoomLoop_n1:
        mov edx, dword [dword esp+031Ch]
        inc edx
        cmp dword [gamemode], byte 0
        jne short .1
        mov ebx, 1Ch
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov dword [dword esp+031Ch], edx
        cmp edx, byte 1Ah
        jl short .3
        cmp ebp, edx
        jne short .3
        jmp short .2
.1:
        mov ebx, 1Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov dword [dword esp+031Ch], edx
        cmp ebp, edx
        jne short .3
.2:
        inc edx
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov dword [dword esp+031Ch], edx
.3:
        mov esi, dword [dword esp+031Ch]
        push esi
        mov ebx, dword [nosplit esi*4+lockerteams]
        mov edx, dword [nosplit ebp*4+lockerteams]
        mov ebx, dword [nosplit ebx*4+teamdivflags]
        or ebx, dword [nosplit edx*4+teamdivflags]
        mov ecx, ebp
        mov edx, esi
        mov eax, 1
        call DrawLockerJersey
        call ClearInputQueue
        mov eax, dword [dword esp+0308h]
        push eax
        mov edx, dword [dword esp+0310h]
        push edx
        jmp near LockerRoomLoop_n0.5
LockerRoomLoop_n6:
        mov edx, ebp
        shl edx, 2
        mov ax, word [dword edx+lockerteams]
        mov word [HomeTeam], ax
        mov eax, dword [dword esp+031Ch]
        mov ax, word [nosplit eax*4+lockerteams]
        mov word [VisTeam], ax
        cmp dword [gamemode], byte 0
        jne short .4
        mov edx, dword [dword edx+jerseyabbrevs]
        cmp byte [byte edx+02h], 0
        je short .1
        mov ebx, 3
        mov eax, str_LAAtMTL+7
        call strncpy_
        jmp short .2
.1:
        mov ebx, 2
        mov eax, str_LAAtMTL+7
        call strncpy_
        mov byte [str_LAAtMTL+9], 20h
.2:
        mov edx, dword [dword esp+031Ch]
        mov edx, dword [nosplit edx*4+jerseyabbrevs]
        cmp byte [byte edx+02h], 0
        je short .3
        mov ebx, 3
        mov eax, str_LAAtMTL
        call strncpy_
        jmp short .4
.3:
        mov ebx, 2
        mov eax, str_LAAtMTL
        call strncpy_
        mov byte [str_LAAtMTL+2], 20h
.4:
        cmp dword [ctl1team], byte 0
        jl short .7
        cmp dword [ctl1side], byte 0
        jne short .5
        mov eax, dword [cont2team]
        jmp short .6
.5:
        mov eax, dword [HomeTeam]
.6:
        sar eax, 10h
        mov dword [ctl1team], eax
.7:
        cmp dword [ctl2team], byte 0
        jl short .10
        cmp dword [ctl2side], byte 0
        jne short .8
        mov eax, dword [cont2team]
        jmp short .9
.8:
        mov eax, dword [HomeTeam]
.9:
        sar eax, 10h
        mov dword [ctl2team], eax
.10:
        call WriteCurModeState
        cmp byte [MusicOn], 0
        je short .11
        cmp dword [songdata], byte 0
        je short .11
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 3
        call SetDigiChannelVolume
.11:
        mov eax, esp
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, esp
        mov eax, 1
        call FadePalStep
        mov ebp, dword [dword esp+0318h]
        push ebp
        call FreeMemBlock
        add esp, byte 4
        cmp byte [MusicOn], 0
        je short .13
        cmp dword [songdata], byte 0
        je short .13
.12:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short LockerRoomLoop_n6.12
        mov ebx, dword [songdata]
        push ebx
        call PushMemDescriptorLocked
        add esp, byte 4
        xor ecx, ecx
        mov dword [songdata], ecx
.13:
        xor eax, eax
.14:
        add esp, 320h
        jmp near LockerRoomScreenEpilogue
LockerRoomLoop_n7:
        cmp byte [MusicOn], 0
        je short .1
        cmp dword [songdata], byte 0
        je short .1
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 3
        call SetDigiChannelVolume
.1:
        mov eax, esp
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, esp
        mov eax, 1
        call FadePalStep
        mov edi, dword [dword esp+0318h]
        push edi
        call FreeMemBlock
        add esp, byte 4
        cmp byte [MusicOn], 0
        je short .3
        cmp dword [songdata], byte 0
        je short .3
.2:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short LockerRoomLoop_n7.2
        mov eax, dword [songdata]
        push eax
        call PushMemDescriptorLocked
        add esp, byte 4
        xor edx, edx
        mov dword [songdata], edx
.3:
        mov eax, 3
        jmp near LockerRoomLoop_n6.14
.4:
        cmp byte [MusicOn], 0
        je short .5
        cmp dword [songdata], byte 0
        je short .5
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 3
        call SetDigiChannelVolume
.5:
        mov eax, esp
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, esp
        mov eax, 1
        call FadePalStep
        mov ebp, dword [dword esp+0318h]
        push ebp
        call FreeMemBlock
        add esp, byte 4
        cmp byte [MusicOn], 0
        je short LockerRoomLoop_n7.3
        cmp dword [songdata], byte 0
        je short LockerRoomLoop_n7.3
.6:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short LockerRoomLoop_n7.6
        mov edi, dword [songdata]
        push edi
        call PushMemDescriptorLocked
        add esp, byte 4
        xor ebp, ebp
        mov dword [songdata], ebp
        jmp near LockerRoomLoop_n7.3
%endif ; C
;-----------------------------------------------------------------------------
; DrawSelBoxOn                                 8245A  95 PC, medium confidence
; Selected radio box frame (shared with sound_config)
;-----------------------------------------------------------------------------
; C: src/front/lockerroom/DrawSelBoxOn.c
%ifdef CBUILD
%include "c/front/lockerroom/DrawSelBoxOn.inc"
%else
DrawSelBoxOn:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov esi, eax
        push dword 0F8h
        mov eax, dword [byte eax+04h]
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
        push dword 0F8h
        mov eax, dword [byte esi+04h]
        add eax, byte 13h
        push eax
        mov edx, dword [byte esi+08h]
        add edx, byte 9
        push edx
        push eax
        mov eax, dword [esi]
        add eax, byte 0Ah
        push eax
        call FillRectColor
        add esp, byte 14h
        push dword 0FAh
        mov eax, dword [byte esi+0Ch]
        add eax, byte 13h
        push eax
        mov eax, dword [byte esi+08h]
        add eax, byte 0Ah
        push eax
        mov edx, dword [byte esi+04h]
        add edx, byte 14h
        push edx
        push eax
        call FillRectColor
        add esp, byte 14h
        push dword 0FAh
DrawSelBox_common:
        mov eax, dword [byte esi+0Ch]
        add eax, byte 13h
        push eax
        mov edx, dword [esi]
        add edx, byte 0Bh
        push edx
        push eax
        mov eax, dword [byte esi+08h]
        add eax, byte 0Ah
        push eax
        call FillRectColor
        add esp, byte 14h
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawSelBoxOff                                824F8  95 PC, medium confidence
; Unselected radio box frame
;-----------------------------------------------------------------------------
; C: src/front/lockerroom/DrawSelBoxOn.c (DrawSelBoxOff)
%ifdef CBUILD
%include "c/front/lockerroom/DrawSelBoxOn.DrawSelBoxOff.inc"
%else
DrawSelBoxOff:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov esi, eax
        push dword 0FAh
        mov eax, dword [byte eax+04h]
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
        push dword 0FAh
        mov eax, dword [byte esi+04h]
        add eax, byte 13h
        push eax
        mov edx, dword [byte esi+08h]
        add edx, byte 9
        push edx
        push eax
        mov eax, dword [esi]
        add eax, byte 0Ah
        push eax
        call FillRectColor
        add esp, byte 14h
        push dword 0F8h
        mov eax, dword [byte esi+0Ch]
        add eax, byte 13h
        push eax
        mov eax, dword [byte esi+08h]
        add eax, byte 0Ah
        push eax
        mov edx, dword [byte esi+04h]
        add edx, byte 14h
        push edx
        push eax
        call FillRectColor
        add esp, byte 14h
        push dword 0F8h
        jmp near DrawSelBox_common
%endif ; C
