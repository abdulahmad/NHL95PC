; Save and restore a game in progress: both teams, every player, the puck,
; and the clock, so a highlight or a replay can put the game back.
bits 32
%include "hockey.inc"
section s_5FB03 progbits alloc exec nowrite align=1
extern __CHK, __STOSB, __STOSD, awlinetab, awroster, awteamrec, awtmglstats, awtmlines
extern awtmplstats, awtmptrF2, awtmroster, awtmsort, awtmstruct, bannermsg, bannertimer, BuildEventLines
extern rinkobjanim, UnusedStateFlag, UnusedStateMode, UnusedStateSpare, GameRecordDay, GameRecordMonth, milestonesaid, curevent
extern goalevent, c1playernum, c2playernum, camx, camy, clockticks, collflag, cont1team
extern cont2team, crowdlevel, crowdsmooth, ctl1dev, ctl1side, ctl1team, ctl2dev, ctl2team
extern curperiod, CwdExciteLvl, deferpending, DeskRedrawAll, DeskRedrawFlag, goalienotebits, hmplstats, hmtmplattr
extern hmtmglattr, awtmplattr, awtmglattr, SumCwdExciteLvl, SpeechPatchNext, UnusedEventWord, rinkobjused_m2, energywarn
extern exhstate, exitgame, fadeinpending, FatalError, FileReadAt, FileWriteAt, fodir1, fodir2
extern fofdata2, fox, foy, frameaccum, gameclock, gamemode, gameover, gamepal
extern GetPeriodTime, gmode, gmode2, gsp, hmlinetab, hmroster, hmteamrec, hmtmglstats
extern hmtmlines, hmtmplstats, hmtmptrF2, hmtmroster, hmtmsort, hmtmstruct, HomeTeam, hudclockhund
extern hudclockmin, hudclocksec, hudhundaccum, hudhundstep, hudpenaway, hudpenhome, iflags, lastplayer
extern lastsfx, lasttouch, lcblink, lcblinktime, lcboxon, lcline, lcreqchoice, lcrequest
extern lcsel, lctimer, lgstate, lj1, lj2, lldispodd, LoadGameGfx, LoadGameTeams
extern LoadModeState, LoadRockMusic, LoadTeamPalette, ltack, ltx, lty, MouseSetPos, ovlscripts
extern onetimerflag, OOlist, OOlistpos, ovlscript, ovlseq, ovlstep, ovlstepidx, ovlsteptimer
extern ovltimer, pad1dev, pad2dev, passdir, passplayer, passspeed, PBnum, Penaltytimer
extern PenBuf, Pencntdwn, penshotctl, penshotfox, penshotfoy, penshotlive, penshotmode, penshotplayer
extern penshotpnum, penshotstart, penshotteam, penshottimer, periodendtime, PerTimeTotal, photobankf, photobanks
extern PlList, postate, psendcount, pspathdir, pspathside, puckcross, recbpr, RefPen
extern refsignal, RefStep, ReplayRecordReset, replaystart, savedmousex, savedmousey, SaveModeState, seed
extern sflags, sflags3, shotongoal, shotontarget, shotplayer, shownumbers, sopathend, sopathpoint
extern sopathx, sopathy, SortCords, SprSort, str_ErrLoadGame, str_ErrSaveGame, threat, gsumheader
extern gsumtail, hmglattr, awglattr, hmplattr, awplattr, awplstats, hmglstats, awglstats
extern VisTeam, penaltysc, SortPending, lcsel_aw, ObjInitFrame, ObjInitAttr, refhitcount, injurystop
extern Pencntdwn2, lcline_aw, rinkobjdefs, rinkobjs, rinkobjs_w2, SaveStateSpare, SaveStatePad, milestonesaid_b2
extern UnusedSpeechWord, UnusedCrowdWord, MaxCwdExciteLvl, NumCwdExciteLvl, UnusedCrowdWordHi, penevteam, GoalState, rinkobjused
extern xc1, yc1, yleader
global SaveGameState, SaveGameState_popx, LoadGameState
;-----------------------------------------------------------------------------
; SaveGameState                                                   5FB03  95 PC
; Writes the in-game state to the open file eax with FileWriteAt (buffer,
; length): ctl1side (4), the 17 SortCords entries (66h bytes each),
;
; both team structs (D4h each), hmlinetab / awlinetab (30h each), then the
; game globals one by one (clock, scores, flags, PenBuf, ...); "Error Saving
; Game" (str_ErrSaveGame) on a failed write; called from demo_savegame
;
; and the in-game save
;-----------------------------------------------------------------------------
; C: src/pc/game_saveload/SaveGameState.c
%ifdef CBUILD
%include "c/pc/game_saveload/SaveGameState.inc"
%else
SaveGameState:
        push dword 0B0h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, 8Ch
        push eax
        mov ecx, 4
        mov ebx, 0FFFFFFFFh
        mov edx, ctl1side
        call FileWriteAt
        test eax, eax
        je short .1
        push str_ErrSaveGame
        call FatalError
        add esp, byte 4
