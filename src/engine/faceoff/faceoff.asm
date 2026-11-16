; Faceoffs and the penalty shot. Who lines up, when the puck is dropped, and the penalty-shot
; assignments.
bits 32
%include "hockey.inc"
section s_51115 progbits alloc exec nowrite align=1
extern __CHK, a2touchpuck, apl, assexit, assinsert, assreplace, awscore, awtmflags
extern awtmlcnt, awtmline, awtmstruct, bannermsg, bannertimer, assonetimer_blade, assonetimer_blade_y, fofdata2_b3
extern fofdata2_b7, c1playernum, c2playernum, camx, camy, CanBlockShot_ret5, CenterMouse, changeplayer
extern checkwindow, clockcont_0, clockticks, CompLine, cont1team, cont2team, crowdlevel, donothing
extern doshot, DrawPanelLine, demoflag, ovlartbank, SpeechPatchNext, Endfaceoff, energywarn, shotongoal
extern EvadePC, fadeinpending, Findhittype, FlushGSumQueue, fodir1, fodir2, fofdata2, forcepldata
extern fox, foy, FreeMemBlock, gameclock, gameopts, gmode, gmode2, gsp
extern hmroster, hmscore, hmtmflags, hmtmlcnt, hmtmline, hmtmpdst, hmtmstruct, iflags
extern introskipped, joysampling, joysampling_save, lcblink, lcboxon, lcfound, ltx, lty
extern onetimerflag, ovlseq, ovlstep, ovltimer, PaSpeechBusy, passdir, passplayer, passspeed
extern penshotmode, penshotplayer, penshotstart, penshotteam, PerTimeTotal, puckc, puckcross, puckstruct
extern puckvx, puckvy, puckvz, puckx, pucky, puckz, randomd0, RefPen
extern refsignal, RefStep, regd0, regd1, regd2, regd4, ResetBench, resetplstuff
extern restorepl, ReturnGoalies, SetExitGame, setpersonel, Setplass, setplayer, SetSPA, SetupPenaltyShot
extern sflags, sflags3, sfx, skateto, skatetopuck, SkateToSpot, SortCords, sortobj15
extern SprSort, SprSortVert, StartFaceoffLineChange, Stop4Pen, StopDigiSample, textline1, textline2, textline3
extern textline4, textline5, threat, updateanim, vtoa, penaltysc, SortPending, puckfaceoff2_ptab
extern puckfaceoff2_ptab_y, injurystop, fofdata2_w2, fofdata2_w4, fofdata2_w6, fofdata, fofdata_w2, penevteam
extern xc1, yc1, yleader
global TakePlayerFromBox, TakePlayerFromBox_ret6, TakePlayerFromBox_ret5, PenShotStart, ForceStartLineup, PenShotAssign, AllInPlace, assleavebox
global puckfaceoff, puckfaceoff2, assbenchwait, asstakeposition, check4bench, asspsclear, assrefpenshot
;-----------------------------------------------------------------------------
; TakePlayerFromBox                            51115  95 PC, medium confidence
; Sort object eax takes the first roster player whose status is 7 (penalty over):
; leaves the box (SPA 7BFh, temp1 5Ah), roster status 3, tmpdst -2.
;-----------------------------------------------------------------------------
; C: src/engine/faceoff/TakePlayerFromBox.c
%ifdef CBUILD
%include "c/engine/faceoff/TakePlayerFromBox.inc"
%else
TakePlayerFromBox:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov ebp, eax
        test byte [byte eax+044h], 40h
        setne al
        xor ah, ah
        mov word [esp], ax
        xor ebx, ebx
        jmp short .3
.1:
        mov edi, dword [byte esp-02h]
        sar edi, 10h
        mov ecx, edi
        shl ecx, 4
        add ecx, edi
        shl ecx, 4
        add ecx, edi
        shl ecx, 2
        movsx esi, bx
        mov eax, esi
        shl eax, 2
        add eax, esi
        shl eax, 3
        sub eax, esi
        add ecx, eax
        cmp byte [dword ecx+hmroster], 7
        jne short .2
        mov word [byte ebp+facedir], 4
        mov edx, 7BFh
        mov eax, ebp
        call SetSPA
        or byte [byte ebp+pflags], 20h
        mov word [byte ebp+temp1], 5Ah
        mov word [byte ebp+temp5], bx
        mov byte [dword ecx+hmroster], 3
        shl edi, 8
        mov eax, esi
        mov word [dword edi+eax*2+hmtmpdst], 0FFFEh
        jmp short .4
.2:
        inc ebx
.3:
        cmp bx, byte 19h
        jl short TakePlayerFromBox.1
.4:
        add esp, byte 4
TakePlayerFromBox_ret6:
        pop ebp
TakePlayerFromBox_ret5:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; PenShotStart                                    511B4  95 PC, low confidence
; With penshotmode off: for the team in eax, when penshotstart is set moves
; players in assignment 2Dh to 29h; else re-assigns skaters
;
; with no newpos/newpnum; puckfaceoff caller
;-----------------------------------------------------------------------------
; C: src/engine/faceoff/TakePlayerFromBox.c (PenShotStart)
%ifdef CBUILD
%include "c/engine/faceoff/TakePlayerFromBox.PenShotStart.inc"
%else
PenShotStart:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        cmp dword [penshotmode], byte 0
        jne near .x
        movsx ebx, ax
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 8
        mov ebx, SortCords
        add ebx, eax
        xor ecx, ecx
.1:
        cmp dword [penshotstart], byte 0
        je short .2
        mov eax, dword [byte ebx+assnum-2]
        sar eax, 10h
        cmp byte [byte ebx+eax+01Eh], 2Dh
        jne short .2
        mov word [byte ebx+temp5], 0
        mov edx, 29h
        mov eax, ebx
        call assreplace
        jmp short .3
