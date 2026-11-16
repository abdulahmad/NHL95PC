; End-of-season trophies. Picking the winners, the award screens, the summary of who won each one,
; and the ceremony (95G front/awards95). One module: they share PickAwardWinners' exit.
bits 32
%include "hockey.inc"
section s_1205D progbits alloc exec nowrite align=1
extern __CHK, __STOSB, apl, assinsert, awardart, awardnames, awardtitles, awardtype
extern awardwinners, awtmap, bannermsg, bannertimer, bgscrollx, bgscrolly, BuildDefaultLines, TextCharH
extern milestonesaid, milestonesaid_b1, milestonesaid_b3, curevent, goalevent, camx, camx_m2
extern camy, cddriveptr, ClearInputQueue, ClearPanelPenalties, clockticks, cont2team, Crowd_Noise, CrowdFadeOut
extern crowdlevel, CrowdNoiseReset, crowdsmooth, cupteam, curleague, curperiod, CwdExciteLvl, deferpending
extern demomode, DrawHudPanel, DrawRinkOverlays, awardtextcolors, awardartfiles, dword_C66D0, dword_C66D4, ovlartfiles
extern goalienotebits, demoflag, gfxidlist, ovlstepart, SumCwdExciteLvl, ovlartbank
extern SpeechPatchNext, UnusedEventWord, energywarn, escrequest, exitgame, fadeinpending, FadeOutPalCycle, FadePalette
extern FadePalStep, FileClose, fileoncd, FileOpenRead, FitPlayerName, FlushGSumQueue, forceteams, fox
extern foy, fputchar, frameaccum, FreeMemBlock, gameclock, gamemode, gameopts, gameover
extern gamepal, gameresult, GetTicks, gsp, HandleHotKey_ret, hilightfont, hmtmap, HomeTeam
extern hudclockhund, hudclockmin, hudclocksec, hudhundaccum, hudhundstep, inputframes, introskipped, j_unlink_
extern joyq_flush, joysampling, joysampling_save, kaufmfont, lastplayer, lcblink, lcblinktime, lcboxon
extern lcline, lcreqchoice, lcrequest, lcsel, lctimer, leaguedbnames, LoadCupFinalSeries, LoadGameGfx
extern LoadGameState, LoadRink, LoadRockMusic, LoadTeamPalette, MakeGSummaryPath, MakePath, memcpy_, MouseSetPos
extern mousex, mousey, MusicChanReset, musichandle, musicon, musicslot, NormalizeDressFlags, AssetLoadNoOp
extern numshapes, numshpbank, awardstatsptrs, awardstatsptrs_e01, awardstatsptrs_e02, awardstatsptrs_e03, awardstatsptrs_e04, awardstatsptrs_e05
extern awardstatsptrs_e06, awardstatsptrs_e08, awardstatsptrs_e09, awardscopenames, ovlartnames, ovlseq, ovlstep, ovltimer
extern pad1dev, pad2dev, PaPreloadClips, passdir, passplayer, passspeed, Penaltytimer, Pencntdwn
extern penshotlive, penshotmode, penshotplayer, penshotstart, PeriodOver, photobankf, photobanks, photoptrs
extern photoptrsf, PlayCrowdSample, PlayDigiSample, PostGameDesk, presidentsteam, PrintFmt1, PrintFmt2, PrintShadowText
extern puckx, pucky, randomd0, ReadGoalieSeasonRec, ReadKeyRec, ReadSeasonRec, ReadTeamNames, ReadTeamRec
extern recbpr, RefPen, refsignal, RefStep, regd0, regd1, regd2, regd4
extern replaystart, ResetGoalieMenu, ResetInputSampling, rinkendart, rinkendbank, rinkhtiles, rinkscrollx, rinkscrolly
extern rinkwtiles, RunDeferredCalls, RunGameFrames, s1font, savedmousex, savedmousey, savepal, scrollx
extern scrolly, scrpitch, SelectScreenBM, SetRinkScroll, SetScreenSize, SetTextColors, SetupGame, SetupGoalieMenu
extern SetupTeamLines, sflags, shotongoal, shotontarget, shotplayer, songdata, SortCords, sounddev
extern SpeechStopQueue, SportsDesk, sprintf_, spritedrawcount, StartGame, StartPreGame, StartThreeStars, StopDigiSample
extern str_0000, str_04d, str_A, str_Adafan, str_Adawards, str_ANA, str_Awards, str_Awardsi
extern str_Awasong, str_backslash, str_Cal, str_D00_D49, str_D00D49, str_D01d, str_D02d, str_D50_D99
extern str_D50D99, str_EN, str_extDB, str_F000149, str_Flo, str_fmtpd, str_G, str_GAA
extern str_GameSav2, str_GfxIdList, str_GP, str_HILIGHT, str_Iff, str_L, str_MightyDucks, str_Min
extern str_Mtafan, str_Mtawards, str_Numshp, str_Pal3, str_Palmem, str_Pct, str_PIM, str_PlusMinus
extern str_PPG, str_PPV, str_Pt, str_Scrn, str_SHG, str_Shots, str_SO, str_SS
extern str_Summ, str_T, str_Titl, str_Trinknd, str_VFN, str_W, strcat_, strcpy_
extern strnicmp_, FreeGameMemory, FlushZones, SetZoneScreen, SetZoneOrigin, BeginZoneFrame, AllocMemBlock, PushMemDescriptorLocked
extern LoadBank, OpenArtArchiveErr, TextSetColors, TextSaveState, TextRestoreState, TextSetFont, LoadSample, FreeSample
extern ReleaseAllVoices, LoadDigiFile, PlayDigiBlockLoop, SndQuery, SetDigiChannelVolume, SetPalette, ShapeBankCount, ShapeBankEntry
extern DrawBitmap, ProjectPointList, FindShape, FindShapeQuiet, ClearScreen, SetScreenTarget, teamabbrevs, textline1
extern textline2, textline3, textline4, textline5, threat, TicksSinceLastCall, treeteamnames, str_ctl07
extern str_ctl06, awardwinners_e01, awardwinners_e02, awardwinners_e03, awardwinners_e04, awardwinners_e05, awardwinners_e06, awardwinners_e08
extern awardwinners_e09, awardstats9g, awardstats9, UpdateHudPanel, viewscrollx, viewscrolly, VisTeam, vtoa
extern WaitClickTimeout, WaitDigiSample, penaltysc, SortPending, lcsel_aw, puckfaceoff2_ptab, puckfaceoff2_ptab_y, refhitcount
extern injurystop, Pencntdwn2, rinkobjs, milestonesaid_b2, UnusedSpeechWord, UnusedCrowdWord, MaxCwdExciteLvl, NumCwdExciteLvl
extern UnusedCrowdWordHi, penevteam, rinkobjused
global PickAwardWinners, PickAwardWinners_x, ShowAwardScreens, DrawAwardsSummary, AwardsCeremony
;-----------------------------------------------------------------------------
; PickAwardWinners                             1205D  95 PC, medium confidence
; Corrected from FindLeagueLeaders: the records it fills (awardwinners,
; presidentsteam, cupteam) are the 11 trophy winners shown by
; ShowAwardScreens / DrawAwardsSummary (Hart, Art Ross, Norris, Selke,
; Vezina, Jennings, Calder, Presidents, Conn Smythe, EA Sports Cup, Stanley
; Cup); scans the 26 TEAMS.DB records with KEY / SEASON DB lookups
;-----------------------------------------------------------------------------
PickAwardWinners:
        push dword 41Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, 400h
        mov edx, 0FFFFFFFFh
        mov dword [dword esp+03F8h], edx
        mov dword [dword esp+03F4h], edx
        mov dword [dword esp+03F0h], edx
        mov ebx, dword [leaguedbnames+10h]
        mov ecx, str_extDB
        mov edx, curleague
        lea eax, [dword esp+03B8h]
        call MakePath
        mov ebx, 1
        mov edx, treeteamnames
        lea eax, [dword esp+03B8h]
        call ReadTeamNames
        mov ebx, eax
        test eax, eax
        jne short .1
        mov ebx, dword [leaguedbnames+10h]
        mov ecx, str_extDB
        mov edx, curleague
        lea eax, [dword esp+03B8h]
        call MakePath
        lea edx, [dword esp+03F8h]
        lea eax, [dword esp+03B8h]
        call FileOpenRead
        mov ebx, eax
