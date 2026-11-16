; Start-up and the in-game pads. Memory and disk checks, keyboard, joystick and mouse, hot keys,
; the frame loop, the palette fade, and the game loop that launches a game.
bits 32
%include "hockey.inc"
section s_10010 progbits alloc exec nowrite align=1
extern __CHK, __STOSB, _dos_getdiskfree_, _dos_getdrive_, _dos_gettime_, addtimer, awardtype, awardwinners
extern bailout_vec, bannertimer, bgscrollx, bgscrolly, BuildDefaultLines, fadeendlvl, JoyPortMask, fadepalbuf
extern byte_D9299, camx, camx_m2, camy, cddriveptr, ClearInputQueue, ClockTick, clockticks
extern cont1team, cont2team, CritErrHandler, Crowd_Noise, CrowdFadeOut, CrowdNoiseOff, CrowdNoiseReset, ctl1dev
extern ctl1side, ctl1team, ctl2dev, ctl2side, ctl2team, ctlavailmask, cupteam, curleague
extern curperiod, deferpending, demomode, DoGameFrame, DrawHudPanel, DrawRinkOverlays, DrawSprite, dword_C4CFC
extern fadestart_m3, fadestep_m3, fadestart_e1, ovlartfiles, BackBufferWidth, JoyRawX1, JoyRawY1, JoyRawX2
extern JoyRawY2, gfxidlist, ovlstepart, ovlartbank, SpeechPatchNext, escrequest
extern exhstate, exit_, exitgame, fadeinpending, FadeOutPalCycle, FadePalStep, FatalError, FileClose
extern fileoncd, FileOpenRead, FileReadAt, FlushGSumQueue, frameaccum, gameclock, gamemode, gameopts
extern gameover, gamepal, gameresult, gmode, gsp, HomeTeam, hudclockhund, hudclockmin
extern hudclocksec, hudhundaccum, hudhundstep, InitFileLocations, inputframes, InputInstall, InputRemove, inputticks
extern InstallTimer, InstantReplay, int386_, IntermissionDesk, introskipped, j_unlink_, joyenablemask, joypresent
extern joyq_flush, joyq_peek, joyq_pop, joyqcount, joyqhead, joyqtick, joyqueue, joyrawbits
extern joyrec, joysampling, joysampling_save, JoystickCalScreen, kaufmfont, keydirtab, lasthotkey, lcreqchoice
extern lcrequest, leaguedbnames, LoadCupFinalSeries, LoadGameGfx, LoadGameState, LoadModeState, LoadNhlCfg, LoadRink
extern LoadRockMusic, LoadTeamPalette, MainDeskLoop, mainfont, MakeGSummaryPath, MakePath, memlist0, memlist1
extern mousebtns, mousepollfn, MouseSetPos, mousex, mousey, MusicChanReset, musichandle, musicon
extern musicslot, NormalizeDressFlags, numshapes, awardstatsptrs, awardstatsptrs_e01, awardstatsptrs_e02, awardstatsptrs_e03, awardstatsptrs_e04
extern awardstatsptrs_e05, awardstatsptrs_e06, awardstatsptrs_e08, awardstatsptrs_e09, ovlartnames, ovlseq, ovlstep, pad1dev
extern pad2dev, palfadedin, PaPreloadClips, penshotlive, PeriodOver, photoptrs, PlayCrowdSample, pntrshapes
extern pointerspr, PollKey, PostGameDesk, presidentsteam, printf_, ReadGoalieSeasonRec, ReadKeyRec, ReadSeasonRec
extern ReadTeamNames, ReadTeamRec, recbpr, replaystart, ResetGoalieMenu, rinkendart, rinkhtiles, rinkscrollx
extern rinkscrolly, rinkwtiles, RunDeferredCalls, RunIntro, s1font, samesideflag, savedmousex, savedmousey
extern savepal, scor2font, scor3font, screenbm, screenh, screenw, scrollx, scrolly
extern SelectScreenBM, SetRinkScroll, SetTickDeadline, SetupGame, SetupGoalieMenu, SetupTeamLines, sflags, ShowCredits
extern ShowGoalieBanner, ShowLoadingScreen, shownumbers, songdata, SpeechStopQueue, SportsDesk, spritedrawcount, srand_
extern StartThreeStars, StopDigiSample, str_backslash, str_CheckRefCard, str_CheckRefCard2, str_ConfigureLeftJoystick, str_ConfigureRightJoystick, str_errd3
extern str_errd4, str_ErrDiskFree2, str_ErrDiskFree3, str_extDB, str_GameSav2, str_GameSet2, str_Kaufm020, str_NoConvMemory
extern str_NoDiskSpaceC, str_NoDiskSpaceCur, str_NoMemory, str_Pntr, str_Pointer3, str_PPV, str_S1, str_Scor2b
extern str_Scor3b, str_Temp3, str_VFN, strcat_, strcpy_, FreeGameMemory, EnsureFreeMemory, InitZoneManager
extern FlushZones, SetZoneScreen, SetZoneOrigin, BeginZoneFrame, AllocMemBlock, PushMemDescriptorLocked, SetupMemoryPoolReserve, initgraphics
extern subwindowdefadr, LoadBank, OpenArtArchiveErr, TextSetFont, ReleaseAllVoices, EnableMidiSfx, DisableMidiSfx, EnableMidiMusic
extern DisableMidiMusic, SndQuery, SetDigiChannelVolume, SetPalette, ShapeBankCount, ShapeBankEntry, InstallKeyboardHandler, KeyDown
extern SetViewRect, InitMouse, InstallBreakHandler, FindShape, CalibrateJoystick, JoyResetCentres, ReadJoyRaw, ClearScreen
extern KbdFlush, SetTextMode, VgaSetPalette, SetScreenTarget, SetClipWindow, WaitRetrace, WaitRetraceEnd, teamabbrevs
extern TicksSinceLastCall, treeteamnames, blackpal, awardwinners_e01, awardwinners_e02, awardwinners_e03, awardwinners_e04, awardwinners_e05
extern awardwinners_e06, awardwinners_e08, awardwinners_e09, awardstats9g, awardstats9, UpdateHudPanel, viewscrollx, viewscrolly
extern VisTeam, vtoa, WaitTickDeadline, SortPending
global GetMemListHead, GetMemStats, main_, main_x, DiskFreeBytes, SetupControllers, ReadKeyboardPad, ReadJoyPad
global ReadMousePad, ReadControllerPad, ReadHotKeys, ReadSkipKeys, SampleInputTick, SetScreenSize, IntermissionPC, DrawSpriteNumber
global DrawFrameSprite, DrawRinkEndArt, WaitKeyRelease, HandleHotKey, HandleHotKey_ret, ResetInputSampling, RunGameFrames, SetFullPalette
global FadePalette, Gameloop, PlayGame, assreplace, assinsert, ReplayIsEmpty
;-----------------------------------------------------------------------------
; GetMemListHead                                                  10010  95 PC
; Returns memlist1 when eax != 0 else memlist0
;-----------------------------------------------------------------------------
; C: src/front/main/GetMemListHead.c
%ifdef CBUILD
%include "c/front/main/GetMemListHead.inc"
%else
GetMemListHead:
        push dword 4
        call __CHK
        test eax, eax
        je short .1
        mov eax, dword [memlist1]
        ret
.1:
        mov eax, dword [memlist0]
        ret
%endif ; C
;-----------------------------------------------------------------------------
; GetMemStats                                  1002A  95 PC, medium confidence
; Walks the memory block list from GetMemListHead(1) (next at +20h) and
; returns total, free, used and largest block through four pointers; main_
; refuses to start ('Insufficient memory available.') when the total is below
; 1E5D70h
;-----------------------------------------------------------------------------
; C: src/front/main/GetMemStats.c
%ifdef CBUILD
%include "c/front/main/GetMemStats.inc"
%else
GetMemStats:
        push dword 14h
        call __CHK
        push esi
        push edi
        push ebp
        push eax
        mov esi, edx
        mov eax, 1
        call GetMemListHead
        mov edx, eax
        mov eax, dword [byte eax+020h]
        mov dword [ecx], 0
        mov edi, dword [ecx]
        mov dword [ebx], edi
        mov dword [esi], edi
        mov ebp, dword [esp]
        mov dword [byte ebp+00h], edi
.1:
        test eax, eax
        je short .4
        mov edi, dword [eax]
        sub edi, dword [edx]
        mov ebp, dword [byte edx+010h]
        mov edx, edi
        sub edx, ebp
        test byte [byte eax+019h], 80h
        jne short .2
        mov edi, dword [byte eax+010h]
        add dword [esi], edi
.2:
        add dword [ebx], edx
        cmp edx, dword [ecx]
        jbe short .3
        mov dword [ecx], edx
.3:
        mov edx, eax
        mov eax, dword [byte eax+020h]
        jmp short GetMemStats.1
