; League Manager. Merging, importing, and exporting team and schedule files, including a floppy disk.
bits 32
%include "hockey.inc"
section s_3A9AA progbits alloc exec nowrite align=1
extern __CHK, _fstrcspn_, AskMasterPassword, AskTeamPassword, MergeResult, ClearScreen, CopyFile, CopyHumanTeamDBs
extern curleague, DeleteFiles, dlgsavebuf, FileClose, FileExists, FileOpenRead, FileOpenRW, FileReadAt
extern FileWriteAt, GetLeagueId, humancount, LeagueCheckAlwaysZero, leaguedbnames, leagueflags, leaguemaster, leaguesaved
extern leagueteams, lgplayeridfile, lgteam_17, lgteamflags, lgteamver, MakePath, masterctlmsg, masteronlymsg
extern masterpw, mergeerrmsg, MergeGoalieRecDelta, mergeincompletemsg, MergeSeasonRecDelta, mergestatemsg, MergeTeamRecDelta, mergingmsg
extern MessageBox, MouseRead, msg_SavedGame, msg_SavedGame_arg, oldcopymsg, ReadGoalieSeasonRec, ReadKeyRec, ReadLeagueInfo
extern ReadSchedGame, ReadSeasonRec, ReadTeamRec, RestoreDialogBg, savedname, SetDialogColors, sprintf_, str_02d2
extern str_dot, str_extDB, str_extID, str_extxx, str_floppydrv, str_GAME2, str_HasNotBeenMerged, str_IsAlreadyMerged
extern str_PINFO, str_PLAYER, str_SAV2, str_Xx, strcpy_, updateerrmsg, UpdateSeasonSchedule, updschedmsg
extern VgaSetPalette, WaitLeagueFloppy, WriteGoalieSeasonRec, WriteLeagueTeamEntry, WriteSchedGame, WriteSeasonRec, WriteTeamRec
global MergeTeamDbs, MergeTeamDbs_ret, MergeScheduleDb, LocateTeamDbCopy, UpdateTeamDbs, UpdateTeamDbs_ret, MergeLeagueFiles, MergeUpdateDbs
global RebuildLeagueDbs
;-----------------------------------------------------------------------------
; MergeTeamDbs                                 3A9AA  95 PC, medium confidence
; Per human team: opens the 7 league DBs as old (.xx snapshot), new (floppy
; copy) and master, and adds the deltas into master: team records
;
; (MergeTeamRecDelta), skater and goalie SEASON records (MergeSeasonRecDelta /
; MergeGoalieRecDelta, picked by the KEY position 'G')
;-----------------------------------------------------------------------------
; C: src/pc/database_merge/MergeTeamDbs.c
%ifdef CBUILD
%include "c/pc/database_merge/MergeTeamDbs.inc"
%else
MergeTeamDbs:
        push dword 0A7Ch
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, 0A68h
        mov esi, eax
        mov dword [dword esp+0A64h], edx
        mov ebp, ebx
        mov dword [dword esp+0A60h], ecx
        mov edi, dword [dword esp+0A7Ch]
        mov edx, 0FFFFFFFFh
        mov dword [dword esp+0A5Ch], edx
        mov dword [dword esp+0A58h], edx
        mov dword [dword esp+0A54h], edx
        mov dword [dword esp+0A50h], edx
        mov dword [dword esp+0A4Ch], edx
        mov dword [dword esp+0A48h], edx
        mov dword [dword esp+0A44h], edx
        mov ebx, dword [leaguedbnames+10h]
        mov ecx, str_extDB
        mov edx, eax
        lea eax, [dword esp+0A24h]
        call MakePath
        lea edx, [dword esp+0A54h]
        lea eax, [dword esp+0A24h]
        call FileOpenRead
        mov edx, eax
        test eax, eax
        jne short .1
        mov ebx, dword [leaguedbnames+10h]
        mov ecx, dword [dword esp+0A60h]
        mov edx, dword [dword esp+0A64h]
        lea eax, [dword esp+0A24h]
        call MakePath
        lea edx, [dword esp+0A5Ch]
        lea eax, [dword esp+0A24h]
        call FileOpenRead
        mov edx, eax
.1:
        test edx, edx
        jne short .2
        mov ebx, dword [leaguedbnames+10h]
        mov ecx, dword [dword esp+0A78h]
        mov edx, ebp
        lea eax, [dword esp+0A24h]
        call MakePath
        lea edx, [dword esp+0A58h]
        lea eax, [dword esp+0A24h]
        call FileOpenRW
        mov edx, eax
.2:
        test edx, edx
        jne short .3
        mov ebx, dword [leaguedbnames]
        mov ecx, str_extDB
        mov edx, esi
        lea eax, [dword esp+0A24h]
        call MakePath
        lea edx, [dword esp+0A50h]
        lea eax, [dword esp+0A24h]
        call FileOpenRead
        mov edx, eax
