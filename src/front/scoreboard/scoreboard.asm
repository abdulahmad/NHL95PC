; The scoreboard drawn during a game: the score, the clock, the line energy and penalty bars,
; and the Stanley Cup final series. One module: the panel functions share UpdateHudPanel's exit.
bits 32
%include "hockey.inc"
section s_14A20 progbits alloc exec nowrite align=1
extern __CHK, _dos_close_, _dos_creat_, _dos_getdiskfree_, _dos_open_, _dos_read_, _dos_write_, awlineind
extern awpanelspr, awscore, awtmline, awtmstruct, awayremap, awayremap_e43, awayremap_eFF, homeremap
extern homeremap_e43, homeremap_eFF, cddriveptr, clockcolon, clockdigits, cont2team, crestnames, ctlavailmask
extern cupseries, curleague, demomode, DemoSetupStub, demoteammode, awlineenergies, hmlineenergies, panelprevmin
extern panelprevsec, panelprevhund, panelhund, hmpanellines, awpanellines, hmpanelpens, awpanelpens, hmlinetimer
extern awlinetimer, demomatchups_m1, demomatchups, demoflag, PenaltyBlankDigit, energywarn, exhstate, FadeOutPalCycle
extern FatalError, fileoncd, FreeMemBlock, Gameloop, gamemode, gameopts, gamepal, gameresult
extern GetPeriodTime, gmode, hmlineind, hmpanelspr, hmscore, hmtmline, hmtmstruct, HomeTeam
extern hudawayline, hudclockhund, hudclockmin, hudclocksec, hudhomeline, hudhundstep, hudpenaway, hudpenhome
extern InitGameSummary, InputInstall, InputRemove, introskipped, j_unlink_, joyq_flush, lcblink, lcboxon
extern lcline, leaguedbnames, linesprites, LoadModeState, LoadRink, LoadRockMusic, LoadScheduleDB, LoadTeamPalette
extern lseek_, MakePath, MessageBox, mousebtns, mousepollfn, MouseSetPos, msg_NeedKbytes, musicon
extern msg_GameDiskSpace, hudotname, PaPreloadClips, penaltydigits, perioddigits, PerTimeTab, PollKey, rand_
extern randomd0, ReloadGameGfx, rmdir_, scoredigits, seed, SelectRinkBM, SelectScreenBM, SeriesLength
extern SetScreenSize, SetupControllers, SetupDemoGame, ShowLoadingScreen, sprintf_, str_backslash2, str_Crests4, str_dot
extern str_ErrDiskFree4, str_ErrDiskFree5, str_GsummaryDb, str_NeedKbytesFmt, str_PPV, str_Scrbrd2, str_Srb3, str_Stanley
extern str_star, strcat_, strcpy_, AllocMemBlock, OpenArtArchiveErr, FillRect, FindShape, ReadJoyRaw
extern VgaBlitKeyed, VgaBlitKeyedAtOwnPos, SetColorRemap, VgaBlitRemap, teamabbrevs, teamdivflags, TeamLineEnergy, _dos_findfirst_
extern _dos_findnext_, VisTeam, lcsel_aw
global DrawPanelScore, DrawPanelLine, DrawPanelLine_x, GetLineEnergies, PanelAddPenalty, PanelRemovePenalty, UpdateHudPanel, UpdateHudPanel_x
global DrawPanelClock, DrawHudPanel, TickPanelClock, DrawPanelClockDigits, TickPanelPenalties, DrawEnergyBar, DrawLineGroupBars, DrawPanelPenalties
global LoadCupFinalSeries, IsCupClinched, CupSeriesWinner
;-----------------------------------------------------------------------------
; DrawPanelScore                               14A20  95 PC, medium confidence
; (side, score): on the screen bitmap draws the score mod 100 as two digit
; shapes (scoredigits) at x 0FFh / 109h (side 1) or 2Eh / 38h (side 0), y 4
;-----------------------------------------------------------------------------
; C: src/front/scoreboard/DrawPanelScore.c
%ifdef CBUILD
%include "c/front/scoreboard/DrawPanelScore.inc"
%else
DrawPanelScore:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push esi
        mov ebx, eax
        mov esi, edx
        cmp dx, byte 64h
        jl short .1
        mov ecx, 64h
        mov eax, edx
        cwd
        idiv cx
        mov esi, edx
.1:
        call SelectScreenBM
        test bx, bx
        je short .4
        push byte 4
        push dword 0FFh
        cmp si, byte 0Ah
        jge short .2
        mov eax, 0Ah
        jmp short .3
.2:
        movsx edx, si
        mov ebx, 0Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
.3:
        mov ecx, dword [nosplit eax*4+scoredigits]
        push ecx
        call VgaBlitKeyed
        add esp, byte 0Ch
        push byte 4
        push dword 109h
        movsx edx, si
        mov ebx, 0Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov esi, dword [nosplit edx*4+scoredigits]
        push esi
        jmp short .7
.4:
        push byte 4
        push byte 2Eh
        cmp si, byte 0Ah
        jge short .5
        mov eax, 0Ah
        jmp short .6
.5:
        movsx edx, si
        mov ebx, 0Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
.6:
        mov edx, dword [nosplit eax*4+scoredigits]
        push edx
        call VgaBlitKeyed
        add esp, byte 0Ch
        push byte 4
        push byte 38h
        movsx edx, si
        mov ebx, 0Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov ebx, dword [nosplit edx*4+scoredigits]
        push ebx
.7:
        call VgaBlitKeyed
        add esp, byte 0Ch
        call SelectRinkBM
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawPanelLine                                14AFE  95 PC, medium confidence
; (side, line): draws the line indicator shape (linesprites[line]) at x 0FBh
; (side 1) or 2Ah (side 0), y 14h, saves it in hudawayline / hudhomeline
;
; and resets the side's energy-bar state when the line moves between the
; groups 0-3, 4-5, 6+; called from the line-change code (chk4lc, puckfaceoff)
;-----------------------------------------------------------------------------
; C: src/front/scoreboard/DrawPanelLine.c
%ifdef CBUILD
%include "c/front/scoreboard/DrawPanelLine.inc"
%else
DrawPanelLine:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        mov ebx, eax
        call SelectScreenBM
        test bx, bx
        je short .3
        mov ebp, dword [hudawayline]
        cmp ebp, byte 4
        setl al
        mov ebx, eax
        and ebx, 0FFh
        cmp dx, byte 4
        setl al
        and eax, 0FFh
        xor eax, ebx
        jne short .1
        cmp ebp, byte 6
        setl al
        mov ebx, eax
        and ebx, 0FFh
        cmp dx, byte 6
        setl al
        and eax, 0FFh
        xor eax, ebx
        je short .2
