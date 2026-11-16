; Passing: open-man check, pass lanes, the pass itself and the computer's pass decision (94G logic94).
bits 32
%include "hockey.inc"
section s_53F8C progbits alloc exec nowrite align=1
extern __CHK, AddPenalty2, assexit, assinsert, AvgCline, awtmap, awtmstruct, bannermsg
extern bannertimer, c1playernum, c2playernum, changeplayer, clockticks, CompLine, CompShoot, dirtab
extern Findhittype, gameclock, gameopts, GetHot, GetHotOrStick, GetHotStick, gmode, gmode2
extern hmtmap, hmtmstruct, lastplayer, lasttouch, onetimerflag, OOlist, OOlistpos, pad1dev
extern passdir, passplayer, passspeed, penshotlive, penshotstart, puckbody, puckc, puckcross
extern puckcross_m2, puckgoalie, pucknopuck, puckstick, puckvx, puckvy, puckvz, puckx
extern pucky, puckz, randomd0, regd0, regd1, regd2, regd3, regd4
extern restorepl, setpersonel, SetSPA, sflags, sfx, ShotLaneOpen, SortCords, IntSqrt
extern threat, ToFixed, vtoa, Ylist, Ylist_m2
global checkob, checkob_ret5a, checkob_ret5, SkillForAnim, ChkDelayedOffside, checkpuckcoll_ccx, checkpuckcoll, CheckBump
global GetLowestPen, chk4lc, chk4lc_shoot, PassLaneChk, PassLaneChk_ret5a, PassLaneChk_ret5, ScatterPass, dopass
global dopass_ret6, passmode, setpassmode, passtoa0, chk4pass
;-----------------------------------------------------------------------------
; checkob                            53F8C  94G logic94.asm, medium confidence
; Genesis comment (logic94.asm): bring up little warning ref if a player on
; your team is over blue line
;-----------------------------------------------------------------------------
checkob:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 4
        mov edi, eax
        xor edx, edx
        mov dword [esp], edx
        xor ebx, ebx
        test byte [gameopts], 2
        je near checkob_ret5a
        cmp dword [penshotlive], byte 0
        jne near checkob_ret5a
        cmp dword [penshotstart], byte 0
        jne near checkob_ret5a
        cmp word [byte edi+SCnum], byte 6
        jge short .1
        xor eax, eax
        jmp short .2
.1:
        mov eax, 6
.2:
        shl eax, 7
        add eax, SortCords
        test byte [byte edi+pflags], 80h
        jne short .8
        mov ecx, dword [byte edi+Ypos]
        sar ecx, 10h
        cmp ecx, byte 0FFFFFFAEh
        jle short .3
        cmp word [byte edi+Yvel], byte 0
        jg short .3
        mov ebx, 4
.3:
        lea esi, [byte ebx+04Eh]
        neg esi
        mov ecx, dword [pucky]
        movsx ecx, word [ecx]
        cmp esi, ecx
        jg near .13
        xor dl, dl
        jmp short .7
.4:
        cmp word [byte eax+01Ah], byte 0
        jl short .6
        mov ecx, dword [byte eax+04h]
        sar ecx, 10h
        lea esi, [byte ebx+04Eh]
        neg esi
        cmp esi, ecx
        jle short .6
.5:
        mov dword [esp], 1
        jmp short .13
.6:
        add eax, 80h
        inc dl
.7:
        cmp dl, 6
        jl short checkob.4
        jmp short .13
.8:
        cmp word [byte edi+Ypos+2], byte 52h
        jge short .9
        cmp word [byte edi+Yvel], byte 0
        jl short .9
        mov ebx, 4
.9:
        mov ecx, dword [pucky]
        movsx ecx, word [ecx]
        lea esi, [byte ebx+04Eh]
        cmp esi, ecx
        jl short .13
        xor dl, dl
        jmp short .12
.10:
        cmp word [byte eax+01Ah], byte 0
        jl short .11
        mov ecx, dword [byte eax+04h]
        sar ecx, 10h
        lea esi, [byte ebx+04Eh]
        cmp esi, ecx
        jl short checkob.5
.11:
        add eax, 80h
        inc dl
.12:
        cmp dl, 6
        jl short checkob.10
.13:
        cmp word [esp], byte 0
        je short .14
        mov bh, byte [gmode2]
        test bh, 80h
        jne near checkob_ret5a
        mov cl, bh
        or cl, 80h
        mov byte [gmode2], cl
        cmp word [bannermsg], byte 4
        jge near checkob_ret5a
        test byte [byte edi+pflags], 80h
        setne al
        mov ebx, eax
        and ebx, 0FFh
        mov eax, dword [pucky]
        cmp word [eax], byte 0
        setl al
        and eax, 0FFh
        xor eax, ebx
        je short checkob_ret5a
        mov word [bannermsg], 4
        xor edx, edx
        mov word [bannertimer], dx
        jmp short checkob_ret5a
.14:
        mov dh, byte [gmode2]
        test dh, 80h
        je short checkob_ret5a
        mov bl, dh
        and bl, 7Fh
        mov byte [gmode2], bl
        cmp word [bannermsg], byte 4
        jne short checkob_ret5a
        cmp word [bannertimer], byte 0
        jne short checkob_ret5a
        mov word [bannermsg], 0FFFFh
checkob_ret5a:
        add esp, byte 4
checkob_ret5:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; SkillForAnim                                    54134  95 PC, low confidence
; Returns the stick-handling attribute byte (5Dh / 62h / 65h) that fits the
; player's current animation (SPA codes 0B1h, 0C9h, 0E1h, 101h, 119h, 11D5h,
; 121Dh); checkpuckcoll
;-----------------------------------------------------------------------------
; C: src/engine/pass/checkob.c (SkillForAnim)
%ifdef CBUILD
%include "c/engine/pass/checkob.SkillForAnim.inc"
%else
SkillForAnim:
        push dword 8
        call __CHK
        push edx
        mov dx, word [byte eax+038h]
        cmp dx, 101h
        jb short .2
        jbe near .11
        cmp dx, 11D5h
        jb short .1
        jbe short .4
        cmp dx, 121Dh
        je near .11
        jmp near .12
.1:
        cmp dx, 119h
        je short .8
        jmp near .12
.2:
        cmp dx, 0C9h
        jb short .3
        jbe short .4
        cmp dx, 0E1h
        je short .4
        jmp short .12
.3:
        cmp dx, 0B1h
        je short .7
        jmp short .12
.4:
        cmp byte [byte eax+065h], 0
        jne short .6
.5:
        mov al, byte [byte eax+05Dh]
        jmp short .13
.6:
        mov al, byte [byte eax+062h]
        jmp short .13
.7:
        cmp byte [byte eax+065h], 0
        jne short SkillForAnim.5
        jmp short SkillForAnim.6
.8:
        cmp byte [byte eax+065h], 0
        jne short .10
.9:
        mov al, byte [byte eax+061h]
        jmp short .13
.10:
        mov al, byte [byte eax+05Fh]
        jmp short .13
.11:
        cmp byte [byte eax+065h], 0
        jne short SkillForAnim.9
        jmp short SkillForAnim.10
