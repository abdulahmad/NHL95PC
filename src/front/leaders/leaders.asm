; League leaders screen and its sort orders (95G stats95).
bits 32
%include "hockey.inc"
section s_25144 progbits alloc exec nowrite align=1
extern __CHK, AllocMemBlock, cddriveptr, DrawArt, DrawShape, fileoncd, FindShape, FitPlayerName
extern fputchar, FreeMemBlock, j___close_, kaufmfont, leadercolhdrs, leadercolhdrs_c1, leadercolhdrs_c2, leadercolhdrs_c3
extern leadercolhdrs_c4, leadersortfns, leadertitles, LoadBank, lseek_, mainfont, MakePath, MakeStatsTitle
extern open_, PrintCenteredText, printfbuf, PrintFmt1, PrintFmt2, PrintOutlinedText, PrintShadowText, qsort_
extern read_, SetClipWindow, SetTextColors, sprintf_, statsbgnames, statsbgshapes, statsfromleague, statsgoaliebuf
extern statsleague, statspalshape, statsplayerbuf, statsplayerdbs, statsplayoffs, statsskaterbuf, statssortkeys, statsteambuf
extern statsteamdbs, str_Addsort2, str_Bkgd2, str_C2, str_fmt2d, str_fmt3d, str_fmt4d, str_fmt5d
extern str_fmtMinSec, str_fmtPct, str_fmtPct0, str_fmtTenths, str_GP6, str_Gstat, str_KeyDb2, str_Keys
extern str_NO, str_PLAYER2, str_POS, str_Pst26, str_Pstat, str_Pstatbar7, str_StatsUnavailable2, str_TEAM
extern sub_B4BA8, TextGridOff, TextGridOpen, TextRestoreState, TextSaveState, TextSetFont, treecol_Er1, treecol_Er2
extern treecol_Wr2, treecolslots, treecolx, treerowy
global CmpGoals, CmpAssists, CmpPPGoals, CmpSHGoals, CmpPlusMinus, CmpPIM, CmpShootPct, CmpGoalieWins
global CmpSavePct, LeadersScreen_coljt, LeadersScreen, LeadersScreen_colPPG, LeadersScreen_colSHG, LeadersScreen_colPIM, LeadersScreen_colPlusMinus, LeadersScreen_colShootPct
global LeadersScreen_colDefault, LeadersScreen_colGAA, LeadersScreen_colWins, LeadersScreen_colSavePct, stand_tmpl1, stand_tmpl2, CmpConfStandings, CmpConfStandings_m
global TeamFromMouse
;-----------------------------------------------------------------------------
; CmpGoals                                                        25144  95 PC
; Leadersortfns[1] (Goal Leaders)
;-----------------------------------------------------------------------------
; C: src/front/leaders/CmpGoals.c
%ifdef CBUILD
%include "c/front/leaders/CmpGoals.inc"
%else
CmpGoals:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        mov ebx, edx
        cmp dword [statsplayoffs], byte 0
        jne short .1
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 4
        sub eax, edx
        mov edx, dword [statsskaterbuf]
        add eax, edx
        jmp short .2
.1:
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 4
        sub eax, edx
        mov edx, dword [statsskaterbuf]
        add eax, edx
        add eax, byte 12h
.2:
        mov edx, eax
        cmp dword [statsplayoffs], byte 0
        jne short .3
        mov ebx, dword [ebx]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 4
        sub eax, ebx
        mov ebx, dword [statsskaterbuf]
        add eax, ebx
        jmp short .4
.3:
        mov ebx, dword [ebx]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 4
        sub eax, ebx
        mov ebx, eax
        mov eax, dword [statsskaterbuf]
        add eax, ebx
        add eax, byte 12h
.4:
        mov bx, word [byte eax+02h]
        mov cx, word [byte edx+02h]
        cmp bx, cx
        je short .6
        mov eax, ebx
        and eax, 0FFFFh
        mov edx, ecx
.5:
        and edx, 0FFFFh
        jmp short .9
.6:
        mov bx, word [eax]
        mov si, word [edx]
        cmp bx, si
        je short .7
        mov edx, esi
        and edx, 0FFFFh
        mov eax, ebx
        and eax, 0FFFFh
        sub edx, eax
        mov eax, edx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.7:
        mov bx, word [byte eax+06h]
        mov di, word [byte edx+06h]
        cmp bx, di
        je short .8
        mov eax, ebx
        and eax, 0FFFFh
        mov edx, edi
        jmp short CmpGoals.5
.8:
        mov eax, dword [byte eax+0Eh]
        sar eax, 10h
        mov edx, dword [byte edx+0Eh]
        sar edx, 10h
.9:
        sub eax, edx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CmpAssists                                                      25237  95 PC
; Leadersortfns[2] (Assist Leaders)
;-----------------------------------------------------------------------------
; C: src/front/leaders/CmpAssists.c
%ifdef CBUILD
%include "c/front/leaders/CmpAssists.inc"
%else
CmpAssists:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        mov ebx, edx
        cmp dword [statsplayoffs], byte 0
        jne short .1
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 4
        sub eax, edx
        mov edx, dword [statsskaterbuf]
        add eax, edx
        jmp short .2
.1:
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 4
        sub eax, edx
        mov edx, dword [statsskaterbuf]
        add eax, edx
        add eax, byte 12h
.2:
        mov edx, eax
        cmp dword [statsplayoffs], byte 0
        jne short .3
        mov ebx, dword [ebx]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 4
        sub eax, ebx
        mov ebx, dword [statsskaterbuf]
        add eax, ebx
        jmp short .4
.3:
        mov ebx, dword [ebx]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 4
        sub eax, ebx
        mov ebx, eax
        mov eax, dword [statsskaterbuf]
        add eax, ebx
        add eax, byte 12h
.4:
        mov bx, word [byte eax+04h]
        mov cx, word [byte edx+04h]
        cmp bx, cx
        je short .6
        mov eax, ebx
        and eax, 0FFFFh
        mov edx, ecx
.5:
        and edx, 0FFFFh
        jmp short .9
.6:
        mov bx, word [eax]
        mov si, word [edx]
        cmp bx, si
        je short .7
        xor ebx, ebx
        mov bx, word [eax]
        xor eax, eax
        mov ax, si
        sub ebx, eax
        mov eax, ebx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.7:
        mov bx, word [byte eax+06h]
        mov di, word [byte edx+06h]
        cmp bx, di
        je short .8
        mov eax, ebx
        and eax, 0FFFFh
        mov edx, edi
        jmp short CmpAssists.5
.8:
        mov eax, dword [byte eax+0Eh]
        sar eax, 10h
        mov edx, dword [byte edx+0Eh]
        sar edx, 10h
.9:
        sub eax, edx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CmpPPGoals                                                      25325  95 PC
; Leadersortfns[3] (Power Play Goal Leaders)
;-----------------------------------------------------------------------------
; C: src/front/leaders/CmpPPGoals.c
%ifdef CBUILD
%include "c/front/leaders/CmpPPGoals.inc"
%else
CmpPPGoals:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        mov ebx, edx
        cmp dword [statsplayoffs], byte 0
        jne short .1
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 4
        sub eax, edx
        mov edx, dword [statsskaterbuf]
        add eax, edx
        jmp short .2
.1:
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 4
        sub eax, edx
        mov edx, dword [statsskaterbuf]
        add eax, edx
        add eax, byte 12h
.2:
        mov edx, eax
        cmp dword [statsplayoffs], byte 0
        jne short .3
        mov ebx, dword [ebx]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 4
        sub eax, ebx
        mov ebx, dword [statsskaterbuf]
        add eax, ebx
        jmp short .4
.3:
        mov ebx, dword [ebx]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 4
        sub eax, ebx
        mov ebx, dword [statsskaterbuf]
        add eax, ebx
        add eax, byte 12h
.4:
        mov bx, word [byte eax+08h]
        mov cx, word [byte edx+08h]
        cmp bx, cx
        je short .5
        xor ebx, ebx
        mov bx, word [byte eax+08h]
        xor eax, eax
        mov ax, cx
        jmp short .10
.5:
        mov bx, word [eax]
        mov si, word [edx]
        cmp bx, si
        je short .6
        mov edx, esi
        and edx, 0FFFFh
        mov eax, ebx
        and eax, 0FFFFh
        sub edx, eax
        mov eax, edx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.6:
        mov bx, word [byte eax+06h]
        mov di, word [byte edx+06h]
        cmp bx, di
        je short .8
        mov eax, ebx
        and eax, 0FFFFh
        mov edx, edi