.1:
        xor ecx, ecx
        mov dword [awlinetimer], ecx
.2:
        movsx eax, dx
        mov dword [hudawayline], eax
        push byte 14h
        push dword 0FBh
        mov esi, dword [nosplit eax*4+linesprites]
        push esi
        jmp short .6
.3:
        cmp dword [hudhomeline], byte 4
        setl al
        mov ebx, eax
        and ebx, 0FFh
        cmp dx, byte 4
        setl al
        and eax, 0FFh
        xor eax, ebx
        jne short .4
        cmp dword [hudhomeline], byte 6
        setl al
        mov ebx, eax
        and ebx, 0FFh
        cmp dx, byte 6
        setl al
        and eax, 0FFh
        xor eax, ebx
        je short .5
.4:
        xor esi, esi
        mov dword [hmlinetimer], esi
.5:
        movsx eax, dx
        mov dword [hudhomeline], eax
        push byte 14h
        push byte 2Ah
        mov edi, dword [nosplit eax*4+linesprites]
        push edi
.6:
        call VgaBlitKeyed
        add esp, byte 0Ch
        call SelectRinkBM
DrawPanelLine_x:
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; GetLineEnergies                              14BEF  95 PC, medium confidence
; (team, out[8]): TeamLineEnergy of the 8 lines minus 60h
;-----------------------------------------------------------------------------
; C: src/front/scoreboard/GetLineEnergies.c
%ifdef CBUILD
%include "c/front/scoreboard/GetLineEnergies.inc"
%else
GetLineEnergies:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push esi
        mov ecx, eax
        mov esi, edx
        xor ebx, ebx
.1:
        movsx edx, bx
        movsx eax, cx
        call TeamLineEnergy
        movsx edx, ax
        mov eax, ebx
        sub edx, byte 60h
        mov dword [esi+eax*4], edx
        inc ebx
        cmp ebx, byte 8
        jl short GetLineEnergies.1
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; PanelAddPenalty                              14C22  95 PC, medium confidence
; (side, player, time): puts the penalty in the first free (-1) slot of the
; 8-entry panel list (hudpenhome / hudpenaway) and flags the side
;
; for a redraw; called from the penalty code (InProgress)
;-----------------------------------------------------------------------------
; C: src/front/scoreboard/PanelAddPenalty.c
%ifdef CBUILD
%include "c/front/scoreboard/PanelAddPenalty.inc"
%else
PanelAddPenalty:
        push dword 10h
        call __CHK
        push ecx
        push esi
        push edi
        mov ecx, eax
        mov edi, edx
        mov esi, ebx
        xor edx, edx
        mov dword [hmlinetimer], edx
        mov dword [awlinetimer], edx
        test ax, ax
        je short .1
        mov eax, hudpenaway
        jmp short .2
.1:
        mov eax, hudpenhome
.2:
        xor edx, edx
        jmp short .6
.3:
        movsx ebx, word [eax]
        cmp ebx, byte 0FFFFFFFFh
        jne short .5
        mov word [eax], di
        mov word [byte eax+02h], si
        mov word [byte eax+06h], 0
        mov dx, word [byte eax+06h]
        mov word [byte eax+04h], dx
        test cx, cx
        je short .4
        xor esi, esi
        mov dword [awpanellines], esi
        pop edi
        pop esi
        pop ecx
        ret
.4:
        xor ecx, ecx
        mov dword [hmpanellines], ecx
        pop edi
        pop esi
        pop ecx
        ret
.5:
        add eax, byte 8
        inc edx
.6:
        cmp dx, byte 8
        jl short PanelAddPenalty.3
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; PanelRemovePenalty                           14CA0  95 PC, medium confidence
; (side, player): clears the time of that player's panel penalty entry;
; called when a player leaves the box (PenGoalStuff after releasepl)
;-----------------------------------------------------------------------------
; C: src/front/scoreboard/PanelRemovePenalty.c
%ifdef CBUILD
%include "c/front/scoreboard/PanelRemovePenalty.inc"
%else
PanelRemovePenalty:
        push dword 0Ch
        call __CHK
        push ebx
        push ecx
        mov ecx, edx
        test ax, ax
        je short .1
        mov eax, hudpenaway
        jmp short .2
.1:
        mov eax, hudpenhome
.2:
        xor ebx, ebx
        xor edx, edx
        jmp short .5
.3:
        cmp cx, word [eax]
        jne short .4
        mov ebx, eax
        jmp short .6
.4:
        add eax, byte 8
        inc edx
.5:
        cmp dx, byte 8
        jl short PanelRemovePenalty.3
.6:
        test ebx, ebx
        je short .x
        mov word [byte ebx+06h], 0
        mov ax, word [byte ebx+06h]
        mov word [byte ebx+04h], ax
        mov word [byte ebx+02h], ax
.x:
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; UpdateHudPanel                               14CF1  95 PC, medium confidence
; Per-frame redraw of the PC top panel on the screen bitmap: line energies
; (GetLineEnergies, DrawEnergyBar bars), line indicators, penalty lists
;
; (DrawLineGroupBars), clock; called from GameLoop, the engine and game_f
;-----------------------------------------------------------------------------
; C: src/front/scoreboard/UpdateHudPanel.c
%ifdef CBUILD
%include "c/front/scoreboard/UpdateHudPanel.inc"
%else
UpdateHudPanel:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        call SelectScreenBM
        cmp dword [hudclockmin], byte 0
        jl near UpdateHudPanel_x
        mov eax, dword [hudhundstep]
        mov dword [panelhund], eax
        xor ebx, ebx
        mov dword [hudhundstep], ebx
        call TickPanelClock
        test eax, eax
        je short .1
        test byte [gmode], 10h
        jne short .1
        mov edx, dword [panelhund]
        mov eax, hudpenhome
        call TickPanelPenalties
        mov edx, dword [panelhund]
        mov eax, hudpenaway
        call TickPanelPenalties