.12:
        mov al, byte [byte eax+05Bh]
.13:
        and eax, 0FFh
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ChkDelayedOffside                            541CA  95 PC, medium confidence
; Offsides option: the flagged team touches the puck in the zone -> AddPenalty2 8 on
; SortCords[lasttouch], returns 1. Called from checkpuckcoll_ccx before puckstick puckgoalie.
;-----------------------------------------------------------------------------
; C: src/engine/pass/ChkDelayedOffside.c
%ifdef CBUILD
%include "c/engine/pass/ChkDelayedOffside.inc"
%else
ChkDelayedOffside:
        push dword 8
        call __CHK
        push edx
        test byte [gameopts], 2
        jne short .2
.1:
        xor eax, eax
        pop edx
        ret
.2:
        test byte [gmode], 10h
        jne short ChkDelayedOffside.1
        cmp dword [penshotlive], byte 0
        jne short ChkDelayedOffside.1
        cmp dword [penshotstart], byte 0
        jne short ChkDelayedOffside.1
        mov edx, dword [pucky]
        movsx edx, word [edx]
        test edx, edx
        jge short .3
        neg edx
.3:
        cmp edx, 0E8h
        jg short ChkDelayedOffside.1
        test byte [byte eax+pflags], 80h
        je short .4
        mov edx, 2
        jmp short .5
.4:
        xor edx, edx
.5:
        mov edx, dword [nosplit edx*2+puckcross_m2]
        sar edx, 10h
        test edx, edx
        jge short .6
        neg edx
.6:
        cmp edx, byte 2Ch
        jg short ChkDelayedOffside.1
        mov edx, dword [byte eax+optmptr]
        test byte [byte edx+tmflags], 10h
        je short ChkDelayedOffside.1
        cmp word [byte eax+SCnum], byte 6
        setl al
        mov edx, eax
        and edx, 0FFh
        cmp word [lasttouch], byte 6
        setl al
        and eax, 0FFh
        cmp eax, edx
        jne short .7
        xor eax, edx
        pop edx
        ret
.7:
        mov eax, dword [lasttouch-2]
        sar eax, 10h
        shl eax, 7
        add eax, SortCords
        mov edx, 8
        call AddPenalty2
        mov eax, 1
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; checkpuckcoll_ccx                                   5428A  94G collide94.asm
; The per-object puck test (stick, body, goalie): the 94G local
; checkpuckcoll.ccx; 94S checkpuckcoll_ccx
;-----------------------------------------------------------------------------
checkpuckcoll_ccx:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        mov ecx, eax
        mov eax, dword [puckc]
        movsx ax, byte [eax]
        cmp dx, ax
        je near PassLaneChk_ret5
        cmp dx, byte 0Bh
        jle short .1
        cmp dx, byte 10h
        jne near PassLaneChk_ret5
.1:
        movsx eax, dx
        shl eax, 7
        mov ebx, SortCords
        add ebx, eax
        test byte [byte ebx+pflags], 4
        jne near PassLaneChk_ret5
        cmp word [byte ebx+03Eh], byte 0
        jne near PassLaneChk_ret5
        test byte [byte ebx+pflags2], 4
        jne near .22
        cmp word [byte ebx+position], byte 0
        jne near .22
        mov eax, ebx
        call SkillForAnim
        mov edi, eax
        mov eax, dword [puckvx]
        mov dx, word [eax]
        test dx, dx
        jge short .2
        movsx edx, dx
        neg edx
        jmp short .3
.2:
        movsx edx, dx
.3:
        mov eax, dword [puckvy]
        mov si, word [eax]
        test si, si
        jge short .4
        movsx eax, si
        neg eax
        jmp short .5
.4:
        movsx eax, si
.5:
        add eax, edx
        mov esi, eax
        test ax, ax
        jne short .6
        mov esi, 1
.6:
        movsx eax, di
        shl eax, 0Bh
        movsx esi, si
        lea edx, [dword eax-0FA0h]
        mov eax, edx
        sar edx, 1Fh
        idiv esi
        mov edi, eax
        test ax, ax
        jge short .7
        xor edi, eax
.7:
        cmp di, byte 4
        jle short .8
        mov edi, 4
.8:
        mov eax, ebx
        call GetHotOrStick
        cmp word [regd0], byte 0
        jge short .9
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .10
.9:
        mov eax, dword [regd0-2]
        sar eax, 10h
.10:
        mov word [regd2], ax
        mov edx, dword [regd2-2]
        sar edx, 10h
        shl edx, 2
        mov esi, 3
        mov eax, edx
        sar edx, 1Fh
        idiv esi
        mov word [regd4], ax
        cmp word [regd1], byte 0
        jge short .11
        mov esi, dword [regd1-2]
        sar esi, 10h
        neg esi
        jmp short .12
.11:
        mov esi, dword [regd1-2]
        sar esi, 10h
.12:
        movsx edx, si
        shl edx, 2
        mov ebp, 3
        mov eax, edx
        sar edx, 1Fh
        idiv ebp
        mov word [regd3], ax
        add word [regd2], di
        mov eax, ebx
        call GetHot
        mov edx, dword [puckx]
        mov ax, word [byte ebx+Xpos+2]
        sub ax, word [edx]
        mov dx, word [regd0]
        add edx, eax
        mov word [regd0], dx
        test dx, dx
        jge short .13
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .14
.13:
        mov eax, dword [regd0-2]
        sar eax, 10h
.14:
        mov word [regd0], ax
        cmp ax, word [regd2]
        jge near .21
        mov edx, dword [pucky]
        mov ax, word [byte ebx+Ypos+2]
        sub ax, word [edx]
        mov dx, word [regd1]
        add edx, eax
        mov word [regd1], dx
        test dx, dx
        jge short .15
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .16
.15:
        mov eax, dword [regd1-2]
        sar eax, 10h
.16:
        mov word [regd1], ax
        cmp ax, word [regd2]
        jge near .21
        mov dx, word [regd4]
        add edx, esi
        cmp dx, byte 5
        jle short .17
        movsx eax, dx
        jmp short .18
.17:
        mov eax, 5
.18:
        mov edx, eax
        add edx, edi
        mov eax, dword [puckz]
        cmp dx, word [eax]
        jl near .21
        mov dx, word [regd4]
        sub esi, edx
        mov edx, esi
        sub edx, edi
        test dx, dx
        jl short .19
        cmp dx, word [eax]
        jge near .21
.19:
        mov edx, dword [regd0-2]
        sar edx, 10h
        imul edx, edx
        mov eax, dword [regd1-2]
        sar eax, 10h
        imul eax, eax
        add edx, eax
        mov dword [regd0], edx
        mov eax, dword [regd2-2]
        sar eax, 10h
        imul eax, eax
        mov dword [regd1], eax
        cmp word [byte ecx+03Eh], byte 0
        jle short .20
        mov ebp, eax
        sar ebp, 2
        mov dword [regd1], ebp
.20:
        mov ax, word [regd1]
        cmp ax, word [regd0]
        jl near .21
        mov eax, ebx
        call ChkDelayedOffside
        mov edx, ebx
        mov eax, ecx
        call puckstick
