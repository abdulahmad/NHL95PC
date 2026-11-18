; Net collisions, falls, body and hold checks.
bits 32
%include "hockey.inc"
%include "spa.inc"
section s_5601D progbits alloc exec nowrite align=1
extern __CHK, AddPenalty, AddPenalty2, assexit, c1playernum, CanRemovePlayer, checkagr, collflag
extern Crowdlevel, CwdExciteLvl, FallDown_pinxl, FallDown_pinxl2, FallDown_pinxr, FallDown_pinxr2, FallDown_pinyb, FallDown_pinyt
extern gameopts, gmode, newcheck, PassLaneChk_ret5, PBnum, PenBuf, penshotctl, penshotplayer
extern puckc, QuickShotChk, randomd0, SetBoxDoorObject, setInjuryType, SetSPA, sflags, sfx
extern Stop4Pen, vecdist, vtoa
global NetCollide, FallDown, Bcheck, holdcheck
;-----------------------------------------------------------------------------
; NetCollide                                      5601D  95 PC, low confidence
; Player near a net (x +-60h, y +-0CAh): when inside the frame snaps the
; player to the net edge for his facing
;
; (FallDown_pinxl / CCBEC / CCBFC offset tables), stops him and returns the
; bump animation (0F0Fh / 0F55h / 0FE1h)
;-----------------------------------------------------------------------------
NetCollide:
        push dword 2Ch
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 0Ch
        mov esi, eax
        mov ebp, edx
        cmp word [byte eax+02h], byte 0
        jl short .1
        mov eax, 60h
        jmp short .2
.1:
        mov eax, 0FFFFFFA0h
.2:
        mov dword [byte esp+08h], eax
        mov edx, dword [esi]
        sar edx, 10h
        sub edx, eax
        mov dword [esp], edx
        cmp word [byte esi+Ypos+2], byte 0
        jl short .3
        mov eax, 0CAh
        jmp short .4
.3:
        mov eax, 0FFFFFF36h
.4:
        mov edi, eax
        mov edx, dword [byte esi+Ypos]
        sar edx, 10h
        sub edx, eax
        mov dword [byte esp+04h], edx
        push edx
        mov ebx, dword [byte esp+04h]
        push ebx
        call vecdist
        mov ecx, eax
        add esp, byte 8
        cmp eax, byte 18h
        jl near .24
        mov edx, dword [esp]
        shl edx, 8
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov ebx, eax
        sar ebx, 2
        mov edx, dword [byte esp+04h]
        shl edx, 8
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        sar eax, 2
        test eax, eax
        jge short .5
        mov ecx, eax
        neg ecx
        jmp short .6
.5:
        mov ecx, eax
.6:
        test ebx, ebx
        jge short .7
        mov edx, ebx
        neg edx
        jmp short .8
.7:
        mov edx, ebx
.8:
        cmp ecx, edx
        jl near .12
        test edi, edi
        jl near .11
        add ebp, byte 2
        and ebp, byte 7
        cmp ebp, byte 5
        jl near .24
        mov edx, dword [byte esp+08h]
        add edx, ebx
        mov word [byte esi+Xpos+2], dx
        cmp dword [byte esp+08h], byte 0
        jge short .9
        test byte [byte esi+055h], 8
        sete dl
        and edx, 0FFh
        je short .9
        add word [byte esi+Xpos+2], byte 6
.9:
        cmp dword [byte esp+08h], byte 0
        jle short .10
        test byte [byte esi+055h], 8
        je short .10
        sub word [byte esi+Xpos+2], byte 6
.10:
        add eax, edi
        sub eax, byte 8
        mov word [byte esi+Ypos+2], ax
        mov word [byte esi+Xvel], 0
        mov word [byte esi+Yvel], 0
        mov eax, dword [byte esi+facedir-2]
        sar eax, 10h
        mov ax, word [nosplit eax*2+FallDown_pinyt]
        db 081h,0E8h,08h,01h,00h,00h            ; insn: sub eax,108h
        add word [byte esi+Ypos+2], ax
        mov eax, SPAboardback
        jmp near .25
