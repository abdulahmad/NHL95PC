; Sports Central. The front-end menu loop, saving or restoring which mode you are in, and the File and
; League Manager menus: a new exhibition or league, trades, imports, and the next game. One module.
bits 32
%include "hockey.inc"
section s_31AB5 progbits alloc exec nowrite align=1
extern __CHK, AddHumanTeam, BuildSavedGameLabels, MergeResult, cddriveptr, CheckGameDiskSpace, CheckMasterPassword, ClearInputQueue
extern cont2team, CreateNewLeague, ctl1dev, ctl1side, ctl1team, ctl2dev, ctl2side, ctl2team
extern ctlavailmask, curleague, currink, desksongalt, DiskFreeBytes, DrawMenuBar, DrawMenuDropdown, DrawMenuItemNorm
extern DrawMenuItemSel, EasnGoalieStatsScreen, EasnSkaterStatsScreen, EasnStandingsMenu, EasnStandingsScreen, EasnTeamStatsScreen, exhstate, ExportDbs
extern FadeOutPalCycle, FadePalStep, FatalError, FileClose, FileCreate, FileExists, fileoncd, FileOpenRead
extern FileOpenRW, FileReadAt, FileWriteAt, FreeMemBlock, GameGoalieStatsScreen, gamemode, gameopts, GameSkaterStatsScreen
extern GameStandingsMenu, GameStandingsScreen, GameTeamStatsScreen, GetInputEvent, goaliestatscb, HomeTeam, ImportDbs, InitGameSummary
extern InputInstall, InputRemove, keepdesksong, leaguedbfmt, leaguedbfmt2, leaguemgrmenu, LeagueSettingsDlg, lgstate
extern mainmenubar, MakePath, memcpy_, menuact_export, menuact_nextlg, MenuHitTest, menusub_lgmgr, MergeLeagueFiles
extern MergeUpdateDbs, MessageBox, mousepollfn, MouseSetPos, musichandle, musicon, musicslot, PlayGame
extern PlayLeagueGame, pointerspr, PreGameScreen, ptrupdatefn, RebuildLeagueDbs, RemoveHumanTeam, rinkbm, rinktilebm
extern schedgameidx, scrpitch, setdiskmsg, SetLeagueSetImage, SetScreenTitle, SetSideControls, SettingsStub, SetupControllers
extern SetupStatsSourceMenu, ShowLoadingScreen, skaterstatscb, songdata, standingscb, standingsmenucb, str_Desk2, str_Easndesk
extern str_fee2, str_fee3, str_fee4, str_Game, str_GameSav4, str_GameSet4, str_Iff8, str_LAAtMTL
extern str_Maindesk, str_Menubuff4, str_Pal15, str_Palette2, str_Pointer7, str_Set, str_Temp4, str_Tonights2
extern strcat_, strcpy_, strncpy_, AllocMemBlock, PushMemDescriptorLocked, LoadBank, EnableMidiSfx, DisableMidiSfx
extern EnableMidiMusic, DisableMidiMusic, LoadDigiFile, PlayDigiBlockLoop, SndQuery, SetDigiChannelVolume, SetPalette, PutBlock
extern DrawBitmap, DrawArt, GrabBlock, SetViewRect, FindShape, SetScreenTarget, SetClipWindow, teamabbrevs
extern teamstatscb, TradePlayers, UpdateTeamDbs, ViewHilights, VisTeam
global MainDeskLoop, MainDeskLoop_x, MainDeskLoop_x2, MenuExit, SaveModeState, LoadModeState, WriteModeState, CopyGameSettings
global MenuNewExhibition, MenuNewLeague, MenuAddTeam, MenuAddTeam_common, MenuAddTeam_ret2, MenuRemoveTeam, MenuLeagueSettings, MenuRebuildDbs
global MenuRebuildDbs_x, MenuMergeUpdateDbs, MenuMergeUpdateDbs_ret, MenuMergeLeagueFiles, MenuUpdateTeamDbs, MenuTradePlayers, MenuNextLeagueGame, MenuLeagueHilights
global MenuImportDbs, MenuExportDbs, DemoSetupStub, FreeRinkGfx
;-----------------------------------------------------------------------------
; MainDeskLoop                                                    31AB5  95 PC
; Front-end top level called from main: maindesk / tonights music
; alternation, easndesk screen, menu bar File / Game / Statistics, runs the
; chosen item's action until it returns 1 (Exit)
;-----------------------------------------------------------------------------
; C: src/front/desk_main/MainDeskLoop.c
%ifdef CBUILD
%include "c/front/desk_main/MainDeskLoop.inc"
%else
MainDeskLoop:
        push dword 0CCh
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, 0A0h
        mov dword [dword esp+080h], 0FFFFFFFFh
        xor ebx, ebx
        mov dword [dword esp+09Ch], ebx
        xor eax, eax
        call SetScreenTitle
        mov dword [byte esp+030h], mainmenubar
        mov dword [byte esp+060h], 3
        mov dword [byte esp+03Ch], ebx
        mov dword [byte esp+038h], ebx
        mov dword [byte esp+034h], ebx
        mov dword [byte esp+05Ch], ebx
        mov dword [byte esp+058h], ebx
        mov dword [byte esp+054h], ebx
        mov dword [byte esp+050h], ebx
        mov dword [byte esp+04Ch], ebx
        mov dword [byte esp+048h], ebx
        mov dword [byte esp+044h], ebx
        mov dword [byte esp+040h], ebx
        mov dword [byte esp+04h], ebx
        mov dword [esp], ebx
        mov edx, dword [mainmenubar]
        mov esi, dword [mainmenubar+8]
        add edx, esi
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov dword [dword esp+094h], eax
        mov dword [dword esp+088h], eax
        db 08Bh,015h                            ; insn: mov edx,[0E3B3h]
        dd mainmenubar+4
        db 08Bh,03Dh                            ; insn: mov edi,[0E3BBh]
        dd mainmenubar+0Ch
        add edx, edi
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov dword [dword esp+098h], eax
        mov dword [dword esp+084h], eax
        push dword 1E0h
        push dword 27Ch
        push ebx
        push ebx
        call SetViewRect
        add esp, byte 10h
        mov ebp, dword [dword esp+098h]
        push ebp
        mov eax, dword [dword esp+098h]
        push eax
        call MouseSetPos
        add esp, byte 8
        call dword [mousepollfn]
        call SetSideControls
        xor eax, eax
        call SetupStatsSourceMenu
        mov dword [teamstatscb], EasnTeamStatsScreen
        mov dword [skaterstatscb], EasnSkaterStatsScreen
        mov dword [goaliestatscb], EasnGoalieStatsScreen
        mov dword [standingscb], EasnStandingsScreen
        mov dword [standingsmenucb], EasnStandingsMenu
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
        push str_Pointer7
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [dword esp+090h], eax
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
        cmp byte [musicon], 0
        je near .7
        cmp dword [songdata], byte 0
        jne near .7
        cmp byte [desksongalt], 0
        je short .3
        mov ecx, str_Iff8
        mov ebx, str_Maindesk
        cmp byte [fileoncd+01DBh], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
        lea eax, [byte esp+020h]
        call MakePath
        xor ah, ah
        mov byte [desksongalt], ah
        jmp short .6
.3:
        mov ecx, str_Iff8
        mov ebx, str_Tonights2
        cmp byte [fileoncd+01DFh], 1
        jne short .4
        mov edx, dword [cddriveptr]
        jmp short .5
.4:
        xor edx, edx
.5:
        lea eax, [byte esp+020h]
        call MakePath
        mov byte [desksongalt], 1
.6:
        lea eax, [byte esp+020h]
        call LoadDigiFile
        mov dword [songdata], eax
.7:
        xor ecx, ecx
        mov ebx, str_Easndesk
        cmp byte [fileoncd+06Ah], 1
        jne short .8
        mov edx, dword [cddriveptr]
        jmp short .9
.8:
        xor edx, edx