.21:
        cmp word [byte ebx+position], byte 0
        jne near .33
        mov ax, word [byte ebx+Xpos+2]
        mov dx, word [byte ecx+02h]
        sub eax, edx
        mov word [regd0], ax
        test ax, ax
        jge near .29
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp near .30
.22:
        test byte [byte ebx+pflags2], 4
        jne short checkpuckcoll_ccx.21
        cmp word [byte ebx+position], byte 0
        jl short checkpuckcoll_ccx.21
        cmp dx, byte 10h
        je short checkpuckcoll_ccx.21
        cmp word [byte ecx+0Ah], byte 5
        jg short checkpuckcoll_ccx.21
        cmp word [byte ecx+010h], 200h
        jg short checkpuckcoll_ccx.21
        mov eax, ebx
        call GetHot
        mov ax, word [byte ebx+Xpos+2]
        sub ax, word [byte ecx+02h]
        mov dx, word [regd0]
        add edx, eax
        mov word [regd0], dx
        test dx, dx
        jge short .23
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .24
.23:
        mov eax, dword [regd0-2]
        sar eax, 10h
.24:
        cmp eax, byte 0Eh
        jg near checkpuckcoll_ccx.21
        mov ax, word [byte ebx+Ypos+2]
        sub ax, word [byte ecx+06h]
        mov dx, word [regd1]
        add edx, eax
        mov word [regd1], dx
        test dx, dx
        jge short .25
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .26
.25:
        mov eax, dword [regd1-2]
        sar eax, 10h
.26:
        cmp eax, byte 0Eh
        jg near checkpuckcoll_ccx.21
        mov edx, dword [regd0-2]
        sar edx, 10h
        imul edx, edx
        mov eax, dword [regd1-2]
        sar eax, 10h
        imul eax, eax
        add edx, eax
        mov dword [regd0], edx
        mov dword [regd1], 0C4h
        cmp word [byte ecx+03Eh], byte 0
        jle short .27
        sar word [regd1], 2
.27:
        mov eax, dword [regd0]
        cmp eax, dword [regd1]
        ja near checkpuckcoll_ccx.21
        mov dx, word [byte ebx+012h]
        cmp dx, 430h
        jl short .28
        cmp dx, 44Fh
        jg short .28
        cmp eax, byte 24h
        ja near checkpuckcoll_ccx.21
.28:
        mov edx, ebx
        mov eax, ecx
        call puckstick
        jmp near PassLaneChk_ret5
.29:
        mov eax, dword [regd0-2]
        sar eax, 10h
.30:
        cmp eax, byte 0Ah
        jg near PassLaneChk_ret5
        mov ax, word [byte ebx+Ypos+2]
        mov di, word [byte ecx+06h]
        sub eax, edi
        mov word [regd1], ax
        test ax, ax
        jge short .31
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .32
.31:
        mov eax, dword [regd1-2]
        sar eax, 10h
.32:
        cmp eax, byte 0Ah
        jg near PassLaneChk_ret5
        mov edx, dword [regd0-2]
        sar edx, 10h
        imul edx, edx
        mov eax, dword [regd1-2]
        sar eax, 10h
        imul eax, eax
        add eax, edx
        cmp eax, byte 64h
        ja near PassLaneChk_ret5
        mov eax, ebx
        call ChkDelayedOffside
        mov edx, ebx
        mov eax, ecx
        call puckgoalie
        jmp near PassLaneChk_ret5
.33:
        mov dx, word [byte ebx+012h]
        cmp dx, 431h
        jl near .40
        cmp dx, 44Fh
        jg near .40
        test dl, 1
        je near .40
        mov eax, dword [puckz]
        cmp word [eax], byte 8
        jge near .40
        mov eax, ebx
        call GetHotStick
        mov ax, word [regd0]
        sar ax, 1
        mov word [regd0], ax
        sar word [regd1], 1
        test ax, ax
        jge short .34
        mov edi, dword [regd0-2]
        sar edi, 10h
        neg edi
        jmp short .35
.34:
        mov edi, dword [regd0-2]
        sar edi, 10h
.35:
        mov ax, word [byte ebx+Xpos+2]
        sub ax, word [byte ecx+02h]
        mov si, word [regd0]
        add esi, eax
        mov word [regd0], si
        test si, si
        jge short .36
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .37
.36:
        mov eax, dword [regd0-2]
        sar eax, 10h
.37:
        movsx esi, di
        cmp eax, esi
        jg short .40
        mov ax, word [byte ebx+Ypos+2]
        sub ax, word [byte ecx+06h]
        mov si, word [regd1]
        add esi, eax
        mov word [regd1], si
        test si, si
        jge short .38
        mov esi, dword [regd1-2]
        sar esi, 10h
        neg esi
        jmp short .39
.38:
        mov esi, dword [regd1-2]
        sar esi, 10h
.39:
        movsx eax, di
        cmp esi, eax
        jg short .40
        mov edi, dword [regd0-2]
        sar edi, 10h
        imul edi, edi
        mov esi, dword [regd1-2]
        sar esi, 10h
        imul esi, esi
        add edi, esi
        mov dword [regd0], edi
        imul eax, eax
        cmp eax, edi
        jae near .46
.40:
        mov edi, 8
        mov esi, 40h
        cmp dx, 44Fh
        jle short .41
        mov edi, 10h
        mov esi, 100h
.41:
        mov ax, word [byte ebx+Xpos+2]
        mov dx, word [byte ecx+02h]
        sub eax, edx
        mov word [regd0], ax
        test ax, ax
        jge short .42
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .43
.42:
        mov eax, dword [regd0-2]
        sar eax, 10h
.43:
        movsx edx, di
        cmp eax, edx
        jg near PassLaneChk_ret5
        mov ax, word [byte ebx+Ypos+2]
        mov dx, word [byte ecx+06h]
        sub eax, edx
        mov word [regd1], ax
        test ax, ax
        jge short .44
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .45
.44:
        mov eax, dword [regd1-2]
        sar eax, 10h
.45:
        movsx edx, di
        cmp eax, edx
        jg near PassLaneChk_ret5
        mov edx, dword [regd0-2]
        sar edx, 10h
        imul edx, edx
        mov eax, dword [regd1-2]
        sar eax, 10h
        imul eax, eax
        add edx, eax
        mov dword [regd0], edx
        movsx eax, si
        cmp eax, edx
        jb near PassLaneChk_ret5
.46:
        mov edx, ebx
        mov eax, ecx
        call puckbody
        jmp near PassLaneChk_ret5
;-----------------------------------------------------------------------------
; checkpuckcoll                                       548AC  94G collide94.asm
; The 94G checkpuckcoll step for step: stop past y 190h, return above Z 16,
; walk the OOlist up and down within 40 and test each object (.ccx)
;-----------------------------------------------------------------------------
; C: src/engine/pass/checkpuckcoll.c
%ifdef CBUILD
%include "c/engine/pass/checkpuckcoll.inc"
%else
checkpuckcoll:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov ebx, eax
        cmp word [byte eax+06h], byte 0
        jge short .1
        mov eax, dword [byte eax+04h]
        sar eax, 10h
        neg eax
        jmp short .2
