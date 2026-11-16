; The summary after a period or a game, including the other games on the scoreboard.
bits 32
%include "hockey.inc"
section s_2D346 progbits alloc exec nowrite align=1
extern __CHK, awlinetab, byte_D42C3, cddriveptr, ClearInputQueue, cont2team, crestnames, curleague
extern DrawGadgetByType, cursndbank, hmteamrec_skaters, FadeOutPalCycle, FadePalette, FadePalStep, FileClose, fileoncd
extern FileOpenRead, FileOpenRW, FitPlayerName, fputchar, FreeMemBlock, gameopts, gameresult, gamestatlabels
extern gsuminitff, hmcrestbmp, hmlinetab, hmpassatt, hmpasscmp, hmroster, hmscore, hmteamrec
extern hmtmstruct, HomeTeam, joyq_flush, kaufmfont, leaguedbfmt, leaguedbfmt2, leaguedbnames, MakePath
extern memcpy_, MusicChanCmd3, musichandle, musicon, musicslot, othergames, othergamesb, otherperiod
extern otherscores, otherscoresb, PaElseNhl, PaOpenBank, PaScoringPeriod, penaltynames, PlayDigiSample, PrintShadowText
extern rand_, ReadGSummaryRec, ReadKeyRec, ReadSeasonRec, ReadTeamRec, schedgameidx, SetDrawBitmap, SetTextColors
extern SetTickDeadline, songdata, sounddev, sprintf_, StopDigiSample, str_02d02d, str_1st2, str_2nd2
extern str_3rd2, str_Adsum, str_Adsum2, str_Bkgd5, str_Bkgd6, str_Colm, str_Colm2, str_CommaSp
extern str_Ctbkgd2, str_Ctbkgd3, str_Ctlogo2, str_Ctlogo3, str_Cttitle12, str_Cttitle2, str_Cttitle3, str_Cttitle32
extern str_D02d2, str_D5, str_D6, str_D7, str_DD, str_DDD, str_Def2, str_DMinS
extern str_EVNT, str_extDB, str_Final, str_FinalOT, str_Fowa2, str_Gamesum, str_Gsta, str_Gsummary2
extern str_Iff6, str_Iff7, str_Indus0302, str_Injured2, str_Leaguetm, str_Mtsum, str_Mtsum2, str_Nd
extern str_NoPenalties, str_NoScoring, str_OT, str_Ots, str_OtShape, str_Pal13, str_Pal14, str_Per1
extern str_Per2, str_Per3, str_Period, str_PP, str_PRDS, str_Rd, str_RParen2, str_S2
extern str_S3, str_Scra2, str_SDD, str_SH, str_ShotsOnGoal, str_SS4, str_St, str_Summ2
extern str_Th, str_Tlu2, str_Top2, str_VFN, strcat_, strcpy_, sub_1BAF3, AllocMemBlock
extern PushMemDescriptorLocked, LoadBank, sub_8E8A0, TextSaveState, TextRestoreState, TextSetFont, LoadSample, FreeSample
extern LoadDigiFile, PlayDigiBlockLoop, SndQuery, SetDigiChannelVolume, PutBlock, DrawShape, sub_913D0, FindShape
extern ClearScreen, VgaSetPalette, SetScreenTarget, SetClipWindow, CreateBitmap, teamstartlag, VisTeam, vscrestbmp
extern WaitClickTimeout, WaitTickDeadline
global GameSummaryScreen_jt, GameSummaryScreen, GameSummaryScreen_p1, GameSummaryScreen_p2, GameSummaryScreen_p3, GameSummaryScreen_ot, GameSummaryScreen_finalot, GameSummaryScreen_final
global GameSummaryScreen_period, PickOtherGames, UpdateOtherScores, UpdateOtherScores_x, PrintClampedText, GameStatsScreen
GameSummaryScreen_jt:
        dd GameSummaryScreen_p1
        dd GameSummaryScreen_p2
        dd GameSummaryScreen_p3
        dd GameSummaryScreen_ot
        dd GameSummaryScreen_finalot
;-----------------------------------------------------------------------------
; GameSummaryScreen                                               2D35A  95 PC
; (mode, ...): gsummary / gamesum screen with crests, period-by-period goals
; / shots, scoring summary (" PP" / " SH", "%02d:%02d") and penalty summary
; ("No Scoring." / "No Penalties."); called by DeskScoringSummary,
; DeskPenaltySummary and the intermission desk
;-----------------------------------------------------------------------------
GameSummaryScreen:
        push dword 818h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, 7F0h
        push eax
        mov byte [dword esp+07E0h], dl
        mov byte [dword esp+07DCh], bl
        mov edx, 0FFFFFFFFh
        mov dword [dword esp+0768h], edx
        mov dword [dword esp+0764h], edx
        lea edi, [dword esp+0758h]
        mov esi, gsuminitff
        movsd
        movsd
        mov dword [dword esp+0760h], edx
        mov eax, 0AAE60h
        call sub_1BAF3
        cmp byte [musicon], 0
        je short .2
        cmp dword [songdata], byte 0
        je short .2
        mov eax, dword [musichandle]
        mov ebx, 4Bh
        mov edx, 3
        call SetDigiChannelVolume
.1:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short GameSummaryScreen.1
        mov edi, dword [songdata]
        push edi
        call PushMemDescriptorLocked
        add esp, byte 4
        xor ebp, ebp
        mov dword [songdata], ebp
.2:
        call ClearInputQueue
        xor eax, eax
        mov dword [dword esp+0778h], eax
.3:
        xor esi, esi
.4:
        mov eax, dword [dword esp+0778h]
        shl eax, 2
        mov edx, dword [dword esp+0778h]
        sub eax, edx
        shl eax, 3
        add eax, edx
        add eax, esi
        xor dl, dl
        mov byte [dword esp+eax+06D0h], dl
        inc esi
        cmp esi, byte 19h
        jl short GameSummaryScreen.4
        mov ecx, dword [dword esp+0778h]
        inc ecx
        mov dword [dword esp+0778h], ecx
        cmp ecx, byte 2
        jl short GameSummaryScreen.3
        xor edi, edi
        mov dword [dword esp+07ACh], edi
        xor ebp, ebp
        mov dword [dword esp+07C0h], ebp
        call PaOpenBank
        xor eax, eax
        mov dword [dword esp+0790h], eax
        xor edx, edx
        mov dword [dword esp+07B4h], eax
        mov dword [dword esp+07B0h], eax
        mov dword [dword esp+07B8h], eax
        mov dword [dword esp+0780h], eax
        mov dword [dword esp+07A4h], 0FFFFFFFFh
        mov al, byte [dword esp+07E0h]
        mov byte [dword esp+07D8h], al
        xor dh, ah
        mov byte [dword esp+07F0h], dh
        mov dword [dword esp+0778h], ebp
.5:
        mov eax, dword [dword esp+0778h]
        xor bl, bl
        mov byte [dword esp+eax+07C8h], bl
        mov byte [dword esp+eax+07D0h], bl
        inc eax
        mov dword [dword esp+0778h], eax
        cmp eax, byte 2
        jl short GameSummaryScreen.5
        call SetScreenTarget
        lea eax, [dword esp+0628h]
        push eax
        call TextSaveState
        add esp, byte 4
        mov ecx, str_VFN
        mov ebx, str_Indus0302
        cmp byte [fileoncd+021Ah], 1
        jne short .6
        mov edx, dword [cddriveptr]
        jmp short .7
.6:
        xor edx, edx
.7:
        lea eax, [dword esp+05D4h]
        call MakePath
        push byte 20h
        lea eax, [dword esp+05D8h]
        push eax
        call sub_8E8A0
        add esp, byte 8
        mov dword [dword esp+077Ch], eax
        push eax
        call TextSetFont
        add esp, byte 4
        xor ecx, ecx
        mov ebx, str_Ctlogo2
        cmp byte [fileoncd+059h], 1
        jne short .8
        mov edx, dword [cddriveptr]
        jmp short .9
.8:
        xor edx, edx
.9:
        lea eax, [dword esp+0734h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0738h]
        push eax
        call LoadBank
        mov edi, eax
        add esp, byte 8
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        mov ebx, dword [nosplit eax*4+crestnames]
        push ebx
        push edi
        call FindShape
        mov esi, eax
        add esp, byte 8
        push byte 20h
        mov eax, dword [byte eax+04h]
        sar eax, 10h
        push eax
        mov eax, dword [byte esi+02h]
        sar eax, 10h
        push eax
        call CreateBitmap
        add esp, byte 0Ch
        mov dword [hmcrestbmp], eax
        push eax
        call SetDrawBitmap
        add esp, byte 4
        push byte 0
        push byte 0
        push esi
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [hmcrestbmp]
        mov eax, dword [byte eax+02Ch]
        mov dx, word [byte esi+08h]
        mov word [byte eax+08h], dx
        mov eax, dword [hmcrestbmp]
        mov eax, dword [byte eax+02Ch]
        mov dx, word [byte esi+0Ah]
        mov word [byte eax+0Ah], dx
        mov eax, dword [VisTeam-2]
        sar eax, 10h
        mov ecx, dword [nosplit eax*4+crestnames]
        push ecx
        push edi
        call FindShape
        mov esi, eax
        add esp, byte 8
        push byte 20h
        mov eax, dword [byte eax+04h]
        sar eax, 10h
        push eax
        mov eax, dword [byte esi+02h]
        sar eax, 10h
        push eax
        call CreateBitmap
        add esp, byte 0Ch
        mov dword [vscrestbmp], eax
        push eax
        call SetDrawBitmap
        add esp, byte 4
        push byte 0
        push byte 0
        push esi
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [vscrestbmp]
        mov eax, dword [byte eax+02Ch]
        mov dx, word [byte esi+08h]
        mov word [byte eax+08h], dx
        mov eax, dword [vscrestbmp]
        mov eax, dword [byte eax+02Ch]
        mov dx, word [byte esi+0Ah]
        mov word [byte eax+0Ah], dx
        call SetScreenTarget
        push edi
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov ebx, str_Ctbkgd2
        cmp byte [fileoncd+058h], 1
        jne short .10
        mov edx, dword [cddriveptr]
        jmp short .11
.10:
        xor edx, edx
