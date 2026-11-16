; Roster moves: free agents, release, temporary databases, player search (95G create95).
bits 32
%include "hockey.inc"
section s_70E8D progbits alloc exec nowrite align=1
extern __CHK, attdb, attdb_size, btn_LeagueExists, byte_EAC86, byte_EAF99, byte_EAFB5, careerdb
extern careerdb_size, carteamsdb, carteamsdb_size, CountSelected, dbdirty, divisionteams, DrawEditRosters, FaListScrolls
extern dword_EA994, dword_EAF7C, EditTeamLines, facount, falist, falistsel, falisttop, FixJerseyNumber
extern FreeLeagueDbsMem, GetFileSize, InputDialog, j_unlink_, keydb, keydb_size, KeyDbPtr, leaguedbnames
extern ListDialog, LoadRosterList, MakePath, menu_r1_editlines, menu_r1_freeagents, menu_r1_tofa, menu_r1_toroster2, menu_r2_editlines
extern menu_r2_freeagents, menu_r2_tofa, menu_r2_toroster1, MessageBox, MoveToOtherRoster, msglines, roster1divmenus, roster2divmenus
extern rosterisfa, rosterlist, rostersel, rosterslot, rosterteam, rosterteamrec, seasondb, seasondb_size
extern SelectRosterTeam, ShowFreeAgents, SplitPlayerName, str_ChooseWhichTeamTo, str_DoesNotExist, str_EnterNameOfPlayer, str_ForAllSelectedPlayers, str_FreeAgentList
extern str_Goalies, str_InTheFreeAgent, str_IsAlreadyDisplayedOn, str_Move, str_MustBeTheSame, str_NotEnoughSpaceFA, str_Players, str_PlayersAndGoalies
extern str_Roster1, str_Roster2, str_space, str_TheNumberOfSelected, str_TMP, str_ToFreeAgentList, strcat_, strcmp_
extern strcpy_, strlwr_, OpenArtArchiveErr, teamcitynames, teamdivflags, TeamRecPtr, teamsdb, teamsdb_size
extern tmpdbpath, unk_EAC84
global MoveToFreeAgents, RemovePlayerFromTeam, LoadTempDatabases, DeleteTempDatabases, SwapSelectedPlayers, SelectMatchingPlayers, SetRosterTeamMenus, FindPlayer
;-----------------------------------------------------------------------------
; MoveToFreeAgents                                                70E8D  95 PC
; 'Move to Free Agent List' menu item: 'Move <name> to free agent list?',
; 'There is not enough space in the free agent list for all selected
; players', RemovePlayerFromTeam, reload and redraw
;-----------------------------------------------------------------------------
; C: src/front/roster_edit/MoveToFreeAgents.c
%ifdef CBUILD
%include "c/front/roster_edit/MoveToFreeAgents.inc"
%else
MoveToFreeAgents:
        push dword 64h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 34h
        push edx
        push ebx
        xor edx, edx
        mov dword [byte esp+030h], edx
        mov dword [byte esp+028h], edx
        mov dword [byte esp+034h], edx
        cmp dword [eax], byte 3
        setne al
        and eax, 0FFh
        mov esi, eax
        sete al
        and eax, 0FFh
        mov dword [byte esp+02Ch], eax
        xor ebp, ebp
.1:
        mov eax, esi
        shl eax, 3
        sub eax, esi
        cmp byte [dword ebp+eax*4+rostersel], 0
        je near .2
        inc dword [byte esp+028h]
        cmp dword [facount], byte 1Eh
        jge near .2
        mov eax, esi
        shl eax, 2
        sub eax, esi
        shl eax, 2
        mov edx, eax
        shl edx, 6
        sub edx, eax
        mov eax, ebp
        shl eax, 3
        sub eax, ebp
        shl eax, 2
        sub eax, ebp
        inc dword [byte esp+034h]
        mov eax, dword [dword edx+eax+dword_EA994]
        mov dword [byte esp+038h], eax
        call KeyDbPtr
        mov edi, eax
        mov dword [msglines], str_Move
        lea edx, [byte eax+03h]
        lea eax, [byte esp+08h]
        call strcpy_
        mov edx, str_space
        lea eax, [byte esp+08h]
        call strcat_
        lea edx, [byte edi+013h]
        lea eax, [byte esp+08h]
        call strcat_
        lea eax, [byte esp+08h]
        mov dword [msglines+4], eax
        mov dword [msglines+8], str_ToFreeAgentList
        push byte 0FFFFFFFFh
        mov edx, dword [byte esp+04h]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        push byte 2
        push btn_LeagueExists
        mov ecx, 3
        mov ebx, msglines
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        cmp eax, byte 1
        jne short .2
        mov dword [byte esp+030h], eax
        cmp byte [dword esi+rosterteam], 1Ah
        jae short .2
        mov byte [edi], 0FFh
        xor eax, eax
        mov al, byte [dword esi+rosterteam]
        mov edx, dword [byte esp+038h]
        call RemovePlayerFromTeam
