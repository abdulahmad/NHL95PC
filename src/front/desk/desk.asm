; The EA Sports desk during a game: pause, intermission, and the screen after the final horn.
bits 32
%include "hockey.inc"
section s_18D7F progbits alloc exec nowrite align=1
extern __CHK, awgoalcnt, awlinetab, awscore, awshotcnt, bailout_vec, boxfillcolor, boxlitecolor
extern boxshadecolor, btn_POHumanOut, cupceremony, cddriveptr, ClearInputQueue, CoachCutScene, cont2team, ctl1team
extern ctl2team, curperiod, deferpending, dlgtextbg, dlgtextfg, DrawMenuBar, DrawMenuDropdown, DrawMenuItemNorm
extern DrawMenuItemSel, msg_DeskExit, msg_DeskExit_e02, dword_C66D0, dword_C66D4, otherperiodprev, deskptry, playsuspended
extern deskptrx, escrequest, exitgame, FadeOutPalCycle, FadePalette, FadePalStep, fileoncd, FlushGSumQueue
extern FreeBackMoment, FreeMemBlock, FreeNowBack, GameLineEditor, gamemode, gameopts, gameresult, GameStatsScreen
extern GameSummaryScreen, GetInputEvent, hlplayedmask, hmgoalcnt, hmlinetab, hmscore, hmshotcnt, HomeTeam
extern InputInstall, InputRemove, InstantReplay, joysampling, LoadPlayerPhotos, LoadRink, MakePath, MenuHitTest
extern MessageBox, mi_AwayGoalie1, mi_AwayGoalie2, mi_AwayGoalieNone, mi_HomeGoalie1, mi_HomeGoalie2, mi_HomeGoalieNone, mousepollfn
extern MouseSetPos, MusicChanReset, musichandle, musicon, musicslot, menuact_gotoreplay, othergames, othergamesb
extern otherperiod, otherscores, otherscoresb, PaOpenBank, PaPlayoffResult, PickOtherGames, pointerspr, ptrupdatefn
extern randomd0, ReadGSumHeader, ReadGSumTail, ReplayIsEmpty, s1font, savepal, SayBackMoment, SayNowBack
extern schedgameidx, scrollx, scrolly, SetDialogColors, SetModeMenuLabels, SetScreenSize, SetScreenTitle, SetTeamGoalie
extern ShowCredits, ShowLoadingScreen, songdata, SpeechBusy, sprintf_, StartHL2, str_Desk, str_DoYouWishToExit
extern str_DoYouWishToReturn, str_Eadesk1d, str_ExitingTheGame, str_Iff3, str_Menubuff3, str_Pal5, str_Pause, str_PleaseEnterOutputFile
extern str_Pointer2, str_ReturningOutOfThe, str_ReturningToSportsCentral, str_ReturningToThePlayoff, FreeGameMemory, EnsureFreeMemory, AllocMemBlock, PushMemDescriptorLocked
extern LoadBank, TextSaveState, TextRestoreState, TextSetFont, LoadDigiFile, PlayDigiBlockLoop, SndQuery, SetDigiChannelVolume
extern SetPalette, PutBlock, DrawBitmap, DrawArt, GrabBlock, MouseRead, SetViewRect, FindShape
extern ClearScreen, SetTextMode, SetScreenTarget, FillRectColor, teamconf, TextInputDialog, TicksSinceLastCall, deskmenubar
extern deskmenubar_lg, desklinesmenubar, deskbankname, UpdateOtherScores, VisTeam, WaitClickTimeout, SortPending, WriteGSumHeader
extern WriteScreenTextFile
global OutputCurrentData, DrawDeskFrames, MenuCallbackTrue, MenuCallbackTrue2, PlayRandomHighlight, IntermissionDesk, PostGameDesk, SportsDesk
global DeskReloadGame, DeskBackToGame, DeskToSportsDesk, DeskReturnConfirm, DeskExitGame, DeskGoToReplay, DeskHomeLines, DeskLines_common
global DeskVisitorLines, DeskGameStats, DeskPenaltySummary, DeskScoringSummary, DeskSummary_common, DeskItem_ret2, DeskTeamScratches, DeskHomeGoalie1
global DeskGoalie_x1, DeskHomeGoalie2, DeskHomeGoalieNone, DeskGoalie_x2, DeskAwayGoalie1, DeskGoalie_x3, DeskGoalie_x4, DeskAwayGoalie2
global DeskAwayGoalieNone
;-----------------------------------------------------------------------------
; OutputCurrentData                                               18D7F  95 PC
; "Output Current Data ..." sports desk item: prompts "Please enter output
; file name" (TextInputDialog text entry with temporary boxfillcolor..C71DC
; colours) and, unless Esc or empty, WriteScreenTextFile
;-----------------------------------------------------------------------------
; C: src/front/desk/OutputCurrentData.c
%ifdef CBUILD
%include "c/front/desk/OutputCurrentData.inc"
%else
OutputCurrentData:
        push dword 44h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 14h
        mov eax, dword [boxfillcolor]
        mov dword [byte esp+010h], eax
        mov eax, dword [boxlitecolor]
        mov dword [byte esp+0Ch], eax
        mov ebp, dword [boxshadecolor]
        mov edi, dword [dlgtextfg]
        mov esi, dword [dlgtextbg]
        mov dword [boxfillcolor], 41h
        mov ebx, 40h
        mov dword [boxlitecolor], ebx
        mov dword [boxshadecolor], 42h
        mov dword [dlgtextfg], ebx
        xor edx, edx
        mov dword [dlgtextbg], edx
        push byte 5
        push edx
        push edx
        push edx
        push edx
        mov ecx, 22h
        mov ebx, 8
        lea edx, [byte esp+014h]
        mov eax, str_PleaseEnterOutputFile
        call TextInputDialog
        cmp eax, byte 1Bh
        je short .1
        cmp byte [esp], 0
        je short .1
        mov eax, esp
        call WriteScreenTextFile
.1:
        mov eax, dword [byte esp+010h]
        mov dword [boxfillcolor], eax
        mov eax, dword [byte esp+0Ch]
        mov dword [boxlitecolor], eax
        mov dword [boxshadecolor], ebp
        mov dword [dlgtextfg], edi
        mov dword [dlgtextbg], esi
        xor eax, eax
        add esp, byte 14h
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawDeskFrames                               18E43  95 PC, medium confidence
; Draws three nested rectangles (FillRectColor lines, colours 22h / 21h / 20h)
; around 0Eh,21h - 0AFh,86h
;-----------------------------------------------------------------------------
; C: src/front/desk/DrawDeskFrames.c
%ifdef CBUILD
%include "c/front/desk/DrawDeskFrames.inc"
%else
DrawDeskFrames:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push edx
        push byte 22h
        push byte 21h
        push dword 0AFh
        push byte 21h
        push byte 0Eh
        call FillRectColor
        add esp, byte 14h
        push byte 22h
        push dword 86h
        push dword 0AFh
        push byte 21h
        push dword 0AFh
        call FillRectColor
        add esp, byte 14h
        push byte 22h
        push dword 86h
        push dword 0AFh
        push dword 86h
        push byte 0Eh
        call FillRectColor
        add esp, byte 14h
        push byte 22h
        push byte 21h
        push byte 0Eh
        push dword 86h
        push byte 0Eh
        call FillRectColor
        add esp, byte 14h
        push byte 21h
        push byte 20h
        push dword 0B0h
        push byte 20h
        push byte 0Dh
        call FillRectColor
        add esp, byte 14h
        push byte 21h
        push dword 87h
        push dword 0B0h
        push byte 20h
        push dword 0B0h
        call FillRectColor
        add esp, byte 14h
        push byte 21h
        push dword 87h
        push dword 0B0h
        push dword 87h
        push byte 0Dh
        call FillRectColor
        add esp, byte 14h
        push byte 21h
        push byte 20h
        push byte 0Dh
        push dword 87h
        push byte 0Dh
        call FillRectColor
        add esp, byte 14h
        push byte 20h
        push byte 1Fh
        push dword 0B1h
        push byte 1Fh
        push byte 0Ch
        call FillRectColor
        add esp, byte 14h
        push byte 20h
        push dword 88h
        push dword 0B1h
        push byte 1Fh
        push dword 0B1h
        call FillRectColor
        add esp, byte 14h
        push byte 20h
        push dword 88h
        push dword 0B1h
        push dword 88h
        push byte 0Ch
        call FillRectColor
        add esp, byte 14h
        push byte 20h
        push byte 1Fh
        push byte 0Ch
        push dword 88h
        push byte 0Ch
        call FillRectColor
        add esp, byte 14h
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; MenuCallbackTrue                                                18F74  95 PC
; Callback that returns 1 (ret 0Ch; second entry MenuCallbackTrue2); its
; address is passed by the penalty text code (62CB9)
;-----------------------------------------------------------------------------
; C: src/front/desk/MenuCallbackTrue.c
%ifdef CBUILD
%include "c/front/desk/MenuCallbackTrue.inc"
%else
MenuCallbackTrue:
        push dword 4
