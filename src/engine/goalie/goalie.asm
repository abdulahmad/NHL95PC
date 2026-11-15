; Goalie assignments: where the goalie stands, when he comes out for the puck, puck threat (94G logic94).
bits 32
%include "hockey.inc"
section s_4B467 progbits alloc exec nowrite align=1
extern __CHK, AddPenalty2, ass_popx, assexit, assinsert, assrefwhistle, check4bench, chk4pass
extern crowdlevel, gmode, goaliesave_saveanim_m2, iflags, imul32, playeracc, puckc, puckcross
extern puckvx, puckvy, puckvz, puckx, pucky, puckz, randomd0, regd0
extern regd1, regd2, regd3, regd3_m2, regd4, SetSPA, sflags, ShotLaneOpen
extern skateto, skatetopuck, SortCords, stopna, threat, vecdist, vtoa
global GoalieToPuckVec, AdjustFacingDirection, assgoalietopuck, ClampYPosition, assgoalie, assgoalie_popebp, CountPuckThreat
;-----------------------------------------------------------------------------
; GoalieToPuckVec                                 4B467  95 PC, low confidence
; Regd0/regd1 = puck - goalie; regd1 forced to +-1 when goalie and puck are
; both behind the same goal line (E8h); assgoalie helper
;-----------------------------------------------------------------------------
; C: src/engine/goalie/GoalieToPuckVec.c
%ifdef CBUILD
%include "c/engine/goalie/GoalieToPuckVec.inc"
%else
GoalieToPuckVec:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov ebx, dword [byte eax+04h]
        sar ebx, 10h
        mov edx, dword [puckx]
        mov dx, word [edx]
        mov cx, word [byte eax+02h]
        sub edx, ecx
        mov word [regd0], dx
        mov edx, dword [pucky]
        mov cx, word [edx]
        mov si, word [byte eax+06h]
        mov eax, ecx
        sub eax, esi
        mov word [regd1], ax
        test ebx, ebx
        jge short .1
        cmp ebx, 0FFFFFF18h
        jl short .x
        movsx eax, word [edx]
        cmp eax, 0FFFFFF18h
        jge short .x
        mov word [regd1], 1
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
.1:
        cmp ebx, 0E8h
        jge short .x
        cmp word [edx], 0E8h
        jl short .x
        mov word [regd1], 0FFFFh
.x:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; AdjustFacingDirection              4B4E9  94G logic94.asm, medium confidence
; Same step as the 93G/94G AdjustFacingDirection (checks): d = facedir - dir,
; step = ((-d)&4)/2-1, with the pfgoal (pflags bit 7) facing-range special
; cases; the PC adds a 2-tick delay counter at +4Ch
;-----------------------------------------------------------------------------
; C: src/engine/goalie/AdjustFacingDirection.c
%ifdef CBUILD
%include "c/engine/goalie/AdjustFacingDirection.inc"
%else
AdjustFacingDirection:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        mov bx, word [byte eax+036h]
        mov ecx, edx
        cmp word [byte eax+04Ch], byte 0
        jne near .7
        movsx esi, bx
        sub esi, edx
        mov edx, esi
        je near .7
        and edx, byte 4
        sar edx, 1
        dec edx
        test byte [byte eax+044h], 80h
        je short .3
        cmp bx, byte 1
        jl short .1
        cmp bx, byte 3
        jg short .1
        cmp cx, byte 5
        jl short .1
        cmp cx, byte 7
        jle near .5
.1:
        cmp bx, byte 5
        jl short .6
        cmp bx, byte 7
        jg short .6
        cmp cx, byte 1
        jl short .6
        cmp cx, byte 3
        jg short .6
.2:
        mov edx, 1
        jmp short .6
.3:
        cmp bx, byte 1
        jl short .4
        cmp bx, byte 3
        jg short .4
        cmp cx, byte 5
        jl short .4
        cmp cx, byte 7
        jle short AdjustFacingDirection.2
.4:
        cmp bx, byte 5
        jl short .6
        cmp bx, byte 7
        jg short .6
        cmp cx, byte 1
        jl short .6
        cmp cx, byte 3
        jg short .6
.5:
        mov edx, 0FFFFFFFFh
.6:
        add dx, word [byte eax+036h]
        xor dh, dh
        and dl, 7
        mov word [byte eax+036h], dx
        mov word [byte eax+04Ch], 2
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.7:
        mov di, word [byte eax+04Ch]
        dec edi
        mov word [byte eax+04Ch], di
        test di, di
        jge short .x
        mov word [byte eax+04Ch], 0
.x:
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assgoalietopuck                                       4B5C2  94G logic94.asm
; Asstab slot 0Fh = 93G assgoalietopuck (goalie skates out to a loose puck):
; check4bench, skatetopuck, assexit
;-----------------------------------------------------------------------------
; C: src/engine/goalie/assgoalietopuck.c
%ifdef CBUILD
%include "c/engine/goalie/assgoalietopuck.inc"
%else
assgoalietopuck:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push edi
        mov edx, eax
        mov bx, word [byte eax+04Ah]
        test bx, bx
        jle short .1
        mov ecx, ebx
        dec ecx
        mov word [byte eax+04Ah], cx
