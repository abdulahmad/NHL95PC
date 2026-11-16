; What the pads do during a game: the timer queue that records buttons between frames, skating,
; passing and shooting input, line changes, the one-timer and receiving a pass (95G engine/input95).
bits 32
%include "hockey.inc"
section s_4FCE8 progbits alloc exec nowrite align=1
extern __CHK, a2touchpuck, apl, assexit, assinsert, assreplace, awscore, awtmflags
extern awtmlcnt, awtmline, awtmstruct, bannermsg, bannertimer, BlockShotDive, burst, assonetimer_blade
extern assonetimer_blade_y, fofdata2_b3, fofdata2_b7, c1playernum, c2playernum, camx, camy, changeplayer
extern checkob, checkwindow, clockcont_0, clockticks, CompLine, cont1team, cont2team, crowdlevel
extern donothing, doplayeracc, doshot, DrawPanelLine, demoflag, dword_CC0FA, playsuspended, ovlartbank
extern SpeechPatchNext, Endfaceoff, energywarn, EvadePC, fadeinpending, Findhittype, FlushGSumQueue, fodir1
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
extern threat, updateanim, vecdist, vtoa, penaltysc, SortPending, lcsel_aw, puckfaceoff2_ptab
extern puckfaceoff2_ptab_y, injurystop, fofdata2_w2, fofdata2_w4, fofdata2_w6, fofdata, fofdata_w2, penevteam
extern xc1, yc1, yleader
global joyq_pop, joyq_flush, joyq_peek, lineinput, faceoffinput, Acheck, CanBlockShot, CanBlockShot_ret6
global CanBlockShot_ret5, OppInReach, Holdplayer, lcselect, doinput, getlchoice, lcfound, ReadJoy1
global Readjoy_tail, ReadJoy2, CenterMouse, PassCompleted, assonetimer, OneTimerChk, asspassrec, SetPenaltyStrength
;-----------------------------------------------------------------------------
; joyq_pop                                                        4FCE8  95 PC
; Input queue. The timer ISR (main_startup SampleInputTick) samples both pads every 5 ticks
; into joyqueue (50 records of 3 bytes) while joysampling is set. The main loop takes the
; frame's record with joyq_peek (-> joyrec, read by ReadJoy1/ReadJoy2) and drops it with joyq_pop.
;-----------------------------------------------------------------------------
; C: src/engine/input/joyq_pop.c
%ifdef CBUILD
%include "c/engine/input/joyq_pop.inc"
%else
joyq_pop:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov edx, dword [joyqcount]
        test edx, edx
        jle short .x
        mov ax, word [joysampling]
        mov word [joysampling_save], ax
        xor ebx, ebx
        mov dword [joysampling], ebx
        lea ecx, [byte edx-01h]
        mov dword [joyqcount], ecx
        mov esi, dword [joyqhead]
        inc esi
        mov dword [joyqhead], esi
        cmp esi, byte 32h
        jl short .1
        mov dword [joyqhead], ebx
.1:
        mov eax, dword [joysampling_save-2]
        sar eax, 10h
        mov dword [joysampling], eax
.x:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; joyq_flush                                                      4FD47  95 PC
; Input queue: joyqcount = 0, joyqtick = 0
;-----------------------------------------------------------------------------
; C: src/engine/input/joyq_flush.c
%ifdef CBUILD
%include "c/engine/input/joyq_flush.inc"
%else
joyq_flush:
        push dword 8
        call __CHK
        push edx
        xor edx, edx
        mov dword [joyqcount], edx
        mov dword [joyqtick], edx
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; joyq_peek                                                       4FD62  95 PC
; Input queue: returns &joyqueue[joyqhead*3] or 0 when empty; main loop
; stores it in joyrec for Readjoy1/2
;-----------------------------------------------------------------------------
; C: src/engine/input/joyq_peek.c
%ifdef CBUILD
%include "c/engine/input/joyq_peek.inc"
%else
joyq_peek:
        push dword 8
        call __CHK
        push edx
        cmp dword [joyqcount], byte 0
        jne short .1
        xor eax, eax
        pop edx
        ret
.1:
        mov edx, dword [joyqhead]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, joyqueue
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; lineinput                                             4FD8E  94G logic94.asm
; role. The PC line change box is one-button: the highlighted choice
; (lcsel lcline) cycles every 60 frames (lctimer) and blinks every 12 (lcblink); a press takes it
; through lcfound. Otherwise the player skates (doplayeracc).
;-----------------------------------------------------------------------------
; C: src/engine/input/CanBlockShot.c (lineinput)
%ifdef CBUILD
%include "c/engine/input/CanBlockShot.lineinput.inc"
%else
lineinput:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ecx, eax
        mov ebx, dword [byte eax+tmptr]
        mov ah, byte [byte ebx+tmflags]
        test ah, 1
        je short .1
        mov dl, ah
        and dl, 0FEh
        mov byte [byte ebx+tmflags], dl
        mov eax, ecx
        call RequestLineChange
.1:
        test byte [byte ecx+pflags], 40h
        setne dl
        xor dh, dh
        mov esi, edx
        test byte [regd2], 40h
        je short .cycle
        movsx ebx, dx
        mov dx, word [nosplit ebx*2+lcsel]
        mov word [regd2], dx
        mov eax, ecx
        call lcfound
        xor edx, edx
        mov word [nosplit ebx*2+lcblink], dx
        mov word [nosplit ebx*2+lcboxon], dx
        jmp near CanBlockShot_ret5
.cycle:
        movsx ebx, dx
        add ebx, ebx
        mov dx, word [dword ebx+lctimer]
        mov edi, edx
        dec edi
        mov word [dword ebx+lctimer], di
        test dx, dx
        jne short .blink
        mov edx, edi
        add edx, byte 3Ch
        mov word [dword ebx+lctimer], dx
        cmp word [dword ebx+lcline], byte 3
        jle short .3
        mov edx, dword [dword ebx+lcsel-2]
        sar edx, 10h
        inc edx
        mov edi, 2
        jmp short .4
.3:
        mov edx, dword [dword ebx+lcsel-2]
        sar edx, 10h
        inc edx
        mov edi, 4