.1:
        mov edx, hmlineenergies
        xor eax, eax
        call GetLineEnergies
        mov edx, awlineenergies
        mov eax, 1
        call GetLineEnergies
        call DrawPanelClockDigits
        mov edx, dword [hudhomeline]
        mov ebx, 1F4h
        mov eax, dword [nosplit edx*4+hmlineenergies]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        mov edx, 2Bh
        call DrawEnergyBar
        mov edx, dword [hudawayline]
        mov eax, dword [nosplit edx*4+awlineenergies]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        mov edx, 0FCh
        call DrawEnergyBar
        cmp word [lcboxon], byte 0
        jne short .2
        cmp dword [hmpanellines], byte 0
        jne short .2
        test byte [gmode], 10h
        je short .3
.2:
        push byte 4Ah
        mov ebx, dword [hudhomeline]
        mov ecx, hmlineenergies
        mov edx, hmlineind
        mov eax, hmlinetimer
        call DrawLineGroupBars
        xor ecx, ecx
        mov dword [hmpanelpens], ecx
        jmp short .6
.3:
        cmp word [hudpenhome], byte 0
        jge short .4
        mov dword [hmpanellines], 1
        push byte 4Ah
        mov ebx, dword [hudhomeline]
        mov ecx, hmlineenergies
        mov edx, hmlineind
        mov eax, hmlinetimer
        call DrawLineGroupBars
        xor ebx, ebx
        mov dword [hmpanelpens], ebx
        jmp short .6
.4:
        cmp dword [hmpanelpens], byte 0
        jne short .5
        mov edi, dword [hmpanelspr]
        push edi
        call VgaBlitKeyedAtOwnPos
        add esp, byte 4
        mov dword [hmpanelpens], 1
.5:
        mov edx, 48h
        mov eax, hudpenhome
        call DrawPanelPenalties
        xor eax, eax
        mov dword [hmlinetimer], eax
.6:
        cmp word [lcboxon+2], byte 0
        jne short .7
        cmp dword [awpanellines], byte 0
        jne short .7
        test byte [gmode], 10h
        je short .8
.7:
        push dword 0C1h
        mov ebx, dword [hudawayline]
        mov ecx, awlineenergies
        mov edx, awlineind
        mov eax, awlinetimer
        call DrawLineGroupBars
        xor esi, esi
        mov dword [awpanelpens], esi
        jmp near UpdateHudPanel_x
.8:
        cmp word [hudpenaway], byte 0
        jge short .9
        mov dword [awpanellines], 1
        push dword 0C1h
        mov ebx, dword [hudawayline]
        mov ecx, awlineenergies
        mov edx, awlineind
        mov eax, awlinetimer
        call DrawLineGroupBars
        xor ecx, ecx
        mov dword [awpanelpens], ecx
        jmp short UpdateHudPanel_x
.9:
        cmp dword [awpanelpens], byte 0
        jne short .10
        mov ebp, dword [awpanelspr]
        push ebp
        call VgaBlitKeyedAtOwnPos
        add esp, byte 4
        mov dword [awpanelpens], 1
.10:
        mov edx, 0BFh
        mov eax, hudpenaway
        call DrawPanelPenalties
        xor edx, edx
        mov dword [awlinetimer], edx
UpdateHudPanel_x:
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawPanelClock                               14F31  95 PC, medium confidence
; Draws the clock digits (clockdigits shapes, separator clockcolon at x 0AAh)
; from hudclockmin / hudclocksec
;
; and saves them in panelprevmin / panelprevsec; called from the scoreboard
; segment
;-----------------------------------------------------------------------------
; C: src/front/scoreboard/UpdateHudPanel.c (DrawPanelClock)
%ifdef CBUILD
%include "c/front/scoreboard/UpdateHudPanel.DrawPanelClock.inc"
%else
DrawPanelClock:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov edx, dword [hudclockmin]
        test edx, edx
        jne near .3
        push byte 3
        push dword 0AAh
        mov edx, dword [clockcolon]
        push edx
        call VgaBlitKeyed
        add esp, byte 0Ch
        cmp dword [hudclocksec], byte 0Ah
        jge short .1
        push byte 3
        push dword 8Ch
        mov esi, dword [clockcolon]
        push esi
        jmp short .2
.1:
        push byte 3
        push dword 8Ch
        mov ebx, 0Ah
        mov eax, dword [hudclocksec]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        mov ecx, dword [nosplit eax*4+clockdigits]
        push ecx
.2:
        call VgaBlitKeyed
        add esp, byte 0Ch
        push byte 3
        push dword 95h
        mov ebx, 0Ah
        mov eax, dword [hudclocksec]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        mov edi, dword [nosplit edx*4+clockdigits]
        push edi
        call VgaBlitKeyed
        add esp, byte 0Ch
        push byte 3
        push dword 0A1h
        mov ebx, 0Ah
        mov eax, dword [hudclockhund]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        mov ebp, dword [nosplit eax*4+clockdigits]
        push ebp
        jmp near .6
.3:
        cmp edx, byte 0Ah
        jge short .4
        push byte 3
        push dword 8Ch
        mov esi, dword [clockcolon]
        push esi
        jmp short .5
.4:
        push byte 3
        push dword 8Ch
        mov ebx, 0Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov ecx, dword [nosplit eax*4+clockdigits]
        push ecx
.5:
        call VgaBlitKeyed
        add esp, byte 0Ch
        push byte 3
        push dword 95h
        mov ebx, 0Ah
        mov eax, dword [hudclockmin]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        mov edi, dword [nosplit edx*4+clockdigits]
        push edi
        call VgaBlitKeyed
        add esp, byte 0Ch
        push byte 3
        push dword 0A1h
        mov ebx, 0Ah
        mov eax, dword [hudclocksec]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        mov ebp, dword [nosplit eax*4+clockdigits]
        push ebp
        call VgaBlitKeyed
        add esp, byte 0Ch
        push byte 3
        push dword 0AAh
        mov ebx, 0Ah
        mov eax, dword [hudclocksec]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        mov eax, dword [nosplit edx*4+clockdigits]
        push eax
.6:
        call VgaBlitKeyed
        add esp, byte 0Ch
        mov eax, dword [hudclockmin]
        mov dword [panelprevmin], eax
        mov eax, dword [hudclocksec]
        mov dword [panelprevsec], eax
        mov eax, dword [hudclockhund]
        mov dword [panelprevhund], eax
        jmp near UpdateHudPanel_x
