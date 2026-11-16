; Team stats screen and its sort orders (95G stats95).
bits 32
%include "hockey.inc"
section s_22DDE progbits alloc exec nowrite align=1
extern __CHK, AllocMemBlock, cddriveptr, DrawArt, DrawShape, eastconfname, eastconfteams, fileoncd
extern FindShape, fputchar, FreeMemBlock, j___close_, kaufmfont, LoadBank, lseek_, mainfont
extern MakePath, MakeStatsTitle, open_, OpenStatsSchedule, PrintCenteredText, PrintFmt1, PrintFmt2, PrintOutlinedText
extern PrintShadowText, qsort_, read_, SetClipWindow, SetTextColors, statsbgnames, statsbgshapes, statsfromleague
extern statsleague, statspalshape, statsplayoffs, statssortkeys, statsteamdbs, statsteamrecs, str_Addsort, str_ANA2
extern str_Bkgd2, str_Dashes36, str_Dashes39, str_fmt2d, str_fmt3d, str_fmt4d, str_fmtTenths, str_GP4
extern str_MightyDucksOfAnaheim, str_Pst24, str_Pstatbar5, str_StatsUnavailable, str_Teams, strnicmp_, SetScreenTarget, teamcolhdrs
extern teamconf, teamdivflags, teamsortfns, teamstattitles, TextGridOff, TextGridOpen, TextRestoreState, TextSaveState
extern TextSetFont, westconfname, westconfteams
global CmpTeamStandings, CmpTeamScoring, CmpTeamScoring_sub, CmpTeamScoring_ret8, CmpTeamScoring_common, CmpTeamDefense, CmpTeamPP, CmpTeamPP_tie
global CmpTeamPK, CmpTeamPK_sub, CmpTeamPK_ret10, CmpTeamPK_x, CmpTeamPenalties, TeamStatsScreen_keyjt, TeamStatsScreen_coljt, TeamStatsScreen
global TeamStatsScreen_keyStand, TeamStatsScreen_keyPK, TeamStatsScreen_keyPP, TeamStatsScreen_keyPen, TeamStatsScreen_colScoring, TeamStatsScreen_colDefense, TeamStatsScreen_colPK, TeamStatsScreen_colPP
global TeamStatsScreen_colPen
;-----------------------------------------------------------------------------
; CmpTeamStandings                                                22DDE  95 PC
; Teamsortfns[5] team sort (Team Standings)
;-----------------------------------------------------------------------------
; C: src/front/team_stats/CmpTeamStandings.c
%ifdef CBUILD
%include "c/front/team_stats/CmpTeamStandings.inc"
%else
CmpTeamStandings:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 0Ch
        mov ebx, eax
        mov esi, edx
        cmp dword [statsplayoffs], byte 0
        jne short .1
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov edx, dword [statsteamrecs]
        add eax, edx
        add eax, byte 28h
        jmp short .2
.1:
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov edx, dword [statsteamrecs]
        add eax, edx
        add eax, byte 3Ah
.2:
        mov edx, eax
        cmp dword [statsplayoffs], byte 0
        jne short .3
        mov ecx, dword [esi]
        mov eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 2
        mov ecx, dword [statsteamrecs]
        add eax, ecx
        add eax, byte 28h
        jmp short .4
.3:
        mov ecx, dword [esi]
        mov eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 2
        sub eax, ecx
        mov ecx, eax
        shl ecx, 2
        mov eax, dword [statsteamrecs]
        add eax, ecx
        add eax, byte 3Ah
.4:
        movzx ebp, byte [byte eax+01h]
        lea ecx, [byte ebp+ebp+00h]
        mov dword [esp], ecx
        xor ecx, ecx
        mov cl, byte [byte eax+03h]
        mov edi, dword [esp]
        add edi, ecx
        mov dword [byte esp+04h], edi
        xor ecx, ecx
        mov cl, byte [byte edx+01h]
        mov dword [byte esp+08h], ecx
        add ecx, ecx
        movzx edi, byte [byte edx+03h]
        add edi, ecx
        mov ecx, dword [byte esp+04h]
        cmp edi, ecx
        je short .5
        mov eax, ecx
        sub eax, edi
        jmp near .11
.5:
        mov cl, byte [eax]
        mov ch, byte [edx]
        cmp cl, ch
        je short .7
        mov dl, ch
        and edx, 0FFh
        mov al, cl
        and eax, 0FFh
.6:
        sub edx, eax
        mov eax, edx
        jmp short .11
.7:
        mov cl, byte [byte eax+01h]
        cmp cl, byte [byte edx+01h]
        je short .8
        mov eax, dword [byte esp+08h]
        sub ebp, eax
        mov eax, ebp
        jmp short .11
.8:
        mov cx, word [byte eax+04h]
        mov di, word [byte edx+04h]
        cmp cx, di
        je short .9
        xor ebx, ebx
        mov bx, cx
        xor eax, eax
        mov ax, di
        sub ebx, eax
        mov eax, ebx
        jmp short .11
.9:
        mov cx, word [byte eax+06h]
        mov di, word [byte edx+06h]
        cmp cx, di
        je short .10
        mov edx, edi
        and edx, 0FFFFh
        mov eax, ecx
        and eax, 0FFFFh
        jmp short CmpTeamStandings.6
.10:
        mov eax, dword [ebx]
        sub eax, dword [esi]
.11:
        add esp, byte 0Ch
        jmp near CmpTeamPK_x
%endif ; C
;-----------------------------------------------------------------------------
; CmpTeamScoring                                                  22F2E  95 PC
; Teamsortfns[0] (Team Scoring)
;-----------------------------------------------------------------------------
; C: src/front/team_stats/CmpTeamStandings.c (CmpTeamScoring)
%ifdef CBUILD
%include "c/front/team_stats/CmpTeamStandings.CmpTeamScoring.inc"
%else
CmpTeamScoring:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 8
        mov esi, eax
        mov ebx, edx
        cmp dword [statsplayoffs], byte 0
        jne short .1
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov edx, dword [statsteamrecs]
        add eax, edx
        add eax, byte 28h
        jmp short .2
.1:
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov edx, dword [statsteamrecs]
        add eax, edx
        add eax, byte 3Ah
.2:
        mov edx, eax
        cmp dword [statsplayoffs], byte 0
        jne short .3
        mov ecx, dword [ebx]
        mov eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 2
        mov ecx, dword [statsteamrecs]
        add eax, ecx
        add eax, byte 28h
        jmp short .4
