; Division and conference standings, and the playoff tree you can move through.
bits 32
%include "hockey.inc"
section s_27080 progbits alloc exec nowrite align=1
extern __CHK, cddriveptr, CmpConfStandings, DeskSetExit3b, divisionnames, divx, divy, embscupbank
extern dword_C6D26, potreeseeds, dword_C6E20, fileoncd, fputchar, FreeMemBlock, j___close_, kaufmfont
extern LoadLeagueTree, LoadPlayoffModeTree, LoadScheduleDB, lseek_, mainfont, MakePath, MakeStatsTitle, memcpy_
extern off_CF6A3, open_, OpenStatsSchedule, playofftree, PrintCenteredText, PrintFmt1, PrintFmt2, PrintOutlinedText
extern PrintShadowText, qsort_, read_, SetTextColors, sprintf_, stand_tmpl1, stand_tmpl2, statsbgnames
extern statsbgshapes, statsfromleague, statsleague, statspal, statspalshape, statspalvalid, statsplayoffs, statsteamdbs
extern str_Adn12, str_Adn22, str_Adn32, str_Aup12, str_Aup22, str_Aup32, str_Bkgd2, str_C3
extern str_Conference, str_D3, str_Eastern, str_EasternConference2, str_Embpal2, str_fmt2d, str_fmt3d, str_fmtPct
extern str_fmtPct0, str_GA2, str_GF, str_GP7, str_L6, str_Midl2, str_P, str_Pal9
extern str_Pct4, str_PlayoffsHaveNotBeen2, str_Pst27, str_Pstatbar8, str_Rst12, str_Rst22, str_Scuparrw2, str_Standings
extern str_T4, str_Team, str_TwoSpaces, str_W4, str_Western, str_WesternConference2, strcat_, LoadBank
extern TextSaveState, TextRestoreState, TextSetFont, sub_91044, DrawArt, DrawShape, FindShape, VgaSetPalette
extern SetScreenTarget, SetClipWindow, teamconf, TextGridOff, TextGridOpen, treecol_Er1, treecol_Er2, treecol_Er3
extern treecol_Wr2, treecol_Wr3, treecolslots, treecolx, treerowy, treeteamnames
global StandingsScreen, HighlightTreeSlot, MoveTreeHighlight, CountSeriesWins, PlayoffTreeScreen, PlayoffTreeHitTest, ShowPlayoffTree
;-----------------------------------------------------------------------------
; StandingsScreen                                                 27080  95 PC
; " Standings" screen: Western / Eastern Conference by division
; (divisionnames, divx / divy), qsort CmpConfStandings, Team GP W L T GF GA P
; Pct; called by the *StandingsScreen callbacks
;-----------------------------------------------------------------------------
; C: src/front/playoff/StandingsScreen.c
%ifdef CBUILD
%include "c/front/playoff/StandingsScreen.inc"
%else
StandingsScreen:
        push dword 468h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 440h
        mov dword [byte ebp-034h], eax
        mov dword [byte ebp-03Ch], edx
        lea edi, [byte ebp-054h]
        mov esi, stand_tmpl1
        movsd
        movsd
        movsw
        lea edi, [byte ebp-048h]
        mov esi, stand_tmpl2
        movsd
        movsd
        movsw
        mov dword [off_CF6A3], DeskSetExit3b
        mov eax, dword [mainfont]
        mov dword [byte ebp-08h], eax
        mov eax, dword [kaufmfont]
        mov dword [byte ebp-0Ch], eax
        xor ecx, ecx
        mov eax, dword [statsfromleague]
        shl eax, 2
        mov ebx, dword [dword eax+statsteamdbs]
        mov edx, statsleague
        lea eax, [byte ebp-074h]
        call MakePath
        push dword 200h
        lea eax, [byte ebp-074h]
        push eax
        call open_
        add esp, byte 8
        mov dword [byte ebp-010h], eax
        cmp dword [statsfromleague], byte 0
        jne short .1
        mov dword [dword ebp-0428h], 4Ch
        jmp short .2
.1:
        mov dword [dword ebp-0428h], 2E8h
.2:
        mov eax, dword [dword ebp-0428h]
        mov dword [byte ebp-030h], eax
        lea eax, [dword ebp-08Eh]
        mov dword [byte ebp-02Ch], eax
        mov dword [byte ebp-018h], 0
.3:
        cmp dword [byte ebp-018h], byte 1Ah
        jl short .5
        jmp near .8
.4:
        inc dword [byte ebp-018h]
        jmp short StandingsScreen.3
.5:
        xor ebx, ebx
        mov edx, dword [byte ebp-030h]
        imul edx, dword [byte ebp-018h]
        mov eax, dword [byte ebp-010h]
        call lseek_
        mov ebx, 34h
        lea edx, [dword ebp-0A8h]
        mov eax, dword [byte ebp-010h]
        call read_
        mov eax, dword [byte ebp-02Ch]
        mov al, byte [byte eax+0Fh]
        xor ah, ah
        add eax, eax
        mov ebx, eax
        mov eax, dword [byte ebp-02Ch]
        xor dh, dh
        mov dl, byte [byte eax+011h]
        mov eax, dword [byte ebp-02Ch]
        add ebx, edx
        mov word [byte eax+016h], bx
        mov eax, dword [byte ebp-02Ch]
        cmp byte [byte eax+0Eh], 0
        je short .6
        mov edx, dword [byte ebp-02Ch]
        xor eax, eax
        mov ax, word [byte edx+016h]
        imul eax, dword 3E8h
        mov edx, dword [byte ebp-02Ch]
        mov dl, byte [byte edx+0Eh]
        and edx, 0FFh
        add edx, eax
        mov eax, dword [byte ebp-02Ch]
        mov al, byte [byte eax+0Eh]
        and eax, 0FFh
        add eax, eax
        mov ebx, eax
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov edx, dword [byte ebp-02Ch]
        mov word [byte edx+018h], ax
        jmp short .7
.6:
        mov eax, dword [byte ebp-02Ch]
        mov word [byte eax+018h], 0
.7:
        imul eax, dword [byte ebp-018h], byte 1Ah
        mov edx, dword [byte ebp-034h]
        add edx, eax
        mov dword [byte ebp-01Ch], edx
        mov ecx, 6
        mov edi, dword [byte ebp-01Ch]
        mov esi, dword [byte ebp-02Ch]
        rep movsd
        movsw
        mov edx, dword [byte ebp-018h]
        shl edx, 2
        add edx, dword [byte ebp-03Ch]
        mov eax, dword [byte ebp-018h]
        mov dword [edx], eax
        jmp near StandingsScreen.4
.8:
        mov eax, dword [byte ebp-010h]
        call j___close_
        mov ecx, CmpConfStandings
        mov ebx, 4
        mov edx, 1Ah
        mov eax, dword [byte ebp-03Ch]
        call qsort_
        call SetScreenTarget
        mov dword [dword ebp-042Ch], 0
        mov eax, dword [statsplayoffs]
        shl eax, 2
        mov eax, dword [dword eax+statsbgnames]
        mov dword [dword ebp-0430h], eax
        cmp byte [fileoncd+08Ch], 1
        jne short .9
        mov eax, dword [cddriveptr]
        mov dword [dword ebp-0434h], eax
        jmp short .10
.9:
        mov dword [dword ebp-0434h], 0
.10:
        mov edx, dword [dword ebp-0434h]
        lea eax, [byte ebp-074h]
        mov ecx, dword [dword ebp-042Ch]
        mov ebx, dword [dword ebp-0430h]
        call MakePath
        push byte 0
        lea eax, [byte ebp-074h]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        mov eax, str_Bkgd2
        push eax
        push dword [statsbgshapes]
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        push dword 1E0h
        push byte 13h
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        push dword [statspalshape]
        call DrawShape
        add esp, byte 4
        push dword 1E0h
        push byte 0
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        push dword [statsbgshapes]
        call FreeMemBlock
        add esp, byte 4
        mov dword [dword ebp-0438h], 0
        mov eax, str_Pstatbar8
        mov dword [dword ebp-043Ch], eax
        cmp byte [fileoncd+013Ch], 1
        jne short .11
        mov eax, dword [cddriveptr]
        mov dword [dword ebp-0440h], eax
        jmp short .12
.11:
        mov dword [dword ebp-0440h], 0
.12:
        mov edx, dword [dword ebp-0440h]
        lea eax, [byte ebp-074h]
        mov ecx, dword [dword ebp-0438h]
        mov ebx, dword [dword ebp-043Ch]
        call MakePath
        push byte 0
        lea eax, [byte ebp-074h]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        mov eax, str_Pst27
        push eax
        push dword [statsbgshapes]
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        push byte 1Ch
        push byte 0
        push dword [statspalshape]
        call DrawArt
        add esp, byte 0Ch
        push dword [statsbgshapes]
        call FreeMemBlock
        add esp, byte 4
        call TextGridOpen
        lea eax, [dword ebp-0E8h]
        push eax
        call TextSaveState
        add esp, byte 4
        push dword [byte ebp-0Ch]
        call TextSetFont
        add esp, byte 4
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        mov dword [byte ebp-024h], 31h
        mov edx, str_Standings
        lea eax, [dword ebp-013Ch]
        call MakeStatsTitle
        lea esi, [dword ebp-013Ch]
        mov edi, dword [byte ebp-024h]
        lea eax, [dword ebp-013Ch]
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, 12Ch
        sub edx, eax
        mov eax, edx
        mov ebx, esi
        mov edx, edi
        call PrintOutlinedText
        mov dword [byte ebp-024h], 50h
        mov esi, str_Western
        mov edi, dword [byte ebp-026h]
        sar edi, 10h
        mov eax, str_Western
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, 0A0h
        sub edx, eax
        mov eax, edx
        cwde
        mov ebx, esi
        mov edx, edi
        call PrintShadowText
        mov esi, str_Conference
        mov eax, dword [byte ebp-024h]
        add eax, 10h
        movsx edi, ax
        mov eax, str_Conference
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, 0A0h
        sub edx, eax
        mov eax, edx
        cwde
        mov ebx, esi
        mov edx, edi
        call PrintShadowText
        mov esi, str_Eastern
        mov edi, dword [byte ebp-026h]
        sar edi, 10h
        mov eax, str_Eastern
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, 1E0h
        sub edx, eax
        mov eax, edx
        cwde
        mov ebx, esi
        mov edx, edi
        call PrintShadowText
        mov esi, str_Conference
        mov eax, dword [byte ebp-024h]
        add eax, 10h
        movsx edi, ax
        mov eax, str_Conference
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, 1E0h
        sub edx, eax
        mov eax, edx
        cwde
        mov ebx, esi
        mov edx, edi
        call PrintShadowText
        push dword [byte ebp-08h]
        call TextSetFont
        add esp, byte 4
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        add dword [byte ebp-024h], byte 57h
        mov dword [byte ebp-028h], 0FFFFFFFFh
        mov dword [byte ebp-018h], 0