.7:
        and edx, 0FFFFh
        sub eax, edx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.8:
        mov bx, word [byte eax+02h]
        mov cx, word [byte edx+02h]
        cmp bx, cx
        je short .9
        mov eax, ebx
        and eax, 0FFFFh
        mov edx, ecx
        jmp short CmpPPGoals.7
.9:
        mov ebx, dword [byte eax+0Eh]
        sar ebx, 10h
        mov eax, dword [byte edx+0Eh]
        sar eax, 10h
.10:
        sub ebx, eax
        mov eax, ebx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CmpSHGoals                                                      25438  95 PC
; Leadersortfns[4] (Shorthanded Goal Leaders)
;-----------------------------------------------------------------------------
; C: src/front/leaders/CmpSHGoals.c
%ifdef CBUILD
%include "c/front/leaders/CmpSHGoals.inc"
%else
CmpSHGoals:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        mov ebx, edx
        cmp dword [statsplayoffs], byte 0
        jne short .1
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 4
        sub eax, edx
        mov edx, dword [statsskaterbuf]
        add eax, edx
        jmp short .2
.1:
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 4
        sub eax, edx
        mov edx, dword [statsskaterbuf]
        add eax, edx
        add eax, byte 12h
.2:
        mov edx, eax
        cmp dword [statsplayoffs], byte 0
        jne short .3
        mov ebx, dword [ebx]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 4
        sub eax, ebx
        mov ebx, dword [statsskaterbuf]
        add eax, ebx
        jmp short .4
.3:
        mov ebx, dword [ebx]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 4
        sub eax, ebx
        mov ebx, dword [statsskaterbuf]
        add eax, ebx
        add eax, byte 12h
.4:
        mov bx, word [byte eax+0Ah]
        mov cx, word [byte edx+0Ah]
        cmp bx, cx
        je short .5
        xor ebx, ebx
        mov bx, word [byte eax+0Ah]
        xor eax, eax
        mov ax, cx
        jmp short .10
.5:
        mov bx, word [eax]
        mov si, word [edx]
        cmp bx, si
        je short .6
        mov edx, esi
        and edx, 0FFFFh
        mov eax, ebx
        and eax, 0FFFFh
        sub edx, eax
        mov eax, edx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.6:
        mov bx, word [byte eax+06h]
        mov di, word [byte edx+06h]
        cmp bx, di
        je short .8
        mov eax, ebx
        and eax, 0FFFFh
        mov edx, edi
.7:
        and edx, 0FFFFh
        sub eax, edx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.8:
        mov bx, word [byte eax+02h]
        mov cx, word [byte edx+02h]
        cmp bx, cx
        je short .9
        mov eax, ebx
        and eax, 0FFFFh
        mov edx, ecx
        jmp short CmpSHGoals.7
.9:
        mov ebx, dword [byte eax+0Eh]
        sar ebx, 10h
        mov eax, dword [byte edx+0Eh]
        sar eax, 10h
.10:
        sub ebx, eax
        mov eax, ebx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CmpPlusMinus                                                    2554B  95 PC
; Leadersortfns[5] (Plus/Minus Leaders)
;-----------------------------------------------------------------------------
; C: src/front/leaders/CmpPlusMinus.c
%ifdef CBUILD
%include "c/front/leaders/CmpPlusMinus.inc"
%else
CmpPlusMinus:
        push dword 10h
        call __CHK
        push ebx
        push esi
        push edi
        mov ebx, edx
        cmp dword [statsplayoffs], byte 0
        jne short .1
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 4
        sub eax, edx
        mov edx, dword [statsskaterbuf]
        add eax, edx
        jmp short .2
.1:
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 4
        sub eax, edx
        mov edx, dword [statsskaterbuf]
        add eax, edx
        add eax, byte 12h
.2:
        mov edx, eax
        cmp dword [statsplayoffs], byte 0
        jne short .3
        mov ebx, dword [ebx]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 4
        sub eax, ebx
        mov ebx, dword [statsskaterbuf]
        add eax, ebx
        jmp short .4
.3:
        mov ebx, dword [ebx]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 4
        sub eax, ebx
        mov ebx, eax
        mov eax, dword [statsskaterbuf]
        add eax, ebx
        add eax, byte 12h
.4:
        mov bx, word [byte eax+010h]
        cmp bx, word [byte edx+010h]
        je short .5
        mov eax, dword [byte eax+0Eh]
        sar eax, 10h
        mov edx, dword [byte edx+0Eh]
        sar edx, 10h
        jmp short .8
.5:
        mov bx, word [eax]
        mov si, word [edx]
        cmp bx, si
        je short .6
        mov edx, esi
        and edx, 0FFFFh
        mov eax, ebx
        and eax, 0FFFFh
        sub edx, eax
        mov eax, edx
        pop edi
        pop esi
        pop ebx
        ret
.6:
        mov bx, word [byte eax+06h]
        mov di, word [byte edx+06h]
        cmp bx, di
        je short .7
        mov eax, ebx
        and eax, 0FFFFh
        mov edx, edi
        and edx, 0FFFFh
        jmp short .8
.7:
        mov ax, word [byte eax+02h]
        and eax, 0FFFFh
        mov dx, word [byte edx+02h]
        and edx, 0FFFFh
.8:
        sub eax, edx
        pop edi
        pop esi
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CmpPIM                                                          25642  95 PC
; Leadersortfns[6] (Penalty Minute Leaders)
;-----------------------------------------------------------------------------
; C: src/front/leaders/CmpPIM.c
%ifdef CBUILD
%include "c/front/leaders/CmpPIM.inc"
%else
CmpPIM:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        mov ebx, edx
        cmp dword [statsplayoffs], byte 0
        jne short .1
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 4
        sub eax, edx
        mov edx, dword [statsskaterbuf]
        add eax, edx
        jmp short .2
.1:
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 4
        sub eax, edx
        mov edx, dword [statsskaterbuf]
        add eax, edx
        add eax, byte 12h
.2:
        mov edx, eax
        cmp dword [statsplayoffs], byte 0
        jne short .3
        mov ebx, dword [ebx]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 4
        sub eax, ebx
        mov ebx, dword [statsskaterbuf]
        add eax, ebx
        jmp short .4
.3:
        mov ebx, dword [ebx]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 4
        sub eax, ebx
        mov ebx, dword [statsskaterbuf]
        add eax, ebx
        add eax, byte 12h
.4:
        mov bx, word [byte eax+0Ch]
        mov cx, word [byte edx+0Ch]
        cmp bx, cx
        je short .5
        xor ebx, ebx
        mov bx, word [byte eax+0Ch]
        xor eax, eax
        mov ax, cx
        jmp short .10
.5:
        mov bx, word [eax]
        mov si, word [edx]
        cmp bx, si
        je short .6
        mov edx, esi
        and edx, 0FFFFh
        mov eax, ebx
        and eax, 0FFFFh
        sub edx, eax
        mov eax, edx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.6:
        mov bx, word [byte eax+06h]
        mov di, word [byte edx+06h]
        cmp bx, di
        je short .8
        mov eax, ebx
        and eax, 0FFFFh
        mov edx, edi
.7:
        and edx, 0FFFFh
        sub eax, edx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.8:
        mov bx, word [byte eax+02h]
        mov cx, word [byte edx+02h]
        cmp bx, cx
        je short .9
        mov eax, ebx
        and eax, 0FFFFh
        mov edx, ecx
        jmp short CmpPIM.7
.9:
        mov ebx, dword [byte eax+0Eh]
        sar ebx, 10h
        mov eax, dword [byte edx+0Eh]
        sar eax, 10h
.10:
        sub ebx, eax
        mov eax, ebx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CmpShootPct                                                     25755  95 PC
; Leadersortfns[7] (Shooting Percentage Leaders)
;-----------------------------------------------------------------------------
; C: src/front/leaders/CmpShootPct.c
%ifdef CBUILD
%include "c/front/leaders/CmpShootPct.inc"
%else
CmpShootPct:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        mov ebx, edx
        mov ecx, dword [edx]
        shl ecx, 2
        mov edx, dword [statssortkeys]
        add ecx, edx
        mov esi, dword [eax]
        shl esi, 2
        add edx, esi
        mov esi, dword [ecx]
        mov edi, dword [edx]
        cmp esi, edi
        je short .1
        mov eax, esi
        sub eax, edi
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.1:
        cmp dword [statsplayoffs], byte 0
        jne short .2
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 4
        sub eax, edx
        mov edx, dword [statsskaterbuf]
        add eax, edx
        jmp short .3