.3:
        mov ecx, dword [ebx]
        mov eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 2
        mov ecx, dword [statsteamrecs]
        add eax, ecx
        add eax, byte 3Ah
.4:
        mov cx, word [byte eax+04h]
        mov di, word [byte edx+04h]
        cmp cx, di
        je short CmpTeamScoring_ret8.1
        xor ebx, ebx
        mov bx, cx
        xor eax, eax
        mov ax, di
CmpTeamScoring_sub:
        sub ebx, eax
        mov eax, ebx
CmpTeamScoring_ret8:
        add esp, byte 8
        jmp near CmpTeamPK_x
.1:
        mov cl, byte [eax]
        mov ch, byte [edx]
        cmp cl, ch
        je short CmpTeamScoring_common
        mov dl, ch
        and edx, 0FFh
        mov al, cl
        and eax, 0FFh
        sub edx, eax
        mov eax, edx
        jmp short CmpTeamScoring_ret8
CmpTeamScoring_common:
        xor ecx, ecx
        mov cl, byte [byte eax+01h]
        mov dword [byte esp+04h], ecx
        add ecx, ecx
        movzx edi, byte [byte eax+03h]
        add ecx, edi
        mov dword [esp], ecx
        movzx ebp, byte [byte edx+01h]
        lea ecx, [byte ebp+ebp+00h]
        movzx edi, byte [byte edx+03h]
        add edi, ecx
        mov ecx, dword [esp]
        cmp edi, ecx
        je short .1
        mov eax, ecx
        sub eax, edi
        jmp short CmpTeamScoring_ret8
.1:
        mov al, byte [byte eax+01h]
        cmp al, byte [byte edx+01h]
        je short .2
        mov eax, dword [byte esp+04h]
        sub eax, ebp
        jmp short CmpTeamScoring_ret8
.2:
        mov eax, dword [esi]
        sub eax, dword [ebx]
        jmp short CmpTeamScoring_ret8
%endif ; C
;-----------------------------------------------------------------------------
; CmpTeamDefense                                                  23051  95 PC
; Teamsortfns[1] (Team Defense)
;-----------------------------------------------------------------------------
; C: src/front/team_stats/CmpTeamStandings.c (CmpTeamDefense)
%ifdef CBUILD
%include "c/front/team_stats/CmpTeamStandings.CmpTeamDefense.inc"
%else
CmpTeamDefense:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 8
        mov esi, eax
        mov ebx, edx
        cmp dword [statsplayoffs], byte 0
        jne short .1
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov edx, dword [statsteamrecs]
        add eax, edx
        add eax, byte 28h
        jmp short .2
.1:
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov edx, dword [statsteamrecs]
        add eax, edx
        add eax, byte 3Ah
.2:
        mov edx, eax
        cmp dword [statsplayoffs], byte 0
        jne short .3
        mov ecx, dword [ebx]
        mov eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 2
        mov ecx, dword [statsteamrecs]
        add eax, ecx
        add eax, byte 28h
        jmp short .4
.3:
        mov ecx, dword [ebx]
        mov eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 2
        mov ecx, dword [statsteamrecs]
        add eax, ecx
        add eax, byte 3Ah
.4:
        mov cx, word [byte eax+06h]
        mov di, word [byte edx+06h]
        cmp cx, di
        je short .5
        mov edx, edi
        and edx, 0FFFFh
        mov eax, ecx
        and eax, 0FFFFh
        sub edx, eax
        mov eax, edx
        jmp near CmpTeamScoring_ret8
.5:
        mov cl, byte [eax]
        mov ch, byte [edx]
        cmp cl, ch
        je near CmpTeamScoring_common
        xor ebx, ebx
        mov bl, cl
        xor eax, eax
        mov al, ch
        jmp near CmpTeamScoring_sub
%endif ; C
;-----------------------------------------------------------------------------
; CmpTeamPP                                                       2312D  95 PC
; Teamsortfns[3] (Team Power Play)
;-----------------------------------------------------------------------------
; C: src/front/team_stats/CmpTeamStandings.c (CmpTeamPP)
%ifdef CBUILD
%include "c/front/team_stats/CmpTeamStandings.CmpTeamPP.inc"
%else
CmpTeamPP:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        mov ebx, eax
        mov esi, edx
        mov edx, dword [edx]
        shl edx, 2
        mov eax, dword [statssortkeys]
        add edx, eax
        mov ecx, dword [ebx]
        shl ecx, 2
        add eax, ecx
        mov ecx, dword [edx]
        mov edi, dword [eax]
        cmp ecx, edi
        je short .2
        mov eax, ecx
.1:
        sub eax, edi
        jmp near CmpTeamPK_ret10
.2:
        cmp dword [statsplayoffs], byte 0
        jne short .3
        mov edx, dword [ebx]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov edx, dword [statsteamrecs]
        add eax, edx
        add eax, byte 28h
        jmp short .4
.3:
        mov edx, dword [ebx]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov edx, dword [statsteamrecs]
        add eax, edx
        add eax, byte 3Ah
.4:
        mov edx, eax
        cmp dword [statsplayoffs], byte 0
        jne short .5
        mov ecx, dword [esi]
        mov eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 2
        mov ecx, dword [statsteamrecs]
        add eax, ecx
        add eax, byte 28h
        jmp short .6
.5:
        mov ecx, dword [esi]
        mov eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 2
        sub eax, ecx
        mov ecx, eax
        shl ecx, 2
        mov eax, dword [statsteamrecs]
        add eax, ecx
        add eax, byte 3Ah
.6:
        xor ecx, ecx
        mov cx, word [byte eax+08h]
        movzx ebp, word [byte edx+0Ah]
        imul ecx, ebp
        mov dword [byte esp+04h], ecx
        xor ecx, ecx
        mov cx, word [byte edx+08h]
        xor edi, edi
        mov di, word [byte eax+0Ah]
        imul ecx, edi
        mov dword [esp], ecx
        mov ecx, dword [byte esp+04h]
        sub ecx, dword [esp]
        je short .7
        test ecx, ecx
        setg al
        and eax, 0FFh
        jmp near CmpTeamPK_ret10
.7:
        cmp di, word [byte edx+0Ah]
        je short .8
        mov eax, edi
        sub eax, ebp
        jmp near CmpTeamPK_ret10
