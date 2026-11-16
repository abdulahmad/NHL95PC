; The skate-out before the puck drops, and the three stars after the game. One module: the stars
; share PreGameIntro's exits.
bits 32
%include "hockey.inc"
section s_47C31 progbits alloc exec nowrite align=1
extern __CHK, AddPenalty, AddPenalty2, assexit, assinsert, assreplace, awscore, awtmap
extern awtmstruct, bannermsg, bannertimer, bgscrollx, bgscrolly, teamrocktune, starskatermin, stargoaliemin
extern Endfaceoff_ftab_m1, hmplattr_b13, awplattr_b13, byte_DF87F, byte_DFFE2, curevent, goalevent, goalevent_b1
extern goalevent_b2, goalevent_b3, goalevent_b4, c1playernum, c2playernum, camx, camx_m2, camy
extern changeplayer, check4bench, check4check, checkob, checkpuckcoll, chk4lc, chk4pass, chk4shot
extern ChkOffsides, ChkPullGoalieLate, ChkScorerMilestone, clockticks, CloseTextOverlay, cont2team, Crowd_Noise, CrowdFadeOut
extern crowdlevel, CrowdNoiseReset, curperiod, deferpending, dirtab, dirtab_y, DoGameFrame, doorpflags
extern doortemp1, doplayeracc, doshot, DrawRinkOverlays, hmlinetimer, awlinetimer, dword_CBEBE, demoflag
extern dword_CC9AD, introstandanims_m2, assscore_dancecnt, goaliesave_saveanim_m2, refsigspa_m2, ShootoutPathData, ShootoutPathData_y, ShootoutPathData_end
extern dword_D8C72, dword_D8C7A, hmplstats_m2, hmplstats, hmtmextra, hmtmtouch3, hmtmnear, awtmtouch3
extern awtmnear, sctemp4, ovlartbank, fofdata2_m2, regd3_m2, SpeechPatchNext, dword_E9AB6, dword_E9AB7
extern EndPenaltyShot, energywarn, escrequest, EvadePC, EvadePlayers, exitgame, fadeinpending, FadePalette
extern Findhittype, findpc, fodir1, fodir2, fofdata2, forcepldata, FormatPlayerName, fox
extern foy, frameaccum, FreeMemBlock, gameclock, gameopts, gameover, gamepal, GetHot
extern getlchoice, gmode, gmode2, goalieacc, gsp, gwgplayer, gwgteam, hmroster
extern hmrosterjersey, hmscore, hmteamrec, hmtmap, hmtmpde, hmtmpdst_m2, hmtmstruct, HomeTeam
extern icingPlayer, iflags, imul32, inputframes, introskipped, IsCupClinched, joyq_flush, joysampling
extern joysampling_save, lasttouch, lcblink, lcblinktime, lcboxon, lcline, lcrequest, lcsel
extern lctimer, lj1, loadpals, loadscreenon, LoadScreenPalTick, LoadTeamPPV, ltx, lty
extern MarkTwoLinePlayers, MusicChanReset, musicon, ovlseq, ovlstep, ovltimer, PaGoal, palcyclelock
extern PaPlayerNumber, PaSpeechBusy, passdir, passspeed, PBnum, Penaltytimer, PenBuf, Pencntdwn
extern PenShotAssign, penshotlive, penshotmode, penshotplayer, penshotstart, penshotteam, periodendtime, PerTimeTotal
extern PlayCrowdSample, playeracc, PostGoalEvent, psendcount, pspathdir, pspathside, puckc, puckcross
extern PuckIChk, puckshadow, puckstruct, pucktemp1, puckvx, puckvy, puckvz, puckx
extern pucky, puckz, qsort_, QueueGoalieNote, randomd0, ReadJoy1, ReadJoy2, reenergizeteam
extern RefPen, refsignal, RefStep, regd0, regd1, regd2, regd3, regd4
extern RemoveFromLines, RemoveTimerCallback, ResetInputSampling, resetplstuff, rinkhtiles, rinkscrollx, rinkscrolly, rinkwtiles
extern RunGameFrames, savepal, scrollx, scrolly, seed, SelectScreenBM, seqtimer, SetBoxDoorObject
extern setpersonel, Setplass, setplayer, SetRinkScroll, SetShotMode, SetSPA, SetTickDeadline, sflags
extern sflags3, sfx, ShotLaneOpen, ShotMode, shotongoal, shotplayer, shownumbers, skateto
extern skatetopuck, SkateToSpot, sopathend, sopathpoint, sopathx, sopathy, SortCords, sortobj15
extern sounddev, SpeechStopQueue, sprintf_, spritedrawcount, SprSort, starordtab, starpl, startm
extern startm_m2, StopDigiSample, stopna, str_EASports, str_StarFmt, FlushZones, SetZoneScreen, SetZoneOrigin
extern BeginZoneFrame, ReleaseAllVoices, SetPalette, teamabbrevs, textline1, textline2, textline3, textline4
extern textline5, threat, TicksSinceLastCall, unk_C1B3E, hmplattr, hmglstats, sortobj11, updateanim
extern UpdateHudPanel, vecdist, viewscrollx, viewscrolly, VisTeam, vtoa, WaitTickDeadline, penaltysc
extern SortPending, injurystop, word_CC9CC, assstarskate_path, assstarskate_path_y, asswingo_dedata, asswingo_dedata_xrand, asswingo_dedata_y
extern asswingo_dedata_yrand, asscentero_dedata, asscentero_dedata_xrand, asscentero_dedata_y, asscentero_dedata_yrand, asspuckc_postab2, asspuckc_postab2_y, refsigdir
extern hmplstats_w2, hmglstats_w2, hmglstats_w4, hmglstats_w8, hmglstats_w14, hmtmtouch1, puckcross2, puckcross6
extern refYpos2, refXvel, refYvel, refframe, reftemp1, reftemp3, reftemp4, reftemp5
extern fofdata2_w2, fofdata2_w4, fofdata2_w6, penevteam, GoalState, xc1, yc1, yleader
global FadeOutPalCycle, PreGameIntro, PreGameIntro_scroll, PreGameIntro_frameloop, PreGameIntro_end, PreGameIntro_popebp, PreGameIntro_popx, StartPreGame
global ThreeStarsLoop, ThreeStarsLoop_tick, assintrostand, assintroline, AddStar, StarEligible, StarCompare, PickThreeStars
global StartThreeStars, MoveInDir, SteerToTarget, assstarskate, assthreestars
;-----------------------------------------------------------------------------
; FadeOutPalCycle                              47C31  95 PC, medium confidence
; When loadscreenon is set: with palcyclelock = 1 (pauses the timer handler
; LoadScreenPalTick, which cycles 3 palettes loadpals, 300h bytes each)
; decrements every palette byte by 1 per tick until all are 0, then
; re-installs LoadScreenPalTick (RemoveTimerCallback) and clears
; loadscreenon; called when leaving many front-end screens
;-----------------------------------------------------------------------------
; C: src/engine/intro/FadeOutPalCycle.c
%ifdef CBUILD
%include "c/engine/intro/FadeOutPalCycle.inc"
%else
FadeOutPalCycle:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push ebp
        cmp dword [loadscreenon], byte 0
        je near .x
        xor esi, esi
.1:
        test esi, esi
        jne short .5
        mov esi, 1
        mov dword [palcyclelock], esi
        xor ecx, ecx
.2:
        xor edx, edx
.3:
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 8
        add eax, edx
        mov bl, byte [dword eax+loadpals]
        test bl, bl
        jle short .4
        mov bh, bl
        dec bh
        mov byte [dword eax+loadpals], bh
        cmp esi, byte 1
        jne short .4
        xor esi, esi
.4:
        inc edx
        cmp edx, 300h
        jl short FadeOutPalCycle.3
        inc ecx
        cmp ecx, byte 3
        jl short FadeOutPalCycle.2
        xor ebp, ebp
        mov dword [palcyclelock], ebp
        push byte 2
        call SetTickDeadline
        add esp, byte 4
        call WaitTickDeadline
        jmp short FadeOutPalCycle.1
.5:
        mov dword [palcyclelock], 1
        push LoadScreenPalTick
        call RemoveTimerCallback
        add esp, byte 4
        xor ecx, ecx
        mov dword [loadscreenon], ecx