.11:
        inc ebp
        and ebp, byte 7
        cmp ebp, byte 3
        jge near .24
        mov edx, dword [byte esp+08h]
        add edx, ebx
        mov word [byte esi+Xpos+2], dx
        add eax, edi
        mov word [byte esi+Ypos+2], ax
        mov word [byte esi+Xvel], 0
        mov word [byte esi+Yvel], 0
        mov eax, dword [byte esi+facedir-2]
        sar eax, 10h
        mov ax, word [nosplit eax*2+FallDown_pinyb]
        add eax, 108h
        add word [byte esi+Ypos+2], ax
        mov eax, SPAboardfront
        jmp near .25
.12:
        cmp dword [byte esp+08h], byte 0
        jl near .18
        cmp ebp, byte 5
        jl near .24
        sub ebx, byte 6
        mov edx, dword [byte esp+08h]
        add edx, ebx
        mov word [byte esi+Xpos+2], dx
        test edi, edi
        jle short .13
        mov edx, 0FFFFFFF6h
        jmp short .14
.13:
        xor edx, edx
.14:
        add eax, edi
        add eax, edx
        mov word [byte esi+Ypos+2], ax
        mov word [byte esi+Xvel], 0
        mov word [byte esi+Yvel], 0
        test byte [byte esi+055h], 8
        je short .15
        mov eax, dword [byte esi+facedir-2]
        sar eax, 10h
        mov edx, 8
        sub edx, eax
        mov eax, edx
        and eax, byte 7
        mov ax, word [nosplit eax*2+FallDown_pinxl]
        add eax, 9Ah
        sub word [byte esi+Xpos+2], ax
        jmp short .16
.15:
        mov eax, dword [byte esi+facedir-2]
        sar eax, 10h
        mov ax, word [nosplit eax*2+FallDown_pinxr]
        db 081h,0E8h,09Ah,00h,00h,00h           ; insn: sub eax,9Ah
        add word [byte esi+Xpos+2], ax
.16:
        test byte [byte esi+055h], 8
        jne near .23
.17:
        mov eax, SPAboardright
        jmp near .25
.18:
        test ebp, ebp
        je near .24
        dec ebp
        cmp ebp, byte 3
        jge near .24
        add ebx, byte 6
        mov edx, dword [byte esp+08h]
        add edx, ebx
        mov word [byte esi+Xpos+2], dx
        test edi, edi
        jle short .19
        mov edx, 0FFFFFFF6h
        jmp short .20
.19:
        xor edx, edx
.20:
        add eax, edi
        add eax, edx
        mov word [byte esi+Ypos+2], ax
        mov word [byte esi+Xvel], 0
        mov word [byte esi+Yvel], 0
        test byte [byte esi+055h], 8
        je short .21
        mov eax, dword [byte esi+facedir-2]
        sar eax, 10h
        mov edx, 8
        sub edx, eax
        mov eax, edx
        and eax, byte 7
        mov ax, word [nosplit eax*2+FallDown_pinxr]
        db 081h,0E8h,09Ah,00h,00h,00h           ; insn: sub eax,9Ah
        sub word [byte esi+Xpos+2], ax
        jmp short .22
.21:
        mov eax, dword [byte esi+facedir-2]
        sar eax, 10h
        mov ax, word [nosplit eax*2+FallDown_pinxl]
        add eax, 9Ah
        add word [byte esi+Xpos+2], ax
.22:
        test byte [byte esi+055h], 8
        jne near NetCollide.17
.23:
        mov eax, SPAboardleft
        jmp short .25
.24:
        mov eax, dword [byte esi+SPA-2]
        sar eax, 10h
.25:
        add esp, byte 0Ch
        jmp near PassLaneChk_ret5
;-----------------------------------------------------------------------------
; FallDown                                            562DB  94G collide94.asm
; A player falls after a hit: fall animation, newcheck, injury (setInjuryType),
; penalty roll (checkagr AddPenalty2).
;-----------------------------------------------------------------------------
; C: src/engine/bodycheck/FallDown.c
%ifdef CBUILD
%include "c/engine/bodycheck/FallDown.inc"
%else
FallDown:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        mov ecx, eax
        mov ebx, edx
        cmp word [byte edx+06Ah], byte 0Bh
        jle short .1
        cmp word [byte ebx+SCnum], byte 10h
        jne near .x