.8:
        mov cl, byte [eax]
        mov ch, byte [edx]
        cmp cl, ch
        je short .9
        xor ebx, ebx
        mov bl, cl
        xor eax, eax
        mov al, ch
        sub ebx, eax
        mov eax, ebx
        jmp near CmpTeamPK_ret10
.9:
        movzx ebp, byte [byte eax+01h]
        lea ecx, [byte ebp+ebp+00h]
        mov dword [esp], ecx
        xor ecx, ecx
        mov cl, byte [byte eax+03h]
        mov edi, dword [esp]
        add edi, ecx
        mov dword [byte esp+08h], edi
        movzx edi, byte [byte edx+01h]
        lea ecx, [edi+edi]
        mov dword [esp], ecx
        xor ecx, ecx
        mov cl, byte [byte edx+03h]
        mov dword [byte esp+04h], ecx
        mov ecx, dword [esp]
        add ecx, dword [byte esp+04h]
        mov dword [byte esp+0Ch], ecx
        mov ecx, dword [byte esp+08h]
        cmp ecx, dword [byte esp+0Ch]
        je short .10
        mov eax, ecx
        sub eax, dword [byte esp+0Ch]
        jmp near CmpTeamPK_ret10
.10:
        mov al, byte [byte eax+01h]
        cmp al, byte [byte edx+01h]
        je short CmpTeamPP_tie
        mov eax, ebp
        jmp near CmpTeamPP.1
CmpTeamPP_tie:
        mov eax, dword [ebx]
        sub eax, dword [esi]
        jmp near CmpTeamPK_ret10
%endif ; C
;-----------------------------------------------------------------------------
; CmpTeamPK                                                       232B7  95 PC
; Teamsortfns[2] (Team Penalty Killing)
;-----------------------------------------------------------------------------
; C: src/front/team_stats/CmpTeamStandings.c (CmpTeamPK)
%ifdef CBUILD
%include "c/front/team_stats/CmpTeamStandings.CmpTeamPK.inc"
%else
CmpTeamPK:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        mov ebx, eax
        mov esi, edx
        mov edx, dword [edx]
        shl edx, 2
        mov eax, dword [statssortkeys]
        add edx, eax
        mov ecx, dword [ebx]
        shl ecx, 2
        add eax, ecx
        mov ecx, dword [edx]
        mov edi, dword [eax]
        cmp ecx, edi
        je short .2
        mov eax, ecx
.1:
        sub eax, edi
        jmp near CmpTeamPK_ret10
.2:
        cmp dword [statsplayoffs], byte 0
        jne short .3
        mov edx, dword [ebx]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov edx, dword [statsteamrecs]
        add eax, edx
        add eax, byte 28h
        jmp short .4
.3:
        mov edx, dword [ebx]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov edx, dword [statsteamrecs]
        add eax, edx
        add eax, byte 3Ah
.4:
        mov edx, eax
        cmp dword [statsplayoffs], byte 0
        jne short .5
        mov ecx, dword [esi]
        mov eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 2
        mov ecx, dword [statsteamrecs]
        add eax, ecx
        add eax, byte 28h
        jmp short .6
.5:
        mov ecx, dword [esi]
        mov eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 2
        sub eax, ecx
        mov ecx, eax
        shl ecx, 2
        mov eax, dword [statsteamrecs]
        add eax, ecx
        add eax, byte 3Ah
.6:
        xor ecx, ecx
        mov cx, word [byte eax+0Ch]
        movzx ebp, word [byte edx+0Eh]
        imul ecx, ebp
        mov dword [byte esp+04h], ecx
        xor ecx, ecx
        mov cx, word [byte edx+0Ch]
        xor edi, edi
        mov di, word [byte eax+0Eh]
        imul ecx, edi
        mov dword [esp], ecx
        mov ecx, dword [byte esp+04h]
        sub ecx, dword [esp]
        je short .7
        test ecx, ecx
        setl al
        and eax, 0FFh
        jmp short CmpTeamPK_ret10
.7:
        cmp di, word [byte edx+0Eh]
        je short CmpTeamPK_x.1
CmpTeamPK_sub:
        mov eax, edi
        sub eax, ebp
CmpTeamPK_ret10:
        add esp, byte 10h
CmpTeamPK_x:
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.1:
        mov cl, byte [eax]
        mov ch, byte [edx]
        cmp cl, ch
        je short .2
        xor ebx, ebx
        mov bl, cl
        xor eax, eax
        mov al, ch
        sub ebx, eax
        mov eax, ebx
        jmp short CmpTeamPK_ret10
.2:
        movzx ebp, byte [byte eax+01h]
        lea ecx, [byte ebp+ebp+00h]
        mov dword [esp], ecx
        xor ecx, ecx
        mov cl, byte [byte eax+03h]
        mov edi, dword [esp]
        add edi, ecx
        mov dword [byte esp+08h], edi
        movzx edi, byte [byte edx+01h]
        lea ecx, [edi+edi]
        mov dword [esp], ecx
        xor ecx, ecx
        mov cl, byte [byte edx+03h]
        mov dword [byte esp+04h], ecx
        mov ecx, dword [esp]
        add ecx, dword [byte esp+04h]
        mov dword [byte esp+0Ch], ecx
        mov ecx, dword [byte esp+08h]
        cmp ecx, dword [byte esp+0Ch]
        je short .3
        mov eax, ecx
        sub eax, dword [byte esp+0Ch]
        jmp short CmpTeamPK_ret10
.3:
        mov al, byte [byte eax+01h]
        cmp al, byte [byte edx+01h]
        je near CmpTeamPP_tie
        mov eax, ebp
        jmp near CmpTeamPK.1
%endif ; C
;-----------------------------------------------------------------------------
; CmpTeamPenalties                                                23437  95 PC
; Teamsortfns[4] (Team Penalties)
;-----------------------------------------------------------------------------
; C: src/front/team_stats/CmpTeamStandings.c (CmpTeamPenalties)
%ifdef CBUILD
%include "c/front/team_stats/CmpTeamStandings.CmpTeamPenalties.inc"
%else
CmpTeamPenalties:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        mov ebx, eax
        mov esi, edx
        mov eax, dword [edx]
        shl eax, 2
        mov edx, dword [statssortkeys]
        add eax, edx
        mov ecx, dword [ebx]
        shl ecx, 2
        add edx, ecx
        mov ecx, dword [eax]
        mov edi, dword [edx]
        cmp ecx, edi
        je short .1
        mov eax, edi
        sub eax, ecx
        jmp near CmpTeamPK_ret10