.1:
        mov eax, dword [byte eax+04h]
        sar eax, 10h
.2:
        cmp eax, 190h
        jle short .3
        mov word [byte ebx+Yvel], 0
        mov ax, word [byte ebx+Yvel]
        mov word [byte ebx+Xvel], ax
.3:
        cmp word [byte ebx+0Ah], byte 10h
        jg near .x
        mov ecx, dword [byte ebx+SCnum-2]
        sar ecx, 10h
        mov cx, word [nosplit ecx*2+OOlistpos]
        jmp short .5
.4:
        movsx eax, cx
        movsx dx, byte [dword eax+OOlist+1]
        mov eax, dword [dword eax+OOlist-2]
        sar eax, 18h
        mov esi, dword [nosplit eax*2+Ylist_m2]
        sar esi, 10h
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
        sub esi, eax
        cmp esi, byte 28h
        jg short .6
        movsx edx, dx
        mov eax, ebx
        call checkpuckcoll_ccx
        inc ecx
.5:
        cmp cx, byte 10h
        jne short checkpuckcoll.4
.6:
        mov ecx, dword [byte ebx+SCnum-2]
        sar ecx, 10h
        mov cx, word [nosplit ecx*2+OOlistpos]
        test cx, cx
        je short .x
.7:
        movsx eax, cx
        movsx dx, byte [dword eax+OOlist-1]
        mov eax, dword [dword eax+OOlist-4]
        sar eax, 18h
        mov eax, dword [nosplit eax*2+Ylist_m2]
        sar eax, 10h
        mov esi, dword [byte ebx+Ypos]
        sar esi, 10h
        sub esi, eax
        cmp esi, byte 28h
        jg short .x
        movsx edx, dx
        mov eax, ebx
        call checkpuckcoll_ccx
        dec cx
        jne short checkpuckcoll.7
.x:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CheckBump                        54990  94G collide94.asm, medium confidence
; Player p runs into the puck carrier c. One time in 20h (randomd0), with the
; puck within 28h in y of c and p faster than 1B58h in x or y: c takes a
; quarter of p's velocity, p stops, sflags bit 6 (sfslock) is set and, while
; the clock runs, p gets penalty 1Eh (AddPenalty2). Returns 1 then, else 0.
;-----------------------------------------------------------------------------
; C: src/engine/pass/CheckBump.c
%ifdef CBUILD
%include "c/engine/pass/CheckBump.inc"
%else
CheckBump:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push esi
        mov ebx, eax
        mov eax, 20h
        call randomd0
        test ax, ax
        jne near .10
        mov eax, dword [pucky]
        mov ax, word [eax]
        sub ax, word [byte edx+Ypos+2]
        test ax, ax
        jge short .1
        cwde
        neg eax
        jmp short .2
.1:
        cwde
.2:
        cmp eax, byte 28h
        jg near .10
        mov cx, word [byte ebx+0Ch]
        mov ax, word [byte ebx+0Eh]
        test cx, cx
        jge short .3
        movsx esi, cx
        neg esi
        jmp short .4
.3:
        movsx esi, cx
.4:
        cmp esi, 1B58h
        jg short .7
        test ax, ax
        jge short .5
        movsx esi, ax
        neg esi
        jmp short .6
.5:
        movsx esi, ax
.6:
        cmp esi, 1B58h
        jle short .10
.7:
        movsx esi, cx
        sar esi, 2
        mov word [byte edx+Xvel], si
        cwde
        sar eax, 2
        mov word [byte edx+Yvel], ax
        mov word [byte ebx+0Ch], 0
        mov word [byte ebx+0Eh], 0
        or byte [sflags], 40h
        test byte [gmode], 1
        je short .9
.8:
        mov eax, 1
        pop esi
        pop ecx
        pop ebx
        ret
.9:
        mov edx, 1Eh
        mov eax, ebx
        call AddPenalty2
        jmp short CheckBump.8
.10:
        xor eax, eax
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; GetLowestPen                                        54A53  94G penalty94.asm
; Same algorithm as 94G penalty94 GetLowestPen (IDA CalcPenTime): shorthanded
; team from tmap, walks its box list (+0B6h) summing the non-coincidental
; tmpdst (+7Eh, &3FFFh) time steps, then compares with the power-play team's
; list; returns the power-play time left
;-----------------------------------------------------------------------------
; C: src/engine/pass/checkob.c (GetLowestPen)
%ifdef CBUILD
%include "c/engine/pass/checkob.GetLowestPen.inc"
%else
GetLowestPen:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ax, word [hmtmap]
        sub ax, word [awtmap]
        test ax, ax
        jle short .1
        mov esi, hmtmstruct
        mov edi, awtmstruct
        jmp short .3
.1:
        jl short .2
        xor eax, eax
        jmp near checkob_ret5
.2:
        mov esi, awtmstruct
        mov edi, hmtmstruct
.3:
        xor ecx, ecx
        xor ebx, ebx
        lea edx, [dword edi+0B6h]
.4:
        movsx ax, byte [edx]
        inc edx
        test ax, ax
        jl short .5
        cwde
        mov ax, word [byte edi+eax*2+07Eh]
        test ax, ax
        jl short GetLowestPen.4
        and ah, 3Fh
        sub eax, ecx
        add ebx, eax
        mov ecx, eax
        jmp short GetLowestPen.4
.5:
        cmp word [byte esi+tmap], byte 6
        jne short .7
.6:
        mov eax, ebx
        jmp near checkob_ret5
.7:
        sub ebx, ecx
        lea edx, [dword esi+0B6h]
.8:
        movsx ax, byte [edx]
        inc edx
        test ax, ax
        jl short GetLowestPen.6
        cwde
        mov ax, word [byte esi+eax*2+07Eh]
        test ax, ax
        jl short GetLowestPen.8
        and ah, 3Fh
        cmp bx, ax
        jl short GetLowestPen.6
        mov eax, ebx
        add eax, ecx
        jmp near checkob_ret5
%endif ; C
;-----------------------------------------------------------------------------
; chk4lc                                              54AF9  93G logic93_3.asm
; (see if computer should call line change). Puck in own half below the blue line,
; 1 in 4, not pflags2 bit 3; PC adds clock penalty checks (GetLowestPen). Then CompLine, setpersonel and
; chk4lc_shoot: CompShoot dumps the puck. Returns 1 when it did.
;-----------------------------------------------------------------------------
; C: src/engine/pass/checkob.c (chk4lc)
%ifdef CBUILD
%include "c/engine/pass/checkob.chk4lc.inc"
%else
chk4lc:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ecx, eax
        test byte [gameopts], 4
        je near .3
        cmp dword [penshotlive], byte 0
        jne near .3
        mov ebx, dword [pucky]
        mov ax, word [ebx]
        mov word [regd0], ax
        test byte [byte ecx+pflags], 80h
        jne short .1
        mov edx, eax
        neg edx
        mov word [regd0], dx