.1:
        test byte [byte ebx+pflags2], 1
        jne near .x
        mov si, word [byte ebx+SPA]
        cmp si, SPAinjury1
        je near .x
        cmp si, SPAstumble
        je near .x
        cmp si, SPAfallfwd
        je near .x
        cmp si, SPAfallback
        je near .x
        cmp si, SPAflip
        je near .x
        cmp si, SPAblockleft
        je near .x
        cmp si, SPAblockright
        je near .x
        cmp word [byte ebx+SCnum], byte 10h
        jne short .4
        cmp si, SPAreffallback
        je near .x
        or byte [byte ebx+pflags], 20h
        mov edx, SPAreffallback
        mov eax, ebx
        call SetSPA
        mov di, word [Crowdlevel]
        cmp di, 3E8h
        jg short .2
        mov eax, edi
        add eax, 1F4h
        mov word [Crowdlevel], ax
        cmp ax, 3E8h
        jle short .2
        mov word [Crowdlevel], 3E8h
.2:
        add word [CwdExciteLvl], byte 0Fh
        mov eax, 1
        call newcheck
.3:
        mov eax, 7Dh
        jmp near .55
.4:
        cmp byte [byte ebx+060h], 0Ch
        jb short .5
        mov eax, 10h
        call randomd0
        cwde
        mov edx, dword [byte ebx+016h]
        sar edx, 10h
        add eax, byte 10h
        cmp eax, edx
        jle short .5
        mov word [byte ebx+040h], 3Ch
        mov esi, SPAstumble
        jmp near .38
.5:
        cmp word [byte ecx+position], byte 0
        je short .6
        mov eax, dword [byte ecx+06Ch]
        mov dh, byte [gmode]
        test dh, 10h
        jne short .6
        test dh, 1
        jne short .6
        inc word [byte eax+024h]
.6:
        mov word [byte ebx+03Eh], 78h
        mov ax, word [byte ecx+Ypos+2]
        sub ax, word [byte ebx+Ypos+2]
        movsx edx, ax
        mov ax, word [byte ecx+Xpos+2]
        sub ax, word [byte ebx+Xpos+2]
        cwde
        call vtoa
        mov edi, eax
        cmp word [byte ecx+position], byte 0
        je short .7
        cmp word [byte ecx+SCnum], byte 6
        setl al
        mov edx, eax
        and edx, 0FFh
        cmp word [byte ebx+SCnum], byte 6
        setl al
        and eax, 0FFh
        cmp edx, eax
        jne short .8
.7:
        mov si, word [byte ebx+SPA]
        jmp near .27
.8:
        cmp word [byte ebx+Xpos+2], byte 0
        jge short .9
        mov eax, dword [ebx]
        sar eax, 10h
        neg eax
        jmp short .10
.9:
        mov eax, dword [ebx]
        sar eax, 10h
.10:
        cmp eax, byte 60h
        jl short .13
        cmp word [byte ebx+Ypos+2], byte 0
        jge short .11
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
        neg eax
        jmp short .12
.11:
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
.12:
        cmp eax, 0CAh
        jl short .13
        movsx edx, di
        mov eax, ebx
        call NetCollide
        mov esi, eax
        cmp ax, word [byte ebx+SPA]
        jne near .27
.13:
        cmp word [byte ebx+Xpos+2], 80h
        jl near .19
        cmp word [byte ebx+Ypos+2], 0D0h
        jg short .14
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
        cmp eax, 0FFFFFF2Ah
        jge short .15
.14:
        movsx edx, di
        mov eax, ebx
        call NetCollide
        mov esi, eax
        jmp near .27
.15:
        cmp di, byte 5
        jl near .27
        mov word [byte ebx+Xvel], 0
        test byte [byte ebx+055h], 8
        je short .18
        mov esi, SPAboardleft
        mov eax, dword [byte ebx+facedir-2]
        sar eax, 10h
        mov edx, 8
        sub edx, eax
        mov eax, edx
        and eax, byte 7
        mov ax, word [nosplit eax*2+FallDown_pinxl]
.16:
        neg eax
.17:
        mov word [byte ebx+Xpos+2], ax
        jmp near .27
.18:
        mov esi, SPAboardright
        mov eax, dword [byte ebx+facedir-2]
        sar eax, 10h
        mov ax, word [nosplit eax*2+FallDown_pinxr]
        jmp short FallDown.17