.1:
        cmp dword [statsplayoffs], byte 0
        jne short .2
        mov edx, dword [ebx]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, eax
        shl edx, 2
        mov eax, dword [statsteamrecs]
        add eax, edx
        add eax, byte 28h
        jmp short .3
.2:
        mov edx, dword [ebx]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, eax
        shl edx, 2
        mov eax, dword [statsteamrecs]
        add eax, edx
        add eax, byte 3Ah
.3:
        mov edx, eax
        cmp dword [statsplayoffs], byte 0
        jne short .4
        mov ecx, dword [esi]
        mov eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 2
        mov ecx, dword [statsteamrecs]
        add eax, ecx
        add eax, byte 28h
        jmp short .5
.4:
        mov ecx, dword [esi]
        mov eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 2
        mov ecx, dword [statsteamrecs]
        add eax, ecx
        add eax, byte 3Ah
.5:
        mov cl, byte [eax]
        mov ch, byte [edx]
        cmp cl, ch
        je short .6
        xor ebx, ebx
        mov bl, cl
        xor eax, eax
        mov al, ch
        sub ebx, eax
        mov eax, ebx
        jmp near CmpTeamPK_ret10
.6:
        mov cx, word [byte eax+010h]
        mov di, word [byte edx+010h]
        cmp cx, di
        je short .7
        mov edx, edi
        and edx, 0FFFFh
        mov eax, ecx
        and eax, 0FFFFh
        sub edx, eax
        mov eax, edx
        jmp near CmpTeamPK_ret10
.7:
        movzx edi, byte [byte eax+01h]
        lea ecx, [edi+edi]
        mov dword [esp], ecx
        xor ecx, ecx
        mov cl, byte [byte eax+03h]
        mov ebp, dword [esp]
        add ebp, ecx
        mov dword [byte esp+08h], ebp
        movzx ebp, byte [byte edx+01h]
        lea ecx, [byte ebp+ebp+00h]
        mov dword [esp], ecx
        xor ecx, ecx
        mov cl, byte [byte edx+03h]
        mov dword [byte esp+04h], ecx
        mov ecx, dword [esp]
        add ecx, dword [byte esp+04h]
        mov dword [byte esp+0Ch], ecx
        mov ecx, dword [byte esp+08h]
        cmp ecx, dword [byte esp+0Ch]
        je short .8
        mov eax, ecx
        sub eax, dword [byte esp+0Ch]
        jmp near CmpTeamPK_ret10
.8:
        mov al, byte [byte eax+01h]
        cmp al, byte [byte edx+01h]
        je near CmpTeamPP_tie
        jmp near CmpTeamPK_sub
%endif ; C
        db 08Dh,040h,00h
TeamStatsScreen_keyjt:
        dd TeamStatsScreen_keyPK
        dd TeamStatsScreen_keyPP
        dd TeamStatsScreen_keyPen
        dd TeamStatsScreen_keyStand
TeamStatsScreen_coljt:
        dd TeamStatsScreen_colScoring
        dd TeamStatsScreen_colDefense
        dd TeamStatsScreen_colPK
        dd TeamStatsScreen_colPP
        dd TeamStatsScreen_colPen
;-----------------------------------------------------------------------------
; TeamStatsScreen                                                 235BE  95 PC
; Team stats table for statscategory 0-5 (titles teamstattitles, sorts
; teamsortfns); allocs "teams" / "addsort"; "Stats Unavailable"
;-----------------------------------------------------------------------------
TeamStatsScreen:
        push dword 294h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, 264h
        push eax
        push byte 20h
        push dword 7B8h
        push str_Teams
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [statsteamrecs], eax
        cmp dword [esp], byte 1
        jle short .1
        push byte 20h
        push byte 68h
        push str_Addsort
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [statssortkeys], eax
.1:
        mov eax, dword [statsfromleague]
        mov ebx, dword [nosplit eax*4+statsteamdbs]
        xor ecx, ecx
        mov edx, statsleague
        lea eax, [dword esp+0224h]
        call MakePath
        push dword 200h
        lea eax, [dword esp+0228h]
        push eax
        call open_
        add esp, byte 8
        mov dword [dword esp+0254h], eax
        cmp dword [statsfromleague], byte 0
        jne short .2
        mov eax, 4Ch
        jmp short .3
.2:
        mov eax, 2E8h
.3:
        mov dword [dword esp+0250h], eax
        cmp dword [statsplayoffs], byte 0
        jne short .5
        xor ebp, ebp
.4:
        mov dword [byte esp+ebp*4+074h], ebp
        inc ebp
        cmp ebp, byte 1Ah
        jl short TeamStatsScreen.4
        mov dword [dword esp+0258h], 1Ah
        jmp short .9
.5:
        lea eax, [dword esp+0244h]
        call OpenStatsSchedule
        mov eax, dword [dword esp+0244h]
        add eax, 199Ah
        add dword [dword esp+0244h], byte 2
        xor ebp, ebp
.6:
        xor ebx, ebx
        mov bl, byte [byte eax+02h]
        mov dword [byte esp+ebp*8+074h], ebx
        xor ebx, ebx
        mov bl, byte [byte eax+03h]
        mov dword [byte esp+ebp*8+078h], ebx
        inc ebp
        add eax, byte 2Ah
        cmp ebp, byte 8
        jl short TeamStatsScreen.6
        cmp dword [byte esp+074h], 0FFh
        jne short .7
        xor eax, eax
        mov dword [dword esp+0258h], eax
        jmp short .8
.7:
        mov dword [dword esp+0258h], 10h
.8:
        mov eax, dword [dword esp+0244h]
        sub eax, byte 2
        push eax
        call FreeMemBlock
        add esp, byte 4
.9:
        cmp dword [dword esp+0258h], byte 0
        je near TeamStatsScreen_keyPen.28
        xor ebp, ebp
        jmp near TeamStatsScreen_keyPen.5