.9:
        lea eax, [byte esp+020h]
        call MakePath
        push byte 0
        lea eax, [byte esp+024h]
        push eax
        call LoadBank
        mov esi, eax
        add esp, byte 8
        mov ebp, eax
        call FadeOutPalCycle
        call SetScreenTarget
        push str_Desk2
        push esi
        call FindShape
        add esp, byte 8
        push eax
        call DrawBitmap
        add esp, byte 4
        push dword 0F8h
        mov ecx, 0F9h
        mov ebx, 0FAh
        mov edx, dword [byte esp+064h]
        mov eax, dword [byte esp+034h]
        call DrawMenuBar
        mov eax, dword [dword esp+098h]
        push eax
        mov edx, dword [dword esp+098h]
        push edx
        mov ebx, dword [dword esp+098h]
        push ebx
        call GrabBlock
        add esp, byte 0Ch
        mov ecx, dword [dword esp+098h]
        push ecx
        mov esi, dword [dword esp+098h]
        push esi
        mov edi, dword [pointerspr]
        push edi
        call DrawArt
        add esp, byte 0Ch
        mov word [scrpitch], 50h
        cmp byte [musicon], 0
        je short .10
        mov eax, dword [songdata]
        test eax, eax
        je short .10
        test byte [gameopts], 40h
        je short .10
        mov edx, dword [musichandle]
        mov ecx, 4Ch
        mov ebx, 3
        call PlayDigiBlockLoop
.10:
        push str_Pal15
        push ebp
        call FindShape
        add esp, byte 8
        lea edx, [byte eax+010h]
        mov ebx, 10h
        xor eax, eax
        call FadePalStep
        push ebp
        call FreeMemBlock
        add esp, byte 4
        call ClearInputQueue
.11:
        xor ecx, ecx
.12:
        call GetInputEvent
        test eax, eax
        je short .13
        lea ebx, [dword esp+084h]
        lea edx, [dword esp+088h]
        call dword [ptrupdatefn]
        mov ecx, eax
        test al, 2
        je short MainDeskLoop.12
.13:
        test cl, 2
        jne near .16
        mov eax, dword [dword esp+088h]
        cmp eax, dword [dword esp+094h]
        jne short .14
        mov eax, dword [dword esp+084h]
        cmp eax, dword [dword esp+098h]
        je short MainDeskLoop.11
.14:
        call SetScreenTarget
        mov esi, dword [dword esp+098h]
        push esi
        mov edi, dword [dword esp+098h]
        push edi
        mov ebp, dword [dword esp+098h]
        push ebp
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [dword esp+084h]
        push eax
        mov edx, dword [dword esp+08Ch]
        push edx
        push ebp
        call GrabBlock
        add esp, byte 0Ch
        mov ecx, dword [dword esp+084h]
        push ecx
        mov esi, dword [dword esp+08Ch]
        push esi
        mov edi, dword [pointerspr]
        push edi
.15:
        call DrawArt
        add esp, byte 0Ch
        mov eax, dword [dword esp+088h]
        mov dword [dword esp+094h], eax
        mov eax, dword [dword esp+084h]
        mov dword [dword esp+098h], eax
        jmp near MainDeskLoop.11
.16:
        lea eax, [byte esp+078h]
        push eax
        lea eax, [dword esp+080h]
        push eax
        lea eax, [byte esp+08h]
        push eax
        lea eax, [byte esp+06Ch]
        push eax
        mov ecx, dword [dword esp+0ACh]
        lea ebx, [byte esp+040h]
        mov edx, dword [dword esp+094h]
        mov eax, dword [dword esp+098h]
        call MenuHitTest
        test eax, eax
        je near .49
        mov esi, dword [byte esp+07Ch]
        shl esi, 2
        mov edx, dword [byte esp+078h]
        shl edx, 5
        mov eax, dword [byte esp+esi+030h]
        add eax, edx
        cmp dword [byte eax+014h], byte 0
        je near .39
        mov eax, dword [byte esp+078h]
        cmp eax, dword [byte esp+esi+040h]
        jne near .33
        mov ebp, dword [dword esp+098h]
        push ebp
        mov eax, dword [dword esp+098h]
        push eax
        mov edx, dword [dword esp+098h]
        push edx
        call PutBlock
        add esp, byte 0Ch
        mov esi, dword [dword esp+09Ch]
        jmp short .19
.17:
        mov ebp, esi
        shl ebp, 2
        xor ebx, ebx
        mov dword [byte esp+ebp+040h], ebx
        mov ecx, dword [byte esp+ebp+050h]
        test ecx, ecx
        je short .18
        mov eax, dword [byte esp+esi*8+04h]
        push eax
        mov edx, dword [byte esp+esi*8+04h]
        push edx
        push ecx
        call PutBlock
        add esp, byte 0Ch
        xor ecx, ecx
        mov dword [byte esp+esi*8+04h], ecx
        mov dword [esp+esi*8], ecx
        mov edi, dword [byte esp+ebp+050h]
        push edi
        call FreeMemBlock
        add esp, byte 4
.18:
        dec esi
.19:
        test esi, esi
        jg short MainDeskLoop.17
        xor eax, eax
        mov dword [dword esp+09Ch], eax
        mov edx, dword [dword esp+090h]
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor ebx, ebx
        mov dword [keepdesksong], ebx
        mov eax, dword [byte esp+07Ch]
        mov ebx, dword [byte esp+078h]
        shl ebx, 5
        mov edx, dword [byte esp+eax*4+030h]
        lea eax, [dword esp+080h]
        call dword [byte edx+ebx+014h]
        mov ebp, eax
        lea eax, [dword esp+080h]
        call FileClose
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
        push str_Pointer7
        call AllocMemBlock
        mov edx, eax
        add esp, byte 0Ch
        mov dword [dword esp+090h], eax
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov eax, dword [pointerspr]
        mov ax, word [byte eax+04h]
        inc eax
        mov word [byte edx+04h], ax
        mov eax, dword [pointerspr]
        mov ax, word [byte eax+06h]
        inc eax
        mov word [byte edx+06h], ax
        xor ecx, ecx
        mov dword [byte esp+03Ch], ecx
        mov dword [byte esp+038h], ecx
        mov dword [byte esp+034h], ecx
        mov dword [byte esp+05Ch], ecx
        mov dword [byte esp+058h], ecx
        mov dword [byte esp+054h], ecx
        mov dword [byte esp+050h], ecx
        mov dword [byte esp+04Ch], ecx
        mov dword [byte esp+048h], ecx
        mov dword [byte esp+044h], ecx
        mov dword [byte esp+06Ch], ecx
        mov dword [byte esp+068h], ecx
        mov dword [byte esp+064h], ecx
        cmp ebp, byte 1
        je near .54
        cmp ebp, byte 2
        jne near .32
        call SetScreenTarget
        cmp dword [keepdesksong], byte 0
        jne short .21
        cmp byte [musicon], 0
        je short .21
        cmp dword [songdata], byte 0
        je short .21
        mov eax, dword [musichandle]
        mov ebx, 46h
        mov edx, 3
        call SetDigiChannelVolume
.20:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short MainDeskLoop.20
        mov ebp, dword [songdata]
        push ebp
        call PushMemDescriptorLocked
        add esp, byte 4
        xor eax, eax
        mov dword [songdata], eax
        jmp short .22
.21:
        xor edx, edx
        mov dword [keepdesksong], edx
.22:
        xor edi, edi
        cmp byte [musicon], 0
        je near .28
        mov edx, dword [songdata]
        test edx, edx
        jne near .28
        mov edi, 1
        cmp byte [desksongalt], 0
        je short .25
        mov ecx, str_Iff8
        mov ebx, str_Maindesk
        cmp byte [fileoncd+01DBh], 1
        jne short .23
        mov edx, dword [cddriveptr]
        jmp short .24
.23:
        xor edx, edx
.24:
        lea eax, [byte esp+020h]
        call MakePath
        xor dh, dh
        mov byte [desksongalt], dh
        jmp short .27
