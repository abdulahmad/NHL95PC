; Coach modes (PC only).
bits 32
%include "hockey.inc"
section s_5A581 progbits alloc exec nowrite align=1
extern __CHK, awscore, awtmcoach_d2, awtmcoach_d3, awtmcoachenergy, awtmcoachflags, awtmcoachmode, awtmlcnt
extern awtmline, cont1team, cont2team, curperiod, gameclock, gameopts, gmode, hmscore
extern hmtmcoach_d2, hmtmcoach_d3, hmtmcoachenergy, hmtmcoachflags, hmtmcoachmode, hmtmlcnt, hmtmline
global SetCoachMode, InitCoachModes, UpdateCoachModes
;-----------------------------------------------------------------------------
; SetCoachMode                                 5A581  95 PC, medium confidence
; Sets a team's coach AI mode (team D2h..D6h fields)
;-----------------------------------------------------------------------------
; C: src/engine/coach/SetCoachMode.c
%ifdef CBUILD
%include "c/engine/coach/SetCoachMode.inc"
%else
SetCoachMode:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov edx, eax
        mov ax, word [hmscore]
        sub ax, word [awscore]
        test edx, edx
        jne short .3
        movsx ebx, ax
        mov dl, byte [hmtmcoachflags]
        and dl, 0FEh
        cmp ebx, byte 0FFFFFFFFh
        jge short .1
        mov byte [hmtmcoachflags], dl
        mov byte [hmtmcoachmode], 5
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        cmp ax, 3
        jle short .2
        mov dword [hmtmcoachenergy], 0D9Ah
        mov byte [hmtmcoachflags], dl
        mov byte [hmtmcoachmode], 4
        mov byte [hmtmcoach_d2], 3
        mov byte [hmtmcoach_d3], 2
        pop edx
        pop ecx
        pop ebx
        ret
.2:
        mov dword [hmtmcoachenergy], 0CCCh
        xor ch, ch
        mov byte [hmtmcoachmode], ch
        mov byte [hmtmcoachflags], dl
        pop edx
        pop ecx
        pop ebx
        ret
.3:
        mov dl, byte [awtmcoachflags]
        or dl, 1
        cmp ax, 1
        jle short .4
        mov byte [awtmcoachflags], dl
        mov byte [awtmcoachmode], 8
        pop edx
        pop ecx
        pop ebx
        ret
.4:
        cwde
        cmp eax, byte 0FFFFFFFDh
        jge short .5
        mov dword [awtmcoachenergy], 0D9Ah
        mov byte [awtmcoach_d2], 3
        mov byte [awtmcoach_d3], 2
        jmp short .6
.5:
        mov dword [awtmcoachenergy], 0CCCh
.6:
        mov byte [awtmcoachflags], dl
        mov byte [awtmcoachmode], 1
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; InitCoachModes                               5A669  95 PC, medium confidence
; Resets both teams' coach AI modes at period start (StartPer)
;-----------------------------------------------------------------------------
; C: src/engine/coach/InitCoachModes.c
%ifdef CBUILD
%include "c/engine/coach/InitCoachModes.inc"
%else
InitCoachModes:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push edi
        xor ah, ah
        mov byte [awtmcoachflags], ah
        mov byte [hmtmcoachflags], ah
        mov dh, 3
        mov byte [hmtmcoach_d2], dh
        mov bl, 2
        mov byte [hmtmcoach_d3], bl
        mov byte [awtmcoach_d2], dh
        mov byte [awtmcoach_d3], bl
        mov edx, dword [curperiod]
        cmp edx, byte 3
        jle short .1
        mov edi, 0D9Ah
        mov dword [hmtmcoachenergy], edi
        mov byte [hmtmcoachmode], bl
        mov dword [awtmcoachenergy], edi
        mov byte [awtmcoachflags], 1
        mov byte [awtmcoachmode], 8
        jmp short .3
.1:
        jne short .2
        xor eax, eax
        call SetCoachMode
        mov eax, 1
        call SetCoachMode
        jmp short .3
.2:
        mov ecx, 0CCCh
        mov dword [hmtmcoachenergy], ecx
        mov byte [hmtmcoachmode], ah
        mov dword [awtmcoachenergy], ecx
        mov byte [awtmcoachflags], 81h
        mov byte [awtmcoachmode], 1
.3:
        xor edx, edx
        mov word [awtmlcnt], dx
        mov word [awtmline], dx
        mov word [hmtmlcnt], dx
        mov word [hmtmline], dx
        test byte [gameopts], 4
        je short .x
        cmp word [cont1team], byte 1
        je short .4
        cmp word [cont2team], byte 1
        je short .4
        mov word [hmtmlcnt], 2
.4:
        cmp word [cont1team], byte 2
        je short .x
        cmp word [cont2team], byte 2
        je short .x
        mov word [awtmline], 3
        mov word [awtmlcnt], 2
.x:
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; UpdateCoachModes                             5A77C  95 PC, medium confidence
; coach AI, once a second from ClockTick. Picks each team's mode (team D2h..D6h) from the
; score difference, time left and penalties (details not traced).
;-----------------------------------------------------------------------------
; C: src/engine/coach/UpdateCoachModes.c
%ifdef CBUILD
%include "c/engine/coach/UpdateCoachModes.inc"
%else
UpdateCoachModes:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        test byte [gmode], 10h
        jne near .x
        mov dx, word [hmscore]
        sub dx, word [awscore]
        cmp dword [curperiod], byte 2
        jne near .6
        cmp word [gameclock], 258h
        jg near .6
        mov bl, byte [hmtmcoachmode]
        xor eax, eax
        call SetCoachMode
        cmp bl, byte [hmtmcoachmode]
        je short .1
        or byte [hmtmcoachflags], 40h