.2:
        inc ebp
        cmp ebp, byte 1Ch
        jl near MoveToFreeAgents.1
        mov eax, dword [byte esp+028h]
        cmp eax, dword [byte esp+034h]
        je short .3
        mov dword [msglines], str_NotEnoughSpaceFA
        mov dword [msglines+4], str_InTheFreeAgent
        mov dword [msglines+8], str_ForAllSelectedPlayers
        push byte 0FFFFFFFFh
        mov ebx, dword [byte esp+04h]
        push ebx
        mov ecx, dword [byte esp+0Ch]
        push ecx
        push byte 0
        push byte 0
        mov ecx, 3
        mov ebx, msglines
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
.3:
        cmp dword [byte esp+030h], byte 0
        je short .x
        mov dword [dbdirty], 1
        mov eax, esi
        call LoadRosterList
        mov eax, dword [byte esp+02Ch]
        cmp byte [dword eax+rosterisfa], 1
        jne short .4
        call LoadRosterList
.4:
        call DrawEditRosters
.x:
        add esp, byte 3Ch
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; RemovePlayerFromTeam                         71043  95 PC, medium confidence
; Finds the player (name keys +24h/+28h/+2Ch) in the team's 1Ch roster slots
; (+4Ch), clears it (-1), facount++, and replaces it in the line table
; (+0BCh, 30h bytes) with 64h
;-----------------------------------------------------------------------------
; C: src/front/roster_edit/RemovePlayerFromTeam.c
%ifdef CBUILD
%include "c/front/roster_edit/RemovePlayerFromTeam.inc"
%else
RemovePlayerFromTeam:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        and eax, 0FFh
        call TeamRecPtr
        mov edi, eax
        mov eax, edx
        call KeyDbPtr
        mov ebx, eax
        mov dh, 0FFh
        xor dl, dl
        jmp short .3
.1:
        xor ecx, ecx
        mov cl, dl
        shl ecx, 2
        add ecx, edi
        mov eax, dword [byte ecx+04Ch]
        call KeyDbPtr
        mov esi, dword [byte ebx+024h]
        cmp esi, dword [byte eax+024h]
        jne short .2
        mov esi, dword [byte ebx+028h]
        cmp esi, dword [byte eax+028h]
        jne short .2
        mov esi, dword [byte ebx+02Ch]
        cmp esi, dword [byte eax+02Ch]
        jne short .2
        inc dword [facount]
        mov dword [byte ecx+04Ch], 0FFFFFFFFh
        mov dh, dl
.2:
        inc dl
.3:
        cmp dl, 1Ch
        jae short .4
        cmp dh, 0FFh
        je short RemovePlayerFromTeam.1
.4:
        cmp dh, 0FFh
        je short .x
        lea esi, [dword edi+0BCh]
        xor dl, dl
        jmp short .7
.5:
        xor eax, eax
        mov al, dl
        add eax, esi
        cmp dh, byte [eax]
        jne short .6
        mov byte [eax], 64h
.6:
        inc dl
.7:
        cmp dl, 30h
        jb short RemovePlayerFromTeam.5
