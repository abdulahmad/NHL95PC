; Playing a league game from the calendar: disk check, team database, the game (PC only).
bits 32
%include "hockey.inc"
section s_35FB9 progbits alloc exec nowrite align=1
extern __CHK, __STOSB, _fstrcspn_, AllocMemBlock, AskTeamPassword, awlinetab, awscore, awtmgoalie
extern awtmlines, btn_MasterDB, btn_MergeNeeded, GameRecordDay, UnusedStateByte, CalendarScreen, cddriveptr, CheckGameDiskSpace
extern ClearScreen, curleague, lgoppteam, lgopphuman, FadePalStep, FileClose, FileExists, fileoncd
extern FileOpenRead, FileOpenRW, FileOpenWrite, FileReadAt, FileWriteAt, FindLeagueFloppy, FindShape, firstteammsg
extern FmtFromLeague, FreeMemBlock, GameGoalieStatsScreen, gameopts, gameresult, GameSkaterStatsScreen, GameStandingsMenu, GameStandingsScreen
extern GameTeamStatsScreen, GetLeagueId, goaliestatscb, hmglstats, hmglstats_w2, hmglstats_w4, hmlinetab, hmplstats
extern hmplstats_w10, hmplstats_w14, hmplstats_w2, hmplstats_w4, hmplstats_w6, hmplstats_w8, hmscore, hmtmgoalie
extern hmtmlines, hmtmstruct, HomeTeam, humancount, InitGameSummary, InputInstall, InputRemove, LeagueCheckStub
extern leaguedbfmt, leaguedbfmt2, leaguedbnames, leaguediskmsg, leagueflags, leaguemaster, leaguesaved, leagueteams
extern LeagueTeamSelect, lggameidx, lgplayteam, lgschedrec, lgschedrec_b1, lgschedrec_b2, lgschedrec_b3, lgschedrec_b4
extern lgschedrec_b5, lgteam_17, lgteamflags, LoadBank, LoadLeagueGameRef, MakePath, masterpw, MergeLeagueFiles
extern MessageBox, MouseRead, msg_DbUpdateError, msg_InsertDisk_arg, msg_MergeNeeded, msg_MergeNeeded_e01, musichandle, musicon
extern musicslot, playerdbsmsg, PlayGame, PreGameScreen, ReadGoalieSeasonRec, ReadGSummaryRec, ReadKeyRec, ReadLeagueInfo
extern ReadLeagueTeamEntry, ReadSchedGame, ReadSeasonRec, ReadTeamNames, ReadTeamRec, RestoreDialogBg, savedname, savleague1
extern savleague2, schedgameidx, SetDialogColors, SetPalette, SetupControllers, SetViewRect, ShowLoadingScreen, skaterstatscb
extern SndQuery, songdata, sprintf_, standingscb, standingsmenucb, starpl, startm, str_02d
extern str_backslash2, str_dot, str_Easndesk2, str_extDB, str_extxx, str_floppydrv, str_GAME, str_GSUMMARY
extern str_MustBeExportedTo, str_MustBeImportedFrom, str_Pal17, str_Pal18, str_PINFO, str_S4, str_SAV, str_SelectATeamTo
extern str_Temp5, str_Xx, strcat_, strcpy_, PushMemDescriptorLocked, SetDigiChannelVolume, teamstatscb, treeteamnames
extern UpdatePlayoffSeries, UpdateSeasonSchedule, UpdateTeamDbs, updschedmsg, VgaSetPalette, VisTeam, WaitLeagueFloppy, lggamecount
extern lgoppgamecount, WriteGoalieSeasonRec, WriteSchedGame, WriteSeasonRec, WriteTeamRec
global CheckLeagueDiskSync, MakeTeamDbFmt, PostGameToTeamDb, PlayLeagueGame
;-----------------------------------------------------------------------------
; CheckLeagueDiskSync                          35FB9  95 PC, medium confidence
; Compares the league id in the floppy PINFO.DB with the local league; on a
; mismatch shows "The league <name> must be imported from / exported to the
; disk for ... before a game can be played!"
;-----------------------------------------------------------------------------
; C: src/front/league_game/CheckLeagueDiskSync.c
%ifdef CBUILD
%include "c/front/league_game/CheckLeagueDiskSync.inc"
%else
CheckLeagueDiskSync:
        push dword 0D8h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, 0B4h
        mov edi, eax
        mov dword [dword esp+0B0h], ebx
        mov dword [dword esp+0ACh], 0FFFFFFFFh
        xor ebp, ebp
        mov esi, dword [dword esp+0B0h]
        shl esi, 4
        sub esi, dword [dword esp+0B0h]
        add esi, esi
        add esi, edx
        mov dword [leaguediskmsg+8], ebp
        lea edx, [dword esp+09Ch]
        mov eax, edi
        call GetLeagueId
        mov dl, byte [byte esi+017h]
        cmp dl, 1
        jne near .8
        cmp eax, dword [dword esp+0B0h]
        je short .1
        test eax, eax
        jge short .2
        cmp dl, byte [byte esi+018h]
        je short .1
        test byte [byte esi+016h], dl
        je short .2
.1:
        test byte [byte esi+016h], 2
        je near .8
        mov dword [leaguediskmsg+8], str_MustBeImportedFrom
        jmp near .7
.2:
        test ecx, ecx
        je near .6
        cmp dword [dword esp+0C4h], byte 0
        je short .3
        mov ebx, edi
        mov edx, esi
        mov eax, esp
        call FmtFromLeague
        mov eax, esp
        mov dword [msg_InsertDisk_arg], eax
        mov ebx, 0FFFFFFFFh
        mov edx, esi
        mov eax, edi
        call FindLeagueFloppy
        jmp short .4
.3:
        mov ebx, 0FFFFFFFFh
        mov edx, esi
        mov eax, edi
        call WaitLeagueFloppy
.4:
        mov ebp, eax
        test ebp, ebp
        jne near .8
        mov ecx, str_extDB
        mov ebx, str_PINFO
        mov edx, str_floppydrv
        lea eax, [byte esp+040h]
        call MakePath
        lea edx, [dword esp+0ACh]
        lea eax, [byte esp+040h]
        call FileOpenRead
        mov ebp, eax
        test eax, eax
        jne short .5
        mov ebx, dword [dword esp+0B0h]
        lea edx, [byte esp+060h]
        mov eax, dword [dword esp+0ACh]
        call ReadLeagueTeamEntry
        mov ebp, eax
.5:
        lea eax, [dword esp+0ACh]
        call FileClose
        test ebp, ebp
        jne short .8
        test byte [byte esp+076h], 1
        je short .8
        mov dword [leaguediskmsg+8], str_MustBeExportedTo
        jmp short .7