.4:
        mov eax, edx
        sar edx, 1Fh
        idiv edi
        mov word [dword ebx+lcsel], dx
        movsx ebx, si
        mov edx, dword [nosplit ebx*2+lcsel_aw]
        sar edx, 10h
        mov dx, word [nosplit edx*2+linenext]
        mov word [nosplit ebx*2+lcline], dx
        mov word [nosplit ebx*2+lcblink], 1
        mov word [nosplit ebx*2+lcblinktime], 0Ch
.blink:
        movsx ebx, si
        add ebx, ebx
        mov dx, word [dword ebx+lcblinktime]
        mov edi, edx
        dec edi
        mov word [dword ebx+lcblinktime], di
        test dx, dx
        jne short .move
        add edi, byte 0Ch
        mov word [dword ebx+lcblinktime], di
        cmp word [dword ebx+lcblink], byte 0
        sete dl
        xor dh, dh
        mov ebx, edx
        movsx edx, si
        mov word [nosplit edx*2+lcblink], bx
.move:
        mov bh, byte [byte ecx+pflags]
        test bh, 8
        je near CanBlockShot_ret5
        cmp dword [playsuspended], byte 0
        jne near CanBlockShot_ret5
        test bh, 20h
        jne near CanBlockShot_ret5
        test byte [byte ecx+pflags2], 1
        jne near CanBlockShot_ret5
        mov edx, dword [regd0-2]
        sar edx, 10h
        mov eax, ecx
        call doplayeracc
        jmp near CanBlockShot_ret5
%endif ; C
;-----------------------------------------------------------------------------
; faceoffinput                                          4FF0D  94G logic94.asm
; (afaceoffpl 17h, fodir1/fodir2, pf2aip). PC adds an automatic
; pull when temp5 runs out (SPA 7F1h) and picks the pull anim by pucktemp1.
;-----------------------------------------------------------------------------
; C: src/engine/input/faceoffinput.c
%ifdef CBUILD
%include "c/engine/input/faceoffinput.inc"
%else
faceoffinput:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov ebx, eax
        mov eax, dword [byte eax+assnum-2]
        sar eax, 10h
        cmp byte [byte ebx+eax+asslist], 17h
        jne near .x
        test byte [byte ebx+pflags], 80h
        je short .1
        mov ax, word [regd0]
        mov word [fodir2], ax
        jmp short .2
.1:
        mov ax, word [regd0]
        mov word [fodir1], ax
.2:
        mov cl, byte [byte ebx+pflags2]
        test cl, 2
        jne short .x
        test byte [regd1], 10h
        jne short .pull
        mov cx, word [byte ebx+temp5]
        dec ecx
        mov word [byte ebx+temp5], cx
        test cx, cx
        jge short .x
        mov edx, 7F1h
        mov eax, ebx
        call SetSPA
        pop edx
        pop ecx
        pop ebx
        ret
.pull:
        mov al, cl
        or al, 2
        mov byte [byte ebx+pflags2], al
        cmp word [pucktemp1], byte 11h
        jge short .3
        or byte [byte ebx+pflags], 20h
        mov edx, 7DDh
        jmp short .4
.3:
        mov edx, 0D05h
.4:
        mov eax, ebx
        call SetSPA
        mov word [byte ebx+temp5], 0FFFFh
.x:
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; Acheck                             4FFAE  94G logic94.asm, medium confidence
; start the hold-check animation of player p against player q: lock the
; animation (pfalock); the normal hold check, or the stick-in-the-air hold
; check when p has an impact and q is not behind p relative to the goal p
; shoots at (pfgoal; dy = p's Ypos - q's Ypos, negated when shooting up).
;-----------------------------------------------------------------------------
; C: src/engine/input/Acheck.c
%ifdef CBUILD
%include "c/engine/input/Acheck.inc"
%else
Acheck:
        push dword 8
        call __CHK
        push ebx
        mov ebx, edx
        or byte [byte eax+pflags], 20h
        cmp word [byte eax+impact], byte 0
        jne short .0
.hold:
        mov edx, 873h
        jmp short .set
.0:
        mov dx, word [byte eax+Ypos+2]
        sub dx, word [byte ebx+Ypos+2]
        test byte [byte eax+pflags], 80h
        je short .1
        neg edx
.1:
        test dx, dx
        jl short Acheck.hold
        mov edx, 639h
.set:
        call SetSPA
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CanBlockShot                                 4FFEE  95 PC, medium confidence
; may this player dive to block a shot? Shooter = puck carrier, or
; shotplayer if the puck is loose and heading at his goal; shooter must be in a shooting SPA, the
; player between him and the puck, facing him, and closer than the puck. Returns 0, or the dive
; direction+1 (0Ah = straight), direction also in [esi+4Ah]; Holdplayer passes it to BlockShotDive.
;-----------------------------------------------------------------------------
CanBlockShot:
        push dword 34h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        mov esi, eax
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jl short .loose
        cmp word [byte esi+SCnum], byte 6
        setl al
        xor edx, edx
        mov dl, al
        mov eax, dword [puckc]
        cmp byte [eax], 6
        setl al
        and eax, 0FFh
        cmp eax, edx
        jne short .loose
        xor eax, edx
        jmp near .x
.loose:
        mov eax, dword [pucky]
        mov bx, word [eax]
        test bx, bx
        jge short .1
        movsx eax, bx
        neg eax
        jmp short .2
.1:
        movsx eax, bx
.2:
        cmp eax, 0E8h
        jg near .no
        cmp eax, byte 4Eh
        jl near .no
        cmp word [byte esi+04Eh], byte 50h
        jg near .no
        test byte [byte esi+pflags], 80h
        setne al
        and eax, 0FFh
        mov ebp, eax
        setne al
        and eax, 0FFh
        add eax, byte 0Ch
        shl eax, 7
        mov edx, SortCords
        add edx, eax
        mov dword [byte esp+0Ch], edx
        test ebp, ebp
        je short .3
        mov eax, 3
        jmp short .4
.3:
        mov eax, 1
.4:
        mov eax, dword [nosplit eax*2+puckcross_m2]
        sar eax, 10h
        cmp eax, byte 0Ah
        jl near .no
        mov eax, dword [puckc]
        mov cl, byte [eax]
        test cl, cl
        jl short .5
        movsx eax, cl
        jmp short .shooter
.5:
        test ebp, ebp
        je short .6
        mov eax, dword [puckvy]
        cmp word [eax], byte 0
        jg near .no