.x:
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; LoadTempDatabases                            710D8  95 PC, medium confidence
; Loads the league databases' .TMP copies into buffers
; (carteamsdb/D07CB/D07CF with sizes D07DB/D07E3/D07E7)
;-----------------------------------------------------------------------------
; C: src/front/roster_edit/LoadTempDatabases.c
%ifdef CBUILD
%include "c/front/roster_edit/LoadTempDatabases.inc"
%else
LoadTempDatabases:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        call FreeLeagueDbsMem
        mov ebx, dword [leaguedbnames+14h]
        mov ecx, str_TMP
        xor edx, edx
        mov eax, tmpdbpath
        call MakePath
        push byte 20h
        push tmpdbpath
        call OpenArtArchiveErr
        add esp, byte 8
        mov dword [seasondb], eax
        push tmpdbpath
        call GetFileSize
        add esp, byte 4
        mov dword [seasondb_size], eax
        mov ebx, dword [leaguedbnames+4]
        mov ecx, str_TMP
        xor edx, edx
        mov eax, tmpdbpath
        call MakePath
        push byte 20h
        push tmpdbpath
        call OpenArtArchiveErr
        add esp, byte 8
        mov dword [careerdb], eax
        push tmpdbpath
        call GetFileSize
        add esp, byte 4
        mov dword [careerdb_size], eax
        mov ebx, dword [leaguedbnames+0Ch]
        mov ecx, str_TMP
        xor edx, edx
        mov eax, tmpdbpath
        call MakePath
        push byte 20h
        push tmpdbpath
        call OpenArtArchiveErr
        add esp, byte 8
        mov dword [carteamsdb], eax
        push tmpdbpath
        call GetFileSize
        add esp, byte 4
        mov dword [carteamsdb_size], eax
        mov ebx, dword [leaguedbnames]
        mov ecx, str_TMP
        xor edx, edx
        mov eax, tmpdbpath
        call MakePath
        push byte 20h
        push tmpdbpath
        call OpenArtArchiveErr
        add esp, byte 8
        mov dword [keydb], eax
        push tmpdbpath
        call GetFileSize
        add esp, byte 4
        mov dword [keydb_size], eax
        mov ebx, dword [leaguedbnames+10h]
        mov ecx, str_TMP
        xor edx, edx
        mov eax, tmpdbpath
        call MakePath
        push byte 20h
        push tmpdbpath
        call OpenArtArchiveErr
        add esp, byte 8
        mov dword [teamsdb], eax
        push tmpdbpath
        call GetFileSize
        add esp, byte 4
        mov dword [teamsdb_size], eax
        mov ebx, dword [leaguedbnames+8]
        mov ecx, str_TMP
        xor edx, edx
        mov eax, tmpdbpath
        call MakePath
        push byte 20h
        push tmpdbpath
        call OpenArtArchiveErr
        add esp, byte 8
        mov dword [attdb], eax
        push tmpdbpath
        call GetFileSize
        add esp, byte 4
        mov dword [attdb_size], eax
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DeleteTempDatabases                                             7125C  95 PC
; Unlinks the .TMP copies of the league databases
;-----------------------------------------------------------------------------
; C: src/front/roster_edit/DeleteTempDatabases.c
%ifdef CBUILD
%include "c/front/roster_edit/DeleteTempDatabases.inc"
%else
DeleteTempDatabases:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov ebx, dword [leaguedbnames+14h]
        mov ecx, str_TMP
        xor edx, edx
        mov eax, tmpdbpath
        call MakePath
        mov eax, tmpdbpath
        call j_unlink_
        mov ebx, dword [leaguedbnames+4]
        mov ecx, str_TMP
        xor edx, edx
        mov eax, tmpdbpath
        call MakePath
        mov eax, tmpdbpath
        call j_unlink_
        mov ebx, dword [leaguedbnames+0Ch]
        mov ecx, str_TMP
        xor edx, edx
        mov eax, tmpdbpath
        call MakePath
        mov eax, tmpdbpath
        call j_unlink_
        mov ebx, dword [leaguedbnames]
        mov ecx, str_TMP
        xor edx, edx
        mov eax, tmpdbpath
        call MakePath
        mov eax, tmpdbpath
        call j_unlink_
        mov ebx, dword [leaguedbnames+10h]
        mov ecx, str_TMP
        xor edx, edx
        mov eax, tmpdbpath
        call MakePath
        mov eax, tmpdbpath
        call j_unlink_
        mov ebx, dword [leaguedbnames+8]
        mov ecx, str_TMP
        xor edx, edx
        mov eax, tmpdbpath
        call MakePath
        mov eax, tmpdbpath
        call j_unlink_
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SwapSelectedPlayers                             71333  95 PC, low confidence
; Unreferenced: checks 'The number of selected players and goalies must be
; the same on both teams!' and exchanges the selected players between the two
; panels
;-----------------------------------------------------------------------------
SwapSelectedPlayers:
        push dword 114h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, 0E4h
        push edx
        push ebx
        xor edx, edx
        mov dword [dword esp+0E8h], edx
        xor ebp, ebp
        xor eax, eax
        xor ebx, ebx
.1:
        cmp byte [dword ebx+rostersel], 0
        je short .2
        inc dword [dword esp+0E8h]
.2:
        cmp byte [dword ebx+rostersel+1Ch], 0
        je short .3
        inc edx
.3:
        inc ebx
        cmp ebx, byte 19h
        jl short SwapSelectedPlayers.1
        xor ebx, ebx
.4:
        cmp byte [dword ebx+byte_EAF99], 0
        je short .5
        inc ebp
.5:
        cmp byte [dword ebx+byte_EAFB5], 0
        je short .6
        inc eax
.6:
        inc ebx
        cmp ebx, byte 3
        jl short SwapSelectedPlayers.4
        cmp edx, dword [dword esp+0E8h]
        jne short .7
        cmp ebp, eax
        je near .12
.7:
        mov ecx, 6
        lea edi, [byte esp+08h]
        mov esi, str_TheNumberOfSelected
        rep movsd
        cmp edx, dword [dword esp+0E8h]
        je short .8
        cmp ebp, eax
        je short .8
        mov edx, str_PlayersAndGoalies
        jmp short .10
.8:
        cmp edx, dword [dword esp+0E8h]
        je short .9
        mov edx, str_Players
        jmp short .10
.9:
        cmp ebp, eax
        je short .11
        mov edx, str_Goalies
