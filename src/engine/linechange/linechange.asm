; Line changes on the fly and at faceoffs.
bits 32
%include "hockey.inc"
section s_4D938 progbits alloc exec nowrite align=1
extern __CHK, ass_popx, assrefwhistle, assreplace, awlinetimer, awplattr_b13, awtmstruct, dirtab
extern dirtab_y, Endfaceoff_ftab_m1, fodir1, fodir2, fofdata2, fofdata2_w2, fofdata2_w4, fofdata2_w6
extern gameopts, getlchoice, gmode, gmode2, hmlinetimer, hmplattr_b13, hmtmstruct, lasttouch
extern lcblink, lcblinktime, lcboxon, lcline, lcsel, lctimer, puckz, randomd0
extern refXvel, regd0, regd2, regd3, regd4, sflags, sflags3, sfx
extern SortCords, StopDigiSample
global RequestLineChange, SetLCmode, StartFaceoffLineChange, Endfaceoff
;-----------------------------------------------------------------------------
; RequestLineChange                            4D938  95 PC, medium confidence
; Team from pflags+44h bit 40h: getlchoice (or the team's current line
; hmtmstruct/awtmstruct+2Ah) into lcline, lcsel, lctimer=3Ch,
;
; lcblink/lcblinktime=0Ch, lcboxon=1; clears hmlinetimer/C5860. Replaces the
; loadTeamStruct guess (cosine 0.14), which does none of this
;-----------------------------------------------------------------------------
; C: src/engine/referee/assrefwhistle.c (RequestLineChange)
%ifdef CBUILD
%include "c/engine/referee/assrefwhistle.RequestLineChange.inc"
%else
RequestLineChange:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        test byte [byte eax+044h], 40h
        setne dl
        xor dh, dh
        mov ebx, edx
        mov ecx, 1
        mov word [regd0], cx
        call getlchoice
        mov si, word [regd0]
        test si, si
        jge short .3
        movsx eax, dx
        xor ecx, ecx
        mov word [nosplit eax*2+lcsel], cx
        test dx, dx
        jle short .1
        mov eax, awtmstruct
        jmp short .2
.1:
        mov eax, hmtmstruct
.2:
        movsx edx, bx
        mov ax, word [byte eax+02Ah]
        mov word [nosplit edx*2+lcline], ax
        jmp short .4
.3:
        movsx eax, dx
        mov word [nosplit eax*2+lcsel], cx
        mov word [nosplit eax*2+lcline], si
.4:
        movsx eax, bx
        mov word [nosplit eax*2+lctimer], 3Ch
        mov edi, 1
        mov word [nosplit eax*2+lcblink], di
        mov word [nosplit eax*2+lcblinktime], 0Ch
        mov word [nosplit eax*2+lcboxon], di
        test bx, bx
        je short .5
        xor ebx, ebx
        mov dword [awlinetimer], ebx
        jmp near ass_popx
.5:
        xor edx, edx
        mov dword [hmlinetimer], edx
        jmp near ass_popx
%endif ; C
;-----------------------------------------------------------------------------
; SetLCmode                          4D9FC  94G logic94.asm, medium confidence
; Put player p's team into line change mode: only with line changes on
; (gameopts bit 2) and when the team is not in it already (tmflags bit 1,
;
; then set). Clears sflags bits 2-3 (sflags), keeps the joystick on p (pflags2
; pf2lcm) and asks for the line change box.
;-----------------------------------------------------------------------------
; C: src/engine/linechange/SetLCmode.c
%ifdef CBUILD
%include "c/engine/linechange/SetLCmode.inc"
%else
SetLCmode:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        test byte [gameopts], 4
        je short .x
        mov edx, dword [byte eax+06Ch]
        mov bl, byte [byte edx+tmflags]
        test bl, 2
        jne short .x
        mov bh, bl
        or bh, 2
        mov byte [byte edx+tmflags], bh
        and byte [sflags], 0F3h
        or byte [byte eax+045h], 8
        call RequestLineChange
.x:
        pop edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; StartFaceoffLineChange                                4DA37  94G logic94.asm
; start a line change for player p's team before a faceoff. r is the object
; that waits for the change.
;
; Clears pf2lcm, calls SetLCmode(p); when the team went into line change mode
; (pf2lcm set again): away player (pfteam) -> r->temp2 = 168h and r->temp4 =
; p's SCnum, home player -> r->temp1 = 258h and r->temp3 = SCnum.
;-----------------------------------------------------------------------------
; C: src/engine/linechange/StartFaceoffLineChange.c
%ifdef CBUILD
%include "c/engine/linechange/StartFaceoffLineChange.inc"
%else
StartFaceoffLineChange:
        push dword 8
        call __CHK
        push ebx
        mov ebx, eax
        and byte [byte edx+pflags2], 0F7h
        mov eax, edx
        call SetLCmode
        test byte [byte edx+pflags2], 8
        je short .x
        test byte [byte edx+pflags], 40h
        je short .1
        mov word [byte ebx+temp2], 168h
        mov dx, word [byte edx+SCnum]
        mov word [byte ebx+temp4], dx
        pop ebx
        ret
.1:
        mov word [byte ebx+temp1], 258h
        mov dx, word [byte edx+SCnum]
        mov word [byte ebx+temp3], dx