.1:
        test ebx, ebx
        jne short .2
        mov ebx, dword [leaguedbnames]
        mov ecx, str_extDB
        mov edx, curleague
        lea eax, [dword esp+03B8h]
        call MakePath
        lea edx, [dword esp+03F4h]
        lea eax, [dword esp+03B8h]
        call FileOpenRead
        mov ebx, eax
.2:
        test ebx, ebx
        jne short .3
        mov ebx, dword [leaguedbnames+14h]
        mov ecx, str_extDB
        mov edx, curleague
        lea eax, [dword esp+03B8h]
        call MakePath
        lea edx, [dword esp+03F0h]
        lea eax, [dword esp+03B8h]
        call FileOpenRead
        mov ebx, eax
.3:
        mov ecx, 0Bh
        xor edx, edx
        lea eax, [dword esp+03D8h]
        call __STOSB
        xor esi, esi
        mov dword [dword esp+03FCh], esi
        jmp near .45
.4:
        mov ebx, edi
        mov edx, esp
        mov eax, dword [dword esp+03F8h]
        call ReadTeamRec
        mov ebx, eax
        xor eax, eax
        mov al, byte [byte esp+029h]
        add eax, eax
        movzx ebp, byte [byte esp+02Bh]
        add ebp, eax
        cmp byte [byte esp+029h], 0
        jne short .5
        cmp byte [byte esp+02Ah], 0
        jne short .5
        xor edx, edx
        jmp short .6
.5:
        xor edx, edx
        mov dl, byte [byte esp+029h]
        movzx esi, byte [byte esp+02Ah]
        add esi, edx
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add edx, eax
        shl edx, 2
        mov eax, edx
        sar edx, 1Fh
        idiv esi
        mov edx, eax
.6:
        cmp byte [dword esp+03DFh], 0
        je short .8
        mov eax, dword [dword esp+03ECh]
        cmp ebp, eax
        jg short .8
        jne short .7
        cmp edx, dword [dword esp+03E8h]
        jg short .8
.7:
        cmp ebp, dword [dword esp+03ECh]
        jne short .9
        cmp edx, dword [dword esp+03E8h]
        jne short .9
        mov al, byte [byte esp+029h]
        cmp al, byte [presidentsteam+029h]
        jbe short .9
.8:
        mov ecx, 0BAh
        mov edi, presidentsteam
        mov esi, esp
        rep movsd
        mov dword [dword esp+03ECh], ebp
        mov dword [dword esp+03E8h], edx
        mov byte [dword esp+03DFh], 0FFh
.9:
        cmp byte [dword esp+03E2h], 0
        je short .10
        xor eax, eax
        mov al, byte [byte esp+03Bh]
        cmp eax, dword [dword esp+03E4h]
        jle short .11
.10:
        mov ecx, 0BAh
        mov edi, cupteam
        mov esi, esp
        rep movsd
        xor eax, eax
        mov al, byte [byte esp+03Bh]
        mov dword [dword esp+03E4h], eax
        mov byte [dword esp+03E2h], 0FFh
.11:
        xor ebp, ebp
        jmp near .31
.12:
        mov eax, dword [byte esp+ebp*4+04Ch]
        cmp eax, byte 0FFFFFFFFh
        je near .30
        mov ebx, eax
        lea edx, [dword esp+0354h]
        mov eax, dword [dword esp+03F4h]
        call ReadKeyRec
        mov ebx, eax
        test eax, eax
        jne short .13
        mov ebx, dword [dword esp+0380h]
        lea edx, [dword esp+0388h]
        mov eax, dword [dword esp+03F0h]
        call ReadSeasonRec
        mov ebx, eax
.13:
        test ebx, ebx
        jne near .30
        cmp word [dword esp+0388h], byte 0
        jbe near .30
        mov edx, dword [awardstatsptrs]
        cmp byte [dword esp+03D8h], 0
        je short .14
        mov eax, dword [dword esp+038Ah]
        mov cx, word [byte edx+02h]
        cmp ax, cx
        ja short .14
        jne short .15
        mov eax, dword [dword esp+0388h]
        cmp ax, word [edx]
        jae short .15
.14:
        mov ecx, 0Dh
        mov edi, awardwinners
        lea esi, [dword esp+0354h]
        rep movsd
        mov ecx, 0Bh
        mov edi, edx
        lea esi, [dword esp+0388h]
        rep movsd
        movsw
        movsb
        mov byte [dword esp+03D8h], 0FFh
.15:
        mov edx, dword [awardstatsptrs_e01]
        cmp byte [dword esp+03D9h], 0
        je short .16
        mov eax, dword [dword esp+038Eh]
        mov cx, word [byte edx+06h]
        cmp ax, cx
        ja short .16
        jne short .17
        mov eax, dword [dword esp+0388h]
        cmp ax, word [edx]
        jae short .17
.16:
        mov ecx, 0Dh
        mov edi, awardwinners_e01
        lea esi, [dword esp+0354h]
        rep movsd
        mov ecx, 0Bh
        mov edi, edx
        lea esi, [dword esp+0388h]
        rep movsd
        movsw
        movsb
        mov byte [dword esp+03D9h], 0FFh