.13:
        cmp dword [byte ebp-018h], byte 1Ah
        jl short .15
        jmp near .22
.14:
        inc dword [byte ebp-018h]
        jmp short StandingsScreen.13
.15:
        mov eax, dword [byte ebp-018h]
        shl eax, 2
        add eax, dword [byte ebp-03Ch]
        imul eax, dword [eax], byte 1Ah
        mov edx, dword [byte ebp-034h]
        add edx, eax
        mov dword [byte ebp-01Ch], edx
        mov eax, dword [byte ebp-01Ch]
        mov al, byte [byte eax+0Dh]
        and eax, 0FFh
        cmp eax, dword [byte ebp-028h]
        je near .16
        mov edx, dword [byte ebp-01Ch]
        mov dl, byte [byte edx+0Dh]
        and edx, 0FFh
        mov ebx, 4
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov dword [byte ebp-028h], edx
        mov eax, dword [byte ebp-028h]
        shl eax, 2
        mov eax, dword [dword eax+divx]
        mov dword [byte ebp-020h], eax
        mov eax, dword [byte ebp-028h]
        shl eax, 2
        mov eax, dword [dword eax+divy]
        mov dword [byte ebp-024h], eax
        mov eax, dword [byte ebp-028h]
        shl eax, 2
        mov ebx, dword [dword eax+divisionnames]
        mov edx, dword [byte ebp-026h]
        sar edx, 10h
        mov eax, dword [byte ebp-022h]
        sar eax, 10h
        call PrintShadowText
        add dword [byte ebp-024h], byte 12h
        mov ebx, str_Team
        mov edx, dword [byte ebp-026h]
        sar edx, 10h
        mov eax, dword [byte ebp-022h]
        sar eax, 10h
        call PrintShadowText
        mov ebx, str_GP7
        mov edx, dword [byte ebp-026h]
        sar edx, 10h
        mov eax, dword [byte ebp-020h]
        add eax, 64h
        cwde
        call PrintShadowText
        mov ebx, str_W4
        mov edx, dword [byte ebp-026h]
        sar edx, 10h
        mov eax, dword [byte ebp-020h]
        add eax, 78h
        cwde
        call PrintShadowText
        mov ebx, str_L6
        mov edx, dword [byte ebp-026h]
        sar edx, 10h
        mov eax, dword [byte ebp-020h]
        add eax, 8Ch
        cwde
        call PrintShadowText
        mov ebx, str_T4
        mov edx, dword [byte ebp-026h]
        sar edx, 10h
        mov eax, dword [byte ebp-020h]
        add eax, 0A0h
        cwde
        call PrintShadowText
        mov ebx, str_GF
        mov edx, dword [byte ebp-026h]
        sar edx, 10h
        mov eax, dword [byte ebp-020h]
        add eax, 0B4h
        cwde
        call PrintShadowText
        mov ebx, str_GA2
        mov edx, dword [byte ebp-026h]
        sar edx, 10h
        mov eax, dword [byte ebp-020h]
        add eax, 0D2h
        cwde
        call PrintShadowText
        mov ebx, str_P
        mov edx, dword [byte ebp-026h]
        sar edx, 10h
        mov eax, dword [byte ebp-020h]
        add eax, 0F0h
        cwde
        call PrintShadowText
        mov ebx, str_Pct4
        mov edx, dword [byte ebp-026h]
        sar edx, 10h
        mov eax, dword [byte ebp-020h]
        add eax, 10Eh
        cwde
        call PrintShadowText
        add dword [byte ebp-024h], byte 13h
.16:
        cmp dword [statsfromleague], byte 0
        jne short .17
        mov eax, dword [byte ebp-01Ch]
        cmp byte [byte eax+0Eh], 0
        je short .18
.17:
        jmp short .19
.18:
        jmp near StandingsScreen.14
.19:
        mov ecx, 6
        mov edi, dword [byte ebp-02Ch]
        mov esi, dword [byte ebp-01Ch]
        rep movsd
        movsw
        mov ebx, dword [byte ebp-02Ch]
        mov edx, dword [byte ebp-026h]
        sar edx, 10h
        mov eax, dword [byte ebp-022h]
        sar eax, 10h
        call PrintShadowText
        mov eax, dword [byte ebp-02Ch]
        mov al, byte [byte eax+0Eh]
        xor ah, ah
        movsx ecx, ax
        mov ebx, str_fmt2d
        mov edx, dword [byte ebp-026h]
        sar edx, 10h
        mov eax, dword [byte ebp-020h]
        add eax, 64h
        cwde
        call PrintFmt1
        mov eax, dword [byte ebp-02Ch]
        mov al, byte [byte eax+0Fh]
        xor ah, ah
        movsx ecx, ax
        mov ebx, str_fmt2d
        mov edx, dword [byte ebp-026h]
        sar edx, 10h
        mov eax, dword [byte ebp-020h]
        add eax, 78h
        cwde
        call PrintFmt1
        mov edx, dword [byte ebp-02Ch]
        xor eax, eax
        mov al, byte [byte edx+010h]
        movsx ecx, ax
        mov ebx, str_fmt2d
        mov edx, dword [byte ebp-026h]
        sar edx, 10h
        mov eax, dword [byte ebp-020h]
        add eax, 8Ch
        cwde
        call PrintFmt1
        mov edx, dword [byte ebp-02Ch]
        xor eax, eax
        mov al, byte [byte edx+011h]
        movsx ecx, ax
        mov ebx, str_fmt2d
        mov edx, dword [byte ebp-026h]
        sar edx, 10h
        mov eax, dword [byte ebp-020h]
        add eax, 0A0h
        cwde
        call PrintFmt1
        mov ecx, dword [byte ebp-02Ch]
        mov ecx, dword [byte ecx+010h]
        sar ecx, 10h
        mov ebx, str_fmt3d
        mov edx, dword [byte ebp-026h]
        sar edx, 10h
        mov eax, dword [byte ebp-020h]
        add eax, 0B4h
        cwde
        call PrintFmt1
        mov ecx, dword [byte ebp-02Ch]
        mov ecx, dword [byte ecx+012h]
        sar ecx, 10h
        mov ebx, str_fmt3d
        mov edx, dword [byte ebp-026h]
        sar edx, 10h
        mov eax, dword [byte ebp-020h]
        add eax, 0D2h
        cwde
        call PrintFmt1
        mov eax, dword [byte ebp-02Ch]
        mov ecx, dword [byte eax+014h]
        sar ecx, 10h
        mov ebx, str_fmt3d
        mov edx, dword [byte ebp-026h]
        sar edx, 10h
        mov eax, dword [byte ebp-020h]
        add eax, 0F0h
        cwde
        call PrintFmt1
        mov eax, dword [byte ebp-02Ch]
        cmp word [byte eax+018h], 3E8h
        jae short .20
        mov edx, dword [byte ebp-02Ch]
        mov dx, word [byte edx+018h]
        and edx, 0FFFFh
        mov ebx, 3E8h
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        movsx ecx, dx
        mov ebx, str_fmtPct0
        mov edx, dword [byte ebp-026h]
        sar edx, 10h
        mov eax, dword [byte ebp-020h]
        add eax, 10Eh
        cwde
        call PrintFmt1
        jmp short .21
.20:
        mov edx, dword [byte ebp-02Ch]
        mov dx, word [byte edx+018h]
        and edx, 0FFFFh
        mov ebx, 3E8h
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        movsx eax, dx
        push eax
        mov edx, dword [byte ebp-02Ch]
        mov dx, word [byte edx+018h]
        and edx, 0FFFFh
        mov ebx, 3E8h
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        movsx ecx, ax
        mov ebx, str_fmtPct
        mov edx, dword [byte ebp-026h]
        sar edx, 10h
        mov eax, dword [byte ebp-020h]
        add eax, 10Eh
        cwde
        call PrintFmt2
.21:
        add dword [byte ebp-024h], byte 0Dh
        jmp near StandingsScreen.14
.22:
        call TextGridOff
        lea eax, [dword ebp-0E8h]
        push eax
        call TextRestoreState
        add esp, byte 4
        mov dword [byte ebp-038h], 0
        mov eax, dword [byte ebp-038h]
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; HighlightTreeSlot                            2785F  95 PC, medium confidence
; Finds the team's slot in treecolslots and draws the 80h highlight box
; (sub_91044) at treecolx / treerowy
;-----------------------------------------------------------------------------
; C: src/front/playoff/HighlightTreeSlot.c
%ifdef CBUILD
%include "c/front/playoff/HighlightTreeSlot.inc"
%else
HighlightTreeSlot:
        push dword 4Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 1Ch
        mov dword [byte ebp-01Ch], eax
        mov dword [byte ebp-08h], 0
.1:
        cmp word [byte ebp-08h], byte 8
        jl short .3
        jmp near .10
.2:
        inc dword [byte ebp-08h]
        jmp short HighlightTreeSlot.1
.3:
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        xor edx, edx
        mov dl, byte [dword eax+treecolslots]
        mov eax, dword [byte ebp-01Ch]
        cmp edx, dword [eax]
        jne short .6
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        sar eax, 1
        shl eax, 2
        mov ax, word [dword eax+treecolx]
        dec eax
        mov dword [byte ebp-0Ch], eax
        test byte [byte ebp-08h], 1
        jne short .4
        mov dword [byte ebp-010h], 4Ah
        jmp short .5
.4:
        mov dword [byte ebp-010h], 5Ah