.4:
        mov eax, dword [esi]
        add eax, dword [ebx]
        mov edx, dword [esp]
        mov dword [edx], eax
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        ret
%endif ; C
;-----------------------------------------------------------------------------
; main_                                                10094  94G hockey94.asm
; Watcom main_ entry (called from the C runtime start); front-end entry like
; 94G Begin
;-----------------------------------------------------------------------------
; C: src/front/main/main_.c
%ifdef CBUILD
%include "c/front/main/main_.inc"
%else
main_:
        push dword 9Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push ebp
        sub esp, byte 70h
        lea eax, [byte esp+054h]
        call _dos_getdrive_
        cmp dword [byte esp+054h], byte 2
        je short .1
        mov eax, 3
        call DiskFreeBytes
        cmp eax, 800h
        jge short .1
        push str_NoDiskSpaceC
        call printf_
        add esp, byte 4
        xor eax, eax
        call exit_
.1:
        lea edx, [byte esp+04Ch]
        xor eax, eax
        call _dos_getdiskfree_
        test eax, eax
        je short .2
        push str_ErrDiskFree2
        call FatalError
        add esp, byte 4
.2:
        xor esi, esi
        mov si, word [byte esp+050h]
        xor ecx, ecx
        mov cx, word [byte esp+052h]
        mov edx, esi
        imul edx, ecx
        add edx, 3FFh
        mov eax, edx
        sar edx, 1Fh
        shl edx, 0Ah
        LD sbb, eax, edx
        sar eax, 0Ah
        mov ebx, eax
        lea edx, [byte eax+07h]
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        lea ebx, [byte eax+01h]
        xor eax, eax
        mov ax, word [byte esp+04Eh]
        cmp eax, ebx
        jge short .3
        mov edx, ebx
        imul edx, esi
        imul edx, ecx
        add edx, 3FFh
        mov eax, edx
        sar edx, 1Fh
        shl edx, 0Ah
        LD sbb, eax, edx
        sar eax, 0Ah
        push eax
        push str_NoDiskSpaceCur
        call printf_
        add esp, byte 8
        xor eax, eax
        call exit_
.3:
        mov word [byte esp+01Ch], 100h
        mov word [byte esp+020h], 0A000h
        mov ebx, esp
        lea edx, [byte esp+01Ch]
        mov eax, 31h
        call int386_
        xor eax, eax
        mov ax, word [byte esp+04h]
        mov esi, eax
        shl esi, 4
        push dword 19000h
        push dword 0C8h
        call SetupMemoryPoolReserve
        add esp, byte 8
        lea ecx, [byte esp+058h]
        lea ebx, [byte esp+05Ch]
        lea edx, [byte esp+060h]
        lea eax, [byte esp+064h]
        call GetMemStats
        cmp dword [byte esp+064h], 1E5D70h
        jae short .4
        push str_NoMemory
        call printf_
        add esp, byte 4
        push str_CheckRefCard
        call printf_
        add esp, byte 4
        xor eax, eax
        call exit_
.4:
        cmp dword [byte esp+064h], 200B20h
        jae short .5
        cmp esi, 7F800h
        jge short .5
        push str_NoConvMemory
        call printf_
        add esp, byte 4
        push str_CheckRefCard2
        call printf_
        add esp, byte 4
        xor eax, eax
        call exit_
.5:
        cmp dword [byte esp+064h], 3EF000h
        jbe short .6
        mov dword [dword_C4CFC], 0C3500h
        jmp short .7
.6:
        mov dword [dword_C4CFC], 30D40h
.7:
        push dword 1E0h
        push dword 280h
        call initgraphics
        add esp, byte 8
        call InstallTimer
        xor eax, eax
        mov dword [joysampling], eax
        db 068h                                 ; insn: push 0DCDh
        dd SampleInputTick
        call addtimer
        add esp, byte 4
        or byte [ctlavailmask], 8
        call InitMouse
        test eax, eax
        je short .8
        or byte [ctlavailmask], 1
.8:
        call InputInstall
        call dword [mousepollfn]
        push CritErrHandler
        call InstallBreakHandler
        add esp, byte 4
        call InitFileLocations
        mov edx, 0C8h
        mov eax, 140h
        call SetScreenSize
        push byte 20h
        push dword 140h
        push dword 0A8h
        push byte 0
        push BackBufferWidth
        call subwindowdefadr
        add esp, byte 14h
        mov dword [screenbm], eax
        mov edx, 1E0h
        mov eax, 280h
        call SetScreenSize
        mov eax, 64h
        call InitZoneManager
        xor ecx, ecx
        mov ebx, str_Pointer3
        cmp byte [fileoncd+013Ah], 1
        jne short .9
        mov edx, dword [cddriveptr]
        jmp short .10
.9:
        xor edx, edx
.10:
        lea eax, [byte esp+038h]
        call MakePath
        push byte 0
        lea eax, [byte esp+03Ch]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [pntrshapes], eax
        push str_Pntr
        push eax
        call FindShape
        add esp, byte 8
        mov dword [pointerspr], eax
        mov ecx, str_VFN
        mov ebx, str_S1
        cmp byte [fileoncd+0162h], 1
        jne short .11
        mov edx, dword [cddriveptr]
        jmp short .12
.11:
        xor edx, edx
.12:
        lea eax, [byte esp+038h]
        call MakePath
        push byte 20h
        lea eax, [byte esp+03Ch]
        push eax
        call OpenArtArchiveErr
        add esp, byte 8
        mov dword [s1font], eax
        mov dword [mainfont], eax
        mov ecx, str_VFN
        mov ebx, str_Scor2b
        cmp byte [fileoncd+0169h], 1
        jne short .13
        mov edx, dword [cddriveptr]
        jmp short .14
.13:
        xor edx, edx
.14:
        lea eax, [byte esp+038h]
        call MakePath
        push byte 20h
        lea eax, [byte esp+03Ch]
        push eax
        call OpenArtArchiveErr
        add esp, byte 8
        mov dword [scor2font], eax
        mov ecx, str_VFN
        mov ebx, str_Scor3b
        cmp byte [fileoncd+016Ah], 1
        jne short .15
        mov edx, dword [cddriveptr]
        jmp short .16
.15:
        xor edx, edx
.16:
        lea eax, [byte esp+038h]
        call MakePath
        push byte 20h
        lea eax, [byte esp+03Ch]
        push eax
        call OpenArtArchiveErr
        add esp, byte 8
        mov dword [scor3font], eax
        mov ecx, str_VFN
        mov ebx, str_Kaufm020
        cmp byte [fileoncd+01C4h], 1
        jne short .17
        mov edx, dword [cddriveptr]
        jmp short .18
.17:
        xor edx, edx
.18:
        lea eax, [byte esp+038h]
        call MakePath
        push byte 20h
        lea eax, [byte esp+03Ch]
        push eax
        call OpenArtArchiveErr
        add esp, byte 8
        mov dword [kaufmfont], eax
        mov edx, dword [s1font]
        push edx
        call TextSetFont
        add esp, byte 4
        mov eax, exhstate
        call LoadModeState
        call LoadNhlCfg
        call RunIntro
        call CalibrateJoystick
        mov dword [byte esp+054h], eax
        mov al, byte [JoyPortMask]
        and al, 0Fh
        cmp al, 0Fh
        sete al
        and eax, 0FFh
        inc eax
        push eax
        call JoyResetCentres
        add esp, byte 4
        test byte [JoyPortMask], 3
        je short .20
        cmp dword [JoyRawX1], byte 0
        jne short .19
        cmp dword [JoyRawY1], byte 0
        je short .20
.19:
        push str_ConfigureLeftJoystick
        push byte 0
        push byte 0
        push byte 1
        call JoystickCalScreen
        add esp, byte 10h
        test byte [joyenablemask], 1
        je short .20
        or byte [ctlavailmask], 2
        mov dword [joypresent], 1
.20:
        test byte [JoyPortMask], 0Ch
        je short .22
        cmp dword [JoyRawX2], byte 0
        jne short .21
        cmp dword [JoyRawY2], byte 0
        je short .22
.21:
        push str_ConfigureRightJoystick
        push byte 1
        push byte 8
        push byte 2
        call JoystickCalScreen
        add esp, byte 10h
        test byte [joyenablemask], 2
        je short .22
        or byte [ctlavailmask], 4
        mov dword [joypresent+4], 1
.22:
        lea edx, [byte esp+068h]
        mov eax, str_GameSet2
        call FileOpenRead
        test eax, eax
        jne short .24
        mov ecx, 75h
        mov ebx, 0FFFFFFFFh
        mov edx, exhstate
        mov eax, dword [byte esp+068h]
        call FileReadAt
        test eax, eax
        je short .23
        push str_errd3
        call FatalError
        add esp, byte 4
.23:
        lea eax, [byte esp+068h]
        call FileClose
        test eax, eax
        je near .32
        push str_errd4
        call FatalError
        add esp, byte 4
        jmp near .32
.24:
        mov dl, byte [ctlavailmask]
        test dl, 2
        je short .25
        mov dword [exhstate+65h], 2
        jmp short .29
.25:
        test dl, 4
        je short .26
        mov dword [exhstate+65h], 4
        jmp short .29
.26:
        test dl, 8
        je short .27
        mov dword [exhstate+65h], 8
        jmp short .29
.27:
        test dl, 1
        je short .28
        mov dword [exhstate+65h], 1
        jmp short .29
.28:
        mov dword [exhstate+65h], 10h