.6:
        test ebp, ebp
        jne short .7
        mov eax, dword [puckvy]
        cmp word [eax], byte 0
        jl near .no
.7:
        mov bx, word [shotplayer]
        test bx, bx
        jl near .no
        cmp word [byte esi+SCnum], byte 6
        setl al
        xor edx, edx
        mov dl, al
        cmp bx, byte 6
        setl al
        and eax, 0FFh
        xor eax, edx
        je near .no
        mov eax, dword [shotplayer-2]
        sar eax, 10h
.shooter:
        shl eax, 7
        add eax, SortCords
        mov eax, dword [byte eax+SPA-2]
        sar eax, 10h
        cmp eax, 3F9h
        je short .shooting
        cmp eax, 491h
        je short .shooting
        cmp eax, 0DD3h
        je short .shooting
        cmp eax, 0E2Bh
        je short .shooting
        cmp eax, 1265h
        je short .shooting
        cmp eax, 12DDh
        je short .shooting
        cmp eax, 1355h
        je short .shooting
        cmp eax, 138Dh
        jne near .no
.shooting:
        mov edx, dword [byte esp+0Ch]
        mov edx, dword [edx]
        sar edx, 10h
        mov eax, dword [puckx]
        movsx eax, word [eax]
        sub eax, edx
        mov dword [esp], eax
        mov edi, dword [byte esp+0Ch]
        mov edi, dword [byte edi+Ypos]
        sar edi, 10h
        mov eax, dword [pucky]
        movsx eax, word [eax]
        sub eax, edi
        mov edi, eax
        push eax
        mov edx, dword [byte esp+04h]
        push edx
        call vecdist
        add esp, byte 8
        mov dword [byte esp+04h], eax
        movsx edx, di
        mov eax, dword [byte esp-02h]
        sar eax, 10h
        call vtoa
        cwde
        mov dword [byte esp+08h], eax
        mov edi, dword [byte esi+Ypos]
        sar edi, 10h
        test ebp, ebp
        je short .8
        cmp edi, byte 0FFFFFFB2h
        jge short .8
        cmp edi, 0FFFFFF18h
        jle short .8
        mov eax, dword [pucky]
        movsx eax, word [eax]
        cmp edi, eax
        jl short .between
.8:
        test ebp, ebp
        jne near .no
        cmp edi, byte 4Eh
        jle near .no
        cmp edi, 0E8h
        jge near .no
        mov eax, dword [pucky]
        movsx eax, word [eax]
        cmp edi, eax
        jle near .no
.between:
        mov edx, dword [esi]
        sar edx, 10h
        mov eax, dword [byte esp+0Ch]
        mov eax, dword [eax]
        sar eax, 10h
        sub edx, eax
        mov dword [esp], edx
        mov eax, dword [byte esp+0Ch]
        mov eax, dword [byte eax+Ypos]
        sar eax, 10h
        sub edi, eax
        push edi
        push edx
        call vecdist
        add esp, byte 8
        mov ebx, eax
        movsx edx, di
        mov eax, dword [byte esp-02h]
        sar eax, 10h
        call vtoa
        cwde
        test byte [byte esi+pflags], 8
        jne short .facing
        cmp eax, byte 2
        je near .no
        cmp eax, byte 6
        je near .no
        cmp word [byte esi+Ypos+2], byte 0
        jge short .9
        mov edx, dword [byte esi+Ypos]
        sar edx, 10h
        neg edx
        jmp short .10
.9:
        mov edx, dword [byte esi+Ypos]
        sar edx, 10h
.10:
        cmp edx, 80h
        jl near .no
        cmp word [byte esi+Xpos+2], byte 0
        jge short .11
        mov edx, dword [esi]
        sar edx, 10h
        neg edx
        jmp short .12
.11:
        mov edx, dword [esi]
        sar edx, 10h
.12:
        cmp edx, byte 64h
        jg near .no
.facing:
        mov edx, dword [byte esi+04Fh]
        sar edx, 18h
        mov edi, dword [byte esi+facedir-2]
        sar edi, 10h
        mov ebp, edx
        sub ebp, edi
        add ebp, byte 2
        and ebp, byte 7
        mov edi, dword [byte esp+08h]
        sub edi, eax
        lea eax, [byte edi+02h]
        and eax, byte 7
        sub edx, dword [byte esp+08h]
        inc edx
        and edx, byte 7
        cmp edx, byte 2
        jg near .no
        test byte [byte esi+pflags], 8
        je short .13
        cmp ebp, byte 4
        jg short .13
        cmp eax, byte 4
        jle short .14
.13:
        test byte [byte esi+pflags], 8
        jne short .no
        cmp ebp, byte 1
        jl short .no
        cmp eax, byte 1
        jl short .no
        cmp ebp, byte 3
        jg short .no
        cmp eax, byte 3
        jg short .no
.14:
        mov edi, dword [byte esp+04h]
        cmp ebx, edi
        jge short .no
        mov edx, dword [byte esi+04Ch]
        sar edx, 10h
        add ebx, edx
        lea edx, [edi+edi]
        cmp ebx, edx
        jge short .no
        cmp ebp, byte 2
        jne short .15
        cmp eax, ebp
        jne short .15
        mov eax, 0Ah
        jmp short .x
.15:
        mov edx, dword [byte esp+08h]
        mov word [byte esi+04Ah], dx
        inc eax
        jmp short .x
.no:
        xor eax, eax
.x:
        add esp, byte 10h
CanBlockShot_ret6:
        pop ebp
CanBlockShot_ret5:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; OppInReach                                   5033D  95 PC, medium confidence
; Returns 1 if one of the 6 opponents is within 30 px in x and y and in the
; front half of facedir (vtoa); holdplayer then plays the hold anim (873h)
; directly
;-----------------------------------------------------------------------------
; C: src/engine/input/CanBlockShot.c (OppInReach)
%ifdef CBUILD
%include "c/engine/input/CanBlockShot.OppInReach.inc"
%else
OppInReach:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov esi, eax
        cmp word [byte eax+SCnum], byte 6
        jge short .1
        mov eax, 6
        jmp short .2
.1:
        xor eax, eax
.2:
        shl eax, 7
        mov edi, SortCords
        add edi, eax
        xor ebp, ebp