.1:
        call __CHK
        mov eax, 1
        ret 0Ch
;-----------------------------------------------------------------------------
; MenuCallbackTrue2                                               18F86  95 PC
; Twin of MenuCallbackTrue with a different __CHK frame size; returns 1
; (Watcom reduced it to a jump into MenuCallbackTrue).
;-----------------------------------------------------------------------------
MenuCallbackTrue2:
        push dword 4
        jmp short MenuCallbackTrue.1
%endif ; C
;-----------------------------------------------------------------------------
; PlayRandomHighlight                          18F8D  95 PC, medium confidence
; Marks the highlights already shown (otherperiod state >= 5 and unchanged)
; in hlplayedmask, picks a random unplayed one of the 6 and plays it with
; StartHL2; returns -1 / its result
;-----------------------------------------------------------------------------
; C: src/front/desk/PlayRandomHighlight.c
%ifdef CBUILD
%include "c/front/desk/PlayRandomHighlight.inc"
%else
PlayRandomHighlight:
        push dword 2Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 0Ch
        xor eax, eax
.1:
        mov edx, eax
        shl edx, 2
        mov ebx, dword [dword edx+otherperiod]
        cmp ebx, byte 5
        jl short .2
        cmp ebx, dword [dword edx+otherperiodprev]
        je short .2
        mov cl, al
        mov edx, 1
        shl edx, cl
        or dword [hlplayedmask], edx
.2:
        inc eax
        cmp eax, byte 6
        jl short PlayRandomHighlight.1
        cmp dword [hlplayedmask], byte 3Fh
        jne short .3
        xor eax, eax
        jmp near .x
.3:
        mov eax, 6
        call randomd0
        cwde
        mov dword [byte esp+08h], eax
        mov cl, byte [byte esp+08h]
        mov eax, 1
        shl eax, cl
        mov ebp, dword [hlplayedmask]
        test eax, ebp
        jne short PlayRandomHighlight.3
        mov edx, ebp
        or edx, eax
        mov dword [hlplayedmask], edx
        mov edx, dword [byte esp+08h]
        xor eax, eax
        mov al, byte [nosplit edx*2+otherscores]
        mov dword [esp], eax
        xor eax, eax
        mov al, byte [nosplit edx*2+otherscoresb]
        mov dword [byte esp+04h], eax
        mov ecx, dword [nosplit edx*4+otherperiod]
        cmp ecx, byte 5
        jl short .4
        mov ecx, 3
        dec dword [esp]
        lea esi, [byte eax-01h]
        mov dword [byte esp+04h], esi
.4:
        push ecx
        mov esi, dword [byte esp+0Ch]
        add esi, esi
        xor edx, edx
        mov dl, byte [dword esi+othergamesb]
        xor eax, eax
        mov al, byte [dword esi+othergames]
        lea ecx, [byte esp+08h]
        lea ebx, [byte esp+04h]
        call StartHL2
        mov ecx, eax
        mov edx, dword [byte esp+08h]
        shl edx, 2
        mov edi, dword [dword edx+otherperiod]
        cmp edi, byte 4
        jg short .5
        mov al, byte [esp]
        mov byte [dword esi+otherscores], al
        mov al, byte [byte esp+04h]
        mov byte [dword esi+otherscoresb], al
        jne short .5
        mov dword [dword edx+otherperiod], 5
.5:
        xor eax, eax
.6:
        mov ebx, dword [nosplit eax*4+otherperiod]
        mov dword [nosplit eax*4+otherperiodprev], ebx
        inc eax
        cmp eax, byte 6
        jl short PlayRandomHighlight.6
        mov eax, ecx