.2:
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 4
        sub eax, edx
        mov edx, eax
        mov eax, dword [statsskaterbuf]
        add eax, edx
        add eax, byte 12h
.3:
        mov edx, eax
        cmp dword [statsplayoffs], byte 0
        jne short .4
        mov ebx, dword [ebx]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 4
        sub eax, ebx
        mov ebx, dword [statsskaterbuf]
        add eax, ebx
        jmp short .5
.4:
        mov ebx, dword [ebx]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 4
        sub eax, ebx
        mov ebx, dword [statsskaterbuf]
        add eax, ebx
        add eax, byte 12h
.5:
        mov bx, word [eax]
        mov cx, word [edx]
        cmp bx, cx
        je short .6
        xor ebx, ebx
        mov bx, word [eax]
        xor eax, eax
        mov ax, cx
        jmp short .9
.6:
        mov bx, word [byte eax+06h]
        mov si, word [byte edx+06h]
        cmp bx, si
        je short .7
        mov eax, ebx
        and eax, 0FFFFh
        mov edx, esi
        and edx, 0FFFFh
        sub eax, edx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.7:
        mov bx, word [byte eax+02h]
        mov di, word [byte edx+02h]
        cmp bx, di
        je short .8
        xor ebx, ebx
        mov bx, word [byte eax+02h]
        xor eax, eax
        mov ax, di
        jmp short .9
.8:
        mov ebx, dword [byte eax+0Eh]
        sar ebx, 10h
        mov eax, dword [byte edx+0Eh]
        sar eax, 10h
.9:
        sub ebx, eax
        mov eax, ebx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CmpGoalieWins                                                   2586A  95 PC
; Leadersortfns[9] (Goaltender Win Leaders)
;-----------------------------------------------------------------------------
; C: src/front/leaders/CmpGoalieWins.c
%ifdef CBUILD
%include "c/front/leaders/CmpGoalieWins.inc"
%else
CmpGoalieWins:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        cmp dword [statsplayoffs], byte 0
        jne short .1
        mov ebx, dword [eax]
        mov eax, ebx
        shl eax, 3
        sub eax, ebx
        shl eax, 2
        sub eax, ebx
        lea ebx, [eax+eax]
        mov eax, dword [statsgoaliebuf]
        add eax, ebx
        jmp short .2
.1:
        mov ebx, dword [eax]
        mov eax, ebx
        shl eax, 3
        sub eax, ebx
        shl eax, 2
        sub eax, ebx
        add eax, eax
        mov ebx, dword [statsgoaliebuf]
        add eax, ebx
        add eax, byte 16h
.2:
        cmp dword [statsplayoffs], byte 0
        jne short .3
        mov ebx, dword [edx]
        mov edx, ebx
        shl edx, 3
        sub edx, ebx
        shl edx, 2
        sub edx, ebx
        add edx, edx
        mov ebx, dword [statsgoaliebuf]
        add ebx, edx
        jmp short .4
.3:
        mov ebx, dword [edx]
        mov edx, ebx
        shl edx, 3
        sub edx, ebx
        shl edx, 2
        sub edx, ebx
        add edx, edx
        mov ebx, dword [statsgoaliebuf]
        add ebx, edx
        add ebx, byte 16h
.4:
        mov edx, ebx
        mov cx, word [byte ebx+02h]
        mov si, word [byte eax+02h]
        cmp cx, si
        je short .5
        xor edx, ebx
        mov dx, cx
        mov eax, esi
        jmp near .13
.5:
        cmp dword [statsplayoffs], byte 0
        jne short .7
        mov cx, word [byte ebx+06h]
        mov di, word [byte eax+06h]
        cmp cx, di
        je short .7
        xor edx, ebx
        mov dx, cx
.6:
        mov eax, edi
        jmp near .13
.7:
        mov bx, word [byte edx+04h]
        mov cx, word [byte eax+04h]
        cmp bx, cx
        je short .9
        xor ebx, ebx
        mov bx, cx
        xor eax, eax
        mov ax, word [byte edx+04h]
.8:
        sub ebx, eax
        mov eax, ebx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.9:
        mov bx, word [edx]
        mov si, word [eax]
        cmp bx, si
        je short .10
        mov eax, esi
        and eax, 0FFFFh
        mov edx, ebx
        and edx, 0FFFFh
        sub eax, edx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.10:
        mov bx, word [byte edx+0Ch]
        mov di, word [byte eax+0Ch]
        cmp bx, di
        je short .11
        mov edx, ebx
        and edx, 0FFFFh
        jmp short CmpGoalieWins.6
.11:
        mov bx, word [byte edx+010h]
        mov cx, word [byte eax+010h]
        cmp bx, cx
        je short .12
        xor ebx, ebx
        mov bx, cx
        xor eax, eax
        mov ax, word [byte edx+010h]
        jmp short CmpGoalieWins.8
.12:
        mov dx, word [byte edx+014h]
        and edx, 0FFFFh
        mov ax, word [byte eax+014h]
.13:
        and eax, 0FFFFh
        sub edx, eax
        mov eax, edx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CmpSavePct                                                      259C0  95 PC
; Leadersortfns[10] (Save Percentage Leaders)
;-----------------------------------------------------------------------------
; C: src/front/leaders/CmpSavePct.c
%ifdef CBUILD
%include "c/front/leaders/CmpSavePct.inc"
%else
CmpSavePct:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        mov ebx, edx
        cmp dword [statsplayoffs], byte 0
        jne short .1
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        mov edx, dword [statsgoaliebuf]
        add eax, edx
        jmp short .2
.1:
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        mov edx, dword [statsgoaliebuf]
        add eax, edx
        add eax, byte 16h
.2:
        mov edx, eax
        cmp dword [statsplayoffs], byte 0
        jne short .3
        mov ebx, dword [ebx]
        mov eax, ebx
        shl eax, 3
        sub eax, ebx
        shl eax, 2
        sub eax, ebx
        add eax, eax
        mov ebx, dword [statsgoaliebuf]
        add eax, ebx
        jmp short .4
.3:
        mov ebx, dword [ebx]
        mov eax, ebx
        shl eax, 3
        sub eax, ebx
        shl eax, 2
        sub eax, ebx
        add eax, eax
        mov ebx, dword [statsgoaliebuf]
        add eax, ebx
        add eax, byte 16h
.4:
        mov bx, word [byte eax+014h]
        mov cx, word [byte edx+014h]
        cmp bx, cx
        je short .6
        xor ebx, ebx
        mov bx, word [byte eax+014h]
        xor eax, eax
        mov ax, cx
.5:
        sub ebx, eax
        mov eax, ebx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.6:
        mov bx, word [byte eax+0Ch]
        mov si, word [byte edx+0Ch]
        cmp bx, si
        je short .8
        mov eax, ebx
        and eax, 0FFFFh
        mov edx, esi
.7:
        and edx, 0FFFFh
        sub eax, edx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.8:
        mov bx, word [eax]
        mov di, word [edx]
        cmp bx, di
        je short .9
        xor ebx, ebx
        mov bx, word [eax]
        xor eax, eax
        mov ax, di
        jmp short CmpSavePct.5
.9:
        mov bx, word [byte eax+02h]
        mov cx, word [byte edx+02h]
        cmp bx, cx
        je short .10
        mov eax, ebx
        and eax, 0FFFFh
        mov edx, ecx
        jmp short CmpSavePct.7
.10:
        mov bx, word [byte eax+04h]
        mov si, word [byte edx+04h]
        cmp bx, si
        je short .11
        mov edx, esi
        and edx, 0FFFFh
        mov eax, ebx
        jmp short .12
.11:
        mov dx, word [byte edx+010h]
        and edx, 0FFFFh
        mov ax, word [byte eax+010h]
.12:
        and eax, 0FFFFh
        sub edx, eax
        mov eax, edx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
        db 08Bh,0C0h
LeadersScreen_coljt:
        dd LeadersScreen_colDefault
        dd LeadersScreen_colDefault
        dd LeadersScreen_colDefault
        dd LeadersScreen_colPPG
        dd LeadersScreen_colSHG
        dd LeadersScreen_colPlusMinus
        dd LeadersScreen_colPIM
        dd LeadersScreen_colShootPct
        dd LeadersScreen_colGAA
        dd LeadersScreen_colWins
        dd LeadersScreen_colSavePct
