; Referee assignments: follow play, whistle, signals, puck drop (PC only).
bits 32
%include "hockey.inc"
section s_4DFF7 progbits alloc exec nowrite align=1
extern __CHK, assgoalie, assgoalie_popebp, assreplace, asswingd, asswingd_skateto, awscore, awtmap
extern awtmstruct, SortCordsOvlFlag, camy, ChkScorerMilestone, clockticks, CloseTextOverlay, crowdlevel, deferpending
extern demoflag, doplayeracc, SpeechPatchNext, UnusedEventWord, EvadePlayers, exitgame, fox, foy
extern gameclock, gameopts, gmode, gmode2, goalevent, goalevent_b1, goalevent_b2, goalevent_b3
extern goalevent_b4, gsp, hmrosterjersey, hmscore, hmtmap, hmtmstruct, HomeTeam, injurystop
extern joysampling, joysampling_save, LoadTeamPPV, musicon, ovlseq, ovltimer, PaGoal, PaSpeechBusy
extern penaltysc, PenBuf, PenShotAssign, penshotmode, periodendtime, PerTimeTotal, PlayCrowdSample, PostGoalEvent
extern puckc, puckstruct, puckvx, puckvy, puckvz, puckx, pucky, puckz
extern QueueGoalieNote, randomd0, RefPen, refsigdir, refsigspa_m2, RefStep, regd0, regd1
extern regd2, SetSPA, sflags3, skateto, SortCords, sounddev, teamabbrevs, VisTeam
extern vtoa, GoalState
global assrefatdot, assreffollow, SkateToSpot, CrowdOnStoppage, assrefwhistle, ass_replace_popx, ass_popx, ass_skate_temp34
global assrefsignal, assrefgoalpa, assrefdrop, assrefgoalline
;-----------------------------------------------------------------------------
; assrefatdot                                  4DFF7  95 PC, medium confidence
; Asstab 1Eh (StartHL2, puckfaceoff2): while play is stopped (injurystop 0,
; clock running) holds the referee at the faceoff spot fox/C90B4 offset
; +-0Fh, facing 2/6
;-----------------------------------------------------------------------------
; C: src/engine/referee/assrefatdot.c
%ifdef CBUILD
%include "c/engine/referee/assrefatdot.inc"
%else
assrefatdot:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        mov ebx, eax
        test byte [byte eax+pflags], 20h
        jne near .x
        cmp word [injurystop], byte 0
        jne near .x
        cmp word [gameclock], byte 0
        jne short .1
        cmp word [clockticks], byte 0
        je near .x
.1:
        mov dl, byte [byte ebx+pflags]
        test dl, 2
        je short .4
        mov dh, dl
        and dh, 0FDh
        mov byte [byte ebx+pflags], dh
        cmp word [fox], byte 0
        jg short .2
        mov eax, 2
        jmp short .3
.2:
        mov eax, 6
.3:
        mov word [byte ebx+facedir], ax
        mov edx, 0C57h
        mov eax, ebx
        call SetSPA
        and byte [byte ebx+pflags], 0FBh
        and byte [byte ebx+pflags2], 0DFh
.4:
        test byte [gmode2], 1
        jne short .x
        cmp word [fox], byte 0
        jg short .5
        mov eax, dword [fox-2]
        sar eax, 10h
        sub eax, byte 0Fh
        jmp short .6
.5:
        mov eax, dword [fox-2]
        sar eax, 10h
        add eax, byte 0Fh
.6:
        mov word [byte ebx+Xpos+2], ax
        mov ax, word [foy]
        mov word [byte ebx+Ypos+2], ax
        mov word [byte ebx+Yvel], 0
        mov ax, word [byte ebx+Yvel]
        mov word [byte ebx+Xvel], ax
.x:
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assreffollow                                 4E0BD  95 PC, medium confidence
; Asstab 1Fh (StartHL2, Endfaceoff, Goal): picks a spot by puck zone (x
; +-46h/78h/90h, y +-0EDh/0E8h or camy) and skates the referee there; idles
; (doplayeracc 8) when the clock is stopped
;-----------------------------------------------------------------------------
; C: src/engine/referee/assrefwhistle.c (assreffollow)
%ifdef CBUILD
%include "c/engine/referee/assrefwhistle.assreffollow.inc"
%else
assreffollow:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ebx, eax
        mov eax, dword [puckc]
        movsx eax, byte [eax]
        shl eax, 7
        mov ecx, SortCords
        add ecx, eax
        test byte [byte ebx+pflags], 20h
        jne near ass_popx
        cmp word [gameclock], byte 0
        jne short .1
        cmp word [clockticks], byte 0
        jne short .1
        mov edx, 8
        mov eax, ebx
        call doplayeracc
        jmp near ass_popx
.1:
        mov dl, byte [byte ebx+pflags]
        test dl, 2
        je short .2
        mov dh, dl
        and dh, 0FDh
        mov byte [byte ebx+pflags], dh
        mov edx, 0A5Bh
        mov eax, ebx
        call SetSPA
.2:
        mov eax, dword [puckx]
        mov di, word [eax]
        test di, di
        jge short .3
        movsx eax, di
        neg eax
        jmp short .4
.3:
        movsx eax, di
.4:
        cmp eax, byte 32h
        jge near .12
        mov eax, dword [pucky]
        mov dx, word [eax]
        test dx, dx
        jge short .5
        movsx eax, dx
        neg eax
        jmp short .6
.5:
        movsx eax, dx
.6:
        cmp eax, 0ACh
        jle short .12
        mov eax, dword [pucky]
        mov si, word [eax]
        test si, si
        jge short .7
        movsx eax, si
        neg eax
        jmp short .8
.7:
        movsx eax, si
.8:
        cmp eax, 0E8h
        jge short .12
        cmp word [byte ebx+Xpos+2], byte 0
        jle short .9
        mov eax, 46h
        jmp short .10
.9:
        mov eax, 0FFFFFFBAh
.10:
        mov word [byte ebx+temp3], ax
        mov eax, dword [pucky]
        cmp word [eax], byte 0
        jle short .11
        mov eax, 0EDh
        jmp near .23
.11:
        mov eax, 0FFFFFF13h
        jmp near .23
.12:
        mov eax, dword [pucky]
        mov di, word [eax]
        test di, di
        jge short .13
        movsx eax, di
        neg eax
        jmp short .14
.13:
        movsx eax, di
.14:
        cmp eax, byte 62h
        jle short .19
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jl short .15
        test byte [byte ecx+044h], 80h
        setne al
        mov ecx, eax
        and ecx, 0FFh
        mov eax, dword [pucky]
        cmp word [eax], byte 0
        setl al
        and eax, 0FFh
        xor eax, ecx
        je short .19
.15:
        cmp word [byte ebx+Xpos+2], byte 0
        jle short .16
        mov eax, 78h
        jmp short .17
.16:
        mov eax, 0FFFFFF88h
.17:
        mov word [byte ebx+temp3], ax
        mov eax, dword [pucky]
        cmp word [eax], byte 0
        jle short .18
        mov eax, 0E8h
        jmp short .23
.18:
        mov eax, 0FFFFFF18h
        jmp short .23