.x:
        pop ebp
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; PreGameIntro                                 47CD6  95 PC, medium confidence
; Pre-game ceremony: PlayCrowdSample(0Ah), big-screen animation 3 or 4
; (LoadTeamPPV), clears the message lines, seqtimer = 708h, reenergizeteam /
; setpersonel / forcepldata for both teams, lines the skaters up near the
; blue lines (y -DCh / DCh, then random x spots, SetSPA 99h, assignment 25h),
; puck assignment 1Ah, referee at centre (assignment 26h), then the shared
; frame loop (PreGameIntro_frameloop: scroll, DrawRinkOverlays,
; CrowdNoiseUpdate) until a joystick button (Readjoy1/2 bits 4-5) or the end
;-----------------------------------------------------------------------------
; C: src/engine/intro/FadeOutPalCycle.c (PreGameIntro)
%ifdef CBUILD
%include "c/engine/intro/FadeOutPalCycle.PreGameIntro.inc"
%else
PreGameIntro:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 10h
        mov eax, 0Ah
        call PlayCrowdSample
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        movsx dx, byte [dword eax+teamrocktune]
        mov dword [byte esp+08h], edx
        mov edi, dword [dword eax+teamrocktune-3]
        sar edi, 18h
        mov di, word [nosplit edi*2+word_CC9CC]
        cmp dx, byte 1
        setne al
        and eax, 0FFh
        add eax, byte 3
        cwde
        call LoadTeamPPV
        xor ah, ah
        mov byte [textline5], ah
        mov byte [textline4], ah
        mov byte [textline2], ah
        xor bl, bl
        mov byte [textline1], ah
        xor bh, bh
        mov byte [textline3], ah
        mov dword [curperiod], 0FFFFFFFFh
        mov word [foy], bx
        xor ecx, ecx
        mov word [fox], cx
        mov edx, dword [HomeTeam-2]
        sar edx, 10h
        shl edx, 10h
        mov eax, dword [VisTeam-2]
        sar eax, 10h
        add eax, edx
        add dword [seed], eax
        xor ecx, ecx
        mov dword [shownumbers], ecx
        mov dword [seqtimer], 708h
        xor esi, esi
        mov word [exitgame], si
        mov eax, 0FFFFFFFFh
        mov word [c2playernum], ax
        mov word [c1playernum], ax
        mov eax, hmtmstruct
        call reenergizeteam
        mov eax, hmtmstruct
        call setpersonel
        mov eax, hmtmstruct
        call forcepldata
        mov eax, awtmstruct
        call reenergizeteam
        mov eax, awtmstruct
        call setpersonel
        mov eax, awtmstruct
        call forcepldata
        call resetplstuff
        mov ebx, sortobj11
        mov dword [byte esp+0Ch], esi
        jmp near .16
.1:
        xor esi, esi
        jmp short .3
.2:
        movsx eax, si
        xor ch, ch
        mov byte [esp+eax], ch
        inc esi
.3:
        cmp si, byte 5
        jl short PreGameIntro.2
        xor esi, esi
        jmp near .15
.4:
        mov ax, word [byte ebx+position]
        test ax, ax
        jne short .9
        mov word [byte ebx+Xpos+2], ax
        mov word [byte ebx+temp3], ax
        test byte [byte ebx+pflags], 80h
        je short .5
        mov eax, 0FFFFFF24h
        jmp short .6
.5:
        mov eax, 0DCh
.6:
        mov word [byte ebx+Ypos+2], ax
        mov word [byte ebx+temp4], ax
        mov word [byte ebx+temp5], 0FF9Ch
        mov word [byte ebx+Yvel], 0
        mov ax, word [byte ebx+Yvel]
        mov word [byte ebx+Xvel], ax
        test byte [byte ebx+pflags], 80h
        je short .7
        xor eax, eax
        jmp short .8
.7:
        mov eax, 4
.8:
        mov word [byte ebx+facedir], ax
        mov edx, 99h
        mov eax, ebx
        call SetSPA
        jmp near .14
.9:
        mov eax, 5
        call randomd0
        mov edx, eax
.10:
        movsx eax, dx
        cmp byte [esp+eax], 0
        je short .11
        lea edx, [byte eax+01h]
        mov ecx, 5
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        jmp short PreGameIntro.10
.11:
        mov byte [esp+eax], 1
        imul edx, byte 28h
        sub edx, byte 50h
        mov eax, 8
        call randomd0
        sub eax, byte 4
        add edx, eax
        mov word [byte ebx+Xpos+2], dx
        mov word [byte ebx+temp3], dx
        mov eax, 2
        call randomd0
        add word [byte ebx+Xpos+2], ax
        test byte [byte ebx+pflags], 80h
        je short .12
        mov edx, 0FFFFFFC6h
        jmp short .13
.12:
        mov edx, 30h
.13:
        mov eax, 4
        call randomd0
        cwde
        sub eax, byte 2
        add edx, eax
        mov word [byte ebx+Ypos+2], dx
        mov word [byte ebx+temp4], dx
        mov word [byte ebx+facedir], 4
        mov word [byte ebx+Yvel], 0
        mov ax, word [byte ebx+Yvel]
        mov word [byte ebx+Xvel], ax
        mov eax, 28h
        call randomd0
        sub eax, byte 14h
        mov edx, edi
        add edx, eax
        mov word [byte ebx+temp5], dx
        xor edx, edx
        mov eax, ebx
        call SetSPA
        mov word [byte ebx+012h], 171h
.14:
        mov edx, 25h
        mov eax, ebx
        call assreplace
        inc esi
        sub ebx, 80h
.15:
        cmp si, byte 6
        jl near PreGameIntro.4
        inc dword [byte esp+0Ch]