.loop:
        mov edx, dword [edi]
        sar edx, 10h
        mov ebx, dword [esi]
        sar ebx, 10h
        sub edx, ebx
        mov ebx, edx
        mov ecx, edx
        movsx edx, dx
        movsx eax, bx
        call vtoa
        cwde
        mov edx, dword [byte esi+facedir-2]
        sar edx, 10h
        sub eax, edx
        lea edx, [byte eax+02h]
        and edx, byte 7
        cmp edx, byte 4
        jg short .next
        test ebx, ebx
        jge short .3
        neg ebx
.3:
        cmp ebx, byte 1Eh
        jge short .next
        test ecx, ecx
        jge short .4
        neg ecx
.4:
        cmp ecx, byte 1Eh
        jge short .next
        mov eax, 1
        jmp near CanBlockShot_ret6
.next:
        inc ebp
        add edi, 80h
        cmp ebp, byte 6
        jl short OppInReach.loop
        xor eax, eax
        jmp near CanBlockShot_ret6
%endif ; C
;-----------------------------------------------------------------------------
; Holdplayer                                            503CD  94G logic94.asm
; (A button, not the puck carrier) with two PC checks first:
; OppInReach -> hold anim 873h; CanBlockShot -> dive (BlockShotDive); else Acheck on SortCords[impactp].
;-----------------------------------------------------------------------------
; C: src/engine/input/Holdplayer.c
%ifdef CBUILD
%include "c/engine/input/Holdplayer.inc"
%else
Holdplayer:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        mov ebx, eax
        mov ah, byte [byte eax+pflags]
        or ah, 20h
        mov byte [byte ebx+pflags], ah
        cmp word [byte ebx+impact], byte 0
        jne short .acheck
        mov eax, ebx
        call OppInReach
        cmp eax, byte 1
        jne short .1
        mov edx, 873h
        mov eax, ebx
        call SetSPA
        pop edx
        pop ebx
        ret
.1:
        mov eax, ebx
        call CanBlockShot
        test eax, eax
        je short .acheck
        mov eax, ebx
        call BlockShotDive
        pop edx
        pop ebx
        ret
.acheck:
        mov edx, dword [byte ebx+impactp-2]
        sar edx, 10h
        shl edx, 7
        add edx, SortCords
        mov eax, ebx
        call Acheck
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; lcselect                                     50434  95 PC, medium confidence
; line change by number (lcrequest/lcreqchoice from the PC keys). Same tail
; as lcfound, but the line comes from the choice directly (+4 +6 for PP PK) instead of lchoicetab.
;-----------------------------------------------------------------------------
; C: src/engine/input/lcselect.c
%ifdef CBUILD
%include "c/engine/input/lcselect.inc"
%else
lcselect:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        test byte [gameopts], 4
        jne short .1
.no:
        xor eax, eax
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.1:
        mov ebx, dword [byte eax+tmptr]
        mov ecx, dword [byte eax+optmptr]
        mov cx, word [byte ecx+tmap]
        sub cx, word [byte ebx+tmap]
        je short .2
        cmp edx, byte 1
        jg short lcselect.no
.2:
        test cx, cx
        jne short .3
        cmp edx, byte 3
        jg short lcselect.no
.3:
        test cx, cx
        jge short .4
        add edx, byte 4
        jmp short .5
.4:
        jle short .5
        add edx, byte 6
.5:
        and byte [byte eax+pflags2], 0F7h
        or byte [byte eax+pflags], 8
        and byte [byte ebx+tmflags], 0FDh
        mov ecx, dword [byte ebx+tmline-2]
        sar ecx, 10h
        cmp ecx, edx
        je short .x
        mov word [byte ebx+tmline], dx
        cmp edx, byte 4
        jge short .6
        mov di, word [byte ebx+tmlcnt]
        inc edi
        mov word [byte ebx+tmlcnt], di
        cmp di, byte 3
        jl short .6
        mov esi, edi
        sub esi, byte 3
        mov word [byte ebx+tmlcnt], si
.6:
        movsx edx, dx
        test byte [byte eax+pflags], 40h
        setne al
        xor ah, ah
        cwde
        call DrawPanelLine
        mov eax, ebx
        call setpersonel
.x:
        mov eax, 1
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; doinput                                               504DA  94G logic94.asm
; from.0 on (the PC reads the pads in ReadJoy1/2 and calls this per
; controlled player; regd0 dpad, regd1 new presses, regd2 changes, regd3 held; bit 4 B, 5 C, 6 A):
; PC line change request -> lcselect; faceoff -> faceoffinput; pf2lcm -> lineinput; pfjoycon
; pfalock: B -> changeplayer, else the PC one-timer switch of control to passplayer
; puck carrier (.pc1): passmode ShotMode B setpassmode A SetLCmode C SetShotMode skate
; other (.notpc): A Holdplayer, B changeplayer, C burst, else skate.
;-----------------------------------------------------------------------------
; C: src/engine/input/doinput.c
%ifdef CBUILD
%include "c/engine/input/doinput.inc"
%else
doinput:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        mov ebx, eax
        mov esi, edx
        test byte [byte eax+pflags], 40h
        setne al
        mov edi, eax
        and edi, 0FFh
        cmp dword [penshotmode], byte 0
        jne short .1
        cmp dword [penshotlive], byte 0
        je short .lcreq
.1:
        test byte [gmode], 1
        jne near .x
.lcreq:
        cmp word [nosplit edi*2+lcrequest], byte 0
        je near .nolcreq
        cmp dword [penshotlive], byte 0
        jne short .nolcreq
        mov ax, word [cont1team]
        cmp ax, word [cont2team]
        jne short .2
        mov ax, word [byte ebx+SCnum]
        cmp ax, word [c1playernum]
        jne short .nolcreq
.2:
        test byte [gmode], 1
        je short .3
        test byte [byte ebx+pflags2], 8
        je short .4
.3:
        lea ecx, [edi+edi]
        mov edx, dword [dword ecx+lcreqchoice-2]
        sar edx, 10h
        mov eax, ebx
        call lcselect
        test ax, ax
        je short .4
        xor eax, eax
        mov word [dword ecx+lcblink], ax
        mov word [dword ecx+lcboxon], ax
.4:
        xor ecx, ecx
        mov word [nosplit edi*2+lcrequest], cx