.3:
        test edx, edx
        jne short .4
        mov ebx, dword [leaguedbnames+14h]
        mov ecx, str_extDB
        mov edx, esi
        lea eax, [dword esp+0A24h]
        call MakePath
        lea edx, [dword esp+0A44h]
        lea eax, [dword esp+0A24h]
        call FileOpenRead
        mov edx, eax
.4:
        test edx, edx
        jne short .5
        mov ebx, dword [leaguedbnames+14h]
        mov ecx, dword [dword esp+0A60h]
        mov edx, dword [dword esp+0A64h]
        lea eax, [dword esp+0A24h]
        call MakePath
        lea edx, [dword esp+0A4Ch]
        lea eax, [dword esp+0A24h]
        call FileOpenRead
        mov edx, eax
.5:
        test edx, edx
        jne short .6
        mov ebx, dword [leaguedbnames+14h]
        mov ecx, dword [dword esp+0A78h]
        mov edx, ebp
        lea eax, [dword esp+0A24h]
        call MakePath
        lea edx, [dword esp+0A48h]
        lea eax, [dword esp+0A24h]
        call FileOpenRW
        mov edx, eax
.6:
        xor ebp, ebp
.7:
        test edx, edx
        jne short .8
        mov ebx, ebp
        lea edx, [dword esp+02E8h]
        mov eax, dword [dword esp+0A54h]
        call ReadTeamRec
        mov edx, eax
.8:
        test edx, edx
        jne short .9
        mov ebx, ebp
        mov edx, esp
        mov eax, dword [dword esp+0A5Ch]
        call ReadTeamRec
        mov edx, eax
.9:
        test edx, edx
        jne short .10
        mov ebx, ebp
        lea edx, [dword esp+05D0h]
        mov eax, dword [dword esp+0A58h]
        call ReadTeamRec
        mov edx, eax
.10:
        test edx, edx
        jne short .11
        push ebp
        mov ecx, edi
        lea ebx, [dword esp+05D4h]
        lea edx, [byte esp+04h]
        lea eax, [dword esp+02ECh]
        call MergeTeamRecDelta
        mov ebx, ebp
        lea edx, [dword esp+05D0h]
        mov eax, dword [dword esp+0A58h]
        call WriteTeamRec
        mov edx, eax
.11:
        test edx, edx
        jne near .25
        xor esi, esi
        jmp near .17
.12:
        mov eax, dword [byte esp+esi*4+04Ch]
        cmp eax, byte 0FFFFFFFFh
        je near .16
        mov ebx, eax
        lea edx, [dword esp+0960h]
        mov eax, dword [dword esp+0A50h]
        call ReadKeyRec
        mov edx, eax
        test eax, eax
        jne short .13
        mov ebx, dword [dword esp+098Ch]
        lea edx, [dword esp+0994h]
        mov eax, dword [dword esp+0A44h]
        call ReadSeasonRec
        mov edx, eax
.13:
        test edx, edx
        jne short .14
        mov ebx, dword [dword esp+098Ch]
        lea edx, [dword esp+09C4h]
        mov eax, dword [dword esp+0A4Ch]
        call ReadSeasonRec
        mov edx, eax
.14:
        test edx, edx
        jne short .15
        mov ebx, dword [dword esp+098Ch]
        lea edx, [dword esp+09F4h]
        mov eax, dword [dword esp+0A48h]
        call ReadSeasonRec
        mov edx, eax
.15:
        test edx, edx
        jne short .16
        push ebp
        mov ecx, edi
        lea ebx, [dword esp+09F8h]
        lea edx, [dword esp+09C8h]
        lea eax, [dword esp+0998h]
        call MergeSeasonRecDelta
        mov ebx, dword [dword esp+098Ch]
        lea edx, [dword esp+09F4h]
        mov eax, dword [dword esp+0A48h]
        call WriteSeasonRec
        mov edx, eax
.16:
        inc esi
.17:
        cmp esi, byte 19h
        jge short .18
        test edx, edx
        je near MergeTeamDbs.12
.18:
        xor esi, esi
        jmp near .24
.19:
        mov eax, dword [dword esp+esi*4+0B0h]
        cmp eax, byte 0FFFFFFFFh
        je near .23
        mov ebx, eax
        lea edx, [dword esp+0960h]
        mov eax, dword [dword esp+0A50h]
        call ReadKeyRec
        mov edx, eax
        test eax, eax
        jne short .20
        mov ebx, dword [dword esp+098Ch]
        lea edx, [dword esp+0928h]
        mov eax, dword [dword esp+0A44h]
        call ReadGoalieSeasonRec
        mov edx, eax
.20:
        test edx, edx
        jne short .21
        mov ebx, dword [dword esp+098Ch]
        lea edx, [dword esp+08B8h]
        mov eax, dword [dword esp+0A4Ch]
        call ReadGoalieSeasonRec
        mov edx, eax
.21:
        test edx, edx
        jne short .22
        mov ebx, dword [dword esp+098Ch]
        lea edx, [dword esp+08F0h]
        mov eax, dword [dword esp+0A48h]
        call ReadGoalieSeasonRec
        mov edx, eax