.25:
        mov ecx, str_Iff8
        mov ebx, str_Tonights2
        cmp byte [fileoncd+01DFh], 1
        jne short .26
        mov edx, dword [cddriveptr]
.26:
        lea eax, [byte esp+020h]
        call MakePath
        mov byte [desksongalt], 1
.27:
        lea eax, [byte esp+020h]
        call LoadDigiFile
        mov dword [songdata], eax
.28:
        push dword 1E0h
        push byte 0
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        xor ecx, ecx
        mov ebx, str_Easndesk
        cmp byte [fileoncd+06Ah], 1
        jne short .29
        mov edx, dword [cddriveptr]
        jmp short .30
.29:
        xor edx, edx
.30:
        lea eax, [byte esp+020h]
        call MakePath
        push byte 0
        lea eax, [byte esp+024h]
        push eax
        call LoadBank
        mov esi, eax
        add esp, byte 8
        mov ebp, eax
        push str_Desk2
        push eax
        call FindShape
        add esp, byte 8
        push eax
        call DrawBitmap
        add esp, byte 4
        push dword 0F8h
        mov ecx, 0F9h
        mov ebx, 0FAh
        mov edx, dword [byte esp+064h]
        mov eax, dword [byte esp+034h]
        call DrawMenuBar
        push str_Pal15
        push esi
        call FindShape
        add esp, byte 8
        lea esi, [byte eax+010h]
        cmp byte [musicon], 0
        je short .31
        cmp edi, byte 1
        jne short .31
        test byte [gameopts], 40h
        je short .31
        mov ebx, dword [songdata]
        test ebx, ebx
        je short .31
        mov edx, dword [musichandle]
        mov eax, ebx
        mov ecx, 4Ch
        mov ebx, 3
        call PlayDigiBlockLoop
.31:
        mov ebx, 10h
        mov edx, esi
        xor eax, eax
        call FadePalStep
        push ebp
        call FreeMemBlock
        add esp, byte 4
.32:
        xor eax, eax
        call SetScreenTitle
        mov ecx, dword [dword esp+098h]
        push ecx
        mov esi, dword [dword esp+098h]
        push esi
        call MouseSetPos
        add esp, byte 8
        call ClearInputQueue
        jmp near .53
.33:
        mov ebx, dword [dword esp+098h]
        push ebx
        mov ecx, dword [dword esp+098h]
        push ecx
        mov esi, dword [dword esp+098h]
        push esi
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [dword esp+09Ch]
        cmp eax, dword [byte esp+07Ch]
        je short .37
        mov esi, eax
        jmp short .36
.34:
        mov edi, esi
        shl edi, 2
        xor ebp, ebp
        mov dword [byte esp+edi+040h], ebp
        mov eax, dword [byte esp+edi+050h]
        test eax, eax
        je short .35
        mov ebp, esi
        mov edx, dword [byte esp+esi*8+04h]
        push edx
        mov ebx, dword [byte esp+esi*8+04h]
        push ebx
        push eax
        call PutBlock
        add esp, byte 0Ch
        xor eax, eax
        mov dword [byte esp+esi*8+04h], eax
        mov dword [esp+esi*8], eax
        mov edx, dword [byte esp+edi+050h]
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor ebx, ebx
        mov dword [byte esp+edi+050h], ebx
        mov dword [byte esp+edi+030h], ebx
        xor ebp, esi
        mov dword [byte esp+edi+060h], ebp
.35:
        dec esi
.36:
        mov edi, dword [byte esp+07Ch]
        cmp esi, edi
        jg short MainDeskLoop.34
        mov dword [dword esp+09Ch], edi
.37:
        push dword 0F8h
        push dword 0F9h
        mov eax, dword [dword esp+084h]
        mov ebx, dword [byte esp+eax*8+0Ch]
        mov edx, dword [byte esp+eax*8+08h]
        mov ecx, dword [byte esp+eax*4+048h]
        shl ecx, 5
        mov eax, dword [byte esp+eax*4+038h]
        add eax, ecx
        mov ecx, 0FAh
        call DrawMenuItemSel
        mov edx, dword [byte esp+07Ch]
        mov eax, dword [byte esp+078h]
        mov dword [byte esp+edx*4+040h], eax
        push dword 0F8h
        push dword 0F9h
        mov ebx, dword [byte esp+edx*8+0Ch]
        mov eax, dword [byte esp+edx*8+08h]
        mov ecx, dword [byte esp+edx*4+048h]
        shl ecx, 5
        mov esi, dword [byte esp+edx*4+038h]
        add esi, ecx
        mov ecx, 0FAh
        mov edx, eax
        mov eax, esi
.38:
        call DrawMenuItemNorm
        jmp near .53
.39:
        cmp dword [byte eax+018h], byte 0
        je near .48
        mov ecx, dword [dword esp+098h]
        push ecx
        mov esi, dword [dword esp+098h]
        push esi
        mov edi, dword [dword esp+098h]
        push edi
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [dword esp+09Ch]
        cmp eax, dword [byte esp+07Ch]
        je short .43
        mov esi, eax
        jmp short .42
.40:
        mov edi, esi
        shl edi, 2
        xor ebp, ebp
        mov dword [byte esp+edi+040h], ebp
        mov eax, dword [byte esp+edi+050h]
        test eax, eax
        je short .41
        mov ebp, esi
        mov edx, dword [byte esp+esi*8+04h]
        push edx
        mov ebx, dword [byte esp+esi*8+04h]
        push ebx
        push eax
        call PutBlock
        add esp, byte 0Ch
        xor eax, eax
        mov dword [byte esp+esi*8+04h], eax
        mov dword [esp+esi*8], eax
        mov edx, dword [byte esp+edi+050h]
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor ebx, ebx
        mov dword [byte esp+edi+050h], ebx
        mov dword [byte esp+edi+030h], ebx
        xor ebp, esi
        mov dword [byte esp+edi+060h], ebp
.41:
        dec esi
.42:
        mov ecx, dword [byte esp+07Ch]
        cmp esi, ecx
        jg short MainDeskLoop.40
        mov dword [dword esp+09Ch], ecx
.43:
        push dword 0F8h
        push dword 0F9h
        mov edi, dword [dword esp+0A4h]
        mov ebx, dword [byte esp+edi*8+0Ch]
        mov edx, dword [byte esp+edi*8+08h]
        mov ecx, dword [byte esp+edi*4+048h]
        shl ecx, 5
        mov eax, dword [byte esp+edi*4+038h]
        add eax, ecx
        mov ecx, 0FAh
        call DrawMenuItemSel
        mov eax, dword [byte esp+078h]
        mov dword [byte esp+edi*4+040h], eax
        push dword 0F8h
        push dword 0F9h
        mov ebx, dword [byte esp+edi*8+0Ch]
        mov edx, dword [byte esp+edi*8+08h]
        shl eax, 5
        mov ecx, dword [byte esp+edi*4+038h]
        add eax, ecx
        mov ecx, 0FAh
        call DrawMenuItemNorm
        mov eax, dword [byte esp+07Ch]
        mov ecx, dword [byte esp+078h]
        shl ecx, 5
        mov ebx, dword [byte esp+eax*4+030h]
        lea edx, [byte edi+01h]
        mov dword [dword esp+09Ch], edx
        mov ebx, dword [byte ecx+ebx+018h]
        mov dword [byte esp+edx*4+030h], ebx
        mov eax, dword [byte esp+eax*4+030h]
        add eax, ecx
        mov ebx, dword [byte eax+01Ch]
        mov dword [byte esp+edx*4+060h], ebx
        cmp edx, byte 1
        je short .44
        mov edx, dword [byte eax+08h]
        jmp short .45
.44:
        mov edx, dword [eax]
.45:
        mov eax, dword [dword esp+09Ch]
        mov ecx, dword [byte esp+eax*8-08h]
        add edx, ecx
        mov dword [esp+eax*8], edx
        mov edx, dword [byte esp+078h]
        shl edx, 5
        mov eax, dword [byte esp+07Ch]
        shl eax, 2
        cmp dword [dword esp+09Ch], byte 1
        je short .46
        mov eax, dword [byte esp+eax+030h]
        mov eax, dword [byte edx+eax+04h]
        jmp short .47