.10:
        lea eax, [byte esp+08h]
        call strcat_
.11:
        lea eax, [byte esp+08h]
        mov dword [msglines], eax
        mov dword [msglines+4], str_MustBeTheSame
        push byte 0FFFFFFFFh
        mov esi, dword [byte esp+04h]
        push esi
        mov edi, dword [byte esp+0Ch]
        push edi
        push byte 0
        push byte 0
        mov ecx, 2
        mov ebx, msglines
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        jmp near .x
.12:
        xor eax, eax
        xor ecx, ecx
        xor ebx, ebx
.13:
        cmp byte [dword ebx+rostersel], 0
        je short .14
        mov edx, ebx
        shl edx, 3
        sub edx, ebx
        shl edx, 2
        sub edx, ebx
        mov dl, byte [dword edx+rosterslot]
        mov byte [dword esp+eax+0B0h], dl
        mov byte [byte esp+eax+078h], bl
        inc eax
.14:
        cmp byte [dword ebx+rostersel+1Ch], 0
        je short .15
        mov edx, ebx
        shl edx, 3
        sub edx, ebx
        shl edx, 2
        sub edx, ebx
        mov dl, byte [dword edx+byte_EAC86]
        mov byte [dword esp+ecx+0CCh], dl
        mov byte [dword esp+ecx+094h], bl
        inc ecx
.15:
        inc ebx
        cmp ebx, byte 1Ch
        jl short SwapSelectedPlayers.13
        add dword [dword esp+0E8h], ebp
        xor ebx, ebx
        jmp near .21
.16:
        xor eax, eax
        mov al, byte [dword esp+ebx+0B0h]
        mov edx, dword [rosterteamrec]
        mov eax, dword [byte edx+eax*4+04Ch]
        call KeyDbPtr
        mov edx, eax
        xor eax, eax
        mov al, byte [dword esp+ebx+0CCh]
        mov ecx, eax
        shl ecx, 2
        mov eax, dword [dword_EAF7C]
        mov eax, dword [byte ecx+eax+04Ch]
        call KeyDbPtr
        mov cl, byte [eax]
        mov ch, byte [edx]
        xor ch, cl
        mov byte [edx], ch
        mov cl, ch
        mov ch, byte [eax]
        xor ch, cl
        mov byte [eax], ch
        xor byte [edx], ch
        xor eax, eax
        mov al, byte [dword esp+ebx+0B0h]
        mov edx, eax
        shl edx, 2
        mov eax, dword [rosterteamrec]
        add eax, edx
        xor edx, edx
        mov dl, byte [dword esp+ebx+0CCh]
        mov ecx, edx
        shl ecx, 2
        mov edx, dword [dword_EAF7C]
        mov edx, dword [byte ecx+edx+04Ch]
        xor dword [byte eax+04Ch], edx
        xor edx, edx
        mov dl, byte [dword esp+ebx+0CCh]
        shl edx, 2
        mov eax, dword [dword_EAF7C]
        add eax, edx
        xor edx, edx
        mov dl, byte [dword esp+ebx+0B0h]
        mov ecx, dword [rosterteamrec]
        mov edx, dword [byte ecx+edx*4+04Ch]
        xor dword [byte eax+04Ch], edx
        xor edx, edx
        mov dl, byte [dword esp+ebx+0B0h]
        shl edx, 2
        mov eax, dword [rosterteamrec]
        add eax, edx
        xor edx, edx
        mov dl, byte [dword esp+ebx+0CCh]
        mov ecx, edx
        shl ecx, 2
        mov edx, dword [dword_EAF7C]
        mov edx, dword [byte ecx+edx+04Ch]
        xor dword [byte eax+04Ch], edx
        movzx ebp, byte [byte esp+ebx+078h]
        mov eax, ebp
        shl eax, 3
        sub eax, ebp
        shl eax, 2
        sub eax, ebp
        xor ecx, ecx
        mov cl, byte [dword esp+ebx+094h]
        mov edx, ecx
        shl edx, 3
        sub edx, ecx
        shl edx, 2
        sub edx, ecx
        mov cl, byte [dword edx+byte_EAC86]
        mov ch, byte [dword eax+rosterslot]
        xor ch, cl
        mov byte [dword eax+rosterslot], ch
        mov cl, ch
        mov ch, byte [dword edx+byte_EAC86]
        xor ch, cl
        mov byte [dword edx+byte_EAC86], ch
        mov cl, ch
        xor byte [dword eax+rosterslot], cl
        mov ecx, 6
        lea edi, [byte esp+05Ch]
        lea esi, [dword eax+rosterlist]
        rep movsd
        movsw
        movsb
        mov ecx, 6
        lea edi, [dword eax+rosterlist]
        lea esi, [dword edx+unk_EAC84]
        rep movsd
        movsw
        movsb
        mov ecx, 6
        lea edi, [dword edx+unk_EAC84]
        lea esi, [byte esp+05Ch]
        rep movsd
        movsw
        movsb
        mov edx, ebp
        xor eax, eax
        call FixJerseyNumber
        xor edx, edx
        mov dl, byte [dword esp+ebx+094h]
        mov eax, 1
        call FixJerseyNumber
        mov esi, dword [rosterteamrec]
        add esi, 0BCh
        xor eax, eax