.nolcreq:
        test byte [gmode2], 1
        je short .nfo
        mov eax, ebx
        call faceoffinput
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.nfo:
        test byte [byte ebx+pflags2], 8
        je short .nlcm
        mov eax, ebx
        call lineinput
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.nlcm:
        mov eax, dword [puckstruct+1Ah]
        sar eax, 10h
        cmp byte [dword eax+puckasslist], 1Ch
        jne short .joycon
        cmp dword [penshotmode], byte 0
        jne short .joycon
        mov al, byte [regd1]
        test al, 10h
        jne short .skip
        test al, 20h
        je near .x
.skip:
        mov dword [introskipped], 1
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.joycon:
        mov dh, byte [byte ebx+pflags]
        test dh, 8
        je near .x
        test dh, 20h
        je near .unlocked
        mov ecx, dword [puckc]
        movsx ax, byte [ecx]
        cmp ax, word [byte ebx+SCnum]
        je near .x
        cmp dword [playsuspended], byte 0
        jne near .x
        mov dh, byte [regd1]
        test dh, 10h
        je short .5
.change:
        movsx edx, si
        mov eax, ebx
        call changeplayer
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.5:
        mov ax, word [passplayer]
        mov si, word [byte ebx+SCnum]
        cmp ax, si
        jne short .6
        cmp dword [onetimerflag], byte 0
        je near .x
.setpassdir:
        mov ax, word [regd0]
        xor ah, ah
        and al, 0Fh
        mov word [passdir], ax
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.6:
        mov eax, dword [passplayer-2]
        sar eax, 10h
        shl eax, 7
        add eax, SortCords
        cmp byte [ecx], 0
        jge near .x
        test dh, 20h
        je near .x
        mov di, word [passplayer]
        test di, di
        jl near .x
        cmp word [byte eax+position], byte 0
        jle near .x
        cmp si, byte 6
        setl dl
        mov ecx, edx
        and ecx, 0FFh
        cmp di, byte 6
        setl dl
        and edx, 0FFh
        cmp edx, ecx
        jne near .x
        test byte [byte eax+pflags], 8
        jne near .x
        test byte [byte eax+pflags2], 4
        jne near .x
        cmp si, word [c1playernum]
.switch:
        jne short .7
        mov dx, word [byte eax+SCnum]
        cmp dx, word [c1playernum]
        je short .ot
        mov edx, dword [c1playernum-2]
        sar edx, 10h
        mov eax, dword [byte eax+SCnum-2]
        sar eax, 10h
        call restorepl
        mov word [c1playernum], ax
.ot:
        mov dword [onetimerflag], 1
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.7:
        mov dx, word [byte eax+SCnum]
        cmp dx, word [c2playernum]
        je short doinput.ot
        mov edx, dword [c2playernum-2]
        sar edx, 10h
        mov eax, dword [byte eax+SCnum-2]
        sar eax, 10h
        call restorepl
        mov word [c2playernum], ax
        jmp short doinput.ot
.unlocked:
        mov ecx, dword [puckc]
        movsx ax, byte [ecx]
        mov di, word [byte ebx+SCnum]
        cmp ax, di
        jne near .notpc
        mov eax, ebx
        call checkob
        cmp word [byte ebx+position], byte 0
        jne short .pc1
        test byte [byte ebx+pflags2], 2
        jne near .x
.pc1:
        mov cl, byte [sflags]
        test cl, 4
        je short .8
        mov eax, ebx
        call passmode
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.8:
        test cl, 8
        je short .9
        mov eax, ebx
        call ShotMode
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.9:
        mov al, byte [regd1]
        test al, 10h
        je short .10
        mov eax, ebx
        call setpassmode
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.10:
        test al, 40h
        je short .11
        cmp dword [penshotlive], byte 0
        jne short .11
        mov eax, ebx
        call SetLCmode
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.11:
        cmp word [byte ebx+position], byte 0
        je near .x
        test byte [regd1], 20h
        je near .acc
        mov eax, ebx
        call SetShotMode
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.notpc:
        cmp dword [playsuspended], byte 0
        jne near .x
        mov al, byte [regd1]
        test al, 40h
        je short .12
        mov eax, ebx
        call Holdplayer
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.12:
        test al, 10h
        jne near doinput.change
        cmp word [byte ebx+position], byte 0
        je near .x
        mov eax, dword [passplayer-2]
        sar eax, 10h
        shl eax, 7
        add eax, SortCords
        cmp di, word [passplayer]
        jne short .14
        test byte [regd1], 20h
        je short .13
        mov eax, ebx
        call burst
.13:
        cmp dword [onetimerflag], byte 0
        jne near doinput.setpassdir
        test byte [regd1], 10h
        jne near doinput.change
        cmp dword [playsuspended], byte 0
        jne near .x
        jmp near .acc
.14:
        cmp byte [ecx], 0
        jge short .15
        test byte [regd1], 20h
        je short .15
        cmp word [passplayer], byte 0
        jl short .15
        cmp di, byte 6
        setl dl
        mov ecx, edx
        and ecx, 0FFh
        cmp word [passplayer], byte 6
        setl dl
        and edx, 0FFh
        cmp edx, ecx
        jne short .15
        test byte [byte eax+pflags], 8
        jne short .15
        test byte [byte eax+pflags2], 4
        jne short .15
        cmp di, word [c1playernum]
        jmp near doinput.switch
.15:
        test byte [regd1], 20h
        je short .16
        mov eax, ebx
        call burst
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.16:
        cmp dword [playsuspended], byte 0
        jne short .x
.acc:
        mov edx, dword [regd0-2]
        sar edx, 10h
        mov eax, ebx
        call doplayeracc
.x:
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; getlchoice                                            50908  94G logic94.asm
; As 93G getlchoice: regd0 choice -> line via lchoicetab; +20h/+40h when the
; tmap of the two teams differ (93G +15h/+2Ah), + tmline*4 (93G *3)
;-----------------------------------------------------------------------------
; C: src/engine/input/getlchoice.c
%ifdef CBUILD
%include "c/engine/input/getlchoice.inc"
%else
getlchoice:
        push dword 10h
        call __CHK
        push ecx
        push edx
        push esi
        mov edx, dword [byte eax+tmptr]
        mov eax, dword [byte eax+optmptr]
        mov ax, word [byte eax+tmap]
        sub ax, word [byte edx+tmap]
        je short .1
        mov cx, word [regd0]
        add ecx, byte 20h
        mov word [regd0], cx
        test ax, ax
        jle short .1
        mov esi, ecx
        add esi, byte 20h
        mov word [regd0], si