.22:
        test edx, edx
        jne short .23
        push ebp
        mov ecx, edi
        lea ebx, [dword esp+08F4h]
        lea edx, [dword esp+08BCh]
        lea eax, [dword esp+092Ch]
        call MergeGoalieRecDelta
        mov ebx, dword [dword esp+098Ch]
        lea edx, [dword esp+08F0h]
        mov eax, dword [dword esp+0A48h]
        call WriteGoalieSeasonRec
        mov edx, eax
.23:
        inc esi
.24:
        cmp esi, byte 3
        jge short .25
        test edx, edx
        je near MergeTeamDbs.19
.25:
        inc ebp
        cmp ebp, byte 1Ah
        jl near MergeTeamDbs.7
        lea eax, [dword esp+0A48h]
        call FileClose
        lea eax, [dword esp+0A4Ch]
        call FileClose
        lea eax, [dword esp+0A44h]
        call FileClose
        lea eax, [dword esp+0A50h]
        call FileClose
        lea eax, [dword esp+0A58h]
        call FileClose
        lea eax, [dword esp+0A5Ch]
        call FileClose
        lea eax, [dword esp+0A54h]
        call FileClose
        mov eax, edx
        add esp, 0A68h
MergeTeamDbs_ret:
        pop ebp
        pop edi
        pop esi
        ret 8
%endif ; C
;-----------------------------------------------------------------------------
; MergeScheduleDb                              3AE1E  95 PC, medium confidence
; "Updating schedule.": copies the team's played SCHEDULE games from the
; floppy copy into the master schedule
;-----------------------------------------------------------------------------
; C: src/pc/database_merge/MergeTeamDbs.c (MergeScheduleDb)
%ifdef CBUILD
%include "c/pc/database_merge/MergeTeamDbs.MergeScheduleDb.inc"
%else
MergeScheduleDb:
        push dword 48h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 38h
        mov edi, edx
        mov ebp, ecx
        mov esi, dword [byte esp+048h]
        mov edx, 0FFFFFFFFh
        mov dword [byte esp+02Ch], edx
        mov dword [byte esp+028h], edx
        mov edx, dword [leaguedbnames+18h]
        mov ecx, ebx
        mov ebx, edx
        mov edx, eax
        mov eax, esp
        call MakePath
        lea edx, [byte esp+028h]
        mov eax, esp
        call FileOpenRead
        mov edx, eax
        test eax, eax
        jne short .1
        mov ebx, dword [leaguedbnames+18h]
        mov ecx, ebp
        mov edx, edi
        mov eax, esp
        call MakePath
        lea edx, [byte esp+02Ch]
        mov eax, esp
        call FileOpenRW
        mov edx, eax
.1:
        test edx, edx
        jne short .2
        mov ecx, 2
        xor ebx, ebx
        lea edx, [byte esp+030h]
        mov eax, dword [byte esp+028h]
        call FileReadAt
        mov edx, eax
.2:
        test edx, edx
        jne short .3
        mov ecx, 2
        xor ebx, ebx
        lea edx, [byte esp+034h]
        mov eax, dword [byte esp+02Ch]
        call FileReadAt
        mov edx, eax
.3:
        test edx, edx
        jne short .4
        mov eax, dword [byte esp+032h]
        sar eax, 10h
        mov ebx, dword [byte esp+04Ch]
        mov dword [ebx], eax
        mov eax, dword [byte esp+030h]
        cmp ax, word [byte esp+034h]
        jle short .4
        mov eax, dword [byte esp+02Eh]
        sar eax, 10h
        mov edx, dword [byte esp+04Ch]
        mov dword [edx], eax
        mov ecx, 2
        xor ebx, ebx
        lea edx, [byte esp+030h]
        mov eax, dword [byte esp+02Ch]
        call FileWriteAt
        mov edx, eax
.4:
        cmp word [byte esp+030h], 444h
        jl short .5
        mov word [byte esp+030h], 4ADh
.5:
        xor ecx, ecx
        jmp short .9
.6:
        mov ebx, ecx
        lea edx, [byte esp+020h]
        mov eax, dword [byte esp+028h]
        call ReadSchedGame
        mov edx, eax
        test eax, eax
        jne short .8
        mov al, byte [byte esp+022h]
        cmp esi, eax
        je short .7
        xor eax, eax
        mov al, byte [byte esp+023h]
        cmp esi, eax
        jne short .8
.7:
        mov ebx, ecx
        lea edx, [byte esp+020h]
        mov eax, dword [byte esp+02Ch]
        call WriteSchedGame
        mov edx, eax
.8:
        inc ecx
.9:
        mov eax, dword [byte esp+02Eh]
        sar eax, 10h
        cmp ecx, eax
        jge short .10
        test edx, edx
        je short MergeScheduleDb.6