.1:
        mov bx, word [regd0]
        test bx, bx
        jl short .3
        cmp bx, byte 4Eh
        jg short .3
        mov eax, 4
        call randomd0
        test ax, ax
        jne short .3
        test byte [byte ecx+pflags2], 8
        jne short .3
        mov ebx, dword [byte ecx+tmptr]
        mov esi, dword [byte ecx+optmptr]
        mov dx, word [byte ebx+tmap]
        sub dx, word [byte esi+tmap]
        test byte [dword ebx+0D4h], 40h
        je short .4
        cmp word [gameclock], byte 0Fh
        jl short .3
.2:
        test dx, dx
        je short .8
        call GetLowestPen
        cmp ax, 0Fh
        jge short .8
.3:
        xor eax, eax
        jmp near checkob_ret5
.4:
        mov eax, ebx
        call AvgCline
        mov ax, word [gameclock]
        cmp ax, 0Fh
        jl short chk4lc.3
        cmp ax, 1Eh
        jge short .5
        cmp word [regd0], 800h
        ja short chk4lc.3
.5:
        test dx, dx
        je short .6
        mov eax, 0F33h
        jmp short .7
.6:
        mov eax, dword [dword ebx+0D6h]
.7:
        xor edi, edi
        mov di, word [regd0]
        cmp edi, eax
        ja short chk4lc.3
        jmp short chk4lc.2
.8:
        mov edx, ebx
        mov eax, esi
        call CompLine
        mov eax, ebx
        call setpersonel
chk4lc_shoot:
        mov eax, ecx
        call CompShoot
        mov eax, 1
        jmp near checkob_ret5
%endif ; C
;-----------------------------------------------------------------------------
; PassLaneChk                                     54C09  95 PC, low confidence
; Pass target check for passer eax / receiver edx: 0 when the passer is the
; goalie, when ShotLaneOpen says no, or when the receiver is on the wrong
; side of the blue line (4Eh by pfgoal); then a vtoa lane test; used by
; chk4pass and dopass
;-----------------------------------------------------------------------------
PassLaneChk:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov ecx, eax
        mov ebx, edx
        test byte [byte eax+044h], 80h
        setne al
        movzx edi, al
        mov edx, edi
        cmp word [byte ecx+position], byte 0
        jne short .2
.1:
        xor eax, eax
        jmp near PassLaneChk_ret5a
.2:
        call ShotLaneOpen
        test eax, eax
        jne short PassLaneChk.1
        mov esi, dword [byte ebx+Ypos]
        sar esi, 10h
        mov eax, dword [byte ecx+Ypos]
        sar eax, 10h
        test edi, edi
        je short .3
        mov edi, 4Eh
        jmp short .4
.3:
        mov edi, 0FFFFFFB2h
.4:
        cmp eax, edi
        setg byte [esp]
        movzx edi, byte [esp]
        xor edi, edx
        jne short PassLaneChk.1
        test eax, eax
        jge short .5
        mov edi, eax
        neg edi
        jmp short .6
.5:
        mov edi, eax
.6:
        test esi, esi
        jge short .7
        mov ebp, esi
        neg ebp
        jmp short .8
.7:
        mov ebp, esi
.8:
        cmp edi, ebp
        jle short PassLaneChk.1
        test eax, eax
        jge short .9
        mov edi, eax
        neg edi
        jmp short .10
.9:
        mov edi, eax
.10:
        cmp edi, byte 76h
        jg short PassLaneChk.1
        test edx, edx
        je short .11
        cmp word [byte ebx+Yvel], byte 0
        jl short PassLaneChk.1
        cmp word [byte ecx+Yvel], byte 0
        jl short PassLaneChk.1
.11:
        test edx, edx
        jne short .12
        cmp word [byte ebx+Yvel], byte 0
        jg near PassLaneChk.1
        cmp word [byte ecx+Yvel], byte 0
        jg near PassLaneChk.1
.12:
        mov edx, dword [byte ebx+0Ch]
        sar edx, 18h
        add edx, esi
        lea edi, [byte eax-04Eh]
        sub edx, byte 4Eh
        xor edx, edi
        test edx, edx
        jl near PassLaneChk.1
        sub esi, eax
        test esi, esi
        jge short .13
        neg esi
.13:
        cmp esi, byte 3Ch
        jg near PassLaneChk.1
        mov eax, dword [ecx]
        sar eax, 10h
        mov esi, dword [ebx]
        sar esi, 10h
        sub eax, esi
        mov esi, eax
        test eax, eax
        jge short .14
        neg esi
.14:
        cmp esi, byte 28h
        jg near PassLaneChk.1
        mov edx, dword [byte ebx+Yvel-2]
        sar edx, 10h
        mov eax, dword [byte ebx+Xvel-2]
        sar eax, 10h
        call vtoa
        movsx esi, ax
        cmp esi, byte 8
        jne short .15
        mov esi, dword [byte ebx+facedir-2]
        sar esi, 10h
.15:
        mov ax, word [byte ecx+Ypos+2]
        sub ax, word [byte ebx+Ypos+2]
        movsx edx, ax
        mov ax, word [byte ecx+Xpos+2]
        sub ax, word [byte ebx+Xpos+2]
        cwde
        call vtoa
        cwde
        sub esi, eax
        lea eax, [byte esi+01h]
        and eax, byte 7
        cmp eax, byte 3
        jge near PassLaneChk.1
        mov eax, 1
PassLaneChk_ret5a:
        add esp, byte 4
PassLaneChk_ret5:
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; ScatterPass                                     54D63  95 PC, low confidence
; (player, receiver): counts a pass attempt (team +26h, hmpassatt) unless
; replay, sets passplayer, receiver gets asstab 13h (asspassrec), puck gets
; random vx/vy scaled by (12h - passing skill +5Dh)*14h
;-----------------------------------------------------------------------------
; C: src/engine/pass/ScatterPass.c
%ifdef CBUILD
%include "c/engine/pass/ScatterPass.inc"
%else
ScatterPass:
        push dword 0Ch
        call __CHK
        push ebx
        push esi
        mov ebx, eax
        mov eax, edx
        mov word [byte ebx+03Eh], 28h
        test byte [gmode], 10h
        jne short .1
        mov edx, dword [byte ebx+06Ch]
        inc word [byte edx+026h]
.1:
        mov dx, word [byte eax+06Ah]
        mov word [passplayer], dx
        mov byte [byte ebx+053h], 0
        mov edx, 13h
        call assinsert
        mov eax, dword [puckvz]
        mov word [eax], 0
        xor eax, eax
        mov al, byte [byte ebx+05Dh]
        mov edx, 12h
        sub edx, eax
        imul eax, edx, byte 14h
        cwde
        call randomd0
        mov edx, dword [puckvx]
        mov word [edx], ax
        xor eax, eax
        mov al, byte [byte ebx+05Dh]
        mov edx, 12h
        sub edx, eax
        imul eax, edx, byte 14h
        cwde
        call randomd0
        mov edx, dword [puckvy]
        mov word [edx], ax
        xor esi, esi
        mov word [pucknopuck], si
        pop esi
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; dopass                             54DF4  94G logic94.asm, medium confidence
; Genesis comment (logic94.asm): pass the puck in passdir, to the best
; teammate there if any
;-----------------------------------------------------------------------------
dopass:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 0Ch
        mov ecx, eax
        xor edx, edx
        mov dword [onetimerflag], edx
        and byte [sflags], 0FBh
        mov eax, dword [puckc]
        mov byte [eax], 0FFh
        mov word [byte ecx+03Eh], 10h
        mov ax, word [byte ecx+SCnum]
        mov word [lastplayer], ax
        test byte [byte ecx+pflags], 8
        jne short .2
        cmp byte [byte ecx+053h], 0
        je short .2
        mov eax, dword [byte ecx+046h]
        sar eax, 10h
        shl eax, 7
        mov edx, SortCords
        add edx, eax