.1:
        mov ax, word [byte edx+tmline]
        mov word [regd1], ax
        shl eax, 2
        add word [regd0], ax
        mov eax, dword [regd0-2]
        sar eax, 10h
        movsx ax, byte [dword eax+lchoicetab]
        mov word [regd0], ax
        pop esi
        pop edx
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; lcfound                                               50975  94G logic94.asm
; As 93G lcfound: getlchoice(regd2), if >= 0 clear pf2lcm, set pfjoycon,
; clear tmflags bit 1, tmline = line, setpersonel
;-----------------------------------------------------------------------------
; C: src/engine/input/lcfound.c
%ifdef CBUILD
%include "c/engine/input/lcfound.inc"
%else
lcfound:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov edx, eax
        mov ebx, dword [byte eax+tmptr]
        mov ax, word [regd2]
        mov word [regd0], ax
        mov eax, edx
        call getlchoice
        cmp word [regd0], byte 0
        jl short .x
        and byte [byte edx+pflags2], 0F7h
        or byte [byte edx+pflags], 8
        and byte [byte ebx+tmflags], 0FDh
        mov ax, word [regd0]
        cmp ax, word [byte ebx+tmline]
        je short .x
        mov word [byte ebx+tmline], ax
        cmp ax, 4
        jge short .1
        mov ax, word [byte ebx+tmlcnt]
        inc eax
        mov word [byte ebx+tmlcnt], ax
        cmp ax, 3
        jl short .1
        mov esi, eax
        sub esi, byte 3
        mov word [byte ebx+tmlcnt], si
.1:
        mov ecx, dword [regd0-2]
        sar ecx, 10h
        test byte [byte edx+pflags], 40h
        setne al
        xor ah, ah
        cwde
        mov edx, ecx
        call DrawPanelLine
        mov eax, ebx
        call setpersonel
.x:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ReadJoy1                                             50A05  94G middle94.asm
; ReadJoy1 ReadJoy2 = ReadJoy1/2, reading byte 0 1 of joyrec instead of the pad.
;-----------------------------------------------------------------------------
; C: src/engine/input/ReadJoy1.c
%ifdef CBUILD
%include "c/engine/input/ReadJoy1.inc"
%else
ReadJoy1:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov edx, dword [joyrec]
        test edx, edx
        je short .1
        mov al, byte [edx]
        xor ah, ah
        mov word [regd0], ax
        jmp short .2
.1:
        mov word [regd0], 8
.2:
        mov ax, word [regd0]
        xor ah, ah
        and al, 70h
        mov word [regd1], ax
        mov ax, word [lj1]
        mov word [regd2], ax
        mov ax, word [regd1]
        mov word [lj1], ax
Readjoy_tail:
        mov word [regd3], ax
        mov bx, word [regd2]
        xor ebx, eax
        mov word [regd2], bx
        mov ecx, eax
        and ecx, ebx
        mov word [regd1], cx
        mov ax, word [regd0]
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ReadJoy2                                             50A84  94G middle94.asm
; 94G spelling of the 93G Readjoy2
;-----------------------------------------------------------------------------
; C: src/engine/input/ReadJoy1.c (ReadJoy2)
%ifdef CBUILD
%include "c/engine/input/ReadJoy1.ReadJoy2.inc"
%else
ReadJoy2:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov edx, dword [joyrec]
        test edx, edx
        je short .1
        mov al, byte [byte edx+01h]
        xor ah, ah
        mov word [regd0], ax
        jmp short .2
.1:
        mov word [regd0], 8
.2:
        mov ax, word [regd0]
        xor ah, ah
        and al, 70h
        mov word [regd1], ax
        mov ax, word [lj2]
        mov word [regd2], ax
        mov ax, word [regd1]
        mov word [lj2], ax
        jmp near Readjoy_tail
%endif ; C
;-----------------------------------------------------------------------------
; CenterMouse                                  50ADE  95 PC, medium confidence
; MouseSetPos(160,100); called after control switches in
; engine_assign_faceoff
;-----------------------------------------------------------------------------
; C: src/engine/input/CenterMouse.c
%ifdef CBUILD
%include "c/engine/input/CenterMouse.inc"
%else
CenterMouse:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push byte 64h
        push dword 0A0h
        call MouseSetPos
        add esp, byte 8
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; PassCompleted                                50AFE  95 PC, medium confidence
; Pass received: when passplayer is on the receiver's team (and not in
; highlight mode) the team pass counter (team+28h) goes up; passplayer = -1.
; Called from PassRecOneTimer and physics
;-----------------------------------------------------------------------------
; C: src/engine/input/PassCompleted.c
%ifdef CBUILD
%include "c/engine/input/PassCompleted.inc"
%else
PassCompleted:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        cmp word [passplayer], byte 0
        jl short .1
        cmp word [byte eax+06Ah], byte 6
        setl dl
        mov ebx, edx
        and ebx, 0FFh
        cmp word [passplayer], byte 6
        setl dl
        and edx, 0FFh
        cmp edx, ebx
        jne short .1
        test byte [gmode], 10h
        jne short .1
        mov eax, dword [byte eax+06Ch]
        inc word [byte eax+028h]
.1:
        mov word [passplayer], 0FFFFh
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assonetimer                     50B55  94G onetimer94.asm, medium confidence
; Role match: the one-timer shot when the pass arrives (94G assignment 23h)
;-----------------------------------------------------------------------------
assonetimer:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ebx, eax
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jge short .1
        mov eax, dword [byte ebx+024h]
        sar eax, 18h
        cmp eax, byte 0FFFFFFE7h
        jge short .3
.1:
        mov eax, dword [puckc]
        movsx ax, byte [eax]
        cmp ax, word [byte ebx+SCnum]
        jne short .2
        mov eax, ebx
        call PassCompleted
.2:
        mov word [passplayer], 0FFFFh
        and byte [byte ebx+pflags], 0FEh
        mov eax, ebx
        call assexit
        xor edi, edi
        mov dword [onetimerflag], edi
        jmp near CanBlockShot_ret5
