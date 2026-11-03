; Drawing over the rink. The window onto the ice, the text overlays, the referee's call and goalie
; banners, and the team palettes.
bits 32
%include "hockey.inc"
section s_65CA8 progbits alloc exec nowrite align=1
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
global DitherRect, checkwindow, checkwindow_popebp, checkwindow_popx, LoadTeamPPV, DrawTextOverlay, CloseTextOverlay, UpdateTextOverlay
global DrawCallBanner, ShowGoalieBanner, SetTeamGoalie, LoadTeamPalette
; C: src/c/engine/overlay/DitherRect.c
%ifdef CBUILD
%include "c/engine/overlay/DitherRect.inc"
%else
DitherRect:
push dword 28h	; 65CA8
call __CHK	; 65CAD
push esi	; 65CB2
push edi	; 65CB3
push ebp	; 65CB4
sub esp, byte 0Ch	; 65CB5
mov ebp, eax	; 65CB8
mov dword [byte esp+04h], edx	; 65CBA
mov dword [byte esp+08h], ebx	; 65CBE
mov dword [esp], ecx	; 65CC2
lea edi, [byte edx+01h]	; 65CC5
jmp short .4	; 65CC8
.1:
mov esi, ebp	; 65CCA
jmp short .3	; 65CCC
.2:
mov ebx, dword [byte esp+01Ch]	; 65CCE
push ebx	; 65CD2
push edi	; 65CD3
push esi	; 65CD4
call sub_B5D80	; 65CD5
add esp, byte 0Ch	; 65CDA
add esi, byte 2	; 65CDD
.3:
mov eax, dword [byte esp+08h]	; 65CE0
add eax, ebp	; 65CE4
cmp esi, eax	; 65CE6
jl short DitherRect.2	; 65CE8
add edi, byte 2	; 65CEA
.4:
mov eax, dword [byte esp+04h]	; 65CED
add eax, dword [esp]	; 65CF1
cmp edi, eax	; 65CF4
jl short DitherRect.1	; 65CF6
add esp, byte 0Ch	; 65CF8
pop ebp	; 65CFB
pop edi	; 65CFC
pop esi	; 65CFD
ret 4	; 65CFE
%endif ; C
; C: src/c/engine/overlay/checkwindow.c
%ifdef CBUILD
%include "c/engine/overlay/checkwindow.inc"
%else
checkwindow:
push dword 20h	; 65D01
call __CHK	; 65D06
push ebx	; 65D0B
push ecx	; 65D0C
push edx	; 65D0D
push esi	; 65D0E
push edi	; 65D0F
push ebp	; 65D10
sub esp, byte 4	; 65D11
mov edx, 28h	; 65D14
mov ecx, 0Ah	; 65D19
xor ebx, ebx	; 65D1E
mov ax, word [yc1]	; 65D20
mov word [regd2], ax	; 65D26
mov ax, word [xc1]	; 65D2C
mov word [regd3], ax	; 65D32
test byte [gmode], 80h	; 65D38
je near .19	; 65D3F
mov edi, 0FFFFFF9Ch	; 65D45
mov word [xc1], di	; 65D4A
mov word [regd3], di	; 65D51
mov ebx, 0Fh	; 65D58
mov word [yc1], bx	; 65D5D
mov word [regd2], bx	; 65D64
mov ecx, 5	; 65D6B
mov ax, word [camy]	; 65D70
sub ebx, eax	; 65D76
mov word [regd0], bx	; 65D78
mov eax, dword [regd0-2]	; 65D7F
sar eax, 10h	; 65D84
cmp eax, byte 0FFFFFFFBh	; 65D87
jge short .1	; 65D8A
mov word [regd1], 14h	; 65D8C
jmp short .2	; 65D95
.1:
cmp bx, cx	; 65D97
jle short .2	; 65D9A
mov word [regd1], 0Ah	; 65D9C
.2:
cmp word [regd0], byte 0	; 65DA5
jge short .3	; 65DAD
mov eax, dword [regd0-2]	; 65DAF
sar eax, 10h	; 65DB4
neg eax	; 65DB7
jmp short .4	; 65DB9
.3:
mov eax, dword [regd0-2]	; 65DBB
sar eax, 10h	; 65DC0
.4:
movsx ecx, cx	; 65DC3
cmp eax, ecx	; 65DC6
jle near .11	; 65DC8
mov ax, word [camy]	; 65DCE
mov cx, word [regd1]	; 65DD4
sub ecx, eax	; 65DDB
mov word [regd1], cx	; 65DDD
test cx, cx	; 65DE4
jge short .5	; 65DE7
mov eax, dword [regd1-2]	; 65DE9
sar eax, 10h	; 65DEE
neg eax	; 65DF1
jmp short .6	; 65DF3
.5:
mov eax, dword [regd1-2]	; 65DF5
sar eax, 10h	; 65DFA
.6:
cmp eax, byte 20h	; 65DFD
jle short .9	; 65E00
cmp word [regd1], byte 0	; 65E02
jge short .7	; 65E0A
mov eax, 0FFFFFFE0h	; 65E0C
jmp short .8	; 65E11
.7:
mov eax, 20h	; 65E13
.8:
mov word [regd1], ax	; 65E18
.9:
mov ax, word [regd1]	; 65E1E
test ax, ax	; 65E24
je short .11	; 65E27
mov ebx, eax	; 65E29
sar bx, 5	; 65E2B
mov word [regd1], bx	; 65E2F
test bx, bx	; 65E36
jne short .10	; 65E39
mov word [regd1], 1	; 65E3B
.10:
mov ax, word [regd1]	; 65E44
add word [camy], ax	; 65E4A
.11:
mov ax, word [regd3]	; 65E51
mov bx, word [camx]	; 65E57
sub eax, ebx	; 65E5E
mov word [regd0], ax	; 65E60
movsx ecx, dx	; 65E66
neg ecx	; 65E69
mov eax, dword [regd0-2]	; 65E6B
sar eax, 10h	; 65E70
cmp eax, ecx	; 65E73
jge short .12	; 65E75
mov ax, word [regd3]	; 65E77
add edx, eax	; 65E7D
mov word [regd1], dx	; 65E7F
mov eax, dword [regd1-2]	; 65E86
sar eax, 10h	; 65E8B
cmp eax, byte 0FFFFFFE0h	; 65E8E
jge short .13	; 65E91
mov word [regd1], 0FFE0h	; 65E93
jmp short .13	; 65E9C
.12:
cmp dx, word [regd0]	; 65E9E
jge near .65	; 65EA5
mov ax, word [regd3]	; 65EAB
sub eax, edx	; 65EB1
mov word [regd1], ax	; 65EB3
cmp ax, 20h	; 65EB9
jle short .13	; 65EBD
mov word [regd1], 20h	; 65EBF
.13:
mov ax, word [camx]	; 65EC8
mov dx, word [regd1]	; 65ECE
sub edx, eax	; 65ED5
mov word [regd1], dx	; 65ED7
test dx, dx	; 65EDE
jge short .14	; 65EE1
mov eax, dword [regd1-2]	; 65EE3
sar eax, 10h	; 65EE8
neg eax	; 65EEB
jmp short .15	; 65EED
.14:
mov eax, dword [regd1-2]	; 65EEF
sar eax, 10h	; 65EF4
.15:
cmp eax, byte 20h	; 65EF7
jle short .18	; 65EFA
cmp word [regd1], byte 0	; 65EFC
jge short .16	; 65F04
mov eax, 0FFFFFFE0h	; 65F06
jmp short .17	; 65F0B
.16:
mov eax, 20h	; 65F0D
.17:
mov word [regd1], ax	; 65F12
.18:
mov si, word [regd1]	; 65F18
test si, si	; 65F1F
je near .65	; 65F22
mov edi, esi	; 65F28
sar di, 5	; 65F2A
mov word [regd1], di	; 65F2E
test di, di	; 65F35
jne near .64	; 65F38
mov word [regd1], 1	; 65F3E
jmp near .64	; 65F47
.19:
cmp word [gameclock], byte 0	; 65F4C
jne short .20	; 65F54
cmp word [clockticks], byte 0	; 65F56
je near .43	; 65F5E
.20:
test byte [gmode], 4	; 65F64
je short .21	; 65F6B
cmp word [Pencntdwn], byte 0	; 65F6D
jl short .22	; 65F75
.21:
cmp word [RefStep], byte 0	; 65F77
jle near .38	; 65F7F
.22:
mov eax, SortCords+800h	; 65F85
mov si, word [SortCords+802h]	; 65F8A
mov word [xc1], si	; 65F91
mov si, word [word_E0022]	; 65F98
mov word [yc1], si	; 65F9F
mov si, word [xc1]	; 65FA6
mov di, word [camx]	; 65FAD
sub esi, edi	; 65FB4
mov word [regd2], si	; 65FB6
mov si, word [word_E0046]	; 65FBD
sub esi, edi	; 65FC4
mov word [regd3], si	; 65FC6
mov esi, dword [regd2-2]	; 65FCD
sar esi, 10h	; 65FD3
mov edi, dword [regd3-2]	; 65FD6
sar edi, 10h	; 65FDC
xor edi, esi	; 65FDF
test edi, edi	; 65FE1
jge short .23	; 65FE3
mov si, word [camx]	; 65FE5
jmp short .27	; 65FEC
.23:
cmp word [regd2], byte 0	; 65FEE
jge short .24	; 65FF6
neg esi	; 65FF8
.24:
cmp word [regd3], byte 0	; 65FFA
jge short .25	; 66002
mov edi, dword [regd3-2]	; 66004
sar edi, 10h	; 6600A
neg edi	; 6600D
jmp short .26	; 6600F
.25:
mov edi, dword [regd3-2]	; 66011
sar edi, 10h	; 66017
.26:
cmp esi, edi	; 6601A
jle short .28	; 6601C
mov si, word [byte eax+temp3]	; 6601E
.27:
mov word [xc1], si	; 66022
.28:
mov si, word [yc1]	; 66029
mov di, word [camy]	; 66030
sub esi, edi	; 66037
mov word [regd2], si	; 66039
mov si, word [byte eax+temp4]	; 66040
sub esi, edi	; 66044
mov word [regd3], si	; 66046
mov esi, dword [regd2-2]	; 6604D
sar esi, 10h	; 66053
mov edi, dword [regd3-2]	; 66056
sar edi, 10h	; 6605C
xor edi, esi	; 6605F
test edi, edi	; 66061
jge short .30	; 66063
mov si, word [camy]	; 66065
.29:
mov word [regd2], si	; 6606C
mov word [yc1], si	; 66073
jmp short .36	; 6607A
.30:
cmp word [regd2], byte 0	; 6607C
jge short .31	; 66084
mov edi, esi	; 66086
neg edi	; 66088
jmp short .32	; 6608A
.31:
mov edi, esi	; 6608C
.32:
cmp word [regd3], byte 0	; 6608E
jge short .33	; 66096
mov esi, dword [regd3-2]	; 66098
sar esi, 10h	; 6609E
neg esi	; 660A1
jmp short .34	; 660A3
.33:
mov esi, dword [regd3-2]	; 660A5
sar esi, 10h	; 660AB
.34:
cmp edi, esi	; 660AE
jle short .35	; 660B0
mov si, word [byte eax+temp4]	; 660B2
jmp short checkwindow.29	; 660B6
.35:
mov si, word [yc1]	; 660B8
mov word [regd2], si	; 660BF
.36:
mov si, word [xc1]	; 660C6
mov word [regd3], si	; 660CD
mov esi, dword [eax]	; 660D4
sar esi, 10h	; 660D6
mov edi, dword [fox-2]	; 660D9
sar edi, 10h	; 660DF
sub esi, edi	; 660E2
mov edi, esi	; 660E4
mov esi, dword [byte eax+Ypos]	; 660E6
sar esi, 10h	; 660E9
mov dword [esp], esi	; 660EC
mov esi, dword [foy-2]	; 660EF
sar esi, 10h	; 660F5
mov ebp, dword [esp]	; 660F8
sub ebp, esi	; 660FB
mov esi, ebp	; 660FD
mov ebp, dword [byte eax+assnum-2]	; 660FF
sar ebp, 10h	; 66102
add eax, ebp	; 66105
cmp byte [byte eax+01Eh], 22h	; 66107
je short .37	; 6610B
cmp byte [byte eax+01Eh], 2Ch	; 6610D
jne near .43	; 66111
.37:
imul edi, edi	; 66117
imul esi, esi	; 6611A
add esi, edi	; 6611D
cmp esi, 640h	; 6611F
jge near .43	; 66125
mov ax, word [foy]	; 6612B
mov word [yc1], ax	; 66131
mov word [regd2], ax	; 66137
mov ax, word [fox]	; 6613D
mov word [xc1], ax	; 66143
mov word [regd3], ax	; 66149
xor ecx, ecx	; 6614F
xor edx, edx	; 66151
jmp near .43	; 66153
.38:
test byte [sflags], 40h	; 66158
jne near .43	; 6615F
mov eax, dword [puckc]	; 66165
cmp byte [eax], 0	; 6616A
jl near .41	; 6616D
movsx eax, byte [eax]	; 66173
shl eax, 7	; 66176
add eax, SortCords	; 66179
mov edi, 2	; 6617E
mov word [regd0], di	; 66183
cmp word [byte eax+SCnum], byte 10h	; 6618A
jne short .39	; 6618F
mov esi, dword [byte eax+0Ch]	; 66191
sar esi, 18h	; 66194
neg esi	; 66197
mov word [yleader], si	; 66199
jmp near .42	; 661A0
.39:
test byte [byte eax+pflags], 80h	; 661A5
je short .40	; 661A9
mov esi, dword [byte eax+Yvel-2]	; 661AB
sar esi, 10h	; 661AE
cmp esi, byte 0FFFFFF9Ch	; 661B1
setl bl	; 661B4
xor bh, bh	; 661B7
mov esi, edi	; 661B9
mov di, word [yleader]	; 661BB
add edi, esi	; 661C2
mov word [yleader], di	; 661C4
cmp di, byte 32h	; 661CB
jl short .42	; 661CF
mov word [yleader], 32h	; 661D1
jmp short .42	; 661DA
.40:
cmp word [byte eax+Yvel], byte 64h	; 661DC
setg bl	; 661E1
xor bh, bh	; 661E4
mov si, word [regd0]	; 661E6
sub word [yleader], si	; 661ED
mov esi, dword [yleader-2]	; 661F4
sar esi, 10h	; 661FA
cmp esi, byte 0FFFFFFCEh	; 661FD
jg short .42	; 66200
mov word [yleader], 0FFCEh	; 66202
jmp short .42	; 6620B
.41:
mov eax, puckstruct	; 6620D
.42:
mov esi, dword [byte eax+0Ch]	; 66212
sar esi, 18h	; 66215
mov edi, dword [byte eax+Ypos]	; 66218
sar edi, 10h	; 6621B
add edi, esi	; 6621E
mov esi, dword [yleader-2]	; 66220
sar esi, 10h	; 66226
add esi, edi	; 66229
mov word [regd2], si	; 6622B
mov word [yc1], si	; 66232
mov ax, word [byte eax+Xpos+2]	; 66239
mov word [regd3], ax	; 6623D
mov word [xc1], ax	; 66243
.43:
mov ax, word [regd2]	; 66249
mov di, word [camy]	; 6624F
sub eax, edi	; 66256
mov word [regd0], ax	; 66258
movsx eax, cx	; 6625E
neg eax	; 66261
mov esi, dword [regd0-2]	; 66263
sar esi, 10h	; 66269
cmp esi, eax	; 6626C
jge short .44	; 6626E
mov ax, word [regd2]	; 66270
add eax, ecx	; 66276
mov word [regd1], ax	; 66278
mov eax, dword [regd1-2]	; 6627E
sar eax, 10h	; 66283
cmp eax, 0FFFFFF44h	; 66286
jge short .47	; 6628B
mov word [regd1], 0FF44h	; 6628D
jmp short .47	; 66296
.44:
cmp cx, word [regd0]	; 66298
jge short .47	; 6629F
test bx, bx	; 662A1
je short .45	; 662A4
mov ax, word [regd2]	; 662A6
jmp short .46	; 662AC
.45:
mov ax, word [regd2]	; 662AE
sub eax, ecx	; 662B4
.46:
mov word [regd1], ax	; 662B6
cmp word [regd1], 0ECh	; 662BC
jle short .47	; 662C5
mov word [regd1], 0ECh	; 662C7
.47:
cmp word [regd0], byte 0	; 662D0
jge short .48	; 662D8
mov eax, dword [regd0-2]	; 662DA
sar eax, 10h	; 662DF
neg eax	; 662E2
jmp short .49	; 662E4
.48:
mov eax, dword [regd0-2]	; 662E6
sar eax, 10h	; 662EB
.49:
movsx ecx, cx	; 662EE
cmp eax, ecx	; 662F1
jle near .56	; 662F3
mov ax, word [camy]	; 662F9
mov di, word [regd1]	; 662FF
sub edi, eax	; 66306
mov word [regd1], di	; 66308
test byte [gmode], 1	; 6630F
je short .54	; 66316
test di, di	; 66318
jge short .50	; 6631B
mov eax, dword [regd1-2]	; 6631D
sar eax, 10h	; 66322
neg eax	; 66325
jmp short .51	; 66327
.50:
mov eax, dword [regd1-2]	; 66329
sar eax, 10h	; 6632E
.51:
cmp eax, byte 20h	; 66331
jle short .54	; 66334
cmp word [regd1], byte 0	; 66336
jge short .52	; 6633E
mov eax, 0FFFFFFE0h	; 66340
jmp short .53	; 66345
.52:
mov eax, 20h	; 66347
.53:
mov word [regd1], ax	; 6634C
.54:
mov si, word [regd1]	; 66352
test si, si	; 66359
je short .56	; 6635C
test bx, bx	; 6635E
sete al	; 66361
xor ecx, ecx	; 66364
mov cl, al	; 66366
add ecx, byte 3	; 66368
mov edi, esi	; 6636B
sar di, cl	; 6636D
mov word [regd1], di	; 66370
test di, di	; 66377
jne short .55	; 6637A
mov word [regd1], 1	; 6637C
.55:
mov ax, word [regd1]	; 66385
add word [camy], ax	; 6638B
.56:
mov ax, word [regd3]	; 66392
mov si, word [camx]	; 66398
sub eax, esi	; 6639F
mov word [regd0], ax	; 663A1
movsx eax, dx	; 663A7
neg eax	; 663AA
mov ecx, dword [regd0-2]	; 663AC
sar ecx, 10h	; 663B2
cmp ecx, eax	; 663B5
jge short .57	; 663B7
mov ax, word [regd3]	; 663B9
add edx, eax	; 663BF
mov word [regd1], dx	; 663C1
mov eax, dword [regd1-2]	; 663C8
sar eax, 10h	; 663CD
cmp eax, byte 0FFFFFFE0h	; 663D0
jge short .58	; 663D3
mov word [regd1], 0FFE0h	; 663D5
jmp short .58	; 663DE
.57:
cmp dx, word [regd0]	; 663E0
jge near .65	; 663E7
mov ax, word [regd3]	; 663ED
sub eax, edx	; 663F3
mov word [regd1], ax	; 663F5
cmp ax, 20h	; 663FB
jle short .58	; 663FF
mov word [regd1], 20h	; 66401
.58:
mov ax, word [camx]	; 6640A
mov cx, word [regd1]	; 66410
sub ecx, eax	; 66417
mov word [regd1], cx	; 66419
test cx, cx	; 66420
jge short .59	; 66423
mov eax, dword [regd1-2]	; 66425
sar eax, 10h	; 6642A
neg eax	; 6642D
jmp short .60	; 6642F
.59:
mov eax, dword [regd1-2]	; 66431
sar eax, 10h	; 66436
.60:
cmp eax, byte 20h	; 66439
jle short .63	; 6643C
cmp word [regd1], byte 0	; 6643E
jge short .61	; 66446
mov eax, 0FFFFFFE0h	; 66448
jmp short .62	; 6644D
.61:
mov eax, 20h	; 6644F
.62:
mov word [regd1], ax	; 66454
.63:
mov ax, word [regd1]	; 6645A
test ax, ax	; 66460
je short .65	; 66463
mov edx, eax	; 66465
sar dx, 4	; 66467
mov word [regd1], dx	; 6646B
test dx, dx	; 66472
jne short .64	; 66475
mov word [regd1], 1	; 66477
.64:
mov ax, word [regd1]	; 66480
add word [camx], ax	; 66486
.65:
add esp, byte 4	; 6648D
checkwindow_popebp:
pop ebp	; 66490
checkwindow_popx:
pop edi	; 66491
pop esi	; 66492
pop edx	; 66493
pop ecx	; 66494
pop ebx	; 66495
ret	; 66496
%endif ; C
; C: src/c/engine/overlay/checkwindow.c (LoadTeamPPV)
%ifdef CBUILD
%include "c/engine/overlay/checkwindow.LoadTeamPPV.inc"
%else
LoadTeamPPV:
push dword 38h	; 66497
call __CHK	; 6649C
push ebx	; 664A1
push ecx	; 664A2
push edx	; 664A3
push esi	; 664A4
push edi	; 664A5
push ebp	; 664A6
sub esp, byte 10h	; 664A7
mov edi, eax	; 664AA
movsx esi, ax	; 664AC
shl esi, 2	; 664AF
call sub_8DAB8	; 664B2
cmp eax, dword [dword esi+dword_CD4B0]	; 664B7
jl near .5	; 664BD
mov ax, word [joysampling]	; 664C3
mov word [joysampling_save], ax	; 664C9
xor ebx, ebx	; 664CF
mov dword [joysampling], ebx	; 664D1
mov ecx, str_PPV	; 664D7
mov ebx, dword [dword esi+off_CBED0]	; 664DC
mov eax, dword [dword esi+dword_CC080]	; 664E2
cmp byte [dword eax+fileoncd], 1	; 664E8
jne short .1	; 664EF
mov edx, dword [cddriveptr]	; 664F1
jmp short .2	; 664F7
.1:
xor edx, edx	; 664F9
.2:
mov eax, esp	; 664FB
call MakePath	; 664FD
push byte 20h	; 66502
lea eax, [byte esp+04h]	; 66504
push eax	; 66508
call sub_8E8A0	; 66509
add esp, byte 8	; 6650E
mov dword [dword_E0244], eax	; 66511
xor esi, esi	; 66516
jmp short .4	; 66518
.3:
push esi	; 6651A
push str_04d2	; 6651B
lea eax, [byte esp+08h]	; 66520
push eax	; 66524
call sprintf_	; 66525
add esp, byte 0Ch	; 6652A
mov eax, esp	; 6652D
push eax	; 6652F
mov ebp, dword [dword_E0244]	; 66530
push ebp	; 66536
call sub_B30B4	; 66537
add esp, byte 8	; 6653C
mov dword [nosplit esi*4+dword_DEF8C], eax	; 6653F
inc esi	; 66546
.4:
mov ecx, dword [dword_E0244]	; 66547
push ecx	; 6654D
call sub_90354	; 6654E
add esp, byte 4	; 66553
cmp esi, eax	; 66556
jl short LoadTeamPPV.3	; 66558
mov eax, dword [joysampling_save-2]	; 6655A
sar eax, 10h	; 6655F
mov dword [joysampling], eax	; 66562
mov word [ovlseq], di	; 66567
movsx eax, di	; 6656E
mov edx, dword [nosplit eax*4+off_CC01D]	; 66571
mov dword [ovlscript], edx	; 66578
mov ax, word [nosplit eax*4+word_CC054]	; 6657E
mov word [ovlsteptimer], ax	; 66586
mov word [ovlstepidx], 1	; 6658C
mov eax, dword [ovlscript]	; 66595
movsx ax, byte [byte eax+01h]	; 6659A
mov word [ovlstep], ax	; 6659F
.5:
add esp, byte 10h	; 665A5
jmp near checkwindow_popebp	; 665A8
%endif ; C
; C: src/c/engine/overlay/checkwindow.c (DrawTextOverlay)
%ifdef CBUILD
%include "c/engine/overlay/checkwindow.DrawTextOverlay.inc"
%else
DrawTextOverlay:
push dword 60h	; 665AD
call __CHK	; 665B2
push ebx	; 665B7
push ecx	; 665B8
push edx	; 665B9
push esi	; 665BA
push edi	; 665BB
push ebp	; 665BC
sub esp, byte 30h	; 665BD
mov dx, word [ovltimer]	; 665C0
cmp dx, byte 10h	; 665C7
jge short .1	; 665CB
mov edi, edx	; 665CD
sub edi, byte 10h	; 665CF
jmp short .3	; 665D2
.1:
cmp dx, 100h	; 665D4
jg short .2	; 665D9
xor edi, edi	; 665DB
jmp short .3	; 665DD
.2:
cmp dx, 258h	; 665DF
jl short .3	; 665E4
mov edi, 258h	; 665E6
sub edi, edx	; 665EB
.3:
mov word [bannermsg], 0FFFFh	; 665ED
xor edx, edx	; 665F6
mov word [bannertimer], dx	; 665F8
test di, di	; 665FF
jge near .5	; 66602
movsx ebx, di	; 66608
add ebx, byte 10h	; 6660B
mov eax, ebx	; 6660E
shl eax, 5	; 66610
lea edx, [ebx+eax]	; 66613
add edx, edx	; 66616
mov eax, edx	; 66618
sar edx, 1Fh	; 6661A
shl edx, 4	; 6661D
LD sbb, eax, edx	; 66620
sar eax, 4	; 66622
mov word [byte esp+018h], ax	; 66625
mov eax, ebx	; 6662A
shl eax, 2	; 6662C
add eax, ebx	; 6662F
shl eax, 2	; 66631
lea edx, [ebx+eax]	; 66634
add edx, edx	; 66637
mov eax, edx	; 66639
sar edx, 1Fh	; 6663B
shl edx, 4	; 6663E
LD sbb, eax, edx	; 66641
sar eax, 4	; 66643
mov dword [byte esp+02Ch], eax	; 66646
mov ax, word [cliprect_x0]	; 6664A
mov word [byte esp+028h], ax	; 66650
mov ax, word [cliprect_x1]	; 66655
mov word [byte esp+0Ch], ax	; 6665B
mov ax, word [cliprect_y0]	; 66660
mov word [byte esp+020h], ax	; 66666
mov ax, word [cliprect_y1]	; 6666B
mov word [byte esp+010h], ax	; 66671
mov si, word [scrollx]	; 66676
add esi, byte 4Ah	; 6667D
sub esi, dword [byte esp+018h]	; 66680
cmp word [gsp], byte 4	; 66684
jne short .4	; 6668C
add esi, 0ACh	; 6668E
.4:
mov eax, dword [byte esp+018h]	; 66694
add eax, esi	; 66698
mov edx, dword [byte esp+018h]	; 6669A
add edx, eax	; 6669E
mov word [byte esp+024h], dx	; 666A0
mov ax, word [scrolly]	; 666A5
add eax, 32h	; 666AB
mov edx, dword [byte esp+02Ch]	; 666B0
sub eax, edx	; 666B4
mov word [byte esp+01Ch], ax	; 666B6
add eax, edx	; 666BB
add edx, eax	; 666BD
mov word [byte esp+014h], dx	; 666BF
mov ax, word [cliprect_x0]	; 666C4
sub ax, word [scrollx]	; 666CA
add esi, eax	; 666D1
add word [byte esp+024h], ax	; 666D3
mov ax, word [cliprect_y0]	; 666D8
sub ax, word [scrolly]	; 666DE
add word [byte esp+01Ch], ax	; 666E5
add word [byte esp+014h], ax	; 666EA
mov eax, dword [byte esp+012h]	; 666EF
sar eax, 10h	; 666F3
push eax	; 666F6
mov eax, dword [byte esp+01Eh]	; 666F7
sar eax, 10h	; 666FB
push eax	; 666FE
mov eax, dword [byte esp+02Ah]	; 666FF
sar eax, 10h	; 66703
push eax	; 66706
movsx eax, si	; 66707
push eax	; 6670A
call sub_B4BC4	; 6670B
add esp, byte 10h	; 66710
.5:
mov si, word [scrollx]	; 66713
add esi, byte 0Ch	; 6671A
cmp word [gsp], byte 4	; 6671D
jne short .6	; 66725
add esi, 0ACh	; 66727
.6:
mov ax, word [scrolly]	; 6672D
add eax, 0Ch	; 66733
mov word [byte esp+01Ch], ax	; 66738
mov eax, esi	; 6673D
add eax, 7Bh	; 6673F
mov word [byte esp+024h], ax	; 66744
mov ax, word [scrolly]	; 66749
add eax, 57h	; 6674F
mov word [byte esp+014h], ax	; 66754
mov ax, word [cliprect_x0]	; 66759
sub ax, word [scrollx]	; 6675F
add esi, eax	; 66766
add word [byte esp+024h], ax	; 66768
mov ax, word [cliprect_y0]	; 6676D
sub ax, word [scrolly]	; 66773
add word [byte esp+01Ch], ax	; 6677A
add word [byte esp+014h], ax	; 6677F
test di, di	; 66784
jl short .7	; 66787
mov eax, dword [ovlseq-2]	; 66789
sar eax, 10h	; 6678E
cmp eax, byte 0FFFFFFFFh	; 66791
je short .7	; 66794
mov eax, dword [ovlstep-2]	; 66796
sar eax, 10h	; 6679B
cmp eax, byte 0FFFFFFFFh	; 6679E
jne short .8	; 667A1
.7:
push byte 10h	; 667A3
mov eax, dword [byte esp+016h]	; 667A5
sar eax, 10h	; 667A9
mov ebp, dword [byte esp+01Eh]	; 667AC
sar ebp, 10h	; 667B0
sub eax, ebp	; 667B3
mov dword [byte esp+08h], eax	; 667B5
push eax	; 667B9
mov eax, dword [byte esp+02Ah]	; 667BA
sar eax, 10h	; 667BE
movsx edx, si	; 667C1
mov dword [byte esp+08h], edx	; 667C4
sub eax, edx	; 667C8
mov dword [byte esp+010h], eax	; 667CA
push eax	; 667CE
push ebp	; 667CF
push edx	; 667D0
call sub_90EC0	; 667D1
add esp, byte 14h	; 667D6
push byte 9	; 667D9
mov ecx, dword [byte esp+08h]	; 667DB
mov ebx, dword [byte esp+0Ch]	; 667DF
mov edx, ebp	; 667E3
mov eax, dword [byte esp+04h]	; 667E5
call DitherRect	; 667E9
.8:
test di, di	; 667EE
je short .9	; 667F1
cmp word [byte esp+018h], byte 3Eh	; 667F3
jl short .10	; 667F9
.9:
push byte 0	; 667FB
push byte 4	; 667FD
push dword 83h	; 667FF
mov eax, dword [byte esp+026h]	; 66804
sar eax, 10h	; 66808
mov dword [byte esp+014h], eax	; 6680B
sub eax, byte 4	; 6680F
push eax	; 66812
movsx ebp, si	; 66813
sub ebp, byte 4	; 66816
push ebp	; 66819
call sub_90D20	; 6681A
add esp, byte 14h	; 6681F
push byte 0	; 66822
push byte 4Bh	; 66824
push byte 4	; 66826
mov edx, dword [byte esp+014h]	; 66828
push edx	; 6682C
push ebp	; 6682D
call sub_90D20	; 6682E
add esp, byte 14h	; 66833
push byte 0	; 66836
push byte 4Bh	; 66838
push byte 4	; 6683A
mov ebx, dword [byte esp+014h]	; 6683C
push ebx	; 66840
mov eax, dword [byte esp+032h]	; 66841
sar eax, 10h	; 66845
push eax	; 66848
call sub_90D20	; 66849
add esp, byte 14h	; 6684E
push byte 0	; 66851
push byte 4	; 66853
push dword 83h	; 66855
mov eax, dword [byte esp+01Eh]	; 6685A
sar eax, 10h	; 6685E
push eax	; 66861
push ebp	; 66862
call sub_90D20	; 66863
add esp, byte 14h	; 66868
.10:
test di, di	; 6686B
jge short .11	; 6686E
mov eax, dword [byte esp+0Eh]	; 66870
sar eax, 10h	; 66874
push eax	; 66877
mov eax, dword [byte esp+022h]	; 66878
sar eax, 10h	; 6687C
push eax	; 6687F
mov eax, dword [byte esp+012h]	; 66880
sar eax, 10h	; 66884
push eax	; 66887
mov eax, dword [byte esp+032h]	; 66888
sar eax, 10h	; 6688C
push eax	; 6688F
call sub_B4BC4	; 66890
add esp, byte 10h	; 66895
jmp near .33	; 66898
.11:
mov eax, dword [ovlseq-2]	; 6689D
sar eax, 10h	; 668A2
cmp eax, byte 0FFFFFFFFh	; 668A5
je near .20	; 668A8
mov eax, dword [ovlstep-2]	; 668AE
sar eax, 10h	; 668B3
cmp eax, byte 0FFFFFFFFh	; 668B6
je near .20	; 668B9
cmp word [ovlseq], byte 0Ah	; 668BF
jne short .12	; 668C7
cmp word [ovlstep], byte 10h	; 668C9
jle short .12	; 668D1
mov edi, dword [byte esp+01Ah]	; 668D3
sar edi, 10h	; 668D7
push edi	; 668DA
movsx ebp, si	; 668DB
push ebp	; 668DE
mov ebx, dword [dword_DF004]	; 668DF
push ebx	; 668E5
call sub_B500C	; 668E6
add esp, byte 0Ch	; 668EB
add edi, byte 1Fh	; 668EE
push edi	; 668F1
add ebp, byte 11h	; 668F2
push ebp	; 668F5
mov eax, dword [ovlstep-2]	; 668F6
sar eax, 10h	; 668FB
mov ecx, dword [nosplit eax*4+dword_DEF8C]	; 668FE
push ecx	; 66905
jmp short .14	; 66906
.12:
cmp word [ovlseq], byte 8	; 66908
jne short .13	; 66910
mov bx, word [ovlstep]	; 66912
cmp bx, byte 12h	; 66919
jl short .13	; 6691D
cmp bx, byte 14h	; 6691F
jg short .13	; 66923
mov ebp, dword [byte esp+01Ah]	; 66925
sar ebp, 10h	; 66929
push ebp	; 6692C
movsx edi, si	; 6692D
push edi	; 66930
mov eax, dword [dword_DEFE0]	; 66931
push eax	; 66936
call sub_B500C	; 66937
add esp, byte 0Ch	; 6693C
add ebp, byte 3Ch	; 6693F
push ebp	; 66942
push edi	; 66943
mov eax, dword [ovlstep-2]	; 66944
sar eax, 10h	; 66949
mov edx, dword [nosplit eax*4+dword_DEF8C]	; 6694C
push edx	; 66953
jmp short .14	; 66954
.13:
mov eax, dword [byte esp+01Ah]	; 66956
sar eax, 10h	; 6695A
push eax	; 6695D
movsx eax, si	; 6695E
push eax	; 66961
mov eax, dword [ovlstep-2]	; 66962
sar eax, 10h	; 66967
mov ebp, dword [nosplit eax*4+dword_DEF8C]	; 6696A
push ebp	; 66971
.14:
call sub_B500C	; 66972
add esp, byte 0Ch	; 66977
cmp word [ovlseq], byte 0	; 6697A
jne near .33	; 66982
cmp word [ovlstep], byte 2	; 66988
jne near .33	; 66990
add word [byte esp+01Ch], byte 23h	; 66996
cmp word [crowdlevel], 2EEh	; 6699C
jle short .16	; 669A5
mov eax, dword [crowdlevel-2]	; 669A7
sar eax, 10h	; 669AC
sub eax, 2EEh	; 669AF
cmp eax, 0C8h	; 669B4
jl short .15	; 669B9
mov eax, 0C8h	; 669BB
.15:
mov word [byte esp+018h], ax	; 669C0
mov ebx, 5	; 669C5
cwd	; 669CA
idiv bx	; 669CC
mov word [byte esp+018h], ax	; 669CF
push byte 30h	; 669D4
mov ecx, dword [byte esp+016h]	; 669D6
sar ecx, 10h	; 669DA
mov edx, dword [byte esp+01Eh]	; 669DD
sar edx, 10h	; 669E1
sub ecx, edx	; 669E4
mov ebx, dword [byte esp+01Ah]	; 669E6
sar ebx, 10h	; 669EA
movsx eax, si	; 669ED
call DitherRect	; 669F0
.16:
cmp word [crowdlevel], 3B6h	; 669F5
jle short .18	; 669FE
mov eax, dword [crowdlevel-2]	; 66A00
sar eax, 10h	; 66A05
add esi, byte 28h	; 66A08
sub eax, 3B6h	; 66A0B
cmp eax, 0C8h	; 66A10
jl short .17	; 66A15
mov eax, 0C8h	; 66A17
.17:
mov word [byte esp+018h], ax	; 66A1C
mov ebx, 5	; 66A21
cwd	; 66A26
idiv bx	; 66A28
mov word [byte esp+018h], ax	; 66A2B
push byte 27h	; 66A30
mov ecx, dword [byte esp+016h]	; 66A32
sar ecx, 10h	; 66A36
mov edx, dword [byte esp+01Eh]	; 66A39
sar edx, 10h	; 66A3D
sub ecx, edx	; 66A40
mov ebx, dword [byte esp+01Ah]	; 66A42
sar ebx, 10h	; 66A46
movsx eax, si	; 66A49
call DitherRect	; 66A4C
.18:
cmp word [crowdlevel], 47Eh	; 66A51
jle near .33	; 66A5A
mov eax, dword [crowdlevel-2]	; 66A60
sar eax, 10h	; 66A65
add esi, byte 28h	; 66A68
sub eax, 47Eh	; 66A6B
cmp eax, 0D7h	; 66A70
jl short .19	; 66A75
mov eax, 0D7h	; 66A77
.19:
mov word [byte esp+018h], ax	; 66A7C
mov ebx, 5	; 66A81
cwd	; 66A86
idiv bx	; 66A88
mov word [byte esp+018h], ax	; 66A8B
push byte 60h	; 66A90
mov ecx, dword [byte esp+016h]	; 66A92
sar ecx, 10h	; 66A96
mov edx, dword [byte esp+01Eh]	; 66A99
sar edx, 10h	; 66A9D
sub ecx, edx	; 66AA0
mov ebx, dword [byte esp+01Ah]	; 66AA2
sar ebx, 10h	; 66AA6
movsx eax, si	; 66AA9
call DitherRect	; 66AAC
jmp near .33	; 66AB1
.20:
cmp byte [textline5], 0	; 66AB6
je short .21	; 66ABD
mov dword [byte esp+02Ch], 0Dh	; 66ABF
add word [byte esp+01Ch], byte 8	; 66AC7
jmp short .23	; 66ACD
.21:
cmp byte [textline4], 0	; 66ACF
je short .22	; 66AD6
mov dword [byte esp+02Ch], 0Fh	; 66AD8
add word [byte esp+01Ch], byte 0Bh	; 66AE0
jmp short .23	; 66AE6
.22:
mov dword [byte esp+02Ch], 12h	; 66AE8
add word [byte esp+01Ch], byte 0Fh	; 66AF0
.23:
mov ecx, dword [scor3font]	; 66AF6
push ecx	; 66AFC
add esi, byte 3Eh	; 66AFD
call sub_8EA18	; 66B00
add esp, byte 4	; 66B05
push dword 0FFh	; 66B08
push byte 25h	; 66B0D
call sub_8E9C0	; 66B0F
add esp, byte 8	; 66B14
mov edi, dword [byte esp+01Ch]	; 66B17
cmp byte [textline3], 0	; 66B1B
je short .24	; 66B22
mov eax, dword [byte esp+01Ah]	; 66B24
sar eax, 10h	; 66B28
push eax	; 66B2B
push textline3	; 66B2C
call fputchar	; 66B31
mov edx, eax	; 66B36
add esp, byte 4	; 66B38
sar edx, 1Fh	; 66B3B
LD sub, eax, edx	; 66B3E
sar eax, 1	; 66B40
movsx edx, si	; 66B42
sub edx, eax	; 66B45
push edx	; 66B47
push textline3	; 66B48
call sub_91964	; 66B4D
add esp, byte 0Ch	; 66B52
.24:
cmp byte [textline1], 0	; 66B55
je short .25	; 66B5C
add edi, dword [byte esp+02Ch]	; 66B5E
movsx eax, di	; 66B62
push eax	; 66B65
push textline1	; 66B66
call fputchar	; 66B6B
mov edx, eax	; 66B70
add esp, byte 4	; 66B72
sar edx, 1Fh	; 66B75
LD sub, eax, edx	; 66B78
sar eax, 1	; 66B7A
movsx edx, si	; 66B7C
sub edx, eax	; 66B7F
push edx	; 66B81
push textline1	; 66B82
call sub_91964	; 66B87
add esp, byte 0Ch	; 66B8C
.25:
cmp byte [textline2], 0	; 66B8F
je short .26	; 66B96
add edi, dword [byte esp+02Ch]	; 66B98
movsx eax, di	; 66B9C
push eax	; 66B9F
push textline2	; 66BA0
call fputchar	; 66BA5
mov edx, eax	; 66BAA
add esp, byte 4	; 66BAC
sar edx, 1Fh	; 66BAF
LD sub, eax, edx	; 66BB2
sar eax, 1	; 66BB4
movsx edx, si	; 66BB6
sub edx, eax	; 66BB9
push edx	; 66BBB
push textline2	; 66BBC
call sub_91964	; 66BC1
add esp, byte 0Ch	; 66BC6
.26:
cmp byte [textline4], 0	; 66BC9
je short .27	; 66BD0
add edi, dword [byte esp+02Ch]	; 66BD2
movsx eax, di	; 66BD6
push eax	; 66BD9
push textline4	; 66BDA
call fputchar	; 66BDF
mov edx, eax	; 66BE4
add esp, byte 4	; 66BE6
sar edx, 1Fh	; 66BE9
LD sub, eax, edx	; 66BEC
sar eax, 1	; 66BEE
movsx edx, si	; 66BF0
sub edx, eax	; 66BF3
push edx	; 66BF5
push textline4	; 66BF6
call sub_91964	; 66BFB
add esp, byte 0Ch	; 66C00
.27:
cmp byte [textline5], 0	; 66C03
je short .28	; 66C0A
add edi, dword [byte esp+02Ch]	; 66C0C
movsx eax, di	; 66C10
push eax	; 66C13
push textline5	; 66C14
call fputchar	; 66C19
mov edx, eax	; 66C1E
add esp, byte 4	; 66C20
sar edx, 1Fh	; 66C23
LD sub, eax, edx	; 66C26
sar eax, 1	; 66C28
movsx edx, si	; 66C2A
sub edx, eax	; 66C2D
push edx	; 66C2F
push textline5	; 66C30
call sub_91964	; 66C35
add esp, byte 0Ch	; 66C3A
.28:
mov edi, dword [scor2font]	; 66C3D
push edi	; 66C43
call sub_8EA18	; 66C44
add esp, byte 4	; 66C49
push dword 0FFh	; 66C4C
push byte 27h	; 66C51
call sub_8E9C0	; 66C53
add esp, byte 8	; 66C58
mov edi, dword [byte esp+01Ch]	; 66C5B
cmp byte [textline3], 0	; 66C5F
je short .29	; 66C66
mov eax, dword [byte esp+01Ah]	; 66C68
sar eax, 10h	; 66C6C
push eax	; 66C6F
push textline3	; 66C70
call fputchar	; 66C75
mov edx, eax	; 66C7A
add esp, byte 4	; 66C7C
sar edx, 1Fh	; 66C7F
LD sub, eax, edx	; 66C82
sar eax, 1	; 66C84
movsx edx, si	; 66C86
sub edx, eax	; 66C89
push edx	; 66C8B
push textline3	; 66C8C
call sub_91964	; 66C91
add esp, byte 0Ch	; 66C96
.29:
cmp byte [textline1], 0	; 66C99
je short .30	; 66CA0
add edi, dword [byte esp+02Ch]	; 66CA2
movsx eax, di	; 66CA6
push eax	; 66CA9
push textline1	; 66CAA
call fputchar	; 66CAF
mov edx, eax	; 66CB4
add esp, byte 4	; 66CB6
sar edx, 1Fh	; 66CB9
LD sub, eax, edx	; 66CBC
sar eax, 1	; 66CBE
movsx edx, si	; 66CC0
sub edx, eax	; 66CC3
push edx	; 66CC5
push textline1	; 66CC6
call sub_91964	; 66CCB
add esp, byte 0Ch	; 66CD0
.30:
cmp byte [textline2], 0	; 66CD3
je short .31	; 66CDA
add edi, dword [byte esp+02Ch]	; 66CDC
movsx eax, di	; 66CE0
push eax	; 66CE3
push textline2	; 66CE4
call fputchar	; 66CE9
mov edx, eax	; 66CEE
add esp, byte 4	; 66CF0
sar edx, 1Fh	; 66CF3
LD sub, eax, edx	; 66CF6
sar eax, 1	; 66CF8
movsx edx, si	; 66CFA
sub edx, eax	; 66CFD
push edx	; 66CFF
push textline2	; 66D00
call sub_91964	; 66D05
add esp, byte 0Ch	; 66D0A
.31:
cmp byte [textline4], 0	; 66D0D
je short .32	; 66D14
add edi, dword [byte esp+02Ch]	; 66D16
movsx eax, di	; 66D1A
push eax	; 66D1D
push textline4	; 66D1E
call fputchar	; 66D23
mov edx, eax	; 66D28
add esp, byte 4	; 66D2A
sar edx, 1Fh	; 66D2D
LD sub, eax, edx	; 66D30
sar eax, 1	; 66D32
movsx edx, si	; 66D34
sub edx, eax	; 66D37
push edx	; 66D39
push textline4	; 66D3A
call sub_91964	; 66D3F
add esp, byte 0Ch	; 66D44
.32:
cmp byte [textline5], 0	; 66D47
je short .33	; 66D4E
add edi, dword [byte esp+02Ch]	; 66D50
movsx eax, di	; 66D54
push eax	; 66D57
push textline5	; 66D58
call fputchar	; 66D5D
mov edx, eax	; 66D62
add esp, byte 4	; 66D64
sar edx, 1Fh	; 66D67
LD sub, eax, edx	; 66D6A
sar eax, 1	; 66D6C
movsx edx, si	; 66D6E
sub edx, eax	; 66D71
push edx	; 66D73
push textline5	; 66D74
call sub_91964	; 66D79
add esp, byte 0Ch	; 66D7E
.33:
mov si, word [cliprect_x0]	; 66D81
add esi, byte 8	; 66D88
cmp word [gsp], byte 4	; 66D8B
jne short .34	; 66D93
add esi, 0ACh	; 66D95
.34:
mov ax, word [cliprect_y0]	; 66D9B
add eax, 8	; 66DA1
mov word [byte esp+01Ch], ax	; 66DA6
mov ebx, dword [byte esp+01Ah]	; 66DAB
sar ebx, 10h	; 66DAF
lea eax, [byte ebx+053h]	; 66DB2
push eax	; 66DB5
movsx edx, si	; 66DB6
lea ecx, [dword edx+083h]	; 66DB9
mov eax, dword [spritedrawcount]	; 66DBF
lea edi, [byte eax+01h]	; 66DC4
mov dword [spritedrawcount], edi	; 66DC7
call sub_6AB7C	; 66DCD
add esp, byte 30h	; 66DD2
jmp near checkwindow_popebp	; 66DD5
%endif ; C
; C: src/c/engine/overlay/CloseTextOverlay.c
%ifdef CBUILD
%include "c/engine/overlay/CloseTextOverlay.inc"
%else
CloseTextOverlay:
push dword 8	; 66DDA
call __CHK	; 66DDF
push ebx	; 66DE4
cmp word [ovltimer], 100h	; 66DE5
jne short .1	; 66DEE
mov word [ovltimer], 10h	; 66DF0
pop ebx	; 66DF9
ret	; 66DFA
.1:
xor ebx, ebx	; 66DFB
mov word [ovltimer], bx	; 66DFD
pop ebx	; 66E04
ret	; 66E05
%endif ; C
; C: src/c/engine/overlay/checkwindow.c (UpdateTextOverlay)
%ifdef CBUILD
%include "c/engine/overlay/checkwindow.UpdateTextOverlay.inc"
%else
UpdateTextOverlay:
push dword 1Ch	; 66E06
call __CHK	; 66E0B
push ebx	; 66E10
push ecx	; 66E11
push edx	; 66E12
push esi	; 66E13
push edi	; 66E14
cmp word [ovltimer], byte 0	; 66E15
jl near checkwindow_popx	; 66E1D
mov bx, word [Pencntdwn]	; 66E23
cmp bx, 100h	; 66E2A
jl short .1	; 66E2F
cmp bx, 140h	; 66E31
jg short .1	; 66E36
test byte [gmode], 40h	; 66E38
je near checkwindow_popx	; 66E3F
.1:
cmp word [ovlseq], byte 0	; 66E45
jne near .6	; 66E4D
cmp word [ovlstep], byte 5	; 66E53
jge short .6	; 66E5B
mov ax, word [crowdlevel]	; 66E5D
cmp ax, 5DCh	; 66E63
jge short .6	; 66E67
cmp word [ovlstepidx], byte 1	; 66E69
jne short .2	; 66E71
cmp ax, 280h	; 66E73
jge short .2	; 66E77
mov word [crowdlevel], 280h	; 66E79
.2:
mov si, word [ovlstepidx]	; 66E82
cmp si, byte 1	; 66E89
jl short .3	; 66E8D
cmp si, byte 5	; 66E8F
jl short .5	; 66E93
.3:
mov ax, word [ovlstepidx]	; 66E95
cmp ax, 7	; 66E9B
jle short .4	; 66E9F
cmp ax, 0Dh	; 66EA1
jl short .5	; 66EA5
.4:
cmp word [ovlstepidx], byte 10h	; 66EA7
jle short .6	; 66EAF
.5:
add word [crowdlevel], byte 8	; 66EB1
.6:
cmp word [ovltimer], byte 10h	; 66EB9
jne near .9	; 66EC1
mov edx, dword [ovlseq-2]	; 66EC7
sar edx, 10h	; 66ECD
cmp edx, byte 0FFFFFFFFh	; 66ED0
je near .9	; 66ED3
mov ebx, dword [ovlscript]	; 66ED9
test ebx, ebx	; 66EDF
je near .9	; 66EE1
mov si, word [ovlsteptimer]	; 66EE7
dec esi	; 66EEE
mov word [ovlsteptimer], si	; 66EEF
test si, si	; 66EF6
jge near checkwindow_popx	; 66EF9
mov eax, ebx	; 66EFF
movsx bx, byte [ebx]	; 66F01
mov cx, word [ovlstepidx]	; 66F05
cmp bx, cx	; 66F0C
jne short .8	; 66F0F
mov ecx, dword [dword_E0244]	; 66F11
push ecx	; 66F17
call FreeMemBlock	; 66F18
add esp, byte 4	; 66F1D
mov eax, dword [ovlseq-2]	; 66F20
sar eax, 10h	; 66F25
cmp byte [dword eax+byte_CC049], 0	; 66F28
je short .7	; 66F2F
mov word [ovltimer], 258h	; 66F31
.7:
mov eax, 0FFFFFFFFh	; 66F3A
mov word [ovlstep], ax	; 66F3F
mov word [ovlseq], ax	; 66F45
xor esi, esi	; 66F4B
mov dword [ovlscript], esi	; 66F4D
jmp near checkwindow_popx	; 66F53
.8:
mov esi, ecx	; 66F58
inc esi	; 66F5A
mov word [ovlstepidx], si	; 66F5B
mov ebx, dword [ovlstepidx-2]	; 66F62
sar ebx, 10h	; 66F68
movsx ax, byte [ebx+eax]	; 66F6B
mov word [ovlstep], ax	; 66F70
mov ax, word [nosplit edx*4+word_CC054]	; 66F76
mov word [ovlsteptimer], ax	; 66F7E
jmp near checkwindow_popx	; 66F84
.9:
mov di, word [ovltimer]	; 66F89
cmp di, 100h	; 66F90
jl short .10	; 66F95
cmp di, 258h	; 66F97
jl short .11	; 66F9C
.10:
inc word [ovltimer]	; 66F9E
.11:
cmp word [ovltimer], 268h	; 66FA5
jle near checkwindow_popx	; 66FAE
mov word [ovltimer], 0FFFFh	; 66FB4
xor dl, dl	; 66FBD
mov byte [textline5], dl	; 66FBF
mov byte [textline4], dl	; 66FC5
mov byte [textline2], dl	; 66FCB
mov byte [textline1], dl	; 66FD1
mov byte [textline3], dl	; 66FD7
jmp near checkwindow_popx	; 66FDD
%endif ; C
; C: src/c/engine/overlay/checkwindow.c (DrawCallBanner)
%ifdef CBUILD
%include "c/engine/overlay/checkwindow.DrawCallBanner.inc"
%else
DrawCallBanner:
push dword 54h	; 66FE2
call __CHK	; 66FE7
push ebx	; 66FEC
push ecx	; 66FED
push edx	; 66FEE
push esi	; 66FEF
push edi	; 66FF0
push ebp	; 66FF1
sub esp, byte 24h	; 66FF2
mov edi, eax	; 66FF5
mov si, word [scrollx]	; 66FF7
add esi, byte 0Ch	; 66FFE
mov ax, word [scrolly]	; 67001
add eax, 95h	; 67007
mov word [byte esp+01Ch], ax	; 6700C
mov ax, word [scrolly]	; 67011
add eax, 9Eh	; 67017
mov word [byte esp+020h], ax	; 6701C
mov edx, dword [scor3font]	; 67021
push edx	; 67027
call sub_8EA18	; 67028
add esp, byte 4	; 6702D
movsx ebp, di	; 67030
shl ebp, 2	; 67033
mov ebx, dword [dword ebp+bannerstrs]	; 67036
push ebx	; 6703C
call fputchar	; 6703D
add esp, byte 4	; 67042
add eax, 4	; 67045
mov word [byte esp+018h], ax	; 6704A
add eax, esi	; 6704F
mov di, word [cliprect_x0]	; 67051
sub di, word [scrollx]	; 67058
add esi, edi	; 6705F
add eax, edi	; 67061
mov di, word [cliprect_y0]	; 67063
sub di, word [scrolly]	; 6706A
add word [byte esp+01Ch], di	; 67071
add word [byte esp+020h], di	; 67076
push byte 10h	; 6707B
mov edx, dword [byte esp+022h]	; 6707D
sar edx, 10h	; 67081
mov dword [byte esp+04h], edx	; 67084
mov edi, dword [byte esp+01Eh]	; 67088
sar edi, 10h	; 6708C
add word [byte esp+01Ch], byte 8	; 6708F
sub edx, edi	; 67095
mov dword [byte esp+010h], edx	; 67097
push edx	; 6709B
cwde	; 6709C
mov dword [byte esp+0Ch], eax	; 6709D
movsx eax, si	; 670A1
mov dword [byte esp+010h], eax	; 670A4
mov eax, dword [byte esp+0Ch]	; 670A8
mov edx, dword [byte esp+010h]	; 670AC
sub eax, edx	; 670B0
mov dword [byte esp+018h], eax	; 670B2
push eax	; 670B6
push edi	; 670B7
push edx	; 670B8
call sub_90D20	; 670B9
add esp, byte 14h	; 670BE
push byte 9	; 670C1
mov ecx, dword [byte esp+010h]	; 670C3
mov ebx, dword [byte esp+014h]	; 670C7
mov edx, edi	; 670CB
mov eax, dword [byte esp+0Ch]	; 670CD
call DitherRect	; 670D1
push byte 0	; 670D6
push byte 4	; 670D8
mov eax, dword [byte esp+01Eh]	; 670DA
sar eax, 10h	; 670DE
mov dword [byte esp+01Ch], eax	; 670E1
push eax	; 670E5
lea eax, [byte edi-04h]	; 670E6
push eax	; 670E9
mov eax, dword [byte esp+018h]	; 670EA
sub eax, byte 4	; 670EE
mov dword [byte esp+020h], eax	; 670F1
push eax	; 670F5
call sub_90D20	; 670F6
add esp, byte 14h	; 670FB
push byte 0	; 670FE
push byte 9	; 67100
push byte 4	; 67102
push edi	; 67104
mov ebx, dword [byte esp+020h]	; 67105
push ebx	; 67109
call sub_90D20	; 6710A
add esp, byte 14h	; 6710F
push byte 0	; 67112
push byte 9	; 67114
push byte 4	; 67116
push edi	; 67118
mov ecx, dword [byte esp+014h]	; 67119
push ecx	; 6711D
call sub_90D20	; 6711E
add esp, byte 14h	; 67123
push byte 0	; 67126
push byte 4	; 67128
mov edi, dword [byte esp+01Ch]	; 6712A
push edi	; 6712E
mov eax, dword [byte esp+0Ch]	; 6712F
push eax	; 67133
mov edx, dword [byte esp+020h]	; 67134
push edx	; 67138
call sub_90D20	; 67139
add esp, byte 14h	; 6713E
push dword 0FFh	; 67141
push byte 25h	; 67146
call sub_8E9C0	; 67148
add esp, byte 8	; 6714D
mov eax, esi	; 67150
add eax, 2	; 67152
mov edx, dword [byte esp+01Ch]	; 67157
inc edx	; 6715B
mov word [byte esp+020h], dx	; 6715C
mov edi, dword [byte esp+01Eh]	; 67161
sar edi, 10h	; 67165
push edi	; 67168
cwde	; 67169
mov dword [byte esp+04h], eax	; 6716A
push eax	; 6716E
mov ecx, dword [dword ebp+bannerstrs]	; 6716F
push ecx	; 67175
call sub_91964	; 67176
add esp, byte 0Ch	; 6717B
mov eax, dword [scor2font]	; 6717E
push eax	; 67183
call sub_8EA18	; 67184
add esp, byte 4	; 67189
push dword 0FFh	; 6718C
push byte 27h	; 67191
call sub_8E9C0	; 67193
add esp, byte 8	; 67198
push edi	; 6719B
mov edx, dword [byte esp+04h]	; 6719C
push edx	; 671A0
mov ebx, dword [dword ebp+bannerstrs]	; 671A1
push ebx	; 671A7
call sub_91964	; 671A8
add esp, byte 0Ch	; 671AD
sub esi, byte 4	; 671B0
sub word [byte esp+01Ch], byte 4	; 671B3
mov ebx, dword [byte esp+01Ah]	; 671B9
sar ebx, 10h	; 671BD
lea eax, [byte ebx+011h]	; 671C0
push eax	; 671C3
movsx edx, si	; 671C4
mov ecx, dword [byte esp+018h]	; 671C7
add ecx, edx	; 671CB
mov eax, dword [spritedrawcount]	; 671CD
lea edi, [byte eax+01h]	; 671D2
mov dword [spritedrawcount], edi	; 671D5
call sub_6AB7C	; 671DB
add esp, byte 24h	; 671E0
jmp near checkwindow_popebp	; 671E3
%endif ; C
; C: src/c/engine/overlay/ShowGoalieBanner.c
%ifdef CBUILD
%include "c/engine/overlay/ShowGoalieBanner.inc"
%else
ShowGoalieBanner:
push dword 14h	; 671E8
call __CHK	; 671ED
push ebx	; 671F2
push ecx	; 671F3
push edx	; 671F4
push esi	; 671F5
mov edx, eax	; 671F6
cwde	; 671F8
mov ebx, eax	; 671F9
shl ebx, 8	; 671FB
mov bx, word [dword ebx+hmtmgoalie]	; 671FE
cmp dword [curperiod], byte 0FFFFFFFFh	; 67205
je near .x	; 6720C
mov ecx, dword [cont1team-2]	; 67212
sar ecx, 10h	; 67218
inc eax	; 6721B
cmp ecx, eax	; 6721C
je short .1	; 6721E
mov ecx, dword [cont2team-2]	; 67220
sar ecx, 10h	; 67226
cmp ecx, eax	; 67229
jne near .x	; 6722B
.1:
movsx eax, bx	; 67231
and eax, 0FFF0h	; 67234
cmp eax, 0FF00h	; 67239
je near .x	; 6723E
test bx, bx	; 67244
setge al	; 67247
and eax, 0FFh	; 6724A
mov cx, word [bannermsg]	; 6724F
cmp ax, cx	; 67256
jg short .2	; 67259
cmp cx, byte 2	; 6725B
jge short .3	; 6725F
.2:
mov word [bannermsg], ax	; 67261
mov word [bannertimer], 50h	; 67267
.3:
test bx, bx	; 67270
jge short .4	; 67273
movsx ecx, dx	; 67275
mov ebx, ecx	; 67278
shl ebx, 2	; 6727A
sub ebx, ecx	; 6727D
shl ebx, 2	; 6727F
mov eax, dword [dword ebx+off_CD4A0]	; 67282
mov byte [eax], 2	; 67288
mov eax, ecx	; 6728B
shl eax, 8	; 6728D
mov cx, word [dword eax+hmtmgoalie]	; 67290
xor ch, ch	; 67297
and cl, 0Fh	; 67299
mov word [dword eax+hmtmgoalie], cx	; 6729C
movsx eax, cx	; 672A3
mov eax, dword [dword ebx+eax*4+off_CD498]	; 672A6
jmp short .5	; 672AD
.4:
movsx esi, dx	; 672AF
mov ecx, esi	; 672B2
shl ecx, 2	; 672B4
sub ecx, esi	; 672B7
shl ecx, 2	; 672B9
xor bh, bh	; 672BC
and bl, 0Fh	; 672BE
movsx eax, bx	; 672C1
mov eax, dword [dword ecx+eax*4+off_CD498]	; 672C4
mov byte [eax], 2	; 672CB
mov eax, esi	; 672CE
shl eax, 8	; 672D0
or word [dword eax+hmtmgoalie], byte 0FFF0h	; 672D3
mov eax, dword [dword ecx+off_CD4A0]	; 672DB
.5:
mov byte [eax], 1	; 672E1
movsx eax, dx	; 672E4
shl eax, 8	; 672E7
add eax, hmtmstruct	; 672EA
call setpersonel	; 672EF
.x:
pop esi	; 672F4
pop edx	; 672F5
pop ecx	; 672F6
pop ebx	; 672F7
ret	; 672F8
%endif ; C
; C: src/c/engine/overlay/SetTeamGoalie.c
%ifdef CBUILD
%include "c/engine/overlay/SetTeamGoalie.inc"
%else
SetTeamGoalie:
push dword 10h	; 672F9
call __CHK	; 672FE
push ebx	; 67303
push ecx	; 67304
push esi	; 67305
movsx ebx, ax	; 67306
mov ecx, ebx	; 67309
shl ecx, 8	; 6730B
mov cx, word [dword ecx+hmtmgoalie]	; 6730E
mov esi, dword [cont1team-2]	; 67315
sar esi, 10h	; 6731B
inc ebx	; 6731E
cmp esi, ebx	; 6731F
je short .1	; 67321
mov esi, dword [cont2team-2]	; 67323
sar esi, 10h	; 67329
cmp esi, ebx	; 6732C
jne near .x	; 6732E
.1:
test dx, dx	; 67334
jge short .2	; 67337
movsx edx, ax	; 67339
shl edx, 8	; 6733C
or word [dword edx+hmtmgoalie], byte 0FFF0h	; 6733F
jmp short .3	; 67347
.2:
movsx ebx, ax	; 67349
shl ebx, 8	; 6734C
mov word [dword ebx+hmtmgoalie], dx	; 6734F
mov dl, byte [gmode]	; 67356
test dl, 1	; 6735C
jne short .3	; 6735F
test dl, 8	; 67361
je short .3	; 67364
mov edx, dword [puckc]	; 67366
mov bl, byte [edx]	; 6736C
test bl, bl	; 6736E
jl short .3	; 67370
cmp bl, 6	; 67372
setl dl	; 67375
mov ebx, edx	; 67378
and ebx, 0FFh	; 6737A
movsx edx, ax	; 67380
xor ebx, edx	; 67383
je short .3	; 67385
shl edx, 8	; 67387
or byte [dword edx+byte_DF64D], 0FFh	; 6738A
.3:
movsx edx, ax	; 67391
shl edx, 8	; 67394
cmp word [dword edx+hmtmgoalie], byte 0	; 67397
jge short .4	; 6739F
test cx, cx	; 673A1
jl short .x	; 673A4
.4:
movsx edx, ax	; 673A6
shl edx, 8	; 673A9
cmp cx, word [dword edx+hmtmgoalie]	; 673AC
je short .x	; 673B3
mov eax, hmtmstruct	; 673B5
add eax, edx	; 673BA
call setpersonel	; 673BC
.x:
pop esi	; 673C1
pop ecx	; 673C2
pop ebx	; 673C3
ret	; 673C4
%endif ; C
; C: src/c/engine/overlay/LoadTeamPalette.c
%ifdef CBUILD
%include "c/engine/overlay/LoadTeamPalette.inc"
%else
LoadTeamPalette:
push dword 30h	; 673C5
call __CHK	; 673CA
push ecx	; 673CF
push esi	; 673D0
push edi	; 673D1
push ebp	; 673D2
sub esp, byte 14h	; 673D3
mov edi, eax	; 673D6
mov dword [byte esp+010h], edx	; 673D8
mov esi, ebx	; 673DC
mov ecx, str_extBIN	; 673DE
mov ebx, str_HOMEPALS4	; 673E3
cmp byte [fileoncd+0A1h], 1	; 673E8
jne short .1	; 673EF
mov edx, dword [cddriveptr]	; 673F1
jmp short .2	; 673F7
.1:
xor edx, edx	; 673F9
.2:
mov eax, esp	; 673FB
call MakePath	; 673FD
push byte 0	; 67402
lea eax, [byte esp+04h]	; 67404
push eax	; 67408
call sub_8E8A0	; 67409
mov edx, eax	; 6740E
add esp, byte 8	; 67410
mov ebp, eax	; 67413
mov eax, edi	; 67415
shl eax, 3	; 67417
sub eax, edi	; 6741A
shl eax, 6	; 6741C
add edx, eax	; 6741F
xor eax, eax	; 67421
.3:
mov cl, byte [edx+eax]	; 67423
mov byte [dword esi+eax+0180h], cl	; 67426
inc eax	; 6742D
cmp eax, 0C0h	; 6742E
jl short LoadTeamPalette.3	; 67433
xor eax, eax	; 67435
add edx, 0C0h	; 67437
.4:
mov bl, byte [edx+eax]	; 6743D
mov byte [dword eax+byte_DC9D8], bl	; 67440
inc eax	; 67446
cmp eax, 100h	; 67447
jl short LoadTeamPalette.4	; 6744C
push ebp	; 6744E
call FreeMemBlock	; 6744F
add esp, byte 4	; 67454
mov ecx, str_extBIN	; 67457
mov ebx, str_AWAYPALS	; 6745C
cmp byte [fileoncd+02Bh], 1	; 67461
jne short .5	; 67468
mov edx, dword [cddriveptr]	; 6746A
jmp short .6	; 67470
.5:
xor edx, edx	; 67472
.6:
mov eax, esp	; 67474
call MakePath	; 67476
push byte 0	; 6747B
lea eax, [byte esp+04h]	; 6747D
push eax	; 67481
call sub_8E8A0	; 67482
mov edx, eax	; 67487
add esp, byte 8	; 67489
mov ebp, eax	; 6748C
mov ebx, dword [byte esp+010h]	; 6748E
mov eax, ebx	; 67492
shl eax, 3	; 67494
sub eax, ebx	; 67497
shl eax, 6	; 67499
add edx, eax	; 6749C
xor eax, eax	; 6749E
.7:
mov cl, byte [edx+eax]	; 674A0
mov byte [dword esi+eax+0240h], cl	; 674A3
inc eax	; 674AA
cmp eax, 0C0h	; 674AB
jl short LoadTeamPalette.7	; 674B0
xor eax, eax	; 674B2
add edx, 0C0h	; 674B4
.8:
mov bl, byte [edx+eax]	; 674BA
mov byte [dword eax+byte_DC8D8], bl	; 674BD
inc eax	; 674C3
cmp eax, 90h	; 674C4
jl short LoadTeamPalette.8	; 674C9
mov eax, 90h	; 674CB
.9:
mov bl, byte [edx+eax]	; 674D0
add bl, 40h	; 674D3
mov byte [dword eax+byte_DC8D8], bl	; 674D6
inc eax	; 674DC
cmp eax, 100h	; 674DD
jl short LoadTeamPalette.9	; 674E2
push ebp	; 674E4
call FreeMemBlock	; 674E5
add esp, byte 4	; 674EA
xor ecx, ecx	; 674ED
mov ebx, str_Rinkpal	; 674EF
cmp byte [fileoncd+015Fh], 1	; 674F4
jne short .10	; 674FB
mov edx, dword [cddriveptr]	; 674FD
jmp short .11	; 67503
.10:
xor edx, edx	; 67505
.11:
mov eax, esp	; 67507
call MakePath	; 67509
push byte 0	; 6750E
lea eax, [byte esp+04h]	; 67510
push eax	; 67514
call sub_8E83C	; 67515
add esp, byte 8	; 6751A
mov ebp, eax	; 6751D
push str_Pal30	; 6751F
push eax	; 67524
call sub_B30B4	; 67525
add esp, byte 8	; 6752A
lea edx, [byte eax+010h]	; 6752D
xor eax, eax	; 67530
.12:
mov bl, byte [edx+eax]	; 67532
mov byte [esi+eax], bl	; 67535
inc eax	; 67538
cmp eax, 180h	; 67539
jl short LoadTeamPalette.12	; 6753E
mov eax, 2F1h	; 67540
.13:
mov bl, byte [edx+eax]	; 67545
mov byte [esi+eax], bl	; 67548
inc eax	; 6754B
cmp eax, 300h	; 6754C
jl short LoadTeamPalette.13	; 67551
push ebp	; 67553
call FreeMemBlock	; 67554
add esp, byte 4	; 67559
add esp, byte 14h	; 6755C
pop ebp	; 6755F
pop edi	; 67560
pop esi	; 67561
pop ecx	; 67562
ret	; 67563
%endif ; C