.29:
        mov ebp, 10h
        mov dword [exhstate+69h], ebp
        xor eax, eax
        mov dword [exhstate+6Dh], eax
        mov dword [exhstate+71h], 1
        cmp ebp, dword [exhstate+65h]
        je short .30
        mov dword [exhstate+5Dh], 0Ch
        jmp short .31
.30:
        mov dword [exhstate+5Dh], 0FFFFFFFFh
.31:
        mov dword [exhstate+61h], 0FFFFFFFEh
.32:
        mov eax, exhstate
        call LoadModeState
        call ShowLoadingScreen
        lea eax, [byte esp+06Ch]
        call _dos_gettime_
        xor eax, eax
        mov al, byte [byte esp+06Fh]
        call srand_
        call MainDeskLoop
        push byte 20h
        push dword 300h
        push str_Temp3
        call AllocMemBlock
        add esp, byte 0Ch
        mov esi, eax
        cmp byte [musicon], 0
        je short .33
        cmp dword [songdata], byte 0
        je short .33
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 3
        call SetDigiChannelVolume
.33:
        push esi
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, esi
        mov eax, 1
        call FadePalStep
        cmp byte [musicon], 0
        je short .35
        cmp dword [songdata], byte 0
        je short .35
.34:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short main_.34
        mov edx, dword [songdata]
        push edx
        call PushMemDescriptorLocked
        add esp, byte 4
        xor ebx, ebx
        mov dword [songdata], ebx
.35:
        call ShowLoadingScreen
        call InputInstall
        call ShowCredits
        call SetTextMode
        call dword [bailout_vec]
main_x:
        add esp, byte 70h
        pop ebp
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DiskFreeBytes                                                   106C8  95 PC
; _dos_getdiskfree_(drive) -> clusters * sectors * bytes; FatalError 'error
; getting disk space free' on failure (main_, CreateNewLeague,
; WriteModeState)
;-----------------------------------------------------------------------------
; C: src/front/main/DiskFreeBytes.c
%ifdef CBUILD
%include "c/front/main/DiskFreeBytes.inc"
%else
DiskFreeBytes:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        sub esp, byte 8
        mov edx, esp
        call _dos_getdiskfree_
        test eax, eax
        je short .1
        push str_ErrDiskFree3
        call FatalError
        add esp, byte 4
.1:
        xor edx, edx
        mov dx, word [byte esp+02h]
        xor eax, eax
        mov ax, word [byte esp+04h]
        imul edx, eax
        xor eax, eax
        mov ax, word [byte esp+06h]
        imul eax, edx
        add esp, byte 8
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SetupControllers                                                10712  95 PC
; From ctl1team/ctl2team and ctl1side/ctl2side sets cont1team/cont2team (0
; none, 1 home, 2 away) and the same-side flag, maps ctl1dev/ctl2dev to pad
; device codes (1 mouse, 2 joystick 1, 4 joystick 2, 8 keyboard, 10h -> 0
; none), recentres the mouse and stops input sampling; called before each
; game
;-----------------------------------------------------------------------------
; C: src/front/main/SetupControllers.c
%ifdef CBUILD
%include "c/front/main/SetupControllers.inc"
%else
SetupControllers:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push ebp
        cmp dword [ctl1team], byte 0
        jge short .1
        xor ecx, ecx
        mov word [cont1team], cx
        jmp short .3
.1:
        cmp dword [ctl1side], byte 0
        jne short .2
        mov word [cont1team], 1
        jmp short .3
.2:
        mov word [cont1team], 2
.3:
        cmp dword [ctl2team], byte 0
        jge short .4
        xor eax, eax
        mov word [cont2team], ax
        jmp short .6
.4:
        cmp dword [ctl2side], byte 0
        jne short .5
        mov word [cont2team], 1
        jmp short .6
.5:
        mov word [cont2team], 2
.6:
        mov eax, dword [ctl1side]
        cmp eax, dword [ctl2side]
        sete al
        and eax, 0FFh
        mov dword [samesideflag], eax
        mov eax, dword [ctl1dev]
        cmp eax, byte 4
        jb short .7
        cmp eax, byte 4
        jbe short .10
        cmp eax, byte 8
        jb short .13
        jbe short .11
        cmp eax, byte 10h
        je short .12
        jmp short .13
.7:
        cmp eax, byte 1
        jb short .13
        jbe short .8
        cmp eax, byte 2
        je short .9
        jmp short .13
.8:
        mov byte [pad1dev], 1
        jmp short .13
.9:
        mov byte [pad1dev], 2
        jmp short .13
.10:
        mov byte [pad1dev], 4
        jmp short .13
.11:
        mov byte [pad1dev], 8
        jmp short .13
.12:
        xor ah, ah
        mov byte [pad1dev], ah
.13:
        mov eax, dword [ctl2dev]
        cmp eax, byte 4
        jb short .14
        jbe short .17
        cmp eax, byte 8
        jb short .20
        jbe short .18
        cmp eax, byte 10h
        je short .19
        jmp short .20
.14:
        cmp eax, byte 1
        jb short .20
        jbe short .15
        cmp eax, byte 2
        je short .16
        jmp short .20
.15:
        mov byte [pad2dev], 1
        jmp short .20
.16:
        mov byte [pad2dev], 2
        jmp short .20
.17:
        mov byte [pad2dev], 4
        jmp short .20
.18:
        mov byte [pad2dev], 8
        jmp short .20
.19:
        xor cl, cl
        mov byte [pad2dev], cl
.20:
        call InitMouse
        push byte 64h
        push dword 0A0h
        call MouseSetPos
        add esp, byte 8
        call InstallKeyboardHandler
        xor ebp, ebp
        mov dword [joysampling], ebp
        pop ebp
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ReadKeyboardPad                                                 1086A  95 PC
; Keyboard pad: arrow / keypad scan codes (48h up, 50h down, 4Bh left, 4Dh
; right, 47h/49h/51h/4Fh diagonals) -> 4-bit mask -> direction via the table
; at C4D1F (8 = none); Ins/Alt/Enter/Space give buttons 10h, 20h or 40h
; (both)
;-----------------------------------------------------------------------------
ReadKeyboardPad:
        push ebx
        push ecx
        push edx
        sub esp, byte 4
        xor edx, edx
        mov dword [esp], edx
        push byte 48h
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .1
        mov dword [esp], 1
.1:
        push byte 50h
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .2
        or byte [esp], 2
.2:
        push byte 4Bh
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .3
        or byte [esp], 8
.3:
        push byte 4Dh
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .4
        or byte [esp], 4
.4:
        push byte 47h
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .5
        or byte [esp], 9
.5:
        push byte 49h
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .6
        or byte [esp], 5
.6:
        push byte 51h
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .7
        or byte [esp], 6
.7:
        push byte 4Fh
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .8
        or byte [esp], 0Ah
.8:
        mov eax, dword [esp]
        mov eax, dword [dword eax+keydirtab-3]
        sar eax, 18h
        mov dword [esp], eax
        push byte 52h
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .9
        push byte 1Ch
        call KeyDown
        add esp, byte 4
        test eax, eax
        jne short .10
.9:
        push byte 38h
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .11
        push byte 39h
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .11
.10:
        or byte [esp], 40h
        jmp short .15
.11:
        push byte 52h
        call KeyDown
        add esp, byte 4
        test eax, eax
        jne short .12
        push byte 38h
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .13
.12:
        or byte [esp], 10h
        jmp short .15
.13:
        push byte 1Ch
        call KeyDown
        add esp, byte 4
        test eax, eax
        jne short .14
        push byte 39h
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .15
.14:
        or byte [esp], 20h
.15:
        mov eax, dword [esp]
        add esp, byte 4
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; ReadJoyPad                                                      109A1  95 PC
; Joystick n pad: 8 (no input) when joystick n is not present
; (joypresent[n]), else the direction from the low/high byte of the sampled
; joystick bits (joyrawbits) through the same direction table, buttons 1/2 ->
; 10h/20h, both -> 40h
;-----------------------------------------------------------------------------
ReadJoyPad:
        push edx
        cmp dword [nosplit eax*4+joypresent], byte 0
        jne short .1
        mov eax, 8
        pop edx
        ret
.1:
        test eax, eax
        je short .2
        mov edx, dword [joyrawbits]
        sar edx, 8
        jmp short .3
.2:
        mov edx, dword [joyrawbits]
        and edx, 0FFh
.3:
        mov eax, edx
        and eax, byte 0Fh
        mov eax, dword [dword eax+keydirtab-3]
        sar eax, 18h
        test dl, 10h
        je short .4
        test dl, 20h
        je short .4
        or al, 40h
        pop edx
        ret
.4:
        test dl, 10h
        je short .5
        or al, 10h
        pop edx
        ret
.5:
        test dl, 20h
        je short .x
        or al, 20h
.x:
        pop edx
        ret
;-----------------------------------------------------------------------------
; ReadMousePad                                                    109FC  95 PC
; Mouse pad: polls the mouse (mousepollfn), direction from the offset to the
; screen centre (A0h,64h) through vtoa (none inside radius 50), mouse buttons
; 1/2 -> 10h/20h, both -> 40h
;-----------------------------------------------------------------------------
ReadMousePad:
        push ebx
        push ecx
        push edx
        call dword [mousepollfn]
        mov edx, dword [mousex]
        sub edx, 0A0h
        imul edx, edx
        mov eax, 64h
        sub eax, dword [mousey]
        imul eax, eax
        add eax, edx
        cmp eax, 9C4h
        jge short .1
        mov eax, 8
        jmp short .2