.3:
        cmp dword [onetimerflag], byte 0
        je near CanBlockShot_ret5
        mov dx, word [byte ebx+SPA]
        cmp dx, 0DD3h
        je short .4
        cmp dx, 0E2Bh
        jne near .16
.4:
        cmp word [byte ebx+SPAnum], byte 2
        jg short .8
        mov ch, byte [regd1]
        test ch, 10h
        jne short .5
        test ch, 40h
        je short .8
.5:
        and byte [sflags], 0F7h
        or byte [byte ebx+pflags], 20h
        cmp word [byte ebx+SPA], 0DD3h
        jne short .6
        mov word [byte ebx+SPA], 1355h
        jmp short .7
.6:
        mov word [byte ebx+SPA], 138Dh
.7:
        xor ecx, ecx
        mov dword [onetimerflag], ecx
.8:
        mov word [byte ebx+03Eh], 5
        mov ax, word [byte ebx+facedir]
        xor ah, ah
        and al, 7
        mov word [regd0], ax
        test byte [byte ebx+055h], 8
        je short .9
        mov eax, 8
        sub ax, word [regd0]
        xor ah, ah
        and al, 7
        mov word [regd0], ax
.9:
        mov eax, dword [regd0-2]
        sar eax, 10h
        movsx dx, byte [nosplit eax*2+assonetimer_blade_y]
        mov word [regd1], dx
        movsx ax, byte [nosplit eax*2+assonetimer_blade]
        mov word [regd0], ax
        test byte [byte ebx+055h], 8
        je short .10
        mov ecx, eax
        neg ecx
        mov word [regd0], cx
.10:
        mov dx, word [byte ebx+Xpos+2]
        add dx, word [regd0]
        mov eax, dword [puckx]
        sub dx, word [eax]
        movsx edx, dx
        mov ax, word [byte ebx+Ypos+2]
        mov cx, word [regd1]
        add ecx, eax
        mov eax, dword [pucky]
        mov si, word [eax]
        mov eax, ecx
        sub eax, esi
        cwde
        imul edx, edx
        imul eax, eax
        add edx, eax
        cmp word [byte ebx+SPAnum], byte 0
        jne short .11
        mov eax, dword [byte ebx+024h]
        sar eax, 18h
        cmp eax, byte 0FFFFFFFCh
        jl short .12
        cmp edx, 190h
        jl short .12
.11:
        cmp word [byte ebx+SPAnum], byte 2
        jne short .13
        cmp edx, 100h
        jge short .13
.12:
        mov word [byte ebx+SPAcnt], 0
        mov eax, ebx
        call updateanim
.13:
        cmp edx, byte 64h
        jle short .14
        cmp edx, 90h
        jg near CanBlockShot_ret5
        mov eax, dword [byte ebx+024h]
        sar eax, 18h
        cmp eax, byte 0FFFFFFF6h
        jge near CanBlockShot_ret5
.14:
        cmp word [passdir], byte 8
        jle short .15
        mov word [passdir], 8
.15:
        xor edx, edx
        mov dl, byte [byte ebx+05Bh]
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        add eax, byte 1Eh
        mov word [passspeed], ax
        mov word [byte ebx+SPAnum], 4
        mov word [byte ebx+SPAcnt], 4
        mov byte [byte ebx+046h], 0
        mov eax, ebx
        call updateanim
        mov eax, dword [byte ebx+06Ch]
        inc word [byte eax+018h]
        add word [crowdlevel], byte 64h
        mov eax, ebx
        call a2touchpuck
        mov eax, ebx
        call doshot
        mov eax, ebx
        call PassCompleted
        and byte [byte ebx+pflags], 0FEh
        mov eax, ebx
        call assexit
        xor esi, esi
        mov dword [onetimerflag], esi
        jmp near CanBlockShot_ret5
.16:
        cmp byte [byte ebx+027h], 16h
        jg near CanBlockShot_ret5
        cmp eax, byte 0FFFFFFF6h
        jl near CanBlockShot_ret5
        mov cl, byte [byte ebx+pflags]
        test cl, 8
        jne short .18
        test cl, 80h
        je short .17
        cmp word [byte ebx+Ypos+2], byte 46h
        jl near CanBlockShot_ret5
.17:
        test byte [byte ebx+pflags], 80h
        jne short .18
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
        cmp eax, byte 0FFFFFFBAh
        jg near CanBlockShot_ret5
.18:
        mov eax, dword [byte ebx+06Ch]
        inc word [byte eax+016h]
        movsx ax, byte [byte ebx+027h]
        add eax, 0Ah
        shl eax, 4
        cwde
        mov edx, dword [puckvx]
        movsx edx, word [edx]
        imul edx, eax
        sar edx, 10h
        mov ecx, dword [puckx]
        add dx, word [ecx]
        neg edx
        mov ecx, dword [puckvy]
        movsx ecx, word [ecx]
        imul eax, ecx
        sar eax, 10h
        test byte [byte ebx+pflags], 80h
        je short .19
        mov ecx, 0E8h
        jmp short .20
.19:
        mov ecx, 0FFFFFF18h
.20:
        mov esi, dword [pucky]
        movsx esi, word [esi]
        cwde
        add eax, esi
        sub ecx, eax
        movsx eax, cx
        movsx ecx, dx
        mov edx, eax
        mov eax, ecx
        call vtoa
        movsx edx, ax
        mov eax, ebx
        call Findhittype
        test ax, ax
        je short .21
        mov edx, 0E2Bh
        jmp short .22
.21:
        mov edx, 0DD3h
.22:
        mov eax, ebx
        call SetSPA
        jmp near CanBlockShot_ret5
;-----------------------------------------------------------------------------
; OneTimerChk                                     50E5C  95 PC, low confidence
; Receiver eax in the attacking zone (|y| between the blue line 4Eh and DEh,
; attacking side), opposing goalie present: scans teammates for a one-timer
; chance; asspassrec caller
;-----------------------------------------------------------------------------
; C: src/engine/input/OneTimerChk.c
%ifdef CBUILD
%include "c/engine/input/OneTimerChk.inc"
%else
OneTimerChk:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov ebx, eax
        cmp word [byte eax+Ypos+2], byte 0
        jge short .1
        mov eax, dword [byte eax+Ypos]
        sar eax, 10h
        neg eax
        jmp short .2