.10:
        mov dword [dword esp+ebp*4+0DCh], ebp
        mov edx, dword [dword esp+0250h]
        imul edx, dword [byte esp+ebp*4+074h]
        xor ebx, ebx
        mov eax, dword [dword esp+0254h]
        call lseek_
        mov ebx, 4Ch
        lea edx, [dword esp+0198h]
        mov eax, dword [dword esp+0254h]
        call read_
        mov eax, ebp
        shl eax, 2
        add eax, ebp
        shl eax, 2
        sub eax, ebp
        shl eax, 2
        mov edi, dword [statsteamrecs]
        add edi, eax
        mov ecx, 13h
        lea esi, [dword esp+0198h]
        rep movsd
        cmp dword [statsplayoffs], byte 0
        jne short .11
        lea eax, [dword esp+01C0h]
        jmp short .12
.11:
        lea eax, [dword esp+01D2h]
.12:
        mov esi, eax
        mov edx, dword [esp]
        sub edx, byte 2
        cmp edx, byte 3
        ja near TeamStatsScreen_keyPen.4
        jmp dword [nosplit cs:edx*4+TeamStatsScreen_keyjt]
TeamStatsScreen_keyStand:
        xor ebx, ebx
        mov bl, byte [dword esp+01BFh]
        mov eax, ebp
        mov edx, dword [statssortkeys]
        mov dword [edx+eax*4], ebx
        jmp near TeamStatsScreen_keyPen.4
TeamStatsScreen_keyPK:
        mov dx, word [byte eax+0Ch]
        cmp dx, word [byte eax+0Eh]
        jbe short .1
        mov word [byte eax+0Eh], dx
.1:
        xor eax, eax
        mov ax, word [byte esi+0Eh]
        mov dword [dword esp+0264h], eax
        test eax, eax
        je short .2
        xor edx, edx
        mov dx, word [byte esi+0Ch]
        mov ebx, edx
        shl ebx, 5
        sub ebx, edx
        shl ebx, 2
        add ebx, edx
        shl ebx, 3
        mov edx, eax
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        lea edx, [ebx+eax]
        mov eax, edx
        sar edx, 1Fh
        idiv dword [dword esp+0264h]
        mov edx, 3E8h
        sub edx, eax
        mov eax, edx
.2:
        mov ebx, ebp
        mov edx, dword [statssortkeys]
        mov dword [edx+ebx*4], eax
        jmp near TeamStatsScreen_keyPen.4
TeamStatsScreen_keyPP:
        mov dx, word [byte eax+08h]
        cmp dx, word [byte eax+0Ah]
        jbe short .1
        mov word [byte eax+0Ah], dx
.1:
        xor eax, eax
        mov ax, word [byte esi+0Ah]
        mov dword [dword esp+0264h], eax
        test eax, eax
        je short TeamStatsScreen_keyPen.3
        xor edx, edx
        mov dx, word [byte esi+08h]
        mov ebx, edx
        shl ebx, 5
        sub ebx, edx
        shl ebx, 2
        add ebx, edx
        shl ebx, 3
        jmp short TeamStatsScreen_keyPen.1
TeamStatsScreen_keyPen:
        xor edx, edx
        mov dl, byte [eax]
        mov dword [dword esp+0264h], edx
        test edx, edx
        je short .2
        xor edx, edx
        mov dx, word [byte eax+010h]
        mov ebx, edx
        shl ebx, 2
        add ebx, edx
        add ebx, ebx
        mov eax, dword [dword esp+0264h]
.1:
        mov edx, eax
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        lea edx, [ebx+eax]
        mov eax, edx
        sar edx, 1Fh
        idiv dword [dword esp+0264h]
        jmp short .3
.2:
        xor eax, eax
.3:
        mov edx, ebp
        mov ebx, dword [statssortkeys]
        mov dword [ebx+edx*4], eax
.4:
        inc ebp
.5:
        cmp ebp, dword [dword esp+0258h]
        jl near TeamStatsScreen.10
        mov eax, dword [esp]
        shl eax, 2
        cmp dword [esp], byte 5
        je short .6
        mov ecx, dword [dword eax+teamsortfns]
        mov ebx, 4
        mov edx, dword [dword esp+0258h]
        lea eax, [dword esp+0DCh]
        call qsort_
        jmp near .28
.6:
        cmp dword [statsplayoffs], byte 0
        jne near .23
        mov ebp, dword [statsfromleague]
        test ebp, ebp
        jne short .8
        mov dword [dword esp+0258h], 0Eh
.7:
        mov edx, dword [nosplit ebp*4+westconfteams]
        mov dword [byte esp+ebp*4+04h], edx
        mov edx, dword [nosplit ebp*4+eastconfteams]
        mov dword [byte esp+ebp*4+03Ch], edx
        inc ebp
        cmp ebp, byte 0Eh
        jl short TeamStatsScreen_keyPen.7
        jmp near .28
.8:
        mov ecx, dword [dword eax+teamsortfns]
        mov ebx, 4
        mov edx, dword [dword esp+0258h]
        lea eax, [dword esp+0DCh]
        call qsort_
        xor ebp, ebp
        xor ebx, ebx
        xor edx, edx
        mov edi, dword [dword esp+0258h]
        jmp short .12
.9:
        mov eax, ebp
        shl eax, 2
        mov ecx, dword [dword esp+eax+0DCh]
        mov ecx, dword [byte esp+ecx*4+074h]
        cmp dword [nosplit ecx*4+teamconf], byte 3
        jne short .10
        mov eax, dword [dword esp+eax+0DCh]
        mov dword [byte esp+edx*4+04h], eax
        inc edx
        jmp short .11
.10:
        mov eax, dword [dword esp+eax+0DCh]
        mov dword [byte esp+ebx*4+03Ch], eax
        inc ebx
.11:
        inc ebp
.12:
        cmp ebp, edi
        jl short TeamStatsScreen_keyPen.9
        mov edx, dword [byte esp+08h]
        mov eax, dword [byte esp+04h]
        mov eax, dword [nosplit eax*4+teamdivflags]
        or eax, dword [nosplit edx*4+teamdivflags]
        cmp eax, byte 3
        je short .17
        mov ebp, 2
.13:
        mov edx, dword [byte esp+ebp*4+04h]
        mov eax, dword [byte esp+04h]
        mov eax, dword [nosplit eax*4+teamdivflags]
        or eax, dword [nosplit edx*4+teamdivflags]
        cmp eax, byte 3
        je short .14
        inc ebp
        cmp ebp, byte 0Ch
        jl short TeamStatsScreen_keyPen.13
.14:
        mov ebx, dword [byte esp+ebp*4+04h]
        jmp short .16
.15:
        mov edx, dword [esp+ebp*4]
        mov dword [byte esp+ebp*4+04h], edx
        dec ebp
