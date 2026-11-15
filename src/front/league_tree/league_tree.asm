; Loading a playoff tree from the playoff files or from the league schedule, and fitting a name into a box.
bits 32
%include "hockey.inc"
section s_2970A progbits alloc exec nowrite align=1
extern __CHK, boxfillcolor, boxlitecolor, boxshadecolor, FileClose, FileOpenRead, fputchar, FreeMemBlock
extern leaguedbnames, lgstate, MakePath, playofftree, playofftree_p1, PlayoffTreeScreen, pochampion, ReadSchedGame
extern ReadTeamNames, statsfromleague, statsleague, str_extDB, str_LSSCHED, str_space, str_Space2, strcat_
extern strcmp_, strcpy_, strlen_, sub_8E8A0, FillRect, sub_B4FAC, PlotPixel, teamcitynames
extern treeteamnames
global LoadPlayoffModeTree, TreeSeriesWinner, OpenStatsSchedule, LoadLeagueTree, FitPlayerName, DrawBevelBox
;-----------------------------------------------------------------------------
; LoadPlayoffModeTree                          2970A  95 PC, medium confidence
; Statsfromleague == 0 path of ShowPlayoffTree: reads team names into
; treeteamnames (ReadTeamNames on leaguedbnames[4]) or LSSCHED.DB, fills
; playofftree from the playoff games (ReadSchedGame 444h.., final 4A6h ->
; pochampion), then PlayoffTreeScreen
;-----------------------------------------------------------------------------
; C: src/front/league_tree/LoadPlayoffModeTree.c
%ifdef CBUILD
%include "c/front/league_tree/LoadPlayoffModeTree.inc"
%else
LoadPlayoffModeTree:
        push dword 0B0h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 98h
        mov dword [byte ebp-030h], eax
        mov dword [byte ebp-028h], edx
        mov dword [byte ebp-08h], 0FFFFFFFFh
        mov ecx, str_extDB
        mov ebx, dword [leaguedbnames+10h]
        mov edx, statsleague
        lea eax, [byte ebp-058h]
        call MakePath
        xor ebx, ebx
        mov edx, treeteamnames
        lea eax, [byte ebp-058h]
        call ReadTeamNames
        mov dword [byte ebp-020h], eax
        cmp word [byte ebp-020h], byte 0
        jne short .1
        mov ecx, str_extDB
        mov ebx, str_LSSCHED
        xor edx, edx
        lea eax, [byte ebp-058h]
        call MakePath
        lea edx, [byte ebp-08h]
        lea eax, [byte ebp-058h]
        call FileOpenRead
        mov dword [byte ebp-020h], eax
.1:
        mov dword [byte ebp-014h], 0
        mov dword [byte ebp-010h], 0
.2:
        cmp word [byte ebp-010h], byte 69h
        jge short .3
        cmp word [byte ebp-020h], byte 0
        je short .5
.3:
        jmp short .6
.4:
        add dword [byte ebp-010h], byte 7
        jmp short LoadPlayoffModeTree.2
.5:
        mov ebx, dword [byte ebp-012h]
        sar ebx, 10h
        add ebx, 444h
        lea edx, [byte ebp-038h]
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        call ReadSchedGame
        mov dword [byte ebp-020h], eax
        xor edx, edx
        mov dl, byte [byte ebp-036h]
        mov eax, dword [byte ebp-016h]
        sar eax, 10h
        shl eax, 2
        mov dword [dword eax+playofftree], edx
        inc word [byte ebp-014h]
        xor edx, edx
        mov dl, byte [byte ebp-035h]
        mov eax, dword [byte ebp-016h]
        sar eax, 10h
        shl eax, 2
        mov dword [dword eax+playofftree], edx
        inc word [byte ebp-014h]
        jmp short LoadPlayoffModeTree.4
.6:
        mov dword [byte ebp-018h], 0
        mov dword [byte ebp-0Ch], 0
        mov word [byte ebp-010h], 0
