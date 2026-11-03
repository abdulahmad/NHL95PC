; Start-up and the in-game pads. Memory and disk checks, keyboard, joystick and mouse, hot keys,
; the frame loop, the palette fade, and the game loop that launches a game.
bits 32
%include "hockey.inc"
section s_10010 progbits alloc exec nowrite align=1
extern __CHK, __STOSB, _dos_getdiskfree_, _dos_getdrive_, _dos_gettime_, addtimer, awardtype, awardwinners
extern bailout_vec, bannertimer, bgscrollx, bgscrolly, BuildDefaultLines, byte_C5138, byte_D416A, byte_D8C88
extern byte_D9299, camx, camx_m2, camy, cddriveptr, ClearInputQueue, ClockTick, clockticks
extern cont1team, cont2team, CritErrHandler, Crowd_Noise, CrowdFadeOut, CrowdNoiseOff, CrowdNoiseReset, ctl1dev
extern ctl1side, ctl1team, ctl2dev, ctl2side, ctl2team, ctlavailmask, cupteam, curleague
extern curperiod, deferpending, demomode, DoGameFrame, DrawHudPanel, DrawRinkOverlays, DrawSprite, dword_C4CFC
extern dword_C5131, dword_C5133, dword_C5135, dword_CC080, dword_D30D4, dword_D4158, dword_D415C, dword_D4160
extern dword_D4164, dword_D8C4C, dword_D8C72, dword_D8C7A, dword_DEF8C, dword_E0244, dword_E9A9E, escrequest
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
extern musicslot, NormalizeDressFlags, numshapes, off_C524F, off_C5253, off_C5257, off_C525B, off_C525F
extern off_C5263, off_C5267, off_C526F, off_C5273, off_CBED0, ovlseq, ovlstep, pad1dev
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
extern str_Scor3b, str_Temp3, str_VFN, strcat_, strcpy_, sub_1B982, sub_1BAF3, sub_6A9CE
extern sub_6ADA7, sub_6AF52, sub_6AF97, sub_6B008, sub_8CCA8, sub_8D2F0, sub_8DF54, sub_8E080
extern sub_8E7A0, sub_8E83C, sub_8E8A0, sub_8EA18, sub_8F633, sub_8F963, sub_8F96E, sub_8F979
extern sub_8F984, sub_8FC8A, sub_8FCDF, sub_8FFB0, sub_90354, sub_9035C, sub_B29F0, sub_B2CBE
extern sub_B2E1B, sub_B2F22, sub_B3036, sub_B30B4, sub_B30F4, sub_B33DB, sub_B3464, sub_B392C
extern sub_B3A24, sub_B4B58, sub_B4B88, sub_B4BA8, sub_B4BC4, sub_B4C33, sub_B4C84, teamabbrevs
extern TicksSinceLastCall, treeteamnames, unk_C4E30, unk_D958C, unk_D95C0, unk_D95F4, unk_D9628, unk_D965C
extern unk_D9690, unk_D96F8, unk_D972C, unk_D9794, unk_D98C3, UpdateHudPanel, viewscrollx, viewscrolly
extern VisTeam, vtoa, WaitTickDeadline, word_CBC44
global GetMemListHead, GetMemStats, main_, main_x, DiskFreeBytes, SetupControllers, ReadKeyboardPad, ReadJoyPad
global ReadMousePad, ReadControllerPad, ReadHotKeys, ReadSkipKeys, SampleInputTick, SetScreenSize, IntermissionPC, DrawSpriteNumber
global DrawFrameSprite, DrawRinkEndArt, WaitKeyRelease, HandleHotKey, HandleHotKey_ret, ResetInputSampling, RunGameFrames, SetFullPalette
global FadePalette, Gameloop, PlayGame, assreplace, assinsert, ReplayIsEmpty
; C: src/c/front/main/GetMemListHead.c
%ifdef CBUILD
%include "c/front/main/GetMemListHead.inc"
%else
GetMemListHead:
push dword 4	; 10010
call __CHK	; 10015
test eax, eax	; 1001A
je short .1	; 1001C
mov eax, dword [memlist1]	; 1001E
ret	; 10023
.1:
mov eax, dword [memlist0]	; 10024
ret	; 10029
%endif ; C
; C: src/c/front/main/GetMemStats.c
%ifdef CBUILD
%include "c/front/main/GetMemStats.inc"
%else
GetMemStats:
push dword 14h	; 1002A
call __CHK	; 1002F
push esi	; 10034
push edi	; 10035
push ebp	; 10036
push eax	; 10037
mov esi, edx	; 10038
mov eax, 1	; 1003A
call GetMemListHead	; 1003F
mov edx, eax	; 10044
mov eax, dword [byte eax+020h]	; 10046
mov dword [ecx], 0	; 10049
mov edi, dword [ecx]	; 1004F
mov dword [ebx], edi	; 10051
mov dword [esi], edi	; 10053
mov ebp, dword [esp]	; 10055
mov dword [byte ebp+00h], edi	; 10058
.1:
test eax, eax	; 1005B
je short .4	; 1005D
mov edi, dword [eax]	; 1005F
sub edi, dword [edx]	; 10061
mov ebp, dword [byte edx+010h]	; 10063
mov edx, edi	; 10066
sub edx, ebp	; 10068
test byte [byte eax+019h], 80h	; 1006A
jne short .2	; 1006E
mov edi, dword [byte eax+010h]	; 10070
add dword [esi], edi	; 10073
.2:
add dword [ebx], edx	; 10075
cmp edx, dword [ecx]	; 10077
jbe short .3	; 10079
mov dword [ecx], edx	; 1007B
.3:
mov edx, eax	; 1007D
mov eax, dword [byte eax+020h]	; 1007F
jmp short GetMemStats.1	; 10082
.4:
mov eax, dword [esi]	; 10084
add eax, dword [ebx]	; 10086
mov edx, dword [esp]	; 10088
mov dword [edx], eax	; 1008B
add esp, byte 4	; 1008D
pop ebp	; 10090
pop edi	; 10091
pop esi	; 10092
ret	; 10093
%endif ; C
; C: src/c/front/main/main_.c
%ifdef CBUILD
%include "c/front/main/main_.inc"
%else
main_:
push dword 9Ch	; 10094
call __CHK	; 10099
push ebx	; 1009E
push ecx	; 1009F
push edx	; 100A0
push esi	; 100A1
push ebp	; 100A2
sub esp, byte 70h	; 100A3
lea eax, [byte esp+054h]	; 100A6
call _dos_getdrive_	; 100AA
cmp dword [byte esp+054h], byte 2	; 100AF
je short .1	; 100B4
mov eax, 3	; 100B6
call DiskFreeBytes	; 100BB
cmp eax, 800h	; 100C0
jge short .1	; 100C5
push str_NoDiskSpaceC	; 100C7
call printf_	; 100CC
add esp, byte 4	; 100D1
xor eax, eax	; 100D4
call exit_	; 100D6
.1:
lea edx, [byte esp+04Ch]	; 100DB
xor eax, eax	; 100DF
call _dos_getdiskfree_	; 100E1
test eax, eax	; 100E6
je short .2	; 100E8
push str_ErrDiskFree2	; 100EA
call FatalError	; 100EF
add esp, byte 4	; 100F4
.2:
xor esi, esi	; 100F7
mov si, word [byte esp+050h]	; 100F9
xor ecx, ecx	; 100FE
mov cx, word [byte esp+052h]	; 10100
mov edx, esi	; 10105
imul edx, ecx	; 10107
add edx, 3FFh	; 1010A
mov eax, edx	; 10110
sar edx, 1Fh	; 10112
shl edx, 0Ah	; 10115
LD sbb, eax, edx	; 10118
sar eax, 0Ah	; 1011A
mov ebx, eax	; 1011D
lea edx, [byte eax+07h]	; 1011F
mov eax, edx	; 10122
sar edx, 1Fh	; 10124
idiv ebx	; 10127
lea ebx, [byte eax+01h]	; 10129
xor eax, eax	; 1012C
mov ax, word [byte esp+04Eh]	; 1012E
cmp eax, ebx	; 10133
jge short .3	; 10135
mov edx, ebx	; 10137
imul edx, esi	; 10139
imul edx, ecx	; 1013C
add edx, 3FFh	; 1013F
mov eax, edx	; 10145
sar edx, 1Fh	; 10147
shl edx, 0Ah	; 1014A
LD sbb, eax, edx	; 1014D
sar eax, 0Ah	; 1014F
push eax	; 10152
push str_NoDiskSpaceCur	; 10153
call printf_	; 10158
add esp, byte 8	; 1015D
xor eax, eax	; 10160
call exit_	; 10162
.3:
mov word [byte esp+01Ch], 100h	; 10167
mov word [byte esp+020h], 0A000h	; 1016E
mov ebx, esp	; 10175
lea edx, [byte esp+01Ch]	; 10177
mov eax, 31h	; 1017B
call int386_	; 10180
xor eax, eax	; 10185
mov ax, word [byte esp+04h]	; 10187
mov esi, eax	; 1018C
shl esi, 4	; 1018E
push dword 19000h	; 10191
push dword 0C8h	; 10196
call sub_8DF54	; 1019B
add esp, byte 8	; 101A0
lea ecx, [byte esp+058h]	; 101A3
lea ebx, [byte esp+05Ch]	; 101A7
lea edx, [byte esp+060h]	; 101AB
lea eax, [byte esp+064h]	; 101AF
call GetMemStats	; 101B3
cmp dword [byte esp+064h], 1E5D70h	; 101B8
jae short .4	; 101C0
push str_NoMemory	; 101C2
call printf_	; 101C7
add esp, byte 4	; 101CC
push str_CheckRefCard	; 101CF
call printf_	; 101D4
add esp, byte 4	; 101D9
xor eax, eax	; 101DC
call exit_	; 101DE
.4:
cmp dword [byte esp+064h], 200B20h	; 101E3
jae short .5	; 101EB
cmp esi, 7F800h	; 101ED
jge short .5	; 101F3
push str_NoConvMemory	; 101F5
call printf_	; 101FA
add esp, byte 4	; 101FF
push str_CheckRefCard2	; 10202
call printf_	; 10207
add esp, byte 4	; 1020C
xor eax, eax	; 1020F
call exit_	; 10211
.5:
cmp dword [byte esp+064h], 3EF000h	; 10216
jbe short .6	; 1021E
mov dword [dword_C4CFC], 0C3500h	; 10220
jmp short .7	; 1022A
.6:
mov dword [dword_C4CFC], 30D40h	; 1022C
.7:
push dword 1E0h	; 10236
push dword 280h	; 1023B
call sub_8E080	; 10240
add esp, byte 8	; 10245
call InstallTimer	; 10248
xor eax, eax	; 1024D
mov dword [joysampling], eax	; 1024F
db 068h	; 10254 push 0DCDh
dd SampleInputTick
call addtimer	; 10259
add esp, byte 4	; 1025E
or byte [ctlavailmask], 8	; 10261
call sub_B2F22	; 10268
test eax, eax	; 1026D
je short .8	; 1026F
or byte [ctlavailmask], 1	; 10271
.8:
call InputInstall	; 10278
call dword [mousepollfn]	; 1027D
push CritErrHandler	; 10283
call sub_B3036	; 10288
add esp, byte 4	; 1028D
call InitFileLocations	; 10290
mov edx, 0C8h	; 10295
mov eax, 140h	; 1029A
call SetScreenSize	; 1029F
push byte 20h	; 102A4
push dword 140h	; 102A6
push dword 0A8h	; 102AB
push byte 0	; 102B0
push dword_D30D4	; 102B2
call sub_8E7A0	; 102B7
add esp, byte 14h	; 102BC
mov dword [screenbm], eax	; 102BF
mov edx, 1E0h	; 102C4
mov eax, 280h	; 102C9
call SetScreenSize	; 102CE
mov eax, 64h	; 102D3
call sub_6A9CE	; 102D8
xor ecx, ecx	; 102DD
mov ebx, str_Pointer3	; 102DF
cmp byte [fileoncd+013Ah], 1	; 102E4
jne short .9	; 102EB
mov edx, dword [cddriveptr]	; 102ED
jmp short .10	; 102F3
.9:
xor edx, edx	; 102F5
.10:
lea eax, [byte esp+038h]	; 102F7
call MakePath	; 102FB
push byte 0	; 10300
lea eax, [byte esp+03Ch]	; 10302
push eax	; 10306
call sub_8E83C	; 10307
add esp, byte 8	; 1030C
mov dword [pntrshapes], eax	; 1030F
push str_Pntr	; 10314
push eax	; 10319
call sub_B30B4	; 1031A
add esp, byte 8	; 1031F
mov dword [pointerspr], eax	; 10322
mov ecx, str_VFN	; 10327
mov ebx, str_S1	; 1032C
cmp byte [fileoncd+0162h], 1	; 10331
jne short .11	; 10338
mov edx, dword [cddriveptr]	; 1033A
jmp short .12	; 10340
.11:
xor edx, edx	; 10342
.12:
lea eax, [byte esp+038h]	; 10344
call MakePath	; 10348
push byte 20h	; 1034D
lea eax, [byte esp+03Ch]	; 1034F
push eax	; 10353
call sub_8E8A0	; 10354
add esp, byte 8	; 10359
mov dword [s1font], eax	; 1035C
mov dword [mainfont], eax	; 10361
mov ecx, str_VFN	; 10366
mov ebx, str_Scor2b	; 1036B
cmp byte [fileoncd+0169h], 1	; 10370
jne short .13	; 10377
mov edx, dword [cddriveptr]	; 10379
jmp short .14	; 1037F
.13:
xor edx, edx	; 10381
.14:
lea eax, [byte esp+038h]	; 10383
call MakePath	; 10387
push byte 20h	; 1038C
lea eax, [byte esp+03Ch]	; 1038E
push eax	; 10392
call sub_8E8A0	; 10393
add esp, byte 8	; 10398
mov dword [scor2font], eax	; 1039B
mov ecx, str_VFN	; 103A0
mov ebx, str_Scor3b	; 103A5
cmp byte [fileoncd+016Ah], 1	; 103AA
jne short .15	; 103B1
mov edx, dword [cddriveptr]	; 103B3
jmp short .16	; 103B9
.15:
xor edx, edx	; 103BB
.16:
lea eax, [byte esp+038h]	; 103BD
call MakePath	; 103C1
push byte 20h	; 103C6
lea eax, [byte esp+03Ch]	; 103C8
push eax	; 103CC
call sub_8E8A0	; 103CD
add esp, byte 8	; 103D2
mov dword [scor3font], eax	; 103D5
mov ecx, str_VFN	; 103DA
mov ebx, str_Kaufm020	; 103DF
cmp byte [fileoncd+01C4h], 1	; 103E4
jne short .17	; 103EB
mov edx, dword [cddriveptr]	; 103ED
jmp short .18	; 103F3
.17:
xor edx, edx	; 103F5
.18:
lea eax, [byte esp+038h]	; 103F7
call MakePath	; 103FB
push byte 20h	; 10400
lea eax, [byte esp+03Ch]	; 10402
push eax	; 10406
call sub_8E8A0	; 10407
add esp, byte 8	; 1040C
mov dword [kaufmfont], eax	; 1040F
mov edx, dword [s1font]	; 10414
push edx	; 1041A
call sub_8EA18	; 1041B
add esp, byte 4	; 10420
mov eax, exhstate	; 10423
call LoadModeState	; 10428
call LoadNhlCfg	; 1042D
call RunIntro	; 10432
call sub_B30F4	; 10437
mov dword [byte esp+054h], eax	; 1043C
mov al, byte [byte_D416A]	; 10440
and al, 0Fh	; 10445
cmp al, 0Fh	; 10447
sete al	; 10449
and eax, 0FFh	; 1044C
inc eax	; 10451
push eax	; 10452
call sub_B33DB	; 10453
add esp, byte 4	; 10458
test byte [byte_D416A], 3	; 1045B
je short .20	; 10462
cmp dword [dword_D4158], byte 0	; 10464
jne short .19	; 1046B
cmp dword [dword_D415C], byte 0	; 1046D
je short .20	; 10474
.19:
push str_ConfigureLeftJoystick	; 10476
push byte 0	; 1047B
push byte 0	; 1047D
push byte 1	; 1047F
call JoystickCalScreen	; 10481
add esp, byte 10h	; 10486
test byte [joyenablemask], 1	; 10489
je short .20	; 10490
or byte [ctlavailmask], 2	; 10492
mov dword [joypresent], 1	; 10499
.20:
test byte [byte_D416A], 0Ch	; 104A3
je short .22	; 104AA
cmp dword [dword_D4160], byte 0	; 104AC
jne short .21	; 104B3
cmp dword [dword_D4164], byte 0	; 104B5
je short .22	; 104BC
.21:
push str_ConfigureRightJoystick	; 104BE
push byte 1	; 104C3
push byte 8	; 104C5
push byte 2	; 104C7
call JoystickCalScreen	; 104C9
add esp, byte 10h	; 104CE
test byte [joyenablemask], 2	; 104D1
je short .22	; 104D8
or byte [ctlavailmask], 4	; 104DA
mov dword [joypresent+4], 1	; 104E1
.22:
lea edx, [byte esp+068h]	; 104EB
mov eax, str_GameSet2	; 104EF
call FileOpenRead	; 104F4
test eax, eax	; 104F9
jne short .24	; 104FB
mov ecx, 75h	; 104FD
mov ebx, 0FFFFFFFFh	; 10502
mov edx, exhstate	; 10507
mov eax, dword [byte esp+068h]	; 1050C
call FileReadAt	; 10510
test eax, eax	; 10515
je short .23	; 10517
push str_errd3	; 10519
call FatalError	; 1051E
add esp, byte 4	; 10523
.23:
lea eax, [byte esp+068h]	; 10526
call FileClose	; 1052A
test eax, eax	; 1052F
je near .32	; 10531
push str_errd4	; 10537
call FatalError	; 1053C
add esp, byte 4	; 10541
jmp near .32	; 10544
.24:
mov dl, byte [ctlavailmask]	; 10549
test dl, 2	; 1054F
je short .25	; 10552
mov dword [exhstate+65h], 2	; 10554
jmp short .29	; 1055E
.25:
test dl, 4	; 10560
je short .26	; 10563
mov dword [exhstate+65h], 4	; 10565
jmp short .29	; 1056F
.26:
test dl, 8	; 10571
je short .27	; 10574
mov dword [exhstate+65h], 8	; 10576
jmp short .29	; 10580
.27:
test dl, 1	; 10582
je short .28	; 10585
mov dword [exhstate+65h], 1	; 10587
jmp short .29	; 10591
.28:
mov dword [exhstate+65h], 10h	; 10593
.29:
mov ebp, 10h	; 1059D
mov dword [exhstate+69h], ebp	; 105A2
xor eax, eax	; 105A8
mov dword [exhstate+6Dh], eax	; 105AA
mov dword [exhstate+71h], 1	; 105AF
cmp ebp, dword [exhstate+65h]	; 105B9
je short .30	; 105BF
mov dword [exhstate+5Dh], 0Ch	; 105C1
jmp short .31	; 105CB
.30:
mov dword [exhstate+5Dh], 0FFFFFFFFh	; 105CD
.31:
mov dword [exhstate+61h], 0FFFFFFFEh	; 105D7
.32:
mov eax, exhstate	; 105E1
call LoadModeState	; 105E6
call ShowLoadingScreen	; 105EB
lea eax, [byte esp+06Ch]	; 105F0
call _dos_gettime_	; 105F4
xor eax, eax	; 105F9
mov al, byte [byte esp+06Fh]	; 105FB
call srand_	; 105FF
call MainDeskLoop	; 10604
push byte 20h	; 10609
push dword 300h	; 1060B
push str_Temp3	; 10610
call sub_8CCA8	; 10615
add esp, byte 0Ch	; 1061A
mov esi, eax	; 1061D
cmp byte [musicon], 0	; 1061F
je short .33	; 10626
cmp dword [songdata], byte 0	; 10628
je short .33	; 1062F
mov eax, dword [musichandle]	; 10631
mov ebx, 64h	; 10636
mov edx, 3	; 1063B
call sub_8FCDF	; 10640
.33:
push esi	; 10645
push dword 100h	; 10646
push byte 0	; 1064B
call sub_8FFB0	; 1064D
add esp, byte 0Ch	; 10652
mov ebx, 10h	; 10655
mov edx, esi	; 1065A
mov eax, 1	; 1065C
call FadePalStep	; 10661
cmp byte [musicon], 0	; 10666
je short .35	; 1066D
cmp dword [songdata], byte 0	; 1066F
je short .35	; 10676
.34:
mov eax, dword [musicslot-3]	; 10678
sar eax, 18h	; 1067D
mov edx, 3	; 10680
call sub_8FC8A	; 10685
test eax, eax	; 1068A
je short main_.34	; 1068C
mov edx, dword [songdata]	; 1068E
push edx	; 10694
call sub_8D2F0	; 10695
add esp, byte 4	; 1069A
xor ebx, ebx	; 1069D
mov dword [songdata], ebx	; 1069F
.35:
call ShowLoadingScreen	; 106A5
call InputInstall	; 106AA
call ShowCredits	; 106AF
call sub_B4B58	; 106B4
call dword [bailout_vec]	; 106B9
main_x:
add esp, byte 70h	; 106BF
pop ebp	; 106C2
pop esi	; 106C3
pop edx	; 106C4
pop ecx	; 106C5
pop ebx	; 106C6
ret	; 106C7
%endif ; C
; C: src/c/front/main/DiskFreeBytes.c
%ifdef CBUILD
%include "c/front/main/DiskFreeBytes.inc"
%else
DiskFreeBytes:
push dword 1Ch	; 106C8
call __CHK	; 106CD
push ebx	; 106D2
push ecx	; 106D3
push edx	; 106D4
sub esp, byte 8	; 106D5
mov edx, esp	; 106D8
call _dos_getdiskfree_	; 106DA
test eax, eax	; 106DF
je short .1	; 106E1
push str_ErrDiskFree3	; 106E3
call FatalError	; 106E8
add esp, byte 4	; 106ED
.1:
xor edx, edx	; 106F0
mov dx, word [byte esp+02h]	; 106F2
xor eax, eax	; 106F7
mov ax, word [byte esp+04h]	; 106F9
imul edx, eax	; 106FE
xor eax, eax	; 10701
mov ax, word [byte esp+06h]	; 10703
imul eax, edx	; 10708
add esp, byte 8	; 1070B
pop edx	; 1070E
pop ecx	; 1070F
pop ebx	; 10710
ret	; 10711
%endif ; C
; C: src/c/front/main/SetupControllers.c
%ifdef CBUILD
%include "c/front/main/SetupControllers.inc"
%else
SetupControllers:
push dword 1Ch	; 10712
call __CHK	; 10717
push ebx	; 1071C
push ecx	; 1071D
push edx	; 1071E
push ebp	; 1071F
cmp dword [ctl1team], byte 0	; 10720
jge short .1	; 10727
xor ecx, ecx	; 10729
mov word [cont1team], cx	; 1072B
jmp short .3	; 10732
.1:
cmp dword [ctl1side], byte 0	; 10734
jne short .2	; 1073B
mov word [cont1team], 1	; 1073D
jmp short .3	; 10746
.2:
mov word [cont1team], 2	; 10748
.3:
cmp dword [ctl2team], byte 0	; 10751
jge short .4	; 10758
xor eax, eax	; 1075A
mov word [cont2team], ax	; 1075C
jmp short .6	; 10762
.4:
cmp dword [ctl2side], byte 0	; 10764
jne short .5	; 1076B
mov word [cont2team], 1	; 1076D
jmp short .6	; 10776
.5:
mov word [cont2team], 2	; 10778
.6:
mov eax, dword [ctl1side]	; 10781
cmp eax, dword [ctl2side]	; 10786
sete al	; 1078C
and eax, 0FFh	; 1078F
mov dword [samesideflag], eax	; 10794
mov eax, dword [ctl1dev]	; 10799
cmp eax, byte 4	; 1079E
jb short .7	; 107A1
cmp eax, byte 4	; 107A3
jbe short .10	; 107A6
cmp eax, byte 8	; 107A8
jb short .13	; 107AB
jbe short .11	; 107AD
cmp eax, byte 10h	; 107AF
je short .12	; 107B2
jmp short .13	; 107B4
.7:
cmp eax, byte 1	; 107B6
jb short .13	; 107B9
jbe short .8	; 107BB
cmp eax, byte 2	; 107BD
je short .9	; 107C0
jmp short .13	; 107C2
.8:
mov byte [pad1dev], 1	; 107C4
jmp short .13	; 107CB
.9:
mov byte [pad1dev], 2	; 107CD
jmp short .13	; 107D4
.10:
mov byte [pad1dev], 4	; 107D6
jmp short .13	; 107DD
.11:
mov byte [pad1dev], 8	; 107DF
jmp short .13	; 107E6
.12:
xor ah, ah	; 107E8
mov byte [pad1dev], ah	; 107EA
.13:
mov eax, dword [ctl2dev]	; 107F0
cmp eax, byte 4	; 107F5
jb short .14	; 107F8
jbe short .17	; 107FA
cmp eax, byte 8	; 107FC
jb short .20	; 107FF
jbe short .18	; 10801
cmp eax, byte 10h	; 10803
je short .19	; 10806
jmp short .20	; 10808
.14:
cmp eax, byte 1	; 1080A
jb short .20	; 1080D
jbe short .15	; 1080F
cmp eax, byte 2	; 10811
je short .16	; 10814
jmp short .20	; 10816
.15:
mov byte [pad2dev], 1	; 10818
jmp short .20	; 1081F
.16:
mov byte [pad2dev], 2	; 10821
jmp short .20	; 10828
.17:
mov byte [pad2dev], 4	; 1082A
jmp short .20	; 10831
.18:
mov byte [pad2dev], 8	; 10833
jmp short .20	; 1083A
.19:
xor cl, cl	; 1083C
mov byte [pad2dev], cl	; 1083E
.20:
call sub_B2F22	; 10844
push byte 64h	; 10849
push dword 0A0h	; 1084B
call MouseSetPos	; 10850
add esp, byte 8	; 10855
call sub_B29F0	; 10858
xor ebp, ebp	; 1085D
mov dword [joysampling], ebp	; 1085F
pop ebp	; 10865
pop edx	; 10866
pop ecx	; 10867
pop ebx	; 10868
ret	; 10869
%endif ; C
ReadKeyboardPad:
push ebx	; 1086A
push ecx	; 1086B
push edx	; 1086C
sub esp, byte 4	; 1086D
xor edx, edx	; 10870
mov dword [esp], edx	; 10872
push byte 48h	; 10875
call sub_B2CBE	; 10877
add esp, byte 4	; 1087C
test eax, eax	; 1087F
je short .1	; 10881
mov dword [esp], 1	; 10883
.1:
push byte 50h	; 1088A
call sub_B2CBE	; 1088C
add esp, byte 4	; 10891
test eax, eax	; 10894
je short .2	; 10896
or byte [esp], 2	; 10898
.2:
push byte 4Bh	; 1089C
call sub_B2CBE	; 1089E
add esp, byte 4	; 108A3
test eax, eax	; 108A6
je short .3	; 108A8
or byte [esp], 8	; 108AA
.3:
push byte 4Dh	; 108AE
call sub_B2CBE	; 108B0
add esp, byte 4	; 108B5
test eax, eax	; 108B8
je short .4	; 108BA
or byte [esp], 4	; 108BC
.4:
push byte 47h	; 108C0
call sub_B2CBE	; 108C2
add esp, byte 4	; 108C7
test eax, eax	; 108CA
je short .5	; 108CC
or byte [esp], 9	; 108CE
.5:
push byte 49h	; 108D2
call sub_B2CBE	; 108D4
add esp, byte 4	; 108D9
test eax, eax	; 108DC
je short .6	; 108DE
or byte [esp], 5	; 108E0
.6:
push byte 51h	; 108E4
call sub_B2CBE	; 108E6
add esp, byte 4	; 108EB
test eax, eax	; 108EE
je short .7	; 108F0
or byte [esp], 6	; 108F2
.7:
push byte 4Fh	; 108F6
call sub_B2CBE	; 108F8
add esp, byte 4	; 108FD
test eax, eax	; 10900
je short .8	; 10902
or byte [esp], 0Ah	; 10904
.8:
mov eax, dword [esp]	; 10908
mov eax, dword [dword eax+keydirtab-3]	; 1090B
sar eax, 18h	; 10911
mov dword [esp], eax	; 10914
push byte 52h	; 10917
call sub_B2CBE	; 10919
add esp, byte 4	; 1091E
test eax, eax	; 10921
je short .9	; 10923
push byte 1Ch	; 10925
call sub_B2CBE	; 10927
add esp, byte 4	; 1092C
test eax, eax	; 1092F
jne short .10	; 10931
.9:
push byte 38h	; 10933
call sub_B2CBE	; 10935
add esp, byte 4	; 1093A
test eax, eax	; 1093D
je short .11	; 1093F
push byte 39h	; 10941
call sub_B2CBE	; 10943
add esp, byte 4	; 10948
test eax, eax	; 1094B
je short .11	; 1094D
.10:
or byte [esp], 40h	; 1094F
jmp short .15	; 10953
.11:
push byte 52h	; 10955
call sub_B2CBE	; 10957
add esp, byte 4	; 1095C
test eax, eax	; 1095F
jne short .12	; 10961
push byte 38h	; 10963
call sub_B2CBE	; 10965
add esp, byte 4	; 1096A
test eax, eax	; 1096D
je short .13	; 1096F
.12:
or byte [esp], 10h	; 10971
jmp short .15	; 10975
.13:
push byte 1Ch	; 10977
call sub_B2CBE	; 10979
add esp, byte 4	; 1097E
test eax, eax	; 10981
jne short .14	; 10983
push byte 39h	; 10985
call sub_B2CBE	; 10987
add esp, byte 4	; 1098C
test eax, eax	; 1098F
je short .15	; 10991
.14:
or byte [esp], 20h	; 10993
.15:
mov eax, dword [esp]	; 10997
add esp, byte 4	; 1099A
pop edx	; 1099D
pop ecx	; 1099E
pop ebx	; 1099F
ret	; 109A0
ReadJoyPad:
push edx	; 109A1
cmp dword [nosplit eax*4+joypresent], byte 0	; 109A2
jne short .1	; 109AA
mov eax, 8	; 109AC
pop edx	; 109B1
ret	; 109B2
.1:
test eax, eax	; 109B3
je short .2	; 109B5
mov edx, dword [joyrawbits]	; 109B7
sar edx, 8	; 109BD
jmp short .3	; 109C0
.2:
mov edx, dword [joyrawbits]	; 109C2
and edx, 0FFh	; 109C8
.3:
mov eax, edx	; 109CE
and eax, byte 0Fh	; 109D0
mov eax, dword [dword eax+keydirtab-3]	; 109D3
sar eax, 18h	; 109D9
test dl, 10h	; 109DC
je short .4	; 109DF
test dl, 20h	; 109E1
je short .4	; 109E4
or al, 40h	; 109E6
pop edx	; 109E8
ret	; 109E9
.4:
test dl, 10h	; 109EA
je short .5	; 109ED
or al, 10h	; 109EF
pop edx	; 109F1
ret	; 109F2
.5:
test dl, 20h	; 109F3
je short .x	; 109F6
or al, 20h	; 109F8
.x:
pop edx	; 109FA
ret	; 109FB
ReadMousePad:
push ebx	; 109FC
push ecx	; 109FD
push edx	; 109FE
call dword [mousepollfn]	; 109FF
mov edx, dword [mousex]	; 10A05
sub edx, 0A0h	; 10A0B
imul edx, edx	; 10A11
mov eax, 64h	; 10A14
sub eax, dword [mousey]	; 10A19
imul eax, eax	; 10A1F
add eax, edx	; 10A22
cmp eax, 9C4h	; 10A24
jge short .1	; 10A29
mov eax, 8	; 10A2B
jmp short .2	; 10A30
.1:
mov eax, 64h	; 10A32
sub ax, word [mousey]	; 10A37
movsx edx, ax	; 10A3E
mov ax, word [mousex]	; 10A41
db 081h,0E8h,0A0h,00h,00h,00h	; 10A47 sub eax,0A0h
cwde	; 10A4D
call vtoa	; 10A4E
cwde	; 10A53
.2:
mov dl, byte [mousebtns]	; 10A54
test dl, 1	; 10A5A
je short .3	; 10A5D
test dl, 2	; 10A5F
je short .3	; 10A62
or al, 40h	; 10A64
pop edx	; 10A66
pop ecx	; 10A67
pop ebx	; 10A68
ret	; 10A69
.3:
mov bl, byte [mousebtns]	; 10A6A
test bl, 1	; 10A70
je short .4	; 10A73
or al, 10h	; 10A75
pop edx	; 10A77
pop ecx	; 10A78
pop ebx	; 10A79
ret	; 10A7A
.4:
test bl, 2	; 10A7B
je short .x	; 10A7E
or al, 20h	; 10A80
.x:
pop edx	; 10A82
pop ecx	; 10A83
pop ebx	; 10A84
ret	; 10A85
ReadControllerPad:
push ebx	; 10A86
mov bl, byte [dword eax+pad1dev]	; 10A87
cmp bl, 8	; 10A8D
jne short .1	; 10A90
call ReadKeyboardPad	; 10A92
jmp short .3	; 10A97
.1:
cmp bl, 2	; 10A99
jne short .4	; 10A9C
xor eax, eax	; 10A9E
.2:
call ReadJoyPad	; 10AA0
.3:
mov byte [edx], al	; 10AA5
pop ebx	; 10AA7
ret	; 10AA8
.4:
cmp bl, 4	; 10AA9
jne short .5	; 10AAC
mov eax, 1	; 10AAE
jmp short ReadControllerPad.2	; 10AB3
.5:
cmp bl, 1	; 10AB5
jne short .6	; 10AB8
call ReadMousePad	; 10ABA
jmp short ReadControllerPad.3	; 10ABF
.6:
mov byte [edx], 8	; 10AC1
pop ebx	; 10AC4
ret	; 10AC5
ReadHotKeys:
push ebx	; 10AC6
push ecx	; 10AC7
push edx	; 10AC8
push esi	; 10AC9
sub esp, byte 4	; 10ACA
mov esi, eax	; 10ACD
xor ah, ah	; 10ACF
mov byte [esp], ah	; 10AD1
push byte 1	; 10AD4
call sub_B2CBE	; 10AD6
add esp, byte 4	; 10ADB
test eax, eax	; 10ADE
je short .1	; 10AE0
mov byte [esp], 1	; 10AE2
jmp near .15	; 10AE6
.1:
push byte 1Dh	; 10AEB
call sub_B2CBE	; 10AED
add esp, byte 4	; 10AF2
test eax, eax	; 10AF5
je short .3	; 10AF7
push byte 1Fh	; 10AF9
call sub_B2CBE	; 10AFB
add esp, byte 4	; 10B00
test eax, eax	; 10B03
je short .2	; 10B05
mov byte [esp], 1Fh	; 10B07
jmp near .15	; 10B0B
.2:
push byte 32h	; 10B10
call sub_B2CBE	; 10B12
add esp, byte 4	; 10B17
test eax, eax	; 10B1A
je near .15	; 10B1C
mov byte [esp], 32h	; 10B22
jmp near .15	; 10B26
.3:
push byte 3Bh	; 10B2B
call sub_B2CBE	; 10B2D
add esp, byte 4	; 10B32
test eax, eax	; 10B35
je short .4	; 10B37
mov byte [esp], 3Bh	; 10B39
jmp near .15	; 10B3D
.4:
push byte 3Ch	; 10B42
call sub_B2CBE	; 10B44
add esp, byte 4	; 10B49
test eax, eax	; 10B4C
je short .5	; 10B4E
mov byte [esp], 3Ch	; 10B50
jmp near .15	; 10B54
.5:
push byte 3Dh	; 10B59
call sub_B2CBE	; 10B5B
add esp, byte 4	; 10B60
test eax, eax	; 10B63
je short .6	; 10B65
mov byte [esp], 3Dh	; 10B67
jmp near .15	; 10B6B
.6:
push byte 3Eh	; 10B70
call sub_B2CBE	; 10B72
add esp, byte 4	; 10B77
test eax, eax	; 10B7A
je short .7	; 10B7C
mov byte [esp], 3Eh	; 10B7E
jmp near .15	; 10B82
.7:
push byte 3Fh	; 10B87
call sub_B2CBE	; 10B89
add esp, byte 4	; 10B8E
test eax, eax	; 10B91
je short .8	; 10B93
mov byte [esp], 3Fh	; 10B95
jmp near .15	; 10B99
.8:
push byte 40h	; 10B9E
call sub_B2CBE	; 10BA0
add esp, byte 4	; 10BA5
test eax, eax	; 10BA8
je short .9	; 10BAA
mov byte [esp], 40h	; 10BAC
jmp near .15	; 10BB0
.9:
push byte 41h	; 10BB5
call sub_B2CBE	; 10BB7
add esp, byte 4	; 10BBC
test eax, eax	; 10BBF
je short .10	; 10BC1
mov byte [esp], 41h	; 10BC3
jmp near .15	; 10BC7
.10:
push byte 42h	; 10BCC
call sub_B2CBE	; 10BCE
add esp, byte 4	; 10BD3
test eax, eax	; 10BD6
je short .11	; 10BD8
mov byte [esp], 42h	; 10BDA
jmp short .15	; 10BDE
.11:
push byte 43h	; 10BE0
call sub_B2CBE	; 10BE2
add esp, byte 4	; 10BE7
test eax, eax	; 10BEA
je short .12	; 10BEC
mov byte [esp], 43h	; 10BEE
jmp short .15	; 10BF2
.12:
push byte 44h	; 10BF4
call sub_B2CBE	; 10BF6
add esp, byte 4	; 10BFB
test eax, eax	; 10BFE
je short .13	; 10C00
mov byte [esp], 44h	; 10C02
jmp short .15	; 10C06
.13:
push byte 0Fh	; 10C08
call sub_B2CBE	; 10C0A
add esp, byte 4	; 10C0F
test eax, eax	; 10C12
je short .14	; 10C14
mov byte [esp], 0Fh	; 10C16
jmp short .15	; 10C1A
.14:
push byte 13h	; 10C1C
call sub_B2CBE	; 10C1E
add esp, byte 4	; 10C23
test eax, eax	; 10C26
je short .15	; 10C28
mov byte [esp], 13h	; 10C2A
.15:
cmp byte [lasthotkey], 0	; 10C2E
je short .17	; 10C35
mov eax, dword [byte esp-03h]	; 10C37
sar eax, 18h	; 10C3B
xor edx, edx	; 10C3E
mov dl, byte [lasthotkey]	; 10C40
cmp eax, edx	; 10C46
jne short .16	; 10C48
xor dh, dh	; 10C4A
mov byte [esp], dh	; 10C4C
jmp short .18	; 10C4F
.16:
xor dl, dl	; 10C51
mov byte [lasthotkey], dl	; 10C53
jmp short .18	; 10C59
.17:
mov al, byte [esp]	; 10C5B
mov byte [lasthotkey], al	; 10C5E
.18:
mov bl, byte [esp]	; 10C63
test bl, bl	; 10C66
je short .19	; 10C68
mov bh, bl	; 10C6A
or bh, 80h	; 10C6C
mov byte [esp], bh	; 10C6F
.19:
mov al, byte [esp]	; 10C72
mov byte [esi], al	; 10C75
add esp, byte 4	; 10C77
pop esi	; 10C7A
pop edx	; 10C7B
pop ecx	; 10C7C
pop ebx	; 10C7D
ret	; 10C7E
ReadSkipKeys:
push ebx	; 10C7F
push ecx	; 10C80
push esi	; 10C81
push edi	; 10C82
sub esp, byte 4	; 10C83
mov edi, eax	; 10C86
mov esi, edx	; 10C88
xor ah, ah	; 10C8A
mov byte [esp], ah	; 10C8C
mov byte [edi], ah	; 10C8F
push byte 1	; 10C91
call sub_B2CBE	; 10C93
add esp, byte 4	; 10C98
test eax, eax	; 10C9B
jne near .6	; 10C9D
push byte 52h	; 10CA3
call sub_B2CBE	; 10CA5
add esp, byte 4	; 10CAA
test eax, eax	; 10CAD
jne short .1	; 10CAF
push byte 38h	; 10CB1
call sub_B2CBE	; 10CB3
add esp, byte 4	; 10CB8
test eax, eax	; 10CBB
jne short .1	; 10CBD
push byte 1Ch	; 10CBF
call sub_B2CBE	; 10CC1
add esp, byte 4	; 10CC6
test eax, eax	; 10CC9
jne short .1	; 10CCB
push byte 39h	; 10CCD
call sub_B2CBE	; 10CCF
add esp, byte 4	; 10CD4
test eax, eax	; 10CD7
je short .3	; 10CD9
.1:
test byte [gmode], 10h	; 10CDB
je short .6	; 10CE2
.2:
or byte [esi], 10h	; 10CE4
jmp near .x	; 10CE7
.3:
mov dl, byte [ctlavailmask]	; 10CEC
test dl, 2	; 10CF2
jne short .4	; 10CF5
test dl, 4	; 10CF7
je short .8	; 10CFA
.4:
call sub_B3464	; 10CFC
test al, 30h	; 10D01
je short .7	; 10D03
.5:
test byte [gmode], 10h	; 10D05
jne short ReadSkipKeys.2	; 10D0C
.6:
mov byte [edi], 81h	; 10D0E
jmp near .x	; 10D11
.7:
sar eax, 8	; 10D16
test al, 30h	; 10D19
jne short ReadSkipKeys.5	; 10D1B
.8:
test byte [ctlavailmask], 1	; 10D1D
je short .9	; 10D24
call dword [mousepollfn]	; 10D26
test byte [mousebtns], 3	; 10D2C
jne short ReadSkipKeys.5	; 10D33
.9:
push byte 1Dh	; 10D35
call sub_B2CBE	; 10D37
add esp, byte 4	; 10D3C
test eax, eax	; 10D3F
je short .11	; 10D41
push byte 1Fh	; 10D43
call sub_B2CBE	; 10D45
add esp, byte 4	; 10D4A
test eax, eax	; 10D4D
je short .10	; 10D4F
mov byte [esp], 1Fh	; 10D51
jmp short .12	; 10D55
.10:
push byte 32h	; 10D57
call sub_B2CBE	; 10D59
add esp, byte 4	; 10D5E
test eax, eax	; 10D61
je short .12	; 10D63
mov byte [esp], 32h	; 10D65
jmp short .12	; 10D69
.11:
push byte 0Fh	; 10D6B
call sub_B2CBE	; 10D6D
add esp, byte 4	; 10D72
test eax, eax	; 10D75
je short .12	; 10D77
mov byte [esp], 0Fh	; 10D79
.12:
cmp byte [lasthotkey], 0	; 10D7D
je short .14	; 10D84
mov eax, dword [byte esp-03h]	; 10D86
sar eax, 18h	; 10D8A
movzx esi, byte [lasthotkey]	; 10D8D
cmp eax, esi	; 10D94
jne short .13	; 10D96
xor dh, dh	; 10D98
mov byte [esp], dh	; 10D9A
jmp short .15	; 10D9D
.13:
xor dl, dl	; 10D9F
mov byte [lasthotkey], dl	; 10DA1
jmp short .15	; 10DA7
.14:
mov al, byte [esp]	; 10DA9
mov byte [lasthotkey], al	; 10DAC
.15:
mov bl, byte [esp]	; 10DB1
test bl, bl	; 10DB4
je short .16	; 10DB6
mov bh, bl	; 10DB8
or bh, 80h	; 10DBA
mov byte [esp], bh	; 10DBD
.16:
mov al, byte [esp]	; 10DC0
mov byte [edi], al	; 10DC3
.x:
add esp, byte 4	; 10DC5
pop edi	; 10DC8
pop esi	; 10DC9
pop ecx	; 10DCA
pop ebx	; 10DCB
ret	; 10DCC
SampleInputTick:
push ebx	; 10DCD
push ecx	; 10DCE
push edx	; 10DCF
push esi	; 10DD0
cmp dword [joysampling], byte 0	; 10DD1
je near .x	; 10DD8
mov ebx, dword [inputticks]	; 10DDE
cmp ebx, 3E8h	; 10DE4
jge short .1	; 10DEA
lea ecx, [byte ebx+01h]	; 10DEC
mov dword [inputticks], ecx	; 10DEF
.1:
mov esi, dword [joyqtick]	; 10DF5
dec esi	; 10DFB
mov dword [joyqtick], esi	; 10DFC
cmp esi, byte 0FFFFFFFFh	; 10E02
jne near .x	; 10E05
mov dword [joyqtick], 4	; 10E0B
mov eax, dword [joyqcount]	; 10E15
cmp eax, byte 32h	; 10E1A
jge near .x	; 10E1D
mov edx, dword [joyqhead]	; 10E23
add edx, eax	; 10E29
mov ebx, 32h	; 10E2B
mov eax, edx	; 10E30
sar edx, 1Fh	; 10E32
idiv ebx	; 10E35
mov esi, edx	; 10E37
test byte [pad1dev], 6	; 10E39
jne short .2	; 10E40
test byte [pad2dev], 6	; 10E42
je short .3	; 10E49
.2:
call sub_B3464	; 10E4B
mov dword [joyrawbits], eax	; 10E50
.3:
mov eax, esi	; 10E55
mov ebx, esi	; 10E57
shl ebx, 2	; 10E59
sub ebx, esi	; 10E5C
add ebx, joyqueue	; 10E5E
mov edx, ebx	; 10E64
xor eax, esi	; 10E66
call ReadControllerPad	; 10E68
lea edx, [byte ebx+01h]	; 10E6D
mov eax, 1	; 10E70
call ReadControllerPad	; 10E75
lea eax, [byte ebx+02h]	; 10E7A
cmp dword [demomode], byte 0	; 10E7D
je short .4	; 10E84
mov edx, ebx	; 10E86
call ReadSkipKeys	; 10E88
jmp short .5	; 10E8D
.4:
call ReadHotKeys	; 10E8F
.5:
inc dword [joyqcount]	; 10E94
.x:
pop esi	; 10E9A
pop edx	; 10E9B
pop ecx	; 10E9C
pop ebx	; 10E9D
ret	; 10E9E
; C: src/c/front/main/SetScreenSize.c
%ifdef CBUILD
%include "c/front/main/SetScreenSize.inc"
%else
SetScreenSize:
push dword 28h	; 10E9F
call __CHK	; 10EA4
push ebx	; 10EA9
push ecx	; 10EAA
push esi	; 10EAB
push edi	; 10EAC
push ebp	; 10EAD
mov esi, eax	; 10EAE
mov edi, edx	; 10EB0
cmp eax, dword [screenw]	; 10EB2
jne short .1	; 10EB8
cmp edi, dword [screenh]	; 10EBA
je near .x	; 10EC0
.1:
push unk_C4E30	; 10EC6
push dword 100h	; 10ECB
push byte 0	; 10ED0
call sub_B4B88	; 10ED2
add esp, byte 0Ch	; 10ED7
call sub_B4BA8	; 10EDA
mov ecx, dword [screenh]	; 10EDF
push ecx	; 10EE5
push byte 0	; 10EE6
mov ebp, dword [screenw]	; 10EE8
push ebp	; 10EEE
push byte 0	; 10EEF
call sub_B4BC4	; 10EF1
add esp, byte 10h	; 10EF6
push byte 0	; 10EF9
call sub_B392C	; 10EFB
add esp, byte 4	; 10F00
push byte 28h	; 10F03
call SetTickDeadline	; 10F05
add esp, byte 4	; 10F0A
call sub_B4C33	; 10F0D
push edi	; 10F12
push esi	; 10F13
call sub_8E080	; 10F14
add esp, byte 8	; 10F19
push unk_C4E30	; 10F1C
push dword 100h	; 10F21
push byte 0	; 10F26
call sub_B4B88	; 10F28
add esp, byte 0Ch	; 10F2D
push edi	; 10F30
push byte 0	; 10F31
push esi	; 10F33
push byte 0	; 10F34
call sub_B4BC4	; 10F36
add esp, byte 10h	; 10F3B
push byte 0	; 10F3E
call sub_B392C	; 10F40
add esp, byte 4	; 10F45
push edi	; 10F48
push esi	; 10F49
push byte 0	; 10F4A
push byte 0	; 10F4C
call sub_B2E1B	; 10F4E
add esp, byte 10h	; 10F53
mov dword [screenw], esi	; 10F56
mov dword [screenh], edi	; 10F5C
call WaitTickDeadline	; 10F62
.x:
pop ebp	; 10F67
pop edi	; 10F68
pop esi	; 10F69
pop ecx	; 10F6A
pop ebx	; 10F6B
ret	; 10F6C
%endif ; C
; C: src/c/front/main/IntermissionPC.c
%ifdef CBUILD
%include "c/front/main/IntermissionPC.inc"
%else
IntermissionPC:
push dword 1Ch	; 10F6D
call __CHK	; 10F72
push ebx	; 10F77
push ecx	; 10F78
push edx	; 10F79
mov eax, dword [exitgame-2]	; 10F7A
sar eax, 10h	; 10F7F
cmp eax, byte 0FFFFFFFFh	; 10F82
je short .3	; 10F85
push savepal	; 10F87
push dword 100h	; 10F8C
push byte 0	; 10F91
call sub_8FFB0	; 10F93
add esp, byte 0Ch	; 10F98
mov ebx, 10h	; 10F9B
mov edx, savepal	; 10FA0
mov eax, 1	; 10FA5
call FadePalette	; 10FAA
mov edx, 1E0h	; 10FAF
mov eax, 280h	; 10FB4
call SetScreenSize	; 10FB9
call CrowdFadeOut	; 10FBE
cmp byte [musicon], 0	; 10FC3
je short .1	; 10FCA
call MusicChanReset	; 10FCC
jmp short .2	; 10FD1
.1:
call sub_8F633	; 10FD3
.2:
call StopDigiSample	; 10FD8
mov eax, 222E0h	; 10FDD
call sub_1BAF3	; 10FE2
.3:
mov edx, dword [s1font]	; 10FE7
push edx	; 10FED
call sub_8EA18	; 10FEE
add esp, byte 4	; 10FF3
call IntermissionDesk	; 10FF6
inc dword [curperiod]	; 10FFB
pop edx	; 11001
pop ecx	; 11002
pop ebx	; 11003
ret	; 11004
%endif ; C
; C: src/c/front/main/DrawSpriteNumber.c
%ifdef CBUILD
%include "c/front/main/DrawSpriteNumber.inc"
%else
DrawSpriteNumber:
push dword 1Ch	; 11005
call __CHK	; 1100A
push esi	; 1100F
push edi	; 11010
sub esp, byte 8	; 11011
mov esi, eax	; 11014
mov word [byte esp+04h], cx	; 11016
mov eax, ebx	; 1101B
add esi, 0C0h	; 1101D
mov edi, 140h	; 11023
sub edi, edx	; 11028
mov edx, edi	; 1102A
add edx, byte 0Dh	; 1102C
mov word [esp], dx	; 1102F
test cx, cx	; 11033
jle short .1	; 11036
sub esi, byte 4	; 11038
.1:
cmp word [byte esp+04h], byte 0	; 1103B
jl short .2	; 11041
add word [esp], byte 2	; 11043
.2:
cmp bx, byte 0Ah	; 11048
jl short .3	; 1104C
movsx edi, bx	; 1104E
mov ebx, 0Ah	; 11051
mov eax, edi	; 11056
mov edx, edi	; 11058
sar edx, 1Fh	; 1105A
idiv ebx	; 1105D
push byte 0	; 1105F
push byte 0	; 11061
mov ebx, dword [byte esp+06h]	; 11063
sar ebx, 10h	; 11067
sub esi, byte 3	; 1106A
movsx edx, si	; 1106D
cwde	; 11070
mov eax, dword [nosplit eax*4+numshapes]	; 11071
xor ecx, ecx	; 11078
call DrawSprite	; 1107A
mov ebx, 0Ah	; 1107F
mov eax, edi	; 11084
mov edx, edi	; 11086
sar edx, 1Fh	; 11088
idiv ebx	; 1108B
mov eax, edx	; 1108D
add esi, byte 7	; 1108F
.3:
push byte 0	; 11092
push byte 0	; 11094
mov edi, dword [byte esp+06h]	; 11096
sar edi, 10h	; 1109A
movsx edx, si	; 1109D
cwde	; 110A0
mov eax, dword [nosplit eax*4+numshapes]	; 110A1
xor ecx, ecx	; 110A8
mov ebx, edi	; 110AA
call DrawSprite	; 110AC
cmp word [byte esp+04h], byte 0	; 110B1
jle short .x	; 110B7
push byte 0	; 110B9
push byte 0	; 110BB
add esi, byte 8	; 110BD
movsx edx, si	; 110C0
mov eax, dword [byte esp+0Ah]	; 110C3
sar eax, 10h	; 110C7
mov eax, dword [nosplit eax*4+dword_D8C4C]	; 110CA
xor ecx, ecx	; 110D1
mov ebx, edi	; 110D3
call DrawSprite	; 110D5
.x:
add esp, byte 8	; 110DA
pop edi	; 110DD
pop esi	; 110DE
ret	; 110DF
%endif ; C
; C: src/c/front/main/DrawFrameSprite.c
%ifdef CBUILD
%include "c/front/main/DrawFrameSprite.inc"
%else
DrawFrameSprite:
push dword 10h	; 110E0
call __CHK	; 110E5
push esi	; 110EA
test ax, ax	; 110EB
jl short .x	; 110EE
cmp ax, 46Eh	; 110F0
jge short .x	; 110F4
cwde	; 110F6
shl eax, 2	; 110F7
cmp dword [dword eax+photoptrs], byte 0	; 110FA
je short .x	; 11101
mov esi, edx	; 11103
add esi, 0C0h	; 11105
mov edx, 140h	; 1110B
sub edx, ebx	; 11110
mov ebx, edx	; 11112
push byte 1	; 11114
mov edx, dword [byte esp+0Ah]	; 11116
sar edx, 10h	; 1111A
push edx	; 1111D
movsx ecx, cx	; 1111E
movsx ebx, bx	; 11121
movsx edx, si	; 11124
mov eax, dword [dword eax+photoptrs]	; 11127
call DrawSprite	; 1112D
.x:
pop esi	; 11132
ret 4	; 11133
%endif ; C
; C: src/c/front/main/DrawRinkEndArt.c
%ifdef CBUILD
%include "c/front/main/DrawRinkEndArt.inc"
%else
DrawRinkEndArt:
push dword 18h	; 11136
call __CHK	; 1113B
push ebx	; 11140
push ecx	; 11141
push edx	; 11142
push byte 0	; 11143
push byte 0FFFFFFFFh	; 11145
mov eax, dword [rinkendart]	; 11147
xor ecx, ecx	; 1114C
mov ebx, 225h	; 1114E
mov edx, 37h	; 11153
call DrawSprite	; 11158
pop edx	; 1115D
pop ecx	; 1115E
pop ebx	; 1115F
ret	; 11160
%endif ; C
; C: src/c/front/main/WaitKeyRelease.c
%ifdef CBUILD
%include "c/front/main/WaitKeyRelease.inc"
%else
WaitKeyRelease:
push dword 18h	; 11161
call __CHK	; 11166
push ebx	; 1116B
push ecx	; 1116C
push edx	; 1116D
push esi	; 1116E
mov esi, eax	; 1116F
.1:
push esi	; 11171
call sub_B2CBE	; 11172
add esp, byte 4	; 11177
test eax, eax	; 1117A
je short .2	; 1117C
call PollKey	; 1117E
jmp short WaitKeyRelease.1	; 11183
.2:
call sub_B3A24	; 11185
pop esi	; 1118A
pop edx	; 1118B
pop ecx	; 1118C
pop ebx	; 1118D
ret	; 1118E
%endif ; C
; C: src/c/front/main/HandleHotKey.c
%ifdef CBUILD
%include "c/front/main/HandleHotKey.inc"
%else
HandleHotKey:
push dword 2Ch	; 1118F
call __CHK	; 11194
push ebx	; 11199
push ecx	; 1119A
push edx	; 1119B
push esi	; 1119C
push edi	; 1119D
push ebp	; 1119E
test al, 80h	; 1119F
je near .19	; 111A1
and al, 7Fh	; 111A7
mov ah, al	; 111A9
cmp al, 32h	; 111AB
jb short .2	; 111AD
jbe near .17	; 111AF
cmp al, 3Fh	; 111B5
jb short .1	; 111B7
cmp al, 42h	; 111B9
jbe short .5	; 111BB
cmp al, 43h	; 111BD
jbe near .6	; 111BF
cmp al, 44h	; 111C5
je near .8	; 111C7
jmp near .19	; 111CD
.1:
cmp al, 3Bh	; 111D2
jb near .19	; 111D4
jmp short .4	; 111DA
.2:
cmp al, 0Fh	; 111DC
jb short .3	; 111DE
jbe short .9	; 111E0
cmp al, 13h	; 111E2
jb near .19	; 111E4
jbe short .10	; 111EA
cmp al, 1Fh	; 111EC
je near HandleHotKey_ret.20	; 111EE
jmp near .19	; 111F4
.3:
cmp al, 1	; 111F9
je near HandleHotKey_ret.24	; 111FB
jmp near .19	; 11201
.4:
mov word [lcrequest], 1	; 11206
xor ah, ah	; 1120F
sub eax, byte 3Bh	; 11211
mov word [lcreqchoice], ax	; 11214
jmp near .19	; 1121A
.5:
mov word [lcrequest+2], 1	; 1121F
xor ah, ah	; 11228
sub eax, byte 3Fh	; 1122A
mov word [lcreqchoice+2], ax	; 1122D
jmp near .19	; 11233
.6:
xor eax, eax	; 11238
.7:
call ShowGoalieBanner	; 1123A
jmp near .19	; 1123F
.8:
mov eax, 1	; 11244
jmp short HandleHotKey.7	; 11249
.9:
cmp dword [shownumbers], byte 0	; 1124B
sete al	; 11252
and eax, 0FFh	; 11255
mov dword [shownumbers], eax	; 1125A
jmp near .19	; 1125F
.10:
test byte [gmode], 10h	; 11264
jne near .19	; 1126B
cmp dword [curperiod], byte 0FFFFFFFFh	; 11271
je near .19	; 11278
mov ax, word [joysampling]	; 1127E
mov word [joysampling_save], ax	; 11284
xor esi, esi	; 1128A
mov dword [joysampling], esi	; 1128C
cmp byte [pad1dev], 1	; 11292
je short .11	; 11299
cmp byte [pad2dev], 1	; 1129B
jne short .12	; 112A2
.11:
mov eax, dword [mousex]	; 112A4
mov dword [savedmousex], eax	; 112A9
mov eax, dword [mousey]	; 112AE
mov dword [savedmousey], eax	; 112B3
.12:
push savepal	; 112B8
push dword 100h	; 112BD
push byte 0	; 112C2
call sub_8FFB0	; 112C4
add esp, byte 0Ch	; 112C9
mov ebx, 10h	; 112CC
mov edx, savepal	; 112D1
mov eax, 1	; 112D6
call FadePalette	; 112DB
call CrowdFadeOut	; 112E0
cmp byte [musicon], 0	; 112E5
je short .13	; 112EC
call MusicChanReset	; 112EE
jmp short .14	; 112F3
.13:
call sub_8F633	; 112F5
.14:
call SpeechStopQueue	; 112FA
call StopDigiSample	; 112FF
call InputInstall	; 11304
mov eax, 1	; 11309
call InstantReplay	; 1130E
call ClearInputQueue	; 11313
call InputRemove	; 11318
cmp byte [pad1dev], 1	; 1131D
je short .15	; 11324
cmp byte [pad2dev], 1	; 11326
jne short .16	; 1132D
.15:
mov edi, dword [savedmousey]	; 1132F
push edi	; 11335
mov ebp, dword [savedmousex]	; 11336
push ebp	; 1133C
call MouseSetPos	; 1133D
add esp, byte 8	; 11342
push dword 0C8h	; 11345
push dword 140h	; 1134A
push byte 0	; 1134F
push byte 0	; 11351
call sub_B2E1B	; 11353
add esp, byte 10h	; 11358
.16:
mov word [fadeinpending], 1	; 1135B
mov ebx, dword [curperiod]	; 11364
mov edx, dword [VisTeam-2]	; 1136A
sar edx, 10h	; 11370
mov eax, dword [HomeTeam-2]	; 11373
sar eax, 10h	; 11378
xor ecx, ecx	; 1137B
call DrawHudPanel	; 1137D
mov eax, dword [joysampling_save-2]	; 11382
sar eax, 10h	; 11387
mov dword [joysampling], eax	; 1138A
mov eax, 1	; 1138F
add dword [rinkscrollx], 3E8h	; 11394
add dword [rinkscrolly], 3E8h	; 1139E
jmp near HandleHotKey_ret	; 113A8
.17:
test byte [gameopts], 40h	; 113AD
sete al	; 113B4
and eax, byte 1	; 113B7
and byte [gameopts], 0BFh	; 113BA
shl eax, 6	; 113C1
or dword [gameopts], eax	; 113C4
test byte [gameopts], 40h	; 113CA
je short .18	; 113D1
call sub_8F979	; 113D3
jmp near .19	; 113D8
.18:
call StopDigiSample	; 113DD
call sub_8F984	; 113E2
.19:
xor eax, eax	; 113E7
HandleHotKey_ret:
pop ebp	; 113E9
pop edi	; 113EA
pop esi	; 113EB
pop edx	; 113EC
pop ecx	; 113ED
pop ebx	; 113EE
ret	; 113EF
.20:
test byte [gameopts], 80h	; 113F0
je short .23	; 113F7
call CrowdNoiseOff	; 113F9
cmp byte [musicon], 0	; 113FE
je short .21	; 11405
call MusicChanReset	; 11407
jmp short .22	; 1140C
.21:
call sub_8F633	; 1140E
.22:
call sub_8F96E	; 11413
.23:
mov cl, byte [gameopts]	; 11418
test cl, 80h	; 1141E
sete al	; 11421
and eax, byte 1	; 11424
mov ch, cl	; 11427
and ch, 7Fh	; 11429
mov byte [gameopts], ch	; 1142C
shl eax, 7	; 11432
or dword [gameopts], eax	; 11435
test byte [gameopts], 80h	; 1143B
je short HandleHotKey.19	; 11442
call CrowdNoiseReset	; 11444
call sub_8F963	; 11449
jmp short HandleHotKey.19	; 1144E
.24:
mov esi, 1	; 11450
mov dword [escrequest], esi	; 11455
mov eax, esi	; 1145B
jmp short HandleHotKey_ret	; 1145D
%endif ; C
; C: src/c/front/main/ResetInputSampling.c
%ifdef CBUILD
%include "c/front/main/ResetInputSampling.inc"
%else
ResetInputSampling:
push dword 8	; 1145F
call __CHK	; 11464
push edx	; 11469
mov ax, word [joysampling]	; 1146A
mov word [joysampling_save], ax	; 11470
xor edx, edx	; 11476
mov dword [joysampling], edx	; 11478
mov eax, dword [inputticks]	; 1147E
mov dword [inputticks], edx	; 11483
mov edx, dword [joysampling_save-2]	; 11489
sar edx, 10h	; 1148F
mov dword [joysampling], edx	; 11492
pop edx	; 11498
ret	; 11499
%endif ; C
; C: src/c/front/main/RunGameFrames.c
%ifdef CBUILD
%include "c/front/main/RunGameFrames.inc"
%else
RunGameFrames:
push dword 0Ch	; 1149A
call __CHK	; 1149F
push ebx	; 114A4
push edx	; 114A5
mov ebx, eax	; 114A6
xor edx, edx	; 114A8
jmp near .7	; 114AA
.1:
cmp dword [inputframes], byte 0	; 114AF
jne short .3	; 114B6
call joyq_peek	; 114B8
mov dword [joyrec], eax	; 114BD
test eax, eax	; 114C2
je near .x	; 114C4
mov al, byte [byte eax+02h]	; 114CA
test al, 80h	; 114CD
je short .2	; 114CF
and eax, 0FFh	; 114D1
call HandleHotKey	; 114D6
cmp eax, byte 1	; 114DB
jne short .2	; 114DE
call joyq_flush	; 114E0
pop edx	; 114E5
pop ebx	; 114E6
ret	; 114E7
.2:
mov dword [inputframes], 3	; 114E8
.3:
test byte [gmode], 1	; 114F2
jne short .5	; 114F9
cmp dword [penshotlive], byte 0	; 114FB
jne short .4	; 11502
add dword [hudhundaccum], byte 64h	; 11504
.4:
call ClockTick	; 1150B
.5:
call DoGameFrame	; 11510
mov eax, dword [inputframes]	; 11515
dec eax	; 1151A
mov dword [inputframes], eax	; 1151B
jne short .6	; 11520
call joyq_pop	; 11522
.6:
cmp dword [deferpending], byte 0	; 11527
jne short .x	; 1152E
cmp word [exitgame], byte 0	; 11530
jne short .x	; 11538
cmp word [gameover], byte 0	; 1153A
jne short .x	; 11542
inc edx	; 11544
.7:
cmp edx, ebx	; 11545
jl near RunGameFrames.1	; 11547
.x:
pop edx	; 1154D
pop ebx	; 1154E
ret	; 1154F
%endif ; C
; C: src/c/front/main/HandleHotKey.c (SetFullPalette)
%ifdef CBUILD
%include "c/front/main/HandleHotKey.SetFullPalette.inc"
%else
SetFullPalette:
push dword 28h	; 11550
call __CHK	; 11555
push ebx	; 1155A
push ecx	; 1155B
push edx	; 1155C
push esi	; 1155D
push edi	; 1155E
push ebp	; 1155F
mov ebp, eax	; 11560
xor esi, esi	; 11562
xor edi, edi	; 11564
jmp short .2	; 11566
.1:
call sub_B4C84	; 11568
lea eax, [edi+ebp]	; 1156D
push eax	; 11570
push dword 80h	; 11571
push esi	; 11576
call sub_B4B88	; 11577
add esp, byte 0Ch	; 1157C
add esi, 80h	; 1157F
add edi, 180h	; 11585
.2:
cmp esi, 100h	; 1158B
jl short SetFullPalette.1	; 11591
jmp near HandleHotKey_ret	; 11593
%endif ; C
FadePalette:
push dword 18h	; 11598
call __CHK	; 1159D
push ecx	; 115A2
push esi	; 115A3
push edi	; 115A4
push ebp	; 115A5
sub esp, byte 4	; 115A6
mov edi, eax	; 115A9
mov esi, edx	; 115AB
mov dword [esp], ebx	; 115AD
test eax, eax	; 115B0
je short .4	; 115B2
cmp dword [palfadedin], byte 0	; 115B4
je short .3	; 115BB
mov ecx, dword [esp]	; 115BD
cmp ecx, byte 2	; 115C0
jle short .1	; 115C3
mov eax, 2	; 115C5
jmp short .2	; 115CA
.1:
mov eax, ecx	; 115CC
.2:
mov dword [esp], eax	; 115CE
.3:
mov dword [palfadedin], 1	; 115D1
jmp short .5	; 115DB
.4:
mov dword [palfadedin], eax	; 115DD
.5:
cmp dword [esp], byte 2	; 115E2
jge short .8	; 115E6
test edi, edi	; 115E8
jne short .7	; 115EA
mov eax, esi	; 115EC
.6:
call SetFullPalette	; 115EE
jmp near .x	; 115F3
.7:
mov ecx, 300h	; 115F8
xor edx, edx	; 115FD
mov eax, byte_D8C88	; 115FF
call __STOSB	; 11604
mov eax, byte_D8C88	; 11609
jmp short FadePalette.6	; 1160E
.8:
mov al, byte [esp]	; 11610
dec al	; 11613
mov byte [dword_C5135], al	; 11615
mov al, byte [esp]	; 1161A
inc al	; 1161D
mov byte [byte_C5138], al	; 1161F
mov ecx, dword [dword edi+dword_C5131]	; 11624
sar ecx, 18h	; 1162A
mov ebp, dword [esp]	; 1162D
jmp short .11	; 11630
.9:
xor ebx, ebx	; 11632
.10:
movsx edx, byte [esi+ebx]	; 11634
imul edx, ecx	; 11638
mov eax, edx	; 1163B
sar edx, 1Fh	; 1163D
idiv ebp	; 11640
mov byte [dword ebx+byte_D8C88], al	; 11642
inc ebx	; 11648
cmp ebx, 300h	; 11649
jl short FadePalette.10	; 1164F
mov eax, byte_D8C88	; 11651
call SetFullPalette	; 11656
mov eax, dword [dword edi+dword_C5133]	; 1165B
sar eax, 18h	; 11661
add ecx, eax	; 11664
.11:
mov eax, dword [dword edi+byte_C5138-3]	; 11666
sar eax, 18h	; 1166C
cmp ecx, eax	; 1166F
jne short FadePalette.9	; 11671
.x:
add esp, byte 4	; 11673
pop ebp	; 11676
pop edi	; 11677
pop esi	; 11678
pop ecx	; 11679
ret	; 1167A
Gameloop:
push dword 48h	; 1167B
call __CHK	; 11680
push ebx	; 11685
push ecx	; 11686
push edx	; 11687
push esi	; 11688
push edi	; 11689
push ebp	; 1168A
sub esp, byte 20h	; 1168B
call TicksSinceLastCall	; 1168E
.1:
mov dword [joysampling], 1	; 11693
cmp word [gameover], byte 0	; 1169D
jne near .29	; 116A5
.2:
cmp word [exitgame], byte 0	; 116AB
jne near .24	; 116B3
call ResetInputSampling	; 116B9
mov edx, eax	; 116BE
shl eax, 2	; 116C0
sub eax, edx	; 116C3
add eax, eax	; 116C5
mov ebp, dword [frameaccum]	; 116C7
add ebp, eax	; 116CD
mov dword [frameaccum], ebp	; 116CF
mov ebx, 0Ah	; 116D5
mov eax, ebp	; 116DA
mov edx, ebp	; 116DC
sar edx, 1Fh	; 116DE
idiv ebx	; 116E1
mov esi, eax	; 116E3
mov eax, ebp	; 116E5
mov edx, ebp	; 116E7
sar edx, 1Fh	; 116E9
idiv ebx	; 116EC
mov dword [frameaccum], edx	; 116EE
mov eax, esi	; 116F4
call RunGameFrames	; 116F6
mov eax, dword [camx-2]	; 116FB
sar eax, 10h	; 11700
add eax, byte 20h	; 11703
mov dword [viewscrollx], eax	; 11706
mov eax, dword [camy-2]	; 1170B
sar eax, 10h	; 11710
mov edx, 140h	; 11713
sub edx, eax	; 11718
lea eax, [byte edx-054h]	; 1171A
mov dword [viewscrolly], eax	; 1171D
mov eax, dword [viewscrollx]	; 11722
cmp eax, byte 40h	; 11727
jle short .3	; 1172A
mov dword [viewscrollx], 40h	; 1172C
jmp short .4	; 11736
.3:
test eax, eax	; 11738
jge short .4	; 1173A
xor ebx, ebx	; 1173C
mov dword [viewscrollx], ebx	; 1173E
.4:
mov edi, dword [viewscrolly]	; 11744
cmp edi, 1A8h	; 1174A
jle short .5	; 11750
mov dword [viewscrolly], 1A8h	; 11752
jmp short .6	; 1175C
.5:
test edi, edi	; 1175E
jge short .6	; 11760
xor eax, eax	; 11762
mov dword [viewscrolly], eax	; 11764
.6:
xor edx, edx	; 11769
xor eax, eax	; 1176B
call sub_6AF97	; 1176D
call sub_6B008	; 11772
mov edx, dword [viewscrolly]	; 11777
mov eax, dword [viewscrollx]	; 1177D
call SetRinkScroll	; 11782
mov eax, dword [bgscrolly-2]	; 11787
sar eax, 10h	; 1178C
shl eax, 3	; 1178F
mov edx, dword [scrolly-2]	; 11792
sar edx, 10h	; 11798
add edx, eax	; 1179B
lea ecx, [dword edx+0A8h]	; 1179D
mov ebx, dword [bgscrollx-2]	; 117A3
sar ebx, 10h	; 117A9
shl ebx, 3	; 117AC
mov eax, dword [scrollx-2]	; 117AF
sar eax, 10h	; 117B4
add eax, ebx	; 117B7
lea ebx, [dword eax+0140h]	; 117B9
call sub_6AF52	; 117BF
xor ebx, ebx	; 117C4
mov dword [spritedrawcount], ebx	; 117C6
mov edx, dword [viewscrolly-2]	; 117CC
sar edx, 10h	; 117D2
mov eax, dword [viewscrollx-2]	; 117D5
sar eax, 10h	; 117DA
call DrawRinkOverlays	; 117DD
cmp word [fadeinpending], byte 0	; 117E2
je short .7	; 117EA
mov ax, word [joysampling]	; 117EC
mov word [joysampling_save], ax	; 117F2
mov dword [joysampling], ebx	; 117F8
push savepal	; 117FE
push dword 100h	; 11803
push ebx	; 11808
call sub_8FFB0	; 11809
add esp, byte 0Ch	; 1180E
mov ebx, 10h	; 11811
mov edx, savepal	; 11816
mov eax, 1	; 1181B
call FadePalette	; 11820
call FlushGSumQueue	; 11825
mov eax, dword [joysampling_save-2]	; 1182A
sar eax, 10h	; 1182F
mov dword [joysampling], eax	; 11832
.7:
movsx eax, si	; 11837
call Crowd_Noise	; 1183A
cmp dword [penshotlive], byte 0	; 1183F
je short .8	; 11846
xor edi, edi	; 11848
mov dword [hudhundstep], edi	; 1184A
jmp near .9	; 11850
.8:
mov edx, dword [hudhundaccum]	; 11855
mov ebx, 18h	; 1185B
mov eax, edx	; 11860
sar edx, 1Fh	; 11862
idiv ebx	; 11865
mov dword [hudhundstep], eax	; 11867
mov eax, dword [hudhundaccum]	; 1186C
mov edx, eax	; 11871
sar edx, 1Fh	; 11873
idiv ebx	; 11876
mov dword [hudhundaccum], edx	; 11878
cmp word [exitgame], byte 0	; 1187E
je short .9	; 11886
mov edx, dword [gameclock-2]	; 11888
sar edx, 10h	; 1188E
mov eax, dword [clockticks-2]	; 11891
sar eax, 10h	; 11896
or eax, edx	; 11899
jne short .9	; 1189B
mov edx, dword [hudclockmin]	; 1189D
mov eax, edx	; 118A3
shl eax, 4	; 118A5
sub eax, edx	; 118A8
shl eax, 2	; 118AA
mov edx, dword [hudclocksec]	; 118AD
add edx, eax	; 118B3
mov eax, edx	; 118B5
shl eax, 2	; 118B7
sub eax, edx	; 118BA
shl eax, 3	; 118BC
add eax, edx	; 118BF
shl eax, 2	; 118C1
mov edx, dword [hudclockhund]	; 118C4
add eax, edx	; 118CA
mov dword [hudhundstep], eax	; 118CC
.9:
call UpdateHudPanel	; 118D1
mov edx, dword [bgscrolly-2]	; 118D6
sar edx, 10h	; 118DC
shl edx, 3	; 118DF
mov eax, dword [scrolly-2]	; 118E2
sar eax, 10h	; 118E7
add edx, eax	; 118EA
neg edx	; 118EC
mov ebx, dword [bgscrollx-2]	; 118EE
sar ebx, 10h	; 118F4
shl ebx, 3	; 118F7
mov eax, dword [scrollx-2]	; 118FA
sar eax, 10h	; 118FF
add eax, ebx	; 11902
neg eax	; 11904
call sub_6AF97	; 11906
call sub_6ADA7	; 1190B
cmp word [fadeinpending], byte 0	; 11910
je short .10	; 11918
mov ax, word [joysampling]	; 1191A
mov word [joysampling_save], ax	; 11920
xor ebp, ebp	; 11926
mov dword [joysampling], ebp	; 11928
mov ebx, 10h	; 1192E
mov edx, gamepal	; 11933
xor eax, eax	; 11938
call FadePalette	; 1193A
xor esi, esi	; 1193F
mov word [fadeinpending], si	; 11941
mov eax, dword [joysampling_save-2]	; 11948
sar eax, 10h	; 1194D
mov dword [joysampling], eax	; 11950
.10:
cmp dword [escrequest], byte 0	; 11955
je near .23	; 1195C
mov edx, dword [demomode]	; 11962
test edx, edx	; 11968
je short .11	; 1196A
mov ebx, 10h	; 1196C
mov edx, gamepal	; 11971
mov eax, 1	; 11976
call FadePalette	; 1197B
mov dword [gameresult], 2	; 11980
jmp near .30	; 1198A
.11:
mov ax, word [joysampling]	; 1198F
mov word [joysampling_save], ax	; 11995
mov dword [joysampling], edx	; 1199B
cmp byte [pad1dev], 1	; 119A1
je short .12	; 119A8
cmp byte [pad2dev], 1	; 119AA
jne short .13	; 119B1
.12:
mov eax, dword [mousex]	; 119B3
mov dword [savedmousex], eax	; 119B8
mov eax, dword [mousey]	; 119BD
mov dword [savedmousey], eax	; 119C2
.13:
call CrowdFadeOut	; 119C7
cmp byte [musicon], 0	; 119CC
je short .14	; 119D3
call MusicChanReset	; 119D5
jmp short .15	; 119DA
.14:
call sub_8F633	; 119DC
.15:
call StopDigiSample	; 119E1
call SpeechStopQueue	; 119E6
call FlushGSumQueue	; 119EB
mov ecx, dword [s1font]	; 119F0
push ecx	; 119F6
call sub_8EA18	; 119F7
add esp, byte 4	; 119FC
push savepal	; 119FF
push dword 100h	; 11A04
push byte 0	; 11A09
call sub_8FFB0	; 11A0B
add esp, byte 0Ch	; 11A10
mov ebx, 10h	; 11A13
mov edx, savepal	; 11A18
mov eax, 1	; 11A1D
call FadePalette	; 11A22
mov edx, 1E0h	; 11A27
mov eax, 280h	; 11A2C
call SetScreenSize	; 11A31
xor eax, eax	; 11A36
call SportsDesk	; 11A38
cmp dword [gameresult], byte 2	; 11A3D
je near .30	; 11A44
mov edx, 0C8h	; 11A4A
mov eax, 140h	; 11A4F
call SetScreenSize	; 11A54
cmp byte [pad1dev], 1	; 11A59
je short .16	; 11A60
cmp byte [pad2dev], 1	; 11A62
jne short .17	; 11A69
.16:
mov edi, dword [savedmousey]	; 11A6B
push edi	; 11A71
mov ebp, dword [savedmousex]	; 11A72
push ebp	; 11A78
call MouseSetPos	; 11A79
add esp, byte 8	; 11A7E
.17:
mov word [fadeinpending], 1	; 11A81
xor eax, eax	; 11A8A
mov dword [escrequest], eax	; 11A8C
mov eax, dword [VisTeam-2]	; 11A91
sar eax, 10h	; 11A96
mov edx, dword [nosplit eax*4+teamabbrevs]	; 11A99
mov eax, dword [HomeTeam-2]	; 11AA0
sar eax, 10h	; 11AA5
mov eax, dword [nosplit eax*4+teamabbrevs]	; 11AA8
call PaPreloadClips	; 11AAF
mov ebx, dword [curperiod]	; 11AB4
mov edx, dword [VisTeam-2]	; 11ABA
sar edx, 10h	; 11AC0
mov eax, dword [HomeTeam-2]	; 11AC3
sar eax, 10h	; 11AC8
xor ecx, ecx	; 11ACB
call DrawHudPanel	; 11ACD
mov eax, dword [ovlseq-2]	; 11AD2
sar eax, 10h	; 11AD7
add dword [rinkscrollx], 3E8h	; 11ADA
add dword [rinkscrolly], 3E8h	; 11AE4
cmp eax, byte 0FFFFFFFFh	; 11AEE
je near .22	; 11AF1
mov edx, dword [ovlstep-2]	; 11AF7
sar edx, 10h	; 11AFD
cmp edx, byte 0FFFFFFFFh	; 11B00
je near .22	; 11B03
cmp dword [dword_E0244], byte 0	; 11B09
jne near .22	; 11B10
mov ecx, str_PPV	; 11B16
mov ebx, dword [nosplit eax*4+off_CBED0]	; 11B1B
mov eax, dword [nosplit eax*4+dword_CC080]	; 11B22
cmp byte [dword eax+fileoncd], 1	; 11B29
jne short .18	; 11B30
mov edx, dword [cddriveptr]	; 11B32
jmp short .19	; 11B38
.18:
xor edx, edx	; 11B3A
.19:
mov eax, esp	; 11B3C
call MakePath	; 11B3E
push byte 20h	; 11B43
lea eax, [byte esp+04h]	; 11B45
push eax	; 11B49
call sub_8E8A0	; 11B4A
add esp, byte 8	; 11B4F
mov dword [dword_E0244], eax	; 11B52
xor esi, esi	; 11B57
jmp short .21	; 11B59
.20:
push esi	; 11B5B
mov ebp, dword [dword_E0244]	; 11B5C
push ebp	; 11B62
call sub_9035C	; 11B63
add esp, byte 8	; 11B68
mov dword [nosplit esi*4+dword_DEF8C], eax	; 11B6B
inc esi	; 11B72
.21:
mov edi, dword [dword_E0244]	; 11B73
push edi	; 11B79
call sub_90354	; 11B7A
add esp, byte 4	; 11B7F
cmp esi, eax	; 11B82
jl short Gameloop.20	; 11B84
.22:
mov eax, dword [joysampling_save-2]	; 11B86
sar eax, 10h	; 11B8B
mov dword [joysampling], eax	; 11B8E
call joyq_flush	; 11B93
.23:
cmp dword [deferpending], byte 0	; 11B98
je near Gameloop.2	; 11B9F
mov ax, word [joysampling]	; 11BA5
mov word [joysampling_save], ax	; 11BAB
xor edx, edx	; 11BB1
mov dword [joysampling], edx	; 11BB3
call RunDeferredCalls	; 11BB9
mov dword [deferpending], edx	; 11BBE
mov eax, dword [joysampling_save-2]	; 11BC4
sar eax, 10h	; 11BC9
mov dword [joysampling], eax	; 11BCC
call joyq_flush	; 11BD1
jmp near Gameloop.2	; 11BD6
.24:
xor esi, esi	; 11BDB
mov dword [joysampling], esi	; 11BDD
cmp dword [demomode], byte 0	; 11BE3
je short .25	; 11BEA
mov ebx, 10h	; 11BEC
mov edx, gamepal	; 11BF1
mov eax, 1	; 11BF6
call FadePalette	; 11BFB
mov dword [gameresult], 1	; 11C00
jmp near .30	; 11C0A
.25:
call PeriodOver	; 11C0F
cmp dword [gameresult], byte 2	; 11C14
je near .30	; 11C1B
cmp word [gameover], byte 0	; 11C21
jne short .26	; 11C29
call SelectScreenBM	; 11C2B
mov edx, dword [VisTeam-2]	; 11C30
sar edx, 10h	; 11C36
mov edx, dword [nosplit edx*4+teamabbrevs]	; 11C39
mov eax, dword [HomeTeam-2]	; 11C40
sar eax, 10h	; 11C45
mov eax, dword [nosplit eax*4+teamabbrevs]	; 11C48
call PaPreloadClips	; 11C4F
mov ebx, dword [curperiod]	; 11C54
mov edx, dword [VisTeam-2]	; 11C5A
sar edx, 10h	; 11C60
mov eax, dword [HomeTeam-2]	; 11C63
sar eax, 10h	; 11C68
mov ecx, 1	; 11C6B
call DrawHudPanel	; 11C70
xor eax, eax	; 11C75
call PlayCrowdSample	; 11C77
.26:
cmp byte [pad1dev], 1	; 11C7C
je short .27	; 11C83
cmp byte [pad2dev], 1	; 11C85
jne short .28	; 11C8C
.27:
push byte 64h	; 11C8E
push dword 0A0h	; 11C90
call MouseSetPos	; 11C95
add esp, byte 8	; 11C9A
.28:
xor esi, esi	; 11C9D
mov word [lcrequest+2], si	; 11C9F
mov word [lcrequest], si	; 11CA6
xor eax, eax	; 11CAD
mov dword [deferpending], eax	; 11CAF
xor edx, edx	; 11CB4
mov dword [inputframes], eax	; 11CB6
xor eax, eax	; 11CBB
mov word [exitgame], ax	; 11CBD
xor ebx, ebx	; 11CC3
mov dword [frameaccum], ebx	; 11CC5
mov dword [hudhundaccum], edx	; 11CCB
call joyq_flush	; 11CD1
jmp near Gameloop.1	; 11CD6
.29:
xor ebx, ebx	; 11CDB
mov dword [joysampling], ebx	; 11CDD
call FlushGSumQueue	; 11CE3
call StartThreeStars	; 11CE8
call PostGameDesk	; 11CED
mov dword [gameresult], 1	; 11CF2
.30:
call sub_1B982	; 11CFC
add esp, byte 20h	; 11D01
jmp near HandleHotKey_ret	; 11D04
; C: src/c/front/main/HandleHotKey.c (PlayGame)
%ifdef CBUILD
%include "c/front/main/HandleHotKey.PlayGame.inc"
%else
PlayGame:
push dword 64h	; 11D09
call __CHK	; 11D0E
push ebx	; 11D13
push ecx	; 11D14
push edx	; 11D15
push esi	; 11D16
push edi	; 11D17
push ebp	; 11D18
sub esp, byte 40h	; 11D19
mov edx, eax	; 11D1C
cmp dword [eax], byte 0	; 11D1E
jge near .4	; 11D21
call LoadRockMusic	; 11D27
call LoadGameGfx	; 11D2C
mov edx, dword [VisTeam-2]	; 11D31
sar edx, 10h	; 11D37
mov eax, dword [HomeTeam-2]	; 11D3A
sar eax, 10h	; 11D3F
mov ebx, gamepal	; 11D42
call LoadTeamPalette	; 11D47
call FadeOutPalCycle	; 11D4C
mov edx, 0C8h	; 11D51
mov eax, 140h	; 11D56
call SetScreenSize	; 11D5B
cmp word [HomeTeam], byte 1Ah	; 11D60
jl short .1	; 11D68
mov eax, 0Ch	; 11D6A
jmp short .2	; 11D6F
.1:
mov eax, dword [HomeTeam-2]	; 11D71
sar eax, 10h	; 11D76
.2:
call LoadRink	; 11D79
xor esi, esi	; 11D7E
mov dword [rinkscrolly], esi	; 11D80
mov dword [rinkscrollx], esi	; 11D86
call SetupGame	; 11D8C
test eax, eax	; 11D91
jge short .3	; 11D93
mov dword [gameresult], 2	; 11D95
call sub_1B982	; 11D9F
call sub_B4BA8	; 11DA4
jmp near .15	; 11DA9
.3:
call SetupGoalieMenu	; 11DAE
jmp near .14	; 11DB3
.4:
test byte [gameopts+1], 2	; 11DB8
jne short .5	; 11DBF
call LoadCupFinalSeries	; 11DC1
.5:
mov eax, dword [edx]	; 11DC6
call LoadGameState	; 11DC8
mov eax, edx	; 11DCD
call FileClose	; 11DCF
mov dword [edx], 0FFFFFFFFh	; 11DD4
call BuildDefaultLines	; 11DDA
call NormalizeDressFlags	; 11DDF
xor eax, eax	; 11DE4
call SetupTeamLines	; 11DE6
mov eax, 1	; 11DEB
call SetupTeamLines	; 11DF0
call MakeGSummaryPath	; 11DF5
call CrowdNoiseReset	; 11DFA
call SetupGoalieMenu	; 11DFF
mov eax, dword [exitgame-2]	; 11E04
sar eax, 10h	; 11E09
cmp eax, byte 0FFFFFFFFh	; 11E0C
je near .14	; 11E0F
call FadeOutPalCycle	; 11E15
xor ecx, ecx	; 11E1A
mov dword [gameresult], ecx	; 11E1C
xor eax, eax	; 11E22
call SportsDesk	; 11E24
cmp dword [gameresult], byte 2	; 11E29
jne short .6	; 11E30
call sub_1B982	; 11E32
jmp near .16	; 11E37
.6:
mov edx, 0C8h	; 11E3C
mov eax, 140h	; 11E41
call SetScreenSize	; 11E46
cmp byte [pad1dev], 1	; 11E4B
je short .7	; 11E52
cmp byte [pad2dev], 1	; 11E54
jne short .8	; 11E5B
.7:
mov edi, dword [savedmousey]	; 11E5D
push edi	; 11E63
mov ebp, dword [savedmousex]	; 11E64
push ebp	; 11E6A
call MouseSetPos	; 11E6B
add esp, byte 8	; 11E70
.8:
mov word [fadeinpending], 1	; 11E73
xor eax, eax	; 11E7C
mov dword [escrequest], eax	; 11E7E
mov ebx, dword [curperiod]	; 11E83
mov edx, dword [VisTeam-2]	; 11E89
sar edx, 10h	; 11E8F
mov eax, dword [HomeTeam-2]	; 11E92
sar eax, 10h	; 11E97
xor ecx, ecx	; 11E9A
call DrawHudPanel	; 11E9C
mov eax, dword [ovlseq-2]	; 11EA1
sar eax, 10h	; 11EA6
add dword [rinkscrollx], 3E8h	; 11EA9
add dword [rinkscrolly], 3E8h	; 11EB3
cmp eax, byte 0FFFFFFFFh	; 11EBD
je near .13	; 11EC0
mov edx, dword [ovlstep-2]	; 11EC6
sar edx, 10h	; 11ECC
cmp edx, byte 0FFFFFFFFh	; 11ECF
je near .13	; 11ED2
cmp dword [dword_E0244], byte 0	; 11ED8
jne short .13	; 11EDF
mov ecx, str_PPV	; 11EE1
mov ebx, dword [nosplit eax*4+off_CBED0]	; 11EE6
mov eax, dword [nosplit eax*4+dword_CC080]	; 11EED
cmp byte [dword eax+fileoncd], 1	; 11EF4
jne short .9	; 11EFB
mov edx, dword [cddriveptr]	; 11EFD
jmp short .10	; 11F03
.9:
xor edx, edx	; 11F05
.10:
mov eax, esp	; 11F07
call MakePath	; 11F09
push byte 20h	; 11F0E
lea eax, [byte esp+04h]	; 11F10
push eax	; 11F14
call sub_8E8A0	; 11F15
add esp, byte 8	; 11F1A
mov dword [dword_E0244], eax	; 11F1D
xor esi, esi	; 11F22
jmp short .12	; 11F24
.11:
push esi	; 11F26
mov edx, dword [dword_E0244]	; 11F27
push edx	; 11F2D
call sub_9035C	; 11F2E
add esp, byte 8	; 11F33
mov dword [nosplit esi*4+dword_DEF8C], eax	; 11F36
inc esi	; 11F3D
.12:
mov eax, dword [dword_E0244]	; 11F3E
push eax	; 11F43
call sub_90354	; 11F44
add esp, byte 4	; 11F49
cmp esi, eax	; 11F4C
jl short PlayGame.11	; 11F4E
.13:
mov edx, dword [VisTeam-2]	; 11F50
sar edx, 10h	; 11F56
mov edx, dword [nosplit edx*4+teamabbrevs]	; 11F59
mov eax, dword [HomeTeam-2]	; 11F60
sar eax, 10h	; 11F65
mov eax, dword [nosplit eax*4+teamabbrevs]	; 11F68
call PaPreloadClips	; 11F6F
.14:
xor ebx, ebx	; 11F74
mov dword [introskipped], ebx	; 11F76
mov dword [gameresult], ebx	; 11F7C
call joyq_flush	; 11F82
call Gameloop	; 11F87
call ResetGoalieMenu	; 11F8C
cmp dword [gamemode], byte 0	; 11F91
je short .15	; 11F98
cmp dword [gameresult], byte 1	; 11F9A
jne short .15	; 11FA1
and byte [gameopts+1], 7Fh	; 11FA3
mov edx, curleague	; 11FAA
lea eax, [byte esp+020h]	; 11FAF
call strcpy_	; 11FB3
mov edx, str_backslash	; 11FB8
lea eax, [byte esp+020h]	; 11FBD
call strcat_	; 11FC1
mov edx, str_GameSav2	; 11FC6
lea eax, [byte esp+020h]	; 11FCB
call strcat_	; 11FCF
lea eax, [byte esp+020h]	; 11FD4
call j_unlink_	; 11FD8
.15:
mov edx, 1E0h	; 11FDD
mov eax, 280h	; 11FE2
call SetScreenSize	; 11FE7
.16:
add esp, byte 40h	; 11FEC
jmp near HandleHotKey_ret	; 11FEF
%endif ; C
; C: src/c/front/main/assreplace.c
%ifdef CBUILD
%include "c/front/main/assreplace.inc"
%else
assreplace:
push dword 8	; 11FF4
call __CHK	; 11FF9
push ebx	; 11FFE
mov ebx, edx	; 11FFF
mov edx, dword [byte eax+01Ah]	; 12001
sar edx, 10h	; 12004
mov byte [byte edx+eax+01Eh], bl	; 12007
or byte [byte eax+044h], 2	; 1200B
pop ebx	; 1200F
ret	; 12010
%endif ; C
; C: src/c/front/main/assinsert.c
%ifdef CBUILD
%include "c/front/main/assinsert.inc"
%else
assinsert:
push dword 8	; 12011
call __CHK	; 12016
push ebx	; 1201B
mov bx, word [byte eax+01Ch]	; 1201C
dec ebx	; 12020
xor bh, bh	; 12021
and bl, 7	; 12023
mov word [byte eax+01Ch], bx	; 12026
movsx edx, dx	; 1202A
call assreplace	; 1202D
pop ebx	; 12032
ret	; 12033
%endif ; C
; C: src/c/front/main/ReplayIsEmpty.c
%ifdef CBUILD
%include "c/front/main/ReplayIsEmpty.inc"
%else
ReplayIsEmpty:
push dword 4	; 12034
call __CHK	; 12039
mov eax, dword [recbpr]	; 1203E
cmp eax, dword [replaystart]	; 12043
jne short .1	; 12049
test byte [sflags], 10h	; 1204B
jne short .1	; 12052
mov eax, 1	; 12054
ret	; 12059
.1:
xor eax, eax	; 1205A
ret	; 1205C
%endif ; C
