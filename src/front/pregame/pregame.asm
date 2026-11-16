; The pre-game matchup at the arena, and tonight's game with the team logos and the injured list.
bits 32
%include "hockey.inc"
section s_29F18 progbits alloc exec nowrite align=1
extern __CHK, awlinetab, boxfillcolor, boxlitecolor, boxshadecolor, byte_D42C3, cddriveptr, ClearInputQueue
extern cont2team, crestnames, ctl1team, ctl2team, curleague, DrawBevelBox, DrawButtons, DrawGadgetByType
extern hmteamrec_skaters, FadePalStep, FileClose, fileoncd, FileOpenRead, FitPlayerName, fputchar, FreeMemBlock
extern GameLineEditor, gameopts, GetInputEvent, hmlinetab, hmroster, HomeTeam, kaufmfont, leaguedbnames
extern mainfont, MakePath, memcpy_, MouseSetPos, MusicChanReset2, musichandle, musicon, musicslot
extern menuact_homelines, menuact_visitorlines, PaLineups, PaOpenBank, PaPlayoffTonight, PaPreloadClips, PaTonightIntro, pointerspr
extern pregamebuttons, PrintOutlinedText, PrintShadowText, ptrupdatefn, ReadKeyRec, ReadTeamRec, schedgameidx, scoutcatidx
extern scoutcatnames, SetDialogColors, SetTextColors, ShowLoadingScreen, songdata, SpeechBusy, sprintf_, str_Apal
extern str_Arena, str_Bkgd4, str_Ctbkgd, str_Ctlogo, str_Cttitle1, str_D4, str_Def, str_extDB
extern str_Fowa, str_GIPK, str_Iff4, str_Iff5, str_Indus030, str_Injured, str_Logoaway, str_Logohome
extern str_Pal10, str_Pal11, str_Pal12, str_Pointer4, str_Rink, str_SAtS, str_Scouting, str_Scra
extern str_Screen, str_Srlogo, str_Tlu, str_Tonights, str_Top, str_VFN, AllocMemBlock, PushMemDescriptorLocked
extern LoadBank, sub_8E8A0, TextSaveState, TextRestoreState, TextSetFont, LoadDigiFile, PlayDigiBlockLoop, SndQuery
extern SetDigiChannelVolume, SetPalette, PutBlock, DrawBitmap, FillRect, DrawArt, sub_913D0, GrabBlock
extern SetViewRect, FindShape, ClearScreen, SetScreenTarget, SetClipWindow, FillRectColor, teamabbrevs, teamconf
extern TrackButtons, pregamelinesmenubar, VisTeam, WaitClickTimeout
global PreGameScreen_jt, PreGameScreen, PreGameScreen_awaylines, PreGameScreen_play, PreGameScreen_cancel, PreGameScreen_homelines, TonightsGameScreen
PreGameScreen_jt:
        dd PreGameScreen_awaylines
        dd PreGameScreen_play
        dd PreGameScreen_cancel
        dd PreGameScreen_homelines
;-----------------------------------------------------------------------------
; PreGameScreen                                                   29F28  95 PC
; Pre-game arena screen: apal / arena / rink / srlogo shapes, "%s   at   %s",
; scouting comparison (scoutcatnames), buttons Away lines / Play / Cancel /
; Home lines (pregamebuttons; lines go to the line editor GameLineEditor),
; then TonightsGameScreen; called from temp_files / import_export /
; season_playoffs before a game
;-----------------------------------------------------------------------------
; C: src/front/pregame/PreGameScreen.c
%ifdef CBUILD
%include "c/front/pregame/PreGameScreen.inc"
%else
PreGameScreen:
        push dword 6A0h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, 674h
        mov byte [dword esp+0670h], al
        mov byte [dword esp+066Ch], dl
        mov dword [dword esp+0638h], 0FFFFFFFFh
        call PaOpenBank
        push dword 0F7h
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
        mov edx, 0F7h
        mov eax, 0FAh
        call SetTextColors
        push byte 20h
        push dword 300h
        push str_Apal
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [dword esp+0644h], eax
        mov al, byte [dword esp+0670h]
        mov byte [dword esp+0668h], al
        mov al, byte [dword esp+066Ch]
        mov byte [dword esp+0669h], al
        mov ebx, dword [leaguedbnames+10h]
        mov ecx, str_extDB
        mov edx, curleague
        lea eax, [dword esp+0610h]
        call MakePath
        lea edx, [dword esp+0638h]
        lea eax, [dword esp+0610h]
        call FileOpenRead
        xor cl, cl
        jmp short .2