.1:
        or byte [byte edx+048h], 6
        mov ebx, dword [edx]
        sar ebx, 10h
        mov eax, dword [byte edx+Ypos]
        sar eax, 10h
        test eax, eax
        jge short .2
        mov ecx, eax
        neg ecx
        jmp short .3
.2:
        mov ecx, eax
.3:
        mov eax, ecx
        cmp ebx, byte 0FFFFFFD8h
        jl short .4
        cmp ebx, byte 29h
        jge short .4
        cmp ecx, 0C5h
        jl short .4
        cmp ecx, 0E4h
        jge short .4
        and byte [byte edx+048h], 0FBh
.4:
        cmp ebx, byte 0FFFFFFD0h
        jl short .5
        cmp ebx, byte 31h
        jge short .5
        cmp eax, 0C5h
        jl short .5
        and byte [byte edx+048h], 0FDh
.5:
        test byte [byte edx+pflags], 8
        jne short .6
        test byte [gmode], 1
        je short .7
.6:
        mov eax, edx
        call assexit
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
.7:
        mov eax, edx
        call check4bench
        test ax, ax
        jne near .x
        mov bl, byte [byte edx+pflags]
        test bl, 2
        je short .8
        mov bh, bl
        and bh, 0FDh
        mov byte [byte edx+pflags], bh
        mov word [byte edx+temp1], ax
.8:
        mov cl, byte [byte edx+027h]
        dec cl
        mov byte [byte edx+027h], cl
        test cl, cl
        jge short .12
        xor eax, eax
        mov al, byte [byte edx+05Ah]
        sar eax, 2
        mov byte [byte edx+027h], al
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jge short assgoalietopuck.6
        test byte [byte edx+pflags], 80h
        setne al
        mov ebx, eax
        and ebx, 0FFh
        mov eax, dword [puckvy]
        cmp word [eax], byte 0
        setl al
        and eax, 0FFh
        xor eax, ebx
        je short .11
        mov eax, dword [puckvy]
        mov di, word [eax]
        test di, di
        jge short .9
        movsx eax, di
        neg eax
        jmp short .10
.9:
        movsx eax, di
.10:
        cmp eax, 800h
        jg near assgoalietopuck.6
.11:
        mov eax, dword [byte edx+optmptr]
        cmp dword [byte eax+03Eh], 96h
        jl near assgoalietopuck.6
.12:
        mov eax, edx
        call skatetopuck
.x:
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ClampYPosition                                        4B6F4  94G logic94.asm
; 93G ClampYPosition: regd0 = 0 if the goalie has the puck, regd1 clamped to
; +-E3h (93G +-$103), minus regd3; assgoalie helper
;-----------------------------------------------------------------------------
; C: src/engine/goalie/ClampYPosition.c
%ifdef CBUILD
%include "c/engine/goalie/ClampYPosition.inc"
%else
ClampYPosition:
        push dword 0Ch
        call __CHK
        push ecx
        push edx
        cmp word [byte eax+06h], byte 0
        jge short .1
        mov edx, dword [byte eax+04h]
        sar edx, 10h
        neg edx
        jmp short .2
.1:
        mov edx, dword [byte eax+04h]
        sar edx, 10h
.2:
        cmp edx, 0E8h
        jge short .5
        mov edx, dword [puckc]
        movsx dx, byte [edx]
        cmp dx, word [byte eax+06Ah]
        jne short .3
        xor ecx, ecx
        mov word [regd0], cx
.3:
        cmp word [regd1], 0E3h
        jle short .4
        mov word [regd1], 0E3h
.4:
        mov eax, dword [regd1-2]
        sar eax, 10h
        cmp eax, 0FFFFFF1Dh
        jge short .5
        mov word [regd1], 0FF1Dh
.5:
        mov ax, word [regd3]
        sub word [regd1], ax
        pop edx
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; assgoalie                          4B774  94G logic94.asm, medium confidence
; Asstab slot 14; field alignment 68% of 59 known-field accesses; content
; rank 1/34 vs other slot routines; 2 known Genesis callees present, 0
; missing, 1 extra
;-----------------------------------------------------------------------------
assgoalie:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov esi, eax
        mov ebp, 1
        mov dx, word [byte eax+04Ah]
        test dx, dx
        jle short .1
        mov ebx, edx
        dec ebx
        mov word [byte eax+04Ah], bx
.1:
        mov eax, dword [puckc]
        movsx ax, byte [eax]
        cmp ax, word [byte esi+SCnum]
        je short .2
        mov byte [byte esi+063h], 0
.2:
        or byte [byte esi+048h], 6
        mov edx, dword [esi]
        sar edx, 10h
        mov ecx, dword [byte esi+Ypos]
        sar ecx, 10h
        test ecx, ecx
        jge short .3
        mov eax, ecx
        neg eax
        jmp short .4
.3:
        mov eax, ecx