.17:
        cmp byte [dword esp+0356h], 44h
        jne short .19
        mov edx, dword [awardstatsptrs_e02]
        cmp byte [dword esp+03DAh], 0
        je short .18
        mov eax, dword [dword esp+038Eh]
        mov cx, word [byte edx+06h]
        cmp ax, cx
        ja short .18
        jne short .19
        mov eax, dword [dword esp+0388h]
        cmp ax, word [edx]
        jae short .19
.18:
        mov ecx, 0Dh
        mov edi, awardwinners_e02
        lea esi, [dword esp+0354h]
        rep movsd
        mov ecx, 0Bh
        mov edi, edx
        lea esi, [dword esp+0388h]
        rep movsd
        movsw
        movsb
        mov byte [dword esp+03DAh], 0FFh
.19:
        mov al, byte [dword esp+0356h]
        cmp al, 4Ch
        je short .20
        cmp al, 52h
        je short .20
        cmp al, 43h
        jne short .22
.20:
        mov edx, dword [awardstatsptrs_e03]
        cmp byte [dword esp+03DBh], 0
        je short .21
        mov eax, dword [dword esp+0398h]
        mov cx, word [byte edx+010h]
        cmp ax, cx
        jg short .21
        jne short .22
        mov eax, dword [dword esp+0388h]
        cmp ax, word [edx]
        jae short .22
.21:
        mov ecx, 0Dh
        mov edi, awardwinners_e03
        lea esi, [dword esp+0354h]
        rep movsd
        mov ecx, 0Bh
        mov edi, edx
        lea esi, [dword esp+0388h]
        rep movsd
        movsw
        movsb
        mov byte [dword esp+03DBh], 0FFh
.22:
        cmp byte [dword esp+0356h], 47h
        je short .24
        cmp byte [dword esp+03B6h], 0
        je short .24
        mov edx, dword [awardstatsptrs_e06]
        cmp byte [dword esp+03DEh], 0
        je short .23
        mov eax, dword [dword esp+038Eh]
        mov cx, word [byte edx+06h]
        cmp ax, cx
        ja short .23
        jne short .24
        mov eax, dword [dword esp+0388h]
        cmp ax, word [edx]
        jae short .24
.23:
        mov ecx, 0Dh
        mov edi, awardwinners_e06
        lea esi, [dword esp+0354h]
        rep movsd
        mov ecx, 0Bh
        mov edi, edx
        lea esi, [dword esp+0388h]
        rep movsd
        movsw
        movsb
        mov byte [dword esp+03DEh], 0FFh
.24:
        mov edx, dword [awardstatsptrs_e08]
        cmp byte [dword esp+03E0h], 0
        je short .25
        mov eax, dword [dword esp+03A0h]
        mov cx, word [byte edx+018h]
        cmp ax, cx
        ja short .25
        jne short .26
        mov eax, dword [dword esp+039Ah]
        cmp ax, word [byte edx+012h]
        jae short .26
.25:
        mov ecx, 0Dh
        mov edi, awardwinners_e08
        lea esi, [dword esp+0354h]
        rep movsd
        mov ecx, 0Bh
        mov edi, edx
        lea esi, [dword esp+0388h]
        rep movsd
        movsw
        movsb
        mov byte [dword esp+03E0h], 0FFh
.26:
        cmp byte [awardtype+9], 1
        jne short .27
        mov edx, dword [awardstatsptrs_e09]
        xor esi, esi
        mov si, word [byte edx+028h]
        xor eax, eax
        mov ax, word [byte edx+02Ah]
        add esi, eax
        xor eax, eax
        mov ax, word [byte edx+02Ch]
        jmp short .28
.27:
        mov edx, dword [awardstatsptrs_e09]
        xor esi, esi
        mov si, word [byte edx+030h]
        xor eax, eax
        mov ax, word [byte edx+032h]
        add eax, esi
        xor esi, esi
        mov si, word [byte edx+034h]
.28:
        add eax, esi
        mov cx, word [edx]
        xor edx, edx
        mov dx, word [dword esp+03B0h]
        xor esi, esi
        mov si, word [dword esp+03B2h]
        add edx, esi
        xor esi, esi
        mov si, word [dword esp+03B4h]
        add edx, esi
        cmp byte [dword esp+03E1h], 0
        je short .29
        cmp edx, eax
        jg short .29
        jne short .30
        cmp cx, word [dword esp+0388h]
        jbe short .30
.29:
        mov ecx, 0Dh
        mov edi, awardwinners_e09
        lea esi, [dword esp+0354h]
        rep movsd
        mov ecx, 0Bh
        mov edi, awardstats9
        lea esi, [dword esp+0388h]
        rep movsd
        movsw
        movsb
        mov dword [awardstatsptrs_e09], awardstats9
        mov byte [awardtype+9], 1
        mov byte [dword esp+03E1h], 0FFh
.30:
        inc ebp
.31:
        cmp ebp, byte 19h
        jge short .32
        test ebx, ebx
        je near PickAwardWinners.12
.32:
        xor ebp, ebp
        jmp near .43
.33:
        mov eax, dword [dword esp+ebp*4+0B0h]
        cmp eax, byte 0FFFFFFFFh
        je near .42
        mov ebx, eax
        lea edx, [dword esp+0320h]
        mov eax, dword [dword esp+03F4h]
        call ReadKeyRec
        mov ebx, eax
        test eax, eax
        jne short .34
        mov ebx, dword [dword esp+034Ch]
        lea edx, [dword esp+02E8h]
        mov eax, dword [dword esp+03F0h]
        call ReadGoalieSeasonRec
        mov ebx, eax
.34:
        test ebx, ebx
        jne near .42
        cmp word [dword esp+02E8h], byte 0
        jbe near .42
        mov edx, dword [awardstatsptrs_e04]
        cmp byte [dword esp+03DCh], 0
        je short .35
        mov eax, dword [dword esp+02EAh]
        mov cx, word [byte edx+02h]
        cmp ax, cx
        ja short .35
        jne short .36
        mov eax, dword [dword esp+02FCh]
        cmp ax, word [byte edx+014h]
        jbe short .36
.35:
        mov ecx, 0Dh
        mov edi, awardwinners_e04
        lea esi, [dword esp+0320h]
        rep movsd
        mov ecx, 0Dh
        mov edi, edx
        lea esi, [dword esp+02E8h]
        rep movsd
        movsw
        mov byte [dword esp+03DCh], 0FFh
.36:
        mov edx, dword [awardstatsptrs_e05]
        cmp word [dword esp+02E8h], byte 19h
        jb short .38
        cmp byte [dword esp+03DDh], 0
        je short .37
        mov eax, dword [dword esp+02F8h]
        mov cx, word [byte edx+010h]
        cmp ax, cx
        jb short .37
        jne short .38
        mov eax, dword [dword esp+02F4h]
        cmp ax, word [byte edx+0Ch]
        jbe short .38
