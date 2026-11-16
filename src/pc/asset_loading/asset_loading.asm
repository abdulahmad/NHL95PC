; Loading a game. Player photos, rink graphics, and a clean set of game variables.
bits 32
%include "hockey.inc"
section s_13867 progbits alloc exec nowrite align=1
extern __CHK, __STOSB, apl, assinsert, awtmap, bannermsg, bannertimer, BuildDefaultLines
extern milestonesaid, milestonesaid_b1, milestonesaid_b3, curevent, goalevent, cddriveptr, ClearInputQueue, ClearPanelPenalties
extern cont2team, crowdlevel, CrowdNoiseReset, crowdsmooth, curperiod, CwdExciteLvl, deferpending, DrawAwardsSummary
extern DrawHudPanel, dword_C66D0, dword_C66D4, goalienotebits, demoflag, gfxidlist, SumCwdExciteLvl, SpeechPatchNext
extern UnusedEventWord, energywarn, exitgame, fadeinpending, FadePalette, FadePalStep, FileClose, fileoncd
extern FileOpenRead, forceteams, fox, foy, frameaccum, FreeMemBlock, gameopts, gameover
extern gsp, hilightfont, hmtmap, HomeTeam, hudhundaccum, inputframes, introskipped, joyq_flush
extern joysampling, joysampling_save, kaufmfont, lastplayer, lcblink, lcblinktime, lcboxon, lcline
extern lcreqchoice, lcrequest, lcsel, lctimer, MakePath, memcpy_, MouseSetPos, musichandle
extern musicon, musicslot, AssetLoadNoOp, numshapes, numshpbank, ovlseq, ovlstep, ovltimer
extern pad1dev, pad2dev, passdir, passplayer, passspeed, Penaltytimer, Pencntdwn, penshotlive
extern penshotmode, penshotplayer, penshotstart, photobankf, photobanks, photoptrs, photoptrsf, PickAwardWinners
extern PickAwardWinners_x, PlayDigiSample, puckx, pucky, randomd0, RefPen, refsignal, RefStep
extern regd0, regd1, regd2, regd4, rinkendart, rinkendbank, savedmousex, savedmousey
extern savepal, scrpitch, SetTextColors, SetupTeamLines, shotongoal, shotontarget, shotplayer, ShowAwardScreens
extern songdata, SortCords, sounddev, sprintf_, StartGame, StartPreGame, StopDigiSample, str_0000
extern str_04d, str_Adafan, str_Adawards, str_Awards, str_Awardsi, str_Awasong, str_D00_D49, str_D00D49
extern str_D50_D99, str_D50D99, str_F000149, str_GfxIdList, str_HILIGHT, str_Iff, str_Mtafan, str_Mtawards
extern str_Numshp, str_Pal3, str_Palmem, str_PPV, str_Scrn, str_Summ, str_Titl, str_Trinknd
extern str_VFN, AllocMemBlock, PushMemDescriptorLocked, LoadBank, OpenArtArchiveErr, TextSetColors, TextSaveState, TextRestoreState
extern TextSetFont, LoadSample, FreeSample, LoadDigiFile, PlayDigiBlockLoop, SndQuery, SetDigiChannelVolume, SetPalette
extern DrawBitmap, ProjectPointList, FindShape, FindShapeQuiet, ClearScreen, SetScreenTarget, textline1, textline2
extern textline3, textline4, textline5, threat, VisTeam, vtoa, WaitClickTimeout, WaitDigiSample
extern penaltysc, SortPending, lcsel_aw, puckfaceoff2_ptab, puckfaceoff2_ptab_y, refhitcount, injurystop, Pencntdwn2
extern rinkobjs, milestonesaid_b2, UnusedSpeechWord, UnusedCrowdWord, MaxCwdExciteLvl, NumCwdExciteLvl, UnusedCrowdWordHi, penevteam
extern rinkobjused
global IndexPhotoBank, IndexPhotoBank_x, LoadPhotoBankF, LoadPhotoBankF_x, LoadPlayerPhotos, LoadTransparentRinkEndOverlay, LoadGameGfx, LoadGameGfx_common
global ReloadGameGfx, PlacePlayersAtStart, SetupGame, SetupDemoGame, ResetGameVars, FileExists
;-----------------------------------------------------------------------------
; IndexPhotoBank                               13867  95 PC, medium confidence
; (bank): looks up the 50 "%04d" pictures of photo bank n (photobanks[n])
; into photoptrs[n*50 ..], stopping at 46Eh entries
;-----------------------------------------------------------------------------
; C: src/pc/asset_loading/IndexPhotoBank.c
%ifdef CBUILD
%include "c/pc/asset_loading/IndexPhotoBank.inc"
%else
IndexPhotoBank:
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
        mov esi, eax
        shl esi, 2
        sub esi, eax
        shl esi, 3
        add esi, eax
        add esi, esi
        xor edi, edi