.46:
        mov eax, dword [byte esp+eax+030h]
        mov eax, dword [byte edx+eax+0Ch]
.47:
        mov edx, dword [dword esp+09Ch]
        shl edx, 3
        mov dword [dword esp+08Ch], edx
        mov edi, dword [byte esp+edx-04h]
        add eax, edi
        mov dword [byte esp+edx+04h], eax
        mov ebp, dword [dword esp+09Ch]
        mov edx, dword [byte esp+ebp*4+060h]
        shl edx, 5
        mov eax, dword [byte esp+ebp*4+030h]
        mov ebx, dword [byte edx+eax-018h]
        sub ebx, dword [eax]
        inc ebx
        mov dword [byte esp+070h], ebx
        mov edx, dword [byte edx+eax-014h]
        sub edx, dword [byte eax+04h]
        inc edx
        mov dword [byte esp+074h], edx
        push byte 20h
        mov eax, ebx
        imul eax, edx
        add eax, byte 11h
        push eax
        push str_Menubuff4
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [byte esp+ebp*4+050h], eax
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov eax, dword [byte esp+ebp*4+050h]
        mov edx, dword [byte esp+070h]
        mov word [byte eax+04h], dx
        mov eax, dword [byte esp+ebp*4+050h]
        mov edx, dword [byte esp+074h]
        mov word [byte eax+06h], dx
        mov eax, dword [dword esp+08Ch]
        mov edx, dword [byte esp+eax+04h]
        push edx
        mov ebx, dword [byte esp+eax+04h]
        push ebx
        mov ecx, dword [byte esp+ebp*4+058h]
        push ecx
        call GrabBlock
        add esp, byte 0Ch
        push dword 0F8h
        push dword 0F9h
        push dword 0FAh
        mov ecx, dword [dword esp+098h]
        mov ecx, dword [byte esp+ecx+010h]
        mov ebx, dword [dword esp+098h]
        mov ebx, dword [byte esp+ebx+0Ch]
        mov edx, dword [byte esp+ebp*4+06Ch]
        mov eax, dword [byte esp+ebp*4+03Ch]
        call DrawMenuDropdown
        xor esi, esi
        mov dword [byte esp+ebp*4+040h], esi
        push dword 0F8h
        push dword 0F9h
        mov ebx, dword [dword esp+094h]
        mov ebx, dword [byte esp+ebx+0Ch]
        mov edx, dword [dword esp+094h]
        mov edx, dword [byte esp+edx+08h]
        mov eax, dword [byte esp+ebp*4+038h]
        mov ecx, 0FAh
        jmp near MainDeskLoop.38
.48:
        mov eax, dword [dword esp+098h]
        push eax
        mov edx, dword [dword esp+098h]
        push edx
        mov ebx, dword [dword esp+098h]
        push ebx
        call PutBlock
        add esp, byte 0Ch
        jmp near .53
.49:
        mov edx, dword [dword esp+098h]
        push edx
        mov ebx, dword [dword esp+098h]
        push ebx
        mov ecx, dword [dword esp+098h]
        push ecx
        call PutBlock
        add esp, byte 0Ch
        mov esi, dword [dword esp+09Ch]
        jmp short .52
.50:
        mov ebp, esi
        shl ebp, 2
        xor eax, eax
        mov dword [byte esp+ebp+040h], eax
        mov edx, dword [byte esp+ebp+050h]
        test edx, edx
        je short .51
        mov ebx, dword [byte esp+esi*8+04h]
        push ebx
        mov ecx, dword [byte esp+esi*8+04h]
        push ecx
        push edx
        call PutBlock
        add esp, byte 0Ch
        xor edx, edx
        mov dword [byte esp+esi*8+04h], edx
        mov dword [esp+esi*8], edx
        mov ebx, dword [byte esp+ebp+050h]
        push ebx
        call FreeMemBlock
        add esp, byte 4
.51:
        dec esi
.52:
        test esi, esi
        jg short MainDeskLoop.50
        xor ebp, ebp
        mov dword [dword esp+09Ch], ebp
        mov dword [byte esp+03Ch], ebp
        mov dword [byte esp+038h], ebp
        mov dword [byte esp+034h], ebp
        mov dword [byte esp+05Ch], ebp
        mov dword [byte esp+058h], ebp
        mov dword [byte esp+054h], ebp
        mov dword [byte esp+050h], ebp
        mov dword [byte esp+04Ch], ebp
        mov dword [byte esp+048h], ebp
        mov dword [byte esp+044h], ebp
        mov dword [byte esp+06Ch], ebp
        mov dword [byte esp+068h], ebp
        mov dword [byte esp+064h], ebp
.53:
        mov edi, dword [dword esp+084h]
        push edi
        mov ebp, dword [dword esp+08Ch]
        push ebp
        mov eax, dword [dword esp+098h]
        push eax
        call GrabBlock
        add esp, byte 0Ch
        mov edx, dword [dword esp+084h]
        push edx
        mov ebx, dword [dword esp+08Ch]
        push ebx
        mov ecx, dword [pointerspr]
        push ecx
        jmp near MainDeskLoop.15
.54:
        call ClearInputQueue
        call InputRemove
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        add esp, 0A0h
MainDeskLoop_x:
        pop ebp
MainDeskLoop_x2:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; MenuExit                                                        3270B  95 PC
; File menu "Exit" action: returns 1 so MainDeskLoop ends
;-----------------------------------------------------------------------------
; C: src/front/desk_main/MenuExit.c
%ifdef CBUILD
%include "c/front/desk_main/MenuExit.inc"
%else
MenuExit:
        push dword 4
        call __CHK
        mov eax, 1
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SaveModeState                                                   3271B  95 PC
; Copies the current league name, DB path formats, HomeTeam/VisTeam, gameopts
; and controller teams/devices/sides into a 75h-byte mode state block
;-----------------------------------------------------------------------------
; C: src/front/desk_main/SaveModeState.c
%ifdef CBUILD
%include "c/front/desk_main/SaveModeState.inc"
%else
SaveModeState:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        mov ebx, eax
        add eax, byte 4
        mov edx, curleague
        call strcpy_
        lea eax, [byte ebx+011h]
        mov edx, leaguedbfmt
        call strcpy_
        lea eax, [byte ebx+031h]
        mov edx, leaguedbfmt2
        call strcpy_
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        mov dword [byte ebx+051h], eax
        mov eax, dword [VisTeam-2]
        sar eax, 10h
        mov dword [byte ebx+055h], eax
        mov eax, dword [gameopts]
        mov dword [byte ebx+059h], eax
        mov eax, dword [ctl1team]
        mov dword [byte ebx+05Dh], eax
        mov eax, dword [ctl2team]
        mov dword [byte ebx+061h], eax
        mov eax, dword [ctl1dev]
        mov dword [byte ebx+065h], eax
        mov eax, dword [ctl2dev]
        mov dword [byte ebx+069h], eax
        mov eax, dword [ctl1side]
        mov dword [byte ebx+06Dh], eax
        mov eax, dword [ctl2side]
        mov dword [byte ebx+071h], eax
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; LoadModeState                                                   327A1  95 PC
; The reverse of SaveModeState: sets gamemode (+0), curleague, paths,
; HomeTeam/VisTeam, gameopts and controller fields from a mode state block
;-----------------------------------------------------------------------------
; C: src/front/desk_main/MainDeskLoop.c (LoadModeState)
%ifdef CBUILD
%include "c/front/desk_main/MainDeskLoop.LoadModeState.inc"
%else
LoadModeState:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov ebx, eax
        lea edx, [byte eax+04h]
        mov eax, curleague
        call strcpy_
        lea edx, [byte ebx+011h]
        mov eax, leaguedbfmt
        call strcpy_
        lea edx, [byte ebx+031h]
        mov eax, leaguedbfmt2
        call strcpy_
        mov edx, dword [ebx]
        mov dword [gamemode], edx
        mov dx, word [byte ebx+051h]
        mov word [HomeTeam], dx
        mov dx, word [byte ebx+055h]
        mov word [VisTeam], dx
        mov edx, dword [byte ebx+059h]
        mov dword [gameopts], edx
        mov edx, dword [byte ebx+05Dh]
        mov dword [ctl1team], edx
        mov edx, dword [byte ebx+061h]
        mov dword [ctl2team], edx
        mov edx, dword [byte ebx+065h]
        mov dword [ctl1dev], edx
        mov edx, dword [byte ebx+069h]
        mov dword [ctl2dev], edx
        mov edx, dword [byte ebx+06Dh]
        mov dword [ctl1side], edx
        mov edx, dword [byte ebx+071h]
        mov dword [ctl2side], edx
        mov edx, dword [ctl1dev]
        cmp edx, byte 2
        jb short .1
        jbe short .2
        cmp edx, byte 4
        je short .3
        jmp short .4