%endif ; C
;-----------------------------------------------------------------------------
; DrawHudPanel                                 150C6  95 PC, medium confidence
; (home, visitor, period, resetclock): full redraw of the PC top panel on the
; screen bitmap: optionally sets the panel clock from GetPeriodTime,
;
; resets the panel state, draws the scrbrd2.PPV "srb3" background, both scores
; (DrawPanelScore), the clock (DrawPanelClock), the period number (shapes
; "3000".. from perioddigits, or "OT" from hudotname), the two team crests
;
; from crests4.PPV (crestnames names "BOS " ...) and the line indicators;
; called by GameLoop, PlayGame, SetupGame, RunDemoGame
;-----------------------------------------------------------------------------
; C: src/front/scoreboard/DrawHudPanel.c
%ifdef CBUILD
%include "c/front/scoreboard/DrawHudPanel.inc"
%else
DrawHudPanel:
        push dword 34h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 14h
        push eax
        mov ebp, edx
        mov esi, ebx
        test ecx, ecx
        je short .1
        call GetPeriodTime
        cwde
        mov dword [hudclocksec], eax
        mov dword [hudclockmin], eax
        mov ebx, 3Ch
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        mov dword [hudclockmin], eax
        mov eax, dword [hudclocksec]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        mov dword [hudclocksec], edx
        xor edx, edx
        mov dword [hudclockhund], edx
.1:
        xor ebx, ebx
        mov dword [panelhund], ebx
        mov dword [awpanellines], ebx
        mov dword [hmpanellines], ebx
        mov eax, dword [hmtmline-2]
        sar eax, 10h
        mov dword [hudhomeline], eax
        mov eax, dword [awtmline-2]
        sar eax, 10h
        mov dword [hudawayline], eax
        mov dword [awpanelpens], ebx
        mov dword [hmpanelpens], ebx
        mov dword [awlinetimer], ebx
        mov dword [hmlinetimer], ebx
        call SelectScreenBM
        mov ecx, str_PPV
        mov ebx, str_Scrbrd2
        cmp byte [fileoncd+016Dh], 1
        jne short .2
        mov edx, dword [cddriveptr]
        jmp short .3
.2:
        xor edx, edx
.3:
        lea eax, [byte esp+04h]
        call MakePath
        push byte 0
        lea eax, [byte esp+08h]
        push eax
        call OpenArtArchiveErr
        mov edi, eax
        add esp, byte 8
        mov dword [byte esp+014h], eax
        push str_Srb3
        push eax
        call FindShape
        add esp, byte 8
        push eax
        call VgaBlitKeyedAtOwnPos
        add esp, byte 4
        mov edx, dword [hmscore-2]
        sar edx, 10h
        xor eax, eax
        call DrawPanelScore
        mov edx, dword [awscore-2]
        sar edx, 10h
        mov eax, 1
        call DrawPanelScore
        call SelectScreenBM
        call DrawPanelClock
        test esi, esi
        jne short .4
        push byte 16h
        push dword 98h
        mov ecx, dword [hudotname]
        push ecx
        jmp short .5
.4:
        mov ebx, 64h
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ebx
        mov esi, edx
        push byte 16h
        push dword 98h
        mov ebx, 0Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov edx, dword [nosplit eax*4+perioddigits]
        push edx
        push edi
        call FindShape
        add esp, byte 8
        push eax
        call VgaBlitKeyed
        add esp, byte 0Ch
        push byte 16h
        push dword 0A0h
        mov ebx, 0Ah
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ebx
        mov ebx, dword [nosplit edx*4+perioddigits]
        push ebx
.5:
        push edi
        call FindShape
        add esp, byte 8
        push eax
        call VgaBlitKeyed
        add esp, byte 0Ch
        mov esi, dword [byte esp+014h]
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov ecx, str_PPV
        mov ebx, str_Crests4
        cmp byte [fileoncd+057h], 1
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
        mov esi, eax
        add esp, byte 8
        mov dh, 67h
        mov byte [homeremap_e43], dh
        mov byte [awayremap_e43], dh
        mov bh, 0FFh
        mov byte [awayremap_eFF], bh
        mov byte [homeremap_eFF], bh
        push homeremap
        call SetColorRemap
        add esp, byte 4
        push byte 4
        push byte 4
        mov eax, dword [byte esp+08h]
        mov edi, dword [nosplit eax*4+crestnames]
        push edi
        push esi
        call FindShape
        add esp, byte 8
        push eax
        call VgaBlitRemap
        add esp, byte 0Ch
        push awayremap
        call SetColorRemap
        add esp, byte 4
        push byte 4
        push dword 11Ch
        mov ebp, dword [nosplit ebp*4+crestnames]
        push ebp
        push esi
        call FindShape
        add esp, byte 8
        push eax
        call VgaBlitRemap
        add esp, byte 0Ch
        mov ch, 43h
        mov byte [homeremap_e43], ch
        mov byte [awayremap_e43], ch
        push esi
        call FreeMemBlock
        add esp, byte 4
        push byte 14h
        push byte 2Ah
        mov eax, dword [hudhomeline]
        mov edx, dword [nosplit eax*4+linesprites]
        push edx
        call VgaBlitKeyed
        add esp, byte 0Ch
        push byte 14h
        push dword 0FBh
        mov eax, dword [hudawayline]
        mov ebx, dword [nosplit eax*4+linesprites]
        push ebx
        call VgaBlitKeyed
        add esp, byte 0Ch
        add esp, byte 18h
        pop ebp
        pop edi
        pop esi
        ret
