; The league schedule and the league playoffs: building the season, simulating a day, and seeding each round.
bits 32
%include "hockey.inc"
section s_41B80 progbits alloc exec nowrite align=1
extern __CHK, __STOSD, AskDatabaseChoice, AwardsCeremony, btn_LeagueExists, btn_WhichSchedule, lgschedrec, byte_DE268
extern careerdb, careerdb_size, confteams, CopyFile, CopyHumanTeamDBs, curleague, dbextension, DeleteDir
extern DiskFreeBytes, DiskSpaceShort, divisionteams, poconf2teams, playoffbuf, leaguedbsizes, dword_C9002, dword_DDD34
extern dword_DDD3C, FileClose, FileExists, FileOpenRead, FileOpenRW, FileReadAt, FileWriteAt, FreeMemBlock
extern gameopts, GetLeagueDBSizes, humancount, keydb, keydb_size, leaguedbnames, leagueflags, leaguemaster
extern leaguesaved, leagueteams, LeagueTeamSelect, lggameidx, lgplayteam, lgstate, lgteam_17, lgteam_18
extern lgteam_19, lgteamflags, lgteamver, MakePath, masterpw, memset_, MessageBox, mkdir_
extern monthdays_m1, msg_CreateError, msg_CreatingLeague, msg_DiskFull, msg_GenSchedule, msg_LeagueExists, msg_NoDiskSpace, msg_WhichSchedule
extern rand_, ReadSchedGame, ReadTeamNames, ReadTeamRec, RestoreDialogBg, savedname, savleague1, savleague2
extern seasondb, seasondb_size, SeriesWinner, SetDialogColors, SimulateGame, sprintf_, str_EnterLeagueName, str_extDB
extern str_extLP, str_gameset, str_KbytesFree, str_KbytesFreeLine, str_Sch, str_sche, str_SelHumanTeams, strcat_
extern strcpy_, AllocMemBlock, sub_8E8A0, GetFileSize, WriteFile, MouseRead, teamdivflags, teamdivision
extern teamdivslot, TextInputDialog, treeteamnames, unknown_libname_1, word_DDD48, word_DDD4A, WriteLeagueInfo, WriteModeState
extern WriteSchedGame, WriteTeamRec
global LoadLeagueGameRef, DateKey, NormalizeDate, UpdateSeasonSchedule, UpdateSeasonSchedule_pop3, UpdatePlayoffSeries, SeriesLength_jt, SeriesLength
global SeriesLength_bo1, SeriesLength_bo3, SeriesLength_n3, SeriesLength_n4, SeriesLength_bo7, RandomizeSchedule, SimScheduleDay, BuildPlayoffs
global GetPlayoffSeeds, SortStandings, SwapInt, SetSeriesTeams, SeedPlayoffRound1, SimPlayoffRound1, SimPlayoffRound1_ok, SimPlayoffRound1_pop3
global SeedPlayoffRound2, SimPlayoffRound2, SeedPlayoffRound3, SimPlayoffRound3, SeedPlayoffFinal, SimPlayoffFinal, FinishPlayoffs_jt, FinishPlayoffs
global FinishPlayoffs_r1, FinishPlayoffs_r2, FinishPlayoffs_r3, FinishPlayoffs_r4, AdvancePlayoffs, CreateNewLeague
;-----------------------------------------------------------------------------
; LoadLeagueGameRef                                               41B80  95 PC
; Import_export 36BFC: reads the saved-game league state from the open file
; in the order SaveLeagueGameRef writes it (DDD38, DDD34, DDD3C, DDD48,
; DDD4A, DDD46, savleague1, savleague2, DDD40)
;-----------------------------------------------------------------------------
; C: src/front/season/LoadLeagueGameRef.c
%ifdef CBUILD
%include "c/front/season/LoadLeagueGameRef.inc"
%else
LoadLeagueGameRef:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov esi, eax
        mov ecx, 4
        mov ebx, 0FFFFFFFFh
        mov edx, lgplayteam
        call FileReadAt
        test eax, eax
        jne short .1
        mov ecx, 4
        mov ebx, 0FFFFFFFFh
        mov edx, dword_DDD34
        mov eax, esi
        call FileReadAt
.1:
        test eax, eax
        jne short .2
        mov ecx, 4
        mov ebx, 0FFFFFFFFh
        mov edx, dword_DDD3C
        mov eax, esi
        call FileReadAt
.2:
        test eax, eax
        jne short .3
        mov ecx, 4
        mov ebx, 0FFFFFFFFh
        mov edx, word_DDD48
        mov eax, esi
        call FileReadAt
.3:
        test eax, eax
        jne short .4
        mov ecx, 4
        mov ebx, 0FFFFFFFFh
        mov edx, word_DDD4A
        mov eax, esi
        call FileReadAt
.4:
        test eax, eax
        jne short .5
        mov ecx, 4
        mov ebx, 0FFFFFFFFh
        mov edx, lggameidx
        mov eax, esi
        call FileReadAt
.5:
        test eax, eax
        jne short .6
        mov ecx, 0Dh
        mov ebx, 0FFFFFFFFh
        mov edx, savleague1
        mov eax, esi
        call FileReadAt
.6:
        test eax, eax
        jne short .7
        mov ecx, 0Dh
        mov ebx, 0FFFFFFFFh
        mov edx, savleague2
        mov eax, esi
        call FileReadAt
.7:
        test eax, eax
        jne short .x
        mov ecx, 6
        mov ebx, 0FFFFFFFFh
        mov edx, lgschedrec
        mov eax, esi
        call FileReadAt
.x:
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DateKey                                      41C79  95 PC, medium confidence
; (month, day) -> sortable day number: months below 9 count as month+12
; (season runs Sep-Jun), result month*31 + day; SimScheduleDay compares game
; dates with it
;-----------------------------------------------------------------------------
; C: src/front/season/DateKey.c
%ifdef CBUILD
%include "c/front/season/DateKey.inc"
%else
DateKey:
        push dword 8
        call __CHK
        push ebx
        cmp eax, byte 9
        jl short .1
        mov ebx, eax
        jmp short .2
.1:
        lea ebx, [byte eax+0Ch]
        mov eax, ebx
.2:
        shl eax, 5
        sub eax, ebx
        add eax, edx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; NormalizeDate                                                   41C9B  95 PC
; (&month, &day): while day > monthdays_m1[month] subtract the month length
; and step the month
;-----------------------------------------------------------------------------
; C: src/front/season/NormalizeDate.c
%ifdef CBUILD
%include "c/front/season/NormalizeDate.inc"
%else
NormalizeDate:
        push dword 0Ch
        call __CHK
        push ebx
        push ecx
.1:
        xor ebx, ebx
        mov bl, byte [eax]
        mov cl, byte [edx]
        mov ch, byte [dword ebx+monthdays_m1]
        cmp cl, ch
        jbe short .x
        mov bh, cl
        sub bh, ch
        mov byte [edx], bh
        inc byte [eax]
        jmp short NormalizeDate.1
.x:
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; UpdateSeasonSchedule                         41CC4  95 PC, medium confidence
; After a league game (import_export/database_merge): opens SCHEDULE.DB,
; TEAMS.DB (rw) and CARTEAMS.DB, loads SEASON/CAREER/KEY databases, reads the
; game at the given index; regular season (index < 444h, or game 444h not yet
; seeded) -> SimScheduleDay, playoffs -> AdvancePlayoffs; saves SEASON.DB and
; frees the buffers
;-----------------------------------------------------------------------------
; C: src/front/season/UpdateSeasonSchedule.c
%ifdef CBUILD
%include "c/front/season/UpdateSeasonSchedule.inc"
%else
UpdateSeasonSchedule:
        push dword 60h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 3Ch
        mov edi, eax
        mov esi, edx
        mov dword [byte esp+034h], ebx
        mov dword [byte esp+038h], ecx
        mov edx, 0FFFFFFFFh
        mov dword [byte esp+030h], edx
        mov dword [byte esp+02Ch], edx
        mov dword [byte esp+028h], edx
        xor ah, ah
        mov byte [byte_DE268], ah
        mov ebx, dword [leaguedbnames+18h]
        mov ecx, esi
        mov edx, edi
        mov eax, esp
        call MakePath
        lea edx, [byte esp+030h]
        mov eax, esp
        call FileOpenRW
        mov ebp, eax
        test eax, eax
        jne short .1
        mov ebx, dword [leaguedbnames+10h]
        mov ecx, esi
        mov edx, edi
        mov eax, esp
        call MakePath
        lea edx, [byte esp+02Ch]
        mov eax, esp
        call FileOpenRW
        mov ebp, eax
.1:
        test ebp, ebp
        jne short .2
        mov ebx, dword [leaguedbnames+0Ch]
        mov ecx, esi
        mov edx, edi
        mov eax, esp
        call MakePath
        lea edx, [byte esp+028h]
        mov eax, esp
        call FileOpenRead
        mov ebp, eax
.2:
        test ebp, ebp
        jne short .3
        mov eax, dword [byte esp+034h]
        cmp eax, 4ADh
        jge short .3
        mov ebx, eax
        lea edx, [byte esp+020h]
        mov eax, dword [byte esp+030h]
        call ReadSchedGame
        mov ebp, eax
.3:
        test ebp, ebp
        jne near .4
        mov ebx, dword [leaguedbnames+14h]
        mov ecx, esi
        mov edx, edi
        mov eax, esp
        call MakePath
        push byte 20h
        lea eax, [byte esp+04h]
        push eax
        call sub_8E8A0
        add esp, byte 8
        mov dword [seasondb], eax
        mov eax, esp
        push eax
        call GetFileSize
        add esp, byte 4
        mov dword [seasondb_size], eax
        mov ebx, dword [leaguedbnames+4]
        mov ecx, esi
        mov edx, edi
        mov eax, esp
        call MakePath
        push byte 20h
        lea eax, [byte esp+04h]
        push eax
        call sub_8E8A0
        add esp, byte 8
        mov dword [careerdb], eax
        mov eax, esp
        push eax
        call GetFileSize
        add esp, byte 4
        mov dword [careerdb_size], eax
        mov ebx, dword [leaguedbnames]
        mov ecx, esi
        mov edx, edi
        mov eax, esp
        call MakePath
        push byte 20h
        lea eax, [byte esp+04h]
        push eax
        call sub_8E8A0
        add esp, byte 8
        mov dword [keydb], eax
        mov eax, esp
        push eax
        call GetFileSize
        add esp, byte 4
        mov dword [keydb_size], eax
.4:
        test ebp, ebp
        jne near .10
        mov edx, dword [byte esp+034h]
        test edx, edx
        jle near .10
        cmp edx, 444h
        jg short .8
        jne short .5
        cmp byte [byte esp+022h], 0FFh
        je short .5
        cmp byte [byte esp+023h], 0FFh
        jne short .6
.5:
        mov eax, 1
        jmp short .7
.6:
        xor eax, eax
.7:
        test eax, eax
        je short .8
        mov edx, dword [byte esp+050h]
        push edx
        mov ebx, dword [byte esp+050h]
        push ebx
        push esi
        push edi
        mov ecx, dword [byte esp+048h]
        push ecx
        mov ecx, dword [byte esp+048h]
        mov ebx, dword [byte esp+03Ch]
        mov edx, dword [byte esp+040h]
        mov eax, dword [byte esp+044h]
        call SimScheduleDay
        jmp short .9
.8:
        mov ebp, dword [byte esp+050h]
        push ebp
        mov eax, dword [byte esp+050h]
        push eax
        push esi
        push edi
        mov ecx, dword [byte esp+048h]
        mov ebx, dword [byte esp+038h]
        mov edx, dword [byte esp+03Ch]
        mov eax, dword [byte esp+040h]
        call AdvancePlayoffs
.9:
        mov ebp, eax
.10:
        test ebp, ebp
        jne short .11
        cmp dword [seasondb], byte 0
        je short .11
        mov ebx, dword [leaguedbnames+14h]
        mov ecx, esi
        mov edx, edi
        mov eax, esp
        call MakePath
        mov edx, dword [seasondb_size]
        push edx
        mov ebx, dword [seasondb]
        push ebx
        lea eax, [byte esp+08h]
        push eax
        call WriteFile
        add esp, byte 0Ch
.11:
        mov ecx, dword [seasondb]
        test ecx, ecx
        je short .12
        push ecx
        call FreeMemBlock
        add esp, byte 4
.12:
        mov edi, dword [careerdb]
        test edi, edi
        je short .13
        push edi
        call FreeMemBlock
        add esp, byte 4
.13:
        mov edx, dword [keydb]
        test edx, edx
        je short .14
        push edx
        call FreeMemBlock
        add esp, byte 4
.14:
        xor ecx, ecx
        mov dword [seasondb], ecx
        mov dword [careerdb], ecx
        mov dword [keydb], ecx
        mov dword [seasondb_size], ecx
        mov dword [careerdb_size], ecx
        mov dword [keydb_size], ecx
        lea eax, [byte esp+028h]
        call FileClose
        lea eax, [byte esp+02Ch]
        call FileClose
        lea eax, [byte esp+030h]
        call FileClose
        mov eax, ebp
        add esp, byte 3Ch
UpdateSeasonSchedule_pop3:
        pop ebp
        pop edi
        pop esi
        ret 8
%endif ; C
;-----------------------------------------------------------------------------
; UpdatePlayoffSeries                          41F64  95 PC, medium confidence
; Import_export 37846/378A4: playoff game index -> round
; (444h/47Ch/498h/4A6h) and series (7 games each); counts played games, and
; when a team reached (n+1)/2 wins blanks the remaining games (FFh teams) and
; rewrites both team records
;-----------------------------------------------------------------------------
; C: src/front/season/UpdatePlayoffSeries.c
%ifdef CBUILD
%include "c/front/season/UpdatePlayoffSeries.inc"
%else
UpdatePlayoffSeries:
        push dword 384h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, 370h
        mov edi, eax
        mov esi, edx
        mov dword [dword esp+0358h], ebx
        xor ebx, ebx
        mov ecx, 1Ah
        xor edx, edx
        lea eax, [dword esp+02E8h]
        call __STOSD
        mov edx, dword [dword esp+0358h]
        cmp edx, 47Ch
        jge short .1
        mov dword [dword esp+0360h], ebx
        jmp short .4
.1:
        cmp edx, 498h
        jge short .2
        mov dword [dword esp+0360h], 7
        jmp short .4
.2:
        cmp edx, 4A6h
        jge short .3
        mov dword [dword esp+0360h], 0Eh
        jmp short .4
.3:
        cmp edx, 4ADh
        jge short .4
        mov dword [dword esp+0360h], 15h
.4:
        mov eax, dword [dword esp+0358h]
        sub eax, 444h
        mov dword [dword esp+0358h], eax
        mov ecx, 7
        mov edx, eax
        sar edx, 1Fh
        idiv ecx
        mov eax, dword [dword esp+0358h]
        sub eax, edx
        mov dword [dword esp+0364h], eax
        xor edx, edx
        mov dword [dword esp+0368h], edx
        xor ecx, ecx
        jmp short .8
.5:
        mov ebx, dword [dword esp+0364h]
        add ebx, 444h
        add ebx, ecx
        lea edx, [dword esp+0350h]
        mov eax, edi
        call ReadSchedGame
        mov ebx, eax
        test eax, eax
        jne short .7
        test ecx, ecx
        jne short .6
        movzx ebp, byte [dword esp+0352h]
        mov al, byte [dword esp+0353h]
        mov dword [dword esp+036Ch], eax
.6:
        cmp byte [dword esp+0352h], 0FFh
        je short .7
        cmp byte [dword esp+0353h], 0FFh
        je short .7
        inc dword [dword esp+0368h]
.7:
        inc ecx
.8:
        cmp ecx, byte 7
        jge short .9
        test ebx, ebx
        je short UpdatePlayoffSeries.5
.9:
        mov edx, dword [dword esp+0368h]
        inc edx
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov dword [dword esp+035Ch], eax
        xor ecx, ecx
        jmp near .19
.10:
        jne near .15
        mov eax, dword [dword esp+ebp*4+02E8h]
        mov ebx, dword [dword esp+035Ch]
        cmp eax, ebx
        je short .11
        mov eax, dword [dword esp+036Ch]
        cmp ebx, dword [dword esp+eax*4+02E8h]
        jne near .15
