; Computer goalie control and pulling the goalie (94G logic94).
bits 32
%include "hockey.inc"
section s_591C7 progbits alloc exec nowrite align=1
extern __CHK, awtmstruct, checkob, checkob_ret5a, cont1team, cont2team, foy, gameclock
extern gmode, goaliemenuflags, goaliemenuflags_e02, gsp, hmtmstruct, penshotmode, puckc, pucky
extern setpersonel
global CPgoalie, ChkGoalies, ReturnGoalies, ChkPullGoalieLate
;-----------------------------------------------------------------------------
; CPgoalie                           591C7  94G logic94.asm, medium confidence
; Computer team t pulls its goalie when no penalty shot runs, gsp is 2 (third
; period), t trails o by 1-2 goals (up to gsp), at most 60 s are left and the
; puck y is on the attacking side (sign flipped by the first SortCords
; entry's pflags bit 7). The goalie byte gets -1, the goalie's menu item is
; unchecked (2) and "pulled" checked (1) in goaliemenuflags, then
; setpersonel.
;-----------------------------------------------------------------------------
; C: src/engine/goaliepull/CPgoalie.c
%ifdef CBUILD
%include "c/engine/goaliepull/CPgoalie.inc"
%else
CPgoalie:
        push dword 8
        call __CHK
        push ecx
        cmp dword [penshotmode], byte 0
        jne near .x
        mov cx, word [gsp]
        cmp cx, byte 2
        jne near .x
        mov dx, word [byte edx+010h]
        sub dx, word [byte eax+010h]
        test dx, dx
        jle short .x
        cmp dx, cx
        jg short .x
        cmp word [gameclock], byte 3Ch
        jg short .x
        mov edx, dword [dword eax+tmsort]
        test byte [byte edx+044h], 80h
        jne short .1
        neg ebx
.1:
        test bx, bx
        jl short .x
        mov byte [byte eax+039h], 0FFh
        cmp eax, awtmstruct
        sete dl
        xor dh, dh
        mov ebx, edx
        mov dx, word [byte eax+038h]
        xor dh, dh
        and dl, 0Fh
        movsx edx, dx
        mov ecx, edx
        shl ecx, 2
        movsx ebx, bx
        mov edx, ebx
        shl edx, 2
        sub edx, ebx
        mov ebx, dword [dword ecx+edx*4+goaliemenuflags]
        mov byte [ebx], 2
        mov edx, dword [nosplit edx*4+goaliemenuflags_e02]
        mov byte [edx], 1
        call setpersonel
.x:
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ChkGoalies                                          59265  93G logic93_4.asm
; (computer pulls goalie on delayed penalty), once a second from periodicevents.
;-----------------------------------------------------------------------------
; C: src/engine/goaliepull/ChkGoalies.c
%ifdef CBUILD
%include "c/engine/goaliepull/ChkGoalies.inc"
%else
ChkGoalies:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        test byte [gmode], 1
        jne near .x
        xor ecx, ecx
        mov eax, hmtmstruct
        mov esi, awtmstruct
        jmp near .4
.1:
        cmp word [byte eax+038h], byte 0
        jl near .3
        mov edx, dword [puckc]
        mov bl, byte [edx]
        test bl, bl
        jl near .3
        cmp bl, 6
        setl dl
        mov ebx, edx
        and ebx, 0FFh
        test cx, cx
        sete dl
        and edx, 0FFh
        xor edx, ebx
        jne short .3
        test byte [gmode], 8
        je short .2
        mov byte [byte eax+039h], 0FFh
        mov dx, word [byte eax+038h]
        xor dh, dh
        and dl, 0Fh
        movsx ebx, dx
        movsx esi, cx
        mov edx, esi
        shl edx, 2
        sub edx, esi
        shl edx, 2
        mov ebx, dword [dword edx+ebx*4+goaliemenuflags]
        mov byte [ebx], 2
        mov edx, dword [dword edx+goaliemenuflags_e02]
        mov byte [edx], 1
        call setpersonel
        jmp short .3
.2:
        movsx edx, cx
        mov ebx, dword [cont1team-2]
        sar ebx, 10h
        inc edx
        cmp ebx, edx
        je short .3
        mov ebx, dword [cont2team-2]
        sar ebx, 10h
        cmp ebx, edx
        je short .3
        mov ebx, dword [pucky]
        movsx ebx, word [ebx]
        mov edx, esi
        call CPgoalie
.3:
        mov eax, awtmstruct
        mov esi, hmtmstruct
        inc ecx
.4:
        cmp cx, byte 2
        jl near ChkGoalies.1
.x:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ReturnGoalies                                       59352  93G logic93_4.asm
; (computer returns a pulled goalie), from puckfaceoff.
;-----------------------------------------------------------------------------
; C: src/engine/pass/checkob.c (ReturnGoalies)
%ifdef CBUILD
%include "c/engine/pass/checkob.ReturnGoalies.inc"
%else
ReturnGoalies:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 4
        xor ecx, ecx
        mov eax, hmtmstruct
        mov esi, awtmstruct
        jmp near .3
.1:
        test byte [byte eax+038h], 0F0h
        jne short .2
        mov byte [byte eax+039h], 0
        movsx edi, cx
        mov edx, edi
        shl edx, 2
        sub edx, edi
        mov ebx, dword [nosplit edx*4+goaliemenuflags_e02]
        mov byte [ebx], 2
        mov bx, word [byte eax+038h]
        xor bh, bh
        and bl, 0Fh
        mov word [esp], bx
        mov ebx, dword [byte esp-02h]
        sar ebx, 10h
        shl ebx, 2
        mov edx, dword [dword ebx+edx*4+goaliemenuflags]
        mov byte [edx], 1
        mov edx, dword [cont1team-2]
        sar edx, 10h
        inc edi
        cmp edx, edi
        je short .2
        mov edx, dword [cont2team-2]
        sar edx, 10h
        cmp edx, edi
        je short .2
        mov ebx, dword [foy-2]
        sar ebx, 10h
        mov edx, esi
        call CPgoalie
.2:
        mov eax, awtmstruct
        mov esi, hmtmstruct
        inc ecx
.3:
        cmp cx, byte 2
        jl short ReturnGoalies.1
        jmp near checkob_ret5a
%endif ; C
;-----------------------------------------------------------------------------
; ChkPullGoalieLate                            593F5  95 PC, medium confidence
; Player logic caller: 0 unless 3rd period (gsp 2) with at most 60 s left and
; the team is not human-controlled; then a team-struct check (likely the
; score: pull the goalie late, not fully traced)
;-----------------------------------------------------------------------------
; C: src/engine/goaliepull/ChkPullGoalieLate.c
%ifdef CBUILD
%include "c/engine/goaliepull/ChkPullGoalieLate.inc"
%else
ChkPullGoalieLate:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov edx, eax
        shl edx, 8
        add edx, hmtmstruct
        test eax, eax
        sete bl
        and ebx, 0FFh
        shl ebx, 8
        mov ecx, hmtmstruct
        add ecx, ebx
        mov ebx, dword [foy-2]
        sar ebx, 10h
        cmp word [gsp], byte 2
        je short .2
.1:
        xor eax, eax
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.2:
        cmp word [gameclock], byte 3Ch
        jg short ChkPullGoalieLate.1
        mov esi, dword [cont1team-2]
        sar esi, 10h
        inc eax
        cmp esi, eax
        je short ChkPullGoalieLate.1
        je short ChkPullGoalieLate.1
        mov ecx, dword [byte ecx+0Eh]
        sar ecx, 10h
        mov eax, dword [byte edx+0Eh]
        sar eax, 10h
        sub ecx, eax
        mov eax, ecx
        test ecx, ecx
        jg short .4
.3:
        xor eax, ecx
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.4:
        cmp ecx, byte 2
        jg short ChkPullGoalieLate.3
        mov eax, dword [dword edx+tmsort]
        test byte [byte eax+044h], 80h
        jne short .5
        neg ebx
.5:
        test ebx, ebx
        jl short ChkPullGoalieLate.1
        mov eax, 1
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
