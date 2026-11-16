; One frame of a played game, including a highlight that borrows another
; game's teams and then puts the current game back.
bits 32
%include "hockey.inc"
section s_69336 progbits alloc exec nowrite align=1
extern __CHK, assreplace, awlinetab, awscore, awtmap, awtmgoalie, awtmline, awtmstruct
extern bannermsg, bannertimer, bgscrollx, bgscrolly, c1playernum, c2playernum, camx, camx_m2
extern camy, ClearPenaltyBuffer, clockticks, cont1team, cont2team, Crowd_Noise, CrowdFadeOut, crowdlevel
extern crowdsmooth, curperiod, CwdExciteLvl, demomode, DoGameFrame, DrawHudPanel, DrawRinkOverlays, oneminsaid
extern starthl2pos, dword_D8C72, dword_D8C7A, hmtmtouch2, hmtmtouch3, awtmtouch3, ovlartbank, SpeechPatchNext
extern energywarn, escrequest, exitgame, fadeinpending, FadeOutPalCycle, FadePalette, FlushGSumQueue, forcepldata
extern FreeMemBlock, gameclock, gameopts, gameover, gamepal, gmode, gmode2, gsp
extern hmlinetab, hmscore, hmtmap, hmtmgoalie, hmtmline, hmtmstruct, HomeTeam, hudclockhund
extern hudclockmin, hudclocksec, hudhundaccum, hudhundstep, icingPlayer, iflags, inputframes, Intermission
extern joyq_flush, joysampling, joysampling_save, lastsfx, lcblink, lcboxon, lcline, LoadGameTeams
extern LoadPlayerPhotos, LoadRink, LoadTeamPalette, MusicChanReset2, musicon, ovlseq, ovlstep, ovltimer
extern PaHighlightIntro, PaOpenBank, passplayer, Pencntdwn, puckc, puckstruct, puckx, pucky
extern randomd0, ReadJoy1, ReadJoy2, reenergizeteam, RefPen, refsignal, RefStep, regd1
extern ResetBench, ResetInputSampling, resetplstuff, restoreteams, rinkhtiles, rinkscrollx, rinkscrolly, rinkwtiles
extern RunGameFrames, savepal, scrollx, scrolly, setpersonel, SetRinkScroll, SetScreenSize, setupice
extern sflags, sflags3, ShowLoadingScreen, SortCords, SpeechBusy, spritedrawcount, SprSort, SprSortVert
extern StopDigiSample, EnsureFreeMemory, FlushZones, SetZoneScreen, SetZoneOrigin, BeginZoneFrame, ReleaseAllVoices, SetPalette
extern TicksSinceLastCall, UpdateHudPanel, viewscrollx, viewscrolly, VisTeam, vtoa, penaltysc, SortPending
extern injurystop, hmtmtouch1, awtmtouch1, awtmtouch2, puckcross2, puckcross6, refYpos2, refXvel
extern refYvel, xc1, yc1, yleader
global StartHL2
;-----------------------------------------------------------------------------
; StartHL2                         69336  94G penalty94.asm, medium confidence
; A team's line table, 30h bytes
;-----------------------------------------------------------------------------
; C: src/engine/frame/StartHL2.c
%ifdef CBUILD
%include "c/engine/frame/StartHL2.inc"
%else
StartHL2:
        push dword 120h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, 0F8h
        push eax
        push edx
        push ebx
        mov ebp, ecx
        xor edx, edx
        mov dword [oneminsaid], edx
        mov ax, word [gameover]
        mov dword [dword esp+0F8h], eax
        mov ax, word [HomeTeam]
        mov word [byte esp+0Ch], ax
        lea eax, [byte esp+0Ch]
        add eax, byte 2
        mov dx, word [VisTeam]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [hmtmgoalie]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [awtmgoalie]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [cont1team]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [cont2team]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [curperiod]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [gsp]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [hmtmap]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [awtmap]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [hmscore]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [awscore]
        mov word [eax], dx
        xor edi, edi
        add eax, byte 2
.1:
        mov edx, edi
        shl edx, 8
        add edx, hmtmstruct
        add edx, byte 7Eh
        xor esi, esi
