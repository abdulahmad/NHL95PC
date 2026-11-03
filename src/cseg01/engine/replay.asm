; Recording and stepping instant replay, and the objects at the side of the rink (95G engine/replay95).
bits 32
%include "hockey.inc"
section s_67564 progbits alloc exec nowrite align=1
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
global ReplayRecordReset, ReplayFirstFrame, ReplayPrevFrame, updatereplay, ReplayStep, ReplayStep_popx, DrawRinkSideObjects
; C: src/c/engine/replay/ReplayRecordReset.c
%ifdef CBUILD
%include "c/engine/replay/ReplayRecordReset.inc"
%else
ReplayRecordReset:
push dword 4	; 67564
call __CHK	; 67569
mov word [replaytick], 1	; 6756E
mov word [replaysfx], 0FFFFh	; 67577
ret	; 67580
%endif ; C
; C: src/c/engine/replay/ReplayFirstFrame.c
%ifdef CBUILD
%include "c/engine/replay/ReplayFirstFrame.inc"
%else
ReplayFirstFrame:
push dword 4	; 67581
call __CHK	; 67586
test byte [sflags], 10h	; 6758B
jne short .1	; 67592
mov eax, dword [replaystart]	; 67594
ret	; 67599
.1:
mov eax, dword [recbpr]	; 6759A
ret	; 6759F
%endif ; C
; C: src/c/engine/replay/ReplayPrevFrame.c
%ifdef CBUILD
%include "c/engine/replay/ReplayPrevFrame.inc"
%else
ReplayPrevFrame:
push dword 8	; 675A0
call __CHK	; 675A5
push edx	; 675AA
mov eax, dword [recbpr]	; 675AB
mov edx, dword [replaystart]	; 675B0
cmp eax, edx	; 675B6
jne short .2	; 675B8
test byte [sflags], 10h	; 675BA
je short .1	; 675C1
lea eax, [dword edx+09580h]	; 675C3
pop edx	; 675C9
ret	; 675CA
.1:
mov eax, edx	; 675CB
pop edx	; 675CD
ret	; 675CE
.2:
sub eax, 80h	; 675CF
pop edx	; 675D4
ret	; 675D5
%endif ; C
updatereplay:
push dword 1Ch	; 675D6
call __CHK	; 675DB
push ebx	; 675E0
push ecx	; 675E1
push edx	; 675E2
push esi	; 675E3
push edi	; 675E4
sub esp, byte 4	; 675E5
test byte [gmode], 10h	; 675E8
jne near .x	; 675EF
mov dx, word [replaytick]	; 675F5
inc edx	; 675FC
mov word [replaytick], dx	; 675FD
cmp dx, byte 2	; 67604
jge short .3	; 67608
test byte [gmode2], 4	; 6760A
je short .1	; 67611
mov word [replaysfx], 0FFFFh	; 67613
jmp short .2	; 6761C
.1:
mov ax, word [lastsfx]	; 6761E
mov word [replaysfx], ax	; 67624
.2:
mov word [lastsfx], 0FFFFh	; 6762A
jmp near .x	; 67633
.3:
mov edi, edx	; 67638
sub edi, byte 2	; 6763A
mov word [replaytick], di	; 6763D
test byte [gmode2], 4	; 67644
je short .4	; 6764B
call ReplayPrevFrame	; 6764D
mov dword [recbpr], eax	; 67652
.4:
mov eax, SortCords	; 67657
xor edx, edx	; 6765C
jmp short .6	; 6765E
.5:
mov bx, word [byte eax+Ypos+2]	; 67660
and bh, 3	; 67664
movsx ebx, bx	; 67667
mov ecx, ebx	; 6766A
shl ecx, 0Ah	; 6766C
mov bx, word [byte eax+Xpos+2]	; 6766F
and bh, 3	; 67673
movsx ebx, bx	; 67676
or ecx, ebx	; 67679
mov bx, word [byte eax+012h]	; 6767B
and bh, 7	; 6767F
movsx ebx, bx	; 67682
shl ebx, 14h	; 67685
or ecx, ebx	; 67688
mov bx, word [byte eax+054h]	; 6768A
xor bl, bl	; 6768E
and bh, 8	; 67690
movsx ebx, bx	; 67693
shl ebx, 14h	; 67696
or ecx, ebx	; 67699
mov ebx, dword [recbpr]	; 6769B
mov dword [ebx], ecx	; 676A1
add dword [recbpr], byte 4	; 676A3
inc edx	; 676AA
add eax, 80h	; 676AB
.6:
cmp dx, byte 11h	; 676B0
jl short updatereplay.5	; 676B4
mov eax, SortCords	; 676B6
xor edx, edx	; 676BB
jmp short .8	; 676BD
.7:
mov ebx, dword [recbpr]	; 676BF
lea ecx, [byte ebx+01h]	; 676C5
mov dword [recbpr], ecx	; 676C8
mov cl, byte [byte eax+05Eh]	; 676CE
mov byte [ebx], cl	; 676D1
inc edx	; 676D3
add eax, 80h	; 676D4
.8:
cmp dx, byte 0Ch	; 676D9
jl short updatereplay.7	; 676DD
mov eax, SortCords	; 676DF
xor edx, edx	; 676E4
jmp short .14	; 676E6
.9:
mov bx, word [byte eax+position]	; 676E8
test bx, bx	; 676EC
jge short .10	; 676EF
mov word [regd0], 0Fh	; 676F1
jmp short .11	; 676FA
.10:
mov word [regd0], bx	; 676FC
.11:
add eax, 80h	; 67703
mov si, word [byte eax+position]	; 67708
test si, si	; 6770C
jge short .12	; 6770F
or byte [regd0], 0F0h	; 67711
jmp short .13	; 67718
.12:
mov ebx, esi	; 6771A
shl ebx, 4	; 6771C
or word [regd0], bx	; 6771F
.13:
mov ebx, dword [recbpr]	; 67726
add eax, 80h	; 6772C
lea ecx, [byte ebx+01h]	; 67731
mov dword [recbpr], ecx	; 67734
mov cl, byte [regd0]	; 6773A
mov byte [ebx], cl	; 67740
inc edx	; 67742
.14:
cmp dx, byte 6	; 67743
jl short updatereplay.9	; 67747
mov ebx, dword [puckz]	; 67749
mov eax, dword [recbpr]	; 6774F
lea ecx, [byte eax+01h]	; 67754
mov dword [recbpr], ecx	; 67757
mov dl, byte [ebx]	; 6775D
mov byte [eax], dl	; 6775F
mov eax, dword [recbpr]	; 67761
lea ebx, [byte eax+01h]	; 67766
mov dword [recbpr], ebx	; 67769
mov dl, byte [byte_DFFA6]	; 6776F
mov byte [eax], dl	; 67775
mov eax, dword [recbpr]	; 67777
lea ebx, [byte eax+01h]	; 6777C
mov dword [recbpr], ebx	; 6777F
mov dl, byte [replaysfx]	; 67785
mov byte [eax], dl	; 6778B
mov eax, dword [recbpr]	; 6778D
lea ebx, [byte eax+01h]	; 67792
mov dword [recbpr], ebx	; 67795
mov dl, byte [lastsfx]	; 6779B
mov byte [eax], dl	; 677A1
mov eax, 0FFFFFFFFh	; 677A3
mov word [lastsfx], ax	; 677A8
mov word [replaysfx], ax	; 677AE
mov dl, byte [c2playernum]	; 677B4
and dl, 0Fh	; 677BA
shl dl, 4	; 677BD
mov al, byte [c1playernum]	; 677C0
and al, 0Fh	; 677C5
or dl, al	; 677C7
mov eax, dword [recbpr]	; 677C9
lea ebx, [byte eax+01h]	; 677CE
mov dword [recbpr], ebx	; 677D1
mov byte [eax], dl	; 677D7
mov ebx, dword [puckc]	; 677D9
mov eax, dword [recbpr]	; 677DF
lea ecx, [byte eax+01h]	; 677E4
mov dword [recbpr], ecx	; 677E7
mov dl, byte [ebx]	; 677ED
mov byte [eax], dl	; 677EF
mov dl, byte [PBnum+1]	; 677F1
and dl, 0Fh	; 677F7
shl dl, 4	; 677FA
mov al, byte [PBnum]	; 677FD
and al, 0Fh	; 67802
or dl, al	; 67804
mov eax, dword [recbpr]	; 67806
lea ebx, [byte eax+01h]	; 6780B
mov dword [recbpr], ebx	; 6780E
mov byte [eax], dl	; 67814
mov eax, dword [recbpr]	; 67816
lea ebx, [byte eax+01h]	; 6781B
mov dword [recbpr], ebx	; 6781E
mov dl, byte [camx]	; 67824
mov byte [eax], dl	; 6782A
mov eax, dword [recbpr]	; 6782C
mov dx, word [camy]	; 67831
mov word [eax], dx	; 67838
mov ecx, dword [recbpr]	; 6783B
add ecx, byte 2	; 67841
mov dword [recbpr], ecx	; 67844
mov dx, word [crowdlevel]	; 6784A
mov word [ecx], dx	; 67851
xor edx, edx	; 67854
add dword [recbpr], byte 2	; 67856
jmp short .16	; 6785D
.15:
movsx ecx, dx	; 6785F
lea ebx, [byte ecx+ecx+01h]	; 67862
mov eax, ebx	; 67866
shl eax, 2	; 67868
sub eax, ebx	; 6786B
mov al, byte [nosplit eax*4+byte_DEE97]	; 6786D
and al, 0Fh	; 67874
mov byte [esp], al	; 67876
mov eax, ecx	; 67879
shl eax, 2	; 6787B
sub eax, ecx	; 6787E
mov al, byte [nosplit eax*8+byte_DEE97]	; 67880
and al, 0Fh	; 67887
shl al, 4	; 67889
mov bl, byte [esp]	; 6788C
or bl, al	; 6788F
mov eax, dword [recbpr]	; 67891
lea ecx, [byte eax+01h]	; 67896
mov dword [recbpr], ecx	; 67899
mov byte [eax], bl	; 6789F
inc edx	; 678A1
.16:
cmp dx, byte 0Ah	; 678A2
jl short updatereplay.15	; 678A6
xor edx, edx	; 678A8
jmp short .18	; 678AA
.17:
movsx ebx, dx	; 678AC
mov eax, ebx	; 678AF
shl eax, 2	; 678B1
sub eax, ebx	; 678B4
mov ebx, eax	; 678B6
shl ebx, 2	; 678B8
mov eax, dword [recbpr]	; 678BB
lea ecx, [byte eax+01h]	; 678C0
mov dword [recbpr], ecx	; 678C3
mov bl, byte [dword ebx+word_DEE94]	; 678C9
mov byte [eax], bl	; 678CF
inc edx	; 678D1
.18:
cmp dx, byte 14h	; 678D2
jl short updatereplay.17	; 678D6
mov eax, dword [replaystart]	; 678D8
lea ebx, [dword eax+09600h]	; 678DD
cmp ebx, dword [recbpr]	; 678E3
ja short .x	; 678E9
or byte [sflags], 10h	; 678EB
mov dword [recbpr], eax	; 678F2
.x:
add esp, byte 4	; 678F7
pop edi	; 678FA
pop esi	; 678FB
pop edx	; 678FC
pop ecx	; 678FD
pop ebx	; 678FE
ret	; 678FF
ReplayStep:
push dword 6Ch	; 67900
call __CHK	; 67905
push ebx	; 6790A
push ecx	; 6790B
push esi	; 6790C
push edi	; 6790D
push ebp	; 6790E
sub esp, byte 48h	; 6790F
mov esi, eax	; 67912
mov ecx, edx	; 67914
mov dword [byte esp+044h], eax	; 67916
test ax, ax	; 6791A
jl near .6	; 6791D
mov ebx, dword [replayplay]	; 67923
.1:
cmp si, byte 1	; 67929
jl near .11	; 6792D
mov edx, dword [replaystart]	; 67933
dec esi	; 67939
mov ebp, dword [replayplay]	; 6793A
add ebp, 80h	; 67940
mov dword [replayplay], ebp	; 67946
lea eax, [dword edx+09600h]	; 6794C
cmp eax, ebp	; 67952
jne short .3	; 67954
test byte [sflags], 10h	; 67956
jne short .2	; 6795D
mov esi, 0FFFFFFFFh	; 6795F
sub ebp, 80h	; 67964
mov dword [replayplay], ebp	; 6796A
jmp near .11	; 67970
.2:
mov dword [replayplay], edx	; 67975
.3:
mov eax, dword [replayplay]	; 6797B
cmp eax, dword [recbpr]	; 67980
jne short .4	; 67986
mov esi, 0FFFFFFFFh	; 67988
sub dword [replayplay], 80h	; 6798D
jmp near .11	; 67997
.4:
test cx, cx	; 6799C
je short ReplayStep.1	; 6799F
cmp ebx, eax	; 679A1
je short ReplayStep.1	; 679A3
mov al, byte [byte eax+058h]	; 679A5
xor ah, ah	; 679A8
cmp ax, 0FFh	; 679AA
je short .5	; 679AE
cwde	; 679B0
call sfx	; 679B1
.5:
mov edx, dword [replayplay]	; 679B6
xor eax, eax	; 679BC
mov al, byte [byte edx+059h]	; 679BE
cmp ax, 0FFh	; 679C1
je near ReplayStep.1	; 679C5
cwde	; 679CB
call sfx	; 679CC
jmp near ReplayStep.1	; 679D1
.6:
mov ebx, dword [recbpr]	; 679D6
mov edx, dword [replaystart]	; 679DC
.7:
test si, si	; 679E2
jge short .11	; 679E5
inc esi	; 679E7
cmp edx, dword [replayplay]	; 679E8
jne short .10	; 679EE
test byte [sflags], 10h	; 679F0
jne short .9	; 679F7
.8:
mov esi, 0FFFFFFFFh	; 679F9
jmp short .11	; 679FE
.9:
lea eax, [dword edx+09600h]	; 67A00
mov dword [replayplay], eax	; 67A06
.10:
mov eax, dword [replayplay]	; 67A0B
cmp eax, ebx	; 67A10
je short ReplayStep.8	; 67A12
lea edi, [byte eax-080h]	; 67A14
mov dword [replayplay], edi	; 67A17
jmp short ReplayStep.7	; 67A1D
.11:
xor eax, eax	; 67A1F
jmp near .16	; 67A21
.12:
mov edx, dword [replayplay]	; 67A26
mov ebx, dword [edx]	; 67A2C
mov dword [regd0], ebx	; 67A2E
mov bx, word [regd0]	; 67A34
and bh, 3	; 67A3B
mov word [regd1], bx	; 67A3E
add edx, byte 4	; 67A45
mov dword [replayplay], edx	; 67A48
mov dl, byte [byte_E03C1]	; 67A4E
test dl, 2	; 67A54
je short .13	; 67A57
mov dh, dl	; 67A59
or dh, 0FCh	; 67A5B
mov byte [byte_E03C1], dh	; 67A5E
.13:
movsx edx, ax	; 67A64
mov bx, word [regd1]	; 67A67
mov word [nosplit edx*2+word_E9F18], bx	; 67A6E
sar dword [regd0], 0Ah	; 67A76
mov dx, word [regd0]	; 67A7D
and dh, 3	; 67A84
mov word [regd1], dx	; 67A87
mov bl, byte [byte_E03C1]	; 67A8E
test bl, 2	; 67A94
je short .14	; 67A97
mov bh, bl	; 67A99
or bh, 0FCh	; 67A9B
mov byte [byte_E03C1], bh	; 67A9E
.14:
movsx edx, ax	; 67AA4
mov bx, word [regd1]	; 67AA7
mov word [nosplit edx*2+word_E9F3A], bx	; 67AAE
sar dword [regd0], 0Ah	; 67AB6
mov dx, word [regd0]	; 67ABD
and dh, 7	; 67AC4
mov word [regd1], dx	; 67AC7
cmp dx, 7FFh	; 67ACE
jne short .15	; 67AD3
mov word [regd1], 0FFFFh	; 67AD5
.15:
movsx edx, ax	; 67ADE
mov bx, word [regd1]	; 67AE1
mov word [nosplit edx*2+word_E9F5C], bx	; 67AE8
test byte [dword_E03BD], 8	; 67AF0
setne dl	; 67AF7
and edx, 0FFh	; 67AFA
mov bl, dl	; 67B00
movsx edx, ax	; 67B02
mov byte [dword edx+byte_E9F7E], bl	; 67B05
inc eax	; 67B0B
.16:
cmp ax, 11h	; 67B0C
jl near ReplayStep.12	; 67B10
xor eax, eax	; 67B16
jmp short .18	; 67B18
.17:
mov edx, dword [replayplay]	; 67B1A
movsx ebx, ax	; 67B20
lea edi, [byte edx+01h]	; 67B23
mov dword [replayplay], edi	; 67B26
mov dl, byte [edx]	; 67B2C
mov byte [dword ebx+byte_E9F8F], dl	; 67B2E
inc eax	; 67B34
.18:
cmp ax, 0Ch	; 67B35
jl short ReplayStep.17	; 67B39
xor eax, eax	; 67B3B
jmp near .24	; 67B3D
.19:
mov edx, dword [replayplay]	; 67B42
lea ebx, [byte edx+01h]	; 67B48
mov dword [replayplay], ebx	; 67B4B
mov dl, byte [edx]	; 67B51
mov byte [regd0], dl	; 67B53
and dl, 0Fh	; 67B59
mov byte [regd1], dl	; 67B5C
cmp dl, 0Fh	; 67B62
jne short .20	; 67B65
mov edx, 0FFFFFFFFh	; 67B67
jmp short .21	; 67B6C
.20:
mov edx, dword [regd1-3]	; 67B6E
sar edx, 18h	; 67B74
.21:
mov bl, dl	; 67B77
movsx edx, ax	; 67B79
mov byte [nosplit edx*2+byte_E9F9B], bl	; 67B7C
mov edx, dword [dword_E03B9]	; 67B83
sar edx, 1Ch	; 67B89
and edx, byte 0Fh	; 67B8C
mov byte [regd1], dl	; 67B8F
cmp dl, 0Fh	; 67B95
jne short .22	; 67B98
mov edx, 0FFFFFFFFh	; 67B9A
jmp short .23	; 67B9F
.22:
mov edx, dword [regd1-3]	; 67BA1
sar edx, 18h	; 67BA7
.23:
mov bl, dl	; 67BAA
movsx edx, ax	; 67BAC
mov byte [nosplit edx*2+byte_E9F9C], bl	; 67BAF
inc eax	; 67BB6
.24:
cmp ax, 6	; 67BB7
jl short ReplayStep.19	; 67BBB
mov eax, dword [replayplay]	; 67BBD
lea edx, [byte eax+01h]	; 67BC2
mov dword [replayplay], edx	; 67BC5
movsx ax, byte [eax]	; 67BCB
mov word [word_E9FA7], ax	; 67BCF
mov eax, edx	; 67BD5
inc edx	; 67BD7
mov dword [replayplay], edx	; 67BD8
movsx ax, byte [eax]	; 67BDE
mov word [word_E9FA9], ax	; 67BE2
lea edi, [byte edx+02h]	; 67BE8
mov dword [replayplay], edi	; 67BEB
lea edx, [byte edi+01h]	; 67BF1
mov dword [replayplay], edx	; 67BF4
mov al, byte [edi]	; 67BFA
mov byte [regd0], al	; 67BFC
and al, 0Fh	; 67C01
mov byte [regd1], al	; 67C03
cmp al, 0Fh	; 67C08
jne short .25	; 67C0A
mov eax, 0FFFFFFFFh	; 67C0C
jmp short .26	; 67C11
.25:
mov eax, dword [regd1-3]	; 67C13
sar eax, 18h	; 67C18
.26:
mov byte [byte_E9FAB], al	; 67C1B
mov eax, dword [dword_E03B9]	; 67C20
sar eax, 1Ch	; 67C25
and eax, byte 0Fh	; 67C28
mov byte [regd1], al	; 67C2B
cmp al, 0Fh	; 67C30
jne short .27	; 67C32
mov eax, 0FFFFFFFFh	; 67C34
jmp short .28	; 67C39
.27:
mov eax, dword [regd1-3]	; 67C3B
sar eax, 18h	; 67C40
.28:
mov byte [byte_E9FAC], al	; 67C43
mov eax, dword [replayplay]	; 67C48
lea edx, [byte eax+01h]	; 67C4D
mov dword [replayplay], edx	; 67C50
mov al, byte [eax]	; 67C56
mov byte [byte_E9FAD], al	; 67C58
mov eax, edx	; 67C5D
inc edx	; 67C5F
mov dword [replayplay], edx	; 67C60
mov al, byte [eax]	; 67C66
mov byte [regd0], al	; 67C68
and al, 0Fh	; 67C6D
mov byte [byte_E9FAE], al	; 67C6F
mov eax, dword [dword_E03B9]	; 67C74
sar eax, 1Ch	; 67C79
and eax, byte 0Fh	; 67C7C
mov byte [byte_E9FAF], al	; 67C7F
mov eax, edx	; 67C84
inc edx	; 67C86
mov dword [replayplay], edx	; 67C87
movsx ax, byte [eax]	; 67C8D
mov word [word_E9FB0], ax	; 67C91
mov word [camx], ax	; 67C97
mov eax, edx	; 67C9D
mov dx, word [edx]	; 67C9F
mov word [word_E9FB2], dx	; 67CA2
mov word [camy], dx	; 67CA9
add eax, byte 2	; 67CB0
mov dword [replayplay], eax	; 67CB3
mov edx, eax	; 67CB8
mov ax, word [eax]	; 67CBA
mov word [crowdlevel], ax	; 67CBD
xor eax, eax	; 67CC3
add edx, byte 2	; 67CC5
mov dword [replayplay], edx	; 67CC8
jmp short .30	; 67CCE
.29:
mov edx, dword [replayplay]	; 67CD0
lea ebx, [byte edx+01h]	; 67CD6
mov dword [replayplay], ebx	; 67CD9
mov dl, byte [edx]	; 67CDF
mov byte [regd0], dl	; 67CE1
xor edx, edx	; 67CE7
mov dl, byte [regd0]	; 67CE9
sar edx, 4	; 67CEF
mov bl, dl	; 67CF2
movsx edx, ax	; 67CF4
mov byte [nosplit edx*2+byte_E9FDC], bl	; 67CF7
mov bl, byte [regd0]	; 67CFE
and bl, 0Fh	; 67D04
mov byte [nosplit edx*2+byte_E9FDD], bl	; 67D07
inc eax	; 67D0E
.30:
cmp ax, 0Ah	; 67D0F
jl short ReplayStep.29	; 67D13
xor eax, eax	; 67D15
jmp short .33	; 67D17
.31:
mov edx, dword [replayplay]	; 67D19
lea ebx, [byte edx+01h]	; 67D1F
mov dword [replayplay], ebx	; 67D22
mov dl, byte [edx]	; 67D28
xor dh, dh	; 67D2A
mov word [regd0], dx	; 67D2C
cmp dx, 0FFh	; 67D33
jne short .32	; 67D38
mov word [regd0], 0FFFFh	; 67D3A
.32:
movsx edx, ax	; 67D43
mov bx, word [regd0]	; 67D46
mov word [nosplit edx*2+word_E9FB4], bx	; 67D4D
inc eax	; 67D55
.33:
cmp ax, 14h	; 67D56
jl short ReplayStep.31	; 67D5A
test cx, cx	; 67D5C
je short .34	; 67D5F
mov eax, dword [replayplay]	; 67D61
cmp eax, dword [recbpr]	; 67D66
je short .34	; 67D6C
mov eax, dword [byte esp+044h]	; 67D6E
add eax, eax	; 67D72
cwde	; 67D74
call Crowd_Noise	; 67D75
jmp short .35	; 67D7A
.34:
call CrowdNoiseOff	; 67D7C
.35:
xor eax, eax	; 67D81
sub dword [replayplay], 80h	; 67D83
jmp short .37	; 67D8D
.36:
movsx ebx, ax	; 67D8F
mov ecx, dword [nosplit ebx*2+dword_E9F38]	; 67D92
sar ecx, 10h	; 67D99
mov dword [esp+ebx*4], ecx	; 67D9C
mov dword [nosplit ebx*4+dword_E9FF0], ebx	; 67D9F
inc eax	; 67DA6
.37:
cmp ax, 11h	; 67DA7
jl short ReplayStep.36	; 67DAB
push dword_E9FF0	; 67DAD
lea eax, [byte esp+04h]	; 67DB2
push eax	; 67DB6
push byte 11h	; 67DB7
call sub_93540	; 67DB9
add esp, byte 0Ch	; 67DBE
mov eax, esi	; 67DC1
add esp, byte 48h	; 67DC3
ReplayStep_popx:
pop ebp	; 67DC6
pop edi	; 67DC7
pop esi	; 67DC8
pop ecx	; 67DC9
pop ebx	; 67DCA
ret	; 67DCB
DrawRinkSideObjects:
push dword 64h	; 67DCC
call __CHK	; 67DD1
push ebx	; 67DD6
push ecx	; 67DD7
push esi	; 67DD8
push edi	; 67DD9
push ebp	; 67DDA
mov ebp, esp	; 67DDB
sub esp, byte 34h	; 67DDD
push eax	; 67DE0
push edx	; 67DE1
mov eax, dword [camx-2]	; 67DE2
sar eax, 10h	; 67DE7
cmp eax, byte 0FFFFFFF0h	; 67DEA
jle near .7	; 67DED
cmp word [camy], byte 50h	; 67DF3
jge short .3	; 67DFB
mov eax, dword [camy-2]	; 67DFD
sar eax, 10h	; 67E02
cmp eax, 0FFFFFF6Ch	; 67E05
jle short .3	; 67E0A
xor esi, esi	; 67E0C
jmp short .2	; 67E0E
.1:
push byte 0	; 67E10
mov eax, esi	; 67E12
add eax, 3	; 67E14
imul eax, byte 0FFFFFFF5h	; 67E19
movsx ebx, ax	; 67E1C
xor ecx, ecx	; 67E1F
mov edx, 0B3h	; 67E21
mov eax, 17Eh	; 67E26
call DrawFrameSprite	; 67E2B
inc esi	; 67E30
.2:
movsx ax, byte [byte_E9FAE]	; 67E31
cmp si, ax	; 67E39
jge short .3	; 67E3C
cmp si, byte 3	; 67E3E
jl short DrawRinkSideObjects.1	; 67E42
.3:
mov eax, dword [camy-2]	; 67E44
sar eax, 10h	; 67E49
cmp eax, byte 0FFFFFFB5h	; 67E4C
jle short .7	; 67E4F
cmp word [camy], 0B1h	; 67E51
jge short .7	; 67E5A
mov eax, dword [byte_E9FAF-3]	; 67E5C
sar eax, 18h	; 67E61
dec eax	; 67E64
cmp eax, byte 2	; 67E65
jl short .4	; 67E68
mov eax, 2	; 67E6A
.4:
mov esi, eax	; 67E6F
jmp short .6	; 67E71
.5:
push byte 1	; 67E73
mov eax, esi	; 67E75
add eax, 3	; 67E77
imul eax, byte 0Bh	; 67E7C
movsx ebx, ax	; 67E7F
xor ecx, ecx	; 67E82
mov edx, 0B3h	; 67E84
mov eax, 17Eh	; 67E89
call DrawFrameSprite	; 67E8E
dec esi	; 67E93
.6:
test si, si	; 67E94
jge short DrawRinkSideObjects.5	; 67E97
.7:
xor esi, esi	; 67E99
jmp near .10	; 67E9B
.8:
movsx eax, si	; 67EA0
mov di, word [nosplit eax*2+word_E9FB4]	; 67EA3
test di, di	; 67EAB
jl short .9	; 67EAE
imul edi, byte 3	; 67EB0
movsx edx, di	; 67EB3
mov dx, word [nosplit edx*2+word_CCEF8]	; 67EB6
mov word [byte ebp-0Ch], dx	; 67EBE
inc edi	; 67EC2
movsx edx, di	; 67EC3
mov dx, word [nosplit edx*2+word_CCEF8]	; 67EC6
mov word [byte ebp-04h], dx	; 67ECE
inc edi	; 67ED2
movsx edx, di	; 67ED3
mov edx, dword [nosplit edx*2+dword_CCEF6]	; 67ED6
sar edx, 10h	; 67EDD
mov eax, dword [dword eax+byte_E9FDC-3]	; 67EE0
sar eax, 18h	; 67EE6
movsx ax, byte [dword edx+eax+byte_CCE00]	; 67EE9
mov word [byte ebp-08h], ax	; 67EF2
push byte 0	; 67EF6
push byte 0FFFFFFFFh	; 67EF8
cmp word [byte ebp-0Ch], 0C0h	; 67EFA
setg al	; 67F00
xor ah, ah	; 67F03
movsx ecx, ax	; 67F05
mov ebx, dword [byte ebp-06h]	; 67F08
sar ebx, 10h	; 67F0B
mov edx, dword [byte ebp-0Eh]	; 67F0E
sar edx, 10h	; 67F11
mov eax, dword [byte ebp-0Ah]	; 67F14
sar eax, 10h	; 67F17
mov eax, dword [nosplit eax*4+photoptrsf]	; 67F1A
call DrawSprite	; 67F21
.9:
inc esi	; 67F26
.10:
cmp si, byte 12h	; 67F27
jl near DrawRinkSideObjects.8	; 67F2B
mov esi, 13h	; 67F31
jmp near .23	; 67F36
.11:
movsx eax, si	; 67F3B
mov di, word [nosplit eax*2+word_E9FB4]	; 67F3E
test di, di	; 67F46
jge short .12	; 67F49
mov word [byte ebp-08h], 0FFFFh	; 67F4B
jmp short .13	; 67F51
.12:
imul edi, byte 3	; 67F53
movsx edx, di	; 67F56
mov dx, word [nosplit edx*2+word_CCEF8]	; 67F59
mov word [byte ebp-0Ch], dx	; 67F61
inc edi	; 67F65
movsx edx, di	; 67F66
mov dx, word [nosplit edx*2+word_CCEF8]	; 67F69
mov word [byte ebp-04h], dx	; 67F71
inc edi	; 67F75
movsx edx, di	; 67F76
mov edx, dword [nosplit edx*2+dword_CCEF6]	; 67F79
sar edx, 10h	; 67F80
mov eax, dword [dword eax+byte_E9FDC-3]	; 67F83
sar eax, 18h	; 67F89
movsx ax, byte [dword edx+eax+byte_CCE00]	; 67F8C
mov word [byte ebp-08h], ax	; 67F95
.13:
cmp word [byte ebp-08h], byte 64h	; 67F99
jg short .14	; 67F9E
test di, di	; 67FA0
jge short .17	; 67FA3
.14:
push byte 0	; 67FA5
cmp si, byte 13h	; 67FA7
sete al	; 67FAB
xor ah, ah	; 67FAE
cwde	; 67FB0
push eax	; 67FB1
xor ecx, ecx	; 67FB2
cmp si, byte 12h	; 67FB4
jne short .15	; 67FB8
mov eax, 1A5h	; 67FBA
jmp short .16	; 67FBF
.15:
mov eax, 12Dh	; 67FC1
.16:
movsx ebx, ax	; 67FC6
mov eax, dword [dword_E0220]	; 67FC9
mov edx, 4	; 67FCE
call DrawSprite	; 67FD3
.17:
cmp word [byte ebp-08h], byte 0	; 67FD8
jl short .18	; 67FDD
push byte 0	; 67FDF
cmp si, byte 13h	; 67FE1
sete al	; 67FE5
xor ah, ah	; 67FE8
cwde	; 67FEA
push eax	; 67FEB
mov ebx, dword [byte ebp-06h]	; 67FEC
sar ebx, 10h	; 67FEF
mov edx, dword [byte ebp-0Eh]	; 67FF2
sar edx, 10h	; 67FF5
mov eax, dword [byte ebp-0Ah]	; 67FF8
sar eax, 10h	; 67FFB
mov eax, dword [nosplit eax*4+photoptrsf]	; 67FFE
xor ecx, ecx	; 68005
call DrawSprite	; 68007
.18:
cmp si, byte 12h	; 6800C
jne short .21	; 68010
push byte 0	; 68012
push byte 0FFFFFFFFh	; 68014
xor ecx, ecx	; 68016
cmp si, si	; 68018
jne short .19	; 6801B
mov eax, 1A5h	; 6801D
jmp short .20	; 68022
.19:
mov eax, 12Dh	; 68024
.20:
movsx ebx, ax	; 68029
mov eax, dword [dword_E0230]	; 6802C
mov edx, 4	; 68031
call DrawSprite	; 68036
jmp short .22	; 6803B
.21:
mov ax, word [word_E9F7A]	; 6803D
mov word [byte ebp-08h], ax	; 68043
cmp ax, 362h	; 68047
jl short .22	; 6804B
push byte 0	; 6804D
mov ebx, dword [word_E9F58-2]	; 6804F
sar ebx, 10h	; 68055
mov edx, dword [word_E9F36-2]	; 68058
sar edx, 10h	; 6805E
mov eax, dword [byte ebp-0Ah]	; 68061
sar eax, 10h	; 68064
xor ecx, ecx	; 68067
call DrawFrameSprite	; 68069
.22:
dec esi	; 6806E
.23:
cmp si, byte 12h	; 6806F
jge near DrawRinkSideObjects.11	; 68073
mov eax, dword [camy-2]	; 68079
sar eax, 10h	; 6807E
cmp eax, 0FFFFFF50h	; 68081
jge short .24	; 68086
mov ax, word [cliprect_y1]	; 68088
mov word [byte ebp-010h], ax	; 6808E
push dword 244h	; 68092
mov edx, dword [cliprect_y0]	; 68097
push edx	; 6809D
mov ebx, dword [dword_D30C0]	; 6809E
push ebx	; 680A4
mov ecx, dword [dword_D30BC]	; 680A5
push ecx	; 680AB
call sub_B4BC4	; 680AC
add esp, byte 10h	; 680B1
.24:
xor esi, esi	; 680B4
jmp short .26	; 680B6
.25:
movsx edx, si	; 680B8
xor edi, edi	; 680BB
mov dword [byte ebp+edx*4-028h], edi	; 680BD
mov dword [byte ebp+edx*4-034h], edx	; 680C1
inc esi	; 680C5
.26:
cmp si, byte 3	; 680C6
jl short DrawRinkSideObjects.25	; 680CA
mov eax, dword [byte_E9FAD-3]	; 680CC
sar eax, 18h	; 680D1
cmp eax, byte 0FFFFFFFFh	; 680D4
je short .27	; 680D7
mov eax, dword [nosplit eax*2+dword_E9F38]	; 680D9
sar eax, 10h	; 680E0
mov dword [byte ebp-020h], eax	; 680E3
.27:
cmp byte [byte_E9FAB], 0	; 680E6
jl short .28	; 680ED
mov eax, dword [byte_E9FAB-3]	; 680EF
sar eax, 18h	; 680F4
mov eax, dword [nosplit eax*2+dword_E9F38]	; 680F7
sar eax, 10h	; 680FE
mov dword [byte ebp-028h], eax	; 68101
.28:
cmp byte [byte_E9FAC], 0	; 68104
jl short .29	; 6810B
mov eax, dword [byte_E9FAC-3]	; 6810D
sar eax, 18h	; 68112
mov eax, dword [nosplit eax*2+dword_E9F38]	; 68115
sar eax, 10h	; 6811C
mov dword [byte ebp-024h], eax	; 6811F
.29:
lea eax, [byte ebp-034h]	; 68122
push eax	; 68125
lea eax, [byte ebp-028h]	; 68126
push eax	; 68129
push byte 3	; 6812A
call sub_93540	; 6812C
add esp, byte 0Ch	; 68131
xor edi, edi	; 68134
jmp near .43	; 68136
.30:
movsx esi, di	; 6813B
mov si, word [byte ebp+esi*4-034h]	; 6813E
cmp si, byte 2	; 68143
jne short .31	; 68147
mov eax, dword [byte_E9FAD-3]	; 68149
sar eax, 18h	; 6814E
cmp eax, byte 0FFFFFFFFh	; 68151
je near .42	; 68154
push byte 0	; 6815A
mov ebx, dword [nosplit eax*2+dword_E9F38]	; 6815C
sar ebx, 10h	; 68163
mov edx, dword [nosplit eax*2+dword_E9F16]	; 68166
sar edx, 10h	; 6816D
mov eax, dword [dword_CC0B4]	; 68170
sar eax, 10h	; 68175
xor ecx, ecx	; 68178
jmp near .41	; 6817A
.31:
test si, si	; 6817F
je short .32	; 68182
mov al, byte [byte_E9FAC]	; 68184
jmp short .33	; 68189
.32:
mov al, byte [byte_E9FAB]	; 6818B
.33:
cbw	; 68190
mov word [byte ebp-08h], ax	; 68192
test ax, ax	; 68196
jl near .42	; 68199
mov eax, dword [byte ebp-0Ah]	; 6819F
sar eax, 10h	; 681A2
add eax, eax	; 681A5
mov edx, dword [dword eax+word_E9F5C-2]	; 681A7
sar edx, 10h	; 681AD
cmp edx, byte 0FFFFFFFFh	; 681B0
je near .42	; 681B3
mov dx, word [dword eax+word_E9F18]	; 681B9
mov word [byte ebp-0Ch], dx	; 681C0
mov ax, word [dword eax+word_E9F3A]	; 681C4
mov word [byte ebp-04h], ax	; 681CB
xor eax, eax	; 681CF
mov word [byte ebp-08h], ax	; 681D1
mov edx, dword [byte ebp-03Eh]	; 681D5
sar edx, 10h	; 681D8
lea eax, [dword edx+0A8h]	; 681DB
mov ebx, 140h	; 681E1
sub ebx, eax	; 681E6
mov eax, dword [byte ebp-06h]	; 681E8
sar eax, 10h	; 681EB
cmp eax, ebx	; 681EE
jge short .34	; 681F0
mov eax, dword [byte ebp-03Ch]	; 681F2
add eax, 0A8h	; 681F5
mov edx, 140h	; 681FA
sub edx, eax	; 681FF
mov word [byte ebp-04h], dx	; 68201
mov word [byte ebp-08h], 1	; 68205
jmp short .35	; 6820B
.34:
mov ebx, 140h	; 6820D
sub ebx, edx	; 68212
cmp eax, ebx	; 68214
jl short .35	; 68216
mov eax, 140h	; 68218
sub eax, dword [byte ebp-03Ch]	; 6821D
inc eax	; 68220
mov word [byte ebp-04h], ax	; 68221
mov word [byte ebp-08h], 2	; 68225
.35:
mov ebx, 0C0h	; 6822B
sub ebx, dword [byte ebp-038h]	; 68230
mov eax, 140h	; 68233
sub eax, ebx	; 68238
mov ebx, eax	; 6823A
cmp word [byte ebp-08h], byte 0	; 6823C
je short .37	; 68241
mov eax, dword [byte ebp-03Ah]	; 68243
sar eax, 10h	; 68246
mov edx, 0C0h	; 68249
sub edx, eax	; 6824E
mov ecx, 140h	; 68250
sub ecx, edx	; 68255
mov edx, dword [byte ebp-0Eh]	; 68257
sar edx, 10h	; 6825A
sub ecx, byte 0Ch	; 6825D
cmp edx, ecx	; 68260
jl short .36	; 68262
sub ebx, byte 0Dh	; 68264
mov word [byte ebp-0Ch], bx	; 68267
or byte [byte ebp-08h], 8	; 6826B
jmp short .39	; 6826F
.36:
sub eax, 0B4h	; 68271
cmp edx, eax	; 68276
jge short .39	; 68278
mov eax, dword [byte ebp-038h]	; 6827A
db 081h,0E8h,0B4h,00h,00h,00h	; 6827D sub eax,0B4h
mov word [byte ebp-0Ch], ax	; 68283
or byte [byte ebp-08h], 4	; 68287
jmp short .39	; 6828B
.37:
mov eax, dword [byte ebp-03Ah]	; 6828D
sar eax, 10h	; 68290
mov edx, 0C0h	; 68293
sub edx, eax	; 68298
mov ecx, 140h	; 6829A
sub ecx, edx	; 6829F
mov edx, dword [byte ebp-0Eh]	; 682A1
sar edx, 10h	; 682A4
cmp edx, ecx	; 682A7
jl short .38	; 682A9
dec ebx	; 682AB
mov word [byte ebp-0Ch], bx	; 682AC
mov word [byte ebp-08h], 8	; 682B0
jmp short .39	; 682B6
.38:
sub eax, 0C0h	; 682B8
cmp edx, eax	; 682BD
jge short .39	; 682BF
mov eax, dword [byte ebp-038h]	; 682C1
db 081h,0E8h,0C0h,00h,00h,00h	; 682C4 sub eax,0C0h
mov word [byte ebp-0Ch], ax	; 682CA
mov word [byte ebp-08h], 4	; 682CE
.39:
mov eax, dword [byte ebp-08h]	; 682D4
test ax, ax	; 682D7
je short .40	; 682DA
push byte 0	; 682DC
xor ah, ah	; 682DE
and al, 8	; 682E0
cwde	; 682E2
mov dword [byte ebp-01Ch], eax	; 682E3
mov eax, dword [byte ebp-06h]	; 682E6
sar eax, 10h	; 682E9
mov dword [byte ebp-018h], eax	; 682EC
mov eax, dword [byte ebp-0Eh]	; 682EF
sar eax, 10h	; 682F2
mov dword [byte ebp-014h], eax	; 682F5
mov eax, dword [byte ebp-0Ah]	; 682F8
sar eax, 10h	; 682FB
push eax	; 682FE
call sub_B340B	; 682FF
add esp, byte 4	; 68304
movsx edx, si	; 68307
shl edx, 4	; 6830A
mov eax, dword [dword edx+eax*2+dword_CC0B4]	; 6830D
sar eax, 10h	; 68314
mov ecx, dword [byte ebp-01Ch]	; 68317
mov ebx, dword [byte ebp-018h]	; 6831A
mov edx, dword [byte ebp-014h]	; 6831D
jmp short .41	; 68320
.40:
push byte 0	; 68322
mov ebx, dword [byte ebp-06h]	; 68324
sar ebx, 10h	; 68327
mov edx, dword [byte ebp-0Eh]	; 6832A
sar edx, 10h	; 6832D
movsx eax, si	; 68330
mov eax, dword [nosplit eax*2+word_CC0B0]	; 68333
sar eax, 10h	; 6833A
xor ecx, ecx	; 6833D
.41:
call DrawFrameSprite	; 6833F
.42:
inc edi	; 68344
.43:
cmp di, byte 3	; 68345
jl near DrawRinkSideObjects.30	; 68349
mov esi, 0Fh	; 6834F
mov ax, word [word_E9F7A]	; 68354
mov word [byte ebp-08h], ax	; 6835A
cmp ax, 284h	; 6835E
jl short .44	; 68362
cmp ax, 288h	; 68364
jg short .44	; 68368
push byte 0	; 6836A
cmp word [word_E9F36], byte 0	; 6836C
setl al	; 68374
xor ah, ah	; 68377
movsx ecx, ax	; 68379
movsx eax, si	; 6837C
mov ebx, dword [nosplit eax*2+dword_E9F38]	; 6837F
sar ebx, 10h	; 68386
mov edx, dword [nosplit eax*2+dword_E9F16]	; 68389
sar edx, 10h	; 68390
mov eax, dword [byte ebp-0Ah]	; 68393
sar eax, 10h	; 68396
jmp short .47	; 68399
.44:
cmp word [byte ebp-08h], 189h	; 6839B
jne short .45	; 683A1
mov eax, dword [word_E9FA7-2]	; 683A3
sar eax, 10h	; 683A8
cmp eax, 0FFFFFF00h	; 683AB
jle short .45	; 683B0
cmp byte [byte_E9FAD], 10h	; 683B2
jne short .46	; 683B9
.45:
movsx eax, si	; 683BB
cmp word [nosplit eax*2+word_E9F3A], byte 0	; 683BE
jl short .48	; 683C7
mov ecx, dword [byte ebp-08h]	; 683C9
cmp cx, 22Ah	; 683CC
jl short .48	; 683D1
cmp cx, 237h	; 683D3
jg short .48	; 683D8
.46:
push byte 0	; 683DA
movsx eax, si	; 683DC
mov ebx, dword [nosplit eax*2+dword_E9F38]	; 683DF
sar ebx, 10h	; 683E6
mov edx, dword [nosplit eax*2+dword_E9F16]	; 683E9
sar edx, 10h	; 683F0
mov eax, dword [byte ebp-0Ah]	; 683F3
sar eax, 10h	; 683F6
xor ecx, ecx	; 683F9
.47:
call DrawFrameSprite	; 683FB
.48:
cmp byte [byte_E9FAD], 10h	; 68400
je short .49	; 68407
cmp word [word_E9FA7], byte 0	; 68409
jl short .49	; 68411
push byte 0	; 68413
mov ebx, dword [dword_E9F56-2]	; 68415
sar ebx, 10h	; 6841B
mov edx, dword [word_E9FA7-2]	; 6841E
sar edx, 10h	; 68424
mov eax, edx	; 68427
shl eax, 2	; 68429
sub eax, edx	; 6842C
mov edx, eax	; 6842E
sar edx, 1Fh	; 68430
LD sub, eax, edx	; 68433
sar eax, 1	; 68435
add eax, ebx	; 68437
movsx ebx, ax	; 68439
mov edx, dword [dword_E9F34-2]	; 6843C
sar edx, 10h	; 68442
mov eax, dword [dword_E9F78-2]	; 68445
sar eax, 10h	; 6844A
xor ecx, ecx	; 6844D
call DrawFrameSprite	; 6844F
.49:
xor edi, edi	; 68454
jmp near .68	; 68456
.50:
movsx esi, di	; 6845B
mov si, word [nosplit esi*4+dword_E9FF0]	; 6845E
cmp si, byte 0Fh	; 68466
je near .67	; 6846A
cmp si, byte 0Eh	; 68470
jne near .54	; 68474
mov eax, dword [byte_E9FAD-3]	; 6847A
sar eax, 18h	; 6847F
cmp eax, byte 0FFFFFFFFh	; 68482
jne near .67	; 68485
cmp word [word_E9FA7], byte 0	; 6848B
jle near .67	; 68493
movsx eax, si	; 68499
add eax, eax	; 6849C
cmp word [dword eax+word_E9F3A], 0E8h	; 6849E
jge near .67	; 684A7
mov edx, dword [dword eax+word_E9F3A-2]	; 684AD
sar edx, 10h	; 684B3
cmp edx, 0FFFFFF18h	; 684B6
jg short .53	; 684BC
cmp edx, 0FFFFFF10h	; 684BE
jl short .53	; 684C4
cmp word [dword eax+word_E9F18], byte 0	; 684C6
jge short .51	; 684CE
mov eax, dword [dword eax+word_E9F18-2]	; 684D0
sar eax, 10h	; 684D6
neg eax	; 684D9
jmp short .52	; 684DB
.51:
mov eax, dword [dword eax+word_E9F18-2]	; 684DD
sar eax, 10h	; 684E3
.52:
cmp eax, byte 14h	; 684E6
jg short .53	; 684E9
cmp word [word_E9FA7], byte 0Dh	; 684EB
jl near .67	; 684F3
.53:
push byte 0	; 684F9
movsx ebx, si	; 684FB
mov ecx, dword [nosplit ebx*2+dword_E9F38]	; 684FE
sar ecx, 10h	; 68505
mov edx, dword [word_E9FA7-2]	; 68508
sar edx, 10h	; 6850E
mov eax, edx	; 68511
shl eax, 2	; 68513
sub eax, edx	; 68516
mov edx, eax	; 68518
sar edx, 1Fh	; 6851A
LD sub, eax, edx	; 6851D
sar eax, 1	; 6851F
add eax, ecx	; 68521
cwde	; 68523
mov edx, dword [nosplit ebx*2+dword_E9F16]	; 68524
sar edx, 10h	; 6852B
mov esi, dword [nosplit ebx*2+dword_E9F5A]	; 6852E
sar esi, 10h	; 68535
xor ecx, ecx	; 68538
mov ebx, eax	; 6853A
mov eax, esi	; 6853C
jmp near .66	; 6853E
.54:
cmp si, byte 0Ch	; 68543
jge short .55	; 68547
movsx eax, si	; 68549
cmp byte [dword eax+byte_E9F9B], 0	; 6854C
jl near .67	; 68553
.55:
movsx eax, si	; 68559
mov eax, dword [nosplit eax*2+dword_E9F5A]	; 6855C
sar eax, 10h	; 68563
cmp eax, byte 0FFFFFFFFh	; 68566
je near .60	; 68569
cmp si, byte 0Ch	; 6856F
jge near .60	; 68573
mov eax, dword [byte_E9FAD-3]	; 68579
sar eax, 18h	; 6857E
cmp eax, byte 0FFFFFFFFh	; 68581
je short .56	; 68584
movsx ax, byte [byte_E9FAD]	; 68586
cmp si, ax	; 6858E
je short .57	; 68591
.56:
movsx ax, byte [byte_E9FAB]	; 68593
cmp si, ax	; 6859B
je short .57	; 6859E
movsx ax, byte [byte_E9FAC]	; 685A0
cmp si, ax	; 685A8
je short .57	; 685AB
movsx eax, si	; 685AD
cmp eax, dword [dword_ED74C]	; 685B0
je short .57	; 685B6
cmp si, word [word_CD4FC]	; 685B8
jne short .58	; 685BF
.57:
movsx eax, si	; 685C1
mov edx, dword [dword eax+byte_E9F9B-3]	; 685C4
sar edx, 18h	; 685CA
mov dword [byte ebp-014h], edx	; 685CD
mov ebx, dword [dword eax+byte_E9F8F-3]	; 685D0
sar ebx, 18h	; 685D6
mov edx, dword [nosplit eax*2+dword_E9F38]	; 685D9
sar edx, 10h	; 685E0
mov eax, dword [nosplit eax*2+dword_E9F16]	; 685E3
sar eax, 10h	; 685EA
mov ecx, dword [byte ebp-014h]	; 685ED
jmp short .59	; 685F0
.58:
cmp dword [shownumbers], byte 0	; 685F2
je short .60	; 685F9
mov ebx, dword [dword eax+byte_E9F8F-3]	; 685FB
sar ebx, 18h	; 68601
mov edx, dword [nosplit eax*2+dword_E9F38]	; 68604
sar edx, 10h	; 6860B
mov eax, dword [nosplit eax*2+dword_E9F16]	; 6860E
sar eax, 10h	; 68615
mov ecx, 0FFFFFFFFh	; 68618
.59:
call DrawSpriteNumber	; 6861D
.60:
cmp si, byte 5	; 68622
setg al	; 68626
xor ah, ah	; 68629
cwde	; 6862B
push eax	; 6862C
movsx eax, si	; 6862D
mov ecx, dword [dword eax+byte_E9F7E-3]	; 68630
sar ecx, 18h	; 68636
mov ebx, dword [nosplit eax*2+dword_E9F38]	; 68639
sar ebx, 10h	; 68640
mov edx, dword [nosplit eax*2+dword_E9F16]	; 68643
sar edx, 10h	; 6864A
mov eax, dword [nosplit eax*2+dword_E9F5A]	; 6864D
sar eax, 10h	; 68654
call DrawFrameSprite	; 68657
cmp si, byte 0Ch	; 6865C
jne near .67	; 68660
cmp byte [byte_E9FAD], 10h	; 68666
je near .67	; 6866D
cmp word [dword_E9F34], byte 0	; 68673
jge short .61	; 6867B
mov eax, dword [dword_E9F34-2]	; 6867D
sar eax, 10h	; 68682
neg eax	; 68685
jmp short .62	; 68687
.61:
mov eax, dword [dword_E9F34-2]	; 68689
sar eax, 10h	; 6868E
.62:
cmp eax, byte 6	; 68691
jne short .63	; 68694
cmp word [dword_E9F56], 0F0h	; 68696
je short .65	; 6869F
.63:
movsx eax, si	; 686A1
add eax, eax	; 686A4
mov dx, word [dword_E9F56]	; 686A6
cmp dx, word [dword eax+word_E9F3A]	; 686AD
jl short .67	; 686B4
cmp word [word_E9FA7], byte 0Dh	; 686B6
jl short .67	; 686BE
mov eax, dword [dword eax+word_E9F18-2]	; 686C0
sar eax, 10h	; 686C6
mov edx, dword [dword_E9F34-2]	; 686C9
sar edx, 10h	; 686CF
sub edx, eax	; 686D2
mov eax, edx	; 686D4
test edx, edx	; 686D6
jge short .64	; 686D8
neg eax	; 686DA
.64:
cmp eax, byte 15h	; 686DC
jge short .67	; 686DF
.65:
push byte 0	; 686E1
mov edx, dword [word_E9FA7-2]	; 686E3
sar edx, 10h	; 686E9
mov eax, edx	; 686EC
shl eax, 2	; 686EE
sub eax, edx	; 686F1
mov edx, eax	; 686F3
sar edx, 1Fh	; 686F5
LD sub, eax, edx	; 686F8
sar eax, 1	; 686FA
mov edx, dword [dword_E9F56-2]	; 686FC
sar edx, 10h	; 68702
add eax, edx	; 68705
movsx ebx, ax	; 68707
mov edx, dword [dword_E9F34-2]	; 6870A
sar edx, 10h	; 68710
mov eax, dword [dword_E9F78-2]	; 68713
sar eax, 10h	; 68718
xor ecx, ecx	; 6871B
.66:
call DrawFrameSprite	; 6871D
.67:
inc edi	; 68722
.68:
cmp di, byte 11h	; 68723
jl near DrawRinkSideObjects.50	; 68727
mov eax, dword [dword_E9F56-2]	; 6872D
sar eax, 10h	; 68732
cmp eax, 0FFFFFF18h	; 68735
jg near .71	; 6873A
cmp eax, 0FFFFFF14h	; 68740
jl short .71	; 68745
cmp word [dword_E9F34], byte 0	; 68747
jge short .69	; 6874F
mov eax, dword [dword_E9F34-2]	; 68751
sar eax, 10h	; 68756
neg eax	; 68759
jmp short .70	; 6875B
.69:
mov eax, dword [dword_E9F34-2]	; 6875D
sar eax, 10h	; 68762
.70:
cmp eax, byte 14h	; 68765
jg short .71	; 68768
cmp word [word_E9FA7], byte 0Dh	; 6876A
jl short .71	; 68772
push byte 0	; 68774
mov edx, dword [word_E9FA7-2]	; 68776
sar edx, 10h	; 6877C
mov eax, edx	; 6877F
shl eax, 2	; 68781
sub eax, edx	; 68784
mov edx, eax	; 68786
sar edx, 1Fh	; 68788
LD sub, eax, edx	; 6878B
sar eax, 1	; 6878D
mov edx, dword [dword_E9F56-2]	; 6878F
sar edx, 10h	; 68795
add eax, edx	; 68798
movsx ebx, ax	; 6879A
mov edx, dword [dword_E9F34-2]	; 6879D
sar edx, 10h	; 687A3
mov eax, dword [dword_E9F78-2]	; 687A6
sar eax, 10h	; 687AB
xor ecx, ecx	; 687AE
call DrawFrameSprite	; 687B0
.71:
mov eax, dword [camy-2]	; 687B5
sar eax, 10h	; 687BA
cmp eax, 0FFFFFF50h	; 687BD
jge short .72	; 687C2
mov eax, dword [byte ebp-012h]	; 687C4
sar eax, 10h	; 687C7
push eax	; 687CA
mov esi, dword [cliprect_y0]	; 687CB
push esi	; 687D1
mov edi, dword [dword_D30C0]	; 687D2
push edi	; 687D8
mov eax, dword [dword_D30BC]	; 687D9
push eax	; 687DE
call sub_B4BC4	; 687DF
add esp, byte 10h	; 687E4
.72:
mov eax, dword [camy-2]	; 687E7
sar eax, 10h	; 687EC
cmp eax, 0FFFFFF70h	; 687EF
jge short .73	; 687F4
call DrawRinkEndArt	; 687F6
.73:
cmp word [word_E9F58], byte 0	; 687FB
jge short .74	; 68803
mov si, word [word_E9F7A]	; 68805
cmp si, 22Ah	; 6880C
jl short .74	; 68811
cmp si, 237h	; 68813
jg short .74	; 68818
push byte 0	; 6881A
mov ebx, dword [word_E9F58-2]	; 6881C
sar ebx, 10h	; 68822
mov edx, dword [word_E9F36-2]	; 68825
sar edx, 10h	; 6882B
mov eax, dword [word_E9F7A-2]	; 6882E
sar eax, 10h	; 68833
xor ecx, ecx	; 68836
call DrawFrameSprite	; 68838
.74:
mov ebx, dword [dword_E9F56-2]	; 6883D
sar ebx, 10h	; 68843
cmp ebx, 0FFFFFEF8h	; 68846
jge short .75	; 6884C
mov eax, dword [byte_E9FAD-3]	; 6884E
sar eax, 18h	; 68853
cmp eax, byte 0FFFFFFFFh	; 68856
jne short .75	; 68859
cmp word [word_E9FA7], byte 0	; 6885B
jl short .75	; 68863
push byte 0	; 68865
mov edx, dword [word_E9FA7-2]	; 68867
sar edx, 10h	; 6886D
mov eax, edx	; 68870
shl eax, 2	; 68872
sub eax, edx	; 68875
mov edx, eax	; 68877
sar edx, 1Fh	; 68879
LD sub, eax, edx	; 6887C
sar eax, 1	; 6887E
add eax, ebx	; 68880
movsx ebx, ax	; 68882
mov edx, dword [dword_E9F34-2]	; 68885
sar edx, 10h	; 6888B
mov eax, dword [dword_E9F78-2]	; 6888E
sar eax, 10h	; 68893
xor ecx, ecx	; 68896
call DrawFrameSprite	; 68898
.75:
mov esp, ebp	; 6889D
jmp near ReplayStep_popx	; 6889F