.16:
        cmp ebp, byte 2
        jge short TeamStatsScreen_keyPen.15
        mov dword [byte esp+08h], ebx
.17:
        mov eax, dword [byte esp+03Ch]
        mov edx, dword [byte esp+040h]
        mov eax, dword [nosplit eax*4+teamdivflags]
        or eax, dword [nosplit edx*4+teamdivflags]
        cmp eax, byte 0Ch
        je short .22
        mov ebp, 2
.18:
        mov edx, dword [byte esp+ebp*4+03Ch]
        mov eax, dword [byte esp+03Ch]
        mov eax, dword [nosplit eax*4+teamdivflags]
        or eax, dword [nosplit edx*4+teamdivflags]
        cmp eax, byte 0Ch
        je short .19
        inc ebp
        cmp ebp, byte 0Ch
        jl short TeamStatsScreen_keyPen.18
.19:
        mov ebx, dword [byte esp+ebp*4+03Ch]
        jmp short .21
.20:
        mov edx, dword [byte esp+ebp*4+038h]
        mov dword [byte esp+ebp*4+03Ch], edx
        dec ebp
.21:
        cmp ebp, byte 2
        jge short TeamStatsScreen_keyPen.20
        mov dword [byte esp+040h], ebx
.22:
        mov dword [dword esp+0258h], 0Eh
        jmp short .28
.23:
        mov ecx, dword [dword eax+teamsortfns]
        mov ebx, 4
        mov edx, dword [dword esp+0258h]
        lea eax, [dword esp+0DCh]
        call qsort_
        xor ebp, ebp
        xor ebx, ebx
        xor edx, edx
        jmp short .27
.24:
        mov eax, ebp
        shl eax, 2
        mov ecx, dword [dword esp+eax+0DCh]
        mov ecx, dword [byte esp+ecx*4+074h]
        cmp dword [nosplit ecx*4+teamconf], byte 3
        jne short .25
        mov eax, dword [dword esp+eax+0DCh]
        mov dword [byte esp+edx*4+04h], eax
        inc edx
        jmp short .26
.25:
        mov eax, dword [dword esp+eax+0DCh]
        mov dword [byte esp+ebx*4+03Ch], eax
        inc ebx
.26:
        inc ebp
.27:
        cmp ebp, byte 10h
        jl short TeamStatsScreen_keyPen.24
        mov dword [dword esp+0258h], 8
.28:
        mov eax, dword [dword esp+0254h]
        call j___close_
        mov esi, dword [mainfont]
        mov edi, dword [kaufmfont]
        call SetScreenTarget
        mov eax, dword [statsplayoffs]
        shl eax, 2
        cmp dword [statsplayoffs], byte 0
        jne short .30
        xor ecx, ecx
        mov ebx, dword [dword eax+statsbgnames]
        cmp byte [fileoncd+08Ch], 1
        jne short .29
        mov edx, dword [cddriveptr]
        jmp short .32
.29:
        xor edx, edx
        jmp short .32
.30:
        xor ecx, ecx
        mov ebx, dword [dword eax+statsbgnames]
        cmp byte [fileoncd+08Dh], 1
        jne short .31
        mov edx, dword [cddriveptr]
        jmp short .32
.31:
        xor edx, edx
.32:
        lea eax, [dword esp+0224h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0228h]
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
        mov ebx, str_Pstatbar5
        cmp byte [fileoncd+013Ch], 1
        jne short .33
        mov edx, dword [cddriveptr]
        jmp short .34
.33:
        xor edx, edx
.34:
        lea eax, [dword esp+0224h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0228h]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        push str_Pst24
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
        lea eax, [dword esp+01E4h]
        push eax
        call TextSaveState
        add esp, byte 4
        push edi
        call TextSetFont
        add esp, byte 4
        call TextGridOpen
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        mov edx, dword [esp]
        mov edx, dword [nosplit edx*4+teamstattitles]
        lea eax, [dword esp+0144h]
        call MakeStatsTitle
        lea eax, [dword esp+0144h]
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, 12Ch
        sub edx, eax
        mov eax, edx
        lea ebx, [dword esp+0144h]
        mov edx, 31h
        call PrintOutlinedText
        cmp dword [dword esp+0258h], byte 0
        jne short .35
        push edi
        call TextSetFont
        add esp, byte 4
        mov edx, str_StatsUnavailable
        mov eax, 0EBh
        call PrintCenteredText
        push esi
        call TextSetFont
        add esp, byte 4
        jmp near TeamStatsScreen_colPen.5
.35:
        push esi
        call TextSetFont
        add esp, byte 4
        mov dword [dword esp+0260h], 5Ch
        mov edi, dword [esp]
        cmp edi, byte 5
        jne near .36
        mov edi, dword [westconfname]
        mov esi, dword [dword esp+025Eh]
        sar esi, 10h
        push edi
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, 0A0h
        sub edx, eax
        movsx eax, dx
        mov ebx, edi
        mov edx, esi
        call PrintShadowText
        mov edi, dword [eastconfname]
        push edi
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, 1E0h
        sub edx, eax
        movsx eax, dx
        mov ebx, edi
        mov edx, esi
        call PrintShadowText
        mov dword [dword esp+0260h], 73h
        mov ecx, dword [dword esp+025Eh]
        sar ecx, 10h
        mov ebx, str_GP4
        mov edx, ecx
        mov eax, 0ECh
        call PrintShadowText
        mov ebx, str_GP4
        mov edx, ecx
        mov eax, 21Ch
        call PrintShadowText
        cmp dword [statsplayoffs], byte 0
        setne al
        mov edx, eax
        and edx, 0FFh
        shl edx, 2
        mov eax, dword [esp]
        shl eax, 4
        mov ebx, dword [dword edx+eax+teamcolhdrs]
        mov edx, dword [dword esp+025Eh]
        sar edx, 10h
        mov eax, 114h
        call PrintShadowText
        cmp dword [statsplayoffs], byte 0
        setne al
        and eax, 0FFh
        mov edx, dword [esp]
        shl edx, 4
        mov ebx, dword [dword edx+eax*4+teamcolhdrs]
        mov edx, dword [dword esp+025Eh]
        sar edx, 10h
        mov eax, 244h
        jmp near .39