;-----------------------------------------------------------------------------
; LeadersScreen                                                   25B24  95 PC
; Player leaders table for statscategory 0-10 (titles leadertitles, sorts
; leadersortfns): POS PLAYER TEAM ...
;-----------------------------------------------------------------------------
; C: src/front/leaders/LeadersScreen.c
%ifdef CBUILD
%include "c/front/leaders/LeadersScreen.inc"
%else
LeadersScreen:
        push dword 2A0h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, 270h
        push eax
        xor edx, edx
        mov dword [dword esp+0258h], edx
        push byte 20h
        push dword 444h
        push str_Keys
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [statsplayerbuf], eax
        cmp dword [esp], byte 8
        jge short .1
        push byte 20h
        push dword 3DBh
        push str_Pstat
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [statsskaterbuf], eax
        jmp short .2
.1:
        push byte 20h
        push dword 46Eh
        push str_Gstat
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [statsgoaliebuf], eax
.2:
        cmp dword [esp], byte 7
        jne short .3
        push byte 20h
        push byte 54h
        push str_Addsort2
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [statssortkeys], eax
.3:
        mov esi, dword [esp]
        cmp esi, byte 8
        je short .4
        cmp esi, byte 0Ah
        je short .4
        cmp esi, byte 5
        je short .4
        cmp esi, byte 7
        jne near .11
.4:
        mov eax, dword [statsfromleague]
        mov ebx, dword [nosplit eax*4+statsteamdbs]
        xor ecx, ecx
        mov edx, statsleague
        lea eax, [dword esp+0238h]
        call MakePath
        push dword 200h
        lea eax, [dword esp+023Ch]
        push eax
        call open_
        add esp, byte 8
        mov esi, eax
        cmp dword [statsfromleague], byte 0
        jne short .5
        mov ecx, 4Ch
        jmp short .6
.5:
        mov ecx, 2E8h
.6:
        xor edi, edi
        mov dword [dword esp+026Ch], edi
.7:
        mov edx, dword [dword esp+026Ch]
        imul edx, ecx
        xor ebx, ebx
        mov eax, esi
        call lseek_
        mov ebx, 4Ch
        lea edx, [dword esp+0110h]
        mov eax, esi
        call read_
        cmp dword [statsplayoffs], byte 0
        jne short .8
        mov al, byte [dword esp+0138h]
        jmp short .9
.8:
        mov al, byte [dword esp+014Ah]
.9:
        xor edx, edx
        mov dl, al
        mov eax, dword [dword esp+026Ch]
        shl eax, 2
        mov dword [byte esp+eax+04h], edx
        mov edx, dword [statsfromleague]
        test edx, edx
        jne short .10
        cmp dword [statsplayoffs], byte 0
        jne short .10
        cmp dword [byte esp+eax+04h], byte 0
        jne short .10
        mov dword [byte esp+eax+04h], edx
.10:
        mov ebx, dword [dword esp+026Ch]
        inc ebx
        mov dword [dword esp+026Ch], ebx
        cmp ebx, byte 1Ah
        jl near LeadersScreen.7
        mov eax, esi
        call j___close_
.11:
        xor ecx, ecx
        mov ebx, str_KeyDb2
        mov edx, statsleague
        lea eax, [dword esp+0238h]
        call MakePath
        push dword 200h
        lea eax, [dword esp+023Ch]
        push eax
        call open_
        add esp, byte 8
        mov dword [dword esp+0260h], eax
        mov eax, dword [statsfromleague]
        mov ebx, dword [nosplit eax*4+statsplayerdbs]
        xor ecx, ecx
        mov edx, statsleague
        lea eax, [dword esp+0238h]
        call MakePath
        push dword 200h
        lea eax, [dword esp+023Ch]
        push eax
        call open_
        add esp, byte 8
        mov dword [dword esp+025Ch], eax
        jmp near .24
.12:
        mov edx, dword [dword esp+0200h]
.13:
        mov eax, dword [dword esp+025Ch]
        call lseek_
        mov ebx, 36h
        lea edx, [dword esp+019Ch]
        mov eax, dword [dword esp+025Ch]
        call read_
        cmp dword [statsplayoffs], byte 0
        jne short .14
        mov eax, dword [dword esp+019Ch]
        jmp short .15
.14:
        mov eax, dword [dword esp+01B2h]
.15:
        and eax, 0FFFFh
        je near .24
        mov edx, dword [esp]
        cmp edx, byte 8
        je short .16
        cmp edx, byte 0Ah
        jne short .17
.16:
        movzx esi, byte [dword esp+01D4h]
        shl esi, 2
        mov edi, dword [byte esp+esi+04h]
        test edi, edi
        je near .24
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add edx, eax
        shl edx, 2
        mov eax, edx
        sar edx, 1Fh
        idiv edi
        cmp eax, byte 1Eh
        jl near .24
        jmp short .20
.17:
        cmp edx, byte 9
        jne short .20
        cmp dword [statsplayoffs], byte 0
        jne short .18
        mov eax, dword [dword esp+019Eh]
        jmp short .19
.18:
        mov eax, dword [dword esp+01B4h]
.19:
        test ax, ax
        jbe near .24