.11:
        lea eax, [dword esp+0734h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0738h]
        push eax
        call LoadBank
        mov esi, eax
        add esp, byte 8
        mov dword [dword esp+0784h], eax
        push str_Bkgd5
        push eax
        call FindShape
        add esp, byte 8
        mov dword [dword esp+079Ch], eax
        push str_Pal13
        push esi
        call FindShape
        add esp, byte 8
        add eax, byte 10h
        mov dword [dword esp+07A8h], eax
        mov dh, byte [esp]
        test dh, 3
        je near .15
        xor ecx, ecx
        mov ebx, str_Cttitle2
        cmp byte [fileoncd+05Bh], 1
        jne short .12
        mov edx, dword [cddriveptr]
        jmp short .13
.12:
        xor edx, edx
.13:
        lea eax, [dword esp+0734h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0738h]
        push eax
        call LoadBank
        mov esi, eax
        add esp, byte 8
        mov dword [dword esp+078Ch], eax
        push str_Summ2
        push eax
        call FindShape
        add esp, byte 8
        mov dword [dword esp+0688h], eax
        push str_OtShape
        push esi
        call FindShape
        add esp, byte 8
        mov dword [dword esp+0670h], eax
        push str_Per1
        push esi
        call FindShape
        add esp, byte 8
        mov dword [dword esp+0678h], eax
        push str_Per2
        push esi
        call FindShape
        add esp, byte 8
        mov dword [dword esp+067Ch], eax
        push str_Per3
        push esi
        call FindShape
        add esp, byte 8
        mov dword [dword esp+0680h], eax
.14:
        push str_Top2
        push esi
        call FindShape
        add esp, byte 8
        mov dword [dword esp+0690h], eax
        jmp near .21
.15:
        test dh, 1Ch
        je near .18
        xor ecx, ecx
        mov ebx, str_Cttitle12
        cmp byte [fileoncd+05Ah], 1
        jne short .16
        mov edx, dword [cddriveptr]
        jmp short .17
.16:
        xor edx, edx
.17:
        lea eax, [dword esp+0734h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0738h]
        push eax
        call LoadBank
        mov esi, eax
        add esp, byte 8
        mov dword [dword esp+078Ch], eax
        push str_Def2
        push eax
        call FindShape
        add esp, byte 8
        mov dword [dword esp+0668h], eax
        push str_Fowa2
        push esi
        call FindShape
        add esp, byte 8
        mov dword [dword esp+066Ch], eax
        push str_Scra2
        push esi
        call FindShape
        add esp, byte 8
        mov dword [dword esp+0684h], eax
        push str_Tlu2
        push esi
        call FindShape
        add esp, byte 8
        mov dword [dword esp+068Ch], eax
        jmp near GameSummaryScreen.14
.18:
        test dh, 20h
        je short .21
        xor ecx, ecx
        mov ebx, str_Cttitle3
        cmp byte [fileoncd+05Ch], 1
        jne short .19
        mov edx, dword [cddriveptr]
        jmp short .20
.19:
        xor edx, edx
.20:
        lea eax, [dword esp+0734h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0738h]
        push eax
        call LoadBank
        mov esi, eax
        add esp, byte 8
        mov dword [dword esp+078Ch], eax
        push str_Ots
        push eax
        call FindShape
        add esp, byte 8
        mov dword [dword esp+0674h], eax
        push str_Colm
        push esi
        call FindShape
        add esp, byte 8
        mov dword [dword esp+0694h], eax
.21:
        xor edx, edx
        mov eax, 40h
        call SetTextColors
        mov ecx, str_extDB
        mov ebx, str_Gsummary2
        mov edx, curleague
        lea eax, [dword esp+05D4h]
        call MakePath
        lea edx, [dword esp+0760h]
        lea eax, [dword esp+05D4h]
        call FileOpenRead
        mov dword [dword esp+0788h], eax
        test eax, eax
        jne short .22
        xor ebx, ebx
        lea edx, [dword esp+0744h]
        mov eax, dword [dword esp+0760h]
        call ReadGSummaryRec
        mov dword [dword esp+0788h], eax
.22:
        test byte [esp], 20h
        jne near .26
        cmp dword [dword esp+0788h], byte 0
        jne short .23
        mov eax, dword [dword esp+0747h]
        sar eax, 10h
        mov dword [dword esp+0770h], eax
        mov al, byte [dword esp+0747h]
        mov byte [dword esp+07D4h], al
        mov al, byte [dword esp+0748h]
        mov byte [dword esp+07E4h], al
        mov ebx, dword [leaguedbnames+10h]
        mov ecx, str_extDB
        mov edx, curleague
        lea eax, [dword esp+05D4h]
        call MakePath
        lea edx, [dword esp+0768h]
        lea eax, [dword esp+05D4h]
        call FileOpenRead
        mov dword [dword esp+0788h], eax
.23:
        cmp dword [dword esp+0788h], byte 0
        jne short .24
        xor ebx, ebx
        mov bl, byte [dword esp+07D4h]
        lea edx, [byte esp+04h]
        mov eax, dword [dword esp+0768h]
        call ReadTeamRec
        mov dword [dword esp+0788h], eax
.24:
        cmp dword [dword esp+0788h], byte 0
        jne short .25
        xor ebx, ebx
        mov bl, byte [dword esp+07E4h]
        lea edx, [dword esp+02ECh]
        mov eax, dword [dword esp+0768h]
        call ReadTeamRec
        mov dword [dword esp+0788h], eax
.25:
        lea eax, [dword esp+0768h]
        call FileClose
.26:
        cmp dword [dword esp+0788h], byte 0
        jne short .27
        mov ebx, dword [leaguedbnames]
        mov ecx, str_extDB
        mov edx, curleague
        lea eax, [dword esp+05D4h]
        call MakePath
        lea edx, [dword esp+0764h]
        lea eax, [dword esp+05D4h]
        call FileOpenRead
        mov dword [dword esp+0788h], eax
.27:
        cmp dword [dword esp+0788h], byte 0
        jne short .28
        mov edx, dword [leaguedbnames+14h]
        lea eax, [dword esp+0734h]
        call strcpy_
        lea eax, [dword esp+0734h]
        push eax
        push leaguedbfmt
        lea eax, [dword esp+05DCh]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea edx, [dword esp+0758h]
        lea eax, [dword esp+05D4h]
        call FileOpenRW
        mov dword [dword esp+0788h], eax
.28:
        cmp dword [dword esp+0788h], byte 0
        jne short .29
        mov edx, dword [leaguedbnames+14h]
        lea eax, [dword esp+0734h]
        call strcpy_
        lea eax, [dword esp+0734h]
        push eax
        push leaguedbfmt2
        lea eax, [dword esp+05DCh]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea edx, [dword esp+075Ch]
        lea eax, [dword esp+05D4h]
        call FileOpenRW
        mov dword [dword esp+0788h], eax
.29:
        test byte [esp], 1Ch
        mov edi, 0A0h
        xor ecx, ecx
        mov dword [dword esp+076Ch], ecx
        test byte [esp], 20h
        jne near .37
        call FadeOutPalCycle
        cmp byte [musicon], 0
        je short .32
        cmp dword [songdata], byte 0
        jne short .32
        mov ecx, str_Iff6
        mov ebx, str_Gamesum
        cmp byte [fileoncd+01E4h], 1
        jne short .30
        mov edx, dword [cddriveptr]
        jmp short .31
.30:
        xor edx, edx
.31:
        lea eax, [dword esp+05D4h]
        call MakePath
        lea eax, [dword esp+05D4h]
        call LoadDigiFile
        mov dword [songdata], eax
        test eax, eax
        je near .37
        test byte [gameopts], 40h
        je near .37
        mov edx, dword [musichandle]
        mov ecx, 4Ch
        mov ebx, 3
        call PlayDigiBlockLoop
        jmp near .37
.32:
        cmp dword [sounddev], byte 8
        jne short .34
        xor ecx, ecx
        mov ebx, str_Mtsum
        cmp byte [fileoncd+0102h], 1
        jne short .33
        mov edx, dword [cddriveptr]
        jmp short .36
.33:
        xor edx, edx
        jmp short .36
.34:
        xor ecx, ecx
        mov ebx, str_Adsum
        cmp byte [fileoncd+021h], 1
        jne short .35
        mov edx, dword [cddriveptr]
        jmp short .36
.35:
        xor edx, edx
.36:
        lea eax, [dword esp+05D4h]
        call MakePath
        mov dword [cursndbank], 20h
        lea eax, [dword esp+05D4h]
        call LoadSample
        mov dword [dword esp+076Ch], eax
        xor edx, edx
        mov dword [cursndbank], edx
        call PlayDigiSample
.37:
        call ClearInputQueue
        call joyq_flush
        mov dword [dword esp+0750h], hmlinetab
        mov dword [dword esp+0754h], awlinetab
        mov bl, byte [esp]
        test bl, 24h
        jne near .39
        mov ebp, dword [dword esp+079Ch]
        push ebp
        call DrawShape
        add esp, byte 4
        test byte [esp], 3
        je short .38
        lea eax, [dword esp+07CCh]
        push eax
        push byte 0
        xor edx, edx
        mov dl, byte [dword esp+07E8h]
        lea ecx, [dword esp+0670h]
        mov ebx, dword [dword esp+07B0h]
        mov eax, dword [byte esp+08h]
        call DrawGadgetByType
        push byte 50h
        push byte 3Dh
        mov eax, dword [hmcrestbmp]
        mov edx, dword [byte eax+02Ch]
        push edx
        call sub_913D0
        add esp, byte 0Ch
        push byte 50h
        push dword 221h
        mov eax, dword [vscrestbmp]
        mov ebx, dword [byte eax+02Ch]
        push ebx
        call sub_913D0
        add esp, byte 0Ch
        jmp near GameSummaryScreen_period.15
.38:
        lea eax, [dword esp+07CCh]
        push eax
        push byte 0
        xor edx, edx
        mov dl, byte [dword esp+07E8h]
        lea ecx, [dword esp+0670h]
        mov ebx, dword [dword esp+07B0h]
        mov eax, dword [byte esp+08h]
        call DrawGadgetByType
        jmp near GameSummaryScreen_period.15
.39:
        test bl, 20h
        je near GameSummaryScreen_period.6
        xor esi, esi
        mov dword [dword esp+0778h], esi
        jmp near GameSummaryScreen_period.5