.1:
        xor ebp, ebp
.2:
        mov edx, ebp
        shl edx, 7
        add edx, SortCords
        mov ecx, 66h
        mov ebx, 0FFFFFFFFh
        mov eax, dword [esp]
        call FileWriteAt
        test eax, eax
        je short .3
        push str_ErrSaveGame
        call FatalError
        add esp, byte 4
.3:
        inc ebp
        cmp ebp, byte 11h
        jl short SaveGameState.2
        xor ebp, ebp
.4:
        mov edx, ebp
        shl edx, 8
        add edx, hmtmstruct
        mov ecx, 0D4h
        mov ebx, 0FFFFFFFFh
        mov eax, dword [esp]
        call FileWriteAt
        test eax, eax
        je short .5
        push str_ErrSaveGame
        call FatalError
        add esp, byte 4
.5:
        inc ebp
        cmp ebp, byte 2
        jl short SaveGameState.4
        mov ecx, 30h
        mov ebx, 0FFFFFFFFh
        mov edx, hmlinetab
        mov eax, dword [esp]
        call FileWriteAt
        test eax, eax
        je short .6
        push str_ErrSaveGame
        call FatalError
        add esp, byte 4
.6:
        mov ecx, 30h
        mov ebx, 0FFFFFFFFh
        mov edx, awlinetab
        mov eax, dword [esp]
        call FileWriteAt
        test eax, eax
        je short .7
        push str_ErrSaveGame
        call FatalError
        add esp, byte 4
.7:
        mov ax, word [HomeTeam]
        mov word [byte esp+04h], ax
        lea eax, [byte esp+04h]
        add eax, byte 2
        mov dx, word [VisTeam]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [camx]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [camy]
        mov word [eax], dx
        xor ebp, ebp
        add eax, byte 2
.8:
        mov dx, word [nosplit ebp*2+fofdata2]
        mov word [eax], dx
        add eax, byte 2
        inc ebp
        cmp ebp, byte 6
        jl short SaveGameState.8
        mov dx, word [shotplayer]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [lastplayer]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [passdir]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [passspeed]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [passplayer]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [threat]
        mov word [eax], dx
        xor ebp, ebp
        add eax, byte 2
.9:
        mov dx, word [nosplit ebp*2+puckcross]
        mov word [eax], dx
        add eax, byte 2
        inc ebp
        cmp ebp, byte 4
        jl short SaveGameState.9
        mov dx, word [lj1]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [lj2]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [lasttouch]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [ltx]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [lty]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [xc1]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [yc1]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [yleader]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [fox]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [foy]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [fodir1]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [fodir2]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [sflags]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [gmode2]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [sflags3]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [c1playernum]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [c2playernum]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [cont1team]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [cont2team]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [Pencntdwn]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [Penaltytimer]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [refsignal]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [RefStep]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [RefPen]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [penaltysc]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [gsp]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [gameclock]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [clockticks]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [shownumbers]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [SortPending]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [exitgame]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [gameover]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [ovltimer]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [refhitcount]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [fadeinpending]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [deferpending]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [injurystop]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [GoalState]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [bannermsg]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [bannertimer]
        mov word [eax], dx
        add eax, byte 2
        mov edx, dword [seed]
        mov dword [eax], edx
        add eax, byte 4
        mov dx, word [PBnum]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [iflags]
        mov word [eax], dx
        mov ecx, 80h
        mov ebx, 0FFFFFFFFh
        lea edx, [byte esp+04h]
        mov eax, dword [esp]
        call FileWriteAt
        test eax, eax
        je short .10
        push str_ErrSaveGame
        call FatalError
        add esp, byte 4
.10:
        lea eax, [byte esp+04h]
        xor ebp, ebp
