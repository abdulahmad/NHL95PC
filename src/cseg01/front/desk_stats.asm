; Sports Central's statistics menu. Writing the current screen out as a text file, the desk exits,
; and one action for each team, skater and goalie category. One module (shared exits).
bits 32
%include "hockey.inc"
section s_17816 progbits alloc exec nowrite align=1
extern __CHK, deskexit, DiskSpaceShort, dword_C65A8, dword_C65AC, dword_DC6A8, dword_DC6B4, dword_DC738
extern exhstate, FadePalStep, fclose_, FileExists, fopen_, fputs_, FreeMemBlock, goaliestatscb
extern LeadersScreen, lgstate, MessageBox, mi_9394Playoffs, mi_9394Season, mi_LeaguePlayoffs, mi_LeagueSeason, mi_PlayoffMode
extern msg_NeedKbytes2, off_C648E, off_C659A, postate, sfpal1, sfpal2, skaterstatscb, sprintf_
extern statscategory, statsfromleague, statsleague, statspal, statspalvalid, statsplayer, statsplayoffs, statsredrawcb
extern statsteamsel, str_NeedKbytesFmt2, str_OUT, str_rt, str_SfPal1, str_SfPal2, str_wt, strcat_
extern strcmp_, strcpy_, strncpy_, sub_8CCA8, sub_8FFB0, teamstatscb, TeamStatsScreen, textgrid
extern unk_C6499, unk_C64F5, unk_C652A, unk_DC340
global WriteScreenTextFile, DeskSetExit1, DeskSetExit2, DeskSetExit3, DeskSetExit3_body, DeskSetExit_ret1, StatsSel9394Season, StatsSel9394Playoffs
global StatsSel_common, StatsSel_x, StatsSelLeague, StatsSelLeaguePlayoffs, StatsSelPlayoffMode, StatsMenuStandings, StatsMenuTeamScoring, StatsMenuTeamDefense
global StatsMenuPenaltyKilling, StatsMenuPowerPlay, StatsMenuTeamPenalties, StatsMenuPoints, StatsMenuGoals, StatsMenuAssists, StatsMenuPPGoals, StatsMenuSHGoals
global StatsMenuPlusMinus, StatsMenuPIM, StatsMenuShootPct, StatsMenuGAA, StatsMenuGoalieWins, StatsMenuSavePct, DeskSetExit3b, ShowPlayerStatsItem
global FreeDeskBuffers
; C: src/c/front/desk_stats/WriteScreenTextFile.c
%ifdef CBUILD
%include "c/front/desk_stats/WriteScreenTextFile.inc"
%else
WriteScreenTextFile:
push dword 0B8h	; 17816
call __CHK	; 1781B
push ebx	; 17820
push ecx	; 17821
push edx	; 17822
push esi	; 17823
push edi	; 17824
sub esp, 8Ch	; 17825
cmp dword [textgrid], byte 0	; 1782B
je near .x	; 17832
mov dword [byte esp+07Ch], 4	; 17838
xor ecx, ecx	; 17840
mov dword [dword esp+080h], ecx	; 17842
mov edx, eax	; 17849
lea eax, [byte esp+068h]	; 1784B
call strcpy_	; 1784F
mov edx, str_OUT	; 17854
lea eax, [byte esp+068h]	; 17859
call strcat_	; 1785D
lea eax, [byte esp+068h]	; 17862
call FileExists	; 17866
test eax, eax	; 1786B
jne short .1	; 1786D
lea edx, [byte esp+07Ch]	; 1786F
call DiskSpaceShort	; 17873
jmp short .2	; 17878
.1:
xor eax, eax	; 1787A
.2:
test eax, eax	; 1787C
je short .3	; 1787E
push eax	; 17880
push str_NeedKbytesFmt2	; 17881
push msg_NeedKbytes2	; 17886
call sprintf_	; 1788B
add esp, byte 0Ch	; 17890
push dword 320h	; 17893
lea eax, [dword esp+088h]	; 17898
push eax	; 1789F
lea eax, [dword esp+090h]	; 178A0
push eax	; 178A7
push byte 0	; 178A8
push byte 0	; 178AA
mov ecx, 3	; 178AC
mov ebx, off_C659A	; 178B1
jmp near .7	; 178B6
.3:
xor ah, ah	; 178BB
mov byte [byte esp+065h], ah	; 178BD
mov edx, str_rt	; 178C1
lea eax, [byte esp+068h]	; 178C6
call fopen_	; 178CA
test eax, eax	; 178CF
je short .4	; 178D1
call fclose_	; 178D3
push byte 0FFFFFFFFh	; 178D8
lea eax, [dword esp+088h]	; 178DA
push eax	; 178E1
lea eax, [dword esp+090h]	; 178E2
push eax	; 178E9
push byte 2	; 178EA
push unk_C6499	; 178EC
mov ecx, 2	; 178F1
mov ebx, off_C648E	; 178F6
mov edx, 0FFFFFFFFh	; 178FB
mov eax, edx	; 17900
call MessageBox	; 17902
cmp eax, byte 1	; 17907
jne near .x	; 1790A
.4:
mov edx, str_wt	; 17910
lea eax, [byte esp+068h]	; 17915
call fopen_	; 17919
mov edi, eax	; 1791E
test eax, eax	; 17920
je short .6	; 17922
mov ecx, dword [textgrid]	; 17924
xor esi, esi	; 1792A
.5:
mov ebx, 64h	; 1792C
mov edx, ecx	; 17931
mov eax, esp	; 17933
call strncpy_	; 17935
mov byte [byte esp+064h], 0Ah	; 1793A
xor dh, dh	; 1793F
mov byte [byte esp+065h], dh	; 17941
mov edx, edi	; 17945
mov eax, esp	; 17947
call fputs_	; 17949
add ecx, byte 64h	; 1794E
inc esi	; 17951
cmp esi, byte 24h	; 17952
jl short WriteScreenTextFile.5	; 17955
mov eax, edi	; 17957
call fclose_	; 17959
push byte 0FFFFFFFFh	; 1795E
lea eax, [dword esp+088h]	; 17960
push eax	; 17967
lea eax, [dword esp+090h]	; 17968
push eax	; 1796F
push byte 0	; 17970
push byte 0	; 17972
mov ecx, 1	; 17974
mov ebx, unk_C64F5	; 17979
jmp short .7	; 1797E
.6:
push byte 0FFFFFFFFh	; 17980
lea eax, [dword esp+088h]	; 17982
push eax	; 17989
lea eax, [dword esp+090h]	; 1798A
push eax	; 17991
push edi	; 17992
push edi	; 17993
mov ecx, 1	; 17994
mov ebx, unk_C652A	; 17999
.7:
mov edx, 0FFFFFFFFh	; 1799E
mov eax, edx	; 179A3
call MessageBox	; 179A5
.x:
add esp, 8Ch	; 179AA
pop edi	; 179B0
pop esi	; 179B1
pop edx	; 179B2
pop ecx	; 179B3
pop ebx	; 179B4
ret	; 179B5
%endif ; C
; C: src/c/front/desk_stats/DeskSetExit1.c
%ifdef CBUILD
%include "c/front/desk_stats/DeskSetExit1.inc"
%else
DeskSetExit1:
push dword 8	; 179B6
call __CHK	; 179BB
push edx	; 179C0
mov edx, 1	; 179C1
mov dword [deskexit], edx	; 179C6
mov eax, edx	; 179CC
pop edx	; 179CE
ret	; 179CF
%endif ; C
; C: src/c/front/desk_stats/DeskSetExit2.c
%ifdef CBUILD
%include "c/front/desk_stats/DeskSetExit2.inc"
%else
DeskSetExit2:
push dword 4	; 179D0
call __CHK	; 179D5
mov dword [deskexit], 2	; 179DA
jmp short DeskSetExit_ret1	; 179E4
%endif ; C
; C: src/c/front/desk_stats/DeskSetExit2.c (DeskSetExit3)
%ifdef CBUILD
%include "c/front/desk_stats/DeskSetExit2.DeskSetExit3.inc"
%else
DeskSetExit3:
push dword 4	; 179E6
DeskSetExit3_body:
call __CHK	; 179EB
mov dword [deskexit], 3	; 179F0
DeskSetExit_ret1:
mov eax, 1	; 179FA
ret	; 179FF
%endif ; C
; C: src/c/front/desk_stats/StatsSel9394Season.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsSel9394Season.inc"
%else
StatsSel9394Season:
push dword 20h	; 17A00
call __CHK	; 17A05
push ebx	; 17A0A
push ecx	; 17A0B
push edx	; 17A0C
push ebp	; 17A0D
cmp dword [statsfromleague], byte 0	; 17A0E
jne short .1	; 17A15
cmp dword [statsplayoffs], byte 0	; 17A17
je near .x	; 17A1E
.1:
mov byte [mi_9394Season], 1	; 17A24
mov dl, 2	; 17A2B
mov byte [mi_PlayoffMode], dl	; 17A2D
mov byte [mi_LeaguePlayoffs], dl	; 17A33
mov byte [mi_LeagueSeason], dl	; 17A39
mov byte [mi_9394Playoffs], dl	; 17A3F
xor ecx, ecx	; 17A45
mov dword [statsfromleague], ecx	; 17A47
cmp dword [statsplayoffs], byte 0	; 17A4D
je short .2	; 17A54
mov dword [statsteamsel], ecx	; 17A56
.2:
xor ebp, ebp	; 17A5C
mov dword [statsplayoffs], ebp	; 17A5E
mov ebx, 1Fh	; 17A64
mov edx, exhstate+4	; 17A69
mov eax, statsleague	; 17A6E
call strncpy_	; 17A73
cmp dword [dword_DC738], byte 0	; 17A78
je short .x	; 17A7F
push unk_DC340	; 17A81
push dword 100h	; 17A86
push ebp	; 17A8B
call sub_8FFB0	; 17A8C
add esp, byte 0Ch	; 17A91
mov ebx, 10h	; 17A94
mov edx, unk_DC340	; 17A99
mov eax, 1	; 17A9E
call FadePalStep	; 17AA3
mov dword [statspalvalid], 1	; 17AA8
mov dword [statspal], unk_DC340	; 17AB2
mov dword [dword_DC6B4], 0FFFFFFFFh	; 17ABC
mov eax, dword [statscategory]	; 17AC6
call dword [statsredrawcb]	; 17ACB
mov dword [statspalvalid], ebp	; 17AD1
mov dword [statspal], ebp	; 17AD7
mov ebx, 10h	; 17ADD
mov edx, unk_DC340	; 17AE2
xor eax, eax	; 17AE7
call FadePalStep	; 17AE9
.x:
pop ebp	; 17AEE
pop edx	; 17AEF
pop ecx	; 17AF0
pop ebx	; 17AF1
ret	; 17AF2
%endif ; C
; C: src/c/front/desk_stats/StatsSel9394Playoffs.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsSel9394Playoffs.inc"
%else
StatsSel9394Playoffs:
push dword 24h	; 17AF3
call __CHK	; 17AF8
push ebx	; 17AFD
push ecx	; 17AFE
push edx	; 17AFF
push esi	; 17B00
push ebp	; 17B01
cmp dword [statsfromleague], byte 0	; 17B02
jne short .1	; 17B09
cmp dword [statsplayoffs], byte 1	; 17B0B
je near StatsSel_x	; 17B12
.1:
mov byte [mi_9394Playoffs], 1	; 17B18
mov dl, 2	; 17B1F
mov byte [mi_PlayoffMode], dl	; 17B21
mov byte [mi_LeaguePlayoffs], dl	; 17B27
mov byte [mi_LeagueSeason], dl	; 17B2D
mov byte [mi_9394Season], dl	; 17B33
xor ecx, ecx	; 17B39
mov dword [statsfromleague], ecx	; 17B3B
cmp dword [statsplayoffs], byte 0	; 17B41
jne short .2	; 17B48
mov dword [statsteamsel], ecx	; 17B4A
.2:
mov ebp, 1	; 17B50
mov dword [statsplayoffs], ebp	; 17B55
mov ebx, 1Fh	; 17B5B
mov edx, exhstate+4	; 17B60
StatsSel_common:
mov eax, statsleague	; 17B65
call strncpy_	; 17B6A
cmp dword [dword_DC738], byte 0	; 17B6F
je short StatsSel_x	; 17B76
push unk_DC340	; 17B78
push dword 100h	; 17B7D
push byte 0	; 17B82
call sub_8FFB0	; 17B84
add esp, byte 0Ch	; 17B89
mov ebx, 10h	; 17B8C
mov edx, unk_DC340	; 17B91
mov eax, ebp	; 17B96
call FadePalStep	; 17B98
mov dword [statspalvalid], ebp	; 17B9D
mov dword [statspal], unk_DC340	; 17BA3
mov dword [dword_DC6B4], 0FFFFFFFFh	; 17BAD
mov eax, dword [statscategory]	; 17BB7
call dword [statsredrawcb]	; 17BBC
xor esi, esi	; 17BC2
mov dword [statspalvalid], esi	; 17BC4
mov dword [statspal], esi	; 17BCA
mov ebx, 10h	; 17BD0
mov edx, unk_DC340	; 17BD5
xor eax, eax	; 17BDA
call FadePalStep	; 17BDC
StatsSel_x:
pop ebp	; 17BE1
pop esi	; 17BE2
pop edx	; 17BE3
pop ecx	; 17BE4
pop ebx	; 17BE5
ret	; 17BE6
%endif ; C
; C: src/c/front/desk_stats/StatsSel9394Playoffs.c (StatsSelLeague)
%ifdef CBUILD
%include "c/front/desk_stats/StatsSel9394Playoffs.StatsSelLeague.inc"
%else
StatsSelLeague:
push dword 24h	; 17BE7
call __CHK	; 17BEC
push ebx	; 17BF1
push ecx	; 17BF2
push edx	; 17BF3
push edi	; 17BF4
push ebp	; 17BF5
cmp dword [statsfromleague], byte 1	; 17BF6
jne short .1	; 17BFD
cmp dword [statsplayoffs], byte 0	; 17BFF
je near .x	; 17C06
.1:
mov byte [mi_LeagueSeason], 1	; 17C0C
mov dl, 2	; 17C13
mov byte [mi_PlayoffMode], dl	; 17C15
mov byte [mi_LeaguePlayoffs], dl	; 17C1B
mov byte [mi_9394Playoffs], dl	; 17C21
mov byte [mi_9394Season], dl	; 17C27
mov dword [statsfromleague], 1	; 17C2D
cmp dword [statsplayoffs], byte 0	; 17C37
je short .2	; 17C3E
xor edi, edi	; 17C40
mov dword [statsteamsel], edi	; 17C42
.2:
xor ebp, ebp	; 17C48
mov dword [statsplayoffs], ebp	; 17C4A
mov ebx, 1Fh	; 17C50
mov edx, lgstate+4	; 17C55
mov eax, statsleague	; 17C5A
call strncpy_	; 17C5F
cmp dword [dword_DC738], byte 0	; 17C64
je short .x	; 17C6B
push unk_DC340	; 17C6D
push dword 100h	; 17C72
push ebp	; 17C77
call sub_8FFB0	; 17C78
add esp, byte 0Ch	; 17C7D
mov ebx, 10h	; 17C80
mov edx, unk_DC340	; 17C85
mov eax, 1	; 17C8A
call FadePalStep	; 17C8F
mov dword [statspalvalid], 1	; 17C94
mov dword [statspal], unk_DC340	; 17C9E
mov dword [dword_DC6B4], 0FFFFFFFFh	; 17CA8
mov eax, dword [statscategory]	; 17CB2
call dword [statsredrawcb]	; 17CB7
mov dword [statspalvalid], ebp	; 17CBD
mov dword [statspal], ebp	; 17CC3
mov ebx, 10h	; 17CC9
mov edx, unk_DC340	; 17CCE
xor eax, eax	; 17CD3
call FadePalStep	; 17CD5
.x:
pop ebp	; 17CDA
pop edi	; 17CDB
pop edx	; 17CDC
pop ecx	; 17CDD
pop ebx	; 17CDE
ret	; 17CDF
%endif ; C
; C: src/c/front/desk_stats/StatsSel9394Playoffs.c (StatsSelLeaguePlayoffs)
%ifdef CBUILD
%include "c/front/desk_stats/StatsSel9394Playoffs.StatsSelLeaguePlayoffs.inc"
%else
StatsSelLeaguePlayoffs:
push dword 24h	; 17CE0
call __CHK	; 17CE5
push ebx	; 17CEA
push ecx	; 17CEB
push edx	; 17CEC
push esi	; 17CED
push ebp	; 17CEE
mov edx, dword [statsfromleague]	; 17CEF
cmp edx, byte 1	; 17CF5
jne short .1	; 17CF8
cmp edx, dword [statsplayoffs]	; 17CFA
jne short .1	; 17D00
mov edx, lgstate+4	; 17D02
mov eax, statsleague	; 17D07
call strcmp_	; 17D0C
test eax, eax	; 17D11
je near StatsSel_x	; 17D13
.1:
mov byte [mi_LeaguePlayoffs], 1	; 17D19
mov dl, 2	; 17D20
mov byte [mi_PlayoffMode], dl	; 17D22
mov byte [mi_LeagueSeason], dl	; 17D28
mov byte [mi_9394Playoffs], dl	; 17D2E
mov byte [mi_9394Season], dl	; 17D34
mov dword [statsfromleague], 1	; 17D3A
mov esi, dword [statsplayoffs]	; 17D44
test esi, esi	; 17D4A
jne short .2	; 17D4C
mov dword [statsteamsel], esi	; 17D4E
.2:
mov ebp, 1	; 17D54
mov dword [statsplayoffs], ebp	; 17D59
mov ebx, 1Fh	; 17D5F
mov edx, lgstate+4	; 17D64
jmp near StatsSel_common	; 17D69
%endif ; C
; C: src/c/front/desk_stats/StatsSel9394Playoffs.c (StatsSelPlayoffMode)
%ifdef CBUILD
%include "c/front/desk_stats/StatsSel9394Playoffs.StatsSelPlayoffMode.inc"
%else
StatsSelPlayoffMode:
push dword 24h	; 17D6E
call __CHK	; 17D73
push ebx	; 17D78
push ecx	; 17D79
push edx	; 17D7A
push esi	; 17D7B
push ebp	; 17D7C
mov edx, dword [statsfromleague]	; 17D7D
cmp edx, byte 1	; 17D83
jne short .1	; 17D86
cmp edx, dword [statsplayoffs]	; 17D88
jne short .1	; 17D8E
mov edx, postate+4	; 17D90
mov eax, statsleague	; 17D95
call strcmp_	; 17D9A
test eax, eax	; 17D9F
je near StatsSel_x	; 17DA1
.1:
mov byte [mi_PlayoffMode], 1	; 17DA7
mov dl, 2	; 17DAE
mov byte [mi_LeaguePlayoffs], dl	; 17DB0
mov byte [mi_LeagueSeason], dl	; 17DB6
mov byte [mi_9394Playoffs], dl	; 17DBC
mov byte [mi_9394Season], dl	; 17DC2
mov dword [statsfromleague], 1	; 17DC8
mov esi, dword [statsplayoffs]	; 17DD2
test esi, esi	; 17DD8
jne short .2	; 17DDA
mov dword [statsteamsel], esi	; 17DDC
.2:
mov ebp, 1	; 17DE2
mov dword [statsplayoffs], ebp	; 17DE7
mov ebx, 1Fh	; 17DED
mov edx, postate+4	; 17DF2
jmp near StatsSel_common	; 17DF7
%endif ; C
; C: src/c/front/desk_stats/StatsMenuStandings.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsMenuStandings.inc"
%else
StatsMenuStandings:
push dword 20h	; 17DFC
call __CHK	; 17E01
push ebx	; 17E06
push ecx	; 17E07
push edx	; 17E08
push esi	; 17E09
mov edx, 5	; 17E0A
mov dword [statscategory], edx	; 17E0F
cmp dword [dword_DC738], byte 0	; 17E15
je near .1	; 17E1C
push byte 20h	; 17E22
push dword 300h	; 17E24
push str_SfPal1	; 17E29
call sub_8CCA8	; 17E2E
add esp, byte 0Ch	; 17E33
mov dword [sfpal1], eax	; 17E36
push eax	; 17E3B
push dword 100h	; 17E3C
push byte 0	; 17E41
call sub_8FFB0	; 17E43
add esp, byte 0Ch	; 17E48
push byte 20h	; 17E4B
push dword 300h	; 17E4D
push str_SfPal2	; 17E52
call sub_8CCA8	; 17E57
add esp, byte 0Ch	; 17E5C
mov dword [sfpal2], eax	; 17E5F
push eax	; 17E64
push dword 100h	; 17E65
push byte 0	; 17E6A
call sub_8FFB0	; 17E6C
add esp, byte 0Ch	; 17E71
mov edx, dword [sfpal1]	; 17E74
mov ebx, 10h	; 17E7A
mov eax, 1	; 17E7F
call FadePalStep	; 17E84
mov ecx, dword [sfpal1]	; 17E89
push ecx	; 17E8F
call FreeMemBlock	; 17E90
add esp, byte 4	; 17E95
mov eax, 5	; 17E98
call TeamStatsScreen	; 17E9D
mov dword [dword_DC6A8], eax	; 17EA2
mov edx, dword [sfpal2]	; 17EA7
mov ebx, 10h	; 17EAD
xor eax, eax	; 17EB2
call FadePalStep	; 17EB4
mov esi, dword [sfpal2]	; 17EB9
push esi	; 17EBF
call FreeMemBlock	; 17EC0
add esp, byte 4	; 17EC5
mov eax, dword [dword_DC6A8]	; 17EC8
pop esi	; 17ECD
pop edx	; 17ECE
pop ecx	; 17ECF
pop ebx	; 17ED0
ret	; 17ED1
.1:
mov eax, edx	; 17ED2
call dword [teamstatscb]	; 17ED4
pop esi	; 17EDA
pop edx	; 17EDB
pop ecx	; 17EDC
pop ebx	; 17EDD
ret	; 17EDE
%endif ; C
; C: src/c/front/desk_stats/StatsMenuTeamScoring.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsMenuTeamScoring.inc"
%else
StatsMenuTeamScoring:
push dword 20h	; 17EDF
call __CHK	; 17EE4
push ebx	; 17EE9
push ecx	; 17EEA
push edx	; 17EEB
push esi	; 17EEC
xor edx, edx	; 17EED
mov dword [statscategory], edx	; 17EEF
cmp dword [dword_DC738], byte 0	; 17EF5
je near .1	; 17EFC
push byte 20h	; 17F02
push dword 300h	; 17F04
push str_SfPal1	; 17F09
call sub_8CCA8	; 17F0E
add esp, byte 0Ch	; 17F13
mov dword [sfpal1], eax	; 17F16
push eax	; 17F1B
push dword 100h	; 17F1C
push byte 0	; 17F21
call sub_8FFB0	; 17F23
add esp, byte 0Ch	; 17F28
push byte 20h	; 17F2B
push dword 300h	; 17F2D
push str_SfPal2	; 17F32
call sub_8CCA8	; 17F37
add esp, byte 0Ch	; 17F3C
mov dword [sfpal2], eax	; 17F3F
push eax	; 17F44
push dword 100h	; 17F45
push byte 0	; 17F4A
call sub_8FFB0	; 17F4C
add esp, byte 0Ch	; 17F51
mov edx, dword [sfpal1]	; 17F54
mov ebx, 10h	; 17F5A
mov eax, 1	; 17F5F
call FadePalStep	; 17F64
mov ecx, dword [sfpal1]	; 17F69
push ecx	; 17F6F
call FreeMemBlock	; 17F70
add esp, byte 4	; 17F75
xor eax, eax	; 17F78
call TeamStatsScreen	; 17F7A
mov dword [dword_DC6A8], eax	; 17F7F
mov edx, dword [sfpal2]	; 17F84
mov ebx, 10h	; 17F8A
xor eax, eax	; 17F8F
call FadePalStep	; 17F91
mov esi, dword [sfpal2]	; 17F96
push esi	; 17F9C
call FreeMemBlock	; 17F9D
add esp, byte 4	; 17FA2
mov eax, dword [dword_DC6A8]	; 17FA5
pop esi	; 17FAA
pop edx	; 17FAB
pop ecx	; 17FAC
pop ebx	; 17FAD
ret	; 17FAE
.1:
xor eax, eax	; 17FAF
call dword [teamstatscb]	; 17FB1
pop esi	; 17FB7
pop edx	; 17FB8
pop ecx	; 17FB9
pop ebx	; 17FBA
ret	; 17FBB
%endif ; C
; C: src/c/front/desk_stats/StatsMenuTeamDefense.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsMenuTeamDefense.inc"
%else
StatsMenuTeamDefense:
push dword 20h	; 17FBC
call __CHK	; 17FC1
push ebx	; 17FC6
push ecx	; 17FC7
push edx	; 17FC8
push esi	; 17FC9
mov edx, 1	; 17FCA
mov dword [statscategory], edx	; 17FCF
cmp dword [dword_DC738], byte 0	; 17FD5
je near .1	; 17FDC
push byte 20h	; 17FE2
push dword 300h	; 17FE4
push str_SfPal1	; 17FE9
call sub_8CCA8	; 17FEE
add esp, byte 0Ch	; 17FF3
mov dword [sfpal1], eax	; 17FF6
push eax	; 17FFB
push dword 100h	; 17FFC
push byte 0	; 18001
call sub_8FFB0	; 18003
add esp, byte 0Ch	; 18008
push byte 20h	; 1800B
push dword 300h	; 1800D
push str_SfPal2	; 18012
call sub_8CCA8	; 18017
add esp, byte 0Ch	; 1801C
mov dword [sfpal2], eax	; 1801F
push eax	; 18024
push dword 100h	; 18025
push byte 0	; 1802A
call sub_8FFB0	; 1802C
add esp, byte 0Ch	; 18031
mov edx, dword [sfpal1]	; 18034
mov ebx, 10h	; 1803A
mov eax, 1	; 1803F
call FadePalStep	; 18044
mov ecx, dword [sfpal1]	; 18049
push ecx	; 1804F
call FreeMemBlock	; 18050
add esp, byte 4	; 18055
mov eax, 1	; 18058
call TeamStatsScreen	; 1805D
mov dword [dword_DC6A8], eax	; 18062
mov edx, dword [sfpal2]	; 18067
mov ebx, 10h	; 1806D
xor eax, eax	; 18072
call FadePalStep	; 18074
mov esi, dword [sfpal2]	; 18079
push esi	; 1807F
call FreeMemBlock	; 18080
add esp, byte 4	; 18085
mov eax, dword [dword_DC6A8]	; 18088
pop esi	; 1808D
pop edx	; 1808E
pop ecx	; 1808F
pop ebx	; 18090
ret	; 18091
.1:
mov eax, edx	; 18092
call dword [teamstatscb]	; 18094
pop esi	; 1809A
pop edx	; 1809B
pop ecx	; 1809C
pop ebx	; 1809D
ret	; 1809E
%endif ; C
; C: src/c/front/desk_stats/StatsMenuPenaltyKilling.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsMenuPenaltyKilling.inc"
%else
StatsMenuPenaltyKilling:
push dword 20h	; 1809F
call __CHK	; 180A4
push ebx	; 180A9
push ecx	; 180AA
push edx	; 180AB
push esi	; 180AC
mov edx, 2	; 180AD
mov dword [statscategory], edx	; 180B2
cmp dword [dword_DC738], byte 0	; 180B8
je near .1	; 180BF
push byte 20h	; 180C5
push dword 300h	; 180C7
push str_SfPal1	; 180CC
call sub_8CCA8	; 180D1
add esp, byte 0Ch	; 180D6
mov dword [sfpal1], eax	; 180D9
push eax	; 180DE
push dword 100h	; 180DF
push byte 0	; 180E4
call sub_8FFB0	; 180E6
add esp, byte 0Ch	; 180EB
push byte 20h	; 180EE
push dword 300h	; 180F0
push str_SfPal2	; 180F5
call sub_8CCA8	; 180FA
add esp, byte 0Ch	; 180FF
mov dword [sfpal2], eax	; 18102
push eax	; 18107
push dword 100h	; 18108
push byte 0	; 1810D
call sub_8FFB0	; 1810F
add esp, byte 0Ch	; 18114
mov edx, dword [sfpal1]	; 18117
mov ebx, 10h	; 1811D
mov eax, 1	; 18122
call FadePalStep	; 18127
mov ecx, dword [sfpal1]	; 1812C
push ecx	; 18132
call FreeMemBlock	; 18133
add esp, byte 4	; 18138
mov eax, 2	; 1813B
call TeamStatsScreen	; 18140
mov dword [dword_DC6A8], eax	; 18145
mov edx, dword [sfpal2]	; 1814A
mov ebx, 10h	; 18150
xor eax, eax	; 18155
call FadePalStep	; 18157
mov esi, dword [sfpal2]	; 1815C
push esi	; 18162
call FreeMemBlock	; 18163
add esp, byte 4	; 18168
mov eax, dword [dword_DC6A8]	; 1816B
pop esi	; 18170
pop edx	; 18171
pop ecx	; 18172
pop ebx	; 18173
ret	; 18174
.1:
mov eax, edx	; 18175
call dword [teamstatscb]	; 18177
pop esi	; 1817D
pop edx	; 1817E
pop ecx	; 1817F
pop ebx	; 18180
ret	; 18181
%endif ; C
; C: src/c/front/desk_stats/StatsMenuPowerPlay.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsMenuPowerPlay.inc"
%else
StatsMenuPowerPlay:
push dword 20h	; 18182
call __CHK	; 18187
push ebx	; 1818C
push ecx	; 1818D
push edx	; 1818E
push esi	; 1818F
mov edx, 3	; 18190
mov dword [statscategory], edx	; 18195
cmp dword [dword_DC738], byte 0	; 1819B
je near .1	; 181A2
push byte 20h	; 181A8
push dword 300h	; 181AA
push str_SfPal1	; 181AF
call sub_8CCA8	; 181B4
add esp, byte 0Ch	; 181B9
mov dword [sfpal1], eax	; 181BC
push eax	; 181C1
push dword 100h	; 181C2
push byte 0	; 181C7
call sub_8FFB0	; 181C9
add esp, byte 0Ch	; 181CE
push byte 20h	; 181D1
push dword 300h	; 181D3
push str_SfPal2	; 181D8
call sub_8CCA8	; 181DD
add esp, byte 0Ch	; 181E2
mov dword [sfpal2], eax	; 181E5
push eax	; 181EA
push dword 100h	; 181EB
push byte 0	; 181F0
call sub_8FFB0	; 181F2
add esp, byte 0Ch	; 181F7
mov edx, dword [sfpal1]	; 181FA
mov ebx, 10h	; 18200
mov eax, 1	; 18205
call FadePalStep	; 1820A
mov ecx, dword [sfpal1]	; 1820F
push ecx	; 18215
call FreeMemBlock	; 18216
add esp, byte 4	; 1821B
mov eax, 3	; 1821E
call TeamStatsScreen	; 18223
mov dword [dword_DC6A8], eax	; 18228
mov edx, dword [sfpal2]	; 1822D
mov ebx, 10h	; 18233
xor eax, eax	; 18238
call FadePalStep	; 1823A
mov esi, dword [sfpal2]	; 1823F
push esi	; 18245
call FreeMemBlock	; 18246
add esp, byte 4	; 1824B
mov eax, dword [dword_DC6A8]	; 1824E
pop esi	; 18253
pop edx	; 18254
pop ecx	; 18255
pop ebx	; 18256
ret	; 18257
.1:
mov eax, edx	; 18258
call dword [teamstatscb]	; 1825A
pop esi	; 18260
pop edx	; 18261
pop ecx	; 18262
pop ebx	; 18263
ret	; 18264
%endif ; C
; C: src/c/front/desk_stats/StatsMenuTeamPenalties.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsMenuTeamPenalties.inc"
%else
StatsMenuTeamPenalties:
push dword 20h	; 18265
call __CHK	; 1826A
push ebx	; 1826F
push ecx	; 18270
push edx	; 18271
push esi	; 18272
mov edx, 4	; 18273
mov dword [statscategory], edx	; 18278
cmp dword [dword_DC738], byte 0	; 1827E
je near .1	; 18285
push byte 20h	; 1828B
push dword 300h	; 1828D
push str_SfPal1	; 18292
call sub_8CCA8	; 18297
add esp, byte 0Ch	; 1829C
mov dword [sfpal1], eax	; 1829F
push eax	; 182A4
push dword 100h	; 182A5
push byte 0	; 182AA
call sub_8FFB0	; 182AC
add esp, byte 0Ch	; 182B1
push byte 20h	; 182B4
push dword 300h	; 182B6
push str_SfPal2	; 182BB
call sub_8CCA8	; 182C0
add esp, byte 0Ch	; 182C5
mov dword [sfpal2], eax	; 182C8
push eax	; 182CD
push dword 100h	; 182CE
push byte 0	; 182D3
call sub_8FFB0	; 182D5
add esp, byte 0Ch	; 182DA
mov edx, dword [sfpal1]	; 182DD
mov ebx, 10h	; 182E3
mov eax, 1	; 182E8
call FadePalStep	; 182ED
mov ecx, dword [sfpal1]	; 182F2
push ecx	; 182F8
call FreeMemBlock	; 182F9
add esp, byte 4	; 182FE
mov eax, 4	; 18301
call TeamStatsScreen	; 18306
mov dword [dword_DC6A8], eax	; 1830B
mov edx, dword [sfpal2]	; 18310
mov ebx, 10h	; 18316
xor eax, eax	; 1831B
call FadePalStep	; 1831D
mov esi, dword [sfpal2]	; 18322
push esi	; 18328
call FreeMemBlock	; 18329
add esp, byte 4	; 1832E
mov eax, dword [dword_DC6A8]	; 18331
pop esi	; 18336
pop edx	; 18337
pop ecx	; 18338
pop ebx	; 18339
ret	; 1833A
.1:
mov eax, edx	; 1833B
call dword [teamstatscb]	; 1833D
pop esi	; 18343
pop edx	; 18344
pop ecx	; 18345
pop ebx	; 18346
ret	; 18347
%endif ; C
; C: src/c/front/desk_stats/StatsMenuPoints.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsMenuPoints.inc"
%else
StatsMenuPoints:
push dword 20h	; 18348
call __CHK	; 1834D
push ebx	; 18352
push ecx	; 18353
push edx	; 18354
push esi	; 18355
xor edx, edx	; 18356
mov dword [statscategory], edx	; 18358
cmp dword [dword_DC738], byte 0	; 1835E
je near .1	; 18365
push byte 20h	; 1836B
push dword 300h	; 1836D
push str_SfPal1	; 18372
call sub_8CCA8	; 18377
add esp, byte 0Ch	; 1837C
mov dword [sfpal1], eax	; 1837F
push eax	; 18384
push dword 100h	; 18385
push byte 0	; 1838A
call sub_8FFB0	; 1838C
add esp, byte 0Ch	; 18391
push byte 20h	; 18394
push dword 300h	; 18396
push str_SfPal2	; 1839B
call sub_8CCA8	; 183A0
add esp, byte 0Ch	; 183A5
mov dword [sfpal2], eax	; 183A8
push eax	; 183AD
push dword 100h	; 183AE
push byte 0	; 183B3
call sub_8FFB0	; 183B5
add esp, byte 0Ch	; 183BA
mov edx, dword [sfpal1]	; 183BD
mov ebx, 10h	; 183C3
mov eax, 1	; 183C8
call FadePalStep	; 183CD
mov ecx, dword [sfpal1]	; 183D2
push ecx	; 183D8
call FreeMemBlock	; 183D9
add esp, byte 4	; 183DE
xor eax, eax	; 183E1
call LeadersScreen	; 183E3
mov dword [dword_DC6A8], eax	; 183E8
mov edx, dword [sfpal2]	; 183ED
mov ebx, 10h	; 183F3
xor eax, eax	; 183F8
call FadePalStep	; 183FA
mov esi, dword [sfpal2]	; 183FF
push esi	; 18405
call FreeMemBlock	; 18406
add esp, byte 4	; 1840B
mov eax, dword [dword_DC6A8]	; 1840E
pop esi	; 18413
pop edx	; 18414
pop ecx	; 18415
pop ebx	; 18416
ret	; 18417
.1:
xor eax, eax	; 18418
call dword [skaterstatscb]	; 1841A
pop esi	; 18420
pop edx	; 18421
pop ecx	; 18422
pop ebx	; 18423
ret	; 18424
%endif ; C
; C: src/c/front/desk_stats/StatsMenuGoals.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsMenuGoals.inc"
%else
StatsMenuGoals:
push dword 20h	; 18425
call __CHK	; 1842A
push ebx	; 1842F
push ecx	; 18430
push edx	; 18431
push esi	; 18432
mov edx, 1	; 18433
mov dword [statscategory], edx	; 18438
cmp dword [dword_DC738], byte 0	; 1843E
je near .1	; 18445
push byte 20h	; 1844B
push dword 300h	; 1844D
push str_SfPal1	; 18452
call sub_8CCA8	; 18457
add esp, byte 0Ch	; 1845C
mov dword [sfpal1], eax	; 1845F
push eax	; 18464
push dword 100h	; 18465
push byte 0	; 1846A
call sub_8FFB0	; 1846C
add esp, byte 0Ch	; 18471
push byte 20h	; 18474
push dword 300h	; 18476
push str_SfPal2	; 1847B
call sub_8CCA8	; 18480
add esp, byte 0Ch	; 18485
mov dword [sfpal2], eax	; 18488
push eax	; 1848D
push dword 100h	; 1848E
push byte 0	; 18493
call sub_8FFB0	; 18495
add esp, byte 0Ch	; 1849A
mov edx, dword [sfpal1]	; 1849D
mov ebx, 10h	; 184A3
mov eax, 1	; 184A8
call FadePalStep	; 184AD
mov ecx, dword [sfpal1]	; 184B2
push ecx	; 184B8
call FreeMemBlock	; 184B9
add esp, byte 4	; 184BE
mov eax, 1	; 184C1
call LeadersScreen	; 184C6
mov dword [dword_DC6A8], eax	; 184CB
mov edx, dword [sfpal2]	; 184D0
mov ebx, 10h	; 184D6
xor eax, eax	; 184DB
call FadePalStep	; 184DD
mov esi, dword [sfpal2]	; 184E2
push esi	; 184E8
call FreeMemBlock	; 184E9
add esp, byte 4	; 184EE
mov eax, dword [dword_DC6A8]	; 184F1
pop esi	; 184F6
pop edx	; 184F7
pop ecx	; 184F8
pop ebx	; 184F9
ret	; 184FA
.1:
mov eax, edx	; 184FB
call dword [skaterstatscb]	; 184FD
pop esi	; 18503
pop edx	; 18504
pop ecx	; 18505
pop ebx	; 18506
ret	; 18507
%endif ; C
; C: src/c/front/desk_stats/StatsMenuAssists.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsMenuAssists.inc"
%else
StatsMenuAssists:
push dword 20h	; 18508
call __CHK	; 1850D
push ebx	; 18512
push ecx	; 18513
push edx	; 18514
push esi	; 18515
mov edx, 2	; 18516
mov dword [statscategory], edx	; 1851B
cmp dword [dword_DC738], byte 0	; 18521
je near .1	; 18528
push byte 20h	; 1852E
push dword 300h	; 18530
push str_SfPal1	; 18535
call sub_8CCA8	; 1853A
add esp, byte 0Ch	; 1853F
mov dword [sfpal1], eax	; 18542
push eax	; 18547
push dword 100h	; 18548
push byte 0	; 1854D
call sub_8FFB0	; 1854F
add esp, byte 0Ch	; 18554
push byte 20h	; 18557
push dword 300h	; 18559
push str_SfPal2	; 1855E
call sub_8CCA8	; 18563
add esp, byte 0Ch	; 18568
mov dword [sfpal2], eax	; 1856B
push eax	; 18570
push dword 100h	; 18571
push byte 0	; 18576
call sub_8FFB0	; 18578
add esp, byte 0Ch	; 1857D
mov edx, dword [sfpal1]	; 18580
mov ebx, 10h	; 18586
mov eax, 1	; 1858B
call FadePalStep	; 18590
mov ecx, dword [sfpal1]	; 18595
push ecx	; 1859B
call FreeMemBlock	; 1859C
add esp, byte 4	; 185A1
mov eax, 2	; 185A4
call LeadersScreen	; 185A9
mov dword [dword_DC6A8], eax	; 185AE
mov edx, dword [sfpal2]	; 185B3
mov ebx, 10h	; 185B9
xor eax, eax	; 185BE
call FadePalStep	; 185C0
mov esi, dword [sfpal2]	; 185C5
push esi	; 185CB
call FreeMemBlock	; 185CC
add esp, byte 4	; 185D1
mov eax, dword [dword_DC6A8]	; 185D4
pop esi	; 185D9
pop edx	; 185DA
pop ecx	; 185DB
pop ebx	; 185DC
ret	; 185DD
.1:
mov eax, edx	; 185DE
call dword [skaterstatscb]	; 185E0
pop esi	; 185E6
pop edx	; 185E7
pop ecx	; 185E8
pop ebx	; 185E9
ret	; 185EA
%endif ; C
; C: src/c/front/desk_stats/StatsMenuPPGoals.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsMenuPPGoals.inc"
%else
StatsMenuPPGoals:
push dword 20h	; 185EB
call __CHK	; 185F0
push ebx	; 185F5
push ecx	; 185F6
push edx	; 185F7
push esi	; 185F8
mov edx, 3	; 185F9
mov dword [statscategory], edx	; 185FE
cmp dword [dword_DC738], byte 0	; 18604
je near .1	; 1860B
push byte 20h	; 18611
push dword 300h	; 18613
push str_SfPal1	; 18618
call sub_8CCA8	; 1861D
add esp, byte 0Ch	; 18622
mov dword [sfpal1], eax	; 18625
push eax	; 1862A
push dword 100h	; 1862B
push byte 0	; 18630
call sub_8FFB0	; 18632
add esp, byte 0Ch	; 18637
push byte 20h	; 1863A
push dword 300h	; 1863C
push str_SfPal2	; 18641
call sub_8CCA8	; 18646
add esp, byte 0Ch	; 1864B
mov dword [sfpal2], eax	; 1864E
push eax	; 18653
push dword 100h	; 18654
push byte 0	; 18659
call sub_8FFB0	; 1865B
add esp, byte 0Ch	; 18660
mov edx, dword [sfpal1]	; 18663
mov ebx, 10h	; 18669
mov eax, 1	; 1866E
call FadePalStep	; 18673
mov ecx, dword [sfpal1]	; 18678
push ecx	; 1867E
call FreeMemBlock	; 1867F
add esp, byte 4	; 18684
mov eax, 3	; 18687
call LeadersScreen	; 1868C
mov dword [dword_DC6A8], eax	; 18691
mov edx, dword [sfpal2]	; 18696
mov ebx, 10h	; 1869C
xor eax, eax	; 186A1
call FadePalStep	; 186A3
mov esi, dword [sfpal2]	; 186A8
push esi	; 186AE
call FreeMemBlock	; 186AF
add esp, byte 4	; 186B4
mov eax, dword [dword_DC6A8]	; 186B7
pop esi	; 186BC
pop edx	; 186BD
pop ecx	; 186BE
pop ebx	; 186BF
ret	; 186C0
.1:
mov eax, edx	; 186C1
call dword [skaterstatscb]	; 186C3
pop esi	; 186C9
pop edx	; 186CA
pop ecx	; 186CB
pop ebx	; 186CC
ret	; 186CD
%endif ; C
; C: src/c/front/desk_stats/StatsMenuSHGoals.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsMenuSHGoals.inc"
%else
StatsMenuSHGoals:
push dword 20h	; 186CE
call __CHK	; 186D3
push ebx	; 186D8
push ecx	; 186D9
push edx	; 186DA
push esi	; 186DB
mov edx, 4	; 186DC
mov dword [statscategory], edx	; 186E1
cmp dword [dword_DC738], byte 0	; 186E7
je near .1	; 186EE
push byte 20h	; 186F4
push dword 300h	; 186F6
push str_SfPal1	; 186FB
call sub_8CCA8	; 18700
add esp, byte 0Ch	; 18705
mov dword [sfpal1], eax	; 18708
push eax	; 1870D
push dword 100h	; 1870E
push byte 0	; 18713
call sub_8FFB0	; 18715
add esp, byte 0Ch	; 1871A
push byte 20h	; 1871D
push dword 300h	; 1871F
push str_SfPal2	; 18724
call sub_8CCA8	; 18729
add esp, byte 0Ch	; 1872E
mov dword [sfpal2], eax	; 18731
push eax	; 18736
push dword 100h	; 18737
push byte 0	; 1873C
call sub_8FFB0	; 1873E
add esp, byte 0Ch	; 18743
mov edx, dword [sfpal1]	; 18746
mov ebx, 10h	; 1874C
mov eax, 1	; 18751
call FadePalStep	; 18756
mov ecx, dword [sfpal1]	; 1875B
push ecx	; 18761
call FreeMemBlock	; 18762
add esp, byte 4	; 18767
mov eax, 4	; 1876A
call LeadersScreen	; 1876F
mov dword [dword_DC6A8], eax	; 18774
mov edx, dword [sfpal2]	; 18779
mov ebx, 10h	; 1877F
xor eax, eax	; 18784
call FadePalStep	; 18786
mov esi, dword [sfpal2]	; 1878B
push esi	; 18791
call FreeMemBlock	; 18792
add esp, byte 4	; 18797
mov eax, dword [dword_DC6A8]	; 1879A
pop esi	; 1879F
pop edx	; 187A0
pop ecx	; 187A1
pop ebx	; 187A2
ret	; 187A3
.1:
mov eax, edx	; 187A4
call dword [skaterstatscb]	; 187A6
pop esi	; 187AC
pop edx	; 187AD
pop ecx	; 187AE
pop ebx	; 187AF
ret	; 187B0
%endif ; C
; C: src/c/front/desk_stats/StatsMenuPlusMinus.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsMenuPlusMinus.inc"
%else
StatsMenuPlusMinus:
push dword 20h	; 187B1
call __CHK	; 187B6
push ebx	; 187BB
push ecx	; 187BC
push edx	; 187BD
push esi	; 187BE
mov edx, 5	; 187BF
mov dword [statscategory], edx	; 187C4
cmp dword [dword_DC738], byte 0	; 187CA
je near .1	; 187D1
push byte 20h	; 187D7
push dword 300h	; 187D9
push str_SfPal1	; 187DE
call sub_8CCA8	; 187E3
add esp, byte 0Ch	; 187E8
mov dword [sfpal1], eax	; 187EB
push eax	; 187F0
push dword 100h	; 187F1
push byte 0	; 187F6
call sub_8FFB0	; 187F8
add esp, byte 0Ch	; 187FD
push byte 20h	; 18800
push dword 300h	; 18802
push str_SfPal2	; 18807
call sub_8CCA8	; 1880C
add esp, byte 0Ch	; 18811
mov dword [sfpal2], eax	; 18814
push eax	; 18819
push dword 100h	; 1881A
push byte 0	; 1881F
call sub_8FFB0	; 18821
add esp, byte 0Ch	; 18826
mov edx, dword [sfpal1]	; 18829
mov ebx, 10h	; 1882F
mov eax, 1	; 18834
call FadePalStep	; 18839
mov ecx, dword [sfpal1]	; 1883E
push ecx	; 18844
call FreeMemBlock	; 18845
add esp, byte 4	; 1884A
mov eax, 5	; 1884D
call LeadersScreen	; 18852
mov dword [dword_DC6A8], eax	; 18857
mov edx, dword [sfpal2]	; 1885C
mov ebx, 10h	; 18862
xor eax, eax	; 18867
call FadePalStep	; 18869
mov esi, dword [sfpal2]	; 1886E
push esi	; 18874
call FreeMemBlock	; 18875
add esp, byte 4	; 1887A
mov eax, dword [dword_DC6A8]	; 1887D
pop esi	; 18882
pop edx	; 18883
pop ecx	; 18884
pop ebx	; 18885
ret	; 18886
.1:
mov eax, edx	; 18887
call dword [skaterstatscb]	; 18889
pop esi	; 1888F
pop edx	; 18890
pop ecx	; 18891
pop ebx	; 18892
ret	; 18893
%endif ; C
; C: src/c/front/desk_stats/StatsMenuPIM.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsMenuPIM.inc"
%else
StatsMenuPIM:
push dword 20h	; 18894
call __CHK	; 18899
push ebx	; 1889E
push ecx	; 1889F
push edx	; 188A0
push esi	; 188A1
mov edx, 6	; 188A2
mov dword [statscategory], edx	; 188A7
cmp dword [dword_DC738], byte 0	; 188AD
je near .1	; 188B4
push byte 20h	; 188BA
push dword 300h	; 188BC
push str_SfPal1	; 188C1
call sub_8CCA8	; 188C6
add esp, byte 0Ch	; 188CB
mov dword [sfpal1], eax	; 188CE
push eax	; 188D3
push dword 100h	; 188D4
push byte 0	; 188D9
call sub_8FFB0	; 188DB
add esp, byte 0Ch	; 188E0
push byte 20h	; 188E3
push dword 300h	; 188E5
push str_SfPal2	; 188EA
call sub_8CCA8	; 188EF
add esp, byte 0Ch	; 188F4
mov dword [sfpal2], eax	; 188F7
push eax	; 188FC
push dword 100h	; 188FD
push byte 0	; 18902
call sub_8FFB0	; 18904
add esp, byte 0Ch	; 18909
mov edx, dword [sfpal1]	; 1890C
mov ebx, 10h	; 18912
mov eax, 1	; 18917
call FadePalStep	; 1891C
mov ecx, dword [sfpal1]	; 18921
push ecx	; 18927
call FreeMemBlock	; 18928
add esp, byte 4	; 1892D
mov eax, 6	; 18930
call LeadersScreen	; 18935
mov dword [dword_DC6A8], eax	; 1893A
mov edx, dword [sfpal2]	; 1893F
mov ebx, 10h	; 18945
xor eax, eax	; 1894A
call FadePalStep	; 1894C
mov esi, dword [sfpal2]	; 18951
push esi	; 18957
call FreeMemBlock	; 18958
add esp, byte 4	; 1895D
mov eax, dword [dword_DC6A8]	; 18960
pop esi	; 18965
pop edx	; 18966
pop ecx	; 18967
pop ebx	; 18968
ret	; 18969
.1:
mov eax, edx	; 1896A
call dword [skaterstatscb]	; 1896C
pop esi	; 18972
pop edx	; 18973
pop ecx	; 18974
pop ebx	; 18975
ret	; 18976
%endif ; C
; C: src/c/front/desk_stats/StatsMenuShootPct.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsMenuShootPct.inc"
%else
StatsMenuShootPct:
push dword 20h	; 18977
call __CHK	; 1897C
push ebx	; 18981
push ecx	; 18982
push edx	; 18983
push esi	; 18984
mov edx, 7	; 18985
mov dword [statscategory], edx	; 1898A
cmp dword [dword_DC738], byte 0	; 18990
je near .1	; 18997
push byte 20h	; 1899D
push dword 300h	; 1899F
push str_SfPal1	; 189A4
call sub_8CCA8	; 189A9
add esp, byte 0Ch	; 189AE
mov dword [sfpal1], eax	; 189B1
push eax	; 189B6
push dword 100h	; 189B7
push byte 0	; 189BC
call sub_8FFB0	; 189BE
add esp, byte 0Ch	; 189C3
push byte 20h	; 189C6
push dword 300h	; 189C8
push str_SfPal2	; 189CD
call sub_8CCA8	; 189D2
add esp, byte 0Ch	; 189D7
mov dword [sfpal2], eax	; 189DA
push eax	; 189DF
push dword 100h	; 189E0
push byte 0	; 189E5
call sub_8FFB0	; 189E7
add esp, byte 0Ch	; 189EC
mov edx, dword [sfpal1]	; 189EF
mov ebx, 10h	; 189F5
mov eax, 1	; 189FA
call FadePalStep	; 189FF
mov ecx, dword [sfpal1]	; 18A04
push ecx	; 18A0A
call FreeMemBlock	; 18A0B
add esp, byte 4	; 18A10
mov eax, 7	; 18A13
call LeadersScreen	; 18A18
mov dword [dword_DC6A8], eax	; 18A1D
mov edx, dword [sfpal2]	; 18A22
mov ebx, 10h	; 18A28
xor eax, eax	; 18A2D
call FadePalStep	; 18A2F
mov esi, dword [sfpal2]	; 18A34
push esi	; 18A3A
call FreeMemBlock	; 18A3B
add esp, byte 4	; 18A40
mov eax, dword [dword_DC6A8]	; 18A43
pop esi	; 18A48
pop edx	; 18A49
pop ecx	; 18A4A
pop ebx	; 18A4B
ret	; 18A4C
.1:
mov eax, edx	; 18A4D
call dword [skaterstatscb]	; 18A4F
pop esi	; 18A55
pop edx	; 18A56
pop ecx	; 18A57
pop ebx	; 18A58
ret	; 18A59
%endif ; C
; C: src/c/front/desk_stats/StatsMenuGAA.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsMenuGAA.inc"
%else
StatsMenuGAA:
push dword 20h	; 18A5A
call __CHK	; 18A5F
push ebx	; 18A64
push ecx	; 18A65
push edx	; 18A66
push esi	; 18A67
mov edx, 8	; 18A68
mov dword [statscategory], edx	; 18A6D
cmp dword [dword_DC738], byte 0	; 18A73
je near .1	; 18A7A
push byte 20h	; 18A80
push dword 300h	; 18A82
push str_SfPal1	; 18A87
call sub_8CCA8	; 18A8C
add esp, byte 0Ch	; 18A91
mov dword [sfpal1], eax	; 18A94
push eax	; 18A99
push dword 100h	; 18A9A
push byte 0	; 18A9F
call sub_8FFB0	; 18AA1
add esp, byte 0Ch	; 18AA6
push byte 20h	; 18AA9
push dword 300h	; 18AAB
push str_SfPal2	; 18AB0
call sub_8CCA8	; 18AB5
add esp, byte 0Ch	; 18ABA
mov dword [sfpal2], eax	; 18ABD
push eax	; 18AC2
push dword 100h	; 18AC3
push byte 0	; 18AC8
call sub_8FFB0	; 18ACA
add esp, byte 0Ch	; 18ACF
mov edx, dword [sfpal1]	; 18AD2
mov ebx, 10h	; 18AD8
mov eax, 1	; 18ADD
call FadePalStep	; 18AE2
mov ecx, dword [sfpal1]	; 18AE7
push ecx	; 18AED
call FreeMemBlock	; 18AEE
add esp, byte 4	; 18AF3
mov eax, 8	; 18AF6
call LeadersScreen	; 18AFB
mov dword [dword_DC6A8], eax	; 18B00
mov edx, dword [sfpal2]	; 18B05
mov ebx, 10h	; 18B0B
xor eax, eax	; 18B10
call FadePalStep	; 18B12
mov esi, dword [sfpal2]	; 18B17
push esi	; 18B1D
call FreeMemBlock	; 18B1E
add esp, byte 4	; 18B23
mov eax, dword [dword_DC6A8]	; 18B26
pop esi	; 18B2B
pop edx	; 18B2C
pop ecx	; 18B2D
pop ebx	; 18B2E
ret	; 18B2F
.1:
mov eax, edx	; 18B30
call dword [goaliestatscb]	; 18B32
pop esi	; 18B38
pop edx	; 18B39
pop ecx	; 18B3A
pop ebx	; 18B3B
ret	; 18B3C
%endif ; C
; C: src/c/front/desk_stats/StatsMenuGoalieWins.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsMenuGoalieWins.inc"
%else
StatsMenuGoalieWins:
push dword 20h	; 18B3D
call __CHK	; 18B42
push ebx	; 18B47
push ecx	; 18B48
push edx	; 18B49
push esi	; 18B4A
mov edx, 9	; 18B4B
mov dword [statscategory], edx	; 18B50
cmp dword [dword_DC738], byte 0	; 18B56
je near .1	; 18B5D
push byte 20h	; 18B63
push dword 300h	; 18B65
push str_SfPal1	; 18B6A
call sub_8CCA8	; 18B6F
add esp, byte 0Ch	; 18B74
mov dword [sfpal1], eax	; 18B77
push eax	; 18B7C
push dword 100h	; 18B7D
push byte 0	; 18B82
call sub_8FFB0	; 18B84
add esp, byte 0Ch	; 18B89
push byte 20h	; 18B8C
push dword 300h	; 18B8E
push str_SfPal2	; 18B93
call sub_8CCA8	; 18B98
add esp, byte 0Ch	; 18B9D
mov dword [sfpal2], eax	; 18BA0
push eax	; 18BA5
push dword 100h	; 18BA6
push byte 0	; 18BAB
call sub_8FFB0	; 18BAD
add esp, byte 0Ch	; 18BB2
mov edx, dword [sfpal1]	; 18BB5
mov ebx, 10h	; 18BBB
mov eax, 1	; 18BC0
call FadePalStep	; 18BC5
mov ecx, dword [sfpal1]	; 18BCA
push ecx	; 18BD0
call FreeMemBlock	; 18BD1
add esp, byte 4	; 18BD6
mov eax, 9	; 18BD9
call LeadersScreen	; 18BDE
mov dword [dword_DC6A8], eax	; 18BE3
mov edx, dword [sfpal2]	; 18BE8
mov ebx, 10h	; 18BEE
xor eax, eax	; 18BF3
call FadePalStep	; 18BF5
mov esi, dword [sfpal2]	; 18BFA
push esi	; 18C00
call FreeMemBlock	; 18C01
add esp, byte 4	; 18C06
mov eax, dword [dword_DC6A8]	; 18C09
pop esi	; 18C0E
pop edx	; 18C0F
pop ecx	; 18C10
pop ebx	; 18C11
ret	; 18C12
.1:
mov eax, edx	; 18C13
call dword [goaliestatscb]	; 18C15
pop esi	; 18C1B
pop edx	; 18C1C
pop ecx	; 18C1D
pop ebx	; 18C1E
ret	; 18C1F
%endif ; C
; C: src/c/front/desk_stats/StatsMenuSavePct.c
%ifdef CBUILD
%include "c/front/desk_stats/StatsMenuSavePct.inc"
%else
StatsMenuSavePct:
push dword 20h	; 18C20
call __CHK	; 18C25
push ebx	; 18C2A
push ecx	; 18C2B
push edx	; 18C2C
push esi	; 18C2D
mov edx, 0Ah	; 18C2E
mov dword [statscategory], edx	; 18C33
cmp dword [dword_DC738], byte 0	; 18C39
je near .1	; 18C40
push byte 20h	; 18C46
push dword 300h	; 18C48
push str_SfPal1	; 18C4D
call sub_8CCA8	; 18C52
add esp, byte 0Ch	; 18C57
mov dword [sfpal1], eax	; 18C5A
push eax	; 18C5F
push dword 100h	; 18C60
push byte 0	; 18C65
call sub_8FFB0	; 18C67
add esp, byte 0Ch	; 18C6C
push byte 20h	; 18C6F
push dword 300h	; 18C71
push str_SfPal2	; 18C76
call sub_8CCA8	; 18C7B
add esp, byte 0Ch	; 18C80
mov dword [sfpal2], eax	; 18C83
push eax	; 18C88
push dword 100h	; 18C89
push byte 0	; 18C8E
call sub_8FFB0	; 18C90
add esp, byte 0Ch	; 18C95
mov edx, dword [sfpal1]	; 18C98
mov ebx, 10h	; 18C9E
mov eax, 1	; 18CA3
call FadePalStep	; 18CA8
mov ecx, dword [sfpal1]	; 18CAD
push ecx	; 18CB3
call FreeMemBlock	; 18CB4
add esp, byte 4	; 18CB9
mov eax, 0Ah	; 18CBC
call LeadersScreen	; 18CC1
mov dword [dword_DC6A8], eax	; 18CC6
mov edx, dword [sfpal2]	; 18CCB
mov ebx, 10h	; 18CD1
xor eax, eax	; 18CD6
call FadePalStep	; 18CD8
mov esi, dword [sfpal2]	; 18CDD
push esi	; 18CE3
call FreeMemBlock	; 18CE4
add esp, byte 4	; 18CE9
mov eax, dword [dword_DC6A8]	; 18CEC
pop esi	; 18CF1
pop edx	; 18CF2
pop ecx	; 18CF3
pop ebx	; 18CF4
ret	; 18CF5
.1:
mov eax, edx	; 18CF6
call dword [goaliestatscb]	; 18CF8
pop esi	; 18CFE
pop edx	; 18CFF
pop ecx	; 18D00
pop ebx	; 18D01
ret	; 18D02
%endif ; C
DeskSetExit3b:
push dword 4	; 18D03
jmp near DeskSetExit3_body	; 18D08
; C: src/c/front/desk_stats/ShowPlayerStatsItem.c
%ifdef CBUILD
%include "c/front/desk_stats/ShowPlayerStatsItem.inc"
%else
ShowPlayerStatsItem:
push dword 4	; 18D0D
call __CHK	; 18D12
cmp byte [statsplayer+2], 47h	; 18D17
setne al	; 18D1E
and eax, 0FFh	; 18D21
add eax, byte 4	; 18D26
mov dword [deskexit], eax	; 18D29
jmp near DeskSetExit_ret1	; 18D2E
%endif ; C
; C: src/c/front/desk_stats/StatsSel9394Playoffs.c (FreeDeskBuffers)
%ifdef CBUILD
%include "c/front/desk_stats/StatsSel9394Playoffs.FreeDeskBuffers.inc"
%else
FreeDeskBuffers:
push dword 1Ch	; 18D33
call __CHK	; 18D38
push ebx	; 18D3D
push ecx	; 18D3E
push edx	; 18D3F
push esi	; 18D40
push ebp	; 18D41
mov edx, dword [dword_C65AC]	; 18D42
test edx, edx	; 18D48
je short .1	; 18D4A
push edx	; 18D4C
call FreeMemBlock	; 18D4D
add esp, byte 4	; 18D52
xor ecx, ecx	; 18D55
mov dword [dword_C65AC], ecx	; 18D57
.1:
mov esi, dword [dword_C65A8]	; 18D5D
test esi, esi	; 18D63
je short .2	; 18D65
push esi	; 18D67
call FreeMemBlock	; 18D68
add esp, byte 4	; 18D6D
xor ebp, ebp	; 18D70
mov dword [dword_C65A8], ebp	; 18D72
.2:
xor eax, eax	; 18D78
jmp near StatsSel_x	; 18D7A
%endif ; C