.5:
        mov word [byte ebp-014h], 64h
        mov word [byte ebp-018h], 0Dh
        push dword 80h
        mov eax, dword [byte ebp-01Ah]
        sar eax, 10h
        push eax
        mov eax, dword [byte ebp-016h]
        sar eax, 10h
        push eax
        mov eax, dword [byte ebp-012h]
        sar eax, 10h
        push eax
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        push eax
        call sub_91044
        add esp, byte 14h
        jmp near .x
.6:
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        xor edx, edx
        mov dl, byte [dword eax+treecol_Er1]
        mov eax, dword [byte ebp-01Ch]
        cmp edx, dword [eax]
        jne short .9
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        sar eax, 1
        shl eax, 2
        mov ax, word [dword eax+treecolx]
        dec eax
        mov word [byte ebp-0Ch], ax
        test byte [byte ebp-08h], 1
        jne short .7
        mov word [byte ebp-010h], 180h
        jmp short .8
.7:
        mov word [byte ebp-010h], 190h
.8:
        mov word [byte ebp-014h], 64h
        mov word [byte ebp-018h], 0Dh
        push dword 80h
        mov eax, dword [byte ebp-01Ah]
        sar eax, 10h
        push eax
        mov eax, dword [byte ebp-016h]
        sar eax, 10h
        push eax
        mov eax, dword [byte ebp-012h]
        sar eax, 10h
        push eax
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        push eax
        call sub_91044
        add esp, byte 14h
        jmp near .x
.9:
        jmp near HighlightTreeSlot.2
.10:
        mov word [byte ebp-08h], 0
.11:
        cmp word [byte ebp-08h], byte 4
        jl short .13
        jmp near .20
.12:
        inc word [byte ebp-08h]
        jmp short HighlightTreeSlot.11
.13:
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        xor edx, edx
        mov dl, byte [dword eax+treecol_Wr2]
        mov eax, dword [byte ebp-01Ch]
        cmp edx, dword [eax]
        jne short .16
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        sar eax, 1
        shl eax, 2
        mov ax, word [dword eax+treerowy]
        dec eax
        mov word [byte ebp-0Ch], ax
        test byte [byte ebp-08h], 1
        jne short .14
        mov word [byte ebp-010h], 99h
        jmp short .15
.14:
        mov word [byte ebp-010h], 0A9h
.15:
        mov word [byte ebp-014h], 64h
        mov word [byte ebp-018h], 0Dh
        push dword 80h
        mov eax, dword [byte ebp-01Ah]
        sar eax, 10h
        push eax
        mov eax, dword [byte ebp-016h]
        sar eax, 10h
        push eax
        mov eax, dword [byte ebp-012h]
        sar eax, 10h
        push eax
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        push eax
        call sub_91044
        add esp, byte 14h
        jmp near .x
.16:
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        xor edx, edx
        mov dl, byte [dword eax+treecol_Er2]
        mov eax, dword [byte ebp-01Ch]
        cmp edx, dword [eax]
        jne near .19
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        sar eax, 1
        mov edx, 1
        sub edx, eax
        mov eax, edx
        shl eax, 2
        mov ax, word [dword eax+treerowy]
        add eax, 64h
        mov edx, 27Fh
        sub edx, eax
        mov word [byte ebp-0Ch], dx
        test byte [byte ebp-08h], 1
        jne short .17
        mov word [byte ebp-010h], 133h
        jmp short .18
.17:
        mov word [byte ebp-010h], 143h
.18:
        mov word [byte ebp-014h], 64h
        mov word [byte ebp-018h], 0Dh
        push dword 80h
        mov eax, dword [byte ebp-01Ah]
        sar eax, 10h
        push eax
        mov eax, dword [byte ebp-016h]
        sar eax, 10h
        push eax
        mov eax, dword [byte ebp-012h]
        sar eax, 10h
        push eax
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        push eax
        call sub_91044
        add esp, byte 14h
        jmp near .x
.19:
        jmp near HighlightTreeSlot.12
.20:
        mov word [byte ebp-08h], 0
.21:
        cmp word [byte ebp-08h], byte 2
        jl short .23
        jmp near .30
.22:
        inc word [byte ebp-08h]
        jmp short HighlightTreeSlot.21
.23:
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        xor edx, edx
        mov dl, byte [dword eax+treecolslots+10h]
        mov eax, dword [byte ebp-01Ch]
        cmp edx, dword [eax]
        jne short .26
        cmp word [byte ebp-08h], byte 0
        jne short .24
        mov word [byte ebp-010h], 0E6h
        jmp short .25
.24:
        mov word [byte ebp-010h], 0F6h
.25:
        push dword 80h
        push byte 0Dh
        push byte 64h
        mov eax, dword [byte ebp-012h]
        sar eax, 10h
        push eax
        push byte 47h
        call sub_91044
        add esp, byte 14h
        jmp near .x
.26:
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        xor edx, edx
        mov dl, byte [dword eax+treecolslots+30h]
        mov eax, dword [byte ebp-01Ch]
        cmp edx, dword [eax]
        jne short .29
        cmp word [byte ebp-08h], byte 0
        jne short .27
        mov word [byte ebp-010h], 0E6h
        jmp short .28
.27:
        mov word [byte ebp-010h], 0F6h
.28:
        push dword 80h
        push byte 0Dh
        push byte 64h
        mov eax, dword [byte ebp-012h]
        sar eax, 10h
        push eax
        push dword 1C5h
        call sub_91044
        add esp, byte 14h
        jmp short .x
.29:
        jmp near HighlightTreeSlot.22
.30:
        xor edx, edx
        mov dl, byte [treecolslots+18h]
        mov eax, dword [byte ebp-01Ch]
        cmp edx, dword [eax]
        jne short .31
        push dword 80h
        push byte 0Dh
        push byte 5Ch
        push dword 0E2h
        push dword 10Ah
        call sub_91044
        add esp, byte 14h
        jmp short .x
.31:
        xor edx, edx
        mov dl, byte [treecolslots+28h]
        mov eax, dword [byte ebp-01Ch]
        cmp edx, dword [eax]
        jne short .x
        push dword 80h
        push byte 0Dh
        push byte 5Ch
        push dword 0F2h
        push dword 10Ah
        call sub_91044
        add esp, byte 14h
.x:
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; MoveTreeHighlight                            27BC3  95 PC, medium confidence
; (old*, new*): unhighlight old, highlight new, *old = new; skips slots >=
; 1Ah; called by RunTeamPickMenu in playoff mode
;-----------------------------------------------------------------------------
; C: src/front/playoff/MoveTreeHighlight.c
%ifdef CBUILD
%include "c/front/playoff/MoveTreeHighlight.inc"
%else
MoveTreeHighlight:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 8
        mov dword [byte ebp-08h], eax
        mov dword [byte ebp-04h], edx
        cmp dword [byte ebp-08h], byte 0
        je short .1
        mov eax, dword [byte ebp-08h]
        mov eax, dword [eax]
        shl eax, 2
        cmp dword [dword eax+playofftree], byte 1Ah
        jl short .2
.1:
        jmp short .x
.2:
        mov eax, dword [byte ebp-08h]
        call HighlightTreeSlot
        cmp dword [byte ebp-04h], byte 0
        je short .3
        mov eax, dword [byte ebp-04h]
        mov eax, dword [eax]
        shl eax, 2
        cmp dword [dword eax+playofftree], byte 1Ah
        jl short .4
.3:
        jmp short .x
.4:
        mov eax, dword [byte ebp-04h]
        call HighlightTreeSlot
        mov eax, dword [byte ebp-04h]
        mov edx, dword [eax]
        mov eax, dword [byte ebp-08h]
        mov dword [eax], edx
.x:
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CountSeriesWins                              27C34  95 PC, medium confidence
; Loads the schedule (LoadScheduleDB or OpenStatsSchedule), counts wins per
; team over the 38h playoff games (6-byte entries, score +4/+5), writes wins
; for the 16 tree teams
;-----------------------------------------------------------------------------
; C: src/front/playoff/CountSeriesWins.c
%ifdef CBUILD
%include "c/front/playoff/CountSeriesWins.inc"
%else
CountSeriesWins:
        push dword 54h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 3Ch
        mov dword [byte ebp-014h], eax
        mov dword [byte ebp-01Ch], edx
        mov dword [byte ebp-018h], ebx
        cmp dword [byte ebp-018h], byte 0
        je short .1
        lea eax, [byte ebp-08h]
        call LoadScheduleDB
        jmp short .2
.1:
        lea eax, [byte ebp-08h]
        call OpenStatsSchedule
.2:
        add dword [byte ebp-08h], byte 2
        mov eax, dword [byte ebp-08h]
        add eax, 1998h
        mov dword [byte ebp-04h], eax
        mov dword [byte ebp-010h], 0
.3:
        cmp dword [byte ebp-010h], byte 1Ch
        jl short .5
        jmp short .6
.4:
        inc dword [byte ebp-010h]
        jmp short CountSeriesWins.3
.5:
        mov eax, dword [byte ebp-010h]
        mov byte [byte eax+ebp-03Ch], 0
        jmp short CountSeriesWins.4
.6:
        mov dword [byte ebp-010h], 0
.7:
        cmp dword [byte ebp-010h], byte 38h
        jl short .9
        jmp near .16
.8:
        inc dword [byte ebp-010h]
        add dword [byte ebp-04h], byte 6
        jmp short CountSeriesWins.7
.9:
        mov eax, dword [byte ebp-04h]
        cmp byte [byte eax+02h], 0FFh
        je short .10
        mov eax, dword [byte ebp-04h]
        cmp byte [byte eax+03h], 0FFh
        jne short .11
.10:
        jmp short .15
.11:
        mov eax, dword [byte ebp-04h]
        cmp byte [byte eax+04h], 0FFh
        je short .12
        mov eax, dword [byte ebp-04h]
        cmp byte [byte eax+05h], 0FFh
        jne short .13
.12:
        jmp short .15
.13:
        mov eax, dword [byte ebp-04h]
        mov dl, byte [byte eax+04h]
        mov eax, dword [byte ebp-04h]
        cmp dl, byte [byte eax+05h]
        jbe short .14
        mov eax, dword [byte ebp-04h]
        mov al, byte [byte eax+02h]
        and eax, 0FFh
        inc byte [byte eax+ebp-03Ch]
        jmp short .15