.11:
        mov dx, word [nosplit ebp*2+PlList]
        mov word [eax], dx
        add eax, byte 2
        inc ebp
        cmp ebp, byte 6
        jl short SaveGameState.11
        mov dl, byte [pad1dev]
        mov byte [eax], dl
        mov dl, byte [pad2dev]
        mov byte [byte eax+01h], dl
        add eax, byte 2
        mov dl, byte [collflag]
        mov byte [eax], dl
        mov dl, byte [gmode]
        mov byte [byte eax+01h], dl
        add eax, byte 2
        mov dx, word [energywarn]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [energywarn+2]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [lcblink]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [lcblink+2]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [lcblinktime]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [lcblinktime+2]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [lcsel]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [lcsel_aw]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [lcline]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [lcline+2]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [lctimer]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [lctimer+2]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [lcboxon]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [lcboxon+2]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [lcrequest]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [lcrequest+2]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [lcreqchoice]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [lcreqchoice+2]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [savedmousex]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [savedmousey]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [SaveStateSpare]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [SaveStatePad]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [curperiod]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [lldispodd]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [UnusedEventWord]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [penevteam]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [periodendtime]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [SpeechPatchNext]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [ltack]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [lastsfx]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [UnusedSpeechWord]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [crowdlevel]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [UnusedCrowdWordHi]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [UnusedCrowdWord]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [CwdExciteLvl]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [MaxCwdExciteLvl]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [NumCwdExciteLvl]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [SumCwdExciteLvl]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [ctl1team]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [ctl2team]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [ctl1dev]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [ctl2dev]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [hudclockmin]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [hudclocksec]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [hudclockhund]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [Pencntdwn2]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [hudhundaccum]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [frameaccum]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [goalienotebits]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [milestonesaid]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [milestonesaid_b2]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [gamemode]
        mov word [eax], dx
        add eax, byte 2
        mov dl, byte [GameRecordMonth]
        mov byte [eax], dl
        mov dl, byte [GameRecordDay]
        mov byte [byte eax+01h], dl
        add eax, byte 2
        mov dl, byte [UnusedStateFlag]
        mov byte [eax], dl
        mov dl, byte [UnusedStateMode]
        mov byte [byte eax+01h], dl
        add eax, byte 2
        mov dl, byte [UnusedStateSpare]
        mov byte [eax], dl
        mov dl, byte [onetimerflag]
        mov byte [byte eax+01h], dl
        mov ecx, 80h
        mov ebx, 0FFFFFFFFh
        lea edx, [byte esp+04h]
        mov eax, dword [esp]
        call FileWriteAt
        test eax, eax
        je short .12
        push str_ErrSaveGame
        call FatalError
        add esp, byte 4
.12:
        lea eax, [byte esp+04h]
        xor ebp, ebp
.13:
        mov ecx, ebp
        shl ecx, 2
        sub ecx, ebp
        mov dx, word [nosplit ecx*4+rinkobjs]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [nosplit ecx*4+rinkobjs_w2]
        mov word [eax], dx
        add eax, byte 2
        inc ebp
        cmp ebp, byte 14h
        jl short SaveGameState.13
        mov dx, word [ovlseq]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [ovlstep]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [ovlsteptimer]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [ovlstepidx]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [shotongoal]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [penshotplayer]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [penshotpnum]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [penshotteam]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [penshotctl]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [lcline_aw]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [penshotfox]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [penshotfoy]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [penshotmode]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [penshotstart]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [penshottimer]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [shotontarget]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [penshotlive]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [psendcount]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [sopathx]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [sopathy]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [sopathend]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [sopathpoint]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [pspathside]
        mov word [eax], dx
        add eax, byte 2
        mov dx, word [pspathdir]
        mov word [eax], dx
        mov ecx, 80h
        mov ebx, 0FFFFFFFFh
        lea edx, [byte esp+04h]
        mov eax, dword [esp]
        call FileWriteAt
        test eax, eax
        je short .14
        push str_ErrSaveGame
        call FatalError
        add esp, byte 4
.14:
        mov ecx, 42h
        mov ebx, 0FFFFFFFFh
        mov edx, PenBuf
        mov eax, dword [esp]
        call FileWriteAt
        test eax, eax
        je short .15
        push str_ErrSaveGame
        call FatalError
        add esp, byte 4
.15:
        mov ecx, 0Bh
        mov ebx, 0FFFFFFFFh
        mov edx, curevent
        mov eax, dword [esp]
        call FileWriteAt
        test eax, eax
        je short .16
        push str_ErrSaveGame
        call FatalError
        add esp, byte 4
.16:
        mov ecx, 0Bh
        mov ebx, 0FFFFFFFFh
        mov edx, goalevent
        mov eax, dword [esp]
        call FileWriteAt
        test eax, eax
        je short .17
        push str_ErrSaveGame
        call FatalError
        add esp, byte 4
.17:
        mov ecx, 0Bh
        mov ebx, 0FFFFFFFFh
        mov edx, gsumheader
        mov eax, dword [esp]
        call FileWriteAt
        test eax, eax
        je short .18
        push str_ErrSaveGame
        call FatalError
        add esp, byte 4
.18:
        mov ecx, 0Bh
        mov ebx, 0FFFFFFFFh
        mov edx, gsumtail
        mov eax, dword [esp]
        call FileWriteAt
        test eax, eax
        je short .19
        push str_ErrSaveGame
        call FatalError
        add esp, byte 4