.11:
        mov dl, 0FFh
        mov byte [dword esp+0350h], dl
        mov byte [dword esp+0351h], dl
        mov byte [dword esp+0354h], dl
        mov byte [dword esp+0355h], dl
        mov ebx, dword [dword esp+0364h]
        add ebx, 444h
        add ebx, ecx
        lea edx, [dword esp+0350h]
        mov eax, edi
        call WriteSchedGame
        mov ebx, eax
        test eax, eax
        jne short .12
        mov ebx, ebp
        mov edx, esp
        mov eax, esi
        call ReadTeamRec
        mov ebx, eax
.12:
        test ebx, ebx
        jne short .13
        mov eax, dword [dword esp+0360h]
        add eax, ecx
        mov dword [dword esp+eax*4+026Ch], 0FFFFFFFFh
        mov ebx, ebp
        mov edx, esp
        mov eax, esi
        call WriteTeamRec
        mov ebx, eax
.13:
        test ebx, ebx
        jne short .14
        mov ebx, dword [dword esp+036Ch]
        mov edx, esp
        mov eax, esi
        call ReadTeamRec
        mov ebx, eax
.14:
        test ebx, ebx
        jne near .18
        mov eax, dword [dword esp+0360h]
        add eax, ecx
        mov dword [dword esp+eax*4+026Ch], 0FFFFFFFFh
        mov ebx, dword [dword esp+036Ch]
        mov edx, esp
        mov eax, esi
        call WriteTeamRec
        mov ebx, eax
        jmp short .18
.15:
        mov ebx, dword [dword esp+0364h]
        add ebx, 444h
        add ebx, ecx
        lea edx, [dword esp+0350h]
        mov eax, edi
        call ReadSchedGame
        mov ebx, eax
        mov dh, byte [dword esp+0354h]
        cmp dh, 0FFh
        je short .18
        mov al, byte [dword esp+0355h]
        cmp al, 0FFh
        je short .18
        cmp dh, al
        jbe short .16
        xor eax, eax
        mov al, byte [dword esp+0352h]
        jmp short .17
.16:
        xor eax, eax
        mov al, byte [dword esp+0353h]
.17:
        inc dword [dword esp+eax*4+02E8h]
.18:
        inc ecx
.19:
        cmp ecx, dword [dword esp+0368h]
        jge short .20
        test ebx, ebx
        je near UpdatePlayoffSeries.10
.20:
        mov eax, ebx
        add esp, 370h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
        db 08Bh,0C0h
SeriesLength_jt:
        dd SeriesLength_bo1
        dd SeriesLength_bo3
        dd SeriesLength_n3
        dd SeriesLength_n4
        dd SeriesLength_n4
        dd SeriesLength_bo7
        dd SeriesLength_bo7
;-----------------------------------------------------------------------------
; SeriesLength                                 42221  95 PC, medium confidence
; Counts the scheduled games of a 7-slot series (until FFh) and returns
; best-of 1/3/5/7, checking SeriesWinner for the 3/5 cases
;-----------------------------------------------------------------------------
SeriesLength:
        push dword 10h
        call __CHK
        push ecx
        push edx
        push esi
        mov ecx, eax
        xor edx, edx
.1:
        mov eax, edx
        shl eax, 2
        sub eax, edx
        cmp byte [ecx+eax*2], 0FFh
        je short .2
        inc edx
        cmp edx, byte 7
        jl short SeriesLength.1
.2:
        lea eax, [byte edx-01h]
        cmp eax, byte 6
        ja short SeriesLength_bo1.4
        jmp dword [nosplit cs:eax*4+SeriesLength_jt]
SeriesLength_bo1:
        mov esi, 1
.4:
        mov eax, esi
        pop esi
        pop edx
        pop ecx
        ret
SeriesLength_bo3:
        mov esi, 3
        jmp short SeriesLength_bo1.4
SeriesLength_n3:
        mov edx, 5
        mov eax, ecx
        call SeriesWinner
        test eax, eax
        jl short SeriesLength_bo3
.7:
        mov esi, 5
        jmp short SeriesLength_bo1.4
SeriesLength_n4:
        mov edx, 7
        mov eax, ecx
        call SeriesWinner
        test eax, eax
        jl short SeriesLength_n3.7
SeriesLength_bo7:
        mov esi, 7
        jmp short SeriesLength_bo1.4
;-----------------------------------------------------------------------------
; RandomizeSchedule                            42295  95 PC, medium confidence
; CreateNewLeague: 'Generating random schedule. Please wait.' when asked,
; shuffles the teams inside each division (divisionteams, 12 rand swaps per
; division) and remaps every SCHEDULE.DB game and TEAMS.DB record to the
; shuffled teams
;-----------------------------------------------------------------------------
RandomizeSchedule:
        push dword 3D4h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, 3A0h
        push eax
        push edx
        mov edx, 0FFFFFFFFh
        mov dword [dword esp+039Ch], edx
        mov dword [dword esp+03A0h], edx
        cmp dword [esp], byte 0
        je near .4
        push byte 0
        push byte 0
        push byte 0
        push byte 0
        push byte 0
        mov ecx, 2
        mov ebx, msg_GenSchedule
        mov eax, edx
        call MessageBox
        mov ecx, 1Ah
        xor edx, edx
        lea eax, [dword esp+02F0h]
        call __STOSD
        xor edi, edi
.1:
        xor ebx, ebx
.2:
        mov eax, edi
        shl eax, 3
        sub eax, edi
        add eax, ebx
        mov dl, byte [dword eax+divisionteams]
        mov byte [dword esp+eax+0378h], dl
        inc ebx
        cmp ebx, byte 7
        jl short RandomizeSchedule.2
        cmp edi, byte 2
        setge al
        movzx ebp, al
        add ebp, byte 6
        xor ebx, ebx
.3:
        call rand_
        mov edx, eax
        sar edx, 1Fh
        idiv ebp
        mov esi, edx
        call rand_
        mov edx, eax
        sar edx, 1Fh
        idiv ebp
        mov ecx, edx
        mov eax, edi
        shl eax, 3
        sub eax, edi
        add esi, eax
        mov dl, byte [dword esp+esi+0378h]
        add ecx, eax
        mov al, byte [dword esp+ecx+0378h]
        mov byte [dword esp+esi+0378h], al
        mov byte [dword esp+ecx+0378h], dl
        inc ebx
        cmp ebx, byte 0Ch
        jl short RandomizeSchedule.3
        inc edi
        cmp edi, byte 4
        jl short RandomizeSchedule.1
.4:
        mov ebx, dword [leaguedbnames+18h]
        mov ecx, str_extDB
        mov edx, dword [byte esp+04h]
        lea eax, [dword esp+0358h]
        call MakePath
        lea edx, [dword esp+039Ch]
        lea eax, [dword esp+0358h]
        call FileOpenRW
        mov edx, eax
        test eax, eax
        jne short .5
        mov ebx, dword [leaguedbnames+10h]
        mov ecx, str_extDB
        mov edx, dword [byte esp+04h]
        lea eax, [dword esp+0358h]
        call MakePath
        lea edx, [dword esp+03A0h]
        lea eax, [dword esp+0358h]
        call FileOpenRW
        mov edx, eax
.5:
        test edx, edx
        jne near .19
        xor edi, edi
        jmp near .15
.6:
        mov ebx, edi
        lea edx, [dword esp+0394h]
        mov eax, dword [dword esp+039Ch]
        call ReadSchedGame
        mov edx, eax
        test eax, eax
        jne near .14
        movzx esi, byte [dword esp+0396h]
        xor ecx, ecx
        mov cl, byte [dword esp+0397h]
        xor ebx, ebx
.7:
        mov al, byte [dword esi+teamdivision]
        mov dl, byte [dword esi+teamdivslot]
        test esi, esi
        jl short .8
        and eax, 0FFh
        mov dword [dword esp+03A4h], eax
        shl eax, 3
        sub eax, dword [dword esp+03A4h]
        and edx, 0FFh
        add eax, edx
        xor edx, edx
        mov dl, byte [dword eax+divisionteams]
        cmp esi, edx
        jne short .8
        mov al, byte [dword esp+eax+0378h]
        mov byte [dword esp+0396h], al
        mov esi, 0FFFFFFFFh
.8:
        mov al, byte [dword ecx+teamdivision]
        mov dl, byte [dword ecx+teamdivslot]
        test ecx, ecx
        jl short .9
        and eax, 0FFh
        mov dword [dword esp+03A4h], eax
        shl eax, 3
        sub eax, dword [dword esp+03A4h]
        and edx, 0FFh
        add eax, edx
        xor edx, edx
        mov dl, byte [dword eax+divisionteams]
        cmp ecx, edx
        jne short .9
        mov al, byte [dword esp+eax+0378h]
        mov byte [dword esp+0397h], al
        mov ecx, 0FFFFFFFFh
.9:
        test esi, esi
        jge short .10
        test ecx, ecx
        jge short .10
        mov ebx, 1Ah
.10:
        inc ebx
        cmp ebx, byte 1Ah
        jl near RandomizeSchedule.7
        mov ebx, edi
        lea edx, [dword esp+0394h]
        mov eax, dword [dword esp+039Ch]
        call WriteSchedGame
        mov edx, eax
        test eax, eax
        jne short .11
        movzx esi, byte [dword esp+0396h]
        xor ecx, ecx
        mov cl, byte [dword esp+0397h]
        mov ebx, esi
        lea edx, [byte esp+08h]
        mov eax, dword [dword esp+03A0h]
        call ReadTeamRec
        mov edx, eax
.11:
        test edx, edx
        jne short .12
        mov eax, edi
        shl eax, 2
        sub eax, edi
        add eax, eax
        lea ebx, [byte eax+02h]
        mov edx, dword [dword esp+esi*4+02F0h]
        mov dword [dword esp+edx*4+0124h], ebx
        inc edx
        mov dword [dword esp+esi*4+02F0h], edx
        mov ebx, esi
        lea edx, [byte esp+08h]
        mov eax, dword [dword esp+03A0h]
        call WriteTeamRec
        mov edx, eax
.12:
        test edx, edx
        jne short .13
        mov ebx, ecx
        lea edx, [byte esp+08h]
        mov eax, dword [dword esp+03A0h]
        call ReadTeamRec
        mov edx, eax
.13:
        test edx, edx
        jne short .14
        mov eax, edi
        shl eax, 2
        sub eax, edi
        add eax, eax
        lea ebx, [byte eax+02h]
        mov edx, dword [dword esp+ecx*4+02F0h]
        mov dword [dword esp+edx*4+0124h], ebx
        lea ebx, [byte edx+01h]
        mov dword [dword esp+ecx*4+02F0h], ebx
        mov ebx, ecx
        lea edx, [byte esp+08h]
        mov eax, dword [dword esp+03A0h]
        call WriteTeamRec
        mov edx, eax
.14:
        inc edi
.15:
        cmp edi, 444h
        jge short .16
        test edx, edx
        jne short .16
        cmp dword [esp], byte 0
        jne near RandomizeSchedule.6
.16:
        mov ah, 0FFh
        mov byte [dword esp+0394h], ah
        mov byte [dword esp+0395h], ah
        mov byte [dword esp+0396h], ah
        mov byte [dword esp+0397h], ah
        mov byte [dword esp+0398h], ah
        mov byte [dword esp+0399h], ah
        mov edi, 444h
        jmp short .18
.17:
        mov ebx, edi
        lea edx, [dword esp+0394h]
        mov eax, dword [dword esp+039Ch]
        call WriteSchedGame
        mov edx, eax
        inc edi
.18:
        cmp edi, 4ADh
        jge short .19
        test edx, edx
        je short RandomizeSchedule.17
.19:
        lea eax, [dword esp+03A0h]
        call FileClose
        lea eax, [dword esp+039Ch]
        call FileClose
        call RestoreDialogBg
        mov eax, edx
        add esp, 3A8h
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; SimScheduleDay                               42631  95 PC, medium confidence
; Simulates (SimulateGame) every unplayed game up to the given game's date
; that the flags select (bit 0 two human teams, bit 1 one, bit 2 none); with
; flags 7 and no human games left it plays out the rest of the 444h
; regular-season games and calls BuildPlayoffs
;-----------------------------------------------------------------------------
; C: src/front/season/SimScheduleDay.c
%ifdef CBUILD
%include "c/front/season/SimScheduleDay.inc"
%else
SimScheduleDay:
        push dword 40h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 24h
        mov edi, eax
        mov dword [byte esp+01Ch], edx
        mov dword [byte esp+0Ch], ebx
        mov ebp, dword [byte esp+034h]
        xor edx, edx
        mov dword [byte esp+010h], edx
        lea ebx, [byte ecx-01h]
        mov edx, esp
        call ReadSchedGame
        mov ebx, eax
        test eax, eax
        jne near .19
        xor edx, edx
        mov dl, byte [byte esp+01h]
        mov al, byte [esp]
        call DateKey
        mov dword [byte esp+014h], eax
        xor ecx, ecx
        mov dword [byte esp+018h], ecx
        xor esi, esi
        jmp near .12
.1:
        mov ebx, esi
        mov edx, esp
        mov eax, edi
        call ReadSchedGame
        mov ebx, eax
        test eax, eax
        jne near .11
        xor edx, edx
        mov dl, byte [byte esp+01h]
        mov al, byte [esp]
        call DateKey
        cmp eax, dword [byte esp+014h]
        jg near .9
        mov dword [byte esp+018h], esi
        xor edx, edx
        xor eax, eax
        mov al, byte [byte esp+02h]
        mov dword [byte esp+08h], eax
        shl eax, 4
        sub eax, dword [byte esp+08h]
        cmp byte [byte ebp+eax*2+017h], 1
        jne short .2
        mov edx, 1
.2:
        xor eax, eax
        mov al, byte [byte esp+03h]
        mov dword [byte esp+08h], eax
        shl eax, 4
        sub eax, dword [byte esp+08h]
        cmp byte [byte ebp+eax*2+017h], 1
        jne short .3
        inc edx
.3:
        cmp byte [byte esp+04h], 0FFh
        je short .4
        cmp byte [byte esp+05h], 0FFh
        jne near .11
.4:
        cmp dword [byte esp+040h], byte 0FFFFFFFFh
        je short .5
        xor eax, eax
        mov al, byte [byte esp+02h]
        mov ecx, dword [byte esp+040h]
        cmp eax, ecx
        je short .5
        xor eax, eax
        mov al, byte [byte esp+03h]
        cmp eax, ecx
        jne near .11
.5:
        test byte [byte esp+044h], 1
        je short .6
        cmp edx, byte 2
        je short .8
.6:
        test byte [byte esp+044h], 4
        je short .7
        test edx, edx
        je short .8
.7:
        test byte [byte esp+044h], 2
        je near .11
        cmp edx, byte 1
        jne near .11
.8:
        push byte 0FFFFFFFFh
        mov eax, dword [byte esp+010h]
        push eax
        mov edx, dword [byte esp+024h]
        push edx
        lea ecx, [byte esp+0Ch]
        mov ebx, esi
        mov edx, dword [byte esp+048h]
        mov eax, dword [byte esp+044h]
        call SimulateGame
        mov ebx, eax
        test eax, eax
        jne short .11
        mov ebx, esi
        mov edx, esp
        mov eax, edi
        call WriteSchedGame
        mov ebx, eax
        jmp short .11
.9:
        mov ah, byte [byte esp+02h]
        cmp ah, 0FFh
        je short .11
        cmp byte [byte esp+03h], 0FFh
        je short .11
        xor edx, edx
        mov dl, ah
        mov eax, edx
        shl eax, 4
        sub eax, edx
        cmp byte [byte ebp+eax*2+017h], 1
        je short .10
        xor edx, edx
        mov dl, byte [byte esp+03h]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        cmp byte [byte ebp+eax*2+017h], 1
        jne short .11
.10:
        mov dword [byte esp+010h], 1
.11:
        inc esi
.12:
        cmp esi, 444h
        jge short .13
        cmp dword [byte esp+010h], byte 0
        jne short .13
        test ebx, ebx
        je near SimScheduleDay.1
.13:
        cmp dword [byte esp+044h], byte 7
        jne near .19
        cmp dword [byte esp+010h], byte 0
        jne near .19
        test ebx, ebx
        jne near .19
        mov esi, dword [byte esp+018h]
        cmp esi, 444h
        jge near .19
        mov dword [byte esp+020h], 444h
        mov ecx, 2
        lea edx, [byte esp+020h]
        mov eax, edi
        call FileWriteAt
        mov ebx, eax
        jmp short .17