.20:
        mov edx, dword [dword esp+0258h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        mov edi, dword [statsgoaliebuf]
        add edi, eax
        mov ecx, 0Dh
        lea esi, [dword esp+019Ch]
        rep movsd
        movsw
        mov ecx, dword [dword esp+0258h]
        cmp ecx, byte 14h
        jl short .21
        mov ebx, dword [esp]
        mov edx, ecx
        shl edx, 2
        sub edx, byte 4
        lea eax, [dword esp+0C0h]
        add edx, eax
        lea eax, [dword esp+0258h]
        call dword [nosplit ebx*4+leadersortfns]
        test eax, eax
        jge near .24
.21:
        mov esi, dword [dword esp+0258h]
        cmp esi, byte 14h
        jge short .22
        mov eax, esi
        shl eax, 2
        sub eax, esi
        shl eax, 2
        add eax, esi
        shl eax, 2
        mov edi, dword [statsplayerbuf]
        add edi, eax
        mov ecx, 0Dh
        lea esi, [dword esp+01D4h]
        rep movsd
        mov edx, dword [dword esp+0258h]
        mov dword [dword esp+edx*4+0C0h], edx
        lea edi, [byte edx+01h]
        mov dword [dword esp+0258h], edi
        jmp short .23
.22:
        mov eax, dword [dword esp+esi*4+0BCh]
        mov dword [dword esp+0270h], eax
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        mov edi, dword [statsplayerbuf]
        add edi, eax
        mov ecx, 0Dh
        lea esi, [dword esp+01D4h]
        rep movsd
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        mov edi, dword [statsgoaliebuf]
        add edi, eax
        mov ecx, 0Dh
        lea esi, [dword esp+019Ch]
        rep movsd
        movsw
.23:
        mov eax, dword [esp]
        mov ecx, dword [nosplit eax*4+leadersortfns]
        mov ebx, 4
        mov edx, dword [dword esp+0258h]
        lea eax, [dword esp+0C0h]
        call qsort_
.24:
        mov ebx, 34h
        lea edx, [dword esp+01D4h]
        mov eax, dword [dword esp+0260h]
        call read_
        cmp eax, byte 34h
        jne near .40
        cmp byte [dword esp+01D4h], 1Ah
        jae short LeadersScreen.24
        cmp byte [dword esp+01D6h], 47h
        jne short .25
        cmp dword [esp], byte 8
        jl short LeadersScreen.24
        xor ebx, ebx
        cmp dword [statsfromleague], byte 0
        jne near LeadersScreen.12
        mov edx, dword [dword esp+01FCh]
        jmp near LeadersScreen.13
.25:
        cmp dword [esp], byte 8
        jge short LeadersScreen.24
        xor ebx, ebx
        cmp dword [statsfromleague], byte 0
        jne short .26
        mov edx, dword [dword esp+01FCh]
        jmp short .27
.26:
        mov edx, dword [dword esp+0200h]
.27:
        mov eax, dword [dword esp+025Ch]
        call lseek_
        mov ebx, 2Fh
        lea edx, [dword esp+0208h]
        mov eax, dword [dword esp+025Ch]
        call read_
        cmp dword [statsplayoffs], byte 0
        jne short .28
        mov eax, dword [dword esp+0208h]
        jmp short .29
.28:
        mov eax, dword [dword esp+021Ah]
.29:
        and eax, 0FFFFh
        je near LeadersScreen.24
        mov edx, dword [esp]
        cmp edx, byte 5
        je short .30
        cmp edx, byte 7
        jne short .31
.30:
        movzx esi, byte [dword esp+01D4h]
        shl esi, 2
        mov ecx, dword [byte esp+esi+04h]
        test ecx, ecx
        je near LeadersScreen.24
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add edx, eax
        shl edx, 2
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        cmp eax, byte 50h
        jl near LeadersScreen.24
.31:
        mov edx, dword [dword esp+0258h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 4
        sub eax, edx
        mov edi, dword [statsskaterbuf]
        add edi, eax
        mov ecx, 0Bh
        lea esi, [dword esp+0208h]
        rep movsd
        movsw
        movsb
        cmp dword [esp], byte 7
        jne near .37
        cmp dword [statsplayoffs], byte 0
        jne short .32
        mov eax, dword [dword esp+0216h]
        jmp short .33
.32:
        mov eax, dword [dword esp+0228h]
.33:
        and eax, 0FFFFh
        mov dword [dword esp+0270h], eax
        je short .36
        cmp dword [statsplayoffs], byte 0
        jne short .34
        mov eax, dword [dword esp+020Ah]
        jmp short .35
.34:
        mov eax, dword [dword esp+021Ch]
.35:
        and eax, 0FFFFh
        mov dword [dword esp+026Ch], eax
        mov ebx, eax
        shl ebx, 5
        sub ebx, eax
        shl ebx, 2
        add ebx, eax
        shl ebx, 3
        mov eax, dword [dword esp+0270h]
        mov edx, eax
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        lea edx, [ebx+eax]
        mov eax, edx
        sar edx, 1Fh
        idiv dword [dword esp+0270h]
        mov edx, dword [dword esp+0258h]
        mov ebx, dword [statssortkeys]
        mov dword [ebx+edx*4], eax
        jmp short .37
.36:
        mov eax, dword [dword esp+0258h]
        mov edx, dword [statssortkeys]
        mov dword [edx+eax*4], 0
.37:
        mov edi, dword [dword esp+0258h]
        cmp edi, byte 14h
        jl short .38
        mov ecx, dword [esp]
        mov edx, edi
        shl edx, 2
        sub edx, byte 4
        lea eax, [dword esp+0C0h]
        add edx, eax
        lea eax, [dword esp+0258h]
        call dword [nosplit ecx*4+leadersortfns]
        test eax, eax
        jge near LeadersScreen.24
.38:
        mov eax, dword [dword esp+0258h]
        cmp eax, byte 14h
        jge short .39
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        mov edi, dword [statsplayerbuf]
        add edi, eax
        mov ecx, 0Dh
        lea esi, [dword esp+01D4h]
        rep movsd
        mov edx, dword [dword esp+0258h]
        mov dword [dword esp+edx*4+0C0h], edx
        lea ebx, [byte edx+01h]
        mov dword [dword esp+0258h], ebx
        jmp near LeadersScreen.23
.39:
        mov eax, dword [dword esp+eax*4+0BCh]
        mov dword [dword esp+0270h], eax
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        mov edi, dword [statsplayerbuf]
        add edi, eax
        mov ecx, 0Dh
        lea esi, [dword esp+01D4h]
        rep movsd
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 4
        sub eax, edx
        mov edi, dword [statsskaterbuf]
        add edi, eax
        mov ecx, 0Bh
        lea esi, [dword esp+0208h]
        rep movsd
        movsw
        movsb
        cmp dword [esp], byte 7
        jne near LeadersScreen.23
        mov edx, dword [dword esp+0258h]
        mov eax, dword [statssortkeys]
        mov ebx, dword [dword esp+0270h]
        mov edx, dword [eax+edx*4]
        mov dword [eax+ebx*4], edx
        jmp near LeadersScreen.23
.40:
        mov eax, dword [dword esp+025Ch]
        call j___close_
        mov eax, dword [dword esp+0260h]
        call j___close_
        mov edi, dword [mainfont]
        mov esi, dword [kaufmfont]
        call sub_B4BA8
        xor ecx, ecx
        mov ebx, dword [statsplayoffs]
        mov ebx, dword [nosplit ebx*4+statsbgnames]
        cmp byte [fileoncd+08Ch], 1
        jne short .41
        mov edx, dword [cddriveptr]
        jmp short .42
.41:
        xor edx, edx
.42:
        lea eax, [dword esp+0238h]
        call MakePath
        push byte 0
        lea eax, [dword esp+023Ch]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        push str_Bkgd2
        push eax
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        push dword 1E0h
        push byte 13h
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        mov eax, dword [statspalshape]
        push eax
        call DrawShape
        add esp, byte 4
        push dword 1E0h
        push byte 0
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        mov edx, dword [statsbgshapes]
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov ebx, str_Pstatbar7
        cmp byte [fileoncd+013Ch], 1
        jne short .43
        mov edx, dword [cddriveptr]
        jmp short .44
.43:
        xor edx, edx
.44:
        lea eax, [dword esp+0238h]
        call MakePath
        push byte 0
        lea eax, [dword esp+023Ch]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        push str_Pst26
        push eax
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        push byte 1Ch
        push byte 0
        push eax
        call DrawArt
        add esp, byte 0Ch
        mov ebx, dword [statsbgshapes]
        push ebx
        call FreeMemBlock
        add esp, byte 4
        lea eax, [dword esp+015Ch]
        push eax
        call TextSaveState
        add esp, byte 4
        push esi
        call TextSetFont
        add esp, byte 4
        call TextGridOpen
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        mov eax, dword [esp]
        mov edx, dword [nosplit eax*4+leadertitles]
        lea eax, [byte esp+06Ch]
        call MakeStatsTitle
        lea eax, [byte esp+06Ch]
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, 12Ch
        sub edx, eax
        mov eax, edx
        lea ebx, [byte esp+06Ch]
        mov edx, 31h
        call PrintOutlinedText
        push edi
        call TextSetFont
        add esp, byte 4
        cmp dword [dword esp+0258h], byte 0
        jne short .45
        push esi
        call TextSetFont
        add esp, byte 4
        mov edx, str_StatsUnavailable2
        mov eax, 0EBh
        call PrintCenteredText
        push edi
        call TextSetFont
        add esp, byte 4
        jmp near LeadersScreen_colDefault.2
.45:
        mov dword [dword esp+0264h], 5Ch
        mov ecx, dword [dword esp+0262h]
        sar ecx, 10h
        mov ebx, str_POS
        mov edx, ecx
        mov eax, 0Ah
        call PrintShadowText
        mov ebx, str_NO
        mov edx, ecx
        mov eax, 32h
        call PrintShadowText
        mov ebx, str_PLAYER2
        mov edx, ecx
        mov eax, 50h
        call PrintShadowText
        mov ebx, str_TEAM
        mov edx, ecx
        mov eax, 0FAh
        call PrintShadowText
        mov ebx, str_GP6
        mov edx, ecx
        mov eax, 172h
        call PrintShadowText
        mov edx, dword [esp]
        mov esi, edx
        shl esi, 2
        add esi, edx
        shl esi, 2
        mov ebx, dword [dword esi+leadercolhdrs]
        mov edx, ecx
        mov eax, 19Ah
        call PrintShadowText
        mov ebx, dword [dword esi+leadercolhdrs_c1]
        mov edx, ecx
        mov eax, 1CCh
        call PrintShadowText
        mov ebx, dword [dword esi+leadercolhdrs_c2]
        mov edx, ecx
        mov eax, 1F4h
        call PrintShadowText
        cmp dword [esp], byte 9
        jne short .46
        cmp dword [statsplayoffs], byte 1
        je short .47
.46:
        mov edx, dword [esp]
        mov eax, edx
        shl eax, 2
        add eax, edx
        mov ebx, dword [nosplit eax*4+leadercolhdrs_c3]
        mov edx, dword [dword esp+0262h]
        sar edx, 10h
        mov eax, 21Ch
        call PrintShadowText
.47:
        mov edx, dword [esp]
        mov eax, edx
        shl eax, 2
        add eax, edx
        mov ebx, dword [nosplit eax*4+leadercolhdrs_c4]
        mov edx, dword [dword esp+0262h]
        sar edx, 10h
        mov eax, 24Eh
        call PrintShadowText
        xor edx, edx
        mov dword [dword esp+026Ch], edx
        add dword [dword esp+0264h], byte 10h
        jmp near LeadersScreen_colDefault.1
.48:
        mov eax, dword [dword esp+eax*4+0C0h]
        mov dword [dword esp+0270h], eax
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        mov esi, dword [statsplayerbuf]
        add esi, eax
        mov ecx, 0Dh
        lea edi, [dword esp+01D4h]
        rep movsd
        mov eax, dword [dword esp+01D3h]
        sar eax, 18h
        push eax
        push str_C2
        push printfbuf
        call sprintf_
        add esp, byte 0Ch
        mov esi, dword [dword esp+0262h]
        sar esi, 10h
        mov ebx, printfbuf
        mov edx, esi
        mov eax, 0Ah
        call PrintShadowText
        mov bh, byte [dword esp+01D5h]
        cmp bh, 64h
        jae short .49
        xor ecx, ecx
        mov cl, bh
        mov ebx, str_fmt2d
        mov edx, esi
        mov eax, 32h
        call PrintFmt1
.49:
        mov ecx, 0A0h
        lea ebx, [dword esp+01E7h]
        lea edx, [dword esp+01D7h]
        mov eax, printfbuf
        call FitPlayerName
        mov edi, dword [dword esp+0262h]
        sar edi, 10h
        mov ebx, printfbuf
        mov edx, edi
        mov eax, 50h
        call PrintShadowText
        mov ebx, dword [statsteamdbs]
        xor ecx, ecx
        mov edx, statsleague
        lea eax, [dword esp+0238h]
        call MakePath
        push dword 200h
        lea eax, [dword esp+023Ch]
        push eax
        call open_
        mov esi, eax
        add esp, byte 8
        xor edx, edx
        mov dl, byte [dword esp+01D4h]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, eax
        shl edx, 2
        xor ebx, ebx
        mov eax, esi
        call lseek_
        mov ebx, 27h
        lea edx, [dword esp+0110h]
        mov eax, esi
        call read_
        mov eax, esi
        call j___close_
        lea ebx, [dword esp+012Ah]
        mov edx, edi
        mov eax, 0FAh
        call PrintShadowText
        cmp dword [esp], byte 8
        jge near .52
        mov edx, dword [dword esp+0270h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 4
        sub eax, edx
        cmp dword [statsplayoffs], byte 0
        jne short .50
        mov esi, dword [statsskaterbuf]
        add esi, eax
        jmp short .51
.50:
        mov edx, dword [statsskaterbuf]
        add eax, edx
        lea esi, [byte eax+012h]
.51:
        mov dword [dword esp+0268h], esi
        movsx ecx, word [esi]
        mov edi, dword [dword esp+0262h]
        sar edi, 10h
        mov ebx, str_fmt2d
        mov edx, edi
        mov eax, 172h
        call PrintFmt1
        mov ecx, dword [esi]
        sar ecx, 10h
        mov ebx, str_fmt3d
        mov edx, edi
        mov eax, 19Ah
        call PrintFmt1
        mov ecx, dword [byte esi+02h]
        sar ecx, 10h
        mov ebx, str_fmt3d
        mov edx, edi
        mov eax, 1CCh
        call PrintFmt1
        mov ecx, dword [byte esi+04h]
        sar ecx, 10h
        mov ebx, str_fmt3d
        mov edx, edi
        mov eax, 1F4h
        jmp short .55
.52:
        mov edx, dword [dword esp+0270h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        cmp dword [statsplayoffs], byte 0
        jne short .53
        mov esi, dword [statsgoaliebuf]
        add esi, eax
        jmp short .54
.53:
        mov edx, dword [statsgoaliebuf]
        add eax, edx
        lea esi, [byte eax+016h]
.54:
        mov ebp, esi
        movsx ecx, word [esi]
        mov edi, dword [dword esp+0262h]
        sar edi, 10h
        mov ebx, str_fmt2d
        mov edx, edi
        mov eax, 172h
        call PrintFmt1
        mov ecx, dword [byte esi+0Ah]
        sar ecx, 10h
        mov ebx, str_fmt4d
        mov edx, edi
        mov eax, 19Ah
.55:
        call PrintFmt1
        mov edi, dword [esp]
        cmp edi, byte 0Ah
        ja near LeadersScreen_colDefault
        mov eax, edi
        jmp dword [nosplit cs:eax*4+LeadersScreen_coljt]
LeadersScreen_colPPG:
        mov ecx, dword [dword esp+0268h]
        mov ecx, dword [byte ecx+06h]
        sar ecx, 10h
        mov edx, dword [dword esp+0262h]
        sar edx, 10h
        mov ebx, str_fmt2d
        jmp near LeadersScreen_colWins.2
LeadersScreen_colSHG:
        mov ecx, dword [dword esp+0268h]
        mov ecx, dword [byte ecx+08h]
.1:
        sar ecx, 10h
        mov edx, dword [dword esp+0262h]
        sar edx, 10h
        mov ebx, str_fmt3d
        jmp near LeadersScreen_colWins.2
LeadersScreen_colPIM:
        mov ecx, dword [dword esp+0268h]
        mov ecx, dword [byte ecx+0Ah]
        jmp short LeadersScreen_colSHG.1
LeadersScreen_colPlusMinus:
        mov ecx, dword [dword esp+0268h]
        mov ecx, dword [byte ecx+0Eh]
        sar ecx, 10h
        mov edx, dword [dword esp+0262h]
        sar edx, 10h
        mov ebx, str_fmt4d
        jmp near LeadersScreen_colWins.2
LeadersScreen_colShootPct:
        mov ecx, dword [dword esp+0268h]
        mov ecx, dword [byte ecx+0Ch]
        sar ecx, 10h
        mov edi, dword [dword esp+0262h]
        sar edi, 10h
        mov ebx, str_fmt5d
        mov edx, edi
        mov eax, 21Ch
        call PrintFmt1
        mov esi, dword [dword esp+0270h]
        shl esi, 2
        mov eax, dword [statssortkeys]
        add esi, eax
        mov ebx, 0Ah
        mov eax, dword [esi]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        movsx eax, dx
        push eax
        mov eax, dword [esi]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        movsx ecx, ax
        mov ebx, str_fmtTenths
        mov edx, edi
        mov eax, 24Eh
.1:
        call PrintFmt2
LeadersScreen_colDefault:
        add dword [dword esp+0264h], byte 0Dh
        inc dword [dword esp+026Ch]
.1:
        mov eax, dword [dword esp+026Ch]
        cmp eax, dword [dword esp+0258h]
        jl near LeadersScreen.48
.2:
        call TextGridOff
        lea eax, [dword esp+015Ch]
        push eax
        call TextRestoreState
        add esp, byte 4
        cmp dword [esp], byte 7
        jne short .3
        mov esi, dword [statssortkeys]
        push esi
        call FreeMemBlock
        add esp, byte 4
.3:
        cmp dword [esp], byte 8
        jge near LeadersScreen_colSavePct.2
        mov eax, dword [statsskaterbuf]
        push eax
        jmp near LeadersScreen_colSavePct.3
LeadersScreen_colGAA:
        mov ecx, dword [byte ebp+0Ch]
        sar ecx, 10h
        mov edi, dword [dword esp+0262h]
        sar edi, 10h
        mov ebx, str_fmt3d
        mov edx, edi
        mov eax, 1CCh
        call PrintFmt1
        xor esi, esi
        mov si, word [byte ebp+010h]
        mov ebx, 64h
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ebx
        movsx eax, dx
        push eax
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ebx
        movsx ecx, ax
        mov ebx, str_fmtMinSec
        mov edx, edi
        mov eax, 1F4h
        jmp near LeadersScreen_colShootPct.1
LeadersScreen_colWins:
        mov ecx, dword [byte ebp+00h]
        sar ecx, 10h
        mov esi, dword [dword esp+0262h]
        sar esi, 10h
        mov ebx, str_fmt2d
        mov edx, esi
        mov eax, 1CCh
        call PrintFmt1
        mov ecx, dword [byte ebp+02h]
        sar ecx, 10h
        mov ebx, str_fmt2d
        mov edx, esi
        mov eax, 1F4h
        call PrintFmt1
        cmp dword [statsplayoffs], byte 0
        jne near LeadersScreen_colDefault
        mov ecx, dword [byte ebp+04h]
        sar ecx, 10h
        mov ebx, str_fmt2d
.1:
        mov edx, esi
.2:
        mov eax, 21Ch
        call PrintFmt1
        jmp near LeadersScreen_colDefault
LeadersScreen_colSavePct:
        mov ecx, dword [byte ebp+0Ch]
        sar ecx, 10h
        mov esi, dword [dword esp+0262h]
        sar esi, 10h
        mov ebx, str_fmt3d
        mov edx, esi
        mov eax, 1CCh
        call PrintFmt1
        mov ecx, dword [byte ebp+010h]
        sar ecx, 10h
        mov ebx, str_fmt4d
        mov edx, esi
        mov eax, 1F4h
        call PrintFmt1
        mov dx, word [byte ebp+014h]
        cmp dx, 3E8h
        jae short .1
        xor edx, edx
        mov dx, word [byte ebp+014h]
        mov ebx, 3E8h
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        movsx ecx, dx
        mov ebx, str_fmtPct0
        jmp short LeadersScreen_colWins.1
.1:
        xor edi, edi
        mov di, dx
        mov ebx, 3E8h
        mov eax, edi
        mov edx, edi
        sar edx, 1Fh
        idiv ebx
        movsx eax, dx
        push eax
        mov eax, edi
        mov edx, edi
        sar edx, 1Fh
        idiv ebx
        movsx ecx, ax
        mov ebx, str_fmtPct
        mov edx, esi
        mov eax, 21Ch
        jmp near LeadersScreen_colShootPct.1
.2:
        mov ebp, dword [statsgoaliebuf]
        push ebp
.3:
        call FreeMemBlock
        add esp, byte 4
        mov edx, dword [statsplayerbuf]
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        add esp, 274h
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
stand_tmpl1:
        db 014h,00h,015h,00h,016h,00h,017h,00h,018h,00h
;-----------------------------------------------------------------------------
; stand_tmpl2                                                     269F4  95 PC
;-----------------------------------------------------------------------------
stand_tmpl2:
        xor al, byte [eax]
        xor dword [eax], eax
        xor byte [eax], al
        das
        add byte [esi], ch
        db 00h
CmpConfStandings:
        db 068h,02Ch,00h,00h,00h,0E8h,044h,05Fh,06h,00h,053h,051h,056h,057h
;-----------------------------------------------------------------------------
; CmpConfStandings_m                                              26A0C  95 PC
;-----------------------------------------------------------------------------
CmpConfStandings_m:
        push ebp
        mov ebp, esp
        sub esp, 14h
        mov dword [byte ebp-014h], eax
        mov dword [byte ebp-010h], edx
        mov eax, dword [byte ebp-014h]
        imul eax, dword [eax], byte 1Ah
        mov edx, dword [statsteambuf]
        add edx, eax
        mov dword [byte ebp-04h], edx
        mov eax, dword [byte ebp-010h]
        imul eax, dword [eax], byte 1Ah
        mov edx, dword [statsteambuf]
        add edx, eax
        mov dword [byte ebp-08h], edx
        mov eax, dword [byte ebp-08h]
        mov dl, byte [byte eax+0Dh]
        mov eax, dword [byte ebp-04h]
        cmp dl, byte [byte eax+0Dh]
        je short .1
        mov eax, dword [byte ebp-04h]
        xor edx, edx
        mov dl, byte [byte eax+0Dh]
        mov eax, dword [byte ebp-08h]
        mov al, byte [byte eax+0Dh]
        and eax, 0FFh
        sub edx, eax
        mov dword [byte ebp-0Ch], edx
        jmp near .7
.1:
        mov eax, dword [byte ebp-08h]
        mov dx, word [byte eax+016h]
        mov eax, dword [byte ebp-04h]
        cmp dx, word [byte eax+016h]
        je short .2
        mov eax, dword [byte ebp-08h]
        xor edx, edx
        mov dx, word [byte eax+016h]
        mov eax, dword [byte ebp-04h]
        mov ax, word [byte eax+016h]
        and eax, 0FFFFh
        sub edx, eax
        mov dword [byte ebp-0Ch], edx
        jmp near .7
.2:
        mov eax, dword [byte ebp-08h]
        mov dl, byte [byte eax+0Eh]
        mov eax, dword [byte ebp-04h]
        cmp dl, byte [byte eax+0Eh]
        je short .3
        mov eax, dword [byte ebp-04h]
        xor edx, edx
        mov dl, byte [byte eax+0Eh]
        mov eax, dword [byte ebp-08h]
        mov al, byte [byte eax+0Eh]
        and eax, 0FFh
        sub edx, eax
        mov dword [byte ebp-0Ch], edx
        jmp near .7
.3:
        mov eax, dword [byte ebp-08h]
        mov dl, byte [byte eax+0Fh]
        mov eax, dword [byte ebp-04h]
        cmp dl, byte [byte eax+0Fh]
        je short .4
        mov eax, dword [byte ebp-08h]
        xor edx, edx
        mov dl, byte [byte eax+0Fh]
        mov eax, dword [byte ebp-04h]
        mov al, byte [byte eax+0Fh]
        and eax, 0FFh
        sub edx, eax
        mov dword [byte ebp-0Ch], edx
        jmp short .7
.4:
        mov eax, dword [byte ebp-08h]
        mov dx, word [byte eax+012h]
        mov eax, dword [byte ebp-04h]
        cmp dx, word [byte eax+012h]
        je short .5
        mov eax, dword [byte ebp-08h]
        xor edx, edx
        mov dx, word [byte eax+012h]
        mov eax, dword [byte ebp-04h]
        mov ax, word [byte eax+012h]
        and eax, 0FFFFh
        sub edx, eax
        mov dword [byte ebp-0Ch], edx
        jmp short .7
.5:
        mov eax, dword [byte ebp-08h]
        mov dx, word [byte eax+014h]
        mov eax, dword [byte ebp-04h]
        cmp dx, word [byte eax+014h]
        je short .6
        mov eax, dword [byte ebp-04h]
        xor edx, edx
        mov dx, word [byte eax+014h]
        mov eax, dword [byte ebp-08h]
        mov ax, word [byte eax+014h]
        and eax, 0FFFFh
        sub edx, eax
        mov dword [byte ebp-0Ch], edx
        jmp short .7
.6:
        mov eax, dword [byte ebp-014h]
        mov eax, dword [eax]
        mov edx, dword [byte ebp-010h]
        sub eax, dword [edx]
        mov dword [byte ebp-0Ch], eax
.7:
        mov eax, dword [byte ebp-0Ch]
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; TeamFromMouse                                26B5A  95 PC, medium confidence
; Standings hit test: mouse x/y -> team row (two columns, rows of 0Dh px;
; playoff variant); called by RunTeamPickMenu
;-----------------------------------------------------------------------------
; C: src/front/leaders/TeamFromMouse.c
%ifdef CBUILD
%include "c/front/leaders/TeamFromMouse.inc"
%else
TeamFromMouse:
        push dword 3Ch
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 28h
        mov dword [byte ebp-028h], eax
        mov dword [byte ebp-024h], edx
        mov dword [byte ebp-020h], ebx
        add dword [byte ebp-028h], byte 4
        cmp dword [statsplayoffs], byte 0
        jne near .9
        mov eax, dword [byte ebp-020h]
        mov dword [eax], 0
        cmp dword [byte ebp-024h], 0A5h
        jge short .1
        mov dword [byte ebp-01Ch], 0
        jmp near .76
.1:
        cmp dword [byte ebp-028h], 140h
        jge near .5
        cmp dword [byte ebp-024h], 0F3h
        jge short .2
        mov edx, dword [byte ebp-024h]
        sub edx, 0A5h
        mov ebx, 0Dh
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov edx, dword [byte ebp-020h]
        mov dword [edx], eax
        mov dword [byte ebp-01Ch], 1
        jmp near .76
.2:
        cmp dword [byte ebp-024h], 14Ah
        jge short .3
        mov dword [byte ebp-01Ch], 0
        jmp near .76
.3:
        cmp dword [byte ebp-024h], 198h
        jge short .4
        mov edx, dword [byte ebp-024h]
        sub edx, 14Ah
        mov ebx, 0Dh
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov edx, dword [byte ebp-020h]
        add eax, byte 6
        mov dword [edx], eax
        mov dword [byte ebp-01Ch], 1
        jmp near .76
.4:
        jmp near .8
.5:
        cmp dword [byte ebp-024h], 100h
        jge short .6
        mov edx, dword [byte ebp-024h]
        sub edx, 0A5h
        mov ebx, 0Dh
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov edx, dword [byte ebp-020h]
        add eax, byte 0Ch
        mov dword [edx], eax
        mov dword [byte ebp-01Ch], 1
        jmp near .76
.6:
        cmp dword [byte ebp-024h], 14Ah
        jge short .7
        mov dword [byte ebp-01Ch], 0
        jmp near .76
.7:
        cmp dword [byte ebp-024h], 1A5h
        jge short .8
        mov edx, dword [byte ebp-024h]
        sub edx, 14Ah
        mov ebx, 0Dh
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov edx, dword [byte ebp-020h]
        add eax, byte 13h
        mov dword [edx], eax
        mov dword [byte ebp-01Ch], 1
        jmp near .76
.8:
        mov dword [byte ebp-01Ch], 0
        jmp near .76
.9:
        mov eax, dword [byte ebp-020h]
        mov dword [eax], 0
        cmp dword [byte ebp-024h], byte 4Ah
        jle short .10
        cmp dword [byte ebp-024h], byte 69h
        jl short .11
.10:
        jmp near .21
.11:
        mov dword [byte ebp-0Ch], 0
.12:
        cmp word [byte ebp-0Ch], byte 4
        jl short .14
        jmp near .20
.13:
        inc dword [byte ebp-0Ch]
        jmp short TeamFromMouse.12
.14:
        mov edx, dword [byte ebp-0Eh]
        sar edx, 10h
        shl edx, 2
        mov eax, dword [byte ebp-028h]
        cmp eax, dword [dword edx+treecolx]
        jl short .15
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        shl eax, 2
        mov eax, dword [dword eax+treecolx]
        add eax, byte 64h
        cmp eax, dword [byte ebp-028h]
        jge short .16
.15:
        jmp short .19
.16:
        cmp dword [byte ebp-024h], byte 5Ah
        jge short .17
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        add eax, eax
        xor edx, edx
        mov dl, byte [dword eax+treecolslots]
        mov eax, dword [byte ebp-020h]
        mov dword [eax], edx
        jmp short .18
.17:
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        add eax, eax
        xor edx, edx
        mov dl, byte [dword eax+treecolslots+1]
        mov eax, dword [byte ebp-020h]
        mov dword [eax], edx
.18:
        mov dword [byte ebp-01Ch], 1
        jmp near .76
.19:
        jmp short TeamFromMouse.13
.20:
        mov dword [byte ebp-01Ch], 0
        jmp near .76
.21:
        cmp dword [byte ebp-024h], 99h
        jle short .22
        cmp dword [byte ebp-024h], 0B9h
        jl short .23
.22:
        jmp near .33
.23:
        mov word [byte ebp-0Ch], 0
.24:
        cmp word [byte ebp-0Ch], byte 2
        jl short .26
        jmp near .32
.25:
        inc word [byte ebp-0Ch]
        jmp short TeamFromMouse.24
.26:
        mov edx, dword [byte ebp-0Eh]
        sar edx, 10h
        shl edx, 2
        mov eax, dword [byte ebp-028h]
        cmp eax, dword [dword edx+treerowy]
        jl short .27
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        shl eax, 2
        mov eax, dword [dword eax+treerowy]
        add eax, byte 64h
        cmp eax, dword [byte ebp-028h]
        jge short .28
.27:
        jmp short .31
.28:
        cmp dword [byte ebp-024h], 0A9h
        jge short .29
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        add eax, eax
        xor edx, edx
        mov dl, byte [dword eax+treecol_Wr2]
        mov eax, dword [byte ebp-020h]
        mov dword [eax], edx
        jmp short .30
.29:
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        add eax, eax
        xor edx, edx
        mov dl, byte [dword eax+treecol_Wr2+1]
        mov eax, dword [byte ebp-020h]
        mov dword [eax], edx
.30:
        mov dword [byte ebp-01Ch], 1
        jmp near .76
.31:
        jmp short TeamFromMouse.25
.32:
        mov dword [byte ebp-01Ch], 0
        jmp near .76
.33:
        cmp dword [byte ebp-024h], 0E5h
        jle short .34
        cmp dword [byte ebp-024h], 104h
        jl short .35
.34:
        jmp near .51
.35:
        cmp dword [byte ebp-028h], byte 48h
        jl short .36
        cmp dword [byte ebp-028h], 0ACh
        jle short .37
.36:
        jmp short .40
.37:
        cmp dword [byte ebp-024h], 0F5h
        jge short .38
        xor edx, edx
        mov dl, byte [treecolslots+10h]
        mov eax, dword [byte ebp-020h]
        mov dword [eax], edx
        jmp short .39
.38:
        xor edx, edx
        mov dl, byte [treecolslots+11h]
        mov eax, dword [byte ebp-020h]
        mov dword [eax], edx
.39:
        mov dword [byte ebp-01Ch], 1
        jmp near .76
.40:
        cmp dword [byte ebp-028h], 10Ch
        jl short .41
        cmp dword [byte ebp-028h], 170h
        jle short .42
.41:
        jmp short .45
.42:
        cmp dword [byte ebp-024h], 0F2h
        jge short .43
        xor edx, edx
        mov dl, byte [treecolslots+18h]
        mov eax, dword [byte ebp-020h]
        mov dword [eax], edx
        jmp short .44
.43:
        xor edx, edx
        mov dl, byte [treecolslots+28h]
        mov eax, dword [byte ebp-020h]
        mov dword [eax], edx
.44:
        mov dword [byte ebp-01Ch], 1
        jmp near .76
.45:
        cmp dword [byte ebp-028h], 1CDh
        jl short .46
        cmp dword [byte ebp-028h], 231h
        jle short .47
.46:
        jmp short .50
.47:
        cmp dword [byte ebp-024h], 0F5h
        jge short .48
        xor edx, edx
        mov dl, byte [treecolslots+30h]
        mov eax, dword [byte ebp-020h]
        mov dword [eax], edx
        jmp short .49
.48:
        xor edx, edx
        mov dl, byte [treecolslots+31h]
        mov eax, dword [byte ebp-020h]
        mov dword [eax], edx
.49:
        mov dword [byte ebp-01Ch], 1
        jmp near .76
.50:
        mov dword [byte ebp-01Ch], 0
        jmp near .76
.51:
        cmp dword [byte ebp-024h], 133h
        jle short .52
        cmp dword [byte ebp-024h], 152h
        jl short .53
.52:
        jmp near .63
.53:
        mov word [byte ebp-0Ch], 0
.54:
        cmp word [byte ebp-0Ch], byte 2
        jl short .56
        jmp near .62
.55:
        inc word [byte ebp-0Ch]
        jmp short TeamFromMouse.54
.56:
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        mov edx, 1
        sub edx, eax
        mov eax, edx
        shl eax, 2
        mov eax, dword [dword eax+treerowy]
        add eax, byte 64h
        mov edx, 280h
        sub edx, eax
        mov eax, edx
        cmp eax, dword [byte ebp-028h]
        jg short .57
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        mov edx, 1
        sub edx, eax
        mov eax, edx
        shl eax, 2
        mov edx, 280h
        sub edx, dword [dword eax+treerowy]
        mov eax, edx
        cmp eax, dword [byte ebp-028h]
        jge short .58
.57:
        jmp short .61
.58:
        cmp dword [byte ebp-024h], 143h
        jge short .59
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        add eax, eax
        xor edx, edx
        mov dl, byte [dword eax+treecol_Er2]
        mov eax, dword [byte ebp-020h]
        mov dword [eax], edx
        jmp short .60
.59:
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        add eax, eax
        xor edx, edx
        mov dl, byte [dword eax+treecol_Er2+1]
        mov eax, dword [byte ebp-020h]
        mov dword [eax], edx
.60:
        mov dword [byte ebp-01Ch], 1
        jmp near .76
.61:
        jmp near TeamFromMouse.55
.62:
        mov dword [byte ebp-01Ch], 0
        jmp near .76
.63:
        cmp dword [byte ebp-024h], 180h
        jle short .64
        cmp dword [byte ebp-024h], 19Fh
        jl short .65
.64:
        jmp near .75
.65:
        mov word [byte ebp-0Ch], 0
.66:
        cmp word [byte ebp-0Ch], byte 4
        jl short .68
        jmp near .74
.67:
        inc word [byte ebp-0Ch]
        jmp short TeamFromMouse.66
.68:
        mov edx, dword [byte ebp-0Eh]
        sar edx, 10h
        shl edx, 2
        mov eax, dword [byte ebp-028h]
        cmp eax, dword [dword edx+treecolx]
        jl short .69
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        shl eax, 2
        mov eax, dword [dword eax+treecolx]
        add eax, byte 64h
        cmp eax, dword [byte ebp-028h]
        jge short .70
.69:
        jmp short .73
.70:
        cmp dword [byte ebp-024h], 190h
        jge short .71
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        add eax, eax
        xor edx, edx
        mov dl, byte [dword eax+treecol_Er1]
        mov eax, dword [byte ebp-020h]
        mov dword [eax], edx
        jmp short .72
.71:
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        add eax, eax
        xor edx, edx
        mov dl, byte [dword eax+treecol_Er1+1]
        mov eax, dword [byte ebp-020h]
        mov dword [eax], edx
.72:
        mov dword [byte ebp-01Ch], 1
        jmp short .76
.73:
        jmp short TeamFromMouse.67
.74:
        mov dword [byte ebp-01Ch], 0
        jmp short .76
.75:
        mov dword [byte ebp-01Ch], 0
.76:
        mov eax, dword [byte ebp-01Ch]
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