.19:
        mov ecx, 40h
        mov ebx, 0FFFFFFFFh
        mov edx, hudpenhome
        mov eax, dword [esp]
        call FileWriteAt
        test eax, eax
        je short .20
        push str_ErrSaveGame
        call FatalError
        add esp, byte 4
.20:
        mov ecx, 40h
        mov ebx, 0FFFFFFFFh
        mov edx, hudpenaway
        mov eax, dword [esp]
        call FileWriteAt
        test eax, eax
        je short .21
        push str_ErrSaveGame
        call FatalError
        add esp, byte 4
.21:
        lea ebx, [byte esp+04h]
        xor ecx, ecx
        xor ebp, ebp
.22:
        lea eax, [byte ecx+010h]
        cmp eax, 80h
        jbe short .24
        mov ebx, 0FFFFFFFFh
        lea edx, [byte esp+04h]
        mov eax, dword [esp]
        call FileWriteAt
        test eax, eax
        je short .23
        push str_ErrSaveGame
        call FatalError
        add esp, byte 4
.23:
        lea ebx, [byte esp+04h]
        xor ecx, ecx
.24:
        mov esi, 19h
        mov eax, ebp
        mov edx, ebp
        sar edx, 1Fh
        idiv esi
        mov edi, eax
        shl edi, 2
        sub edi, eax
        shl edi, 3
        add edi, eax
        shl edi, 4
        mov eax, ebp
        mov edx, ebp
        sar edx, 1Fh
        idiv esi
        shl edx, 4
        lea esi, [edi+edx]
        mov edi, ebx
        lea esi, [dword esi+hmplstats]
        movsd
        movsd
        movsd
        movsd
        add ebx, byte 10h
        add ecx, byte 10h
        inc ebp
        cmp ebp, byte 32h
        jl short SaveGameState.22
        xor ebp, ebp
.25:
        lea eax, [byte ecx+06h]
        cmp eax, 80h
        jbe short .27
        mov ebx, 0FFFFFFFFh
        lea edx, [byte esp+04h]
        mov eax, dword [esp]
        call FileWriteAt
        test eax, eax
        je short .26
        push str_ErrSaveGame
        call FatalError
        add esp, byte 4
.26:
        lea ebx, [byte esp+04h]
        xor ecx, ecx
.27:
        mov esi, 3
        mov eax, ebp
        mov edx, ebp
        sar edx, 1Fh
        idiv esi
        mov edi, eax
        shl edi, 3
        add edi, eax
        add edi, edi
        mov eax, ebp
        mov edx, ebp
        sar edx, 1Fh
        idiv esi
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        lea esi, [edi+eax]
        mov edi, ebx
        lea esi, [dword esi+hmglstats]
        movsd
        movsw
        add ebx, byte 6
        add ecx, byte 6
        inc ebp
        cmp ebp, byte 6
        jl short SaveGameState.25
        test ecx, ecx
        je short .28
        mov ebx, 0FFFFFFFFh
        lea edx, [byte esp+04h]
        mov eax, dword [esp]
        call FileWriteAt
        test eax, eax
        je short .28
        push str_ErrSaveGame
        call FatalError
        add esp, byte 4
.28:
        xor eax, eax
        add esp, 90h
SaveGameState_popx:
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; LoadGameState                                                   60612  95 PC
; Reads back what SaveGameState wrote, in the same order, with FileReadAt from
; file eax; "Error Loading Game" (str_ErrLoadGame) on a failed read; called
;
; from gamesave_io
;-----------------------------------------------------------------------------
LoadGameState:
        push dword 134h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, 110h
        mov ebp, eax
        mov ecx, 4
        mov ebx, 0FFFFFFFFh
        mov edx, ctl1side
        call FileReadAt
        test eax, eax
        je short .1
        push str_ErrSaveGame
        call FatalError
        add esp, byte 4
.1:
        xor edx, edx
        mov dword [dword esp+010Ch], edx
.2:
        mov edx, dword [dword esp+010Ch]
        shl edx, 7
        add edx, SortCords
        mov ecx, 66h
        mov ebx, 0FFFFFFFFh
        mov eax, ebp
        call FileReadAt
        test eax, eax
        je short .3
        push str_ErrLoadGame
        call FatalError
        add esp, byte 4
.3:
        mov ebx, dword [dword esp+010Ch]
        inc ebx
        mov dword [dword esp+010Ch], ebx
        cmp ebx, byte 11h
        jl short LoadGameState.2
        xor esi, esi
        mov dword [dword esp+010Ch], esi
.4:
        mov edx, dword [dword esp+010Ch]
        shl edx, 8
        add edx, hmtmstruct
        mov ecx, 0D4h
        mov ebx, 0FFFFFFFFh
        mov eax, ebp
        call FileReadAt
        test eax, eax
        je short .5
        push str_ErrLoadGame
        call FatalError
        add esp, byte 4
