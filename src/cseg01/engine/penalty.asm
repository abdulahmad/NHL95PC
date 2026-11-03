; Penalties. The time left in the period, calling a penalty, the box, who is released, the power play,
; and the penalty shot (95G engine/penalty95).
bits 32
%include "hockey.inc"
section s_62CD7 progbits alloc exec nowrite align=1
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
extern PlayCrowdSample, PostPenaltyEvent, priolist, puckc, puckstruct, pucktemp1, puckvx, puckvy
extern puckvz, puckx, pucky, puckz, randomd0, RefPen, refsignal, RefStep
extern regd1, regd2, regd3, restorepl, s1font, scor2font, scpflags2, Setplass
extern setplayer, sflags, sflags3, sfx, shotongoal, shotontarget, SortCords, sortobj15
extern sprintf_, str_02d02dSInjury, str_02d02dSPenalty, str_Assists, str_B3, str_B4, str_B5, str_B6
extern str_B7, str_B8, str_DMinutes, str_FmtClockEvent, str_FmtNumFirstLast, str_FmtNumInitialLast, str_FmtNumName, str_FmtNumNameSuffix
extern str_FmtParenD, str_GameMisconduct, str_GoneFor1Period, str_GoneForTheGame, str_PenaltyShot, str_PPTag, str_S8, str_ServedByD
extern str_SHTag, str_ToBeTakenBy, str_Unassisted, strcpy_, strlen_, sub_8EA18, teamabbrevs, textline1
extern textline2, textline3, textline4, textline5, unk_C1B49, unk_C5423, unk_C542E, unk_E9B4C
extern UpdateTextOverlay, vecdist, VisTeam, word_C5428, word_C90D8, word_CBC44, word_CBEC6, word_CC0B0
extern word_CCEF8, word_CD39C, word_DB08A, word_DEE94, word_DF644, word_E9AAE, word_E9B2C, yleader
global GetPeriodTimeRemaining, AddPenalty, AddPenalty2, SetPA, InProgress, InProgress_popebp, InProgress_popx, chkprogress_go
global chkprogress_x, Stop4Pen, checkfornewpen, releasepl, chkatop, updatepentime_ut_chk, updatepentime_ut, updatePPTeamTime
global updatepentime, PenaltyManager, chkprogress, UpdatePowerPlayFlags, ClearPenaltyBuffer, PenGoalStuff, SetupPenaltyShot, ShotLaneOpen
global QuickShotChk, CountShotOnGoal, StartPenaltyShot, EndPenaltyShot
; C: src/c/engine/penalty/GetPeriodTimeRemaining.c
%ifdef CBUILD
%include "c/engine/penalty/GetPeriodTimeRemaining.inc"
%else
GetPeriodTimeRemaining:
push dword 4	; 62CD7
call __CHK	; 62CDC
mov ax, word [gsp]	; 62CE1
shl eax, 0Eh	; 62CE7
add ax, word [PerTimeTotal]	; 62CEA
sub ax, word [gameclock]	; 62CF1
ret	; 62CF8
%endif ; C
; C: src/c/engine/penalty/AddPenalty.c
%ifdef CBUILD
%include "c/engine/penalty/AddPenalty.inc"
%else
AddPenalty:
push dword 8	; 62CF9
call __CHK	; 62CFE
push ebx	; 62D03
mov ebx, eax	; 62D04
test byte [gmode], 1	; 62D06
jne near .x	; 62D0D
cmp word [byte ebx+06Ah], byte 10h	; 62D13
je near .x	; 62D18
cmp dword [penshotlive], byte 0	; 62D1E
jne short .x	; 62D25
cmp dx, byte 6	; 62D27
je short .4	; 62D2B
cmp dx, byte 8	; 62D2D
jne short .1	; 62D31
test byte [gameopts], 2	; 62D33
jmp short .3	; 62D3A
.1:
cmp dx, byte 1Dh	; 62D3C
jne short .2	; 62D40
test byte [gameopts], 8	; 62D42
jmp short .3	; 62D49
.2:
test byte [gameopts], 1	; 62D4B
je short .x	; 62D52
test byte [byte ebx+044h], 40h	; 62D54
setne al	; 62D58
and eax, 0FFh	; 62D5B
cmp byte [dword eax+PBnum], 8	; 62D60
jge short .x	; 62D67
mov eax, ebx	; 62D69
call CanRemovePlayer	; 62D6B
test eax, eax	; 62D70
.3:
je short .x	; 62D72
.4:
movsx edx, dx	; 62D74
mov eax, ebx	; 62D77
call AddPenalty2	; 62D79
.x:
pop ebx	; 62D7E
ret	; 62D7F
%endif ; C
; C: src/c/engine/penalty/AddPenalty2.c
%ifdef CBUILD
%include "c/engine/penalty/AddPenalty2.inc"
%else
AddPenalty2:
push dword 0Ch	; 62D80
call __CHK	; 62D85
push ebx	; 62D8A
push ecx	; 62D8B
mov ebx, eax	; 62D8C
mov ecx, edx	; 62D8E
test byte [sflags], 80h	; 62D90
jne near .x	; 62D97
cmp word [word_CBC44], byte 0	; 62D9D
jne near .x	; 62DA5
cmp dword [penshotstart], byte 0	; 62DAB
jne short .1	; 62DB2
movsx edx, cx	; 62DB4
shl edx, 2	; 62DB7
mov eax, dword [bannermsg-2]	; 62DBA
sar eax, 10h	; 62DBF
cmp eax, dword [dword edx+word_CD39C]	; 62DC2
jge short .1	; 62DC8
mov ax, word [dword edx+word_CD39C]	; 62DCA
mov word [bannermsg], ax	; 62DD1
mov eax, dword [bannermsg-2]	; 62DD7
sar eax, 10h	; 62DDC
cmp eax, byte 0FFFFFFFFh	; 62DDF
je short .1	; 62DE2
cmp word [bannermsg], byte 6	; 62DE4
je short .1	; 62DEC
mov word [bannertimer], 50h	; 62DEE
.1:
cmp cx, byte 7	; 62DF7
jl short .5	; 62DFB
mov ax, word [crowdlevel]	; 62DFD
cmp ax, 320h	; 62E03
jg short .2	; 62E07
mov edx, eax	; 62E09
add edx, 190h	; 62E0B
mov word [crowdlevel], dx	; 62E11
cmp dx, 320h	; 62E18
jle short .2	; 62E1D
mov word [crowdlevel], 320h	; 62E1F
.2:
test byte [byte ebx+044h], 40h	; 62E28
je short .3	; 62E2C
add word [CwdExciteLvl], byte 14h	; 62E2E
mov eax, 7Dh	; 62E36
jmp short .4	; 62E3B
.3:
mov eax, 0A0h	; 62E3D
.4:
call sfx	; 62E42
.5:
xor eax, eax	; 62E47
jmp short .9	; 62E49
.6:
movsx edx, ax	; 62E4B
add edx, edx	; 62E4E
cmp byte [dword edx+PenBuf], 0	; 62E50
jne short .8	; 62E57
mov byte [dword edx+PenBuf], cl	; 62E59
mov al, byte [byte ebx+06Ah]	; 62E5F
mov byte [dword edx+PenBuf_pl], al	; 62E62
movsx eax, cx	; 62E68
cmp byte [dword eax+penmintab], 0	; 62E6B
je short .x	; 62E72
mov ch, byte [byte ebx+045h]	; 62E74
test ch, 10h	; 62E77
jne short .7	; 62E7A
mov ah, ch	; 62E7C
or ah, 10h	; 62E7E
mov byte [byte ebx+045h], ah	; 62E81
pop ecx	; 62E84
pop ebx	; 62E85
ret	; 62E86
.7:
xor al, al	; 62E87
mov byte [dword edx+PenBuf_pl], al	; 62E89
mov byte [dword edx+PenBuf], al	; 62E8F
pop ecx	; 62E95
pop ebx	; 62E96
ret	; 62E97
.8:
inc eax	; 62E98
.9:
cmp ax, 20h	; 62E99
jl short AddPenalty2.6	; 62E9D
.x:
pop ecx	; 62E9F
pop ebx	; 62EA0
ret	; 62EA1
%endif ; C
; C: src/c/engine/penalty/SetPA.c
%ifdef CBUILD
%include "c/engine/penalty/SetPA.inc"
%else
SetPA:
push dword 8	; 62EA2
call __CHK	; 62EA7
push edx	; 62EAC
cmp ax, 5	; 62EAD
je short .x	; 62EB1
cmp ax, 1Ch	; 62EB3
je short .x	; 62EB7
mov word [RefPen], ax	; 62EB9
xor edx, edx	; 62EBF
mov word [RefStep], dx	; 62EC1
cmp ax, 7	; 62EC8
jne short .1	; 62ECC
mov edx, 23h	; 62ECE
jmp short .2	; 62ED3
.1:
mov edx, 20h	; 62ED5
.2:
movsx edx, dx	; 62EDA
mov eax, SortCords+800h	; 62EDD
call assreplace	; 62EE2
.x:
pop edx	; 62EE7
ret	; 62EE8
%endif ; C
InProgress:
push dword 3Ch	; 62EE9
call __CHK	; 62EEE
push ebx	; 62EF3
push ecx	; 62EF4
push edx	; 62EF5
push esi	; 62EF6
push edi	; 62EF7
push ebp	; 62EF8
mov ebp, esp	; 62EF9
sub esp, byte 14h	; 62EFB
cmp word [RefStep], byte 0	; 62EFE
je near .33	; 62F06
call PaSpeechBusy	; 62F0C
test eax, eax	; 62F11
jne near .33	; 62F13
.1:
cmp byte [PenBuf], 0	; 62F19
jne near .8	; 62F20
mov bx, word [ovlseq]	; 62F26
test bx, bx	; 62F2D
je short .2	; 62F30
cmp bx, byte 2	; 62F32
je short .2	; 62F36
cmp word [ovltimer], byte 0	; 62F38
jge near .33	; 62F40
.2:
xor esi, esi	; 62F46
mov edi, hmtmstruct	; 62F48
jmp short .7	; 62F4D
.3:
mov ebx, 6	; 62F4F
mov edx, 1Bh	; 62F54
jmp short .6	; 62F59
.4:
movsx eax, dx	; 62F5B
add eax, eax	; 62F5E
add eax, edi	; 62F60
cmp word [byte eax+07Eh], byte 0	; 62F62
jle short .5	; 62F67
mov cl, byte [byte eax+07Fh]	; 62F69
and cl, 0DFh	; 62F6C
mov byte [byte eax+07Fh], cl	; 62F6F
test cl, 10h	; 62F72
jne short .5	; 62F75
cmp bx, byte 4	; 62F77
jle short .5	; 62F7B
dec ebx	; 62F7D
.5:
dec edx	; 62F7E
.6:
test dx, dx	; 62F7F
jge short InProgress.4	; 62F82
mov word [byte edi+036h], bx	; 62F84
mov edi, awtmstruct	; 62F88
inc esi	; 62F8D
.7:
cmp si, byte 2	; 62F8E
jl short InProgress.3	; 62F92
and byte [gmode], 0FBh	; 62F94
mov eax, dword [puckstruct+1Ah]	; 62F9B
sar eax, 10h	; 62FA0
add eax, puckstruct	; 62FA3
movsx si, byte [byte eax+01Eh]	; 62FA8
cmp si, byte 1Bh	; 62FAD
je near .33	; 62FB1
cmp si, byte 1Ch	; 62FB7
je near .33	; 62FBB
mov edx, 1Bh	; 62FC1
mov eax, puckstruct	; 62FC6
call assreplace	; 62FCB
jmp near .33	; 62FD0
.8:
mov esi, 1	; 62FD5
jmp short .10	; 62FDA
.9:
inc esi	; 62FDC
.10:
movsx eax, si	; 62FDD
cmp byte [nosplit eax*2+PenBuf], 0	; 62FE0
jne short InProgress.9	; 62FE8
dec esi	; 62FEA
movsx eax, si	; 62FEB
add eax, eax	; 62FEE
mov dh, byte [dword eax+PenBuf_pl]	; 62FF0
test dh, 80h	; 62FF6
jne short .11	; 62FF9
mov edx, dword [dword eax+PenBuf_pl-3]	; 62FFB
sar edx, 18h	; 63001
shl edx, 7	; 63004
mov ebx, SortCords	; 63007
add ebx, edx	; 6300C
mov dword [byte ebp-014h], ebx	; 6300E
cmp word [byte ebx+01Ah], byte 0	; 63011
jge near .33	; 63016
xor cl, cl	; 6301C
mov byte [dword eax+PenBuf_pl], cl	; 6301E
mov byte [dword eax+PenBuf], cl	; 63024
jmp near .33	; 6302A
.11:
mov bl, dh	; 6302F
and bl, 7Fh	; 63031
mov byte [dword eax+PenBuf_pl], bl	; 63034
movsx dx, byte [dword eax+PenBuf]	; 6303A
mov word [byte ebp-08h], dx	; 63042
cmp dx, byte 1Ah	; 63046
jne near .13	; 6304A
call StartPenaltyShot	; 63050
mov dx, word [PerTimeTotal]	; 63055
mov cx, word [gameclock]	; 6305C
sub edx, ecx	; 63063
cmp cx, byte 3Ch	; 63065
jge short .12	; 63069
cmp word [clockticks], byte 0	; 6306B
je short .12	; 63073
dec edx	; 63075
.12:
movsx eax, si	; 63076
mov ebx, dword [nosplit eax*2+dword_E9A14]	; 63079
sar ebx, 18h	; 63080
shl ebx, 7	; 63083
mov ecx, SortCords	; 63086
add ecx, ebx	; 6308B
mov dword [byte ebp-014h], ecx	; 6308D
xor bh, bh	; 63090
mov byte [nosplit eax*2+PenBuf_pl], bh	; 63092
mov byte [nosplit eax*2+PenBuf], bh	; 63099
push byte 0	; 630A0
movsx edi, dx	; 630A2
mov ebx, 3Ch	; 630A5
mov eax, edi	; 630AA
mov edx, edi	; 630AC
sar edx, 1Fh	; 630AE
idiv ebx	; 630B1
push edx	; 630B3
mov eax, edi	; 630B4
mov edx, edi	; 630B6
sar edx, 1Fh	; 630B8
idiv ebx	; 630BB
push eax	; 630BD
xor ecx, ecx	; 630BE
mov eax, dword [byte ebp-0Ah]	; 630C0
sar eax, 10h	; 630C3
lea ebx, [byte eax-09h]	; 630C6
mov edx, dword [byte ebp-014h]	; 630C9
mov edx, dword [byte edx+044h]	; 630CC
sar edx, 18h	; 630CF
mov eax, dword [byte ebp-014h]	; 630D2
test byte [byte eax+044h], 40h	; 630D5
setne al	; 630D9
and eax, 0FFh	; 630DC
call PostPenaltyEvent	; 630E1
jmp near .32	; 630E6
.13:
mov edi, dword [byte ebp-0Ah]	; 630EB
sar edi, 10h	; 630EE
movsx dx, byte [dword edi+penmintab]	; 630F1
mov word [byte ebp-010h], dx	; 630F9
test dx, dx	; 630FD
jg near .18	; 63100
jge near .16	; 63106
mov eax, dword [dword eax+PenBuf_pl-3]	; 6310C
sar eax, 18h	; 63112
shl eax, 7	; 63115
mov edx, SortCords	; 63118
add edx, eax	; 6311D
mov dword [byte ebp-014h], edx	; 6311F
mov edi, dword [byte edx+06Ch]	; 63122
mov ebx, dword [byte edx+044h]	; 63125
sar ebx, 18h	; 63128
mov eax, ebx	; 6312B
shl eax, 2	; 6312D
add eax, ebx	; 63130
shl eax, 3	; 63132
sub eax, ebx	; 63135
mov edx, dword [dword edi+tmroster]	; 63137
mov byte [edx+eax], 8	; 6313D
mov eax, dword [byte ebp-014h]	; 63141
mov eax, dword [byte eax+044h]	; 63144
sar eax, 18h	; 63147
mov eax, dword [byte edi+eax*2+tmpdst-2]	; 6314A
sar eax, 10h	; 6314E
cmp eax, byte 0FFFFFFFDh	; 63151
jle short .14	; 63154
mov edx, 1Dh	; 63156
mov eax, dword [byte ebp-014h]	; 6315B
call assreplace	; 6315E
.14:
mov eax, dword [byte ebp-014h]	; 63163
mov eax, dword [byte eax+044h]	; 63166
sar eax, 18h	; 63169
mov word [byte edi+eax*2+07Eh], 0FFFBh	; 6316C
mov dx, word [PerTimeTotal]	; 63173
mov di, word [gameclock]	; 6317A
sub edx, edi	; 63181
cmp di, byte 3Ch	; 63183
jge short .15	; 63187
cmp word [clockticks], byte 0	; 63189
je short .15	; 63191
dec edx	; 63193
.15:
movsx eax, si	; 63194
push eax	; 63197
movsx edi, dx	; 63198
mov ebx, 3Ch	; 6319B
mov eax, edi	; 631A0
mov edx, edi	; 631A2
sar edx, 1Fh	; 631A4
idiv ebx	; 631A7
push edx	; 631A9
mov eax, edi	; 631AA
mov edx, edi	; 631AC
sar edx, 1Fh	; 631AE
idiv ebx	; 631B1
push eax	; 631B3
mov ecx, dword [byte ebp-012h]	; 631B4
sar ecx, 10h	; 631B7
mov eax, dword [byte ebp-0Ah]	; 631BA
sar eax, 10h	; 631BD
lea ebx, [byte eax-09h]	; 631C0
mov edx, dword [byte ebp-014h]	; 631C3
mov edx, dword [byte edx+044h]	; 631C6
sar edx, 18h	; 631C9
mov eax, dword [byte ebp-014h]	; 631CC
test byte [byte eax+044h], 40h	; 631CF
setne al	; 631D3
and eax, 0FFh	; 631D6
call PostPenaltyEvent	; 631DB
movsx eax, si	; 631E0
movsx dx, byte [nosplit eax*2+PenBuf_pl]	; 631E3
mov word [word_C90D8], dx	; 631EC
xor bl, bl	; 631F3
mov byte [nosplit eax*2+PenBuf_pl], bl	; 631F5
mov byte [nosplit eax*2+PenBuf], bl	; 631FC
jmp near .32	; 63203
.16:
movsx dx, bl	; 63208
mov word [word_C90D8], dx	; 6320C
xor dl, dl	; 63213
mov byte [dword eax+PenBuf_pl], dl	; 63215
mov byte [dword eax+PenBuf], dl	; 6321B
test byte [sflags], 80h	; 63221
jne short .17	; 63228
cmp word [word_CBC44], byte 0	; 6322A
je near .32	; 63232
.17:
cmp word [byte ebp-08h], byte 7	; 63238
jne near InProgress.1	; 6323D
jmp near .32	; 63243
.18:
mov eax, dword [dword eax+PenBuf_pl-3]	; 63248
sar eax, 18h	; 6324E
shl eax, 7	; 63251
mov edx, SortCords	; 63254
add edx, eax	; 63259
mov dword [byte ebp-014h], edx	; 6325B
mov edi, dword [byte edx+06Ch]	; 6325E
inc word [byte edi+0Ah]	; 63261
mov eax, dword [byte ebp-010h]	; 63265
add word [byte edi+0Ch], ax	; 63268
movsx ax, byte [byte edx+047h]	; 6326C
mov word [byte ebp-0Ch], ax	; 63271
cmp ax, 19h	; 63275
jge short .19	; 63279
mov edx, dword [byte ebp-0Eh]	; 6327B
sar edx, 10h	; 6327E
shl edx, 4	; 63281
mov eax, dword [dword edi+0E6h]	; 63284
add eax, edx	; 6328A
mov edx, dword [byte ebp-010h]	; 6328C
add word [byte eax+04h], dx	; 6328F
.19:
mov ebx, dword [byte ebp-012h]	; 63293
sar ebx, 10h	; 63296
xor edx, edx	; 63299
mov eax, dword [byte ebp-014h]	; 6329B
mov dl, byte [byte eax+05Eh]	; 6329E
test byte [byte eax+044h], 40h	; 632A1
setne al	; 632A5
xor ah, ah	; 632A8
cwde	; 632AA
call PanelAddPenalty	; 632AB
mov dx, word [PerTimeTotal]	; 632B0
mov cx, word [gameclock]	; 632B7
sub edx, ecx	; 632BE
cmp cx, byte 3Ch	; 632C0
jge short .20	; 632C4
cmp word [clockticks], byte 0	; 632C6
je short .20	; 632CE
dec edx	; 632D0
.20:
movsx eax, si	; 632D1
push eax	; 632D4
movsx ebx, dx	; 632D5
mov ecx, 3Ch	; 632D8
mov eax, ebx	; 632DD
mov edx, ebx	; 632DF
sar edx, 1Fh	; 632E1
idiv ecx	; 632E4
push edx	; 632E6
mov eax, ebx	; 632E7
mov edx, ebx	; 632E9
sar edx, 1Fh	; 632EB
idiv ecx	; 632EE
push eax	; 632F0
mov ecx, dword [byte ebp-012h]	; 632F1
sar ecx, 10h	; 632F4
mov eax, dword [byte ebp-0Ah]	; 632F7
sar eax, 10h	; 632FA
lea ebx, [byte eax-09h]	; 632FD
mov edx, dword [byte ebp-014h]	; 63300
mov edx, dword [byte edx+044h]	; 63303
sar edx, 18h	; 63306
mov eax, dword [byte ebp-014h]	; 63309
test byte [byte eax+044h], 40h	; 6330C
setne byte [byte ebp-04h]	; 63310
xor eax, eax	; 63314
mov al, byte [byte ebp-04h]	; 63316
call PostPenaltyEvent	; 63319
mov ecx, dword [byte ebp-010h]	; 6331E
imul eax, ecx, byte 3Ch	; 63321
mov word [byte ebp-010h], ax	; 63324
cmp ax, 12Ch	; 63328
jne short .21	; 6332C
or byte [byte ebp-0Fh], 40h	; 6332E
.21:
or byte [byte ebp-0Fh], 20h	; 63332
mov eax, dword [byte ebp-0Eh]	; 63336
sar eax, 10h	; 63339
mov eax, dword [byte edi+eax*2+07Ch]	; 6333C
sar eax, 10h	; 63340
cmp eax, byte 0FFFFFFFDh	; 63343
je short .22	; 63346
cmp eax, byte 0FFFFFFFCh	; 63348
jne near .27	; 6334B
.22:
mov eax, dword [dword edi+0F6h]	; 63351
mov dword [byte ebp-014h], eax	; 63357
xor edx, edx	; 6335A
jmp short .25	; 6335C
.23:
mov eax, dword [byte ebp-014h]	; 6335E
cmp word [byte eax+01Ah], byte 0	; 63361
jle short .24	; 63366
mov eax, dword [byte eax+044h]	; 63368
sar eax, 18h	; 6336B
mov eax, dword [byte edi+eax*2+07Ch]	; 6336E
sar eax, 10h	; 63372
cmp eax, byte 0FFFFFFFFh	; 63375
jne short .24	; 63378
mov eax, dword [byte ebp-014h]	; 6337A
test byte [byte eax+045h], 10h	; 6337D
je short .26	; 63381
.24:
inc edx	; 63383
add dword [byte ebp-014h], 80h	; 63384
.25:
cmp dx, byte 6	; 6338B
jl short InProgress.23	; 6338F
.26:
cmp dx, byte 6	; 63391
je near .33	; 63395
mov eax, dword [byte ebp-014h]	; 6339B
movsx ax, byte [byte eax+047h]	; 6339E
mov word [byte ebp-0Ch], ax	; 633A3
movsx eax, si	; 633A7
mov dl, byte [nosplit eax*2+PenBuf_pl]	; 633AA
and dl, 80h	; 633B1
mov ebx, dword [byte ebp-014h]	; 633B4
mov dh, byte [byte ebx+06Ah]	; 633B7
or dl, dh	; 633BA
mov byte [nosplit eax*2+PenBuf_pl], dl	; 633BC
xor eax, eax	; 633C3
mov al, byte [byte ebx+05Eh]	; 633C5
push eax	; 633C8
push str_ServedByD	; 633C9
push textline5	; 633CE
call sprintf_	; 633D3
add esp, byte 0Ch	; 633D8
.27:
mov eax, dword [byte ebp-0Eh]	; 633DB
sar eax, 10h	; 633DE
add eax, eax	; 633E1
add eax, edi	; 633E3
cmp word [byte eax+07Eh], byte 0	; 633E5
jl short .28	; 633EA
test byte [byte eax+07Fh], 10h	; 633EC
je short .28	; 633F0
or byte [byte ebp-0Fh], 10h	; 633F2
.28:
mov ebx, dword [byte ebp-0Eh]	; 633F6
sar ebx, 10h	; 633F9
mov eax, ebx	; 633FC
mov edx, dword [byte ebp-010h]	; 633FE
mov word [byte edi+eax*2+07Eh], dx	; 63401
shl eax, 2	; 63406
add eax, ebx	; 63409
shl eax, 3	; 6340B
sub eax, ebx	; 6340E
mov edx, dword [dword edi+0EEh]	; 63410
mov byte [edx+eax], 5	; 63416
xor esi, esi	; 6341A
jmp short .30	; 6341C
.29:
movsx eax, si	; 6341E
cmp byte [dword edi+eax+0B6h], 0	; 63421
jl short .31	; 63429
inc esi	; 6342B
.30:
cmp si, byte 1Ch	; 6342C
jl short InProgress.29	; 63430
.31:
movsx eax, si	; 63432
add edi, eax	; 63435
mov al, byte [byte ebp-0Ch]	; 63437
mov byte [dword edi+0B6h], al	; 6343A
mov byte [dword edi+0B7h], 0FFh	; 63440
mov edx, 0Ch	; 63447
mov eax, dword [byte ebp-014h]	; 6344C
call assreplace	; 6344F
mov eax, dword [byte ebp-014h]	; 63454
mov ax, word [byte eax+06Ah]	; 63457
mov word [word_C90D8], ax	; 6345B
.32:
mov eax, dword [byte ebp-0Ah]	; 63461
sar eax, 10h	; 63464
call SetPA	; 63467
.33:
mov esp, ebp	; 6346C
InProgress_popebp:
pop ebp	; 6346E
InProgress_popx:
pop edi	; 6346F
pop esi	; 63470
pop edx	; 63471
pop ecx	; 63472
pop ebx	; 63473
ret	; 63474
; C: src/c/engine/penalty/InProgress.c (chkprogress_go)
%ifdef CBUILD
%include "c/engine/penalty/InProgress.chkprogress_go.inc"
%else
chkprogress_go:
mov di, word [refsignal]	; 63475
dec edi	; 6347C
mov word [refsignal], di	; 6347D
test di, di	; 63484
jge short .1	; 63487
xor edx, edx	; 63489
mov word [refsignal], dx	; 6348B
.1:
mov bx, word [Pencntdwn]	; 63492
dec ebx	; 63499
mov word [Pencntdwn], bx	; 6349A
test bx, bx	; 634A1
jge near chkprogress_x	; 634A4
and byte [gmode], 0F7h	; 634AA
xor esi, esi	; 634B1
mov word [refsignal], si	; 634B3
xor eax, eax	; 634BA
.2:
movsx edx, ax	; 634BC
inc eax	; 634BF
cmp byte [nosplit edx*2+PenBuf], 0	; 634C0
je short chkprogress_x	; 634C8
movsx edx, ax	; 634CA
mov edx, dword [nosplit edx*2+PenBuf_m5]	; 634CD
sar edx, 18h	; 634D4
cmp byte [dword edx+penmintab], 0	; 634D7
je short chkprogress_go.2	; 634DE
or byte [gmode2], 4	; 634E0
mov edi, 0FFFFFFFFh	; 634E7
mov word [word_CC0B0], di	; 634EC
mov word [word_CBC44], 1	; 634F3
mov edx, dword [puckc]	; 634FC
mov byte [edx], 0FFh	; 63502
mov edx, 1Ah	; 63505
mov eax, puckstruct	; 6350A
call assinsert	; 6350F
mov word [pucktemp1], 1C20h	; 63514
mov byte [RefStep+1], 0FFh	; 6351D
xor ebx, ebx	; 63524
mov word [refsignal], bx	; 63526
cmp word [bannertimer], byte 0	; 6352D
jne short chkprogress_x	; 63535
mov word [bannermsg], di	; 63537
chkprogress_x:
pop edi	; 6353E
pop esi	; 6353F
pop edx	; 63540
pop ebx	; 63541
ret	; 63542
%endif ; C
; C: src/c/engine/penalty/Stop4Pen.c
%ifdef CBUILD
%include "c/engine/penalty/Stop4Pen.inc"
%else
Stop4Pen:
push dword 0Ch	; 63543
call __CHK	; 63548
push edx	; 6354D
push esi	; 6354E
movsx edx, ax	; 6354F
mov al, byte [nosplit edx*2+PenBuf]	; 63552
mov ah, byte [nosplit edx*2+PenBuf_pl]	; 63559
mov dl, byte [gmode]	; 63560
test dl, 1	; 63566
jne near .23	; 63569
mov dh, dl	; 6356F
or dh, 1	; 63571
mov byte [gmode], dh	; 63574
xor edx, edx	; 6357A
mov word [foy], dx	; 6357C
mov word [fox], dx	; 63583
cmp al, 7	; 6358A
je near .7	; 6358C
mov dx, word [ltx]	; 63592
mov word [fox], dx	; 63599
mov dx, word [lty]	; 635A0
mov word [foy], dx	; 635A7
cmp al, 3	; 635AE
je near .7	; 635B0
cmp al, 1Dh	; 635B6
je near .7	; 635B8
mov edx, dword [puckx]	; 635BE
mov dx, word [edx]	; 635C4
mov word [fox], dx	; 635C7
mov edx, dword [pucky]	; 635CE
mov dx, word [edx]	; 635D4
mov word [foy], dx	; 635D7
cmp al, 8	; 635DE
jne short .4	; 635E0
test dx, dx	; 635E2
jge short .1	; 635E5
mov edx, dword [foy-2]	; 635E7
sar edx, 10h	; 635ED
neg edx	; 635F0
jmp short .2	; 635F2
.1:
mov edx, dword [foy-2]	; 635F4
sar edx, 10h	; 635FA
.2:
cmp edx, byte 4Eh	; 635FD
jge short .7	; 63600
cmp word [foy], byte 0	; 63602
jge short .3	; 6360A
mov edx, 0FFFFFFB2h	; 6360C
jmp short .6	; 63611
.3:
mov edx, 4Eh	; 63613
jmp short .6	; 63618
.4:
cmp al, 6	; 6361A
jne short .7	; 6361C
movsx edx, ah	; 6361E
shl edx, 7	; 63621
add edx, SortCords	; 63624
test byte [byte edx+044h], 80h	; 6362A
je short .5	; 6362E
mov edx, 0FFFFFDA8h	; 63630
jmp short .6	; 63635
.5:
mov edx, 258h	; 63637
.6:
mov word [foy], dx	; 6363C
.7:
cmp dword [penshotstart], byte 0	; 63643
je short .8	; 6364A
mov ax, word [penshotfox]	; 6364C
mov word [fox], ax	; 63652
mov ax, word [penshotfoy]	; 63658
mov word [foy], ax	; 6365E
.8:
cmp word [fox], byte 60h	; 63664
jl short .9	; 6366C
mov word [fox], 60h	; 6366E
jmp short .10	; 63677
.9:
mov edx, dword [fox-2]	; 63679
sar edx, 10h	; 6367F
cmp edx, byte 0FFFFFFA0h	; 63682
jg short .10	; 63685
mov word [fox], 0FFA0h	; 63687
.10:
cmp word [foy], 90h	; 63690
jl short .13	; 63699
cmp word [fox], byte 0	; 6369B
jge short .11	; 636A3
mov edx, 0FFFFFFA0h	; 636A5
jmp short .12	; 636AA
.11:
mov edx, 60h	; 636AC
.12:
mov word [fox], dx	; 636B1
mov word [foy], 0B8h	; 636B8
jmp short .16	; 636C1
.13:
mov edx, dword [foy-2]	; 636C3
sar edx, 10h	; 636C9
cmp edx, 0FFFFFF70h	; 636CC
jg short .16	; 636D2
cmp word [fox], byte 0	; 636D4
jge short .14	; 636DC
mov edx, 0FFFFFFA0h	; 636DE
jmp short .15	; 636E3
.14:
mov edx, 60h	; 636E5
.15:
mov word [fox], dx	; 636EA
mov word [foy], 0FF48h	; 636F1
.16:
xor eax, eax	; 636FA
mov esi, 0FFFFFFC3h	; 636FC
.17:
movsx edx, ax	; 63701
mov dl, byte [nosplit edx*2+PenBuf_pl]	; 63704
and dl, 7Fh	; 6370B
movsx edx, dl	; 6370E
shl edx, 7	; 63711
add edx, SortCords	; 63714
test byte [byte edx+044h], 80h	; 6371A
jne short .19	; 6371E
mov edx, dword [foy-2]	; 63720
sar edx, 10h	; 63726
cmp edx, byte 0FFFFFFB2h	; 63729
jg short .22	; 6372C
mov word [foy], si	; 6372E
cmp word [fox], byte 0	; 63735
jge short .18	; 6373D
mov edx, 0FFFFFF9Ch	; 6373F
jmp short .21	; 63744
.18:
mov edx, 64h	; 63746
jmp short .21	; 6374B
.19:
cmp word [foy], byte 4Eh	; 6374D
jl short .22	; 63755
mov word [foy], 3Dh	; 63757
cmp word [fox], byte 0	; 63760
jge short .20	; 63768
mov edx, 0FFFFFF9Ch	; 6376A
jmp short .21	; 6376F
.20:
mov edx, 64h	; 63771
.21:
mov word [fox], dx	; 63776
.22:
inc eax	; 6377D
movsx edx, ax	; 6377E
cmp byte [nosplit edx*2+PenBuf], 0	; 63781
jne near Stop4Pen.17	; 63789
.23:
xor eax, eax	; 6378F
mov word [Pencntdwn], ax	; 63791
or byte [gmode], 4	; 63797
mov eax, 0A4h	; 6379E
call sfx	; 637A3
mov eax, 5	; 637A8
call SetPA	; 637AD
pop esi	; 637B2
pop edx	; 637B3
ret	; 637B4
%endif ; C
; C: src/c/engine/penalty/checkfornewpen.c
%ifdef CBUILD
%include "c/engine/penalty/checkfornewpen.inc"
%else
checkfornewpen:
push dword 10h	; 637B5
call __CHK	; 637BA
push ebx	; 637BF
push ecx	; 637C0
push edx	; 637C1
test byte [sflags], 80h	; 637C2
jne near .x	; 637C9
mov dx, word [word_CBC44]	; 637CF
test dx, dx	; 637D6
jne near .x	; 637D9
jmp near .11	; 637DF
.1:
mov bh, byte [dword eax+PenBuf_pl]	; 637E4
test byte [gmode], 4	; 637EA
jne near .5	; 637F1
movsx eax, bl	; 637F7
cmp byte [dword eax+penmintab], 0	; 637FA
je short .4	; 63801
mov eax, dword [puckc]	; 63803
mov cl, byte [eax]	; 63808
test cl, cl	; 6380A
jl short .2	; 6380C
cmp cl, 6	; 6380E
setl al	; 63811
mov ecx, eax	; 63814
and ecx, 0FFh	; 63816
cmp bh, 6	; 6381C
setl al	; 6381F
and eax, 0FFh	; 63822
xor eax, ecx	; 63827
je short .3	; 63829
.2:
mov ch, byte [gmode]	; 6382B
test ch, 8	; 63831
jne near .10	; 63834
mov al, ch	; 6383A
or al, 8	; 6383C
mov byte [gmode], al	; 6383E
mov eax, 1Ch	; 63843
call SetPA	; 63848
jmp near .10	; 6384D
.3:
mov word [refsignal], 28h	; 63852
mov eax, dword [bannermsg-2]	; 6385B
sar eax, 10h	; 63860
cmp eax, byte 0FFFFFFFFh	; 63863
je short .4	; 63866
mov word [bannertimer], 50h	; 63868
.4:
movsx eax, dx	; 63871
call Stop4Pen	; 63874
.5:
movsx eax, dx	; 63879
add eax, eax	; 6387C
mov bh, byte [dword eax+PenBuf_pl]	; 6387E
test bh, 80h	; 63884
jne near .10	; 63887
mov cl, bh	; 6388D
or cl, 80h	; 6388F
mov byte [dword eax+PenBuf_pl], cl	; 63892
movsx eax, bl	; 63898
movsx ax, byte [dword eax+pendelaytab]	; 6389B
shl eax, 5	; 638A3
cmp ax, word [Pencntdwn]	; 638A6
jle short .6	; 638AD
mov word [Pencntdwn], ax	; 638AF
.6:
cmp word [word_CBEC6], byte 0	; 638B5
je short .7	; 638BD
mov word [Pencntdwn], 140h	; 638BF
.7:
cmp dword [penshotstart], byte 0	; 638C8
je short .8	; 638CF
cmp bl, 5	; 638D1
jne short .8	; 638D4
movsx ax, byte [byte_C9146]	; 638D6
shl eax, 5	; 638DE
movsx bx, byte [byte_C9111]	; 638E1
shl ebx, 5	; 638E9
mov word [Pencntdwn], bx	; 638EC
jmp short .9	; 638F3
.8:
movsx eax, bl	; 638F5
movsx ax, byte [dword eax+byte_C9142]	; 638F8
shl eax, 5	; 63900
.9:
cmp ax, word [word_CC0B0]	; 63903
jle short .10	; 6390A
mov word [word_CC0B0], ax	; 6390C
.10:
inc edx	; 63912
.11:
movsx eax, dx	; 63913
add eax, eax	; 63916
mov bl, byte [dword eax+PenBuf]	; 63918
test bl, bl	; 6391E
jne near checkfornewpen.1	; 63920
.x:
pop edx	; 63926
pop ecx	; 63927
pop ebx	; 63928
ret	; 63929
%endif ; C
; C: src/c/engine/penalty/releasepl.c
%ifdef CBUILD
%include "c/engine/penalty/releasepl.inc"
%else
releasepl:
push dword 0Ch	; 6392A
call __CHK	; 6392F
push ebx	; 63934
push ecx	; 63935
mov ebx, dword [dword eax+tmsort]	; 63936
.1:
cmp word [byte ebx+01Ah], byte 0	; 6393C
jl short .2	; 63941
add ebx, 80h	; 63943
jmp short releasepl.1	; 63949
.2:
inc word [byte eax+tmap]	; 6394B
or byte [hmtmflags], 1	; 6394F
or byte [awtmflags], 1	; 63956
or byte [byte_DF6E8], 40h	; 6395D
or byte [byte_DF7E8], 40h	; 63964
cmp word [byte eax+tmgoalie], byte 0	; 6396B
setl cl	; 63970
and ecx, 0FFh	; 63973
mov eax, dword [byte eax+tmap-2]	; 63979
sar eax, 10h	; 6397C
movsx ax, byte [dword ecx+eax+priolist]	; 6397F
mov word [byte ebx+01Ah], ax	; 63988
mov eax, ebx	; 6398C
call Setplass	; 6398E
movsx edx, dx	; 63993
mov eax, ebx	; 63996
call setplayer	; 63998
or byte [byte ebx+045h], 4	; 6399D
pop ecx	; 639A1
pop ebx	; 639A2
ret	; 639A3
%endif ; C
; C: src/c/engine/penalty/chkatop.c
%ifdef CBUILD
%include "c/engine/penalty/chkatop.inc"
%else
chkatop:
push dword 8	; 639A4
call __CHK	; 639A9
push edx	; 639AE
test byte [gmode], 10h	; 639AF
jne short .x	; 639B6
mov eax, dword [pucky]	; 639B8
mov dx, word [eax]	; 639BD
cmp dx, byte 4Eh	; 639C0
jle short .1	; 639C4
xor eax, eax	; 639C6
jmp short .2	; 639C8
.1:
movsx eax, dx	; 639CA
cmp eax, byte 0FFFFFFB2h	; 639CD
jge short .x	; 639D0
mov eax, 1	; 639D2
.2:
test byte [gmode], 2	; 639D7
je short .3	; 639DE
xor al, 1	; 639E0
.3:
test ax, ax	; 639E2
jle short .4	; 639E5
mov eax, awtmstruct	; 639E7
jmp short .5	; 639EC
.4:
mov eax, hmtmstruct	; 639EE
.5:
inc word [byte eax+tmATOP]	; 639F3
.x:
pop edx	; 639F7
ret	; 639F8
%endif ; C
; C: src/c/engine/penalty/updatepentime_ut_chk.c
%ifdef CBUILD
%include "c/engine/penalty/updatepentime_ut_chk.inc"
%else
updatepentime_ut_chk:
push dword 0Ch	; 639F9
call __CHK	; 639FE
push ebx	; 63A03
push ecx	; 63A04
mov ebx, eax	; 63A05
movsx edx, dx	; 63A07
lea eax, [edx+edx]	; 63A0A
add eax, ebx	; 63A0D
mov cx, word [byte eax+tmpdst]	; 63A0F
and ch, 3Fh	; 63A13
cmp cx, byte 5	; 63A16
jg short .x	; 63A1A
cmp word [byte eax+tmpdst], byte 0	; 63A1C
jne short .1	; 63A21
mov eax, ebx	; 63A23
call releasepl	; 63A25
.1:
mov eax, 97h	; 63A2A
call sfx	; 63A2F
.x:
pop ecx	; 63A34
pop ebx	; 63A35
ret	; 63A36
%endif ; C
; C: src/c/engine/penalty/InProgress.c (updatepentime_ut)
%ifdef CBUILD
%include "c/engine/penalty/InProgress.updatepentime_ut.inc"
%else
updatepentime_ut:
push dword 1Ch	; 63A37
call __CHK	; 63A3C
push ebx	; 63A41
push ecx	; 63A42
push edx	; 63A43
push esi	; 63A44
push edi	; 63A45
sub esp, byte 4	; 63A46
mov ecx, eax	; 63A49
mov edx, 2	; 63A4B
mov dword [regd1], edx	; 63A50
mov ebx, edx	; 63A56
mov dword [regd3], edx	; 63A58
xor edi, edi	; 63A5E
xor ebx, edx	; 63A60
jmp near .5	; 63A62
.1:
movsx eax, bx	; 63A67
movsx ax, byte [dword ecx+eax+tmpbox]	; 63A6A
test ax, ax	; 63A73
jl near .6	; 63A76
mov dx, word [regd1]	; 63A7C
dec edx	; 63A83
mov word [regd1], dx	; 63A84
test dx, dx	; 63A8B
jl short .4	; 63A8E
movsx edx, di	; 63A90
mov byte [esp+edx], al	; 63A93
movsx esi, ax	; 63A96
lea eax, [esi+esi]	; 63A99
inc edi	; 63A9C
add eax, ecx	; 63A9D
mov dx, word [byte eax+tmpdst]	; 63A9F
dec edx	; 63AA3
mov word [byte eax+tmpdst], dx	; 63AA4
test dx, 3FFFh	; 63AA8
jne short .4	; 63AAD
mov edx, esi	; 63AAF
shl edx, 2	; 63AB1
add edx, esi	; 63AB4
shl edx, 3	; 63AB6
sub edx, esi	; 63AB9
mov esi, edx	; 63ABB
mov edx, dword [dword ecx+tmroster]	; 63ABD
mov byte [edx+esi], 7	; 63AC3
and byte [byte eax+tmpdst+1], 0BFh	; 63AC7
mov word [regd2], 1	; 63ACB
.2:
mov eax, dword [regd2-2]	; 63AD4
sar eax, 10h	; 63AD9
movsx edx, bx	; 63ADC
add eax, edx	; 63ADF
mov dl, byte [dword ecx+eax+tmpbox]	; 63AE1
mov byte [dword ecx+eax+0B5h], dl	; 63AE8
test dl, dl	; 63AEF
jl short .3	; 63AF1
inc word [regd2]	; 63AF3
jmp short updatepentime_ut.2	; 63AFA
.3:
dec ebx	; 63AFC
.4:
inc ebx	; 63AFD
.5:
cmp bx, byte 1Ch	; 63AFE
jl near updatepentime_ut.1	; 63B02
.6:
mov di, word [regd1]	; 63B08
cmp di, byte 1	; 63B0F
jne short .7	; 63B13
mov edx, dword [byte esp-03h]	; 63B15
jmp short .9	; 63B19
.7:
test di, di	; 63B1B
jne short .8	; 63B1E
mov edx, dword [byte esp-03h]	; 63B20
sar edx, 18h	; 63B24
mov eax, ecx	; 63B27
call updatepentime_ut_chk	; 63B29
mov edx, dword [byte esp-02h]	; 63B2E
jmp short .9	; 63B32
.8:
mov eax, dword [regd1-2]	; 63B34
sar eax, 10h	; 63B39
cmp eax, byte 0FFFFFFFFh	; 63B3C
jne short .10	; 63B3F
mov edx, dword [byte esp-02h]	; 63B41
.9:
sar edx, 18h	; 63B45
mov eax, ecx	; 63B48
call updatepentime_ut_chk	; 63B4A
.10:
add esp, byte 4	; 63B4F
jmp near InProgress_popx	; 63B52
%endif ; C
; C: src/c/engine/penalty/updatePPTeamTime.c
%ifdef CBUILD
%include "c/engine/penalty/updatePPTeamTime.inc"
%else
updatePPTeamTime:
push dword 4	; 63B57
call __CHK	; 63B5C
mov ah, byte [gmode2]	; 63B61
test ah, 20h	; 63B67
je short .x	; 63B6A
test ah, 40h	; 63B6C
jne short .1	; 63B6F
mov eax, hmtmstruct	; 63B71
inc word [byte eax+08h]	; 63B76
ret	; 63B7A
.1:
mov eax, awtmstruct	; 63B7B
inc word [byte eax+08h]	; 63B80
.x:
ret	; 63B84
%endif ; C
; C: src/c/engine/penalty/updatepentime.c
%ifdef CBUILD
%include "c/engine/penalty/updatepentime.inc"
%else
updatepentime:
push dword 8	; 63B85
call __CHK	; 63B8A
push edx	; 63B8F
mov ah, byte [sflags3]	; 63B90
and ah, 0BFh	; 63B96
mov byte [sflags3], ah	; 63B99
test byte [gmode], 1	; 63B9F
jne short .x	; 63BA6
cmp dword [penshotlive], byte 0	; 63BA8
jne short .x	; 63BAF
mov dx, word [Penaltytimer]	; 63BB1
dec edx	; 63BB8
mov word [Penaltytimer], dx	; 63BB9
test dx, dx	; 63BC0
jge short .x	; 63BC3
mov dh, ah	; 63BC5
or dh, 40h	; 63BC7
mov byte [sflags3], dh	; 63BCA
add word [Penaltytimer], byte 18h	; 63BD0
call chkatop	; 63BD8
call updatePPTeamTime	; 63BDD
mov eax, hmtmstruct	; 63BE2
call updatepentime_ut	; 63BE7
mov eax, awtmstruct	; 63BEC
call updatepentime_ut	; 63BF1
.x:
pop edx	; 63BF6
ret	; 63BF7
%endif ; C
; C: src/c/engine/penalty/InProgress.c (PenaltyManager)
%ifdef CBUILD
%include "c/engine/penalty/InProgress.PenaltyManager.inc"
%else
PenaltyManager:
push dword 4	; 63BF8
call __CHK	; 63BFD
call updatepentime	; 63C02
call checkfornewpen	; 63C07
chkprogress:
push dword 14h	; 63C0C
call __CHK	; 63C11
push ebx	; 63C16
push edx	; 63C17
push esi	; 63C18
push edi	; 63C19
test byte [gmode], 1	; 63C1A
je near chkprogress_x	; 63C21
call UpdateTextOverlay	; 63C27
mov dx, word [word_CC0B0]	; 63C2C
test dx, dx	; 63C33
jl short .1	; 63C36
mov ebx, edx	; 63C38
dec ebx	; 63C3A
mov word [word_CC0B0], bx	; 63C3B
test bx, bx	; 63C42
jge short .1	; 63C45
or byte [gmode2], 4	; 63C47
.1:
test byte [gmode], 4	; 63C4E
je near chkprogress_x	; 63C55
cmp word [Pencntdwn], byte 0	; 63C5B
jge near chkprogress_go	; 63C63
call InProgress	; 63C69
pop edi	; 63C6E
pop esi	; 63C6F
pop edx	; 63C70
pop ebx	; 63C71
ret	; 63C72
%endif ; C
; C: src/c/engine/penalty/UpdatePowerPlayFlags.c
%ifdef CBUILD
%include "c/engine/penalty/UpdatePowerPlayFlags.inc"
%else
UpdatePowerPlayFlags:
push dword 10h	; 63C73
call __CHK	; 63C78
push ebx	; 63C7D
push ecx	; 63C7E
push edx	; 63C7F
mov eax, awtmstruct	; 63C80
mov dx, word [hmtmap]	; 63C85
mov bx, word [awtmap]	; 63C8C
sub dx, bx	; 63C93
mov ebx, edx	; 63C96
jne short .1	; 63C98
and byte [gmode2], 0DFh	; 63C9A
pop edx	; 63CA1
pop ecx	; 63CA2
pop ebx	; 63CA3
ret	; 63CA4
.1:
mov dx, word [gmode2]	; 63CA5
and dl, 9Fh	; 63CAC
test bx, bx	; 63CAF
jle short .2	; 63CB2
mov eax, hmtmstruct	; 63CB4
test byte [gmode2], 40h	; 63CB9
je short .4	; 63CC0
jmp short .3	; 63CC2
.2:
test byte [gmode2], 40h	; 63CC4
jne short .4	; 63CCB
mov word [gmode2], dx	; 63CCD
or dl, 40h	; 63CD4
.3:
mov word [gmode2], dx	; 63CD7
.4:
mov cl, byte [gmode2]	; 63CDE
test cl, 20h	; 63CE4
jne short .x	; 63CE7
mov ch, cl	; 63CE9
or ch, 20h	; 63CEB
mov byte [gmode2], ch	; 63CEE
inc word [byte eax+04h]	; 63CF4
test byte [gmode], 1	; 63CF8
je short .x	; 63CFF
test byte [gameopts+1], 1	; 63D01
je short .5	; 63D08
cmp byte [musicon], 0	; 63D0A
jne short .6	; 63D11
.5:
mov edx, 1	; 63D13
jmp short .7	; 63D18
.6:
xor edx, edx	; 63D1A
.7:
test edx, edx	; 63D1C
je short .x	; 63D1E
cmp eax, hmtmstruct	; 63D20
jne short .8	; 63D25
mov eax, 1	; 63D27
jmp short .9	; 63D2C
.8:
mov eax, 4	; 63D2E
.9:
call PlayCrowdSample	; 63D33
.x:
pop edx	; 63D38
pop ecx	; 63D39
pop ebx	; 63D3A
ret	; 63D3B
%endif ; C
; C: src/c/engine/penalty/ClearPenaltyBuffer.c
%ifdef CBUILD
%include "c/engine/penalty/ClearPenaltyBuffer.inc"
%else
ClearPenaltyBuffer:
push dword 0Ch	; 63D3C
call __CHK	; 63D41
push ebx	; 63D46
push edx	; 63D47
xor edx, edx	; 63D48
jmp short .2	; 63D4A
.1:
movsx eax, dx	; 63D4C
xor bl, bl	; 63D4F
mov byte [nosplit eax*2+PenBuf_pl], bl	; 63D51
mov byte [nosplit eax*2+PenBuf], bl	; 63D58
inc edx	; 63D5F
.2:
cmp dx, byte 20h	; 63D60
jl short ClearPenaltyBuffer.1	; 63D64
pop edx	; 63D66
pop ebx	; 63D67
ret	; 63D68
%endif ; C
PenGoalStuff:
push dword 20h	; 63D69
call __CHK	; 63D6E
push ebx	; 63D73
push ecx	; 63D74
push edx	; 63D75
push esi	; 63D76
push edi	; 63D77
push ebp	; 63D78
push eax	; 63D79
test ax, ax	; 63D7A
jle short .1	; 63D7D
mov ebp, awtmstruct	; 63D7F
jmp short .2	; 63D84
.1:
mov ebp, hmtmstruct	; 63D86
.2:
cmp word [esp], byte 0	; 63D8B
sete al	; 63D90
and eax, 0FFh	; 63D93
je short .3	; 63D98
mov edi, awtmstruct	; 63D9A
jmp short .4	; 63D9F
.3:
mov edi, hmtmstruct	; 63DA1
.4:
xor eax, eax	; 63DA6
xor ebx, ebx	; 63DA8
jmp near .13	; 63DAA
.5:
cmp word [gsp], byte 3	; 63DAF
jne short .6	; 63DB7
mov dx, word [hmscore]	; 63DB9
cmp dx, word [awscore]	; 63DC0
jne short .7	; 63DC7
.6:
mov edx, 1	; 63DC9
jmp short .8	; 63DCE
.7:
xor edx, edx	; 63DD0
.8:
test edx, edx	; 63DD2
je near .10	; 63DD4
movsx ecx, bx	; 63DDA
add ecx, ecx	; 63DDD
mov edx, dword [dword ecx+PenBuf-3]	; 63DDF
sar edx, 18h	; 63DE5
mov esi, dword [dword edx+penmintab-3]	; 63DE8
sar esi, 18h	; 63DEE
cmp esi, byte 0FFFFFFFFh	; 63DF1
je short .9	; 63DF4
cmp byte [dword edx+penmintab], 5	; 63DF6
je short .9	; 63DFD
cmp byte [dword edx+penmintab], 2	; 63DFF
jne short .10	; 63E06
cmp byte [dword ecx+PenBuf_pl], 6	; 63E08
setl dl	; 63E0F
mov ecx, edx	; 63E12
and ecx, 0FFh	; 63E14
mov edx, dword [byte esp-02h]	; 63E1A
sar edx, 10h	; 63E1E
xor edx, ecx	; 63E21
je short .10	; 63E23
.9:
cmp ax, bx	; 63E25
je short .12	; 63E28
movsx esi, bx	; 63E2A
movsx edx, ax	; 63E2D
mov cl, byte [nosplit esi*2+PenBuf]	; 63E30
mov byte [nosplit edx*2+PenBuf], cl	; 63E37
mov cl, byte [nosplit esi*2+PenBuf_pl]	; 63E3E
mov byte [nosplit edx*2+PenBuf_pl], cl	; 63E45
inc eax	; 63E4C
jmp short .12	; 63E4D
.10:
movsx edx, bx	; 63E4F
add edx, edx	; 63E52
mov cl, byte [dword edx+PenBuf_pl]	; 63E54
test cl, cl	; 63E5A
jl short .11	; 63E5C
cmp cl, 0Ch	; 63E5E
jge short .11	; 63E61
mov edx, dword [dword edx+PenBuf_pl-3]	; 63E63
sar edx, 18h	; 63E69
shl edx, 7	; 63E6C
and byte [dword edx+scpflags2], 0EFh	; 63E6F
.11:
movsx edx, bx	; 63E76
xor ch, ch	; 63E79
mov byte [nosplit edx*2+PenBuf_pl], ch	; 63E7B
mov byte [nosplit edx*2+PenBuf], ch	; 63E82
.12:
inc ebx	; 63E89
.13:
movsx edx, bx	; 63E8A
cmp byte [nosplit edx*2+PenBuf], 0	; 63E8D
jne near PenGoalStuff.5	; 63E95
cmp byte [PenBuf], 0	; 63E9B
jne short .14	; 63EA2
cmp word [bannermsg], byte 6	; 63EA4
jne short .14	; 63EAC
mov word [bannermsg], 0FFFFh	; 63EAE
.14:
mov dx, word [byte ebp+036h]	; 63EB7
cmp dx, word [byte edi+036h]	; 63EBB
jle near .20	; 63EBF
xor ebx, ebx	; 63EC5
jmp short .16	; 63EC7
.15:
movsx edx, bx	; 63EC9
movsx ax, byte [dword edx+edi+0B6h]	; 63ECC
test ax, ax	; 63ED5
jl near .20	; 63ED8
movsx edx, ax	; 63EDE
test byte [byte edi+edx*2+07Fh], 40h	; 63EE1
je short .17	; 63EE6
inc ebx	; 63EE8
.16:
cmp bx, byte 1Ch	; 63EE9
jl short PenGoalStuff.15	; 63EED
.17:
movsx ecx, ax	; 63EEF
mov eax, ecx	; 63EF2
mov word [byte edi+eax*2+07Eh], 0	; 63EF4
mov esi, ecx	; 63EFB
shl esi, 2	; 63EFD
add esi, ecx	; 63F00
shl esi, 3	; 63F02
sub esi, ecx	; 63F05
mov edx, dword [dword edi+0EEh]	; 63F07
mov byte [edx+esi], 7	; 63F0D
mov edx, ecx	; 63F11
mov eax, edi	; 63F13
call releasepl	; 63F15
mov eax, dword [dword edi+0EEh]	; 63F1A
xor edx, edx	; 63F20
mov dl, byte [byte esi+eax+05h]	; 63F22
cmp word [esp], byte 0	; 63F26
sete al	; 63F2B
xor ah, ah	; 63F2E
cwde	; 63F30
call PanelRemovePenalty	; 63F31
mov eax, 1	; 63F36
.18:
movsx edx, ax	; 63F3B
movsx ecx, bx	; 63F3E
add edx, ecx	; 63F41
mov cl, byte [dword edx+edi+0B6h]	; 63F43
mov byte [dword edx+edi+0B5h], cl	; 63F4A
test cl, cl	; 63F51
jl short .19	; 63F53
inc eax	; 63F55
jmp short PenGoalStuff.18	; 63F56
.19:
inc word [byte ebp+02h]	; 63F58
or byte [hmtmflags], 1	; 63F5C
or byte [awtmflags], 1	; 63F63
.20:
add esp, byte 4	; 63F6A
jmp near InProgress_popebp	; 63F6D
; C: src/c/engine/penalty/SetupPenaltyShot.c
%ifdef CBUILD
%include "c/engine/penalty/SetupPenaltyShot.inc"
%else
SetupPenaltyShot:
push dword 10h	; 63F72
call __CHK	; 63F77
push ebx	; 63F7C
push edx	; 63F7D
push esi	; 63F7E
mov ebx, dword [puckvz]	; 63F7F
mov word [ebx], 0	; 63F85
mov ax, word [ebx]	; 63F8A
mov ebx, dword [puckvy]	; 63F8D
mov word [ebx], ax	; 63F93
mov ebx, dword [puckvx]	; 63F96
mov word [ebx], ax	; 63F9C
mov ebx, dword [puckz]	; 63F9F
mov word [ebx], ax	; 63FA5
mov ebx, dword [pucky]	; 63FA8
mov word [ebx], ax	; 63FAE
mov edx, dword [puckx]	; 63FB1
mov word [edx], ax	; 63FB7
mov edx, 18h	; 63FBA
mov eax, puckstruct	; 63FBF
call assreplace	; 63FC4
mov ebx, dword [penshotplayer]	; 63FC9
shl ebx, 7	; 63FCF
add ebx, SortCords	; 63FD2
and byte [byte ebx+pflags2], 0DBh	; 63FD8
and byte [byte ebx+pflags], 0FBh	; 63FDC
mov edx, 2Eh	; 63FE0
mov eax, ebx	; 63FE5
call assinsert	; 63FE7
mov edx, 2Eh	; 63FEC
mov eax, ebx	; 63FF1
call assinsert	; 63FF3
mov edx, 2Eh	; 63FF8
mov eax, ebx	; 63FFD
call assinsert	; 63FFF
mov edx, 2Eh	; 64004
mov eax, ebx	; 64009
call assinsert	; 6400B
mov edx, 2Eh	; 64010
mov eax, ebx	; 64015
call assinsert	; 64017
mov edx, 2Eh	; 6401C
mov eax, ebx	; 64021
call assinsert	; 64023
mov edx, 2Eh	; 64028
mov eax, ebx	; 6402D
call assinsert	; 6402F
mov edx, 2Eh	; 64034
mov eax, ebx	; 64039
call assinsert	; 6403B
cmp dword [penshotteam], byte 0	; 64040
sete al	; 64047
and eax, 0FFh	; 6404A
mov edx, dword [cont1team-2]	; 6404F
sar edx, 10h	; 64055
inc eax	; 64058
cmp edx, eax	; 64059
jne short .1	; 6405B
mov edx, dword [c1playernum-2]	; 6405D
sar edx, 10h	; 64063
cmp edx, byte 0FFFFFFFFh	; 64066
je short .1	; 64069
mov eax, 0FFFFFFFFh	; 6406B
call restorepl	; 64070
mov word [c1playernum], ax	; 64075
.1:
cmp dword [penshotteam], byte 0	; 6407B
sete al	; 64082
xor edx, edx	; 64085
mov dl, al	; 64087
mov eax, dword [cont2team-2]	; 64089
sar eax, 10h	; 6408E
inc edx	; 64091
cmp eax, edx	; 64092
jne short .2	; 64094
mov edx, dword [c2playernum-2]	; 64096
sar edx, 10h	; 6409C
cmp edx, byte 0FFFFFFFFh	; 6409F
je short .2	; 640A2
mov eax, 0FFFFFFFFh	; 640A4
call restorepl	; 640A9
mov word [c2playernum], ax	; 640AE
.2:
mov ebx, dword [byte ebx+06Ch]	; 640B4
mov word [byte ebx+034h], 0FFFFh	; 640B7
mov ax, word [byte ebx+034h]	; 640BD
mov word [byte ebx+032h], ax	; 640C1
mov word [byte ebx+030h], ax	; 640C5
mov edx, dword [puckc]	; 640C9
add word [crowdlevel], byte 64h	; 640CF
mov al, byte [penshotplayer]	; 640D7
mov byte [edx], al	; 640DC
mov esi, 1	; 640DE
mov dword [penshotlive], esi	; 640E3
mov dword [penshotstart], esi	; 640E9
mov dword [penshottimer], 3E8h	; 640EF
call ClearPenaltyBuffer	; 640F9
pop esi	; 640FE
pop edx	; 640FF
pop ebx	; 64100
ret	; 64101
%endif ; C
; C: src/c/engine/penalty/InProgress.c (ShotLaneOpen)
%ifdef CBUILD
%include "c/engine/penalty/InProgress.ShotLaneOpen.inc"
%else
ShotLaneOpen:
push dword 2Ch	; 64102
call __CHK	; 64107
push ebx	; 6410C
push ecx	; 6410D
push edx	; 6410E
push esi	; 6410F
push edi	; 64110
push ebp	; 64111
sub esp, byte 8	; 64112
xor edx, edx	; 64115
mov dword [shotontarget], edx	; 64117
mov eax, dword [puckc]	; 6411D
mov dl, byte [eax]	; 64122
test dl, dl	; 64124
jge short .2	; 64126
.1:
xor eax, eax	; 64128
jmp near .15	; 6412A
.2:
movsx eax, dl	; 6412F
shl eax, 7	; 64132
mov esi, SortCords	; 64135
add esi, eax	; 6413A
mov ebp, dword [byte esi+Ypos]	; 6413C
sar ebp, 10h	; 6413F
mov edi, ebp	; 64142
mov eax, dword [esi]	; 64144
sar eax, 10h	; 64146
test byte [byte esi+pflags], 80h	; 64149
je near .8	; 6414D
test ebp, ebp	; 64153
jl short ShotLaneOpen.1	; 64155
push eax	; 64157
add ebp, byte 4	; 64158
sub edi, 0E8h	; 6415B
push edi	; 64161
call vecdist	; 64162
add esp, byte 8	; 64167
mov dword [byte esp+04h], eax	; 6416A
xor ecx, ecx	; 6416E
mov dword [esp], ecx	; 64170
xor edi, edi	; 64173
cmp word [byte esi+SCnum], byte 6	; 64175
jge short .3	; 6417A
mov eax, 6	; 6417C
jmp short .4	; 64181
.3:
xor eax, eax	; 64183
.4:
shl eax, 7	; 64185
mov esi, SortCords	; 64188
add esi, eax	; 6418D
jmp short .7	; 6418F
.5:
cmp word [byte esi+position], byte 0	; 64191
jle short .6	; 64196
mov edx, dword [esi]	; 64198
sar edx, 10h	; 6419A
mov eax, dword [byte esi+Ypos]	; 6419D
sar eax, 10h	; 641A0
cmp eax, ebp	; 641A3
jg short ShotLaneOpen.1	; 641A5
cmp word [byte esi+Yvel], byte 0	; 641A7
jl short .6	; 641AC
push edx	; 641AE
sub eax, 0E8h	; 641AF
push eax	; 641B4
call vecdist	; 641B5
add esp, byte 8	; 641BA
mov edx, dword [byte esp+04h]	; 641BD
sub edx, dword [esp]	; 641C1
cmp eax, edx	; 641C4
jle near ShotLaneOpen.1	; 641C6
.6:
inc edi	; 641CC
add esi, 80h	; 641CD
.7:
cmp edi, byte 6	; 641D3
jl short ShotLaneOpen.5	; 641D6
jmp near .14	; 641D8
.8:
test ebp, ebp	; 641DD
jg near ShotLaneOpen.1	; 641DF
push eax	; 641E5
sub ebp, byte 4	; 641E6
add edi, 0E8h	; 641E9
push edi	; 641EF
call vecdist	; 641F0
add esp, byte 8	; 641F5
mov dword [byte esp+04h], eax	; 641F8
xor ebx, ebx	; 641FC
mov dword [esp], ebx	; 641FE
xor edi, edi	; 64201
cmp word [byte esi+SCnum], byte 6	; 64203
jge short .9	; 64208
mov eax, 6	; 6420A
jmp short .10	; 6420F
.9:
xor eax, eax	; 64211
.10:
shl eax, 7	; 64213
mov esi, SortCords	; 64216
add esi, eax	; 6421B
jmp short .13	; 6421D
.11:
cmp word [byte esi+position], byte 0	; 6421F
jle short .12	; 64224
mov edx, dword [esi]	; 64226
sar edx, 10h	; 64228
mov eax, dword [byte esi+Ypos]	; 6422B
sar eax, 10h	; 6422E
cmp eax, ebp	; 64231
jl near ShotLaneOpen.1	; 64233
cmp word [byte esi+Yvel], byte 0	; 64239
jg short .12	; 6423E
push edx	; 64240
add eax, 0E8h	; 64241
push eax	; 64246
call vecdist	; 64247
add esp, byte 8	; 6424C
mov edx, dword [byte esp+04h]	; 6424F
sub edx, dword [esp]	; 64253
cmp eax, edx	; 64256
jle near ShotLaneOpen.1	; 64258
.12:
inc edi	; 6425E
add esi, 80h	; 6425F
.13:
cmp edi, byte 6	; 64265
jl short ShotLaneOpen.11	; 64268
.14:
mov esi, 1	; 6426A
mov dword [shotontarget], esi	; 6426F
mov eax, esi	; 64275
.15:
add esp, byte 8	; 64277
jmp near InProgress_popebp	; 6427A
%endif ; C
; C: src/c/engine/penalty/QuickShotChk.c
%ifdef CBUILD
%include "c/engine/penalty/QuickShotChk.inc"
%else
QuickShotChk:
push dword 10h	; 6427F
call __CHK	; 64284
push ebx	; 64289
push edx	; 6428A
push esi	; 6428B
mov edx, eax	; 6428C
test byte [gmode], 10h	; 6428E
jne short .1	; 64295
test byte [gameopts], 1	; 64297
je short .1	; 6429E
mov eax, dword [puckc]	; 642A0
movsx ax, byte [eax]	; 642A5
cmp ax, word [byte edx+SCnum]	; 642A9
jne short .1	; 642AD
cmp dword [shotongoal], byte 0	; 642AF
jne short .2	; 642B6
.1:
xor eax, eax	; 642B8
pop esi	; 642BA
pop edx	; 642BB
pop ebx	; 642BC
ret	; 642BD
.2:
test byte [byte edx+pflags], 80h	; 642BE
je short .3	; 642C2
cmp word [byte edx+Yvel], byte 0	; 642C4
jl short QuickShotChk.1	; 642C9
mov bx, word [byte edx+facedir]	; 642CB
cmp bx, byte 2	; 642CF
jl short .4	; 642D3
cmp bx, byte 6	; 642D5
jg short .4	; 642D9
jmp short QuickShotChk.1	; 642DB
.3:
cmp word [byte edx+Yvel], byte 0	; 642DD
jg short QuickShotChk.1	; 642E2
mov si, word [byte edx+facedir]	; 642E4
cmp si, byte 2	; 642E8
jle short QuickShotChk.1	; 642EC
cmp si, byte 6	; 642EE
jge short QuickShotChk.1	; 642F2
.4:
call ShotLaneOpen	; 642F4
mov eax, dword [shotontarget]	; 642F9
mov dword [shotongoal], eax	; 642FE
test eax, eax	; 64303
je short .x	; 64305
cmp word [byte edx+Ypos+2], byte 0	; 64307
jge short .5	; 6430C
mov eax, dword [byte edx+Ypos]	; 6430E
sar eax, 10h	; 64311
neg eax	; 64314
jmp short .6	; 64316
.5:
mov eax, dword [byte edx+Ypos]	; 64318
sar eax, 10h	; 6431B
.6:
cmp eax, 0E4h	; 6431E
jg short QuickShotChk.1	; 64323
mov eax, dword [byte edx+070h]	; 64325
cmp word [byte eax+tmgoalie], byte 0	; 64328
jl short QuickShotChk.1	; 6432D
mov eax, 1	; 6432F
.x:
pop esi	; 64334
pop edx	; 64335
pop ebx	; 64336
ret	; 64337
%endif ; C
; C: src/c/engine/penalty/CountShotOnGoal.c
%ifdef CBUILD
%include "c/engine/penalty/CountShotOnGoal.inc"
%else
CountShotOnGoal:
push dword 8	; 64338
call __CHK	; 6433D
push edx	; 64342
call ShotLaneOpen	; 64343
mov eax, dword [shotontarget]	; 64348
mov dword [shotongoal], eax	; 6434D
test eax, eax	; 64352
je short .3	; 64354
add word [crowdlevel], byte 64h	; 64356
cmp dword [penshotmode], byte 0	; 6435E
jne short .3	; 64365
mov eax, dword [puckc]	; 64367
cmp byte [eax], 5	; 6436C
setg al	; 6436F
and eax, 0FFh	; 64372
je short .1	; 64377
mov eax, awtmstruct	; 64379
jmp short .2	; 6437E
.1:
mov eax, hmtmstruct	; 64380
.2:
mov edx, 1	; 64385
inc word [byte eax+01Ch]	; 6438A
mov eax, edx	; 6438E
pop edx	; 64390
ret	; 64391
.3:
xor edx, edx	; 64392
mov eax, edx	; 64394
pop edx	; 64396
ret	; 64397
%endif ; C
; C: src/c/engine/penalty/StartPenaltyShot.c
%ifdef CBUILD
%include "c/engine/penalty/StartPenaltyShot.inc"
%else
StartPenaltyShot:
push dword 0Ch	; 64398
call __CHK	; 6439D
push ebx	; 643A2
push esi	; 643A3
cmp dword [penshotmode], byte 0	; 643A4
jne near .x	; 643AB
cmp dword [penshotplayer], byte 5	; 643B1
setg al	; 643B8
and eax, 0FFh	; 643BB
mov dword [penshotteam], eax	; 643C0
test eax, eax	; 643C5
jle short .1	; 643C7
mov eax, awtmstruct	; 643C9
jmp short .2	; 643CE
.1:
mov eax, hmtmstruct	; 643D0
.2:
inc word [byte eax+020h]	; 643D5
mov ebx, 1	; 643D9
mov word [hmtmap], bx	; 643DE
mov word [awtmap], bx	; 643E5
mov eax, dword [penshotplayer]	; 643EC
shl eax, 7	; 643F1
mov eax, dword [dword eax+SortCords+44h]	; 643F4
sar eax, 18h	; 643FA
mov dword [penshotpnum], eax	; 643FD
mov dword [penshotmode], 1	; 64402
mov eax, dword [fox-2]	; 6440C
sar eax, 10h	; 64411
mov dword [penshotfox], eax	; 64414
mov eax, dword [foy-2]	; 64419
sar eax, 10h	; 6441E
mov dword [penshotfoy], eax	; 64421
xor esi, esi	; 64426
mov word [fox], si	; 64428
mov word [foy], si	; 6442F
.x:
pop esi	; 64436
pop ebx	; 64437
ret	; 64438
%endif ; C
; C: src/c/engine/penalty/EndPenaltyShot.c
%ifdef CBUILD
%include "c/engine/penalty/EndPenaltyShot.inc"
%else
EndPenaltyShot:
push dword 0Ch	; 64439
call __CHK	; 6443E
push ecx	; 64443
push edx	; 64444
cmp dword [penshotlive], byte 0	; 64445
je short .x	; 6444C
cmp dword [penshotmode], byte 0	; 6444E
je short .x	; 64455
xor ecx, ecx	; 64457
mov dword [penshotmode], ecx	; 64459
mov dword [penshotlive], ecx	; 6445F
mov dword [penshotplayer], 0FFFFFFFFh	; 64465
mov edx, 5	; 6446F
mov eax, puckstruct	; 64474
call AddPenalty2	; 64479
mov ax, word [penshotfox]	; 6447E
mov word [ltx], ax	; 64484
mov ax, word [penshotfoy]	; 6448A
mov word [lty], ax	; 64490
mov edx, 21h	; 64496
mov eax, SortCords+800h	; 6449B
call assreplace	; 644A0
.x:
pop edx	; 644A5
pop ecx	; 644A6
ret	; 644A7
%endif ; C