.16:
        cmp word [byte esp+0Ch], byte 2
        jl near PreGameIntro.1
        mov word [puckstruct+28h], 78h
        mov word [puckstruct+2], 0C8h
        mov word [puckstruct+6], 0FED4h
        xor ecx, ecx
        mov word [puckstruct+0Ch], cx
        xor esi, esi
        mov word [puckstruct+0Eh], cx
        mov edx, 1Ah
        mov eax, puckstruct
        call assreplace
        mov eax, dword [byte esp+08h]
        mov word [reftemp1], ax
        mov eax, 8Eh
        mov word [SortCords+802h], ax
        mov word [reftemp3], ax
        mov eax, 2
        call randomd0
        add word [SortCords+802h], ax
        mov word [refYpos2], cx
        mov word [reftemp4], cx
        mov word [SortCords+836h], 4
        mov word [refYvel], cx
        mov word [refXvel], cx
        mov word [reftemp5], di
        xor edx, edx
        mov eax, SortCords+800h
        call SetSPA
        mov word [refframe], 289h
        mov edx, 26h
        mov eax, SortCords+800h
        call assreplace
        mov word [RefStep], si
        or byte [sflags], 40h
        call DoGameFrame
        call DoGameFrame
        call SprSort
        xor edi, edi
        mov dword [frameaccum], edi
        mov dword [inputframes], edi
        mov eax, dword [puckc]
        mov byte [eax], 0FFh
        mov dword [joysampling], edi
        call joyq_flush
        xor edi, edi
        mov word [camx], di
        mov word [xc1], si
        mov word [camy], si
        mov word [yc1], si
        mov dword [viewscrollx], 20h
        mov dword [viewscrolly], 0ECh
        mov eax, dword [ovlseq-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        je short .17
        call CloseTextOverlay
.17:
        call SelectScreenBM
        xor ebx, ebx
        mov word [lcblink+2], bx
        mov word [lcblink], bx
        mov word [energywarn+2], bx
        mov word [energywarn], bx
        call UpdateHudPanel
        add esp, byte 10h
        jmp near PreGameIntro_popx
%endif ; C
; C: src/engine/intro/FadeOutPalCycle.c (PreGameIntro_scroll)
%ifdef CBUILD
%include "c/engine/intro/FadeOutPalCycle.PreGameIntro_scroll.inc"
%else
PreGameIntro_scroll:
        test ecx, ecx
        jge short PreGameIntro_frameloop
        xor ebp, ebp
        mov dword [viewscrollx], ebp
PreGameIntro_frameloop:
        mov edx, dword [viewscrolly]
        cmp edx, 1A8h
        jle short .1
        mov dword [viewscrolly], 1A8h
        jmp short .2
.1:
        test edx, edx
        jge short .2
        xor ecx, ecx
        mov dword [viewscrolly], ecx
.2:
        xor edx, edx
        xor eax, eax
        call SetZoneOrigin
        call BeginZoneFrame
        mov edx, dword [viewscrolly]
        mov eax, dword [viewscrollx]
        call SetRinkScroll
        mov edx, dword [bgscrolly-2]
        sar edx, 10h
        shl edx, 3
        mov eax, dword [scrolly-2]
        sar eax, 10h
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
        xor ebp, ebp
        mov dword [spritedrawcount], ebp
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
        je short .3
        mov ax, word [joysampling]
        mov word [joysampling_save], ax
        xor eax, eax
        mov dword [joysampling], ebp
        mov ebx, 10h
        mov edx, gamepal
        call FadePalette
        xor ebx, ebx
        mov word [fadeinpending], bx
        mov eax, dword [joysampling_save-2]
        sar eax, 10h
        mov dword [joysampling], eax
.3:
        movsx eax, si
        call Crowd_Noise
        cmp dword [escrequest], byte 0
        jne short PreGameIntro_end
        call ReadJoy1
        mov ah, byte [regd1]
        test ah, 10h
        jne short .4
        test ah, 20h
        je short .5
.4:
        mov dword [introskipped], 1
        mov word [fadeinpending], 1
        jmp short PreGameIntro_end
.5:
        call ReadJoy2
        mov dh, byte [regd1]
        test dh, 10h
        jne short PreGameIntro_frameloop.4
        test dh, 20h
        jne short PreGameIntro_frameloop.4
        call WaitTickDeadline
        jmp near ThreeStarsLoop_tick
%endif ; C
; C: src/engine/intro/FadeOutPalCycle.c (PreGameIntro_end)
%ifdef CBUILD
%include "c/engine/intro/FadeOutPalCycle.PreGameIntro_end.inc"
%else
PreGameIntro_end:
        xor esi, esi
        mov dword [joysampling], esi
        mov eax, dword [ovlseq-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        je short .1
        mov edi, dword [ovlartbank]
        push edi
        call FreeMemBlock
        add esp, byte 4
        mov word [ovlseq], 0FFFFh
.1:
        mov ebp, dword [escrequest]
        test ebp, ebp
        je short .2
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
        call StopDigiSample
        call SpeechStopQueue
        xor edx, edx
        mov dword [escrequest], edx
        mov eax, 0FFFFFFFFh
        jmp short PreGameIntro_popebp
.2:
        cmp dword [introskipped], byte 0
        je short .3
        push savepal
        push dword 100h
        push ebp
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, savepal
        mov eax, 1
        call FadePalette
.3:
        call StopDigiSample
        call SpeechStopQueue
        xor eax, eax
PreGameIntro_popebp:
        pop ebp
PreGameIntro_popx:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; StartPreGame                                 4830E  95 PC, medium confidence
; Returns 0 when demoflag is set; else runs PreGameIntro unless eax is
; non-zero, then CrowdNoiseReset; called twice from asset_loading game start
; code demoflag is a skip flag; introskipped/fadeinpending follow.
;-----------------------------------------------------------------------------
; C: src/engine/intro/FadeOutPalCycle.c (StartPreGame)
%ifdef CBUILD
%include "c/engine/intro/FadeOutPalCycle.StartPreGame.inc"
%else
StartPreGame:
        push dword 4
        call __CHK
        cmp dword [demoflag], byte 0
        je short .1
        xor eax, eax
        ret
.1:
        test ax, ax
        jne short .2
        call PreGameIntro
.2:
        call CrowdNoiseReset
;-----------------------------------------------------------------------------
; ThreeStarsLoop                               48333  95 PC, medium confidence
; Called at the end of StartThreeStars: per real-time tick
; (ResetInputSampling) counts seqtimer down and steers the scroll targets
; (viewscrollx / viewscrolly) from camx, then jumps into
; PreGameIntro_frameloop to draw the frame
;-----------------------------------------------------------------------------
ThreeStarsLoop:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        call TicksSinceLastCall
        mov dword [joysampling], 1
        xor ebx, ebx
        mov dword [escrequest], ebx
        add dword [rinkscrollx], 3E8h
        add dword [rinkscrolly], 3E8h
ThreeStarsLoop_tick:
        cmp dword [seqtimer], byte 0
        je near PreGameIntro_end
        push byte 4
        call SetTickDeadline
        add esp, byte 4
        call ResetInputSampling
        movsx edx, ax
        mov eax, edx
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
        movsx edx, si
        mov eax, edx
        call RunGameFrames
        mov eax, dword [seqtimer]
        sub eax, edx
        mov dword [seqtimer], eax
        test eax, eax
        jge short .1
        xor ebx, ebx
        mov dword [seqtimer], ebx
.1:
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
        mov ecx, dword [viewscrollx]
        cmp ecx, byte 40h
        jle near PreGameIntro_scroll
        mov dword [viewscrollx], 40h
        jmp near PreGameIntro_frameloop
%endif ; C
;-----------------------------------------------------------------------------
; assintrostand                                4842A  95 PC, medium confidence
; Asstab 25h (PreGameIntro): stands with a countdown in temp5, small random x
; jitter and random fidget animation (introstandanims_m2); when done
; assinsert 27h
;-----------------------------------------------------------------------------
; C: src/engine/intro/assintrostand.c
%ifdef CBUILD
%include "c/engine/intro/assintrostand.inc"
%else
assintrostand:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov ebx, eax
        test byte [byte eax+pflags], 20h
        jne near .x
        mov edx, dword [byte ebx+temp5-2]
        sar edx, 10h
        cmp edx, byte 0FFFFFF9Ch
        je near .x
        mov dx, word [byte ebx+temp5]
        dec edx
        mov word [byte ebx+temp5], dx
        test dx, dx
        jle short .2
        mov eax, 64h
        call randomd0
        test ax, ax
        jne short .1
        mov eax, 2
        call randomd0
        mov dx, word [byte ebx+temp3]
        add edx, eax
        mov word [byte ebx+Xpos+2], dx
.1:
        test byte [byte ebx+pflags2], 2
        jne short .x
        mov eax, 50h
        call randomd0
        test ax, ax
        jne short .x
        mov eax, 9
        call randomd0
        movsx edx, ax
        mov ecx, 5
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov edx, dword [nosplit edx*4+introstandanims_m2]
        sar edx, 10h
        mov eax, ebx
        call SetSPA
        or byte [byte ebx+pflags2], 2
        pop edx
        pop ecx
        pop ebx
        ret
.2:
        mov edx, 27h
        mov eax, ebx
        call assinsert
.x:
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assintroline                                 484DA  95 PC, medium confidence
; Asstab 26h (PreGameIntro): skates to the line-up spot (temp3 -0Fh,temp4),
; turns to face centre, marks temp5 -64h; when all 12 skaters are done sets
; seqtimer 0Ah; crowdlevel 320h
;-----------------------------------------------------------------------------
; C: src/engine/intro/assintroline.c
%ifdef CBUILD
%include "c/engine/intro/assintroline.inc"
%else
assintroline:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push edi
        mov ebx, eax
        test byte [byte eax+pflags], 20h
        jne near .x
        mov eax, dword [byte ebx+temp5-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFF9Ch
        jne short .3
        cmp dword [seqtimer], byte 0Ah
        jle near .x
        xor eax, eax
        jmp short .2
.1:
        mov ebx, eax
        shl ebx, 7
        mov ebx, dword [dword ebx+sctemp4]
        sar ebx, 10h
        cmp ebx, byte 0FFFFFF9Ch
        jne near .x
        inc eax
.2:
        cmp eax, byte 0Ch
        jl short assintroline.1
        mov dword [seqtimer], 0Ah
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.3:
        mov dx, word [byte ebx+temp5]
        test dx, dx
        jle near .7
        mov ecx, edx
        dec ecx
        mov word [byte ebx+temp5], cx
        test cx, cx
        jle short .7
        mov eax, 64h
        call randomd0
        test ax, ax
        jne short .4
        mov eax, 2
        call randomd0
        mov edx, eax
        mov ax, word [byte ebx+temp3]
        add eax, edx
        mov word [byte ebx+Xpos+2], ax
.4:
        test byte [byte ebx+pflags2], 2
        jne near .x
        mov eax, 50h
        call randomd0
        test ax, ax
        jne near .x
        mov eax, 2
        call randomd0
        test ax, ax
        je short .5
        mov eax, 0DABh
        jmp short .6
.5:
        mov eax, 0DC3h
.6:
        movsx edx, ax
        mov eax, ebx
        call SetSPA
        or byte [byte ebx+pflags2], 2
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.7:
        mov dl, byte [byte ebx+pflags]
        test dl, 2
        je short .8
        mov dh, dl
        and dh, 0FDh
        mov byte [byte ebx+pflags], dh
        mov word [byte ebx+temp2], 8
        mov word [byte ebx+temp1], 0
        mov word [byte ebx+temp3], 0FFF1h
        mov word [byte ebx+temp4], 0
        or byte [byte ebx+pflags2], 20h
        mov word [byte ebx+Wallcos], 0
        mov word [byte ebx+Wallsin], 0
        mov edx, 0A5Bh
        mov eax, ebx
        call SetSPA
        xor edi, edi
        mov word [yc1], di
        mov word [RefStep], 1
        mov word [crowdlevel], 320h
.8:
        mov edx, dword [ebx]
        sar edx, 10h
        mov eax, dword [byte ebx+temp3-2]
        sar eax, 10h
        sub edx, eax
        mov eax, edx
        mov ecx, dword [byte ebx+Ypos]
        sar ecx, 10h
        mov edx, dword [byte ebx+temp4-2]
        sar edx, 10h
        sub ecx, edx
        mov edx, ecx
        mov ecx, eax
        imul ecx, ecx
        mov eax, edx
        imul eax, eax
        add eax, ecx
        cmp eax, byte 40h
        jge near .16
        cmp word [byte ebx+Xvel], byte 0
        jge short .9
        mov edx, dword [byte ebx+Xvel-2]
        sar edx, 10h
        neg edx
        jmp short .10
.9:
        mov edx, dword [byte ebx+Xvel-2]
        sar edx, 10h
.10:
        cmp edx, byte 10h
        jge near .16
        cmp word [byte ebx+Yvel], byte 0
        jge short .11
        mov edx, dword [byte ebx+Yvel-2]
        sar edx, 10h
        neg edx
        jmp short .12
.11:
        mov edx, dword [byte ebx+Yvel-2]
        sar edx, 10h
.12:
        cmp edx, byte 10h
        jge near .16
        mov ax, word [byte ebx+temp3]
        mov word [byte ebx+Xpos+2], ax
        mov ax, word [byte ebx+temp4]
        mov word [byte ebx+Ypos+2], ax
        mov di, word [byte ebx+temp1]
        dec edi
        mov word [byte ebx+temp1], di
        test di, di
        jge near .x
        mov edx, edi
        add edx, byte 8
        mov word [byte ebx+temp1], dx
        mov edx, 0A5Bh
        mov eax, ebx
        call SetSPA
        mov ax, word [byte ebx+Ypos+2]
        neg eax
        movsx edx, ax
        mov ax, word [byte ebx+Xpos+2]
        neg eax
        cwde
        call vtoa
        cwde
        mov dword [regd2], eax
        mov ax, word [regd2]
        mov cx, word [byte ebx+facedir]
        cmp ax, cx
        je short .15
        sub eax, ecx
        xor ah, ah
        and al, 7
        mov word [regd2], ax
        cmp ax, 5
        jge short .13
        mov eax, 1
        jmp short .14
.13:
        mov eax, 0FFFFFFFFh
.14:
        mov edx, dword [byte ebx+facedir-2]
        sar edx, 10h
        add eax, edx
        and eax, byte 7
        mov word [byte ebx+facedir], ax
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.15:
        mov word [byte ebx+Yvel], 0
        mov ax, word [byte ebx+Yvel]
        mov word [byte ebx+Xvel], ax
        mov word [byte ebx+temp5], 0FF9Ch
        mov edx, 0C57h
        mov eax, ebx
        call SetSPA
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.16:
        mov dx, word [byte ebx+temp3]
        mov word [regd0], dx
        mov dx, word [byte ebx+temp4]
        mov word [regd1], dx
        cmp eax, 90h
        jle short .17
        xor edx, edx
        mov eax, ebx
        call skateto
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.17:
        xor edx, edx
        mov eax, ebx
        call SkateToSpot
.x:
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; AddStar                                                         48789  95 PC
; PC three stars. eax = list index (0-2), edx = team, ebx = player. Stores (team, player) in startm/starpl
; unless the pair is already in the first eax entries. Returns 1 if added, 0 if a duplicate.
;-----------------------------------------------------------------------------
; C: src/engine/intro/AddStar.c
%ifdef CBUILD
%include "c/engine/intro/AddStar.inc"
%else
AddStar:
        push dword 0Ch
        call __CHK
        push ecx
        push esi
        mov esi, eax
        mov ecx, edx
        xor edx, edx
        jmp short .3
.1:
        mov eax, edx
        shl eax, 2
        cmp cx, word [dword eax+startm]
        jne short .2
        cmp bx, word [dword eax+starpl]
        jne short .2
        xor eax, eax
        pop esi
        pop ecx
        ret
.2:
        inc edx
.3:
        movsx eax, si
        cmp edx, eax
        jl short AddStar.1
        mov word [nosplit eax*4+startm], cx
        mov word [nosplit eax*4+starpl], bx
        mov eax, 1
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; StarEligible                                    487D9  95 PC, low confidence
; (team, roster idx): 0 when the roster slot (hmtmpdst) is below -1 or the
; player's on-ice sprite has +1Ah == 6; else 1. Used by StarCompare when
; picking three stars
;-----------------------------------------------------------------------------
; C: src/engine/intro/StarEligible.c
%ifdef CBUILD
%include "c/engine/intro/StarEligible.inc"
%else
StarEligible:
        push dword 0Ch
        call __CHK
        push ebx
        push ecx
        mov ecx, edx
        mov edx, eax
        shl edx, 8
        mov ebx, ecx
        mov edx, dword [dword edx+ebx*2+hmtmpdst_m2]
        sar edx, 10h
        cmp edx, byte 0FFFFFFFFh
        jge short .2
.1:
        xor eax, eax
        pop ecx
        pop ebx
        ret
.2:
        test eax, eax
        je short .3
        mov eax, 6
.3:
        shl eax, 7
        add eax, SortCords
        xor edx, edx
.4:
        mov ebx, dword [byte eax+044h]
        sar ebx, 18h
        cmp ebx, ecx
        jne short .5
        cmp word [byte eax+01Ah], byte 6
        jne short .6
        jmp short StarEligible.1
.5:
        inc edx
        add eax, 80h
        cmp edx, byte 6
        jl short StarEligible.4
.6:
        mov eax, 1
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; StarCompare                                  4883B  95 PC, medium confidence
; qsort comparator for PickThreeStars; player stat points from hmplstats, +2 for gwgteam/gwgplayer.
;-----------------------------------------------------------------------------
StarCompare:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        mov ecx, eax
        mov esi, edx
        mov ebx, 19h
        mov eax, dword [eax]
        mov edx, dword [ecx]
        sar edx, 1Fh
        idiv ebx
        mov edi, eax
        mov eax, dword [esi]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        mov ebx, eax
        mov ebp, 19h
        mov eax, dword [ecx]
        mov edx, eax
        sar edx, 1Fh
        idiv ebp
        mov ebp, edx
        mov ecx, 19h
        mov eax, dword [esi]
        mov edx, eax
        sar edx, 1Fh
        idiv ecx
        mov dword [byte esp+04h], edx
        mov edx, edi
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add eax, edx
        shl eax, 4
        add eax, hmplstats
        mov edx, ebp
        shl edx, 4
        add edx, eax
        mov ecx, ebx
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 3
        add eax, ecx
        shl eax, 4
        mov ecx, hmplstats
        add ecx, eax
        mov eax, dword [byte esp+04h]
        shl eax, 4
        add eax, ecx
        mov ecx, dword [edx]
        sar ecx, 10h
        movsx esi, word [edx]
        add ecx, esi
        cmp edi, dword [gwgteam]
        jne short .1
        cmp ebp, dword [gwgplayer]
        jne short .1
        add ecx, byte 2
.1:
        mov esi, dword [eax]
        sar esi, 10h
        mov dword [esp], esi
        movsx esi, word [eax]
        add esi, dword [esp]
        mov dword [byte esp+08h], esi
        cmp ebx, dword [gwgteam]
        jne short .2
        mov esi, dword [byte esp+04h]
        cmp esi, dword [gwgplayer]
        jne short .2
        add dword [byte esp+08h], byte 2
.2:
        mov esi, dword [byte esp+08h]
        cmp ecx, esi
        je short .3
        mov eax, esi
        jmp near .13
.3:
        mov si, word [eax]
        cmp si, word [edx]
        je short .4
        movsx eax, si
        movsx edx, word [edx]
        jmp short .7
.4:
        test ecx, ecx
        jle short .5
        cmp edi, ebx
        je short .5
        mov ecx, ebx
        shl ecx, 8
        mov ecx, dword [dword ecx+hmscore-2]
        sar ecx, 10h
        mov dword [esp], ecx
        mov ecx, edi
        shl ecx, 8
        mov ecx, dword [dword ecx+hmscore-2]
        sar ecx, 10h
        mov esi, dword [esp]
        sub esi, ecx
        mov ecx, esi
        je short .5
        test esi, esi
        setg byte [byte esp+0Ch]
        movzx esi, byte [byte esp+0Ch]
        xor esi, ebx
        je short .5
        mov eax, ecx
        jmp near .x
.5:
        mov cx, word [byte eax+0Eh]
        cmp cx, word [byte edx+0Eh]
        je short .8
        mov eax, dword [byte eax+0Ch]
        sar eax, 10h
        mov edx, dword [byte edx+0Ch]
.6:
        sar edx, 10h
.7:
        sub eax, edx
        jmp near .x
.8:
        cmp word [byte eax+06h], byte 0
        jg short .9
        cmp word [byte edx+06h], byte 0
        jle short .10
.9:
        mov eax, dword [byte eax+04h]
        sar eax, 10h
        mov edx, dword [byte edx+04h]
        jmp short StarCompare.6
.10:
        mov edx, ebp
        mov eax, edi
        call StarEligible
        mov ecx, eax
        mov edx, dword [byte esp+04h]
        mov eax, ebx
        call StarEligible
        xor ecx, eax
        je short .12
        test eax, eax
        je short .11
        mov eax, 1
        jmp near .x
.11:
        mov eax, 0FFFFFFFFh
        jmp near .x
.12:
        mov eax, edi
        shl eax, 5
        sub eax, edi
        shl eax, 2
        add eax, edi
        shl eax, 2
        mov edx, hmplattr
        add edx, eax
        mov eax, ebp
        shl eax, 2
        add eax, ebp
        shl eax, 2
        add edx, eax
        mov eax, ebx
        shl eax, 5
        sub eax, ebx
        shl eax, 2
        add eax, ebx
        shl eax, 2
        mov ecx, hmplattr
        add ecx, eax
        mov ebx, dword [byte esp+04h]
        mov eax, ebx
        shl eax, 2
        add eax, ebx
        shl eax, 2
        add eax, ecx
        xor ecx, ecx
        mov cl, byte [byte eax+01h]
        xor ebx, ebx
        mov bl, byte [byte eax+02h]
        add ecx, ebx
        xor ebx, ebx
        mov bl, byte [byte eax+04h]
        add ebx, ecx
        xor ecx, ecx
        mov cl, byte [byte eax+06h]
        add ebx, ecx
        xor ecx, ecx
        mov cl, byte [byte eax+09h]
        add ecx, ebx
        xor ebx, ebx
        mov bl, byte [byte eax+0Ah]
        add ecx, ebx
        xor ebx, ebx
        mov bl, byte [byte eax+03h]
        add ecx, ebx
        xor ebx, ebx
        mov bl, byte [byte eax+0Dh]
        add ecx, ebx
        xor ebx, ebx
        mov bl, byte [byte eax+0Bh]
        add ebx, ecx
        mov al, byte [byte eax+05h]
        and eax, 0FFh
        add ebx, eax
        mov dword [byte esp+08h], ebx
        xor ebx, ebx
        mov bl, byte [byte edx+01h]
        xor eax, eax
        mov al, byte [byte edx+02h]
        add ebx, eax
        xor eax, eax
        mov al, byte [byte edx+04h]
        add eax, ebx
        xor ebx, ebx
        mov bl, byte [byte edx+06h]
        add ebx, eax
        xor eax, eax
        mov al, byte [byte edx+09h]
        add ebx, eax
        xor eax, eax
        mov al, byte [byte edx+0Ah]
        add ebx, eax
        xor eax, eax
        mov al, byte [byte edx+03h]
        add ebx, eax
        xor eax, eax
        mov al, byte [byte edx+0Dh]
        add eax, ebx
        xor ecx, ecx
        mov cl, byte [byte edx+0Bh]
        add ecx, eax
        xor eax, eax
        mov al, byte [byte edx+05h]
        add ecx, eax
        mov eax, dword [byte esp+08h]
.13:
        sub eax, ecx
.x:
        add esp, byte 10h
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; PickThreeStars                                                  48AC8  95 PC
; PC three stars. Empties startm/starpl, records the winner (gwgteam, gwgplayer = its team field 2Eh)
; when the scores differ, then fills the 3 stars from the qsorted players (StarCompare) with AddStar.
;-----------------------------------------------------------------------------
; C: src/engine/intro/FadeOutPalCycle.c (PickThreeStars)
%ifdef CBUILD
%include "c/engine/intro/FadeOutPalCycle.PickThreeStars.inc"
%else
PickThreeStars:
        push dword 0F4h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, 0D8h
        xor edi, edi
        xor ecx, ecx
        mov esi, 0FFFFFFFFh
        jmp short .2
.1:
        movsx eax, cx
        mov word [nosplit eax*4+starpl], si
        mov word [nosplit eax*4+startm], si
        inc ecx
.2:
        cmp cx, byte 3
        jl short PickThreeStars.1
        mov edx, 0FFFFFFFFh
        mov dword [gwgplayer], edx
        mov dword [gwgteam], edx
        cmp dword [curperiod], byte 3
        jle near .3
        mov cx, word [awscore]
        sub cx, word [hmscore]
        je short .3
        test cx, cx
        setg al
        xor ch, ch
        mov cl, al
        cmp word [lasttouch], byte 6
        setl al
        and eax, 0FFh
        movsx esi, cx
        xor eax, esi
        je short .3
        mov dword [gwgteam], esi
        mov eax, esi
        shl eax, 8
        mov eax, dword [dword eax+hmtmtouch1-2]
        sar eax, 10h
        mov dword [gwgplayer], eax
        mov edx, dword [awscore-2]
        sar edx, 10h
        mov eax, dword [hmscore-2]
        sar eax, 10h
        call IsCupClinched
        test eax, eax
        je short .3
        mov ebx, dword [gwgplayer-2]
        sar ebx, 10h
        movsx eax, di
        mov edx, esi
        call AddStar
        add edi, eax
.3:
        xor ecx, ecx
        jmp near .8
.4:
        test cx, cx
        sete al
        and eax, 0FFh
        shl eax, 8
        cmp word [dword eax+hmscore], byte 0
        jne near .7
        xor esi, esi
        movsx edx, cx
        mov eax, edx
        shl eax, 3
        add eax, edx
        mov dx, word [nosplit eax*2+hmglstats_w8]
        cmp dx, word [nosplit eax*2+hmglstats_w2]
        jle short .5
        mov esi, 1
.5:
        movsx edx, cx
        mov eax, edx
        shl eax, 3
        add eax, edx
        add eax, eax
        mov dx, word [dword eax+hmglstats_w14]
        cmp dx, word [dword eax+hmglstats_w2]
        jle short .6
        cmp dx, word [dword eax+hmglstats_w8]
        jle short .6
        mov esi, 2
.6:
        movsx edx, cx
        mov ebp, edx
        shl ebp, 3
        add ebp, edx
        add ebp, ebp
        movsx ebx, si
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        add eax, eax
        add eax, ebp
        mov ebp, dword [gameopts]
        shl ebp, 14h
        shr ebp, 1Eh
        movsx bx, byte [dword ebp+starskatermin]
        cmp bx, word [dword eax+hmglstats_w2]
        jge short .7
        add esi, byte 19h
        movsx ebx, si
        movsx eax, di
        call AddStar
        add edi, eax
.7:
        inc ecx
.8:
        cmp cx, byte 2
        jl near PickThreeStars.4
        xor eax, eax
        mov word [dword esp+0D4h], ax
        xor ecx, ecx
        jmp near .12
.9:
        movsx ebx, cx
        mov esi, 19h
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv esi
        mov ebp, eax
        shl eax, 4
        add eax, ebp
        shl eax, 4
        add eax, ebp
        shl eax, 2
        mov dword [dword esp+0C8h], eax
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv esi
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 3
        sub eax, edx
        add eax, dword [dword esp+0C8h]
        movzx si, byte [dword eax+hmroster]
        test si, si
        je short .11
        cmp si, byte 2
        je short .11
        mov eax, ebp
        shl eax, 2
        sub eax, ebp
        shl eax, 3
        add eax, ebp
        shl eax, 4
        add eax, hmplstats
        shl edx, 4
        add eax, edx
        cmp si, byte 1
        jne short .10
        cmp word [eax], byte 0
        jne short .10
        cmp word [byte eax+Xpos+2], byte 0
        jne short .10
        cmp word [byte eax+04h], byte 0
        jne short .10
        cmp word [byte eax+Ypos+2], byte 0
        jne short .10
        cmp word [byte eax+Yvel], byte 0
        je short .11
.10:
        movsx edx, cx
        mov eax, dword [dword esp+0D2h]
        sar eax, 10h
        mov dword [esp+eax*4], edx
        inc word [dword esp+0D4h]
.11:
        inc ecx
.12:
        cmp cx, byte 32h
        jl near PickThreeStars.9
        mov edx, dword [dword esp+0D2h]
        sar edx, 10h
        mov ecx, StarCompare
        mov ebx, 4
        mov eax, esp
        call qsort_
        xor ecx, ecx
        jmp near .22
.13:
        movsx esi, cx
        mov si, word [esp+esi*4]
        movsx ebx, si
        mov esi, 19h
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv esi
        mov esi, eax
        shl eax, 2
        sub eax, esi
        shl eax, 3
        add eax, esi
        shl eax, 4
        mov dword [dword esp+0C8h], eax
        mov ebp, 19h
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ebp
        mov eax, edx
        shl eax, 4
        add eax, dword [dword esp+0C8h]
        mov ebx, dword [dword eax+hmplstats_w2-2]
        sar ebx, 10h
        mov eax, dword [dword eax+hmplstats-2]
        sar eax, 10h
        add eax, ebx
        cmp eax, byte 1
        jle short .14
        movsx ebx, dx
        movsx edx, si
        movsx eax, di
        call AddStar
        add edi, eax
        cmp di, byte 3
        jge near .20
        jmp near .21
.14:
        xor esi, esi
        jmp near .17
.15:
        movsx ebx, si
        mov ebp, 3
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ebp
        mov dword [dword esp+0CCh], eax
        mov edx, eax
        shl eax, 3
        add eax, edx
        add eax, eax
        mov dword [dword esp+0D0h], eax
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ebp
        mov ebp, edx
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        mov ebx, dword [dword esp+0D0h]
        add ebx, eax
        mov eax, dword [gameopts]
        shl eax, 14h
        shr eax, 1Eh
        movsx ax, byte [dword eax+stargoaliemin]
        cmp ax, word [dword ebx+hmglstats_w2]
        jg short .16
        mov edx, dword [dword ebx+hmglstats_w4-2]
        sar edx, 10h
        mov eax, edx
        shl eax, 5
        sub eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 3
        mov dword [dword esp+0C8h], eax
        mov ebx, dword [dword ebx+hmglstats_w2-2]
        sar ebx, 10h
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov edx, dword [dword esp+0C8h]
        add edx, eax
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        cmp eax, byte 4Bh
        jg short .16
        lea eax, [byte ebp+019h]
        movsx ebx, ax
        mov eax, dword [dword esp+0CCh]
        movsx edx, ax
        movsx eax, di
        call AddStar
        add edi, eax
        cmp di, byte 3
        jge short .20
.16:
        inc esi
.17:
        cmp si, byte 6
        jl near PickThreeStars.15
.18:
        mov ebp, 19h
.19:
        cmp cx, word [dword esp+0D4h]
        jl short .23
.20:
        add esp, 0D8h
        jmp near PreGameIntro_popebp
.21:
        inc ecx
.22:
        cmp cx, word [dword esp+0D4h]
        jl near PickThreeStars.13
        jmp short PickThreeStars.18
.23:
        movsx esi, cx
        mov si, word [esp+esi*4]
        movsx ebx, si
        mov esi, 19h
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv esi
        movsx esi, dx
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ebp
        movsx edx, ax
        movsx eax, di
        mov ebx, esi
        call AddStar
        add edi, eax
        cmp di, byte 3
        jge short PickThreeStars.20
        inc ecx
        jmp short PickThreeStars.19
%endif ; C
;-----------------------------------------------------------------------------
; StartThreeStars                              48F0B  95 PC, medium confidence
; PC end-of-game set-up for the three-stars ceremony (assthreestars, asstab 15h): PickThreeStars,
; clears the clock line-change signal state, stops the clock, empties the penalty boxes and places the players.
;-----------------------------------------------------------------------------
; C: src/engine/intro/FadeOutPalCycle.c (StartThreeStars)
%ifdef CBUILD
%include "c/engine/intro/FadeOutPalCycle.StartThreeStars.inc"
%else
StartThreeStars:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov edx, dword [demoflag]
        test edx, edx
        jne near PreGameIntro_popx
        mov esi, dword [curperiod]
        mov dword [joysampling], edx
        call joyq_flush
        push savepal
        push dword 100h
        push edx
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, savepal
        mov eax, 1
        call FadePalette
        mov word [fadeinpending], 1
        call PickThreeStars
        mov byte [curevent], 0FFh
        xor ebx, ebx
        mov word [SortPending], bx
        mov word [RefPen], bx
        mov word [refsignal], bx
        mov word [Penaltytimer], bx
        mov word [bannertimer], bx
        mov word [injurystop], bx
        mov word [lcboxon+2], bx
        mov word [lcboxon], bx
        mov word [lcblink+2], bx
        mov word [lcblink], bx
        mov word [energywarn+2], bx
        mov word [energywarn], bx
        mov word [lcrequest+2], bx
        mov word [lcrequest], bx
        mov eax, dword [ovlseq-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        je short .1
        mov ecx, dword [ovlartbank]
        push ecx
        call FreeMemBlock
        add esp, byte 4
.1:
        mov edx, 0FFFFFFFFh
        mov word [bannermsg], dx
        mov word [ovlstep], dx
        mov word [ovlseq], dx
        xor dl, dl
        mov byte [textline5], dl
        mov byte [textline4], dl
        mov byte [textline2], dl
        mov byte [textline1], dl
        mov byte [textline3], dl
        mov dword [curperiod], 0FFFFFFFFh
        xor edi, edi
        mov word [exitgame], di
        mov word [gameover], di
        mov ch, byte [gmode]
        or ch, 1
        mov byte [gmode], ch
        mov al, ch
        and al, 7Fh
        mov byte [gmode], al
        mov dword [seqtimer], 2EE0h
        mov edx, 0FFFFFFFFh
        mov word [c2playernum], dx
        mov word [c1playernum], dx
        xor ah, ah
        mov byte [PBnum+1], ah
        xor dl, dl
        mov byte [PBnum], dl
        mov ebx, SortCords
        xor ecx, ecx
.2:
        mov word [byte ebx+Xpos+2], 0FF38h
        mov ax, word [byte ebx+Xpos+2]
        mov word [byte ebx+temp3], ax
        mov word [byte ebx+Ypos+2], 0
        mov ax, word [byte ebx+Ypos+2]
        mov word [byte ebx+temp4], ax
        mov word [byte ebx+temp5], 0FF9Ch
        mov word [byte ebx+Yvel], 0
        mov ax, word [byte ebx+Yvel]
        mov word [byte ebx+Xvel], ax
        mov word [byte ebx+012h], 0FFFFh
        mov byte [byte ebx+newpos], 0FFh
        mov al, byte [byte ebx+newpos]
        mov byte [byte ebx+newpnum], al
        xor edx, edx
        mov eax, ebx
        call SetSPA
        xor edx, edx
        mov eax, ebx
        call assreplace
        and byte [byte ebx+pflags], 0D7h
        or byte [byte ebx+pflags2], 4
        inc ecx
        add ebx, 80h
        cmp ecx, byte 0Ch
        jl short StartThreeStars.2
        mov ecx, 78h
        mov word [puckstruct+28h], cx
        mov edi, 0C8h
        mov word [puckstruct+2], di
        mov word [puckstruct+6], 0FED4h
        xor edx, edx
        mov word [puckstruct+0Ch], dx
        mov word [puckstruct+0Eh], dx
        mov edx, 1Ah
        mov eax, puckstruct
        call assreplace
        mov ebx, puckstruct
        add ebx, 80h
        mov word [byte ebx+temp2], cx
        mov word [byte ebx+Xpos+2], di
        mov word [byte ebx+Ypos+2], 0FED4h
        mov word [byte ebx+Xvel], 0
        mov word [byte ebx+Yvel], 0
        mov edx, 19h
        mov eax, ebx
        call assreplace
        xor ecx, ecx
        mov word [reftemp1], cx
        mov edi, 0FFFFFF38h
        mov word [SortCords+802h], di
        mov word [reftemp3], di
        mov word [refYpos2], cx
        mov word [reftemp4], cx
        mov word [refYvel], cx
        mov word [refXvel], cx
        xor edx, edx
        mov eax, SortCords+800h
        call SetSPA
        mov word [refframe], 0FFFFh
        mov edx, 15h
        mov eax, SortCords+800h
        call assreplace
        mov word [RefStep], cx
        or byte [sflags], 40h
        call DoGameFrame
        call DoGameFrame
        call SprSort
        xor eax, eax
        mov dword [frameaccum], eax
        mov dword [inputframes], eax
        mov eax, dword [puckc]
        mov byte [eax], 0FFh
        mov ebx, 0FFFFFFE0h
        mov word [camx], bx
        mov word [xc1], bx
        mov word [camy], cx
        mov word [yc1], cx
        call CloseTextOverlay
        call ThreeStarsLoop
        test eax, eax
        jge short .3
        mov word [crowdlevel], cx
.3:
        mov dword [curperiod], esi
        call CrowdFadeOut
        xor ebx, ebx
        mov word [crowdlevel], bx
        cmp byte [musicon], 0
        je short .4
        call MusicChanReset
        jmp near PreGameIntro_popx
.4:
        call ReleaseAllVoices
        jmp near PreGameIntro_popx
%endif ; C
;-----------------------------------------------------------------------------
; MoveInDir                                       49260  95 PC, low confidence
; (player, dir): goalie -> goalieacc; dir 8..9 stop/stand (StopNA or anim
; 289h); else turns facedir one step toward dir, skating anim 2E9h, playeracc
;-----------------------------------------------------------------------------
; C: src/engine/intro/MoveInDir.c
%ifdef CBUILD
%include "c/engine/intro/MoveInDir.inc"
%else
MoveInDir:
        push dword 8
        call __CHK
        push ebx
        mov ebx, eax
        cmp word [byte eax+position], byte 0
        jne short .1
        movsx edx, dx
        call goalieacc
        pop ebx
        ret
.1:
        xor dh, dh
        and dl, 0Fh
        cmp dx, byte 7
        jle short .3
        cmp dx, byte 9
        jne short .2
        mov eax, dword [byte eax+Xvel-2]
        sar eax, 10h
        mov edx, dword [byte ebx+Yvel-2]
        sar edx, 10h
        or eax, edx
        je short .2
        mov eax, ebx
        call stopna
        pop ebx
        ret
.2:
        test byte [byte ebx+pflags2], 2
        jne short .x
        mov edx, 289h
        mov eax, ebx
        call SetSPA
        pop ebx
        ret
.3:
        sub dx, word [byte eax+facedir]
        je short .4
        movsx edx, dx
        mov eax, edx
        neg eax
        and eax, byte 4
        sar eax, 1
        mov edx, dword [byte ebx+facedir-2]
        sar edx, 10h
        dec eax
        add eax, edx
        and eax, byte 7
        mov word [byte ebx+facedir], ax
.4:
        mov edx, 2E9h
        mov eax, ebx
        call SetSPA
        mov edx, dword [byte ebx+facedir-2]
        sar edx, 10h
        mov eax, ebx
        call playeracc
.x:
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SteerToTarget                                   492F9  95 PC, low confidence
; Every 0Ch ticks (+29h countdown) recomputes the direction to regd0/regd1 (9
; when within 0Ch), stores it in +28h and moves with MoveInDir; used by the
; pc slot 20 skater
;-----------------------------------------------------------------------------
; C: src/engine/intro/SteerToTarget.c
%ifdef CBUILD
%include "c/engine/intro/SteerToTarget.inc"
%else
SteerToTarget:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov ebx, eax
        mov ah, byte [byte eax+029h]
        dec ah
        mov byte [byte ebx+029h], ah
        test ah, ah
        jge near .7
        mov dh, ah
        add dh, 0Ch
        mov byte [byte ebx+029h], dh
        mov eax, dword [byte ebx+0Ah]
        sar eax, 18h
        mov edx, dword [regd0-2]
        sar edx, 10h
        sub edx, eax
        mov eax, dword [ebx]
        sar eax, 10h
        sub edx, eax
        mov word [regd0], dx
        mov eax, dword [byte ebx+0Ch]
        sar eax, 18h
        mov edx, dword [regd1-2]
        sar edx, 10h
        sub edx, eax
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
        sub edx, eax
        mov word [regd1], dx
        cmp word [regd0], byte 0
        jge short .1
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .2
.1:
        mov eax, dword [regd0-2]
        sar eax, 10h
.2:
        cmp eax, byte 0Ch
        jg short .5
        cmp word [regd1], byte 0
        jge short .3
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .4
.3:
        mov eax, dword [regd1-2]
        sar eax, 10h
.4:
        cmp eax, byte 0Ch
        jg short .5
        mov word [regd0], 9
        jmp short .6
.5:
        mov edx, dword [regd1-2]
        sar edx, 10h
        mov eax, dword [regd0-2]
        sar eax, 10h
        call vtoa
        mov word [regd0], ax
.6:
        mov al, byte [regd0]
        mov byte [byte ebx+028h], al
        cmp word [regd0], byte 7
        jle short .7
        mov edx, dword [byte ebx+Xvel-2]
        sar edx, 10h
        mov eax, dword [byte ebx+Yvel-2]
        sar eax, 10h
        or eax, edx
        jne short .7
        mov ax, word [byte ebx+temp3]
        mov dx, word [byte ebx+Xpos+2]
        sub eax, edx
        mov word [regd0], ax
        mov ax, word [byte ebx+temp4]
        mov cx, word [byte ebx+Ypos+2]
        sub eax, ecx
        mov word [regd1], ax
        mov edx, dword [regd1-2]
        sar edx, 10h
        mov eax, dword [regd0-2]
        sar eax, 10h
        call vtoa
        mov dx, word [byte ebx+facedir]
        sub dx, ax
        mov word [regd0], dx
        je short .7
        mov eax, edx
        xor ah, dh
        and al, 4
        cwde
        mov edx, eax
        sar edx, 1
        mov eax, dword [byte ebx+facedir-2]
        sar eax, 10h
        add eax, edx
        dec eax
        and eax, byte 7
        mov word [byte ebx+facedir], ax
.7:
        mov edx, dword [byte ebx+025h]
        sar edx, 18h
        mov eax, ebx
        call MoveInDir
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assstarskate                                 49460  95 PC, medium confidence
; Asstab 20 (14h, the 94 assfight slot; PC has no fights): the three stars
; skate a 4-point path (StartThreeStars), maybe stopping for SPA 731h
;-----------------------------------------------------------------------------
; C: src/engine/intro/assstarskate.c
%ifdef CBUILD
%include "c/engine/intro/assstarskate.inc"
%else
assstarskate:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push edi
        mov ebx, eax
        test byte [byte eax+pflags], 20h
        jne near .x
        mov dl, byte [byte ebx+pflags]
        test dl, 2
        je near .3
        mov dh, dl
        and dh, 0FDh
        mov byte [byte ebx+pflags], dh
        mov word [byte ebx+temp5], 0
        mov word [byte ebx+temp2], 8
        test byte [byte ebx+pflags], 40h
        setne al
        xor ah, ah
        mov edx, eax
        cmp word [byte ebx+position], byte 0
        je short .1
        test ax, ax
        jne short .1
        mov ax, word [hmscore]
        cmp ax, word [awscore]
        jle short .1
        mov eax, 8
        call randomd0
        mov word [byte ebx+temp1], ax
        jmp short .2
.1:
        mov word [byte ebx+temp1], 0FFFFh
.2:
        mov eax, dword [byte ebx+temp5-2]
        sar eax, 10h
        movsx edx, dx
        shl edx, 4
        mov ax, word [dword edx+eax*4+assstarskate_path]
        mov word [byte ebx+temp3], ax
        mov eax, dword [byte ebx+temp5-2]
        sar eax, 10h
        mov ax, word [dword edx+eax*4+assstarskate_path_y]
        mov word [byte ebx+temp4], ax
.3:
        mov edx, dword [ebx]
        sar edx, 10h
        mov eax, dword [byte ebx+temp3-2]
        sar eax, 10h
        sub edx, eax
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
        mov ecx, dword [byte ebx+temp4-2]
        sar ecx, 10h
        sub eax, ecx
        imul edx, edx
        imul eax, eax
        add eax, edx
        cmp eax, 384h
        jge short .5
        mov di, word [byte ebx+temp5]
        inc edi
        mov word [byte ebx+temp5], di
        cmp di, byte 3
        jle short .4
        mov eax, ebx
        call assexit
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.4:
        test byte [byte ebx+pflags], 40h
        setne al
        xor ah, ah
        mov edx, dword [byte ebx+temp5-2]
        sar edx, 10h
        shl edx, 2
        cwde
        shl eax, 4
        mov dx, word [dword edx+eax+assstarskate_path]
        mov word [byte ebx+temp3], dx
        mov edx, dword [byte ebx+temp5-2]
        sar edx, 10h
        mov ax, word [dword eax+edx*4+assstarskate_path_y]
        mov word [byte ebx+temp4], ax
        mov ax, word [byte ebx+temp1]
        cmp ax, word [byte ebx+temp5]
        jne short .5
        or byte [byte ebx+pflags], 20h
        mov edx, 731h
        mov eax, ebx
        call SetSPA
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.5:
        mov ax, word [byte ebx+temp3]
        mov word [regd0], ax
        mov ax, word [byte ebx+temp4]
        mov word [regd1], ax
        mov eax, ebx
        call SteerToTarget
.x:
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assthreestars                                                   495B8  95 PC
; asstab 15h. Announces star temp1: "%s Star" with 1st/2nd/3rd, the player's name, "EA Sports".
;-----------------------------------------------------------------------------
assthreestars:
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
        mov eax, dword [ovltimer-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        je short .1
        mov dx, word [ovltimer]
        cmp dx, byte 10h
        jl near .16
        cmp dx, 258h
        jl short .1
        cmp dx, 268h
        jl near .16
.1:
        mov ah, byte [byte ebp+pflags]
        test ah, 2
        je near .5
        mov dl, ah
        and dl, 0FDh
        mov byte [byte ebp+pflags], dl
        mov edi, textline3
        mov esi, str_EASports
        movsd
        movsd
        movsw
        xor dh, dh
        mov byte [textline5], dh
        mov byte [textline4], dh
        mov word [byte ebp+temp1], 2
        mov eax, 14h
        call randomd0
        add eax, 14h
        mov word [byte ebp+temp2], ax
        test byte [gameopts+1], 1
        je short .2
        cmp byte [musicon], 0
        je short .2
        mov esi, eax
        add esi, 0DCh
        mov word [byte ebp+temp2], si
.2:
        mov word [byte ebp+temp3], 0FFFFh
        mov ebx, dword [byte ebp+temp1-2]
        sar ebx, 10h
        mov esi, dword [nosplit ebx*4+startm_m2]
        sar esi, 10h
        mov edi, dword [nosplit ebx*4+startm]
        sar edi, 10h
        mov edx, dword [nosplit ebx*4+starordtab]
        push edx
        push str_StarFmt
        push textline1
        call sprintf_
        add esp, byte 0Ch
        push unk_C1B3E
        mov edx, esi
        shl edx, 4
        add edx, esi
        shl edx, 4
        add edx, esi
        shl edx, 2
        mov ecx, hmroster
        add ecx, edx
        mov ebx, edi
        shl ebx, 2
        add ebx, edi
        shl ebx, 3
        sub ebx, edi
        lea eax, [ecx+ebx]
        lea ecx, [byte eax+017h]
        push ecx
        add eax, byte 7
        mov dword [byte esp+08h], eax
        mov dl, byte [dword edx+ebx+hmrosterjersey]
        and edx, 0FFh
        mov ebx, esi
        shl ebx, 2
        sub ebx, esi
        shl ebx, 3
        mov eax, ebx
        shl ebx, 5
        sub ebx, eax
        mov eax, hmteamrec
        add eax, ebx
        mov ecx, dword [byte esp+08h]
        mov ebx, edx
        mov edx, eax
        mov eax, textline2
        call FormatPlayerName
        test esi, esi
        je short .3
        mov ax, word [VisTeam]
        jmp short .4
.3:
        mov ax, word [HomeTeam]
.4:
        movsx ecx, ax
        mov eax, esi
        shl eax, 4
        add eax, esi
        shl eax, 4
        add eax, esi
        shl eax, 2
        mov ebx, edi
        shl ebx, 2
        add ebx, edi
        shl ebx, 3
        sub ebx, edi
        add eax, ebx
        xor ebx, ebx
        mov bl, byte [dword eax+hmrosterjersey]
        mov edx, dword [byte ebp+temp1-2]
        sar edx, 10h
        inc edx
        mov eax, dword [nosplit ecx*4+teamabbrevs]
        call PaPlayerNumber
.5:
        mov di, word [byte ebp+temp2]
        dec edi
        mov word [byte ebp+temp2], di
        test di, di
        jg near .16
        cmp word [byte ebp+temp1], byte 0
        jge short .6
        xor edx, edx
        mov dword [seqtimer], edx
        mov ebx, 1
        mov word [exitgame], bx
        mov word [gameover], bx
        jmp near .16
.6:
        mov eax, dword [byte ebp+temp3-2]
        sar eax, 10h
        shl eax, 7
        mov ebx, SortCords
        add ebx, eax
        cmp word [byte ebp+temp3], byte 0
        jl near .11
        cmp word [byte ebx+temp1], byte 64h
        jne near .11
        mov eax, dword [byte ebx+010h]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        jne near .11
        mov eax, 1Eh
        call randomd0
        add eax, 14h
        mov word [byte ebp+temp2], ax
        test byte [gameopts+1], 1
        je short .7
        cmp byte [musicon], 0
        je short .7
        add word [byte ebp+temp2], 0DCh
.7:
        mov word [byte ebp+temp3], 0FFFFh
        mov di, word [byte ebp+temp1]
        dec edi
        mov word [byte ebp+temp1], di
        test di, di
        jge short .8
        mov word [ovltimer], 258h
        jmp near .16
.8:
        mov ebx, dword [byte ebp+temp1-2]
        sar ebx, 10h
        mov esi, dword [nosplit ebx*4+startm_m2]
        sar esi, 10h
        mov edi, dword [nosplit ebx*4+startm]
        sar edi, 10h
        mov eax, dword [nosplit ebx*4+starordtab]
        push eax
        push str_StarFmt
        push textline1
        call sprintf_
        add esp, byte 0Ch
        push unk_C1B3E
        mov edx, esi
        shl edx, 4
        add edx, esi
        shl edx, 4
        add edx, esi
        shl edx, 2
        mov ecx, hmroster
        add ecx, edx
        mov ebx, edi
        shl ebx, 2
        add ebx, edi
        shl ebx, 3
        sub ebx, edi
        add ecx, ebx
        lea eax, [byte ecx+017h]
        push eax
        add ecx, byte 7
        xor eax, eax
        mov al, byte [dword edx+ebx+hmrosterjersey]
        mov dword [byte esp+08h], eax
        mov ebx, esi
        shl ebx, 2
        sub ebx, esi
        shl ebx, 3
        mov eax, ebx
        shl ebx, 5
        sub ebx, eax
        mov edx, hmteamrec
        add edx, ebx
        mov ebx, dword [byte esp+08h]
        mov eax, textline2
        call FormatPlayerName
        test esi, esi
        je short .9
        mov ax, word [VisTeam]
        jmp short .10
.9:
        mov ax, word [HomeTeam]
.10:
        cwde
        mov edx, esi
        shl edx, 4
        add edx, esi
        shl edx, 4
        add edx, esi
        shl edx, 2
        mov ebx, edi
        shl ebx, 2
        add ebx, edi
        shl ebx, 3
        sub ebx, edi
        mov bl, byte [dword edx+ebx+hmrosterjersey]
        and ebx, 0FFh
        mov edx, dword [byte ebp+temp1-2]
        sar edx, 10h
        inc edx
        mov eax, dword [nosplit eax*4+teamabbrevs]
        call PaPlayerNumber
        jmp near .16
.11:
        cmp word [byte ebp+temp2], byte 0
        jl near .16
        mov eax, dword [byte ebp+temp1-2]
        sar eax, 10h
        cmp word [nosplit eax*4+startm], byte 0
        setne al
        and eax, 0FFh
        add eax, byte 5
        mov word [byte ebp+temp3], ax
        shl eax, 7
        mov ebx, SortCords
        add ebx, eax
        test byte [byte ebx+pflags], 40h
        setne al
        and eax, 0FFh
        mov esi, eax
        je short .12
        mov eax, 2BCh
        jmp short .13
.12:
        mov eax, 5DCh
.13:
        mov word [crowdlevel], ax
        mov eax, dword [byte ebp+temp1-2]
        sar eax, 10h
        mov al, byte [nosplit eax*4+starpl]
        mov byte [byte ebx+047h], al
        movsx edi, al
        cmp edi, byte 19h
        jge short .14
        mov eax, 4
        jmp short .15
.14:
        xor eax, eax
.15:
        mov word [byte ebx+position], ax
        mov word [byte ebx+temp1], 0
        mov byte [byte ebx+newpnum], 0FFh
        mov al, byte [byte ebx+newpnum]
        mov byte [byte ebx+newpos], al
        shl esi, 8
        mov eax, edi
        mov word [dword esi+eax*2+hmtmpde], 300h
        and byte [byte ebp+pflags2], 0FBh
        movsx edx, di
        mov eax, ebx
        call setplayer
        xor edx, edx
        mov eax, ebx
        call assreplace
        mov edx, 1Dh
        mov eax, ebx
        call assinsert
        mov edx, 14h
        mov eax, ebx
        call assinsert
        mov edx, 9
        mov eax, ebx
        call assinsert
.16:
        add esp, byte 4
        jmp near PreGameIntro_popebp