.40:
        mov al, byte [nosplit ecx*2+othergames]
        mov byte [dword esp+07D4h], al
        mov al, byte [nosplit ecx*2+othergamesb]
        mov byte [dword esp+07E4h], al
        mov al, byte [nosplit ecx*4+otherperiod]
        mov byte [dword esp+07D8h], al
        mov al, byte [nosplit ecx*2+otherscores]
        mov byte [dword esp+07D0h], al
        mov al, byte [nosplit ecx*2+otherscoresb]
        mov byte [dword esp+07D1h], al
        jne short .41
        mov ebx, dword [leaguedbnames+10h]
        mov ecx, str_extDB
        mov edx, curleague
        lea eax, [dword esp+05D4h]
        call MakePath
        lea edx, [dword esp+0768h]
        lea eax, [dword esp+05D4h]
        call FileOpenRead
        mov dword [dword esp+0788h], eax
.41:
        mov ebx, dword [dword esp+0788h]
        test ebx, ebx
        jne short .42
        mov bl, byte [dword esp+07D4h]
        lea edx, [byte esp+04h]
        mov eax, dword [dword esp+0768h]
        call ReadTeamRec
        mov dword [dword esp+0788h], eax
.42:
        cmp dword [dword esp+0788h], byte 0
        jne short .43
        xor ebx, ebx
        mov bl, byte [dword esp+07E4h]
        lea edx, [dword esp+02ECh]
        mov eax, dword [dword esp+0768h]
        call ReadTeamRec
        mov dword [dword esp+0788h], eax
.43:
        lea eax, [dword esp+0768h]
        call FileClose
        mov esi, dword [dword esp+0788h]
        test esi, esi
        jne near GameSummaryScreen_period.4
        cmp dword [dword esp+0778h], byte 0
        je short .44
        push dword 1E0h
        push dword 8Ch
        push dword 280h
        push byte 72h
        jmp short .45
.44:
        push dword 1E0h
        push esi
        push dword 280h
        push esi
.45:
        call SetClipWindow
        add esp, byte 10h
        call FadeOutPalCycle
        mov ebp, dword [dword esp+079Ch]
        push ebp
        call DrawShape
        add esp, byte 4
        lea eax, [dword esp+07CCh]
        push eax
        push byte 0
        xor edx, edx
        mov dl, byte [dword esp+07E8h]
        lea ecx, [dword esp+0670h]
        mov ebx, dword [dword esp+07B0h]
        mov eax, dword [byte esp+08h]
        call DrawGadgetByType
        push dword 1E0h
        push byte 0
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        lea edx, [dword esp+0306h]
        lea eax, [dword esp+05D4h]
        call strcpy_
        lea ebx, [dword esp+05D4h]
        mov edx, 0D2h
        mov eax, 74h
        call PrintShadowText
        xor eax, eax
        mov al, byte [dword esp+07D1h]
        push eax
        push str_D6
        lea eax, [dword esp+05DCh]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea ebx, [dword esp+05D4h]
        mov edx, 0D2h
        mov eax, 118h
        call PrintShadowText
        lea edx, [byte esp+01Eh]
        lea eax, [dword esp+05D4h]
        call strcpy_
        lea ebx, [dword esp+05D4h]
        mov edx, 114h
        mov eax, 74h
        call PrintShadowText
        xor eax, eax
        mov al, byte [dword esp+07D0h]
        push eax
        push str_D6
        lea eax, [dword esp+05DCh]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea ebx, [dword esp+05D4h]
        mov edx, 114h
        mov eax, 118h
        call PrintShadowText
        mov edi, 0F3h
        mov al, byte [dword esp+07D8h]
        dec al
        cmp al, 4
        ja short GameSummaryScreen_final
        and eax, 0FFh
        jmp dword [nosplit cs:eax*4+GameSummaryScreen_jt]
GameSummaryScreen_p1:
        push str_1st2
        jmp short GameSummaryScreen_period
GameSummaryScreen_p2:
        push str_2nd2
        jmp short GameSummaryScreen_period
GameSummaryScreen_p3:
        push str_3rd2
        jmp short GameSummaryScreen_period
GameSummaryScreen_ot:
        push str_OT
        jmp short GameSummaryScreen_period
GameSummaryScreen_finalot:
        push str_FinalOT
        jmp short GameSummaryScreen_period
GameSummaryScreen_final:
        push str_Final
GameSummaryScreen_period:
        lea eax, [dword esp+05D8h]
        push eax
        call sprintf_
        add esp, byte 8
        cmp byte [dword esp+07D8h], 4
        jae short .1
        mov edx, str_Period
        lea eax, [dword esp+05D4h]
        call strcat_
.1:
        lea ebx, [dword esp+05D4h]
        mov edx, edi
        mov eax, 190h
        call PrintShadowText
        cmp dword [dword esp+07A4h], byte 0
        je short .2
        call PaElseNhl
        xor edx, edx
        mov dword [dword esp+07A4h], edx
.2:
        cmp dword [dword esp+0778h], byte 0
        jne short .3
        mov ebx, 10h
        mov edx, dword [dword esp+07A8h]
        xor eax, eax
        call FadePalStep
.3:
        mov eax, 3E8h
        call WaitClickTimeout
        mov dword [dword esp+07B4h], eax
.4:
        inc dword [dword esp+0778h]
.5:
        mov ecx, dword [dword esp+0778h]
        cmp ecx, byte 6
        jge near .14
        cmp dword [dword esp+07B4h], byte 2
        jge near .14
        mov ebp, dword [dword esp+0788h]
        test ebp, ebp
        je near GameSummaryScreen.40
        jmp near .14
.6:
        test bl, 4
        je near .15
        xor esi, esi
.7:
        test esi, esi
        je short .8
        mov ebx, 10h
        mov edx, dword [dword esp+07A8h]
        mov eax, 1
        call FadePalStep
.8:
        push byte 0
        call ClearScreen
        add esp, byte 4
        mov edi, dword [dword esp+079Ch]
        push edi
        call DrawShape
        add esp, byte 4
        lea eax, [dword esp+07CCh]
        push eax
        push byte 0
        xor edx, edx
        mov dl, byte [dword esp+07E8h]
        lea ecx, [dword esp+0670h]
        mov ebx, dword [dword esp+07B0h]
        mov eax, dword [byte esp+08h]
        call DrawGadgetByType
        push byte 50h
        push byte 3Dh
        mov eax, dword [nosplit esi*4+hmcrestbmp]
        mov ebp, dword [byte eax+02Ch]
        push ebp
        call sub_913D0
        add esp, byte 0Ch
        movzx edi, byte [byte_D42C3]
        add edi, byte 78h
        xor eax, eax
        mov dword [dword esp+0778h], eax
        jmp near .12
.9:
        mov eax, dword [dword esp+esi*4+0750h]
        add eax, edx
        mov al, byte [byte eax+028h]
        and eax, 0FFh
        mov dword [dword esp+07C4h], eax
        cmp eax, byte 64h
        jge near .11
        mov ebp, esi
        shl ebp, 2
        sub ebp, esi
        shl ebp, 3
        mov eax, ebp
        shl ebp, 5
        sub ebp, eax
        mov eax, dword [dword esp+07C4h]
        mov ebx, dword [dword ebp+eax*4+hmteamrec_skaters]
        lea edx, [dword esp+069Ch]
        mov eax, dword [dword esp+0764h]
        call ReadKeyRec
        mov dword [dword esp+0788h], eax
        test eax, eax
        jne short .10
        mov ecx, 0C8h
        lea ebx, [dword esp+06AFh]
        xor edx, edx
        lea eax, [dword esp+05D4h]
        call FitPlayerName
        lea ebx, [dword esp+05D4h]
        mov edx, edi
        mov eax, 0B4h
        call PrintShadowText
        mov eax, esi
        shl eax, 4
        add eax, esi
        shl eax, 4
        add eax, esi
        mov ebp, dword [dword esp+07C4h]
        shl ebp, 2
        mov edx, dword [dword esp+07C4h]
        add ebp, edx
        shl ebp, 3
        sub ebp, edx
        cmp byte [dword ebp+eax*4+hmroster], 1
        jne short .10
        mov ebx, str_Injured2
        mov edx, edi
        mov eax, 226h
        call PrintShadowText
.10:
        xor eax, eax
        mov al, byte [byte_D42C3]
        add eax, byte 0Eh
        add edi, eax
.11:
        inc dword [dword esp+0778h]
.12:
        mov edx, dword [dword esp+0778h]
        cmp edx, byte 8
        jge short .13
        cmp dword [dword esp+0788h], byte 0
        je near GameSummaryScreen_period.9
.13:
        mov ebx, 10h
        mov edx, dword [dword esp+07A8h]
        xor eax, eax
        call FadePalStep
        mov eax, 3E8h
        call WaitClickTimeout
        mov dword [dword esp+07B4h], eax
        inc esi
        cmp esi, byte 2
        jl near GameSummaryScreen_period.7
.14:
        mov dword [dword esp+0780h], 0FFFFFFFFh
.15:
        cmp dword [dword esp+0780h], byte 0FFFFFFFFh
        je near .81
        push byte 20h
        mov eax, dword [dword esp+0774h]
        shl eax, 2
        mov ebp, dword [dword esp+0774h]
        sub eax, ebp
        shl eax, 2
        sub eax, ebp
        inc eax
        push eax
        push str_EVNT
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [dword esp+07C0h], eax
        xor ebx, ebx
        mov dword [dword esp+07BCh], ebx
        mov dword [dword esp+0778h], ebx
        mov dword [dword esp+07A0h], ebx
        xor dh, dh
        mov byte [dword esp+07CCh], dh
        mov byte [dword esp+07CDh], dh
.16:
        mov eax, dword [dword esp+07BCh]
        shl eax, 2
        mov ebp, dword [dword esp+07BCh]
        sub eax, ebp
        shl eax, 2
        sub eax, ebp
        mov esi, dword [dword esp+07C0h]
        add esi, eax
        mov ebx, dword [dword esp+0778h]
        mov edx, esi
        mov eax, dword [dword esp+0760h]
        call ReadGSummaryRec
        mov dword [dword esp+0788h], eax
        mov bh, byte [esi]
        cmp bh, 1
        jne short .17
        test byte [esp], bh
        jne short .19
.17:
        mov eax, dword [dword esp+07BCh]
        shl eax, 2
        mov ebx, dword [dword esp+07BCh]
        sub eax, ebx
        shl eax, 2
        sub eax, ebx
        add eax, dword [dword esp+07C0h]
        mov ch, byte [eax]
        cmp ch, 2
        jne short .18
        test byte [esp], ch
        jne short .19