.4:
        mov ecx, eax
        cmp edx, byte 0FFFFFFD8h
        jl short .5
        cmp edx, byte 29h
        jge short .5
        cmp eax, 0C5h
        jl short .5
        cmp eax, 0E4h
        jge short .5
        and byte [byte esi+048h], 0FBh
.5:
        cmp edx, byte 0FFFFFFD0h
        jl short .6
        cmp edx, byte 31h
        jge short .6
        cmp ecx, 0C5h
        jl short .6
        and byte [byte esi+048h], 0FDh
.6:
        mov eax, esi
        call check4bench
        test ax, ax
        jne near assgoalie_popebp
        mov al, byte [byte esi+pflags]
        test al, 2
        je short .7
        mov ah, al
        and ah, 0FDh
        mov byte [byte esi+pflags], ah
        mov word [byte esi+temp1], 0
        mov word [byte esi+temp2], 8
        mov byte [byte esi+02Dh], 0FFh
.7:
        cmp ecx, 0E4h
        jle short .13
        xor eax, eax
        mov word [regd2], ax
        test edx, edx
        jge short .8
        mov eax, edx
        neg eax
        jmp short .9
.8:
        mov eax, edx
.9:
        cmp eax, byte 30h
        jg short .12
.10:
        cmp word [byte esi+Xpos+2], byte 0
        jge short .11
        mov eax, 0FFFFFF60h
        jmp near .141
.11:
        mov eax, 0A0h
        jmp near .141
.12:
        mov word [regd0], dx
        jmp near .142
.13:
        test edx, edx
        jge short .14
        mov eax, edx
        neg eax
        jmp short .15
.14:
        mov eax, edx
.15:
        cmp eax, byte 34h
        jg short .16
        cmp ecx, 0EFh
        jge short .16
        cmp ecx, 0B3h
        jge short .21
.16:
        test edx, edx
        jl short .17
        mov eax, 4
        jmp short .18
.17:
        mov eax, 0FFFFFFFCh
.18:
        mov word [regd0], ax
        test byte [byte esi+pflags], 80h
        je short .19
        mov eax, 0FFFFFF3Ch
        jmp short .20
.19:
        mov eax, 0C4h
.20:
        mov word [regd1], ax
        xor edx, edx
        mov eax, esi
        call skateto
        jmp near assgoalie_popebp
.21:
        test byte [byte esi+pflags2], 2
        jne short .24
        test byte [byte esi+pflags], 20h
        jne short .24
        mov eax, dword [puckc]
        movsx ax, byte [eax]
        cmp ax, word [byte esi+SCnum]
        jne short .22
        mov eax, 99h
        jmp short .23
.22:
        mov eax, 1
.23:
        movsx edx, ax
        mov eax, esi
        call SetSPA
.24:
        test byte [gmode], 1
        jne near assgoalie_popebp
        cmp word [byte esi+temp5], byte 0
        jl short .27
        mov eax, dword [puckc]
        movsx ax, byte [eax]
        cmp ax, word [byte esi+SCnum]
        jne short .26
        cmp ecx, 9Bh
        jge short .25
        mov word [byte esi+temp5], 0
.25:
        mov bx, word [byte esi+temp5]
        dec ebx
        mov word [byte esi+temp5], bx
        test bx, bx
        jge short .27
        mov edx, 4
        mov eax, esi
        call AddPenalty2
        jmp short .27
.26:
        mov word [byte esi+temp5], 0FFFFh
.27:
        test byte [byte esi+pflags2], 2
        jne near assgoalie_popebp
        mov di, word [byte esi+temp1]
        dec edi
        mov word [byte esi+temp1], di
        test di, di
        jl short .29
        movsx ax, byte [byte esi+028h]
        mov word [regd2], ax
        cmp ax, 7
        jle near .148
.28:
        mov eax, esi
        call stopna
        jmp near assgoalie_popebp
.29:
        xor edx, edx
        mov dl, byte [byte esi+05Ah]
        mov ebx, 3
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov word [byte esi+temp1], ax
        test byte [byte esi+pflags], 8
        jne near .41
        mov eax, dword [pucky]
        mov ax, word [eax]
        mov dx, word [byte esi+Ypos+2]
        xor eax, edx
        mov word [regd1], ax
        test ax, ax
        jge short .32
        xor ecx, ecx
        mov word [regd0], cx
        test byte [byte esi+pflags], 80h
        je short .30
        mov eax, 0FFFFFF2Ch
        jmp short .31
.30:
        mov eax, 0D4h
.31:
        mov word [regd2], ax
        jmp near .142
.32:
        dec word [byte esi+temp4]
        mov eax, dword [puckc]
        movsx ax, byte [eax]
        cmp ax, word [byte esi+SCnum]
        jne near .41
        cmp word [byte esi+temp5], byte 0
        jge short .33
        mov word [byte esi+temp5], 5Ah
.33:
        mov word [byte esi+temp4], 0FFFFh
        cmp word [byte esi+temp5], byte 5Ah
        jge near .39
        mov eax, 4
        call randomd0
        test ax, ax
        jne near .39
        cmp word [byte esi+SCnum], byte 6
        jge short .34
        mov eax, 6
        jmp short .35