.14:
        mov ebx, esi
        mov edx, esp
        mov eax, edi
        call ReadSchedGame
        mov ebx, eax
        test eax, eax
        jne short .16
        cmp byte [byte esp+04h], 0FFh
        je short .15
        cmp byte [byte esp+05h], 0FFh
        jne short .16
.15:
        push byte 0FFFFFFFFh
        mov eax, dword [byte esp+010h]
        push eax
        mov edx, dword [byte esp+024h]
        push edx
        lea ecx, [byte esp+0Ch]
        mov ebx, esi
        mov edx, dword [byte esp+048h]
        mov eax, dword [byte esp+044h]
        call SimulateGame
        mov ebx, eax
        test eax, eax
        jne short .16
        mov ebx, esi
        mov edx, esp
        mov eax, edi
        call WriteSchedGame
        mov ebx, eax
.16:
        inc esi
.17:
        cmp esi, 444h
        jge short .18
        test ebx, ebx
        je short SimScheduleDay.14
.18:
        mov ebx, dword [byte esp+03Ch]
        push ebx
        mov ecx, dword [byte esp+03Ch]
        push ecx
        mov ecx, ebp
        mov ebx, dword [byte esp+014h]
        mov edx, dword [byte esp+024h]
        mov eax, edi
        call BuildPlayoffs
        mov ebx, eax
.19:
        mov eax, ebx
        add esp, byte 24h
        pop ebp
        pop edi
        pop esi
        ret 14h
%endif ; C
;-----------------------------------------------------------------------------
; BuildPlayoffs                                428AB  95 PC, medium confidence
; GetPlayoffSeeds, allocates 69h (105) playoff games set to FFh,
; SeedPlayoffRound1; with no human team in the playoffs simulates every round
; (Sim/Seed round functions); writes the games after game 444h and the 'sche'
; SEASON data
;-----------------------------------------------------------------------------
; C: src/front/season/UpdateSeasonSchedule.c (BuildPlayoffs)
%ifdef CBUILD
%include "c/front/season/UpdateSeasonSchedule.BuildPlayoffs.inc"
%else
BuildPlayoffs:
        push dword 0C0h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, 0A0h
        push eax
        mov ebp, edx
        mov dword [dword esp+098h], ebx
        mov edi, ecx
        xor edx, edx
        mov dword [dword esp+094h], edx
        mov ebx, ebp
        mov edx, eax
        lea eax, [byte esp+04h]
        call GetPlayoffSeeds
        test eax, eax
        je short .1
        mov ebx, eax
        jmp near .10
.1:
        push byte 20h
        push dword 276h
        push str_sche
        call AllocMemBlock
        add esp, byte 0Ch
        mov esi, eax
        xor edx, edx
.2:
        mov eax, edx
        shl eax, 2
        sub eax, edx
        mov byte [byte esi+eax*2+05h], 0FFh
        mov bl, byte [byte esi+eax*2+05h]
        mov byte [byte esi+eax*2+04h], bl
        mov byte [byte esi+eax*2+03h], bl
        mov byte [byte esi+eax*2+02h], bl
        mov byte [byte esi+eax*2+01h], bl
        mov byte [esi+eax*2], bl
        inc edx
        cmp edx, byte 69h
        jl short BuildPlayoffs.2
        xor edx, edx
.3:
        mov ebx, edx
        shl ebx, 2
        mov ecx, dword [byte esp+ebx+04h]
        mov eax, ecx
        shl eax, 4
        sub eax, ecx
        cmp byte [byte edi+eax*2+017h], 1
        jne short .5
.4:
        mov dword [dword esp+094h], 1
        jmp short .6
.5:
        mov ebx, dword [byte esp+ebx+03Ch]
        mov eax, ebx
        shl eax, 4
        sub eax, ebx
        cmp byte [byte edi+eax*2+017h], 1
        je short BuildPlayoffs.4
        inc edx
        cmp edx, byte 8
        jl short BuildPlayoffs.3
.6:
        mov ecx, dword [gameopts]
        shl ecx, 11h
        shr ecx, 1Dh
        cmp dword [dword esp+094h], byte 0
        je short .7
        push edi
        mov ebx, ebp
        mov edx, esi
        lea eax, [byte esp+08h]
        call SeedPlayoffRound1
        mov dword [dword esp+09Ch], eax
        test eax, eax
        jne near .9
        mov ecx, 276h
        mov ebx, 199Ah
        mov edx, esi
        jmp near .8
.7:
        push edi
        mov ebx, ebp
        mov edx, esi
        lea eax, [byte esp+08h]
        call SeedPlayoffRound1
        mov dword [dword esp+09Ch], eax
        test eax, eax
        jne near .9
        mov edx, dword [dword esp+0B8h]
        push edx
        mov ecx, dword [dword esp+0B8h]
        mov ebx, dword [dword esp+09Ch]
        mov edx, ebp
        mov eax, esi
        call SimPlayoffRound1
        mov dword [dword esp+09Ch], eax
        test eax, eax
        jne near .9
        lea eax, [dword esp+094h]
        push eax
        mov edx, dword [gameopts]
        shl edx, 11h
        shr edx, 1Dh
        mov ecx, edi
        mov ebx, ebp
        mov eax, esi
        call SeedPlayoffRound2
        mov dword [dword esp+09Ch], eax
        test eax, eax
        jne near .9
        mov ebx, dword [dword esp+0B8h]
        push ebx
        mov ecx, dword [dword esp+0B8h]
        mov ebx, dword [dword esp+09Ch]
        mov edx, ebp
        mov eax, esi
        call SimPlayoffRound2
        mov dword [dword esp+09Ch], eax
        test eax, eax
        jne near .9
        lea eax, [dword esp+094h]
        push eax
        mov edx, dword [gameopts]
        shl edx, 11h
        shr edx, 1Dh
        mov ecx, edi
        mov ebx, ebp
        mov eax, esi
        call SeedPlayoffRound3
        mov dword [dword esp+09Ch], eax
        test eax, eax
        jne near .9
        mov ecx, dword [dword esp+0B8h]
        push ecx
        mov ecx, dword [dword esp+0B8h]
        mov ebx, dword [dword esp+09Ch]
        mov edx, ebp
        mov eax, esi
        call SimPlayoffRound3
        mov dword [dword esp+09Ch], eax
        test eax, eax
        jne near .9
        lea eax, [dword esp+094h]
        push eax
        mov eax, dword [byte esp+04h]
        push eax
        mov edx, dword [gameopts]
        shl edx, 11h
        shr edx, 1Dh
        mov ecx, edi
        mov ebx, ebp
        mov eax, esi
        call SeedPlayoffFinal
        mov dword [dword esp+09Ch], eax
        test eax, eax
        jne near .9
        mov edx, dword [dword esp+0B8h]
        push edx
        mov ecx, dword [dword esp+0B8h]
        mov ebx, dword [dword esp+09Ch]
        mov edx, ebp
        mov eax, esi
        call SimPlayoffFinal
        mov dword [dword esp+09Ch], eax
        test eax, eax
        jne near .9
        mov ecx, 276h
        mov ebx, 199Ah
        mov edx, esi
        mov eax, dword [esp]
        call FileWriteAt
        mov dword [dword esp+09Ch], eax
        test eax, eax
        jne short .9
        mov ebx, dword [leaguedbnames+14h]
        mov ecx, dword [dword esp+0B8h]
        mov edx, dword [dword esp+0B4h]
        lea eax, [byte esp+074h]
        call MakePath
        mov ebx, dword [seasondb_size]
        push ebx
        mov ecx, dword [seasondb]
        push ecx
        lea eax, [byte esp+07Ch]
        push eax
        call WriteFile
        add esp, byte 0Ch
        call AwardsCeremony
        mov byte [byte_DE268], 0FFh
        mov dword [dword esp+0A0h], 4ADh
        mov ecx, 2
        xor ebx, ebx
        lea edx, [dword esp+0A0h]
.8:
        mov eax, dword [esp]
        call FileWriteAt
        mov dword [dword esp+09Ch], eax
.9:
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov ebx, dword [dword esp+09Ch]
.10:
        mov eax, ebx
        add esp, 0A4h
        jmp near UpdateSeasonSchedule_pop3
%endif ; C
;-----------------------------------------------------------------------------
; GetPlayoffSeeds                              42BBA  95 PC, medium confidence
; Reads the TEAMS.DB records of each conference's teams (lists C55E9 / C5619,
; 0Ch each), ranks them on points (2*W+T), wins and goals (SortStandings),
; and moves a team so the top two are not from the same pair (teamdivflags
; flags)
;-----------------------------------------------------------------------------
; C: src/front/season/GetPlayoffSeeds.c
%ifdef CBUILD
%include "c/front/season/GetPlayoffSeeds.inc"
%else
GetPlayoffSeeds:
        push dword 3E4h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, 3C8h
        mov edi, eax
        mov ebp, ebx
        xor ecx, ecx
.1:
        mov esi, ecx
        shl esi, 2
        mov ebx, dword [dword esi+confteams]
        mov edx, esp
        mov eax, ebp
        call ReadTeamRec
        test eax, eax
        jne near .x
        mov edx, dword [dword esi+confteams]
        mov dword [edi+esi], edx
        mov al, byte [byte esp+029h]
        lea edx, [eax+eax]
        xor ebx, ebx
        mov bl, byte [byte esp+02Bh]
        add edx, ebx
        mov dword [dword esp+esi+0390h], edx
        mov dword [dword esp+esi+02E8h], eax
        xor eax, eax
        mov ax, word [byte esp+02Ch]
        mov dword [dword esp+esi+0358h], eax
        xor eax, eax
        mov ax, word [byte esp+02Eh]
        mov dword [dword esp+esi+0320h], eax
        inc ecx
        cmp ecx, byte 0Ch
        jl short GetPlayoffSeeds.1
        push byte 0Ch
        lea eax, [dword esp+0324h]
        push eax
        lea ecx, [dword esp+0360h]
        lea ebx, [dword esp+02F0h]
        lea edx, [dword esp+0398h]
        mov eax, edi
        call SortStandings
        mov edx, dword [byte edi+04h]
        mov eax, dword [edi]
        mov eax, dword [nosplit eax*4+teamdivflags]
        or eax, dword [nosplit edx*4+teamdivflags]
        cmp eax, byte 3
        je short .6
        mov ecx, 2
.2:
        mov eax, ecx
        mov eax, dword [edi+eax*4]
        mov esi, dword [edi]
        mov esi, dword [nosplit esi*4+teamdivflags]
        or esi, dword [nosplit eax*4+teamdivflags]
        cmp esi, byte 3
        je short .3
        inc ecx
        cmp ecx, byte 0Ch
        jl short GetPlayoffSeeds.2
.3:
        mov edx, ecx
        mov edx, dword [edi+edx*4]
        jmp short .5
.4:
        mov esi, ecx
        mov eax, dword [byte edi+esi*4-04h]
        mov dword [edi+esi*4], eax
        dec ecx
.5:
        cmp ecx, byte 2
        jge short GetPlayoffSeeds.4
        mov dword [byte edi+04h], edx
.6:
        xor ecx, ecx
.7:
        mov esi, ecx
        shl esi, 2
        mov ebx, dword [dword esi+poconf2teams]
        mov edx, esp
        mov eax, ebp
        call ReadTeamRec
        test eax, eax
        jne near .x
        mov edx, dword [dword esi+poconf2teams]
        mov dword [byte edi+esi+038h], edx
        mov al, byte [byte esp+029h]
        lea edx, [eax+eax]
        xor ebx, ebx
        mov bl, byte [byte esp+02Bh]
        add edx, ebx
        mov dword [dword esp+esi+0390h], edx
        mov dword [dword esp+esi+02E8h], eax
        xor eax, eax
        mov ax, word [byte esp+02Ch]
        mov dword [dword esp+esi+0358h], eax
        xor eax, eax
        mov ax, word [byte esp+02Eh]
        mov dword [dword esp+esi+0320h], eax
        inc ecx
        cmp ecx, byte 0Eh
        jl short GetPlayoffSeeds.7
        push byte 0Eh
        lea eax, [dword esp+0324h]
        push eax
        lea eax, [byte edi+038h]
        lea ecx, [dword esp+0360h]
        lea ebx, [dword esp+02F0h]
        lea edx, [dword esp+0398h]
        call SortStandings
        mov eax, dword [byte edi+038h]
        mov edx, dword [byte edi+03Ch]
        mov eax, dword [nosplit eax*4+teamdivflags]
        or eax, dword [nosplit edx*4+teamdivflags]
        cmp eax, byte 0Ch
        je short .12
        mov ecx, 2
.8:
        mov eax, ecx
        mov eax, dword [byte edi+eax*4+038h]
        mov esi, dword [byte edi+038h]
        mov esi, dword [nosplit esi*4+teamdivflags]
        or esi, dword [nosplit eax*4+teamdivflags]
        cmp esi, byte 0Ch
        je short .9
        inc ecx
        cmp ecx, byte 0Eh
        jl short GetPlayoffSeeds.8
.9:
        mov edx, ecx
        mov edx, dword [byte edi+edx*4+038h]
        jmp short .11
.10:
        mov esi, ecx
        mov eax, dword [byte edi+esi*4+034h]
        mov dword [byte edi+esi*4+038h], eax
        dec ecx
.11:
        cmp ecx, byte 2
        jge short GetPlayoffSeeds.10
        mov dword [byte edi+03Ch], edx
.12:
        xor eax, eax
.x:
        add esp, 3C8h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SortStandings                                42DAA  95 PC, medium confidence
; Orders team indexes by points, then wins, then goals for/against (arrays
; passed in), swapping with SwapInt
;-----------------------------------------------------------------------------
; C: src/front/season/UpdateSeasonSchedule.c (SortStandings)
%ifdef CBUILD
%include "c/front/season/UpdateSeasonSchedule.SortStandings.inc"
%else
SortStandings:
        push dword 38h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 18h
        push eax
        push edx
        push ebx
        push ecx
        xor esi, esi
        jmp near .11
.1:
        lea ecx, [byte esi+01h]
        jmp near .10
.2:
        mov ebx, ecx
        shl ebx, 2
        mov edi, dword [byte esp+08h]
        add edi, ebx
        mov eax, esi
        shl eax, 2
        mov dword [byte esp+024h], eax
        mov eax, dword [byte esp+08h]
        mov ebp, dword [byte esp+024h]
        add eax, ebp
        mov dword [byte esp+018h], eax
        mov eax, dword [byte esp+0Ch]
        add eax, ebx
        mov edx, dword [edi]
        mov ebp, dword [byte esp+018h]
        cmp edx, dword [byte ebp+00h]
        jle short .4
.3:
        mov eax, dword [eax]
        jmp near .8
.4:
        mov edx, dword [byte esp+0Ch]
        add edx, dword [byte esp+024h]
        mov edi, dword [edi]
        mov ebp, dword [byte esp+018h]
        cmp edi, dword [byte ebp+00h]
        jge short .6
.5:
        mov eax, dword [edx]
        jmp near .8
.6:
        mov edi, dword [byte esp+04h]
        add edi, ebx
        mov dword [byte esp+01Ch], edi
        mov edi, dword [byte esp+04h]
        mov ebp, dword [byte esp+024h]
        add edi, ebp
        mov dword [byte esp+014h], edi
        mov edi, dword [byte esp+01Ch]
        mov edi, dword [edi]
        mov ebp, dword [byte esp+014h]
        cmp edi, dword [byte ebp+00h]
        jg short SortStandings.3
        mov edi, dword [byte esp+01Ch]
        mov edi, dword [edi]
        cmp edi, dword [byte ebp+00h]
        jl short SortStandings.5
        mov edi, dword [esp]
        add edi, ebx
        mov dword [byte esp+010h], edi
        mov edi, dword [esp]
        mov ebp, dword [byte esp+024h]
        add edi, ebp
        mov dword [byte esp+020h], edi
        mov edi, dword [byte esp+010h]
        mov edi, dword [edi]
        mov ebp, dword [byte esp+020h]
        cmp edi, dword [byte ebp+00h]
        jg short SortStandings.3
        mov edi, dword [byte esp+010h]
        mov edi, dword [edi]
        cmp edi, dword [byte ebp+00h]
        jl short SortStandings.5
        mov edi, dword [byte esp+038h]
        add ebx, edi
        add edi, dword [byte esp+024h]
        mov ebp, dword [ebx]
        cmp ebp, dword [edi]
        jg short SortStandings.5
        mov ebx, ebp
        cmp ebx, dword [edi]
        jl near SortStandings.3
        mov ebx, dword [eax]
        mov edi, dword [edx]
        cmp ebx, edi
        jle short .7
        mov eax, ebx
        jmp short .8
