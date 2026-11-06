; End-of-season trophies. Picking the winners, the award screens, the summary of who won each one,
; and the ceremony (95G front/awards95). One module: they share PickAwardWinners' exit.
bits 32
%include "hockey.inc"
section s_1205D progbits alloc exec nowrite align=1
extern __CHK, __STOSB, apl, assinsert, awardart, awardnames, awardtitles, awardtype
extern awardwinners, awtmap, bannermsg, bannertimer, bgscrollx, bgscrolly, BuildDefaultLines, byte_D42C3
extern byte_D9299, byte_E024C, byte_E024D, byte_E024F, byte_E9AC8, byte_E9AD3, camx, camx_m2
extern camy, cddriveptr, ClearInputQueue, ClearPanelPenalties, clockticks, cont2team, Crowd_Noise, CrowdFadeOut
extern crowdlevel, CrowdNoiseReset, crowdsmooth, cupteam, curleague, curperiod, CwdExciteLvl, deferpending
extern demomode, DrawHudPanel, DrawRinkOverlays, dword_C513C, dword_C5168, dword_C66D0, dword_C66D4, dword_CC080
extern dword_CC0AC, dword_CC0EC, dword_D8C4C, dword_D8C72, dword_D8C7A, dword_DEF8C, dword_E009C, dword_E0244
extern dword_E9A9E, dword_E9AB6, energywarn, escrequest, exitgame, fadeinpending, FadeOutPalCycle, FadePalette
extern FadePalStep, FileClose, fileoncd, FileOpenRead, FitPlayerName, FlushGSumQueue, forceteams, fox
extern foy, fputchar, frameaccum, FreeMemBlock, gameclock, gamemode, gameopts, gameover
extern gamepal, gameresult, GetTicks, gsp, HandleHotKey_ret, hilightfont, hmtmap, HomeTeam
extern hudclockhund, hudclockmin, hudclocksec, hudhundaccum, hudhundstep, inputframes, introskipped, j_unlink_
extern joyq_flush, joysampling, joysampling_save, kaufmfont, lastplayer, lcblink, lcblinktime, lcboxon
extern lcline, lcreqchoice, lcrequest, lcsel, lctimer, leaguedbnames, LoadCupFinalSeries, LoadGameGfx
extern LoadGameState, LoadRink, LoadRockMusic, LoadTeamPalette, MakeGSummaryPath, MakePath, memcpy_, MouseSetPos
extern mousex, mousey, MusicChanReset, musichandle, musicon, musicslot, NormalizeDressFlags, nullsub_2
extern numshapes, numshpbank, off_C524F, off_C5253, off_C5257, off_C525B, off_C525F, off_C5263
extern off_C5267, off_C526F, off_C5273, off_C527B, off_CBED0, ovlseq, ovlstep, ovltimer
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
extern strnicmp_, sub_1B982, sub_6ADA7, sub_6AF52, sub_6AF97, sub_6B008, sub_8CCA8, sub_8D2F0
extern sub_8E83C, sub_8E8A0, sub_8E9C0, sub_8E9E8, sub_8EA00, sub_8EA18, sub_8F13B, sub_8F1FE
extern sub_8F633, sub_8F98F, sub_8FB8E, sub_8FC8A, sub_8FCDF, sub_8FFB0, sub_90354, sub_9035C
extern sub_9061C, sub_90B80, sub_B30B4, sub_B30BB, sub_B392C, sub_B4BA8, teamabbrevs, textline1
extern textline2, textline3, textline4, textline5, threat, TicksSinceLastCall, treeteamnames, unk_C03C4
extern unk_C03C6, unk_D958C, unk_D95C0, unk_D95F4, unk_D9628, unk_D965C, unk_D9690, unk_D96F8
extern unk_D972C, unk_D9794, unk_D98C3, UpdateHudPanel, viewscrollx, viewscrolly, VisTeam, vtoa
extern WaitClickTimeout, WaitDigiSample, word_C90D8, word_CBC44, word_CBC60, word_CBE8C, word_CBE8E, word_CBEC2
extern word_CBEC6, word_CC0B0, word_DEE94, word_E024E, word_E9A9C, word_E9AA2, word_E9AA4, word_E9AA6
extern word_E9AAA, word_E9AAE, word_E9B2C
global PickAwardWinners, PickAwardWinners_x, ShowAwardScreens, DrawAwardsSummary, AwardsCeremony
PickAwardWinners:
push dword 41Ch	; 1205D
call __CHK	; 12062
push ebx	; 12067
push ecx	; 12068
push edx	; 12069
push esi	; 1206A
push edi	; 1206B
push ebp	; 1206C
sub esp, 400h	; 1206D
mov edx, 0FFFFFFFFh	; 12073
mov dword [dword esp+03F8h], edx	; 12078
mov dword [dword esp+03F4h], edx	; 1207F
mov dword [dword esp+03F0h], edx	; 12086
mov ebx, dword [leaguedbnames+10h]	; 1208D
mov ecx, str_extDB	; 12093
mov edx, curleague	; 12098
lea eax, [dword esp+03B8h]	; 1209D
call MakePath	; 120A4
mov ebx, 1	; 120A9
mov edx, treeteamnames	; 120AE
lea eax, [dword esp+03B8h]	; 120B3
call ReadTeamNames	; 120BA
mov ebx, eax	; 120BF
test eax, eax	; 120C1
jne short .1	; 120C3
mov ebx, dword [leaguedbnames+10h]	; 120C5
mov ecx, str_extDB	; 120CB
mov edx, curleague	; 120D0
lea eax, [dword esp+03B8h]	; 120D5
call MakePath	; 120DC
lea edx, [dword esp+03F8h]	; 120E1
lea eax, [dword esp+03B8h]	; 120E8
call FileOpenRead	; 120EF
mov ebx, eax	; 120F4
.1:
test ebx, ebx	; 120F6
jne short .2	; 120F8
mov ebx, dword [leaguedbnames]	; 120FA
mov ecx, str_extDB	; 12100
mov edx, curleague	; 12105
lea eax, [dword esp+03B8h]	; 1210A
call MakePath	; 12111
lea edx, [dword esp+03F4h]	; 12116
lea eax, [dword esp+03B8h]	; 1211D
call FileOpenRead	; 12124
mov ebx, eax	; 12129
.2:
test ebx, ebx	; 1212B
jne short .3	; 1212D
mov ebx, dword [leaguedbnames+14h]	; 1212F
mov ecx, str_extDB	; 12135
mov edx, curleague	; 1213A
lea eax, [dword esp+03B8h]	; 1213F
call MakePath	; 12146
lea edx, [dword esp+03F0h]	; 1214B
lea eax, [dword esp+03B8h]	; 12152
call FileOpenRead	; 12159
mov ebx, eax	; 1215E
.3:
mov ecx, 0Bh	; 12160
xor edx, edx	; 12165
lea eax, [dword esp+03D8h]	; 12167
call __STOSB	; 1216E
xor esi, esi	; 12173
mov dword [dword esp+03FCh], esi	; 12175
jmp near .45	; 1217C
.4:
mov ebx, edi	; 12181
mov edx, esp	; 12183
mov eax, dword [dword esp+03F8h]	; 12185
call ReadTeamRec	; 1218C
mov ebx, eax	; 12191
xor eax, eax	; 12193
mov al, byte [byte esp+029h]	; 12195
add eax, eax	; 12199
movzx ebp, byte [byte esp+02Bh]	; 1219B
add ebp, eax	; 121A0
cmp byte [byte esp+029h], 0	; 121A2
jne short .5	; 121A7
cmp byte [byte esp+02Ah], 0	; 121A9
jne short .5	; 121AE
xor edx, edx	; 121B0
jmp short .6	; 121B2
.5:
xor edx, edx	; 121B4
mov dl, byte [byte esp+029h]	; 121B6
movzx esi, byte [byte esp+02Ah]	; 121BA
add esi, edx	; 121BF
mov eax, edx	; 121C1
shl eax, 2	; 121C3
sub eax, edx	; 121C6
shl eax, 3	; 121C8
add edx, eax	; 121CB
shl edx, 2	; 121CD
mov eax, edx	; 121D0
sar edx, 1Fh	; 121D2
idiv esi	; 121D5
mov edx, eax	; 121D7
.6:
cmp byte [dword esp+03DFh], 0	; 121D9
je short .8	; 121E1
mov eax, dword [dword esp+03ECh]	; 121E3
cmp ebp, eax	; 121EA
jg short .8	; 121EC
jne short .7	; 121EE
cmp edx, dword [dword esp+03E8h]	; 121F0
jg short .8	; 121F7
.7:
cmp ebp, dword [dword esp+03ECh]	; 121F9
jne short .9	; 12200
cmp edx, dword [dword esp+03E8h]	; 12202
jne short .9	; 12209
mov al, byte [byte esp+029h]	; 1220B
cmp al, byte [byte_D9299]	; 1220F
jbe short .9	; 12215
.8:
mov ecx, 0BAh	; 12217
mov edi, presidentsteam	; 1221C
mov esi, esp	; 12221
rep movsd	; 12223
mov dword [dword esp+03ECh], ebp	; 12225
mov dword [dword esp+03E8h], edx	; 1222C
mov byte [dword esp+03DFh], 0FFh	; 12233
.9:
cmp byte [dword esp+03E2h], 0	; 1223B
je short .10	; 12243
xor eax, eax	; 12245
mov al, byte [byte esp+03Bh]	; 12247
cmp eax, dword [dword esp+03E4h]	; 1224B
jle short .11	; 12252
.10:
mov ecx, 0BAh	; 12254
mov edi, cupteam	; 12259
mov esi, esp	; 1225E
rep movsd	; 12260
xor eax, eax	; 12262
mov al, byte [byte esp+03Bh]	; 12264
mov dword [dword esp+03E4h], eax	; 12268
mov byte [dword esp+03E2h], 0FFh	; 1226F
.11:
xor ebp, ebp	; 12277
jmp near .31	; 12279
.12:
mov eax, dword [byte esp+ebp*4+04Ch]	; 1227E
cmp eax, byte 0FFFFFFFFh	; 12282
je near .30	; 12285
mov ebx, eax	; 1228B
lea edx, [dword esp+0354h]	; 1228D
mov eax, dword [dword esp+03F4h]	; 12294
call ReadKeyRec	; 1229B
mov ebx, eax	; 122A0
test eax, eax	; 122A2
jne short .13	; 122A4
mov ebx, dword [dword esp+0380h]	; 122A6
lea edx, [dword esp+0388h]	; 122AD
mov eax, dword [dword esp+03F0h]	; 122B4
call ReadSeasonRec	; 122BB
mov ebx, eax	; 122C0
.13:
test ebx, ebx	; 122C2
jne near .30	; 122C4
cmp word [dword esp+0388h], byte 0	; 122CA
jbe near .30	; 122D3
mov edx, dword [off_C524F]	; 122D9
cmp byte [dword esp+03D8h], 0	; 122DF
je short .14	; 122E7
mov eax, dword [dword esp+038Ah]	; 122E9
mov cx, word [byte edx+02h]	; 122F0
cmp ax, cx	; 122F4
ja short .14	; 122F7
jne short .15	; 122F9
mov eax, dword [dword esp+0388h]	; 122FB
cmp ax, word [edx]	; 12302
jae short .15	; 12305
.14:
mov ecx, 0Dh	; 12307
mov edi, awardwinners	; 1230C
lea esi, [dword esp+0354h]	; 12311
rep movsd	; 12318
mov ecx, 0Bh	; 1231A
mov edi, edx	; 1231F
lea esi, [dword esp+0388h]	; 12321
rep movsd	; 12328
movsw	; 1232A
movsb	; 1232C
mov byte [dword esp+03D8h], 0FFh	; 1232D
.15:
mov edx, dword [off_C5253]	; 12335
cmp byte [dword esp+03D9h], 0	; 1233B
je short .16	; 12343
mov eax, dword [dword esp+038Eh]	; 12345
mov cx, word [byte edx+06h]	; 1234C
cmp ax, cx	; 12350
ja short .16	; 12353
jne short .17	; 12355
mov eax, dword [dword esp+0388h]	; 12357
cmp ax, word [edx]	; 1235E
jae short .17	; 12361
.16:
mov ecx, 0Dh	; 12363
mov edi, unk_D958C	; 12368
lea esi, [dword esp+0354h]	; 1236D
rep movsd	; 12374
mov ecx, 0Bh	; 12376
mov edi, edx	; 1237B
lea esi, [dword esp+0388h]	; 1237D
rep movsd	; 12384
movsw	; 12386
movsb	; 12388
mov byte [dword esp+03D9h], 0FFh	; 12389
.17:
cmp byte [dword esp+0356h], 44h	; 12391
jne short .19	; 12399
mov edx, dword [off_C5257]	; 1239B
cmp byte [dword esp+03DAh], 0	; 123A1
je short .18	; 123A9
mov eax, dword [dword esp+038Eh]	; 123AB
mov cx, word [byte edx+06h]	; 123B2
cmp ax, cx	; 123B6
ja short .18	; 123B9
jne short .19	; 123BB
mov eax, dword [dword esp+0388h]	; 123BD
cmp ax, word [edx]	; 123C4
jae short .19	; 123C7
.18:
mov ecx, 0Dh	; 123C9
mov edi, unk_D95C0	; 123CE
lea esi, [dword esp+0354h]	; 123D3
rep movsd	; 123DA
mov ecx, 0Bh	; 123DC
mov edi, edx	; 123E1
lea esi, [dword esp+0388h]	; 123E3
rep movsd	; 123EA
movsw	; 123EC
movsb	; 123EE
mov byte [dword esp+03DAh], 0FFh	; 123EF
.19:
mov al, byte [dword esp+0356h]	; 123F7
cmp al, 4Ch	; 123FE
je short .20	; 12400
cmp al, 52h	; 12402
je short .20	; 12404
cmp al, 43h	; 12406
jne short .22	; 12408
.20:
mov edx, dword [off_C525B]	; 1240A
cmp byte [dword esp+03DBh], 0	; 12410
je short .21	; 12418
mov eax, dword [dword esp+0398h]	; 1241A
mov cx, word [byte edx+010h]	; 12421
cmp ax, cx	; 12425
jg short .21	; 12428
jne short .22	; 1242A
mov eax, dword [dword esp+0388h]	; 1242C
cmp ax, word [edx]	; 12433
jae short .22	; 12436
.21:
mov ecx, 0Dh	; 12438
mov edi, unk_D95F4	; 1243D
lea esi, [dword esp+0354h]	; 12442
rep movsd	; 12449
mov ecx, 0Bh	; 1244B
mov edi, edx	; 12450
lea esi, [dword esp+0388h]	; 12452
rep movsd	; 12459
movsw	; 1245B
movsb	; 1245D
mov byte [dword esp+03DBh], 0FFh	; 1245E
.22:
cmp byte [dword esp+0356h], 47h	; 12466
je short .24	; 1246E
cmp byte [dword esp+03B6h], 0	; 12470
je short .24	; 12478
mov edx, dword [off_C5267]	; 1247A
cmp byte [dword esp+03DEh], 0	; 12480
je short .23	; 12488
mov eax, dword [dword esp+038Eh]	; 1248A
mov cx, word [byte edx+06h]	; 12491
cmp ax, cx	; 12495
ja short .23	; 12498
jne short .24	; 1249A
mov eax, dword [dword esp+0388h]	; 1249C
cmp ax, word [edx]	; 124A3
jae short .24	; 124A6
.23:
mov ecx, 0Dh	; 124A8
mov edi, unk_D9690	; 124AD
lea esi, [dword esp+0354h]	; 124B2
rep movsd	; 124B9
mov ecx, 0Bh	; 124BB
mov edi, edx	; 124C0
lea esi, [dword esp+0388h]	; 124C2
rep movsd	; 124C9
movsw	; 124CB
movsb	; 124CD
mov byte [dword esp+03DEh], 0FFh	; 124CE
.24:
mov edx, dword [off_C526F]	; 124D6
cmp byte [dword esp+03E0h], 0	; 124DC
je short .25	; 124E4
mov eax, dword [dword esp+03A0h]	; 124E6
mov cx, word [byte edx+018h]	; 124ED
cmp ax, cx	; 124F1
ja short .25	; 124F4
jne short .26	; 124F6
mov eax, dword [dword esp+039Ah]	; 124F8
cmp ax, word [byte edx+012h]	; 124FF
jae short .26	; 12503
.25:
mov ecx, 0Dh	; 12505
mov edi, unk_D96F8	; 1250A
lea esi, [dword esp+0354h]	; 1250F
rep movsd	; 12516
mov ecx, 0Bh	; 12518
mov edi, edx	; 1251D
lea esi, [dword esp+0388h]	; 1251F
rep movsd	; 12526
movsw	; 12528
movsb	; 1252A
mov byte [dword esp+03E0h], 0FFh	; 1252B
.26:
cmp byte [awardtype+9], 1	; 12533
jne short .27	; 1253A
mov edx, dword [off_C5273]	; 1253C
xor esi, esi	; 12542
mov si, word [byte edx+028h]	; 12544
xor eax, eax	; 12548
mov ax, word [byte edx+02Ah]	; 1254A
add esi, eax	; 1254E
xor eax, eax	; 12550
mov ax, word [byte edx+02Ch]	; 12552
jmp short .28	; 12556
.27:
mov edx, dword [off_C5273]	; 12558
xor esi, esi	; 1255E
mov si, word [byte edx+030h]	; 12560
xor eax, eax	; 12564
mov ax, word [byte edx+032h]	; 12566
add eax, esi	; 1256A
xor esi, esi	; 1256C
mov si, word [byte edx+034h]	; 1256E
.28:
add eax, esi	; 12572
mov cx, word [edx]	; 12574
xor edx, edx	; 12577
mov dx, word [dword esp+03B0h]	; 12579
xor esi, esi	; 12581
mov si, word [dword esp+03B2h]	; 12583
add edx, esi	; 1258B
xor esi, esi	; 1258D
mov si, word [dword esp+03B4h]	; 1258F
add edx, esi	; 12597
cmp byte [dword esp+03E1h], 0	; 12599
je short .29	; 125A1
cmp edx, eax	; 125A3
jg short .29	; 125A5
jne short .30	; 125A7
cmp cx, word [dword esp+0388h]	; 125A9
jbe short .30	; 125B1
.29:
mov ecx, 0Dh	; 125B3
mov edi, unk_D972C	; 125B8
lea esi, [dword esp+0354h]	; 125BD
rep movsd	; 125C4
mov ecx, 0Bh	; 125C6
mov edi, unk_D98C3	; 125CB
lea esi, [dword esp+0388h]	; 125D0
rep movsd	; 125D7
movsw	; 125D9
movsb	; 125DB
mov dword [off_C5273], unk_D98C3	; 125DC
mov byte [awardtype+9], 1	; 125E6
mov byte [dword esp+03E1h], 0FFh	; 125ED
.30:
inc ebp	; 125F5
.31:
cmp ebp, byte 19h	; 125F6
jge short .32	; 125F9
test ebx, ebx	; 125FB
je near PickAwardWinners.12	; 125FD
.32:
xor ebp, ebp	; 12603
jmp near .43	; 12605
.33:
mov eax, dword [dword esp+ebp*4+0B0h]	; 1260A
cmp eax, byte 0FFFFFFFFh	; 12611
je near .42	; 12614
mov ebx, eax	; 1261A
lea edx, [dword esp+0320h]	; 1261C
mov eax, dword [dword esp+03F4h]	; 12623
call ReadKeyRec	; 1262A
mov ebx, eax	; 1262F
test eax, eax	; 12631
jne short .34	; 12633
mov ebx, dword [dword esp+034Ch]	; 12635
lea edx, [dword esp+02E8h]	; 1263C
mov eax, dword [dword esp+03F0h]	; 12643
call ReadGoalieSeasonRec	; 1264A
mov ebx, eax	; 1264F
.34:
test ebx, ebx	; 12651
jne near .42	; 12653
cmp word [dword esp+02E8h], byte 0	; 12659
jbe near .42	; 12662
mov edx, dword [off_C525F]	; 12668
cmp byte [dword esp+03DCh], 0	; 1266E
je short .35	; 12676
mov eax, dword [dword esp+02EAh]	; 12678
mov cx, word [byte edx+02h]	; 1267F
cmp ax, cx	; 12683
ja short .35	; 12686
jne short .36	; 12688
mov eax, dword [dword esp+02FCh]	; 1268A
cmp ax, word [byte edx+014h]	; 12691
jbe short .36	; 12695
.35:
mov ecx, 0Dh	; 12697
mov edi, unk_D9628	; 1269C
lea esi, [dword esp+0320h]	; 126A1
rep movsd	; 126A8
mov ecx, 0Dh	; 126AA
mov edi, edx	; 126AF
lea esi, [dword esp+02E8h]	; 126B1
rep movsd	; 126B8
movsw	; 126BA
mov byte [dword esp+03DCh], 0FFh	; 126BC
.36:
mov edx, dword [off_C5263]	; 126C4
cmp word [dword esp+02E8h], byte 19h	; 126CA
jb short .38	; 126D3
cmp byte [dword esp+03DDh], 0	; 126D5
je short .37	; 126DD
mov eax, dword [dword esp+02F8h]	; 126DF
mov cx, word [byte edx+010h]	; 126E6
cmp ax, cx	; 126EA
jb short .37	; 126ED
jne short .38	; 126EF
mov eax, dword [dword esp+02F4h]	; 126F1
cmp ax, word [byte edx+0Ch]	; 126F8
jbe short .38	; 126FC
.37:
mov ecx, 0Dh	; 126FE
mov edi, unk_D965C	; 12703
lea esi, [dword esp+0320h]	; 12708
rep movsd	; 1270F
mov ecx, 0Dh	; 12711
mov edi, edx	; 12716
lea esi, [dword esp+02E8h]	; 12718
rep movsd	; 1271F
movsw	; 12721
mov byte [dword esp+03DDh], 0FFh	; 12723
.38:
cmp byte [awardtype+9], 1	; 1272B
jne short .39	; 12732
mov edx, dword [off_C5273]	; 12734
xor esi, esi	; 1273A
mov si, word [byte edx+028h]	; 1273C
xor eax, eax	; 12740
mov ax, word [byte edx+02Ah]	; 12742
add eax, esi	; 12746
xor esi, esi	; 12748
mov si, word [byte edx+02Ch]	; 1274A
jmp short .40	; 1274E
.39:
mov edx, dword [off_C5273]	; 12750
xor esi, esi	; 12756
mov si, word [byte edx+030h]	; 12758
xor eax, eax	; 1275C
mov ax, word [byte edx+032h]	; 1275E
add esi, eax	; 12762
xor eax, eax	; 12764
mov ax, word [byte edx+034h]	; 12766
.40:
add eax, esi	; 1276A
mov cx, word [edx]	; 1276C
xor esi, esi	; 1276F
mov si, word [dword esp+0318h]	; 12771
xor edx, edx	; 12779
mov dx, word [dword esp+031Ah]	; 1277B
add esi, edx	; 12783
xor edx, edx	; 12785
mov dx, word [dword esp+031Ch]	; 12787
add edx, esi	; 1278F
cmp byte [dword esp+03E1h], 0	; 12791
je short .41	; 12799
cmp edx, eax	; 1279B
jg short .41	; 1279D
jne short .42	; 1279F
cmp cx, word [dword esp+02E8h]	; 127A1
jbe short .42	; 127A9
.41:
mov ecx, 0Dh	; 127AB
mov edi, unk_D972C	; 127B0
lea esi, [dword esp+0354h]	; 127B5
rep movsd	; 127BC
mov ecx, 0Dh	; 127BE
mov edi, unk_D9794	; 127C3
lea esi, [dword esp+02E8h]	; 127C8
rep movsd	; 127CF
movsw	; 127D1
mov dword [off_C5273], unk_D9794	; 127D3
xor cl, cl	; 127DD
mov byte [awardtype+9], cl	; 127DF
mov byte [dword esp+03E1h], 0FFh	; 127E5
.42:
inc ebp	; 127ED
.43:
cmp ebp, byte 3	; 127EE
jge short .44	; 127F1
test ebx, ebx	; 127F3
je near PickAwardWinners.33	; 127F5
.44:
inc dword [dword esp+03FCh]	; 127FB
.45:
mov edi, dword [dword esp+03FCh]	; 12802
cmp edi, byte 1Ah	; 12809
jge short .46	; 1280C
test ebx, ebx	; 1280E
je near PickAwardWinners.4	; 12810
.46:
lea eax, [dword esp+03F0h]	; 12816
call FileClose	; 1281D
lea eax, [dword esp+03F4h]	; 12822
call FileClose	; 12829
lea eax, [dword esp+03F8h]	; 1282E
call FileClose	; 12835
mov eax, ebx	; 1283A
add esp, 400h	; 1283C
PickAwardWinners_x:
pop ebp	; 12842
pop edi	; 12843
pop esi	; 12844
pop edx	; 12845
pop ecx	; 12846
pop ebx	; 12847
ret	; 12848
; C: src/front/awards/PickAwardWinners.c (ShowAwardScreens)
%ifdef CBUILD
%include "c/front/awards/PickAwardWinners.ShowAwardScreens.inc"
%else
ShowAwardScreens:
push dword 6Ch	; 12849
call __CHK	; 1284E
push ebx	; 12853
push ecx	; 12854
push edx	; 12855
push esi	; 12856
push edi	; 12857
push ebp	; 12858
sub esp, byte 40h	; 12859
xor edi, edi	; 1285C
call ClearInputQueue	; 1285E
mov dword [byte esp+038h], edi	; 12863
jmp near .27	; 12867
.1:
mov esi, ebx	; 1286C
mov eax, dword [nosplit ebx*4+dword_C513C]	; 1286E
xor edx, edx	; 12875
call SetTextColors	; 12877
call GetTicks	; 1287C
xor ecx, ecx	; 12881
mov ebx, dword [nosplit esi*4+awardart]	; 12883
mov eax, dword [nosplit esi*4+dword_C5168]	; 1288A
cmp byte [dword eax+fileoncd], 1	; 12891
jne short .2	; 12898
mov edx, dword [cddriveptr]	; 1289A
jmp short .3	; 128A0
.2:
xor edx, edx	; 128A2
.3:
mov eax, esp	; 128A4
call MakePath	; 128A6
push byte 0	; 128AB
lea eax, [byte esp+04h]	; 128AD
push eax	; 128B1
call sub_8E83C	; 128B2
add esp, byte 8	; 128B7
mov dword [byte esp+02Ch], eax	; 128BA
push byte 1	; 128BE
push eax	; 128C0
call sub_9035C	; 128C1
add esp, byte 8	; 128C6
push eax	; 128C9
call sub_9061C	; 128CA
add esp, byte 4	; 128CF
mov ebp, 76h	; 128D2
mov eax, dword [byte esp+038h]	; 128D7
cmp byte [dword eax+awardtype], 2	; 128DB
jne near .13	; 128E2
cmp eax, byte 0Ah	; 128E8
jne short .4	; 128EB
mov edx, cupteam	; 128ED
jmp short .5	; 128F2
.4:
mov edx, presidentsteam	; 128F4
.5:
mov eax, esp	; 128F9
call strcpy_	; 128FB
mov ebx, 3	; 12900
mov edx, str_ANA	; 12905
mov eax, esp	; 1290A
call strnicmp_	; 1290C
test eax, eax	; 12911
jne short .7	; 12913
push str_MightyDucks	; 12915
call fputchar	; 1291A
add esp, byte 4	; 1291F
sar eax, 1	; 12922
mov esi, 1FEh	; 12924
sub esi, eax	; 12929
mov ebx, str_MightyDucks	; 1292B
.6:
mov edx, ebp	; 12930
mov eax, esi	; 12932
call PrintShadowText	; 12934
jmp near .25	; 12939
.7:
cmp dword [byte esp+038h], byte 0Ah	; 1293E
jne short .8	; 12943
mov edx, cupteam+5	; 12945
jmp short .9	; 1294A
.8:
mov edx, presidentsteam+5	; 1294C
.9:
mov eax, esp	; 12951
call strcpy_	; 12953
mov ebx, 3	; 12958
mov edx, str_Cal	; 1295D
mov eax, esp	; 12962
call strnicmp_	; 12964
test eax, eax	; 12969
je short .10	; 1296B
mov ebx, 3	; 1296D
mov edx, str_Flo	; 12972
mov eax, esp	; 12977
call strnicmp_	; 12979
test eax, eax	; 1297E
jne short .11	; 12980
.10:
mov edx, unk_C03C4	; 12982
jmp short .12	; 12987
.11:
mov edx, unk_C03C6	; 12989
.12:
mov eax, esp	; 1298E
call strcat_	; 12990
mov eax, esp	; 12995
push eax	; 12997
call fputchar	; 12998
add esp, byte 4	; 1299D
sar eax, 1	; 129A0
mov esi, 1FEh	; 129A2
sub esi, eax	; 129A7
mov ebx, esp	; 129A9
jmp short ShowAwardScreens.6	; 129AB
.13:
mov edi, eax	; 129AD
shl edi, 2	; 129AF
sub edi, eax	; 129B2
shl edi, 2	; 129B4
add edi, eax	; 129B7
shl edi, 2	; 129B9
mov eax, awardwinners	; 129BC
add eax, edi	; 129C1
lea edx, [byte eax+013h]	; 129C3
push edx	; 129C6
add eax, byte 3	; 129C7
push eax	; 129CA
push str_SS	; 129CB
lea eax, [byte esp+0Ch]	; 129D0
push eax	; 129D4
call sprintf_	; 129D5
add esp, byte 10h	; 129DA
mov eax, esp	; 129DD
push eax	; 129DF
call fputchar	; 129E0
add esp, byte 4	; 129E5
sar eax, 1	; 129E8
mov esi, 1FEh	; 129EA
sub esi, eax	; 129EF
mov ebx, esp	; 129F1
mov edx, ebp	; 129F3
mov eax, esi	; 129F5
call PrintShadowText	; 129F7
xor edx, edx	; 129FC
mov dl, byte [dword edi+awardwinners]	; 129FE
mov eax, edx	; 12A04
shl eax, 2	; 12A06
add eax, edx	; 12A09
shl eax, 2	; 12A0B
add eax, edx	; 12A0E
mov edx, treeteamnames	; 12A10
add edx, eax	; 12A15
mov eax, esp	; 12A17
call strcpy_	; 12A19
mov ebx, 3	; 12A1E
mov edx, str_ANA	; 12A23
mov eax, esp	; 12A28
call strnicmp_	; 12A2A
test eax, eax	; 12A2F
jne short .14	; 12A31
mov ecx, 6	; 12A33
mov edi, esp	; 12A38
mov esi, str_MightyDucks	; 12A3A
rep movsd	; 12A3F
movsb	; 12A41
jmp short .18	; 12A42
.14:
mov bl, byte [dword edi+awardwinners]	; 12A44
cmp bl, 2	; 12A4A
je short .15	; 12A4D
cmp bl, 18h	; 12A4F
je short .15	; 12A52
cmp bl, 19h	; 12A54
jne short .16	; 12A57
.15:
mov edx, unk_C03C4	; 12A59
jmp short .17	; 12A5E
.16:
mov edx, unk_C03C6	; 12A60
.17:
mov eax, esp	; 12A65
call strcat_	; 12A67
.18:
mov eax, esp	; 12A6C
push eax	; 12A6E
call fputchar	; 12A6F
add esp, byte 4	; 12A74
sar eax, 1	; 12A77
mov esi, 1FEh	; 12A79
sub esi, eax	; 12A7E
xor eax, eax	; 12A80
mov al, byte [byte_D42C3]	; 12A82
add ebp, eax	; 12A87
mov ebx, esp	; 12A89
mov edx, ebp	; 12A8B
mov eax, esi	; 12A8D
call PrintShadowText	; 12A8F
mov esi, 1A4h	; 12A94
add ebp, byte 2Ch	; 12A99
mov edi, dword [byte esp+038h]	; 12A9C
shl edi, 2	; 12AA0
mov eax, dword [byte esp+038h]	; 12AA3
mov ch, byte [dword eax+awardtype]	; 12AA7
test ch, ch	; 12AAD
jne near .21	; 12AAF
mov ebx, str_GP	; 12AB5
mov edx, ebp	; 12ABA
mov eax, esi	; 12ABC
call PrintShadowText	; 12ABE
xor edx, edx	; 12AC3
mov dl, byte [byte_D42C3]	; 12AC5
add edx, ebp	; 12ACB
mov ebx, str_Min	; 12ACD
mov eax, esi	; 12AD2
call PrintShadowText	; 12AD4
xor edx, edx	; 12AD9
mov dl, byte [byte_D42C3]	; 12ADB
add edx, edx	; 12AE1
add edx, ebp	; 12AE3
mov ebx, str_GAA	; 12AE5
mov eax, esi	; 12AEA
call PrintShadowText	; 12AEC
xor edx, edx	; 12AF1
mov dl, byte [byte_D42C3]	; 12AF3
mov eax, edx	; 12AF9
shl eax, 2	; 12AFB
sub eax, edx	; 12AFE
lea edx, [eax+ebp]	; 12B00
mov ebx, str_W	; 12B03
mov eax, esi	; 12B08
call PrintShadowText	; 12B0A
xor eax, eax	; 12B0F
mov al, byte [byte_D42C3]	; 12B11
shl eax, 2	; 12B16
lea edx, [eax+ebp]	; 12B19
mov ebx, str_L	; 12B1C
mov eax, esi	; 12B21
call PrintShadowText	; 12B23
xor edx, edx	; 12B28
mov dl, byte [byte_D42C3]	; 12B2A
mov eax, edx	; 12B30
shl eax, 2	; 12B32
add eax, edx	; 12B35
lea edx, [eax+ebp]	; 12B37
mov ebx, str_T	; 12B3A
mov eax, esi	; 12B3F
call PrintShadowText	; 12B41
xor edx, edx	; 12B46
mov dl, byte [byte_D42C3]	; 12B48
mov eax, edx	; 12B4E
shl eax, 2	; 12B50
sub eax, edx	; 12B53
add eax, eax	; 12B55
lea edx, [eax+ebp]	; 12B57
mov ebx, str_SO	; 12B5A
mov eax, esi	; 12B5F
call PrintShadowText	; 12B61
xor edx, edx	; 12B66
mov dl, byte [byte_D42C3]	; 12B68
mov eax, edx	; 12B6E
shl eax, 3	; 12B70
sub eax, edx	; 12B73
lea edx, [eax+ebp]	; 12B75
mov ebx, str_EN	; 12B78
mov eax, esi	; 12B7D
call PrintShadowText	; 12B7F
xor edx, edx	; 12B84
mov dl, byte [byte_D42C3]	; 12B86
shl edx, 3	; 12B8C
add edx, ebp	; 12B8F
mov ebx, str_Shots	; 12B91
mov eax, esi	; 12B96
call PrintShadowText	; 12B98
xor edx, edx	; 12B9D
mov dl, byte [byte_D42C3]	; 12B9F
mov eax, edx	; 12BA5
shl eax, 3	; 12BA7
add eax, edx	; 12BAA
lea edx, [eax+ebp]	; 12BAC
mov ebx, str_Pct	; 12BAF
mov eax, esi	; 12BB4
call PrintShadowText	; 12BB6
mov eax, dword [dword edi+off_C524F]	; 12BBB
mov dword [byte esp+034h], eax	; 12BC1
mov edi, eax	; 12BC5
xor eax, eax	; 12BC7
mov dword [byte esp+03Ch], eax	; 12BC9
.19:
mov eax, dword [byte esp+03Ch]	; 12BCD
mov ebx, dword [nosplit eax*4+off_C527B]	; 12BD1
xor edx, edx	; 12BD8
mov dl, byte [byte_D42C3]	; 12BDA
lea eax, [byte esi+034h]	; 12BE0
mov ecx, ebp	; 12BE3
sub ecx, edx	; 12BE5
mov edx, ecx	; 12BE7
add esi, byte 50h	; 12BE9
call PrintShadowText	; 12BEC
xor ecx, ecx	; 12BF1
mov cx, word [edi]	; 12BF3
mov ebx, str_fmtpd	; 12BF6
mov edx, ebp	; 12BFB
mov eax, esi	; 12BFD
call PrintFmt1	; 12BFF
xor ecx, ecx	; 12C04
mov cx, word [byte edi+0Ch]	; 12C06
xor edx, edx	; 12C0A
mov dl, byte [byte_D42C3]	; 12C0C
add edx, ebp	; 12C12
mov ebx, str_fmtpd	; 12C14
mov eax, esi	; 12C19
call PrintFmt1	; 12C1B
xor ebx, ebx	; 12C20
mov bx, word [byte edi+010h]	; 12C22
mov ecx, 64h	; 12C26
mov eax, ebx	; 12C2B
mov edx, ebx	; 12C2D
sar edx, 1Fh	; 12C2F
idiv ecx	; 12C32
push edx	; 12C34
mov eax, ebx	; 12C35
mov edx, ebx	; 12C37
sar edx, 1Fh	; 12C39
idiv ecx	; 12C3C
xor edx, edx	; 12C3E
mov dl, byte [byte_D42C3]	; 12C40
add edx, edx	; 12C46
add edx, ebp	; 12C48
mov ecx, eax	; 12C4A
mov ebx, str_D02d	; 12C4C
mov eax, esi	; 12C51
call PrintFmt2	; 12C53
xor ecx, ecx	; 12C58
mov cx, word [byte edi+02h]	; 12C5A
xor edx, edx	; 12C5E
mov dl, byte [byte_D42C3]	; 12C60
mov eax, edx	; 12C66
shl eax, 2	; 12C68
sub eax, edx	; 12C6B
lea edx, [eax+ebp]	; 12C6D
mov ebx, str_fmtpd	; 12C70
mov eax, esi	; 12C75
call PrintFmt1	; 12C77
xor ecx, ecx	; 12C7C
mov cx, word [byte edi+04h]	; 12C7E
xor edx, edx	; 12C82
mov dl, byte [byte_D42C3]	; 12C84
shl edx, 2	; 12C8A
add edx, ebp	; 12C8D
mov ebx, str_fmtpd	; 12C8F
mov eax, esi	; 12C94
call PrintFmt1	; 12C96
mov edx, dword [byte esp+03Ch]	; 12C9B
test edx, edx	; 12C9F
jne short .20	; 12CA1
xor ecx, ecx	; 12CA3
mov cx, word [byte edi+06h]	; 12CA5
mov dl, byte [byte_D42C3]	; 12CA9
mov eax, edx	; 12CAF
shl eax, 2	; 12CB1
add eax, edx	; 12CB4
lea edx, [eax+ebp]	; 12CB6
mov ebx, str_fmtpd	; 12CB9
mov eax, esi	; 12CBE
call PrintFmt1	; 12CC0
.20:
xor ecx, ecx	; 12CC5
mov cx, word [byte edi+08h]	; 12CC7
xor edx, edx	; 12CCB
mov dl, byte [byte_D42C3]	; 12CCD
mov eax, edx	; 12CD3
shl eax, 2	; 12CD5
sub eax, edx	; 12CD8
add eax, eax	; 12CDA
lea edx, [eax+ebp]	; 12CDC
mov ebx, str_fmtpd	; 12CDF
mov eax, esi	; 12CE4
call PrintFmt1	; 12CE6
xor ecx, ecx	; 12CEB
mov cx, word [byte edi+0Ah]	; 12CED
xor edx, edx	; 12CF1
mov dl, byte [byte_D42C3]	; 12CF3
mov eax, edx	; 12CF9
shl eax, 3	; 12CFB
sub eax, edx	; 12CFE
lea edx, [eax+ebp]	; 12D00
mov ebx, str_fmtpd	; 12D03
mov eax, esi	; 12D08
call PrintFmt1	; 12D0A
xor ecx, ecx	; 12D0F
mov cx, word [byte edi+012h]	; 12D11
xor edx, edx	; 12D15
mov dl, byte [byte_D42C3]	; 12D17
shl edx, 3	; 12D1D
add edx, ebp	; 12D20
mov ebx, str_fmtpd	; 12D22
mov eax, esi	; 12D27
call PrintFmt1	; 12D29
xor ebx, ebx	; 12D2E
mov bx, word [byte edi+014h]	; 12D30
mov ecx, 0Ah	; 12D34
mov eax, ebx	; 12D39
mov edx, ebx	; 12D3B
sar edx, 1Fh	; 12D3D
idiv ecx	; 12D40
push edx	; 12D42
mov eax, ebx	; 12D43
mov edx, ebx	; 12D45
sar edx, 1Fh	; 12D47
idiv ecx	; 12D4A
mov ecx, eax	; 12D4C
xor edx, edx	; 12D4E
mov dl, byte [byte_D42C3]	; 12D50
mov eax, edx	; 12D56
shl eax, 3	; 12D58
add eax, edx	; 12D5B
lea edx, [eax+ebp]	; 12D5D
mov ebx, str_D01d	; 12D60
mov eax, esi	; 12D65
call PrintFmt2	; 12D67
mov edi, dword [byte esp+034h]	; 12D6C
add edi, byte 16h	; 12D70
mov ebx, dword [byte esp+03Ch]	; 12D73
inc ebx	; 12D77
mov dword [byte esp+03Ch], ebx	; 12D78
cmp ebx, byte 2	; 12D7C
jl near ShowAwardScreens.19	; 12D7F
jmp near .25	; 12D85
.21:
cmp ch, 1	; 12D8A
jne near .25	; 12D8D
mov ebx, str_GP	; 12D93
mov edx, ebp	; 12D98
mov eax, esi	; 12D9A
call PrintShadowText	; 12D9C
xor edx, edx	; 12DA1
mov dl, byte [byte_D42C3]	; 12DA3
add edx, ebp	; 12DA9
mov ebx, str_G	; 12DAB
mov eax, esi	; 12DB0
call PrintShadowText	; 12DB2
xor edx, edx	; 12DB7
mov dl, byte [byte_D42C3]	; 12DB9
add edx, edx	; 12DBF
add edx, ebp	; 12DC1
mov ebx, str_A	; 12DC3
mov eax, esi	; 12DC8
call PrintShadowText	; 12DCA
xor edx, edx	; 12DCF
mov dl, byte [byte_D42C3]	; 12DD1
mov eax, edx	; 12DD7
shl eax, 2	; 12DD9
sub eax, edx	; 12DDC
lea edx, [eax+ebp]	; 12DDE
mov ebx, str_Pt	; 12DE1
mov eax, esi	; 12DE6
call PrintShadowText	; 12DE8
xor edx, edx	; 12DED
mov dl, byte [byte_D42C3]	; 12DEF
shl edx, 2	; 12DF5
add edx, ebp	; 12DF8
mov ebx, str_PIM	; 12DFA
mov eax, esi	; 12DFF
call PrintShadowText	; 12E01
xor edx, edx	; 12E06
mov dl, byte [byte_D42C3]	; 12E08
mov eax, edx	; 12E0E
shl eax, 2	; 12E10
add eax, edx	; 12E13
lea edx, [eax+ebp]	; 12E15
mov ebx, str_PlusMinus	; 12E18
mov eax, esi	; 12E1D
call PrintShadowText	; 12E1F
xor edx, edx	; 12E24
mov dl, byte [byte_D42C3]	; 12E26
mov eax, edx	; 12E2C
shl eax, 2	; 12E2E
sub eax, edx	; 12E31
add eax, eax	; 12E33
lea edx, [eax+ebp]	; 12E35
mov ebx, str_PPG	; 12E38
mov eax, esi	; 12E3D
call PrintShadowText	; 12E3F
xor edx, edx	; 12E44
mov dl, byte [byte_D42C3]	; 12E46
mov eax, edx	; 12E4C
shl eax, 3	; 12E4E
sub eax, edx	; 12E51
lea edx, [eax+ebp]	; 12E53
mov ebx, str_SHG	; 12E56
mov eax, esi	; 12E5B
call PrintShadowText	; 12E5D
xor edx, edx	; 12E62
mov dl, byte [byte_D42C3]	; 12E64
shl edx, 3	; 12E6A
add edx, ebp	; 12E6D
mov ebx, str_Shots	; 12E6F
mov eax, esi	; 12E74
call PrintShadowText	; 12E76
xor edx, edx	; 12E7B
mov dl, byte [byte_D42C3]	; 12E7D
mov eax, edx	; 12E83
shl eax, 3	; 12E85
add eax, edx	; 12E88
lea edx, [eax+ebp]	; 12E8A
mov ebx, str_Pct	; 12E8D
mov eax, esi	; 12E92
call PrintShadowText	; 12E94
mov eax, dword [dword edi+off_C524F]	; 12E99
mov dword [byte esp+030h], eax	; 12E9F
mov edi, eax	; 12EA3
xor ecx, ecx	; 12EA5
mov dword [byte esp+03Ch], ecx	; 12EA7
.22:
mov eax, dword [byte esp+03Ch]	; 12EAB
mov ebx, dword [nosplit eax*4+off_C527B]	; 12EAF
xor edx, edx	; 12EB6
mov dl, byte [byte_D42C3]	; 12EB8
lea eax, [byte esi+034h]	; 12EBE
mov ecx, ebp	; 12EC1
sub ecx, edx	; 12EC3
mov edx, ecx	; 12EC5
add esi, byte 50h	; 12EC7
call PrintShadowText	; 12ECA
xor ecx, ecx	; 12ECF
mov cx, word [edi]	; 12ED1
mov ebx, str_fmtpd	; 12ED4
mov edx, ebp	; 12ED9
mov eax, esi	; 12EDB
call PrintFmt1	; 12EDD
xor ecx, ecx	; 12EE2
mov cx, word [byte edi+02h]	; 12EE4
xor edx, edx	; 12EE8
mov dl, byte [byte_D42C3]	; 12EEA
add edx, ebp	; 12EF0
mov ebx, str_fmtpd	; 12EF2
mov eax, esi	; 12EF7
call PrintFmt1	; 12EF9
xor ecx, ecx	; 12EFE
mov cx, word [byte edi+04h]	; 12F00
xor eax, eax	; 12F04
mov al, byte [byte_D42C3]	; 12F06
add eax, eax	; 12F0B
lea edx, [eax+ebp]	; 12F0D
mov ebx, str_fmtpd	; 12F10
mov eax, esi	; 12F15
call PrintFmt1	; 12F17
xor ecx, ecx	; 12F1C
mov cx, word [byte edi+06h]	; 12F1E
xor edx, edx	; 12F22
mov dl, byte [byte_D42C3]	; 12F24
mov eax, edx	; 12F2A
shl eax, 2	; 12F2C
sub eax, edx	; 12F2F
lea edx, [eax+ebp]	; 12F31
mov ebx, str_fmtpd	; 12F34
mov eax, esi	; 12F39
call PrintFmt1	; 12F3B
xor ecx, ecx	; 12F40
mov cx, word [byte edi+0Ch]	; 12F42
xor edx, edx	; 12F46
mov dl, byte [byte_D42C3]	; 12F48
shl edx, 2	; 12F4E
add edx, ebp	; 12F51
mov ebx, str_fmtpd	; 12F53
mov eax, esi	; 12F58
call PrintFmt1	; 12F5A
mov ecx, dword [byte edi+0Eh]	; 12F5F
sar ecx, 10h	; 12F62
xor edx, edx	; 12F65
mov dl, byte [byte_D42C3]	; 12F67
mov eax, edx	; 12F6D
shl eax, 2	; 12F6F
add eax, edx	; 12F72
lea edx, [eax+ebp]	; 12F74
mov ebx, str_fmtpd	; 12F77
mov eax, esi	; 12F7C
call PrintFmt1	; 12F7E
xor ecx, ecx	; 12F83
mov cx, word [byte edi+08h]	; 12F85
xor edx, edx	; 12F89
mov dl, byte [byte_D42C3]	; 12F8B
mov eax, edx	; 12F91
shl eax, 2	; 12F93
sub eax, edx	; 12F96
add eax, eax	; 12F98
lea edx, [eax+ebp]	; 12F9A
mov ebx, str_fmtpd	; 12F9D
mov eax, esi	; 12FA2
call PrintFmt1	; 12FA4
xor ecx, ecx	; 12FA9
mov cx, word [byte edi+0Ah]	; 12FAB
xor edx, edx	; 12FAF
mov dl, byte [byte_D42C3]	; 12FB1
mov eax, edx	; 12FB7
shl eax, 3	; 12FB9
sub eax, edx	; 12FBC
lea edx, [eax+ebp]	; 12FBE
mov ebx, str_fmtpd	; 12FC1
mov eax, esi	; 12FC6
call PrintFmt1	; 12FC8
xor ecx, ecx	; 12FCD
mov cx, word [byte edi+0Eh]	; 12FCF
xor eax, eax	; 12FD3
mov al, byte [byte_D42C3]	; 12FD5
shl eax, 3	; 12FDA
lea edx, [eax+ebp]	; 12FDD
mov ebx, str_fmtpd	; 12FE0
mov eax, esi	; 12FE5
call PrintFmt1	; 12FE7
cmp word [byte edi+0Eh], byte 0	; 12FEC
je short .23	; 12FF1
xor edx, edx	; 12FF3
mov dx, word [byte edi+02h]	; 12FF5
mov ecx, edx	; 12FF9
shl ecx, 5	; 12FFB
sub ecx, edx	; 12FFE
shl ecx, 2	; 13000
add ecx, edx	; 13003
shl ecx, 3	; 13005
xor ebx, ebx	; 13008
mov bx, word [byte edi+0Eh]	; 1300A
mov eax, ebx	; 1300E
mov edx, ebx	; 13010
sar edx, 1Fh	; 13012
LD sub, eax, edx	; 13015
sar eax, 1	; 13017
lea edx, [ecx+eax]	; 13019
mov eax, edx	; 1301C
sar edx, 1Fh	; 1301E
idiv ebx	; 13021
mov edi, eax	; 13023
jmp short .24	; 13025
.23:
xor edi, edi	; 13027
.24:
mov ebx, 0Ah	; 13029
mov eax, edi	; 1302E
mov edx, edi	; 13030
sar edx, 1Fh	; 13032
idiv ebx	; 13035
push edx	; 13037
mov eax, edi	; 13038
mov edx, edi	; 1303A
sar edx, 1Fh	; 1303C
idiv ebx	; 1303F
mov ecx, eax	; 13041
xor edx, edx	; 13043
mov dl, byte [byte_D42C3]	; 13045
mov eax, edx	; 1304B
shl eax, 3	; 1304D
add eax, edx	; 13050
lea edx, [eax+ebp]	; 13052
mov ebx, str_D01d	; 13055
mov eax, esi	; 1305A
call PrintFmt2	; 1305C
mov edi, dword [byte esp+030h]	; 13061
add edi, byte 12h	; 13065
mov ecx, dword [byte esp+03Ch]	; 13068
inc ecx	; 1306C
mov dword [byte esp+03Ch], ecx	; 1306D
cmp ecx, byte 2	; 13071
jl near ShowAwardScreens.22	; 13074
.25:
mov ebp, 1BAh	; 1307A
mov edi, dword [byte esp+038h]	; 1307F
shl edi, 3	; 13083
mov esi, dword [dword edi+awardtitles+4]	; 13086
test esi, esi	; 1308C
je short .26	; 1308E
push esi	; 13090
call fputchar	; 13091
add esp, byte 4	; 13096
sar eax, 1	; 13099
mov esi, 1FEh	; 1309B
sub esi, eax	; 130A0
mov ebx, dword [dword edi+awardtitles+4]	; 130A2
mov edx, ebp	; 130A8
mov eax, esi	; 130AA
call PrintShadowText	; 130AC
movzx ebp, byte [byte_D42C3]	; 130B1
mov eax, 1BAh	; 130B8
sub eax, ebp	; 130BD
mov ebp, eax	; 130BF
.26:
mov edi, dword [byte esp+038h]	; 130C1
mov eax, dword [nosplit edi*8+awardtitles]	; 130C5
push eax	; 130CC
call fputchar	; 130CD
add esp, byte 4	; 130D2
sar eax, 1	; 130D5
mov esi, 1FEh	; 130D7
sub esi, eax	; 130DC
mov ebx, dword [nosplit edi*8+awardtitles]	; 130DE
mov edx, ebp	; 130E5
mov eax, esi	; 130E7
call PrintShadowText	; 130E9
push str_Pal3	; 130EE
mov edx, dword [byte esp+030h]	; 130F3
push edx	; 130F7
call sub_B30B4	; 130F8
add esp, byte 8	; 130FD
lea edx, [byte eax+010h]	; 13100
mov ebx, 10h	; 13103
xor eax, eax	; 13108
call FadePalStep	; 1310A
mov ebx, dword [byte esp+02Ch]	; 1310F
push ebx	; 13113
call FreeMemBlock	; 13114
add esp, byte 4	; 13119
mov eax, 2710h	; 1311C
call WaitClickTimeout	; 13121
mov edi, eax	; 13126
push byte 0	; 13128
push dword 300h	; 1312A
push str_Palmem	; 1312F
call sub_8CCA8	; 13134
mov esi, eax	; 13139
add esp, byte 0Ch	; 1313B
push eax	; 1313E
push dword 100h	; 1313F
push byte 0	; 13144
call sub_8FFB0	; 13146
add esp, byte 0Ch	; 1314B
mov ebx, 10h	; 1314E
mov edx, esi	; 13153
mov eax, 1	; 13155
call FadePalStep	; 1315A
push esi	; 1315F
call FreeMemBlock	; 13160
add esp, byte 4	; 13165
inc dword [byte esp+038h]	; 13168
.27:
mov ebx, dword [byte esp+038h]	; 1316C
cmp ebx, byte 0Bh	; 13170
jge short .28	; 13173
cmp edi, byte 3	; 13175
jne near ShowAwardScreens.1	; 13178
.28:
mov eax, edi	; 1317E
add esp, byte 40h	; 13180
jmp near PickAwardWinners_x	; 13183
%endif ; C
DrawAwardsSummary:
push dword 4Ch	; 13188
call __CHK	; 1318D
push ebx	; 13192
push ecx	; 13193
push edx	; 13194
push esi	; 13195
push edi	; 13196
push ebp	; 13197
sub esp, byte 30h	; 13198
xor edx, edx	; 1319B
mov dword [byte esp+02Ch], edx	; 1319D
.1:
mov esi, dword [byte esp+02Ch]	; 131A1
mov eax, esi	; 131A5
shl eax, 2	; 131A7
add eax, esi	; 131AA
shl eax, 2	; 131AC
sub eax, esi	; 131AF
lea ebp, [dword eax+08Ch]	; 131B1
mov ebx, dword [nosplit esi*4+awardnames]	; 131B7
mov edx, ebp	; 131BE
mov eax, 14h	; 131C0
call PrintShadowText	; 131C5
cmp byte [dword esi+awardtype], 2	; 131CA
jne near .8	; 131D1
mov ebx, 3	; 131D7
mov edx, str_ANA	; 131DC
mov eax, esp	; 131E1
call strnicmp_	; 131E3
test eax, eax	; 131E8
jne short .2	; 131EA
mov ebx, str_MightyDucks	; 131EC
jmp near .14	; 131F1
.2:
cmp esi, byte 0Ah	; 131F6
jne short .3	; 131F9
mov edx, cupteam+5	; 131FB
jmp short .4	; 13200
.3:
mov edx, presidentsteam+5	; 13202
.4:
mov eax, esp	; 13207
call strcpy_	; 13209
mov ebx, 3	; 1320E
mov edx, str_Cal	; 13213
mov eax, esp	; 13218
call strnicmp_	; 1321A
test eax, eax	; 1321F
je short .5	; 13221
mov ebx, 3	; 13223
mov edx, str_Flo	; 13228
mov eax, esp	; 1322D
call strnicmp_	; 1322F
test eax, eax	; 13234
jne short .6	; 13236
.5:
mov edx, unk_C03C4	; 13238
jmp short .7	; 1323D
.6:
mov edx, unk_C03C6	; 1323F
.7:
mov eax, esp	; 13244
call strcat_	; 13246
mov ebx, esp	; 1324B
jmp near .14	; 1324D
.8:
mov eax, esi	; 13252
shl eax, 2	; 13254
sub eax, esi	; 13257
shl eax, 2	; 13259
add esi, eax	; 1325C
shl esi, 2	; 1325E
mov eax, awardwinners	; 13261
add eax, esi	; 13266
lea ebx, [byte eax+013h]	; 13268
lea edx, [byte eax+03h]	; 1326B
mov ecx, 0D2h	; 1326E
mov eax, esp	; 13273
call FitPlayerName	; 13275
mov ebx, esp	; 1327A
mov edx, ebp	; 1327C
mov eax, 0B4h	; 1327E
call PrintShadowText	; 13283
xor edx, edx	; 13288
mov dl, byte [dword esi+awardwinners]	; 1328A
mov eax, edx	; 13290
shl eax, 2	; 13292
add eax, edx	; 13295
shl eax, 2	; 13297
add eax, edx	; 1329A
mov edx, treeteamnames	; 1329C
add edx, eax	; 132A1
mov eax, esp	; 132A3
call strcpy_	; 132A5
mov ebx, 3	; 132AA
mov edx, str_ANA	; 132AF
mov eax, esp	; 132B4
call strnicmp_	; 132B6
test eax, eax	; 132BB
jne short .9	; 132BD
mov ecx, 6	; 132BF
mov edi, esp	; 132C4
mov esi, str_MightyDucks	; 132C6
rep movsd	; 132CB
movsb	; 132CD
jmp short .13	; 132CE
.9:
mov dh, byte [dword esi+awardwinners]	; 132D0
cmp dh, 2	; 132D6
je short .10	; 132D9
cmp dh, 18h	; 132DB
je short .10	; 132DE
cmp dh, 19h	; 132E0
jne short .11	; 132E3
.10:
mov edx, unk_C03C4	; 132E5
jmp short .12	; 132EA
.11:
mov edx, unk_C03C6	; 132EC
.12:
mov eax, esp	; 132F1
call strcat_	; 132F3
.13:
mov ebx, esp	; 132F8
.14:
mov edx, ebp	; 132FA
mov eax, 190h	; 132FC
call PrintShadowText	; 13301
mov ecx, dword [byte esp+02Ch]	; 13306
inc ecx	; 1330A
mov dword [byte esp+02Ch], ecx	; 1330B
cmp ecx, byte 0Bh	; 1330F
jl near DrawAwardsSummary.1	; 13312
add esp, byte 30h	; 13318
jmp near PickAwardWinners_x	; 1331B
; C: src/front/awards/PickAwardWinners.c (AwardsCeremony)
%ifdef CBUILD
%include "c/front/awards/PickAwardWinners.AwardsCeremony.inc"
%else
AwardsCeremony:
push dword 78h	; 13320
call __CHK	; 13325
push ebx	; 1332A
push ecx	; 1332B
push edx	; 1332C
push esi	; 1332D
push edi	; 1332E
push ebp	; 1332F
sub esp, byte 50h	; 13330
call ClearInputQueue	; 13333
push byte 20h	; 13338
push dword 300h	; 1333A
push str_Palmem	; 1333F
call sub_8CCA8	; 13344
add esp, byte 0Ch	; 13349
mov esi, eax	; 1334C
push eax	; 1334E
push dword 100h	; 1334F
push byte 0	; 13354
call sub_8FFB0	; 13356
add esp, byte 0Ch	; 1335B
cmp byte [musicon], 0	; 1335E
je short .1	; 13365
cmp dword [songdata], byte 0	; 13367
je short .1	; 1336E
mov eax, dword [musichandle]	; 13370
mov ebx, 32h	; 13375
mov edx, 3	; 1337A
call sub_8FCDF	; 1337F
.1:
mov ebx, 10h	; 13384
mov edx, esi	; 13389
mov eax, 1	; 1338B
call FadePalStep	; 13390
cmp byte [musicon], 0	; 13395
je short .3	; 1339C
cmp dword [songdata], byte 0	; 1339E
je short .3	; 133A5
.2:
mov eax, dword [musicslot-3]	; 133A7
sar eax, 18h	; 133AC
mov edx, 3	; 133AF
call sub_8FC8A	; 133B4
test eax, eax	; 133B9
je short AwardsCeremony.2	; 133BB
mov ecx, dword [songdata]	; 133BD
push ecx	; 133C3
call sub_8D2F0	; 133C4
add esp, byte 4	; 133C9
xor ebp, ebp	; 133CC
mov dword [songdata], ebp	; 133CE
.3:
mov eax, esp	; 133D4
push eax	; 133D6
call sub_8E9E8	; 133D7
add esp, byte 4	; 133DC
mov eax, dword [kaufmfont]	; 133DF
push eax	; 133E4
call sub_8EA18	; 133E5
add esp, byte 4	; 133EA
xor ecx, ecx	; 133ED
mov ebx, str_Awardsi	; 133EF
cmp byte [fileoncd+01DEh], 1	; 133F4
jne short .4	; 133FB
mov edx, dword [cddriveptr]	; 133FD
jmp short .5	; 13403
.4:
xor edx, edx	; 13405
.5:
lea eax, [byte esp+040h]	; 13407
call MakePath	; 1340B
push byte 0	; 13410
lea eax, [byte esp+044h]	; 13412
push eax	; 13416
call sub_8E83C	; 13417
mov ebp, eax	; 1341C
add esp, byte 8	; 1341E
push str_Scrn	; 13421
push eax	; 13426
call sub_B30B4	; 13427
add esp, byte 8	; 1342C
push eax	; 1342F
call sub_9061C	; 13430
add esp, byte 4	; 13435
push str_Titl	; 13438
push ebp	; 1343D
call sub_B30B4	; 1343E
add esp, byte 8	; 13443
push eax	; 13446
call sub_9061C	; 13447
add esp, byte 4	; 1344C
push str_Pal3	; 1344F
push ebp	; 13454
call sub_B30B4	; 13455
add esp, byte 8	; 1345A
lea edx, [byte eax+010h]	; 1345D
mov ebx, 300h	; 13460
mov eax, esi	; 13465
call memcpy_	; 13467
push ebp	; 1346C
call FreeMemBlock	; 1346D
add esp, byte 4	; 13472
cmp byte [musicon], 0	; 13475
je short .8	; 1347C
cmp dword [songdata], byte 0	; 1347E
jne short .8	; 13485
mov ecx, str_Iff	; 13487
mov ebx, str_Awards	; 1348C
cmp byte [fileoncd+0220h], 1	; 13491
jne short .6	; 13498
mov edx, dword [cddriveptr]	; 1349A
jmp short .7	; 134A0
.6:
xor edx, edx	; 134A2
.7:
lea eax, [byte esp+040h]	; 134A4
call MakePath	; 134A8
lea eax, [byte esp+040h]	; 134AD
call sub_8F98F	; 134B1
mov dword [songdata], eax	; 134B6
test eax, eax	; 134BB
je near .13	; 134BD
test byte [gameopts], 40h	; 134C3
je near .13	; 134CA
mov edx, dword [musichandle]	; 134D0
mov ecx, 4Ch	; 134D6
mov ebx, 3	; 134DB
call sub_8FB8E	; 134E0
jmp short .13	; 134E5
.8:
mov ebx, dword [sounddev]	; 134E7
cmp ebx, byte 1	; 134ED
je short .13	; 134F0
cmp ebx, byte 8	; 134F2
jne short .10	; 134F5
xor ecx, ecx	; 134F7
mov ebx, str_Mtafan	; 134F9
cmp byte [fileoncd+0FAh], 1	; 134FE
jne short .9	; 13505
mov edx, dword [cddriveptr]	; 13507
jmp short .12	; 1350D
.9:
xor edx, edx	; 1350F
jmp short .12	; 13511
.10:
xor ecx, ecx	; 13513
mov ebx, str_Adafan	; 13515
cmp byte [fileoncd+018h], 1	; 1351A
jne short .11	; 13521
mov edx, dword [cddriveptr]	; 13523
jmp short .12	; 13529
.11:
xor edx, edx	; 1352B
.12:
lea eax, [byte esp+040h]	; 1352D
call MakePath	; 13531
lea eax, [byte esp+040h]	; 13536
call sub_8F13B	; 1353A
mov edi, eax	; 1353F
call PlayDigiSample	; 13541
.13:
mov ebx, 10h	; 13546
mov edx, esi	; 1354B
xor eax, eax	; 1354D
call FadePalStep	; 1354F
cmp byte [musicon], 0	; 13554
jne short .14	; 1355B
cmp dword [sounddev], byte 1	; 1355D
je short .14	; 13564
call WaitDigiSample	; 13566
mov ebx, 10h	; 1356B
mov edx, esi	; 13570
mov eax, 1	; 13572
call FadePalStep	; 13577
call StopDigiSample	; 1357C
mov eax, edi	; 13581
call sub_8F1FE	; 13583
jmp near .20	; 13588
.14:
cmp byte [musicon], 0	; 1358D
je near .19	; 13594
xor eax, eax	; 1359A
.15:
test eax, eax	; 1359C
jne short .16	; 1359E
mov eax, dword [musicslot-3]	; 135A0
sar eax, 18h	; 135A5
mov edx, 3	; 135A8
call sub_8FC8A	; 135AD
test eax, eax	; 135B2
jne short .16	; 135B4
mov eax, 0Ah	; 135B6
call WaitClickTimeout	; 135BB
jmp short AwardsCeremony.15	; 135C0
.16:
mov eax, dword [musichandle]	; 135C2
mov ebx, 32h	; 135C7
mov edx, 3	; 135CC
call sub_8FCDF	; 135D1
mov ebx, 10h	; 135D6
mov edx, esi	; 135DB
mov eax, 1	; 135DD
call FadePalStep	; 135E2
.17:
mov eax, dword [musicslot-3]	; 135E7
sar eax, 18h	; 135EC
mov edx, 3	; 135EF
call sub_8FC8A	; 135F4
test eax, eax	; 135F9
je short AwardsCeremony.17	; 135FB
mov eax, dword [songdata]	; 135FD
test eax, eax	; 13602
je short .18	; 13604
push eax	; 13606
call sub_8D2F0	; 13607
add esp, byte 4	; 1360C
.18:
xor ebx, ebx	; 1360F
mov dword [songdata], ebx	; 13611
jmp short .20	; 13617
.19:
mov eax, 140h	; 13619
call WaitClickTimeout	; 1361E
mov ebx, 10h	; 13623
mov edx, esi	; 13628
mov eax, 1	; 1362A
call FadePalStep	; 1362F
.20:
push esi	; 13634
call FreeMemBlock	; 13635
add esp, byte 4	; 1363A
call PickAwardWinners	; 1363D
mov esi, eax	; 13642
cmp byte [musicon], 0	; 13644
je short .23	; 1364B
cmp dword [songdata], byte 0	; 1364D
jne short .23	; 13654
mov ecx, str_Iff	; 13656
mov ebx, str_Awasong	; 1365B
cmp byte [fileoncd+0224h], 1	; 13660
jne short .21	; 13667
mov edx, dword [cddriveptr]	; 13669
jmp short .22	; 1366F
.21:
xor edx, edx	; 13671
.22:
lea eax, [byte esp+040h]	; 13673
call MakePath	; 13677
lea eax, [byte esp+040h]	; 1367C
call sub_8F98F	; 13680
mov dword [songdata], eax	; 13685
test eax, eax	; 1368A
je near .28	; 1368C
test byte [gameopts], 40h	; 13692
je near .28	; 13699
mov edx, dword [musichandle]	; 1369F
mov ecx, 7Fh	; 136A5
mov ebx, 3	; 136AA
call sub_8FB8E	; 136AF
jmp short .28	; 136B4
.23:
cmp dword [sounddev], byte 8	; 136B6
jne short .25	; 136BD
xor ecx, ecx	; 136BF
mov ebx, str_Mtawards	; 136C1
cmp byte [fileoncd+0FCh], 1	; 136C6
jne short .24	; 136CD
mov edx, dword [cddriveptr]	; 136CF
jmp short .27	; 136D5
.24:
xor edx, edx	; 136D7
jmp short .27	; 136D9
.25:
xor ecx, ecx	; 136DB
mov ebx, str_Adawards	; 136DD
cmp byte [fileoncd+01Ah], 1	; 136E2
jne short .26	; 136E9
mov edx, dword [cddriveptr]	; 136EB
jmp short .27	; 136F1
.26:
xor edx, edx	; 136F3
.27:
lea eax, [byte esp+040h]	; 136F5
call MakePath	; 136F9
lea eax, [byte esp+040h]	; 136FE
call sub_8F13B	; 13702
mov edi, eax	; 13707
call PlayDigiSample	; 13709
.28:
test esi, esi	; 1370E
jne near .32	; 13710
call ShowAwardScreens	; 13716
cmp eax, byte 3	; 1371B
jge near .31	; 1371E
xor ecx, ecx	; 13724
mov ebx, str_Awardsi	; 13726
cmp byte [fileoncd+01DEh], 1	; 1372B
jne short .29	; 13732
mov edx, dword [cddriveptr]	; 13734
jmp short .30	; 1373A
.29:
xor edx, edx	; 1373C
.30:
lea eax, [byte esp+040h]	; 1373E
call MakePath	; 13742
push byte 0	; 13747
lea eax, [byte esp+044h]	; 13749
push eax	; 1374D
call sub_8E83C	; 1374E
mov esi, eax	; 13753
add esp, byte 8	; 13755
call ClearInputQueue	; 13758
call sub_B4BA8	; 1375D
xor edx, edx	; 13762
mov eax, 1	; 13764
call SetTextColors	; 13769
push str_Scrn	; 1376E
push esi	; 13773
call sub_B30B4	; 13774
add esp, byte 8	; 13779
push eax	; 1377C
call sub_9061C	; 1377D
add esp, byte 4	; 13782
push str_Summ	; 13785
push esi	; 1378A
call sub_B30B4	; 1378B
add esp, byte 8	; 13790
push eax	; 13793
call sub_9061C	; 13794
add esp, byte 4	; 13799
call DrawAwardsSummary	; 1379C
call sub_B4BA8	; 137A1
push str_Pal3	; 137A6
push esi	; 137AB
call sub_B30B4	; 137AC
add esp, byte 8	; 137B1
lea ebp, [byte eax+010h]	; 137B4
mov ebx, 10h	; 137B7
mov edx, ebp	; 137BC
xor eax, eax	; 137BE
call FadePalStep	; 137C0
mov eax, 2328h	; 137C5
call WaitClickTimeout	; 137CA
mov ebx, 10h	; 137CF
mov edx, ebp	; 137D4
mov eax, 1	; 137D6
call FadePalStep	; 137DB
push esi	; 137E0
call FreeMemBlock	; 137E1
add esp, byte 4	; 137E6
.31:
call sub_B4BA8	; 137E9
push byte 0	; 137EE
call sub_B392C	; 137F0
add esp, byte 4	; 137F5
.32:
cmp byte [musicon], 0	; 137F8
je short .35	; 137FF
mov eax, dword [musichandle]	; 13801
mov ebx, 78h	; 13806
mov edx, 3	; 1380B
call sub_8FCDF	; 13810
.33:
mov eax, dword [musicslot-3]	; 13815
sar eax, 18h	; 1381A
mov edx, 3	; 1381D
call sub_8FC8A	; 13822
test eax, eax	; 13827
je short AwardsCeremony.33	; 13829
mov ebp, dword [songdata]	; 1382B
test ebp, ebp	; 13831
je short .34	; 13833
push ebp	; 13835
call sub_8D2F0	; 13836
add esp, byte 4	; 1383B
.34:
xor edx, edx	; 1383E
mov dword [songdata], edx	; 13840
jmp short .36	; 13846
.35:
call StopDigiSample	; 13848
mov eax, edi	; 1384D
call sub_8F1FE	; 1384F
.36:
mov eax, esp	; 13854
push eax	; 13856
call sub_8EA00	; 13857
add esp, byte 4	; 1385C
add esp, byte 50h	; 1385F
jmp near PickAwardWinners_x	; 13862
%endif ; C