.1:
        mov bl, byte [awtmcoachmode]
        mov eax, 1
        call SetCoachMode
        cmp bl, byte [awtmcoachmode]
        je short .2
        or byte [awtmcoachflags], 40h
.2:
        cmp word [gameclock], 258h
        jne near .x
        movsx eax, dx
        cmp eax, byte 0FFFFFFFFh
        jge short .4
        mov ah, byte [hmtmcoach_d2]
        cmp ah, 4
        jae short .3
        mov bl, ah
        inc bl
        mov byte [hmtmcoach_d2], bl
.3:
        mov bh, byte [hmtmcoach_d3]
        cmp bh, 1
        jbe short .4
        mov cl, bh
        dec cl
        mov byte [hmtmcoach_d3], cl
.4:
        cmp dx, byte 1
        jle near .x
        mov ch, byte [awtmcoach_d2]
        cmp ch, 4
        jae short .5
        mov al, ch
        inc al
        mov byte [awtmcoach_d2], al
.5:
        mov ah, byte [awtmcoach_d3]
        cmp ah, 1
        jbe near .x
        mov dl, ah
        dec dl
        mov byte [awtmcoach_d3], dl
        pop edx
        pop ecx
        pop ebx
        ret
.6:
        cmp dword [curperiod], byte 3
        jne near .x
        mov bl, byte [hmtmcoachmode]
        cmp word [gameclock], byte 3Ch
        jg short .8
        movsx eax, dx
        cmp eax, byte 0FFFFFFFFh
        jg short .8
.7:
        mov dword [hmtmcoachenergy], 0B33h
        or byte [hmtmcoachflags], 1
        mov byte [hmtmcoachmode], 6
        jmp short .11
.8:
        cmp word [gameclock], byte 78h
        jg short .9
        movsx eax, dx
        cmp eax, byte 0FFFFFFFFh
        jl short UpdateCoachModes.7
.9:
        cmp word [gameclock], 0B4h
        jg short .12
        movsx eax, dx
        cmp eax, byte 0FFFFFFFFh
        jg short .12
.10:
        mov dword [hmtmcoachenergy], 0B33h
        or byte [hmtmcoachflags], 1
        mov byte [hmtmcoachmode], 7
.11:
        mov byte [hmtmcoach_d2], 4
        mov byte [hmtmcoach_d3], 1
        jmp near .18
.12:
        cmp word [gameclock], 12Ch
        jg short .13
        movsx eax, dx
        cmp eax, byte 0FFFFFFFFh
        jl short UpdateCoachModes.10
.13:
        cmp word [gameclock], 258h
        jg short .17
        movsx eax, dx
        cmp eax, byte 0FFFFFFFFh
        jge short .14
        mov dword [hmtmcoachenergy], 0B33h
        or byte [hmtmcoachflags], 1
        mov byte [hmtmcoachmode], 0Ah
        jmp short UpdateCoachModes.11
.14:
        cmp dx, byte 2
        jle short .15
        mov dword [hmtmcoachenergy], 0CCCh
        jmp short .16
.15:
        mov dword [hmtmcoachenergy], 0D9Ah
.16:
        and byte [hmtmcoachflags], 0FEh
        mov cl, 3
        mov byte [hmtmcoachmode], cl
        mov byte [hmtmcoach_d2], cl
        mov byte [hmtmcoach_d3], 2
        jmp short .18
.17:
        xor eax, eax
        call SetCoachMode
.18:
        cmp bl, byte [hmtmcoachmode]
        je short .19
        or byte [hmtmcoachflags], 40h
.19:
        mov bl, byte [awtmcoachmode]
        cmp word [gameclock], byte 3Ch
        jg short .21
        cmp dx, byte 1
        jl short .21
.20:
        mov dword [awtmcoachenergy], 0B33h
        or byte [awtmcoachflags], 1
        mov byte [awtmcoachmode], 6
        jmp short .24
.21:
        cmp word [gameclock], byte 78h
        jg short .22
        cmp dx, byte 1
        jg short UpdateCoachModes.20
.22:
        cmp word [gameclock], 0B4h
        jg short .25
        cmp dx, byte 1
        jle short .25
.23:
        mov dword [awtmcoachenergy], 0B33h
        or byte [awtmcoachflags], 1
        mov byte [awtmcoachmode], 7
.24:
        mov byte [awtmcoach_d2], 4
        mov byte [awtmcoach_d3], 1
        jmp near .31
.25:
        cmp word [gameclock], 12Ch
        jg short .26
        cmp dx, byte 1
        jg short UpdateCoachModes.23
.26:
        cmp word [gameclock], 258h
        jg short .30
        cmp dx, byte 1
        jle short .27
        mov dword [awtmcoachenergy], 0B33h
        or byte [awtmcoachflags], 1
        mov byte [awtmcoachmode], 0Ah
        jmp short UpdateCoachModes.24
.27:
        movsx eax, dx
        cmp eax, byte 0FFFFFFFEh
        jge short .28
        mov dword [awtmcoachenergy], 0CCCh
        mov byte [awtmcoachmode], 9
        jmp short .29
.28:
        mov dword [awtmcoachenergy], 0D9Ah
        mov byte [awtmcoachmode], 8
.29:
        or byte [awtmcoachflags], 1
        mov byte [awtmcoach_d2], 3
        mov byte [awtmcoach_d3], 2
        jmp short .31
.30:
        mov eax, 1
        call SetCoachMode
.31:
        cmp bl, byte [awtmcoachmode]
        je short .x
        or byte [awtmcoachflags], 40h
.x:
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