.34:
        xor eax, eax
.35:
        shl eax, 7
        add eax, SortCords
        xor edx, edx
        jmp short .38
.36:
        test byte [byte eax+045h], 4
        jne short .37
        cmp word [byte eax+01Ah], byte 0
        jle short .37
        mov di, word [byte eax+04Eh]
        cmp di, byte 23h
        jge short .37
        cmp di, byte 14h
        jge short .37
        or byte [byte esi+pflags], 20h
        or byte [byte esi+pflags2], 2
        mov edx, 1135h
        mov eax, esi
        call SetSPA
        jmp near assgoalie_popebp
.37:
        inc edx
        add eax, 80h
.38:
        cmp dx, byte 6
        jl short assgoalie.36
        mov word [threat], 1
        mov eax, esi
        call chk4pass
        test ax, ax
        jne near assgoalie_popebp
.39:
        mov edi, puckcross
        mov word [regd3], 0E4h
        mov word [regd4], 0E8h
        test byte [byte esi+pflags], 80h
        je short .40
        mov word [regd3], 0FF1Ch
        mov word [regd4], 0FF18h
        add edi, byte 4
.40:
        cmp word [byte esi+Ypos+2], byte 0
        jge near .47
        mov eax, dword [byte esi+Ypos]
        sar eax, 10h
        neg eax
        jmp near .48
.41:
        mov eax, dword [puckx]
        mov ax, word [eax]
        mov dx, word [byte esi+Xpos+2]
        sub eax, edx
        mov word [regd0], ax
        mov eax, dword [pucky]
        mov dx, word [eax]
        mov bx, word [byte esi+Ypos+2]
        sub edx, ebx
        mov word [regd1], dx
        mov edx, dword [puckc]
        mov ch, byte [edx]
        test ch, ch
        jl near .44
        jl near assgoalie.39
        cmp word [byte esi+SCnum], byte 6
        setl al
        mov edx, eax
        and edx, 0FFh
        mov eax, dword [puckc]
        cmp byte [eax], 6
        setl al
        and eax, 0FFh
        xor eax, edx
        je near assgoalie.39
        cmp word [byte esi+04Ah], byte 0
        jne near assgoalie.39
        mov eax, 100h
        call randomd0
        cmp ax, 0Ah
        jge near assgoalie.39
        cmp word [byte esi+04Eh], byte 23h
        jge near assgoalie.39
        mov eax, dword [pucky]
        mov di, word [eax]
        test di, di
        jge short .42
        movsx eax, di
        neg eax
        jmp short .43
.42:
        movsx eax, di
.43:
        cmp eax, 0E9h
        jge near assgoalie.39
        mov edx, dword [regd1-2]
        sar edx, 10h
        mov eax, dword [regd0-2]
        sar eax, 10h
        call vtoa
        mov word [byte esi+facedir], ax
        or byte [byte esi+pflags], 20h
        or byte [byte esi+pflags2], 2
        mov edx, 1095h
        mov eax, esi
        call SetSPA
        mov word [byte esi+04Ah], 0F0h
        jmp near assgoalie_popebp
.44:
        cmp word [byte esi+temp4], byte 0
        jne near assgoalie.39
        cmp word [byte esi+04Eh], byte 2Dh
        jge near assgoalie.39
        mov dx, word [eax]
        test dx, dx
        jge short .45
        movsx eax, dx
        neg eax
        jmp short .46
.45:
        movsx eax, dx
.46:
        cmp eax, 0E9h
        jge near assgoalie.39
        mov eax, dword [byte esi+070h]
        cmp dword [byte eax+03Eh], byte 3Ch
        jge near assgoalie.39
        mov eax, 100h
        call randomd0
        cmp ax, 0Ah
        jge near assgoalie.39
        mov edx, dword [regd1-2]
        sar edx, 10h
        mov eax, dword [regd0-2]
        sar eax, 10h
        call vtoa
        mov word [byte esi+facedir], ax
        mov word [byte esi+03Eh], 8
        or byte [byte esi+pflags], 20h
        or byte [byte esi+pflags2], 2
        mov edx, 181h
        mov eax, esi
        call SetSPA
        mov word [byte esi+04Ah], 168h
        mov bx, word [crowdlevel]
        cmp bx, 4B0h
        jg near assgoalie_popebp
        mov ecx, ebx
        add ecx, 96h
        mov word [crowdlevel], cx
        cmp cx, 4B0h
        jle near assgoalie_popebp
        mov word [crowdlevel], 4B0h
        jmp near assgoalie_popebp
.47:
        mov eax, dword [byte esi+Ypos]
        sar eax, 10h
.48:
        cmp eax, 0E4h
        jle short .51
        xor edi, edi
        mov word [regd2], di
        mov word [regd0], di
        cmp word [byte esi+Xpos+2], byte 0
        jge short .49
        mov eax, dword [esi]
        sar eax, 10h
        neg eax
        jmp short .50
.49:
        mov eax, dword [esi]
        sar eax, 10h
.50:
        cmp eax, byte 30h
        jg near .142
        jmp near assgoalie.10