.1:
        mov eax, ecx
        call ScatterPass
        jmp near .23
.2:
        cmp word [byte ecx+position], byte 0
        jne short .3
        mov word [byte esp+08h], 8
        jmp short .4
.3:
        xor eax, eax
        mov al, byte [byte ecx+05Dh]
        mov word [byte esp+08h], ax
.4:
        mov eax, dword [byte esp+08h]
        shl eax, 2
        add eax, 0A0h
        mov word [passspeed], ax
        cmp word [byte ecx+SCnum], byte 6
        jge short .5
        xor eax, eax
        jmp short .6
.5:
        mov eax, 6
.6:
        shl eax, 7
        mov ebx, SortCords
        add ebx, eax
        mov dword [byte esp+04h], 0FFFFFFFFh
        xor ebp, ebp
        mov word [byte esp+08h], 6
.7:
        cmp ecx, ebx
        je near .11
        cmp word [byte ebx+position], byte 0
        jle near .11
        test byte [byte ebx+pflags2], 4
        jne short .11
        mov edi, dword [puckx]
        mov si, word [byte ebx+Xpos+2]
        sub si, word [edi]
        movsx edi, si
        mov eax, dword [pucky]
        mov si, word [byte ebx+Ypos+2]
        sub si, word [eax]
        movsx esi, si
        mov edx, esi
        mov eax, edi
        call vtoa
        sub ax, word [passdir]
        xor ah, ah
        and al, 7
        cmp ax, 1
        jle short .8
        cmp ax, 7
        jne short .11
.8:
        imul edi, edi
        imul esi, esi
        add esi, edi
        test ax, ax
        jne short .9
        xor eax, eax
        jmp short .10
.9:
        mov eax, 10000h
.10:
        add esi, eax
        mov dword [esp], esi
        cmp esi, dword [byte esp+04h]
        ja short .11
        mov dword [byte esp+04h], esi
        mov ebp, ebx
.11:
        add ebx, 80h
        mov esi, dword [byte esp+08h]
        dec si
        mov word [byte esp+08h], si
        jne near dopass.7
        test ebp, ebp
        je short .13
        test byte [byte ecx+pflags], 8
        je short .12
        mov edx, ebp
        mov eax, ecx
        call PassLaneChk
        test eax, eax
        je short .12
        mov edx, ebp
        jmp near dopass.1
.12:
        mov eax, ebp
        call passtoa0
        jmp near .14
.13:
        mov edi, dword [passspeed-2]
        sar edi, 10h
        mov esi, dword [passdir-2]
        sar esi, 10h
        mov esi, dword [nosplit esi*4+dirtab]
        sar esi, 10h
        imul esi, edi
        shl esi, 0Ah
        mov dword [esp], esi
        mov ebx, 0BB8h
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ebx
        mov dword [esp], eax
        mov edx, dword [esp]
        add dx, word [byte ecx+Yvel]
        mov eax, dword [puckvy]
        mov word [eax], dx
        mov esi, dword [passdir-2]
        sar esi, 10h
        mov esi, dword [nosplit esi*4+clockticks]
        sar esi, 10h
        imul esi, edi
        shl esi, 0Ah
        mov dword [esp], esi
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ebx
        mov dword [esp], eax
        mov edx, dword [esp]
        add dx, word [byte ecx+Xvel]
        mov eax, dword [puckvx]
        mov word [eax], dx
        mov eax, 1000h
        call randomd0
        mov edx, eax
        mov eax, dword [puckvz]
        mov word [eax], dx
.14:
        cmp word [byte ecx+position], byte 0
        jne near .20
        test byte [byte ecx+pflags], 80h
        sete al
        mov edx, eax
        and edx, 0FFh
        mov eax, dword [puckvy]
        cmp word [eax], byte 0
        setl al
        and eax, 0FFh
        xor eax, edx
        je short .15
        mov eax, dword [puckvy]
        mov dx, word [eax]
        neg edx
        mov word [eax], dx
.15:
        mov word [byte esp+08h], 1B9h
        or byte [byte ecx+pflags2], 2
        test byte [byte ecx+pflags], 8
        je near .22
        test ebp, ebp
        je short .17
        test byte [byte ebp+044h], 8
        jne short .17
        mov ax, word [byte ecx+SCnum]
        mov dx, word [c1playernum]
        cmp ax, dx
        jne short .16
        cmp dx, word [byte ebp+06Ah]
        je near .22
        mov edx, dword [c1playernum-2]
        sar edx, 10h
        mov eax, dword [byte ebp+068h]
        sar eax, 10h
        call restorepl
        mov word [c1playernum], ax
        jmp near .22
.16:
        mov ax, word [byte ebp+06Ah]
        cmp ax, word [c2playernum]
        je near .22
        mov edx, dword [c2playernum-2]
        sar edx, 10h
        mov eax, dword [byte ebp+068h]
        sar eax, 10h
        call restorepl
        mov word [c2playernum], ax
        jmp short .22
.17:
        mov ax, word [byte ecx+SCnum]
        cmp ax, word [c1playernum]
        jne short .18
        xor eax, eax
        jmp short .19
.18:
        mov eax, 2
.19:
        movsx edx, ax
        mov eax, ecx
        call changeplayer
        jmp short .22
.20:
        mov edx, dword [puckvy]
        movsx edx, word [edx]
        mov eax, dword [puckvx]
        movsx eax, word [eax]
        call vtoa
        movsx edx, ax
        mov eax, ecx
        call Findhittype
        test ax, ax
        jne short .21
        mov word [byte esp+08h], 389h
        jmp short .22
.21:
        mov word [byte esp+08h], 3C1h
.22:
        mov edx, dword [byte esp+06h]
        sar edx, 10h
        mov eax, ecx
        call SetSPA
        or byte [byte ecx+pflags], 20h
        mov eax, dword [puckvz]
        cmp byte [byte eax+01h], 6
        setge al
        and eax, 0FFh
        add eax, 98h
        cwde
        call sfx
.23:
        add esp, byte 0Ch
dopass_ret6:
        pop ebp
        jmp near checkob_ret5