%endif ; C
;-----------------------------------------------------------------------------
; TickPanelClock                               15374  95 PC, medium confidence
; (hundredths): saves the drawn clock (hudclockmin / sec / hund ->
; panelprevmin..C5718) and counts the panel clock down; returns 0
;
; when it reaches 0:00, else 1 (UpdateHudPanel)
;-----------------------------------------------------------------------------
; C: src/front/scoreboard/TickPanelClock.c
%ifdef CBUILD
%include "c/front/scoreboard/TickPanelClock.inc"
%else
TickPanelClock:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov edx, dword [hudclockmin]
        mov dword [panelprevmin], edx
        mov edx, dword [hudclocksec]
        mov dword [panelprevsec], edx
        mov edx, dword [hudclockhund]
        mov dword [panelprevhund], edx
        sub edx, eax
        mov dword [hudclockhund], edx
        test edx, edx
        jge short .1
        lea ecx, [byte edx+064h]
        mov dword [hudclockhund], ecx
        mov esi, dword [hudclocksec]
        dec esi
        mov dword [hudclocksec], esi
        test esi, esi
        jge short .1
        mov dword [hudclocksec], 3Bh
        mov eax, dword [hudclockmin]
        dec eax
        mov dword [hudclockmin], eax
        test eax, eax
        jge short .1
        xor ebx, ebx
        mov dword [hudclockhund], ebx
        mov dword [hudclocksec], ebx
        mov dword [hudclockmin], ebx
        xor eax, eax
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        mov eax, 1
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawPanelClockDigits                         1540A  95 PC, medium confidence
; Redraws the clock digits (clockdigits, separator clockcolon) that changed
; since the last draw (UpdateHudPanel)
;-----------------------------------------------------------------------------
; C: src/front/scoreboard/UpdateHudPanel.c (DrawPanelClockDigits)
%ifdef CBUILD
%include "c/front/scoreboard/UpdateHudPanel.DrawPanelClockDigits.inc"
%else
DrawPanelClockDigits:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov edx, dword [hudclockmin]
        test edx, edx
        jne near .6
        cmp edx, dword [panelprevmin]
        je short .1
        push byte 3
        push dword 0AAh
        mov edi, dword [clockcolon]
        push edi
        call VgaBlitKeyed
        add esp, byte 0Ch
.1:
        mov eax, dword [panelprevsec]
        mov ebp, dword [hudclocksec]
        cmp eax, ebp
        je near .5
        mov ebx, 0Ah
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        mov ebx, eax
        mov ecx, 0Ah
        mov eax, ebp
        mov edx, ebp
        sar edx, 1Fh
        idiv ecx
        cmp ebx, eax
        je short .4
        cmp ebp, ecx
        jge short .2
        push byte 3
        push dword 8Ch
        mov ecx, dword [clockcolon]
        push ecx
        jmp short .3
.2:
        push byte 3
        push dword 8Ch
        mov ebx, dword [nosplit eax*4+clockdigits]
        push ebx
.3:
        call VgaBlitKeyed
        add esp, byte 0Ch
.4:
        mov ebx, 0Ah
        mov eax, dword [panelprevsec]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        mov ebx, edx
        mov ecx, 0Ah
        mov eax, dword [hudclocksec]
        mov edx, eax
        sar edx, 1Fh
        idiv ecx
        cmp ebx, edx
        je short .5
        push byte 3
        push dword 95h
        mov esi, dword [nosplit edx*4+clockdigits]
        push esi
        call VgaBlitKeyed
        add esp, byte 0Ch
.5:
        mov ebx, 0Ah
        mov eax, dword [panelprevhund]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        mov ebx, eax
        mov ecx, 0Ah
        mov eax, dword [hudclockhund]
        mov edx, eax
        sar edx, 1Fh
        idiv ecx
        cmp ebx, eax
        je near UpdateHudPanel_x
        push byte 3
        push dword 0A1h
        mov edi, dword [nosplit eax*4+clockdigits]
        push edi
        jmp near .12
.6:
        mov eax, dword [panelprevmin]
        cmp eax, edx
        je near .10
        mov ebx, 0Ah
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        mov ebx, eax
        mov ecx, 0Ah
        mov eax, dword [hudclockmin]
        mov edx, eax
        sar edx, 1Fh
        idiv ecx
        cmp ebx, eax
        je short .9
        cmp dword [hudclockmin], byte 0Ah
        jge short .7
        push byte 3
        push dword 8Ch
        mov edi, dword [clockcolon]
        push edi
        jmp short .8
.7:
        push byte 3
        push dword 8Ch
        mov esi, dword [nosplit eax*4+clockdigits]
        push esi
.8:
        call VgaBlitKeyed
        add esp, byte 0Ch
.9:
        mov ebx, 0Ah
        mov eax, dword [panelprevmin]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        mov ebx, edx
        mov ecx, 0Ah
        mov eax, dword [hudclockmin]
        mov edx, eax
        sar edx, 1Fh
        idiv ecx
        cmp ebx, edx
        je short .10
        push byte 3
        push dword 95h
        mov ebp, dword [nosplit edx*4+clockdigits]
        push ebp
        call VgaBlitKeyed
        add esp, byte 0Ch
.10:
        mov eax, dword [panelprevsec]
        cmp eax, dword [hudclocksec]
        je near UpdateHudPanel_x
        mov ebx, 0Ah
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        mov ebx, eax
        mov ecx, 0Ah
        mov eax, dword [hudclocksec]
        mov edx, eax
        sar edx, 1Fh
        idiv ecx
        cmp ebx, eax
        je short .11
        push byte 3
        push dword 0A1h
        mov ebx, dword [nosplit eax*4+clockdigits]
        push ebx
        call VgaBlitKeyed
        add esp, byte 0Ch
.11:
        mov ebx, 0Ah
        mov eax, dword [panelprevsec]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        mov ebx, edx
        mov ecx, 0Ah
        mov eax, dword [hudclocksec]
        mov edx, eax
        sar edx, 1Fh
        idiv ecx
        cmp ebx, edx
        je near UpdateHudPanel_x
        push byte 3
        push dword 0AAh
        mov ecx, dword [nosplit edx*4+clockdigits]
        push ecx
.12:
        call VgaBlitKeyed
        add esp, byte 0Ch
        jmp near UpdateHudPanel_x
%endif ; C
;-----------------------------------------------------------------------------
; TickPanelPenalties                           15655  95 PC, medium confidence
; (penalty list, hundredths): counts down the first two entries (min / sec /
; hund at +2 / +4 / +6), frees an expired entry (-1) and packs the list;
;
; UpdateHudPanel calls it for hudpenhome / hudpenaway
;-----------------------------------------------------------------------------
; C: src/front/scoreboard/DrawPanelLine.c (TickPanelPenalties)
%ifdef CBUILD
%include "c/front/scoreboard/DrawPanelLine.TickPanelPenalties.inc"
%else
TickPanelPenalties:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        mov ecx, eax
        xor ebp, ebp
