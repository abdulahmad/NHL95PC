; The league calendar, stepping to the next or previous month, playing a league game, posting the result
; into the team files, and the team grid used while setting a league up.
bits 32
%include "hockey.inc"
section s_33FFD progbits alloc exec nowrite align=1
extern __CHK, __STOSB, _fstrcspn_, AskTeamPassword, awlinetab, awscore, awtmgoalie, awtmlines
extern btn_MasterDB, byte_D42C3, byte_DC267, byte_DC268, lgschedrec, lgschedrec_b1, lgschedrec_b2, lgschedrec_b3
extern lgschedrec_b5, calcolx, calendarshapes, calexit, CalGoalieStatsScreen, calmenubar, calmonth, calnextslot
extern calprevslot, calrowy, calsel, calselday, calselmonth, CalSkaterStatsScreen, CalStandingsMenu, CalStandingsScreen
extern CalTeamStatsScreen, cddriveptr, CheckGameDiskSpace, ClearInputQueue, crestnames, curleague, dlgtextbg, dlgtextfg
extern DrawMenuBar, DrawMenuDropdown, DrawMenuItemNorm, DrawMenuItemSel, msg_MergeNeeded_e01, hmplstats, dword_DC23E, calredraw
extern dword_DDD34, dword_DDD3C, lgschedrec_b4, FadeOutPalCycle, FadePalStep, FileClose, FileExists, fileoncd
extern FileOpenRead, FileOpenRW, FileOpenWrite, FileReadAt, FileWriteAt, FindLeagueFloppy, firstteammsg, FmtFromLeague
extern fontcolor, fputchar, FreeMemBlock, GameGoalieStatsScreen, gameopts, gameresult, GameSkaterStatsScreen, GameStandingsMenu
extern GameStandingsScreen, GameTeamStatsScreen, GetInputEvent, GetLeagueId, goaliestatscb, gridcellbuf, gridcellx, gridcelly
extern hmlinetab, hmscore, hmtmgoalie, hmtmlines, hmtmstruct, HomeTeam, humancount, InitGameSummary
extern InputInstall, InputRemove, LeagueCheckStub, leaguedbfmt, leaguedbfmt2, leaguedbnames, leaguediskmsg, leagueflags
extern leaguemaster, leaguesaved, leagueteams, LeagueTeamSelect, lggameidx, lgplayteam, lgteam_17, lgteamflags
extern LoadLeagueGameRef, mainfont, MakePath, masterpw, memset_, MenuHitTest, MergeLeagueFiles, MessageBox
extern monthdays, monthfirstday, monthfirstday_m1, MouseSetPos, msg_InsertDisk_arg, musichandle, musicon, musicslot
extern playerdbsmsg, PlayGame, pointerspr, PreGameScreen, PrintCenteredText, PrintShadowText, ptrupdatefn, ReadGoalieSeasonRec
extern ReadGSummaryRec, ReadKeyRec, ReadLeagueInfo, ReadLeagueTeamEntry, ReadSchedGame, ReadSeasonRec, ReadTeamNames, ReadTeamRec
extern RestoreDialogBg, savedname, savepal, savleague1, savleague2, schedgameidx, SetCtlTeams, SetDialogColors
extern SetTextColors, SetupControllers, ShowLoadingScreen, skaterstatscb, songdata, sprintf_, standingscb, standingsmenucb
extern starpl, startm, startm_m2, str_02d, str_02d9D, str_Away, str_Back, str_backslash2
extern str_Bkgd7, str_Boxb, str_Boxr, str_Calendar, str_Callogo, str_Callogo2, str_D8, str_dot
extern str_Easndesk2, str_extDB, str_extxx, str_floppydrv, str_GAME, str_GSUMMARY, str_Home, str_Iff9
extern str_L7, str_Menubuff5, str_MustBeExportedTo, str_MustBeImportedFrom, str_Pal17, str_Pal18, str_PINFO, str_Pointer8
extern str_S4, str_SAV, str_SDD2, str_SelectATeamTo, str_T5, str_Temp5, str_W5, str_Xx
extern strcat_, strcpy_, AllocMemBlock, sub_8D2F0, LoadBank, TextSaveState, TextRestoreState, TextSetFont
extern sub_8F98F, sub_8FB8E, SndQuery, sub_8FCDF, SetPalette, PutBlock, DrawBitmap, DrawArt
extern sub_913D0, GrabBlock, PrintString, sub_92F50, sub_93000, MouseRead, SetViewRect, FindShape
extern ClearScreen, VgaSetPalette, sub_B4BA8, SetClipWindow, SetColorRemap, sub_B4FAC, teamstatscb, treeteamnames
extern msg_DbUpdateError, msg_MergeNeeded, btn_MergeNeeded, hmglstats, UpdatePlayoffSeries, UpdateSeasonSchedule, UpdateTeamDbs, updschedmsg
extern VisTeam, WaitLeagueFloppy, hmplstats_w2, hmplstats_w4, hmplstats_w6, hmplstats_w8, hmplstats_w10, hmplstats_w14
extern hmglstats_w2, hmglstats_w4, word_DDD48, word_DDD4A, WriteGoalieSeasonRec, WriteSchedGame, WriteSeasonRec, WriteTeamRec
global DrawCalendarDay, CalNextMonth, CalPrevMonth, CalReturn, ApplyShapePalette, SetGameSides, CalendarScreen, CheckLeagueDiskSync
global MakeTeamDbFmt, PostGameToTeamDb, PlayLeagueGame, TeamGridHitTest, DrawTeamGridName, SaveGridCellBg, RestoreGridCellBg, HighlightGridCell
global DrawTeamGrid
;-----------------------------------------------------------------------------
; DrawCalendarDay                              33FFD  95 PC, medium confidence
; Draws one calendar day box (boxr / boxb) at calcolx / calrowy: day number,
; opponent crest, Home / Away and the W / L / T "%s:%d-%d" result
;-----------------------------------------------------------------------------
DrawCalendarDay:
        push dword 0CCh
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, 9Ch
        push eax
        push edx
        push ecx
        mov esi, dword [dword esp+0C4h]
        push str_Boxr
        push esi
        call FindShape
        add esp, byte 8
        mov dword [dword esp+084h], eax
        push str_Boxb
        push esi
        call FindShape
        add esp, byte 8
        mov dword [dword esp+094h], eax
        push str_Bkgd7
        push esi
        call FindShape
        add esp, byte 8
        push eax
        call DrawBitmap
        add esp, byte 4
        mov edx, dword [byte esp+08h]
        cmp edx, byte 9
        setl al
        and eax, 0FFh
        add eax, byte 3
        push eax
        lea eax, [byte edx+01h]
        push eax
        push str_02d9D
        lea eax, [byte esp+058h]
        push eax
        call sprintf_
        add esp, byte 10h
        lea eax, [byte esp+04Ch]
        push eax
        push esi
        call FindShape
        add esp, byte 8
        push eax
        call DrawBitmap
        add esp, byte 4
        mov ecx, dword [dword esp+0BCh]
        shl ecx, 2
        mov ebx, dword [dword ecx+crestnames]
        mov byte [byte esp+04Ch], 21h
        mov al, byte [ebx]
        mov byte [byte esp+04Dh], al
        mov al, byte [byte ebx+01h]
        mov byte [byte esp+04Eh], al
        mov al, byte [byte ebx+02h]
        mov byte [byte esp+04Fh], al
        push byte 3Fh
        push byte 26h
        add ecx, dword [byte esp+0Ch]
        mov esi, dword [ecx]
        push esi
        call sub_913D0
        add esp, byte 0Ch
        lea eax, [byte esp+0Ch]
        push eax
        call TextSaveState
        add esp, byte 4
        mov edi, dword [dword esp+0C0h]
        push edi
        call TextSetFont
        add esp, byte 4
        mov dword [fontcolor], 0C0h
        mov eax, dword [byte esp+08h]
        cmp byte [dword eax+monthfirstday], 0
        je short .1
        mov esi, dword [calcolx]
        add esi, byte 7
        mov edi, dword [calrowy]
        jmp short .2
.1:
        mov esi, dword [calcolx+18h]
        add esi, byte 7
        mov edi, dword [calrowy+14h]
.2:
        add edi, byte 5
        mov dword [fontcolor], 0B6h
        push edi
        push esi
        push str_Home
        call PrintString
        add esp, byte 0Ch
        mov dword [fontcolor], 0B7h
        add edi, byte 0Ch
        push edi
        push esi
        push str_Away
        call PrintString
        add esp, byte 0Ch
        xor ebp, ebp
        jmp near .4