.5:
        mov edi, dword [dword esp+010Ch]
        inc edi
        mov dword [dword esp+010Ch], edi
        cmp edi, byte 2
        jl short LoadGameState.4
        mov ecx, 30h
        mov ebx, 0FFFFFFFFh
        mov edx, hmlinetab
        mov eax, ebp
        call FileReadAt
        test eax, eax
        je short .6
        push str_ErrLoadGame
        call FatalError
        add esp, byte 4
.6:
        mov ecx, 30h
        mov ebx, 0FFFFFFFFh
        mov edx, awlinetab
        mov eax, ebp
        call FileReadAt
        test eax, eax
        je short .7
        push str_ErrLoadGame
        call FatalError
        add esp, byte 4
.7:
        mov ecx, 80h
        mov ebx, 0FFFFFFFFh
        mov edx, esp
        mov eax, ebp
        call FileReadAt
        test eax, eax
        je short .8
        push str_ErrLoadGame
        call FatalError
        add esp, byte 4
.8:
        mov eax, dword [esp]
        mov word [HomeTeam], ax
        mov ebx, esp
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [VisTeam], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [camx], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [camy], ax
        xor edx, edx
        mov dword [dword esp+010Ch], edx
        add ebx, byte 2
.9:
        mov eax, dword [dword esp+010Ch]
        mov dx, word [ebx]
        mov word [nosplit eax*2+fofdata2], dx
        add ebx, byte 2
        lea ecx, [byte eax+01h]
        mov dword [dword esp+010Ch], ecx
        cmp ecx, byte 6
        jl short LoadGameState.9
        mov ax, word [ebx]
        mov word [shotplayer], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [lastplayer], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [passdir], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [passspeed], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [passplayer], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [threat], ax
        xor edi, edi
        mov dword [dword esp+010Ch], edi
        add ebx, byte 2
.10:
        mov eax, dword [dword esp+010Ch]
        mov dx, word [ebx]
        mov word [nosplit eax*2+puckcross], dx
        add ebx, byte 2
        inc eax
        mov dword [dword esp+010Ch], eax
        cmp eax, byte 4
        jl short LoadGameState.10
        mov ax, word [ebx]
        mov word [lj1], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [lj2], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [lasttouch], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [ltx], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [lty], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [xc1], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [yc1], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [yleader], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [fox], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [foy], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [fodir1], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [fodir2], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [sflags], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [gmode2], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [sflags3], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [c1playernum], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [c2playernum], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [cont1team], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [cont2team], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [Pencntdwn], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [Penaltytimer], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [refsignal], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [RefStep], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [RefPen], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [penaltysc], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [gsp], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [gameclock], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [clockticks], ax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [shownumbers], eax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [SortPending], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [exitgame], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [gameover], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [ovltimer], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [refhitcount], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [fadeinpending], ax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [deferpending], eax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [injurystop], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [GoalState], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [bannermsg], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [bannertimer], ax
        add ebx, byte 2
        mov eax, dword [ebx]
        mov dword [seed], eax
        add ebx, byte 4
        mov ax, word [ebx]
        mov word [PBnum], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [iflags], ax
        mov ecx, 80h
        mov ebx, 0FFFFFFFFh
        mov edx, esp
        mov eax, ebp
        call FileReadAt
        test eax, eax
        je short .11
        push str_ErrLoadGame
        call FatalError
        add esp, byte 4
.11:
        mov ebx, esp
        xor ecx, ecx
        mov dword [dword esp+010Ch], ecx