.2:
        mov bx, word [edx]
        mov word [eax], bx
        add edx, byte 2
        add eax, byte 2
        inc esi
        cmp esi, byte 1Ch
        jl short StartHL2.2
        inc edi
        cmp edi, byte 2
        jl short StartHL2.1
        mov eax, dword [gameopts]
        mov dword [dword esp+0F4h], eax
        mov ecx, 0Ch
        lea edi, [dword esp+0C4h]
        mov esi, hmlinetab
        rep movsd
        mov ecx, 0Ch
        lea edi, [dword esp+094h]
        mov esi, awlinetab
        rep movsd
        call FlushGSumQueue
        and byte [gameopts], 0E4h
        xor edx, edx
        mov word [gameover], dx
        mov word [CwdExciteLvl], dx
        mov eax, dword [byte esp+08h]
        mov word [HomeTeam], ax
        mov eax, dword [byte esp+04h]
        mov word [VisTeam], ax
        mov eax, 2
        call LoadGameTeams
        mov eax, dword [ovlseq-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        je short .3
        mov ebx, dword [ovlartbank]
        push ebx
        call FreeMemBlock
        add esp, byte 4
.3:
        mov edx, dword [VisTeam-2]
        sar edx, 10h
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        mov ebx, gamepal
        call LoadTeamPalette
        call LoadPlayerPhotos
        xor ecx, ecx
        mov word [awtmgoalie], cx
        mov word [hmtmgoalie], cx
        call restoreteams
        mov edi, 0FFFFFFFFh
        mov word [c2playernum], di
        mov word [c1playernum], di
        mov word [cont2team], cx
        mov word [cont1team], cx
        mov eax, 78h
        call randomd0
        add eax, 3Ch
        mov word [gameclock], ax
        mov word [clockticks], cx
        mov ebx, dword [gameclock-2]
        sar ebx, 10h
        mov ecx, 3Ch
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ecx
        mov dword [hudclockmin], eax
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ecx
        mov dword [hudclocksec], edx
        xor ecx, ecx
        mov dword [hudclockhund], ecx
        mov eax, dword [dword esp+0114h]
        mov dword [curperiod], eax
        mov eax, dword [dword esp+0114h]
        dec eax
        mov word [gsp], ax
        mov eax, dword [esp]
        mov ax, word [eax]
        mov word [hmscore], ax
        mov ax, word [byte ebp+00h]
        mov word [awscore], ax
        mov eax, 7
        call randomd0
        movsx edx, ax
        mov ebx, 4
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov word [hmtmline], dx
        mov eax, 7
        call randomd0
        movsx edx, ax
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov word [awtmline], dx
        call FadeOutPalCycle
        mov edx, 0C8h
        mov eax, 140h
        call SetScreenSize
        cmp word [HomeTeam], byte 1Ah
        jl short .4
        mov eax, 0Ch
        jmp short .5
.4:
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
.5:
        call LoadRink
        mov ebx, dword [curperiod]
        mov edx, dword [VisTeam-2]
        sar edx, 10h
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        xor ecx, ecx
        call DrawHudPanel
        xor dl, dl
        mov byte [gmode], dl
        mov byte [gmode], 10h
        test byte [gsp], 1
        je short .9
        cmp word [gsp], byte 3
        jne short .6
        test byte [gameopts+1], 2
        jne short .7
.6:
        mov eax, 1
        jmp short .8
.7:
        xor eax, eax
.8:
        test eax, eax
        je short .9
        or byte [gmode], 2
.9:
        mov ax, word [gmode2]
        mov dword [dword esp+0FCh], eax
        xor eax, eax
        mov word [sflags3], ax
        xor edx, edx
        mov word [gmode2], ax
        xor ebx, ebx
        mov word [sflags], ax
        mov word [gmode2], 4
        xor ch, ch
        mov byte [icingPlayer], ch
        xor al, al
        mov byte [iflags], al
        mov esi, 0FFFFFFFFh
        mov word [passplayer], si
        xor edi, edi
        mov word [refsignal], dx
        mov eax, esi
        mov word [RefStep], si
        mov edx, esi
        mov word [Pencntdwn], si
        mov word [RefPen], bx
        mov ecx, esi
        mov word [penaltysc], si
        mov word [ovltimer], si
        mov word [SortPending], di
        mov word [bannermsg], si
        mov word [ovlstep], si
        mov ebx, esi
        mov word [ovlseq], si
        xor ecx, esi
        mov word [bannertimer], cx
        xor esi, esi
        mov word [injurystop], si
        mov word [crowdlevel], si
        xor esi, esi
        mov dword [crowdsmooth], esi
        mov word [puckcross6], ax
        mov word [puckcross2], ax
        call setupice
        call SprSortVert
        xor ebx, edx
        mov word [camy], bx
        xor ecx, ecx
        mov word [camx], cx
        mov word [yleader], cx
        mov word [yc1], cx
        mov word [xc1], cx
        add dword [rinkscrollx], 3E8h
        add dword [rinkscrolly], 3E8h
        call ResetBench
        mov eax, hmtmstruct
        call reenergizeteam
        mov eax, hmtmstruct
        call setpersonel
        mov eax, hmtmstruct
        call forcepldata
        mov word [hmtmtouch3], dx
        mov ebx, edx
        mov word [hmtmtouch2], bx
        mov word [hmtmtouch1], bx
        mov eax, awtmstruct
        call reenergizeteam
        mov eax, awtmstruct
        call setpersonel
        mov eax, awtmstruct
        call forcepldata
        mov word [awtmtouch3], bx
        mov word [awtmtouch2], bx
        mov word [awtmtouch1], bx
        call resetplstuff
        mov ebx, SortCords
        xor edi, edi
.10:
        test byte [byte ebx+pflags], 80h
        je short .11
        xor edx, edx
        jmp short .12
.11:
        mov edx, 6
.12:
        mov eax, dword [byte ebx+position-2]
        sar eax, 10h
        add edx, eax
        lea esi, [edx+edx]
        mov eax, 14h
        call randomd0
        sub eax, byte 0Ah
        mov dword [dword esp+0100h], eax
        mov ax, word [nosplit edx*4+starthl2pos]
        mov edx, dword [dword esp+0100h]
        add eax, edx
        mov word [byte ebx+Xpos+2], ax
        mov cx, word [byte ebx+position]
        test cx, cx
        sete al
        mov edx, eax
        and edx, 0FFh
        test cx, cx
        jne short .13
        mov eax, 4
        jmp short .14
.13:
        mov eax, 14h
.14:
        cwde
        call randomd0
        cwde
        sub eax, edx
        je short .15
        mov eax, 4
        jmp short .16
.15:
        mov eax, 0Ah
.16:
        mov edx, dword [nosplit esi*2+starthl2pos]
        sar edx, 10h
        add eax, edx
        mov word [byte ebx+Ypos+2], ax
        mov word [byte ebx+Yvel], 0
        mov ax, word [byte ebx+Yvel]
        mov word [byte ebx+Xvel], ax
        mov eax, dword [pucky]
        mov ax, word [eax]
        sub ax, word [byte ebx+Ypos+2]
        movsx edx, ax
        mov eax, dword [puckx]
        mov ax, word [eax]
        sub ax, word [byte ebx+Xpos+2]
        cwde
        call vtoa
        mov word [byte ebx+facedir], ax
        inc edi
        add ebx, 80h
        cmp edi, byte 0Ch
        jl near StartHL2.10
        mov word [puckstruct+28h], 78h
        mov eax, 14h
        call randomd0
        sub eax, byte 0Ah
        mov word [puckstruct+2], ax
        mov eax, 14h
        call randomd0
        sub eax, byte 0Ah
        mov word [puckstruct+6], ax
        xor edi, edi
        mov word [puckstruct+0Ah], di
        mov eax, 7D0h
        call randomd0
        db 081h,0E8h,0E8h,03h,00h,00h           ; insn: sub eax,3E8h
        mov word [puckstruct+0Ch], ax
        mov eax, 7D0h
        call randomd0
        db 081h,0E8h,0E8h,03h,00h,00h           ; insn: sub eax,3E8h
        mov word [puckstruct+0Eh], ax
        mov word [puckstruct+12h], 18Ah
        mov word [puckstruct+54h], di
        mov edx, 18h
        mov eax, puckstruct
        call assreplace
        mov ebx, puckstruct
        add ebx, 80h
        mov word [byte ebx+012h], 189h
        mov word [byte ebx+054h], di
        mov edx, 19h
        mov eax, ebx
        call assreplace
        mov word [SortCords+802h], 0FF88h
        mov word [refYpos2], di
        mov esi, 2
        mov word [SortCords+836h], si
        mov word [refYvel], di
        mov word [refXvel], di
        mov edx, 1Fh
        mov eax, SortCords+800h
        call assreplace
        call DoGameFrame
        call DoGameFrame
        call SprSort
        xor edi, edi
        xor edx, edx
        mov dword [hudhundaccum], edi
        mov dword [inputframes], edi
        mov eax, dword [puckc]
        mov byte [eax], 0FFh
        mov dword [joysampling], edi
        call joyq_flush
        xor edx, edi
        mov word [exitgame], dx
        mov word [gameover], dx
        mov word [fadeinpending], si
        call TicksSinceLastCall
        mov esi, 1
        mov dword [joysampling], esi
        mov dword [demomode], esi
        mov dword [escrequest], edi
.17:
        cmp word [exitgame], byte 0
        jne near .26
        call ResetInputSampling
        mov edx, eax
        shl eax, 2
        sub eax, edx
        add eax, eax
        add edi, eax
        mov ebx, 0Ah
        mov eax, edi
        mov edx, edi
        sar edx, 1Fh
        idiv ebx
        mov esi, eax
        mov eax, edi
        mov edx, edi
        sar edx, 1Fh
        idiv ebx
        mov edi, edx
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
        mov ebx, dword [viewscrollx]
        cmp ebx, byte 40h
        jle short .18
        mov dword [viewscrollx], 40h
        jmp short .19
.18:
        test ebx, ebx
        jge short .19
        xor eax, eax
        mov dword [viewscrollx], eax
.19:
        mov ebx, dword [viewscrolly]
        cmp ebx, 1A8h
        jle short .20
        mov dword [viewscrolly], 1A8h
        jmp short .21
.20:
        test ebx, ebx
        jge short .21
        xor eax, eax
        mov dword [viewscrolly], eax
.21:
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
        mov edx, dword [bgscrolly-2]
        sar edx, 10h
        shl edx, 3
        mov eax, dword [scrolly-2]
        sar eax, 10h
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
        cmp word [fadeinpending], byte 0
        je short .22
        mov ax, word [joysampling]
        mov word [joysampling_save], ax
        xor ecx, ecx
        mov dword [joysampling], ecx
        push savepal
        push dword 100h
        push ecx
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, savepal
        mov eax, 1
        call FadePalette
        mov eax, dword [joysampling_save-2]
        sar eax, 10h
        mov dword [joysampling], eax
.22:
        movsx eax, si
        call Crowd_Noise
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
        je short .23
        mov eax, dword [gameclock-2]
        sar eax, 10h
        mov edx, dword [clockticks-2]
        sar edx, 10h
        or eax, edx
        jne short .23
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
.23:
        call UpdateHudPanel
        mov bx, word [fadeinpending]
        test bx, bx
        je short .25
        mov ax, word [joysampling]
        mov word [joysampling_save], ax
        xor esi, esi
        mov dword [joysampling], esi
        cmp bx, byte 2
        jne short .24
        call PaOpenBank
        mov edx, dword [byte esp+04h]
        mov eax, dword [byte esp+08h]
        call PaHighlightIntro
        mov ebx, 10h
        mov edx, gamepal
        xor eax, eax
        call FadePalette
        xor esi, esi
        mov word [fadeinpending], si
        mov eax, 0C8h
        call randomd0
        add eax, 64h
        mov word [crowdlevel], ax
        mov eax, dword [crowdlevel-2]
        sar eax, 10h
        mov dword [crowdsmooth], eax
.24:
        mov eax, dword [joysampling_save-2]
        sar eax, 10h
        mov dword [joysampling], eax
.25:
        cmp dword [escrequest], byte 0
        jne short .26
        call ReadJoy1
        mov dl, byte [regd1]
        test dl, 10h
        jne short .26
        test dl, 20h
        jne short .26
        call ReadJoy2
        mov bl, byte [regd1]
        test bl, 10h
        jne short .26
        test bl, 20h
        je near StartHL2.17
.26:
        xor edx, edx
        mov dword [joysampling], edx
        mov eax, dword [ovlseq-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        je short .27
        mov ebx, dword [ovlartbank]
        push ebx
        call FreeMemBlock
        add esp, byte 4
.27:
        mov edi, 0FFFFFFFFh
        mov word [bannermsg], di
        mov word [ovlstep], di
        mov word [ovlseq], di
        xor ecx, ecx
        mov dword [demomode], ecx
        mov dword [oneminsaid], ecx
        push savepal
        push dword 100h
        push ecx
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, savepal
        mov eax, 1
        call FadePalette
        call CrowdFadeOut
        xor ebx, ebx
        mov word [crowdlevel], bx
        xor edi, edi
        mov dword [crowdsmooth], edi
        cmp byte [musicon], 0
        je short .29
        test byte [gameopts+1], 1
        je short .29
        call MusicChanReset2
.28:
        call SpeechBusy
        test eax, eax
        jne short StartHL2.28
        jmp short .30
.29:
        call ReleaseAllVoices
.30:
        call StopDigiSample
        mov word [exitgame], 0FFFFh
        mov edx, 1E0h
        mov eax, 280h
        call SetScreenSize
        cmp dword [escrequest], byte 0
        jne short .31
        mov eax, 222E0h
        call EnsureFreeMemory
        call ShowLoadingScreen
.31:
        mov eax, dword [dword esp+0F8h]
        mov word [gameover], ax
        mov eax, dword [byte esp+0Ch]
        mov word [HomeTeam], ax
        lea eax, [byte esp+0Ch]
        add eax, byte 2
        mov dx, word [eax]
        mov word [VisTeam], dx
        add eax, byte 2
        mov dx, word [eax]
        mov word [hmtmgoalie], dx
        add eax, byte 2
        mov dx, word [eax]
        mov word [awtmgoalie], dx
        add eax, byte 2
        mov dx, word [eax]
        mov word [cont1team], dx
        add eax, byte 2
        mov dx, word [eax]
        mov word [cont2team], dx
        add eax, byte 2
        movsx edx, word [eax]
        mov dword [curperiod], edx
        add eax, byte 2
        mov dx, word [eax]
        mov word [gsp], dx
        add eax, byte 2
        mov dx, word [eax]
        mov word [hmtmap], dx
        add eax, byte 2
        mov dx, word [eax]
        mov word [awtmap], dx
        mov edx, dword [hmscore-2]
        sar edx, 10h
        mov ebx, dword [esp]
        mov dword [ebx], edx
        mov edx, dword [awscore-2]
        sar edx, 10h
        mov dword [byte ebp+00h], edx
        add eax, byte 2
        mov dx, word [eax]
        mov word [hmscore], dx
        add eax, byte 2
        mov dx, word [eax]
        mov word [awscore], dx
        xor edi, edi
        add eax, byte 2
.32:
        mov edx, edi
        shl edx, 8
        add edx, hmtmstruct
        add edx, byte 7Eh
        xor esi, esi
.33:
        mov bx, word [eax]
        mov word [edx], bx
        add eax, byte 2
        add edx, byte 2
        inc esi
        cmp esi, byte 1Ch
        jl short StartHL2.33
        inc edi
        cmp edi, byte 2
        jl short StartHL2.32
        mov eax, dword [dword esp+0F4h]
        mov dword [gameopts], eax
        mov ecx, 0Ch
        mov edi, hmlinetab
        lea esi, [dword esp+0C4h]
        rep movsd
        mov ecx, 0Ch
        mov edi, awlinetab
        lea esi, [dword esp+094h]
        rep movsd
        mov eax, 4
        call LoadGameTeams
        call Intermission
        xor al, al
        mov byte [gmode], al
        mov ah, 1
        mov byte [gmode], ah
        test byte [gsp], ah
        je short .37
        cmp word [gsp], byte 3
        jne short .34
        test byte [gameopts+1], 2
        jne short .35
.34:
        mov eax, 1
        jmp short .36
.35:
        xor eax, eax
.36:
        test eax, eax
        je short .37
        or byte [gmode], 2
.37:
        xor edi, edi
        mov word [sflags3], di
        mov word [gmode2], di
        mov word [sflags], di
        mov eax, dword [dword esp+0FCh]
        mov word [gmode2], ax
        mov eax, dword [puckc]
        mov byte [eax], 0FFh
        mov word [ovltimer], 0FFFFh
        mov word [camx], di
        mov word [camy], di
        mov edx, dword [VisTeam-2]
        sar edx, 10h
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        mov ebx, gamepal
        call LoadTeamPalette
        mov word [energywarn+2], di
        mov word [energywarn], di
        mov word [lcblink+2], di
        mov word [lcblink], di
        mov ecx, 0FFFFFFFFh
        mov word [lcline+2], cx
        mov word [lcline], cx
        mov word [lcboxon+2], di
        mov word [lcboxon], di
        mov word [fadeinpending], 1
        xor edx, edx
        mov dword [hudhundaccum], edx
        mov word [refsignal], di
        mov word [RefStep], cx
        mov edx, 1Eh
        mov eax, SortCords+800h
        call assreplace
        call ClearPenaltyBuffer
        mov word [Pencntdwn], cx
        call joyq_flush
        cmp dword [escrequest], byte 0
        je short .38
        xor ecx, ecx
        mov dword [escrequest], ecx
        mov eax, 0FFFFFFFFh
        jmp short .x
.38:
        xor eax, eax
.x:
        add esp, 104h
        pop ebp
        pop edi
        pop esi
        ret 4
%endif ; C
