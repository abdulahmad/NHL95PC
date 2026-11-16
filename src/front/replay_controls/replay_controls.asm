; The instant-replay panel and its gadgets, the rock music played for a team, and saving a
; highlight and playing one back from the reel. One module (DrawGadgetButton's exit).
bits 32
%include "hockey.inc"
section s_7DC8B progbits alloc exec nowrite align=1
extern __CHK, AllocMemBlock, bgscrollx, bgscrolly, camx, camy, cddriveptr, ClearInputQueue
extern crowdlevel, CrowdNoiseOff, crowdsmooth, ctl1team, ctl2team, cursndbank, DrawArt, DrawFrameSprite
extern DrawRinkSideObjects, DrawShape, dressedskaters, dword_C66D0, dword_C66D4, GadgetMovie, ReplaySpeedAccum, ReplayHoverPrev
extern ReplayCamFree, ReplayHoverPlayer, ReplayStartRate, ReplayCtlFlags, FadePalette, fileoncd, FindShape, FreeMemBlock
extern FreeSample, gadgetfile, gadgetptrx, gadgetptry, gadgetrect_x1, gadgetrect_y0, gadgetrect_y1, gadgetrects
extern gadgetshape, gamemode, gamepal, GetInputEvent, GrabBlock, HilightSaveToDlg, hilightslot, HomeTeam
extern lastsfx, LoadSample, mainfont, MakePath, MessageBox, MouseSetPos, msg_NoHilightSpace, musicon
extern NudgeRinkScroll, PlotPixel, pointerspr, ptrupdatefn, rand_, replaybtnarmed, ReplayFirstFrame, replayfollowpl
extern replayfrac, replaynosave, replayplay, replayptrx, replayptry, replaysfx, replayspotx, replayspoty
extern ReplayStep, RestoreDialogBg, rinkscrollx, rinkscrolly, rockcuefiles, rockcuepathsel, rockcuepool, rockrandcues
extern rockteamcues, rocktunes, rpl_x, rpl_x_e16, rpl_y, SaveHilight, savepal, scrollx
extern scrolly, SelectRinkBM, SelectScreenBM, SetClipWindow, SetDialogColors, SetPalette, SetRinkScroll, SetScreenSize
extern SetTickDeadline, SetViewRect, sounddev, spritedrawcount, str_ADROCKU, str_BothTeams, str_Gad1, str_Gadget5
extern str_Gadget6, str_MTROCKU, str_NeitherTeams, str_Pointer19, str_PPV, str_ROCKDITI, str_SBROCKU, FlushZones
extern SetZoneScreen, SetZoneOrigin, BeginZoneFrame, OpenArtArchiveErr, MviGetFrame, SetScreenTarget, VgaBlitKeyed, FillRectColor
extern VgaBlitKeyedFlipV, teamrockcuetbl, teamrocktune, teamtunefiles, teamtunepathsel, TextRestoreState, TextSaveState, TextSetFont
extern TicksSinceLastCall, viewscrollx, viewscrolly, WaitTickDeadline
global LoadRockMusic, LoadRockMusic_ret, FreeRockMusic, DrawGadgetByType, GadgetStub0, GadgetSoundStub, bothneitherstrs, DrawGadgetButton
global DrawGadgetButton_ret, InstantReplay, GadgetHitTest, PickNearestPlayer, ReplayControlLoop, ReplaySaveHilight_jt, ReplaySaveHilight, ReplaySaveHilight_n0
global ReplaySaveHilight_n2, ReplaySaveHilight_n1, ReplaySaveHilight_n3
;-----------------------------------------------------------------------------
; LoadRockMusic                                7DC8B  95 PC, medium confidence
; Loads 6 team cues + 3 random of 18 pool + device rock tune (MT/SB/ADROCKU)
; + team tune + ROCKDITI via LoadSample
;-----------------------------------------------------------------------------
; C: src/front/replay_controls/LoadRockMusic.c
%ifdef CBUILD
%include "c/front/replay_controls/LoadRockMusic.inc"
%else
LoadRockMusic:
        push dword 38h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 20h
        mov dword [cursndbank], 20h
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        mov dword [byte esp+01Ch], eax
        cmp eax, byte 1Ah
        jl short .1
        mov dword [byte esp+01Ch], 0Dh
.1:
        xor edi, edi
.2:
        mov edx, dword [byte esp+01Ch]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        mov eax, dword [dword edi+eax*2+teamrockcuetbl]
        sar eax, 18h
        test eax, eax
        jl short .5
        xor ecx, ecx
        mov ebx, dword [nosplit eax*4+rockcuefiles]
        mov eax, dword [nosplit eax*4+rockcuepathsel]
        cmp byte [dword eax+fileoncd], 1
        jne short .3
        mov edx, dword [cddriveptr]
        jmp short .4
.3:
        xor edx, edx
.4:
        mov eax, esp
        call MakePath
        mov eax, esp
        call LoadSample
        mov dword [nosplit edi*4+rockteamcues], eax
        jmp short .6
.5:
        xor esi, esi
        mov dword [nosplit edi*4+rockteamcues], esi
.6:
        inc edi
        cmp edi, byte 6
        jl short LoadRockMusic.2
        xor edi, edi
.7:
        mov ebx, 0FFFFFFFFh
        call rand_
        mov edx, eax
        and edx, 7FFFh
        mov ecx, 12h
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov esi, edx
        xor eax, eax
        jmp short .10
.8:
        mov ecx, dword [byte esp+01Ch]
        mov edx, ecx
        shl edx, 2
        sub edx, ecx
        mov ecx, dword [dword eax+edx*2+teamrockcuetbl]
        sar ecx, 18h
        cmp ecx, dword [nosplit esi*4+rockcuepool]
        jne short .9
        xor ebx, ebx
.9:
        inc eax
.10:
        cmp eax, byte 6
        jge short .11
        test ebx, ebx
        jne short LoadRockMusic.8
.11:
        xor eax, eax
        jmp short .14
.12:
        mov ecx, dword [nosplit esi*4+rockcuepool]
        cmp ecx, dword [byte esp+eax*4+010h]
        jne short .13
        xor ebx, ebx
.13:
        inc eax
.14:
        cmp eax, edi
        jge short .15
        test ebx, ebx
        jne short LoadRockMusic.12
.15:
        test ebx, ebx
        je short LoadRockMusic.7
        mov edx, dword [nosplit esi*4+rockcuepool]
        mov dword [byte esp+edi*4+010h], edx
        xor ecx, ecx
        mov ebx, dword [nosplit edx*4+rockcuefiles]
        mov eax, dword [nosplit edx*4+rockcuepathsel]
        cmp byte [dword eax+fileoncd], 1
        jne short .16
        mov edx, dword [cddriveptr]
        jmp short .17
.16:
        xor edx, edx
.17:
        mov eax, esp
        call MakePath
        mov eax, esp
        call LoadSample
        mov dword [nosplit edi*4+rockrandcues], eax
        inc edi
        cmp edi, byte 3
        jl near LoadRockMusic.7
        cmp dword [sounddev], byte 8
        jne short .19
        xor ecx, ecx
        mov ebx, str_MTROCKU
        cmp byte [fileoncd+0100h], 1
.18:
        je short .21
        xor edx, edx
        jmp short .23
.19:
        cmp byte [musicon], 0
        je short .20
        xor ecx, ecx
        mov ebx, str_SBROCKU
        cmp byte [fileoncd+0166h], 1
        jmp short LoadRockMusic.18
.20:
        xor ecx, ecx
        mov ebx, str_ADROCKU
        cmp byte [fileoncd+01Fh], 1
        jne short .22
.21:
        mov edx, dword [cddriveptr]
        jmp short .23
.22:
        xor edx, edx
.23:
        mov eax, esp
        call MakePath
        mov eax, esp
        call LoadSample
        mov dword [rocktunes], eax
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        mov eax, dword [dword eax+teamrocktune-3]
        sar eax, 18h
        xor ecx, ecx
        mov ebx, dword [nosplit eax*4+teamtunefiles]
        mov eax, dword [nosplit eax*4+teamtunepathsel]
        cmp byte [dword eax+fileoncd], 1
        jne short .24
        mov edx, dword [cddriveptr]
        jmp short .25
.24:
        xor edx, edx
.25:
        mov eax, esp
        call MakePath
        mov eax, esp
        call LoadSample
        mov dword [rocktunes+4], eax
        xor ecx, ecx
        mov ebx, str_ROCKDITI
        cmp byte [fileoncd+0161h], 1
        jne short .26
        mov edx, dword [cddriveptr]
        jmp short .27
.26:
        xor edx, edx
.27:
        mov eax, esp
        call MakePath
        mov eax, esp
        call LoadSample
        mov dword [rocktunes+8], eax
        xor eax, eax
        mov dword [cursndbank], eax
        add esp, byte 20h
LoadRockMusic_ret:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; FreeRockMusic                                7DEC8  95 PC, medium confidence
; Frees rockteamcues[6], rockrandcues[3], rocktunes[3] via FreeSample
;-----------------------------------------------------------------------------
; C: src/front/replay_controls/LoadRockMusic.c (FreeRockMusic)
%ifdef CBUILD
%include "c/front/replay_controls/LoadRockMusic.FreeRockMusic.inc"
%else
FreeRockMusic:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        xor edx, edx
.1:
        mov ebx, edx
        shl ebx, 2
        mov ecx, dword [dword ebx+rockteamcues]
        test ecx, ecx
        je short .2
        mov eax, ecx
        call FreeSample
        xor esi, esi
        mov dword [dword ebx+rockteamcues], esi
.2:
        inc edx
        cmp edx, byte 6
        jl short FreeRockMusic.1
        xor edx, edx
.3:
        mov ebx, edx
        shl ebx, 2
        mov edi, dword [dword ebx+rockrandcues]
        test edi, edi
        je short .4
        mov eax, edi
        call FreeSample
        xor ebp, ebp
        mov dword [dword ebx+rockrandcues], ebp
.4:
        inc edx
        cmp edx, byte 3
        jl short FreeRockMusic.3
        xor edx, edx
.5:
        mov ebx, edx
        shl ebx, 2
        mov eax, dword [dword ebx+rocktunes]
        test eax, eax
        je short .6
        call FreeSample
        xor ecx, ecx
        mov dword [dword ebx+rocktunes], ecx
.6:
        inc edx
        cmp edx, byte 3
        jl short FreeRockMusic.5
        pop ebp
        jmp near LoadRockMusic_ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawGadgetByType                                7DF4E  95 PC, low confidence
; (type, ?, ?, gadget): switch on type 4/8/10h/20h drawing the gadget's
; shapes (+28h/+24h/+2Ch via DrawShape) and its label field; used by
; game_setup and settings dialogs
;-----------------------------------------------------------------------------
; C: src/front/replay_controls/DrawGadgetByType.c
%ifdef CBUILD
%include "c/front/replay_controls/DrawGadgetByType.inc"
%else
DrawGadgetByType:
        push dword 18h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov byte [esp], dl
        mov esi, ecx
        cmp eax, byte 8
        jb short .1
        jbe short .3
        cmp eax, byte 10h
        jb near .6
        jbe short .4
        cmp eax, byte 20h
        je short .5
        jmp near .6
.1:
        cmp eax, byte 4
        jne short .6
        mov eax, dword [byte ecx+028h]
        push eax
        call DrawShape
        add esp, byte 4
        mov edx, dword [byte esi+024h]
        push edx
        call DrawShape
        add esp, byte 4
        mov ebx, dword [byte esi+01Ch]
.2:
        push ebx
        jmp near .9
.3:
        mov eax, dword [byte ecx+028h]
        push eax
        call DrawShape
        add esp, byte 4
        mov edx, dword [byte esi+024h]
        push edx
        call DrawShape
        add esp, byte 4
        mov ebx, dword [byte esi+04h]
        jmp short DrawGadgetByType.2
.4:
        mov ecx, dword [byte ecx+028h]
        push ecx
        call DrawShape
        add esp, byte 4
        mov edi, dword [byte esi+024h]
        push edi
        call DrawShape
        add esp, byte 4
        mov ebp, dword [esi]
        push ebp
        jmp short .9
.5:
        mov edx, dword [byte ecx+02Ch]
        push edx
        call DrawShape
        add esp, byte 4
        mov ebx, dword [byte esi+0Ch]
        jmp short DrawGadgetByType.2
.6:
        mov ecx, dword [byte esi+028h]
        push ecx
        call DrawShape
        add esp, byte 4
        mov edi, dword [byte esi+020h]
        push edi
        call DrawShape
        add esp, byte 4
        cmp byte [esp], 4
        jb short .7
        mov eax, 2
        jmp short .8
.7:
        xor eax, eax
        mov al, byte [esp]
        add eax, byte 3
.8:
        mov ebp, dword [esi+eax*4]
        push ebp
.9:
        call DrawShape
        add esp, byte 4
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        ret 8
%endif ; C
;-----------------------------------------------------------------------------
; GadgetStub0                                                     7E032  95 PC
; __CHK; return 0; unreferenced
;-----------------------------------------------------------------------------
; C: src/front/replay_controls/GadgetStub0.c
%ifdef CBUILD
%include "c/front/replay_controls/GadgetStub0.inc"
%else
GadgetStub0:
        push dword 4
        call __CHK
        xor eax, eax
        ret
%endif ; C
;-----------------------------------------------------------------------------
; GadgetSoundStub                                7E03F  95 PC, low confidence
; MviGetFrame(GadgetMovie) (EA sound library, one stack argument).
;-----------------------------------------------------------------------------
; C: src/front/replay_controls/GadgetSoundStub.c
%ifdef CBUILD
%include "c/front/replay_controls/GadgetSoundStub.inc"
%else
GadgetSoundStub:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        mov edx, dword [GadgetMovie]
        push edx
        call MviGetFrame
        add esp, byte 4
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
bothneitherstrs:
        dd str_BothTeams
        dd str_NeitherTeams
;-----------------------------------------------------------------------------
; DrawGadgetButton                             7E067  95 PC, medium confidence
; Draws frame around gadget button idx (28-byte rect table gadgetrects,
; y-0A8h)
;-----------------------------------------------------------------------------
; C: src/front/replay_controls/DrawGadgetButton.c
%ifdef CBUILD
%include "c/front/replay_controls/DrawGadgetButton.inc"
%else
DrawGadgetButton:
        push dword 34h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov esi, eax
        shl eax, 3
        sub eax, esi
        mov esi, dword [nosplit eax*4+gadgetrects]
        mov dword [esp], esi
        mov edi, dword [nosplit eax*4+gadgetrect_y0]
        sub edi, 0A8h
        mov esi, dword [nosplit eax*4+gadgetrect_x1]
        mov ebp, dword [nosplit eax*4+gadgetrect_y1]
        sub ebp, 0A8h
        push byte 10h
        push edi
        push esi
        push edi
        mov edx, dword [byte esp+010h]
        push edx
        call FillRectColor
        add esp, byte 14h
        push byte 10h
        push ebp
        mov ebx, dword [byte esp+08h]
        push ebx
        push edi
        push ebx
        call FillRectColor
        add esp, byte 14h
        push byte 15h
        push ebp
        push esi
        push edi
        push esi
        call FillRectColor
        add esp, byte 14h
        push byte 15h
        push ebp
        push esi
        push ebp
        mov esi, dword [byte esp+010h]
        push esi
        call FillRectColor
        add esp, byte 14h
        add esp, byte 4
DrawGadgetButton_ret:
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; InstantReplay                                7E0FA  95 PC, medium confidence
; Replay gadget screen: gadget6/gadget5 .PPV panel, camera save,
; ReplayFirstFrame/ReplayStep; from main/frontend/highlights
;-----------------------------------------------------------------------------
InstantReplay:
        push dword 50h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 20h
        push eax
        cmp dword [gamemode], byte 0
        je short .1
        cmp dword [ctl1team], byte 0
        jge short .2
        cmp dword [ctl2team], byte 0
        jge short .2
.1:
        mov dword [replaynosave], 1
        jmp short .3
.2:
        xor esi, esi
        mov dword [replaynosave], esi
.3:
        mov dword [ReplayCtlFlags], 44h
        mov dword [ReplayStartRate], 8
        mov dword [gadgetptrx], 100h
        mov dword [gadgetptry], 0BCh
        push dword 0C1h
        push dword 140h
        push byte 0
        push byte 0
        call SetViewRect
        add esp, byte 10h
        mov ecx, dword [gadgetptry]
        push ecx
        mov esi, dword [gadgetptrx]
        push esi
        call MouseSetPos
        add esp, byte 8
        call SelectScreenBM
        push byte 20h
        push byte 0
        push dword 140h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        cmp dword [replaynosave], byte 0
        je short .5
        mov ecx, str_PPV
        mov ebx, str_Gadget6
        cmp byte [fileoncd+0223h], 1
        jne short .4
        mov edx, dword [cddriveptr]
        jmp short .7
.4:
        xor edx, edx
        jmp short .7
.5:
        mov ecx, str_PPV
        mov ebx, str_Gadget5
        cmp byte [fileoncd+096h], 1
        jne short .6
        mov edx, dword [cddriveptr]
        jmp short .7
.6:
        xor edx, edx
.7:
        lea eax, [byte esp+04h]
        call MakePath
        push byte 0
        lea eax, [byte esp+08h]
        push eax
        call OpenArtArchiveErr
        add esp, byte 8
        mov dword [gadgetfile], eax
        push str_Gad1
        push eax
        call FindShape
        add esp, byte 8
        mov dword [gadgetshape], eax
        push byte 0
        push byte 0
        push eax
        call VgaBlitKeyed
        add esp, byte 0Ch
        mov eax, 6
        call DrawGadgetButton
        mov eax, 2
        call DrawGadgetButton
        mov eax, dword [gadgetptry]
        sub eax, 0A8h
        push eax
        mov ebp, dword [gadgetptrx]
        push ebp
        mov eax, dword [pointerspr]
        push eax
        call DrawArt
        add esp, byte 0Ch
        mov edx, 1
        mov dword [dword_C66D4], edx
        mov dword [dword_C66D0], edx
        mov ax, word [camx]
        mov dword [byte esp+01Ch], eax
        mov ax, word [camy]
        mov dword [byte esp+020h], eax
        mov di, word [viewscrollx]
        mov ax, word [viewscrolly]
        mov word [byte esp+018h], ax
        mov si, word [crowdlevel]
        xor ecx, ecx
        mov dword [ReplayCamFree], ecx
        mov word [replayfollowpl], 0FFFFh
        mov ebp, 0FFFFFFFFh
        mov dword [ReplayHoverPlayer], ebp
        mov dword [ReplayHoverPrev], ebp
        xor edx, edx
        mov dword [replaybtnarmed], ecx
        xor ebx, ebx
        mov word [replayfrac], bx
        add dword [rinkscrollx], 3E8h
        add dword [rinkscrolly], 3E8h
        call ReplayFirstFrame
        mov dword [replayplay], eax
        xor ebp, ebp
        mov dword [byte esp+014h], ebp
        xor eax, eax
        call ReplayStep
        mov eax, dword [crowdlevel-2]
        sar eax, 10h
        mov dword [crowdsmooth], eax
        mov eax, dword [camx-2]
        sar eax, 10h
        add eax, byte 20h
        mov dword [viewscrollx], eax
        cmp eax, byte 40h
        jle short .8
        mov dword [viewscrollx], 40h
.8:
        cmp dword [viewscrollx], byte 0
        jge short .9
        xor ecx, ecx
        mov dword [viewscrollx], ecx
.9:
        mov eax, dword [camy-2]
        sar eax, 10h
        mov edx, 140h
        sub edx, eax
        lea eax, [byte edx-054h]
        mov dword [viewscrolly], eax
        cmp eax, 1A8h
        jle short .10
        mov dword [viewscrolly], 1A8h
.10:
        cmp dword [viewscrolly], byte 0
        jge short .11
        xor ebx, ebx
        mov dword [viewscrolly], ebx
.11:
        call SelectRinkBM
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
        mov eax, dword [bgscrollx-2]
        sar eax, 10h
        shl eax, 3
        mov ebx, dword [scrollx-2]
        sar ebx, 10h
        add eax, ebx
        lea ebx, [dword eax+0140h]
        call SetZoneScreen
        xor ecx, ecx
        mov dword [spritedrawcount], ecx
        mov edx, dword [viewscrolly-2]
        sar edx, 10h
        mov eax, dword [viewscrollx-2]
        sar eax, 10h
        call DrawRinkSideObjects
        mov eax, dword [bgscrolly-2]
        sar eax, 10h
        shl eax, 3
        mov edx, dword [scrolly-2]
        sar edx, 10h
        add edx, eax
        neg edx
        mov eax, dword [bgscrollx-2]
        sar eax, 10h
        shl eax, 3
        mov ebx, dword [scrollx-2]
        sar ebx, 10h
        add eax, ebx
        neg eax
        call SetZoneOrigin
        call FlushZones
        mov ebx, 10h
        mov edx, gamepal
        xor eax, eax
        call FadePalette
        call TicksSinceLastCall
        call ClearInputQueue
        xor ebp, ebp
        mov dword [byte esp+014h], ebp
.12:
        call SelectScreenBM
        lea eax, [byte esp+014h]
        call ReplayControlLoop
        test eax, eax
        je near .29
        imul eax, dword [byte esp+014h], byte 6
        add word [replayfrac], ax
        mov ebx, dword [replayfrac-2]
        sar ebx, 10h
        mov ecx, 14h
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ecx
        mov dword [byte esp+014h], eax
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ecx
        mov word [replayfrac], dx
        mov eax, dword [ReplayCtlFlags]
        and eax, byte 3Fh
        cmp eax, byte 10h
        sete al
        xor ah, ah
        movsx edx, ax
        mov eax, dword [byte esp+012h]
        sar eax, 10h
        call ReplayStep
        cwde
        mov dword [byte esp+014h], eax
        call SelectRinkBM
        cmp dword [ReplayCamFree], byte 0
        je near .17
        mov ax, word [replayspotx]
        mov word [camx], ax
        mov ax, word [replayspoty]
        mov word [camy], ax
        cmp word [camx], byte 20h
        jle short .13
        mov word [camx], 20h
        jmp short .14
.13:
        mov eax, dword [camx-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFE0h
        jge short .14
        mov word [camx], 0FFE0h
.14:
        cmp word [camy], 0ECh
        jle short .15
        mov word [camy], 0ECh
        jmp short .16
.15:
        mov eax, dword [camy-2]
        sar eax, 10h
        cmp eax, 0FFFFFF44h
        jge short .16
        mov word [camy], 0FF44h
.16:
        mov eax, dword [camx-2]
        sar eax, 10h
        mov dword [replayspotx], eax
        mov eax, dword [camy-2]
        sar eax, 10h
        mov dword [replayspoty], eax
        jmp near .21
.17:
        cmp word [replayfollowpl], byte 0
        jl near .21
        mov eax, dword [replayfollowpl-2]
        sar eax, 10h
        mov dx, word [nosplit eax*2+rpl_x]
        mov word [camx], dx
        mov ax, word [nosplit eax*2+rpl_y]
        mov word [camy], ax
        cmp dx, byte 20h
        jle short .18
        mov word [camx], 20h
        jmp short .19
.18:
        mov eax, dword [camx-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFE0h
        jge short .19
        mov word [camx], 0FFE0h
.19:
        cmp word [camy], 0ECh
        jle short .20
        mov word [camy], 0ECh
        jmp short .21
.20:
        mov eax, dword [camy-2]
        sar eax, 10h
        cmp eax, 0FFFFFF44h
        jge short .21
        mov word [camy], 0FF44h
.21:
        mov eax, dword [camx-2]
        sar eax, 10h
        add eax, byte 20h
        mov dword [viewscrollx], eax
        cmp eax, byte 40h
        jle short .22
        mov dword [viewscrollx], 40h
.22:
        cmp dword [viewscrollx], byte 0
        jge short .23
        xor ebp, ebp
        mov dword [viewscrollx], ebp
.23:
        mov eax, dword [camy-2]
        sar eax, 10h
        mov edx, 140h
        sub edx, eax
        lea eax, [byte edx-054h]
        mov dword [viewscrolly], eax
        cmp eax, 1A8h
        jle short .24
        mov dword [viewscrolly], 1A8h
.24:
        cmp dword [viewscrolly], byte 0
        jge short .25
        xor ecx, ecx
        mov dword [viewscrolly], ecx
.25:
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
        xor ebp, ebp
        mov dword [spritedrawcount], ebp
        mov edx, dword [viewscrolly-2]
        sar edx, 10h
        mov eax, dword [viewscrollx-2]
        sar eax, 10h
        call DrawRinkSideObjects
        cmp dword [gadgetptry], 0A8h
        jge near .28
        mov edx, dword [ReplayHoverPlayer]
        cmp edx, byte 0FFFFFFFFh
        jne short .26
        mov dword [ReplayHoverPrev], edx
        mov eax, dword [camx-2]
        sar eax, 10h
        add eax, dword [gadgetptrx]
        sub eax, 0A0h
        mov dword [replayptrx], eax
        mov eax, dword [camy-2]
        sar eax, 10h
        sub eax, dword [gadgetptry]
        add eax, byte 54h
        mov dword [replayptry], eax
        push byte 0
        mov ax, word [replayptry]
        inc eax
        movsx ebx, ax
        mov ax, word [replayptrx]
        inc eax
        movsx edx, ax
        xor ecx, ecx
        mov eax, 188h
        call DrawFrameSprite
        jmp near .28
.26:
        push byte 1
        mov eax, edx
        mov dx, word [nosplit edx*2+rpl_y]
        inc edx
        movsx ebx, dx
        mov ax, word [nosplit eax*2+rpl_x]
        inc eax
        movsx edx, ax
        xor ecx, ecx
        mov eax, 188h
        call DrawFrameSprite
        mov eax, dword [ReplayHoverPrev]
        mov ebx, dword [ReplayHoverPlayer]
        cmp eax, ebx
        je short .28
        mov eax, ebx
        mov ebx, dword [nosplit ebx*2+dressedskaters]
        sar ebx, 10h
        mov edx, dword [camx-2]
        sar edx, 10h
        sub ebx, edx
        add ebx, 0A0h
        mov dword [gadgetptrx], ebx
        mov eax, dword [nosplit eax*2+rpl_x_e16]
        sar eax, 10h
        mov edx, dword [camy-2]
        sar edx, 10h
        sub edx, eax
        add edx, byte 54h
        mov dword [gadgetptry], edx
        cmp edx, 0A7h
        jle short .27
        mov dword [gadgetptry], 0A7h
.27:
        mov eax, dword [gadgetptry]
        push eax
        mov edx, dword [gadgetptrx]
        push edx
        call MouseSetPos
        add esp, byte 8
        mov eax, dword [ReplayHoverPlayer]
        mov dword [ReplayHoverPrev], eax
.28:
        mov eax, dword [bgscrolly-2]
        sar eax, 10h
        shl eax, 3
        mov edx, dword [scrolly-2]
        sar edx, 10h
        add edx, eax
        neg edx
        mov eax, dword [bgscrollx-2]
        sar eax, 10h
        shl eax, 3
        mov ebx, dword [scrollx-2]
        sar ebx, 10h
        add eax, ebx
        neg eax
        call SetZoneOrigin
        call FlushZones
        call TicksSinceLastCall
        mov dword [byte esp+014h], eax
        jmp near InstantReplay.12
.29:
        call CrowdNoiseOff
        mov ecx, 0FFFFFFFFh
        mov word [lastsfx], cx
        mov word [replaysfx], cx
        mov eax, dword [byte esp+01Ch]
        mov word [camx], ax
        mov eax, dword [byte esp+020h]
        mov word [camy], ax
        movsx eax, di
        mov dword [viewscrollx], eax
        mov eax, dword [byte esp+016h]
        sar eax, 10h
        mov dword [viewscrolly], eax
        mov word [crowdlevel], si
        movsx eax, si
        mov dword [crowdsmooth], eax
        mov eax, 1
        mov dword [dword_C66D4], eax
        mov dword [dword_C66D0], eax
        push savepal
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, savepal
        mov eax, 1
        call FadePalette
        mov ebx, dword [gadgetfile]
        push ebx
        call FreeMemBlock
        add esp, byte 4
        call SetScreenTarget
        cmp dword [esp], byte 0
        jne short .30
        mov edx, 1E0h
        mov eax, 280h
        call SetScreenSize
.30:
        add esp, byte 24h
        jmp near DrawGadgetButton_ret
;-----------------------------------------------------------------------------
; GadgetHitTest                                7E8E5  95 PC, medium confidence
; Hit-test 10 gadget button rects
;-----------------------------------------------------------------------------
; C: src/front/replay_controls/GadgetHitTest.c
%ifdef CBUILD
%include "c/front/replay_controls/GadgetHitTest.inc"
%else
GadgetHitTest:
        push dword 10h
        call __CHK
        push ecx
        push esi
        push edi
        mov ecx, eax
        mov esi, edx
        mov edi, ebx
        xor edx, edx
        lea ecx, [byte eax+05h]
.1:
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        cmp ecx, dword [dword eax+gadgetrects]
        jl short .2
        cmp ecx, dword [dword eax+gadgetrect_x1]
        jg short .2
        cmp esi, dword [dword eax+gadgetrect_y0]
        jl short .2
        cmp esi, dword [dword eax+gadgetrect_y1]
        jg short .2
        mov dword [edi], edx
        mov eax, 1
        pop edi
        pop esi
        pop ecx
        ret
.2:
        inc edx
        cmp edx, byte 0Ah
        jl short GadgetHitTest.1
        xor eax, eax
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; PickNearestPlayer                            7E93E  95 PC, medium confidence
; Nearest of 17 objects (skipping 12..15) within 10px of pointer
;-----------------------------------------------------------------------------
; C: src/front/replay_controls/PickNearestPlayer.c
%ifdef CBUILD
%include "c/front/replay_controls/PickNearestPlayer.inc"
%else
PickNearestPlayer:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov edi, eax
        mov dword [esp], edx
        mov esi, 0FFFFFFFFh
        mov ecx, 2710h
        xor eax, eax
        mov ebp, dword [esp]
.1:
        cmp eax, byte 0Ch
        jl short .2
        cmp eax, byte 0Fh
        jle short .3
.2:
        mov ebx, dword [nosplit eax*2+dressedskaters]
        sar ebx, 10h
        sub ebx, edi
        mov edx, dword [nosplit eax*2+rpl_x_e16]
        sar edx, 10h
        sub edx, ebp
        imul ebx, ebx
        imul edx, edx
        add edx, ebx
        cmp edx, byte 64h
        jg short .3
        cmp edx, ecx
        jge short .3
        mov ecx, edx
        mov esi, eax
.3:
        inc eax
        cmp eax, byte 11h
        jl short PickNearestPlayer.1
        mov eax, esi
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ReplayControlLoop                            7E9AC  95 PC, medium confidence
; Input loop for replay gadget buttons
;-----------------------------------------------------------------------------
; C: src/front/replay_controls/DrawGadgetButton.c (ReplayControlLoop)
%ifdef CBUILD
%include "c/front/replay_controls/DrawGadgetButton.ReplayControlLoop.inc"
%else
ReplayControlLoop:
        push dword 3Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        mov esi, eax
        xor edi, edi
        mov eax, dword [ReplayCtlFlags]
        mov dword [byte esp+04h], eax
        mov eax, dword [gadgetptrx]
        mov dword [byte esp+08h], eax
        mov ebp, dword [gadgetptry]
        mov dword [byte esp+0Ch], edi
        mov ecx, 13Fh
.1:
        call GetInputEvent
        test eax, eax
        je short .4
        mov ebx, gadgetptry
        mov edx, gadgetptrx
        call dword [ptrupdatefn]
        mov dword [byte esp+0Ch], eax
        cmp dword [gadgetptrx], 140h
        jl short .2
        mov dword [gadgetptrx], ecx
.2:
        cmp dword [gadgetptry], 0C8h
        jl short .3
        mov dword [gadgetptry], 0C7h
.3:
        test byte [byte esp+0Ch], 2
        je short ReplayControlLoop.1
.4:
        mov dl, byte [byte esp+0Ch]
        test dl, 1
        je short .5
        mov dword [replaybtnarmed], 1
        jmp short .6
.5:
        test dl, 2
        je short .6
        xor ebx, ebx
        mov dword [replaybtnarmed], ebx
.6:
        mov eax, dword [replaybtnarmed]
        test eax, eax
        je short .9
        mov edx, dword [gadgetptry]
        mov eax, dword [gadgetptrx]
        mov ebx, esp
        call GadgetHitTest
        test eax, eax
        je short .7
        cmp dword [replaynosave], byte 0
        je short .8
        cmp dword [esp], byte 7
        jne short .8
.7:
        xor eax, eax
        jmp short .9
.8:
        mov cl, byte [esp]
        mov eax, 1
        shl eax, cl
.9:
        mov dword [esp], eax
        mov edx, dword [gadgetptry]
        cmp edx, 0A8h
        jge short .10
        mov eax, dword [camx-2]
        sar eax, 10h
        add eax, dword [gadgetptrx]
        sub eax, 0A0h
        mov dword [replayptrx], eax
        mov eax, dword [camy-2]
        sar eax, 10h
        sub eax, edx
        add eax, byte 54h
        mov dword [replayptry], eax
.10:
        mov eax, dword [ReplayCtlFlags]
        and eax, byte 54h
        mov edx, dword [ReplayCtlFlags]
        and edx, byte 40h
        mov ebx, dword [esp]
        cmp ebx, byte 10h
        jb short .12
        jbe near .15
        cmp ebx, byte 40h
        jb short .11
        jbe near .29
        cmp ebx, 80h
        jb near .32
        jbe near .30
        cmp ebx, 100h
        je near .31
        jmp near .32
.11:
        cmp ebx, byte 20h
        je near .19
        jmp near .32
.12:
        cmp ebx, byte 2
        jb short .13
        jbe near .20
        cmp ebx, byte 4
        jb near .32
        jbe short .14
        cmp ebx, byte 8
        je near .25
        jmp near .32
.13:
        cmp ebx, byte 1
        je short .18
        jmp near .32
.14:
        or dl, 4
        mov dword [ReplayCtlFlags], edx
        jmp near .46
.15:
        mov eax, dword [ReplayCtlFlags]
        and eax, byte 3Fh
        cmp eax, byte 10h
        je short .16
        xor ebx, ebx
        mov word [replayfrac], bx
.16:
        mov eax, dword [ReplayCtlFlags]
        and eax, byte 40h
        or al, 10h
        mov dword [ReplayCtlFlags], eax
.17:
        mov edi, dword [esi]
        jmp near .47
.18:
        or al, 1
        mov dword [ReplayCtlFlags], eax
        mov edi, dword [esi]
        shl edi, 2
        neg edi
        jmp near .47
.19:
        or al, 20h
        mov dword [ReplayCtlFlags], eax
        mov edi, dword [esi]
        shl edi, 2
        jmp near .47
.20:
        test byte [ReplayCtlFlags], 2
        je short .22
        mov eax, dword [esi]
        mov edx, dword [ReplaySpeedAccum]
        add edx, eax
        mov dword [ReplaySpeedAccum], edx
        cmp edx, byte 5
        jge short .21
        xor edi, edi
        jmp short .23
.21:
        mov edi, 0FFFFFFFFh
        lea ecx, [byte edx-05h]
        mov dword [ReplaySpeedAccum], ecx
        jmp short .23
.22:
        xor edi, edi
        mov dword [ReplaySpeedAccum], edi
        mov edi, 0FFFFFFFFh
        mov word [replayfrac], 0FFF2h
.23:
        mov eax, dword [ReplayCtlFlags]
        and eax, byte 40h
        or al, 6
.24:
        mov dword [ReplayCtlFlags], eax
        jmp near .47
.25:
        test byte [ReplayCtlFlags], 8
        je short .27
        mov eax, dword [esi]
        mov edx, dword [ReplaySpeedAccum]
        add edx, eax
        mov dword [ReplaySpeedAccum], edx
        cmp edx, byte 5
        jge short .26
        xor edi, edi
        jmp short .28
.26:
        mov edi, 1
        lea ecx, [byte edx-05h]
        mov dword [ReplaySpeedAccum], ecx
        jmp short .28
.27:
        xor edi, edi
        mov dword [ReplaySpeedAccum], edi
        mov edi, 1
        mov word [replayfrac], 0Eh
.28:
        mov eax, dword [ReplayCtlFlags]
        and eax, byte 40h
        or al, 0Ch
        jmp short ReplayControlLoop.24
.29:
        or byte [ReplayCtlFlags], 40h
        xor edi, edi
        mov dword [ReplayCamFree], edi
        mov eax, 0FFFFFFFFh
        mov dword [ReplayHoverPlayer], eax
        mov dword [ReplayHoverPrev], eax
        mov word [replayfollowpl], 0FFFFh
        jmp near .47
.30:
        or dl, 84h
        mov dword [ReplayCtlFlags], edx
        jmp near .47
.31:
        xor eax, eax
        jmp near .63
.32:
        cmp dword [gadgetptry], 0A8h
        jge near .45
        mov edx, dword [replayptry]
        mov eax, dword [replayptrx]
        call PickNearestPlayer
        mov dword [ReplayHoverPlayer], eax
        test byte [byte esp+0Ch], 2
        je near .45
        cmp eax, byte 0FFFFFFFFh
        jne near .38
        mov dword [ReplayCamFree], 1
        mov dword [ReplayHoverPrev], eax
        mov word [replayfollowpl], 0FFFFh
        mov eax, dword [replayptrx]
        mov dword [replayspotx], eax
        mov eax, dword [replayptry]
        mov dword [replayspoty], eax
        mov eax, dword [replayspotx]
        mov dword [gadgetptrx], eax
        mov eax, dword [replayspoty]
        mov dword [gadgetptry], eax
        mov edi, dword [gadgetptrx]
        cmp edi, byte 20h
        jle short .33
        mov dword [gadgetptrx], 20h
        jmp short .34
.33:
        cmp edi, byte 0FFFFFFE0h
        jge short .34
        mov dword [gadgetptrx], 0FFFFFFE0h
.34:
        mov ecx, dword [gadgetptry]
        cmp ecx, 0ECh
        jle short .35
        mov dword [gadgetptry], 0ECh
        jmp short .36
.35:
        cmp ecx, 0FFFFFF44h
        jge short .36
        mov dword [gadgetptry], 0FFFFFF44h
.36:
        mov eax, dword [replayspotx]
        sub eax, dword [gadgetptrx]
        add eax, 0A0h
        mov dword [gadgetptrx], eax
        mov eax, dword [gadgetptry]
        sub eax, dword [replayspoty]
        add eax, byte 54h
        mov dword [gadgetptry], eax
        cmp eax, 0A7h
        jle short .37
        mov dword [gadgetptry], 0A7h
.37:
        mov edx, dword [gadgetptry]
        push edx
        mov ebx, dword [gadgetptrx]
        push ebx
        call MouseSetPos
        add esp, byte 8
        jmp near .44
.38:
        xor edx, edx
        mov dword [ReplayCamFree], edx
        mov dx, word [ReplayHoverPlayer]
        mov word [replayfollowpl], dx
        mov edx, dword [nosplit eax*2+dressedskaters]
        sar edx, 10h
        mov dword [gadgetptrx], edx
        mov eax, dword [nosplit eax*2+rpl_x_e16]
        sar eax, 10h
        mov dword [gadgetptry], eax
        cmp edx, byte 20h
        jle short .39
        mov dword [gadgetptrx], 20h
        jmp short .40
.39:
        cmp edx, byte 0FFFFFFE0h
        jge short .40
        mov dword [gadgetptrx], 0FFFFFFE0h
.40:
        mov edx, dword [gadgetptry]
        cmp edx, 0ECh
        jle short .41
        mov dword [gadgetptry], 0ECh
        jmp short .42
.41:
        cmp edx, 0FFFFFF44h
        jge short .42
        mov dword [gadgetptry], 0FFFFFF44h
.42:
        mov eax, dword [ReplayHoverPlayer]
        mov edx, dword [nosplit eax*2+dressedskaters]
        sar edx, 10h
        sub edx, dword [gadgetptrx]
        add edx, 0A0h
        mov dword [gadgetptrx], edx
        mov eax, dword [nosplit eax*2+rpl_x_e16]
        sar eax, 10h
        mov edx, dword [gadgetptry]
        sub edx, eax
        lea eax, [byte edx+054h]
        mov dword [gadgetptry], eax
        cmp eax, 0A7h
        jle short .43
        mov dword [gadgetptry], 0A7h
.43:
        mov eax, dword [gadgetptry]
        push eax
        mov edx, dword [gadgetptrx]
        push edx
        call MouseSetPos
        add esp, byte 8
        mov eax, dword [ReplayHoverPlayer]
        mov dword [ReplayHoverPrev], eax
.44:
        and dword [ReplayCtlFlags], byte 14h
.45:
        and dword [ReplayCtlFlags], byte 54h
        test byte [ReplayCtlFlags], 10h
        jne near ReplayControlLoop.17
.46:
        xor edi, edi
.47:
        mov eax, dword [byte esp+08h]
        cmp eax, dword [gadgetptrx]
        jne short .48
        cmp ebp, dword [gadgetptry]
        jne short .48
        mov eax, dword [byte esp+04h]
        cmp eax, dword [ReplayCtlFlags]
        je near .61
.48:
        mov eax, dword [byte esp+04h]
        cmp eax, dword [ReplayCtlFlags]
        jne near .57
        mov edx, dword [pointerspr]
        mov eax, dword [byte edx+02h]
        sar eax, 10h
        mov ebx, dword [byte esp+08h]
        add eax, ebx
        mov edx, dword [byte edx+04h]
        sar edx, 10h
        sub ebp, 0A8h
        add edx, ebp
        test ebx, ebx
        jge short .49
        xor ebx, ebx
        mov dword [byte esp+08h], ebx
        jmp short .50
.49:
        cmp ebx, 140h
        jle short .50
        mov dword [byte esp+08h], 140h
.50:
        test ebp, ebp
        jge short .51
        xor ebp, ebp
        jmp short .52
.51:
        cmp ebp, byte 20h
        jle short .52
        mov ebp, 20h
.52:
        test eax, eax
        jge short .53
        xor eax, eax
        jmp short .54
.53:
        cmp eax, 140h
        jle short .54
        mov eax, 140h
.54:
        test edx, edx
        jge short .55
        xor edx, edx
        jmp short .56
.55:
        cmp edx, byte 20h
        jle short .56
        mov edx, 20h
.56:
        push edx
        push ebp
        push eax
        mov ecx, dword [byte esp+014h]
        push ecx
        call SetClipWindow
        add esp, byte 10h
.57:
        push byte 0
        push byte 0
        mov ebp, dword [gadgetshape]
        push ebp
        call VgaBlitKeyedFlipV
        add esp, byte 0Ch
        mov eax, dword [byte esp+04h]
        cmp eax, dword [ReplayCtlFlags]
        jne short .58
        push byte 20h
        push byte 0
        push dword 140h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
.58:
        xor ebx, ebx
        mov dword [esp], ebx
.59:
        mov cl, byte [esp]
        mov eax, 1
        shl eax, cl
        test dword [ReplayCtlFlags], eax
        je short .60
        mov eax, dword [esp]
        call DrawGadgetButton
.60:
        mov ebp, dword [esp]
        inc ebp
        mov dword [esp], ebp
        cmp ebp, byte 9
        jl short ReplayControlLoop.59
        mov edx, dword [gadgetptry]
        cmp edx, 0A8h
        jl short .61
        lea eax, [dword edx-0A8h]
        push eax
        mov ebx, dword [gadgetptrx]
        push ebx
        mov ecx, dword [pointerspr]
        push ecx
        call DrawArt
        add esp, byte 0Ch
.61:
        test byte [ReplayCtlFlags], 80h
        je short .62
        xor ebp, ebp
        mov dword [replaybtnarmed], ebp
        mov ebx, dword [gadgetptry]
        mov edx, dword [gadgetptrx]
        xor eax, eax
        call ReplaySaveHilight
        call ClearInputQueue
        mov dword [ReplayCtlFlags], 4
        call SelectScreenBM
        push byte 20h
        push ebp
        push dword 140h
        push ebp
        call SetClipWindow
        add esp, byte 10h
        push ebp
        push ebp
        mov edx, dword [gadgetshape]
        push edx
        call VgaBlitKeyed
        add esp, byte 0Ch
        mov eax, 2
        call DrawGadgetButton
        mov eax, dword [gadgetptry]
        sub eax, 0A8h
        push eax
        mov ebx, dword [gadgetptrx]
        push ebx
        mov ecx, dword [pointerspr]
        push ecx
        call DrawArt
        add esp, byte 0Ch
.62:
        mov dword [esi], edi
        mov eax, 1
.63:
        add esp, byte 10h
        jmp near DrawGadgetButton_ret
%endif ; C
        db 08Bh,0C0h
ReplaySaveHilight_jt:
        dd ReplaySaveHilight_n0
        dd ReplaySaveHilight_n1
        dd ReplaySaveHilight_n2
        dd ReplaySaveHilight_n3
;-----------------------------------------------------------------------------
; ReplaySaveHilight                            7F0AF  95 PC, medium confidence
; Gadget button 7: picks team, writes highlight (sub_7FA10), "Insufficient
; disk space to save hilights." message
;-----------------------------------------------------------------------------
ReplaySaveHilight:
        push dword 94h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 64h
        push edx
        push ebx
        call SetScreenTarget
        mov edx, dword [ctl1team]
        test edx, edx
        jl short .1
        mov ebx, dword [ctl2team]
        test ebx, ebx
        jl short .1
        cmp edx, ebx
        jne near .9
.1:
        push byte 64h
        call SetTickDeadline
        add esp, byte 4
        mov edi, dword [ctl1team]
        test edi, edi
        jl short .3
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        cmp eax, edi
        jne short .2
        xor eax, edi
        jmp short .5
.2:
        mov eax, 1
        jmp short .5
.3:
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        mov ebp, dword [ctl2team]
        cmp eax, ebp
        jne short .4
        xor eax, ebp
        jmp short .5
.4:
        mov eax, 1
.5:
        call SaveHilight
        mov dword [byte esp+068h], eax
        cmp dword [byte esp+068h], byte 0
        je near .8
        lea eax, [byte esp+08h]
        push eax
        call TextSaveState
        add esp, byte 4
        mov ecx, dword [mainfont]
        push ecx
        call TextSetFont
        add esp, byte 4
        push dword 1F4h
        call SetTickDeadline
        add esp, byte 4
        push byte 0
        mov ecx, 59h
        mov ebx, 11h
        mov edx, ecx
        mov eax, 14h
        call SetDialogColors
        push byte 0
        push byte 0
        push byte 0
        push byte 0
        push byte 0
        mov ecx, 3
        mov ebx, msg_NoHilightSpace
        xor edx, edx
        xor eax, eax
        call MessageBox
        lea eax, [byte esp+08h]
        push eax
        call TextRestoreState
        add esp, byte 4
        mov esi, dword [gadgetfile]
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov ecx, str_PPV
        mov ebx, str_Gadget6
        cmp byte [fileoncd+0223h], 1
        jne short .6
        mov edx, dword [cddriveptr]
        jmp short .7
.6:
        xor edx, edx
.7:
        lea eax, [byte esp+048h]
        call MakePath
        push byte 0
        lea eax, [byte esp+04Ch]
        push eax
        call OpenArtArchiveErr
        add esp, byte 8
        mov dword [gadgetfile], eax
        push str_Gad1
        push eax
        call FindShape
        add esp, byte 8
        mov dword [gadgetshape], eax
        call WaitTickDeadline
        call RestoreDialogBg
        jmp near ReplaySaveHilight_n3.x
.8:
        call WaitTickDeadline
        jmp near ReplaySaveHilight_n3.x
.9:
        call SelectScreenBM
        push byte 20h
        push byte 0
        push dword 0F0h
        push dword 0C2h
        call SetClipWindow
        add esp, byte 10h
        push byte 0
        push byte 0
        mov esi, dword [gadgetshape]
        push esi
        call VgaBlitKeyedFlipV
        add esp, byte 0Ch
        mov eax, 7
        call DrawGadgetButton
        call SetScreenTarget
        push dword 0C8h
        push byte 0
        push dword 140h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        mov eax, dword [pointerspr]
        mov edx, dword [byte eax+02h]
        sar edx, 10h
        mov eax, dword [byte eax+04h]
        sar eax, 10h
        imul edx, eax
        lea ecx, [byte edx+011h]
        push byte 20h
        push ecx
        push str_Pointer19
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
        mov eax, dword [pointerspr]
        mov ax, word [byte eax+04h]
        mov edx, ebp
        mov word [byte edx+04h], ax
        mov eax, dword [pointerspr]
        mov ax, word [byte eax+06h]
        mov word [byte edx+06h], ax
        call HilightSaveToDlg
        mov dword [hilightslot], 3
        mov dword [gadgetptrx], 0EEh
        mov dword [gadgetptry], 8Ah
        push dword 96h
        push dword 136h
        push byte 4Bh
        push byte 0
        call SetViewRect
        add esp, byte 10h
        push dword 8Ah
        push dword 0EEh
        call MouseSetPos
        add esp, byte 8
        push dword 8Ah
        push dword 0EEh
        mov ebx, ebp
        push ebx
        call GrabBlock
        add esp, byte 0Ch
        push dword 8Ah
        push dword 0EEh
        mov ecx, dword [pointerspr]
        push ecx
        call DrawArt
        add esp, byte 0Ch
        call ClearInputQueue
        xor esi, esi
        mov dword [byte esp+068h], esi
.10:
        test byte [byte esp+068h], 2
        jne near .18
.11:
        call GetInputEvent
        test eax, eax
        je short ReplaySaveHilight.11
        mov ecx, dword [gadgetptrx]
        mov esi, dword [gadgetptry]
        mov ebx, gadgetptry
        mov edx, gadgetptrx
        call dword [ptrupdatefn]
        mov dword [byte esp+068h], eax
        test al, 2
        je near .17
        mov ebx, dword [gadgetptrx]
        cmp ebx, byte 4Eh
        jl near .16
        cmp ebx, 0D8h
        jg near .16
        mov edx, dword [gadgetptry]
        cmp edx, byte 50h
        jl short .12
        cmp edx, byte 5Eh
        jg short .12
        xor edx, edx
        mov dword [hilightslot], edx
        jmp near .17
.12:
        mov edi, dword [gadgetptry]
        cmp edi, byte 61h
        jl short .13
        cmp edi, byte 6Fh
        jg short .13
        mov dword [hilightslot], 1
        jmp short .17
.13:
        mov edx, dword [gadgetptry]
        cmp edx, byte 72h
        jl short .14
        cmp edx, 80h
        jg short .14
        mov dword [hilightslot], 2
        jmp short .17
.14:
        mov edi, dword [gadgetptry]
        cmp edi, 83h
        jl short .15
        cmp edi, 91h
        jg short .15
        mov dword [hilightslot], 3
        jmp short .17
.15:
        xor edx, edx
        mov dword [byte esp+068h], edx
        jmp short .17
.16:
        xor eax, eax
        mov dword [byte esp+068h], eax
.17:
        push esi
        push ecx
        push ebp
        call DrawArt
        add esp, byte 0Ch
        mov ebx, dword [gadgetptry]
        push ebx
        mov ecx, dword [gadgetptrx]
        push ecx
        push ebp
        call GrabBlock
        add esp, byte 0Ch
        mov esi, dword [gadgetptry]
        push esi
        mov edi, dword [gadgetptrx]
        push edi
        mov eax, dword [pointerspr]
        push eax
        call DrawArt
        add esp, byte 0Ch
        jmp near ReplaySaveHilight.10
.18:
        push byte 64h
        call SetTickDeadline
        add esp, byte 4
        push dword 0C8h
        push byte 0
        push dword 140h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        push byte 10h
        mov edx, dword [hilightslot]
        mov eax, edx
        shl eax, 4
        add eax, edx
        lea edx, [byte eax+05Eh]
        push edx
        push byte 4Eh
        add eax, byte 50h
        push eax
        push byte 4Eh
        call FillRectColor
        add esp, byte 14h
        push byte 10h
        mov edx, dword [hilightslot]
        mov eax, edx
        shl eax, 4
        add eax, edx
        add eax, byte 50h
        push eax
        push dword 0D8h
        push eax
        push byte 4Eh
        call FillRectColor
        add esp, byte 14h
        push byte 59h
        mov edx, dword [hilightslot]
        mov eax, edx
        shl eax, 4
        add eax, edx
        add eax, byte 5Eh
        push eax
        push dword 0D8h
        push eax
        push byte 4Fh
        call FillRectColor
        add esp, byte 14h
        push byte 59h
        mov edx, dword [hilightslot]
        mov eax, edx
        shl eax, 4
        add eax, edx
        lea edx, [byte eax+05Eh]
        push edx
        push dword 0D8h
        add eax, byte 51h
        push eax
        push dword 0D8h
        call FillRectColor
        add esp, byte 14h
        push byte 13h
        mov edx, dword [hilightslot]
        mov eax, edx
        shl eax, 4
        add eax, edx
        add eax, byte 50h
        push eax
        push dword 0D8h
        call PlotPixel
        add esp, byte 0Ch
        push byte 13h
        mov edx, dword [hilightslot]
        mov eax, edx
        shl eax, 4
        add eax, edx
        add eax, byte 5Eh
        push eax
        push byte 4Eh
        call PlotPixel
        add esp, byte 0Ch
        mov edi, dword [gadgetptry]
        push edi
        mov eax, dword [gadgetptrx]
        push eax
        mov edx, dword [pointerspr]
        push edx
        call DrawArt
        add esp, byte 0Ch
        mov eax, dword [hilightslot]
        cmp eax, byte 3
        ja short ReplaySaveHilight_n3.1
        jmp dword [nosplit cs:eax*4+ReplaySaveHilight_jt]
ReplaySaveHilight_n0:
        xor eax, eax
        jmp short ReplaySaveHilight_n1.1
ReplaySaveHilight_n2:
        xor eax, eax
        call SaveHilight
        mov dword [byte esp+068h], eax
        test eax, eax
        jne short ReplaySaveHilight_n3.1
ReplaySaveHilight_n1:
        mov eax, 1
.1:
        call SaveHilight
        mov dword [byte esp+068h], eax
        jmp short ReplaySaveHilight_n3.1
ReplaySaveHilight_n3:
        xor ebx, ebx
        mov dword [byte esp+068h], ebx
.1:
        cmp dword [byte esp+068h], byte 0
        je near .4
        push dword 1F4h
        call SetTickDeadline
        add esp, byte 4
        push byte 0
        mov ecx, 59h
        mov ebx, 11h
        mov edx, ecx
        mov eax, 14h
        call SetDialogColors
        push byte 0
        push byte 0
        push byte 0
        push byte 0
        push byte 0
        mov ecx, 3
        mov ebx, msg_NoHilightSpace
        xor edx, edx
        xor eax, eax
        call MessageBox
        mov esi, dword [gadgetfile]
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov ecx, str_PPV
        mov ebx, str_Gadget6
        cmp byte [fileoncd+0223h], 1
        jne short .2
        mov edx, dword [cddriveptr]
        jmp short .3
.2:
        xor edx, edx
.3:
        lea eax, [byte esp+048h]
        call MakePath
        push byte 0
        lea eax, [byte esp+04Ch]
        push eax
        call OpenArtArchiveErr
        add esp, byte 8
        mov dword [gadgetfile], eax
        push str_Gad1
        push eax
        call FindShape
        add esp, byte 8
        mov dword [gadgetshape], eax
        call WaitTickDeadline
        call RestoreDialogBg
        jmp short .5
.4:
        call WaitTickDeadline
.5:
        call NudgeRinkScroll
        mov eax, dword [byte esp+04h]
        mov dword [gadgetptrx], eax
        mov eax, dword [esp]
        mov dword [gadgetptry], eax
        push eax
        mov eax, dword [byte esp+08h]
        push eax
        call MouseSetPos
        add esp, byte 8
        cmp dword [byte esp+068h], byte 0
        je short .6
        push dword 1F4h
        call SetTickDeadline
        add esp, byte 4
        push byte 0
        mov ecx, 59h
        mov ebx, 11h
        mov edx, ecx
        mov eax, 14h
        call SetDialogColors
        call SetScreenTarget
        push byte 0
        push byte 0
        push byte 0
        push byte 0
        push byte 0
        mov ecx, 3
        mov ebx, msg_NoHilightSpace
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        call WaitTickDeadline
        call RestoreDialogBg
.6:
        push dword 0C8h
        push byte 0
        push dword 140h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        push ebp
        call FreeMemBlock
        add esp, byte 4
        push dword 0C1h
        push dword 140h
        push byte 0
        push byte 0
        call SetViewRect
        add esp, byte 10h
.x:
        add esp, byte 6Ch
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