.17:
        lea edx, [esi+eax]
        mov cl, byte [edx]
        cmp cl, byte [dword esp+ebx+0B0h]
        jne short .18
        mov byte [edx], 64h
.18:
        inc eax
        cmp eax, byte 30h
        jl short SwapSelectedPlayers.17
        mov esi, dword [dword_EAF7C]
        add esi, 0BCh
        xor eax, eax
.19:
        lea edx, [esi+eax]
        mov cl, byte [edx]
        cmp cl, byte [dword esp+ebx+0CCh]
        jne short .20
        mov byte [edx], 64h
.20:
        inc eax
        cmp eax, byte 30h
        jl short SwapSelectedPlayers.19
        inc ebx
.21:
        cmp ebx, dword [dword esp+0E8h]
        jl near SwapSelectedPlayers.16
        mov ebx, 1
        mov dword [dbdirty], ebx
        xor eax, eax
        call LoadRosterList
        mov eax, ebx
        call LoadRosterList
        call DrawEditRosters
.x:
        add esp, 0ECh
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
;-----------------------------------------------------------------------------
; SelectMatchingPlayers                                           71690  95 PC
; (first, last, side): selects the panel's players whose lower-cased
; first/last name match (last only when first is empty)
;-----------------------------------------------------------------------------
; C: src/front/roster_edit/SelectMatchingPlayers.c
%ifdef CBUILD
%include "c/front/roster_edit/SelectMatchingPlayers.inc"
%else
SelectMatchingPlayers:
        push dword 34h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 20h
        mov esi, eax
        mov edi, edx
        mov ebp, ebx
        cmp byte [dword ebx+rosterisfa], 1
        je near .6
        xor ecx, ecx
.1:
        mov eax, ebp
        shl eax, 3
        sub eax, ebp
        xor dh, dh
        mov byte [dword ecx+eax*4+rostersel], dh
        inc ecx
        cmp ecx, byte 1Ch
        jl short SelectMatchingPlayers.1
        xor ecx, ecx
.2:
        mov eax, ebp
        shl eax, 2
        sub eax, ebp
        shl eax, 2
        mov ebx, eax
        shl ebx, 6
        sub ebx, eax
        mov eax, ecx
        shl eax, 3
        sub eax, ecx
        shl eax, 2
        sub eax, ecx
        mov eax, dword [dword ebx+eax+dword_EA994]
        call KeyDbPtr
        mov ebx, eax
        lea edx, [byte eax+03h]
        lea eax, [byte esp+010h]
        call strcpy_
        lea edx, [byte ebx+013h]
        mov eax, esp
        call strcpy_
        lea eax, [byte esp+010h]
        call strlwr_
        mov eax, esp
        call strlwr_
        lea edx, [byte esp+010h]
        mov eax, esi
        call strcmp_
        test eax, eax
        jne short .3
        mov edx, esp
        mov eax, edi
        call strcmp_
        test eax, eax
        je short .4
.3:
        cmp byte [edi], 0
        jne short .5
        mov edx, esp
        mov eax, esi
        call strcmp_
        test eax, eax
        jne short .5
.4:
        mov eax, ebp
        shl eax, 3
        sub eax, ebp
        mov dl, byte [dword ecx+eax*4+rostersel]
        not dl
        mov byte [dword ecx+eax*4+rostersel], dl
.5:
        inc ecx
        cmp ecx, byte 1Ch
        jl near SelectMatchingPlayers.2
        jmp near .x
.6:
        xor ecx, ecx
        jmp short .8
.7:
        mov eax, dword [falistsel]
        mov byte [ecx+eax], 0
        inc ecx
.8:
        cmp ecx, dword [facount]
        jl short SelectMatchingPlayers.7
        cmp dword [FaListScrolls], byte 0
        je short .9
        mov dword [falisttop], 0FFFFFFFFh
.9:
        xor ecx, ecx
        jmp near .14
.10:
        mov eax, ecx
        shl eax, 3
        sub eax, ecx
        shl eax, 2
        sub eax, ecx
        mov edx, dword [falist]
        add eax, edx
        add eax, byte 8
        mov ebx, esp
        lea edx, [byte esp+010h]
        call SplitPlayerName
        lea eax, [byte esp+010h]
        call strlwr_
        mov eax, esp
        call strlwr_
        lea edx, [byte esp+010h]
        mov eax, esi
        call strcmp_
        test eax, eax
        jne short .11
        mov edx, esp
        mov eax, edi
        call strcmp_
        test eax, eax
        je short .12