.1:
        mov eax, ebp
        shl eax, 3
        add eax, ecx
        mov bx, word [byte eax+06h]
        sub ebx, edx
        mov word [byte eax+06h], bx
        test bx, bx
        jge short .2
        mov edi, ebx
        add edi, byte 64h
        mov word [byte eax+06h], di
        mov bx, word [byte eax+04h]
        dec ebx
        mov word [byte eax+04h], bx
        test bx, bx
        jge short .2
        mov word [byte eax+04h], 3Bh
        mov di, word [byte eax+02h]
        dec edi
        mov word [byte eax+02h], di
        test di, di
        jge short .2
        mov word [byte eax+02h], 0
        mov word [byte eax+04h], 0
        mov word [byte eax+06h], 0
        mov word [eax], 0FFFFh
.2:
        inc ebp
        cmp ebp, byte 2
        jl short TickPanelPenalties.1
        xor ebp, ebp
.3:
        mov eax, ebp
        cmp word [ecx+eax*8], byte 0
        jge short .7
        mov ebx, ebp
        lea edx, [byte ebp+01h]
        jmp short .6
.4:
        mov eax, edx
        shl eax, 3
        add eax, ecx
        cmp word [eax], byte 0
        jl short .5
        mov edi, ebx
        shl edi, 3
        add edi, ecx
        mov esi, eax
        movsd
        movsd
        mov word [eax], 0FFFFh
        inc ebx
.5:
        inc edx
.6:
        cmp edx, byte 8
        jl short TickPanelPenalties.4
.7:
        inc ebp
        cmp ebp, byte 7
        jl short TickPanelPenalties.3
        jmp near DrawPanelLine_x
%endif ; C
;-----------------------------------------------------------------------------
; DrawEnergyBar                                15707  95 PC, medium confidence
; (level, x): draws a two-column energy bar (FillRect rectangles, 1Ah high) at
; x; colour 67h, or 0 / 7 while the side's energywarn flag is set
;
; (UpdateHudPanel, current line energy / 500) The 0/7 colours are used while
; energywarn[side] is set.
;-----------------------------------------------------------------------------
; C: src/front/scoreboard/DrawPanelLine.c (DrawEnergyBar)
%ifdef CBUILD
%include "c/front/scoreboard/DrawPanelLine.DrawEnergyBar.inc"
%else
DrawEnergyBar:
        push dword 38h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 0Ch
        mov esi, eax
        mov edi, edx
        cmp edx, 0A0h
        setg al
        mov ebp, eax
        and ebp, 0FFh
        add ebp, ebp
        cmp word [dword ebp+energywarn], byte 0
        je short .1
        xor ebx, ebx
        mov dword [byte esp+08h], ebx
        mov ebp, 7
        jmp short .2
.1:
        mov dword [byte esp+08h], 67h
        xor ebp, ebp
.2:
        mov ecx, dword [byte esp+08h]
        push ecx
        push byte 3
        push esi
        push byte 1Ah
        lea eax, [byte edi+09h]
        sub eax, esi
        push eax
        call FillRect
        add esp, byte 14h
        mov eax, dword [byte esp+08h]
        push eax
        push byte 3
        push esi
        push byte 1Ah
        lea eax, [byte edi+010h]
        mov dword [byte esp+010h], eax
        push eax
        call FillRect
        add esp, byte 14h
        push ebp
        push byte 3
        mov eax, 8
        sub eax, esi
        mov dword [byte esp+0Ch], eax
        push eax
        push byte 1Ah
        inc edi
        push edi
        call FillRect
        add esp, byte 14h
        push ebp
        push byte 3
        mov ecx, dword [byte esp+0Ch]
        push ecx
        push byte 1Ah
        add esi, dword [byte esp+010h]
        push esi
        call FillRect
        add esp, byte 14h
        add esp, byte 0Ch
        jmp near DrawPanelLine_x
%endif ; C
;-----------------------------------------------------------------------------
; DrawLineGroupBars                            157BD  95 PC, medium confidence
; Draws the energy bars of the current line group (lines 0-3, 4-5 or 6-7,
; picking the group art once), the current line in colour 21h
;
; and the line-change selection (lcboxon / lcsel) blinking (lcblink); x > 0A0h
; is the right side (UpdateHudPanel)
;-----------------------------------------------------------------------------
; C: src/front/scoreboard/DrawLineGroupBars.c
%ifdef CBUILD
%include "c/front/scoreboard/DrawLineGroupBars.inc"
%else
DrawLineGroupBars:
        push dword 4Ch
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 28h
        mov esi, eax
        mov dword [byte esp+014h], ebx
        mov dword [byte esp+010h], ecx
        cmp dword [byte esp+038h], 0A0h
        setg al
        movzx ebp, al
        mov dword [byte esp+0Ch], ebp
        add ebp, ebp
        cmp word [dword ebp+lcboxon], byte 0
        je short .1
        mov ebp, dword [dword ebp+lcline-2]
        sar ebp, 10h
        jmp short .2
.1:
        mov ebp, dword [byte esp+014h]
.2:
        mov dword [byte esp+01Ch], ebp
        mov ecx, dword [byte esp+01Ch]
        cmp ecx, byte 4
        jb short .3
        cmp ecx, byte 5
        jbe short .5
        cmp ecx, byte 7
        jbe short .7
        jmp near .9
.3:
        cmp dword [esi], byte 0
        jne short .4
        mov ebp, dword [edx]
        push ebp
        call VgaBlitKeyedAtOwnPos
        add esp, byte 4
        mov dword [esi], 1
.4:
        mov edi, 8
        xor eax, eax
        mov dword [byte esp+08h], eax
        mov dword [byte esp+018h], 4
        jmp short .9
.5:
        cmp dword [esi], byte 0
        jne short .6
        mov ebx, dword [byte edx+04h]
        push ebx
        call VgaBlitKeyedAtOwnPos
        add esp, byte 4
        mov dword [esi], 1
.6:
        mov edi, 0Eh
        mov dword [byte esp+08h], 4
        mov dword [byte esp+018h], 6
        jmp short .9
.7:
        cmp dword [esi], byte 0
        jne short .8
        mov ecx, dword [byte edx+08h]
        push ecx
        call VgaBlitKeyedAtOwnPos
        add esp, byte 4
        mov dword [esi], 1
.8:
        mov edi, 0Eh
        mov dword [byte esp+08h], 6
        mov dword [byte esp+018h], 8
.9:
        mov ebp, dword [byte esp+08h]
        jmp near .15