.7:
        mov eax, edi
.8:
        mov edx, ecx
        shl edx, 2
        mov ebp, dword [byte esp+0Ch]
        add edx, ebp
        cmp eax, dword [edx]
        jne short .9
        mov ebx, ebp
        mov edx, ecx
        mov eax, esi
        call SwapInt
        mov ebx, dword [byte esp+08h]
        mov edx, ecx
        mov eax, esi
        call SwapInt
        mov ebx, dword [byte esp+04h]
        mov edx, ecx
        mov eax, esi
        call SwapInt
        mov ebx, dword [esp]
        mov edx, ecx
        mov eax, esi
        call SwapInt
        mov ebx, dword [byte esp+038h]
        mov edx, ecx
        mov eax, esi
        call SwapInt
.9:
        inc ecx
.10:
        cmp ecx, dword [byte esp+03Ch]
        jl near SortStandings.2
        inc esi
.11:
        mov eax, dword [byte esp+03Ch]
        dec eax
        cmp esi, eax
        jl near SortStandings.1
        add esp, byte 28h
        jmp near UpdateSeasonSchedule_pop3
%endif ; C
;-----------------------------------------------------------------------------
; SwapInt                                                         42F19  95 PC
; Xor-swaps two dwords of an array (array, i, j)
;-----------------------------------------------------------------------------
; C: src/front/season/SwapInt.c
%ifdef CBUILD
%include "c/front/season/SwapInt.inc"
%else
SwapInt:
        push dword 0Ch
        call __CHK
        push ecx
        push esi
        shl eax, 2
        add eax, ebx
        shl edx, 2
        add edx, ebx
        mov ebx, dword [edx]
        mov ecx, dword [eax]
        xor ecx, ebx
        mov dword [eax], ecx
        mov esi, dword [edx]
        xor esi, ecx
        mov dword [edx], esi
        xor dword [eax], esi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SetSeriesTeams                               42F42  95 PC, medium confidence