.7:
        cmp word [byte ebp-010h], byte 7
        jge short .8
        cmp word [byte ebp-020h], byte 0
        je short .10
.8:
        jmp near .25
.9:
        inc word [byte ebp-010h]
        jmp short LoadPlayoffModeTree.7
.10:
        mov ebx, dword [byte ebp-012h]
        sar ebx, 10h
        add ebx, 4A6h
        lea edx, [byte ebp-038h]
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        call ReadSchedGame
        mov dword [byte ebp-020h], eax
        cmp word [byte ebp-010h], byte 0
        jne short .11
        xor eax, eax
        mov al, byte [byte ebp-036h]
        mov dword [byte ebp-04h], eax
        xor eax, eax
        mov al, byte [byte ebp-035h]
        mov dword [byte ebp-01Ch], eax
.11:
        mov al, byte [byte ebp-034h]
        cmp al, byte [byte ebp-033h]
        jbe short .12
        xor eax, eax
        mov al, byte [byte ebp-036h]
        cmp ax, word [byte ebp-04h]
        je short .14
.12:
        mov al, byte [byte ebp-033h]
        cmp al, byte [byte ebp-034h]
        jbe short .13
        xor eax, eax
        mov al, byte [byte ebp-035h]
        cmp ax, word [byte ebp-04h]
        je short .14
.13:
        jmp short .15
.14:
        inc dword [byte ebp-018h]
        jmp short .16
.15:
        inc dword [byte ebp-0Ch]
.16:
        cmp word [byte ebp-018h], byte 4
        jne short .17
        xor eax, eax
        mov al, byte [byte ebp-036h]
        cmp ax, word [byte ebp-04h]
        je short .19
.17:
        cmp word [byte ebp-0Ch], byte 4
        jne short .18
        xor eax, eax
        mov al, byte [byte ebp-036h]
        cmp ax, word [byte ebp-01Ch]
        je short .19
.18:
        jmp short .20
.19:
        xor eax, eax
        mov al, byte [byte ebp-036h]
        mov dword [pochampion], eax
        mov word [byte ebp-010h], 7
.20:
        cmp word [byte ebp-0Ch], byte 4
        jne short .21
        xor eax, eax
        mov al, byte [byte ebp-035h]
        cmp ax, word [byte ebp-01Ch]
        je short .23
.21:
        cmp word [byte ebp-018h], byte 4
        jne short .22
        xor eax, eax
        mov al, byte [byte ebp-035h]
        cmp ax, word [byte ebp-04h]
        je short .23
.22:
        jmp short .24
.23:
        xor eax, eax
        mov al, byte [byte ebp-035h]
        mov dword [pochampion], eax
        mov word [byte ebp-010h], 7
.24:
        jmp near LoadPlayoffModeTree.9
.25:
        lea eax, [byte ebp-08h]
        call FileClose
        cmp word [byte ebp-020h], byte 0
        jne short .26
        call PlayoffTreeScreen
.26:
        mov dword [byte ebp-02Ch], 0
        mov eax, dword [byte ebp-02Ch]
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; TreeSeriesWinner                             2991C  95 PC, medium confidence
; Same code as SeriesWinner (season_playoffs) with an extra is-series flag:
; walks 6-byte game entries of a series; returns the team that reached
; len/2+1 wins, -1 if a game is unplayed
;-----------------------------------------------------------------------------
TreeSeriesWinner:
        push dword 38h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 24h
        mov dword [byte ebp-014h], eax
        mov dword [byte ebp-01Ch], edx
        mov dword [byte ebp-018h], ebx
        xor eax, eax
        mov edx, dword [byte ebp-014h]
        mov al, byte [byte edx+02h]
        mov dword [byte ebp-0Ch], eax
        xor eax, eax
        mov edx, dword [byte ebp-014h]
        mov al, byte [byte edx+03h]
        mov dword [byte ebp-010h], eax
        cmp dword [byte ebp-018h], byte 0
        je near .12
        mov eax, dword [byte ebp-01Ch]
        shr eax, 1
        inc eax
        mov dword [byte ebp-01Ch], eax
        mov dword [byte ebp-020h], 0
        mov eax, dword [byte ebp-020h]
        mov dword [byte ebp-024h], eax