.1:
        cmp edx, byte 1
        jne short .4
        test byte [ctlavailmask], 1
        jne short .4
        xor ecx, ecx
        mov dword [ctl1dev], ecx
        jmp short .4
.2:
        test byte [ctlavailmask], 2
        jne short .4
        xor ebx, ebx
        mov dword [ctl1dev], ebx
        jmp short .4
.3:
        test byte [ctlavailmask], 4
        jne short .4
        xor edx, edx
        mov dword [ctl1dev], edx
.4:
        mov edx, dword [ctl2dev]
        cmp edx, byte 2
        jb short .5
        jbe short .6
        cmp edx, byte 4
        je short .7
        jmp short .8
.5:
        cmp edx, byte 1
        jne short .8
        test byte [ctlavailmask], 1
        jne short .8
        xor ebp, ebp
        mov dword [ctl2dev], ebp
        jmp short .8
.6:
        test byte [ctlavailmask], 2
        jne short .8
        xor edi, edi
        mov dword [ctl2dev], edi
        jmp short .8
.7:
        test byte [ctlavailmask], 4
        jne short .8
        xor esi, esi
        mov dword [ctl2dev], esi
.8:
        cmp dword [ctl1dev], byte 0
        jne near .13
        test byte [ctlavailmask], 2
        je short .9
        cmp dword [ctl2dev], byte 2
        je short .9
        mov dword [ctl1dev], 2
        jmp near .13
.9:
        test byte [ctlavailmask], 4
        je short .10
        cmp dword [ctl2dev], byte 4
        je short .10
        mov dword [ctl1dev], 4
        jmp short .13
.10:
        test byte [ctlavailmask], 8
        je short .11
        cmp dword [ctl2dev], byte 8
        je short .11
        mov dword [ctl1dev], 8
        jmp short .13
.11:
        test byte [ctlavailmask], 1
        je short .12
        cmp dword [ctl2dev], byte 1
        je short .12
        mov dword [ctl1dev], 1
        jmp short .13
.12:
        mov dword [ctl1dev], 10h
.13:
        cmp dword [ctl2dev], byte 0
        jne near .18
        test byte [ctlavailmask], 2
        je short .14
        cmp dword [ctl1dev], byte 2
        je short .14
        mov dword [ctl2dev], 2
        jmp near .18
.14:
        test byte [ctlavailmask], 4
        je short .15
        cmp dword [ctl1dev], byte 4
        je short .15
        mov dword [ctl2dev], 4
        jmp short .18
.15:
        test byte [ctlavailmask], 8
        je short .16
        cmp dword [ctl1dev], byte 8
        je short .16
        mov dword [ctl2dev], 8
        jmp short .18
.16:
        test byte [ctlavailmask], 1
        je short .17
        cmp dword [ctl1dev], byte 1
        je short .17
        mov dword [ctl2dev], 1
        jmp short .18
.17:
        mov dword [ctl2dev], 10h
.18:
        cmp dword [ctl2dev], byte 10h
        sete al
        xor edx, edx
        mov dl, al
        mov ebx, edx
        mov eax, dword [ctl1dev]
        cmp eax, byte 10h
        sete dl
        and edx, 0FFh
        xor edx, ebx
        je short .21
        cmp eax, byte 10h
        jne short .19
        xor ebx, ebx
        mov edx, 1
        jmp short .20
.19:
        xor edx, edx
        mov ebx, 1
.20:
        cmp dword [nosplit edx*4+ctl1side], byte 0
        sete dl
        mov eax, edx
        and eax, 0FFh
        mov dword [nosplit ebx*4+ctl1side], eax
        sete dl
        xor eax, eax
        mov al, dl
        sub eax, byte 2
        mov dword [nosplit ebx*4+ctl1team], eax
.21:
        test byte [gameopts], 40h
        je short .22
        call EnableMidiMusic
        jmp short .23
.22:
        call DisableMidiMusic
.23:
        test byte [gameopts], 80h
        je short .24
        call EnableMidiSfx
        jmp short .25
.24:
        call DisableMidiSfx
.25:
        call SetSideControls
        cmp dword [gamemode], byte 0
        jne near MainDeskLoop_x
        mov edx, dword [HomeTeam-2]
        sar edx, 10h
        mov edx, dword [nosplit edx*4+teamabbrevs]
        cmp byte [byte edx+02h], 0
        je short .26
        mov ebx, 3
        mov eax, str_LAAtMTL+7
        call strncpy_
        jmp short .27
.26:
        mov ebx, 2
        mov eax, str_LAAtMTL+7
        call strncpy_
        mov byte [str_LAAtMTL+9], 20h
.27:
        mov edx, dword [VisTeam-2]
        sar edx, 10h
        mov edx, dword [nosplit edx*4+teamabbrevs]
        cmp byte [byte edx+02h], 0
        je short .28
        mov ebx, 3
        mov eax, str_LAAtMTL
        call strncpy_
        jmp near MainDeskLoop_x
.28:
        mov ebx, 2
        mov eax, str_LAAtMTL
        call strncpy_
        mov byte [str_LAAtMTL+2], 20h
        jmp near MainDeskLoop_x
%endif ; C
;-----------------------------------------------------------------------------
; WriteModeState                               32B1D  95 PC, medium confidence
; Fills a mode state block from the current globals and writes its 75h bytes
; to the mode's settings file (root for gamemode 0, else in the league dir)
;-----------------------------------------------------------------------------
; C: src/front/desk_main/MainDeskLoop.c (WriteModeState)
%ifdef CBUILD
%include "c/front/desk_main/MainDeskLoop.WriteModeState.inc"
%else
WriteModeState:
        push dword 5Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 2Ch
        mov ebp, eax
        cmp dword [gamemode], byte 0
        jne short .1
        mov edi, esp
        mov esi, str_GameSet4
        movsd
        movsd
        movsb
        jmp short .2
.1:
        mov ecx, str_Set
        mov ebx, str_Game
        mov edx, curleague
        mov eax, esp
        call MakePath
.2:
        mov eax, esp
        call FileExists
        test eax, eax
        jne short .3
        call DiskFreeBytes
        cmp eax, byte 75h
        jb near .6
.3:
        lea eax, [byte ebp+04h]
        mov edx, curleague
        call strcpy_
        lea eax, [byte ebp+011h]
        mov edx, leaguedbfmt
        call strcpy_
        lea eax, [byte ebp+031h]
        mov edx, leaguedbfmt2
        call strcpy_
        mov eax, dword [gamemode]
        mov dword [byte ebp+00h], eax
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        mov dword [byte ebp+051h], eax
        mov eax, dword [VisTeam-2]
        sar eax, 10h
        mov dword [byte ebp+055h], eax
        mov eax, dword [gameopts]
        mov dword [byte ebp+059h], eax
        mov eax, dword [ctl1team]
        mov dword [byte ebp+05Dh], eax
        mov eax, dword [ctl2team]
        mov dword [byte ebp+061h], eax
        mov eax, dword [ctl1dev]
        mov dword [byte ebp+065h], eax
        mov eax, dword [ctl2dev]
        mov dword [byte ebp+069h], eax
        mov eax, dword [ctl1side]
        mov dword [byte ebp+06Dh], eax
        mov eax, dword [ctl2side]
        mov dword [byte ebp+071h], eax
        lea edx, [byte esp+020h]
        mov eax, esp
        call FileCreate
        test eax, eax
        je short .4
        push str_fee2
        call FatalError
        add esp, byte 4
