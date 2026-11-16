; Team grid (PC only).
bits 32
%include "hockey.inc"
section s_37B92 progbits alloc exec nowrite align=1
extern __CHK, AllocMemBlock, byte_D42C3, cddriveptr, crestnames, dlgtextbg, dlgtextfg, DrawArt
extern fileoncd, FindShape, fputchar, FreeMemBlock, GrabBlock, gridcellbuf, gridcellx, gridcelly
extern LoadBank, MakePath, memset_, PrintCenteredText, PrintShadowText, PutBlock, SetClipWindow, SetTextColors
extern str_Back, str_Callogo2, strcpy_, XorRectOutline, DrawFrameClipped
global TeamGridHitTest, DrawTeamGridName, SaveGridCellBg, RestoreGridCellBg, HighlightGridCell, DrawTeamGrid
;-----------------------------------------------------------------------------
; TeamGridHitTest                                                 37B92  95 PC
; (mx, my, grid): team in the 4 x 7 division grid cell under the mouse, -1
; for none / empty (63h)
;-----------------------------------------------------------------------------
; C: src/front/team_grid/TeamGridHitTest.c
%ifdef CBUILD
%include "c/front/team_grid/TeamGridHitTest.inc"
%else
TeamGridHitTest:
        push dword 24h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        mov ebp, eax
        mov edi, edx
        mov dword [esp], ebx
        mov dword [byte esp+04h], 0FFFFFFFFh
        xor ecx, ecx
.1:
        xor edx, edx
.2:
        mov eax, ecx
        shl eax, 3
        sub eax, ecx
        add eax, dword [esp]
        mov al, byte [edx+eax]
        and eax, 0FFh
        mov dword [byte esp+08h], eax
        mov eax, edx
        shl eax, 2
        add eax, edx
        mov ebx, eax
        shl eax, 4
        add eax, ebx
        cmp ecx, byte 2
        jge short .3
        lea ebx, [byte eax+040h]
        jmp short .4
.3:
        lea ebx, [byte eax+016h]
.4:
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 3
        sub eax, ecx
        shl eax, 2
        lea esi, [byte eax+058h]
        mov dword [byte esp+0Ch], esi
        lea esi, [byte ebx+046h]
        add eax, 91h
        cmp ebp, ebx
        jl short .5
        cmp ebp, esi
        jg short .5
        cmp edi, dword [byte esp+0Ch]
        jl short .5
        cmp edi, eax
        jg short .5
        mov eax, dword [byte esp+08h]
        mov dword [byte esp+04h], eax
        mov ecx, 4
        mov edx, 6
.5:
        inc edx
        cmp edx, byte 7
        jl short TeamGridHitTest.2
        inc ecx
        cmp ecx, byte 4
        jl near TeamGridHitTest.1
        mov ecx, dword [byte esp+04h]
        cmp ecx, byte 63h
        jne short .6
        mov eax, 0FFFFFFFFh
        jmp short .x
.6:
        mov eax, ecx
.x:
        add esp, byte 10h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawTeamGridName                                                37C53  95 PC
; Prints a team's name centred in its division grid cell
;-----------------------------------------------------------------------------
; C: src/front/team_grid/DrawTeamGridName.c
%ifdef CBUILD
%include "c/front/team_grid/DrawTeamGridName.inc"
%else
DrawTeamGridName:
        push dword 38h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 8
        push eax
        push edx
        push ebx
        push ecx
        mov edx, dword [dlgtextbg]
        mov eax, dword [dlgtextfg]
        call SetTextColors
        xor edx, edx
        mov dword [byte esp+014h], edx
.1:
        xor edi, edi