.36:
        mov ecx, dword [dword esp+025Eh]
        sar ecx, 10h
        mov ebx, str_GP4
        mov edx, ecx
        mov eax, 154h
        call PrintShadowText
        mov esi, edi
        shl esi, 4
        mov ebx, dword [dword esi+teamcolhdrs]
        mov edx, ecx
        mov eax, 186h
        call PrintShadowText
        mov ebx, dword [dword esi+teamcolhdrs+4]
        mov edx, ecx
        mov eax, 1B8h
        call PrintShadowText
        cmp dword [statsplayoffs], byte 0
        je short .37
        cmp edi, byte 1
        je short .38
        test edi, edi
        je short .38
.37:
        mov ebx, dword [esp]
        shl ebx, 4
        mov ebx, dword [dword ebx+teamcolhdrs+8]
        mov edx, dword [dword esp+025Eh]
        sar edx, 10h
        mov eax, 1EAh
        call PrintShadowText
.38:
        mov eax, dword [esp]
        shl eax, 4
        mov ebx, dword [dword eax+teamcolhdrs+0Ch]
        mov edx, dword [dword esp+025Eh]
        sar edx, 10h
        mov eax, 21Ch
.39:
        call PrintShadowText
        mov dword [dword esp+025Ch], 1
        add dword [dword esp+0260h], byte 10h
        cmp dword [esp], byte 5
        jne near .59
        xor ebp, ebp
        jmp near .58
.40:
        xor edi, edi
        mov dword [dword esp+0248h], edi
        cmp ebp, byte 0Ch
        jge near .48
        mov eax, dword [byte esp+ebp*4+04h]
        mov dword [dword esp+0264h], eax
        mov edx, eax
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov esi, dword [statsteamrecs]
        add esi, eax
        mov ecx, 13h
        lea edi, [dword esp+0198h]
        rep movsd
        cmp dword [statsplayoffs], byte 0
        jne short .41
        lea eax, [dword esp+01C0h]
        jmp short .42
.41:
        lea eax, [dword esp+01D2h]
.42:
        mov esi, eax
        cmp dword [statsfromleague], byte 0
        jne short .43
        cmp byte [eax], 0
        je near .57
.43:
        mov ecx, dword [dword esp+025Ah]
        sar ecx, 10h
        mov edi, dword [dword esp+025Eh]
        sar edi, 10h
        mov eax, dword [dword esp+0248h]
        add eax, 1Eh
        cwde
        mov ebx, str_fmt2d
        mov edx, edi
        call PrintFmt1
        mov ebx, 3
        mov edx, str_ANA2
        lea eax, [dword esp+0198h]
        call strnicmp_
        mov edx, eax
        mov eax, dword [dword esp+0248h]
        add eax, 3Ch
        test edx, edx
        jne short .44
        cwde
        mov ebx, str_MightyDucksOfAnaheim
        jmp short .45
.44:
        cwde
        lea ebx, [dword esp+019Dh]
.45:
        mov edx, edi
        call PrintShadowText
        xor ecx, ecx
        mov cl, byte [esi]
        mov edi, dword [dword esp+025Eh]
        sar edi, 10h
        mov eax, dword [dword esp+0248h]
        add eax, 0ECh
        cwde
        mov ebx, str_fmt2d
        mov edx, edi
        call PrintFmt1
        mov eax, dword [dword esp+0248h]
        add eax, 114h
        cmp dword [statsplayoffs], byte 0
        jne short .46
        xor edx, edx
        mov dl, byte [byte esi+01h]
        mov ebx, edx
        add ebx, edx
        xor edx, edx
        mov dl, byte [byte esi+03h]
        add edx, ebx
        movsx ecx, dx
        cwde
        mov ebx, str_fmt3d
        jmp short .47
.46:
        xor ecx, ecx
        mov cl, byte [byte esi+01h]
        cwde
        mov ebx, str_fmt2d
.47:
        mov edx, edi
        call PrintFmt1
.48:
        mov dword [dword esp+0248h], 140h
        mov eax, dword [byte esp+ebp*4+03Ch]
        mov dword [dword esp+0264h], eax
        mov edx, eax
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov esi, dword [statsteamrecs]
        add esi, eax
        mov ecx, 13h
        lea edi, [dword esp+0198h]
        rep movsd
        cmp dword [statsplayoffs], byte 0
        jne short .49
        lea eax, [dword esp+01C0h]
        jmp short .50
.49:
        lea eax, [dword esp+01D2h]
.50:
        mov esi, eax
        cmp dword [statsfromleague], byte 0
        jne short .51
        cmp byte [eax], 0
        je near .57
.51:
        mov ecx, dword [dword esp+025Ah]
        sar ecx, 10h
        mov edi, dword [dword esp+025Eh]
        sar edi, 10h
        mov eax, dword [dword esp+0248h]
        add eax, 1Eh
        cwde
        mov ebx, str_fmt2d
        mov edx, edi
        call PrintFmt1
        mov ebx, 3
        mov edx, str_ANA2
        lea eax, [dword esp+0198h]
        call strnicmp_
        mov edx, dword [dword esp+0248h]
        add edx, byte 3Ch
        test eax, eax
        jne short .52
        movsx eax, dx
        mov ebx, str_MightyDucksOfAnaheim
        jmp short .53
.52:
        movsx eax, dx
        lea ebx, [dword esp+019Dh]
.53:
        mov edx, edi
        call PrintShadowText
        xor ecx, ecx
        mov cl, byte [esi]
        mov edi, dword [dword esp+025Eh]
        sar edi, 10h
        mov eax, dword [dword esp+0248h]
        add eax, 0DCh
        cwde
        mov ebx, str_fmt2d
        mov edx, edi
        call PrintFmt1
        mov eax, dword [dword esp+0248h]
        add eax, 104h
        cmp dword [statsplayoffs], byte 0
        jne short .54
        xor edx, edx
        mov dl, byte [byte esi+01h]
        add edx, edx
        xor ebx, ebx
        mov bl, byte [byte esi+03h]
        add edx, ebx
        movsx ecx, dx
        cwde
        mov ebx, str_fmt3d
        jmp short .55
.54:
        xor ecx, ecx
        mov cl, byte [byte esi+01h]
        cwde
        mov ebx, str_fmt2d
