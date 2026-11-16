; Adding or removing a human team, the master password, the league info file, and copying that
; team's files.
bits 32
%include "hockey.inc"
section s_408F5 progbits alloc exec nowrite align=1
extern __CHK, _fstrcspn_, AskMasterPassword, AskTeamPassword, btn_MasterDB, btn_TradeStats, btn_WrongDisk, awayremap
extern homeremap, lgschedrec, byte_DE268, cddriveptr, ClearInputQueue, CopyFile, curleague, DeleteFiles
extern dlgbevelcol1, dlgbevelcol2, dlgedgecol1, dlgedgecol2, dlgedgecol3, dlgfillcol, menuwidth_trade1, menutext_trade1
extern menuwidth_trade2, menutext_trade2, dword_DDD34, dword_DDD3C, tradebitmap, ExecuteTrade, ExportTeamToFloppy, FileClose
extern FileCreate, fileoncd, FileOpenRead, FileOpenRW, FileOpenWrite, FileReadAt, FileWriteAt, fputchar
extern FreeMemBlock, humancount, leaguedbnames, leagueflags, leaguemaster, leaguesaved, leagueteams, LeagueTeamSelect
extern lggameidx, lgplayteam, MakePath, masterpw, memset_, MergeLeagueFiles, MessageBox, msg_AllHuman
extern msg_Copying, msg_Copying_arg, msg_InsertDisk, msg_InsertDisk_arg, msg_MasterDB, msg_MasterDB_arg, msg_OneHuman, msg_SavedGame
extern msg_SavedGame_arg, msg_TradeDeadline, msg_TradeError, msg_WrongDisk, msg_WrongDisk_arg, negone_3DC28, ReadLeagueInfo, ReadSchedGame
extern ReadTeamNames, RestoreDialogBg, savedname, savleague1, savleague2, SelectFloppyDrive, SetDialogColors, sprintf_
extern str_bangpal, str_dot, str_easndesk, str_extBIN, str_extDB, str_extID, str_extLP, str_extnum
extern str_extxx, str_floppydrv, str_FromLeague, str_HOMEPALS, str_LLSN, str_LLST, str_PINFO, str_PLAYER
extern str_saved, str_SelNewHuman, str_SelRemoveHuman, str_SelTradeTeams, str_Show, str_star, str_Statistics, strcat_
extern strcpy_, strcspn_, stricmp_, strncpy_, AllocMemBlock, LoadBank, OpenArtArchiveErr, MouseRead
extern FindShape, ClearScreen, VgaSetPalette, CreateBitmap, teamcitynames, TradeScreen, treeteamnames, _dos_findfirst_
extern _dos_findnext_, word_DDD48, word_DDD4A, WriteLeagueTeamEntry
global AddHumanTeam, AddHumanTeam_msgbox, AddHumanTeam_exit, RemoveHumanTeam, CheckMasterPassword, FmtFromLeague, BuildLeagueList, LeagueCheckStub
global GetLeagueId, WriteLeagueInfo, MsgCopyingDatabases, CopyHumanTeamDBs, SaveLeagueGameRef
;-----------------------------------------------------------------------------
; AddHumanTeam                                                    408F5  95 PC
; League menu (temp_files 33256): ReadLeagueInfo, saved-game /
; master-database prompts, refuses when 1Ah teams are human ('All the teams
; are already human'), 'Select new human controlled team', then
; WriteLeagueInfo and CopyHumanTeamDBs for the new team
;-----------------------------------------------------------------------------
; C: src/front/league_teams/AddHumanTeam.c
%ifdef CBUILD
%include "c/front/league_teams/AddHumanTeam.inc"
%else
AddHumanTeam:
        push dword 74h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 44h
        xor ah, ah
        mov byte [byte_DE268], ah
        mov edx, 2
        mov eax, curleague
        call LeagueCheckStub
        mov esi, eax
.1:
        xor edi, edi
        test esi, esi
        jne short .2
        push savedname
        push leaguesaved
        push leagueflags
        push humancount
        mov ecx, leaguemaster
        mov ebx, masterpw
        mov edx, leagueteams
        mov eax, curleague
        call ReadLeagueInfo
        mov esi, eax
.2:
        test esi, esi
        jne near .5
        mov edx, curleague
        lea eax, [byte esp+020h]
        call strcpy_
        mov ecx, ds
        mov ebx, str_dot
        mov edx, ds
        lea eax, [byte esp+020h]
        call _fstrcspn_
        xor dl, dl
        mov byte [byte esp+eax+020h], dl
        lea eax, [byte esp+030h]
        push eax
        lea eax, [byte esp+038h]
        push eax
        lea eax, [byte esp+040h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push esi
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
        cmp dword [leaguesaved], byte 0
        je short .3
        lea eax, [byte esp+020h]
        mov dword [msg_SavedGame_arg], eax
        push byte 0FFFFFFFFh
        lea eax, [byte esp+034h]
        push eax
        lea eax, [byte esp+03Ch]
        push eax
        push esi
        push esi
        mov ecx, 3
        mov ebx, msg_SavedGame
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        jmp short .4
.3:
        test byte [leagueflags], 4
        jne short .5
        lea eax, [byte esp+020h]
        mov dword [msg_MasterDB_arg], eax
        push byte 0FFFFFFFFh
        lea eax, [byte esp+034h]
        push eax
        lea eax, [byte esp+03Ch]
        push eax
        push byte 2
        push btn_MasterDB
        mov ecx, 4
        mov ebx, msg_MasterDB
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov dword [byte esp+038h], eax
        test eax, eax
        jne short .4
        call MergeLeagueFiles
        mov edi, 0FFFFFFFFh
        jmp short .5
.4:
        mov esi, 0FFFFFFFFh
.5:
        test edi, edi
        jne near AddHumanTeam.1
        cmp byte [byte_DE268], 0
        je near .8
        push edi
        call ClearScreen
        add esp, byte 4
        xor ecx, ecx
        mov ebx, str_easndesk
        cmp byte [fileoncd+06Ah], 1
        jne short .6
        mov edx, dword [cddriveptr]
        jmp short .7
.6:
        xor edx, edx
.7:
        mov eax, esp
        call MakePath
        push byte 0
        lea eax, [byte esp+04h]
        push eax
        call LoadBank
        mov edi, eax
        add esp, byte 8
        push str_bangpal
        push eax
        call FindShape
        add esp, byte 8
        add eax, byte 10h
        push eax
        push dword 100h
        push byte 0
        call VgaSetPalette
        add esp, byte 0Ch
        push edi
        call FreeMemBlock
        add esp, byte 4
        mov ah, 17h
        mov byte [byte esp+040h], ah
        mov byte [byte esp+041h], ah
        mov byte [byte esp+042h], ah
        lea eax, [byte esp+040h]
        push eax
        push byte 1
        push dword 0F8h
        call VgaSetPalette
        add esp, byte 0Ch
        mov bl, 2Ah
        mov byte [byte esp+040h], bl
        mov byte [byte esp+041h], bl
        mov byte [byte esp+042h], bl
        lea eax, [byte esp+040h]
        push eax
        push byte 1
        push dword 0F9h
        call VgaSetPalette
        add esp, byte 0Ch
        mov ch, 3Fh
        mov byte [byte esp+040h], ch
        mov byte [byte esp+041h], ch
        mov byte [byte esp+042h], ch
        lea eax, [byte esp+040h]
        push eax
        push byte 1
        push dword 0FAh
        call VgaSetPalette
        add esp, byte 0Ch
.8:
        test esi, esi
        jne near AddHumanTeam_exit
        mov ebx, dword [humancount]
        cmp ebx, byte 1Ah
        jge near .9
        mov esi, ebx
        mov ebx, dword [leaguedbnames+10h]
        mov ecx, str_extDB
        mov edx, curleague
        mov eax, esp
        call MakePath
        mov ebx, 1
        mov edx, treeteamnames
        mov eax, esp
        call ReadTeamNames
        lea eax, [byte esp+03Ch]
        push eax
        push str_SelNewHuman
        push byte 2
        mov ecx, leagueteams
        mov ebx, treeteamnames
        mov edx, humancount
        mov eax, curleague
        call LeagueTeamSelect
        cmp dword [byte esp+03Ch], byte 0
        jl near AddHumanTeam_exit
        mov edi, dword [humancount]
        cmp esi, edi
        je near AddHumanTeam_exit
        push savedname
        mov ebp, dword [leaguesaved]
        push ebp
        mov eax, dword [leagueflags]
        push eax
        push edi
        mov ecx, dword [leaguemaster]
        mov ebx, masterpw
        mov edx, leagueteams
        mov eax, curleague
        call WriteLeagueInfo
        test eax, eax
        jne short AddHumanTeam_exit
        mov ebx, 0FFFFFFFFh
        mov edx, leagueteams
        mov eax, curleague
        call CopyHumanTeamDBs
        jmp short AddHumanTeam_exit
.9:
        lea eax, [byte esp+030h]
        push eax
        lea eax, [byte esp+038h]
        push eax
        lea eax, [byte esp+040h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [byte esp+034h]
        push eax
        lea eax, [byte esp+03Ch]
        push eax
        push esi
        push esi
        mov ecx, 1
        mov ebx, msg_AllHuman
AddHumanTeam_msgbox:
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
AddHumanTeam_exit:
        add esp, byte 44h
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; RemoveHumanTeam                                                 40C29  95 PC
; League menu (temp_files 332EC): same checks as AddHumanTeam, refuses with
; one human team ('There is only one human controlled team!'), 'Select human
; controlled team to remove', then rewrites PINFO.DB
;-----------------------------------------------------------------------------
; C: src/front/league_teams/AddHumanTeam.c (RemoveHumanTeam)
%ifdef CBUILD
%include "c/front/league_teams/AddHumanTeam.RemoveHumanTeam.inc"
%else
RemoveHumanTeam:
        push dword 74h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 44h
        xor ah, ah
        mov byte [byte_DE268], ah
        mov edx, 2
        mov eax, curleague
        call LeagueCheckStub
        mov esi, eax
.1:
        xor edi, edi
        test esi, esi
        jne short .2
        push savedname
        push leaguesaved
        push leagueflags
        push humancount
        mov ecx, leaguemaster
        mov ebx, masterpw
        mov edx, leagueteams
        mov eax, curleague
        call ReadLeagueInfo
        mov esi, eax
.2:
        test esi, esi
        jne near .5
        mov edx, curleague
        lea eax, [byte esp+020h]
        call strcpy_
        mov ecx, ds
        mov ebx, str_dot
        mov edx, ds
        lea eax, [byte esp+020h]
        call _fstrcspn_
        xor dl, dl
        mov byte [byte esp+eax+020h], dl
        lea eax, [byte esp+030h]
        push eax
        lea eax, [byte esp+038h]
        push eax
        lea eax, [byte esp+044h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push esi
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
        cmp dword [leaguesaved], byte 0
        je short .3
        lea eax, [byte esp+020h]
        mov dword [msg_SavedGame_arg], eax
        push byte 0FFFFFFFFh
        lea eax, [byte esp+034h]
        push eax
        lea eax, [byte esp+03Ch]
        push eax
        push esi
        push esi
        mov ecx, 3
        mov ebx, msg_SavedGame
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        jmp short .4
.3:
        test byte [leagueflags], 4
        jne short .5
        lea eax, [byte esp+020h]
        mov dword [msg_MasterDB_arg], eax
        push byte 0FFFFFFFFh
        lea eax, [byte esp+034h]
        push eax
        lea eax, [byte esp+03Ch]
        push eax
        push byte 2
        push btn_MasterDB
        mov ecx, 4
        mov ebx, msg_MasterDB
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov dword [byte esp+03Ch], eax
        test eax, eax
        jne short .4
        call MergeLeagueFiles
        mov edi, 0FFFFFFFFh
        jmp short .5
.4:
        mov esi, 0FFFFFFFFh
.5:
        test edi, edi
        jne near RemoveHumanTeam.1
        cmp byte [byte_DE268], 0
        je near .8
        push edi
        call ClearScreen
        add esp, byte 4
        xor ecx, ecx
        mov ebx, str_easndesk
        cmp byte [fileoncd+06Ah], 1
        jne short .6
        mov edx, dword [cddriveptr]
        jmp short .7
.6:
        xor edx, edx
.7:
        mov eax, esp
        call MakePath
        push byte 0
        lea eax, [byte esp+04h]
        push eax
        call LoadBank
        mov edi, eax
        add esp, byte 8
        push str_bangpal
        push eax
        call FindShape
        add esp, byte 8
        add eax, byte 10h
        push eax
        push dword 100h
        push byte 0
        call VgaSetPalette
        add esp, byte 0Ch
        push edi
        call FreeMemBlock
        add esp, byte 4
        mov ah, 17h
        mov byte [byte esp+040h], ah
        mov byte [byte esp+041h], ah
        mov byte [byte esp+042h], ah
        lea eax, [byte esp+040h]
        push eax
        push byte 1
        push dword 0F8h
        call VgaSetPalette
        add esp, byte 0Ch
        mov bl, 2Ah
        mov byte [byte esp+040h], bl
        mov byte [byte esp+041h], bl
        mov byte [byte esp+042h], bl
        lea eax, [byte esp+040h]
        push eax
        push byte 1
        push dword 0F9h
        call VgaSetPalette
        add esp, byte 0Ch
        mov ch, 3Fh
        mov byte [byte esp+040h], ch
        mov byte [byte esp+041h], ch
        mov byte [byte esp+042h], ch
        lea eax, [byte esp+040h]
        push eax
        push byte 1
        push dword 0FAh
        call VgaSetPalette
        add esp, byte 0Ch
.8:
        test esi, esi
        jne near AddHumanTeam_exit
        mov ebx, dword [humancount]
        cmp ebx, byte 1
        jle near .9
        mov esi, ebx
        mov ebx, dword [leaguedbnames+10h]
        mov ecx, str_extDB
        mov edx, curleague
        mov eax, esp
        call MakePath
        mov ebx, 1
        mov edx, treeteamnames
        mov eax, esp
        call ReadTeamNames
        lea eax, [byte esp+038h]
        push eax
        push str_SelRemoveHuman
        push byte 4
        mov ecx, leagueteams
        mov ebx, treeteamnames
        mov edx, humancount
        mov eax, curleague
        call LeagueTeamSelect
        cmp dword [byte esp+038h], byte 0
        jl near AddHumanTeam_exit
        mov edi, dword [humancount]
        cmp esi, edi
        je near AddHumanTeam_exit
        push savedname
        mov ebp, dword [leaguesaved]
        push ebp
        mov eax, dword [leagueflags]
        push eax
        push edi
        mov ecx, dword [leaguemaster]
        mov ebx, masterpw
        mov edx, leagueteams
        mov eax, curleague
        call WriteLeagueInfo
        jmp near AddHumanTeam_exit
.9:
        push esi
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
        lea eax, [byte esp+030h]
        push eax
        lea eax, [byte esp+038h]
        push eax
        lea eax, [byte esp+044h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [byte esp+034h]
        push eax
        lea eax, [byte esp+03Ch]
        push eax
        push esi
        push esi
        mov ecx, 2
        mov ebx, msg_OneHuman
        jmp near AddHumanTeam_msgbox
%endif ; C
;-----------------------------------------------------------------------------
; CheckMasterPassword                          40F4E  95 PC, medium confidence
; League menu (temp_files 3331D): ReadLeagueInfo, master-database prompt,
; then AskMasterPassword for the league master team (leaguemaster); returns
; its result (0 = accepted), the caller runs settings when it fails
;-----------------------------------------------------------------------------
; C: src/front/league_teams/CheckMasterPassword.c
%ifdef CBUILD
%include "c/front/league_teams/CheckMasterPassword.inc"
%else
CheckMasterPassword:
        push dword 4Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 20h
        mov edx, 2
        mov eax, curleague
        call LeagueCheckStub
        mov esi, eax
.1:
        xor edi, edi
        test esi, esi
        jne short .2
        push savedname
        push leaguesaved
        push leagueflags
        push humancount
        mov ecx, leaguemaster
        mov ebx, masterpw
        mov edx, leagueteams
        mov eax, curleague
        call ReadLeagueInfo
        mov esi, eax
.2:
        test esi, esi
        jne near .4
        mov edx, curleague
        mov eax, esp
        call strcpy_
        mov ecx, ds
        mov ebx, str_dot
        mov edx, ds
        mov eax, esp
        call _fstrcspn_
        xor dl, dl
        mov byte [esp+eax], dl
        test byte [leagueflags], 4
        jne near .4
        mov eax, esp
        mov dword [msg_MasterDB_arg], eax
        push esi
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
        lea eax, [byte esp+010h]
        push eax
        lea eax, [byte esp+018h]
        push eax
        lea eax, [byte esp+020h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [byte esp+014h]
        push eax
        lea eax, [byte esp+01Ch]
        push eax
        push byte 2
        push btn_MasterDB
        mov ecx, 4
        mov ebx, msg_MasterDB
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov dword [byte esp+018h], eax
        test eax, eax
        jne short .3
        call MergeLeagueFiles
        mov edi, 0FFFFFFFFh
        jmp short .4
.3:
        mov esi, 0FFFFFFFFh
.4:
        test edi, edi
        jne near CheckMasterPassword.1
        test esi, esi
        jne near .6
        cmp byte [byte_DE268], 0
        je short .5
        push edi
        call ClearScreen
        add esp, byte 4
        mov bh, 17h
        mov byte [byte esp+01Ch], bh
        mov byte [byte esp+01Dh], bh
        mov byte [byte esp+01Eh], bh
        lea eax, [byte esp+01Ch]
        push eax
        push byte 1
        push dword 0F8h
        call VgaSetPalette
        add esp, byte 0Ch
        mov al, 2Ah
        mov byte [byte esp+01Ch], al
        mov byte [byte esp+01Dh], al
        mov byte [byte esp+01Eh], al
        lea eax, [byte esp+01Ch]
        push eax
        push byte 1
        push dword 0F9h
        call VgaSetPalette
        add esp, byte 0Ch
        mov dh, 3Fh
        mov byte [byte esp+01Ch], dh
        mov byte [byte esp+01Dh], dh
        mov byte [byte esp+01Eh], dh
        lea eax, [byte esp+01Ch]
        push eax
        push byte 1
        push dword 0FAh
        call VgaSetPalette
        add esp, byte 0Ch
.5:
        push byte 0
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
        mov eax, dword [leaguemaster]
        mov ebx, masterpw
        mov edx, leagueteams
        call AskMasterPassword
        mov esi, eax
        cmp byte [byte_DE268], 0
        je short .6
        push byte 0
        call ClearScreen
        add esp, byte 4
        xor ch, ch
        mov byte [byte esp+01Ch], ch
        mov byte [byte esp+01Dh], ch
        mov byte [byte esp+01Eh], ch
        lea eax, [byte esp+01Ch]
        push eax
        push byte 1
        push dword 0F8h
        call VgaSetPalette
        add esp, byte 0Ch
        lea eax, [byte esp+01Ch]
        push eax
        push byte 1
        push dword 0F9h
        call VgaSetPalette
        add esp, byte 0Ch
        lea eax, [byte esp+01Ch]
        push eax
        push byte 1
        push dword 0FAh
        call VgaSetPalette
        add esp, byte 0Ch
.6:
        mov eax, esi
        add esp, byte 20h
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; FmtFromLeague                                                   41171  95 PC
; Dst = text + ' from the league ' + league path up to the first '.'; used
; for the 'That disk is for ...' message and in database_merge/import_export
;-----------------------------------------------------------------------------
; C: src/front/league_teams/FmtFromLeague.c
%ifdef CBUILD
%include "c/front/league_teams/FmtFromLeague.inc"
%else
FmtFromLeague:
        push dword 20h
        call __CHK
        push ecx
        push esi
        push edi
        sub esp, byte 10h
        mov esi, eax
        mov edi, edx
        mov edx, ebx
        mov eax, esp
        call strcpy_
        mov ecx, ds
        mov ebx, str_dot
        mov edx, ds
        mov eax, esp
        call _fstrcspn_
        xor dl, dl
        mov byte [esp+eax], dl
        mov edx, edi
        mov eax, esi
        call strcpy_
        mov edx, str_FromLeague
        mov eax, esi
        call strcat_
        mov edx, esp
        mov eax, esi
        call strcat_
        add esp, byte 10h
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; BuildLeagueList                              411C8  95 PC, medium confidence
; Unreferenced: _dos_findfirst/next over '*.LP', allocates 'LLST' (pointer
; list) and 'LLSN' (9-byte names), keeps leagues whose GetLeagueId result
; passes the flag filter (bit 0: id >= 0, bit 1: id < 0); returns the count
;-----------------------------------------------------------------------------
; C: src/front/league_teams/BuildLeagueList.c
%ifdef CBUILD
%include "c/front/league_teams/BuildLeagueList.inc"
%else
BuildLeagueList:
        push dword 70h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 4Ch
        push eax
        mov edi, edx
        mov dword [byte esp+048h], ebx
        mov edx, str_star
        lea eax, [byte esp+030h]
        call strcpy_
        mov edx, str_extLP
        lea eax, [byte esp+030h]
        call strcat_
        xor ebp, ebp
        lea ebx, [byte esp+04h]
        mov edx, 10h
        lea eax, [byte esp+030h]
        call _dos_findfirst_
        test eax, eax
        jne short .3
        mov ebp, 1
.1:
        lea eax, [byte esp+04h]
        call _dos_findnext_
        mov edx, eax
        test eax, eax
        jne short .2
        inc ebp
.2:
        test edx, edx
        je short BuildLeagueList.1
.3:
        test ebp, ebp
        je near .12
        mov esi, ebp
        shl esi, 2
        push byte 20h
        push esi
        push str_LLST
        call AllocMemBlock
        add esp, byte 0Ch
        mov edx, dword [esp]
        mov dword [edx], eax
        mov ebx, esi
        xor edx, edx
        call memset_
        mov eax, ebp
        shl eax, 3
        add eax, ebp
        mov esi, eax
        push byte 20h
        push eax
        push str_LLSN
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [edi], eax
        mov ebx, esi
        xor edx, edx
        call memset_
        mov dword [byte esp+04Ch], ebp
        xor esi, esi
        jmp near .11
.4:
        test esi, esi
        jne short .5
        lea ebx, [byte esp+04h]
        mov edx, 10h
        lea eax, [byte esp+030h]
        call _dos_findfirst_
        jmp short .6
.5:
        lea eax, [byte esp+04h]
        call _dos_findnext_
.6:
        lea edx, [byte esp+040h]
        lea eax, [byte esp+022h]
        call GetLeagueId
        mov edx, eax
        test eax, eax
        jge short .7
        test byte [byte esp+048h], 2
        jne short .8
.7:
        test edx, edx
        jl short .9
        test byte [byte esp+048h], 1
        je short .9
.8:
        mov ecx, ds
        mov ebx, str_dot
        mov edx, ds
        lea eax, [byte esp+022h]
        call _fstrcspn_
        mov dword [byte esp+044h], eax
        mov ecx, esi
        shl ecx, 3
        add ecx, esi
        mov eax, dword [edi]
        add eax, ecx
        mov ebx, dword [byte esp+044h]
        lea edx, [byte esp+022h]
        call strncpy_
        mov eax, dword [edi]
        add eax, ecx
        add eax, dword [byte esp+044h]
        mov byte [eax], 0
        mov eax, dword [edi]
        add ecx, eax
        mov eax, esi
        mov edx, dword [esp]
        mov edx, dword [edx]
        mov dword [edx+eax*4], ecx
        jmp short .10
.9:
        dec ebp
.10:
        inc esi
.11:
        cmp esi, dword [byte esp+04Ch]
        jl near BuildLeagueList.4
.12:
        test ebp, ebp
        jne short .13
        mov eax, dword [esp]
        mov dword [eax], ebp
        mov dword [edi], ebp
.13:
        mov eax, ebp
        add esp, byte 50h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; LeagueCheckStub                              41337  95 PC, medium confidence
; Returns 0; called (league path, 2) before ReadLeagueInfo by
; AddHumanTeam/RemoveHumanTeam/CheckMasterPassword and in
; database_merge/import_export (stubbed-out check)
;-----------------------------------------------------------------------------
; C: src/front/league_teams/LeagueCheckStub.c
%ifdef CBUILD
%include "c/front/league_teams/LeagueCheckStub.inc"
%else
LeagueCheckStub:
        push dword 4
        call __CHK
        xor eax, eax
        ret
%endif ; C
;-----------------------------------------------------------------------------
; GetLeagueId                                  41344  95 PC, medium confidence
; Opens <dir>\PLAYER.ID, reads byte 0 and 4 bytes at 19h into the caller's
; buffer, returns byte 0 (FFh when the file is missing or short)
;-----------------------------------------------------------------------------
; C: src/front/league_teams/GetLeagueId.c
%ifdef CBUILD
%include "c/front/league_teams/GetLeagueId.inc"
%else
GetLeagueId:
        push dword 38h
        call __CHK
        push ebx
        push ecx
        push esi
        sub esp, byte 28h
        mov esi, edx
        mov dword [byte esp+020h], 0FFFFFFFFh
        mov ecx, str_extID
        mov ebx, str_PLAYER
        mov edx, eax
        mov eax, esp
        call MakePath
        lea edx, [byte esp+020h]
        mov eax, esp
        call FileOpenRead
        test eax, eax
        jne short .1
        mov ecx, 1
        xor ebx, ebx
        lea edx, [byte esp+024h]
        mov eax, dword [byte esp+020h]
        call FileReadAt
.1:
        test eax, eax
        jne short .2
        mov ecx, 4
        mov ebx, 19h
        mov edx, esi
        mov eax, dword [byte esp+020h]
        call FileReadAt
.2:
        test eax, eax
        je short .3
        mov byte [byte esp+024h], 0FFh
.3:
        lea eax, [byte esp+020h]
        call FileClose
        mov eax, dword [byte esp+021h]
        sar eax, 18h
        add esp, byte 28h
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; WriteLeagueInfo                                                 413CD  95 PC
; Creates <league>\PINFO.DB and writes: +0 human count, +2 master team, +4
; saved-game flag, +6 saved-game name (0Dh), +13h flags, +15h master password
; (0Bh), +20h team table (30Ch = 1Ah x 1Eh); args match the ReadLeagueInfo
; globals
;-----------------------------------------------------------------------------
; C: src/front/league_teams/WriteLeagueInfo.c
%ifdef CBUILD
%include "c/front/league_teams/WriteLeagueInfo.inc"
%else
WriteLeagueInfo:
        push dword 34h
        call __CHK
        push esi
        push edi
        sub esp, byte 28h
        mov esi, edx
        mov edi, ebx
        mov dword [byte esp+020h], ecx
        mov dword [byte esp+024h], 0FFFFFFFFh
        mov ecx, str_extDB
        mov ebx, str_PINFO
        mov edx, eax
        mov eax, esp
        call MakePath
        lea edx, [byte esp+024h]
        mov eax, esp
        call FileCreate
        mov edx, eax
        test eax, eax
        jne short .1
        mov ecx, 2
        xor ebx, ebx
        lea edx, [byte esp+034h]
        mov eax, dword [byte esp+024h]
        call FileWriteAt
        mov edx, eax
.1:
        test edx, edx
        jne short .2
        mov ecx, 2
        mov ebx, ecx
        lea edx, [byte esp+020h]
        mov eax, dword [byte esp+024h]
        call FileWriteAt
        mov edx, eax
.2:
        test edx, edx
        jne short .3
        mov ecx, 2
        mov ebx, 4
        lea edx, [byte esp+03Ch]
        mov eax, dword [byte esp+024h]
        call FileWriteAt
        mov edx, eax
.3:
        test edx, edx
        jne short .4
        mov ecx, 0Dh
        mov ebx, 6
        mov edx, dword [byte esp+040h]
        mov eax, dword [byte esp+024h]
        call FileWriteAt
        mov edx, eax
.4:
        test edx, edx
        jne short .5
        mov ecx, 2
        mov ebx, 13h
        lea edx, [byte esp+038h]
        mov eax, dword [byte esp+024h]
        call FileWriteAt
        mov edx, eax
.5:
        test edx, edx
        jne short .6
        mov ecx, 0Bh
        mov ebx, 15h
        mov edx, edi
        mov eax, dword [byte esp+024h]
        call FileWriteAt
        mov edx, eax
.6:
        test edx, edx
        jne short .7
        mov ecx, 30Ch
        mov ebx, 20h
        mov edx, esi
        mov eax, dword [byte esp+024h]
        call FileWriteAt
        mov edx, eax
.7:
        lea eax, [byte esp+024h]
        call FileClose
        mov eax, edx
        add esp, byte 28h
        pop edi
        pop esi
        ret 10h
%endif ; C
;-----------------------------------------------------------------------------
; MsgCopyingDatabases                                             414E0  95 PC
; MessageBox 'Copying databases for %s' (no buttons) with the team name
;-----------------------------------------------------------------------------
; C: src/front/league_teams/MsgCopyingDatabases.c
%ifdef CBUILD
%include "c/front/league_teams/MsgCopyingDatabases.inc"
%else
MsgCopyingDatabases:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push edx
        mov dword [msg_Copying_arg], eax
        push byte 0
        push byte 0
        push byte 0
        push byte 0
        push byte 0
        mov ecx, 2
        mov ebx, msg_Copying
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CopyHumanTeamDBs                             41516  95 PC, medium confidence
; For each human team (+17h = 1, or the one asked): team from disk (+18h = 2)
; asks 'Insert disk for', checks PLAYER.ID ('That disk is for ... from the
; league ...') and imports with ExportTeamToFloppy; otherwise
; MsgCopyingDatabases and copies the 7 league databases (KEY..SCHEDULE.DB) to
; '.xx' copies, sets +16h bit 0 and saves PINFO
;-----------------------------------------------------------------------------
CopyHumanTeamDBs:
        push dword 0E4h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, 0BCh
        mov esi, eax
        mov dword [dword esp+0ACh], edx
        mov dword [dword esp+0A8h], ebx
        mov edx, 0FFFFFFFFh
        mov dword [dword esp+094h], edx
        mov ebx, edx
        mov dword [dword esp+098h], edx
        xor ebx, edx
        xor ecx, ecx
        mov dword [dword esp+0B4h], ecx
        jmp near .18
.1:
        mov eax, edi
        shl eax, 4
        sub eax, edi
        add eax, eax
        add eax, dword [dword esp+0ACh]
        cmp byte [byte eax+017h], 1
        jne near .17
        mov eax, dword [dword esp+0A8h]
        test eax, eax
        jl short .2
        cmp eax, edi
        jne near .17
.2:
        mov ecx, dword [dword esp+0B4h]
        push ecx
        push str_extnum
        lea eax, [byte esp+08h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov edx, esp
        mov eax, str_extxx
        call strcpy_
        mov eax, ecx
        shl eax, 4
        sub eax, ecx
        add eax, eax
        add eax, dword [dword esp+0ACh]
        cmp byte [byte eax+018h], 2
        jne near .11
        test byte [byte eax+016h], 1
        jne near .11
.3:
        xor eax, eax
        mov dword [dword esp+0B0h], eax
        mov edx, dword [dword esp+0B4h]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        add eax, eax
        mov edi, dword [dword esp+0ACh]
        add edi, eax
        mov edx, edi
        lea eax, [dword esp+080h]
        call strcpy_
        lea eax, [dword esp+080h]
        mov dword [msg_InsertDisk_arg], eax
        lea eax, [dword esp+09Ch]
        push eax
        lea eax, [dword esp+0A4h]
        push eax
        lea eax, [dword esp+0ACh]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [dword esp+0A0h]
        push eax
        lea eax, [dword esp+0A8h]
        push eax
        push byte 0
        push byte 0
        mov ecx, 4
        mov ebx, msg_InsertDisk
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov ebp, eax
        test eax, eax
        jne short .4
        mov edx, edi
        mov eax, esi
        call SelectFloppyDrive
        mov ebp, eax
.4:
        test ebp, ebp
        jne near .8
        mov ecx, str_extID
        mov ebx, str_PLAYER
        mov edx, str_floppydrv
        lea eax, [byte esp+040h]
        call MakePath
        lea edx, [dword esp+094h]
        lea eax, [byte esp+040h]
        call FileOpenRead
        test eax, eax
        jne near .7
        mov ecx, 0Bh
        mov ebx, 1
        lea edx, [dword esp+080h]
        mov eax, dword [dword esp+094h]
        call FileReadAt
        mov ecx, 0Dh
        mov ebx, 0FFFFFFFFh
        lea edx, [byte esp+070h]
        mov eax, dword [dword esp+094h]
        call FileReadAt
        mov edx, dword [dword esp+0B4h]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        add eax, eax
        add eax, dword [dword esp+0ACh]
        lea edx, [dword esp+080h]
        call stricmp_
        test eax, eax
        jne short .5
        lea edx, [byte esp+070h]
        mov eax, esi
        call stricmp_
        test eax, eax
        je near .7
.5:
        lea ebx, [byte esp+070h]
        lea edx, [dword esp+080h]
        mov eax, esp
        call FmtFromLeague
        mov eax, esp
        mov dword [msg_WrongDisk_arg], eax
        lea eax, [dword esp+09Ch]
        push eax
        lea eax, [dword esp+0A4h]
        push eax
        lea eax, [dword esp+0ACh]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [dword esp+0A0h]
        push eax
        lea eax, [dword esp+0A8h]
        push eax
        push byte 2
        push btn_WrongDisk
        mov ecx, 3
        mov ebx, msg_WrongDisk
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov dword [dword esp+0A4h], eax
        cmp eax, byte 1
        je short .6
        test eax, eax
        jge short .7
.6:
        mov dword [dword esp+0B0h], 1
.7:
        lea eax, [dword esp+094h]
        call FileClose
.8:
        cmp dword [dword esp+0B0h], byte 0
        je short .9
        test ebp, ebp
        je near CopyHumanTeamDBs.3
.9:
        call ClearInputQueue
        test ebp, ebp
        jne short .10
        push ebp
        push byte 0FFFFFFFFh
        mov edi, dword [dword esp+0B4h]
        push edi
        mov ecx, dword [dword esp+0C0h]
        mov ebx, str_extxx
        mov edx, str_extDB
        mov eax, esi
        call ExportTeamToFloppy
        mov ebx, eax
        jmp near .17
.10:
        mov ebx, 0FFFFFFFFh
        jmp near .17
.11:
        mov edx, dword [dword esp+0B4h]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        add eax, eax
        add eax, dword [dword esp+0ACh]
        call MsgCopyingDatabases
        xor edi, edi
        jmp short .13
.12:
        mov edx, esi
        lea eax, [byte esp+060h]
        call strcpy_
        mov edx, dword [nosplit edi*4+leaguedbnames]
        lea eax, [byte esp+040h]
        call strcpy_
        mov edx, str_extxx
        lea eax, [dword esp+08Ch]
        call strcpy_
        lea ebx, [dword esp+08Dh]
        lea edx, [byte esp+040h]
        lea eax, [byte esp+060h]
        call DeleteFiles
        push esi
        mov eax, dword [nosplit edi*4+leaguedbnames]
        mov ecx, esi
        mov ebx, str_extxx
        mov edx, str_extDB
        call CopyFile
        mov ebx, eax
        inc edi
.13:
        cmp edi, byte 7
        jge short .14
        test ebx, ebx
        je short CopyHumanTeamDBs.12
.14:
        test ebx, ebx
        jne short .15
        mov ecx, str_extDB
        mov ebx, str_PINFO
        mov edx, esi
        lea eax, [byte esp+040h]
        call MakePath
        lea edx, [dword esp+098h]
        lea eax, [byte esp+040h]
        call FileOpenRW
        mov ebx, eax
.15:
        test ebx, ebx
        jne short .16
        mov edx, dword [dword esp+0B4h]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        add eax, eax
        mov edx, dword [dword esp+0ACh]
        add edx, eax
        mov byte [byte edx+016h], 1
        mov ebx, dword [dword esp+0B4h]
        mov eax, dword [dword esp+098h]
        call WriteLeagueTeamEntry
        mov ebx, eax
.16:
        lea eax, [dword esp+098h]
        call FileClose
        call RestoreDialogBg
.17:
        inc dword [dword esp+0B4h]
.18:
        mov edi, dword [dword esp+0B4h]
        cmp edi, byte 1Ah
        jge short .19
        test ebx, ebx
        je near CopyHumanTeamDBs.1
.19:
        test ebx, ebx
        jne short .20
        mov ecx, str_extDB
        mov ebx, str_PINFO
        mov edx, esi
        lea eax, [byte esp+040h]
        call MakePath
        lea edx, [dword esp+098h]
        lea eax, [byte esp+040h]
        call FileOpenRW
        mov ebx, eax
.20:
        test ebx, ebx
        jne short .21
        xor edx, edx
        mov dword [dword esp+0B8h], edx
        mov ecx, 2
        mov ebx, 13h
        lea edx, [dword esp+0B8h]
        mov eax, dword [dword esp+098h]
        call FileWriteAt
        mov ebx, eax
.21:
        lea eax, [dword esp+098h]
        call FileClose
        mov eax, ebx
        add esp, 0BCh
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
;-----------------------------------------------------------------------------
; SaveLeagueGameRef                            41978  95 PC, medium confidence
; Demo_savegame 85CC2: writes the league state (DDD34-DDD59) to the
; saved-game file, then marks PINFO.DB of each league in the game
; (savleague1, savleague2 when two) with saved flag -1 and name 'saved'
;-----------------------------------------------------------------------------
; C: src/front/league_teams/SaveLeagueGameRef.c
%ifdef CBUILD
%include "c/front/league_teams/SaveLeagueGameRef.inc"
%else
SaveLeagueGameRef:
        push dword 50h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 38h
        mov esi, eax
        mov edx, 0FFFFFFFFh
        mov dword [byte esp+030h], edx
        mov ecx, 4
        mov ebx, edx
        mov edx, lgplayteam
        call FileWriteAt
        mov edx, eax
        test eax, eax
        jne short .1
        mov ecx, 4
        mov ebx, 0FFFFFFFFh
        mov edx, dword_DDD34
        mov eax, esi
        call FileWriteAt
        mov edx, eax
.1:
        test edx, edx
        jne short .2
        mov ecx, 4
        mov ebx, 0FFFFFFFFh
        mov edx, dword_DDD3C
        mov eax, esi
        call FileWriteAt
        mov edx, eax
.2:
        test edx, edx
        jne short .3
        mov ecx, 4
        mov ebx, 0FFFFFFFFh
        mov edx, word_DDD48
        mov eax, esi
        call FileWriteAt
        mov edx, eax
.3:
        test edx, edx
        jne short .4
        mov ecx, 4
        mov ebx, 0FFFFFFFFh
        mov edx, word_DDD4A
        mov eax, esi
        call FileWriteAt
        mov edx, eax
.4:
        test edx, edx
        jne short .5
        mov ecx, 4
        mov ebx, 0FFFFFFFFh
        mov edx, lggameidx
        mov eax, esi
        call FileWriteAt
        mov edx, eax
.5:
        test edx, edx
        jne short .6
        mov ecx, 0Dh
        mov ebx, 0FFFFFFFFh
        mov edx, savleague1
        mov eax, esi
        call FileWriteAt
        mov edx, eax
.6:
        test edx, edx
        jne short .7
        mov ecx, 0Dh
        mov ebx, 0FFFFFFFFh
        mov edx, savleague2
        mov eax, esi
        call FileWriteAt
        mov edx, eax
.7:
        test edx, edx
        jne short .8
        mov ecx, 6
        mov ebx, 0FFFFFFFFh
        mov edx, lgschedrec
        mov eax, esi
        call FileWriteAt
        mov edx, eax
.8:
        mov dword [byte esp+034h], 0FFFFFFFFh
        lea edi, [byte esp+020h]
        mov esi, str_saved
        movsd
        movsw
        test edx, edx
        jne short .9
        mov ecx, str_extDB
        mov ebx, str_PINFO
        mov edx, savleague1
        mov eax, esp
        call MakePath
        lea edx, [byte esp+030h]
        mov eax, esp
        call FileOpenWrite
        mov edx, eax
.9:
        test edx, edx
        jne short .10
        mov ecx, 2
        mov ebx, 4
        lea edx, [byte esp+034h]
        mov eax, dword [byte esp+030h]
        call FileWriteAt
        mov edx, eax
.10:
        test edx, edx
        jne short .11
        mov ecx, 0Dh
        mov ebx, 6
        lea edx, [byte esp+020h]
        mov eax, dword [byte esp+030h]
        call FileWriteAt
        mov edx, eax
.11:
        lea eax, [byte esp+030h]
        call FileClose
        cmp dword [dword_DDD3C], byte 0
        je short .x
        test edx, edx
        jne short .12
        mov ecx, str_extDB
        mov ebx, str_PINFO
        mov edx, savleague2
        mov eax, esp
        call MakePath
        lea edx, [byte esp+030h]
        mov eax, esp
        call FileOpenWrite
        mov edx, eax
.12:
        test edx, edx
        jne short .13
        mov ecx, 2
        mov ebx, 4
        lea edx, [byte esp+034h]
        mov eax, dword [byte esp+030h]
        call FileWriteAt
        mov edx, eax
.13:
        test edx, edx
        jne short .14
        mov ecx, 0Dh
        mov ebx, 6
        lea edx, [byte esp+020h]
        mov eax, dword [byte esp+030h]
        call FileWriteAt
.14:
        lea eax, [byte esp+030h]
        call FileClose
.x:
        add esp, byte 38h
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