.1:
        mov eax, 64h
        sub ax, word [mousey]
        movsx edx, ax
        mov ax, word [mousex]
        db 081h,0E8h,0A0h,00h,00h,00h           ; insn: sub eax,0A0h
        cwde
        call vtoa
        cwde
.2:
        mov dl, byte [mousebtns]
        test dl, 1
        je short .3
        test dl, 2
        je short .3
        or al, 40h
        pop edx
        pop ecx
        pop ebx
        ret
.3:
        mov bl, byte [mousebtns]
        test bl, 1
        je short .4
        or al, 10h
        pop edx
        pop ecx
        pop ebx
        ret
.4:
        test bl, 2
        je short .x
        or al, 20h
.x:
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; ReadControllerPad                                               10A86  95 PC
; (controller, &out): dispatches on the controller's pad device code to
; ReadKeyboardPad / ReadJoyPad(0/1) / ReadMousePad, 8 (no input) for none
;-----------------------------------------------------------------------------
ReadControllerPad:
        push ebx
        mov bl, byte [dword eax+pad1dev]
        cmp bl, 8
        jne short .1
        call ReadKeyboardPad
        jmp short .3
.1:
        cmp bl, 2
        jne short .4
        xor eax, eax
.2:
        call ReadJoyPad
.3:
        mov byte [edx], al
        pop ebx
        ret
.4:
        cmp bl, 4
        jne short .5
        mov eax, 1
        jmp short ReadControllerPad.2
.5:
        cmp bl, 1
        jne short .6
        call ReadMousePad
        jmp short ReadControllerPad.3
.6:
        mov byte [edx], 8
        pop ebx
        ret
;-----------------------------------------------------------------------------
; ReadHotKeys                                                     10AC6  95 PC
; Game hot keys: Esc (1), Ctrl+S (1Fh), Ctrl+M (32h), F1-F10 (3Bh-44h), Tab
; (0Fh), R (13h); edge-triggered against the last key (lasthotkey), a new key
; is returned with bit 80h set
;-----------------------------------------------------------------------------
ReadHotKeys:
        push ebx
        push ecx
        push edx
        push esi
        sub esp, byte 4
        mov esi, eax
        xor ah, ah
        mov byte [esp], ah
        push byte 1
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .1
        mov byte [esp], 1
        jmp near .15
.1:
        push byte 1Dh
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .3
        push byte 1Fh
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .2
        mov byte [esp], 1Fh
        jmp near .15
.2:
        push byte 32h
        call KeyDown
        add esp, byte 4
        test eax, eax
        je near .15
        mov byte [esp], 32h
        jmp near .15
.3:
        push byte 3Bh
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .4
        mov byte [esp], 3Bh
        jmp near .15
.4:
        push byte 3Ch
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .5
        mov byte [esp], 3Ch
        jmp near .15
.5:
        push byte 3Dh
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .6
        mov byte [esp], 3Dh
        jmp near .15
.6:
        push byte 3Eh
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .7
        mov byte [esp], 3Eh
        jmp near .15
.7:
        push byte 3Fh
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .8
        mov byte [esp], 3Fh
        jmp near .15
.8:
        push byte 40h
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .9
        mov byte [esp], 40h
        jmp near .15
.9:
        push byte 41h
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .10
        mov byte [esp], 41h
        jmp near .15
.10:
        push byte 42h
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .11
        mov byte [esp], 42h
        jmp short .15
.11:
        push byte 43h
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .12
        mov byte [esp], 43h
        jmp short .15
.12:
        push byte 44h
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .13
        mov byte [esp], 44h
        jmp short .15
.13:
        push byte 0Fh
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .14
        mov byte [esp], 0Fh
        jmp short .15
.14:
        push byte 13h
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .15
        mov byte [esp], 13h
.15:
        cmp byte [lasthotkey], 0
        je short .17
        mov eax, dword [byte esp-03h]
        sar eax, 18h
        xor edx, edx
        mov dl, byte [lasthotkey]
        cmp eax, edx
        jne short .16
        xor dh, dh
        mov byte [esp], dh
        jmp short .18
.16:
        xor dl, dl
        mov byte [lasthotkey], dl
        jmp short .18
.17:
        mov al, byte [esp]
        mov byte [lasthotkey], al
.18:
        mov bl, byte [esp]
        test bl, bl
        je short .19
        mov bh, bl
        or bh, 80h
        mov byte [esp], bh
.19:
        mov al, byte [esp]
        mov byte [esi], al
        add esp, byte 4
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; ReadSkipKeys                                 10C7F  95 PC, medium confidence
; Hot-key reader used while demomode is set: Esc, Ins/Alt/Enter/Space or any
; joystick/mouse button give 81h (an Esc), or set pad bit 10h when gmode bit
; 10h; otherwise Ctrl+S / Ctrl+M / Tab, edge-triggered like ReadHotKeys
;-----------------------------------------------------------------------------
ReadSkipKeys:
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 4
        mov edi, eax
        mov esi, edx
        xor ah, ah
        mov byte [esp], ah
        mov byte [edi], ah
        push byte 1
        call KeyDown
        add esp, byte 4
        test eax, eax
        jne near .6
        push byte 52h
        call KeyDown
        add esp, byte 4
        test eax, eax
        jne short .1
        push byte 38h
        call KeyDown
        add esp, byte 4
        test eax, eax
        jne short .1
        push byte 1Ch
        call KeyDown
        add esp, byte 4
        test eax, eax
        jne short .1
        push byte 39h
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .3
.1:
        test byte [gmode], 10h
        je short .6
.2:
        or byte [esi], 10h
        jmp near .x
.3:
        mov dl, byte [ctlavailmask]
        test dl, 2
        jne short .4
        test dl, 4
        je short .8
.4:
        call ReadJoyRaw
        test al, 30h
        je short .7
.5:
        test byte [gmode], 10h
        jne short ReadSkipKeys.2
.6:
        mov byte [edi], 81h
        jmp near .x
.7:
        sar eax, 8
        test al, 30h
        jne short ReadSkipKeys.5
.8:
        test byte [ctlavailmask], 1
        je short .9
        call dword [mousepollfn]
        test byte [mousebtns], 3
        jne short ReadSkipKeys.5
.9:
        push byte 1Dh
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .11
        push byte 1Fh
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .10
        mov byte [esp], 1Fh
        jmp short .12
.10:
        push byte 32h
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .12
        mov byte [esp], 32h
        jmp short .12
.11:
        push byte 0Fh
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .12
        mov byte [esp], 0Fh
.12:
        cmp byte [lasthotkey], 0
        je short .14
        mov eax, dword [byte esp-03h]
        sar eax, 18h
        movzx esi, byte [lasthotkey]
        cmp eax, esi
        jne short .13
        xor dh, dh
        mov byte [esp], dh
        jmp short .15
.13:
        xor dl, dl
        mov byte [lasthotkey], dl
        jmp short .15
.14:
        mov al, byte [esp]
        mov byte [lasthotkey], al
.15:
        mov bl, byte [esp]
        test bl, bl
        je short .16
        mov bh, bl
        or bh, 80h
        mov byte [esp], bh
.16:
        mov al, byte [esp]
        mov byte [edi], al
.x:
        add esp, byte 4
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; SampleInputTick                                                 10DCD  95 PC
; Timer callback installed by main_ (addtimer): while joysampling, every 5th
; tick appends a 3-byte record (controller 1 pad, controller 2 pad, hot key)
; to the 50-entry joyqueue ring (joyqhead/joyqcount), reading the joysticks
; first when either controller uses one
;-----------------------------------------------------------------------------
SampleInputTick:
        push ebx
        push ecx
        push edx
        push esi
        cmp dword [joysampling], byte 0
        je near .x
        mov ebx, dword [inputticks]
        cmp ebx, 3E8h
        jge short .1
        lea ecx, [byte ebx+01h]
        mov dword [inputticks], ecx
.1:
        mov esi, dword [joyqtick]
        dec esi
        mov dword [joyqtick], esi
        cmp esi, byte 0FFFFFFFFh
        jne near .x
        mov dword [joyqtick], 4
        mov eax, dword [joyqcount]
        cmp eax, byte 32h
        jge near .x
        mov edx, dword [joyqhead]
        add edx, eax
        mov ebx, 32h
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov esi, edx
        test byte [pad1dev], 6
        jne short .2
        test byte [pad2dev], 6
        je short .3
.2:
        call ReadJoyRaw
        mov dword [joyrawbits], eax
.3:
        mov eax, esi
        mov ebx, esi
        shl ebx, 2
        sub ebx, esi
        add ebx, joyqueue
        mov edx, ebx
        xor eax, esi
        call ReadControllerPad
        lea edx, [byte ebx+01h]
        mov eax, 1
        call ReadControllerPad
        lea eax, [byte ebx+02h]
        cmp dword [demomode], byte 0
        je short .4
        mov edx, ebx
        call ReadSkipKeys
        jmp short .5