.19:
        mov eax, dword [ebx]
        sar eax, 10h
        cmp eax, byte 0FFFFFF80h
        jg near .25
        cmp word [byte ebx+Ypos+2], 0D0h
        jg short FallDown.14
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
        cmp eax, 0FFFFFF2Ah
        jl near FallDown.14
        test di, di
        je near .27
        cmp di, byte 4
        jge near .27
        mov word [byte ebx+Xvel], 0
        mov eax, dword [byte ebx+Ypos]
        sar eax, 10h
        cmp eax, byte 0FFFFFFACh
        jl short .20
        cmp eax, byte 0FFFFFFF6h
        jl short .21
.20:
        mov dx, word [byte ebx+Ypos+2]
        cmp dx, byte 27h
        jl short .23
        cmp dx, byte 75h
        jge short .23
.21:
        test byte [byte ebx+055h], 8
        je short .22
        mov esi, SPAbenchcheckr
        mov eax, dword [byte ebx+facedir-2]
        sar eax, 10h
        mov edx, 8
        sub edx, eax
        mov eax, edx
        and eax, byte 7
        mov ax, word [nosplit eax*2+FallDown_pinxr2]
        jmp near FallDown.16
.22:
        mov esi, SPAbenchcheckl
        mov eax, dword [byte ebx+facedir-2]
        sar eax, 10h
        mov ax, word [nosplit eax*2+FallDown_pinxl2]
        jmp near FallDown.17
.23:
        test byte [byte ebx+055h], 8
        je short .24
        mov esi, SPAboardright
        mov eax, dword [byte ebx+facedir-2]
        sar eax, 10h
        mov edx, 8
        sub edx, eax
        mov eax, edx
        and eax, byte 7
        mov ax, word [nosplit eax*2+FallDown_pinxr]
        jmp near FallDown.16
.24:
        mov esi, SPAboardleft
        mov eax, dword [byte ebx+facedir-2]
        sar eax, 10h
        mov ax, word [nosplit eax*2+FallDown_pinxl]
        jmp near FallDown.17
.25:
        cmp word [byte ebx+Ypos+2], 0EEh
        jl short .26
        cmp word [byte ebx+Xpos+2], byte 68h
        jg near FallDown.14
        cmp eax, byte 0FFFFFF98h
        jl near FallDown.14
        movsx eax, di
        add eax, byte 2
        and eax, byte 7
        cmp eax, byte 5
        jl short .27
        mov eax, dword [byte ebx+facedir-2]
        sar eax, 10h
        mov ax, word [nosplit eax*2+FallDown_pinyt]
        mov word [byte ebx+Ypos+2], ax
        mov word [byte ebx+Yvel], 0
        mov esi, SPAboardback
        jmp short .27
.26:
        mov edx, dword [byte ebx+Ypos]
        sar edx, 10h
        cmp edx, 0FFFFFF0Eh
        jg short .27
        cmp word [byte ebx+Xpos+2], byte 68h
        jg near FallDown.14
        cmp eax, byte 0FFFFFF98h
        jl near FallDown.14
        movsx eax, di
        inc eax
        and eax, byte 7
        cmp eax, byte 3
        jge short .27
        mov eax, dword [byte ebx+facedir-2]
        sar eax, 10h
        mov ax, word [nosplit eax*2+FallDown_pinyb]
        mov word [byte ebx+Ypos+2], ax
        mov word [byte ebx+Yvel], 0
        mov esi, SPAboardfront
.27:
        cmp si, word [byte ebx+SPA]
        jne near .35
        sub di, word [byte ebx+facedir]
        inc edi
        and edi, byte 7
        cmp di, byte 2
        ja short .28
        mov esi, SPAfallback
        jmp near .38
.28:
        cmp word [byte ecx+SCnum], byte 0Eh
        jne near .33
        cmp di, byte 3
        je short .29
        cmp di, byte 7
        jne near .33
.29:
        mov esi, SPAfallback
        mov di, word [byte ecx+012h]
        cmp di, 44Fh
        jg near .38
        cmp di, 467h
        jg near .38
        cmp dword [penshotplayer], byte 0
        jge near .38
        mov dl, byte [gmode]
        test dl, 1
        jne near .38
        test dl, 10h
        jne near .38
        test byte [gameopts], 10h
        je near .38
        test byte [byte ebx+036h], 3
        jne near .38
        test byte [byte ebx+pflags2], 10h
        jne near .38
        test byte [byte ebx+pflags], 8
        je short .30
        mov eax, 0C8h
        jmp short .31