.14:
        mov eax, dword [byte ebp-04h]
        mov al, byte [byte eax+03h]
        and eax, 0FFh
        inc byte [byte eax+ebp-03Ch]
.15:
        jmp short CountSeriesWins.8
.16:
        mov dword [byte ebp-010h], 0
.17:
        cmp dword [byte ebp-010h], byte 10h
        jl short .19
        jmp short .20
.18:
        inc dword [byte ebp-010h]
        jmp short CountSeriesWins.17
.19:
        mov eax, dword [byte ebp-010h]
        shl eax, 2
        add eax, dword [byte ebp-014h]
        mov eax, dword [eax]
        xor edx, edx
        mov dl, byte [byte eax+ebp-03Ch]
        mov eax, dword [byte ebp-010h]
        shl eax, 2
        add eax, dword [byte ebp-01Ch]
        mov dword [eax], edx
        jmp short CountSeriesWins.18
.20:
        mov dword [byte ebp-010h], 0
.21:
        cmp dword [byte ebp-010h], byte 1Ah
        jl short .23
        jmp short .24
.22:
        inc dword [byte ebp-010h]
        jmp short CountSeriesWins.21
.23:
        mov eax, dword [byte ebp-010h]
        mov byte [byte eax+ebp-03Ch], 0
        jmp short CountSeriesWins.22
.24:
        mov dword [byte ebp-010h], 0
.25:
        cmp dword [byte ebp-010h], byte 1Ch
        jl short .27
        jmp near .34
.26:
        inc dword [byte ebp-010h]
        add dword [byte ebp-04h], byte 6
        jmp short CountSeriesWins.25
.27:
        mov eax, dword [byte ebp-04h]
        cmp byte [byte eax+02h], 0FFh
        je short .28
        mov eax, dword [byte ebp-04h]
        cmp byte [byte eax+03h], 0FFh
        jne short .29
.28:
        jmp short .33
.29:
        mov eax, dword [byte ebp-04h]
        cmp byte [byte eax+04h], 0FFh
        je short .30
        mov eax, dword [byte ebp-04h]
        cmp byte [byte eax+05h], 0FFh
        jne short .31
.30:
        jmp short .33
.31:
        mov eax, dword [byte ebp-04h]
        mov dl, byte [byte eax+04h]
        mov eax, dword [byte ebp-04h]
        cmp dl, byte [byte eax+05h]
        jbe short .32
        mov eax, dword [byte ebp-04h]
        mov al, byte [byte eax+02h]
        and eax, 0FFh
        inc byte [byte eax+ebp-03Ch]
        jmp short .33
.32:
        mov eax, dword [byte ebp-04h]
        mov al, byte [byte eax+03h]
        and eax, 0FFh
        inc byte [byte eax+ebp-03Ch]
.33:
        jmp short CountSeriesWins.26
.34:
        mov dword [byte ebp-010h], 10h
.35:
        cmp dword [byte ebp-010h], byte 18h
        jl short .37
        jmp short .38
.36:
        inc dword [byte ebp-010h]
        jmp short CountSeriesWins.35
.37:
        mov eax, dword [byte ebp-010h]
        shl eax, 2
        add eax, dword [byte ebp-014h]
        mov eax, dword [eax]
        xor edx, edx
        mov dl, byte [byte eax+ebp-03Ch]
        mov eax, dword [byte ebp-010h]
        shl eax, 2
        add eax, dword [byte ebp-01Ch]
        mov dword [eax], edx
        jmp short CountSeriesWins.36
.38:
        mov dword [byte ebp-010h], 0
.39:
        cmp dword [byte ebp-010h], byte 1Ah
        jl short .41
        jmp short .42
.40:
        inc dword [byte ebp-010h]
        jmp short CountSeriesWins.39
.41:
        mov eax, dword [byte ebp-010h]
        mov byte [byte eax+ebp-03Ch], 0
        jmp short CountSeriesWins.40
.42:
        mov dword [byte ebp-010h], 0
.43:
        cmp dword [byte ebp-010h], byte 0Eh
        jl short .45
        jmp near .52
.44:
        inc dword [byte ebp-010h]
        add dword [byte ebp-04h], byte 6
        jmp short CountSeriesWins.43
.45:
        mov eax, dword [byte ebp-04h]
        cmp byte [byte eax+02h], 0FFh
        je short .46
        mov eax, dword [byte ebp-04h]
        cmp byte [byte eax+03h], 0FFh
        jne short .47
.46:
        jmp short .51
.47:
        mov eax, dword [byte ebp-04h]
        cmp byte [byte eax+04h], 0FFh
        je short .48
        mov eax, dword [byte ebp-04h]
        cmp byte [byte eax+05h], 0FFh
        jne short .49
.48:
        jmp short .51
.49:
        mov eax, dword [byte ebp-04h]
        mov dl, byte [byte eax+04h]
        mov eax, dword [byte ebp-04h]
        cmp dl, byte [byte eax+05h]
        jbe short .50
        mov eax, dword [byte ebp-04h]
        mov al, byte [byte eax+02h]
        and eax, 0FFh
        inc byte [byte eax+ebp-03Ch]
        jmp short .51
.50:
        mov eax, dword [byte ebp-04h]
        mov al, byte [byte eax+03h]
        and eax, 0FFh
        inc byte [byte eax+ebp-03Ch]
.51:
        jmp short CountSeriesWins.44
.52:
        mov dword [byte ebp-010h], 18h
.53:
        cmp dword [byte ebp-010h], byte 1Ch
        jl short .55
        jmp short .56
.54:
        inc dword [byte ebp-010h]
        jmp short CountSeriesWins.53
.55:
        mov eax, dword [byte ebp-010h]
        shl eax, 2
        add eax, dword [byte ebp-014h]
        mov eax, dword [eax]
        xor edx, edx
        mov dl, byte [byte eax+ebp-03Ch]
        mov eax, dword [byte ebp-010h]
        shl eax, 2
        add eax, dword [byte ebp-01Ch]
        mov dword [eax], edx
        jmp short CountSeriesWins.54
.56:
        mov dword [byte ebp-010h], 0
.57:
        cmp dword [byte ebp-010h], byte 1Ah
        jl short .59
        jmp short .60
.58:
        inc dword [byte ebp-010h]
        jmp short CountSeriesWins.57
.59:
        mov eax, dword [byte ebp-010h]
        mov byte [byte eax+ebp-03Ch], 0
        jmp short CountSeriesWins.58
.60:
        mov dword [byte ebp-010h], 0
.61:
        cmp dword [byte ebp-010h], byte 7
        jl short .63
        jmp near .70
.62:
        inc dword [byte ebp-010h]
        add dword [byte ebp-04h], byte 6
        jmp short CountSeriesWins.61
.63:
        mov eax, dword [byte ebp-04h]
        cmp byte [byte eax+02h], 0FFh
        je short .64
        mov eax, dword [byte ebp-04h]
        cmp byte [byte eax+03h], 0FFh
        jne short .65
.64:
        jmp short .69
.65:
        mov eax, dword [byte ebp-04h]
        cmp byte [byte eax+04h], 0FFh
        je short .66
        mov eax, dword [byte ebp-04h]
        cmp byte [byte eax+05h], 0FFh
        jne short .67
.66:
        jmp short .69
.67:
        mov eax, dword [byte ebp-04h]
        mov dl, byte [byte eax+04h]
        mov eax, dword [byte ebp-04h]
        cmp dl, byte [byte eax+05h]
        jbe short .68
        mov eax, dword [byte ebp-04h]
        mov al, byte [byte eax+02h]
        and eax, 0FFh
        inc byte [byte eax+ebp-03Ch]
        jmp short .69
.68:
        mov eax, dword [byte ebp-04h]
        mov al, byte [byte eax+03h]
        and eax, 0FFh
        inc byte [byte eax+ebp-03Ch]
.69:
        jmp short CountSeriesWins.62
.70:
        mov dword [byte ebp-010h], 1Ch
.71:
        cmp dword [byte ebp-010h], byte 1Eh
        jl short .73
        jmp short .74
.72:
        inc dword [byte ebp-010h]
        jmp short CountSeriesWins.71
.73:
        mov eax, dword [byte ebp-010h]
        shl eax, 2
        add eax, dword [byte ebp-014h]
        mov eax, dword [eax]
        xor edx, edx
        mov dl, byte [byte eax+ebp-03Ch]
        mov eax, dword [byte ebp-010h]
        shl eax, 2
        add eax, dword [byte ebp-01Ch]
        mov dword [eax], edx
        jmp short CountSeriesWins.72
.74:
        mov eax, dword [byte ebp-08h]
        sub eax, byte 2
        push eax
        call FreeMemBlock
        add esp, byte 4
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; PlayoffTreeScreen                                               27F9C  95 PC
; Playoff tree: "Playoffs have not been seeded yet", rst1 / rst2, scuparrw,
; Western / Eastern Conference, aup / midl / adn arrows
;-----------------------------------------------------------------------------
; C: src/front/playoff/PlayoffTreeScreen.c
%ifdef CBUILD
%include "c/front/playoff/PlayoffTreeScreen.inc"
%else
PlayoffTreeScreen:
        push dword 224h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 1F8h
        mov dword [byte ebp-038h], 0
        mov eax, dword [mainfont]
        mov dword [byte ebp-02Ch], eax
        mov eax, dword [kaufmfont]
        mov dword [byte ebp-03Ch], eax
        cmp dword [playofftree], byte 1Ah
        jne short .1
        mov dword [off_CF6A3], 0
        jmp short .2
.1:
        mov dword [off_CF6A3], DeskSetExit3b
.2:
        call SetScreenTarget
        cmp dword [embscupbank], byte 0
        jne near .5
        mov dword [dword ebp-01CCh], 0
        mov eax, dword [statsplayoffs]
        shl eax, 2
        mov eax, dword [dword eax+statsbgnames]
        mov dword [dword ebp-01D0h], eax
        cmp byte [fileoncd+08Dh], 1
        jne short .3
        mov eax, dword [cddriveptr]
        mov dword [dword ebp-01D4h], eax
        jmp short .4
.3:
        mov dword [dword ebp-01D4h], 0