.3:
        xor ebx, ebx
        mov eax, dword [byte esp+08h]
        mov bl, byte [dword eax+monthfirstday]
        add ebx, ebp
        mov esi, 7
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv esi
        mov esi, edx
        mov ecx, 7
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ecx
        mov esi, dword [nosplit esi*4+calcolx]
        add esi, byte 4
        mov edi, dword [nosplit eax*4+calrowy]
        inc edi
        inc ebp
        push ebp
        push str_D8
        lea eax, [byte esp+054h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov dword [fontcolor], 0C0h
        push edi
        push esi
        lea eax, [byte esp+054h]
        push eax
        call PrintString
        add esp, byte 0Ch
        mov dword [fontcolor], 0FFh
        dec edi
        push edi
        dec esi
        push esi
        lea eax, [byte esp+054h]
        push eax
        call PrintString
        add esp, byte 0Ch
.4:
        xor eax, eax
        mov ebx, dword [byte esp+08h]
        mov al, byte [dword ebx+monthdays]
        cmp ebp, eax
        jl near DrawCalendarDay.3
        mov dword [dword esp+098h], 0FFFFFFFFh
        xor ebp, ebp
        jmp near .18
.5:
        mov ebx, ebp
        shl ebx, 2
        sub ebx, ebp
        add ebx, ebx
        add ebx, dword [esp]
        xor ecx, ecx
        mov cl, byte [ebx]
        mov eax, dword [byte esp+08h]
        inc eax
        cmp ecx, eax
        jne near .17
        xor ecx, eax
        mov cl, byte [byte ebx+01h]
        xor eax, eax
        mov esi, dword [byte esp+08h]
        mov al, byte [dword esi+monthfirstday]
        add eax, ecx
        lea esi, [byte eax-01h]
        mov ecx, 7
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ecx
        mov edi, edx
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ecx
        mov esi, edi
        mov esi, dword [nosplit esi*4+calcolx]
        mov edi, dword [nosplit eax*4+calrowy]
        xor eax, eax
        mov al, byte [byte ebx+02h]
        cmp eax, dword [dword esp+0BCh]
        jne short .10
        mov eax, dword [dword esp+084h]
        mov dword [dword esp+09Ch], eax
        xor eax, eax
        mov al, byte [byte ebx+03h]
        mov dword [dword esp+0A4h], eax
        mov al, byte [byte ebx+04h]
        mov ch, byte [byte ebx+05h]
        cmp al, ch
        jbe short .7
        xor eax, eax
        mov al, ch
        push eax
        xor eax, eax
        mov al, byte [byte ebx+04h]
.6:
        push eax
        push str_W5
        jmp near .13
.7:
        jae short .9
        xor eax, eax
        mov al, ch
        push eax
        xor eax, eax
        mov al, byte [byte ebx+04h]
.8:
        push eax
        push str_L7
        jmp short .13
.9:
        xor eax, eax
        mov al, ch
        push eax
        xor eax, eax
        mov al, byte [byte ebx+04h]
        push eax
        push str_T5
        jmp short .13
.10:
        mov ecx, dword [dword esp+094h]
        mov dword [dword esp+09Ch], ecx
        mov dword [dword esp+0A4h], eax
        mov al, byte [byte ebx+04h]
        mov dh, byte [byte ebx+05h]
        cmp al, dh
        jbe short .11
        xor eax, eax
        mov al, byte [byte ebx+04h]
        push eax
        xor eax, eax
        mov al, dh
        jmp short DrawCalendarDay.8
.11:
        jae short .12
        xor eax, eax
        mov al, byte [byte ebx+04h]
        push eax
        xor eax, eax
        mov al, dh
        jmp short DrawCalendarDay.6
.12:
        xor eax, eax
        mov al, dh
        push eax
        xor eax, eax
        mov al, byte [byte ebx+04h]
        push eax
        push str_T5
.13:
        push str_SDD2
        lea eax, [byte esp+07Ch]
        push eax
        call sprintf_
        add esp, byte 14h
        mov ebx, ebp
        shl ebx, 2
        sub ebx, ebp
        add ebx, ebx
        mov eax, dword [esp]
        add eax, ebx
        mov dword [dword esp+0A0h], eax
        cmp byte [byte eax+04h], 0FFh
        je short .14
        cmp byte [byte eax+05h], 0FFh
        jne near .15
.14:
        push edi
        push esi
        mov edx, dword [dword esp+0A4h]
        push edx
        call DrawArt
        add esp, byte 0Ch
        push edi
        push esi
        mov eax, dword [dword esp+0ACh]
        shl eax, 2
        add eax, dword [byte esp+0Ch]
        mov ecx, dword [eax]
        push ecx
        call DrawArt
        add esp, byte 0Ch
        mov ebx, ebp
        shl ebx, 2
        sub ebx, ebp
        mov eax, dword [esp]
        mov al, byte [byte eax+ebx*2+01h]
        and eax, 0FFh
        push eax
        push str_D8
        lea eax, [byte esp+054h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov dword [fontcolor], 0FFh
        lea eax, [byte edi+01h]
        push eax
        lea eax, [byte esi+04h]
        push eax
        lea eax, [byte esp+054h]
        push eax
        call PrintString
        add esp, byte 0Ch
        mov dword [fontcolor], 0C0h
        push edi
        add esi, byte 3
        push esi
        lea eax, [byte esp+054h]
        jmp near .16
.15:
        push edi
        push esi
        mov eax, dword [dword esp+0ACh]
        shl eax, 2
        add eax, dword [byte esp+0Ch]
        mov ecx, dword [eax]
        push ecx
        call DrawArt
        add esp, byte 0Ch
        xor eax, eax
        mov ebx, dword [dword esp+0A0h]
        mov al, byte [byte ebx+01h]
        push eax
        push str_D8
        lea eax, [byte esp+054h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov dword [fontcolor], 0C0h
        lea eax, [byte edi+01h]
        push eax
        lea eax, [byte esi+04h]
        push eax
        lea eax, [byte esp+054h]
        push eax
        call PrintString
        add esp, byte 0Ch
        mov dword [fontcolor], 0FFh
        push edi
        lea eax, [byte esi+03h]
        push eax
        lea eax, [byte esp+054h]
        push eax
        call PrintString
        add esp, byte 0Ch
        push edi
        push esi
        mov ebx, dword [dword esp+0A4h]
        push ebx
        call DrawArt
        add esp, byte 0Ch
        mov dword [fontcolor], 0FFh
        lea eax, [byte edi+031h]
        push eax
        lea eax, [byte esp+070h]
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        lea ebx, [byte esi+027h]
        sub ebx, eax
        push ebx
        lea eax, [byte esp+074h]
        push eax
        call PrintString
        add esp, byte 0Ch
        mov dword [fontcolor], 0C0h
        add edi, byte 30h
        push edi
        lea eax, [byte esp+070h]
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        add esi, byte 26h
        sub esi, eax
        push esi
        lea eax, [byte esp+074h]
.16:
        push eax
        call PrintString
        add esp, byte 0Ch
        mov eax, ebp
        mov ebx, ebp
        shl ebx, 2
        sub ebx, ebp
        add ebx, ebx
        add ebx, dword [esp]
        xor eax, ebp
        mov al, byte [ebx]
        mov esi, dword [calselmonth]
        cmp eax, esi
        jne short .17
        xor eax, esi
        mov al, byte [byte ebx+01h]
        cmp eax, dword [calselday]
        jne short .17
        mov dword [dword esp+098h], ebp
.17:
        inc ebp
.18:
        cmp ebp, dword [dword esp+0B8h]
        jl near DrawCalendarDay.5
        mov ebx, dword [dword esp+098h]
        test ebx, ebx
        jl near .19
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        add eax, eax
        add eax, dword [esp]
        mov al, byte [byte eax+01h]
        and eax, 0FFh
        xor ebx, ebx
        mov ecx, dword [byte esp+08h]
        mov bl, byte [dword ecx+monthfirstday]
        add eax, ebx
        lea ebx, [byte eax-01h]
        mov ecx, 7
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ecx
        mov esi, edx
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ecx
        mov esi, dword [nosplit esi*4+calcolx]
        mov edi, dword [nosplit eax*4+calrowy]
        lea eax, [byte esi+04Ch]
        mov dword [dword esp+090h], eax
        lea ebp, [byte edi+03Eh]
        push dword 0BBh
        lea eax, [byte edi-01h]
        mov dword [dword esp+080h], eax
        push eax
        mov edx, dword [dword esp+098h]
        push edx
        push eax
        lea eax, [byte esi-01h]
        mov dword [dword esp+090h], eax
        push eax
        call sub_B4FAC
        add esp, byte 14h
        push dword 0BBh
        push edi
        mov eax, dword [dword esp+098h]
        dec eax
        mov dword [dword esp+090h], eax
        push eax
        push edi
        push esi
        call sub_B4FAC
        add esp, byte 14h
        push dword 0BBh
        push ebp
        mov edx, dword [dword esp+088h]
        push edx
        mov ebx, dword [dword esp+088h]
        push ebx
        push edx
        call sub_B4FAC
        add esp, byte 14h
        push dword 0BBh
        lea eax, [byte ebp-01h]
        mov dword [dword esp+090h], eax
        push eax
        push esi
        push edi
        push esi
        call sub_B4FAC
        add esp, byte 14h
        push dword 0BBh
        push ebp
        mov edx, dword [dword esp+098h]
        push edx
        mov ebx, dword [dword esp+088h]
        push ebx
        push edx
        call sub_B4FAC
        add esp, byte 14h
        push dword 0BBh
        mov eax, dword [dword esp+090h]
        push eax
        mov edx, dword [dword esp+090h]
        push edx
        push edi
        push edx
        call sub_B4FAC
        add esp, byte 14h
        push dword 0BBh
        push ebp
        mov ecx, dword [dword esp+098h]
        push ecx
        push ebp
        mov edi, dword [dword esp+090h]
        push edi
        call sub_B4FAC
        add esp, byte 14h
        push dword 0BBh
        mov ebp, dword [dword esp+090h]
        push ebp
        mov eax, dword [dword esp+090h]
        push eax
        push ebp
        push esi
        call sub_B4FAC
        add esp, byte 14h
.19:
        lea eax, [byte esp+0Ch]
        push eax
        call TextRestoreState
        add esp, byte 4
        add esp, 0A8h
        pop ebp
        pop edi
        pop esi
        ret 10h
;-----------------------------------------------------------------------------
; CalNextMonth                                                    34691  95 PC
; Calendar "Next month": calmonth +1 (wraps 11 -> 0, stops at June), disables
; itself at the last month
;-----------------------------------------------------------------------------
; C: src/front/calendar/CalNextMonth.c
%ifdef CBUILD
%include "c/front/calendar/CalNextMonth.inc"
%else
CalNextMonth:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edi
        mov dword [calnextslot], CalNextMonth
        mov dword [calprevslot], CalPrevMonth
        mov ecx, dword [calmonth]
        inc ecx
        mov dword [calmonth], ecx
        cmp ecx, byte 0Ch
        jne short .1
        xor edi, edi
        mov dword [calmonth], edi
.1:
        cmp dword [calmonth], byte 6
        jne short .2
        mov dword [calmonth], 5
.2:
        cmp dword [calmonth], byte 5
        jne short .3
        xor ebx, ebx
        mov dword [calnextslot], ebx
.3:
        mov dword [calsel], 0FFFFFFFFh
        pop edi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CalPrevMonth                                                    346FE  95 PC
; Calendar "Previous month": calmonth -1 (wraps 0 -> 11, stops at October),
; disables itself at the first month
;-----------------------------------------------------------------------------
; C: src/front/calendar/CalPrevMonth.c
%ifdef CBUILD
%include "c/front/calendar/CalPrevMonth.inc"
%else
CalPrevMonth:
        push dword 0Ch
        call __CHK
        push ebx
        push ecx
        mov dword [calnextslot], CalNextMonth
        mov dword [calprevslot], CalPrevMonth
        mov ecx, dword [calmonth]
        dec ecx
        mov dword [calmonth], ecx
        cmp ecx, byte 0FFFFFFFFh
        jne short .1
        mov dword [calmonth], 0Bh
.1:
        cmp dword [calmonth], byte 8
        jne short .2
        mov dword [calmonth], 9
.2:
        cmp dword [calmonth], byte 9
        jne short .3
        xor ebx, ebx
        mov dword [calprevslot], ebx
.3:
        mov dword [calsel], 0FFFFFFFFh
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CalReturn                                                       3476B  95 PC
; Calendar "Return to Sports Central": sets calexit and calsel to -1
;-----------------------------------------------------------------------------
; C: src/front/calendar/CalReturn.c
%ifdef CBUILD
%include "c/front/calendar/CalReturn.inc"
%else
CalReturn:
        push dword 8
        call __CHK
        push edx
        mov edx, 0FFFFFFFFh
        mov dword [calexit], edx
        mov dword [calsel], edx
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; ApplyShapePalette                            34789  95 PC, medium confidence
; Sets the palette from the !pal block of the given shape file
;-----------------------------------------------------------------------------
; C: src/front/calendar/ApplyShapePalette.c
%ifdef CBUILD
%include "c/front/calendar/ApplyShapePalette.inc"
%else
ApplyShapePalette:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push str_Pal17
        push eax
        call FindShape
        add esp, byte 8
        lea edx, [byte eax+010h]
        mov ebx, 10h
        xor eax, eax
        call FadePalStep
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SetGameSides                                 347B7  95 PC, medium confidence
; (team, sched, game): sets the side controls for the two teams of a schedule
; game (the other team -1 unless it is a human team)
;-----------------------------------------------------------------------------
; C: src/front/calendar/SetGameSides.c
%ifdef CBUILD
%include "c/front/calendar/SetGameSides.inc"
%else
SetGameSides:
        push dword 0Ch
        call __CHK
        push ecx
        push esi
        mov esi, eax
        mov ecx, edx
        mov edx, ebx
        shl edx, 2
        sub edx, ebx
        add edx, edx
        add edx, ecx
        xor eax, eax
        mov al, byte [byte edx+02h]
        cmp esi, eax
        jne short .1
        mov dl, byte [byte edx+03h]
        and edx, 0FFh
        jmp short .2
.1:
        movzx esi, byte [byte edx+03h]
        mov edx, eax
.2:
        mov eax, edx
        shl eax, 4
        sub eax, edx
        cmp byte [nosplit eax*2+lgteam_17], 1
        je short .3
        mov edx, 0FFFFFFFFh
.3:
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        add eax, eax
        add eax, ecx
        xor ecx, ecx
        mov cl, byte [byte eax+03h]
        xor ebx, ebx
        mov bl, byte [byte eax+02h]
        mov eax, esi
        call SetCtlTeams
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CalendarScreen                                                  34821  95 PC
; League calendar (calendar / callogo): month grid of the human team's games,
; Play / Game / Statistics menu, picks and plays the next game; called from
; import_export
;-----------------------------------------------------------------------------
CalendarScreen:
        push dword 7F8h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, 7D0h
        push eax
        mov edi, edx
        mov ebp, ebx
        mov dword [dword esp+0780h], 0FFFFFFFFh
        xor ebx, ebx
        mov dword [dword esp+07B0h], ebx
        mov dword [dword esp+079Ch], 0C0h
        mov dword [dword esp+07A4h], 0Ch
        mov dword [dword esp+07A0h], 67h
        call sub_B4BA8
        push byte 0
        call ClearScreen
        add esp, byte 4
        cmp byte [musicon], 0
        je short .1
        cmp dword [songdata], byte 0
        je short .1
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 3
        call sub_8FCDF
.1:
        push savepal
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, savepal
        mov eax, 1
        call FadePalStep
        cmp byte [musicon], 0
        je short .3
        cmp dword [songdata], byte 0
        je short .3
.2:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short CalendarScreen.2
        mov ecx, dword [songdata]
        push ecx
        call sub_8D2F0
        add esp, byte 4
        xor esi, esi
        mov dword [songdata], esi
.3:
        call ShowLoadingScreen
        mov dword [teamstatscb], CalTeamStatsScreen
        mov dword [skaterstatscb], CalSkaterStatsScreen
        mov dword [goaliestatscb], CalGoalieStatsScreen
        mov dword [standingscb], CalStandingsScreen
        mov dword [standingsmenucb], CalStandingsMenu
        push dword 0FFh
        mov ecx, 0C0h
        mov ebx, 67h
        mov edx, ecx
        mov eax, 0Ch
        call SetDialogColors
        xor edx, edx
        mov word [dword esp+07B8h], dx
        mov dword [calsel], 0FFFFFFFFh
        xor edx, edx
        mov dword [calexit], edx
        mov dword [calredraw], edx
        mov eax, dword [mainfont]
        mov dword [dword esp+07ACh], eax
        xor ecx, ecx
        mov ebx, str_Calendar
        cmp byte [fileoncd+01C1h], 1
        jne short .4
        mov edx, dword [cddriveptr]
        jmp short .5
.4:
        xor edx, edx
.5:
        lea eax, [dword esp+06F8h]
        call MakePath
        push byte 20h
        lea eax, [dword esp+06FCh]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [calendarshapes], eax
        xor ecx, ecx
        mov ebx, str_Callogo
        cmp byte [fileoncd+01C2h], 1
        jne short .6
        mov edx, dword [cddriveptr]
        jmp short .7
.6:
        xor edx, edx
.7:
        lea eax, [dword esp+06F8h]
        call MakePath
        push byte 20h
        lea eax, [dword esp+06FCh]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [dword esp+078Ch], eax
        xor ebx, ebx
        mov word [dword esp+07CCh], bx
        jmp short .9
.8:
        mov eax, dword [dword esp+07CAh]
        sar eax, 10h
        mov dl, byte [dword esp+07CCh]
        mov byte [byte esp+eax+04h], dl
        mov eax, ecx
        inc eax
        mov word [dword esp+07CCh], ax
.9:
        mov ecx, dword [dword esp+07CCh]
        cmp cx, 100h
        jl short CalendarScreen.8
        lea eax, [byte esp+04h]
        push eax
        call SetColorRemap
        add esp, byte 4
        xor esi, esi
        mov word [dword esp+07CCh], si
        jmp short .11
.10:
        mov esi, dword [dword esp+07CAh]
        sar esi, 10h
        mov eax, dword [nosplit esi*4+crestnames]
        push eax
        mov edx, dword [dword esp+0790h]
        push edx
        call FindShape
        add esp, byte 8
        mov dword [dword esp+esi*4+0690h], eax
        inc word [dword esp+07CCh]
.11:
        cmp word [dword esp+07CCh], byte 1Ah
        jl short CalendarScreen.10
        mov ebx, dword [leaguedbnames+18h]
        mov ecx, edi
        mov edx, dword [esp]
        lea eax, [dword esp+06F8h]
        call MakePath
        lea edx, [dword esp+0780h]
        lea eax, [dword esp+06F8h]
        call FileOpenRead
        mov esi, eax
        test ax, ax
        jne short .12
        mov ecx, 2
        xor ebx, ebx
        lea edx, [dword esp+07C0h]
        mov eax, dword [dword esp+0780h]
        call FileReadAt
        mov esi, eax
.12:
        test si, si
        jne near .22
        mov dword [calmonth], 0FFFFFFFFh
        mov edi, 5
        mov ebx, 0FFFFFFFFh
        mov dword [dword esp+07BCh], ebx
        mov word [dword esp+07C4h], bx
        mov word [dword esp+07CCh], si
        jmp near .20
.13:
        mov ebx, dword [dword esp+07CAh]
        sar ebx, 10h
        mov eax, dword [dword esp+07B6h]
        sar eax, 10h
        mov ecx, eax
        shl ecx, 2
        sub ecx, eax
        add ecx, ecx
        lea edx, [dword esp+0304h]
        add edx, ecx
        mov eax, dword [dword esp+0780h]
        call ReadSchedGame
        mov esi, eax
        test ax, ax
        jne near .19
        mov eax, dword [dword esp+07CCh]
        cmp ax, word [dword esp+07C0h]
        jne near .16
        cmp byte [dword esp+ecx+0306h], 0FFh
        je short .14
        cmp byte [dword esp+ecx+0307h], 0FFh
        je short .14
        movzx di, byte [dword esp+ecx+0304h]
        dec edi
        xor eax, eax
        mov al, byte [dword esp+ecx+0304h]
        mov dword [calselmonth], eax
        xor eax, eax
        mov al, byte [dword esp+ecx+0305h]
        jmp short .15
.14:
        mov ebx, dword [dword esp+07B6h]
        sar ebx, 10h
        lea edx, [byte ebx-01h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        movzx di, byte [dword esp+eax*2+0304h]
        dec edi
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        xor edx, edx
        mov dl, byte [dword esp+eax*2+0304h]
        mov dword [calselmonth], edx
        mov al, byte [dword esp+eax*2+0305h]
        and eax, 0FFh
.15:
        mov dword [calselday], eax
.16:
        mov edx, dword [dword esp+07B6h]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        xor edx, edx
        mov dl, byte [dword esp+eax+0306h]
        cmp edx, ebp
        je short .17
        mov al, byte [dword esp+eax+0307h]
        and eax, 0FFh
        cmp eax, ebp
        jne near .19
.17:
        mov edx, dword [dword esp+07B6h]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        mov dh, byte [dword esp+eax+0304h]
        cmp dh, 0FFh
        je near .19
        cmp byte [dword esp+eax+0305h], 0FFh
        je short .19
        mov bh, byte [dword esp+eax+0308h]
        cmp bh, 0FFh
        jne short .18
        cmp bh, byte [dword esp+eax+0309h]
        jne short .18
        cmp dword [calmonth], byte 0
        jge short .18
        mov al, dh
        and eax, 0FFh
        dec eax
        mov dword [calmonth], eax
        mov eax, dword [dword esp+07CCh]
        mov dword [dword esp+07BCh], eax
        mov eax, dword [dword esp+07B8h]
        mov word [dword esp+07C4h], ax
.18:
        mov eax, dword [dword esp+07B6h]
        sar eax, 10h
        mov edx, dword [dword esp+07CCh]
        mov word [dword esp+eax*2+05ACh], dx
        inc word [dword esp+07B8h]
.19:
        inc word [dword esp+07CCh]
.20:
        cmp word [dword esp+07CCh], 4ADh
        jge short .21
        test si, si
        je near CalendarScreen.13
.21:
        cmp dword [calmonth], byte 0
        jge short .22
        movsx eax, di
        mov dword [calmonth], eax
.22:
        test si, si
        je short .23
        call FadeOutPalCycle
.23:
        lea eax, [dword esp+0780h]
        call FileClose
        cmp word [dword esp+07BCh], byte 0
        jl short .24
        test si, si
        jne short .24
        mov ecx, dword [dword esp+07C2h]
        sar ecx, 10h
        mov ebx, ecx
        lea edx, [dword esp+0304h]
        mov eax, ebp
        call SetGameSides
        mov edx, ecx
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        xor edx, ecx
        mov dl, byte [dword esp+eax*2+0304h]
        mov dword [calselmonth], edx
        mov al, byte [dword esp+eax*2+0305h]
        and eax, 0FFh
        mov dword [calselday], eax
        mov eax, dword [dword esp+ecx*2+05AAh]
        sar eax, 10h
        mov dword [calsel], eax
.24:
        test si, si
        jne near .83
        cmp dword [calmonth], byte 5
        jne short .25
        xor eax, eax
        mov dword [calnextslot], eax
        jmp short .26
.25:
        mov dword [calnextslot], CalNextMonth
.26:
        cmp dword [calmonth], byte 9
        jne short .27
        xor ecx, ecx
        mov dword [calprevslot], ecx
        jmp short .28
.27:
        mov dword [calprevslot], CalPrevMonth
.28:
        mov ax, word [calmonth]
        mov word [dword esp+07D0h], ax
        call sub_B4BA8
        mov esi, calmenubar
        mov dword [dword esp+0730h], esi
        mov edi, 3
        mov dword [dword esp+0748h], edi
        xor eax, eax
        mov dword [dword esp+0734h], eax
        mov dword [dword esp+073Ch], eax
        mov dword [dword esp+0740h], eax
        mov dword [dword esp+0754h], eax
        mov dword [dword esp+0758h], eax
        mov dword [dword esp+0718h], eax
        mov dword [dword esp+071Ch], eax
        call FadeOutPalCycle
        call sub_B4BA8
        mov edx, dword [dword esp+07A0h]
        push edx
        mov ecx, dword [dword esp+07A8h]
        mov ebx, dword [dword esp+07A0h]
        mov edx, edi
        mov eax, esi
        call DrawMenuBar
        mov ebx, dword [calendarshapes]
        push ebx
        mov ecx, dword [dword esp+07B0h]
        push ecx
        push ebp
        mov eax, dword [dword esp+07C2h]
        sar eax, 10h
        push eax
        mov eax, dword [calmonth]
        lea ecx, [dword esp+0314h]
        mov ebx, dword [dword esp+07B8h]
        lea edx, [dword esp+06A0h]
        call DrawCalendarDay
        cmp byte [musicon], 0
        je short .31
        cmp dword [songdata], byte 0
        jne short .31
        mov ecx, str_Iff9
        mov ebx, str_Calendar
        cmp byte [fileoncd+01E2h], 1
        jne short .29
        mov edx, dword [cddriveptr]
        jmp short .30
.29:
        xor edx, edx
.30:
        lea eax, [dword esp+06F8h]
        call MakePath
        lea eax, [dword esp+06F8h]
        call sub_8F98F
        mov dword [songdata], eax
        test eax, eax
        je short .31
        test byte [gameopts], 40h
        je short .31
        mov edx, dword [musichandle]
        mov ecx, 4Ch
        mov ebx, 3
        call sub_8FB8E
.31:
        mov eax, dword [calendarshapes]
        call ApplyShapePalette
        mov eax, dword [pointerspr]
        mov edx, dword [byte eax+02h]
        sar edx, 10h
        shl edx, 2
        mov eax, dword [byte eax+04h]
        sar eax, 10h
        inc eax
        add edx, byte 4
        imul eax, edx
        add eax, byte 11h
        push byte 20h
        push eax
        push str_Pointer8
        call AllocMemBlock
        mov dword [dword esp+0794h], eax
        add esp, byte 0Ch
        mov dword [dword esp+0794h], eax
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov eax, dword [pointerspr]
        mov ax, word [byte eax+04h]
        inc eax
        mov edx, dword [dword esp+0788h]
        mov word [byte edx+04h], ax
        mov eax, dword [pointerspr]
        mov ax, word [byte eax+06h]
        inc eax
        mov word [byte edx+06h], ax
        lea eax, [dword esp+0774h]
        push eax
        lea eax, [dword esp+077Ch]
        push eax
        lea eax, [dword esp+0784h]
        push eax
        call MouseRead
        add esp, byte 0Ch
        mov eax, dword [dword esp+0778h]
        mov dword [dword esp+0770h], eax
        mov eax, dword [dword esp+0774h]
        mov dword [dword esp+076Ch], eax
        push eax
        mov eax, dword [dword esp+077Ch]
        push eax
        mov edx, dword [dword esp+0790h]
        push edx
        call GrabBlock
        add esp, byte 0Ch
        mov ebx, dword [dword esp+0774h]
        push ebx
        mov ecx, dword [dword esp+077Ch]
        push ecx
        mov esi, dword [pointerspr]
        push esi
        call DrawArt
        add esp, byte 0Ch
        call ClearInputQueue
.32:
        xor ecx, ecx
.33:
        call GetInputEvent
        mov esi, eax
        test eax, eax
        je short .34
        lea ebx, [dword esp+076Ch]
        lea edx, [dword esp+0770h]
        call dword [ptrupdatefn]
        mov ecx, eax
.34:
        test esi, esi
        je short .35
        test cl, 2
        je short CalendarScreen.33
.35:
        test cl, 2
        jne short .37
        mov eax, dword [dword esp+0770h]
        cmp eax, dword [dword esp+0778h]
        jne short .36
        mov eax, dword [dword esp+076Ch]
        cmp eax, dword [dword esp+0774h]
        je near .82
.36:
        mov ebx, dword [dword esp+0774h]
        push ebx
        mov ecx, dword [dword esp+077Ch]
        push ecx
        mov esi, dword [dword esp+079Ch]
        push esi
        call PutBlock
        add esp, byte 0Ch
        mov edi, dword [dword esp+076Ch]
        push edi
        mov eax, dword [dword esp+0774h]
        push eax
        push esi
        call GrabBlock
        add esp, byte 0Ch
        mov ebx, dword [dword esp+076Ch]
        push ebx
        mov ecx, dword [dword esp+0774h]
        push ecx
        mov esi, dword [pointerspr]
        push esi
        jmp near .80
.37:
        lea eax, [dword esp+0764h]
        push eax
        lea eax, [dword esp+076Ch]
        push eax
        lea eax, [dword esp+0720h]
        push eax
        lea eax, [dword esp+0754h]
        push eax
        mov ecx, dword [dword esp+07C0h]
        lea ebx, [dword esp+0740h]
        mov edx, dword [dword esp+077Ch]
        mov eax, dword [dword esp+0780h]
        call MenuHitTest
        test eax, eax
        je near .65
        mov edx, dword [dword esp+0768h]
        shl edx, 2
        mov eax, dword [dword esp+0764h]
        shl eax, 5
        mov ebx, dword [dword esp+edx+0730h]
        add eax, ebx
        cmp dword [byte eax+014h], byte 0
        je near .50
        mov eax, dword [dword esp+0764h]
        cmp eax, dword [dword esp+edx+0754h]
        jne near .45
        mov ebx, dword [dword esp+0774h]
        push ebx
        mov ecx, dword [dword esp+077Ch]
        push ecx
        mov esi, dword [dword esp+079Ch]
        push esi
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [dword esp+07B0h]
        mov word [dword esp+07CCh], ax
        jmp short .40
.38:
        mov esi, dword [dword esp+07CAh]
        sar esi, 10h
        mov edi, esi
        shl edi, 2
        mov eax, dword [dword esp+edi+073Ch]
        test eax, eax
        je short .39
        mov edx, dword [dword esp+esi*8+071Ch]
        push edx
        mov ebx, dword [dword esp+esi*8+071Ch]
        push ebx
        push eax
        call PutBlock
        add esp, byte 0Ch
        xor eax, eax
        mov dword [dword esp+esi*8+0718h], eax
        mov dword [dword esp+esi*8+071Ch], eax
        mov ebx, dword [dword esp+edi+073Ch]
        push ebx
        call FreeMemBlock
        add esp, byte 4
.39:
        dec word [dword esp+07CCh]
.40:
        cmp word [dword esp+07CCh], byte 0
        jge short CalendarScreen.38
        xor esi, esi
        mov dword [dword esp+07B0h], esi
        mov eax, dword [dword esp+0768h]
        mov edx, dword [dword esp+0764h]
        shl edx, 5
        mov eax, dword [dword esp+eax*4+0730h]
        call dword [byte edx+eax+014h]
        mov esi, eax
        lea eax, [byte esp+04h]
        push eax
        call SetColorRemap
        add esp, byte 4
        xor edi, edi
        mov dword [dword esp+0734h], edi
        mov dword [dword esp+073Ch], edi
        mov dword [dword esp+0740h], edi
        mov dword [dword esp+0758h], edi
        mov dword [dword esp+074Ch], edi
        cmp esi, byte 1
        jne short .42
        mov esi, dword [dword esp+0794h]
        push esi
        call FreeMemBlock
        add esp, byte 4
        cmp byte [musicon], 0
        je short .41
        cmp dword [songdata], byte 0
        je short .41
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 3
        call sub_8FCDF
.41:
        xor eax, eax
        jmp near .x
.42:
        mov esi, dword [dword esp+0774h]
        push esi
        mov edi, dword [dword esp+077Ch]
        push edi
        call MouseSetPos
        add esp, byte 8
        mov eax, dword [dword esp+0778h]
        mov dword [dword esp+0770h], eax
        mov eax, dword [dword esp+0774h]
        mov dword [dword esp+076Ch], eax
        call ClearInputQueue
        mov eax, dword [dword esp+07CEh]
        sar eax, 10h
        cmp eax, dword [calmonth]
        je short .43
        call sub_B4BA8
        mov ebx, dword [dword esp+07A0h]
        push ebx
        mov ecx, dword [dword esp+07A8h]
        mov ebx, dword [dword esp+07A0h]
        mov edx, 3
        mov eax, calmenubar
        call DrawMenuBar
        mov ecx, dword [calendarshapes]
        push ecx
        mov esi, dword [dword esp+07B0h]
        push esi
        push ebp
        mov eax, dword [dword esp+07C2h]
        sar eax, 10h
        push eax
        mov eax, dword [calmonth]
        lea ecx, [dword esp+0314h]
        mov ebx, dword [dword esp+07B8h]
        lea edx, [dword esp+06A0h]
        call DrawCalendarDay
.43:
        cmp dword [calredraw], byte 0
        je short .44
        call sub_B4BA8
        mov eax, dword [dword esp+07A0h]
        push eax
        mov ecx, dword [dword esp+07A8h]
        mov ebx, dword [dword esp+07A0h]
        mov edx, 3
        mov eax, calmenubar
        call DrawMenuBar
        mov edx, dword [calendarshapes]
        push edx
        mov ebx, dword [dword esp+07B0h]
        push ebx
        push ebp
        mov eax, dword [dword esp+07C2h]
        sar eax, 10h
        push eax
        mov eax, dword [calmonth]
        lea ecx, [dword esp+0314h]
        mov ebx, dword [dword esp+07B8h]
        lea edx, [dword esp+06A0h]
        call DrawCalendarDay
        mov eax, dword [calendarshapes]
        call ApplyShapePalette
        xor ecx, ecx
        mov dword [calredraw], ecx
.44:
        mov ax, word [calmonth]
        mov word [dword esp+07D0h], ax
        jmp near .79
.45:
        mov ecx, dword [dword esp+0774h]
        push ecx
        mov esi, dword [dword esp+077Ch]
        push esi
        mov edi, dword [dword esp+079Ch]
        push edi
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [dword esp+07B0h]
        cmp eax, dword [dword esp+0768h]
        je near .49
        mov eax, dword [dword esp+07B0h]
        mov word [dword esp+07CCh], ax
        jmp short .48
.46:
        mov esi, edi
        shl esi, 2
        xor ecx, ecx
        mov dword [dword esp+esi+0754h], ecx
        mov eax, dword [dword esp+esi+073Ch]
        test eax, eax
        je short .47
        mov edx, dword [dword esp+edi*8+071Ch]
        push edx
        mov ebx, dword [dword esp+edi*8+071Ch]
        push ebx
        push eax
        call PutBlock
        add esp, byte 0Ch
        xor eax, eax
        mov dword [dword esp+edi*8+071Ch], eax
        mov dword [dword esp+edi*8+0718h], eax
        mov edx, dword [dword esp+esi+073Ch]
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor ebx, ebx
        mov dword [dword esp+esi+073Ch], ebx
        mov dword [dword esp+esi+0730h], ebx
        mov dword [dword esp+esi+0748h], ebx
.47:
        dec word [dword esp+07CCh]
.48:
        mov edi, dword [dword esp+07CAh]
        sar edi, 10h
        mov ebx, dword [dword esp+0768h]
        cmp edi, ebx
        jg near CalendarScreen.46
        mov dword [dword esp+07B0h], ebx
.49:
        mov eax, dword [dword esp+07A0h]
        push eax
        mov edx, dword [dword esp+07A8h]
        push edx
        mov eax, dword [dword esp+0770h]
        mov ebx, dword [dword esp+eax*8+0724h]
        mov edx, dword [dword esp+eax*8+0720h]
        mov ecx, dword [dword esp+eax*4+075Ch]
        shl ecx, 5
        mov eax, dword [dword esp+eax*4+0738h]
        add eax, ecx
        mov ecx, dword [dword esp+07A4h]
        call DrawMenuItemSel
        mov edx, dword [dword esp+0768h]
        mov eax, dword [dword esp+0764h]
        mov dword [dword esp+edx*4+0754h], eax
        mov ebx, dword [dword esp+07A0h]
        push ebx
        mov ecx, dword [dword esp+07A8h]
        push ecx
        mov ebx, dword [dword esp+edx*8+0724h]
        mov eax, dword [dword esp+edx*8+0720h]
        mov esi, dword [dword esp+edx*4+075Ch]
        shl esi, 5
        mov edx, dword [dword esp+edx*4+0738h]
        add esi, edx
        mov ecx, dword [dword esp+07A4h]
        mov edx, eax
        mov eax, esi
        jmp near .64
.50:
        cmp dword [byte eax+018h], byte 0
        je near .59
        mov ebx, dword [dword esp+0774h]
        push ebx
        mov ecx, dword [dword esp+077Ch]
        push ecx
        mov esi, dword [dword esp+079Ch]
        push esi
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [dword esp+07B0h]
        cmp eax, dword [dword esp+0768h]
        je near .54
        mov eax, dword [dword esp+07B0h]
        mov word [dword esp+07CCh], ax
        jmp short .53
.51:
        mov esi, edi
        shl esi, 2
        xor ebx, ebx
        mov dword [dword esp+esi+0754h], ebx
        mov ecx, dword [dword esp+esi+073Ch]
        test ecx, ecx
        je short .52
        mov eax, dword [dword esp+edi*8+071Ch]
        push eax
        mov edx, dword [dword esp+edi*8+071Ch]
        push edx
        push ecx
        call PutBlock
        add esp, byte 0Ch
        xor ecx, ecx
        mov dword [dword esp+edi*8+0718h], ecx
        mov dword [dword esp+edi*8+071Ch], ecx
        mov edx, dword [dword esp+esi+073Ch]
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor ebx, ebx
        mov dword [dword esp+esi+073Ch], ebx
        mov dword [dword esp+esi+0730h], ebx
        mov dword [dword esp+esi+0748h], ebx
.52:
        dec word [dword esp+07CCh]
.53:
        mov edi, dword [dword esp+07CAh]
        sar edi, 10h
        mov edx, dword [dword esp+0768h]
        cmp edi, edx
        jg near CalendarScreen.51
        mov dword [dword esp+07B0h], edx
.54:
        mov eax, dword [dword esp+07A0h]
        push eax
        mov edx, dword [dword esp+07A8h]
        push edx
        mov edi, dword [dword esp+07B8h]
        mov ebx, dword [dword esp+edi*8+0724h]
        mov edx, dword [dword esp+edi*8+0720h]
        mov eax, dword [dword esp+edi*4+075Ch]
        shl eax, 5
        mov ecx, dword [dword esp+edi*4+0738h]
        add eax, ecx
        mov ecx, dword [dword esp+07A4h]
        call DrawMenuItemSel
        mov eax, dword [dword esp+0764h]
        mov dword [dword esp+edi*4+0754h], eax
        mov eax, dword [dword esp+07A0h]
        push eax
        mov edx, dword [dword esp+07A8h]
        push edx
        mov ebx, dword [dword esp+edi*8+0724h]
        mov edx, dword [dword esp+edi*8+0720h]
        mov eax, dword [dword esp+076Ch]
        shl eax, 5
        mov ecx, dword [dword esp+edi*4+0738h]
        add eax, ecx
        mov ecx, dword [dword esp+07A4h]
        call DrawMenuItemNorm
        mov eax, dword [dword esp+0768h]
        mov ecx, dword [dword esp+0764h]
        shl ecx, 5
        mov ebx, dword [dword esp+eax*4+0730h]
        lea esi, [byte edi+01h]
        mov dword [dword esp+07B0h], esi
        mov ebx, dword [byte ecx+ebx+018h]
        mov dword [dword esp+esi*4+0730h], ebx
        mov eax, dword [dword esp+eax*4+0730h]
        add eax, ecx
        mov ebx, dword [byte eax+01Ch]
        mov dword [dword esp+esi*4+0748h], ebx
        cmp esi, byte 1
        je short .55
        mov edx, dword [byte eax+08h]
        jmp short .56
.55:
        mov edx, dword [eax]
.56:
        mov eax, dword [dword esp+07B0h]
        mov ebx, dword [dword esp+eax*8+0710h]
        add edx, ebx
        mov dword [dword esp+eax*8+0718h], edx
        mov edx, dword [dword esp+0764h]
        shl edx, 5
        mov eax, dword [dword esp+0768h]
        shl eax, 2
        cmp dword [dword esp+07B0h], byte 1
        je short .57
        mov eax, dword [dword esp+eax+0730h]
        mov eax, dword [byte edx+eax+04h]
        jmp short .58
.57:
        mov eax, dword [dword esp+eax+0730h]
        mov eax, dword [byte edx+eax+0Ch]
.58:
        mov edx, dword [dword esp+07B0h]
        shl edx, 3
        mov dword [dword esp+0790h], edx
        mov esi, dword [dword esp+edx+0714h]
        add eax, esi
        mov dword [dword esp+edx+071Ch], eax
        mov eax, dword [dword esp+07B0h]
        shl eax, 2
        mov dword [dword esp+0798h], eax
        mov edx, dword [dword esp+eax+0748h]
        shl edx, 5
        mov eax, dword [dword esp+eax+0730h]
        mov ebx, dword [byte edx+eax-018h]
        sub ebx, dword [eax]
        inc ebx
        mov dword [dword esp+0760h], ebx
        mov edx, dword [byte edx+eax-014h]
        sub edx, dword [byte eax+04h]
        inc edx
        mov dword [dword esp+0784h], edx
        push byte 20h
        mov eax, dword [dword esp+0764h]
        shl eax, 2
        imul eax, edx
        add eax, byte 11h
        push eax
        push str_Menubuff5
        call AllocMemBlock
        add esp, byte 0Ch
        mov edx, dword [dword esp+0798h]
        mov dword [dword esp+edx+073Ch], eax
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov eax, dword [dword esp+edx+073Ch]
        mov edx, dword [dword esp+0760h]
        mov word [byte eax+04h], dx
        mov eax, dword [dword esp+0798h]
        mov eax, dword [dword esp+eax+073Ch]
        mov edx, dword [dword esp+0784h]
        mov word [byte eax+06h], dx
        mov eax, dword [dword esp+0790h]
        mov esi, dword [dword esp+eax+071Ch]
        push esi
        mov edi, dword [dword esp+eax+071Ch]
        push edi
        mov eax, dword [dword esp+07A0h]
        mov edx, dword [dword esp+eax+0744h]
        push edx
        call GrabBlock
        add esp, byte 0Ch
        mov ebx, dword [dword esp+07A0h]
        push ebx
        mov ecx, dword [dword esp+07A8h]
        push ecx
        mov esi, dword [dword esp+07A4h]
        push esi
        mov ecx, dword [dword esp+079Ch]
        mov ecx, dword [dword esp+ecx+0728h]
        mov ebx, dword [dword esp+079Ch]
        mov ebx, dword [dword esp+ebx+0724h]
        mov edx, dword [dword esp+07A4h]
        mov edx, dword [dword esp+edx+0754h]
        mov eax, dword [dword esp+07A4h]
        mov eax, dword [dword esp+eax+073Ch]
        call DrawMenuDropdown
        mov eax, dword [dword esp+0798h]
        xor edi, edi
        mov dword [dword esp+eax+0754h], edi
        mov eax, dword [dword esp+07A0h]
        push eax
        mov edx, dword [dword esp+07A8h]
        push edx
        mov ebx, dword [dword esp+0798h]
        mov ebx, dword [dword esp+ebx+0724h]
        mov edx, dword [dword esp+0798h]
        mov edx, dword [dword esp+edx+0720h]
        mov eax, dword [dword esp+07A0h]
        mov eax, dword [dword esp+eax+0738h]
        mov ecx, esi
        jmp near .64
.59:
        mov esi, dword [dword esp+0774h]
        push esi
        mov edi, dword [dword esp+077Ch]
        push edi
        mov eax, dword [dword esp+079Ch]
        push eax
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [dword esp+07B0h]
        cmp eax, dword [dword esp+0768h]
        je near .63
        mov eax, dword [dword esp+07B0h]
        mov word [dword esp+07CCh], ax
        jmp short .62
.60:
        mov esi, edi
        shl esi, 2
        xor edx, edx
        mov dword [dword esp+esi+0754h], edx
        mov ebx, dword [dword esp+esi+073Ch]
        test ebx, ebx
        je short .61
        mov ecx, dword [dword esp+edi*8+071Ch]
        push ecx
        mov eax, dword [dword esp+edi*8+071Ch]
        push eax
        push ebx
        call PutBlock
        add esp, byte 0Ch
        xor ebx, ebx
        mov dword [dword esp+edi*8+0718h], ebx
        mov dword [dword esp+edi*8+071Ch], ebx
        mov edi, dword [dword esp+esi+073Ch]
        push edi
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        mov dword [dword esp+esi+073Ch], eax
        mov dword [dword esp+esi+0730h], eax
        mov dword [dword esp+esi+0748h], eax
.61:
        dec word [dword esp+07CCh]
.62:
        mov edi, dword [dword esp+07CAh]
        sar edi, 10h
        mov eax, dword [dword esp+0768h]
        cmp edi, eax
        jg near CalendarScreen.60
        mov dword [dword esp+07B0h], eax
.63:
        mov ecx, dword [dword esp+07A0h]
        push ecx
        mov esi, dword [dword esp+07A8h]
        push esi
        mov eax, dword [dword esp+0770h]
        mov ebx, dword [dword esp+eax*8+0724h]
        mov edx, dword [dword esp+eax*8+0720h]
        mov ecx, dword [dword esp+eax*4+075Ch]
        shl ecx, 5
        mov eax, dword [dword esp+eax*4+0738h]
        add eax, ecx
        mov ecx, dword [dword esp+07A4h]
        call DrawMenuItemSel
        mov edx, dword [dword esp+0768h]
        mov eax, dword [dword esp+0764h]
        mov dword [dword esp+edx*4+0754h], eax
        mov edi, dword [dword esp+07A0h]
        push edi
        push esi
        mov ebx, dword [dword esp+edx*8+0724h]
        mov eax, dword [dword esp+edx*8+0720h]
        mov esi, dword [dword esp+edx*4+075Ch]
        shl esi, 5
        mov edx, dword [dword esp+edx*4+0738h]
        add esi, edx
        mov ecx, dword [dword esp+07A4h]
        mov edx, eax
        mov eax, esi
.64:
        call DrawMenuItemNorm
        jmp near .79
.65:
        mov edi, dword [dword esp+0774h]
        push edi
        mov eax, dword [dword esp+077Ch]
        push eax
        mov edx, dword [dword esp+079Ch]
        push edx
        call PutBlock
        add esp, byte 0Ch
        cmp dword [dword esp+07B0h], byte 0
        je near .69
        mov eax, dword [dword esp+07B0h]
        mov word [dword esp+07CCh], ax
        jmp short .68
.66:
        mov esi, dword [dword esp+07CAh]
        sar esi, 10h
        mov edi, esi
        shl edi, 2
        mov eax, dword [dword esp+edi+073Ch]
        test eax, eax
        je short .67
        mov edx, dword [dword esp+esi*8+071Ch]
        push edx
        mov ebx, dword [dword esp+esi*8+071Ch]
        push ebx
        push eax
        call PutBlock
        add esp, byte 0Ch
        xor eax, eax
        mov dword [dword esp+esi*8+0718h], eax
        mov dword [dword esp+esi*8+071Ch], eax
        mov ebx, dword [dword esp+edi+073Ch]
        push ebx
        call FreeMemBlock
        add esp, byte 4
.67:
        dec word [dword esp+07CCh]
.68:
        cmp word [dword esp+07CCh], byte 0
        jge short CalendarScreen.66
        xor eax, eax
        mov dword [dword esp+07B0h], eax
        mov dword [dword esp+0734h], eax
        mov dword [dword esp+073Ch], eax
        mov dword [dword esp+0740h], eax
        mov dword [dword esp+0758h], eax
        mov dword [dword esp+074Ch], eax
        jmp near .79
.69:
        mov word [dword esp+07B4h], 0FFFFh
        mov ecx, dword [dword esp+0770h]
        cmp ecx, byte 52h
        jl near .78
        cmp ecx, 25Fh
        jge near .78
        mov edi, dword [dword esp+076Ch]
        cmp edi, byte 44h
        jl near .78
        cmp edi, 1B2h
        jge near .78
        lea edx, [byte edi-044h]
        mov ebx, 3Dh
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov esi, eax
        shl esi, 3
        sub esi, eax
        lea edx, [byte ecx-052h]
        mov ebx, 4Bh
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        add esi, eax
        mov ebx, dword [calmonth]
        xor edx, edx
        mov dl, byte [dword ebx+monthfirstday]
        mov ecx, 7
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov eax, esi
        sub eax, edx
        mov word [dword esp+07C8h], ax
        test ax, ax
        jl near .78
        xor eax, eax
        mov al, byte [dword ebx+monthdays]
        mov edx, dword [dword esp+07C6h]
        sar edx, 10h
        cmp edx, eax
        jge near .78
        xor ebx, ebx
        mov word [dword esp+07CCh], bx
        jmp near .77
.70:
        mov edx, dword [dword esp+07CAh]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        xor ecx, ecx
        mov cl, byte [dword esp+eax+0304h]
        mov ebx, dword [calmonth]
        inc ebx
        cmp ecx, ebx
        jne near .76
        xor ecx, ebx
        mov cl, byte [dword esp+eax+0305h]
        mov ebx, dword [dword esp+07C6h]
        sar ebx, 10h
        inc ebx
        cmp ecx, ebx
        jne near .76
        mov bl, byte [dword esp+eax+0308h]
        cmp bl, 0FFh
        jne near .76
        cmp bl, byte [dword esp+eax+0309h]
        jne near .76
        mov eax, dword [dword esp+edx*2+05AAh]
        sar eax, 10h
        cmp eax, dword [calsel]
        jne short .71
        mov dword [calexit], 0FFFFFFFFh
.71:
        cmp word [dword esp+07C0h], 444h
        jl short .72
        mov eax, dword [dword esp+07CAh]
        sar eax, 10h
        mov ax, word [dword esp+eax*2+05ACh]
        cmp ax, word [dword esp+07BCh]
        jne short .73
.72:
        mov eax, dword [dword esp+07CAh]
        sar eax, 10h
        mov ax, word [dword esp+eax*2+05ACh]
        mov word [dword esp+07B4h], ax
        mov eax, dword [dword esp+07CCh]
        mov word [dword esp+07C4h], ax
        mov eax, dword [dword esp+07B8h]
        mov word [dword esp+07CCh], ax
.73:
        mov esi, dword [calselmonth]
        mov edi, dword [calselday]
        mov ebx, dword [dword esp+07C2h]
        sar ebx, 10h
        mov edx, ebx
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        xor edx, ebx
        mov dl, byte [dword esp+eax*2+0304h]
        mov dword [calselmonth], edx
        mov al, byte [dword esp+eax*2+0305h]
        and eax, 0FFh
        mov dword [calselday], eax
        cmp dword [calexit], byte 0
        jne short .74
        lea edx, [dword esp+0304h]
        mov eax, ebp
        call SetGameSides
.74:
        call sub_B4BA8
        mov ebx, dword [dword esp+07A0h]
        push ebx
        mov ecx, dword [dword esp+07A8h]
        mov ebx, dword [dword esp+07A0h]
        mov edx, 3
        mov eax, calmenubar
        call DrawMenuBar
        mov ecx, dword [calselmonth]
        cmp esi, ecx
        jne near .75
        cmp edi, dword [calselday]
        je near .75
        movzx esi, byte [dword ecx+monthfirstday_m1]
        add esi, edi
        dec esi
        mov ebx, 7
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ebx
        mov ebx, edx
        mov ecx, 7
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ecx
        mov esi, ebx
        shl esi, 2
        mov ecx, dword [dword esi+calcolx]
        sub ecx, byte 2
        mov ebx, dword [nosplit eax*4+calrowy]
        sub ebx, byte 2
        mov edx, dword [dword esi+calcolx]
        add edx, byte 4Dh
        mov eax, dword [nosplit eax*4+calrowy]
        add eax, byte 3Fh
        push eax
        push ebx
        push edx
        push ecx
        call SetClipWindow
        add esp, byte 10h
        mov edx, dword [calendarshapes]
        push edx
        mov ebx, dword [dword esp+07B0h]
        push ebx
        push ebp
        mov eax, dword [dword esp+07C2h]
        sar eax, 10h
        push eax
        mov eax, dword [calmonth]
        lea ecx, [dword esp+0314h]
        mov ebx, dword [dword esp+07B8h]
        lea edx, [dword esp+06A0h]
        call DrawCalendarDay
.75:
        mov eax, dword [calselmonth]
        movzx esi, byte [dword eax+monthfirstday_m1]
        add esi, dword [calselday]
        dec esi
        mov ebx, 7
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ebx
        mov ebx, edx
        mov ecx, 7
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ecx
        mov esi, eax
        mov eax, ebx
        mov ebx, dword [nosplit eax*4+calcolx]
        sub ebx, byte 2
        mov edx, dword [nosplit esi*4+calrowy]
        sub edx, byte 2
        mov eax, dword [nosplit eax*4+calcolx]
        add eax, byte 4Dh
        mov ecx, dword [nosplit esi*4+calrowy]
        add ecx, byte 3Fh
        push ecx
        push edx
        push eax
        push ebx
        call SetClipWindow
        add esp, byte 10h
        mov esi, dword [calendarshapes]
        push esi
        mov edi, dword [dword esp+07B0h]
        push edi
        push ebp
        mov eax, dword [dword esp+07C2h]
        sar eax, 10h
        push eax
        mov eax, dword [calmonth]
        lea ecx, [dword esp+0314h]
        mov ebx, dword [dword esp+07B8h]
        lea edx, [dword esp+06A0h]
        call DrawCalendarDay
        push dword 1E0h
        push byte 0
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
.76:
        inc word [dword esp+07CCh]
.77:
        mov eax, dword [dword esp+07CCh]
        cmp ax, word [dword esp+07B8h]
        jl near CalendarScreen.70
.78:
        mov eax, dword [dword esp+07B2h]
        sar eax, 10h
        mov dword [calsel], eax
.79:
        mov ecx, dword [dword esp+0774h]
        push ecx
        mov esi, dword [dword esp+077Ch]
        push esi
        mov edi, dword [dword esp+079Ch]
        push edi
        call GrabBlock
        add esp, byte 0Ch
        mov eax, dword [dword esp+0774h]
        push eax
        mov edx, dword [dword esp+077Ch]
        push edx
        mov ebx, dword [dword esp+079Ch]
        push ebx
        call PutBlock
        add esp, byte 0Ch
        mov ecx, dword [dword esp+076Ch]
        push ecx
        mov esi, dword [dword esp+0774h]
        push esi
        mov edi, dword [dword esp+079Ch]
        push edi
        call GrabBlock
        add esp, byte 0Ch
        cmp dword [calexit], byte 0
        jne short .81
        mov edx, dword [dword esp+076Ch]
        push edx
        mov ebx, dword [dword esp+0774h]
        push ebx
        mov ecx, dword [pointerspr]
        push ecx
.80:
        call DrawArt
        add esp, byte 0Ch
.81:
        mov eax, dword [dword esp+0770h]
        mov dword [dword esp+0778h], eax
        mov eax, dword [dword esp+076Ch]
        mov dword [dword esp+0774h], eax
.82:
        cmp dword [calexit], byte 0
        je near CalendarScreen.32
.83:
        mov edi, dword [dword esp+0794h]
        push edi
        call FreeMemBlock
        add esp, byte 4
        mov ebp, dword [dword esp+078Ch]
        push ebp
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [calendarshapes]
        push eax
        call FreeMemBlock
        add esp, byte 4
        xor edx, edx
        mov dword [calendarshapes], edx
        mov dword [teamstatscb], GameTeamStatsScreen
        mov dword [skaterstatscb], GameSkaterStatsScreen
        mov dword [goaliestatscb], GameGoalieStatsScreen
        mov dword [standingscb], GameStandingsScreen
        mov dword [standingsmenucb], GameStandingsMenu
        cmp byte [musicon], 0
        je short .84
        cmp dword [songdata], byte 0
        je short .84
        mov eax, dword [musichandle]
        mov ebx, 64h
        mov edx, 3
        call sub_8FCDF
.84:
        mov eax, dword [calsel]
.x:
        add esp, 7D4h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
;-----------------------------------------------------------------------------
; CheckLeagueDiskSync                          35FB9  95 PC, medium confidence
; Compares the league id in the floppy PINFO.DB with the local league; on a
; mismatch shows "The league <name> must be imported from / exported to the
; disk for ... before a game can be played!"
;-----------------------------------------------------------------------------
; C: src/front/calendar/CheckLeagueDiskSync.c
%ifdef CBUILD
%include "c/front/calendar/CheckLeagueDiskSync.inc"
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
; C: src/front/calendar/MakeTeamDbFmt.c
%ifdef CBUILD
%include "c/front/calendar/MakeTeamDbFmt.inc"
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
        call sub_8FCDF
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
        call sub_8D2F0
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
        mov edx, word_DDD48
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
        mov dword [dword_DDD34], eax
        mov dword [dword_DDD3C], 0FFFFFFFFh
        mov edx, dword [dword_DDD34]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        cmp byte [nosplit eax*2+lgteam_17], 0
        jne short .30
        xor ecx, ecx
        mov dword [dword_DDD3C], ecx
.30:
        lea eax, [byte esp+06Ch]
        call FileClose
        cmp dword [dword_DDD3C], byte 0
        je near .36
        test esi, esi
        jne near .33
        push esi
        mov ebx, dword [dword_DDD34]
        mov ecx, 0FFFFFFFFh
        mov edx, leagueteams
        mov eax, curleague
        call CheckLeagueDiskSync
        mov esi, eax
        test eax, eax
        jne short .33
        mov edx, dword [dword_DDD34]
        push edx
        push str_02d
        lea eax, [byte esp+068h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea edx, [byte esp+060h]
        mov eax, str_Xx
        call strcpy_
        mov edx, dword [dword_DDD34]
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
        mov edx, word_DDD4A
        mov eax, dword [byte esp+05Ch]
        call FileReadAt
        mov esi, eax
.35:
        lea eax, [byte esp+05Ch]
        call FileClose
        test esi, esi
        jne short .36
        mov esi, dword [dword_DDD34]
        push esi
        push str_02d
        lea eax, [byte esp+068h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea edx, [byte esp+060h]
        mov eax, str_Xx
        call strcpy_
        mov eax, dword [dword_DDD34]
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
        call sub_8FCDF
.38:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short PlayLeagueGame.38
        mov ecx, dword [songdata]
        push ecx
        call sub_8D2F0
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
        mov byte [byte_DC268], al
        mov al, byte [lgschedrec_b1]
        mov byte [byte_DC267], al
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
        mov dl, byte [byte_DC267]
        mov al, byte [byte_DC268]
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
        cmp dword [dword_DDD3C], byte 0
        je near .56
        push byte 0FFFFFFFFh
        mov ebx, dword [dword_DDD34]
        mov ecx, 0FFFFFFFFh
        mov edx, leagueteams
        mov eax, curleague
        call CheckLeagueDiskSync
        mov esi, eax
        test eax, eax
        jne short .56
        mov eax, dword [dword_DDD34]
        push eax
        push str_02d
        lea eax, [byte esp+068h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea edx, [byte esp+060h]
        mov eax, str_Xx
        call strcpy_
        mov edx, dword [dword_DDD34]
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
        cmp dword [dword_DDD3C], byte 0
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
        cmp dword [dword_DDD3C], byte 0
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
        cmp dword [dword_DDD3C], byte 0
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
        cmp dword [dword_DDD3C], byte 0
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
        cmp dx, word [word_DDD48]
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
        cmp dword [dword_DDD3C], byte 0
        je short .72
        mov ax, word [lggameidx]
        cmp ax, word [word_DDD4A]
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
        cmp dword [dword_DDD3C], byte 0
        je short .74
        push byte 2
        mov ecx, dword [dword_DDD34]
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
        mov ebx, dword [dword_DDD34]
        mov ecx, ebp
        mov edx, str_Xx
        mov eax, savleague2
        jmp short .75
.74:
        push savleague1
        mov ebx, dword [dword esp+080h]
        push ebx
        mov ebx, dword [dword_DDD34]
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
        cmp dword [dword_DDD3C], byte 0
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
        call sub_8FCDF
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
        call sub_8D2F0
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
;-----------------------------------------------------------------------------
; TeamGridHitTest                                                 37B92  95 PC
; (mx, my, grid): team in the 4 x 7 division grid cell under the mouse, -1
; for none / empty (63h)
;-----------------------------------------------------------------------------
; C: src/front/calendar/TeamGridHitTest.c
%ifdef CBUILD
%include "c/front/calendar/TeamGridHitTest.inc"
%else
TeamGridHitTest:
        push dword 24h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        mov ebp, eax
        mov edi, edx
        mov dword [esp], ebx
        mov dword [byte esp+04h], 0FFFFFFFFh
        xor ecx, ecx
.1:
        xor edx, edx
.2:
        mov eax, ecx
        shl eax, 3
        sub eax, ecx
        add eax, dword [esp]
        mov al, byte [edx+eax]
        and eax, 0FFh
        mov dword [byte esp+08h], eax
        mov eax, edx
        shl eax, 2
        add eax, edx
        mov ebx, eax
        shl eax, 4
        add eax, ebx
        cmp ecx, byte 2
        jge short .3
        lea ebx, [byte eax+040h]
        jmp short .4
.3:
        lea ebx, [byte eax+016h]
.4:
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 3
        sub eax, ecx
        shl eax, 2
        lea esi, [byte eax+058h]
        mov dword [byte esp+0Ch], esi
        lea esi, [byte ebx+046h]
        add eax, 91h
        cmp ebp, ebx
        jl short .5
        cmp ebp, esi
        jg short .5
        cmp edi, dword [byte esp+0Ch]
        jl short .5
        cmp edi, eax
        jg short .5
        mov eax, dword [byte esp+08h]
        mov dword [byte esp+04h], eax
        mov ecx, 4
        mov edx, 6
.5:
        inc edx
        cmp edx, byte 7
        jl short TeamGridHitTest.2
        inc ecx
        cmp ecx, byte 4
        jl near TeamGridHitTest.1
        mov ecx, dword [byte esp+04h]
        cmp ecx, byte 63h
        jne short .6
        mov eax, 0FFFFFFFFh
        jmp short .x
.6:
        mov eax, ecx
.x:
        add esp, byte 10h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawTeamGridName                                                37C53  95 PC
; Prints a team's name centred in its division grid cell
;-----------------------------------------------------------------------------
; C: src/front/calendar/DrawTeamGridName.c
%ifdef CBUILD
%include "c/front/calendar/DrawTeamGridName.inc"
%else
DrawTeamGridName:
        push dword 38h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 8
        push eax
        push edx
        push ebx
        push ecx
        mov edx, dword [dlgtextbg]
        mov eax, dword [dlgtextfg]
        call SetTextColors
        xor edx, edx
        mov dword [byte esp+014h], edx
.1:
        xor edi, edi
.2:
        mov edx, dword [byte esp+014h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        add eax, dword [esp]
        mov al, byte [edi+eax]
        and eax, 0FFh
        cmp eax, dword [byte esp+0Ch]
        jne near .5
        mov eax, edi
        shl eax, 2
        add eax, edi
        mov esi, eax
        shl eax, 4
        add eax, esi
        cmp edx, byte 2
        jge short .3
        lea esi, [byte eax+039h]
        jmp short .4
.3:
        lea esi, [byte eax+0Fh]
.4:
        mov ebp, dword [byte esp+014h]
        mov eax, ebp
        shl eax, 2
        sub eax, ebp
        shl eax, 3
        sub eax, ebp
        shl eax, 2
        lea ebp, [dword eax+097h]
        lea edx, [byte esi+04Dh]
        xor eax, eax
        mov al, byte [byte_D42C3]
        add eax, ebp
        inc eax
        push eax
        push ebp
        push edx
        push esi
        call SetClipWindow
        add esp, byte 10h
        push byte 0
        push byte 0
        mov eax, dword [byte esp+0Ch]
        push eax
        call DrawArt
        add esp, byte 0Ch
        push dword 1E0h
        push byte 0
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        mov edx, dword [byte esp+0Ch]
        mov eax, edx
        shl eax, 4
        sub eax, edx
        add eax, eax
        mov edx, dword [byte esp+08h]
        add edx, eax
        mov dword [byte esp+010h], edx
        push edx
        call fputchar
        add esp, byte 4
        sar eax, 1
        add esi, byte 2Ah
        sub esi, eax
        mov ebx, dword [byte esp+010h]
        mov edx, ebp
        mov eax, esi
        call PrintShadowText
.5:
        inc edi
        cmp edi, byte 7
        jl near DrawTeamGridName.2
        mov ebx, dword [byte esp+014h]
        inc ebx
        mov dword [byte esp+014h], ebx
        cmp ebx, byte 4
        jl near DrawTeamGridName.1
        add esp, byte 18h
        pop ebp
        pop edi
        pop esi
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SaveGridCellBg                                                  37D6A  95 PC
; Allocates "back" and saves the screen under a team's grid cell
;-----------------------------------------------------------------------------
; C: src/front/calendar/SaveGridCellBg.c
%ifdef CBUILD
%include "c/front/calendar/SaveGridCellBg.inc"
%else
SaveGridCellBg:
        push dword 28h
        call __CHK
        push esi
        push edi
        push ebp
        push eax
        push edx
        push ebx
        mov ebp, ecx
        push byte 20h
        push dword 4688h
        push str_Back
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [gridcellbuf], eax
        mov ebx, 11h
        xor edx, edx
        call memset_
        mov eax, dword [gridcellbuf]
        mov word [byte eax+04h], 4Eh
        mov eax, dword [gridcellbuf]
        mov word [byte eax+06h], 41h
        xor edi, edi
.1:
        xor esi, esi
.2:
        mov eax, edi
        shl eax, 3
        sub eax, edi
        add eax, dword [byte esp+04h]
        mov al, byte [esi+eax]
        and eax, 0FFh
        cmp eax, dword [byte esp+08h]
        jne short .5
        mov eax, esi
        shl eax, 2
        add eax, esi
        mov edx, eax
        shl eax, 4
        add eax, edx
        cmp edi, byte 2
        jge short .3
        add eax, byte 3Ch
        jmp short .4
.3:
        add eax, byte 12h
.4:
        mov dword [gridcellx], eax
        mov eax, edi
        shl eax, 2
        sub eax, edi
        shl eax, 3
        sub eax, edi
        shl eax, 2
        add eax, byte 54h
        mov dword [gridcelly], eax
        mov ecx, dword [byte esp+01Ch]
        push ecx
        lea eax, [byte ebp-04h]
        push eax
        mov eax, dword [byte esp+08h]
        push eax
        call PutBlock
        add esp, byte 0Ch
        mov edx, dword [gridcelly]
        push edx
        mov ebx, dword [gridcellx]
        push ebx
        mov ecx, dword [gridcellbuf]
        push ecx
        call GrabBlock
        add esp, byte 0Ch
.5:
        inc esi
        cmp esi, byte 7
        jl near SaveGridCellBg.2
        inc edi
        cmp edi, byte 4
        jl near SaveGridCellBg.1
        add esp, byte 0Ch
        pop ebp
        pop edi
        pop esi
        ret 4
%endif ; C
;-----------------------------------------------------------------------------
; RestoreGridCellBg                                               37E5B  95 PC
; Restores and frees the saved grid cell
;-----------------------------------------------------------------------------
; C: src/front/calendar/RestoreGridCellBg.c
%ifdef CBUILD
%include "c/front/calendar/RestoreGridCellBg.inc"
%else
RestoreGridCellBg:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edi
        push ebp
        mov edx, dword [gridcellbuf]
        test edx, edx
        je short .x
        mov ebx, dword [gridcelly]
        push ebx
        mov ecx, dword [gridcellx]
        push ecx
        push edx
        call PutBlock
        add esp, byte 0Ch
        mov edi, dword [gridcellbuf]
        push edi
        call FreeMemBlock
        add esp, byte 4
        xor ebp, ebp
        mov dword [gridcellbuf], ebp
.x:
        pop ebp
        pop edi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; HighlightGridCell                                               37EA6  95 PC
; (on, grid, team): draws or erases the frame around a team's grid cell
;-----------------------------------------------------------------------------
; C: src/front/calendar/HighlightGridCell.c
%ifdef CBUILD
%include "c/front/calendar/HighlightGridCell.inc"
%else
HighlightGridCell:
        push dword 48h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 14h
        push eax
        push edx
        push ebx
        xor edi, edi
.1:
        xor esi, esi
.2:
        mov eax, edi
        shl eax, 3
        sub eax, edi
        add eax, dword [byte esp+04h]
        mov al, byte [esi+eax]
        and eax, 0FFh
        cmp eax, dword [byte esp+08h]
        jne near .7
        mov eax, esi
        shl eax, 2
        add eax, esi
        mov edx, eax
        shl eax, 4
        add eax, edx
        cmp edi, byte 2
        jge short .3
        lea edx, [byte eax+03Eh]
        jmp short .4
.3:
        lea edx, [byte eax+014h]
.4:
        mov eax, edi
        shl eax, 2
        sub eax, edi
        shl eax, 3
        sub eax, edi
        shl eax, 2
        lea ebx, [byte eax+056h]
        lea ebp, [byte edx+04Ah]
        mov dword [byte esp+0Ch], ebp
        lea ebp, [dword eax+093h]
        mov dword [byte esp+014h], ebp
        lea ebp, [byte edx-01h]
        mov dword [byte esp+018h], ebp
        lea ebp, [byte eax+055h]
        lea ecx, [byte edx+04Bh]
        mov dword [byte esp+01Ch], ecx
        add eax, 94h
        mov dword [byte esp+010h], eax
        mov ecx, dword [esp]
        test ecx, ecx
        je short .5
        push dword 80h
        mov ecx, dword [byte esp+018h]
        push ecx
        mov eax, dword [byte esp+014h]
        push eax
        push ebx
        push edx
        call sub_92F50
        add esp, byte 14h
        push dword 80h
        mov edx, dword [byte esp+014h]
        push edx
        mov ebx, dword [byte esp+024h]
        push ebx
        push ebp
        mov ecx, dword [byte esp+028h]
        push ecx
        call sub_92F50
        jmp short .6
.5:
        push ecx
        mov eax, dword [byte esp+018h]
        push eax
        mov ecx, dword [byte esp+014h]
        push ecx
        push ebx
        push edx
        call sub_93000
        add esp, byte 14h
        push byte 0
        mov eax, dword [byte esp+014h]
        push eax
        mov edx, dword [byte esp+024h]
        push edx
        push ebp
        mov ebx, dword [byte esp+028h]
        push ebx
        call sub_93000
.6:
        add esp, byte 14h
.7:
        inc esi
        cmp esi, byte 7
        jl near HighlightGridCell.2
        inc edi
        cmp edi, byte 4
        jl near HighlightGridCell.1
        add esp, byte 20h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawTeamGrid                                 37FBA  95 PC, medium confidence
; Centred title, callogo crest of each team in the division grid and their
; names (DrawTeamGridName)
;-----------------------------------------------------------------------------
; C: src/front/calendar/DrawTeamGrid.c
%ifdef CBUILD
%include "c/front/calendar/DrawTeamGrid.inc"
%else
DrawTeamGrid:
        push dword 0E8h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, 0C0h
        push eax
        push ebx
        push ecx
        lea eax, [byte esp+074h]
        call strcpy_
        lea edx, [byte esp+074h]
        mov eax, 28h
        call PrintCenteredText
        xor ecx, ecx
        mov ebx, str_Callogo2
        cmp byte [fileoncd+01C2h], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
        lea eax, [byte esp+074h]
        call MakePath
        push byte 0
        lea eax, [byte esp+078h]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [dword esp+0C8h], eax
        xor ebp, ebp
.3:
        mov edx, dword [nosplit ebp*4+crestnames]
        push edx
        mov ebx, dword [dword esp+0CCh]
        push ebx
        call FindShape
        add esp, byte 8
        mov dword [byte esp+ebp*4+0Ch], eax
        inc ebp
        cmp ebp, byte 1Ah
        jl short DrawTeamGrid.3
        xor ebp, ebp
.4:
        xor edi, edi
.5:
        mov eax, ebp
        shl eax, 3
        sub eax, ebp
        mov esi, dword [byte esp+04h]
        add esi, eax
        movzx esi, byte [edi+esi]
        cmp esi, byte 63h
        je short .9
        mov eax, edi
        shl eax, 2
        add eax, edi
        mov edx, eax
        shl eax, 4
        add eax, edx
        cmp ebp, byte 2
        jge short .6
        lea ebx, [byte eax+040h]
        jmp short .7
.6:
        lea ebx, [byte eax+016h]
.7:
        mov eax, ebp
        shl eax, 2
        sub eax, ebp
        shl eax, 3
        sub eax, ebp
        shl eax, 2
        add eax, byte 58h
        push eax
        push ebx
        mov ecx, dword [byte esp+esi*4+014h]
        push ecx
        call DrawArt
        add esp, byte 0Ch
        mov eax, esi
        shl eax, 4
        sub eax, esi
        add eax, eax
        add eax, dword [byte esp+08h]
        cmp byte [byte eax+017h], 1
        jne short .8
        mov ecx, dword [byte esp+04h]
        mov ebx, dword [esp]
        mov edx, dword [byte esp+08h]
        mov eax, esi
        call DrawTeamGridName
.8:
        inc edi
        cmp edi, byte 7
        jl short DrawTeamGrid.5
.9:
        inc ebp
        cmp ebp, byte 4
        jl near DrawTeamGrid.4
        mov ebx, dword [dword esp+0C8h]
        push ebx
        call FreeMemBlock
        add esp, byte 4
        add esp, 0CCh
        pop ebp
        pop edi
        pop esi
        ret
%endif ; C
