; What the pads do during a game: the timer queue that records buttons between frames, skating,
; passing and shooting input, line changes, the one-timer and receiving a pass (95G engine/input95).
bits 32
%include "hockey.inc"
section s_4FCE8 progbits alloc exec nowrite align=1
extern __CHK, a2touchpuck, apl, assexit, assinsert, assreplace, awscore, awtmflags
extern awtmlcnt, awtmline, awtmstruct, bannermsg, bannertimer, BlockShotDive, burst, byte_CCBBA
extern byte_CCBBB, byte_E0393, byte_E0397, c1playernum, c2playernum, camx, camy, changeplayer
extern checkob, checkwindow, clockcont_0, clockticks, CompLine, cont1team, cont2team, crowdlevel
extern donothing, doplayeracc, doshot, DrawPanelLine, dword_CC0EC, dword_CC0FA, dword_CCC9C, dword_E0244
extern dword_E9A9E, Endfaceoff, energywarn, EvadePC, fadeinpending, Findhittype, FlushGSumQueue, fodir1
extern fodir2, fofdata2, forcepldata, fox, foy, FreeMemBlock, gameclock, gameopts
extern gmode, gmode2, gsp, hmroster, hmscore, hmtmflags, hmtmlcnt, hmtmline
extern hmtmpdst, hmtmstruct, iflags, introskipped, joyqcount, joyqhead, joyqtick, joyqueue
extern joyrec, joysampling, joysampling_save, lcblink, lcblinktime, lcboxon, lchoicetab, lcline
extern lcreqchoice, lcrequest, lcsel, lctimer, linenext, lj1, lj2, ltx
extern lty, MouseSetPos, onetimerflag, ovlseq, ovlstep, ovltimer, PaSpeechBusy, passdir
extern passmode, passplayer, passspeed, penshotlive, penshotmode, penshotplayer, penshotstart, penshotteam
extern PerTimeTotal, puckasslist, puckc, puckcross, puckcross_m2, puckstruct, pucktemp1, puckvx
extern puckvy, puckvz, puckx, pucky, puckz, randomd0, RefPen, refsignal
extern RefStep, regd0, regd1, regd2, regd3, regd4, RequestLineChange, ResetBench
extern resetplstuff, restorepl, ReturnGoalies, SetExitGame, SetLCmode, setpassmode, setpersonel, Setplass
extern setplayer, SetShotMode, SetSPA, SetupPenaltyShot, sflags, sflags3, sfx, ShotMode
extern shotplayer, skateto, skatetopuck, SkateToSpot, SortCords, sortobj15, SprSort, SprSortVert
extern StartFaceoffLineChange, Stop4Pen, StopDigiSample, textline1, textline2, textline3, textline4, textline5
extern threat, updateanim, vecdist, vtoa, word_C90D8, word_CBC44, word_CBC60, word_CBE8C
extern word_CBE8E, word_CBEC6, word_E0392, word_E0394, word_E0396, word_E0398, word_E039A, word_E9AAE
extern xc1, yc1, yleader
global joyq_pop, joyq_flush, joyq_peek, lineinput, faceoffinput, Acheck, CanBlockShot, CanBlockShot_ret6
global CanBlockShot_ret5, OppInReach, Holdplayer, lcselect, doinput, getlchoice, lcfound, ReadJoy1
global Readjoy_tail, ReadJoy2, CenterMouse, PassCompleted, assonetimer, OneTimerChk, asspassrec, SetPenaltyStrength
; Input queue. The timer ISR (main_startup SampleInputTick) samples both pads every 5 ticks
; into joyqueue (50 records of 3 bytes) while joysampling is set. The main loop takes the
; frame's record with joyq_peek (-> joyrec, read by ReadJoy1/ReadJoy2) and drops it with joyq_pop.
; C: src/engine/input/joyq_pop.c
%ifdef CBUILD
%include "c/engine/input/joyq_pop.inc"
%else
joyq_pop:
push dword 14h	; 4FCE8
call __CHK	; 4FCED
push ebx	; 4FCF2
push ecx	; 4FCF3
push edx	; 4FCF4
push esi	; 4FCF5
mov edx, dword [joyqcount]	; 4FCF6
test edx, edx	; 4FCFC
jle short .x	; 4FCFE
mov ax, word [joysampling]	; 4FD00
mov word [joysampling_save], ax	; 4FD06
xor ebx, ebx	; 4FD0C
mov dword [joysampling], ebx	; 4FD0E
lea ecx, [byte edx-01h]	; 4FD14
mov dword [joyqcount], ecx	; 4FD17
mov esi, dword [joyqhead]	; 4FD1D
inc esi	; 4FD23
mov dword [joyqhead], esi	; 4FD24
cmp esi, byte 32h	; 4FD2A
jl short .1	; 4FD2D
mov dword [joyqhead], ebx	; 4FD2F
.1:
mov eax, dword [joysampling_save-2]	; 4FD35
sar eax, 10h	; 4FD3A
mov dword [joysampling], eax	; 4FD3D
.x:
pop esi	; 4FD42
pop edx	; 4FD43
pop ecx	; 4FD44
pop ebx	; 4FD45
ret	; 4FD46
%endif ; C
; C: src/engine/input/joyq_flush.c
%ifdef CBUILD
%include "c/engine/input/joyq_flush.inc"
%else
joyq_flush:
push dword 8	; 4FD47
call __CHK	; 4FD4C
push edx	; 4FD51
xor edx, edx	; 4FD52
mov dword [joyqcount], edx	; 4FD54
mov dword [joyqtick], edx	; 4FD5A
pop edx	; 4FD60
ret	; 4FD61
%endif ; C
; C: src/engine/input/joyq_peek.c
%ifdef CBUILD
%include "c/engine/input/joyq_peek.inc"
%else
joyq_peek:
push dword 8	; 4FD62
call __CHK	; 4FD67
push edx	; 4FD6C
cmp dword [joyqcount], byte 0	; 4FD6D
jne short .1	; 4FD74
xor eax, eax	; 4FD76
pop edx	; 4FD78
ret	; 4FD79
.1:
mov edx, dword [joyqhead]	; 4FD7A
mov eax, edx	; 4FD80
shl eax, 2	; 4FD82
sub eax, edx	; 4FD85
add eax, joyqueue	; 4FD87
pop edx	; 4FD8C
ret	; 4FD8D
%endif ; C
; lineinput: role. The PC line change box is one-button: the highlighted choice
; (lcsel lcline) cycles every 60 frames (lctimer) and blinks every 12 (lcblink); a press takes it
; through lcfound. Otherwise the player skates (doplayeracc).
; C: src/engine/input/CanBlockShot.c (lineinput)
%ifdef CBUILD
%include "c/engine/input/CanBlockShot.lineinput.inc"
%else
lineinput:
push dword 18h	; 4FD8E
call __CHK	; 4FD93
push ebx	; 4FD98
push ecx	; 4FD99
push edx	; 4FD9A
push esi	; 4FD9B
push edi	; 4FD9C
mov ecx, eax	; 4FD9D
mov ebx, dword [byte eax+tmptr]	; 4FD9F
mov ah, byte [byte ebx+tmflags]	; 4FDA2
test ah, 1	; 4FDA5
je short .1	; 4FDA8
mov dl, ah	; 4FDAA
and dl, 0FEh	; 4FDAC
mov byte [byte ebx+tmflags], dl	; 4FDAF
mov eax, ecx	; 4FDB2
call RequestLineChange	; 4FDB4
.1:
test byte [byte ecx+pflags], 40h	; 4FDB9
setne dl	; 4FDBD
xor dh, dh	; 4FDC0
mov esi, edx	; 4FDC2
test byte [regd2], 40h	; 4FDC4
je short .cycle	; 4FDCB
movsx ebx, dx	; 4FDCD
mov dx, word [nosplit ebx*2+lcsel]	; 4FDD0
mov word [regd2], dx	; 4FDD8
mov eax, ecx	; 4FDDF
call lcfound	; 4FDE1
xor edx, edx	; 4FDE6
mov word [nosplit ebx*2+lcblink], dx	; 4FDE8
mov word [nosplit ebx*2+lcboxon], dx	; 4FDF0
jmp near CanBlockShot_ret5	; 4FDF8
.cycle:
movsx ebx, dx	; 4FDFD
add ebx, ebx	; 4FE00
mov dx, word [dword ebx+lctimer]	; 4FE02
mov edi, edx	; 4FE09
dec edi	; 4FE0B
mov word [dword ebx+lctimer], di	; 4FE0C
test dx, dx	; 4FE13
jne short .blink	; 4FE16
mov edx, edi	; 4FE18
add edx, byte 3Ch	; 4FE1A
mov word [dword ebx+lctimer], dx	; 4FE1D
cmp word [dword ebx+lcline], byte 3	; 4FE24
jle short .3	; 4FE2C
mov edx, dword [dword ebx+lcsel-2]	; 4FE2E
sar edx, 10h	; 4FE34
inc edx	; 4FE37
mov edi, 2	; 4FE38
jmp short .4	; 4FE3D
.3:
mov edx, dword [dword ebx+lcsel-2]	; 4FE3F
sar edx, 10h	; 4FE45
inc edx	; 4FE48
mov edi, 4	; 4FE49
.4:
mov eax, edx	; 4FE4E
sar edx, 1Fh	; 4FE50
idiv edi	; 4FE53
mov word [dword ebx+lcsel], dx	; 4FE55
movsx ebx, si	; 4FE5C
mov edx, dword [nosplit ebx*2+word_CBC60]	; 4FE5F
sar edx, 10h	; 4FE66
mov dx, word [nosplit edx*2+linenext]	; 4FE69
mov word [nosplit ebx*2+lcline], dx	; 4FE71
mov word [nosplit ebx*2+lcblink], 1	; 4FE79
mov word [nosplit ebx*2+lcblinktime], 0Ch	; 4FE83
.blink:
movsx ebx, si	; 4FE8D
add ebx, ebx	; 4FE90
mov dx, word [dword ebx+lcblinktime]	; 4FE92
mov edi, edx	; 4FE99
dec edi	; 4FE9B
mov word [dword ebx+lcblinktime], di	; 4FE9C
test dx, dx	; 4FEA3
jne short .move	; 4FEA6
add edi, byte 0Ch	; 4FEA8
mov word [dword ebx+lcblinktime], di	; 4FEAB
cmp word [dword ebx+lcblink], byte 0	; 4FEB2
sete dl	; 4FEBA
xor dh, dh	; 4FEBD
mov ebx, edx	; 4FEBF
movsx edx, si	; 4FEC1
mov word [nosplit edx*2+lcblink], bx	; 4FEC4
.move:
mov bh, byte [byte ecx+pflags]	; 4FECC
test bh, 8	; 4FECF
je near CanBlockShot_ret5	; 4FED2
cmp dword [dword_CCC9C], byte 0	; 4FED8
jne near CanBlockShot_ret5	; 4FEDF
test bh, 20h	; 4FEE5
jne near CanBlockShot_ret5	; 4FEE8
test byte [byte ecx+pflags2], 1	; 4FEEE
jne near CanBlockShot_ret5	; 4FEF2
mov edx, dword [regd0-2]	; 4FEF8
sar edx, 10h	; 4FEFE
mov eax, ecx	; 4FF01
call doplayeracc	; 4FF03
jmp near CanBlockShot_ret5	; 4FF08
%endif ; C
; faceoffinput: (afaceoffpl 17h, fodir1/fodir2, pf2aip). PC adds an automatic
; pull when temp5 runs out (SPA 7F1h) and picks the pull anim by pucktemp1.
; C: src/engine/input/faceoffinput.c
%ifdef CBUILD
%include "c/engine/input/faceoffinput.inc"
%else
faceoffinput:
push dword 10h	; 4FF0D
call __CHK	; 4FF12
push ebx	; 4FF17
push ecx	; 4FF18
push edx	; 4FF19
mov ebx, eax	; 4FF1A
mov eax, dword [byte eax+assnum-2]	; 4FF1C
sar eax, 10h	; 4FF1F
cmp byte [byte ebx+eax+asslist], 17h	; 4FF22
jne near .x	; 4FF27
test byte [byte ebx+pflags], 80h	; 4FF2D
je short .1	; 4FF31
mov ax, word [regd0]	; 4FF33
mov word [fodir2], ax	; 4FF39
jmp short .2	; 4FF3F
.1:
mov ax, word [regd0]	; 4FF41
mov word [fodir1], ax	; 4FF47
.2:
mov cl, byte [byte ebx+pflags2]	; 4FF4D
test cl, 2	; 4FF50
jne short .x	; 4FF53
test byte [regd1], 10h	; 4FF55
jne short .pull	; 4FF5C
mov cx, word [byte ebx+temp5]	; 4FF5E
dec ecx	; 4FF62
mov word [byte ebx+temp5], cx	; 4FF63
test cx, cx	; 4FF67
jge short .x	; 4FF6A
mov edx, 7F1h	; 4FF6C
mov eax, ebx	; 4FF71
call SetSPA	; 4FF73
pop edx	; 4FF78
pop ecx	; 4FF79
pop ebx	; 4FF7A
ret	; 4FF7B
.pull:
mov al, cl	; 4FF7C
or al, 2	; 4FF7E
mov byte [byte ebx+pflags2], al	; 4FF80
cmp word [pucktemp1], byte 11h	; 4FF83
jge short .3	; 4FF8B
or byte [byte ebx+pflags], 20h	; 4FF8D
mov edx, 7DDh	; 4FF91
jmp short .4	; 4FF96
.3:
mov edx, 0D05h	; 4FF98
.4:
mov eax, ebx	; 4FF9D
call SetSPA	; 4FF9F
mov word [byte ebx+temp5], 0FFFFh	; 4FFA4
.x:
pop edx	; 4FFAA
pop ecx	; 4FFAB
pop ebx	; 4FFAC
ret	; 4FFAD
%endif ; C
; C: src/engine/input/Acheck.c
%ifdef CBUILD
%include "c/engine/input/Acheck.inc"
%else
Acheck:
push dword 8	; 4FFAE
call __CHK	; 4FFB3
push ebx	; 4FFB8
mov ebx, edx	; 4FFB9
or byte [byte eax+pflags], 20h	; 4FFBB
cmp word [byte eax+impact], byte 0	; 4FFBF
jne short .0	; 4FFC4
.hold:
mov edx, 873h	; 4FFC6
jmp short .set	; 4FFCB
.0:
mov dx, word [byte eax+Ypos+2]	; 4FFCD
sub dx, word [byte ebx+Ypos+2]	; 4FFD1
test byte [byte eax+pflags], 80h	; 4FFD5
je short .1	; 4FFD9
neg edx	; 4FFDB
.1:
test dx, dx	; 4FFDD
jl short Acheck.hold	; 4FFE0
mov edx, 639h	; 4FFE2
.set:
call SetSPA	; 4FFE7
pop ebx	; 4FFEC
ret	; 4FFED
%endif ; C
; CanBlockShot: may this player dive to block a shot? Shooter = puck carrier, or
; shotplayer if the puck is loose and heading at his goal; shooter must be in a shooting SPA, the
; player between him and the puck, facing him, and closer than the puck. Returns 0, or the dive
; direction+1 (0Ah = straight), direction also in [esi+4Ah]; Holdplayer passes it to BlockShotDive.
CanBlockShot:
push dword 34h	; 4FFEE
call __CHK	; 4FFF3
push ebx	; 4FFF8
push ecx	; 4FFF9
push edx	; 4FFFA
push esi	; 4FFFB
push edi	; 4FFFC
push ebp	; 4FFFD
sub esp, byte 10h	; 4FFFE
mov esi, eax	; 50001
mov eax, dword [puckc]	; 50003
cmp byte [eax], 0	; 50008
jl short .loose	; 5000B
cmp word [byte esi+SCnum], byte 6	; 5000D
setl al	; 50012
xor edx, edx	; 50015
mov dl, al	; 50017
mov eax, dword [puckc]	; 50019
cmp byte [eax], 6	; 5001E
setl al	; 50021
and eax, 0FFh	; 50024
cmp eax, edx	; 50029
jne short .loose	; 5002B
xor eax, edx	; 5002D
jmp near .x	; 5002F
.loose:
mov eax, dword [pucky]	; 50034
mov bx, word [eax]	; 50039
test bx, bx	; 5003C
jge short .1	; 5003F
movsx eax, bx	; 50041
neg eax	; 50044
jmp short .2	; 50046
.1:
movsx eax, bx	; 50048
.2:
cmp eax, 0E8h	; 5004B
jg near .no	; 50050
cmp eax, byte 4Eh	; 50056
jl near .no	; 50059
cmp word [byte esi+04Eh], byte 50h	; 5005F
jg near .no	; 50064
test byte [byte esi+pflags], 80h	; 5006A
setne al	; 5006E
and eax, 0FFh	; 50071
mov ebp, eax	; 50076
setne al	; 50078
and eax, 0FFh	; 5007B
add eax, byte 0Ch	; 50080
shl eax, 7	; 50083
mov edx, SortCords	; 50086
add edx, eax	; 5008B
mov dword [byte esp+0Ch], edx	; 5008D
test ebp, ebp	; 50091
je short .3	; 50093
mov eax, 3	; 50095
jmp short .4	; 5009A
.3:
mov eax, 1	; 5009C
.4:
mov eax, dword [nosplit eax*2+puckcross_m2]	; 500A1
sar eax, 10h	; 500A8
cmp eax, byte 0Ah	; 500AB
jl near .no	; 500AE
mov eax, dword [puckc]	; 500B4
mov cl, byte [eax]	; 500B9
test cl, cl	; 500BB
jl short .5	; 500BD
movsx eax, cl	; 500BF
jmp short .shooter	; 500C2
.5:
test ebp, ebp	; 500C4
je short .6	; 500C6
mov eax, dword [puckvy]	; 500C8
cmp word [eax], byte 0	; 500CD
jg near .no	; 500D1
.6:
test ebp, ebp	; 500D7
jne short .7	; 500D9
mov eax, dword [puckvy]	; 500DB
cmp word [eax], byte 0	; 500E0
jl near .no	; 500E4
.7:
mov bx, word [shotplayer]	; 500EA
test bx, bx	; 500F1
jl near .no	; 500F4
cmp word [byte esi+SCnum], byte 6	; 500FA
setl al	; 500FF
xor edx, edx	; 50102
mov dl, al	; 50104
cmp bx, byte 6	; 50106
setl al	; 5010A
and eax, 0FFh	; 5010D
xor eax, edx	; 50112
je near .no	; 50114
mov eax, dword [shotplayer-2]	; 5011A
sar eax, 10h	; 5011F
.shooter:
shl eax, 7	; 50122
add eax, SortCords	; 50125
mov eax, dword [byte eax+SPA-2]	; 5012A
sar eax, 10h	; 5012D
cmp eax, 3F9h	; 50130
je short .shooting	; 50135
cmp eax, 491h	; 50137
je short .shooting	; 5013C
cmp eax, 0DD3h	; 5013E
je short .shooting	; 50143
cmp eax, 0E2Bh	; 50145
je short .shooting	; 5014A
cmp eax, 1265h	; 5014C
je short .shooting	; 50151
cmp eax, 12DDh	; 50153
je short .shooting	; 50158
cmp eax, 1355h	; 5015A
je short .shooting	; 5015F
cmp eax, 138Dh	; 50161
jne near .no	; 50166
.shooting:
mov edx, dword [byte esp+0Ch]	; 5016C
mov edx, dword [edx]	; 50170
sar edx, 10h	; 50172
mov eax, dword [puckx]	; 50175
movsx eax, word [eax]	; 5017A
sub eax, edx	; 5017D
mov dword [esp], eax	; 5017F
mov edi, dword [byte esp+0Ch]	; 50182
mov edi, dword [byte edi+Ypos]	; 50186
sar edi, 10h	; 50189
mov eax, dword [pucky]	; 5018C
movsx eax, word [eax]	; 50191
sub eax, edi	; 50194
mov edi, eax	; 50196
push eax	; 50198
mov edx, dword [byte esp+04h]	; 50199
push edx	; 5019D
call vecdist	; 5019E
add esp, byte 8	; 501A3
mov dword [byte esp+04h], eax	; 501A6
movsx edx, di	; 501AA
mov eax, dword [byte esp-02h]	; 501AD
sar eax, 10h	; 501B1
call vtoa	; 501B4
cwde	; 501B9
mov dword [byte esp+08h], eax	; 501BA
mov edi, dword [byte esi+Ypos]	; 501BE
sar edi, 10h	; 501C1
test ebp, ebp	; 501C4
je short .8	; 501C6
cmp edi, byte 0FFFFFFB2h	; 501C8
jge short .8	; 501CB
cmp edi, 0FFFFFF18h	; 501CD
jle short .8	; 501D3
mov eax, dword [pucky]	; 501D5
movsx eax, word [eax]	; 501DA
cmp edi, eax	; 501DD
jl short .between	; 501DF
.8:
test ebp, ebp	; 501E1
jne near .no	; 501E3
cmp edi, byte 4Eh	; 501E9
jle near .no	; 501EC
cmp edi, 0E8h	; 501F2
jge near .no	; 501F8
mov eax, dword [pucky]	; 501FE
movsx eax, word [eax]	; 50203
cmp edi, eax	; 50206
jle near .no	; 50208
.between:
mov edx, dword [esi]	; 5020E
sar edx, 10h	; 50210
mov eax, dword [byte esp+0Ch]	; 50213
mov eax, dword [eax]	; 50217
sar eax, 10h	; 50219
sub edx, eax	; 5021C
mov dword [esp], edx	; 5021E
mov eax, dword [byte esp+0Ch]	; 50221
mov eax, dword [byte eax+Ypos]	; 50225
sar eax, 10h	; 50228
sub edi, eax	; 5022B
push edi	; 5022D
push edx	; 5022E
call vecdist	; 5022F
add esp, byte 8	; 50234
mov ebx, eax	; 50237
movsx edx, di	; 50239
mov eax, dword [byte esp-02h]	; 5023C
sar eax, 10h	; 50240
call vtoa	; 50243
cwde	; 50248
test byte [byte esi+pflags], 8	; 50249
jne short .facing	; 5024D
cmp eax, byte 2	; 5024F
je near .no	; 50252
cmp eax, byte 6	; 50258
je near .no	; 5025B
cmp word [byte esi+Ypos+2], byte 0	; 50261
jge short .9	; 50266
mov edx, dword [byte esi+Ypos]	; 50268
sar edx, 10h	; 5026B
neg edx	; 5026E
jmp short .10	; 50270
.9:
mov edx, dword [byte esi+Ypos]	; 50272
sar edx, 10h	; 50275
.10:
cmp edx, 80h	; 50278
jl near .no	; 5027E
cmp word [byte esi+Xpos+2], byte 0	; 50284
jge short .11	; 50289
mov edx, dword [esi]	; 5028B
sar edx, 10h	; 5028D
neg edx	; 50290
jmp short .12	; 50292
.11:
mov edx, dword [esi]	; 50294
sar edx, 10h	; 50296
.12:
cmp edx, byte 64h	; 50299
jg near .no	; 5029C
.facing:
mov edx, dword [byte esi+04Fh]	; 502A2
sar edx, 18h	; 502A5
mov edi, dword [byte esi+facedir-2]	; 502A8
sar edi, 10h	; 502AB
mov ebp, edx	; 502AE
sub ebp, edi	; 502B0
add ebp, byte 2	; 502B2
and ebp, byte 7	; 502B5
mov edi, dword [byte esp+08h]	; 502B8
sub edi, eax	; 502BC
lea eax, [byte edi+02h]	; 502BE
and eax, byte 7	; 502C1
sub edx, dword [byte esp+08h]	; 502C4
inc edx	; 502C8
and edx, byte 7	; 502C9
cmp edx, byte 2	; 502CC
jg near .no	; 502CF
test byte [byte esi+pflags], 8	; 502D5
je short .13	; 502D9
cmp ebp, byte 4	; 502DB
jg short .13	; 502DE
cmp eax, byte 4	; 502E0
jle short .14	; 502E3
.13:
test byte [byte esi+pflags], 8	; 502E5
jne short .no	; 502E9
cmp ebp, byte 1	; 502EB
jl short .no	; 502EE
cmp eax, byte 1	; 502F0
jl short .no	; 502F3
cmp ebp, byte 3	; 502F5
jg short .no	; 502F8
cmp eax, byte 3	; 502FA
jg short .no	; 502FD
.14:
mov edi, dword [byte esp+04h]	; 502FF
cmp ebx, edi	; 50303
jge short .no	; 50305
mov edx, dword [byte esi+04Ch]	; 50307
sar edx, 10h	; 5030A
add ebx, edx	; 5030D
lea edx, [edi+edi]	; 5030F
cmp ebx, edx	; 50312
jge short .no	; 50314
cmp ebp, byte 2	; 50316
jne short .15	; 50319
cmp eax, ebp	; 5031B
jne short .15	; 5031D
mov eax, 0Ah	; 5031F
jmp short .x	; 50324
.15:
mov edx, dword [byte esp+08h]	; 50326
mov word [byte esi+04Ah], dx	; 5032A
inc eax	; 5032E
jmp short .x	; 5032F
.no:
xor eax, eax	; 50331
.x:
add esp, byte 10h	; 50333
CanBlockShot_ret6:
pop ebp	; 50336
CanBlockShot_ret5:
pop edi	; 50337
pop esi	; 50338
pop edx	; 50339
pop ecx	; 5033A
pop ebx	; 5033B
ret	; 5033C
; C: src/engine/input/CanBlockShot.c (OppInReach)
%ifdef CBUILD
%include "c/engine/input/CanBlockShot.OppInReach.inc"
%else
OppInReach:
push dword 1Ch	; 5033D
call __CHK	; 50342
push ebx	; 50347
push ecx	; 50348
push edx	; 50349
push esi	; 5034A
push edi	; 5034B
push ebp	; 5034C
mov esi, eax	; 5034D
cmp word [byte eax+SCnum], byte 6	; 5034F
jge short .1	; 50354
mov eax, 6	; 50356
jmp short .2	; 5035B
.1:
xor eax, eax	; 5035D
.2:
shl eax, 7	; 5035F
mov edi, SortCords	; 50362
add edi, eax	; 50367
xor ebp, ebp	; 50369
.loop:
mov edx, dword [edi]	; 5036B
sar edx, 10h	; 5036D
mov ebx, dword [esi]	; 50370
sar ebx, 10h	; 50372
sub edx, ebx	; 50375
mov ebx, edx	; 50377
mov ecx, edx	; 50379
movsx edx, dx	; 5037B
movsx eax, bx	; 5037E
call vtoa	; 50381
cwde	; 50386
mov edx, dword [byte esi+facedir-2]	; 50387
sar edx, 10h	; 5038A
sub eax, edx	; 5038D
lea edx, [byte eax+02h]	; 5038F
and edx, byte 7	; 50392
cmp edx, byte 4	; 50395
jg short .next	; 50398
test ebx, ebx	; 5039A
jge short .3	; 5039C
neg ebx	; 5039E
.3:
cmp ebx, byte 1Eh	; 503A0
jge short .next	; 503A3
test ecx, ecx	; 503A5
jge short .4	; 503A7
neg ecx	; 503A9
.4:
cmp ecx, byte 1Eh	; 503AB
jge short .next	; 503AE
mov eax, 1	; 503B0
jmp near CanBlockShot_ret6	; 503B5
.next:
inc ebp	; 503BA
add edi, 80h	; 503BB
cmp ebp, byte 6	; 503C1
jl short OppInReach.loop	; 503C4
xor eax, eax	; 503C6
jmp near CanBlockShot_ret6	; 503C8
%endif ; C
; Holdplayer: (A button, not the puck carrier) with two PC checks first:
; OppInReach -> hold anim 873h; CanBlockShot -> dive (BlockShotDive); else Acheck on SortCords[impactp].
; C: src/engine/input/Holdplayer.c
%ifdef CBUILD
%include "c/engine/input/Holdplayer.inc"
%else
Holdplayer:
push dword 0Ch	; 503CD
call __CHK	; 503D2
push ebx	; 503D7
push edx	; 503D8
mov ebx, eax	; 503D9
mov ah, byte [byte eax+pflags]	; 503DB
or ah, 20h	; 503DE
mov byte [byte ebx+pflags], ah	; 503E1
cmp word [byte ebx+impact], byte 0	; 503E4
jne short .acheck	; 503E9
mov eax, ebx	; 503EB
call OppInReach	; 503ED
cmp eax, byte 1	; 503F2
jne short .1	; 503F5
mov edx, 873h	; 503F7
mov eax, ebx	; 503FC
call SetSPA	; 503FE
pop edx	; 50403
pop ebx	; 50404
ret	; 50405
.1:
mov eax, ebx	; 50406
call CanBlockShot	; 50408
test eax, eax	; 5040D
je short .acheck	; 5040F
mov eax, ebx	; 50411
call BlockShotDive	; 50413
pop edx	; 50418
pop ebx	; 50419
ret	; 5041A
.acheck:
mov edx, dword [byte ebx+impactp-2]	; 5041B
sar edx, 10h	; 5041E
shl edx, 7	; 50421
add edx, SortCords	; 50424
mov eax, ebx	; 5042A
call Acheck	; 5042C
pop edx	; 50431
pop ebx	; 50432
ret	; 50433
%endif ; C
; lcselect: line change by number (lcrequest/lcreqchoice from the PC keys). Same tail
; as lcfound, but the line comes from the choice directly (+4 +6 for PP PK) instead of lchoicetab.
; C: src/engine/input/lcselect.c
%ifdef CBUILD
%include "c/engine/input/lcselect.inc"
%else
lcselect:
push dword 14h	; 50434
call __CHK	; 50439
push ebx	; 5043E
push ecx	; 5043F
push esi	; 50440
push edi	; 50441
test byte [gameopts], 4	; 50442
jne short .1	; 50449
.no:
xor eax, eax	; 5044B
pop edi	; 5044D
pop esi	; 5044E
pop ecx	; 5044F
pop ebx	; 50450
ret	; 50451
.1:
mov ebx, dword [byte eax+tmptr]	; 50452
mov ecx, dword [byte eax+optmptr]	; 50455
mov cx, word [byte ecx+tmap]	; 50458
sub cx, word [byte ebx+tmap]	; 5045C
je short .2	; 50460
cmp edx, byte 1	; 50462
jg short lcselect.no	; 50465
.2:
test cx, cx	; 50467
jne short .3	; 5046A
cmp edx, byte 3	; 5046C
jg short lcselect.no	; 5046F
.3:
test cx, cx	; 50471
jge short .4	; 50474
add edx, byte 4	; 50476
jmp short .5	; 50479
.4:
jle short .5	; 5047B
add edx, byte 6	; 5047D
.5:
and byte [byte eax+pflags2], 0F7h	; 50480
or byte [byte eax+pflags], 8	; 50484
and byte [byte ebx+tmflags], 0FDh	; 50488
mov ecx, dword [byte ebx+tmline-2]	; 5048C
sar ecx, 10h	; 5048F
cmp ecx, edx	; 50492
je short .x	; 50494
mov word [byte ebx+tmline], dx	; 50496
cmp edx, byte 4	; 5049A
jge short .6	; 5049D
mov di, word [byte ebx+tmlcnt]	; 5049F
inc edi	; 504A3
mov word [byte ebx+tmlcnt], di	; 504A4
cmp di, byte 3	; 504A8
jl short .6	; 504AC
mov esi, edi	; 504AE
sub esi, byte 3	; 504B0
mov word [byte ebx+tmlcnt], si	; 504B3
.6:
movsx edx, dx	; 504B7
test byte [byte eax+pflags], 40h	; 504BA
setne al	; 504BE
xor ah, ah	; 504C1
cwde	; 504C3
call DrawPanelLine	; 504C4
mov eax, ebx	; 504C9
call setpersonel	; 504CB
.x:
mov eax, 1	; 504D0
pop edi	; 504D5
pop esi	; 504D6
pop ecx	; 504D7
pop ebx	; 504D8
ret	; 504D9
%endif ; C
; doinput: from.0 on (the PC reads the pads in ReadJoy1/2 and calls this per
; controlled player; regd0 dpad, regd1 new presses, regd2 changes, regd3 held; bit 4 B, 5 C, 6 A):
; PC line change request -> lcselect; faceoff -> faceoffinput; pf2lcm -> lineinput; pfjoycon
; pfalock: B -> changeplayer, else the PC one-timer switch of control to passplayer
; puck carrier (.pc1): passmode ShotMode B setpassmode A SetLCmode C SetShotMode skate
; other (.notpc): A Holdplayer, B changeplayer, C burst, else skate.
; C: src/engine/input/doinput.c
%ifdef CBUILD
%include "c/engine/input/doinput.inc"
%else
doinput:
push dword 14h	; 504DA
call __CHK	; 504DF
push ebx	; 504E4
push ecx	; 504E5
push esi	; 504E6
push edi	; 504E7
mov ebx, eax	; 504E8
mov esi, edx	; 504EA
test byte [byte eax+pflags], 40h	; 504EC
setne al	; 504F0
mov edi, eax	; 504F3
and edi, 0FFh	; 504F5
cmp dword [penshotmode], byte 0	; 504FB
jne short .1	; 50502
cmp dword [penshotlive], byte 0	; 50504
je short .lcreq	; 5050B
.1:
test byte [gmode], 1	; 5050D
jne near .x	; 50514
.lcreq:
cmp word [nosplit edi*2+lcrequest], byte 0	; 5051A
je near .nolcreq	; 50523
cmp dword [penshotlive], byte 0	; 50529
jne short .nolcreq	; 50530
mov ax, word [cont1team]	; 50532
cmp ax, word [cont2team]	; 50538
jne short .2	; 5053F
mov ax, word [byte ebx+SCnum]	; 50541
cmp ax, word [c1playernum]	; 50545
jne short .nolcreq	; 5054C
.2:
test byte [gmode], 1	; 5054E
je short .3	; 50555
test byte [byte ebx+pflags2], 8	; 50557
je short .4	; 5055B
.3:
lea ecx, [edi+edi]	; 5055D
mov edx, dword [dword ecx+lcreqchoice-2]	; 50560
sar edx, 10h	; 50566
mov eax, ebx	; 50569
call lcselect	; 5056B
test ax, ax	; 50570
je short .4	; 50573
xor eax, eax	; 50575
mov word [dword ecx+lcblink], ax	; 50577
mov word [dword ecx+lcboxon], ax	; 5057E
.4:
xor ecx, ecx	; 50585
mov word [nosplit edi*2+lcrequest], cx	; 50587
.nolcreq:
test byte [gmode2], 1	; 5058F
je short .nfo	; 50596
mov eax, ebx	; 50598
call faceoffinput	; 5059A
pop edi	; 5059F
pop esi	; 505A0
pop ecx	; 505A1
pop ebx	; 505A2
ret	; 505A3
.nfo:
test byte [byte ebx+pflags2], 8	; 505A4
je short .nlcm	; 505A8
mov eax, ebx	; 505AA
call lineinput	; 505AC
pop edi	; 505B1
pop esi	; 505B2
pop ecx	; 505B3
pop ebx	; 505B4
ret	; 505B5
.nlcm:
mov eax, dword [puckstruct+1Ah]	; 505B6
sar eax, 10h	; 505BB
cmp byte [dword eax+puckasslist], 1Ch	; 505BE
jne short .joycon	; 505C5
cmp dword [penshotmode], byte 0	; 505C7
jne short .joycon	; 505CE
mov al, byte [regd1]	; 505D0
test al, 10h	; 505D5
jne short .skip	; 505D7
test al, 20h	; 505D9
je near .x	; 505DB
.skip:
mov dword [introskipped], 1	; 505E1
pop edi	; 505EB
pop esi	; 505EC
pop ecx	; 505ED
pop ebx	; 505EE
ret	; 505EF
.joycon:
mov dh, byte [byte ebx+pflags]	; 505F0
test dh, 8	; 505F3
je near .x	; 505F6
test dh, 20h	; 505FC
je near .unlocked	; 505FF
mov ecx, dword [puckc]	; 50605
movsx ax, byte [ecx]	; 5060B
cmp ax, word [byte ebx+SCnum]	; 5060F
je near .x	; 50613
cmp dword [dword_CCC9C], byte 0	; 50619
jne near .x	; 50620
mov dh, byte [regd1]	; 50626
test dh, 10h	; 5062C
je short .5	; 5062F
.change:
movsx edx, si	; 50631
mov eax, ebx	; 50634
call changeplayer	; 50636
pop edi	; 5063B
pop esi	; 5063C
pop ecx	; 5063D
pop ebx	; 5063E
ret	; 5063F
.5:
mov ax, word [passplayer]	; 50640
mov si, word [byte ebx+SCnum]	; 50646
cmp ax, si	; 5064A
jne short .6	; 5064D
cmp dword [onetimerflag], byte 0	; 5064F
je near .x	; 50656
.setpassdir:
mov ax, word [regd0]	; 5065C
xor ah, ah	; 50662
and al, 0Fh	; 50664
mov word [passdir], ax	; 50666
pop edi	; 5066C
pop esi	; 5066D
pop ecx	; 5066E
pop ebx	; 5066F
ret	; 50670
.6:
mov eax, dword [passplayer-2]	; 50671
sar eax, 10h	; 50676
shl eax, 7	; 50679
add eax, SortCords	; 5067C
cmp byte [ecx], 0	; 50681
jge near .x	; 50684
test dh, 20h	; 5068A
je near .x	; 5068D
mov di, word [passplayer]	; 50693
test di, di	; 5069A
jl near .x	; 5069D
cmp word [byte eax+position], byte 0	; 506A3
jle near .x	; 506A8
cmp si, byte 6	; 506AE
setl dl	; 506B2
mov ecx, edx	; 506B5
and ecx, 0FFh	; 506B7
cmp di, byte 6	; 506BD
setl dl	; 506C1
and edx, 0FFh	; 506C4
cmp edx, ecx	; 506CA
jne near .x	; 506CC
test byte [byte eax+pflags], 8	; 506D2
jne near .x	; 506D6
test byte [byte eax+pflags2], 4	; 506DC
jne near .x	; 506E0
cmp si, word [c1playernum]	; 506E6
.switch:
jne short .7	; 506ED
mov dx, word [byte eax+SCnum]	; 506EF
cmp dx, word [c1playernum]	; 506F3
je short .ot	; 506FA
mov edx, dword [c1playernum-2]	; 506FC
sar edx, 10h	; 50702
mov eax, dword [byte eax+SCnum-2]	; 50705
sar eax, 10h	; 50708
call restorepl	; 5070B
mov word [c1playernum], ax	; 50710
.ot:
mov dword [onetimerflag], 1	; 50716
pop edi	; 50720
pop esi	; 50721
pop ecx	; 50722
pop ebx	; 50723
ret	; 50724
.7:
mov dx, word [byte eax+SCnum]	; 50725
cmp dx, word [c2playernum]	; 50729
je short doinput.ot	; 50730
mov edx, dword [c2playernum-2]	; 50732
sar edx, 10h	; 50738
mov eax, dword [byte eax+SCnum-2]	; 5073B
sar eax, 10h	; 5073E
call restorepl	; 50741
mov word [c2playernum], ax	; 50746
jmp short doinput.ot	; 5074C
.unlocked:
mov ecx, dword [puckc]	; 5074E
movsx ax, byte [ecx]	; 50754
mov di, word [byte ebx+SCnum]	; 50758
cmp ax, di	; 5075C
jne near .notpc	; 5075F
mov eax, ebx	; 50765
call checkob	; 50767
cmp word [byte ebx+position], byte 0	; 5076C
jne short .pc1	; 50771
test byte [byte ebx+pflags2], 2	; 50773
jne near .x	; 50777
.pc1:
mov cl, byte [sflags]	; 5077D
test cl, 4	; 50783
je short .8	; 50786
mov eax, ebx	; 50788
call passmode	; 5078A
pop edi	; 5078F
pop esi	; 50790
pop ecx	; 50791
pop ebx	; 50792
ret	; 50793
.8:
test cl, 8	; 50794
je short .9	; 50797
mov eax, ebx	; 50799
call ShotMode	; 5079B
pop edi	; 507A0
pop esi	; 507A1
pop ecx	; 507A2
pop ebx	; 507A3
ret	; 507A4
.9:
mov al, byte [regd1]	; 507A5
test al, 10h	; 507AA
je short .10	; 507AC
mov eax, ebx	; 507AE
call setpassmode	; 507B0
pop edi	; 507B5
pop esi	; 507B6
pop ecx	; 507B7
pop ebx	; 507B8
ret	; 507B9
.10:
test al, 40h	; 507BA
je short .11	; 507BC
cmp dword [penshotlive], byte 0	; 507BE
jne short .11	; 507C5
mov eax, ebx	; 507C7
call SetLCmode	; 507C9
pop edi	; 507CE
pop esi	; 507CF
pop ecx	; 507D0
pop ebx	; 507D1
ret	; 507D2
.11:
cmp word [byte ebx+position], byte 0	; 507D3
je near .x	; 507D8
test byte [regd1], 20h	; 507DE
je near .acc	; 507E5
mov eax, ebx	; 507EB
call SetShotMode	; 507ED
pop edi	; 507F2
pop esi	; 507F3
pop ecx	; 507F4
pop ebx	; 507F5
ret	; 507F6
.notpc:
cmp dword [dword_CCC9C], byte 0	; 507F7
jne near .x	; 507FE
mov al, byte [regd1]	; 50804
test al, 40h	; 50809
je short .12	; 5080B
mov eax, ebx	; 5080D
call Holdplayer	; 5080F
pop edi	; 50814
pop esi	; 50815
pop ecx	; 50816
pop ebx	; 50817
ret	; 50818
.12:
test al, 10h	; 50819
jne near doinput.change	; 5081B
cmp word [byte ebx+position], byte 0	; 50821
je near .x	; 50826
mov eax, dword [passplayer-2]	; 5082C
sar eax, 10h	; 50831
shl eax, 7	; 50834
add eax, SortCords	; 50837
cmp di, word [passplayer]	; 5083C
jne short .14	; 50843
test byte [regd1], 20h	; 50845
je short .13	; 5084C
mov eax, ebx	; 5084E
call burst	; 50850
.13:
cmp dword [onetimerflag], byte 0	; 50855
jne near doinput.setpassdir	; 5085C
test byte [regd1], 10h	; 50862
jne near doinput.change	; 50869
cmp dword [dword_CCC9C], byte 0	; 5086F
jne near .x	; 50876
jmp near .acc	; 5087C
.14:
cmp byte [ecx], 0	; 50881
jge short .15	; 50884
test byte [regd1], 20h	; 50886
je short .15	; 5088D
cmp word [passplayer], byte 0	; 5088F
jl short .15	; 50897
cmp di, byte 6	; 50899
setl dl	; 5089D
mov ecx, edx	; 508A0
and ecx, 0FFh	; 508A2
cmp word [passplayer], byte 6	; 508A8
setl dl	; 508B0
and edx, 0FFh	; 508B3
cmp edx, ecx	; 508B9
jne short .15	; 508BB
test byte [byte eax+pflags], 8	; 508BD
jne short .15	; 508C1
test byte [byte eax+pflags2], 4	; 508C3
jne short .15	; 508C7
cmp di, word [c1playernum]	; 508C9
jmp near doinput.switch	; 508D0
.15:
test byte [regd1], 20h	; 508D5
je short .16	; 508DC
mov eax, ebx	; 508DE
call burst	; 508E0
pop edi	; 508E5
pop esi	; 508E6
pop ecx	; 508E7
pop ebx	; 508E8
ret	; 508E9
.16:
cmp dword [dword_CCC9C], byte 0	; 508EA
jne short .x	; 508F1
.acc:
mov edx, dword [regd0-2]	; 508F3
sar edx, 10h	; 508F9
mov eax, ebx	; 508FC
call doplayeracc	; 508FE
.x:
pop edi	; 50903
pop esi	; 50904
pop ecx	; 50905
pop ebx	; 50906
ret	; 50907
%endif ; C
; C: src/engine/input/getlchoice.c
%ifdef CBUILD
%include "c/engine/input/getlchoice.inc"
%else
getlchoice:
push dword 10h	; 50908
call __CHK	; 5090D
push ecx	; 50912
push edx	; 50913
push esi	; 50914
mov edx, dword [byte eax+tmptr]	; 50915
mov eax, dword [byte eax+optmptr]	; 50918
mov ax, word [byte eax+tmap]	; 5091B
sub ax, word [byte edx+tmap]	; 5091F
je short .1	; 50923
mov cx, word [regd0]	; 50925
add ecx, byte 20h	; 5092C
mov word [regd0], cx	; 5092F
test ax, ax	; 50936
jle short .1	; 50939
mov esi, ecx	; 5093B
add esi, byte 20h	; 5093D
mov word [regd0], si	; 50940
.1:
mov ax, word [byte edx+tmline]	; 50947
mov word [regd1], ax	; 5094B
shl eax, 2	; 50951
add word [regd0], ax	; 50954
mov eax, dword [regd0-2]	; 5095B
sar eax, 10h	; 50960
movsx ax, byte [dword eax+lchoicetab]	; 50963
mov word [regd0], ax	; 5096B
pop esi	; 50971
pop edx	; 50972
pop ecx	; 50973
ret	; 50974
%endif ; C
; C: src/engine/input/lcfound.c
%ifdef CBUILD
%include "c/engine/input/lcfound.inc"
%else
lcfound:
push dword 14h	; 50975
call __CHK	; 5097A
push ebx	; 5097F
push ecx	; 50980
push edx	; 50981
push esi	; 50982
mov edx, eax	; 50983
mov ebx, dword [byte eax+tmptr]	; 50985
mov ax, word [regd2]	; 50988
mov word [regd0], ax	; 5098E
mov eax, edx	; 50994
call getlchoice	; 50996
cmp word [regd0], byte 0	; 5099B
jl short .x	; 509A3
and byte [byte edx+pflags2], 0F7h	; 509A5
or byte [byte edx+pflags], 8	; 509A9
and byte [byte ebx+tmflags], 0FDh	; 509AD
mov ax, word [regd0]	; 509B1
cmp ax, word [byte ebx+tmline]	; 509B7
je short .x	; 509BB
mov word [byte ebx+tmline], ax	; 509BD
cmp ax, 4	; 509C1
jge short .1	; 509C5
mov ax, word [byte ebx+tmlcnt]	; 509C7
inc eax	; 509CB
mov word [byte ebx+tmlcnt], ax	; 509CC
cmp ax, 3	; 509D0
jl short .1	; 509D4
mov esi, eax	; 509D6
sub esi, byte 3	; 509D8
mov word [byte ebx+tmlcnt], si	; 509DB
.1:
mov ecx, dword [regd0-2]	; 509DF
sar ecx, 10h	; 509E5
test byte [byte edx+pflags], 40h	; 509E8
setne al	; 509EC
xor ah, ah	; 509EF
cwde	; 509F1
mov edx, ecx	; 509F2
call DrawPanelLine	; 509F4
mov eax, ebx	; 509F9
call setpersonel	; 509FB
.x:
pop esi	; 50A00
pop edx	; 50A01
pop ecx	; 50A02
pop ebx	; 50A03
ret	; 50A04
%endif ; C
; ReadJoy1 ReadJoy2 = ReadJoy1/2, reading byte 0 1 of joyrec instead of the pad.
; C: src/engine/input/ReadJoy1.c
%ifdef CBUILD
%include "c/engine/input/ReadJoy1.inc"
%else
ReadJoy1:
push dword 10h	; 50A05
call __CHK	; 50A0A
push ebx	; 50A0F
push ecx	; 50A10
push edx	; 50A11
mov edx, dword [joyrec]	; 50A12
test edx, edx	; 50A18
je short .1	; 50A1A
mov al, byte [edx]	; 50A1C
xor ah, ah	; 50A1E
mov word [regd0], ax	; 50A20
jmp short .2	; 50A26
.1:
mov word [regd0], 8	; 50A28
.2:
mov ax, word [regd0]	; 50A31
xor ah, ah	; 50A37
and al, 70h	; 50A39
mov word [regd1], ax	; 50A3B
mov ax, word [lj1]	; 50A41
mov word [regd2], ax	; 50A47
mov ax, word [regd1]	; 50A4D
mov word [lj1], ax	; 50A53
Readjoy_tail:
mov word [regd3], ax	; 50A59
mov bx, word [regd2]	; 50A5F
xor ebx, eax	; 50A66
mov word [regd2], bx	; 50A68
mov ecx, eax	; 50A6F
and ecx, ebx	; 50A71
mov word [regd1], cx	; 50A73
mov ax, word [regd0]	; 50A7A
pop edx	; 50A80
pop ecx	; 50A81
pop ebx	; 50A82
ret	; 50A83
%endif ; C
; C: src/engine/input/ReadJoy1.c (ReadJoy2)
%ifdef CBUILD
%include "c/engine/input/ReadJoy1.ReadJoy2.inc"
%else
ReadJoy2:
push dword 10h	; 50A84
call __CHK	; 50A89
push ebx	; 50A8E
push ecx	; 50A8F
push edx	; 50A90
mov edx, dword [joyrec]	; 50A91
test edx, edx	; 50A97
je short .1	; 50A99
mov al, byte [byte edx+01h]	; 50A9B
xor ah, ah	; 50A9E
mov word [regd0], ax	; 50AA0
jmp short .2	; 50AA6
.1:
mov word [regd0], 8	; 50AA8
.2:
mov ax, word [regd0]	; 50AB1
xor ah, ah	; 50AB7
and al, 70h	; 50AB9
mov word [regd1], ax	; 50ABB
mov ax, word [lj2]	; 50AC1
mov word [regd2], ax	; 50AC7
mov ax, word [regd1]	; 50ACD
mov word [lj2], ax	; 50AD3
jmp near Readjoy_tail	; 50AD9
%endif ; C
; C: src/engine/input/CenterMouse.c
%ifdef CBUILD
%include "c/engine/input/CenterMouse.inc"
%else
CenterMouse:
push dword 18h	; 50ADE
call __CHK	; 50AE3
push ebx	; 50AE8
push ecx	; 50AE9
push edx	; 50AEA
push byte 64h	; 50AEB
push dword 0A0h	; 50AED
call MouseSetPos	; 50AF2
add esp, byte 8	; 50AF7
pop edx	; 50AFA
pop ecx	; 50AFB
pop ebx	; 50AFC
ret	; 50AFD
%endif ; C
; C: src/engine/input/PassCompleted.c
%ifdef CBUILD
%include "c/engine/input/PassCompleted.inc"
%else
PassCompleted:
push dword 0Ch	; 50AFE
call __CHK	; 50B03
push ebx	; 50B08
push edx	; 50B09
cmp word [passplayer], byte 0	; 50B0A
jl short .1	; 50B12
cmp word [byte eax+06Ah], byte 6	; 50B14
setl dl	; 50B19
mov ebx, edx	; 50B1C
and ebx, 0FFh	; 50B1E
cmp word [passplayer], byte 6	; 50B24
setl dl	; 50B2C
and edx, 0FFh	; 50B2F
cmp edx, ebx	; 50B35
jne short .1	; 50B37
test byte [gmode], 10h	; 50B39
jne short .1	; 50B40
mov eax, dword [byte eax+06Ch]	; 50B42
inc word [byte eax+028h]	; 50B45
.1:
mov word [passplayer], 0FFFFh	; 50B49
pop edx	; 50B52
pop ebx	; 50B53
ret	; 50B54
%endif ; C
assonetimer:
push dword 18h	; 50B55
call __CHK	; 50B5A
push ebx	; 50B5F
push ecx	; 50B60
push edx	; 50B61
push esi	; 50B62
push edi	; 50B63
mov ebx, eax	; 50B64
mov eax, dword [puckc]	; 50B66
cmp byte [eax], 0	; 50B6B
jge short .1	; 50B6E
mov eax, dword [byte ebx+024h]	; 50B70
sar eax, 18h	; 50B73
cmp eax, byte 0FFFFFFE7h	; 50B76
jge short .3	; 50B79
.1:
mov eax, dword [puckc]	; 50B7B
movsx ax, byte [eax]	; 50B80
cmp ax, word [byte ebx+SCnum]	; 50B84
jne short .2	; 50B88
mov eax, ebx	; 50B8A
call PassCompleted	; 50B8C
.2:
mov word [passplayer], 0FFFFh	; 50B91
and byte [byte ebx+pflags], 0FEh	; 50B9A
mov eax, ebx	; 50B9E
call assexit	; 50BA0
xor edi, edi	; 50BA5
mov dword [onetimerflag], edi	; 50BA7
jmp near CanBlockShot_ret5	; 50BAD
.3:
cmp dword [onetimerflag], byte 0	; 50BB2
je near CanBlockShot_ret5	; 50BB9
mov dx, word [byte ebx+SPA]	; 50BBF
cmp dx, 0DD3h	; 50BC3
je short .4	; 50BC8
cmp dx, 0E2Bh	; 50BCA
jne near .16	; 50BCF
.4:
cmp word [byte ebx+SPAnum], byte 2	; 50BD5
jg short .8	; 50BDA
mov ch, byte [regd1]	; 50BDC
test ch, 10h	; 50BE2
jne short .5	; 50BE5
test ch, 40h	; 50BE7
je short .8	; 50BEA
.5:
and byte [sflags], 0F7h	; 50BEC
or byte [byte ebx+pflags], 20h	; 50BF3
cmp word [byte ebx+SPA], 0DD3h	; 50BF7
jne short .6	; 50BFD
mov word [byte ebx+SPA], 1355h	; 50BFF
jmp short .7	; 50C05
.6:
mov word [byte ebx+SPA], 138Dh	; 50C07
.7:
xor ecx, ecx	; 50C0D
mov dword [onetimerflag], ecx	; 50C0F
.8:
mov word [byte ebx+03Eh], 5	; 50C15
mov ax, word [byte ebx+facedir]	; 50C1B
xor ah, ah	; 50C1F
and al, 7	; 50C21
mov word [regd0], ax	; 50C23
test byte [byte ebx+055h], 8	; 50C29
je short .9	; 50C2D
mov eax, 8	; 50C2F
sub ax, word [regd0]	; 50C34
xor ah, ah	; 50C3B
and al, 7	; 50C3D
mov word [regd0], ax	; 50C3F
.9:
mov eax, dword [regd0-2]	; 50C45
sar eax, 10h	; 50C4A
movsx dx, byte [nosplit eax*2+byte_CCBBB]	; 50C4D
mov word [regd1], dx	; 50C56
movsx ax, byte [nosplit eax*2+byte_CCBBA]	; 50C5D
mov word [regd0], ax	; 50C66
test byte [byte ebx+055h], 8	; 50C6C
je short .10	; 50C70
mov ecx, eax	; 50C72
neg ecx	; 50C74
mov word [regd0], cx	; 50C76
.10:
mov dx, word [byte ebx+Xpos+2]	; 50C7D
add dx, word [regd0]	; 50C81
mov eax, dword [puckx]	; 50C88
sub dx, word [eax]	; 50C8D
movsx edx, dx	; 50C90
mov ax, word [byte ebx+Ypos+2]	; 50C93
mov cx, word [regd1]	; 50C97
add ecx, eax	; 50C9E
mov eax, dword [pucky]	; 50CA0
mov si, word [eax]	; 50CA5
mov eax, ecx	; 50CA8
sub eax, esi	; 50CAA
cwde	; 50CAC
imul edx, edx	; 50CAD
imul eax, eax	; 50CB0
add edx, eax	; 50CB3
cmp word [byte ebx+SPAnum], byte 0	; 50CB5
jne short .11	; 50CBA
mov eax, dword [byte ebx+024h]	; 50CBC
sar eax, 18h	; 50CBF
cmp eax, byte 0FFFFFFFCh	; 50CC2
jl short .12	; 50CC5
cmp edx, 190h	; 50CC7
jl short .12	; 50CCD
.11:
cmp word [byte ebx+SPAnum], byte 2	; 50CCF
jne short .13	; 50CD4
cmp edx, 100h	; 50CD6
jge short .13	; 50CDC
.12:
mov word [byte ebx+SPAcnt], 0	; 50CDE
mov eax, ebx	; 50CE4
call updateanim	; 50CE6
.13:
cmp edx, byte 64h	; 50CEB
jle short .14	; 50CEE
cmp edx, 90h	; 50CF0
jg near CanBlockShot_ret5	; 50CF6
mov eax, dword [byte ebx+024h]	; 50CFC
sar eax, 18h	; 50CFF
cmp eax, byte 0FFFFFFF6h	; 50D02
jge near CanBlockShot_ret5	; 50D05
.14:
cmp word [passdir], byte 8	; 50D0B
jle short .15	; 50D13
mov word [passdir], 8	; 50D15
.15:
xor edx, edx	; 50D1E
mov dl, byte [byte ebx+05Bh]	; 50D20
mov eax, edx	; 50D23
sar edx, 1Fh	; 50D25
LD sub, eax, edx	; 50D28
sar eax, 1	; 50D2A
add eax, byte 1Eh	; 50D2C
mov word [passspeed], ax	; 50D2F
mov word [byte ebx+SPAnum], 4	; 50D35
mov word [byte ebx+SPAcnt], 4	; 50D3B
mov byte [byte ebx+046h], 0	; 50D41
mov eax, ebx	; 50D45
call updateanim	; 50D47
mov eax, dword [byte ebx+06Ch]	; 50D4C
inc word [byte eax+018h]	; 50D4F
add word [crowdlevel], byte 64h	; 50D53
mov eax, ebx	; 50D5B
call a2touchpuck	; 50D5D
mov eax, ebx	; 50D62
call doshot	; 50D64
mov eax, ebx	; 50D69
call PassCompleted	; 50D6B
and byte [byte ebx+pflags], 0FEh	; 50D70
mov eax, ebx	; 50D74
call assexit	; 50D76
xor esi, esi	; 50D7B
mov dword [onetimerflag], esi	; 50D7D
jmp near CanBlockShot_ret5	; 50D83
.16:
cmp byte [byte ebx+027h], 16h	; 50D88
jg near CanBlockShot_ret5	; 50D8C
cmp eax, byte 0FFFFFFF6h	; 50D92
jl near CanBlockShot_ret5	; 50D95
mov cl, byte [byte ebx+pflags]	; 50D9B
test cl, 8	; 50D9E
jne short .18	; 50DA1
test cl, 80h	; 50DA3
je short .17	; 50DA6
cmp word [byte ebx+Ypos+2], byte 46h	; 50DA8
jl near CanBlockShot_ret5	; 50DAD
.17:
test byte [byte ebx+pflags], 80h	; 50DB3
jne short .18	; 50DB7
mov eax, dword [byte ebx+Ypos]	; 50DB9
sar eax, 10h	; 50DBC
cmp eax, byte 0FFFFFFBAh	; 50DBF
jg near CanBlockShot_ret5	; 50DC2
.18:
mov eax, dword [byte ebx+06Ch]	; 50DC8
inc word [byte eax+016h]	; 50DCB
movsx ax, byte [byte ebx+027h]	; 50DCF
add eax, 0Ah	; 50DD4
shl eax, 4	; 50DD9
cwde	; 50DDC
mov edx, dword [puckvx]	; 50DDD
movsx edx, word [edx]	; 50DE3
imul edx, eax	; 50DE6
sar edx, 10h	; 50DE9
mov ecx, dword [puckx]	; 50DEC
add dx, word [ecx]	; 50DF2
neg edx	; 50DF5
mov ecx, dword [puckvy]	; 50DF7
movsx ecx, word [ecx]	; 50DFD
imul eax, ecx	; 50E00
sar eax, 10h	; 50E03
test byte [byte ebx+pflags], 80h	; 50E06
je short .19	; 50E0A
mov ecx, 0E8h	; 50E0C
jmp short .20	; 50E11
.19:
mov ecx, 0FFFFFF18h	; 50E13
.20:
mov esi, dword [pucky]	; 50E18
movsx esi, word [esi]	; 50E1E
cwde	; 50E21
add eax, esi	; 50E22
sub ecx, eax	; 50E24
movsx eax, cx	; 50E26
movsx ecx, dx	; 50E29
mov edx, eax	; 50E2C
mov eax, ecx	; 50E2E
call vtoa	; 50E30
movsx edx, ax	; 50E35
mov eax, ebx	; 50E38
call Findhittype	; 50E3A
test ax, ax	; 50E3F
je short .21	; 50E42
mov edx, 0E2Bh	; 50E44
jmp short .22	; 50E49
.21:
mov edx, 0DD3h	; 50E4B
.22:
mov eax, ebx	; 50E50
call SetSPA	; 50E52
jmp near CanBlockShot_ret5	; 50E57
; C: src/engine/input/OneTimerChk.c
%ifdef CBUILD
%include "c/engine/input/OneTimerChk.inc"
%else
OneTimerChk:
push dword 10h	; 50E5C
call __CHK	; 50E61
push ebx	; 50E66
push ecx	; 50E67
push edx	; 50E68
mov ebx, eax	; 50E69
cmp word [byte eax+Ypos+2], byte 0	; 50E6B
jge short .1	; 50E70
mov eax, dword [byte eax+Ypos]	; 50E72
sar eax, 10h	; 50E75
neg eax	; 50E78
jmp short .2	; 50E7A
.1:
mov eax, dword [byte eax+Ypos]	; 50E7C
sar eax, 10h	; 50E7F
.2:
cmp eax, byte 4Eh	; 50E82
jle near .12	; 50E85
cmp eax, 0DEh	; 50E8B
jge near .12	; 50E90
cmp word [byte ebx+Ypos+2], byte 0	; 50E96
setl al	; 50E9B
and eax, 0FFh	; 50E9E
test byte [byte ebx+pflags], 80h	; 50EA3
setne dl	; 50EA7
and edx, 0FFh	; 50EAA
xor eax, edx	; 50EB0
je near .12	; 50EB2
mov eax, dword [byte ebx+070h]	; 50EB8
cmp word [byte eax+tmgoalie], byte 0	; 50EBB
jl near .12	; 50EC0
cmp word [byte ebx+SCnum], byte 6	; 50EC6
jge short .3	; 50ECB
mov eax, 6	; 50ECD
jmp short .4	; 50ED2
.3:
xor eax, eax	; 50ED4
.4:
shl eax, 7	; 50ED6
add eax, SortCords	; 50ED9
xor edx, edx	; 50EDE
.5:
cmp word [byte eax+position], byte 0	; 50EE0
je short .6	; 50EE5
inc edx	; 50EE7
add eax, 80h	; 50EE8
cmp edx, byte 6	; 50EED
jl short OneTimerChk.5	; 50EF0
.6:
mov edx, 3	; 50EF2
mov ecx, dword [ebx]	; 50EF7
sar ecx, 10h	; 50EF9
mov ebx, dword [eax]	; 50EFC
sar ebx, 10h	; 50EFE
xor ecx, ebx	; 50F01
je short .11	; 50F03
cmp word [byte eax+Xpos+2], byte 0	; 50F05
jge short .7	; 50F0A
mov eax, ebx	; 50F0C
neg eax	; 50F0E
jmp short .8	; 50F10
.7:
mov eax, ebx	; 50F12
.8:
cmp eax, byte 0Ch	; 50F14
jle short .10	; 50F17
.9:
mov eax, 1	; 50F19
pop edx	; 50F1E
pop ecx	; 50F1F
pop ebx	; 50F20
ret	; 50F21
.10:
cmp eax, byte 6	; 50F22
jle short .11	; 50F25
mov edx, 2	; 50F27
.11:
movsx eax, dx	; 50F2C
call randomd0	; 50F2F
test ax, ax	; 50F34
je short OneTimerChk.9	; 50F37
.12:
xor eax, eax	; 50F39
pop edx	; 50F3B
pop ecx	; 50F3C
pop ebx	; 50F3D
ret	; 50F3E
%endif ; C
; asspassrec: (asstab 13h, catching a pass). skatetopuck toward the pass; PC adds the
; one-timer (assonetimer, OneTimerChk) and the pass statistics (PassCompleted).
; C: src/engine/input/CanBlockShot.c (asspassrec)
%ifdef CBUILD
%include "c/engine/input/CanBlockShot.asspassrec.inc"
%else
asspassrec:
push dword 18h	; 50F3F
call __CHK	; 50F44
push ebx	; 50F49
push ecx	; 50F4A
push edx	; 50F4B
push esi	; 50F4C
push edi	; 50F4D
mov edx, eax	; 50F4E
test byte [byte eax+044h], 20h	; 50F50
jne near CanBlockShot_ret5	; 50F54
test byte [gmode], 1	; 50F5A
je short .1	; 50F61
xor edi, edi	; 50F63
mov dword [onetimerflag], edi	; 50F65
mov eax, edx	; 50F6B
call assexit	; 50F6D
mov eax, edx	; 50F72
call donothing	; 50F74
jmp near CanBlockShot_ret5	; 50F79
.1:
dec byte [byte edx+027h]	; 50F7E
mov cl, byte [byte edx+pflags]	; 50F81
test cl, 8	; 50F84
je short .3	; 50F87
.2:
mov eax, edx	; 50F89
call assonetimer	; 50F8B
jmp near CanBlockShot_ret5	; 50F90
.3:
test cl, 2	; 50F95
je short .4	; 50F98
mov al, cl	; 50F9A
and al, 0FCh	; 50F9C
mov ah, al	; 50F9E
or ah, 1	; 50FA0
mov byte [byte edx+pflags], ah	; 50FA3
mov word [byte edx+temp2], 8	; 50FA6
test byte [byte edx+pflags], 40h	; 50FAC
setne al	; 50FB0
xor ah, ah	; 50FB3
inc eax	; 50FB5
mov word [regd0], ax	; 50FB6
mov eax, dword [puckc]	; 50FBC
cmp byte [eax], 0	; 50FC1
jge short .4	; 50FC4
mov ax, word [cont1team]	; 50FC6
mov bx, word [regd0]	; 50FCC
cmp ax, bx	; 50FD3
je short .4	; 50FD6
cmp bx, word [cont2team]	; 50FD8
je short .4	; 50FDF
mov eax, edx	; 50FE1
call OneTimerChk	; 50FE3
test eax, eax	; 50FE8
je short .4	; 50FEA
mov dword [onetimerflag], 1	; 50FEC
.4:
cmp dword [onetimerflag], byte 0	; 50FF6
je short .5	; 50FFD
and byte [regd1], 0AFh	; 50FFF
jmp short asspassrec.2	; 51006
.5:
mov eax, dword [puckc]	; 51008
cmp byte [eax], 0	; 5100D
jge short .11	; 51010
mov eax, dword [puckvx]	; 51012
mov si, word [eax]	; 51017
test si, si	; 5101A
jge short .6	; 5101D
movsx eax, si	; 5101F
neg eax	; 51022
jmp short .7	; 51024
.6:
movsx eax, si	; 51026
.7:
cmp eax, 168h	; 51029
jge short .10	; 5102E
mov eax, dword [puckvy]	; 51030
mov di, word [eax]	; 51035
test di, di	; 51038
jge short .8	; 5103B
movsx eax, di	; 5103D
neg eax	; 51040
jmp short .9	; 51042
.8:
movsx eax, di	; 51044
.9:
cmp eax, 168h	; 51047
jge short .10	; 5104C
mov eax, edx	; 5104E
call skatetopuck	; 51050
.10:
mov eax, dword [byte edx+024h]	; 51055
sar eax, 18h	; 51058
cmp eax, byte 0FFFFFFFBh	; 5105B
jge near CanBlockShot_ret5	; 5105E
.11:
and byte [byte edx+pflags], 0FEh	; 51064
mov eax, edx	; 51068
call assexit	; 5106A
xor esi, esi	; 5106F
mov dword [onetimerflag], esi	; 51071
mov eax, dword [puckc]	; 51077
movsx bx, byte [eax]	; 5107C
cmp bx, word [byte edx+SCnum]	; 51080
jne short .12	; 51084
mov eax, edx	; 51086
call PassCompleted	; 51088
jmp near CanBlockShot_ret5	; 5108D
.12:
cmp byte [eax], 0	; 51092
jl near CanBlockShot_ret5	; 51095
mov word [passplayer], 0FFFFh	; 5109B
jmp near CanBlockShot_ret5	; 510A4
%endif ; C
; SetPenaltyStrength: Each penalized roster player (tmpdst > 0) removes one skater slot (from slot 5
; down): position -1, temp5 -100; tmap = skaters left.
; C: src/engine/input/SetPenaltyStrength.c
%ifdef CBUILD
%include "c/engine/input/SetPenaltyStrength.inc"
%else
SetPenaltyStrength:
push dword 14h	; 510A9
call __CHK	; 510AE
push ebx	; 510B3
push edx	; 510B4
push esi	; 510B5
push edi	; 510B6
xor esi, esi	; 510B7
mov edi, hmtmstruct	; 510B9
jmp short .5	; 510BE
.1:
mov edx, 6	; 510C0
mov ebx, 1Bh	; 510C5
jmp short .4	; 510CA
.2:
mov eax, ebx	; 510CC
cmp word [byte edi+eax*2+07Eh], byte 0	; 510CE
jle short .3	; 510D4
cmp edx, byte 4	; 510D6
jle short .3	; 510D9
mov eax, esi	; 510DB
shl eax, 2	; 510DD
sub eax, esi	; 510E0
add eax, eax	; 510E2
dec edx	; 510E4
add eax, edx	; 510E5
shl eax, 7	; 510E7
mov word [dword eax+SortCords+1Ah], 0FFFFh	; 510EA
mov word [dword eax+SortCords+2Eh], 0FF9Ch	; 510F3
.3:
dec ebx	; 510FC
.4:
test ebx, ebx	; 510FD
jge short SetPenaltyStrength.2	; 510FF
mov word [byte edi+036h], dx	; 51101
mov edi, awtmstruct	; 51105
inc esi	; 5110A
.5:
cmp esi, byte 2	; 5110B
jl short SetPenaltyStrength.1	; 5110E
pop edi	; 51110
pop esi	; 51111
pop edx	; 51112
pop ebx	; 51113
ret	; 51114
%endif ; C