.10:
        lea eax, [byte esp+02Ch]
        call FileClose
        lea eax, [byte esp+028h]
        call FileClose
        mov eax, edx
        add esp, byte 38h
        jmp near MergeTeamDbs_ret
%endif ; C
;-----------------------------------------------------------------------------
; LocateTeamDbCopy                             3AF70  95 PC, medium confidence
; (teams, team, ...): local teams use the league dir and their entry stamp;
; floppy teams prompt for their disk (WaitLeagueFloppy), read its stamp
;
; (GetLeagueId) and warn "That floppy disk has an old copy of the league"
;-----------------------------------------------------------------------------
; C: src/pc/database_merge/LocateTeamDbCopy.c
%ifdef CBUILD
%include "c/pc/database_merge/LocateTeamDbCopy.inc"
%else
LocateTeamDbCopy:
        push dword 34h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        mov esi, ebx
        mov dword [byte esp+0Ch], ecx
        mov edi, dword [byte esp+024h]
        mov ebp, dword [byte esp+028h]
        xor ebx, ebx
        mov ecx, edx
        shl ecx, 4
        sub ecx, edx
        add ecx, ecx
        add ecx, eax
        cmp byte [byte ecx+018h], 1
        je short .1
        cmp byte [byte ecx+016h], 1
        jne short .2
.1:
        mov ecx, dword [byte esp+0Ch]
        mov dword [edi], ecx
        mov ecx, edx
        shl ecx, 4
        sub ecx, edx
        mov eax, dword [byte eax+ecx*2+01Ah]
        mov dword [byte ebp+00h], eax
        jmp short .3