.30:
        mov eax, 0A0h
.31:
        cwde
        call randomd0
        cmp ax, 14h
        jg near .38
        mov eax, ebx
        call CanRemovePlayer
        test eax, eax
        je near .38
        mov dx, word [Crowdlevel]
        cmp dx, 3E8h
        jg short .32
        mov esi, edx
        add esi, 1F4h
        mov word [Crowdlevel], si
        cmp si, 3E8h
        jle short .32
        mov word [Crowdlevel], 3E8h
.32:
        add word [CwdExciteLvl], byte 0Fh
        or byte [byte ebx+pflags], 20h
        mov edx, SPAinjury1
        mov eax, ebx
        call SetSPA
        mov eax, ebx
        call setInjuryType
        mov edx, 0Ah
        mov eax, ecx
        call AddPenalty2
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.33:
        test byte [byte ebx+036h], 3
        jne short .34
        cmp byte [byte ecx+064h], 0Ah
        jb short .34
        cmp word [byte ecx+SCnum], byte 0Bh
        jg short .34
        mov esi, SPAflip
        test byte [byte ecx+pflags], 40h
        setne al
        and eax, 0FFh
        call SetBoxDoorObject
        jmp short .38
.34:
        mov esi, SPAfallfwd
        jmp short .38
.35:
        mov eax, dword [puckc]
        add word [Crowdlevel], byte 64h
        movsx ax, byte [eax]
        cmp ax, word [byte ebx+SCnum]
        je short .38
        mov eax, ecx
        call checkagr
        cmp ax, 3
        jg short .38
        cmp si, SPAboardback
        jl short .38
        cmp si, SPAboardleft
        jg short .38
        cmp word [byte ebx+018h], byte 23h
        jle short .36
        mov eax, 18h
        jmp short .37
.36:
        mov eax, 14h
.37:
        movsx edx, ax
        mov eax, ecx
        call AddPenalty
.38:
        or byte [byte ebx+pflags], 20h
        movsx edx, si
        mov eax, ebx
        call SetSPA
        mov eax, dword [byte ebx+assnum-2]
        sar eax, 10h
        cmp byte [byte ebx+eax+01Eh], 12h
        jne short .39
        mov eax, ebx
        call assexit
.39:
        mov di, word [Crowdlevel]
        cmp di, 3E8h
        jg short .40
        mov eax, edi
        add eax, 1F4h
        mov word [Crowdlevel], ax
        cmp ax, 3E8h
        jle short .40
        mov word [Crowdlevel], 3E8h
.40:
        mov eax, dword [puckc]
        add word [CwdExciteLvl], byte 0Fh
        mov dh, byte [eax]
        test dh, dh
        jl short .41
        movsx dx, dh
        cmp dx, word [byte ebx+SCnum]
        je short .44
.41:
        cmp si, SPAboardback
        jl short .43
        cmp si, SPAbenchcheckl
        jg short .43
        mov eax, 2
.42:
        call newcheck
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.43:
        mov eax, 1
        jmp short FallDown.42
.44:
        mov byte [eax], 0FFh
        cmp dword [penshotplayer], byte 0
        jge near .54
        test byte [gmode], 10h
        jne near .54
        test byte [gameopts], 10h
        je near .54
        cmp word [byte ebx+SPA], SPAfallback
        jne near .54
        test byte [byte ebx+036h], 3
        jne near .54
        test byte [byte ebx+pflags2], 10h
        jne near .54
        test byte [byte ebx+pflags], 8
        je short .45
        mov eax, 0C8h
        jmp short .46
.45:
        mov eax, 0A0h
.46:
        cwde
        call randomd0
        cmp ax, word [byte ebx+018h]
        jg near .54
        test byte [gmode], 1
        jne near .54
        mov eax, ebx
        call CanRemovePlayer
        test eax, eax
        je near .54
        or byte [byte ebx+pflags], 20h
        mov edx, SPAinjury1
        mov eax, ebx
        call SetSPA
        mov eax, ebx
        call setInjuryType
        cmp word [byte ecx+position], byte 0
        je short .47
        test byte [gameopts], 1
        je short .47
        test byte [byte ecx+pflags], 40h
        setne al
        and eax, 0FFh
        cmp byte [dword eax+PBnum], 8
        jge short .47
        mov eax, ecx
        call CanRemovePlayer
        test eax, eax
        jne short .48
