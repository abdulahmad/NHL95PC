; The skate-out before the puck drops, and the three stars after the game. One module: the stars
; share PreGameIntro's exits.
bits 32
%include "hockey.inc"
section s_47C31 progbits alloc exec nowrite align=1
extern __CHK, AddPenalty, AddPenalty2, assexit, assinsert, assreplace, awscore, awtmap
extern awtmstruct, bannermsg, bannertimer, bgscrollx, bgscrolly, byte_CC9B0, byte_CC9E4, byte_CC9E7
extern byte_CCA95, byte_DACB3, byte_DAEA7, byte_DF87F, byte_DFFE2, byte_E9AC8, byte_E9AD3, byte_E9AD4
extern byte_E9AD5, byte_E9AD6, byte_E9AD7, c1playernum, c2playernum, camx, camx_m2, camy
extern changeplayer, check4bench, check4check, checkob, checkpuckcoll, chk4lc, chk4pass, chk4shot
extern ChkOffsides, ChkPullGoalieLate, ChkScorerMilestone, clockticks, CloseTextOverlay, cont2team, Crowd_Noise, CrowdFadeOut
extern crowdlevel, CrowdNoiseReset, curperiod, deferpending, dirtab, dirtab_y, DoGameFrame, doorpflags
extern doortemp1, doplayeracc, doshot, DrawRinkOverlays, dword_C585C, dword_C5860, dword_CBEBE, dword_CC0EC
extern dword_CC9AD, dword_CC9CE, dword_CCA58, dword_CCA5A, dword_CCAD8, dword_CCB18, dword_CCB1C, dword_CCB20
extern dword_D8C72, dword_D8C7A, dword_DB086, dword_DB088, dword_DF642, dword_DF648, dword_DF652, dword_DF748
extern dword_DF752, dword_DF848, dword_E0244, dword_E038E, dword_E03AE, dword_E9A9E, dword_E9AB6, dword_E9AB7
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
extern startm_m2, StopDigiSample, stopna, str_EASports, str_StarFmt, sub_6ADA7, sub_6AF52, sub_6AF97
extern sub_6B008, sub_8F633, sub_8FFB0, teamabbrevs, textline1, textline2, textline3, textline4
extern textline5, threat, TicksSinceLastCall, unk_C1B3E, unk_DACA0, unk_DC240, unk_DFD9C, updateanim
extern UpdateHudPanel, vecdist, viewscrollx, viewscrolly, VisTeam, vtoa, WaitTickDeadline, word_C90D8
extern word_CBC44, word_CBEC6, word_CC9CC, word_CC9EA, word_CC9EC, word_CCA18, word_CCA1A, word_CCA1C
extern word_CCA1E, word_CCA38, word_CCA3A, word_CCA3C, word_CCA3E, word_CCA6E, word_CCA70, word_CCA9C
extern word_DB08A, word_DC242, word_DC244, word_DC248, word_DC24E, word_DF644, word_DF816, word_DF81A
extern word_E0022, word_E0028, word_E002A, word_E002E, word_E0042, word_E0046, word_E0048, word_E004A
extern word_E0392, word_E0394, word_E0396, word_E9AAE, word_E9AB0, xc1, yc1, yleader
global FadeOutPalCycle, PreGameIntro, PreGameIntro_scroll, PreGameIntro_frameloop, PreGameIntro_end, PreGameIntro_popebp, PreGameIntro_popx, StartPreGame
global ThreeStarsLoop, ThreeStarsLoop_tick, assintrostand, assintroline, AddStar, StarEligible, StarCompare, PickThreeStars
global StartThreeStars, MoveInDir, SteerToTarget, assstarskate, assthreestars
; C: src/engine/intro/FadeOutPalCycle.c
%ifdef CBUILD
%include "c/engine/intro/FadeOutPalCycle.inc"
%else
FadeOutPalCycle:
push dword 1Ch	; 47C31
call __CHK	; 47C36
push ebx	; 47C3B
push ecx	; 47C3C
push edx	; 47C3D
push esi	; 47C3E
push ebp	; 47C3F
cmp dword [loadscreenon], byte 0	; 47C40
je near .x	; 47C47
xor esi, esi	; 47C4D
.1:
test esi, esi	; 47C4F
jne short .5	; 47C51
mov esi, 1	; 47C53
mov dword [palcyclelock], esi	; 47C58
xor ecx, ecx	; 47C5E
.2:
xor edx, edx	; 47C60
.3:
mov eax, ecx	; 47C62
shl eax, 2	; 47C64
sub eax, ecx	; 47C67
shl eax, 8	; 47C69
add eax, edx	; 47C6C
mov bl, byte [dword eax+loadpals]	; 47C6E
test bl, bl	; 47C74
jle short .4	; 47C76
mov bh, bl	; 47C78
dec bh	; 47C7A
mov byte [dword eax+loadpals], bh	; 47C7C
cmp esi, byte 1	; 47C82
jne short .4	; 47C85
xor esi, esi	; 47C87
.4:
inc edx	; 47C89
cmp edx, 300h	; 47C8A
jl short FadeOutPalCycle.3	; 47C90
inc ecx	; 47C92
cmp ecx, byte 3	; 47C93
jl short FadeOutPalCycle.2	; 47C96
xor ebp, ebp	; 47C98
mov dword [palcyclelock], ebp	; 47C9A
push byte 2	; 47CA0
call SetTickDeadline	; 47CA2
add esp, byte 4	; 47CA7
call WaitTickDeadline	; 47CAA
jmp short FadeOutPalCycle.1	; 47CAF
.5:
mov dword [palcyclelock], 1	; 47CB1
push LoadScreenPalTick	; 47CBB
call RemoveTimerCallback	; 47CC0
add esp, byte 4	; 47CC5
xor ecx, ecx	; 47CC8
mov dword [loadscreenon], ecx	; 47CCA
.x:
pop ebp	; 47CD0
pop esi	; 47CD1
pop edx	; 47CD2
pop ecx	; 47CD3
pop ebx	; 47CD4
ret	; 47CD5
%endif ; C
; C: src/engine/intro/FadeOutPalCycle.c (PreGameIntro)
%ifdef CBUILD
%include "c/engine/intro/FadeOutPalCycle.PreGameIntro.inc"
%else
PreGameIntro:
push dword 28h	; 47CD6
call __CHK	; 47CDB
push ebx	; 47CE0
push ecx	; 47CE1
push edx	; 47CE2
push esi	; 47CE3
push edi	; 47CE4
sub esp, byte 10h	; 47CE5
mov eax, 0Ah	; 47CE8
call PlayCrowdSample	; 47CED
mov eax, dword [HomeTeam-2]	; 47CF2
sar eax, 10h	; 47CF7
movsx dx, byte [dword eax+byte_CC9B0]	; 47CFA
mov dword [byte esp+08h], edx	; 47D02
mov edi, dword [dword eax+byte_CC9B0-3]	; 47D06
sar edi, 18h	; 47D0C
mov di, word [nosplit edi*2+word_CC9CC]	; 47D0F
cmp dx, byte 1	; 47D17
setne al	; 47D1B
and eax, 0FFh	; 47D1E
add eax, byte 3	; 47D23
cwde	; 47D26
call LoadTeamPPV	; 47D27
xor ah, ah	; 47D2C
mov byte [textline5], ah	; 47D2E
mov byte [textline4], ah	; 47D34
mov byte [textline2], ah	; 47D3A
xor bl, bl	; 47D40
mov byte [textline1], ah	; 47D42
xor bh, bh	; 47D48
mov byte [textline3], ah	; 47D4A
mov dword [curperiod], 0FFFFFFFFh	; 47D50
mov word [foy], bx	; 47D5A
xor ecx, ecx	; 47D61
mov word [fox], cx	; 47D63
mov edx, dword [HomeTeam-2]	; 47D6A
sar edx, 10h	; 47D70
shl edx, 10h	; 47D73
mov eax, dword [VisTeam-2]	; 47D76
sar eax, 10h	; 47D7B
add eax, edx	; 47D7E
add dword [seed], eax	; 47D80
xor ecx, ecx	; 47D86
mov dword [shownumbers], ecx	; 47D88
mov dword [seqtimer], 708h	; 47D8E
xor esi, esi	; 47D98
mov word [exitgame], si	; 47D9A
mov eax, 0FFFFFFFFh	; 47DA1
mov word [c2playernum], ax	; 47DA6
mov word [c1playernum], ax	; 47DAC
mov eax, hmtmstruct	; 47DB2
call reenergizeteam	; 47DB7
mov eax, hmtmstruct	; 47DBC
call setpersonel	; 47DC1
mov eax, hmtmstruct	; 47DC6
call forcepldata	; 47DCB
mov eax, awtmstruct	; 47DD0
call reenergizeteam	; 47DD5
mov eax, awtmstruct	; 47DDA
call setpersonel	; 47DDF
mov eax, awtmstruct	; 47DE4
call forcepldata	; 47DE9
call resetplstuff	; 47DEE
mov ebx, unk_DFD9C	; 47DF3
mov dword [byte esp+0Ch], esi	; 47DF8
jmp near .16	; 47DFC
.1:
xor esi, esi	; 47E01
jmp short .3	; 47E03
.2:
movsx eax, si	; 47E05
xor ch, ch	; 47E08
mov byte [esp+eax], ch	; 47E0A
inc esi	; 47E0D
.3:
cmp si, byte 5	; 47E0E
jl short PreGameIntro.2	; 47E12
xor esi, esi	; 47E14
jmp near .15	; 47E16
.4:
mov ax, word [byte ebx+position]	; 47E1B
test ax, ax	; 47E1F
jne short .9	; 47E22
mov word [byte ebx+Xpos+2], ax	; 47E24
mov word [byte ebx+temp3], ax	; 47E28
test byte [byte ebx+pflags], 80h	; 47E2C
je short .5	; 47E30
mov eax, 0FFFFFF24h	; 47E32
jmp short .6	; 47E37
.5:
mov eax, 0DCh	; 47E39
.6:
mov word [byte ebx+Ypos+2], ax	; 47E3E
mov word [byte ebx+temp4], ax	; 47E42
mov word [byte ebx+temp5], 0FF9Ch	; 47E46
mov word [byte ebx+Yvel], 0	; 47E4C
mov ax, word [byte ebx+Yvel]	; 47E52
mov word [byte ebx+Xvel], ax	; 47E56
test byte [byte ebx+pflags], 80h	; 47E5A
je short .7	; 47E5E
xor eax, eax	; 47E60
jmp short .8	; 47E62
.7:
mov eax, 4	; 47E64
.8:
mov word [byte ebx+facedir], ax	; 47E69
mov edx, 99h	; 47E6D
mov eax, ebx	; 47E72
call SetSPA	; 47E74
jmp near .14	; 47E79
.9:
mov eax, 5	; 47E7E
call randomd0	; 47E83
mov edx, eax	; 47E88
.10:
movsx eax, dx	; 47E8A
cmp byte [esp+eax], 0	; 47E8D
je short .11	; 47E91
lea edx, [byte eax+01h]	; 47E93
mov ecx, 5	; 47E96
mov eax, edx	; 47E9B
sar edx, 1Fh	; 47E9D
idiv ecx	; 47EA0
jmp short PreGameIntro.10	; 47EA2
.11:
mov byte [esp+eax], 1	; 47EA4
imul edx, byte 28h	; 47EA8
sub edx, byte 50h	; 47EAB
mov eax, 8	; 47EAE
call randomd0	; 47EB3
sub eax, byte 4	; 47EB8
add edx, eax	; 47EBB
mov word [byte ebx+Xpos+2], dx	; 47EBD
mov word [byte ebx+temp3], dx	; 47EC1
mov eax, 2	; 47EC5
call randomd0	; 47ECA
add word [byte ebx+Xpos+2], ax	; 47ECF
test byte [byte ebx+pflags], 80h	; 47ED3
je short .12	; 47ED7
mov edx, 0FFFFFFC6h	; 47ED9
jmp short .13	; 47EDE
.12:
mov edx, 30h	; 47EE0
.13:
mov eax, 4	; 47EE5
call randomd0	; 47EEA
cwde	; 47EEF
sub eax, byte 2	; 47EF0
add edx, eax	; 47EF3
mov word [byte ebx+Ypos+2], dx	; 47EF5
mov word [byte ebx+temp4], dx	; 47EF9
mov word [byte ebx+facedir], 4	; 47EFD
mov word [byte ebx+Yvel], 0	; 47F03
mov ax, word [byte ebx+Yvel]	; 47F09
mov word [byte ebx+Xvel], ax	; 47F0D
mov eax, 28h	; 47F11
call randomd0	; 47F16
sub eax, byte 14h	; 47F1B
mov edx, edi	; 47F1E
add edx, eax	; 47F20
mov word [byte ebx+temp5], dx	; 47F22
xor edx, edx	; 47F26
mov eax, ebx	; 47F28
call SetSPA	; 47F2A
mov word [byte ebx+012h], 171h	; 47F2F
.14:
mov edx, 25h	; 47F35
mov eax, ebx	; 47F3A
call assreplace	; 47F3C
inc esi	; 47F41
sub ebx, 80h	; 47F42
.15:
cmp si, byte 6	; 47F48
jl near PreGameIntro.4	; 47F4C
inc dword [byte esp+0Ch]	; 47F52
.16:
cmp word [byte esp+0Ch], byte 2	; 47F56
jl near PreGameIntro.1	; 47F5C
mov word [puckstruct+28h], 78h	; 47F62
mov word [puckstruct+2], 0C8h	; 47F6B
mov word [puckstruct+6], 0FED4h	; 47F74
xor ecx, ecx	; 47F7D
mov word [puckstruct+0Ch], cx	; 47F7F
xor esi, esi	; 47F86
mov word [puckstruct+0Eh], cx	; 47F88
mov edx, 1Ah	; 47F8F
mov eax, puckstruct	; 47F94
call assreplace	; 47F99
mov eax, dword [byte esp+08h]	; 47F9E
mov word [word_E0042], ax	; 47FA2
mov eax, 8Eh	; 47FA8
mov word [SortCords+802h], ax	; 47FAD
mov word [word_E0046], ax	; 47FB3
mov eax, 2	; 47FB9
call randomd0	; 47FBE
add word [SortCords+802h], ax	; 47FC3
mov word [word_E0022], cx	; 47FCA
mov word [word_E0048], cx	; 47FD1
mov word [SortCords+836h], 4	; 47FD8
mov word [word_E002A], cx	; 47FE1
mov word [word_E0028], cx	; 47FE8
mov word [word_E004A], di	; 47FEF
xor edx, edx	; 47FF6
mov eax, SortCords+800h	; 47FF8
call SetSPA	; 47FFD
mov word [word_E002E], 289h	; 48002
mov edx, 26h	; 4800B
mov eax, SortCords+800h	; 48010
call assreplace	; 48015
mov word [RefStep], si	; 4801A
or byte [sflags], 40h	; 48021
call DoGameFrame	; 48028
call DoGameFrame	; 4802D
call SprSort	; 48032
xor edi, edi	; 48037
mov dword [frameaccum], edi	; 48039
mov dword [inputframes], edi	; 4803F
mov eax, dword [puckc]	; 48045
mov byte [eax], 0FFh	; 4804A
mov dword [joysampling], edi	; 4804D
call joyq_flush	; 48053
xor edi, edi	; 48058
mov word [camx], di	; 4805A
mov word [xc1], si	; 48061
mov word [camy], si	; 48068
mov word [yc1], si	; 4806F
mov dword [viewscrollx], 20h	; 48076
mov dword [viewscrolly], 0ECh	; 48080
mov eax, dword [ovlseq-2]	; 4808A
sar eax, 10h	; 4808F
cmp eax, byte 0FFFFFFFFh	; 48092
je short .17	; 48095
call CloseTextOverlay	; 48097
.17:
call SelectScreenBM	; 4809C
xor ebx, ebx	; 480A1
mov word [lcblink+2], bx	; 480A3
mov word [lcblink], bx	; 480AA
mov word [energywarn+2], bx	; 480B1
mov word [energywarn], bx	; 480B8
call UpdateHudPanel	; 480BF
add esp, byte 10h	; 480C4
jmp near PreGameIntro_popx	; 480C7
%endif ; C
; C: src/engine/intro/FadeOutPalCycle.c (PreGameIntro_scroll)
%ifdef CBUILD
%include "c/engine/intro/FadeOutPalCycle.PreGameIntro_scroll.inc"
%else
PreGameIntro_scroll:
test ecx, ecx	; 480CC
jge short PreGameIntro_frameloop	; 480CE
xor ebp, ebp	; 480D0
mov dword [viewscrollx], ebp	; 480D2
PreGameIntro_frameloop:
mov edx, dword [viewscrolly]	; 480D8
cmp edx, 1A8h	; 480DE
jle short .1	; 480E4
mov dword [viewscrolly], 1A8h	; 480E6
jmp short .2	; 480F0
.1:
test edx, edx	; 480F2
jge short .2	; 480F4
xor ecx, ecx	; 480F6
mov dword [viewscrolly], ecx	; 480F8
.2:
xor edx, edx	; 480FE
xor eax, eax	; 48100
call sub_6AF97	; 48102
call sub_6B008	; 48107
mov edx, dword [viewscrolly]	; 4810C
mov eax, dword [viewscrollx]	; 48112
call SetRinkScroll	; 48117
mov edx, dword [bgscrolly-2]	; 4811C
sar edx, 10h	; 48122
shl edx, 3	; 48125
mov eax, dword [scrolly-2]	; 48128
sar eax, 10h	; 4812D
add edx, eax	; 48130
lea ecx, [dword edx+0A8h]	; 48132
mov eax, dword [bgscrollx-2]	; 48138
sar eax, 10h	; 4813D
shl eax, 3	; 48140
mov ebx, dword [scrollx-2]	; 48143
sar ebx, 10h	; 48149
add eax, ebx	; 4814C
lea ebx, [dword eax+0140h]	; 4814E
call sub_6AF52	; 48154
xor ebp, ebp	; 48159
mov dword [spritedrawcount], ebp	; 4815B
mov edx, dword [viewscrolly-2]	; 48161
sar edx, 10h	; 48167
mov eax, dword [viewscrollx-2]	; 4816A
sar eax, 10h	; 4816F
call DrawRinkOverlays	; 48172
mov edx, dword [bgscrolly-2]	; 48177
sar edx, 10h	; 4817D
shl edx, 3	; 48180
mov eax, dword [scrolly-2]	; 48183
sar eax, 10h	; 48188
add edx, eax	; 4818B
neg edx	; 4818D
mov ebx, dword [bgscrollx-2]	; 4818F
sar ebx, 10h	; 48195
shl ebx, 3	; 48198
mov eax, dword [scrollx-2]	; 4819B
sar eax, 10h	; 481A0
add eax, ebx	; 481A3
neg eax	; 481A5
call sub_6AF97	; 481A7
call sub_6ADA7	; 481AC
cmp word [fadeinpending], byte 0	; 481B1
je short .3	; 481B9
mov ax, word [joysampling]	; 481BB
mov word [joysampling_save], ax	; 481C1
xor eax, eax	; 481C7
mov dword [joysampling], ebp	; 481C9
mov ebx, 10h	; 481CF
mov edx, gamepal	; 481D4
call FadePalette	; 481D9
xor ebx, ebx	; 481DE
mov word [fadeinpending], bx	; 481E0
mov eax, dword [joysampling_save-2]	; 481E7
sar eax, 10h	; 481EC
mov dword [joysampling], eax	; 481EF
.3:
movsx eax, si	; 481F4
call Crowd_Noise	; 481F7
cmp dword [escrequest], byte 0	; 481FC
jne short PreGameIntro_end	; 48203
call ReadJoy1	; 48205
mov ah, byte [regd1]	; 4820A
test ah, 10h	; 48210
jne short .4	; 48213
test ah, 20h	; 48215
je short .5	; 48218
.4:
mov dword [introskipped], 1	; 4821A
mov word [fadeinpending], 1	; 48224
jmp short PreGameIntro_end	; 4822D
.5:
call ReadJoy2	; 4822F
mov dh, byte [regd1]	; 48234
test dh, 10h	; 4823A
jne short PreGameIntro_frameloop.4	; 4823D
test dh, 20h	; 4823F
jne short PreGameIntro_frameloop.4	; 48242
call WaitTickDeadline	; 48244
jmp near ThreeStarsLoop_tick	; 48249
%endif ; C
; C: src/engine/intro/FadeOutPalCycle.c (PreGameIntro_end)
%ifdef CBUILD
%include "c/engine/intro/FadeOutPalCycle.PreGameIntro_end.inc"
%else
PreGameIntro_end:
xor esi, esi	; 4824E
mov dword [joysampling], esi	; 48250
mov eax, dword [ovlseq-2]	; 48256
sar eax, 10h	; 4825B
cmp eax, byte 0FFFFFFFFh	; 4825E
je short .1	; 48261
mov edi, dword [dword_E0244]	; 48263
push edi	; 48269
call FreeMemBlock	; 4826A
add esp, byte 4	; 4826F
mov word [ovlseq], 0FFFFh	; 48272
.1:
mov ebp, dword [escrequest]	; 4827B
test ebp, ebp	; 48281
je short .2	; 48283
push savepal	; 48285
push dword 100h	; 4828A
push byte 0	; 4828F
call sub_8FFB0	; 48291
add esp, byte 0Ch	; 48296
mov ebx, 10h	; 48299
mov edx, savepal	; 4829E
mov eax, 1	; 482A3
call FadePalette	; 482A8
call CrowdFadeOut	; 482AD
call StopDigiSample	; 482B2
call SpeechStopQueue	; 482B7
xor edx, edx	; 482BC
mov dword [escrequest], edx	; 482BE
mov eax, 0FFFFFFFFh	; 482C4
jmp short PreGameIntro_popebp	; 482C9
.2:
cmp dword [introskipped], byte 0	; 482CB
je short .3	; 482D2
push savepal	; 482D4
push dword 100h	; 482D9
push ebp	; 482DE
call sub_8FFB0	; 482DF
add esp, byte 0Ch	; 482E4
mov ebx, 10h	; 482E7
mov edx, savepal	; 482EC
mov eax, 1	; 482F1
call FadePalette	; 482F6
.3:
call StopDigiSample	; 482FB
call SpeechStopQueue	; 48300
xor eax, eax	; 48305
PreGameIntro_popebp:
pop ebp	; 48307
PreGameIntro_popx:
pop edi	; 48308
pop esi	; 48309
pop edx	; 4830A
pop ecx	; 4830B
pop ebx	; 4830C
ret	; 4830D
%endif ; C
; C: src/engine/intro/FadeOutPalCycle.c (StartPreGame)
%ifdef CBUILD
%include "c/engine/intro/FadeOutPalCycle.StartPreGame.inc"
%else
StartPreGame:
push dword 4	; 4830E
call __CHK	; 48313
cmp dword [dword_CC0EC], byte 0	; 48318
je short .1	; 4831F
xor eax, eax	; 48321
ret	; 48323
.1:
test ax, ax	; 48324
jne short .2	; 48327
call PreGameIntro	; 48329
.2:
call CrowdNoiseReset	; 4832E
ThreeStarsLoop:
push dword 28h	; 48333
call __CHK	; 48338
push ebx	; 4833D
push ecx	; 4833E
push edx	; 4833F
push esi	; 48340
push edi	; 48341
push ebp	; 48342
call TicksSinceLastCall	; 48343
mov dword [joysampling], 1	; 48348
xor ebx, ebx	; 48352
mov dword [escrequest], ebx	; 48354
add dword [rinkscrollx], 3E8h	; 4835A
add dword [rinkscrolly], 3E8h	; 48364
ThreeStarsLoop_tick:
cmp dword [seqtimer], byte 0	; 4836E
je near PreGameIntro_end	; 48375
push byte 4	; 4837B
call SetTickDeadline	; 4837D
add esp, byte 4	; 48382
call ResetInputSampling	; 48385
movsx edx, ax	; 4838A
mov eax, edx	; 4838D
shl eax, 2	; 4838F
sub eax, edx	; 48392
add eax, eax	; 48394
mov ebp, dword [frameaccum]	; 48396
add ebp, eax	; 4839C
mov dword [frameaccum], ebp	; 4839E
mov ebx, 0Ah	; 483A4
mov eax, ebp	; 483A9
mov edx, ebp	; 483AB
sar edx, 1Fh	; 483AD
idiv ebx	; 483B0
mov esi, eax	; 483B2
mov eax, ebp	; 483B4
mov edx, ebp	; 483B6
sar edx, 1Fh	; 483B8
idiv ebx	; 483BB
mov dword [frameaccum], edx	; 483BD
movsx edx, si	; 483C3
mov eax, edx	; 483C6
call RunGameFrames	; 483C8
mov eax, dword [seqtimer]	; 483CD
sub eax, edx	; 483D2
mov dword [seqtimer], eax	; 483D4
test eax, eax	; 483D9
jge short .1	; 483DB
xor ebx, ebx	; 483DD
mov dword [seqtimer], ebx	; 483DF
.1:
mov eax, dword [camx-2]	; 483E5
sar eax, 10h	; 483EA
add eax, byte 20h	; 483ED
mov dword [viewscrollx], eax	; 483F0
mov eax, dword [camy-2]	; 483F5
sar eax, 10h	; 483FA
mov edx, 140h	; 483FD
sub edx, eax	; 48402
lea eax, [byte edx-054h]	; 48404
mov dword [viewscrolly], eax	; 48407
mov ecx, dword [viewscrollx]	; 4840C
cmp ecx, byte 40h	; 48412
jle near PreGameIntro_scroll	; 48415
mov dword [viewscrollx], 40h	; 4841B
jmp near PreGameIntro_frameloop	; 48425
%endif ; C
; C: src/engine/intro/assintrostand.c
%ifdef CBUILD
%include "c/engine/intro/assintrostand.inc"
%else
assintrostand:
push dword 10h	; 4842A
call __CHK	; 4842F
push ebx	; 48434
push ecx	; 48435
push edx	; 48436
mov ebx, eax	; 48437
test byte [byte eax+pflags], 20h	; 48439
jne near .x	; 4843D
mov edx, dword [byte ebx+temp5-2]	; 48443
sar edx, 10h	; 48446
cmp edx, byte 0FFFFFF9Ch	; 48449
je near .x	; 4844C
mov dx, word [byte ebx+temp5]	; 48452
dec edx	; 48456
mov word [byte ebx+temp5], dx	; 48457
test dx, dx	; 4845B
jle short .2	; 4845E
mov eax, 64h	; 48460
call randomd0	; 48465
test ax, ax	; 4846A
jne short .1	; 4846D
mov eax, 2	; 4846F
call randomd0	; 48474
mov dx, word [byte ebx+temp3]	; 48479
add edx, eax	; 4847D
mov word [byte ebx+Xpos+2], dx	; 4847F
.1:
test byte [byte ebx+pflags2], 2	; 48483
jne short .x	; 48487
mov eax, 50h	; 48489
call randomd0	; 4848E
test ax, ax	; 48493
jne short .x	; 48496
mov eax, 9	; 48498
call randomd0	; 4849D
movsx edx, ax	; 484A2
mov ecx, 5	; 484A5
mov eax, edx	; 484AA
sar edx, 1Fh	; 484AC
idiv ecx	; 484AF
mov edx, dword [nosplit edx*4+dword_CC9CE]	; 484B1
sar edx, 10h	; 484B8
mov eax, ebx	; 484BB
call SetSPA	; 484BD
or byte [byte ebx+pflags2], 2	; 484C2
pop edx	; 484C6
pop ecx	; 484C7
pop ebx	; 484C8
ret	; 484C9
.2:
mov edx, 27h	; 484CA
mov eax, ebx	; 484CF
call assinsert	; 484D1
.x:
pop edx	; 484D6
pop ecx	; 484D7
pop ebx	; 484D8
ret	; 484D9
%endif ; C
; C: src/engine/intro/assintroline.c
%ifdef CBUILD
%include "c/engine/intro/assintroline.inc"
%else
assintroline:
push dword 14h	; 484DA
call __CHK	; 484DF
push ebx	; 484E4
push ecx	; 484E5
push edx	; 484E6
push edi	; 484E7
mov ebx, eax	; 484E8
test byte [byte eax+pflags], 20h	; 484EA
jne near .x	; 484EE
mov eax, dword [byte ebx+temp5-2]	; 484F4
sar eax, 10h	; 484F7
cmp eax, byte 0FFFFFF9Ch	; 484FA
jne short .3	; 484FD
cmp dword [seqtimer], byte 0Ah	; 484FF
jle near .x	; 48506
xor eax, eax	; 4850C
jmp short .2	; 4850E
.1:
mov ebx, eax	; 48510
shl ebx, 7	; 48512
mov ebx, dword [dword ebx+dword_DF848]	; 48515
sar ebx, 10h	; 4851B
cmp ebx, byte 0FFFFFF9Ch	; 4851E
jne near .x	; 48521
inc eax	; 48527
.2:
cmp eax, byte 0Ch	; 48528
jl short assintroline.1	; 4852B
mov dword [seqtimer], 0Ah	; 4852D
pop edi	; 48537
pop edx	; 48538
pop ecx	; 48539
pop ebx	; 4853A
ret	; 4853B
.3:
mov dx, word [byte ebx+temp5]	; 4853C
test dx, dx	; 48540
jle near .7	; 48543
mov ecx, edx	; 48549
dec ecx	; 4854B
mov word [byte ebx+temp5], cx	; 4854C
test cx, cx	; 48550
jle short .7	; 48553
mov eax, 64h	; 48555
call randomd0	; 4855A
test ax, ax	; 4855F
jne short .4	; 48562
mov eax, 2	; 48564
call randomd0	; 48569
mov edx, eax	; 4856E
mov ax, word [byte ebx+temp3]	; 48570
add eax, edx	; 48574
mov word [byte ebx+Xpos+2], ax	; 48576
.4:
test byte [byte ebx+pflags2], 2	; 4857A
jne near .x	; 4857E
mov eax, 50h	; 48584
call randomd0	; 48589
test ax, ax	; 4858E
jne near .x	; 48591
mov eax, 2	; 48597
call randomd0	; 4859C
test ax, ax	; 485A1
je short .5	; 485A4
mov eax, 0DABh	; 485A6
jmp short .6	; 485AB
.5:
mov eax, 0DC3h	; 485AD
.6:
movsx edx, ax	; 485B2
mov eax, ebx	; 485B5
call SetSPA	; 485B7
or byte [byte ebx+pflags2], 2	; 485BC
pop edi	; 485C0
pop edx	; 485C1
pop ecx	; 485C2
pop ebx	; 485C3
ret	; 485C4
.7:
mov dl, byte [byte ebx+pflags]	; 485C5
test dl, 2	; 485C8
je short .8	; 485CB
mov dh, dl	; 485CD
and dh, 0FDh	; 485CF
mov byte [byte ebx+pflags], dh	; 485D2
mov word [byte ebx+temp2], 8	; 485D5
mov word [byte ebx+temp1], 0	; 485DB
mov word [byte ebx+temp3], 0FFF1h	; 485E1
mov word [byte ebx+temp4], 0	; 485E7
or byte [byte ebx+pflags2], 20h	; 485ED
mov word [byte ebx+Wallcos], 0	; 485F1
mov word [byte ebx+Wallsin], 0	; 485F7
mov edx, 0A5Bh	; 485FD
mov eax, ebx	; 48602
call SetSPA	; 48604
xor edi, edi	; 48609
mov word [yc1], di	; 4860B
mov word [RefStep], 1	; 48612
mov word [crowdlevel], 320h	; 4861B
.8:
mov edx, dword [ebx]	; 48624
sar edx, 10h	; 48626
mov eax, dword [byte ebx+temp3-2]	; 48629
sar eax, 10h	; 4862C
sub edx, eax	; 4862F
mov eax, edx	; 48631
mov ecx, dword [byte ebx+Ypos]	; 48633
sar ecx, 10h	; 48636
mov edx, dword [byte ebx+temp4-2]	; 48639
sar edx, 10h	; 4863C
sub ecx, edx	; 4863F
mov edx, ecx	; 48641
mov ecx, eax	; 48643
imul ecx, ecx	; 48645
mov eax, edx	; 48648
imul eax, eax	; 4864A
add eax, ecx	; 4864D
cmp eax, byte 40h	; 4864F
jge near .16	; 48652
cmp word [byte ebx+Xvel], byte 0	; 48658
jge short .9	; 4865D
mov edx, dword [byte ebx+Xvel-2]	; 4865F
sar edx, 10h	; 48662
neg edx	; 48665
jmp short .10	; 48667
.9:
mov edx, dword [byte ebx+Xvel-2]	; 48669
sar edx, 10h	; 4866C
.10:
cmp edx, byte 10h	; 4866F
jge near .16	; 48672
cmp word [byte ebx+Yvel], byte 0	; 48678
jge short .11	; 4867D
mov edx, dword [byte ebx+Yvel-2]	; 4867F
sar edx, 10h	; 48682
neg edx	; 48685
jmp short .12	; 48687
.11:
mov edx, dword [byte ebx+Yvel-2]	; 48689
sar edx, 10h	; 4868C
.12:
cmp edx, byte 10h	; 4868F
jge near .16	; 48692
mov ax, word [byte ebx+temp3]	; 48698
mov word [byte ebx+Xpos+2], ax	; 4869C
mov ax, word [byte ebx+temp4]	; 486A0
mov word [byte ebx+Ypos+2], ax	; 486A4
mov di, word [byte ebx+temp1]	; 486A8
dec edi	; 486AC
mov word [byte ebx+temp1], di	; 486AD
test di, di	; 486B1
jge near .x	; 486B4
mov edx, edi	; 486BA
add edx, byte 8	; 486BC
mov word [byte ebx+temp1], dx	; 486BF
mov edx, 0A5Bh	; 486C3
mov eax, ebx	; 486C8
call SetSPA	; 486CA
mov ax, word [byte ebx+Ypos+2]	; 486CF
neg eax	; 486D3
movsx edx, ax	; 486D5
mov ax, word [byte ebx+Xpos+2]	; 486D8
neg eax	; 486DC
cwde	; 486DE
call vtoa	; 486DF
cwde	; 486E4
mov dword [regd2], eax	; 486E5
mov ax, word [regd2]	; 486EA
mov cx, word [byte ebx+facedir]	; 486F0
cmp ax, cx	; 486F4
je short .15	; 486F7
sub eax, ecx	; 486F9
xor ah, ah	; 486FB
and al, 7	; 486FD
mov word [regd2], ax	; 486FF
cmp ax, 5	; 48705
jge short .13	; 48709
mov eax, 1	; 4870B
jmp short .14	; 48710
.13:
mov eax, 0FFFFFFFFh	; 48712
.14:
mov edx, dword [byte ebx+facedir-2]	; 48717
sar edx, 10h	; 4871A
add eax, edx	; 4871D
and eax, byte 7	; 4871F
mov word [byte ebx+facedir], ax	; 48722
pop edi	; 48726
pop edx	; 48727
pop ecx	; 48728
pop ebx	; 48729
ret	; 4872A
.15:
mov word [byte ebx+Yvel], 0	; 4872B
mov ax, word [byte ebx+Yvel]	; 48731
mov word [byte ebx+Xvel], ax	; 48735
mov word [byte ebx+temp5], 0FF9Ch	; 48739
mov edx, 0C57h	; 4873F
mov eax, ebx	; 48744
call SetSPA	; 48746
pop edi	; 4874B
pop edx	; 4874C
pop ecx	; 4874D
pop ebx	; 4874E
ret	; 4874F
.16:
mov dx, word [byte ebx+temp3]	; 48750
mov word [regd0], dx	; 48754
mov dx, word [byte ebx+temp4]	; 4875B
mov word [regd1], dx	; 4875F
cmp eax, 90h	; 48766
jle short .17	; 4876B
xor edx, edx	; 4876D
mov eax, ebx	; 4876F
call skateto	; 48771
pop edi	; 48776
pop edx	; 48777
pop ecx	; 48778
pop ebx	; 48779
ret	; 4877A
.17:
xor edx, edx	; 4877B
mov eax, ebx	; 4877D
call SkateToSpot	; 4877F
.x:
pop edi	; 48784
pop edx	; 48785
pop ecx	; 48786
pop ebx	; 48787
ret	; 48788
%endif ; C
; AddStar: PC three stars. eax = list index (0-2), edx = team, ebx = player. Stores (team, player) in startm/starpl
; unless the pair is already in the first eax entries. Returns 1 if added, 0 if a duplicate.
; C: src/engine/intro/AddStar.c
%ifdef CBUILD
%include "c/engine/intro/AddStar.inc"
%else
AddStar:
push dword 0Ch	; 48789
call __CHK	; 4878E
push ecx	; 48793
push esi	; 48794
mov esi, eax	; 48795
mov ecx, edx	; 48797
xor edx, edx	; 48799
jmp short .3	; 4879B
.1:
mov eax, edx	; 4879D
shl eax, 2	; 4879F
cmp cx, word [dword eax+startm]	; 487A2
jne short .2	; 487A9
cmp bx, word [dword eax+starpl]	; 487AB
jne short .2	; 487B2
xor eax, eax	; 487B4
pop esi	; 487B6
pop ecx	; 487B7
ret	; 487B8
.2:
inc edx	; 487B9
.3:
movsx eax, si	; 487BA
cmp edx, eax	; 487BD
jl short AddStar.1	; 487BF
mov word [nosplit eax*4+startm], cx	; 487C1
mov word [nosplit eax*4+starpl], bx	; 487C9
mov eax, 1	; 487D1
pop esi	; 487D6
pop ecx	; 487D7
ret	; 487D8
%endif ; C
; C: src/engine/intro/StarEligible.c
%ifdef CBUILD
%include "c/engine/intro/StarEligible.inc"
%else
StarEligible:
push dword 0Ch	; 487D9
call __CHK	; 487DE
push ebx	; 487E3
push ecx	; 487E4
mov ecx, edx	; 487E5
mov edx, eax	; 487E7
shl edx, 8	; 487E9
mov ebx, ecx	; 487EC
mov edx, dword [dword edx+ebx*2+hmtmpdst_m2]	; 487EE
sar edx, 10h	; 487F5
cmp edx, byte 0FFFFFFFFh	; 487F8
jge short .2	; 487FB
.1:
xor eax, eax	; 487FD
pop ecx	; 487FF
pop ebx	; 48800
ret	; 48801
.2:
test eax, eax	; 48802
je short .3	; 48804
mov eax, 6	; 48806
.3:
shl eax, 7	; 4880B
add eax, SortCords	; 4880E
xor edx, edx	; 48813
.4:
mov ebx, dword [byte eax+044h]	; 48815
sar ebx, 18h	; 48818
cmp ebx, ecx	; 4881B
jne short .5	; 4881D
cmp word [byte eax+01Ah], byte 6	; 4881F
jne short .6	; 48824
jmp short StarEligible.1	; 48826
.5:
inc edx	; 48828
add eax, 80h	; 48829
cmp edx, byte 6	; 4882E
jl short StarEligible.4	; 48831
.6:
mov eax, 1	; 48833
pop ecx	; 48838
pop ebx	; 48839
ret	; 4883A
%endif ; C
; StarCompare: qsort comparator for PickThreeStars; player stat points from dword_DB088, +2 for gwgteam/gwgplayer.
StarCompare:
push dword 28h	; 4883B
call __CHK	; 48840
push ebx	; 48845
push ecx	; 48846
push esi	; 48847
push edi	; 48848
push ebp	; 48849
sub esp, byte 10h	; 4884A
mov ecx, eax	; 4884D
mov esi, edx	; 4884F
mov ebx, 19h	; 48851
mov eax, dword [eax]	; 48856
mov edx, dword [ecx]	; 48858
sar edx, 1Fh	; 4885A
idiv ebx	; 4885D
mov edi, eax	; 4885F
mov eax, dword [esi]	; 48861
mov edx, eax	; 48863
sar edx, 1Fh	; 48865
idiv ebx	; 48868
mov ebx, eax	; 4886A
mov ebp, 19h	; 4886C
mov eax, dword [ecx]	; 48871
mov edx, eax	; 48873
sar edx, 1Fh	; 48875
idiv ebp	; 48878
mov ebp, edx	; 4887A
mov ecx, 19h	; 4887C
mov eax, dword [esi]	; 48881
mov edx, eax	; 48883
sar edx, 1Fh	; 48885
idiv ecx	; 48888
mov dword [byte esp+04h], edx	; 4888A
mov edx, edi	; 4888E
mov eax, edx	; 48890
shl eax, 2	; 48892
sub eax, edx	; 48895
shl eax, 3	; 48897
add eax, edx	; 4889A
shl eax, 4	; 4889C
add eax, dword_DB088	; 4889F
mov edx, ebp	; 488A4
shl edx, 4	; 488A6
add edx, eax	; 488A9
mov ecx, ebx	; 488AB
mov eax, ecx	; 488AD
shl eax, 2	; 488AF
sub eax, ecx	; 488B2
shl eax, 3	; 488B4
add eax, ecx	; 488B7
shl eax, 4	; 488B9
mov ecx, dword_DB088	; 488BC
add ecx, eax	; 488C1
mov eax, dword [byte esp+04h]	; 488C3
shl eax, 4	; 488C7
add eax, ecx	; 488CA
mov ecx, dword [edx]	; 488CC
sar ecx, 10h	; 488CE
movsx esi, word [edx]	; 488D1
add ecx, esi	; 488D4
cmp edi, dword [gwgteam]	; 488D6
jne short .1	; 488DC
cmp ebp, dword [gwgplayer]	; 488DE
jne short .1	; 488E4
add ecx, byte 2	; 488E6
.1:
mov esi, dword [eax]	; 488E9
sar esi, 10h	; 488EB
mov dword [esp], esi	; 488EE
movsx esi, word [eax]	; 488F1
add esi, dword [esp]	; 488F4
mov dword [byte esp+08h], esi	; 488F7
cmp ebx, dword [gwgteam]	; 488FB
jne short .2	; 48901
mov esi, dword [byte esp+04h]	; 48903
cmp esi, dword [gwgplayer]	; 48907
jne short .2	; 4890D
add dword [byte esp+08h], byte 2	; 4890F
.2:
mov esi, dword [byte esp+08h]	; 48914
cmp ecx, esi	; 48918
je short .3	; 4891A
mov eax, esi	; 4891C
jmp near .13	; 4891E
.3:
mov si, word [eax]	; 48923
cmp si, word [edx]	; 48926
je short .4	; 48929
movsx eax, si	; 4892B
movsx edx, word [edx]	; 4892E
jmp short .7	; 48931
.4:
test ecx, ecx	; 48933
jle short .5	; 48935
cmp edi, ebx	; 48937
je short .5	; 48939
mov ecx, ebx	; 4893B
shl ecx, 8	; 4893D
mov ecx, dword [dword ecx+hmscore-2]	; 48940
sar ecx, 10h	; 48946
mov dword [esp], ecx	; 48949
mov ecx, edi	; 4894C
shl ecx, 8	; 4894E
mov ecx, dword [dword ecx+hmscore-2]	; 48951
sar ecx, 10h	; 48957
mov esi, dword [esp]	; 4895A
sub esi, ecx	; 4895D
mov ecx, esi	; 4895F
je short .5	; 48961
test esi, esi	; 48963
setg byte [byte esp+0Ch]	; 48965
movzx esi, byte [byte esp+0Ch]	; 4896A
xor esi, ebx	; 4896F
je short .5	; 48971
mov eax, ecx	; 48973
jmp near .x	; 48975
.5:
mov cx, word [byte eax+0Eh]	; 4897A
cmp cx, word [byte edx+0Eh]	; 4897E
je short .8	; 48982
mov eax, dword [byte eax+0Ch]	; 48984
sar eax, 10h	; 48987
mov edx, dword [byte edx+0Ch]	; 4898A
.6:
sar edx, 10h	; 4898D
.7:
sub eax, edx	; 48990
jmp near .x	; 48992
.8:
cmp word [byte eax+06h], byte 0	; 48997
jg short .9	; 4899C
cmp word [byte edx+06h], byte 0	; 4899E
jle short .10	; 489A3
.9:
mov eax, dword [byte eax+04h]	; 489A5
sar eax, 10h	; 489A8
mov edx, dword [byte edx+04h]	; 489AB
jmp short StarCompare.6	; 489AE
.10:
mov edx, ebp	; 489B0
mov eax, edi	; 489B2
call StarEligible	; 489B4
mov ecx, eax	; 489B9
mov edx, dword [byte esp+04h]	; 489BB
mov eax, ebx	; 489BF
call StarEligible	; 489C1
xor ecx, eax	; 489C6
je short .12	; 489C8
test eax, eax	; 489CA
je short .11	; 489CC
mov eax, 1	; 489CE
jmp near .x	; 489D3
.11:
mov eax, 0FFFFFFFFh	; 489D8
jmp near .x	; 489DD
.12:
mov eax, edi	; 489E2
shl eax, 5	; 489E4
sub eax, edi	; 489E7
shl eax, 2	; 489E9
add eax, edi	; 489EC
shl eax, 2	; 489EE
mov edx, unk_DACA0	; 489F1
add edx, eax	; 489F6
mov eax, ebp	; 489F8
shl eax, 2	; 489FA
add eax, ebp	; 489FD
shl eax, 2	; 489FF
add edx, eax	; 48A02
mov eax, ebx	; 48A04
shl eax, 5	; 48A06
sub eax, ebx	; 48A09
shl eax, 2	; 48A0B
add eax, ebx	; 48A0E
shl eax, 2	; 48A10
mov ecx, unk_DACA0	; 48A13
add ecx, eax	; 48A18
mov ebx, dword [byte esp+04h]	; 48A1A
mov eax, ebx	; 48A1E
shl eax, 2	; 48A20
add eax, ebx	; 48A23
shl eax, 2	; 48A25
add eax, ecx	; 48A28
xor ecx, ecx	; 48A2A
mov cl, byte [byte eax+01h]	; 48A2C
xor ebx, ebx	; 48A2F
mov bl, byte [byte eax+02h]	; 48A31
add ecx, ebx	; 48A34
xor ebx, ebx	; 48A36
mov bl, byte [byte eax+04h]	; 48A38
add ebx, ecx	; 48A3B
xor ecx, ecx	; 48A3D
mov cl, byte [byte eax+06h]	; 48A3F
add ebx, ecx	; 48A42
xor ecx, ecx	; 48A44
mov cl, byte [byte eax+09h]	; 48A46
add ecx, ebx	; 48A49
xor ebx, ebx	; 48A4B
mov bl, byte [byte eax+0Ah]	; 48A4D
add ecx, ebx	; 48A50
xor ebx, ebx	; 48A52
mov bl, byte [byte eax+03h]	; 48A54
add ecx, ebx	; 48A57
xor ebx, ebx	; 48A59
mov bl, byte [byte eax+0Dh]	; 48A5B
add ecx, ebx	; 48A5E
xor ebx, ebx	; 48A60
mov bl, byte [byte eax+0Bh]	; 48A62
add ebx, ecx	; 48A65
mov al, byte [byte eax+05h]	; 48A67
and eax, 0FFh	; 48A6A
add ebx, eax	; 48A6F
mov dword [byte esp+08h], ebx	; 48A71
xor ebx, ebx	; 48A75
mov bl, byte [byte edx+01h]	; 48A77
xor eax, eax	; 48A7A
mov al, byte [byte edx+02h]	; 48A7C
add ebx, eax	; 48A7F
xor eax, eax	; 48A81
mov al, byte [byte edx+04h]	; 48A83
add eax, ebx	; 48A86
xor ebx, ebx	; 48A88
mov bl, byte [byte edx+06h]	; 48A8A
add ebx, eax	; 48A8D
xor eax, eax	; 48A8F
mov al, byte [byte edx+09h]	; 48A91
add ebx, eax	; 48A94
xor eax, eax	; 48A96
mov al, byte [byte edx+0Ah]	; 48A98
add ebx, eax	; 48A9B
xor eax, eax	; 48A9D
mov al, byte [byte edx+03h]	; 48A9F
add ebx, eax	; 48AA2
xor eax, eax	; 48AA4
mov al, byte [byte edx+0Dh]	; 48AA6
add eax, ebx	; 48AA9
xor ecx, ecx	; 48AAB
mov cl, byte [byte edx+0Bh]	; 48AAD
add ecx, eax	; 48AB0
xor eax, eax	; 48AB2
mov al, byte [byte edx+05h]	; 48AB4
add ecx, eax	; 48AB7
mov eax, dword [byte esp+08h]	; 48AB9
.13:
sub eax, ecx	; 48ABD
.x:
add esp, byte 10h	; 48ABF
pop ebp	; 48AC2
pop edi	; 48AC3
pop esi	; 48AC4
pop ecx	; 48AC5
pop ebx	; 48AC6
ret	; 48AC7
; PickThreeStars: PC three stars. Empties startm/starpl, records the winner (gwgteam, gwgplayer = its team field 2Eh)
; when the scores differ, then fills the 3 stars from the qsorted players (StarCompare) with AddStar.
; C: src/engine/intro/FadeOutPalCycle.c (PickThreeStars)
%ifdef CBUILD
%include "c/engine/intro/FadeOutPalCycle.PickThreeStars.inc"
%else
PickThreeStars:
push dword 0F4h	; 48AC8
call __CHK	; 48ACD
push ebx	; 48AD2
push ecx	; 48AD3
push edx	; 48AD4
push esi	; 48AD5
push edi	; 48AD6
push ebp	; 48AD7
sub esp, 0D8h	; 48AD8
xor edi, edi	; 48ADE
xor ecx, ecx	; 48AE0
mov esi, 0FFFFFFFFh	; 48AE2
jmp short .2	; 48AE7
.1:
movsx eax, cx	; 48AE9
mov word [nosplit eax*4+starpl], si	; 48AEC
mov word [nosplit eax*4+startm], si	; 48AF4
inc ecx	; 48AFC
.2:
cmp cx, byte 3	; 48AFD
jl short PickThreeStars.1	; 48B01
mov edx, 0FFFFFFFFh	; 48B03
mov dword [gwgplayer], edx	; 48B08
mov dword [gwgteam], edx	; 48B0E
cmp dword [curperiod], byte 3	; 48B14
jle near .3	; 48B1B
mov cx, word [awscore]	; 48B21
sub cx, word [hmscore]	; 48B28
je short .3	; 48B2F
test cx, cx	; 48B31
setg al	; 48B34
xor ch, ch	; 48B37
mov cl, al	; 48B39
cmp word [lasttouch], byte 6	; 48B3B
setl al	; 48B43
and eax, 0FFh	; 48B46
movsx esi, cx	; 48B4B
xor eax, esi	; 48B4E
je short .3	; 48B50
mov dword [gwgteam], esi	; 48B52
mov eax, esi	; 48B58
shl eax, 8	; 48B5A
mov eax, dword [dword eax+word_DF644-2]	; 48B5D
sar eax, 10h	; 48B63
mov dword [gwgplayer], eax	; 48B66
mov edx, dword [awscore-2]	; 48B6B
sar edx, 10h	; 48B71
mov eax, dword [hmscore-2]	; 48B74
sar eax, 10h	; 48B79
call IsCupClinched	; 48B7C
test eax, eax	; 48B81
je short .3	; 48B83
mov ebx, dword [gwgplayer-2]	; 48B85
sar ebx, 10h	; 48B8B
movsx eax, di	; 48B8E
mov edx, esi	; 48B91
call AddStar	; 48B93
add edi, eax	; 48B98
.3:
xor ecx, ecx	; 48B9A
jmp near .8	; 48B9C
.4:
test cx, cx	; 48BA1
sete al	; 48BA4
and eax, 0FFh	; 48BA7
shl eax, 8	; 48BAC
cmp word [dword eax+hmscore], byte 0	; 48BAF
jne near .7	; 48BB7
xor esi, esi	; 48BBD
movsx edx, cx	; 48BBF
mov eax, edx	; 48BC2
shl eax, 3	; 48BC4
add eax, edx	; 48BC7
mov dx, word [nosplit eax*2+word_DC248]	; 48BC9
cmp dx, word [nosplit eax*2+word_DC242]	; 48BD1
jle short .5	; 48BD9
mov esi, 1	; 48BDB
.5:
movsx edx, cx	; 48BE0
mov eax, edx	; 48BE3
shl eax, 3	; 48BE5
add eax, edx	; 48BE8
add eax, eax	; 48BEA
mov dx, word [dword eax+word_DC24E]	; 48BEC
cmp dx, word [dword eax+word_DC242]	; 48BF3
jle short .6	; 48BFA
cmp dx, word [dword eax+word_DC248]	; 48BFC
jle short .6	; 48C03
mov esi, 2	; 48C05
.6:
movsx edx, cx	; 48C0A
mov ebp, edx	; 48C0D
shl ebp, 3	; 48C0F
add ebp, edx	; 48C12
add ebp, ebp	; 48C14
movsx ebx, si	; 48C16
mov eax, ebx	; 48C19
shl eax, 2	; 48C1B
sub eax, ebx	; 48C1E
add eax, eax	; 48C20
add eax, ebp	; 48C22
mov ebp, dword [gameopts]	; 48C24
shl ebp, 14h	; 48C2A
shr ebp, 1Eh	; 48C2D
movsx bx, byte [dword ebp+byte_CC9E4]	; 48C30
cmp bx, word [dword eax+word_DC242]	; 48C38
jge short .7	; 48C3F
add esi, byte 19h	; 48C41
movsx ebx, si	; 48C44
movsx eax, di	; 48C47
call AddStar	; 48C4A
add edi, eax	; 48C4F
.7:
inc ecx	; 48C51
.8:
cmp cx, byte 2	; 48C52
jl near PickThreeStars.4	; 48C56
xor eax, eax	; 48C5C
mov word [dword esp+0D4h], ax	; 48C5E
xor ecx, ecx	; 48C66
jmp near .12	; 48C68
.9:
movsx ebx, cx	; 48C6D
mov esi, 19h	; 48C70
mov eax, ebx	; 48C75
mov edx, ebx	; 48C77
sar edx, 1Fh	; 48C79
idiv esi	; 48C7C
mov ebp, eax	; 48C7E
shl eax, 4	; 48C80
add eax, ebp	; 48C83
shl eax, 4	; 48C85
add eax, ebp	; 48C88
shl eax, 2	; 48C8A
mov dword [dword esp+0C8h], eax	; 48C8D
mov eax, ebx	; 48C94
mov edx, ebx	; 48C96
sar edx, 1Fh	; 48C98
idiv esi	; 48C9B
mov eax, edx	; 48C9D
shl eax, 2	; 48C9F
add eax, edx	; 48CA2
shl eax, 3	; 48CA4
sub eax, edx	; 48CA7
add eax, dword [dword esp+0C8h]	; 48CA9
movzx si, byte [dword eax+hmroster]	; 48CB0
test si, si	; 48CB8
je short .11	; 48CBB
cmp si, byte 2	; 48CBD
je short .11	; 48CC1
mov eax, ebp	; 48CC3
shl eax, 2	; 48CC5
sub eax, ebp	; 48CC8
shl eax, 3	; 48CCA
add eax, ebp	; 48CCD
shl eax, 4	; 48CCF
add eax, dword_DB088	; 48CD2
shl edx, 4	; 48CD7
add eax, edx	; 48CDA
cmp si, byte 1	; 48CDC
jne short .10	; 48CE0
cmp word [eax], byte 0	; 48CE2
jne short .10	; 48CE6
cmp word [byte eax+Xpos+2], byte 0	; 48CE8
jne short .10	; 48CED
cmp word [byte eax+04h], byte 0	; 48CEF
jne short .10	; 48CF4
cmp word [byte eax+Ypos+2], byte 0	; 48CF6
jne short .10	; 48CFB
cmp word [byte eax+Yvel], byte 0	; 48CFD
je short .11	; 48D02
.10:
movsx edx, cx	; 48D04
mov eax, dword [dword esp+0D2h]	; 48D07
sar eax, 10h	; 48D0E
mov dword [esp+eax*4], edx	; 48D11
inc word [dword esp+0D4h]	; 48D14
.11:
inc ecx	; 48D1C
.12:
cmp cx, byte 32h	; 48D1D
jl near PickThreeStars.9	; 48D21
mov edx, dword [dword esp+0D2h]	; 48D27
sar edx, 10h	; 48D2E
mov ecx, StarCompare	; 48D31
mov ebx, 4	; 48D36
mov eax, esp	; 48D3B
call qsort_	; 48D3D
xor ecx, ecx	; 48D42
jmp near .22	; 48D44
.13:
movsx esi, cx	; 48D49
mov si, word [esp+esi*4]	; 48D4C
movsx ebx, si	; 48D50
mov esi, 19h	; 48D53
mov eax, ebx	; 48D58
mov edx, ebx	; 48D5A
sar edx, 1Fh	; 48D5C
idiv esi	; 48D5F
mov esi, eax	; 48D61
shl eax, 2	; 48D63
sub eax, esi	; 48D66
shl eax, 3	; 48D68
add eax, esi	; 48D6B
shl eax, 4	; 48D6D
mov dword [dword esp+0C8h], eax	; 48D70
mov ebp, 19h	; 48D77
mov eax, ebx	; 48D7C
mov edx, ebx	; 48D7E
sar edx, 1Fh	; 48D80
idiv ebp	; 48D83
mov eax, edx	; 48D85
shl eax, 4	; 48D87
add eax, dword [dword esp+0C8h]	; 48D8A
mov ebx, dword [dword eax+word_DB08A-2]	; 48D91
sar ebx, 10h	; 48D97
mov eax, dword [dword eax+dword_DB088-2]	; 48D9A
sar eax, 10h	; 48DA0
add eax, ebx	; 48DA3
cmp eax, byte 1	; 48DA5
jle short .14	; 48DA8
movsx ebx, dx	; 48DAA
movsx edx, si	; 48DAD
movsx eax, di	; 48DB0
call AddStar	; 48DB3
add edi, eax	; 48DB8
cmp di, byte 3	; 48DBA
jge near .20	; 48DBE
jmp near .21	; 48DC4
.14:
xor esi, esi	; 48DC9
jmp near .17	; 48DCB
.15:
movsx ebx, si	; 48DD0
mov ebp, 3	; 48DD3
mov eax, ebx	; 48DD8
mov edx, ebx	; 48DDA
sar edx, 1Fh	; 48DDC
idiv ebp	; 48DDF
mov dword [dword esp+0CCh], eax	; 48DE1
mov edx, eax	; 48DE8
shl eax, 3	; 48DEA
add eax, edx	; 48DED
add eax, eax	; 48DEF
mov dword [dword esp+0D0h], eax	; 48DF1
mov eax, ebx	; 48DF8
mov edx, ebx	; 48DFA
sar edx, 1Fh	; 48DFC
idiv ebp	; 48DFF
mov ebp, edx	; 48E01
mov eax, edx	; 48E03
shl eax, 2	; 48E05
sub eax, edx	; 48E08
add eax, eax	; 48E0A
mov ebx, dword [dword esp+0D0h]	; 48E0C
add ebx, eax	; 48E13
mov eax, dword [gameopts]	; 48E15
shl eax, 14h	; 48E1A
shr eax, 1Eh	; 48E1D
movsx ax, byte [dword eax+byte_CC9E7]	; 48E20
cmp ax, word [dword ebx+word_DC242]	; 48E28
jg short .16	; 48E2F
mov edx, dword [dword ebx+word_DC244-2]	; 48E31
sar edx, 10h	; 48E37
mov eax, edx	; 48E3A
shl eax, 5	; 48E3C
sub eax, edx	; 48E3F
shl eax, 2	; 48E41
add eax, edx	; 48E44
shl eax, 3	; 48E46
mov dword [dword esp+0C8h], eax	; 48E49
mov ebx, dword [dword ebx+word_DC242-2]	; 48E50
sar ebx, 10h	; 48E56
mov eax, ebx	; 48E59
mov edx, ebx	; 48E5B
sar edx, 1Fh	; 48E5D
LD sub, eax, edx	; 48E60
sar eax, 1	; 48E62
mov edx, dword [dword esp+0C8h]	; 48E64
add edx, eax	; 48E6B
mov eax, edx	; 48E6D
sar edx, 1Fh	; 48E6F
idiv ebx	; 48E72
cmp eax, byte 4Bh	; 48E74
jg short .16	; 48E77
lea eax, [byte ebp+019h]	; 48E79
movsx ebx, ax	; 48E7C
mov eax, dword [dword esp+0CCh]	; 48E7F
movsx edx, ax	; 48E86
movsx eax, di	; 48E89
call AddStar	; 48E8C
add edi, eax	; 48E91
cmp di, byte 3	; 48E93
jge short .20	; 48E97
.16:
inc esi	; 48E99
.17:
cmp si, byte 6	; 48E9A
jl near PickThreeStars.15	; 48E9E
.18:
mov ebp, 19h	; 48EA4
.19:
cmp cx, word [dword esp+0D4h]	; 48EA9
jl short .23	; 48EB1
.20:
add esp, 0D8h	; 48EB3
jmp near PreGameIntro_popebp	; 48EB9
.21:
inc ecx	; 48EBE
.22:
cmp cx, word [dword esp+0D4h]	; 48EBF
jl near PickThreeStars.13	; 48EC7
jmp short PickThreeStars.18	; 48ECD
.23:
movsx esi, cx	; 48ECF
mov si, word [esp+esi*4]	; 48ED2
movsx ebx, si	; 48ED6
mov esi, 19h	; 48ED9
mov eax, ebx	; 48EDE
mov edx, ebx	; 48EE0
sar edx, 1Fh	; 48EE2
idiv esi	; 48EE5
movsx esi, dx	; 48EE7
mov eax, ebx	; 48EEA
mov edx, ebx	; 48EEC
sar edx, 1Fh	; 48EEE
idiv ebp	; 48EF1
movsx edx, ax	; 48EF3
movsx eax, di	; 48EF6
mov ebx, esi	; 48EF9
call AddStar	; 48EFB
add edi, eax	; 48F00
cmp di, byte 3	; 48F02
jge short PickThreeStars.20	; 48F06
inc ecx	; 48F08
jmp short PickThreeStars.19	; 48F09
%endif ; C
; StartThreeStars: PC end-of-game set-up for the three-stars ceremony (assthreestars, asstab 15h): PickThreeStars,
; clears the clock line-change signal state, stops the clock, empties the penalty boxes and places the players.
; C: src/engine/intro/FadeOutPalCycle.c (StartThreeStars)
%ifdef CBUILD
%include "c/engine/intro/FadeOutPalCycle.StartThreeStars.inc"
%else
StartThreeStars:
push dword 24h	; 48F0B
call __CHK	; 48F10
push ebx	; 48F15
push ecx	; 48F16
push edx	; 48F17
push esi	; 48F18
push edi	; 48F19
mov edx, dword [dword_CC0EC]	; 48F1A
test edx, edx	; 48F20
jne near PreGameIntro_popx	; 48F22
mov esi, dword [curperiod]	; 48F28
mov dword [joysampling], edx	; 48F2E
call joyq_flush	; 48F34
push savepal	; 48F39
push dword 100h	; 48F3E
push edx	; 48F43
call sub_8FFB0	; 48F44
add esp, byte 0Ch	; 48F49
mov ebx, 10h	; 48F4C
mov edx, savepal	; 48F51
mov eax, 1	; 48F56
call FadePalette	; 48F5B
mov word [fadeinpending], 1	; 48F60
call PickThreeStars	; 48F69
mov byte [byte_E9AC8], 0FFh	; 48F6E
xor ebx, ebx	; 48F75
mov word [word_CBC44], bx	; 48F77
mov word [RefPen], bx	; 48F7E
mov word [refsignal], bx	; 48F85
mov word [Penaltytimer], bx	; 48F8C
mov word [bannertimer], bx	; 48F93
mov word [word_CBEC6], bx	; 48F9A
mov word [lcboxon+2], bx	; 48FA1
mov word [lcboxon], bx	; 48FA8
mov word [lcblink+2], bx	; 48FAF
mov word [lcblink], bx	; 48FB6
mov word [energywarn+2], bx	; 48FBD
mov word [energywarn], bx	; 48FC4
mov word [lcrequest+2], bx	; 48FCB
mov word [lcrequest], bx	; 48FD2
mov eax, dword [ovlseq-2]	; 48FD9
sar eax, 10h	; 48FDE
cmp eax, byte 0FFFFFFFFh	; 48FE1
je short .1	; 48FE4
mov ecx, dword [dword_E0244]	; 48FE6
push ecx	; 48FEC
call FreeMemBlock	; 48FED
add esp, byte 4	; 48FF2
.1:
mov edx, 0FFFFFFFFh	; 48FF5
mov word [bannermsg], dx	; 48FFA
mov word [ovlstep], dx	; 49001
mov word [ovlseq], dx	; 49008
xor dl, dl	; 4900F
mov byte [textline5], dl	; 49011
mov byte [textline4], dl	; 49017
mov byte [textline2], dl	; 4901D
mov byte [textline1], dl	; 49023
mov byte [textline3], dl	; 49029
mov dword [curperiod], 0FFFFFFFFh	; 4902F
xor edi, edi	; 49039
mov word [exitgame], di	; 4903B
mov word [gameover], di	; 49042
mov ch, byte [gmode]	; 49049
or ch, 1	; 4904F
mov byte [gmode], ch	; 49052
mov al, ch	; 49058
and al, 7Fh	; 4905A
mov byte [gmode], al	; 4905C
mov dword [seqtimer], 2EE0h	; 49061
mov edx, 0FFFFFFFFh	; 4906B
mov word [c2playernum], dx	; 49070
mov word [c1playernum], dx	; 49077
xor ah, ah	; 4907E
mov byte [PBnum+1], ah	; 49080
xor dl, dl	; 49086
mov byte [PBnum], dl	; 49088
mov ebx, SortCords	; 4908E
xor ecx, ecx	; 49093
.2:
mov word [byte ebx+Xpos+2], 0FF38h	; 49095
mov ax, word [byte ebx+Xpos+2]	; 4909B
mov word [byte ebx+temp3], ax	; 4909F
mov word [byte ebx+Ypos+2], 0	; 490A3
mov ax, word [byte ebx+Ypos+2]	; 490A9
mov word [byte ebx+temp4], ax	; 490AD
mov word [byte ebx+temp5], 0FF9Ch	; 490B1
mov word [byte ebx+Yvel], 0	; 490B7
mov ax, word [byte ebx+Yvel]	; 490BD
mov word [byte ebx+Xvel], ax	; 490C1
mov word [byte ebx+012h], 0FFFFh	; 490C5
mov byte [byte ebx+newpos], 0FFh	; 490CB
mov al, byte [byte ebx+newpos]	; 490CF
mov byte [byte ebx+newpnum], al	; 490D2
xor edx, edx	; 490D5
mov eax, ebx	; 490D7
call SetSPA	; 490D9
xor edx, edx	; 490DE
mov eax, ebx	; 490E0
call assreplace	; 490E2
and byte [byte ebx+pflags], 0D7h	; 490E7
or byte [byte ebx+pflags2], 4	; 490EB
inc ecx	; 490EF
add ebx, 80h	; 490F0
cmp ecx, byte 0Ch	; 490F6
jl short StartThreeStars.2	; 490F9
mov ecx, 78h	; 490FB
mov word [puckstruct+28h], cx	; 49100
mov edi, 0C8h	; 49107
mov word [puckstruct+2], di	; 4910C
mov word [puckstruct+6], 0FED4h	; 49113
xor edx, edx	; 4911C
mov word [puckstruct+0Ch], dx	; 4911E
mov word [puckstruct+0Eh], dx	; 49125
mov edx, 1Ah	; 4912C
mov eax, puckstruct	; 49131
call assreplace	; 49136
mov ebx, puckstruct	; 4913B
add ebx, 80h	; 49140
mov word [byte ebx+temp2], cx	; 49146
mov word [byte ebx+Xpos+2], di	; 4914A
mov word [byte ebx+Ypos+2], 0FED4h	; 4914E
mov word [byte ebx+Xvel], 0	; 49154
mov word [byte ebx+Yvel], 0	; 4915A
mov edx, 19h	; 49160
mov eax, ebx	; 49165
call assreplace	; 49167
xor ecx, ecx	; 4916C
mov word [word_E0042], cx	; 4916E
mov edi, 0FFFFFF38h	; 49175
mov word [SortCords+802h], di	; 4917A
mov word [word_E0046], di	; 49181
mov word [word_E0022], cx	; 49188
mov word [word_E0048], cx	; 4918F
mov word [word_E002A], cx	; 49196
mov word [word_E0028], cx	; 4919D
xor edx, edx	; 491A4
mov eax, SortCords+800h	; 491A6
call SetSPA	; 491AB
mov word [word_E002E], 0FFFFh	; 491B0
mov edx, 15h	; 491B9
mov eax, SortCords+800h	; 491BE
call assreplace	; 491C3
mov word [RefStep], cx	; 491C8
or byte [sflags], 40h	; 491CF
call DoGameFrame	; 491D6
call DoGameFrame	; 491DB
call SprSort	; 491E0
xor eax, eax	; 491E5
mov dword [frameaccum], eax	; 491E7
mov dword [inputframes], eax	; 491EC
mov eax, dword [puckc]	; 491F1
mov byte [eax], 0FFh	; 491F6
mov ebx, 0FFFFFFE0h	; 491F9
mov word [camx], bx	; 491FE
mov word [xc1], bx	; 49205
mov word [camy], cx	; 4920C
mov word [yc1], cx	; 49213
call CloseTextOverlay	; 4921A
call ThreeStarsLoop	; 4921F
test eax, eax	; 49224
jge short .3	; 49226
mov word [crowdlevel], cx	; 49228
.3:
mov dword [curperiod], esi	; 4922F
call CrowdFadeOut	; 49235
xor ebx, ebx	; 4923A
mov word [crowdlevel], bx	; 4923C
cmp byte [musicon], 0	; 49243
je short .4	; 4924A
call MusicChanReset	; 4924C
jmp near PreGameIntro_popx	; 49251
.4:
call sub_8F633	; 49256
jmp near PreGameIntro_popx	; 4925B
%endif ; C
; C: src/engine/intro/MoveInDir.c
%ifdef CBUILD
%include "c/engine/intro/MoveInDir.inc"
%else
MoveInDir:
push dword 8	; 49260
call __CHK	; 49265
push ebx	; 4926A
mov ebx, eax	; 4926B
cmp word [byte eax+position], byte 0	; 4926D
jne short .1	; 49272
movsx edx, dx	; 49274
call goalieacc	; 49277
pop ebx	; 4927C
ret	; 4927D
.1:
xor dh, dh	; 4927E
and dl, 0Fh	; 49280
cmp dx, byte 7	; 49283
jle short .3	; 49287
cmp dx, byte 9	; 49289
jne short .2	; 4928D
mov eax, dword [byte eax+Xvel-2]	; 4928F
sar eax, 10h	; 49292
mov edx, dword [byte ebx+Yvel-2]	; 49295
sar edx, 10h	; 49298
or eax, edx	; 4929B
je short .2	; 4929D
mov eax, ebx	; 4929F
call stopna	; 492A1
pop ebx	; 492A6
ret	; 492A7
.2:
test byte [byte ebx+pflags2], 2	; 492A8
jne short .x	; 492AC
mov edx, 289h	; 492AE
mov eax, ebx	; 492B3
call SetSPA	; 492B5
pop ebx	; 492BA
ret	; 492BB
.3:
sub dx, word [byte eax+facedir]	; 492BC
je short .4	; 492C0
movsx edx, dx	; 492C2
mov eax, edx	; 492C5
neg eax	; 492C7
and eax, byte 4	; 492C9
sar eax, 1	; 492CC
mov edx, dword [byte ebx+facedir-2]	; 492CE
sar edx, 10h	; 492D1
dec eax	; 492D4
add eax, edx	; 492D5
and eax, byte 7	; 492D7
mov word [byte ebx+facedir], ax	; 492DA
.4:
mov edx, 2E9h	; 492DE
mov eax, ebx	; 492E3
call SetSPA	; 492E5
mov edx, dword [byte ebx+facedir-2]	; 492EA
sar edx, 10h	; 492ED
mov eax, ebx	; 492F0
call playeracc	; 492F2
.x:
pop ebx	; 492F7
ret	; 492F8
%endif ; C
; C: src/engine/intro/SteerToTarget.c
%ifdef CBUILD
%include "c/engine/intro/SteerToTarget.inc"
%else
SteerToTarget:
push dword 10h	; 492F9
call __CHK	; 492FE
push ebx	; 49303
push ecx	; 49304
push edx	; 49305
mov ebx, eax	; 49306
mov ah, byte [byte eax+029h]	; 49308
dec ah	; 4930B
mov byte [byte ebx+029h], ah	; 4930D
test ah, ah	; 49310
jge near .7	; 49312
mov dh, ah	; 49318
add dh, 0Ch	; 4931A
mov byte [byte ebx+029h], dh	; 4931D
mov eax, dword [byte ebx+0Ah]	; 49320
sar eax, 18h	; 49323
mov edx, dword [regd0-2]	; 49326
sar edx, 10h	; 4932C
sub edx, eax	; 4932F
mov eax, dword [ebx]	; 49331
sar eax, 10h	; 49333
sub edx, eax	; 49336
mov word [regd0], dx	; 49338
mov eax, dword [byte ebx+0Ch]	; 4933F
sar eax, 18h	; 49342
mov edx, dword [regd1-2]	; 49345
sar edx, 10h	; 4934B
sub edx, eax	; 4934E
mov eax, dword [byte ebx+Ypos]	; 49350
sar eax, 10h	; 49353
sub edx, eax	; 49356
mov word [regd1], dx	; 49358
cmp word [regd0], byte 0	; 4935F
jge short .1	; 49367
mov eax, dword [regd0-2]	; 49369
sar eax, 10h	; 4936E
neg eax	; 49371
jmp short .2	; 49373
.1:
mov eax, dword [regd0-2]	; 49375
sar eax, 10h	; 4937A
.2:
cmp eax, byte 0Ch	; 4937D
jg short .5	; 49380
cmp word [regd1], byte 0	; 49382
jge short .3	; 4938A
mov eax, dword [regd1-2]	; 4938C
sar eax, 10h	; 49391
neg eax	; 49394
jmp short .4	; 49396
.3:
mov eax, dword [regd1-2]	; 49398
sar eax, 10h	; 4939D
.4:
cmp eax, byte 0Ch	; 493A0
jg short .5	; 493A3
mov word [regd0], 9	; 493A5
jmp short .6	; 493AE
.5:
mov edx, dword [regd1-2]	; 493B0
sar edx, 10h	; 493B6
mov eax, dword [regd0-2]	; 493B9
sar eax, 10h	; 493BE
call vtoa	; 493C1
mov word [regd0], ax	; 493C6
.6:
mov al, byte [regd0]	; 493CC
mov byte [byte ebx+028h], al	; 493D1
cmp word [regd0], byte 7	; 493D4
jle short .7	; 493DC
mov edx, dword [byte ebx+Xvel-2]	; 493DE
sar edx, 10h	; 493E1
mov eax, dword [byte ebx+Yvel-2]	; 493E4
sar eax, 10h	; 493E7
or eax, edx	; 493EA
jne short .7	; 493EC
mov ax, word [byte ebx+temp3]	; 493EE
mov dx, word [byte ebx+Xpos+2]	; 493F2
sub eax, edx	; 493F6
mov word [regd0], ax	; 493F8
mov ax, word [byte ebx+temp4]	; 493FE
mov cx, word [byte ebx+Ypos+2]	; 49402
sub eax, ecx	; 49406
mov word [regd1], ax	; 49408
mov edx, dword [regd1-2]	; 4940E
sar edx, 10h	; 49414
mov eax, dword [regd0-2]	; 49417
sar eax, 10h	; 4941C
call vtoa	; 4941F
mov dx, word [byte ebx+facedir]	; 49424
sub dx, ax	; 49428
mov word [regd0], dx	; 4942B
je short .7	; 49432
mov eax, edx	; 49434
xor ah, dh	; 49436
and al, 4	; 49438
cwde	; 4943A
mov edx, eax	; 4943B
sar edx, 1	; 4943D
mov eax, dword [byte ebx+facedir-2]	; 4943F
sar eax, 10h	; 49442
add eax, edx	; 49445
dec eax	; 49447
and eax, byte 7	; 49448
mov word [byte ebx+facedir], ax	; 4944B
.7:
mov edx, dword [byte ebx+025h]	; 4944F
sar edx, 18h	; 49452
mov eax, ebx	; 49455
call MoveInDir	; 49457
pop edx	; 4945C
pop ecx	; 4945D
pop ebx	; 4945E
ret	; 4945F
%endif ; C
; C: src/engine/intro/assstarskate.c
%ifdef CBUILD
%include "c/engine/intro/assstarskate.inc"
%else
assstarskate:
push dword 14h	; 49460
call __CHK	; 49465
push ebx	; 4946A
push ecx	; 4946B
push edx	; 4946C
push edi	; 4946D
mov ebx, eax	; 4946E
test byte [byte eax+pflags], 20h	; 49470
jne near .x	; 49474
mov dl, byte [byte ebx+pflags]	; 4947A
test dl, 2	; 4947D
je near .3	; 49480
mov dh, dl	; 49486
and dh, 0FDh	; 49488
mov byte [byte ebx+pflags], dh	; 4948B
mov word [byte ebx+temp5], 0	; 4948E
mov word [byte ebx+temp2], 8	; 49494
test byte [byte ebx+pflags], 40h	; 4949A
setne al	; 4949E
xor ah, ah	; 494A1
mov edx, eax	; 494A3
cmp word [byte ebx+position], byte 0	; 494A5
je short .1	; 494AA
test ax, ax	; 494AC
jne short .1	; 494AF
mov ax, word [hmscore]	; 494B1
cmp ax, word [awscore]	; 494B7
jle short .1	; 494BE
mov eax, 8	; 494C0
call randomd0	; 494C5
mov word [byte ebx+temp1], ax	; 494CA
jmp short .2	; 494CE
.1:
mov word [byte ebx+temp1], 0FFFFh	; 494D0
.2:
mov eax, dword [byte ebx+temp5-2]	; 494D6
sar eax, 10h	; 494D9
movsx edx, dx	; 494DC
shl edx, 4	; 494DF
mov ax, word [dword edx+eax*4+word_CC9EA]	; 494E2
mov word [byte ebx+temp3], ax	; 494EA
mov eax, dword [byte ebx+temp5-2]	; 494EE
sar eax, 10h	; 494F1
mov ax, word [dword edx+eax*4+word_CC9EC]	; 494F4
mov word [byte ebx+temp4], ax	; 494FC
.3:
mov edx, dword [ebx]	; 49500
sar edx, 10h	; 49502
mov eax, dword [byte ebx+temp3-2]	; 49505
sar eax, 10h	; 49508
sub edx, eax	; 4950B
mov eax, dword [byte ebx+Ypos]	; 4950D
sar eax, 10h	; 49510
mov ecx, dword [byte ebx+temp4-2]	; 49513
sar ecx, 10h	; 49516
sub eax, ecx	; 49519
imul edx, edx	; 4951B
imul eax, eax	; 4951E
add eax, edx	; 49521
cmp eax, 384h	; 49523
jge short .5	; 49528
mov di, word [byte ebx+temp5]	; 4952A
inc edi	; 4952E
mov word [byte ebx+temp5], di	; 4952F
cmp di, byte 3	; 49533
jle short .4	; 49537
mov eax, ebx	; 49539
call assexit	; 4953B
pop edi	; 49540
pop edx	; 49541
pop ecx	; 49542
pop ebx	; 49543
ret	; 49544
.4:
test byte [byte ebx+pflags], 40h	; 49545
setne al	; 49549
xor ah, ah	; 4954C
mov edx, dword [byte ebx+temp5-2]	; 4954E
sar edx, 10h	; 49551
shl edx, 2	; 49554
cwde	; 49557
shl eax, 4	; 49558
mov dx, word [dword edx+eax+word_CC9EA]	; 4955B
mov word [byte ebx+temp3], dx	; 49563
mov edx, dword [byte ebx+temp5-2]	; 49567
sar edx, 10h	; 4956A
mov ax, word [dword eax+edx*4+word_CC9EC]	; 4956D
mov word [byte ebx+temp4], ax	; 49575
mov ax, word [byte ebx+temp1]	; 49579
cmp ax, word [byte ebx+temp5]	; 4957D
jne short .5	; 49581
or byte [byte ebx+pflags], 20h	; 49583
mov edx, 731h	; 49587
mov eax, ebx	; 4958C
call SetSPA	; 4958E
pop edi	; 49593
pop edx	; 49594
pop ecx	; 49595
pop ebx	; 49596
ret	; 49597
.5:
mov ax, word [byte ebx+temp3]	; 49598
mov word [regd0], ax	; 4959C
mov ax, word [byte ebx+temp4]	; 495A2
mov word [regd1], ax	; 495A6
mov eax, ebx	; 495AC
call SteerToTarget	; 495AE
.x:
pop edi	; 495B3
pop edx	; 495B4
pop ecx	; 495B5
pop ebx	; 495B6
ret	; 495B7
%endif ; C
; assthreestars: asstab 15h. Announces star temp1: "%s Star" with 1st/2nd/3rd, the player's name, "EA Sports".
assthreestars:
push dword 2Ch	; 495B8
call __CHK	; 495BD
push ebx	; 495C2
push ecx	; 495C3
push edx	; 495C4
push esi	; 495C5
push edi	; 495C6
push ebp	; 495C7
sub esp, byte 4	; 495C8
mov ebp, eax	; 495CB
mov eax, dword [ovltimer-2]	; 495CD
sar eax, 10h	; 495D2
cmp eax, byte 0FFFFFFFFh	; 495D5
je short .1	; 495D8
mov dx, word [ovltimer]	; 495DA
cmp dx, byte 10h	; 495E1
jl near .16	; 495E5
cmp dx, 258h	; 495EB
jl short .1	; 495F0
cmp dx, 268h	; 495F2
jl near .16	; 495F7
.1:
mov ah, byte [byte ebp+pflags]	; 495FD
test ah, 2	; 49600
je near .5	; 49603
mov dl, ah	; 49609
and dl, 0FDh	; 4960B
mov byte [byte ebp+pflags], dl	; 4960E
mov edi, textline3	; 49611
mov esi, str_EASports	; 49616
movsd	; 4961B
movsd	; 4961C
movsw	; 4961D
xor dh, dh	; 4961F
mov byte [textline5], dh	; 49621
mov byte [textline4], dh	; 49627
mov word [byte ebp+temp1], 2	; 4962D
mov eax, 14h	; 49633
call randomd0	; 49638
add eax, 14h	; 4963D
mov word [byte ebp+temp2], ax	; 49642
test byte [gameopts+1], 1	; 49646
je short .2	; 4964D
cmp byte [musicon], 0	; 4964F
je short .2	; 49656
mov esi, eax	; 49658
add esi, 0DCh	; 4965A
mov word [byte ebp+temp2], si	; 49660
.2:
mov word [byte ebp+temp3], 0FFFFh	; 49664
mov ebx, dword [byte ebp+temp1-2]	; 4966A
sar ebx, 10h	; 4966D
mov esi, dword [nosplit ebx*4+startm_m2]	; 49670
sar esi, 10h	; 49677
mov edi, dword [nosplit ebx*4+startm]	; 4967A
sar edi, 10h	; 49681
mov edx, dword [nosplit ebx*4+starordtab]	; 49684
push edx	; 4968B
push str_StarFmt	; 4968C
push textline1	; 49691
call sprintf_	; 49696
add esp, byte 0Ch	; 4969B
push unk_C1B3E	; 4969E
mov edx, esi	; 496A3
shl edx, 4	; 496A5
add edx, esi	; 496A8
shl edx, 4	; 496AA
add edx, esi	; 496AD
shl edx, 2	; 496AF
mov ecx, hmroster	; 496B2
add ecx, edx	; 496B7
mov ebx, edi	; 496B9
shl ebx, 2	; 496BB
add ebx, edi	; 496BE
shl ebx, 3	; 496C0
sub ebx, edi	; 496C3
lea eax, [ecx+ebx]	; 496C5
lea ecx, [byte eax+017h]	; 496C8
push ecx	; 496CB
add eax, byte 7	; 496CC
mov dword [byte esp+08h], eax	; 496CF
mov dl, byte [dword edx+ebx+hmrosterjersey]	; 496D3
and edx, 0FFh	; 496DA
mov ebx, esi	; 496E0
shl ebx, 2	; 496E2
sub ebx, esi	; 496E5
shl ebx, 3	; 496E7
mov eax, ebx	; 496EA
shl ebx, 5	; 496EC
sub ebx, eax	; 496EF
mov eax, hmteamrec	; 496F1
add eax, ebx	; 496F6
mov ecx, dword [byte esp+08h]	; 496F8
mov ebx, edx	; 496FC
mov edx, eax	; 496FE
mov eax, textline2	; 49700
call FormatPlayerName	; 49705
test esi, esi	; 4970A
je short .3	; 4970C
mov ax, word [VisTeam]	; 4970E
jmp short .4	; 49714
.3:
mov ax, word [HomeTeam]	; 49716
.4:
movsx ecx, ax	; 4971C
mov eax, esi	; 4971F
shl eax, 4	; 49721
add eax, esi	; 49724
shl eax, 4	; 49726
add eax, esi	; 49729
shl eax, 2	; 4972B
mov ebx, edi	; 4972E
shl ebx, 2	; 49730
add ebx, edi	; 49733
shl ebx, 3	; 49735
sub ebx, edi	; 49738
add eax, ebx	; 4973A
xor ebx, ebx	; 4973C
mov bl, byte [dword eax+hmrosterjersey]	; 4973E
mov edx, dword [byte ebp+temp1-2]	; 49744
sar edx, 10h	; 49747
inc edx	; 4974A
mov eax, dword [nosplit ecx*4+teamabbrevs]	; 4974B
call PaPlayerNumber	; 49752
.5:
mov di, word [byte ebp+temp2]	; 49757
dec edi	; 4975B
mov word [byte ebp+temp2], di	; 4975C
test di, di	; 49760
jg near .16	; 49763
cmp word [byte ebp+temp1], byte 0	; 49769
jge short .6	; 4976E
xor edx, edx	; 49770
mov dword [seqtimer], edx	; 49772
mov ebx, 1	; 49778
mov word [exitgame], bx	; 4977D
mov word [gameover], bx	; 49784
jmp near .16	; 4978B
.6:
mov eax, dword [byte ebp+temp3-2]	; 49790
sar eax, 10h	; 49793
shl eax, 7	; 49796
mov ebx, SortCords	; 49799
add ebx, eax	; 4979E
cmp word [byte ebp+temp3], byte 0	; 497A0
jl near .11	; 497A5
cmp word [byte ebx+temp1], byte 64h	; 497AB
jne near .11	; 497B0
mov eax, dword [byte ebx+010h]	; 497B6
sar eax, 10h	; 497B9
cmp eax, byte 0FFFFFFFFh	; 497BC
jne near .11	; 497BF
mov eax, 1Eh	; 497C5
call randomd0	; 497CA
add eax, 14h	; 497CF
mov word [byte ebp+temp2], ax	; 497D4
test byte [gameopts+1], 1	; 497D8
je short .7	; 497DF
cmp byte [musicon], 0	; 497E1
je short .7	; 497E8
add word [byte ebp+temp2], 0DCh	; 497EA
.7:
mov word [byte ebp+temp3], 0FFFFh	; 497F0
mov di, word [byte ebp+temp1]	; 497F6
dec edi	; 497FA
mov word [byte ebp+temp1], di	; 497FB
test di, di	; 497FF
jge short .8	; 49802
mov word [ovltimer], 258h	; 49804
jmp near .16	; 4980D
.8:
mov ebx, dword [byte ebp+temp1-2]	; 49812
sar ebx, 10h	; 49815
mov esi, dword [nosplit ebx*4+startm_m2]	; 49818
sar esi, 10h	; 4981F
mov edi, dword [nosplit ebx*4+startm]	; 49822
sar edi, 10h	; 49829
mov eax, dword [nosplit ebx*4+starordtab]	; 4982C
push eax	; 49833
push str_StarFmt	; 49834
push textline1	; 49839
call sprintf_	; 4983E
add esp, byte 0Ch	; 49843
push unk_C1B3E	; 49846
mov edx, esi	; 4984B
shl edx, 4	; 4984D
add edx, esi	; 49850
shl edx, 4	; 49852
add edx, esi	; 49855
shl edx, 2	; 49857
mov ecx, hmroster	; 4985A
add ecx, edx	; 4985F
mov ebx, edi	; 49861
shl ebx, 2	; 49863
add ebx, edi	; 49866
shl ebx, 3	; 49868
sub ebx, edi	; 4986B
add ecx, ebx	; 4986D
lea eax, [byte ecx+017h]	; 4986F
push eax	; 49872
add ecx, byte 7	; 49873
xor eax, eax	; 49876
mov al, byte [dword edx+ebx+hmrosterjersey]	; 49878
mov dword [byte esp+08h], eax	; 4987F
mov ebx, esi	; 49883
shl ebx, 2	; 49885
sub ebx, esi	; 49888
shl ebx, 3	; 4988A
mov eax, ebx	; 4988D
shl ebx, 5	; 4988F
sub ebx, eax	; 49892
mov edx, hmteamrec	; 49894
add edx, ebx	; 49899
mov ebx, dword [byte esp+08h]	; 4989B
mov eax, textline2	; 4989F
call FormatPlayerName	; 498A4
test esi, esi	; 498A9
je short .9	; 498AB
mov ax, word [VisTeam]	; 498AD
jmp short .10	; 498B3
.9:
mov ax, word [HomeTeam]	; 498B5
.10:
cwde	; 498BB
mov edx, esi	; 498BC
shl edx, 4	; 498BE
add edx, esi	; 498C1
shl edx, 4	; 498C3
add edx, esi	; 498C6
shl edx, 2	; 498C8
mov ebx, edi	; 498CB
shl ebx, 2	; 498CD
add ebx, edi	; 498D0
shl ebx, 3	; 498D2
sub ebx, edi	; 498D5
mov bl, byte [dword edx+ebx+hmrosterjersey]	; 498D7
and ebx, 0FFh	; 498DE
mov edx, dword [byte ebp+temp1-2]	; 498E4
sar edx, 10h	; 498E7
inc edx	; 498EA
mov eax, dword [nosplit eax*4+teamabbrevs]	; 498EB
call PaPlayerNumber	; 498F2
jmp near .16	; 498F7
.11:
cmp word [byte ebp+temp2], byte 0	; 498FC
jl near .16	; 49901
mov eax, dword [byte ebp+temp1-2]	; 49907
sar eax, 10h	; 4990A
cmp word [nosplit eax*4+startm], byte 0	; 4990D
setne al	; 49916
and eax, 0FFh	; 49919
add eax, byte 5	; 4991E
mov word [byte ebp+temp3], ax	; 49921
shl eax, 7	; 49925
mov ebx, SortCords	; 49928
add ebx, eax	; 4992D
test byte [byte ebx+pflags], 40h	; 4992F
setne al	; 49933
and eax, 0FFh	; 49936
mov esi, eax	; 4993B
je short .12	; 4993D
mov eax, 2BCh	; 4993F
jmp short .13	; 49944
.12:
mov eax, 5DCh	; 49946
.13:
mov word [crowdlevel], ax	; 4994B
mov eax, dword [byte ebp+temp1-2]	; 49951
sar eax, 10h	; 49954
mov al, byte [nosplit eax*4+starpl]	; 49957
mov byte [byte ebx+047h], al	; 4995E
movsx edi, al	; 49961
cmp edi, byte 19h	; 49964
jge short .14	; 49967
mov eax, 4	; 49969
jmp short .15	; 4996E
.14:
xor eax, eax	; 49970
.15:
mov word [byte ebx+position], ax	; 49972
mov word [byte ebx+temp1], 0	; 49976
mov byte [byte ebx+newpnum], 0FFh	; 4997C
mov al, byte [byte ebx+newpnum]	; 49980
mov byte [byte ebx+newpos], al	; 49983
shl esi, 8	; 49986
mov eax, edi	; 49989
mov word [dword esi+eax*2+hmtmpde], 300h	; 4998B
and byte [byte ebp+pflags2], 0FBh	; 49995
movsx edx, di	; 49999
mov eax, ebx	; 4999C
call setplayer	; 4999E
xor edx, edx	; 499A3
mov eax, ebx	; 499A5
call assreplace	; 499A7
mov edx, 1Dh	; 499AC
mov eax, ebx	; 499B1
call assinsert	; 499B3
mov edx, 14h	; 499B8
mov eax, ebx	; 499BD
call assinsert	; 499BF
mov edx, 9	; 499C4
mov eax, ebx	; 499C9
call assinsert	; 499CB
.16:
add esp, byte 4	; 499D0
jmp near PreGameIntro_popebp	; 499D3