.2:
        mov eax, dword [byte esp+020h]
        mov dword [edi], eax
        mov edx, ecx
        mov eax, esi
        call WaitLeagueFloppy
        mov edi, eax
        mov ebx, eax
        mov edx, ebp
        mov eax, dword [byte esp+020h]
        call GetLeagueId
        cmp edi, byte 4
        je short .3
        mov eax, dword [byte ebp+00h]
        cmp eax, dword [byte ecx+01Ah]
        jae short .3
        mov dword [oldcopymsg+8], esi
        mov eax, esp
        push eax
        lea eax, [byte esp+08h]
        push eax
        lea eax, [byte esp+010h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [byte esp+04h]
        push eax
        lea eax, [byte esp+0Ch]
        push eax
        push byte 0
        push byte 0
        mov ecx, 3
        mov ebx, oldcopymsg
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov ebx, 0FFFFFFFFh
.3:
        mov eax, ebx
        add esp, byte 10h
        pop ebp
        pop edi
        pop esi
        ret 0Ch
%endif ; C
;-----------------------------------------------------------------------------
; UpdateTeamDbs                                                   3B039  95 PC
; MenuUpdateTeamDbs / PlayLeagueGame: "The league X has not been merged."
; unless merged, then CopyHumanTeamDBs; "Error
;
; while updating players databases!"
;-----------------------------------------------------------------------------
; C: src/pc/database_merge/UpdateTeamDbs.c
%ifdef CBUILD
%include "c/pc/database_merge/UpdateTeamDbs.inc"
%else
UpdateTeamDbs:
        push dword 74h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 44h
        mov dword [byte esp+030h], 0FFFFFFFFh
        xor ebp, ebp
        push ebp
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
        mov edx, 2
        mov eax, curleague
        call LeagueCheckAlwaysZero
        test eax, eax
        jne near .6
        push savedname
        push leaguesaved
        push leagueflags
        push humancount
        mov ecx, leaguemaster
        mov ebx, masterpw
        mov edx, leagueteams
        mov eax, curleague
        call ReadLeagueInfo
        mov edi, eax
        mov esi, eax
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
        test edi, edi
        jne short .1
        cmp dword [leaguesaved], byte 0
        je short .1
        lea eax, [byte esp+020h]
        mov dword [msg_SavedGame_arg], eax
        lea eax, [byte esp+034h]
        push eax
        lea eax, [byte esp+03Ch]
        push eax
        lea eax, [byte esp+044h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [byte esp+038h]
        push eax
        lea eax, [byte esp+040h]
        push eax
        push edi
        push edi
        mov ecx, 3
        mov ebx, msg_SavedGame
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov ebp, 0FFFFFFFFh
.1:
        test ebp, ebp
        jne near .6
        test esi, esi
        jne short .2
        mov ecx, str_extDB
        mov ebx, str_PINFO
        mov edx, curleague
        mov eax, esp
        call MakePath
        lea edx, [byte esp+030h]
        mov eax, esp
        call FileOpenRW
        mov esi, eax
.2:
        test esi, esi
        jne short .3
        mov ecx, 2
        mov ebx, 13h
        lea edx, [byte esp+040h]
        mov eax, dword [byte esp+030h]
        call FileReadAt
        mov esi, eax
.3:
        lea eax, [byte esp+030h]
        call FileClose
        test esi, esi
        jne short .5
        test byte [byte esp+040h], 4
        je short .4
        mov ebx, 0FFFFFFFFh
        mov edx, leagueteams
        mov eax, curleague
        call CopyHumanTeamDBs
        mov esi, eax
        jmp short .5
.4:
        lea eax, [byte esp+020h]
        mov dword [mergestatemsg+4], eax
        mov dword [mergestatemsg+8], str_HasNotBeenMerged
        lea eax, [byte esp+034h]
        push eax
        lea eax, [byte esp+03Ch]
        push eax
        lea eax, [byte esp+044h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [byte esp+038h]
        push eax
        lea eax, [byte esp+040h]
        push eax
        push esi
        push esi
        mov ecx, 3
        mov ebx, mergestatemsg
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
.5:
        test esi, esi
        je short .6
        lea eax, [byte esp+034h]
        push eax
        lea eax, [byte esp+03Ch]
        push eax
        lea eax, [byte esp+044h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [byte esp+038h]
        push eax
        lea eax, [byte esp+040h]
        push eax
        push byte 0
        push byte 0
        mov ecx, 2
        mov ebx, updateerrmsg
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
.6:
        push byte 0
        mov ecx, 3Fh
        mov ebx, 17h
        mov edx, ecx
        mov eax, 2Ah
        call SetDialogColors
        add esp, byte 44h
        pop ebp
UpdateTeamDbs_ret:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; MergeLeagueFiles                                                3B25A  95 PC
; MenuMergeLeagueFiles / PlayLeagueGame / TradePlayers: master copy only ("The
; databases can only be merged on the master copy of the league"),
;
; "Merging players to master database." (MergeTeamDbs), "Updating schedule."
; (MergeScheduleDb), marks the team entry merged (flags |= 4, stamp),
; "Warning! Merge not completed!"
;-----------------------------------------------------------------------------
; C: src/pc/database_merge/UpdateTeamDbs.c (MergeLeagueFiles)
%ifdef CBUILD
%include "c/pc/database_merge/UpdateTeamDbs.MergeLeagueFiles.inc"
%else
MergeLeagueFiles:
        push dword 8Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 60h
        mov edx, 0FFFFFFFFh
        mov dword [byte esp+044h], edx
        mov dword [byte esp+058h], edx
        mov dword [byte esp+03Ch], edx
        push byte 0
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
        mov edx, 2
        mov eax, curleague
        call LeagueCheckAlwaysZero
        xor dl, dl
        mov byte [MergeResult], dl
        test eax, eax
        jne near .27
        push savedname
        push leaguesaved
        push leagueflags
        push humancount
        mov ecx, leaguemaster
        mov ebx, masterpw
        mov edx, leagueteams
        mov eax, curleague
        call ReadLeagueInfo
        mov edi, eax
        mov esi, eax
        mov ecx, str_extID
        mov ebx, str_PLAYER
        mov edx, curleague
        mov eax, esp
        call MakePath
        mov eax, esp
        call FileExists
        mov dword [lgplayeridfile], eax
        test edi, edi
        jne near .27
        mov edx, curleague
        lea eax, [byte esp+020h]
        call strcpy_
        mov ecx, ds
        mov ebx, str_dot
        mov edx, ds
        lea eax, [byte esp+020h]
        call _fstrcspn_
        xor dh, dh
        mov byte [byte esp+eax+020h], dh
        cmp dword [leaguesaved], byte 0
        je short .1
        lea eax, [byte esp+020h]
        mov dword [msg_SavedGame_arg], eax
        lea eax, [byte esp+048h]
        push eax
        lea eax, [byte esp+050h]
        push eax
        lea eax, [byte esp+058h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [byte esp+04Ch]
        push eax
        lea eax, [byte esp+054h]
        push eax
        push edi
        push edi
        mov ecx, 3
        mov ebx, msg_SavedGame
        jmp near .26
.1:
        mov edx, dword [leaguemaster]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        cmp byte [nosplit eax*2+lgteamflags], 2
        jne short .2
        lea eax, [byte esp+020h]
        mov dword [masterctlmsg+4], eax
        lea eax, [byte esp+048h]
        push eax
        lea eax, [byte esp+050h]
        push eax
        lea eax, [byte esp+058h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [byte esp+04Ch]
        push eax
        lea eax, [byte esp+054h]
        push eax
        push edi
        push edi
        mov ecx, 3
        mov ebx, masterctlmsg
        jmp near .26
.2:
        cmp dword [lgplayeridfile], byte 0
        je short .3
        lea eax, [byte esp+020h]
        mov dword [masteronlymsg+8], eax
        lea eax, [byte esp+048h]
        push eax
        lea eax, [byte esp+050h]
        push eax
        lea eax, [byte esp+058h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [byte esp+04Ch]
        push eax
        lea eax, [byte esp+054h]
        push eax
        push edi
        push edi
        mov ecx, 3
        mov ebx, masteronlymsg
        jmp near .26
.3:
        test byte [leagueflags], 4
        jne near .25
        test edi, edi
        jne short .4
        mov ecx, str_extDB
        mov ebx, str_PINFO
        mov edx, curleague
        mov eax, esp
        call MakePath
        lea edx, [byte esp+044h]
        mov eax, esp
        call FileOpenRW
        mov esi, eax
.4:
        test esi, esi
        jne short .5
        mov ebx, dword [leaguemaster]
        push ebx
        push str_02d2
        lea eax, [byte esp+040h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea edx, [byte esp+038h]
        mov eax, str_Xx
        call strcpy_
        lea eax, [byte esp+030h]
        push eax
        lea eax, [byte esp+044h]
        push eax
        push str_floppydrv
        mov edx, dword [leaguemaster]
        mov ecx, curleague
        mov ebx, ecx
        mov eax, leagueteams
        call LocateTeamDbCopy
        mov esi, eax
.5:
        test esi, esi
        jne short .6
        push esi
        push esi
        push esi
        push esi
        push esi
        mov ecx, 1
        mov ebx, mergingmsg
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
.6:
        xor ecx, ecx
        mov dword [byte esp+054h], ecx
        jmp near .15
.7:
        mov eax, edi
        shl eax, 4
        sub eax, edi
        add eax, eax
        cmp byte [dword eax+lgteam_17], 1
        jne near .14
        test byte [dword eax+lgteamflags], 4
        jne near .14
        push edi
        push str_02d2
        lea eax, [byte esp+040h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea edx, [byte esp+038h]
        mov eax, str_extxx
        call strcpy_
        lea eax, [byte esp+030h]
        push eax
        lea eax, [byte esp+038h]
        push eax
        push str_floppydrv
        mov ecx, curleague
        mov ebx, ecx
        mov edx, dword [byte esp+060h]
        mov eax, leagueteams
        call LocateTeamDbCopy
        mov esi, eax
        test eax, eax
        jne short .9
        cmp dword [dlgsavebuf], byte 0
        jne short .8
        push eax
        push eax
        push eax
        push eax
        push eax
        mov ecx, 1
        mov ebx, mergingmsg
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
.8:
        mov ecx, str_extDB
        mov ebx, str_PINFO
        mov edx, dword [byte esp+034h]
        mov eax, esp
        call MakePath
        lea edx, [byte esp+058h]
        mov eax, esp
        call FileOpenRW
        mov esi, eax
.9:
        test esi, esi
        jne short .10
        mov eax, dword [byte esp+054h]
        cmp eax, dword [leaguemaster]
        je short .10
        push eax
        push str_Xx
        mov ecx, str_extxx
        mov ebx, dword [byte esp+048h]
        mov edx, dword [byte esp+03Ch]
        mov eax, curleague
        call MergeTeamDbs
        mov esi, eax
        test eax, eax
        jne short .10
        lea eax, [byte esp+05Ch]
        push eax
        mov eax, dword [byte esp+058h]
        push eax
        mov ecx, str_Xx
        mov ebx, str_extxx
        mov edx, curleague
        mov eax, dword [byte esp+03Ch]
        call MergeScheduleDb
        mov esi, eax
.10:
        test esi, esi
        jne short .11
        mov esi, dword [byte esp+054h]
        shl esi, 4
        sub esi, dword [byte esp+054h]
        add esi, esi
        mov eax, dword [byte esp+030h]
        mov dword [dword esi+lgteamver], eax
        or byte [dword esi+lgteamflags], 4
        mov edx, leagueteams
        add edx, esi
        mov ebx, dword [byte esp+054h]
        mov eax, dword [byte esp+044h]
        call WriteLeagueTeamEntry
        mov esi, eax
.11:
        test esi, esi
        jne short .12
        mov eax, dword [byte esp+054h]
        shl eax, 4
        mov ebx, dword [byte esp+054h]
        sub eax, ebx
        add eax, eax
        mov edx, leagueteams
        add edx, eax
        mov eax, dword [byte esp+058h]
        call WriteLeagueTeamEntry
        mov esi, eax
.12:
        test esi, esi
        jne short .13
        cmp dword [byte esp+034h], curleague
        je short .13
        mov dword [leagueflags], 4
        mov ecx, 2
        mov ebx, 13h
        mov edx, leagueflags
        mov eax, dword [byte esp+058h]
        call FileWriteAt
        mov esi, eax
.13:
        lea eax, [byte esp+058h]
        call FileClose
        test esi, esi
        jne short .14
        mov dword [leagueflags], 8
        mov ecx, 2
        mov ebx, 13h
        mov edx, leagueflags
        mov eax, dword [byte esp+044h]
        call FileWriteAt
        mov esi, eax
.14:
        inc dword [byte esp+054h]
.15:
        mov edi, dword [byte esp+054h]
        cmp edi, byte 1Ah
        jge short .16
        test esi, esi
        je near MergeLeagueFiles.7
.16:
        test esi, esi
        jne short .17
        push curleague
        mov eax, dword [leaguedbnames+10h]
        mov ecx, dword [byte esp+044h]
        mov ebx, str_extDB
        mov edx, str_Xx
        call CopyFile
        mov esi, eax
.17:
        test esi, esi
        jne short .18
        push curleague
        mov eax, dword [leaguedbnames+14h]
        mov ecx, dword [byte esp+044h]
        mov ebx, str_extDB
        mov edx, str_Xx
        call CopyFile
        mov esi, eax
.18:
        test esi, esi
        jne short .19
        push curleague
        mov eax, dword [leaguedbnames+18h]
        mov ecx, dword [byte esp+044h]
        mov ebx, str_extDB
        mov edx, str_Xx
        call CopyFile
        mov esi, eax
.19:
        call RestoreDialogBg
        test esi, esi
        jne short .20
        mov ebx, dword [leaguedbnames+18h]
        mov ecx, str_extDB
        mov edx, curleague
        mov eax, esp
        call MakePath
        lea edx, [byte esp+03Ch]
        mov eax, esp
        call FileOpenRead
        mov esi, eax
.20:
        test esi, esi
        jne short .21
        mov ecx, 2
        xor ebx, ebx
        lea edx, [byte esp+05Ch]
        mov eax, dword [byte esp+03Ch]
        call FileReadAt
        mov esi, eax
.21:
        lea eax, [byte esp+03Ch]
        call FileClose
        test esi, esi
        jne short .22
        push esi
        push esi
        push esi
        push esi
        push esi
        mov ecx, 1
        mov ebx, updschedmsg
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        push byte 7
        push byte 0FFFFFFFFh
        mov ebx, dword [byte esp+062h]
        sar ebx, 10h
        mov ecx, leagueteams
        mov edx, str_extDB
        mov eax, curleague
        call UpdateSeasonSchedule
        mov esi, eax
.22:
        test esi, esi
        jne short .23
        mov dword [leagueflags], 4
        mov ecx, 2
        mov ebx, 13h
        mov edx, leagueflags
        mov eax, dword [byte esp+044h]
        call FileWriteAt
        mov esi, eax
.23:
        call RestoreDialogBg
        lea eax, [byte esp+044h]
        call FileClose
        lea eax, [byte esp+048h]
        push eax
        lea eax, [byte esp+050h]
        push eax
        lea eax, [byte esp+05Ch]
        push eax
        call MouseRead
        add esp, byte 0Ch
        cmp esi, byte 4
        jne short .24
        cmp dword [leagueflags], byte 8
        jne near .27
        push byte 0FFFFFFFFh
        lea eax, [byte esp+04Ch]
        push eax
        lea eax, [byte esp+054h]
        push eax
        push byte 0
        push byte 0
        mov ecx, 3
        mov ebx, mergeincompletemsg
        jmp short .26
.24:
        test esi, esi
        je short .27
        push byte 0FFFFFFFFh
        lea eax, [byte esp+04Ch]
        push eax
        lea eax, [byte esp+054h]
        push eax
        push byte 0
        push byte 0
        mov ecx, 1
        mov ebx, mergeerrmsg
        jmp short .26
.25:
        lea eax, [byte esp+020h]
        mov dword [mergestatemsg+4], eax
        mov dword [mergestatemsg+8], str_IsAlreadyMerged
        lea eax, [byte esp+048h]
        push eax
        lea eax, [byte esp+050h]
        push eax
        lea eax, [byte esp+05Ch]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [byte esp+04Ch]
        push eax
        lea eax, [byte esp+054h]
        push eax
        push edi
        push edi
        mov ecx, 3
        mov ebx, mergestatemsg
.26:
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
.27:
        push byte 0
        mov ecx, 3Fh
        mov ebx, 17h
        mov edx, ecx
        mov eax, 2Ah
        call SetDialogColors
        mov eax, dword [MergeResult-3]
        sar eax, 18h
        add esp, byte 60h
        jmp near UpdateTeamDbs_ret
%endif ; C
;-----------------------------------------------------------------------------
; MergeUpdateDbs                                                  3B8B0  95 PC
; MenuMergeUpdateDbs: MergeLeagueFiles then UpdateTeamDbs
;-----------------------------------------------------------------------------
; C: src/pc/database_merge/MergeUpdateDbs.c
%ifdef CBUILD
%include "c/pc/database_merge/MergeUpdateDbs.inc"
%else
MergeUpdateDbs:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        sub esp, byte 4
        call MergeLeagueFiles
        mov edx, eax
        mov esi, eax
        cmp dword [leaguesaved], byte 0
        jne near .2
        mov ebx, dword [leaguemaster]
        mov eax, ebx
        shl eax, 4
        sub eax, ebx
        cmp byte [nosplit eax*2+lgteamflags], 2
        je near .2
        mov ecx, dword [lgplayeridfile]
        test ecx, ecx
        jne near .2
        test edx, edx
        je short .1
        push ecx
        call ClearScreen
        add esp, byte 4
        mov bh, 17h
        mov byte [esp], bh
        mov byte [byte esp+01h], bh
        mov byte [byte esp+02h], bh
        mov eax, esp
        push eax
        push byte 1
        push dword 0F8h
        call VgaSetPalette
        add esp, byte 0Ch
        mov al, 2Ah
        mov byte [esp], al
        mov byte [byte esp+01h], al
        mov byte [byte esp+02h], al
        mov eax, esp
        push eax
        push byte 1
        push dword 0F9h
        call VgaSetPalette
        add esp, byte 0Ch
        mov dh, 3Fh
        mov byte [esp], dh
        mov byte [byte esp+01h], dh
        mov byte [byte esp+02h], dh
        mov eax, esp
        push eax
        push byte 1
        push dword 0FAh
        call VgaSetPalette
        add esp, byte 0Ch
.1:
        call UpdateTeamDbs
        test esi, esi
        je short .2
        push byte 0
        call ClearScreen
        add esp, byte 4
        xor cl, cl
        mov byte [esp], cl
        mov byte [byte esp+01h], cl
        mov byte [byte esp+02h], cl
        mov eax, esp
        push eax
        push byte 1
        push dword 0F8h
        call VgaSetPalette
        add esp, byte 0Ch
        mov eax, esp
        push eax
        push byte 1
        push dword 0F9h
        call VgaSetPalette
        add esp, byte 0Ch
        mov eax, esp
        push eax
        push byte 1
        push dword 0FAh
        call VgaSetPalette
        add esp, byte 0Ch
.2:
        mov eax, esi
        add esp, byte 4
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; RebuildLeagueDbs                                                3B9CA  95 PC
; MenuRebuildDbs: team or master password, deletes GAME*.SAV,
; CopyHumanTeamDBs; "Error while updating players databases!"
;-----------------------------------------------------------------------------
; C: src/pc/database_merge/UpdateTeamDbs.c (RebuildLeagueDbs)
%ifdef CBUILD
%include "c/pc/database_merge/UpdateTeamDbs.RebuildLeagueDbs.inc"
%else
RebuildLeagueDbs:
        push dword 60h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 34h
        mov dword [byte esp+020h], 0FFFFFFFFh
        push byte 0
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
        mov edx, 2
        mov eax, curleague
        call LeagueCheckAlwaysZero
        mov ecx, eax
        test eax, eax
        jne near .5
        push savedname
        push leaguesaved
        push leagueflags
        push humancount
        mov ecx, leaguemaster
        mov ebx, masterpw
        mov edx, leagueteams
        mov eax, curleague
        call ReadLeagueInfo
        mov ecx, eax
        xor esi, esi
        mov dword [byte esp+02Ch], esi
        jmp short .3
.1:
        mov eax, edi
        shl eax, 4
        sub eax, edi
        cmp byte [nosplit eax*2+lgteam_17], 1
        jne short .2
        mov edx, leagueteams
        mov eax, edi
        call AskTeamPassword
        mov esi, eax
.2:
        inc dword [byte esp+02Ch]
.3:
        mov edi, dword [byte esp+02Ch]
        cmp edi, byte 1Ah
        jge short .4
        test esi, esi
        je short RebuildLeagueDbs.1
.4:
        test esi, esi
        jne short .5
        mov eax, dword [leaguemaster]
        mov ebx, masterpw
        mov edx, leagueteams
        call AskMasterPassword
        mov esi, eax
.5:
        test ecx, ecx
        jne near .8
        test esi, esi
        jne near .8
        mov ecx, str_extDB
        mov ebx, str_PINFO
        mov edx, curleague
        mov eax, esp
        call MakePath
        lea edx, [byte esp+020h]
        mov eax, esp
        call FileOpenRW
        mov ecx, eax
        test eax, eax
        jne short .6
        mov ecx, 2
        mov ebx, 13h
        lea edx, [byte esp+030h]
        mov eax, dword [byte esp+020h]
        call FileReadAt
        mov ecx, eax
.6:
        lea eax, [byte esp+020h]
        call FileClose
        test ecx, ecx
        jne short .7
        mov edx, curleague
        mov eax, esp
        call strcpy_
        mov ebx, str_SAV2
        mov edx, str_GAME2
        mov eax, esp
        call DeleteFiles
        mov ebx, 0FFFFFFFFh
        mov edx, leagueteams
        mov eax, curleague
        call CopyHumanTeamDBs
        mov ecx, eax
.7:
        test ecx, ecx
        je short .8
        lea eax, [byte esp+024h]
        push eax
        lea eax, [byte esp+02Ch]
        push eax
        lea eax, [byte esp+034h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [byte esp+028h]
        push eax
        lea eax, [byte esp+030h]
        push eax
        push byte 0
        push byte 0
        mov ecx, 2
        mov ebx, updateerrmsg
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
.8:
        push byte 0
        mov ecx, 3Fh
        mov ebx, 17h
        mov edx, ecx
        mov eax, 2Ah
        call SetDialogColors
        add esp, byte 34h
        jmp near UpdateTeamDbs_ret
%endif ; C