;-----------------------------------------------------------------------------
; passmode                                              5514E  94G logic94.asm
; As 93G passmode: B changed (regd2 bit 4) -> dopass, else dpad&7 -> passdir
;-----------------------------------------------------------------------------
; C: src/engine/pass/passmode.c
%ifdef CBUILD
%include "c/engine/pass/passmode.inc"
%else
passmode:
        push dword 8
        call __CHK
        push edx
        test byte [regd2], 10h
        jne short .1
        test byte [regd0], 8
        jne short .x
        mov dx, word [regd0]
        xor dh, dh
        and dl, 7
        mov word [passdir], dx
        or byte [regd0], 8
        test byte [byte eax+044h], 8
        je short .1
        mov dx, word [byte eax+06Ah]
        cmp dx, word [c1playernum]
        setne dl
        and edx, 0FFh
        cmp byte [dword edx+pad1dev], 1
        je short .x
.1:
        call dopass
.x:
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; setpassmode                        551AF  94G logic94.asm, medium confidence
; Genesis comment (logic94.asm): initialize pass mode
;-----------------------------------------------------------------------------
; C: src/engine/pass/setpassmode.c
%ifdef CBUILD
%include "c/engine/pass/setpassmode.inc"
%else
setpassmode:
        push dword 4
        call __CHK
        mov ax, word [byte eax+036h]
        xor ah, ah
        and al, 7
        mov word [passdir], ax
        or byte [sflags], 4
        ret
%endif ; C
;-----------------------------------------------------------------------------
; passtoa0                           551CF  94G logic94.asm, medium confidence
; Genesis comment (logic94.asm): pass puck to player a0
;-----------------------------------------------------------------------------
passtoa0:
        push dword 38h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 1Ch
        mov esi, eax
        test byte [gmode], 10h
        jne short .1
        mov eax, dword [byte esi+06Ch]
        inc word [byte eax+026h]
.1:
        mov ax, word [byte esi+SCnum]
        mov word [passplayer], ax
        mov edx, 13h
        mov eax, esi
        call assinsert
        mov eax, esi
        call GetHot
        mov dx, word [regd0]
        add dx, word [byte esi+Xpos+2]
        mov eax, dword [puckx]
        mov cx, word [eax]
        sub edx, ecx
        mov word [byte esp+014h], dx
        mov ecx, dword [byte esp+012h]
        sar ecx, 12h
        mov dx, word [regd1]
        add dx, word [byte esi+Ypos+2]
        mov eax, dword [pucky]
        mov bx, word [eax]
        sub edx, ebx
        mov word [byte esp+010h], dx
        mov edi, dword [byte esp+0Eh]
        sar edi, 12h
        mov edx, dword [byte esi+Xvel-2]
        sar edx, 10h
        mov eax, edx
        shl eax, 4
        sub eax, edx
        shl eax, 4
        sar eax, 10h
        mov word [esp], ax
        mov edx, dword [byte esi+Yvel-2]
        sar edx, 10h
        mov eax, edx
        shl eax, 4
        sub eax, edx
        shl eax, 4
        sar eax, 10h
        mov word [byte esp+0Ch], ax
        mov eax, dword [esp]
        imul eax, ecx
        mov edx, dword [byte esp+0Ch]
        imul edx, edi
        add eax, edx
        add eax, eax
        mov word [byte esp+08h], ax
        mov eax, dword [passdir]
        sar eax, 12h
        mov ebx, eax
        mov edx, dword [byte esp-02h]
        sar edx, 10h
        imul edx, edx
        mov eax, dword [byte esp+0Ah]
        sar eax, 10h
        imul eax, eax
        add edx, eax
        movsx eax, bx
        imul eax, eax
        sub edx, eax
        mov word [byte esp+018h], dx
        movsx edx, cx
        imul edx, edx
        movsx ecx, di
        imul ecx, ecx
        add ecx, edx
        mov edx, dword [byte esp+016h]
        sar edx, 10h
        imul ecx, edx
        shl ecx, 2
        mov eax, dword [byte esp+06h]
        sar eax, 10h
        imul eax, eax
        sub eax, ecx
        mov ecx, eax
        test eax, eax
        jle short .2
        push eax
        call IntSqrt
        add esp, byte 4
        mov ecx, eax
        jmp short .3
.2:
        xor ecx, eax
.3:
        mov edi, dword [byte esp+018h]
        sar di, 2
        mov word [byte esp+018h], di
        test di, di
        jne short .4
        mov word [byte esp+018h], 1
.4:
        xor ebx, ebx
        jmp short .6
.5:
        mov word [byte esp+04h], cx
        neg ecx
        mov eax, dword [byte esp+02h]
        sar eax, 10h
        mov edx, dword [byte esp+06h]
        sar edx, 10h
        sub eax, edx
        mov edx, eax
        mov edi, dword [byte esp+016h]
        sar edi, 10h
        sar edx, 1Fh
        idiv edi
        mov word [byte esp+04h], ax
        test ax, ax
        jge short .7
        inc ebx
.6:
        cmp bx, byte 2
        jl short passtoa0.5
.7:
        cmp word [byte esp+04h], byte 0
        jg short .8
        mov word [byte esp+04h], 1
.8:
        cmp word [byte esp+04h], byte 18h
        jle short .9
        mov word [byte esp+04h], 18h
.9:
        cmp word [byte esp+04h], byte 0Ch
        jge short .10
        mov eax, dword [byte esp+02h]
        sar eax, 10h
        jmp short .11
.10:
        mov eax, 0Ch
.11:
        movsx bx, al
        cmp bx, byte 6
        jle short .12
        movsx edi, bx
        lea edx, [byte edi+01h]
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov ecx, eax
        mov eax, edi
        mov edx, edi
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        cwde
        call randomd0
        cwde
        add eax, ecx
        mov ebx, eax
.12:
        mov eax, dword [puckvz]
        mov byte [byte eax+01h], bl
        mov al, byte [byte esp+04h]
        shl al, 3
        sub al, 0Ah
        mov byte [byte esi+027h], al
        mov eax, dword [byte esi+024h]
        sar eax, 18h
        sub eax, byte 6
        mov word [pucknopuck], ax
        mov edx, dword [byte esp+02h]
        sar edx, 10h
        mov ecx, dword [byte esp-02h]
        sar ecx, 10h
        imul ecx, edx
        sar ecx, 1
        mov eax, dword [byte esp+012h]
        sar eax, 10h
        add ecx, eax
        mov dword [regd0], ecx
        mov eax, dword [puckx]
        mov ax, word [eax]
        mov bx, word [regd0]
        add eax, ebx
        mov word [byte esi+temp3], ax
        mov eax, dword [byte esp+0Ah]
        sar eax, 10h
        imul edx, eax
        sar edx, 1
        mov eax, dword [byte esp+0Eh]
        sar eax, 10h
        add edx, eax
        mov dword [regd1], edx
        mov eax, dword [pucky]
        mov ax, word [eax]
        mov cx, word [regd1]
        add eax, ecx
        mov word [byte esi+temp4], ax
        mov esi, dword [byte esp+04h]
        imul eax, esi, byte 78h
        mov word [byte esp+04h], ax
        mov eax, dword [regd0]
        call ToFixed
        mov edx, eax
        mov ecx, dword [byte esp+02h]
        sar ecx, 10h
        sar edx, 1Fh
        idiv ecx
        mov esi, eax
        mov eax, dword [puckvx]
        mov word [eax], si
        mov eax, dword [regd1]
        call ToFixed
        mov edx, eax
        sar edx, 1Fh
        idiv ecx
        mov esi, eax
        mov eax, dword [puckvy]
        mov word [eax], si
        add esp, byte 1Ch
        jmp near checkob_ret5