.1:
        mov eax, dword [byte ebp-024h]
        cmp eax, dword [byte ebp-01Ch]
        jae short .2
        mov eax, dword [byte ebp-020h]
        cmp eax, dword [byte ebp-01Ch]
        jb short .4
.2:
        jmp short .11
.3:
        add dword [byte ebp-014h], byte 6
        jmp short TreeSeriesWinner.1
.4:
        mov eax, dword [byte ebp-014h]
        cmp byte [byte eax+04h], 0FFh
        jne short .5
        mov dword [byte ebp-04h], 0FFFFFFFFh
        jmp near .26
.5:
        mov eax, dword [byte ebp-014h]
        mov al, byte [byte eax+02h]
        and eax, 0FFh
        cmp eax, dword [byte ebp-0Ch]
        jne short .8
        mov eax, dword [byte ebp-014h]
        mov dl, byte [byte eax+04h]
        mov eax, dword [byte ebp-014h]
        cmp dl, byte [byte eax+05h]
        jbe short .6
        inc dword [byte ebp-024h]
        jmp short .7
.6:
        inc dword [byte ebp-020h]
.7:
        jmp short .10
.8:
        mov eax, dword [byte ebp-014h]
        mov dl, byte [byte eax+04h]
        mov eax, dword [byte ebp-014h]
        cmp dl, byte [byte eax+05h]
        jbe short .9
        inc dword [byte ebp-020h]
        jmp short .10
.9:
        inc dword [byte ebp-024h]
.10:
        jmp short TreeSeriesWinner.3
.11:
        jmp near .24
.12:
        mov eax, dword [byte ebp-014h]
        cmp byte [byte eax+04h], 0FFh
        jne short .13
        mov dword [byte ebp-04h], 0FFFFFFFFh
        jmp near .26
.13:
        mov dword [byte ebp-08h], 0
        mov dword [byte ebp-020h], 0
        mov eax, dword [byte ebp-020h]
        mov dword [byte ebp-024h], eax
.14:
        mov eax, dword [byte ebp-014h]
        cmp byte [eax], 0FFh
        je short .15
        cmp dword [byte ebp-08h], byte 7
        jl short .17
.15:
        jmp short .24
.16:
        add dword [byte ebp-014h], byte 6
        inc dword [byte ebp-08h]
        jmp short TreeSeriesWinner.14
.17:
        mov eax, dword [byte ebp-014h]
        cmp byte [byte eax+04h], 0FFh
        jne short .18
        mov dword [byte ebp-04h], 0FFFFFFFFh
        jmp short .26
.18:
        mov eax, dword [byte ebp-014h]
        mov al, byte [byte eax+02h]
        and eax, 0FFh
        cmp eax, dword [byte ebp-0Ch]
        jne short .21
        mov eax, dword [byte ebp-014h]
        mov dl, byte [byte eax+04h]
        mov eax, dword [byte ebp-014h]
        cmp dl, byte [byte eax+05h]
        jbe short .19
        inc dword [byte ebp-024h]
        jmp short .20
.19:
        inc dword [byte ebp-020h]
.20:
        jmp short .23
.21:
        mov eax, dword [byte ebp-014h]
        mov dl, byte [byte eax+04h]
        mov eax, dword [byte ebp-014h]
        cmp dl, byte [byte eax+05h]
        jbe short .22
        inc dword [byte ebp-020h]
        jmp short .23
.22:
        inc dword [byte ebp-024h]
.23:
        jmp short TreeSeriesWinner.16
.24:
        mov eax, dword [byte ebp-024h]
        cmp eax, dword [byte ebp-020h]
        jle short .25
        mov eax, dword [byte ebp-0Ch]
        mov dword [byte ebp-04h], eax
        jmp short .26