.19:
        cmp word [byte ebx+Xpos+2], byte 0
        jle short .20
        mov eax, 90h
        jmp short .21
.20:
        mov eax, 0FFFFFF70h
.21:
        mov word [byte ebx+temp3], ax
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
        mov ecx, dword [camy-2]
        sar ecx, 10h
        sub eax, ecx
        test eax, eax
        jge short .22
        neg eax
.22:
        cmp eax, byte 32h
        jle short .24
        mov ax, word [camy]
.23:
        mov word [byte ebx+temp4], ax
.24:
        mov ax, word [byte ebx+temp3]
        mov word [regd0], ax
        mov ax, word [byte ebx+temp4]
        mov word [regd1], ax
        mov edx, EvadePlayers
        jmp near asswingd_skateto
%endif ; C
;-----------------------------------------------------------------------------
; SkateToSpot                                  4E292  95 PC, medium confidence
; Player eax skates to regd0/regd1; within 8 in x and y it snaps there and
; stops (Xvel/Yvel 0), else skateto with SetSPA / vtoa facing; used by the PC
; scripted assignments
;-----------------------------------------------------------------------------
SkateToSpot:
        push dword 2Ch
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 18h
        mov ebx, eax
        mov si, word [regd0]
        sub si, word [byte eax+02h]
        test si, si
        jge short .1
        movsx eax, si
        neg eax
        jmp short .2
.1:
        movsx eax, si
.2:
        mov dword [byte esp+0Ch], eax
        mov cx, word [regd1]
        sub cx, word [byte ebx+Ypos+2]
        test cx, cx
        jge short .3
        movsx eax, cx
        neg eax
        jmp short .4
.3:
        movsx eax, cx
.4:
        mov dword [byte esp+010h], eax
        cmp word [byte esp+0Ch], byte 8
        jge short .5
        cmp word [byte esp+010h], byte 8
        jge short .5
        mov word [byte ebx+Yvel], 0
        mov ax, word [byte ebx+Yvel]
        mov word [byte ebx+Xvel], ax
        mov ax, word [regd0]
        mov word [byte ebx+Xpos+2], ax
        mov ax, word [regd1]
        mov word [byte ebx+Ypos+2], ax
        jmp near .x
.5:
        cmp word [byte ebx+Xpos+2], byte 0
        jge short .6
        mov edi, dword [ebx]
        sar edi, 10h
        neg edi
        jmp short .7
.6:
        mov edi, dword [ebx]
        sar edi, 10h
.7:
        cmp word [byte ebx+Ypos+2], byte 0
        jge short .8
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
        neg eax
        jmp short .9
.8:
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
.9:
        mov dword [byte esp+04h], eax
        mov eax, dword [byte esp+04h]
        mov dword [byte esp+014h], eax
        cmp word [regd1], byte 0
        jge short .10
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .11
.10:
        mov eax, dword [regd1-2]
        sar eax, 10h
.11:
        cmp di, byte 1Eh
        jg near .20
        cmp word [byte esp+014h], 0F2h
        jl near .20
        cmp ax, 0F2h
        jge near .20
        cmp word [byte ebx+Ypos+2], byte 0
        jge short .12
        mov eax, 0FFFFFF04h
        jmp short .13
.12:
        mov eax, 0FCh
.13:
        mov word [regd1], ax
        cmp word [regd0], byte 0
        jge short .14
        mov eax, 0FFFFFFD8h
        jmp short .15
.14:
        mov eax, 28h
.15:
        mov word [regd0], ax
        cmp word [byte ebx+Yvel], byte 0
        setg al
        and eax, 0FFh
        cmp word [byte ebx+Ypos+2], byte 0
        setg cl
        movzx edi, cl
        xor eax, edi
        je short .16
        mov word [byte ebx+Yvel], 0
.16:
        mov si, word [regd0]
        sub si, word [byte ebx+Xpos+2]
        test si, si
        jge short .17
        movsx eax, si
        neg eax
        jmp short .18
.17:
        movsx eax, si
.18:
        mov dword [byte esp+0Ch], eax
        mov cx, word [regd1]
        sub cx, word [byte ebx+Ypos+2]
        test cx, cx
        jge short .19
        movsx eax, cx
        neg eax
        jmp near .31
.19:
        movsx eax, cx
        jmp near .31
.20:
        cmp di, byte 10h
        jl near .32
        cmp di, byte 1Eh
        jg near .32
        cmp word [byte esp+014h], 0E8h
        jl near .32
        mov edi, dword [byte ebx+Ypos]
        sar edi, 10h
        mov dword [esp], edi
        mov edi, dword [regd1-2]
        sar edi, 10h
        xor edi, dword [esp]
        test edi, edi
        jl near .32
        cmp ax, 0E8h
        jge near .32
        cmp ax, 0E0h
        jle near .32
        cmp word [regd0], byte 0
        jge short .21
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .22
.21:
        mov eax, dword [regd0-2]
        sar eax, 10h
.22:
        cmp eax, byte 14h
        jge near .32
        cmp word [byte ebx+Ypos+2], byte 0
        jge short .23
        mov eax, 0FFFFFF24h
        jmp short .24
.23:
        mov eax, 0DCh
.24:
        mov word [regd1], ax
        cmp word [byte ebx+Xpos+2], byte 0
        jge short .25
        mov eax, 0FFFFFFD8h
        jmp short .26
.25:
        mov eax, 28h
.26:
        mov word [regd0], ax
        cmp word [byte ebx+Xvel], byte 0
        setg al
        movzx edi, al
        cmp word [byte ebx+Xpos+2], byte 0
        setg al
        and eax, 0FFh
        xor eax, edi
        je short .27
        mov word [byte ebx+Xvel], 0
.27:
        mov si, word [regd0]
        sub si, word [byte ebx+Xpos+2]
        test si, si
        jge short .28
        movsx eax, si
        neg eax
        jmp short .29
.28:
        movsx eax, si
.29:
        mov dword [byte esp+0Ch], eax
        mov cx, word [regd1]
        sub cx, word [byte ebx+Ypos+2]
        test cx, cx
        jge short .30
        movsx eax, cx
        neg eax
        jmp short .31
.30:
        movsx eax, cx
.31:
        mov dword [byte esp+010h], eax
.32:
        mov eax, ebx
        call skateto
        cmp word [byte esp+0Ch], byte 19h
        jge near .38
        cmp word [byte esp+010h], byte 19h
        jge near .38
        cmp word [byte ebx+Xvel], byte 0
        jge short .33
        mov eax, dword [byte ebx+Xvel-2]
        sar eax, 10h
        neg eax
        jmp short .34
.33:
        mov eax, dword [byte ebx+Xvel-2]
        sar eax, 10h
.34:
        cmp eax, 9C4h
        jle short .35
        mov edi, dword [byte ebx+Xvel-2]
        sar edi, 10h
        mov eax, edi
        mov edx, edi
        sar edx, 1Fh
        shl edx, 2
        LD sbb, eax, edx
        sar eax, 2
        sub edi, eax
        mov word [byte ebx+Xvel], di