.55:
        mov edx, edi
        call PrintFmt1
        mov ebx, dword [dword esp+025Ch]
        inc ebx
        mov dword [dword esp+025Ch], ebx
        cmp ebx, byte 9
        jne short .56
        cmp dword [statsplayoffs], byte 0
        jne short .56
        add dword [dword esp+0260h], byte 0Dh
        mov esi, dword [dword esp+025Eh]
        sar esi, 10h
        mov ebx, str_Dashes39
        mov edx, esi
        mov eax, 1Eh
        call PrintShadowText
        mov ebx, str_Dashes36
        mov edx, esi
        mov eax, 15Eh
        call PrintShadowText
.56:
        add dword [dword esp+0260h], byte 0Dh
.57:
        inc ebp
.58:
        cmp ebp, dword [dword esp+0258h]
        jl near TeamStatsScreen_keyPen.40
        jmp near TeamStatsScreen_colPen.5
.59:
        xor ebp, ebp
        jmp near TeamStatsScreen_colPen.4
.60:
        mov eax, dword [dword esp+ebp*4+0DCh]
        mov dword [dword esp+0264h], eax
        mov edx, eax
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov esi, dword [statsteamrecs]
        add esi, eax
        mov ecx, 13h
        lea edi, [dword esp+0198h]
        rep movsd
        cmp dword [statsplayoffs], byte 0
        jne short .61
        lea eax, [dword esp+01C0h]
        jmp short .62
.61:
        lea eax, [dword esp+01D2h]
.62:
        mov esi, eax
        cmp dword [statsfromleague], byte 0
        jne short .63
        cmp byte [eax], 0
        je near TeamStatsScreen_colPen.3
.63:
        mov eax, dword [dword esp+025Ch]
        movsx ecx, ax
        mov edi, dword [dword esp+025Eh]
        sar edi, 10h
        inc dword [dword esp+025Ch]
        mov ebx, str_fmt2d
        mov edx, edi
        mov eax, 50h
        call PrintFmt1
        mov ebx, 3
        mov edx, str_ANA2
        lea eax, [dword esp+0198h]
        call strnicmp_
        test eax, eax
        jne short .64
        mov ebx, str_MightyDucksOfAnaheim
        jmp short .65
.64:
        lea ebx, [dword esp+019Dh]
.65:
        mov edx, edi
        mov eax, 6Eh
        call PrintShadowText
        xor ecx, ecx
        mov cl, byte [esi]
        mov edi, dword [dword esp+025Eh]
        sar edi, 10h
        mov ebx, str_fmt2d
        mov edx, edi
        mov eax, 154h
        call PrintFmt1
        mov edx, dword [esp]
        cmp edx, byte 4
        ja near TeamStatsScreen_colPen.2
        mov eax, edx
        mov edx, dword [dword esp+0264h]
        shl edx, 2
        mov dword [dword esp+024Ch], edx
        jmp dword [nosplit cs:eax*4+TeamStatsScreen_coljt]
TeamStatsScreen_colScoring:
        xor ecx, ecx
        mov cl, byte [byte esi+01h]
        mov ebx, str_fmt2d
        mov edx, edi
        mov eax, 186h
        call PrintFmt1
        xor ecx, ecx
        mov cl, byte [byte esi+02h]
        mov ebx, str_fmt2d
        mov edx, edi
        mov eax, 1B8h
        call PrintFmt1
        cmp dword [statsplayoffs], byte 0
        jne short .1
        xor ecx, ecx
        mov cl, byte [byte esi+03h]
        mov ebx, str_fmt2d
        mov edx, edi
        mov eax, 1EAh
        call PrintFmt1
.1:
        mov ecx, dword [byte esi+02h]
.2:
        sar ecx, 10h
        mov edx, dword [dword esp+025Eh]
        sar edx, 10h
        mov ebx, str_fmt3d
        mov eax, 21Ch
        call PrintFmt1
        jmp near TeamStatsScreen_colPen.2
TeamStatsScreen_colDefense:
        xor ecx, ecx
        mov cl, byte [byte esi+01h]
        mov ebx, str_fmt2d
        mov edx, edi
        mov eax, 186h
        call PrintFmt1
        xor ecx, ecx
        mov cl, byte [byte esi+02h]
        mov ebx, str_fmt2d
        mov edx, edi
        mov eax, 1B8h
        call PrintFmt1
        cmp dword [statsplayoffs], byte 0
        jne short .1
        xor ecx, ecx
        mov cl, byte [byte esi+03h]
        mov ebx, str_fmt2d
        mov edx, edi
        mov eax, 1EAh
        call PrintFmt1
.1:
        mov ecx, dword [byte esi+04h]
        jmp short TeamStatsScreen_colScoring.2
TeamStatsScreen_colPK:
        mov ecx, dword [byte esi+0Ch]
        sar ecx, 10h
        mov ebx, str_fmt3d
        mov edx, edi
        mov eax, 186h
        call PrintFmt1
        mov ecx, dword [byte esi+0Ah]
        sar ecx, 10h
        mov ebx, str_fmt4d
.1:
        mov edx, edi
        mov eax, 1B8h
        call PrintFmt1
        mov esi, dword [statssortkeys]
        add esi, dword [dword esp+024Ch]
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
        mov eax, 1EAh
        jmp short TeamStatsScreen_colPen.1
TeamStatsScreen_colPP:
        mov ecx, dword [byte esi+08h]
        sar ecx, 10h
        mov ebx, str_fmt3d
        mov edx, edi
        mov eax, 186h
        call PrintFmt1
        mov ecx, dword [byte esi+06h]
        sar ecx, 10h
        mov ebx, str_fmt3d
        jmp short TeamStatsScreen_colPK.1
TeamStatsScreen_colPen:
        mov ecx, dword [byte esi+0Eh]
        sar ecx, 10h
        mov ebx, str_fmt3d
        mov edx, edi
        mov eax, 186h
        call PrintFmt1
        mov esi, dword [statssortkeys]
        add esi, dword [dword esp+024Ch]
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
        mov eax, 1B8h
.1:
        call PrintFmt2
.2:
        add dword [dword esp+0260h], byte 0Dh
.3:
        inc ebp
.4:
        cmp ebp, dword [dword esp+0258h]
        jl near TeamStatsScreen_keyPen.60
.5:
        call TextGridOff
        lea eax, [dword esp+01E4h]
        push eax
        call TextRestoreState
        add esp, byte 4
        cmp dword [esp], byte 1
        jle short .6
        mov ebx, dword [statssortkeys]
        push ebx
        call FreeMemBlock
        add esp, byte 4
.6:
        mov ecx, dword [statsteamrecs]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        add esp, 268h
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
