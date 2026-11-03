; Choosing a sound card: the dialog, and writing that choice to NHL.CFG.
bits 32
%include "hockey.inc"
section s_82579 progbits alloc exec nowrite align=1
extern __CHK, __STOSD, acptspr, asc_C36C3, byte_C541B, byte_D2439, byte_DC9D8, byte_DC9DD
extern byte_DC9DF, byte_DC9E8, byte_DC9E9, byte_DC9EB, byte_DC9EC, byte_DC9EE, byte_DCA21, byte_DCA28
extern byte_DCA29, byte_DCA38, byte_DCAD3, byte_DCAD4, byte_DCAD5, byte_DCAD6, cddriveptr, chkoffspr
extern chkonspr, ClearInputQueue, cont2team, ctl1side, ctl1team, ctl2side, ctl2team, DrawSelBoxOff
extern DrawSelBoxOn, dword_C4CFC, dword_CCC94, dword_D20E0, dword_D2150, dword_D223C, dword_D22DC, dword_D22E0
extern dword_D22EC, dword_D22F0, dword_D2350, dword_D2423, dword_D2427, dword_D242B, dword_D2435, dword_D27B2
extern dword_ED7A4, dword_ED7A8, FadeOutPalCycle, FadePalStep, FatalError, fclose_, fdlg_cancel, fileoncd
extern fopen_, fprintf_, fputchar, FreeMemBlock, gamemode, gameopts, GetInputEvent, homebckspr
extern homenamebckspr, HomeTeam, InitSpeech, kaufmfont, lockerrects, mainfont, MakePath, MessageBox
extern modesetlabel, MouseSetPos, msg_InitMT32, musichandle, musicon, musicslot, na01spr, na03spr
extern na05spr, off_CECFF, off_CED3F, off_D21C0, off_D2230, pg01spr, pg03spr, pg05spr
extern pg07spr, pl05spr, pl10spr, pl20spr, PlayDigiSample, pointerspr, PrintOutlinedText, PrintShadowText
extern ptrupdatefn, RestoreDialogBg, s1font, setbits, SetDialogColors, SetTextColors, SetTickDeadline, settingsfile
extern ShowLoadingScreen, ShutdownSpeech, ShutdownSpeech_ret5, sndcardname, songdata, soundcardrects, sounddev, sounddevids
extern speechbank, speechinit, speechq, sprintf_, str_00002, str_Accept, str_Acpt, str_ADLib
extern str_ADLIB, str_Adlib, str_Buffer, str_Canc, str_Cancel2, str_CantOpenNhlCfg, str_CFG, str_Dbx2
extern str_Emmcopybuf, str_Exhibition2, str_ExhibitionGame, str_HomeBck, str_HomeNameBck, str_HomeTeam, str_Iff11, str_Iff12
extern str_Jersey, str_JERSH, str_JERSV, str_LAAtMTL, str_League2, str_Lockroom, str_Maindesk2, str_MT32
extern str_MT322, str_MT323, str_MT32HOCK, str_Na01, str_Na03, str_Na05, str_NHL3, str_Off
extern str_On, str_P01, str_PC, str_PCBEEP, str_PCBEEP2, str_PCSpeaker, str_Pg01, str_Pg03
extern str_Pg05, str_Pg07, str_Pl05, str_Pl10, str_Pl20, str_Playoff, str_PlayoffTree2, str_Pointer20
extern str_Pointer21, str_Return, str_Room, str_SBDAC, str_SBDAC2, str_Settings, str_Settings3, str_ShowLeague
extern str_Slapshot, str_Sound4, str_SoundBlaster, str_SoundBlaster2, str_SportsCentral2, str_Temp8, str_TitleBck, str_UltraSound
extern str_ULTRASOUND, str_VisBck, str_VisitingTeam, str_VisNameBck, str_Vs, strcpy_, strncpy_, sub_8CCA8
extern sub_8D2F0, sub_8E83C, sub_8E9C0, sub_8E9E8, sub_8EA00, sub_8EA18, sub_8EB5B, sub_8EB93
extern sub_8ECC0, sub_8F13B, sub_8F1FE, sub_8F98F, sub_8FB8E, sub_8FBE5, sub_8FC37, sub_8FC8A
extern sub_8FCDF, sub_8FFB0, sub_903F0, sub_90D20, sub_910E0, sub_91284, sub_912C8, sub_91370
extern sub_91400, sub_91964, sub_91FE0, sub_97079, sub_B2DCA, sub_B30B4, sub_B4B88, sub_B4BA8
extern sub_B4DD4, sub_B4FAC, sub_B5DB0, teamcitynames, teamdivflags, titlebckspr, unk_C36AC, unk_D2403
extern unk_D2413, unk_D249C, visbckspr, visnamebckspr, VisTeam, WaitDigiSample, WaitTickDeadline, WriteCurModeState
global MenuSoundSettings, DrawSoundCardDlg, DrawSoundCardOpts, SoundCardHitTest, RedrawSoundCardOpts, SoundCardDlgLoop, SoundCardDlgLoop_poll, SoundCardDlgLoop_next
global SoundCardDlg_epilogue, SoundCardDlgLoop_x, SetSoundDevice
; C: src/c/pc/sound_config/MenuSoundSettings.c
%ifdef CBUILD
%include "c/pc/sound_config/MenuSoundSettings.inc"
%else
MenuSoundSettings:
push dword 24h	; 82579
call __CHK	; 8257E
push ebx	; 82583
push ecx	; 82584
push esi	; 82585
push edi	; 82586
push ebp	; 82587
cmp byte [musicon], 0	; 82588
je short .1	; 8258F
cmp dword [songdata], byte 0	; 82591
jne short .2	; 82598
.1:
push byte 0	; 8259A
push dword 4E200h	; 8259C
push str_Temp8	; 825A1
call sub_8CCA8	; 825A6
add esp, byte 0Ch	; 825AB
mov dword [dword_D2435], eax	; 825AE
.2:
push byte 0	; 825B3
push dword 5F11h	; 825B5
push str_Buffer	; 825BA
call sub_8CCA8	; 825BF
mov ebp, eax	; 825C4
add esp, byte 0Ch	; 825C6
mov esi, dword [pointerspr]	; 825C9
mov edi, eax	; 825CF
movsd	; 825D1
movsd	; 825D2
movsd	; 825D3
movsd	; 825D4
movsb	; 825D5
mov word [byte eax+04h], 80h	; 825D6
mov word [byte eax+06h], 0BEh	; 825DC
push byte 13h	; 825E2
push byte 0Ah	; 825E4
push eax	; 825E6
call sub_91400	; 825E7
add esp, byte 0Ch	; 825EC
call DrawSoundCardDlg	; 825EF
call DrawSoundCardOpts	; 825F4
call SoundCardDlgLoop	; 825F9
push byte 13h	; 825FE
push byte 0Ah	; 82600
push ebp	; 82602
call sub_903F0	; 82603
add esp, byte 0Ch	; 82608
push ebp	; 8260B
call FreeMemBlock	; 8260C
add esp, byte 4	; 82611
xor eax, eax	; 82614
pop ebp	; 82616
pop edi	; 82617
pop esi	; 82618
pop ecx	; 82619
pop ebx	; 8261A
ret	; 8261B
%endif ; C
; C: src/c/pc/sound_config/DrawSoundCardDlg.c
%ifdef CBUILD
%include "c/pc/sound_config/DrawSoundCardDlg.inc"
%else
DrawSoundCardDlg:
push dword 40h	; 8261C
call __CHK	; 82621
push ebx	; 82626
push ecx	; 82627
push edx	; 82628
push esi	; 82629
sub esp, byte 20h	; 8262A
call sub_B4BA8	; 8262D
xor ecx, ecx	; 82632
mov ebx, str_Sound4	; 82634
cmp byte [fileoncd+0191h], 1	; 82639
jne short .1	; 82640
mov edx, dword [cddriveptr]	; 82642
jmp short .2	; 82648
.1:
xor edx, edx	; 8264A
.2:
mov eax, esp	; 8264C
call MakePath	; 8264E
push byte 0	; 82653
lea eax, [byte esp+04h]	; 82655
push eax	; 82659
call sub_8E83C	; 8265A
mov esi, eax	; 8265F
add esp, byte 8	; 82661
push byte 13h	; 82664
push byte 0Ah	; 82666
push str_Dbx2	; 82668
push eax	; 8266D
call sub_B30B4	; 8266E
add esp, byte 8	; 82673
push eax	; 82676
call sub_91284	; 82677
add esp, byte 0Ch	; 8267C
push esi	; 8267F
call FreeMemBlock	; 82680
add esp, byte 4	; 82685
add esp, byte 20h	; 82688
pop esi	; 8268B
pop edx	; 8268C
pop ecx	; 8268D
pop ebx	; 8268E
ret	; 8268F
%endif ; C
; C: src/c/pc/sound_config/DrawSoundCardOpts.c
%ifdef CBUILD
%include "c/pc/sound_config/DrawSoundCardOpts.inc"
%else
DrawSoundCardOpts:
push dword 20h	; 82690
call __CHK	; 82695
push ebx	; 8269A
push ecx	; 8269B
push edx	; 8269C
push esi	; 8269D
mov eax, dword [sounddev]	; 8269E
mov dword [setbits], eax	; 826A3
xor edx, edx	; 826A8
.1:
mov cl, dl	; 826AA
mov esi, 1	; 826AC
shl esi, cl	; 826B1
mov eax, edx	; 826B3
shl eax, 4	; 826B5
add eax, soundcardrects	; 826B8
test dword [setbits], esi	; 826BD
je short .2	; 826C3
call DrawSelBoxOn	; 826C5
jmp short .3	; 826CA
.2:
call DrawSelBoxOff	; 826CC
.3:
inc edx	; 826D1
cmp edx, byte 8	; 826D2
jl short DrawSoundCardOpts.1	; 826D5
mov esi, soundcardrects	; 826D7
push dword 0FFh	; 826DC
push dword 0F8h	; 826E1
call sub_8E9C0	; 826E6
add esp, byte 8	; 826EB
test byte [byte_C541B], 1	; 826EE
jne short .4	; 826F5
mov eax, dword [soundcardrects+4]	; 826F7
add eax, byte 13h	; 826FC
push eax	; 826FF
mov eax, dword [soundcardrects]	; 82700
add eax, byte 18h	; 82705
push eax	; 82708
push str_PCSpeaker	; 82709
call sub_91964	; 8270E
add esp, byte 0Ch	; 82713
.4:
add esi, byte 10h	; 82716
test byte [byte_C541B], 2	; 82719
jne short .5	; 82720
mov eax, dword [byte esi+04h]	; 82722
add eax, byte 13h	; 82725
push eax	; 82728
mov eax, dword [esi]	; 82729
add eax, byte 0Eh	; 8272B
push eax	; 8272E
push str_SoundBlaster	; 8272F
call sub_91964	; 82734
add esp, byte 0Ch	; 82739
.5:
add esi, byte 10h	; 8273C
test byte [byte_C541B], 4	; 8273F
jne short .6	; 82746
mov eax, dword [byte esi+04h]	; 82748
add eax, byte 13h	; 8274B
push eax	; 8274E
mov eax, dword [esi]	; 8274F
add eax, byte 29h	; 82751
push eax	; 82754
push str_ADLib	; 82755
call sub_91964	; 8275A
add esp, byte 0Ch	; 8275F
.6:
add esi, byte 10h	; 82762
test byte [byte_C541B], 8	; 82765
jne short .7	; 8276C
mov eax, dword [byte esi+04h]	; 8276E
add eax, byte 13h	; 82771
push eax	; 82774
mov eax, dword [esi]	; 82775
add eax, byte 28h	; 82777
push eax	; 8277A
push str_MT32	; 8277B
call sub_91964	; 82780
add esp, byte 0Ch	; 82785
.7:
add esi, byte 20h	; 82788
test byte [byte_C541B], 20h	; 8278B
jne short .x	; 82792
mov eax, dword [byte esi+04h]	; 82794
add eax, byte 13h	; 82797
push eax	; 8279A
mov eax, dword [esi]	; 8279B
add eax, byte 18h	; 8279D
push eax	; 827A0
push str_UltraSound	; 827A1
call sub_91964	; 827A6
add esp, byte 0Ch	; 827AB
.x:
pop esi	; 827AE
pop edx	; 827AF
pop ecx	; 827B0
pop ebx	; 827B1
ret	; 827B2
%endif ; C
; C: src/c/pc/sound_config/SoundCardHitTest.c
%ifdef CBUILD
%include "c/pc/sound_config/SoundCardHitTest.inc"
%else
SoundCardHitTest:
push dword 0Ch	; 827B3
call __CHK	; 827B8
push ecx	; 827BD
push esi	; 827BE
mov ecx, eax	; 827BF
mov esi, edx	; 827C1
xor edx, edx	; 827C3
lea ecx, [byte eax-06h]	; 827C5
sub esi, byte 13h	; 827C8
.1:
mov eax, edx	; 827CB
shl eax, 4	; 827CD
cmp ecx, dword [dword eax+soundcardrects]	; 827D0
jl short .2	; 827D6
cmp ecx, dword [dword eax+soundcardrects+8]	; 827D8
jg short .2	; 827DE
cmp esi, dword [dword eax+soundcardrects+4]	; 827E0
jl short .2	; 827E6
cmp esi, dword [dword eax+soundcardrects+0Ch]	; 827E8
jg short .2	; 827EE
mov dword [ebx], edx	; 827F0
mov eax, 1	; 827F2
pop esi	; 827F7
pop ecx	; 827F8
ret	; 827F9
.2:
inc edx	; 827FA
cmp edx, byte 8	; 827FB
jl short SoundCardHitTest.1	; 827FE
xor eax, eax	; 82800
pop esi	; 82802
pop ecx	; 82803
ret	; 82804
%endif ; C
; C: src/c/pc/sound_config/RedrawSoundCardOpts.c
%ifdef CBUILD
%include "c/pc/sound_config/RedrawSoundCardOpts.inc"
%else
RedrawSoundCardOpts:
push dword 20h	; 82805
call __CHK	; 8280A
push ebx	; 8280F
push ecx	; 82810
push edx	; 82811
push esi	; 82812
xor edx, edx	; 82813
.1:
mov cl, dl	; 82815
mov esi, 1	; 82817
shl esi, cl	; 8281C
mov eax, edx	; 8281E
shl eax, 4	; 82820
add eax, soundcardrects	; 82823
test dword [setbits], esi	; 82828
je short .2	; 8282E
call DrawSelBoxOn	; 82830
jmp short .3	; 82835
.2:
call DrawSelBoxOff	; 82837
.3:
inc edx	; 8283C
cmp edx, byte 8	; 8283D
jl short RedrawSoundCardOpts.1	; 82840
mov esi, soundcardrects	; 82842
push dword 0FFh	; 82847
push dword 0F8h	; 8284C
call sub_8E9C0	; 82851
add esp, byte 8	; 82856
test byte [byte_C541B], 1	; 82859
jne short .4	; 82860
mov eax, dword [soundcardrects+4]	; 82862
add eax, byte 13h	; 82867
push eax	; 8286A
mov eax, dword [soundcardrects]	; 8286B
add eax, byte 18h	; 82870
push eax	; 82873
push str_PCSpeaker	; 82874
call sub_91964	; 82879
add esp, byte 0Ch	; 8287E
.4:
add esi, byte 10h	; 82881
test byte [byte_C541B], 2	; 82884
jne short .5	; 8288B
mov eax, dword [byte esi+04h]	; 8288D
add eax, byte 13h	; 82890
push eax	; 82893
mov eax, dword [esi]	; 82894
add eax, byte 0Eh	; 82896
push eax	; 82899
push str_SoundBlaster	; 8289A
call sub_91964	; 8289F
add esp, byte 0Ch	; 828A4
.5:
add esi, byte 10h	; 828A7
test byte [byte_C541B], 4	; 828AA
jne short .6	; 828B1
mov eax, dword [byte esi+04h]	; 828B3
add eax, byte 13h	; 828B6
push eax	; 828B9
mov eax, dword [esi]	; 828BA
add eax, byte 29h	; 828BC
push eax	; 828BF
push str_ADLib	; 828C0
call sub_91964	; 828C5
add esp, byte 0Ch	; 828CA
.6:
add esi, byte 10h	; 828CD
test byte [byte_C541B], 8	; 828D0
jne short .7	; 828D7
mov eax, dword [byte esi+04h]	; 828D9
add eax, byte 13h	; 828DC
push eax	; 828DF
mov eax, dword [esi]	; 828E0
add eax, byte 28h	; 828E2
push eax	; 828E5
push str_MT32	; 828E6
call sub_91964	; 828EB
add esp, byte 0Ch	; 828F0
.7:
add esi, byte 20h	; 828F3
test byte [byte_C541B], 20h	; 828F6
jne short .x	; 828FD
mov eax, dword [byte esi+04h]	; 828FF
add eax, byte 13h	; 82902
push eax	; 82905
mov eax, dword [esi]	; 82906
add eax, byte 18h	; 82908
push eax	; 8290B
push str_UltraSound	; 8290C
call sub_91964	; 82911
add esp, byte 0Ch	; 82916
.x:
pop esi	; 82919
pop edx	; 8291A
pop ecx	; 8291B
pop ebx	; 8291C
ret	; 8291D
%endif ; C
; C: src/c/pc/sound_config/SoundCardDlgLoop.c
%ifdef CBUILD
%include "c/pc/sound_config/SoundCardDlgLoop.inc"
%else
SoundCardDlgLoop:
push dword 60h	; 8291E
call __CHK	; 82923
push ebx	; 82928
push ecx	; 82929
push edx	; 8292A
push esi	; 8292B
push edi	; 8292C
push ebp	; 8292D
sub esp, byte 38h	; 8292E
mov eax, dword [pointerspr]	; 82931
mov edx, dword [byte eax+02h]	; 82936
sar edx, 10h	; 82939
mov eax, dword [byte eax+04h]	; 8293C
sar eax, 10h	; 8293F
inc eax	; 82942
inc edx	; 82943
imul edx, eax	; 82944
add edx, byte 11h	; 82947
push byte 0	; 8294A
push edx	; 8294C
push str_Pointer21	; 8294D
call sub_8CCA8	; 82952
add esp, byte 0Ch	; 82957
mov ebp, eax	; 8295A
mov esi, dword [pointerspr]	; 8295C
mov edi, eax	; 82962
movsd	; 82964
movsd	; 82965
movsd	; 82966
movsd	; 82967
movsb	; 82968
mov edx, dword [pointerspr]	; 82969
mov dx, word [byte edx+04h]	; 8296F
inc edx	; 82973
mov word [byte eax+04h], dx	; 82974
mov edx, dword [pointerspr]	; 82978
mov dx, word [byte edx+06h]	; 8297E
inc edx	; 82982
mov word [byte eax+06h], dx	; 82983
mov edx, dword [dword_D2435]	; 82987
test edx, edx	; 8298D
je short .1	; 8298F
push edx	; 82991
call FreeMemBlock	; 82992
add esp, byte 4	; 82997
xor ecx, ecx	; 8299A
mov dword [dword_D2435], ecx	; 8299C
.1:
lea eax, [byte esp+030h]	; 829A2
push eax	; 829A6
lea eax, [byte esp+038h]	; 829A7
push eax	; 829AB
lea eax, [byte esp+02Ch]	; 829AC
push eax	; 829B0
call sub_B2DCA	; 829B1
add esp, byte 0Ch	; 829B6
mov eax, dword [byte esp+034h]	; 829B9
mov dword [byte esp+02Ch], eax	; 829BD
mov eax, dword [byte esp+030h]	; 829C1
mov dword [byte esp+028h], eax	; 829C5
call sub_B4BA8	; 829C9
mov esi, dword [byte esp+028h]	; 829CE
push esi	; 829D2
mov eax, dword [byte esp+030h]	; 829D3
sub eax, byte 4	; 829D7
push eax	; 829DA
push ebp	; 829DB
call sub_91400	; 829DC
add esp, byte 0Ch	; 829E1
mov edi, dword [byte esp+028h]	; 829E4
push edi	; 829E8
mov eax, dword [byte esp+030h]	; 829E9
sub eax, byte 4	; 829ED
push eax	; 829F0
mov eax, dword [pointerspr]	; 829F1
push eax	; 829F6
call sub_91370	; 829F7
add esp, byte 0Ch	; 829FC
call ClearInputQueue	; 829FF
.2:
xor edx, edx	; 82A04
mov dword [byte esp+024h], edx	; 82A06
.3:
call GetInputEvent	; 82A0A
test eax, eax	; 82A0F
je short .4	; 82A11
lea ebx, [byte esp+028h]	; 82A13
lea edx, [byte esp+02Ch]	; 82A17
call dword [ptrupdatefn]	; 82A1B
mov dword [byte esp+024h], eax	; 82A21
test al, 6	; 82A25
je short SoundCardDlgLoop.3	; 82A27
.4:
mov ah, byte [byte esp+024h]	; 82A29
test ah, 2	; 82A2D
jne near SoundCardDlgLoop_poll.2	; 82A30
test ah, 4	; 82A36
jne short SoundCardDlgLoop_poll.2	; 82A39
mov eax, dword [byte esp+02Ch]	; 82A3B
cmp eax, dword [byte esp+034h]	; 82A3F
jne short .5	; 82A43
mov eax, dword [byte esp+028h]	; 82A45
cmp eax, dword [byte esp+030h]	; 82A49
je short SoundCardDlgLoop.2	; 82A4D
.5:
mov ebx, dword [byte esp+030h]	; 82A4F
push ebx	; 82A53
mov eax, dword [byte esp+038h]	; 82A54
sub eax, byte 4	; 82A58
SoundCardDlgLoop_poll:
push eax	; 82A5B
push ebp	; 82A5C
call sub_903F0	; 82A5D
add esp, byte 0Ch	; 82A62
mov ecx, dword [byte esp+028h]	; 82A65
push ecx	; 82A69
mov eax, dword [byte esp+030h]	; 82A6A
sub eax, byte 4	; 82A6E
push eax	; 82A71
push ebp	; 82A72
call sub_91400	; 82A73
add esp, byte 0Ch	; 82A78
mov esi, dword [byte esp+028h]	; 82A7B
push esi	; 82A7F
mov eax, dword [byte esp+030h]	; 82A80
sub eax, byte 4	; 82A84
push eax	; 82A87
mov edi, dword [pointerspr]	; 82A88
push edi	; 82A8E
.1:
call sub_91370	; 82A8F
add esp, byte 0Ch	; 82A94
mov eax, dword [byte esp+02Ch]	; 82A97
mov dword [byte esp+034h], eax	; 82A9B
mov eax, dword [byte esp+028h]	; 82A9F
mov dword [byte esp+030h], eax	; 82AA3
jmp near SoundCardDlgLoop.2	; 82AA7
.2:
mov eax, dword [byte esp+034h]	; 82AAC
sub eax, byte 4	; 82AB0
mov dh, byte [byte esp+024h]	; 82AB3
test dh, 2	; 82AB7
je near SoundCardDlgLoop_x	; 82ABA
mov ebx, dword [byte esp+030h]	; 82AC0
push ebx	; 82AC4
push eax	; 82AC5
push ebp	; 82AC6
call sub_903F0	; 82AC7
add esp, byte 0Ch	; 82ACC
lea ebx, [byte esp+020h]	; 82ACF
mov edx, dword [byte esp+028h]	; 82AD3
mov eax, dword [byte esp+02Ch]	; 82AD7
call SoundCardHitTest	; 82ADB
test eax, eax	; 82AE0
je near .20	; 82AE2
mov cl, byte [byte esp+020h]	; 82AE8
mov eax, 1	; 82AEC
shl eax, cl	; 82AF1
mov dword [byte esp+020h], eax	; 82AF3
test dword [setbits], eax	; 82AF7
jne near .20	; 82AFD
test dword [byte_C541B], eax	; 82B03
je near .20	; 82B09
cmp eax, byte 10h	; 82B0F
jb short .5	; 82B12
jbe short .7	; 82B14
cmp eax, byte 40h	; 82B16
jb short .3	; 82B19
jbe short .8	; 82B1B
cmp eax, 80h	; 82B1D
je near .21	; 82B22
jmp near .19	; 82B28
.3:
cmp eax, byte 20h	; 82B2D
.4:
je short .7	; 82B30
jmp near .19	; 82B32
.5:
cmp eax, byte 4	; 82B37
jb short .6	; 82B3A
jbe short .7	; 82B3C
cmp eax, byte 8	; 82B3E
jmp short SoundCardDlgLoop_poll.4	; 82B41
.6:
cmp eax, byte 1	; 82B43
jb near .19	; 82B46
cmp eax, byte 2	; 82B4C
ja near .19	; 82B4F
.7:
mov eax, dword [byte esp+020h]	; 82B55
mov dword [setbits], eax	; 82B59
jmp near .19	; 82B5E
.8:
mov eax, unk_D2403	; 82B63
call DrawSelBoxOn	; 82B68
push dword 0F7h	; 82B6D
mov ecx, 0FAh	; 82B72
mov ebx, 0F8h	; 82B77
mov edx, ecx	; 82B7C
mov eax, 0F9h	; 82B7E
call SetDialogColors	; 82B83
cmp byte [musicon], 0	; 82B88
je short .10	; 82B8F
cmp dword [songdata], byte 0	; 82B91
je short .10	; 82B98
mov eax, dword [musichandle]	; 82B9A
mov ebx, 64h	; 82B9F
mov edx, 3	; 82BA4
call sub_8FCDF	; 82BA9
.9:
mov eax, dword [musicslot-3]	; 82BAE
sar eax, 18h	; 82BB3
mov edx, 3	; 82BB6
call sub_8FC8A	; 82BBB
test eax, eax	; 82BC0
je short SoundCardDlgLoop_poll.9	; 82BC2
mov eax, dword [songdata]	; 82BC4
push eax	; 82BC9
call sub_8D2F0	; 82BCA
add esp, byte 4	; 82BCF
xor edx, edx	; 82BD2
mov dword [songdata], edx	; 82BD4
.10:
mov eax, dword [setbits]	; 82BDA
call SetSoundDevice	; 82BDF
test eax, eax	; 82BE4
je near .15	; 82BE6
mov eax, dword [setbits]	; 82BEC
mov dword [sounddev], eax	; 82BF1
push ebp	; 82BF6
call FreeMemBlock	; 82BF7
add esp, byte 4	; 82BFC
cmp byte [musicon], 0	; 82BFF
je short .13	; 82C06
cmp dword [songdata], byte 0	; 82C08
jne short .13	; 82C0F
mov ecx, str_Iff12	; 82C11
mov ebx, str_Maindesk2	; 82C16
cmp byte [fileoncd+01DBh], 1	; 82C1B
jne short .11	; 82C22
mov edx, dword [cddriveptr]	; 82C24
jmp short .12	; 82C2A
.11:
xor edx, edx	; 82C2C
.12:
mov eax, esp	; 82C2E
call MakePath	; 82C30
mov eax, esp	; 82C35
call sub_8F98F	; 82C37
mov dword [songdata], eax	; 82C3C
test eax, eax	; 82C41
je short .13	; 82C43
test byte [gameopts], 40h	; 82C45
je short .13	; 82C4C
mov edx, dword [musichandle]	; 82C4E
mov ecx, 4Ch	; 82C54
mov ebx, 3	; 82C59
call sub_8FB8E	; 82C5E
.13:
cmp byte [musicon], 0	; 82C63
je short .14	; 82C6A
or byte [gameopts+1], 1	; 82C6C
jmp near SoundCardDlgLoop_next.1	; 82C73
.14:
and byte [gameopts+1], 0FEh	; 82C78
jmp near SoundCardDlgLoop_next.1	; 82C7F
.15:
mov eax, dword [setbits]	; 82C84
xor dword [byte_C541B], eax	; 82C89
mov eax, dword [sounddev]	; 82C8F
mov dword [setbits], eax	; 82C94
cmp byte [musicon], 0	; 82C99
je short .18	; 82CA0
cmp dword [songdata], byte 0	; 82CA2
jne short .18	; 82CA9
mov ecx, str_Iff12	; 82CAB
mov ebx, str_Maindesk2	; 82CB0
cmp byte [fileoncd+01DBh], 1	; 82CB5
jne short .16	; 82CBC
mov edx, dword [cddriveptr]	; 82CBE
jmp short .17	; 82CC4
.16:
xor edx, edx	; 82CC6
.17:
mov eax, esp	; 82CC8
call MakePath	; 82CCA
mov eax, esp	; 82CCF
call sub_8F98F	; 82CD1
mov dword [songdata], eax	; 82CD6
test eax, eax	; 82CDB
je short .18	; 82CDD
test byte [gameopts], 40h	; 82CDF
je short .18	; 82CE6
mov edx, dword [musichandle]	; 82CE8
mov ecx, 4Ch	; 82CEE
mov ebx, 3	; 82CF3
call sub_8FB8E	; 82CF8
.18:
mov eax, unk_D2403	; 82CFD
call DrawSelBoxOff	; 82D02
.19:
call RedrawSoundCardOpts	; 82D07
.20:
mov edi, dword [byte esp+028h]	; 82D0C
push edi	; 82D10
mov eax, dword [byte esp+030h]	; 82D11
sub eax, byte 4	; 82D15
push eax	; 82D18
push ebp	; 82D19
call sub_91400	; 82D1A
add esp, byte 0Ch	; 82D1F
mov eax, dword [byte esp+028h]	; 82D22
push eax	; 82D26
mov eax, dword [byte esp+030h]	; 82D27
sub eax, byte 4	; 82D2B
push eax	; 82D2E
mov edx, dword [pointerspr]	; 82D2F
push edx	; 82D35
jmp near SoundCardDlgLoop_poll.1	; 82D36
.21:
mov eax, unk_D2413	; 82D3B
call DrawSelBoxOn	; 82D40
SoundCardDlgLoop_next:
push ebp	; 82D45
call FreeMemBlock	; 82D46
add esp, byte 4	; 82D4B
.1:
xor eax, eax	; 82D4E
add esp, byte 38h	; 82D50
SoundCardDlg_epilogue:
pop ebp	; 82D53
pop edi	; 82D54
pop esi	; 82D55
pop edx	; 82D56
pop ecx	; 82D57
pop ebx	; 82D58
ret	; 82D59
SoundCardDlgLoop_x:
test dh, 4	; 82D5A
je short .1	; 82D5D
mov edx, dword [byte esp+030h]	; 82D5F
push edx	; 82D63
push eax	; 82D64
push ebp	; 82D65
call sub_903F0	; 82D66
add esp, byte 0Ch	; 82D6B
jmp short SoundCardDlgLoop_next	; 82D6E
.1:
mov ebx, dword [byte esp+030h]	; 82D70
push ebx	; 82D74
jmp near SoundCardDlgLoop_poll	; 82D75
%endif ; C
; C: src/c/pc/sound_config/SoundCardDlgLoop.c (SetSoundDevice)
%ifdef CBUILD
%include "c/pc/sound_config/SoundCardDlgLoop.SetSoundDevice.inc"
%else
SetSoundDevice:
push dword 74h	; 82D7A
call __CHK	; 82D7F
push ebx	; 82D84
push ecx	; 82D85
push edx	; 82D86
push esi	; 82D87
push edi	; 82D88
push ebp	; 82D89
sub esp, byte 44h	; 82D8A
mov esi, eax	; 82D8D
xor ebp, ebp	; 82D8F
mov dword [byte esp+03Ch], 1	; 82D91
cmp dword [dword_D2423], byte 0	; 82D99
je short .4	; 82DA0
mov ecx, dword [sounddev]	; 82DA2
cmp ecx, byte 2	; 82DA8
je short .1	; 82DAB
cmp ecx, byte 20h	; 82DAD
jne short .2	; 82DB0
.1:
call ShutdownSpeech	; 82DB2
mov edx, dword [dword_ED7A8]	; 82DB7
push edx	; 82DBD
call FreeMemBlock	; 82DBE
add esp, byte 4	; 82DC3
xor ebx, ebx	; 82DC6
mov dword [dword_ED7A8], ebx	; 82DC8
jmp short .3	; 82DCE
.2:
cmp ecx, byte 4	; 82DD0
jne short .3	; 82DD3
mov eax, dword [dword_ED7A4]	; 82DD5
call sub_8F1FE	; 82DDA
.3:
call sub_8EB93	; 82DDF
.4:
mov dword [dword_CCC94], 20h	; 82DE4
xor edi, edi	; 82DEE
mov dword [dword_D2423], edi	; 82DF0
.5:
cmp esi, byte 4	; 82DF6
jb short .6	; 82DF9
jbe near .9	; 82DFB
cmp esi, byte 8	; 82E01
jb near .12	; 82E04
jbe near .10	; 82E0A
cmp esi, byte 20h	; 82E10
je near .11	; 82E13
jmp near .12	; 82E19
.6:
cmp esi, byte 1	; 82E1E
jb near .12	; 82E21
jbe short .7	; 82E27
cmp esi, byte 2	; 82E29
je short .8	; 82E2C
jmp near .12	; 82E2E
.7:
mov edx, str_PCBEEP	; 82E33
lea eax, [byte esp+020h]	; 82E38
call strcpy_	; 82E3C
mov edx, str_PC	; 82E41
lea eax, [byte esp+010h]	; 82E46
call strcpy_	; 82E4A
mov dword [dword_D2427], 1	; 82E4F
mov dword [dword_D242B], 0FFFFFFFFh	; 82E59
xor ch, ch	; 82E63
mov byte [byte_D2439], ch	; 82E65
jmp near .13	; 82E6B
.8:
mov edx, str_SBDAC	; 82E70
lea eax, [byte esp+020h]	; 82E75
call strcpy_	; 82E79
mov edx, str_PC	; 82E7E
lea eax, [byte esp+010h]	; 82E83
call strcpy_	; 82E87
mov dword [dword_D2427], esi	; 82E8C
mov dword [dword_D242B], 3	; 82E92
mov bh, 1	; 82E9C
mov byte [musicslot], bh	; 82E9E
mov byte [byte_D2439], bh	; 82EA4
jmp near .13	; 82EAA
.9:
mov edx, str_ADLIB	; 82EAF
lea eax, [byte esp+020h]	; 82EB4
call strcpy_	; 82EB8
mov edx, str_PC	; 82EBD
lea eax, [byte esp+010h]	; 82EC2
call strcpy_	; 82EC6
mov dword [dword_D2427], 2	; 82ECB
mov dword [dword_D242B], 0FFFFFFFFh	; 82ED5
xor bl, bl	; 82EDF
mov byte [byte_D2439], bl	; 82EE1
jmp near .13	; 82EE7
.10:
mov edx, str_MT322	; 82EEC
lea eax, [byte esp+020h]	; 82EF1
call strcpy_	; 82EF5
mov edx, str_PC	; 82EFA
lea eax, [byte esp+010h]	; 82EFF
call strcpy_	; 82F03
mov dword [dword_D2427], 4	; 82F08
mov dword [dword_D242B], 0FFFFFFFFh	; 82F12
xor dh, dh	; 82F1C
mov byte [byte_D2439], dh	; 82F1E
jmp short .13	; 82F24
.11:
mov edx, str_SBDAC2	; 82F26
lea eax, [byte esp+020h]	; 82F2B
call strcpy_	; 82F2F
mov edx, str_PC	; 82F34
lea eax, [byte esp+010h]	; 82F39
call strcpy_	; 82F3D
mov dword [dword_D2427], 5	; 82F42
mov dword [dword_D242B], 6	; 82F4C
mov ah, 1	; 82F56
mov byte [musicslot], ah	; 82F58
mov byte [byte_D2439], ah	; 82F5E
jmp short .13	; 82F64
.12:
mov edx, str_PCBEEP2	; 82F66
lea eax, [byte esp+020h]	; 82F6B
call strcpy_	; 82F6F
mov edx, str_PC	; 82F74
lea eax, [byte esp+010h]	; 82F79
call strcpy_	; 82F7D
xor eax, eax	; 82F82
mov dword [dword_D2427], eax	; 82F84
mov dword [dword_D242B], 0FFFFFFFFh	; 82F89
xor al, al	; 82F93
mov byte [byte_D2439], al	; 82F95
.13:
call sub_8EB5B	; 82F9A
mov ebx, dword [dword_D2427]	; 82F9F
test ebx, ebx	; 82FA5
jl short .15	; 82FA7
mov eax, ebx	; 82FA9
call sub_97079	; 82FAB
mov ebp, eax	; 82FB0
cmp eax, byte 0FFFFFFFFh	; 82FB2
je short .15	; 82FB5
mov ecx, dword [dword_D242B]	; 82FB7
test ecx, ecx	; 82FBD
jl short .14	; 82FBF
mov eax, ecx	; 82FC1
call sub_97079	; 82FC3
mov dword [byte esp+03Ch], eax	; 82FC8
cmp eax, byte 0FFFFFFFFh	; 82FCC
je short .15	; 82FCF
.14:
mov dword [dword_D2423], 0FFFFFFFFh	; 82FD1
.15:
cmp dword [dword_D2423], byte 0	; 82FDB
je near .29	; 82FE2
lea edx, [byte esp+010h]	; 82FE8
lea eax, [byte esp+020h]	; 82FEC
call sub_8ECC0	; 82FF0
cmp esi, byte 4	; 82FF5
jne short .18	; 82FF8
xor ecx, ecx	; 82FFA
mov ebx, str_Slapshot	; 82FFC
cmp byte [fileoncd+018Fh], 1	; 83001
jne short .16	; 83008
mov edx, dword [cddriveptr]	; 8300A
jmp short .17	; 83010
.16:
xor edx, edx	; 83012
.17:
mov eax, esp	; 83014
call MakePath	; 83016
mov eax, esp	; 8301B
call sub_8F13B	; 8301D
mov dword [dword_ED7A4], eax	; 83022
.18:
cmp esi, byte 8	; 83027
jne near .21	; 8302A
mov ebx, dword [dword_D2350]	; 83030
test ebx, ebx	; 83036
jne near .21	; 83038
push ebx	; 8303E
lea eax, [byte esp+034h]	; 8303F
push eax	; 83043
lea eax, [byte esp+03Ch]	; 83044
push eax	; 83048
push ebx	; 83049
push ebx	; 8304A
mov ecx, 2	; 8304B
mov ebx, msg_InitMT32	; 83050
mov edx, 0FFFFFFFFh	; 83055
mov eax, edx	; 8305A
call MessageBox	; 8305C
xor ecx, ecx	; 83061
mov ebx, str_MT32HOCK	; 83063
cmp byte [fileoncd+0F7h], 1	; 83068
jne short .19	; 8306F
mov edx, dword [cddriveptr]	; 83071
jmp short .20	; 83077
.19:
xor edx, edx	; 83079
.20:
mov eax, esp	; 8307B
call MakePath	; 8307D
mov eax, esp	; 83082
call sub_8F13B	; 83084
mov edx, eax	; 83089
mov dword [dword_D2350], 0FFFFFFFFh	; 8308B
mov dword [sounddev], 8	; 83095
call PlayDigiSample	; 8309F
call WaitDigiSample	; 830A4
mov eax, edx	; 830A9
call sub_8F1FE	; 830AB
call RestoreDialogBg	; 830B0
.21:
mov dword [sounddev], esi	; 830B5
cmp byte [byte_D2439], 0	; 830BB
je short .22	; 830C2
mov eax, dword [byte esp+03Ch]	; 830C4
jmp short .23	; 830C8
.22:
mov eax, ebp	; 830CA
.23:
mov byte [byte_D2439], al	; 830CC
mov al, byte [byte esp+03Ch]	; 830D1
mov byte [musicslot], al	; 830D5
mov eax, dword [sounddev]	; 830DA
mov dword [setbits], eax	; 830DF
mov ecx, str_CFG	; 830E4
mov ebx, str_NHL3	; 830E9
xor edx, edx	; 830EE
mov eax, esp	; 830F0
call MakePath	; 830F2
mov edx, unk_C36AC	; 830F7
mov eax, esp	; 830FC
call fopen_	; 830FE
mov edi, eax	; 83103
test eax, eax	; 83105
jne short .24	; 83107
push str_CantOpenNhlCfg	; 83109
call FatalError	; 8310E
add esp, byte 4	; 83113
.24:
xor eax, eax	; 83116
.25:
cmp esi, dword [nosplit eax*4+sounddevids]	; 83118
je short .26	; 8311F
inc eax	; 83121
jmp short SetSoundDevice.25	; 83122
.26:
push eax	; 83124
push asc_C36C3	; 83125
push edi	; 8312A
call fprintf_	; 8312B
add esp, byte 0Ch	; 83130
mov eax, edi	; 83133
call fclose_	; 83135
mov ecx, dword [sounddev]	; 8313A
cmp ecx, byte 2	; 83140
je short .27	; 83143
cmp ecx, byte 20h	; 83145
jne short .28	; 83148
.27:
mov byte [musicon], 1	; 8314A
mov eax, dword [dword_D242B]	; 83151
mov dword [musichandle], eax	; 83156
jmp near .39	; 8315B
.28:
xor bh, bh	; 83160
mov byte [musicon], bh	; 83162
jmp near .39	; 83168
.29:
cmp esi, byte 10h	; 8316D
je near .37	; 83170
cmp esi, byte 1	; 83176
je near .37	; 83179
cmp esi, byte 4	; 8317F
jb short .30	; 83182
jbe short .32	; 83184
cmp esi, byte 8	; 83186
jb short .34	; 83189
jbe short .33	; 8318B
cmp esi, byte 20h	; 8318D
je short .31	; 83190
jmp short .34	; 83192
.30:
cmp esi, byte 2	; 83194
jne short .34	; 83197
mov dword [sndcardname], str_SoundBlaster2	; 83199
jmp short .34	; 831A3
.31:
mov dword [sndcardname], str_ULTRASOUND	; 831A5
jmp short .34	; 831AF
.32:
mov dword [sndcardname], str_Adlib	; 831B1
jmp short .34	; 831BB
.33:
mov dword [sndcardname], str_MT323	; 831BD
.34:
xor edx, edx	; 831C7
mov dword [byte esp+040h], edx	; 831C9
lea eax, [byte esp+030h]	; 831CD
push eax	; 831D1
lea eax, [byte esp+038h]	; 831D2
push eax	; 831D6
lea eax, [byte esp+040h]	; 831D7
push eax	; 831DB
call sub_B2DCA	; 831DC
add esp, byte 0Ch	; 831E1
push byte 0	; 831E4
lea eax, [byte esp+034h]	; 831E6
push eax	; 831EA
lea eax, [byte esp+03Ch]	; 831EB
push eax	; 831EF
push byte 0	; 831F0
push byte 0	; 831F2
mov ecx, 3	; 831F4
mov ebx, unk_D249C	; 831F9
mov edx, 0FFFFFFFFh	; 831FE
mov eax, edx	; 83203
call MessageBox	; 83205
.35:
call GetInputEvent	; 8320A
test eax, eax	; 8320F
je short .36	; 83211
lea ebx, [byte esp+030h]	; 83213
lea edx, [byte esp+034h]	; 83217
call dword [ptrupdatefn]	; 8321B
mov dword [byte esp+040h], eax	; 83221
.36:
test byte [byte esp+040h], 2	; 83225
je short SetSoundDevice.35	; 8322A
call RestoreDialogBg	; 8322C
mov esi, 10h	; 83231
jmp short .38	; 83236
.37:
mov dword [dword_D2423], 0FFFFFFFFh	; 83238
.38:
call sub_8EB93	; 83242
push byte 64h	; 83247
call SetTickDeadline	; 83249
add esp, byte 4	; 8324E
call WaitTickDeadline	; 83251
.39:
cmp dword [dword_D2423], byte 0	; 83256
je near SetSoundDevice.5	; 8325D
mov edx, dword [sounddev]	; 83263
cmp edx, byte 2	; 83269
je short .40	; 8326C
cmp edx, byte 20h	; 8326E
jne short .41	; 83271
.40:
push byte 20h	; 83273
push dword 400h	; 83275
push str_Emmcopybuf	; 8327A
call sub_8CCA8	; 8327F
add esp, byte 0Ch	; 83284
mov dword [dword_ED7A8], eax	; 83287
mov edx, dword [dword_C4CFC]	; 8328C
movzx esi, byte [musicslot]	; 83292
mov ecx, 400h	; 83299
mov ebx, eax	; 8329E
mov eax, esi	; 832A0
call InitSpeech	; 832A2
.41:
xor ecx, ecx	; 832A7
mov dword [dword_CCC94], ecx	; 832A9
mov eax, 1	; 832AF
add esp, byte 44h	; 832B4
jmp near SoundCardDlg_epilogue	; 832B7
%endif ; C
