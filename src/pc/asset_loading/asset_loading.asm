; Loading a game. Player photos, rink graphics, and a clean set of game variables.
bits 32
%include "hockey.inc"
section s_13867 progbits alloc exec nowrite align=1
extern __CHK, __STOSB, apl, assinsert, awtmap, bannermsg, bannertimer, BuildDefaultLines
extern byte_E024C, byte_E024D, byte_E024F, byte_E9AC8, byte_E9AD3, cddriveptr, ClearInputQueue, ClearPanelPenalties
extern cont2team, crowdlevel, CrowdNoiseReset, crowdsmooth, curperiod, CwdExciteLvl, deferpending, DrawAwardsSummary
extern DrawHudPanel, dword_C66D0, dword_C66D4, dword_CC0AC, dword_CC0EC, dword_D8C4C, dword_E009C, dword_E9A9E
extern dword_E9AB6, energywarn, exitgame, fadeinpending, FadePalette, FadePalStep, FileClose, fileoncd
extern FileOpenRead, forceteams, fox, foy, frameaccum, FreeMemBlock, gameopts, gameover
extern gsp, hilightfont, hmtmap, HomeTeam, hudhundaccum, inputframes, introskipped, joyq_flush
extern joysampling, joysampling_save, kaufmfont, lastplayer, lcblink, lcblinktime, lcboxon, lcline
extern lcreqchoice, lcrequest, lcsel, lctimer, MakePath, memcpy_, MouseSetPos, musichandle
extern musicon, musicslot, nullsub_2, numshapes, numshpbank, ovlseq, ovlstep, ovltimer
extern pad1dev, pad2dev, passdir, passplayer, passspeed, Penaltytimer, Pencntdwn, penshotlive
extern penshotmode, penshotplayer, penshotstart, photobankf, photobanks, photoptrs, photoptrsf, PickAwardWinners
extern PickAwardWinners_x, PlayDigiSample, puckx, pucky, randomd0, RefPen, refsignal, RefStep
extern regd0, regd1, regd2, regd4, rinkendart, rinkendbank, savedmousex, savedmousey
extern savepal, scrpitch, SetTextColors, SetupTeamLines, shotongoal, shotontarget, shotplayer, ShowAwardScreens
extern songdata, SortCords, sounddev, sprintf_, StartGame, StartPreGame, StopDigiSample, str_0000
extern str_04d, str_Adafan, str_Adawards, str_Awards, str_Awardsi, str_Awasong, str_D00_D49, str_D00D49
extern str_D50_D99, str_D50D99, str_F000149, str_GfxIdList, str_HILIGHT, str_Iff, str_Mtafan, str_Mtawards
extern str_Numshp, str_Pal3, str_Palmem, str_PPV, str_Scrn, str_Summ, str_Titl, str_Trinknd
extern str_VFN, sub_8CCA8, sub_8D2F0, sub_8E83C, sub_8E8A0, sub_8E9C0, sub_8E9E8, sub_8EA00
extern sub_8EA18, sub_8F13B, sub_8F1FE, sub_8F98F, sub_8FB8E, sub_8FC8A, sub_8FCDF, sub_8FFB0
extern sub_9061C, sub_90B80, sub_B30B4, sub_B30BB, sub_B392C, sub_B4BA8, textline1, textline2
extern textline3, textline4, textline5, threat, VisTeam, vtoa, WaitClickTimeout, WaitDigiSample
extern word_C90D8, word_CBC44, word_CBC60, word_CBE8C, word_CBE8E, word_CBEC2, word_CBEC6, word_CC0B0
extern word_DEE94, word_E024E, word_E9A9C, word_E9AA2, word_E9AA4, word_E9AA6, word_E9AAA, word_E9AAE
extern word_E9B2C
global IndexPhotoBank, IndexPhotoBank_x, LoadPhotoBankF, LoadPhotoBankF_x, LoadPlayerPhotos, LoadTransparentRinkEndOverlay, LoadGameGfx, LoadGameGfx_common
global ReloadGameGfx, PlacePlayersAtStart, SetupGame, SetupDemoGame, ResetGameVars, FileExists
; C: src/pc/asset_loading/IndexPhotoBank.c
%ifdef CBUILD
%include "c/pc/asset_loading/IndexPhotoBank.inc"
%else
IndexPhotoBank:
push dword 34h	; 13867
call __CHK	; 1386C
push ebx	; 13871
push ecx	; 13872
push edx	; 13873
push esi	; 13874
push edi	; 13875
push ebp	; 13876
sub esp, byte 0Ch	; 13877
mov ebp, eax	; 1387A
mov esi, eax	; 1387C
shl esi, 2	; 1387E
sub esi, eax	; 13881
shl esi, 3	; 13883
add esi, eax	; 13886
add esi, esi	; 13888
xor edi, edi	; 1388A
.1:
push esi	; 1388C
push str_04d	; 1388D
lea eax, [byte esp+08h]	; 13892
push eax	; 13896
call sprintf_	; 13897
add esp, byte 0Ch	; 1389C
mov eax, esp	; 1389F
push eax	; 138A1
mov edx, dword [nosplit ebp*4+photobanks]	; 138A2
push edx	; 138A9
call sub_B30BB	; 138AA
add esp, byte 8	; 138AF
mov dword [nosplit esi*4+photoptrs], eax	; 138B2
inc esi	; 138B9
cmp esi, 46Eh	; 138BA
jge short .2	; 138C0
inc edi	; 138C2
cmp edi, byte 32h	; 138C3
jl short IndexPhotoBank.1	; 138C6
.2:
add esp, byte 0Ch	; 138C8
pop ebp	; 138CB
IndexPhotoBank_x:
pop edi	; 138CC
pop esi	; 138CD
pop edx	; 138CE
pop ecx	; 138CF
pop ebx	; 138D0
ret	; 138D1
%endif ; C
; C: src/pc/asset_loading/LoadPhotoBankF.c
%ifdef CBUILD
%include "c/pc/asset_loading/LoadPhotoBankF.inc"
%else
LoadPhotoBankF:
push dword 40h	; 138D2
call __CHK	; 138D7
push ebx	; 138DC
push ecx	; 138DD
push edx	; 138DE
push esi	; 138DF
sub esp, byte 20h	; 138E0
mov edx, dword [photobankf]	; 138E3
test edx, edx	; 138E9
jne short LoadPhotoBankF_x	; 138EB
mov ecx, str_PPV	; 138ED
mov ebx, str_F000149	; 138F2
cmp byte [fileoncd+090h], 1	; 138F7
jne short .1	; 138FE
mov edx, dword [cddriveptr]	; 13900
.1:
mov eax, esp	; 13906
call MakePath	; 13908
push byte 20h	; 1390D
lea eax, [byte esp+04h]	; 1390F
push eax	; 13913
call sub_8E8A0	; 13914
add esp, byte 8	; 13919
mov dword [photobankf], eax	; 1391C
xor esi, esi	; 13921
.2:
push esi	; 13923
push str_04d	; 13924
lea eax, [byte esp+018h]	; 13929
push eax	; 1392D
call sprintf_	; 1392E
add esp, byte 0Ch	; 13933
lea eax, [byte esp+010h]	; 13936
push eax	; 1393A
mov ebx, dword [photobankf]	; 1393B
push ebx	; 13941
call sub_B30B4	; 13942
add esp, byte 8	; 13947
mov dword [nosplit esi*4+photoptrsf], eax	; 1394A
inc esi	; 13951
cmp esi, byte 69h	; 13952
jl short LoadPhotoBankF.2	; 13955
LoadPhotoBankF_x:
add esp, byte 20h	; 13957
pop esi	; 1395A
pop edx	; 1395B
pop ecx	; 1395C
pop ebx	; 1395D
ret	; 1395E
%endif ; C
; C: src/pc/asset_loading/LoadPhotoBankF.c (LoadPlayerPhotos)
%ifdef CBUILD
%include "c/pc/asset_loading/LoadPhotoBankF.LoadPlayerPhotos.inc"
%else
LoadPlayerPhotos:
push dword 44h	; 1395F
call __CHK	; 13964
push ebx	; 13969
push ecx	; 1396A
push edx	; 1396B
push esi	; 1396C
sub esp, byte 20h	; 1396D
xor esi, esi	; 13970
.1:
cmp dword [nosplit esi*4+photobanks], byte 0	; 13972
jne near .8	; 1397A
mov eax, esi	; 13980
mov edx, esi	; 13982
sar edx, 1Fh	; 13984
LD sub, eax, edx	; 13987
sar eax, 1	; 13989
mov ebx, eax	; 1398B
mov ecx, 2	; 1398D
mov eax, esi	; 13992
mov edx, esi	; 13994
sar edx, 1Fh	; 13996
idiv ecx	; 13999
mov eax, edx	; 1399B
cmp esi, byte 14h	; 1399D
jl short .3	; 139A0
test edx, edx	; 139A2
je short .2	; 139A4
push ebx	; 139A6
push ebx	; 139A7
push str_D50D99	; 139A8
jmp short .5	; 139AD
.2:
push ebx	; 139AF
push ebx	; 139B0
push str_D00D49	; 139B1
jmp short .5	; 139B6
.3:
test edx, edx	; 139B8
je short .4	; 139BA
push ebx	; 139BC
push ebx	; 139BD
push str_D50_D99	; 139BE
jmp short .5	; 139C3
.4:
push ebx	; 139C5
push ebx	; 139C6
push str_D00_D49	; 139C7
.5:
lea eax, [byte esp+01Ch]	; 139CC
push eax	; 139D0
call sprintf_	; 139D1
add esp, byte 10h	; 139D6
mov ecx, str_PPV	; 139D9
lea ebx, [byte esp+010h]	; 139DE
cmp byte [dword esi+fileoncd], 1	; 139E2
jne short .6	; 139E9
mov edx, dword [cddriveptr]	; 139EB
jmp short .7	; 139F1
.6:
xor edx, edx	; 139F3
.7:
mov eax, esp	; 139F5
call MakePath	; 139F7
push byte 20h	; 139FC
lea eax, [byte esp+04h]	; 139FE
push eax	; 13A02
call sub_8E8A0	; 13A03
mov edx, eax	; 13A08
add esp, byte 8	; 13A0A
mov eax, esi	; 13A0D
mov dword [nosplit esi*4+photobanks], edx	; 13A0F
call IndexPhotoBank	; 13A16
.8:
inc esi	; 13A1B
cmp esi, byte 17h	; 13A1C
jl near LoadPlayerPhotos.1	; 13A1F
call LoadPhotoBankF	; 13A25
jmp near LoadPhotoBankF_x	; 13A2A
%endif ; C
; C: src/pc/asset_loading/LoadTransparentRinkEndOverlay.c
%ifdef CBUILD
%include "c/pc/asset_loading/LoadTransparentRinkEndOverlay.inc"
%else
LoadTransparentRinkEndOverlay:
push dword 28h	; 13A2F
call __CHK	; 13A34
push ebx	; 13A39
push ecx	; 13A3A
push edx	; 13A3B
sub esp, byte 10h	; 13A3C
mov ecx, str_PPV	; 13A3F
mov ebx, str_Trinknd	; 13A44
cmp byte [fileoncd+01AAh], 1	; 13A49
jne short .1	; 13A50
mov edx, dword [cddriveptr]	; 13A52
jmp short .2	; 13A58
.1:
xor edx, edx	; 13A5A
.2:
mov eax, esp	; 13A5C
call MakePath	; 13A5E
push byte 20h	; 13A63
lea eax, [byte esp+04h]	; 13A65
push eax	; 13A69
call sub_8E8A0	; 13A6A
add esp, byte 8	; 13A6F
mov dword [rinkendbank], eax	; 13A72
push str_0000	; 13A77
push eax	; 13A7C
call sub_B30B4	; 13A7D
add esp, byte 8	; 13A82
mov dword [rinkendart], eax	; 13A85
add esp, byte 10h	; 13A8A
pop edx	; 13A8D
pop ecx	; 13A8E
pop ebx	; 13A8F
ret	; 13A90
%endif ; C
; C: src/pc/asset_loading/LoadGameGfx.c
%ifdef CBUILD
%include "c/pc/asset_loading/LoadGameGfx.inc"
%else
LoadGameGfx:
push dword 3Ch	; 13A91
call __CHK	; 13A96
push ebx	; 13A9B
push ecx	; 13A9C
push edx	; 13A9D
push esi	; 13A9E
sub esp, byte 1Ch	; 13A9F
call sub_B4BA8	; 13AA2
mov word [scrpitch], 52h	; 13AA7
mov ecx, str_VFN	; 13AB0
mov ebx, str_HILIGHT	; 13AB5
cmp byte [fileoncd+0A0h], 1	; 13ABA
jne short .1	; 13AC1
mov edx, dword [cddriveptr]	; 13AC3
jmp short .2	; 13AC9
.1:
xor edx, edx	; 13ACB
.2:
mov eax, esp	; 13ACD
call MakePath	; 13ACF
push byte 20h	; 13AD4
lea eax, [byte esp+04h]	; 13AD6
push eax	; 13ADA
call sub_8E8A0	; 13ADB
add esp, byte 8	; 13AE0
mov dword [hilightfont], eax	; 13AE3
mov ecx, str_PPV	; 13AE8
mov ebx, str_Numshp	; 13AED
cmp byte [fileoncd+010Bh], 1	; 13AF2
jne short .3	; 13AF9
mov edx, dword [cddriveptr]	; 13AFB
jmp short .4	; 13B01
.3:
xor edx, edx	; 13B03
.4:
mov eax, esp	; 13B05
call MakePath	; 13B07
push byte 20h	; 13B0C
lea eax, [byte esp+04h]	; 13B0E
push eax	; 13B12
call sub_8E8A0	; 13B13
add esp, byte 8	; 13B18
mov dword [numshpbank], eax	; 13B1B
xor esi, esi	; 13B20
.5:
push esi	; 13B22
push str_04d	; 13B23
lea eax, [byte esp+018h]	; 13B28
push eax	; 13B2C
call sprintf_	; 13B2D
add esp, byte 0Ch	; 13B32
lea eax, [byte esp+010h]	; 13B35
push eax	; 13B39
mov edx, dword [numshpbank]	; 13B3A
push edx	; 13B40
call sub_B30B4	; 13B41
add esp, byte 8	; 13B46
mov dword [nosplit esi*4+numshapes], eax	; 13B49
inc esi	; 13B50
cmp esi, byte 0Ah	; 13B51
jl short LoadGameGfx.5	; 13B54
LoadGameGfx_common:
push dword_D8C4C	; 13B56
push str_GfxIdList	; 13B5B
mov ebx, dword [numshpbank]	; 13B60
push ebx	; 13B66
call sub_90B80	; 13B67
add esp, byte 0Ch	; 13B6C
call ClearPanelPenalties	; 13B6F
call LoadTransparentRinkEndOverlay	; 13B74
push dword 0FFh	; 13B79
push byte 4	; 13B7E
call sub_8E9C0	; 13B80
add esp, byte 8	; 13B85
call LoadPlayerPhotos	; 13B88
call nullsub_2	; 13B8D
mov word [fadeinpending], 1	; 13B92
mov ecx, 1	; 13B9B
mov dword [dword_C66D4], ecx	; 13BA0
mov dword [dword_C66D0], ecx	; 13BA6
add esp, byte 1Ch	; 13BAC
pop esi	; 13BAF
pop edx	; 13BB0
pop ecx	; 13BB1
pop ebx	; 13BB2
ret	; 13BB3
%endif ; C
; C: src/pc/asset_loading/LoadGameGfx.c (ReloadGameGfx)
%ifdef CBUILD
%include "c/pc/asset_loading/LoadGameGfx.ReloadGameGfx.inc"
%else
ReloadGameGfx:
push dword 3Ch	; 13BB4
call __CHK	; 13BB9
push ebx	; 13BBE
push ecx	; 13BBF
push edx	; 13BC0
push esi	; 13BC1
sub esp, byte 1Ch	; 13BC2
mov word [scrpitch], 52h	; 13BC5
mov ecx, str_VFN	; 13BCE
mov ebx, str_HILIGHT	; 13BD3
cmp byte [fileoncd+0A0h], 1	; 13BD8
jne short .1	; 13BDF
mov edx, dword [cddriveptr]	; 13BE1
jmp short .2	; 13BE7
.1:
xor edx, edx	; 13BE9
.2:
mov eax, esp	; 13BEB
call MakePath	; 13BED
push byte 20h	; 13BF2
lea eax, [byte esp+04h]	; 13BF4
push eax	; 13BF8
call sub_8E8A0	; 13BF9
add esp, byte 8	; 13BFE
mov dword [hilightfont], eax	; 13C01
mov ecx, str_PPV	; 13C06
mov ebx, str_Numshp	; 13C0B
cmp byte [fileoncd+010Bh], 1	; 13C10
jne short .3	; 13C17
mov edx, dword [cddriveptr]	; 13C19
jmp short .4	; 13C1F
.3:
xor edx, edx	; 13C21
.4:
mov eax, esp	; 13C23
call MakePath	; 13C25
push byte 20h	; 13C2A
lea eax, [byte esp+04h]	; 13C2C
push eax	; 13C30
call sub_8E8A0	; 13C31
add esp, byte 8	; 13C36
mov dword [numshpbank], eax	; 13C39
xor esi, esi	; 13C3E
.5:
push esi	; 13C40
push str_04d	; 13C41
lea eax, [byte esp+018h]	; 13C46
push eax	; 13C4A
call sprintf_	; 13C4B
add esp, byte 0Ch	; 13C50
lea eax, [byte esp+010h]	; 13C53
push eax	; 13C57
mov edx, dword [numshpbank]	; 13C58
push edx	; 13C5E
call sub_B30B4	; 13C5F
add esp, byte 8	; 13C64
mov dword [nosplit esi*4+numshapes], eax	; 13C67
inc esi	; 13C6E
cmp esi, byte 0Ah	; 13C6F
jl short ReloadGameGfx.5	; 13C72
jmp near LoadGameGfx_common	; 13C74
%endif ; C
PlacePlayersAtStart:
push dword 10h	; 13C79
call __CHK	; 13C7E
push ebx	; 13C83
push ecx	; 13C84
push edx	; 13C85
cmp dword [dword_CC0EC], byte 0	; 13C86
jne near .x	; 13C8D
call forceteams	; 13C93
xor edx, edx	; 13C98
mov word [foy], dx	; 13C9A
mov word [fox], dx	; 13CA1
mov eax, dword [pucky]	; 13CA8
mov word [eax], dx	; 13CAD
mov eax, dword [puckx]	; 13CB0
mov word [eax], dx	; 13CB5
mov ebx, SortCords	; 13CB8
mov word [regd2], 0Ch	; 13CBD
.1:
mov word [byte ebx+02Eh], 0FF9Ch	; 13CC6
mov ax, word [byte ebx+01Ah]	; 13CCC
mov word [regd1], ax	; 13CD0
cmp ax, 4	; 13CD6
sete al	; 13CDA
and eax, 0FFh	; 13CDD
add eax, byte 16h	; 13CE2
movsx edx, ax	; 13CE5
mov eax, ebx	; 13CE8
call assinsert	; 13CEA
cmp word [regd1], byte 0	; 13CEF
jl near .11	; 13CF7
test byte [byte ebx+044h], 40h	; 13CFD
je short .2	; 13D01
mov ax, word [awtmap]	; 13D03
jmp short .3	; 13D09
.2:
mov ax, word [hmtmap]	; 13D0B
.3:
neg eax	; 13D11
mov word [regd4], ax	; 13D13
mov ax, word [regd4]	; 13D19
add eax, 6	; 13D1F
shl eax, 3	; 13D24
mov word [regd4], ax	; 13D27
mov edx, dword [regd4-2]	; 13D2D
sar edx, 10h	; 13D33
mov eax, dword [regd1-2]	; 13D36
sar eax, 10h	; 13D3B
movsx ax, byte [dword edx+eax+apl]	; 13D3E
mov word [regd4], ax	; 13D47
add eax, eax	; 13D4D
mov word [regd4], ax	; 13D4F
mov eax, dword [regd4-2]	; 13D55
sar eax, 10h	; 13D5A
mov dx, word [nosplit eax*2+word_CBE8C]	; 13D5D
mov word [regd0], dx	; 13D65
mov ax, word [nosplit eax*2+word_CBE8E]	; 13D6C
mov word [regd1], ax	; 13D74
test byte [byte ebx+044h], 80h	; 13D7A
jne short .4	; 13D7E
neg word [regd0]	; 13D80
neg word [regd1]	; 13D87
.4:
mov ax, word [regd0]	; 13D8E
mov word [byte ebx+02h], ax	; 13D94
mov ax, word [regd1]	; 13D98
mov word [byte ebx+06h], ax	; 13D9E
mov word [byte ebx+0Eh], 0	; 13DA2
mov ax, word [byte ebx+0Eh]	; 13DA8
mov word [byte ebx+0Ch], ax	; 13DAC
mov eax, dword [pucky]	; 13DB0
mov ax, word [eax]	; 13DB5
sub ax, word [regd1]	; 13DB8
movsx edx, ax	; 13DBF
mov eax, dword [puckx]	; 13DC2
mov ax, word [eax]	; 13DC7
sub ax, word [regd0]	; 13DCA
cwde	; 13DD1
call vtoa	; 13DD2
mov word [byte ebx+036h], ax	; 13DD7
cmp word [byte ebx+01Ah], byte 0	; 13DDB
jne short .7	; 13DE0
cmp byte [byte ebx+065h], 0	; 13DE2
je short .5	; 13DE6
mov eax, dword [byte ebx+034h]	; 13DE8
sar eax, 10h	; 13DEB
jmp short .6	; 13DEE
.5:
mov eax, dword [byte ebx+034h]	; 13DF0
sar eax, 10h	; 13DF3
mov edx, 8	; 13DF6
sub edx, eax	; 13DFB
mov eax, edx	; 13DFD
and eax, byte 7	; 13DFF
.6:
mov edx, eax	; 13E02
shl eax, 2	; 13E04
sub eax, edx	; 13E07
add eax, 196h	; 13E09
mov word [byte ebx+012h], ax	; 13E0E
mov word [regd1], 1	; 13E12
jmp short .10	; 13E1B
.7:
cmp byte [byte ebx+065h], 0	; 13E1D
je short .8	; 13E21
mov eax, dword [byte ebx+034h]	; 13E23
sar eax, 10h	; 13E26
jmp short .9	; 13E29
.8:
mov eax, dword [byte ebx+034h]	; 13E2B
sar eax, 10h	; 13E2E
mov edx, 8	; 13E31
sub edx, eax	; 13E36
mov eax, edx	; 13E38
and eax, byte 7	; 13E3A
.9:
mov edx, eax	; 13E3D
shl eax, 2	; 13E3F
add eax, edx	; 13E42
mov word [byte ebx+012h], ax	; 13E44
mov word [regd1], 289h	; 13E48
.10:
and byte [byte ebx+045h], 0FBh	; 13E51
and byte [byte ebx+044h], 0DFh	; 13E55
mov word [byte ebx+03Ah], 0	; 13E59
mov ax, word [regd1]	; 13E5F
mov word [byte ebx+038h], ax	; 13E65
mov word [byte ebx+03Ch], 0FFFFh	; 13E69
.11:
add ebx, 80h	; 13E6F
mov cx, word [regd2]	; 13E75
dec cx	; 13E7C
mov word [regd2], cx	; 13E7E
jne near PlacePlayersAtStart.1	; 13E85
.x:
pop edx	; 13E8B
pop ecx	; 13E8C
pop ebx	; 13E8D
ret	; 13E8E
; C: src/pc/asset_loading/SetupGame.c
%ifdef CBUILD
%include "c/pc/asset_loading/SetupGame.inc"
%else
SetupGame:
push dword 20h	; 13E8F
call __CHK	; 13E94
push ebx	; 13E99
push ecx	; 13E9A
push edx	; 13E9B
push edi	; 13E9C
call BuildDefaultLines	; 13E9D
xor eax, eax	; 13EA2
call SetupTeamLines	; 13EA4
mov eax, 1	; 13EA9
call SetupTeamLines	; 13EAE
mov word [gsp], 0FFFFh	; 13EB3
xor ebx, ebx	; 13EBC
mov word [crowdlevel], bx	; 13EBE
call CrowdNoiseReset	; 13EC5
xor edx, edx	; 13ECA
mov dword [introskipped], edx	; 13ECC
call ResetGameVars	; 13ED2
mov edx, dword [VisTeam-2]	; 13ED7
sar edx, 10h	; 13EDD
mov eax, dword [HomeTeam-2]	; 13EE0
sar eax, 10h	; 13EE5
mov ecx, 1	; 13EE8
mov ebx, ecx	; 13EED
call DrawHudPanel	; 13EEF
xor ecx, ecx	; 13EF4
mov word [crowdlevel], cx	; 13EF6
xor ebx, ebx	; 13EFD
mov dword [crowdsmooth], ebx	; 13EFF
xor edx, edx	; 13F05
xor eax, eax	; 13F07
call StartPreGame	; 13F09
test eax, eax	; 13F0E
jge short .1	; 13F10
mov eax, 0FFFFFFFFh	; 13F12
pop edi	; 13F17
pop edx	; 13F18
pop ecx	; 13F19
pop ebx	; 13F1A
ret	; 13F1B
.1:
mov edx, dword [introskipped]	; 13F1C
test edx, edx	; 13F22
je short .2	; 13F24
mov word [fadeinpending], 1	; 13F26
.2:
xor edi, edi	; 13F2F
mov word [gsp], di	; 13F31
call ResetGameVars	; 13F38
mov dword [introskipped], edx	; 13F3D
test edx, edx	; 13F43
je short .3	; 13F45
push savepal	; 13F47
push dword 100h	; 13F4C
push byte 0	; 13F51
call sub_8FFB0	; 13F53
add esp, byte 0Ch	; 13F58
mov ebx, 10h	; 13F5B
mov edx, savepal	; 13F60
mov eax, 1	; 13F65
call FadePalette	; 13F6A
.3:
test byte [gameopts], 4	; 13F6F
jne short .4	; 13F76
cmp dword [introskipped], byte 0	; 13F78
jne short .5	; 13F7F
.4:
call PlacePlayersAtStart	; 13F81
.5:
cmp dword [dword_CC0EC], byte 0	; 13F86
jne short .6	; 13F8D
cmp dword [introskipped], byte 0	; 13F8F
jne short .6	; 13F96
xor eax, eax	; 13F98
mov word [fadeinpending], ax	; 13F9A
.6:
xor eax, eax	; 13FA0
pop edi	; 13FA2
pop edx	; 13FA3
pop ecx	; 13FA4
pop ebx	; 13FA5
ret	; 13FA6
%endif ; C
; C: src/pc/asset_loading/SetupDemoGame.c
%ifdef CBUILD
%include "c/pc/asset_loading/SetupDemoGame.inc"
%else
SetupDemoGame:
push dword 14h	; 13FA7
call __CHK	; 13FAC
push ebx	; 13FB1
push ecx	; 13FB2
push edx	; 13FB3
push edi	; 13FB4
call BuildDefaultLines	; 13FB5
xor eax, eax	; 13FBA
call SetupTeamLines	; 13FBC
mov eax, 1	; 13FC1
call SetupTeamLines	; 13FC6
mov word [gsp], 0FFFFh	; 13FCB
xor ebx, ebx	; 13FD4
mov word [crowdlevel], bx	; 13FD6
call CrowdNoiseReset	; 13FDD
xor edx, edx	; 13FE2
mov dword [introskipped], edx	; 13FE4
call ResetGameVars	; 13FEA
xor ecx, ecx	; 13FEF
mov word [crowdlevel], cx	; 13FF1
mov dword [crowdsmooth], edx	; 13FF8
xor eax, eax	; 13FFE
call StartPreGame	; 14000
test eax, eax	; 14005
jge short .1	; 14007
mov eax, 0FFFFFFFFh	; 14009
pop edi	; 1400E
pop edx	; 1400F
pop ecx	; 14010
pop ebx	; 14011
ret	; 14012
.1:
mov edx, dword [introskipped]	; 14013
test edx, edx	; 14019
je short .2	; 1401B
mov word [fadeinpending], 1	; 1401D
.2:
xor edi, edi	; 14026
mov word [gsp], di	; 14028
call ResetGameVars	; 1402F
mov dword [introskipped], edx	; 14034
cmp dword [dword_CC0EC], byte 0	; 1403A
jne short .3	; 14041
test edx, edx	; 14043
jne short .3	; 14045
xor eax, eax	; 14047
mov word [fadeinpending], ax	; 14049
.3:
xor eax, eax	; 1404F
pop edi	; 14051
pop edx	; 14052
pop ecx	; 14053
pop ebx	; 14054
ret	; 14055
%endif ; C
ResetGameVars:
push dword 20h	; 14056
call __CHK	; 1405B
push ebx	; 14060
push ecx	; 14061
push edx	; 14062
push esi	; 14063
push edi	; 14064
mov ah, 0FFh	; 14065
mov byte [byte_E9AC8], ah	; 14067
mov byte [byte_E9AD3], ah	; 1406D
xor edx, edx	; 14073
mov dword [dword_CC0AC], edx	; 14075
xor dh, dh	; 1407B
mov byte [byte_E024F], dh	; 1407D
mov byte [word_E024E], dh	; 14083
mov byte [byte_E024D], dh	; 14089
mov byte [byte_E024C], dh	; 1408F
mov edx, 0FFFFFFFFh	; 14095
mov word [ovltimer], dx	; 1409A
mov word [word_C90D8], dx	; 140A1
mov word [RefStep], dx	; 140A8
mov word [Pencntdwn], dx	; 140AF
mov word [word_CC0B0], dx	; 140B6
xor eax, eax	; 140BD
mov word [threat], ax	; 140BF
mov word [passplayer], ax	; 140C5
mov word [passspeed], ax	; 140CB
mov word [passdir], ax	; 140D1
mov word [lastplayer], ax	; 140D7
mov word [shotplayer], ax	; 140DD
mov word [word_CBC44], ax	; 140E3
mov word [RefPen], ax	; 140E9
mov word [refsignal], ax	; 140EF
mov word [Penaltytimer], ax	; 140F5
mov word [lcblinktime+2], ax	; 140FB
mov word [lcblinktime], ax	; 14101
mov word [lcblink+2], ax	; 14107
mov word [lcblink], ax	; 1410D
mov word [energywarn+2], ax	; 14113
mov word [energywarn], ax	; 14119
mov word [lcreqchoice+2], ax	; 1411F
mov word [lcreqchoice], ax	; 14125
mov word [lcrequest+2], ax	; 1412B
mov word [lcrequest], ax	; 14131
mov word [lcboxon+2], ax	; 14137
mov word [lcboxon], ax	; 1413D
mov word [lctimer+2], ax	; 14143
mov word [lctimer], ax	; 14149
mov word [lcline+2], ax	; 1414F
mov word [lcline], ax	; 14155
mov word [word_CBC60], ax	; 1415B
mov word [lcsel], ax	; 14161
xor ebx, ebx	; 14167
mov dword [savedmousey], ebx	; 14169
xor ecx, ecx	; 1416F
mov dword [savedmousex], ecx	; 14171
mov word [bannertimer], ax	; 14177
mov word [word_CBEC6], ax	; 1417D
mov word [word_CBEC2], ax	; 14183
mov ecx, edx	; 14189
mov word [bannermsg], dx	; 1418B
mov word [ovlstep], dx	; 14192
mov word [ovlseq], dx	; 14199
xor ch, dh	; 141A0
mov byte [textline5], ch	; 141A2
xor al, al	; 141A8
mov byte [textline4], al	; 141AA
mov byte [textline2], al	; 141AF
mov byte [textline1], al	; 141B4
mov byte [textline3], al	; 141B9
xor esi, esi	; 141BE
mov dword [penshotmode], ebx	; 141C0
mov dword [penshotlive], ebx	; 141C6
mov dword [penshotstart], ebx	; 141CC
xor eax, eax	; 141D2
mov dword [shotontarget], ebx	; 141D4
mov dword [shotongoal], ebx	; 141DA
mov dword [penshotplayer], 0FFFFFFFFh	; 141E0
xor eax, esi	; 141EA
mov word [CwdExciteLvl], ax	; 141EC
xor ebx, ebx	; 141F2
.1:
mov eax, ebx	; 141F4
shl eax, 2	; 141F6
sub eax, ebx	; 141F9
shl eax, 2	; 141FB
mov edx, word_DEE94	; 141FE
add edx, eax	; 14203
mov word [edx], 0FFFFh	; 14205
mov eax, 28h	; 1420A
call randomd0	; 1420F
add al, 3Ch	; 14214
mov byte [byte edx+02h], al	; 14216
inc ebx	; 14219
cmp ebx, byte 14h	; 1421A
jl short ResetGameVars.1	; 1421D
mov ecx, 20h	; 1421F
xor edx, edx	; 14224
mov eax, word_E9B2C	; 14226
call __STOSB	; 1422B
xor edx, edx	; 14230
mov word [dword_E9A9E], dx	; 14232
mov word [word_E9AAE], dx	; 14239
mov word [dword_E9AB6], dx	; 14240
mov word [word_E9AA6], dx	; 14247
mov word [word_E9AA4], dx	; 1424E
mov word [word_E9AA2], dx	; 14255
mov word [word_E9AAA], dx	; 1425C
xor ecx, ecx	; 14263
mov dword [dword_E009C], ecx	; 14265
mov word [word_E9A9C], 0FFFFh	; 1426B
call StartGame	; 14274
mov dword [curperiod], 1	; 14279
cmp byte [pad1dev], 1	; 14283
je short .2	; 1428A
cmp byte [pad2dev], 1	; 1428C
jne short .3	; 14293
.2:
push byte 64h	; 14295
push dword 0A0h	; 14297
call MouseSetPos	; 1429C
add esp, byte 8	; 142A1
.3:
xor edi, edi	; 142A4
mov dword [deferpending], edi	; 142A6
mov dword [inputframes], edi	; 142AC
xor ecx, ecx	; 142B2
mov word [exitgame], cx	; 142B4
xor esi, esi	; 142BB
mov word [gameover], si	; 142BD
mov dword [hudhundaccum], edi	; 142C4
mov dword [frameaccum], edi	; 142CA
mov dword [joysampling], edi	; 142D0
mov word [joysampling_save], cx	; 142D6
call joyq_flush	; 142DD
jmp near IndexPhotoBank_x	; 142E2
; C: src/pc/asset_loading/FileExists.c
%ifdef CBUILD
%include "c/pc/asset_loading/FileExists.inc"
%else
FileExists:
push dword 10h	; 142E7
call __CHK	; 142EC
push ebx	; 142F1
push edx	; 142F2
sub esp, byte 4	; 142F3
mov dword [esp], 0FFFFFFFFh	; 142F6
xor ebx, ebx	; 142FD
mov edx, esp	; 142FF
call FileOpenRead	; 14301
test eax, eax	; 14306
jne short .1	; 14308
mov ebx, 1	; 1430A
.1:
mov eax, esp	; 1430F
call FileClose	; 14311
mov eax, ebx	; 14316
add esp, byte 4	; 14318
pop edx	; 1431B
pop ebx	; 1431C
ret	; 1431D
%endif ; C