.4:
        mov ecx, 75h
        mov ebx, 0FFFFFFFFh
        mov edx, ebp
        mov eax, dword [byte esp+020h]
        call FileWriteAt
        test eax, eax
        je short .5
        push str_fee3
        call FatalError
        add esp, byte 4
.5:
        lea eax, [byte esp+020h]
        call FileClose
        test eax, eax
        je short .7
        push str_fee4
        call FatalError
        add esp, byte 4
        jmp short .7
.6:
        mov ebx, 140h
        mov dword [byte esp+028h], ebx
        mov ecx, 0F0h
        mov dword [byte esp+024h], ecx
        push ecx
        push ebx
        call MouseSetPos
        add esp, byte 8
        push dword 320h
        lea eax, [byte esp+028h]
        push eax
        lea eax, [byte esp+030h]
        push eax
        push byte 0
        push byte 0
        mov ecx, 3
        mov ebx, setdiskmsg
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
.7:
        add esp, byte 2Ch
        jmp near MainDeskLoop_x
%endif ; C
;-----------------------------------------------------------------------------
; CopyGameSettings                             32C9E  95 PC, medium confidence
; (src, dst): copies game.set (75h bytes) to dst, or into an existing dst
; only the 13 bytes at +4 and the dword at +59h; used by database_merge with
; the floppy path
;-----------------------------------------------------------------------------
; C: src/front/desk_main/CopyGameSettings.c
%ifdef CBUILD
%include "c/front/desk_main/CopyGameSettings.inc"
%else
CopyGameSettings:
        push dword 108h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        sub esp, 0F4h
        mov esi, edx
        lea edx, [dword esp+0F0h]
        call FileOpenRead
        test eax, eax
        je short .2
.1:
        mov eax, 0FFFFFFFFh
        jmp near .x
.2:
        mov ecx, 75h
        mov ebx, 0FFFFFFFFh
        lea edx, [byte esp+078h]
        mov eax, dword [dword esp+0F0h]
        call FileReadAt
        test eax, eax
        jne short CopyGameSettings.1
        lea eax, [dword esp+0F0h]
        call FileClose
        test eax, eax
        jne short CopyGameSettings.1
        lea edx, [dword esp+0F0h]
        mov eax, esi
        call FileOpenRW
        test eax, eax
        je short .3
        lea edx, [dword esp+0F0h]
        mov eax, esi
        call FileCreate
        test eax, eax
        jne short CopyGameSettings.1
        mov ecx, 1Dh
        mov edi, esp
        lea esi, [byte esp+078h]
        rep movsd
        movsb
        jmp short .4
.3:
        mov ecx, 75h
        mov ebx, 0FFFFFFFFh
        mov edx, esp
        mov eax, dword [dword esp+0F0h]
        call FileReadAt
        test eax, eax
        jne near CopyGameSettings.1
        mov eax, dword [dword esp+0D1h]
        mov dword [byte esp+059h], eax
        mov ebx, 0Dh
        lea edx, [byte esp+07Ch]
        lea eax, [byte esp+04h]
        call memcpy_
.4:
        mov ecx, 75h
        xor ebx, ebx
        mov edx, esp
        mov eax, dword [dword esp+0F0h]
        call FileWriteAt
        test eax, eax
        jne near CopyGameSettings.1
        lea eax, [dword esp+0F0h]
        call FileClose
        test eax, eax
        jne near CopyGameSettings.1
.x:
        add esp, 0F4h
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; MenuNewExhibition                                               32DA9  95 PC
; File menu "New Exhibition Game ...": disk check, controllers,
; PreGameScreen, PlayGame, then back to the desk (also resumes a saved
; exhibition)
;-----------------------------------------------------------------------------
; C: src/front/desk_main/MainDeskLoop.c (MenuNewExhibition)
%ifdef CBUILD
%include "c/front/desk_main/MainDeskLoop.MenuNewExhibition.inc"
%else
MenuNewExhibition:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov esi, eax
        xor edx, edx
        call CheckGameDiskSpace
        test eax, eax
        je short .1
        xor eax, eax
        jmp near MainDeskLoop_x
.1:
        mov dword [schedgameidx], edx
        mov dword [teamstatscb], GameTeamStatsScreen
        mov dword [skaterstatscb], GameSkaterStatsScreen
        mov dword [goaliestatscb], GameGoalieStatsScreen
        mov dword [standingscb], GameStandingsScreen
        mov dword [standingsmenucb], GameStandingsMenu
        call SetupControllers
        or byte [gameopts+1], 2
        cmp dword [esi], byte 0
        jge short .2
        xor eax, eax
        call InitGameSummary
        mov edx, dword [VisTeam-2]
        sar edx, 10h
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        call PreGameScreen
        mov edx, eax
        call InputRemove
.2:
        test dl, 4
        jne near .7
        mov eax, 1
        call SetupStatsSourceMenu
        cmp dword [esi], byte 0
        jl near .6
        push byte 20h
        push dword 300h
        push str_Palette2
        call AllocMemBlock
        add esp, byte 0Ch
        mov edi, eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        cmp byte [musicon], 0
        je short .3
        cmp dword [songdata], byte 0
        je short .3
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 3
        call SetDigiChannelVolume
.3:
        mov ebx, 10h
        mov edx, edi
        mov eax, 1
        call FadePalStep
        push edi
        call FreeMemBlock
        add esp, byte 4
        cmp byte [musicon], 0
        je short .5
        cmp dword [songdata], byte 0
        je short .5
.4:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short MenuNewExhibition.4
        mov edx, dword [songdata]
        push edx
        call PushMemDescriptorLocked
        add esp, byte 4
        xor ebx, ebx
        mov dword [songdata], ebx
.5:
        call ShowLoadingScreen
.6:
        mov eax, esi
        call PlayGame
        xor eax, eax
        call SetupStatsSourceMenu
.7:
        push byte 20h
        push dword 300h
        push str_Temp4
        call AllocMemBlock
        add esp, byte 0Ch
        mov esi, eax
        cmp byte [musicon], 0
        je short .8
        cmp dword [songdata], byte 0
        je short .8
        mov eax, dword [musichandle]
        mov ebx, 19h
        mov edx, 3
        call SetDigiChannelVolume
.8:
        push esi
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, esi
        mov eax, 1
        call FadePalStep
        push esi
        call FreeMemBlock
        add esp, byte 4
        cmp byte [musicon], 0
        je short .10
        cmp dword [songdata], byte 0
        je short .10
.9:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short MenuNewExhibition.9
        mov edi, dword [songdata]
        push edi
        call PushMemDescriptorLocked
        add esp, byte 4
        xor ebp, ebp
        mov dword [songdata], ebp
.10:
        call InputInstall
        mov dword [teamstatscb], EasnTeamStatsScreen
        mov dword [skaterstatscb], EasnSkaterStatsScreen
        mov dword [goaliestatscb], EasnGoalieStatsScreen
        mov dword [standingscb], EasnStandingsScreen
        mov dword [standingsmenucb], EasnStandingsMenu
        mov eax, 2
        jmp near MainDeskLoop_x