.11:
        cmp byte [edi], 0
        jne short .13
        mov edx, esp
        mov eax, esi
        call strcmp_
        test eax, eax
        jne short .13
.12:
        mov eax, dword [falistsel]
        mov dl, byte [ecx+eax]
        not dl
        mov byte [ecx+eax], dl
        cmp dword [FaListScrolls], byte 0
        je short .13
        cmp dword [falisttop], byte 0FFFFFFFFh
        jne short .13
        mov dword [falisttop], ecx
.13:
        inc ecx
.14:
        cmp ecx, dword [facount]
        jl near SelectMatchingPlayers.10
.x:
        add esp, byte 20h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SetRosterTeamMenus                                              7183D  95 PC
; (side, team): re-enables the old team's division item (or 'Free Agents
; ...'), disables the new one and sets 'Edit Team Lines ...'
;-----------------------------------------------------------------------------
SetRosterTeamMenus:
        push dword 14h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, eax
        mov esi, edx
        movzx edi, byte [dword eax+rosterteam]
        cmp edi, 0FFh
        jne short .1
        mov edx, ShowFreeAgents
        mov dword [menu_r1_freeagents], edx
        mov dword [menu_r2_freeagents], edx
        jmp short .5
.1:
        mov ecx, dword [nosplit edi*4+teamdivflags]
        sar ecx, 1
        cmp ecx, byte 4
        jne short .2
        dec ecx
.2:
        xor edx, edx
.3:
        mov eax, ecx
        shl eax, 3
        sub eax, ecx
        mov al, byte [dword edx+eax+divisionteams]
        and eax, 0FFh
        cmp eax, edi
        je short .4
        inc edx
        cmp edx, byte 7
        jl short SetRosterTeamMenus.3
.4:
        shl ecx, 5
        shl edx, 5
        mov eax, dword [dword ecx+roster1divmenus]
        mov dword [byte edx+eax+014h], SelectRosterTeam
        mov eax, dword [dword ecx+roster2divmenus]
        mov dword [byte edx+eax+014h], SelectRosterTeam
.5:
        cmp esi, byte 64h
        jne short .8
        test ebp, ebp
        jne short .6
        mov dword [menu_r1_editlines], ebp
        jmp short .7
.6:
        xor ecx, ecx
        mov dword [menu_r2_editlines], ecx
.7:
        xor edi, edi
        mov dword [menu_r1_freeagents], edi
        mov dword [menu_r2_freeagents], edi
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
.8:
        mov ecx, dword [nosplit esi*4+teamdivflags]
        sar ecx, 1
        cmp ecx, byte 4
        jne short .9
        dec ecx
.9:
        xor edx, edx
.10:
        mov eax, ecx
        shl eax, 3
        sub eax, ecx
        mov al, byte [dword edx+eax+divisionteams]
        and eax, 0FFh
        cmp eax, esi
        je short .11
        inc edx
        cmp edx, byte 7
        jl short SetRosterTeamMenus.10
.11:
        shl ecx, 5
        mov eax, edx
        shl eax, 5
        mov edx, dword [dword ecx+roster1divmenus]
        mov dword [byte edx+eax+014h], 0
        mov edx, dword [dword ecx+roster2divmenus]
        mov dword [byte edx+eax+014h], 0
        test ebp, ebp
        jne short .12
        mov dword [menu_r1_editlines], EditTeamLines
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
.12:
        mov dword [menu_r2_editlines], EditTeamLines
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
;-----------------------------------------------------------------------------
; FindPlayer                                                      71961  95 PC
; 'Find Player ...' menu item: 'Enter name of player to find:', searches the
; free-agent list and the teams, 'Choose which team to display' / 'is already
; displayed on Roster N' / 'does not exist!', then SetRosterTeamMenus,
; LoadRosterList and SelectMatchingPlayers
;-----------------------------------------------------------------------------
; C: src/front/roster_edit/FindPlayer.c
%ifdef CBUILD
%include "c/front/roster_edit/FindPlayer.inc"
%else
FindPlayer:
        push dword 1E8h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, 1B8h
        push edx
        push ebx
        cmp dword [eax], byte 1
        setne al
        and eax, 0FFh
        mov dword [dword esp+01BCh], eax
        sete al
        and eax, 0FFh
        mov dword [dword esp+01B4h], eax
        xor ah, ah
        mov byte [dword esp+0154h], ah
        mov dword [msglines], str_EnterNameOfPlayer
        push byte 0
        push byte 0
        push byte 0
        push byte 0
        push dword 0BAh
        mov ecx, 1Fh
        lea ebx, [dword esp+0168h]
        mov edx, 1
        mov eax, msglines
        call InputDialog
        lea eax, [dword esp+0154h]
        call strlwr_
        lea ebx, [dword esp+0174h]
        lea edx, [dword esp+01A4h]
        lea eax, [dword esp+0154h]
        call SplitPlayerName
        cmp byte [dword esp+0174h], 0
        jne short .1
        cmp byte [dword esp+01A4h], 0
        je near .x
