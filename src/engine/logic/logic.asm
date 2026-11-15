; What each player is trying to do. The assignment table: wings, centres, defence, the goalie,
; the puck carrier, the referee, and the shootout path (95G engine/logic95).
bits 32
%include "hockey.inc"
section s_499D8 progbits alloc exec nowrite align=1
extern __CHK, AddPenalty, AddPenalty2, assinsert, assreplace, awscore, awtmap, awtmstruct
extern bannermsg, bannertimer, starskatermin, stargoaliemin, Endfaceoff_ftab_m1, hmplattr_b13, awplattr_b13, byte_DF87F
extern byte_DFFE2, curevent, goalevent, goalevent_b1, goalevent_b2, goalevent_b3, goalevent_b4, c1playernum
extern c2playernum, camx, camx_m2, camy, changeplayer, check4bench, check4check, checkob
extern checkpuckcoll, chk4lc, chk4pass, chk4shot, ChkOffsides, ChkPullGoalieLate, ChkScorerMilestone, clockticks
extern CloseTextOverlay, CrowdFadeOut, crowdlevel, curperiod, deferpending, dirtab, dirtab_y, DoGameFrame
extern doorpflags, doortemp1, doplayeracc, doshot, hmlinetimer, awlinetimer, dword_CBEBE, demoflag
extern introstandanims_m2, assscore_dancecnt, goaliesave_saveanim_m2, refsigspa_m2, ShootoutPathData, ShootoutPathData_y, ShootoutPathData_end, hmplstats_m2
extern hmplstats, hmtmextra, hmtmtouch3, hmtmnear, awtmtouch3, awtmnear, sctemp4, ovlartbank
extern fofdata2_m2, regd3_m2, dword_E9A9E, dword_E9AB6, dword_E9AB7, EndPenaltyShot, energywarn, EvadePC
extern EvadePlayers, exitgame, fadeinpending, FadePalette, Findhittype, findpc, fodir1, fodir2
extern fofdata2, FormatPlayerName, fox, foy, frameaccum, FreeMemBlock, gameclock, gameopts
extern gameover, GetHot, getlchoice, gmode, gmode2, goalieacc, gsp, gwgplayer
extern gwgteam, hmroster, hmrosterjersey, hmscore, hmteamrec, hmtmap, hmtmpde, hmtmpdst_m2
extern hmtmstruct, HomeTeam, icingPlayer, iflags, imul32, inputframes, IsCupClinched, joyq_flush
extern joysampling, joysampling_save, lasttouch, lcblink, lcblinktime, lcboxon, lcline, lcrequest
extern lcsel, lctimer, lj1, LoadTeamPPV, ltx, lty, MarkTwoLinePlayers, MusicChanReset
extern musicon, ovlseq, ovlstep, ovltimer, PaGoal, PaPlayerNumber, PaSpeechBusy, passdir
extern passspeed, PBnum, Penaltytimer, PenBuf, Pencntdwn, PenShotAssign, penshotlive, penshotmode
extern penshotplayer, penshotstart, penshotteam, periodendtime, PerTimeTotal, PlayCrowdSample, playeracc, PostGoalEvent
extern PreGameIntro_popebp, PreGameIntro_popx, psendcount, pspathdir, pspathside, puckc, puckcross, PuckIChk
extern puckshadow, puckstruct, pucktemp1, puckvx, puckvy, puckvz, puckx, pucky
extern puckz, qsort_, QueueGoalieNote, randomd0, RefPen, refsignal, RefStep, regd0
extern regd1, regd2, regd3, regd4, RemoveFromLines, savepal, seqtimer, SetBoxDoorObject
extern Setplass, setplayer, SetShotMode, SetSPA, sflags, sflags3, sfx, ShotLaneOpen
extern ShotMode, shotongoal, shotplayer, skateto, skatetopuck, sopathend, sopathpoint, sopathx
extern sopathy, SortCords, sortobj15, sounddev, sprintf_, SprSort, starordtab, starpl
extern startm, startm_m2, StopDigiSample, stopna, str_EASports, str_StarFmt, sub_8F633, SetPalette
extern teamabbrevs, textline1, textline2, textline3, textline4, textline5, threat, ThreeStarsLoop
extern unk_C1B3E, hmplattr, hmglstats, updateanim, vecdist, VisTeam, vtoa, penaltysc
extern word_CBC44, injurystop, assstarskate_path, assstarskate_path_y, asswingo_dedata, asswingo_dedata_xrand, asswingo_dedata_y, asswingo_dedata_yrand
extern asscentero_dedata, asscentero_dedata_xrand, asscentero_dedata_y, asscentero_dedata_yrand, asspuckc_postab2, asspuckc_postab2_y, refsigdir, hmplstats_w2
extern hmglstats_w2, hmglstats_w4, hmglstats_w8, hmglstats_w14, hmtmtouch1, puckcross2, puckcross6, refYpos2
extern refXvel, refYvel, refframe, reftemp1, reftemp3, reftemp4, fofdata2_w2, fofdata2_w4
extern fofdata2_w6, penevteam, word_E9AB0, xc1, yc1, yleader
global assboxenter, assbenchside, assdefo, assdefd, asswingd, asswingd_skate0, asswingd_skateto, asswingo
global asswingo_evade, asscenterd, asscentero, donothing, assstanley, assscore, asseben, assleaveice
global asspenalty, assdopen, assepen, assbench, GoalieToPuckVec, AdjustFacingDirection, assgoalietopuck, ClampYPosition
global assgoalie, assgoalie_popebp, CountPuckThreat, asspuckc, sub_4C8BD, asspuckc_chkdir, assnearest, assshoot
global assshoot_ret, assfaceoff, assexit, assfaceoffpl, pucknorm_body, pucknorm, pucknothing, puckunflip
global RequestLineChange, SetLCmode, StartFaceoffLineChange, Endfaceoff, a2offsides, ChkTwoLinePass, a2touchpuck, puckflip
global assrefatdot, assreffollow, SkateToSpot, CrowdOnStoppage, assrefwhistle, ass_replace_popx, ass_popx, ass_skate_temp34
global assrefsignal, assrefgoalpa, assrefdrop, assrefgoalline, rtss, NextPathPoint, StartShootoutPath, asspenshooter
;-----------------------------------------------------------------------------
; assboxenter                                     499D8  95 PC, low confidence
; Asstab 2Ah: Pencntdwn 12Ch; skates to x -91h,y 6, then seats the player in
; the box (pflags 20h, tmpde 800h, SetBoxDoorObject) and opens the box door
; sprite (sortobj15)
;-----------------------------------------------------------------------------
; C: src/engine/logic/assboxenter.c
%ifdef CBUILD
%include "c/engine/logic/assboxenter.inc"
%else
assboxenter:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov ebx, eax
        mov word [Pencntdwn], 12Ch
        test byte [byte eax+pflags], 20h
        jne near .x
        mov dl, byte [byte ebx+pflags]
        test dl, 2
        je short .1
        mov dh, dl
        and dh, 0FDh
        mov byte [byte ebx+pflags], dh
        mov word [byte ebx+temp2], 8
        mov word [byte ebx+temp4], 6
        mov word [byte ebx+temp3], 0FF6Fh
        mov word [byte ebx+temp1], 0
        mov word [byte ebx+temp5], 0
.1:
        mov cx, word [byte ebx+temp1]
        cmp cx, byte 64h
        jne near .2
        cmp cx, word [doortemp1]
        jne near .x
        mov word [doortemp1], 0C8h
        xor al, al
        mov byte [byte_DFFE2], al
        or byte [doorpflags], 20h
        mov edx, 0EA9h
        mov eax, sortobj15
        call SetSPA
        and byte [byte ebx+055h], 0F7h
        mov word [byte ebx+012h], 165h
        mov word [byte ebx+facedir], 2
        mov byte [byte ebx+046h], 0
        or byte [byte ebx+pflags], 20h
        mov edx, 0E83h
        mov eax, ebx
        call SetSPA
        mov eax, dword [byte ebx+044h]
        sar eax, 18h
        mov edx, dword [byte ebx+06Ch]
        mov word [byte edx+eax*2+tmpde], 800h
        mov eax, ebx
        call assexit
        test byte [byte ebx+pflags], 40h
        setne al
        and eax, 0FFh
        call SetBoxDoorObject
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.2:
        mov esi, ecx
        dec esi
        mov word [byte ebx+temp1], si
        test si, si
        jge near .8
        mov eax, esi
        add eax, 8
        mov word [byte ebx+temp1], ax
        mov ax, word [byte ebx+Ypos+2]
        mov dx, word [byte ebx+temp4]
        sub eax, edx
        mov word [regd1], ax
        mov ax, word [byte ebx+Xpos+2]
        mov cx, word [byte ebx+temp3]
        sub eax, ecx
        mov word [regd0], ax
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
        cmp eax, byte 4
        jg near .8
        cmp word [regd0], byte 4
        jg near .8
        mov ax, word [byte ebx+temp4]
        mov word [byte ebx+Ypos+2], ax
        mov ax, word [byte ebx+temp3]
        mov word [byte ebx+Xpos+2], ax
        mov word [byte ebx+Yvel], 0
        mov word [byte ebx+Xvel], 0
        mov edx, 289h
        mov eax, ebx
        call SetSPA
        or byte [byte ebx+pflags], 4
        mov ax, word [byte ebx+facedir]
        cmp ax, 6
        je short .7
        cmp ax, 7
        jge short .5
        cmp ax, 2
        jle short .5
        mov eax, 1
        jmp short .6
.5:
        mov eax, 0FFFFFFFFh
.6:
        mov edx, dword [byte ebx+facedir-2]
        sar edx, 10h
        add eax, edx
        and eax, byte 7
        mov word [byte ebx+facedir], ax
.7:
        cmp word [byte ebx+facedir], byte 6
        jne short .x
        mov word [byte ebx+temp1], 64h
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.8:
        test byte [byte ebx+pflags], 4
        jne short .x
        mov ax, word [byte ebx+temp3]
        mov word [regd0], ax
        mov ax, word [byte ebx+temp4]
        mov word [regd1], ax
        xor edx, edx
        mov eax, ebx
        call SkateToSpot
.x:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assbenchside                                    49BC2  95 PC, low confidence
; Asstab 2Bh (clockcont_0): when the camera is at the left boards (camx <=
; -20h, |camy| <= 14h) places the sprite at x -0BEh,y 3 and plays bench-side
; animations 0E97h / 0EB5h; waits on PaSpeechBusy
;-----------------------------------------------------------------------------
; C: src/engine/logic/assbenchside.c
%ifdef CBUILD
%include "c/engine/logic/assbenchside.inc"
%else
assbenchside:
        push dword 10h
        call __CHK
        push ebx
        push edx
        push edi
        mov ebx, eax
        test byte [byte eax+044h], 2
        je near .4
        mov eax, ebx
        call puckshadow
        call PaSpeechBusy
        test eax, eax
        jne near .x
        cmp word [ovltimer], 100h
        jne short .1
        mov word [ovltimer], 258h