%endif ; C
;-----------------------------------------------------------------------------
; MenuNewLeague                                                   32FF4  95 PC
; File menu "New League ...": CreateNewLeague in lgstate, then enables Export
; / Next League Game / League Manager menu actions
;-----------------------------------------------------------------------------
; C: src/front/desk_main/MenuAddTeam.c (MenuNewLeague)
%ifdef CBUILD
%include "c/front/desk_main/MenuAddTeam.MenuNewLeague.inc"
%else
MenuNewLeague:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov eax, exhstate
        call SaveModeState
        mov dword [lgstate], 2
        mov dword [lgstate+51h], 0Ch
        mov dword [lgstate+55h], 15h
        or word [lgstate+59h], 2FFh
        cmp byte [musicon], 0
        je short .1
        or byte [lgstate+5Ah], 1
        jmp short .2
.1:
        and byte [lgstate+5Ah], 0FEh
.2:
        mov bl, byte [lgstate+5Ah]
        and bl, 83h
        mov byte [lgstate+5Ah], bl
        mov bh, bl
        or bh, 78h
        mov byte [lgstate+5Ah], bh
        mov cl, byte [ctlavailmask]
        test cl, 2
        je short .3
        mov dword [lgstate+65h], 2
        jmp short .7
.3:
        test cl, 4
        je short .4
        mov dword [lgstate+65h], 4
        jmp short .7
.4:
        test cl, 8
        je short .5
        mov dword [lgstate+65h], 8
        jmp short .7
.5:
        test cl, 1
        je short .6
        mov dword [lgstate+65h], 1
        jmp short .7
.6:
        mov dword [lgstate+65h], 10h
.7:
        cmp dword [lgstate+65h], byte 10h
        je short .8
        mov dword [lgstate+5Dh], 0Ch
        jmp short .9
.8:
        mov dword [lgstate+5Dh], 0FFFFFFFFh
.9:
        mov dword [lgstate+69h], 10h
        mov dword [lgstate+61h], 0FFFFFFFEh
        xor eax, eax
        mov dword [lgstate+6Dh], eax
        mov dword [lgstate+71h], 1
        mov eax, lgstate
        call LoadModeState
        xor eax, eax
        call SetLeagueSetImage
        call CreateNewLeague
        call SettingsStub
        cmp byte [lgstate+4], 0
        je short .10
        call BuildSavedGameLabels
        xor eax, eax
        call SetupStatsSourceMenu
        mov dword [menuact_export], MenuExportDbs
        mov dword [menuact_nextlg], MenuNextLeagueGame
        mov dword [menusub_lgmgr], leaguemgrmenu
        jmp short .11
.10:
        call BuildSavedGameLabels
        xor eax, eax
        call SetupStatsSourceMenu
        xor ebx, ebx
        mov dword [menuact_export], ebx
        mov dword [menuact_nextlg], ebx
        mov dword [menusub_lgmgr], ebx
.11:
        mov eax, exhstate
        call LoadModeState
        push byte 20h
        push dword 300h
        push str_Temp4
        call AllocMemBlock
        add esp, byte 0Ch
        mov esi, eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        cmp byte [musicon], 0
        je short .12
        cmp dword [songdata], byte 0
        je short .12
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 3
        call SetDigiChannelVolume
.12:
        mov ebx, 10h
        mov edx, esi
        mov eax, 1
        call FadePalStep
        push esi
        call FreeMemBlock
        add esp, byte 4
        cmp byte [musicon], 0
        je near MenuAddTeam_ret2
        cmp dword [songdata], byte 0
        je near MenuAddTeam_ret2
.13:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short MenuNewLeague.13
        mov ecx, dword [songdata]
        push ecx
        call PushMemDescriptorLocked
        add esp, byte 4
        xor esi, esi
        mov dword [songdata], esi
        jmp near MenuAddTeam_ret2
%endif ; C
;-----------------------------------------------------------------------------
; MenuAddTeam                                                     3322A  95 PC
; League Manager "Add Team to League ..." (AddHumanTeam in lgstate)
;-----------------------------------------------------------------------------
; C: src/front/desk_main/MenuAddTeam.c
%ifdef CBUILD
%include "c/front/desk_main/MenuAddTeam.inc"
%else
MenuAddTeam:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov eax, exhstate
        call SaveModeState
        mov eax, lgstate
        call LoadModeState
        mov eax, 3
        call SetupStatsSourceMenu
        call AddHumanTeam
MenuAddTeam_common:
        xor eax, eax
        call SetupStatsSourceMenu
        mov eax, lgstate
        call SaveModeState
        mov eax, exhstate
        call LoadModeState
        push byte 20h
        push dword 300h
        push str_Temp4
        call AllocMemBlock
        mov esi, eax
        add esp, byte 0Ch
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, esi
        mov eax, 1
        call FadePalStep
        push esi
        call FreeMemBlock
        add esp, byte 4
MenuAddTeam_ret2:
        mov eax, 2
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; MenuRemoveTeam                                                  332C0  95 PC
; League Manager "Remove Team From League ..." (RemoveHumanTeam)
;-----------------------------------------------------------------------------
MenuRemoveTeam:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov eax, exhstate
        call SaveModeState
        mov eax, lgstate
        call LoadModeState
        mov eax, 3
        call SetupStatsSourceMenu
        call RemoveHumanTeam
        jmp near MenuAddTeam_common
%endif ; C
;-----------------------------------------------------------------------------
; MenuLeagueSettings                                              332F6  95 PC
; League Manager "Change League Play Settings ..." (CheckMasterPassword,
; settings dialog)
;-----------------------------------------------------------------------------
; C: src/front/desk_main/MainDeskLoop.c (MenuLeagueSettings)
%ifdef CBUILD
%include "c/front/desk_main/MainDeskLoop.MenuLeagueSettings.inc"
%else
MenuLeagueSettings:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        xor edi, edi
        xor esi, esi
        mov eax, exhstate
        call SaveModeState
        mov eax, lgstate
        call LoadModeState
        call CheckMasterPassword
        test eax, eax
        jne short .1
        mov edi, 0FFFFFFFFh
.1:
        cmp byte [MergeResult], 0
        je short .2
        push byte 20h
        push dword 300h
        push str_Temp4
        call AllocMemBlock
        mov esi, eax
        add esp, byte 0Ch
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, esi
        mov eax, 1
        call FadePalStep
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov esi, 2
.2:
        test edi, edi
        je short .3
        call LeagueSettingsDlg
.3:
        mov eax, lgstate
        call SaveModeState
        mov eax, exhstate
        call LoadModeState
        mov eax, esi
        jmp near MainDeskLoop_x2
%endif ; C
;-----------------------------------------------------------------------------
; MenuRebuildDbs                                                  3339D  95 PC
; League Manager "Rebuild DataBases ..."
;-----------------------------------------------------------------------------
; C: src/front/desk_main/MenuAddTeam.c (MenuRebuildDbs)
%ifdef CBUILD
%include "c/front/desk_main/MenuAddTeam.MenuRebuildDbs.inc"
%else
MenuRebuildDbs:
        push dword 4
        call __CHK
        mov eax, exhstate
        call SaveModeState
        mov eax, lgstate
        call LoadModeState
        call RebuildLeagueDbs
MenuRebuildDbs_x:
        mov eax, lgstate
        call SaveModeState
        mov eax, exhstate
        call LoadModeState
        xor eax, eax
        ret
%endif ; C
;-----------------------------------------------------------------------------
; MenuMergeUpdateDbs                                              333D7  95 PC
; League Manager "Merge and Update Team Databases ..."
;-----------------------------------------------------------------------------
; C: src/front/desk_main/MenuAddTeam.c (MenuMergeUpdateDbs)
%ifdef CBUILD
%include "c/front/desk_main/MenuAddTeam.MenuMergeUpdateDbs.inc"
%else
MenuMergeUpdateDbs:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov eax, exhstate
        call SaveModeState
        mov eax, lgstate
        call LoadModeState
        call MergeUpdateDbs
        mov esi, eax
        mov eax, lgstate
        call SaveModeState
        mov eax, exhstate
        call LoadModeState
        test esi, esi
        je short .1
        push byte 20h
        push dword 300h
        push str_Temp4
        call AllocMemBlock
        mov esi, eax
        add esp, byte 0Ch
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, esi
        mov eax, 1
        call FadePalStep
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov eax, 2
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        xor eax, eax
        pop esi
        pop edx
        pop ecx
        pop ebx