.4:
        mov edx, dword [dword ebp-01D4h]
        lea eax, [byte ebp-05Ch]
        mov ecx, dword [dword ebp-01CCh]
        mov ebx, dword [dword ebp-01D0h]
        call MakePath
        push byte 0
        lea eax, [byte ebp-05Ch]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        mov eax, str_Bkgd2
        push eax
        push dword [statsbgshapes]
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        push dword 1E0h
        push byte 13h
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        push dword [statspalshape]
        call DrawShape
        add esp, byte 4
        push dword 1E0h
        push byte 0
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        push dword [statsbgshapes]
        call FreeMemBlock
        add esp, byte 4
        jmp short .6
.5:
        mov eax, str_Bkgd2
        push eax
        push dword [embscupbank]
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        push dword 1E0h
        push byte 13h
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        push dword [statspalshape]
        call DrawShape
        add esp, byte 4
        push dword 1E0h
        push byte 0
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
.6:
        cmp dword [dword_C6D26], byte 1
        jne near .11
        mov dword [dword ebp-01D8h], 0
        mov eax, str_Embpal2
        mov dword [dword ebp-01DCh], eax
        cmp byte [fileoncd+08Eh], 1
        jne short .7
        mov eax, dword [cddriveptr]
        mov dword [dword ebp-01E0h], eax
        jmp short .8
.7:
        mov dword [dword ebp-01E0h], 0
.8:
        mov edx, dword [dword ebp-01E0h]
        lea eax, [byte ebp-05Ch]
        mov ecx, dword [dword ebp-01D8h]
        mov ebx, dword [dword ebp-01DCh]
        call MakePath
        push byte 0
        lea eax, [byte ebp-05Ch]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        mov eax, str_Pal9
        push eax
        push dword [statsbgshapes]
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        cmp dword [statspalvalid], byte 1
        jne short .9
        mov ebx, 300h
        mov edx, dword [statspalshape]
        add edx, byte 10h
        mov eax, dword [statspal]
        call memcpy_
        jmp short .10
.9:
        mov eax, dword [statspalshape]
        add eax, byte 10h
        push eax
        push dword 100h
        push byte 0
        call VgaSetPalette
        add esp, byte 0Ch
.10:
        push dword [statsbgshapes]
        call FreeMemBlock
        add esp, byte 4
        mov dword [dword_C6D26], 0
.11:
        xor ebx, ebx
        lea edx, [dword ebp-01C8h]
        mov eax, playofftree
        call CountSeriesWins
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        xor eax, eax
        mov al, byte [treecolslots]
        shl eax, 2
        cmp dword [dword eax+playofftree], byte 19h
        jle short .12
        push dword [byte ebp-03Ch]
        call TextSetFont
        add esp, byte 4
        mov ecx, 8
        lea edi, [dword ebp-0F0h]
        mov esi, str_PlayoffsHaveNotBeen2
        rep movsd
        movsw
        lea esi, [dword ebp-0F0h]
        mov edi, 0F0h
        lea eax, [dword ebp-0F0h]
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, 140h
        sub edx, eax
        mov eax, edx
        mov ebx, esi
        mov edx, edi
        call PrintOutlinedText
        push dword [byte ebp-02Ch]
        call TextSetFont
        add esp, byte 4
        jmp near .x
.12:
        mov dword [dword ebp-01E4h], 0
        mov eax, str_Pstatbar8
        mov dword [dword ebp-01E8h], eax
        cmp byte [fileoncd+013Ch], 1
        jne short .13
        mov eax, dword [cddriveptr]
        mov dword [dword ebp-01ECh], eax
        jmp short .14
.13:
        mov dword [dword ebp-01ECh], 0
.14:
        mov edx, dword [dword ebp-01ECh]
        lea eax, [byte ebp-05Ch]
        mov ecx, dword [dword ebp-01E4h]
        mov ebx, dword [dword ebp-01E8h]
        call MakePath
        push byte 0
        lea eax, [byte ebp-05Ch]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        mov eax, str_Rst12
        push eax
        push dword [statsbgshapes]
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        push byte 1Ah
        push byte 0
        push dword [statspalshape]
        call DrawArt
        add esp, byte 0Ch
        mov eax, str_Rst22
        push eax
        push dword [statsbgshapes]
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        push dword 192h
        push byte 0Fh
        push dword [statspalshape]
        call DrawArt
        add esp, byte 0Ch
        push dword [statsbgshapes]
        call FreeMemBlock
        add esp, byte 4
        mov dword [dword ebp-01F0h], 0
        mov eax, str_Scuparrw2
        mov dword [dword ebp-01F4h], eax
        cmp byte [fileoncd+016Eh], 1
        jne short .15
        mov eax, dword [cddriveptr]
        mov dword [dword ebp-01F8h], eax
        jmp short .16
.15:
        mov dword [dword ebp-01F8h], 0
.16:
        mov edx, dword [dword ebp-01F8h]
        lea eax, [byte ebp-05Ch]
        mov ecx, dword [dword ebp-01F0h]
        mov ebx, dword [dword ebp-01F4h]
        call MakePath
        push byte 0
        lea eax, [byte ebp-05Ch]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        call TextGridOpen
        lea eax, [dword ebp-09Ch]
        push eax
        call TextSaveState
        add esp, byte 4
        push dword [byte ebp-02Ch]
        call TextSetFont
        add esp, byte 4
        mov edx, str_Standings
        lea eax, [dword ebp-0F0h]
        call MakeStatsTitle
        lea edx, [dword ebp-0F0h]
        mov eax, 16h
        call PrintCenteredText
        push dword [byte ebp-03Ch]
        call TextSetFont
        add esp, byte 4
        lea edi, [dword ebp-0F0h]
        mov esi, str_WesternConference2
        movsd
        movsd
        movsd
        movsd
        movsw
        movsb
        lea esi, [dword ebp-0F0h]
        mov edi, 2Fh
        lea eax, [dword ebp-0F0h]
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, 140h
        sub edx, eax
        mov eax, edx
        mov ebx, esi
        mov edx, edi
        call PrintOutlinedText
        lea edi, [dword ebp-0F0h]
        mov esi, str_EasternConference2
        movsd
        movsd
        movsd
        movsd
        movsw
        movsb
        lea esi, [dword ebp-0F0h]
        mov edi, 1A7h
        lea eax, [dword ebp-0F0h]
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, 140h
        sub edx, eax
        mov eax, edx
        mov ebx, esi
        mov edx, edi
        call PrintOutlinedText
        push dword [byte ebp-02Ch]
        call TextSetFont
        add esp, byte 4
        mov dword [byte ebp-014h], 0
.17:
        cmp word [byte ebp-014h], byte 8
        jl short .19
        jmp near .24
.18:
        inc dword [byte ebp-014h]
        jmp short PlayoffTreeScreen.17
.19:
        cmp word [byte ebp-014h], byte 4
        jge short .20
        mov eax, dword [byte ebp-014h]
        mov dword [byte ebp-018h], eax
        mov edx, dword [byte ebp-016h]
        sar edx, 10h
        add edx, edx
        xor eax, eax
        mov al, byte [dword edx+treecolslots]
        mov dword [byte ebp-08h], eax
        jmp short .21
.20:
        mov eax, 7
        sub eax, dword [byte ebp-014h]
        mov dword [byte ebp-018h], eax
        mov edx, dword [byte ebp-016h]
        sar edx, 10h
        add edx, edx
        sub edx, byte 8
        mov eax, 7
        sub eax, edx
        mov edx, eax
        xor eax, eax
        mov al, byte [dword edx+treecolslots]
        mov dword [byte ebp-08h], eax
.21:
        mov edx, dword [byte ebp-016h]
        sar edx, 10h
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        shl eax, 2
        mov eax, dword [dword eax+playofftree]
        shl eax, 2
        mov dword [dword eax+potreeseeds], edx
        cmp word [byte ebp-014h], byte 4
        jge short .22
        mov eax, dword [byte ebp-014h]
        mov dword [byte ebp-018h], eax
        mov edx, dword [byte ebp-016h]
        sar edx, 10h
        add edx, edx
        xor eax, eax
        mov al, byte [dword edx+treecol_Er1]
        mov word [byte ebp-08h], ax
        jmp short .23
.22:
        mov eax, 7
        sub eax, dword [byte ebp-014h]
        mov dword [byte ebp-018h], eax
        mov edx, dword [byte ebp-016h]
        sar edx, 10h
        add edx, edx
        sub edx, byte 8
        mov eax, 7
        sub eax, edx
        mov edx, eax
        xor eax, eax
        mov al, byte [dword edx+treecol_Er1]
        mov word [byte ebp-08h], ax
.23:
        mov edx, dword [byte ebp-016h]
        sar edx, 10h
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        shl eax, 2
        mov eax, dword [dword eax+playofftree]
        shl eax, 2
        mov dword [dword eax+potreeseeds], edx
        jmp near PlayoffTreeScreen.18
.24:
        mov dword [byte ebp-034h], 48h
        mov word [byte ebp-014h], 0
.25:
        cmp word [byte ebp-014h], byte 8
        jl short .27
        jmp near .38
.26:
        inc word [byte ebp-014h]
        jmp short PlayoffTreeScreen.25
.27:
        cmp word [byte ebp-014h], byte 4
        jge short .28
        mov eax, dword [byte ebp-014h]
        mov dword [byte ebp-018h], eax
        mov edx, dword [byte ebp-016h]
        sar edx, 10h
        add edx, edx
        xor eax, eax
        mov al, byte [dword edx+treecolslots]
        mov word [byte ebp-08h], ax
        jmp short .29
.28:
        mov eax, 7
        sub eax, dword [byte ebp-014h]
        mov dword [byte ebp-018h], eax
        mov edx, dword [byte ebp-016h]
        sar edx, 10h
        add edx, edx
        sub edx, byte 8
        mov eax, 7
        sub eax, edx
        mov edx, eax
        xor eax, eax
        mov al, byte [dword edx+treecolslots]
        mov word [byte ebp-08h], ax