.1:
        xor esi, esi
        xor edi, edi
.2:
        mov eax, edi
        call TeamRecPtr
        mov ebp, eax
        mov dword [dword esp+esi*4+0E8h], 0FFFFFFFFh
        xor ebx, ebx
        jmp near .7
.3:
        mov eax, ebx
        mov eax, dword [byte ebp+eax*4+04Ch]
        call KeyDbPtr
        mov ecx, eax
        lea edx, [byte eax+03h]
        lea eax, [dword esp+0184h]
        call strcpy_
        lea edx, [byte ecx+013h]
        lea eax, [dword esp+0194h]
        call strcpy_
        lea eax, [dword esp+0184h]
        call strlwr_
        lea eax, [dword esp+0194h]
        call strlwr_
        lea edx, [dword esp+0184h]
        lea eax, [dword esp+01A4h]
        call strcmp_
        test eax, eax
        jne short .4
        lea edx, [dword esp+0194h]
        lea eax, [dword esp+0174h]
        call strcmp_
        test eax, eax
        je short .5
.4:
        cmp byte [dword esp+0174h], 0
        jne short .6
        lea edx, [dword esp+0194h]
        lea eax, [dword esp+01A4h]
        call strcmp_
        test eax, eax
        jne short .6
.5:
        mov dword [dword esp+esi*4+0E8h], edi
        inc esi
.6:
        inc ebx
.7:
        cmp ebx, byte 1Ch
        jge short .8
        cmp dword [dword esp+esi*4+0E8h], byte 0
        jl near FindPlayer.3
.8:
        inc edi
        cmp edi, byte 1Ah
        jl near FindPlayer.2
        mov ebx, 34h
        xor edx, edx
        mov eax, dword [keydb_size]
        div ebx
        mov edi, eax
        mov dword [dword esp+esi*4+0E8h], 0FFFFFFFFh
        xor ecx, ecx
        jmp near .13
.9:
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 2
        mov ebx, dword [keydb]
        add ebx, eax
        cmp byte [ebx], 0FFh
        jne near .12
        lea edx, [byte ebx+03h]
        lea eax, [dword esp+0184h]
        call strcpy_
        lea edx, [byte ebx+013h]
        lea eax, [dword esp+0194h]
        call strcpy_
        lea eax, [dword esp+0184h]
        call strlwr_
        lea eax, [dword esp+0194h]
        call strlwr_
        lea edx, [dword esp+0184h]
        lea eax, [dword esp+01A4h]
        call strcmp_
        test eax, eax
        jne short .10
        lea edx, [dword esp+0194h]
        lea eax, [dword esp+0174h]
        call strcmp_
        test eax, eax
        je short .11
.10:
        cmp byte [dword esp+0174h], 0
        jne short .12
        lea edx, [dword esp+0194h]
        lea eax, [dword esp+01A4h]
        call strcmp_
        test eax, eax
        jne short .12
.11:
        mov dword [dword esp+esi*4+0E8h], 64h
        inc esi
.12:
        inc ecx
.13:
        cmp ecx, edi
        jge short .14
        cmp dword [dword esp+esi*4+0E8h], byte 0
        jl near FindPlayer.9
.14:
        test esi, esi
        jle near .36
        cmp esi, byte 1
        jle short .19
        xor ebx, ebx
        xor edi, edi
        jmp short .18
.15:
        mov eax, edi
        shl eax, 2
        mov edx, ebx
        shl edx, 2
        mov ecx, dword [dword esp+eax+0E8h]
        cmp ecx, byte 64h
        jne short .16
        mov dword [byte esp+edx+08h], str_FreeAgentList
        jmp short .17
.16:
        cmp ecx, byte 1Ah
        jge short .17
        mov eax, dword [nosplit ecx*4+teamcitynames]
        mov dword [byte esp+edx+08h], eax
.17:
        inc ebx
        inc edi
.18:
        cmp edi, esi
        jl short FindPlayer.15
        lea eax, [byte esp+078h]
        push eax
        push byte 0
        xor ecx, ecx
        mov ebx, str_ChooseWhichTeamTo
        mov edx, esi
        lea eax, [byte esp+010h]
        call ListDialog
        mov eax, dword [dword esp+eax*4+0E8h]
        jmp short .20
.19:
        mov eax, dword [dword esp+0E8h]