.1:
        mov eax, dword [byte eax+Ypos]
        sar eax, 10h
.2:
        cmp eax, byte 4Eh
        jle near .12
        cmp eax, 0DEh
        jge near .12
        cmp word [byte ebx+Ypos+2], byte 0
        setl al
        and eax, 0FFh
        test byte [byte ebx+pflags], 80h
        setne dl
        and edx, 0FFh
        xor eax, edx
        je near .12
        mov eax, dword [byte ebx+070h]
        cmp word [byte eax+tmgoalie], byte 0
        jl near .12
        cmp word [byte ebx+SCnum], byte 6
        jge short .3
        mov eax, 6
        jmp short .4
.3:
        xor eax, eax
.4:
        shl eax, 7
        add eax, SortCords
        xor edx, edx
.5:
        cmp word [byte eax+position], byte 0
        je short .6
        inc edx
        add eax, 80h
        cmp edx, byte 6
        jl short OneTimerChk.5
.6:
        mov edx, 3
        mov ecx, dword [ebx]
        sar ecx, 10h
        mov ebx, dword [eax]
        sar ebx, 10h
        xor ecx, ebx
        je short .11
        cmp word [byte eax+Xpos+2], byte 0
        jge short .7
        mov eax, ebx
        neg eax
        jmp short .8
.7:
        mov eax, ebx
.8:
        cmp eax, byte 0Ch
        jle short .10
.9:
        mov eax, 1
        pop edx
        pop ecx
        pop ebx
        ret
.10:
        cmp eax, byte 6
        jle short .11
        mov edx, 2
.11:
        movsx eax, dx
        call randomd0
        test ax, ax
        je short OneTimerChk.9
.12:
        xor eax, eax
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; asspassrec                                            50F3F  94G logic94.asm
; (asstab 13h, catching a pass). skatetopuck toward the pass; PC adds the
; one-timer (assonetimer, OneTimerChk) and the pass statistics (PassCompleted).
;-----------------------------------------------------------------------------
; C: src/engine/input/CanBlockShot.c (asspassrec)
%ifdef CBUILD
%include "c/engine/input/CanBlockShot.asspassrec.inc"
%else
asspassrec:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov edx, eax
        test byte [byte eax+044h], 20h
        jne near CanBlockShot_ret5
        test byte [gmode], 1
        je short .1
        xor edi, edi
        mov dword [onetimerflag], edi
        mov eax, edx
        call assexit
        mov eax, edx
        call donothing
        jmp near CanBlockShot_ret5
.1:
        dec byte [byte edx+027h]
        mov cl, byte [byte edx+pflags]
        test cl, 8
        je short .3
.2:
        mov eax, edx
        call assonetimer
        jmp near CanBlockShot_ret5
.3:
        test cl, 2
        je short .4
        mov al, cl
        and al, 0FCh
        mov ah, al
        or ah, 1
        mov byte [byte edx+pflags], ah
        mov word [byte edx+temp2], 8
        test byte [byte edx+pflags], 40h
        setne al
        xor ah, ah
        inc eax
        mov word [regd0], ax
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jge short .4
        mov ax, word [cont1team]
        mov bx, word [regd0]
        cmp ax, bx
        je short .4
        cmp bx, word [cont2team]
        je short .4
        mov eax, edx
        call OneTimerChk
        test eax, eax
        je short .4
        mov dword [onetimerflag], 1
.4:
        cmp dword [onetimerflag], byte 0
        je short .5
        and byte [regd1], 0AFh
        jmp short asspassrec.2
.5:
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jge short .11
        mov eax, dword [puckvx]
        mov si, word [eax]
        test si, si
        jge short .6
        movsx eax, si
        neg eax
        jmp short .7
.6:
        movsx eax, si
.7:
        cmp eax, 168h
        jge short .10
        mov eax, dword [puckvy]
        mov di, word [eax]
        test di, di
        jge short .8
        movsx eax, di
        neg eax
        jmp short .9
.8:
        movsx eax, di
.9:
        cmp eax, 168h
        jge short .10
        mov eax, edx
        call skatetopuck
.10:
        mov eax, dword [byte edx+024h]
        sar eax, 18h
        cmp eax, byte 0FFFFFFFBh
        jge near CanBlockShot_ret5
.11:
        and byte [byte edx+pflags], 0FEh
        mov eax, edx
        call assexit
        xor esi, esi
        mov dword [onetimerflag], esi
        mov eax, dword [puckc]
        movsx bx, byte [eax]
        cmp bx, word [byte edx+SCnum]
        jne short .12
        mov eax, edx
        call PassCompleted
        jmp near CanBlockShot_ret5
.12:
        cmp byte [eax], 0
        jl near CanBlockShot_ret5
        mov word [passplayer], 0FFFFh
        jmp near CanBlockShot_ret5
%endif ; C
;-----------------------------------------------------------------------------
; SetPenaltyStrength                           510A9  95 PC, medium confidence
; Each penalized roster player (tmpdst > 0) removes one skater slot (from slot 5
; down): position -1, temp5 -100; tmap = skaters left.
;-----------------------------------------------------------------------------
; C: src/engine/input/SetPenaltyStrength.c
%ifdef CBUILD
%include "c/engine/input/SetPenaltyStrength.inc"
%else
SetPenaltyStrength:
        push dword 14h
        call __CHK
        push ebx
        push edx
        push esi
        push edi
        xor esi, esi
        mov edi, hmtmstruct
        jmp short .5
.1:
        mov edx, 6
        mov ebx, 1Bh
        jmp short .4
.2:
        mov eax, ebx
        cmp word [byte edi+eax*2+07Eh], byte 0
        jle short .3
        cmp edx, byte 4
        jle short .3
        mov eax, esi
        shl eax, 2
        sub eax, esi
        add eax, eax
        dec edx
        add eax, edx
        shl eax, 7
        mov word [dword eax+SortCords+1Ah], 0FFFFh
        mov word [dword eax+SortCords+2Eh], 0FF9Ch
.3:
        dec ebx
.4:
        test ebx, ebx
        jge short SetPenaltyStrength.2
        mov word [byte edi+036h], dx
        mov edi, awtmstruct
        inc esi
.5:
        cmp esi, byte 2
        jl short SetPenaltyStrength.1
        pop edi
        pop esi
        pop edx
        pop ebx
        ret
%endif ; C