.4:
        call ReadHotKeys
.5:
        inc dword [joyqcount]
.x:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; SetScreenSize                                10E9F  95 PC, medium confidence
; (w, h): if different from the current size (screenw/C4E2C) blanks the
; palette, clears the screen, switches the video mode (initgraphics) and
; clears again; main_ uses 140h x C8h and 280h x 1E0h
;-----------------------------------------------------------------------------
; C: src/front/main/SetScreenSize.c
%ifdef CBUILD
%include "c/front/main/SetScreenSize.inc"
%else
SetScreenSize:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        mov esi, eax
        mov edi, edx
        cmp eax, dword [screenw]
        jne short .1
        cmp edi, dword [screenh]
        je near .x
.1:
        push blackpal
        push dword 100h
        push byte 0
        call VgaSetPalette
        add esp, byte 0Ch
        call SetScreenTarget
        mov ecx, dword [screenh]
        push ecx
        push byte 0
        mov ebp, dword [screenw]
        push ebp
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        push byte 0
        call ClearScreen
        add esp, byte 4
        push byte 28h
        call SetTickDeadline
        add esp, byte 4
        call WaitRetrace
        push edi
        push esi
        call initgraphics
        add esp, byte 8
        push blackpal
        push dword 100h
        push byte 0
        call VgaSetPalette
        add esp, byte 0Ch
        push edi
        push byte 0
        push esi
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        push byte 0
        call ClearScreen
        add esp, byte 4
        push edi
        push esi
        push byte 0
        push byte 0
        call SetViewRect
        add esp, byte 10h
        mov dword [screenw], esi
        mov dword [screenh], edi
        call WaitTickDeadline