;-----------------------------------------------------------------------------
; chk4pass                                              55493  94G logic94.asm
; (computer looks for a good pass): threat spodds roll, target by vtoa
; (PassLaneChk), dopass, assexit.
;-----------------------------------------------------------------------------
; C: src/engine/pass/checkob.c (chk4pass)
%ifdef CBUILD
%include "c/engine/pass/checkob.chk4pass.inc"
%else
chk4pass:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ebx, eax
        mov byte [byte eax+053h], 0
        mov dx, word [threat]
        test dx, dx
        jne short .1
        xor ah, ah
        mov al, byte [byte ebx+05Fh]
        add eax, 10h
        cwde
        call randomd0
        cmp ax, 9
        jg near .29
.1:
        mov eax, 6
        call randomd0
        mov word [regd0], ax
        cmp word [byte ebx+SCnum], byte 6
        jl short .2
        add eax, 6
        mov word [regd0], ax
.2:
        mov ax, word [regd0]
        cmp ax, word [byte ebx+SCnum]
        jne short .4
.3:
        xor edx, edx
        jmp near .29
.4:
        mov ecx, dword [regd0-2]
        sar ecx, 10h
        shl ecx, 7
        add ecx, SortCords
        cmp word [byte ecx+position], byte 0
        jle short chk4pass.3
        test byte [byte ecx+pflags2], 4
        jne short chk4pass.3
        test byte [byte ecx+pflags], 20h
        jne short chk4pass.3
        cmp word [byte ebx+position], byte 0
        je near .17
        test byte [byte ebx+pflags], 80h
        setne al
        mov edx, eax
        and edx, 0FFh
        mov eax, dword [pucky]
        cmp word [eax], byte 0
        setg al
        and eax, 0FFh
        xor eax, edx
        je near .17
        mov edx, dword [puckx]
        mov di, word [edx]
        test di, di
        jge short .5
        movsx eax, di
        neg eax
        jmp short .6
.5:
        movsx eax, di
.6:
        cmp eax, byte 32h
        jg near .17
        mov edx, dword [pucky]
        mov ax, word [edx]
        test ax, ax
        jge short .7
        cwde
        neg eax
        jmp short .8
.7:
        cwde
.8:
        cmp eax, 0ACh
        jle near .17
        mov edx, dword [pucky]
        mov si, word [edx]
        test si, si
        jge short .9
        movsx eax, si
        neg eax
        jmp short .10
.9:
        movsx eax, si
.10:
        cmp eax, 0EBh
        jl near chk4pass.3
        mov ax, word [byte ecx+Xpos+2]
        mov word [regd0], ax
        mov ax, word [byte ecx+Ypos+2]
        mov word [regd1], ax
        cmp word [regd0], byte 0
        jge short .11
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .12
.11:
        mov eax, dword [regd0-2]
        sar eax, 10h
.12:
        cmp eax, byte 3Ch
        jl near chk4pass.3
        mov eax, dword [puckx]
        movsx edx, word [eax]
        mov eax, dword [regd0-2]
        sar eax, 10h
        xor eax, edx
        test eax, eax
        jge short .17
        mov edx, dword [pucky]
        mov ax, word [edx]
        test ax, ax
        jge short .13
        cwde
        neg eax
        jmp short .14
.13:
        cwde
.14:
        lea edx, [dword eax-0E8h]
        cmp word [regd1], byte 0
        jge short .15
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .16
.15:
        mov eax, dword [regd1-2]
        sar eax, 10h
.16:
        sub eax, 0E8h
        xor eax, edx
        test eax, eax
        jl near chk4pass.3
.17:
        mov ax, word [byte ecx+Ypos+2]
        mov word [regd0], ax
        mov ax, word [byte ebx+Ypos+2]
        mov word [regd1], ax
        test byte [byte ebx+pflags], 80h
        jne short .18
        neg word [regd0]
        neg word [regd1]
.18:
        test byte [gameopts], 2
        je short .19
        mov edx, dword [regd0-2]
        sar edx, 10h
        mov eax, dword [regd1-2]
        sar eax, 10h
        sub eax, byte 4Eh
        sub edx, byte 4Eh
        xor eax, edx
        test eax, eax
        jge short .19
        mov edx, ecx
        mov eax, ebx
        call PassLaneChk
        mov byte [byte ebx+053h], al
        test al, al
        je near chk4pass.3
        jmp short .20
.19:
        mov dx, word [regd0]
        cmp dx, byte 4Eh
        jg short .21
        mov ax, word [regd1]
        mov esi, edx
        sub esi, eax
        mov word [regd0], si
        mov eax, dword [regd0-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFF1h
        jge short .21
        mov edx, ecx
        mov eax, ebx
        call PassLaneChk
        mov byte [byte ebx+053h], al
        test al, al
        je near chk4pass.3
.20:
        mov ax, word [byte ecx+SCnum]
        mov word [byte ebx+048h], ax
.21:
        test byte [gameopts], 8
        je short .22
        test byte [byte ecx+pflags2], 80h
        je short .22
        mov eax, dword [regd1-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFB2h
        jge short .22
        cmp word [regd0], byte 0
        jg near chk4pass.3
.22:
        mov al, byte [byte ecx+052h]
        xor al, 4
        cbw
        mov word [passdir], ax
        mov eax, dword [byte ecx+04Ch]
        sar eax, 10h
        mov dword [regd2], eax
        cmp word [byte ebx+SCnum], byte 6
        jge short .23
        mov eax, 6
        jmp short .24
.23:
        xor eax, eax
.24:
        shl eax, 7
        mov edx, SortCords
        add edx, eax
        mov word [regd3], 6
.25:
        mov ecx, dword [byte edx+04Ch]
        sar ecx, 10h
        cmp ecx, dword [regd2]
        jg short .28
        mov al, byte [byte edx+052h]
        xor al, 4
        cbw
        mov si, word [passdir]
        sub esi, eax
        mov eax, esi
        inc eax
        xor ah, ah
        and al, 7
        cmp ax, 1
        je near chk4pass.3
        cmp word [byte ebx+position], byte 0
        jne short .28
        cmp ecx, byte 1Eh
        jl near chk4pass.3
        cmp ax, 2
        jg short .26
        cmp ecx, byte 3Ch
        jl near chk4pass.3
.26:
        cmp ax, 3
        je short .27
        cmp ax, 7
        jne short .28
.27:
        cmp ecx, byte 28h
        jl near chk4pass.3
.28:
        add edx, 80h
        mov di, word [regd3]
        dec di
        mov word [regd3], di
        jne short chk4pass.25
        mov eax, ebx
        call dopass
        mov dx, word [byte ebx+position]
        test dx, dx
        je short .29
        mov eax, ebx
        call assexit
        mov edx, 1
.29:
        mov eax, edx
        jmp near checkob_ret5
%endif ; C