.x:
        add esp, byte 0Ch
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; IntermissionDesk                             190BE  95 PC, medium confidence
; Between periods (called from IntermissionPC): in an exhibition between real
; teams plays the period highlights (UpdateOtherScores, PlayRandomHighlight),
; then the sports desk in intermission mode (SportsDesk 1), clears the goal /
; shot counters and restores 320x200
;-----------------------------------------------------------------------------
; C: src/front/desk/IntermissionDesk.c
%ifdef CBUILD
%include "c/front/desk/IntermissionDesk.inc"
%else
IntermissionDesk:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov eax, dword [exitgame-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        je near .3
        call ShowLoadingScreen
        call FlushGSumQueue
        call ReadGSumTail
        call InputInstall
        mov edx, dword [curperiod]
        xor ecx, ecx
        mov ebx, edx
        mov eax, 1
        call GameSummaryScreen
        mov ecx, eax
        call InputRemove
        cmp dword [gamemode], byte 0
        jne near .4
        mov dx, word [HomeTeam]
        cmp dx, byte 1Ah
        je near .4
        cmp dx, byte 1Bh
        je near .4
        mov si, word [VisTeam]
        cmp si, byte 1Ah
        je near .4
        cmp si, byte 1Bh
        je near .4
        cmp dword [curperiod], byte 1
        jne short .2
        xor esi, esi
        mov dword [hlplayedmask], esi
        mov edx, dword [VisTeam-2]
        sar edx, 10h
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        call PickOtherGames
        xor edx, edx
.1:
        mov ebx, dword [nosplit edx*4+otherperiod]
        mov dword [nosplit edx*4+otherperiodprev], ebx
        inc edx
        cmp edx, byte 6
        jl short IntermissionDesk.1
.2:
        test cl, 4
        jne short .4
        mov eax, dword [curperiod]
        call UpdateOtherScores
        call PlayRandomHighlight
        test eax, eax
        jl short .4
        call InputInstall
        mov edx, dword [curperiod]
        xor ecx, ecx
        xor ebx, ebx
        mov eax, 20h
        call GameSummaryScreen
        call InputRemove
        jmp short .4
.3:
        call FadeOutPalCycle
.4:
        mov word [exitgame], 0FFFFh
        mov eax, 1
        call SportsDesk
        xor ah, ah
        mov byte [hmgoalcnt], ah
        mov byte [hmshotcnt], ah
        mov byte [awgoalcnt], ah
        mov byte [awshotcnt], ah
        call WriteGSumHeader
        mov edx, 0C8h
        mov eax, 140h
        call SetScreenSize
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; PostGameDesk                                 1920F  95 PC, medium confidence
; End of game (from PlayGame): fade, 640x480, game summary
; (GameSummaryScreen), in an exhibition between real teams the highlights
; (PlayRandomHighlight), then SportsDesk 2 and gameresult = 1
;-----------------------------------------------------------------------------
; C: src/front/desk/PostGameDesk.c
%ifdef CBUILD
%include "c/front/desk/PostGameDesk.inc"
%else
PostGameDesk:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push savepal
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, savepal
        mov eax, 1
        call FadePalStep
        mov edx, 1E0h
        mov eax, 280h
        call SetScreenSize
        mov eax, 222E0h
        call EnsureFreeMemory
        call ShowLoadingScreen
        call FlushGSumQueue
        call ReadGSumTail
        call ReadGSumHeader
        call InputInstall
        mov ebx, dword [curperiod]
        xor ecx, ecx
        mov edx, 1
        mov eax, edx
        call GameSummaryScreen
        mov edx, eax
        call InputRemove
        cmp dword [gamemode], byte 0
        jne near .2
        test dl, 4
        jne near .2
        mov dx, word [HomeTeam]
        cmp dx, byte 1Ah
        je near .2
        cmp dx, byte 1Bh
        je near .2
        mov cx, word [VisTeam]
        cmp cx, byte 1Ah
        je short .2
        cmp cx, byte 1Bh
        je short .2
        mov eax, dword [curperiod]
        call UpdateOtherScores
        call PlayRandomHighlight
        mov edx, 1E0h
        mov eax, 280h
        call SetScreenSize
        call FreeGameMemory
        call CoachCutScene
        mov edx, eax
        test eax, eax
        je short .1
        mov eax, 0Ah
        call WaitClickTimeout
        mov edx, eax
.1:
        test edx, edx
        jne short .2
        call ShowLoadingScreen
        call InputInstall
        mov edx, dword [curperiod]
        xor ecx, ecx
        xor ebx, ebx
        mov eax, 20h
        call GameSummaryScreen
        call InputRemove
.2:
        mov eax, 2
        call SportsDesk
        mov dword [gameresult], 1
        mov edx, 0C8h
        mov eax, 140h
        call SetScreenSize
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SportsDesk                                   1935D  95 PC, medium confidence
; (mode): the PC "EA Sports desk" menu screen ("eadesk%1d" art by mode,
; "desk" / "!pal", "Pointer" cursor, "pause" and "menubuff" buffers); mode 0
; is the pause menu from GameLoop (Esc), 1 the intermission, 2 after the
; game; runs the desk menus until an item returns to the game
;-----------------------------------------------------------------------------
SportsDesk:
        push dword 434h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, 404h
        push eax
        xor edx, edx
        mov dword [dword esp+0404h], edx
        mov dword [dword esp+03F4h], edx
        mov dword [dword esp+03F0h], 5DCh
        mov eax, dword [gamemode]
        call SetModeMenuLabels
        mov eax, dword [esp]
        add eax, byte 3
        call SetScreenTitle
        call ReplayIsEmpty
        test eax, eax
        je short .1
        mov dword [menuact_gotoreplay], edx
        jmp short .2
.1:
        mov dword [menuact_gotoreplay], DeskGoToReplay
.2:
        lea eax, [dword esp+03D4h]
        push eax
        lea eax, [dword esp+03DCh]
        push eax
        lea eax, [dword esp+03E4h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        xor ebp, ebp
        mov dword [escrequest], ebp
        mov dword [joysampling], ebp
        cmp dword [esp], byte 0
        jne short .3
        mov eax, 0AAE60h
        call EnsureFreeMemory
        lea eax, [byte esp+04h]
        push eax
        push dword 100h
        push ebp
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        lea edx, [byte esp+04h]
        mov eax, 1
        call FadePalStep
.3:
        call SetScreenTarget
        mov ebx, dword [esp]
        push ebx
        push str_Eadesk1d
        push deskbankname
        call sprintf_
        add esp, byte 0Ch
        xor ecx, ecx
        mov ebx, deskbankname
        mov eax, dword [esp]
        cmp byte [dword eax+fileoncd+064h], 1
        jne short .4
        mov edx, dword [cddriveptr]
        jmp short .5
.4:
        xor edx, edx
.5:
        lea eax, [dword esp+0344h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0348h]
        push eax
        call LoadBank
        mov esi, eax
        add esp, byte 8
        mov edi, eax
        push str_Desk
        push eax
        call FindShape
        add esp, byte 8
        push eax
        call DrawBitmap
        add esp, byte 4
        push str_Pal5
        push esi
        call FindShape
        add esp, byte 8
        lea edx, [byte eax+010h]
        xor esi, esi
.6:
        mov al, byte [edx+esi]
        mov byte [byte esp+esi+04h], al
        inc esi
        cmp esi, 300h
        jl short SportsDesk.6
        push edi
        call FreeMemBlock
        add esp, byte 4
        lea eax, [dword esp+0304h]
        push eax
        call TextSaveState
        add esp, byte 4
        mov ecx, dword [s1font]
        push ecx
        call TextSetFont
        add esp, byte 4
        cmp dword [esp], byte 2
        jne short .8
        cmp dword [schedgameidx], 444h
        jl short .7
        call PaOpenBank
.7:
        mov dword [dword esp+03B4h], deskmenubar_lg
        mov dword [dword esp+03A4h], 3
        jmp short .9
.8:
        mov dword [dword esp+03B4h], deskmenubar
        mov dword [dword esp+03A4h], 6
.9:
        xor ecx, ecx
        mov dword [dword esp+03C0h], ecx
        mov dword [dword esp+03BCh], ecx
        mov dword [dword esp+03B8h], ecx
        mov dword [dword esp+0390h], ecx
        mov dword [dword esp+038Ch], ecx
        mov dword [dword esp+0388h], ecx
        mov dword [dword esp+0384h], ecx
        mov dword [dword esp+03A0h], ecx
        mov dword [dword esp+039Ch], ecx
        mov dword [dword esp+0398h], ecx
        mov dword [dword esp+0394h], ecx
        mov dword [dword esp+0368h], ecx
        mov dword [dword esp+0364h], ecx
        mov eax, dword [pointerspr]
        mov edx, dword [byte eax+02h]
        sar edx, 10h
        mov eax, dword [byte eax+04h]
        sar eax, 10h
        lea ebx, [byte eax+01h]
        lea eax, [byte edx+01h]
        imul eax, ebx
        add eax, byte 11h
        push byte 20h
        push eax
        push str_Pointer2
        call AllocMemBlock
        mov ebp, eax
        add esp, byte 0Ch
        mov dword [dword esp+03F8h], eax
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
        mov word [byte ebp+04h], ax
        mov eax, dword [pointerspr]
        mov ax, word [byte eax+06h]
        inc eax
        mov word [byte ebp+06h], ax
        push dword 0F8h
        mov ecx, 0F9h
        mov ebx, 0FAh
        mov edx, dword [dword esp+03A8h]
        mov eax, dword [dword esp+03B8h]
        call DrawMenuBar
        call InputInstall
        mov edx, dword [dword esp+03B4h]
        mov edx, dword [edx]
        mov eax, dword [dword esp+03B4h]
        mov ebx, dword [byte eax+08h]
        add edx, ebx
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov dword [dword esp+0400h], eax
        mov dword [dword esp+03E4h], eax
        mov edx, dword [dword esp+03B4h]
        mov edx, dword [byte edx+04h]
        mov eax, dword [dword esp+03B4h]
        mov ecx, dword [byte eax+0Ch]
        add edx, ecx
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov dword [dword esp+03ECh], eax
        mov dword [dword esp+03E0h], eax
        mov esi, eax
        push eax
        mov edi, dword [dword esp+0404h]
        push edi
        push ebp
        call GrabBlock
        add esp, byte 0Ch
        mov ebp, esi
        push ebp
        push edi
        mov edx, dword [pointerspr]
        push edx
        call DrawArt
        add esp, byte 0Ch
        cmp byte [musicon], 0
        je short .12
        cmp dword [songdata], byte 0
        jne short .12
        mov ecx, str_Iff3
        mov ebx, str_Pause
        cmp byte [fileoncd+021Ch], 1
        jne short .10
        mov edx, dword [cddriveptr]
        jmp short .11
.10:
        xor edx, edx
.11:
        lea eax, [dword esp+0344h]
        call MakePath
        lea eax, [dword esp+0344h]
        call LoadDigiFile
        mov dword [songdata], eax
        test eax, eax
        je short .12
        test byte [gameopts], 40h
        je short .12
        mov edx, dword [musichandle]
        mov ecx, 4Ch
        mov ebx, 3
        call PlayDigiBlockLoop
.12:
        mov ebx, 10h
        lea edx, [byte esp+04h]
        xor eax, eax
        call FadePalStep
        push dword 1E0h
        push dword 280h
        push byte 0
        push byte 0
        call SetViewRect
        add esp, byte 10h
        mov ecx, dword [dword esp+03ECh]
        push ecx
        mov esi, dword [dword esp+0404h]
        push esi
        call MouseSetPos
        add esp, byte 8
        call dword [mousepollfn]
        call ClearInputQueue
        mov edi, dword [esp]
        cmp edi, byte 1
        jne short .13
        cmp dword [ctl1team], byte 0
        jge short .13
        cmp dword [ctl2team], byte 0
        jge short .13
        mov dword [dword esp+03F4h], edi
.13:
        call TicksSinceLastCall
        cmp dword [esp], byte 2
        jne near .21
        cmp dword [schedgameidx], 444h
        jl near .21
        mov ax, word [hmscore]
        cmp ax, word [awscore]
        jle short .14
        mov esi, dword [cont2team]
        jmp short .15
.14:
        mov esi, dword [HomeTeam]
.15:
        sar esi, 10h
        xor edi, edi
        cmp dword [curperiod], byte 3
        jle short .16
        mov edi, 0FFFFFFFFh
.16:
        mov edx, dword [HomeTeam-2]
        sar edx, 10h
        mov eax, dword [VisTeam-2]
        sar eax, 10h
        shl eax, 2
        mov edx, dword [nosplit edx*4+teamconf]
        mov ebx, dword [dword eax+teamconf]
        cmp edx, ebx
        je short .17
        mov ebx, 3
        jmp short .18
.17:
        or edx, ebx
        mov eax, edx
        sar edx, 1Fh
        mov ebx, 2
        idiv ebx
        lea ebx, [byte edx+01h]
.18:
        mov ecx, 1
        cmp dword [schedgameidx], 47Ch
        jl short .19
        mov ecx, 2
.19:
        cmp dword [schedgameidx], 498h
        jl short .20
        mov ecx, 3
.20:
        mov eax, dword [cupceremony-3]
        sar eax, 18h
        push eax
        push edi
        mov edx, dword [schedgameidx]
        sub edx, 444h
        mov eax, edx
        sar edx, 1Fh
        mov edi, 7
        idiv edi
        inc edx
        mov eax, esi
        call PaPlayoffResult
        xor dh, dh
        mov byte [cupceremony], dh
.21:
        mov dword [dword esp+03E8h], 0B4h
        jmp near .34
.22:
        test ebx, ebx
        jle short .23
        xor esi, esi
        mov dword [dword esp+03E8h], esi
.23:
        cmp dword [dword esp+03E8h], byte 0
        jne short .24
        cmp dword [esp], byte 0
        jne short .24
        cmp dword [gameresult], byte 0
        jne short .24
        test byte [gameopts+1], 1
        je short .24
        mov dword [dword esp+03E8h], 0FFFFFFFFh
        call MusicChanReset
        call SayBackMoment
.24:
        cmp dword [dword esp+03F4h], byte 0
        je near .29
        call TicksSinceLastCall
        mov esi, dword [dword esp+03F0h]
        sub esi, eax
        mov dword [dword esp+03F0h], esi
        test esi, esi
        jge near .29
        cmp byte [musicon], 0
        je short .25
        cmp dword [songdata], byte 0
        je short .25
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 3
        call SetDigiChannelVolume
.25:
        mov edx, 1
        mov dword [dword_C66D4], edx
        mov dword [dword_C66D0], edx
        call ClearInputQueue
        call InputRemove
        lea eax, [dword esp+0304h]
        push eax
        call TextRestoreState
        add esp, byte 4
        push dword 1E0h
        push dword 280h
        push byte 0
        push byte 0
        call SetViewRect
        add esp, byte 10h
        mov word [scrolly], ax
        mov word [scrollx], ax
        xor ecx, ecx
        mov dword [deferpending], ecx
        mov esi, dword [dword esp+03D4h]
        push esi
        mov edi, dword [dword esp+03DCh]
        push edi
        call MouseSetPos
        add esp, byte 8
        lea eax, [byte esp+04h]
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        lea edx, [byte esp+04h]
        mov eax, 1
        call FadePalStep
        mov eax, dword [gamemode]
        call SetScreenTitle
        mov ebp, dword [dword esp+03F8h]
        push ebp
        call FreeMemBlock
        add esp, byte 4
        cmp byte [musicon], 0
        je short .27
        cmp dword [songdata], byte 0
        je short .27
.26:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short SportsDesk.26
        mov edx, dword [songdata]
        push edx
        call PushMemDescriptorLocked
        add esp, byte 4
        xor ebx, ebx
        mov dword [songdata], ebx
.27:
        call DeskReloadGame
        cmp byte [musicon], 0
        je short .28
        cmp dword [gameresult], byte 0
        jne short .28
        test byte [gameopts+1], 1
        je short .28
        call MusicChanReset
        call FreeBackMoment
.28:
        xor eax, eax
        add esp, 408h
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.29:
        xor ebp, ebp
        mov dword [dword esp+03DCh], ebp
.30:
        call GetInputEvent
        test eax, eax
        je short .31
        lea ebx, [dword esp+03E0h]
        lea edx, [dword esp+03E4h]
        call dword [ptrupdatefn]
        mov dword [dword esp+03DCh], eax
        test al, 2
        je short SportsDesk.30
.31:
        test byte [dword esp+03DCh], 2
        jne near .35
        mov eax, dword [dword esp+03E4h]
        cmp eax, dword [dword esp+0400h]
        jne short .32
        mov eax, dword [dword esp+03E0h]
        cmp eax, dword [dword esp+03ECh]
        je near .34
.32:
        xor esi, esi
        mov dword [dword esp+03F4h], esi
        mov edi, dword [dword esp+03ECh]
        push edi
        mov ebp, dword [dword esp+0404h]
        push ebp
        mov eax, dword [dword esp+0400h]
        push eax
        call PutBlock
        add esp, byte 0Ch
        mov edx, dword [dword esp+03E0h]
        push edx
        mov ebx, dword [dword esp+03E8h]
        push ebx
        mov ecx, dword [dword esp+0400h]
        push ecx
        call GrabBlock
        add esp, byte 0Ch
        mov esi, dword [dword esp+03E0h]
        push esi
        mov edi, dword [dword esp+03E8h]
        push edi
        mov ebp, dword [pointerspr]
        push ebp
.33:
        call DrawArt
        add esp, byte 0Ch
        mov eax, dword [dword esp+03E4h]
        mov dword [dword esp+0400h], eax
        mov eax, dword [dword esp+03E0h]
        mov dword [dword esp+03ECh], eax
.34:
        cmp byte [musicon], 0
        je near SportsDesk.24
        mov ebx, dword [dword esp+03E8h]
        cmp ebx, TicksSinceLastCall
        jbe near SportsDesk.22
        call TicksSinceLastCall
        sub dword [dword esp+03E8h], eax
        jmp near SportsDesk.23
.35:
        xor edx, edx
        mov dword [dword esp+03F4h], edx
        lea eax, [dword esp+03CCh]
        push eax
        lea eax, [dword esp+03D4h]
        push eax
        lea eax, [dword esp+036Ch]
        push eax
        lea eax, [dword esp+03B0h]
        push eax
        mov ecx, dword [dword esp+0414h]
        lea ebx, [dword esp+03C4h]
        mov edx, dword [dword esp+03F0h]
        mov eax, dword [dword esp+03F4h]
        call MenuHitTest
        test eax, eax
        je near .69
        mov esi, dword [dword esp+03D0h]
        shl esi, 2
        mov eax, dword [dword esp+03CCh]
        shl eax, 5
        mov edx, dword [dword esp+esi+03B4h]
        add eax, edx
        cmp dword [byte eax+014h], byte 0
        je near .59
        mov eax, dword [dword esp+03CCh]
        cmp eax, dword [dword esp+esi+0394h]
        jne near .53
        mov ebp, dword [dword esp+03ECh]
        push ebp
        mov eax, dword [dword esp+0404h]
        push eax
        mov edx, dword [dword esp+0400h]
        push edx
        call PutBlock
        add esp, byte 0Ch
        mov esi, dword [dword esp+0404h]
        jmp short .38
.36:
        mov ebp, esi
        shl ebp, 2
        xor eax, eax
        mov dword [dword esp+ebp+0394h], eax
        mov edx, dword [dword esp+ebp+0384h]
        test edx, edx
        je short .37
        mov ebx, dword [dword esp+esi*8+0368h]
        push ebx
        mov ecx, dword [dword esp+esi*8+0368h]
        push ecx
        push edx
        call PutBlock
        add esp, byte 0Ch
        xor edx, edx
        mov dword [dword esp+esi*8+0368h], edx
        mov dword [dword esp+esi*8+0364h], edx
        mov ebx, dword [dword esp+ebp+0384h]
        push ebx
        call FreeMemBlock
        add esp, byte 4
.37:
        dec esi
.38:
        test esi, esi
        jg short SportsDesk.36
        xor eax, eax
        mov dword [dword esp+0404h], eax
        mov eax, dword [dword esp+03E4h]
        mov dword [deskptrx], eax
        mov eax, dword [dword esp+03E0h]
        mov dword [deskptry], eax
        mov eax, dword [dword esp+03D0h]
        mov edx, dword [dword esp+03CCh]
        shl edx, 5
        mov eax, dword [dword esp+eax*4+03B4h]
        call dword [byte edx+eax+014h]
        mov edx, eax
        mov dword [dword esp+03DCh], eax
        mov eax, dword [deskptrx]
        mov dword [dword esp+03E4h], eax
        mov eax, dword [deskptry]
        mov dword [dword esp+03E0h], eax
        xor ebx, ebx
        mov dword [dword esp+03C0h], ebx
        mov dword [dword esp+03BCh], ebx
        mov dword [dword esp+03B8h], ebx
        mov dword [dword esp+0390h], ebx
        mov dword [dword esp+038Ch], ebx
        mov dword [dword esp+0388h], ebx
        mov dword [dword esp+0384h], ebx
        mov dword [dword esp+03A0h], ebx
        mov dword [dword esp+039Ch], ebx
        mov dword [dword esp+0398h], ebx
        mov dword [dword esp+03B0h], ebx
        mov dword [dword esp+03ACh], ebx
        mov dword [dword esp+03A8h], ebx
        cmp edx, byte 1
        je short .39
        cmp edx, byte 5
        jne near .48
.39:
        call ClearInputQueue
        call InputRemove
        lea eax, [dword esp+0304h]
        push eax
        call TextRestoreState
        add esp, byte 4
        push dword 1E0h
        push dword 280h
        push byte 0
        push byte 0
        call SetViewRect
        add esp, byte 10h
        xor ecx, ecx
        mov dword [deferpending], ecx
        mov esi, dword [dword esp+03D4h]
        push esi
        mov edi, dword [dword esp+03DCh]
        push edi
        call MouseSetPos
        add esp, byte 8
        lea eax, [byte esp+04h]
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        cmp byte [musicon], 0
        je short .40
        cmp dword [songdata], byte 0
        je short .40
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 3
        call SetDigiChannelVolume
.40:
        cmp dword [dword esp+03DCh], byte 1
        jne short .41
        cmp byte [musicon], 0
        je short .41
        test byte [gameopts+1], 1
        je short .41
        call MusicChanReset
        call SayNowBack
.41:
        mov ebx, 14h
        lea edx, [byte esp+04h]
        mov eax, 1
        call FadePalStep
        cmp dword [dword esp+03DCh], byte 1
        je short .42
        mov dword [gameresult], 2
.42:
        mov eax, dword [gamemode]
        call SetScreenTitle
        mov ecx, dword [dword esp+03F8h]
        test ecx, ecx
        je short .43
        push ecx
        call FreeMemBlock
        add esp, byte 4
.43:
        cmp byte [musicon], 0
        je short .45
        cmp dword [songdata], byte 0
        je short .45
.44:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short SportsDesk.44
        mov esi, dword [songdata]
        push esi
        call PushMemDescriptorLocked
        add esp, byte 4
        xor edi, edi
        mov dword [songdata], edi
.45:
        cmp dword [dword esp+03DCh], byte 1
        jne short .46
        call DeskReloadGame
.46:
        cmp dword [dword esp+03DCh], byte 1
        jne near SportsDesk.28
        cmp byte [musicon], 0
        je near SportsDesk.28
        test byte [gameopts+1], 1
        je near SportsDesk.28
.47:
        call SpeechBusy
        test eax, eax
        jne short SportsDesk.47
        call FreeNowBack
        jmp near SportsDesk.28
.48:
        cmp edx, byte 2
        jne near .52
        lea eax, [byte esp+04h]
        push eax
        push dword 100h
        push ebx
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        lea edx, [byte esp+04h]
        mov eax, 1
        call FadePalStep
        mov eax, 0AAE60h
        call EnsureFreeMemory
        xor ecx, ecx
        mov ebx, deskbankname
        mov eax, dword [esp]
        cmp byte [dword eax+fileoncd+064h], 1
        jne short .49
        mov edx, dword [cddriveptr]
        jmp short .50
.49:
        xor edx, edx
.50:
        lea eax, [dword esp+0344h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0348h]
        push eax
        call LoadBank
        mov esi, eax
        add esp, byte 8
        mov edi, eax
        push str_Desk
        push eax
        call FindShape
        add esp, byte 8
        push eax
        call DrawBitmap
        add esp, byte 4
        push str_Pal5
        push esi
        call FindShape
        add esp, byte 8
        lea edx, [byte eax+010h]
        xor esi, esi
.51:
        mov al, byte [edx+esi]
        mov byte [byte esp+esi+04h], al
        inc esi
        cmp esi, 300h
        jl short SportsDesk.51
        push edi
        call FreeMemBlock
        add esp, byte 4
        push dword 0F8h
        mov ecx, 0F9h
        mov ebx, 0FAh
        mov edx, dword [dword esp+03A8h]
        mov eax, dword [dword esp+03B8h]
        call DrawMenuBar
        mov ebx, 10h
        lea edx, [byte esp+04h]
        xor eax, eax
        call FadePalStep
.52:
        mov ecx, dword [dword esp+03ECh]
        push ecx
        mov esi, dword [dword esp+0404h]
        push esi
        call MouseSetPos
        add esp, byte 8
        call ClearInputQueue
        jmp near .73
.53:
        mov ebx, dword [dword esp+03ECh]
        push ebx
        mov ecx, dword [dword esp+0404h]
        push ecx
        mov esi, dword [dword esp+0400h]
        push esi
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [dword esp+0404h]
        cmp eax, dword [dword esp+03D0h]
        je near .57
        mov esi, eax
        jmp short .56
.54:
        mov edi, esi
        shl edi, 2
        xor ebp, ebp
        mov dword [dword esp+edi+0394h], ebp
        mov eax, dword [dword esp+edi+0384h]
        test eax, eax
        je short .55
        mov ebp, esi
        mov edx, dword [dword esp+esi*8+0368h]
        push edx
        mov ebx, dword [dword esp+esi*8+0368h]
        push ebx
        push eax
        call PutBlock
        add esp, byte 0Ch
        xor eax, eax
        mov dword [dword esp+esi*8+0368h], eax
        mov dword [dword esp+esi*8+0364h], eax
        mov edx, dword [dword esp+edi+0384h]
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor ebx, ebx
        mov dword [dword esp+edi+0384h], ebx
        mov dword [dword esp+edi+03B4h], ebx
        xor ebp, esi
        mov dword [dword esp+edi+03A4h], ebp
.55:
        dec esi
.56:
        mov edi, dword [dword esp+03D0h]
        cmp esi, edi
        jg short SportsDesk.54
        mov dword [dword esp+0404h], edi
.57:
        push dword 0F8h
        push dword 0F9h
        mov eax, dword [dword esp+03D8h]
        mov ebx, dword [dword esp+eax*8+0370h]
        mov edx, dword [dword esp+eax*8+036Ch]
        mov ecx, dword [dword esp+eax*4+039Ch]
        shl ecx, 5
        mov eax, dword [dword esp+eax*4+03BCh]
        add eax, ecx
        mov ecx, 0FAh
        call DrawMenuItemSel
        mov edx, dword [dword esp+03D0h]
        mov eax, dword [dword esp+03CCh]
        mov dword [dword esp+edx*4+0394h], eax
        push dword 0F8h
        push dword 0F9h
        mov ebx, dword [dword esp+edx*8+0370h]
        mov eax, dword [dword esp+edx*8+036Ch]
        mov ecx, dword [dword esp+edx*4+039Ch]
        shl ecx, 5
        mov esi, dword [dword esp+edx*4+03BCh]
        add esi, ecx
        mov ecx, 0FAh
        mov edx, eax
        mov eax, esi
.58:
        call DrawMenuItemNorm
        jmp near .73
.59:
        cmp dword [byte eax+018h], byte 0
        je near .68
        mov ecx, dword [dword esp+03ECh]
        push ecx
        mov esi, dword [dword esp+0404h]
        push esi
        mov edi, dword [dword esp+0400h]
        push edi
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [dword esp+0404h]
        cmp eax, dword [dword esp+03D0h]
        je near .63
        mov esi, eax
        jmp short .62
.60:
        mov edi, esi
        shl edi, 2
        xor ebp, ebp
        mov dword [dword esp+edi+0394h], ebp
        mov eax, dword [dword esp+edi+0384h]
        test eax, eax
        je short .61
        mov ebp, esi
        mov edx, dword [dword esp+esi*8+0368h]
        push edx
        mov ebx, dword [dword esp+esi*8+0368h]
        push ebx
        push eax
        call PutBlock
        add esp, byte 0Ch
        xor eax, eax
        mov dword [dword esp+esi*8+0368h], eax
        mov dword [dword esp+esi*8+0364h], eax
        mov edx, dword [dword esp+edi+0384h]
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor ebx, ebx
        mov dword [dword esp+edi+0384h], ebx
        mov dword [dword esp+edi+03B4h], ebx
        xor ebp, esi
        mov dword [dword esp+edi+03A4h], ebp
.61:
        dec esi
.62:
        mov ecx, dword [dword esp+03D0h]
        cmp esi, ecx
        jg short SportsDesk.60
        mov dword [dword esp+0404h], ecx
.63:
        push dword 0F8h
        push dword 0F9h
        mov edi, dword [dword esp+040Ch]
        mov ebx, dword [dword esp+edi*8+0370h]
        mov edx, dword [dword esp+edi*8+036Ch]
        mov eax, dword [dword esp+edi*4+039Ch]
        shl eax, 5
        mov ecx, dword [dword esp+edi*4+03BCh]
        add eax, ecx
        mov ecx, 0FAh
        call DrawMenuItemSel
        mov eax, dword [dword esp+03CCh]
        mov dword [dword esp+edi*4+0394h], eax
        push dword 0F8h
        push dword 0F9h
        mov ebx, dword [dword esp+edi*8+0370h]
        mov edx, dword [dword esp+edi*8+036Ch]
        shl eax, 5
        mov ecx, dword [dword esp+edi*4+03BCh]
        add eax, ecx
        mov ecx, 0FAh
        call DrawMenuItemNorm
        mov eax, dword [dword esp+03D0h]
        mov ecx, dword [dword esp+03CCh]
        shl ecx, 5
        mov ebx, dword [dword esp+eax*4+03B4h]
        lea edx, [byte edi+01h]
        mov dword [dword esp+0404h], edx
        mov ebx, dword [byte ecx+ebx+018h]
        mov dword [dword esp+edx*4+03B4h], ebx
        mov eax, dword [dword esp+eax*4+03B4h]
        add eax, ecx
        mov ebx, dword [byte eax+01Ch]
        mov dword [dword esp+edx*4+03A4h], ebx
        cmp edx, byte 1
        je short .64
        mov edx, dword [byte eax+08h]
        jmp short .65
.64:
        mov edx, dword [eax]
.65:
        mov eax, dword [dword esp+0404h]
        mov ecx, dword [dword esp+eax*8+035Ch]
        add edx, ecx
        mov dword [dword esp+eax*8+0364h], edx
        mov edx, dword [dword esp+03CCh]
        shl edx, 5
        mov eax, dword [dword esp+03D0h]
        shl eax, 2
        cmp dword [dword esp+0404h], byte 1
        je short .66
        mov eax, dword [dword esp+eax+03B4h]
        mov eax, dword [byte edx+eax+04h]
        jmp short .67
.66:
        mov eax, dword [dword esp+eax+03B4h]
        mov eax, dword [byte edx+eax+0Ch]
.67:
        mov edx, dword [dword esp+0404h]
        shl edx, 3
        mov dword [dword esp+03FCh], edx
        mov edi, dword [dword esp+edx+0360h]
        add eax, edi
        mov dword [dword esp+edx+0368h], eax
        mov ebp, dword [dword esp+0404h]
        mov edx, dword [dword esp+ebp*4+03A4h]
        shl edx, 5
        mov eax, dword [dword esp+ebp*4+03B4h]
        mov ebx, dword [byte edx+eax-018h]
        sub ebx, dword [eax]
        inc ebx
        mov dword [dword esp+03C4h], ebx
        mov edx, dword [byte edx+eax-014h]
        sub edx, dword [byte eax+04h]
        inc edx
        mov dword [dword esp+03C8h], edx
        push byte 20h
        mov eax, ebx
        imul eax, edx
        add eax, byte 11h
        push eax
        push str_Menubuff3
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [dword esp+ebp*4+0384h], eax
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov eax, dword [dword esp+ebp*4+0384h]
        mov edx, dword [dword esp+03C4h]
        mov word [byte eax+04h], dx
        mov eax, dword [dword esp+ebp*4+0384h]
        mov edx, dword [dword esp+03C8h]
        mov word [byte eax+06h], dx
        mov eax, dword [dword esp+03FCh]
        mov edx, dword [dword esp+eax+0368h]
        push edx
        mov ebx, dword [dword esp+eax+0368h]
        push ebx
        mov ecx, dword [dword esp+ebp*4+038Ch]
        push ecx
        call GrabBlock
        add esp, byte 0Ch
        push dword 0F8h
        push dword 0F9h
        push dword 0FAh
        mov ecx, dword [dword esp+0408h]
        mov ecx, dword [dword esp+ecx+0374h]
        mov ebx, dword [dword esp+0408h]
        mov ebx, dword [dword esp+ebx+0370h]
        mov edx, dword [dword esp+ebp*4+03B0h]
        mov eax, dword [dword esp+ebp*4+03C0h]
        call DrawMenuDropdown
        xor esi, esi
        mov dword [dword esp+ebp*4+0394h], esi
        push dword 0F8h
        push dword 0F9h
        mov ebx, dword [dword esp+0404h]
        mov ebx, dword [dword esp+ebx+0370h]
        mov edx, dword [dword esp+0404h]
        mov edx, dword [dword esp+edx+036Ch]
        mov eax, dword [dword esp+ebp*4+03BCh]
        mov ecx, 0FAh
        jmp near SportsDesk.58
.68:
        mov eax, dword [dword esp+03ECh]
        push eax
        mov edx, dword [dword esp+0404h]
        push edx
        mov ebx, dword [dword esp+0400h]
        push ebx
        call PutBlock
        add esp, byte 0Ch
        jmp near .73
.69:
        mov ebx, dword [dword esp+03ECh]
        push ebx
        mov ecx, dword [dword esp+0404h]
        push ecx
        mov esi, dword [dword esp+0400h]
        push esi
        call PutBlock
        add esp, byte 0Ch
        mov esi, dword [dword esp+0404h]
        jmp short .72
.70:
        mov ebp, esi
        shl ebp, 2
        xor eax, eax
        mov dword [dword esp+ebp+0394h], eax
        mov edx, dword [dword esp+ebp+0384h]
        test edx, edx
        je short .71
        mov ebx, dword [dword esp+esi*8+0368h]
        push ebx
        mov ecx, dword [dword esp+esi*8+0368h]
        push ecx
        push edx
        call PutBlock
        add esp, byte 0Ch
        xor edx, edx
        mov dword [dword esp+esi*8+0368h], edx
        mov dword [dword esp+esi*8+0364h], edx
        mov ebx, dword [dword esp+ebp+0384h]
        push ebx
        call FreeMemBlock
        add esp, byte 4
.71:
        dec esi
.72:
        test esi, esi
        jg short SportsDesk.70
        xor eax, eax
        mov dword [dword esp+0404h], eax
        mov dword [dword esp+03C0h], eax
        mov dword [dword esp+03BCh], eax
        mov dword [dword esp+03B8h], eax
        mov dword [dword esp+0390h], eax
        mov dword [dword esp+038Ch], eax
        mov dword [dword esp+0388h], eax
        mov dword [dword esp+0384h], eax
        mov dword [dword esp+03A0h], eax
        mov dword [dword esp+039Ch], eax
        mov dword [dword esp+0398h], eax
        mov dword [dword esp+03B0h], eax
        mov dword [dword esp+03ACh], eax
        mov dword [dword esp+03A8h], eax
.73:
        mov edi, dword [dword esp+03E0h]
        push edi
        mov ebp, dword [dword esp+03E8h]
        push ebp
        mov eax, dword [dword esp+0400h]
        push eax
        call GrabBlock
        add esp, byte 0Ch
        mov edx, dword [dword esp+03E0h]
        push edx
        mov ebx, dword [dword esp+03E8h]
        push ebx
        mov ecx, dword [pointerspr]
        push ecx
        jmp near SportsDesk.33
;-----------------------------------------------------------------------------
; DeskReloadGame                                  1A534  95 PC, low confidence
; Reloads the home team art (LoadRink, team 0Ch for the all-star teams) and
; LoadPlayerPhotos, fades in and flags a desk redraw (dword_C66D4 /
; dword_C66D0); SportsDesk
;-----------------------------------------------------------------------------
; C: src/front/desk/DeskReloadGame.c
%ifdef CBUILD
%include "c/front/desk/DeskReloadGame.inc"
%else
DeskReloadGame:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        cmp word [HomeTeam], byte 1Ah
        jl short .1
        mov eax, 0Ch
        jmp short .2
.1:
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
.2:
        call LoadRink
        call LoadPlayerPhotos
        push savepal
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, savepal
        mov eax, 1
        call FadePalStep
        mov edx, 1
        mov dword [dword_C66D4], edx
        mov dword [dword_C66D0], edx
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DeskBackToGame                                                  1A5A1  95 PC
; "Back to Game" item: returns 1
;-----------------------------------------------------------------------------
; C: src/front/desk/DeskBackToGame.c
%ifdef CBUILD
%include "c/front/desk/DeskBackToGame.inc"
%else
DeskBackToGame:
        push dword 4
        call __CHK
        mov eax, 1
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DeskToSportsDesk                             1A5B1  95 PC, medium confidence
; "Sports Desk" item (no confirmation): flags a redraw, returns 5
;-----------------------------------------------------------------------------
; C: src/front/desk/DeskToSportsDesk.c
%ifdef CBUILD
%include "c/front/desk/DeskToSportsDesk.inc"
%else
DeskToSportsDesk:
        push dword 8
        call __CHK
        push edx
        mov edx, 1
        mov dword [dword_C66D4], edx
        mov dword [dword_C66D0], edx
        mov eax, 5
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DeskReturnConfirm                                               1A5D4  95 PC
; "Sports Desk" item in a game: MessageBox "Returning to sports central" /
; "Returning out of the game" / "Returning to the playoff tree" (by gamemode)
; "Do you wish to return?"; yes returns 5, else 0
;-----------------------------------------------------------------------------
; C: src/front/desk/DeskReturnConfirm.c
%ifdef CBUILD
%include "c/front/desk/DeskReturnConfirm.inc"
%else
DeskReturnConfirm:
        push dword 34h
        call __CHK
        push ebx
        push ecx
        push edx
        push edi
        sub esp, byte 0Ch
        mov eax, esp
        push eax
        lea eax, [byte esp+08h]
        push eax
        lea eax, [byte esp+010h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        mov eax, dword [gamemode]
        cmp eax, byte 1
        jb short .1
        jbe short .3
        cmp eax, byte 2
        je short .2
        jmp short .4
.1:
        test eax, eax
        jne short .4
        mov dword [msg_DeskExit], str_ReturningToSportsCentral
        jmp short .4
.2:
        mov dword [msg_DeskExit], str_ReturningOutOfThe
        jmp short .4
.3:
        mov dword [msg_DeskExit], str_ReturningToThePlayoff
.4:
        mov dword [msg_DeskExit_e02], str_DoYouWishToReturn
        push byte 0
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
        push byte 0FFFFFFFFh
        lea eax, [byte esp+08h]
        push eax
        lea eax, [byte esp+010h]
        push eax
        push byte 2
        push btn_POHumanOut
        mov ecx, 3
        mov ebx, msg_DeskExit
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov dword [esp], eax
        test eax, eax
        jg short .5
        xor eax, eax
        jmp short .x
.5:
        mov edi, 1
        mov dword [dword_C66D4], edi
        mov dword [dword_C66D0], edi
        mov eax, 5
.x:
        add esp, byte 0Ch
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DeskExitGame                                                    1A6A7  95 PC
; "Exit" item: MessageBox "Exiting the game" / "Do you wish to exit?"; on yes
; stops the music, ShowCredits and leaves through bailout_vec
;-----------------------------------------------------------------------------
; C: src/front/desk/DeskExitGame.c
%ifdef CBUILD
%include "c/front/desk/DeskExitGame.inc"
%else
DeskExitGame:
        push dword 38h
        call __CHK
        push ebx
        push ecx
        push edx
        push edi
        push ebp
        sub esp, byte 0Ch
        cmp byte [musicon], 0
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
        lea eax, [byte esp+08h]
        push eax
        lea eax, [byte esp+010h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        mov dword [msg_DeskExit], str_ExitingTheGame
        mov dword [msg_DeskExit_e02], str_DoYouWishToExit
        push byte 0
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
        push byte 0FFFFFFFFh
        lea eax, [byte esp+08h]
        push eax
        lea eax, [byte esp+010h]
        push eax
        push byte 2
        push btn_POHumanOut
        mov ecx, 3
        mov ebx, msg_DeskExit
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov dword [esp], eax
        test eax, eax
        jle near .4
        push savepal
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, savepal
        mov eax, 1
        call FadePalStep
        call SetScreenTarget
        push byte 0
        call ClearScreen
        add esp, byte 4
        cmp byte [musicon], 0
        je short .3
        cmp dword [songdata], byte 0
        je short .3
.2:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short DeskExitGame.2
        mov edi, dword [songdata]
        push edi
        call PushMemDescriptorLocked
        add esp, byte 4
        xor ebp, ebp
        mov dword [songdata], ebp
.3:
        call ShowLoadingScreen
        call FreeGameMemory
        call ShowCredits
        push savepal
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, savepal
        mov eax, 1
        call FadePalStep
        call SetTextMode
        call dword [bailout_vec]
.4:
        xor eax, eax
        add esp, byte 0Ch
        pop ebp
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DeskGoToReplay                               1A817  95 PC, medium confidence
; "Go To Replay ..." item: reloads the home team art and photos, fades,
; 320x200, InstantReplay (replay), flags a redraw
;-----------------------------------------------------------------------------
; C: src/front/desk/DeskGoToReplay.c
%ifdef CBUILD
%include "c/front/desk/DeskGoToReplay.inc"
%else
DeskGoToReplay:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        cmp word [HomeTeam], byte 1Ah
        jl short .1
        mov eax, 0Ch
        jmp short .2
.1:
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
.2:
        call LoadRink
        call LoadPlayerPhotos
        push savepal
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, savepal
        mov eax, 1
        call FadePalette
        mov edx, 0C8h
        mov eax, 140h
        call SetScreenSize
        xor eax, eax
        call InstantReplay
        mov edx, dword [s1font]
        push edx
        call TextSetFont
        add esp, byte 4
        mov ebx, 1
        mov dword [dword_C66D4], ebx
        mov dword [dword_C66D0], ebx
        jmp near DeskItem_ret2
;-----------------------------------------------------------------------------
; DeskHomeLines                                1A8AA  95 PC, medium confidence
; "Home Team ..." item: fade, line editor for hmlinetab (GameLineEditor team
; 0)
;-----------------------------------------------------------------------------
DeskHomeLines:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push savepal
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, savepal
        mov eax, 1
        call FadePalStep
        mov ecx, 2
        mov ebx, desklinesmenubar
        mov edx, hmlinetab
        xor eax, eax
DeskLines_common:
        call GameLineEditor
        push savepal
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, savepal
        mov eax, 1
        call FadePalStep
        jmp near DeskItem_ret2
;-----------------------------------------------------------------------------
; DeskVisitorLines                             1A922  95 PC, medium confidence
; "Visiting Team ..." item: fade, line editor for awlinetab (GameLineEditor
; team 1)
;-----------------------------------------------------------------------------
DeskVisitorLines:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push savepal
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, savepal
        mov eax, 1
        call FadePalStep
        mov ecx, 2
        mov ebx, desklinesmenubar
        mov edx, awlinetab
        mov eax, 1
        jmp short DeskLines_common
;-----------------------------------------------------------------------------
; DeskGameStats                                1A96D  95 PC, medium confidence
; "Game Statistics ..." item: fade, GameStatsScreen
;-----------------------------------------------------------------------------
DeskGameStats:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push savepal
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, savepal
        mov eax, 1
        call FadePalStep
        call GameStatsScreen
        jmp near DeskItem_ret2
;-----------------------------------------------------------------------------
; DeskPenaltySummary                           1A9AC  95 PC, medium confidence
; "Penalty Summary ..." item: fades the music, GameSummaryScreen summary page
;-----------------------------------------------------------------------------
DeskPenaltySummary:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push savepal
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        cmp byte [musicon], 0
        je short .1
        cmp dword [songdata], byte 0
        je short .1
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 3
        call SetDigiChannelVolume
.1:
        mov ebx, 10h
        mov edx, savepal
        mov eax, 1
        call FadePalStep
        cmp byte [musicon], 0
        je short .3
        cmp dword [songdata], byte 0
        je short .3
.2:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short DeskPenaltySummary.2
        mov ecx, dword [songdata]
        push ecx
        call PushMemDescriptorLocked
        add esp, byte 4
        xor esi, esi
        mov dword [songdata], esi
.3:
        call ShowLoadingScreen
        mov ebx, dword [curperiod]
        xor ecx, ecx
        mov edx, 1
        mov eax, 2
        call GameSummaryScreen
        mov eax, 2
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; DeskScoringSummary                           1AA6D  95 PC, medium confidence
; "Scoring Summary ..." item: fade, GameSummaryScreen(1)
;-----------------------------------------------------------------------------
DeskScoringSummary:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push savepal
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, savepal
        mov eax, 1
        call FadePalStep
        call ShowLoadingScreen
        mov ebx, dword [curperiod]
        xor ecx, ecx
        mov edx, 1
        mov eax, edx
DeskSummary_common:
        call GameSummaryScreen
DeskItem_ret2:
        mov eax, 2
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; DeskTeamScratches                            1AAC4  95 PC, medium confidence
; "Team Scratches ..." item: fade, GameSummaryScreen(4)
;-----------------------------------------------------------------------------
DeskTeamScratches:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push savepal
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, savepal
        mov eax, 1
        call FadePalStep
        call ShowLoadingScreen
        xor ecx, ecx
        xor ebx, ebx
        xor edx, edx
        mov eax, 4
        jmp short DeskSummary_common
;-----------------------------------------------------------------------------
; DeskHomeGoalie1                              1AB0B  95 PC, medium confidence
; "Home Team Goalie" menu, first goalie: SetTeamGoalie(0, 0) and marks the
; item
;-----------------------------------------------------------------------------
DeskHomeGoalie1:
        push dword 8
        call __CHK
        push edx
        xor edx, edx
        xor eax, eax
        call SetTeamGoalie
        mov eax, dword [mi_HomeGoalie1]
        mov byte [eax], 1
        mov eax, dword [mi_HomeGoalie2]
        mov byte [eax], 2
DeskGoalie_x1:
        mov eax, dword [mi_HomeGoalieNone]
        jmp near DeskGoalie_x4
;-----------------------------------------------------------------------------
; DeskHomeGoalie2                              1AB39  95 PC, medium confidence
; Home second goalie: SetTeamGoalie(0, 1)
;-----------------------------------------------------------------------------
DeskHomeGoalie2:
        push dword 8
        call __CHK
        push edx
        mov edx, 1
        xor eax, eax
        call SetTeamGoalie
        mov eax, dword [mi_HomeGoalie1]
        mov byte [eax], 2
        mov eax, dword [mi_HomeGoalie2]
        mov byte [eax], 1
        jmp short DeskGoalie_x1
;-----------------------------------------------------------------------------
; DeskHomeGoalieNone                           1AB62  95 PC, medium confidence
; Home goalie "NONE" (empty net): SetTeamGoalie(0, -1)
;-----------------------------------------------------------------------------
DeskHomeGoalieNone:
        push dword 8
        call __CHK
        push edx
        mov edx, 0FFFFFFFFh
        xor eax, eax
        call SetTeamGoalie
        mov eax, dword [mi_HomeGoalie1]
        mov byte [eax], 2
        mov eax, dword [mi_HomeGoalie2]
        mov byte [eax], 2
        mov eax, dword [mi_HomeGoalieNone]
DeskGoalie_x2:
        mov byte [eax], 1
        xor eax, eax
        pop edx
        ret
;-----------------------------------------------------------------------------
; DeskAwayGoalie1                              1AB95  95 PC, medium confidence
; Visiting first goalie: SetTeamGoalie(1, 0)
;-----------------------------------------------------------------------------
DeskAwayGoalie1:
        push dword 8
        call __CHK
        push edx
        xor edx, edx
        mov eax, 1
        call SetTeamGoalie
        mov eax, dword [mi_AwayGoalie1]
        mov byte [eax], 1
        mov eax, dword [mi_AwayGoalie2]
        mov byte [eax], 2
DeskGoalie_x3:
        mov eax, dword [mi_AwayGoalieNone]
DeskGoalie_x4:
        mov byte [eax], 2
        xor eax, eax
        pop edx
        ret
;-----------------------------------------------------------------------------
; DeskAwayGoalie2                              1ABC8  95 PC, medium confidence
; Visiting second goalie: SetTeamGoalie(1, 1)
;-----------------------------------------------------------------------------
DeskAwayGoalie2:
        push dword 8
        call __CHK
        push edx
        mov edx, 1
        mov eax, edx
        call SetTeamGoalie
        mov eax, dword [mi_AwayGoalie1]
        mov byte [eax], 2
        mov eax, dword [mi_AwayGoalie2]
        mov byte [eax], 1
        jmp short DeskGoalie_x3
;-----------------------------------------------------------------------------
; DeskAwayGoalieNone                           1ABF1  95 PC, medium confidence
; Visiting goalie "NONE": SetTeamGoalie(1, -1)
;-----------------------------------------------------------------------------
DeskAwayGoalieNone:
        push dword 8
        call __CHK
        push edx
        mov edx, 0FFFFFFFFh
        mov eax, 1
        call SetTeamGoalie
        mov eax, dword [mi_AwayGoalie1]
        mov byte [eax], 2
        mov eax, dword [mi_AwayGoalie2]
        mov byte [eax], 2
        mov eax, dword [mi_AwayGoalieNone]
        jmp near DeskGoalie_x2
%endif ; C
