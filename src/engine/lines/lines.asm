; Building lines. Sorting the players by position, the default lines, filling and refilling each slot,
; and which players can be removed (95G engine/lines95).
bits 32
%include "hockey.inc"
section s_644A8 progbits alloc exec nowrite align=1
extern __CHK, awlinetab, bannermsg, bannerstrs, bannertimer, byte_CC049, byte_CCE00, byte_CD418
extern byte_CD421, byte_CD473, byte_DB3AE, byte_DC8D8, byte_DC9D8, byte_DEE97, byte_DF64D, byte_DFFA6
extern byte_E03C1, byte_E9DB4, byte_E9E18, byte_E9E31, byte_E9E4A, byte_E9F7E, byte_E9F8F, byte_E9F9B
extern byte_E9F9C, byte_E9FAB, byte_E9FAC, byte_E9FAD, byte_E9FAE, byte_E9FAF, byte_E9FDC, byte_E9FDD
extern c1playernum, c2playernum, camx, camx_m2, camy, cddriveptr, cliprect_x0, cliprect_x1
extern cliprect_y0, cliprect_y1, clockticks, cont1team, cont2team, Crowd_Noise, crowdlevel, CrowdNoiseOff
extern curperiod, DrawFrameSprite, DrawRinkEndArt, DrawSprite, DrawSpriteNumber, dword_CC080, dword_CC0B4, dword_CCEF6
extern dword_CD41E, dword_CD4B0, dword_D30BC, dword_D30C0, dword_DEF8C, dword_DEFE0, dword_DF004, dword_E0220
extern dword_E0230, dword_E0244, dword_E03AE, dword_E03B9, dword_E03BD, dword_E9A9E, dword_E9C24, dword_E9C85
extern dword_E9C88, dword_E9F16, dword_E9F32, dword_E9F34, dword_E9F38, dword_E9F54, dword_E9F56, dword_E9F5A
extern dword_E9F76, dword_E9F78, dword_E9F7B, dword_E9F8C, dword_E9F98, dword_E9FA5, dword_E9FA8, dword_E9FAA
extern dword_E9FD9, dword_E9FF0, dword_ED74C, fileoncd, fox, foy, fputchar, FreeMemBlock
extern gameclock, gmode, gmode2, gsp, hmlinetab, hmroster, hmtmgoalie, hmtmstruct
extern joysampling, joysampling_save, lastsfx, MakePath, off_CBED0, off_CC01D, off_CD498, off_CD4A0
extern ovlscript, ovlseq, ovlstep, ovlstepidx, ovlsteptimer, ovltimer, PBnum, Pencntdwn
extern photoptrsf, puckc, puckstruct, puckz, recbpr, RefStep, regd0, regd1
extern regd2, regd3, replayplay, replaysfx, replaystart, replaytick, scor2font, scor3font
extern scrollx, scrolly, setpersonel, sflags, sfx, shownumbers, SortCords, sprintf_
extern spritedrawcount, str_04d2, str_AWAYPALS, str_extBIN, str_HOMEPALS4, str_Pal30, str_PPV, str_Rinkpal
extern sub_6AB7C, sub_8DAB8, sub_8E83C, sub_8E8A0, sub_8E9C0, sub_8EA18, sub_90354, sub_90D20
extern sub_90EC0, sub_91964, sub_93540, sub_B30B4, sub_B340B, sub_B4BC4, sub_B500C, sub_B5D80
extern textline1, textline2, textline3, textline4, textline5, unk_DACA0, unk_E9CEC, unk_E9D1E
extern unk_E9D50, unk_E9D82, unk_E9DE6, unk_E9E7C, unk_E9EAE, unk_E9EE0, word_CC054, word_CC0B0
extern word_CCEF8, word_CD4FC, word_DEE94, word_E0022, word_E0046, word_E9F12, word_E9F14, word_E9F18
extern word_E9F36, word_E9F3A, word_E9F58, word_E9F5C, word_E9F7A, word_E9FA7, word_E9FA9, word_E9FB0
extern word_E9FB2, word_E9FB4, xc1, yc1, yleader
global SortPlayersByPos, SortNonDefPlayers, BuildDefaultLines, lines_popx, CanFillLineSlot, lines_addesp10_x, FillDressedSlots, PickForLineSlot
global lines_popx2, PickGoalie, PickExtraSkater, RefillLineSlots, RemoveFromLines, SetupTeamLines, NormalizeDressFlags, CanRemovePlayer
; C: src/engine/lines/SortPlayersByPos.c
%ifdef CBUILD
%include "c/engine/lines/SortPlayersByPos.inc"
%else
SortPlayersByPos:
push dword 24h	; 644A8
call __CHK	; 644AD
push esi	; 644B2
push edi	; 644B3
push ebp	; 644B4
sub esp, byte 4	; 644B5
push eax	; 644B8
mov ebp, edx	; 644B9
mov edi, ebx	; 644BB
mov byte [byte esp+04h], cl	; 644BD
xor eax, eax	; 644C1
.1:
mov ebx, eax	; 644C3
shl ebx, 2	; 644C5
mov dword [dword ebx+dword_E9C88], eax	; 644C8
mov ecx, dword [byte esp-02h]	; 644CE
sar ecx, 10h	; 644D2
mov esi, ecx	; 644D5
shl esi, 4	; 644D7
add esi, ecx	; 644DA
shl esi, 4	; 644DC
add esi, ecx	; 644DF
shl esi, 2	; 644E1
mov edx, eax	; 644E4
shl edx, 2	; 644E6
add edx, eax	; 644E9
shl edx, 3	; 644EB
sub edx, eax	; 644EE
mov dl, byte [dword edx+esi+byte_DB3AE]	; 644F0
cmp dl, byte [byte esp+04h]	; 644F7
je short .2	; 644FB
mov dword [dword ebx+dword_E9C24], 0FFFFFFFFh	; 644FD
jmp short .3	; 64507
.2:
mov edx, eax	; 64509
movsx edx, word [edi+edx*2]	; 6450B
mov dword [dword ebx+dword_E9C24], edx	; 6450F
.3:
inc eax	; 64515
cmp eax, byte 19h	; 64516
jl short SortPlayersByPos.1	; 64519
push dword_E9C88	; 6451B
push dword_E9C24	; 64520
push byte 19h	; 64525
call sub_93540	; 64527
add esp, byte 0Ch	; 6452C
xor eax, eax	; 6452F
.4:
mov edx, eax	; 64531
shl edx, 2	; 64533
cmp dword [dword edx+dword_E9C24], byte 0	; 64536
jge short .5	; 6453D
mov edx, 0FFFFFFFFh	; 6453F
jmp short .6	; 64544
.5:
mov edx, dword [dword edx+dword_E9C88-3]	; 64546
sar edx, 18h	; 6454C
.6:
mov byte [eax+ebp], dl	; 6454F
inc eax	; 64552
cmp eax, byte 19h	; 64553
jl short SortPlayersByPos.4	; 64556
add esp, byte 8	; 64558
pop ebp	; 6455B
pop edi	; 6455C
pop esi	; 6455D
ret	; 6455E
%endif ; C
; C: src/engine/lines/SortNonDefPlayers.c
%ifdef CBUILD
%include "c/engine/lines/SortNonDefPlayers.inc"
%else
SortNonDefPlayers:
push dword 24h	; 6455F
call __CHK	; 64564
push ecx	; 64569
push esi	; 6456A
push edi	; 6456B
push ebp	; 6456C
push eax	; 6456D
mov edi, edx	; 6456E
mov ebp, ebx	; 64570
xor eax, eax	; 64572
.1:
mov ebx, eax	; 64574
shl ebx, 2	; 64576
mov dword [dword ebx+dword_E9C88], eax	; 64579
mov ecx, dword [byte esp-02h]	; 6457F
sar ecx, 10h	; 64583
mov esi, ecx	; 64586
shl esi, 4	; 64588
add esi, ecx	; 6458B
shl esi, 4	; 6458D
add esi, ecx	; 64590
shl esi, 2	; 64592
mov edx, eax	; 64595
shl edx, 2	; 64597
add edx, eax	; 6459A
shl edx, 3	; 6459C
sub edx, eax	; 6459F
mov dl, byte [dword edx+esi+byte_DB3AE]	; 645A1
xor dh, dh	; 645A8
cmp dx, byte 44h	; 645AA
jne short .2	; 645AE
mov dword [dword ebx+dword_E9C24], 0FFFFFFFFh	; 645B0
jmp short .3	; 645BA
.2:
mov edx, eax	; 645BC
movsx edx, word [byte ebp+edx*2+00h]	; 645BE
mov dword [dword ebx+dword_E9C24], edx	; 645C3
.3:
inc eax	; 645C9
cmp eax, byte 19h	; 645CA
jl short SortNonDefPlayers.1	; 645CD
push dword_E9C88	; 645CF
push dword_E9C24	; 645D4
push byte 19h	; 645D9
call sub_93540	; 645DB
add esp, byte 0Ch	; 645E0
xor eax, eax	; 645E3
.4:
mov edx, eax	; 645E5
shl edx, 2	; 645E7
cmp dword [dword edx+dword_E9C24], byte 0	; 645EA
jge short .5	; 645F1
mov edx, 0FFFFFFFFh	; 645F3
jmp short .6	; 645F8
.5:
mov edx, dword [dword edx+dword_E9C88-3]	; 645FA
sar edx, 18h	; 64600
.6:
mov byte [edi+eax], dl	; 64603
inc eax	; 64606
cmp eax, byte 19h	; 64607
jl short SortNonDefPlayers.4	; 6460A
add esp, byte 4	; 6460C
pop ebp	; 6460F
pop edi	; 64610
pop esi	; 64611
pop ecx	; 64612
ret	; 64613
%endif ; C
; C: src/engine/lines/BuildDefaultLines.c
%ifdef CBUILD
%include "c/engine/lines/BuildDefaultLines.inc"
%else
BuildDefaultLines:
push dword 0F4h	; 64614
call __CHK	; 64619
push ebx	; 6461E
push ecx	; 6461F
push edx	; 64620
push esi	; 64621
push edi	; 64622
push ebp	; 64623
sub esp, 0D8h	; 64624
xor esi, esi	; 6462A
jmp near .13	; 6462C
.1:
xor edx, edx	; 64631
jmp near .6	; 64633
.2:
movsx ecx, si	; 64638
mov ebp, ecx	; 6463B
shl ebp, 4	; 6463D
add ebp, ecx	; 64640
shl ebp, 4	; 64642
add ebp, ecx	; 64645
shl ebp, 2	; 64647
movsx edi, dx	; 6464A
mov eax, edi	; 6464D
shl eax, 2	; 6464F
add eax, edi	; 64652
shl eax, 3	; 64654
sub eax, edi	; 64657
add eax, ebp	; 64659
mov bl, byte [dword eax+hmroster]	; 6465B
test bl, bl	; 64661
je short .3	; 64663
cmp bl, 1	; 64665
jne short .4	; 64668
.3:
movsx ebx, si	; 6466A
mov eax, ebx	; 6466D
shl eax, 2	; 6466F
sub eax, ebx	; 64672
shl eax, 3	; 64674
add eax, ebx	; 64677
add eax, eax	; 64679
movsx ebx, dx	; 6467B
add ebx, ebx	; 6467E
add eax, ebx	; 64680
mov ebx, 0FFFFFFFFh	; 64682
mov word [esp+eax], bx	; 64687
mov word [byte esp+eax+064h], bx	; 6468B
jmp near .5	; 64690
.4:
mov eax, ecx	; 64695
shl eax, 5	; 64697
sub eax, ecx	; 6469A
shl eax, 2	; 6469C
add eax, ecx	; 6469F
shl eax, 2	; 646A1
mov ebp, unk_DACA0	; 646A4
add ebp, eax	; 646A9
mov ebx, edi	; 646AB
mov eax, edi	; 646AD
shl eax, 2	; 646AF
add eax, edi	; 646B2
xor ebx, edi	; 646B4
mov bl, byte [byte ebp+eax*4+01h]	; 646B6
mov dword [dword esp+0D4h], ebx	; 646BA
xor ebx, ebx	; 646C1
mov bl, byte [byte ebp+eax*4+02h]	; 646C3
mov dword [dword esp+0D0h], ebx	; 646C7
mov ebx, dword [dword esp+0D4h]	; 646CE
add ebx, dword [dword esp+0D0h]	; 646D5
mov dword [dword esp+0D0h], ebx	; 646DC
xor ebx, ebx	; 646E3
mov bl, byte [byte ebp+eax*4+04h]	; 646E5
mov dword [dword esp+0D4h], ebx	; 646E9
mov ebx, dword [dword esp+0D0h]	; 646F0
add ebx, dword [dword esp+0D4h]	; 646F7
mov dword [dword esp+0D4h], ebx	; 646FE
xor ebx, ebx	; 64705
mov bl, byte [byte ebp+eax*4+06h]	; 64707
mov dword [dword esp+0D0h], ebx	; 6470B
mov ebx, dword [dword esp+0D4h]	; 64712
add ebx, dword [dword esp+0D0h]	; 64719
mov dword [dword esp+0D4h], ebx	; 64720
xor ebx, ebx	; 64727
mov bl, byte [byte ebp+eax*4+09h]	; 64729
mov dword [dword esp+0D0h], ebx	; 6472D
mov ebx, dword [dword esp+0D4h]	; 64734
add ebx, dword [dword esp+0D0h]	; 6473B
mov dword [dword esp+0D0h], ebx	; 64742
xor ebx, ebx	; 64749
mov bl, byte [byte ebp+eax*4+0Ah]	; 6474B
mov dword [dword esp+0D4h], ebx	; 6474F
mov ebx, dword [dword esp+0D0h]	; 64756
add ebx, dword [dword esp+0D4h]	; 6475D
mov dword [dword esp+0D4h], ebx	; 64764
xor ebx, ebx	; 6476B
mov bl, byte [byte ebp+eax*4+03h]	; 6476D
mov dword [dword esp+0D0h], ebx	; 64771
mov ebx, dword [dword esp+0D4h]	; 64778
add ebx, dword [dword esp+0D0h]	; 6477F
mov dword [dword esp+0D0h], ebx	; 64786
xor ebx, ebx	; 6478D
mov bl, byte [byte ebp+eax*4+0Dh]	; 6478F
mov dword [dword esp+0D4h], ebx	; 64793
mov ebx, dword [dword esp+0D0h]	; 6479A
add ebx, dword [dword esp+0D4h]	; 647A1
mov dword [dword esp+0D4h], ebx	; 647A8
mov ebx, ecx	; 647AF
shl ebx, 2	; 647B1
sub ebx, ecx	; 647B4
shl ebx, 3	; 647B6
add ecx, ebx	; 647B9
add ecx, ecx	; 647BB
lea ebx, [edi+edi]	; 647BD
add ebx, ecx	; 647C0
mov ecx, dword [dword esp+0D4h]	; 647C2
mov word [byte esp+ebx+064h], cx	; 647C9
xor ecx, ecx	; 647CE
mov cl, byte [byte ebp+eax*4+01h]	; 647D0
movzx di, byte [byte ebp+eax*4+02h]	; 647D4
add ecx, edi	; 647DA
movzx di, byte [byte ebp+eax*4+04h]	; 647DC
add ecx, edi	; 647E2
movzx di, byte [byte ebp+eax*4+06h]	; 647E4
add ecx, edi	; 647EA
movzx di, byte [byte ebp+eax*4+09h]	; 647EC
add ecx, edi	; 647F2
movzx di, byte [byte ebp+eax*4+0Bh]	; 647F4
add ecx, edi	; 647FA
movzx di, byte [byte ebp+eax*4+05h]	; 647FC
add ecx, edi	; 64802
movzx di, byte [byte ebp+eax*4+0Ch]	; 64804
add edi, ecx	; 6480A
xor ecx, ecx	; 6480C
mov cl, byte [byte ebp+eax*4+03h]	; 6480E
add ecx, edi	; 64812
mov al, byte [byte ebp+eax*4+0Dh]	; 64814
xor ah, ah	; 64818
add eax, ecx	; 6481A
mov word [esp+ebx], ax	; 6481C
.5:
inc edx	; 64820
.6:
cmp dx, byte 19h	; 64821
jl near BuildDefaultLines.2	; 64825
movsx edi, si	; 6482B
mov ebp, edi	; 6482E
shl ebp, 2	; 64830
sub ebp, edi	; 64833
shl ebp, 3	; 64835
add ebp, edi	; 64838
add ebp, ebp	; 6483A
lea eax, [byte esp+064h]	; 6483C
add eax, ebp	; 64840
mov dword [dword esp+0CCh], eax	; 64842
mov eax, edi	; 64849
shl eax, 2	; 6484B
sub eax, edi	; 6484E
shl eax, 3	; 64850
add eax, edi	; 64853
mov dword [dword esp+0C8h], eax	; 64855
mov edx, unk_E9D50	; 6485C
add edx, eax	; 64861
mov ecx, 44h	; 64863
mov ebx, dword [dword esp+0CCh]	; 64868
mov eax, edi	; 6486F
call SortPlayersByPos	; 64871
mov edx, unk_E9EAE	; 64876
add edx, dword [dword esp+0C8h]	; 6487B
mov ecx, 52h	; 64882
mov ebx, dword [dword esp+0CCh]	; 64887
mov eax, edi	; 6488E
call SortPlayersByPos	; 64890
mov edx, unk_E9DE6	; 64895
add edx, dword [dword esp+0C8h]	; 6489A
mov ecx, 4Ch	; 648A1
mov ebx, dword [dword esp+0CCh]	; 648A6
mov eax, edi	; 648AD
call SortPlayersByPos	; 648AF
mov edx, unk_E9CEC	; 648B4
add edx, dword [dword esp+0C8h]	; 648B9
mov ecx, 43h	; 648C0
mov ebx, dword [dword esp+0CCh]	; 648C5
mov eax, edi	; 648CC
call SortPlayersByPos	; 648CE
mov eax, esp	; 648D3
add ebp, eax	; 648D5
mov edx, byte_E9DB4	; 648D7
add edx, dword [dword esp+0C8h]	; 648DC
mov ecx, 44h	; 648E3
mov ebx, ebp	; 648E8
mov eax, edi	; 648EA
call SortPlayersByPos	; 648EC
mov edx, unk_E9D1E	; 648F1
add edx, dword [dword esp+0C8h]	; 648F6
mov ecx, 52h	; 648FD
mov ebx, ebp	; 64902
mov eax, edi	; 64904
call SortPlayersByPos	; 64906
mov edx, unk_E9E7C	; 6490B
add edx, dword [dword esp+0C8h]	; 64910
mov ecx, 4Ch	; 64917
mov ebx, ebp	; 6491C
mov eax, edi	; 6491E
call SortPlayersByPos	; 64920
mov edx, unk_E9D82	; 64925
add edx, dword [dword esp+0C8h]	; 6492A
mov ecx, 43h	; 64931
mov ebx, ebp	; 64936
mov eax, edi	; 64938
call SortPlayersByPos	; 6493A
mov edx, byte_E9E4A	; 6493F
add edx, dword [dword esp+0C8h]	; 64944
mov ebx, dword [dword esp+0CCh]	; 6494B
mov eax, edi	; 64952
call SortNonDefPlayers	; 64954
mov edx, unk_E9EE0	; 64959
add edx, dword [dword esp+0C8h]	; 6495E
mov ebx, ebp	; 64965
mov eax, edi	; 64967
call SortNonDefPlayers	; 64969
xor edx, edx	; 6496E
movsx ecx, si	; 64970
jmp short .8	; 64973
.7:
mov ebp, ecx	; 64975
shl ebp, 4	; 64977
add ebp, ecx	; 6497A
shl ebp, 4	; 6497C
add ebp, ecx	; 6497F
shl ebp, 2	; 64981
movsx edi, dx	; 64984
mov eax, edi	; 64987
shl eax, 2	; 64989
add eax, edi	; 6498C
shl eax, 3	; 6498E
sub eax, edi	; 64991
movzx ebp, byte [dword eax+ebp+hmroster]	; 64993
mov eax, ecx	; 6499B
shl eax, 2	; 6499D
sub eax, ecx	; 649A0
shl eax, 3	; 649A2
add eax, ecx	; 649A5
add edi, eax	; 649A7
mov al, byte [dword ebp+byte_CD418]	; 649A9
mov byte [dword edi+byte_E9E18], al	; 649AF
inc edx	; 649B5
.8:
cmp dx, byte 19h	; 649B6
jl short BuildDefaultLines.7	; 649BA
test si, si	; 649BC
je short .9	; 649BF
mov ebx, awlinetab	; 649C1
jmp short .10	; 649C6
.9:
mov ebx, hmlinetab	; 649C8
.10:
xor edx, edx	; 649CD
jmp short .12	; 649CF
.11:
movsx ecx, si	; 649D1
mov eax, ecx	; 649D4
shl eax, 2	; 649D6
sub eax, ecx	; 649D9
shl eax, 3	; 649DB
add ecx, eax	; 649DE
movsx eax, byte [ebx]	; 649E0
inc ebx	; 649E3
mov byte [dword ecx+eax+byte_E9E18], 0	; 649E4
inc edx	; 649EC
.12:
cmp dx, byte 12h	; 649ED
jl short BuildDefaultLines.11	; 649F1
inc esi	; 649F3
.13:
cmp si, byte 2	; 649F4
jl near BuildDefaultLines.1	; 649F8
add esp, 0D8h	; 649FE
lines_popx:
pop ebp	; 64A04
pop edi	; 64A05
pop esi	; 64A06
pop edx	; 64A07
pop ecx	; 64A08
pop ebx	; 64A09
ret	; 64A0A
%endif ; C
CanFillLineSlot:
push dword 24h	; 64A0B
call __CHK	; 64A10
push ecx	; 64A15
push esi	; 64A16
push edi	; 64A17
push ebp	; 64A18
sub esp, byte 10h	; 64A19
mov esi, eax	; 64A1C
mov ecx, edx	; 64A1E
mov edi, ebx	; 64A20
test ax, ax	; 64A22
je short .1	; 64A25
mov ebp, awlinetab	; 64A27
jmp short .2	; 64A2C
.1:
mov ebp, hmlinetab	; 64A2E
.2:
movsx eax, si	; 64A33
mov dword [byte esp+04h], eax	; 64A36
mov ebx, eax	; 64A3A
shl ebx, 4	; 64A3C
add ebx, eax	; 64A3F
shl ebx, 4	; 64A41
add ebx, eax	; 64A44
shl ebx, 2	; 64A46
movsx eax, di	; 64A49
mov dword [byte esp+08h], eax	; 64A4C
mov edx, eax	; 64A50
shl eax, 2	; 64A52
add eax, edx	; 64A55
shl eax, 3	; 64A57
sub eax, edx	; 64A5A
mov al, byte [dword ebx+eax+hmroster]	; 64A5C
and eax, 0FFh	; 64A63
movsx bx, byte [dword eax+byte_CD418]	; 64A68
test bx, bx	; 64A70
jne short .4	; 64A73
.3:
xor edx, edx	; 64A75
jmp near .34	; 64A77
.4:
cmp bx, byte 2	; 64A7C
jne short .5	; 64A80
mov edx, dword [byte esp+04h]	; 64A82
mov eax, edx	; 64A86
shl eax, 2	; 64A88
sub eax, edx	; 64A8B
shl eax, 3	; 64A8D
add eax, edx	; 64A90
add eax, dword [byte esp+08h]	; 64A92
cmp byte [dword eax+byte_E9E18], 2	; 64A96
jne short CanFillLineSlot.3	; 64A9D
.5:
movsx edx, si	; 64A9F
mov ebx, edx	; 64AA2
shl ebx, 4	; 64AA4
add ebx, edx	; 64AA7
shl ebx, 4	; 64AA9
add ebx, edx	; 64AAC
shl ebx, 2	; 64AAE
movsx edx, di	; 64AB1
mov eax, edx	; 64AB4
shl eax, 2	; 64AB6
add eax, edx	; 64AB9
shl eax, 3	; 64ABB
sub eax, edx	; 64ABE
xor edx, edx	; 64AC0
mov dl, byte [dword ebx+eax+byte_DB3AE]	; 64AC2
cmp cx, byte 0Ch	; 64AC9
jge near .11	; 64ACD
xor esi, esi	; 64AD3
xor ebx, ebx	; 64AD5
jmp short .9	; 64AD7
.6:
movsx edx, bx	; 64AD9
mov dword [byte esp+0Ch], 3	; 64ADC
mov eax, edx	; 64AE4
sar edx, 1Fh	; 64AE6
idiv dword [byte esp+0Ch]	; 64AE9
mov dword [esp], edx	; 64AED
movsx edx, cx	; 64AF0
mov dword [byte esp+0Ch], 3	; 64AF3
mov eax, edx	; 64AFB
sar edx, 1Fh	; 64AFD
idiv dword [byte esp+0Ch]	; 64B00
cmp edx, dword [esp]	; 64B04
jne short .7	; 64B07
cmp bx, cx	; 64B09
jge short .8	; 64B0C
.7:
movsx edx, bx	; 64B0E
movsx dx, byte [edx+ebp]	; 64B11
cmp dx, di	; 64B16
jne short .8	; 64B19
inc esi	; 64B1B
.8:
inc ebx	; 64B1C
.9:
cmp bx, byte 0Ch	; 64B1D
jl short CanFillLineSlot.6	; 64B21
cmp si, byte 2	; 64B23
jl short .10	; 64B27
cmp word [word_E9F12], byte 6	; 64B29
jg near CanFillLineSlot.3	; 64B31
.10:
movsx edx, cx	; 64B37
mov ebx, 3	; 64B3A
mov eax, edx	; 64B3F
sar edx, 1Fh	; 64B41
idiv ebx	; 64B44
mov edx, eax	; 64B46
shl eax, 2	; 64B48
sub eax, edx	; 64B4B
mov edx, eax	; 64B4D
mov esi, eax	; 64B4F
add esi, byte 2	; 64B51
jmp near .27	; 64B54
.11:
cmp cx, byte 12h	; 64B59
jge near .17	; 64B5D
cmp word [word_E9F14], byte 3	; 64B63
jl short .16	; 64B6B
xor esi, esi	; 64B6D
mov ebx, 0Ch	; 64B6F
jmp short .15	; 64B74
.12:
movsx edx, bx	; 64B76
mov dword [byte esp+0Ch], 2	; 64B79
mov eax, edx	; 64B81
sar edx, 1Fh	; 64B83
idiv dword [byte esp+0Ch]	; 64B86
mov dword [esp], edx	; 64B8A
movsx edx, cx	; 64B8D
mov dword [byte esp+0Ch], 2	; 64B90
mov eax, edx	; 64B98
sar edx, 1Fh	; 64B9A
idiv dword [byte esp+0Ch]	; 64B9D
cmp edx, dword [esp]	; 64BA1
jne short .13	; 64BA4
cmp bx, cx	; 64BA6
jge short .14	; 64BA9
.13:
movsx edx, bx	; 64BAB
movsx dx, byte [edx+ebp]	; 64BAE
cmp dx, di	; 64BB3
jne short .14	; 64BB6
inc esi	; 64BB8
.14:
inc ebx	; 64BB9
.15:
cmp bx, byte 12h	; 64BBA
jl short CanFillLineSlot.12	; 64BBE
cmp si, byte 2	; 64BC0
jge near CanFillLineSlot.3	; 64BC4
.16:
mov edx, ecx	; 64BCA
and dl, 0FEh	; 64BCC
mov esi, edx	; 64BCF
inc esi	; 64BD1
jmp near .27	; 64BD2
.17:
cmp cx, byte 1Ch	; 64BD7
jge short .23	; 64BDB
cmp dx, byte 44h	; 64BDD
jne short .18	; 64BE1
cmp word [word_E9F14], byte 4	; 64BE3
jl short .19	; 64BEB
.18:
cmp dx, byte 44h	; 64BED
je short .22	; 64BF1
cmp word [word_E9F12], byte 6	; 64BF3
jge short .22	; 64BFB
.19:
cmp cx, byte 17h	; 64BFD
jge short .20	; 64C01
mov edx, 12h	; 64C03
jmp short .21	; 64C08
.20:
mov edx, 17h	; 64C0A
.21:
mov esi, edx	; 64C0F
add esi, byte 4	; 64C11
jmp short .27	; 64C14
.22:
mov edx, 12h	; 64C16
mov esi, 1Bh	; 64C1B
jmp short .27	; 64C20
.23:
cmp dx, byte 44h	; 64C22
jne short .26	; 64C26
cmp word [word_E9F14], byte 4	; 64C28
jge short .26	; 64C30
cmp cx, byte 20h	; 64C32
jge short .24	; 64C36
mov edx, 1Ch	; 64C38
jmp short .25	; 64C3D
.24:
mov edx, 20h	; 64C3F
.25:
mov esi, edx	; 64C44
add esi, byte 3	; 64C46
jmp short .27	; 64C49
.26:
mov edx, 1Ch	; 64C4B
mov esi, 23h	; 64C50
.27:
mov ebx, edx	; 64C55
jmp short .33	; 64C57
.28:
cmp bx, cx	; 64C59
je short .32	; 64C5C
cmp cx, byte 1Ch	; 64C5E
jl short .29	; 64C62
movsx edx, cx	; 64C64
movsx eax, bx	; 64C67
add edx, byte 4	; 64C6A
jmp short .30	; 64C6D
.29:
cmp cx, byte 12h	; 64C6F
jl short .31	; 64C73
movsx edx, cx	; 64C75
movsx eax, bx	; 64C78
add edx, byte 5	; 64C7B
.30:
cmp eax, edx	; 64C7E
je short .32	; 64C80
.31:
movsx edx, bx	; 64C82
movsx dx, byte [edx+ebp]	; 64C85
cmp dx, di	; 64C8A
jne short .32	; 64C8D
xor edx, edi	; 64C8F
jmp short .34	; 64C91
.32:
inc ebx	; 64C93
.33:
cmp bx, si	; 64C94
jle short CanFillLineSlot.28	; 64C97
mov edx, 1	; 64C99
.34:
mov eax, edx	; 64C9E
lines_addesp10_x:
add esp, byte 10h	; 64CA0
pop ebp	; 64CA3
pop edi	; 64CA4
pop esi	; 64CA5
pop ecx	; 64CA6
ret	; 64CA7
FillDressedSlots:
push dword 24h	; 64CA8
call __CHK	; 64CAD
push ecx	; 64CB2
push esi	; 64CB3
push edi	; 64CB4
push ebp	; 64CB5
sub esp, byte 10h	; 64CB6
mov ebp, eax	; 64CB9
mov word [esp], dx	; 64CBB
mov word [byte esp+08h], bx	; 64CBF
xor edx, edx	; 64CC4
mov word [byte esp+0Ch], dx	; 64CC6
jmp near .11	; 64CCB
.1:
mov ecx, dword [byte esp-02h]	; 64CD0
sar ecx, 10h	; 64CD4
mov eax, ecx	; 64CD7
shl eax, 2	; 64CD9
sub eax, ecx	; 64CDC
shl eax, 3	; 64CDE
add eax, ecx	; 64CE1
mov edi, dword [byte esp+02h]	; 64CE3
sar edi, 10h	; 64CE7
lea esi, [eax+edi]	; 64CEA
cmp byte [dword esi+byte_E9E18], 0	; 64CED
je near .10	; 64CF4
mov edx, dword [byte esp+06h]	; 64CFA
sar edx, 10h	; 64CFE
mov ebx, edi	; 64D01
mov eax, ecx	; 64D03
call CanFillLineSlot	; 64D05
test ax, ax	; 64D0A
je near .10	; 64D0D
cmp byte [dword esi+byte_E9E18], 2	; 64D13
jne near .9	; 64D1A
cmp word [dword_E9F16], byte 12h	; 64D20
jge near .10	; 64D28
mov edx, ecx	; 64D2E
shl edx, 4	; 64D30
add edx, ecx	; 64D33
shl edx, 4	; 64D35
add edx, ecx	; 64D38
shl edx, 2	; 64D3A
mov eax, edi	; 64D3D
shl eax, 2	; 64D3F
add eax, edi	; 64D42
shl eax, 3	; 64D44
sub eax, edi	; 64D47
cmp byte [dword edx+eax+byte_DB3AE], 44h	; 64D49
je short .2	; 64D51
cmp word [word_E9F12], byte 0Ch	; 64D53
jge near .10	; 64D5B
.2:
mov edx, dword [byte esp-02h]	; 64D61
sar edx, 10h	; 64D65
mov ecx, edx	; 64D68
shl ecx, 4	; 64D6A
add ecx, edx	; 64D6D
shl ecx, 4	; 64D6F
add ecx, edx	; 64D72
shl ecx, 2	; 64D74
mov edx, dword [byte esp+02h]	; 64D77
sar edx, 10h	; 64D7B
mov eax, edx	; 64D7E
shl eax, 2	; 64D80
add eax, edx	; 64D83
shl eax, 3	; 64D85
sub eax, edx	; 64D88
mov byte [dword ecx+eax+hmroster], 3	; 64D8A
cmp word [esp], byte 0	; 64D92
je short .3	; 64D97
mov esi, awlinetab	; 64D99
jmp short .4	; 64D9E
.3:
mov esi, hmlinetab	; 64DA0
.4:
mov ecx, 28h	; 64DA5
mov edi, dword [byte esp+04h]	; 64DAA
jmp short .7	; 64DAE
.5:
movsx eax, cx	; 64DB0
add eax, esi	; 64DB3
movsx dx, byte [eax]	; 64DB5
cmp dx, di	; 64DB9
jne short .6	; 64DBC
mov byte [eax], 64h	; 64DBE
.6:
inc ecx	; 64DC1
.7:
cmp cx, byte 30h	; 64DC2
jl short FillDressedSlots.5	; 64DC6
mov esi, dword [byte esp-02h]	; 64DC8
sar esi, 10h	; 64DCC
mov eax, esi	; 64DCF
shl eax, 2	; 64DD1
sub eax, esi	; 64DD4
shl eax, 3	; 64DD6
add eax, esi	; 64DD9
mov ecx, dword [byte esp+02h]	; 64DDB
sar ecx, 10h	; 64DDF
mov byte [dword ecx+eax+byte_E9E18], 1	; 64DE2
mov edx, esi	; 64DEA
shl esi, 4	; 64DEC
add esi, edx	; 64DEF
shl esi, 4	; 64DF1
add esi, edx	; 64DF4
shl esi, 2	; 64DF6
mov eax, ecx	; 64DF9
shl eax, 2	; 64DFB
add eax, ecx	; 64DFE
shl eax, 3	; 64E00
sub eax, ecx	; 64E03
inc word [dword_E9F16]	; 64E05
cmp byte [dword esi+eax+byte_DB3AE], 44h	; 64E0C
jne short .8	; 64E14
inc word [word_E9F14]	; 64E16
jmp short .9	; 64E1D
.8:
inc word [word_E9F12]	; 64E1F
.9:
mov eax, dword [byte esp+04h]	; 64E26
jmp near lines_addesp10_x	; 64E2A
.10:
inc word [byte esp+0Ch]	; 64E2F
.11:
cmp word [byte esp+0Ch], byte 19h	; 64E34
jge short .12	; 64E3A
mov eax, dword [byte esp+0Ah]	; 64E3C
sar eax, 10h	; 64E40
movsx ax, byte [eax+ebp]	; 64E43
mov word [byte esp+04h], ax	; 64E48
test ax, ax	; 64E4D
jge near FillDressedSlots.1	; 64E50
.12:
mov eax, 0FFFFFFFFh	; 64E56
jmp near lines_addesp10_x	; 64E5B
PickForLineSlot:
push dword 24h	; 64E60
call __CHK	; 64E65
push ebx	; 64E6A
push ecx	; 64E6B
push esi	; 64E6C
push edi	; 64E6D
push ebp	; 64E6E
sub esp, byte 8	; 64E6F
push eax	; 64E72
mov esi, edx	; 64E73
test ax, ax	; 64E75
je short .1	; 64E78
mov ebp, awlinetab	; 64E7A
jmp short .2	; 64E7F
.1:
mov ebp, hmlinetab	; 64E81
.2:
movsx eax, si	; 64E86
movsx ax, byte [dword eax+byte_CD473]	; 64E89
mov dword [byte esp+04h], eax	; 64E91
mov ecx, eax	; 64E95
.3:
movsx eax, cx	; 64E97
movsx ax, byte [dword eax+byte_CD421]	; 64E9A
inc ecx	; 64EA2
cmp ax, si	; 64EA3
jne short PickForLineSlot.3	; 64EA6
.4:
movsx eax, cx	; 64EA8
cmp byte [dword eax+byte_CD421], 0	; 64EAB
jl short .7	; 64EB2
mov eax, dword [dword eax+byte_CD421-3]	; 64EB4
sar eax, 18h	; 64EBA
movsx di, byte [eax+ebp]	; 64EBD
movsx ebx, byte [eax+ebp]	; 64EC2
movsx edx, si	; 64EC6
mov eax, dword [byte esp-02h]	; 64EC9
sar eax, 10h	; 64ECD
call CanFillLineSlot	; 64ED0
test ax, ax	; 64ED5
je short .6	; 64ED8
.5:
mov esi, edi	; 64EDA
jmp near .48	; 64EDC
.6:
inc ecx	; 64EE1
jmp short PickForLineSlot.4	; 64EE2
.7:
movsx ebx, si	; 64EE4
movsx edx, byte [ebx+ebp]	; 64EE7
mov edi, edx	; 64EEB
shl edi, 2	; 64EED
add edi, edx	; 64EF0
shl edi, 3	; 64EF2
sub edi, edx	; 64EF5
mov edx, dword [byte esp-02h]	; 64EF7
sar edx, 10h	; 64EFB
mov eax, edx	; 64EFE
shl eax, 4	; 64F00
add eax, edx	; 64F03
shl eax, 4	; 64F05
add eax, edx	; 64F08
mov al, byte [dword edi+eax*4+byte_DB3AE]	; 64F0A
xor ah, ah	; 64F11
mov dword [byte esp+08h], eax	; 64F13
mov eax, edx	; 64F17
shl eax, 2	; 64F19
sub eax, edx	; 64F1C
shl eax, 3	; 64F1E
add eax, edx	; 64F21
mov ecx, dword [byte esp+08h]	; 64F23
cmp cx, byte 44h	; 64F27
jne short .12	; 64F2B
mov ecx, edx	; 64F2D
cmp si, byte 1Ch	; 64F2F
jge short .8	; 64F33
cmp si, byte 12h	; 64F35
jl short .8	; 64F39
add eax, unk_E9D50	; 64F3B
jmp short .9	; 64F40
.8:
mov edx, dword [byte esp-02h]	; 64F42
sar edx, 10h	; 64F46
mov eax, edx	; 64F49
shl eax, 2	; 64F4B
sub eax, edx	; 64F4E
shl eax, 3	; 64F50
add eax, edx	; 64F53
add eax, byte_E9DB4	; 64F55
.9:
mov edx, ecx	; 64F5A
.10:
call FillDressedSlots	; 64F5C
test ax, ax	; 64F61
jl near .31	; 64F64
.11:
mov esi, eax	; 64F6A
jmp near .48	; 64F6C
.12:
cmp cx, byte 43h	; 64F71
jne near .18	; 64F75
cmp si, byte 1Ch	; 64F7B
jge short .13	; 64F7F
add eax, unk_E9CEC	; 64F81
jmp short .14	; 64F86
.13:
add eax, unk_E9D82	; 64F88
.14:
call FillDressedSlots	; 64F8D
test ax, ax	; 64F92
jge short PickForLineSlot.11	; 64F95
movsx ecx, si	; 64F97
mov edx, dword [byte esp-02h]	; 64F9A
sar edx, 10h	; 64F9E
mov eax, edx	; 64FA1
shl eax, 2	; 64FA3
sub eax, edx	; 64FA6
shl eax, 3	; 64FA8
add eax, edx	; 64FAB
cmp si, byte 1Ch	; 64FAD
jge short .15	; 64FB1
add eax, unk_E9DE6	; 64FB3
jmp short .16	; 64FB8
.15:
add eax, unk_E9E7C	; 64FBA
.16:
mov ebx, ecx	; 64FBF
call FillDressedSlots	; 64FC1
test ax, ax	; 64FC6
jge short PickForLineSlot.11	; 64FC9
movsx ebx, si	; 64FCB
mov ecx, dword [byte esp-02h]	; 64FCE
sar ecx, 10h	; 64FD2
mov eax, ecx	; 64FD5
shl eax, 2	; 64FD7
sub eax, ecx	; 64FDA
shl eax, 3	; 64FDC
add eax, ecx	; 64FDF
cmp si, byte 1Ch	; 64FE1
jge short .17	; 64FE5
add eax, unk_E9EAE	; 64FE7
jmp near PickForLineSlot.9	; 64FEC
.17:
add eax, unk_E9D1E	; 64FF1
jmp near PickForLineSlot.9	; 64FF6
.18:
cmp cx, byte 52h	; 64FFB
jne near .25	; 64FFF
cmp si, byte 1Ch	; 65005
jge short .19	; 65009
add eax, unk_E9EAE	; 6500B
jmp short .20	; 65010
.19:
add eax, unk_E9D1E	; 65012
.20:
call FillDressedSlots	; 65017
test ax, ax	; 6501C
jge near PickForLineSlot.11	; 6501F
movsx ecx, si	; 65025
mov edx, dword [byte esp-02h]	; 65028
sar edx, 10h	; 6502C
mov eax, edx	; 6502F
shl eax, 2	; 65031
sub eax, edx	; 65034
shl eax, 3	; 65036
add eax, edx	; 65039
cmp si, byte 1Ch	; 6503B
jge short .21	; 6503F
add eax, unk_E9DE6	; 65041
jmp short .22	; 65046
.21:
add eax, unk_E9E7C	; 65048
.22:
mov ebx, ecx	; 6504D
call FillDressedSlots	; 6504F
test ax, ax	; 65054
jge near PickForLineSlot.11	; 65057
movsx ecx, si	; 6505D
mov edx, dword [byte esp-02h]	; 65060
sar edx, 10h	; 65064
mov eax, edx	; 65067
shl eax, 2	; 65069
sub eax, edx	; 6506C
shl eax, 3	; 6506E
add eax, edx	; 65071
cmp si, byte 1Ch	; 65073
jge short .23	; 65077
add eax, unk_E9CEC	; 65079
jmp short .24	; 6507E
.23:
add eax, unk_E9D82	; 65080
.24:
mov ebx, ecx	; 65085
jmp near PickForLineSlot.10	; 65087
.25:
cmp cx, byte 4Ch	; 6508C
jne near .31	; 65090
cmp si, byte 1Ch	; 65096
jge short .26	; 6509A
add eax, unk_E9DE6	; 6509C
jmp short .27	; 650A1
.26:
add eax, unk_E9E7C	; 650A3
.27:
call FillDressedSlots	; 650A8
test ax, ax	; 650AD
jge near PickForLineSlot.11	; 650B0
movsx ebx, si	; 650B6
mov ecx, dword [byte esp-02h]	; 650B9
sar ecx, 10h	; 650BD
mov eax, ecx	; 650C0
shl eax, 2	; 650C2
sub eax, ecx	; 650C5
shl eax, 3	; 650C7
add eax, ecx	; 650CA
cmp si, byte 1Ch	; 650CC
jge short .28	; 650D0
add eax, unk_E9EAE	; 650D2
jmp short .29	; 650D7
.28:
add eax, unk_E9D1E	; 650D9
.29:
mov edx, ecx	; 650DE
call FillDressedSlots	; 650E0
test ax, ax	; 650E5
jge near PickForLineSlot.11	; 650E8
movsx ebx, si	; 650EE
mov ecx, dword [byte esp-02h]	; 650F1
sar ecx, 10h	; 650F5
mov eax, ecx	; 650F8
shl eax, 2	; 650FA
sub eax, ecx	; 650FD
shl eax, 3	; 650FF
add eax, ecx	; 65102
cmp si, byte 1Ch	; 65104
jge short .30	; 65108
add eax, unk_E9CEC	; 6510A
jmp near PickForLineSlot.9	; 6510F
.30:
add eax, unk_E9D82	; 65114
jmp near PickForLineSlot.9	; 65119
.31:
mov ecx, dword [byte esp+04h]	; 6511E
.32:
movsx eax, cx	; 65122
movsx dx, byte [dword eax+byte_CD421]	; 65125
cmp dx, si	; 6512D
je short .33	; 65130
mov eax, dword [dword eax+byte_CD421-3]	; 65132
sar eax, 18h	; 65138
movsx di, byte [eax+ebp]	; 6513B
movsx ebx, byte [eax+ebp]	; 65140
movsx edx, si	; 65144
mov eax, dword [byte esp-02h]	; 65147
sar eax, 10h	; 6514B
call CanFillLineSlot	; 6514E
test ax, ax	; 65153
jne near PickForLineSlot.5	; 65156
inc ecx	; 6515C
jmp short PickForLineSlot.32	; 6515D
.33:
cmp word [byte esp+08h], byte 44h	; 6515F
jne short .35	; 65165
cmp si, byte 12h	; 65167
jl short .34	; 6516B
cmp si, byte 1Ch	; 6516D
jge short .34	; 65171
mov edx, dword [byte esp-02h]	; 65173
sar edx, 10h	; 65177
mov eax, edx	; 6517A
shl eax, 2	; 6517C
sub eax, edx	; 6517F
shl eax, 3	; 65181
add eax, edx	; 65184
add eax, unk_E9D50	; 65186
jmp short .37	; 6518B
.34:
mov edx, dword [byte esp-02h]	; 6518D
sar edx, 10h	; 65191
mov eax, edx	; 65194
shl eax, 2	; 65196
sub eax, edx	; 65199
shl eax, 3	; 6519B
add eax, edx	; 6519E
add eax, byte_E9DB4	; 651A0
jmp short .37	; 651A5
.35:
cmp si, byte 1Ch	; 651A7
jge short .36	; 651AB
mov edx, dword [byte esp-02h]	; 651AD
sar edx, 10h	; 651B1
mov eax, edx	; 651B4
shl eax, 2	; 651B6
sub eax, edx	; 651B9
shl eax, 3	; 651BB
add eax, edx	; 651BE
add eax, byte_E9E4A	; 651C0
jmp short .37	; 651C5
.36:
mov edx, dword [byte esp-02h]	; 651C7
sar edx, 10h	; 651CB
mov eax, edx	; 651CE
shl eax, 2	; 651D0
sub eax, edx	; 651D3
shl eax, 3	; 651D5
add eax, edx	; 651D8
add eax, unk_E9EE0	; 651DA
.37:
mov ebp, eax	; 651DF
xor ecx, ecx	; 651E1
jmp short .39	; 651E3
.38:
movsx eax, cx	; 651E5
movsx di, byte [eax+ebp]	; 651E8
test di, di	; 651ED
jl short .40	; 651F0
movsx ebx, di	; 651F2
movsx edx, si	; 651F5
mov eax, dword [byte esp-02h]	; 651F8
sar eax, 10h	; 651FC
call CanFillLineSlot	; 651FF
test ax, ax	; 65204
jne near PickForLineSlot.5	; 65207
inc ecx	; 6520D
.39:
cmp cx, byte 19h	; 6520E
jl short PickForLineSlot.38	; 65212
.40:
cmp word [byte esp+08h], byte 44h	; 65214
jne short .42	; 6521A
cmp si, byte 12h	; 6521C
jl short .41	; 65220
cmp si, byte 1Ch	; 65222
jge short .41	; 65226
mov edx, dword [byte esp-02h]	; 65228
sar edx, 10h	; 6522C
mov eax, edx	; 6522F
shl eax, 2	; 65231
sub eax, edx	; 65234
shl eax, 3	; 65236
add eax, edx	; 65239
add eax, byte_E9E4A	; 6523B
jmp short .44	; 65240
.41:
mov edx, dword [byte esp-02h]	; 65242
sar edx, 10h	; 65246
mov eax, edx	; 65249
shl eax, 2	; 6524B
sub eax, edx	; 6524E
shl eax, 3	; 65250
add eax, edx	; 65253
add eax, unk_E9EE0	; 65255
jmp short .44	; 6525A
.42:
cmp si, byte 1Ch	; 6525C
jge short .43	; 65260
mov edx, dword [byte esp-02h]	; 65262
sar edx, 10h	; 65266
mov eax, edx	; 65269
shl eax, 2	; 6526B
sub eax, edx	; 6526E
shl eax, 3	; 65270
add eax, edx	; 65273
add eax, unk_E9D50	; 65275
jmp short .44	; 6527A
.43:
mov edx, dword [byte esp-02h]	; 6527C
sar edx, 10h	; 65280
mov eax, edx	; 65283
shl eax, 2	; 65285
sub eax, edx	; 65288
shl eax, 3	; 6528A
add eax, edx	; 6528D
add eax, byte_E9DB4	; 6528F
.44:
mov ebp, eax	; 65294
xor ecx, ecx	; 65296
jmp short .46	; 65298
.45:
movsx eax, cx	; 6529A
movsx di, byte [eax+ebp]	; 6529D
test di, di	; 652A2
jl short .47	; 652A5
movsx ebx, di	; 652A7
movsx edx, si	; 652AA
mov eax, dword [byte esp-02h]	; 652AD
sar eax, 10h	; 652B1
call CanFillLineSlot	; 652B4
test ax, ax	; 652B9
jne near PickForLineSlot.5	; 652BC
inc ecx	; 652C2
.46:
cmp cx, byte 19h	; 652C3
jl short PickForLineSlot.45	; 652C7
.47:
xor esi, esi	; 652C9
.48:
mov eax, esi	; 652CB
add esp, byte 0Ch	; 652CD
lines_popx2:
pop ebp	; 652D0
pop edi	; 652D1
pop esi	; 652D2
pop ecx	; 652D3
pop ebx	; 652D4
ret	; 652D5
; C: src/engine/lines/PickGoalie.c
%ifdef CBUILD
%include "c/engine/lines/PickGoalie.inc"
%else
PickGoalie:
push dword 14h	; 652D6
call __CHK	; 652DB
push ecx	; 652E0
push esi	; 652E1
push edi	; 652E2
sub esp, byte 4	; 652E3
mov edi, eax	; 652E6
mov dword [esp], ebx	; 652E8
test ax, ax	; 652EB
je short .1	; 652EE
mov eax, awlinetab	; 652F0
jmp short .2	; 652F5
.1:
mov eax, hmlinetab	; 652F7
.2:
mov ebx, eax	; 652FC
cmp dx, byte 24h	; 652FE
jne short .3	; 65302
mov dl, byte [byte eax+025h]	; 65304
mov byte [byte eax+024h], dl	; 65307
.3:
mov edx, 19h	; 6530A
jmp near .11	; 6530F
.4:
movsx ax, byte [byte ebx+024h]	; 65314
cmp dx, ax	; 65319
je near .10	; 6531C
movsx ax, byte [byte ebx+025h]	; 65322
cmp dx, ax	; 65327
je near .10	; 6532A
movsx ecx, di	; 65330
mov esi, ecx	; 65333
shl esi, 4	; 65335
add esi, ecx	; 65338
shl esi, 4	; 6533A
add esi, ecx	; 6533D
shl esi, 2	; 6533F
movsx ecx, dx	; 65342
mov eax, ecx	; 65345
shl eax, 2	; 65347
add eax, ecx	; 6534A
shl eax, 3	; 6534C
sub eax, ecx	; 6534F
add eax, esi	; 65351
movzx si, byte [dword eax+hmroster]	; 65353
xor ecx, ecx	; 6535B
mov cl, byte [dword eax+hmroster]	; 6535D
cmp byte [dword ecx+byte_CD418], 1	; 65363
jne short .6	; 6536A
.5:
mov byte [byte ebx+025h], dl	; 6536C
jmp short .x	; 6536F
.6:
cmp si, byte 2	; 65371
jne short .10	; 65375
cmp word [esp], byte 0	; 65377
je short .10	; 6537C
mov byte [dword eax+hmroster], 3	; 6537E
mov ecx, 28h	; 65385
jmp short .9	; 6538A
.7:
movsx eax, cx	; 6538C
add eax, ebx	; 6538F
movsx si, byte [eax]	; 65391
cmp si, dx	; 65395
jne short .8	; 65398
mov byte [eax], 64h	; 6539A
.8:
inc ecx	; 6539D
.9:
cmp cx, byte 30h	; 6539E
jl short PickGoalie.7	; 653A2
jmp short PickGoalie.5	; 653A4
.10:
inc edx	; 653A6
.11:
cmp dx, byte 1Ch	; 653A7
jl near PickGoalie.4	; 653AB
mov al, byte [byte ebx+024h]	; 653B1
mov byte [byte ebx+025h], al	; 653B4
.x:
add esp, byte 4	; 653B7
pop edi	; 653BA
pop esi	; 653BB
pop ecx	; 653BC
ret	; 653BD
%endif ; C
; C: src/engine/lines/PickForLineSlot.c (PickExtraSkater)
%ifdef CBUILD
%include "c/engine/lines/PickForLineSlot.PickExtraSkater.inc"
%else
PickExtraSkater:
push dword 20h	; 653BE
call __CHK	; 653C3
push ebx	; 653C8
push ecx	; 653C9
push esi	; 653CA
push edi	; 653CB
push ebp	; 653CC
sub esp, byte 8	; 653CD
mov edi, eax	; 653D0
mov ebx, edx	; 653D2
test ax, ax	; 653D4
je short .1	; 653D7
mov edx, awlinetab	; 653D9
jmp short .2	; 653DE
.1:
mov edx, hmlinetab	; 653E0
.2:
mov esi, edx	; 653E5
movsx eax, di	; 653E7
mov ecx, eax	; 653EA
shl eax, 2	; 653EC
sub eax, ecx	; 653EF
shl eax, 3	; 653F1
add eax, ecx	; 653F4
mov ebp, byte_E9E4A	; 653F6
add ebp, eax	; 653FB
cmp bx, byte 26h	; 653FD
jne near .7	; 65401
movsx bx, byte [byte edx+027h]	; 65407
mov eax, ecx	; 6540C
shl eax, 4	; 6540E
add eax, ecx	; 65411
shl eax, 4	; 65413
add eax, ecx	; 65416
shl eax, 2	; 65418
mov dword [esp], eax	; 6541B
mov eax, dword [byte edx+024h]	; 6541E
sar eax, 18h	; 65421
mov dword [byte esp+04h], eax	; 65424
shl eax, 2	; 65428
mov ecx, dword [byte esp+04h]	; 6542B
add eax, ecx	; 6542F
shl eax, 3	; 65431
sub eax, ecx	; 65434
add eax, dword [esp]	; 65436
mov al, byte [dword eax+hmroster]	; 65439
and eax, 0FFh	; 6543F
cmp byte [dword eax+byte_CD418], 1	; 65444
jne short .3	; 6544B
mov byte [byte edx+026h], bl	; 6544D
jmp short .7	; 65450
.3:
xor edx, edx	; 65452
jmp short .6	; 65454
.4:
movsx eax, dx	; 65456
movsx bx, byte [eax+ebp]	; 65459
test bx, bx	; 6545E
jl short .7	; 65461
movsx ecx, di	; 65463
mov eax, ecx	; 65466
shl eax, 4	; 65468
add eax, ecx	; 6546B
shl eax, 4	; 6546D
add eax, ecx	; 65470
shl eax, 2	; 65472
mov dword [byte esp+04h], eax	; 65475
movsx ecx, bx	; 65479
mov eax, ecx	; 6547C
shl eax, 2	; 6547E
add eax, ecx	; 65481
shl eax, 3	; 65483
sub eax, ecx	; 65486
add eax, dword [byte esp+04h]	; 65488
mov al, byte [dword eax+hmroster]	; 6548C
and eax, 0FFh	; 65492
cmp byte [dword eax+byte_CD418], 1	; 65497
jne short .5	; 6549E
mov byte [byte esi+026h], bl	; 654A0
jmp short .7	; 654A3
.5:
inc edx	; 654A5
.6:
cmp dx, byte 19h	; 654A6
jl short PickExtraSkater.4	; 654AA
.7:
movsx edx, di	; 654AC
mov eax, edx	; 654AF
shl eax, 2	; 654B1
sub eax, edx	; 654B4
shl eax, 3	; 654B6
add eax, edx	; 654B9
mov ebp, byte_E9E4A	; 654BB
add ebp, eax	; 654C0
xor edx, edx	; 654C2
jmp short .10	; 654C4
.8:
movsx eax, dx	; 654C6
movsx bx, byte [eax+ebp]	; 654C9
test bx, bx	; 654CE
jl short .11	; 654D1
movsx ecx, di	; 654D3
mov eax, ecx	; 654D6
shl eax, 4	; 654D8
add eax, ecx	; 654DB
shl eax, 4	; 654DD
add eax, ecx	; 654E0
shl eax, 2	; 654E2
mov dword [byte esp+04h], eax	; 654E5
movsx ecx, bx	; 654E9
mov eax, ecx	; 654EC
shl eax, 2	; 654EE
add eax, ecx	; 654F1
shl eax, 3	; 654F3
sub eax, ecx	; 654F6
add eax, dword [byte esp+04h]	; 654F8
mov al, byte [dword eax+hmroster]	; 654FC
and eax, 0FFh	; 65502
cmp byte [dword eax+byte_CD418], 1	; 65507
jne short .9	; 6550E
movsx ax, byte [byte esi+026h]	; 65510
cmp bx, ax	; 65515
je short .9	; 65518
mov byte [byte esi+027h], bl	; 6551A
jmp short .11	; 6551D
.9:
inc edx	; 6551F
.10:
cmp dx, byte 19h	; 65520
jl short PickExtraSkater.8	; 65524
.11:
add esp, byte 8	; 65526
jmp near lines_popx2	; 65529
%endif ; C
; C: src/engine/lines/RefillLineSlots.c
%ifdef CBUILD
%include "c/engine/lines/RefillLineSlots.inc"
%else
RefillLineSlots:
push dword 18h	; 6552E
call __CHK	; 65533
push esi	; 65538
push edi	; 65539
push ebp	; 6553A
sub esp, byte 4	; 6553B
push eax	; 6553E
mov esi, edx	; 6553F
mov edi, ebx	; 65541
mov dword [byte esp+04h], ecx	; 65543
test ax, ax	; 65547
je short .1	; 6554A
mov eax, awlinetab	; 6554C
jmp short .2	; 65551
.1:
mov eax, hmlinetab	; 65553
.2:
mov ebp, eax	; 65558
movsx ebx, si	; 6555A
movsx ecx, byte [ebx+eax]	; 6555D
mov ebx, dword [byte esp-02h]	; 65561
sar ebx, 10h	; 65565
mov eax, ebx	; 65568
shl eax, 2	; 6556A
sub eax, ebx	; 6556D
shl eax, 3	; 6556F
add eax, ebx	; 65572
xor dl, dl	; 65574
mov byte [dword ecx+eax+byte_E9E18], dl	; 65576
.3:
cmp di, word [byte esp+04h]	; 6557D
jge short .x	; 65582
movsx ecx, si	; 65584
mov ebx, dword [byte esp-02h]	; 65587
sar ebx, 10h	; 6558B
mov edx, ecx	; 6558E
mov eax, ebx	; 65590
call PickForLineSlot	; 65592
mov edx, eax	; 65597
lea eax, [ecx+ebp]	; 65599
mov byte [eax], dl	; 6559C
cmp si, byte 12h	; 6559E
jge short .4	; 655A2
movsx ecx, dl	; 655A4
mov eax, ebx	; 655A7
shl eax, 2	; 655A9
sub eax, ebx	; 655AC
shl eax, 3	; 655AE
add eax, ebx	; 655B1
xor dh, dh	; 655B3
mov byte [dword ecx+eax+byte_E9E18], dh	; 655B5
.4:
inc edi	; 655BC
add esi, dword [byte esp+018h]	; 655BD
jmp short RefillLineSlots.3	; 655C1
.x:
add esp, byte 8	; 655C3
pop ebp	; 655C6
pop edi	; 655C7
pop esi	; 655C8
ret 4	; 655C9
%endif ; C
RemoveFromLines:
push dword 28h	; 655CC
call __CHK	; 655D1
push ebx	; 655D6
push ecx	; 655D7
push esi	; 655D8
push edi	; 655D9
sub esp, byte 8	; 655DA
push eax	; 655DD
push edx	; 655DE
test ax, ax	; 655DF
je short .1	; 655E2
mov esi, awlinetab	; 655E4
jmp short .2	; 655E9
.1:
mov esi, hmlinetab	; 655EB
.2:
mov edx, dword [byte esp+02h]	; 655F0
sar edx, 10h	; 655F4
mov ebx, edx	; 655F7
shl ebx, 4	; 655F9
add ebx, edx	; 655FC
shl ebx, 4	; 655FE
add ebx, edx	; 65601
shl ebx, 2	; 65603
mov edx, dword [byte esp-02h]	; 65606
sar edx, 10h	; 6560A
mov eax, edx	; 6560D
shl eax, 2	; 6560F
add eax, edx	; 65612
shl eax, 3	; 65614
sub eax, edx	; 65617
add eax, ebx	; 65619
mov dl, byte [dword eax+byte_DB3AE]	; 6561B
cmp dl, 44h	; 65621
jne near .6	; 65624
xor edi, edi	; 6562A
mov word [word_E9F14], di	; 6562C
mov word [byte esp+0Ch], di	; 65633
jmp short .5	; 65638
.3:
mov ebx, dword [byte esp+02h]	; 6563A
sar ebx, 10h	; 6563E
mov eax, ebx	; 65641
shl eax, 2	; 65643
sub eax, ebx	; 65646
shl eax, 3	; 65648
add eax, ebx	; 6564B
mov edx, dword [byte esp+0Ah]	; 6564D
sar edx, 10h	; 65651
movsx ax, byte [dword edx+eax+byte_E9DB4]	; 65654
test ax, ax	; 6565D
jl near .10	; 65660
mov edx, ebx	; 65666
shl edx, 4	; 65668
add edx, ebx	; 6566B
shl edx, 4	; 6566D
add ebx, edx	; 65670
shl ebx, 2	; 65672
movsx edx, ax	; 65675
mov eax, edx	; 65678
shl eax, 2	; 6567A
add eax, edx	; 6567D
shl eax, 3	; 6567F
sub eax, edx	; 65682
mov al, byte [dword ebx+eax+hmroster]	; 65684
and eax, 0FFh	; 6568B
cmp byte [dword eax+byte_CD418], 1	; 65690
jne short .4	; 65697
inc word [word_E9F14]	; 65699
.4:
inc word [byte esp+0Ch]	; 656A0
.5:
cmp word [byte esp+0Ch], byte 19h	; 656A5
jl short RemoveFromLines.3	; 656AB
jmp near .10	; 656AD
.6:
cmp dl, 47h	; 656B2
je near .10	; 656B5
xor ebx, ebx	; 656BB
mov word [word_E9F12], bx	; 656BD
mov word [byte esp+0Ch], bx	; 656C4
jmp short .9	; 656C9
.7:
mov ebx, dword [byte esp+02h]	; 656CB
sar ebx, 10h	; 656CF
mov eax, ebx	; 656D2
shl eax, 2	; 656D4
sub eax, ebx	; 656D7
shl eax, 3	; 656D9
lea edx, [ebx+eax]	; 656DC
mov eax, dword [byte esp+0Ah]	; 656DF
sar eax, 10h	; 656E3
movsx ax, byte [dword edx+eax+byte_E9E4A]	; 656E6
test ax, ax	; 656EF
jl short .10	; 656F2
mov edx, ebx	; 656F4
shl edx, 4	; 656F6
add edx, ebx	; 656F9
shl edx, 4	; 656FB
add ebx, edx	; 656FE
shl ebx, 2	; 65700
movsx edx, ax	; 65703
mov eax, edx	; 65706
shl eax, 2	; 65708
add eax, edx	; 6570B
shl eax, 3	; 6570D
sub eax, edx	; 65710
mov al, byte [dword ebx+eax+hmroster]	; 65712
and eax, 0FFh	; 65719
cmp byte [dword eax+byte_CD418], 1	; 6571E
jne short .8	; 65725
inc word [word_E9F12]	; 65727
.8:
inc word [byte esp+0Ch]	; 6572E
.9:
cmp word [byte esp+0Ch], byte 19h	; 65733
jl short RemoveFromLines.7	; 65739
.10:
xor edi, edi	; 6573B
mov word [byte esp+0Ch], di	; 6573D
jmp short .15	; 65742
.11:
xor edx, edx	; 65744
mov dword [byte esp+08h], edx	; 65746
jmp short .14	; 6574A
.12:
movsx ax, byte [esi]	; 6574C
inc esi	; 65750
cmp ax, word [esp]	; 65751
jne short .13	; 65755
push byte 3	; 65757
mov ebx, dword [byte esp+0Eh]	; 65759
sar ebx, 10h	; 6575D
movsx edx, di	; 65760
mov eax, dword [byte esp+06h]	; 65763
sar eax, 10h	; 65767
mov ecx, 4	; 6576A
call RefillLineSlots	; 6576F
.13:
inc edi	; 65774
inc dword [byte esp+08h]	; 65775
.14:
cmp word [byte esp+08h], byte 3	; 65779
jl short RemoveFromLines.12	; 6577F
inc word [byte esp+0Ch]	; 65781
.15:
cmp word [byte esp+0Ch], byte 4	; 65786
jl short RemoveFromLines.11	; 6578C
xor eax, eax	; 6578E
mov word [byte esp+0Ch], ax	; 65790
jmp short .20	; 65795
.16:
xor edx, edx	; 65797
mov dword [byte esp+08h], edx	; 65799
jmp short .19	; 6579D
.17:
movsx ax, byte [esi]	; 6579F
inc esi	; 657A3
cmp ax, word [esp]	; 657A4
jne short .18	; 657A8
push byte 2	; 657AA
mov ebx, dword [byte esp+0Eh]	; 657AC
sar ebx, 10h	; 657B0
movsx edx, di	; 657B3
mov eax, dword [byte esp+06h]	; 657B6
sar eax, 10h	; 657BA
mov ecx, 3	; 657BD
call RefillLineSlots	; 657C2
.18:
inc edi	; 657C7
inc dword [byte esp+08h]	; 657C8
.19:
cmp word [byte esp+08h], byte 2	; 657CC
jl short RemoveFromLines.17	; 657D2
inc word [byte esp+0Ch]	; 657D4
.20:
cmp word [byte esp+0Ch], byte 3	; 657D9
jl short RemoveFromLines.16	; 657DF
xor eax, eax	; 657E1
mov word [byte esp+0Ch], ax	; 657E3
jmp short .25	; 657E8
.21:
xor edx, edx	; 657EA
mov dword [byte esp+08h], edx	; 657EC
jmp short .24	; 657F0
.22:
movsx ax, byte [esi]	; 657F2
inc esi	; 657F6
cmp ax, word [esp]	; 657F7
jne short .23	; 657FB
push byte 5	; 657FD
mov ebx, dword [byte esp+0Eh]	; 657FF
sar ebx, 10h	; 65803
movsx edx, di	; 65806
mov eax, dword [byte esp+06h]	; 65809
sar eax, 10h	; 6580D
mov ecx, 2	; 65810
call RefillLineSlots	; 65815
.23:
inc edi	; 6581A
inc dword [byte esp+08h]	; 6581B
.24:
cmp word [byte esp+08h], byte 5	; 6581F
jl short RemoveFromLines.22	; 65825
inc word [byte esp+0Ch]	; 65827
.25:
cmp word [byte esp+0Ch], byte 2	; 6582C
jl short RemoveFromLines.21	; 65832
xor eax, eax	; 65834
mov word [byte esp+0Ch], ax	; 65836
jmp short .30	; 6583B
.26:
xor edx, edx	; 6583D
mov dword [byte esp+08h], edx	; 6583F
jmp short .29	; 65843
.27:
movsx ax, byte [esi]	; 65845
inc esi	; 65849
cmp ax, word [esp]	; 6584A
jne short .28	; 6584E
push byte 4	; 65850
mov ebx, dword [byte esp+0Eh]	; 65852
sar ebx, 10h	; 65856
movsx edx, di	; 65859
mov eax, dword [byte esp+06h]	; 6585C
sar eax, 10h	; 65860
mov ecx, 2	; 65863
call RefillLineSlots	; 65868
.28:
inc edi	; 6586D
inc dword [byte esp+08h]	; 6586E
.29:
cmp word [byte esp+08h], byte 4	; 65872
jl short RemoveFromLines.27	; 65878
inc word [byte esp+0Ch]	; 6587A
.30:
cmp word [byte esp+0Ch], byte 2	; 6587F
jl short RemoveFromLines.26	; 65885
xor eax, eax	; 65887
mov word [byte esp+0Ch], ax	; 65889
jmp short .33	; 6588E
.31:
movsx ax, byte [esi]	; 65890
inc esi	; 65894
cmp ax, word [esp]	; 65895
jne short .32	; 65899
movsx edx, di	; 6589B
mov eax, dword [byte esp+02h]	; 6589E
sar eax, 10h	; 658A2
xor ebx, ebx	; 658A5
call PickGoalie	; 658A7
.32:
inc edi	; 658AC
inc word [byte esp+0Ch]	; 658AD
.33:
cmp word [byte esp+0Ch], byte 2	; 658B2
jl short RemoveFromLines.31	; 658B8
xor ecx, ecx	; 658BA
mov word [byte esp+0Ch], cx	; 658BC
jmp short .36	; 658C1
.34:
movsx ax, byte [esi]	; 658C3
inc esi	; 658C7
cmp ax, word [esp]	; 658C8
jne short .35	; 658CC
movsx edx, di	; 658CE
mov eax, dword [byte esp+02h]	; 658D1
sar eax, 10h	; 658D5
call PickExtraSkater	; 658D8
.35:
inc edi	; 658DD
inc word [byte esp+0Ch]	; 658DE
.36:
cmp word [byte esp+0Ch], byte 2	; 658E3
jl short RemoveFromLines.34	; 658E9
add esp, byte 10h	; 658EB
pop edi	; 658EE
pop esi	; 658EF
pop ecx	; 658F0
pop ebx	; 658F1
ret	; 658F2
; C: src/engine/lines/BuildDefaultLines.c (SetupTeamLines)
%ifdef CBUILD
%include "c/engine/lines/BuildDefaultLines.SetupTeamLines.inc"
%else
SetupTeamLines:
push dword 1Ch	; 658F3
call __CHK	; 658F8
push ebx	; 658FD
push ecx	; 658FE
push edx	; 658FF
push esi	; 65900
push edi	; 65901
push ebp	; 65902
mov esi, eax	; 65903
test ax, ax	; 65905
je short .1	; 65908
mov ebp, awlinetab	; 6590A
jmp short .2	; 6590F
.1:
mov ebp, hmlinetab	; 65911
.2:
xor edx, edx	; 65916
mov word [word_E9F14], dx	; 65918
xor ecx, ecx	; 6591F
jmp short .5	; 65921
.3:
movsx edi, si	; 65923
mov edx, edi	; 65926
shl edx, 2	; 65928
sub edx, edi	; 6592B
shl edx, 3	; 6592D
add edx, edi	; 65930
movsx eax, cx	; 65932
movsx dx, byte [dword edx+eax+byte_E9DB4]	; 65935
test dx, dx	; 6593E
jl short .6	; 65941
mov ebx, edi	; 65943
shl edi, 4	; 65945
add edi, ebx	; 65948
shl edi, 4	; 6594A
add edi, ebx	; 6594D
shl edi, 2	; 6594F
movsx ebx, dx	; 65952
mov eax, ebx	; 65955
shl eax, 2	; 65957
add eax, ebx	; 6595A
shl eax, 3	; 6595C
sub eax, ebx	; 6595F
mov al, byte [dword edi+eax+hmroster]	; 65961
and eax, 0FFh	; 65968
cmp byte [dword eax+byte_CD418], 1	; 6596D
jne short .4	; 65974
inc word [word_E9F14]	; 65976
.4:
inc ecx	; 6597D
.5:
cmp cx, byte 19h	; 6597E
jl short SetupTeamLines.3	; 65982
.6:
xor ecx, ecx	; 65984
mov word [word_E9F12], cx	; 65986
jmp short .9	; 6598D
.7:
movsx edi, si	; 6598F
mov eax, edi	; 65992
shl eax, 2	; 65994
sub eax, edi	; 65997
shl eax, 3	; 65999
add eax, edi	; 6599C
movsx edx, cx	; 6599E
movsx dx, byte [dword edx+eax+byte_E9E4A]	; 659A1
test dx, dx	; 659AA
jl short .10	; 659AD
mov ebx, edi	; 659AF
shl edi, 4	; 659B1
add edi, ebx	; 659B4
shl edi, 4	; 659B6
add edi, ebx	; 659B9
shl edi, 2	; 659BB
movsx ebx, dx	; 659BE
mov eax, ebx	; 659C1
shl eax, 2	; 659C3
add eax, ebx	; 659C6
shl eax, 3	; 659C8
sub eax, ebx	; 659CB
mov al, byte [dword edi+eax+hmroster]	; 659CD
and eax, 0FFh	; 659D4
cmp byte [dword eax+byte_CD418], 1	; 659D9
jne short .8	; 659E0
inc word [word_E9F12]	; 659E2
.8:
inc ecx	; 659E9
.9:
cmp cx, byte 19h	; 659EA
jl short SetupTeamLines.7	; 659EE
.10:
mov ax, word [word_E9F12]	; 659F0
mov dx, word [word_E9F14]	; 659F6
add eax, edx	; 659FD
mov word [dword_E9F16], ax	; 659FF
xor ecx, ecx	; 65A05
jmp short .12	; 65A07
.11:
movsx eax, cx	; 65A09
xor edx, edx	; 65A0C
mov dword [nosplit eax*4+dword_E9C24], edx	; 65A0E
inc ecx	; 65A15
.12:
cmp cx, byte 19h	; 65A16
jl short SetupTeamLines.11	; 65A1A
xor ecx, ecx	; 65A1C
mov edi, 1	; 65A1E
jmp short .14	; 65A23
.13:
movsx eax, cx	; 65A25
movsx eax, byte [eax+ebp]	; 65A28
mov dword [nosplit eax*4+dword_E9C24], edi	; 65A2C
inc ecx	; 65A33
.14:
cmp cx, byte 24h	; 65A34
jl short SetupTeamLines.13	; 65A38
mov eax, dword [byte ebp+024h]	; 65A3A
sar eax, 18h	; 65A3D
mov ebx, 1	; 65A40
mov dword [nosplit eax*4+dword_E9C24], ebx	; 65A45
mov eax, dword [byte ebp+023h]	; 65A4C
sar eax, 18h	; 65A4F
mov dword [nosplit eax*4+dword_E9C24], ebx	; 65A52
xor ecx, ecx	; 65A59
jmp short .18	; 65A5B
.15:
movsx ebx, si	; 65A5D
mov edi, ebx	; 65A60
shl edi, 4	; 65A62
add edi, ebx	; 65A65
shl edi, 4	; 65A67
add edi, ebx	; 65A6A
shl edi, 2	; 65A6C
movsx edx, cx	; 65A6F
mov eax, edx	; 65A72
shl eax, 2	; 65A74
add eax, edx	; 65A77
shl eax, 3	; 65A79
sub eax, edx	; 65A7C
mov al, byte [dword edi+eax+hmroster]	; 65A7E
xor ah, ah	; 65A85
cmp dword [nosplit edx*4+dword_E9C24], byte 0	; 65A87
je short .17	; 65A8F
test ax, ax	; 65A91
je short .16	; 65A94
cmp ax, 1	; 65A96
jne short .17	; 65A9A
.16:
movsx edx, cx	; 65A9C
movsx eax, si	; 65A9F
call RemoveFromLines	; 65AA2
.17:
inc ecx	; 65AA7
.18:
cmp cx, byte 19h	; 65AA8
jl short SetupTeamLines.15	; 65AAC
mov ecx, 24h	; 65AAE
jmp short .22	; 65AB3
.19:
movsx eax, cx	; 65AB5
movsx ebx, byte [eax+ebp]	; 65AB8
mov edx, ebx	; 65ABC
shl edx, 2	; 65ABE
add edx, ebx	; 65AC1
shl edx, 3	; 65AC3
sub edx, ebx	; 65AC6
movsx ebx, si	; 65AC8
mov eax, ebx	; 65ACB
shl eax, 4	; 65ACD
add eax, ebx	; 65AD0
shl eax, 4	; 65AD2
add eax, ebx	; 65AD5
mov al, byte [dword edx+eax*4+hmroster]	; 65AD7
xor ah, ah	; 65ADE
test ax, ax	; 65AE0
je short .20	; 65AE3
cmp ax, 1	; 65AE5
jne short .21	; 65AE9
.20:
movsx edx, cx	; 65AEB
movsx eax, si	; 65AEE
mov ebx, 1	; 65AF1
call PickGoalie	; 65AF6
.21:
inc ecx	; 65AFB
.22:
cmp cx, byte 25h	; 65AFC
jl short SetupTeamLines.19	; 65B00
xor ecx, ecx	; 65B02
jmp short .24	; 65B04
.23:
movsx ebx, si	; 65B06
mov eax, ebx	; 65B09
shl eax, 2	; 65B0B
sub eax, ebx	; 65B0E
shl eax, 3	; 65B10
add eax, ebx	; 65B13
movsx edx, cx	; 65B15
cmp byte [dword edx+eax+byte_E9E18], 1	; 65B18
sete dl	; 65B20
movsx ebx, si	; 65B23
mov eax, ebx	; 65B26
shl eax, 2	; 65B28
sub eax, ebx	; 65B2B
shl eax, 3	; 65B2D
add ebx, eax	; 65B30
movsx eax, cx	; 65B32
mov byte [dword ebx+eax+byte_E9E18], dl	; 65B35
inc ecx	; 65B3C
.24:
cmp cx, byte 19h	; 65B3D
jl short SetupTeamLines.23	; 65B41
jmp near lines_popx	; 65B43
%endif ; C
; C: src/engine/lines/NormalizeDressFlags.c
%ifdef CBUILD
%include "c/engine/lines/NormalizeDressFlags.inc"
%else
NormalizeDressFlags:
push dword 0Ch	; 65B48
call __CHK	; 65B4D
push ebx	; 65B52
push edx	; 65B53
xor eax, eax	; 65B54
.1:
mov dh, byte [dword eax+byte_E9E18]	; 65B56
cmp dh, 1	; 65B5C
sete dl	; 65B5F
mov byte [dword eax+byte_E9E18], dl	; 65B62
mov bl, byte [dword eax+byte_E9E31]	; 65B68
cmp bl, 1	; 65B6E
sete dl	; 65B71
mov byte [dword eax+byte_E9E31], dl	; 65B74
inc eax	; 65B7A
cmp eax, byte 19h	; 65B7B
jl short NormalizeDressFlags.1	; 65B7E
pop edx	; 65B80
pop ebx	; 65B81
ret	; 65B82
%endif ; C
; C: src/engine/lines/BuildDefaultLines.c (CanRemovePlayer)
%ifdef CBUILD
%include "c/engine/lines/BuildDefaultLines.CanRemovePlayer.inc"
%else
CanRemovePlayer:
push dword 24h	; 65B83
call __CHK	; 65B88
push ebx	; 65B8D
push ecx	; 65B8E
push edx	; 65B8F
push esi	; 65B90
push edi	; 65B91
push ebp	; 65B92
sub esp, byte 8	; 65B93
mov ebp, eax	; 65B96
xor edx, edx	; 65B98
mov dword [byte esp+04h], edx	; 65B9A
test byte [byte eax+044h], 40h	; 65B9E
setne al	; 65BA2
xor ah, ah	; 65BA5
mov edi, eax	; 65BA7
xor ecx, ecx	; 65BA9
jmp near .5	; 65BAB
.1:
movsx esi, di	; 65BB0
mov eax, esi	; 65BB3
shl eax, 2	; 65BB5
sub eax, esi	; 65BB8
shl eax, 3	; 65BBA
add esi, eax	; 65BBD
movsx eax, dx	; 65BBF
movsx bx, byte [dword esi+eax+byte_E9DB4]	; 65BC2
test bx, bx	; 65BCB
jl short .6	; 65BCE
movsx ax, byte [byte ebp+047h]	; 65BD0
cmp bx, ax	; 65BD5
jne short .2	; 65BD8
mov dword [byte esp+04h], 1	; 65BDA
.2:
movsx esi, di	; 65BE2
mov eax, esi	; 65BE5
shl eax, 4	; 65BE7
add eax, esi	; 65BEA
shl eax, 4	; 65BEC
add eax, esi	; 65BEF
shl eax, 2	; 65BF1
mov dword [esp], eax	; 65BF4
movsx esi, bx	; 65BF7
mov eax, esi	; 65BFA
shl eax, 2	; 65BFC
add eax, esi	; 65BFF
shl eax, 3	; 65C01
sub eax, esi	; 65C04
add eax, dword [esp]	; 65C06
mov al, byte [dword eax+hmroster]	; 65C09
xor ah, ah	; 65C0F
cmp ax, 4	; 65C11
je short .3	; 65C15
cmp ax, 3	; 65C17
jne short .4	; 65C1B
.3:
inc ecx	; 65C1D
.4:
inc edx	; 65C1E
.5:
cmp dx, byte 19h	; 65C1F
jl short CanRemovePlayer.1	; 65C23
.6:
cmp word [byte esp+04h], byte 0	; 65C25
je short .7	; 65C2B
cmp cx, byte 2	; 65C2D
jmp short .13	; 65C31
.7:
xor ecx, ecx	; 65C33
xor edx, edx	; 65C35
jmp short .11	; 65C37
.8:
movsx ebp, di	; 65C39
mov eax, ebp	; 65C3C
shl eax, 2	; 65C3E
sub eax, ebp	; 65C41
shl eax, 3	; 65C43
add eax, ebp	; 65C46
movsx esi, dx	; 65C48
movsx bx, byte [dword esi+eax+byte_E9E4A]	; 65C4B
test bx, bx	; 65C54
jl short .12	; 65C57
mov esi, ebp	; 65C59
shl ebp, 4	; 65C5B
add ebp, esi	; 65C5E
shl ebp, 4	; 65C60
add ebp, esi	; 65C63
shl ebp, 2	; 65C65
movsx esi, bx	; 65C68
mov eax, esi	; 65C6B
shl eax, 2	; 65C6D
add eax, esi	; 65C70
shl eax, 3	; 65C72
sub eax, esi	; 65C75
mov al, byte [dword eax+ebp+hmroster]	; 65C77
xor ah, ah	; 65C7E
cmp ax, 4	; 65C80
je short .9	; 65C84
cmp ax, 3	; 65C86
jne short .10	; 65C8A
.9:
inc ecx	; 65C8C
.10:
inc edx	; 65C8D
.11:
cmp dx, byte 19h	; 65C8E
jl short CanRemovePlayer.8	; 65C92
.12:
cmp cx, byte 4	; 65C94
.13:
setg al	; 65C98
and eax, 0FFh	; 65C9B
add esp, byte 8	; 65CA0
jmp near lines_popx	; 65CA3
%endif ; C