.12:
        mov eax, dword [dword esp+010Ch]
        mov dx, word [ebx]
        mov word [nosplit eax*2+PlList], dx
        add ebx, byte 2
        lea esi, [byte eax+01h]
        mov dword [dword esp+010Ch], esi
        cmp esi, byte 6
        jl short LoadGameState.12
        mov al, byte [ebx]
        mov byte [pad1dev], al
        mov al, byte [byte ebx+01h]
        mov byte [pad2dev], al
        add ebx, byte 2
        mov al, byte [ebx]
        mov byte [collflag], al
        mov al, byte [byte ebx+01h]
        mov byte [gmode], al
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [energywarn], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [energywarn+2], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [lcblink], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [lcblink+2], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [lcblinktime], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [lcblinktime+2], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [lcsel], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [lcsel_aw], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [lcline], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [lcline+2], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [lctimer], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [lctimer+2], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [lcboxon], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [lcboxon+2], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [lcrequest], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [lcrequest+2], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [lcreqchoice], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [lcreqchoice+2], ax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [savedmousex], eax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [savedmousey], eax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [SaveStateSpare], eax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [SaveStatePad], eax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [curperiod], eax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [lldispodd], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [UnusedEventWord], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [penevteam], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [periodendtime], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [SpeechPatchNext], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [ltack], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [lastsfx], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [UnusedSpeechWord], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [crowdlevel], ax
        mov eax, dword [crowdlevel-2]
        sar eax, 10h
        mov dword [crowdsmooth], eax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [UnusedCrowdWordHi], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [UnusedCrowdWord], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [CwdExciteLvl], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [MaxCwdExciteLvl], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [NumCwdExciteLvl], ax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [SumCwdExciteLvl], eax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [ctl1team], eax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [ctl2team], eax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [ctl1dev], eax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [ctl2dev], eax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [hudclockmin], eax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [hudclocksec], eax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [hudclockhund], eax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [Pencntdwn2], ax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [hudhundaccum], eax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [frameaccum], eax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [goalienotebits], eax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [milestonesaid], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [milestonesaid_b2], ax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [gamemode], eax
        add ebx, byte 2
        mov al, byte [ebx]
        mov byte [GameRecordMonth], al
        mov al, byte [byte ebx+01h]
        mov byte [GameRecordDay], al
        add ebx, byte 2
        mov al, byte [ebx]
        mov byte [UnusedStateFlag], al
        mov al, byte [byte ebx+01h]
        mov byte [UnusedStateMode], al
        add ebx, byte 2
        mov al, byte [ebx]
        mov byte [UnusedStateSpare], al
        movsx eax, byte [byte ebx+01h]
        mov dword [onetimerflag], eax
        mov ecx, 80h
        mov ebx, 0FFFFFFFFh
        mov edx, esp
        mov eax, ebp
        call FileReadAt
        test eax, eax
        je short .13
        push str_ErrLoadGame
        call FatalError
        add esp, byte 4
.13:
        mov ebx, esp
        mov ecx, 20h
        xor edx, edx
        mov eax, rinkobjused
        call __STOSB
        mov dword [dword esp+010Ch], 10h
        xor edx, edx
        mov dword [dword esp+010Ch], edx
.14:
        mov eax, dword [dword esp+010Ch]
        mov esi, eax
        shl esi, 2
        sub esi, eax
        shl esi, 2
        add esi, rinkobjs
        mov ax, word [ebx]
        mov word [esi], ax
        movsx edi, ax
        mov eax, edi
        mov edx, edi
        sar edx, 1Fh
        shl edx, 4
        LD sbb, eax, edx
        sar eax, 4
        add eax, eax
        mov dword [dword esp+0100h], eax
        mov ecx, 10h
        mov eax, edi
        mov edx, edi
        sar edx, 1Fh
        idiv ecx
        mov cl, dl
        mov edx, 1
        shl edx, cl
        mov eax, dword [dword esp+0100h]
        mov eax, dword [dword eax+rinkobjused-2]
        sar eax, 10h
        or eax, edx
        mov edx, dword [dword esp+0100h]
        mov word [dword edx+rinkobjused], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [byte esi+02h], ax
        add ebx, byte 2
        test edi, edi
        jl short .15
        mov eax, edi
        shl edi, 2
        sub edi, eax
        mov ax, word [nosplit edi*2+rinkobjdefs]
        mov word [byte esi+05h], ax
        inc edi
        mov ax, word [nosplit edi*2+rinkobjdefs]
        mov word [byte esi+07h], ax
        inc edi
        mov ax, word [nosplit edi*2+rinkobjdefs]
        mov word [byte esi+09h], ax
        mov eax, dword [byte esi+07h]
        sar eax, 10h
        mov al, byte [dword eax+rinkobjanim]
        mov byte [byte esi+0Bh], al
        mov eax, dword [byte esi+07h]
        sar eax, 10h
        mov edx, dword [esi]
        sar edx, 18h
        mov al, byte [dword edx+eax+rinkobjanim]
        mov byte [byte esi+04h], al
.15:
        mov ecx, dword [dword esp+010Ch]
        inc ecx
        mov dword [dword esp+010Ch], ecx
        cmp ecx, byte 14h
        jl near LoadGameState.14
        mov ax, word [ebx]
        mov word [ovlseq], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [ovlstep], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [ovlsteptimer], ax
        add ebx, byte 2
        mov ax, word [ebx]
        mov word [ovlstepidx], ax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [shotongoal], eax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [penshotplayer], eax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [penshotpnum], eax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [penshotteam], eax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [penshotctl], eax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [lcline_aw], eax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [penshotfox], eax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [penshotfoy], eax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [penshotmode], eax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [penshotstart], eax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [penshottimer], eax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [shotontarget], eax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [penshotlive], eax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [psendcount], eax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [sopathx], eax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [sopathy], eax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [sopathend], eax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [sopathpoint], eax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [pspathside], eax
        add ebx, byte 2
        movsx eax, word [ebx]
        mov dword [pspathdir], eax
        mov ecx, 42h
        mov ebx, 0FFFFFFFFh
        mov edx, PenBuf
        mov eax, ebp
        call FileReadAt
        test eax, eax
        je short .16
        push str_ErrLoadGame
        call FatalError
        add esp, byte 4