.25:
        mov eax, dword [byte ebp-010h]
        mov dword [byte ebp-04h], eax
.26:
        mov eax, dword [byte ebp-04h]
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
;-----------------------------------------------------------------------------
; OpenStatsSchedule                            29A97  95 PC, medium confidence
; Opens the league schedule DB (leaguedbnames[6]) or LSSCHED.DB as a
; shape-style file (sub_8E8A0) into *out
;-----------------------------------------------------------------------------
; C: src/front/league_tree/OpenStatsSchedule.c
%ifdef CBUILD
%include "c/front/league_tree/OpenStatsSchedule.inc"
%else
OpenStatsSchedule:
        push dword 48h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 24h
        mov dword [byte ebp-04h], eax
        cmp dword [statsfromleague], byte 0
        je short .1
        mov ecx, str_extDB
        mov ebx, dword [leaguedbnames+18h]
        mov edx, statsleague
        lea eax, [byte ebp-024h]
        call MakePath
        jmp short .2
.1:
        mov ecx, str_extDB
        mov ebx, str_LSSCHED
        xor edx, edx
        lea eax, [byte ebp-024h]
        call MakePath
.2:
        push byte 20h
        lea eax, [byte ebp-024h]
        push eax
        call sub_8E8A0
        mov edx, eax
        add esp, byte 8
        mov eax, dword [byte ebp-04h]
        mov dword [eax], edx
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
; LoadLeagueTree                               29B07  95 PC, medium confidence
; Statsfromleague path: copies teamcitynames into treeteamnames, reads the
; playoff pairs from the schedule into playofftree, resolves winners with
; SeriesWinner, then PlayoffTreeScreen
;-----------------------------------------------------------------------------
; C: src/front/league_tree/LoadLeagueTree.c
%ifdef CBUILD
%include "c/front/league_tree/LoadLeagueTree.inc"
%else
LoadLeagueTree:
        push dword 5Ch
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 40h
        mov dword [byte ebp-030h], eax
        mov dword [byte ebp-028h], edx
        mov edx, lgstate+4
        mov eax, statsleague
        call strcmp_
        mov dword [byte ebp-018h], eax
        mov dword [byte ebp-04h], 0
.1:
        cmp dword [byte ebp-04h], byte 1Ah
        jl short .3
        jmp short .4
.2:
        inc dword [byte ebp-04h]
        jmp short LoadLeagueTree.1
.3:
        mov eax, dword [byte ebp-04h]
        shl eax, 2
        mov edx, dword [dword eax+teamcitynames]
        imul eax, dword [byte ebp-04h], byte 15h
        mov ebx, treeteamnames
        add eax, ebx
        call strcpy_
        jmp short LoadLeagueTree.2
.4:
        mov edx, str_Space2
        mov eax, treeteamnames+222h
        call strcpy_
        lea eax, [byte ebp-01Ch]
        call OpenStatsSchedule
        add dword [byte ebp-01Ch], byte 2
        mov eax, dword [byte ebp-01Ch]
        add eax, 1998h
        mov dword [byte ebp-020h], eax
        mov dword [byte ebp-04h], 0
.5:
        cmp dword [byte ebp-04h], byte 1Eh
        jl short .7
        jmp near .10
.6:
        add dword [byte ebp-04h], byte 2
        add dword [byte ebp-020h], byte 2Ah
        jmp short LoadLeagueTree.5
.7:
        mov eax, dword [byte ebp-020h]
        xor edx, edx
        mov dl, byte [byte eax+02h]
        mov eax, dword [byte ebp-04h]
        shl eax, 2
        mov dword [dword eax+playofftree], edx
        mov eax, dword [byte ebp-020h]
        xor edx, edx
        mov dl, byte [byte eax+03h]
        mov eax, dword [byte ebp-04h]
        shl eax, 2
        mov dword [dword eax+playofftree_p1], edx
        mov eax, dword [byte ebp-04h]
        shl eax, 2
        cmp dword [dword eax+playofftree], 0FFh
        jne short .8
        mov eax, dword [byte ebp-04h]
        shl eax, 2
        mov dword [dword eax+playofftree], 1Ah