.10:
        cmp ebp, dword [byte esp+01Ch]
        jne short .11
        mov edx, dword [byte esp+0Ch]
        cmp word [nosplit edx*2+lcblink], byte 0
        je short .11
        mov dword [byte esp+024h], 61h
        mov dword [byte esp+020h], 7
        jmp short .14
.11:
        cmp ebp, dword [byte esp+014h]
        jne short .12
        mov edx, 21h
        jmp short .13
.12:
        mov edx, 67h
.13:
        mov dword [byte esp+024h], edx
        xor eax, eax
        mov dword [byte esp+020h], eax
.14:
        mov edx, ebp
        shl edx, 2
        add edx, dword [byte esp+010h]
        mov esi, 0C8h
        mov eax, dword [edx]
        mov edx, eax
        sar edx, 1Fh
        idiv esi
        mov esi, eax
        mov eax, dword [byte esp+024h]
        push eax
        push byte 3
        push esi
        push edi
        mov edx, dword [byte esp+048h]
        add edx, byte 15h
        sub edx, esi
        push edx
        call FillRect
        add esp, byte 14h
        mov edx, dword [byte esp+024h]
        push edx
        push byte 3
        push esi
        push edi
        mov edx, dword [byte esp+048h]
        add edx, byte 20h
        mov dword [byte esp+010h], edx
        push edx
        call FillRect
        add esp, byte 14h
        mov ecx, dword [byte esp+020h]
        push ecx
        push byte 3
        mov edx, 14h
        sub edx, esi
        mov dword [byte esp+0Ch], edx
        push edx
        push edi
        mov edx, dword [byte esp+048h]
        inc edx
        push edx
        call FillRect
        add esp, byte 14h
        mov edx, dword [byte esp+020h]
        push edx
        push byte 3
        mov ebx, dword [byte esp+0Ch]
        push ebx
        push edi
        add esi, dword [byte esp+010h]
        push esi
        call FillRect
        add esp, byte 14h
        inc ebp
        add edi, byte 6
.15:
        cmp ebp, dword [byte esp+018h]
        jl near DrawLineGroupBars.10
        add esp, byte 28h
        pop ebp
        pop edi
        pop esi
        ret 4
%endif ; C
;-----------------------------------------------------------------------------
; DrawPanelPenalties                           15995  95 PC, medium confidence
; Draws up to 4 panel penalty entries per side: player number and time digits
; from the penaltydigits / PenaltyBlankDigit shapes (UpdateHudPanel)
;-----------------------------------------------------------------------------
; C: src/front/scoreboard/DrawPanelLine.c (DrawPanelPenalties)
%ifdef CBUILD
%include "c/front/scoreboard/DrawPanelLine.DrawPanelPenalties.inc"
%else
DrawPanelPenalties:
        push dword 2Ch
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        push eax
        mov edi, edx
        xor edx, edx
        mov dword [byte esp+04h], edx
        mov esi, 9
        jmp near .8
.1:
        mov eax, ebx
        shl eax, 3
        add eax, dword [esp]
        lea edx, [byte edi+0Ah]
        mov bx, word [eax]
        test bx, bx
        jl near .6
        cmp bx, byte 0Ah
        jge short .2
        push esi
        push edx
        mov ebx, dword [PenaltyBlankDigit]
        push ebx
        jmp short .3
.2:
        push esi
        push edx
        movsx edx, bx
        mov ebx, 0Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov edx, dword [nosplit eax*4+penaltydigits]
        push edx
.3:
        call VgaBlitKeyed
        add esp, byte 0Ch
        push esi
        lea eax, [byte edi+010h]
        push eax
        mov ebp, dword [byte esp+0Ch]
        shl ebp, 3
        add ebp, dword [byte esp+08h]
        movsx edx, word [byte ebp+00h]
        mov ebx, 0Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov edx, dword [nosplit edx*4+penaltydigits]
        push edx
        call VgaBlitKeyed
        add esp, byte 0Ch
        lea eax, [byte edi+01Bh]
        cmp word [byte ebp+02h], byte 0Ah
        jge short .4
        push esi
        push eax
        mov ecx, dword [PenaltyBlankDigit]
        push ecx
        jmp short .5
.4:
        push esi
        push eax
        mov edx, dword [byte ebp+00h]
        sar edx, 10h
        mov ebx, 0Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov ebx, dword [nosplit eax*4+penaltydigits]
        push ebx
.5:
        call VgaBlitKeyed
        add esp, byte 0Ch
        push esi
        lea eax, [byte edi+021h]
        push eax
        mov ebp, dword [byte esp+0Ch]
        shl ebp, 3
        add ebp, dword [byte esp+08h]
        mov edx, dword [byte ebp+00h]
        sar edx, 10h
        mov ebx, 0Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov edx, dword [nosplit edx*4+penaltydigits]
        push edx
        call VgaBlitKeyed
        add esp, byte 0Ch
        push esi
        lea eax, [byte edi+02Ah]
        push eax
        mov edx, dword [byte ebp+02h]
        sar edx, 10h
        mov ebx, 0Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov ebx, dword [nosplit eax*4+penaltydigits]
        push ebx
        call VgaBlitKeyed
        add esp, byte 0Ch
        push esi
        lea eax, [byte edi+030h]
        push eax
        mov edx, dword [byte ebp+02h]
        sar edx, 10h
        mov ebx, 0Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov ecx, dword [nosplit edx*4+penaltydigits]
        push ecx
        jmp short .7
.6:
        push esi
        push edx
        mov ebp, dword [PenaltyBlankDigit]
        push ebp
        call VgaBlitKeyed
        add esp, byte 0Ch
        push esi
        lea eax, [byte edi+010h]
        push eax
        mov eax, dword [PenaltyBlankDigit]
        push eax
        call VgaBlitKeyed
        add esp, byte 0Ch
        push esi
        lea eax, [byte edi+01Bh]
        push eax
        mov edx, dword [PenaltyBlankDigit]
        push edx
        call VgaBlitKeyed
        add esp, byte 0Ch
        push esi
        lea eax, [byte edi+021h]
        push eax
        mov ebx, dword [PenaltyBlankDigit]
        push ebx
        call VgaBlitKeyed
        add esp, byte 0Ch
        push esi
        lea eax, [byte edi+02Ah]
        push eax
        mov ecx, dword [PenaltyBlankDigit]
        push ecx
        call VgaBlitKeyed
        add esp, byte 0Ch
        push esi
        lea eax, [byte edi+030h]
        push eax
        mov ebp, dword [PenaltyBlankDigit]
        push ebp