.16:
        mov ecx, 0Bh
        mov ebx, 0FFFFFFFFh
        mov edx, curevent
        mov eax, ebp
        call FileReadAt
        test eax, eax
        je short .17
        push str_ErrLoadGame
        call FatalError
        add esp, byte 4
.17:
        mov ecx, 0Bh
        mov ebx, 0FFFFFFFFh
        mov edx, goalevent
        mov eax, ebp
        call FileReadAt
        test eax, eax
        je short .18
        push str_ErrLoadGame
        call FatalError
        add esp, byte 4
.18:
        mov ecx, 0Bh
        mov ebx, 0FFFFFFFFh
        mov edx, gsumheader
        mov eax, ebp
        call FileReadAt
        test eax, eax
        je short .19
        push str_ErrLoadGame
        call FatalError
        add esp, byte 4
.19:
        mov ecx, 0Bh
        mov ebx, 0FFFFFFFFh
        mov edx, gsumtail
        mov eax, ebp
        call FileReadAt
        test eax, eax
        je short .20
        push str_ErrLoadGame
        call FatalError
        add esp, byte 4
.20:
        mov ecx, 40h
        mov ebx, 0FFFFFFFFh
        lea edx, [dword esp+0C0h]
        mov eax, ebp
        call FileReadAt
        test eax, eax
        je short .21
        push str_ErrLoadGame
        call FatalError
        add esp, byte 4
.21:
        mov ecx, 40h
        mov ebx, 0FFFFFFFFh
        lea edx, [dword esp+080h]
        mov eax, ebp
        call FileReadAt
        test eax, eax
        je short .22
        push str_ErrLoadGame
        call FatalError
        add esp, byte 4
.22:
        xor edi, edi
        mov dword [dword esp+0108h], edi
        mov dword [dword esp+010Ch], edi
.23:
        cmp dword [dword esp+0108h], byte 0
        jne short .26
        mov dword [dword esp+0108h], 80h
        cmp dword [dword esp+010Ch], byte 30h
        jl short .24
        mov dword [dword esp+0108h], 44h
.24:
        mov ecx, dword [dword esp+0108h]
        mov ebx, 0FFFFFFFFh
        mov edx, esp
        mov eax, ebp
        call FileReadAt
        test eax, eax
        je short .25
        push str_ErrLoadGame
        call FatalError
        add esp, byte 4
.25:
        mov eax, esp
        mov dword [dword esp+0104h], eax
.26:
        mov ecx, dword [dword esp+0104h]
        mov ebx, 19h
        mov eax, dword [dword esp+010Ch]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        mov ebx, eax
        shl ebx, 2
        sub ebx, eax
        shl ebx, 3
        lea esi, [eax+ebx]
        shl esi, 4
        mov ebx, 19h
        mov eax, dword [dword esp+010Ch]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        shl edx, 4
        lea edi, [byte ecx+010h]
        mov dword [dword esp+0104h], edi
        lea edi, [dword edx+esi+hmplstats]
        mov esi, ecx
        movsd
        movsd
        movsd
        movsd
        sub dword [dword esp+0108h], byte 10h
        mov edx, dword [dword esp+010Ch]
        inc edx
        mov dword [dword esp+010Ch], edx
        cmp edx, byte 32h
        jl near LoadGameState.23
        mov ebp, dword [dword esp+0104h]
        xor ecx, ecx
        mov dword [dword esp+010Ch], ecx
.27:
        mov esi, ebp
        mov ebx, 3
        mov eax, dword [dword esp+010Ch]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        mov edi, eax
        shl edi, 3
        add edi, eax
        add edi, edi
        mov eax, dword [dword esp+010Ch]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        mov ebx, edx
        shl ebx, 2
        sub ebx, edx
        add ebp, byte 6
        lea edi, [dword edi+ebx*2+hmglstats]
        movsd
        movsw
        mov esi, dword [dword esp+010Ch]
        inc esi
        mov dword [dword esp+010Ch], esi
        cmp esi, byte 6
        jl short LoadGameState.27
        cmp byte [pad1dev], 1
        je short .28
        cmp byte [pad2dev], 1
        jne short .29
.28:
        push byte 64h
        push dword 0A0h
        call MouseSetPos
        add esp, byte 8
.29:
        mov eax, dword [gamemode]
        cmp eax, byte 1
        jb short .30
        jbe short .31
        cmp eax, byte 2
        je short .32
        jmp short .34
.30:
        test eax, eax
        jne short .34
        mov eax, exhstate
        call SaveModeState
        mov eax, exhstate
        jmp short .33