.47:
        mov edx, 0Ah
        mov eax, ecx
        call AddPenalty2
        jmp near .54
.48:
        mov ax, word [byte ebx+Ypos+2]
        sub ax, word [byte ecx+Ypos+2]
        movsx edx, ax
        mov ax, word [byte ebx+Xpos+2]
        sub ax, word [byte ecx+Xpos+2]
        cwde
        call vtoa
        mov edx, dword [byte ecx+facedir-2]
        sar edx, 10h
        cwde
        sub eax, edx
        inc eax
        and eax, byte 7
        cmp eax, byte 2
        jg short .49
        mov eax, dword [byte ebx+facedir-2]
        sar eax, 10h
        sub eax, edx
        inc eax
        and eax, byte 7
        cmp eax, byte 2
        jg short .49
        mov edx, 17h
        jmp short .50
.49:
        mov edx, 9
.50:
        mov eax, ecx
        call AddPenalty2
        xor edx, edx
        jmp short .53
.51:
        movsx eax, dx
        cmp byte [nosplit eax*2+PenBuf], 0
        jne short .52
        mov eax, edx
        dec eax
        cwde
        call Stop4Pen
.52:
        inc edx
.53:
        cmp dx, byte 20h
        jl short FallDown.51
.54:
        test byte [byte ebx+pflags], 40h
        jne near FallDown.3
        mov eax, 0A0h
.55:
        call sfx
.x:
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; Bcheck                           56A54  94G collide94.asm, medium confidence
; Bcheck: player in the B-check animation hits the other player
; (FallDown, checkagr, AddPenalty)
;-----------------------------------------------------------------------------
; C: src/engine/bodycheck/Bcheck.c
%ifdef CBUILD
%include "c/engine/bodycheck/Bcheck.inc"
%else
Bcheck:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push esi
        mov ebx, eax
        mov ecx, edx
        test byte [byte eax+044h], 20h
        jne near .x
        cmp word [byte ebx+SCnum], byte 10h
        je near .x
        cmp word [byte ebx+position], byte 0
        je near .x
        test byte [byte ebx+pflags2], 1
        jne near .x
        test byte [gameopts], 1
        jne short .1
        test byte [byte ecx+pflags], 8
        je short .1
        xor eax, eax
        mov al, byte [byte ecx+064h]
        mov edx, eax
        add edx, byte 10h
        xor eax, eax
        mov al, byte [byte ebx+057h]
        sub edx, eax
        movsx eax, dx
        call randomd0
        cmp ax, 0Ch
        jl near .x
.1:
        mov esi, dword [byte ecx+facedir-2]
        sar esi, 10h
        mov ax, word [byte ebx+Ypos+2]
        sub ax, word [byte ecx+Ypos+2]
        movsx edx, ax
        mov ax, word [byte ebx+Xpos+2]
        sub ax, word [byte ecx+Xpos+2]
        cwde
        call vtoa
        cwde
        sub eax, esi
        inc eax
        and eax, byte 7
        cmp eax, byte 2
        jg near .x
        mov edx, ebx
        mov eax, ecx
        call FallDown
        mov eax, ebx
        call QuickShotChk
        test eax, eax
        je short .5
        cmp dword [penshotplayer], byte 0
        jge short .7
        mov eax, dword [byte ebx+SCnum-2]
        sar eax, 10h
        mov dword [penshotplayer], eax
        mov eax, dword [c1playernum-2]
        sar eax, 10h
        mov ebx, dword [penshotplayer]
        cmp eax, ebx
        jne short .2
        mov dword [penshotctl], 1
        jmp short .4
.2:
        jne short .3
        mov dword [penshotctl], 2
        jmp short .4
.3:
        mov dword [penshotctl], 0FFFFFFFFh
.4:
        mov edx, 1Ah
        jmp short .6
.5:
        mov eax, ecx
        call checkagr
        cmp ax, 4
        jg short .7
        mov edx, 10h
.6:
        mov eax, ecx
        call AddPenalty
.7:
        mov byte [collflag], 0FFh