.2:
        mov edx, dword [byte esp+014h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        add eax, dword [esp]
        mov al, byte [edi+eax]
        and eax, 0FFh
        cmp eax, dword [byte esp+0Ch]
        jne near .5
        mov eax, edi
        shl eax, 2
        add eax, edi
        mov esi, eax
        shl eax, 4
        add eax, esi
        cmp edx, byte 2
        jge short .3
        lea esi, [byte eax+039h]
        jmp short .4
.3:
        lea esi, [byte eax+0Fh]
.4:
        mov ebp, dword [byte esp+014h]
        mov eax, ebp
        shl eax, 2
        sub eax, ebp
        shl eax, 3
        sub eax, ebp
        shl eax, 2
        lea ebp, [dword eax+097h]
        lea edx, [byte esi+04Dh]
        xor eax, eax
        mov al, byte [byte_D42C3]
        add eax, ebp
        inc eax
        push eax
        push ebp
        push edx
        push esi
        call SetClipWindow
        add esp, byte 10h
        push byte 0
        push byte 0
        mov eax, dword [byte esp+0Ch]
        push eax
        call DrawArt
        add esp, byte 0Ch
        push dword 1E0h
        push byte 0
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        mov edx, dword [byte esp+0Ch]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        add eax, eax
        mov edx, dword [byte esp+08h]
        add edx, eax
        mov dword [byte esp+010h], edx
        push edx
        call fputchar
        add esp, byte 4
        sar eax, 1
        add esi, byte 2Ah
        sub esi, eax
        mov ebx, dword [byte esp+010h]
        mov edx, ebp
        mov eax, esi
        call PrintShadowText
.5:
        inc edi
        cmp edi, byte 7
        jl near DrawTeamGridName.2
        mov ebx, dword [byte esp+014h]
        inc ebx
        mov dword [byte esp+014h], ebx
        cmp ebx, byte 4
        jl near DrawTeamGridName.1
        add esp, byte 18h
        pop ebp
        pop edi
        pop esi
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SaveGridCellBg                                                  37D6A  95 PC
; Allocates "back" and saves the screen under a team's grid cell
;-----------------------------------------------------------------------------
; C: src/front/team_grid/SaveGridCellBg.c
%ifdef CBUILD
%include "c/front/team_grid/SaveGridCellBg.inc"
%else
SaveGridCellBg:
        push dword 28h
        call __CHK
        push esi
        push edi
        push ebp
        push eax
        push edx
        push ebx
        mov ebp, ecx
        push byte 20h
        push dword 4688h
        push str_Back
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [gridcellbuf], eax
        mov ebx, 11h
        xor edx, edx
        call memset_
        mov eax, dword [gridcellbuf]
        mov word [byte eax+04h], 4Eh
        mov eax, dword [gridcellbuf]
        mov word [byte eax+06h], 41h
        xor edi, edi
.1:
        xor esi, esi
.2:
        mov eax, edi
        shl eax, 3
        sub eax, edi
        add eax, dword [byte esp+04h]
        mov al, byte [esi+eax]
        and eax, 0FFh
        cmp eax, dword [byte esp+08h]
        jne short .5
        mov eax, esi
        shl eax, 2
        add eax, esi
        mov edx, eax
        shl eax, 4
        add eax, edx
        cmp edi, byte 2
        jge short .3
        add eax, byte 3Ch
        jmp short .4
.3:
        add eax, byte 12h
.4:
        mov dword [gridcellx], eax
        mov eax, edi
        shl eax, 2
        sub eax, edi
        shl eax, 3
        sub eax, edi
        shl eax, 2
        add eax, byte 54h
        mov dword [gridcelly], eax
        mov ecx, dword [byte esp+01Ch]
        push ecx
        lea eax, [byte ebp-04h]
        push eax
        mov eax, dword [byte esp+08h]
        push eax
        call PutBlock
        add esp, byte 0Ch
        mov edx, dword [gridcelly]
        push edx
        mov ebx, dword [gridcellx]
        push ebx
        mov ecx, dword [gridcellbuf]
        push ecx
        call GrabBlock
        add esp, byte 0Ch
.5:
        inc esi
        cmp esi, byte 7
        jl near SaveGridCellBg.2
        inc edi
        cmp edi, byte 4
        jl near SaveGridCellBg.1
        add esp, byte 0Ch
        pop ebp
        pop edi
        pop esi
        ret 4
%endif ; C
;-----------------------------------------------------------------------------
; RestoreGridCellBg                                               37E5B  95 PC
; Restores and frees the saved grid cell
;-----------------------------------------------------------------------------
; C: src/front/team_grid/RestoreGridCellBg.c
%ifdef CBUILD
%include "c/front/team_grid/RestoreGridCellBg.inc"
%else
RestoreGridCellBg:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edi
        push ebp
        mov edx, dword [gridcellbuf]
        test edx, edx
        je short .x
        mov ebx, dword [gridcelly]
        push ebx
        mov ecx, dword [gridcellx]
        push ecx
        push edx
        call PutBlock
        add esp, byte 0Ch
        mov edi, dword [gridcellbuf]
        push edi
        call FreeMemBlock
        add esp, byte 4
        xor ebp, ebp
        mov dword [gridcellbuf], ebp
.x:
        pop ebp
        pop edi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; HighlightGridCell                                               37EA6  95 PC
; (on, grid, team): draws or erases the frame around a team's grid cell
;-----------------------------------------------------------------------------
; C: src/front/team_grid/HighlightGridCell.c
%ifdef CBUILD
%include "c/front/team_grid/HighlightGridCell.inc"
%else
HighlightGridCell:
        push dword 48h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 14h
        push eax
        push edx
        push ebx
        xor edi, edi
.1:
        xor esi, esi
.2:
        mov eax, edi
        shl eax, 3
        sub eax, edi
        add eax, dword [byte esp+04h]
        mov al, byte [esi+eax]
        and eax, 0FFh
        cmp eax, dword [byte esp+08h]
        jne near .7
        mov eax, esi
        shl eax, 2
        add eax, esi
        mov edx, eax
        shl eax, 4
        add eax, edx
        cmp edi, byte 2
        jge short .3
        lea edx, [byte eax+03Eh]
        jmp short .4
.3:
        lea edx, [byte eax+014h]
.4:
        mov eax, edi
        shl eax, 2
        sub eax, edi
        shl eax, 3
        sub eax, edi
        shl eax, 2
        lea ebx, [byte eax+056h]
        lea ebp, [byte edx+04Ah]
        mov dword [byte esp+0Ch], ebp
        lea ebp, [dword eax+093h]
        mov dword [byte esp+014h], ebp
        lea ebp, [byte edx-01h]
        mov dword [byte esp+018h], ebp
        lea ebp, [byte eax+055h]
        lea ecx, [byte edx+04Bh]
        mov dword [byte esp+01Ch], ecx
        add eax, 94h
        mov dword [byte esp+010h], eax
        mov ecx, dword [esp]
        test ecx, ecx
        je short .5
        push dword 80h
        mov ecx, dword [byte esp+018h]
        push ecx
        mov eax, dword [byte esp+014h]
        push eax
        push ebx
        push edx
        call XorRectOutline
        add esp, byte 14h
        push dword 80h
        mov edx, dword [byte esp+014h]
        push edx
        mov ebx, dword [byte esp+024h]
        push ebx
        push ebp
        mov ecx, dword [byte esp+028h]
        push ecx
        call XorRectOutline
        jmp short .6
.5:
        push ecx
        mov eax, dword [byte esp+018h]
        push eax
        mov ecx, dword [byte esp+014h]
        push ecx
        push ebx
        push edx
        call DrawFrameClipped
        add esp, byte 14h
        push byte 0
        mov eax, dword [byte esp+014h]
        push eax
        mov edx, dword [byte esp+024h]
        push edx
        push ebp
        mov ebx, dword [byte esp+028h]
        push ebx
        call DrawFrameClipped
.6:
        add esp, byte 14h
.7:
        inc esi
        cmp esi, byte 7
        jl near HighlightGridCell.2
        inc edi
        cmp edi, byte 4
        jl near HighlightGridCell.1
        add esp, byte 20h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawTeamGrid                                 37FBA  95 PC, medium confidence
; Centred title, callogo crest of each team in the division grid and their
; names (DrawTeamGridName)
;-----------------------------------------------------------------------------
; C: src/front/team_grid/DrawTeamGrid.c
%ifdef CBUILD
%include "c/front/team_grid/DrawTeamGrid.inc"
%else
DrawTeamGrid:
        push dword 0E8h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, 0C0h
        push eax
        push ebx
        push ecx
        lea eax, [byte esp+074h]
        call strcpy_
        lea edx, [byte esp+074h]
        mov eax, 28h
        call PrintCenteredText
        xor ecx, ecx
        mov ebx, str_Callogo2
        cmp byte [fileoncd+01C2h], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
        lea eax, [byte esp+074h]
        call MakePath
        push byte 0
        lea eax, [byte esp+078h]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [dword esp+0C8h], eax
        xor ebp, ebp
.3:
        mov edx, dword [nosplit ebp*4+crestnames]
        push edx
        mov ebx, dword [dword esp+0CCh]
        push ebx
        call FindShape
        add esp, byte 8
        mov dword [byte esp+ebp*4+0Ch], eax
        inc ebp
        cmp ebp, byte 1Ah
        jl short DrawTeamGrid.3
        xor ebp, ebp
.4:
        xor edi, edi
.5:
        mov eax, ebp
        shl eax, 3
        sub eax, ebp
        mov esi, dword [byte esp+04h]
        add esi, eax
        movzx esi, byte [edi+esi]
        cmp esi, byte 63h
        je short .9
        mov eax, edi
        shl eax, 2
        add eax, edi
        mov edx, eax
        shl eax, 4
        add eax, edx
        cmp ebp, byte 2
        jge short .6
        lea ebx, [byte eax+040h]
        jmp short .7
.6:
        lea ebx, [byte eax+016h]
.7:
        mov eax, ebp
        shl eax, 2
        sub eax, ebp
        shl eax, 3
        sub eax, ebp
        shl eax, 2
        add eax, byte 58h
        push eax
        push ebx
        mov ecx, dword [byte esp+esi*4+014h]
        push ecx
        call DrawArt
        add esp, byte 0Ch
        mov eax, esi
        shl eax, 4
        sub eax, esi
        add eax, eax
        add eax, dword [byte esp+08h]
        cmp byte [byte eax+017h], 1
        jne short .8
        mov ecx, dword [byte esp+04h]
        mov ebx, dword [esp]
        mov edx, dword [byte esp+08h]
        mov eax, esi
        call DrawTeamGridName
.8:
        inc edi
        cmp edi, byte 7
        jl short DrawTeamGrid.5
.9:
        inc ebp
        cmp ebp, byte 4
        jl near DrawTeamGrid.4
        mov ebx, dword [dword esp+0C8h]
        push ebx
        call FreeMemBlock
        add esp, byte 4
        add esp, 0CCh
        pop ebp
        pop edi
        pop esi
        ret
%endif ; C