.7:
        call VgaBlitKeyed
        add esp, byte 0Ch
        inc dword [byte esp+04h]
        add esi, byte 5
.8:
        mov ebx, dword [byte esp+04h]
        cmp ebx, byte 4
        jl near DrawPanelPenalties.1
        add esp, byte 8
        jmp near DrawPanelLine_x
%endif ; C
;-----------------------------------------------------------------------------
; LoadCupFinalSeries                           15B76  95 PC, medium confidence
; When Home and Visitor are in different conferences (teamdivflags 3 / 0Ch, so
; a Stanley Cup final game): allocates "Stanley" (2Ah bytes)
;
; and copies the 7 final-series games (SCHEDULE.DB +1BE4h) into cupseries,
; else cupseries = 0; called from PlayGame and key_team_db
;-----------------------------------------------------------------------------
; C: src/front/scoreboard/LoadCupFinalSeries.c
%ifdef CBUILD
%include "c/front/scoreboard/LoadCupFinalSeries.inc"
%else
LoadCupFinalSeries:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 4
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        mov edx, dword [VisTeam-2]
        sar edx, 10h
        mov eax, dword [nosplit eax*4+teamdivflags]
        or eax, dword [nosplit edx*4+teamdivflags]
        test al, 3
        je near .2
        test al, 0Ch
        je short .2
        push byte 20h
        push byte 2Ah
        push str_Stanley
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [cupseries], eax
        mov eax, esp
        call LoadScheduleDB
        mov eax, dword [esp]
        add eax, byte 2
        mov dword [esp], eax
        xor edx, edx
.1:
        lea esi, [dword edx+04A6h]
        mov eax, esi
        shl eax, 2
        sub eax, esi
        add eax, eax
        mov esi, dword [esp]
        add esi, eax
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        mov edi, dword [cupseries]
        add edi, eax
        movsd
        movsw
        inc edx
        cmp edx, byte 7
        jl short LoadCupFinalSeries.1
        mov eax, dword [esp]
        sub eax, byte 2
        mov dword [esp], eax
        je short .x
        push eax
        call FreeMemBlock
        add esp, byte 4
        jmp short .x
.2:
        xor ecx, ecx
        mov dword [cupseries], ecx
.x:
        add esp, byte 4
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; IsCupClinched                                15C30  95 PC, medium confidence
; (score1, score2): with cupseries loaded, puts this game's score into the
; first unplayed final game, asks CupSeriesWinner (best-of
;
; from gameopts in Play-Off mode, else SeriesLength), restores the slot;
; returns 1 when this game wins the Cup; called from the engine end-of-game
; code
;-----------------------------------------------------------------------------
; C: src/front/scoreboard/IsCupClinched.c
%ifdef CBUILD
%include "c/front/scoreboard/IsCupClinched.inc"
%else
IsCupClinched:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push eax
        push edx
        cmp dword [cupseries], byte 0
        jne short .2
.1:
        xor eax, eax
        jmp near .x
.2:
        xor ebx, ebx
        jmp short .4
.3:
        inc ebx
.4:
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        lea edx, [eax+eax]
        mov eax, dword [cupseries]
        add eax, edx
        cmp byte [byte eax+04h], 0FFh
        jne short IsCupClinched.3
        mov cl, byte [byte esp+04h]
        mov byte [byte eax+04h], cl
        mov eax, dword [cupseries]
        add edx, eax
        mov al, byte [esp]
        mov byte [byte edx+05h], al
        cmp dword [gamemode], byte 1
        jne short .5
        mov edx, dword [gameopts]
        shl edx, 11h
        shr edx, 1Dh
        jmp short .6
.5:
        mov eax, dword [cupseries]
        call SeriesLength
        mov edx, eax
.6:
        mov eax, dword [cupseries]
        call CupSeriesWinner
        mov edx, eax
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        lea ebx, [eax+eax]
        mov eax, dword [cupseries]
        mov byte [byte ebx+eax+05h], 0FFh
        mov cl, byte [byte ebx+eax+05h]
        mov eax, dword [cupseries]
        mov byte [byte ebx+eax+04h], cl
        test edx, edx
        jl near IsCupClinched.1
        mov eax, 1
.x:
        add esp, byte 8
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CupSeriesWinner                              15CE1  95 PC, medium confidence
; Same code as SeriesWinner (season_playoffs): (series games, best-of) counts
; each side's wins until one reaches best-of/2+1; -1
;
; when a needed game is unplayed
;-----------------------------------------------------------------------------
; C: src/front/scoreboard/CupSeriesWinner.c
%ifdef CBUILD
%include "c/front/scoreboard/CupSeriesWinner.inc"
%else
CupSeriesWinner:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 0Ch
        mov ebp, edx
        shr ebp, 1
        inc ebp
        xor edx, edx
        mov dl, byte [byte eax+02h]
        mov dword [byte esp+08h], edx
        xor edx, edx
        mov dl, byte [byte eax+03h]
        mov dword [byte esp+04h], edx
        xor edx, edx
        xor ebx, ebx
        jmp short .7
.1:
        cmp byte [byte eax+04h], 0FFh
        jne short .2
        mov eax, 0FFFFFFFFh
        jmp short .x
.2:
        movzx esi, byte [byte eax+02h]
        mov dword [esp], esi
        lea edi, [byte ebx+01h]
        lea esi, [byte edx+01h]
        mov ecx, dword [esp]
        cmp ecx, dword [byte esp+08h]
        jne short .4
        mov cl, byte [byte eax+04h]
        cmp cl, byte [byte eax+05h]
        ja short .5
.3:
        mov edx, esi
        jmp short .6
.4:
        mov cl, byte [byte eax+04h]
        cmp cl, byte [byte eax+05h]
        ja short CupSeriesWinner.3
.5:
        mov ebx, edi
.6:
        add eax, byte 6
.7:
        cmp ebx, ebp
        jae short .8
        cmp edx, ebp
        jb short CupSeriesWinner.1
.8:
        cmp ebx, edx
        jle short .9
        mov eax, dword [byte esp+08h]
        jmp short .x
.9:
        mov eax, dword [byte esp+04h]
.x:
        add esp, byte 0Ch
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
