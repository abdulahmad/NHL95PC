; The league schedule and the league playoffs: building the season, simulating a day, and seeding each round.
bits 32
%include "hockey.inc"
section s_41B80 progbits alloc exec nowrite align=1
extern __CHK, __STOSD, AdvancePlayoffs, BuildPlayoffs, MergeResult, careerdb, careerdb_size, divisionteams
extern lgoppteam, lgopphuman, FileClose, FileOpenRead, FileOpenRW, FileReadAt, FileWriteAt, FreeMemBlock
extern GetFileSize, keydb, keydb_size, leaguedbnames, lggameidx, lgplayteam, lgschedrec, MakePath
extern MessageBox, monthdays_m1, msg_GenSchedule, rand_, ReadSchedGame, ReadTeamRec, RestoreDialogBg, savleague1
extern savleague2, seasondb, seasondb_size, SeriesWinner, SimulateGame, str_extDB, OpenArtArchiveErr, teamdivision
extern teamdivslot, lggamecount, lgoppgamecount, WriteFile, WriteSchedGame, WriteTeamRec
global LoadLeagueGameRef, DateKey, NormalizeDate, UpdateSeasonSchedule, UpdateSeasonSchedule_pop3, UpdatePlayoffSeries, SeriesLength_jt, SeriesLength
global SeriesLength_bo1, SeriesLength_bo3, SeriesLength_n3, SeriesLength_n4, SeriesLength_bo7, RandomizeSchedule, SimScheduleDay
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
        mov edx, lgoppteam
        mov eax, esi
        call FileReadAt
.1:
        test eax, eax
        jne short .2
        mov ecx, 4
        mov ebx, 0FFFFFFFFh
        mov edx, lgopphuman
        mov eax, esi
        call FileReadAt
.2:
        test eax, eax
        jne short .3
        mov ecx, 4
        mov ebx, 0FFFFFFFFh
        mov edx, lggamecount
        mov eax, esi
        call FileReadAt
.3:
        test eax, eax
        jne short .4
        mov ecx, 4
        mov ebx, 0FFFFFFFFh
        mov edx, lgoppgamecount
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
        mov byte [MergeResult], ah
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
        call OpenArtArchiveErr
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
        call OpenArtArchiveErr
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
        call OpenArtArchiveErr
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