.51:
        mov eax, dword [puckx]
        mov ax, word [eax]
        mov word [regd0], ax
        mov eax, dword [pucky]
        mov ax, word [eax]
        mov word [regd1], ax
        mov eax, esi
        call ClampYPosition
        mov edx, dword [regd1-2]
        sar edx, 10h
        mov eax, dword [regd0-2]
        sar eax, 10h
        call vtoa
        mov word [regd0], ax
        mov dx, word [byte esi+facedir]
        mov word [regd1], dx
        sub ax, dx
        mov word [regd0], ax
        je near .56
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        and eax, byte 4
        sar eax, 1
        dec eax
        mov word [regd0], ax
        mov ecx, dword [regd1-2]
        sar ecx, 10h
        mov edx, 1
        shl edx, cl
        mov ax, word [regd1]
        add ax, word [regd0]
        test dl, 42h
        jne short .52
        mov word [regd1], ax
        jmp short .55
.52:
        mov word [regd1], ax
        test byte [byte esi+pflags], 80h
        jne short .53
        mov eax, 83h
        jmp short .54
.53:
        mov eax, 38h
.54:
        mov ecx, dword [regd1-2]
        sar ecx, 10h
        mov edx, 1
        shl edx, cl
        test eax, edx
        je short .55
        mov cx, word [regd0]
        neg ecx
        mov word [regd0], cx
        mov eax, ecx
        add eax, ecx
        add word [regd1], ax
.55:
        mov bx, word [regd1]
        xor bh, bh
        and bl, 7
        mov word [regd1], bx
        mov word [byte esi+facedir], bx
.56:
        mov word [regd0], 0E0h
        mov eax, dword [pucky]
        mov dx, word [eax]
        test dx, dx
        jge short .57
        movsx eax, dx
        neg eax
        jmp short .58
.57:
        movsx eax, dx
.58:
        cmp eax, 0BBh
        jle short .59
        sub word [regd0], byte 40h
.59:
        mov ax, word [regd0]
        mov word [regd1], ax
        mov eax, dword [regd0-2]
        sar eax, 10h
        push eax
        mov eax, dword [puckvx]
        movsx eax, word [eax]
        push eax
        call imul32
        add esp, byte 8
        mov edx, eax
        sar edx, 10h
        mov eax, dword [puckx]
        movsx eax, word [eax]
        add eax, edx
        mov word [regd0], ax
        mov eax, dword [regd1-2]
        sar eax, 10h
        push eax
        mov eax, dword [puckvy]
        movsx eax, word [eax]
        push eax
        call imul32
        add esp, byte 8
        mov edx, eax
        sar edx, 10h
        mov eax, dword [pucky]
        movsx eax, word [eax]
        add eax, edx
        mov word [regd1], ax
        mov eax, esi
        call ClampYPosition
        mov eax, dword [regd1-2]
        sar eax, 10h
        push eax
        mov eax, dword [regd0-2]
        sar eax, 10h
        push eax
        call vecdist
        add esp, byte 8
        mov edx, eax
        cmp eax, byte 1Eh
        jl near .64
        inc edx
        mov word [regd2], dx
        mov eax, dword [pucky]
        mov cx, word [eax]
        test cx, cx
        jge short .60
        movsx eax, cx
        neg eax
        jmp short .61
.60:
        movsx eax, cx
.61:
        cmp eax, byte 74h
        jge short .62
        call ShotLaneOpen
        test eax, eax
        je short .62
        mov word [regd4], 14h
        test byte [sflags], 8
        je short .63
        mov word [regd4], 1Ch
        jmp short .63
.62:
        mov word [regd4], 12h
        test byte [sflags], 8
        je short .63
        mov word [regd4], 1Ah
.63:
        mov eax, dword [regd1-2]
        sar eax, 10h
        mov edx, dword [regd4-2]
        sar edx, 10h
        imul edx, eax
        mov ebx, dword [regd2-2]
        sar ebx, 10h
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov word [regd1], ax
        mov eax, dword [regd0-2]
        sar eax, 10h
        add word [regd4], byte 8
        mov edx, dword [regd4-2]
        sar edx, 10h
        imul edx, eax
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov word [regd0], ax
.64:
        mov ax, word [regd3]
        mov bx, word [regd1]
        add ebx, eax
        mov word [regd1], bx
        mov word [regd2], bx
        mov ecx, dword [puckvy]
        movsx ecx, word [ecx]
        sar ecx, 9
        mov eax, dword [pucky]
        movsx edx, word [eax]
        add ecx, edx
        mov ebx, dword [puckc]
        cmp byte [ebx], 0
        jge near .72
        cmp word [eax], byte 0
        jge short .65
        neg edx
.65:
        cmp edx, 0E8h
        jge short .72
        cmp word [byte esi+Ypos+2], byte 0
        jge short .66
        mov eax, dword [byte esi+Ypos]
        sar eax, 10h
        neg eax
        jmp short .67
.66:
        mov eax, dword [byte esi+Ypos]
        sar eax, 10h