.2:
        cmp word [byte ebx+position], byte 0
        jl short .3
        mov eax, dword [byte ebx+03Fh]
        sar eax, 18h
        cmp eax, byte 0FFFFFFFFh
        jne short .3
        mov eax, dword [byte ebx+040h]
        sar eax, 18h
        cmp eax, byte 0FFFFFFFFh
        jne short .3
        mov eax, dword [byte ebx+temp5-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFF9Ch
        je short .3
        mov eax, dword [byte ebx+assnum-2]
        sar eax, 10h
        cmp byte [byte ebx+eax+01Eh], 27h
        je short .3
        mov edx, 27h
        mov eax, ebx
        call assinsert
.3:
        inc ecx
        add ebx, 80h
        cmp ecx, byte 6
        jl short PenShotStart.1
.x:
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ForceStartLineup                             5125F  95 PC, medium confidence
; At the opening faceoff (gsp 0, gameclock = PerTimeTotal, clockticks 0, flag
; CC0EC clear) forcepldata for team eax; puckfaceoff caller
;-----------------------------------------------------------------------------
; C: src/engine/faceoff/ForceStartLineup.c
%ifdef CBUILD
%include "c/engine/faceoff/ForceStartLineup.inc"
%else
ForceStartLineup:
        push dword 8
        call __CHK
        push edx
        cmp dword [demoflag], byte 0
        jne short .x
        cmp word [gsp], byte 0
        jne short .x
        mov dx, word [gameclock]
        cmp dx, word [PerTimeTotal]
        jne short .x
        cmp word [clockticks], byte 0
        jne short .x
        cwde
        shl eax, 8
        add eax, hmtmstruct
        call forcepldata
.x:
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; PenShotAssign                                512A7  95 PC, medium confidence
; penalty shot set-up: shooter (penshotplayer) -> assignment 27h, other skaters -> 2Dh
; (asspsclear: wait by the side boards).
;-----------------------------------------------------------------------------
; C: src/engine/faceoff/PenShotAssign.c
%ifdef CBUILD
%include "c/engine/faceoff/PenShotAssign.inc"
%else
PenShotAssign:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push edi
        mov ebx, SortCords
        cmp dword [penshotmode], byte 0
        je near .8
        xor ecx, ecx
.1:
        cmp word [byte ebx+position], byte 0
        jle short .4
        mov word [byte ebx+temp5], 0
        cmp ecx, dword [penshotplayer]
        jne short .2
        mov edx, 27h
        jmp short .3
.2:
        mov eax, dword [byte ebx+assnum-2]
        sar eax, 10h
        mov eax, dword [byte ebx+eax+01Bh]
        sar eax, 18h
        cmp eax, byte 29h
        je short .4
        cmp eax, byte 1Dh
        je short .4
        mov edx, 2Dh
.3:
        mov eax, ebx
        call assinsert
.4:
        mov di, word [byte ebx+position]
        test di, di
        jne short .7
        mov word [byte ebx+temp5], di
        test byte [byte ebx+pflags], 40h
        setne al
        and eax, 0FFh
        xor eax, dword [penshotteam]
        je short .5
        mov byte [byte ebx+newpnum], 0FFh
        mov byte [byte ebx+newpos], 0FFh
        mov edx, 27h
        jmp short .6
.5:
        mov edx, 2Dh
.6:
        mov eax, ebx
        call assinsert
.7:
        inc ecx
        add ebx, 80h
        cmp ecx, byte 0Ch
        jl near PenShotAssign.1
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.8:
        xor ecx, ecx
.9:
        cmp dword [penshotstart], byte 0
        je short .12
        mov eax, dword [byte ebx+assnum-2]
        sar eax, 10h
        add eax, ebx
        mov dl, byte [byte eax+01Eh]
        cmp dl, 2Dh
        jne short .10
        test byte [gameopts], 4
        jne near .15
        mov edx, 27h
        mov eax, ebx
        call assinsert
        mov edx, 9
        jmp near .14
.10:
        mov di, word [byte ebx+position]
        test di, di
        jle short .11
        mov byte [byte ebx+newpos], 0FFh
        mov al, byte [byte ebx+newpos]
        mov byte [byte ebx+newpnum], al
        mov edx, 28h
        jmp near .14
.11:
        jne near .15
        cmp dl, 29h
        je near .15
        mov edx, 27h
        jmp short .14
.12:
        mov dx, word [byte ebx+position]
        test dx, dx
        jle short .13
        mov word [byte ebx+temp5], 0
        mov eax, dword [byte ebx+assnum-2]
        sar eax, 10h
        mov eax, dword [byte ebx+eax+01Bh]
        sar eax, 18h
        cmp eax, byte 29h
        je short .15
        cmp eax, byte 1Dh
        je short .15
        test byte [gameopts], 4
        setne al
        and eax, 0FFh
        add eax, byte 27h
        movsx edx, ax
        jmp short .14
.13:
        jne short .15
        mov word [byte ebx+temp5], dx
        mov eax, dword [byte ebx+assnum-2]
        sar eax, 10h
        mov eax, dword [byte ebx+eax+01Bh]
        sar eax, 18h
        cmp eax, byte 29h
        je short .15
        mov edx, 27h
.14:
        mov eax, ebx
        call assinsert
.15:
        inc ecx
        add ebx, 80h
        cmp ecx, byte 0Ch
        jl near PenShotAssign.9
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; AllInPlace                                   51440  95 PC, medium confidence
; 1 when none of the 12 skater sort objects is on the ice with temp5 != -100
; (all players reached their spot), else 0
;-----------------------------------------------------------------------------
; C: src/engine/faceoff/AllInPlace.c
%ifdef CBUILD
%include "c/engine/faceoff/AllInPlace.inc"
%else
AllInPlace:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        mov eax, SortCords
        xor edx, edx
.1:
        cmp word [byte eax+01Ah], byte 0
        jl short .2
        mov ebx, dword [byte eax+02Ch]
        sar ebx, 10h
        cmp ebx, byte 0FFFFFF9Ch
        je short .2
        xor eax, eax
        pop edx
        pop ebx
        ret
.2:
        inc edx
        add eax, 80h
        cmp edx, byte 0Ch
        jl short AllInPlace.1
        mov eax, 1
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assleavebox                                     5147D  95 PC, low confidence
; Asstab slot 28h: check4bench, then skates from the penalty box area
; (temp3/temp4 targets as asspsclear) and brings the released player on
;
; (TakePlayerFromBox, setplayer, skateto)
;-----------------------------------------------------------------------------
; C: src/engine/faceoff/assleavebox.c
%ifdef CBUILD
%include "c/engine/faceoff/assleavebox.inc"
%else
assleavebox:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push edi
        mov ebx, eax
        test byte [byte eax+044h], 20h
        jne near .x
        mov eax, ebx
        call check4bench
        test ax, ax
        jne near .x
        mov dl, byte [byte ebx+pflags]
        test dl, 2
        je short .3
        mov dh, dl
        and dh, 0FDh
        mov byte [byte ebx+pflags], dh
        mov word [byte ebx+temp2], 8
        test byte [byte ebx+pflags], 40h
        jne short .1
        mov edx, 0FFFFFFCEh
        jmp short .2
.1:
        mov edx, 41h
.2:
        mov word [byte ebx+temp4], dx
        mov eax, 4
        call randomd0
        mov edx, 2
        sub edx, eax
        imul eax, edx, byte 0Fh
        add word [byte ebx+temp4], ax
        mov word [byte ebx+temp3], 0FF58h
        mov word [byte ebx+temp1], 0
        mov word [byte ebx+temp5], 0
.3:
        mov cx, word [byte ebx+temp1]
        cmp cx, byte 5Ah
        jne short .4
        mov edx, 28h
        mov eax, ebx
        call assinsert
        mov edx, dword [byte ebx+temp5-2]
        sar edx, 10h
        mov eax, ebx
        call setplayer
        mov word [byte ebx+012h], 0FFFFh
        mov word [byte ebx+temp5], 0
        mov word [byte ebx+temp1], 0
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.4:
        cmp cx, byte 64h
        je near .15
        dec ecx
        mov word [byte ebx+temp1], cx
        test cx, cx
        jge near .14
        mov edi, ecx
        add edi, byte 8
        mov word [byte ebx+temp1], di
        test byte [byte ebx+pflags], 40h
        jne short .5
        mov eax, 0FFFFFFCEh
        jmp short .6
.5:
        mov eax, 46h
.6:
        mov edx, dword [byte ebx+Ypos]
        sar edx, 10h
        sub edx, eax
        mov ax, word [byte ebx+Xpos+2]
        mov cx, word [byte ebx+temp3]
        sub eax, ecx
        mov word [regd0], ax
        test dx, dx
        jge short .7
        movsx eax, dx
        neg eax
        jmp short .8
.7:
        movsx eax, dx
.8:
        cmp eax, byte 26h
        jg near .14
        cmp word [regd0], byte 1Fh
        jg near .14
        cmp word [byte ebx+position], byte 0
        jne short .9
        mov eax, 1
        jmp short .10
.9:
        mov eax, 289h
.10:
        mov word [regd1], ax
        mov edx, dword [regd1-2]
        sar edx, 10h
        mov eax, ebx
        call SetSPA
        or byte [byte ebx+pflags], 4
        mov ax, word [byte ebx+facedir]
        cmp ax, 6
        je short .13
        cmp ax, 7
        jge short .11
        cmp ax, 2
        jle short .11
        mov edx, 1
        jmp short .12
.11:
        mov edx, 0FFFFFFFFh
.12:
        mov eax, dword [byte ebx+facedir-2]
        sar eax, 10h
        add eax, edx
        and eax, byte 7
        mov word [byte ebx+facedir], ax
.13:
        mov word [byte ebx+Yvel], 0
        mov word [byte ebx+Xvel], 0F800h
        cmp word [regd0], byte 10h
        jg near .x
        mov word [byte ebx+Xvel], 0
        cmp word [byte ebx+facedir], byte 6
        jne near .x
        mov word [byte ebx+temp1], 64h
        mov edx, 289h
        mov eax, ebx
        call SetSPA
        mov eax, ebx
        call TakePlayerFromBox
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.14:
        test byte [byte ebx+pflags], 4
        jne near .x
        mov ax, word [byte ebx+temp3]
        mov word [regd0], ax
        mov ax, word [byte ebx+temp4]
        mov word [regd1], ax
        xor edx, edx
        mov eax, ebx
        call skateto
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.15:
        cmp word [byte ebx+position], byte 0
        jle short .16
        cmp word [byte ebx+facedir], byte 6
        jne short .16
        mov eax, dword [byte ebx+044h]
        sar eax, 18h
        mov edx, dword [byte ebx+06Ch]
        mov edx, dword [byte edx+eax*2+tmpde-2]
        sar edx, 10h
        mov eax, edx
        sar edx, 1Fh
        shl edx, 5
        LD sbb, eax, edx
        sar eax, 5
        add eax, byte 50h
        cwde
        call randomd0
        test ax, ax
        jne short .16
        mov edx, 0D97h
        mov eax, ebx
        call SetSPA
        or byte [byte ebx+pflags], 20h
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.16:
        cmp word [byte ebx+SPA], byte 0
        jne short .x
        mov edx, 289h
        mov eax, ebx
        call SetSPA
.x:
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; puckfaceoff                                           516E1  94G logic94.asm
; (asstab 1Bh, puck assignment at a stoppage, 'this is where the action
; starts'): end of period (clockcont_0), penalties (Stop4Pen),
;
; computer line choice (CompLine, setpersonel), ReturnGoalies, restorepl, then
; the faceoff set-up. PC adds the penalty shot (PenShotStart) and
; ForceStartLineup.
;-----------------------------------------------------------------------------
puckfaceoff:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 0Ch
        mov ebp, eax
        add eax, byte 26h
        mov dword [esp], eax
        mov eax, ebp
        add eax, byte 28h
        mov dword [byte esp+04h], eax
        test byte [byte ebp+pflags], 2
        je near .27
        mov eax, dword [puckc]
        mov dl, byte [eax]
        cmp dl, 10h
        je short .2
        test dl, dl
        jl short .1
        cmp dword [penshotstart], byte 0
        je short .1
        movsx eax, byte [eax]
        shl eax, 7
        mov dx, word [dword eax+SortCords+1Ah]
        test dx, dx
        jne short .1
        mov word [dword eax+SortCords+3Eh], 78h
        mov eax, dword [puckvy]
        mov word [eax], dx
        mov eax, dword [puckvx]
        mov word [eax], dx
.1:
        mov eax, dword [puckc]
        mov byte [eax], 0FFh
.2:
        and byte [byte ebp+pflags], 0FDh
        cmp word [gameclock], byte 0
        jne short .3
        cmp word [clockticks], byte 0
        je short .4
.3:
        test byte [gmode], 40h
        je short .5
.4:
        call SetExitGame
        jmp near .34
.5:
        cmp word [gsp], byte 3
        jne short .6
        mov ax, word [hmscore]
        cmp ax, word [awscore]
        je short .6
        call clockcont_0
        jmp near .34
.6:
        test byte [gmode], 8
        je short .7
        xor eax, eax
        call Stop4Pen
        jmp near .34
.7:
        cmp dword [penshotmode], byte 0
        je short .8
        mov byte [byte ebp+027h], 0FFh
        mov byte [byte ebp+029h], 0FFh
        mov eax, awtmstruct
        call setpersonel
        mov eax, 1
        call PenShotStart
        xor edi, edi
        mov word [lcblink+2], di
        mov word [energywarn+2], di
        mov word [lcboxon+2], di
        mov eax, hmtmstruct
        call setpersonel
        xor eax, eax
        call PenShotStart
        mov word [lcblink], di
        mov word [energywarn], di
        mov word [lcboxon], di
        jmp near .33
.8:
        cmp dword [penshotstart], byte 0
        je near .20
        cmp word [c1playernum], byte 0
        jge near .14
        mov cx, word [cont1team]
        test cx, cx
        je short .14
        cmp cx, byte 1
        jne short .9
        mov eax, SortCords
        jmp short .10
.9:
        mov eax, SortCords+300h
.10:
        xor dl, dl
        mov bx, word [c2playernum]
        jmp short .13
.11:
        cmp word [byte eax+position], byte 0
        jl short .12
        mov cx, word [byte eax+SCnum]
        cmp bx, cx
        je short .12
        cmp cx, word [c1playernum]
        je short .14
        mov edx, dword [c1playernum-2]
        sar edx, 10h
        mov eax, dword [byte eax+SCnum-2]
        sar eax, 10h
        call restorepl
        mov word [c1playernum], ax
        jmp short .14
.12:
        inc dl
        add eax, 80h
.13:
        cmp dl, 6
        jl short puckfaceoff.11
.14:
        cmp word [c2playernum], byte 0
        jge near .20
        mov ax, word [cont2team]
        test ax, ax
        je short .20
        cmp ax, 1
        jne short .15
        mov eax, SortCords
        jmp short .16
.15:
        mov eax, SortCords+300h
.16:
        xor dl, dl
        jmp short .19
.17:
        cmp word [byte eax+position], byte 0
        jl short .18
        mov bx, word [c1playernum]
        mov cx, word [byte eax+SCnum]
        cmp bx, cx
        je short .18
        cmp cx, word [c2playernum]
        je short .20
        mov edx, dword [c2playernum-2]
        sar edx, 10h
        mov eax, dword [byte eax+SCnum-2]
        sar eax, 10h
        call restorepl
        mov word [c2playernum], ax
        jmp short .20
.18:
        inc dl
        add eax, 80h
.19:
        cmp dl, 6
        jl short puckfaceoff.17
.20:
        call ReturnGoalies
        test byte [gameopts], 4
        jne short .21
        mov eax, hmtmstruct
        call setpersonel
        mov eax, awtmstruct
        call setpersonel
.21:
        mov byte [byte ebp+027h], 0FFh
        mov byte [byte ebp+029h], 0FFh
        test byte [gameopts], 4
        je near .27
        and byte [hmtmflags], 0FDh
        and byte [awtmflags], 0FDh
        mov eax, SortCords
        xor dl, dl
        jmp short .23
.22:
        and byte [byte eax+pflags2], 0F7h
        inc dl
        add eax, 80h
.23:
        cmp dl, 0Ch
        jl short puckfaceoff.22
        mov eax, dword [cont1team-2]
        sar eax, 10h
        mov edx, dword [cont2team-2]
        sar edx, 10h
        or eax, edx
        je short .24
        cmp word [SortPending], byte 0
        je short .24
        or byte [sflags], 40h
        call SprSortVert
        xor eax, eax
        mov word [SortPending], ax
.24:
        mov ax, word [c1playernum]
        mov word [regd0], ax
        test ax, ax
        jl short .25
        mov eax, dword [regd0-2]
        sar eax, 10h
        shl eax, 7
        mov edx, SortCords
        add edx, eax
        mov eax, ebp
        call StartFaceoffLineChange
.25:
        mov ax, word [c2playernum]
        mov word [regd0], ax
        test ax, ax
        jl short .26
        mov ax, word [cont2team]
        cmp ax, word [cont1team]
        je short .26
        mov eax, dword [regd0-2]
        sar eax, 10h
        shl eax, 7
        mov edx, SortCords
        add edx, eax
        mov eax, ebp
        call StartFaceoffLineChange
.26:
        mov dword [regd0], 2
        test byte [gameopts], 4
        je short .27
        mov ax, word [regd0]
        cmp ax, word [cont1team]
        je short .27
        cmp ax, word [cont2team]
        je short .27
        mov edx, awtmstruct
        mov eax, hmtmstruct
        call CompLine
        mov eax, awtmstruct
        call setpersonel
        mov eax, 1
        call PenShotStart
.27:
        xor dl, dl
.28:
        movsx ebx, dl
        mov ecx, ebx
        shl ecx, 2
        mov eax, dword [esp+ecx]
        cmp word [eax], byte 0
        jl near .31
        mov ax, word [byte eax+04h]
        mov word [regd1], ax
        mov eax, dword [regd1-2]
        sar eax, 10h
        shl eax, 7
        add eax, SortCords
        mov esi, ebx
        shl esi, 8
        mov dword [byte esp+08h], esi
        lea esi, [ebx+ebx]
        mov edi, hmtmstruct
        add edi, dword [byte esp+08h]
        test byte [byte eax+pflags2], 8
        jne short .29
        mov eax, dword [esp+ecx]
        mov byte [byte eax+01h], 0FFh
        xor eax, eax
        mov word [dword esi+lcblink], ax
        mov word [dword esi+lcboxon], ax
        jmp short .30
.29:
        mov eax, dword [esp+ecx]
        dec word [eax]
        mov eax, dword [esp+ecx]
        cmp word [eax], byte 0
        jge short .31
        mov eax, dword [regd1-2]
        sar eax, 10h
        shl eax, 7
        add eax, SortCords
        test byte [byte eax+pflags2], 8
        je short .31
        xor ecx, ecx
        mov word [regd2], cx
        call lcfound
        mov word [dword esi+lcblink], cx
        mov word [dword esi+lcboxon], cx
.30:
        mov eax, edi
        call setpersonel
        mov eax, ebx
        call PenShotStart
        mov eax, ebx
        call ForceStartLineup
.31:
        inc dl
        cmp dl, 2
        jne near puckfaceoff.28
        cmp word [byte ebp+temp1], byte 0
        jge near .34
        cmp word [byte ebp+temp2], byte 0
        jge near .34
        mov eax, 1
        mov word [regd0], ax
        test byte [gameopts], 4
        je short .32
        cmp ax, word [cont1team]
        je short .32
        cmp ax, word [cont2team]
        je short .32
        mov edx, hmtmstruct
        mov eax, awtmstruct
        call CompLine
        mov eax, hmtmstruct
        call setpersonel
        xor eax, eax
        call PenShotStart
.32:
        test byte [gameopts], 4
        jne short .33
        xor ecx, ecx
        mov word [awtmlcnt], cx
        mov word [awtmline], cx
        mov word [hmtmlcnt], cx
        mov word [hmtmline], cx
        xor edx, edx
        xor eax, eax
        call DrawPanelLine
        xor edx, edx
        mov eax, 1
        call DrawPanelLine
.33:
        mov edx, 1Ch
        mov eax, ebp
        call assreplace
        mov word [byte ebp+temp5], 3E8h
.34:
        add esp, byte 0Ch
        jmp near TakePlayerFromBox_ret6
;-----------------------------------------------------------------------------
; puckfaceoff2                       51BDB  94G logic94.asm, medium confidence
; Assignment table slot 1Ch: the puck while the faceoff is set up
;-----------------------------------------------------------------------------
puckfaceoff2:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov esi, eax
        test byte [byte eax+pflags], 2
        je near .64
        mov dx, word [byte esi+temp5]
        dec edx
        mov word [byte esi+temp5], dx
        test dx, dx
        jle near .2
        cmp dword [demoflag], byte 0
        jne short .2
        cmp dword [introskipped], byte 0
        jne short .2
        cmp word [injurystop], byte 0
        jne short .2
        cmp word [gsp], byte 0
        jne short .1
        cmp word [clockticks], byte 0
        jne short .1
        mov ax, word [gameclock]
        cmp ax, word [PerTimeTotal]
        je short .2
.1:
        cmp word [RefStep], byte 0
        jge near TakePlayerFromBox_ret6
        cmp word [ovltimer], byte 0
        jge near TakePlayerFromBox_ret6
        call AllInPlace
        test eax, eax
        je near TakePlayerFromBox_ret6
.2:
        and byte [byte esi+pflags], 0FDh
        cmp dword [introskipped], byte 0
        je short .3
        mov eax, dword [ovlseq-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        je short .3
        mov edi, dword [ovlartbank]
        push edi
        call FreeMemBlock
        add esp, byte 4
.3:
        xor ebp, ebp
        mov dword [penshotstart], ebp
        mov ax, word [joysampling]
        mov word [joysampling_save], ax
        mov dword [joysampling], ebp
        call FlushGSumQueue
        mov eax, dword [joysampling_save-2]
        sar eax, 10h
        mov dword [joysampling], eax
        mov edi, 0FFFFFFFFh
        mov word [bannermsg], di
        mov eax, edi
        mov word [ovlstep], di
        mov edx, edi
        mov word [ovlseq], di
        mov ebx, edi
        mov word [ovltimer], di
        xor ecx, ecx
        mov word [bannertimer], cx
        xor dh, ah
        mov byte [textline5], dh
        xor bl, al
        mov byte [textline4], bl
        xor bh, ah
        mov byte [textline2], bh
        xor cl, cl
        mov byte [textline1], cl
        xor ch, ch
        mov byte [textline3], ch
        cmp dword [demoflag], byte 0
        jne short .4
        cmp word [gsp], byte 0
        jne short .4
        mov ax, word [gameclock]
        cmp ax, word [PerTimeTotal]
        jne short .4
        cmp word [clockticks], byte 0
        jne short .4
        cmp dword [introskipped], byte 0
        jne short .4
        xor edx, edx
        mov word [fadeinpending], dx
        jmp short .7
.4:
        cmp dword [demoflag], byte 0
        jne short .5
        cmp dword [introskipped], byte 0
        jne short .5
        mov cx, word [injurystop]
        test cx, cx
        je short .6
.5:
        mov word [fadeinpending], 1
        jmp short .7
.6:
        mov word [fadeinpending], cx
.7:
        mov word [RefStep], 0FFFFh
        xor ebp, ebp
        mov dword [introskipped], ebp
        xor ecx, ecx
        mov word [injurystop], cx
        and byte [sflags], 0FEh
        and byte [sflags3], 0FEh
        xor dl, dl
        mov byte [iflags], dl
        xor edi, edi
        mov word [refsignal], di
        mov dh, 0FFh
        mov byte [puckcross+3], dh
        mov byte [puckcross+7], dh
        mov bh, byte [gmode2]
        and bh, 78h
        mov byte [gmode2], bh
        mov cl, bh
        or cl, 5
        mov byte [gmode2], cl
        mov word [passplayer], 0FFFFh
        call SprSortVert
        xor dh, dh
        mov word [SortPending], dx
        xor ebx, ebx
        mov word [camy], bx
        xor ecx, ecx
        mov word [camx], cx
        mov ax, word [fox]
        mov word [xc1], ax
        mov ax, word [foy]
        mov word [yc1], ax
        cmp word [xc1], byte 0
        jge short .8
        mov eax, dword [xc1-2]
        sar eax, 10h
        neg eax
        jmp short .9
.8:
        mov eax, dword [xc1-2]
        sar eax, 10h
.9:
        cmp eax, byte 20h
        jle short .12
        cmp word [fox], byte 0
        jle short .10
        mov eax, 20h
        jmp short .11
.10:
        mov eax, 0FFFFFFE0h
.11:
        mov word [xc1], ax
.12:
        mov eax, dword [yc1-2]
        sar eax, 10h
        cmp eax, 0FFFFFF44h
        jg short .13
        mov word [yc1], 0FF44h
        jmp short .14
.13:
        cmp word [yc1], 0ECh
        jl short .14
        mov word [yc1], 0ECh
.14:
        mov ax, word [xc1]
        mov word [camx], ax
        mov ax, word [yc1]
        mov word [camy], ax
        xor edi, edi
        mov word [yleader], di
        mov eax, dword [puckx]
        mov dx, word [fox]
        mov word [eax], dx
        mov eax, dword [pucky]
        mov dx, word [foy]
        mov word [eax], dx
        cmp dword [penshotmode], byte 0
        jne short .15
        mov eax, dword [puckz]
        mov word [eax], 0FF9Ch
        jmp short .16
.15:
        mov eax, dword [puckz]
        mov word [eax], di
.16:
        mov eax, dword [puckvx]
        mov word [eax], 0
        mov eax, dword [puckvy]
        mov word [eax], 0
        mov eax, dword [puckvz]
        mov word [eax], 0
        mov eax, dword [puckc]
        mov byte [eax], 0FFh
        xor eax, eax
        mov word [SortCords+60Ch], ax
        xor edx, edx
        mov word [SortCords+60Eh], ax
        mov word [SortCords+602h], ax
        mov word [SortCords+606h], 0ECh
        mov eax, SortCords+600h
        add eax, 80h
        mov word [byte eax+Xvel], dx
        mov word [byte eax+Yvel], dx
        mov word [byte eax+Xpos+2], dx
        mov word [byte eax+Ypos+2], 0FF14h
        mov word [RefPen], dx
        mov eax, 0FFFFFFFFh
        mov word [penaltysc], ax
        mov word [penevteam], ax
        mov ax, word [fox]
        mov word [ltx], ax
        mov ax, word [foy]
        mov word [lty], ax
        mov word [sortobj15+12h], 189h
        xor ecx, ecx
        mov word [sortobj15+38h], cx
        mov word [sortobj15+54h], cx
        mov word [puckstruct+54h], cx
        mov word [puckstruct+12h], 18Ah
        and byte [sflags], 0BFh
        call checkwindow
        cmp dword [penshotmode], byte 0
        je near .25
        call SprSort
        mov eax, dword [c1playernum-2]
        sar eax, 10h
        mov ebx, dword [penshotplayer]
        cmp eax, ebx
        je near .18
        mov edx, dword [c2playernum-2]
        sar edx, 10h
        cmp edx, ebx
        je short .18
        mov ebx, dword [penshotteam]
        inc ebx
        mov ecx, dword [cont1team-2]
        sar ecx, 10h
        cmp ecx, ebx
        jne short .17
        cmp eax, dword [penshotplayer]
        je short .18
        mov ebx, dword [penshotplayer-2]
        sar ebx, 10h
        mov edx, eax
        mov eax, ebx
        call restorepl
        mov word [c1playernum], ax
        jmp short .18
.17:
        mov eax, dword [cont2team-2]
        sar eax, 10h
        cmp eax, ebx
        jne short .18
        cmp edx, dword [penshotplayer]
        je short .18
        mov eax, dword [penshotplayer-2]
        sar eax, 10h
        call restorepl
        mov word [c2playernum], ax
.18:
        mov ebx, SortCords
        xor eax, eax
        jmp short .21
.19:
        cmp word [byte ebx+position], byte 0
        jne short .20
        test byte [byte ebx+pflags], 40h
        setne dl
        and edx, 0FFh
        xor edx, dword [penshotteam]
        jne short .22
.20:
        inc eax
        add ebx, 80h
.21:
        cmp ax, 0Ch
        jl short puckfaceoff2.19
.22:
        mov word [byte ebx+048h], 0
        mov word [byte ebx+04Ch], 0
        mov word [byte ebx+04Ah], 0
        mov byte [byte ebx+053h], 0
        and byte [byte ebx+pflags2], 0DBh
        and byte [byte ebx+pflags], 0FBh
        mov edi, dword [penshotteam]
        test edi, edi
        sete al
        and eax, 0FFh
        mov edx, dword [cont1team-2]
        sar edx, 10h
        inc eax
        cmp edx, eax
        jne short .23
        mov edx, dword [c1playernum-2]
        sar edx, 10h
        cmp edx, byte 0FFFFFFFFh
        je short .24
        mov eax, 0FFFFFFFFh
        call restorepl
        mov word [c1playernum], ax
        jmp short .24
.23:
        test edi, edi
        sete al
        and eax, 0FFh
        mov edx, dword [cont2team-2]
        sar edx, 10h
        inc eax
        cmp edx, eax
        jne short .24
        mov edx, dword [c2playernum-2]
        sar edx, 10h
        cmp edx, byte 0FFFFFFFFh
        je short .24
        mov eax, 0FFFFFFFFh
        call restorepl
        mov word [c2playernum], ax
.24:
        call CenterMouse
        call StopDigiSample
        and byte [gmode2], 0FAh
        and byte [gmode], 0FEh
        and byte [byte esi+pflags2], 0FEh
        or byte [sflags3], 10h
        and byte [byte esi+pflags], 0FBh
        mov edx, 18h
        mov eax, esi
        call assreplace
        call SetupPenaltyShot
        jmp near TakePlayerFromBox_ret6
.25:
        call ResetBench
        mov eax, hmtmstruct
        call setpersonel
        mov eax, hmtmstruct
        call forcepldata
        mov eax, awtmstruct
        call setpersonel
        mov eax, awtmstruct
        call forcepldata
        call resetplstuff
        mov ebx, SortCords
        mov word [regd2], 0Ch
.26:
        mov word [byte ebx+Xpos+2], 0FF10h
        mov word [byte ebx+Ypos+2], 0
        mov ax, word [byte ebx+position]
        mov word [regd1], ax
        mov eax, dword [byte ebx+temp5-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFF9Ch
        jne short .27
        mov word [byte ebx+temp5], 0
.27:
        mov di, word [regd1]
        test di, di
        jl near .56
        je short .30
        cmp di, byte 4
        jne short .28
        mov eax, dword [byte ebx+06Ch]
        movsx dx, byte [byte ebx+047h]
        mov word [byte eax+030h], dx
        mov byte [byte eax+033h], 0FFh
        mov byte [byte eax+035h], 0FFh
        and byte [byte eax+tmflags], 0F7h
        mov word [regd0], 17h
        jmp short .29
.28:
        mov word [regd0], 16h
.29:
        mov edx, dword [regd0-2]
        sar edx, 10h
        mov eax, ebx
        call assinsert
.30:
        mov eax, dword [byte ebx+06Ch]
        mov ax, word [byte eax+tmap]
        neg eax
        mov word [regd4], ax
        mov eax, dword [regd4-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFAh
        jle short .31
        mov eax, dword [byte ebx+06Ch]
        cmp word [byte eax+tmgoalie], byte 0
        jge short .31
        dec word [regd4]
.31:
        mov ax, word [regd4]
        add eax, 6
        shl eax, 3
        mov word [regd4], ax
        mov eax, dword [regd4-2]
        sar eax, 10h
        mov edx, dword [regd1-2]
        sar edx, 10h
        movsx ax, byte [dword edx+eax+apl]
        mov word [regd4], ax
        add eax, eax
        mov word [regd4], ax
        mov eax, dword [regd4-2]
        sar eax, 10h
        mov dx, word [nosplit eax*2+puckfaceoff2_ptab]
        mov word [regd0], dx
        mov ax, word [nosplit eax*2+puckfaceoff2_ptab_y]
        mov word [regd1], ax
        test byte [byte ebx+pflags], 80h
        jne short .32
        neg word [regd0]
        neg eax
        mov word [regd1], ax
.32:
        cmp word [byte ebx+position], byte 0
        je short .35
        cmp word [regd4], byte 4
        jg short .34
        mov edx, dword [fox-2]
        sar edx, 10h
        mov eax, dword [regd0-2]
        sar eax, 10h
        xor eax, edx
        test eax, eax
        jge short .33
        mov edx, dword [fox]
        sar edx, 13h
        mov eax, dword [regd1-2]
        sar eax, 10h
        sub eax, edx
        mov word [regd1], ax
.33:
        mov edx, dword [yleader]
        sar edx, 12h
        mov eax, dword [regd0-2]
        sar eax, 10h
        sub eax, edx
        mov word [regd0], ax
.34:
        mov ax, word [fox]
        add word [regd0], ax
        mov ax, word [foy]
        add word [regd1], ax
        jmp near .42
.35:
        cmp word [foy], byte 0
        jge short .36
        mov eax, dword [foy-2]
        sar eax, 10h
        neg eax
        jmp short .37
.36:
        mov eax, dword [foy-2]
        sar eax, 10h
.37:
        cmp eax, byte 27h
        jle near .42
        mov cl, byte [byte ebx+pflags]
        test cl, 80h
        sete al
        mov edx, eax
        and edx, 0FFh
        cmp word [foy], byte 0
        setl al
        and eax, 0FFh
        xor eax, edx
        je short .42
        test cl, 80h
        jne short .38
        mov eax, 27h
        jmp short .39
.38:
        mov eax, 0FFFFFFD9h
.39:
        mov edx, dword [foy-2]
        sar edx, 10h
        sub edx, eax
        mov eax, edx
        test dx, dx
        jge short .40
        movsx edx, dx
        neg edx
        jmp short .41
.40:
        movsx edx, dx
.41:
        mov eax, edx
        mov edx, dword [fox-2]
        sar edx, 10h
        cwde
        imul edx, eax
        mov eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, eax
        sar edx, 1Fh
        shl edx, 0Ch
        LD sbb, eax, edx
        sar eax, 0Ch
        add word [regd0], ax
.42:
        mov ax, word [regd0]
        mov word [byte ebx+Xpos+2], ax
        mov ax, word [regd1]
        mov word [byte ebx+Ypos+2], ax
        mov word [byte ebx+Xvel], 0
        mov word [byte ebx+Yvel], 0
        mov eax, dword [pucky]
        mov ax, word [eax]
        sub ax, word [regd1]
        movsx edx, ax
        mov eax, dword [puckx]
        mov ax, word [eax]
        sub ax, word [regd0]
        cwde
        call vtoa
        mov word [byte ebx+facedir], ax
        mov ax, word [byte ebx+position]
        test ax, ax
        jne near .49
        cmp byte [byte ebx+065h], 0
        je short .43
        mov edx, dword [byte ebx+facedir-2]
        sar edx, 10h
        jmp short .44
.43:
        mov edx, dword [byte ebx+facedir-2]
        sar edx, 10h
        mov eax, 8
        sub eax, edx
        mov edx, eax
        and edx, byte 7
.44:
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, 196h
        mov word [byte ebx+012h], ax
        mov word [regd1], 1
        mov cx, word [byte ebx+facedir]
        cmp cx, byte 2
        jne short .47
        test byte [byte ebx+pflags], 80h
        je short .45
        mov eax, 1
        jmp short .46
.45:
        mov eax, 3
.46:
        mov word [byte ebx+facedir], ax
        jmp near .55
.47:
        cmp cx, byte 6
        jne near .55
        test byte [byte ebx+pflags], 80h
        je short .48
        mov eax, 7
        jmp short puckfaceoff2.46
.48:
        mov eax, 5
        jmp short puckfaceoff2.46
.49:
        cmp ax, 4
        jne short .52
        cmp word [byte ebx+facedir], byte 0
        je short .50
        mov eax, 167h
        jmp short .51
.50:
        mov eax, 16Ch
.51:
        mov word [byte ebx+012h], ax
        xor eax, eax
        mov word [regd1], ax
        jmp short .55
.52:
        cmp byte [byte ebx+065h], 0
        je short .53
        mov edx, dword [byte ebx+facedir-2]
        sar edx, 10h
        jmp short .54
.53:
        mov eax, dword [byte ebx+facedir-2]
        sar eax, 10h
        mov edx, 8
        sub edx, eax
        and edx, byte 7
.54:
        mov eax, edx
        shl eax, 2
        add eax, edx
        mov word [byte ebx+012h], ax
        mov word [regd1], 289h
.55:
        and byte [byte ebx+pflags2], 0FBh
        and byte [byte ebx+pflags], 0DFh
        mov edx, dword [regd1-2]
        sar edx, 10h
        mov eax, ebx
        call SetSPA
.56:
        and byte [byte ebx+pflags2], 7Fh
        add ebx, 80h
        mov ax, word [regd2]
        dec ax
        mov word [regd2], ax
        jne near puckfaceoff2.26
        mov ebx, SortCords+800h
        mov cx, word [fox]
        test cx, cx
        jg short .57
        mov word [SortCords+836h], 2
        mov eax, ecx
        sub eax, byte 0Fh
        jmp short .58
.57:
        mov word [SortCords+836h], 6
        mov eax, ecx
        add eax, 0Fh
.58:
        mov word [SortCords+802h], ax
        mov ax, word [foy]
        mov word [byte ebx+Ypos+2], ax
        cmp word [byte ebx+facedir], byte 3
        jle short .59
        mov eax, 2C7h
        jmp short .60
.59:
        mov eax, 2BFh
.60:
        mov word [byte ebx+012h], ax
        mov edx, 1Eh
        mov eax, ebx
        call assinsert
        mov word [byte ebx+Xvel], 0
        mov word [byte ebx+Yvel], 0
        and byte [byte ebx+pflags], 0DFh
        mov edx, 0C57h
        mov eax, ebx
        call SetSPA
        call SprSort
        mov ebx, 0FFFFFFFFh
        mov word [c1playernum], bx
        mov word [c2playernum], bx
        cmp word [cont1team], byte 0
        je short .61
        xor eax, eax
        mov word [regd4], ax
        xor edx, edx
        mov eax, esi
        call changeplayer
.61:
        cmp word [cont2team], byte 0
        je short .62
        mov dword [regd4], 2
        mov edx, dword [regd4-2]
        sar edx, 10h
        mov eax, esi
        call changeplayer
.62:
        call CenterMouse
        mov eax, 78h
        call randomd0
        add eax, 0B4h
        mov word [byte esi+temp1], ax
        mov word [fofdata2], 1
        mov ecx, 8000h
        mov word [fofdata2_w2], cx
        mov word [fofdata2_w4], 4
        mov word [fofdata2_w6], 0A800h
        mov word [fofdata], 7
        mov word [fofdata_w2], cx
        test byte [gmode], 2
        jne short .63
        xor byte [fofdata2_b3], 8
        xor byte [fofdata2_b7], 8
.63:
        mov ebx, 0FFFFFFFFh
        mov word [fodir2], bx
        mov word [fodir1], bx
        jmp near TakePlayerFromBox_ret6
.64:
        mov dx, word [byte esi+temp1]
        dec edx
        mov word [byte esi+temp1], dx
        test dx, dx
        jl short .66
        cmp dx, byte 11h
        jne short .65
        mov edx, 0C43h
        mov eax, SortCords+800h
        call SetSPA
.65:
        cmp word [byte esi+temp1], byte 0
        je near TakePlayerFromBox_ret6
        mov eax, dword [byte esi+temp1-2]
        sar eax, 10h
        add eax, byte 6
        sar eax, 3
        mov word [regd0], ax
        cmp ax, 2
        jg near TakePlayerFromBox_ret6
        mov edx, 0Ah
        sub edx, eax
        mov word [fofdata], dx
        jmp near TakePlayerFromBox_ret6
.66:
        mov eax, esi
        call Endfaceoff
        jmp near TakePlayerFromBox_ret6
;-----------------------------------------------------------------------------
; assbenchwait                                    526ED  95 PC, low confidence
; Asstab 29h (after assleaveice, PenShotStart, setpersonel): clears +12h,
; check4bench; when on the bench sets +26h 64h / +2Eh 0
;-----------------------------------------------------------------------------
; C: src/engine/faceoff/assbenchwait.c
%ifdef CBUILD
%include "c/engine/faceoff/assbenchwait.inc"
%else
assbenchwait:
        push dword 8
        call __CHK
        push edx
        mov edx, eax
        test byte [byte eax+044h], 20h
        jne short .x
        mov word [byte edx+012h], 0FFFFh
        mov eax, edx
        call check4bench
        test ax, ax
        je short .x
        mov word [byte edx+026h], 64h
        mov word [byte edx+02Eh], 0
.x:
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; asstakeposition                                 52720  95 PC, low confidence
; Asstab 27h (assintrostand, assbench, PenShotStart/Assign): goalie -> 0Dh;
; else skates to the position slot from apl by position and team tmap, exits
;
; when done
;-----------------------------------------------------------------------------
; C: src/engine/faceoff/TakePlayerFromBox.c (asstakeposition)
%ifdef CBUILD
%include "c/engine/faceoff/TakePlayerFromBox.asstakeposition.inc"
%else
asstakeposition:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ebx, eax
        cmp word [byte eax+position], byte 0
        jge short .1
        mov edx, 0Dh
        call assreplace
        mov word [byte ebx+temp5], 0FF9Ch
        or byte [byte ebx+pflags2], 4
.1:
        test byte [byte ebx+pflags], 20h
        jne near TakePlayerFromBox_ret5
        mov eax, ebx
        call check4bench
        test ax, ax
        jne near TakePlayerFromBox_ret5
        mov eax, dword [byte ebx+temp5-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFF9Ch
        jne short .3
        mov eax, ebx
        call assexit
        mov eax, dword [byte ebx+assnum-2]
        sar eax, 10h
        add eax, ebx
        mov dl, byte [byte eax+01Eh]
        cmp dl, 7
        je short .2
        cmp dl, 28h
        jne near TakePlayerFromBox_ret5
.2:
        mov eax, ebx
        call assexit
        jmp near TakePlayerFromBox_ret5
.3:
        mov dh, byte [byte ebx+pflags]
        test dh, 2
        je near .21
        mov cl, dh
        and cl, 0FDh
        mov byte [byte ebx+pflags], cl
        mov word [byte ebx+temp2], 8
        mov word [byte ebx+temp1], 0
        mov ax, word [byte ebx+position]
        mov word [regd1], ax
        mov eax, dword [byte ebx+06Ch]
        mov ax, word [byte eax+tmap]
        neg eax
        mov word [regd4], ax
        mov eax, dword [regd4-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFAh
        jle short .4
        mov eax, dword [byte ebx+06Ch]
        cmp word [byte eax+tmgoalie], byte 0
        jge short .4
        dec word [regd4]
.4:
        mov ax, word [regd4]
        add eax, 6
        shl eax, 3
        mov word [regd4], ax
        mov edx, dword [regd4-2]
        sar edx, 10h
        mov eax, dword [regd1-2]
        sar eax, 10h
        movsx ax, byte [dword edx+eax+apl]
        mov word [regd4], ax
        add eax, eax
        mov word [regd4], ax
        mov eax, dword [regd4-2]
        sar eax, 10h
        mov dx, word [nosplit eax*2+puckfaceoff2_ptab]
        mov word [regd0], dx
        mov ax, word [nosplit eax*2+puckfaceoff2_ptab_y]
        mov word [regd1], ax
        test byte [byte ebx+pflags], 80h
        jne short .5
        mov edi, edx
        neg edi
        mov word [regd0], di
        neg eax
        mov word [regd1], ax
.5:
        cmp word [byte ebx+position], byte 0
        je short .8
        cmp word [regd4], byte 4
        jg short .7
        mov edx, dword [fox-2]
        sar edx, 10h
        mov eax, dword [regd0-2]
        sar eax, 10h
        xor eax, edx
        test eax, eax
        jge short .6
        mov edx, dword [fox]
        sar edx, 13h
        mov eax, dword [regd1-2]
        sar eax, 10h
        sub eax, edx
        mov word [regd1], ax
.6:
        mov edx, dword [yleader]
        sar edx, 12h
        mov eax, dword [regd0-2]
        sar eax, 10h
        sub eax, edx
        mov word [regd0], ax
.7:
        mov ax, word [fox]
        add word [regd0], ax
        mov ax, word [foy]
        add word [regd1], ax
        jmp near .15
.8:
        cmp word [foy], byte 0
        jge short .9
        mov eax, dword [foy-2]
        sar eax, 10h
        neg eax
        jmp short .10
.9:
        mov eax, dword [foy-2]
        sar eax, 10h
.10:
        cmp eax, byte 27h
        jle near .15
        test byte [byte ebx+pflags], 80h
        sete al
        mov edx, eax
        and edx, 0FFh
        cmp word [foy], byte 0
        setl al
        and eax, 0FFh
        xor eax, edx
        je short .15
        test byte [byte ebx+pflags], 80h
        jne short .11
        mov eax, 27h
        jmp short .12
.11:
        mov eax, 0FFFFFFD9h
.12:
        mov edx, dword [foy-2]
        sar edx, 10h
        sub edx, eax
        mov eax, edx
        test dx, dx
        jge short .13
        movsx edx, dx
        neg edx
        jmp short .14
.13:
        movsx edx, dx
.14:
        mov eax, edx
        mov edx, dword [fox-2]
        sar edx, 10h
        cwde
        imul edx, eax
        mov eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, eax
        sar edx, 1Fh
        shl edx, 0Ch
        LD sbb, eax, edx
        sar eax, 0Ch
        add word [regd0], ax
.15:
        cmp dword [penshotmode], byte 0
        je short .18
        mov eax, dword [byte ebx+SCnum-2]
        sar eax, 10h
        cmp eax, dword [penshotplayer]
        jne short .18
        xor esi, esi
        mov word [regd0], si
        test byte [byte ebx+pflags], 80h
        je short .16
        mov eax, 0FFFFFFF6h
        jmp short .17
.16:
        mov eax, 0Ah
.17:
        mov word [regd1], ax
.18:
        mov ax, word [regd0]
        mov word [byte ebx+temp3], ax
        mov ax, word [regd1]
        mov word [byte ebx+temp4], ax
        or byte [byte ebx+pflags2], 20h
        mov word [byte ebx+Wallcos], 0
        mov word [byte ebx+Wallsin], 0
        cmp word [byte ebx+position], byte 0
        jne short .19
        mov eax, 99h
        jmp short .20
.19:
        mov eax, 289h
.20:
        movsx edx, ax
        mov eax, ebx
        call SetSPA
.21:
        mov eax, dword [ebx]
        sar eax, 10h
        mov edx, dword [byte ebx+temp3-2]
        sar edx, 10h
        sub eax, edx
        mov edx, eax
        mov ecx, dword [byte ebx+Ypos]
        sar ecx, 10h
        mov eax, dword [byte ebx+temp4-2]
        sar eax, 10h
        sub ecx, eax
        mov eax, ecx
        imul edx, edx
        imul eax, ecx
        add edx, eax
        cmp edx, byte 40h
        jge near .36
        cmp word [byte ebx+Xvel], byte 0
        jge short .22
        mov eax, dword [byte ebx+Xvel-2]
        sar eax, 10h
        neg eax
        jmp short .23
.22:
        mov eax, dword [byte ebx+Xvel-2]
        sar eax, 10h
.23:
        cmp eax, byte 10h
        jge near .36
        cmp word [byte ebx+Yvel], byte 0
        jge short .24
        mov eax, dword [byte ebx+Yvel-2]
        sar eax, 10h
        neg eax
        jmp short .25
.24:
        mov eax, dword [byte ebx+Yvel-2]
        sar eax, 10h
.25:
        cmp eax, byte 10h
        jge near .36
        mov ax, word [byte ebx+temp3]
        mov word [byte ebx+Xpos+2], ax
        mov ax, word [byte ebx+temp4]
        mov word [byte ebx+Ypos+2], ax
        mov si, word [byte ebx+temp1]
        dec esi
        mov word [byte ebx+temp1], si
        test si, si
        jge near TakePlayerFromBox_ret5
        mov eax, esi
        add eax, 8
        mov word [byte ebx+temp1], ax
        cmp word [byte ebx+position], byte 0
        jne short .26
        mov eax, 99h
        jmp short .27
.26:
        mov eax, 289h
.27:
        movsx edx, ax
        mov eax, ebx
        call SetSPA
        mov ax, word [foy]
        sub ax, word [byte ebx+Ypos+2]
        movsx edx, ax
        mov ax, word [fox]
        sub ax, word [byte ebx+Xpos+2]
        cwde
        call vtoa
        cwde
        mov dword [regd2], eax
        cmp word [byte ebx+position], byte 0
        jne short .32
        mov ax, word [regd2]
        cmp ax, 2
        jne short .29
        test byte [byte ebx+pflags], 80h
        je short .28
        mov eax, 1
        jmp short .31
.28:
        mov eax, 3
        jmp short .31
.29:
        cmp ax, 6
        jne short .32
        test byte [byte ebx+pflags], 80h
        je short .30
        mov eax, 7
        jmp short .31
.30:
        mov eax, 5
.31:
        mov word [regd2], ax
.32:
        mov ax, word [regd2]
        mov cx, word [byte ebx+facedir]
        cmp ax, cx
        je short .35
        sub eax, ecx
        xor ah, ah
        and al, 7
        mov word [regd2], ax
        cmp ax, 5
        jge short .33
        mov eax, 1
        jmp short .34
.33:
        mov eax, 0FFFFFFFFh
.34:
        mov edx, dword [byte ebx+facedir-2]
        sar edx, 10h
        add eax, edx
        and eax, byte 7
        mov word [byte ebx+facedir], ax
        jmp near TakePlayerFromBox_ret5
.35:
        mov word [byte ebx+Yvel], 0
        mov ax, word [byte ebx+Yvel]
        mov word [byte ebx+Xvel], ax
        mov word [byte ebx+temp5], 0FF9Ch
        jmp near TakePlayerFromBox_ret5
.36:
        mov ax, word [byte ebx+temp3]
        mov word [regd0], ax
        mov ax, word [byte ebx+temp4]
        mov word [regd1], ax
        cmp edx, 190h
        jl short .37
        xor edx, edx
        mov eax, ebx
        call skateto
        jmp near TakePlayerFromBox_ret5
.37:
        xor edx, edx
        mov eax, ebx
        call SkateToSpot
        jmp near TakePlayerFromBox_ret5
%endif ; C
;-----------------------------------------------------------------------------
; check4bench                                           52BB6  94G logic94.asm
; 0 when p should stay, 1 when a line change was applied. A joystick player
; (pflags bit 3) stays while the clock runs. pflags2 bit 4 stays. The
;
; penalty-shot player stays, and so does an assignment of 7 or 9 once a
; penalty shot has started. No pending change (newpos and newpnum both
; negative) stays. At the start of a period, assignment 27h on the same spot
;
; stays, and assignment 29h stays while that team's line-change box is on. A
; different player, or the same player on 29h or 2Dh during a penalty shot,
; goes to the bench (assignment 0Bh) unless that is already the assignment or
;
; p has the puck: pflags2 bit 2 is set, pflags bit 2 is cleared, temp1 is
; cleared, and temp5 is cleared while the clock is stopped. Otherwise the
; change is taken. pflags2 bit 2 and pflags bit 2 are cleared. A non-negative
;
; newpos is copied to position when (pnum < 19h) differs from (newpos == 0).
; Setplass runs. While the clock is stopped and the period is not just
; starting, temp5 is cleared and assignment 28h (a positive position with the
;
; line-change box on) or 27h is inserted. newpnum and newpos become -1.
;-----------------------------------------------------------------------------
; C: src/engine/faceoff/check4bench.c
%ifdef CBUILD
%include "c/engine/faceoff/check4bench.inc"
%else
check4bench:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov ebx, eax
        test byte [gmode], 1
        jne short .1
        test byte [byte ebx+pflags], 8
        jne short .2
.1:
        test byte [byte ebx+pflags2], 10h
        je short .3
.2:
        xor eax, eax
        pop edx
        pop ecx
        pop ebx
        ret
.3:
        mov eax, dword [byte ebx+SCnum-2]
        sar eax, 10h
        mov edx, dword [penshotplayer]
        cmp eax, edx
        jne short .5
.4:
        xor eax, edx
        pop edx
        pop ecx
        pop ebx
        ret
.5:
        cmp dword [penshotstart], byte 0
        je short .6
        mov eax, dword [byte ebx+assnum-2]
        sar eax, 10h
        add eax, ebx
        mov cl, byte [byte eax+01Eh]
        cmp cl, 7
        je short check4bench.2
        cmp cl, 9
        je short check4bench.2
.6:
        cmp byte [byte ebx+newpos], 0
        jge short .7
        cmp byte [byte ebx+newpnum], 0
        jl short check4bench.2
.7:
        mov ax, word [gameclock]
        cmp ax, word [PerTimeTotal]
        jne short .9
        cmp word [clockticks], byte 0
        jne short .9
        movsx ax, byte [byte ebx+newpos]
        cmp ax, word [byte ebx+position]
        jne short .8
        mov al, byte [byte ebx+newpnum]
        cmp al, byte [byte ebx+047h]
        jne short .8
        mov eax, dword [byte ebx+assnum-2]
        sar eax, 10h
        cmp byte [byte ebx+eax+01Eh], 27h
        je short check4bench.2
.8:
        test byte [byte ebx+pflags], 40h
        setne al
        and eax, 0FFh
        cmp word [nosplit eax*2+lcboxon], byte 0
        je short .9
        mov eax, dword [byte ebx+assnum-2]
        sar eax, 10h
        cmp byte [byte ebx+eax+01Eh], 29h
        je near check4bench.2
.9:
        mov al, byte [byte ebx+newpnum]
        cmp al, byte [byte ebx+047h]
        jne short .10
        cmp dword [penshotstart], byte 0
        je short .12
        mov eax, dword [byte ebx+assnum-2]
        sar eax, 10h
        add eax, ebx
        mov dl, byte [byte eax+01Eh]
        cmp dl, 29h
        je short .10
        cmp dl, 2Dh
        jne short .12
.10:
        mov eax, dword [byte ebx+assnum-2]
        sar eax, 10h
        cmp byte [byte ebx+eax+01Eh], 0Bh
        je near check4bench.2
        mov eax, dword [puckc]
        movsx ax, byte [eax]
        mov dx, word [byte ebx+SCnum]
        cmp ax, dx
        je near check4bench.4
        or byte [byte ebx+pflags2], 4
        and byte [byte ebx+pflags], 0FBh
        mov word [byte ebx+temp1], 0
        test byte [gmode], 1
        je short .11
        mov word [byte ebx+temp5], 0
.11:
        mov edx, 0Bh
        mov eax, ebx
        call assreplace
        jmp near .20
.12:
        and byte [byte ebx+pflags2], 0FBh
        and byte [byte ebx+pflags], 0FBh
        cmp byte [byte ebx+newpos], 0
        jl short .13
        cmp byte [byte ebx+047h], 19h
        setl al
        mov edx, eax
        and edx, 0FFh
        mov cl, byte [byte ebx+newpos]
        test cl, cl
        sete al
        and eax, 0FFh
        xor eax, edx
        je short .13
        movsx ax, cl
        mov word [byte ebx+position], ax
.13:
        mov eax, ebx
        call Setplass
        test byte [gmode], 1
        je short .19
        mov ax, word [gameclock]
        cmp ax, word [PerTimeTotal]
        jne short .14
        cmp word [clockticks], byte 0
        je short .15
.14:
        mov eax, 1
        jmp short .16
.15:
        xor eax, eax
.16:
        test eax, eax
        je short .19
        mov word [byte ebx+temp5], 0
        cmp word [byte ebx+position], byte 0
        jle short .17
        test byte [byte ebx+pflags], 40h
        setne al
        and eax, 0FFh
        cmp word [nosplit eax*2+lcboxon], byte 0
        je short .17
        mov edx, 28h
        jmp short .18
.17:
        mov edx, 27h
.18:
        mov eax, ebx
        call assinsert
.19:
        mov byte [byte ebx+newpnum], 0FFh
        mov byte [byte ebx+newpos], 0FFh
.20:
        mov eax, 1
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; asspsclear                                   52DB0  95 PC, medium confidence
; Asstab slot 2Dh, penalty shot (penshotmode): skaters skate to a spot by the
; side boards (x -A8h, y -32h/41h +-random) and stop facing the play
;
; (SPA 289h; 7BFh / 0D2Dh)
;-----------------------------------------------------------------------------
; C: src/engine/faceoff/asspsclear.c
%ifdef CBUILD
%include "c/engine/faceoff/asspsclear.inc"
%else
asspsclear:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov ebx, eax
        test byte [byte eax+044h], 20h
        jne near .x
        cmp word [byte ebx+temp1], byte 64h
        je near .17
        cmp dword [penshotmode], byte 0
        je near .x
        mov dl, byte [byte ebx+pflags]
        test dl, 2
        je short .3
        mov dh, dl
        and dh, 0FDh
        mov byte [byte ebx+pflags], dh
        mov word [byte ebx+temp2], 8
        test byte [byte ebx+pflags], 40h
        jne short .1
        mov edx, 0FFFFFFCEh
        jmp short .2
.1:
        mov edx, 41h
.2:
        mov word [byte ebx+temp4], dx
        mov eax, 4
        call randomd0
        mov edx, 2
        sub edx, eax
        imul eax, edx, byte 0Fh
        add word [byte ebx+temp4], ax
        mov word [byte ebx+temp3], 0FF58h
        mov word [byte ebx+temp1], 0
        mov word [byte ebx+temp5], 0
        mov byte [byte ebx+newpos], 0FFh
        mov al, byte [byte ebx+newpos]
        mov byte [byte ebx+newpnum], al
.3:
        mov si, word [byte ebx+temp1]
        dec esi
        mov word [byte ebx+temp1], si
        test si, si
        jge near .13
        mov eax, esi
        add eax, 8
        mov word [byte ebx+temp1], ax
        mov ax, word [byte ebx+Ypos+2]
        sub ax, word [byte ebx+temp4]
        mov dx, word [byte ebx+Xpos+2]
        mov cx, word [byte ebx+temp3]
        sub edx, ecx
        mov word [regd0], dx
        test ax, ax
        jge short .4
        movsx edx, ax
        neg edx
        jmp short .5
.4:
        movsx edx, ax
.5:
        cmp edx, byte 28h
        jg near .13
        cmp word [regd0], byte 20h
        jg near .13
        cmp word [byte ebx+position], byte 0
        jne short .6
        mov edx, 1
        jmp short .7
.6:
        mov edx, 289h
.7:
        mov word [regd1], dx
        mov edx, dword [regd1-2]
        sar edx, 10h
        mov eax, ebx
        call SetSPA
        or byte [byte ebx+pflags], 4
        mov dx, word [byte ebx+facedir]
        cmp dx, byte 4
        je short .10
        jge short .8
        mov edx, 1
        jmp short .9
.8:
        mov edx, 0FFFFFFFFh
.9:
        mov eax, dword [byte ebx+facedir-2]
        sar eax, 10h
        add eax, edx
        and eax, byte 7
        mov word [byte ebx+facedir], ax
.10:
        mov word [byte ebx+Yvel], 0
        mov word [byte ebx+Xvel], 0F800h
        cmp word [regd0], byte 10h
        jg near .x
        mov word [byte ebx+Xvel], 0
        cmp word [byte ebx+facedir], byte 4
        jne near .x
        mov word [byte ebx+Xvel], 0F800h
        mov word [byte ebx+facedir], 2
        cmp word [byte ebx+position], byte 0
        jne short .11
        mov edx, 0D2Dh
        jmp short .12
.11:
        mov edx, 7BFh
.12:
        movsx edx, dx
        mov eax, ebx
        call SetSPA
        or byte [byte ebx+pflags], 20h
        or byte [byte ebx+pflags2], 4
        mov word [byte ebx+temp5], 0FF9Ch
        mov word [byte ebx+temp1], 64h
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.13:
        test byte [byte ebx+pflags], 4
        jne short .x
        mov ax, word [byte ebx+temp3]
        mov word [regd0], ax
        mov ax, word [byte ebx+temp4]
        mov word [regd1], ax
        test byte [gmode], 1
        jne short .14
        cmp word [byte ebx+position], byte 0
        jne short .15
.14:
        xor edx, edx
        jmp short .16
.15:
        mov edx, EvadePC
.16:
        mov eax, ebx
        call skateto
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.17:
        mov word [byte ebx+012h], 0FFFFh
        mov word [byte ebx+Xpos+2], 0FF58h
.x:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assrefpenshot                                52FB0  95 PC, medium confidence
; Asstab 2Ch (assrefdrop in penshotmode): places the puck at centre (puckc
; 10h), waits for penshotplayer, then drops it; with no shooter goes to 21h
;-----------------------------------------------------------------------------
; C: src/engine/faceoff/assrefpenshot.c
%ifdef CBUILD
%include "c/engine/faceoff/assrefpenshot.inc"
%else
assrefpenshot:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov ebx, eax
        test byte [byte eax+044h], 20h
        jne near .x
        mov dl, byte [byte ebx+pflags]
        test dl, 2
        je near .1
        mov dh, dl
        and dh, 0FDh
        mov byte [byte ebx+pflags], dh
        mov word [byte ebx+temp2], 8
        mov byte [byte ebx+026h], 0
        mov ax, word [byte ebx+Ypos+2]
        neg eax
        movsx edx, ax
        mov ax, word [byte ebx+Xpos+2]
        neg eax
        cwde
        call vtoa
        mov byte [byte ebx+027h], al
        mov word [byte ebx+temp3], 0
        mov word [byte ebx+temp4], 0
        mov word [byte ebx+temp5], 0
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
.1:
        cmp dword [penshotplayer], byte 0FFFFFFFFh
        jne short .2
        mov edx, 21h
        mov eax, ebx
        call assreplace
        pop edx
        pop ecx
        pop ebx
        ret
.2:
        mov dx, word [byte ebx+temp5]
        cmp dx, byte 64h
        je near .x
        cmp dx, byte 1
        jne short .3
        mov eax, dword [puckc]
        mov byte [eax], 0FFh
        mov eax, dword [puckvz]
        mov word [eax], 0
        mov dx, word [eax]
        mov eax, dword [puckvy]
        mov word [eax], dx
        mov eax, dword [puckvx]
        mov word [eax], dx
        mov eax, dword [puckz]
        mov word [eax], dx
        mov eax, dword [pucky]
        mov word [eax], dx
        mov eax, dword [puckx]
        mov word [eax], dx
        inc word [byte ebx+temp5]
.3:
        mov edx, dword [ebx]
        sar edx, 10h
        mov eax, dword [byte ebx+temp3-2]
        sar eax, 10h
        sub edx, eax
        mov eax, edx
        mov ecx, dword [byte ebx+Ypos]
        sar ecx, 10h
        mov edx, dword [byte ebx+temp4-2]
        sar edx, 10h
        sub ecx, edx
        mov edx, ecx
        imul eax, eax
        imul edx, ecx
        add eax, edx
        cmp eax, byte 40h
        jge near .16
        cmp word [byte ebx+Xvel], byte 0
        jge short .4
        mov eax, dword [byte ebx+Xvel-2]
        sar eax, 10h
        neg eax
        jmp short .5
.4:
        mov eax, dword [byte ebx+Xvel-2]
        sar eax, 10h
.5:
        cmp eax, byte 10h
        jge near .16
        cmp word [byte ebx+Yvel], byte 0
        jge short .6
        mov eax, dword [byte ebx+Yvel-2]
        sar eax, 10h
        neg eax
        jmp short .7
.6:
        mov eax, dword [byte ebx+Yvel-2]
        sar eax, 10h
.7:
        cmp eax, byte 10h
        jge near .16
        cmp word [byte ebx+temp5], byte 0
        je short .8
        mov ax, word [byte ebx+temp3]
        mov word [byte ebx+Xpos+2], ax
        mov ax, word [byte ebx+temp4]
        mov word [byte ebx+Ypos+2], ax
        mov dword [regd2], 6
        jmp short .9
.8:
        mov eax, dword [byte ebx+024h]
        sar eax, 18h
        mov dword [regd2], eax
.9:
        mov ch, byte [byte ebx+026h]
        dec ch
        mov byte [byte ebx+026h], ch
        test ch, ch
        jge near .x
        mov ah, ch
        add ah, 8
        mov byte [byte ebx+026h], ah
        mov edx, 0A5Bh
        mov eax, ebx
        call SetSPA
        mov ax, word [regd2]
        mov cx, word [byte ebx+facedir]
        cmp ax, cx
        je short .12
        sub eax, ecx
        xor ah, ah
        and al, 7
        mov word [regd2], ax
        cmp ax, 5
        jge short .10
        mov eax, 1
        jmp short .11
.10:
        mov eax, 0FFFFFFFFh
.11:
        mov edx, dword [byte ebx+facedir-2]
        sar edx, 10h
        add eax, edx
        and eax, byte 7
        mov word [byte ebx+facedir], ax
        pop edx
        pop ecx
        pop ebx
        ret
.12:
        mov word [byte ebx+Yvel], 0
        mov ax, word [byte ebx+Yvel]
        mov word [byte ebx+Xvel], ax
        cmp word [byte ebx+temp5], byte 0
        jne short .15
        or byte [byte ebx+pflags], 20h
        mov edx, 0C03h
        mov eax, ebx
        call SetSPA
        mov word [byte ebx+temp3], 96h
        test byte [gmode], 2
        sete al
        and eax, 0FFh
        xor eax, dword [penshotteam]
        je short .13
        mov eax, 0FFFFFFF6h
        jmp short .14
.13:
        mov eax, 0Ah
.14:
        mov word [byte ebx+temp4], ax
        inc word [byte ebx+temp5]
        xor edx, edx
        mov word [RefStep], dx
        and byte [sflags], 0BFh
        pop edx
        pop ecx
        pop ebx
        ret
.15:
        call PaSpeechBusy
        test eax, eax
        jne short .x
        mov eax, dword [ovlseq-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        jne short .x
        call AllInPlace
        test eax, eax
        je short .x
        mov word [RefStep], 0FFFFh
        mov eax, 0A4h
        call sfx
        mov word [byte ebx+temp5], 64h
        pop edx
        pop ecx
        pop ebx
        ret
.16:
        mov ax, word [byte ebx+temp3]
        mov word [regd0], ax
        mov ax, word [byte ebx+temp4]
        mov word [regd1], ax
        xor edx, edx
        mov eax, ebx
        call SkateToSpot
.x:
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
