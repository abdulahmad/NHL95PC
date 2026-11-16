; Loading the two teams for a game: rosters, player records, the goalie menu, and the game summary path.
bits 32
%include "hockey.inc"
section s_1BBCC progbits alloc exec nowrite align=1
extern __CHK, awgoalcnt, awgoalieidx, awlinetab, awroster, awscratch, awshotcnt, awteamrec
extern awtmap, awtmgoalie, gsumheader_b1, gsumheader_b2, gsumheader_b3, gsumheader_b4, RosterStatusByInjury, hmrosterpos
extern GameRecordDay, GameRecordMonth, cont2team, curleague, curperiod, hmplstats, hmteamrec_skaters, hmteamrec_goalies
extern plcareergoals, plcareerpts, plseasongoals, plseasonpts, hmtmpdst_gl_m2, FatalError, FileClose, FileCreate
extern FileOpenRead, FileReadAt, FileWriteAt, fputchar, gameopts, gsummarypath, hmgoalcnt, hmgoalieidx
extern hmlinetab, hmroster, hmrosterjersey, hmscratch, hmshotcnt, hmteamrec, hmtmap, hmtmgoalie
extern hmtmpdst_m2, HomeTeam, hudpenaway, hudpenhome, leaguedbfmt, leaguedbfmt2, LoadCupFinalSeries, LoadScoreboardGfx
extern lseek_, mi_AwayGoalie1, mi_AwayGoalie2, mi_AwayGoalieNone, mi_HomeGoalie1, mi_HomeGoalie2, mi_HomeGoalieNone, sprintf_
extern str_att, str_backslash3, str_career, str_fe1, str_fe2, str_fe3, str_fe4, str_fe5
extern str_fe7, str_fe8, str_fe9, str_feA, str_feB, str_feB1, str_feB5, str_feB8
extern str_feC, str_feD, str_feE, str_feF, str_feG, str_feH, str_feI, str_feJ
extern str_feK, str_feL, str_feM, str_feN, str_feO, str_feP, str_feQ, str_GoalieItemTmpl
extern str_GsummaryDb2, str_key, str_season, str_teams, strcat_, strcpy_, strncpy_, gsumheader
extern gsumtail, hmgoaliemenu, awgoaliemenu, hmglattr, hmplattr, hmglstats, _dos_findfirst_, VisTeam
extern gsumcount, hmpanelpen_time, hmpanelpen_w4, hmpanelpen_w6, awpanelpen_time, awpanelpen_w4, awpanelpen_w6, hmplstats_w2
extern hmplstats_w4, hmplstats_w6, hmplstats_w8, hmplstats_w10, hmplstats_w12, hmplstats_w14, hmglstats_w2, hmglstats_w4
global LoadGameTeams, InitGameSummary, ReadPlayerRecord, OpenPlayerDBs, OpenPlayerDBs_x, LoadTeamRoster, MakeGSummaryPath, SetupGoalieMenu
global ResetGoalieMenu, ClearPanelPenalties
;-----------------------------------------------------------------------------
; LoadGameTeams                                1BBCC  95 PC, medium confidence
; (mode): reads the Home and Visitor TEAMS.DB records (leaguedbfmt /
; leaguedbfmt2 paths) into hmteamrec / awteamrec,
;
; opens each side's KEY / ATT / SEASON / CAREER files (OpenPlayerDBs) and
; loads both rosters (LoadTeamRoster); in modes 0 / 2 copies the saved lines
; into hmlinetab / awlinetab; marks the scratched players
;
; (hmscratch / awscratch) in the rosters; FatalError codes "1".."8"
;-----------------------------------------------------------------------------
; C: src/front/team_db/LoadGameTeams.c
%ifdef CBUILD
%include "c/front/team_db/LoadGameTeams.inc"
%else
LoadGameTeams:
        push dword 88h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 60h
        push eax
        push str_teams
        push leaguedbfmt
        lea eax, [byte esp+038h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea ebx, [byte esp+04h]
        xor edx, edx
        lea eax, [byte esp+030h]
        call _dos_findfirst_
        test eax, eax
        je short .1
        push str_fe1
        call FatalError
        add esp, byte 4
.1:
        lea edx, [byte esp+060h]
        lea eax, [byte esp+030h]
        call FileOpenRead
        test eax, eax
        je short .2
        push str_fe2
        call FatalError
        add esp, byte 4
.2:
        xor ebx, ebx
        xor edx, edx
        mov eax, dword [byte esp+060h]
        call lseek_
        test eax, eax
        je short .3
        push str_fe3
        call FatalError
        add esp, byte 4
.3:
        mov edx, dword [HomeTeam-2]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        mov edx, eax
        shl eax, 5
        sub eax, edx
        xor ebx, ebx
        mov edx, eax
        mov eax, dword [byte esp+060h]
        call lseek_
        test eax, eax
        jge short .4
        push str_fe4
        call FatalError
        add esp, byte 4
.4:
        mov ecx, 2E8h
        mov ebx, 0FFFFFFFFh
        mov edx, hmteamrec
        mov eax, dword [byte esp+060h]
        call FileReadAt
        test eax, eax
        je short .5
        push str_fe5
        call FatalError
        add esp, byte 4
.5:
        lea eax, [byte esp+060h]
        call FileClose
        push str_teams
        push leaguedbfmt2
        lea eax, [byte esp+038h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea ebx, [byte esp+04h]
        xor edx, edx
        lea eax, [byte esp+030h]
        call _dos_findfirst_
        test eax, eax
        je short .6
        push str_fe1
        call FatalError
        add esp, byte 4
.6:
        lea edx, [byte esp+060h]
        lea eax, [byte esp+030h]
        call FileOpenRead
        test eax, eax
        je short .7
        push str_fe2
        call FatalError
        add esp, byte 4
.7:
        xor ebx, ebx
        xor edx, edx
        mov eax, dword [byte esp+060h]
        call lseek_
        test eax, eax
        je short .8
        push str_fe3
        call FatalError
        add esp, byte 4
.8:
        mov edx, dword [VisTeam-2]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        mov edx, eax
        shl eax, 5
        sub eax, edx
        xor ebx, ebx
        mov edx, eax
        mov eax, dword [byte esp+060h]
        call lseek_
        test eax, eax
        jge short .9
        push str_fe7
        call FatalError
        add esp, byte 4
.9:
        mov ecx, 2E8h
        mov ebx, 0FFFFFFFFh
        mov edx, awteamrec
        mov eax, dword [byte esp+060h]
        call FileReadAt
        test eax, eax
        je short .10
        push str_fe8
        call FatalError
        add esp, byte 4
.10:
        lea eax, [byte esp+060h]
        call FileClose
        lea eax, [byte esp+050h]
        push eax
        push leaguedbfmt
        lea eax, [byte esp+05Ch]
        push eax
        lea ecx, [byte esp+064h]
        lea ebx, [byte esp+068h]
        lea edx, [byte esp+06Ch]
        mov eax, dword [byte esp+0Ch]
        call OpenPlayerDBs
        push byte 0
        mov edx, dword [byte esp+054h]
        push edx
        mov ebx, dword [byte esp+05Ch]
        push ebx
        mov ecx, dword [byte esp+064h]
        mov ebx, dword [byte esp+068h]
        mov edx, dword [byte esp+06Ch]
        mov eax, dword [byte esp+0Ch]
        call LoadTeamRoster
        lea eax, [byte esp+060h]
        call FileClose
        lea eax, [byte esp+05Ch]
        call FileClose
        lea eax, [byte esp+058h]
        call FileClose
        test byte [esp], 6
        jne short .11
        lea eax, [byte esp+054h]
        call FileClose
.11:
        lea eax, [byte esp+050h]
        push eax
        push leaguedbfmt2
        lea eax, [byte esp+05Ch]
        push eax
        lea ecx, [byte esp+064h]
        lea ebx, [byte esp+068h]
        lea edx, [byte esp+06Ch]
        mov eax, dword [byte esp+0Ch]
        call OpenPlayerDBs
        push byte 1
        mov ecx, dword [byte esp+054h]
        push ecx
        mov esi, dword [byte esp+05Ch]
        push esi
        mov ecx, dword [byte esp+064h]
        mov ebx, dword [byte esp+068h]
        mov edx, dword [byte esp+06Ch]
        mov eax, dword [byte esp+0Ch]
        call LoadTeamRoster
        lea eax, [byte esp+060h]
        call FileClose
        lea eax, [byte esp+05Ch]
        call FileClose
        lea eax, [byte esp+058h]
        call FileClose
        test byte [esp], 6
        jne short .12
        lea eax, [byte esp+054h]
        call FileClose
.12:
        mov edi, dword [esp]
        test edi, edi
        je short .13
        cmp edi, byte 2
        jne short .14
.13:
        mov ecx, 0Ch
        mov edi, hmlinetab
        mov esi, hmteamrec+0BCh
        rep movsd
        mov ecx, 0Ch
        mov edi, awlinetab
        mov esi, awteamrec+0BCh
        rep movsd
.14:
        xor eax, eax
        mov cl, 2
.15:
        mov dh, byte [dword eax+hmscratch]
        cmp dh, 64h
        je short .16
        xor ebx, ebx
        mov bl, dh
        mov edx, ebx
        shl edx, 2
        add edx, ebx
        shl edx, 3
        sub edx, ebx
        mov byte [dword edx+hmroster], 2
.16:
        cmp byte [dword eax+awscratch], 64h
        je short .17
        xor ebx, ebx
        mov bl, byte [dword eax+awscratch]
        mov edx, ebx
        shl edx, 2
        add edx, ebx
        shl edx, 3
        sub edx, ebx
        mov byte [dword edx+awroster], cl
.17:
        inc eax
        cmp eax, byte 8
        jl short LoadGameTeams.15
        add esp, byte 64h
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; InitGameSummary                              1BEFD  95 PC, medium confidence
; (a, b): new game: fills the 0Bh-byte game header at C5423 (a, b, Home,
; Visitor, 1), clears the goal / shot counters, LoadCupFinalSeries
;
; unless gameopts+1 bit 1, creates <league>\gsummary.db (MakeGSummaryPath)
; with two 0Bh headers, LoadGameTeams(0), clears the per-player (2 x 25 x 10h
; at hmplstats) and goalie (2 x 3 x 6 at hmglstats) game stats; called
;
; from temp_files, import_export, RunDemoGame and season_playoffs
;-----------------------------------------------------------------------------
; C: src/front/team_db/InitGameSummary.c
%ifdef CBUILD
%include "c/front/team_db/InitGameSummary.inc"
%else
InitGameSummary:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 4
        mov byte [GameRecordMonth], al
        mov byte [GameRecordDay], dl
        mov dword [curperiod], 0FFFFFFFFh
        mov byte [gsumheader_b1], al
        mov byte [gsumheader_b2], dl
        mov al, byte [HomeTeam]
        mov byte [gsumheader_b3], al
        mov al, byte [VisTeam]
        mov byte [gsumheader_b4], al
        mov word [gsumcount], 1
        xor ah, ah
        mov byte [hmgoalcnt], ah
        mov byte [hmshotcnt], ah
        mov byte [awgoalcnt], ah
        mov byte [awshotcnt], ah
        test byte [gameopts+1], 2
        jne short .1
        call LoadCupFinalSeries
.1:
        call MakeGSummaryPath
        mov edx, esp
        mov eax, gsummarypath
        call FileCreate
        test eax, eax
        je short .2
        push str_feB1
        call FatalError
        add esp, byte 4
.2:
        mov ecx, 0Bh
        mov ebx, 0FFFFFFFFh
        mov edx, gsumheader
        mov eax, dword [esp]
        call FileWriteAt
        test eax, eax
        je short .3
        push str_feB5
        call FatalError
        add esp, byte 4
.3:
        mov ecx, 0Bh
        mov ebx, 0FFFFFFFFh
        mov edx, gsumtail
        mov eax, dword [esp]
        call FileWriteAt
        test eax, eax
        je short .4
        push str_feB8
        call FatalError
        add esp, byte 4
.4:
        mov eax, esp
        call FileClose
        xor eax, eax
        call LoadGameTeams
        xor ebx, ebx
        mov word [hmplstats_w14], bx
        mov word [hmplstats_w12], bx
        mov word [hmplstats_w10], bx
        mov word [hmplstats_w8], bx
        mov word [hmplstats_w6], bx
        mov word [hmplstats_w4], bx
        mov word [hmplstats_w2], bx
        mov word [hmplstats], bx
        xor ecx, ecx
.5:
        xor edx, edx
.6:
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 3
        add eax, ecx
        shl eax, 4
        mov esi, edx
        shl esi, 4
        lea edi, [dword esi+eax+hmplstats]
        mov esi, hmplstats
        movsd
        movsd
        movsd
        movsd
        inc edx
        cmp edx, byte 19h
        jl short InitGameSummary.6
        inc ecx
        cmp ecx, byte 2
        jl short InitGameSummary.5
        xor esi, esi
        mov word [hmglstats_w4], si
        mov word [hmglstats_w2], si
        mov word [hmglstats], si
        xor ecx, ecx
.7:
        xor edx, edx
.8:
        mov esi, ecx
        shl esi, 3
        add esi, ecx
        add esi, esi
        mov eax, edx
        shl eax, 2
        sub eax, edx
        lea edi, [dword esi+eax*2+hmglstats]
        mov esi, hmglstats
        movsd
        movsw
        inc edx
        cmp edx, byte 3
        jl short InitGameSummary.8
        inc ecx
        cmp ecx, byte 2
        jl short InitGameSummary.7
        add esp, byte 4
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ReadPlayerRecord                               1C0AF  95 PC, medium confidence
; Reads one player's KEY (34h), ATT, SEASON and CAREER records with lseek /
; FileReadAt (FatalError codes "D".."Q"); ret 20h
;-----------------------------------------------------------------------------
; C: src/front/team_db/ReadPlayerRecord.c
%ifdef CBUILD
%include "c/front/team_db/ReadPlayerRecord.inc"
%else
ReadPlayerRecord:
        push dword 1Ch
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 8
        mov edi, eax
        mov ebp, edx
        mov dword [byte esp+04h], ebx
        mov esi, ecx
        xor ebx, ebx
        xor edx, edx
        call lseek_
        test eax, eax
        je short .1
        push str_feD
        call FatalError
        add esp, byte 4
.1:
        xor ebx, ebx
        mov edx, dword [byte esp+018h]
        mov eax, edi
        call lseek_
        test eax, eax
        jge short .2
        push str_feE
        call FatalError
        add esp, byte 4
.2:
        mov ecx, 34h
        mov ebx, 0FFFFFFFFh
        mov edx, dword [byte esp+01Ch]
        mov eax, edi
        call FileReadAt
        test eax, eax
        je short .3
        push str_feF
        call FatalError
        add esp, byte 4
.3:
        xor ebx, ebx
        xor edx, edx
        mov eax, ebp
        call lseek_
        test eax, eax
        je short .4
        push str_feG
        call FatalError
        add esp, byte 4
.4:
        mov edx, dword [byte esp+01Ch]
        mov edx, dword [byte edx+024h]
        xor ebx, ebx
        mov eax, ebp
        call lseek_
        test eax, eax
        jge short .5
        push str_feH
        call FatalError
        add esp, byte 4
.5:
        mov ecx, dword [byte esp+024h]
        mov ebx, 0FFFFFFFFh
        mov edx, dword [byte esp+020h]
        mov eax, ebp
        call FileReadAt
        test eax, eax
        je short .6
        push str_feI
        call FatalError
        add esp, byte 4
.6:
        xor ebx, ebx
        xor edx, edx
        mov eax, dword [byte esp+04h]
        call lseek_
        test eax, eax
        je short .7
        push str_feL
        call FatalError
        add esp, byte 4
.7:
        mov edx, dword [byte esp+01Ch]
        mov edx, dword [byte edx+02Ch]
        xor ebx, ebx
        mov eax, dword [byte esp+04h]
        call lseek_
        test eax, eax
        jge short .8
        push str_feM
        call FatalError
        add esp, byte 4
.8:
        mov ecx, dword [byte esp+02Ch]
        mov ebx, 0FFFFFFFFh
        mov edx, dword [byte esp+028h]
        mov eax, dword [byte esp+04h]
        call FileReadAt
        test eax, eax
        je short .9
        push str_feN
        call FatalError
        add esp, byte 4
.9:
        mov edx, dword [byte esp+034h]
        test edx, edx
        jne short .10
        mov dword [esp], edx
        jmp short .13
.10:
        xor ebx, ebx
        xor edx, edx
        mov eax, esi
        call lseek_
        test eax, eax
        je short .11
        push str_feO
        call FatalError
        add esp, byte 4
.11:
        mov edx, dword [byte esp+01Ch]
        mov edx, dword [byte edx+028h]
        xor ebx, ebx
        mov eax, esi
        call lseek_
        test eax, eax
        jge short .12
        push str_feP
        call FatalError
        add esp, byte 4
.12:
        mov ecx, dword [byte esp+034h]
        mov ebx, 0FFFFFFFFh
        mov edx, dword [byte esp+030h]
        mov eax, esi
        call FileReadAt
        test eax, eax
        je short .13
        push str_feQ
        call FatalError
        add esp, byte 4
.13:
        mov eax, dword [esp]
        add esp, byte 8
        pop ebp
        pop edi
        pop esi
        ret 20h
%endif ; C
;-----------------------------------------------------------------------------
; OpenPlayerDBs                                1C26C  95 PC, medium confidence
; (path fmt, &key, &att, &season, &career): FileOpenRead of "key", "att",
; "season" and (unless mode bits 6) "career" .DB for one side
;
; (FatalError "9".."K")
;-----------------------------------------------------------------------------
; C: src/front/team_db/OpenPlayerDBs.c
%ifdef CBUILD
%include "c/front/team_db/OpenPlayerDBs.inc"
%else
OpenPlayerDBs:
        push dword 6Ch
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 4Ch
        push eax
        mov edi, edx
        mov ebp, ebx
        mov esi, ecx
        push str_key
        mov edx, dword [byte esp+068h]
        push edx
        lea eax, [byte esp+038h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea ebx, [byte esp+04h]
        xor edx, edx
        lea eax, [byte esp+030h]
        call _dos_findfirst_
        test eax, eax
        je short .1
        push str_fe9
        call FatalError
        add esp, byte 4
.1:
        mov edx, edi
        lea eax, [byte esp+030h]
        call FileOpenRead
        test eax, eax
        je short .2
        push str_feA
        call FatalError
        add esp, byte 4
.2:
        push str_att
        mov ebx, dword [byte esp+068h]
        push ebx
        lea eax, [byte esp+038h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea ebx, [byte esp+04h]
        xor edx, edx
        lea eax, [byte esp+030h]
        call _dos_findfirst_
        test eax, eax
        je short .3
        push str_feB
        call FatalError
        add esp, byte 4
.3:
        mov edx, ebp
        lea eax, [byte esp+030h]
        call FileOpenRead
        test eax, eax
        je short .4
        push str_feC
        call FatalError
        add esp, byte 4
.4:
        push str_season
        mov ecx, dword [byte esp+068h]
        push ecx
        lea eax, [byte esp+038h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea ebx, [byte esp+04h]
        xor edx, edx
        lea eax, [byte esp+030h]
        call _dos_findfirst_
        test eax, eax
        je short .5
        push str_feJ
        call FatalError
        add esp, byte 4
.5:
        mov edx, esi
        lea eax, [byte esp+030h]
        call FileOpenRead
        test eax, eax
        je short .6
        push str_feK
        call FatalError
        add esp, byte 4
.6:
        test byte [esp], 6
        je short .7
        mov eax, dword [byte esp+068h]
        mov dword [eax], 0
        jmp short .10
.7:
        push str_career
        mov esi, dword [byte esp+068h]
        push esi
        lea eax, [byte esp+038h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea ebx, [byte esp+04h]
        xor edx, edx
        lea eax, [byte esp+030h]
        call _dos_findfirst_
        test eax, eax
        je short .8
        push str_feL
        call FatalError
        add esp, byte 4
.8:
        mov edx, dword [byte esp+060h]
        lea eax, [byte esp+030h]
        call FileOpenRead
        test eax, eax
        je short .9
        push str_feM
        call FatalError
        add esp, byte 4
.9:
        mov eax, dword [byte esp+068h]
        mov dword [eax], 28h
.10:
        add esp, byte 50h
OpenPlayerDBs_x:
        pop ebp
        pop edi
        pop esi
        ret 0Ch
%endif ; C
;-----------------------------------------------------------------------------
; LoadTeamRoster                               1C3F6  95 PC, medium confidence
; (side, file handles...): for each roster slot of the team record reads the
; player records
;
; (ReadPlayerRecord at hmteamrec_skaters offsets) into hmroster / awroster
; entries (names, attributes, status bytes 1 / 3 / 5)
;-----------------------------------------------------------------------------
LoadTeamRoster:
        push dword 130h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, 0F0h
        push eax
        push edx
        push ebx
        push ecx
        xor ebp, ebp
.1:
        mov edx, dword [dword esp+0118h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        mov edx, eax
        shl eax, 5
        sub eax, edx
        mov edx, ebp
        shl edx, 2
        add edx, eax
        mov eax, ebp
        shl eax, 2
        add eax, ebp
        shl eax, 3
        sub eax, ebp
        mov dword [dword esp+0FCh], eax
        mov esi, dword [dword esp+0118h]
        mov edi, esi
        shl edi, 4
        add edi, esi
        shl edi, 4
        add edi, esi
        shl edi, 2
        lea esi, [eax+edi]
        mov ebx, dword [dword edx+hmteamrec_skaters]
        test ebx, ebx
        jl near .12
        mov ecx, dword [dword esp+0114h]
        push ecx
        lea eax, [dword esp+0B0h]
        push eax
        push byte 2Fh
        lea eax, [dword esp+088h]
        push eax
        push byte 14h
        lea eax, [dword esp+0E8h]
        push eax
        lea eax, [byte esp+060h]
        push eax
        push ebx
        mov ecx, dword [dword esp+0130h]
        mov ebx, dword [byte esp+020h]
        mov edx, dword [byte esp+024h]
        mov eax, dword [byte esp+028h]
        call ReadPlayerRecord
        mov al, byte [byte esp+049h]
        mov byte [dword esi+hmrosterjersey], al
        mov al, byte [byte esp+04Ah]
        mov byte [dword esi+hmrosterpos], al
        mov ebx, hmroster
        add ebx, edi
        add ebx, dword [dword esp+0FCh]
        lea eax, [byte ebx+07h]
        lea edx, [byte esp+04Bh]
        call strcpy_
        lea eax, [byte ebx+017h]
        lea edx, [byte esp+05Bh]
        call strcpy_
        mov ebx, dword [byte esp+0Ch]
        test ebx, ebx
        je short .2
        cmp ebx, byte 2
        jne short .7
.2:
        mov esi, ebp
        shl esi, 2
        add esi, ebp
        shl esi, 3
        sub esi, ebp
        mov edx, dword [dword esp+0118h]
        mov eax, edx
        shl eax, 4
        add eax, edx
        shl eax, 4
        add eax, edx
        shl eax, 2
        add esi, eax
        mov al, byte [GameRecordMonth]
        mov dh, byte [dword esp+0A2h]
        cmp al, dh
        jae short .4
.3:
        mov byte [dword esi+hmroster], 1
        jmp short .9
.4:
        jbe short .6
.5:
        mov byte [dword esi+hmroster], 3
        jmp short .9
.6:
        mov al, byte [GameRecordDay]
        cmp al, byte [dword esp+0A3h]
        jb short LoadTeamRoster.3
        jmp short LoadTeamRoster.5
.7:
        mov edx, dword [dword esp+0118h]
        shl edx, 8
        mov eax, ebp
        mov eax, dword [dword edx+eax*2+hmtmpdst_m2]
        sar eax, 10h
        test eax, eax
        jle short .8
        mov byte [dword esi+hmroster], 5
        jmp short .9
.8:
        neg eax
        mov al, byte [nosplit eax*2+RosterStatusByInjury]
        mov byte [dword esi+hmroster], al
.9:
        mov edx, dword [dword esp+0118h]
        mov esi, edx
        shl esi, 5
        sub esi, edx
        shl esi, 2
        add esi, edx
        shl esi, 2
        mov eax, ebp
        shl eax, 2
        add eax, ebp
        lea edi, [dword esi+eax*4+hmplattr]
        lea esi, [dword esp+0D4h]
        movsd
        movsd
        movsd
        movsd
        movsd
        test byte [byte esp+0Ch], 6
        jne near .13
        mov edx, dword [dword esp+0118h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add eax, edx
        shl eax, 4
        mov edx, ebp
        shl edx, 4
        add eax, edx
        test byte [gameopts+1], 2
        je short .11
        xor edx, edx
        mov dx, word [dword esp+0D0h]
        mov dword [dword eax+plcareergoals], edx
        mov ebx, edx
        xor edx, edx
        mov dx, word [dword esp+0D2h]
        add edx, ebx
        mov dword [dword eax+plcareerpts], edx
        xor edx, edx
        mov dx, word [byte esp+07Eh]
        mov dword [dword eax+plseasongoals], edx
        mov ebx, edx
        xor edx, edx
        mov dx, word [dword esp+080h]
.10:
        add edx, ebx
        mov dword [dword eax+plseasonpts], edx
        jmp short .13
.11:
        xor esi, esi
        mov dword [dword eax+plcareergoals], esi
        mov edx, esi
        mov dword [dword eax+plcareerpts], esi
        mov dx, word [dword esp+090h]
        mov dword [dword eax+plseasongoals], edx
        mov ebx, edx
        xor edx, edx
        mov dx, word [dword esp+092h]
        jmp short LoadTeamRoster.10
.12:
        xor ah, ah
        mov byte [dword esi+hmroster], ah
.13:
        inc ebp
        cmp ebp, byte 19h
        jl near LoadTeamRoster.1
        xor ebp, ebp
.14:
        mov edx, dword [dword esp+0118h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        mov edx, eax
        shl eax, 5
        sub eax, edx
        mov edx, ebp
        shl edx, 2
        add edx, eax
        lea ebx, [byte ebp+019h]
        mov esi, dword [dword esp+0118h]
        mov eax, esi
        shl eax, 4
        add eax, esi
        shl eax, 4
        add eax, esi
        shl eax, 2
        mov dword [dword esp+0F8h], eax
        mov edi, ebx
        shl edi, 2
        add edi, ebx
        shl edi, 3
        sub edi, ebx
        lea esi, [eax+edi]
        cmp dword [dword edx+hmteamrec_goalies], byte 0
        jl near .23
        push byte 0
        push byte 0
        push byte 36h
        lea eax, [byte esp+01Ch]
        push eax
        push byte 10h
        lea eax, [dword esp+0FCh]
        push eax
        lea eax, [byte esp+060h]
        push eax
        mov ebx, dword [dword edx+hmteamrec_goalies]
        push ebx
        xor ecx, ecx
        mov ebx, dword [byte esp+020h]
        mov edx, dword [byte esp+024h]
        mov eax, dword [byte esp+028h]
        call ReadPlayerRecord
        mov al, byte [byte esp+049h]
        mov byte [dword esi+hmrosterjersey], al
        mov al, byte [byte esp+04Ah]
        mov byte [dword esi+hmrosterpos], al
        mov ebx, hmroster
        add ebx, dword [dword esp+0F8h]
        add ebx, edi
        lea eax, [byte ebx+07h]
        lea edx, [byte esp+04Bh]
        call strcpy_
        lea eax, [byte ebx+017h]
        lea edx, [byte esp+05Bh]
        call strcpy_
        mov edi, dword [byte esp+0Ch]
        test edi, edi
        je short .15
        cmp edi, byte 2
        jne short .20
.15:
        lea ebx, [byte ebp+019h]
        mov edx, dword [dword esp+0118h]
        mov esi, edx
        shl esi, 4
        add esi, edx
        shl esi, 4
        add esi, edx
        shl esi, 2
        mov eax, ebx
        shl eax, 2
        add eax, ebx
        shl eax, 3
        sub eax, ebx
        add esi, eax
        mov al, byte [GameRecordMonth]
        mov cl, byte [byte esp+03Eh]
        cmp al, cl
        jae short .17
.16:
        mov byte [dword esi+hmroster], 1
        jmp short .22
.17:
        jbe short .19
.18:
        mov byte [dword esi+hmroster], 3
        jmp short .22
.19:
        mov al, byte [GameRecordDay]
        cmp al, byte [byte esp+03Fh]
        jb short LoadTeamRoster.16
        jmp short LoadTeamRoster.18
.20:
        mov eax, dword [dword esp+0118h]
        shl eax, 8
        mov edx, ebp
        mov eax, dword [dword eax+edx*2+hmtmpdst_gl_m2]
        sar eax, 10h
        test eax, eax
        jle short .21
        mov byte [dword esi+hmroster], 5
        jmp short .22
.21:
        neg eax
        mov al, byte [nosplit eax*2+RosterStatusByInjury]
        mov byte [dword esi+hmroster], al
.22:
        mov edx, dword [dword esp+0118h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 4
        mov esi, ebp
        shl esi, 4
        lea edi, [dword esi+eax+hmglattr]
        lea esi, [dword esp+0E8h]
        movsd
        movsd
        movsd
        movsd
        jmp short .24
.23:
        xor bl, bl
        mov byte [dword esi+hmroster], bl
.24:
        inc ebp
        cmp ebp, byte 3
        jl near LoadTeamRoster.14
        add esp, 100h
        jmp near OpenPlayerDBs_x
;-----------------------------------------------------------------------------
; MakeGSummaryPath                                                1C807  95 PC
; Gsummarypath = "<curleague>\gsummary.db" (just "gsummary.db" without a
; league)
;-----------------------------------------------------------------------------
; C: src/front/team_db/MakeGSummaryPath.c
%ifdef CBUILD
%include "c/front/team_db/MakeGSummaryPath.inc"
%else
MakeGSummaryPath:
        push dword 8
        call __CHK
        push edx
        xor ah, ah
        mov byte [gsummarypath], ah
        cmp byte [curleague], 0
        je short .1
        mov edx, curleague
        mov eax, gsummarypath
        call strcpy_
        mov edx, str_backslash3
        mov eax, gsummarypath
        call strcat_
.1:
        mov edx, str_GsummaryDb2
        mov eax, gsummarypath
        call strcat_
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SetupGoalieMenu                              1C852  95 PC, medium confidence
; Fills the goalie menu items (mi_HomeGoalie1/2, mi_AwayGoalie1/2) with "nn X.
;
; Name" for each side's two goalies (hmgoalieidx / awgoalieidx in hmroster /
; awroster), sizes the menu columns and marks the goalie in net (hmtmgoalie,
; NONE when pulled); called from PlayGame
;-----------------------------------------------------------------------------
; C: src/front/team_db/SetupGoalieMenu.c
%ifdef CBUILD
%include "c/front/team_db/SetupGoalieMenu.inc"
%else
SetupGoalieMenu:
        push dword 38h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        sub esp, byte 20h
        mov esi, hmgoaliemenu
        xor edx, edx
        mov dl, byte [hmgoalieidx]
        mov ebx, edx
        shl ebx, 2
        add ebx, edx
        shl ebx, 3
        sub ebx, edx
        add ebx, hmroster
        mov edx, dword [mi_HomeGoalie1]
        mov eax, esp
        call strcpy_
        mov ah, byte [byte ebx+05h]
        cmp ah, 0Ah
        jae short .1
        mov al, byte [byte esp+01h]
        mov byte [byte esp+02h], al
        jmp short .2
.1:
        xor edx, edx
        mov dl, ah
        mov ecx, 0Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov edx, dword [byte esp-01h]
        sar edx, 18h
        add edx, eax
        mov byte [byte esp+02h], dl
.2:
        xor edx, edx
        mov dl, byte [byte ebx+05h]
        mov ecx, 0Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov eax, edx
        mov edx, dword [esp]
        sar edx, 18h
        add edx, eax
        mov byte [byte esp+03h], dl
        mov al, byte [byte ebx+07h]
        mov byte [byte esp+05h], al
        lea edx, [byte ebx+017h]
        mov ebx, 10h
        lea eax, [byte esp+08h]
        call strncpy_
        mov eax, esp
        push eax
        call fputchar
        add esp, byte 4
        add eax, byte 5
        mov dword [byte esi+08h], eax
        mov eax, dword [byte esi+010h]
        mov edx, esp
        call strcpy_
        xor edx, edx
        mov dl, byte [hmgoalieidx+1]
        mov ebx, edx
        shl ebx, 2
        add ebx, edx
        shl ebx, 3
        sub ebx, edx
        add ebx, hmroster
        mov edx, dword [byte esi+030h]
        mov eax, esp
        call strcpy_
        cmp byte [byte ebx+05h], 0Ah
        jae short .3
        mov al, byte [byte esp+01h]
        mov byte [byte esp+02h], al
        jmp short .4
.3:
        xor edx, edx
        mov dl, byte [byte ebx+05h]
        mov ecx, 0Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov edx, dword [byte esp-01h]
        sar edx, 18h
        add edx, eax
        mov byte [byte esp+02h], dl
.4:
        xor edx, edx
        mov dl, byte [byte ebx+05h]
        mov ecx, 0Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov eax, edx
        mov edx, dword [esp]
        sar edx, 18h
        add edx, eax
        mov byte [byte esp+03h], dl
        mov al, byte [byte ebx+07h]
        mov byte [byte esp+05h], al
        lea edx, [byte ebx+017h]
        mov ebx, 10h
        lea eax, [byte esp+08h]
        call strncpy_
        mov eax, esp
        push eax
        call fputchar
        add esp, byte 4
        add eax, byte 5
        mov dword [byte esi+028h], eax
        mov eax, dword [byte esi+030h]
        mov edx, esp
        call strcpy_
        mov eax, dword [byte esi+08h]
        mov edx, dword [byte esi+028h]
        cmp eax, edx
        jle short .5
        mov dword [byte esi+048h], eax
        mov dword [byte esi+028h], eax
        jmp short .6
.5:
        mov dword [byte esi+048h], edx
        mov dword [byte esi+08h], edx
.6:
        cmp word [hmtmgoalie], byte 0
        jge short .7
        mov eax, dword [byte esi+050h]
        jmp short .8
.7:
        mov eax, dword [hmtmgoalie-2]
        sar eax, 10h
        shl eax, 5
        mov eax, dword [byte esi+eax+010h]
.8:
        mov byte [eax], 1
        mov esi, awgoaliemenu
        xor edx, edx
        mov dl, byte [awgoalieidx]
        mov ebx, edx
        shl ebx, 2
        add ebx, edx
        shl ebx, 3
        sub ebx, edx
        add ebx, awroster
        mov edx, dword [mi_AwayGoalie1]
        mov eax, esp
        call strcpy_
        cmp byte [byte ebx+05h], 0Ah
        jae short .9
        mov al, byte [byte esp+01h]
        mov byte [byte esp+02h], al
        jmp short .10
.9:
        xor edx, edx
        mov dl, byte [byte ebx+05h]
        mov ecx, 0Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov edx, dword [byte esp-01h]
        sar edx, 18h
        add edx, eax
        mov byte [byte esp+02h], dl
.10:
        xor edx, edx
        mov dl, byte [byte ebx+05h]
        mov ecx, 0Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov eax, edx
        mov edx, dword [esp]
        sar edx, 18h
        add edx, eax
        mov byte [byte esp+03h], dl
        mov al, byte [byte ebx+07h]
        mov byte [byte esp+05h], al
        lea edx, [byte ebx+017h]
        mov ebx, 10h
        lea eax, [byte esp+08h]
        call strncpy_
        mov eax, esp
        push eax
        call fputchar
        add esp, byte 4
        add eax, byte 5
        mov dword [byte esi+08h], eax
        mov eax, dword [byte esi+010h]
        mov edx, esp
        call strcpy_
        xor edx, edx
        mov dl, byte [awgoalieidx+1]
        mov ebx, edx
        shl ebx, 2
        add ebx, edx
        shl ebx, 3
        sub ebx, edx
        add ebx, awroster
        mov edx, dword [byte esi+030h]
        mov eax, esp
        call strcpy_
        mov cl, byte [byte ebx+05h]
        cmp cl, 0Ah
        jae short .11
        mov al, byte [byte esp+01h]
        mov byte [byte esp+02h], al
        jmp short .12
.11:
        xor edx, edx
        mov dl, cl
        mov ecx, 0Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov edx, dword [byte esp-01h]
        sar edx, 18h
        add edx, eax
        mov byte [byte esp+02h], dl
.12:
        xor edx, edx
        mov dl, byte [byte ebx+05h]
        mov ecx, 0Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov eax, edx
        mov edx, dword [esp]
        sar edx, 18h
        add edx, eax
        mov byte [byte esp+03h], dl
        mov al, byte [byte ebx+07h]
        mov byte [byte esp+05h], al
        lea edx, [byte ebx+017h]
        mov ebx, 10h
        lea eax, [byte esp+08h]
        call strncpy_
        mov eax, esp
        push eax
        call fputchar
        add esp, byte 4
        add eax, byte 5
        mov dword [byte esi+028h], eax
        mov eax, dword [byte esi+030h]
        mov edx, esp
        call strcpy_
        mov eax, dword [byte esi+08h]
        mov ebx, dword [byte esi+028h]
        cmp eax, ebx
        jle short .13
        mov dword [byte esi+048h], eax
        mov dword [byte esi+028h], eax
        jmp short .14
.13:
        mov dword [byte esi+048h], ebx
        mov dword [byte esi+08h], ebx
.14:
        cmp word [awtmgoalie], byte 0
        jge short .15
        mov eax, dword [byte esi+050h]
        jmp short .16
.15:
        mov eax, dword [awtmgoalie-2]
        sar eax, 10h
        shl eax, 5
        mov eax, dword [byte esi+eax+010h]
.16:
        mov byte [eax], 1
        add esp, byte 20h
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ResetGoalieMenu                                                 1CB7F  95 PC
; Copies the "00 X. XXXXXXXXXXXXXXXX" template back into the four goalie
; items and unmarks the NONE items; called at the end of PlayGame
;-----------------------------------------------------------------------------
; C: src/front/team_db/ResetGoalieMenu.c
%ifdef CBUILD
%include "c/front/team_db/ResetGoalieMenu.inc"
%else
ResetGoalieMenu:
        push dword 8
        call __CHK
        push edx
        mov eax, dword [mi_HomeGoalie1]
        mov edx, str_GoalieItemTmpl
        call strcpy_
        mov eax, dword [mi_HomeGoalie2]
        mov edx, str_GoalieItemTmpl
        call strcpy_
        mov eax, dword [mi_HomeGoalieNone]
        mov byte [eax], 2
        mov eax, dword [mi_AwayGoalie1]
        mov edx, str_GoalieItemTmpl
        call strcpy_
        mov eax, dword [mi_AwayGoalie2]
        mov edx, str_GoalieItemTmpl
        call strcpy_
        mov eax, dword [mi_AwayGoalieNone]
        mov byte [eax], 2
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ClearPanelPenalties                          1CBD8  95 PC, medium confidence
; Empties the 8-entry hudpenhome / hudpenaway lists (-1, times 0), then
; LoadScoreboardGfx; LoadGameGfx_common
;-----------------------------------------------------------------------------
; C: src/front/team_db/ClearPanelPenalties.c
%ifdef CBUILD
%include "c/front/team_db/ClearPanelPenalties.inc"
%else
ClearPanelPenalties:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        xor edx, edx
        mov ebx, 0FFFFFFFFh
.1:
        mov word [nosplit edx*8+hudpenaway], bx
        mov word [nosplit edx*8+hudpenhome], bx
        xor ecx, ecx
        mov word [nosplit edx*8+awpanelpen_w6], cx
        mov word [nosplit edx*8+hmpanelpen_w6], cx
        mov word [nosplit edx*8+awpanelpen_w4], cx
        mov word [nosplit edx*8+hmpanelpen_w4], cx
        mov word [nosplit edx*8+awpanelpen_time], cx
        mov word [nosplit edx*8+hmpanelpen_time], cx
        inc edx
        cmp edx, byte 8
        jl short ClearPanelPenalties.1
        call LoadScoreboardGfx
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