.x:
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; IntermissionPC                                  10F6D  95 PC, low confidence
; Called from the period-end path after Intermission when gsp > 0: fades out
; (FadePalette), restores 640x480, stops crowd/music/digital sound and runs
; EnsureFreeMemory(222E0h) when SortPending is set, then IntermissionDesk and counts
; curperiod
;-----------------------------------------------------------------------------
; C: src/front/main/IntermissionPC.c
%ifdef CBUILD
%include "c/front/main/IntermissionPC.inc"
%else
IntermissionPC:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        mov eax, dword [exitgame-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        je short .3
        push savepal
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, savepal
        mov eax, 1
        call FadePalette
        mov edx, 1E0h
        mov eax, 280h
        call SetScreenSize
        call CrowdFadeOut
        cmp byte [musicon], 0
        je short .1
        call MusicChanReset
        jmp short .2
.1:
        call ReleaseAllVoices
.2:
        call StopDigiSample
        mov eax, 222E0h
        call EnsureFreeMemory
.3:
        mov edx, dword [s1font]
        push edx
        call TextSetFont
        add esp, byte 4
        call IntermissionDesk
        inc dword [curperiod]
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawSpriteNumber                             11005  95 PC, medium confidence
; Draws a 1- or 2-digit number with the digit sprites numshapes[0..9]
; (DrawSprite), plus a suffix sprite from gfxidlist when cx > 0; x mirrored
; from 140h
;-----------------------------------------------------------------------------
; C: src/front/main/DrawSpriteNumber.c
%ifdef CBUILD
%include "c/front/main/DrawSpriteNumber.inc"
%else
DrawSpriteNumber:
        push dword 1Ch
        call __CHK
        push esi
        push edi
        sub esp, byte 8
        mov esi, eax
        mov word [byte esp+04h], cx
        mov eax, ebx
        add esi, 0C0h
        mov edi, 140h
        sub edi, edx
        mov edx, edi
        add edx, byte 0Dh
        mov word [esp], dx
        test cx, cx
        jle short .1
        sub esi, byte 4
.1:
        cmp word [byte esp+04h], byte 0
        jl short .2
        add word [esp], byte 2
.2:
        cmp bx, byte 0Ah
        jl short .3
        movsx edi, bx
        mov ebx, 0Ah
        mov eax, edi
        mov edx, edi
        sar edx, 1Fh
        idiv ebx
        push byte 0
        push byte 0
        mov ebx, dword [byte esp+06h]
        sar ebx, 10h
        sub esi, byte 3
        movsx edx, si
        cwde
        mov eax, dword [nosplit eax*4+numshapes]
        xor ecx, ecx
        call DrawSprite
        mov ebx, 0Ah
        mov eax, edi
        mov edx, edi
        sar edx, 1Fh
        idiv ebx
        mov eax, edx
        add esi, byte 7
.3:
        push byte 0
        push byte 0
        mov edi, dword [byte esp+06h]
        sar edi, 10h
        movsx edx, si
        cwde
        mov eax, dword [nosplit eax*4+numshapes]
        xor ecx, ecx
        mov ebx, edi
        call DrawSprite
        cmp word [byte esp+04h], byte 0
        jle short .x
        push byte 0
        push byte 0
        add esi, byte 8
        movsx edx, si
        mov eax, dword [byte esp+0Ah]
        sar eax, 10h
        mov eax, dword [nosplit eax*4+gfxidlist]
        xor ecx, ecx
        mov ebx, edi
        call DrawSprite
.x:
        add esp, byte 8
        pop edi
        pop esi
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawFrameSprite                              110E0  95 PC, medium confidence
; Draws sprite index ax (< 46Eh, non-null in photoptrs) through DrawSprite at
; a position mirrored from 140h
;-----------------------------------------------------------------------------
; C: src/front/main/DrawFrameSprite.c
%ifdef CBUILD
%include "c/front/main/DrawFrameSprite.inc"
%else
DrawFrameSprite:
        push dword 10h
        call __CHK
        push esi
        test ax, ax
        jl short .x
        cmp ax, 46Eh
        jge short .x
        cwde
        shl eax, 2
        cmp dword [dword eax+photoptrs], byte 0
        je short .x
        mov esi, edx
        add esi, 0C0h
        mov edx, 140h
        sub edx, ebx
        mov ebx, edx
        push byte 1
        mov edx, dword [byte esp+0Ah]
        sar edx, 10h
        push edx
        movsx ecx, cx
        movsx ebx, bx
        movsx edx, si
        mov eax, dword [dword eax+photoptrs]
        call DrawSprite
.x:
        pop esi
        ret 4
%endif ; C
;-----------------------------------------------------------------------------
; DrawRinkEndArt                                                  11136  95 PC
; Draws rinkendart (frame '0000' of the 'trinknd' rink-end art loaded in
; asset_loading) at 37h,225h; the game display calls it when camx < -90h
;-----------------------------------------------------------------------------
; C: src/front/main/DrawRinkEndArt.c
%ifdef CBUILD
%include "c/front/main/DrawRinkEndArt.inc"
%else
DrawRinkEndArt:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push byte 0
        push byte 0FFFFFFFFh
        mov eax, dword [rinkendart]
        xor ecx, ecx
        mov ebx, 225h
        mov edx, 37h
        call DrawSprite
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; WaitKeyRelease                                                  11161  95 PC
; Waits (PollKey) until scan code eax is no longer down, then flushes the key
; buffer (KbdFlush)
;-----------------------------------------------------------------------------
; C: src/front/main/WaitKeyRelease.c
%ifdef CBUILD
%include "c/front/main/WaitKeyRelease.inc"
%else
WaitKeyRelease:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov esi, eax
.1:
        push esi
        call KeyDown
        add esp, byte 4
        test eax, eax
        je short .2
        call PollKey
        jmp short WaitKeyRelease.1
.2:
        call KbdFlush
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; HandleHotKey                                                    1118F  95 PC
; Acts on a ReadHotKeys code: F1-F4 line-change request (lcrequest /
; lcreqchoice), F5-F8 request word_E0306 / word_E0382, F9 / F10
; ShowGoalieBanner(0/1), Tab toggles shownumbers, R opens the in-game menu
; (InstantReplay) with sound stopped and resumes, Ctrl+M toggles music
; (gameopts bit 6), Ctrl+S toggles sound effects (bit 7), Esc sets the quit
; request and returns 1
;-----------------------------------------------------------------------------
; C: src/front/main/HandleHotKey.c
%ifdef CBUILD
%include "c/front/main/HandleHotKey.inc"
%else
HandleHotKey:
        push dword 2Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        test al, 80h
        je near .19
        and al, 7Fh
        mov ah, al
        cmp al, 32h
        jb short .2
        jbe near .17
        cmp al, 3Fh
        jb short .1
        cmp al, 42h
        jbe short .5
        cmp al, 43h
        jbe near .6
        cmp al, 44h
        je near .8
        jmp near .19
.1:
        cmp al, 3Bh
        jb near .19
        jmp short .4
.2:
        cmp al, 0Fh
        jb short .3
        jbe short .9
        cmp al, 13h
        jb near .19
        jbe short .10
        cmp al, 1Fh
        je near HandleHotKey_ret.20
        jmp near .19
.3:
        cmp al, 1
        je near HandleHotKey_ret.24
        jmp near .19
.4:
        mov word [lcrequest], 1
        xor ah, ah
        sub eax, byte 3Bh
        mov word [lcreqchoice], ax
        jmp near .19
.5:
        mov word [lcrequest+2], 1
        xor ah, ah
        sub eax, byte 3Fh
        mov word [lcreqchoice+2], ax
        jmp near .19
.6:
        xor eax, eax
.7:
        call ShowGoalieBanner
        jmp near .19
.8:
        mov eax, 1
        jmp short HandleHotKey.7
.9:
        cmp dword [shownumbers], byte 0
        sete al
        and eax, 0FFh
        mov dword [shownumbers], eax
        jmp near .19
.10:
        test byte [gmode], 10h
        jne near .19
        cmp dword [curperiod], byte 0FFFFFFFFh
        je near .19
        mov ax, word [joysampling]
        mov word [joysampling_save], ax
        xor esi, esi
        mov dword [joysampling], esi
        cmp byte [pad1dev], 1
        je short .11
        cmp byte [pad2dev], 1
        jne short .12
.11:
        mov eax, dword [mousex]
        mov dword [savedmousex], eax
        mov eax, dword [mousey]
        mov dword [savedmousey], eax
.12:
        push savepal
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, savepal
        mov eax, 1
        call FadePalette
        call CrowdFadeOut
        cmp byte [musicon], 0
        je short .13
        call MusicChanReset
        jmp short .14
.13:
        call ReleaseAllVoices
.14:
        call SpeechStopQueue
        call StopDigiSample
        call InputInstall
        mov eax, 1
        call InstantReplay
        call ClearInputQueue
        call InputRemove
        cmp byte [pad1dev], 1
        je short .15
        cmp byte [pad2dev], 1
        jne short .16
.15:
        mov edi, dword [savedmousey]
        push edi
        mov ebp, dword [savedmousex]
        push ebp
        call MouseSetPos
        add esp, byte 8
        push dword 0C8h
        push dword 140h
        push byte 0
        push byte 0
        call SetViewRect
        add esp, byte 10h
.16:
        mov word [fadeinpending], 1
        mov ebx, dword [curperiod]
        mov edx, dword [VisTeam-2]
        sar edx, 10h
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        xor ecx, ecx
        call DrawHudPanel
        mov eax, dword [joysampling_save-2]
        sar eax, 10h
        mov dword [joysampling], eax
        mov eax, 1
        add dword [rinkscrollx], 3E8h
        add dword [rinkscrolly], 3E8h
        jmp near HandleHotKey_ret
.17:
        test byte [gameopts], 40h
        sete al
        and eax, byte 1
        and byte [gameopts], 0BFh
        shl eax, 6
        or dword [gameopts], eax
        test byte [gameopts], 40h
        je short .18
        call EnableMidiMusic
        jmp near .19
.18:
        call StopDigiSample
        call DisableMidiMusic
.19:
        xor eax, eax
HandleHotKey_ret:
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.20:
        test byte [gameopts], 80h
        je short .23
        call CrowdNoiseOff
        cmp byte [musicon], 0
        je short .21
        call MusicChanReset
        jmp short .22
.21:
        call ReleaseAllVoices
.22:
        call DisableMidiSfx
.23:
        mov cl, byte [gameopts]
        test cl, 80h
        sete al
        and eax, byte 1
        mov ch, cl
        and ch, 7Fh
        mov byte [gameopts], ch
        shl eax, 7
        or dword [gameopts], eax
        test byte [gameopts], 80h
        je short HandleHotKey.19
        call CrowdNoiseReset
        call EnableMidiSfx
        jmp short HandleHotKey.19
.24:
        mov esi, 1
        mov dword [escrequest], esi
        mov eax, esi
        jmp short HandleHotKey_ret
%endif ; C
;-----------------------------------------------------------------------------
; ResetInputSampling                           1145F  95 PC, medium confidence
; Pauses sampling (joysampling_save), clears the tick counter inputticks and
; restores joysampling from SpeechPatchNext
;-----------------------------------------------------------------------------
; C: src/front/main/ResetInputSampling.c
%ifdef CBUILD
%include "c/front/main/ResetInputSampling.inc"
%else
ResetInputSampling:
        push dword 8
        call __CHK
        push edx
        mov ax, word [joysampling]
        mov word [joysampling_save], ax
        xor edx, edx
        mov dword [joysampling], edx
        mov eax, dword [inputticks]
        mov dword [inputticks], edx
        mov edx, dword [joysampling_save-2]
        sar edx, 10h
        mov dword [joysampling], edx
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; RunGameFrames                                                   1149A  95 PC
; Runs up to eax game frames: takes the next joyqueue record (each lasts 3
; frames), handles hot keys (HandleHotKey; Esc flushes the queue and
; returns), ClockTick unless gmode bit 0, DoGameFrame, stops on deferpending
; / exitgame / gameover
;-----------------------------------------------------------------------------
; C: src/front/main/RunGameFrames.c
%ifdef CBUILD
%include "c/front/main/RunGameFrames.inc"
%else
RunGameFrames:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        mov ebx, eax
        xor edx, edx
        jmp near .7
.1:
        cmp dword [inputframes], byte 0
        jne short .3
        call joyq_peek
        mov dword [joyrec], eax
        test eax, eax
        je near .x
        mov al, byte [byte eax+02h]
        test al, 80h
        je short .2
        and eax, 0FFh
        call HandleHotKey
        cmp eax, byte 1
        jne short .2
        call joyq_flush
        pop edx
        pop ebx
        ret
.2:
        mov dword [inputframes], 3
.3:
        test byte [gmode], 1
        jne short .5
        cmp dword [penshotlive], byte 0
        jne short .4
        add dword [hudhundaccum], byte 64h
.4:
        call ClockTick
.5:
        call DoGameFrame
        mov eax, dword [inputframes]
        dec eax
        mov dword [inputframes], eax
        jne short .6
        call joyq_pop
.6:
        cmp dword [deferpending], byte 0
        jne short .x
        cmp word [exitgame], byte 0
        jne short .x
        cmp word [gameover], byte 0
        jne short .x
        inc edx
.7:
        cmp edx, ebx
        jl near RunGameFrames.1
.x:
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SetFullPalette                               11550  95 PC, medium confidence
; Sets all 256 palette entries in two 128-colour blocks, waiting (WaitRetraceEnd)
; before each
;-----------------------------------------------------------------------------
; C: src/front/main/HandleHotKey.c (SetFullPalette)
%ifdef CBUILD
%include "c/front/main/HandleHotKey.SetFullPalette.inc"
%else
SetFullPalette:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov ebp, eax
        xor esi, esi
        xor edi, edi
        jmp short .2
.1:
        call WaitRetraceEnd
        lea eax, [edi+ebp]
        push eax
        push dword 80h
        push esi
        call VgaSetPalette
        add esp, byte 0Ch
        add esi, 80h
        add edi, 180h
.2:
        cmp esi, 100h
        jl short SetFullPalette.1
        jmp near HandleHotKey_ret
%endif ; C
;-----------------------------------------------------------------------------
; FadePalette                                  11598  95 PC, medium confidence
; (in, palette, steps): fades the 256-colour palette in from black or out to
; black in `steps` steps through fadepalbuf, or sets it at once when steps <
; 2; remembers the faded-in state in palfadedin
;-----------------------------------------------------------------------------
FadePalette:
        push dword 18h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov edi, eax
        mov esi, edx
        mov dword [esp], ebx
        test eax, eax
        je short .4
        cmp dword [palfadedin], byte 0
        je short .3
        mov ecx, dword [esp]
        cmp ecx, byte 2
        jle short .1
        mov eax, 2
        jmp short .2
.1:
        mov eax, ecx
.2:
        mov dword [esp], eax
.3:
        mov dword [palfadedin], 1
        jmp short .5
.4:
        mov dword [palfadedin], eax
.5:
        cmp dword [esp], byte 2
        jge short .8
        test edi, edi
        jne short .7
        mov eax, esi
.6:
        call SetFullPalette
        jmp near .x
.7:
        mov ecx, 300h
        xor edx, edx
        mov eax, fadepalbuf
        call __STOSB
        mov eax, fadepalbuf
        jmp short FadePalette.6
.8:
        mov al, byte [esp]
        dec al
        mov byte [fadestart_e1], al
        mov al, byte [esp]
        inc al
        mov byte [fadeendlvl], al
        mov ecx, dword [dword edi+fadestart_m3]
        sar ecx, 18h
        mov ebp, dword [esp]
        jmp short .11
.9:
        xor ebx, ebx
.10:
        movsx edx, byte [esi+ebx]
        imul edx, ecx
        mov eax, edx
        sar edx, 1Fh
        idiv ebp
        mov byte [dword ebx+fadepalbuf], al
        inc ebx
        cmp ebx, 300h
        jl short FadePalette.10
        mov eax, fadepalbuf
        call SetFullPalette
        mov eax, dword [dword edi+fadestep_m3]
        sar eax, 18h
        add ecx, eax
.11:
        mov eax, dword [dword edi+fadeendlvl-3]
        sar eax, 18h
        cmp ecx, eax
        jne short FadePalette.9
.x:
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
;-----------------------------------------------------------------------------
; Gameloop                          1167B  94G hockey94.asm, medium confidence
; Role match: the in-game loop (94G Gameloop); PC converts timer ticks to
; frames
;-----------------------------------------------------------------------------
Gameloop:
        push dword 48h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 20h
        call TicksSinceLastCall
.1:
        mov dword [joysampling], 1
        cmp word [gameover], byte 0
        jne near .29
.2:
        cmp word [exitgame], byte 0
        jne near .24
        call ResetInputSampling
        mov edx, eax
        shl eax, 2
        sub eax, edx
        add eax, eax
        mov ebp, dword [frameaccum]
        add ebp, eax
        mov dword [frameaccum], ebp
        mov ebx, 0Ah
        mov eax, ebp
        mov edx, ebp
        sar edx, 1Fh
        idiv ebx
        mov esi, eax
        mov eax, ebp
        mov edx, ebp
        sar edx, 1Fh
        idiv ebx
        mov dword [frameaccum], edx
        mov eax, esi
        call RunGameFrames
        mov eax, dword [camx-2]
        sar eax, 10h
        add eax, byte 20h
        mov dword [viewscrollx], eax
        mov eax, dword [camy-2]
        sar eax, 10h
        mov edx, 140h
        sub edx, eax
        lea eax, [byte edx-054h]
        mov dword [viewscrolly], eax
        mov eax, dword [viewscrollx]
        cmp eax, byte 40h
        jle short .3
        mov dword [viewscrollx], 40h
        jmp short .4
.3:
        test eax, eax
        jge short .4
        xor ebx, ebx
        mov dword [viewscrollx], ebx
.4:
        mov edi, dword [viewscrolly]
        cmp edi, 1A8h
        jle short .5
        mov dword [viewscrolly], 1A8h
        jmp short .6
.5:
        test edi, edi
        jge short .6
        xor eax, eax
        mov dword [viewscrolly], eax
.6:
        xor edx, edx
        xor eax, eax
        call SetZoneOrigin
        call BeginZoneFrame
        mov edx, dword [viewscrolly]
        mov eax, dword [viewscrollx]
        call SetRinkScroll
        mov eax, dword [bgscrolly-2]
        sar eax, 10h
        shl eax, 3
        mov edx, dword [scrolly-2]
        sar edx, 10h
        add edx, eax
        lea ecx, [dword edx+0A8h]
        mov ebx, dword [bgscrollx-2]
        sar ebx, 10h
        shl ebx, 3
        mov eax, dword [scrollx-2]
        sar eax, 10h
        add eax, ebx
        lea ebx, [dword eax+0140h]
        call SetZoneScreen
        xor ebx, ebx
        mov dword [spritedrawcount], ebx
        mov edx, dword [viewscrolly-2]
        sar edx, 10h
        mov eax, dword [viewscrollx-2]
        sar eax, 10h
        call DrawRinkOverlays
        cmp word [fadeinpending], byte 0
        je short .7
        mov ax, word [joysampling]
        mov word [joysampling_save], ax
        mov dword [joysampling], ebx
        push savepal
        push dword 100h
        push ebx
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, savepal
        mov eax, 1
        call FadePalette
        call FlushGSumQueue
        mov eax, dword [joysampling_save-2]
        sar eax, 10h
        mov dword [joysampling], eax
.7:
        movsx eax, si
        call Crowd_Noise
        cmp dword [penshotlive], byte 0
        je short .8
        xor edi, edi
        mov dword [hudhundstep], edi
        jmp near .9
.8:
        mov edx, dword [hudhundaccum]
        mov ebx, 18h
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov dword [hudhundstep], eax
        mov eax, dword [hudhundaccum]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        mov dword [hudhundaccum], edx
        cmp word [exitgame], byte 0
        je short .9
        mov edx, dword [gameclock-2]
        sar edx, 10h
        mov eax, dword [clockticks-2]
        sar eax, 10h
        or eax, edx
        jne short .9
        mov edx, dword [hudclockmin]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        shl eax, 2
        mov edx, dword [hudclocksec]
        add edx, eax
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add eax, edx
        shl eax, 2
        mov edx, dword [hudclockhund]
        add eax, edx
        mov dword [hudhundstep], eax
.9:
        call UpdateHudPanel
        mov edx, dword [bgscrolly-2]
        sar edx, 10h
        shl edx, 3
        mov eax, dword [scrolly-2]
        sar eax, 10h
        add edx, eax
        neg edx
        mov ebx, dword [bgscrollx-2]
        sar ebx, 10h
        shl ebx, 3
        mov eax, dword [scrollx-2]
        sar eax, 10h
        add eax, ebx
        neg eax
        call SetZoneOrigin
        call FlushZones
        cmp word [fadeinpending], byte 0
        je short .10
        mov ax, word [joysampling]
        mov word [joysampling_save], ax
        xor ebp, ebp
        mov dword [joysampling], ebp
        mov ebx, 10h
        mov edx, gamepal
        xor eax, eax
        call FadePalette
        xor esi, esi
        mov word [fadeinpending], si
        mov eax, dword [joysampling_save-2]
        sar eax, 10h
        mov dword [joysampling], eax
.10:
        cmp dword [escrequest], byte 0
        je near .23
        mov edx, dword [demomode]
        test edx, edx
        je short .11
        mov ebx, 10h
        mov edx, gamepal
        mov eax, 1
        call FadePalette
        mov dword [gameresult], 2
        jmp near .30
.11:
        mov ax, word [joysampling]
        mov word [joysampling_save], ax
        mov dword [joysampling], edx
        cmp byte [pad1dev], 1
        je short .12
        cmp byte [pad2dev], 1
        jne short .13
.12:
        mov eax, dword [mousex]
        mov dword [savedmousex], eax
        mov eax, dword [mousey]
        mov dword [savedmousey], eax
.13:
        call CrowdFadeOut
        cmp byte [musicon], 0
        je short .14
        call MusicChanReset
        jmp short .15
.14:
        call ReleaseAllVoices
.15:
        call StopDigiSample
        call SpeechStopQueue
        call FlushGSumQueue
        mov ecx, dword [s1font]
        push ecx
        call TextSetFont
        add esp, byte 4
        push savepal
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, savepal
        mov eax, 1
        call FadePalette
        mov edx, 1E0h
        mov eax, 280h
        call SetScreenSize
        xor eax, eax
        call SportsDesk
        cmp dword [gameresult], byte 2
        je near .30
        mov edx, 0C8h
        mov eax, 140h
        call SetScreenSize
        cmp byte [pad1dev], 1
        je short .16
        cmp byte [pad2dev], 1
        jne short .17
.16:
        mov edi, dword [savedmousey]
        push edi
        mov ebp, dword [savedmousex]
        push ebp
        call MouseSetPos
        add esp, byte 8
.17:
        mov word [fadeinpending], 1
        xor eax, eax
        mov dword [escrequest], eax
        mov eax, dword [VisTeam-2]
        sar eax, 10h
        mov edx, dword [nosplit eax*4+teamabbrevs]
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        mov eax, dword [nosplit eax*4+teamabbrevs]
        call PaPreloadClips
        mov ebx, dword [curperiod]
        mov edx, dword [VisTeam-2]
        sar edx, 10h
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        xor ecx, ecx
        call DrawHudPanel
        mov eax, dword [ovlseq-2]
        sar eax, 10h
        add dword [rinkscrollx], 3E8h
        add dword [rinkscrolly], 3E8h
        cmp eax, byte 0FFFFFFFFh
        je near .22
        mov edx, dword [ovlstep-2]
        sar edx, 10h
        cmp edx, byte 0FFFFFFFFh
        je near .22
        cmp dword [ovlartbank], byte 0
        jne near .22
        mov ecx, str_PPV
        mov ebx, dword [nosplit eax*4+ovlartnames]
        mov eax, dword [nosplit eax*4+ovlartfiles]
        cmp byte [dword eax+fileoncd], 1
        jne short .18
        mov edx, dword [cddriveptr]
        jmp short .19
.18:
        xor edx, edx
.19:
        mov eax, esp
        call MakePath
        push byte 20h
        lea eax, [byte esp+04h]
        push eax
        call OpenArtArchiveErr
        add esp, byte 8
        mov dword [ovlartbank], eax
        xor esi, esi
        jmp short .21
.20:
        push esi
        mov ebp, dword [ovlartbank]
        push ebp
        call ShapeBankEntry
        add esp, byte 8
        mov dword [nosplit esi*4+ovlstepart], eax
        inc esi
.21:
        mov edi, dword [ovlartbank]
        push edi
        call ShapeBankCount
        add esp, byte 4
        cmp esi, eax
        jl short Gameloop.20
.22:
        mov eax, dword [joysampling_save-2]
        sar eax, 10h
        mov dword [joysampling], eax
        call joyq_flush
.23:
        cmp dword [deferpending], byte 0
        je near Gameloop.2
        mov ax, word [joysampling]
        mov word [joysampling_save], ax
        xor edx, edx
        mov dword [joysampling], edx
        call RunDeferredCalls
        mov dword [deferpending], edx
        mov eax, dword [joysampling_save-2]
        sar eax, 10h
        mov dword [joysampling], eax
        call joyq_flush
        jmp near Gameloop.2
.24:
        xor esi, esi
        mov dword [joysampling], esi
        cmp dword [demomode], byte 0
        je short .25
        mov ebx, 10h
        mov edx, gamepal
        mov eax, 1
        call FadePalette
        mov dword [gameresult], 1
        jmp near .30
.25:
        call PeriodOver
        cmp dword [gameresult], byte 2
        je near .30
        cmp word [gameover], byte 0
        jne short .26
        call SelectScreenBM
        mov edx, dword [VisTeam-2]
        sar edx, 10h
        mov edx, dword [nosplit edx*4+teamabbrevs]
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        mov eax, dword [nosplit eax*4+teamabbrevs]
        call PaPreloadClips
        mov ebx, dword [curperiod]
        mov edx, dword [VisTeam-2]
        sar edx, 10h
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        mov ecx, 1
        call DrawHudPanel
        xor eax, eax
        call PlayCrowdSample
.26:
        cmp byte [pad1dev], 1
        je short .27
        cmp byte [pad2dev], 1
        jne short .28
.27:
        push byte 64h
        push dword 0A0h
        call MouseSetPos
        add esp, byte 8
.28:
        xor esi, esi
        mov word [lcrequest+2], si
        mov word [lcrequest], si
        xor eax, eax
        mov dword [deferpending], eax
        xor edx, edx
        mov dword [inputframes], eax
        xor eax, eax
        mov word [exitgame], ax
        xor ebx, ebx
        mov dword [frameaccum], ebx
        mov dword [hudhundaccum], edx
        call joyq_flush
        jmp near Gameloop.1
.29:
        xor ebx, ebx
        mov dword [joysampling], ebx
        call FlushGSumQueue
        call StartThreeStars
        call PostGameDesk
        mov dword [gameresult], 1
.30:
        call FreeGameMemory
        add esp, byte 20h
        jmp near HandleHotKey_ret
;-----------------------------------------------------------------------------
; PlayGame                                                        11D09  95 PC
; (&savefile): without an open saved game runs the pre-game screens
; (LoadRockMusic, LoadGameGfx, SetupGame; gameresult 2 on cancel), otherwise
; LoadGameState from the file, rebuilds lines (SetupTeamLines) and resumes;
; then GameLoop; in league / Play-Off mode a completed game (gameresult 1)
; deletes <league>\game.sav; called from temp_files, import_export and
; PlayoffModeLoop
;-----------------------------------------------------------------------------
; C: src/front/main/HandleHotKey.c (PlayGame)
%ifdef CBUILD
%include "c/front/main/HandleHotKey.PlayGame.inc"
%else
PlayGame:
        push dword 64h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 40h
        mov edx, eax
        cmp dword [eax], byte 0
        jge near .4
        call LoadRockMusic
        call LoadGameGfx
        mov edx, dword [VisTeam-2]
        sar edx, 10h
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        mov ebx, gamepal
        call LoadTeamPalette
        call FadeOutPalCycle
        mov edx, 0C8h
        mov eax, 140h
        call SetScreenSize
        cmp word [HomeTeam], byte 1Ah
        jl short .1
        mov eax, 0Ch
        jmp short .2
.1:
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
.2:
        call LoadRink
        xor esi, esi
        mov dword [rinkscrolly], esi
        mov dword [rinkscrollx], esi
        call SetupGame
        test eax, eax
        jge short .3
        mov dword [gameresult], 2
        call FreeGameMemory
        call SetScreenTarget
        jmp near .15
.3:
        call SetupGoalieMenu
        jmp near .14
.4:
        test byte [gameopts+1], 2
        jne short .5
        call LoadCupFinalSeries
.5:
        mov eax, dword [edx]
        call LoadGameState
        mov eax, edx
        call FileClose
        mov dword [edx], 0FFFFFFFFh
        call BuildDefaultLines
        call NormalizeDressFlags
        xor eax, eax
        call SetupTeamLines
        mov eax, 1
        call SetupTeamLines
        call MakeGSummaryPath
        call CrowdNoiseReset
        call SetupGoalieMenu
        mov eax, dword [exitgame-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        je near .14
        call FadeOutPalCycle
        xor ecx, ecx
        mov dword [gameresult], ecx
        xor eax, eax
        call SportsDesk
        cmp dword [gameresult], byte 2
        jne short .6
        call FreeGameMemory
        jmp near .16
.6:
        mov edx, 0C8h
        mov eax, 140h
        call SetScreenSize
        cmp byte [pad1dev], 1
        je short .7
        cmp byte [pad2dev], 1
        jne short .8
.7:
        mov edi, dword [savedmousey]
        push edi
        mov ebp, dword [savedmousex]
        push ebp
        call MouseSetPos
        add esp, byte 8
.8:
        mov word [fadeinpending], 1
        xor eax, eax
        mov dword [escrequest], eax
        mov ebx, dword [curperiod]
        mov edx, dword [VisTeam-2]
        sar edx, 10h
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        xor ecx, ecx
        call DrawHudPanel
        mov eax, dword [ovlseq-2]
        sar eax, 10h
        add dword [rinkscrollx], 3E8h
        add dword [rinkscrolly], 3E8h
        cmp eax, byte 0FFFFFFFFh
        je near .13
        mov edx, dword [ovlstep-2]
        sar edx, 10h
        cmp edx, byte 0FFFFFFFFh
        je near .13
        cmp dword [ovlartbank], byte 0
        jne short .13
        mov ecx, str_PPV
        mov ebx, dword [nosplit eax*4+ovlartnames]
        mov eax, dword [nosplit eax*4+ovlartfiles]
        cmp byte [dword eax+fileoncd], 1
        jne short .9
        mov edx, dword [cddriveptr]
        jmp short .10
.9:
        xor edx, edx
.10:
        mov eax, esp
        call MakePath
        push byte 20h
        lea eax, [byte esp+04h]
        push eax
        call OpenArtArchiveErr
        add esp, byte 8
        mov dword [ovlartbank], eax
        xor esi, esi
        jmp short .12
.11:
        push esi
        mov edx, dword [ovlartbank]
        push edx
        call ShapeBankEntry
        add esp, byte 8
        mov dword [nosplit esi*4+ovlstepart], eax
        inc esi
.12:
        mov eax, dword [ovlartbank]
        push eax
        call ShapeBankCount
        add esp, byte 4
        cmp esi, eax
        jl short PlayGame.11
.13:
        mov edx, dword [VisTeam-2]
        sar edx, 10h
        mov edx, dword [nosplit edx*4+teamabbrevs]
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        mov eax, dword [nosplit eax*4+teamabbrevs]
        call PaPreloadClips
.14:
        xor ebx, ebx
        mov dword [introskipped], ebx
        mov dword [gameresult], ebx
        call joyq_flush
        call Gameloop
        call ResetGoalieMenu
        cmp dword [gamemode], byte 0
        je short .15
        cmp dword [gameresult], byte 1
        jne short .15
        and byte [gameopts+1], 7Fh
        mov edx, curleague
        lea eax, [byte esp+020h]
        call strcpy_
        mov edx, str_backslash
        lea eax, [byte esp+020h]
        call strcat_
        mov edx, str_GameSav2
        lea eax, [byte esp+020h]
        call strcat_
        lea eax, [byte esp+020h]
        call j_unlink_
.15:
        mov edx, 1E0h
        mov eax, 280h
        call SetScreenSize
.16:
        add esp, byte 40h
        jmp near HandleHotKey_ret
%endif ; C
;-----------------------------------------------------------------------------
; assreplace                         11FF4  94G logic94.asm, medium confidence
; Replace player p's current assignment (asslist[assnum]) with a and set pfna
; so it starts on the next update.
;-----------------------------------------------------------------------------
; C: src/front/main/assreplace.c
%ifdef CBUILD
%include "c/front/main/assreplace.inc"
%else
assreplace:
        push dword 8
        call __CHK
        push ebx
        mov ebx, edx
        mov edx, dword [byte eax+01Ah]
        sar edx, 10h
        mov byte [byte edx+eax+01Eh], bl
        or byte [byte eax+044h], 2
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assinsert                                             12011  94G logic94.asm
; Push assignment a on player p's 8-entry assignment ring (assnum - 1, mod
; 8), so the current one resumes when a ends; then assreplace.
;-----------------------------------------------------------------------------
; C: src/front/main/assinsert.c
%ifdef CBUILD
%include "c/front/main/assinsert.inc"
%else
assinsert:
        push dword 8
        call __CHK
        push ebx
        mov bx, word [byte eax+01Ch]
        dec ebx
        xor bh, bh
        and bl, 7
        mov word [byte eax+01Ch], bx
        movsx edx, dx
        call assreplace
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ReplayIsEmpty                                12034  95 PC, medium confidence
; Returns 1 when recbpr == replaystart and sflags bit 10h is clear (nothing
; recorded in the replay buffer)
;-----------------------------------------------------------------------------
; C: src/front/main/ReplayIsEmpty.c
%ifdef CBUILD
%include "c/front/main/ReplayIsEmpty.inc"
%else
ReplayIsEmpty:
        push dword 4
        call __CHK
        mov eax, dword [recbpr]
        cmp eax, dword [replaystart]
        jne short .1
        test byte [sflags], 10h
        jne short .1
        mov eax, 1
        ret
.1:
        xor eax, eax
        ret
%endif ; C