.67:
        cmp eax, byte 74h
        jle short .72
        cmp word [byte esi+04Eh], byte 1Eh
        jge short .72
        cmp word [byte esi+Ypos+2], byte 0
        jge short .68
        mov eax, dword [byte esi+Ypos]
        sar eax, 10h
        neg eax
        jmp short .69
.68:
        mov eax, dword [byte esi+Ypos]
        sar eax, 10h
.69:
        test ecx, ecx
        jge short .70
        mov edx, ecx
        neg edx
        jmp short .71
.70:
        mov edx, ecx
.71:
        cmp edx, eax
        jle short .72
        xor ebp, ebp
.72:
        test ebp, ebp
        je short .73
        cmp word [byte edi+02h], byte 23h
        jae near .142
.73:
        movsx edx, word [edi]
        test ebp, ebp
        je near .84
        test edx, edx
        jge short .74
        mov eax, edx
        neg eax
        jmp short .75
.74:
        mov eax, edx
.75:
        cmp eax, byte 19h
        jl near .84
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jge near .142
        test byte [iflags], 4
        jne near .142
        mov eax, dword [puckx]
        mov dx, word [eax]
        test dx, dx
        jge short .76
        movsx eax, dx
        neg eax
        jmp short .77
.76:
        movsx eax, dx
.77:
        cmp eax, byte 44h
        jl near .142
        mov eax, dword [puckvy]
        mov bx, word [eax]
        test bx, bx
        jge short .78
        movsx eax, bx
        neg eax
        jmp short .79
.78:
        movsx eax, bx
.79:
        cmp eax, 3800h
        jl near .142
        mov eax, dword [pucky]
        mov cx, word [eax]
        test cx, cx
        jge short .80
        movsx eax, cx
        neg eax
        jmp short .81
.80:
        movsx eax, cx
.81:
        cmp eax, 98h
        jl near .142
        test byte [byte esi+pflags], 80h
        je short .82
        mov eax, dword [puckvy]
        movsx eax, word [eax]
        neg eax
        jmp short .83
.82:
        mov eax, dword [puckvy]
        movsx eax, word [eax]
.83:
        cmp eax, 0FFFFFE70h
        jl near .142
        mov eax, dword [byte esi+06Ch]
        cmp dword [byte eax+03Eh], 132h
        jl near .142
        mov eax, dword [byte esi+070h]
        cmp dword [byte eax+03Eh], 132h
        jl near .142
        mov edx, 0Fh
        mov eax, esi
        call assinsert
        jmp near assgoalie_popebp
.84:
        mov eax, dword [esi]
        sar eax, 10h
        sub edx, eax
        test edx, edx
        jge short .85
        neg edx
.85:
        sub edx, byte 8
        cmp edx, byte 10h
        jle short .86
        mov edx, 10h
.86:
        test edx, edx
        jge short .87
        xor edx, edx
.87:
        sar edx, 2
        cmp word [byte esi+Ypos+2], byte 0
        jge short .88
        mov eax, dword [byte esi+Ypos]
        sar eax, 10h
        neg eax
        jmp short .89
.88:
        mov eax, dword [byte esi+Ypos]
        sar eax, 10h
.89:
        test ecx, ecx
        jge short .90
        neg ecx
.90:
        cmp ecx, eax
        jle short .91
        add edx, byte 4
.91:
        test ebp, ebp
        je near .101
        cmp word [byte esi+04Eh], byte 19h
        jg short .94
        mov eax, dword [pucky]
        mov bx, word [eax]
        test bx, bx
        jge short .92
        movsx eax, bx
        neg eax
        jmp short .93
.92:
        movsx eax, bx
.93:
        cmp eax, 0E8h
        jle near .101
.94:
        xor eax, eax
        mov ax, word [byte edi+02h]
        add edx, byte 0Ch
        cmp eax, edx
        jge short .97
        mov eax, dword [pucky]
        mov cx, word [eax]
        test cx, cx
        jge short .95
        movsx eax, cx
        neg eax
        jmp short .96
.95:
        movsx eax, cx
.96:
        cmp eax, 0E9h
        jle short .101
.97:
        mov ax, word [edi]
        mov word [regd0], ax
        mov eax, dword [pucky]
        mov cx, word [eax]
        test cx, cx
        jge short .98
        movsx eax, cx
        neg eax
        jmp short .99
.98:
        movsx eax, cx
.99:
        cmp eax, 0DCh
        jle near .142
        mov eax, dword [puckx]
        cmp word [eax], byte 0
        jle short .100
        mov eax, 18h
        jmp near .141
.100:
        mov eax, 0FFFFFFE8h
        jmp near .141
.101:
        mov eax, dword [puckc]
        movsx ax, byte [eax]
        cmp ax, word [byte esi+SCnum]
        je near .142
        mov eax, dword [puckx]
        mov bx, word [eax]
        test bx, bx
        jge short .102
        movsx eax, bx
        neg eax
        jmp short .103
.102:
        movsx eax, bx