.x:
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; holdcheck                        56B79  94G collide94.asm, medium confidence
; Player a grabbing player b.
;
; Not when a is already held (pflags bit 5), is SCnum 16, has no position or
; pflags2 bit 0 is set; only when b faces a (direction from b to a within one
; step of b's facedir).
;
; Dropping the puck carrier clears sflags bit 3; both skate on at their mean
; velocity, both get pflags bit 5, a takes SPA 669h and b 651h (88Bh unless b
; is in 639h).
;
; On a quick shot chance (QuickShotChk) with no penalty shot pending, a gets
; the penalty shot (penshotctl 1 2 -1 by controller) and b a penalty 1Ah, the
; puck is loose (puckc -1) and b's nopuck 20h; else
;
; unless a's checking aggression (checkagr) is over 6, b gets holding (12h
; when in SPA 651h, else 0Fh). Then collflag -1.
;-----------------------------------------------------------------------------
; C: src/engine/bodycheck/holdcheck.c
%ifdef CBUILD
%include "c/engine/bodycheck/holdcheck.inc"
%else
holdcheck:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push esi
        mov ebx, eax
        mov ecx, edx
        test byte [byte eax+044h], 20h
        jne near .x
        cmp word [byte ebx+SCnum], byte 10h
        je near .x
        cmp word [byte ebx+position], byte 0
        je near .x
        test byte [byte ebx+pflags2], 1
        jne near .x
        mov esi, dword [byte ecx+facedir-2]
        sar esi, 10h
        mov ax, word [byte ebx+Ypos+2]
        sub ax, word [byte ecx+Ypos+2]
        movsx edx, ax
        mov ax, word [byte ebx+Xpos+2]
        sub ax, word [byte ecx+Xpos+2]
        cwde
        call vtoa
        cwde
        sub eax, esi
        inc eax
        and eax, byte 7
        cmp eax, byte 2
        jg near .x
        mov eax, dword [puckc]
        movsx ax, byte [eax]
        cmp ax, word [byte ebx+SCnum]
        jne short .1
        and byte [sflags], 0F7h
.1:
        mov edx, dword [byte ebx+Xvel-2]
        sar edx, 10h
        mov eax, dword [byte ecx+Xvel-2]
        sar eax, 10h
        add eax, edx
        sar eax, 1
        mov word [byte ebx+Xvel], ax
        mov word [byte ecx+Xvel], ax
        mov edx, dword [byte ebx+Yvel-2]
        sar edx, 10h
        mov eax, dword [byte ecx+Yvel-2]
        sar eax, 10h
        add eax, edx
        sar eax, 1
        mov word [byte ebx+Yvel], ax
        mov word [byte ecx+Yvel], ax
        or byte [byte ebx+pflags], 20h
        mov edx, SPAflail
        mov eax, ebx
        call SetSPA
        or byte [byte ecx+pflags], 20h
        cmp word [byte ecx+SPA], SPAHold
        jne short .2
        mov eax, SPAHold2
        jmp short .3
.2:
        mov eax, SPAhook2
.3:
        movsx edx, ax
        mov eax, ecx
        call SetSPA
        mov eax, ebx
        call QuickShotChk
        test eax, eax
        je short .7
        cmp dword [penshotplayer], byte 0
        jge near .10
        mov eax, dword [byte ebx+SCnum-2]
        sar eax, 10h
        mov dword [penshotplayer], eax
        mov eax, dword [c1playernum-2]
        sar eax, 10h
        mov ebx, dword [penshotplayer]
        cmp eax, ebx
        jne short .4
        mov dword [penshotctl], 1
        jmp short .6
.4:
        jne short .5
        mov dword [penshotctl], 2
        jmp short .6
.5:
        mov dword [penshotctl], 0FFFFFFFFh
.6:
        mov edx, 1Ah
        mov eax, ecx
        call AddPenalty
        mov eax, dword [puckc]
        mov byte [eax], 0FFh
        mov word [byte ecx+03Eh], 20h
        jmp short .10
.7:
        mov eax, ecx
        call checkagr
        cmp ax, 6
        jg short .10
        cmp word [byte ecx+SPA], SPAHold2
        jne short .8
        mov eax, 12h
        jmp short .9
.8:
        mov eax, 0Fh
.9:
        movsx edx, ax
        mov eax, ecx
        call AddPenalty
.10:
        mov byte [collflag], 0FFh
.x:
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