.1:
        xor edx, edx
        mov dl, cl
        xor ebx, ebx
        mov bl, byte [dword esp+edx+0668h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        mov edx, eax
        shl eax, 5
        sub eax, edx
        mov edx, esp
        add edx, eax
        mov eax, dword [dword esp+0638h]
        call ReadTeamRec
        inc cl
.2:
        cmp cl, 2
        jae short .3
        test eax, eax
        je short PreGameScreen.1
.3:
        lea eax, [dword esp+0638h]
        call FileClose
        call SetScreenTarget
        push byte 20h
        push dword 300h
        push str_Pal10
        call AllocMemBlock
        add esp, byte 0Ch
        mov esi, eax
        cmp byte [musicon], 0
        je short .4
        cmp dword [songdata], byte 0
        je short .4
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 3
        call SetDigiChannelVolume
.4:
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
        je short .6
        cmp dword [songdata], byte 0
        je short .6
.5:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short PreGameScreen.5
        mov esi, dword [songdata]
        push esi
        call PushMemDescriptorLocked
        add esp, byte 4
        xor edi, edi
        mov dword [songdata], edi
.6:
        mov ebp, dword [kaufmfont]
        mov eax, dword [mainfont]
        mov dword [dword esp+0648h], eax
        lea eax, [dword esp+05D0h]
        push eax
        call TextSaveState
        add esp, byte 4
        mov eax, dword [dword esp+0648h]
        push eax
        call TextSetFont
        add esp, byte 4
        xor ecx, ecx
        mov ebx, str_Arena
        cmp byte [fileoncd+027h], 1
        jne short .7
        mov edx, dword [cddriveptr]
        jmp short .8
.7:
        xor edx, edx
.8:
        lea eax, [dword esp+0610h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0614h]
        push eax
        call LoadBank
        mov esi, eax
        add esp, byte 8
        push str_Pal11
        push eax
        call FindShape
        add esp, byte 8
        lea edx, [byte eax+010h]
        mov ebx, 300h
        mov eax, dword [dword esp+0644h]
        call memcpy_
        push str_Rink
        push esi
        call FindShape
        mov edi, eax
        add esp, byte 8
        push dword 1E0h
        push byte 0
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        push edi
        call DrawBitmap
        add esp, byte 4
        push esi
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov ebx, str_Srlogo
        cmp byte [fileoncd+0219h], 1
        jne short .9
        mov edx, dword [cddriveptr]
        jmp short .10
.9:
        xor edx, edx
.10:
        lea eax, [dword esp+0610h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0614h]
        push eax
        call LoadBank
        mov esi, eax
        add esp, byte 8
        xor eax, eax
        mov al, byte [dword esp+066Ch]
        mov edx, dword [nosplit eax*4+crestnames]
        push edx
        push esi
        call FindShape
        add esp, byte 8
        push byte 6Dh
        push byte 3Ch
        push eax
        call DrawArt
        add esp, byte 0Ch
        xor eax, eax
        mov al, byte [dword esp+0670h]
        mov ebx, dword [nosplit eax*4+crestnames]
        push ebx
        push esi
        call FindShape
        add esp, byte 8
        push byte 6Dh
        push dword 1E5h
        push eax
        call DrawArt
        add esp, byte 0Ch
        push esi
        call FreeMemBlock
        add esp, byte 4
        push ebp
        call TextSetFont
        add esp, byte 4
        lea eax, [byte esp+01Ah]
        push eax
        lea eax, [dword esp+0306h]
        push eax
        push str_SAtS
        lea eax, [dword esp+061Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        lea eax, [dword esp+0610h]
        push eax
        call fputchar
        add esp, byte 4
        mov edx, 280h
        sub edx, eax
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        lea ebx, [dword esp+0610h]
        mov edx, 93h
        call PrintOutlinedText
        mov ecx, dword [boxfillcolor]
        push ecx
        push byte 5
        push dword 1AEh
        push dword 0CFh
        push byte 6Eh
        call FillRect
        add esp, byte 14h
        mov esi, dword [boxlitecolor]
        push esi
        push dword 0CFh
        push dword 21Ch
        push dword 0CFh
        push byte 6Eh
        call FillRectColor
        add esp, byte 14h
        mov edi, dword [boxshadecolor]
        push edi
        push dword 0D3h
        push dword 21Ch
        push dword 0D3h
        push byte 6Eh
        call FillRectColor
        add esp, byte 14h
        xor esi, esi
.11:
        xor eax, eax
        mov al, byte [byte_D42C3]
        add eax, byte 3
        imul eax, esi
        lea edi, [dword eax+0DAh]
        cmp esi, byte 8
        jne short .12
        mov ebp, dword [boxfillcolor]
        push ebp
        push byte 5
        push dword 1AEh
        lea ebp, [byte edi+05h]
        push ebp
        push byte 6Eh
        call FillRect
        add esp, byte 14h
        mov eax, dword [boxlitecolor]
        push eax
        push ebp
        push dword 21Ch
        lea eax, [byte edi+09h]
        mov dword [dword esp+0648h], eax
        push ebp
        push byte 6Eh
        call FillRectColor
        add esp, byte 14h
        mov edx, dword [boxshadecolor]
        push edx
        mov ebx, dword [dword esp+0640h]
        push ebx
        push dword 21Ch
        add edi, byte 0Eh
        push ebx
        push byte 6Eh
        call FillRectColor
        add esp, byte 14h
.12:
        mov ebp, dword [nosplit esi*4+scoutcatnames]
        push ebp
        call fputchar
        add esp, byte 4
        mov edx, 280h
        sub edx, eax
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov ebx, ebp
        mov edx, edi
        call PrintOutlinedText
        inc esi
        cmp esi, byte 9
        jl near PreGameScreen.11
        lea eax, [dword esp+05C4h]
        mov dword [dword esp+065Ch], eax
        lea eax, [dword esp+02DCh]
        mov dword [dword esp+0658h], eax
        xor esi, esi
.13:
        mov ebp, 0FAh
        mov ecx, ebp
        xor eax, eax
        mov al, byte [dword esi+scoutcatidx]
        mov edx, dword [dword esp+065Ch]
        add edx, eax
        add eax, dword [dword esp+0658h]
        mov bl, byte [edx]
        mov bh, byte [eax]
        cmp bl, bh
        jbe short .14
        mov ebp, 0FDh
        jmp short .15
.14:
        jae short .15
        mov ecx, 0FDh
.15:
        xor eax, eax
        mov al, byte [byte_D42C3]
        lea edi, [byte eax+03h]
        imul edi, esi
        add edi, 0DAh
        cmp esi, byte 8
        jne short .16
        add edi, byte 0Ch
.16:
        mov edx, 0F7h
        mov eax, ebp
        call SetTextColors
        xor eax, eax
        mov al, byte [dword esi+scoutcatidx]
        add eax, dword [dword esp+065Ch]
        mov al, byte [eax]
        and eax, 0FFh
        push eax
        push str_D4
        lea eax, [dword esp+0618h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea ebx, [dword esp+0610h]
        mov edx, edi
        mov eax, 6Eh
        call PrintOutlinedText
        mov edx, 0F7h
        mov eax, ecx
        call SetTextColors
        xor eax, eax
        mov al, byte [dword esi+scoutcatidx]
        add eax, dword [dword esp+0658h]
        mov al, byte [eax]
        and eax, 0FFh
        push eax
        push str_D4
        lea eax, [dword esp+0618h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea ebx, [dword esp+0610h]
        mov edx, edi
        mov eax, 212h
        call PrintOutlinedText
        inc esi
        cmp esi, byte 9
        jl near PreGameScreen.13
        mov edx, 0F7h
        mov eax, 0FAh
        call SetTextColors
        mov ebx, dword [dword esp+0648h]
        push ebx
        call TextSetFont
        add esp, byte 4
        cmp dword [menuact_homelines], byte 0
        jne short .18
        cmp dword [menuact_visitorlines], byte 0
        jne short .18
        mov dword [dword esp+0650h], 2
.17:
        mov dword [dword esp+0654h], pregamebuttons+1Ch
        jmp short .22
.18:
        cmp dword [menuact_homelines], byte 0
        jne short .19
        mov dword [dword esp+0650h], 3
        jmp short .21
.19:
        cmp dword [menuact_visitorlines], byte 0
        jne short .20
        mov dword [dword esp+0650h], 3
        jmp short PreGameScreen.17
.20:
        mov dword [dword esp+0650h], 4
.21:
        mov dword [dword esp+0654h], pregamebuttons
.22:
        push byte 1
        mov ecx, 1DFh
        mov ebx, 26Bh
        mov edx, 1AEh
        xor eax, eax
        call DrawBevelBox
        mov edx, dword [dword esp+0650h]
        mov eax, dword [dword esp+0654h]
        call DrawButtons
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
        push str_Pointer4
        call AllocMemBlock
        mov dword [dword esp+0648h], eax
        add esp, byte 0Ch
        mov dword [dword esp+0660h], eax
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
        mov edx, dword [dword esp+063Ch]
        mov word [byte edx+04h], ax
        mov eax, dword [pointerspr]
        mov ax, word [byte eax+06h]
        inc eax
        mov word [byte edx+06h], ax
        xor ebp, ebp
        mov dword [dword esp+0630h], ebp
        xor esi, esi
        mov dword [dword esp+0634h], ebp
        push dword 1E0h
        push dword 280h
        push ebp
        push ebp
        call SetViewRect
        add esp, byte 10h
        mov ecx, dword [dword esp+0634h]
        push ecx
        mov edi, dword [dword esp+0634h]
        push edi
        call MouseSetPos
        add esp, byte 8
        push ebp
        push ebp
        mov eax, dword [dword esp+0644h]
        push eax
        call GrabBlock
        add esp, byte 0Ch
        push ebp
        push ebp
        mov edx, dword [pointerspr]
        push edx
        call DrawArt
        add esp, byte 0Ch
        call ClearInputQueue
        cmp byte [musicon], 0
        je short .25
        cmp dword [songdata], byte 0
        jne short .25
        mov ecx, str_Iff4
        mov ebx, str_Scouting
        cmp byte [fileoncd+01E3h], 1
        jne short .23
        mov edx, dword [cddriveptr]
        jmp short .24
.23:
        xor edx, edx
.24:
        lea eax, [dword esp+0610h]
        call MakePath
        lea eax, [dword esp+0610h]
        call LoadDigiFile
        mov dword [songdata], eax
        test eax, eax
        je short .25
        test byte [gameopts], 40h
        je short .25
        mov edx, dword [musichandle]
        mov ecx, 4Ch
        mov ebx, 3
        call PlayDigiBlockLoop
.25:
        mov ebx, 10h
        mov edx, dword [dword esp+0644h]
        xor eax, eax
        call FadePalStep
        cmp dword [schedgameidx], 444h
        jge short .26
        xor edx, edx
        mov dl, byte [dword esp+066Ch]
        xor eax, eax
        mov al, byte [dword esp+0670h]
        call PaTonightIntro
        jmp near .31
.26:
        xor edx, edx
        mov dl, byte [dword esp+0670h]
        shl edx, 2
        xor eax, eax
        mov al, byte [dword esp+066Ch]
        shl eax, 2
        mov ebx, dword [dword edx+teamconf]
        mov edi, dword [dword eax+teamconf]
        cmp ebx, edi
        je short .27
        mov ecx, 3
        jmp short .28
.27:
        mov edx, dword [dword edx+teamconf]
        or edx, edi
        mov ebx, 2
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        lea ecx, [byte edx+01h]
.28:
        mov eax, 1
        cmp dword [schedgameidx], 47Ch
        jl short .29
        mov eax, 2
.29:
        cmp dword [schedgameidx], 498h
        jl short .30
        mov eax, 3
.30:
        push eax
        mov edx, dword [schedgameidx]
        sub edx, 444h
        mov ebx, 7
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        lea ebx, [byte edx+01h]
        xor edx, edx
        mov dl, byte [dword esp+0670h]
        xor eax, eax
        mov al, byte [dword esp+0674h]
        call PaPlayoffTonight
.31:
        xor ebx, ebx
        mov dword [dword esp+0664h], ebx
        mov dword [dword esp+0640h], ebx
.32:
        xor edi, edi
        mov dword [dword esp+064Ch], edi
.33:
        call GetInputEvent
        mov ecx, eax
        test eax, eax
        je short .34
        lea ebx, [dword esp+0634h]
        lea edx, [dword esp+0630h]
        call dword [ptrupdatefn]
        mov dword [dword esp+064Ch], eax
.34:
        test ecx, ecx
        je short .35
        test byte [dword esp+064Ch], 6
        je short PreGameScreen.33
.35:
        cmp dword [dword esp+064Ch], byte 0
        jne short .37
        cmp ebp, dword [dword esp+0630h]
        jne short .36
        cmp esi, dword [dword esp+0634h]
        je near PreGameScreen_homelines.7
.36:
        push esi
        push ebp
        mov ecx, dword [dword esp+0668h]
        push ecx
        call PutBlock
        add esp, byte 0Ch
        mov esi, dword [dword esp+0634h]
        push esi
        mov edi, dword [dword esp+0634h]
        push edi
        mov ebp, dword [dword esp+0668h]
        push ebp
        call GrabBlock
        add esp, byte 0Ch
        mov eax, dword [dword esp+0634h]
        push eax
        mov edx, dword [dword esp+0634h]
        push edx
        mov ebx, dword [pointerspr]
        push ebx
        jmp near PreGameScreen_homelines.5
.37:
        test byte [dword esp+064Ch], 4
        je short .38
        mov dword [dword esp+0664h], 0FFFFFFFFh
        mov dword [dword esp+0640h], 3
        jmp near PreGameScreen_homelines.7
.38:
        push esi
        push ebp
        mov edx, dword [dword esp+0668h]
        push edx
        call PutBlock
        add esp, byte 0Ch
        mov ebx, dword [dword esp+064Ch]
        push ebx
        mov ecx, dword [dword esp+0638h]
        mov ebx, dword [dword esp+0634h]
        mov edx, dword [dword esp+0654h]
        mov eax, dword [dword esp+0658h]
        call TrackButtons
        mov edx, eax
        test eax, eax
        jl near PreGameScreen_homelines.4
        cmp dword [menuact_visitorlines], byte 0
        jne short .39
        lea edx, [byte eax+01h]
.39:
        cmp edx, byte 3
        ja near PreGameScreen_homelines.3
        jmp dword [nosplit cs:edx*4+PreGameScreen_jt]
PreGameScreen_awaylines:
        mov eax, dword [VisTeam-2]
        sar eax, 10h
        cmp eax, dword [ctl1team]
        je short .1
        cmp eax, dword [ctl2team]
        jne near PreGameScreen_homelines.3
.1:
        push byte 20h
        push dword 4B011h
        push str_Screen
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
        mov word [byte eax+04h], 280h
        mov word [byte eax+06h], 1E0h
        push byte 0
        push byte 0
        push eax
        call GrabBlock
        add esp, byte 0Ch
        mov ecx, 3
        mov ebx, pregamelinesmenubar
        mov edx, awlinetab
        mov eax, 1
        jmp near PreGameScreen_homelines.2
PreGameScreen_play:
        mov dword [dword esp+0664h], 0FFFFFFFFh
        jmp near PreGameScreen_homelines.3
PreGameScreen_cancel:
        mov dword [dword esp+0664h], 0FFFFFFFFh
        mov dword [dword esp+0640h], 3
        jmp near PreGameScreen_homelines.3
PreGameScreen_homelines:
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        cmp eax, dword [ctl1team]
        je short .1
        cmp eax, dword [ctl2team]
        jne near .3
.1:
        push byte 20h
        push dword 4B011h
        push str_Screen
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
        mov word [byte eax+04h], 280h
        mov word [byte eax+06h], 1E0h
        push byte 0
        push byte 0
        push eax
        call GrabBlock
        add esp, byte 0Ch
        mov ecx, 3
        mov ebx, pregamelinesmenubar
        mov edx, hmlinetab
        xor eax, eax
.2:
        call GameLineEditor
        push byte 20h
        push dword 300h
        push str_Pal10
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
        push byte 0
        push byte 0
        push ebp
        call PutBlock
        add esp, byte 0Ch
        push ebp
        call FreeMemBlock
        add esp, byte 4
        mov ebx, 10h
        mov edx, dword [dword esp+0644h]
        xor eax, eax
        call FadePalStep
        mov edx, 0F7h
        mov eax, 0FAh
        call SetTextColors
.3:
        call SetScreenTarget
.4:
        mov esi, dword [dword esp+0634h]
        push esi
        mov edi, dword [dword esp+0634h]
        push edi
        mov ebp, dword [dword esp+0668h]
        push ebp
        call GrabBlock
        add esp, byte 0Ch
        cmp dword [dword esp+0664h], byte 0
        jne short .6
        mov edx, dword [dword esp+0634h]
        push edx
        mov ebx, dword [dword esp+0634h]
        push ebx
        mov ecx, dword [pointerspr]
        push ecx
.5:
        call DrawArt
        add esp, byte 0Ch
.6:
        mov ebp, dword [dword esp+0630h]
        mov esi, dword [dword esp+0634h]
.7:
        cmp dword [dword esp+0664h], byte 0
        je near PreGameScreen.32
        cmp byte [musicon], 0
        je short .8
        cmp dword [songdata], byte 0
        je short .8
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 3
        call SetDigiChannelVolume
.8:
        mov ebx, 10h
        mov edx, dword [dword esp+0644h]
        mov eax, 1
        call FadePalStep
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
        je short PreGameScreen_homelines.9
        mov ebp, dword [songdata]
        push ebp
        call PushMemDescriptorLocked
        add esp, byte 4
        xor eax, eax
        mov dword [songdata], eax
.10:
        cmp byte [musicon], 0
        je short .12
        test byte [gameopts+1], 1
        je short .12
        call MusicChanReset2
.11:
        call SpeechBusy
        test eax, eax
        jne short PreGameScreen_homelines.11
.12:
        lea eax, [dword esp+05D0h]
        push eax
        call TextRestoreState
        add esp, byte 4
        mov edx, dword [dword esp+0644h]
        push edx
        call FreeMemBlock
        add esp, byte 4
        mov ebx, dword [dword esp+0660h]
        push ebx
        call FreeMemBlock
        add esp, byte 4
        cmp dword [dword esp+0640h], byte 2
        jge short .13
        xor ecx, ecx
        mov cl, byte [dword esp+066Ch]
        xor ebx, ebx
        mov bl, byte [dword esp+0670h]
        mov edx, ecx
        mov eax, ebx
        call TonightsGameScreen
        mov dword [dword esp+0640h], eax
        mov edx, dword [nosplit ecx*4+teamabbrevs]
        mov eax, dword [nosplit ebx*4+teamabbrevs]
        call PaPreloadClips
.13:
        xor esi, esi
        mov dword [dword esp+0664h], esi
        cmp dword [dword esp+0640h], byte 3
        jne short .14
        mov dword [dword esp+0664h], 4
.14:
        mov eax, dword [dword esp+0664h]
        add esp, 674h
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; TonightsGameScreen                           2ABDF  95 PC, medium confidence
; "tonights" matchup screen: ctlogo / logohome / logoaway / ctbkgd /
; cttitle1, team leader shapes (top, tlu, scra, fowa, def), indus030 font,
; KEY records (GIPK), "Injured" list; FitPlayerName for names
;-----------------------------------------------------------------------------
; C: src/front/pregame/TonightsGameScreen.c
%ifdef CBUILD
%include "c/front/pregame/TonightsGameScreen.inc"
%else
TonightsGameScreen:
        push dword 148h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, 120h
        mov dword [dword esp+0E8h], 0FFFFFFFFh
        call ClearInputQueue
        xor ebp, ebp
        call SetScreenTarget
        push ebp
        call ClearScreen
        add esp, byte 4
        xor ecx, ecx
        mov ebx, str_Ctlogo
        cmp byte [fileoncd+059h], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
        lea eax, [dword esp+0C8h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0CCh]
        push eax
        call LoadBank
        mov dword [dword esp+0104h], eax
        add esp, byte 8
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        mov ebx, dword [nosplit eax*4+crestnames]
        push ebx
        mov ecx, dword [dword esp+0100h]
        push ecx
        call FindShape
        mov dword [dword esp+0F4h], eax
        add esp, byte 8
        mov eax, dword [byte eax+02h]
        sar eax, 10h
        mov edx, dword [dword esp+0ECh]
        mov edx, dword [byte edx+04h]
        sar edx, 10h
        imul eax, edx
        add eax, byte 11h
        mov dword [dword esp+0110h], eax
        push byte 20h
        push eax
        push str_Logohome
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [dword esp+0E0h], eax
        mov edi, eax
        mov esi, dword [dword esp+0ECh]
        movsd
        movsd
        movsd
        movsd
        movsb
        push byte 0
        push byte 0
        mov edi, dword [dword esp+0F4h]
        push edi
        call PutBlock
        add esp, byte 0Ch
        push byte 0
        push byte 0
        mov eax, dword [dword esp+0E8h]
        push eax
        call GrabBlock
        add esp, byte 0Ch
        mov eax, dword [VisTeam-2]
        sar eax, 10h
        mov edx, dword [nosplit eax*4+crestnames]
        push edx
        mov ebx, dword [dword esp+0100h]
        push ebx
        call FindShape
        mov dword [dword esp+0F4h], eax
        add esp, byte 8
        mov edx, dword [byte eax+02h]
        sar edx, 10h
        mov eax, dword [byte eax+04h]
        sar eax, 10h
        imul eax, edx
        add eax, byte 11h
        mov dword [dword esp+0110h], eax
        push byte 20h
        push eax
        push str_Logoaway
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [dword esp+0E4h], eax
        mov edi, eax
        mov esi, dword [dword esp+0ECh]
        movsd
        movsd
        movsd
        movsd
        movsb
        push byte 0
        push byte 0
        mov esi, dword [dword esp+0F4h]
        push esi
        call PutBlock
        add esp, byte 0Ch
        push byte 0
        push byte 0
        mov edi, dword [dword esp+0ECh]
        push edi
        call GrabBlock
        add esp, byte 0Ch
        mov eax, dword [dword esp+0FCh]
        push eax
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov ebx, str_Ctbkgd
        cmp byte [fileoncd+058h], 1
        jne short .3
        mov edx, dword [cddriveptr]
        jmp short .4
.3:
        xor edx, edx
.4:
        lea eax, [dword esp+0C8h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0CCh]
        push eax
        call LoadBank
        mov esi, eax
        add esp, byte 8
        mov dword [dword esp+0F0h], eax
        push str_Bkgd4
        push eax
        call FindShape
        add esp, byte 8
        mov dword [dword esp+0100h], eax
        push str_Pal12
        push esi
        call FindShape
        add esp, byte 8
        add eax, byte 10h
        mov dword [dword esp+0108h], eax
        xor ecx, ecx
        mov ebx, str_Cttitle1
        cmp byte [fileoncd+05Ah], 1
        jne short .5
        mov edx, dword [cddriveptr]
        jmp short .6
.5:
        xor edx, edx
.6:
        lea eax, [dword esp+0C8h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0CCh]
        push eax
        call LoadBank
        mov esi, eax
        add esp, byte 8
        mov dword [dword esp+0F8h], eax
        push str_Def
        push eax
        call FindShape
        add esp, byte 8
        mov dword [dword esp+094h], eax
        push str_Fowa
        push esi
        call FindShape
        add esp, byte 8
        mov dword [dword esp+098h], eax
        push str_Scra
        push esi
        call FindShape
        add esp, byte 8
        mov dword [dword esp+0B0h], eax
        push str_Tlu
        push esi
        call FindShape
        add esp, byte 8
        mov dword [dword esp+0B8h], eax
        push str_Top
        push esi
        call FindShape
        add esp, byte 8
        mov dword [dword esp+0BCh], eax
        lea eax, [byte esp+054h]
        push eax
        call TextSaveState
        add esp, byte 4
        mov ecx, str_VFN
        mov ebx, str_Indus030
        cmp byte [fileoncd+021Ah], 1
        jne short .7
        mov edx, dword [cddriveptr]
        jmp short .8
.7:
        xor edx, edx
.8:
        mov eax, esp
        call MakePath
        push byte 20h
        lea eax, [byte esp+04h]
        push eax
        call sub_8E8A0
        add esp, byte 8
        mov dword [dword esp+0F4h], eax
        push eax
        call TextSetFont
        add esp, byte 4
        xor edx, edx
        mov eax, 40h
        call SetTextColors
        test ebp, ebp
        jne short .9
        mov ebx, dword [leaguedbnames]
        mov ecx, str_extDB
        mov edx, curleague
        mov eax, esp
        call MakePath
        lea edx, [dword esp+0E8h]
        mov eax, esp
        call FileOpenRead
        mov ebp, eax
.9:
        test ebp, ebp
        jne near .16
        push byte 20h
        push dword 0B60h
        push str_GIPK
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [dword esp+010Ch], eax
        mov dword [dword esp+0110h], ebp
        jmp near .15
.10:
        xor esi, esi
        jmp short .13
.11:
        mov edx, dword [dword esp+0110h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        mov edx, eax
        shl eax, 5
        sub eax, edx
        mov ebx, esi
        mov ebx, dword [dword eax+ebx*4+hmteamrec_skaters]
        cmp ebx, byte 0FFFFFFFFh
        je short .12
        mov edx, dword [dword esp+0110h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        lea edx, [eax+esi]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        mov edx, dword [dword esp+010Ch]
        add edx, eax
        mov eax, dword [dword esp+0E8h]
        call ReadKeyRec
        mov ebp, eax
.12:
        inc esi
.13:
        cmp esi, byte 1Ch
        jge short .14
        test ebp, ebp
        je short TonightsGameScreen.11
.14:
        inc dword [dword esp+0110h]
.15:
        cmp dword [dword esp+0110h], byte 2
        jge short .16
        test ebp, ebp
        je near TonightsGameScreen.10
.16:
        lea eax, [dword esp+0E8h]
        call FileClose
        mov dword [dword esp+0D8h], hmlinetab
        mov dword [dword esp+0DCh], awlinetab
        xor ebp, ebp
        mov dword [dword esp+0104h], ebp
        xor esi, esi
        cmp byte [musicon], 0
        je short .19
        cmp dword [songdata], byte 0
        jne short .19
        mov ecx, str_Iff5
        mov ebx, str_Tonights
        cmp byte [fileoncd+01DFh], 1
        jne short .17
        mov edx, dword [cddriveptr]
        jmp short .18
.17:
        xor edx, edx
.18:
        lea eax, [dword esp+0C8h]
        call MakePath
        lea eax, [dword esp+0C8h]
        call LoadDigiFile
        mov dword [songdata], eax
        test eax, eax
        je short .19
        test byte [gameopts], 40h
        je short .19
        mov edx, dword [musichandle]
        mov ecx, 4Ch
        mov ebx, 3
        call PlayDigiBlockLoop
.19:
        xor edx, edx
        mov dword [dword esp+0114h], edx
        jmp near .48
.20:
        call SetScreenTarget
        cmp dword [dword esp+0114h], byte 0
        je short .21
        push dword 1E0h
        push dword 8Ch
        push dword 280h
        push dword 80h
        call SetClipWindow
        add esp, byte 10h
        mov ebx, dword [dword esp+0100h]
        push ebx
        call DrawBitmap
        add esp, byte 4
        push dword 8Ch
        push ebp
        push dword 80h
        push ebp
        call SetClipWindow
        add esp, byte 10h
        mov ecx, dword [dword esp+0100h]
        push ecx
        call DrawBitmap
        add esp, byte 4
        push dword 1E0h
        push ebp
        push dword 80h
        push ebp
        call SetClipWindow
        add esp, byte 10h
        jmp short .22
.21:
        push dword 1E0h
        push ebp
        push dword 280h
        push ebp
        call SetClipWindow
        add esp, byte 10h
        mov edx, dword [dword esp+0100h]
        push edx
        call DrawBitmap
        add esp, byte 4
.22:
        lea eax, [dword esp+011Ch]
        push eax
        push byte 0
        lea ecx, [dword esp+09Ch]
        mov ebx, dword [dword esp+0110h]
        xor edx, edx
        mov eax, 8
        call DrawGadgetByType
        push dword 1E0h
        push byte 0
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        push byte 50h
        push byte 3Dh
        mov eax, dword [dword esp+011Ch]
        mov esi, dword [dword esp+eax*4+0E8h]
        push esi
        call sub_913D0
        add esp, byte 0Ch
        xor edx, edx
        mov eax, 40h
        call SetTextColors
        push dword 154h
        push byte 0
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        movzx edi, byte [byte_D42C3]
        add edi, 0A6h
        xor eax, eax
        mov dword [dword esp+0110h], eax
        jmp near .28
.23:
        xor esi, esi
        jmp near .26
.24:
        mov ebx, dword [dword esp+0114h]
        mov edx, dword [dword esp+0110h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, eax
        mov eax, dword [dword esp+ebx*4+0D8h]
        add eax, edx
        mov al, byte [esi+eax]
        and eax, 0FFh
        mov dword [dword esp+0118h], eax
        mov eax, ebx
        shl eax, 3
        sub eax, ebx
        shl eax, 2
        mov edx, dword [dword esp+0118h]
        add edx, eax
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        mov edx, dword [dword esp+010Ch]
        add edx, eax
        test ebp, ebp
        jne short .25
        lea ebx, [byte edx+013h]
        mov ecx, 0C8h
        xor edx, edx
        mov eax, esp
        call FitPlayerName
        mov eax, esp
        push eax
        call fputchar
        add esp, byte 4
        mov edx, 96h
        sub edx, eax
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov ebx, eax
        mov eax, esi
        shl eax, 2
        add eax, esi
        add eax, eax
        mov edx, eax
        shl eax, 4
        sub eax, edx
        add eax, 91h
        add eax, ebx
        mov ebx, esp
        mov edx, edi
        call PrintShadowText
.25:
        inc esi
.26:
        cmp esi, byte 3
        jge short .27
        test ebp, ebp
        je near TonightsGameScreen.24
.27:
        xor eax, eax
        mov al, byte [byte_D42C3]
        add eax, byte 0Eh
        add edi, eax
        inc dword [dword esp+0110h]
.28:
        cmp dword [dword esp+0110h], byte 4
        jge short .29
        test ebp, ebp
        je near TonightsGameScreen.23
.29:
        cmp dword [dword esp+0104h], byte 0
        jne short .31
        mov ebx, 10h
        mov edx, dword [dword esp+0108h]
        xor eax, eax
        call FadePalStep
        cmp dword [dword esp+0114h], byte 0
        jne short .30
        call PaLineups
.30:
        mov dword [dword esp+0104h], 0FFFFFFFFh
.31:
        mov eax, 3E8h
        call WaitClickTimeout
        mov esi, eax
        cmp eax, byte 2
        jge near .40
        call SetScreenTarget
        push dword 1E0h
        push dword 8Ch
        push dword 280h
        push dword 80h
        call SetClipWindow
        add esp, byte 10h
        mov edx, dword [dword esp+0100h]
        push edx
        call DrawBitmap
        add esp, byte 4
        push dword 1E0h
        push dword 8Ch
        push dword 80h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        lea eax, [dword esp+011Ch]
        push eax
        push byte 0
        lea ecx, [dword esp+09Ch]
        mov ebx, dword [dword esp+0110h]
        xor edx, edx
        mov eax, 10h
        call DrawGadgetByType
        push byte 50h
        push byte 3Dh
        mov eax, dword [dword esp+011Ch]
        mov ebx, dword [dword esp+eax*4+0E8h]
        push ebx
        call sub_913D0
        add esp, byte 0Ch
        push dword 1E0h
        push byte 0
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        movzx edi, byte [byte_D42C3]
        add edi, 0A6h
        xor ecx, ecx
        mov dword [dword esp+0110h], ecx
        jmp near .37
.32:
        xor esi, esi
        jmp near .35
.33:
        mov eax, dword [dword esp+0114h]
        mov edx, dword [dword esp+eax*4+0D8h]
        mov eax, dword [dword esp+0110h]
        add eax, eax
        add eax, edx
        mov al, byte [byte esi+eax+0Ch]
        and eax, 0FFh
        mov dword [dword esp+0118h], eax
        mov edx, dword [dword esp+0114h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        mov edx, dword [dword esp+0118h]
        add edx, eax
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        mov edx, dword [dword esp+010Ch]
        add edx, eax
        test ebp, ebp
        jne short .34
        lea ebx, [byte edx+013h]
        mov ecx, 0C8h
        xor edx, edx
        mov eax, esp
        call FitPlayerName
        mov eax, esp
        push eax
        call fputchar
        add esp, byte 4
        mov edx, 0F0h
        sub edx, eax
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov edx, eax
        mov eax, esi
        shl eax, 4
        sub eax, esi
        shl eax, 4
        add eax, 91h
        add eax, edx
        mov ebx, esp
        mov edx, edi
        call PrintShadowText
.34:
        inc esi
.35:
        cmp esi, byte 2
        jge short .36
        test ebp, ebp
        je near TonightsGameScreen.33
.36:
        xor eax, eax
        mov al, byte [byte_D42C3]
        add eax, byte 0Eh
        add edi, eax
        inc dword [dword esp+0110h]
.37:
        cmp dword [dword esp+0110h], byte 3
        jge short .38
        test ebp, ebp
        je near TonightsGameScreen.32
.38:
        cmp dword [dword esp+0104h], byte 0
        jne short .39
        mov ebx, 10h
        mov edx, dword [dword esp+0108h]
        xor eax, eax
        call FadePalStep
        mov dword [dword esp+0104h], 0FFFFFFFFh
.39:
        mov eax, 3E8h
        call WaitClickTimeout
        mov esi, eax
.40:
        cmp esi, byte 2
        jge near .47
        call SetScreenTarget
        push dword 1E0h
        push dword 8Ch
        push dword 280h
        push dword 80h
        call SetClipWindow
        add esp, byte 10h
        mov esi, dword [dword esp+0100h]
        push esi
        call DrawBitmap
        add esp, byte 4
        push dword 1E0h
        push dword 8Ch
        push dword 80h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        lea eax, [dword esp+011Ch]
        push eax
        push byte 0
        lea ecx, [dword esp+09Ch]
        mov ebx, dword [dword esp+0110h]
        xor edx, edx
        mov eax, 4
        call DrawGadgetByType
        push byte 50h
        push byte 3Dh
        mov eax, dword [dword esp+011Ch]
        mov edi, dword [dword esp+eax*4+0E8h]
        push edi
        call sub_913D0
        add esp, byte 0Ch
        push dword 1E0h
        push byte 0
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        movzx edi, byte [byte_D42C3]
        add edi, byte 7Eh
        xor eax, eax
        mov dword [dword esp+0110h], eax
        jmp near .44
.41:
        mov eax, dword [dword esp+0114h]
        mov eax, dword [dword esp+eax*4+0D8h]
        add eax, edx
        mov al, byte [byte eax+028h]
        and eax, 0FFh
        mov dword [dword esp+0118h], eax
        cmp eax, byte 64h
        jge near .43
        mov edx, dword [dword esp+0114h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        mov edx, dword [dword esp+0118h]
        add edx, eax
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        mov edx, dword [dword esp+010Ch]
        add edx, eax
        test ebp, ebp
        jne short .42
        lea ebx, [byte edx+013h]
        mov ecx, 0C8h
        xor edx, edx
        mov eax, esp
        call FitPlayerName
        mov ebx, esp
        mov edx, edi
        mov eax, 0B4h
        call PrintShadowText
        mov edx, dword [dword esp+0114h]
        mov ebx, edx
        shl ebx, 4
        add ebx, edx
        shl ebx, 4
        add ebx, edx
        shl ebx, 2
        mov edx, dword [dword esp+0118h]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 3
        sub eax, edx
        cmp byte [dword ebx+eax+hmroster], 1
        jne short .42
        mov ebx, str_Injured
        mov edx, edi
        mov eax, 226h
        call PrintShadowText
.42:
        xor eax, eax
        mov al, byte [byte_D42C3]
        add eax, byte 0Eh
        add edi, eax
.43:
        inc dword [dword esp+0110h]
.44:
        mov edx, dword [dword esp+0110h]
        cmp edx, byte 8
        jge short .45
        test ebp, ebp
        je near TonightsGameScreen.41
.45:
        cmp dword [dword esp+0104h], byte 0
        jne short .46
        mov ebx, 10h
        mov edx, dword [dword esp+0108h]
        xor eax, eax
        call FadePalStep
        mov dword [dword esp+0104h], 0FFFFFFFFh
.46:
        mov eax, 3E8h
        call WaitClickTimeout
        mov esi, eax
.47:
        inc dword [dword esp+0114h]
.48:
        cmp dword [dword esp+0114h], byte 2
        jge short .49
        cmp esi, byte 2
        jge short .49
        test ebp, ebp
        je near TonightsGameScreen.20
.49:
        mov ecx, dword [dword esp+010Ch]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        cmp byte [musicon], 0
        je short .50
        cmp dword [songdata], byte 0
        je short .50
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 3
        call SetDigiChannelVolume
.50:
        mov ebx, 10h
        mov edx, dword [dword esp+0108h]
        mov eax, 1
        call FadePalStep
        call SetScreenTarget
        push byte 0
        call ClearScreen
        add esp, byte 4
        cmp byte [musicon], 0
        je short .52
        cmp dword [songdata], byte 0
        je short .52
.51:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short TonightsGameScreen.51
        mov edx, dword [songdata]
        push edx
        call PushMemDescriptorLocked
        add esp, byte 4
        xor ebx, ebx
        mov dword [songdata], ebx
.52:
        cmp esi, byte 3
        jge short .53
        call ShowLoadingScreen
.53:
        lea eax, [byte esp+054h]
        push eax
        call TextRestoreState
        add esp, byte 4
        mov ecx, dword [dword esp+0F4h]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        mov edi, dword [dword esp+0F8h]
        push edi
        call FreeMemBlock
        add esp, byte 4
        mov ebp, dword [dword esp+0F0h]
        push ebp
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [dword esp+0E0h]
        push eax
        call FreeMemBlock
        add esp, byte 4
        mov edx, dword [dword esp+0E4h]
        push edx
        call FreeMemBlock
        add esp, byte 4
        mov eax, esi
        add esp, 120h
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