.37:
        mov ecx, 0Dh
        mov edi, awardwinners_e05
        lea esi, [dword esp+0320h]
        rep movsd
        mov ecx, 0Dh
        mov edi, edx
        lea esi, [dword esp+02E8h]
        rep movsd
        movsw
        mov byte [dword esp+03DDh], 0FFh
.38:
        cmp byte [awardtype+9], 1
        jne short .39
        mov edx, dword [awardstatsptrs_e09]
        xor esi, esi
        mov si, word [byte edx+028h]
        xor eax, eax
        mov ax, word [byte edx+02Ah]
        add eax, esi
        xor esi, esi
        mov si, word [byte edx+02Ch]
        jmp short .40
.39:
        mov edx, dword [awardstatsptrs_e09]
        xor esi, esi
        mov si, word [byte edx+030h]
        xor eax, eax
        mov ax, word [byte edx+032h]
        add esi, eax
        xor eax, eax
        mov ax, word [byte edx+034h]
.40:
        add eax, esi
        mov cx, word [edx]
        xor esi, esi
        mov si, word [dword esp+0318h]
        xor edx, edx
        mov dx, word [dword esp+031Ah]
        add esi, edx
        xor edx, edx
        mov dx, word [dword esp+031Ch]
        add edx, esi
        cmp byte [dword esp+03E1h], 0
        je short .41
        cmp edx, eax
        jg short .41
        jne short .42
        cmp cx, word [dword esp+02E8h]
        jbe short .42
.41:
        mov ecx, 0Dh
        mov edi, awardwinners_e09
        lea esi, [dword esp+0354h]
        rep movsd
        mov ecx, 0Dh
        mov edi, awardstats9g
        lea esi, [dword esp+02E8h]
        rep movsd
        movsw
        mov dword [awardstatsptrs_e09], awardstats9g
        xor cl, cl
        mov byte [awardtype+9], cl
        mov byte [dword esp+03E1h], 0FFh
.42:
        inc ebp
.43:
        cmp ebp, byte 3
        jge short .44
        test ebx, ebx
        je near PickAwardWinners.33
.44:
        inc dword [dword esp+03FCh]
.45:
        mov edi, dword [dword esp+03FCh]
        cmp edi, byte 1Ah
        jge short .46
        test ebx, ebx
        je near PickAwardWinners.4
.46:
        lea eax, [dword esp+03F0h]
        call FileClose
        lea eax, [dword esp+03F4h]
        call FileClose
        lea eax, [dword esp+03F8h]
        call FileClose
        mov eax, ebx
        add esp, 400h
PickAwardWinners_x:
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; ShowAwardScreens                                                12849  95 PC
; For each of the 11 trophies (awardnames) loads the art file from awardart
; via MakePath, prints the winner (a team for awardtype 2: presidentsteam /
; cupteam, else the awardwinners player record with GP / G / A / Pt / PIM /
; +/- / PPG / SHG, or GAA / Min / Shots / Pct for goalies) and the title from
; awardtitles ("Most Valuable Player", ...), fades in ("!pal" / "palmem") and
; waits (WaitClickTimeout 10000); stops when the wait returns 3; returns that
; result; called from asset_loading
;-----------------------------------------------------------------------------
; C: src/front/awards/PickAwardWinners.c (ShowAwardScreens)
%ifdef CBUILD
%include "c/front/awards/PickAwardWinners.ShowAwardScreens.inc"
%else
ShowAwardScreens:
        push dword 6Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 40h
        xor edi, edi
        call ClearInputQueue
        mov dword [byte esp+038h], edi
        jmp near .27
.1:
        mov esi, ebx
        mov eax, dword [nosplit ebx*4+awardtextcolors]
        xor edx, edx
        call SetTextColors
        call GetTicks
        xor ecx, ecx
        mov ebx, dword [nosplit esi*4+awardart]
        mov eax, dword [nosplit esi*4+awardartfiles]
        cmp byte [dword eax+fileoncd], 1
        jne short .2
        mov edx, dword [cddriveptr]
        jmp short .3
.2:
        xor edx, edx
.3:
        mov eax, esp
        call MakePath
        push byte 0
        lea eax, [byte esp+04h]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [byte esp+02Ch], eax
        push byte 1
        push eax
        call ShapeBankEntry
        add esp, byte 8
        push eax
        call DrawBitmap
        add esp, byte 4
        mov ebp, 76h
        mov eax, dword [byte esp+038h]
        cmp byte [dword eax+awardtype], 2
        jne near .13
        cmp eax, byte 0Ah
        jne short .4
        mov edx, cupteam
        jmp short .5
.4:
        mov edx, presidentsteam
.5:
        mov eax, esp
        call strcpy_
        mov ebx, 3
        mov edx, str_ANA
        mov eax, esp
        call strnicmp_
        test eax, eax
        jne short .7
        push str_MightyDucks
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov esi, 1FEh
        sub esi, eax
        mov ebx, str_MightyDucks
.6:
        mov edx, ebp
        mov eax, esi
        call PrintShadowText
        jmp near .25
.7:
        cmp dword [byte esp+038h], byte 0Ah
        jne short .8
        mov edx, cupteam+5
        jmp short .9
.8:
        mov edx, presidentsteam+5
.9:
        mov eax, esp
        call strcpy_
        mov ebx, 3
        mov edx, str_Cal
        mov eax, esp
        call strnicmp_
        test eax, eax
        je short .10
        mov ebx, 3
        mov edx, str_Flo
        mov eax, esp
        call strnicmp_
        test eax, eax
        jne short .11
.10:
        mov edx, str_ctl07
        jmp short .12
.11:
        mov edx, str_ctl06
.12:
        mov eax, esp
        call strcat_
        mov eax, esp
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov esi, 1FEh
        sub esi, eax
        mov ebx, esp
        jmp short ShowAwardScreens.6