.6:
        lea eax, [dword esp+0A0h]
        push eax
        lea eax, [dword esp+0A8h]
        push eax
        lea eax, [dword esp+0B0h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [dword esp+0A4h]
        push eax
        lea eax, [dword esp+0ACh]
        push eax
        push byte 0
        push byte 0
        mov ecx, 2
        mov ebx, firstteammsg
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
.7:
        mov ebp, 4
.8:
        cmp dword [leaguediskmsg+8], byte 0
        je near .9
        mov edx, edi
        lea eax, [dword esp+080h]
        call strcpy_
        mov ecx, ds
        mov ebx, str_dot
        mov edx, ds
        lea eax, [dword esp+080h]
        call _fstrcspn_
        xor ch, ch
        mov byte [dword esp+eax+080h], ch
        lea eax, [dword esp+080h]
        mov dword [leaguediskmsg+4], eax
        mov edx, esi
        lea eax, [dword esp+090h]
        call strcpy_
        lea eax, [dword esp+090h]
        mov dword [leaguediskmsg+0Ch], eax
        lea eax, [dword esp+0A0h]
        push eax
        lea eax, [dword esp+0A8h]
        push eax
        lea eax, [dword esp+0B0h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [dword esp+0A4h]
        push eax
        lea eax, [dword esp+0ACh]
        push eax
        push byte 0
        push byte 0
        mov ecx, 5
        mov ebx, leaguediskmsg
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
.9:
        mov eax, ebp
        add esp, 0B4h
        pop ebp
        pop edi
        pop esi
        ret 4
%endif ; C
;-----------------------------------------------------------------------------
; MakeTeamDbFmt                                36207  95 PC, medium confidence
; (out, dir, teams, team): for a human team builds "dir\%s.NN" (team number
; as .%02d)
;-----------------------------------------------------------------------------
; C: src/front/league_game/MakeTeamDbFmt.c
%ifdef CBUILD
%include "c/front/league_game/MakeTeamDbFmt.inc"
%else
MakeTeamDbFmt:
        push dword 18h
        call __CHK
        push esi
        sub esp, byte 4
        mov esi, eax
        mov eax, ecx
        shl eax, 4
        sub eax, ecx
        cmp byte [byte ebx+eax*2+017h], 1
        jne short .1
        push ecx
        push str_02d
        lea eax, [byte esp+08h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov eax, esi
        call strcpy_
        mov edx, str_backslash2
        mov eax, esi
        call strcat_
        mov edx, str_S4
        mov eax, esi
        call strcat_
        mov edx, esp
        mov eax, esi
        call strcat_
        add esp, byte 4
        pop esi
        ret
.1:
        mov byte [esi], 0
        add esp, byte 4
        pop esi
        ret
%endif ; C
;-----------------------------------------------------------------------------
; PostGameToTeamDb                             3626D  95 PC, medium confidence
; (dir, ext, team, side, ...): merges the game's key / season / GSUMMARY
; records and player stat lines into the team's league database and rewrites
; the team record; used by PlayLeagueGame and season_playoffs after a league
; game
;-----------------------------------------------------------------------------
PostGameToTeamDb:
        push dword 420h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, 404h
        push eax
        push edx
        push ebx
        mov ebp, ecx
        mov edx, 0FFFFFFFFh
        mov dword [dword esp+03ECh], edx
        mov dword [dword esp+03E8h], edx
        mov dword [dword esp+03E4h], edx
        mov dword [dword esp+03E0h], edx
        mov dword [dword esp+03D8h], hmlinetab
        mov dword [dword esp+03DCh], awlinetab
        cmp dword [dword esp+0420h], 444h
        jge short .1
        lea eax, [byte esp+034h]
        mov dword [dword esp+03FCh], eax
        lea edi, [dword esp+0360h]
        lea esi, [dword esp+02F4h]
        jmp short .2
.1:
        lea eax, [byte esp+046h]
        mov dword [dword esp+03FCh], eax
        lea edi, [dword esp+0372h]
        lea esi, [dword esp+030Ah]
.2:
        mov ebx, dword [leaguedbnames+10h]
        mov ecx, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        lea eax, [dword esp+0390h]
        call MakePath
        lea edx, [dword esp+03ECh]
        lea eax, [dword esp+0390h]
        call FileOpenRW
        mov ebx, eax
        test eax, eax
        jne short .3
        mov ebx, dword [leaguedbnames]
        mov ecx, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        lea eax, [dword esp+0390h]
        call MakePath
        lea edx, [dword esp+03E8h]
        lea eax, [dword esp+0390h]
        call FileOpenRead
        mov ebx, eax
.3:
        test ebx, ebx
        jne short .4
        mov ebx, dword [leaguedbnames+14h]
        mov ecx, dword [byte esp+04h]
        mov edx, dword [byte esp+08h]
        lea eax, [dword esp+0390h]
        call MakePath
        lea edx, [dword esp+03E4h]
        lea eax, [dword esp+0390h]
        call FileOpenRW
        mov ebx, eax
.4:
        test ebx, ebx
        jne short .5
        mov ecx, str_extDB
        mov ebx, str_GSUMMARY
        mov edx, dword [dword esp+0424h]
        lea eax, [dword esp+0390h]
        call MakePath
        lea edx, [dword esp+03E0h]
        lea eax, [dword esp+0390h]
        call FileOpenRW
        mov ebx, eax
.5:
        test ebx, ebx
        jne short .6
        mov ebx, dword [esp]
        lea edx, [byte esp+0Ch]
        mov eax, dword [dword esp+03ECh]
        call ReadTeamRec
        mov ebx, eax
.6:
        test ebx, ebx
        jne near .20
        mov eax, dword [dword esp+03FCh]
        inc byte [eax]
        mov ax, word [hmscore]
        mov dx, word [awscore]
        cmp ax, dx
        jle short .9
        mov eax, dword [awscore-2]
        sar eax, 10h
        inc eax
        mov dword [dword esp+0404h], eax
        mov dword [dword esp+0400h], ebx
        test ebp, ebp
        jne short .8
.7:
        mov eax, dword [dword esp+03FCh]
        inc byte [byte eax+01h]
        jmp short .11
.8:
        mov eax, dword [dword esp+03FCh]
        inc byte [byte eax+02h]
        jmp short .11
.9:
        jge short .10
        cwde
        inc eax
        mov dword [dword esp+0404h], eax
        mov dword [dword esp+0400h], 1
        test ebp, ebp
        je short PostGameToTeamDb.8
        jmp short PostGameToTeamDb.7
.10:
        mov dword [dword esp+0400h], 0FFFFFFFFh
        mov eax, dword [dword esp+03FCh]
        inc byte [byte eax+03h]
        mov eax, dword [hmscore-2]
        sar eax, 10h
        mov dword [dword esp+0404h], eax
.11:
        mov eax, ebp
        shl eax, 8
        mov dword [dword esp+03F0h], eax
        mov ax, word [dword eax+hmscore]
        mov edx, dword [dword esp+03FCh]
        add word [byte edx+04h], ax
        mov eax, ebp
        xor al, 1
        shl eax, 8
        mov dx, word [dword eax+hmscore]
        mov ecx, dword [dword esp+03FCh]
        add word [byte ecx+06h], dx
        mov edx, dword [dword esp+03F0h]
        mov dx, word [dword edx+hmtmstruct+4]
        add word [byte ecx+0Ah], dx
        mov edx, dword [dword esp+03F0h]
        mov dx, word [dword edx+hmtmstruct+2]
        add word [byte ecx+08h], dx
        mov dx, word [dword eax+hmtmstruct+4]
        add word [byte ecx+0Eh], dx
        mov dx, word [dword eax+hmtmstruct+2]
        add word [byte ecx+0Ch], dx
        mov ax, word [dword eax+hmtmstruct+0Ch]
        mov edx, ecx
        mov cx, word [byte ecx+010h]
        add ecx, eax
        mov word [byte edx+010h], cx
        xor ecx, ecx
        mov dword [dword esp+03F8h], ecx
        jmp near .19
.12:
        shl eax, 2
        mov edx, dword [dword eax+startm-2]
        sar edx, 10h
        cmp edx, ebp
        jne near .18
        mov ebx, dword [dword eax+starpl-2]
        sar ebx, 10h
        mov ebx, dword [byte esp+ebx*4+058h]
        lea edx, [dword esp+032Ch]
        mov eax, dword [dword esp+03E8h]
        call ReadKeyRec
        mov ebx, eax
        test eax, eax
        jne short .15
        cmp byte [dword esp+032Eh], 47h
        jne short .13
        mov ebx, dword [dword esp+0358h]
        lea edx, [dword esp+02F4h]
        mov eax, dword [dword esp+03E4h]
        call ReadGoalieSeasonRec
        jmp short .14
.13:
        mov ebx, dword [dword esp+0358h]
        lea edx, [dword esp+0360h]
        mov eax, dword [dword esp+03E4h]
        call ReadSeasonRec
.14:
        mov ebx, eax
.15:
        test ebx, ebx
        jne short .18
        mov eax, dword [dword esp+03F8h]
        add eax, eax
        cmp byte [dword esp+032Eh], 47h
        jne short .16
        inc word [dword esp+eax+0324h]
        mov ebx, dword [dword esp+0358h]
        lea edx, [dword esp+02F4h]
        mov eax, dword [dword esp+03E4h]
        call WriteGoalieSeasonRec
        jmp short .17
.16:
        inc word [dword esp+eax+0388h]
        mov ebx, dword [dword esp+0358h]
        lea edx, [dword esp+0360h]
        mov eax, dword [dword esp+03E4h]
        call WriteSeasonRec
.17:
        mov ebx, eax
.18:
        inc dword [dword esp+03F8h]
.19:
        mov eax, dword [dword esp+03F8h]
        cmp eax, byte 3
        jge short .20
        test ebx, ebx
        je near PostGameToTeamDb.12
.20:
        cmp dword [dword esp+0400h], byte 0
        jge short .21
        mov ax, word [hmtmgoalie]
        xor ah, ah
        and al, 1
        cwde
        mov edx, dword [hmtmlines]
        mov al, byte [byte edx+eax+024h]
        mov byte [dword esp+040Ch], al
        mov ax, word [awtmgoalie]
        xor ah, ah
        and al, 1
        movsx edx, ax
        mov eax, dword [awtmlines]
        mov al, byte [byte edx+eax+024h]
        mov byte [dword esp+040Dh], al
        jmp near .30
.21:
        test ebx, ebx
        jne short .22
        lea edx, [dword esp+03CCh]
        mov eax, dword [dword esp+03E0h]
        call ReadGSummaryRec
        mov ebx, eax
.22:
        test ebx, ebx
        jne near .30
        xor ecx, ecx
        mov dword [dword esp+0408h], ebx
        mov al, 0FFh
        mov byte [dword esp+040Ch], al
        mov byte [dword esp+040Dh], al
        mov eax, dword [dword esp+03CFh]
        sar eax, 10h
        mov dword [dword esp+03F4h], eax
        mov dword [dword esp+03F8h], ebx
        jmp near .29
.23:
        mov ebx, eax
        lea edx, [dword esp+03CCh]
        mov eax, dword [dword esp+03E0h]
        call ReadGSummaryRec
        mov ebx, eax
        test eax, eax
        jne near .28
        cmp byte [dword esp+03CCh], 1
        jne short .28
        lea edx, [dword esp+03CDh]
        cmp byte [dword esp+03CDh], 0
        jne short .24
        inc ecx
        jmp short .25
.24:
        inc dword [dword esp+0408h]
.25:
        cmp dword [dword esp+0400h], byte 0
        jne short .26
        cmp ecx, dword [dword esp+0404h]
        jne short .28
        mov al, byte [byte edx+08h]
        mov byte [dword esp+040Ch], al
        mov al, byte [byte edx+09h]
        jmp short .27
.26:
        mov eax, dword [dword esp+0408h]
        cmp eax, dword [dword esp+0404h]
        jne short .28
        mov al, byte [byte edx+09h]
        mov byte [dword esp+040Ch], al
        mov al, byte [byte edx+08h]
.27:
        mov byte [dword esp+040Dh], al
.28:
        inc dword [dword esp+03F8h]
.29:
        mov eax, dword [dword esp+03F8h]
        cmp eax, dword [dword esp+03F4h]
        jg short .30
        test ebx, ebx
        je near PostGameToTeamDb.23
.30:
        mov ecx, 19h
        mov edx, 1010101h
        lea eax, [dword esp+03B0h]
        call __STOSB
        mov dword [dword esp+03F8h], 19h
        xor eax, eax
        mov dword [dword esp+03F8h], eax
.31:
        mov eax, dword [dword esp+ebp*4+03D8h]
        add eax, dword [dword esp+03F8h]
        mov al, byte [byte eax+028h]
        and eax, 0FFh
        cmp eax, byte 19h
        jge short .32
        xor dl, dl
        mov byte [dword esp+eax+03B0h], dl
.32:
        mov ecx, dword [dword esp+03F8h]
        inc ecx
        mov dword [dword esp+03F8h], ecx
        cmp ecx, byte 8
        jl short PostGameToTeamDb.31
        xor edx, edx
        mov dword [dword esp+03F8h], edx
        jmp near .36
.33:
        mov eax, ecx
        shl eax, 2
        mov edx, dword [byte esp+eax+058h]
        cmp edx, byte 0FFFFFFFFh
        je near .35
        mov ebx, edx
        lea edx, [dword esp+032Ch]
        mov eax, dword [dword esp+03E8h]
        call ReadKeyRec
        mov ebx, eax
        test eax, eax
        jne short .34
        mov ebx, dword [dword esp+0358h]
        lea edx, [dword esp+0360h]
        mov eax, dword [dword esp+03E4h]
        call ReadSeasonRec
        mov ebx, eax
.34:
        test ebx, ebx
        jne near .35
        mov eax, dword [dword esp+03F8h]
        cmp byte [dword esp+eax+03B0h], 0
        je near .35
        mov ebx, ebp
        shl ebx, 2
        sub ebx, ebp
        shl ebx, 3
        add ebx, ebp
        shl ebx, 4
        shl eax, 4
        inc word [edi]
        add ebx, eax
        mov ax, word [dword ebx+hmplstats]
        add word [byte edi+02h], ax
        mov ax, word [dword ebx+hmplstats_w2]
        add word [byte edi+04h], ax
        mov ax, word [dword ebx+hmplstats]
        mov dx, word [byte edi+06h]
        add edx, eax
        mov word [byte edi+06h], dx
        mov ax, word [dword ebx+hmplstats_w2]
        mov ecx, edx
        add ecx, eax
        mov word [byte edi+06h], cx
        mov ax, word [dword ebx+hmplstats_w4]
        add word [byte edi+0Ch], ax
        mov ax, word [dword ebx+hmplstats_w6]
        add word [byte edi+010h], ax
        mov ax, word [dword ebx+hmplstats_w8]
        add word [byte edi+08h], ax
        mov ax, word [dword ebx+hmplstats_w10]
        add word [byte edi+0Ah], ax
        mov ax, word [dword ebx+hmplstats_w14]
        add word [byte edi+0Eh], ax
        mov ebx, dword [dword esp+0358h]
        lea edx, [dword esp+0360h]
        mov eax, dword [dword esp+03E4h]
        call WriteSeasonRec
        mov ebx, eax
.35:
        inc dword [dword esp+03F8h]
.36:
        mov ecx, dword [dword esp+03F8h]
        cmp ecx, byte 19h
        jge short .37
        test ebx, ebx
        je near PostGameToTeamDb.33
.37:
        xor edi, edi
        mov dword [dword esp+03F8h], edi
.38:
        mov eax, dword [dword esp+03F8h]
        xor cl, cl
        mov byte [dword esp+eax+03C9h], cl
        lea edi, [byte eax+01h]
        mov dword [dword esp+03F8h], edi
        cmp edi, byte 3
        jl short PostGameToTeamDb.38
        xor edx, edx
        mov dword [dword esp+03F8h], edx
.39:
        mov eax, dword [dword esp+ebp*4+03D8h]
        add eax, dword [dword esp+03F8h]
        mov al, byte [byte eax+024h]
        and eax, 0FFh
        cmp eax, byte 1Ch
        jge short .40
        inc byte [dword esp+eax+03B0h]
.40:
        mov edi, dword [dword esp+03F8h]
        inc edi
        mov dword [dword esp+03F8h], edi
        cmp edi, byte 2
        jl short PostGameToTeamDb.39
        xor edx, edx
        mov dword [dword esp+03F8h], edx
        jmp near .56
.41:
        mov eax, ecx
        shl eax, 2
        mov edi, dword [dword esp+eax+0BCh]
        cmp edi, byte 0FFFFFFFFh
        je near .55
        mov ebx, edi
        lea edx, [dword esp+032Ch]
        mov eax, dword [dword esp+03E8h]
        call ReadKeyRec
        mov ebx, eax
        test eax, eax
        jne short .42
        mov ebx, dword [dword esp+0358h]
        lea edx, [dword esp+02F4h]
        mov eax, dword [dword esp+03E4h]
        call ReadGoalieSeasonRec
        mov ebx, eax
.42:
        test ebx, ebx
        jne near .55
        mov eax, dword [dword esp+03F8h]
        cmp byte [dword esp+eax+03C9h], 0
        je near .55
        mov eax, ebp
        shl eax, 3
        add eax, ebp
        add eax, eax
        mov edi, dword [dword esp+03F8h]
        shl edi, 2
        sub edi, dword [dword esp+03F8h]
        add edi, edi
        add edi, eax
        cmp word [dword edi+hmglstats], byte 0
        je near .55
        inc word [esi]
        mov edx, dword [dword edi+hmglstats-2]
        sar edx, 10h
        mov eax, edx
        sar edx, 1Fh
        mov ebx, 3Ch
        idiv ebx
        mov edx, eax
        xor eax, eax
        mov ax, word [byte esi+0Ch]
        add eax, edx
        mov word [byte esi+0Ch], ax
        mov ax, word [dword edi+hmglstats_w2]
        add word [byte esi+012h], ax
        mov ax, word [dword edi+hmglstats_w4]
        add word [byte esi+0Eh], ax
        mov eax, dword [dword esp+ebp+0409h]
        sar eax, 18h
        mov dl, byte [dword esp+03F8h]
        add dl, 19h
        and edx, 0FFh
        cmp eax, edx
        jne short .50
        mov ax, word [hmscore]
        mov cx, word [awscore]
        cmp ax, cx
        jle short .45
        test ebp, ebp
        jne short .44
.43:
        inc word [byte esi+02h]
        jmp short .47
.44:
        inc word [byte esi+04h]
        jmp short .47
.45:
        jge short .46
        test ebp, ebp
        je short PostGameToTeamDb.44
        jmp short PostGameToTeamDb.43
.46:
        inc word [byte esi+06h]
.47:
        cmp word [awscore], byte 0
        jne short .48
        test ebp, ebp
        je short .49
.48:
        cmp word [hmscore], byte 0
        jne short .50
        cmp ebp, byte 1
        jne short .50
.49:
        inc word [byte esi+08h]
.50:
        mov cx, word [esi]
        test cx, cx
        je short .51
        xor eax, eax
        mov ax, word [byte esi+0Eh]
        mov edx, eax
        shl edx, 2
        sub edx, eax
        shl edx, 3
        add edx, eax
        shl edx, 2
        xor ebx, ebx
        mov bx, cx
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov word [byte esi+010h], ax
        jmp short .52
.51:
        mov word [byte esi+010h], cx
.52:
        mov di, word [byte esi+012h]
        test di, di
        je short .53
        xor edi, edi
        mov di, word [byte esi+012h]
        xor eax, eax
        mov ax, word [byte esi+0Eh]
        mov edx, edi
        sub edx, eax
        mov ebx, edx
        shl ebx, 5
        sub ebx, edx
        shl ebx, 2
        add ebx, edx
        shl ebx, 3
        mov eax, edi
        mov edx, edi
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        lea edx, [ebx+eax]
        mov eax, edx
        sar edx, 1Fh
        idiv edi
        mov word [byte esi+014h], ax
        jmp short .54
.53:
        mov word [byte esi+014h], di
.54:
        mov ebx, dword [dword esp+0358h]
        lea edx, [dword esp+02F4h]
        mov eax, dword [dword esp+03E4h]
        call WriteGoalieSeasonRec
        mov ebx, eax
.55:
        inc dword [dword esp+03F8h]
.56:
        mov ecx, dword [dword esp+03F8h]
        cmp ecx, byte 3
        jge short .57
        test ebx, ebx
        je near PostGameToTeamDb.41
.57:
        test ebx, ebx
        jne short .58
        mov ebx, dword [esp]
        lea edx, [byte esp+0Ch]
        mov eax, dword [dword esp+03ECh]
        call WriteTeamRec
        mov ebx, eax
.58:
        lea eax, [dword esp+03E0h]
        call FileClose
        lea eax, [dword esp+03E4h]
        call FileClose
        lea eax, [dword esp+03E8h]
        call FileClose
        lea eax, [dword esp+03ECh]
        call FileClose
        mov eax, ebx
        add esp, 410h
        pop ebp
        pop edi
        pop esi
        ret 8
;-----------------------------------------------------------------------------
; PlayLeagueGame                                                  36B93  95 PC
; MenuNextLeagueGame body: loads the next league game, checks the human
; teams' disks / passwords, "Select a team to play.", plays it and posts the
; results to both team databases
;-----------------------------------------------------------------------------
PlayLeagueGame:
        push dword 0C4h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, 94h
        mov edi, eax
        mov edx, 0FFFFFFFFh
        mov dword [byte esp+06Ch], edx
        mov dword [byte esp+05Ch], edx
        mov dword [byte esp+058h], edx
        mov dword [byte esp+040h], edx
        mov dword [byte esp+064h], edx
        xor edx, edx
        mov dword [byte esp+070h], edx
        mov dword [byte esp+078h], edx
        xor ecx, ecx
        mov dword [dword esp+084h], edx
        mov word [lggameidx], 0FFFFh
        push dword 1E0h
        push dword 280h
        push ecx
        push ecx
        call SetViewRect
        add esp, byte 10h
        mov esi, dword [edi]
        test esi, esi
        jl short .1
        mov eax, esi
        call LoadLeagueGameRef
.1:
        mov edx, 3
        mov eax, curleague
        call LeagueCheckStub
        mov esi, eax
.2:
        xor eax, eax
        mov dword [dword esp+090h], eax
        test esi, esi
        jne short .3
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
.3:
        test esi, esi
        jne near .9
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
        test byte [leagueflags], 0Ch
        je near .8
        lea eax, [byte esp+04Ch]
        push eax
        lea eax, [byte esp+054h]
        push eax
        lea eax, [byte esp+05Ch]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push esi
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
        test byte [leagueflags], 8
        je short .4
        lea eax, [byte esp+020h]
        mov dword [msg_MergeNeeded_e01], eax
        push byte 0FFFFFFFFh
        lea eax, [byte esp+050h]
        push eax
        lea eax, [byte esp+058h]
        push eax
        push byte 2
        push btn_MergeNeeded
        mov ecx, 5
        mov ebx, msg_MergeNeeded
        jmp short .5
.4:
        lea eax, [byte esp+020h]
        mov dword [playerdbsmsg+4], eax
        push byte 0FFFFFFFFh
        lea eax, [byte esp+050h]
        push eax
        lea eax, [byte esp+058h]
        push eax
        push byte 2
        push btn_MasterDB
        mov ecx, 4
        mov ebx, playerdbsmsg
.5:
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov dword [byte esp+054h], eax
        cmp dword [byte esp+054h], byte 0
        jne short .7
        test byte [leagueflags], 8
        je short .6
        call MergeLeagueFiles
.6:
        call UpdateTeamDbs
        mov dword [dword esp+090h], 0FFFFFFFFh
        jmp short .9
.7:
        mov esi, 0FFFFFFFFh
        jmp short .9
.8:
        mov ebx, dword [leaguedbnames+10h]
        mov ecx, str_extDB
        mov edx, curleague
        mov eax, esp
        call MakePath
        mov ebx, 1
        mov edx, treeteamnames
        mov eax, esp
        call ReadTeamNames
        mov esi, eax
.9:
        mov ecx, dword [dword esp+090h]
        test ecx, ecx
        jne near PlayLeagueGame.2
        cmp dword [edi], byte 0
        jge near .21
        mov dword [dword esp+088h], ecx
        test esi, esi
        jne short .10
        push ecx
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
        lea edx, [byte esp+044h]
        mov eax, curleague
        call GetLeagueId
        mov dword [lgplayteam], eax
.10:
        test esi, esi
        jne short .11
        cmp dword [lgplayteam], byte 0
        jge short .11
        push lgplayteam
        push str_SelectATeamTo
        push byte 8
        mov ecx, leagueteams
        mov ebx, treeteamnames
        mov edx, humancount
        mov eax, curleague
        call LeagueTeamSelect
        mov dword [dword esp+088h], 0FFFFFFFFh
.11:
        test esi, esi
        jne near .18
        mov ebx, dword [lgplayteam]
        test ebx, ebx
        jl near .18
        push esi
        xor ecx, ecx
        mov edx, leagueteams
        mov eax, curleague
        call CheckLeagueDiskSync
        mov esi, eax
        test eax, eax
        jne near .16
        mov ecx, dword [lgplayteam]
        push ecx
        push str_02d
        lea eax, [byte esp+068h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea edx, [byte esp+060h]
        mov eax, str_extxx
        call strcpy_
        mov edx, dword [lgplayteam]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        test byte [nosplit eax*2+lgteamflags], 1
        je short .12
        mov edx, curleague
        jmp short .13
.12:
        mov edx, str_floppydrv
.13:
        mov eax, savleague1
        call strcpy_
        cmp dword [humancount], byte 1
        je short .14
        cmp dword [dword esp+088h], byte 0
        jne short .15
.14:
        push byte 0
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
.15:
        mov eax, dword [lgplayteam]
        mov edx, leagueteams
        call AskTeamPassword
        mov esi, eax
.16:
        test esi, esi
        jne short .17
        mov ebx, dword [leaguedbnames+10h]
        mov ecx, str_extDB
        mov edx, curleague
        mov eax, esp
        call MakePath
        xor ebx, ebx
        mov edx, treeteamnames
        mov eax, esp
        call ReadTeamNames
        mov esi, eax
.17:
        test esi, esi
        jne short .18
        mov dword [dword esp+084h], 0FFFFFFFFh
.18:
        push byte 20h
        push dword 300h
        push str_Pal18
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [dword esp+080h], eax
        cmp byte [musicon], 0
        je short .19
        cmp dword [songdata], byte 0
        je short .19
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 3
        call SetDigiChannelVolume
.19:
        mov ecx, dword [dword esp+080h]
        push ecx
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, dword [dword esp+080h]
        mov eax, 1
        call FadePalStep
        mov eax, dword [dword esp+080h]
        push eax
        call FreeMemBlock
        add esp, byte 4
        cmp byte [musicon], 0
        je near .22
        cmp dword [songdata], byte 0
        je near .22
.20:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short PlayLeagueGame.20
        mov ebx, dword [songdata]
        push ebx
        call PushMemDescriptorLocked
        add esp, byte 4
        xor ecx, ecx
        mov dword [songdata], ecx
        jmp short .22
.21:
        push ecx
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
        mov edx, dword [lgplayteam]
        push edx
        push str_02d
        lea eax, [byte esp+068h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea edx, [byte esp+060h]
        mov eax, str_extxx
        call strcpy_
        mov eax, dword [lgplayteam]
        mov edx, leagueteams
        call AskTeamPassword
        mov esi, eax
        test eax, eax
        jne short .22
        mov dword [dword esp+084h], 0FFFFFFFFh
.22:
        cmp dword [dword esp+084h], byte 0
        je near .85
.23:
        mov eax, dword [lggameidx-2]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        jne short .24
        cmp dword [edi], byte 0
        jl short .25
.24:
        cmp dword [byte esp+070h], byte 0
        je short .26
.25:
        mov ebx, dword [lgplayteam]
        mov edx, str_extxx
        mov eax, savleague1
        call CalendarScreen
        mov word [lggameidx], ax
.26:
        cmp word [lggameidx], byte 0
        jl near .80
        mov ebx, dword [leaguedbnames+18h]
        mov ecx, str_extxx
        mov edx, savleague1
        mov eax, esp
        call MakePath
        lea edx, [byte esp+06Ch]
        mov eax, esp
        call FileOpenRW
        mov esi, eax
        cmp dword [edi], byte 0
        jge near .30
        test eax, eax
        jne short .27
        mov ecx, 2
        xor ebx, ebx
        mov edx, lggamecount
        mov eax, dword [byte esp+06Ch]
        call FileReadAt
        mov esi, eax
.27:
        test esi, esi
        jne short .28
        mov ebx, dword [lggameidx-2]
        sar ebx, 10h
        mov edx, lgschedrec
        mov eax, dword [byte esp+06Ch]
        call ReadSchedGame
        mov esi, eax
.28:
        test esi, esi
        jne short .30
        xor eax, eax
        mov al, byte [lgschedrec_b2]
        mov edx, dword [lgplayteam]
        cmp eax, edx
        jne short .29
        xor eax, edx
        mov al, byte [lgschedrec_b3]
.29:
        mov dword [lgoppteam], eax
        mov dword [lgopphuman], 0FFFFFFFFh
        mov edx, dword [lgoppteam]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        cmp byte [nosplit eax*2+lgteam_17], 0
        jne short .30
        xor ecx, ecx
        mov dword [lgopphuman], ecx
.30:
        lea eax, [byte esp+06Ch]
        call FileClose
        cmp dword [lgopphuman], byte 0
        je near .36
        test esi, esi
        jne near .33
        push esi
        mov ebx, dword [lgoppteam]
        mov ecx, 0FFFFFFFFh
        mov edx, leagueteams
        mov eax, curleague
        call CheckLeagueDiskSync
        mov esi, eax
        test eax, eax
        jne short .33
        mov edx, dword [lgoppteam]
        push edx
        push str_02d
        lea eax, [byte esp+068h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea edx, [byte esp+060h]
        mov eax, str_Xx
        call strcpy_
        mov edx, dword [lgoppteam]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        test byte [nosplit eax*2+lgteamflags], 1
        je short .31
        cmp dword [dword esp+088h], byte 0
        je short .31
        mov edx, curleague
        jmp short .32
.31:
        mov edx, str_floppydrv
.32:
        mov eax, savleague2
        call strcpy_
.33:
        test esi, esi
        jne short .34
        mov ebx, dword [leaguedbnames+18h]
        mov ecx, str_Xx
        mov edx, savleague2
        mov eax, esp
        call MakePath
        lea edx, [byte esp+05Ch]
        mov eax, esp
        call FileOpenRW
        mov esi, eax
.34:
        cmp dword [edi], byte 0
        jge short .35
        test esi, esi
        jne short .35
        mov ecx, 2
        xor ebx, ebx
        mov edx, lgoppgamecount
        mov eax, dword [byte esp+05Ch]
        call FileReadAt
        mov esi, eax
.35:
        lea eax, [byte esp+05Ch]
        call FileClose
        test esi, esi
        jne short .36
        mov esi, dword [lgoppteam]
        push esi
        push str_02d
        lea eax, [byte esp+068h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea edx, [byte esp+060h]
        mov eax, str_Xx
        call strcpy_
        mov eax, dword [lgoppteam]
        mov edx, leagueteams
        call AskTeamPassword
        mov esi, eax
        test eax, eax
        je short .36
        mov dword [byte esp+078h], 0FFFFFFFFh
.36:
        test esi, esi
        jne near .51
        cmp dword [edi], byte 0
        jl short .37
        push byte 20h
        push dword 300h
        push str_Temp5
        call AllocMemBlock
        mov esi, eax
        add esp, byte 0Ch
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, esi
        mov eax, 1
        call FadePalStep
        push esi
        call FreeMemBlock
        add esp, byte 4
.37:
        cmp byte [musicon], 0
        je short .39
        cmp dword [songdata], byte 0
        je short .39
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 3
        call SetDigiChannelVolume
.38:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short PlayLeagueGame.38
        mov ecx, dword [songdata]
        push ecx
        call PushMemDescriptorLocked
        add esp, byte 4
        xor esi, esi
        mov dword [songdata], esi
.39:
        cmp dword [edi], byte 0
        jl short .40
        call ShowLoadingScreen
.40:
        xor ecx, ecx
        mov cl, byte [lgschedrec_b2]
        cmp ecx, dword [lgplayteam]
        jne short .41
        xor ebx, ebx
        mov dword [byte esp+074h], ebx
        mov ebp, 1
        mov ebx, leagueteams
        mov edx, savleague1
        mov eax, leaguedbfmt
        call MakeTeamDbFmt
        xor ecx, ecx
        mov cl, byte [lgschedrec_b3]
        mov ebx, leagueteams
        mov edx, savleague2
        jmp short .42
.41:
        mov dword [byte esp+074h], 1
        xor ebp, ebp
        mov ebx, leagueteams
        mov edx, savleague2
        mov eax, leaguedbfmt
        call MakeTeamDbFmt
        xor ecx, ecx
        mov cl, byte [lgschedrec_b3]
        mov ebx, leagueteams
        mov edx, savleague1
.42:
        mov eax, leaguedbfmt2
        call MakeTeamDbFmt
        cmp byte [leaguedbfmt2], 0
        jne short .43
        mov edx, leaguedbfmt
        mov eax, leaguedbfmt2
        call strcpy_
.43:
        cmp byte [leaguedbfmt], 0
        jne short .44
        mov edx, leaguedbfmt2
        mov eax, leaguedbfmt
        call strcpy_
.44:
        mov eax, dword [lggameidx-2]
        sar eax, 10h
        mov dword [schedgameidx], eax
        cmp word [lggameidx], 444h
        jge short .45
        or byte [gameopts+1], 2
        jmp short .46
.45:
        and byte [gameopts+1], 0FDh
.46:
        cmp dword [edi], byte 0
        jge short .47
        mov al, byte [lgschedrec]
        mov byte [UnusedStateByte], al
        mov al, byte [lgschedrec_b1]
        mov byte [GameRecordDay], al
        xor eax, eax
        mov al, byte [lgschedrec_b2]
        mov word [HomeTeam], ax
        xor eax, eax
        mov al, byte [lgschedrec_b3]
        mov word [VisTeam], ax
.47:
        call SetupControllers
        xor esi, esi
        cmp dword [edi], byte 0
        jge short .49
        call CheckGameDiskSpace
        test eax, eax
        jne short .48
        xor edx, edx
        mov dl, byte [GameRecordDay]
        mov al, byte [UnusedStateByte]
        call InitGameSummary
        xor edx, edx
        mov dl, byte [VisTeam]
        xor eax, eax
        mov al, byte [HomeTeam]
        call PreGameScreen
        mov esi, eax
        jmp short .49
.48:
        mov esi, 4
.49:
        cmp esi, byte 4
        je short .50
        mov dword [teamstatscb], GameTeamStatsScreen
        mov dword [skaterstatscb], GameSkaterStatsScreen
        mov dword [goaliestatscb], GameGoalieStatsScreen
        mov dword [standingscb], GameStandingsScreen
        mov dword [standingsmenucb], GameStandingsMenu
        call InputRemove
        mov eax, edi
        call PlayGame
        call InputInstall
        cmp dword [gameresult], byte 1
        jne short .51
        mov al, byte [hmscore]
        mov byte [lgschedrec_b4], al
        mov al, byte [awscore]
        mov byte [lgschedrec_b5], al
        jmp short .51
.50:
        mov dword [gameresult], 2
.51:
        test esi, esi
        jne near .77
        cmp dword [gameresult], byte 1
        jne near .77
        mov eax, dword [lggameidx-2]
        sar eax, 10h
        mov dword [byte esp+07Ch], eax
        push esi
        call ClearScreen
        add esp, byte 4
        xor ecx, ecx
        mov ebx, str_Easndesk2
        cmp byte [fileoncd+06Ah], 1
        jne short .52
        mov edx, dword [cddriveptr]
        jmp short .53
.52:
        xor edx, edx
.53:
        mov eax, esp
        call MakePath
        push byte 0
        lea eax, [byte esp+04h]
        push eax
        call LoadBank
        mov dword [byte esp+070h], eax
        add esp, byte 8
        push str_Pal17
        push eax
        call FindShape
        add esp, byte 8
        add eax, byte 10h
        push eax
        push dword 100h
        push byte 0
        call VgaSetPalette
        add esp, byte 0Ch
        mov ebx, dword [byte esp+068h]
        push ebx
        call FreeMemBlock
        add esp, byte 4
        mov dl, 17h
        mov byte [byte esp+060h], dl
        mov byte [byte esp+061h], dl
        mov byte [byte esp+062h], dl
        lea eax, [byte esp+060h]
        push eax
        push byte 1
        push dword 0F8h
        call VgaSetPalette
        add esp, byte 0Ch
        mov bh, 2Ah
        mov byte [byte esp+060h], bh
        mov byte [byte esp+061h], bh
        mov byte [byte esp+062h], bh
        lea eax, [byte esp+060h]
        push eax
        push byte 1
        push dword 0F9h
        call VgaSetPalette
        add esp, byte 0Ch
        mov al, 3Fh
        mov byte [byte esp+060h], al
        mov byte [byte esp+061h], al
        mov byte [byte esp+062h], al
        lea eax, [byte esp+060h]
        push eax
        push byte 1
        push dword 0FAh
        call VgaSetPalette
        add esp, byte 0Ch
        push byte 0
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
        cmp dword [lgopphuman], byte 0
        je near .56
        push byte 0FFFFFFFFh
        mov ebx, dword [lgoppteam]
        mov ecx, 0FFFFFFFFh
        mov edx, leagueteams
        mov eax, curleague
        call CheckLeagueDiskSync
        mov esi, eax
        test eax, eax
        jne short .56
        mov eax, dword [lgoppteam]
        push eax
        push str_02d
        lea eax, [byte esp+068h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea edx, [byte esp+060h]
        mov eax, str_Xx
        call strcpy_
        mov edx, dword [lgoppteam]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        test byte [nosplit eax*2+lgteamflags], 1
        je short .54
        cmp dword [dword esp+088h], byte 0
        je short .54
        mov edx, curleague
        jmp short .55
.54:
        mov edx, str_floppydrv
.55:
        mov eax, savleague2
        call strcpy_
.56:
        test esi, esi
        jne short .57
        mov ebx, dword [leaguedbnames+18h]
        mov ecx, str_extxx
        mov edx, savleague1
        mov eax, esp
        call MakePath
        lea edx, [byte esp+06Ch]
        mov eax, esp
        call FileOpenRW
        mov esi, eax
        cmp dword [lgopphuman], byte 0
        je short .57
        test eax, eax
        jne short .57
        mov ebx, dword [leaguedbnames+18h]
        mov ecx, str_Xx
        mov edx, savleague2
        mov eax, esp
        call MakePath
        lea edx, [byte esp+05Ch]
        mov eax, esp
        call FileOpenRW
        mov esi, eax
.57:
        test esi, esi
        jne short .58
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
        mov dword [byte esp+048h], esi
        xor bl, bl
        mov byte [byte esp+030h], bl
.58:
        test esi, esi
        jne short .59
        mov ecx, str_extDB
        mov ebx, str_PINFO
        mov edx, savleague1
        mov eax, esp
        call MakePath
        lea edx, [byte esp+064h]
        mov eax, esp
        call FileOpenWrite
        mov esi, eax
.59:
        test esi, esi
        jne short .60
        mov ecx, 2
        mov ebx, 4
        lea edx, [byte esp+048h]
        mov eax, dword [byte esp+064h]
        call FileWriteAt
        mov esi, eax
.60:
        test esi, esi
        jne short .61
        mov ecx, 0Dh
        mov ebx, 6
        lea edx, [byte esp+030h]
        mov eax, dword [byte esp+064h]
        call FileWriteAt
        mov esi, eax
.61:
        lea eax, [byte esp+064h]
        call FileClose
        cmp dword [lgopphuman], byte 0
        je short .65
        test esi, esi
        jne short .62
        mov ecx, str_extDB
        mov ebx, str_PINFO
        mov edx, savleague2
        mov eax, esp
        call MakePath
        lea edx, [byte esp+064h]
        mov eax, esp
        call FileOpenWrite
        mov esi, eax
.62:
        test esi, esi
        jne short .63
        mov ecx, 2
        mov ebx, 4
        lea edx, [byte esp+048h]
        mov eax, dword [byte esp+064h]
        call FileWriteAt
        mov esi, eax
.63:
        test esi, esi
        jne short .64
        mov ecx, 0Dh
        mov ebx, 6
        lea edx, [byte esp+030h]
        mov eax, dword [byte esp+064h]
        call FileWriteAt
        mov esi, eax
.64:
        lea eax, [byte esp+064h]
        call FileClose
.65:
        test esi, esi
        jne short .66
        mov ebx, dword [lggameidx-2]
        sar ebx, 10h
        mov edx, lgschedrec
        mov eax, dword [byte esp+06Ch]
        call WriteSchedGame
        mov esi, eax
.66:
        test esi, esi
        jne short .67
        cmp dword [lgopphuman], byte 0
        je short .67
        mov ebx, dword [lggameidx-2]
        sar ebx, 10h
        mov edx, lgschedrec
        mov eax, dword [byte esp+05Ch]
        call WriteSchedGame
        mov esi, eax
.67:
        test esi, esi
        jne near .72
        mov ax, word [lggameidx]
        cmp ax, 444h
        jl near .70
        mov ebx, dword [leaguedbnames+10h]
        mov ecx, str_extxx
        mov edx, savleague1
        mov eax, esp
        call MakePath
        lea edx, [byte esp+058h]
        mov eax, esp
        call FileOpenRW
        mov esi, eax
        test eax, eax
        jne short .68
        mov ebx, dword [lggameidx-2]
        sar ebx, 10h
        mov edx, dword [byte esp+058h]
        mov eax, dword [byte esp+06Ch]
        call UpdatePlayoffSeries
        mov esi, eax
.68:
        lea eax, [byte esp+058h]
        call FileClose
        test esi, esi
        jne near .72
        cmp dword [lgopphuman], byte 0
        je near .72
        mov ebx, dword [leaguedbnames+10h]
        mov ecx, str_Xx
        mov edx, savleague2
        mov eax, esp
        call MakePath
        lea edx, [byte esp+040h]
        mov eax, esp
        call FileOpenRW
        mov esi, eax
        test eax, eax
        jne short .69
        mov ebx, dword [lggameidx-2]
        sar ebx, 10h
        mov edx, dword [byte esp+040h]
        mov eax, dword [byte esp+05Ch]
        call UpdatePlayoffSeries
        mov esi, eax
.69:
        lea eax, [byte esp+040h]
        call FileClose
        jmp short .72
.70:
        mov edx, eax
        inc edx
        mov word [lggameidx], dx
        cmp dx, word [lggamecount]
        jle short .71
        mov ecx, 2
        xor ebx, ebx
        mov edx, lggameidx
        mov eax, dword [byte esp+06Ch]
        call FileWriteAt
        mov esi, eax
.71:
        test esi, esi
        jne short .72
        cmp dword [lgopphuman], byte 0
        je short .72
        mov ax, word [lggameidx]
        cmp ax, word [lgoppgamecount]
        jle short .72
        mov ecx, 2
        xor ebx, ebx
        mov edx, lggameidx
        mov eax, dword [byte esp+05Ch]
        call FileWriteAt
        mov esi, eax
.72:
        test esi, esi
        jne near .76
        push byte 2
        mov esi, dword [lgplayteam]
        push esi
        mov ebx, dword [lggameidx-2]
        sar ebx, 10h
        dec ebx
        mov ecx, leagueteams
        mov edx, str_extxx
        mov eax, savleague1
        call UpdateSeasonSchedule
        mov esi, eax
        test eax, eax
        jne short .73
        push savleague1
        mov eax, dword [dword esp+080h]
        push eax
        mov ebx, dword [lgplayteam]
        mov ecx, dword [byte esp+07Ch]
        mov edx, str_extxx
        mov eax, savleague1
        call PostGameToTeamDb
        mov esi, eax
.73:
        test esi, esi
        jne near .76
        cmp dword [lgopphuman], byte 0
        je short .74
        push byte 2
        mov ecx, dword [lgoppteam]
        push ecx
        mov ebx, dword [lggameidx-2]
        sar ebx, 10h
        mov ecx, leagueteams
        mov edx, str_Xx
        mov eax, savleague2
        call UpdateSeasonSchedule
        mov esi, eax
        test eax, eax
        jne short .76
        push savleague1
        mov esi, dword [dword esp+080h]
        push esi
        mov ebx, dword [lgoppteam]
        mov ecx, ebp
        mov edx, str_Xx
        mov eax, savleague2
        jmp short .75
.74:
        push savleague1
        mov ebx, dword [dword esp+080h]
        push ebx
        mov ebx, dword [lgoppteam]
        mov ecx, ebp
        mov edx, str_extxx
        mov eax, savleague1
.75:
        call PostGameToTeamDb
        mov esi, eax
.76:
        call RestoreDialogBg
        push byte 0
        call ClearScreen
        add esp, byte 4
.77:
        test esi, esi
        je short .78
        cmp dword [byte esp+078h], byte 0
        jne short .78
        cmp esi, byte 4
        je short .78
        lea eax, [byte esp+04Ch]
        push eax
        lea eax, [byte esp+054h]
        push eax
        lea eax, [byte esp+05Ch]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [byte esp+050h]
        push eax
        lea eax, [byte esp+058h]
        push eax
        push byte 0
        push byte 0
        mov ecx, 1
        mov ebx, msg_DbUpdateError
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
.78:
        cmp dword [lgopphuman], byte 0
        je short .79
        lea eax, [byte esp+05Ch]
        call FileClose
.79:
        lea eax, [byte esp+06Ch]
        call FileClose
.80:
        push byte 20h
        push dword 300h
        push str_Temp5
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [dword esp+08Ch], eax
        cmp byte [musicon], 0
        je short .81
        cmp dword [songdata], byte 0
        je short .81
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 3
        call SetDigiChannelVolume
.81:
        mov ecx, dword [dword esp+08Ch]
        push ecx
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, dword [dword esp+08Ch]
        mov eax, 1
        call FadePalStep
        mov eax, dword [dword esp+08Ch]
        push eax
        call FreeMemBlock
        add esp, byte 4
        cmp byte [musicon], 0
        je short .83
        cmp dword [songdata], byte 0
        je short .83
.82:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short PlayLeagueGame.82
        mov ebx, dword [songdata]
        push ebx
        call PushMemDescriptorLocked
        add esp, byte 4
        xor ecx, ecx
        mov dword [songdata], ecx
.83:
        call InputInstall
        mov dword [byte esp+070h], 0FFFFFFFFh
        cmp esi, byte 4
        jne short .84
        xor esi, esi
.84:
        mov ecx, str_SAV
        mov ebx, str_GAME
        mov edx, curleague
        mov eax, esp
        call MakePath
        cmp word [lggameidx], byte 0
        jl short .85
        test esi, esi
        jne short .85
        mov eax, esp
        call FileExists
        test eax, eax
        je near PlayLeagueGame.23
.85:
        push dword 1E0h
        push dword 280h
        push byte 0
        push byte 0
        call SetViewRect
        add esp, byte 10h
        add esp, 94h
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