.1:
        push esi
        push str_04d
        lea eax, [byte esp+08h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov eax, esp
        push eax
        mov edx, dword [nosplit ebp*4+photobanks]
        push edx
        call FindShapeQuiet
        add esp, byte 8
        mov dword [nosplit esi*4+photoptrs], eax
        inc esi
        cmp esi, 46Eh
        jge short .2
        inc edi
        cmp edi, byte 32h
        jl short IndexPhotoBank.1
.2:
        add esp, byte 0Ch
        pop ebp
IndexPhotoBank_x:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; LoadPhotoBankF                                                  138D2  95 PC
; Once (photobankf == 0): loads "f000_149.PPV" and looks up its 69h "%04d"
; pictures into photoptrsf
;-----------------------------------------------------------------------------
; C: src/pc/asset_loading/LoadPhotoBankF.c
%ifdef CBUILD
%include "c/pc/asset_loading/LoadPhotoBankF.inc"
%else
LoadPhotoBankF:
        push dword 40h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        sub esp, byte 20h
        mov edx, dword [photobankf]
        test edx, edx
        jne short LoadPhotoBankF_x
        mov ecx, str_PPV
        mov ebx, str_F000149
        cmp byte [fileoncd+090h], 1
        jne short .1
        mov edx, dword [cddriveptr]
.1:
        mov eax, esp
        call MakePath
        push byte 20h
        lea eax, [byte esp+04h]
        push eax
        call OpenArtArchiveErr
        add esp, byte 8
        mov dword [photobankf], eax
        xor esi, esi
.2:
        push esi
        push str_04d
        lea eax, [byte esp+018h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea eax, [byte esp+010h]
        push eax
        mov ebx, dword [photobankf]
        push ebx
        call FindShape
        add esp, byte 8
        mov dword [nosplit esi*4+photoptrsf], eax
        inc esi
        cmp esi, byte 69h
        jl short LoadPhotoBankF.2
LoadPhotoBankF_x:
        add esp, byte 20h
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; LoadPlayerPhotos                             1395F  95 PC, medium confidence
; Loads each of the 17h .PPV photo banks not loaded yet (names "%d00_%d49" /
; "%d50_%d99" below bank 14h, "%d00%d49" / "%d50%d99" above) and indexes them
; (IndexPhotoBank), then LoadPhotoBankF; called from the game setup,
; frontend_desk and the game
;-----------------------------------------------------------------------------
; C: src/pc/asset_loading/LoadPhotoBankF.c (LoadPlayerPhotos)
%ifdef CBUILD
%include "c/pc/asset_loading/LoadPhotoBankF.LoadPlayerPhotos.inc"
%else
LoadPlayerPhotos:
        push dword 44h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        sub esp, byte 20h
        xor esi, esi
.1:
        cmp dword [nosplit esi*4+photobanks], byte 0
        jne near .8
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov ebx, eax
        mov ecx, 2
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ecx
        mov eax, edx
        cmp esi, byte 14h
        jl short .3
        test edx, edx
        je short .2
        push ebx
        push ebx
        push str_D50D99
        jmp short .5
.2:
        push ebx
        push ebx
        push str_D00D49
        jmp short .5
.3:
        test edx, edx
        je short .4
        push ebx
        push ebx
        push str_D50_D99
        jmp short .5
.4:
        push ebx
        push ebx
        push str_D00_D49
.5:
        lea eax, [byte esp+01Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        mov ecx, str_PPV
        lea ebx, [byte esp+010h]
        cmp byte [dword esi+fileoncd], 1
        jne short .6
        mov edx, dword [cddriveptr]
        jmp short .7
.6:
        xor edx, edx
.7:
        mov eax, esp
        call MakePath
        push byte 20h
        lea eax, [byte esp+04h]
        push eax
        call OpenArtArchiveErr
        mov edx, eax
        add esp, byte 8
        mov eax, esi
        mov dword [nosplit esi*4+photobanks], edx
        call IndexPhotoBank
.8:
        inc esi
        cmp esi, byte 17h
        jl near LoadPlayerPhotos.1
        call LoadPhotoBankF
        jmp near LoadPhotoBankF_x
%endif ; C
;-----------------------------------------------------------------------------
; LoadTransparentRinkEndOverlay                                 13A2F  library
; Load the transparent rink end bank (TRINKND.PPV, from the CD when fileoncd
; says so) into rinkendbank and its art 0000 into rinkendart.
;-----------------------------------------------------------------------------
; C: src/pc/asset_loading/LoadTransparentRinkEndOverlay.c
%ifdef CBUILD
%include "c/pc/asset_loading/LoadTransparentRinkEndOverlay.inc"
%else
LoadTransparentRinkEndOverlay:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        sub esp, byte 10h
        mov ecx, str_PPV
        mov ebx, str_Trinknd
        cmp byte [fileoncd+01AAh], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
        mov eax, esp
        call MakePath
        push byte 20h
        lea eax, [byte esp+04h]
        push eax
        call OpenArtArchiveErr
        add esp, byte 8
        mov dword [rinkendbank], eax
        push str_0000
        push eax
        call FindShape
        add esp, byte 8
        mov dword [rinkendart], eax
        add esp, byte 10h
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; LoadGameGfx                                  13A91  95 PC, medium confidence
; In-game graphics: SetScreenTarget, scrpitch 52h, HILIGHT.VFN (hilightfont),
; numshp.PPV with its 10 number shapes (numshapes), then LoadGameGfx_common;
; called from PlayGame and the highlights / game-setup code
;-----------------------------------------------------------------------------
; C: src/pc/asset_loading/LoadGameGfx.c
%ifdef CBUILD
%include "c/pc/asset_loading/LoadGameGfx.inc"
%else
LoadGameGfx:
        push dword 3Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        sub esp, byte 1Ch
        call SetScreenTarget
        mov word [scrpitch], 52h
        mov ecx, str_VFN
        mov ebx, str_HILIGHT
        cmp byte [fileoncd+0A0h], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
        mov eax, esp
        call MakePath
        push byte 20h
        lea eax, [byte esp+04h]
        push eax
        call OpenArtArchiveErr
        add esp, byte 8
        mov dword [hilightfont], eax
        mov ecx, str_PPV
        mov ebx, str_Numshp
        cmp byte [fileoncd+010Bh], 1
        jne short .3
        mov edx, dword [cddriveptr]
        jmp short .4
.3:
        xor edx, edx
.4:
        mov eax, esp
        call MakePath
        push byte 20h
        lea eax, [byte esp+04h]
        push eax
        call OpenArtArchiveErr
        add esp, byte 8
        mov dword [numshpbank], eax
        xor esi, esi
.5:
        push esi
        push str_04d
        lea eax, [byte esp+018h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea eax, [byte esp+010h]
        push eax
        mov edx, dword [numshpbank]
        push edx
        call FindShape
        add esp, byte 8
        mov dword [nosplit esi*4+numshapes], eax
        inc esi
        cmp esi, byte 0Ah
        jl short LoadGameGfx.5
LoadGameGfx_common:
        push gfxidlist
        push str_GfxIdList
        mov ebx, dword [numshpbank]
        push ebx
        call ProjectPointList
        add esp, byte 0Ch
        call ClearPanelPenalties
        call LoadTransparentRinkEndOverlay
        push dword 0FFh
        push byte 4
        call TextSetColors
        add esp, byte 8
        call LoadPlayerPhotos
        call AssetLoadNoOp
        mov word [fadeinpending], 1
        mov ecx, 1
        mov dword [dword_C66D4], ecx
        mov dword [dword_C66D0], ecx
        add esp, byte 1Ch
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ReloadGameGfx                                13BB4  95 PC, medium confidence
; LoadGameGfx without the SetScreenTarget call (same HILIGHT / numshp loads, then
; LoadGameGfx_common); called from the scoreboard segment before
; SetupGameQuick
;-----------------------------------------------------------------------------
; C: src/pc/asset_loading/LoadGameGfx.c (ReloadGameGfx)
%ifdef CBUILD
%include "c/pc/asset_loading/LoadGameGfx.ReloadGameGfx.inc"
%else
ReloadGameGfx:
        push dword 3Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        sub esp, byte 1Ch
        mov word [scrpitch], 52h
        mov ecx, str_VFN
        mov ebx, str_HILIGHT
        cmp byte [fileoncd+0A0h], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
        mov eax, esp
        call MakePath
        push byte 20h
        lea eax, [byte esp+04h]
        push eax
        call OpenArtArchiveErr
        add esp, byte 8
        mov dword [hilightfont], eax
        mov ecx, str_PPV
        mov ebx, str_Numshp
        cmp byte [fileoncd+010Bh], 1
        jne short .3
        mov edx, dword [cddriveptr]
        jmp short .4
.3:
        xor edx, edx
.4:
        mov eax, esp
        call MakePath
        push byte 20h
        lea eax, [byte esp+04h]
        push eax
        call OpenArtArchiveErr
        add esp, byte 8
        mov dword [numshpbank], eax
        xor esi, esi
.5:
        push esi
        push str_04d
        lea eax, [byte esp+018h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea eax, [byte esp+010h]
        push eax
        mov edx, dword [numshpbank]
        push edx
        call FindShape
        add esp, byte 8
        mov dword [nosplit esi*4+numshapes], eax
        inc esi
        cmp esi, byte 0Ah
        jl short ReloadGameGfx.5
        jmp near LoadGameGfx_common
%endif ; C
;-----------------------------------------------------------------------------
; PlacePlayersAtStart                             13C79  95 PC, low confidence
; When demoflag is 0: forceteams, puck to centre, then for the 12 skaters /
; goalies: assignment 16h (17h goalie), position from the team formation
; tables (apl, puckfaceoff2_ptab / puckfaceoff2_ptab_y, mirrored by side),
; facing the puck (vtoa); PlayGame setup calls it when gameopts bit 2 is set
; or no skate-out
;-----------------------------------------------------------------------------
PlacePlayersAtStart:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        cmp dword [demoflag], byte 0
        jne near .x
        call forceteams
        xor edx, edx
        mov word [foy], dx
        mov word [fox], dx
        mov eax, dword [pucky]
        mov word [eax], dx
        mov eax, dword [puckx]
        mov word [eax], dx
        mov ebx, SortCords
        mov word [regd2], 0Ch
.1:
        mov word [byte ebx+02Eh], 0FF9Ch
        mov ax, word [byte ebx+01Ah]
        mov word [regd1], ax
        cmp ax, 4
        sete al
        and eax, 0FFh
        add eax, byte 16h
        movsx edx, ax
        mov eax, ebx
        call assinsert
        cmp word [regd1], byte 0
        jl near .11
        test byte [byte ebx+044h], 40h
        je short .2
        mov ax, word [awtmap]
        jmp short .3
.2:
        mov ax, word [hmtmap]
.3:
        neg eax
        mov word [regd4], ax
        mov ax, word [regd4]
        add eax, 6
        shl eax, 3
        mov word [regd4], ax
        mov edx, dword [regd4-2]
        sar edx, 10h
        mov eax, dword [regd1-2]
        sar eax, 10h
        movsx ax, byte [dword edx+eax+apl]
        mov word [regd4], ax
        add eax, eax
        mov word [regd4], ax
        mov eax, dword [regd4-2]
        sar eax, 10h
        mov dx, word [nosplit eax*2+puckfaceoff2_ptab]
        mov word [regd0], dx
        mov ax, word [nosplit eax*2+puckfaceoff2_ptab_y]
        mov word [regd1], ax
        test byte [byte ebx+044h], 80h
        jne short .4
        neg word [regd0]
        neg word [regd1]
.4:
        mov ax, word [regd0]
        mov word [byte ebx+02h], ax
        mov ax, word [regd1]
        mov word [byte ebx+06h], ax
        mov word [byte ebx+0Eh], 0
        mov ax, word [byte ebx+0Eh]
        mov word [byte ebx+0Ch], ax
        mov eax, dword [pucky]
        mov ax, word [eax]
        sub ax, word [regd1]
        movsx edx, ax
        mov eax, dword [puckx]
        mov ax, word [eax]
        sub ax, word [regd0]
        cwde
        call vtoa
        mov word [byte ebx+036h], ax
        cmp word [byte ebx+01Ah], byte 0
        jne short .7
        cmp byte [byte ebx+065h], 0
        je short .5
        mov eax, dword [byte ebx+034h]
        sar eax, 10h
        jmp short .6
.5:
        mov eax, dword [byte ebx+034h]
        sar eax, 10h
        mov edx, 8
        sub edx, eax
        mov eax, edx
        and eax, byte 7
.6:
        mov edx, eax
        shl eax, 2
        sub eax, edx
        add eax, 196h
        mov word [byte ebx+012h], ax
        mov word [regd1], 1
        jmp short .10
.7:
        cmp byte [byte ebx+065h], 0
        je short .8
        mov eax, dword [byte ebx+034h]
        sar eax, 10h
        jmp short .9
.8:
        mov eax, dword [byte ebx+034h]
        sar eax, 10h
        mov edx, 8
        sub edx, eax
        mov eax, edx
        and eax, byte 7
.9:
        mov edx, eax
        shl eax, 2
        add eax, edx
        mov word [byte ebx+012h], ax
        mov word [regd1], 289h
.10:
        and byte [byte ebx+045h], 0FBh
        and byte [byte ebx+044h], 0DFh
        mov word [byte ebx+03Ah], 0
        mov ax, word [regd1]
        mov word [byte ebx+038h], ax
        mov word [byte ebx+03Ch], 0FFFFh
.11:
        add ebx, 80h
        mov cx, word [regd2]
        dec cx
        mov word [regd2], cx
        jne near PlacePlayersAtStart.1
.x:
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; SetupGame                                    13E8F  95 PC, medium confidence
; (from PlayGame): lines for both teams (SetupTeamLines), crowd reset,
; ResetGameVars, team intro scoreboard (DrawHudPanel Home / Visitor),
; StartPreGame (-1 on cancel), ResetGameVars again, palette fade-in,
; PlacePlayersAtStart
;-----------------------------------------------------------------------------
; C: src/pc/asset_loading/SetupGame.c
%ifdef CBUILD
%include "c/pc/asset_loading/SetupGame.inc"
%else
SetupGame:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push edi
        call BuildDefaultLines
        xor eax, eax
        call SetupTeamLines
        mov eax, 1
        call SetupTeamLines
        mov word [gsp], 0FFFFh
        xor ebx, ebx
        mov word [crowdlevel], bx
        call CrowdNoiseReset
        xor edx, edx
        mov dword [introskipped], edx
        call ResetGameVars
        mov edx, dword [VisTeam-2]
        sar edx, 10h
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        mov ecx, 1
        mov ebx, ecx
        call DrawHudPanel
        xor ecx, ecx
        mov word [crowdlevel], cx
        xor ebx, ebx
        mov dword [crowdsmooth], ebx
        xor edx, edx
        xor eax, eax
        call StartPreGame
        test eax, eax
        jge short .1
        mov eax, 0FFFFFFFFh
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        mov edx, dword [introskipped]
        test edx, edx
        je short .2
        mov word [fadeinpending], 1
.2:
        xor edi, edi
        mov word [gsp], di
        call ResetGameVars
        mov dword [introskipped], edx
        test edx, edx
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
.3:
        test byte [gameopts], 4
        jne short .4
        cmp dword [introskipped], byte 0
        jne short .5
.4:
        call PlacePlayersAtStart
.5:
        cmp dword [demoflag], byte 0
        jne short .6
        cmp dword [introskipped], byte 0
        jne short .6
        xor eax, eax
        mov word [fadeinpending], ax
.6:
        xor eax, eax
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SetupDemoGame                                13FA7  95 PC, medium confidence
; Corrected from SetupGameQuick: its only caller is RunDemoGame; SetupGame
; without the panel intro, the fade-in and PlacePlayersAtStart
;-----------------------------------------------------------------------------
; C: src/pc/asset_loading/SetupDemoGame.c
%ifdef CBUILD
%include "c/pc/asset_loading/SetupDemoGame.inc"
%else
SetupDemoGame:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push edi
        call BuildDefaultLines
        xor eax, eax
        call SetupTeamLines
        mov eax, 1
        call SetupTeamLines
        mov word [gsp], 0FFFFh
        xor ebx, ebx
        mov word [crowdlevel], bx
        call CrowdNoiseReset
        xor edx, edx
        mov dword [introskipped], edx
        call ResetGameVars
        xor ecx, ecx
        mov word [crowdlevel], cx
        mov dword [crowdsmooth], edx
        xor eax, eax
        call StartPreGame
        test eax, eax
        jge short .1
        mov eax, 0FFFFFFFFh
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        mov edx, dword [introskipped]
        test edx, edx
        je short .2
        mov word [fadeinpending], 1
.2:
        xor edi, edi
        mov word [gsp], di
        call ResetGameVars
        mov dword [introskipped], edx
        cmp dword [demoflag], byte 0
        jne short .3
        test edx, edx
        jne short .3
        xor eax, eax
        mov word [fadeinpending], ax
.3:
        xor eax, eax
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ResetGameVars                                14056  95 PC, medium confidence
; Clears the per-game state (penalty / referee / line-change / penalty-shot
; vars, pass state, crowd excitement, input counters, exitgame / gameover,
; frameaccum), calls StartGame, centres the mouse when a pad uses it,
; joyq_flush
;-----------------------------------------------------------------------------
ResetGameVars:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ah, 0FFh
        mov byte [curevent], ah
        mov byte [goalevent], ah
        xor edx, edx
        mov dword [goalienotebits], edx
        xor dh, dh
        mov byte [milestonesaid_b3], dh
        mov byte [milestonesaid_b2], dh
        mov byte [milestonesaid_b1], dh
        mov byte [milestonesaid], dh
        mov edx, 0FFFFFFFFh
        mov word [ovltimer], dx
        mov word [penaltysc], dx
        mov word [RefStep], dx
        mov word [Pencntdwn], dx
        mov word [Pencntdwn2], dx
        xor eax, eax
        mov word [threat], ax
        mov word [passplayer], ax
        mov word [passspeed], ax
        mov word [passdir], ax
        mov word [lastplayer], ax
        mov word [shotplayer], ax
        mov word [SortPending], ax
        mov word [RefPen], ax
        mov word [refsignal], ax
        mov word [Penaltytimer], ax
        mov word [lcblinktime+2], ax
        mov word [lcblinktime], ax
        mov word [lcblink+2], ax
        mov word [lcblink], ax
        mov word [energywarn+2], ax
        mov word [energywarn], ax
        mov word [lcreqchoice+2], ax
        mov word [lcreqchoice], ax
        mov word [lcrequest+2], ax
        mov word [lcrequest], ax
        mov word [lcboxon+2], ax
        mov word [lcboxon], ax
        mov word [lctimer+2], ax
        mov word [lctimer], ax
        mov word [lcline+2], ax
        mov word [lcline], ax
        mov word [lcsel_aw], ax
        mov word [lcsel], ax
        xor ebx, ebx
        mov dword [savedmousey], ebx
        xor ecx, ecx
        mov dword [savedmousex], ecx
        mov word [bannertimer], ax
        mov word [injurystop], ax
        mov word [refhitcount], ax
        mov ecx, edx
        mov word [bannermsg], dx
        mov word [ovlstep], dx
        mov word [ovlseq], dx
        xor ch, dh
        mov byte [textline5], ch
        xor al, al
        mov byte [textline4], al
        mov byte [textline2], al
        mov byte [textline1], al
        mov byte [textline3], al
        xor esi, esi
        mov dword [penshotmode], ebx
        mov dword [penshotlive], ebx
        mov dword [penshotstart], ebx
        xor eax, eax
        mov dword [shotontarget], ebx
        mov dword [shotongoal], ebx
        mov dword [penshotplayer], 0FFFFFFFFh
        xor eax, esi
        mov word [CwdExciteLvl], ax
        xor ebx, ebx
.1:
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 2
        mov edx, rinkobjs
        add edx, eax
        mov word [edx], 0FFFFh
        mov eax, 28h
        call randomd0
        add al, 3Ch
        mov byte [byte edx+02h], al
        inc ebx
        cmp ebx, byte 14h
        jl short ResetGameVars.1
        mov ecx, 20h
        xor edx, edx
        mov eax, rinkobjused
        call __STOSB
        xor edx, edx
        mov word [SpeechPatchNext], dx
        mov word [penevteam], dx
        mov word [UnusedEventWord], dx
        mov word [NumCwdExciteLvl], dx
        mov word [MaxCwdExciteLvl], dx
        mov word [UnusedCrowdWord], dx
        mov word [UnusedCrowdWordHi], dx
        xor ecx, ecx
        mov dword [SumCwdExciteLvl], ecx
        mov word [UnusedSpeechWord], 0FFFFh
        call StartGame
        mov dword [curperiod], 1
        cmp byte [pad1dev], 1
        je short .2
        cmp byte [pad2dev], 1
        jne short .3
.2:
        push byte 64h
        push dword 0A0h
        call MouseSetPos
        add esp, byte 8
.3:
        xor edi, edi
        mov dword [deferpending], edi
        mov dword [inputframes], edi
        xor ecx, ecx
        mov word [exitgame], cx
        xor esi, esi
        mov word [gameover], si
        mov dword [hudhundaccum], edi
        mov dword [frameaccum], edi
        mov dword [joysampling], edi
        mov word [joysampling_save], cx
        call joyq_flush
        jmp near IndexPhotoBank_x
;-----------------------------------------------------------------------------
; FileExists                                                      142E7  95 PC
; (name): FileOpenRead then FileClose; returns 1 when the open succeeded
;-----------------------------------------------------------------------------
; C: src/pc/asset_loading/FileExists.c
%ifdef CBUILD
%include "c/pc/asset_loading/FileExists.inc"
%else
FileExists:
        push dword 10h
        call __CHK
        push ebx
        push edx
        sub esp, byte 4
        mov dword [esp], 0FFFFFFFFh
        xor ebx, ebx
        mov edx, esp
        call FileOpenRead
        test eax, eax
        jne short .1
        mov ebx, 1
.1:
        mov eax, esp
        call FileClose
        mov eax, ebx
        add esp, byte 4
        pop edx
        pop ebx
        ret
%endif ; C