.8:
        mov eax, dword [byte ebp-04h]
        shl eax, 2
        cmp dword [dword eax+playofftree_p1], 0FFh
        jne short .9
        mov eax, dword [byte ebp-04h]
        shl eax, 2
        mov dword [dword eax+playofftree_p1], 1Ah
.9:
        jmp short LoadLeagueTree.6
.10:
        mov eax, dword [byte ebp-01Ch]
        add eax, 1BE4h
        mov dword [byte ebp-020h], eax
        mov ebx, dword [byte ebp-018h]
        mov eax, dword [byte ebp-01Ch]
        mov edx, dword [dword eax+088h]
        mov eax, dword [byte ebp-020h]
        call TreeSeriesWinner
        mov dword [pochampion], eax
        cmp dword [pochampion], byte 0FFFFFFFFh
        jne short .11
        mov dword [pochampion], 1Ah
.11:
        mov eax, dword [byte ebp-01Ch]
        sub eax, byte 2
        push eax
        call FreeMemBlock
        add esp, byte 4
        call PlayoffTreeScreen
        mov dword [byte ebp-02Ch], 0
        mov eax, dword [byte ebp-02Ch]
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; FitPlayerName                                                   29C75  95 PC
; Dest = "First Last", falls back to "F. Last", then trims chars until the
; text width fits
;-----------------------------------------------------------------------------
; C: src/front/league_tree/FitPlayerName.c
%ifdef CBUILD
%include "c/front/league_tree/FitPlayerName.inc"
%else
FitPlayerName:
        push dword 18h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov esi, eax
        mov dword [esp], edx
        mov ebp, ebx
        mov edi, ecx
        test edx, edx
        je short .1
        call strcpy_
        mov edx, str_space
        mov eax, esi
        call strcat_
        mov edx, ebx
        mov eax, esi
        call strcat_
        push esi
        call fputchar
        add esp, byte 4
        cmp eax, edi
        jle short .2
        mov eax, dword [esp]
        mov al, byte [eax]
        mov byte [esi], al
        mov byte [byte esi+01h], 2Eh
        mov byte [byte esi+02h], 20h
        mov byte [byte esi+03h], 0
        mov edx, ebp
        mov eax, esi
        call strcat_
        jmp short .2
.1:
        mov edx, ebx
        call strcpy_
.2:
        push esi
        call fputchar
        add esp, byte 4
        cmp eax, edi
        jle short .x
        mov eax, esi
        call strlen_
        mov byte [byte esi+eax-01h], 0
        jmp short FitPlayerName.2