.18:
        mov eax, dword [dword esp+07BCh]
        shl eax, 2
        mov ebp, dword [dword esp+07BCh]
        sub eax, ebp
        shl eax, 2
        sub eax, ebp
        add eax, dword [dword esp+07C0h]
        cmp byte [eax], 4
        jne short .22
        test byte [esp], 3
        je short .22
.19:
        mov eax, dword [dword esp+07BCh]
        shl eax, 2
        mov ecx, dword [dword esp+07BCh]
        sub eax, ecx
        shl eax, 2
        sub eax, ecx
        add eax, dword [dword esp+07C0h]
        cmp byte [eax], 4
        jne short .20
        inc dword [dword esp+07A0h]
.20:
        mov eax, dword [dword esp+07BCh]
        shl eax, 2
        mov edx, dword [dword esp+07BCh]
        sub eax, edx
        shl eax, 2
        sub eax, edx
        add eax, dword [dword esp+07C0h]
        mov bh, byte [eax]
        cmp bh, 1
        jne short .21
        lea ebp, [byte eax+01h]
        xor eax, eax
        mov al, byte [byte ebp+00h]
        add byte [dword esp+eax+07CCh], bh
.21:
        inc dword [dword esp+07BCh]
.22:
        mov ebp, dword [dword esp+0778h]
        inc ebp
        mov dword [dword esp+0778h], ebp
        cmp dword [dword esp+0788h], byte 0
        jne short .23
        cmp ebp, dword [dword esp+0770h]
        jle near GameSummaryScreen_period.16
.23:
        push byte 20h
        mov eax, dword [dword esp+07A4h]
        shl eax, 2
        inc eax
        push eax
        push str_PRDS
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [dword esp+07ACh], eax
        mov ebx, 1
        mov dword [dword esp+0794h], ebx
        xor ecx, ecx
        mov dword [dword esp+0778h], ecx
        xor esi, esi
        mov dword [dword esp+0798h], ebx
        mov dword [dword esp+0774h], ecx
        mov ebx, dword [dword esp+07A0h]
        mov ebp, dword [dword esp+07ACh]
.24:
        mov eax, dword [dword esp+0778h]
        shl eax, 2
        mov edx, dword [dword esp+0778h]
        sub eax, edx
        shl eax, 2
        sub eax, edx
        add eax, dword [dword esp+07C0h]
        cmp byte [eax], 4
        jne short .25
        mov edx, esi
        shl edx, 2
        add edx, ebp
        inc eax
        mov dword [edx], eax
        inc esi
.25:
        mov eax, dword [dword esp+0778h]
        inc eax
        mov dword [dword esp+0778h], eax
        cmp eax, dword [dword esp+0770h]
        jg short .26
        cmp esi, ebx
        jl short GameSummaryScreen_period.24
.26:
        mov al, byte [esp]
        test al, 24h
        jne near .28
        test al, 3
        je short .27
        lea eax, [dword esp+07CCh]
        push eax
        mov esi, dword [dword esp+07A4h]
        push esi
        xor edx, edx
        mov dl, byte [dword esp+07E8h]
        lea ecx, [dword esp+0670h]
        mov ebx, dword [dword esp+07B0h]
        mov eax, dword [byte esp+08h]
        call DrawGadgetByType
        push byte 50h
        push byte 3Dh
        mov eax, dword [hmcrestbmp]
        mov ebp, dword [byte eax+02Ch]
        push ebp
        call sub_913D0
        add esp, byte 0Ch
        push byte 50h
        push dword 221h
        mov eax, dword [vscrestbmp]
        mov edx, dword [byte eax+02Ch]
        push edx
        call sub_913D0
        add esp, byte 0Ch
        jmp short .28
.27:
        lea eax, [dword esp+07CCh]
        push eax
        mov ecx, dword [dword esp+07A4h]
        push ecx
        xor edx, edx
        mov dl, byte [dword esp+07E8h]
        lea ecx, [dword esp+0670h]
        mov ebx, dword [dword esp+07B0h]
        mov eax, dword [byte esp+08h]
        call DrawGadgetByType
.28:
        xor ebx, ebx
        mov dword [dword esp+0778h], ebx
        xor dl, dl
        mov byte [dword esp+07ECh], dl
        xor dh, dh
        mov byte [dword esp+07E8h], dh
        jmp near .78
.29:
        cmp al, 1
        jne near .47
        mov ebp, esi
        xor edx, edx
        mov dl, byte [esi]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add eax, edx
        xor edx, edx
        mov dl, byte [byte esi+01h]
        add eax, edx
        inc byte [dword esp+eax+06D0h]
        mov al, byte [byte esi+05h]
        cmp al, byte [dword esp+07E0h]
        jb near .47
        cmp al, byte [dword esp+07DCh]
        ja near .47
        test byte [esp], 1
        je near .47
        xor eax, eax
        mov al, byte [byte esi+01h]
        mov dword [dword esp+07C4h], eax
        xor edx, edx
        mov dl, byte [esi]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        mov edx, eax
        shl eax, 5
        sub eax, edx
        mov edx, dword [dword esp+07C4h]
        shl edx, 2
        add eax, edx
        mov ebx, dword [byte esp+eax+050h]
        lea edx, [dword esp+069Ch]
        mov eax, dword [dword esp+0764h]
        call ReadKeyRec
        mov dword [dword esp+0788h], eax
        test eax, eax
        jne near .30
        xor edx, edx
        mov dl, byte [esi]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        mov edx, eax
        shl eax, 5
        sub eax, edx
        lea edx, [byte esp+04h]
        add eax, edx
        push eax
        push str_S3
        lea eax, [dword esp+05DCh]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea ebx, [dword esp+05D4h]
        mov edx, edi
        mov eax, 96h
        call PrintShadowText
        mov ecx, 0C8h
        lea ebx, [dword esp+06AFh]
        xor edx, edx
        lea eax, [dword esp+05D4h]
        call FitPlayerName
        xor eax, eax
        mov al, byte [esi]
        mov eax, dword [dword esp+eax*4+0758h]
        mov ebx, dword [dword esp+06C8h]
        lea edx, [dword esp+0704h]
        call ReadSeasonRec
        mov dword [dword esp+0788h], eax
