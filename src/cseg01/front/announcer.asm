; The announcer. The timer that feeds the speech queue, the speech bank, loading samples into memory
; and finding a free slot, and building a sentence from clips for a goal, a penalty, a score, and the
; playoff round. One module (ShutdownSpeech's exits).
bits 32
%include "hockey.inc"
section s_832BC progbits alloc exec nowrite align=1
extern __CHK, __CHP, __STOSD, _dos_close_, _dos_open_, _dos_read_, _fmemmove_, _os_handle_3
extern addtimer, asc_C36C3, byte_C541B, byte_D2439, byte_D27B6, cddriveptr, ClearInputQueue, DrawSelBoxOff
extern DrawSelBoxOn, dword_C4CFC, dword_CCC94, dword_CCC98, dword_D2350, dword_D2423, dword_D2427, dword_D242B
extern dword_D2435, dword_D27A2, dword_D27B2, dword_ED7A4, dword_ED7A8, FatalError, fclose_, fileoncd
extern fopen_, fprintf_, FreeMemBlock, gameopts, GetInputEvent, itoa_, lseek_, MakePath
extern MessageBox, msg_InitMT32, musichandle, musicon, musicslot, penaltyclips, PlayDigiSample, pointerspr
extern ptrupdatefn, qword_C37B0, qword_C37B8, qword_C37C0, qword_C37C8, qword_C37D0, RedrawSoundCardOpts, RemoveTimerCallback
extern RestoreDialogBg, samplereq, scorperclips, setbits, SetDialogColors, SetTickDeadline, sndcardname, songdata
extern SoundCardHitTest, sounddev, sounddevids, speechbank, speechcopybuf, speechcopylen, speechinit, speechq
extern sprintf_, str_02dS, str_1minuteCor, str_1secondCor, str_2minCor, str_5minCor, str_ADLIB, str_Adlib
extern str_AndBar, str_AndnumCor, str_AsstnumCor, str_AtCor, str_Awa, str_BackmomtInt, str_Bar, str_BetweenBar
extern str_CantOpenNhlCfg, str_CFG, str_CoachclpInt, str_Cor, str_DS, str_EasportsBar, str_EastfindBar, str_EastfinuBar
extern str_EastquadBar, str_EastquauBar, str_EastsemdBar, str_EastsemuBar, str_ElsenhlInt, str_Emmcopybuf, str_Frm, str_GamebtwnBar
extern str_GamemiscS, str_Gamenum, str_GamenumBar, str_GoalnumCor, str_GoodniteInt, str_HavewonBar, str_HighliteBar, str_Hom
extern str_Iff12, str_LineupsInt, str_Maindesk2, str_MinutesCor, str_MT322, str_MT323, str_MT32HOCK, str_NHL3
extern str_NhlInt, str_NowbackInt, str_Num, str_NumberCor, str_OfBar, str_OneleftCor, str_OvertimeBar, str_PauseCor
extern str_PC, str_PCBEEP, str_PCBEEP2, str_Pen, str_PennumCor, str_PenshotCor, str_PensnumCor, str_Pointer21
extern str_Rnk, str_SampleMemMan, str_SBDAC, str_SBDAC2, str_Scor1otpBar, str_Scor1perBar, str_Scor2otpBar, str_Scor2perBar
extern str_Scor3otpBar, str_Scor3perBar, str_ScortotpBar, str_SecondsCor, str_Sentence, str_Slapshot, str_SoundBlaster2, str_SpeechBank
extern str_Speechbuf, str_SS5, str_SSS, str_StanleydBar, str_StanleyuBar, str_TakeynowBar, str_Tea, str_ThegameBar
extern str_TonightBar, str_ULTRASOUND, str_VIV, str_WestfindBar, str_WestfinuBar, str_WestquadBar, str_WestquauBar, str_WestsemdBar
extern str_WestsemuBar, str_XBRUCE2, strcpy_, strncpy_, sub_8CC70, sub_8CCA8, sub_8D2F0, sub_8DBD4
extern sub_8EB5B, sub_8EB93, sub_8ECC0, sub_8F13B, sub_8F1FE, sub_8F98F, sub_8FB8E, sub_8FBE5
extern sub_8FC37, sub_8FC8A, sub_8FCAC, sub_8FCDF, sub_903F0, sub_91370, sub_91400, sub_97079
extern sub_98028, sub_B2DCA, sub_B4BA8, unk_C36AC, unk_D2403, unk_D2413, unk_D249C, WaitDigiSample
extern WaitTickDeadline
global SpeechTimerTick, ClearSpeechSlot, ResetSpeechQueue, InitSpeechSlots, ResetSampleReq, InitSpeech, ShutdownSpeech, ShutdownSpeech_ret6
global ShutdownSpeech_ret5, SpeechIsInit, SpeechBusy, SpeechIdle, MusicChanReset2, SpeechStopQueue, MusicChanCmd3, MusicChanReset
global Swap16, ReadBE24, ReadBE24_ret, ReadCString, OpenSpeechBank, OpenSpeechBank_ret, SpeechSlotSize, ReadSpeechSample
global LoadSpeechSlot, PlaceSpeechSlot, StrEqNoCase, FindFreeSpeechSlot, FindLoadedSpeechSlot, FindSpeechSlot, SpeechSlotLoaded, IsSampleRequested
global RequestSample, FreeUnrequestedSamples, MoveSampleMem, CompactSpeechSlot, MakeSampleRoom, EnsureSampleRoom, CompactSpeechMem, PenaltyLenClip
global PlayoffRoundClipD, PlayoffRoundClipU, QueueSpeechClip, LoadClipSlot, SayClip_body, SayScorePeriod, SayNhlIntro, SayGoodnight
global SayLineups, SayNowBack, FreeNowBack, SayBackMoment, FreeBackMoment, SayCoachClip, FreeCoachClip, FreeClip
global FreeClip_ret, SayElseNhl, SayHighlightIntro, SayPlayoffResult, SayTheGame, SayScoringPeriod, SayClip, SayScoringPeriod_ot2
global SayScoringPeriod_ot3, SayScoringPeriod_ott, SayScoringPeriod_reg, SayTonightIntro, SayPlayoffTonight, RequestTimeClips, QueueTimeClips, SayPenalty
global SayPenaltyShot, SayPlayerNumber, SayGoal, SayOneMinuteLeft, OpenAnnouncerBank, QueuePenaltyType, PreloadAnnouncerClips
; C: src/c/front/announcer/ShutdownSpeech.c (SpeechTimerTick)
%ifdef CBUILD
%include "c/front/announcer/ShutdownSpeech.SpeechTimerTick.inc"
%else
SpeechTimerTick:
push dword 20h	; 832BC
call __CHK	; 832C1
push ebx	; 832C6
push ecx	; 832C7
push edx	; 832C8
push esi	; 832C9
push edi	; 832CA
cmp dword [speechinit], byte 0	; 832CB
je near ShutdownSpeech_ret5	; 832D2
mov eax, dword [speechq]	; 832D8
mov ebx, dword [byte eax+05Ch]	; 832DD
test ebx, ebx	; 832E0
je short .1	; 832E2
lea ecx, [byte ebx-01h]	; 832E4
mov dword [byte eax+05Ch], ecx	; 832E7
.1:
mov eax, dword [speechq]	; 832EA
cmp dword [byte eax+060h], byte 0	; 832EF
je near ShutdownSpeech_ret5	; 832F3
mov edi, dword [byte eax+050h]	; 832F9
test edi, edi	; 832FC
je short .2	; 832FE
lea ecx, [byte edi-01h]	; 83300
mov dword [byte eax+050h], ecx	; 83303
jmp near ShutdownSpeech_ret5	; 83306
.2:
mov ecx, dword [byte eax+058h]	; 8330B
lea edx, [byte ecx+01h]	; 8330E
mov dword [byte eax+058h], edx	; 83311
mov edx, dword [speechq]	; 83314
cmp ecx, dword [byte edx+054h]	; 8331A
jge near .5	; 8331D
mov eax, ecx	; 83323
mov ecx, dword [edx+eax*4]	; 83325
cmp ecx, byte 0FFFFFFFFh	; 83328
jne short .3	; 8332B
mov dword [byte edx+060h], edi	; 8332D
jmp near ShutdownSpeech_ret5	; 83330
.3:
mov eax, ecx	; 83335
shl eax, 2	; 83337
add eax, ecx	; 8333A
shl eax, 2	; 8333C
sub eax, ecx	; 8333F
add eax, eax	; 83341
mov ebx, dword [speechbank]	; 83343
add eax, ebx	; 83349
mov esi, dword [byte eax+0Eh]	; 8334B
mov ecx, dword [byte eax+016h]	; 8334E
mov ebx, dword [byte eax+01Eh]	; 83351
mov dword [byte edx+050h], ebx	; 83354
mov edx, dword [dword_D27B2]	; 83357
inc edx	; 8335D
mov dword [dword_D27B2], edx	; 8335E
mov ebx, edx	; 83364
and ebx, byte 1	; 83366
mov dword [dword_D27B2], ebx	; 83369
cmp byte [byte eax+0Dh], 47h	; 8336F
jne short .4	; 83373
push byte 7Fh	; 83375
push dword 2B11h	; 83377
mov edx, dword [musichandle]	; 8337C
mov eax, esi	; 83382
call sub_8FBE5	; 83384
jmp near ShutdownSpeech_ret5	; 83389
.4:
add ecx, ecx	; 8338E
push byte 7Fh	; 83390
push dword 2B11h	; 83392
mov edx, dword [musichandle]	; 83397
mov eax, esi	; 8339D
call sub_8FC37	; 8339F
jmp near ShutdownSpeech_ret5	; 833A4
.5:
mov dword [byte edx+060h], edi	; 833A9
mov eax, dword [speechbank]	; 833AC
mov edx, dword [speechq]	; 833B1
mov eax, dword [dword eax+03B70h]	; 833B7
mov dword [byte edx+05Ch], eax	; 833BD
jmp near ShutdownSpeech_ret5	; 833C0
%endif ; C
; C: src/c/front/announcer/ClearSpeechSlot.c
%ifdef CBUILD
%include "c/front/announcer/ClearSpeechSlot.inc"
%else
ClearSpeechSlot:
push dword 4	; 833C5
call __CHK	; 833CA
mov byte [eax], 0	; 833CF
mov byte [byte eax+0Dh], 0	; 833D2
mov dword [byte eax+0Eh], 0	; 833D6
mov dword [byte eax+012h], 0	; 833DD
mov dword [byte eax+016h], 0	; 833E4
mov dword [byte eax+01Eh], 0	; 833EB
mov dword [byte eax+022h], 0	; 833F2
ret	; 833F9
%endif ; C
; C: src/c/front/announcer/ResetSpeechQueue.c
%ifdef CBUILD
%include "c/front/announcer/ResetSpeechQueue.inc"
%else
ResetSpeechQueue:
push dword 0Ch	; 833FA
call __CHK	; 833FF
push ecx	; 83404
push edx	; 83405
mov eax, dword [speechq]	; 83406
mov dword [byte eax+060h], 0	; 8340B
mov eax, dword [speechq]	; 83412
mov ecx, 14h	; 83417
mov edx, 0FFFFFFFFh	; 8341C
call __STOSD	; 83421
mov eax, dword [speechq]	; 83426
mov dword [byte eax+054h], 0	; 8342B
mov eax, dword [speechq]	; 83432
mov dword [byte eax+058h], 0	; 83437
mov eax, dword [speechq]	; 8343E
mov dword [byte eax+050h], 0	; 83443
mov eax, dword [speechq]	; 8344A
mov dword [byte eax+05Ch], 0	; 8344F
pop edx	; 83456
pop ecx	; 83457
ret	; 83458
%endif ; C
; C: src/c/front/announcer/InitSpeechSlots.c
%ifdef CBUILD
%include "c/front/announcer/InitSpeechSlots.inc"
%else
InitSpeechSlots:
push dword 1Ch	; 83459
call __CHK	; 8345E
push ebx	; 83463
push ecx	; 83464
push edx	; 83465
mov ecx, eax	; 83466
xor edx, edx	; 83468
.1:
mov eax, edx	; 8346A
shl eax, 2	; 8346C
add eax, edx	; 8346F
shl eax, 2	; 83471
sub eax, edx	; 83474
add eax, eax	; 83476
mov ebx, dword [speechbank]	; 83478
add eax, ebx	; 8347E
call ClearSpeechSlot	; 83480
inc edx	; 83485
cmp edx, 190h	; 83486
jl short InitSpeechSlots.1	; 8348C
mov eax, dword [speechbank]	; 8348E
lea edx, [dword ecx-01388h]	; 83493
mov dword [dword eax+03B68h], edx	; 83499
mov edx, dword [dword_CCC94]	; 8349F
push edx	; 834A5
push ecx	; 834A6
push str_Speechbuf	; 834A7
call sub_8CC70	; 834AC
add esp, byte 0Ch	; 834B1
mov edx, dword [speechbank]	; 834B4
mov dword [dword edx+03B60h], eax	; 834BA
mov eax, dword [speechbank]	; 834C0
mov ebx, dword [dword eax+03B60h]	; 834C5
push ebx	; 834CB
call sub_8DBD4	; 834CC
add esp, byte 4	; 834D1
mov edx, dword [speechbank]	; 834D4
mov dword [dword edx+03B64h], eax	; 834DA
mov eax, dword [speechbank]	; 834E0
mov dword [dword eax+03B6Ch], 0	; 834E5
mov eax, dword [speechbank]	; 834EF
mov dword [dword eax+03B74h], 0	; 834F4
mov eax, dword [speechbank]	; 834FE
mov dword [dword eax+03B70h], 0	; 83503
mov eax, dword [speechbank]	; 8350D
mov dword [dword eax+03B78h], 0	; 83512
pop edx	; 8351C
pop ecx	; 8351D
pop ebx	; 8351E
ret	; 8351F
%endif ; C
; C: src/c/front/announcer/ResetSampleReq.c
%ifdef CBUILD
%include "c/front/announcer/ResetSampleReq.inc"
%else
ResetSampleReq:
push dword 0Ch	; 83520
call __CHK	; 83525
push ebx	; 8352A
push edx	; 8352B
xor edx, edx	; 8352C
.1:
mov eax, edx	; 8352E
shl eax, 2	; 83530
sub eax, edx	; 83533
shl eax, 2	; 83535
lea ebx, [edx+eax]	; 83538
mov eax, dword [samplereq]	; 8353B
mov byte [ebx+eax], 0	; 83540
inc edx	; 83544
cmp edx, byte 14h	; 83545
jl short ResetSampleReq.1	; 83548
mov eax, dword [samplereq]	; 8354A
mov dword [dword eax+010Ch], 0	; 8354F
mov eax, dword [samplereq]	; 83559
mov dword [dword eax+0108h], 0	; 8355E
mov eax, dword [samplereq]	; 83568
mov dword [dword eax+0104h], 0	; 8356D
pop edx	; 83577
pop ebx	; 83578
ret	; 83579
%endif ; C
; C: src/c/front/announcer/InitSpeech.c
%ifdef CBUILD
%include "c/front/announcer/InitSpeech.inc"
%else
InitSpeech:
push dword 1Ch	; 8357A
call __CHK	; 8357F
push esi	; 83584
push edi	; 83585
sub esp, byte 4	; 83586
mov byte [esp], al	; 83589
mov esi, edx	; 8358C
call SpeechIsInit	; 8358E
test eax, eax	; 83593
jne near .x	; 83595
mov al, byte [esp]	; 8359B
mov byte [byte_D27B6], al	; 8359E
xor edx, edx	; 835A3
mov dword [dword_D27B2], edx	; 835A5
mov dword [speechcopybuf], ebx	; 835AB
mov dword [speechcopylen], ecx	; 835B1
mov ebx, dword [dword_CCC94]	; 835B7
push ebx	; 835BD
push byte 64h	; 835BE
push str_Sentence	; 835C0
call sub_8CCA8	; 835C5
add esp, byte 0Ch	; 835CA
mov dword [speechq], eax	; 835CD
call ResetSpeechQueue	; 835D2
mov ecx, dword [dword_CCC94]	; 835D7
push ecx	; 835DD
push dword 110h	; 835DE
push str_SampleMemMan	; 835E3
call sub_8CCA8	; 835E8
add esp, byte 0Ch	; 835ED
mov dword [samplereq], eax	; 835F0
call ResetSampleReq	; 835F5
mov edi, dword [dword_CCC94]	; 835FA
push edi	; 83600
push dword 3B93h	; 83601
push str_SpeechBank	; 83606
call sub_8CCA8	; 8360B
add esp, byte 0Ch	; 83610
mov dword [speechbank], eax	; 83613
mov eax, esi	; 83618
call InitSpeechSlots	; 8361A
push SpeechTimerTick	; 8361F
call addtimer	; 83624
add esp, byte 4	; 83629
mov dword [speechinit], 1	; 8362C
.x:
add esp, byte 4	; 83636
pop edi	; 83639
pop esi	; 8363A
ret	; 8363B
%endif ; C
; C: src/c/front/announcer/ShutdownSpeech.c
%ifdef CBUILD
%include "c/front/announcer/ShutdownSpeech.inc"
%else
ShutdownSpeech:
push dword 20h	; 8363C
call __CHK	; 83641
push ebx	; 83646
push ecx	; 83647
push edx	; 83648
push esi	; 83649
push edi	; 8364A
push ebp	; 8364B
cmp dword [speechinit], byte 0	; 8364C
je short ShutdownSpeech_ret6	; 83653
push SpeechTimerTick	; 83655
call RemoveTimerCallback	; 8365A
add esp, byte 4	; 8365F
mov eax, dword [speechbank]	; 83662
cmp dword [dword eax+03B78h], byte 0	; 83667
je short .1	; 8366E
mov eax, dword [dword eax+03B7Ch]	; 83670
call _dos_close_	; 83676
.1:
mov ecx, dword [speechq]	; 8367B
push ecx	; 83681
call FreeMemBlock	; 83682
add esp, byte 4	; 83687
mov eax, dword [speechbank]	; 8368A
mov esi, dword [dword eax+03B60h]	; 8368F
push esi	; 83695
call sub_8D2F0	; 83696
add esp, byte 4	; 8369B
mov edi, dword [speechbank]	; 8369E
push edi	; 836A4
call FreeMemBlock	; 836A5
add esp, byte 4	; 836AA
mov ebp, dword [samplereq]	; 836AD
push ebp	; 836B3
call FreeMemBlock	; 836B4
add esp, byte 4	; 836B9
xor eax, eax	; 836BC
mov dword [speechinit], eax	; 836BE
ShutdownSpeech_ret6:
pop ebp	; 836C3
ShutdownSpeech_ret5:
pop edi	; 836C4
pop esi	; 836C5
pop edx	; 836C6
pop ecx	; 836C7
pop ebx	; 836C8
ret	; 836C9
%endif ; C
; C: src/c/front/announcer/SpeechIsInit.c
%ifdef CBUILD
%include "c/front/announcer/SpeechIsInit.inc"
%else
SpeechIsInit:
push dword 4	; 836CA
call __CHK	; 836CF
cmp dword [speechinit], byte 0	; 836D4
setne al	; 836DB
and eax, 0FFh	; 836DE
ret	; 836E3
%endif ; C
; C: src/c/front/announcer/SpeechBusy.c
%ifdef CBUILD
%include "c/front/announcer/SpeechBusy.inc"
%else
SpeechBusy:
push dword 4	; 836E4
call __CHK	; 836E9
cmp dword [speechinit], byte 0	; 836EE
je short .3	; 836F5
mov eax, dword [speechq]	; 836F7
cmp dword [byte eax+060h], byte 0	; 836FC
je short .2	; 83700
.1:
mov eax, 1	; 83702
ret	; 83707
.2:
cmp dword [byte eax+05Ch], byte 0	; 83708
jne short SpeechBusy.1	; 8370C
.3:
xor eax, eax	; 8370E
ret	; 83710
%endif ; C
; C: src/c/front/announcer/SpeechIdle.c
%ifdef CBUILD
%include "c/front/announcer/SpeechIdle.inc"
%else
SpeechIdle:
push dword 4	; 83711
call __CHK	; 83716
cmp dword [speechinit], byte 0	; 8371B
jne short .2	; 83722
.1:
xor eax, eax	; 83724
ret	; 83726
.2:
mov eax, dword [speechq]	; 83727
cmp dword [byte eax+060h], byte 0	; 8372C
jne short SpeechIdle.1	; 83730
cmp dword [byte eax+05Ch], byte 0	; 83732
jne short SpeechIdle.1	; 83736
mov eax, 1	; 83738
ret	; 8373D
%endif ; C
; C: src/c/front/announcer/MusicChanReset2.c
%ifdef CBUILD
%include "c/front/announcer/MusicChanReset2.inc"
%else
MusicChanReset2:
push dword 4	; 8373E
call __CHK	; 83743
call MusicChanReset	; 83748
SpeechStopQueue:
push dword 10h	; 8374D
call __CHK	; 83752
push ebx	; 83757
push ecx	; 83758
push edx	; 83759
cmp dword [speechinit], byte 0	; 8375A
je short .x	; 83761
mov eax, dword [speechq]	; 83763
mov dword [byte eax+060h], 0	; 83768
mov eax, dword [speechq]	; 8376F
mov ebx, dword [speechbank]	; 83774
mov edx, dword [byte eax+050h]	; 8377A
mov ecx, dword [dword ebx+03B70h]	; 8377D
add edx, ecx	; 83783
mov dword [byte eax+05Ch], edx	; 83785
.x:
pop edx	; 83788
pop ecx	; 83789
pop ebx	; 8378A
ret	; 8378B
%endif ; C
; C: src/c/front/announcer/MusicChanCmd3.c
%ifdef CBUILD
%include "c/front/announcer/MusicChanCmd3.inc"
%else
MusicChanCmd3:
push dword 8	; 8378C
call __CHK	; 83791
push edx	; 83796
mov eax, dword [musichandle]	; 83797
mov edx, 3	; 8379C
call sub_8FCAC	; 837A1
pop edx	; 837A6
ret	; 837A7
%endif ; C
; C: src/c/front/announcer/MusicChanReset.c
%ifdef CBUILD
%include "c/front/announcer/MusicChanReset.inc"
%else
MusicChanReset:
push dword 8	; 837A8
call __CHK	; 837AD
push edx	; 837B2
cmp dword [speechinit], byte 0	; 837B3
je short .x	; 837BA
mov eax, dword [musichandle]	; 837BC
xor edx, edx	; 837C1
call sub_8FCAC	; 837C3
mov eax, dword [musichandle]	; 837C8
mov edx, 1	; 837CD
call sub_8FCAC	; 837D2
.x:
pop edx	; 837D7
ret	; 837D8
%endif ; C
; C: src/c/front/announcer/Swap16.c
%ifdef CBUILD
%include "c/front/announcer/Swap16.inc"
%else
Swap16:
push dword 8	; 837D9
call __CHK	; 837DE
push edx	; 837E3
mov edx, eax	; 837E4
and edx, 0FFh	; 837E6
shl edx, 8	; 837EC
shr eax, 8	; 837EF
and eax, 0FFh	; 837F2
or eax, edx	; 837F7
pop edx	; 837F9
ret	; 837FA
%endif ; C
; C: src/c/front/announcer/ShutdownSpeech.c (ReadBE24)
%ifdef CBUILD
%include "c/front/announcer/ShutdownSpeech.ReadBE24.inc"
%else
ReadBE24:
push dword 20h	; 837FB
call __CHK	; 83800
push ebx	; 83805
push ecx	; 83806
push edx	; 83807
push esi	; 83808
sub esp, byte 8	; 83809
mov esi, eax	; 8380C
xor ah, ah	; 8380E
mov byte [byte esp+07h], ah	; 83810
mov ebx, esp	; 83814
push ebx	; 83816
mov edx, 1	; 83817
mov ecx, ds	; 8381C
lea ebx, [byte esp+0Ah]	; 8381E
mov eax, esi	; 83822
call _dos_read_	; 83824
mov ebx, esp	; 83829
push ebx	; 8382B
mov edx, 1	; 8382C
mov ecx, ds	; 83831
lea ebx, [byte esp+09h]	; 83833
mov eax, esi	; 83837
call _dos_read_	; 83839
mov ebx, esp	; 8383E
push ebx	; 83840
mov edx, 1	; 83841
mov ecx, ds	; 83846
lea ebx, [byte esp+08h]	; 83848
mov eax, esi	; 8384C
call _dos_read_	; 8384E
mov eax, dword [byte esp+04h]	; 83853
ReadBE24_ret:
add esp, byte 8	; 83857
pop esi	; 8385A
pop edx	; 8385B
pop ecx	; 8385C
pop ebx	; 8385D
ret	; 8385E
%endif ; C
; C: src/c/front/announcer/ReadCString.c
%ifdef CBUILD
%include "c/front/announcer/ReadCString.inc"
%else
ReadCString:
push dword 1Ch	; 8385F
call __CHK	; 83864
push ebx	; 83869
push ecx	; 8386A
push esi	; 8386B
push edi	; 8386C
sub esp, byte 4	; 8386D
mov esi, eax	; 83870
mov edi, edx	; 83872
.1:
mov eax, esp	; 83874
push eax	; 83876
mov ecx, ds	; 83877
mov edx, 1	; 83879
mov ebx, esi	; 8387E
mov eax, edi	; 83880
call _dos_read_	; 83882
mov eax, esi	; 83887
inc esi	; 83889
cmp byte [eax], 0	; 8388A
jne short ReadCString.1	; 8388D
add esp, byte 4	; 8388F
pop edi	; 83892
pop esi	; 83893
pop ecx	; 83894
pop ebx	; 83895
ret	; 83896
%endif ; C
OpenSpeechBank:
push dword 40h	; 83897
call __CHK	; 8389C
push ebx	; 838A1
push ecx	; 838A2
push esi	; 838A3
push edi	; 838A4
push ebp	; 838A5
sub esp, byte 24h	; 838A6
mov esi, eax	; 838A9
mov edi, edx	; 838AB
cmp dword [speechinit], byte 0	; 838AD
je near .10	; 838B4
mov eax, dword [speechbank]	; 838BA
cmp dword [dword eax+03B78h], byte 0	; 838BF
je short .1	; 838C6
lea edx, [dword eax+03B80h]	; 838C8
mov eax, esi	; 838CE
call StrEqNoCase	; 838D0
test eax, eax	; 838D5
jne near .10	; 838D7
mov eax, dword [speechbank]	; 838DD
mov eax, dword [dword eax+03B7Ch]	; 838E2
call _dos_close_	; 838E8
.1:
lea ebx, [byte esp+010h]	; 838ED
xor edx, edx	; 838F1
mov eax, esi	; 838F3
call _dos_open_	; 838F5
mov eax, dword [speechbank]	; 838FA
add eax, 3B80h	; 838FF
mov ebx, 0Dh	; 83904
mov edx, esi	; 83909
call strncpy_	; 8390B
mov edx, dword [speechbank]	; 83910
mov eax, dword [byte esp+010h]	; 83916
mov dword [dword edx+03B7Ch], eax	; 8391A
mov eax, dword [speechbank]	; 83920
mov dword [dword eax+03B70h], edi	; 83925
mov eax, dword [speechbank]	; 8392B
mov dword [dword eax+03B78h], 1	; 83930
mov eax, dword [speechbank]	; 8393A
mov dword [dword eax+03B6Ch], 0	; 8393F
mov eax, dword [speechbank]	; 83949
mov dword [dword eax+03B74h], 0	; 8394E
lea eax, [byte esp+08h]	; 83958
push eax	; 8395C
mov edx, 2	; 8395D
mov ecx, ds	; 83962
lea ebx, [byte esp+024h]	; 83964
mov eax, dword [byte esp+014h]	; 83968
call _dos_read_	; 8396C
mov eax, dword [byte esp+01Eh]	; 83971
sar eax, 10h	; 83975
call Swap16	; 83978
mov edx, dword [speechbank]	; 8397D
mov word [dword edx+03B8Dh], ax	; 83983
lea eax, [byte esp+08h]	; 8398A
push eax	; 8398E
mov edx, 2	; 8398F
mov ecx, ds	; 83994
lea ebx, [byte esp+018h]	; 83996
mov eax, dword [byte esp+014h]	; 8399A
call _dos_read_	; 8399E
mov eax, dword [byte esp+012h]	; 839A3
sar eax, 10h	; 839A7
call Swap16	; 839AA
mov edx, eax	; 839AF
mov eax, dword [speechbank]	; 839B1
mov word [dword eax+03B8Fh], dx	; 839B6
lea eax, [byte esp+08h]	; 839BD
push eax	; 839C1
mov edx, 2	; 839C2
mov ecx, ds	; 839C7
lea ebx, [byte esp+020h]	; 839C9
mov eax, dword [byte esp+014h]	; 839CD
call _dos_read_	; 839D1
mov eax, dword [byte esp+01Ah]	; 839D6
sar eax, 10h	; 839DA
call Swap16	; 839DD
mov edx, dword [speechbank]	; 839E2
mov word [dword edx+03B91h], ax	; 839E8
xor esi, esi	; 839EF
jmp short .3	; 839F1
.2:
mov edi, esi	; 839F3
shl edi, 2	; 839F5
add edi, esi	; 839F8
shl edi, 2	; 839FA
sub edi, esi	; 839FD
add edi, edi	; 839FF
mov dword [byte edi+eax+0Eh], 0	; 83A01
mov eax, dword [byte esp+010h]	; 83A09
call ReadBE24	; 83A0D
mov edx, eax	; 83A12
mov eax, dword [speechbank]	; 83A14
mov dword [byte edi+eax+012h], edx	; 83A19
mov eax, dword [byte esp+010h]	; 83A1D
call ReadBE24	; 83A21
mov edx, dword [speechbank]	; 83A26
mov dword [byte edx+edi+01Ah], eax	; 83A2C
mov eax, dword [speechbank]	; 83A30
add eax, edi	; 83A35
mov edx, dword [byte esp+010h]	; 83A37
call ReadCString	; 83A3B
mov eax, dword [speechbank]	; 83A40
mov dword [byte edi+eax+022h], 0	; 83A45
inc esi	; 83A4D
.3:
mov eax, dword [speechbank]	; 83A4E
mov edx, dword [dword eax+03B8Fh]	; 83A53
sar edx, 10h	; 83A59
cmp esi, edx	; 83A5C
jl short OpenSpeechBank.2	; 83A5E
xor esi, esi	; 83A60
jmp near .7	; 83A62
.4:
mov edi, esi	; 83A67
shl edi, 2	; 83A69
add edi, esi	; 83A6C
shl edi, 2	; 83A6E
sub edi, esi	; 83A71
add edi, edi	; 83A73
mov ebp, dword [byte edi+eax+012h]	; 83A75
xor ebx, ebx	; 83A79
mov edx, ebp	; 83A7B
mov eax, dword [byte esp+010h]	; 83A7D
call lseek_	; 83A81
lea eax, [byte esp+08h]	; 83A86
push eax	; 83A8A
mov edx, 2	; 83A8B
mov ecx, ds	; 83A90
lea ebx, [byte esp+01Ch]	; 83A92
mov eax, dword [byte esp+014h]	; 83A96
call _dos_read_	; 83A9A
mov eax, dword [byte esp+018h]	; 83A9F
xor ah, ah	; 83AA3
xor edx, edx	; 83AA5
mov dx, word [byte esp+018h]	; 83AA7
sar edx, 8	; 83AAC
mov dword [byte esp+018h], edx	; 83AAF
cmp ax, 47h	; 83AB3
jne short .5	; 83AB7
lea edx, [byte ebp+06h]	; 83AB9
xor ebx, ebx	; 83ABC
mov eax, dword [byte esp+010h]	; 83ABE
call lseek_	; 83AC2
lea eax, [byte esp+08h]	; 83AC7
push eax	; 83ACB
mov edx, 2	; 83ACC
mov ecx, ds	; 83AD1
lea ebx, [byte esp+010h]	; 83AD3
mov eax, dword [byte esp+014h]	; 83AD7
call _dos_read_	; 83ADB
mov eax, dword [byte esp+0Ch]	; 83AE0
call Swap16	; 83AE4
sub eax, byte 5	; 83AE9
mov dword [byte esp+0Ch], eax	; 83AEC
mov edx, dword [speechbank]	; 83AF0
mov dword [byte edx+edi+016h], eax	; 83AF6
mov dword [esp], eax	; 83AFA
xor ebp, ebp	; 83AFD
mov dword [byte esp+04h], ebp	; 83AFF
fild qword [esp]	; 83B03
fmul qword [qword_C37B0]	; 83B06
fdiv qword [qword_C37C0]	; 83B0C
call __CHP	; 83B12
fistp qword [esp]	; 83B17
mov edx, dword [speechbank]	; 83B1A
mov eax, dword [esp]	; 83B20
mov dword [byte edx+edi+01Eh], eax	; 83B23
mov eax, dword [speechbank]	; 83B27
mov byte [byte edi+eax+0Dh], 47h	; 83B2C
jmp short .6	; 83B31
.5:
mov edx, dword [speechbank]	; 83B33
mov eax, dword [byte edx+edi+01Ah]	; 83B39
mov dword [byte esp+0Ch], eax	; 83B3D
mov dword [byte edx+edi+016h], eax	; 83B41
mov dword [esp], eax	; 83B45
xor ecx, ecx	; 83B48
mov dword [byte esp+04h], ecx	; 83B4A
fild qword [esp]	; 83B4E
fmul qword [qword_C37B0]	; 83B51
fdiv qword [qword_C37B8]	; 83B57
call __CHP	; 83B5D
fistp qword [esp]	; 83B62
mov edx, dword [speechbank]	; 83B65
mov eax, dword [esp]	; 83B6B
sub eax, byte 1Ah	; 83B6E
mov dword [byte edx+edi+01Eh], eax	; 83B71
mov eax, dword [speechbank]	; 83B75
mov byte [byte edi+eax+0Dh], 0FFh	; 83B7A
.6:
inc esi	; 83B7F
.7:
mov eax, dword [speechbank]	; 83B80
mov edx, dword [dword eax+03B8Fh]	; 83B85
sar edx, 10h	; 83B8B
cmp esi, edx	; 83B8E
jl near OpenSpeechBank.4	; 83B90
mov esi, edx	; 83B96
jmp short .9	; 83B98
.8:
mov eax, esi	; 83B9A
shl eax, 2	; 83B9C
add eax, esi	; 83B9F
shl eax, 2	; 83BA1
sub eax, esi	; 83BA4
add eax, eax	; 83BA6
mov edx, dword [speechbank]	; 83BA8
add eax, edx	; 83BAE
call ClearSpeechSlot	; 83BB0
inc esi	; 83BB5
.9:
cmp esi, 190h	; 83BB6
jl short OpenSpeechBank.8	; 83BBC
.10:
add esp, byte 24h	; 83BBE
OpenSpeechBank_ret:
pop ebp	; 83BC1
pop edi	; 83BC2
pop esi	; 83BC3
pop ecx	; 83BC4
pop ebx	; 83BC5
ret	; 83BC6
; C: src/c/front/announcer/SpeechSlotSize.c
%ifdef CBUILD
%include "c/front/announcer/SpeechSlotSize.inc"
%else
SpeechSlotSize:
push dword 8	; 83BC7
call __CHK	; 83BCC
push edx	; 83BD1
cmp eax, byte 0FFFFFFFFh	; 83BD2
jne short .1	; 83BD5
xor eax, eax	; 83BD7
pop edx	; 83BD9
ret	; 83BDA
.1:
mov edx, eax	; 83BDB
shl eax, 2	; 83BDD
add eax, edx	; 83BE0
shl eax, 2	; 83BE2
sub eax, edx	; 83BE5
mov edx, dword [speechbank]	; 83BE7
mov eax, dword [byte edx+eax*2+016h]	; 83BED
pop edx	; 83BF1
ret	; 83BF2
%endif ; C
; C: src/c/front/announcer/OpenSpeechBank.c (ReadSpeechSample)
%ifdef CBUILD
%include "c/front/announcer/OpenSpeechBank.ReadSpeechSample.inc"
%else
ReadSpeechSample:
push dword 38h	; 83BF3
call __CHK	; 83BF8
push ebx	; 83BFD
push ecx	; 83BFE
push esi	; 83BFF
push edi	; 83C00
push ebp	; 83C01
sub esp, byte 14h	; 83C02
mov ecx, eax	; 83C05
mov esi, edx	; 83C07
shl eax, 2	; 83C09
add eax, ecx	; 83C0C
shl eax, 2	; 83C0E
sub eax, ecx	; 83C11
add eax, eax	; 83C13
mov edx, dword [speechbank]	; 83C15
add eax, edx	; 83C1B
mov edi, dword [byte eax+01Ah]	; 83C1D
mov edx, dword [dword edx+03B7Ch]	; 83C20
mov dword [esp], edx	; 83C26
mov edx, dword [byte eax+012h]	; 83C29
mov dword [byte esp+0Ch], edx	; 83C2C
mov eax, dword [byte eax+016h]	; 83C30
mov dword [byte esp+08h], eax	; 83C33
push esi	; 83C37
call _os_handle_3	; 83C38
mov ebp, eax	; 83C3D
add esp, byte 4	; 83C3F
mov esi, eax	; 83C42
mov eax, dword [byte esp+08h]	; 83C44
sub eax, edi	; 83C48
add eax, 1388h	; 83C4A
lea edx, [eax+ebp]	; 83C4F
mov dword [byte esp+010h], edx	; 83C52
xor ebx, ebx	; 83C56
mov edx, dword [byte esp+0Ch]	; 83C58
mov eax, dword [esp]	; 83C5C
call lseek_	; 83C5F
lea eax, [byte esp+04h]	; 83C64
push eax	; 83C68
mov ecx, ds	; 83C69
mov edx, edi	; 83C6B
mov ebx, dword [byte esp+014h]	; 83C6D
mov eax, dword [byte esp+04h]	; 83C71
call _dos_read_	; 83C75
push edi	; 83C7A
push ebp	; 83C7B
mov edx, dword [byte esp+018h]	; 83C7C
push edx	; 83C80
call sub_98028	; 83C81
add esp, byte 0Ch	; 83C86
mov ecx, eax	; 83C89
xor bl, bl	; 83C8B
xor edx, edx	; 83C8D
jmp short .2	; 83C8F
.1:
mov bh, byte [byte edx+esi+05h]	; 83C91
add bh, bl	; 83C95
mov byte [edx+esi], bh	; 83C97
add bl, byte [byte edx+esi+05h]	; 83C9A
inc edx	; 83C9E
.2:
lea eax, [byte ecx-05h]	; 83C9F
cmp edx, eax	; 83CA2
jl short ReadSpeechSample.1	; 83CA4
add esp, byte 14h	; 83CA6
jmp near OpenSpeechBank_ret	; 83CA9
%endif ; C
; C: src/c/front/announcer/ShutdownSpeech.c (LoadSpeechSlot)
%ifdef CBUILD
%include "c/front/announcer/ShutdownSpeech.LoadSpeechSlot.inc"
%else
LoadSpeechSlot:
push dword 1Ch	; 83CAE
call __CHK	; 83CB3
push ebx	; 83CB8
push ecx	; 83CB9
push edx	; 83CBA
push esi	; 83CBB
sub esp, byte 8	; 83CBC
mov ebx, eax	; 83CBF
test eax, eax	; 83CC1
jne short .1	; 83CC3
mov edx, dword [speechbank]	; 83CC5
mov edx, dword [dword edx+03B64h]	; 83CCB
jmp short .2	; 83CD1
.1:
lea edx, [byte eax-01h]	; 83CD3
mov eax, edx	; 83CD6
shl eax, 2	; 83CD8
add eax, edx	; 83CDB
shl eax, 2	; 83CDD
sub eax, edx	; 83CE0
add eax, eax	; 83CE2
mov edx, dword [speechbank]	; 83CE4
add eax, edx	; 83CEA
mov edx, dword [byte eax+0Eh]	; 83CEC
add edx, dword [byte eax+016h]	; 83CEF
.2:
mov eax, ebx	; 83CF2
shl eax, 2	; 83CF4
add eax, ebx	; 83CF7
shl eax, 2	; 83CF9
sub eax, ebx	; 83CFC
lea ecx, [eax+eax]	; 83CFE
mov eax, dword [speechbank]	; 83D01
mov dword [byte ecx+eax+0Eh], edx	; 83D06
mov eax, ebx	; 83D0A
call ReadSpeechSample	; 83D0C
mov edx, eax	; 83D11
mov eax, dword [speechbank]	; 83D13
mov dword [byte ecx+eax+016h], edx	; 83D18
mov eax, dword [speechbank]	; 83D1C
mov ebx, dword [dword eax+03B70h]	; 83D21
mov dword [esp], edx	; 83D27
xor esi, esi	; 83D2A
mov dword [byte esp+04h], esi	; 83D2C
fild qword [esp]	; 83D30
fmul qword [qword_C37C8]	; 83D33
fdiv qword [qword_C37D0]	; 83D39
call __CHP	; 83D3F
fistp qword [esp]	; 83D44
mov esi, dword [esp]	; 83D47
sub esi, ebx	; 83D4A
mov dword [byte ecx+eax+01Eh], esi	; 83D4C
mov eax, dword [speechbank]	; 83D50
mov dword [byte ecx+eax+022h], 1	; 83D55
mov eax, dword [speechbank]	; 83D5D
add dword [dword eax+03B6Ch], edx	; 83D62
mov eax, dword [speechbank]	; 83D68
inc dword [dword eax+03B74h]	; 83D6D
jmp near ReadBE24_ret	; 83D73
%endif ; C
; C: src/c/front/announcer/ShutdownSpeech.c (PlaceSpeechSlot)
%ifdef CBUILD
%include "c/front/announcer/ShutdownSpeech.PlaceSpeechSlot.inc"
%else
PlaceSpeechSlot:
push dword 28h	; 83D78
call __CHK	; 83D7D
push ebx	; 83D82
push ecx	; 83D83
push edx	; 83D84
push esi	; 83D85
push edi	; 83D86
push ebp	; 83D87
sub esp, byte 8	; 83D88
mov edx, eax	; 83D8B
test eax, eax	; 83D8D
jne short .1	; 83D8F
mov ebp, dword [speechbank]	; 83D91
mov ebp, dword [dword ebp+03B64h]	; 83D97
jmp short .2	; 83D9D
.1:
lea esi, [byte eax-01h]	; 83D9F
mov eax, esi	; 83DA2
shl eax, 2	; 83DA4
add eax, esi	; 83DA7
shl eax, 2	; 83DA9
sub eax, esi	; 83DAC
mov esi, dword [speechbank]	; 83DAE
mov ebp, dword [byte esi+eax*2+0Eh]	; 83DB4
add ebp, dword [byte esi+eax*2+016h]	; 83DB8
.2:
mov esi, edx	; 83DBC
shl esi, 2	; 83DBE
add esi, edx	; 83DC1
shl esi, 2	; 83DC3
sub esi, edx	; 83DC6
mov eax, dword [speechbank]	; 83DC8
mov dword [byte eax+esi*2+0Eh], ebp	; 83DCD
mov eax, dword [speechbank]	; 83DD1
mov edi, dword [dword eax+03B7Ch]	; 83DD6
mov edx, dword [byte eax+esi*2+01Ah]	; 83DDC
mov dword [byte esp+04h], edx	; 83DE0
mov edx, dword [byte eax+esi*2+012h]	; 83DE4
xor ebx, ebx	; 83DE8
mov eax, edi	; 83DEA
call lseek_	; 83DEC
mov eax, esp	; 83DF1
push eax	; 83DF3
mov ecx, ds	; 83DF4
mov edx, dword [byte esp+08h]	; 83DF6
mov ebx, ebp	; 83DFA
mov eax, edi	; 83DFC
call _dos_read_	; 83DFE
mov eax, dword [speechbank]	; 83E03
mov dword [byte eax+esi*2+022h], 1	; 83E08
mov edx, dword [speechbank]	; 83E10
mov eax, dword [esp]	; 83E16
add dword [dword edx+03B6Ch], eax	; 83E19
mov eax, dword [speechbank]	; 83E1F
inc dword [dword eax+03B74h]	; 83E24
add esp, byte 8	; 83E2A
jmp near ShutdownSpeech_ret6	; 83E2D
%endif ; C
; C: src/c/front/announcer/StrEqNoCase.c
%ifdef CBUILD
%include "c/front/announcer/StrEqNoCase.inc"
%else
StrEqNoCase:
push dword 0Ch	; 83E32
call __CHK	; 83E37
push ebx	; 83E3C
push ecx	; 83E3D
.1:
cmp byte [eax], 0	; 83E3E
jne short .2	; 83E41
cmp byte [edx], 0	; 83E43
je short .3	; 83E46
.2:
movsx ebx, byte [eax]	; 83E48
and ebx, 0DFh	; 83E4B
movsx ecx, byte [edx]	; 83E51
and ecx, 0DFh	; 83E54
inc eax	; 83E5A
inc edx	; 83E5B
cmp ebx, ecx	; 83E5C
je short StrEqNoCase.1	; 83E5E
xor eax, eax	; 83E60
pop ecx	; 83E62
pop ebx	; 83E63
ret	; 83E64
.3:
mov eax, 1	; 83E65
pop ecx	; 83E6A
pop ebx	; 83E6B
ret	; 83E6C
%endif ; C
; C: src/c/front/announcer/FindFreeSpeechSlot.c
%ifdef CBUILD
%include "c/front/announcer/FindFreeSpeechSlot.inc"
%else
FindFreeSpeechSlot:
push dword 0Ch	; 83E6D
call __CHK	; 83E72
push ebx	; 83E77
push edx	; 83E78
mov edx, eax	; 83E79
mov ebx, dword [speechbank]	; 83E7B
jmp short .3	; 83E81
.1:
mov eax, edx	; 83E83
shl eax, 2	; 83E85
add eax, edx	; 83E88
shl eax, 2	; 83E8A
sub eax, edx	; 83E8D
cmp dword [byte ebx+eax*2+022h], byte 0	; 83E8F
jne short .2	; 83E94
mov eax, edx	; 83E96
pop edx	; 83E98
pop ebx	; 83E99
ret	; 83E9A
.2:
inc edx	; 83E9B
.3:
cmp edx, 190h	; 83E9C
jl short FindFreeSpeechSlot.1	; 83EA2
mov eax, 0FFFFFFFFh	; 83EA4
pop edx	; 83EA9
pop ebx	; 83EAA
ret	; 83EAB
%endif ; C
; C: src/c/front/announcer/FindLoadedSpeechSlot.c
%ifdef CBUILD
%include "c/front/announcer/FindLoadedSpeechSlot.inc"
%else
FindLoadedSpeechSlot:
push dword 0Ch	; 83EAC
call __CHK	; 83EB1
push ebx	; 83EB6
push edx	; 83EB7
mov edx, eax	; 83EB8
mov ebx, dword [speechbank]	; 83EBA
jmp short .3	; 83EC0
.1:
mov eax, edx	; 83EC2
shl eax, 2	; 83EC4
add eax, edx	; 83EC7
shl eax, 2	; 83EC9
sub eax, edx	; 83ECC
cmp dword [byte ebx+eax*2+022h], byte 1	; 83ECE
jne short .2	; 83ED3
mov eax, edx	; 83ED5
pop edx	; 83ED7
pop ebx	; 83ED8
ret	; 83ED9
.2:
inc edx	; 83EDA
.3:
cmp edx, 190h	; 83EDB
jl short FindLoadedSpeechSlot.1	; 83EE1
mov eax, 0FFFFFFFFh	; 83EE3
pop edx	; 83EE8
pop ebx	; 83EE9
ret	; 83EEA
%endif ; C
; C: src/c/front/announcer/FindSpeechSlot.c
%ifdef CBUILD
%include "c/front/announcer/FindSpeechSlot.inc"
%else
FindSpeechSlot:
push dword 10h	; 83EEB
call __CHK	; 83EF0
push ebx	; 83EF5
push ecx	; 83EF6
push edx	; 83EF7
mov ecx, eax	; 83EF8
xor ebx, ebx	; 83EFA
.1:
mov eax, ebx	; 83EFC
shl eax, 2	; 83EFE
add eax, ebx	; 83F01
shl eax, 2	; 83F03
sub eax, ebx	; 83F06
add eax, eax	; 83F08
mov edx, dword [speechbank]	; 83F0A
add edx, eax	; 83F10
mov eax, ecx	; 83F12
call StrEqNoCase	; 83F14
test eax, eax	; 83F19
je short .2	; 83F1B
mov eax, ebx	; 83F1D
pop edx	; 83F1F
pop ecx	; 83F20
pop ebx	; 83F21
ret	; 83F22
.2:
inc ebx	; 83F23
cmp ebx, 190h	; 83F24
jl short FindSpeechSlot.1	; 83F2A
mov eax, 0FFFFFFFFh	; 83F2C
pop edx	; 83F31
pop ecx	; 83F32
pop ebx	; 83F33
ret	; 83F34
%endif ; C
; C: src/c/front/announcer/SpeechSlotLoaded.c
%ifdef CBUILD
%include "c/front/announcer/SpeechSlotLoaded.inc"
%else
SpeechSlotLoaded:
push dword 8	; 83F35
call __CHK	; 83F3A
push edx	; 83F3F
mov edx, eax	; 83F40
shl eax, 2	; 83F42
add eax, edx	; 83F45
shl eax, 2	; 83F47
sub eax, edx	; 83F4A
mov edx, dword [speechbank]	; 83F4C
cmp dword [byte edx+eax*2+022h], byte 1	; 83F52
sete al	; 83F57
and eax, 0FFh	; 83F5A
pop edx	; 83F5F
ret	; 83F60
%endif ; C
; C: src/c/front/announcer/IsSampleRequested.c
%ifdef CBUILD
%include "c/front/announcer/IsSampleRequested.inc"
%else
IsSampleRequested:
push dword 14h	; 83F61
call __CHK	; 83F66
push ebx	; 83F6B
push ecx	; 83F6C
push edx	; 83F6D
push esi	; 83F6E
mov esi, eax	; 83F6F
xor ebx, ebx	; 83F71
jmp short .3	; 83F73
.1:
mov eax, ebx	; 83F75
shl eax, 2	; 83F77
sub eax, ebx	; 83F7A
shl eax, 2	; 83F7C
add eax, ebx	; 83F7F
lea edx, [ecx+eax]	; 83F81
mov eax, esi	; 83F84
call StrEqNoCase	; 83F86
test eax, eax	; 83F8B
je short .2	; 83F8D
mov eax, 1	; 83F8F
pop esi	; 83F94
pop edx	; 83F95
pop ecx	; 83F96
pop ebx	; 83F97
ret	; 83F98
.2:
inc ebx	; 83F99
.3:
mov ecx, dword [samplereq]	; 83F9A
cmp ebx, dword [dword ecx+0108h]	; 83FA0
jl short IsSampleRequested.1	; 83FA6
xor eax, eax	; 83FA8
pop esi	; 83FAA
pop edx	; 83FAB
pop ecx	; 83FAC
pop ebx	; 83FAD
ret	; 83FAE
%endif ; C
; C: src/c/front/announcer/RequestSample.c
%ifdef CBUILD
%include "c/front/announcer/RequestSample.inc"
%else
RequestSample:
push dword 14h	; 83FAF
call __CHK	; 83FB4
push ebx	; 83FB9
push ecx	; 83FBA
push edx	; 83FBB
push esi	; 83FBC
mov ecx, eax	; 83FBD
call IsSampleRequested	; 83FBF
cmp eax, byte 1	; 83FC4
je short .x	; 83FC7
mov edx, dword [samplereq]	; 83FC9
mov esi, dword [dword edx+0108h]	; 83FCF
mov eax, esi	; 83FD5
shl eax, 2	; 83FD7
sub eax, esi	; 83FDA
shl eax, 2	; 83FDC
add eax, esi	; 83FDF
inc esi	; 83FE1
mov dword [dword edx+0108h], esi	; 83FE2
mov edx, dword [samplereq]	; 83FE8
add eax, edx	; 83FEE
mov ebx, 0Dh	; 83FF0
mov edx, ecx	; 83FF5
call strncpy_	; 83FF7
mov eax, ecx	; 83FFC
call FindSpeechSlot	; 83FFE
mov ecx, eax	; 84003
cmp eax, byte 0FFFFFFFFh	; 84005
je short .1	; 84008
call SpeechSlotLoaded	; 8400A
test eax, eax	; 8400F
jne short .1	; 84011
mov edx, dword [samplereq]	; 84013
mov eax, ecx	; 84019
call SpeechSlotSize	; 8401B
add dword [dword edx+0104h], eax	; 84020
.1:
mov eax, dword [samplereq]	; 84026
inc dword [dword eax+010Ch]	; 8402B
.x:
pop esi	; 84031
pop edx	; 84032
pop ecx	; 84033
pop ebx	; 84034
ret	; 84035
%endif ; C
; C: src/c/front/announcer/FreeUnrequestedSamples.c
%ifdef CBUILD
%include "c/front/announcer/FreeUnrequestedSamples.inc"
%else
FreeUnrequestedSamples:
push dword 10h	; 84036
call __CHK	; 8403B
push ebx	; 84040
push ecx	; 84041
push edx	; 84042
mov edx, 18Fh	; 84043
jmp short .3	; 84048
.1:
mov eax, edx	; 8404A
shl eax, 2	; 8404C
add eax, edx	; 8404F
shl eax, 2	; 84051
sub eax, edx	; 84054
lea ebx, [eax+eax]	; 84056
mov eax, dword [speechbank]	; 84059
add eax, ebx	; 8405E
mov ecx, dword [byte eax+022h]	; 84060
cmp ecx, byte 1	; 84063
jne short .2	; 84066
call IsSampleRequested	; 84068
test eax, eax	; 8406D
jne short .2	; 8406F
mov eax, dword [speechbank]	; 84071
mov dword [byte ebx+eax+022h], 0	; 84076
mov eax, dword [speechbank]	; 8407E
mov edx, dword [byte ebx+eax+016h]	; 84083
sub dword [dword eax+03B6Ch], edx	; 84087
mov eax, dword [speechbank]	; 8408D
mov ebx, ecx	; 84092
sub dword [dword eax+03B74h], ecx	; 84094
jmp short .4	; 8409A
.2:
dec edx	; 8409C
.3:
test edx, edx	; 8409D
jge short FreeUnrequestedSamples.1	; 8409F
xor ebx, ebx	; 840A1
.4:
mov eax, ebx	; 840A3
pop edx	; 840A5
pop ecx	; 840A6
pop ebx	; 840A7
ret	; 840A8
%endif ; C
; C: src/c/front/announcer/OpenSpeechBank.c (MoveSampleMem)
%ifdef CBUILD
%include "c/front/announcer/OpenSpeechBank.MoveSampleMem.inc"
%else
MoveSampleMem:
push dword 20h	; 840A9
call __CHK	; 840AE
push ecx	; 840B3
push esi	; 840B4
push edi	; 840B5
push ebp	; 840B6
sub esp, byte 8	; 840B7
mov ebp, eax	; 840BA
mov dword [esp], edx	; 840BC
mov edi, ebx	; 840BF
.1:
test edi, edi	; 840C1
je short .x	; 840C3
mov edx, dword [speechcopylen]	; 840C5
cmp edi, edx	; 840CB
jbe short .2	; 840CD
mov esi, edx	; 840CF
jmp short .3	; 840D1
.2:
mov esi, edi	; 840D3
.3:
mov ebx, dword [esp]	; 840D5
push ebx	; 840D8
call _os_handle_3	; 840D9
add esp, byte 4	; 840DE
push esi	; 840E1
mov ecx, ds	; 840E2
mov edx, ds	; 840E4
mov ebx, dword [speechcopybuf]	; 840E6
mov dword [byte esp+08h], ebx	; 840EC
mov ebx, eax	; 840F0
mov eax, dword [byte esp+08h]	; 840F2
call _fmemmove_	; 840F6
push ebp	; 840FB
call _os_handle_3	; 840FC
add esp, byte 4	; 84101
push esi	; 84104
mov ecx, ds	; 84105
mov ebx, dword [speechcopybuf]	; 84107
mov edx, ds	; 8410D
call _fmemmove_	; 8410F
add dword [esp], esi	; 84114
add ebp, esi	; 84117
sub edi, esi	; 84119
jmp short MoveSampleMem.1	; 8411B
.x:
add esp, byte 8	; 8411D
pop ebp	; 84120
pop edi	; 84121
pop esi	; 84122
pop ecx	; 84123
ret	; 84124
%endif ; C
; C: src/c/front/announcer/OpenSpeechBank.c (CompactSpeechSlot)
%ifdef CBUILD
%include "c/front/announcer/OpenSpeechBank.CompactSpeechSlot.inc"
%else
CompactSpeechSlot:
push dword 44h	; 84125
call __CHK	; 8412A
push ebx	; 8412F
push ecx	; 84130
push esi	; 84131
push edi	; 84132
push ebp	; 84133
sub esp, byte 2Ch	; 84134
mov ecx, eax	; 84137
mov ebx, edx	; 84139
mov eax, edx	; 8413B
shl eax, 2	; 8413D
add eax, edx	; 84140
shl eax, 2	; 84142
sub eax, edx	; 84145
mov edx, dword [speechbank]	; 84147
mov esi, dword [byte edx+eax*2+0Eh]	; 8414D
test ecx, ecx	; 84151
jne short .1	; 84153
mov ebp, dword [dword edx+03B64h]	; 84155
jmp short .2	; 8415B
.1:
lea ebp, [byte ecx-01h]	; 8415D
mov eax, ebp	; 84160
shl eax, 2	; 84162
add eax, ebp	; 84165
shl eax, 2	; 84167
sub eax, ebp	; 8416A
mov ebp, dword [byte edx+eax*2+0Eh]	; 8416C
add ebp, dword [byte edx+eax*2+016h]	; 84170
.2:
mov eax, ebx	; 84174
shl eax, 2	; 84176
add eax, ebx	; 84179
shl eax, 2	; 8417B
sub eax, ebx	; 8417E
add eax, eax	; 84180
mov dword [byte esp+028h], eax	; 84182
mov ebx, dword [speechbank]	; 84186
add ebx, eax	; 8418C
mov ebx, dword [byte ebx+016h]	; 8418E
mov edx, esi	; 84191
mov eax, ebp	; 84193
call MoveSampleMem	; 84195
mov edx, ecx	; 8419A
shl edx, 2	; 8419C
add edx, ecx	; 8419F
shl edx, 2	; 841A1
sub edx, ecx	; 841A4
add edx, edx	; 841A6
mov ebx, dword [speechbank]	; 841A8
lea eax, [ebx+edx]	; 841AE
mov ecx, 9	; 841B1
mov edi, esp	; 841B6
mov esi, eax	; 841B8
rep movsd	; 841BA
movsw	; 841BC
mov esi, dword [byte esp+028h]	; 841BE
add esi, ebx	; 841C2
mov ecx, 9	; 841C4
mov edi, eax	; 841C9
rep movsd	; 841CB
movsw	; 841CD
mov edi, dword [speechbank]	; 841CF
mov ebx, dword [byte esp+028h]	; 841D5
add edi, ebx	; 841D9
mov ecx, 9	; 841DB
mov esi, esp	; 841E0
rep movsd	; 841E2
movsw	; 841E4
mov eax, dword [speechbank]	; 841E6
mov dword [byte edx+eax+0Eh], ebp	; 841EB
mov eax, dword [speechbank]	; 841EF
add eax, ebx	; 841F4
mov dword [byte eax+022h], 0	; 841F6
add esp, byte 2Ch	; 841FD
jmp near OpenSpeechBank_ret	; 84200
%endif ; C
; C: src/c/front/announcer/MakeSampleRoom.c
%ifdef CBUILD
%include "c/front/announcer/MakeSampleRoom.inc"
%else
MakeSampleRoom:
push dword 14h	; 84205
call __CHK	; 8420A
push ebx	; 8420F
push ecx	; 84210
push edx	; 84211
push esi	; 84212
xor edx, edx	; 84213
xor ecx, ecx	; 84215
mov eax, dword [speechbank]	; 84217
mov esi, dword [dword eax+03B68h]	; 8421C
mov ebx, dword [samplereq]	; 84222
mov eax, dword [dword eax+03B6Ch]	; 84228
add eax, dword [dword ebx+0104h]	; 8422E
cmp eax, esi	; 84234
jbe short .x	; 84236
.1:
call FreeUnrequestedSamples	; 84238
mov eax, dword [speechbank]	; 8423D
mov ebx, dword [samplereq]	; 84242
mov eax, dword [dword eax+03B6Ch]	; 84248
add eax, dword [dword ebx+0104h]	; 8424E
cmp eax, esi	; 84254
jae short .2	; 84256
mov ecx, 1	; 84258
.2:
test ecx, ecx	; 8425D
jne short .x	; 8425F
inc edx	; 84261
cmp edx, 190h	; 84262
jl short MakeSampleRoom.1	; 84268
.x:
pop esi	; 8426A
pop edx	; 8426B
pop ecx	; 8426C
pop ebx	; 8426D
ret	; 8426E
%endif ; C
; C: src/c/front/announcer/ShutdownSpeech.c (EnsureSampleRoom)
%ifdef CBUILD
%include "c/front/announcer/ShutdownSpeech.EnsureSampleRoom.inc"
%else
EnsureSampleRoom:
push dword 4	; 8426F
call __CHK	; 84274
call MakeSampleRoom	; 84279
%endif ; C
; C: src/c/front/announcer/ShutdownSpeech.c (CompactSpeechMem)
%ifdef CBUILD
%include "c/front/announcer/ShutdownSpeech.CompactSpeechMem.inc"
%else
CompactSpeechMem:
push dword 0Ch	; 8427E
call __CHK	; 84283
push ebx	; 84288
push edx	; 84289
xor eax, eax	; 8428A
call FindFreeSpeechSlot	; 8428C
mov ebx, eax	; 84291
cmp eax, byte 0FFFFFFFFh	; 84293
je short .2	; 84296
.1:
call FindLoadedSpeechSlot	; 84298
mov edx, eax	; 8429D
.2:
cmp edx, byte 0FFFFFFFFh	; 8429F
je near FreeClip_ret	; 842A2
mov eax, ebx	; 842A8
call CompactSpeechSlot	; 842AA
mov eax, ebx	; 842AF
call FindFreeSpeechSlot	; 842B1
mov ebx, eax	; 842B6
jmp short CompactSpeechMem.1	; 842B8
%endif ; C
; C: src/c/front/announcer/PenaltyLenClip.c
%ifdef CBUILD
%include "c/front/announcer/PenaltyLenClip.inc"
%else
PenaltyLenClip:
push dword 14h	; 842BA
call __CHK	; 842BF
push ebx	; 842C4
mov ebx, eax	; 842C5
mov eax, edx	; 842C7
cmp ebx, byte 2	; 842C9
jl short .1	; 842CC
jle short .4	; 842CE
cmp ebx, byte 5	; 842D0
je short .2	; 842D3
jmp short .4	; 842D5
.1:
cmp ebx, byte 0FFFFFFFFh	; 842D7
je short .3	; 842DA
jmp short .4	; 842DC
.2:
mov edx, str_5minCor	; 842DE
jmp short .5	; 842E3
.3:
push str_Cor	; 842E5
push str_GamemiscS	; 842EA
push edx	; 842EF
call sprintf_	; 842F0
add esp, byte 0Ch	; 842F5
pop ebx	; 842F8
ret	; 842F9
.4:
mov edx, str_2minCor	; 842FA
.5:
call strcpy_	; 842FF
pop ebx	; 84304
ret	; 84305
%endif ; C
; C: src/c/front/announcer/PlayoffRoundClipD.c
%ifdef CBUILD
%include "c/front/announcer/PlayoffRoundClipD.inc"
%else
PlayoffRoundClipD:
push dword 10h	; 84306
call __CHK	; 8430B
push ecx	; 84310
mov ecx, eax	; 84311
mov eax, ebx	; 84313
cmp edx, byte 2	; 84315
jb short .1	; 84318
jbe short .5	; 8431A
cmp edx, byte 3	; 8431C
je near .9	; 8431F
pop ecx	; 84325
ret	; 84326
.1:
cmp edx, byte 1	; 84327
jne near .x	; 8432A
cmp ebx, byte 2	; 84330
jb short .2	; 84333
jbe short .3	; 84335
cmp ebx, byte 3	; 84337
je short .4	; 8433A
pop ecx	; 8433C
ret	; 8433D
.2:
cmp ebx, edx	; 8433E
jne short .x	; 84340
push str_EastquadBar	; 84342
jmp short .10	; 84347
.3:
push str_EastsemdBar	; 84349
jmp short .10	; 8434E
.4:
push str_EastfindBar	; 84350
jmp short .10	; 84355
.5:
cmp ebx, byte 2	; 84357
jb short .6	; 8435A
jbe short .7	; 8435C
cmp ebx, byte 3	; 8435E
je short .8	; 84361
pop ecx	; 84363
ret	; 84364
.6:
cmp ebx, byte 1	; 84365
jne short .x	; 84368
push str_WestquadBar	; 8436A
jmp short .10	; 8436F
.7:
push str_WestsemdBar	; 84371
jmp short .10	; 84376
.8:
push str_WestfindBar	; 84378
jmp short .10	; 8437D
.9:
push str_StanleydBar	; 8437F
.10:
push ecx	; 84384
call sprintf_	; 84385
add esp, byte 8	; 8438A
.x:
pop ecx	; 8438D
ret	; 8438E
%endif ; C
; C: src/c/front/announcer/PlayoffRoundClipU.c
%ifdef CBUILD
%include "c/front/announcer/PlayoffRoundClipU.inc"
%else
PlayoffRoundClipU:
push dword 10h	; 8438F
call __CHK	; 84394
push ecx	; 84399
mov ecx, eax	; 8439A
mov eax, ebx	; 8439C
cmp edx, byte 2	; 8439E
jb short .1	; 843A1
jbe short .5	; 843A3
cmp edx, byte 3	; 843A5
je near .9	; 843A8
pop ecx	; 843AE
ret	; 843AF
.1:
cmp edx, byte 1	; 843B0
jne near .x	; 843B3
cmp ebx, byte 2	; 843B9
jb short .2	; 843BC
jbe short .3	; 843BE
cmp ebx, byte 3	; 843C0
je short .4	; 843C3
pop ecx	; 843C5
ret	; 843C6
.2:
cmp ebx, edx	; 843C7
jne short .x	; 843C9
push str_EastquauBar	; 843CB
jmp short .10	; 843D0
.3:
push str_EastsemuBar	; 843D2
jmp short .10	; 843D7
.4:
push str_EastfinuBar	; 843D9
jmp short .10	; 843DE
.5:
cmp ebx, byte 2	; 843E0
jb short .6	; 843E3
jbe short .7	; 843E5
cmp ebx, byte 3	; 843E7
je short .8	; 843EA
pop ecx	; 843EC
ret	; 843ED
.6:
cmp ebx, byte 1	; 843EE
jne short .x	; 843F1
push str_WestquauBar	; 843F3
jmp short .10	; 843F8
.7:
push str_WestsemuBar	; 843FA
jmp short .10	; 843FF
.8:
push str_WestfinuBar	; 84401
jmp short .10	; 84406
.9:
push str_StanleyuBar	; 84408
.10:
push ecx	; 8440D
call sprintf_	; 8440E
add esp, byte 8	; 84413
.x:
pop ecx	; 84416
ret	; 84417
%endif ; C
; C: src/c/front/announcer/ShutdownSpeech.c (QueueSpeechClip)
%ifdef CBUILD
%include "c/front/announcer/ShutdownSpeech.QueueSpeechClip.inc"
%else
QueueSpeechClip:
push dword 54h	; 84418
call __CHK	; 8441D
push ebx	; 84422
push ecx	; 84423
push edx	; 84424
push esi	; 84425
push edi	; 84426
push ebp	; 84427
sub esp, byte 38h	; 84428
mov edx, eax	; 8442B
mov eax, dword [speechq]	; 8442D
mov ecx, dword [byte eax+054h]	; 84432
mov dword [byte esp+030h], ecx	; 84435
lea ebx, [byte ecx+01h]	; 84439
mov dword [byte eax+054h], ebx	; 8443C
mov eax, edx	; 8443F
call FindSpeechSlot	; 84441
mov ebx, eax	; 84446
cmp eax, byte 0FFFFFFFFh	; 84448
jne short .2	; 8444B
.1:
mov edx, dword [speechq]	; 8444D
xor eax, eax	; 84453
dec dword [byte edx+054h]	; 84455
jmp near .7	; 84458
.2:
call SpeechSlotLoaded	; 8445D
test eax, eax	; 84462
je short .3	; 84464
mov eax, dword [speechq]	; 84466
mov dword [eax+ecx*4], ebx	; 8446B
jmp near .6	; 8446E
.3:
call FindFreeSpeechSlot	; 84473
mov edx, eax	; 84478
mov dword [byte esp+034h], eax	; 8447A
cmp eax, byte 0FFFFFFFFh	; 8447E
je short QueueSpeechClip.1	; 84481
shl eax, 2	; 84483
add eax, edx	; 84486
shl eax, 2	; 84488
sub eax, edx	; 8448B
add eax, eax	; 8448D
mov dword [byte esp+028h], eax	; 8448F
mov eax, dword [speechbank]	; 84493
mov dword [byte esp+02Ch], eax	; 84498
mov ecx, dword [byte esp+028h]	; 8449C
lea ebp, [eax+ecx]	; 844A0
mov ecx, 9	; 844A3
mov edi, esp	; 844A8
mov esi, ebp	; 844AA
rep movsd	; 844AC
movsw	; 844AE
mov eax, ebx	; 844B0
shl eax, 2	; 844B2
add eax, ebx	; 844B5
shl eax, 2	; 844B7
sub eax, ebx	; 844BA
add eax, eax	; 844BC
mov esi, dword [byte esp+02Ch]	; 844BE
add esi, eax	; 844C2
mov ecx, 9	; 844C4
mov edi, ebp	; 844C9
rep movsd	; 844CB
movsw	; 844CD
mov edi, dword [speechbank]	; 844CF
add edi, eax	; 844D5
mov ecx, 9	; 844D7
mov esi, esp	; 844DC
rep movsd	; 844DE
movsw	; 844E0
mov eax, dword [speechbank]	; 844E2
mov ebx, dword [byte esp+028h]	; 844E7
add ebx, eax	; 844EB
mov ecx, dword [dword eax+03B6Ch]	; 844ED
add ecx, dword [byte ebx+016h]	; 844F3
cmp ecx, dword [dword eax+03B68h]	; 844F6
ja near QueueSpeechClip.1	; 844FC
cmp byte [byte ebx+0Dh], 47h	; 84502
jne short .4	; 84506
mov eax, edx	; 84508
call LoadSpeechSlot	; 8450A
jmp short .5	; 8450F
.4:
mov eax, edx	; 84511
call PlaceSpeechSlot	; 84513
.5:
mov edx, dword [byte esp+030h]	; 84518
shl edx, 2	; 8451C
mov eax, dword [speechq]	; 8451F
add eax, edx	; 84524
mov edx, dword [byte esp+034h]	; 84526
mov dword [eax], edx	; 8452A
.6:
mov eax, 1	; 8452C
.7:
add esp, byte 38h	; 84531
jmp near ShutdownSpeech_ret6	; 84534
%endif ; C
; C: src/c/front/announcer/ShutdownSpeech.c (LoadClipSlot)
%ifdef CBUILD
%include "c/front/announcer/ShutdownSpeech.LoadClipSlot.inc"
%else
LoadClipSlot:
push dword 48h	; 84539
call __CHK	; 8453E
push ebx	; 84543
push ecx	; 84544
push edx	; 84545
push esi	; 84546
push edi	; 84547
push ebp	; 84548
sub esp, byte 2Ch	; 84549
call FindSpeechSlot	; 8454C
mov ebx, eax	; 84551
cmp eax, byte 0FFFFFFFFh	; 84553
jne short .2	; 84556
.1:
xor eax, eax	; 84558
jmp near .5	; 8455A
.2:
call SpeechSlotLoaded	; 8455F
test eax, eax	; 84564
jne near .4	; 84566
call FindFreeSpeechSlot	; 8456C
mov edx, eax	; 84571
cmp eax, byte 0FFFFFFFFh	; 84573
je short LoadClipSlot.1	; 84576
mov eax, ebx	; 84578
shl eax, 2	; 8457A
add eax, ebx	; 8457D
shl eax, 2	; 8457F
sub eax, ebx	; 84582
add eax, eax	; 84584
mov dword [byte esp+028h], eax	; 84586
mov ebx, dword [speechbank]	; 8458A
lea ebp, [eax+ebx]	; 84590
mov eax, dword [dword ebx+03B6Ch]	; 84593
add eax, dword [byte ebp+016h]	; 84599
cmp eax, dword [dword ebx+03B68h]	; 8459C
ja short LoadClipSlot.1	; 845A2
mov ecx, edx	; 845A4
mov eax, ecx	; 845A6
shl eax, 2	; 845A8
add eax, ecx	; 845AB
shl eax, 2	; 845AD
sub eax, ecx	; 845B0
add eax, eax	; 845B2
add ebx, eax	; 845B4
mov ecx, 9	; 845B6
mov edi, esp	; 845BB
mov esi, ebx	; 845BD
rep movsd	; 845BF
movsw	; 845C1
mov ecx, 9	; 845C3
mov edi, ebx	; 845C8
mov esi, ebp	; 845CA
rep movsd	; 845CC
movsw	; 845CE
mov edi, dword [speechbank]	; 845D0
add edi, dword [byte esp+028h]	; 845D6
mov ecx, 9	; 845DA
mov esi, esp	; 845DF
rep movsd	; 845E1
movsw	; 845E3
mov ebx, dword [speechbank]	; 845E5
cmp byte [byte ebx+eax+0Dh], 47h	; 845EB
jne short .3	; 845F0
mov eax, edx	; 845F2
call LoadSpeechSlot	; 845F4
jmp short .4	; 845F9
.3:
mov eax, edx	; 845FB
call PlaceSpeechSlot	; 845FD
.4:
mov eax, 1	; 84602
.5:
add esp, byte 2Ch	; 84607
jmp near ShutdownSpeech_ret6	; 8460A
%endif ; C
; C: src/c/front/announcer/ShutdownSpeech.c (SayClip_body)
%ifdef CBUILD
%include "c/front/announcer/ShutdownSpeech.SayClip_body.inc"
%else
SayClip_body:
call SpeechIdle	; 8460F
test eax, eax	; 84614
je short .x	; 84616
call ResetSpeechQueue	; 84618
call ResetSampleReq	; 8461D
mov eax, dword [speechbank]	; 84622
mov dword [dword eax+03B70h], 0	; 84627
mov eax, edx	; 84631
call RequestSample	; 84633
call EnsureSampleRoom	; 84638
mov eax, edx	; 8463D
call QueueSpeechClip	; 8463F
mov eax, dword [speechq]	; 84644
mov dword [byte eax+060h], 1	; 84649
mov eax, 1	; 84650
.x:
pop edx	; 84655
ret	; 84656
%endif ; C
; C: src/c/front/announcer/ShutdownSpeech.c (SayScorePeriod)
%ifdef CBUILD
%include "c/front/announcer/ShutdownSpeech.SayScorePeriod.inc"
%else
SayScorePeriod:
push dword 8	; 84657
call __CHK	; 8465C
push edx	; 84661
mov edx, eax	; 84662
cmp dword [speechinit], byte 0	; 84664
jne short .1	; 8466B
xor eax, eax	; 8466D
pop edx	; 8466F
ret	; 84670
.1:
call SpeechIdle	; 84671
test eax, eax	; 84676
je short .x	; 84678
call ResetSpeechQueue	; 8467A
call ResetSampleReq	; 8467F
mov eax, dword [nosplit edx*4+scorperclips]	; 84684
call RequestSample	; 8468B
call EnsureSampleRoom	; 84690
mov eax, dword [nosplit edx*4+scorperclips]	; 84695
call QueueSpeechClip	; 8469C
mov eax, dword [speechq]	; 846A1
mov dword [byte eax+060h], 1	; 846A6
mov eax, 1	; 846AD
.x:
pop edx	; 846B2
ret	; 846B3
%endif ; C
; C: src/c/front/announcer/ShutdownSpeech.c (SayNhlIntro)
%ifdef CBUILD
%include "c/front/announcer/ShutdownSpeech.SayNhlIntro.inc"
%else
SayNhlIntro:
push dword 4	; 846B4
call __CHK	; 846B9
mov eax, str_NhlInt	; 846BE
jmp near SayClip	; 846C3
SayGoodnight:
push dword 4	; 846C8
call __CHK	; 846CD
mov eax, str_GoodniteInt	; 846D2
jmp near SayClip	; 846D7
SayLineups:
push dword 4	; 846DC
call __CHK	; 846E1
mov eax, str_LineupsInt	; 846E6
jmp near SayClip	; 846EB
SayNowBack:
push dword 4	; 846F0
call __CHK	; 846F5
mov eax, str_NowbackInt	; 846FA
jmp near SayClip	; 846FF
FreeNowBack:
push dword 4	; 84704
call __CHK	; 84709
mov eax, str_NowbackInt	; 8470E
jmp short FreeClip	; 84713
SayBackMoment:
push dword 4	; 84715
call __CHK	; 8471A
mov eax, str_BackmomtInt	; 8471F
jmp near SayClip	; 84724
FreeBackMoment:
push dword 4	; 84729
call __CHK	; 8472E
mov eax, str_BackmomtInt	; 84733
jmp short FreeClip	; 84738
SayCoachClip:
push dword 4	; 8473A
call __CHK	; 8473F
mov eax, str_CoachclpInt	; 84744
jmp near SayClip	; 84749
FreeCoachClip:
push dword 4	; 8474E
call __CHK	; 84753
mov eax, str_CoachclpInt	; 84758
FreeClip:
push dword 0Ch	; 8475D
call __CHK	; 84762
push ebx	; 84767
push edx	; 84768
call FindSpeechSlot	; 84769
cmp eax, byte 0FFFFFFFFh	; 8476E
je short FreeClip_ret	; 84771
mov edx, eax	; 84773
shl eax, 2	; 84775
add eax, edx	; 84778
shl eax, 2	; 8477A
sub eax, edx	; 8477D
lea edx, [eax+eax]	; 8477F
mov eax, dword [speechbank]	; 84782
add eax, edx	; 84787
mov ebx, dword [byte eax+022h]	; 84789
cmp ebx, byte 1	; 8478C
jne short FreeClip_ret	; 8478F
mov dword [byte eax+022h], 0	; 84791
mov eax, dword [speechbank]	; 84798
mov edx, dword [byte edx+eax+016h]	; 8479D
sub dword [dword eax+03B6Ch], edx	; 847A1
mov eax, dword [speechbank]	; 847A7
sub dword [dword eax+03B74h], ebx	; 847AC
call EnsureSampleRoom	; 847B2
FreeClip_ret:
pop edx	; 847B7
pop ebx	; 847B8
ret	; 847B9
SayElseNhl:
push dword 4	; 847BA
call __CHK	; 847BF
mov eax, str_ElsenhlInt	; 847C4
jmp near SayClip	; 847C9
%endif ; C
; C: src/c/front/announcer/ShutdownSpeech.c (SayHighlightIntro)
%ifdef CBUILD
%include "c/front/announcer/ShutdownSpeech.SayHighlightIntro.inc"
%else
SayHighlightIntro:
push dword 48h	; 847CE
call __CHK	; 847D3
push ecx	; 847D8
sub esp, byte 30h	; 847D9
mov ecx, eax	; 847DC
cmp dword [speechinit], byte 0	; 847DE
jne short .1	; 847E5
xor eax, eax	; 847E7
add esp, byte 30h	; 847E9
pop ecx	; 847EC
ret	; 847ED
.1:
call SpeechIdle	; 847EE
test eax, eax	; 847F3
je near .x	; 847F5
mov eax, dword [speechbank]	; 847FB
mov dword [dword eax+03B70h], 0	; 84800
push str_Rnk	; 8480A
push ecx	; 8480F
push str_SS5	; 84810
lea eax, [byte esp+02Ch]	; 84815
push eax	; 84819
call sprintf_	; 8481A
add esp, byte 10h	; 8481F
push str_Awa	; 84822
push edx	; 84827
push str_SS5	; 84828
lea eax, [byte esp+01Ch]	; 8482D
push eax	; 84831
call sprintf_	; 84832
add esp, byte 10h	; 84837
push str_Hom	; 8483A
push ebx	; 8483F
push str_SS5	; 84840
lea eax, [byte esp+0Ch]	; 84845
push eax	; 84849
call sprintf_	; 8484A
add esp, byte 10h	; 8484F
call ResetSpeechQueue	; 84852
call ResetSampleReq	; 84857
mov eax, str_TakeynowBar	; 8485C
call RequestSample	; 84861
lea eax, [byte esp+020h]	; 84866
call RequestSample	; 8486A
mov eax, str_HighliteBar	; 8486F
call RequestSample	; 84874
mov eax, str_OfBar	; 84879
call RequestSample	; 8487E
mov eax, str_GamebtwnBar	; 84883
call RequestSample	; 84888
lea eax, [byte esp+010h]	; 8488D
call RequestSample	; 84891
mov eax, str_AndBar	; 84896
call RequestSample	; 8489B
mov eax, esp	; 848A0
call RequestSample	; 848A2
call EnsureSampleRoom	; 848A7
mov eax, str_TakeynowBar	; 848AC
call QueueSpeechClip	; 848B1
lea eax, [byte esp+020h]	; 848B6
call QueueSpeechClip	; 848BA
mov eax, str_HighliteBar	; 848BF
call QueueSpeechClip	; 848C4
mov eax, str_OfBar	; 848C9
call QueueSpeechClip	; 848CE
mov eax, str_GamebtwnBar	; 848D3
call QueueSpeechClip	; 848D8
lea eax, [byte esp+010h]	; 848DD
call QueueSpeechClip	; 848E1
mov eax, str_AndBar	; 848E6
call QueueSpeechClip	; 848EB
mov eax, esp	; 848F0
call QueueSpeechClip	; 848F2
mov eax, dword [speechq]	; 848F7
mov dword [byte eax+060h], 1	; 848FC
mov eax, 1	; 84903
.x:
add esp, byte 30h	; 84908
pop ecx	; 8490B
ret	; 8490C
%endif ; C
; C: src/c/front/announcer/ShutdownSpeech.c (SayPlayoffResult)
%ifdef CBUILD
%include "c/front/announcer/ShutdownSpeech.SayPlayoffResult.inc"
%else
SayPlayoffResult:
push dword 64h	; 8490D
call __CHK	; 84912
push esi	; 84917
push edi	; 84918
push ebp	; 84919
sub esp, byte 40h	; 8491A
mov ebp, eax	; 8491D
mov esi, edx	; 8491F
mov edi, ebx	; 84921
cmp dword [speechinit], byte 0	; 84923
jne short .1	; 8492A
xor eax, eax	; 8492C
jmp near .x	; 8492E
.1:
call SpeechIdle	; 84933
test eax, eax	; 84938
je near .x	; 8493A
mov eax, dword [speechbank]	; 84940
mov dword [dword eax+03B70h], 0	; 84945
push str_Awa	; 8494F
push ebp	; 84954
push str_SS5	; 84955
lea eax, [byte esp+03Ch]	; 8495A
push eax	; 8495E
call sprintf_	; 8495F
add esp, byte 10h	; 84964
mov ebx, 0Ah	; 84967
lea edx, [byte esp+020h]	; 8496C
mov eax, esi	; 84970
call itoa_	; 84972
push str_Bar	; 84977
lea eax, [byte esp+024h]	; 8497C
push eax	; 84980
push str_Gamenum	; 84981
push str_SSS	; 84986
lea eax, [byte esp+010h]	; 8498B
push eax	; 8498F
call sprintf_	; 84990
add esp, byte 14h	; 84995
mov ebx, ecx	; 84998
mov edx, edi	; 8499A
lea eax, [byte esp+010h]	; 8499C
call PlayoffRoundClipD	; 849A0
call ResetSampleReq	; 849A5
call ResetSpeechQueue	; 849AA
cmp dword [byte esp+050h], byte 0	; 849AF
je short .2	; 849B4
mov eax, str_OvertimeBar	; 849B6
call RequestSample	; 849BB
.2:
lea eax, [byte esp+030h]	; 849C0
call RequestSample	; 849C4
mov eax, str_HavewonBar	; 849C9
call RequestSample	; 849CE
cmp dword [byte esp+054h], byte 0	; 849D3
jne short .3	; 849D8
mov eax, str_GamenumBar	; 849DA
call RequestSample	; 849DF
mov eax, esp	; 849E4
call RequestSample	; 849E6
mov eax, str_OfBar	; 849EB
call RequestSample	; 849F0
.3:
lea eax, [byte esp+010h]	; 849F5
call RequestSample	; 849F9
call EnsureSampleRoom	; 849FE
cmp dword [byte esp+050h], byte 0	; 84A03
je short .4	; 84A08
mov eax, str_OvertimeBar	; 84A0A
call QueueSpeechClip	; 84A0F
.4:
lea eax, [byte esp+030h]	; 84A14
call QueueSpeechClip	; 84A18
mov eax, str_HavewonBar	; 84A1D
call QueueSpeechClip	; 84A22
cmp dword [byte esp+054h], byte 0	; 84A27
jne short .5	; 84A2C
mov eax, str_GamenumBar	; 84A2E
call QueueSpeechClip	; 84A33
mov eax, esp	; 84A38
call QueueSpeechClip	; 84A3A
mov eax, str_OfBar	; 84A3F
call QueueSpeechClip	; 84A44
.5:
lea eax, [byte esp+010h]	; 84A49
call QueueSpeechClip	; 84A4D
mov eax, dword [speechq]	; 84A52
mov dword [byte eax+060h], 1	; 84A57
mov eax, 1	; 84A5E
.x:
add esp, byte 40h	; 84A63
pop ebp	; 84A66
pop edi	; 84A67
pop esi	; 84A68
ret 8	; 84A69
%endif ; C
; C: src/c/front/announcer/ShutdownSpeech.c (SayTheGame)
%ifdef CBUILD
%include "c/front/announcer/ShutdownSpeech.SayTheGame.inc"
%else
SayTheGame:
push dword 4	; 84A6C
call __CHK	; 84A71
mov eax, str_ThegameBar	; 84A76
jmp short SayClip	; 84A7B
%endif ; C
; C: src/c/front/announcer/ShutdownSpeech.c (SayScoringPeriod)
%ifdef CBUILD
%include "c/front/announcer/ShutdownSpeech.SayScoringPeriod.inc"
%else
SayScoringPeriod:
push dword 4	; 84A7D
call __CHK	; 84A82
test ebx, ebx	; 84A87
je short .1	; 84A89
mov eax, str_ThegameBar	; 84A8B
jmp short SayClip	; 84A90
.1:
test edx, edx	; 84A92
je short SayScoringPeriod_reg	; 84A94
cmp eax, byte 2	; 84A96
jb short .2	; 84A99
jbe short SayScoringPeriod_ot2	; 84A9B
cmp eax, byte 3	; 84A9D
je short SayScoringPeriod_ot3	; 84AA0
jmp short SayScoringPeriod_ott	; 84AA2
.2:
cmp eax, byte 1	; 84AA4
jne short SayScoringPeriod_ott	; 84AA7
mov eax, str_Scor1otpBar	; 84AA9
%endif ; C
; C: src/c/front/announcer/ShutdownSpeech.c (SayClip)
%ifdef CBUILD
%include "c/front/announcer/ShutdownSpeech.SayClip.inc"
%else
SayClip:
push dword 8	; 84AAE
call __CHK	; 84AB3
push edx	; 84AB8
mov edx, eax	; 84AB9
cmp dword [speechinit], byte 0	; 84ABB
jne near SayClip_body	; 84AC2
xor eax, eax	; 84AC8
pop edx	; 84ACA
ret	; 84ACB
%endif ; C
; C: src/c/front/announcer/ShutdownSpeech.c (SayScoringPeriod_ot2)
%ifdef CBUILD
%include "c/front/announcer/ShutdownSpeech.SayScoringPeriod_ot2.inc"
%else
SayScoringPeriod_ot2:
mov eax, str_Scor2otpBar	; 84ACC
jmp short SayClip	; 84AD1
SayScoringPeriod_ot3:
mov eax, str_Scor3otpBar	; 84AD3
jmp short SayClip	; 84AD8
SayScoringPeriod_ott:
mov eax, str_ScortotpBar	; 84ADA
jmp short SayClip	; 84ADF
SayScoringPeriod_reg:
cmp eax, byte 2	; 84AE1
jb short .1	; 84AE4
jbe short .2	; 84AE6
cmp eax, byte 3	; 84AE8
je short .3	; 84AEB
xor eax, eax	; 84AED
ret	; 84AEF
.1:
cmp eax, byte 1	; 84AF0
jne short .4	; 84AF3
mov eax, str_Scor1perBar	; 84AF5
jmp short SayClip	; 84AFA
.2:
mov eax, str_Scor2perBar	; 84AFC
jmp short SayClip	; 84B01
.3:
mov eax, str_Scor3perBar	; 84B03
jmp short SayClip	; 84B08
.4:
xor eax, eax	; 84B0A
ret	; 84B0C
%endif ; C
; C: src/c/front/announcer/SayTonightIntro.c
%ifdef CBUILD
%include "c/front/announcer/SayTonightIntro.inc"
%else
SayTonightIntro:
push dword 48h	; 84B0D
call __CHK	; 84B12
push ecx	; 84B17
sub esp, byte 30h	; 84B18
mov ecx, eax	; 84B1B
cmp dword [speechinit], byte 0	; 84B1D
jne short .1	; 84B24
xor eax, eax	; 84B26
add esp, byte 30h	; 84B28
pop ecx	; 84B2B
ret	; 84B2C
.1:
call SpeechIdle	; 84B2D
test eax, eax	; 84B32
je near .x	; 84B34
mov eax, dword [speechbank]	; 84B3A
mov dword [dword eax+03B70h], 0	; 84B3F
push str_Rnk	; 84B49
push ecx	; 84B4E
push str_SS5	; 84B4F
lea eax, [byte esp+02Ch]	; 84B54
push eax	; 84B58
call sprintf_	; 84B59
add esp, byte 10h	; 84B5E
push str_Awa	; 84B61
push edx	; 84B66
push str_SS5	; 84B67
lea eax, [byte esp+01Ch]	; 84B6C
push eax	; 84B70
call sprintf_	; 84B71
add esp, byte 10h	; 84B76
push str_Hom	; 84B79
push ebx	; 84B7E
push str_SS5	; 84B7F
lea eax, [byte esp+0Ch]	; 84B84
push eax	; 84B88
call sprintf_	; 84B89
add esp, byte 10h	; 84B8E
call ResetSpeechQueue	; 84B91
call ResetSampleReq	; 84B96
mov eax, str_TonightBar	; 84B9B
call RequestSample	; 84BA0
lea eax, [byte esp+020h]	; 84BA5
call RequestSample	; 84BA9
mov eax, str_EasportsBar	; 84BAE
call RequestSample	; 84BB3
mov eax, str_GamebtwnBar	; 84BB8
call RequestSample	; 84BBD
lea eax, [byte esp+010h]	; 84BC2
call RequestSample	; 84BC6
mov eax, str_AndBar	; 84BCB
call RequestSample	; 84BD0
mov eax, esp	; 84BD5
call RequestSample	; 84BD7
call EnsureSampleRoom	; 84BDC
mov eax, str_TonightBar	; 84BE1
call QueueSpeechClip	; 84BE6
lea eax, [byte esp+020h]	; 84BEB
call QueueSpeechClip	; 84BEF
mov eax, str_EasportsBar	; 84BF4
call QueueSpeechClip	; 84BF9
mov eax, str_GamebtwnBar	; 84BFE
call QueueSpeechClip	; 84C03
lea eax, [byte esp+010h]	; 84C08
call QueueSpeechClip	; 84C0C
mov eax, str_AndBar	; 84C11
call QueueSpeechClip	; 84C16
mov eax, esp	; 84C1B
call QueueSpeechClip	; 84C1D
mov eax, dword [speechq]	; 84C22
mov dword [byte eax+060h], 1	; 84C27
mov eax, 1	; 84C2E
.x:
add esp, byte 30h	; 84C33
pop ecx	; 84C36
ret	; 84C37
%endif ; C
; C: src/c/front/announcer/SayPlayoffTonight.c
%ifdef CBUILD
%include "c/front/announcer/SayPlayoffTonight.inc"
%else
SayPlayoffTonight:
push dword 7Ch	; 84C38
call __CHK	; 84C3D
push esi	; 84C42
sub esp, byte 60h	; 84C43
mov esi, eax	; 84C46
cmp dword [speechinit], byte 0	; 84C48
jne short .1	; 84C4F
xor eax, eax	; 84C51
jmp near .x	; 84C53
.1:
call SpeechIdle	; 84C58
test eax, eax	; 84C5D
je near .x	; 84C5F
mov eax, dword [speechbank]	; 84C65
mov dword [dword eax+03B70h], 0	; 84C6A
push str_Rnk	; 84C74
push esi	; 84C79
push str_SS5	; 84C7A
lea eax, [byte esp+04Ch]	; 84C7F
push eax	; 84C83
call sprintf_	; 84C84
add esp, byte 10h	; 84C89
push str_Awa	; 84C8C
push edx	; 84C91
push str_SS5	; 84C92
lea eax, [byte esp+05Ch]	; 84C97
push eax	; 84C9B
call sprintf_	; 84C9C
add esp, byte 10h	; 84CA1
push str_Hom	; 84CA4
push ebx	; 84CA9
push str_SS5	; 84CAA
lea eax, [byte esp+01Ch]	; 84CAF
push eax	; 84CB3
call sprintf_	; 84CB4
add esp, byte 10h	; 84CB9
mov ebx, 0Ah	; 84CBC
lea edx, [byte esp+030h]	; 84CC1
mov eax, ecx	; 84CC5
call itoa_	; 84CC7
push str_Bar	; 84CCC
lea eax, [byte esp+034h]	; 84CD1
push eax	; 84CD5
push str_Gamenum	; 84CD6
push str_SSS	; 84CDB
lea eax, [byte esp+030h]	; 84CE0
push eax	; 84CE4
call sprintf_	; 84CE5
add esp, byte 14h	; 84CEA
mov ebx, dword [byte esp+06Ch]	; 84CED
mov edx, dword [byte esp+068h]	; 84CF1
mov eax, esp	; 84CF5
call PlayoffRoundClipU	; 84CF7
call ResetSpeechQueue	; 84CFC
call ResetSampleReq	; 84D01
mov eax, str_TonightBar	; 84D06
call RequestSample	; 84D0B
lea eax, [byte esp+040h]	; 84D10
call RequestSample	; 84D14
mov eax, str_EasportsBar	; 84D19
call RequestSample	; 84D1E
lea eax, [byte esp+020h]	; 84D23
call RequestSample	; 84D27
mov eax, str_OfBar	; 84D2C
call RequestSample	; 84D31
mov eax, esp	; 84D36
call RequestSample	; 84D38
mov eax, str_BetweenBar	; 84D3D
call RequestSample	; 84D42
lea eax, [byte esp+050h]	; 84D47
call RequestSample	; 84D4B
mov eax, str_AndBar	; 84D50
call RequestSample	; 84D55
lea eax, [byte esp+010h]	; 84D5A
call RequestSample	; 84D5E
call EnsureSampleRoom	; 84D63
mov eax, str_TonightBar	; 84D68
call QueueSpeechClip	; 84D6D
lea eax, [byte esp+040h]	; 84D72
call QueueSpeechClip	; 84D76
mov eax, str_EasportsBar	; 84D7B
call QueueSpeechClip	; 84D80
lea eax, [byte esp+020h]	; 84D85
call QueueSpeechClip	; 84D89
mov eax, str_OfBar	; 84D8E
call QueueSpeechClip	; 84D93
mov eax, esp	; 84D98
call QueueSpeechClip	; 84D9A
mov eax, str_BetweenBar	; 84D9F
call QueueSpeechClip	; 84DA4
lea eax, [byte esp+050h]	; 84DA9
call QueueSpeechClip	; 84DAD
mov eax, str_AndBar	; 84DB2
call QueueSpeechClip	; 84DB7
lea eax, [byte esp+010h]	; 84DBC
call QueueSpeechClip	; 84DC0
mov eax, dword [speechq]	; 84DC5
mov dword [byte eax+060h], 1	; 84DCA
mov eax, 1	; 84DD1
.x:
add esp, byte 60h	; 84DD6
pop esi	; 84DD9
ret 8	; 84DDA
%endif ; C
; C: src/c/front/announcer/RequestTimeClips.c
%ifdef CBUILD
%include "c/front/announcer/RequestTimeClips.inc"
%else
RequestTimeClips:
push dword 38h	; 84DDD
call __CHK	; 84DE2
push ebx	; 84DE7
sub esp, byte 20h	; 84DE8
mov ebx, eax	; 84DEB
push str_Num	; 84DED
push eax	; 84DF2
push str_DS	; 84DF3
lea eax, [byte esp+01Ch]	; 84DF8
push eax	; 84DFC
call sprintf_	; 84DFD
add esp, byte 10h	; 84E02
push str_Num	; 84E05
push edx	; 84E0A
push str_02dS	; 84E0B
lea eax, [byte esp+0Ch]	; 84E10
push eax	; 84E14
call sprintf_	; 84E15
add esp, byte 10h	; 84E1A
mov eax, str_AtCor	; 84E1D
call RequestSample	; 84E22
mov eax, str_PauseCor	; 84E27
call RequestSample	; 84E2C
test ebx, ebx	; 84E31
je short .4	; 84E33
test edx, edx	; 84E35
jne short .2	; 84E37
cmp ebx, byte 1	; 84E39
jne short .1	; 84E3C
mov eax, str_1minuteCor	; 84E3E
jmp short .3	; 84E43
.1:
lea eax, [byte esp+010h]	; 84E45
call RequestSample	; 84E49
mov eax, str_MinutesCor	; 84E4E
jmp short .3	; 84E53
.2:
lea eax, [byte esp+010h]	; 84E55
.3:
call RequestSample	; 84E59
.4:
cmp edx, byte 1	; 84E5E
jne short .6	; 84E61
test ebx, ebx	; 84E63
jne short .5	; 84E65
mov eax, str_1secondCor	; 84E67
jmp short .8	; 84E6C
.5:
mov eax, esp	; 84E6E
jmp short .8	; 84E70
.6:
test edx, edx	; 84E72
jle short .x	; 84E74
test ebx, ebx	; 84E76
jne short .7	; 84E78
push str_Num	; 84E7A
push edx	; 84E7F
push str_DS	; 84E80
lea eax, [byte esp+0Ch]	; 84E85
push eax	; 84E89
call sprintf_	; 84E8A
add esp, byte 10h	; 84E8F
mov eax, esp	; 84E92
call RequestSample	; 84E94
mov eax, str_SecondsCor	; 84E99
jmp short .8	; 84E9E
.7:
mov eax, esp	; 84EA0
.8:
call RequestSample	; 84EA2
.x:
add esp, byte 20h	; 84EA7
pop ebx	; 84EAA
ret	; 84EAB
%endif ; C
; C: src/c/front/announcer/QueueTimeClips.c
%ifdef CBUILD
%include "c/front/announcer/QueueTimeClips.inc"
%else
QueueTimeClips:
push dword 38h	; 84EAC
call __CHK	; 84EB1
push ebx	; 84EB6
sub esp, byte 20h	; 84EB7
mov ebx, eax	; 84EBA
push str_Num	; 84EBC
push eax	; 84EC1
push str_DS	; 84EC2
lea eax, [byte esp+01Ch]	; 84EC7
push eax	; 84ECB
call sprintf_	; 84ECC
add esp, byte 10h	; 84ED1
push str_Num	; 84ED4
push edx	; 84ED9
push str_02dS	; 84EDA
lea eax, [byte esp+0Ch]	; 84EDF
push eax	; 84EE3
call sprintf_	; 84EE4
add esp, byte 10h	; 84EE9
mov eax, str_AtCor	; 84EEC
call QueueSpeechClip	; 84EF1
mov eax, str_PauseCor	; 84EF6
call QueueSpeechClip	; 84EFB
test ebx, ebx	; 84F00
je short .4	; 84F02
test edx, edx	; 84F04
jne short .2	; 84F06
cmp ebx, byte 1	; 84F08
jne short .1	; 84F0B
mov eax, str_1minuteCor	; 84F0D
jmp short .3	; 84F12
.1:
lea eax, [byte esp+010h]	; 84F14
call QueueSpeechClip	; 84F18
mov eax, str_MinutesCor	; 84F1D
jmp short .3	; 84F22
.2:
lea eax, [byte esp+010h]	; 84F24
.3:
call QueueSpeechClip	; 84F28
.4:
cmp edx, byte 1	; 84F2D
jne short .6	; 84F30
test ebx, ebx	; 84F32
jne short .5	; 84F34
mov eax, str_1secondCor	; 84F36
jmp short .8	; 84F3B
.5:
mov eax, esp	; 84F3D
jmp short .8	; 84F3F
.6:
test edx, edx	; 84F41
jle short .x	; 84F43
test ebx, ebx	; 84F45
jne short .7	; 84F47
push str_Num	; 84F49
push edx	; 84F4E
push str_DS	; 84F4F
lea eax, [byte esp+0Ch]	; 84F54
push eax	; 84F58
call sprintf_	; 84F59
add esp, byte 10h	; 84F5E
mov eax, esp	; 84F61
call QueueSpeechClip	; 84F63
mov eax, str_SecondsCor	; 84F68
jmp short .8	; 84F6D
.7:
mov eax, esp	; 84F6F
.8:
call QueueSpeechClip	; 84F71
.x:
add esp, byte 20h	; 84F76
pop ebx	; 84F79
ret	; 84F7A
%endif ; C
; C: src/c/front/announcer/SayPenalty.c
%ifdef CBUILD
%include "c/front/announcer/SayPenalty.inc"
%else
SayPenalty:
push dword 60h	; 84F7B
call __CHK	; 84F80
push esi	; 84F85
push edi	; 84F86
push ebp	; 84F87
sub esp, byte 40h	; 84F88
mov esi, eax	; 84F8B
mov edi, dword [byte esp+050h]	; 84F8D
mov ebp, dword [byte esp+054h]	; 84F91
mov eax, dword [speechinit]	; 84F95
test eax, eax	; 84F9A
je near .x	; 84F9C
call SpeechIdle	; 84FA2
test eax, eax	; 84FA7
je near .x	; 84FA9
mov eax, dword [speechbank]	; 84FAF
mov dword [dword eax+03B70h], 1Ah	; 84FB4
push str_Tea	; 84FBE
push esi	; 84FC3
push str_SS5	; 84FC4
lea eax, [byte esp+0Ch]	; 84FC9
push eax	; 84FCD
call sprintf_	; 84FCE
add esp, byte 10h	; 84FD3
push str_Num	; 84FD6
push edx	; 84FDB
push str_DS	; 84FDC
lea eax, [byte esp+03Ch]	; 84FE1
push eax	; 84FE5
call sprintf_	; 84FE6
add esp, byte 10h	; 84FEB
lea edx, [byte esp+020h]	; 84FEE
mov eax, ebx	; 84FF2
call PenaltyLenClip	; 84FF4
push str_Pen	; 84FF9
push ecx	; 84FFE
push str_SS5	; 84FFF
lea eax, [byte esp+01Ch]	; 85004
push eax	; 85008
call sprintf_	; 85009
add esp, byte 10h	; 8500E
call ResetSampleReq	; 85011
call ResetSpeechQueue	; 85016
mov eax, str_OneleftCor	; 8501B
call RequestSample	; 85020
mov edx, dword [byte esp+058h]	; 85025
cmp edx, byte 1	; 85029
jne short .2	; 8502C
mov eax, esp	; 8502E
call RequestSample	; 85030
cmp edx, dword [byte esp+05Ch]	; 85035
jge short .1	; 85039
mov eax, str_PensnumCor	; 8503B
jmp short .3	; 85040
.1:
mov eax, str_PennumCor	; 85042
jmp short .3	; 85047
.2:
mov eax, str_AndnumCor	; 85049
.3:
call RequestSample	; 8504E
lea eax, [byte esp+030h]	; 85053
call RequestSample	; 85057
mov eax, str_PauseCor	; 8505C
call RequestSample	; 85061
lea eax, [byte esp+020h]	; 85066
call RequestSample	; 8506A
lea eax, [byte esp+010h]	; 8506F
call RequestSample	; 85073
mov eax, str_PauseCor	; 85078
call RequestSample	; 8507D
cmp dword [byte esp+060h], byte 0	; 85082
je short .4	; 85087
mov edx, ebp	; 85089
mov eax, edi	; 8508B
call RequestTimeClips	; 8508D
.4:
call EnsureSampleRoom	; 85092
mov esi, dword [byte esp+058h]	; 85097
cmp esi, byte 1	; 8509B
jne short .6	; 8509E
mov eax, esp	; 850A0
call QueueSpeechClip	; 850A2
cmp esi, dword [byte esp+05Ch]	; 850A7
jge short .5	; 850AB
mov eax, str_PensnumCor	; 850AD
jmp short .7	; 850B2
.5:
mov eax, str_PennumCor	; 850B4
jmp short .7	; 850B9
.6:
mov eax, str_AndnumCor	; 850BB
.7:
call QueueSpeechClip	; 850C0
lea eax, [byte esp+030h]	; 850C5
call QueueSpeechClip	; 850C9
mov eax, str_PauseCor	; 850CE
call QueueSpeechClip	; 850D3
lea eax, [byte esp+020h]	; 850D8
call QueueSpeechClip	; 850DC
lea eax, [byte esp+010h]	; 850E1
call QueueSpeechClip	; 850E5
mov eax, str_PauseCor	; 850EA
call QueueSpeechClip	; 850EF
cmp dword [byte esp+060h], byte 0	; 850F4
je short .8	; 850F9
mov edx, ebp	; 850FB
mov eax, edi	; 850FD
call QueueTimeClips	; 850FF
.8:
mov eax, dword [speechq]	; 85104
mov dword [byte eax+060h], 1	; 85109
mov eax, 1	; 85110
.x:
add esp, byte 40h	; 85115
pop ebp	; 85118
pop edi	; 85119
pop esi	; 8511A
ret 14h	; 8511B
%endif ; C
; C: src/c/front/announcer/SayPenaltyShot.c
%ifdef CBUILD
%include "c/front/announcer/SayPenaltyShot.inc"
%else
SayPenaltyShot:
push dword 38h	; 8511E
call __CHK	; 85123
push esi	; 85128
sub esp, byte 20h	; 85129
mov esi, eax	; 8512C
cmp dword [speechinit], byte 0	; 8512E
jne short .1	; 85135
xor eax, eax	; 85137
add esp, byte 20h	; 85139
pop esi	; 8513C
ret	; 8513D
.1:
call SpeechIdle	; 8513E
test eax, eax	; 85143
je near .x	; 85145
mov eax, dword [speechbank]	; 8514B
mov dword [dword eax+03B70h], 1Ah	; 85150
push str_Tea	; 8515A
push esi	; 8515F
push str_SS5	; 85160
lea eax, [byte esp+01Ch]	; 85165
push eax	; 85169
call sprintf_	; 8516A
add esp, byte 10h	; 8516F
push str_Num	; 85172
push edx	; 85177
push str_DS	; 85178
lea eax, [byte esp+0Ch]	; 8517D
push eax	; 85181
call sprintf_	; 85182
add esp, byte 10h	; 85187
call ResetSampleReq	; 8518A
call ResetSpeechQueue	; 8518F
mov eax, str_OneleftCor	; 85194
call RequestSample	; 85199
lea eax, [byte esp+010h]	; 8519E
call RequestSample	; 851A2
mov eax, str_PenshotCor	; 851A7
call RequestSample	; 851AC
mov eax, esp	; 851B1
call RequestSample	; 851B3
mov eax, str_PauseCor	; 851B8
call RequestSample	; 851BD
mov edx, ecx	; 851C2
mov eax, ebx	; 851C4
call RequestTimeClips	; 851C6
call EnsureSampleRoom	; 851CB
lea eax, [byte esp+010h]	; 851D0
call QueueSpeechClip	; 851D4
mov eax, str_PenshotCor	; 851D9
call QueueSpeechClip	; 851DE
mov eax, esp	; 851E3
call QueueSpeechClip	; 851E5
mov eax, str_PauseCor	; 851EA
call QueueSpeechClip	; 851EF
mov edx, ecx	; 851F4
mov eax, ebx	; 851F6
call QueueTimeClips	; 851F8
mov eax, dword [speechq]	; 851FD
mov dword [byte eax+060h], 1	; 85202
mov eax, 1	; 85209
.x:
add esp, byte 20h	; 8520E
pop esi	; 85211
ret	; 85212
%endif ; C
; C: src/c/front/announcer/SayPlayerNumber.c
%ifdef CBUILD
%include "c/front/announcer/SayPlayerNumber.inc"
%else
SayPlayerNumber:
push dword 4Ch	; 85213
call __CHK	; 85218
push ecx	; 8521D
push esi	; 8521E
sub esp, byte 30h	; 8521F
mov ecx, eax	; 85222
mov esi, ebx	; 85224
cmp dword [speechinit], byte 0	; 85226
jne short .1	; 8522D
xor eax, eax	; 8522F
jmp near .x	; 85231
.1:
call SpeechIdle	; 85236
test eax, eax	; 8523B
je near .x	; 8523D
mov eax, dword [speechbank]	; 85243
mov dword [dword eax+03B70h], 1Ah	; 85248
push str_Frm	; 85252
push ecx	; 85257
push str_SS5	; 85258
lea eax, [byte esp+02Ch]	; 8525D
push eax	; 85261
call sprintf_	; 85262
add esp, byte 10h	; 85267
mov edx, dword [nosplit edx*4+dword_D27A2]	; 8526A
mov ebx, 0Dh	; 85271
mov eax, esp	; 85276
call strncpy_	; 85278
push str_Num	; 8527D
push esi	; 85282
push str_DS	; 85283
lea eax, [byte esp+01Ch]	; 85288
push eax	; 8528C
call sprintf_	; 8528D
add esp, byte 10h	; 85292
call ResetSampleReq	; 85295
call ResetSpeechQueue	; 8529A
mov eax, str_OneleftCor	; 8529F
call RequestSample	; 852A4
mov eax, esp	; 852A9
call RequestSample	; 852AB
lea eax, [byte esp+020h]	; 852B0
call RequestSample	; 852B4
mov eax, str_PauseCor	; 852B9
call RequestSample	; 852BE
mov eax, str_NumberCor	; 852C3
call RequestSample	; 852C8
lea eax, [byte esp+010h]	; 852CD
call RequestSample	; 852D1
call EnsureSampleRoom	; 852D6
mov eax, esp	; 852DB
call QueueSpeechClip	; 852DD
lea eax, [byte esp+020h]	; 852E2
call QueueSpeechClip	; 852E6
mov eax, str_PauseCor	; 852EB
call QueueSpeechClip	; 852F0
mov eax, str_NumberCor	; 852F5
call QueueSpeechClip	; 852FA
lea eax, [byte esp+010h]	; 852FF
call QueueSpeechClip	; 85303
mov eax, dword [speechq]	; 85308
mov dword [byte eax+060h], 1	; 8530D
mov eax, 1	; 85314
.x:
add esp, byte 30h	; 85319
pop esi	; 8531C
pop ecx	; 8531D
ret	; 8531E
%endif ; C
; C: src/c/front/announcer/SayGoal.c
%ifdef CBUILD
%include "c/front/announcer/SayGoal.inc"
%else
SayGoal:
push dword 5Ch	; 8531F
call __CHK	; 85324
push esi	; 85329
push ebp	; 8532A
sub esp, byte 40h	; 8532B
mov esi, eax	; 8532E
cmp dword [speechinit], byte 0	; 85330
jne short .1	; 85337
xor eax, eax	; 85339
jmp near .x	; 8533B
.1:
call SpeechIdle	; 85340
test eax, eax	; 85345
je near .x	; 85347
mov eax, dword [speechbank]	; 8534D
mov dword [dword eax+03B70h], 1Ah	; 85352
push str_Tea	; 8535C
push esi	; 85361
push str_SS5	; 85362
lea eax, [byte esp+03Ch]	; 85367
push eax	; 8536B
call sprintf_	; 8536C
add esp, byte 10h	; 85371
push str_Num	; 85374
push ebx	; 85379
push str_DS	; 8537A
lea eax, [byte esp+0Ch]	; 8537F
push eax	; 85383
call sprintf_	; 85384
add esp, byte 10h	; 85389
push str_Num	; 8538C
push ecx	; 85391
push str_DS	; 85392
lea eax, [byte esp+02Ch]	; 85397
push eax	; 8539B
call sprintf_	; 8539C
add esp, byte 10h	; 853A1
push str_Num	; 853A4
mov ebp, dword [byte esp+050h]	; 853A9
push ebp	; 853AD
push str_DS	; 853AE
lea eax, [byte esp+01Ch]	; 853B3
push eax	; 853B7
call sprintf_	; 853B8
add esp, byte 10h	; 853BD
call ResetSampleReq	; 853C0
call ResetSpeechQueue	; 853C5
mov eax, str_OneleftCor	; 853CA
call RequestSample	; 853CF
lea eax, [byte esp+030h]	; 853D4
call RequestSample	; 853D8
mov eax, str_GoalnumCor	; 853DD
call RequestSample	; 853E2
mov eax, esp	; 853E7
call RequestSample	; 853E9
test edx, edx	; 853EE
jle short .2	; 853F0
mov eax, str_PauseCor	; 853F2
call RequestSample	; 853F7
mov eax, str_AsstnumCor	; 853FC
call RequestSample	; 85401
lea eax, [byte esp+020h]	; 85406
call RequestSample	; 8540A
.2:
cmp edx, byte 1	; 8540F
jle short .3	; 85412
mov eax, str_PauseCor	; 85414
call RequestSample	; 85419
mov eax, str_AndnumCor	; 8541E
call RequestSample	; 85423
lea eax, [byte esp+010h]	; 85428
call RequestSample	; 8542C
.3:
call EnsureSampleRoom	; 85431
lea eax, [byte esp+030h]	; 85436
call QueueSpeechClip	; 8543A
mov eax, str_GoalnumCor	; 8543F
call QueueSpeechClip	; 85444
mov eax, esp	; 85449
call QueueSpeechClip	; 8544B
test edx, edx	; 85450
jle short .4	; 85452
mov eax, str_PauseCor	; 85454
call QueueSpeechClip	; 85459
mov eax, str_AsstnumCor	; 8545E
call QueueSpeechClip	; 85463
lea eax, [byte esp+020h]	; 85468
call QueueSpeechClip	; 8546C
.4:
cmp edx, byte 1	; 85471
jle short .5	; 85474
mov eax, str_PauseCor	; 85476
call QueueSpeechClip	; 8547B
mov eax, str_AndnumCor	; 85480
call QueueSpeechClip	; 85485
lea eax, [byte esp+010h]	; 8548A
call QueueSpeechClip	; 8548E
.5:
mov eax, dword [speechq]	; 85493
mov dword [byte eax+060h], 1	; 85498
mov eax, 1	; 8549F
.x:
add esp, byte 40h	; 854A4
pop ebp	; 854A7
pop esi	; 854A8
ret 4	; 854A9
%endif ; C
; C: src/c/front/announcer/SayOneMinuteLeft.c
%ifdef CBUILD
%include "c/front/announcer/SayOneMinuteLeft.inc"
%else
SayOneMinuteLeft:
push dword 8	; 854AC
call __CHK	; 854B1
push ebx	; 854B6
cmp dword [speechinit], byte 0	; 854B7
jne short .1	; 854BE
xor eax, eax	; 854C0
pop ebx	; 854C2
ret	; 854C3
.1:
call SpeechIdle	; 854C4
test eax, eax	; 854C9
je short .x	; 854CB
call ResetSampleReq	; 854CD
call ResetSpeechQueue	; 854D2
mov eax, str_OneleftCor	; 854D7
call RequestSample	; 854DC
call EnsureSampleRoom	; 854E1
mov eax, str_OneleftCor	; 854E6
call QueueSpeechClip	; 854EB
mov ebx, 1	; 854F0
mov dword [dword_CCC98], ebx	; 854F5
mov eax, dword [speechq]	; 854FB
mov dword [byte eax+060h], ebx	; 85500
mov eax, ebx	; 85503
.x:
pop ebx	; 85505
ret	; 85506
%endif ; C
; C: src/c/front/announcer/OpenAnnouncerBank.c
%ifdef CBUILD
%include "c/front/announcer/OpenAnnouncerBank.inc"
%else
OpenAnnouncerBank:
push dword 20h	; 85507
call __CHK	; 8550C
push ebx	; 85511
push ecx	; 85512
push edx	; 85513
sub esp, byte 10h	; 85514
cmp dword [speechinit], byte 0	; 85517
jne short .1	; 8551E
xor eax, eax	; 85520
jmp short .x	; 85522
.1:
call SpeechIdle	; 85524
test eax, eax	; 85529
je short .x	; 8552B
call ResetSampleReq	; 8552D
call ResetSpeechQueue	; 85532
mov ecx, str_VIV	; 85537
mov ebx, str_XBRUCE2	; 8553C
cmp byte [fileoncd+01C0h], 1	; 85541
jne short .2	; 85548
mov edx, dword [cddriveptr]	; 8554A
jmp short .3	; 85550
.2:
xor edx, edx	; 85552
.3:
mov eax, esp	; 85554
call MakePath	; 85556
xor edx, edx	; 8555B
mov eax, esp	; 8555D
call OpenSpeechBank	; 8555F
mov eax, 1	; 85564
.x:
add esp, byte 10h	; 85569
pop edx	; 8556C
pop ecx	; 8556D
pop ebx	; 8556E
ret	; 8556F
%endif ; C
; C: src/c/front/announcer/QueuePenaltyType.c
%ifdef CBUILD
%include "c/front/announcer/QueuePenaltyType.inc"
%else
QueuePenaltyType:
push dword 28h	; 85570
call __CHK	; 85575
push edx	; 8557A
sub esp, byte 10h	; 8557B
mov eax, dword [speechbank]	; 8557E
mov edx, dword [dword eax+03B68h]	; 85583
sub edx, dword [dword eax+03B6Ch]	; 85589
cmp edx, 186A0h	; 8558F
jbe short .3	; 85595
call ResetSampleReq	; 85597
call ResetSpeechQueue	; 8559C
xor edx, edx	; 855A1
.1:
push str_Num	; 855A3
push edx	; 855A8
push str_DS	; 855A9
lea eax, [byte esp+0Ch]	; 855AE
push eax	; 855B2
call sprintf_	; 855B3
add esp, byte 10h	; 855B8
mov eax, esp	; 855BB
call RequestSample	; 855BD
inc edx	; 855C2
cmp edx, byte 0Ah	; 855C3
jl short QueuePenaltyType.1	; 855C6
xor edx, edx	; 855C8
.2:
push str_Num	; 855CA
push edx	; 855CF
push str_DS	; 855D0
lea eax, [byte esp+0Ch]	; 855D5
push eax	; 855D9
call sprintf_	; 855DA
add esp, byte 10h	; 855DF
mov eax, esp	; 855E2
call QueueSpeechClip	; 855E4
inc edx	; 855E9
cmp edx, byte 0Ah	; 855EA
jl short QueuePenaltyType.2	; 855ED
.3:
mov eax, dword [speechbank]	; 855EF
mov edx, dword [dword eax+03B68h]	; 855F4
sub edx, dword [dword eax+03B6Ch]	; 855FA
cmp edx, 186A0h	; 85600
jbe short .6	; 85606
call ResetSampleReq	; 85608
call ResetSpeechQueue	; 8560D
mov edx, 0Ah	; 85612
.4:
push str_Num	; 85617
push edx	; 8561C
push str_DS	; 8561D
lea eax, [byte esp+0Ch]	; 85622
push eax	; 85626
call sprintf_	; 85627
add esp, byte 10h	; 8562C
mov eax, esp	; 8562F
call RequestSample	; 85631
inc edx	; 85636
cmp edx, byte 14h	; 85637
jl short QueuePenaltyType.4	; 8563A
mov edx, 0Ah	; 8563C
.5:
push str_Num	; 85641
push edx	; 85646
push str_DS	; 85647
lea eax, [byte esp+0Ch]	; 8564C
push eax	; 85650
call sprintf_	; 85651
add esp, byte 10h	; 85656
mov eax, esp	; 85659
call QueueSpeechClip	; 8565B
inc edx	; 85660
cmp edx, byte 14h	; 85661
jl short QueuePenaltyType.5	; 85664
.6:
mov eax, dword [speechbank]	; 85666
mov edx, dword [dword eax+03B68h]	; 8566B
sub edx, dword [dword eax+03B6Ch]	; 85671
cmp edx, 186A0h	; 85677
jbe short .9	; 8567D
call ResetSampleReq	; 8567F
call ResetSpeechQueue	; 85684
mov edx, 14h	; 85689
.7:
push str_Num	; 8568E
push edx	; 85693
push str_DS	; 85694
lea eax, [byte esp+0Ch]	; 85699
push eax	; 8569D
call sprintf_	; 8569E
add esp, byte 10h	; 856A3
mov eax, esp	; 856A6
call RequestSample	; 856A8
inc edx	; 856AD
cmp edx, byte 1Eh	; 856AE
jl short QueuePenaltyType.7	; 856B1
mov edx, 14h	; 856B3
.8:
push str_Num	; 856B8
push edx	; 856BD
push str_DS	; 856BE
lea eax, [byte esp+0Ch]	; 856C3
push eax	; 856C7
call sprintf_	; 856C8
add esp, byte 10h	; 856CD
mov eax, esp	; 856D0
call QueueSpeechClip	; 856D2
inc edx	; 856D7
cmp edx, byte 1Eh	; 856D8
jl short QueuePenaltyType.8	; 856DB
.9:
mov eax, dword [speechbank]	; 856DD
mov edx, dword [dword eax+03B68h]	; 856E2
sub edx, dword [dword eax+03B6Ch]	; 856E8
cmp edx, 186A0h	; 856EE
jbe short .12	; 856F4
call ResetSampleReq	; 856F6
call ResetSpeechQueue	; 856FB
xor edx, edx	; 85700
.10:
push str_Num	; 85702
push edx	; 85707
push str_02dS	; 85708
lea eax, [byte esp+0Ch]	; 8570D
push eax	; 85711
call sprintf_	; 85712
add esp, byte 10h	; 85717
mov eax, esp	; 8571A
call RequestSample	; 8571C
inc edx	; 85721
cmp edx, byte 0Ah	; 85722
jl short QueuePenaltyType.10	; 85725
xor edx, edx	; 85727
.11:
push str_Num	; 85729
push edx	; 8572E
push str_02dS	; 8572F
lea eax, [byte esp+0Ch]	; 85734
push eax	; 85738
call sprintf_	; 85739
add esp, byte 10h	; 8573E
mov eax, esp	; 85741
call QueueSpeechClip	; 85743
inc edx	; 85748
cmp edx, byte 0Ah	; 85749
jl short QueuePenaltyType.11	; 8574C
.12:
mov eax, dword [speechbank]	; 8574E
mov edx, dword [dword eax+03B68h]	; 85753
sub edx, dword [dword eax+03B6Ch]	; 85759
cmp edx, 249F0h	; 8575F
jbe short .x	; 85765
call ResetSampleReq	; 85767
call ResetSpeechQueue	; 8576C
xor edx, edx	; 85771
.13:
mov eax, dword [nosplit edx*4+penaltyclips]	; 85773
call RequestSample	; 8577A
inc edx	; 8577F
cmp edx, byte 0Eh	; 85780
jl short QueuePenaltyType.13	; 85783
xor edx, edx	; 85785
.14:
mov eax, dword [nosplit edx*4+penaltyclips]	; 85787
call QueueSpeechClip	; 8578E
inc edx	; 85793
cmp edx, byte 0Eh	; 85794
jl short QueuePenaltyType.14	; 85797
.x:
add esp, byte 10h	; 85799
pop edx	; 8579C
ret	; 8579D
%endif ; C
; C: src/c/front/announcer/PreloadAnnouncerClips.c
%ifdef CBUILD
%include "c/front/announcer/PreloadAnnouncerClips.inc"
%else
PreloadAnnouncerClips:
push dword 54h	; 8579E
call __CHK	; 857A3
push ebx	; 857A8
push ecx	; 857A9
push esi	; 857AA
push edi	; 857AB
sub esp, byte 30h	; 857AC
mov esi, eax	; 857AF
mov edi, edx	; 857B1
cmp dword [speechinit], byte 0	; 857B3
jne short .1	; 857BA
xor eax, eax	; 857BC
jmp near .x	; 857BE
.1:
call SpeechIdle	; 857C3
test eax, eax	; 857C8
je near .x	; 857CA
call ResetSampleReq	; 857D0
call ResetSpeechQueue	; 857D5
mov ecx, str_VIV	; 857DA
mov ebx, str_XBRUCE2	; 857DF
cmp byte [fileoncd+01C0h], 1	; 857E4
jne short .2	; 857EB
mov edx, dword [cddriveptr]	; 857ED
jmp short .3	; 857F3
.2:
xor edx, edx	; 857F5
.3:
mov eax, esp	; 857F7
call MakePath	; 857F9
mov edx, 1Ah	; 857FE
mov eax, esp	; 85803
call OpenSpeechBank	; 85805
push str_Tea	; 8580A
push esi	; 8580F
push str_SS5	; 85810
lea eax, [byte esp+02Ch]	; 85815
push eax	; 85819
call sprintf_	; 8581A
add esp, byte 10h	; 8581F
push str_Tea	; 85822
push edi	; 85827
push str_SS5	; 85828
lea eax, [byte esp+01Ch]	; 8582D
push eax	; 85831
call sprintf_	; 85832
add esp, byte 10h	; 85837
mov eax, str_OneleftCor	; 8583A
call RequestSample	; 8583F
mov eax, str_PauseCor	; 85844
call RequestSample	; 85849
lea eax, [byte esp+020h]	; 8584E
call RequestSample	; 85852
lea eax, [byte esp+010h]	; 85857
call RequestSample	; 8585B
mov eax, str_GoalnumCor	; 85860
call RequestSample	; 85865
mov eax, str_AsstnumCor	; 8586A
call RequestSample	; 8586F
mov eax, str_AndnumCor	; 85874
call RequestSample	; 85879
mov eax, str_PennumCor	; 8587E
call RequestSample	; 85883
mov eax, str_PensnumCor	; 85888
call RequestSample	; 8588D
mov eax, str_2minCor	; 85892
call RequestSample	; 85897
mov eax, str_AtCor	; 8589C
call RequestSample	; 858A1
mov eax, str_OneleftCor	; 858A6
call QueueSpeechClip	; 858AB
mov eax, str_PauseCor	; 858B0
call QueueSpeechClip	; 858B5
lea eax, [byte esp+020h]	; 858BA
call QueueSpeechClip	; 858BE
lea eax, [byte esp+010h]	; 858C3
call QueueSpeechClip	; 858C7
mov eax, str_GoalnumCor	; 858CC
call QueueSpeechClip	; 858D1
mov eax, str_AsstnumCor	; 858D6
call QueueSpeechClip	; 858DB
mov eax, str_AndnumCor	; 858E0
call QueueSpeechClip	; 858E5
mov eax, str_PennumCor	; 858EA
call QueueSpeechClip	; 858EF
mov eax, str_PensnumCor	; 858F4
call QueueSpeechClip	; 858F9
mov eax, str_2minCor	; 858FE
call QueueSpeechClip	; 85903
mov eax, str_AtCor	; 85908
call QueueSpeechClip	; 8590D
call QueuePenaltyType	; 85912
mov eax, 1	; 85917
.x:
add esp, byte 30h	; 8591C
pop edi	; 8591F
pop esi	; 85920
pop ecx	; 85921
pop ebx	; 85922
ret	; 85923
%endif ; C