.x:
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawBevelBox                                 29D00  95 PC, medium confidence
; Fills a rect with boxfillcolor and draws lit / shaded edges (boxlitecolor /
; boxshadecolor), double edge when the stack flag is set
;-----------------------------------------------------------------------------
; C: src/front/league_tree/FitPlayerName.c (DrawBevelBox)
%ifdef CBUILD
%include "c/front/league_tree/FitPlayerName.DrawBevelBox.inc"
%else
DrawBevelBox:
        push dword 38h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 14h
        mov edi, eax
        mov esi, edx
        mov ebp, ebx
        mov dword [byte esp+010h], ecx
        mov edx, dword [boxfillcolor]
        push edx
        mov eax, ecx
        sub eax, esi
        inc eax
        push eax
        mov eax, ebx
        sub eax, edi
        inc eax
        push eax
        push esi
        push edi
        call FillRect
        add esp, byte 14h
        mov ebx, dword [boxlitecolor]
        push ebx
        push esi
        push ebp
        push esi
        push edi
        call sub_B4FAC
        add esp, byte 14h
        mov ecx, dword [boxlitecolor]
        push ecx
        mov eax, dword [byte esp+014h]
        push eax
        push edi
        push esi
        push edi
        call sub_B4FAC
        add esp, byte 14h
        mov edx, dword [boxshadecolor]
        push edx
        mov ebx, dword [byte esp+014h]
        push ebx
        push ebp
        push esi
        push ebp
        call sub_B4FAC
        add esp, byte 14h
        mov ecx, dword [boxshadecolor]
        push ecx
        mov eax, dword [byte esp+014h]
        push eax
        push ebp
        push eax
        push edi
        call sub_B4FAC
        add esp, byte 14h
        cmp dword [byte esp+024h], byte 0
        je near .x
        mov ecx, dword [boxlitecolor]
        push ecx
        mov eax, esi
        add eax, byte 2
        mov dword [byte esp+04h], eax
        push eax
        mov eax, edi
        add eax, byte 2
        mov dword [byte esp+0Ch], eax
        push eax
        call PlotPixel
        add esp, byte 0Ch
        mov ebx, dword [boxlitecolor]
        push ebx
        add esi, byte 3
        push esi
        add edi, byte 3
        push edi
        call PlotPixel
        add esp, byte 0Ch
        mov ecx, dword [boxshadecolor]
        push ecx
        mov eax, dword [byte esp+04h]
        push eax
        push edi
        call PlotPixel
        add esp, byte 0Ch
        mov edx, dword [boxshadecolor]
        push edx
        push esi
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call PlotPixel
        add esp, byte 0Ch
        mov ecx, dword [boxshadecolor]
        push ecx
        mov eax, dword [byte esp+014h]
        sub eax, byte 2
        mov dword [byte esp+0Ch], eax
        push eax
        mov edx, dword [byte esp+0Ch]
        push edx
        call PlotPixel
        add esp, byte 0Ch
        mov ebx, dword [boxshadecolor]
        push ebx
        mov eax, dword [byte esp+014h]
        sub eax, byte 3
        mov dword [byte esp+010h], eax
        push eax
        push edi
        call PlotPixel
        add esp, byte 0Ch
        mov eax, dword [boxlitecolor]
        push eax
        mov edx, dword [byte esp+0Ch]
        push edx
        push edi
        call PlotPixel
        add esp, byte 0Ch
        mov ebx, dword [boxlitecolor]
        push ebx
        mov ecx, dword [byte esp+010h]
        push ecx
        mov edi, dword [byte esp+0Ch]
        push edi
        call PlotPixel
        add esp, byte 0Ch
        mov eax, dword [boxlitecolor]
        push eax
        mov edx, dword [byte esp+04h]
        push edx
        lea edi, [byte ebp-03h]
        push edi
        call PlotPixel
        add esp, byte 0Ch
        mov ebx, dword [boxlitecolor]
        push ebx
        push esi
        sub ebp, byte 2
        push ebp
        call PlotPixel
        add esp, byte 0Ch
        mov ecx, dword [boxshadecolor]
        push ecx
        mov eax, dword [byte esp+04h]
        push eax
        push ebp
        call PlotPixel
        add esp, byte 0Ch
        mov edx, dword [boxshadecolor]
        push edx
        push esi
        push edi
        call PlotPixel
        add esp, byte 0Ch
        mov ebx, dword [boxshadecolor]
        push ebx
        mov ecx, dword [byte esp+0Ch]
        push ecx
        push edi
        call PlotPixel
        add esp, byte 0Ch
        mov esi, dword [boxshadecolor]
        push esi
        mov eax, dword [byte esp+010h]
        push eax
        push ebp
        call PlotPixel
        add esp, byte 0Ch
        mov edx, dword [boxlitecolor]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        push ebp
        call PlotPixel
        add esp, byte 0Ch
        mov ecx, dword [boxlitecolor]
        push ecx
        mov esi, dword [byte esp+010h]
        push esi
        push edi
        call PlotPixel
        add esp, byte 0Ch
.x:
        add esp, byte 14h
        pop ebp
        pop edi
        pop esi
        ret 4
%endif ; C
        db 08Dh,040h,00h