.31:
        mov eax, postate
        call SaveModeState
        mov eax, postate
        jmp short .33
.32:
        mov eax, lgstate
        call SaveModeState
        mov eax, lgstate
.33:
        call LoadModeState
.34:
        call GetPeriodTime
        mov word [PerTimeTotal], ax
        mov eax, 1
        call LoadGameTeams
        mov edx, dword [VisTeam-2]
        sar edx, 10h
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        mov ebx, gamepal
        call LoadTeamPalette
        mov ebp, 1
        mov dword [DeskRedrawFlag], ebp
        mov dword [DeskRedrawAll], ebp
        xor edx, edx
        mov dword [hudhundstep], edx
        call LoadRockMusic
        mov ecx, 17h
        mov edx, 0FFFFFFFFh
        mov eax, photobanks
        call __STOSD
        mov ebx, 0FFFFFFFFh
        mov dword [photobankf], ebx
        call LoadGameGfx
        mov ecx, 17h
        xor edx, edx
        mov eax, photobanks
        call __STOSD
        xor ecx, ecx
        mov dword [photobankf], ecx
        mov eax, dword [ovlseq-2]
        sar eax, 10h
        cmp eax, ebx
        je short .35
        mov edx, dword [ovlstep-2]
        sar edx, 10h
        cmp edx, ebx
        je short .35
        mov eax, dword [nosplit eax*4+ovlscripts]
        mov dword [ovlscript], eax
.35:
        call BuildEventLines
        mov eax, dword [replaystart]
        mov dword [recbpr], eax
        call ReplayRecordReset
        and byte [sflags], 0EFh
        mov word [fadeinpending], 1
        mov dword [hmtmsort], SortCords
        mov dword [hmtmplattr], hmplattr
        mov dword [hmtmglattr], hmglattr
        mov dword [hmtmlines], hmlinetab
        mov dword [hmtmplstats], hmplstats
        mov dword [hmtmglstats], hmglstats
        mov dword [hmtmroster], hmroster
        mov dword [hmtmptrF2], hmteamrec
        mov dword [awtmsort], SortCords+300h
        mov dword [awtmplattr], awplattr
        mov dword [awtmglattr], awglattr
        mov dword [awtmlines], awlinetab
        mov dword [awtmplstats], awplstats
        mov dword [awtmglstats], awglstats
        mov dword [awtmroster], awroster
        mov dword [awtmptrF2], awteamrec
        mov ebx, SortCords
        xor ebp, ebp
        mov dword [dword esp+010Ch], ebp
.36:
        mov eax, dword [dword esp+010Ch]
        mov word [byte ebx+06Ah], ax
        mov eax, dword [dword esp+010Ch]
        mov esi, eax
        shl esi, 3
        add esi, eax
        mov ax, word [nosplit esi*2+ObjInitFrame]
        mov word [byte ebx+066h], ax
        mov ax, word [nosplit esi*2+ObjInitAttr]
        mov word [byte ebx+068h], ax
        test byte [byte ebx+044h], 40h
        je short .37
        mov eax, awtmstruct
        jmp short .38
.37:
        mov eax, hmtmstruct
.38:
        mov dword [byte ebx+06Ch], eax
        test byte [byte ebx+044h], 40h
        jne short .39
        mov eax, awtmstruct
        jmp short .40
.39:
        mov eax, hmtmstruct
.40:
        mov dword [byte ebx+070h], eax
        mov eax, dword [ebx]
        mov dword [byte ebx+074h], eax
        mov eax, dword [byte ebx+04h]
        mov dword [byte ebx+078h], eax
        mov eax, dword [byte ebx+08h]
        mov dword [byte ebx+07Ch], eax
        mov eax, dword [dword esp+010Ch]
        mov dl, byte [dword esp+010Ch]
        mov byte [dword eax+OOlist], dl
        mov edx, dword [dword esp+010Ch]
        mov word [nosplit eax*2+OOlistpos], dx
        inc eax
        mov dword [dword esp+010Ch], eax
        add ebx, 80h
        cmp eax, byte 11h
        jl near LoadGameState.36
        call SprSort
        xor ebx, ebx
        mov dword [dword esp+010Ch], ebx
.41:
        mov ebx, dword [dword esp+010Ch]
        lea edi, [nosplit ebx*8+hudpenhome]
        lea esi, [dword esp+ebx*8+0C0h]
        movsd
        movsd
        lea edi, [nosplit ebx*8+hudpenaway]
        lea esi, [dword esp+ebx*8+080h]
        movsd
        movsd
        lea ecx, [byte ebx+01h]
        mov dword [dword esp+010Ch], ecx
        cmp ecx, byte 8
        jl short LoadGameState.41
        xor eax, eax
        add esp, 110h
        jmp near SaveGameState_popx