.1:
        mov eax, dword [camx-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFE0h
        jg near .x
        cmp word [camy], byte 0
        jge short .2
        mov eax, dword [camy-2]
        sar eax, 10h
        neg eax
        jmp short .3
.2:
        mov eax, dword [camy-2]
        sar eax, 10h
.3:
        cmp eax, byte 14h
        jg near .x
        and byte [byte ebx+pflags], 0FDh
        mov word [byte ebx+Xpos+2], 0FF42h
        mov word [byte ebx+Ypos+2], 3
        mov word [byte ebx+temp1], 0
        mov word [byte ebx+Yvel], 0
        mov ax, word [byte ebx+Yvel]
        mov word [byte ebx+Xvel], ax
        mov byte [byte ebx+046h], 0
        mov word [byte ebx+012h], 362h
        mov edx, 0E97h
        mov eax, ebx
        call SetSPA
.4:
        mov di, word [byte ebx+temp1]
        cmp di, byte 64h
        jge short .6
        cmp word [byte ebx+SPA], byte 0
        jne short .5
        mov word [byte ebx+temp1], 64h
        pop edi
        pop edx
        pop ebx
        ret
.5:
        cmp word [byte ebx+SPAnum], byte 4
        jl short .x
        cmp word [byte ebx+SPAcnt], byte 0Bh
        jg short .x
        mov word [byte ebx+Xpos+2], 0FF51h
        pop edi
        pop edx
        pop ebx
        ret
.6:
        cmp di, 0C8h
        jne short .x
        cmp word [byte ebx+012h], 365h
        jne short .x
        cmp word [byte ebx+SPA], byte 0
        jne short .x
        mov eax, 28h
        call randomd0
        test ax, ax
        jne short .x
        mov edx, 0EB5h
        mov eax, ebx
        call SetSPA
.x:
        pop edi
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assdefo                                               49CDD  94G logic94.asm
; Asstab slot 1; field alignment 82% of 11 known-field accesses; content rank
; 1/34 vs other slot routines; 0 known Genesis callees present, 0 missing, 0
; extra
;-----------------------------------------------------------------------------
; C: src/engine/logic/assdefo.c
%ifdef CBUILD
%include "c/engine/logic/assdefo.inc"
%else
assdefo:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov ebx, eax
        test byte [byte eax+pflags], 20h
        jne near .x
        mov eax, ebx
        call check4bench
        test ax, ax
        jne near .x
        test byte [gmode], 1
        je short .1
        mov eax, ebx
        call donothing
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        mov dh, byte [byte ebx+pflags]
        test dh, 8
        jne near .x
        test dh, 2
        je short .2
        mov ch, dh
        and ch, 0FDh
        mov byte [byte ebx+pflags], ch
        mov word [byte ebx+temp1], ax
        mov word [byte ebx+temp2], 8
.2:
        mov al, byte [byte ebx+027h]
        dec al
        mov byte [byte ebx+027h], al
        test al, al
        jge near .6
        mov al, byte [byte ebx+05Ah]
        mov byte [byte ebx+027h], al
        mov eax, dword [byte ebx+06Ch]
        test byte [byte eax+tmflags], 10h
        je short .4
.3:
        mov edx, 2
        mov eax, ebx
        call assreplace
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.4:
        mov eax, dword [pucky]
        mov ax, word [eax]
        mov word [regd1], ax
        test byte [byte ebx+pflags], 80h
        jne short .5
        mov edx, eax
        neg edx
        mov word [regd1], dx
.5:
        cmp word [regd1], byte 53h
        jl short assdefo.3
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jl short .6
        cmp word [byte ebx+SCnum], byte 6
        setl al
        xor edx, edx
        mov dl, al
        mov eax, dword [puckc]
        cmp byte [eax], 6
        setl al
        and eax, 0FFh
        xor eax, edx
        jne short assdefo.3
.6:
        cmp word [byte ebx+position], byte 2
        jne short .7
        mov eax, 64h
        jmp short .8
.7:
        mov eax, 0FFFFFF9Ch
.8:
        mov word [regd0], ax
        mov word [regd1], 58h
        test byte [byte ebx+pflags], 80h
        jne short .9
        neg word [regd0]
        mov word [regd1], 0FFA8h
.9:
        mov eax, dword [puckx]
        movsx edx, word [eax]
        mov ecx, dword [regd0-2]
        sar ecx, 10h
        mov esi, edx
        xor esi, ecx
        test esi, esi
        jl short .10
        mov ax, word [eax]
        mov word [regd0], ax
        jmp short .11
.10:
        sar edx, 1
        add edx, ecx
        mov word [regd0], dx
.11:
        mov edx, EvadePC
        mov eax, ebx
        call skateto
.x:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assdefd                                               49E3A  94G logic94.asm
; Asstab slot 2; field alignment 81% of 31 known-field accesses; content rank
; 1/34 vs other slot routines; 0 known Genesis callees present, 0 missing, 0
; extra
;-----------------------------------------------------------------------------
; C: src/engine/logic/assrefwhistle.c (assdefd)
%ifdef CBUILD
%include "c/engine/logic/assrefwhistle.assdefd.inc"
%else
assdefd:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ebx, eax
        test byte [byte eax+pflags], 20h
        jne near ass_popx
        mov eax, ebx
        call check4bench
        test ax, ax
        jne near ass_popx
        test byte [gmode], 1
        je short .1
        mov eax, ebx
        call donothing
        jmp near ass_popx
.1:
        mov dh, byte [byte ebx+pflags]
        test dh, 8
        jne near ass_popx
        test dh, 2
        je short .2
        mov ch, dh
        and ch, 0FDh
        mov byte [byte ebx+pflags], ch
        mov word [byte ebx+temp1], ax
        mov word [byte ebx+temp2], 8
.2:
        mov al, byte [byte ebx+027h]
        dec al
        mov byte [byte ebx+027h], al
        test al, al
        jge near .27
        mov al, byte [byte ebx+05Ah]
        mov byte [byte ebx+027h], al
        mov eax, dword [pucky]
        mov ax, word [eax]
        mov word [regd1], ax
        mov eax, dword [puckvy]
        movsx eax, word [eax]
        sar eax, 6
        mov word [regd3], ax
        test byte [byte ebx+pflags], 80h
        jne short .3
        neg word [regd1]
        mov ecx, eax
        neg ecx
        mov word [regd3], cx
.3:
        cmp word [regd3], byte 0
        jge short .4
        xor edi, edi
        mov word [regd3], di
.4:
        mov ax, word [regd1]
        mov dx, word [regd3]
        add edx, eax
        mov word [regd3], dx
        cmp dx, byte 4Eh
        jl near .8
        mov eax, dword [byte ebx+06Ch]
        test byte [byte eax+tmflags], 10h
        jne near .8
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jl near .8
        test byte [gmode2], 20h
        je short .5
        mov al, byte [byte ebx+pflags]
        and al, 40h
        xor edx, edx
        mov dl, al
        mov ax, word [gmode2]
        xor ah, ah
        and al, 40h
        cwde
        xor eax, edx
        jne short .6
.5:
        mov eax, 1
        jmp short .7
.6:
        xor eax, eax
.7:
        test eax, eax
        je short .8
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jl short .8
        cmp word [byte ebx+SCnum], byte 6
        setl al
        mov edx, eax
        and edx, 0FFh
        mov eax, dword [puckc]
        cmp byte [eax], 6
        setl al
        and eax, 0FFh
        cmp eax, edx
        jne short .8
        mov edx, 1
        mov eax, ebx
        call assreplace
        jmp near ass_popx
.8:
        cmp word [byte ebx+position], byte 2
        jne short .9
        mov eax, 50h
        jmp short .10
.9:
        mov eax, 0FFFFFFB0h
.10:
        mov word [byte ebx+temp3], ax
        cmp word [byte ebx+SCnum], byte 6
        jge short .11
        mov eax, 6
        jmp short .12
.11:
        xor eax, eax
.12:
        shl eax, 7
        add eax, SortCords
        mov word [regd2], 6
        test byte [byte ebx+pflags], 80h
        je near .17
        mov word [regd0], 3E8h
.13:
        test byte [byte eax+pflags2], 4
        jne short .15
        cmp word [byte eax+position], byte 0
        jl short .15
        mov dx, word [byte eax+Yvel]
        mov word [regd1], dx
        test dx, dx
        jle short .14
        xor esi, esi
        mov word [regd1], si
.14:
        mov ecx, dword [byte eax+Ypos]
        sar ecx, 10h
        mov edx, dword [regd1-2]
        sar edx, 14h
        add edx, ecx
        mov word [regd1], dx
        cmp dx, word [regd0]
        jg short .15
        mov word [regd0], dx
.15:
        add eax, 80h
        mov dx, word [regd2]
        dec dx
        mov word [regd2], dx
        jne short assdefd.13
        sub word [regd0], byte 32h
        mov eax, dword [regd0-2]
        sar eax, 10h
        cmp eax, 0FFFFFF56h
        jg short .16
        mov word [regd0], 0FF3Dh
.16:
        mov ax, word [regd0]
        mov word [byte ebx+temp4], ax
        jmp near .22
.17:
        mov word [regd0], 0FC18h
.18:
        test byte [byte eax+pflags2], 4
        jne short .20
        cmp word [byte eax+position], byte 0
        jl short .20
        mov dx, word [byte eax+Yvel]
        mov word [regd1], dx
        test dx, dx
        jge short .19
        xor ecx, ecx
        mov word [regd1], cx
.19:
        mov ecx, dword [byte eax+Ypos]
        sar ecx, 10h
        mov edx, dword [regd1-2]
        sar edx, 14h
        add edx, ecx
        mov word [regd1], dx
        cmp dx, word [regd0]
        jl short .20
        mov word [regd0], dx
.20:
        add eax, 80h
        mov di, word [regd2]
        dec di
        mov word [regd2], di
        jne short assdefd.18
        mov cx, word [regd0]
        add ecx, byte 32h
        mov word [regd0], cx
        cmp cx, 0AAh
        jl short .21
        mov word [regd0], 0C3h
.21:
        mov ax, word [regd0]
        mov word [byte ebx+temp4], ax
        neg word [byte ebx+temp3]
.22:
        mov edx, dword [byte ebx+temp3-2]
        sar edx, 10h
        mov eax, dword [puckx]
        movsx eax, word [eax]
        xor eax, edx
        test eax, eax
        jge short .27
        mov word [byte ebx+temp3], 0
        cmp word [regd0], byte 0
        jge short .23
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .24
.23:
        mov eax, dword [regd0-2]
        sar eax, 10h
.24:
        cmp eax, 0C3h
        jne short .27
        cmp word [regd0], byte 0
        jge short .25
        mov eax, 0FFFFFF4Ah
        jmp short .26
.25:
        mov eax, 0B6h
.26:
        mov word [byte ebx+temp4], ax
.27:
        mov ax, word [byte ebx+temp3]
        mov word [regd0], ax
        mov ax, word [byte ebx+temp4]
        mov word [regd1], ax
        mov edx, EvadePC
        mov eax, ebx
        call skateto
        mov eax, ebx
        call check4check
        jmp near ass_popx
%endif ; C
;-----------------------------------------------------------------------------
; asswingd                           4A1A6  94G logic94.asm, medium confidence
; Asstab slot 3; field alignment 80% of 10 known-field accesses; content rank
; 2/34 vs other slot routines; 0 known Genesis callees present, 0 missing, 0
; extra
;-----------------------------------------------------------------------------
; C: src/engine/logic/assrefwhistle.c (asswingd)
%ifdef CBUILD
%include "c/engine/logic/assrefwhistle.asswingd.inc"
%else
asswingd:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ebx, eax
        test byte [byte eax+pflags], 20h
        jne near ass_popx
        mov eax, ebx
        call check4bench
        test ax, ax
        jne near ass_popx
        test byte [gmode], 1
        je short .1
        mov eax, ebx
        call donothing
        jmp near ass_popx
.1:
        mov dh, byte [byte ebx+pflags]
        test dh, 8
        jne near ass_popx
        test dh, 2
        je short .2
        mov ch, dh
        and ch, 0FDh
        mov byte [byte ebx+pflags], ch
        mov word [byte ebx+temp1], ax
        mov word [byte ebx+temp2], 8
.2:
        mov al, byte [byte ebx+027h]
        dec al
        mov byte [byte ebx+027h], al
        test al, al
        jge short .3
        mov al, byte [byte ebx+059h]
        mov byte [byte ebx+027h], al
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jl short .3
        cmp word [byte ebx+SCnum], byte 6
        setl al
        xor edx, edx
        mov dl, al
        mov eax, dword [puckc]
        cmp byte [eax], 6
        setl al
        and eax, 0FFh
        cmp eax, edx
        jne short .3
        mov edx, 4
        mov eax, ebx
        call assreplace
        jmp near ass_popx
.3:
        cmp word [byte ebx+position], byte 5
        jne short .4
        mov eax, 0FFFFFF88h
        jmp short .5
.4:
        mov eax, 78h
.5:
        mov dword [regd0], eax
        mov word [regd1], 8Eh
        mov edi, 44h
        mov word [regd2], di
        test byte [byte ebx+pflags], 80h
        je short .10
        neg word [regd0]
        mov word [regd1], 0FF72h
        mov esi, 0FFFFFFBCh
        mov word [regd2], si
        mov eax, dword [byte ebx+06Ch]
        test byte [byte eax+tmflags], 10h
        je short .6
        mov word [regd1], si
        jmp short .11
.6:
        mov eax, dword [pucky]
        mov di, word [eax]
        cmp di, si
        jl short .8
.7:
        mov word [regd1], di
        jmp short .11
.8:
        mov edx, 0FFFFFF18h
        mov word [regd2], dx
        cmp dx, word [eax]
        jl short .11
.9:
        mov word [regd1], dx
        jmp short .11
.10:
        mov eax, dword [byte ebx+06Ch]
        test byte [byte eax+tmflags], 10h
        jne short asswingd.7
        mov eax, dword [pucky]
        mov dx, word [eax]
        cmp dx, di
        jle short asswingd.9
        mov ecx, 0E8h
        mov word [regd2], cx
        cmp cx, word [eax]
        jg short .11
        mov word [regd1], cx
.11:
        mov eax, dword [puckx]
        movsx ecx, word [eax]
        mov edx, dword [regd0-2]
        sar edx, 10h
        xor edx, ecx
        test edx, edx
        jl short asswingd_skate0
        mov ax, word [eax]
        mov word [regd0], ax
asswingd_skate0:
        xor edx, edx
asswingd_skateto:
        mov eax, ebx
        call skateto
        jmp near ass_popx
%endif ; C
;-----------------------------------------------------------------------------
; asswingo                                              4A343  94G logic94.asm
; Asstab slot 4; field alignment 83% of 18 known-field accesses; content rank
; 1/34 vs other slot routines; 0 known Genesis callees present, 0 missing, 1
; extra
;-----------------------------------------------------------------------------
; C: src/engine/logic/assrefwhistle.c (asswingo)
%ifdef CBUILD
%include "c/engine/logic/assrefwhistle.asswingo.inc"
%else
asswingo:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ebx, eax
        test byte [byte eax+pflags], 20h
        jne near ass_popx
        mov eax, ebx
        call check4bench
        test ax, ax
        jne near ass_popx
        test byte [gmode], 1
        je short .1
        mov eax, ebx
        call donothing
        jmp near ass_popx
.1:
        mov dh, byte [byte ebx+pflags]
        test dh, 8
        jne near ass_popx
        test dh, 2
        je short .2
        mov ch, dh
        and ch, 0FDh
        mov byte [byte ebx+pflags], ch
        mov byte [byte ebx+02Fh], 0FFh
        mov word [byte ebx+temp1], ax
        mov word [byte ebx+temp2], 8
.2:
        mov al, byte [byte ebx+027h]
        dec al
        mov byte [byte ebx+027h], al
        test al, al
        jge near .7
        mov al, byte [byte ebx+059h]
        mov byte [byte ebx+027h], al
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jl short .3
        cmp word [byte ebx+SCnum], byte 6
        setl al
        mov edx, eax
        and edx, 0FFh
        mov eax, dword [puckc]
        cmp byte [eax], 6
        setl al
        and eax, 0FFh
        xor eax, edx
        je short .3
        mov edx, 3
        mov eax, ebx
        call assreplace
        jmp near ass_popx
.3:
        mov eax, dword [pucky]
        mov ax, word [eax]
        mov word [regd0], ax
        mov edx, dword [puckvy]
        movsx edx, word [edx]
        sar edx, 6
        mov eax, dword [regd0-2]
        sar eax, 10h
        add eax, edx
        mov word [regd3], ax
        test byte [byte ebx+pflags], 80h
        jne short .4
        neg word [regd0]
        mov esi, eax
        neg esi
        mov word [regd3], si
.4:
        xor edx, edx
        mov eax, dword [regd3-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFB2h
        jl short .5
        mov edx, 4
        cmp word [regd0], byte 4Eh
        jl short .5
        mov eax, dword [byte ebx+06Ch]
        test byte [byte eax+tmflags], 10h
        jne short .5
        mov edx, 8
        cmp word [regd3], 0E8h
        jl short .5
        mov edx, 0Ch
.5:
        cmp dx, word [byte ebx+temp5]
        jne short .6
        mov eax, 80h
        call randomd0
        mov word [regd0], ax
        test ax, ax
        jne short .7
.6:
        mov word [byte ebx+temp5], dx
        movsx edx, dx
        mov ax, word [nosplit edx*2+asswingo_dedata_xrand]
        add eax, eax
        cwde
        call randomd0
        sub ax, word [nosplit edx*2+asswingo_dedata_xrand]
        mov cx, word [nosplit edx*2+asswingo_dedata]
        add ecx, eax
        xor eax, eax
        mov al, byte [byte ebx+059h]
        add ecx, eax
        mov word [byte ebx+temp3], cx
        mov ax, word [nosplit edx*2+asswingo_dedata_yrand]
        add eax, eax
        cwde
        call randomd0
        mov di, word [nosplit edx*2+asswingo_dedata_yrand]
        mov ecx, eax
        sub ecx, edi
        mov ax, word [nosplit edx*2+asswingo_dedata_y]
        add ecx, eax
        mov word [byte ebx+temp4], cx
.7:
        mov ax, word [byte ebx+temp3]
        mov word [regd0], ax
        cmp word [byte ebx+position], byte 5
        je short .8
        neg word [regd0]
.8:
        mov ax, word [byte ebx+temp4]
        mov word [regd1], ax
        test byte [byte ebx+pflags], 80h
        jne short asswingo_evade
        neg word [regd0]
        mov esi, eax
        neg esi
        mov word [regd1], si
asswingo_evade:
        mov edx, EvadePC
        jmp near asswingd_skateto
%endif ; C
;-----------------------------------------------------------------------------
; asscenterd                                            4A53A  94G logic94.asm
; Asstab slot 5; field alignment 80% of 10 known-field accesses; content rank
; 1/34 vs other slot routines; 0 known Genesis callees present, 0 missing, 0
; extra
;-----------------------------------------------------------------------------
; C: src/engine/logic/asscenterd.c
%ifdef CBUILD
%include "c/engine/logic/asscenterd.inc"
%else
asscenterd:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov ebx, eax
        test byte [byte eax+pflags], 20h
        jne near .x
        mov eax, ebx
        call check4bench
        test ax, ax
        jne near .x
        test byte [gmode], 1
        je short .1
        mov eax, ebx
        call donothing
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        mov dh, byte [byte ebx+pflags]
        test dh, 8
        jne near .x
        test dh, 2
        je short .2
        mov ch, dh
        and ch, 0FDh
        mov byte [byte ebx+pflags], ch
        mov word [byte ebx+temp1], ax
        mov word [byte ebx+temp2], 8
.2:
        mov al, byte [byte ebx+027h]
        dec al
        mov byte [byte ebx+027h], al
        test al, al
        jge short .3
        mov al, byte [byte ebx+059h]
        mov byte [byte ebx+027h], al
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jl short .3
        cmp word [byte ebx+SCnum], byte 6
        setl al
        mov edx, eax
        and edx, 0FFh
        mov eax, dword [puckc]
        cmp byte [eax], 6
        setl al
        and eax, 0FFh
        cmp eax, edx
        jne short .3
        mov edx, 6
        mov eax, ebx
        call assreplace
        pop edx
        pop ecx
        pop ebx
        ret
.3:
        mov eax, dword [puckx]
        movsx eax, word [eax]
        sar eax, 1
        mov word [regd0], ax
        mov eax, dword [pucky]
        mov ax, word [eax]
        mov word [regd2], ax
        test byte [byte ebx+pflags], 80h
        jne short .4
        mov ecx, eax
        neg ecx
        mov word [regd2], cx
.4:
        mov word [regd1], 0FF8Fh
        mov eax, dword [regd2-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFB2h
        jl short .5
        mov eax, dword [pucky]
        movsx eax, word [eax]
        sub eax, byte 71h
        sar eax, 1
        mov word [regd1], ax
.5:
        test byte [byte ebx+pflags], 80h
        jne short .6
        neg word [regd1]
.6:
        xor edx, edx
        mov eax, ebx
        call skateto
.x:
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; asscentero                                            4A65C  94G logic94.asm
; Asstab slot 6; field alignment 82% of 17 known-field accesses; content rank
; 1/34 vs other slot routines; 0 known Genesis callees present, 0 missing, 1
; extra
;-----------------------------------------------------------------------------
; C: src/engine/logic/assrefwhistle.c (asscentero)
%ifdef CBUILD
%include "c/engine/logic/assrefwhistle.asscentero.inc"
%else
asscentero:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ebx, eax
        test byte [byte eax+pflags], 20h
        jne near ass_popx
        mov eax, ebx
        call check4bench
        test ax, ax
        jne near ass_popx
        test byte [gmode], 1
        je short .1
        mov eax, ebx
        call donothing
        jmp near ass_popx
.1:
        mov dh, byte [byte ebx+pflags]
        test dh, 8
        jne near ass_popx
        test dh, 2
        je short .2
        mov ch, dh
        and ch, 0FDh
        mov byte [byte ebx+pflags], ch
        mov byte [byte ebx+02Fh], 0FFh
        mov word [byte ebx+temp1], ax
        mov word [byte ebx+temp2], 8
.2:
        mov al, byte [byte ebx+027h]
        dec al
        mov byte [byte ebx+027h], al
        test al, al
        jge near .7
        mov al, byte [byte ebx+059h]
        mov byte [byte ebx+027h], al
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jl short .3
        cmp word [byte ebx+SCnum], byte 6
        setl al
        mov edx, eax
        and edx, 0FFh
        mov eax, dword [puckc]
        cmp byte [eax], 6
        setl al
        and eax, 0FFh
        xor eax, edx
        je short .3
        mov edx, 5
        mov eax, ebx
        call assreplace
        jmp near ass_popx
.3:
        mov eax, dword [pucky]
        mov ax, word [eax]
        mov word [regd0], ax
        test byte [byte ebx+pflags], 80h
        jne short .4
        mov ecx, eax
        neg ecx
        mov word [regd0], cx
.4:
        xor edx, edx
        mov eax, dword [regd0-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFB2h
        jl short .5
        mov edx, 4
        mov si, word [regd0]
        cmp si, byte 4Eh
        jl short .5
        mov eax, dword [byte ebx+06Ch]
        test byte [byte eax+tmflags], 10h
        jne short .5
        mov edx, 8
        cmp si, 0E8h
        jl short .5
        mov edx, 0Ch
.5:
        cmp dx, word [byte ebx+temp5]
        jne short .6
        mov eax, 80h
        call randomd0
        mov word [regd0], ax
        test ax, ax
        jne short .7
.6:
        mov word [byte ebx+temp5], dx
        movsx edx, dx
        mov ax, word [nosplit edx*2+asscentero_dedata_xrand]
        add eax, eax
        cwde
        call randomd0
        sub ax, word [nosplit edx*2+asscentero_dedata_xrand]
        mov cx, word [nosplit edx*2+asscentero_dedata]
        add eax, ecx
        mov word [byte ebx+temp3], ax
        mov ax, word [nosplit edx*2+asscentero_dedata_yrand]
        add eax, eax
        cwde
        call randomd0
        sub ax, word [nosplit edx*2+asscentero_dedata_yrand]
        mov dx, word [nosplit edx*2+asscentero_dedata_y]
        add eax, edx
        mov word [byte ebx+temp4], ax
.7:
        mov ax, word [byte ebx+temp3]
        mov word [regd0], ax
        mov ax, word [byte ebx+temp4]
        mov word [regd1], ax
        test byte [byte ebx+pflags], 80h
        jne near asswingo_evade
        mov edi, eax
        neg edi
        mov word [regd1], di
        jmp near asswingo_evade
%endif ; C
;-----------------------------------------------------------------------------
; donothing                                             4A80E  94G logic94.asm
; The 94G donothing: doplayeracc 8 unless pfalock or pfjoycon
;-----------------------------------------------------------------------------
; C: src/engine/logic/donothing.c
%ifdef CBUILD
%include "c/engine/logic/donothing.inc"
%else
donothing:
        push dword 8
        call __CHK
        push edx
        mov dl, byte [byte eax+044h]
        test dl, 20h
        jne short .x
        test dl, 8
        jne short .x
        mov edx, 8
        call doplayeracc
.x:
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assstanley                         4A832  94G logic94.asm, medium confidence
; Asstab slot 8; field alignment 70% of 10 known-field accesses; content rank
; 1/34 vs other slot routines; 2 known Genesis callees present, 0 missing, 0
; extra
;-----------------------------------------------------------------------------
; C: src/engine/logic/assstanley.c
%ifdef CBUILD
%include "c/engine/logic/assstanley.inc"
%else
assstanley:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov ebx, eax
        test byte [byte eax+pflags], 20h
        jne near .x
        mov dl, byte [byte ebx+pflags]
        test dl, 2
        je short .1
        mov dh, dl
        and dh, 0FDh
        mov byte [byte ebx+pflags], dh
        mov word [byte ebx+temp3], 0FFB0h
        mov word [byte ebx+temp4], 0
        mov word [byte ebx+temp1], 0
        mov byte [byte ebx+046h], 0
        mov edx, 0ECBh
        mov eax, ebx
        call SetSPA
        mov word [Pencntdwn], 100h
.1:
        cmp word [byte ebx+SPA], byte 0
        jne short .2
        mov eax, dword [byte ebx+044h]
        sar eax, 18h
        mov edx, dword [byte ebx+06Ch]
        mov word [byte edx+eax*2+tmpde], 300h
        mov edx, 833h
        mov eax, ebx
        call SetSPA
.2:
        mov ax, word [byte ebx+temp4]
        sub ax, word [byte ebx+Ypos+2]
        movsx edx, ax
        mov ax, word [byte ebx+temp3]
        sub ax, word [byte ebx+Xpos+2]
        cwde
        call vtoa
        mov word [regd0], ax
        cmp ax, 7
        jg short .x
        mov ax, word [byte ebx+temp1]
        dec eax
        mov word [byte ebx+temp1], ax
        test ax, ax
        jge short .3
        mov ecx, eax
        add ecx, byte 0Ch
        mov word [byte ebx+temp1], cx
        mov ax, word [byte ebx+facedir]
        cmp ax, word [regd0]
        je short .3
        inc eax
        xor ah, ah
        and al, 7
        mov word [byte ebx+facedir], ax
.3:
        mov edx, dword [regd0-2]
        sar edx, 10h
        mov eax, ebx
        call playeracc
.x:
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assscore                                              4A90F  94G logic94.asm
; Asstab slot 7; field alignment 92% of 13 known-field accesses; content rank
; 1/34 vs other slot routines; 2 known Genesis callees present, 0 missing, 0
; extra
;-----------------------------------------------------------------------------
; C: src/engine/logic/assscore.c
%ifdef CBUILD
%include "c/engine/logic/assscore.inc"
%else
assscore:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push edi
        mov ebx, eax
        mov eax, dword [puckc]
        movsx dx, byte [eax]
        cmp dx, word [byte ebx+SCnum]
        jne short .1
        mov byte [eax], 0FFh
        mov eax, dword [puckstruct+1Ah]
        sar eax, 10h
        add eax, puckstruct
        cmp byte [byte eax+01Eh], 18h
        jne short .1
        mov edx, 1Ah
        mov eax, puckstruct
        call assreplace
.1:
        test byte [byte ebx+pflags], 20h
        jne near .x
        mov eax, ebx
        call check4bench
        test ax, ax
        jne near .x
        mov cl, byte [byte ebx+pflags]
        test cl, 2
        je near .6
        mov ch, cl
        and ch, 0FDh
        mov byte [byte ebx+pflags], ch
        mov eax, 78h
        call randomd0
        mov word [byte ebx+temp1], ax
        mov word [byte ebx+temp2], 8
        test byte [gmode], 80h
        je short .2
        mov word [byte ebx+temp3], 0FFB0h
        mov word [byte ebx+temp4], 0
        jmp short .5
.2:
        cmp word [camx], byte 0
        jge short .3
        mov eax, 0FFFFFF9Ch
        jmp short .4
.3:
        mov eax, 64h
.4:
        mov word [byte ebx+temp3], ax
        mov ax, word [camy]
        mov word [byte ebx+temp4], ax
        cmp word [camx], byte 0
        jge short .5
        sub eax, byte 37h
        mov word [byte ebx+temp4], ax
.5:
        mov ax, word [byte ebx+SCnum]
        cmp ax, word [shotplayer]
        jne short .6
        xor edx, edx
        mov dword [assscore_dancecnt], edx
.6:
        mov cx, word [byte ebx+temp1]
        dec ecx
        mov word [byte ebx+temp1], cx
        test cx, cx
        jge near .12
        or byte [byte ebx+pflags], 20h
        mov word [regd1], 731h
        mov eax, 78h
        call randomd0
        mov word [byte ebx+temp1], ax
        mov ax, word [byte ebx+SCnum]
        cmp ax, word [shotplayer]
        jne short .11
        mov word [regd1], 769h
        mov ecx, dword [assscore_dancecnt]
        test ecx, ecx
        je short .7
        cmp ecx, byte 3
        jge short .8
        mov eax, 2
        call randomd0
        test ax, ax
        jne short .8
.7:
        mov word [byte ebx+temp1], 0
        inc dword [assscore_dancecnt]
        jmp short .11
.8:
        xor edi, edi
        mov dword [assscore_dancecnt], edi
        cmp word [byte ebx+temp1], byte 1Eh
        jle short .9
        mov eax, dword [byte ebx+temp1-2]
        sar eax, 10h
        jmp short .10
.9:
        mov eax, 1Eh
.10:
        mov word [byte ebx+temp1], ax
.11:
        mov edx, dword [regd1-2]
        sar edx, 10h
        mov eax, ebx
        call SetSPA
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.12:
        test byte [byte ebx+pflags], 8
        jne short .x
        mov ax, word [byte ebx+temp3]
        mov word [regd0], ax
        mov ax, word [byte ebx+temp4]
        mov word [regd1], ax
        xor edx, edx
        mov eax, ebx
        call skateto
.x:
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; asseben                                               4AAC2  94G logic94.asm
; Asstab slot 9; field alignment 88% of 16 known-field accesses; content rank
; 1/34 vs other slot routines; 1 known Genesis callees present, 0 missing, 0
; extra
;-----------------------------------------------------------------------------
; C: src/engine/logic/asseben.c
%ifdef CBUILD
%include "c/engine/logic/asseben.inc"
%else
asseben:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov dl, byte [byte eax+pflags]
        test dl, 20h
        jne near .x
        test dl, 2
        je near .4
        mov cl, dl
        and cl, 0FDh
        mov byte [byte eax+pflags], cl
        mov word [byte eax+Xvel], 0
        mov word [byte eax+Yvel], 0
        mov word [byte eax+048h], 0
        mov dx, word [byte eax+SCnum]
        sub edx, byte 6
        mov word [regd0], dx
        test dx, dx
        jl short .1
        mov ebx, edx
        add ebx, byte 2
        mov word [regd0], bx
.1:
        mov dx, word [regd0]
        imul edx, byte 0Eh
        mov word [byte eax+Ypos+2], dx
        mov word [byte eax+Xpos+2], 0FF60h
        mov word [byte eax+facedir], 2
        mov ch, byte [byte eax+pflags]
        and ch, 0CFh
        mov dl, ch
        or dl, 20h
        mov byte [byte eax+pflags], dl
        cmp word [byte eax+position], byte 0
        jne short .2
        mov edx, 0D15h
        jmp short .3
.2:
        mov edx, 7A1h
.3:
        movsx edx, dx
        call SetSPA
        pop edx
        pop ecx
        pop ebx
        ret
.4:
        mov word [byte eax+facedir], 4
        and byte [byte eax+pflags], 0FBh
        and byte [byte eax+pflags2], 0DBh
        mov word [byte eax+SPA], 0
        mov word [byte eax+Xvel], 1000h
        call assexit
.x:
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assleaveice                                  4AB87  95 PC, medium confidence
; Asstab 1Dh (set by assthreestars, InProgress): skates to the bench gate (x
; -0A8h, y +-1Ch/24h by team), turns, plays the exit animation, sets pflags
; 20h (off ice) and RemoveFromLines (gsp<4, not gmode 40h); then assreplace
; 29h
;-----------------------------------------------------------------------------
; C: src/engine/logic/assleaveice.c
%ifdef CBUILD
%include "c/engine/logic/assleaveice.inc"
%else
assleaveice:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push edi
        mov ebx, eax
        test byte [byte eax+pflags], 20h
        jne near .x
        cmp word [byte ebx+temp1], byte 64h
        je near .17
        mov dh, byte [byte ebx+pflags]
        test dh, 2
        je near .6
        mov cl, dh
        and cl, 0FDh
        mov byte [byte ebx+pflags], cl
        or byte [byte ebx+pflags2], 4
        test byte [byte ebx+pflags], 8
        je short .3
        mov ax, word [byte ebx+SCnum]
        cmp ax, word [c1playernum]
        jne short .1
        xor edi, edi
        mov word [regd4], di
        jmp short .2
.1:
        mov word [regd4], 2
.2:
        mov edx, dword [regd4-2]
        sar edx, 10h
        mov eax, ebx
        call changeplayer
.3:
        mov word [byte ebx+temp2], 8
        test byte [byte ebx+pflags], 40h
        jne short .4
        mov eax, 0FFFFFFE4h
        jmp short .5
.4:
        mov eax, 24h
.5:
        mov word [byte ebx+temp4], ax
        mov word [byte ebx+temp3], 0FF58h
        mov word [byte ebx+temp1], 0
        or byte [byte ebx+pflags2], 20h
        mov word [byte ebx+Wallcos], 0
        mov word [byte ebx+Wallsin], 0
.6:
        mov ax, word [byte ebx+temp1]
        dec eax
        mov word [byte ebx+temp1], ax
        test ax, ax
        jge near .16
        mov ecx, eax
        add ecx, byte 8
        mov word [byte ebx+temp1], cx
        mov ax, word [byte ebx+Ypos+2]
        sub ax, word [byte ebx+temp4]
        mov dx, word [byte ebx+Xpos+2]
        mov di, word [byte ebx+temp3]
        sub edx, edi
        mov word [regd0], dx
        test ax, ax
        jge short .7
        cwde
        neg eax
        jmp short .8
.7:
        cwde
.8:
        cmp eax, byte 14h
        jg near .16
        cmp word [regd0], byte 20h
        jg near .16
        cmp word [byte ebx+position], byte 0
        jne short .9
        mov eax, 1
        jmp short .10
.9:
        mov eax, 289h
.10:
        mov word [regd1], ax
        mov edx, dword [regd1-2]
        sar edx, 10h
        mov eax, ebx
        call SetSPA
        or byte [byte ebx+pflags], 4
        mov cx, word [byte ebx+facedir]
        cmp cx, byte 4
        je short .13
        jge short .11
        mov eax, 1
        jmp short .12
.11:
        mov eax, 0FFFFFFFFh
.12:
        mov edx, dword [byte ebx+facedir-2]
        sar edx, 10h
        add eax, edx
        and eax, byte 7
        mov word [byte ebx+facedir], ax
.13:
        mov word [byte ebx+Yvel], 0
        mov word [byte ebx+Xvel], 0F800h
        cmp word [regd0], byte 10h
        jg near .x
        mov word [byte ebx+Xvel], 0
        cmp word [byte ebx+facedir], byte 4
        jne near .x
        mov word [byte ebx+Xvel], 0F800h
        mov word [byte ebx+facedir], 2
        cmp word [byte ebx+position], byte 0
        jne short .14
        mov eax, 0D2Dh
        jmp short .15
.14:
        mov eax, 7BFh
.15:
        movsx edx, ax
        mov eax, ebx
        call SetSPA
        or byte [byte ebx+pflags], 20h
        mov word [byte ebx+temp1], 64h
        cmp word [gsp], byte 4
        jge short .x
        test byte [gmode], 40h
        jne short .x
        mov edx, dword [byte ebx+044h]
        sar edx, 18h
        test byte [byte ebx+pflags], 40h
        setne al
        xor ah, ah
        cwde
        call RemoveFromLines
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.16:
        test byte [byte ebx+pflags], 4
        jne short .x
        mov ax, word [byte ebx+temp3]
        mov word [regd0], ax
        mov ax, word [byte ebx+temp4]
        mov word [regd1], ax
        xor edx, edx
        mov eax, ebx
        call skateto
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.17:
        and byte [byte ebx+pflags2], 0EFh
        mov word [byte ebx+012h], 0FFFFh
        mov edx, 29h
        mov eax, ebx
        call assreplace
.x:
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; asspenalty                                            4ADAB  94G logic94.asm
; Asstab slot 12; field alignment 97% of 30 known-field accesses; content
; rank 1/34 vs other slot routines; 1 known Genesis callees present, 0
; missing, 0 extra
;-----------------------------------------------------------------------------
; C: src/engine/logic/assrefwhistle.c (asspenalty)
%ifdef CBUILD
%include "c/engine/logic/assrefwhistle.asspenalty.inc"
%else
asspenalty:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ebx, eax
        test byte [byte eax+pflags], 20h
        jne near ass_popx
        mov dl, byte [byte ebx+pflags]
        test dl, 2
        je near .7
        mov dh, dl
        and dh, 0FDh
        mov byte [byte ebx+pflags], dh
        or byte [byte ebx+pflags2], 4
        test byte [byte ebx+pflags], 8
        je short .3
        mov ax, word [byte ebx+SCnum]
        cmp ax, word [c1playernum]
        jne short .1
        xor esi, esi
        mov word [regd4], si
        jmp short .2
.1:
        mov word [regd4], 2
.2:
        mov edx, dword [regd4-2]
        sar edx, 10h
        mov eax, ebx
        call changeplayer
.3:
        mov word [byte ebx+temp2], 8
        test byte [byte ebx+pflags], 40h
        jne short .4
        movsx ax, byte [PBnum]
        mov word [regd1], ax
        mov dword [regd0], 0FFFFFFF5h
        jmp short .5
.4:
        movsx ax, byte [PBnum+1]
        mov word [regd1], ax
        mov dword [regd0], 0Bh
.5:
        mov di, word [regd1]
        and edi, byte 0Fh
        mov word [regd1], di
        cmp di, byte 2
        jle short .6
        mov dword [regd1], 2
.6:
        mov dx, word [regd1]
        add edx, byte 3
        mov word [regd1], dx
        mov eax, edx
        mov cx, word [regd0]
        imul eax, ecx
        mov word [byte ebx+temp4], ax
        mov word [byte ebx+temp3], 0A0h
        mov word [byte ebx+temp1], 0
        or byte [byte ebx+pflags2], 20h
        mov word [byte ebx+Wallcos], 0
        mov word [byte ebx+Wallsin], 0
.7:
        mov ax, word [byte ebx+Ypos+2]
        mov si, word [byte ebx+temp4]
        sub eax, esi
        mov word [regd0], ax
        test ax, ax
        jge short .8
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .9
.8:
        mov eax, dword [regd0-2]
        sar eax, 10h
.9:
        cmp eax, byte 0Ch
        jg near .14
        mov ax, word [byte ebx+Xpos+2]
        mov dx, word [byte ebx+temp3]
        sub eax, edx
        mov word [regd0], ax
        mov eax, dword [regd0-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFE8h
        jl near .14
        mov cx, word [byte ebx+temp1]
        dec ecx
        mov word [byte ebx+temp1], cx
        test cx, cx
        jge near ass_popx
        mov edi, ecx
        add edi, byte 8
        mov word [byte ebx+temp1], di
        or byte [byte ebx+pflags], 4
        mov edx, 289h
        mov eax, ebx
        call SetSPA
        mov eax, 4
        mov word [regd2], ax
        mov dx, word [byte ebx+facedir]
        cmp dx, ax
        je short .12
        sub eax, edx
        xor ah, ah
        and al, 7
        mov word [regd2], ax
        cmp ax, 5
        jge short .10
        mov eax, 1
        jmp short .11
.10:
        mov eax, 0FFFFFFFFh
.11:
        mov edx, dword [byte ebx+facedir-2]
        sar edx, 10h
        add eax, edx
        and eax, byte 7
        mov word [byte ebx+facedir], ax
.12:
        mov word [byte ebx+Yvel], 0
        mov word [byte ebx+Xvel], 1000h
        mov eax, dword [regd0-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFF8h
        jl near ass_popx
        mov word [byte ebx+Xvel], 0
        mov ax, word [regd2]
        cmp ax, word [byte ebx+facedir]
        jne near ass_popx
        or byte [byte ebx+pflags], 20h
        mov word [byte ebx+facedir], 2
        mov edx, 7A1h
        mov eax, ebx
        call SetSPA
        and byte [byte ebx+pflags2], 0EFh
        mov eax, dword [byte ebx+06Ch]
        mov dx, word [byte eax+tmap]
        cmp dx, byte 4
        jle short .13
        mov ecx, edx
        dec ecx
        mov word [byte eax+tmap], cx
.13:
        mov edx, 0Dh
        mov eax, ebx
        call assreplace
        jmp near ass_popx
.14:
        mov ax, word [byte ebx+temp3]
        mov word [regd0], ax
        mov ax, word [byte ebx+temp4]
        mov word [regd1], ax
        jmp near asswingd_skate0
%endif ; C
;-----------------------------------------------------------------------------
; assdopen                                              4AFFB  94G logic94.asm
; asstab 0Dh (player goes to the penalty box). Bumps PBnum (home) or PBnum+1 (away).
;-----------------------------------------------------------------------------
; C: src/engine/logic/assdopen.c
%ifdef CBUILD
%include "c/engine/logic/assdopen.inc"
%else
assdopen:
        push dword 8
        call __CHK
        push edx
        mov dl, byte [byte eax+044h]
        test dl, 20h
        jne short .x
        test dl, 40h
        jne short .1
        inc byte [PBnum]
        jmp short .2
.1:
        inc byte [PBnum+1]
.2:
        mov byte [byte eax+01Bh], 0FFh
        mov word [byte eax+012h], 0FFFFh
.x:
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assepen                                               4B02D  94G logic94.asm
; Asstab slot 10; field alignment 84% of 19 known-field accesses; content
; rank 1/34 vs other slot routines; 1 known Genesis callees present, 0
; missing, 0 extra
;-----------------------------------------------------------------------------
; C: src/engine/logic/assepen.c
%ifdef CBUILD
%include "c/engine/logic/assepen.inc"
%else
assepen:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov dl, byte [byte eax+pflags]
        test dl, 20h
        jne near .x
        test dl, 2
        je near .7
        mov cl, dl
        or cl, 4
        mov ch, cl
        and ch, 0EDh
        mov byte [byte eax+pflags], ch
        or byte [byte eax+pflags2], 4
        test byte [byte eax+pflags], 40h
        jne short .3
        mov cl, byte [PBnum]
        dec cl
        mov byte [PBnum], cl
        cmp cl, 2
        jle short .1
        mov ebx, 2
        jmp short .2
.1:
        mov ebx, dword [PBnum-3]
        sar ebx, 18h
.2:
        mov edx, ebx
        shl edx, 2
        sub edx, ebx
        shl edx, 2
        sub edx, ebx
        mov ebx, 0FFFFFFDFh
        sub ebx, edx
        mov word [byte eax+Ypos+2], bx
        jmp short .6
.3:
        mov bl, byte [PBnum+1]
        dec bl
        mov byte [PBnum+1], bl
        cmp bl, 2
        jle short .4
        mov ebx, 2
        jmp short .5
.4:
        mov ebx, dword [PerTimeTotal]
        sar ebx, 18h
.5:
        mov edx, ebx
        shl edx, 2
        sub edx, ebx
        shl edx, 2
        sub edx, ebx
        add edx, byte 21h
        mov word [byte eax+Ypos+2], dx
.6:
        mov word [byte eax+Xvel], 0
        mov word [byte eax+Yvel], 0
        mov word [byte eax+Xpos+2], 9Eh
        mov word [byte eax+facedir], 2
        or byte [byte eax+pflags], 20h
        mov edx, 7BFh
        call SetSPA
        call SprSort
        pop edx
        pop ecx
        pop ebx
        ret
.7:
        mov word [byte eax+facedir], 4
        mov byte [byte eax+newpnum], 0FFh
        mov byte [byte eax+newpos], 0FFh
        and byte [byte eax+pflags], 0F3h
        and byte [byte eax+pflags2], 0DBh
        mov word [byte eax+Xvel], 0F000h
        call assexit
.x:
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assbench                                              4B12C  94G logic94.asm
; Asstab slot 11; field alignment 85% of 41 known-field accesses; content
; rank 1/34 vs other slot routines; 1 known Genesis callees present, 0
; missing, 0 extra
;-----------------------------------------------------------------------------
; C: src/engine/logic/assbench.c
%ifdef CBUILD
%include "c/engine/logic/assbench.inc"
%else
assbench:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov ebx, eax
        test byte [byte eax+pflags], 20h
        jne near .x
        cmp word [byte ebx+temp1], byte 64h
        je near .23
        mov eax, ebx
        call check4bench
        test ax, ax
        jne near .x
        test byte [byte ebx+pflags2], 10h
        je short .2
.1:
        mov eax, ebx
        call donothing
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.2:
        test byte [gmode2], 1
        jne short assbench.1
        test byte [gmode], 1
        je short .3
        cmp word [byte ebx+position], byte 0
        jne short .3
        mov eax, dword [byte ebx+06Ch]
        mov eax, dword [byte eax+tmgoalie-2]
        sar eax, 10h
        and eax, 0FFF0h
        cmp eax, 0FF00h
        jne short .3
        test byte [byte ebx+pflags], 40h
        setne al
        and eax, 0FFh
        call ChkPullGoalieLate
        test eax, eax
        jne short .3
        mov byte [byte ebx+newpos], 0FFh
        mov al, byte [byte ebx+newpos]
        mov byte [byte ebx+newpnum], al
        mov edx, 27h
        mov eax, ebx
        call assreplace
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.3:
        mov cl, byte [byte ebx+pflags]
        test cl, 2
        je short .6
        mov ch, cl
        and ch, 0FDh
        mov byte [byte ebx+pflags], ch
        mov word [byte ebx+temp2], 8
        test byte [byte ebx+pflags], 40h
        jne short .4
        mov eax, 0FFFFFFCEh
        jmp short .5
.4:
        mov eax, 41h
.5:
        mov word [byte ebx+temp4], ax
        mov word [byte ebx+temp3], 0FF58h
        mov word [byte ebx+temp1], 0
.6:
        mov al, byte [byte ebx+newpnum]
        cmp al, byte [byte ebx+047h]
        jne short .8
        and byte [byte ebx+pflags2], 0FBh
        cmp byte [byte ebx+newpnum], 19h
        setl al
        mov edx, eax
        and edx, 0FFh
        mov cl, byte [byte ebx+newpos]
        test cl, cl
        sete al
        and eax, 0FFh
        xor eax, edx
        je short .7
        movsx ax, cl
        mov word [byte ebx+position], ax
.7:
        mov eax, ebx
        call Setplass
        mov byte [byte ebx+newpnum], 0FFh
        mov byte [byte ebx+newpos], 0FFh
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.8:
        cmp word [byte ebx+position], byte 0
        jne short .9
        or byte [byte ebx+048h], 3
.9:
        mov dx, word [byte ebx+temp1]
        dec edx
        mov word [byte ebx+temp1], dx
        test dx, dx
        jge near .19
        mov esi, edx
        add esi, byte 8
        mov word [byte ebx+temp1], si
        mov ax, word [byte ebx+Ypos+2]
        sub ax, word [byte ebx+temp4]
        mov dx, word [byte ebx+Xpos+2]
        mov cx, word [byte ebx+temp3]
        sub edx, ecx
        mov word [regd0], dx
        test ax, ax
        jge short .10
        cwde
        neg eax
        jmp short .11
.10:
        cwde
.11:
        cmp eax, byte 28h
        jg near .19
        cmp word [regd0], byte 20h
        jg near .19
        cmp word [byte ebx+position], byte 0
        jne short .12
        mov eax, 1
        jmp short .13
.12:
        mov eax, 289h
.13:
        mov word [regd1], ax
        mov edx, dword [regd1-2]
        sar edx, 10h
        mov eax, ebx
        call SetSPA
        or byte [byte ebx+pflags], 4
        mov dx, word [byte ebx+facedir]
        cmp dx, byte 4
        je short .16
        jge short .14
        mov eax, 1
        jmp short .15
.14:
        mov eax, 0FFFFFFFFh
.15:
        mov edx, dword [byte ebx+facedir-2]
        sar edx, 10h
        add eax, edx
        and eax, byte 7
        mov word [byte ebx+facedir], ax
.16:
        mov word [byte ebx+Yvel], 0
        mov word [byte ebx+Xvel], 0F800h
        cmp word [regd0], byte 10h
        jg near .x
        mov word [byte ebx+Xvel], 0
        cmp word [byte ebx+facedir], byte 4
        jne near .x
        mov word [byte ebx+Xvel], 0F800h
        mov word [byte ebx+facedir], 2
        cmp word [byte ebx+position], byte 0
        jne short .17
        mov eax, 0D2Dh
        jmp short .18
.17:
        mov eax, 7BFh
.18:
        movsx edx, ax
        mov eax, ebx
        call SetSPA
        or byte [byte ebx+pflags], 20h
        mov word [byte ebx+temp1], 64h
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.19:
        test byte [byte ebx+pflags], 4
        jne near .x
        mov ax, word [byte ebx+temp3]
        mov word [regd0], ax
        mov ax, word [byte ebx+temp4]
        mov word [regd1], ax
        test byte [gmode], 1
        jne short .20
        cmp word [byte ebx+position], byte 0
        jne short .21
.20:
        xor edx, edx
        jmp short .22
.21:
        mov edx, EvadePC
.22:
        mov eax, ebx
        call skateto
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.23:
        mov word [byte ebx+012h], 0FFFFh
        mov ecx, dword [byte ebx+06Ch]
        mov eax, dword [byte ebx+044h]
        sar eax, 18h
        add eax, eax
        add eax, ecx
        cmp word [byte eax+07Eh], byte 0
        jg short .24
        mov edx, dword [byte eax+07Ch]
        sar edx, 10h
        cmp edx, byte 0FFFFFFFEh
        jl short .24
        mov word [byte eax+07Eh], 0FFFEh
        mov edx, dword [byte ebx+044h]
        sar edx, 18h
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 3
        sub eax, edx
        mov edx, eax
        mov eax, dword [dword ecx+tmroster]
        mov byte [edx+eax], 3
.24:
        cmp byte [byte ebx+newpnum], 19h
        setl al
        mov edx, eax
        and edx, 0FFh
        mov cl, byte [byte ebx+newpos]
        test cl, cl
        sete al
        and eax, 0FFh
        xor eax, edx
        je short .25
        movsx ax, cl
        mov word [byte ebx+position], ax
.25:
        mov eax, ebx
        call Setplass
        test byte [gmode], 1
        je short .26
        mov word [byte ebx+temp5], 0
        mov edx, 27h
        mov eax, ebx
        call assinsert
.26:
        movsx ax, byte [byte ebx+newpnum]
        mov word [regd3], ax
        mov byte [byte ebx+newpnum], 0FFh
        mov byte [byte ebx+newpos], 0FFh
        mov edx, dword [regd3-2]
        sar edx, 10h
        mov eax, ebx
        call setplayer
.x:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; GoalieToPuckVec                                 4B467  95 PC, low confidence
; Regd0/regd1 = puck - goalie; regd1 forced to +-1 when goalie and puck are
; both behind the same goal line (E8h); assgoalie helper
;-----------------------------------------------------------------------------
; C: src/engine/logic/GoalieToPuckVec.c
%ifdef CBUILD
%include "c/engine/logic/GoalieToPuckVec.inc"
%else
GoalieToPuckVec:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov ebx, dword [byte eax+04h]
        sar ebx, 10h
        mov edx, dword [puckx]
        mov dx, word [edx]
        mov cx, word [byte eax+02h]
        sub edx, ecx
        mov word [regd0], dx
        mov edx, dword [pucky]
        mov cx, word [edx]
        mov si, word [byte eax+06h]
        mov eax, ecx
        sub eax, esi
        mov word [regd1], ax
        test ebx, ebx
        jge short .1
        cmp ebx, 0FFFFFF18h
        jl short .x
        movsx eax, word [edx]
        cmp eax, 0FFFFFF18h
        jge short .x
        mov word [regd1], 1
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        cmp ebx, 0E8h
        jge short .x
        cmp word [edx], 0E8h
        jl short .x
        mov word [regd1], 0FFFFh
.x:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; AdjustFacingDirection              4B4E9  94G logic94.asm, medium confidence
; Same step as the 93G/94G AdjustFacingDirection (checks): d = facedir - dir,
; step = ((-d)&4)/2-1, with the pfgoal (pflags bit 7) facing-range special
; cases; the PC adds a 2-tick delay counter at +4Ch
;-----------------------------------------------------------------------------
; C: src/engine/logic/AdjustFacingDirection.c
%ifdef CBUILD
%include "c/engine/logic/AdjustFacingDirection.inc"
%else
AdjustFacingDirection:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        mov bx, word [byte eax+036h]
        mov ecx, edx
        cmp word [byte eax+04Ch], byte 0
        jne near .7
        movsx esi, bx
        sub esi, edx
        mov edx, esi
        je near .7
        and edx, byte 4
        sar edx, 1
        dec edx
        test byte [byte eax+044h], 80h
        je short .3
        cmp bx, byte 1
        jl short .1
        cmp bx, byte 3
        jg short .1
        cmp cx, byte 5
        jl short .1
        cmp cx, byte 7
        jle near .5
.1:
        cmp bx, byte 5
        jl short .6
        cmp bx, byte 7
        jg short .6
        cmp cx, byte 1
        jl short .6
        cmp cx, byte 3
        jg short .6
.2:
        mov edx, 1
        jmp short .6
.3:
        cmp bx, byte 1
        jl short .4
        cmp bx, byte 3
        jg short .4
        cmp cx, byte 5
        jl short .4
        cmp cx, byte 7
        jle short AdjustFacingDirection.2
.4:
        cmp bx, byte 5
        jl short .6
        cmp bx, byte 7
        jg short .6
        cmp cx, byte 1
        jl short .6
        cmp cx, byte 3
        jg short .6
.5:
        mov edx, 0FFFFFFFFh
.6:
        add dx, word [byte eax+036h]
        xor dh, dh
        and dl, 7
        mov word [byte eax+036h], dx
        mov word [byte eax+04Ch], 2
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.7:
        mov di, word [byte eax+04Ch]
        dec edi
        mov word [byte eax+04Ch], di
        test di, di
        jge short .x
        mov word [byte eax+04Ch], 0
.x:
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assgoalietopuck                                       4B5C2  94G logic94.asm
; Asstab slot 0Fh = 93G assgoalietopuck (goalie skates out to a loose puck):
; check4bench, skatetopuck, assexit
;-----------------------------------------------------------------------------
; C: src/engine/logic/assgoalietopuck.c
%ifdef CBUILD
%include "c/engine/logic/assgoalietopuck.inc"
%else
assgoalietopuck:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push edi
        mov edx, eax
        mov bx, word [byte eax+04Ah]
        test bx, bx
        jle short .1
        mov ecx, ebx
        dec ecx
        mov word [byte eax+04Ah], cx
.1:
        or byte [byte edx+048h], 6
        mov ebx, dword [edx]
        sar ebx, 10h
        mov eax, dword [byte edx+Ypos]
        sar eax, 10h
        test eax, eax
        jge short .2
        mov ecx, eax
        neg ecx
        jmp short .3
.2:
        mov ecx, eax
.3:
        mov eax, ecx
        cmp ebx, byte 0FFFFFFD8h
        jl short .4
        cmp ebx, byte 29h
        jge short .4
        cmp ecx, 0C5h
        jl short .4
        cmp ecx, 0E4h
        jge short .4
        and byte [byte edx+048h], 0FBh
.4:
        cmp ebx, byte 0FFFFFFD0h
        jl short .5
        cmp ebx, byte 31h
        jge short .5
        cmp eax, 0C5h
        jl short .5
        and byte [byte edx+048h], 0FDh
.5:
        test byte [byte edx+pflags], 8
        jne short .6
        test byte [gmode], 1
        je short .7
.6:
        mov eax, edx
        call assexit
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.7:
        mov eax, edx
        call check4bench
        test ax, ax
        jne near .x
        mov bl, byte [byte edx+pflags]
        test bl, 2
        je short .8
        mov bh, bl
        and bh, 0FDh
        mov byte [byte edx+pflags], bh
        mov word [byte edx+temp1], ax
.8:
        mov cl, byte [byte edx+027h]
        dec cl
        mov byte [byte edx+027h], cl
        test cl, cl
        jge short .12
        xor eax, eax
        mov al, byte [byte edx+05Ah]
        sar eax, 2
        mov byte [byte edx+027h], al
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jge short assgoalietopuck.6
        test byte [byte edx+pflags], 80h
        setne al
        mov ebx, eax
        and ebx, 0FFh
        mov eax, dword [puckvy]
        cmp word [eax], byte 0
        setl al
        and eax, 0FFh
        xor eax, ebx
        je short .11
        mov eax, dword [puckvy]
        mov di, word [eax]
        test di, di
        jge short .9
        movsx eax, di
        neg eax
        jmp short .10
.9:
        movsx eax, di
.10:
        cmp eax, 800h
        jg near assgoalietopuck.6
.11:
        mov eax, dword [byte edx+optmptr]
        cmp dword [byte eax+03Eh], 96h
        jl near assgoalietopuck.6
.12:
        mov eax, edx
        call skatetopuck
.x:
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ClampYPosition                                        4B6F4  94G logic94.asm
; 93G ClampYPosition: regd0 = 0 if the goalie has the puck, regd1 clamped to
; +-E3h (93G +-$103), minus regd3; assgoalie helper
;-----------------------------------------------------------------------------
; C: src/engine/logic/ClampYPosition.c
%ifdef CBUILD
%include "c/engine/logic/ClampYPosition.inc"
%else
ClampYPosition:
        push dword 0Ch
        call __CHK
        push ecx
        push edx
        cmp word [byte eax+06h], byte 0
        jge short .1
        mov edx, dword [byte eax+04h]
        sar edx, 10h
        neg edx
        jmp short .2
.1:
        mov edx, dword [byte eax+04h]
        sar edx, 10h
.2:
        cmp edx, 0E8h
        jge short .5
        mov edx, dword [puckc]
        movsx dx, byte [edx]
        cmp dx, word [byte eax+06Ah]
        jne short .3
        xor ecx, ecx
        mov word [regd0], cx
.3:
        cmp word [regd1], 0E3h
        jle short .4
        mov word [regd1], 0E3h
.4:
        mov eax, dword [regd1-2]
        sar eax, 10h
        cmp eax, 0FFFFFF1Dh
        jge short .5
        mov word [regd1], 0FF1Dh
.5:
        mov ax, word [regd3]
        sub word [regd1], ax
        pop edx
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assgoalie                          4B774  94G logic94.asm, medium confidence
; Asstab slot 14; field alignment 68% of 59 known-field accesses; content
; rank 1/34 vs other slot routines; 2 known Genesis callees present, 0
; missing, 1 extra
;-----------------------------------------------------------------------------
assgoalie:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov esi, eax
        mov ebp, 1
        mov dx, word [byte eax+04Ah]
        test dx, dx
        jle short .1
        mov ebx, edx
        dec ebx
        mov word [byte eax+04Ah], bx
.1:
        mov eax, dword [puckc]
        movsx ax, byte [eax]
        cmp ax, word [byte esi+SCnum]
        je short .2
        mov byte [byte esi+063h], 0
.2:
        or byte [byte esi+048h], 6
        mov edx, dword [esi]
        sar edx, 10h
        mov ecx, dword [byte esi+Ypos]
        sar ecx, 10h
        test ecx, ecx
        jge short .3
        mov eax, ecx
        neg eax
        jmp short .4
.3:
        mov eax, ecx
.4:
        mov ecx, eax
        cmp edx, byte 0FFFFFFD8h
        jl short .5
        cmp edx, byte 29h
        jge short .5
        cmp eax, 0C5h
        jl short .5
        cmp eax, 0E4h
        jge short .5
        and byte [byte esi+048h], 0FBh
.5:
        cmp edx, byte 0FFFFFFD0h
        jl short .6
        cmp edx, byte 31h
        jge short .6
        cmp ecx, 0C5h
        jl short .6
        and byte [byte esi+048h], 0FDh
.6:
        mov eax, esi
        call check4bench
        test ax, ax
        jne near assgoalie_popebp
        mov al, byte [byte esi+pflags]
        test al, 2
        je short .7
        mov ah, al
        and ah, 0FDh
        mov byte [byte esi+pflags], ah
        mov word [byte esi+temp1], 0
        mov word [byte esi+temp2], 8
        mov byte [byte esi+02Dh], 0FFh
.7:
        cmp ecx, 0E4h
        jle short .13
        xor eax, eax
        mov word [regd2], ax
        test edx, edx
        jge short .8
        mov eax, edx
        neg eax
        jmp short .9
.8:
        mov eax, edx
.9:
        cmp eax, byte 30h
        jg short .12
.10:
        cmp word [byte esi+Xpos+2], byte 0
        jge short .11
        mov eax, 0FFFFFF60h
        jmp near .141
.11:
        mov eax, 0A0h
        jmp near .141
.12:
        mov word [regd0], dx
        jmp near .142
.13:
        test edx, edx
        jge short .14
        mov eax, edx
        neg eax
        jmp short .15
.14:
        mov eax, edx
.15:
        cmp eax, byte 34h
        jg short .16
        cmp ecx, 0EFh
        jge short .16
        cmp ecx, 0B3h
        jge short .21
.16:
        test edx, edx
        jl short .17
        mov eax, 4
        jmp short .18
.17:
        mov eax, 0FFFFFFFCh
.18:
        mov word [regd0], ax
        test byte [byte esi+pflags], 80h
        je short .19
        mov eax, 0FFFFFF3Ch
        jmp short .20
.19:
        mov eax, 0C4h
.20:
        mov word [regd1], ax
        xor edx, edx
        mov eax, esi
        call skateto
        jmp near assgoalie_popebp
.21:
        test byte [byte esi+pflags2], 2
        jne short .24
        test byte [byte esi+pflags], 20h
        jne short .24
        mov eax, dword [puckc]
        movsx ax, byte [eax]
        cmp ax, word [byte esi+SCnum]
        jne short .22
        mov eax, 99h
        jmp short .23
.22:
        mov eax, 1
.23:
        movsx edx, ax
        mov eax, esi
        call SetSPA
.24:
        test byte [gmode], 1
        jne near assgoalie_popebp
        cmp word [byte esi+temp5], byte 0
        jl short .27
        mov eax, dword [puckc]
        movsx ax, byte [eax]
        cmp ax, word [byte esi+SCnum]
        jne short .26
        cmp ecx, 9Bh
        jge short .25
        mov word [byte esi+temp5], 0
.25:
        mov bx, word [byte esi+temp5]
        dec ebx
        mov word [byte esi+temp5], bx
        test bx, bx
        jge short .27
        mov edx, 4
        mov eax, esi
        call AddPenalty2
        jmp short .27
.26:
        mov word [byte esi+temp5], 0FFFFh
.27:
        test byte [byte esi+pflags2], 2
        jne near assgoalie_popebp
        mov di, word [byte esi+temp1]
        dec edi
        mov word [byte esi+temp1], di
        test di, di
        jl short .29
        movsx ax, byte [byte esi+028h]
        mov word [regd2], ax
        cmp ax, 7
        jle near .148
.28:
        mov eax, esi
        call stopna
        jmp near assgoalie_popebp
.29:
        xor edx, edx
        mov dl, byte [byte esi+05Ah]
        mov ebx, 3
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov word [byte esi+temp1], ax
        test byte [byte esi+pflags], 8
        jne near .41
        mov eax, dword [pucky]
        mov ax, word [eax]
        mov dx, word [byte esi+Ypos+2]
        xor eax, edx
        mov word [regd1], ax
        test ax, ax
        jge short .32
        xor ecx, ecx
        mov word [regd0], cx
        test byte [byte esi+pflags], 80h
        je short .30
        mov eax, 0FFFFFF2Ch
        jmp short .31
.30:
        mov eax, 0D4h
.31:
        mov word [regd2], ax
        jmp near .142
.32:
        dec word [byte esi+temp4]
        mov eax, dword [puckc]
        movsx ax, byte [eax]
        cmp ax, word [byte esi+SCnum]
        jne near .41
        cmp word [byte esi+temp5], byte 0
        jge short .33
        mov word [byte esi+temp5], 5Ah
.33:
        mov word [byte esi+temp4], 0FFFFh
        cmp word [byte esi+temp5], byte 5Ah
        jge near .39
        mov eax, 4
        call randomd0
        test ax, ax
        jne near .39
        cmp word [byte esi+SCnum], byte 6
        jge short .34
        mov eax, 6
        jmp short .35
.34:
        xor eax, eax
.35:
        shl eax, 7
        add eax, SortCords
        xor edx, edx
        jmp short .38
.36:
        test byte [byte eax+045h], 4
        jne short .37
        cmp word [byte eax+01Ah], byte 0
        jle short .37
        mov di, word [byte eax+04Eh]
        cmp di, byte 23h
        jge short .37
        cmp di, byte 14h
        jge short .37
        or byte [byte esi+pflags], 20h
        or byte [byte esi+pflags2], 2
        mov edx, 1135h
        mov eax, esi
        call SetSPA
        jmp near assgoalie_popebp
.37:
        inc edx
        add eax, 80h
.38:
        cmp dx, byte 6
        jl short assgoalie.36
        mov word [threat], 1
        mov eax, esi
        call chk4pass
        test ax, ax
        jne near assgoalie_popebp
.39:
        mov edi, puckcross
        mov word [regd3], 0E4h
        mov word [regd4], 0E8h
        test byte [byte esi+pflags], 80h
        je short .40
        mov word [regd3], 0FF1Ch
        mov word [regd4], 0FF18h
        add edi, byte 4
.40:
        cmp word [byte esi+Ypos+2], byte 0
        jge near .47
        mov eax, dword [byte esi+Ypos]
        sar eax, 10h
        neg eax
        jmp near .48
.41:
        mov eax, dword [puckx]
        mov ax, word [eax]
        mov dx, word [byte esi+Xpos+2]
        sub eax, edx
        mov word [regd0], ax
        mov eax, dword [pucky]
        mov dx, word [eax]
        mov bx, word [byte esi+Ypos+2]
        sub edx, ebx
        mov word [regd1], dx
        mov edx, dword [puckc]
        mov ch, byte [edx]
        test ch, ch
        jl near .44
        jl near assgoalie.39
        cmp word [byte esi+SCnum], byte 6
        setl al
        mov edx, eax
        and edx, 0FFh
        mov eax, dword [puckc]
        cmp byte [eax], 6
        setl al
        and eax, 0FFh
        xor eax, edx
        je near assgoalie.39
        cmp word [byte esi+04Ah], byte 0
        jne near assgoalie.39
        mov eax, 100h
        call randomd0
        cmp ax, 0Ah
        jge near assgoalie.39
        cmp word [byte esi+04Eh], byte 23h
        jge near assgoalie.39
        mov eax, dword [pucky]
        mov di, word [eax]
        test di, di
        jge short .42
        movsx eax, di
        neg eax
        jmp short .43
.42:
        movsx eax, di
.43:
        cmp eax, 0E9h
        jge near assgoalie.39
        mov edx, dword [regd1-2]
        sar edx, 10h
        mov eax, dword [regd0-2]
        sar eax, 10h
        call vtoa
        mov word [byte esi+facedir], ax
        or byte [byte esi+pflags], 20h
        or byte [byte esi+pflags2], 2
        mov edx, 1095h
        mov eax, esi
        call SetSPA
        mov word [byte esi+04Ah], 0F0h
        jmp near assgoalie_popebp
.44:
        cmp word [byte esi+temp4], byte 0
        jne near assgoalie.39
        cmp word [byte esi+04Eh], byte 2Dh
        jge near assgoalie.39
        mov dx, word [eax]
        test dx, dx
        jge short .45
        movsx eax, dx
        neg eax
        jmp short .46
.45:
        movsx eax, dx
.46:
        cmp eax, 0E9h
        jge near assgoalie.39
        mov eax, dword [byte esi+070h]
        cmp dword [byte eax+03Eh], byte 3Ch
        jge near assgoalie.39
        mov eax, 100h
        call randomd0
        cmp ax, 0Ah
        jge near assgoalie.39
        mov edx, dword [regd1-2]
        sar edx, 10h
        mov eax, dword [regd0-2]
        sar eax, 10h
        call vtoa
        mov word [byte esi+facedir], ax
        mov word [byte esi+03Eh], 8
        or byte [byte esi+pflags], 20h
        or byte [byte esi+pflags2], 2
        mov edx, 181h
        mov eax, esi
        call SetSPA
        mov word [byte esi+04Ah], 168h
        mov bx, word [crowdlevel]
        cmp bx, 4B0h
        jg near assgoalie_popebp
        mov ecx, ebx
        add ecx, 96h
        mov word [crowdlevel], cx
        cmp cx, 4B0h
        jle near assgoalie_popebp
        mov word [crowdlevel], 4B0h
        jmp near assgoalie_popebp
.47:
        mov eax, dword [byte esi+Ypos]
        sar eax, 10h
.48:
        cmp eax, 0E4h
        jle short .51
        xor edi, edi
        mov word [regd2], di
        mov word [regd0], di
        cmp word [byte esi+Xpos+2], byte 0
        jge short .49
        mov eax, dword [esi]
        sar eax, 10h
        neg eax
        jmp short .50
.49:
        mov eax, dword [esi]
        sar eax, 10h
.50:
        cmp eax, byte 30h
        jg near .142
        jmp near assgoalie.10
.51:
        mov eax, dword [puckx]
        mov ax, word [eax]
        mov word [regd0], ax
        mov eax, dword [pucky]
        mov ax, word [eax]
        mov word [regd1], ax
        mov eax, esi
        call ClampYPosition
        mov edx, dword [regd1-2]
        sar edx, 10h
        mov eax, dword [regd0-2]
        sar eax, 10h
        call vtoa
        mov word [regd0], ax
        mov dx, word [byte esi+facedir]
        mov word [regd1], dx
        sub ax, dx
        mov word [regd0], ax
        je near .56
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        and eax, byte 4
        sar eax, 1
        dec eax
        mov word [regd0], ax
        mov ecx, dword [regd1-2]
        sar ecx, 10h
        mov edx, 1
        shl edx, cl
        mov ax, word [regd1]
        add ax, word [regd0]
        test dl, 42h
        jne short .52
        mov word [regd1], ax
        jmp short .55
.52:
        mov word [regd1], ax
        test byte [byte esi+pflags], 80h
        jne short .53
        mov eax, 83h
        jmp short .54
.53:
        mov eax, 38h
.54:
        mov ecx, dword [regd1-2]
        sar ecx, 10h
        mov edx, 1
        shl edx, cl
        test eax, edx
        je short .55
        mov cx, word [regd0]
        neg ecx
        mov word [regd0], cx
        mov eax, ecx
        add eax, ecx
        add word [regd1], ax
.55:
        mov bx, word [regd1]
        xor bh, bh
        and bl, 7
        mov word [regd1], bx
        mov word [byte esi+facedir], bx
.56:
        mov word [regd0], 0E0h
        mov eax, dword [pucky]
        mov dx, word [eax]
        test dx, dx
        jge short .57
        movsx eax, dx
        neg eax
        jmp short .58
.57:
        movsx eax, dx
.58:
        cmp eax, 0BBh
        jle short .59
        sub word [regd0], byte 40h
.59:
        mov ax, word [regd0]
        mov word [regd1], ax
        mov eax, dword [regd0-2]
        sar eax, 10h
        push eax
        mov eax, dword [puckvx]
        movsx eax, word [eax]
        push eax
        call imul32
        add esp, byte 8
        mov edx, eax
        sar edx, 10h
        mov eax, dword [puckx]
        movsx eax, word [eax]
        add eax, edx
        mov word [regd0], ax
        mov eax, dword [regd1-2]
        sar eax, 10h
        push eax
        mov eax, dword [puckvy]
        movsx eax, word [eax]
        push eax
        call imul32
        add esp, byte 8
        mov edx, eax
        sar edx, 10h
        mov eax, dword [pucky]
        movsx eax, word [eax]
        add eax, edx
        mov word [regd1], ax
        mov eax, esi
        call ClampYPosition
        mov eax, dword [regd1-2]
        sar eax, 10h
        push eax
        mov eax, dword [regd0-2]
        sar eax, 10h
        push eax
        call vecdist
        add esp, byte 8
        mov edx, eax
        cmp eax, byte 1Eh
        jl near .64
        inc edx
        mov word [regd2], dx
        mov eax, dword [pucky]
        mov cx, word [eax]
        test cx, cx
        jge short .60
        movsx eax, cx
        neg eax
        jmp short .61
.60:
        movsx eax, cx
.61:
        cmp eax, byte 74h
        jge short .62
        call ShotLaneOpen
        test eax, eax
        je short .62
        mov word [regd4], 14h
        test byte [sflags], 8
        je short .63
        mov word [regd4], 1Ch
        jmp short .63
.62:
        mov word [regd4], 12h
        test byte [sflags], 8
        je short .63
        mov word [regd4], 1Ah
.63:
        mov eax, dword [regd1-2]
        sar eax, 10h
        mov edx, dword [regd4-2]
        sar edx, 10h
        imul edx, eax
        mov ebx, dword [regd2-2]
        sar ebx, 10h
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov word [regd1], ax
        mov eax, dword [regd0-2]
        sar eax, 10h
        add word [regd4], byte 8
        mov edx, dword [regd4-2]
        sar edx, 10h
        imul edx, eax
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov word [regd0], ax
.64:
        mov ax, word [regd3]
        mov bx, word [regd1]
        add ebx, eax
        mov word [regd1], bx
        mov word [regd2], bx
        mov ecx, dword [puckvy]
        movsx ecx, word [ecx]
        sar ecx, 9
        mov eax, dword [pucky]
        movsx edx, word [eax]
        add ecx, edx
        mov ebx, dword [puckc]
        cmp byte [ebx], 0
        jge near .72
        cmp word [eax], byte 0
        jge short .65
        neg edx
.65:
        cmp edx, 0E8h
        jge short .72
        cmp word [byte esi+Ypos+2], byte 0
        jge short .66
        mov eax, dword [byte esi+Ypos]
        sar eax, 10h
        neg eax
        jmp short .67
.66:
        mov eax, dword [byte esi+Ypos]
        sar eax, 10h
.67:
        cmp eax, byte 74h
        jle short .72
        cmp word [byte esi+04Eh], byte 1Eh
        jge short .72
        cmp word [byte esi+Ypos+2], byte 0
        jge short .68
        mov eax, dword [byte esi+Ypos]
        sar eax, 10h
        neg eax
        jmp short .69
.68:
        mov eax, dword [byte esi+Ypos]
        sar eax, 10h
.69:
        test ecx, ecx
        jge short .70
        mov edx, ecx
        neg edx
        jmp short .71
.70:
        mov edx, ecx
.71:
        cmp edx, eax
        jle short .72
        xor ebp, ebp
.72:
        test ebp, ebp
        je short .73
        cmp word [byte edi+02h], byte 23h
        jae near .142
.73:
        movsx edx, word [edi]
        test ebp, ebp
        je near .84
        test edx, edx
        jge short .74
        mov eax, edx
        neg eax
        jmp short .75
.74:
        mov eax, edx
.75:
        cmp eax, byte 19h
        jl near .84
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jge near .142
        test byte [iflags], 4
        jne near .142
        mov eax, dword [puckx]
        mov dx, word [eax]
        test dx, dx
        jge short .76
        movsx eax, dx
        neg eax
        jmp short .77
.76:
        movsx eax, dx
.77:
        cmp eax, byte 44h
        jl near .142
        mov eax, dword [puckvy]
        mov bx, word [eax]
        test bx, bx
        jge short .78
        movsx eax, bx
        neg eax
        jmp short .79
.78:
        movsx eax, bx
.79:
        cmp eax, 3800h
        jl near .142
        mov eax, dword [pucky]
        mov cx, word [eax]
        test cx, cx
        jge short .80
        movsx eax, cx
        neg eax
        jmp short .81
.80:
        movsx eax, cx
.81:
        cmp eax, 98h
        jl near .142
        test byte [byte esi+pflags], 80h
        je short .82
        mov eax, dword [puckvy]
        movsx eax, word [eax]
        neg eax
        jmp short .83
.82:
        mov eax, dword [puckvy]
        movsx eax, word [eax]
.83:
        cmp eax, 0FFFFFE70h
        jl near .142
        mov eax, dword [byte esi+06Ch]
        cmp dword [byte eax+03Eh], 132h
        jl near .142
        mov eax, dword [byte esi+070h]
        cmp dword [byte eax+03Eh], 132h
        jl near .142
        mov edx, 0Fh
        mov eax, esi
        call assinsert
        jmp near assgoalie_popebp
.84:
        mov eax, dword [esi]
        sar eax, 10h
        sub edx, eax
        test edx, edx
        jge short .85
        neg edx
.85:
        sub edx, byte 8
        cmp edx, byte 10h
        jle short .86
        mov edx, 10h
.86:
        test edx, edx
        jge short .87
        xor edx, edx
.87:
        sar edx, 2
        cmp word [byte esi+Ypos+2], byte 0
        jge short .88
        mov eax, dword [byte esi+Ypos]
        sar eax, 10h
        neg eax
        jmp short .89
.88:
        mov eax, dword [byte esi+Ypos]
        sar eax, 10h
.89:
        test ecx, ecx
        jge short .90
        neg ecx
.90:
        cmp ecx, eax
        jle short .91
        add edx, byte 4
.91:
        test ebp, ebp
        je near .101
        cmp word [byte esi+04Eh], byte 19h
        jg short .94
        mov eax, dword [pucky]
        mov bx, word [eax]
        test bx, bx
        jge short .92
        movsx eax, bx
        neg eax
        jmp short .93
.92:
        movsx eax, bx
.93:
        cmp eax, 0E8h
        jle near .101
.94:
        xor eax, eax
        mov ax, word [byte edi+02h]
        add edx, byte 0Ch
        cmp eax, edx
        jge short .97
        mov eax, dword [pucky]
        mov cx, word [eax]
        test cx, cx
        jge short .95
        movsx eax, cx
        neg eax
        jmp short .96
.95:
        movsx eax, cx
.96:
        cmp eax, 0E9h
        jle short .101
.97:
        mov ax, word [edi]
        mov word [regd0], ax
        mov eax, dword [pucky]
        mov cx, word [eax]
        test cx, cx
        jge short .98
        movsx eax, cx
        neg eax
        jmp short .99
.98:
        movsx eax, cx
.99:
        cmp eax, 0DCh
        jle near .142
        mov eax, dword [puckx]
        cmp word [eax], byte 0
        jle short .100
        mov eax, 18h
        jmp near .141
.100:
        mov eax, 0FFFFFFE8h
        jmp near .141
.101:
        mov eax, dword [puckc]
        movsx ax, byte [eax]
        cmp ax, word [byte esi+SCnum]
        je near .142
        mov eax, dword [puckx]
        mov bx, word [eax]
        test bx, bx
        jge short .102
        movsx eax, bx
        neg eax
        jmp short .103
.102:
        movsx eax, bx
.103:
        cmp eax, byte 64h
        jge near .142
        mov eax, dword [puckz]
        cmp word [eax], byte 14h
        jge near .142
        sar word [byte esi+Xvel], 1
        sar word [byte esi+Yvel], 1
        test byte [byte esi+048h], 2
        jne short .105
        mov edx, dword [puckvx]
        movsx edx, word [edx]
        sar edx, 0Ah
        mov eax, dword [puckx]
        movsx eax, word [eax]
        add edx, eax
        mov eax, dword [esi]
        sar eax, 10h
        sub edx, eax
        mov word [regd0], dx
        mov eax, dword [puckvy]
        movsx edx, word [eax]
        sar edx, 0Ah
        mov eax, dword [pucky]
        movsx eax, word [eax]
        add edx, eax
        mov eax, dword [byte esi+Ypos]
        sar eax, 10h
        sub edx, eax
        mov word [regd1], dx
        mov edx, dword [regd1-2]
        sar edx, 10h
        mov eax, dword [regd0-2]
        sar eax, 10h
        call vtoa
        cwde
        cmp eax, byte 8
        jne short .104
        xor eax, eax
        jmp short .106
.104:
        sub ax, word [byte esi+facedir]
        xor ah, ah
        and al, 7
        jmp short .106
.105:
        movsx ax, byte [byte esi+052h]
        sub ax, word [byte esi+facedir]
        xor ah, ah
        and al, 7
.106:
        mov word [regd3], ax
        cmp word [regd3], byte 4
        jne short .111
        mov eax, dword [puckvy]
        mov bx, word [eax]
        test bx, bx
        jge short .107
        movsx edx, bx
        neg edx
        jmp short .108
.107:
        movsx edx, bx
.108:
        mov eax, dword [puckvx]
        mov cx, word [eax]
        test cx, cx
        jge short .109
        movsx eax, cx
        neg eax
        jmp short .110
.109:
        movsx eax, cx
.110:
        add eax, edx
        cmp eax, 1200h
        jg short .111
        mov word [regd0], 8
        jmp near .136
.111:
        mov ax, word [regd3]
        test ax, ax
        je short .112
        cmp ax, 4
        jne near .132
.112:
        mov eax, dword [byte esi+facedir-2]
        sar eax, 10h
        test eax, eax
        jne short .115
        cmp word [regd0], byte 0
.113:
        jl short .117
.114:
        mov eax, 1
        jmp near .131
.115:
        cmp eax, byte 4
        jne short .118
        cmp word [regd0], byte 0
.116:
        jl short assgoalie.114
.117:
        mov eax, 7
        jmp near .131
.118:
        cmp eax, byte 1
        je short .119
        cmp eax, byte 5
        jne short .124
.119:
        cmp word [regd0], byte 0
        jge short .120
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .121
.120:
        mov eax, dword [regd0-2]
        sar eax, 10h
.121:
        cmp word [regd1], byte 0
        jge short .122
        mov edx, dword [regd1-2]
        sar edx, 10h
        neg edx
        jmp short .123
.122:
        mov edx, dword [regd1-2]
        sar edx, 10h
.123:
        cmp eax, edx
        jmp short assgoalie.113
.124:
        cmp eax, byte 3
        je short .125
        cmp eax, byte 7
        jne short .130
.125:
        cmp word [regd0], byte 0
        jge short .126
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .127
.126:
        mov eax, dword [regd0-2]
        sar eax, 10h
.127:
        cmp word [regd1], byte 0
        jge short .128
        mov edx, dword [regd1-2]
        sar edx, 10h
        neg edx
        jmp short .129
.128:
        mov edx, dword [regd1-2]
        sar edx, 10h
.129:
        cmp eax, edx
        jmp near assgoalie.116
.130:
        mov eax, 2
        call randomd0
.131:
        mov word [regd3], ax
.132:
        mov eax, dword [regd3_m2]
        sar eax, 12h
        mov word [regd0], ax
        test byte [byte esi+055h], 8
        je short .133
        test ax, ax
        sete al
        xor ah, ah
        mov word [regd0], ax
.133:
        mov bx, word [regd3]
        cmp bx, byte 4
        jl short .134
        mov eax, 7
        sub eax, ebx
        mov word [regd3], ax
.134:
        cmp word [regd3], byte 2
        jl short .135
        mov eax, dword [puckz]
        cmp word [eax], byte 0Ah
        jge short .135
        mov eax, dword [puckvz]
        cmp word [eax], 800h
        jge short .135
        add word [regd0], byte 6
        jmp short .136
.135:
        mov eax, dword [puckz]
        cmp word [eax], byte 8
        jge short .136
        mov eax, dword [puckvz]
        cmp word [eax], 800h
        jge short .136
        add word [regd0], byte 4
        cmp word [byte edi+02h], byte 9
        jb short .136
        mov ax, word [byte esi+facedir]
        cmp ax, 2
        je short .136
        cmp ax, 6
        je short .136
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jl short .136
        sub word [regd0], byte 2
.136:
        or byte [byte esi+pflags], 20h
        or byte [byte esi+pflags2], 2
        mov edx, dword [regd0-2]
        sar edx, 10h
        mov edx, dword [nosplit edx*2+goaliesave_saveanim_m2]
        sar edx, 10h
        mov eax, esi
        call SetSPA
        mov dx, word [crowdlevel]
        cmp dx, 4B0h
        jg short .137
        mov ebx, edx
        add ebx, 96h
        mov word [crowdlevel], bx
        cmp bx, 4B0h
        jle short .137
        mov word [crowdlevel], 4B0h
.137:
        mov ax, word [edi]
        mov word [regd0], ax
        mov eax, dword [pucky]
        mov dx, word [eax]
        test dx, dx
        jge short .138
        movsx eax, dx
        neg eax
        jmp short .139
.138:
        movsx eax, dx
.139:
        cmp eax, 0DCh
        jle short .142
        mov eax, dword [puckx]
        cmp word [eax], byte 0
        jle short .140
        mov eax, 18h
        jmp short .141
.140:
        mov eax, 0FFFFFFE8h
.141:
        mov word [regd0], ax
.142:
        mov ax, word [regd2]
        mov word [regd1], ax
        mov edx, dword [byte esi+0Ah]
        sar edx, 18h
        mov eax, dword [esi]
        sar eax, 10h
        add edx, eax
        mov eax, dword [regd0-2]
        sar eax, 10h
        sub eax, edx
        mov word [regd0], ax
        mov eax, dword [byte esi+0Ch]
        sar eax, 18h
        mov edx, dword [byte esi+Ypos]
        sar edx, 10h
        add edx, eax
        mov eax, dword [regd1-2]
        sar eax, 10h
        sub eax, edx
        mov word [regd1], ax
        test ebp, ebp
        je short .147
        mov edx, 5
        cmp word [regd0], byte 0
        jge short .143
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .144
.143:
        mov eax, dword [regd0-2]
        sar eax, 10h
.144:
        movsx ebx, dx
        cmp eax, ebx
        jge short .147
        cmp word [regd1], byte 0
        jge short .145
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .146
.145:
        mov eax, dword [regd1-2]
        sar eax, 10h
.146:
        movsx edx, dx
        cmp eax, edx
        jge short .147
        xor eax, eax
        mov word [regd1], ax
        mov word [regd0], ax
.147:
        mov edx, dword [regd1-2]
        sar edx, 10h
        mov eax, dword [regd0-2]
        sar eax, 10h
        call vtoa
        mov byte [byte esi+028h], al
        cbw
        mov word [regd2], ax
        cmp ax, 7
        jg near assgoalie.28
.148:
        mov edx, dword [regd2-2]
        sar edx, 10h
        mov eax, esi
        call playeracc
assgoalie_popebp:
        pop ebp
        jmp near ass_popx
;-----------------------------------------------------------------------------
; CountPuckThreat                              4C632  95 PC, medium confidence
; Counts the opposing skaters (other team's 6 sprites) within 14h of the puck
; (plus the player's offset) into threat
;-----------------------------------------------------------------------------
; C: src/engine/logic/assrefwhistle.c (CountPuckThreat)
%ifdef CBUILD
%include "c/engine/logic/assrefwhistle.CountPuckThreat.inc"
%else
CountPuckThreat:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ecx, dword [byte eax+0Ah]
        sar ecx, 18h
        mov edx, dword [puckx]
        movsx edx, word [edx]
        add ecx, edx
        mov edi, ecx
        mov ecx, dword [byte eax+0Ch]
        sar ecx, 18h
        mov edx, dword [pucky]
        movsx edx, word [edx]
        add edx, ecx
        mov esi, edx
        xor edx, edx
        mov word [threat], dx
        cmp word [byte eax+06Ah], byte 6
        jge short .1
        mov eax, 6
        jmp short .2
.1:
        xor eax, eax
.2:
        shl eax, 7
        add eax, SortCords
        xor ebx, ebx
        jmp short .9
.3:
        mov edx, dword [byte eax+0Ah]
        sar edx, 18h
        mov ecx, dword [eax]
        sar ecx, 10h
        add ecx, edx
        movsx edx, di
        sub ecx, edx
        mov edx, ecx
        test cx, cx
        jge short .4
        movsx edx, cx
        neg edx
        jmp short .5
.4:
        movsx edx, cx
.5:
        cmp edx, byte 14h
        jg short .8
        mov ecx, dword [byte eax+0Ch]
        sar ecx, 18h
        mov edx, dword [byte eax+04h]
        sar edx, 10h
        add edx, ecx
        movsx ecx, si
        sub edx, ecx
        test dx, dx
        jge short .6
        movsx edx, dx
        neg edx
        jmp short .7
.6:
        movsx edx, dx
.7:
        cmp edx, byte 14h
        jg short .8
        inc word [threat]
.8:
        add eax, 80h
        inc ebx
.9:
        cmp bx, byte 6
        jl short CountPuckThreat.3
        jmp near ass_popx
%endif ; C
;-----------------------------------------------------------------------------
; asspuckc                                              4C6F3  94G logic94.asm
; asstab 10h (player has the puck): checkob, chk4lc, chk4shot, chk4pass, then
; skateto with asspuckc_chkdir as the collision routine.
;-----------------------------------------------------------------------------
; C: src/engine/logic/asspuckc.c
%ifdef CBUILD
%include "c/engine/logic/asspuckc.inc"
%else
asspuckc:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push edi
        mov ebx, eax
        mov eax, dword [puckc]
        movsx ax, byte [eax]
        cmp ax, word [byte ebx+SCnum]
        je short .2
.1:
        mov eax, ebx
        call assexit
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.2:
        mov ah, byte [byte ebx+pflags]
        test ah, 20h
        jne near .x
        test byte [gmode], 1
        je short .3
        mov eax, ebx
        call donothing
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.3:
        test ah, 8
        jne short asspuckc.1
        test ah, 2
        je short .4
        mov ch, ah
        and ch, 0FDh
        mov byte [byte ebx+pflags], ch
        mov word [byte ebx+04Ch], 0
        mov word [byte ebx+temp1], 0
        mov word [byte ebx+temp2], 8
        mov eax, 4
        call randomd0
        mov word [byte ebx+temp3], ax
        xor ecx, ecx
        mov word [threat], cx
.4:
        mov al, byte [byte ebx+027h]
        dec al
        mov byte [byte ebx+027h], al
        test al, al
        jge near .8
        mov al, byte [byte ebx+059h]
        mov byte [byte ebx+027h], al
        mov eax, ebx
        call checkob
        cmp dword [shotongoal], byte 0
        je short .7
        cmp word [byte ebx+Ypos+2], byte 0
        jge short .5
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
        neg eax
        jmp short .6
.5:
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
.6:
        cmp eax, byte 70h
        jge short .7
        mov edx, 2Eh
        mov eax, ebx
        call assreplace
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.7:
        mov eax, ebx
        call chk4lc
        test ax, ax
        jne near .x
        mov eax, ebx
        call chk4shot
        test ax, ax
        jne near .x
        mov eax, ebx
        call chk4pass
        test ax, ax
        jne near .x
.8:
        test byte [gmode2], 80h
        je short .9
        mov ax, word [byte ebx+position]
        dec eax
        jmp short .10
.9:
        mov ax, word [byte ebx+temp3]
        add eax, 6
.10:
        mov word [regd0], ax
        mov ax, word [regd0]
        add eax, eax
        mov word [regd0], ax
        mov eax, dword [regd0-2]
        sar eax, 10h
        mov dx, word [nosplit eax*2+asspuckc_postab2_y]
        mov word [regd1], dx
        mov ax, word [nosplit eax*2+asspuckc_postab2]
        mov word [regd0], ax
        test byte [byte ebx+pflags], 80h
        jne short .11
        mov edi, eax
        neg edi
        mov word [regd0], di
        neg word [regd1]
.11:
        mov eax, dword [ebx]
        sar eax, 10h
        mov edx, dword [regd0-2]
        sar edx, 10h
        sub eax, edx
        test eax, eax
        jge short .12
        neg eax
.12:
        cmp eax, byte 0Ch
        jg short .14
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
        mov edx, dword [regd1-2]
        sar edx, 10h
        sub eax, edx
        test eax, eax
        jge short .13
        neg eax
.13:
        cmp eax, byte 0Ch
        jg short .14
        mov eax, 4
        call randomd0
        mov word [byte ebx+temp3], ax
.14:
        mov edx, asspuckc_chkdir
        mov eax, ebx
        call skateto
.x:
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; sub_4C8BD                                                       4C8BD  95 PC
;-----------------------------------------------------------------------------
; C: src/engine/logic/sub_4C8BD.c
%ifdef CBUILD
%include "c/engine/logic/sub_4C8BD.inc"
%else
sub_4C8BD:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        sub esp, byte 4
        mov edx, dword [byte eax+0Ah]
        sar edx, 19h
        mov ebx, dword [eax]
        sar ebx, 10h
        add ebx, edx
        mov ecx, dword [byte eax+0Ch]
        sar ecx, 19h
        mov edx, dword [byte eax+Ypos]
        sar edx, 10h
        add edx, ecx
        mov ecx, dword [byte eax+assnum-2]
        sar ecx, 10h
        cmp byte [byte ecx+eax+01Eh], 11h
        je near .x
        test byte [byte eax+pflags], 80h
        setne cl
        and ecx, 0FFh
        cmp word [byte eax+Ypos+2], byte 0
        setl byte [esp]
        movzx esi, byte [esp]
        xor ecx, esi
        jne near .x
        test edx, edx
        jge short .1
        mov ecx, edx
        neg ecx
        jmp short .2
.1:
        mov ecx, edx
.2:
        cmp ecx, 0AAh
        jl near .x
        test edx, edx
        jge short .3
        mov ecx, edx
        neg ecx
        jmp short .4
.3:
        mov ecx, edx
.4:
        cmp ecx, 0E8h
        jg near .x
        test ebx, ebx
        jge short .5
        mov ecx, ebx
        neg ecx
        jmp short .6
.5:
        mov ecx, ebx
.6:
        cmp ecx, byte 50h
        jg near .x
        mov eax, dword [byte eax+06Ch]
        mov eax, dword [dword eax+0F8h]
        sar eax, 10h
        test eax, eax
        jl near .x
        shl eax, 7
        add eax, SortCords
        mov esi, dword [byte eax+0Ah]
        sar esi, 19h
        mov ecx, dword [eax]
        sar ecx, 10h
        add ecx, esi
        sub ebx, ecx
        cmp word [regd1], byte 0
        jge short .7
        mov ecx, dword [regd1-2]
        sar ecx, 10h
        neg ecx
        jmp short .8
.7:
        mov ecx, dword [regd1-2]
        sar ecx, 10h
.8:
        cmp ecx, byte 14h
        jg short .x
        mov ecx, dword [byte eax+0Ch]
        sar ecx, 19h
        mov eax, dword [byte eax+Ypos]
        sar eax, 10h
        add eax, ecx
        sub edx, eax
        cmp word [regd1], byte 0
        jge short .9
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .10
.9:
        mov eax, dword [regd1-2]
        sar eax, 10h
.10:
        cmp eax, byte 14h
        jg short .x
        movsx edx, dx
        movsx eax, bx
        call vtoa
        mov word [regd0], ax
.x:
        add esp, byte 4
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; asspuckc_chkdir                  4C9FD  93G logic93_3.asm, medium confidence
; 93G asspuckc .chkdir: the skateto collision routine asspuckc passes (mov
; edx, asspuckc_chkdir), picks a direction with vtoa / randomd0
;-----------------------------------------------------------------------------
; C: src/engine/logic/asspuckc_chkdir.c
%ifdef CBUILD
%include "c/engine/logic/asspuckc_chkdir.inc"
%else
asspuckc_chkdir:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push edi
        mov ecx, eax
        movsx ax, byte [regd0]
        mov word [regd0], ax
        mov edx, dword [byte ecx+0Ah]
        sar edx, 18h
        mov eax, dword [puckx]
        movsx eax, word [eax]
        add eax, edx
        mov word [regd2], ax
        mov edx, dword [byte ecx+0Ch]
        sar edx, 18h
        mov eax, dword [pucky]
        movsx eax, word [eax]
        add eax, edx
        mov word [regd3], ax
        xor edx, edx
        mov word [threat], dx
        mov ebx, 6
        mov word [regd4], bx
        cmp bx, word [byte ecx+SCnum]
        jle short .1
        mov eax, 6
        jmp short .2
.1:
        xor eax, eax
.2:
        shl eax, 7
        mov ebx, SortCords
        add ebx, eax
.3:
        mov eax, dword [byte ebx+0Ah]
        sar eax, 18h
        mov edx, dword [ebx]
        sar edx, 10h
        add edx, eax
        mov eax, dword [regd2-2]
        sar eax, 10h
        sub edx, eax
        mov word [regd1], dx
        test dx, dx
        jge short .4
        mov edx, dword [regd1-2]
        sar edx, 10h
        neg edx
        jmp short .5
.4:
        mov edx, dword [regd1-2]
        sar edx, 10h
.5:
        cmp edx, byte 19h
        jg near .8
        mov eax, dword [byte ebx+0Ch]
        sar eax, 18h
        mov edx, dword [byte ebx+04h]
        sar edx, 10h
        add eax, edx
        mov edx, dword [regd3-2]
        sar edx, 10h
        sub eax, edx
        mov word [regd1], ax
        test ax, ax
        jge short .6
        mov edx, dword [regd1-2]
        sar edx, 10h
        neg edx
        jmp short .7
.6:
        mov edx, dword [regd1-2]
        sar edx, 10h
.7:
        cmp edx, byte 19h
        jg short .8
        inc word [threat]
        mov ax, word [byte ecx+Ypos+2]
        sub ax, word [byte ebx+06h]
        movsx edx, ax
        mov ax, word [byte ecx+Xpos+2]
        sub ax, word [byte ebx+02h]
        cwde
        call vtoa
        mov word [regd0], ax
        mov dx, word [byte ecx+facedir]
        xor dl, 4
        mov word [regd1], dx
        cmp ax, dx
        jne short .8
        mov eax, 2
        call randomd0
        add ax, word [regd0]
        xor ah, ah
        and al, 7
        mov word [regd0], ax
.8:
        add ebx, 80h
        mov di, word [regd4]
        dec di
        mov word [regd4], di
        jne near asspuckc_chkdir.3
        test byte [byte ecx+pflags], 80h
        setne al
        and eax, 0FFh
        cmp word [byte ecx+Ypos+2], byte 0
        setl dl
        and edx, 0FFh
        xor eax, edx
        jne near .x
        cmp word [regd3], byte 0
        jge short .9
        mov eax, dword [regd3-2]
        sar eax, 10h
        neg eax
        jmp short .10
.9:
        mov eax, dword [regd3-2]
        sar eax, 10h
.10:
        cmp eax, 0AAh
        jl near .x
        cmp word [regd3], byte 0
        jge short .11
        mov eax, dword [regd3-2]
        sar eax, 10h
        neg eax
        jmp short .12
.11:
        mov eax, dword [regd3-2]
        sar eax, 10h
.12:
        cmp eax, 0E8h
        jg near .x
        cmp word [regd2], byte 0
        jge short .13
        mov eax, dword [regd2-2]
        sar eax, 10h
        neg eax
        jmp short .14
.13:
        mov eax, dword [regd2-2]
        sar eax, 10h
.14:
        cmp eax, byte 50h
        jg near .x
        mov eax, dword [byte ecx+06Ch]
        mov ax, word [dword eax+0FAh]
        mov word [regd4], ax
        test ax, ax
        jl near .19
        mov ebx, dword [regd4-2]
        sar ebx, 10h
        shl ebx, 7
        add ebx, SortCords
        mov edx, dword [byte ebx+0Ah]
        sar edx, 18h
        mov eax, dword [ebx]
        sar eax, 10h
        add edx, eax
        mov eax, dword [regd2-2]
        sar eax, 10h
        sub edx, eax
        mov word [regd1], dx
        test dx, dx
        jge short .15
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .16
.15:
        mov eax, dword [regd1-2]
        sar eax, 10h
.16:
        cmp eax, byte 14h
        jg short .19
        mov edx, dword [byte ebx+0Ch]
        sar edx, 18h
        mov eax, dword [byte ebx+04h]
        sar eax, 10h
        add eax, edx
        mov edx, dword [regd3-2]
        sar edx, 10h
        sub eax, edx
        mov word [regd4], ax
        cmp word [regd1], byte 0
        jge short .17
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .18
.17:
        mov eax, dword [regd1-2]
        sar eax, 10h
.18:
        cmp eax, byte 14h
        jg short .19
        mov ax, word [regd4]
        neg eax
        movsx edx, ax
        mov ax, word [regd1]
        neg eax
        cwde
        call vtoa
        mov word [regd0], ax
.19:
        cmp word [regd2], byte 0
        jge short .20
        mov eax, dword [regd2-2]
        sar eax, 10h
        neg eax
        jmp short .21
.20:
        mov eax, dword [regd2-2]
        sar eax, 10h
.21:
        cmp eax, byte 1Eh
        jg short .x
        test byte [byte ecx+pflags], 80h
        je short .22
        mov edx, 0FFFFFF24h
        jmp short .23
.22:
        mov edx, 0DCh
.23:
        mov ax, word [regd3]
        mov ebx, edx
        sub ebx, eax
        mov word [regd1], bx
        test bx, bx
        jge short .24
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .25
.24:
        mov eax, dword [regd1-2]
        sar eax, 10h
.25:
        cmp eax, byte 14h
        jg short .x
        mov ax, word [byte ecx+Ypos+2]
        sub eax, edx
        movsx edx, ax
        mov eax, dword [ecx]
        sar eax, 10h
        call vtoa
        mov word [regd0], ax
.x:
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assnearest                         4CD4B  94G logic94.asm, medium confidence
; Asstab slot 17; field alignment 61% of 28 known-field accesses; content
; rank 1/34 vs other slot routines; 1 known Genesis callees present, 0
; missing, 0 extra
;-----------------------------------------------------------------------------
; C: src/engine/logic/assgoalie.c (assnearest)
%ifdef CBUILD
%include "c/engine/logic/assgoalie.assnearest.inc"
%else
assnearest:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 0Ch
        mov ebx, eax
        mov esi, eax
        mov eax, dword [byte eax+06Ch]
        mov dword [byte esp+04h], eax
        mov ah, byte [byte ebx+pflags]
        test ah, 2
        je short .1
        mov dl, ah
        and dl, 0FDh
        mov byte [byte ebx+pflags], dl
        mov word [byte ebx+temp1], 0
        mov word [byte ebx+temp2], 8
        mov word [byte ebx+temp3], 0
.1:
        mov eax, dword [puckc]
        movsx ax, byte [eax]
        cmp ax, word [byte ebx+SCnum]
        jne short .3
        cmp word [byte ebx+position], byte 0
        jne short .2
        mov eax, ebx
        call assgoalie
        jmp near .60
.2:
        test byte [byte ebx+pflags], 8
        jne near .60
        mov edx, 10h
        mov eax, ebx
        call assinsert
        jmp near .60
.3:
        mov dh, byte [byte ebx+027h]
        dec dh
        mov byte [byte ebx+027h], dh
        test dh, dh
        jge near .33
        mov al, byte [byte ebx+059h]
        mov byte [byte ebx+027h], al
        mov eax, dword [byte esp+04h]
        mov dword [byte eax+03Ah], 0
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jl short .4
        cmp word [byte ebx+SCnum], byte 6
        setl al
        xor edx, edx
        mov dl, al
        mov eax, dword [puckc]
        cmp byte [eax], 6
        setl al
        and eax, 0FFh
        cmp eax, edx
        jne short .4
        mov eax, dword [puckc]
        movsx eax, byte [eax]
        shl eax, 7
        mov esi, SortCords
        add esi, eax
        jmp near .15
.4:
        mov ax, word [byte ebx+SCnum]
        mov dword [byte esp+08h], eax
        mov cx, word [byte ebx+Ypos+2]
        mov dword [regd2], 0FFFFFFFFh
        mov edi, 6
        mov word [regd4], di
        cmp di, word [byte ebx+SCnum]
        jle short .5
        xor eax, eax
        jmp short .6
.5:
        mov eax, 6
.6:
        shl eax, 7
        mov edx, SortCords
        add edx, eax
        mov eax, dword [byte ebx+SCnum-2]
        sar eax, 10h
        cmp eax, dword [penshotplayer]
        je near .14
.7:
        cmp word [byte edx+position], byte 0
        jle near .13
        cmp word [byte edx+03Eh], byte 0
        jne near .13
        test byte [byte edx+pflags2], 4
        jne near .13
        mov eax, dword [byte edx+assnum-2]
        sar eax, 10h
        cmp byte [byte edx+eax+01Eh], 13h
        je near .13
        cmp word [byte edx+Ypos+2], byte 0
        jge short .8
        mov eax, dword [byte edx+Ypos]
        sar eax, 10h
        neg eax
        jmp short .9
.8:
        mov eax, dword [byte edx+Ypos]
        sar eax, 10h
.9:
        cmp eax, 0E8h
        jge short .12
        test byte [byte ebx+pflags], 80h
        je short .10
        cmp cx, word [byte edx+Ypos+2]
        jge short .11
.10:
        test byte [byte ebx+pflags], 80h
        jne short .12
        cmp cx, word [byte edx+Ypos+2]
        jg short .12
.11:
        mov ax, word [byte edx+SCnum]
        mov dword [byte esp+08h], eax
        mov cx, word [byte edx+Ypos+2]
.12:
        mov eax, edx
        call GetHot
        mov ebp, dword [edx]
        sar ebp, 10h
        mov eax, dword [regd0-2]
        sar eax, 10h
        add ebp, eax
        mov eax, dword [puckx]
        movsx edi, word [eax]
        sub ebp, edi
        mov edi, ebp
        mov eax, dword [puckvx]
        movsx eax, word [eax]
        sar eax, 6
        sub edi, eax
        mov word [regd0], di
        mov eax, dword [regd0-2]
        sar eax, 10h
        imul eax, eax
        mov dword [regd0], eax
        mov edi, dword [byte edx+Ypos]
        sar edi, 10h
        mov eax, dword [regd1-2]
        sar eax, 10h
        add eax, edi
        mov dword [esp], eax
        mov eax, dword [pucky]
        movsx edi, word [eax]
        mov eax, dword [esp]
        sub eax, edi
        mov edi, eax
        mov eax, dword [puckvy]
        movsx eax, word [eax]
        sar eax, 6
        sub edi, eax
        mov word [regd1], di
        mov eax, dword [regd1-2]
        sar eax, 10h
        imul eax, eax
        mov dword [regd1], eax
        mov ebp, dword [regd0]
        add ebp, eax
        mov dword [regd0], ebp
        cmp ebp, dword [regd2]
        ja short .13
        mov dword [regd2], ebp
        mov esi, edx
.13:
        add edx, 80h
        mov ax, word [regd4]
        dec ax
        mov word [regd4], ax
        jne near assnearest.7
.14:
        mov ebp, dword [regd2]
        test ebp, ebp
        jl short .16
        mov edx, dword [byte esp+04h]
        mov dword [byte edx+03Ah], ebp
.15:
        cmp esi, ebx
        je short .16
        test byte [gmode], 1
        jne short .16
        cmp word [byte esi+position], byte 0
        jle short .16
        test byte [byte esi+pflags2], 4
        jne short .16
        and byte [byte esi+pflags], 0FEh
        mov edx, 11h
        mov eax, esi
        call assinsert
        mov eax, ebx
        call assexit
        jmp near .60
.16:
        test byte [byte ebx+pflags], 20h
        jne near .60
        mov dword [regd1], 2
        mov dx, word [regd2]
        cmp dx, 190h
        jle near .23
        cmp dx, 0E10h
        jg short .21
        mov eax, dword [puckvx]
        mov si, word [eax]
        test si, si
        jge short .17
        movsx eax, si
        neg eax
        jmp short .18
.17:
        movsx eax, si
.18:
        cmp eax, 1F4h
        jge short .21
        mov eax, dword [puckvy]
        mov di, word [eax]
        test di, di
        jge short .19
        movsx eax, di
        neg eax
        jmp short .20
.19:
        movsx eax, di
.20:
        cmp eax, 1F4h
        jl short .23
.21:
        mov ax, word [byte ebx+position]
        cmp ax, 2
        jle near .24
        test byte [byte ebx+pflags], 80h
        je short .22
        cmp ax, 4Eh
        jg short .23
.22:
        test byte [byte ebx+pflags], 80h
        jne short .24
        mov eax, dword [byte ebx+position-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFB2h
        jge short .24
.23:
        sub word [regd1], byte 2
        cmp word [byte ebx+position], byte 2
        jg short .24
        mov ax, word [byte ebx+SCnum]
        cmp ax, word [byte esp+08h]
        je near .33
        xor eax, eax
        mov al, byte [byte ebx+062h]
        mov edx, 32h
        sub edx, eax
        xor eax, eax
        mov al, byte [byte ebx+064h]
        sub edx, eax
        mov eax, edx
        xor edx, edx
        mov dl, byte [byte ebx+05Ah]
        sub eax, edx
        mov edx, eax
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        cwde
        call randomd0
        test ax, ax
        jne near .33
.24:
        mov eax, dword [puckvx]
        mov dx, word [eax]
        test dx, dx
        jge short .25
        movsx eax, dx
        neg eax
        jmp short .26
.25:
        movsx eax, dx
.26:
        cmp eax, 1F4h
        jge short .29
        mov eax, dword [puckvy]
        mov cx, word [eax]
        test cx, cx
        jge short .27
        movsx eax, cx
        neg eax
        jmp short .28
.27:
        movsx eax, cx
.28:
        cmp eax, 1F4h
        jge short .29
        dec word [regd1]
.29:
        test byte [gmode2], 20h
        je short .30
        sub word [regd1], byte 2
        mov al, byte [byte ebx+pflags]
        and al, 40h
        xor edx, edx
        mov dl, al
        mov ax, word [gmode2]
        xor ah, ah
        and al, 40h
        cwde
        xor eax, edx
        je short .30
        add dword [regd1], byte 4
.30:
        cmp word [regd1], byte 0
        jge short .31
        xor eax, eax
        mov al, byte [byte ebx+064h]
        mov edx, 14h
        sub edx, eax
        mov eax, edx
        mov ecx, dword [regd1-2]
        sar ecx, 10h
        neg ecx
        sar eax, cl
        jmp short .32
.31:
        xor eax, eax
        mov al, byte [byte ebx+064h]
        mov edx, 14h
        sub edx, eax
        mov eax, edx
        mov cx, word [regd1]
        shl eax, cl
.32:
        mov word [regd0], ax
        mov eax, dword [regd0-2]
        sar eax, 10h
        call randomd0
        cmp ax, 1
        ja short .33
        mov word [byte ebx+temp3], 12Ch
.33:
        mov dl, byte [byte ebx+pflags]
        test dl, 20h
        jne near .60
        test byte [gmode], 1
        je short .34
        mov eax, ebx
        call check4bench
        test ax, ax
        jne near .60
        mov eax, ebx
        call donothing
        jmp near .60
.34:
        test dl, 8
        jne near .60
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jl short .35
        mov dx, word [byte ebx+temp3]
        dec edx
        mov word [byte ebx+temp3], dx
        test dx, dx
        jl short .36
.35:
        mov eax, ebx
        call skatetopuck
        jmp near .59
.36:
        mov word [byte ebx+temp3], 0
        mov eax, dword [puckvx]
        movsx eax, byte [byte eax+01h]
        sar eax, 1
        movsx edx, ax
        mov eax, dword [puckx]
        movsx eax, word [eax]
        add eax, edx
        mov word [regd0], ax
        mov eax, dword [puckvy]
        movsx eax, byte [byte eax+01h]
        sar eax, 1
        movsx edx, ax
        mov eax, dword [pucky]
        movsx eax, word [eax]
        add eax, edx
        mov word [regd1], ax
        mov edx, dword [regd0-2]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, eax
        sar edx, 1Fh
        shl edx, 2
        LD sbb, eax, edx
        sar eax, 2
        mov word [regd0], ax
        test byte [byte ebx+pflags], 80h
        je short .37
        mov eax, 0FFFFFF2Ch
        jmp short .38
.37:
        mov eax, 0D4h
.38:
        mov edx, dword [regd1-2]
        sar edx, 10h
        sub eax, edx
        sar eax, 1
        add eax, edx
        mov word [regd1], ax
        mov eax, dword [pucky]
        mov si, word [eax]
        test si, si
        jge short .39
        movsx eax, si
        neg eax
        jmp short .40
.39:
        movsx eax, si
.40:
        cmp word [regd1], byte 0
        jge short .41
        mov edx, dword [regd1-2]
        sar edx, 10h
        neg edx
        jmp short .42
.41:
        mov edx, dword [regd1-2]
        sar edx, 10h
.42:
        cmp edx, eax
        jle near .58
        mov eax, dword [puckx]
        mov dx, word [eax]
        test dx, dx
        jge short .43
        movsx eax, dx
        neg eax
        jmp short .44
.43:
        movsx eax, dx
.44:
        cmp eax, byte 41h
        jge near .58
        mov eax, dword [pucky]
        movsx edx, word [eax]
        mov eax, dword [regd1-2]
        sar eax, 10h
        sub eax, edx
        test eax, eax
        jge short .45
        neg eax
.45:
        cmp eax, byte 14h
        jle near .58
        cmp word [regd0], byte 0
        jge short .46
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .47
.46:
        mov eax, dword [regd0-2]
        sar eax, 10h
.47:
        cmp eax, byte 14h
        jge short .51
        cmp word [regd1], byte 0
        jge short .48
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .49
.48:
        mov eax, dword [regd1-2]
        sar eax, 10h
.49:
        cmp eax, 0C8h
        jle near .58
        cmp word [regd1], byte 0
        jge short .50
        mov eax, 0FFFFFF38h
        jmp near .57
.50:
        mov eax, 0C8h
        jmp short .57
.51:
        cmp word [regd0], byte 0
        jge short .52
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .53
.52:
        mov eax, dword [regd0-2]
        sar eax, 10h
.53:
        cmp eax, byte 28h
        jge short .58
        cmp word [regd1], byte 0
        jge short .54
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .55
.54:
        mov eax, dword [regd1-2]
        sar eax, 10h
.55:
        cmp eax, 0D2h
        jle short .58
        cmp word [regd1], byte 0
        jge short .56
        mov eax, 0FFFFFF2Eh
        jmp short .57
.56:
        mov eax, 0D2h
.57:
        mov word [regd1], ax
.58:
        xor edx, edx
        mov eax, ebx
        call skateto
.59:
        mov eax, ebx
        call check4check
.60:
        add esp, byte 0Ch
        jmp near assgoalie_popebp
%endif ; C
;-----------------------------------------------------------------------------
; assshoot                           4D3F8  94G logic94.asm, medium confidence
; Asstab slot 18; field alignment 100% of 3 known-field accesses; content
; rank 1/34 vs other slot routines; 0 known Genesis callees present, 0
; missing, 1 extra
;-----------------------------------------------------------------------------
; C: src/engine/logic/assshoot.c
%ifdef CBUILD
%include "c/engine/logic/assshoot.inc"
%else
assshoot:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push edi
        mov edx, eax
        test byte [byte eax+pflags], 20h
        jne near .11
        mov bl, byte [byte edx+pflags]
        test bl, 2
        je short .1
        mov ah, bl
        and ah, 0FDh
        mov byte [byte edx+pflags], ah
        mov eax, edx
        call SetShotMode
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        test byte [sflags], 8
        jne short .2
        mov eax, edx
        call assexit
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.2:
        xor ebx, ebx
        mov word [regd2], bx
        mov cx, word [byte edx+temp2]
        dec ecx
        mov word [byte edx+temp2], cx
        test cx, cx
        jge short .3
        or byte [regd2], 20h
.3:
        mov di, word [byte edx+04Ch]
        dec edi
        mov word [byte edx+04Ch], di
        test di, di
        jge short .4
        mov word [byte edx+04Ch], 0
.4:
        cmp word [byte edx+Ypos+2], byte 0
        jge short .5
        mov eax, dword [byte edx+Ypos]
        sar eax, 10h
        neg eax
        jmp short .6
.5:
        mov eax, dword [byte edx+Ypos]
        sar eax, 10h
.6:
        cmp eax, 9Eh
        jge short .9
        cmp word [byte edx+Ypos+2], byte 0
        jge short .7
        mov eax, dword [byte edx+Ypos]
        sar eax, 10h
        neg eax
        jmp short .8
.7:
        mov eax, dword [byte edx+Ypos]
        sar eax, 10h
.8:
        cmp eax, byte 53h
        jle short .9
        mov eax, dword [byte edx+070h]
        cmp dword [byte eax+03Eh], byte 24h
        jge short .9
        cmp word [byte edx+04Ch], byte 0
        jne short .9
        mov eax, 14h
        call randomd0
        test ax, ax
        jne short .9
        mov word [byte edx+04Ch], 12Ch
        or byte [regd1], 10h
        jmp short .10
.9:
        and byte [regd1], 0AFh
.10:
        mov eax, edx
        call ShotMode
.11:
        pop edi
        pop edx
        pop ecx
        pop ebx
assshoot_ret:
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assfaceoff                         4D4F0  94G logic94.asm, medium confidence
; Asstab slot 22; field alignment 100% of 1 known-field accesses; content
; rank 1/34 vs other slot routines; 0 known Genesis callees present, 0
; missing, 0 extra
;-----------------------------------------------------------------------------
; C: src/engine/logic/assshoot.c (assfaceoff)
%ifdef CBUILD
%include "c/engine/logic/assshoot.assfaceoff.inc"
%else
assfaceoff:
        push dword 4
        call __CHK
        test byte [byte eax+pflags], 20h
        jne short assshoot_ret
        test byte [gmode2], 1
        jne short assshoot_ret
%endif ; C
;-----------------------------------------------------------------------------
; assexit                                               4D509  94G logic94.asm
;-----------------------------------------------------------------------------
; C: src/engine/logic/assshoot.c (assexit)
%ifdef CBUILD
%include "c/engine/logic/assshoot.assexit.inc"
%else
assexit:
        push dword 8
        call __CHK
        push edx
        mov dx, word [byte eax+01Ch]
        inc edx
        xor dh, dh
        and dl, 7
        mov word [byte eax+01Ch], dx
        or byte [byte eax+044h], 2
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assfaceoffpl                                        4D528  95G faceoff95.asm
; 95G assfaceoffpl (93G logic93.asm): the faceoff participant. pflags bit 5
; returns; faceoff flag clear calls assexit; bit 1 clears temp1 and sets the
; faceoff frame
;-----------------------------------------------------------------------------
; C: src/engine/logic/assfaceoffpl.c
%ifdef CBUILD
%include "c/engine/logic/assfaceoffpl.inc"
%else
assfaceoffpl:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov ebx, eax
        test byte [byte eax+pflags], 20h
        jne near .x
        test byte [gmode2], 1
        jne short .1
        mov word [byte ebx+03Eh], 14h
        mov eax, ebx
        call assexit
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        mov dh, byte [byte ebx+pflags]
        test dh, 2
        je short .5
        mov cl, dh
        and cl, 0FDh
        mov byte [byte ebx+pflags], cl
        mov word [byte ebx+temp1], 0
        cmp word [byte ebx+facedir], byte 0
        je short .2
        mov eax, 167h
        jmp short .3
.2:
        mov eax, 16Ch
.3:
        mov word [byte ebx+012h], ax
        xor edx, edx
        mov eax, ebx
        call SetSPA
        test byte [byte ebx+pflags], 40h
        je short .4
        mov eax, 0Ah
        call randomd0
        add eax, 14h
        mov word [byte ebx+temp5], ax
        jmp short .5
.4:
        mov word [byte ebx+temp5], 28h
.5:
        mov edx, fofdata2
        test byte [byte ebx+pflags], 40h
        je short .6
        add edx, byte 4
.6:
        mov cx, word [byte ebx+012h]
        cmp cx, 169h
        je short .7
        cmp cx, 16Eh
        jne short .8
.7:
        mov word [regd0], 2
        jmp short .12
.8:
        cmp cx, 16Ah
        je short .9
        cmp cx, 16Fh
        jne short .11
.9:
        cmp word [byte ebx+SPAcnt], byte 7
        jne short .10
        test byte [byte ebx+pflags], 40h
        setne al
        and eax, 0FFh
        add eax, 9Eh
        cwde
        call sfx
.10:
        mov word [regd0], 3
        jmp short .12
.11:
        mov word [regd0], 1
.12:
        cmp byte [byte ebx+065h], 0
        jne short .13
        add word [regd0], byte 3
.13:
        mov ax, word [regd0]
        mov word [edx], ax
        test byte [byte ebx+pflags], 8
        jne near .x
        mov al, byte [byte ebx+pflags2]
        test al, 2
        jne near .x
        mov ah, al
        or ah, 2
        mov byte [byte ebx+pflags2], ah
        cmp word [byte ebx+temp5], byte 0
        jge short .14
        cmp word [pucktemp1], byte 10h
        jbe short .15
        mov eax, 8
        call randomd0
        test ax, ax
        je short .15
.14:
        mov dx, word [byte ebx+temp5]
        dec edx
        mov word [byte ebx+temp5], dx
        test dx, dx
        jge short .x
        mov eax, 7F1h
        jmp short .17
.15:
        mov word [byte ebx+temp5], 0FFFFh
        cmp word [pucktemp1], byte 11h
        jge short .16
        or byte [byte ebx+pflags], 20h
        mov eax, 7DDh
        jmp short .17
.16:
        mov eax, 0D05h
.17:
        movsx edx, ax
        mov eax, ebx
        call SetSPA
.x:
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; pucknorm_body                                         4D6B4  94G logic94.asm
;-----------------------------------------------------------------------------
; C: src/engine/logic/assrefwhistle.c (pucknorm_body)
%ifdef CBUILD
%include "c/engine/logic/assrefwhistle.pucknorm_body.inc"
%else
pucknorm_body:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ebx, eax
        dec word [puckcross2]
        dec word [puckcross6]
        mov si, word [byte eax+026h]
        dec esi
        mov word [byte eax+026h], si
        test si, si
        jge short .1
        mov eax, esi
        add eax, 5
        mov word [byte ebx+temp1], ax
        mov eax, ebx
        call findpc
.1:
        mov edx, dword [puckc]
        mov ah, byte [edx]
        test ah, ah
        jl short .2
        movsx eax, ah
        shl eax, 7
        mov edx, SortCords
        add edx, eax
        mov eax, edx
        call a2touchpuck
        mov eax, edx
        call GetHot
        mov eax, dword [edx]
        sar eax, 10h
        mov ecx, dword [regd0-2]
        sar ecx, 10h
        add ecx, eax
        mov eax, dword [ebx]
        sar eax, 10h
        sub ecx, eax
        sar ecx, 2
        add eax, ecx
        mov word [byte ebx+Xpos+2], ax
        mov eax, dword [byte edx+Ypos]
        sar eax, 10h
        mov ecx, dword [regd1-2]
        sar ecx, 10h
        add ecx, eax
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
        sub ecx, eax
        sar ecx, 2
        add eax, ecx
        mov word [byte ebx+Ypos+2], ax
        mov ax, word [byte edx+Xvel]
        mov word [byte ebx+Xvel], ax
        mov ax, word [byte edx+Yvel]
        mov word [byte ebx+Yvel], ax
.2:
        call PuckIChk
        mov eax, ebx
        call ChkOffsides
        mov eax, ebx
        call MarkTwoLinePlayers
        mov dl, byte [gmode]
        test dl, 1
        jne near .14
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jl short .4
        xor esi, esi
        mov dword [psendcount], esi
.3:
        mov word [byte ebx+temp2], 78h
        jmp near .14
.4:
        test dl, 2
        sete al
        and eax, 0FFh
        xor eax, dword [penshotteam]
        cmp dword [penshotlive], byte 0
        je short .7
        test eax, eax
        jne short .5
        mov edx, dword [puckvy]
        cmp word [edx], byte 0
        jge short .6
.5:
        test eax, eax
        je short .7
        mov eax, dword [puckvy]
        cmp word [eax], byte 0
        jg short .7
.6:
        mov edi, dword [psendcount]
        inc edi
        mov dword [psendcount], edi
        cmp edi, byte 1Eh
        jl short .8
        call EndPenaltyShot
        xor eax, eax
        mov dword [psendcount], eax
        jmp short .8
.7:
        xor esi, esi
        mov dword [psendcount], esi
.8:
        mov ax, word [byte ebx+Xpos+2]
        cmp ax, word [byte ebx+OldXpos+2]
        jne short pucknorm_body.3
        mov ax, word [byte ebx+Ypos+2]
        cmp ax, word [byte ebx+07Ah]
        jne short pucknorm_body.3
        mov edx, dword [puckx]
        mov cx, word [edx]
        test cx, cx
        jge short .9
        movsx eax, cx
        neg eax
        jmp short .10
.9:
        movsx eax, cx
.10:
        cmp eax, 0A3h
        jge short .13
        mov edx, dword [pucky]
        mov si, word [edx]
        test si, si
        jge short .11
        movsx edx, si
        neg edx
        jmp short .12
.11:
        movsx edx, si
.12:
        cmp edx, 10Eh
        jge short .13
        cmp dword [hmtmnear], byte 14h
        jle short .13
        cmp dword [awtmnear], byte 14h
        jg near pucknorm_body.3
.13:
        mov di, word [byte ebx+temp2]
        dec edi
        mov word [byte ebx+temp2], di
        test di, di
        jge short .14
        mov edx, 3
        mov eax, ebx
        call AddPenalty2
.14:
        cmp word [byte ebx+010h], byte 0
        jge short .15
        mov eax, dword [byte ebx+0Eh]
        sar eax, 10h
        neg eax
        jmp short .16
.15:
        mov eax, dword [byte ebx+0Eh]
        sar eax, 10h
.16:
        cmp eax, 100h
        jge short .17
        cmp word [byte ebx+0Ah], byte 0
        jne short .17
        mov eax, ebx
        call puckunflip
.17:
        mov eax, ebx
        call checkpuckcoll
        jmp near ass_popx
%endif ; C
;-----------------------------------------------------------------------------
; pucknorm                                              4D8C7  94G logic94.asm
; Slot $18; head identical to 93G pucknorm: bclr pfna; clr temp1(+26h);
; temp2(+28h)=$78; then calls the body sub_4D6B4
;-----------------------------------------------------------------------------
; C: src/engine/logic/pucknorm.c
%ifdef CBUILD
%include "c/engine/logic/pucknorm.inc"
%else
pucknorm:
        push dword 8
        call __CHK
        push edx
        mov dl, byte [byte eax+pflags]
        test dl, 2
        je short .1
        mov dh, dl
        and dh, 0FDh
        mov byte [byte eax+pflags], dh
        mov word [byte eax+temp1], 0
        mov word [byte eax+temp2], 78h
        xor edx, edx
        mov dword [psendcount], edx
.1:
        call pucknorm_body
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; pucknothing                        4D8FD  94G logic94.asm, medium confidence
; Asstab slot 26; field alignment n/a of 0 known-field accesses; content rank
; 2/34 vs other slot routines; 0 known Genesis callees present, 0 missing, 0
; extra
;-----------------------------------------------------------------------------
; C: src/engine/logic/pucknothing.c
%ifdef CBUILD
%include "c/engine/logic/pucknothing.inc"
%else
pucknothing:
        push dword 4
        call __CHK
;-----------------------------------------------------------------------------
; puckunflip                         4D907  94G logic94.asm, medium confidence
;-----------------------------------------------------------------------------
; C: src/engine/logic/puckunflip.c
%ifdef CBUILD
%include "c/engine/logic/puckunflip.inc"
%else
puckunflip:
        push dword 8
        call __CHK
        push edx
        mov dx, word [byte eax+03Ah]
        cmp dx, byte 4
        jl short .1
        cmp dx, byte 0Ch
        jge short .1
        xor byte [byte eax+036h], 2
.1:
        or byte [byte eax+036h], 4
        mov word [byte eax+03Ah], 0
        mov word [byte eax+03Ch], 0FFFFh
        pop edx
        ret
%endif ; C
%endif ; C
;-----------------------------------------------------------------------------
; RequestLineChange                            4D938  95 PC, medium confidence
; Team from pflags+44h bit 40h: getlchoice (or the team's current line
; hmtmstruct/awtmstruct+2Ah) into lcline, lcsel, lctimer=3Ch,
; lcblink/lcblinktime=0Ch, lcboxon=1; clears hmlinetimer/C5860. Replaces the
; 93G loadTeamStruct guess (cosine 0.14), which does none of this
;-----------------------------------------------------------------------------
; C: src/engine/logic/assrefwhistle.c (RequestLineChange)
%ifdef CBUILD
%include "c/engine/logic/assrefwhistle.RequestLineChange.inc"
%else
RequestLineChange:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        test byte [byte eax+044h], 40h
        setne dl
        xor dh, dh
        mov ebx, edx
        mov ecx, 1
        mov word [regd0], cx
        call getlchoice
        mov si, word [regd0]
        test si, si
        jge short .3
        movsx eax, dx
        xor ecx, ecx
        mov word [nosplit eax*2+lcsel], cx
        test dx, dx
        jle short .1
        mov eax, awtmstruct
        jmp short .2
.1:
        mov eax, hmtmstruct
.2:
        movsx edx, bx
        mov ax, word [byte eax+02Ah]
        mov word [nosplit edx*2+lcline], ax
        jmp short .4
.3:
        movsx eax, dx
        mov word [nosplit eax*2+lcsel], cx
        mov word [nosplit eax*2+lcline], si
.4:
        movsx eax, bx
        mov word [nosplit eax*2+lctimer], 3Ch
        mov edi, 1
        mov word [nosplit eax*2+lcblink], di
        mov word [nosplit eax*2+lcblinktime], 0Ch
        mov word [nosplit eax*2+lcboxon], di
        test bx, bx
        je short .5
        xor ebx, ebx
        mov dword [awlinetimer], ebx
        jmp near ass_popx
.5:
        xor edx, edx
        mov dword [hmlinetimer], edx
        jmp near ass_popx
%endif ; C
;-----------------------------------------------------------------------------
; SetLCmode                          4D9FC  94G logic94.asm, medium confidence
;-----------------------------------------------------------------------------
; C: src/engine/logic/SetLCmode.c
%ifdef CBUILD
%include "c/engine/logic/SetLCmode.inc"
%else
SetLCmode:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        test byte [gameopts], 4
        je short .x
        mov edx, dword [byte eax+06Ch]
        mov bl, byte [byte edx+tmflags]
        test bl, 2
        jne short .x
        mov bh, bl
        or bh, 2
        mov byte [byte edx+tmflags], bh
        and byte [sflags], 0F3h
        or byte [byte eax+045h], 8
        call RequestLineChange
.x:
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; StartFaceoffLineChange                                4DA37  94G logic94.asm
;-----------------------------------------------------------------------------
; C: src/engine/logic/StartFaceoffLineChange.c
%ifdef CBUILD
%include "c/engine/logic/StartFaceoffLineChange.inc"
%else
StartFaceoffLineChange:
        push dword 8
        call __CHK
        push ebx
        mov ebx, eax
        and byte [byte edx+pflags2], 0F7h
        mov eax, edx
        call SetLCmode
        test byte [byte edx+pflags2], 8
        je short .x
        test byte [byte edx+pflags], 40h
        je short .1
        mov word [byte ebx+temp2], 168h
        mov dx, word [byte edx+SCnum]
        mov word [byte ebx+temp4], dx
        pop ebx
        ret
.1:
        mov word [byte ebx+temp1], 258h
        mov dx, word [byte edx+SCnum]
        mov word [byte ebx+temp3], dx
.x:
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; Endfaceoff                         4DA7B  94G logic94.asm, medium confidence
;-----------------------------------------------------------------------------
; C: src/engine/logic/assrefwhistle.c (Endfaceoff)
%ifdef CBUILD
%include "c/engine/logic/assrefwhistle.Endfaceoff.inc"
%else
Endfaceoff:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ecx, eax
        call StopDigiSample
        mov eax, 0ABh
        call sfx
        and byte [gmode2], 0FAh
        and byte [gmode], 0FEh
        and byte [byte ecx+pflags2], 0FEh
        or byte [sflags3], 10h
        mov eax, dword [fofdata2-2]
        sar eax, 10h
        movsx ax, byte [dword eax+Endfaceoff_ftab_m1]
        mov edx, 10h
        sub edx, eax
        mov eax, dword [fofdata2_w4-2]
        sar eax, 10h
        movsx ax, byte [dword eax+Endfaceoff_ftab_m1]
        add edx, eax
        mov word [regd2], dx
        xor edx, edx
        jmp short .2
.1:
        movsx eax, dx
        shl eax, 7
        cmp word [dword eax+SortCords+1Ah], byte 4
        je short .3
        inc edx
.2:
        cmp dx, byte 6
        jl short Endfaceoff.1
.3:
        mov ebx, 6
        jmp short .5
.4:
        movsx eax, bx
        shl eax, 7
        cmp word [dword eax+SortCords+1Ah], byte 4
        je short .6
        inc ebx
.5:
        cmp bx, byte 0Ch
        jl short Endfaceoff.4
.6:
        movsx eax, bx
        shl eax, 7
        mov esi, dword [dword eax+SortCords+44h]
        sar esi, 18h
        mov eax, esi
        shl eax, 2
        add eax, esi
        movzx di, byte [nosplit eax*4+awplattr_b13]
        movsx eax, dx
        shl eax, 7
        mov esi, dword [dword eax+SortCords+44h]
        sar esi, 18h
        mov eax, esi
        shl eax, 2
        add eax, esi
        mov al, byte [nosplit eax*4+hmplattr_b13]
        xor ah, ah
        sub edi, eax
        add word [regd2], di
        mov eax, 21h
        call randomd0
        cmp ax, word [regd2]
        jge short .7
        mov ax, word [fofdata2_w6]
        mov word [lasttouch], bx
        jmp short .8
.7:
        mov ax, word [fofdata2_w2]
        mov word [lasttouch], dx
.8:
        test ah, 8
        je short .9
        mov ax, word [fodir2]
        mov word [regd3], ax
        mov word [regd4], 0F800h
        jmp short .10
.9:
        mov ax, word [fodir1]
        mov word [regd3], ax
        mov word [regd4], 800h
.10:
        mov ax, word [regd3]
        mov word [regd0], ax
        test byte [regd0], 8
        jne short .11
        mov ebx, eax
        xor bh, ah
        and bl, 7
        mov word [regd0], bx
        mov eax, 4
        call randomd0
        test ax, ax
        jne short .13
        mov eax, 5
        call randomd0
        sub eax, byte 2
        xor ah, ah
        and al, 7
        mov word [regd0], ax
        cmp word [regd4], byte 0
        jge short .13
        jmp short .12
.11:
        mov eax, 5
        call randomd0
        sub eax, byte 2
        xor ah, ah
        and al, 7
        mov word [regd0], ax
        cmp word [regd4], byte 0
        jge short .13
.12:
        xor byte [regd0], 4
.13:
        mov ax, word [regd0]
        add eax, eax
        mov word [regd0], ax
        mov eax, dword [regd0-2]
        sar eax, 10h
        mov ax, word [nosplit eax*2+dirtab]
        shl eax, 5
        mov word [byte ecx+Xvel], ax
        mov eax, dword [regd0-2]
        sar eax, 10h
        mov dx, word [nosplit eax*2+dirtab_y]
        shl edx, 5
        mov ax, word [regd4]
        add edx, eax
        mov word [byte ecx+Yvel], dx
        mov eax, 800h
        call randomd0
        mov word [byte ecx+010h], ax
        mov eax, dword [puckz]
        mov word [eax], 0
        and byte [byte ecx+pflags], 0FBh
        mov edx, 18h
        mov eax, ecx
        call assreplace
        mov edx, 1Fh
        mov eax, SortCords+800h
        call assreplace
        cmp word [SortCords+802h], byte 0
        jle short .14
        mov eax, 500h
        jmp short .15
.14:
        mov eax, 0FFFFFB00h
.15:
        mov word [refXvel], ax
        jmp near ass_popx
%endif ; C
;-----------------------------------------------------------------------------
; a2offsides                         4DCDD  94G logic94.asm, medium confidence
;-----------------------------------------------------------------------------
; C: src/engine/logic/a2offsides.c
%ifdef CBUILD
%include "c/engine/logic/a2offsides.inc"
%else
a2offsides:
        push dword 8
        call __CHK
        push edx
        test byte [gameopts], 2
        jne short .2
.1:
        xor eax, eax
        pop edx
        ret
.2:
        cmp dword [penshotlive], byte 0
        jne short a2offsides.1
        cmp dword [penshotstart], byte 0
        jne short a2offsides.1
        mov edx, dword [pucky]
        mov dx, word [edx]
        mov word [regd0], dx
        test byte [byte eax+044h], 80h
        jne short .3
        neg word [regd0]
.3:
        cmp word [regd0], byte 4Eh
        jl short a2offsides.1
        mov edx, dword [byte eax+06Ch]
        test byte [byte edx+tmflags], 10h
        je short a2offsides.1
        test byte [gmode], 10h
        jne short a2offsides.1
        mov edx, 8
        call AddPenalty
        mov eax, 1
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ChkTwoLinePass                               4DD51  95 PC, medium confidence
; Two-line pass option (gameopts bit 3, not in highlight mode): receiver eax
; was past the red line (pflags2 bit 7 from MarkTwoLinePlayers, or on the
; attacking side) and the pass came from a teammate in his own half
; (lasttouch): returns 1 for a two-line pass whistle; called by a2touchpuck
;-----------------------------------------------------------------------------
; C: src/engine/logic/ChkTwoLinePass.c
%ifdef CBUILD
%include "c/engine/logic/ChkTwoLinePass.inc"
%else
ChkTwoLinePass:
        push dword 10h
        call __CHK
        push ebx
        push edx
        push esi
        test byte [gmode], 10h
        je short .2
.1:
        xor eax, eax
        pop esi
        pop edx
        pop ebx
        ret
.2:
        test byte [gameopts], 8
        je short ChkTwoLinePass.1
        test byte [byte eax+pflags2], 80h
        jne short .3
        test byte [byte eax+pflags], 80h
        sete dl
        mov ebx, edx
        and ebx, 0FFh
        mov edx, dword [pucky]
        cmp word [edx], byte 0
        setg dl
        and edx, 0FFh
        xor edx, ebx
        jne short ChkTwoLinePass.1
.3:
        mov dx, word [byte eax+SCnum]
        mov si, word [lasttouch]
        cmp dx, si
        je short ChkTwoLinePass.1
        cmp dx, byte 6
        setl dl
        mov ebx, edx
        and ebx, 0FFh
        cmp si, byte 6
        setl dl
        and edx, 0FFh
        xor edx, ebx
        jne short ChkTwoLinePass.1
        test byte [byte eax+pflags], 80h
        jne short .4
        cmp word [lty], byte 4Eh
        jl short ChkTwoLinePass.1
        cmp word [byte eax+Ypos+2], byte 0
        jle short .5
        jmp near ChkTwoLinePass.1
.4:
        mov edx, dword [lty-2]
        sar edx, 10h
        cmp edx, byte 0FFFFFFB2h
        jg near ChkTwoLinePass.1
        cmp word [byte eax+Ypos+2], byte 0
        jl near ChkTwoLinePass.1
.5:
        mov eax, 1
        pop esi
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; a2touchpuck                                           4DE14  94G logic94.asm
;-----------------------------------------------------------------------------
; C: src/engine/logic/a2touchpuck.c
%ifdef CBUILD
%include "c/engine/logic/a2touchpuck.inc"
%else
a2touchpuck:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push edi
        mov ebx, eax
        call ChkTwoLinePass
        mov ecx, eax
        test ax, ax
        jne short .1
        test byte [gmode], 1
        jne short .1
        mov ax, word [byte ebx+Xpos+2]
        mov word [ltx], ax
        mov ax, word [byte ebx+Ypos+2]
        mov word [lty], ax
        mov ax, word [byte ebx+SCnum]
        mov word [lasttouch], ax
.1:
        mov eax, dword [byte ebx+06Ch]
        movsx dx, byte [byte ebx+047h]
        cmp dx, word [byte eax+030h]
        je short .4
        mov dl, byte [byte eax+tmflags]
        test dl, 8
        je short .2
        mov dh, dl
        and dh, 0F7h
        mov byte [byte eax+tmflags], dh
        jmp short .3
.2:
        mov dx, word [byte eax+Wallsin]
        mov word [byte eax+034h], dx
        mov dx, word [byte eax+Wallcos]
        mov word [byte eax+Wallsin], dx
.3:
        movsx dx, byte [byte ebx+047h]
        mov word [byte eax+Wallcos], dx
        cmp dx, word [byte eax+034h]
        jne short .5
        mov byte [byte eax+035h], 0FFh
        jmp short .5
.4:
        mov dl, byte [byte eax+pflags]
        test dl, 8
        je short .5
        mov dh, dl
        and dh, 0F7h
        mov byte [byte eax+pflags], dh
.5:
        cmp word [byte ebx+position], byte 0
        je short .6
        and byte [gmode2], 0EFh
.6:
        mov eax, ebx
        call a2offsides
        test ax, ax
        jne short .7
        test cx, cx
        je short .7
        mov edx, 1Dh
        mov eax, ebx
        call AddPenalty
.7:
        mov ah, byte [iflags]
        test ah, 4
        je short .8
        test ah, 1
        je short .8
        cmp word [byte ebx+position], byte 0
        je short .8
        test byte [byte ebx+pflags], 80h
        setne al
        mov edx, eax
        and edx, 0FFh
        test byte [iflags], 2
        setne al
        and eax, 0FFh
        xor eax, edx
        je short .8
        mov eax, dword [icingPlayer-3]
        sar eax, 18h
        shl eax, 7
        add eax, SortCords
        mov edx, 6
        call AddPenalty
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.8:
        xor ch, ch
        mov byte [iflags], ch
        mov al, byte [byte ebx+06Ah]
        mov byte [icingPlayer], al
        mov eax, dword [pucky]
        mov ax, word [eax]
        mov word [regd0], ax
        test byte [byte ebx+pflags], 80h
        je short .9
        mov byte [iflags], 2
        neg word [regd0]
.9:
        cmp word [regd0], byte 0
        jl short .x
        mov ax, word [hmtmap]
        mov di, word [awtmap]
        sub eax, edi
        mov word [regd0], ax
        test byte [byte ebx+pflags], 40h
        je short .10
        neg eax
        mov word [regd0], ax
.10:
        cmp word [regd0], byte 0
        jl short .x
        or byte [iflags], 4
.x:
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; puckflip                                              4DFA4  94G logic94.asm
;-----------------------------------------------------------------------------
; C: src/engine/logic/puckflip.c
%ifdef CBUILD
%include "c/engine/logic/puckflip.inc"
%else
puckflip:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        mov edx, dword [byte eax+Xvel-2]
        sar edx, 10h
        mov ebx, dword [byte eax+Yvel-2]
        sar ebx, 10h
        add edx, ebx
        cmp edx, byte 14h
        jge short .1
        call puckunflip
        pop edx
        pop ebx
        ret
.1:
        mov dx, word [regd0]
        xor dh, dh
        and dl, 1
        xor dx, word [byte eax+facedir]
        xor dh, dh
        and dl, 3
        mov word [byte eax+facedir], dx
        mov word [byte eax+SPAcnt], 0FFFFh
        mov edx, 239h
        call SetSPA
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assrefatdot                                  4DFF7  95 PC, medium confidence
; Asstab 1Eh (StartHL2, puckfaceoff2): while play is stopped (injurystop 0,
; clock running) holds the referee at the faceoff spot fox/C90B4 offset
; +-0Fh, facing 2/6
;-----------------------------------------------------------------------------
; C: src/engine/logic/assrefatdot.c
%ifdef CBUILD
%include "c/engine/logic/assrefatdot.inc"
%else
assrefatdot:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        mov ebx, eax
        test byte [byte eax+pflags], 20h
        jne near .x
        cmp word [injurystop], byte 0
        jne near .x
        cmp word [gameclock], byte 0
        jne short .1
        cmp word [clockticks], byte 0
        je near .x
.1:
        mov dl, byte [byte ebx+pflags]
        test dl, 2
        je short .4
        mov dh, dl
        and dh, 0FDh
        mov byte [byte ebx+pflags], dh
        cmp word [fox], byte 0
        jg short .2
        mov eax, 2
        jmp short .3
.2:
        mov eax, 6
.3:
        mov word [byte ebx+facedir], ax
        mov edx, 0C57h
        mov eax, ebx
        call SetSPA
        and byte [byte ebx+pflags], 0FBh
        and byte [byte ebx+pflags2], 0DFh
.4:
        test byte [gmode2], 1
        jne short .x
        cmp word [fox], byte 0
        jg short .5
        mov eax, dword [fox-2]
        sar eax, 10h
        sub eax, byte 0Fh
        jmp short .6
.5:
        mov eax, dword [fox-2]
        sar eax, 10h
        add eax, byte 0Fh
.6:
        mov word [byte ebx+Xpos+2], ax
        mov ax, word [foy]
        mov word [byte ebx+Ypos+2], ax
        mov word [byte ebx+Yvel], 0
        mov ax, word [byte ebx+Yvel]
        mov word [byte ebx+Xvel], ax
.x:
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assreffollow                                 4E0BD  95 PC, medium confidence
; Asstab 1Fh (StartHL2, Endfaceoff, Goal): picks a spot by puck zone (x
; +-46h/78h/90h, y +-0EDh/0E8h or camy) and skates the referee there; idles
; (doplayeracc 8) when the clock is stopped
;-----------------------------------------------------------------------------
; C: src/engine/logic/assrefwhistle.c (assreffollow)
%ifdef CBUILD
%include "c/engine/logic/assrefwhistle.assreffollow.inc"
%else
assreffollow:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ebx, eax
        mov eax, dword [puckc]
        movsx eax, byte [eax]
        shl eax, 7
        mov ecx, SortCords
        add ecx, eax
        test byte [byte ebx+pflags], 20h
        jne near ass_popx
        cmp word [gameclock], byte 0
        jne short .1
        cmp word [clockticks], byte 0
        jne short .1
        mov edx, 8
        mov eax, ebx
        call doplayeracc
        jmp near ass_popx
.1:
        mov dl, byte [byte ebx+pflags]
        test dl, 2
        je short .2
        mov dh, dl
        and dh, 0FDh
        mov byte [byte ebx+pflags], dh
        mov edx, 0A5Bh
        mov eax, ebx
        call SetSPA
.2:
        mov eax, dword [puckx]
        mov di, word [eax]
        test di, di
        jge short .3
        movsx eax, di
        neg eax
        jmp short .4
.3:
        movsx eax, di
.4:
        cmp eax, byte 32h
        jge near .12
        mov eax, dword [pucky]
        mov dx, word [eax]
        test dx, dx
        jge short .5
        movsx eax, dx
        neg eax
        jmp short .6
.5:
        movsx eax, dx
.6:
        cmp eax, 0ACh
        jle short .12
        mov eax, dword [pucky]
        mov si, word [eax]
        test si, si
        jge short .7
        movsx eax, si
        neg eax
        jmp short .8
.7:
        movsx eax, si
.8:
        cmp eax, 0E8h
        jge short .12
        cmp word [byte ebx+Xpos+2], byte 0
        jle short .9
        mov eax, 46h
        jmp short .10
.9:
        mov eax, 0FFFFFFBAh
.10:
        mov word [byte ebx+temp3], ax
        mov eax, dword [pucky]
        cmp word [eax], byte 0
        jle short .11
        mov eax, 0EDh
        jmp near .23
.11:
        mov eax, 0FFFFFF13h
        jmp near .23
.12:
        mov eax, dword [pucky]
        mov di, word [eax]
        test di, di
        jge short .13
        movsx eax, di
        neg eax
        jmp short .14
.13:
        movsx eax, di
.14:
        cmp eax, byte 62h
        jle short .19
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jl short .15
        test byte [byte ecx+044h], 80h
        setne al
        mov ecx, eax
        and ecx, 0FFh
        mov eax, dword [pucky]
        cmp word [eax], byte 0
        setl al
        and eax, 0FFh
        xor eax, ecx
        je short .19
.15:
        cmp word [byte ebx+Xpos+2], byte 0
        jle short .16
        mov eax, 78h
        jmp short .17
.16:
        mov eax, 0FFFFFF88h
.17:
        mov word [byte ebx+temp3], ax
        mov eax, dword [pucky]
        cmp word [eax], byte 0
        jle short .18
        mov eax, 0E8h
        jmp short .23
.18:
        mov eax, 0FFFFFF18h
        jmp short .23
.19:
        cmp word [byte ebx+Xpos+2], byte 0
        jle short .20
        mov eax, 90h
        jmp short .21
.20:
        mov eax, 0FFFFFF70h
.21:
        mov word [byte ebx+temp3], ax
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
        mov ecx, dword [camy-2]
        sar ecx, 10h
        sub eax, ecx
        test eax, eax
        jge short .22
        neg eax
.22:
        cmp eax, byte 32h
        jle short .24
        mov ax, word [camy]
.23:
        mov word [byte ebx+temp4], ax
.24:
        mov ax, word [byte ebx+temp3]
        mov word [regd0], ax
        mov ax, word [byte ebx+temp4]
        mov word [regd1], ax
        mov edx, EvadePlayers
        jmp near asswingd_skateto
%endif ; C
;-----------------------------------------------------------------------------
; SkateToSpot                                  4E292  95 PC, medium confidence
; Player eax skates to regd0/regd1; within 8 in x and y it snaps there and
; stops (Xvel/Yvel 0), else skateto with SetSPA / vtoa facing; used by the PC
; scripted assignments
;-----------------------------------------------------------------------------
SkateToSpot:
        push dword 2Ch
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 18h
        mov ebx, eax
        mov si, word [regd0]
        sub si, word [byte eax+02h]
        test si, si
        jge short .1
        movsx eax, si
        neg eax
        jmp short .2
.1:
        movsx eax, si
.2:
        mov dword [byte esp+0Ch], eax
        mov cx, word [regd1]
        sub cx, word [byte ebx+Ypos+2]
        test cx, cx
        jge short .3
        movsx eax, cx
        neg eax
        jmp short .4
.3:
        movsx eax, cx
.4:
        mov dword [byte esp+010h], eax
        cmp word [byte esp+0Ch], byte 8
        jge short .5
        cmp word [byte esp+010h], byte 8
        jge short .5
        mov word [byte ebx+Yvel], 0
        mov ax, word [byte ebx+Yvel]
        mov word [byte ebx+Xvel], ax
        mov ax, word [regd0]
        mov word [byte ebx+Xpos+2], ax
        mov ax, word [regd1]
        mov word [byte ebx+Ypos+2], ax
        jmp near .x
.5:
        cmp word [byte ebx+Xpos+2], byte 0
        jge short .6
        mov edi, dword [ebx]
        sar edi, 10h
        neg edi
        jmp short .7
.6:
        mov edi, dword [ebx]
        sar edi, 10h
.7:
        cmp word [byte ebx+Ypos+2], byte 0
        jge short .8
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
        neg eax
        jmp short .9
.8:
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
.9:
        mov dword [byte esp+04h], eax
        mov eax, dword [byte esp+04h]
        mov dword [byte esp+014h], eax
        cmp word [regd1], byte 0
        jge short .10
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .11
.10:
        mov eax, dword [regd1-2]
        sar eax, 10h
.11:
        cmp di, byte 1Eh
        jg near .20
        cmp word [byte esp+014h], 0F2h
        jl near .20
        cmp ax, 0F2h
        jge near .20
        cmp word [byte ebx+Ypos+2], byte 0
        jge short .12
        mov eax, 0FFFFFF04h
        jmp short .13
.12:
        mov eax, 0FCh
.13:
        mov word [regd1], ax
        cmp word [regd0], byte 0
        jge short .14
        mov eax, 0FFFFFFD8h
        jmp short .15
.14:
        mov eax, 28h
.15:
        mov word [regd0], ax
        cmp word [byte ebx+Yvel], byte 0
        setg al
        and eax, 0FFh
        cmp word [byte ebx+Ypos+2], byte 0
        setg cl
        movzx edi, cl
        xor eax, edi
        je short .16
        mov word [byte ebx+Yvel], 0
.16:
        mov si, word [regd0]
        sub si, word [byte ebx+Xpos+2]
        test si, si
        jge short .17
        movsx eax, si
        neg eax
        jmp short .18
.17:
        movsx eax, si
.18:
        mov dword [byte esp+0Ch], eax
        mov cx, word [regd1]
        sub cx, word [byte ebx+Ypos+2]
        test cx, cx
        jge short .19
        movsx eax, cx
        neg eax
        jmp near .31
.19:
        movsx eax, cx
        jmp near .31
.20:
        cmp di, byte 10h
        jl near .32
        cmp di, byte 1Eh
        jg near .32
        cmp word [byte esp+014h], 0E8h
        jl near .32
        mov edi, dword [byte ebx+Ypos]
        sar edi, 10h
        mov dword [esp], edi
        mov edi, dword [regd1-2]
        sar edi, 10h
        xor edi, dword [esp]
        test edi, edi
        jl near .32
        cmp ax, 0E8h
        jge near .32
        cmp ax, 0E0h
        jle near .32
        cmp word [regd0], byte 0
        jge short .21
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .22
.21:
        mov eax, dword [regd0-2]
        sar eax, 10h
.22:
        cmp eax, byte 14h
        jge near .32
        cmp word [byte ebx+Ypos+2], byte 0
        jge short .23
        mov eax, 0FFFFFF24h
        jmp short .24
.23:
        mov eax, 0DCh
.24:
        mov word [regd1], ax
        cmp word [byte ebx+Xpos+2], byte 0
        jge short .25
        mov eax, 0FFFFFFD8h
        jmp short .26
.25:
        mov eax, 28h
.26:
        mov word [regd0], ax
        cmp word [byte ebx+Xvel], byte 0
        setg al
        movzx edi, al
        cmp word [byte ebx+Xpos+2], byte 0
        setg al
        and eax, 0FFh
        xor eax, edi
        je short .27
        mov word [byte ebx+Xvel], 0
.27:
        mov si, word [regd0]
        sub si, word [byte ebx+Xpos+2]
        test si, si
        jge short .28
        movsx eax, si
        neg eax
        jmp short .29
.28:
        movsx eax, si
.29:
        mov dword [byte esp+0Ch], eax
        mov cx, word [regd1]
        sub cx, word [byte ebx+Ypos+2]
        test cx, cx
        jge short .30
        movsx eax, cx
        neg eax
        jmp short .31
.30:
        movsx eax, cx
.31:
        mov dword [byte esp+010h], eax
.32:
        mov eax, ebx
        call skateto
        cmp word [byte esp+0Ch], byte 19h
        jge near .38
        cmp word [byte esp+010h], byte 19h
        jge near .38
        cmp word [byte ebx+Xvel], byte 0
        jge short .33
        mov eax, dword [byte ebx+Xvel-2]
        sar eax, 10h
        neg eax
        jmp short .34
.33:
        mov eax, dword [byte ebx+Xvel-2]
        sar eax, 10h
.34:
        cmp eax, 9C4h
        jle short .35
        mov edi, dword [byte ebx+Xvel-2]
        sar edi, 10h
        mov eax, edi
        mov edx, edi
        sar edx, 1Fh
        shl edx, 2
        LD sbb, eax, edx
        sar eax, 2
        sub edi, eax
        mov word [byte ebx+Xvel], di
.35:
        cmp word [byte ebx+Yvel], byte 0
        jge short .36
        mov eax, dword [byte ebx+Yvel-2]
        sar eax, 10h
        neg eax
        jmp short .37
.36:
        mov eax, dword [byte ebx+Yvel-2]
        sar eax, 10h
.37:
        cmp eax, 9C4h
        jle short .38
        mov edi, dword [byte ebx+Yvel-2]
        sar edi, 10h
        mov eax, edi
        mov edx, edi
        sar edx, 1Fh
        shl edx, 2
        LD sbb, eax, edx
        sar eax, 2
        sub edi, eax
        mov word [byte ebx+Yvel], di
.38:
        cmp word [byte ebx+SCnum], byte 10h
        jne short .39
        mov edi, 0A5Bh
        mov word [byte esp+08h], 0A73h
        jmp short .41
.39:
        cmp word [byte ebx+position], byte 0
        jne short .40
        mov edi, 99h
        mov word [byte esp+08h], 1F1h
        jmp short .41
.40:
        mov edi, 289h
        mov word [byte esp+08h], 2E9h
.41:
        cmp word [byte esp+0Ch], byte 8
        jl short .49
        cmp word [byte ebx+Xvel], byte 0
        jge short .42
        mov eax, dword [byte ebx+Xvel-2]
        sar eax, 10h
        neg eax
        jmp short .43
.42:
        mov eax, dword [byte ebx+Xvel-2]
        sar eax, 10h
.43:
        cmp eax, 640h
        jge short .49
        cmp word [byte ebx+Xvel], byte 0
        jne short .44
        cmp di, word [byte ebx+SPA]
        jne short .44
        mov edx, dword [byte esp+06h]
        sar edx, 10h
        jmp short .45
.44:
        cmp word [byte ebx+SPA], byte 0
        jne short .46
        movsx edx, di
.45:
        mov eax, ebx
        call SetSPA
.46:
        test si, si
        jle short .47
        mov eax, 640h
        jmp short .48
.47:
        mov eax, 0FFFFF9C0h
.48:
        mov word [byte ebx+Xvel], ax
.49:
        cmp word [byte esp+010h], byte 8
        jl short .57
        cmp word [byte ebx+Yvel], byte 0
        jge short .50
        mov eax, dword [byte ebx+Yvel-2]
        sar eax, 10h
        neg eax
        jmp short .51
.50:
        mov eax, dword [byte ebx+Yvel-2]
        sar eax, 10h
.51:
        cmp eax, 640h
        jge short .57
        cmp word [byte ebx+Xvel], byte 0
        jne short .52
        cmp di, word [byte ebx+SPA]
        jne short .52
        mov edx, dword [byte esp+06h]
        sar edx, 10h
        jmp short .53
.52:
        cmp word [byte ebx+SPA], byte 0
        jne short .54
        movsx edx, di
.53:
        mov eax, ebx
        call SetSPA
.54:
        test cx, cx
        jle short .55
        mov eax, 640h
        jmp short .56
.55:
        mov eax, 0FFFFF9C0h
.56:
        mov word [byte ebx+Yvel], ax
.57:
        mov ax, word [regd1]
        sub ax, word [byte ebx+Ypos+2]
        movsx edx, ax
        mov ax, word [regd0]
        sub ax, word [byte ebx+Xpos+2]
        cwde
        call vtoa
        sub ax, word [byte ebx+facedir]
        xor ah, ah
        and al, 7
        movsx edx, ax
        inc edx
        and edx, byte 7
        cmp edx, byte 2
        jle short .x
        cmp byte [byte ebx+029h], 0
        jne short .x
        cmp ax, 5
        jge short .58
        mov eax, 1
        jmp short .59
.58:
        mov eax, 0FFFFFFFFh
.59:
        mov edx, dword [byte ebx+facedir-2]
        sar edx, 10h
        add eax, edx
        and eax, byte 7
        mov word [byte ebx+facedir], ax
.x:
        add esp, byte 18h
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; CrowdOnStoppage                                 4E71A  95 PC, low confidence
; On a whistle (ovltimer -1, not replay) picks crowd/music reactions by
; RefPen and clock: PlayCrowdSample 2 late in the period, 5 at period end,
; team music when musicon and gameopts+1 bit 0
;-----------------------------------------------------------------------------
; C: src/engine/logic/CrowdOnStoppage.c
%ifdef CBUILD
%include "c/engine/logic/CrowdOnStoppage.inc"
%else
CrowdOnStoppage:
        push dword 0Ch
        call __CHK
        push ecx
        push edx
        test byte [gmode], 10h
        jne near .12
        mov eax, dword [ovltimer-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        jne near .12
        mov dx, word [RefPen]
        cmp dx, byte 1Dh
        je short .1
        cmp dx, byte 1Eh
        je short .1
        cmp dx, byte 3
        je short .1
        cmp dx, byte 4
        je short .1
        cmp dx, byte 8
        je short .1
        cmp dx, byte 6
        je short .1
        mov eax, 1
        jmp short .2
.1:
        xor eax, eax
.2:
        test eax, eax
        jne near .12
        mov edx, dword [dword_E9AB6]
        sar edx, 11h
        mov eax, dword [gameclock-2]
        sar eax, 10h
        cmp edx, eax
        jle short .4
        cmp word [gameclock], byte 3Ch
        jl short .4
        mov dl, byte [sflags3]
        test dl, 80h
        je short .4
        mov ch, dl
        and ch, 7Fh
        mov byte [sflags3], ch
        mov eax, 2
.3:
        call PlayCrowdSample
        xor eax, eax
        pop edx
        pop ecx
        ret
.4:
        cmp word [gsp], byte 2
        jne short .5
        mov ax, word [gameclock]
        cmp ax, word [periodendtime]
        jg short .5
        mov word [periodendtime], 0FFFFh
        mov eax, 5
        jmp short CrowdOnStoppage.3
.5:
        test byte [gameopts+1], 1
        je short .7
        cmp byte [musicon], 0
        je short .7
        mov eax, dword [awtmap-2]
        sar eax, 10h
        mov edx, dword [hmtmap-2]
        sar edx, 10h
        sub eax, edx
        mov edx, eax
        je short .7
        mov eax, 4
        call randomd0
        test ax, ax
        jne short .7
        test edx, edx
        jle short .6
        mov eax, 4
        jmp short CrowdOnStoppage.3
.6:
        mov eax, 1
        jmp short CrowdOnStoppage.3
.7:
        mov eax, 8
        call randomd0
        movsx edx, ax
        cmp dword [demoflag], byte 0
        jne short .8
        test edx, edx
        jne short .8
        test byte [gameopts], 80h
        je near .12
        test byte [sounddev], 2Ah
        je near .12
        cmp word [crowdlevel], 2BCh
        jg near .12
        xor eax, eax
        call LoadTeamPPV
        mov eax, dword [ovlseq-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        je short .12
        call CloseTextOverlay
        mov eax, 1
        pop edx
        pop ecx
        ret
.8:
        cmp dword [demoflag], byte 0
        jne short .9
        cmp edx, byte 1
        jne short .9
        mov eax, 2
        call LoadTeamPPV
        mov eax, dword [ovlseq-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        je short .12
        mov eax, 9
        call PlayCrowdSample
        call CloseTextOverlay
        mov eax, edx
        pop edx
        pop ecx
        ret
.9:
        cmp edx, byte 5
        jge short .10
        lea eax, [byte edx+04h]
        jmp short .11
.10:
        jne short .12
        mov eax, 0Bh
.11:
        call PlayCrowdSample
.12:
        xor eax, eax
        pop edx
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assrefwhistle                                4E8EF  95 PC, medium confidence
; Asstab 24h: on a stoppage (clock 0, or period-3 tie broken) sets RefStep
; -1, ovltimer 258h, puck to assignment 1Bh and the referee to 1Eh
;-----------------------------------------------------------------------------
; C: src/engine/logic/assrefwhistle.c
%ifdef CBUILD
%include "c/engine/logic/assrefwhistle.inc"
%else
assrefwhistle:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ebx, eax
        test byte [byte eax+pflags], 20h
        jne near ass_popx
        test byte [byte ebx+pflags], 2
        je near ass_popx.2
        cmp word [injurystop], byte 0
        jne short .2
        cmp word [gameclock], byte 0
        jne short .1
        cmp word [clockticks], byte 0
        je short .2
.1:
        cmp word [gsp], byte 3
        jne short ass_popx.1
        mov ax, word [hmscore]
        cmp ax, word [awscore]
        je short ass_popx.1
.2:
        mov word [RefStep], 0FFFFh
        cmp word [ovltimer], 100h
        jne short .3
        mov word [ovltimer], 258h
.3:
        mov edx, 1Bh
        mov eax, puckstruct
        call assreplace
        mov edx, 1Eh
ass_replace_popx:
        mov eax, ebx
        call assreplace
ass_popx:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        mov word [RefStep], 1
        and byte [byte ebx+pflags], 0FDh
        call PenShotAssign
        mov word [byte ebx+temp2], 8
        mov word [byte ebx+temp4], 0
        mov word [byte ebx+temp3], 0A0h
        mov word [byte ebx+temp1], 0
        or byte [byte ebx+pflags2], 20h
        mov word [byte ebx+Wallcos], 0
        mov word [byte ebx+Wallsin], 0
        mov edx, 0A5Bh
        mov eax, ebx
        call SetSPA
        call CrowdOnStoppage
        test eax, eax
        jne short ass_popx
        cmp word [ovltimer], 100h
        jne short .2
        mov word [ovltimer], 258h
.2:
        mov ax, word [byte ebx+Ypos+2]
        mov dx, word [byte ebx+temp4]
        sub eax, edx
        mov word [regd0], ax
        test ax, ax
        jge short .3
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .4
.3:
        mov eax, dword [regd0-2]
        sar eax, 10h
.4:
        cmp eax, byte 6
        jg near ass_skate_temp34
        mov ax, word [byte ebx+Xpos+2]
        mov si, word [byte ebx+temp3]
        sub eax, esi
        mov word [regd0], ax
        mov eax, dword [regd0-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFF6h
        jl near ass_skate_temp34
        mov di, word [byte ebx+temp1]
        dec edi
        mov word [byte ebx+temp1], di
        test di, di
        jge near ass_popx
        mov edx, edi
        add edx, byte 8
        mov word [byte ebx+temp1], dx
        mov edx, 0A5Bh
        mov eax, ebx
        call SetSPA
        mov dword [regd2], 2
        mov ax, word [regd2]
        mov cx, word [byte ebx+facedir]
        cmp ax, cx
        je short .7
        sub eax, ecx
        xor ah, ah
        and al, 7
        mov word [regd2], ax
        cmp ax, 5
        jge short .5
        mov eax, 1
        jmp short .6
.5:
        mov eax, 0FFFFFFFFh
.6:
        mov edx, dword [byte ebx+facedir-2]
        sar edx, 10h
        add eax, edx
        and eax, byte 7
        mov word [byte ebx+facedir], ax
.7:
        mov word [byte ebx+Yvel], 0
        mov word [byte ebx+Xvel], 0
        mov ax, word [regd2]
        cmp ax, word [byte ebx+facedir]
        jne near ass_popx
        or byte [byte ebx+pflags], 20h
        mov edx, 0C1Bh
        mov eax, ebx
        call SetSPA
        mov edx, 22h
        jmp near ass_replace_popx
%endif ; C
;-----------------------------------------------------------------------------
; ass_skate_temp34                                                4EAE2  95 PC
;-----------------------------------------------------------------------------
ass_skate_temp34:
        mov ax, word [byte ebx+temp3]
        mov word [regd0], ax
        mov ax, word [byte ebx+temp4]
        mov word [regd1], ax
        xor edx, edx
        mov eax, ebx
        call SkateToSpot
        jmp near ass_popx
;-----------------------------------------------------------------------------
; assrefsignal                                 4EB04  95 PC, medium confidence
; Asstab 20h: skates to x 0A0h,y 0 (the timekeeper side), plays 0A5Bh; when
; RefPen is 7 (goal) posts PostGoalEvent with scorer/assists and period time;
; then assreplace 21h
;-----------------------------------------------------------------------------
; C: src/engine/logic/assgoalie.c (assrefsignal)
%ifdef CBUILD
%include "c/engine/logic/assgoalie.assrefsignal.inc"
%else
assrefsignal:
        push dword 2Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, byte 4
        mov esi, eax
        test byte [byte eax+pflags], 20h
        jne near .17
        mov dl, byte [byte esi+pflags]
        test dl, 2
        je near .10
        mov dh, dl
        and dh, 0FDh
        mov byte [byte esi+pflags], dh
        mov eax, dword [RefPen-2]
        sar eax, 10h
        cmp word [nosplit eax*2+refsigdir], byte 0
        jge near .9
        cmp word [RefPen], byte 7
        jne near .8
        mov ebx, dword [pucky]
        cmp word [ebx], byte 0
        setl al
        movzx edi, al
        test byte [gmode], 2
        setne al
        and eax, 0FFh
        xor edi, eax
        test edi, edi
        jle short .1
        mov ecx, awtmstruct
        jmp short .2
.1:
        mov ecx, hmtmstruct
.2:
        mov ebx, dword [PerTimeTotal-2]
        sar ebx, 10h
        mov eax, dword [gameclock-2]
        sar eax, 10h
        sub ebx, eax
        cmp word [gameclock], byte 3Ch
        jge short .3
        cmp word [clockticks], byte 0
        je short .3
        dec ebx
.3:
        mov dword [byte ebp-04h], 3Ch
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv dword [byte ebp-04h]
        push edx
        mov dword [byte ebp-04h], 3Ch
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv dword [byte ebp-04h]
        push eax
        mov eax, dword [word_E9AB0-2]
        sar eax, 10h
        push eax
        cmp word [byte ecx+034h], byte 0
        jge short .4
        mov eax, 0FFFFFFFFh
        jmp short .5
.4:
        mov eax, dword [byte ecx+032h]
        sar eax, 10h
.5:
        cmp word [byte ecx+032h], byte 0
        jge short .6
        mov ebx, 0FFFFFFFFh
        jmp short .7
.6:
        mov ebx, dword [byte ecx+030h]
        sar ebx, 10h
.7:
        mov edx, dword [byte ecx+02Eh]
        sar edx, 10h
        mov ecx, eax
        mov eax, edi
        call PostGoalEvent
.8:
        mov edx, 21h
        mov eax, esi
        call assreplace
        jmp near .17
.9:
        mov word [byte esi+temp2], 8
        mov word [byte esi+temp4], 0
        mov word [byte esi+temp3], 0A0h
        mov word [byte esi+temp1], 0
        or byte [byte esi+pflags2], 20h
        mov word [byte esi+Wallcos], 0
        mov word [byte esi+Wallsin], 0
.10:
        mov ax, word [byte esi+Ypos+2]
        mov bx, word [byte esi+temp4]
        sub eax, ebx
        mov word [regd0], ax
        test ax, ax
        jge short .11
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .12
.11:
        mov eax, dword [regd0-2]
        sar eax, 10h
.12:
        cmp eax, byte 0Ch
        jg near .16
        mov ax, word [byte esi+Xpos+2]
        mov di, word [byte esi+temp3]
        sub eax, edi
        mov word [regd0], ax
        mov eax, dword [regd0-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFECh
        jl near .16
        mov ax, word [byte esi+temp1]
        dec eax
        mov word [byte esi+temp1], ax
        test ax, ax
        jge near .17
        mov ebx, eax
        add ebx, byte 8
        mov word [byte esi+temp1], bx
        mov edx, 0A5Bh
        mov eax, esi
        call SetSPA
        mov eax, dword [RefPen-2]
        sar eax, 10h
        mov ax, word [nosplit eax*2+refsigdir]
        mov word [regd2], ax
        mov cx, word [byte esi+facedir]
        cmp ax, cx
        je short .15
        mov ebx, eax
        sub ebx, ecx
        xor bh, bh
        and bl, 7
        mov word [regd2], bx
        cmp bx, byte 5
        jge short .13
        mov ebx, 1
        jmp short .14
.13:
        mov ebx, 0FFFFFFFFh
.14:
        mov eax, dword [byte esi+facedir-2]
        sar eax, 10h
        add eax, ebx
        and eax, byte 7
        mov word [byte esi+facedir], ax
.15:
        mov word [byte esi+Yvel], 0
        mov word [byte esi+Xvel], 0
        mov ax, word [regd2]
        cmp ax, word [byte esi+facedir]
        jne short .17
        or byte [byte esi+pflags], 20h
        mov eax, dword [RefPen-2]
        sar eax, 10h
        mov edx, dword [nosplit eax*2+refsigspa_m2]
        sar edx, 10h
        mov eax, esi
        call SetSPA
        jmp near assrefsignal.8
.16:
        mov ax, word [byte esi+temp3]
        mov word [regd0], ax
        mov ax, word [byte esi+temp4]
        mov word [regd1], ax
        xor edx, edx
        mov eax, esi
        call SkateToSpot
.17:
        mov esp, ebp
        jmp near assgoalie_popebp
%endif ; C
;-----------------------------------------------------------------------------
; assrefgoalpa                                 4ED7C  95 PC, medium confidence
; Asstab 21h (assrefsignal, EndPenaltyShot, assrefpenshot): once ovltimer >=
; 0ECh and goalevent == 1, calls PaGoal with the scorer/assist jerseys
; (goalevent_b1..E9AD7) and team abbrev, then clears E9AD3
;-----------------------------------------------------------------------------
assrefgoalpa:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 8
        mov ebx, eax
        test byte [byte eax+pflags], 20h
        jne near .64
        mov dx, word [ovlseq]
        cmp dx, byte 2
        je near .5
        test dx, dx
        je near .5
        mov si, word [ovltimer]
        test si, si
        jl near .5
        cmp si, 100h
        jge near .5
        mov edx, 0A5Bh
        mov eax, ebx
        call SetSPA
        cmp word [ovltimer], 0ECh
        jl near .64
        cmp byte [goalevent], 1
        jne near .64
        xor ebx, ebx
        mov bl, byte [goalevent_b1]
        xor eax, eax
        mov al, byte [goalevent_b2]
        mov word [esp], ax
        xor edx, edx
        mov dl, byte [goalevent_b3]
        movzx di, byte [goalevent_b4]
        xor eax, eax
        cmp dx, 0FFh
        je short .1
        mov eax, 1
.1:
        cmp di, 0FFh
        je short .2
        inc eax
.2:
        test bx, bx
        je short .3
        mov cx, word [VisTeam]
        jmp short .4
.3:
        mov cx, word [HomeTeam]
.4:
        mov word [byte esp+04h], cx
        mov cx, word [joysampling]
        mov word [joysampling_save], cx
        xor ecx, ecx
        mov dword [joysampling], ecx
        movsx ecx, bx
        mov esi, ecx
        shl esi, 4
        add esi, ecx
        shl esi, 4
        add esi, ecx
        shl esi, 2
        movsx ecx, di
        mov ebx, ecx
        shl ebx, 2
        add ebx, ecx
        shl ebx, 3
        sub ebx, ecx
        mov bl, byte [dword esi+ebx+hmrosterjersey]
        and ebx, 0FFh
        push ebx
        movsx ecx, dx
        mov ebx, ecx
        shl ebx, 2
        add ebx, ecx
        shl ebx, 3
        sub ebx, ecx
        movzx edi, byte [dword esi+ebx+hmrosterjersey]
        mov ecx, dword [byte esp+02h]
        sar ecx, 10h
        mov ebx, ecx
        shl ebx, 2
        add ebx, ecx
        shl ebx, 3
        sub ebx, ecx
        add esi, ebx
        xor ebx, ebx
        mov bl, byte [dword esi+hmrosterjersey]
        movsx edx, ax
        mov eax, dword [byte esp+06h]
        sar eax, 10h
        mov eax, dword [nosplit eax*4+teamabbrevs]
        mov ecx, edi
        call PaGoal
        mov eax, dword [joysampling_save-2]
        sar eax, 10h
        mov dword [joysampling], eax
        mov byte [goalevent], 0FFh
        cmp word [gsp], byte 3
        jl near .64
        mov word [ovltimer], 38h
        jmp near .64
.5:
        cmp byte [PenBuf], 0
        je short .6
        mov edx, 0A5Bh
        mov eax, ebx
        call SetSPA
        mov word [RefStep], 0FFFFh
        jmp near .64
.6:
        mov ecx, dword [puckx]
        mov ax, word [ecx]
        test ax, ax
        jge short .7
        cwde
        neg eax
        jmp short .8
.7:
        cwde
.8:
        cmp eax, 0A0h
        jg short .11
        mov ecx, dword [pucky]
        mov dx, word [ecx]
        test dx, dx
        jge short .9
        movsx eax, dx
        neg eax
        jmp short .10
.9:
        movsx eax, dx
.10:
        cmp eax, 112h
        jle short .12
.11:
        mov edx, 24h
        jmp near .24
.12:
        test byte [byte ebx+pflags], 2
        je near .21
        cmp word [injurystop], byte 0
        jne short .14
        cmp word [gameclock], byte 0
        jne short .13
        cmp word [clockticks], byte 0
        je short .14
.13:
        cmp word [gsp], byte 3
        jne short .16
        mov ax, word [hmscore]
        cmp ax, word [awscore]
        je short .16
.14:
        mov word [RefStep], 0FFFFh
        cmp word [ovltimer], 100h
        jne short .15
        mov word [ovltimer], 258h
.15:
        mov edx, 1Bh
        mov eax, puckstruct
        call assreplace
        mov edx, 1Eh
        jmp near .24
.16:
        mov word [RefStep], 1
        and byte [byte ebx+pflags], 0FDh
        call PenShotAssign
        mov word [byte ebx+temp2], 8
        mov word [byte ebx+temp1], 0
        mov word [byte ebx+temp5], 0
        or byte [byte ebx+pflags2], 20h
        mov word [byte ebx+Wallcos], 0
        mov word [byte ebx+Wallsin], 0
        mov edx, 0A5Bh
        mov eax, ebx
        call SetSPA
        mov si, word [RefPen]
        cmp si, byte 4
        jne short .17
        call QueueGoalieNote
        test ax, ax
        jne near .20
        mov eax, dword [penaltysc-2]
        sar eax, 10h
        shl eax, 7
        cmp byte [dword eax+byte_DF87F], 0
        je short .19
        cmp word [dword_E9A9E], byte 0
        jne short .19
        xor dh, dh
        mov byte [dword eax+byte_DF87F], dh
        mov eax, 8
        call LoadTeamPPV
        mov eax, dword [ovlseq-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        je short .20
        mov word [dword_E9A9E], 1
        call CloseTextOverlay
        jmp near .64
.17:
        cmp si, byte 7
        jne short .19
        test byte [gmode], 10h
        je short .18
        mov word [exitgame], 1
        jmp near .64
.18:
        call ChkScorerMilestone
        jmp short .20
.19:
        call CrowdOnStoppage
        test eax, eax
        jne near .64
.20:
        cmp word [ovltimer], 100h
        jne short .21
        mov word [ovltimer], 258h
.21:
        cmp dword [deferpending], byte 0
        jne near .64
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jl short .22
        mov byte [eax], 0FFh
        mov edx, 1Ah
        mov eax, puckstruct
        call assreplace
.22:
        cmp word [byte ebx+temp5], 258h
        jle short .25
        mov eax, dword [puckc]
        mov byte [eax], 10h
        mov eax, dword [puckvx]
        mov word [eax], 0
        mov eax, dword [puckvy]
        mov word [eax], 0
        mov eax, dword [puckvz]
        mov word [eax], 0
        mov eax, dword [puckz]
        mov word [eax], 64h
.23:
        mov edx, 22h
.24:
        mov eax, ebx
        call assreplace
        jmp near .64
.25:
        mov ecx, dword [puckx]
        mov ax, word [ecx]
        test ax, ax
        jge short .26
        cwde
        neg eax
        jmp short .27
.26:
        cwde
.27:
        cmp eax, byte 6
        jne near .34
        mov ecx, dword [pucky]
        mov dx, word [ecx]
        test dx, dx
        jge short .28
        movsx eax, dx
        neg eax
        jmp short .29
.28:
        movsx eax, dx
.29:
        cmp eax, 0F0h
        jne short .34
        mov eax, dword [puckx]
        mov ax, word [eax]
        mov word [byte ebx+temp3], ax
        mov eax, dword [pucky]
        cmp word [eax], byte 0
        jge short .30
        mov eax, 0FFFFFF1Dh
        jmp short .31
.30:
        mov eax, 0E3h
.31:
        mov word [byte ebx+temp4], ax
        mov ax, word [byte ebx+Xpos+2]
        mov di, word [byte ebx+temp3]
        sub eax, edi
        mov word [regd0], ax
        mov eax, dword [pucky]
        cmp word [eax], byte 0
        jge short .32
        mov eax, 0FFFFFF12h
        jmp short .33
.32:
        mov eax, 0EEh
.33:
        mov edx, dword [byte ebx+Ypos]
        sar edx, 10h
        sub edx, eax
        jmp near .45
.34:
        mov edx, dword [puckvx]
        movsx edx, word [edx]
        sar edx, 7
        mov eax, dword [puckx]
        movsx eax, word [eax]
        add eax, edx
        mov word [byte ebx+temp3], ax
        mov edx, dword [puckvy]
        movsx edx, word [edx]
        sar edx, 7
        mov eax, dword [pucky]
        movsx eax, word [eax]
        add eax, edx
        mov word [byte ebx+temp4], ax
        mov edx, dword [puckvy]
        movsx edx, word [edx]
        mov eax, dword [puckvx]
        movsx eax, word [eax]
        call vtoa
        mov word [regd0], ax
        mov edx, dword [pucky]
        mov ax, word [byte ebx+Ypos+2]
        sub ax, word [edx]
        movsx edx, ax
        mov ecx, dword [puckx]
        mov ax, word [byte ebx+Xpos+2]
        sub ax, word [ecx]
        cwde
        call vtoa
        mov word [regd1], ax
        mov di, word [regd0]
        cmp di, byte 7
        jg short .35
        cmp ax, 7
        jg short .35
        cmp ax, di
        jne short .36
.35:
        mov eax, dword [puckx]
        mov ax, word [eax]
        mov word [byte ebx+temp3], ax
        mov eax, dword [pucky]
        mov ax, word [eax]
        mov word [byte ebx+temp4], ax
.36:
        mov edi, dword [byte ebx+temp4-2]
        sar edi, 10h
        mov eax, dword [pucky]
        movsx eax, word [eax]
        lea ecx, [dword eax-0E8h]
        lea edx, [dword edi-0E8h]
        xor edx, ecx
        test edx, edx
        jge near .40
        mov ecx, 0E8h
        sub ecx, eax
        mov ebp, dword [byte ebx+temp3-2]
        sar ebp, 10h
        mov edx, dword [puckx]
        movsx esi, word [edx]
        sub ebp, esi
        imul ecx, ebp
        mov esi, edi
        sub esi, eax
        je short .37
        mov eax, ecx
        mov edx, ecx
        sar edx, 1Fh
        idiv esi
        mov ecx, eax
.37:
        mov eax, dword [puckx]
        mov ax, word [eax]
        add eax, ecx
        mov word [regd0], ax
        test ax, ax
        jge short .38
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .39
.38:
        mov eax, dword [regd0-2]
        sar eax, 10h
.39:
        cmp eax, byte 19h
        jge short .40
        mov eax, dword [puckx]
        mov ax, word [eax]
        mov word [byte ebx+temp3], ax
        mov eax, dword [pucky]
        mov ax, word [eax]
        mov word [byte ebx+temp4], ax
.40:
        mov edx, dword [byte ebx+temp4-2]
        sar edx, 10h
        mov eax, dword [pucky]
        movsx eax, word [eax]
        lea ecx, [dword eax+0E8h]
        lea esi, [dword edx+0E8h]
        xor ecx, esi
        test ecx, ecx
        jge near .44
        mov ecx, 0FFFFFF18h
        sub ecx, eax
        mov edi, dword [byte ebx+temp3-2]
        sar edi, 10h
        mov esi, dword [puckx]
        movsx esi, word [esi]
        sub edi, esi
        imul ecx, edi
        mov esi, edx
        sub esi, eax
        je short .41
        mov eax, ecx
        mov edx, ecx
        sar edx, 1Fh
        idiv esi
        mov ecx, eax
.41:
        mov eax, dword [puckx]
        mov ax, word [eax]
        add ecx, eax
        mov word [regd0], cx
        test cx, cx
        jge short .42
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .43
.42:
        mov eax, dword [regd0-2]
        sar eax, 10h
.43:
        cmp eax, byte 19h
        jge short .44
        mov eax, dword [puckx]
        mov ax, word [eax]
        mov word [byte ebx+temp3], ax
        mov eax, dword [pucky]
        mov ax, word [eax]
        mov word [byte ebx+temp4], ax
.44:
        mov eax, dword [puckx]
        mov dx, word [byte ebx+Xpos+2]
        mov di, word [eax]
        mov eax, edx
        sub eax, edi
        mov word [regd0], ax
        mov eax, dword [pucky]
        mov dx, word [byte ebx+Ypos+2]
        mov cx, word [eax]
        sub edx, ecx
.45:
        mov word [regd1], dx
        cmp word [regd0], byte 0
        jge short .46
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .47
.46:
        mov eax, dword [regd0-2]
        sar eax, 10h
.47:
        cmp eax, byte 0Ch
        jg near .63
        cmp word [regd1], byte 0
        jge short .48
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .49
.48:
        mov eax, dword [regd1-2]
        sar eax, 10h
.49:
        cmp eax, byte 0Ch
        jg near .63
        mov ecx, dword [puckx]
        mov di, word [ecx]
        test di, di
        jge short .50
        movsx eax, di
        neg eax
        jmp short .51
.50:
        movsx eax, di
.51:
        cmp eax, byte 6
        jne short .56
        mov ecx, dword [pucky]
        mov ax, word [ecx]
        test ax, ax
        jge short .52
        cwde
        neg eax
        jmp short .53
.52:
        cwde
.53:
        cmp eax, 0F0h
        jne short .56
        cmp word [byte ebx+Ypos+2], byte 0
        jge short .54
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
        neg eax
        jmp short .55
.54:
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
.55:
        cmp eax, 0E8h
        jg short .57
.56:
        mov eax, 1
        jmp short .58
.57:
        xor eax, eax
.58:
        test eax, eax
        je near .63
        mov cx, word [byte ebx+temp1]
        dec ecx
        mov word [byte ebx+temp1], cx
        test cx, cx
        jge near .64
        mov edi, ecx
        add edi, byte 8
        mov word [byte ebx+temp1], di
        mov edx, 0A5Bh
        mov eax, ebx
        call SetSPA
        mov eax, dword [pucky]
        mov ax, word [eax]
        sub ax, word [byte ebx+Ypos+2]
        movsx edx, ax
        mov eax, dword [puckx]
        mov ax, word [eax]
        sub ax, word [byte ebx+Xpos+2]
        cwde
        call vtoa
        mov word [regd2], ax
        cmp ax, 8
        jge short .60
        mov edx, dword [byte ebx+facedir-2]
        sar edx, 10h
        movsx ecx, ax
        sub ecx, edx
        inc ecx
        and ecx, byte 7
        cmp ecx, byte 2
        jle short .60
        sub ax, word [byte ebx+facedir]
        xor ah, ah
        and al, 7
        mov word [regd2], ax
        cmp ax, 5
        jge short .59
        mov eax, 1
        jmp short .62
.59:
        mov eax, 0FFFFFFFFh
        jmp short .62
.60:
        mov word [byte ebx+Yvel], 0
        mov ax, word [byte ebx+Yvel]
        mov word [byte ebx+Xvel], ax
        mov eax, dword [puckc]
        mov byte [eax], 10h
        mov eax, dword [puckvx]
        mov word [eax], 0
        mov eax, dword [puckvy]
        mov word [eax], 0
        mov eax, dword [puckvz]
        mov word [eax], 0
        mov eax, dword [puckz]
        mov word [eax], 0FF9Ch
        mov si, word [regd2]
        cmp si, byte 8
        jge short .61
        mov word [byte ebx+facedir], si
.61:
        or byte [byte ebx+pflags], 20h
        mov edx, 0C03h
        mov eax, ebx
        call SetSPA
        jmp near assrefgoalpa.23
.62:
        mov edx, dword [byte ebx+facedir-2]
        sar edx, 10h
        add eax, edx
        and eax, byte 7
        mov word [byte ebx+facedir], ax
.63:
        inc word [byte ebx+temp5]
        mov ax, word [byte ebx+temp3]
        mov word [regd0], ax
        mov ax, word [byte ebx+temp4]
        mov word [regd1], ax
        xor edx, edx
        mov eax, ebx
        call SkateToSpot
.64:
        add esp, byte 8
        jmp near assgoalie_popebp
;-----------------------------------------------------------------------------
; assrefdrop                                   4F5BF  95 PC, medium confidence
; Asstab 22h: in penshotmode switches to 2Ch; else skates to the faceoff spot
; (+-0Fh), puts the puck in hand (puckc 10h, z -64h, v 0)
;-----------------------------------------------------------------------------
; C: src/engine/logic/assrefwhistle.c (assrefdrop)
%ifdef CBUILD
%include "c/engine/logic/assrefwhistle.assrefdrop.inc"
%else
assrefdrop:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ebx, eax
        cmp dword [penshotmode], byte 0
        je short .2
        mov edx, 2Ch
.1:
        call assreplace
        jmp near ass_popx
.2:
        test byte [byte eax+pflags], 20h
        jne near ass_popx
        mov dl, byte [byte ebx+pflags]
        test dl, 2
        je near .5
        mov dh, dl
        and dh, 0FDh
        mov byte [byte ebx+pflags], dh
        mov word [byte ebx+temp2], 8
        mov word [byte ebx+temp1], 0
        cmp word [fox], byte 0
        jg short .3
        mov eax, dword [fox-2]
        sar eax, 10h
        sub eax, byte 0Fh
        jmp short .4
.3:
        mov eax, dword [fox-2]
        sar eax, 10h
        add eax, byte 0Fh
.4:
        mov word [byte ebx+temp3], ax
        mov ax, word [foy]
        mov word [byte ebx+temp4], ax
        or byte [byte ebx+pflags2], 20h
        mov word [byte ebx+Wallcos], 0
        mov word [byte ebx+Wallsin], 0
        mov eax, dword [puckc]
        mov byte [eax], 10h
        mov eax, dword [puckvx]
        mov word [eax], 0
        mov eax, dword [puckvy]
        mov word [eax], 0
        mov eax, dword [puckvz]
        mov word [eax], 0
        mov eax, dword [puckz]
        mov word [eax], 0FF9Ch
        mov edx, 0A5Bh
        mov eax, ebx
        call SetSPA
.5:
        mov edx, dword [ebx]
        sar edx, 10h
        mov eax, dword [byte ebx+temp3-2]
        sar eax, 10h
        sub edx, eax
        mov eax, edx
        mov edx, dword [byte ebx+Ypos]
        sar edx, 10h
        mov ecx, dword [byte ebx+temp4-2]
        sar ecx, 10h
        sub edx, ecx
        imul eax, eax
        imul edx, edx
        add eax, edx
        cmp eax, byte 40h
        jge near ass_skate_temp34
        cmp word [byte ebx+Xvel], byte 0
        jge short .6
        mov eax, dword [byte ebx+Xvel-2]
        sar eax, 10h
        neg eax
        jmp short .7
.6:
        mov eax, dword [byte ebx+Xvel-2]
        sar eax, 10h
.7:
        cmp eax, byte 10h
        jge near ass_skate_temp34
        cmp word [byte ebx+Yvel], byte 0
        jge short .8
        mov eax, dword [byte ebx+Yvel-2]
        sar eax, 10h
        neg eax
        jmp short .9
.8:
        mov eax, dword [byte ebx+Yvel-2]
        sar eax, 10h
.9:
        cmp eax, byte 10h
        jge near ass_skate_temp34
        mov ax, word [byte ebx+temp3]
        mov word [byte ebx+Xpos+2], ax
        mov ax, word [byte ebx+temp4]
        mov word [byte ebx+Ypos+2], ax
        mov di, word [byte ebx+temp1]
        dec edi
        mov word [byte ebx+temp1], di
        test di, di
        jge near ass_popx
        mov edx, edi
        add edx, byte 8
        mov word [byte ebx+temp1], dx
        mov edx, 0A5Bh
        mov eax, ebx
        call SetSPA
        cmp word [fox], byte 0
        jg short .10
        mov eax, 2
        jmp short .11
.10:
        mov eax, 6
.11:
        mov dword [regd2], eax
        mov ax, word [regd2]
        mov si, word [byte ebx+facedir]
        cmp ax, si
        je short .14
        sub eax, esi
        xor ah, ah
        and al, 7
        mov word [regd2], ax
        cmp ax, 5
        jge short .12
        mov eax, 1
        jmp short .13
.12:
        mov eax, 0FFFFFFFFh
.13:
        mov edx, dword [byte ebx+facedir-2]
        sar edx, 10h
        add eax, edx
        and eax, byte 7
        mov word [byte ebx+facedir], ax
        jmp near ass_popx
.14:
        mov word [byte ebx+Yvel], 0
        mov ax, word [byte ebx+Yvel]
        mov word [byte ebx+Xvel], ax
        call PaSpeechBusy
        test eax, eax
        jne near ass_popx
        mov eax, dword [ovlseq-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        jne near ass_popx
        mov word [RefStep], 0FFFFh
        mov edx, 1Eh
        mov eax, ebx
        jmp near assrefdrop.1
%endif ; C
;-----------------------------------------------------------------------------
; assrefgoalline                                  4F7D0  95 PC, low confidence
; Asstab 23h: skates the referee to x +-32h, y +-0E6h (beside the net on the
; puck's end) and holds there
;-----------------------------------------------------------------------------
; C: src/engine/logic/assrefwhistle.c (assrefgoalline)
%ifdef CBUILD
%include "c/engine/logic/assrefwhistle.assrefgoalline.inc"
%else
assrefgoalline:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ebx, eax
        test byte [byte eax+pflags], 20h
        jne near ass_popx
        mov dl, byte [byte ebx+pflags]
        test dl, 2
        je short .5
        mov dh, dl
        and dh, 0FDh
        mov byte [byte ebx+pflags], dh
        mov word [byte ebx+temp2], 8
        mov word [byte ebx+temp1], 0
        mov eax, dword [pucky]
        cmp word [eax], byte 0
        jle short .1
        mov eax, 0E6h
        jmp short .2
.1:
        mov eax, 0FFFFFF1Ah
.2:
        mov word [byte ebx+temp4], ax
        cmp word [byte ebx+Xpos+2], byte 0
        jle short .3
        mov eax, 32h
        jmp short .4
.3:
        mov eax, 0FFFFFFCEh
.4:
        mov word [byte ebx+temp3], ax
        or byte [byte ebx+pflags2], 20h
        mov word [byte ebx+Wallcos], 0
        mov word [byte ebx+Wallsin], 0
.5:
        mov ax, word [byte ebx+Ypos+2]
        mov si, word [byte ebx+temp4]
        sub eax, esi
        mov word [regd0], ax
        test ax, ax
        jge short .6
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .7
.6:
        mov eax, dword [regd0-2]
        sar eax, 10h
.7:
        cmp eax, byte 0Ch
        jg near ass_skate_temp34
        cmp word [byte ebx+Ypos+2], byte 0
        jge short .8
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
        neg eax
        jmp short .9
.8:
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
.9:
        cmp word [byte ebx+temp4], byte 0
        jge short .10
        mov edx, dword [byte ebx+temp4-2]
        sar edx, 10h
        neg edx
        jmp short .11
.10:
        mov edx, dword [byte ebx+temp4-2]
        sar edx, 10h
.11:
        cmp eax, edx
        jg near ass_skate_temp34
        mov ax, word [byte ebx+Xpos+2]
        mov cx, word [byte ebx+temp3]
        sub eax, ecx
        mov word [regd0], ax
        test ax, ax
        jge short .12
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .13
.12:
        mov eax, dword [regd0-2]
        sar eax, 10h
.13:
        cmp eax, byte 0Ch
        jg near ass_skate_temp34
        mov di, word [byte ebx+temp1]
        dec edi
        mov word [byte ebx+temp1], di
        test di, di
        jge near ass_popx
        mov edx, edi
        add edx, byte 8
        mov word [byte ebx+temp1], dx
        mov edx, 0A5Bh
        mov eax, ebx
        call SetSPA
        mov ax, word [byte ebx+temp4]
        sub ax, word [byte ebx+Ypos+2]
        movsx edx, ax
        mov ax, word [byte ebx+Xpos+2]
        neg eax
        cwde
        call vtoa
        cwde
        mov dword [regd2], eax
        mov ax, word [regd2]
        mov si, word [byte ebx+facedir]
        cmp ax, si
        je short .16
        sub eax, esi
        xor ah, ah
        and al, 7
        mov word [regd2], ax
        cmp ax, 5
        jge short .14
        mov eax, 1
        jmp short .15
.14:
        mov eax, 0FFFFFFFFh
.15:
        mov edx, dword [byte ebx+facedir-2]
        sar edx, 10h
        add eax, edx
        and eax, byte 7
        mov word [byte ebx+facedir], ax
        jmp near ass_popx
.16:
        mov word [byte ebx+Yvel], 0
        mov ax, word [byte ebx+Yvel]
        mov word [byte ebx+Xvel], ax
        or byte [byte ebx+pflags], 20h
        mov edx, 0C1Bh
        mov eax, ebx
        call SetSPA
        mov edx, 20h
        jmp near ass_replace_popx
%endif ; C
;-----------------------------------------------------------------------------
; rtss                             4F990  94G collide94.asm, medium confidence
; Asstab slot 0; field alignment n/a of 0 known-field accesses; content rank
; 1/34 vs other slot routines; 0 known Genesis callees present, 0 missing, 0
; extra
;-----------------------------------------------------------------------------
; C: src/engine/logic/rtss.c
%ifdef CBUILD
%include "c/engine/logic/rtss.inc"
%else
rtss:
        push dword 4
        call __CHK
        ret
%endif ; C
;-----------------------------------------------------------------------------
; NextPathPoint               4F99B  94G shootoutpath94.asm, medium confidence
; Same role as 94G shootoutpath94 NextPathPoint: advances the path index
; (sopathpoint) and loads the next point x/y/end from the 3-dword table
; ShootoutPathData (x negated by the path side); called by asspenshooter
;-----------------------------------------------------------------------------
; C: src/engine/logic/NextPathPoint.c
%ifdef CBUILD
%include "c/engine/logic/NextPathPoint.inc"
%else
NextPathPoint:
        push dword 8
        call __CHK
        push edx
        mov edx, dword [sopathpoint]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, eax
        mov eax, dword [nosplit eax*4+ShootoutPathData]
        cmp dword [pspathside], byte 0
        jge short .1
        neg eax
.1:
        mov dword [sopathx], eax
        mov eax, edx
        mov edx, dword [nosplit edx*4+ShootoutPathData_y]
        mov dword [sopathy], edx
        mov eax, dword [nosplit eax*4+ShootoutPathData_end]
        mov dword [sopathend], eax
        inc dword [sopathpoint]
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; StartShootoutPath           4F9EF  94G shootoutpath94.asm, medium confidence
; Role match: starts the shootout / penalty shot skate path (PC builds the
; path, 94G picks one)
;-----------------------------------------------------------------------------
; C: src/engine/logic/StartShootoutPath.c
%ifdef CBUILD
%include "c/engine/logic/StartShootoutPath.inc"
%else
StartShootoutPath:
        push dword 0Ch
        call __CHK
        push ebx
        push ecx
        mov ebx, eax
        cmp edx, byte 27h
        jl near .8
        mov edx, dword [eax]
        sar edx, 10h
        test edx, edx
        jge short .1
        neg edx
.1:
        cmp edx, byte 14h
        jle short .2
        xor ecx, ecx
        mov dword [sopathx], ecx
        mov dword [pspathside], ecx
        jmp short .7
.2:
        mov edx, 2Ch
        mov eax, 4
        call randomd0
        test ax, ax
        je short .3
        cmp byte [byte ebx+065h], 0
        je short .5
        jmp short .4
.3:
        mov eax, 10h
        call randomd0
        cmp ax, 8
        jge short .5
.4:
        mov edx, 0FFFFFFD4h
.5:
        test byte [byte ebx+044h], 80h
        jne short .6
        neg edx
.6:
        mov dword [sopathx], edx
        mov dword [pspathside], edx
.7:
        mov dword [sopathpoint], 2
        mov dword [sopathy], 97h
        mov dword [sopathend], 66h
        pop ecx
        pop ebx
        ret
.8:
        mov edx, 3Ah
        mov eax, 4
        call randomd0
        test ax, ax
        je short .9
        cmp byte [byte ebx+065h], 0
        je short .11
        jmp short .10
.9:
        mov eax, 10h
        call randomd0
        cmp ax, 8
        jge short .11
.10:
        mov edx, 0FFFFFFC6h
.11:
        test byte [byte ebx+044h], 80h
        jne short .12
        neg edx
.12:
        mov dword [sopathx], edx
        mov dword [pspathside], edx
        mov dword [sopathy], 3Ch
        mov dword [sopathend], 1Eh
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; asspenshooter                                4FAE8  95 PC, medium confidence
; Asstab 2Eh (asspuckc, SetupPenaltyShot): penalty-shot carrier: assexit if
; not carrying; PickShotAim, then dekes and shoots on the goal (passdir,
; passspeed)
;-----------------------------------------------------------------------------
; C: src/engine/logic/asspenshooter.c
%ifdef CBUILD
%include "c/engine/logic/asspenshooter.inc"
%else
asspenshooter:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov ebx, eax
        mov edx, dword [puckc]
        movsx ax, byte [edx]
        cmp ax, word [byte ebx+SCnum]
        je short .2
.1:
        mov eax, ebx
        call assexit
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.2:
        mov ah, byte [byte ebx+pflags]
        test ah, 8
        jne short asspenshooter.1
        test ah, 20h
        jne near .x
        test byte [gmode], 1
        je short .3
        mov edx, 289h
        mov eax, ebx
        call SetSPA
        mov word [byte ebx+03Eh], 3Ch
        mov eax, ebx
        call donothing
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.3:
        mov ecx, dword [byte ebx+Ypos]
        sar ecx, 10h
        test ah, 80h
        jne short .4
        neg ecx
.4:
        mov ah, byte [byte ebx+pflags]
        test ah, 2
        je short .5
        mov dl, ah
        and dl, 0FDh
        mov byte [byte ebx+pflags], dl
        mov word [byte ebx+temp1], 0
        mov byte [byte ebx+029h], 0
        mov byte [byte ebx+028h], 8
        xor edx, edx
        mov dword [sopathpoint], edx
        mov eax, 4
        call randomd0
        mov word [byte ebx+temp3], ax
        mov edx, ecx
        mov eax, ebx
        call StartShootoutPath
.5:
        mov esi, dword [sopathend]
        test esi, esi
        jge near .13
        mov ecx, dword [byte ebx+facedir-2]
        sar ecx, 10h
        sub ecx, dword [pspathdir]
        je near .14
        inc ecx
        and ecx, byte 7
        cmp ecx, byte 3
        jl short .6
        mov eax, 4
        call randomd0
        test ax, ax
        je short .7
.6:
        cmp ecx, byte 3
        jge near .14
        mov eax, 20h
        call randomd0
        test ax, ax
        jne near .14
.7:
        mov eax, 2
        call randomd0
        movsx ecx, ax
        add ecx, byte 2
        cmp dword [pspathside], byte 0
        jge short .8
        add ecx, byte 3
.8:
        mov word [passdir], cx
        mov word [passspeed], 14h
        mov ax, word [byte ebx+Xpos+2]
        neg eax
        mov word [regd0], ax
        test byte [byte ebx+pflags], 80h
        jne short .9
        mov eax, 0FFFFFF18h
        jmp short .10
.9:
        mov eax, 0E8h
.10:
        mov edx, dword [byte ebx+Ypos]
        sar edx, 10h
        sub eax, edx
        mov word [regd1], ax
        mov edx, dword [regd1-2]
        sar edx, 10h
        mov eax, dword [regd0-2]
        sar eax, 10h
        call vtoa
        movsx ecx, ax
        movsx edx, cx
        mov eax, ebx
        call Findhittype
        test ax, ax
        je short .11
        mov eax, 0DD3h
        jmp short .12
.11:
        mov eax, 0E2Bh
.12:
        movsx edx, ax
        mov eax, ebx
        call SetSPA
        mov eax, ebx
        call updateanim
        mov word [byte ebx+SPAcnt], 2
        mov eax, ebx
        call doshot
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.13:
        cmp ecx, esi
        jl short .14
        call NextPathPoint
        mov eax, dword [byte ebx+facedir-2]
        sar eax, 10h
        mov dword [pspathdir], eax
.14:
        mov ax, word [sopathx]
        mov word [regd0], ax
        mov ax, word [sopathy]
        mov word [regd1], ax
        test byte [byte ebx+pflags], 80h
        jne short .15
        mov ecx, eax
        neg ecx
        mov word [regd1], cx
.15:
        sub byte [byte ebx+029h], 2
        xor edx, edx
        mov eax, ebx
        call skateto
.x:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