.13:
        mov edi, eax
        shl edi, 2
        sub edi, eax
        shl edi, 2
        add edi, eax
        shl edi, 2
        mov eax, awardwinners
        add eax, edi
        lea edx, [byte eax+013h]
        push edx
        add eax, byte 3
        push eax
        push str_SS
        lea eax, [byte esp+0Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        mov eax, esp
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov esi, 1FEh
        sub esi, eax
        mov ebx, esp
        mov edx, ebp
        mov eax, esi
        call PrintShadowText
        xor edx, edx
        mov dl, byte [dword edi+awardwinners]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        add eax, edx
        mov edx, treeteamnames
        add edx, eax
        mov eax, esp
        call strcpy_
        mov ebx, 3
        mov edx, str_ANA
        mov eax, esp
        call strnicmp_
        test eax, eax
        jne short .14
        mov ecx, 6
        mov edi, esp
        mov esi, str_MightyDucks
        rep movsd
        movsb
        jmp short .18
.14:
        mov bl, byte [dword edi+awardwinners]
        cmp bl, 2
        je short .15
        cmp bl, 18h
        je short .15
        cmp bl, 19h
        jne short .16
.15:
        mov edx, str_ctl07
        jmp short .17
.16:
        mov edx, str_ctl06
.17:
        mov eax, esp
        call strcat_
.18:
        mov eax, esp
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov esi, 1FEh
        sub esi, eax
        xor eax, eax
        mov al, byte [TextCharH]
        add ebp, eax
        mov ebx, esp
        mov edx, ebp
        mov eax, esi
        call PrintShadowText
        mov esi, 1A4h
        add ebp, byte 2Ch
        mov edi, dword [byte esp+038h]
        shl edi, 2
        mov eax, dword [byte esp+038h]
        mov ch, byte [dword eax+awardtype]
        test ch, ch
        jne near .21
        mov ebx, str_GP
        mov edx, ebp
        mov eax, esi
        call PrintShadowText
        xor edx, edx
        mov dl, byte [TextCharH]
        add edx, ebp
        mov ebx, str_Min
        mov eax, esi
        call PrintShadowText
        xor edx, edx
        mov dl, byte [TextCharH]
        add edx, edx
        add edx, ebp
        mov ebx, str_GAA
        mov eax, esi
        call PrintShadowText
        xor edx, edx
        mov dl, byte [TextCharH]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        lea edx, [eax+ebp]
        mov ebx, str_W
        mov eax, esi
        call PrintShadowText
        xor eax, eax
        mov al, byte [TextCharH]
        shl eax, 2
        lea edx, [eax+ebp]
        mov ebx, str_L
        mov eax, esi
        call PrintShadowText
        xor edx, edx
        mov dl, byte [TextCharH]
        mov eax, edx
        shl eax, 2
        add eax, edx
        lea edx, [eax+ebp]
        mov ebx, str_T
        mov eax, esi
        call PrintShadowText
        xor edx, edx
        mov dl, byte [TextCharH]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        lea edx, [eax+ebp]
        mov ebx, str_SO
        mov eax, esi
        call PrintShadowText
        xor edx, edx
        mov dl, byte [TextCharH]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        lea edx, [eax+ebp]
        mov ebx, str_EN
        mov eax, esi
        call PrintShadowText
        xor edx, edx
        mov dl, byte [TextCharH]
        shl edx, 3
        add edx, ebp
        mov ebx, str_Shots
        mov eax, esi
        call PrintShadowText
        xor edx, edx
        mov dl, byte [TextCharH]
        mov eax, edx
        shl eax, 3
        add eax, edx
        lea edx, [eax+ebp]
        mov ebx, str_Pct
        mov eax, esi
        call PrintShadowText
        mov eax, dword [dword edi+awardstatsptrs]
        mov dword [byte esp+034h], eax
        mov edi, eax
        xor eax, eax
        mov dword [byte esp+03Ch], eax
.19:
        mov eax, dword [byte esp+03Ch]
        mov ebx, dword [nosplit eax*4+awardscopenames]
        xor edx, edx
        mov dl, byte [TextCharH]
        lea eax, [byte esi+034h]
        mov ecx, ebp
        sub ecx, edx
        mov edx, ecx
        add esi, byte 50h
        call PrintShadowText
        xor ecx, ecx
        mov cx, word [edi]
        mov ebx, str_fmtpd
        mov edx, ebp
        mov eax, esi
        call PrintFmt1
        xor ecx, ecx
        mov cx, word [byte edi+0Ch]
        xor edx, edx
        mov dl, byte [TextCharH]
        add edx, ebp
        mov ebx, str_fmtpd
        mov eax, esi
        call PrintFmt1
        xor ebx, ebx
        mov bx, word [byte edi+010h]
        mov ecx, 64h
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ecx
        push edx
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ecx
        xor edx, edx
        mov dl, byte [TextCharH]
        add edx, edx
        add edx, ebp
        mov ecx, eax
        mov ebx, str_D02d
        mov eax, esi
        call PrintFmt2
        xor ecx, ecx
        mov cx, word [byte edi+02h]
        xor edx, edx
        mov dl, byte [TextCharH]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        lea edx, [eax+ebp]
        mov ebx, str_fmtpd
        mov eax, esi
        call PrintFmt1
        xor ecx, ecx
        mov cx, word [byte edi+04h]
        xor edx, edx
        mov dl, byte [TextCharH]
        shl edx, 2
        add edx, ebp
        mov ebx, str_fmtpd
        mov eax, esi
        call PrintFmt1
        mov edx, dword [byte esp+03Ch]
        test edx, edx
        jne short .20
        xor ecx, ecx
        mov cx, word [byte edi+06h]
        mov dl, byte [TextCharH]
        mov eax, edx
        shl eax, 2
        add eax, edx
        lea edx, [eax+ebp]
        mov ebx, str_fmtpd
        mov eax, esi
        call PrintFmt1
.20:
        xor ecx, ecx
        mov cx, word [byte edi+08h]
        xor edx, edx
        mov dl, byte [TextCharH]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        lea edx, [eax+ebp]
        mov ebx, str_fmtpd
        mov eax, esi
        call PrintFmt1
        xor ecx, ecx
        mov cx, word [byte edi+0Ah]
        xor edx, edx
        mov dl, byte [TextCharH]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        lea edx, [eax+ebp]
        mov ebx, str_fmtpd
        mov eax, esi
        call PrintFmt1
        xor ecx, ecx
        mov cx, word [byte edi+012h]
        xor edx, edx
        mov dl, byte [TextCharH]
        shl edx, 3
        add edx, ebp
        mov ebx, str_fmtpd
        mov eax, esi
        call PrintFmt1
        xor ebx, ebx
        mov bx, word [byte edi+014h]
        mov ecx, 0Ah
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ecx
        push edx
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ecx
        mov ecx, eax
        xor edx, edx
        mov dl, byte [TextCharH]
        mov eax, edx
        shl eax, 3
        add eax, edx
        lea edx, [eax+ebp]
        mov ebx, str_D01d
        mov eax, esi
        call PrintFmt2
        mov edi, dword [byte esp+034h]
        add edi, byte 16h
        mov ebx, dword [byte esp+03Ch]
        inc ebx
        mov dword [byte esp+03Ch], ebx
        cmp ebx, byte 2
        jl near ShowAwardScreens.19
        jmp near .25
.21:
        cmp ch, 1
        jne near .25
        mov ebx, str_GP
        mov edx, ebp
        mov eax, esi
        call PrintShadowText
        xor edx, edx
        mov dl, byte [TextCharH]
        add edx, ebp
        mov ebx, str_G
        mov eax, esi
        call PrintShadowText
        xor edx, edx
        mov dl, byte [TextCharH]
        add edx, edx
        add edx, ebp
        mov ebx, str_A
        mov eax, esi
        call PrintShadowText
        xor edx, edx
        mov dl, byte [TextCharH]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        lea edx, [eax+ebp]
        mov ebx, str_Pt
        mov eax, esi
        call PrintShadowText
        xor edx, edx
        mov dl, byte [TextCharH]
        shl edx, 2
        add edx, ebp
        mov ebx, str_PIM
        mov eax, esi
        call PrintShadowText
        xor edx, edx
        mov dl, byte [TextCharH]
        mov eax, edx
        shl eax, 2
        add eax, edx
        lea edx, [eax+ebp]
        mov ebx, str_PlusMinus
        mov eax, esi
        call PrintShadowText
        xor edx, edx
        mov dl, byte [TextCharH]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        lea edx, [eax+ebp]
        mov ebx, str_PPG
        mov eax, esi
        call PrintShadowText
        xor edx, edx
        mov dl, byte [TextCharH]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        lea edx, [eax+ebp]
        mov ebx, str_SHG
        mov eax, esi
        call PrintShadowText
        xor edx, edx
        mov dl, byte [TextCharH]
        shl edx, 3
        add edx, ebp
        mov ebx, str_Shots
        mov eax, esi
        call PrintShadowText
        xor edx, edx
        mov dl, byte [TextCharH]
        mov eax, edx
        shl eax, 3
        add eax, edx
        lea edx, [eax+ebp]
        mov ebx, str_Pct
        mov eax, esi
        call PrintShadowText
        mov eax, dword [dword edi+awardstatsptrs]
        mov dword [byte esp+030h], eax
        mov edi, eax
        xor ecx, ecx
        mov dword [byte esp+03Ch], ecx
.22:
        mov eax, dword [byte esp+03Ch]
        mov ebx, dword [nosplit eax*4+awardscopenames]
        xor edx, edx
        mov dl, byte [TextCharH]
        lea eax, [byte esi+034h]
        mov ecx, ebp
        sub ecx, edx
        mov edx, ecx
        add esi, byte 50h
        call PrintShadowText
        xor ecx, ecx
        mov cx, word [edi]
        mov ebx, str_fmtpd
        mov edx, ebp
        mov eax, esi
        call PrintFmt1
        xor ecx, ecx
        mov cx, word [byte edi+02h]
        xor edx, edx
        mov dl, byte [TextCharH]
        add edx, ebp
        mov ebx, str_fmtpd
        mov eax, esi
        call PrintFmt1
        xor ecx, ecx
        mov cx, word [byte edi+04h]
        xor eax, eax
        mov al, byte [TextCharH]
        add eax, eax
        lea edx, [eax+ebp]
        mov ebx, str_fmtpd
        mov eax, esi
        call PrintFmt1
        xor ecx, ecx
        mov cx, word [byte edi+06h]
        xor edx, edx
        mov dl, byte [TextCharH]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        lea edx, [eax+ebp]
        mov ebx, str_fmtpd
        mov eax, esi
        call PrintFmt1
        xor ecx, ecx
        mov cx, word [byte edi+0Ch]
        xor edx, edx
        mov dl, byte [TextCharH]
        shl edx, 2
        add edx, ebp
        mov ebx, str_fmtpd
        mov eax, esi
        call PrintFmt1
        mov ecx, dword [byte edi+0Eh]
        sar ecx, 10h
        xor edx, edx
        mov dl, byte [TextCharH]
        mov eax, edx
        shl eax, 2
        add eax, edx
        lea edx, [eax+ebp]
        mov ebx, str_fmtpd
        mov eax, esi
        call PrintFmt1
        xor ecx, ecx
        mov cx, word [byte edi+08h]
        xor edx, edx
        mov dl, byte [TextCharH]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        lea edx, [eax+ebp]
        mov ebx, str_fmtpd
        mov eax, esi
        call PrintFmt1
        xor ecx, ecx
        mov cx, word [byte edi+0Ah]
        xor edx, edx
        mov dl, byte [TextCharH]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        lea edx, [eax+ebp]
        mov ebx, str_fmtpd
        mov eax, esi
        call PrintFmt1
        xor ecx, ecx
        mov cx, word [byte edi+0Eh]
        xor eax, eax
        mov al, byte [TextCharH]
        shl eax, 3
        lea edx, [eax+ebp]
        mov ebx, str_fmtpd
        mov eax, esi
        call PrintFmt1
        cmp word [byte edi+0Eh], byte 0
        je short .23
        xor edx, edx
        mov dx, word [byte edi+02h]
        mov ecx, edx
        shl ecx, 5
        sub ecx, edx
        shl ecx, 2
        add ecx, edx
        shl ecx, 3
        xor ebx, ebx
        mov bx, word [byte edi+0Eh]
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        lea edx, [ecx+eax]
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov edi, eax
        jmp short .24
.23:
        xor edi, edi
.24:
        mov ebx, 0Ah
        mov eax, edi
        mov edx, edi
        sar edx, 1Fh
        idiv ebx
        push edx
        mov eax, edi
        mov edx, edi
        sar edx, 1Fh
        idiv ebx
        mov ecx, eax
        xor edx, edx
        mov dl, byte [TextCharH]
        mov eax, edx
        shl eax, 3
        add eax, edx
        lea edx, [eax+ebp]
        mov ebx, str_D01d
        mov eax, esi
        call PrintFmt2
        mov edi, dword [byte esp+030h]
        add edi, byte 12h
        mov ecx, dword [byte esp+03Ch]
        inc ecx
        mov dword [byte esp+03Ch], ecx
        cmp ecx, byte 2
        jl near ShowAwardScreens.22
.25:
        mov ebp, 1BAh
        mov edi, dword [byte esp+038h]
        shl edi, 3
        mov esi, dword [dword edi+awardtitles+4]
        test esi, esi
        je short .26
        push esi
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov esi, 1FEh
        sub esi, eax
        mov ebx, dword [dword edi+awardtitles+4]
        mov edx, ebp
        mov eax, esi
        call PrintShadowText
        movzx ebp, byte [TextCharH]
        mov eax, 1BAh
        sub eax, ebp
        mov ebp, eax
.26:
        mov edi, dword [byte esp+038h]
        mov eax, dword [nosplit edi*8+awardtitles]
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov esi, 1FEh
        sub esi, eax
        mov ebx, dword [nosplit edi*8+awardtitles]
        mov edx, ebp
        mov eax, esi
        call PrintShadowText
        push str_Pal3
        mov edx, dword [byte esp+030h]
        push edx
        call FindShape
        add esp, byte 8
        lea edx, [byte eax+010h]
        mov ebx, 10h
        xor eax, eax
        call FadePalStep
        mov ebx, dword [byte esp+02Ch]
        push ebx
        call FreeMemBlock
        add esp, byte 4
        mov eax, 2710h
        call WaitClickTimeout
        mov edi, eax
        push byte 0
        push dword 300h
        push str_Palmem
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
        inc dword [byte esp+038h]
.27:
        mov ebx, dword [byte esp+038h]
        cmp ebx, byte 0Bh
        jge short .28
        cmp edi, byte 3
        jne near ShowAwardScreens.1
.28:
        mov eax, edi
        add esp, byte 40h
        jmp near PickAwardWinners_x
%endif ; C
;-----------------------------------------------------------------------------
; DrawAwardsSummary                                               13188  95 PC
; One row per trophy: award name (awardnames) at x 14h, winner name at x 0B4h
; and team at x 190h (or the team alone for awardtype 2); called from
; asset_loading after the award screens
;-----------------------------------------------------------------------------
DrawAwardsSummary:
        push dword 4Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 30h
        xor edx, edx
        mov dword [byte esp+02Ch], edx
.1:
        mov esi, dword [byte esp+02Ch]
        mov eax, esi
        shl eax, 2
        add eax, esi
        shl eax, 2
        sub eax, esi
        lea ebp, [dword eax+08Ch]
        mov ebx, dword [nosplit esi*4+awardnames]
        mov edx, ebp
        mov eax, 14h
        call PrintShadowText
        cmp byte [dword esi+awardtype], 2
        jne near .8
        mov ebx, 3
        mov edx, str_ANA
        mov eax, esp
        call strnicmp_
        test eax, eax
        jne short .2
        mov ebx, str_MightyDucks
        jmp near .14
.2:
        cmp esi, byte 0Ah
        jne short .3
        mov edx, cupteam+5
        jmp short .4
.3:
        mov edx, presidentsteam+5
.4:
        mov eax, esp
        call strcpy_
        mov ebx, 3
        mov edx, str_Cal
        mov eax, esp
        call strnicmp_
        test eax, eax
        je short .5
        mov ebx, 3
        mov edx, str_Flo
        mov eax, esp
        call strnicmp_
        test eax, eax
        jne short .6
.5:
        mov edx, str_ctl07
        jmp short .7
.6:
        mov edx, str_ctl06
.7:
        mov eax, esp
        call strcat_
        mov ebx, esp
        jmp near .14
.8:
        mov eax, esi
        shl eax, 2
        sub eax, esi
        shl eax, 2
        add esi, eax
        shl esi, 2
        mov eax, awardwinners
        add eax, esi
        lea ebx, [byte eax+013h]
        lea edx, [byte eax+03h]
        mov ecx, 0D2h
        mov eax, esp
        call FitPlayerName
        mov ebx, esp
        mov edx, ebp
        mov eax, 0B4h
        call PrintShadowText
        xor edx, edx
        mov dl, byte [dword esi+awardwinners]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        add eax, edx
        mov edx, treeteamnames
        add edx, eax
        mov eax, esp
        call strcpy_
        mov ebx, 3
        mov edx, str_ANA
        mov eax, esp
        call strnicmp_
        test eax, eax
        jne short .9
        mov ecx, 6
        mov edi, esp
        mov esi, str_MightyDucks
        rep movsd
        movsb
        jmp short .13
.9:
        mov dh, byte [dword esi+awardwinners]
        cmp dh, 2
        je short .10
        cmp dh, 18h
        je short .10
        cmp dh, 19h
        jne short .11
.10:
        mov edx, str_ctl07
        jmp short .12
.11:
        mov edx, str_ctl06
.12:
        mov eax, esp
        call strcat_
.13:
        mov ebx, esp
.14:
        mov edx, ebp
        mov eax, 190h
        call PrintShadowText
        mov ecx, dword [byte esp+02Ch]
        inc ecx
        mov dword [byte esp+02Ch], ecx
        cmp ecx, byte 0Bh
        jl near DrawAwardsSummary.1
        add esp, byte 30h
        jmp near PickAwardWinners_x
;-----------------------------------------------------------------------------
; AwardsCeremony                                                  13320  95 PC
; End-of-season trophy presentation (called from the schedule screens): loads
; the "awardsi" art (scrn / titl / !pal), plays the fanfare ("mtafan" /
; "adafan" by sound card) and the awards song ("awasong", "mtawards" /
; "adawards"), PickAwardWinners, ShowAwardScreens, then the "summ" screen
; with DrawAwardsSummary
;-----------------------------------------------------------------------------
; C: src/front/awards/PickAwardWinners.c (AwardsCeremony)
%ifdef CBUILD
%include "c/front/awards/PickAwardWinners.AwardsCeremony.inc"
%else
AwardsCeremony:
        push dword 78h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 50h
        call ClearInputQueue
        push byte 20h
        push dword 300h
        push str_Palmem
        call AllocMemBlock
        add esp, byte 0Ch
        mov esi, eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        cmp byte [musicon], 0
        je short .1
        cmp dword [songdata], byte 0
        je short .1
        mov eax, dword [musichandle]
        mov ebx, 32h
        mov edx, 3
        call SetDigiChannelVolume
.1:
        mov ebx, 10h
        mov edx, esi
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
        je short AwardsCeremony.2
        mov ecx, dword [songdata]
        push ecx
        call PushMemDescriptorLocked
        add esp, byte 4
        xor ebp, ebp
        mov dword [songdata], ebp
.3:
        mov eax, esp
        push eax
        call TextSaveState
        add esp, byte 4
        mov eax, dword [kaufmfont]
        push eax
        call TextSetFont
        add esp, byte 4
        xor ecx, ecx
        mov ebx, str_Awardsi
        cmp byte [fileoncd+01DEh], 1
        jne short .4
        mov edx, dword [cddriveptr]
        jmp short .5
.4:
        xor edx, edx
.5:
        lea eax, [byte esp+040h]
        call MakePath
        push byte 0
        lea eax, [byte esp+044h]
        push eax
        call LoadBank
        mov ebp, eax
        add esp, byte 8
        push str_Scrn
        push eax
        call FindShape
        add esp, byte 8
        push eax
        call DrawBitmap
        add esp, byte 4
        push str_Titl
        push ebp
        call FindShape
        add esp, byte 8
        push eax
        call DrawBitmap
        add esp, byte 4
        push str_Pal3
        push ebp
        call FindShape
        add esp, byte 8
        lea edx, [byte eax+010h]
        mov ebx, 300h
        mov eax, esi
        call memcpy_
        push ebp
        call FreeMemBlock
        add esp, byte 4
        cmp byte [musicon], 0
        je short .8
        cmp dword [songdata], byte 0
        jne short .8
        mov ecx, str_Iff
        mov ebx, str_Awards
        cmp byte [fileoncd+0220h], 1
        jne short .6
        mov edx, dword [cddriveptr]
        jmp short .7
.6:
        xor edx, edx
.7:
        lea eax, [byte esp+040h]
        call MakePath
        lea eax, [byte esp+040h]
        call LoadDigiFile
        mov dword [songdata], eax
        test eax, eax
        je near .13
        test byte [gameopts], 40h
        je near .13
        mov edx, dword [musichandle]
        mov ecx, 4Ch
        mov ebx, 3
        call PlayDigiBlockLoop
        jmp short .13
.8:
        mov ebx, dword [sounddev]
        cmp ebx, byte 1
        je short .13
        cmp ebx, byte 8
        jne short .10
        xor ecx, ecx
        mov ebx, str_Mtafan
        cmp byte [fileoncd+0FAh], 1
        jne short .9
        mov edx, dword [cddriveptr]
        jmp short .12
.9:
        xor edx, edx
        jmp short .12
.10:
        xor ecx, ecx
        mov ebx, str_Adafan
        cmp byte [fileoncd+018h], 1
        jne short .11
        mov edx, dword [cddriveptr]
        jmp short .12
.11:
        xor edx, edx
.12:
        lea eax, [byte esp+040h]
        call MakePath
        lea eax, [byte esp+040h]
        call LoadSample
        mov edi, eax
        call PlayDigiSample
.13:
        mov ebx, 10h
        mov edx, esi
        xor eax, eax
        call FadePalStep
        cmp byte [musicon], 0
        jne short .14
        cmp dword [sounddev], byte 1
        je short .14
        call WaitDigiSample
        mov ebx, 10h
        mov edx, esi
        mov eax, 1
        call FadePalStep
        call StopDigiSample
        mov eax, edi
        call FreeSample
        jmp near .20
.14:
        cmp byte [musicon], 0
        je near .19
        xor eax, eax
.15:
        test eax, eax
        jne short .16
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        jne short .16
        mov eax, 0Ah
        call WaitClickTimeout
        jmp short AwardsCeremony.15
.16:
        mov eax, dword [musichandle]
        mov ebx, 32h
        mov edx, 3
        call SetDigiChannelVolume
        mov ebx, 10h
        mov edx, esi
        mov eax, 1
        call FadePalStep
.17:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short AwardsCeremony.17
        mov eax, dword [songdata]
        test eax, eax
        je short .18
        push eax
        call PushMemDescriptorLocked
        add esp, byte 4
.18:
        xor ebx, ebx
        mov dword [songdata], ebx
        jmp short .20
.19:
        mov eax, 140h
        call WaitClickTimeout
        mov ebx, 10h
        mov edx, esi
        mov eax, 1
        call FadePalStep
.20:
        push esi
        call FreeMemBlock
        add esp, byte 4
        call PickAwardWinners
        mov esi, eax
        cmp byte [musicon], 0
        je short .23
        cmp dword [songdata], byte 0
        jne short .23
        mov ecx, str_Iff
        mov ebx, str_Awasong
        cmp byte [fileoncd+0224h], 1
        jne short .21
        mov edx, dword [cddriveptr]
        jmp short .22
.21:
        xor edx, edx
.22:
        lea eax, [byte esp+040h]
        call MakePath
        lea eax, [byte esp+040h]
        call LoadDigiFile
        mov dword [songdata], eax
        test eax, eax
        je near .28
        test byte [gameopts], 40h
        je near .28
        mov edx, dword [musichandle]
        mov ecx, 7Fh
        mov ebx, 3
        call PlayDigiBlockLoop
        jmp short .28
.23:
        cmp dword [sounddev], byte 8
        jne short .25
        xor ecx, ecx
        mov ebx, str_Mtawards
        cmp byte [fileoncd+0FCh], 1
        jne short .24
        mov edx, dword [cddriveptr]
        jmp short .27
.24:
        xor edx, edx
        jmp short .27
.25:
        xor ecx, ecx
        mov ebx, str_Adawards
        cmp byte [fileoncd+01Ah], 1
        jne short .26
        mov edx, dword [cddriveptr]
        jmp short .27
.26:
        xor edx, edx
.27:
        lea eax, [byte esp+040h]
        call MakePath
        lea eax, [byte esp+040h]
        call LoadSample
        mov edi, eax
        call PlayDigiSample
.28:
        test esi, esi
        jne near .32
        call ShowAwardScreens
        cmp eax, byte 3
        jge near .31
        xor ecx, ecx
        mov ebx, str_Awardsi
        cmp byte [fileoncd+01DEh], 1
        jne short .29
        mov edx, dword [cddriveptr]
        jmp short .30
.29:
        xor edx, edx
.30:
        lea eax, [byte esp+040h]
        call MakePath
        push byte 0
        lea eax, [byte esp+044h]
        push eax
        call LoadBank
        mov esi, eax
        add esp, byte 8
        call ClearInputQueue
        call SetScreenTarget
        xor edx, edx
        mov eax, 1
        call SetTextColors
        push str_Scrn
        push esi
        call FindShape
        add esp, byte 8
        push eax
        call DrawBitmap
        add esp, byte 4
        push str_Summ
        push esi
        call FindShape
        add esp, byte 8
        push eax
        call DrawBitmap
        add esp, byte 4
        call DrawAwardsSummary
        call SetScreenTarget
        push str_Pal3
        push esi
        call FindShape
        add esp, byte 8
        lea ebp, [byte eax+010h]
        mov ebx, 10h
        mov edx, ebp
        xor eax, eax
        call FadePalStep
        mov eax, 2328h
        call WaitClickTimeout
        mov ebx, 10h
        mov edx, ebp
        mov eax, 1
        call FadePalStep
        push esi
        call FreeMemBlock
        add esp, byte 4
.31:
        call SetScreenTarget
        push byte 0
        call ClearScreen
        add esp, byte 4
.32:
        cmp byte [musicon], 0
        je short .35
        mov eax, dword [musichandle]
        mov ebx, 78h
        mov edx, 3
        call SetDigiChannelVolume
.33:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short AwardsCeremony.33
        mov ebp, dword [songdata]
        test ebp, ebp
        je short .34
        push ebp
        call PushMemDescriptorLocked
        add esp, byte 4
.34:
        xor edx, edx
        mov dword [songdata], edx
        jmp short .36
.35:
        call StopDigiSample
        mov eax, edi
        call FreeSample
.36:
        mov eax, esp
        push eax
        call TextRestoreState
        add esp, byte 4
        add esp, byte 50h
        jmp near PickAwardWinners_x
%endif ; C