.30:
        cmp dword [dword esp+0788h], byte 0
        jne near .47
        xor edx, edx
        mov dl, byte [byte ebp+00h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add eax, edx
        add eax, dword [dword esp+07C4h]
        mov esi, dword [dword esp+eax+06CDh]
        sar esi, 18h
        test byte [gameopts+1], 2
        je short .31
        xor eax, eax
        mov ax, word [dword esp+0706h]
        jmp short .32
.31:
        xor eax, eax
        mov ax, word [dword esp+0718h]
.32:
        add esi, eax
        push esi
        push str_D5
        lea eax, [dword esp+073Ch]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea edx, [dword esp+0734h]
        lea eax, [dword esp+05D4h]
        call strcat_
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        mov ebx, 0Ah
        idiv ebx
        mov ebx, edx
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        mov esi, 64h
        idiv esi
        cmp ebx, byte 1
        jne short .33
        cmp edx, byte 0Bh
        je short .33
        mov edx, str_St
        jmp short .36
.33:
        cmp ebx, byte 2
        jne short .34
        cmp edx, byte 0Ch
        je short .34
        mov edx, str_Nd
        jmp short .36
.34:
        cmp ebx, byte 3
        jne short .35
        cmp edx, byte 0Dh
        je short .35
        mov edx, str_Rd
        jmp short .36
.35:
        mov edx, str_Th
.36:
        lea eax, [dword esp+05D4h]
        call strcat_
        mov dl, byte [byte ebp+04h]
        test dl, 2
        je short .37
        mov edx, str_SH
        jmp short .38
.37:
        test dl, 4
        je short .39
        mov edx, str_PP
.38:
        lea eax, [dword esp+05D4h]
        call strcat_
.39:
        lea ebx, [dword esp+05D4h]
        mov edx, edi
        mov eax, 0E6h
        call PrintShadowText
        mov byte [dword esp+07ECh], 0FFh
        xor eax, eax
        mov al, byte [byte ebp+07h]
        push eax
        xor eax, eax
        mov al, byte [byte ebp+06h]
        push eax
        push str_02d02d
        lea eax, [dword esp+05E0h]
        push eax
        call sprintf_
        add esp, byte 10h
        lea ebx, [dword esp+05D4h]
        mov edx, edi
        mov eax, 20Dh
        call PrintShadowText
        xor eax, eax
        mov al, byte [byte_D42C3]
        add edi, eax
        mov bh, byte [byte ebp+02h]
        cmp bh, 0FFh
        je near .42
        xor eax, eax
        mov al, bh
        mov dword [dword esp+07C4h], eax
        xor edx, edx
        mov dl, byte [byte ebp+00h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        mov edx, eax
        shl eax, 5
        sub eax, edx
        mov edx, dword [dword esp+07C4h]
        shl edx, 2
        add eax, edx
        mov ebx, dword [byte esp+eax+050h]
        lea edx, [dword esp+069Ch]
        mov eax, dword [dword esp+0764h]
        call ReadKeyRec
        mov dword [dword esp+0788h], eax
        test eax, eax
        jne short .40
        mov ecx, 0C8h
        lea ebx, [dword esp+06AFh]
        xor edx, edx
        lea eax, [dword esp+0734h]
        call FitPlayerName
        lea eax, [dword esp+0734h]
        push eax
        push str_S2
        lea eax, [dword esp+05DCh]
        push eax
        call sprintf_
        add esp, byte 0Ch
.40:
        mov cl, byte [byte ebp+03h]
        cmp cl, 0FFh
        je near .41
        xor eax, eax
        mov al, cl
        mov dword [dword esp+07C4h], eax
        xor eax, eax
        mov al, byte [byte ebp+00h]
        mov esi, eax
        shl esi, 2
        sub esi, eax
        shl esi, 3
        mov eax, esi
        shl esi, 5
        sub esi, eax
        mov ebx, dword [dword esp+07C4h]
        shl ebx, 2
        add ebx, esi
        mov ebx, dword [byte esp+ebx+050h]
        lea edx, [dword esp+069Ch]
        mov eax, dword [dword esp+0764h]
        call ReadKeyRec
        mov dword [dword esp+0788h], eax
        test eax, eax
        jne short .41
        mov ecx, 0C8h
        lea ebx, [dword esp+06AFh]
        xor edx, edx
        lea eax, [dword esp+0734h]
        call FitPlayerName
        mov edx, str_CommaSp
        lea eax, [dword esp+05D4h]
        call strcat_
        lea edx, [dword esp+0734h]
        lea eax, [dword esp+05D4h]
        call strcat_
.41:
        cmp dword [dword esp+0788h], byte 0
        jne short .42
        mov edx, str_RParen2
        lea eax, [dword esp+05D4h]
        call strcat_
        lea ebx, [dword esp+05D4h]
        mov edx, edi
        mov eax, 0E6h
        call PrintShadowText
.42:
        xor eax, eax
        mov al, byte [byte_D42C3]
        add edi, eax
        jmp near .47
.43:
        test byte [esp], 2
        je near .47
        mov al, byte [byte esi+04h]
        cmp al, byte [dword esp+07E0h]
        jb near .47
        cmp al, byte [dword esp+07DCh]
        ja near .47
        xor eax, eax
        mov al, byte [esi]
        mov ebp, eax
        shl ebp, 2
        sub ebp, eax
        shl ebp, 3
        mov eax, ebp
        shl ebp, 5
        sub ebp, eax
        lea eax, [byte esp+04h]
        add eax, ebp
        push eax
        push str_S3
        lea eax, [dword esp+05DCh]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea ebx, [dword esp+05D4h]
        mov edx, edi
        mov eax, 91h
        call PrintShadowText
        xor eax, eax
        mov al, byte [byte esi+01h]
        mov dword [dword esp+07C4h], eax
        xor eax, eax
        mov al, byte [esi]
        mov ebp, eax
        shl ebp, 2
        sub ebp, eax
        shl ebp, 3
        mov eax, ebp
        shl ebp, 5
        sub ebp, eax
        mov eax, dword [dword esp+07C4h]
        shl eax, 2
        add ebp, eax
        mov ebx, dword [byte esp+ebp+050h]
        lea edx, [dword esp+069Ch]
        mov eax, dword [dword esp+0764h]
        call ReadKeyRec
        mov dword [dword esp+0788h], eax
        test eax, eax
        jne near .47
        lea ebx, [dword esp+06AFh]
        mov edx, edi
        mov eax, 0DCh
        call PrintShadowText
        xor eax, eax
        mov al, byte [byte esi+06h]
        push eax
        xor eax, eax
        mov al, byte [byte esi+05h]
        push eax
        push str_02d02d
        lea eax, [dword esp+05E0h]
        push eax
        call sprintf_
        add esp, byte 10h
        lea ebx, [dword esp+05D4h]
        mov edx, edi
        mov eax, 229h
        call PrintShadowText
        xor eax, eax
        mov al, byte [byte_D42C3]
        add edi, eax
        mov dh, byte [byte esi+03h]
        cmp dh, 0FFh
        jne short .44
        xor eax, eax
        mov al, byte [byte esi+02h]
        mov edx, dword [nosplit eax*4+penaltynames]
        push edx
        push str_SS4
        lea eax, [dword esp+05DCh]
        push eax
        call sprintf_
        add esp, byte 0Ch
        jmp short .45
.44:
        xor eax, eax
        mov al, byte [byte esi+02h]
        mov ebp, dword [nosplit eax*4+penaltynames]
        push ebp
        xor eax, eax
        mov al, dh
        push eax
        push str_DMinS
        lea eax, [dword esp+05E0h]
        push eax
        call sprintf_
        add esp, byte 10h
.45:
        lea ebx, [dword esp+05D4h]
        mov edx, edi
        mov eax, 0DCh
        call PrintShadowText
        xor eax, eax
        mov al, byte [byte_D42C3]
        add edi, eax
        mov byte [dword esp+07E8h], 0FFh
        jmp short .47
.46:
        mov bl, byte [dword esp+07F0h]
        inc bl
        mov byte [dword esp+07F0h], bl
        cmp bl, byte [dword esp+07E0h]
        jb short .47
        cmp bl, byte [dword esp+07DCh]
        ja short .47
        mov edi, 177h
        mov ecx, 0FFFFFFFFh
        mov dword [dword esp+07B8h], ecx
        mov dword [dword esp+07B0h], ecx
.47:
        xor eax, eax
        mov al, byte [byte_D42C3]
        inc dword [dword esp+0778h]
        mov edx, 177h
        sub edx, eax
        cmp edi, edx
        jge short .48
        cmp dword [dword esp+07B8h], byte 0
        jne short .48
        cmp dword [dword esp+0780h], byte 0
        jne short .48
        cmp dword [dword esp+0788h], byte 0
        je near .78
.48:
        test byte [esp], 1
        je near .51
        xor al, al
        mov byte [dword esp+07D0h], al
        mov byte [dword esp+07D1h], al
        mov byte [dword esp+07C8h], al
        mov byte [dword esp+07C9h], al
        xor esi, esi
        jmp short .50
.49:
        mov edi, esi
        shl edi, 2
        add edi, dword [dword esp+07ACh]
        mov eax, dword [edi]
        mov al, byte [eax]
        add byte [dword esp+07D0h], al
        mov eax, dword [edi]
        mov al, byte [byte eax+02h]
        add byte [dword esp+07D1h], al
        mov eax, dword [edi]
        mov al, byte [byte eax+01h]
        add byte [dword esp+07C8h], al
        mov eax, dword [edi]
        mov al, byte [byte eax+03h]
        add byte [dword esp+07C9h], al
        inc esi
.50:
        movzx ebp, byte [dword esp+07D8h]
        cmp esi, ebp
        jl short GameSummaryScreen_period.49
        push str_ShotsOnGoal
        lea eax, [dword esp+05D8h]
        push eax
        call sprintf_
        add esp, byte 8
        lea eax, [dword esp+05D4h]
        push eax
        call fputchar
        add esp, byte 4
        mov edx, 1F4h
        sub edx, eax
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        add eax, 86h
        lea ebx, [dword esp+05D4h]
        mov edx, 190h
        call PrintShadowText
        movzx edi, byte [byte_D42C3]
        add edi, 190h
        xor eax, eax
        mov al, byte [dword esp+07C8h]
        push eax
        mov esi, ebp
        shl esi, 2
        add esi, dword [dword esp+07B0h]
        mov eax, dword [byte esi-04h]
        mov al, byte [byte eax+01h]
        and eax, 0FFh
        push eax
        lea eax, [byte esp+026h]
        push eax
        push str_SDD
        lea eax, [dword esp+05E4h]
        push eax
        call sprintf_
        add esp, byte 14h
        lea eax, [dword esp+05D4h]
        push eax
        call fputchar
        add esp, byte 4
        mov edx, 17Fh
        sub edx, eax
        lea eax, [byte edx-01Eh]
        lea ebx, [dword esp+05D4h]
        mov edx, edi
        call PrintShadowText
        xor eax, eax
        mov al, byte [dword esp+07C9h]
        push eax
        mov eax, dword [byte esi-04h]
        mov al, byte [byte eax+03h]
        and eax, 0FFh
        push eax
        lea eax, [dword esp+030Eh]
        push eax
        push str_SDD
        lea eax, [dword esp+05E4h]
        push eax
        call sprintf_
        add esp, byte 14h
        lea ebx, [dword esp+05D4h]
        mov edx, edi
        mov eax, 1A5h
        call PrintShadowText
.51:
        cmp dword [dword esp+0790h], byte 0
        jne near .58
        mov al, byte [esp]
        test al, 24h
        jne near .58
        test al, 1
        je near .57
        cmp dword [dword esp+0794h], byte 0
        je near .57
        xor ebx, ebx
        mov dword [dword esp+07A4h], ebx
        mov dword [dword esp+0794h], ebx
        cmp dword [gameresult], byte 1
        je short .52
        mov al, byte [dword esp+07E0h]
        cmp al, byte [dword esp+07DCh]
        je short .53
.52:
        mov ebx, 0FFFFFFFFh
        xor edx, edx
        xor eax, eax
        jmp short .56
.53:
        mov dh, byte [dword esp+07D8h]
        cmp dh, 4
        jae short .54
        xor eax, eax
        mov al, dh
        xor edx, edx
        jmp short .56
.54:
        cmp dh, 7
        jae short .55
        mov al, byte [dword esp+07CCh]
        cmp al, byte [dword esp+07CDh]
        jne short .55
        cmp dword [schedgameidx], 444h
        jl short .55
        xor eax, eax
        mov al, dh
        sub eax, byte 3
        xor ebx, ebx
        mov edx, 0FFFFFFFFh
        jmp short .56
.55:
        xor ebx, ebx
        mov edx, 0FFFFFFFFh
        xor eax, eax
.56:
        call PaScoringPeriod
.57:
        mov dword [dword esp+0790h], 1
.58:
        cmp dword [dword esp+07B0h], byte 0
        jne near .64
        mov esi, dword [dword esp+0778h]
        mov ebx, dword [dword esp+07C0h]
.59:
        mov eax, esi
        shl eax, 2
        sub eax, esi
        shl eax, 2
        sub eax, esi
        add eax, dword [dword esp+07C0h]
        mov cl, byte [eax]
        cmp cl, 4
        je short .63
        cmp cl, 1
        jne short .60
        test byte [esp], cl
        jne short .61
.60:
        mov eax, esi
        shl eax, 2
        sub eax, esi
        shl eax, 2
        sub eax, esi
        add eax, ebx
        mov dl, byte [eax]
        cmp dl, 2
        jne short .62
        test byte [esp], dl
        je short .62
.61:
        mov esi, dword [dword esp+0778h]
        jmp short .63
.62:
        inc esi
        jmp short GameSummaryScreen_period.59
.63:
        mov dword [dword esp+0778h], esi
        mov eax, esi
        shl eax, 2
        sub eax, esi
        shl eax, 2
        sub eax, esi
        add eax, dword [dword esp+07C0h]
        cmp byte [eax], 4
        jne short .64
        mov dword [dword esp+07B0h], 0FFFFFFFFh
        inc esi
        mov dword [dword esp+0778h], esi
.64:
        cmp byte [dword esp+07ECh], 0
        jne short .65
        test byte [esp], 1
        je short .65
        push str_NoScoring
        call fputchar
        add esp, byte 4
        mov edx, 1F4h
        sub edx, eax
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        add eax, 8Ch
        mov ebx, str_NoScoring
        mov edx, 10Bh
        call PrintShadowText
.65:
        cmp byte [dword esp+07E8h], 0
        jne short .66
        test byte [esp], 2
        je short .66
        push str_NoPenalties
        call fputchar
        add esp, byte 4
        mov edx, 1F4h
        sub edx, eax
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        add eax, 8Ch
        mov ebx, str_NoPenalties
        mov edx, 10Bh
        call PrintShadowText
.66:
        mov al, byte [dword esp+07D8h]
        cmp al, byte [dword esp+07DCh]
        jne short .68
        mov eax, dword [dword esp+0778h]
        cmp eax, dword [dword esp+07BCh]
        je short .67
        shl eax, 2
        mov edx, dword [dword esp+0778h]
        sub eax, edx
        shl eax, 2
        sub eax, edx
        add eax, dword [dword esp+07C0h]
        cmp byte [eax], 4
        jne short .68
.67:
        mov dword [dword esp+0780h], 0FFFFFFFFh
.68:
        cmp dword [dword esp+07B0h], byte 0
        je short .70
        cmp byte [dword esp+07D8h], 5
        jae short .69
        mov dword [dword esp+07A4h], 0FFFFFFFFh
.69:
        mov dword [dword esp+0774h], 1
        inc byte [dword esp+07D8h]
.70:
        xor edx, edx
        mov dword [dword esp+07B0h], edx
        xor bh, bh
        mov byte [dword esp+07ECh], bh
        xor cl, cl
        mov byte [dword esp+07E8h], cl
        cmp dword [dword esp+0798h], byte 0
        je short .71
        mov ebx, 10h
        mov edx, dword [dword esp+07A8h]
        xor eax, eax
        call FadePalStep
        xor ecx, ecx
        mov dword [dword esp+0798h], ecx
.71:
        test byte [esp], 1
        je short .72
        movzx esi, byte [dword esp+07D8h]
        cmp esi, byte 4
.72:
        mov eax, 3E8h
        call WaitClickTimeout
        mov dword [dword esp+07B4h], eax
        xor esi, esi
        mov dword [dword esp+07B8h], esi
        mov edi, 0A0h
        mov ebp, dword [dword esp+0780h]
        test ebp, ebp
        jne near .78
        cmp dword [dword esp+0788h], byte 0
        jne near .78
        cmp eax, byte 2
        jge near .78
        mov eax, dword [dword esp+0778h]
        cmp eax, dword [dword esp+07BCh]
        jge near .78
        cmp dword [dword esp+0774h], byte 0
        je short .73
        mov ebx, 10h
        mov edx, dword [dword esp+07A8h]
        mov eax, 1
        call FadePalette
        mov dword [dword esp+0798h], 1
        mov dword [dword esp+0774h], ebp
        push dword 1E0h
        push dword 8Ch
        push dword 280h
        push ebp
        jmp short .74
.73:
        push dword 1E0h
        push dword 8Ch
        push dword 280h
        push dword 80h
.74:
        call SetClipWindow
        add esp, byte 10h
        mov eax, dword [dword esp+079Ch]
        push eax
        call DrawShape
        add esp, byte 4
        test byte [esp], 3
        je short .75
        lea eax, [dword esp+07CCh]
        push eax
        mov ebx, dword [dword esp+07A4h]
        push ebx
        xor edx, edx
        mov dl, byte [dword esp+07E0h]
        lea ecx, [dword esp+0670h]
        mov ebx, dword [dword esp+07B0h]
        mov eax, dword [byte esp+08h]
        call DrawGadgetByType
        push byte 50h
        push byte 3Dh
        mov eax, dword [hmcrestbmp]
        mov ecx, dword [byte eax+02Ch]
        push ecx
        call sub_913D0
        add esp, byte 0Ch
        push byte 50h
        push dword 221h
        mov eax, dword [vscrestbmp]
        mov esi, dword [byte eax+02Ch]
        push esi
        call sub_913D0
        add esp, byte 0Ch
        jmp short .76
.75:
        lea eax, [dword esp+07CCh]
        push eax
        mov edx, dword [dword esp+07A4h]
        push edx
        xor edx, edx
        mov dl, byte [dword esp+07E0h]
        lea ecx, [dword esp+0670h]
        mov ebx, dword [dword esp+07B0h]
        mov eax, dword [byte esp+08h]
        call DrawGadgetByType
.76:
        test byte [esp], 1
        je short .78
        cmp dword [dword esp+07A4h], byte 0
        je short .78
        xor eax, eax
        mov dword [dword esp+07A4h], eax
        cmp dword [gameresult], byte 1
        je short .78
        mov al, byte [dword esp+07E0h]
        cmp al, byte [dword esp+07DCh]
        jne short .78
        mov dh, byte [dword esp+07D8h]
        cmp dh, 4
        jae near .79
        xor eax, eax
        mov al, dh
        xor ebx, ebx
        xor edx, edx
.77:
        call PaScoringPeriod
.78:
        mov ecx, dword [dword esp+0788h]
        test ecx, ecx
        jne near .81
        cmp dword [dword esp+0780h], byte 0
        jne near .81
        mov eax, dword [dword esp+0778h]
        cmp eax, dword [dword esp+07BCh]
        jge near .81
        cmp dword [dword esp+07B4h], byte 2
        jge near .81
        push dword 1E0h
        push ecx
        push dword 280h
        push ecx
        call SetClipWindow
        add esp, byte 10h
        mov eax, dword [dword esp+0778h]
        shl eax, 2
        mov edx, dword [dword esp+0778h]
        sub eax, edx
        shl eax, 2
        sub eax, edx
        mov esi, dword [dword esp+07C0h]
        add esi, eax
        mov al, byte [esi]
        inc esi
        cmp al, 2
        jb near GameSummaryScreen_period.29
        jbe near GameSummaryScreen_period.43
        cmp al, 4
        je near GameSummaryScreen_period.46
        jmp near GameSummaryScreen_period.47
.79:
        cmp dh, 7
        jae short .80
        mov al, byte [dword esp+07CCh]
        cmp al, byte [dword esp+07CDh]
        jne short .80
        cmp dword [schedgameidx], 444h
        jl short .80
        xor eax, eax
        mov al, dh
        sub eax, byte 3
        xor ebx, ebx
        mov edx, 0FFFFFFFFh
        jmp near GameSummaryScreen_period.77
.80:
        xor ebx, ebx
        mov edx, 0FFFFFFFFh
        xor eax, eax
        jmp near GameSummaryScreen_period.77
.81:
        cmp byte [musicon], 0
        je short .82
        cmp dword [songdata], byte 0
        je short .82
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 3
        call SetDigiChannelVolume
.82:
        mov ebx, 10h
        mov edx, dword [dword esp+07A8h]
        mov eax, 1
        call FadePalStep
        cmp byte [musicon], 0
        je short .84
        cmp dword [songdata], byte 0
        je short .84
.83:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short GameSummaryScreen_period.83
        mov edi, dword [songdata]
        push edi
        call PushMemDescriptorLocked
        add esp, byte 4
        xor ebp, ebp
        mov dword [songdata], ebp
        jmp short .85
.84:
        call StopDigiSample
.85:
        call SetScreenTarget
        push byte 0
        call ClearScreen
        add esp, byte 4
        mov eax, dword [dword esp+07ACh]
        test eax, eax
        je short .86
        push eax
        call FreeMemBlock
        add esp, byte 4
.86:
        mov ebx, dword [dword esp+07C0h]
        test ebx, ebx
        je short .87
        push ebx
        call FreeMemBlock
        add esp, byte 4
.87:
        lea eax, [dword esp+075Ch]
        call FileClose
        lea eax, [dword esp+0758h]
        call FileClose
        lea eax, [dword esp+0764h]
        call FileClose
        lea eax, [dword esp+0760h]
        call FileClose
        lea eax, [dword esp+0628h]
        push eax
        call TextRestoreState
        add esp, byte 4
        mov esi, dword [dword esp+077Ch]
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov edi, dword [dword esp+078Ch]
        push edi
        call FreeMemBlock
        add esp, byte 4
        mov ebp, dword [dword esp+0784h]
        push ebp
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [hmcrestbmp]
        push eax
        call FreeMemBlock
        add esp, byte 4
        mov edx, dword [vscrestbmp]
        push edx
        call FreeMemBlock
        add esp, byte 4
        mov ebx, dword [dword esp+076Ch]
        test ebx, ebx
        je short .88
        mov eax, ebx
        call FreeSample
.88:
        xor ecx, ecx
        mov dword [dword esp+0780h], ecx
        cmp dword [dword esp+07B4h], byte 3
        jne short .89
        mov dword [dword esp+0780h], 4
.89:
        mov eax, dword [dword esp+0780h]
        add esp, 7F4h
        pop ebp
        pop edi
        pop esi
        ret
;-----------------------------------------------------------------------------
; PickOtherGames                               2F2B1  95 PC, medium confidence
; (home, visitor): picks 6 random pairs of other teams (rand % 26, no
; repeats, not the two playing, teamstartlag <= home's) and clears their
; scores and periods
;-----------------------------------------------------------------------------
; C: src/front/summary/PickOtherGames.c
%ifdef CBUILD
%include "c/front/summary/PickOtherGames.inc"
%else
PickOtherGames:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 8
        mov ch, al
        mov byte [esp], dl
        xor eax, eax
        mov al, ch
        mov al, byte [dword eax+teamstartlag]
        mov byte [byte esp+04h], al
        xor edi, edi
.1:
        xor edx, edx
        mov dword [nosplit edi*4+otherperiod], edx
        xor dl, dl
        mov byte [nosplit edi*2+otherscores], dl
        mov byte [nosplit edi*2+otherscoresb], dl
.2:
        xor esi, esi
        call rand_
        mov edx, eax
        mov ebx, 1Ah
        sar edx, 1Fh
        idiv ebx
        lea eax, [edi+edi]
        mov byte [dword eax+othergames], dl
        cmp ch, dl
        je short .3
        cmp dl, byte [esp]
        je short .3
        mov al, dl
        and eax, 0FFh
        mov al, byte [dword eax+teamstartlag]
        cmp al, byte [byte esp+04h]
        jbe short .4
.3:
        mov esi, 0FFFFFFFFh
.4:
        xor edx, edx
        jmp short .8
.5:
        lea eax, [edi+edi]
        lea ebx, [edx+edx]
        mov cl, byte [dword eax+othergames]
        cmp cl, byte [dword ebx+othergames]
        je short .6
        cmp cl, byte [dword ebx+othergamesb]
        jne short .7
.6:
        mov esi, 0FFFFFFFFh
.7:
        inc edx
.8:
        cmp edx, edi
        jge short .9
        test esi, esi
        je short PickOtherGames.5
.9:
        test esi, esi
        jne short PickOtherGames.2
.10:
        xor esi, esi
        call rand_
        mov edx, eax
        mov ebx, 1Ah
        sar edx, 1Fh
        idiv ebx
        lea eax, [edi+edi]
        mov byte [dword eax+othergamesb], dl
        cmp dl, byte [dword eax+othergames]
        je short .11
        cmp ch, dl
        je short .11
        cmp dl, byte [esp]
        jne short .12
.11:
        mov esi, 0FFFFFFFFh
.12:
        xor edx, edx
        jmp short .16
.13:
        lea eax, [edi+edi]
        lea ebx, [edx+edx]
        mov cl, byte [dword eax+othergamesb]
        cmp cl, byte [dword ebx+othergames]
        je short .14
        mov al, cl
        cmp al, byte [dword ebx+othergamesb]
        jne short .15
.14:
        mov esi, 0FFFFFFFFh
.15:
        inc edx
.16:
        cmp edx, edi
        jge short .17
        test esi, esi
        je short PickOtherGames.13
.17:
        test esi, esi
        jne short PickOtherGames.10
        inc edi
        cmp edi, byte 6
        jl near PickOtherGames.1
        add esp, byte 8
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; UpdateOtherScores                            2F3D7  95 PC, medium confidence
; (period): advances the 6 other games to period + teamstartlag difference,
; adding rand % 3 goals per period; ties go to OT (70% chance each side
; scores) and finish as 5 (final OT) or 6 (final)
;-----------------------------------------------------------------------------
; C: src/front/summary/UpdateOtherScores.c
%ifdef CBUILD
%include "c/front/summary/UpdateOtherScores.inc"
%else
UpdateOtherScores:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        push eax
        xor edi, edi
.1:
        mov al, byte [nosplit edi*2+othergames]
        and eax, 0FFh
        xor edx, edx
        mov dl, byte [dword eax+teamstartlag]
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        mov al, byte [dword eax+teamstartlag]
        and eax, 0FFh
        sub eax, edx
        mov dword [byte esp+04h], eax
        mov eax, dword [esp]
        mov edx, dword [byte esp+04h]
        add edx, eax
        mov dword [byte esp+04h], edx
        mov esi, edi
        shl esi, 2
        mov ebx, dword [dword esi+otherperiod]
        cmp edx, ebx
        jl near .9
        mov esi, ebx
        jmp near .8
.2:
        mov ebx, edi
        shl ebx, 2
        cmp esi, byte 4
        jne near .5
        lea ecx, [edi+edi]
        mov al, byte [dword ecx+otherscores]
        cmp al, byte [dword ecx+otherscoresb]
        jne short .4
        mov dword [dword ebx+otherperiod], esi
        call rand_
        mov edx, eax
        and edx, 7FFFh
        mov ebp, 64h
        mov eax, edx
        sar edx, 1Fh
        idiv ebp
        cmp edx, byte 46h
        jle short .3
        mov dword [dword ebx+otherperiod], 5
        inc byte [dword ecx+otherscores]
        jmp near .7
.3:
        call rand_
        and eax, 7FFFh
        mov edx, eax
        sar edx, 1Fh
        idiv ebp
        cmp edx, byte 46h
        jle near .7
        mov dword [dword ebx+otherperiod], 5
        inc byte [dword ecx+otherscoresb]
        jmp near .7
.4:
        mov dword [dword ebx+otherperiod], 6
        jmp near .7
.5:
        cmp esi, byte 5
        jne short .6
        cmp dword [dword ebx+otherperiod], byte 4
        jne short .6
        mov dword [dword ebx+otherperiod], esi
        jmp short .7
.6:
        mov ebx, edi
        shl ebx, 2
        mov eax, dword [dword ebx+otherperiod]
        cmp eax, byte 3
        jge short .7
        cmp esi, eax
        je short .7
        mov dword [dword ebx+otherperiod], esi
        call rand_
        mov edx, eax
        and edx, 7FFFh
        mov ecx, 3
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov ecx, edx
        xor edx, edx
        mov dl, byte [nosplit edi*2+otherscores]
        add edx, ecx
        mov byte [nosplit edi*2+otherscores], dl
        call rand_
        mov edx, eax
        and edx, 7FFFh
        mov ecx, 3
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov eax, edx
        xor edx, edx
        mov dl, byte [nosplit edi*2+otherscoresb]
        add edx, eax
        mov byte [nosplit edi*2+otherscoresb], dl
.7:
        inc esi
.8:
        cmp esi, dword [byte esp+04h]
        jle near UpdateOtherScores.2
.9:
        inc edi
        cmp edi, byte 6
        jl near UpdateOtherScores.1
        add esp, byte 8
UpdateOtherScores_x:
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; PrintClampedText                             2F580  95 PC, medium confidence
; PrintShadowText with x clamped into the left (8..F0h) or right (..280h)
; half by the text width
;-----------------------------------------------------------------------------
; C: src/front/summary/PrintClampedText.c
%ifdef CBUILD
%include "c/front/summary/PrintClampedText.inc"
%else
PrintClampedText:
        push dword 18h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        mov esi, eax
        mov ebp, edx
        mov edi, ebx
        push ebx
        call fputchar
        add esp, byte 4
        mov edx, eax
        cmp esi, 140h
        jl short .1
        lea ebx, [esi+eax]
        cmp ebx, 280h
        jle short .1
        mov esi, 280h
        sub esi, eax
        jmp short .2
.1:
        cmp esi, 140h
        jge short .2
        lea eax, [esi+edx]
        cmp eax, 0F0h
        jle short .2
        mov esi, 0F0h
        sub esi, edx
        cmp esi, byte 8
        jge short .2
        mov esi, 8
.2:
        mov ebx, edi
        mov edx, ebp
        mov eax, esi
        call PrintShadowText
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; GameStatsScreen                                                 2F5EE  95 PC
; DeskGameStats: gsta / leaguetm screen listing gamestatlabels with both
; teams' values (score, shots, one timers, PP goals/chances, PP time and
; shots, penalties/min, faceoffs, body checks, attack zone time, passing %)
;-----------------------------------------------------------------------------
; C: src/front/summary/UpdateOtherScores.c (GameStatsScreen)
%ifdef CBUILD
%include "c/front/summary/UpdateOtherScores.GameStatsScreen.inc"
%else
GameStatsScreen:
        push dword 3A4h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 374h
        mov eax, dword [HomeTeam-2]
        sar eax, 10h
        mov dword [byte ebp-020h], eax
        mov eax, dword [VisTeam-2]
        sar eax, 10h
        mov dword [byte ebp-01Ch], eax
        call ClearInputQueue
        call SetScreenTarget
        push byte 0
        call ClearScreen
        add esp, byte 4
        xor ah, ah
        mov byte [byte ebp-034h], ah
        mov byte [byte ebp-033h], ah
        mov byte [byte ebp-032h], ah
        xor edi, edi
.1:
        lea eax, [byte ebp-034h]
        push eax
        push byte 1
        push edi
        call VgaSetPalette
        add esp, byte 0Ch
        inc edi
        cmp edi, 100h
        jl short GameStatsScreen.1
        xor ecx, ecx
        mov ebx, str_Ctbkgd3
        cmp byte [fileoncd+058h], 1
        jne short .2
        mov edx, dword [cddriveptr]
        jmp short .3
.2:
        xor edx, edx
.3:
        lea eax, [byte ebp-034h]
        call MakePath
        push byte 0
        lea eax, [byte ebp-034h]
        push eax
        call LoadBank
        mov esi, eax
        add esp, byte 8
        push str_Pal14
        push eax
        call FindShape
        add esp, byte 8
        lea edx, [byte eax+010h]
        mov ebx, 300h
        lea eax, [dword ebp-0374h]
        call memcpy_
        push str_Bkgd6
        push esi
        call FindShape
        add esp, byte 8
        push eax
        call DrawShape
        add esp, byte 4
        push esi
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov ebx, str_Cttitle32
        cmp byte [fileoncd+05Ch], 1
        jne short .4
        mov edx, dword [cddriveptr]
        jmp short .5
.4:
        xor edx, edx
.5:
        lea eax, [byte ebp-034h]
        call MakePath
        push byte 0
        lea eax, [byte ebp-034h]
        push eax
        call LoadBank
        mov esi, eax
        add esp, byte 8
        push str_Colm2
        push eax
        call FindShape
        add esp, byte 8
        push eax
        call DrawShape
        add esp, byte 4
        push str_Gsta
        push esi
        call FindShape
        add esp, byte 8
        push eax
        call DrawShape
        add esp, byte 4
        push esi
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov ebx, str_Ctlogo3
        cmp byte [fileoncd+059h], 1
        jne short .6
        mov edx, dword [cddriveptr]
        jmp short .7
.6:
        xor edx, edx
.7:
        lea eax, [byte ebp-034h]
        call MakePath
        push byte 0
        lea eax, [byte ebp-034h]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [byte ebp-010h], eax
        lea eax, [byte ebp-074h]
        push eax
        call TextSaveState
        add esp, byte 4
        mov edx, dword [kaufmfont]
        push edx
        call TextSetFont
        add esp, byte 4
        xor edx, edx
        mov eax, 40h
        call SetTextColors
        mov dword [byte ebp-0Ch], 0B0h
        xor edi, edi
.8:
        mov ecx, dword [nosplit edi*4+gamestatlabels]
        push ecx
        call fputchar
        add esp, byte 4
        mov edx, 26Ch
        sub edx, eax
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov ebx, dword [nosplit edi*4+gamestatlabels]
        mov edx, dword [byte ebp-0Ch]
        call PrintShadowText
        add dword [byte ebp-0Ch], byte 18h
        inc edi
        cmp edi, byte 0Ch
        jl short GameStatsScreen.8
        xor edi, edi
.9:
        mov eax, dword [byte ebp+edi*4-020h]
        mov edx, dword [nosplit eax*4+crestnames]
        push edx
        mov ebx, dword [byte ebp-010h]
        push ebx
        call FindShape
        add esp, byte 8
        mov edx, eax
        push byte 4Eh
        test edi, edi
        je short .10
        mov eax, 212h
        jmp short .11
.10:
        mov eax, 40h
.11:
        push eax
        push edx
        call sub_913D0
        add esp, byte 0Ch
        mov eax, edi
        shl eax, 3
        sub eax, edi
        mov ebx, eax
        shl eax, 6
        add eax, ebx
        mov dword [byte ebp-018h], eax
        mov eax, edi
        shl eax, 2
        sub eax, edi
        shl eax, 3
        mov edx, eax
        shl eax, 5
        sub eax, edx
        add eax, hmteamrec
        lea esi, [byte eax+01Ah]
        push esi
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, dword [byte ebp-018h]
        add edx, byte 49h
        mov dword [byte ebp-08h], edx
        sub edx, eax
        mov eax, edx
        mov ebx, esi
        mov edx, 8Ah
        call PrintShadowText
        mov esi, edi
        shl esi, 8
        mov eax, dword [dword esi+hmscore-2]
        sar eax, 10h
        push eax
        push str_D7
        lea eax, [byte ebp-034h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea eax, [byte ebp-034h]
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, dword [byte ebp-08h]
        sub edx, eax
        mov eax, edx
        lea ebx, [byte ebp-034h]
        mov edx, 0B0h
        call PrintClampedText
        mov eax, dword [dword esi+hmtmstruct-2]
        sar eax, 10h
        push eax
        push str_D7
        lea eax, [byte ebp-034h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea eax, [byte ebp-034h]
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, dword [byte ebp-08h]
        sub edx, eax
        mov eax, edx
        lea ebx, [byte ebp-034h]
        mov edx, 0C8h
        call PrintClampedText
        mov eax, dword [dword esi+hmtmstruct+16h]
        sar eax, 10h
        push eax
        push str_D7
        lea eax, [byte ebp-034h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea eax, [byte ebp-034h]
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, dword [byte ebp-08h]
        sub edx, eax
        mov eax, edx
        lea ebx, [byte ebp-034h]
        mov edx, 0E0h
        call PrintClampedText
        mov eax, dword [dword esi+hmtmstruct+2]
        sar eax, 10h
        push eax
        mov eax, dword [dword esi+hmtmstruct]
        sar eax, 10h
        push eax
        push str_DD
        lea eax, [byte ebp-034h]
        push eax
        call sprintf_
        add esp, byte 10h
        lea eax, [byte ebp-034h]
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, dword [byte ebp-08h]
        sub edx, eax
        mov eax, edx
        lea ebx, [byte ebp-034h]
        mov edx, 0F8h
        call PrintClampedText
        mov ecx, dword [dword esi+hmtmstruct+6]
        sar ecx, 10h
        mov ebx, 3Ch
        mov eax, ecx
        mov edx, ecx
        sar edx, 1Fh
        idiv ebx
        mov ebx, eax
        mov dword [byte ebp-04h], 3Ch
        mov eax, ecx
        mov edx, ecx
        sar edx, 1Fh
        idiv dword [byte ebp-04h]
        push edx
        push ebx
        push str_D02d2
        lea eax, [byte ebp-034h]
        push eax
        call sprintf_
        add esp, byte 10h
        lea eax, [byte ebp-034h]
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, dword [byte ebp-08h]
        sub edx, eax
        mov eax, edx
        lea ebx, [byte ebp-034h]
        mov edx, 110h
        call PrintClampedText
        mov eax, dword [dword esi+hmtmstruct+4]
        sar eax, 10h
        push eax
        push str_D7
        lea eax, [byte ebp-034h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea eax, [byte ebp-034h]
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, dword [byte ebp-08h]
        sub edx, eax
        mov eax, edx
        lea ebx, [byte ebp-034h]
        mov edx, 128h
        call PrintClampedText
        mov eax, dword [dword esi+hmtmstruct+0Ah]
        sar eax, 10h
        push eax
        mov eax, dword [dword esi+hmtmstruct+8]
        sar eax, 10h
        push eax
        push str_DD
        lea eax, [byte ebp-034h]
        push eax
        call sprintf_
        add esp, byte 10h
        lea eax, [byte ebp-034h]
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, dword [byte ebp-08h]
        sub edx, eax
        mov eax, edx
        lea ebx, [byte ebp-034h]
        mov edx, 140h
        call PrintClampedText
        mov eax, dword [dword esi+hmscore]
        sar eax, 10h
        push eax
        push str_D7
        lea eax, [byte ebp-034h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea eax, [byte ebp-034h]
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, dword [byte ebp-08h]
        sub edx, eax
        mov eax, edx
        lea ebx, [byte ebp-034h]
        mov edx, 158h
        call PrintClampedText
        mov eax, dword [dword esi+hmtmstruct+12h]
        sar eax, 10h
        push eax
        push str_D7
        lea eax, [byte ebp-034h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea eax, [byte ebp-034h]
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, dword [byte ebp-08h]
        sub edx, eax
        mov eax, edx
        lea ebx, [byte ebp-034h]
        mov edx, 170h
        call PrintClampedText
        mov eax, dword [dword esi+hmtmstruct+22h]
        sar eax, 10h
        push eax
        push str_D7
        lea eax, [byte ebp-034h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea eax, [byte ebp-034h]
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, dword [byte ebp-08h]
        sub edx, eax
        mov eax, edx
        lea ebx, [byte ebp-034h]
        mov edx, 188h
        call PrintClampedText
        mov ecx, dword [dword esi+hmtmstruct+0Ch]
        sar ecx, 10h
        mov ebx, 3Ch
        mov eax, ecx
        mov edx, ecx
        sar edx, 1Fh
        idiv ebx
        mov ebx, eax
        mov dword [byte ebp-04h], 3Ch
        mov eax, ecx
        mov edx, ecx
        sar edx, 1Fh
        idiv dword [byte ebp-04h]
        push edx
        push ebx
        push str_D02d2
        lea eax, [byte ebp-034h]
        push eax
        call sprintf_
        add esp, byte 10h
        lea eax, [byte ebp-034h]
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, dword [byte ebp-08h]
        sub edx, eax
        mov eax, edx
        lea ebx, [byte ebp-034h]
        mov edx, 1A0h
        call PrintClampedText
        xor ebx, ebx
        mov dword [byte ebp-0Ch], 1B8h
        cmp word [dword esi+hmpassatt], byte 0
        je short .12
        mov edx, dword [dword esi+hmpasscmp-2]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add edx, eax
        shl edx, 2
        mov ebx, dword [dword esi+hmpassatt-2]
        sar ebx, 10h
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov ebx, eax
.12:
        push ebx
        mov eax, edi
        shl eax, 8
        mov edx, dword [dword eax+hmpassatt-2]
        sar edx, 10h
        push edx
        mov eax, dword [dword eax+hmpasscmp-2]
        sar eax, 10h
        push eax
        push str_DDD
        lea eax, [byte ebp-034h]
        push eax
        call sprintf_
        add esp, byte 14h
        mov eax, edi
        shl eax, 3
        sub eax, edi
        mov esi, eax
        shl esi, 6
        add esi, eax
        lea eax, [byte ebp-034h]
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        add esi, byte 49h
        sub esi, eax
        mov eax, esi
        lea ebx, [byte ebp-034h]
        mov edx, dword [byte ebp-0Ch]
        call PrintClampedText
        inc edi
        cmp edi, byte 2
        jl near GameStatsScreen.9
        cmp byte [musicon], 0
        je near .16
        cmp dword [songdata], byte 0
        je short .13
        mov eax, dword [musichandle]
        mov ebx, 28h
        mov edx, 3
        call SetDigiChannelVolume
        push byte 28h
        call SetTickDeadline
        add esp, byte 4
        call WaitTickDeadline
        mov edi, dword [songdata]
        push edi
        call PushMemDescriptorLocked
        add esp, byte 4
        xor eax, eax
        mov dword [songdata], eax
.13:
        call MusicChanCmd3
        mov ecx, str_Iff7
        mov ebx, str_Leaguetm
        cmp byte [fileoncd+01E0h], 1
        jne short .14
        mov edx, dword [cddriveptr]
        jmp short .15
.14:
        xor edx, edx
.15:
        lea eax, [byte ebp-034h]
        call MakePath
        lea eax, [byte ebp-034h]
        call LoadDigiFile
        mov dword [songdata], eax
        test eax, eax
        je near .21
        test byte [gameopts], 40h
        je near .21
        mov edx, dword [musichandle]
        mov ecx, 7Fh
        mov ebx, 3
        call PlayDigiBlockLoop
        jmp near .21
.16:
        cmp dword [sounddev], byte 8
        jne short .18
        xor ecx, ecx
        mov ebx, str_Mtsum2
        cmp byte [fileoncd+0102h], 1
        jne short .17
        mov edx, dword [cddriveptr]
        jmp short .20
.17:
        xor edx, edx
        jmp short .20
.18:
        xor ecx, ecx
        mov ebx, str_Adsum2
        cmp byte [fileoncd+021h], 1
        jne short .19
        mov edx, dword [cddriveptr]
        jmp short .20
.19:
        xor edx, edx
.20:
        lea eax, [byte ebp-034h]
        call MakePath
        mov dword [cursndbank], 20h
        lea eax, [byte ebp-034h]
        call LoadSample
        mov dword [byte ebp-014h], eax
        xor ecx, ecx
        mov dword [cursndbank], ecx
        call PlayDigiSample
.21:
        mov ebx, 10h
        lea edx, [dword ebp-0374h]
        xor eax, eax
        call FadePalStep
        mov eax, 7D0h
        call WaitClickTimeout
        cmp byte [musicon], 0
        je short .22
        cmp dword [songdata], byte 0
        je short .22
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 3
        call SetDigiChannelVolume
.22:
        mov ebx, 10h
        lea edx, [dword ebp-0374h]
        mov eax, 1
        call FadePalStep
        cmp byte [musicon], 0
        je short .24
        cmp dword [songdata], byte 0
        je short .25
.23:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short GameStatsScreen.23
        mov ecx, dword [songdata]
        push ecx
        call PushMemDescriptorLocked
        add esp, byte 4
        xor esi, esi
        mov dword [songdata], esi
        jmp short .25
.24:
        call StopDigiSample
        mov eax, dword [byte ebp-014h]
        call FreeSample
.25:
        lea eax, [byte ebp-074h]
        push eax
        call TextRestoreState
        add esp, byte 4
        mov edi, dword [byte ebp-010h]
        push edi
        call FreeMemBlock
        add esp, byte 4
        mov esp, ebp
        jmp near UpdateOtherScores_x
%endif ; C