.103:
        cmp eax, byte 64h
        jge near .142
        mov eax, dword [puckz]
        cmp word [eax], byte 14h
        jge near .142
        sar word [byte esi+Xvel], 1
        sar word [byte esi+Yvel], 1
        test byte [byte esi+048h], 2
        jne short .105
        mov edx, dword [puckvx]
        movsx edx, word [edx]
        sar edx, 0Ah
        mov eax, dword [puckx]
        movsx eax, word [eax]
        add edx, eax
        mov eax, dword [esi]
        sar eax, 10h
        sub edx, eax
        mov word [regd0], dx
        mov eax, dword [puckvy]
        movsx edx, word [eax]
        sar edx, 0Ah
        mov eax, dword [pucky]
        movsx eax, word [eax]
        add edx, eax
        mov eax, dword [byte esi+Ypos]
        sar eax, 10h
        sub edx, eax
        mov word [regd1], dx
        mov edx, dword [regd1-2]
        sar edx, 10h
        mov eax, dword [regd0-2]
        sar eax, 10h
        call vtoa
        cwde
        cmp eax, byte 8
        jne short .104
        xor eax, eax
        jmp short .106
.104:
        sub ax, word [byte esi+facedir]
        xor ah, ah
        and al, 7
        jmp short .106
.105:
        movsx ax, byte [byte esi+052h]
        sub ax, word [byte esi+facedir]
        xor ah, ah
        and al, 7
.106:
        mov word [regd3], ax
        cmp word [regd3], byte 4
        jne short .111
        mov eax, dword [puckvy]
        mov bx, word [eax]
        test bx, bx
        jge short .107
        movsx edx, bx
        neg edx
        jmp short .108
.107:
        movsx edx, bx
.108:
        mov eax, dword [puckvx]
        mov cx, word [eax]
        test cx, cx
        jge short .109
        movsx eax, cx
        neg eax
        jmp short .110
.109:
        movsx eax, cx
.110:
        add eax, edx
        cmp eax, 1200h
        jg short .111
        mov word [regd0], 8
        jmp near .136
.111:
        mov ax, word [regd3]
        test ax, ax
        je short .112
        cmp ax, 4
        jne near .132
.112:
        mov eax, dword [byte esi+facedir-2]
        sar eax, 10h
        test eax, eax
        jne short .115
        cmp word [regd0], byte 0
.113:
        jl short .117
.114:
        mov eax, 1
        jmp near .131
.115:
        cmp eax, byte 4
        jne short .118
        cmp word [regd0], byte 0
.116:
        jl short assgoalie.114
.117:
        mov eax, 7
        jmp near .131
.118:
        cmp eax, byte 1
        je short .119
        cmp eax, byte 5
        jne short .124
.119:
        cmp word [regd0], byte 0
        jge short .120
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .121
.120:
        mov eax, dword [regd0-2]
        sar eax, 10h
.121:
        cmp word [regd1], byte 0
        jge short .122
        mov edx, dword [regd1-2]
        sar edx, 10h
        neg edx
        jmp short .123
.122:
        mov edx, dword [regd1-2]
        sar edx, 10h
.123:
        cmp eax, edx
        jmp short assgoalie.113
.124:
        cmp eax, byte 3
        je short .125
        cmp eax, byte 7
        jne short .130
.125:
        cmp word [regd0], byte 0
        jge short .126
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .127
.126:
        mov eax, dword [regd0-2]
        sar eax, 10h
.127:
        cmp word [regd1], byte 0
        jge short .128
        mov edx, dword [regd1-2]
        sar edx, 10h
        neg edx
        jmp short .129
.128:
        mov edx, dword [regd1-2]
        sar edx, 10h
.129:
        cmp eax, edx
        jmp near assgoalie.116
.130:
        mov eax, 2
        call randomd0
.131:
        mov word [regd3], ax
.132:
        mov eax, dword [regd3_m2]
        sar eax, 12h
        mov word [regd0], ax
        test byte [byte esi+055h], 8
        je short .133
        test ax, ax
        sete al
        xor ah, ah
        mov word [regd0], ax
.133:
        mov bx, word [regd3]
        cmp bx, byte 4
        jl short .134
        mov eax, 7
        sub eax, ebx
        mov word [regd3], ax
.134:
        cmp word [regd3], byte 2
        jl short .135
        mov eax, dword [puckz]
        cmp word [eax], byte 0Ah
        jge short .135
        mov eax, dword [puckvz]
        cmp word [eax], 800h
        jge short .135
        add word [regd0], byte 6
        jmp short .136
.135:
        mov eax, dword [puckz]
        cmp word [eax], byte 8
        jge short .136
        mov eax, dword [puckvz]
        cmp word [eax], 800h
        jge short .136
        add word [regd0], byte 4
        cmp word [byte edi+02h], byte 9
        jb short .136
        mov ax, word [byte esi+facedir]
        cmp ax, 2
        je short .136
        cmp ax, 6
        je short .136
        mov eax, dword [puckc]
        cmp byte [eax], 0
        jl short .136
        sub word [regd0], byte 2