MenuMergeUpdateDbs_ret:
        ret
%endif ; C
;-----------------------------------------------------------------------------
; MenuMergeLeagueFiles                                            33469  95 PC
; League Manager "Merge League Files ..."
;-----------------------------------------------------------------------------
; C: src/front/desk_main/MenuAddTeam.c (MenuMergeLeagueFiles)
%ifdef CBUILD
%include "c/front/desk_main/MenuAddTeam.MenuMergeLeagueFiles.inc"
%else
MenuMergeLeagueFiles:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov eax, exhstate
        call SaveModeState
        mov eax, lgstate
        call LoadModeState
        call MergeLeagueFiles
        mov esi, eax
        mov eax, lgstate
        call SaveModeState
        mov eax, exhstate
        call LoadModeState
        test esi, esi
        je short .1
        push byte 20h
        push dword 300h
        push str_Temp4
        call AllocMemBlock
        mov esi, eax
        add esp, byte 0Ch
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, esi
        mov eax, 1
        call FadePalStep
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov eax, 2
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        xor eax, eax
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; MenuUpdateTeamDbs                                               334FB  95 PC
; League Manager "Update Teams DataBases ..."
;-----------------------------------------------------------------------------
; C: src/front/desk_main/MenuAddTeam.c (MenuUpdateTeamDbs)
%ifdef CBUILD
%include "c/front/desk_main/MenuAddTeam.MenuUpdateTeamDbs.inc"
%else
MenuUpdateTeamDbs:
        push dword 4
        call __CHK
        mov eax, exhstate
        call SaveModeState
        mov eax, lgstate
        call LoadModeState
        call UpdateTeamDbs
        jmp near MenuRebuildDbs_x
%endif ; C
;-----------------------------------------------------------------------------
; MenuTradePlayers                                                33523  95 PC
; League Manager "Trade Players ..." (TradePlayers in lgstate)
;-----------------------------------------------------------------------------
; C: src/front/desk_main/MenuAddTeam.c (MenuTradePlayers)
%ifdef CBUILD
%include "c/front/desk_main/MenuAddTeam.MenuTradePlayers.inc"
%else
MenuTradePlayers:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov eax, exhstate
        call SaveModeState
        mov eax, lgstate
        call LoadModeState
        mov eax, 3
        call SetupStatsSourceMenu
        call TradePlayers
        jmp near MenuAddTeam_common
%endif ; C
;-----------------------------------------------------------------------------
; MenuNextLeagueGame                                              33559  95 PC
; File menu "Next League Game ...": opens curleague\game.sav, plays the
; league game (PlayLeagueGame), sets the EASN league stats callbacks
;-----------------------------------------------------------------------------
; C: src/front/desk_main/MenuAddTeam.c (MenuNextLeagueGame)
%ifdef CBUILD
%include "c/front/desk_main/MenuAddTeam.MenuNextLeagueGame.inc"
%else
MenuNextLeagueGame:
        push dword 40h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        sub esp, byte 20h
        mov ebx, eax
        mov eax, exhstate
        call SaveModeState
        mov eax, lgstate
        call LoadModeState
        mov eax, 3
        call SetupStatsSourceMenu
        mov eax, 1
        call SetLeagueSetImage
        mov eax, 2
        call SetScreenTitle
        cmp dword [ebx], byte 0
        jge short .1
        mov edx, curleague
        mov eax, esp
        call strcpy_
        mov edx, str_GameSav4
        mov eax, esp
        call strcat_
        mov edx, ebx
        mov eax, esp
        call FileOpenRead
        test eax, eax
        je short .1
        mov dword [ebx], 0FFFFFFFFh
.1:
        mov eax, ebx
        call PlayLeagueGame
        mov dword [teamstatscb], EasnTeamStatsScreen
        mov dword [skaterstatscb], EasnSkaterStatsScreen
        mov dword [goaliestatscb], EasnGoalieStatsScreen
        mov dword [standingscb], EasnStandingsScreen
        mov dword [standingsmenucb], EasnStandingsMenu
        xor eax, eax
        call SetupStatsSourceMenu
        mov eax, lgstate
        call SaveModeState
        mov eax, exhstate
        call LoadModeState
        push byte 20h
        push dword 300h
        push str_Temp4
        call AllocMemBlock
        mov esi, eax
        add esp, byte 0Ch
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, esi
        mov eax, 1
        call FadePalStep
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov eax, 2
        add esp, byte 20h
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; MenuLeagueHilights                                              3366F  95 PC
; League Manager "League Hilights ..."
;-----------------------------------------------------------------------------
; C: src/front/desk_main/MenuAddTeam.c (MenuLeagueHilights)
%ifdef CBUILD
%include "c/front/desk_main/MenuAddTeam.MenuLeagueHilights.inc"
%else
MenuLeagueHilights:
        push dword 8
        call __CHK
        push edx
        mov eax, exhstate
        call SaveModeState
        mov eax, lgstate
        call LoadModeState
        xor edx, edx
        mov dword [gamemode], edx
        call ViewHilights
        test eax, eax
        jne short .1
        mov eax, exhstate
        call LoadModeState
        mov eax, 2
        pop edx
        ret
.1:
        mov eax, exhstate
        call LoadModeState
        xor eax, eax
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; MenuImportDbs                                                   336BE  95 PC
; File menu "Import Databases ..."
;-----------------------------------------------------------------------------
; C: src/front/desk_main/MenuAddTeam.c (MenuImportDbs)
%ifdef CBUILD
%include "c/front/desk_main/MenuAddTeam.MenuImportDbs.inc"
%else
MenuImportDbs:
        push dword 4
        call __CHK
        mov eax, exhstate
        call SaveModeState
        mov eax, lgstate
        call LoadModeState
        call ImportDbs
        jmp near MenuRebuildDbs_x
%endif ; C
;-----------------------------------------------------------------------------
; MenuExportDbs                                336E6  95 PC, medium confidence
; File menu "Export Databases ..." action installed with a league (ExportDbs
; in lgstate)
;-----------------------------------------------------------------------------
; C: src/front/desk_main/MenuAddTeam.c (MenuExportDbs)
%ifdef CBUILD
%include "c/front/desk_main/MenuAddTeam.MenuExportDbs.inc"
%else
MenuExportDbs:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov eax, exhstate
        call SaveModeState
        mov eax, lgstate
        call LoadModeState
        mov eax, 3
        call SetupStatsSourceMenu
        call ExportDbs
        jmp near MenuAddTeam_common
%endif ; C
;-----------------------------------------------------------------------------
; DemoSetupStub                                                   3371C  95 PC
; Empty; called before the scoreboard demo starts
;-----------------------------------------------------------------------------
; C: src/front/desk_main/DemoSetupStub.c
%ifdef CBUILD
%include "c/front/desk_main/DemoSetupStub.inc"
%else
DemoSetupStub:
        push dword 4
        call __CHK
        ret
%endif ; C
;-----------------------------------------------------------------------------
; FreeRinkGfx                                  33727  95 PC, medium confidence
; Frees rinkbm and the rinktilebm buffer (resets currink to -1); used by
; cdstream and highlights
;-----------------------------------------------------------------------------
; C: src/front/desk_main/FreeRinkGfx.c
%ifdef CBUILD
%include "c/front/desk_main/FreeRinkGfx.inc"
%else
FreeRinkGfx:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push ebp
        mov edx, dword [rinkbm]
        test edx, edx
        je short .1
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov dword [rinkbm], ecx
.1:
        mov esi, dword [rinktilebm]
        test esi, esi
        je short .x
        push esi
        call FreeMemBlock
        add esp, byte 4
        xor ebp, ebp
        mov dword [rinktilebm], ebp
        mov dword [currink], 0FFFFFFFFh
.x:
        pop ebp
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