.20:
        mov dword [dword esp+01B8h], eax
        cmp dword [dword esp+01B8h], byte 64h
        jne near .24
        mov eax, dword [dword esp+01B4h]
        cmp byte [dword eax+rosterisfa], 1
        jne short .23
        lea eax, [dword esp+0154h]
        mov dword [msglines], eax
        mov dword [msglines+4], str_IsAlreadyDisplayedOn
        cmp dword [dword esp+01BCh], byte 0
        jne short .21
        mov eax, str_Roster2
        jmp short .22
.21:
        mov eax, str_Roster1
.22:
        mov dword [msglines+8], eax
        push byte 0FFFFFFFFh
        mov ecx, dword [byte esp+04h]
        push ecx
        mov esi, dword [byte esp+0Ch]
        push esi
        push byte 0
        push byte 0
        mov ecx, 3
        mov ebx, msglines
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        jmp near .28
.23:
        mov eax, dword [dword esp+01BCh]
        cmp byte [dword eax+rosterisfa], 1
        je near .28
        mov edx, dword [dword esp+01B8h]
        call SetRosterTeamMenus
        mov eax, dword [dword esp+01BCh]
        mov byte [dword eax+rosterisfa], 1
        call LoadRosterList
        mov eax, dword [dword esp+01BCh]
        mov byte [dword eax+rosterteam], 0FFh
        jmp near .28
.24:
        xor eax, eax
        mov edx, dword [dword esp+01B4h]
        mov al, byte [dword edx+rosterteam]
        mov ebx, dword [dword esp+01B8h]
        cmp eax, ebx
        jne short .27
        lea eax, [dword esp+0154h]
        mov dword [msglines], eax
        mov dword [msglines+4], str_IsAlreadyDisplayedOn
        cmp dword [dword esp+01BCh], byte 0
        jne short .25
        mov eax, str_Roster2
        jmp short .26
.25:
        mov eax, str_Roster1
.26:
        mov dword [msglines+8], eax
        push byte 0FFFFFFFFh
        mov ebp, dword [byte esp+04h]
        push ebp
        mov eax, dword [byte esp+0Ch]
        push eax
        push byte 0
        push byte 0
        mov ecx, 3
        mov ebx, msglines
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov eax, dword [dword esp+01B4h]
        mov dword [dword esp+01BCh], eax
        jmp short .28
.27:
        xor eax, eax
        mov edx, dword [dword esp+01BCh]
        mov al, byte [dword edx+rosterteam]
        cmp eax, ebx
        je short .28
        mov edx, ebx
        mov eax, dword [dword esp+01BCh]
        call SetRosterTeamMenus
        mov eax, dword [dword esp+01BCh]
        xor dl, dl
        mov byte [dword eax+rosterisfa], dl
        mov al, byte [dword esp+01B8h]
        mov edx, dword [dword esp+01BCh]
        mov byte [dword edx+rosterteam], al
        mov eax, edx
        call LoadRosterList
.28:
        mov ebx, dword [dword esp+01BCh]
        lea edx, [dword esp+0174h]
        lea eax, [dword esp+01A4h]
        call SelectMatchingPlayers
        call DrawEditRosters
        mov eax, dword [dword esp+01BCh]
        cmp byte [dword eax+rosterisfa], 1
        jne short .29
        mov eax, dword [falistsel]
        jmp short .30
.29:
        mov edx, eax
        shl eax, 3
        sub eax, edx
        shl eax, 2
        add eax, rostersel
.30:
        call CountSelected
        test eax, eax
        jle near .34
        cmp dword [dword esp+01BCh], byte 0
        jne short .32
        cmp byte [rosterisfa], 1
        je short .31
        cmp dword [facount], byte 1Eh
        jge short .31
        mov dword [menu_r1_tofa], MoveToFreeAgents
.31:
        cmp byte [rosterisfa+1], 1
        je near .x
        mov dword [menu_r1_toroster2], MoveToOtherRoster
        jmp near .x
.32:
        cmp byte [rosterisfa+1], 1
        je short .33
        cmp dword [facount], byte 1Eh
        jge short .33
        mov dword [menu_r2_tofa], MoveToFreeAgents
.33:
        cmp byte [rosterisfa], 1
        je near .x
        mov dword [menu_r2_toroster1], MoveToOtherRoster
        jmp short .x
.34:
        mov edi, dword [dword esp+01BCh]
        test edi, edi
        jne short .35
        mov dword [menu_r1_tofa], edi
        mov dword [menu_r1_toroster2], edi
        jmp short .x
.35:
        xor ebp, ebp
        mov dword [menu_r2_tofa], ebp
        mov dword [menu_r2_toroster1], ebp
        jmp short .x
.36:
        lea eax, [dword esp+0154h]
        mov dword [msglines], eax
        mov dword [msglines+4], str_DoesNotExist
        push byte 0FFFFFFFFh
        mov edx, dword [byte esp+04h]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        push byte 0
        push byte 0
        mov ecx, 2
        mov ebx, msglines
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
.x:
        add esp, 1C0h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
