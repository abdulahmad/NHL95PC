; The rink objects, the deferred calls, and the game log: the summary records and the goal, assist,
; penalty and injury events that the summary screens read.
bits 32
%include "hockey.inc"
section s_614C2 progbits alloc exec nowrite align=1
extern __CHK, assinsert, assreplace, awgoalcnt, awscore, awtmap, awtmflags, awtmstruct
extern bannermsg, bannertimer, byte_C9111, byte_C9142, byte_C9146, byte_CCE00, byte_CCE01, byte_DF6E8
extern byte_DF7E8, byte_E024C, byte_E024D, byte_E9A15, byte_E9AC8, byte_E9AC9, byte_E9ACA, byte_E9ACB
extern byte_E9ACC, byte_E9ACD, byte_E9ACE, byte_E9ACF, byte_E9AD0, byte_E9AD1, byte_E9AD2, byte_E9AD3
extern c1playernum, c2playernum, CanRemovePlayer, clockticks, CloseTextOverlay, cont1team, cont2team, crowdlevel
extern curperiod, CwdExciteLvl, defercount, deferpending, DrawFrameSprite, DrawSprite, dword_C9120, dword_CBEBE
extern dword_CC0AC, dword_CD2F8, dword_DB086, dword_DB088, dword_DEB74, dword_DEB78, dword_DEB7C, dword_DEB80
extern dword_DF646, dword_DF648, dword_E0220, dword_E0230, dword_E9A14, dword_E9A9E, dword_E9B2A, dword_E9BA4
extern dword_E9BA8, dword_E9BAC, dword_E9BB0, dword_E9BB4, dword_E9BB8, dword_E9BBC, dword_E9BC0, FatalError
extern FileClose, FileOpenRW, FileWriteAt, fox, foy, fputchar, gameclock, gamemode
extern gameopts, gmode, gmode2, gsp, gsummarypath, gsumqcount, hmgoalcnt, hmroster
extern hmrosterjersey, hmscore, hmteamrec, hmtmap, hmtmflags, hmtmgoalie, hmtmlines, hmtmstruct
extern HomeTeam, joysampling, joysampling_save, lastsfx, LoadTeamPPV, lseek_, ltx, lty
extern MenuCallbackTrue, MenuCallbackTrue2, musicon, off_CD354, ovlseq, ovltimer, PanelAddPenalty, PanelRemovePenalty
extern PaPenalty, PaPenaltyShot, PaSpeechBusy, PBnum, penaltynames, Penaltytimer, PenBuf, PenBuf_m5
extern PenBuf_pl, Pencntdwn, pendelaytab, penmintab, penshotfox, penshotfoy, penshotlive, penshotmode
extern penshotplayer, penshotpnum, penshotstart, penshotteam, penshottimer, periodendtime, PerTimeTotal, photoptrsf
extern PlayCrowdSample, priolist, puckc, puckstruct, pucktemp1, puckvx, puckvy, puckvz
extern puckx, pucky, puckz, randomd0, RefPen, refsignal, RefStep, regd1
extern regd2, regd3, restorepl, s1font, scor2font, scpflags2, Setplass, setplayer
extern sflags, sflags3, sfx, shotongoal, shotontarget, SortCords, sortobj15, sprintf_
extern str_02d02dSInjury, str_02d02dSPenalty, str_Assists, str_B3, str_B4, str_B5, str_B6, str_B7
extern str_B8, str_DMinutes, str_FmtClockEvent, str_FmtNumFirstLast, str_FmtNumInitialLast, str_FmtNumName, str_FmtNumNameSuffix, str_FmtParenD
extern str_GameMisconduct, str_GoneFor1Period, str_GoneForTheGame, str_PenaltyShot, str_PPTag, str_S8, str_ServedByD, str_SHTag
extern str_ToBeTakenBy, str_Unassisted, strcpy_, strlen_, sub_8EA18, teamabbrevs, textline1, textline2
extern textline3, textline4, textline5, unk_C1B49, unk_C5423, unk_C542E, unk_E9B4C, UpdateTextOverlay
extern vecdist, VisTeam, word_C5428, word_C90D8, word_CBC44, word_CBEC6, word_CC0B0, word_CCEF8
extern word_CD39C, word_DB08A, word_DEE94, word_DF644, word_E9AAE, word_E9B2C, yleader
global SetRinkObject, SetBoxDoorObject, DecayCrowdLevel, sfxslots_popx, DrawRinkObjects, QueueDeferredCall, RunDeferredCalls, fileio_popebpx
global AppendGSumRecord, FlushGSumQueue, ReadGSumHeader, fileio_tail_a, fileio_tail_b, fileio_tail_c, ReadGSumTail, WriteGSumHeader
global FormatPlayerName, BuildEventLines, PostGoalEvent, PostPenaltyEvent, PostInjuryEvent, NullCallback0C, ChkScorerMilestone, QueueGoalieNote
; C: src/engine/gamelog/SetRinkObject.c
%ifdef CBUILD
%include "c/engine/gamelog/SetRinkObject.inc"
%else
SetRinkObject:
push dword 14h	; 614C2
call __CHK	; 614C7
push ebx	; 614CC
push ecx	; 614CD
push esi	; 614CE
push edi	; 614CF
mov esi, edx	; 614D0
mov ebx, eax	; 614D2
shl ebx, 2	; 614D4
sub ebx, eax	; 614D7
shl ebx, 2	; 614D9
add ebx, word_DEE94	; 614DC
mov word [ebx], dx	; 614E2
mov eax, edx	; 614E5
sar edx, 1Fh	; 614E7
shl edx, 4	; 614EA
LD sbb, eax, edx	; 614ED
sar eax, 4	; 614EF
lea edi, [eax+eax]	; 614F2
mov ecx, 10h	; 614F5
mov eax, esi	; 614FA
mov edx, esi	; 614FC
sar edx, 1Fh	; 614FE
idiv ecx	; 61501
mov cl, dl	; 61503
mov edx, 1	; 61505
shl edx, cl	; 6150A
mov eax, dword [dword edi+word_E9B2C-2]	; 6150C
sar eax, 10h	; 61512
or eax, edx	; 61515
mov word [dword edi+word_E9B2C], ax	; 61517
mov eax, esi	; 6151E
shl esi, 2	; 61520
sub esi, eax	; 61523
mov ax, word [nosplit esi*2+word_CCEF8]	; 61525
mov word [byte ebx+05h], ax	; 6152D
inc esi	; 61531
mov ax, word [nosplit esi*2+word_CCEF8]	; 61532
mov word [byte ebx+07h], ax	; 6153A
inc esi	; 6153E
mov ax, word [nosplit esi*2+word_CCEF8]	; 6153F
mov word [byte ebx+09h], ax	; 61547
mov eax, dword [byte ebx+07h]	; 6154B
sar eax, 10h	; 6154E
mov al, byte [dword eax+byte_CCE00]	; 61551
mov byte [byte ebx+0Bh], al	; 61557
mov eax, dword [byte ebx+07h]	; 6155A
sar eax, 10h	; 6155D
mov al, byte [dword eax+byte_CCE01]	; 61560
mov byte [byte ebx+04h], al	; 61566
mov byte [byte ebx+02h], 0Ch	; 61569
mov byte [byte ebx+03h], 1	; 6156D
pop edi	; 61571
pop esi	; 61572
pop ecx	; 61573
pop ebx	; 61574
ret	; 61575
%endif ; C
; C: src/engine/gamelog/SetBoxDoorObject.c
%ifdef CBUILD
%include "c/engine/gamelog/SetBoxDoorObject.inc"
%else
SetBoxDoorObject:
push dword 8	; 61576
call __CHK	; 6157B
push edx	; 61580
test eax, eax	; 61581
je short .1	; 61583
mov edx, 88h	; 61585
mov eax, 13h	; 6158A
jmp short .2	; 6158F
.1:
mov edx, 87h	; 61591
mov eax, 12h	; 61596
.2:
call SetRinkObject	; 6159B
pop edx	; 615A0
ret	; 615A1
%endif ; C
; C: src/engine/gamelog/DecayCrowdLevel.c
%ifdef CBUILD
%include "c/engine/gamelog/DecayCrowdLevel.inc"
%else
DecayCrowdLevel:
push dword 1Ch	; 615A2
call __CHK	; 615A7
push ebx	; 615AC
push ecx	; 615AD
push edx	; 615AE
push esi	; 615AF
push edi	; 615B0
sub esp, byte 4	; 615B1
mov dx, word [crowdlevel]	; 615B4
cmp dx, 2BCh	; 615BB
jle short .1	; 615C0
mov esi, edx	; 615C2
sub esi, byte 2	; 615C4
mov word [crowdlevel], si	; 615C7
jmp short .2	; 615CE
.1:
cmp dx, 15Eh	; 615D0
jle short .2	; 615D5
mov ecx, edx	; 615D7
sub ecx, byte 3	; 615D9
mov word [crowdlevel], cx	; 615DC
.2:
mov di, word [crowdlevel]	; 615E3
dec edi	; 615EA
mov word [crowdlevel], di	; 615EB
test di, di	; 615F2
jge short .3	; 615F5
xor edx, edx	; 615F7
mov word [crowdlevel], dx	; 615F9
mov eax, 10h	; 61600
call randomd0	; 61605
test ax, ax	; 6160A
jne short .3	; 6160D
mov eax, 20h	; 6160F
call randomd0	; 61614
mov word [crowdlevel], ax	; 61619
.3:
xor ebx, ebx	; 6161F
mov word [esp], bx	; 61621
jmp near .20	; 61625
.4:
mov edx, dword [byte esp-02h]	; 6162A
sar edx, 10h	; 6162E
mov eax, edx	; 61631
shl eax, 2	; 61633
sub eax, edx	; 61636
shl eax, 2	; 61638
mov ebx, word_DEE94	; 6163B
add ebx, eax	; 61640
cmp word [ebx], byte 0	; 61642
jge near .10	; 61646
mov ah, byte [byte ebx+02h]	; 6164C
dec ah	; 6164F
mov byte [byte ebx+02h], ah	; 61651
test ah, ah	; 61654
jge near .19	; 61656
cmp cx, byte 12h	; 6165C
jne short .5	; 61660
mov eax, 11h	; 61662
call randomd0	; 61667
mov esi, eax	; 6166C
add esi, 89h	; 6166E
jmp near .9	; 61674
.5:
cmp cx, byte 13h	; 61679
jne short .6	; 6167D
mov eax, 11h	; 6167F
call randomd0	; 61684
mov esi, eax	; 61689
add esi, 9Ah	; 6168B
jmp near .9	; 61691
.6:
cmp cx, byte 11h	; 61696
jne short .7	; 6169A
test byte [gmode], 1	; 6169C
je short .7	; 616A3
mov eax, 4	; 616A5
call randomd0	; 616AA
cmp ax, 2	; 616AF
jge short .7	; 616B3
mov esi, eax	; 616B5
add esi, 85h	; 616B7
jmp short .9	; 616BD
.7:
mov eax, 85h	; 616BF
call randomd0	; 616C4
mov esi, eax	; 616C9
.8:
movsx ebx, si	; 616CB
mov eax, ebx	; 616CE
mov edx, ebx	; 616D0
sar edx, 1Fh	; 616D2
shl edx, 4	; 616D5
LD sbb, eax, edx	; 616D8
sar eax, 4	; 616DA
mov edi, dword [nosplit eax*2+dword_E9B2A]	; 616DD
sar edi, 10h	; 616E4
mov ecx, 10h	; 616E7
mov eax, ebx	; 616EC
mov edx, ebx	; 616EE
sar edx, 1Fh	; 616F0
idiv ecx	; 616F3
mov cl, dl	; 616F5
mov eax, 1	; 616F7
shl eax, cl	; 616FC
test edi, eax	; 616FE
je short .9	; 61700
inc esi	; 61702
cmp si, 85h	; 61703
jl short DecayCrowdLevel.8	; 61708
xor esi, esi	; 6170A
jmp short DecayCrowdLevel.8	; 6170C
.9:
movsx edx, si	; 6170E
mov eax, dword [byte esp-02h]	; 61711
sar eax, 10h	; 61715
call SetRinkObject	; 61718
jmp near .19	; 6171D
.10:
mov ah, byte [byte ebx+02h]	; 61722
dec ah	; 61725
mov byte [byte ebx+02h], ah	; 61727
test ah, ah	; 6172A
jge near .19	; 6172C
cmp byte [byte ebx+0Bh], 0	; 61732
jge short .11	; 61736
mov eax, dword [byte ebx+08h]	; 61738
sar eax, 18h	; 6173B
neg eax	; 6173E
jmp short .12	; 61740
.11:
mov eax, dword [byte ebx+08h]	; 61742
sar eax, 18h	; 61745
.12:
mov edx, dword [ebx]	; 61748
sar edx, 18h	; 6174A
cmp edx, eax	; 6174D
jge short .13	; 6174F
mov byte [byte ebx+02h], 0Ch	; 61751
inc byte [byte ebx+03h]	; 61755
mov eax, dword [byte ebx+07h]	; 61758
sar eax, 10h	; 6175B
mov edx, dword [ebx]	; 6175E
sar edx, 18h	; 61760
mov al, byte [dword edx+eax+byte_CCE00]	; 61763
mov byte [byte ebx+04h], al	; 6176A
jmp near .19	; 6176D
.13:
cmp byte [byte ebx+0Bh], 0	; 61772
jge short .14	; 61776
mov eax, 2	; 61778
call randomd0	; 6177D
test ax, ax	; 61782
je short .14	; 61785
mov eax, dword [byte ebx+07h]	; 61787
sar eax, 10h	; 6178A
mov al, byte [dword eax+byte_CCE01]	; 6178D
mov byte [byte ebx+04h], al	; 61793
mov byte [byte ebx+02h], 0Ch	; 61796
mov byte [byte ebx+03h], 1	; 6179A
jmp near .19	; 6179E
.14:
movsx ecx, word [ebx]	; 617A3
mov eax, ecx	; 617A6
mov edx, ecx	; 617A8
sar edx, 1Fh	; 617AA
shl edx, 4	; 617AD
LD sbb, eax, edx	; 617B0
sar eax, 4	; 617B2
lea edi, [eax+eax]	; 617B5
mov esi, 10h	; 617B8
mov eax, ecx	; 617BD
mov edx, ecx	; 617BF
sar edx, 1Fh	; 617C1
idiv esi	; 617C4
mov cl, dl	; 617C6
mov edx, 1	; 617C8
shl edx, cl	; 617CD
not edx	; 617CF
mov eax, dword [dword edi+word_E9B2C-2]	; 617D1
sar eax, 10h	; 617D7
and eax, edx	; 617DA
mov word [dword edi+word_E9B2C], ax	; 617DC
mov word [ebx], 0FFFFh	; 617E3
mov edx, dword [crowdlevel-2]	; 617E8
sar edx, 10h	; 617EE
mov eax, 3E8h	; 617F1
sub eax, edx	; 617F6
mov edx, eax	; 617F8
sar edx, 1Fh	; 617FA
shl edx, 3	; 617FD
LD sbb, eax, edx	; 61800
sar eax, 3	; 61802
mov edx, eax	; 61805
cmp ax, 14h	; 61807
jge short .15	; 6180B
mov edx, 14h	; 6180D
.15:
cmp word [esp], byte 12h	; 61812
jl short .16	; 61817
cmp dx, byte 64h	; 61819
jge short .16	; 6181D
mov edx, 64h	; 6181F
.16:
cmp word [esp], byte 11h	; 61824
jne short .17	; 61829
test byte [gmode], 1	; 6182B
je short .17	; 61832
mov edx, 78h	; 61834
jmp short .18	; 61839
.17:
movsx eax, dx	; 6183B
call randomd0	; 6183E
mov edx, eax	; 61843
.18:
mov byte [byte ebx+02h], dl	; 61845
.19:
inc word [esp]	; 61848
.20:
mov ecx, dword [esp]	; 6184C
cmp cx, byte 14h	; 6184F
jl near DecayCrowdLevel.4	; 61853
add esp, byte 4	; 61859
sfxslots_popx:
pop edi	; 6185C
pop esi	; 6185D
pop edx	; 6185E
pop ecx	; 6185F
pop ebx	; 61860
ret	; 61861
%endif ; C
; C: src/engine/gamelog/DecayCrowdLevel.c (DrawRinkObjects)
%ifdef CBUILD
%include "c/engine/gamelog/DecayCrowdLevel.DrawRinkObjects.inc"
%else
DrawRinkObjects:
push dword 34h	; 61862
call __CHK	; 61867
push ebx	; 6186C
push ecx	; 6186D
push edx	; 6186E
push esi	; 6186F
push edi	; 61870
push ebp	; 61871
mov ebp, esp	; 61872
sub esp, byte 10h	; 61874
mov esi, word_DEE94	; 61877
xor edi, edi	; 6187C
jmp short .3	; 6187E
.1:
cmp word [esi], byte 0	; 61880
jl short .2	; 61884
push byte 0	; 61886
push byte 0FFFFFFFFh	; 61888
cmp word [byte esi+05h], 0C0h	; 6188A
setg al	; 61890
xor ah, ah	; 61893
cwde	; 61895
mov dword [byte ebp-010h], eax	; 61896
mov ebx, dword [byte esi+05h]	; 61899
sar ebx, 10h	; 6189C
mov edx, dword [byte esi+03h]	; 6189F
sar edx, 10h	; 618A2
mov eax, dword [byte esi+01h]	; 618A5
sar eax, 18h	; 618A8
mov eax, dword [nosplit eax*4+photoptrsf]	; 618AB
mov ecx, dword [byte ebp-010h]	; 618B2
call DrawSprite	; 618B5
.2:
inc edi	; 618BA
add esi, byte 0Ch	; 618BB
.3:
cmp di, byte 12h	; 618BE
jl short DrawRinkObjects.1	; 618C2
mov edi, 1	; 618C4
add esi, byte 0Ch	; 618C9
jmp near .12	; 618CC
.4:
cmp word [esi], byte 0	; 618D1
jge short .5	; 618D5
mov word [byte ebp-0Ch], 0FFFFh	; 618D7
jmp short .6	; 618DD
.5:
movsx ax, byte [byte esi+04h]	; 618DF
mov word [byte ebp-0Ch], ax	; 618E4
.6:
mov ax, word [byte esi+05h]	; 618E8
mov word [byte ebp-08h], ax	; 618EC
mov ax, word [byte esi+07h]	; 618F0
mov word [byte ebp-04h], ax	; 618F4
cmp word [byte ebp-0Ch], byte 64h	; 618F8
jg short .7	; 618FD
cmp word [esi], byte 0	; 618FF
jge short .8	; 61903
.7:
push byte 0	; 61905
movsx eax, di	; 61907
push eax	; 6190A
mov ebx, dword [nosplit eax*4+dword_CD2F8]	; 6190B
sar ebx, 10h	; 61912
mov eax, dword [dword_E0220]	; 61915
xor ecx, ecx	; 6191A
mov edx, 4	; 6191C
call DrawSprite	; 61921
.8:
cmp word [byte ebp-0Ch], byte 0	; 61926
jl short .9	; 6192B
push byte 0	; 6192D
movsx eax, di	; 6192F
push eax	; 61932
mov ebx, dword [byte ebp-06h]	; 61933
sar ebx, 10h	; 61936
mov edx, dword [byte ebp-0Ah]	; 61939
sar edx, 10h	; 6193C
mov eax, dword [byte ebp-0Eh]	; 6193F
sar eax, 10h	; 61942
mov eax, dword [nosplit eax*4+photoptrsf]	; 61945
xor ecx, ecx	; 6194C
call DrawSprite	; 6194E
.9:
test di, di	; 61953
jne short .10	; 61956
push byte 0	; 61958
push byte 0FFFFFFFFh	; 6195A
movsx eax, di	; 6195C
mov ebx, dword [nosplit eax*4+dword_CD2F8]	; 6195F
sar ebx, 10h	; 61966
mov eax, dword [dword_E0230]	; 61969
xor ecx, ecx	; 6196E
mov edx, 4	; 61970
call DrawSprite	; 61975
jmp short .11	; 6197A
.10:
test byte [gmode], 80h	; 6197C
je short .11	; 61983
cmp word [sortobj15+12h], 362h	; 61985
jl short .11	; 6198E
push byte 0	; 61990
mov ebx, dword [sortobj15+4]	; 61992
sar ebx, 10h	; 61998
mov edx, dword [sortobj15]	; 6199B
sar edx, 10h	; 619A1
mov eax, dword [sortobj15+10h]	; 619A4
sar eax, 10h	; 619A9
xor ecx, ecx	; 619AC
call DrawFrameSprite	; 619AE
.11:
dec edi	; 619B3
sub esi, byte 0Ch	; 619B4
.12:
test di, di	; 619B7
jge near DrawRinkObjects.4	; 619BA
mov esp, ebp	; 619C0
pop ebp	; 619C2
jmp near sfxslots_popx	; 619C3
%endif ; C
; C: src/engine/gamelog/QueueDeferredCall.c
%ifdef CBUILD
%include "c/engine/gamelog/QueueDeferredCall.inc"
%else
QueueDeferredCall:
push dword 8	; 619C8
call __CHK	; 619CD
push esi	; 619D2
mov esi, eax	; 619D3
mov eax, dword [defercount]	; 619D5
shl eax, 5	; 619DA
mov dword [dword eax+dword_E9BC0], esi	; 619DD
mov dword [dword eax+dword_E9BA4], edx	; 619E3
mov dword [dword eax+dword_E9BA8], ebx	; 619E9
mov dword [dword eax+dword_E9BAC], ecx	; 619EF
mov edx, dword [byte esp+08h]	; 619F5
mov dword [dword eax+dword_E9BB0], edx	; 619F9
mov edx, dword [byte esp+0Ch]	; 619FF
mov dword [dword eax+dword_E9BB4], edx	; 61A03
mov edx, dword [byte esp+010h]	; 61A09
mov dword [dword eax+dword_E9BB8], edx	; 61A0D
mov edx, dword [byte esp+014h]	; 61A13
mov dword [dword eax+dword_E9BBC], edx	; 61A17
inc dword [defercount]	; 61A1D
pop esi	; 61A23
ret 10h	; 61A24
%endif ; C
; C: src/engine/gamelog/RunDeferredCalls.c
%ifdef CBUILD
%include "c/engine/gamelog/RunDeferredCalls.inc"
%else
RunDeferredCalls:
push dword 28h	; 61A27
call __CHK	; 61A2C
push ebx	; 61A31
push ecx	; 61A32
push edx	; 61A33
push esi	; 61A34
push edi	; 61A35
push ebp	; 61A36
xor edi, edi	; 61A37
jmp short .2	; 61A39
.1:
mov esi, edi	; 61A3B
shl esi, 5	; 61A3D
mov ebx, dword [dword esi+dword_E9BBC]	; 61A40
push ebx	; 61A46
mov ecx, dword [dword esi+dword_E9BB8]	; 61A47
push ecx	; 61A4D
mov ebp, dword [dword esi+dword_E9BB4]	; 61A4E
push ebp	; 61A54
mov ecx, dword [dword esi+dword_E9BB0]	; 61A55
mov ebx, dword [dword esi+dword_E9BAC]	; 61A5B
mov edx, dword [dword esi+dword_E9BA8]	; 61A61
mov eax, dword [dword esi+dword_E9BA4]	; 61A67
call dword [dword esi+dword_E9BC0]	; 61A6D
inc edi	; 61A73
.2:
cmp edi, dword [defercount]	; 61A74
jl short RunDeferredCalls.1	; 61A7A
xor eax, eax	; 61A7C
mov dword [defercount], eax	; 61A7E
fileio_popebpx:
pop ebp	; 61A83
pop edi	; 61A84
pop esi	; 61A85
pop edx	; 61A86
pop ecx	; 61A87
pop ebx	; 61A88
ret	; 61A89
%endif ; C
; C: src/engine/gamelog/AppendGSumRecord.c
%ifdef CBUILD
%include "c/engine/gamelog/AppendGSumRecord.inc"
%else
AppendGSumRecord:
push dword 1Ch	; 61A8A
call __CHK	; 61A8F
push ebx	; 61A94
push ecx	; 61A95
push edx	; 61A96
push esi	; 61A97
sub esp, byte 4	; 61A98
mov esi, eax	; 61A9B
inc word [word_C5428]	; 61A9D
mov edx, esp	; 61AA4
mov eax, gsummarypath	; 61AA6
call FileOpenRW	; 61AAB
test eax, eax	; 61AB0
je short .1	; 61AB2
push str_B3	; 61AB4
call FatalError	; 61AB9
add esp, byte 4	; 61ABE
.1:
xor ebx, ebx	; 61AC1
xor edx, edx	; 61AC3
mov eax, dword [esp]	; 61AC5
call lseek_	; 61AC8
test eax, eax	; 61ACD
jge short .2	; 61ACF
push str_B4	; 61AD1
call FatalError	; 61AD6
add esp, byte 4	; 61ADB
.2:
mov ecx, 0Bh	; 61ADE
mov ebx, 0FFFFFFFFh	; 61AE3
mov edx, unk_C5423	; 61AE8
mov eax, dword [esp]	; 61AED
call FileWriteAt	; 61AF0
test eax, eax	; 61AF5
je short .3	; 61AF7
push str_B5	; 61AF9
call FatalError	; 61AFE
add esp, byte 4	; 61B03
.3:
mov ebx, 2	; 61B06
mov edx, 0FFFFFFF5h	; 61B0B
mov eax, dword [esp]	; 61B10
call lseek_	; 61B13
test eax, eax	; 61B18
jge short .4	; 61B1A
push str_B6	; 61B1C
call FatalError	; 61B21
add esp, byte 4	; 61B26
.4:
mov ecx, 0Bh	; 61B29
mov ebx, 0FFFFFFFFh	; 61B2E
mov edx, esi	; 61B33
mov eax, dword [esp]	; 61B35
call FileWriteAt	; 61B38
test eax, eax	; 61B3D
je short .5	; 61B3F
push str_B7	; 61B41
call FatalError	; 61B46
add esp, byte 4	; 61B4B
.5:
mov ecx, 0Bh	; 61B4E
mov ebx, 0FFFFFFFFh	; 61B53
mov edx, unk_C542E	; 61B58
mov eax, dword [esp]	; 61B5D
call FileWriteAt	; 61B60
test eax, eax	; 61B65
je short .6	; 61B67
push str_B8	; 61B69
call FatalError	; 61B6E
add esp, byte 4	; 61B73
.6:
mov eax, esp	; 61B76
call FileClose	; 61B78
add esp, byte 4	; 61B7D
pop esi	; 61B80
pop edx	; 61B81
pop ecx	; 61B82
pop ebx	; 61B83
ret	; 61B84
%endif ; C
; C: src/engine/gamelog/FlushGSumQueue.c
%ifdef CBUILD
%include "c/engine/gamelog/FlushGSumQueue.inc"
%else
FlushGSumQueue:
push dword 0Ch	; 61B85
call __CHK	; 61B8A
push ecx	; 61B8F
push edx	; 61B90
xor edx, edx	; 61B91
jmp short .2	; 61B93
.1:
mov eax, edx	; 61B95
shl eax, 2	; 61B97
sub eax, edx	; 61B9A
shl eax, 2	; 61B9C
sub eax, edx	; 61B9F
add eax, unk_E9B4C	; 61BA1
call AppendGSumRecord	; 61BA6
inc edx	; 61BAB
.2:
cmp edx, dword [gsumqcount]	; 61BAC
jl short FlushGSumQueue.1	; 61BB2
xor ecx, ecx	; 61BB4
mov dword [gsumqcount], ecx	; 61BB6
pop edx	; 61BBC
pop ecx	; 61BBD
ret	; 61BBE
%endif ; C
; C: src/engine/gamelog/ReadGSumHeader.c
%ifdef CBUILD
%include "c/engine/gamelog/ReadGSumHeader.inc"
%else
ReadGSumHeader:
push dword 18h	; 61BBF
call __CHK	; 61BC4
push ebx	; 61BC9
push ecx	; 61BCA
push edx	; 61BCB
sub esp, byte 4	; 61BCC
mov edx, esp	; 61BCF
mov eax, gsummarypath	; 61BD1
call FileOpenRW	; 61BD6
test eax, eax	; 61BDB
je short .1	; 61BDD
push str_B3	; 61BDF
call FatalError	; 61BE4
add esp, byte 4	; 61BE9
.1:
mov ecx, 0Bh	; 61BEC
mov ebx, 0FFFFFFFFh	; 61BF1
mov edx, unk_C5423	; 61BF6
fileio_tail_a:
mov eax, dword [esp]	; 61BFB
call FileWriteAt	; 61BFE
test eax, eax	; 61C03
je short fileio_tail_c	; 61C05
push str_B4	; 61C07
fileio_tail_b:
call FatalError	; 61C0C
add esp, byte 4	; 61C11
fileio_tail_c:
mov eax, esp	; 61C14
call FileClose	; 61C16
add esp, byte 4	; 61C1B
pop edx	; 61C1E
pop ecx	; 61C1F
pop ebx	; 61C20
ret	; 61C21
%endif ; C
; C: src/engine/gamelog/ReadGSumHeader.c (ReadGSumTail)
%ifdef CBUILD
%include "c/engine/gamelog/ReadGSumHeader.ReadGSumTail.inc"
%else
ReadGSumTail:
push dword 18h	; 61C22
call __CHK	; 61C27
push ebx	; 61C2C
push ecx	; 61C2D
push edx	; 61C2E
sub esp, byte 4	; 61C2F
mov edx, esp	; 61C32
mov eax, gsummarypath	; 61C34
call FileOpenRW	; 61C39
test eax, eax	; 61C3E
je short .1	; 61C40
push str_B3	; 61C42
call FatalError	; 61C47
add esp, byte 4	; 61C4C
.1:
mov ebx, 2	; 61C4F
mov edx, 0FFFFFFF5h	; 61C54
mov eax, dword [esp]	; 61C59
call lseek_	; 61C5C
test eax, eax	; 61C61
jge short .2	; 61C63
push str_B6	; 61C65
call FatalError	; 61C6A
add esp, byte 4	; 61C6F
.2:
mov ecx, 0Bh	; 61C72
mov ebx, 0FFFFFFFFh	; 61C77
mov edx, unk_C542E	; 61C7C
jmp near fileio_tail_a	; 61C81
%endif ; C
; C: src/engine/gamelog/ReadGSumHeader.c (WriteGSumHeader)
%ifdef CBUILD
%include "c/engine/gamelog/ReadGSumHeader.WriteGSumHeader.inc"
%else
WriteGSumHeader:
push dword 18h	; 61C86
call __CHK	; 61C8B
push ebx	; 61C90
push ecx	; 61C91
push edx	; 61C92
sub esp, byte 4	; 61C93
inc word [word_C5428]	; 61C96
mov edx, esp	; 61C9D
mov eax, gsummarypath	; 61C9F
call FileOpenRW	; 61CA4
test eax, eax	; 61CA9
je short .1	; 61CAB
push str_B3	; 61CAD
call FatalError	; 61CB2
add esp, byte 4	; 61CB7
.1:
xor ebx, ebx	; 61CBA
xor edx, edx	; 61CBC
mov eax, dword [esp]	; 61CBE
call lseek_	; 61CC1
test eax, eax	; 61CC6
jge short .2	; 61CC8
push str_B4	; 61CCA
call FatalError	; 61CCF
add esp, byte 4	; 61CD4
.2:
mov ecx, 0Bh	; 61CD7
mov ebx, 0FFFFFFFFh	; 61CDC
mov edx, unk_C5423	; 61CE1
mov eax, dword [esp]	; 61CE6
call FileWriteAt	; 61CE9
test eax, eax	; 61CEE
je short .3	; 61CF0
push str_B5	; 61CF2
call FatalError	; 61CF7
add esp, byte 4	; 61CFC
.3:
mov ebx, 2	; 61CFF
xor edx, edx	; 61D04
mov eax, dword [esp]	; 61D06
call lseek_	; 61D09
test eax, eax	; 61D0E
jge short .4	; 61D10
push str_B6	; 61D12
call FatalError	; 61D17
add esp, byte 4	; 61D1C
.4:
mov ecx, 0Bh	; 61D1F
mov ebx, 0FFFFFFFFh	; 61D24
mov edx, unk_C542E	; 61D29
mov eax, dword [esp]	; 61D2E
call FileWriteAt	; 61D31
test eax, eax	; 61D36
je near fileio_tail_c	; 61D38
push str_B8	; 61D3E
jmp near fileio_tail_b	; 61D43
%endif ; C
; C: src/engine/gamelog/FormatPlayerName.c
%ifdef CBUILD
%include "c/engine/gamelog/FormatPlayerName.inc"
%else
FormatPlayerName:
push dword 48h	; 61D48
call __CHK	; 61D4D
push esi	; 61D52
push edi	; 61D53
push ebp	; 61D54
sub esp, byte 1Ch	; 61D55
mov edi, eax	; 61D58
mov dword [byte esp+014h], edx	; 61D5A
mov word [byte esp+018h], bx	; 61D5E
mov ebp, ecx	; 61D63
mov edx, dword [scor2font]	; 61D65
push edx	; 61D6B
call sub_8EA18	; 61D6C
add esp, byte 4	; 61D71
mov ebx, dword [byte esp+030h]	; 61D74
push ebx	; 61D78
mov ecx, dword [byte esp+030h]	; 61D79
push ecx	; 61D7D
push ebp	; 61D7E
mov esi, dword [byte esp+022h]	; 61D7F
sar esi, 10h	; 61D83
push esi	; 61D86
mov eax, dword [byte esp+024h]	; 61D87
push eax	; 61D8B
push str_FmtNumFirstLast	; 61D8C
push edi	; 61D91
call sprintf_	; 61D92
add esp, byte 1Ch	; 61D97
push edi	; 61D9A
call fputchar	; 61D9B
add esp, byte 4	; 61DA0
cmp eax, byte 7Ch	; 61DA3
jle near .3	; 61DA6
mov edx, dword [byte esp+030h]	; 61DAC
push edx	; 61DB0
mov ebx, dword [byte esp+030h]	; 61DB1
push ebx	; 61DB5
movsx eax, byte [byte ebp+00h]	; 61DB6
push eax	; 61DBA
push esi	; 61DBB
mov ecx, dword [byte esp+024h]	; 61DBC
push ecx	; 61DC0
push str_FmtNumInitialLast	; 61DC1
push edi	; 61DC6
call sprintf_	; 61DC7
add esp, byte 1Ch	; 61DCC
push edi	; 61DCF
call fputchar	; 61DD0
add esp, byte 4	; 61DD5
cmp eax, byte 7Ch	; 61DD8
jle near .3	; 61DDB
mov ebp, dword [byte esp+030h]	; 61DE1
push ebp	; 61DE5
mov eax, dword [byte esp+030h]	; 61DE6
push eax	; 61DEA
push esi	; 61DEB
mov edx, dword [byte esp+020h]	; 61DEC
push edx	; 61DF0
push str_FmtNumNameSuffix	; 61DF1
push edi	; 61DF6
call sprintf_	; 61DF7
add esp, byte 18h	; 61DFC
push edi	; 61DFF
call fputchar	; 61E00
add esp, byte 4	; 61E05
cmp eax, byte 7Ch	; 61E08
jle short .3	; 61E0B
push ebp	; 61E0D
push esi	; 61E0E
mov ecx, dword [byte esp+01Ch]	; 61E0F
push ecx	; 61E13
push str_FmtNumName	; 61E14
push edi	; 61E19
call sprintf_	; 61E1A
add esp, byte 14h	; 61E1F
push edi	; 61E22
call fputchar	; 61E23
add esp, byte 4	; 61E28
mov ebp, 7Ch	; 61E2B
sub ebp, eax	; 61E30
mov edx, dword [byte esp+02Ch]	; 61E32
mov eax, esp	; 61E36
call strcpy_	; 61E38
mov eax, esp	; 61E3D
call strlen_	; 61E3F
mov esi, eax	; 61E44
.1:
mov eax, esp	; 61E46
push eax	; 61E48
call fputchar	; 61E49
add esp, byte 4	; 61E4E
cmp eax, ebp	; 61E51
jle short .2	; 61E53
dec esi	; 61E55
xor ah, ah	; 61E56
mov byte [esp+esi], ah	; 61E58
jmp short FormatPlayerName.1	; 61E5B
.2:
mov esi, dword [byte esp+030h]	; 61E5D
push esi	; 61E61
lea eax, [byte esp+04h]	; 61E62
push eax	; 61E66
mov eax, dword [byte esp+01Eh]	; 61E67
sar eax, 10h	; 61E6B
push eax	; 61E6E
mov ebp, dword [byte esp+020h]	; 61E6F
push ebp	; 61E73
push str_FmtNumNameSuffix	; 61E74
push edi	; 61E79
call sprintf_	; 61E7A
add esp, byte 18h	; 61E7F
.3:
mov eax, dword [s1font]	; 61E82
push eax	; 61E87
call sub_8EA18	; 61E88
add esp, byte 4	; 61E8D
add esp, byte 1Ch	; 61E90
pop ebp	; 61E93
pop edi	; 61E94
pop esi	; 61E95
ret 8	; 61E96
%endif ; C
; C: src/engine/gamelog/BuildEventLines.c
%ifdef CBUILD
%include "c/engine/gamelog/BuildEventLines.inc"
%else
BuildEventLines:
push dword 3Ch	; 61E99
call __CHK	; 61E9E
push ebx	; 61EA3
push ecx	; 61EA4
push edx	; 61EA5
push esi	; 61EA6
push edi	; 61EA7
push ebp	; 61EA8
sub esp, byte 0Ch	; 61EA9
xor ah, ah	; 61EAC
mov byte [textline5], ah	; 61EAE
mov byte [textline4], ah	; 61EB4
mov byte [textline2], ah	; 61EBA
mov byte [textline1], ah	; 61EC0
mov byte [textline3], ah	; 61EC6
mov cl, byte [byte_E9AC8]	; 61ECC
cmp cl, 1	; 61ED2
jne near .8	; 61ED5
movzx esi, byte [byte_E9AC9]	; 61EDB
mov edx, esi	; 61EE2
shl edx, 2	; 61EE4
sub edx, esi	; 61EE7
shl edx, 3	; 61EE9
mov eax, edx	; 61EEC
shl edx, 5	; 61EEE
sub edx, eax	; 61EF1
add edx, hmteamrec	; 61EF3
add edx, byte 1Ah	; 61EF9
push edx	; 61EFC
xor eax, eax	; 61EFD
mov al, byte [byte_E9AD0]	; 61EFF
push eax	; 61F04
xor eax, eax	; 61F05
mov al, byte [byte_E9ACF]	; 61F07
push eax	; 61F0C
push str_FmtClockEvent	; 61F0D
push textline3	; 61F12
call sprintf_	; 61F17
add esp, byte 14h	; 61F1C
xor eax, eax	; 61F1F
mov al, byte [byte_E9ACD]	; 61F21
xor edx, edx	; 61F26
mov dl, byte [byte_E9ACA]	; 61F28
test al, 2	; 61F2E
je short .1	; 61F30
mov eax, str_SHTag	; 61F32
jmp short .3	; 61F37
.1:
test al, 4	; 61F39
je short .2	; 61F3B
mov eax, str_PPTag	; 61F3D
jmp short .3	; 61F42
.2:
mov eax, unk_C1B49	; 61F44
.3:
push eax	; 61F49
push str_S8	; 61F4A
lea eax, [byte esp+08h]	; 61F4F
push eax	; 61F53
call sprintf_	; 61F54
mov ecx, eax	; 61F59
add esp, byte 0Ch	; 61F5B
cmp dword [gamemode], byte 0	; 61F5E
je short .4	; 61F65
test byte [gmode], 10h	; 61F67
jne short .4	; 61F6E
cmp edx, byte 19h	; 61F70
jge short .4	; 61F73
mov eax, esi	; 61F75
shl eax, 2	; 61F77
sub eax, esi	; 61F7A
shl eax, 3	; 61F7C
lea ebx, [esi+eax]	; 61F7F
shl ebx, 4	; 61F82
mov eax, edx	; 61F85
shl eax, 4	; 61F87
add eax, ebx	; 61F8A
mov ebx, dword [dword eax+dword_DB088-2]	; 61F8C
sar ebx, 10h	; 61F92
add ebx, dword [dword eax+dword_DEB7C]	; 61F95
push ebx	; 61F9B
push str_FmtParenD	; 61F9C
lea eax, [byte esp+08h]	; 61FA1
add eax, ecx	; 61FA5
push eax	; 61FA7
call sprintf_	; 61FA8
add esp, byte 0Ch	; 61FAD
.4:
mov eax, esp	; 61FB0
push eax	; 61FB2
mov ebx, esi	; 61FB3
mov edi, esi	; 61FB5
shl edi, 4	; 61FB7
add edi, esi	; 61FBA
shl edi, 4	; 61FBC
add edi, esi	; 61FBF
shl edi, 2	; 61FC1
mov ebp, hmroster	; 61FC4
add ebp, edi	; 61FC9
mov eax, edx	; 61FCB
shl eax, 2	; 61FCD
add eax, edx	; 61FD0
shl eax, 3	; 61FD2
sub eax, edx	; 61FD5
lea ecx, [eax+ebp]	; 61FD7
lea edx, [byte ecx+017h]	; 61FDA
push edx	; 61FDD
add ecx, byte 7	; 61FDE
xor ebx, esi	; 61FE1
mov bl, byte [dword edi+eax+hmrosterjersey]	; 61FE3
mov edx, unk_C1B49	; 61FEA
mov eax, textline1	; 61FEF
call FormatPlayerName	; 61FF4
xor edx, edx	; 61FF9
mov dl, byte [byte_E9ACB]	; 61FFB
cmp edx, 0FFh	; 62001
jne short .5	; 62007
push str_Unassisted	; 62009
push textline2	; 6200E
call sprintf_	; 62013
add esp, byte 8	; 62018
jmp short .6	; 6201B
.5:
push str_Assists	; 6201D
push textline2	; 62022
call sprintf_	; 62027
add esp, byte 8	; 6202C
push unk_C1B49	; 6202F
mov eax, edx	; 62034
shl eax, 2	; 62036
add eax, edx	; 62039
shl eax, 3	; 6203B
sub eax, edx	; 6203E
mov edx, eax	; 62040
add eax, ebp	; 62042
lea ebx, [byte eax+017h]	; 62044
push ebx	; 62047
lea ecx, [byte eax+07h]	; 62048
xor ebx, ebx	; 6204B
mov bl, byte [dword edx+edi+hmrosterjersey]	; 6204D
mov edx, unk_C1B49	; 62054
mov eax, textline4	; 62059
call FormatPlayerName	; 6205E
.6:
xor edx, edx	; 62063
mov dl, byte [byte_E9ACC]	; 62065
cmp edx, 0FFh	; 6206B
je near .14	; 62071
push unk_C1B49	; 62077
mov ebx, esi	; 6207C
shl ebx, 4	; 6207E
add ebx, esi	; 62081
shl ebx, 4	; 62083
add ebx, esi	; 62086
shl ebx, 2	; 62088
mov ecx, hmroster	; 6208B
add ecx, ebx	; 62090
mov eax, edx	; 62092
shl eax, 2	; 62094
add eax, edx	; 62097
shl eax, 3	; 62099
sub eax, edx	; 6209C
lea edx, [ecx+eax]	; 6209E
lea ecx, [byte edx+017h]	; 620A1
push ecx	; 620A4
lea ecx, [byte edx+07h]	; 620A5
mov bl, byte [dword ebx+eax+hmrosterjersey]	; 620A8
and ebx, 0FFh	; 620AF
mov edx, unk_C1B49	; 620B5
mov eax, textline5	; 620BA
.7:
call FormatPlayerName	; 620BF
jmp near .14	; 620C4
.8:
cmp cl, 2	; 620C9
jne near .11	; 620CC
movzx esi, byte [byte_E9AC9]	; 620D2
xor edx, edx	; 620D9
mov dl, byte [byte_E9ACA]	; 620DB
cmp byte [byte_E9ACB], 11h	; 620E1
jne near .9	; 620E8
mov edx, dword [penshotteam]	; 620EE
mov eax, edx	; 620F4
shl eax, 2	; 620F6
sub eax, edx	; 620F9
shl eax, 3	; 620FB
mov edx, eax	; 620FE
shl eax, 5	; 62100
sub eax, edx	; 62103
add eax, hmteamrec	; 62105
push eax	; 6210A
xor eax, eax	; 6210B
mov al, byte [byte_E9ACF]	; 6210D
push eax	; 62112
xor eax, eax	; 62113
mov al, byte [byte_E9ACE]	; 62115
push eax	; 6211A
push str_FmtClockEvent	; 6211B
push textline3	; 62120
call sprintf_	; 62125
add esp, byte 14h	; 6212A
mov edi, textline1	; 6212D
mov esi, str_PenaltyShot	; 62132
movsd	; 62137
movsd	; 62138
movsd	; 62139
movsb	; 6213A
mov edi, textline2	; 6213B
mov esi, str_ToBeTakenBy	; 62140
movsd	; 62145
movsd	; 62146
movsd	; 62147
movsw	; 62148
movsb	; 6214A
push unk_C1B49	; 6214B
mov edx, dword [penshotteam]	; 62150
mov ebx, edx	; 62156
shl ebx, 4	; 62158
add ebx, edx	; 6215B
shl ebx, 4	; 6215D
add ebx, edx	; 62160
shl ebx, 2	; 62162
mov ecx, hmroster	; 62165
add ecx, ebx	; 6216A
mov edx, dword [penshotpnum]	; 6216C
mov eax, edx	; 62172
shl eax, 2	; 62174
add eax, edx	; 62177
shl eax, 3	; 62179
sub eax, edx	; 6217C
lea edx, [ecx+eax]	; 6217E
lea ecx, [byte edx+017h]	; 62181
push ecx	; 62184
lea ecx, [byte edx+07h]	; 62185
add eax, ebx	; 62188
xor ebx, ebx	; 6218A
mov bl, byte [dword eax+hmrosterjersey]	; 6218C
mov edx, unk_C1B49	; 62192
mov eax, textline4	; 62197
jmp near BuildEventLines.7	; 6219C
.9:
mov eax, esi	; 621A1
shl eax, 2	; 621A3
sub eax, esi	; 621A6
shl eax, 3	; 621A8
mov ebx, eax	; 621AB
shl eax, 5	; 621AD
sub eax, ebx	; 621B0
add eax, hmteamrec	; 621B2
push eax	; 621B7
xor eax, eax	; 621B8
mov al, byte [byte_E9ACF]	; 621BA
push eax	; 621BF
xor eax, eax	; 621C0
mov al, byte [byte_E9ACE]	; 621C2
push eax	; 621C7
push str_02d02dSPenalty	; 621C8
push textline3	; 621CD
call sprintf_	; 621D2
add esp, byte 14h	; 621D7
push unk_C1B49	; 621DA
mov ebx, esi	; 621DF
shl ebx, 4	; 621E1
add ebx, esi	; 621E4
shl ebx, 4	; 621E6
add ebx, esi	; 621E9
shl ebx, 2	; 621EB
mov ecx, hmroster	; 621EE
add ecx, ebx	; 621F3
mov eax, edx	; 621F5
shl eax, 2	; 621F7
add eax, edx	; 621FA
shl eax, 3	; 621FC
sub eax, edx	; 621FF
mov edx, eax	; 62201
add eax, ecx	; 62203
lea ecx, [byte eax+017h]	; 62205
push ecx	; 62208
lea ecx, [byte eax+07h]	; 62209
lea eax, [ebx+edx]	; 6220C
xor ebx, ebx	; 6220F
mov bl, byte [dword eax+hmrosterjersey]	; 62211
mov edx, unk_C1B49	; 62217
mov eax, textline1	; 6221C
call FormatPlayerName	; 62221
xor eax, eax	; 62226
mov al, byte [byte_E9ACB]	; 62228
mov edx, dword [nosplit eax*4+penaltynames]	; 6222D
mov eax, textline2	; 62234
call strcpy_	; 62239
movzx edi, byte [byte_E9ACC]	; 6223E
cmp edi, 0FFh	; 62245
jne short .10	; 6224B
mov edi, textline4	; 6224D
mov esi, str_GameMisconduct	; 62252
movsd	; 62257
movsd	; 62258
movsd	; 62259
movsd	; 6225A
jmp near .14	; 6225B
.10:
push edi	; 62260
push str_DMinutes	; 62261
push textline4	; 62266
call sprintf_	; 6226B
add esp, byte 0Ch	; 62270
jmp near .14	; 62273
.11:
cmp cl, 3	; 62278
jne near .14	; 6227B
movzx esi, byte [byte_E9AC9]	; 62281
xor edx, edx	; 62288
mov dl, byte [byte_E9ACA]	; 6228A
mov edi, dword [byte_E9ACB-3]	; 62290
sar edi, 18h	; 62296
mov eax, esi	; 62299
shl eax, 2	; 6229B
sub eax, esi	; 6229E
shl eax, 3	; 622A0
mov ebx, eax	; 622A3
shl eax, 5	; 622A5
sub eax, ebx	; 622A8
add eax, hmteamrec	; 622AA
push eax	; 622AF
xor eax, eax	; 622B0
mov al, byte [byte_E9ACE]	; 622B2
push eax	; 622B7
xor eax, eax	; 622B8
mov al, byte [byte_E9ACD]	; 622BA
push eax	; 622BF
push str_02d02dSInjury	; 622C0
push textline3	; 622C5
call sprintf_	; 622CA
add esp, byte 14h	; 622CF
push unk_C1B49	; 622D2
mov ebx, esi	; 622D7
shl ebx, 4	; 622D9
add ebx, esi	; 622DC
shl ebx, 4	; 622DE
add ebx, esi	; 622E1
shl ebx, 2	; 622E3
mov ecx, hmroster	; 622E6
add ecx, ebx	; 622EB
mov eax, edx	; 622ED
shl eax, 2	; 622EF
add eax, edx	; 622F2
shl eax, 3	; 622F4
sub eax, edx	; 622F7
add ecx, eax	; 622F9
lea edx, [byte ecx+017h]	; 622FB
push edx	; 622FE
add ecx, byte 7	; 622FF
mov bl, byte [dword ebx+eax+hmrosterjersey]	; 62302
and ebx, 0FFh	; 62309
mov edx, unk_C1B49	; 6230F
mov eax, textline1	; 62314
call FormatPlayerName	; 62319
test edi, edi	; 6231E
jle short .12	; 62320
push str_GoneForTheGame	; 62322
jmp short .13	; 62327
.12:
push str_GoneFor1Period	; 62329
.13:
push textline2	; 6232E
call sprintf_	; 62333
add esp, byte 8	; 62338
.14:
add esp, byte 0Ch	; 6233B
jmp near fileio_popebpx	; 6233E
%endif ; C
; C: src/engine/gamelog/PostGoalEvent.c
%ifdef CBUILD
%include "c/engine/gamelog/PostGoalEvent.inc"
%else
PostGoalEvent:
push dword 10h	; 62343
call __CHK	; 62348
push esi	; 6234D
push edi	; 6234E
push eax	; 6234F
mov byte [byte_E9AC8], 1	; 62350
mov al, byte [esp]	; 62357
mov byte [byte_E9AC9], al	; 6235A
mov byte [byte_E9ACA], dl	; 6235F
mov byte [byte_E9ACB], bl	; 62365
mov byte [byte_E9ACC], cl	; 6236B
mov al, byte [byte esp+010h]	; 62371
mov byte [byte_E9ACD], al	; 62375
mov al, byte [curperiod]	; 6237A
mov byte [byte_E9ACE], al	; 6237F
mov al, byte [byte esp+014h]	; 62384
mov byte [byte_E9ACF], al	; 62388
mov al, byte [byte esp+018h]	; 6238D
mov byte [byte_E9AD0], al	; 62391
mov eax, dword [esp]	; 62396
shl eax, 8	; 62399
mov dx, word [dword eax+hmtmgoalie]	; 6239C
xor dh, dh	; 623A3
and dl, 1	; 623A5
movsx edx, dx	; 623A8
mov eax, dword [dword eax+hmtmlines]	; 623AB
mov al, byte [byte edx+eax+024h]	; 623B1
mov byte [byte_E9AD1], al	; 623B5
cmp dword [esp], byte 0	; 623BA
sete al	; 623BE
and eax, 0FFh	; 623C1
shl eax, 8	; 623C6
mov ax, word [dword eax+hmtmgoalie]	; 623C9
xor ah, ah	; 623D0
and al, 1	; 623D2
movsx edx, ax	; 623D4
cmp dword [esp], byte 0	; 623D7
sete al	; 623DB
and eax, 0FFh	; 623DE
shl eax, 8	; 623E3
mov eax, dword [dword eax+hmtmlines]	; 623E6
mov al, byte [byte edx+eax+024h]	; 623EC
mov byte [byte_E9AD2], al	; 623F0
test byte [gmode], 10h	; 623F5
jne short .3	; 623FC
mov edx, dword [gsumqcount]	; 623FE
mov eax, edx	; 62404
shl eax, 2	; 62406
sub eax, edx	; 62409
shl eax, 2	; 6240B
sub eax, edx	; 6240E
lea edi, [dword eax+unk_E9B4C]	; 62410
mov esi, byte_E9AC8	; 62416
movsd	; 6241B
movsd	; 6241C
movsw	; 6241D
movsb	; 6241F
mov ecx, dword [gsumqcount]	; 62420
inc ecx	; 62426
mov dword [gsumqcount], ecx	; 62427
cmp ecx, byte 8	; 6242D
jl short .1	; 62430
lea edi, [byte ecx-01h]	; 62432
mov dword [gsumqcount], edi	; 62435
.1:
cmp dword [esp], byte 0	; 6243B
je short .2	; 6243F
inc byte [awgoalcnt]	; 62441
jmp short .3	; 62447
.2:
inc byte [hmgoalcnt]	; 62449
.3:
cmp dword [esp], byte 0	; 6244F
jne short .6	; 62453
mov eax, 14h	; 62455
call randomd0	; 6245A
cmp ax, 0Ah	; 6245F
jge short .4	; 62463
mov eax, 1	; 62465
jmp short .5	; 6246A
.4:
mov eax, 5	; 6246C
.5:
cwde	; 62471
call LoadTeamPPV	; 62472
.6:
call BuildEventLines	; 62477
call CloseTextOverlay	; 6247C
mov ax, word [joysampling]	; 62481
mov word [joysampling_save], ax	; 62487
xor edx, edx	; 6248D
mov dword [joysampling], edx	; 6248F
mov edi, byte_E9AD3	; 62495
mov esi, byte_E9AC8	; 6249A
movsd	; 6249F
movsd	; 624A0
movsw	; 624A1
movsb	; 624A3
mov eax, dword [joysampling_save-2]	; 624A4
sar eax, 10h	; 624A9
mov dword [joysampling], eax	; 624AC
add esp, byte 4	; 624B1
pop edi	; 624B4
pop esi	; 624B5
ret 0Ch	; 624B6
%endif ; C
; C: src/engine/gamelog/PostPenaltyEvent.c
%ifdef CBUILD
%include "c/engine/gamelog/PostPenaltyEvent.inc"
%else
PostPenaltyEvent:
push dword 2Ch	; 624B9
call __CHK	; 624BE
push esi	; 624C3
push edi	; 624C4
push ebp	; 624C5
push eax	; 624C6
push edx	; 624C7
mov edx, ecx	; 624C8
test byte [gmode], 10h	; 624CA
jne near .18	; 624D1
mov byte [byte_E9AC8], 2	; 624D7
mov al, byte [byte esp+04h]	; 624DE
mov byte [byte_E9AC9], al	; 624E2
mov al, byte [esp]	; 624E7
mov byte [byte_E9ACA], al	; 624EA
mov byte [byte_E9ACB], bl	; 624EF
mov byte [byte_E9ACC], dl	; 624F5
mov al, byte [curperiod]	; 624FB
mov byte [byte_E9ACD], al	; 62500
mov al, byte [byte esp+018h]	; 62505
mov byte [byte_E9ACE], al	; 62509
mov al, byte [byte esp+01Ch]	; 6250E
mov byte [byte_E9ACF], al	; 62512
mov ecx, dword [gsumqcount]	; 62517
mov eax, ecx	; 6251D
shl eax, 2	; 6251F
sub eax, ecx	; 62522
shl eax, 2	; 62524
sub eax, ecx	; 62527
lea edi, [dword eax+unk_E9B4C]	; 62529
mov esi, byte_E9AC8	; 6252F
movsd	; 62534
movsd	; 62535
movsw	; 62536
movsb	; 62538
mov ecx, dword [gsumqcount]	; 62539
inc ecx	; 6253F
mov dword [gsumqcount], ecx	; 62540
cmp ecx, byte 8	; 62546
jl short .1	; 62549
lea edi, [byte ecx-01h]	; 6254B
mov dword [gsumqcount], edi	; 6254E
.1:
mov eax, dword [ovltimer-2]	; 62554
sar eax, 10h	; 62559
cmp eax, byte 0FFFFFFFFh	; 6255C
jne near .6	; 6255F
cmp ebx, byte 11h	; 62565
je near .6	; 62568
cmp dword [byte esp+04h], byte 0	; 6256E
je short .2	; 62573
mov eax, 4	; 62575
call randomd0	; 6257A
test ax, ax	; 6257F
jne short .2	; 62582
mov eax, 0Ah	; 62584
jmp short .5	; 62589
.2:
cmp ebx, byte 4	; 6258B
jne short .3	; 6258E
mov eax, 3	; 62590
call randomd0	; 62595
test ax, ax	; 6259A
jne short .6	; 6259D
mov eax, 6	; 6259F
jmp short .5	; 625A4
.3:
cmp ebx, byte 6	; 625A6
jne short .4	; 625A9
mov eax, 3	; 625AB
call randomd0	; 625B0
test ax, ax	; 625B5
jne short .6	; 625B8
mov eax, 7	; 625BA
jmp short .5	; 625BF
.4:
cmp ebx, byte 5	; 625C1
jne short .6	; 625C4
mov eax, 3	; 625C6
call randomd0	; 625CB
test ax, ax	; 625D0
jne short .6	; 625D3
mov eax, 9	; 625D5
.5:
call LoadTeamPPV	; 625DA
.6:
call BuildEventLines	; 625DF
call CloseTextOverlay	; 625E4
mov ax, word [joysampling]	; 625E9
mov word [joysampling_save], ax	; 625EF
xor eax, eax	; 625F5
mov dword [joysampling], eax	; 625F7
cmp word [crowdlevel], 190h	; 625FC
jle short .7	; 62605
mov word [crowdlevel], 190h	; 62607
.7:
cmp dword [byte esp+04h], byte 0	; 62610
je short .8	; 62615
mov ax, word [VisTeam]	; 62617
jmp short .9	; 6261D
.8:
mov ax, word [HomeTeam]	; 6261F
.9:
movsx esi, ax	; 62625
cmp ebx, byte 11h	; 62628
jne short .12	; 6262B
cmp dword [penshotteam], byte 0	; 6262D
je short .10	; 62634
mov ax, word [VisTeam]	; 62636
jmp short .11	; 6263C
.10:
mov ax, word [HomeTeam]	; 6263E
.11:
movsx esi, ax	; 62644
mov edx, dword [penshotteam]	; 62647
mov ebx, edx	; 6264D
shl ebx, 4	; 6264F
add ebx, edx	; 62652
shl ebx, 4	; 62654
add ebx, edx	; 62657
shl ebx, 2	; 62659
mov edx, dword [penshotpnum]	; 6265C
mov eax, edx	; 62662
shl eax, 2	; 62664
add eax, edx	; 62667
shl eax, 3	; 62669
sub eax, edx	; 6266C
xor edx, edx	; 6266E
mov dl, byte [dword ebx+eax+hmrosterjersey]	; 62670
mov eax, dword [nosplit esi*4+teamabbrevs]	; 62677
mov ecx, dword [byte esp+01Ch]	; 6267E
mov ebx, dword [byte esp+018h]	; 62682
call PaPenaltyShot	; 62686
jmp near .17	; 6268B
.12:
cmp dword [byte esp+020h], byte 0	; 62690
sete al	; 62695
mov ebp, eax	; 62698
and ebp, 0FFh	; 6269A
mov eax, dword [word_E9AAE-2]	; 626A0
sar eax, 10h	; 626A5
cmp eax, dword [byte esp+04h]	; 626A8
jne short .13	; 626AC
mov eax, 2	; 626AE
jmp short .14	; 626B3
.13:
mov eax, 1	; 626B5
mov ecx, dword [byte esp+04h]	; 626BA
mov word [word_E9AAE], cx	; 626BE
.14:
mov edi, dword [byte esp+020h]	; 626C5
test edi, edi	; 626C9
je short .15	; 626CB
mov cl, byte [nosplit edi*2+byte_E9A15]	; 626CD
and cl, 1Fh	; 626D4
cmp cl, 6	; 626D7
setl cl	; 626DA
and ecx, 0FFh	; 626DD
xor ecx, dword [byte esp+04h]	; 626E3
je short .15	; 626E7
lea ecx, [byte eax+01h]	; 626E9
jmp short .16	; 626EC
.15:
mov ecx, eax	; 626EE
.16:
push ebp	; 626F0
push ecx	; 626F1
push eax	; 626F2
mov eax, dword [byte esp+028h]	; 626F3
push eax	; 626F7
mov ecx, dword [byte esp+028h]	; 626F8
push ecx	; 626FC
mov ecx, dword [nosplit ebx*4+off_CD354]	; 626FD
mov ebx, dword [byte esp+018h]	; 62704
mov edi, ebx	; 62708
shl edi, 4	; 6270A
add edi, ebx	; 6270D
shl edi, 4	; 6270F
add edi, ebx	; 62712
shl edi, 2	; 62714
mov ebx, dword [byte esp+014h]	; 62717
mov eax, ebx	; 6271B
shl eax, 2	; 6271D
add eax, ebx	; 62720
shl eax, 3	; 62722
sub eax, ebx	; 62725
movzx edi, byte [dword edi+eax+hmrosterjersey]	; 62727
mov eax, dword [nosplit esi*4+teamabbrevs]	; 6272F
mov ebx, edx	; 62736
mov edx, edi	; 62738
call PaPenalty	; 6273A
test ebp, ebp	; 6273F
je short .17	; 62741
mov word [word_E9AAE], 0FFFFh	; 62743
.17:
mov eax, dword [joysampling_save-2]	; 6274C
sar eax, 10h	; 62751
mov dword [joysampling], eax	; 62754
.18:
xor eax, eax	; 62759
add esp, byte 8	; 6275B
pop ebp	; 6275E
pop edi	; 6275F
pop esi	; 62760
ret 0Ch	; 62761
%endif ; C
; C: src/engine/gamelog/PostInjuryEvent.c
%ifdef CBUILD
%include "c/engine/gamelog/PostInjuryEvent.inc"
%else
PostInjuryEvent:
push dword 0Ch	; 62764
call __CHK	; 62769
push esi	; 6276E
push edi	; 6276F
test byte [gmode], 10h	; 62770
jne short .2	; 62777
mov byte [byte_E9AC8], 3	; 62779
mov byte [byte_E9AC9], al	; 62780
mov byte [byte_E9ACA], dl	; 62785
mov byte [byte_E9ACB], bl	; 6278B
mov al, byte [curperiod]	; 62791
mov byte [byte_E9ACC], al	; 62796
mov byte [byte_E9ACD], cl	; 6279B
mov al, byte [byte esp+0Ch]	; 627A1
mov byte [byte_E9ACE], al	; 627A5
mov edx, dword [gsumqcount]	; 627AA
mov eax, edx	; 627B0
shl eax, 2	; 627B2
sub eax, edx	; 627B5
shl eax, 2	; 627B7
sub eax, edx	; 627BA
lea edi, [dword eax+unk_E9B4C]	; 627BC
mov esi, byte_E9AC8	; 627C2
movsd	; 627C7
movsd	; 627C8
movsw	; 627C9
movsb	; 627CB
mov edx, dword [gsumqcount]	; 627CC
inc edx	; 627D2
mov dword [gsumqcount], edx	; 627D3
cmp edx, byte 8	; 627D9
jl short .1	; 627DC
lea ecx, [byte edx-01h]	; 627DE
mov dword [gsumqcount], ecx	; 627E1
.1:
call BuildEventLines	; 627E7
call CloseTextOverlay	; 627EC
.2:
xor eax, eax	; 627F1
pop edi	; 627F3
pop esi	; 627F4
ret 0Ch	; 627F5
%endif ; C
; C: src/engine/gamelog/PostInjuryEvent.c (NullCallback0C)
%ifdef CBUILD
%include "c/engine/gamelog/PostInjuryEvent.NullCallback0C.inc"
%else
NullCallback0C:
push dword 4	; 627F8
call __CHK	; 627FD
xor eax, eax	; 62802
ret 0Ch	; 62804
%endif ; C
ChkScorerMilestone:
push dword 30h	; 62807
call __CHK	; 6280C
push ebx	; 62811
push ecx	; 62812
push edx	; 62813
push esi	; 62814
push edi	; 62815
push ebp	; 62816
sub esp, byte 4	; 62817
mov edx, dword [pucky]	; 6281A
cmp word [edx], byte 0	; 62820
setl dl	; 62824
mov ebp, edx	; 62827
and ebp, 0FFh	; 62829
test byte [gmode], 2	; 6282F
setne dl	; 62836
and edx, 0FFh	; 62839
xor ebp, edx	; 6283F
lea edx, [byte ebp+ebp+00h]	; 62841
cmp byte [dword edx+byte_E024C], 0	; 62845
je short .1	; 6284C
cmp byte [dword edx+byte_E024D], 0	; 6284E
jne near .17	; 62855
.1:
xor esi, esi	; 6285B
mov edx, ebp	; 6285D
shl edx, 8	; 6285F
mov dx, word [dword edx+word_DF644]	; 62862
xor dh, dh	; 62869
movsx edi, dx	; 6286B
cmp edi, byte 19h	; 6286E
jge near .10	; 62871
mov edx, ebp	; 62877
shl edx, 2	; 62879
sub edx, ebp	; 6287C
shl edx, 3	; 6287E
lea ebx, [edx+ebp]	; 62881
shl ebx, 4	; 62884
mov edx, edi	; 62887
shl edx, 4	; 62889
add edx, ebx	; 6288C
mov ecx, dword [dword edx+dword_DB088-2]	; 6288E
sar ecx, 10h	; 62894
mov ebx, dword [dword edx+word_DB08A-2]	; 62897
sar ebx, 10h	; 6289D
add ebx, ecx	; 628A0
cmp ecx, byte 3	; 628A2
jne short .3	; 628A5
mov esi, 1	; 628A7
.2:
mov ebx, ecx	; 628AC
jmp near .10	; 628AE
.3:
cmp dword [gamemode], byte 0	; 628B3
je near .10	; 628BA
test byte [gameopts+1], 2	; 628C0
je near .8	; 628C7
mov eax, dword [dword edx+dword_DEB7C]	; 628CD
mov dword [esp], eax	; 628D3
mov eax, dword [dword edx+dword_DEB74]	; 628D6
add dword [esp], eax	; 628DC
mov eax, dword [esp]	; 628DF
add eax, ecx	; 628E2
cmp eax, byte 1	; 628E4
jne short .4	; 628E7
mov esi, 6	; 628E9
mov ebx, eax	; 628EE
jmp near .10	; 628F0
.4:
add ecx, dword [dword edx+dword_DEB7C]	; 628F5
cmp ecx, byte 32h	; 628FB
jl short .5	; 628FE
mov dword [esp], 32h	; 62900
mov eax, ecx	; 62907
mov edx, ecx	; 62909
sar edx, 1Fh	; 6290B
idiv dword [esp]	; 6290E
test edx, edx	; 62911
jne short .5	; 62913
mov esi, 2	; 62915
jmp short ChkScorerMilestone.2	; 6291A
.5:
mov edx, ebp	; 6291C
shl edx, 2	; 6291E
sub edx, ebp	; 62921
shl edx, 3	; 62923
add edx, ebp	; 62926
shl edx, 4	; 62928
mov dword [esp], edx	; 6292B
mov edx, edi	; 6292E
shl edx, 4	; 62930
add edx, dword [esp]	; 62933
add ebx, dword [dword edx+dword_DEB80]	; 62936
cmp ebx, byte 64h	; 6293C
jl short .6	; 6293F
mov dword [esp], 64h	; 62941
mov eax, ebx	; 62948
mov edx, ebx	; 6294A
sar edx, 1Fh	; 6294C
idiv dword [esp]	; 6294F
test edx, edx	; 62952
jne short .6	; 62954
mov esi, 4	; 62956
jmp near .10	; 6295B
.6:
mov edx, ebp	; 62960
shl edx, 2	; 62962
sub edx, ebp	; 62965
shl edx, 3	; 62967
add edx, ebp	; 6296A
shl edx, 4	; 6296C
mov eax, edi	; 6296F
shl eax, 4	; 62971
add edx, eax	; 62974
add ecx, dword [dword edx+dword_DEB74]	; 62976
cmp ecx, byte 64h	; 6297C
jl short .7	; 6297F
mov dword [esp], 64h	; 62981
mov eax, ecx	; 62988
mov edx, ecx	; 6298A
sar edx, 1Fh	; 6298C
idiv dword [esp]	; 6298F
test edx, edx	; 62992
jne short .7	; 62994
mov esi, 3	; 62996
jmp near ChkScorerMilestone.2	; 6299B
.7:
mov edx, ebp	; 629A0
shl edx, 2	; 629A2
sub edx, ebp	; 629A5
shl edx, 3	; 629A7
add edx, ebp	; 629AA
shl edx, 4	; 629AC
mov ecx, edi	; 629AF
shl ecx, 4	; 629B1
add ebx, dword [dword ecx+edx+dword_DEB78]	; 629B4
cmp ebx, byte 64h	; 629BB
jl near .10	; 629BE
mov ecx, 64h	; 629C4
mov eax, ebx	; 629C9
mov edx, ebx	; 629CB
sar edx, 1Fh	; 629CD
idiv ecx	; 629D0
test edx, edx	; 629D2
jne short .10	; 629D4
mov esi, 5	; 629D6
jmp short .10	; 629DB
.8:
add ecx, dword [dword edx+dword_DEB7C]	; 629DD
cmp ecx, byte 0Ah	; 629E3
jl short .9	; 629E6
mov dword [esp], 0Ah	; 629E8
mov eax, ecx	; 629EF
mov edx, ecx	; 629F1
sar edx, 1Fh	; 629F3
idiv dword [esp]	; 629F6
test edx, edx	; 629F9
jne short .9	; 629FB
mov esi, 7	; 629FD
jmp near ChkScorerMilestone.2	; 62A02
.9:
mov edx, ebp	; 62A07
shl edx, 2	; 62A09
sub edx, ebp	; 62A0C
shl edx, 3	; 62A0E
lea ecx, [edx+ebp]	; 62A11
shl ecx, 4	; 62A14
mov edx, edi	; 62A17
shl edx, 4	; 62A19
add ebx, dword [dword ecx+edx+dword_DEB80]	; 62A1C
cmp ebx, byte 14h	; 62A23
jl short .10	; 62A26
mov ecx, 14h	; 62A28
mov eax, ebx	; 62A2D
mov edx, ebx	; 62A2F
sar edx, 1Fh	; 62A31
idiv ecx	; 62A34
test edx, edx	; 62A36
jne short .10	; 62A38
mov esi, 8	; 62A3A
.10:
cmp dword [gamemode], byte 0	; 62A3F
je near .16	; 62A46
test esi, esi	; 62A4C
jne near .16	; 62A4E
mov edi, ebp	; 62A54
shl edi, 8	; 62A56
mov edi, dword [dword edi+dword_DF646-2]	; 62A59
sar edi, 10h	; 62A5F
test edi, edi	; 62A62
jl near .16	; 62A64
cmp edi, byte 19h	; 62A6A
jge near .16	; 62A6D
mov edx, ebp	; 62A73
shl edx, 2	; 62A75
sub edx, ebp	; 62A78
shl edx, 3	; 62A7A
lea ebx, [edx+ebp]	; 62A7D
shl ebx, 4	; 62A80
mov edx, edi	; 62A83
shl edx, 4	; 62A85
add edx, ebx	; 62A88
mov ecx, dword [dword edx+word_DB08A-2]	; 62A8A
sar ecx, 10h	; 62A90
mov ebx, dword [dword edx+dword_DB088-2]	; 62A93
sar ebx, 10h	; 62A99
add ebx, ecx	; 62A9C
test byte [gameopts+1], 2	; 62A9E
je short .12	; 62AA5
add ebx, dword [dword edx+dword_DEB80]	; 62AA7
cmp ebx, byte 64h	; 62AAD
jl short .11	; 62AB0
mov ecx, 64h	; 62AB2
mov eax, ebx	; 62AB7
mov edx, ebx	; 62AB9
sar edx, 1Fh	; 62ABB
idiv ecx	; 62ABE
test edx, edx	; 62AC0
jne short .11	; 62AC2
mov esi, 4	; 62AC4
jmp short .13	; 62AC9
.11:
mov edx, ebp	; 62ACB
shl edx, 2	; 62ACD
sub edx, ebp	; 62AD0
shl edx, 3	; 62AD2
add edx, ebp	; 62AD5
shl edx, 4	; 62AD7
mov ecx, edi	; 62ADA
shl ecx, 4	; 62ADC
add ebx, dword [dword ecx+edx+dword_DEB78]	; 62ADF
cmp ebx, byte 64h	; 62AE6
jl short .13	; 62AE9
mov ecx, 64h	; 62AEB
mov eax, ebx	; 62AF0
mov edx, ebx	; 62AF2
sar edx, 1Fh	; 62AF4
idiv ecx	; 62AF7
test edx, edx	; 62AF9
jne short .13	; 62AFB
mov esi, 5	; 62AFD
jmp short .13	; 62B02
.12:
add ebx, dword [dword edx+dword_DEB80]	; 62B04
cmp ebx, byte 14h	; 62B0A
jl short .13	; 62B0D
mov ecx, 14h	; 62B0F
mov eax, ebx	; 62B14
mov edx, ebx	; 62B16
sar edx, 1Fh	; 62B18
idiv ecx	; 62B1B
test edx, edx	; 62B1D
jne short .13	; 62B1F
mov esi, 8	; 62B21
.13:
test esi, esi	; 62B26
jne near .16	; 62B28
mov edi, ebp	; 62B2E
shl edi, 8	; 62B30
mov edi, dword [dword edi+dword_DF648-2]	; 62B33
sar edi, 10h	; 62B39
test edi, edi	; 62B3C
jl near .16	; 62B3E
cmp edi, byte 19h	; 62B44
jge near .16	; 62B47
mov edx, ebp	; 62B4D
shl edx, 2	; 62B4F
sub edx, ebp	; 62B52
shl edx, 3	; 62B54
lea ebx, [edx+ebp]	; 62B57
shl ebx, 4	; 62B5A
mov edx, edi	; 62B5D
shl edx, 4	; 62B5F
add edx, ebx	; 62B62
mov ecx, dword [dword edx+word_DB08A-2]	; 62B64
sar ecx, 10h	; 62B6A
mov ebx, dword [dword edx+dword_DB088-2]	; 62B6D
sar ebx, 10h	; 62B73
add ebx, ecx	; 62B76
test byte [gameopts+1], 2	; 62B78
je short .15	; 62B7F
add ebx, dword [dword edx+dword_DEB80]	; 62B81
cmp ebx, byte 64h	; 62B87
jl short .14	; 62B8A
mov ecx, 64h	; 62B8C
mov eax, ebx	; 62B91
mov edx, ebx	; 62B93
sar edx, 1Fh	; 62B95
idiv ecx	; 62B98
test edx, edx	; 62B9A
jne short .14	; 62B9C
mov esi, 4	; 62B9E
jmp short .16	; 62BA3
.14:
mov edx, ebp	; 62BA5
shl edx, 2	; 62BA7
sub edx, ebp	; 62BAA
shl edx, 3	; 62BAC
lea ecx, [edx+ebp]	; 62BAF
shl ecx, 4	; 62BB2
mov edx, edi	; 62BB5
shl edx, 4	; 62BB7
add ebx, dword [dword ecx+edx+dword_DEB78]	; 62BBA
cmp ebx, byte 64h	; 62BC1
jl short .16	; 62BC4
mov ecx, 64h	; 62BC6
mov eax, ebx	; 62BCB
mov edx, ebx	; 62BCD
sar edx, 1Fh	; 62BCF
idiv ecx	; 62BD2
test edx, edx	; 62BD4
jne short .16	; 62BD6
mov esi, 5	; 62BD8
jmp short .16	; 62BDD
.15:
add ebx, dword [dword edx+dword_DEB80]	; 62BDF
cmp ebx, byte 14h	; 62BE5
jl short .16	; 62BE8
mov ecx, 14h	; 62BEA
mov eax, ebx	; 62BEF
mov edx, ebx	; 62BF1
sar edx, 1Fh	; 62BF3
idiv ecx	; 62BF6
test edx, edx	; 62BF8
jne short .16	; 62BFA
mov esi, 8	; 62BFC
.16:
test esi, esi	; 62C01
je short .17	; 62C03
push byte 0	; 62C05
push byte 0	; 62C07
push byte 0	; 62C09
push ebx	; 62C0B
mov ecx, esi	; 62C0C
mov ebx, edi	; 62C0E
mov edx, ebp	; 62C10
mov eax, MenuCallbackTrue2	; 62C12
call QueueDeferredCall	; 62C17
mov dword [deferpending], 1	; 62C1C
mov word [ovltimer], 0FFFFh	; 62C26
.17:
add esp, byte 4	; 62C2F
jmp near fileio_popebpx	; 62C32
; C: src/engine/gamelog/QueueGoalieNote.c
%ifdef CBUILD
%include "c/engine/gamelog/QueueGoalieNote.inc"
%else
QueueGoalieNote:
push dword 24h	; 62C37
call __CHK	; 62C3C
push ebx	; 62C41
push ecx	; 62C42
push edx	; 62C43
push esi	; 62C44
cmp dword [dword_CC0AC], byte 3Fh	; 62C45
jne short .2	; 62C4C
.1:
xor eax, eax	; 62C4E
pop esi	; 62C50
pop edx	; 62C51
pop ecx	; 62C52
pop ebx	; 62C53
ret	; 62C54
.2:
cmp word [word_C90D8], byte 0	; 62C55
jl short QueueGoalieNote.1	; 62C5D
mov eax, dword [word_C90D8-2]	; 62C5F
sar eax, 10h	; 62C64
shl eax, 7	; 62C67
add eax, SortCords	; 62C6A
test byte [byte eax+044h], 40h	; 62C6F
setne dl	; 62C73
xor ebx, ebx	; 62C76
mov bl, dl	; 62C78
mov esi, ebx	; 62C7A
mov edx, dword [byte eax+06Ch]	; 62C7C
mov ecx, dword [byte edx+tmgoalie-2]	; 62C7F
sar ecx, 10h	; 62C82
mov edx, 1	; 62C85
shl edx, cl	; 62C8A
test ebx, ebx	; 62C8C
je short .3	; 62C8E
shl edx, 3	; 62C90
.3:
mov ebx, dword [dword_CC0AC]	; 62C93
test edx, ebx	; 62C99
jne short QueueGoalieNote.1	; 62C9B
mov ecx, ebx	; 62C9D
or ecx, edx	; 62C9F
mov dword [dword_CC0AC], ecx	; 62CA1
push byte 0	; 62CA7
push byte 0	; 62CA9
push byte 0	; 62CAB
push byte 0	; 62CAD
mov ebx, dword [byte eax+044h]	; 62CAF
sar ebx, 18h	; 62CB2
xor ecx, ecx	; 62CB5
mov edx, esi	; 62CB7
mov eax, MenuCallbackTrue	; 62CB9
call QueueDeferredCall	; 62CBE
mov dword [deferpending], 1	; 62CC3
mov eax, 1	; 62CCD
pop esi	; 62CD2
pop edx	; 62CD3
pop ecx	; 62CD4
pop ebx	; 62CD5
ret	; 62CD6
%endif ; C