.35:
        cmp word [byte ebx+Yvel], byte 0
        jge short .36
        mov eax, dword [byte ebx+Yvel-2]
        sar eax, 10h
        neg eax
        jmp short .37
.36:
        mov eax, dword [byte ebx+Yvel-2]
        sar eax, 10h
.37:
        cmp eax, 9C4h
        jle short .38
        mov edi, dword [byte ebx+Yvel-2]
        sar edi, 10h
        mov eax, edi
        mov edx, edi
        sar edx, 1Fh
        shl edx, 2
        LD sbb, eax, edx
        sar eax, 2
        sub edi, eax
        mov word [byte ebx+Yvel], di
.38:
        cmp word [byte ebx+SCnum], byte 10h
        jne short .39
        mov edi, 0A5Bh
        mov word [byte esp+08h], 0A73h
        jmp short .41
.39:
        cmp word [byte ebx+position], byte 0
        jne short .40
        mov edi, 99h
        mov word [byte esp+08h], 1F1h
        jmp short .41
.40:
        mov edi, 289h
        mov word [byte esp+08h], 2E9h
.41:
        cmp word [byte esp+0Ch], byte 8
        jl short .49
        cmp word [byte ebx+Xvel], byte 0
        jge short .42
        mov eax, dword [byte ebx+Xvel-2]
        sar eax, 10h
        neg eax
        jmp short .43
.42:
        mov eax, dword [byte ebx+Xvel-2]
        sar eax, 10h
.43:
        cmp eax, 640h
        jge short .49
        cmp word [byte ebx+Xvel], byte 0
        jne short .44
        cmp di, word [byte ebx+SPA]
        jne short .44
        mov edx, dword [byte esp+06h]
        sar edx, 10h
        jmp short .45
.44:
        cmp word [byte ebx+SPA], byte 0
        jne short .46
        movsx edx, di
.45:
        mov eax, ebx
        call SetSPA
.46:
        test si, si
        jle short .47
        mov eax, 640h
        jmp short .48
.47:
        mov eax, 0FFFFF9C0h
.48:
        mov word [byte ebx+Xvel], ax
.49:
        cmp word [byte esp+010h], byte 8
        jl short .57
        cmp word [byte ebx+Yvel], byte 0
        jge short .50
        mov eax, dword [byte ebx+Yvel-2]
        sar eax, 10h
        neg eax
        jmp short .51
.50:
        mov eax, dword [byte ebx+Yvel-2]
        sar eax, 10h
.51:
        cmp eax, 640h
        jge short .57
        cmp word [byte ebx+Xvel], byte 0
        jne short .52
        cmp di, word [byte ebx+SPA]
        jne short .52
        mov edx, dword [byte esp+06h]
        sar edx, 10h
        jmp short .53
.52:
        cmp word [byte ebx+SPA], byte 0
        jne short .54
        movsx edx, di
.53:
        mov eax, ebx
        call SetSPA
.54:
        test cx, cx
        jle short .55
        mov eax, 640h
        jmp short .56
.55:
        mov eax, 0FFFFF9C0h
.56:
        mov word [byte ebx+Yvel], ax
.57:
        mov ax, word [regd1]
        sub ax, word [byte ebx+Ypos+2]
        movsx edx, ax
        mov ax, word [regd0]
        sub ax, word [byte ebx+Xpos+2]
        cwde
        call vtoa
        sub ax, word [byte ebx+facedir]
        xor ah, ah
        and al, 7
        movsx edx, ax
        inc edx
        and edx, byte 7
        cmp edx, byte 2
        jle short .x
        cmp byte [byte ebx+029h], 0
        jne short .x
        cmp ax, 5
        jge short .58
        mov eax, 1
        jmp short .59
.58:
        mov eax, 0FFFFFFFFh
.59:
        mov edx, dword [byte ebx+facedir-2]
        sar edx, 10h
        add eax, edx
        and eax, byte 7
        mov word [byte ebx+facedir], ax
