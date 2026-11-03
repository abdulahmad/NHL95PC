; The league calendar, stepping to the next or previous month, playing a league game, posting the result
; into the team files, and the team grid used while setting a league up.
bits 32
%include "hockey.inc"
section s_33FFD progbits alloc exec nowrite align=1
extern __CHK, __STOSB, _fstrcspn_, AskTeamPassword, awlinetab, awscore, awtmgoalie, awtmlines
extern btn_MasterDB, byte_D42C3, byte_DC267, byte_DC268, byte_DDD40, byte_DDD41, byte_DDD42, byte_DDD43
extern byte_DDD45, calcolx, calendarshapes, calexit, CalGoalieStatsScreen, calmenubar, calmonth, calnextslot
extern calprevslot, calrowy, calsel, calselday, calselmonth, CalSkaterStatsScreen, CalStandingsMenu, CalStandingsScreen
extern CalTeamStatsScreen, cddriveptr, CheckGameDiskSpace, ClearInputQueue, crestnames, curleague, dlgtextbg, dlgtextfg
extern DrawMenuBar, DrawMenuDropdown, DrawMenuItemNorm, DrawMenuItemSel, dword_C7F0B, dword_DB088, dword_DC23E, dword_DDD2C
extern dword_DDD34, dword_DDD3C, dword_DDD44, FadeOutPalCycle, FadePalStep, FileClose, FileExists, fileoncd
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
extern strcat_, strcpy_, sub_8CCA8, sub_8D2F0, sub_8E83C, sub_8E9E8, sub_8EA00, sub_8EA18
extern sub_8F98F, sub_8FB8E, sub_8FC8A, sub_8FCDF, sub_8FFB0, sub_903F0, sub_9061C, sub_91370
extern sub_913D0, sub_91400, sub_91964, sub_92F50, sub_93000, sub_B2DCA, sub_B2E1B, sub_B30B4
extern sub_B392C, sub_B4B88, sub_B4BA8, sub_B4BC4, sub_B4DD4, sub_B4FAC, teamstatscb, treeteamnames
extern unk_C7805, unk_C7F07, unk_C7F1B, unk_DC240, UpdatePlayoffSeries, UpdateSeasonSchedule, UpdateTeamDbs, updschedmsg
extern VisTeam, WaitLeagueFloppy, word_DB08A, word_DB08C, word_DB08E, word_DB090, word_DB092, word_DB096
extern word_DC242, word_DC244, word_DDD48, word_DDD4A, WriteGoalieSeasonRec, WriteSchedGame, WriteSeasonRec, WriteTeamRec
global DrawCalendarDay, CalNextMonth, CalPrevMonth, CalReturn, ApplyShapePalette, SetGameSides, CalendarScreen, CheckLeagueDiskSync
global MakeTeamDbFmt, PostGameToTeamDb, PlayLeagueGame, TeamGridHitTest, DrawTeamGridName, SaveGridCellBg, RestoreGridCellBg, HighlightGridCell
global DrawTeamGrid
DrawCalendarDay:
push dword 0CCh	; 33FFD
call __CHK	; 34002
push esi	; 34007
push edi	; 34008
push ebp	; 34009
sub esp, 9Ch	; 3400A
push eax	; 34010
push edx	; 34011
push ecx	; 34012
mov esi, dword [dword esp+0C4h]	; 34013
push str_Boxr	; 3401A
push esi	; 3401F
call sub_B30B4	; 34020
add esp, byte 8	; 34025
mov dword [dword esp+084h], eax	; 34028
push str_Boxb	; 3402F
push esi	; 34034
call sub_B30B4	; 34035
add esp, byte 8	; 3403A
mov dword [dword esp+094h], eax	; 3403D
push str_Bkgd7	; 34044
push esi	; 34049
call sub_B30B4	; 3404A
add esp, byte 8	; 3404F
push eax	; 34052
call sub_9061C	; 34053
add esp, byte 4	; 34058
mov edx, dword [byte esp+08h]	; 3405B
cmp edx, byte 9	; 3405F
setl al	; 34062
and eax, 0FFh	; 34065
add eax, byte 3	; 3406A
push eax	; 3406D
lea eax, [byte edx+01h]	; 3406E
push eax	; 34071
push str_02d9D	; 34072
lea eax, [byte esp+058h]	; 34077
push eax	; 3407B
call sprintf_	; 3407C
add esp, byte 10h	; 34081
lea eax, [byte esp+04Ch]	; 34084
push eax	; 34088
push esi	; 34089
call sub_B30B4	; 3408A
add esp, byte 8	; 3408F
push eax	; 34092
call sub_9061C	; 34093
add esp, byte 4	; 34098
mov ecx, dword [dword esp+0BCh]	; 3409B
shl ecx, 2	; 340A2
mov ebx, dword [dword ecx+crestnames]	; 340A5
mov byte [byte esp+04Ch], 21h	; 340AB
mov al, byte [ebx]	; 340B0
mov byte [byte esp+04Dh], al	; 340B2
mov al, byte [byte ebx+01h]	; 340B6
mov byte [byte esp+04Eh], al	; 340B9
mov al, byte [byte ebx+02h]	; 340BD
mov byte [byte esp+04Fh], al	; 340C0
push byte 3Fh	; 340C4
push byte 26h	; 340C6
add ecx, dword [byte esp+0Ch]	; 340C8
mov esi, dword [ecx]	; 340CC
push esi	; 340CE
call sub_913D0	; 340CF
add esp, byte 0Ch	; 340D4
lea eax, [byte esp+0Ch]	; 340D7
push eax	; 340DB
call sub_8E9E8	; 340DC
add esp, byte 4	; 340E1
mov edi, dword [dword esp+0C0h]	; 340E4
push edi	; 340EB
call sub_8EA18	; 340EC
add esp, byte 4	; 340F1
mov dword [fontcolor], 0C0h	; 340F4
mov eax, dword [byte esp+08h]	; 340FE
cmp byte [dword eax+monthfirstday], 0	; 34102
je short .1	; 34109
mov esi, dword [calcolx]	; 3410B
add esi, byte 7	; 34111
mov edi, dword [calrowy]	; 34114
jmp short .2	; 3411A
.1:
mov esi, dword [calcolx+18h]	; 3411C
add esi, byte 7	; 34122
mov edi, dword [calrowy+14h]	; 34125
.2:
add edi, byte 5	; 3412B
mov dword [fontcolor], 0B6h	; 3412E
push edi	; 34138
push esi	; 34139
push str_Home	; 3413A
call sub_91964	; 3413F
add esp, byte 0Ch	; 34144
mov dword [fontcolor], 0B7h	; 34147
add edi, byte 0Ch	; 34151
push edi	; 34154
push esi	; 34155
push str_Away	; 34156
call sub_91964	; 3415B
add esp, byte 0Ch	; 34160
xor ebp, ebp	; 34163
jmp near .4	; 34165
.3:
xor ebx, ebx	; 3416A
mov eax, dword [byte esp+08h]	; 3416C
mov bl, byte [dword eax+monthfirstday]	; 34170
add ebx, ebp	; 34176
mov esi, 7	; 34178
mov eax, ebx	; 3417D
mov edx, ebx	; 3417F
sar edx, 1Fh	; 34181
idiv esi	; 34184
mov esi, edx	; 34186
mov ecx, 7	; 34188
mov eax, ebx	; 3418D
mov edx, ebx	; 3418F
sar edx, 1Fh	; 34191
idiv ecx	; 34194
mov esi, dword [nosplit esi*4+calcolx]	; 34196
add esi, byte 4	; 3419D
mov edi, dword [nosplit eax*4+calrowy]	; 341A0
inc edi	; 341A7
inc ebp	; 341A8
push ebp	; 341A9
push str_D8	; 341AA
lea eax, [byte esp+054h]	; 341AF
push eax	; 341B3
call sprintf_	; 341B4
add esp, byte 0Ch	; 341B9
mov dword [fontcolor], 0C0h	; 341BC
push edi	; 341C6
push esi	; 341C7
lea eax, [byte esp+054h]	; 341C8
push eax	; 341CC
call sub_91964	; 341CD
add esp, byte 0Ch	; 341D2
mov dword [fontcolor], 0FFh	; 341D5
dec edi	; 341DF
push edi	; 341E0
dec esi	; 341E1
push esi	; 341E2
lea eax, [byte esp+054h]	; 341E3
push eax	; 341E7
call sub_91964	; 341E8
add esp, byte 0Ch	; 341ED
.4:
xor eax, eax	; 341F0
mov ebx, dword [byte esp+08h]	; 341F2
mov al, byte [dword ebx+monthdays]	; 341F6
cmp ebp, eax	; 341FC
jl near DrawCalendarDay.3	; 341FE
mov dword [dword esp+098h], 0FFFFFFFFh	; 34204
xor ebp, ebp	; 3420F
jmp near .18	; 34211
.5:
mov ebx, ebp	; 34216
shl ebx, 2	; 34218
sub ebx, ebp	; 3421B
add ebx, ebx	; 3421D
add ebx, dword [esp]	; 3421F
xor ecx, ecx	; 34222
mov cl, byte [ebx]	; 34224
mov eax, dword [byte esp+08h]	; 34226
inc eax	; 3422A
cmp ecx, eax	; 3422B
jne near .17	; 3422D
xor ecx, eax	; 34233
mov cl, byte [byte ebx+01h]	; 34235
xor eax, eax	; 34238
mov esi, dword [byte esp+08h]	; 3423A
mov al, byte [dword esi+monthfirstday]	; 3423E
add eax, ecx	; 34244
lea esi, [byte eax-01h]	; 34246
mov ecx, 7	; 34249
mov eax, esi	; 3424E
mov edx, esi	; 34250
sar edx, 1Fh	; 34252
idiv ecx	; 34255
mov edi, edx	; 34257
mov eax, esi	; 34259
mov edx, esi	; 3425B
sar edx, 1Fh	; 3425D
idiv ecx	; 34260
mov esi, edi	; 34262
mov esi, dword [nosplit esi*4+calcolx]	; 34264
mov edi, dword [nosplit eax*4+calrowy]	; 3426B
xor eax, eax	; 34272
mov al, byte [byte ebx+02h]	; 34274
cmp eax, dword [dword esp+0BCh]	; 34277
jne short .10	; 3427E
mov eax, dword [dword esp+084h]	; 34280
mov dword [dword esp+09Ch], eax	; 34287
xor eax, eax	; 3428E
mov al, byte [byte ebx+03h]	; 34290
mov dword [dword esp+0A4h], eax	; 34293
mov al, byte [byte ebx+04h]	; 3429A
mov ch, byte [byte ebx+05h]	; 3429D
cmp al, ch	; 342A0
jbe short .7	; 342A2
xor eax, eax	; 342A4
mov al, ch	; 342A6
push eax	; 342A8
xor eax, eax	; 342A9
mov al, byte [byte ebx+04h]	; 342AB
.6:
push eax	; 342AE
push str_W5	; 342AF
jmp near .13	; 342B4
.7:
jae short .9	; 342B9
xor eax, eax	; 342BB
mov al, ch	; 342BD
push eax	; 342BF
xor eax, eax	; 342C0
mov al, byte [byte ebx+04h]	; 342C2
.8:
push eax	; 342C5
push str_L7	; 342C6
jmp short .13	; 342CB
.9:
xor eax, eax	; 342CD
mov al, ch	; 342CF
push eax	; 342D1
xor eax, eax	; 342D2
mov al, byte [byte ebx+04h]	; 342D4
push eax	; 342D7
push str_T5	; 342D8
jmp short .13	; 342DD
.10:
mov ecx, dword [dword esp+094h]	; 342DF
mov dword [dword esp+09Ch], ecx	; 342E6
mov dword [dword esp+0A4h], eax	; 342ED
mov al, byte [byte ebx+04h]	; 342F4
mov dh, byte [byte ebx+05h]	; 342F7
cmp al, dh	; 342FA
jbe short .11	; 342FC
xor eax, eax	; 342FE
mov al, byte [byte ebx+04h]	; 34300
push eax	; 34303
xor eax, eax	; 34304
mov al, dh	; 34306
jmp short DrawCalendarDay.8	; 34308
.11:
jae short .12	; 3430A
xor eax, eax	; 3430C
mov al, byte [byte ebx+04h]	; 3430E
push eax	; 34311
xor eax, eax	; 34312
mov al, dh	; 34314
jmp short DrawCalendarDay.6	; 34316
.12:
xor eax, eax	; 34318
mov al, dh	; 3431A
push eax	; 3431C
xor eax, eax	; 3431D
mov al, byte [byte ebx+04h]	; 3431F
push eax	; 34322
push str_T5	; 34323
.13:
push str_SDD2	; 34328
lea eax, [byte esp+07Ch]	; 3432D
push eax	; 34331
call sprintf_	; 34332
add esp, byte 14h	; 34337
mov ebx, ebp	; 3433A
shl ebx, 2	; 3433C
sub ebx, ebp	; 3433F
add ebx, ebx	; 34341
mov eax, dword [esp]	; 34343
add eax, ebx	; 34346
mov dword [dword esp+0A0h], eax	; 34348
cmp byte [byte eax+04h], 0FFh	; 3434F
je short .14	; 34353
cmp byte [byte eax+05h], 0FFh	; 34355
jne near .15	; 34359
.14:
push edi	; 3435F
push esi	; 34360
mov edx, dword [dword esp+0A4h]	; 34361
push edx	; 34368
call sub_91370	; 34369
add esp, byte 0Ch	; 3436E
push edi	; 34371
push esi	; 34372
mov eax, dword [dword esp+0ACh]	; 34373
shl eax, 2	; 3437A
add eax, dword [byte esp+0Ch]	; 3437D
mov ecx, dword [eax]	; 34381
push ecx	; 34383
call sub_91370	; 34384
add esp, byte 0Ch	; 34389
mov ebx, ebp	; 3438C
shl ebx, 2	; 3438E
sub ebx, ebp	; 34391
mov eax, dword [esp]	; 34393
mov al, byte [byte eax+ebx*2+01h]	; 34396
and eax, 0FFh	; 3439A
push eax	; 3439F
push str_D8	; 343A0
lea eax, [byte esp+054h]	; 343A5
push eax	; 343A9
call sprintf_	; 343AA
add esp, byte 0Ch	; 343AF
mov dword [fontcolor], 0FFh	; 343B2
lea eax, [byte edi+01h]	; 343BC
push eax	; 343BF
lea eax, [byte esi+04h]	; 343C0
push eax	; 343C3
lea eax, [byte esp+054h]	; 343C4
push eax	; 343C8
call sub_91964	; 343C9
add esp, byte 0Ch	; 343CE
mov dword [fontcolor], 0C0h	; 343D1
push edi	; 343DB
add esi, byte 3	; 343DC
push esi	; 343DF
lea eax, [byte esp+054h]	; 343E0
jmp near .16	; 343E4
.15:
push edi	; 343E9
push esi	; 343EA
mov eax, dword [dword esp+0ACh]	; 343EB
shl eax, 2	; 343F2
add eax, dword [byte esp+0Ch]	; 343F5
mov ecx, dword [eax]	; 343F9
push ecx	; 343FB
call sub_91370	; 343FC
add esp, byte 0Ch	; 34401
xor eax, eax	; 34404
mov ebx, dword [dword esp+0A0h]	; 34406
mov al, byte [byte ebx+01h]	; 3440D
push eax	; 34410
push str_D8	; 34411
lea eax, [byte esp+054h]	; 34416
push eax	; 3441A
call sprintf_	; 3441B
add esp, byte 0Ch	; 34420
mov dword [fontcolor], 0C0h	; 34423
lea eax, [byte edi+01h]	; 3442D
push eax	; 34430
lea eax, [byte esi+04h]	; 34431
push eax	; 34434
lea eax, [byte esp+054h]	; 34435
push eax	; 34439
call sub_91964	; 3443A
add esp, byte 0Ch	; 3443F
mov dword [fontcolor], 0FFh	; 34442
push edi	; 3444C
lea eax, [byte esi+03h]	; 3444D
push eax	; 34450
lea eax, [byte esp+054h]	; 34451
push eax	; 34455
call sub_91964	; 34456
add esp, byte 0Ch	; 3445B
push edi	; 3445E
push esi	; 3445F
mov ebx, dword [dword esp+0A4h]	; 34460
push ebx	; 34467
call sub_91370	; 34468
add esp, byte 0Ch	; 3446D
mov dword [fontcolor], 0FFh	; 34470
lea eax, [byte edi+031h]	; 3447A
push eax	; 3447D
lea eax, [byte esp+070h]	; 3447E
push eax	; 34482
call fputchar	; 34483
add esp, byte 4	; 34488
sar eax, 1	; 3448B
lea ebx, [byte esi+027h]	; 3448D
sub ebx, eax	; 34490
push ebx	; 34492
lea eax, [byte esp+074h]	; 34493
push eax	; 34497
call sub_91964	; 34498
add esp, byte 0Ch	; 3449D
mov dword [fontcolor], 0C0h	; 344A0
add edi, byte 30h	; 344AA
push edi	; 344AD
lea eax, [byte esp+070h]	; 344AE
push eax	; 344B2
call fputchar	; 344B3
add esp, byte 4	; 344B8
sar eax, 1	; 344BB
add esi, byte 26h	; 344BD
sub esi, eax	; 344C0
push esi	; 344C2
lea eax, [byte esp+074h]	; 344C3
.16:
push eax	; 344C7
call sub_91964	; 344C8
add esp, byte 0Ch	; 344CD
mov eax, ebp	; 344D0
mov ebx, ebp	; 344D2
shl ebx, 2	; 344D4
sub ebx, ebp	; 344D7
add ebx, ebx	; 344D9
add ebx, dword [esp]	; 344DB
xor eax, ebp	; 344DE
mov al, byte [ebx]	; 344E0
mov esi, dword [calselmonth]	; 344E2
cmp eax, esi	; 344E8
jne short .17	; 344EA
xor eax, esi	; 344EC
mov al, byte [byte ebx+01h]	; 344EE
cmp eax, dword [calselday]	; 344F1
jne short .17	; 344F7
mov dword [dword esp+098h], ebp	; 344F9
.17:
inc ebp	; 34500
.18:
cmp ebp, dword [dword esp+0B8h]	; 34501
jl near DrawCalendarDay.5	; 34508
mov ebx, dword [dword esp+098h]	; 3450E
test ebx, ebx	; 34515
jl near .19	; 34517
mov eax, ebx	; 3451D
shl eax, 2	; 3451F
sub eax, ebx	; 34522
add eax, eax	; 34524
add eax, dword [esp]	; 34526
mov al, byte [byte eax+01h]	; 34529
and eax, 0FFh	; 3452C
xor ebx, ebx	; 34531
mov ecx, dword [byte esp+08h]	; 34533
mov bl, byte [dword ecx+monthfirstday]	; 34537
add eax, ebx	; 3453D
lea ebx, [byte eax-01h]	; 3453F
mov ecx, 7	; 34542
mov eax, ebx	; 34547
mov edx, ebx	; 34549
sar edx, 1Fh	; 3454B
idiv ecx	; 3454E
mov esi, edx	; 34550
mov eax, ebx	; 34552
mov edx, ebx	; 34554
sar edx, 1Fh	; 34556
idiv ecx	; 34559
mov esi, dword [nosplit esi*4+calcolx]	; 3455B
mov edi, dword [nosplit eax*4+calrowy]	; 34562
lea eax, [byte esi+04Ch]	; 34569
mov dword [dword esp+090h], eax	; 3456C
lea ebp, [byte edi+03Eh]	; 34573
push dword 0BBh	; 34576
lea eax, [byte edi-01h]	; 3457B
mov dword [dword esp+080h], eax	; 3457E
push eax	; 34585
mov edx, dword [dword esp+098h]	; 34586
push edx	; 3458D
push eax	; 3458E
lea eax, [byte esi-01h]	; 3458F
mov dword [dword esp+090h], eax	; 34592
push eax	; 34599
call sub_B4FAC	; 3459A
add esp, byte 14h	; 3459F
push dword 0BBh	; 345A2
push edi	; 345A7
mov eax, dword [dword esp+098h]	; 345A8
dec eax	; 345AF
mov dword [dword esp+090h], eax	; 345B0
push eax	; 345B7
push edi	; 345B8
push esi	; 345B9
call sub_B4FAC	; 345BA
add esp, byte 14h	; 345BF
push dword 0BBh	; 345C2
push ebp	; 345C7
mov edx, dword [dword esp+088h]	; 345C8
push edx	; 345CF
mov ebx, dword [dword esp+088h]	; 345D0
push ebx	; 345D7
push edx	; 345D8
call sub_B4FAC	; 345D9
add esp, byte 14h	; 345DE
push dword 0BBh	; 345E1
lea eax, [byte ebp-01h]	; 345E6
mov dword [dword esp+090h], eax	; 345E9
push eax	; 345F0
push esi	; 345F1
push edi	; 345F2
push esi	; 345F3
call sub_B4FAC	; 345F4
add esp, byte 14h	; 345F9
push dword 0BBh	; 345FC
push ebp	; 34601
mov edx, dword [dword esp+098h]	; 34602
push edx	; 34609
mov ebx, dword [dword esp+088h]	; 3460A
push ebx	; 34611
push edx	; 34612
call sub_B4FAC	; 34613
add esp, byte 14h	; 34618
push dword 0BBh	; 3461B
mov eax, dword [dword esp+090h]	; 34620
push eax	; 34627
mov edx, dword [dword esp+090h]	; 34628
push edx	; 3462F
push edi	; 34630
push edx	; 34631
call sub_B4FAC	; 34632
add esp, byte 14h	; 34637
push dword 0BBh	; 3463A
push ebp	; 3463F
mov ecx, dword [dword esp+098h]	; 34640
push ecx	; 34647
push ebp	; 34648
mov edi, dword [dword esp+090h]	; 34649
push edi	; 34650
call sub_B4FAC	; 34651
add esp, byte 14h	; 34656
push dword 0BBh	; 34659
mov ebp, dword [dword esp+090h]	; 3465E
push ebp	; 34665
mov eax, dword [dword esp+090h]	; 34666
push eax	; 3466D
push ebp	; 3466E
push esi	; 3466F
call sub_B4FAC	; 34670
add esp, byte 14h	; 34675
.19:
lea eax, [byte esp+0Ch]	; 34678
push eax	; 3467C
call sub_8EA00	; 3467D
add esp, byte 4	; 34682
add esp, 0A8h	; 34685
pop ebp	; 3468B
pop edi	; 3468C
pop esi	; 3468D
ret 10h	; 3468E
; C: src/c/front/calendar/CalNextMonth.c
%ifdef CBUILD
%include "c/front/calendar/CalNextMonth.inc"
%else
CalNextMonth:
push dword 10h	; 34691
call __CHK	; 34696
push ebx	; 3469B
push ecx	; 3469C
push edi	; 3469D
mov dword [calnextslot], CalNextMonth	; 3469E
mov dword [calprevslot], CalPrevMonth	; 346A8
mov ecx, dword [calmonth]	; 346B2
inc ecx	; 346B8
mov dword [calmonth], ecx	; 346B9
cmp ecx, byte 0Ch	; 346BF
jne short .1	; 346C2
xor edi, edi	; 346C4
mov dword [calmonth], edi	; 346C6
.1:
cmp dword [calmonth], byte 6	; 346CC
jne short .2	; 346D3
mov dword [calmonth], 5	; 346D5
.2:
cmp dword [calmonth], byte 5	; 346DF
jne short .3	; 346E6
xor ebx, ebx	; 346E8
mov dword [calnextslot], ebx	; 346EA
.3:
mov dword [calsel], 0FFFFFFFFh	; 346F0
pop edi	; 346FA
pop ecx	; 346FB
pop ebx	; 346FC
ret	; 346FD
%endif ; C
; C: src/c/front/calendar/CalPrevMonth.c
%ifdef CBUILD
%include "c/front/calendar/CalPrevMonth.inc"
%else
CalPrevMonth:
push dword 0Ch	; 346FE
call __CHK	; 34703
push ebx	; 34708
push ecx	; 34709
mov dword [calnextslot], CalNextMonth	; 3470A
mov dword [calprevslot], CalPrevMonth	; 34714
mov ecx, dword [calmonth]	; 3471E
dec ecx	; 34724
mov dword [calmonth], ecx	; 34725
cmp ecx, byte 0FFFFFFFFh	; 3472B
jne short .1	; 3472E
mov dword [calmonth], 0Bh	; 34730
.1:
cmp dword [calmonth], byte 8	; 3473A
jne short .2	; 34741
mov dword [calmonth], 9	; 34743
.2:
cmp dword [calmonth], byte 9	; 3474D
jne short .3	; 34754
xor ebx, ebx	; 34756
mov dword [calprevslot], ebx	; 34758
.3:
mov dword [calsel], 0FFFFFFFFh	; 3475E
pop ecx	; 34768
pop ebx	; 34769
ret	; 3476A
%endif ; C
; C: src/c/front/calendar/CalReturn.c
%ifdef CBUILD
%include "c/front/calendar/CalReturn.inc"
%else
CalReturn:
push dword 8	; 3476B
call __CHK	; 34770
push edx	; 34775
mov edx, 0FFFFFFFFh	; 34776
mov dword [calexit], edx	; 3477B
mov dword [calsel], edx	; 34781
pop edx	; 34787
ret	; 34788
%endif ; C
; C: src/c/front/calendar/ApplyShapePalette.c
%ifdef CBUILD
%include "c/front/calendar/ApplyShapePalette.inc"
%else
ApplyShapePalette:
push dword 18h	; 34789
call __CHK	; 3478E
push ebx	; 34793
push ecx	; 34794
push edx	; 34795
push str_Pal17	; 34796
push eax	; 3479B
call sub_B30B4	; 3479C
add esp, byte 8	; 347A1
lea edx, [byte eax+010h]	; 347A4
mov ebx, 10h	; 347A7
xor eax, eax	; 347AC
call FadePalStep	; 347AE
pop edx	; 347B3
pop ecx	; 347B4
pop ebx	; 347B5
ret	; 347B6
%endif ; C
; C: src/c/front/calendar/SetGameSides.c
%ifdef CBUILD
%include "c/front/calendar/SetGameSides.inc"
%else
SetGameSides:
push dword 0Ch	; 347B7
call __CHK	; 347BC
push ecx	; 347C1
push esi	; 347C2
mov esi, eax	; 347C3
mov ecx, edx	; 347C5
mov edx, ebx	; 347C7
shl edx, 2	; 347C9
sub edx, ebx	; 347CC
add edx, edx	; 347CE
add edx, ecx	; 347D0
xor eax, eax	; 347D2
mov al, byte [byte edx+02h]	; 347D4
cmp esi, eax	; 347D7
jne short .1	; 347D9
mov dl, byte [byte edx+03h]	; 347DB
and edx, 0FFh	; 347DE
jmp short .2	; 347E4
.1:
movzx esi, byte [byte edx+03h]	; 347E6
mov edx, eax	; 347EA
.2:
mov eax, edx	; 347EC
shl eax, 4	; 347EE
sub eax, edx	; 347F1
cmp byte [nosplit eax*2+lgteam_17], 1	; 347F3
je short .3	; 347FB
mov edx, 0FFFFFFFFh	; 347FD
.3:
mov eax, ebx	; 34802
shl eax, 2	; 34804
sub eax, ebx	; 34807
add eax, eax	; 34809
add eax, ecx	; 3480B
xor ecx, ecx	; 3480D
mov cl, byte [byte eax+03h]	; 3480F
xor ebx, ebx	; 34812
mov bl, byte [byte eax+02h]	; 34814
mov eax, esi	; 34817
call SetCtlTeams	; 34819
pop esi	; 3481E
pop ecx	; 3481F
ret	; 34820
%endif ; C
CalendarScreen:
push dword 7F8h	; 34821
call __CHK	; 34826
push ecx	; 3482B
push esi	; 3482C
push edi	; 3482D
push ebp	; 3482E
sub esp, 7D0h	; 3482F
push eax	; 34835
mov edi, edx	; 34836
mov ebp, ebx	; 34838
mov dword [dword esp+0780h], 0FFFFFFFFh	; 3483A
xor ebx, ebx	; 34845
mov dword [dword esp+07B0h], ebx	; 34847
mov dword [dword esp+079Ch], 0C0h	; 3484E
mov dword [dword esp+07A4h], 0Ch	; 34859
mov dword [dword esp+07A0h], 67h	; 34864
call sub_B4BA8	; 3486F
push byte 0	; 34874
call sub_B392C	; 34876
add esp, byte 4	; 3487B
cmp byte [musicon], 0	; 3487E
je short .1	; 34885
cmp dword [songdata], byte 0	; 34887
je short .1	; 3488E
mov eax, dword [musichandle]	; 34890
mov ebx, 64h	; 34895
mov edx, 3	; 3489A
call sub_8FCDF	; 3489F
.1:
push savepal	; 348A4
push dword 100h	; 348A9
push byte 0	; 348AE
call sub_8FFB0	; 348B0
add esp, byte 0Ch	; 348B5
mov ebx, 10h	; 348B8
mov edx, savepal	; 348BD
mov eax, 1	; 348C2
call FadePalStep	; 348C7
cmp byte [musicon], 0	; 348CC
je short .3	; 348D3
cmp dword [songdata], byte 0	; 348D5
je short .3	; 348DC
.2:
mov eax, dword [musicslot-3]	; 348DE
sar eax, 18h	; 348E3
mov edx, 3	; 348E6
call sub_8FC8A	; 348EB
test eax, eax	; 348F0
je short CalendarScreen.2	; 348F2
mov ecx, dword [songdata]	; 348F4
push ecx	; 348FA
call sub_8D2F0	; 348FB
add esp, byte 4	; 34900
xor esi, esi	; 34903
mov dword [songdata], esi	; 34905
.3:
call ShowLoadingScreen	; 3490B
mov dword [teamstatscb], CalTeamStatsScreen	; 34910
mov dword [skaterstatscb], CalSkaterStatsScreen	; 3491A
mov dword [goaliestatscb], CalGoalieStatsScreen	; 34924
mov dword [standingscb], CalStandingsScreen	; 3492E
mov dword [standingsmenucb], CalStandingsMenu	; 34938
push dword 0FFh	; 34942
mov ecx, 0C0h	; 34947
mov ebx, 67h	; 3494C
mov edx, ecx	; 34951
mov eax, 0Ch	; 34953
call SetDialogColors	; 34958
xor edx, edx	; 3495D
mov word [dword esp+07B8h], dx	; 3495F
mov dword [calsel], 0FFFFFFFFh	; 34967
xor edx, edx	; 34971
mov dword [calexit], edx	; 34973
mov dword [dword_DDD2C], edx	; 34979
mov eax, dword [mainfont]	; 3497F
mov dword [dword esp+07ACh], eax	; 34984
xor ecx, ecx	; 3498B
mov ebx, str_Calendar	; 3498D
cmp byte [fileoncd+01C1h], 1	; 34992
jne short .4	; 34999
mov edx, dword [cddriveptr]	; 3499B
jmp short .5	; 349A1
.4:
xor edx, edx	; 349A3
.5:
lea eax, [dword esp+06F8h]	; 349A5
call MakePath	; 349AC
push byte 20h	; 349B1
lea eax, [dword esp+06FCh]	; 349B3
push eax	; 349BA
call sub_8E83C	; 349BB
add esp, byte 8	; 349C0
mov dword [calendarshapes], eax	; 349C3
xor ecx, ecx	; 349C8
mov ebx, str_Callogo	; 349CA
cmp byte [fileoncd+01C2h], 1	; 349CF
jne short .6	; 349D6
mov edx, dword [cddriveptr]	; 349D8
jmp short .7	; 349DE
.6:
xor edx, edx	; 349E0
.7:
lea eax, [dword esp+06F8h]	; 349E2
call MakePath	; 349E9
push byte 20h	; 349EE
lea eax, [dword esp+06FCh]	; 349F0
push eax	; 349F7
call sub_8E83C	; 349F8
add esp, byte 8	; 349FD
mov dword [dword esp+078Ch], eax	; 34A00
xor ebx, ebx	; 34A07
mov word [dword esp+07CCh], bx	; 34A09
jmp short .9	; 34A11
.8:
mov eax, dword [dword esp+07CAh]	; 34A13
sar eax, 10h	; 34A1A
mov dl, byte [dword esp+07CCh]	; 34A1D
mov byte [byte esp+eax+04h], dl	; 34A24
mov eax, ecx	; 34A28
inc eax	; 34A2A
mov word [dword esp+07CCh], ax	; 34A2B
.9:
mov ecx, dword [dword esp+07CCh]	; 34A33
cmp cx, 100h	; 34A3A
jl short CalendarScreen.8	; 34A3F
lea eax, [byte esp+04h]	; 34A41
push eax	; 34A45
call sub_B4DD4	; 34A46
add esp, byte 4	; 34A4B
xor esi, esi	; 34A4E
mov word [dword esp+07CCh], si	; 34A50
jmp short .11	; 34A58
.10:
mov esi, dword [dword esp+07CAh]	; 34A5A
sar esi, 10h	; 34A61
mov eax, dword [nosplit esi*4+crestnames]	; 34A64
push eax	; 34A6B
mov edx, dword [dword esp+0790h]	; 34A6C
push edx	; 34A73
call sub_B30B4	; 34A74
add esp, byte 8	; 34A79
mov dword [dword esp+esi*4+0690h], eax	; 34A7C
inc word [dword esp+07CCh]	; 34A83
.11:
cmp word [dword esp+07CCh], byte 1Ah	; 34A8B
jl short CalendarScreen.10	; 34A94
mov ebx, dword [leaguedbnames+18h]	; 34A96
mov ecx, edi	; 34A9C
mov edx, dword [esp]	; 34A9E
lea eax, [dword esp+06F8h]	; 34AA1
call MakePath	; 34AA8
lea edx, [dword esp+0780h]	; 34AAD
lea eax, [dword esp+06F8h]	; 34AB4
call FileOpenRead	; 34ABB
mov esi, eax	; 34AC0
test ax, ax	; 34AC2
jne short .12	; 34AC5
mov ecx, 2	; 34AC7
xor ebx, ebx	; 34ACC
lea edx, [dword esp+07C0h]	; 34ACE
mov eax, dword [dword esp+0780h]	; 34AD5
call FileReadAt	; 34ADC
mov esi, eax	; 34AE1
.12:
test si, si	; 34AE3
jne near .22	; 34AE6
mov dword [calmonth], 0FFFFFFFFh	; 34AEC
mov edi, 5	; 34AF6
mov ebx, 0FFFFFFFFh	; 34AFB
mov dword [dword esp+07BCh], ebx	; 34B00
mov word [dword esp+07C4h], bx	; 34B07
mov word [dword esp+07CCh], si	; 34B0F
jmp near .20	; 34B17
.13:
mov ebx, dword [dword esp+07CAh]	; 34B1C
sar ebx, 10h	; 34B23
mov eax, dword [dword esp+07B6h]	; 34B26
sar eax, 10h	; 34B2D
mov ecx, eax	; 34B30
shl ecx, 2	; 34B32
sub ecx, eax	; 34B35
add ecx, ecx	; 34B37
lea edx, [dword esp+0304h]	; 34B39
add edx, ecx	; 34B40
mov eax, dword [dword esp+0780h]	; 34B42
call ReadSchedGame	; 34B49
mov esi, eax	; 34B4E
test ax, ax	; 34B50
jne near .19	; 34B53
mov eax, dword [dword esp+07CCh]	; 34B59
cmp ax, word [dword esp+07C0h]	; 34B60
jne near .16	; 34B68
cmp byte [dword esp+ecx+0306h], 0FFh	; 34B6E
je short .14	; 34B76
cmp byte [dword esp+ecx+0307h], 0FFh	; 34B78
je short .14	; 34B80
movzx di, byte [dword esp+ecx+0304h]	; 34B82
dec edi	; 34B8B
xor eax, eax	; 34B8C
mov al, byte [dword esp+ecx+0304h]	; 34B8E
mov dword [calselmonth], eax	; 34B95
xor eax, eax	; 34B9A
mov al, byte [dword esp+ecx+0305h]	; 34B9C
jmp short .15	; 34BA3
.14:
mov ebx, dword [dword esp+07B6h]	; 34BA5
sar ebx, 10h	; 34BAC
lea edx, [byte ebx-01h]	; 34BAF
mov eax, edx	; 34BB2
shl eax, 2	; 34BB4
sub eax, edx	; 34BB7
movzx di, byte [dword esp+eax*2+0304h]	; 34BB9
dec edi	; 34BC2
mov eax, ebx	; 34BC3
shl eax, 2	; 34BC5
sub eax, ebx	; 34BC8
xor edx, edx	; 34BCA
mov dl, byte [dword esp+eax*2+0304h]	; 34BCC
mov dword [calselmonth], edx	; 34BD3
mov al, byte [dword esp+eax*2+0305h]	; 34BD9
and eax, 0FFh	; 34BE0
.15:
mov dword [calselday], eax	; 34BE5
.16:
mov edx, dword [dword esp+07B6h]	; 34BEA
sar edx, 10h	; 34BF1
mov eax, edx	; 34BF4
shl eax, 2	; 34BF6
sub eax, edx	; 34BF9
add eax, eax	; 34BFB
xor edx, edx	; 34BFD
mov dl, byte [dword esp+eax+0306h]	; 34BFF
cmp edx, ebp	; 34C06
je short .17	; 34C08
mov al, byte [dword esp+eax+0307h]	; 34C0A
and eax, 0FFh	; 34C11
cmp eax, ebp	; 34C16
jne near .19	; 34C18
.17:
mov edx, dword [dword esp+07B6h]	; 34C1E
sar edx, 10h	; 34C25
mov eax, edx	; 34C28
shl eax, 2	; 34C2A
sub eax, edx	; 34C2D
add eax, eax	; 34C2F
mov dh, byte [dword esp+eax+0304h]	; 34C31
cmp dh, 0FFh	; 34C38
je near .19	; 34C3B
cmp byte [dword esp+eax+0305h], 0FFh	; 34C41
je short .19	; 34C49
mov bh, byte [dword esp+eax+0308h]	; 34C4B
cmp bh, 0FFh	; 34C52
jne short .18	; 34C55
cmp bh, byte [dword esp+eax+0309h]	; 34C57
jne short .18	; 34C5E
cmp dword [calmonth], byte 0	; 34C60
jge short .18	; 34C67
mov al, dh	; 34C69
and eax, 0FFh	; 34C6B
dec eax	; 34C70
mov dword [calmonth], eax	; 34C71
mov eax, dword [dword esp+07CCh]	; 34C76
mov dword [dword esp+07BCh], eax	; 34C7D
mov eax, dword [dword esp+07B8h]	; 34C84
mov word [dword esp+07C4h], ax	; 34C8B
.18:
mov eax, dword [dword esp+07B6h]	; 34C93
sar eax, 10h	; 34C9A
mov edx, dword [dword esp+07CCh]	; 34C9D
mov word [dword esp+eax*2+05ACh], dx	; 34CA4
inc word [dword esp+07B8h]	; 34CAC
.19:
inc word [dword esp+07CCh]	; 34CB4
.20:
cmp word [dword esp+07CCh], 4ADh	; 34CBC
jge short .21	; 34CC6
test si, si	; 34CC8
je near CalendarScreen.13	; 34CCB
.21:
cmp dword [calmonth], byte 0	; 34CD1
jge short .22	; 34CD8
movsx eax, di	; 34CDA
mov dword [calmonth], eax	; 34CDD
.22:
test si, si	; 34CE2
je short .23	; 34CE5
call FadeOutPalCycle	; 34CE7
.23:
lea eax, [dword esp+0780h]	; 34CEC
call FileClose	; 34CF3
cmp word [dword esp+07BCh], byte 0	; 34CF8
jl short .24	; 34D01
test si, si	; 34D03
jne short .24	; 34D06
mov ecx, dword [dword esp+07C2h]	; 34D08
sar ecx, 10h	; 34D0F
mov ebx, ecx	; 34D12
lea edx, [dword esp+0304h]	; 34D14
mov eax, ebp	; 34D1B
call SetGameSides	; 34D1D
mov edx, ecx	; 34D22
mov eax, ecx	; 34D24
shl eax, 2	; 34D26
sub eax, ecx	; 34D29
xor edx, ecx	; 34D2B
mov dl, byte [dword esp+eax*2+0304h]	; 34D2D
mov dword [calselmonth], edx	; 34D34
mov al, byte [dword esp+eax*2+0305h]	; 34D3A
and eax, 0FFh	; 34D41
mov dword [calselday], eax	; 34D46
mov eax, dword [dword esp+ecx*2+05AAh]	; 34D4B
sar eax, 10h	; 34D52
mov dword [calsel], eax	; 34D55
.24:
test si, si	; 34D5A
jne near .83	; 34D5D
cmp dword [calmonth], byte 5	; 34D63
jne short .25	; 34D6A
xor eax, eax	; 34D6C
mov dword [calnextslot], eax	; 34D6E
jmp short .26	; 34D73
.25:
mov dword [calnextslot], CalNextMonth	; 34D75
.26:
cmp dword [calmonth], byte 9	; 34D7F
jne short .27	; 34D86
xor ecx, ecx	; 34D88
mov dword [calprevslot], ecx	; 34D8A
jmp short .28	; 34D90
.27:
mov dword [calprevslot], CalPrevMonth	; 34D92
.28:
mov ax, word [calmonth]	; 34D9C
mov word [dword esp+07D0h], ax	; 34DA2
call sub_B4BA8	; 34DAA
mov esi, calmenubar	; 34DAF
mov dword [dword esp+0730h], esi	; 34DB4
mov edi, 3	; 34DBB
mov dword [dword esp+0748h], edi	; 34DC0
xor eax, eax	; 34DC7
mov dword [dword esp+0734h], eax	; 34DC9
mov dword [dword esp+073Ch], eax	; 34DD0
mov dword [dword esp+0740h], eax	; 34DD7
mov dword [dword esp+0754h], eax	; 34DDE
mov dword [dword esp+0758h], eax	; 34DE5
mov dword [dword esp+0718h], eax	; 34DEC
mov dword [dword esp+071Ch], eax	; 34DF3
call FadeOutPalCycle	; 34DFA
call sub_B4BA8	; 34DFF
mov edx, dword [dword esp+07A0h]	; 34E04
push edx	; 34E0B
mov ecx, dword [dword esp+07A8h]	; 34E0C
mov ebx, dword [dword esp+07A0h]	; 34E13
mov edx, edi	; 34E1A
mov eax, esi	; 34E1C
call DrawMenuBar	; 34E1E
mov ebx, dword [calendarshapes]	; 34E23
push ebx	; 34E29
mov ecx, dword [dword esp+07B0h]	; 34E2A
push ecx	; 34E31
push ebp	; 34E32
mov eax, dword [dword esp+07C2h]	; 34E33
sar eax, 10h	; 34E3A
push eax	; 34E3D
mov eax, dword [calmonth]	; 34E3E
lea ecx, [dword esp+0314h]	; 34E43
mov ebx, dword [dword esp+07B8h]	; 34E4A
lea edx, [dword esp+06A0h]	; 34E51
call DrawCalendarDay	; 34E58
cmp byte [musicon], 0	; 34E5D
je short .31	; 34E64
cmp dword [songdata], byte 0	; 34E66
jne short .31	; 34E6D
mov ecx, str_Iff9	; 34E6F
mov ebx, str_Calendar	; 34E74
cmp byte [fileoncd+01E2h], 1	; 34E79
jne short .29	; 34E80
mov edx, dword [cddriveptr]	; 34E82
jmp short .30	; 34E88
.29:
xor edx, edx	; 34E8A
.30:
lea eax, [dword esp+06F8h]	; 34E8C
call MakePath	; 34E93
lea eax, [dword esp+06F8h]	; 34E98
call sub_8F98F	; 34E9F
mov dword [songdata], eax	; 34EA4
test eax, eax	; 34EA9
je short .31	; 34EAB
test byte [gameopts], 40h	; 34EAD
je short .31	; 34EB4
mov edx, dword [musichandle]	; 34EB6
mov ecx, 4Ch	; 34EBC
mov ebx, 3	; 34EC1
call sub_8FB8E	; 34EC6
.31:
mov eax, dword [calendarshapes]	; 34ECB
call ApplyShapePalette	; 34ED0
mov eax, dword [pointerspr]	; 34ED5
mov edx, dword [byte eax+02h]	; 34EDA
sar edx, 10h	; 34EDD
shl edx, 2	; 34EE0
mov eax, dword [byte eax+04h]	; 34EE3
sar eax, 10h	; 34EE6
inc eax	; 34EE9
add edx, byte 4	; 34EEA
imul eax, edx	; 34EED
add eax, byte 11h	; 34EF0
push byte 20h	; 34EF3
push eax	; 34EF5
push str_Pointer8	; 34EF6
call sub_8CCA8	; 34EFB
mov dword [dword esp+0794h], eax	; 34F00
add esp, byte 0Ch	; 34F07
mov dword [dword esp+0794h], eax	; 34F0A
mov esi, dword [pointerspr]	; 34F11
mov edi, eax	; 34F17
movsd	; 34F19
movsd	; 34F1A
movsd	; 34F1B
movsd	; 34F1C
movsb	; 34F1D
mov eax, dword [pointerspr]	; 34F1E
mov ax, word [byte eax+04h]	; 34F23
inc eax	; 34F27
mov edx, dword [dword esp+0788h]	; 34F28
mov word [byte edx+04h], ax	; 34F2F
mov eax, dword [pointerspr]	; 34F33
mov ax, word [byte eax+06h]	; 34F38
inc eax	; 34F3C
mov word [byte edx+06h], ax	; 34F3D
lea eax, [dword esp+0774h]	; 34F41
push eax	; 34F48
lea eax, [dword esp+077Ch]	; 34F49
push eax	; 34F50
lea eax, [dword esp+0784h]	; 34F51
push eax	; 34F58
call sub_B2DCA	; 34F59
add esp, byte 0Ch	; 34F5E
mov eax, dword [dword esp+0778h]	; 34F61
mov dword [dword esp+0770h], eax	; 34F68
mov eax, dword [dword esp+0774h]	; 34F6F
mov dword [dword esp+076Ch], eax	; 34F76
push eax	; 34F7D
mov eax, dword [dword esp+077Ch]	; 34F7E
push eax	; 34F85
mov edx, dword [dword esp+0790h]	; 34F86
push edx	; 34F8D
call sub_91400	; 34F8E
add esp, byte 0Ch	; 34F93
mov ebx, dword [dword esp+0774h]	; 34F96
push ebx	; 34F9D
mov ecx, dword [dword esp+077Ch]	; 34F9E
push ecx	; 34FA5
mov esi, dword [pointerspr]	; 34FA6
push esi	; 34FAC
call sub_91370	; 34FAD
add esp, byte 0Ch	; 34FB2
call ClearInputQueue	; 34FB5
.32:
xor ecx, ecx	; 34FBA
.33:
call GetInputEvent	; 34FBC
mov esi, eax	; 34FC1
test eax, eax	; 34FC3
je short .34	; 34FC5
lea ebx, [dword esp+076Ch]	; 34FC7
lea edx, [dword esp+0770h]	; 34FCE
call dword [ptrupdatefn]	; 34FD5
mov ecx, eax	; 34FDB
.34:
test esi, esi	; 34FDD
je short .35	; 34FDF
test cl, 2	; 34FE1
je short CalendarScreen.33	; 34FE4
.35:
test cl, 2	; 34FE6
jne short .37	; 34FE9
mov eax, dword [dword esp+0770h]	; 34FEB
cmp eax, dword [dword esp+0778h]	; 34FF2
jne short .36	; 34FF9
mov eax, dword [dword esp+076Ch]	; 34FFB
cmp eax, dword [dword esp+0774h]	; 35002
je near .82	; 35009
.36:
mov ebx, dword [dword esp+0774h]	; 3500F
push ebx	; 35016
mov ecx, dword [dword esp+077Ch]	; 35017
push ecx	; 3501E
mov esi, dword [dword esp+079Ch]	; 3501F
push esi	; 35026
call sub_903F0	; 35027
add esp, byte 0Ch	; 3502C
mov edi, dword [dword esp+076Ch]	; 3502F
push edi	; 35036
mov eax, dword [dword esp+0774h]	; 35037
push eax	; 3503E
push esi	; 3503F
call sub_91400	; 35040
add esp, byte 0Ch	; 35045
mov ebx, dword [dword esp+076Ch]	; 35048
push ebx	; 3504F
mov ecx, dword [dword esp+0774h]	; 35050
push ecx	; 35057
mov esi, dword [pointerspr]	; 35058
push esi	; 3505E
jmp near .80	; 3505F
.37:
lea eax, [dword esp+0764h]	; 35064
push eax	; 3506B
lea eax, [dword esp+076Ch]	; 3506C
push eax	; 35073
lea eax, [dword esp+0720h]	; 35074
push eax	; 3507B
lea eax, [dword esp+0754h]	; 3507C
push eax	; 35083
mov ecx, dword [dword esp+07C0h]	; 35084
lea ebx, [dword esp+0740h]	; 3508B
mov edx, dword [dword esp+077Ch]	; 35092
mov eax, dword [dword esp+0780h]	; 35099
call MenuHitTest	; 350A0
test eax, eax	; 350A5
je near .65	; 350A7
mov edx, dword [dword esp+0768h]	; 350AD
shl edx, 2	; 350B4
mov eax, dword [dword esp+0764h]	; 350B7
shl eax, 5	; 350BE
mov ebx, dword [dword esp+edx+0730h]	; 350C1
add eax, ebx	; 350C8
cmp dword [byte eax+014h], byte 0	; 350CA
je near .50	; 350CE
mov eax, dword [dword esp+0764h]	; 350D4
cmp eax, dword [dword esp+edx+0754h]	; 350DB
jne near .45	; 350E2
mov ebx, dword [dword esp+0774h]	; 350E8
push ebx	; 350EF
mov ecx, dword [dword esp+077Ch]	; 350F0
push ecx	; 350F7
mov esi, dword [dword esp+079Ch]	; 350F8
push esi	; 350FF
call sub_903F0	; 35100
add esp, byte 0Ch	; 35105
mov eax, dword [dword esp+07B0h]	; 35108
mov word [dword esp+07CCh], ax	; 3510F
jmp short .40	; 35117
.38:
mov esi, dword [dword esp+07CAh]	; 35119
sar esi, 10h	; 35120
mov edi, esi	; 35123
shl edi, 2	; 35125
mov eax, dword [dword esp+edi+073Ch]	; 35128
test eax, eax	; 3512F
je short .39	; 35131
mov edx, dword [dword esp+esi*8+071Ch]	; 35133
push edx	; 3513A
mov ebx, dword [dword esp+esi*8+071Ch]	; 3513B
push ebx	; 35142
push eax	; 35143
call sub_903F0	; 35144
add esp, byte 0Ch	; 35149
xor eax, eax	; 3514C
mov dword [dword esp+esi*8+0718h], eax	; 3514E
mov dword [dword esp+esi*8+071Ch], eax	; 35155
mov ebx, dword [dword esp+edi+073Ch]	; 3515C
push ebx	; 35163
call FreeMemBlock	; 35164
add esp, byte 4	; 35169
.39:
dec word [dword esp+07CCh]	; 3516C
.40:
cmp word [dword esp+07CCh], byte 0	; 35174
jge short CalendarScreen.38	; 3517D
xor esi, esi	; 3517F
mov dword [dword esp+07B0h], esi	; 35181
mov eax, dword [dword esp+0768h]	; 35188
mov edx, dword [dword esp+0764h]	; 3518F
shl edx, 5	; 35196
mov eax, dword [dword esp+eax*4+0730h]	; 35199
call dword [byte edx+eax+014h]	; 351A0
mov esi, eax	; 351A4
lea eax, [byte esp+04h]	; 351A6
push eax	; 351AA
call sub_B4DD4	; 351AB
add esp, byte 4	; 351B0
xor edi, edi	; 351B3
mov dword [dword esp+0734h], edi	; 351B5
mov dword [dword esp+073Ch], edi	; 351BC
mov dword [dword esp+0740h], edi	; 351C3
mov dword [dword esp+0758h], edi	; 351CA
mov dword [dword esp+074Ch], edi	; 351D1
cmp esi, byte 1	; 351D8
jne short .42	; 351DB
mov esi, dword [dword esp+0794h]	; 351DD
push esi	; 351E4
call FreeMemBlock	; 351E5
add esp, byte 4	; 351EA
cmp byte [musicon], 0	; 351ED
je short .41	; 351F4
cmp dword [songdata], byte 0	; 351F6
je short .41	; 351FD
mov eax, dword [musichandle]	; 351FF
mov ebx, 64h	; 35204
mov edx, 3	; 35209
call sub_8FCDF	; 3520E
.41:
xor eax, eax	; 35213
jmp near .x	; 35215
.42:
mov esi, dword [dword esp+0774h]	; 3521A
push esi	; 35221
mov edi, dword [dword esp+077Ch]	; 35222
push edi	; 35229
call MouseSetPos	; 3522A
add esp, byte 8	; 3522F
mov eax, dword [dword esp+0778h]	; 35232
mov dword [dword esp+0770h], eax	; 35239
mov eax, dword [dword esp+0774h]	; 35240
mov dword [dword esp+076Ch], eax	; 35247
call ClearInputQueue	; 3524E
mov eax, dword [dword esp+07CEh]	; 35253
sar eax, 10h	; 3525A
cmp eax, dword [calmonth]	; 3525D
je short .43	; 35263
call sub_B4BA8	; 35265
mov ebx, dword [dword esp+07A0h]	; 3526A
push ebx	; 35271
mov ecx, dword [dword esp+07A8h]	; 35272
mov ebx, dword [dword esp+07A0h]	; 35279
mov edx, 3	; 35280
mov eax, calmenubar	; 35285
call DrawMenuBar	; 3528A
mov ecx, dword [calendarshapes]	; 3528F
push ecx	; 35295
mov esi, dword [dword esp+07B0h]	; 35296
push esi	; 3529D
push ebp	; 3529E
mov eax, dword [dword esp+07C2h]	; 3529F
sar eax, 10h	; 352A6
push eax	; 352A9
mov eax, dword [calmonth]	; 352AA
lea ecx, [dword esp+0314h]	; 352AF
mov ebx, dword [dword esp+07B8h]	; 352B6
lea edx, [dword esp+06A0h]	; 352BD
call DrawCalendarDay	; 352C4
.43:
cmp dword [dword_DDD2C], byte 0	; 352C9
je short .44	; 352D0
call sub_B4BA8	; 352D2
mov eax, dword [dword esp+07A0h]	; 352D7
push eax	; 352DE
mov ecx, dword [dword esp+07A8h]	; 352DF
mov ebx, dword [dword esp+07A0h]	; 352E6
mov edx, 3	; 352ED
mov eax, calmenubar	; 352F2
call DrawMenuBar	; 352F7
mov edx, dword [calendarshapes]	; 352FC
push edx	; 35302
mov ebx, dword [dword esp+07B0h]	; 35303
push ebx	; 3530A
push ebp	; 3530B
mov eax, dword [dword esp+07C2h]	; 3530C
sar eax, 10h	; 35313
push eax	; 35316
mov eax, dword [calmonth]	; 35317
lea ecx, [dword esp+0314h]	; 3531C
mov ebx, dword [dword esp+07B8h]	; 35323
lea edx, [dword esp+06A0h]	; 3532A
call DrawCalendarDay	; 35331
mov eax, dword [calendarshapes]	; 35336
call ApplyShapePalette	; 3533B
xor ecx, ecx	; 35340
mov dword [dword_DDD2C], ecx	; 35342
.44:
mov ax, word [calmonth]	; 35348
mov word [dword esp+07D0h], ax	; 3534E
jmp near .79	; 35356
.45:
mov ecx, dword [dword esp+0774h]	; 3535B
push ecx	; 35362
mov esi, dword [dword esp+077Ch]	; 35363
push esi	; 3536A
mov edi, dword [dword esp+079Ch]	; 3536B
push edi	; 35372
call sub_903F0	; 35373
add esp, byte 0Ch	; 35378
mov eax, dword [dword esp+07B0h]	; 3537B
cmp eax, dword [dword esp+0768h]	; 35382
je near .49	; 35389
mov eax, dword [dword esp+07B0h]	; 3538F
mov word [dword esp+07CCh], ax	; 35396
jmp short .48	; 3539E
.46:
mov esi, edi	; 353A0
shl esi, 2	; 353A2
xor ecx, ecx	; 353A5
mov dword [dword esp+esi+0754h], ecx	; 353A7
mov eax, dword [dword esp+esi+073Ch]	; 353AE
test eax, eax	; 353B5
je short .47	; 353B7
mov edx, dword [dword esp+edi*8+071Ch]	; 353B9
push edx	; 353C0
mov ebx, dword [dword esp+edi*8+071Ch]	; 353C1
push ebx	; 353C8
push eax	; 353C9
call sub_903F0	; 353CA
add esp, byte 0Ch	; 353CF
xor eax, eax	; 353D2
mov dword [dword esp+edi*8+071Ch], eax	; 353D4
mov dword [dword esp+edi*8+0718h], eax	; 353DB
mov edx, dword [dword esp+esi+073Ch]	; 353E2
push edx	; 353E9
call FreeMemBlock	; 353EA
add esp, byte 4	; 353EF
xor ebx, ebx	; 353F2
mov dword [dword esp+esi+073Ch], ebx	; 353F4
mov dword [dword esp+esi+0730h], ebx	; 353FB
mov dword [dword esp+esi+0748h], ebx	; 35402
.47:
dec word [dword esp+07CCh]	; 35409
.48:
mov edi, dword [dword esp+07CAh]	; 35411
sar edi, 10h	; 35418
mov ebx, dword [dword esp+0768h]	; 3541B
cmp edi, ebx	; 35422
jg near CalendarScreen.46	; 35424
mov dword [dword esp+07B0h], ebx	; 3542A
.49:
mov eax, dword [dword esp+07A0h]	; 35431
push eax	; 35438
mov edx, dword [dword esp+07A8h]	; 35439
push edx	; 35440
mov eax, dword [dword esp+0770h]	; 35441
mov ebx, dword [dword esp+eax*8+0724h]	; 35448
mov edx, dword [dword esp+eax*8+0720h]	; 3544F
mov ecx, dword [dword esp+eax*4+075Ch]	; 35456
shl ecx, 5	; 3545D
mov eax, dword [dword esp+eax*4+0738h]	; 35460
add eax, ecx	; 35467
mov ecx, dword [dword esp+07A4h]	; 35469
call DrawMenuItemSel	; 35470
mov edx, dword [dword esp+0768h]	; 35475
mov eax, dword [dword esp+0764h]	; 3547C
mov dword [dword esp+edx*4+0754h], eax	; 35483
mov ebx, dword [dword esp+07A0h]	; 3548A
push ebx	; 35491
mov ecx, dword [dword esp+07A8h]	; 35492
push ecx	; 35499
mov ebx, dword [dword esp+edx*8+0724h]	; 3549A
mov eax, dword [dword esp+edx*8+0720h]	; 354A1
mov esi, dword [dword esp+edx*4+075Ch]	; 354A8
shl esi, 5	; 354AF
mov edx, dword [dword esp+edx*4+0738h]	; 354B2
add esi, edx	; 354B9
mov ecx, dword [dword esp+07A4h]	; 354BB
mov edx, eax	; 354C2
mov eax, esi	; 354C4
jmp near .64	; 354C6
.50:
cmp dword [byte eax+018h], byte 0	; 354CB
je near .59	; 354CF
mov ebx, dword [dword esp+0774h]	; 354D5
push ebx	; 354DC
mov ecx, dword [dword esp+077Ch]	; 354DD
push ecx	; 354E4
mov esi, dword [dword esp+079Ch]	; 354E5
push esi	; 354EC
call sub_903F0	; 354ED
add esp, byte 0Ch	; 354F2
mov eax, dword [dword esp+07B0h]	; 354F5
cmp eax, dword [dword esp+0768h]	; 354FC
je near .54	; 35503
mov eax, dword [dword esp+07B0h]	; 35509
mov word [dword esp+07CCh], ax	; 35510
jmp short .53	; 35518
.51:
mov esi, edi	; 3551A
shl esi, 2	; 3551C
xor ebx, ebx	; 3551F
mov dword [dword esp+esi+0754h], ebx	; 35521
mov ecx, dword [dword esp+esi+073Ch]	; 35528
test ecx, ecx	; 3552F
je short .52	; 35531
mov eax, dword [dword esp+edi*8+071Ch]	; 35533
push eax	; 3553A
mov edx, dword [dword esp+edi*8+071Ch]	; 3553B
push edx	; 35542
push ecx	; 35543
call sub_903F0	; 35544
add esp, byte 0Ch	; 35549
xor ecx, ecx	; 3554C
mov dword [dword esp+edi*8+0718h], ecx	; 3554E
mov dword [dword esp+edi*8+071Ch], ecx	; 35555
mov edx, dword [dword esp+esi+073Ch]	; 3555C
push edx	; 35563
call FreeMemBlock	; 35564
add esp, byte 4	; 35569
xor ebx, ebx	; 3556C
mov dword [dword esp+esi+073Ch], ebx	; 3556E
mov dword [dword esp+esi+0730h], ebx	; 35575
mov dword [dword esp+esi+0748h], ebx	; 3557C
.52:
dec word [dword esp+07CCh]	; 35583
.53:
mov edi, dword [dword esp+07CAh]	; 3558B
sar edi, 10h	; 35592
mov edx, dword [dword esp+0768h]	; 35595
cmp edi, edx	; 3559C
jg near CalendarScreen.51	; 3559E
mov dword [dword esp+07B0h], edx	; 355A4
.54:
mov eax, dword [dword esp+07A0h]	; 355AB
push eax	; 355B2
mov edx, dword [dword esp+07A8h]	; 355B3
push edx	; 355BA
mov edi, dword [dword esp+07B8h]	; 355BB
mov ebx, dword [dword esp+edi*8+0724h]	; 355C2
mov edx, dword [dword esp+edi*8+0720h]	; 355C9
mov eax, dword [dword esp+edi*4+075Ch]	; 355D0
shl eax, 5	; 355D7
mov ecx, dword [dword esp+edi*4+0738h]	; 355DA
add eax, ecx	; 355E1
mov ecx, dword [dword esp+07A4h]	; 355E3
call DrawMenuItemSel	; 355EA
mov eax, dword [dword esp+0764h]	; 355EF
mov dword [dword esp+edi*4+0754h], eax	; 355F6
mov eax, dword [dword esp+07A0h]	; 355FD
push eax	; 35604
mov edx, dword [dword esp+07A8h]	; 35605
push edx	; 3560C
mov ebx, dword [dword esp+edi*8+0724h]	; 3560D
mov edx, dword [dword esp+edi*8+0720h]	; 35614
mov eax, dword [dword esp+076Ch]	; 3561B
shl eax, 5	; 35622
mov ecx, dword [dword esp+edi*4+0738h]	; 35625
add eax, ecx	; 3562C
mov ecx, dword [dword esp+07A4h]	; 3562E
call DrawMenuItemNorm	; 35635
mov eax, dword [dword esp+0768h]	; 3563A
mov ecx, dword [dword esp+0764h]	; 35641
shl ecx, 5	; 35648
mov ebx, dword [dword esp+eax*4+0730h]	; 3564B
lea esi, [byte edi+01h]	; 35652
mov dword [dword esp+07B0h], esi	; 35655
mov ebx, dword [byte ecx+ebx+018h]	; 3565C
mov dword [dword esp+esi*4+0730h], ebx	; 35660
mov eax, dword [dword esp+eax*4+0730h]	; 35667
add eax, ecx	; 3566E
mov ebx, dword [byte eax+01Ch]	; 35670
mov dword [dword esp+esi*4+0748h], ebx	; 35673
cmp esi, byte 1	; 3567A
je short .55	; 3567D
mov edx, dword [byte eax+08h]	; 3567F
jmp short .56	; 35682
.55:
mov edx, dword [eax]	; 35684
.56:
mov eax, dword [dword esp+07B0h]	; 35686
mov ebx, dword [dword esp+eax*8+0710h]	; 3568D
add edx, ebx	; 35694
mov dword [dword esp+eax*8+0718h], edx	; 35696
mov edx, dword [dword esp+0764h]	; 3569D
shl edx, 5	; 356A4
mov eax, dword [dword esp+0768h]	; 356A7
shl eax, 2	; 356AE
cmp dword [dword esp+07B0h], byte 1	; 356B1
je short .57	; 356B9
mov eax, dword [dword esp+eax+0730h]	; 356BB
mov eax, dword [byte edx+eax+04h]	; 356C2
jmp short .58	; 356C6
.57:
mov eax, dword [dword esp+eax+0730h]	; 356C8
mov eax, dword [byte edx+eax+0Ch]	; 356CF
.58:
mov edx, dword [dword esp+07B0h]	; 356D3
shl edx, 3	; 356DA
mov dword [dword esp+0790h], edx	; 356DD
mov esi, dword [dword esp+edx+0714h]	; 356E4
add eax, esi	; 356EB
mov dword [dword esp+edx+071Ch], eax	; 356ED
mov eax, dword [dword esp+07B0h]	; 356F4
shl eax, 2	; 356FB
mov dword [dword esp+0798h], eax	; 356FE
mov edx, dword [dword esp+eax+0748h]	; 35705
shl edx, 5	; 3570C
mov eax, dword [dword esp+eax+0730h]	; 3570F
mov ebx, dword [byte edx+eax-018h]	; 35716
sub ebx, dword [eax]	; 3571A
inc ebx	; 3571C
mov dword [dword esp+0760h], ebx	; 3571D
mov edx, dword [byte edx+eax-014h]	; 35724
sub edx, dword [byte eax+04h]	; 35728
inc edx	; 3572B
mov dword [dword esp+0784h], edx	; 3572C
push byte 20h	; 35733
mov eax, dword [dword esp+0764h]	; 35735
shl eax, 2	; 3573C
imul eax, edx	; 3573F
add eax, byte 11h	; 35742
push eax	; 35745
push str_Menubuff5	; 35746
call sub_8CCA8	; 3574B
add esp, byte 0Ch	; 35750
mov edx, dword [dword esp+0798h]	; 35753
mov dword [dword esp+edx+073Ch], eax	; 3575A
mov esi, dword [pointerspr]	; 35761
mov edi, eax	; 35767
movsd	; 35769
movsd	; 3576A
movsd	; 3576B
movsd	; 3576C
movsb	; 3576D
mov eax, dword [dword esp+edx+073Ch]	; 3576E
mov edx, dword [dword esp+0760h]	; 35775
mov word [byte eax+04h], dx	; 3577C
mov eax, dword [dword esp+0798h]	; 35780
mov eax, dword [dword esp+eax+073Ch]	; 35787
mov edx, dword [dword esp+0784h]	; 3578E
mov word [byte eax+06h], dx	; 35795
mov eax, dword [dword esp+0790h]	; 35799
mov esi, dword [dword esp+eax+071Ch]	; 357A0
push esi	; 357A7
mov edi, dword [dword esp+eax+071Ch]	; 357A8
push edi	; 357AF
mov eax, dword [dword esp+07A0h]	; 357B0
mov edx, dword [dword esp+eax+0744h]	; 357B7
push edx	; 357BE
call sub_91400	; 357BF
add esp, byte 0Ch	; 357C4
mov ebx, dword [dword esp+07A0h]	; 357C7
push ebx	; 357CE
mov ecx, dword [dword esp+07A8h]	; 357CF
push ecx	; 357D6
mov esi, dword [dword esp+07A4h]	; 357D7
push esi	; 357DE
mov ecx, dword [dword esp+079Ch]	; 357DF
mov ecx, dword [dword esp+ecx+0728h]	; 357E6
mov ebx, dword [dword esp+079Ch]	; 357ED
mov ebx, dword [dword esp+ebx+0724h]	; 357F4
mov edx, dword [dword esp+07A4h]	; 357FB
mov edx, dword [dword esp+edx+0754h]	; 35802
mov eax, dword [dword esp+07A4h]	; 35809
mov eax, dword [dword esp+eax+073Ch]	; 35810
call DrawMenuDropdown	; 35817
mov eax, dword [dword esp+0798h]	; 3581C
xor edi, edi	; 35823
mov dword [dword esp+eax+0754h], edi	; 35825
mov eax, dword [dword esp+07A0h]	; 3582C
push eax	; 35833
mov edx, dword [dword esp+07A8h]	; 35834
push edx	; 3583B
mov ebx, dword [dword esp+0798h]	; 3583C
mov ebx, dword [dword esp+ebx+0724h]	; 35843
mov edx, dword [dword esp+0798h]	; 3584A
mov edx, dword [dword esp+edx+0720h]	; 35851
mov eax, dword [dword esp+07A0h]	; 35858
mov eax, dword [dword esp+eax+0738h]	; 3585F
mov ecx, esi	; 35866
jmp near .64	; 35868
.59:
mov esi, dword [dword esp+0774h]	; 3586D
push esi	; 35874
mov edi, dword [dword esp+077Ch]	; 35875
push edi	; 3587C
mov eax, dword [dword esp+079Ch]	; 3587D
push eax	; 35884
call sub_903F0	; 35885
add esp, byte 0Ch	; 3588A
mov eax, dword [dword esp+07B0h]	; 3588D
cmp eax, dword [dword esp+0768h]	; 35894
je near .63	; 3589B
mov eax, dword [dword esp+07B0h]	; 358A1
mov word [dword esp+07CCh], ax	; 358A8
jmp short .62	; 358B0
.60:
mov esi, edi	; 358B2
shl esi, 2	; 358B4
xor edx, edx	; 358B7
mov dword [dword esp+esi+0754h], edx	; 358B9
mov ebx, dword [dword esp+esi+073Ch]	; 358C0
test ebx, ebx	; 358C7
je short .61	; 358C9
mov ecx, dword [dword esp+edi*8+071Ch]	; 358CB
push ecx	; 358D2
mov eax, dword [dword esp+edi*8+071Ch]	; 358D3
push eax	; 358DA
push ebx	; 358DB
call sub_903F0	; 358DC
add esp, byte 0Ch	; 358E1
xor ebx, ebx	; 358E4
mov dword [dword esp+edi*8+0718h], ebx	; 358E6
mov dword [dword esp+edi*8+071Ch], ebx	; 358ED
mov edi, dword [dword esp+esi+073Ch]	; 358F4
push edi	; 358FB
call FreeMemBlock	; 358FC
add esp, byte 4	; 35901
xor eax, eax	; 35904
mov dword [dword esp+esi+073Ch], eax	; 35906
mov dword [dword esp+esi+0730h], eax	; 3590D
mov dword [dword esp+esi+0748h], eax	; 35914
.61:
dec word [dword esp+07CCh]	; 3591B
.62:
mov edi, dword [dword esp+07CAh]	; 35923
sar edi, 10h	; 3592A
mov eax, dword [dword esp+0768h]	; 3592D
cmp edi, eax	; 35934
jg near CalendarScreen.60	; 35936
mov dword [dword esp+07B0h], eax	; 3593C
.63:
mov ecx, dword [dword esp+07A0h]	; 35943
push ecx	; 3594A
mov esi, dword [dword esp+07A8h]	; 3594B
push esi	; 35952
mov eax, dword [dword esp+0770h]	; 35953
mov ebx, dword [dword esp+eax*8+0724h]	; 3595A
mov edx, dword [dword esp+eax*8+0720h]	; 35961
mov ecx, dword [dword esp+eax*4+075Ch]	; 35968
shl ecx, 5	; 3596F
mov eax, dword [dword esp+eax*4+0738h]	; 35972
add eax, ecx	; 35979
mov ecx, dword [dword esp+07A4h]	; 3597B
call DrawMenuItemSel	; 35982
mov edx, dword [dword esp+0768h]	; 35987
mov eax, dword [dword esp+0764h]	; 3598E
mov dword [dword esp+edx*4+0754h], eax	; 35995
mov edi, dword [dword esp+07A0h]	; 3599C
push edi	; 359A3
push esi	; 359A4
mov ebx, dword [dword esp+edx*8+0724h]	; 359A5
mov eax, dword [dword esp+edx*8+0720h]	; 359AC
mov esi, dword [dword esp+edx*4+075Ch]	; 359B3
shl esi, 5	; 359BA
mov edx, dword [dword esp+edx*4+0738h]	; 359BD
add esi, edx	; 359C4
mov ecx, dword [dword esp+07A4h]	; 359C6
mov edx, eax	; 359CD
mov eax, esi	; 359CF
.64:
call DrawMenuItemNorm	; 359D1
jmp near .79	; 359D6
.65:
mov edi, dword [dword esp+0774h]	; 359DB
push edi	; 359E2
mov eax, dword [dword esp+077Ch]	; 359E3
push eax	; 359EA
mov edx, dword [dword esp+079Ch]	; 359EB
push edx	; 359F2
call sub_903F0	; 359F3
add esp, byte 0Ch	; 359F8
cmp dword [dword esp+07B0h], byte 0	; 359FB
je near .69	; 35A03
mov eax, dword [dword esp+07B0h]	; 35A09
mov word [dword esp+07CCh], ax	; 35A10
jmp short .68	; 35A18
.66:
mov esi, dword [dword esp+07CAh]	; 35A1A
sar esi, 10h	; 35A21
mov edi, esi	; 35A24
shl edi, 2	; 35A26
mov eax, dword [dword esp+edi+073Ch]	; 35A29
test eax, eax	; 35A30
je short .67	; 35A32
mov edx, dword [dword esp+esi*8+071Ch]	; 35A34
push edx	; 35A3B
mov ebx, dword [dword esp+esi*8+071Ch]	; 35A3C
push ebx	; 35A43
push eax	; 35A44
call sub_903F0	; 35A45
add esp, byte 0Ch	; 35A4A
xor eax, eax	; 35A4D
mov dword [dword esp+esi*8+0718h], eax	; 35A4F
mov dword [dword esp+esi*8+071Ch], eax	; 35A56
mov ebx, dword [dword esp+edi+073Ch]	; 35A5D
push ebx	; 35A64
call FreeMemBlock	; 35A65
add esp, byte 4	; 35A6A
.67:
dec word [dword esp+07CCh]	; 35A6D
.68:
cmp word [dword esp+07CCh], byte 0	; 35A75
jge short CalendarScreen.66	; 35A7E
xor eax, eax	; 35A80
mov dword [dword esp+07B0h], eax	; 35A82
mov dword [dword esp+0734h], eax	; 35A89
mov dword [dword esp+073Ch], eax	; 35A90
mov dword [dword esp+0740h], eax	; 35A97
mov dword [dword esp+0758h], eax	; 35A9E
mov dword [dword esp+074Ch], eax	; 35AA5
jmp near .79	; 35AAC
.69:
mov word [dword esp+07B4h], 0FFFFh	; 35AB1
mov ecx, dword [dword esp+0770h]	; 35ABB
cmp ecx, byte 52h	; 35AC2
jl near .78	; 35AC5
cmp ecx, 25Fh	; 35ACB
jge near .78	; 35AD1
mov edi, dword [dword esp+076Ch]	; 35AD7
cmp edi, byte 44h	; 35ADE
jl near .78	; 35AE1
cmp edi, 1B2h	; 35AE7
jge near .78	; 35AED
lea edx, [byte edi-044h]	; 35AF3
mov ebx, 3Dh	; 35AF6
mov eax, edx	; 35AFB
sar edx, 1Fh	; 35AFD
idiv ebx	; 35B00
mov esi, eax	; 35B02
shl esi, 3	; 35B04
sub esi, eax	; 35B07
lea edx, [byte ecx-052h]	; 35B09
mov ebx, 4Bh	; 35B0C
mov eax, edx	; 35B11
sar edx, 1Fh	; 35B13
idiv ebx	; 35B16
add esi, eax	; 35B18
mov ebx, dword [calmonth]	; 35B1A
xor edx, edx	; 35B20
mov dl, byte [dword ebx+monthfirstday]	; 35B22
mov ecx, 7	; 35B28
mov eax, edx	; 35B2D
sar edx, 1Fh	; 35B2F
idiv ecx	; 35B32
mov eax, esi	; 35B34
sub eax, edx	; 35B36
mov word [dword esp+07C8h], ax	; 35B38
test ax, ax	; 35B40
jl near .78	; 35B43
xor eax, eax	; 35B49
mov al, byte [dword ebx+monthdays]	; 35B4B
mov edx, dword [dword esp+07C6h]	; 35B51
sar edx, 10h	; 35B58
cmp edx, eax	; 35B5B
jge near .78	; 35B5D
xor ebx, ebx	; 35B63
mov word [dword esp+07CCh], bx	; 35B65
jmp near .77	; 35B6D
.70:
mov edx, dword [dword esp+07CAh]	; 35B72
sar edx, 10h	; 35B79
mov eax, edx	; 35B7C
shl eax, 2	; 35B7E
sub eax, edx	; 35B81
add eax, eax	; 35B83
xor ecx, ecx	; 35B85
mov cl, byte [dword esp+eax+0304h]	; 35B87
mov ebx, dword [calmonth]	; 35B8E
inc ebx	; 35B94
cmp ecx, ebx	; 35B95
jne near .76	; 35B97
xor ecx, ebx	; 35B9D
mov cl, byte [dword esp+eax+0305h]	; 35B9F
mov ebx, dword [dword esp+07C6h]	; 35BA6
sar ebx, 10h	; 35BAD
inc ebx	; 35BB0
cmp ecx, ebx	; 35BB1
jne near .76	; 35BB3
mov bl, byte [dword esp+eax+0308h]	; 35BB9
cmp bl, 0FFh	; 35BC0
jne near .76	; 35BC3
cmp bl, byte [dword esp+eax+0309h]	; 35BC9
jne near .76	; 35BD0
mov eax, dword [dword esp+edx*2+05AAh]	; 35BD6
sar eax, 10h	; 35BDD
cmp eax, dword [calsel]	; 35BE0
jne short .71	; 35BE6
mov dword [calexit], 0FFFFFFFFh	; 35BE8
.71:
cmp word [dword esp+07C0h], 444h	; 35BF2
jl short .72	; 35BFC
mov eax, dword [dword esp+07CAh]	; 35BFE
sar eax, 10h	; 35C05
mov ax, word [dword esp+eax*2+05ACh]	; 35C08
cmp ax, word [dword esp+07BCh]	; 35C10
jne short .73	; 35C18
.72:
mov eax, dword [dword esp+07CAh]	; 35C1A
sar eax, 10h	; 35C21
mov ax, word [dword esp+eax*2+05ACh]	; 35C24
mov word [dword esp+07B4h], ax	; 35C2C
mov eax, dword [dword esp+07CCh]	; 35C34
mov word [dword esp+07C4h], ax	; 35C3B
mov eax, dword [dword esp+07B8h]	; 35C43
mov word [dword esp+07CCh], ax	; 35C4A
.73:
mov esi, dword [calselmonth]	; 35C52
mov edi, dword [calselday]	; 35C58
mov ebx, dword [dword esp+07C2h]	; 35C5E
sar ebx, 10h	; 35C65
mov edx, ebx	; 35C68
mov eax, ebx	; 35C6A
shl eax, 2	; 35C6C
sub eax, ebx	; 35C6F
xor edx, ebx	; 35C71
mov dl, byte [dword esp+eax*2+0304h]	; 35C73
mov dword [calselmonth], edx	; 35C7A
mov al, byte [dword esp+eax*2+0305h]	; 35C80
and eax, 0FFh	; 35C87
mov dword [calselday], eax	; 35C8C
cmp dword [calexit], byte 0	; 35C91
jne short .74	; 35C98
lea edx, [dword esp+0304h]	; 35C9A
mov eax, ebp	; 35CA1
call SetGameSides	; 35CA3
.74:
call sub_B4BA8	; 35CA8
mov ebx, dword [dword esp+07A0h]	; 35CAD
push ebx	; 35CB4
mov ecx, dword [dword esp+07A8h]	; 35CB5
mov ebx, dword [dword esp+07A0h]	; 35CBC
mov edx, 3	; 35CC3
mov eax, calmenubar	; 35CC8
call DrawMenuBar	; 35CCD
mov ecx, dword [calselmonth]	; 35CD2
cmp esi, ecx	; 35CD8
jne near .75	; 35CDA
cmp edi, dword [calselday]	; 35CE0
je near .75	; 35CE6
movzx esi, byte [dword ecx+monthfirstday_m1]	; 35CEC
add esi, edi	; 35CF3
dec esi	; 35CF5
mov ebx, 7	; 35CF6
mov eax, esi	; 35CFB
mov edx, esi	; 35CFD
sar edx, 1Fh	; 35CFF
idiv ebx	; 35D02
mov ebx, edx	; 35D04
mov ecx, 7	; 35D06
mov eax, esi	; 35D0B
mov edx, esi	; 35D0D
sar edx, 1Fh	; 35D0F
idiv ecx	; 35D12
mov esi, ebx	; 35D14
shl esi, 2	; 35D16
mov ecx, dword [dword esi+calcolx]	; 35D19
sub ecx, byte 2	; 35D1F
mov ebx, dword [nosplit eax*4+calrowy]	; 35D22
sub ebx, byte 2	; 35D29
mov edx, dword [dword esi+calcolx]	; 35D2C
add edx, byte 4Dh	; 35D32
mov eax, dword [nosplit eax*4+calrowy]	; 35D35
add eax, byte 3Fh	; 35D3C
push eax	; 35D3F
push ebx	; 35D40
push edx	; 35D41
push ecx	; 35D42
call sub_B4BC4	; 35D43
add esp, byte 10h	; 35D48
mov edx, dword [calendarshapes]	; 35D4B
push edx	; 35D51
mov ebx, dword [dword esp+07B0h]	; 35D52
push ebx	; 35D59
push ebp	; 35D5A
mov eax, dword [dword esp+07C2h]	; 35D5B
sar eax, 10h	; 35D62
push eax	; 35D65
mov eax, dword [calmonth]	; 35D66
lea ecx, [dword esp+0314h]	; 35D6B
mov ebx, dword [dword esp+07B8h]	; 35D72
lea edx, [dword esp+06A0h]	; 35D79
call DrawCalendarDay	; 35D80
.75:
mov eax, dword [calselmonth]	; 35D85
movzx esi, byte [dword eax+monthfirstday_m1]	; 35D8A
add esi, dword [calselday]	; 35D91
dec esi	; 35D97
mov ebx, 7	; 35D98
mov eax, esi	; 35D9D
mov edx, esi	; 35D9F
sar edx, 1Fh	; 35DA1
idiv ebx	; 35DA4
mov ebx, edx	; 35DA6
mov ecx, 7	; 35DA8
mov eax, esi	; 35DAD
mov edx, esi	; 35DAF
sar edx, 1Fh	; 35DB1
idiv ecx	; 35DB4
mov esi, eax	; 35DB6
mov eax, ebx	; 35DB8
mov ebx, dword [nosplit eax*4+calcolx]	; 35DBA
sub ebx, byte 2	; 35DC1
mov edx, dword [nosplit esi*4+calrowy]	; 35DC4
sub edx, byte 2	; 35DCB
mov eax, dword [nosplit eax*4+calcolx]	; 35DCE
add eax, byte 4Dh	; 35DD5
mov ecx, dword [nosplit esi*4+calrowy]	; 35DD8
add ecx, byte 3Fh	; 35DDF
push ecx	; 35DE2
push edx	; 35DE3
push eax	; 35DE4
push ebx	; 35DE5
call sub_B4BC4	; 35DE6
add esp, byte 10h	; 35DEB
mov esi, dword [calendarshapes]	; 35DEE
push esi	; 35DF4
mov edi, dword [dword esp+07B0h]	; 35DF5
push edi	; 35DFC
push ebp	; 35DFD
mov eax, dword [dword esp+07C2h]	; 35DFE
sar eax, 10h	; 35E05
push eax	; 35E08
mov eax, dword [calmonth]	; 35E09
lea ecx, [dword esp+0314h]	; 35E0E
mov ebx, dword [dword esp+07B8h]	; 35E15
lea edx, [dword esp+06A0h]	; 35E1C
call DrawCalendarDay	; 35E23
push dword 1E0h	; 35E28
push byte 0	; 35E2D
push dword 280h	; 35E2F
push byte 0	; 35E34
call sub_B4BC4	; 35E36
add esp, byte 10h	; 35E3B
.76:
inc word [dword esp+07CCh]	; 35E3E
.77:
mov eax, dword [dword esp+07CCh]	; 35E46
cmp ax, word [dword esp+07B8h]	; 35E4D
jl near CalendarScreen.70	; 35E55
.78:
mov eax, dword [dword esp+07B2h]	; 35E5B
sar eax, 10h	; 35E62
mov dword [calsel], eax	; 35E65
.79:
mov ecx, dword [dword esp+0774h]	; 35E6A
push ecx	; 35E71
mov esi, dword [dword esp+077Ch]	; 35E72
push esi	; 35E79
mov edi, dword [dword esp+079Ch]	; 35E7A
push edi	; 35E81
call sub_91400	; 35E82
add esp, byte 0Ch	; 35E87
mov eax, dword [dword esp+0774h]	; 35E8A
push eax	; 35E91
mov edx, dword [dword esp+077Ch]	; 35E92
push edx	; 35E99
mov ebx, dword [dword esp+079Ch]	; 35E9A
push ebx	; 35EA1
call sub_903F0	; 35EA2
add esp, byte 0Ch	; 35EA7
mov ecx, dword [dword esp+076Ch]	; 35EAA
push ecx	; 35EB1
mov esi, dword [dword esp+0774h]	; 35EB2
push esi	; 35EB9
mov edi, dword [dword esp+079Ch]	; 35EBA
push edi	; 35EC1
call sub_91400	; 35EC2
add esp, byte 0Ch	; 35EC7
cmp dword [calexit], byte 0	; 35ECA
jne short .81	; 35ED1
mov edx, dword [dword esp+076Ch]	; 35ED3
push edx	; 35EDA
mov ebx, dword [dword esp+0774h]	; 35EDB
push ebx	; 35EE2
mov ecx, dword [pointerspr]	; 35EE3
push ecx	; 35EE9
.80:
call sub_91370	; 35EEA
add esp, byte 0Ch	; 35EEF
.81:
mov eax, dword [dword esp+0770h]	; 35EF2
mov dword [dword esp+0778h], eax	; 35EF9
mov eax, dword [dword esp+076Ch]	; 35F00
mov dword [dword esp+0774h], eax	; 35F07
.82:
cmp dword [calexit], byte 0	; 35F0E
je near CalendarScreen.32	; 35F15
.83:
mov edi, dword [dword esp+0794h]	; 35F1B
push edi	; 35F22
call FreeMemBlock	; 35F23
add esp, byte 4	; 35F28
mov ebp, dword [dword esp+078Ch]	; 35F2B
push ebp	; 35F32
call FreeMemBlock	; 35F33
add esp, byte 4	; 35F38
mov eax, dword [calendarshapes]	; 35F3B
push eax	; 35F40
call FreeMemBlock	; 35F41
add esp, byte 4	; 35F46
xor edx, edx	; 35F49
mov dword [calendarshapes], edx	; 35F4B
mov dword [teamstatscb], GameTeamStatsScreen	; 35F51
mov dword [skaterstatscb], GameSkaterStatsScreen	; 35F5B
mov dword [goaliestatscb], GameGoalieStatsScreen	; 35F65
mov dword [standingscb], GameStandingsScreen	; 35F6F
mov dword [standingsmenucb], GameStandingsMenu	; 35F79
cmp byte [musicon], 0	; 35F83
je short .84	; 35F8A
cmp dword [songdata], byte 0	; 35F8C
je short .84	; 35F93
mov eax, dword [musichandle]	; 35F95
mov ebx, 64h	; 35F9A
mov edx, 3	; 35F9F
call sub_8FCDF	; 35FA4
.84:
mov eax, dword [calsel]	; 35FA9
.x:
add esp, 7D4h	; 35FAE
pop ebp	; 35FB4
pop edi	; 35FB5
pop esi	; 35FB6
pop ecx	; 35FB7
ret	; 35FB8
; C: src/c/front/calendar/CheckLeagueDiskSync.c
%ifdef CBUILD
%include "c/front/calendar/CheckLeagueDiskSync.inc"
%else
CheckLeagueDiskSync:
push dword 0D8h	; 35FB9
call __CHK	; 35FBE
push esi	; 35FC3
push edi	; 35FC4
push ebp	; 35FC5
sub esp, 0B4h	; 35FC6
mov edi, eax	; 35FCC
mov dword [dword esp+0B0h], ebx	; 35FCE
mov dword [dword esp+0ACh], 0FFFFFFFFh	; 35FD5
xor ebp, ebp	; 35FE0
mov esi, dword [dword esp+0B0h]	; 35FE2
shl esi, 4	; 35FE9
sub esi, dword [dword esp+0B0h]	; 35FEC
add esi, esi	; 35FF3
add esi, edx	; 35FF5
mov dword [leaguediskmsg+8], ebp	; 35FF7
lea edx, [dword esp+09Ch]	; 35FFD
mov eax, edi	; 36004
call GetLeagueId	; 36006
mov dl, byte [byte esi+017h]	; 3600B
cmp dl, 1	; 3600E
jne near .8	; 36011
cmp eax, dword [dword esp+0B0h]	; 36017
je short .1	; 3601E
test eax, eax	; 36020
jge short .2	; 36022
cmp dl, byte [byte esi+018h]	; 36024
je short .1	; 36027
test byte [byte esi+016h], dl	; 36029
je short .2	; 3602C
.1:
test byte [byte esi+016h], 2	; 3602E
je near .8	; 36032
mov dword [leaguediskmsg+8], str_MustBeImportedFrom	; 36038
jmp near .7	; 36042
.2:
test ecx, ecx	; 36047
je near .6	; 36049
cmp dword [dword esp+0C4h], byte 0	; 3604F
je short .3	; 36057
mov ebx, edi	; 36059
mov edx, esi	; 3605B
mov eax, esp	; 3605D
call FmtFromLeague	; 3605F
mov eax, esp	; 36064
mov dword [msg_InsertDisk_arg], eax	; 36066
mov ebx, 0FFFFFFFFh	; 3606B
mov edx, esi	; 36070
mov eax, edi	; 36072
call FindLeagueFloppy	; 36074
jmp short .4	; 36079
.3:
mov ebx, 0FFFFFFFFh	; 3607B
mov edx, esi	; 36080
mov eax, edi	; 36082
call WaitLeagueFloppy	; 36084
.4:
mov ebp, eax	; 36089
test ebp, ebp	; 3608B
jne near .8	; 3608D
mov ecx, str_extDB	; 36093
mov ebx, str_PINFO	; 36098
mov edx, str_floppydrv	; 3609D
lea eax, [byte esp+040h]	; 360A2
call MakePath	; 360A6
lea edx, [dword esp+0ACh]	; 360AB
lea eax, [byte esp+040h]	; 360B2
call FileOpenRead	; 360B6
mov ebp, eax	; 360BB
test eax, eax	; 360BD
jne short .5	; 360BF
mov ebx, dword [dword esp+0B0h]	; 360C1
lea edx, [byte esp+060h]	; 360C8
mov eax, dword [dword esp+0ACh]	; 360CC
call ReadLeagueTeamEntry	; 360D3
mov ebp, eax	; 360D8
.5:
lea eax, [dword esp+0ACh]	; 360DA
call FileClose	; 360E1
test ebp, ebp	; 360E6
jne short .8	; 360E8
test byte [byte esp+076h], 1	; 360EA
je short .8	; 360EF
mov dword [leaguediskmsg+8], str_MustBeExportedTo	; 360F1
jmp short .7	; 360FB
.6:
lea eax, [dword esp+0A0h]	; 360FD
push eax	; 36104
lea eax, [dword esp+0A8h]	; 36105
push eax	; 3610C
lea eax, [dword esp+0B0h]	; 3610D
push eax	; 36114
call sub_B2DCA	; 36115
add esp, byte 0Ch	; 3611A
push byte 0FFFFFFFFh	; 3611D
lea eax, [dword esp+0A4h]	; 3611F
push eax	; 36126
lea eax, [dword esp+0ACh]	; 36127
push eax	; 3612E
push byte 0	; 3612F
push byte 0	; 36131
mov ecx, 2	; 36133
mov ebx, firstteammsg	; 36138
mov edx, 0FFFFFFFFh	; 3613D
mov eax, edx	; 36142
call MessageBox	; 36144
.7:
mov ebp, 4	; 36149
.8:
cmp dword [leaguediskmsg+8], byte 0	; 3614E
je near .9	; 36155
mov edx, edi	; 3615B
lea eax, [dword esp+080h]	; 3615D
call strcpy_	; 36164
mov ecx, ds	; 36169
mov ebx, str_dot	; 3616B
mov edx, ds	; 36170
lea eax, [dword esp+080h]	; 36172
call _fstrcspn_	; 36179
xor ch, ch	; 3617E
mov byte [dword esp+eax+080h], ch	; 36180
lea eax, [dword esp+080h]	; 36187
mov dword [leaguediskmsg+4], eax	; 3618E
mov edx, esi	; 36193
lea eax, [dword esp+090h]	; 36195
call strcpy_	; 3619C
lea eax, [dword esp+090h]	; 361A1
mov dword [leaguediskmsg+0Ch], eax	; 361A8
lea eax, [dword esp+0A0h]	; 361AD
push eax	; 361B4
lea eax, [dword esp+0A8h]	; 361B5
push eax	; 361BC
lea eax, [dword esp+0B0h]	; 361BD
push eax	; 361C4
call sub_B2DCA	; 361C5
add esp, byte 0Ch	; 361CA
push byte 0FFFFFFFFh	; 361CD
lea eax, [dword esp+0A4h]	; 361CF
push eax	; 361D6
lea eax, [dword esp+0ACh]	; 361D7
push eax	; 361DE
push byte 0	; 361DF
push byte 0	; 361E1
mov ecx, 5	; 361E3
mov ebx, leaguediskmsg	; 361E8
mov edx, 0FFFFFFFFh	; 361ED
mov eax, edx	; 361F2
call MessageBox	; 361F4
.9:
mov eax, ebp	; 361F9
add esp, 0B4h	; 361FB
pop ebp	; 36201
pop edi	; 36202
pop esi	; 36203
ret 4	; 36204
%endif ; C
; C: src/c/front/calendar/MakeTeamDbFmt.c
%ifdef CBUILD
%include "c/front/calendar/MakeTeamDbFmt.inc"
%else
MakeTeamDbFmt:
push dword 18h	; 36207
call __CHK	; 3620C
push esi	; 36211
sub esp, byte 4	; 36212
mov esi, eax	; 36215
mov eax, ecx	; 36217
shl eax, 4	; 36219
sub eax, ecx	; 3621C
cmp byte [byte ebx+eax*2+017h], 1	; 3621E
jne short .1	; 36223
push ecx	; 36225
push str_02d	; 36226
lea eax, [byte esp+08h]	; 3622B
push eax	; 3622F
call sprintf_	; 36230
add esp, byte 0Ch	; 36235
mov eax, esi	; 36238
call strcpy_	; 3623A
mov edx, str_backslash2	; 3623F
mov eax, esi	; 36244
call strcat_	; 36246
mov edx, str_S4	; 3624B
mov eax, esi	; 36250
call strcat_	; 36252
mov edx, esp	; 36257
mov eax, esi	; 36259
call strcat_	; 3625B
add esp, byte 4	; 36260
pop esi	; 36263
ret	; 36264
.1:
mov byte [esi], 0	; 36265
add esp, byte 4	; 36268
pop esi	; 3626B
ret	; 3626C
%endif ; C
PostGameToTeamDb:
push dword 420h	; 3626D
call __CHK	; 36272
push esi	; 36277
push edi	; 36278
push ebp	; 36279
sub esp, 404h	; 3627A
push eax	; 36280
push edx	; 36281
push ebx	; 36282
mov ebp, ecx	; 36283
mov edx, 0FFFFFFFFh	; 36285
mov dword [dword esp+03ECh], edx	; 3628A
mov dword [dword esp+03E8h], edx	; 36291
mov dword [dword esp+03E4h], edx	; 36298
mov dword [dword esp+03E0h], edx	; 3629F
mov dword [dword esp+03D8h], hmlinetab	; 362A6
mov dword [dword esp+03DCh], awlinetab	; 362B1
cmp dword [dword esp+0420h], 444h	; 362BC
jge short .1	; 362C7
lea eax, [byte esp+034h]	; 362C9
mov dword [dword esp+03FCh], eax	; 362CD
lea edi, [dword esp+0360h]	; 362D4
lea esi, [dword esp+02F4h]	; 362DB
jmp short .2	; 362E2
.1:
lea eax, [byte esp+046h]	; 362E4
mov dword [dword esp+03FCh], eax	; 362E8
lea edi, [dword esp+0372h]	; 362EF
lea esi, [dword esp+030Ah]	; 362F6
.2:
mov ebx, dword [leaguedbnames+10h]	; 362FD
mov ecx, dword [byte esp+04h]	; 36303
mov edx, dword [byte esp+08h]	; 36307
lea eax, [dword esp+0390h]	; 3630B
call MakePath	; 36312
lea edx, [dword esp+03ECh]	; 36317
lea eax, [dword esp+0390h]	; 3631E
call FileOpenRW	; 36325
mov ebx, eax	; 3632A
test eax, eax	; 3632C
jne short .3	; 3632E
mov ebx, dword [leaguedbnames]	; 36330
mov ecx, dword [byte esp+04h]	; 36336
mov edx, dword [byte esp+08h]	; 3633A
lea eax, [dword esp+0390h]	; 3633E
call MakePath	; 36345
lea edx, [dword esp+03E8h]	; 3634A
lea eax, [dword esp+0390h]	; 36351
call FileOpenRead	; 36358
mov ebx, eax	; 3635D
.3:
test ebx, ebx	; 3635F
jne short .4	; 36361
mov ebx, dword [leaguedbnames+14h]	; 36363
mov ecx, dword [byte esp+04h]	; 36369
mov edx, dword [byte esp+08h]	; 3636D
lea eax, [dword esp+0390h]	; 36371
call MakePath	; 36378
lea edx, [dword esp+03E4h]	; 3637D
lea eax, [dword esp+0390h]	; 36384
call FileOpenRW	; 3638B
mov ebx, eax	; 36390
.4:
test ebx, ebx	; 36392
jne short .5	; 36394
mov ecx, str_extDB	; 36396
mov ebx, str_GSUMMARY	; 3639B
mov edx, dword [dword esp+0424h]	; 363A0
lea eax, [dword esp+0390h]	; 363A7
call MakePath	; 363AE
lea edx, [dword esp+03E0h]	; 363B3
lea eax, [dword esp+0390h]	; 363BA
call FileOpenRW	; 363C1
mov ebx, eax	; 363C6
.5:
test ebx, ebx	; 363C8
jne short .6	; 363CA
mov ebx, dword [esp]	; 363CC
lea edx, [byte esp+0Ch]	; 363CF
mov eax, dword [dword esp+03ECh]	; 363D3
call ReadTeamRec	; 363DA
mov ebx, eax	; 363DF
.6:
test ebx, ebx	; 363E1
jne near .20	; 363E3
mov eax, dword [dword esp+03FCh]	; 363E9
inc byte [eax]	; 363F0
mov ax, word [hmscore]	; 363F2
mov dx, word [awscore]	; 363F8
cmp ax, dx	; 363FF
jle short .9	; 36402
mov eax, dword [awscore-2]	; 36404
sar eax, 10h	; 36409
inc eax	; 3640C
mov dword [dword esp+0404h], eax	; 3640D
mov dword [dword esp+0400h], ebx	; 36414
test ebp, ebp	; 3641B
jne short .8	; 3641D
.7:
mov eax, dword [dword esp+03FCh]	; 3641F
inc byte [byte eax+01h]	; 36426
jmp short .11	; 36429
.8:
mov eax, dword [dword esp+03FCh]	; 3642B
inc byte [byte eax+02h]	; 36432
jmp short .11	; 36435
.9:
jge short .10	; 36437
cwde	; 36439
inc eax	; 3643A
mov dword [dword esp+0404h], eax	; 3643B
mov dword [dword esp+0400h], 1	; 36442
test ebp, ebp	; 3644D
je short PostGameToTeamDb.8	; 3644F
jmp short PostGameToTeamDb.7	; 36451
.10:
mov dword [dword esp+0400h], 0FFFFFFFFh	; 36453
mov eax, dword [dword esp+03FCh]	; 3645E
inc byte [byte eax+03h]	; 36465
mov eax, dword [hmscore-2]	; 36468
sar eax, 10h	; 3646D
mov dword [dword esp+0404h], eax	; 36470
.11:
mov eax, ebp	; 36477
shl eax, 8	; 36479
mov dword [dword esp+03F0h], eax	; 3647C
mov ax, word [dword eax+hmscore]	; 36483
mov edx, dword [dword esp+03FCh]	; 3648A
add word [byte edx+04h], ax	; 36491
mov eax, ebp	; 36495
xor al, 1	; 36497
shl eax, 8	; 36499
mov dx, word [dword eax+hmscore]	; 3649C
mov ecx, dword [dword esp+03FCh]	; 364A3
add word [byte ecx+06h], dx	; 364AA
mov edx, dword [dword esp+03F0h]	; 364AE
mov dx, word [dword edx+hmtmstruct+4]	; 364B5
add word [byte ecx+0Ah], dx	; 364BC
mov edx, dword [dword esp+03F0h]	; 364C0
mov dx, word [dword edx+hmtmstruct+2]	; 364C7
add word [byte ecx+08h], dx	; 364CE
mov dx, word [dword eax+hmtmstruct+4]	; 364D2
add word [byte ecx+0Eh], dx	; 364D9
mov dx, word [dword eax+hmtmstruct+2]	; 364DD
add word [byte ecx+0Ch], dx	; 364E4
mov ax, word [dword eax+hmtmstruct+0Ch]	; 364E8
mov edx, ecx	; 364EF
mov cx, word [byte ecx+010h]	; 364F1
add ecx, eax	; 364F5
mov word [byte edx+010h], cx	; 364F7
xor ecx, ecx	; 364FB
mov dword [dword esp+03F8h], ecx	; 364FD
jmp near .19	; 36504
.12:
shl eax, 2	; 36509
mov edx, dword [dword eax+startm-2]	; 3650C
sar edx, 10h	; 36512
cmp edx, ebp	; 36515
jne near .18	; 36517
mov ebx, dword [dword eax+starpl-2]	; 3651D
sar ebx, 10h	; 36523
mov ebx, dword [byte esp+ebx*4+058h]	; 36526
lea edx, [dword esp+032Ch]	; 3652A
mov eax, dword [dword esp+03E8h]	; 36531
call ReadKeyRec	; 36538
mov ebx, eax	; 3653D
test eax, eax	; 3653F
jne short .15	; 36541
cmp byte [dword esp+032Eh], 47h	; 36543
jne short .13	; 3654B
mov ebx, dword [dword esp+0358h]	; 3654D
lea edx, [dword esp+02F4h]	; 36554
mov eax, dword [dword esp+03E4h]	; 3655B
call ReadGoalieSeasonRec	; 36562
jmp short .14	; 36567
.13:
mov ebx, dword [dword esp+0358h]	; 36569
lea edx, [dword esp+0360h]	; 36570
mov eax, dword [dword esp+03E4h]	; 36577
call ReadSeasonRec	; 3657E
.14:
mov ebx, eax	; 36583
.15:
test ebx, ebx	; 36585
jne short .18	; 36587
mov eax, dword [dword esp+03F8h]	; 36589
add eax, eax	; 36590
cmp byte [dword esp+032Eh], 47h	; 36592
jne short .16	; 3659A
inc word [dword esp+eax+0324h]	; 3659C
mov ebx, dword [dword esp+0358h]	; 365A4
lea edx, [dword esp+02F4h]	; 365AB
mov eax, dword [dword esp+03E4h]	; 365B2
call WriteGoalieSeasonRec	; 365B9
jmp short .17	; 365BE
.16:
inc word [dword esp+eax+0388h]	; 365C0
mov ebx, dword [dword esp+0358h]	; 365C8
lea edx, [dword esp+0360h]	; 365CF
mov eax, dword [dword esp+03E4h]	; 365D6
call WriteSeasonRec	; 365DD
.17:
mov ebx, eax	; 365E2
.18:
inc dword [dword esp+03F8h]	; 365E4
.19:
mov eax, dword [dword esp+03F8h]	; 365EB
cmp eax, byte 3	; 365F2
jge short .20	; 365F5
test ebx, ebx	; 365F7
je near PostGameToTeamDb.12	; 365F9
.20:
cmp dword [dword esp+0400h], byte 0	; 365FF
jge short .21	; 36607
mov ax, word [hmtmgoalie]	; 36609
xor ah, ah	; 3660F
and al, 1	; 36611
cwde	; 36613
mov edx, dword [hmtmlines]	; 36614
mov al, byte [byte edx+eax+024h]	; 3661A
mov byte [dword esp+040Ch], al	; 3661E
mov ax, word [awtmgoalie]	; 36625
xor ah, ah	; 3662B
and al, 1	; 3662D
movsx edx, ax	; 3662F
mov eax, dword [awtmlines]	; 36632
mov al, byte [byte edx+eax+024h]	; 36637
mov byte [dword esp+040Dh], al	; 3663B
jmp near .30	; 36642
.21:
test ebx, ebx	; 36647
jne short .22	; 36649
lea edx, [dword esp+03CCh]	; 3664B
mov eax, dword [dword esp+03E0h]	; 36652
call ReadGSummaryRec	; 36659
mov ebx, eax	; 3665E
.22:
test ebx, ebx	; 36660
jne near .30	; 36662
xor ecx, ecx	; 36668
mov dword [dword esp+0408h], ebx	; 3666A
mov al, 0FFh	; 36671
mov byte [dword esp+040Ch], al	; 36673
mov byte [dword esp+040Dh], al	; 3667A
mov eax, dword [dword esp+03CFh]	; 36681
sar eax, 10h	; 36688
mov dword [dword esp+03F4h], eax	; 3668B
mov dword [dword esp+03F8h], ebx	; 36692
jmp near .29	; 36699
.23:
mov ebx, eax	; 3669E
lea edx, [dword esp+03CCh]	; 366A0
mov eax, dword [dword esp+03E0h]	; 366A7
call ReadGSummaryRec	; 366AE
mov ebx, eax	; 366B3
test eax, eax	; 366B5
jne near .28	; 366B7
cmp byte [dword esp+03CCh], 1	; 366BD
jne short .28	; 366C5
lea edx, [dword esp+03CDh]	; 366C7
cmp byte [dword esp+03CDh], 0	; 366CE
jne short .24	; 366D6
inc ecx	; 366D8
jmp short .25	; 366D9
.24:
inc dword [dword esp+0408h]	; 366DB
.25:
cmp dword [dword esp+0400h], byte 0	; 366E2
jne short .26	; 366EA
cmp ecx, dword [dword esp+0404h]	; 366EC
jne short .28	; 366F3
mov al, byte [byte edx+08h]	; 366F5
mov byte [dword esp+040Ch], al	; 366F8
mov al, byte [byte edx+09h]	; 366FF
jmp short .27	; 36702
.26:
mov eax, dword [dword esp+0408h]	; 36704
cmp eax, dword [dword esp+0404h]	; 3670B
jne short .28	; 36712
mov al, byte [byte edx+09h]	; 36714
mov byte [dword esp+040Ch], al	; 36717
mov al, byte [byte edx+08h]	; 3671E
.27:
mov byte [dword esp+040Dh], al	; 36721
.28:
inc dword [dword esp+03F8h]	; 36728
.29:
mov eax, dword [dword esp+03F8h]	; 3672F
cmp eax, dword [dword esp+03F4h]	; 36736
jg short .30	; 3673D
test ebx, ebx	; 3673F
je near PostGameToTeamDb.23	; 36741
.30:
mov ecx, 19h	; 36747
mov edx, 1010101h	; 3674C
lea eax, [dword esp+03B0h]	; 36751
call __STOSB	; 36758
mov dword [dword esp+03F8h], 19h	; 3675D
xor eax, eax	; 36768
mov dword [dword esp+03F8h], eax	; 3676A
.31:
mov eax, dword [dword esp+ebp*4+03D8h]	; 36771
add eax, dword [dword esp+03F8h]	; 36778
mov al, byte [byte eax+028h]	; 3677F
and eax, 0FFh	; 36782
cmp eax, byte 19h	; 36787
jge short .32	; 3678A
xor dl, dl	; 3678C
mov byte [dword esp+eax+03B0h], dl	; 3678E
.32:
mov ecx, dword [dword esp+03F8h]	; 36795
inc ecx	; 3679C
mov dword [dword esp+03F8h], ecx	; 3679D
cmp ecx, byte 8	; 367A4
jl short PostGameToTeamDb.31	; 367A7
xor edx, edx	; 367A9
mov dword [dword esp+03F8h], edx	; 367AB
jmp near .36	; 367B2
.33:
mov eax, ecx	; 367B7
shl eax, 2	; 367B9
mov edx, dword [byte esp+eax+058h]	; 367BC
cmp edx, byte 0FFFFFFFFh	; 367C0
je near .35	; 367C3
mov ebx, edx	; 367C9
lea edx, [dword esp+032Ch]	; 367CB
mov eax, dword [dword esp+03E8h]	; 367D2
call ReadKeyRec	; 367D9
mov ebx, eax	; 367DE
test eax, eax	; 367E0
jne short .34	; 367E2
mov ebx, dword [dword esp+0358h]	; 367E4
lea edx, [dword esp+0360h]	; 367EB
mov eax, dword [dword esp+03E4h]	; 367F2
call ReadSeasonRec	; 367F9
mov ebx, eax	; 367FE
.34:
test ebx, ebx	; 36800
jne near .35	; 36802
mov eax, dword [dword esp+03F8h]	; 36808
cmp byte [dword esp+eax+03B0h], 0	; 3680F
je near .35	; 36817
mov ebx, ebp	; 3681D
shl ebx, 2	; 3681F
sub ebx, ebp	; 36822
shl ebx, 3	; 36824
add ebx, ebp	; 36827
shl ebx, 4	; 36829
shl eax, 4	; 3682C
inc word [edi]	; 3682F
add ebx, eax	; 36832
mov ax, word [dword ebx+dword_DB088]	; 36834
add word [byte edi+02h], ax	; 3683B
mov ax, word [dword ebx+word_DB08A]	; 3683F
add word [byte edi+04h], ax	; 36846
mov ax, word [dword ebx+dword_DB088]	; 3684A
mov dx, word [byte edi+06h]	; 36851
add edx, eax	; 36855
mov word [byte edi+06h], dx	; 36857
mov ax, word [dword ebx+word_DB08A]	; 3685B
mov ecx, edx	; 36862
add ecx, eax	; 36864
mov word [byte edi+06h], cx	; 36866
mov ax, word [dword ebx+word_DB08C]	; 3686A
add word [byte edi+0Ch], ax	; 36871
mov ax, word [dword ebx+word_DB08E]	; 36875
add word [byte edi+010h], ax	; 3687C
mov ax, word [dword ebx+word_DB090]	; 36880
add word [byte edi+08h], ax	; 36887
mov ax, word [dword ebx+word_DB092]	; 3688B
add word [byte edi+0Ah], ax	; 36892
mov ax, word [dword ebx+word_DB096]	; 36896
add word [byte edi+0Eh], ax	; 3689D
mov ebx, dword [dword esp+0358h]	; 368A1
lea edx, [dword esp+0360h]	; 368A8
mov eax, dword [dword esp+03E4h]	; 368AF
call WriteSeasonRec	; 368B6
mov ebx, eax	; 368BB
.35:
inc dword [dword esp+03F8h]	; 368BD
.36:
mov ecx, dword [dword esp+03F8h]	; 368C4
cmp ecx, byte 19h	; 368CB
jge short .37	; 368CE
test ebx, ebx	; 368D0
je near PostGameToTeamDb.33	; 368D2
.37:
xor edi, edi	; 368D8
mov dword [dword esp+03F8h], edi	; 368DA
.38:
mov eax, dword [dword esp+03F8h]	; 368E1
xor cl, cl	; 368E8
mov byte [dword esp+eax+03C9h], cl	; 368EA
lea edi, [byte eax+01h]	; 368F1
mov dword [dword esp+03F8h], edi	; 368F4
cmp edi, byte 3	; 368FB
jl short PostGameToTeamDb.38	; 368FE
xor edx, edx	; 36900
mov dword [dword esp+03F8h], edx	; 36902
.39:
mov eax, dword [dword esp+ebp*4+03D8h]	; 36909
add eax, dword [dword esp+03F8h]	; 36910
mov al, byte [byte eax+024h]	; 36917
and eax, 0FFh	; 3691A
cmp eax, byte 1Ch	; 3691F
jge short .40	; 36922
inc byte [dword esp+eax+03B0h]	; 36924
.40:
mov edi, dword [dword esp+03F8h]	; 3692B
inc edi	; 36932
mov dword [dword esp+03F8h], edi	; 36933
cmp edi, byte 2	; 3693A
jl short PostGameToTeamDb.39	; 3693D
xor edx, edx	; 3693F
mov dword [dword esp+03F8h], edx	; 36941
jmp near .56	; 36948
.41:
mov eax, ecx	; 3694D
shl eax, 2	; 3694F
mov edi, dword [dword esp+eax+0BCh]	; 36952
cmp edi, byte 0FFFFFFFFh	; 36959
je near .55	; 3695C
mov ebx, edi	; 36962
lea edx, [dword esp+032Ch]	; 36964
mov eax, dword [dword esp+03E8h]	; 3696B
call ReadKeyRec	; 36972
mov ebx, eax	; 36977
test eax, eax	; 36979
jne short .42	; 3697B
mov ebx, dword [dword esp+0358h]	; 3697D
lea edx, [dword esp+02F4h]	; 36984
mov eax, dword [dword esp+03E4h]	; 3698B
call ReadGoalieSeasonRec	; 36992
mov ebx, eax	; 36997
.42:
test ebx, ebx	; 36999
jne near .55	; 3699B
mov eax, dword [dword esp+03F8h]	; 369A1
cmp byte [dword esp+eax+03C9h], 0	; 369A8
je near .55	; 369B0
mov eax, ebp	; 369B6
shl eax, 3	; 369B8
add eax, ebp	; 369BB
add eax, eax	; 369BD
mov edi, dword [dword esp+03F8h]	; 369BF
shl edi, 2	; 369C6
sub edi, dword [dword esp+03F8h]	; 369C9
add edi, edi	; 369D0
add edi, eax	; 369D2
cmp word [dword edi+unk_DC240], byte 0	; 369D4
je near .55	; 369DC
inc word [esi]	; 369E2
mov edx, dword [dword edi+unk_DC240-2]	; 369E5
sar edx, 10h	; 369EB
mov eax, edx	; 369EE
sar edx, 1Fh	; 369F0
mov ebx, 3Ch	; 369F3
idiv ebx	; 369F8
mov edx, eax	; 369FA
xor eax, eax	; 369FC
mov ax, word [byte esi+0Ch]	; 369FE
add eax, edx	; 36A02
mov word [byte esi+0Ch], ax	; 36A04
mov ax, word [dword edi+word_DC242]	; 36A08
add word [byte esi+012h], ax	; 36A0F
mov ax, word [dword edi+word_DC244]	; 36A13
add word [byte esi+0Eh], ax	; 36A1A
mov eax, dword [dword esp+ebp+0409h]	; 36A1E
sar eax, 18h	; 36A25
mov dl, byte [dword esp+03F8h]	; 36A28
add dl, 19h	; 36A2F
and edx, 0FFh	; 36A32
cmp eax, edx	; 36A38
jne short .50	; 36A3A
mov ax, word [hmscore]	; 36A3C
mov cx, word [awscore]	; 36A42
cmp ax, cx	; 36A49
jle short .45	; 36A4C
test ebp, ebp	; 36A4E
jne short .44	; 36A50
.43:
inc word [byte esi+02h]	; 36A52
jmp short .47	; 36A56
.44:
inc word [byte esi+04h]	; 36A58
jmp short .47	; 36A5C
.45:
jge short .46	; 36A5E
test ebp, ebp	; 36A60
je short PostGameToTeamDb.44	; 36A62
jmp short PostGameToTeamDb.43	; 36A64
.46:
inc word [byte esi+06h]	; 36A66
.47:
cmp word [awscore], byte 0	; 36A6A
jne short .48	; 36A72
test ebp, ebp	; 36A74
je short .49	; 36A76
.48:
cmp word [hmscore], byte 0	; 36A78
jne short .50	; 36A80
cmp ebp, byte 1	; 36A82
jne short .50	; 36A85
.49:
inc word [byte esi+08h]	; 36A87
.50:
mov cx, word [esi]	; 36A8B
test cx, cx	; 36A8E
je short .51	; 36A91
xor eax, eax	; 36A93
mov ax, word [byte esi+0Eh]	; 36A95
mov edx, eax	; 36A99
shl edx, 2	; 36A9B
sub edx, eax	; 36A9E
shl edx, 3	; 36AA0
add edx, eax	; 36AA3
shl edx, 2	; 36AA5
xor ebx, ebx	; 36AA8
mov bx, cx	; 36AAA
mov eax, edx	; 36AAD
sar edx, 1Fh	; 36AAF
idiv ebx	; 36AB2
mov word [byte esi+010h], ax	; 36AB4
jmp short .52	; 36AB8
.51:
mov word [byte esi+010h], cx	; 36ABA
.52:
mov di, word [byte esi+012h]	; 36ABE
test di, di	; 36AC2
je short .53	; 36AC5
xor edi, edi	; 36AC7
mov di, word [byte esi+012h]	; 36AC9
xor eax, eax	; 36ACD
mov ax, word [byte esi+0Eh]	; 36ACF
mov edx, edi	; 36AD3
sub edx, eax	; 36AD5
mov ebx, edx	; 36AD7
shl ebx, 5	; 36AD9
sub ebx, edx	; 36ADC
shl ebx, 2	; 36ADE
add ebx, edx	; 36AE1
shl ebx, 3	; 36AE3
mov eax, edi	; 36AE6
mov edx, edi	; 36AE8
sar edx, 1Fh	; 36AEA
LD sub, eax, edx	; 36AED
sar eax, 1	; 36AEF
lea edx, [ebx+eax]	; 36AF1
mov eax, edx	; 36AF4
sar edx, 1Fh	; 36AF6
idiv edi	; 36AF9
mov word [byte esi+014h], ax	; 36AFB
jmp short .54	; 36AFF
.53:
mov word [byte esi+014h], di	; 36B01
.54:
mov ebx, dword [dword esp+0358h]	; 36B05
lea edx, [dword esp+02F4h]	; 36B0C
mov eax, dword [dword esp+03E4h]	; 36B13
call WriteGoalieSeasonRec	; 36B1A
mov ebx, eax	; 36B1F
.55:
inc dword [dword esp+03F8h]	; 36B21
.56:
mov ecx, dword [dword esp+03F8h]	; 36B28
cmp ecx, byte 3	; 36B2F
jge short .57	; 36B32
test ebx, ebx	; 36B34
je near PostGameToTeamDb.41	; 36B36
.57:
test ebx, ebx	; 36B3C
jne short .58	; 36B3E
mov ebx, dword [esp]	; 36B40
lea edx, [byte esp+0Ch]	; 36B43
mov eax, dword [dword esp+03ECh]	; 36B47
call WriteTeamRec	; 36B4E
mov ebx, eax	; 36B53
.58:
lea eax, [dword esp+03E0h]	; 36B55
call FileClose	; 36B5C
lea eax, [dword esp+03E4h]	; 36B61
call FileClose	; 36B68
lea eax, [dword esp+03E8h]	; 36B6D
call FileClose	; 36B74
lea eax, [dword esp+03ECh]	; 36B79
call FileClose	; 36B80
mov eax, ebx	; 36B85
add esp, 410h	; 36B87
pop ebp	; 36B8D
pop edi	; 36B8E
pop esi	; 36B8F
ret 8	; 36B90
PlayLeagueGame:
push dword 0C4h	; 36B93
call __CHK	; 36B98
push ebx	; 36B9D
push ecx	; 36B9E
push edx	; 36B9F
push esi	; 36BA0
push edi	; 36BA1
push ebp	; 36BA2
sub esp, 94h	; 36BA3
mov edi, eax	; 36BA9
mov edx, 0FFFFFFFFh	; 36BAB
mov dword [byte esp+06Ch], edx	; 36BB0
mov dword [byte esp+05Ch], edx	; 36BB4
mov dword [byte esp+058h], edx	; 36BB8
mov dword [byte esp+040h], edx	; 36BBC
mov dword [byte esp+064h], edx	; 36BC0
xor edx, edx	; 36BC4
mov dword [byte esp+070h], edx	; 36BC6
mov dword [byte esp+078h], edx	; 36BCA
xor ecx, ecx	; 36BCE
mov dword [dword esp+084h], edx	; 36BD0
mov word [lggameidx], 0FFFFh	; 36BD7
push dword 1E0h	; 36BE0
push dword 280h	; 36BE5
push ecx	; 36BEA
push ecx	; 36BEB
call sub_B2E1B	; 36BEC
add esp, byte 10h	; 36BF1
mov esi, dword [edi]	; 36BF4
test esi, esi	; 36BF6
jl short .1	; 36BF8
mov eax, esi	; 36BFA
call LoadLeagueGameRef	; 36BFC
.1:
mov edx, 3	; 36C01
mov eax, curleague	; 36C06
call LeagueCheckStub	; 36C0B
mov esi, eax	; 36C10
.2:
xor eax, eax	; 36C12
mov dword [dword esp+090h], eax	; 36C14
test esi, esi	; 36C1B
jne short .3	; 36C1D
push savedname	; 36C1F
push leaguesaved	; 36C24
push leagueflags	; 36C29
push humancount	; 36C2E
mov ecx, leaguemaster	; 36C33
mov ebx, masterpw	; 36C38
mov edx, leagueteams	; 36C3D
mov eax, curleague	; 36C42
call ReadLeagueInfo	; 36C47
mov esi, eax	; 36C4C
.3:
test esi, esi	; 36C4E
jne near .9	; 36C50
mov edx, curleague	; 36C56
lea eax, [byte esp+020h]	; 36C5B
call strcpy_	; 36C5F
mov ecx, ds	; 36C64
mov ebx, str_dot	; 36C66
mov edx, ds	; 36C6B
lea eax, [byte esp+020h]	; 36C6D
call _fstrcspn_	; 36C71
xor dl, dl	; 36C76
mov byte [byte esp+eax+020h], dl	; 36C78
test byte [leagueflags], 0Ch	; 36C7C
je near .8	; 36C83
lea eax, [byte esp+04Ch]	; 36C89
push eax	; 36C8D
lea eax, [byte esp+054h]	; 36C8E
push eax	; 36C92
lea eax, [byte esp+05Ch]	; 36C93
push eax	; 36C97
call sub_B2DCA	; 36C98
add esp, byte 0Ch	; 36C9D
push esi	; 36CA0
mov ecx, 0FAh	; 36CA1
mov ebx, 0F8h	; 36CA6
mov edx, ecx	; 36CAB
mov eax, 0F9h	; 36CAD
call SetDialogColors	; 36CB2
test byte [leagueflags], 8	; 36CB7
je short .4	; 36CBE
lea eax, [byte esp+020h]	; 36CC0
mov dword [dword_C7F0B], eax	; 36CC4
push byte 0FFFFFFFFh	; 36CC9
lea eax, [byte esp+050h]	; 36CCB
push eax	; 36CCF
lea eax, [byte esp+058h]	; 36CD0
push eax	; 36CD4
push byte 2	; 36CD5
push unk_C7F1B	; 36CD7
mov ecx, 5	; 36CDC
mov ebx, unk_C7F07	; 36CE1
jmp short .5	; 36CE6
.4:
lea eax, [byte esp+020h]	; 36CE8
mov dword [playerdbsmsg+4], eax	; 36CEC
push byte 0FFFFFFFFh	; 36CF1
lea eax, [byte esp+050h]	; 36CF3
push eax	; 36CF7
lea eax, [byte esp+058h]	; 36CF8
push eax	; 36CFC
push byte 2	; 36CFD
push btn_MasterDB	; 36CFF
mov ecx, 4	; 36D04
mov ebx, playerdbsmsg	; 36D09
.5:
mov edx, 0FFFFFFFFh	; 36D0E
mov eax, edx	; 36D13
call MessageBox	; 36D15
mov dword [byte esp+054h], eax	; 36D1A
cmp dword [byte esp+054h], byte 0	; 36D1E
jne short .7	; 36D23
test byte [leagueflags], 8	; 36D25
je short .6	; 36D2C
call MergeLeagueFiles	; 36D2E
.6:
call UpdateTeamDbs	; 36D33
mov dword [dword esp+090h], 0FFFFFFFFh	; 36D38
jmp short .9	; 36D43
.7:
mov esi, 0FFFFFFFFh	; 36D45
jmp short .9	; 36D4A
.8:
mov ebx, dword [leaguedbnames+10h]	; 36D4C
mov ecx, str_extDB	; 36D52
mov edx, curleague	; 36D57
mov eax, esp	; 36D5C
call MakePath	; 36D5E
mov ebx, 1	; 36D63
mov edx, treeteamnames	; 36D68
mov eax, esp	; 36D6D
call ReadTeamNames	; 36D6F
mov esi, eax	; 36D74
.9:
mov ecx, dword [dword esp+090h]	; 36D76
test ecx, ecx	; 36D7D
jne near PlayLeagueGame.2	; 36D7F
cmp dword [edi], byte 0	; 36D85
jge near .21	; 36D88
mov dword [dword esp+088h], ecx	; 36D8E
test esi, esi	; 36D95
jne short .10	; 36D97
push ecx	; 36D99
mov ecx, 0FAh	; 36D9A
mov ebx, 0F8h	; 36D9F
mov edx, ecx	; 36DA4
mov eax, 0F9h	; 36DA6
call SetDialogColors	; 36DAB
lea edx, [byte esp+044h]	; 36DB0
mov eax, curleague	; 36DB4
call GetLeagueId	; 36DB9
mov dword [lgplayteam], eax	; 36DBE
.10:
test esi, esi	; 36DC3
jne short .11	; 36DC5
cmp dword [lgplayteam], byte 0	; 36DC7
jge short .11	; 36DCE
push lgplayteam	; 36DD0
push str_SelectATeamTo	; 36DD5
push byte 8	; 36DDA
mov ecx, leagueteams	; 36DDC
mov ebx, treeteamnames	; 36DE1
mov edx, humancount	; 36DE6
mov eax, curleague	; 36DEB
call LeagueTeamSelect	; 36DF0
mov dword [dword esp+088h], 0FFFFFFFFh	; 36DF5
.11:
test esi, esi	; 36E00
jne near .18	; 36E02
mov ebx, dword [lgplayteam]	; 36E08
test ebx, ebx	; 36E0E
jl near .18	; 36E10
push esi	; 36E16
xor ecx, ecx	; 36E17
mov edx, leagueteams	; 36E19
mov eax, curleague	; 36E1E
call CheckLeagueDiskSync	; 36E23
mov esi, eax	; 36E28
test eax, eax	; 36E2A
jne near .16	; 36E2C
mov ecx, dword [lgplayteam]	; 36E32
push ecx	; 36E38
push str_02d	; 36E39
lea eax, [byte esp+068h]	; 36E3E
push eax	; 36E42
call sprintf_	; 36E43
add esp, byte 0Ch	; 36E48
lea edx, [byte esp+060h]	; 36E4B
mov eax, str_extxx	; 36E4F
call strcpy_	; 36E54
mov edx, dword [lgplayteam]	; 36E59
mov eax, edx	; 36E5F
shl eax, 4	; 36E61
sub eax, edx	; 36E64
test byte [nosplit eax*2+lgteamflags], 1	; 36E66
je short .12	; 36E6E
mov edx, curleague	; 36E70
jmp short .13	; 36E75
.12:
mov edx, str_floppydrv	; 36E77
.13:
mov eax, savleague1	; 36E7C
call strcpy_	; 36E81
cmp dword [humancount], byte 1	; 36E86
je short .14	; 36E8D
cmp dword [dword esp+088h], byte 0	; 36E8F
jne short .15	; 36E97
.14:
push byte 0	; 36E99
mov ecx, 0FAh	; 36E9B
mov ebx, 0F8h	; 36EA0
mov edx, ecx	; 36EA5
mov eax, 0F9h	; 36EA7
call SetDialogColors	; 36EAC
.15:
mov eax, dword [lgplayteam]	; 36EB1
mov edx, leagueteams	; 36EB6
call AskTeamPassword	; 36EBB
mov esi, eax	; 36EC0
.16:
test esi, esi	; 36EC2
jne short .17	; 36EC4
mov ebx, dword [leaguedbnames+10h]	; 36EC6
mov ecx, str_extDB	; 36ECC
mov edx, curleague	; 36ED1
mov eax, esp	; 36ED6
call MakePath	; 36ED8
xor ebx, ebx	; 36EDD
mov edx, treeteamnames	; 36EDF
mov eax, esp	; 36EE4
call ReadTeamNames	; 36EE6
mov esi, eax	; 36EEB
.17:
test esi, esi	; 36EED
jne short .18	; 36EEF
mov dword [dword esp+084h], 0FFFFFFFFh	; 36EF1
.18:
push byte 20h	; 36EFC
push dword 300h	; 36EFE
push str_Pal18	; 36F03
call sub_8CCA8	; 36F08
add esp, byte 0Ch	; 36F0D
mov dword [dword esp+080h], eax	; 36F10
cmp byte [musicon], 0	; 36F17
je short .19	; 36F1E
cmp dword [songdata], byte 0	; 36F20
je short .19	; 36F27
mov eax, dword [musichandle]	; 36F29
mov ebx, 64h	; 36F2E
mov edx, 3	; 36F33
call sub_8FCDF	; 36F38
.19:
mov ecx, dword [dword esp+080h]	; 36F3D
push ecx	; 36F44
push dword 100h	; 36F45
push byte 0	; 36F4A
call sub_8FFB0	; 36F4C
add esp, byte 0Ch	; 36F51
mov ebx, 10h	; 36F54
mov edx, dword [dword esp+080h]	; 36F59
mov eax, 1	; 36F60
call FadePalStep	; 36F65
mov eax, dword [dword esp+080h]	; 36F6A
push eax	; 36F71
call FreeMemBlock	; 36F72
add esp, byte 4	; 36F77
cmp byte [musicon], 0	; 36F7A
je near .22	; 36F81
cmp dword [songdata], byte 0	; 36F87
je near .22	; 36F8E
.20:
mov eax, dword [musicslot-3]	; 36F94
sar eax, 18h	; 36F99
mov edx, 3	; 36F9C
call sub_8FC8A	; 36FA1
test eax, eax	; 36FA6
je short PlayLeagueGame.20	; 36FA8
mov ebx, dword [songdata]	; 36FAA
push ebx	; 36FB0
call sub_8D2F0	; 36FB1
add esp, byte 4	; 36FB6
xor ecx, ecx	; 36FB9
mov dword [songdata], ecx	; 36FBB
jmp short .22	; 36FC1
.21:
push ecx	; 36FC3
mov ecx, 0FAh	; 36FC4
mov ebx, 0F8h	; 36FC9
mov edx, ecx	; 36FCE
mov eax, 0F9h	; 36FD0
call SetDialogColors	; 36FD5
mov edx, dword [lgplayteam]	; 36FDA
push edx	; 36FE0
push str_02d	; 36FE1
lea eax, [byte esp+068h]	; 36FE6
push eax	; 36FEA
call sprintf_	; 36FEB
add esp, byte 0Ch	; 36FF0
lea edx, [byte esp+060h]	; 36FF3
mov eax, str_extxx	; 36FF7
call strcpy_	; 36FFC
mov eax, dword [lgplayteam]	; 37001
mov edx, leagueteams	; 37006
call AskTeamPassword	; 3700B
mov esi, eax	; 37010
test eax, eax	; 37012
jne short .22	; 37014
mov dword [dword esp+084h], 0FFFFFFFFh	; 37016
.22:
cmp dword [dword esp+084h], byte 0	; 37021
je near .85	; 37029
.23:
mov eax, dword [lggameidx-2]	; 3702F
sar eax, 10h	; 37034
cmp eax, byte 0FFFFFFFFh	; 37037
jne short .24	; 3703A
cmp dword [edi], byte 0	; 3703C
jl short .25	; 3703F
.24:
cmp dword [byte esp+070h], byte 0	; 37041
je short .26	; 37046
.25:
mov ebx, dword [lgplayteam]	; 37048
mov edx, str_extxx	; 3704E
mov eax, savleague1	; 37053
call CalendarScreen	; 37058
mov word [lggameidx], ax	; 3705D
.26:
cmp word [lggameidx], byte 0	; 37063
jl near .80	; 3706B
mov ebx, dword [leaguedbnames+18h]	; 37071
mov ecx, str_extxx	; 37077
mov edx, savleague1	; 3707C
mov eax, esp	; 37081
call MakePath	; 37083
lea edx, [byte esp+06Ch]	; 37088
mov eax, esp	; 3708C
call FileOpenRW	; 3708E
mov esi, eax	; 37093
cmp dword [edi], byte 0	; 37095
jge near .30	; 37098
test eax, eax	; 3709E
jne short .27	; 370A0
mov ecx, 2	; 370A2
xor ebx, ebx	; 370A7
mov edx, word_DDD48	; 370A9
mov eax, dword [byte esp+06Ch]	; 370AE
call FileReadAt	; 370B2
mov esi, eax	; 370B7
.27:
test esi, esi	; 370B9
jne short .28	; 370BB
mov ebx, dword [lggameidx-2]	; 370BD
sar ebx, 10h	; 370C3
mov edx, byte_DDD40	; 370C6
mov eax, dword [byte esp+06Ch]	; 370CB
call ReadSchedGame	; 370CF
mov esi, eax	; 370D4
.28:
test esi, esi	; 370D6
jne short .30	; 370D8
xor eax, eax	; 370DA
mov al, byte [byte_DDD42]	; 370DC
mov edx, dword [lgplayteam]	; 370E1
cmp eax, edx	; 370E7
jne short .29	; 370E9
xor eax, edx	; 370EB
mov al, byte [byte_DDD43]	; 370ED
.29:
mov dword [dword_DDD34], eax	; 370F2
mov dword [dword_DDD3C], 0FFFFFFFFh	; 370F7
mov edx, dword [dword_DDD34]	; 37101
mov eax, edx	; 37107
shl eax, 4	; 37109
sub eax, edx	; 3710C
cmp byte [nosplit eax*2+lgteam_17], 0	; 3710E
jne short .30	; 37116
xor ecx, ecx	; 37118
mov dword [dword_DDD3C], ecx	; 3711A
.30:
lea eax, [byte esp+06Ch]	; 37120
call FileClose	; 37124
cmp dword [dword_DDD3C], byte 0	; 37129
je near .36	; 37130
test esi, esi	; 37136
jne near .33	; 37138
push esi	; 3713E
mov ebx, dword [dword_DDD34]	; 3713F
mov ecx, 0FFFFFFFFh	; 37145
mov edx, leagueteams	; 3714A
mov eax, curleague	; 3714F
call CheckLeagueDiskSync	; 37154
mov esi, eax	; 37159
test eax, eax	; 3715B
jne short .33	; 3715D
mov edx, dword [dword_DDD34]	; 3715F
push edx	; 37165
push str_02d	; 37166
lea eax, [byte esp+068h]	; 3716B
push eax	; 3716F
call sprintf_	; 37170
add esp, byte 0Ch	; 37175
lea edx, [byte esp+060h]	; 37178
mov eax, str_Xx	; 3717C
call strcpy_	; 37181
mov edx, dword [dword_DDD34]	; 37186
mov eax, edx	; 3718C
shl eax, 4	; 3718E
sub eax, edx	; 37191
test byte [nosplit eax*2+lgteamflags], 1	; 37193
je short .31	; 3719B
cmp dword [dword esp+088h], byte 0	; 3719D
je short .31	; 371A5
mov edx, curleague	; 371A7
jmp short .32	; 371AC
.31:
mov edx, str_floppydrv	; 371AE
.32:
mov eax, savleague2	; 371B3
call strcpy_	; 371B8
.33:
test esi, esi	; 371BD
jne short .34	; 371BF
mov ebx, dword [leaguedbnames+18h]	; 371C1
mov ecx, str_Xx	; 371C7
mov edx, savleague2	; 371CC
mov eax, esp	; 371D1
call MakePath	; 371D3
lea edx, [byte esp+05Ch]	; 371D8
mov eax, esp	; 371DC
call FileOpenRW	; 371DE
mov esi, eax	; 371E3
.34:
cmp dword [edi], byte 0	; 371E5
jge short .35	; 371E8
test esi, esi	; 371EA
jne short .35	; 371EC
mov ecx, 2	; 371EE
xor ebx, ebx	; 371F3
mov edx, word_DDD4A	; 371F5
mov eax, dword [byte esp+05Ch]	; 371FA
call FileReadAt	; 371FE
mov esi, eax	; 37203
.35:
lea eax, [byte esp+05Ch]	; 37205
call FileClose	; 37209
test esi, esi	; 3720E
jne short .36	; 37210
mov esi, dword [dword_DDD34]	; 37212
push esi	; 37218
push str_02d	; 37219
lea eax, [byte esp+068h]	; 3721E
push eax	; 37222
call sprintf_	; 37223
add esp, byte 0Ch	; 37228
lea edx, [byte esp+060h]	; 3722B
mov eax, str_Xx	; 3722F
call strcpy_	; 37234
mov eax, dword [dword_DDD34]	; 37239
mov edx, leagueteams	; 3723E
call AskTeamPassword	; 37243
mov esi, eax	; 37248
test eax, eax	; 3724A
je short .36	; 3724C
mov dword [byte esp+078h], 0FFFFFFFFh	; 3724E
.36:
test esi, esi	; 37256
jne near .51	; 37258
cmp dword [edi], byte 0	; 3725E
jl short .37	; 37261
push byte 20h	; 37263
push dword 300h	; 37265
push str_Temp5	; 3726A
call sub_8CCA8	; 3726F
mov esi, eax	; 37274
add esp, byte 0Ch	; 37276
push eax	; 37279
push dword 100h	; 3727A
push byte 0	; 3727F
call sub_8FFB0	; 37281
add esp, byte 0Ch	; 37286
mov ebx, 10h	; 37289
mov edx, esi	; 3728E
mov eax, 1	; 37290
call FadePalStep	; 37295
push esi	; 3729A
call FreeMemBlock	; 3729B
add esp, byte 4	; 372A0
.37:
cmp byte [musicon], 0	; 372A3
je short .39	; 372AA
cmp dword [songdata], byte 0	; 372AC
je short .39	; 372B3
mov eax, dword [musichandle]	; 372B5
mov ebx, 64h	; 372BA
mov edx, 3	; 372BF
call sub_8FCDF	; 372C4
.38:
mov eax, dword [musicslot-3]	; 372C9
sar eax, 18h	; 372CE
mov edx, 3	; 372D1
call sub_8FC8A	; 372D6
test eax, eax	; 372DB
je short PlayLeagueGame.38	; 372DD
mov ecx, dword [songdata]	; 372DF
push ecx	; 372E5
call sub_8D2F0	; 372E6
add esp, byte 4	; 372EB
xor esi, esi	; 372EE
mov dword [songdata], esi	; 372F0
.39:
cmp dword [edi], byte 0	; 372F6
jl short .40	; 372F9
call ShowLoadingScreen	; 372FB
.40:
xor ecx, ecx	; 37300
mov cl, byte [byte_DDD42]	; 37302
cmp ecx, dword [lgplayteam]	; 37308
jne short .41	; 3730E
xor ebx, ebx	; 37310
mov dword [byte esp+074h], ebx	; 37312
mov ebp, 1	; 37316
mov ebx, leagueteams	; 3731B
mov edx, savleague1	; 37320
mov eax, leaguedbfmt	; 37325
call MakeTeamDbFmt	; 3732A
xor ecx, ecx	; 3732F
mov cl, byte [byte_DDD43]	; 37331
mov ebx, leagueteams	; 37337
mov edx, savleague2	; 3733C
jmp short .42	; 37341
.41:
mov dword [byte esp+074h], 1	; 37343
xor ebp, ebp	; 3734B
mov ebx, leagueteams	; 3734D
mov edx, savleague2	; 37352
mov eax, leaguedbfmt	; 37357
call MakeTeamDbFmt	; 3735C
xor ecx, ecx	; 37361
mov cl, byte [byte_DDD43]	; 37363
mov ebx, leagueteams	; 37369
mov edx, savleague1	; 3736E
.42:
mov eax, leaguedbfmt2	; 37373
call MakeTeamDbFmt	; 37378
cmp byte [leaguedbfmt2], 0	; 3737D
jne short .43	; 37384
mov edx, leaguedbfmt	; 37386
mov eax, leaguedbfmt2	; 3738B
call strcpy_	; 37390
.43:
cmp byte [leaguedbfmt], 0	; 37395
jne short .44	; 3739C
mov edx, leaguedbfmt2	; 3739E
mov eax, leaguedbfmt	; 373A3
call strcpy_	; 373A8
.44:
mov eax, dword [lggameidx-2]	; 373AD
sar eax, 10h	; 373B2
mov dword [schedgameidx], eax	; 373B5
cmp word [lggameidx], 444h	; 373BA
jge short .45	; 373C3
or byte [gameopts+1], 2	; 373C5
jmp short .46	; 373CC
.45:
and byte [gameopts+1], 0FDh	; 373CE
.46:
cmp dword [edi], byte 0	; 373D5
jge short .47	; 373D8
mov al, byte [byte_DDD40]	; 373DA
mov byte [byte_DC268], al	; 373DF
mov al, byte [byte_DDD41]	; 373E4
mov byte [byte_DC267], al	; 373E9
xor eax, eax	; 373EE
mov al, byte [byte_DDD42]	; 373F0
mov word [HomeTeam], ax	; 373F5
xor eax, eax	; 373FB
mov al, byte [byte_DDD43]	; 373FD
mov word [VisTeam], ax	; 37402
.47:
call SetupControllers	; 37408
xor esi, esi	; 3740D
cmp dword [edi], byte 0	; 3740F
jge short .49	; 37412
call CheckGameDiskSpace	; 37414
test eax, eax	; 37419
jne short .48	; 3741B
xor edx, edx	; 3741D
mov dl, byte [byte_DC267]	; 3741F
mov al, byte [byte_DC268]	; 37425
call InitGameSummary	; 3742A
xor edx, edx	; 3742F
mov dl, byte [VisTeam]	; 37431
xor eax, eax	; 37437
mov al, byte [HomeTeam]	; 37439
call PreGameScreen	; 3743E
mov esi, eax	; 37443
jmp short .49	; 37445
.48:
mov esi, 4	; 37447
.49:
cmp esi, byte 4	; 3744C
je short .50	; 3744F
mov dword [teamstatscb], GameTeamStatsScreen	; 37451
mov dword [skaterstatscb], GameSkaterStatsScreen	; 3745B
mov dword [goaliestatscb], GameGoalieStatsScreen	; 37465
mov dword [standingscb], GameStandingsScreen	; 3746F
mov dword [standingsmenucb], GameStandingsMenu	; 37479
call InputRemove	; 37483
mov eax, edi	; 37488
call PlayGame	; 3748A
call InputInstall	; 3748F
cmp dword [gameresult], byte 1	; 37494
jne short .51	; 3749B
mov al, byte [hmscore]	; 3749D
mov byte [dword_DDD44], al	; 374A2
mov al, byte [awscore]	; 374A7
mov byte [byte_DDD45], al	; 374AC
jmp short .51	; 374B1
.50:
mov dword [gameresult], 2	; 374B3
.51:
test esi, esi	; 374BD
jne near .77	; 374BF
cmp dword [gameresult], byte 1	; 374C5
jne near .77	; 374CC
mov eax, dword [lggameidx-2]	; 374D2
sar eax, 10h	; 374D7
mov dword [byte esp+07Ch], eax	; 374DA
push esi	; 374DE
call sub_B392C	; 374DF
add esp, byte 4	; 374E4
xor ecx, ecx	; 374E7
mov ebx, str_Easndesk2	; 374E9
cmp byte [fileoncd+06Ah], 1	; 374EE
jne short .52	; 374F5
mov edx, dword [cddriveptr]	; 374F7
jmp short .53	; 374FD
.52:
xor edx, edx	; 374FF
.53:
mov eax, esp	; 37501
call MakePath	; 37503
push byte 0	; 37508
lea eax, [byte esp+04h]	; 3750A
push eax	; 3750E
call sub_8E83C	; 3750F
mov dword [byte esp+070h], eax	; 37514
add esp, byte 8	; 37518
push str_Pal17	; 3751B
push eax	; 37520
call sub_B30B4	; 37521
add esp, byte 8	; 37526
add eax, byte 10h	; 37529
push eax	; 3752C
push dword 100h	; 3752D
push byte 0	; 37532
call sub_B4B88	; 37534
add esp, byte 0Ch	; 37539
mov ebx, dword [byte esp+068h]	; 3753C
push ebx	; 37540
call FreeMemBlock	; 37541
add esp, byte 4	; 37546
mov dl, 17h	; 37549
mov byte [byte esp+060h], dl	; 3754B
mov byte [byte esp+061h], dl	; 3754F
mov byte [byte esp+062h], dl	; 37553
lea eax, [byte esp+060h]	; 37557
push eax	; 3755B
push byte 1	; 3755C
push dword 0F8h	; 3755E
call sub_B4B88	; 37563
add esp, byte 0Ch	; 37568
mov bh, 2Ah	; 3756B
mov byte [byte esp+060h], bh	; 3756D
mov byte [byte esp+061h], bh	; 37571
mov byte [byte esp+062h], bh	; 37575
lea eax, [byte esp+060h]	; 37579
push eax	; 3757D
push byte 1	; 3757E
push dword 0F9h	; 37580
call sub_B4B88	; 37585
add esp, byte 0Ch	; 3758A
mov al, 3Fh	; 3758D
mov byte [byte esp+060h], al	; 3758F
mov byte [byte esp+061h], al	; 37593
mov byte [byte esp+062h], al	; 37597
lea eax, [byte esp+060h]	; 3759B
push eax	; 3759F
push byte 1	; 375A0
push dword 0FAh	; 375A2
call sub_B4B88	; 375A7
add esp, byte 0Ch	; 375AC
push byte 0	; 375AF
mov ecx, 0FAh	; 375B1
mov ebx, 0F8h	; 375B6
mov edx, ecx	; 375BB
mov eax, 0F9h	; 375BD
call SetDialogColors	; 375C2
cmp dword [dword_DDD3C], byte 0	; 375C7
je near .56	; 375CE
push byte 0FFFFFFFFh	; 375D4
mov ebx, dword [dword_DDD34]	; 375D6
mov ecx, 0FFFFFFFFh	; 375DC
mov edx, leagueteams	; 375E1
mov eax, curleague	; 375E6
call CheckLeagueDiskSync	; 375EB
mov esi, eax	; 375F0
test eax, eax	; 375F2
jne short .56	; 375F4
mov eax, dword [dword_DDD34]	; 375F6
push eax	; 375FB
push str_02d	; 375FC
lea eax, [byte esp+068h]	; 37601
push eax	; 37605
call sprintf_	; 37606
add esp, byte 0Ch	; 3760B
lea edx, [byte esp+060h]	; 3760E
mov eax, str_Xx	; 37612
call strcpy_	; 37617
mov edx, dword [dword_DDD34]	; 3761C
mov eax, edx	; 37622
shl eax, 4	; 37624
sub eax, edx	; 37627
test byte [nosplit eax*2+lgteamflags], 1	; 37629
je short .54	; 37631
cmp dword [dword esp+088h], byte 0	; 37633
je short .54	; 3763B
mov edx, curleague	; 3763D
jmp short .55	; 37642
.54:
mov edx, str_floppydrv	; 37644
.55:
mov eax, savleague2	; 37649
call strcpy_	; 3764E
.56:
test esi, esi	; 37653
jne short .57	; 37655
mov ebx, dword [leaguedbnames+18h]	; 37657
mov ecx, str_extxx	; 3765D
mov edx, savleague1	; 37662
mov eax, esp	; 37667
call MakePath	; 37669
lea edx, [byte esp+06Ch]	; 3766E
mov eax, esp	; 37672
call FileOpenRW	; 37674
mov esi, eax	; 37679
cmp dword [dword_DDD3C], byte 0	; 3767B
je short .57	; 37682
test eax, eax	; 37684
jne short .57	; 37686
mov ebx, dword [leaguedbnames+18h]	; 37688
mov ecx, str_Xx	; 3768E
mov edx, savleague2	; 37693
mov eax, esp	; 37698
call MakePath	; 3769A
lea edx, [byte esp+05Ch]	; 3769F
mov eax, esp	; 376A3
call FileOpenRW	; 376A5
mov esi, eax	; 376AA
.57:
test esi, esi	; 376AC
jne short .58	; 376AE
push esi	; 376B0
push esi	; 376B1
push esi	; 376B2
push esi	; 376B3
push esi	; 376B4
mov ecx, 1	; 376B5
mov ebx, updschedmsg	; 376BA
mov edx, 0FFFFFFFFh	; 376BF
mov eax, edx	; 376C4
call MessageBox	; 376C6
mov dword [byte esp+048h], esi	; 376CB
xor bl, bl	; 376CF
mov byte [byte esp+030h], bl	; 376D1
.58:
test esi, esi	; 376D5
jne short .59	; 376D7
mov ecx, str_extDB	; 376D9
mov ebx, str_PINFO	; 376DE
mov edx, savleague1	; 376E3
mov eax, esp	; 376E8
call MakePath	; 376EA
lea edx, [byte esp+064h]	; 376EF
mov eax, esp	; 376F3
call FileOpenWrite	; 376F5
mov esi, eax	; 376FA
.59:
test esi, esi	; 376FC
jne short .60	; 376FE
mov ecx, 2	; 37700
mov ebx, 4	; 37705
lea edx, [byte esp+048h]	; 3770A
mov eax, dword [byte esp+064h]	; 3770E
call FileWriteAt	; 37712
mov esi, eax	; 37717
.60:
test esi, esi	; 37719
jne short .61	; 3771B
mov ecx, 0Dh	; 3771D
mov ebx, 6	; 37722
lea edx, [byte esp+030h]	; 37727
mov eax, dword [byte esp+064h]	; 3772B
call FileWriteAt	; 3772F
mov esi, eax	; 37734
.61:
lea eax, [byte esp+064h]	; 37736
call FileClose	; 3773A
cmp dword [dword_DDD3C], byte 0	; 3773F
je short .65	; 37746
test esi, esi	; 37748
jne short .62	; 3774A
mov ecx, str_extDB	; 3774C
mov ebx, str_PINFO	; 37751
mov edx, savleague2	; 37756
mov eax, esp	; 3775B
call MakePath	; 3775D
lea edx, [byte esp+064h]	; 37762
mov eax, esp	; 37766
call FileOpenWrite	; 37768
mov esi, eax	; 3776D
.62:
test esi, esi	; 3776F
jne short .63	; 37771
mov ecx, 2	; 37773
mov ebx, 4	; 37778
lea edx, [byte esp+048h]	; 3777D
mov eax, dword [byte esp+064h]	; 37781
call FileWriteAt	; 37785
mov esi, eax	; 3778A
.63:
test esi, esi	; 3778C
jne short .64	; 3778E
mov ecx, 0Dh	; 37790
mov ebx, 6	; 37795
lea edx, [byte esp+030h]	; 3779A
mov eax, dword [byte esp+064h]	; 3779E
call FileWriteAt	; 377A2
mov esi, eax	; 377A7
.64:
lea eax, [byte esp+064h]	; 377A9
call FileClose	; 377AD
.65:
test esi, esi	; 377B2
jne short .66	; 377B4
mov ebx, dword [lggameidx-2]	; 377B6
sar ebx, 10h	; 377BC
mov edx, byte_DDD40	; 377BF
mov eax, dword [byte esp+06Ch]	; 377C4
call WriteSchedGame	; 377C8
mov esi, eax	; 377CD
.66:
test esi, esi	; 377CF
jne short .67	; 377D1
cmp dword [dword_DDD3C], byte 0	; 377D3
je short .67	; 377DA
mov ebx, dword [lggameidx-2]	; 377DC
sar ebx, 10h	; 377E2
mov edx, byte_DDD40	; 377E5
mov eax, dword [byte esp+05Ch]	; 377EA
call WriteSchedGame	; 377EE
mov esi, eax	; 377F3
.67:
test esi, esi	; 377F5
jne near .72	; 377F7
mov ax, word [lggameidx]	; 377FD
cmp ax, 444h	; 37803
jl near .70	; 37807
mov ebx, dword [leaguedbnames+10h]	; 3780D
mov ecx, str_extxx	; 37813
mov edx, savleague1	; 37818
mov eax, esp	; 3781D
call MakePath	; 3781F
lea edx, [byte esp+058h]	; 37824
mov eax, esp	; 37828
call FileOpenRW	; 3782A
mov esi, eax	; 3782F
test eax, eax	; 37831
jne short .68	; 37833
mov ebx, dword [lggameidx-2]	; 37835
sar ebx, 10h	; 3783B
mov edx, dword [byte esp+058h]	; 3783E
mov eax, dword [byte esp+06Ch]	; 37842
call UpdatePlayoffSeries	; 37846
mov esi, eax	; 3784B
.68:
lea eax, [byte esp+058h]	; 3784D
call FileClose	; 37851
test esi, esi	; 37856
jne near .72	; 37858
cmp dword [dword_DDD3C], byte 0	; 3785E
je near .72	; 37865
mov ebx, dword [leaguedbnames+10h]	; 3786B
mov ecx, str_Xx	; 37871
mov edx, savleague2	; 37876
mov eax, esp	; 3787B
call MakePath	; 3787D
lea edx, [byte esp+040h]	; 37882
mov eax, esp	; 37886
call FileOpenRW	; 37888
mov esi, eax	; 3788D
test eax, eax	; 3788F
jne short .69	; 37891
mov ebx, dword [lggameidx-2]	; 37893
sar ebx, 10h	; 37899
mov edx, dword [byte esp+040h]	; 3789C
mov eax, dword [byte esp+05Ch]	; 378A0
call UpdatePlayoffSeries	; 378A4
mov esi, eax	; 378A9
.69:
lea eax, [byte esp+040h]	; 378AB
call FileClose	; 378AF
jmp short .72	; 378B4
.70:
mov edx, eax	; 378B6
inc edx	; 378B8
mov word [lggameidx], dx	; 378B9
cmp dx, word [word_DDD48]	; 378C0
jle short .71	; 378C7
mov ecx, 2	; 378C9
xor ebx, ebx	; 378CE
mov edx, lggameidx	; 378D0
mov eax, dword [byte esp+06Ch]	; 378D5
call FileWriteAt	; 378D9
mov esi, eax	; 378DE
.71:
test esi, esi	; 378E0
jne short .72	; 378E2
cmp dword [dword_DDD3C], byte 0	; 378E4
je short .72	; 378EB
mov ax, word [lggameidx]	; 378ED
cmp ax, word [word_DDD4A]	; 378F3
jle short .72	; 378FA
mov ecx, 2	; 378FC
xor ebx, ebx	; 37901
mov edx, lggameidx	; 37903
mov eax, dword [byte esp+05Ch]	; 37908
call FileWriteAt	; 3790C
mov esi, eax	; 37911
.72:
test esi, esi	; 37913
jne near .76	; 37915
push byte 2	; 3791B
mov esi, dword [lgplayteam]	; 3791D
push esi	; 37923
mov ebx, dword [lggameidx-2]	; 37924
sar ebx, 10h	; 3792A
dec ebx	; 3792D
mov ecx, leagueteams	; 3792E
mov edx, str_extxx	; 37933
mov eax, savleague1	; 37938
call UpdateSeasonSchedule	; 3793D
mov esi, eax	; 37942
test eax, eax	; 37944
jne short .73	; 37946
push savleague1	; 37948
mov eax, dword [dword esp+080h]	; 3794D
push eax	; 37954
mov ebx, dword [lgplayteam]	; 37955
mov ecx, dword [byte esp+07Ch]	; 3795B
mov edx, str_extxx	; 3795F
mov eax, savleague1	; 37964
call PostGameToTeamDb	; 37969
mov esi, eax	; 3796E
.73:
test esi, esi	; 37970
jne near .76	; 37972
cmp dword [dword_DDD3C], byte 0	; 37978
je short .74	; 3797F
push byte 2	; 37981
mov ecx, dword [dword_DDD34]	; 37983
push ecx	; 37989
mov ebx, dword [lggameidx-2]	; 3798A
sar ebx, 10h	; 37990
mov ecx, leagueteams	; 37993
mov edx, str_Xx	; 37998
mov eax, savleague2	; 3799D
call UpdateSeasonSchedule	; 379A2
mov esi, eax	; 379A7
test eax, eax	; 379A9
jne short .76	; 379AB
push savleague1	; 379AD
mov esi, dword [dword esp+080h]	; 379B2
push esi	; 379B9
mov ebx, dword [dword_DDD34]	; 379BA
mov ecx, ebp	; 379C0
mov edx, str_Xx	; 379C2
mov eax, savleague2	; 379C7
jmp short .75	; 379CC
.74:
push savleague1	; 379CE
mov ebx, dword [dword esp+080h]	; 379D3
push ebx	; 379DA
mov ebx, dword [dword_DDD34]	; 379DB
mov ecx, ebp	; 379E1
mov edx, str_extxx	; 379E3
mov eax, savleague1	; 379E8
.75:
call PostGameToTeamDb	; 379ED
mov esi, eax	; 379F2
.76:
call RestoreDialogBg	; 379F4
push byte 0	; 379F9
call sub_B392C	; 379FB
add esp, byte 4	; 37A00
.77:
test esi, esi	; 37A03
je short .78	; 37A05
cmp dword [byte esp+078h], byte 0	; 37A07
jne short .78	; 37A0C
cmp esi, byte 4	; 37A0E
je short .78	; 37A11
lea eax, [byte esp+04Ch]	; 37A13
push eax	; 37A17
lea eax, [byte esp+054h]	; 37A18
push eax	; 37A1C
lea eax, [byte esp+05Ch]	; 37A1D
push eax	; 37A21
call sub_B2DCA	; 37A22
add esp, byte 0Ch	; 37A27
push byte 0FFFFFFFFh	; 37A2A
lea eax, [byte esp+050h]	; 37A2C
push eax	; 37A30
lea eax, [byte esp+058h]	; 37A31
push eax	; 37A35
push byte 0	; 37A36
push byte 0	; 37A38
mov ecx, 1	; 37A3A
mov ebx, unk_C7805	; 37A3F
mov edx, 0FFFFFFFFh	; 37A44
mov eax, edx	; 37A49
call MessageBox	; 37A4B
.78:
cmp dword [dword_DDD3C], byte 0	; 37A50
je short .79	; 37A57
lea eax, [byte esp+05Ch]	; 37A59
call FileClose	; 37A5D
.79:
lea eax, [byte esp+06Ch]	; 37A62
call FileClose	; 37A66
.80:
push byte 20h	; 37A6B
push dword 300h	; 37A6D
push str_Temp5	; 37A72
call sub_8CCA8	; 37A77
add esp, byte 0Ch	; 37A7C
mov dword [dword esp+08Ch], eax	; 37A7F
cmp byte [musicon], 0	; 37A86
je short .81	; 37A8D
cmp dword [songdata], byte 0	; 37A8F
je short .81	; 37A96
mov eax, dword [musichandle]	; 37A98
mov ebx, 64h	; 37A9D
mov edx, 3	; 37AA2
call sub_8FCDF	; 37AA7
.81:
mov ecx, dword [dword esp+08Ch]	; 37AAC
push ecx	; 37AB3
push dword 100h	; 37AB4
push byte 0	; 37AB9
call sub_8FFB0	; 37ABB
add esp, byte 0Ch	; 37AC0
mov ebx, 10h	; 37AC3
mov edx, dword [dword esp+08Ch]	; 37AC8
mov eax, 1	; 37ACF
call FadePalStep	; 37AD4
mov eax, dword [dword esp+08Ch]	; 37AD9
push eax	; 37AE0
call FreeMemBlock	; 37AE1
add esp, byte 4	; 37AE6
cmp byte [musicon], 0	; 37AE9
je short .83	; 37AF0
cmp dword [songdata], byte 0	; 37AF2
je short .83	; 37AF9
.82:
mov eax, dword [musicslot-3]	; 37AFB
sar eax, 18h	; 37B00
mov edx, 3	; 37B03
call sub_8FC8A	; 37B08
test eax, eax	; 37B0D
je short PlayLeagueGame.82	; 37B0F
mov ebx, dword [songdata]	; 37B11
push ebx	; 37B17
call sub_8D2F0	; 37B18
add esp, byte 4	; 37B1D
xor ecx, ecx	; 37B20
mov dword [songdata], ecx	; 37B22
.83:
call InputInstall	; 37B28
mov dword [byte esp+070h], 0FFFFFFFFh	; 37B2D
cmp esi, byte 4	; 37B35
jne short .84	; 37B38
xor esi, esi	; 37B3A
.84:
mov ecx, str_SAV	; 37B3C
mov ebx, str_GAME	; 37B41
mov edx, curleague	; 37B46
mov eax, esp	; 37B4B
call MakePath	; 37B4D
cmp word [lggameidx], byte 0	; 37B52
jl short .85	; 37B5A
test esi, esi	; 37B5C
jne short .85	; 37B5E
mov eax, esp	; 37B60
call FileExists	; 37B62
test eax, eax	; 37B67
je near PlayLeagueGame.23	; 37B69
.85:
push dword 1E0h	; 37B6F
push dword 280h	; 37B74
push byte 0	; 37B79
push byte 0	; 37B7B
call sub_B2E1B	; 37B7D
add esp, byte 10h	; 37B82
add esp, 94h	; 37B85
pop ebp	; 37B8B
pop edi	; 37B8C
pop esi	; 37B8D
pop edx	; 37B8E
pop ecx	; 37B8F
pop ebx	; 37B90
ret	; 37B91
; C: src/c/front/calendar/TeamGridHitTest.c
%ifdef CBUILD
%include "c/front/calendar/TeamGridHitTest.inc"
%else
TeamGridHitTest:
push dword 24h	; 37B92
call __CHK	; 37B97
push ecx	; 37B9C
push esi	; 37B9D
push edi	; 37B9E
push ebp	; 37B9F
sub esp, byte 10h	; 37BA0
mov ebp, eax	; 37BA3
mov edi, edx	; 37BA5
mov dword [esp], ebx	; 37BA7
mov dword [byte esp+04h], 0FFFFFFFFh	; 37BAA
xor ecx, ecx	; 37BB2
.1:
xor edx, edx	; 37BB4
.2:
mov eax, ecx	; 37BB6
shl eax, 3	; 37BB8
sub eax, ecx	; 37BBB
add eax, dword [esp]	; 37BBD
mov al, byte [edx+eax]	; 37BC0
and eax, 0FFh	; 37BC3
mov dword [byte esp+08h], eax	; 37BC8
mov eax, edx	; 37BCC
shl eax, 2	; 37BCE
add eax, edx	; 37BD1
mov ebx, eax	; 37BD3
shl eax, 4	; 37BD5
add eax, ebx	; 37BD8
cmp ecx, byte 2	; 37BDA
jge short .3	; 37BDD
lea ebx, [byte eax+040h]	; 37BDF
jmp short .4	; 37BE2
.3:
lea ebx, [byte eax+016h]	; 37BE4
.4:
mov eax, ecx	; 37BE7
shl eax, 2	; 37BE9
sub eax, ecx	; 37BEC
shl eax, 3	; 37BEE
sub eax, ecx	; 37BF1
shl eax, 2	; 37BF3
lea esi, [byte eax+058h]	; 37BF6
mov dword [byte esp+0Ch], esi	; 37BF9
lea esi, [byte ebx+046h]	; 37BFD
add eax, 91h	; 37C00
cmp ebp, ebx	; 37C05
jl short .5	; 37C07
cmp ebp, esi	; 37C09
jg short .5	; 37C0B
cmp edi, dword [byte esp+0Ch]	; 37C0D
jl short .5	; 37C11
cmp edi, eax	; 37C13
jg short .5	; 37C15
mov eax, dword [byte esp+08h]	; 37C17
mov dword [byte esp+04h], eax	; 37C1B
mov ecx, 4	; 37C1F
mov edx, 6	; 37C24
.5:
inc edx	; 37C29
cmp edx, byte 7	; 37C2A
jl short TeamGridHitTest.2	; 37C2D
inc ecx	; 37C2F
cmp ecx, byte 4	; 37C30
jl near TeamGridHitTest.1	; 37C33
mov ecx, dword [byte esp+04h]	; 37C39
cmp ecx, byte 63h	; 37C3D
jne short .6	; 37C40
mov eax, 0FFFFFFFFh	; 37C42
jmp short .x	; 37C47
.6:
mov eax, ecx	; 37C49
.x:
add esp, byte 10h	; 37C4B
pop ebp	; 37C4E
pop edi	; 37C4F
pop esi	; 37C50
pop ecx	; 37C51
ret	; 37C52
%endif ; C
; C: src/c/front/calendar/DrawTeamGridName.c
%ifdef CBUILD
%include "c/front/calendar/DrawTeamGridName.inc"
%else
DrawTeamGridName:
push dword 38h	; 37C53
call __CHK	; 37C58
push esi	; 37C5D
push edi	; 37C5E
push ebp	; 37C5F
sub esp, byte 8	; 37C60
push eax	; 37C63
push edx	; 37C64
push ebx	; 37C65
push ecx	; 37C66
mov edx, dword [dlgtextbg]	; 37C67
mov eax, dword [dlgtextfg]	; 37C6D
call SetTextColors	; 37C72
xor edx, edx	; 37C77
mov dword [byte esp+014h], edx	; 37C79
.1:
xor edi, edi	; 37C7D
.2:
mov edx, dword [byte esp+014h]	; 37C7F
mov eax, edx	; 37C83
shl eax, 3	; 37C85
sub eax, edx	; 37C88
add eax, dword [esp]	; 37C8A
mov al, byte [edi+eax]	; 37C8D
and eax, 0FFh	; 37C90
cmp eax, dword [byte esp+0Ch]	; 37C95
jne near .5	; 37C99
mov eax, edi	; 37C9F
shl eax, 2	; 37CA1
add eax, edi	; 37CA4
mov esi, eax	; 37CA6
shl eax, 4	; 37CA8
add eax, esi	; 37CAB
cmp edx, byte 2	; 37CAD
jge short .3	; 37CB0
lea esi, [byte eax+039h]	; 37CB2
jmp short .4	; 37CB5
.3:
lea esi, [byte eax+0Fh]	; 37CB7
.4:
mov ebp, dword [byte esp+014h]	; 37CBA
mov eax, ebp	; 37CBE
shl eax, 2	; 37CC0
sub eax, ebp	; 37CC3
shl eax, 3	; 37CC5
sub eax, ebp	; 37CC8
shl eax, 2	; 37CCA
lea ebp, [dword eax+097h]	; 37CCD
lea edx, [byte esi+04Dh]	; 37CD3
xor eax, eax	; 37CD6
mov al, byte [byte_D42C3]	; 37CD8
add eax, ebp	; 37CDD
inc eax	; 37CDF
push eax	; 37CE0
push ebp	; 37CE1
push edx	; 37CE2
push esi	; 37CE3
call sub_B4BC4	; 37CE4
add esp, byte 10h	; 37CE9
push byte 0	; 37CEC
push byte 0	; 37CEE
mov eax, dword [byte esp+0Ch]	; 37CF0
push eax	; 37CF4
call sub_91370	; 37CF5
add esp, byte 0Ch	; 37CFA
push dword 1E0h	; 37CFD
push byte 0	; 37D02
push dword 280h	; 37D04
push byte 0	; 37D09
call sub_B4BC4	; 37D0B
add esp, byte 10h	; 37D10
mov edx, dword [byte esp+0Ch]	; 37D13
mov eax, edx	; 37D17
shl eax, 4	; 37D19
sub eax, edx	; 37D1C
add eax, eax	; 37D1E
mov edx, dword [byte esp+08h]	; 37D20
add edx, eax	; 37D24
mov dword [byte esp+010h], edx	; 37D26
push edx	; 37D2A
call fputchar	; 37D2B
add esp, byte 4	; 37D30
sar eax, 1	; 37D33
add esi, byte 2Ah	; 37D35
sub esi, eax	; 37D38
mov ebx, dword [byte esp+010h]	; 37D3A
mov edx, ebp	; 37D3E
mov eax, esi	; 37D40
call PrintShadowText	; 37D42
.5:
inc edi	; 37D47
cmp edi, byte 7	; 37D48
jl near DrawTeamGridName.2	; 37D4B
mov ebx, dword [byte esp+014h]	; 37D51
inc ebx	; 37D55
mov dword [byte esp+014h], ebx	; 37D56
cmp ebx, byte 4	; 37D5A
jl near DrawTeamGridName.1	; 37D5D
add esp, byte 18h	; 37D63
pop ebp	; 37D66
pop edi	; 37D67
pop esi	; 37D68
ret	; 37D69
%endif ; C
; C: src/c/front/calendar/SaveGridCellBg.c
%ifdef CBUILD
%include "c/front/calendar/SaveGridCellBg.inc"
%else
SaveGridCellBg:
push dword 28h	; 37D6A
call __CHK	; 37D6F
push esi	; 37D74
push edi	; 37D75
push ebp	; 37D76
push eax	; 37D77
push edx	; 37D78
push ebx	; 37D79
mov ebp, ecx	; 37D7A
push byte 20h	; 37D7C
push dword 4688h	; 37D7E
push str_Back	; 37D83
call sub_8CCA8	; 37D88
add esp, byte 0Ch	; 37D8D
mov dword [gridcellbuf], eax	; 37D90
mov ebx, 11h	; 37D95
xor edx, edx	; 37D9A
call memset_	; 37D9C
mov eax, dword [gridcellbuf]	; 37DA1
mov word [byte eax+04h], 4Eh	; 37DA6
mov eax, dword [gridcellbuf]	; 37DAC
mov word [byte eax+06h], 41h	; 37DB1
xor edi, edi	; 37DB7
.1:
xor esi, esi	; 37DB9
.2:
mov eax, edi	; 37DBB
shl eax, 3	; 37DBD
sub eax, edi	; 37DC0
add eax, dword [byte esp+04h]	; 37DC2
mov al, byte [esi+eax]	; 37DC6
and eax, 0FFh	; 37DC9
cmp eax, dword [byte esp+08h]	; 37DCE
jne short .5	; 37DD2
mov eax, esi	; 37DD4
shl eax, 2	; 37DD6
add eax, esi	; 37DD9
mov edx, eax	; 37DDB
shl eax, 4	; 37DDD
add eax, edx	; 37DE0
cmp edi, byte 2	; 37DE2
jge short .3	; 37DE5
add eax, byte 3Ch	; 37DE7
jmp short .4	; 37DEA
.3:
add eax, byte 12h	; 37DEC
.4:
mov dword [gridcellx], eax	; 37DEF
mov eax, edi	; 37DF4
shl eax, 2	; 37DF6
sub eax, edi	; 37DF9
shl eax, 3	; 37DFB
sub eax, edi	; 37DFE
shl eax, 2	; 37E00
add eax, byte 54h	; 37E03
mov dword [gridcelly], eax	; 37E06
mov ecx, dword [byte esp+01Ch]	; 37E0B
push ecx	; 37E0F
lea eax, [byte ebp-04h]	; 37E10
push eax	; 37E13
mov eax, dword [byte esp+08h]	; 37E14
push eax	; 37E18
call sub_903F0	; 37E19
add esp, byte 0Ch	; 37E1E
mov edx, dword [gridcelly]	; 37E21
push edx	; 37E27
mov ebx, dword [gridcellx]	; 37E28
push ebx	; 37E2E
mov ecx, dword [gridcellbuf]	; 37E2F
push ecx	; 37E35
call sub_91400	; 37E36
add esp, byte 0Ch	; 37E3B
.5:
inc esi	; 37E3E
cmp esi, byte 7	; 37E3F
jl near SaveGridCellBg.2	; 37E42
inc edi	; 37E48
cmp edi, byte 4	; 37E49
jl near SaveGridCellBg.1	; 37E4C
add esp, byte 0Ch	; 37E52
pop ebp	; 37E55
pop edi	; 37E56
pop esi	; 37E57
ret 4	; 37E58
%endif ; C
; C: src/c/front/calendar/RestoreGridCellBg.c
%ifdef CBUILD
%include "c/front/calendar/RestoreGridCellBg.inc"
%else
RestoreGridCellBg:
push dword 20h	; 37E5B
call __CHK	; 37E60
push ebx	; 37E65
push ecx	; 37E66
push edi	; 37E67
push ebp	; 37E68
mov edx, dword [gridcellbuf]	; 37E69
test edx, edx	; 37E6F
je short .x	; 37E71
mov ebx, dword [gridcelly]	; 37E73
push ebx	; 37E79
mov ecx, dword [gridcellx]	; 37E7A
push ecx	; 37E80
push edx	; 37E81
call sub_903F0	; 37E82
add esp, byte 0Ch	; 37E87
mov edi, dword [gridcellbuf]	; 37E8A
push edi	; 37E90
call FreeMemBlock	; 37E91
add esp, byte 4	; 37E96
xor ebp, ebp	; 37E99
mov dword [gridcellbuf], ebp	; 37E9B
.x:
pop ebp	; 37EA1
pop edi	; 37EA2
pop ecx	; 37EA3
pop ebx	; 37EA4
ret	; 37EA5
%endif ; C
; C: src/c/front/calendar/HighlightGridCell.c
%ifdef CBUILD
%include "c/front/calendar/HighlightGridCell.inc"
%else
HighlightGridCell:
push dword 48h	; 37EA6
call __CHK	; 37EAB
push ecx	; 37EB0
push esi	; 37EB1
push edi	; 37EB2
push ebp	; 37EB3
sub esp, byte 14h	; 37EB4
push eax	; 37EB7
push edx	; 37EB8
push ebx	; 37EB9
xor edi, edi	; 37EBA
.1:
xor esi, esi	; 37EBC
.2:
mov eax, edi	; 37EBE
shl eax, 3	; 37EC0
sub eax, edi	; 37EC3
add eax, dword [byte esp+04h]	; 37EC5
mov al, byte [esi+eax]	; 37EC9
and eax, 0FFh	; 37ECC
cmp eax, dword [byte esp+08h]	; 37ED1
jne near .7	; 37ED5
mov eax, esi	; 37EDB
shl eax, 2	; 37EDD
add eax, esi	; 37EE0
mov edx, eax	; 37EE2
shl eax, 4	; 37EE4
add eax, edx	; 37EE7
cmp edi, byte 2	; 37EE9
jge short .3	; 37EEC
lea edx, [byte eax+03Eh]	; 37EEE
jmp short .4	; 37EF1
.3:
lea edx, [byte eax+014h]	; 37EF3
.4:
mov eax, edi	; 37EF6
shl eax, 2	; 37EF8
sub eax, edi	; 37EFB
shl eax, 3	; 37EFD
sub eax, edi	; 37F00
shl eax, 2	; 37F02
lea ebx, [byte eax+056h]	; 37F05
lea ebp, [byte edx+04Ah]	; 37F08
mov dword [byte esp+0Ch], ebp	; 37F0B
lea ebp, [dword eax+093h]	; 37F0F
mov dword [byte esp+014h], ebp	; 37F15
lea ebp, [byte edx-01h]	; 37F19
mov dword [byte esp+018h], ebp	; 37F1C
lea ebp, [byte eax+055h]	; 37F20
lea ecx, [byte edx+04Bh]	; 37F23
mov dword [byte esp+01Ch], ecx	; 37F26
add eax, 94h	; 37F2A
mov dword [byte esp+010h], eax	; 37F2F
mov ecx, dword [esp]	; 37F33
test ecx, ecx	; 37F36
je short .5	; 37F38
push dword 80h	; 37F3A
mov ecx, dword [byte esp+018h]	; 37F3F
push ecx	; 37F43
mov eax, dword [byte esp+014h]	; 37F44
push eax	; 37F48
push ebx	; 37F49
push edx	; 37F4A
call sub_92F50	; 37F4B
add esp, byte 14h	; 37F50
push dword 80h	; 37F53
mov edx, dword [byte esp+014h]	; 37F58
push edx	; 37F5C
mov ebx, dword [byte esp+024h]	; 37F5D
push ebx	; 37F61
push ebp	; 37F62
mov ecx, dword [byte esp+028h]	; 37F63
push ecx	; 37F67
call sub_92F50	; 37F68
jmp short .6	; 37F6D
.5:
push ecx	; 37F6F
mov eax, dword [byte esp+018h]	; 37F70
push eax	; 37F74
mov ecx, dword [byte esp+014h]	; 37F75
push ecx	; 37F79
push ebx	; 37F7A
push edx	; 37F7B
call sub_93000	; 37F7C
add esp, byte 14h	; 37F81
push byte 0	; 37F84
mov eax, dword [byte esp+014h]	; 37F86
push eax	; 37F8A
mov edx, dword [byte esp+024h]	; 37F8B
push edx	; 37F8F
push ebp	; 37F90
mov ebx, dword [byte esp+028h]	; 37F91
push ebx	; 37F95
call sub_93000	; 37F96
.6:
add esp, byte 14h	; 37F9B
.7:
inc esi	; 37F9E
cmp esi, byte 7	; 37F9F
jl near HighlightGridCell.2	; 37FA2
inc edi	; 37FA8
cmp edi, byte 4	; 37FA9
jl near HighlightGridCell.1	; 37FAC
add esp, byte 20h	; 37FB2
pop ebp	; 37FB5
pop edi	; 37FB6
pop esi	; 37FB7
pop ecx	; 37FB8
ret	; 37FB9
%endif ; C
; C: src/c/front/calendar/DrawTeamGrid.c
%ifdef CBUILD
%include "c/front/calendar/DrawTeamGrid.inc"
%else
DrawTeamGrid:
push dword 0E8h	; 37FBA
call __CHK	; 37FBF
push esi	; 37FC4
push edi	; 37FC5
push ebp	; 37FC6
sub esp, 0C0h	; 37FC7
push eax	; 37FCD
push ebx	; 37FCE
push ecx	; 37FCF
lea eax, [byte esp+074h]	; 37FD0
call strcpy_	; 37FD4
lea edx, [byte esp+074h]	; 37FD9
mov eax, 28h	; 37FDD
call PrintCenteredText	; 37FE2
xor ecx, ecx	; 37FE7
mov ebx, str_Callogo2	; 37FE9
cmp byte [fileoncd+01C2h], 1	; 37FEE
jne short .1	; 37FF5
mov edx, dword [cddriveptr]	; 37FF7
jmp short .2	; 37FFD
.1:
xor edx, edx	; 37FFF
.2:
lea eax, [byte esp+074h]	; 38001
call MakePath	; 38005
push byte 0	; 3800A
lea eax, [byte esp+078h]	; 3800C
push eax	; 38010
call sub_8E83C	; 38011
add esp, byte 8	; 38016
mov dword [dword esp+0C8h], eax	; 38019
xor ebp, ebp	; 38020
.3:
mov edx, dword [nosplit ebp*4+crestnames]	; 38022
push edx	; 38029
mov ebx, dword [dword esp+0CCh]	; 3802A
push ebx	; 38031
call sub_B30B4	; 38032
add esp, byte 8	; 38037
mov dword [byte esp+ebp*4+0Ch], eax	; 3803A
inc ebp	; 3803E
cmp ebp, byte 1Ah	; 3803F
jl short DrawTeamGrid.3	; 38042
xor ebp, ebp	; 38044
.4:
xor edi, edi	; 38046
.5:
mov eax, ebp	; 38048
shl eax, 3	; 3804A
sub eax, ebp	; 3804D
mov esi, dword [byte esp+04h]	; 3804F
add esi, eax	; 38053
movzx esi, byte [edi+esi]	; 38055
cmp esi, byte 63h	; 38059
je short .9	; 3805C
mov eax, edi	; 3805E
shl eax, 2	; 38060
add eax, edi	; 38063
mov edx, eax	; 38065
shl eax, 4	; 38067
add eax, edx	; 3806A
cmp ebp, byte 2	; 3806C
jge short .6	; 3806F
lea ebx, [byte eax+040h]	; 38071
jmp short .7	; 38074
.6:
lea ebx, [byte eax+016h]	; 38076
.7:
mov eax, ebp	; 38079
shl eax, 2	; 3807B
sub eax, ebp	; 3807E
shl eax, 3	; 38080
sub eax, ebp	; 38083
shl eax, 2	; 38085
add eax, byte 58h	; 38088
push eax	; 3808B
push ebx	; 3808C
mov ecx, dword [byte esp+esi*4+014h]	; 3808D
push ecx	; 38091
call sub_91370	; 38092
add esp, byte 0Ch	; 38097
mov eax, esi	; 3809A
shl eax, 4	; 3809C
sub eax, esi	; 3809F
add eax, eax	; 380A1
add eax, dword [byte esp+08h]	; 380A3
cmp byte [byte eax+017h], 1	; 380A7
jne short .8	; 380AB
mov ecx, dword [byte esp+04h]	; 380AD
mov ebx, dword [esp]	; 380B1
mov edx, dword [byte esp+08h]	; 380B4
mov eax, esi	; 380B8
call DrawTeamGridName	; 380BA
.8:
inc edi	; 380BF
cmp edi, byte 7	; 380C0
jl short DrawTeamGrid.5	; 380C3
.9:
inc ebp	; 380C5
cmp ebp, byte 4	; 380C6
jl near DrawTeamGrid.4	; 380C9
mov ebx, dword [dword esp+0C8h]	; 380CF
push ebx	; 380D6
call FreeMemBlock	; 380D7
add esp, byte 4	; 380DC
add esp, 0CCh	; 380DF
pop ebp	; 380E5
pop edi	; 380E6
pop esi	; 380E7
ret	; 380E8
%endif ; C