.29:
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        shl eax, 2
        mov eax, dword [dword eax+playofftree]
        shl eax, 2
        mov eax, dword [dword eax+potreeseeds]
        add eax, 91h
        push eax
        mov eax, str_C3
        push eax
        lea eax, [dword ebp-0F0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        shl eax, 2
        imul edx, dword [dword eax+playofftree], byte 15h
        mov eax, treeteamnames
        add edx, eax
        lea eax, [dword ebp-0F0h]
        call strcat_
        lea ebx, [dword ebp-0F0h]
        mov edx, dword [byte ebp-036h]
        sar edx, 10h
        mov eax, dword [byte ebp-01Ah]
        sar eax, 10h
        shl eax, 2
        mov eax, dword [dword eax+treecolx-2]
        sar eax, 10h
        call PrintShadowText
        mov eax, dword [byte ebp-01Ah]
        sar eax, 10h
        shl eax, 2
        mov ax, word [dword eax+treecolx]
        add eax, 6Ah
        mov dword [byte ebp-024h], eax
        xor edx, edx
        mov dl, byte [treecol_Wr2]
        shl edx, 2
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        shl eax, 2
        mov edx, dword [dword edx+playofftree]
        cmp edx, dword [dword eax+playofftree]
        je short .30
        xor eax, eax
        mov al, byte [treecol_Wr2+1]
        shl eax, 2
        mov edx, dword [byte ebp-0Ah]
        sar edx, 10h
        shl edx, 2
        mov eax, dword [dword eax+playofftree]
        cmp eax, dword [dword edx+playofftree]
        jne short .31
.30:
        jmp short .32
.31:
        xor eax, eax
        mov al, byte [treecol_Wr2+2]
        shl eax, 2
        mov edx, dword [byte ebp-0Ah]
        sar edx, 10h
        shl edx, 2
        mov eax, dword [dword eax+playofftree]
        cmp eax, dword [dword edx+playofftree]
        jne short .33
.32:
        jmp short .34
.33:
        xor eax, eax
        mov al, byte [treecol_Wr2+3]
        shl eax, 2
        mov edx, dword [byte ebp-0Ah]
        sar edx, 10h
        shl edx, 2
        mov eax, dword [dword eax+playofftree]
        cmp eax, dword [dword edx+playofftree]
        jne short .35
.34:
        mov edx, 43h
        mov eax, 44h
        call SetTextColors
        jmp short .36
.35:
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
.36:
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        shl eax, 2
        push dword [dword eax+ebp-01C8h]
        mov eax, str_D3
        push eax
        lea eax, [dword ebp-0F0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea ebx, [dword ebp-0F0h]
        mov edx, dword [byte ebp-036h]
        sar edx, 10h
        mov eax, dword [byte ebp-026h]
        sar eax, 10h
        call PrintShadowText
        cmp word [byte ebp-014h], byte 3
        jne short .37
        add dword [byte ebp-034h], byte 10h
.37:
        jmp near PlayoffTreeScreen.26
.38:
        add dword [byte ebp-034h], byte 3Fh
        xor eax, eax
        mov al, byte [treecol_Wr2]
        shl eax, 2
        cmp dword [dword eax+playofftree], byte 1Ah
        jge short .39
        xor eax, eax
        mov al, byte [treecol_Wr2+1]
        shl eax, 2
        cmp dword [dword eax+playofftree], byte 1Ah
        jl short .40
.39:
        jmp short .41
.40:
        xor eax, eax
        mov al, byte [treecol_Wr2+2]
        shl eax, 2
        cmp dword [dword eax+playofftree], byte 1Ah
        jl short .42
.41:
        jmp short .43
.42:
        xor eax, eax
        mov al, byte [treecol_Wr2+3]
        shl eax, 2
        cmp dword [dword eax+playofftree], byte 1Ah
        jl short .44
.43:
        jmp near .64
.44:
        mov eax, str_Aup12
        push eax
        push dword [statsbgshapes]
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        push dword [statspalshape]
        call DrawShape
        add esp, byte 4
        mov word [byte ebp-014h], 0
.45:
        cmp word [byte ebp-014h], byte 4
        jl short .47
        jmp near .54
.46:
        inc word [byte ebp-014h]
        jmp short PlayoffTreeScreen.45
.47:
        cmp word [byte ebp-014h], byte 2
        jge short .48
        mov eax, dword [byte ebp-014h]
        add eax, 4
        mov word [byte ebp-018h], ax
        mov edx, dword [byte ebp-016h]
        sar edx, 10h
        add edx, edx
        xor eax, eax
        mov al, byte [dword edx+treecol_Wr2]
        mov word [byte ebp-08h], ax
        jmp short .49
.48:
        mov eax, 7
        sub eax, dword [byte ebp-014h]
        mov word [byte ebp-018h], ax
        mov edx, dword [byte ebp-016h]
        sar edx, 10h
        add edx, edx
        sub edx, byte 4
        mov eax, 3
        sub eax, edx
        mov edx, eax
        xor eax, eax
        mov al, byte [dword edx+treecol_Wr2]
        mov word [byte ebp-08h], ax
.49:
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        shl eax, 2
        mov eax, dword [dword eax+playofftree]
        shl eax, 2
        mov eax, dword [dword eax+potreeseeds]
        add eax, 91h
        push eax
        mov eax, str_C3
        push eax
        lea eax, [dword ebp-0F0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        shl eax, 2
        imul edx, dword [dword eax+playofftree], byte 15h
        mov eax, treeteamnames
        add edx, eax
        lea eax, [dword ebp-0F0h]
        call strcat_
        lea ebx, [dword ebp-0F0h]
        mov edx, dword [byte ebp-036h]
        sar edx, 10h
        mov eax, dword [byte ebp-01Ah]
        sar eax, 10h
        shl eax, 2
        mov eax, dword [dword eax+treecolx-2]
        sar eax, 10h
        call PrintShadowText
        mov eax, dword [byte ebp-01Ah]
        sar eax, 10h
        shl eax, 2
        mov ax, word [dword eax+treecolx]
        add eax, 6Ah
        mov word [byte ebp-024h], ax
        xor edx, edx
        mov dl, byte [treecolslots+10h]
        shl edx, 2
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        shl eax, 2
        mov edx, dword [dword edx+playofftree]
        cmp edx, dword [dword eax+playofftree]
        je short .50
        xor eax, eax
        mov al, byte [treecolslots+11h]
        shl eax, 2
        mov edx, dword [byte ebp-0Ah]
        sar edx, 10h
        shl edx, 2
        mov eax, dword [dword eax+playofftree]
        cmp eax, dword [dword edx+playofftree]
        jne short .51
.50:
        mov edx, 43h
        mov eax, 44h
        call SetTextColors
        jmp short .52
.51:
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
.52:
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        shl eax, 2
        push dword [dword eax+ebp-01C8h]
        mov eax, str_D3
        push eax
        lea eax, [dword ebp-0F0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea ebx, [dword ebp-0F0h]
        mov edx, dword [byte ebp-036h]
        sar edx, 10h
        mov eax, dword [byte ebp-026h]
        sar eax, 10h
        call PrintShadowText
        cmp word [byte ebp-014h], byte 1
        jne short .53
        add dword [byte ebp-034h], byte 10h
.53:
        jmp near PlayoffTreeScreen.46
.54:
        add dword [byte ebp-034h], byte 3Dh
        xor eax, eax
        mov al, byte [treecolslots+10h]
        shl eax, 2
        cmp dword [dword eax+playofftree], byte 1Ah
        jge short .55
        xor eax, eax
        mov al, byte [treecolslots+11h]
        shl eax, 2
        cmp dword [dword eax+playofftree], byte 1Ah
        jl short .56
.55:
        jmp near .63
.56:
        mov eax, str_Aup22
        push eax
        push dword [statsbgshapes]
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        push dword [statspalshape]
        call DrawShape
        add esp, byte 4
        xor eax, eax
        mov al, byte [treecolslots+10h]
        mov word [byte ebp-08h], ax
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        shl eax, 2
        mov eax, dword [dword eax+playofftree]
        shl eax, 2
        mov eax, dword [dword eax+potreeseeds]
        add eax, 91h
        push eax
        mov eax, str_C3
        push eax
        lea eax, [dword ebp-0F0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        shl eax, 2
        imul eax, dword [dword eax+playofftree], byte 15h
        mov edx, treeteamnames
        add edx, eax
        lea eax, [dword ebp-0F0h]
        call strcat_
        lea ebx, [dword ebp-0F0h]
        mov eax, dword [byte ebp-034h]
        dec eax
        movsx edx, ax
        mov eax, 48h
        call PrintShadowText
        xor eax, eax
        mov al, byte [treecolslots+18h]
        shl eax, 2
        mov edx, dword [byte ebp-0Ah]
        sar edx, 10h
        shl edx, 2
        mov eax, dword [dword eax+playofftree]
        cmp eax, dword [dword edx+playofftree]
        je short .57
        xor eax, eax
        mov al, byte [treecolslots+28h]
        shl eax, 2
        mov edx, dword [byte ebp-0Ah]
        sar edx, 10h
        shl edx, 2
        mov eax, dword [dword eax+playofftree]
        cmp eax, dword [dword edx+playofftree]
        jne short .58
.57:
        mov edx, 43h
        mov eax, 44h
        call SetTextColors
        jmp short .59
.58:
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
.59:
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        shl eax, 2
        push dword [dword eax+ebp-01C8h]
        mov eax, str_D3
        push eax
        lea eax, [dword ebp-0F0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea ebx, [dword ebp-0F0h]
        mov eax, dword [byte ebp-034h]
        dec eax
        movsx edx, ax
        mov eax, 0B2h
        call PrintShadowText
        add dword [byte ebp-034h], byte 10h
        xor eax, eax
        mov al, byte [treecolslots+11h]
        mov word [byte ebp-08h], ax
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        shl eax, 2
        mov eax, dword [dword eax+playofftree]
        shl eax, 2
        mov eax, dword [dword eax+potreeseeds]
        add eax, 91h
        push eax
        mov eax, str_C3
        push eax
        lea eax, [dword ebp-0F0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        shl eax, 2
        imul eax, dword [dword eax+playofftree], byte 15h
        mov edx, treeteamnames
        add edx, eax
        lea eax, [dword ebp-0F0h]
        call strcat_
        lea ebx, [dword ebp-0F0h]
        mov eax, dword [byte ebp-034h]
        dec eax
        movsx edx, ax
        mov eax, 48h
        call PrintShadowText
        xor eax, eax
        mov al, byte [treecolslots+18h]
        shl eax, 2
        mov edx, dword [byte ebp-0Ah]
        sar edx, 10h
        shl edx, 2
        mov eax, dword [dword eax+playofftree]
        cmp eax, dword [dword edx+playofftree]
        je short .60
        xor eax, eax
        mov al, byte [treecolslots+28h]
        shl eax, 2
        mov edx, dword [byte ebp-0Ah]
        sar edx, 10h
        shl edx, 2
        mov eax, dword [dword eax+playofftree]
        cmp eax, dword [dword edx+playofftree]
        jne short .61
.60:
        mov edx, 43h
        mov eax, 44h
        call SetTextColors
        jmp short .62
.61:
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
.62:
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        shl eax, 2
        push dword [dword eax+ebp-01C8h]
        mov eax, str_D3
        push eax
        lea eax, [dword ebp-0F0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea ebx, [dword ebp-0F0h]
        mov eax, dword [byte ebp-034h]
        dec eax
        movsx edx, ax
        mov eax, 0B2h
        call PrintShadowText
        sub dword [byte ebp-034h], byte 10h
.63:
        jmp short .65
.64:
        add dword [byte ebp-034h], byte 4Dh
.65:
        xor eax, eax
        mov al, byte [treecolslots+18h]
        shl eax, 2
        cmp dword [dword eax+playofftree], byte 1Ah
        jge near .70
        mov eax, str_Aup32
        push eax
        push dword [statsbgshapes]
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        push dword [statspalshape]
        call DrawShape
        add esp, byte 4
        mov dword [byte ebp-038h], 1
        mov eax, str_Midl2
        push eax
        push dword [statsbgshapes]
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        push dword [statspalshape]
        call DrawShape
        add esp, byte 4
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        lea edi, [dword ebp-0F0h]
        mov esi, str_TwoSpaces
        movsw
        movsb
        xor eax, eax
        mov al, byte [treecolslots+18h]
        mov word [byte ebp-08h], ax
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        shl eax, 2
        imul edx, dword [dword eax+playofftree], byte 15h
        mov eax, treeteamnames
        add edx, eax
        lea eax, [dword ebp-0F0h]
        call strcat_
        lea ebx, [dword ebp-0F0h]
        mov eax, dword [byte ebp-034h]
        sub eax, byte 4
        movsx edx, ax
        mov eax, 102h
        call PrintShadowText
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        shl eax, 2
        push dword [dword eax+ebp-01C8h]
        mov eax, str_D3
        push eax
        lea eax, [dword ebp-0F0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        xor eax, eax
        mov al, byte [treecolslots+20h]
        shl eax, 2
        mov edx, dword [byte ebp-0Ah]
        sar edx, 10h
        shl edx, 2
        mov eax, dword [dword eax+playofftree]
        cmp eax, dword [dword edx+playofftree]
        jne short .68
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        shl eax, 2
        cmp dword [dword eax+teamconf], byte 3
        jne short .66
        mov edx, 43h
        mov eax, 44h
        call SetTextColors
        jmp short .67
.66:
        mov edx, 43h
        mov eax, 0C4h
        call SetTextColors
.67:
        jmp short .69
.68:
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
.69:
        lea ebx, [dword ebp-0F0h]
        mov eax, dword [byte ebp-034h]
        sub eax, byte 4
        movsx edx, ax
        mov eax, 16Ch
        call PrintShadowText
.70:
        xor eax, eax
        mov al, byte [treecolslots+28h]
        shl eax, 2
        cmp dword [dword eax+playofftree], byte 1Ah
        jge near .76
        mov eax, str_Adn32
        push eax
        push dword [statsbgshapes]
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        push dword [statspalshape]
        call DrawShape
        add esp, byte 4
        cmp dword [byte ebp-038h], byte 0
        jne short .71
        mov eax, str_Midl2
        push eax
        push dword [statsbgshapes]
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        push dword [statspalshape]
        call DrawShape
        add esp, byte 4
.71:
        add dword [byte ebp-034h], byte 10h
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        lea edi, [dword ebp-0F0h]
        mov esi, str_TwoSpaces
        movsw
        movsb
        xor eax, eax
        mov al, byte [treecolslots+28h]
        mov word [byte ebp-08h], ax
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        shl eax, 2
        imul eax, dword [dword eax+playofftree], byte 15h
        mov edx, treeteamnames
        add edx, eax
        lea eax, [dword ebp-0F0h]
        call strcat_
        lea ebx, [dword ebp-0F0h]
        mov eax, dword [byte ebp-034h]
        sub eax, byte 4
        movsx edx, ax
        mov eax, 102h
        call PrintShadowText
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        shl eax, 2
        push dword [dword eax+ebp-01C8h]
        mov eax, str_D3
        push eax
        lea eax, [dword ebp-0F0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        xor eax, eax
        mov al, byte [treecolslots+20h]
        shl eax, 2
        mov edx, dword [byte ebp-0Ah]
        sar edx, 10h
        shl edx, 2
        mov eax, dword [dword eax+playofftree]
        cmp eax, dword [dword edx+playofftree]
        jne short .74
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        shl eax, 2
        cmp dword [dword eax+teamconf], byte 3
        jne short .72
        mov edx, 43h
        mov eax, 44h
        call SetTextColors
        jmp short .73
.72:
        mov edx, 43h
        mov eax, 0C4h
        call SetTextColors
.73:
        jmp short .75
.74:
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
.75:
        lea ebx, [dword ebp-0F0h]
        mov eax, dword [byte ebp-034h]
        sub eax, byte 4
        movsx edx, ax
        mov eax, 16Ch
        call PrintShadowText
        sub dword [byte ebp-034h], byte 10h
.76:
        xor eax, eax
        mov al, byte [treecolslots+30h]
        shl eax, 2
        cmp dword [dword eax+playofftree], byte 1Ah
        jge short .77
        xor eax, eax
        mov al, byte [treecolslots+31h]
        shl eax, 2
        cmp dword [dword eax+playofftree], byte 1Ah
        jl short .78
.77:
        jmp near .85
.78:
        xor eax, eax
        mov al, byte [treecolslots+30h]
        mov word [byte ebp-08h], ax
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        shl eax, 2
        mov eax, dword [dword eax+playofftree]
        shl eax, 2
        mov eax, dword [dword eax+potreeseeds]
        add eax, 91h
        push eax
        mov eax, str_C3
        push eax
        lea eax, [dword ebp-0F0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        shl eax, 2
        imul edx, dword [dword eax+playofftree], byte 15h
        mov eax, treeteamnames
        add edx, eax
        lea eax, [dword ebp-0F0h]
        call strcat_
        lea ebx, [dword ebp-0F0h]
        mov eax, dword [byte ebp-034h]
        dec eax
        movsx edx, ax
        mov eax, 1C6h
        call PrintShadowText
        xor eax, eax
        mov al, byte [treecolslots+18h]
        shl eax, 2
        mov edx, dword [byte ebp-0Ah]
        sar edx, 10h
        shl edx, 2
        mov eax, dword [dword eax+playofftree]
        cmp eax, dword [dword edx+playofftree]
        je short .79
        xor eax, eax
        mov al, byte [treecolslots+28h]
        shl eax, 2
        mov edx, dword [byte ebp-0Ah]
        sar edx, 10h
        shl edx, 2
        mov eax, dword [dword eax+playofftree]
        cmp eax, dword [dword edx+playofftree]
        jne short .80
.79:
        mov edx, 43h
        mov eax, 0C4h
        call SetTextColors
        jmp short .81
.80:
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
.81:
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        shl eax, 2
        push dword [dword eax+ebp-01C8h]
        mov eax, str_D3
        push eax
        lea eax, [dword ebp-0F0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea ebx, [dword ebp-0F0h]
        mov eax, dword [byte ebp-034h]
        dec eax
        movsx edx, ax
        mov eax, 230h
        call PrintShadowText
        add dword [byte ebp-034h], byte 10h
        xor eax, eax
        mov al, byte [treecolslots+31h]
        mov word [byte ebp-08h], ax
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        shl eax, 2
        mov eax, dword [dword eax+playofftree]
        shl eax, 2
        mov eax, dword [dword eax+potreeseeds]
        add eax, 91h
        push eax
        mov eax, str_C3
        push eax
        lea eax, [dword ebp-0F0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        shl eax, 2
        imul eax, dword [dword eax+playofftree], byte 15h
        mov edx, treeteamnames
        add edx, eax
        lea eax, [dword ebp-0F0h]
        call strcat_
        lea ebx, [dword ebp-0F0h]
        mov eax, dword [byte ebp-034h]
        dec eax
        movsx edx, ax
        mov eax, 1C6h
        call PrintShadowText
        xor eax, eax
        mov al, byte [treecolslots+18h]
        shl eax, 2
        mov edx, dword [byte ebp-0Ah]
        sar edx, 10h
        shl edx, 2
        mov eax, dword [dword eax+playofftree]
        cmp eax, dword [dword edx+playofftree]
        je short .82
        xor eax, eax
        mov al, byte [treecolslots+28h]
        shl eax, 2
        mov edx, dword [byte ebp-0Ah]
        sar edx, 10h
        shl edx, 2
        mov eax, dword [dword eax+playofftree]
        cmp eax, dword [dword edx+playofftree]
        jne short .83
.82:
        mov edx, 43h
        mov eax, 0C4h
        call SetTextColors
        jmp short .84
.83:
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
.84:
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        shl eax, 2
        push dword [dword eax+ebp-01C8h]
        mov eax, str_D3
        push eax
        lea eax, [dword ebp-0F0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea ebx, [dword ebp-0F0h]
        mov eax, dword [byte ebp-034h]
        dec eax
        movsx edx, ax
        mov eax, 230h
        call PrintShadowText
        add dword [byte ebp-034h], byte 3Dh
        mov eax, str_Adn22
        push eax
        push dword [statsbgshapes]
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        push dword [statspalshape]
        call DrawShape
        add esp, byte 4
        jmp short .86
.85:
        add dword [byte ebp-034h], byte 4Dh
.86:
        xor eax, eax
        mov al, byte [treecol_Er2]
        shl eax, 2
        cmp dword [dword eax+playofftree], byte 1Ah
        jge short .87
        xor eax, eax
        mov al, byte [treecol_Er2+1]
        shl eax, 2
        cmp dword [dword eax+playofftree], byte 1Ah
        jl short .88
.87:
        jmp short .89
.88:
        xor eax, eax
        mov al, byte [treecol_Er2+2]
        shl eax, 2
        cmp dword [dword eax+playofftree], byte 1Ah
        jl short .90
.89:
        jmp short .91
.90:
        xor eax, eax
        mov al, byte [treecol_Er2+3]
        shl eax, 2
        cmp dword [dword eax+playofftree], byte 1Ah
        jl short .92
.91:
        jmp near .105
.92:
        mov word [byte ebp-014h], 0
.93:
        cmp word [byte ebp-014h], byte 4
        jl short .95
        jmp near .104
.94:
        inc word [byte ebp-014h]
        jmp short PlayoffTreeScreen.93
.95:
        cmp word [byte ebp-014h], byte 2
        jge short .96
        mov eax, dword [byte ebp-014h]
        mov word [byte ebp-018h], ax
        jmp short .97
.96:
        mov eax, 3
        sub eax, dword [byte ebp-014h]
        mov word [byte ebp-018h], ax
.97:
        cmp word [byte ebp-014h], byte 2
        jge short .98
        mov edx, dword [byte ebp-016h]
        sar edx, 10h
        add edx, edx
        xor eax, eax
        mov al, byte [dword edx+treecol_Er2]
        mov word [byte ebp-08h], ax
        jmp short .99
.98:
        mov edx, dword [byte ebp-016h]
        sar edx, 10h
        add edx, edx
        sub edx, byte 4
        mov eax, 3
        sub eax, edx
        mov edx, eax
        xor eax, eax
        mov al, byte [dword edx+treecol_Er2]
        mov word [byte ebp-08h], ax
.99:
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        shl eax, 2
        mov eax, dword [dword eax+playofftree]
        shl eax, 2
        mov eax, dword [dword eax+potreeseeds]
        add eax, 91h
        push eax
        mov eax, str_C3
        push eax
        lea eax, [dword ebp-0F0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        shl eax, 2
        imul eax, dword [dword eax+playofftree], byte 15h
        mov edx, treeteamnames
        add edx, eax
        lea eax, [dword ebp-0F0h]
        call strcat_
        lea ebx, [dword ebp-0F0h]
        mov edx, dword [byte ebp-036h]
        sar edx, 10h
        mov eax, dword [byte ebp-01Ah]
        sar eax, 10h
        mov ecx, 5
        sub ecx, eax
        mov eax, ecx
        shl eax, 2
        mov ax, word [dword eax+treecolx]
        add eax, 64h
        mov ecx, 280h
        sub ecx, eax
        mov eax, ecx
        cwde
        call PrintShadowText
        mov eax, dword [byte ebp-01Ah]
        sar eax, 10h
        mov edx, 5
        sub edx, eax
        shl edx, 2
        mov eax, 286h
        sub ax, word [dword edx+treecolx]
        mov word [byte ebp-024h], ax
        xor edx, edx
        mov dl, byte [treecolslots+30h]
        shl edx, 2
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        shl eax, 2
        mov edx, dword [dword edx+playofftree]
        cmp edx, dword [dword eax+playofftree]
        je short .100
        xor eax, eax
        mov al, byte [treecolslots+31h]
        shl eax, 2
        mov edx, dword [byte ebp-0Ah]
        sar edx, 10h
        shl edx, 2
        mov eax, dword [dword eax+playofftree]
        cmp eax, dword [dword edx+playofftree]
        jne short .101
.100:
        mov edx, 43h
        mov eax, 0C4h
        call SetTextColors
        jmp short .102
.101:
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
.102:
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        shl eax, 2
        push dword [dword eax+ebp-01C8h]
        mov eax, str_D3
        push eax
        lea eax, [dword ebp-0F0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea ebx, [dword ebp-0F0h]
        mov edx, dword [byte ebp-036h]
        sar edx, 10h
        mov eax, dword [byte ebp-026h]
        sar eax, 10h
        call PrintShadowText
        cmp word [byte ebp-014h], byte 1
        jne short .103
        add dword [byte ebp-034h], byte 10h
.103:
        jmp near PlayoffTreeScreen.94
.104:
        add dword [byte ebp-034h], byte 3Dh
        mov eax, str_Adn12
        push eax
        push dword [statsbgshapes]
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        push dword [statspalshape]
        call DrawShape
        add esp, byte 4
        jmp short .106
.105:
        add dword [byte ebp-034h], byte 4Dh
.106:
        mov word [byte ebp-014h], 0
.107:
        cmp word [byte ebp-014h], byte 8
        jl short .109
        jmp near .120
.108:
        inc word [byte ebp-014h]
        jmp short PlayoffTreeScreen.107
.109:
        cmp word [byte ebp-014h], byte 4
        jge short .110
        mov eax, dword [byte ebp-014h]
        mov word [byte ebp-018h], ax
        mov edx, dword [byte ebp-016h]
        sar edx, 10h
        add edx, edx
        xor eax, eax
        mov al, byte [dword edx+treecol_Er1]
        mov word [byte ebp-08h], ax
        jmp short .111
.110:
        mov eax, 7
        sub eax, dword [byte ebp-014h]
        mov word [byte ebp-018h], ax
        mov edx, dword [byte ebp-016h]
        sar edx, 10h
        add edx, edx
        sub edx, byte 8
        mov eax, 7
        sub eax, edx
        mov edx, eax
        xor eax, eax
        mov al, byte [dword edx+treecol_Er1]
        mov word [byte ebp-08h], ax
.111:
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        shl eax, 2
        mov eax, dword [dword eax+playofftree]
        shl eax, 2
        mov eax, dword [dword eax+potreeseeds]
        add eax, 91h
        push eax
        mov eax, str_C3
        push eax
        lea eax, [dword ebp-0F0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        shl eax, 2
        imul edx, dword [dword eax+playofftree], byte 15h
        mov eax, treeteamnames
        add edx, eax
        lea eax, [dword ebp-0F0h]
        call strcat_
        lea ebx, [dword ebp-0F0h]
        mov edx, dword [byte ebp-036h]
        sar edx, 10h
        mov eax, dword [byte ebp-01Ah]
        sar eax, 10h
        shl eax, 2
        mov eax, dword [dword eax+treecolx-2]
        sar eax, 10h
        call PrintShadowText
        mov eax, dword [byte ebp-01Ah]
        sar eax, 10h
        shl eax, 2
        mov ax, word [dword eax+treecolx]
        add eax, 6Ah
        mov word [byte ebp-024h], ax
        xor edx, edx
        mov dl, byte [treecol_Er2]
        shl edx, 2
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        shl eax, 2
        mov edx, dword [dword edx+playofftree]
        cmp edx, dword [dword eax+playofftree]
        je short .112
        xor eax, eax
        mov al, byte [treecol_Er2+1]
        shl eax, 2
        mov edx, dword [byte ebp-0Ah]
        sar edx, 10h
        shl edx, 2
        mov eax, dword [dword eax+playofftree]
        cmp eax, dword [dword edx+playofftree]
        jne short .113
.112:
        jmp short .114
.113:
        xor eax, eax
        mov al, byte [treecol_Er2+2]
        shl eax, 2
        mov edx, dword [byte ebp-0Ah]
        sar edx, 10h
        shl edx, 2
        mov eax, dword [dword eax+playofftree]
        cmp eax, dword [dword edx+playofftree]
        jne short .115
.114:
        jmp short .116
.115:
        xor eax, eax
        mov al, byte [treecol_Er2+3]
        shl eax, 2
        mov edx, dword [byte ebp-0Ah]
        sar edx, 10h
        shl edx, 2
        mov eax, dword [dword eax+playofftree]
        cmp eax, dword [dword edx+playofftree]
        jne short .117
.116:
        mov edx, 43h
        mov eax, 0C4h
        call SetTextColors
        jmp short .118
.117:
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
.118:
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        shl eax, 2
        push dword [dword eax+ebp-01C8h]
        mov eax, str_D3
        push eax
        lea eax, [dword ebp-0F0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea ebx, [dword ebp-0F0h]
        mov edx, dword [byte ebp-036h]
        sar edx, 10h
        mov eax, dword [byte ebp-026h]
        sar eax, 10h
        call PrintShadowText
        cmp word [byte ebp-014h], byte 3
        jne short .119
        add dword [byte ebp-034h], byte 10h
.119:
        jmp near PlayoffTreeScreen.108
.120:
        call TextGridOff
        push dword [statsbgshapes]
        call FreeMemBlock
        add esp, byte 4
        lea eax, [dword ebp-09Ch]
        push eax
        call TextRestoreState
        add esp, byte 4
.x:
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; PlayoffTreeHitTest                                              29681  95 PC
; Stub, always returns 0 (ret 4); called by RunTeamPickMenu
;-----------------------------------------------------------------------------
; C: src/front/playoff/PlayoffTreeHitTest.c
%ifdef CBUILD
%include "c/front/playoff/PlayoffTreeHitTest.inc"
%else
PlayoffTreeHitTest:
        push dword 28h
        call __CHK
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 18h
        mov dword [byte ebp-018h], eax
        mov dword [byte ebp-014h], edx
        mov dword [byte ebp-010h], ebx
        mov dword [byte ebp-0Ch], ecx
        mov dword [byte ebp-04h], 0
        mov eax, dword [byte ebp-04h]
        mov dword [byte ebp-08h], eax
        mov eax, dword [byte ebp-08h]
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        ret 4
;-----------------------------------------------------------------------------
; ShowPlayoffTree                              296BA  95 PC, medium confidence
; Statsfromleague ? LoadLeagueTree : LoadPlayoffModeTree (both end in
; PlayoffTreeScreen); called by the *StandingsScreen callbacks
;-----------------------------------------------------------------------------
ShowPlayoffTree:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 0Ch
        mov dword [byte ebp-0Ch], eax
        mov dword [byte ebp-08h], edx
        cmp dword [statsfromleague], byte 0
        jne short .1
        mov edx, dword [byte ebp-08h]
        mov eax, dword [byte ebp-0Ch]
        call LoadPlayoffModeTree
        jmp short .2
.1:
        mov edx, dword [byte ebp-08h]
        mov eax, dword [byte ebp-0Ch]
        call LoadLeagueTree
.2:
        mov dword [byte ebp-04h], 0
        mov eax, dword [byte ebp-04h]
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