.x:
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; Endfaceoff                         4DA7B  94G logic94.asm, medium confidence
; Drops the puck: picks the faceoff winner and sends the puck off; ends in
; ass_popx: stop the sample, play sfx ABh, end the faceoff (gmode2 bits 0
;
; and 2, the clock bit of gmode, p's pflags2 bit 0; sflags3 bit 4).
;
; The odds (regd2) are 10h less the first centre's faceoff stance
; (Endfaceoff_ftab_m1 by fofdata2) plus the second's, plus the away centre's
; faceoff rating less the home centre's (awplattr_b13 / hmplattr_b13 by pnum;
;
; the centres are the skaters with position 4): randomd0(21h) below them gives
; the puck to the away centre (lasttouch, his input fofdata2_w6), else to the
; home centre (fofdata2_w2).
;
; The winner's input bit 0Bh picks the direction (fodir2 with y speed -800h,
; else fodir1 / +800h); a held direction (bit 3 clear) is used 3 times in 4,
; else a random one of the 5 around the y direction (mirrored
;
; by the sign of the y speed).
;
; The puck p gets that velocity (dirtab * 20h, plus the y speed), a random z
; velocity (below 800h), z 0, loses pflags bit 2 and takes assignment 18h
; (pucknorm); the referee (SortCords + 16) takes 1Fh and refXvel is set
;
; to 500h toward his side. p: the puck. No result.
;-----------------------------------------------------------------------------
; C: src/engine/referee/assrefwhistle.c (Endfaceoff)
%ifdef CBUILD
%include "c/engine/referee/assrefwhistle.Endfaceoff.inc"
%else
Endfaceoff:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ecx, eax
        call StopDigiSample
        mov eax, 0ABh
        call sfx
        and byte [gmode2], 0FAh
        and byte [gmode], 0FEh
        and byte [byte ecx+pflags2], 0FEh
        or byte [sflags3], 10h
        mov eax, dword [fofdata2-2]
        sar eax, 10h
        movsx ax, byte [dword eax+Endfaceoff_ftab_m1]
        mov edx, 10h
        sub edx, eax
        mov eax, dword [fofdata2_w4-2]
        sar eax, 10h
        movsx ax, byte [dword eax+Endfaceoff_ftab_m1]
        add edx, eax
        mov word [regd2], dx
        xor edx, edx
        jmp short .2
.1:
        movsx eax, dx
        shl eax, 7
        cmp word [dword eax+SortCords+1Ah], byte 4
        je short .3
        inc edx
.2:
        cmp dx, byte 6
        jl short Endfaceoff.1
.3:
        mov ebx, 6
        jmp short .5
.4:
        movsx eax, bx
        shl eax, 7
        cmp word [dword eax+SortCords+1Ah], byte 4
        je short .6
        inc ebx
.5:
        cmp bx, byte 0Ch
        jl short Endfaceoff.4
.6:
        movsx eax, bx
        shl eax, 7
        mov esi, dword [dword eax+SortCords+44h]
        sar esi, 18h
        mov eax, esi
        shl eax, 2
        add eax, esi
        movzx di, byte [nosplit eax*4+awplattr_b13]
        movsx eax, dx
        shl eax, 7
        mov esi, dword [dword eax+SortCords+44h]
        sar esi, 18h
        mov eax, esi
        shl eax, 2
        add eax, esi
        mov al, byte [nosplit eax*4+hmplattr_b13]
        xor ah, ah
        sub edi, eax
        add word [regd2], di
        mov eax, 21h
        call randomd0
        cmp ax, word [regd2]
        jge short .7
        mov ax, word [fofdata2_w6]
        mov word [lasttouch], bx
        jmp short .8
.7:
        mov ax, word [fofdata2_w2]
        mov word [lasttouch], dx
.8:
        test ah, 8
        je short .9
        mov ax, word [fodir2]
        mov word [regd3], ax
        mov word [regd4], 0F800h
        jmp short .10
.9:
        mov ax, word [fodir1]
        mov word [regd3], ax
        mov word [regd4], 800h
.10:
        mov ax, word [regd3]
        mov word [regd0], ax
        test byte [regd0], 8
        jne short .11
        mov ebx, eax
        xor bh, ah
        and bl, 7
        mov word [regd0], bx
        mov eax, 4
        call randomd0
        test ax, ax
        jne short .13
        mov eax, 5
        call randomd0
        sub eax, byte 2
        xor ah, ah
        and al, 7
        mov word [regd0], ax
        cmp word [regd4], byte 0
        jge short .13
        jmp short .12
.11:
        mov eax, 5
        call randomd0
        sub eax, byte 2
        xor ah, ah
        and al, 7
        mov word [regd0], ax
        cmp word [regd4], byte 0
        jge short .13
.12:
        xor byte [regd0], 4
.13:
        mov ax, word [regd0]
        add eax, eax
        mov word [regd0], ax
        mov eax, dword [regd0-2]
        sar eax, 10h
        mov ax, word [nosplit eax*2+dirtab]
        shl eax, 5
        mov word [byte ecx+Xvel], ax
        mov eax, dword [regd0-2]
        sar eax, 10h
        mov dx, word [nosplit eax*2+dirtab_y]
        shl edx, 5
        mov ax, word [regd4]
        add edx, eax
        mov word [byte ecx+Yvel], dx
        mov eax, 800h
        call randomd0
        mov word [byte ecx+010h], ax
        mov eax, dword [puckz]
        mov word [eax], 0
        and byte [byte ecx+pflags], 0FBh
        mov edx, 18h
        mov eax, ecx
        call assreplace
        mov edx, 1Fh
        mov eax, SortCords+800h
        call assreplace
        cmp word [SortCords+802h], byte 0
        jle short .14
        mov eax, 500h
        jmp short .15
.14:
        mov eax, 0FFFFFB00h
.15:
        mov word [refXvel], ax
        jmp near ass_popx
%endif ; C