.x:
        add esp, byte 18h
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; CrowdOnStoppage                                 4E71A  95 PC, low confidence
; On a whistle (ovltimer -1, not replay) picks crowd/music reactions by
; RefPen and clock: PlayCrowdSample 2 late in the period, 5 at period end,
; team music when musicon and gameopts+1 bit 0
;-----------------------------------------------------------------------------
; C: src/engine/referee/CrowdOnStoppage.c
%ifdef CBUILD
%include "c/engine/referee/CrowdOnStoppage.inc"
%else
CrowdOnStoppage:
        push dword 0Ch
        call __CHK
        push ecx
        push edx
        test byte [gmode], 10h
        jne near .12
        mov eax, dword [ovltimer-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        jne near .12
        mov dx, word [RefPen]
        cmp dx, byte 1Dh
        je short .1
        cmp dx, byte 1Eh
        je short .1
        cmp dx, byte 3
        je short .1
        cmp dx, byte 4
        je short .1
        cmp dx, byte 8
        je short .1
        cmp dx, byte 6
        je short .1
        mov eax, 1
        jmp short .2
.1:
        xor eax, eax
.2:
        test eax, eax
        jne near .12
        mov edx, dword [UnusedEventWord]
        sar edx, 11h
        mov eax, dword [gameclock-2]
        sar eax, 10h
        cmp edx, eax
        jle short .4
        cmp word [gameclock], byte 3Ch
        jl short .4
        mov dl, byte [sflags3]
        test dl, 80h
        je short .4
        mov ch, dl
        and ch, 7Fh
        mov byte [sflags3], ch
        mov eax, 2
.3:
        call PlayCrowdSample
        xor eax, eax
        pop edx
        pop ecx
        ret
.4:
        cmp word [gsp], byte 2
        jne short .5
        mov ax, word [gameclock]
        cmp ax, word [periodendtime]
        jg short .5
        mov word [periodendtime], 0FFFFh
        mov eax, 5
        jmp short CrowdOnStoppage.3
.5:
        test byte [gameopts+1], 1
        je short .7
        cmp byte [musicon], 0
        je short .7
        mov eax, dword [awtmap-2]
        sar eax, 10h
        mov edx, dword [hmtmap-2]
        sar edx, 10h
        sub eax, edx
        mov edx, eax
        je short .7
        mov eax, 4
        call randomd0
        test ax, ax
        jne short .7
        test edx, edx
        jle short .6
        mov eax, 4
        jmp short CrowdOnStoppage.3
.6:
        mov eax, 1
        jmp short CrowdOnStoppage.3
.7:
        mov eax, 8
        call randomd0
        movsx edx, ax
        cmp dword [demoflag], byte 0
        jne short .8
        test edx, edx
        jne short .8
        test byte [gameopts], 80h
        je near .12
        test byte [sounddev], 2Ah
        je near .12
        cmp word [crowdlevel], 2BCh
        jg near .12
        xor eax, eax
        call LoadTeamPPV
        mov eax, dword [ovlseq-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        je short .12
        call CloseTextOverlay
        mov eax, 1
        pop edx
        pop ecx
        ret
.8:
        cmp dword [demoflag], byte 0
        jne short .9
        cmp edx, byte 1
        jne short .9
        mov eax, 2
        call LoadTeamPPV
        mov eax, dword [ovlseq-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        je short .12
        mov eax, 9
        call PlayCrowdSample
        call CloseTextOverlay
        mov eax, edx
        pop edx
        pop ecx
        ret
.9:
        cmp edx, byte 5
        jge short .10
        lea eax, [byte edx+04h]
        jmp short .11
.10:
        jne short .12
        mov eax, 0Bh
.11:
        call PlayCrowdSample
.12:
        xor eax, eax
        pop edx
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assrefwhistle                                4E8EF  95 PC, medium confidence
; Asstab 24h: on a stoppage (clock 0, or period-3 tie broken) sets RefStep
; -1, ovltimer 258h, puck to assignment 1Bh and the referee to 1Eh
;-----------------------------------------------------------------------------
; C: src/engine/referee/assrefwhistle.c
%ifdef CBUILD
%include "c/engine/referee/assrefwhistle.inc"
%else
assrefwhistle:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ebx, eax
        test byte [byte eax+pflags], 20h
        jne near ass_popx
        test byte [byte ebx+pflags], 2
        je near ass_popx.2
        cmp word [injurystop], byte 0
        jne short .2
        cmp word [gameclock], byte 0
        jne short .1
        cmp word [clockticks], byte 0
        je short .2
.1:
        cmp word [gsp], byte 3
        jne short ass_popx.1
        mov ax, word [hmscore]
        cmp ax, word [awscore]
        je short ass_popx.1
.2:
        mov word [RefStep], 0FFFFh
        cmp word [ovltimer], 100h
        jne short .3
        mov word [ovltimer], 258h
.3:
        mov edx, 1Bh
        mov eax, puckstruct
        call assreplace
        mov edx, 1Eh
ass_replace_popx:
        mov eax, ebx
        call assreplace
ass_popx:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        mov word [RefStep], 1
        and byte [byte ebx+pflags], 0FDh
        call PenShotAssign
        mov word [byte ebx+temp2], 8
        mov word [byte ebx+temp4], 0
        mov word [byte ebx+temp3], 0A0h
        mov word [byte ebx+temp1], 0
        or byte [byte ebx+pflags2], 20h
        mov word [byte ebx+Wallcos], 0
        mov word [byte ebx+Wallsin], 0
        mov edx, 0A5Bh
        mov eax, ebx
        call SetSPA
        call CrowdOnStoppage
        test eax, eax
        jne short ass_popx
        cmp word [ovltimer], 100h
        jne short .2
        mov word [ovltimer], 258h
.2:
        mov ax, word [byte ebx+Ypos+2]
        mov dx, word [byte ebx+temp4]
        sub eax, edx
        mov word [regd0], ax
        test ax, ax
        jge short .3
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .4
.3:
        mov eax, dword [regd0-2]
        sar eax, 10h
.4:
        cmp eax, byte 6
        jg near ass_skate_temp34
        mov ax, word [byte ebx+Xpos+2]
        mov si, word [byte ebx+temp3]
        sub eax, esi
        mov word [regd0], ax
        mov eax, dword [regd0-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFF6h
        jl near ass_skate_temp34
        mov di, word [byte ebx+temp1]
        dec edi
        mov word [byte ebx+temp1], di
        test di, di
        jge near ass_popx
        mov edx, edi
        add edx, byte 8
        mov word [byte ebx+temp1], dx
        mov edx, 0A5Bh
        mov eax, ebx
        call SetSPA
        mov dword [regd2], 2
        mov ax, word [regd2]
        mov cx, word [byte ebx+facedir]
        cmp ax, cx
        je short .7
        sub eax, ecx
        xor ah, ah
        and al, 7
        mov word [regd2], ax
        cmp ax, 5
        jge short .5
        mov eax, 1
        jmp short .6
.5:
        mov eax, 0FFFFFFFFh
.6:
        mov edx, dword [byte ebx+facedir-2]
        sar edx, 10h
        add eax, edx
        and eax, byte 7
        mov word [byte ebx+facedir], ax
.7:
        mov word [byte ebx+Yvel], 0
        mov word [byte ebx+Xvel], 0
        mov ax, word [regd2]
        cmp ax, word [byte ebx+facedir]
        jne near ass_popx
        or byte [byte ebx+pflags], 20h
        mov edx, 0C1Bh
        mov eax, ebx
        call SetSPA
        mov edx, 22h
        jmp near ass_replace_popx
%endif ; C
;-----------------------------------------------------------------------------
; ass_skate_temp34                                                4EAE2  95 PC
; Shared referee tail: skate to the spot in temp3 / temp4 (SkateToSpot), then
; the assignment exit ass_popx.
;-----------------------------------------------------------------------------
ass_skate_temp34:
        mov ax, word [byte ebx+temp3]
        mov word [regd0], ax
        mov ax, word [byte ebx+temp4]
        mov word [regd1], ax
        xor edx, edx
        mov eax, ebx
        call SkateToSpot
        jmp near ass_popx
;-----------------------------------------------------------------------------
; assrefsignal                                 4EB04  95 PC, medium confidence
; Asstab 20h: skates to x 0A0h,y 0 (the timekeeper side), plays 0A5Bh; when
; RefPen is 7 (goal) posts PostGoalEvent with scorer/assists and period time;
; then assreplace 21h
;-----------------------------------------------------------------------------
; C: src/engine/goalie/assgoalie.c (assrefsignal)
%ifdef CBUILD
%include "c/engine/goalie/assgoalie.assrefsignal.inc"
%else
assrefsignal:
        push dword 2Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, byte 4
        mov esi, eax
        test byte [byte eax+pflags], 20h
        jne near .17
        mov dl, byte [byte esi+pflags]
        test dl, 2
        je near .10
        mov dh, dl
        and dh, 0FDh
        mov byte [byte esi+pflags], dh
        mov eax, dword [RefPen-2]
        sar eax, 10h
        cmp word [nosplit eax*2+refsigdir], byte 0
        jge near .9
        cmp word [RefPen], byte 7
        jne near .8
        mov ebx, dword [pucky]
        cmp word [ebx], byte 0
        setl al
        movzx edi, al
        test byte [gmode], 2
        setne al
        and eax, 0FFh
        xor edi, eax
        test edi, edi
        jle short .1
        mov ecx, awtmstruct
        jmp short .2
.1:
        mov ecx, hmtmstruct
.2:
        mov ebx, dword [PerTimeTotal-2]
        sar ebx, 10h
        mov eax, dword [gameclock-2]
        sar eax, 10h
        sub ebx, eax
        cmp word [gameclock], byte 3Ch
        jge short .3
        cmp word [clockticks], byte 0
        je short .3
        dec ebx
.3:
        mov dword [byte ebp-04h], 3Ch
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv dword [byte ebp-04h]
        push edx
        mov dword [byte ebp-04h], 3Ch
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv dword [byte ebp-04h]
        push eax
        mov eax, dword [GoalState-2]
        sar eax, 10h
        push eax
        cmp word [byte ecx+034h], byte 0
        jge short .4
        mov eax, 0FFFFFFFFh
        jmp short .5
.4:
        mov eax, dword [byte ecx+032h]
        sar eax, 10h
.5:
        cmp word [byte ecx+032h], byte 0
        jge short .6
        mov ebx, 0FFFFFFFFh
        jmp short .7
.6:
        mov ebx, dword [byte ecx+030h]
        sar ebx, 10h
.7:
        mov edx, dword [byte ecx+02Eh]
        sar edx, 10h
        mov ecx, eax
        mov eax, edi
        call PostGoalEvent
.8:
        mov edx, 21h
        mov eax, esi
        call assreplace
        jmp near .17
.9:
        mov word [byte esi+temp2], 8
        mov word [byte esi+temp4], 0
        mov word [byte esi+temp3], 0A0h
        mov word [byte esi+temp1], 0
        or byte [byte esi+pflags2], 20h
        mov word [byte esi+Wallcos], 0
        mov word [byte esi+Wallsin], 0
.10:
        mov ax, word [byte esi+Ypos+2]
        mov bx, word [byte esi+temp4]
        sub eax, ebx
        mov word [regd0], ax
        test ax, ax
        jge short .11
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .12
.11:
        mov eax, dword [regd0-2]
        sar eax, 10h
.12:
        cmp eax, byte 0Ch
        jg near .16
        mov ax, word [byte esi+Xpos+2]
        mov di, word [byte esi+temp3]
        sub eax, edi
        mov word [regd0], ax
        mov eax, dword [regd0-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFECh
        jl near .16
        mov ax, word [byte esi+temp1]
        dec eax
        mov word [byte esi+temp1], ax
        test ax, ax
        jge near .17
        mov ebx, eax
        add ebx, byte 8
        mov word [byte esi+temp1], bx
        mov edx, 0A5Bh
        mov eax, esi
        call SetSPA
        mov eax, dword [RefPen-2]
        sar eax, 10h
        mov ax, word [nosplit eax*2+refsigdir]
        mov word [regd2], ax
        mov cx, word [byte esi+facedir]
        cmp ax, cx
        je short .15
        mov ebx, eax
        sub ebx, ecx
        xor bh, bh
        and bl, 7
        mov word [regd2], bx
        cmp bx, byte 5
        jge short .13
        mov ebx, 1
        jmp short .14
.13:
        mov ebx, 0FFFFFFFFh
.14:
        mov eax, dword [byte esi+facedir-2]
        sar eax, 10h
        add eax, ebx
        and eax, byte 7
        mov word [byte esi+facedir], ax
.15:
        mov word [byte esi+Yvel], 0
        mov word [byte esi+Xvel], 0
        mov ax, word [regd2]
        cmp ax, word [byte esi+facedir]
        jne short .17
        or byte [byte esi+pflags], 20h
        mov eax, dword [RefPen-2]
        sar eax, 10h
        mov edx, dword [nosplit eax*2+refsigspa_m2]
        sar edx, 10h
        mov eax, esi
        call SetSPA
        jmp near assrefsignal.8
.16:
        mov ax, word [byte esi+temp3]
        mov word [regd0], ax
        mov ax, word [byte esi+temp4]
        mov word [regd1], ax
        xor edx, edx
        mov eax, esi
        call SkateToSpot
.17:
        mov esp, ebp
        jmp near assgoalie_popebp
%endif ; C
;-----------------------------------------------------------------------------
; assrefgoalpa                                 4ED7C  95 PC, medium confidence
; Asstab 21h (assrefsignal, EndPenaltyShot, assrefpenshot): once ovltimer >=
; 0ECh and goalevent == 1, calls PaGoal with the scorer/assist jerseys
; (goalevent_b1..E9AD7) and team abbrev, then clears E9AD3
;-----------------------------------------------------------------------------
assrefgoalpa:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 8
        mov ebx, eax
        test byte [byte eax+pflags], 20h
        jne near .64
        mov dx, word [ovlseq]
        cmp dx, byte 2
        je near .5
        test dx, dx
        je near .5
        mov si, word [ovltimer]
        test si, si
        jl near .5
        cmp si, 100h
        jge near .5
        mov edx, 0A5Bh
        mov eax, ebx
        call SetSPA
        cmp word [ovltimer], 0ECh
        jl near .64
        cmp byte [goalevent], 1
        jne near .64
        xor ebx, ebx
        mov bl, byte [goalevent_b1]
        xor eax, eax
        mov al, byte [goalevent_b2]
        mov word [esp], ax
        xor edx, edx
        mov dl, byte [goalevent_b3]
        movzx di, byte [goalevent_b4]
        xor eax, eax
        cmp dx, 0FFh
        je short .1
        mov eax, 1
.1:
        cmp di, 0FFh
        je short .2
        inc eax
.2:
        test bx, bx
        je short .3
        mov cx, word [VisTeam]
        jmp short .4
.3:
        mov cx, word [HomeTeam]
.4:
        mov word [byte esp+04h], cx
        mov cx, word [joysampling]
        mov word [joysampling_save], cx
        xor ecx, ecx
        mov dword [joysampling], ecx
        movsx ecx, bx
        mov esi, ecx
        shl esi, 4
        add esi, ecx
        shl esi, 4
        add esi, ecx
        shl esi, 2
        movsx ecx, di
        mov ebx, ecx
        shl ebx, 2
        add ebx, ecx
        shl ebx, 3
        sub ebx, ecx
        mov bl, byte [dword esi+ebx+hmrosterjersey]
        and ebx, 0FFh
        push ebx
        movsx ecx, dx
        mov ebx, ecx
        shl ebx, 2
        add ebx, ecx
        shl ebx, 3
        sub ebx, ecx
        movzx edi, byte [dword esi+ebx+hmrosterjersey]
        mov ecx, dword [byte esp+02h]
        sar ecx, 10h
        mov ebx, ecx
        shl ebx, 2
        add ebx, ecx
        shl ebx, 3
        sub ebx, ecx
        add esi, ebx
        xor ebx, ebx
        mov bl, byte [dword esi+hmrosterjersey]
        movsx edx, ax
        mov eax, dword [byte esp+06h]
        sar eax, 10h
        mov eax, dword [nosplit eax*4+teamabbrevs]
        mov ecx, edi
        call PaGoal
        mov eax, dword [joysampling_save-2]
        sar eax, 10h
        mov dword [joysampling], eax
        mov byte [goalevent], 0FFh
        cmp word [gsp], byte 3
        jl near .64
        mov word [ovltimer], 38h
        jmp near .64
.5:
        cmp byte [PenBuf], 0
        je short .6
        mov edx, 0A5Bh
        mov eax, ebx
        call SetSPA
        mov word [RefStep], 0FFFFh
        jmp near .64
.6:
        mov ecx, dword [puckx]
        mov ax, word [ecx]
        test ax, ax
        jge short .7
        cwde
        neg eax
        jmp short .8
.7:
        cwde
.8:
        cmp eax, 0A0h
        jg short .11
        mov ecx, dword [pucky]
        mov dx, word [ecx]
        test dx, dx
        jge short .9
        movsx eax, dx
        neg eax
        jmp short .10
.9:
        movsx eax, dx
.10:
        cmp eax, 112h
        jle short .12
.11:
        mov edx, 24h
        jmp near .24
.12:
        test byte [byte ebx+pflags], 2
        je near .21
        cmp word [injurystop], byte 0
        jne short .14
        cmp word [gameclock], byte 0
        jne short .13
        cmp word [clockticks], byte 0
        je short .14
.13:
        cmp word [gsp], byte 3
        jne short .16
        mov ax, word [hmscore]
        cmp ax, word [awscore]
        je short .16
.14:
        mov word [RefStep], 0FFFFh
        cmp word [ovltimer], 100h
        jne short .15
        mov word [ovltimer], 258h
.15:
        mov edx, 1Bh
        mov eax, puckstruct
        call assreplace
        mov edx, 1Eh
        jmp near .24
.16:
        mov word [RefStep], 1
        and byte [byte ebx+pflags], 0FDh
        call PenShotAssign
        mov word [byte ebx+temp2], 8
        mov word [byte ebx+temp1], 0
        mov word [byte ebx+temp5], 0
        or byte [byte ebx+pflags2], 20h
        mov word [byte ebx+Wallcos], 0
        mov word [byte ebx+Wallsin], 0
        mov edx, 0A5Bh
        mov eax, ebx
        call SetSPA
        mov si, word [RefPen]
        cmp si, byte 4
        jne short .17
        call QueueGoalieNote
        test ax, ax
        jne near .20
        mov eax, dword [penaltysc-2]
        sar eax, 10h
        shl eax, 7
        cmp byte [dword eax+SortCordsOvlFlag], 0
        je short .19
        cmp word [SpeechPatchNext], byte 0
        jne short .19
        xor dh, dh
        mov byte [dword eax+SortCordsOvlFlag], dh
        mov eax, 8
        call LoadTeamPPV
        mov eax, dword [ovlseq-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        je short .20
        mov word [SpeechPatchNext], 1
        call CloseTextOverlay
        jmp near .64
.17:
        cmp si, byte 7
        jne short .19
        test byte [gmode], 10h
        je short .18
        mov word [exitgame], 1
        jmp near .64
.18:
        call ChkScorerMilestone
        jmp short .20
.19:
        call CrowdOnStoppage
        test eax, eax
        jne near .64
.20:
        cmp word [ovltimer], 100h
        jne short .21
        mov word [ovltimer], 258h
.21:
        cmp dword [deferpending], byte 0
        jne near .64
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jl short .22
        mov byte [eax], 0FFh
        mov edx, 1Ah
        mov eax, puckstruct
        call assreplace
.22:
        cmp word [byte ebx+temp5], 258h
        jle short .25
        mov eax, dword [puckc]
        mov byte [eax], 10h
        mov eax, dword [puckvx]
        mov word [eax], 0
        mov eax, dword [puckvy]
        mov word [eax], 0
        mov eax, dword [puckvz]
        mov word [eax], 0
        mov eax, dword [puckz]
        mov word [eax], 64h
.23:
        mov edx, 22h
.24:
        mov eax, ebx
        call assreplace
        jmp near .64
.25:
        mov ecx, dword [puckx]
        mov ax, word [ecx]
        test ax, ax
        jge short .26
        cwde
        neg eax
        jmp short .27
.26:
        cwde
.27:
        cmp eax, byte 6
        jne near .34
        mov ecx, dword [pucky]
        mov dx, word [ecx]
        test dx, dx
        jge short .28
        movsx eax, dx
        neg eax
        jmp short .29
.28:
        movsx eax, dx
.29:
        cmp eax, 0F0h
        jne short .34
        mov eax, dword [puckx]
        mov ax, word [eax]
        mov word [byte ebx+temp3], ax
        mov eax, dword [pucky]
        cmp word [eax], byte 0
        jge short .30
        mov eax, 0FFFFFF1Dh
        jmp short .31
.30:
        mov eax, 0E3h
.31:
        mov word [byte ebx+temp4], ax
        mov ax, word [byte ebx+Xpos+2]
        mov di, word [byte ebx+temp3]
        sub eax, edi
        mov word [regd0], ax
        mov eax, dword [pucky]
        cmp word [eax], byte 0
        jge short .32
        mov eax, 0FFFFFF12h
        jmp short .33
.32:
        mov eax, 0EEh
.33:
        mov edx, dword [byte ebx+Ypos]
        sar edx, 10h
        sub edx, eax
        jmp near .45
.34:
        mov edx, dword [puckvx]
        movsx edx, word [edx]
        sar edx, 7
        mov eax, dword [puckx]
        movsx eax, word [eax]
        add eax, edx
        mov word [byte ebx+temp3], ax
        mov edx, dword [puckvy]
        movsx edx, word [edx]
        sar edx, 7
        mov eax, dword [pucky]
        movsx eax, word [eax]
        add eax, edx
        mov word [byte ebx+temp4], ax
        mov edx, dword [puckvy]
        movsx edx, word [edx]
        mov eax, dword [puckvx]
        movsx eax, word [eax]
        call vtoa
        mov word [regd0], ax
        mov edx, dword [pucky]
        mov ax, word [byte ebx+Ypos+2]
        sub ax, word [edx]
        movsx edx, ax
        mov ecx, dword [puckx]
        mov ax, word [byte ebx+Xpos+2]
        sub ax, word [ecx]
        cwde
        call vtoa
        mov word [regd1], ax
        mov di, word [regd0]
        cmp di, byte 7
        jg short .35
        cmp ax, 7
        jg short .35
        cmp ax, di
        jne short .36
.35:
        mov eax, dword [puckx]
        mov ax, word [eax]
        mov word [byte ebx+temp3], ax
        mov eax, dword [pucky]
        mov ax, word [eax]
        mov word [byte ebx+temp4], ax
.36:
        mov edi, dword [byte ebx+temp4-2]
        sar edi, 10h
        mov eax, dword [pucky]
        movsx eax, word [eax]
        lea ecx, [dword eax-0E8h]
        lea edx, [dword edi-0E8h]
        xor edx, ecx
        test edx, edx
        jge near .40
        mov ecx, 0E8h
        sub ecx, eax
        mov ebp, dword [byte ebx+temp3-2]
        sar ebp, 10h
        mov edx, dword [puckx]
        movsx esi, word [edx]
        sub ebp, esi
        imul ecx, ebp
        mov esi, edi
        sub esi, eax
        je short .37
        mov eax, ecx
        mov edx, ecx
        sar edx, 1Fh
        idiv esi
        mov ecx, eax
.37:
        mov eax, dword [puckx]
        mov ax, word [eax]
        add eax, ecx
        mov word [regd0], ax
        test ax, ax
        jge short .38
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .39
.38:
        mov eax, dword [regd0-2]
        sar eax, 10h
.39:
        cmp eax, byte 19h
        jge short .40
        mov eax, dword [puckx]
        mov ax, word [eax]
        mov word [byte ebx+temp3], ax
        mov eax, dword [pucky]
        mov ax, word [eax]
        mov word [byte ebx+temp4], ax
.40:
        mov edx, dword [byte ebx+temp4-2]
        sar edx, 10h
        mov eax, dword [pucky]
        movsx eax, word [eax]
        lea ecx, [dword eax+0E8h]
        lea esi, [dword edx+0E8h]
        xor ecx, esi
        test ecx, ecx
        jge near .44
        mov ecx, 0FFFFFF18h
        sub ecx, eax
        mov edi, dword [byte ebx+temp3-2]
        sar edi, 10h
        mov esi, dword [puckx]
        movsx esi, word [esi]
        sub edi, esi
        imul ecx, edi
        mov esi, edx
        sub esi, eax
        je short .41
        mov eax, ecx
        mov edx, ecx
        sar edx, 1Fh
        idiv esi
        mov ecx, eax
.41:
        mov eax, dword [puckx]
        mov ax, word [eax]
        add ecx, eax
        mov word [regd0], cx
        test cx, cx
        jge short .42
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .43
.42:
        mov eax, dword [regd0-2]
        sar eax, 10h
.43:
        cmp eax, byte 19h
        jge short .44
        mov eax, dword [puckx]
        mov ax, word [eax]
        mov word [byte ebx+temp3], ax
        mov eax, dword [pucky]
        mov ax, word [eax]
        mov word [byte ebx+temp4], ax
.44:
        mov eax, dword [puckx]
        mov dx, word [byte ebx+Xpos+2]
        mov di, word [eax]
        mov eax, edx
        sub eax, edi
        mov word [regd0], ax
        mov eax, dword [pucky]
        mov dx, word [byte ebx+Ypos+2]
        mov cx, word [eax]
        sub edx, ecx
.45:
        mov word [regd1], dx
        cmp word [regd0], byte 0
        jge short .46
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .47
.46:
        mov eax, dword [regd0-2]
        sar eax, 10h
.47:
        cmp eax, byte 0Ch
        jg near .63
        cmp word [regd1], byte 0
        jge short .48
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .49
.48:
        mov eax, dword [regd1-2]
        sar eax, 10h
.49:
        cmp eax, byte 0Ch
        jg near .63
        mov ecx, dword [puckx]
        mov di, word [ecx]
        test di, di
        jge short .50
        movsx eax, di
        neg eax
        jmp short .51
.50:
        movsx eax, di
.51:
        cmp eax, byte 6
        jne short .56
        mov ecx, dword [pucky]
        mov ax, word [ecx]
        test ax, ax
        jge short .52
        cwde
        neg eax
        jmp short .53
.52:
        cwde
.53:
        cmp eax, 0F0h
        jne short .56
        cmp word [byte ebx+Ypos+2], byte 0
        jge short .54
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
        neg eax
        jmp short .55
.54:
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
.55:
        cmp eax, 0E8h
        jg short .57
.56:
        mov eax, 1
        jmp short .58
.57:
        xor eax, eax
.58:
        test eax, eax
        je near .63
        mov cx, word [byte ebx+temp1]
        dec ecx
        mov word [byte ebx+temp1], cx
        test cx, cx
        jge near .64
        mov edi, ecx
        add edi, byte 8
        mov word [byte ebx+temp1], di
        mov edx, 0A5Bh
        mov eax, ebx
        call SetSPA
        mov eax, dword [pucky]
        mov ax, word [eax]
        sub ax, word [byte ebx+Ypos+2]
        movsx edx, ax
        mov eax, dword [puckx]
        mov ax, word [eax]
        sub ax, word [byte ebx+Xpos+2]
        cwde
        call vtoa
        mov word [regd2], ax
        cmp ax, 8
        jge short .60
        mov edx, dword [byte ebx+facedir-2]
        sar edx, 10h
        movsx ecx, ax
        sub ecx, edx
        inc ecx
        and ecx, byte 7
        cmp ecx, byte 2
        jle short .60
        sub ax, word [byte ebx+facedir]
        xor ah, ah
        and al, 7
        mov word [regd2], ax
        cmp ax, 5
        jge short .59
        mov eax, 1
        jmp short .62
.59:
        mov eax, 0FFFFFFFFh
        jmp short .62
.60:
        mov word [byte ebx+Yvel], 0
        mov ax, word [byte ebx+Yvel]
        mov word [byte ebx+Xvel], ax
        mov eax, dword [puckc]
        mov byte [eax], 10h
        mov eax, dword [puckvx]
        mov word [eax], 0
        mov eax, dword [puckvy]
        mov word [eax], 0
        mov eax, dword [puckvz]
        mov word [eax], 0
        mov eax, dword [puckz]
        mov word [eax], 0FF9Ch
        mov si, word [regd2]
        cmp si, byte 8
        jge short .61
        mov word [byte ebx+facedir], si
.61:
        or byte [byte ebx+pflags], 20h
        mov edx, 0C03h
        mov eax, ebx
        call SetSPA
        jmp near assrefgoalpa.23
.62:
        mov edx, dword [byte ebx+facedir-2]
        sar edx, 10h
        add eax, edx
        and eax, byte 7
        mov word [byte ebx+facedir], ax
.63:
        inc word [byte ebx+temp5]
        mov ax, word [byte ebx+temp3]
        mov word [regd0], ax
        mov ax, word [byte ebx+temp4]
        mov word [regd1], ax
        xor edx, edx
        mov eax, ebx
        call SkateToSpot
.64:
        add esp, byte 8
        jmp near assgoalie_popebp
;-----------------------------------------------------------------------------
; assrefdrop                                   4F5BF  95 PC, medium confidence
; Asstab 22h: in penshotmode switches to 2Ch; else skates to the faceoff spot
; (+-0Fh), puts the puck in hand (puckc 10h, z -64h, v 0)
;-----------------------------------------------------------------------------
; C: src/engine/referee/assrefwhistle.c (assrefdrop)
%ifdef CBUILD
%include "c/engine/referee/assrefwhistle.assrefdrop.inc"
%else
assrefdrop:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ebx, eax
        cmp dword [penshotmode], byte 0
        je short .2
        mov edx, 2Ch
.1:
        call assreplace
        jmp near ass_popx
.2:
        test byte [byte eax+pflags], 20h
        jne near ass_popx
        mov dl, byte [byte ebx+pflags]
        test dl, 2
        je near .5
        mov dh, dl
        and dh, 0FDh
        mov byte [byte ebx+pflags], dh
        mov word [byte ebx+temp2], 8
        mov word [byte ebx+temp1], 0
        cmp word [fox], byte 0
        jg short .3
        mov eax, dword [fox-2]
        sar eax, 10h
        sub eax, byte 0Fh
        jmp short .4
.3:
        mov eax, dword [fox-2]
        sar eax, 10h
        add eax, byte 0Fh
.4:
        mov word [byte ebx+temp3], ax
        mov ax, word [foy]
        mov word [byte ebx+temp4], ax
        or byte [byte ebx+pflags2], 20h
        mov word [byte ebx+Wallcos], 0
        mov word [byte ebx+Wallsin], 0
        mov eax, dword [puckc]
        mov byte [eax], 10h
        mov eax, dword [puckvx]
        mov word [eax], 0
        mov eax, dword [puckvy]
        mov word [eax], 0
        mov eax, dword [puckvz]
        mov word [eax], 0
        mov eax, dword [puckz]
        mov word [eax], 0FF9Ch
        mov edx, 0A5Bh
        mov eax, ebx
        call SetSPA
.5:
        mov edx, dword [ebx]
        sar edx, 10h
        mov eax, dword [byte ebx+temp3-2]
        sar eax, 10h
        sub edx, eax
        mov eax, edx
        mov edx, dword [byte ebx+Ypos]
        sar edx, 10h
        mov ecx, dword [byte ebx+temp4-2]
        sar ecx, 10h
        sub edx, ecx
        imul eax, eax
        imul edx, edx
        add eax, edx
        cmp eax, byte 40h
        jge near ass_skate_temp34
        cmp word [byte ebx+Xvel], byte 0
        jge short .6
        mov eax, dword [byte ebx+Xvel-2]
        sar eax, 10h
        neg eax
        jmp short .7
.6:
        mov eax, dword [byte ebx+Xvel-2]
        sar eax, 10h
.7:
        cmp eax, byte 10h
        jge near ass_skate_temp34
        cmp word [byte ebx+Yvel], byte 0
        jge short .8
        mov eax, dword [byte ebx+Yvel-2]
        sar eax, 10h
        neg eax
        jmp short .9
.8:
        mov eax, dword [byte ebx+Yvel-2]
        sar eax, 10h
.9:
        cmp eax, byte 10h
        jge near ass_skate_temp34
        mov ax, word [byte ebx+temp3]
        mov word [byte ebx+Xpos+2], ax
        mov ax, word [byte ebx+temp4]
        mov word [byte ebx+Ypos+2], ax
        mov di, word [byte ebx+temp1]
        dec edi
        mov word [byte ebx+temp1], di
        test di, di
        jge near ass_popx
        mov edx, edi
        add edx, byte 8
        mov word [byte ebx+temp1], dx
        mov edx, 0A5Bh
        mov eax, ebx
        call SetSPA
        cmp word [fox], byte 0
        jg short .10
        mov eax, 2
        jmp short .11
.10:
        mov eax, 6
.11:
        mov dword [regd2], eax
        mov ax, word [regd2]
        mov si, word [byte ebx+facedir]
        cmp ax, si
        je short .14
        sub eax, esi
        xor ah, ah
        and al, 7
        mov word [regd2], ax
        cmp ax, 5
        jge short .12
        mov eax, 1
        jmp short .13
.12:
        mov eax, 0FFFFFFFFh
.13:
        mov edx, dword [byte ebx+facedir-2]
        sar edx, 10h
        add eax, edx
        and eax, byte 7
        mov word [byte ebx+facedir], ax
        jmp near ass_popx
.14:
        mov word [byte ebx+Yvel], 0
        mov ax, word [byte ebx+Yvel]
        mov word [byte ebx+Xvel], ax
        call PaSpeechBusy
        test eax, eax
        jne near ass_popx
        mov eax, dword [ovlseq-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        jne near ass_popx
        mov word [RefStep], 0FFFFh
        mov edx, 1Eh
        mov eax, ebx
        jmp near assrefdrop.1
%endif ; C
;-----------------------------------------------------------------------------
; assrefgoalline                                  4F7D0  95 PC, low confidence
; Asstab 23h: skates the referee to x +-32h, y +-0E6h (beside the net on the
; puck's end) and holds there
;-----------------------------------------------------------------------------
; C: src/engine/referee/assrefwhistle.c (assrefgoalline)
%ifdef CBUILD
%include "c/engine/referee/assrefwhistle.assrefgoalline.inc"
%else
assrefgoalline:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ebx, eax
        test byte [byte eax+pflags], 20h
        jne near ass_popx
        mov dl, byte [byte ebx+pflags]
        test dl, 2
        je short .5
        mov dh, dl
        and dh, 0FDh
        mov byte [byte ebx+pflags], dh
        mov word [byte ebx+temp2], 8
        mov word [byte ebx+temp1], 0
        mov eax, dword [pucky]
        cmp word [eax], byte 0
        jle short .1
        mov eax, 0E6h
        jmp short .2
.1:
        mov eax, 0FFFFFF1Ah
.2:
        mov word [byte ebx+temp4], ax
        cmp word [byte ebx+Xpos+2], byte 0
        jle short .3
        mov eax, 32h
        jmp short .4
.3:
        mov eax, 0FFFFFFCEh
.4:
        mov word [byte ebx+temp3], ax
        or byte [byte ebx+pflags2], 20h
        mov word [byte ebx+Wallcos], 0
        mov word [byte ebx+Wallsin], 0
.5:
        mov ax, word [byte ebx+Ypos+2]
        mov si, word [byte ebx+temp4]
        sub eax, esi
        mov word [regd0], ax
        test ax, ax
        jge short .6
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .7
.6:
        mov eax, dword [regd0-2]
        sar eax, 10h
.7:
        cmp eax, byte 0Ch
        jg near ass_skate_temp34
        cmp word [byte ebx+Ypos+2], byte 0
        jge short .8
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
        neg eax
        jmp short .9
.8:
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
.9:
        cmp word [byte ebx+temp4], byte 0
        jge short .10
        mov edx, dword [byte ebx+temp4-2]
        sar edx, 10h
        neg edx
        jmp short .11
.10:
        mov edx, dword [byte ebx+temp4-2]
        sar edx, 10h
.11:
        cmp eax, edx
        jg near ass_skate_temp34
        mov ax, word [byte ebx+Xpos+2]
        mov cx, word [byte ebx+temp3]
        sub eax, ecx
        mov word [regd0], ax
        test ax, ax
        jge short .12
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .13
.12:
        mov eax, dword [regd0-2]
        sar eax, 10h
.13:
        cmp eax, byte 0Ch
        jg near ass_skate_temp34
        mov di, word [byte ebx+temp1]
        dec edi
        mov word [byte ebx+temp1], di
        test di, di
        jge near ass_popx
        mov edx, edi
        add edx, byte 8
        mov word [byte ebx+temp1], dx
        mov edx, 0A5Bh
        mov eax, ebx
        call SetSPA
        mov ax, word [byte ebx+temp4]
        sub ax, word [byte ebx+Ypos+2]
        movsx edx, ax
        mov ax, word [byte ebx+Xpos+2]
        neg eax
        cwde
        call vtoa
        cwde
        mov dword [regd2], eax
        mov ax, word [regd2]
        mov si, word [byte ebx+facedir]
        cmp ax, si
        je short .16
        sub eax, esi
        xor ah, ah
        and al, 7
        mov word [regd2], ax
        cmp ax, 5
        jge short .14
        mov eax, 1
        jmp short .15
.14:
        mov eax, 0FFFFFFFFh
.15:
        mov edx, dword [byte ebx+facedir-2]
        sar edx, 10h
        add eax, edx
        and eax, byte 7
        mov word [byte ebx+facedir], ax
        jmp near ass_popx
.16:
        mov word [byte ebx+Yvel], 0
        mov ax, word [byte ebx+Yvel]
        mov word [byte ebx+Xvel], ax
        or byte [byte ebx+pflags], 20h
        mov edx, 0C1Bh
        mov eax, ebx
        call SetSPA
        mov edx, 20h
        jmp near ass_replace_popx
%endif ; C