.136:
        or byte [byte esi+pflags], 20h
        or byte [byte esi+pflags2], 2
        mov edx, dword [regd0-2]
        sar edx, 10h
        mov edx, dword [nosplit edx*2+goaliesave_saveanim_m2]
        sar edx, 10h
        mov eax, esi
        call SetSPA
        mov dx, word [crowdlevel]
        cmp dx, 4B0h
        jg short .137
        mov ebx, edx
        add ebx, 96h
        mov word [crowdlevel], bx
        cmp bx, 4B0h
        jle short .137
        mov word [crowdlevel], 4B0h
.137:
        mov ax, word [edi]
        mov word [regd0], ax
        mov eax, dword [pucky]
        mov dx, word [eax]
        test dx, dx
        jge short .138
        movsx eax, dx
        neg eax
        jmp short .139
.138:
        movsx eax, dx
.139:
        cmp eax, 0DCh
        jle short .142
        mov eax, dword [puckx]
        cmp word [eax], byte 0
        jle short .140
        mov eax, 18h
        jmp short .141
.140:
        mov eax, 0FFFFFFE8h
.141:
        mov word [regd0], ax
.142:
        mov ax, word [regd2]
        mov word [regd1], ax
        mov edx, dword [byte esi+0Ah]
        sar edx, 18h
        mov eax, dword [esi]
        sar eax, 10h
        add edx, eax
        mov eax, dword [regd0-2]
        sar eax, 10h
        sub eax, edx
        mov word [regd0], ax
        mov eax, dword [byte esi+0Ch]
        sar eax, 18h
        mov edx, dword [byte esi+Ypos]
        sar edx, 10h
        add edx, eax
        mov eax, dword [regd1-2]
        sar eax, 10h
        sub eax, edx
        mov word [regd1], ax
        test ebp, ebp
        je short .147
        mov edx, 5
        cmp word [regd0], byte 0
        jge short .143
        mov eax, dword [regd0-2]
        sar eax, 10h
        neg eax
        jmp short .144
.143:
        mov eax, dword [regd0-2]
        sar eax, 10h
.144:
        movsx ebx, dx
        cmp eax, ebx
        jge short .147
        cmp word [regd1], byte 0
        jge short .145
        mov eax, dword [regd1-2]
        sar eax, 10h
        neg eax
        jmp short .146
.145:
        mov eax, dword [regd1-2]
        sar eax, 10h
.146:
        movsx edx, dx
        cmp eax, edx
        jge short .147
        xor eax, eax
        mov word [regd1], ax
        mov word [regd0], ax
.147:
        mov edx, dword [regd1-2]
        sar edx, 10h
        mov eax, dword [regd0-2]
        sar eax, 10h
        call vtoa
        mov byte [byte esi+028h], al
        cbw
        mov word [regd2], ax
        cmp ax, 7
        jg near assgoalie.28
.148:
        mov edx, dword [regd2-2]
        sar edx, 10h
        mov eax, esi
        call playeracc
assgoalie_popebp:
        pop ebp
        jmp near ass_popx
;-----------------------------------------------------------------------------
; CountPuckThreat                              4C632  95 PC, medium confidence
; Counts the opposing skaters (other team's 6 sprites) within 14h of the puck
; (plus the player's offset) into threat
;-----------------------------------------------------------------------------
; C: src/engine/referee/assrefwhistle.c (CountPuckThreat)
%ifdef CBUILD
%include "c/engine/referee/assrefwhistle.CountPuckThreat.inc"
%else
CountPuckThreat:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ecx, dword [byte eax+0Ah]
        sar ecx, 18h
        mov edx, dword [puckx]
        movsx edx, word [edx]
        add ecx, edx
        mov edi, ecx
        mov ecx, dword [byte eax+0Ch]
        sar ecx, 18h
        mov edx, dword [pucky]
        movsx edx, word [edx]
        add edx, ecx
        mov esi, edx
        xor edx, edx
        mov word [threat], dx
        cmp word [byte eax+06Ah], byte 6
        jge short .1
        mov eax, 6
        jmp short .2
.1:
        xor eax, eax
.2:
        shl eax, 7
        add eax, SortCords
        xor ebx, ebx
        jmp short .9
.3:
        mov edx, dword [byte eax+0Ah]
        sar edx, 18h
        mov ecx, dword [eax]
        sar ecx, 10h
        add ecx, edx
        movsx edx, di
        sub ecx, edx
        mov edx, ecx
        test cx, cx
        jge short .4
        movsx edx, cx
        neg edx
        jmp short .5
.4:
        movsx edx, cx
.5:
        cmp edx, byte 14h
        jg short .8
        mov ecx, dword [byte eax+0Ch]
        sar ecx, 18h
        mov edx, dword [byte eax+04h]
        sar edx, 10h
        add edx, ecx
        movsx ecx, si
        sub edx, ecx
        test dx, dx
        jge short .6
        movsx edx, dx
        neg edx
        jmp short .7
.6:
        movsx edx, dx
.7:
        cmp edx, byte 14h
        jg short .8
        inc word [threat]
.8:
        add eax, 80h
        inc ebx
.9:
        cmp bx, byte 6
        jl short CountPuckThreat.3
        jmp near ass_popx
%endif ; C