; Fills the home/away team bytes of a 7-game series for best-of 7/5/3/1
; (2-2-1-1-1, or 2-3-2 when both teams' teamdivflags flags OR to 3)
;-----------------------------------------------------------------------------
; C: src/front/season/SetSeriesTeams.c
%ifdef CBUILD
%include "c/front/season/SetSeriesTeams.inc"
%else
SetSeriesTeams:
        push dword 8
        call __CHK
        push esi
        mov esi, dword [nosplit edx*4+teamdivflags]
        or esi, dword [nosplit ebx*4+teamdivflags]
        cmp esi, byte 3
        jne short .1
        cmp ecx, byte 7
        jne short .1
        mov byte [byte eax+026h], dl
        mov byte [byte eax+020h], dl
        mov byte [byte eax+01Bh], dl
        mov byte [byte eax+015h], dl
        mov byte [byte eax+0Fh], dl
        mov byte [byte eax+08h], dl
        mov byte [byte eax+02h], dl
        mov byte [byte eax+027h], bl
        mov byte [byte eax+021h], bl
        mov byte [byte eax+01Ah], bl
        jmp short .3
.1:
        cmp ecx, byte 7
        jne short .4
        mov byte [byte eax+026h], dl
        mov byte [byte eax+021h], dl
        mov byte [byte eax+01Ah], dl
        mov byte [byte eax+015h], dl
        mov byte [byte eax+0Fh], dl
        mov byte [byte eax+08h], dl
        mov byte [byte eax+02h], dl
        mov byte [byte eax+027h], bl
        mov byte [byte eax+020h], bl
.2:
        mov byte [byte eax+01Bh], bl
.3:
        mov byte [byte eax+014h], bl
        mov byte [byte eax+0Eh], bl
        mov byte [byte eax+09h], bl
        mov byte [byte eax+03h], bl
        pop esi
        ret
.4:
        cmp ecx, byte 5
        jne short .5
        mov byte [byte eax+01Ah], dl
        mov byte [byte eax+015h], dl
        mov byte [byte eax+0Fh], dl
        mov byte [byte eax+08h], dl
        mov byte [byte eax+02h], dl
        jmp short SetSeriesTeams.2
.5:
        cmp ecx, byte 3
        jne short .6
        mov byte [byte eax+0Eh], dl
        mov byte [byte eax+09h], dl
        mov byte [byte eax+02h], dl
        mov byte [byte eax+0Fh], bl
        mov byte [byte eax+08h], bl
        mov byte [byte eax+03h], bl
        pop esi
        ret
.6:
        mov byte [byte eax+02h], dl
        mov byte [byte eax+03h], bl
        pop esi
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SeedPlayoffRound1                            42FED  95 PC, medium confidence
; Sets up the 8 first-round series from the seeds with SetSeriesTeams and
; updates the TEAMS.DB records (ReadTeamRec / WriteTeamRec)
;-----------------------------------------------------------------------------
; C: src/front/season/SimPlayoffRound1.c (SeedPlayoffRound1)
%ifdef CBUILD
%include "c/front/season/SimPlayoffRound1.SeedPlayoffRound1.inc"
%else
SeedPlayoffRound1:
        push dword 5FCh
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, 5ECh
        mov ebp, eax
        mov dword [dword esp+05E4h], edx
        mov esi, ebx
        mov edi, ecx
        xor edx, edx
        mov dword [dword esp+05D4h], edx
.1:
        mov edx, dword [dword esp+05D4h]
        shl edx, 2
        add edx, ebp
        mov ebx, dword [edx]
        mov eax, ebx
        shl eax, 4
        sub eax, ebx
        add eax, eax
        add eax, dword [dword esp+05FCh]
        cmp byte [byte eax+017h], 1
        jne short .2
        mov ebx, dword [edx]
        mov edx, esp
        mov eax, esi
        call ReadTeamRec
        test eax, eax
        jne near .23
.2:
        mov edx, dword [dword esp+05D4h]
        shl edx, 2
        add edx, ebp
        mov ebx, dword [byte edx+038h]
        mov eax, ebx
        shl eax, 4
        sub eax, ebx
        add eax, eax
        add eax, dword [dword esp+05FCh]
        cmp byte [byte eax+017h], 1
        jne short .3
        mov ebx, dword [byte edx+038h]
        lea edx, [dword esp+02E8h]
        mov eax, esi
        call ReadTeamRec
        test eax, eax
        jne near .23
.3:
        xor eax, eax
        mov ebx, 0FFFFFFFFh
.4:
        mov dword [dword esp+eax*4+0554h], ebx
        mov dword [dword esp+eax*4+026Ch], ebx
        inc eax
        cmp eax, byte 1Ch
        jl short SeedPlayoffRound1.4
        mov edx, dword [dword esp+05D4h]
        shl edx, 2
        add edx, ebp
        mov ebx, dword [edx]
        mov eax, ebx
        shl eax, 4
        sub eax, ebx
        add eax, eax
        add eax, dword [dword esp+05FCh]
        cmp byte [byte eax+017h], 1
        jne short .5
        mov edx, esp
        mov eax, esi
        call WriteTeamRec
        test eax, eax
        jne near .23
.5:
        mov edx, dword [dword esp+05D4h]
        shl edx, 2
        add edx, ebp
        mov ebx, dword [byte edx+038h]
        mov eax, ebx
        shl eax, 4
        sub eax, ebx
        add eax, eax
        add eax, dword [dword esp+05FCh]
        cmp byte [byte eax+017h], 1
        jne short .6
        mov ebx, dword [byte edx+038h]
        lea edx, [dword esp+02E8h]
        mov eax, esi
        call WriteTeamRec
        test eax, eax
        jne near .23
.6:
        mov ecx, dword [dword esp+05D4h]
        inc ecx
        mov dword [dword esp+05D4h], ecx
        cmp ecx, byte 8
        jl near SeedPlayoffRound1.1
        xor edx, edx
        mov dword [dword esp+05D4h], edx
.7:
        mov edx, dword [dword esp+05D4h]
        shl edx, 2
        add edx, ebp
        mov ebx, dword [edx]
        mov eax, ebx
        shl eax, 4
        sub eax, ebx
        add eax, eax
        add eax, dword [dword esp+05FCh]
        cmp byte [byte eax+017h], 1
        jne short .8
        mov ebx, dword [edx]
        mov edx, esp
        mov eax, esi
        call ReadTeamRec
        test eax, eax
        jne near .23
.8:
        mov edx, 7
        sub edx, dword [dword esp+05D4h]
        shl edx, 2
        add edx, ebp
        mov ebx, dword [edx]
        mov eax, ebx
        shl eax, 4
        sub eax, ebx
        add eax, eax
        add eax, dword [dword esp+05FCh]
        cmp byte [byte eax+017h], 1
        jne short .9
        mov ebx, dword [edx]
        lea edx, [dword esp+02E8h]
        mov eax, esi
        call ReadTeamRec
        test eax, eax
        jne near .23
.9:
        xor eax, eax
        jmp short .11
.10:
        mov ebx, dword [dword esp+05D4h]
        mov edx, ebx
        shl edx, 3
        sub edx, ebx
        add edx, 444h
        lea ebx, [edx+eax]
        mov edx, ebx
        shl edx, 2
        sub edx, ebx
        lea ebx, [byte edx+edx+02h]
        mov dword [dword esp+eax*4+0554h], ebx
        mov dword [dword esp+eax*4+026Ch], ebx
        inc eax
.11:
        cmp eax, edi
        jl short SeedPlayoffRound1.10
        mov edx, dword [dword esp+05D4h]
        shl edx, 2
        add edx, ebp
        mov ebx, dword [edx]
        mov eax, ebx
        shl eax, 4
        sub eax, ebx
        add eax, eax
        add eax, dword [dword esp+05FCh]
        cmp byte [byte eax+017h], 1
        jne short .12
        mov edx, esp
        mov eax, esi
        call WriteTeamRec
        test eax, eax
        jne near .23
.12:
        mov eax, 7
        sub eax, dword [dword esp+05D4h]
        shl eax, 2
        lea edx, [eax+ebp]
        mov ebx, dword [edx]
        mov eax, ebx
        shl eax, 4
        sub eax, ebx
        add eax, eax
        add eax, dword [dword esp+05FCh]
        cmp byte [byte eax+017h], 1
        jne short .13
        mov ebx, dword [edx]
        lea edx, [dword esp+02E8h]
        mov eax, esi
        call WriteTeamRec
        test eax, eax
        jne near .23
.13:
        mov ecx, dword [dword esp+05D4h]
        inc ecx
        mov dword [dword esp+05D4h], ecx
        cmp ecx, byte 4
        jl near SeedPlayoffRound1.7
        xor edx, edx
        mov dword [dword esp+05D4h], edx
.14:
        mov edx, dword [dword esp+05D4h]
        shl edx, 2
        add edx, ebp
        mov ebx, dword [byte edx+038h]
        mov eax, ebx
        shl eax, 4
        sub eax, ebx
        add eax, eax
        add eax, dword [dword esp+05FCh]
        cmp byte [byte eax+017h], 1
        jne short .15
        mov ebx, dword [byte edx+038h]
        mov edx, esp
        mov eax, esi
        call ReadTeamRec
        test eax, eax
        jne near .23
.15:
        mov eax, 7
        sub eax, dword [dword esp+05D4h]
        shl eax, 2
        lea edx, [eax+ebp]
        mov ebx, dword [byte edx+038h]
        mov eax, ebx
        shl eax, 4
        sub eax, ebx
        add eax, eax
        add eax, dword [dword esp+05FCh]
        cmp byte [byte eax+017h], 1
        jne short .16
        mov ebx, dword [byte edx+038h]
        lea edx, [dword esp+02E8h]
        mov eax, esi
        call ReadTeamRec
        test eax, eax
        jne near .23
.16:
        xor eax, eax
        jmp short .18
.17:
        mov ebx, dword [dword esp+05D4h]
        mov edx, ebx
        shl edx, 3
        sub edx, ebx
        add edx, 460h
        lea ebx, [edx+eax]
        mov edx, ebx
        shl edx, 2
        sub edx, ebx
        lea ebx, [byte edx+edx+02h]
        mov dword [dword esp+eax*4+0554h], ebx
        mov dword [dword esp+eax*4+026Ch], ebx
        inc eax
.18:
        cmp eax, edi
        jl short SeedPlayoffRound1.17
        mov edx, dword [dword esp+05D4h]
        shl edx, 2
        add edx, ebp
        mov ebx, dword [byte edx+038h]
        mov eax, ebx
        shl eax, 4
        sub eax, ebx
        add eax, eax
        add eax, dword [dword esp+05FCh]
        cmp byte [byte eax+017h], 1
        jne short .19
        mov edx, esp
        mov eax, esi
        call WriteTeamRec
        test eax, eax
        jne near .23
.19:
        mov eax, 7
        sub eax, dword [dword esp+05D4h]
        shl eax, 2
        lea edx, [eax+ebp]
        mov ebx, dword [byte edx+038h]
        mov eax, ebx
        shl eax, 4
        sub eax, ebx
        add eax, eax
        add eax, dword [dword esp+05FCh]
        cmp byte [byte eax+017h], 1
        jne short .20
        mov ebx, dword [byte edx+038h]
        lea edx, [dword esp+02E8h]
        mov eax, esi
        call WriteTeamRec
        test eax, eax
        jne near .23
.20:
        mov ecx, dword [dword esp+05D4h]
        inc ecx
        mov dword [dword esp+05D4h], ecx
        cmp ecx, byte 4
        jl near SeedPlayoffRound1.14
        mov ebx, dword [byte ebp+01Ch]
        mov edx, dword [byte ebp+00h]
        mov ecx, edi
        mov eax, dword [dword esp+05E4h]
        call SetSeriesTeams
        mov ebx, dword [byte ebp+018h]
        mov edx, dword [byte ebp+04h]
        mov eax, dword [dword esp+05E4h]
        add eax, byte 2Ah
        mov ecx, edi
        call SetSeriesTeams
        mov ebx, dword [byte ebp+014h]
        mov edx, dword [byte ebp+08h]
        mov eax, dword [dword esp+05E4h]
        add eax, byte 54h
        mov ecx, edi
        call SetSeriesTeams
        mov ebx, dword [byte ebp+010h]
        mov edx, dword [byte ebp+0Ch]
        mov eax, dword [dword esp+05E4h]
        add eax, byte 7Eh
        mov ecx, edi
        call SetSeriesTeams
        mov ebx, dword [byte ebp+054h]
        mov edx, dword [byte ebp+038h]
        mov eax, dword [dword esp+05E4h]
        add eax, 0A8h
        mov ecx, edi
        call SetSeriesTeams
        mov ebx, dword [byte ebp+050h]
        mov edx, dword [byte ebp+03Ch]
        mov eax, dword [dword esp+05E4h]
        add eax, 0D2h
        mov ecx, edi
        call SetSeriesTeams
        mov ebx, dword [byte ebp+04Ch]
        mov edx, dword [byte ebp+040h]
        mov eax, dword [dword esp+05E4h]
        add eax, 0FCh
        mov ecx, edi
        call SetSeriesTeams
        mov ebx, dword [byte ebp+048h]
        mov edx, dword [byte ebp+044h]
        mov eax, dword [dword esp+05E4h]
        add eax, 126h
        mov ecx, edi
        call SetSeriesTeams
        xor edx, edx
        mov dword [dword esp+05D4h], edx
        jmp near .22
.21:
        lea edx, [byte ebx+031h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        mov edx, dword [dword esp+05E4h]
        add edx, eax
        mov dword [dword esp+05D0h], edx
        mov byte [edx], 4
        mov bl, byte [edx]
        mov edx, dword [dword esp+05D4h]
        add edx, byte 2Ah
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        add eax, dword [dword esp+05E4h]
        mov byte [eax], bl
        mov cl, bl
        mov ebx, dword [dword esp+05D4h]
        add ebx, byte 23h
        mov edx, ebx
        shl edx, 2
        sub edx, ebx
        add edx, edx
        mov ebx, dword [dword esp+05E4h]
        add ebx, edx
        mov byte [ebx], cl
        mov dl, cl
        mov byte [dword esp+05E8h], dl
        mov ecx, dword [dword esp+05D4h]
        add ecx, byte 1Ch
        mov edx, ecx
        shl edx, 2
        sub edx, ecx
        add edx, edx
        mov ecx, dword [dword esp+05E4h]
        add ecx, edx
        mov dword [dword esp+05D8h], ecx
        mov edx, ecx
        mov cl, byte [dword esp+05E8h]
        mov byte [edx], cl
        mov dl, cl
        mov esi, dword [dword esp+05D4h]
        add esi, byte 15h
        mov ecx, esi
        shl ecx, 2
        sub ecx, esi
        add ecx, ecx
        mov esi, dword [dword esp+05E4h]
        add esi, ecx
        mov byte [esi], dl
        mov cl, dl
        mov ebp, dword [dword esp+05D4h]
        add ebp, byte 0Eh
        mov edx, ebp
        shl edx, 2
        sub edx, ebp
        add edx, edx
        add edx, dword [dword esp+05E4h]
        mov byte [edx], cl
        mov byte [dword esp+05E8h], cl
        mov ebp, dword [dword esp+05D4h]
        add ebp, byte 7
        mov dword [dword esp+05E0h], ebp
        shl ebp, 2
        sub ebp, dword [dword esp+05E0h]
        add ebp, ebp
        mov ecx, dword [dword esp+05E4h]
        add ecx, ebp
        mov dword [dword esp+05DCh], ecx
        mov cl, byte [dword esp+05E8h]
        mov ebp, dword [dword esp+05DCh]
        mov byte [byte ebp+00h], cl
        mov byte [dword esp+05E8h], cl
        mov ebp, dword [dword esp+05D4h]
        mov dword [dword esp+05E0h], ebp
        shl ebp, 2
        sub ebp, dword [dword esp+05E0h]
        add ebp, ebp
        add ebp, dword [dword esp+05E4h]
        mov cl, byte [dword esp+05E8h]
        mov byte [byte ebp+00h], cl
        mov cl, byte [dword esp+05D4h]
        add cl, cl
        mov ch, cl
        add ch, 11h
        mov byte [byte esi+01h], ch
        mov byte [byte edx+01h], ch
        mov esi, dword [dword esp+05DCh]
        mov byte [byte esi+01h], ch
        mov byte [byte ebp+01h], ch
        mov dl, cl
        add dl, 10h
        mov esi, dword [dword esp+05D0h]
        mov byte [byte esi+01h], dl
        mov byte [byte eax+01h], dl
        mov al, dl
        mov byte [byte ebx+01h], dl
        mov edx, dword [dword esp+05D8h]
        mov byte [byte edx+01h], al
        inc dword [dword esp+05D4h]
.22:
        mov ebx, dword [dword esp+05D4h]
        cmp edi, ebx
        jg near SeedPlayoffRound1.21
        xor eax, eax
.23:
        add esp, 5ECh
        jmp near SimPlayoffRound1_pop3
%endif ; C
;-----------------------------------------------------------------------------
; SimPlayoffRound1                             43644  95 PC, medium confidence
; For the 8 round-1 series (game 444h + 7*i): blanks games after a clinch,
; simulates unplayed ones (SimulateGame) and counts wins
;-----------------------------------------------------------------------------
SimPlayoffRound1:
        push dword 94h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 78h
        mov edi, eax
        mov dword [byte esp+070h], edx
        mov dword [byte esp+068h], ebx
        mov dword [byte esp+06Ch], ecx
        mov esi, eax
        mov ecx, 1Ah
        xor edx, edx
        mov eax, esp
        call __STOSD
        mov eax, edi
        call SeriesLength
        mov ebp, eax
        xor edx, edx
        mov dword [byte esp+074h], edx
.1:
        xor edi, edi
        jmp near .9
.2:
        xor ecx, ecx
        mov cl, byte [byte esi+02h]
        mov eax, ebp
        mov edx, ebp
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        lea edx, [byte eax+01h]
        cmp edx, dword [esp+ecx*4]
        je short .3
        xor eax, eax
        mov al, byte [byte esi+03h]
        cmp edx, dword [esp+eax*4]
        jne short .4
.3:
        mov eax, edi
        shl eax, 2
        sub eax, edi
        mov byte [byte esi+eax*2+03h], 0FFh
        mov dl, byte [byte esi+eax*2+03h]
        mov byte [byte esi+eax*2+02h], dl
        mov byte [byte esi+eax*2+01h], dl
        mov byte [esi+eax*2], dl
        jmp short .8
.4:
        mov eax, edi
        shl eax, 2
        sub eax, edi
        add eax, eax
        lea ecx, [esi+eax]
        cmp byte [byte ecx+04h], 0FFh
        jne short .5
        push byte 2
        mov eax, dword [byte esp+06Ch]
        push eax
        mov edx, dword [byte esp+078h]
        push edx
        mov edx, dword [dword esp+080h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        add eax, 444h
        lea ebx, [eax+edi]
        mov edx, dword [dword esp+094h]
        mov eax, dword [byte esp+078h]
        call SimulateGame
.5:
        mov eax, edi
        shl eax, 2
        sub eax, edi
        add eax, eax
        add eax, esi
        mov dl, byte [byte eax+04h]
        cmp dl, byte [byte eax+05h]
        jbe short .6
        mov al, byte [byte eax+02h]
        jmp short .7
.6:
        mov al, byte [byte eax+03h]
.7:
        and eax, 0FFh
        inc dword [esp+eax*4]
.8:
        inc edi
.9:
        cmp edi, ebp
        jl near SimPlayoffRound1.2
        mov ebx, dword [byte esp+074h]
        inc ebx
        mov dword [byte esp+074h], ebx
        add esi, byte 2Ah
        cmp ebx, byte 8
        jl near SimPlayoffRound1.1
SimPlayoffRound1_ok:
        xor eax, eax
        add esp, byte 78h
SimPlayoffRound1_pop3:
        pop ebp
        pop edi
        pop esi
        ret 4
;-----------------------------------------------------------------------------
; SeedPlayoffRound2                            43757  95 PC, medium confidence
; Builds the round-2 series (game 47Ch) from the round-1 winners
; (SeriesLength / SetSeriesTeams)
;-----------------------------------------------------------------------------
; C: src/front/season/SimPlayoffRound1.c (SeedPlayoffRound2)
%ifdef CBUILD
%include "c/front/season/SimPlayoffRound1.SeedPlayoffRound2.inc"
%else
SeedPlayoffRound2:
        push dword 618h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, 604h
        push eax
        mov esi, edx
        mov edi, ebx
        mov dword [dword esp+05F8h], ecx
        mov ebp, eax
        call SeriesLength
        mov dword [dword esp+05F4h], eax
        lea ecx, [byte eax-01h]
        jmp near .7
.1:
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        add eax, eax
        lea edx, [eax+ebp]
        cmp byte [byte edx+04h], 0FFh
        je short .3
.2:
        mov al, byte [edx]
        mov byte [dword esp+0600h], al
        mov al, byte [byte edx+01h]
        inc al
        jmp short .5
.3:
        lea edx, [byte ecx+07h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        lea edx, [eax+ebp]
        mov bl, byte [byte edx+04h]
        cmp bl, 0FFh
        jne short SeedPlayoffRound2.2
        lea edx, [byte ecx+0Eh]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        lea edx, [eax+ebp]
        mov bh, byte [byte edx+04h]
        cmp bh, bl
        jne short SeedPlayoffRound2.2
        lea edx, [byte ecx+015h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        lea edx, [eax+ebp]
        cmp bl, byte [byte edx+04h]
        jne short SeedPlayoffRound2.2
        lea edx, [byte ecx+01Ch]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        lea edx, [eax+ebp]
        cmp bl, byte [byte edx+04h]
        je short .6
.4:
        mov al, byte [edx]
        mov byte [dword esp+0600h], al
        mov al, byte [byte edx+01h]
.5:
        mov byte [dword esp+05FCh], al
        jmp short .8
.6:
        lea edx, [byte ecx+023h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        lea edx, [eax+ebp]
        mov bl, byte [byte edx+04h]
        cmp bl, bh
        jne short SeedPlayoffRound2.4
        lea edx, [byte ecx+02Ah]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        lea edx, [eax+ebp]
        cmp bl, byte [byte edx+04h]
        jne short SeedPlayoffRound2.4
        lea edx, [byte ecx+031h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        lea edx, [eax+ebp]
        cmp bl, byte [byte edx+04h]
        jne short SeedPlayoffRound2.4
        dec ecx
.7:
        test ecx, ecx
        jge near SeedPlayoffRound2.1
.8:
        xor ecx, ecx
        jmp near .10
.9:
        lea edx, [dword esp+05FCh]
        lea eax, [dword esp+0600h]
        call NormalizeDate
        lea edx, [byte ecx+04Dh]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        lea edx, [eax+ebp]
        mov al, byte [dword esp+0600h]
        mov byte [edx], al
        mov byte [dword esp+0604h], al
        lea ebx, [byte ecx+046h]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        add eax, eax
        lea ebx, [eax+ebp]
        mov al, byte [dword esp+0604h]
        mov byte [ebx], al
        mov al, byte [dword esp+05FCh]
        mov byte [byte edx+01h], al
        mov byte [byte ebx+01h], al
        mov ah, al
        inc ah
        mov byte [dword esp+05FCh], ah
        lea edx, [dword esp+05FCh]
        lea eax, [dword esp+0600h]
        call NormalizeDate
        lea edx, [byte ecx+03Fh]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        lea edx, [eax+ebp]
        mov al, byte [dword esp+0600h]
        mov byte [edx], al
        mov byte [dword esp+0604h], al
        lea ebx, [byte ecx+038h]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        add eax, eax
        lea ebx, [eax+ebp]
        mov al, byte [dword esp+0604h]
        mov byte [ebx], al
        mov al, byte [dword esp+05FCh]
        mov byte [byte edx+01h], al
        mov byte [byte ebx+01h], al
        mov dl, al
        inc dl
        mov byte [dword esp+05FCh], dl
        inc ecx
.10:
        cmp ecx, esi
        jl near SeedPlayoffRound2.9
        mov ecx, 8
        mov edx, 0FFFFFFFFh
        lea eax, [dword esp+05D4h]
        call __STOSD
        mov edx, dword [dword esp+05F4h]
        mov eax, ebp
        call SeriesWinner
        xor edx, edx
        mov dl, byte [byte ebp+02h]
        cmp eax, edx
        jne short .11
        mov dword [dword esp+05D4h], edx
        jmp short .12
.11:
        mov dword [dword esp+05F0h], eax
.12:
        lea eax, [byte ebp+02Ah]
        mov edx, dword [dword esp+05F4h]
        call SeriesWinner
        xor edx, edx
        mov dl, byte [byte ebp+02Ch]
        cmp eax, edx
        jne short .13
        mov dword [dword esp+05D8h], edx
        jmp short .14
.13:
        mov dword [dword esp+05ECh], eax
.14:
        lea eax, [byte ebp+054h]
        mov edx, dword [dword esp+05F4h]
        call SeriesWinner
        xor edx, edx
        mov dl, byte [byte ebp+056h]
        cmp eax, edx
        jne short .15
        mov dword [dword esp+05DCh], edx
        jmp short .16
.15:
        mov dword [dword esp+05E8h], eax
.16:
        lea eax, [byte ebp+07Eh]
        mov edx, dword [dword esp+05F4h]
        call SeriesWinner
        xor edx, edx
        mov dl, byte [dword ebp+080h]
        cmp eax, edx
        jne short .17
        mov dword [dword esp+05E0h], edx
        jmp short .18
.17:
        mov dword [dword esp+05E4h], eax
.18:
        xor ecx, ecx
        xor eax, eax
        jmp short .21
.19:
        mov edx, ecx
        shl edx, 2
        mov ebx, dword [dword esp+edx+05D4h]
        test ebx, ebx
        jl short .20
        cmp ebx, byte 1Ah
        jge short .20
        mov dword [dword esp+eax*4+05D4h], ebx
        inc eax
.20:
        inc ecx
.21:
        cmp ecx, byte 8
        jl short SeedPlayoffRound2.19
        mov eax, dword [esp]
        add eax, 150h
        mov ecx, esi
        mov ebx, dword [dword esp+05E0h]
        mov edx, dword [dword esp+05D4h]
        call SetSeriesTeams
        mov eax, dword [esp]
        add eax, 17Ah
        mov ecx, esi
        mov ebx, dword [dword esp+05DCh]
        mov edx, dword [dword esp+05D8h]
        call SetSeriesTeams
        mov eax, dword [dword esp+0618h]
        mov dword [eax], 0
        xor ecx, ecx
.22:
        mov edx, ecx
        shl edx, 2
        mov ebx, dword [dword esp+edx+05D4h]
        mov eax, ebx
        shl eax, 4
        sub eax, ebx
        add eax, eax
        add eax, dword [dword esp+05F8h]
        cmp byte [byte eax+017h], 1
        jne short .23
        mov eax, dword [dword esp+0618h]
        mov dword [eax], 1
        mov ebx, dword [dword esp+edx+05D4h]
        lea edx, [byte esp+04h]
        mov eax, edi
        call ReadTeamRec
        test eax, eax
        jne near .47
.23:
        mov edx, 3
        sub edx, ecx
        shl edx, 2
        mov ebx, dword [dword esp+edx+05D4h]
        mov eax, ebx
        shl eax, 4
        sub eax, ebx
        add eax, eax
        add eax, dword [dword esp+05F8h]
        cmp byte [byte eax+017h], 1
        jne short .24
        mov eax, dword [dword esp+0618h]
        mov dword [eax], 1
        mov ebx, dword [dword esp+edx+05D4h]
        lea edx, [dword esp+02ECh]
        mov eax, edi
        call ReadTeamRec
        test eax, eax
        jne near .47
.24:
        xor eax, eax
        jmp short .26
.25:
        mov edx, ecx
        shl edx, 3
        sub edx, ecx
        lea ebx, [dword edx+047Ch]
        add ebx, eax
        mov edx, ebx
        shl edx, 2
        sub edx, ebx
        lea ebx, [byte edx+edx+02h]
        mov dword [dword esp+eax*4+0574h], ebx
        mov dword [dword esp+eax*4+028Ch], ebx
        inc eax
.26:
        cmp eax, esi
        jl short SeedPlayoffRound2.25
        mov edx, ecx
        shl edx, 2
        mov ebx, dword [dword esp+edx+05D4h]
        mov eax, ebx
        shl eax, 4
        sub eax, ebx
        add eax, eax
        add eax, dword [dword esp+05F8h]
        cmp byte [byte eax+017h], 1
        jne short .27
        mov ebx, dword [dword esp+edx+05D4h]
        lea edx, [byte esp+04h]
        mov eax, edi
        call WriteTeamRec
        test eax, eax
        jne near .47
.27:
        mov edx, 3
        sub edx, ecx
        shl edx, 2
        mov ebx, dword [dword esp+edx+05D4h]
        mov eax, ebx
        shl eax, 4
        sub eax, ebx
        add eax, eax
        add eax, dword [dword esp+05F8h]
        cmp byte [byte eax+017h], 1
        jne short .28
        mov ebx, dword [dword esp+edx+05D4h]
        lea edx, [dword esp+02ECh]
        mov eax, edi
        call WriteTeamRec
        test eax, eax
        jne near .47
.28:
        inc ecx
        cmp ecx, byte 2
        jl near SeedPlayoffRound2.22
        mov ecx, 8
        mov edx, 0FFFFFFFFh
        lea eax, [dword esp+05D4h]
        call __STOSD
        lea eax, [dword ebp+0A8h]
        mov edx, dword [dword esp+05F4h]
        call SeriesWinner
        xor edx, edx
        mov dl, byte [dword ebp+0AAh]
        cmp eax, edx
        jne short .29
        mov dword [dword esp+05D4h], edx
        jmp short .30
.29:
        mov dword [dword esp+05F0h], eax
.30:
        lea eax, [dword ebp+0D2h]
        mov edx, dword [dword esp+05F4h]
        call SeriesWinner
        xor edx, edx
        mov dl, byte [dword ebp+0D4h]
        cmp eax, edx
        jne short .31
        mov dword [dword esp+05D8h], edx
        jmp short .32
.31:
        mov dword [dword esp+05ECh], eax
.32:
        lea eax, [dword ebp+0FCh]
        mov edx, dword [dword esp+05F4h]
        call SeriesWinner
        xor edx, edx
        mov dl, byte [dword ebp+0FEh]
        cmp eax, edx
        jne short .33
        mov dword [dword esp+05DCh], edx
        jmp short .34
.33:
        mov dword [dword esp+05E8h], eax
.34:
        lea eax, [dword ebp+0126h]
        mov edx, dword [dword esp+05F4h]
        call SeriesWinner
        xor edx, edx
        mov dl, byte [dword ebp+0128h]
        cmp eax, edx
        jne short .35
        mov dword [dword esp+05E0h], edx
        jmp short .36
.35:
        mov dword [dword esp+05E4h], eax
.36:
        xor ecx, ecx
        xor eax, eax
        jmp short .39
.37:
        mov edx, ecx
        shl edx, 2
        mov ebp, dword [dword esp+edx+05D4h]
        test ebp, ebp
        jl short .38
        cmp ebp, byte 1Ah
        jge short .38
        mov dword [dword esp+eax*4+05D4h], ebp
        inc eax
.38:
        inc ecx
.39:
        cmp ecx, byte 8
        jl short SeedPlayoffRound2.37
        mov eax, dword [esp]
        add eax, 1A4h
        mov ecx, esi
        mov ebx, dword [dword esp+05E0h]
        mov edx, dword [dword esp+05D4h]
        call SetSeriesTeams
        mov eax, dword [esp]
        add eax, 1CEh
        mov ecx, esi
        mov ebx, dword [dword esp+05DCh]
        mov edx, dword [dword esp+05D8h]
        call SetSeriesTeams
        xor ecx, ecx
.40:
        mov edx, ecx
        shl edx, 2
        mov ebx, dword [dword esp+edx+05D4h]
        mov eax, ebx
        shl eax, 4
        sub eax, ebx
        add eax, eax
        add eax, dword [dword esp+05F8h]
        cmp byte [byte eax+017h], 1
        jne short .41
        mov eax, dword [dword esp+0618h]
        mov dword [eax], 1
        mov ebx, dword [dword esp+edx+05D4h]
        lea edx, [byte esp+04h]
        mov eax, edi
        call ReadTeamRec
        test eax, eax
        jne near .47
.41:
        mov edx, 3
        sub edx, ecx
        shl edx, 2
        mov ebx, dword [dword esp+edx+05D4h]
        mov eax, ebx
        shl eax, 4
        sub eax, ebx
        add eax, eax
        add eax, dword [dword esp+05F8h]
        cmp byte [byte eax+017h], 1
        jne short .42
        mov eax, dword [dword esp+0618h]
        mov dword [eax], 1
        mov ebx, dword [dword esp+edx+05D4h]
        lea edx, [dword esp+02ECh]
        mov eax, edi
        call ReadTeamRec
        test eax, eax
        jne near .47
.42:
        xor eax, eax
        jmp short .44
.43:
        mov edx, ecx
        shl edx, 3
        sub edx, ecx
        add edx, 48Ah
        lea ebx, [edx+eax]
        mov edx, ebx
        shl edx, 2
        sub edx, ebx
        lea ebx, [byte edx+edx+02h]
        mov dword [dword esp+eax*4+0574h], ebx
        mov dword [dword esp+eax*4+028Ch], ebx
        inc eax
.44:
        cmp eax, esi
        jl short SeedPlayoffRound2.43
        mov edx, ecx
        shl edx, 2
        mov ebx, dword [dword esp+edx+05D4h]
        mov eax, ebx
        shl eax, 4
        sub eax, ebx
        add eax, eax
        add eax, dword [dword esp+05F8h]
        cmp byte [byte eax+017h], 1
        jne short .45
        mov ebx, dword [dword esp+edx+05D4h]
        lea edx, [byte esp+04h]
        mov eax, edi
        call WriteTeamRec
        test eax, eax
        jne short .47
.45:
        mov edx, 3
        sub edx, ecx
        shl edx, 2
        mov ebx, dword [dword esp+edx+05D4h]
        mov eax, ebx
        shl eax, 4
        sub eax, ebx
        add eax, eax
        add eax, dword [dword esp+05F8h]
        cmp byte [byte eax+017h], 1
        jne short .46
        mov ebx, dword [dword esp+edx+05D4h]
        lea edx, [dword esp+02ECh]
        mov eax, edi
        call WriteTeamRec
        test eax, eax
        jne short .47
.46:
        inc ecx
        cmp ecx, byte 2
        jl near SeedPlayoffRound2.40
        xor eax, eax
.47:
        add esp, 608h
        jmp near SimPlayoffRound1_pop3
%endif ; C
;-----------------------------------------------------------------------------
; SimPlayoffRound2                             43E40  95 PC, medium confidence
; As SimPlayoffRound1 for the 4 round-2 series (game 47Ch)
;-----------------------------------------------------------------------------
; C: src/front/season/SimPlayoffRound1.c (SimPlayoffRound2)
%ifdef CBUILD
%include "c/front/season/SimPlayoffRound1.SimPlayoffRound2.inc"
%else
SimPlayoffRound2:
        push dword 94h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 6Ch
        push edx
        push ebx
        push ecx
        lea esi, [dword eax+0150h]
        mov ecx, 1Ah
        xor edx, edx
        lea eax, [byte esp+0Ch]
        call __STOSD
        mov eax, esi
        call SeriesLength
        mov ebp, eax
        xor edx, edx
        mov dword [byte esp+074h], edx
.1:
        xor edi, edi
        jmp near .9
.2:
        xor ecx, ecx
        mov cl, byte [byte esi+02h]
        mov eax, ebp
        mov edx, ebp
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        lea edx, [byte eax+01h]
        cmp edx, dword [byte esp+ecx*4+0Ch]
        je short .3
        xor eax, eax
        mov al, byte [byte esi+03h]
        cmp edx, dword [byte esp+eax*4+0Ch]
        jne short .4
.3:
        mov eax, edi
        shl eax, 2
        sub eax, edi
        mov byte [byte esi+eax*2+02h], 0FFh
        mov dl, byte [byte esi+eax*2+02h]
        mov byte [byte esi+eax*2+03h], dl
        mov byte [byte esi+eax*2+01h], dl
        mov byte [esi+eax*2], dl
        jmp short .8
.4:
        mov eax, edi
        shl eax, 2
        sub eax, edi
        add eax, eax
        lea ecx, [esi+eax]
        cmp byte [byte ecx+04h], 0FFh
        jne short .5
        push byte 2
        mov eax, dword [byte esp+08h]
        push eax
        mov edx, dword [byte esp+010h]
        push edx
        mov edx, dword [dword esp+080h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        add eax, 47Ch
        lea ebx, [eax+edi]
        mov edx, dword [dword esp+094h]
        mov eax, dword [byte esp+0Ch]
        call SimulateGame
.5:
        mov eax, edi
        shl eax, 2
        sub eax, edi
        add eax, eax
        add eax, esi
        mov dl, byte [byte eax+04h]
        cmp dl, byte [byte eax+05h]
        jbe short .6
        mov al, byte [byte eax+02h]
        jmp short .7
.6:
        mov al, byte [byte eax+03h]
.7:
        and eax, 0FFh
        inc dword [byte esp+eax*4+0Ch]
.8:
        inc edi
.9:
        cmp edi, ebp
        jl near SimPlayoffRound2.2
        mov ebx, dword [byte esp+074h]
        inc ebx
        mov dword [byte esp+074h], ebx
        add esi, byte 2Ah
        cmp ebx, byte 4
        jl near SimPlayoffRound2.1
        jmp near SimPlayoffRound1_ok
%endif ; C
;-----------------------------------------------------------------------------
; SeedPlayoffRound3                            43F4B  95 PC, medium confidence
; Builds the conference finals (game 498h) from the round-2 winners
;-----------------------------------------------------------------------------
SeedPlayoffRound3:
        push dword 608h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, 5F4h
        push eax
        mov edi, edx
        mov ebp, ebx
        mov dword [dword esp+05E4h], ecx
        lea esi, [dword eax+0150h]
        mov eax, esi
        call SeriesLength
        mov dword [dword esp+05D8h], eax
        lea ebx, [byte eax-01h]
        jmp near .7
.1:
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        add eax, eax
        lea edx, [esi+eax]
        cmp byte [byte edx+04h], 0FFh
        je short .3
.2:
        mov al, byte [edx]
        mov byte [dword esp+05F4h], al
        mov al, byte [byte edx+01h]
        inc al
        jmp short .5
.3:
        lea edx, [byte ebx+07h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        lea edx, [esi+eax]
        mov cl, byte [byte edx+04h]
        cmp cl, 0FFh
        jne short SeedPlayoffRound3.2
        lea edx, [byte ebx+0Eh]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        lea edx, [esi+eax]
        cmp cl, byte [byte edx+04h]
        je short .6
.4:
        mov al, byte [edx]
        mov byte [dword esp+05F4h], al
        mov al, byte [byte edx+01h]
.5:
        mov byte [dword esp+05F0h], al
        jmp short .8
.6:
        lea edx, [byte ebx+015h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        lea edx, [esi+eax]
        cmp cl, byte [byte edx+04h]
        jne short SeedPlayoffRound3.4
        dec ebx
.7:
        test ebx, ebx
        jge short SeedPlayoffRound3.1
.8:
        xor ebx, ebx
        jmp near .10
.9:
        lea edx, [dword esp+05F0h]
        lea eax, [dword esp+05F4h]
        call NormalizeDate
        lea edx, [byte ebx+023h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        lea edx, [esi+eax]
        mov al, byte [dword esp+05F4h]
        mov byte [edx], al
        mov al, byte [dword esp+05F0h]
        mov byte [byte edx+01h], al
        mov cl, al
        inc cl
        mov byte [dword esp+05F0h], cl
        lea edx, [dword esp+05F0h]
        lea eax, [dword esp+05F4h]
        call NormalizeDate
        lea edx, [byte ebx+01Ch]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        lea edx, [esi+eax]
        mov al, byte [dword esp+05F4h]
        mov byte [edx], al
        mov al, byte [dword esp+05F0h]
        mov byte [byte edx+01h], al
        mov ch, al
        inc ch
        mov byte [dword esp+05F0h], ch
        inc ebx
.10:
        cmp ebx, edi
        jl near SeedPlayoffRound3.9
        mov edx, dword [dword esp+05D8h]
        mov eax, esi
        call SeriesWinner
        mov dword [dword esp+05DCh], eax
        mov dword [dword esp+05E8h], eax
        lea eax, [byte esi+02Ah]
        mov edx, dword [dword esp+05D8h]
        call SeriesWinner
        mov dword [dword esp+05ECh], eax
        xor edx, edx
        mov dl, byte [byte esi+02h]
        mov ebx, dword [esp]
        add ebx, 1F8h
        mov dword [dword esp+05D4h], ebx
        mov ebx, dword [dword esp+05DCh]
        cmp edx, ebx
        jne short .11
        mov ecx, edi
        mov ebx, eax
        jmp short .12
.11:
        mov ecx, edi
        mov edx, eax
.12:
        mov eax, dword [dword esp+05D4h]
        call SetSeriesTeams
        mov eax, dword [dword esp+0608h]
        mov dword [eax], 0
        mov eax, dword [dword esp+05E8h]
        shl eax, 4
        mov ecx, dword [dword esp+05E8h]
        sub eax, ecx
        add eax, eax
        add eax, dword [dword esp+05E4h]
        cmp byte [byte eax+017h], 1
        jne short .13
        mov eax, dword [dword esp+0608h]
        mov dword [eax], 1
        mov ebx, ecx
        lea edx, [dword esp+02ECh]
        mov eax, ebp
        call ReadTeamRec
        test eax, eax
        jne near .27
.13:
        mov eax, dword [dword esp+05ECh]
        shl eax, 4
        mov ebx, dword [dword esp+05ECh]
        sub eax, ebx
        add eax, eax
        add eax, dword [dword esp+05E4h]
        cmp byte [byte eax+017h], 1
        jne short .14
        mov eax, dword [dword esp+0608h]
        mov dword [eax], 1
        lea edx, [byte esp+04h]
        mov eax, ebp
        call ReadTeamRec
        test eax, eax
        jne near .27
.14:
        xor eax, eax
        jmp short .16
.15:
        lea ebx, [dword eax+0498h]
        mov edx, ebx
        shl edx, 2
        sub edx, ebx
        add edx, edx
        add edx, byte 2
        mov dword [dword esp+eax*4+02A8h], edx
        mov dword [dword esp+eax*4+0590h], edx
        inc eax
.16:
        cmp eax, edi
        jl short SeedPlayoffRound3.15
        mov eax, dword [dword esp+05E8h]
        shl eax, 4
        sub eax, dword [dword esp+05E8h]
        add eax, eax
        add eax, dword [dword esp+05E4h]
        cmp byte [byte eax+017h], 1
        jne short .17
        mov ebx, dword [dword esp+05E8h]
        lea edx, [dword esp+02ECh]
        mov eax, ebp
        call WriteTeamRec
        test eax, eax
        jne near .27
.17:
        mov eax, dword [dword esp+05ECh]
        shl eax, 4
        mov ecx, dword [dword esp+05ECh]
        sub eax, ecx
        add eax, eax
        add eax, dword [dword esp+05E4h]
        cmp byte [byte eax+017h], 1
        jne short .18
        mov ebx, ecx
        lea edx, [byte esp+04h]
        mov eax, ebp
        call WriteTeamRec
        test eax, eax
        jne near .27
.18:
        lea eax, [byte esi+054h]
        mov edx, dword [dword esp+05D8h]
        call SeriesWinner
        mov dword [dword esp+05E0h], eax
        mov dword [dword esp+05E8h], eax
        lea eax, [byte esi+07Eh]
        mov edx, dword [dword esp+05D8h]
        call SeriesWinner
        mov dword [dword esp+05ECh], eax
        xor edx, edx
        mov dl, byte [byte esi+056h]
        mov esi, dword [esp]
        add esi, 222h
        mov ebx, dword [dword esp+05E0h]
        cmp edx, ebx
        jne short .19
        mov ecx, edi
        mov ebx, eax
        jmp short .20
.19:
        mov ecx, edi
        mov edx, eax
.20:
        mov eax, esi
        call SetSeriesTeams
        mov eax, dword [dword esp+05E8h]
        shl eax, 4
        mov ecx, dword [dword esp+05E8h]
        sub eax, ecx
        add eax, eax
        add eax, dword [dword esp+05E4h]
        cmp byte [byte eax+017h], 1
        jne short .21
        mov eax, dword [dword esp+0608h]
        mov dword [eax], 1
        mov ebx, ecx
        lea edx, [dword esp+02ECh]
        mov eax, ebp
        call ReadTeamRec
        test eax, eax
        jne near .27
.21:
        mov eax, dword [dword esp+05ECh]
        shl eax, 4
        mov edx, dword [dword esp+05ECh]
        sub eax, edx
        add eax, eax
        add eax, dword [dword esp+05E4h]
        cmp byte [byte eax+017h], 1
        jne short .22
        mov eax, dword [dword esp+0608h]
        mov dword [eax], 1
        mov ebx, edx
        lea edx, [byte esp+04h]
        mov eax, ebp
        call ReadTeamRec
        test eax, eax
        jne near .27
.22:
        xor eax, eax
        jmp short .24
.23:
        lea edx, [dword eax+049Fh]
        mov esi, edx
        shl esi, 2
        sub esi, edx
        add esi, esi
        add esi, byte 2
        mov dword [dword esp+eax*4+02A8h], esi
        mov dword [dword esp+eax*4+0590h], esi
        inc eax
.24:
        cmp eax, edi
        jl short SeedPlayoffRound3.23
        mov eax, dword [dword esp+05E8h]
        shl eax, 4
        sub eax, dword [dword esp+05E8h]
        add eax, eax
        add eax, dword [dword esp+05E4h]
        cmp byte [byte eax+017h], 1
        jne short .25
        mov ebx, dword [dword esp+05E8h]
        lea edx, [dword esp+02ECh]
        mov eax, ebp
        call WriteTeamRec
        test eax, eax
        jne short .27
.25:
        mov eax, dword [dword esp+05ECh]
        shl eax, 4
        mov edi, dword [dword esp+05ECh]
        sub eax, edi
        add eax, eax
        add eax, dword [dword esp+05E4h]
        cmp byte [byte eax+017h], 1
        jne short .26
        mov ebx, edi
        lea edx, [byte esp+04h]
        mov eax, ebp
        call WriteTeamRec
        test eax, eax
        jne short .27
.26:
        xor eax, eax
.27:
        add esp, 5F8h
        jmp near SimPlayoffRound1_pop3
;-----------------------------------------------------------------------------
; SimPlayoffRound3                             443B6  95 PC, medium confidence
; As SimPlayoffRound1 for the 2 round-3 series (game 498h)
;-----------------------------------------------------------------------------
; C: src/front/season/SimPlayoffRound1.c (SimPlayoffRound3)
%ifdef CBUILD
%include "c/front/season/SimPlayoffRound1.SimPlayoffRound3.inc"
%else
SimPlayoffRound3:
        push dword 94h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 6Ch
        push edx
        push ebx
        push ecx
        lea esi, [dword eax+01F8h]
        mov ecx, 1Ah
        xor edx, edx
        lea eax, [byte esp+0Ch]
        call __STOSD
        mov eax, esi
        call SeriesLength
        mov ebp, eax
        xor edx, edx
        mov dword [byte esp+074h], edx
.1:
        xor edi, edi
        jmp near .9
.2:
        xor ecx, ecx
        mov cl, byte [byte esi+02h]
        mov eax, ebp
        mov edx, ebp
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        lea edx, [byte eax+01h]
        cmp edx, dword [byte esp+ecx*4+0Ch]
        je short .3
        xor eax, eax
        mov al, byte [byte esi+03h]
        cmp edx, dword [byte esp+eax*4+0Ch]
        jne short .4
.3:
        mov eax, edi
        shl eax, 2
        sub eax, edi
        mov byte [byte esi+eax*2+05h], 0FFh
        mov dl, byte [byte esi+eax*2+05h]
        mov byte [byte esi+eax*2+04h], dl
        mov byte [byte esi+eax*2+03h], dl
        mov byte [byte esi+eax*2+02h], dl
        mov byte [byte esi+eax*2+01h], dl
        mov byte [esi+eax*2], dl
        jmp short .8
.4:
        mov eax, edi
        shl eax, 2
        sub eax, edi
        add eax, eax
        lea ecx, [esi+eax]
        cmp byte [byte ecx+04h], 0FFh
        jne short .5
        push byte 2
        mov eax, dword [byte esp+08h]
        push eax
        mov edx, dword [byte esp+010h]
        push edx
        mov edx, dword [dword esp+080h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        add eax, 498h
        lea ebx, [eax+edi]
        mov edx, dword [dword esp+094h]
        mov eax, dword [byte esp+0Ch]
        call SimulateGame
.5:
        mov eax, edi
        shl eax, 2
        sub eax, edi
        add eax, eax
        add eax, esi
        mov dl, byte [byte eax+04h]
        cmp dl, byte [byte eax+05h]
        jbe short .6
        mov al, byte [byte eax+02h]
        jmp short .7
.6:
        mov al, byte [byte eax+03h]
.7:
        and eax, 0FFh
        inc dword [byte esp+eax*4+0Ch]
.8:
        inc edi
.9:
        cmp edi, ebp
        jl near SimPlayoffRound3.2
        mov ebx, dword [byte esp+074h]
        inc ebx
        mov dword [byte esp+074h], ebx
        add esi, byte 2Ah
        cmp ebx, byte 2
        jl near SimPlayoffRound3.1
        jmp near SimPlayoffRound1_ok
%endif ; C
;-----------------------------------------------------------------------------
; SeedPlayoffFinal                             444C9  95 PC, medium confidence
; Builds the final series (game 4A6h) from the conference champions, ranking
; them with SortStandings
;-----------------------------------------------------------------------------
; C: src/front/season/SimPlayoffRound1.c (SeedPlayoffFinal)
%ifdef CBUILD
%include "c/front/season/SimPlayoffRound1.SeedPlayoffFinal.inc"
%else
SeedPlayoffFinal:
        push dword 638h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, 61Ch
        push eax
        mov esi, edx
        mov edi, ebx
        mov ebp, ecx
        lea ecx, [dword eax+01F8h]
        mov eax, ecx
        call SeriesLength
        mov dword [dword esp+0614h], eax
        lea ebx, [byte eax-01h]
        jmp short .5
.1:
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        add eax, eax
        lea edx, [ecx+eax]
        cmp byte [byte edx+04h], 0FFh
        je short .3
        mov al, byte [edx]
        mov byte [dword esp+061Ch], al
        mov al, byte [byte edx+01h]
.2:
        mov byte [dword esp+0618h], al
        jmp short .6
.3:
        lea edx, [byte ebx+07h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        lea edx, [ecx+eax]
        cmp byte [byte edx+04h], 0FFh
        je short .4
        mov al, byte [edx]
        mov byte [dword esp+061Ch], al
        mov al, byte [byte edx+01h]
        inc al
        jmp short SeedPlayoffFinal.2
.4:
        dec ebx
.5:
        test ebx, ebx
        jge short SeedPlayoffFinal.1
.6:
        xor ebx, ebx
        jmp short .8
.7:
        add byte [dword esp+0618h], 2
        lea edx, [dword esp+0618h]
        lea eax, [dword esp+061Ch]
        call NormalizeDate
        lea edx, [byte ebx+0Eh]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        lea edx, [ecx+eax]
        mov al, byte [dword esp+061Ch]
        mov byte [edx], al
        mov al, byte [dword esp+0618h]
        mov byte [byte edx+01h], al
        inc ebx
.8:
        cmp ebx, esi
        jl short SeedPlayoffFinal.7
        mov edx, dword [dword esp+0614h]
        mov eax, ecx
        call SeriesWinner
        mov dword [dword esp+05D4h], eax
        lea eax, [byte ecx+02Ah]
        mov edx, dword [dword esp+0614h]
        call SeriesWinner
        mov dword [dword esp+05D8h], eax
        mov eax, dword [dword esp+0634h]
        mov dword [eax], 0
        mov edx, dword [dword esp+05D4h]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        cmp byte [byte ebp+eax*2+017h], 1
        jne short .9
        mov eax, dword [dword esp+0634h]
        mov dword [eax], 1
        mov ebx, dword [dword esp+05D4h]
        lea edx, [byte esp+04h]
        mov eax, edi
        call ReadTeamRec
        test eax, eax
        jne near .15
.9:
        mov edx, dword [dword esp+05D8h]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        cmp byte [byte ebp+eax*2+017h], 1
        jne short .10
        mov eax, dword [dword esp+0634h]
        mov dword [eax], 1
        mov ebx, dword [dword esp+05D8h]
        lea edx, [dword esp+02ECh]
        mov eax, edi
        call ReadTeamRec
        test eax, eax
        jne near .15
.10:
        xor edx, edx
        jmp short .12
.11:
        lea ebx, [dword edx+04A6h]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        lea ebx, [byte eax+eax+02h]
        mov dword [dword esp+edx*4+05ACh], ebx
        mov dword [dword esp+edx*4+02C4h], ebx
        inc edx
.12:
        cmp edx, esi
        jl short SeedPlayoffFinal.11
        mov edx, dword [dword esp+05D4h]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        cmp byte [byte ebp+eax*2+017h], 1
        jne short .13
        mov ebx, dword [dword esp+05D4h]
        lea edx, [byte esp+04h]
        mov eax, edi
        call WriteTeamRec
        test eax, eax
        jne near .15
.13:
        mov edx, dword [dword esp+05D8h]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        cmp byte [byte ebp+eax*2+017h], 1
        jne short .14
        mov ebx, dword [dword esp+05D8h]
        lea edx, [dword esp+02ECh]
        mov eax, edi
        call WriteTeamRec
        test eax, eax
        jne near .15
.14:
        xor eax, eax
        mov al, byte [byte esp+02Dh]
        lea edx, [eax+eax]
        xor ebx, ebx
        mov bl, byte [byte esp+02Fh]
        add edx, ebx
        mov dword [dword esp+060Ch], edx
        mov dword [dword esp+05FCh], eax
        xor eax, eax
        mov ax, word [byte esp+030h]
        mov dword [dword esp+05F4h], eax
        xor eax, eax
        mov ax, word [byte esp+032h]
        mov dword [dword esp+0604h], eax
        xor eax, eax
        mov al, byte [dword esp+0315h]
        lea edx, [eax+eax]
        xor ebx, ebx
        mov bl, byte [dword esp+0317h]
        add edx, ebx
        mov dword [dword esp+0610h], edx
        mov dword [dword esp+0600h], eax
        xor eax, eax
        mov ax, word [dword esp+0318h]
        mov dword [dword esp+05F8h], eax
        xor eax, eax
        mov ax, word [dword esp+031Ah]
        mov dword [dword esp+0608h], eax
        push byte 2
        lea eax, [dword esp+0608h]
        push eax
        lea ecx, [dword esp+05FCh]
        lea ebx, [dword esp+0604h]
        lea edx, [dword esp+0614h]
        lea eax, [dword esp+05DCh]
        call SortStandings
        mov eax, dword [esp]
        add eax, 24Ch
        mov ecx, esi
        mov ebx, dword [dword esp+05D8h]
        mov edx, dword [dword esp+05D4h]
        call SetSeriesTeams
        xor eax, eax
.15:
        add esp, 620h
        jmp near UpdateSeasonSchedule_pop3
%endif ; C
;-----------------------------------------------------------------------------
; SimPlayoffFinal                              447A6  95 PC, medium confidence
; Simulates the final series (game 4A6h)
;-----------------------------------------------------------------------------
; C: src/front/season/SimPlayoffRound1.c (SimPlayoffFinal)
%ifdef CBUILD
%include "c/front/season/SimPlayoffRound1.SimPlayoffFinal.inc"
%else
SimPlayoffFinal:
        push dword 90h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 68h
        push edx
        push ebx
        push ecx
        lea esi, [dword eax+024Ch]
        mov ecx, 1Ah
        xor edx, edx
        lea eax, [byte esp+0Ch]
        call __STOSD
        mov eax, esi
        call SeriesLength
        mov ebp, eax
        xor edi, edi
        jmp near .8
.1:
        xor ecx, ecx
        mov cl, byte [byte esi+02h]
        mov eax, ebp
        mov edx, ebp
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        inc eax
        cmp eax, dword [byte esp+ecx*4+0Ch]
        je short .2
        xor ebx, ebx
        mov bl, byte [byte esi+03h]
        cmp eax, dword [byte esp+ebx*4+0Ch]
        jne short .3
.2:
        mov eax, edi
        shl eax, 2
        sub eax, edi
        mov byte [byte esi+eax*2+03h], 0FFh
        mov bl, byte [byte esi+eax*2+03h]
        mov byte [byte esi+eax*2+02h], bl
        mov byte [byte esi+eax*2+01h], bl
        mov byte [esi+eax*2], bl
        jmp short .7
.3:
        mov eax, edi
        shl eax, 2
        sub eax, edi
        add eax, eax
        lea ecx, [esi+eax]
        cmp byte [byte ecx+04h], 0FFh
        jne short .4
        push byte 2
        mov eax, dword [byte esp+08h]
        push eax
        mov edx, dword [byte esp+010h]
        push edx
        lea ebx, [dword edi+04A6h]
        mov edx, dword [dword esp+090h]
        mov eax, dword [byte esp+0Ch]
        call SimulateGame
.4:
        mov eax, edi
        shl eax, 2
        sub eax, edi
        add eax, eax
        add eax, esi
        mov bl, byte [byte eax+04h]
        cmp bl, byte [byte eax+05h]
        jbe short .5
        mov al, byte [byte eax+02h]
        jmp short .6
.5:
        mov al, byte [byte eax+03h]
.6:
        and eax, 0FFh
        inc dword [byte esp+eax*4+0Ch]
.7:
        inc edi
.8:
        cmp edi, ebp
        jl near SimPlayoffFinal.1
        xor eax, eax
        add esp, byte 74h
        jmp near SimPlayoffRound1_pop3
%endif ; C
FinishPlayoffs_jt:
        dd FinishPlayoffs_r1
        dd FinishPlayoffs_r2
        dd FinishPlayoffs_r3
        dd FinishPlayoffs_r4
;-----------------------------------------------------------------------------
; FinishPlayoffs                               44899  95 PC, medium confidence
; From the current round (jump table) runs the remaining Sim/Seed round
; functions, writes the playoff games and the SEASON data
;-----------------------------------------------------------------------------
; C: src/front/season/FinishPlayoffs.c
%ifdef CBUILD
%include "c/front/season/FinishPlayoffs.inc"
%else
FinishPlayoffs:
        push dword 48h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 28h
        push eax
        mov esi, edx
        mov edi, ebx
        mov ebp, ecx
        mov eax, dword [byte esp+044h]
        sub eax, byte 2
        cmp eax, byte 3
        ja near FinishPlayoffs_r4.5
        jmp dword [nosplit cs:eax*4+FinishPlayoffs_jt]
FinishPlayoffs_r1:
        mov edx, dword [byte esp+040h]
        push edx
        mov eax, dword [playoffbuf]
        mov ecx, dword [byte esp+040h]
        mov edx, esi
        call SimPlayoffRound1
        test eax, eax
        jne near FinishPlayoffs_r4.x
        lea eax, [byte esp+024h]
        push eax
        mov edx, dword [gameopts]
        shl edx, 11h
        shr edx, 1Dh
        mov eax, dword [playoffbuf]
        mov ecx, ebp
        mov ebx, esi
        call SeedPlayoffRound2
        test eax, eax
        jne near FinishPlayoffs_r4.x
FinishPlayoffs_r2:
        mov ebx, dword [byte esp+040h]
        push ebx
        mov eax, dword [playoffbuf]
        mov ecx, dword [byte esp+040h]
        mov ebx, edi
        mov edx, esi
        call SimPlayoffRound2
        test eax, eax
        jne near FinishPlayoffs_r4.x
        lea eax, [byte esp+024h]
        push eax
        mov edx, dword [gameopts]
        shl edx, 11h
        shr edx, 1Dh
        mov eax, dword [playoffbuf]
        mov ecx, ebp
        mov ebx, esi
        call SeedPlayoffRound3
        test eax, eax
        jne near FinishPlayoffs_r4.x
FinishPlayoffs_r3:
        mov ecx, dword [byte esp+040h]
        push ecx
        mov eax, dword [playoffbuf]
        mov ecx, dword [byte esp+040h]
        mov ebx, edi
        mov edx, esi
        call SimPlayoffRound3
        test eax, eax
        jne near FinishPlayoffs_r4.x
        lea eax, [byte esp+024h]
        push eax
        mov eax, dword [byte esp+04h]
        push eax
        mov edx, dword [gameopts]
        shl edx, 11h
        shr edx, 1Dh
        mov eax, dword [playoffbuf]
        mov ecx, ebp
        mov ebx, esi
        call SeedPlayoffFinal
        test eax, eax
        jne near FinishPlayoffs_r4.x
FinishPlayoffs_r4:
        mov edx, dword [byte esp+040h]
        push edx
        mov eax, dword [playoffbuf]
        mov ecx, dword [byte esp+040h]
        mov ebx, edi
        mov edx, esi
        call SimPlayoffFinal
        test eax, eax
        jne near .x
        mov edx, dword [playoffbuf]
        mov ecx, 276h
        mov ebx, 199Ah
        mov eax, dword [esp]
        call FileWriteAt
        test eax, eax
        jne short .x
        mov ebx, dword [leaguedbnames+14h]
        mov ecx, dword [byte esp+040h]
        mov edx, dword [byte esp+03Ch]
        lea eax, [byte esp+04h]
        call MakePath
        mov ebx, dword [seasondb_size]
        push ebx
        mov ecx, dword [seasondb]
        push ecx
        lea eax, [byte esp+0Ch]
        push eax
        call WriteFile
        add esp, byte 0Ch
        call AwardsCeremony
        mov byte [byte_DE268], 0FFh
        mov dword [byte esp+028h], 4ADh
        mov ecx, 2
        xor ebx, ebx
        lea edx, [byte esp+028h]
        mov eax, dword [esp]
        call FileWriteAt
        jmp short .x
.5:
        mov eax, 0FFFFFFFFh
.x:
        add esp, byte 2Ch
        pop ebp
        pop edi
        pop esi
        ret 0Ch
%endif ; C
;-----------------------------------------------------------------------------
; AdvancePlayoffs                              44A41  95 PC, medium confidence
; Reads the 69h playoff games, finds the current round, simulates or seeds
; the next round (or FinishPlayoffs when no human team is left), writes the
; games back and the 'Sch' SEASON data
;-----------------------------------------------------------------------------
; C: src/front/season/AdvancePlayoffs.c
%ifdef CBUILD
%include "c/front/season/AdvancePlayoffs.inc"
%else
AdvancePlayoffs:
        push dword 54h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 38h
        mov esi, eax
        mov dword [byte esp+030h], edx
        mov dword [byte esp+02Ch], ebx
        mov edi, ecx
        xor edx, edx
        mov dword [byte esp+028h], edx
        xor ebp, ebp
        xor ecx, ecx
        jmp near .5
.1:
        lea ebx, [dword ecx+0444h]
        lea edx, [byte esp+020h]
        mov eax, esi
        call ReadSchedGame
        mov ebp, eax
        cmp byte [byte esp+022h], 0FFh
        je short .4
        cmp byte [byte esp+023h], 0FFh
        je short .4
        xor edx, edx
        mov dl, byte [byte esp+022h]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        cmp byte [byte edi+eax*2+017h], 1
        je short .2
        xor edx, edx
        mov dl, byte [byte esp+023h]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        cmp byte [byte edi+eax*2+017h], 1
        jne short .4
.2:
        cmp byte [byte esp+020h], 0FFh
        je short .4
        cmp byte [byte esp+021h], 0FFh
        je short .4
        cmp byte [byte esp+024h], 0FFh
        je short .3
        cmp byte [byte esp+025h], 0FFh
        jne short .4
.3:
        mov dword [byte esp+028h], 1
.4:
        inc ecx
.5:
        cmp ecx, byte 69h
        jge short .6
        test ebp, ebp
        jne short .6
        cmp dword [byte esp+028h], byte 0
        je short AdvancePlayoffs.1
.6:
        test ebp, ebp
        jne near .12
        cmp dword [byte esp+028h], byte 0
        jne near .12
        cmp dword [byte esp+054h], byte 7
        jne near .12
        cmp dword [byte esp+050h], byte 0FFFFFFFFh
        jne near .12
        mov ecx, 2
        xor ebx, ebx
        lea edx, [byte esp+034h]
        mov eax, esi
        call FileReadAt
        test eax, eax
        jne near .x
        push byte 20h
        push dword 276h
        push str_Sch
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [playoffbuf], eax
        mov ecx, 276h
        mov ebx, 199Ah
        mov edx, eax
        mov eax, esi
        call FileReadAt
        mov ebp, eax
        test eax, eax
        jne near .13
        mov edx, dword [byte esp+034h]
        cmp dx, 47Ch
        jge near .8
        mov dword [byte esp+034h], 47Ch
        mov ebx, dword [byte esp+04Ch]
        push ebx
        mov eax, dword [playoffbuf]
        mov ecx, dword [byte esp+04Ch]
        mov ebx, dword [byte esp+030h]
        mov edx, dword [byte esp+034h]
        call SimPlayoffRound1
        mov ebp, eax
        test eax, eax
        jne near .13
        lea eax, [byte esp+028h]
        push eax
        mov edx, dword [gameopts]
        shl edx, 11h
        shr edx, 1Dh
        mov eax, dword [playoffbuf]
        mov ecx, edi
        mov ebx, dword [byte esp+034h]
        call SeedPlayoffRound2
        mov ebp, eax
        test eax, eax
        jne near .13
        cmp dword [byte esp+028h], byte 0
        jne near .11
        push byte 3
        mov ebp, dword [byte esp+050h]
        push ebp
        mov eax, dword [byte esp+050h]
        push eax
.7:
        mov ecx, edi
        mov ebx, dword [byte esp+038h]
        mov edx, dword [byte esp+03Ch]
        mov eax, esi
        call FinishPlayoffs
        jmp near .11
.8:
        cmp dx, 498h
        jge short .9
        mov dword [byte esp+034h], 498h
        mov ecx, dword [byte esp+04Ch]
        push ecx
        mov eax, dword [playoffbuf]
        mov ecx, dword [byte esp+04Ch]
        mov ebx, dword [byte esp+030h]
        mov edx, dword [byte esp+034h]
        call SimPlayoffRound2
        mov ebp, eax
        test eax, eax
        jne near .13
        lea eax, [byte esp+028h]
        push eax
        mov edx, dword [gameopts]
        shl edx, 11h
        shr edx, 1Dh
        mov eax, dword [playoffbuf]
        mov ecx, edi
        mov ebx, dword [byte esp+034h]
        call SeedPlayoffRound3
        mov ebp, eax
        test eax, eax
        jne near .13
        cmp dword [byte esp+028h], byte 0
        jne near .11
        push byte 4
        mov eax, dword [byte esp+050h]
        push eax
        mov edx, dword [byte esp+050h]
        push edx
        jmp near AdvancePlayoffs.7
.9:
        cmp dx, 4A6h
        jge near .10
        mov dword [byte esp+034h], 4A6h
        mov ebp, dword [byte esp+04Ch]
        push ebp
        mov eax, dword [playoffbuf]
        mov ecx, dword [byte esp+04Ch]
        mov ebx, dword [byte esp+030h]
        mov edx, dword [byte esp+034h]
        call SimPlayoffRound3
        mov ebp, eax
        test eax, eax
        jne near .13
        lea eax, [byte esp+028h]
        push eax
        push esi
        mov edx, dword [gameopts]
        shl edx, 11h
        shr edx, 1Dh
        mov eax, dword [playoffbuf]
        mov ecx, edi
        mov ebx, dword [byte esp+038h]
        call SeedPlayoffFinal
        mov ebp, eax
        test eax, eax
        jne near .13
        cmp dword [byte esp+028h], byte 0
        jne near .11
        push byte 5
        mov edx, dword [byte esp+050h]
        push edx
        mov ebx, dword [byte esp+050h]
        push ebx
        mov ecx, edi
        mov ebx, dword [byte esp+038h]
        mov edx, dword [byte esp+03Ch]
        mov eax, esi
        call FinishPlayoffs
        mov dword [byte esp+034h], 4ADh
        jmp short .11
.10:
        cmp dx, 4ADh
        jge short .11
        mov dword [byte esp+034h], 4ADh
        mov ebx, dword [byte esp+04Ch]
        push ebx
        mov eax, dword [playoffbuf]
        mov ecx, dword [byte esp+04Ch]
        mov ebx, dword [byte esp+030h]
        mov edx, dword [byte esp+034h]
        call SimPlayoffFinal
        mov ebp, eax
        test eax, eax
        jne short .13
        mov ebx, dword [leaguedbnames+14h]
        mov ecx, dword [byte esp+04Ch]
        mov edx, dword [byte esp+048h]
        mov eax, esp
        call MakePath
        mov ecx, dword [seasondb_size]
        push ecx
        mov edi, dword [seasondb]
        push edi
        lea eax, [byte esp+08h]
        push eax
        call WriteFile
        add esp, byte 0Ch
        call AwardsCeremony
        mov byte [byte_DE268], 0FFh
.11:
        mov ecx, 2
        xor ebx, ebx
        lea edx, [byte esp+034h]
        mov eax, esi
        call FileWriteAt
        mov ebp, eax
        test eax, eax
        jne short .13
.12:
        mov edx, dword [playoffbuf]
        test edx, edx
        je short .13
        mov ecx, 276h
        mov ebx, 199Ah
        mov eax, esi
        call FileWriteAt
        mov ebp, eax
.13:
        mov ebx, dword [playoffbuf]
        test ebx, ebx
        je short .14
        push ebx
        call FreeMemBlock
        add esp, byte 4
        xor esi, esi
        mov dword [playoffbuf], esi
.14:
        mov eax, ebp
.x:
        add esp, byte 38h
        pop ebp
        pop edi
        pop esi
        ret 10h
%endif ; C
;-----------------------------------------------------------------------------
; CreateNewLeague                                                 44DCF  95 PC
; League menu (temp_files 3310F): 'Enter New League Name', '<name>.LP'
; directory ('There is already a league with that name!'), free-space check
; ('%4d Kbytes of free disk space.'), 'Which schedule do you want to use?'
; ('93 - '94 Season / Random), 'Select human controlled teams', 'Creating
; league.', copies the databases, WriteLeagueInfo, RandomizeSchedule,
; CopyHumanTeamDBs ('Error while creating league!')
;-----------------------------------------------------------------------------
CreateNewLeague:
        push dword 0A0h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 70h
        push byte 0
        mov ecx, 0FAh
        mov ebx, 0F8h
        mov edx, ecx
        mov eax, 0F9h
        call SetDialogColors
        xor edi, edi
        xor esi, esi
        mov dword [byte esp+068h], edi
.1:
        mov edx, dword [byte esp+068h]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        add eax, eax
        add eax, leagueteams
        mov ebx, 0Bh
        xor edx, edx
        call memset_
        mov edx, dword [byte esp+068h]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        add eax, eax
        add eax, leagueteams
        add eax, byte 0Bh
        mov ebx, 0Bh
        xor edx, edx
        call memset_
        mov edx, dword [byte esp+068h]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        mov byte [nosplit eax*2+lgteamflags], 1
        xor dh, dh
        mov byte [nosplit eax*2+lgteam_17], dh
        mov byte [nosplit eax*2+lgteam_18], 2
        mov byte [nosplit eax*2+lgteam_19], dh
        xor ebx, ebx
        mov dword [nosplit eax*2+lgteamver], ebx
        mov ecx, dword [byte esp+068h]
        inc ecx
        mov dword [byte esp+068h], ecx
        cmp ecx, byte 1Ah
        jl near CreateNewLeague.1
        push byte 5
        push ebx
        push ebx
        push ebx
        push ebx
        mov ecx, 30h
        mov ebx, 8
        lea edx, [byte esp+060h]
        mov eax, str_EnterLeagueName
        call TextInputDialog
        mov dword [byte esp+068h], eax
        cmp byte [byte esp+04Ch], 0
        je near .22
        cmp eax, byte 1Bh
        je near .22
        lea eax, [byte esp+060h]
        push eax
        lea eax, [byte esp+068h]
        push eax
        lea eax, [byte esp+070h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        mov edx, str_extLP
        lea eax, [byte esp+04Ch]
        call strcat_
        lea edx, [byte esp+04Ch]
        mov eax, curleague
        call strcpy_
        mov ebx, esp
        mov edx, 10h
        lea eax, [byte esp+04Ch]
        call unknown_libname_1
        test eax, eax
        jne short .3
        push byte 0FFFFFFFFh
        lea eax, [byte esp+064h]
        push eax
        lea eax, [byte esp+06Ch]
        push eax
        push byte 2
        push btn_LeagueExists
        mov ecx, 2
        mov ebx, msg_LeagueExists
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov dword [byte esp+06Ch], eax
        cmp eax, byte 1
        jne short .2
        lea eax, [byte esp+04Ch]
        call DeleteDir
        jmp short .3
.2:
        mov esi, 1
.3:
        test esi, esi
        jne short .4
        push byte 0FFFFFFFFh
        lea eax, [byte esp+064h]
        push eax
        lea eax, [byte esp+06Ch]
        push eax
        push byte 2
        push btn_WhichSchedule
        mov ecx, 1
        mov ebx, msg_WhichSchedule
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov dword [byte esp+06Ch], eax
        cmp eax, byte 0FFFFFFFFh
        jne short .4
        mov esi, eax
.4:
        test esi, esi
        jne short .5
        call AskDatabaseChoice
        cmp eax, byte 0FFFFFFFFh
        jne short .5
        mov esi, eax
.5:
        test esi, esi
        jne short .7
        xor eax, eax
        call DiskFreeBytes
        cmp eax, 800h
        jge short .6
        push dword 1F4h
        lea eax, [byte esp+064h]
        push eax
        lea eax, [byte esp+06Ch]
        push eax
        push esi
        push esi
        mov ecx, 1
        mov ebx, msg_DiskFull
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov edi, 1
        jmp short .7
.6:
        lea eax, [byte esp+04Ch]
        call mkdir_
        mov edi, eax
.7:
        test esi, esi
        jne near .19
        test edi, edi
        jne near .19
        mov ebx, dword [leaguedbnames+10h]
        mov ecx, str_extDB
        xor edx, edx
        lea eax, [byte esp+02Ch]
        call MakePath
        mov ebx, 1
        mov edx, treeteamnames
        lea eax, [byte esp+02Ch]
        call ReadTeamNames
        mov edi, eax
        test eax, eax
        jne near .19
        lea eax, [byte esp+05Ch]
        push eax
        push str_SelHumanTeams
        push byte 1
        mov ecx, leagueteams
        mov ebx, treeteamnames
        mov edx, humancount
        mov eax, curleague
        call LeagueTeamSelect
        mov ebp, 0B6h
        jmp short .10
.8:
        mov eax, esi
        shl eax, 4
        sub eax, esi
        add eax, eax
        mov ch, byte [dword eax+lgteam_17]
        cmp ch, 1
        jne short .9
        cmp ch, byte [dword eax+lgteam_18]
        jne short .9
        sub ebp, byte 7
.9:
        inc esi
.10:
        cmp esi, byte 1Ah
        jl short CreateNewLeague.8
        mov ebx, dword [dbextension]
        mov edx, leaguedbsizes
        xor eax, eax
        call GetLeagueDBSizes
        xor esi, esi
.11:
        mov edx, 1
.12:
        mov eax, edx
        shl eax, 3
        sub eax, edx
        add eax, esi
        mov ebx, dword [nosplit esi*4+leaguedbsizes]
        mov dword [nosplit eax*4+leaguedbsizes], ebx
        inc edx
        cmp edx, byte 1Ah
        jle short CreateNewLeague.12
        inc esi
        cmp esi, byte 7
        jl short CreateNewLeague.11
        xor ecx, ecx
        mov ebx, str_gameset
        mov edx, curleague
        lea eax, [byte esp+02Ch]
        call MakePath
        lea eax, [byte esp+02Ch]
        call FileExists
        test eax, eax
        je short .13
        xor eax, eax
        mov dword [dword_C9002], eax
.13:
        mov edx, ebp
        shl edx, 2
        add edx, leaguedbsizes
        xor eax, eax
        call DiskSpaceShort
        test eax, eax
        je short .14
        push eax
        push str_KbytesFree
        push str_KbytesFreeLine
        call sprintf_
        add esp, byte 0Ch
        push dword 320h
        lea eax, [byte esp+064h]
        push eax
        lea eax, [byte esp+06Ch]
        push eax
        push byte 0
        push byte 0
        mov ecx, 3
        mov ebx, msg_NoDiskSpace
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov edi, 1
.14:
        test edi, edi
        jne near .19
        cmp dword [byte esp+05Ch], byte 0
        jl near .19
        push edi
        push edi
        push edi
        push edi
        push edi
        mov ecx, 1
        mov ebx, msg_CreatingLeague
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        push savedname
        mov ebx, dword [leaguesaved]
        push ebx
        mov ecx, dword [leagueflags]
        push ecx
        mov esi, dword [humancount]
        push esi
        mov ecx, dword [leaguemaster]
        mov ebx, masterpw
        mov edx, leagueteams
        mov eax, curleague
        call WriteLeagueInfo
        mov edi, eax
        xor ebp, ebp
        mov dword [byte esp+068h], ebp
        jmp short .16
.15:
        push curleague
        mov edx, dword [dbextension]
        mov eax, dword [nosplit eax*4+leaguedbnames]
        xor ecx, ecx
        mov ebx, str_extDB
        call CopyFile
        mov edi, eax
        inc dword [byte esp+068h]
.16:
        mov eax, dword [byte esp+068h]
        cmp eax, byte 7
        jge short .17
        test edi, edi
        je short CreateNewLeague.15
.17:
        test edi, edi
        jne short .18
        mov eax, lgstate
        call WriteModeState
        mov edx, dword [byte esp+06Ch]
        mov eax, curleague
        call RandomizeSchedule
        mov edi, eax
.18:
        call RestoreDialogBg
        test edi, edi
        jne short .19
        mov ebx, 0FFFFFFFFh
        mov edx, leagueteams
        mov eax, curleague
        call CopyHumanTeamDBs
        mov edi, eax
.19:
        test edi, edi
        jne short .20
        cmp dword [byte esp+05Ch], byte 0
        jge short .22
.20:
        test edi, edi
        je short .21
        lea eax, [byte esp+060h]
        push eax
        lea eax, [byte esp+068h]
        push eax
        lea eax, [byte esp+070h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        push byte 0FFFFFFFFh
        lea eax, [byte esp+064h]
        push eax
        lea eax, [byte esp+06Ch]
        push eax
        push byte 0
        push byte 0
        mov ecx, 1
        mov ebx, msg_CreateError
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
.21:
        xor dh, dh
        mov byte [lgstate+4], dh
        lea eax, [byte esp+04Ch]
        call DeleteDir
.22:
        push byte 0
        mov ecx, 3Fh
        mov ebx, 17h
        mov edx, ecx
        mov eax, 2Ah
        call SetDialogColors
        add esp, byte 70h
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
