; Player, team, and leader statistics, the roster screen, and the sorts behind those lists.
bits 32
%include "hockey.inc"
section s_21CDE progbits alloc exec nowrite align=1
extern __CHK, portraitoncd, cddriveptr, CmpGAA, CmpPoints, DrawPhotoWithPal, dword_DC734, statsfilepos
extern lgstatsfilepos, eastconfname, eastconfteams, fileoncd, FitPlayerName, fputchar, FreeMemBlock, goalieratingnames
extern j___close_, kaufmfont, leadersortfns, leadertitles, lseek_, mainfont, MakePath, MakeStatsTitle
extern memcpy_, skatercardattrs_m3, goaliecardattrs_m3, leadercolhdrs, leadercolhdrs_c1, leadercolhdrs_c2, leadercolhdrs_c3, leadercolhdrs_c4
extern open_, OpenStatsSchedule, PrintCenteredText, printfbuf, PrintFmt1, PrintFmt2, PrintOutlinedText, PrintShadowText
extern qsort_, read_, SetTextColors, skaterratingnames, sprintf_, statsbgnames, statsbgshapes, statsfromleague
extern statsgoaliebuf, statsgoalieorder, statsgoalieplr, statslabels, statsleague, statsnumgoalies, statsnumskaters, statspalshape
extern statsplayer, statsplayerbuf, statsplayerdbs, statsplayoffs, statsskaterbuf, statsskaterorder, statsskaterplr, statssortkeys
extern statsteambuf, statsteamdbs, statsteamrecs, str_A2, str_A3, str_Addsort, str_Addsort2, str_ANA2
extern str_AttDb, str_Bkgd2, str_C, str_C2, str_Center2, str_D2, str_Dashes36, str_Dashes39
extern str_Defense, str_DGoalie, str_EN2, str_fmt2d, str_fmt3d, str_fmt4d, str_fmt5d, str_fmtEmb
extern str_fmtMinSec, str_fmtPct, str_fmtPct0, str_fmtTenths, str_G2, str_G3, str_GA, str_GAA2
extern str_GAA3, str_GloveHand2, str_GP2, str_GP3, str_GP4, str_GP5, str_GP6, str_Gstat
extern str_KeyDb, str_KeyDb2, str_Keys, str_L2, str_L3, str_L4, str_L5, str_LeftWing2
extern str_MightyDucksOfAnaheim, str_MightyDucksOfAnaheim2, str_Min2, str_Min3, str_Name, str_NO, str_No, str_PCT
extern str_Pct2, str_Pct3, str_PIM2, str_PIM3, str_PLAYER2, str_PlayerStats, str_PlayerStats2, str_PlusMinus2
extern str_PlusMinus3, str_PORTR, str_PORTR2, str_Pos, str_POS, str_PPG2, str_Pst1, str_Pst12
extern str_Pst22, str_Pst23, str_Pst24, str_Pst25, str_Pst26, str_Pstat, str_Pstatbar3, str_Pstatbar4
extern str_Pstatbar5, str_Pstatbar6, str_Pstatbar7, str_PT, str_Pt2, str_R, str_R2, str_Ratings2
extern str_Ratings3, str_Regi, str_RightWing2, str_S, str_SA, str_SA2, str_SHG2, str_Shoots2
extern str_Shots2, str_Shots3, str_SO2, str_SS2, str_SS3, str_StatsUnavailable, str_StatsUnavailable2, str_T2
extern str_T3, str_TEAM, str_Teams, str_Trad, str_W2, str_W3, strcat_, strnicmp_
extern AllocMemBlock, LoadBank, TextSaveState, TextRestoreState, TextSetFont, DrawArt, DrawShape, FindShape
extern sub_B30BB, sub_B4BA8, SetClipWindow, teamcolhdrs, teamconf, teamdivflags, teamsortfns, teamstattitles
extern TextGridOff, TextGridOpen, treecol_Er1, treecol_Er2, treecol_Wr2, treecolslots, treecolx, treerowy
extern westconfname, westconfteams
global SkaterStatsCard, GoalieStatsCard, CmpTeamStandings, CmpTeamScoring, CmpTeamScoring_sub, CmpTeamScoring_ret8, CmpTeamScoring_common, CmpTeamDefense
global CmpTeamPP, CmpTeamPP_tie, CmpTeamPK, CmpTeamPK_sub, CmpTeamPK_ret10, CmpTeamPK_x, CmpTeamPenalties, TeamStatsScreen_keyjt
global TeamStatsScreen_coljt, TeamStatsScreen, TeamStatsScreen_keyStand, TeamStatsScreen_keyPK, TeamStatsScreen_keyPP, TeamStatsScreen_keyPen, TeamStatsScreen_colScoring, TeamStatsScreen_colDefense
global TeamStatsScreen_colPK, TeamStatsScreen_colPP, TeamStatsScreen_colPen, PlayerFromMouseY, TeamRosterScreen, CmpGoals, CmpAssists, CmpPPGoals
global CmpSHGoals, CmpPlusMinus, CmpPIM, CmpShootPct, CmpGoalieWins, CmpSavePct, LeadersScreen_coljt, LeadersScreen
global LeadersScreen_colPPG, LeadersScreen_colSHG, LeadersScreen_colPIM, LeadersScreen_colPlusMinus, LeadersScreen_colShootPct, LeadersScreen_colDefault, LeadersScreen_colGAA, LeadersScreen_colWins
global LeadersScreen_colSavePct, stand_tmpl1, stand_tmpl2, CmpConfStandings, CmpConfStandings_m, TeamFromMouse
;-----------------------------------------------------------------------------
; SkaterStatsCard                                                 21CDE  95 PC
; Player Stats card for statsplayer (skater): reads career/season.db + att.db
; + team record, emb<team> background, PORTR photo, position name,
; G/A/Pt/PIM/+-/PPG/SHG/Shots/Pct, Ratings, Shoots L/R
;-----------------------------------------------------------------------------
SkaterStatsCard:
        push dword 138h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, 10Ch
        xor edx, edx
        mov dword [dword esp+0FCh], edx
        mov ebp, statsplayer
        mov eax, dword [mainfont]
        mov dword [dword esp+0F8h], eax
        mov eax, dword [kaufmfont]
        mov dword [dword esp+0100h], eax
        mov eax, dword [statsfromleague]
        mov ebx, dword [nosplit eax*4+statsplayerdbs]
        xor ecx, ecx
        mov edx, statsleague
        lea eax, [dword esp+0B8h]
        call MakePath
        push dword 200h
        lea eax, [dword esp+0BCh]
        push eax
        call open_
        add esp, byte 8
        mov ecx, eax
        xor ebx, ebx
        cmp dword [statsfromleague], byte 0
        jne short .1
        mov edx, dword [statsfilepos]
        jmp short .2
.1:
        mov edx, dword [lgstatsfilepos]
.2:
        mov eax, ecx
        call lseek_
        mov ebx, 28h
        lea edx, [dword esp+090h]
        mov eax, ecx
        call read_
        mov eax, ecx
        call j___close_
        xor ecx, ecx
        mov ebx, str_AttDb
        mov edx, statsleague
        lea eax, [dword esp+0B8h]
        call MakePath
        push dword 200h
        lea eax, [dword esp+0BCh]
        push eax
        call open_
        mov ecx, eax
        add esp, byte 8
        mov edx, dword [byte ebp+024h]
        xor ebx, ebx
        call lseek_
        mov ebx, 14h
        lea edx, [dword esp+0D8h]
        mov eax, ecx
        call read_
        mov eax, ecx
        call j___close_
        mov ebx, dword [statsteamdbs]
        xor ecx, ecx
        mov edx, statsleague
        lea eax, [dword esp+0B8h]
        call MakePath
        push dword 200h
        lea eax, [dword esp+0BCh]
        push eax
        call open_
        mov ecx, eax
        add esp, byte 8
        xor edx, edx
        mov dl, byte [byte ebp+00h]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, eax
        shl edx, 2
        xor ebx, ebx
        mov eax, ecx
        call lseek_
        mov ebx, 5
        lea edx, [dword esp+0ECh]
        mov eax, ecx
        call read_
        mov eax, ecx
        call j___close_
        call sub_B4BA8
        lea eax, [dword esp+0ECh]
        push eax
        push str_fmtEmb
        push printfbuf
        call sprintf_
        add esp, byte 0Ch
        xor ecx, ecx
        mov ebx, printfbuf
        xor eax, eax
        mov al, byte [byte ebp+00h]
        cmp byte [dword eax+fileoncd+070h], 1
        jne short .3
        mov edx, dword [cddriveptr]
        jmp short .4
.3:
        xor edx, edx
.4:
        lea eax, [dword esp+0B8h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0BCh]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        push str_Bkgd2
        push eax
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        push dword 1E0h
        push byte 13h
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        mov edi, dword [statspalshape]
        push edi
        call DrawShape
        add esp, byte 4
        push dword 1E0h
        push byte 0
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        mov eax, dword [statsbgshapes]
        push eax
        call FreeMemBlock
        add esp, byte 4
        cmp byte [byte ebp+030h], 0
        je near .13
        mov edi, esp
        mov esi, str_PORTR
        movsd
        movsw
        lea edx, [byte ebp+030h]
        mov ebx, 4
        lea eax, [byte esp+05h]
        call memcpy_
        mov eax, dword [byte ebp+02Eh]
        sar eax, 18h
        lea edx, [byte eax-030h]
        mov eax, edx
        shl eax, 2
        add edx, eax
        add edx, edx
        mov eax, dword [byte ebp+02Fh]
        sar eax, 18h
        sub eax, byte 30h
        xor bl, bl
        mov byte [byte esp+08h], bl
        xor ecx, ecx
        mov ebx, esp
        cmp byte [dword edx+eax+portraitoncd], 1
        jne short .5
        mov edx, dword [cddriveptr]
        jmp short .6
.5:
        xor edx, edx
.6:
        lea eax, [dword esp+0B8h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0BCh]
        push eax
        call LoadBank
        mov esi, eax
        add esp, byte 8
        lea edx, [byte ebp+030h]
        mov ebx, 4
        mov eax, esp
        call memcpy_
        xor bh, bh
        mov byte [byte esp+04h], bh
        mov eax, esp
        push eax
        push esi
        call sub_B30BB
        mov edi, eax
        add esp, byte 8
        test eax, eax
        je short .9
        mov byte [esp], 21h
        mov eax, esp
        push eax
        push esi
        call sub_B30BB
        add esp, byte 8
        add eax, byte 10h
        mov ecx, 26h
        mov ebx, 21h
        mov edx, edi
        call DrawPhotoWithPal
        push esi
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov ebx, str_Pstatbar3
        cmp byte [fileoncd+013Ch], 1
        jne short .7
        mov edx, dword [cddriveptr]
        jmp short .8
.7:
        xor edx, edx
.8:
        lea eax, [dword esp+0B8h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0BCh]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        push str_Pst1
        jmp short .12
.9:
        push esi
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov ebx, str_Pstatbar3
        cmp byte [fileoncd+013Ch], 1
        jne short .10
        mov edx, dword [cddriveptr]
        jmp short .11
.10:
        xor edx, edx
.11:
        lea eax, [dword esp+0B8h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0BCh]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        push str_Pst22
.12:
        push eax
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        push eax
        call DrawShape
        add esp, byte 4
        mov ebx, dword [statsbgshapes]
        push ebx
        jmp short .16
.13:
        xor ecx, ecx
        mov ebx, str_Pstatbar3
        cmp byte [fileoncd+013Ch], 1
        jne short .14
        mov edx, dword [cddriveptr]
        jmp short .15
.14:
        xor edx, edx
.15:
        lea eax, [dword esp+0B8h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0BCh]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        push str_Pst22
        push eax
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        push eax
        call DrawShape
        add esp, byte 4
        mov edx, dword [statsbgshapes]
        push edx
.16:
        call FreeMemBlock
        add esp, byte 4
        lea eax, [byte esp+050h]
        push eax
        call TextSaveState
        add esp, byte 4
        mov ecx, dword [dword esp+0100h]
        push ecx
        call TextSetFont
        add esp, byte 4
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        mov edi, printfbuf
        mov esi, str_PlayerStats
        movsd
        movsd
        movsd
        movsb
        push printfbuf
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, 140h
        sub edx, eax
        mov eax, edx
        mov ebx, printfbuf
        mov edx, 52h
        call PrintOutlinedText
        call TextGridOpen
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        lea eax, [byte ebp+013h]
        push eax
        lea eax, [byte ebp+03h]
        push eax
        push str_SS2
        push printfbuf
        call sprintf_
        add esp, byte 10h
        mov edx, printfbuf
        mov eax, 98h
        call PrintCenteredText
        xor eax, eax
        mov al, byte [byte ebp+01h]
        push eax
        push str_D2
        push printfbuf
        call sprintf_
        add esp, byte 0Ch
        mov al, byte [byte ebp+02h]
        cmp al, 44h
        jb short .17
        jbe short .18
        cmp al, 4Ch
        jb short .22
        jbe short .19
        cmp al, 52h
        je short .20
        jmp short .22
.17:
        cmp al, 43h
        jne short .22
        mov edx, str_Center2
        jmp short .21
.18:
        mov edx, str_Defense
        jmp short .21
.19:
        mov edx, str_LeftWing2
        jmp short .21
.20:
        mov edx, str_RightWing2
.21:
        mov eax, printfbuf
        call strcat_
.22:
        mov edx, printfbuf
        mov eax, 0B2h
        call PrintCenteredText
        mov esi, dword [dword esp+0F8h]
        push esi
        call TextSetFont
        add esp, byte 4
        mov dword [dword esp+0F4h], 0F3h
        mov ecx, dword [dword esp+0F2h]
        sar ecx, 10h
        mov ebx, str_GP2
        mov edx, ecx
        mov eax, 82h
        call PrintShadowText
        mov ebx, str_G2
        mov edx, ecx
        mov eax, 0AAh
        call PrintShadowText
        mov ebx, str_A2
        mov edx, ecx
        mov eax, 0D2h
        call PrintShadowText
        mov ebx, str_Pt2
        mov edx, ecx
        mov eax, 0FAh
        call PrintShadowText
        mov ebx, str_PIM2
        mov edx, ecx
        mov eax, 122h
        call PrintShadowText
        mov ebx, str_PlusMinus2
        mov edx, ecx
        mov eax, 14Ah
        call PrintShadowText
        mov ebx, str_PPG2
        mov edx, ecx
        mov eax, 186h
        call PrintShadowText
        mov ebx, str_SHG2
        mov edx, ecx
        mov eax, 1AEh
        call PrintShadowText
        mov ebx, str_Shots2
        mov edx, ecx
        mov eax, 1D6h
        call PrintShadowText
        mov ebx, str_Pct2
        mov edx, ecx
        mov eax, 212h
        call PrintShadowText
        lea esi, [dword esp+090h]
        xor ebp, ebp
        mov dword [dword esp+0F4h], 103h
.23:
        mov ebx, dword [nosplit ebp*4+statslabels]
        mov edi, dword [dword esp+0F2h]
        sar edi, 10h
        mov edx, edi
        mov eax, 32h
        call PrintShadowText
        movsx ecx, word [esi]
        mov ebx, str_fmt2d
        mov edx, edi
        mov eax, 82h
        call PrintFmt1
        mov ecx, dword [esi]
        sar ecx, 10h
        mov ebx, str_fmt3d
        mov edx, edi
        mov eax, 0AAh
        call PrintFmt1
        mov ecx, dword [byte esi+02h]
        sar ecx, 10h
        mov ebx, str_fmt3d
        mov edx, edi
        mov eax, 0D2h
        call PrintFmt1
        mov ecx, dword [byte esi+04h]
        sar ecx, 10h
        mov ebx, str_fmt3d
        mov edx, edi
        mov eax, 0FAh
        call PrintFmt1
        mov ecx, dword [byte esi+0Ah]
        sar ecx, 10h
        mov ebx, str_fmt3d
        mov edx, edi
        mov eax, 122h
        call PrintFmt1
        mov ecx, dword [byte esi+0Eh]
        sar ecx, 10h
        mov ebx, str_fmt4d
        mov edx, edi
        mov eax, 14Ah
        call PrintFmt1
        mov ecx, dword [byte esi+06h]
        sar ecx, 10h
        mov ebx, str_fmt3d
        mov edx, edi
        mov eax, 186h
        call PrintFmt1
        mov ecx, dword [byte esi+08h]
        sar ecx, 10h
        mov ebx, str_fmt3d
        mov edx, edi
        mov eax, 1AEh
        call PrintFmt1
        mov ecx, dword [byte esi+0Ch]
        sar ecx, 10h
        mov ebx, str_fmt5d
        mov edx, edi
        mov eax, 1D6h
        call PrintFmt1
        cmp word [byte esi+0Eh], byte 0
        je short .24
        xor edx, edx
        mov dx, word [byte esi+02h]
        mov edi, edx
        shl edi, 5
        sub edi, edx
        shl edi, 2
        add edi, edx
        shl edi, 3
        mov si, word [byte esi+0Eh]
        and esi, 0FFFFh
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        lea edx, [edi+eax]
        mov eax, edx
        sar edx, 1Fh
        idiv esi
        mov edi, eax
        jmp short .25
.24:
        xor edi, edi
.25:
        mov ebx, 0Ah
        mov eax, edi
        mov edx, edi
        sar edx, 1Fh
        idiv ebx
        movsx eax, dx
        push eax
        mov eax, edi
        mov edx, edi
        sar edx, 1Fh
        idiv ebx
        movsx ecx, ax
        mov edx, dword [dword esp+0F6h]
        sar edx, 10h
        mov ebx, str_fmtTenths
        mov eax, 212h
        call PrintFmt2
        lea esi, [dword esp+0A2h]
        add dword [dword esp+0F4h], byte 0Dh
        inc ebp
        cmp ebp, byte 2
        jl near SkaterStatsCard.23
        mov dword [dword esp+0F4h], 131h
        mov eax, dword [dword esp+0F2h]
        sar eax, 10h
        mov edx, str_Ratings2
        call PrintCenteredText
        lea eax, [dword esp+0D8h]
        mov dword [dword esp+0104h], eax
        mov dword [dword esp+0F4h], 143h
        mov ecx, dword [dword esp+0F2h]
        sar ecx, 10h
        mov ebx, str_Shoots2
        mov edx, ecx
        mov eax, 1Eh
        call PrintShadowText
        cmp byte [dword esp+0D8h], 0
        je short .26
        mov ebx, str_L2
        jmp short .27
.26:
        mov ebx, str_R
.27:
        mov edx, ecx
        mov eax, 10Eh
        call PrintShadowText
        xor esi, esi
        mov dword [dword esp+0108h], esi
        xor ebp, ebp
        add dword [dword esp+0F4h], byte 0Dh
.28:
        cmp ebp, byte 7
        jne short .29
        mov dword [dword esp+0108h], 136h
        sub dword [dword esp+0F4h], byte 68h
.29:
        mov ebx, dword [nosplit ebp*4+skaterratingnames]
        mov edi, dword [dword esp+0F2h]
        sar edi, 10h
        mov eax, dword [dword esp+0108h]
        add eax, 1Eh
        cwde
        mov edx, edi
        call PrintShadowText
        mov edx, dword [dword ebp+skatercardattrs_m3]
        sar edx, 18h
        add edx, dword [dword esp+0104h]
        xor eax, eax
        mov al, byte [edx]
        add eax, byte 5
        mov esi, eax
        shl esi, 2
        add esi, eax
        movsx ecx, si
        mov eax, dword [dword esp+0108h]
        add eax, 10Eh
        cwde
        mov ebx, str_fmt3d
        mov edx, edi
        call PrintFmt1
        add dword [dword esp+0F4h], byte 0Dh
        inc ebp
        cmp ebp, byte 0Eh
        jl near SkaterStatsCard.28
        lea eax, [byte esp+050h]
        push eax
        call TextRestoreState
        add esp, byte 4
        call TextGridOff
        mov eax, dword [dword esp+0FCh]
        add esp, 10Ch
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; GoalieStatsCard                                                 22581  95 PC
; Goalie version: "%d Goalie", GP/Min/GAA/W/L/T/SO/EN/SA/Pct, Ratings, Glove
; Hand
;-----------------------------------------------------------------------------
; C: src/front/stats/GoalieStatsCard.c
%ifdef CBUILD
%include "c/front/stats/GoalieStatsCard.inc"
%else
GoalieStatsCard:
        push dword 13Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, 110h
        mov ebp, statsplayer
        mov eax, dword [mainfont]
        mov dword [dword esp+0104h], eax
        mov eax, dword [kaufmfont]
        mov dword [dword esp+0108h], eax
        mov eax, dword [statsfromleague]
        mov ebx, dword [nosplit eax*4+statsplayerdbs]
        xor ecx, ecx
        mov edx, statsleague
        lea eax, [dword esp+0C8h]
        call MakePath
        push dword 200h
        lea eax, [dword esp+0CCh]
        push eax
        call open_
        add esp, byte 8
        mov ecx, eax
        xor ebx, ebx
        cmp dword [statsfromleague], byte 0
        jne short .1
        mov edx, dword [statsfilepos]
        jmp short .2
.1:
        mov edx, dword [lgstatsfilepos]
.2:
        mov eax, ecx
        call lseek_
        mov ebx, 36h
        lea edx, [dword esp+090h]
        mov eax, ecx
        call read_
        mov eax, ecx
        call j___close_
        xor ecx, ecx
        mov ebx, str_AttDb
        mov edx, statsleague
        lea eax, [dword esp+0C8h]
        call MakePath
        push dword 200h
        lea eax, [dword esp+0CCh]
        push eax
        call open_
        mov ecx, eax
        add esp, byte 8
        mov edx, dword [byte ebp+024h]
        xor ebx, ebx
        call lseek_
        mov ebx, 10h
        lea edx, [dword esp+0E8h]
        mov eax, ecx
        call read_
        mov eax, ecx
        call j___close_
        mov ebx, dword [statsteamdbs]
        xor ecx, ecx
        mov edx, statsleague
        lea eax, [dword esp+0C8h]
        call MakePath
        push dword 200h
        lea eax, [dword esp+0CCh]
        push eax
        call open_
        mov ecx, eax
        add esp, byte 8
        xor edx, edx
        mov dl, byte [byte ebp+00h]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, eax
        shl edx, 2
        xor ebx, ebx
        mov eax, ecx
        call lseek_
        mov ebx, 5
        lea edx, [dword esp+0F8h]
        mov eax, ecx
        call read_
        mov eax, ecx
        call j___close_
        call sub_B4BA8
        lea eax, [dword esp+0F8h]
        push eax
        push str_fmtEmb
        push printfbuf
        call sprintf_
        add esp, byte 0Ch
        xor ecx, ecx
        mov ebx, printfbuf
        xor eax, eax
        mov al, byte [byte ebp+00h]
        cmp byte [dword eax+fileoncd+070h], 1
        jne short .3
        mov edx, dword [cddriveptr]
        jmp short .4
.3:
        xor edx, edx
.4:
        lea eax, [dword esp+0C8h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0CCh]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        push str_Bkgd2
        push eax
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        push dword 1E0h
        push byte 13h
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        mov ebx, dword [statspalshape]
        push ebx
        call DrawShape
        add esp, byte 4
        push dword 1E0h
        push byte 0
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        mov ecx, dword [statsbgshapes]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        cmp byte [byte ebp+030h], 0
        je near .13
        mov edi, esp
        mov esi, str_PORTR2
        movsd
        movsw
        lea edx, [byte ebp+030h]
        mov ebx, 4
        lea eax, [byte esp+05h]
        call memcpy_
        mov eax, dword [byte ebp+02Eh]
        sar eax, 18h
        lea edx, [byte eax-030h]
        mov eax, edx
        shl eax, 2
        add eax, edx
        mov edx, dword [byte ebp+02Fh]
        sar edx, 18h
        sub edx, byte 30h
        xor bl, bl
        mov byte [byte esp+08h], bl
        xor ecx, ecx
        mov ebx, esp
        cmp byte [dword edx+eax*2+portraitoncd], 1
        jne short .5
        mov edx, dword [cddriveptr]
        jmp short .6
.5:
        xor edx, edx
.6:
        lea eax, [dword esp+0C8h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0CCh]
        push eax
        call LoadBank
        mov esi, eax
        add esp, byte 8
        lea edx, [byte ebp+030h]
        mov ebx, 4
        mov eax, esp
        call memcpy_
        xor bh, bh
        mov byte [byte esp+04h], bh
        mov eax, esp
        push eax
        push esi
        call sub_B30BB
        mov edi, eax
        add esp, byte 8
        test eax, eax
        je short .9
        mov byte [esp], 21h
        mov eax, esp
        push eax
        push esi
        call sub_B30BB
        add esp, byte 8
        add eax, byte 10h
        mov ecx, 26h
        mov ebx, 21h
        mov edx, edi
        call DrawPhotoWithPal
        push esi
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov ebx, str_Pstatbar4
        cmp byte [fileoncd+013Ch], 1
        jne short .7
        mov edx, dword [cddriveptr]
        jmp short .8
.7:
        xor edx, edx
.8:
        lea eax, [dword esp+0C8h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0CCh]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        push str_Pst12
        jmp short .12
.9:
        push esi
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov ebx, str_Pstatbar4
        cmp byte [fileoncd+013Ch], 1
        jne short .10
        mov edx, dword [cddriveptr]
        jmp short .11
.10:
        xor edx, edx
.11:
        lea eax, [dword esp+0C8h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0CCh]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        push str_Pst23
.12:
        push eax
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        push eax
        call DrawShape
        add esp, byte 4
        mov edi, dword [statsbgshapes]
        push edi
        jmp short .16
.13:
        xor ecx, ecx
        mov ebx, str_Pstatbar4
        cmp byte [fileoncd+013Ch], 1
        jne short .14
        mov edx, dword [cddriveptr]
        jmp short .15
.14:
        xor edx, edx
.15:
        lea eax, [dword esp+0C8h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0CCh]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        push str_Pst23
        push eax
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        push eax
        call DrawShape
        add esp, byte 4
        mov esi, dword [statsbgshapes]
        push esi
.16:
        call FreeMemBlock
        add esp, byte 4
        call TextGridOpen
        lea eax, [byte esp+050h]
        push eax
        call TextSaveState
        add esp, byte 4
        mov eax, dword [dword esp+0108h]
        push eax
        call TextSetFont
        add esp, byte 4
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        mov edi, printfbuf
        mov esi, str_PlayerStats2
        movsd
        movsd
        movsd
        movsb
        push printfbuf
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, 140h
        sub edx, eax
        mov eax, edx
        mov ebx, printfbuf
        mov edx, 52h
        call PrintOutlinedText
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        lea eax, [byte ebp+013h]
        push eax
        lea eax, [byte ebp+03h]
        push eax
        push str_SS3
        push printfbuf
        call sprintf_
        add esp, byte 10h
        mov edx, printfbuf
        mov eax, 98h
        call PrintCenteredText
        xor eax, eax
        mov al, byte [byte ebp+01h]
        push eax
        push str_DGoalie
        push printfbuf
        call sprintf_
        add esp, byte 0Ch
        mov edx, printfbuf
        mov eax, 0B2h
        call PrintCenteredText
        mov edx, dword [dword esp+0104h]
        push edx
        call TextSetFont
        add esp, byte 4
        mov dword [dword esp+0100h], 0F3h
        mov ecx, dword [dword esp+0FEh]
        sar ecx, 10h
        mov ebx, str_GP3
        mov edx, ecx
        mov eax, 82h
        call PrintShadowText
        mov ebx, str_Min2
        mov edx, ecx
        mov eax, 0AAh
        call PrintShadowText
        mov ebx, str_GAA2
        mov edx, ecx
        mov eax, 0D2h
        call PrintShadowText
        mov ebx, str_W2
        mov edx, ecx
        mov eax, 10Eh
        call PrintShadowText
        mov ebx, str_L4
        mov edx, ecx
        mov eax, 136h
        call PrintShadowText
        mov ebx, str_T2
        mov edx, ecx
        mov eax, 15Eh
        call PrintShadowText
        mov ebx, str_SO2
        mov edx, ecx
        mov eax, 186h
        call PrintShadowText
        mov ebx, str_EN2
        mov edx, ecx
        mov eax, 1AEh
        call PrintShadowText
        mov ebx, str_SA
        mov edx, ecx
        mov eax, 1D6h
        call PrintShadowText
        mov ebx, str_Pct3
        mov edx, ecx
        mov eax, 212h
        call PrintShadowText
        lea esi, [dword esp+090h]
        xor ebp, ebp
        mov dword [dword esp+0100h], 103h
.17:
        mov ebx, dword [nosplit ebp*4+statslabels]
        mov edi, dword [dword esp+0FEh]
        sar edi, 10h
        mov edx, edi
        mov eax, 32h
        call PrintShadowText
        movsx ecx, word [esi]
        mov ebx, str_fmt2d
        mov edx, edi
        mov eax, 82h
        call PrintFmt1
        mov ecx, dword [byte esi+0Ah]
        sar ecx, 10h
        mov ebx, str_fmt4d
        mov edx, edi
        mov eax, 0AAh
        call PrintFmt1
        xor ebx, ebx
        mov bx, word [byte esi+010h]
        mov ecx, 64h
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ecx
        movsx eax, dx
        push eax
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ecx
        movsx ecx, ax
        mov ebx, str_fmtMinSec
        mov edx, edi
        mov eax, 0D2h
        call PrintFmt2
        mov ecx, dword [esi]
        sar ecx, 10h
        mov ebx, str_fmt2d
        mov edx, edi
        mov eax, 10Eh
        call PrintFmt1
        mov ecx, dword [byte esi+02h]
        sar ecx, 10h
        mov ebx, str_fmt2d
        mov edx, edi
        mov eax, 136h
        call PrintFmt1
        mov ecx, dword [byte esi+04h]
        sar ecx, 10h
        mov ebx, str_fmt2d
        mov edx, edi
        mov eax, 15Eh
        call PrintFmt1
        mov ecx, dword [byte esi+06h]
        sar ecx, 10h
        mov ebx, str_fmt2d
        mov edx, edi
        mov eax, 186h
        call PrintFmt1
        mov ecx, dword [byte esi+08h]
        sar ecx, 10h
        mov ebx, str_fmt2d
        mov edx, edi
        mov eax, 1AEh
        call PrintFmt1
        mov ecx, dword [byte esi+010h]
        sar ecx, 10h
        mov ebx, str_fmt5d
        mov edx, edi
        mov eax, 1D6h
        call PrintFmt1
        mov dx, word [byte esi+014h]
        cmp dx, 3E8h
        jae short .18
        xor edx, edx
        mov dx, word [byte esi+014h]
        mov ebx, 3E8h
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        movsx ecx, dx
        mov ebx, str_fmtPct0
        mov edx, edi
        mov eax, 212h
        call PrintFmt1
        jmp short .19
.18:
        mov esi, edx
        and esi, 0FFFFh
        mov ebx, 3E8h
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ebx
        movsx eax, dx
        push eax
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ebx
        movsx ecx, ax
        mov ebx, str_fmtPct
        mov edx, edi
        mov eax, 212h
        call PrintFmt2
.19:
        lea esi, [dword esp+0A6h]
        add dword [dword esp+0100h], byte 0Dh
        inc ebp
        cmp ebp, byte 2
        jl near GoalieStatsCard.17
        mov dword [dword esp+0100h], 131h
        mov eax, dword [dword esp+0FEh]
        sar eax, 10h
        mov edx, str_Ratings3
        call PrintCenteredText
        lea eax, [dword esp+0E8h]
        mov dword [dword esp+010Ch], eax
        mov dword [dword esp+0100h], 143h
        mov ecx, dword [dword esp+0FEh]
        sar ecx, 10h
        mov ebx, str_GloveHand2
        mov edx, ecx
        mov eax, 14h
        call PrintShadowText
        cmp byte [dword esp+0E8h], 0
        je short .20
        mov ebx, str_L3
        jmp short .21
.20:
        mov ebx, str_R2
.21:
        mov edx, ecx
        mov eax, 104h
        call PrintShadowText
        xor edi, edi
        xor ebp, ebp
        add dword [dword esp+0100h], byte 0Dh
.22:
        cmp ebp, byte 5
        jne short .23
        add edi, 140h
        lea edx, [byte ebp+01h]
        mov esi, edx
        shl esi, 2
        sub esi, edx
        shl esi, 2
        add esi, edx
        sub dword [dword esp+0100h], esi
.23:
        mov ebx, dword [nosplit ebp*4+goalieratingnames]
        mov esi, dword [dword esp+0FEh]
        sar esi, 10h
        mov eax, edi
        add eax, 14h
        cwde
        mov edx, esi
        call PrintShadowText
        mov edx, dword [dword ebp+goaliecardattrs_m3]
        sar edx, 18h
        add edx, dword [dword esp+010Ch]
        xor eax, eax
        mov al, byte [edx]
        add eax, byte 5
        mov ebx, eax
        shl ebx, 2
        add ebx, eax
        movsx ecx, bx
        mov eax, edi
        add eax, 104h
        cwde
        mov ebx, str_fmt3d
        mov edx, esi
        call PrintFmt1
        add dword [dword esp+0100h], byte 0Dh
        inc ebp
        cmp ebp, byte 0Ah
        jl near GoalieStatsCard.22
        lea eax, [byte esp+050h]
        push eax
        call TextRestoreState
        add esp, byte 4
        call TextGridOff
        add esp, 110h
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CmpTeamStandings                                                22DDE  95 PC
; Teamsortfns[5] team sort (Team Standings)
;-----------------------------------------------------------------------------
; C: src/front/stats/CmpTeamStandings.c
%ifdef CBUILD
%include "c/front/stats/CmpTeamStandings.inc"
%else
CmpTeamStandings:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 0Ch
        mov ebx, eax
        mov esi, edx
        cmp dword [statsplayoffs], byte 0
        jne short .1
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov edx, dword [statsteamrecs]
        add eax, edx
        add eax, byte 28h
        jmp short .2
.1:
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov edx, dword [statsteamrecs]
        add eax, edx
        add eax, byte 3Ah
.2:
        mov edx, eax
        cmp dword [statsplayoffs], byte 0
        jne short .3
        mov ecx, dword [esi]
        mov eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 2
        mov ecx, dword [statsteamrecs]
        add eax, ecx
        add eax, byte 28h
        jmp short .4
.3:
        mov ecx, dword [esi]
        mov eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 2
        sub eax, ecx
        mov ecx, eax
        shl ecx, 2
        mov eax, dword [statsteamrecs]
        add eax, ecx
        add eax, byte 3Ah
.4:
        movzx ebp, byte [byte eax+01h]
        lea ecx, [byte ebp+ebp+00h]
        mov dword [esp], ecx
        xor ecx, ecx
        mov cl, byte [byte eax+03h]
        mov edi, dword [esp]
        add edi, ecx
        mov dword [byte esp+04h], edi
        xor ecx, ecx
        mov cl, byte [byte edx+01h]
        mov dword [byte esp+08h], ecx
        add ecx, ecx
        movzx edi, byte [byte edx+03h]
        add edi, ecx
        mov ecx, dword [byte esp+04h]
        cmp edi, ecx
        je short .5
        mov eax, ecx
        sub eax, edi
        jmp near .11
.5:
        mov cl, byte [eax]
        mov ch, byte [edx]
        cmp cl, ch
        je short .7
        mov dl, ch
        and edx, 0FFh
        mov al, cl
        and eax, 0FFh
.6:
        sub edx, eax
        mov eax, edx
        jmp short .11
.7:
        mov cl, byte [byte eax+01h]
        cmp cl, byte [byte edx+01h]
        je short .8
        mov eax, dword [byte esp+08h]
        sub ebp, eax
        mov eax, ebp
        jmp short .11
.8:
        mov cx, word [byte eax+04h]
        mov di, word [byte edx+04h]
        cmp cx, di
        je short .9
        xor ebx, ebx
        mov bx, cx
        xor eax, eax
        mov ax, di
        sub ebx, eax
        mov eax, ebx
        jmp short .11
.9:
        mov cx, word [byte eax+06h]
        mov di, word [byte edx+06h]
        cmp cx, di
        je short .10
        mov edx, edi
        and edx, 0FFFFh
        mov eax, ecx
        and eax, 0FFFFh
        jmp short CmpTeamStandings.6
.10:
        mov eax, dword [ebx]
        sub eax, dword [esi]
.11:
        add esp, byte 0Ch
        jmp near CmpTeamPK_x
%endif ; C
;-----------------------------------------------------------------------------
; CmpTeamScoring                                                  22F2E  95 PC
; Teamsortfns[0] (Team Scoring)
;-----------------------------------------------------------------------------
; C: src/front/stats/CmpTeamStandings.c (CmpTeamScoring)
%ifdef CBUILD
%include "c/front/stats/CmpTeamStandings.CmpTeamScoring.inc"
%else
CmpTeamScoring:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 8
        mov esi, eax
        mov ebx, edx
        cmp dword [statsplayoffs], byte 0
        jne short .1
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov edx, dword [statsteamrecs]
        add eax, edx
        add eax, byte 28h
        jmp short .2
.1:
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov edx, dword [statsteamrecs]
        add eax, edx
        add eax, byte 3Ah
.2:
        mov edx, eax
        cmp dword [statsplayoffs], byte 0
        jne short .3
        mov ecx, dword [ebx]
        mov eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 2
        mov ecx, dword [statsteamrecs]
        add eax, ecx
        add eax, byte 28h
        jmp short .4
.3:
        mov ecx, dword [ebx]
        mov eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 2
        mov ecx, dword [statsteamrecs]
        add eax, ecx
        add eax, byte 3Ah
.4:
        mov cx, word [byte eax+04h]
        mov di, word [byte edx+04h]
        cmp cx, di
        je short CmpTeamScoring_ret8.1
        xor ebx, ebx
        mov bx, cx
        xor eax, eax
        mov ax, di
CmpTeamScoring_sub:
        sub ebx, eax
        mov eax, ebx
CmpTeamScoring_ret8:
        add esp, byte 8
        jmp near CmpTeamPK_x
.1:
        mov cl, byte [eax]
        mov ch, byte [edx]
        cmp cl, ch
        je short CmpTeamScoring_common
        mov dl, ch
        and edx, 0FFh
        mov al, cl
        and eax, 0FFh
        sub edx, eax
        mov eax, edx
        jmp short CmpTeamScoring_ret8
CmpTeamScoring_common:
        xor ecx, ecx
        mov cl, byte [byte eax+01h]
        mov dword [byte esp+04h], ecx
        add ecx, ecx
        movzx edi, byte [byte eax+03h]
        add ecx, edi
        mov dword [esp], ecx
        movzx ebp, byte [byte edx+01h]
        lea ecx, [byte ebp+ebp+00h]
        movzx edi, byte [byte edx+03h]
        add edi, ecx
        mov ecx, dword [esp]
        cmp edi, ecx
        je short .1
        mov eax, ecx
        sub eax, edi
        jmp short CmpTeamScoring_ret8
.1:
        mov al, byte [byte eax+01h]
        cmp al, byte [byte edx+01h]
        je short .2
        mov eax, dword [byte esp+04h]
        sub eax, ebp
        jmp short CmpTeamScoring_ret8
.2:
        mov eax, dword [esi]
        sub eax, dword [ebx]
        jmp short CmpTeamScoring_ret8
%endif ; C
;-----------------------------------------------------------------------------
; CmpTeamDefense                                                  23051  95 PC
; Teamsortfns[1] (Team Defense)
;-----------------------------------------------------------------------------
; C: src/front/stats/CmpTeamStandings.c (CmpTeamDefense)
%ifdef CBUILD
%include "c/front/stats/CmpTeamStandings.CmpTeamDefense.inc"
%else
CmpTeamDefense:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 8
        mov esi, eax
        mov ebx, edx
        cmp dword [statsplayoffs], byte 0
        jne short .1
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov edx, dword [statsteamrecs]
        add eax, edx
        add eax, byte 28h
        jmp short .2
.1:
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov edx, dword [statsteamrecs]
        add eax, edx
        add eax, byte 3Ah
.2:
        mov edx, eax
        cmp dword [statsplayoffs], byte 0
        jne short .3
        mov ecx, dword [ebx]
        mov eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 2
        mov ecx, dword [statsteamrecs]
        add eax, ecx
        add eax, byte 28h
        jmp short .4
.3:
        mov ecx, dword [ebx]
        mov eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 2
        mov ecx, dword [statsteamrecs]
        add eax, ecx
        add eax, byte 3Ah
.4:
        mov cx, word [byte eax+06h]
        mov di, word [byte edx+06h]
        cmp cx, di
        je short .5
        mov edx, edi
        and edx, 0FFFFh
        mov eax, ecx
        and eax, 0FFFFh
        sub edx, eax
        mov eax, edx
        jmp near CmpTeamScoring_ret8
.5:
        mov cl, byte [eax]
        mov ch, byte [edx]
        cmp cl, ch
        je near CmpTeamScoring_common
        xor ebx, ebx
        mov bl, cl
        xor eax, eax
        mov al, ch
        jmp near CmpTeamScoring_sub
%endif ; C
;-----------------------------------------------------------------------------
; CmpTeamPP                                                       2312D  95 PC
; Teamsortfns[3] (Team Power Play)
;-----------------------------------------------------------------------------
; C: src/front/stats/CmpTeamStandings.c (CmpTeamPP)
%ifdef CBUILD
%include "c/front/stats/CmpTeamStandings.CmpTeamPP.inc"
%else
CmpTeamPP:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        mov ebx, eax
        mov esi, edx
        mov edx, dword [edx]
        shl edx, 2
        mov eax, dword [statssortkeys]
        add edx, eax
        mov ecx, dword [ebx]
        shl ecx, 2
        add eax, ecx
        mov ecx, dword [edx]
        mov edi, dword [eax]
        cmp ecx, edi
        je short .2
        mov eax, ecx
.1:
        sub eax, edi
        jmp near CmpTeamPK_ret10
.2:
        cmp dword [statsplayoffs], byte 0
        jne short .3
        mov edx, dword [ebx]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov edx, dword [statsteamrecs]
        add eax, edx
        add eax, byte 28h
        jmp short .4
.3:
        mov edx, dword [ebx]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov edx, dword [statsteamrecs]
        add eax, edx
        add eax, byte 3Ah
.4:
        mov edx, eax
        cmp dword [statsplayoffs], byte 0
        jne short .5
        mov ecx, dword [esi]
        mov eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 2
        mov ecx, dword [statsteamrecs]
        add eax, ecx
        add eax, byte 28h
        jmp short .6
.5:
        mov ecx, dword [esi]
        mov eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 2
        sub eax, ecx
        mov ecx, eax
        shl ecx, 2
        mov eax, dword [statsteamrecs]
        add eax, ecx
        add eax, byte 3Ah
.6:
        xor ecx, ecx
        mov cx, word [byte eax+08h]
        movzx ebp, word [byte edx+0Ah]
        imul ecx, ebp
        mov dword [byte esp+04h], ecx
        xor ecx, ecx
        mov cx, word [byte edx+08h]
        xor edi, edi
        mov di, word [byte eax+0Ah]
        imul ecx, edi
        mov dword [esp], ecx
        mov ecx, dword [byte esp+04h]
        sub ecx, dword [esp]
        je short .7
        test ecx, ecx
        setg al
        and eax, 0FFh
        jmp near CmpTeamPK_ret10
.7:
        cmp di, word [byte edx+0Ah]
        je short .8
        mov eax, edi
        sub eax, ebp
        jmp near CmpTeamPK_ret10
.8:
        mov cl, byte [eax]
        mov ch, byte [edx]
        cmp cl, ch
        je short .9
        xor ebx, ebx
        mov bl, cl
        xor eax, eax
        mov al, ch
        sub ebx, eax
        mov eax, ebx
        jmp near CmpTeamPK_ret10
.9:
        movzx ebp, byte [byte eax+01h]
        lea ecx, [byte ebp+ebp+00h]
        mov dword [esp], ecx
        xor ecx, ecx
        mov cl, byte [byte eax+03h]
        mov edi, dword [esp]
        add edi, ecx
        mov dword [byte esp+08h], edi
        movzx edi, byte [byte edx+01h]
        lea ecx, [edi+edi]
        mov dword [esp], ecx
        xor ecx, ecx
        mov cl, byte [byte edx+03h]
        mov dword [byte esp+04h], ecx
        mov ecx, dword [esp]
        add ecx, dword [byte esp+04h]
        mov dword [byte esp+0Ch], ecx
        mov ecx, dword [byte esp+08h]
        cmp ecx, dword [byte esp+0Ch]
        je short .10
        mov eax, ecx
        sub eax, dword [byte esp+0Ch]
        jmp near CmpTeamPK_ret10
.10:
        mov al, byte [byte eax+01h]
        cmp al, byte [byte edx+01h]
        je short CmpTeamPP_tie
        mov eax, ebp
        jmp near CmpTeamPP.1
CmpTeamPP_tie:
        mov eax, dword [ebx]
        sub eax, dword [esi]
        jmp near CmpTeamPK_ret10
%endif ; C
;-----------------------------------------------------------------------------
; CmpTeamPK                                                       232B7  95 PC
; Teamsortfns[2] (Team Penalty Killing)
;-----------------------------------------------------------------------------
; C: src/front/stats/CmpTeamStandings.c (CmpTeamPK)
%ifdef CBUILD
%include "c/front/stats/CmpTeamStandings.CmpTeamPK.inc"
%else
CmpTeamPK:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        mov ebx, eax
        mov esi, edx
        mov edx, dword [edx]
        shl edx, 2
        mov eax, dword [statssortkeys]
        add edx, eax
        mov ecx, dword [ebx]
        shl ecx, 2
        add eax, ecx
        mov ecx, dword [edx]
        mov edi, dword [eax]
        cmp ecx, edi
        je short .2
        mov eax, ecx
.1:
        sub eax, edi
        jmp near CmpTeamPK_ret10
.2:
        cmp dword [statsplayoffs], byte 0
        jne short .3
        mov edx, dword [ebx]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov edx, dword [statsteamrecs]
        add eax, edx
        add eax, byte 28h
        jmp short .4
.3:
        mov edx, dword [ebx]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov edx, dword [statsteamrecs]
        add eax, edx
        add eax, byte 3Ah
.4:
        mov edx, eax
        cmp dword [statsplayoffs], byte 0
        jne short .5
        mov ecx, dword [esi]
        mov eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 2
        mov ecx, dword [statsteamrecs]
        add eax, ecx
        add eax, byte 28h
        jmp short .6
.5:
        mov ecx, dword [esi]
        mov eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 2
        sub eax, ecx
        mov ecx, eax
        shl ecx, 2
        mov eax, dword [statsteamrecs]
        add eax, ecx
        add eax, byte 3Ah
.6:
        xor ecx, ecx
        mov cx, word [byte eax+0Ch]
        movzx ebp, word [byte edx+0Eh]
        imul ecx, ebp
        mov dword [byte esp+04h], ecx
        xor ecx, ecx
        mov cx, word [byte edx+0Ch]
        xor edi, edi
        mov di, word [byte eax+0Eh]
        imul ecx, edi
        mov dword [esp], ecx
        mov ecx, dword [byte esp+04h]
        sub ecx, dword [esp]
        je short .7
        test ecx, ecx
        setl al
        and eax, 0FFh
        jmp short CmpTeamPK_ret10
.7:
        cmp di, word [byte edx+0Eh]
        je short CmpTeamPK_x.1
CmpTeamPK_sub:
        mov eax, edi
        sub eax, ebp
CmpTeamPK_ret10:
        add esp, byte 10h
CmpTeamPK_x:
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.1:
        mov cl, byte [eax]
        mov ch, byte [edx]
        cmp cl, ch
        je short .2
        xor ebx, ebx
        mov bl, cl
        xor eax, eax
        mov al, ch
        sub ebx, eax
        mov eax, ebx
        jmp short CmpTeamPK_ret10
.2:
        movzx ebp, byte [byte eax+01h]
        lea ecx, [byte ebp+ebp+00h]
        mov dword [esp], ecx
        xor ecx, ecx
        mov cl, byte [byte eax+03h]
        mov edi, dword [esp]
        add edi, ecx
        mov dword [byte esp+08h], edi
        movzx edi, byte [byte edx+01h]
        lea ecx, [edi+edi]
        mov dword [esp], ecx
        xor ecx, ecx
        mov cl, byte [byte edx+03h]
        mov dword [byte esp+04h], ecx
        mov ecx, dword [esp]
        add ecx, dword [byte esp+04h]
        mov dword [byte esp+0Ch], ecx
        mov ecx, dword [byte esp+08h]
        cmp ecx, dword [byte esp+0Ch]
        je short .3
        mov eax, ecx
        sub eax, dword [byte esp+0Ch]
        jmp short CmpTeamPK_ret10
.3:
        mov al, byte [byte eax+01h]
        cmp al, byte [byte edx+01h]
        je near CmpTeamPP_tie
        mov eax, ebp
        jmp near CmpTeamPK.1
%endif ; C
;-----------------------------------------------------------------------------
; CmpTeamPenalties                                                23437  95 PC
; Teamsortfns[4] (Team Penalties)
;-----------------------------------------------------------------------------
; C: src/front/stats/CmpTeamStandings.c (CmpTeamPenalties)
%ifdef CBUILD
%include "c/front/stats/CmpTeamStandings.CmpTeamPenalties.inc"
%else
CmpTeamPenalties:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        mov ebx, eax
        mov esi, edx
        mov eax, dword [edx]
        shl eax, 2
        mov edx, dword [statssortkeys]
        add eax, edx
        mov ecx, dword [ebx]
        shl ecx, 2
        add edx, ecx
        mov ecx, dword [eax]
        mov edi, dword [edx]
        cmp ecx, edi
        je short .1
        mov eax, edi
        sub eax, ecx
        jmp near CmpTeamPK_ret10
.1:
        cmp dword [statsplayoffs], byte 0
        jne short .2
        mov edx, dword [ebx]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, eax
        shl edx, 2
        mov eax, dword [statsteamrecs]
        add eax, edx
        add eax, byte 28h
        jmp short .3
.2:
        mov edx, dword [ebx]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, eax
        shl edx, 2
        mov eax, dword [statsteamrecs]
        add eax, edx
        add eax, byte 3Ah
.3:
        mov edx, eax
        cmp dword [statsplayoffs], byte 0
        jne short .4
        mov ecx, dword [esi]
        mov eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 2
        mov ecx, dword [statsteamrecs]
        add eax, ecx
        add eax, byte 28h
        jmp short .5
.4:
        mov ecx, dword [esi]
        mov eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 2
        mov ecx, dword [statsteamrecs]
        add eax, ecx
        add eax, byte 3Ah
.5:
        mov cl, byte [eax]
        mov ch, byte [edx]
        cmp cl, ch
        je short .6
        xor ebx, ebx
        mov bl, cl
        xor eax, eax
        mov al, ch
        sub ebx, eax
        mov eax, ebx
        jmp near CmpTeamPK_ret10
.6:
        mov cx, word [byte eax+010h]
        mov di, word [byte edx+010h]
        cmp cx, di
        je short .7
        mov edx, edi
        and edx, 0FFFFh
        mov eax, ecx
        and eax, 0FFFFh
        sub edx, eax
        mov eax, edx
        jmp near CmpTeamPK_ret10
.7:
        movzx edi, byte [byte eax+01h]
        lea ecx, [edi+edi]
        mov dword [esp], ecx
        xor ecx, ecx
        mov cl, byte [byte eax+03h]
        mov ebp, dword [esp]
        add ebp, ecx
        mov dword [byte esp+08h], ebp
        movzx ebp, byte [byte edx+01h]
        lea ecx, [byte ebp+ebp+00h]
        mov dword [esp], ecx
        xor ecx, ecx
        mov cl, byte [byte edx+03h]
        mov dword [byte esp+04h], ecx
        mov ecx, dword [esp]
        add ecx, dword [byte esp+04h]
        mov dword [byte esp+0Ch], ecx
        mov ecx, dword [byte esp+08h]
        cmp ecx, dword [byte esp+0Ch]
        je short .8
        mov eax, ecx
        sub eax, dword [byte esp+0Ch]
        jmp near CmpTeamPK_ret10
.8:
        mov al, byte [byte eax+01h]
        cmp al, byte [byte edx+01h]
        je near CmpTeamPP_tie
        jmp near CmpTeamPK_sub
%endif ; C
        db 08Dh,040h,00h
TeamStatsScreen_keyjt:
        dd TeamStatsScreen_keyPK
        dd TeamStatsScreen_keyPP
        dd TeamStatsScreen_keyPen
        dd TeamStatsScreen_keyStand
TeamStatsScreen_coljt:
        dd TeamStatsScreen_colScoring
        dd TeamStatsScreen_colDefense
        dd TeamStatsScreen_colPK
        dd TeamStatsScreen_colPP
        dd TeamStatsScreen_colPen
;-----------------------------------------------------------------------------
; TeamStatsScreen                                                 235BE  95 PC
; Team stats table for statscategory 0-5 (titles teamstattitles, sorts
; teamsortfns); allocs "teams" / "addsort"; "Stats Unavailable"
;-----------------------------------------------------------------------------
TeamStatsScreen:
        push dword 294h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, 264h
        push eax
        push byte 20h
        push dword 7B8h
        push str_Teams
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [statsteamrecs], eax
        cmp dword [esp], byte 1
        jle short .1
        push byte 20h
        push byte 68h
        push str_Addsort
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [statssortkeys], eax
.1:
        mov eax, dword [statsfromleague]
        mov ebx, dword [nosplit eax*4+statsteamdbs]
        xor ecx, ecx
        mov edx, statsleague
        lea eax, [dword esp+0224h]
        call MakePath
        push dword 200h
        lea eax, [dword esp+0228h]
        push eax
        call open_
        add esp, byte 8
        mov dword [dword esp+0254h], eax
        cmp dword [statsfromleague], byte 0
        jne short .2
        mov eax, 4Ch
        jmp short .3
.2:
        mov eax, 2E8h
.3:
        mov dword [dword esp+0250h], eax
        cmp dword [statsplayoffs], byte 0
        jne short .5
        xor ebp, ebp
.4:
        mov dword [byte esp+ebp*4+074h], ebp
        inc ebp
        cmp ebp, byte 1Ah
        jl short TeamStatsScreen.4
        mov dword [dword esp+0258h], 1Ah
        jmp short .9
.5:
        lea eax, [dword esp+0244h]
        call OpenStatsSchedule
        mov eax, dword [dword esp+0244h]
        add eax, 199Ah
        add dword [dword esp+0244h], byte 2
        xor ebp, ebp
.6:
        xor ebx, ebx
        mov bl, byte [byte eax+02h]
        mov dword [byte esp+ebp*8+074h], ebx
        xor ebx, ebx
        mov bl, byte [byte eax+03h]
        mov dword [byte esp+ebp*8+078h], ebx
        inc ebp
        add eax, byte 2Ah
        cmp ebp, byte 8
        jl short TeamStatsScreen.6
        cmp dword [byte esp+074h], 0FFh
        jne short .7
        xor eax, eax
        mov dword [dword esp+0258h], eax
        jmp short .8
.7:
        mov dword [dword esp+0258h], 10h
.8:
        mov eax, dword [dword esp+0244h]
        sub eax, byte 2
        push eax
        call FreeMemBlock
        add esp, byte 4
.9:
        cmp dword [dword esp+0258h], byte 0
        je near TeamStatsScreen_keyPen.28
        xor ebp, ebp
        jmp near TeamStatsScreen_keyPen.5
.10:
        mov dword [dword esp+ebp*4+0DCh], ebp
        mov edx, dword [dword esp+0250h]
        imul edx, dword [byte esp+ebp*4+074h]
        xor ebx, ebx
        mov eax, dword [dword esp+0254h]
        call lseek_
        mov ebx, 4Ch
        lea edx, [dword esp+0198h]
        mov eax, dword [dword esp+0254h]
        call read_
        mov eax, ebp
        shl eax, 2
        add eax, ebp
        shl eax, 2
        sub eax, ebp
        shl eax, 2
        mov edi, dword [statsteamrecs]
        add edi, eax
        mov ecx, 13h
        lea esi, [dword esp+0198h]
        rep movsd
        cmp dword [statsplayoffs], byte 0
        jne short .11
        lea eax, [dword esp+01C0h]
        jmp short .12
.11:
        lea eax, [dword esp+01D2h]
.12:
        mov esi, eax
        mov edx, dword [esp]
        sub edx, byte 2
        cmp edx, byte 3
        ja near TeamStatsScreen_keyPen.4
        jmp dword [nosplit cs:edx*4+TeamStatsScreen_keyjt]
TeamStatsScreen_keyStand:
        xor ebx, ebx
        mov bl, byte [dword esp+01BFh]
        mov eax, ebp
        mov edx, dword [statssortkeys]
        mov dword [edx+eax*4], ebx
        jmp near TeamStatsScreen_keyPen.4
TeamStatsScreen_keyPK:
        mov dx, word [byte eax+0Ch]
        cmp dx, word [byte eax+0Eh]
        jbe short .1
        mov word [byte eax+0Eh], dx
.1:
        xor eax, eax
        mov ax, word [byte esi+0Eh]
        mov dword [dword esp+0264h], eax
        test eax, eax
        je short .2
        xor edx, edx
        mov dx, word [byte esi+0Ch]
        mov ebx, edx
        shl ebx, 5
        sub ebx, edx
        shl ebx, 2
        add ebx, edx
        shl ebx, 3
        mov edx, eax
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        lea edx, [ebx+eax]
        mov eax, edx
        sar edx, 1Fh
        idiv dword [dword esp+0264h]
        mov edx, 3E8h
        sub edx, eax
        mov eax, edx
.2:
        mov ebx, ebp
        mov edx, dword [statssortkeys]
        mov dword [edx+ebx*4], eax
        jmp near TeamStatsScreen_keyPen.4
TeamStatsScreen_keyPP:
        mov dx, word [byte eax+08h]
        cmp dx, word [byte eax+0Ah]
        jbe short .1
        mov word [byte eax+0Ah], dx
.1:
        xor eax, eax
        mov ax, word [byte esi+0Ah]
        mov dword [dword esp+0264h], eax
        test eax, eax
        je short TeamStatsScreen_keyPen.3
        xor edx, edx
        mov dx, word [byte esi+08h]
        mov ebx, edx
        shl ebx, 5
        sub ebx, edx
        shl ebx, 2
        add ebx, edx
        shl ebx, 3
        jmp short TeamStatsScreen_keyPen.1
TeamStatsScreen_keyPen:
        xor edx, edx
        mov dl, byte [eax]
        mov dword [dword esp+0264h], edx
        test edx, edx
        je short .2
        xor edx, edx
        mov dx, word [byte eax+010h]
        mov ebx, edx
        shl ebx, 2
        add ebx, edx
        add ebx, ebx
        mov eax, dword [dword esp+0264h]
.1:
        mov edx, eax
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        lea edx, [ebx+eax]
        mov eax, edx
        sar edx, 1Fh
        idiv dword [dword esp+0264h]
        jmp short .3
.2:
        xor eax, eax
.3:
        mov edx, ebp
        mov ebx, dword [statssortkeys]
        mov dword [ebx+edx*4], eax
.4:
        inc ebp
.5:
        cmp ebp, dword [dword esp+0258h]
        jl near TeamStatsScreen.10
        mov eax, dword [esp]
        shl eax, 2
        cmp dword [esp], byte 5
        je short .6
        mov ecx, dword [dword eax+teamsortfns]
        mov ebx, 4
        mov edx, dword [dword esp+0258h]
        lea eax, [dword esp+0DCh]
        call qsort_
        jmp near .28
.6:
        cmp dword [statsplayoffs], byte 0
        jne near .23
        mov ebp, dword [statsfromleague]
        test ebp, ebp
        jne short .8
        mov dword [dword esp+0258h], 0Eh
.7:
        mov edx, dword [nosplit ebp*4+westconfteams]
        mov dword [byte esp+ebp*4+04h], edx
        mov edx, dword [nosplit ebp*4+eastconfteams]
        mov dword [byte esp+ebp*4+03Ch], edx
        inc ebp
        cmp ebp, byte 0Eh
        jl short TeamStatsScreen_keyPen.7
        jmp near .28
.8:
        mov ecx, dword [dword eax+teamsortfns]
        mov ebx, 4
        mov edx, dword [dword esp+0258h]
        lea eax, [dword esp+0DCh]
        call qsort_
        xor ebp, ebp
        xor ebx, ebx
        xor edx, edx
        mov edi, dword [dword esp+0258h]
        jmp short .12
.9:
        mov eax, ebp
        shl eax, 2
        mov ecx, dword [dword esp+eax+0DCh]
        mov ecx, dword [byte esp+ecx*4+074h]
        cmp dword [nosplit ecx*4+teamconf], byte 3
        jne short .10
        mov eax, dword [dword esp+eax+0DCh]
        mov dword [byte esp+edx*4+04h], eax
        inc edx
        jmp short .11
.10:
        mov eax, dword [dword esp+eax+0DCh]
        mov dword [byte esp+ebx*4+03Ch], eax
        inc ebx
.11:
        inc ebp
.12:
        cmp ebp, edi
        jl short TeamStatsScreen_keyPen.9
        mov edx, dword [byte esp+08h]
        mov eax, dword [byte esp+04h]
        mov eax, dword [nosplit eax*4+teamdivflags]
        or eax, dword [nosplit edx*4+teamdivflags]
        cmp eax, byte 3
        je short .17
        mov ebp, 2
.13:
        mov edx, dword [byte esp+ebp*4+04h]
        mov eax, dword [byte esp+04h]
        mov eax, dword [nosplit eax*4+teamdivflags]
        or eax, dword [nosplit edx*4+teamdivflags]
        cmp eax, byte 3
        je short .14
        inc ebp
        cmp ebp, byte 0Ch
        jl short TeamStatsScreen_keyPen.13
.14:
        mov ebx, dword [byte esp+ebp*4+04h]
        jmp short .16
.15:
        mov edx, dword [esp+ebp*4]
        mov dword [byte esp+ebp*4+04h], edx
        dec ebp
.16:
        cmp ebp, byte 2
        jge short TeamStatsScreen_keyPen.15
        mov dword [byte esp+08h], ebx
.17:
        mov eax, dword [byte esp+03Ch]
        mov edx, dword [byte esp+040h]
        mov eax, dword [nosplit eax*4+teamdivflags]
        or eax, dword [nosplit edx*4+teamdivflags]
        cmp eax, byte 0Ch
        je short .22
        mov ebp, 2
.18:
        mov edx, dword [byte esp+ebp*4+03Ch]
        mov eax, dword [byte esp+03Ch]
        mov eax, dword [nosplit eax*4+teamdivflags]
        or eax, dword [nosplit edx*4+teamdivflags]
        cmp eax, byte 0Ch
        je short .19
        inc ebp
        cmp ebp, byte 0Ch
        jl short TeamStatsScreen_keyPen.18
.19:
        mov ebx, dword [byte esp+ebp*4+03Ch]
        jmp short .21
.20:
        mov edx, dword [byte esp+ebp*4+038h]
        mov dword [byte esp+ebp*4+03Ch], edx
        dec ebp
.21:
        cmp ebp, byte 2
        jge short TeamStatsScreen_keyPen.20
        mov dword [byte esp+040h], ebx
.22:
        mov dword [dword esp+0258h], 0Eh
        jmp short .28
.23:
        mov ecx, dword [dword eax+teamsortfns]
        mov ebx, 4
        mov edx, dword [dword esp+0258h]
        lea eax, [dword esp+0DCh]
        call qsort_
        xor ebp, ebp
        xor ebx, ebx
        xor edx, edx
        jmp short .27
.24:
        mov eax, ebp
        shl eax, 2
        mov ecx, dword [dword esp+eax+0DCh]
        mov ecx, dword [byte esp+ecx*4+074h]
        cmp dword [nosplit ecx*4+teamconf], byte 3
        jne short .25
        mov eax, dword [dword esp+eax+0DCh]
        mov dword [byte esp+edx*4+04h], eax
        inc edx
        jmp short .26
.25:
        mov eax, dword [dword esp+eax+0DCh]
        mov dword [byte esp+ebx*4+03Ch], eax
        inc ebx
.26:
        inc ebp
.27:
        cmp ebp, byte 10h
        jl short TeamStatsScreen_keyPen.24
        mov dword [dword esp+0258h], 8
.28:
        mov eax, dword [dword esp+0254h]
        call j___close_
        mov esi, dword [mainfont]
        mov edi, dword [kaufmfont]
        call sub_B4BA8
        mov eax, dword [statsplayoffs]
        shl eax, 2
        cmp dword [statsplayoffs], byte 0
        jne short .30
        xor ecx, ecx
        mov ebx, dword [dword eax+statsbgnames]
        cmp byte [fileoncd+08Ch], 1
        jne short .29
        mov edx, dword [cddriveptr]
        jmp short .32
.29:
        xor edx, edx
        jmp short .32
.30:
        xor ecx, ecx
        mov ebx, dword [dword eax+statsbgnames]
        cmp byte [fileoncd+08Dh], 1
        jne short .31
        mov edx, dword [cddriveptr]
        jmp short .32
.31:
        xor edx, edx
.32:
        lea eax, [dword esp+0224h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0228h]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        push str_Bkgd2
        push eax
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        push dword 1E0h
        push byte 13h
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        mov eax, dword [statspalshape]
        push eax
        call DrawShape
        add esp, byte 4
        push dword 1E0h
        push byte 0
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        mov edx, dword [statsbgshapes]
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov ebx, str_Pstatbar5
        cmp byte [fileoncd+013Ch], 1
        jne short .33
        mov edx, dword [cddriveptr]
        jmp short .34
.33:
        xor edx, edx
.34:
        lea eax, [dword esp+0224h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0228h]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        push str_Pst24
        push eax
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        push byte 1Ch
        push byte 0
        push eax
        call DrawArt
        add esp, byte 0Ch
        mov ebx, dword [statsbgshapes]
        push ebx
        call FreeMemBlock
        add esp, byte 4
        lea eax, [dword esp+01E4h]
        push eax
        call TextSaveState
        add esp, byte 4
        push edi
        call TextSetFont
        add esp, byte 4
        call TextGridOpen
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        mov edx, dword [esp]
        mov edx, dword [nosplit edx*4+teamstattitles]
        lea eax, [dword esp+0144h]
        call MakeStatsTitle
        lea eax, [dword esp+0144h]
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, 12Ch
        sub edx, eax
        mov eax, edx
        lea ebx, [dword esp+0144h]
        mov edx, 31h
        call PrintOutlinedText
        cmp dword [dword esp+0258h], byte 0
        jne short .35
        push edi
        call TextSetFont
        add esp, byte 4
        mov edx, str_StatsUnavailable
        mov eax, 0EBh
        call PrintCenteredText
        push esi
        call TextSetFont
        add esp, byte 4
        jmp near TeamStatsScreen_colPen.5
.35:
        push esi
        call TextSetFont
        add esp, byte 4
        mov dword [dword esp+0260h], 5Ch
        mov edi, dword [esp]
        cmp edi, byte 5
        jne near .36
        mov edi, dword [westconfname]
        mov esi, dword [dword esp+025Eh]
        sar esi, 10h
        push edi
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, 0A0h
        sub edx, eax
        movsx eax, dx
        mov ebx, edi
        mov edx, esi
        call PrintShadowText
        mov edi, dword [eastconfname]
        push edi
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, 1E0h
        sub edx, eax
        movsx eax, dx
        mov ebx, edi
        mov edx, esi
        call PrintShadowText
        mov dword [dword esp+0260h], 73h
        mov ecx, dword [dword esp+025Eh]
        sar ecx, 10h
        mov ebx, str_GP4
        mov edx, ecx
        mov eax, 0ECh
        call PrintShadowText
        mov ebx, str_GP4
        mov edx, ecx
        mov eax, 21Ch
        call PrintShadowText
        cmp dword [statsplayoffs], byte 0
        setne al
        mov edx, eax
        and edx, 0FFh
        shl edx, 2
        mov eax, dword [esp]
        shl eax, 4
        mov ebx, dword [dword edx+eax+teamcolhdrs]
        mov edx, dword [dword esp+025Eh]
        sar edx, 10h
        mov eax, 114h
        call PrintShadowText
        cmp dword [statsplayoffs], byte 0
        setne al
        and eax, 0FFh
        mov edx, dword [esp]
        shl edx, 4
        mov ebx, dword [dword edx+eax*4+teamcolhdrs]
        mov edx, dword [dword esp+025Eh]
        sar edx, 10h
        mov eax, 244h
        jmp near .39
.36:
        mov ecx, dword [dword esp+025Eh]
        sar ecx, 10h
        mov ebx, str_GP4
        mov edx, ecx
        mov eax, 154h
        call PrintShadowText
        mov esi, edi
        shl esi, 4
        mov ebx, dword [dword esi+teamcolhdrs]
        mov edx, ecx
        mov eax, 186h
        call PrintShadowText
        mov ebx, dword [dword esi+teamcolhdrs+4]
        mov edx, ecx
        mov eax, 1B8h
        call PrintShadowText
        cmp dword [statsplayoffs], byte 0
        je short .37
        cmp edi, byte 1
        je short .38
        test edi, edi
        je short .38
.37:
        mov ebx, dword [esp]
        shl ebx, 4
        mov ebx, dword [dword ebx+teamcolhdrs+8]
        mov edx, dword [dword esp+025Eh]
        sar edx, 10h
        mov eax, 1EAh
        call PrintShadowText
.38:
        mov eax, dword [esp]
        shl eax, 4
        mov ebx, dword [dword eax+teamcolhdrs+0Ch]
        mov edx, dword [dword esp+025Eh]
        sar edx, 10h
        mov eax, 21Ch
.39:
        call PrintShadowText
        mov dword [dword esp+025Ch], 1
        add dword [dword esp+0260h], byte 10h
        cmp dword [esp], byte 5
        jne near .59
        xor ebp, ebp
        jmp near .58
.40:
        xor edi, edi
        mov dword [dword esp+0248h], edi
        cmp ebp, byte 0Ch
        jge near .48
        mov eax, dword [byte esp+ebp*4+04h]
        mov dword [dword esp+0264h], eax
        mov edx, eax
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov esi, dword [statsteamrecs]
        add esi, eax
        mov ecx, 13h
        lea edi, [dword esp+0198h]
        rep movsd
        cmp dword [statsplayoffs], byte 0
        jne short .41
        lea eax, [dword esp+01C0h]
        jmp short .42
.41:
        lea eax, [dword esp+01D2h]
.42:
        mov esi, eax
        cmp dword [statsfromleague], byte 0
        jne short .43
        cmp byte [eax], 0
        je near .57
.43:
        mov ecx, dword [dword esp+025Ah]
        sar ecx, 10h
        mov edi, dword [dword esp+025Eh]
        sar edi, 10h
        mov eax, dword [dword esp+0248h]
        add eax, 1Eh
        cwde
        mov ebx, str_fmt2d
        mov edx, edi
        call PrintFmt1
        mov ebx, 3
        mov edx, str_ANA2
        lea eax, [dword esp+0198h]
        call strnicmp_
        mov edx, eax
        mov eax, dword [dword esp+0248h]
        add eax, 3Ch
        test edx, edx
        jne short .44
        cwde
        mov ebx, str_MightyDucksOfAnaheim
        jmp short .45
.44:
        cwde
        lea ebx, [dword esp+019Dh]
.45:
        mov edx, edi
        call PrintShadowText
        xor ecx, ecx
        mov cl, byte [esi]
        mov edi, dword [dword esp+025Eh]
        sar edi, 10h
        mov eax, dword [dword esp+0248h]
        add eax, 0ECh
        cwde
        mov ebx, str_fmt2d
        mov edx, edi
        call PrintFmt1
        mov eax, dword [dword esp+0248h]
        add eax, 114h
        cmp dword [statsplayoffs], byte 0
        jne short .46
        xor edx, edx
        mov dl, byte [byte esi+01h]
        mov ebx, edx
        add ebx, edx
        xor edx, edx
        mov dl, byte [byte esi+03h]
        add edx, ebx
        movsx ecx, dx
        cwde
        mov ebx, str_fmt3d
        jmp short .47
.46:
        xor ecx, ecx
        mov cl, byte [byte esi+01h]
        cwde
        mov ebx, str_fmt2d
.47:
        mov edx, edi
        call PrintFmt1
.48:
        mov dword [dword esp+0248h], 140h
        mov eax, dword [byte esp+ebp*4+03Ch]
        mov dword [dword esp+0264h], eax
        mov edx, eax
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov esi, dword [statsteamrecs]
        add esi, eax
        mov ecx, 13h
        lea edi, [dword esp+0198h]
        rep movsd
        cmp dword [statsplayoffs], byte 0
        jne short .49
        lea eax, [dword esp+01C0h]
        jmp short .50
.49:
        lea eax, [dword esp+01D2h]
.50:
        mov esi, eax
        cmp dword [statsfromleague], byte 0
        jne short .51
        cmp byte [eax], 0
        je near .57
.51:
        mov ecx, dword [dword esp+025Ah]
        sar ecx, 10h
        mov edi, dword [dword esp+025Eh]
        sar edi, 10h
        mov eax, dword [dword esp+0248h]
        add eax, 1Eh
        cwde
        mov ebx, str_fmt2d
        mov edx, edi
        call PrintFmt1
        mov ebx, 3
        mov edx, str_ANA2
        lea eax, [dword esp+0198h]
        call strnicmp_
        mov edx, dword [dword esp+0248h]
        add edx, byte 3Ch
        test eax, eax
        jne short .52
        movsx eax, dx
        mov ebx, str_MightyDucksOfAnaheim
        jmp short .53
.52:
        movsx eax, dx
        lea ebx, [dword esp+019Dh]
.53:
        mov edx, edi
        call PrintShadowText
        xor ecx, ecx
        mov cl, byte [esi]
        mov edi, dword [dword esp+025Eh]
        sar edi, 10h
        mov eax, dword [dword esp+0248h]
        add eax, 0DCh
        cwde
        mov ebx, str_fmt2d
        mov edx, edi
        call PrintFmt1
        mov eax, dword [dword esp+0248h]
        add eax, 104h
        cmp dword [statsplayoffs], byte 0
        jne short .54
        xor edx, edx
        mov dl, byte [byte esi+01h]
        add edx, edx
        xor ebx, ebx
        mov bl, byte [byte esi+03h]
        add edx, ebx
        movsx ecx, dx
        cwde
        mov ebx, str_fmt3d
        jmp short .55
.54:
        xor ecx, ecx
        mov cl, byte [byte esi+01h]
        cwde
        mov ebx, str_fmt2d
.55:
        mov edx, edi
        call PrintFmt1
        mov ebx, dword [dword esp+025Ch]
        inc ebx
        mov dword [dword esp+025Ch], ebx
        cmp ebx, byte 9
        jne short .56
        cmp dword [statsplayoffs], byte 0
        jne short .56
        add dword [dword esp+0260h], byte 0Dh
        mov esi, dword [dword esp+025Eh]
        sar esi, 10h
        mov ebx, str_Dashes39
        mov edx, esi
        mov eax, 1Eh
        call PrintShadowText
        mov ebx, str_Dashes36
        mov edx, esi
        mov eax, 15Eh
        call PrintShadowText
.56:
        add dword [dword esp+0260h], byte 0Dh
.57:
        inc ebp
.58:
        cmp ebp, dword [dword esp+0258h]
        jl near TeamStatsScreen_keyPen.40
        jmp near TeamStatsScreen_colPen.5
.59:
        xor ebp, ebp
        jmp near TeamStatsScreen_colPen.4
.60:
        mov eax, dword [dword esp+ebp*4+0DCh]
        mov dword [dword esp+0264h], eax
        mov edx, eax
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov esi, dword [statsteamrecs]
        add esi, eax
        mov ecx, 13h
        lea edi, [dword esp+0198h]
        rep movsd
        cmp dword [statsplayoffs], byte 0
        jne short .61
        lea eax, [dword esp+01C0h]
        jmp short .62
.61:
        lea eax, [dword esp+01D2h]
.62:
        mov esi, eax
        cmp dword [statsfromleague], byte 0
        jne short .63
        cmp byte [eax], 0
        je near TeamStatsScreen_colPen.3
.63:
        mov eax, dword [dword esp+025Ch]
        movsx ecx, ax
        mov edi, dword [dword esp+025Eh]
        sar edi, 10h
        inc dword [dword esp+025Ch]
        mov ebx, str_fmt2d
        mov edx, edi
        mov eax, 50h
        call PrintFmt1
        mov ebx, 3
        mov edx, str_ANA2
        lea eax, [dword esp+0198h]
        call strnicmp_
        test eax, eax
        jne short .64
        mov ebx, str_MightyDucksOfAnaheim
        jmp short .65
.64:
        lea ebx, [dword esp+019Dh]
.65:
        mov edx, edi
        mov eax, 6Eh
        call PrintShadowText
        xor ecx, ecx
        mov cl, byte [esi]
        mov edi, dword [dword esp+025Eh]
        sar edi, 10h
        mov ebx, str_fmt2d
        mov edx, edi
        mov eax, 154h
        call PrintFmt1
        mov edx, dword [esp]
        cmp edx, byte 4
        ja near TeamStatsScreen_colPen.2
        mov eax, edx
        mov edx, dword [dword esp+0264h]
        shl edx, 2
        mov dword [dword esp+024Ch], edx
        jmp dword [nosplit cs:eax*4+TeamStatsScreen_coljt]
TeamStatsScreen_colScoring:
        xor ecx, ecx
        mov cl, byte [byte esi+01h]
        mov ebx, str_fmt2d
        mov edx, edi
        mov eax, 186h
        call PrintFmt1
        xor ecx, ecx
        mov cl, byte [byte esi+02h]
        mov ebx, str_fmt2d
        mov edx, edi
        mov eax, 1B8h
        call PrintFmt1
        cmp dword [statsplayoffs], byte 0
        jne short .1
        xor ecx, ecx
        mov cl, byte [byte esi+03h]
        mov ebx, str_fmt2d
        mov edx, edi
        mov eax, 1EAh
        call PrintFmt1
.1:
        mov ecx, dword [byte esi+02h]
.2:
        sar ecx, 10h
        mov edx, dword [dword esp+025Eh]
        sar edx, 10h
        mov ebx, str_fmt3d
        mov eax, 21Ch
        call PrintFmt1
        jmp near TeamStatsScreen_colPen.2
TeamStatsScreen_colDefense:
        xor ecx, ecx
        mov cl, byte [byte esi+01h]
        mov ebx, str_fmt2d
        mov edx, edi
        mov eax, 186h
        call PrintFmt1
        xor ecx, ecx
        mov cl, byte [byte esi+02h]
        mov ebx, str_fmt2d
        mov edx, edi
        mov eax, 1B8h
        call PrintFmt1
        cmp dword [statsplayoffs], byte 0
        jne short .1
        xor ecx, ecx
        mov cl, byte [byte esi+03h]
        mov ebx, str_fmt2d
        mov edx, edi
        mov eax, 1EAh
        call PrintFmt1
.1:
        mov ecx, dword [byte esi+04h]
        jmp short TeamStatsScreen_colScoring.2
TeamStatsScreen_colPK:
        mov ecx, dword [byte esi+0Ch]
        sar ecx, 10h
        mov ebx, str_fmt3d
        mov edx, edi
        mov eax, 186h
        call PrintFmt1
        mov ecx, dword [byte esi+0Ah]
        sar ecx, 10h
        mov ebx, str_fmt4d
.1:
        mov edx, edi
        mov eax, 1B8h
        call PrintFmt1
        mov esi, dword [statssortkeys]
        add esi, dword [dword esp+024Ch]
        mov ebx, 0Ah
        mov eax, dword [esi]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        movsx eax, dx
        push eax
        mov eax, dword [esi]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        movsx ecx, ax
        mov ebx, str_fmtTenths
        mov edx, edi
        mov eax, 1EAh
        jmp short TeamStatsScreen_colPen.1
TeamStatsScreen_colPP:
        mov ecx, dword [byte esi+08h]
        sar ecx, 10h
        mov ebx, str_fmt3d
        mov edx, edi
        mov eax, 186h
        call PrintFmt1
        mov ecx, dword [byte esi+06h]
        sar ecx, 10h
        mov ebx, str_fmt3d
        jmp short TeamStatsScreen_colPK.1
TeamStatsScreen_colPen:
        mov ecx, dword [byte esi+0Eh]
        sar ecx, 10h
        mov ebx, str_fmt3d
        mov edx, edi
        mov eax, 186h
        call PrintFmt1
        mov esi, dword [statssortkeys]
        add esi, dword [dword esp+024Ch]
        mov ebx, 0Ah
        mov eax, dword [esi]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        movsx eax, dx
        push eax
        mov eax, dword [esi]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        movsx ecx, ax
        mov ebx, str_fmtTenths
        mov edx, edi
        mov eax, 1B8h
.1:
        call PrintFmt2
.2:
        add dword [dword esp+0260h], byte 0Dh
.3:
        inc ebp
.4:
        cmp ebp, dword [dword esp+0258h]
        jl near TeamStatsScreen_keyPen.60
.5:
        call TextGridOff
        lea eax, [dword esp+01E4h]
        push eax
        call TextRestoreState
        add esp, byte 4
        cmp dword [esp], byte 1
        jle short .6
        mov ebx, dword [statssortkeys]
        push ebx
        call FreeMemBlock
        add esp, byte 4
.6:
        mov ecx, dword [statsteamrecs]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        add esp, 268h
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; PlayerFromMouseY                                                24453  95 PC
; Roster hit test: y 40h.. skater rows / 1A5h.. goalie rows of 0Dh px ->
; player index; called by RunPlayerPickMenu
;-----------------------------------------------------------------------------
; C: src/front/stats/PlayerFromMouseY.c
%ifdef CBUILD
%include "c/front/stats/PlayerFromMouseY.inc"
%else
PlayerFromMouseY:
        push dword 8
        call __CHK
        push ecx
        mov dword [ebx], 0
        cmp edx, byte 40h
        jl near .3
        mov ecx, dword [statsnumskaters]
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 2
        add eax, ecx
        add eax, byte 40h
        cmp edx, eax
        jge short .2
        sub edx, byte 40h
        mov ecx, 0Dh
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
.1:
        mov dword [ebx], eax
        mov eax, 1
        pop ecx
        ret
.2:
        cmp edx, 1A5h
        jl short .3
        mov ecx, dword [statsnumgoalies]
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 2
        add eax, ecx
        add eax, 1A5h
        cmp edx, eax
        jge short .3
        sub edx, 1A5h
        mov ecx, 0Dh
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov edx, eax
        mov eax, dword [statsnumskaters]
        add eax, edx
        jmp short PlayerFromMouseY.1
.3:
        xor eax, eax
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; TeamRosterScreen                             244E2  95 PC, medium confidence
; Team roster table (key.db, trad / regi, Pos No Name GP G A PT ... goalies
; Min GAA W L T GA SA PCT); team_select / roster / standings menus
;-----------------------------------------------------------------------------
; C: src/front/stats/TeamRosterScreen.c
%ifdef CBUILD
%include "c/front/stats/TeamRosterScreen.inc"
%else
TeamRosterScreen:
        push dword 43Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, 40Ch
        push eax
        mov eax, dword [mainfont]
        mov dword [dword esp+03FCh], eax
        mov eax, dword [kaufmfont]
        mov dword [dword esp+03F8h], eax
        mov ebx, dword [statsteamdbs+4]
        xor ecx, ecx
        mov edx, statsleague
        lea eax, [dword esp+03C8h]
        call MakePath
        push dword 200h
        lea eax, [dword esp+03CCh]
        push eax
        call open_
        mov ecx, eax
        add esp, byte 8
        mov dword [dword esp+03F4h], eax
        mov edx, dword [esp]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        mov edx, eax
        shl eax, 5
        sub eax, edx
        xor ebx, ebx
        mov edx, eax
        mov eax, ecx
        call lseek_
        mov ebx, 2E8h
        lea edx, [byte esp+04h]
        mov eax, ecx
        call read_
        xor ecx, ecx
        mov ebx, str_KeyDb
        mov edx, statsleague
        lea eax, [dword esp+03C8h]
        call MakePath
        push dword 200h
        lea eax, [dword esp+03CCh]
        push eax
        call open_
        add esp, byte 8
        mov dword [dword esp+03E8h], eax
        mov ebx, dword [statsfromleague]
        mov ebx, dword [nosplit ebx*4+statsplayerdbs]
        xor ecx, ecx
        mov edx, statsleague
        lea eax, [dword esp+03C8h]
        call MakePath
        push dword 200h
        lea eax, [dword esp+03CCh]
        push eax
        call open_
        add esp, byte 8
        mov dword [dword esp+03ECh], eax
        xor edx, edx
        mov dword [dword esp+03F0h], edx
        xor ebp, ebp
        jmp near .5
.1:
        mov ebx, ebp
        shl ebx, 2
        mov ecx, dword [byte esp+ebx+050h]
        cmp ecx, byte 0FFFFFFFFh
        je near .4
        mov edx, ecx
        xor ebx, ebx
        mov eax, dword [dword esp+03E8h]
        call lseek_
        mov ebx, 34h
        lea edx, [dword esp+0364h]
        mov eax, dword [dword esp+03E8h]
        call read_
        mov esi, ebp
        shl esi, 2
        sub esi, ebp
        shl esi, 2
        add esi, ebp
        shl esi, 2
        mov edi, dword [statsplayerbuf]
        add edi, esi
        mov ecx, 0Dh
        lea esi, [dword esp+0364h]
        rep movsd
        xor ebx, ebx
        cmp dword [statsfromleague], byte 0
        jne short .2
        mov edx, dword [dword esp+038Ch]
        jmp short .3
.2:
        mov edx, dword [dword esp+0390h]
.3:
        mov eax, dword [dword esp+03ECh]
        call lseek_
        mov ebx, 2Fh
        lea edx, [dword esp+0398h]
        mov eax, dword [dword esp+03ECh]
        call read_
        mov edx, dword [dword esp+03F0h]
        mov esi, edx
        shl esi, 2
        sub esi, edx
        shl esi, 4
        sub esi, edx
        mov edi, dword [statsskaterbuf]
        add edi, esi
        mov ecx, 0Bh
        lea esi, [dword esp+0398h]
        rep movsd
        movsw
        movsb
        mov dword [nosplit edx*4+statsskaterplr], ebp
        mov dword [nosplit edx*4+statsskaterorder], edx
        lea edi, [byte edx+01h]
        mov dword [dword esp+03F0h], edi
.4:
        inc ebp
.5:
        cmp ebp, byte 19h
        jl near TeamRosterScreen.1
        xor ebx, ebx
        mov dword [dword esp+0408h], ebx
        xor ebp, ebp
        jmp near .10
.6:
        mov ebx, ebp
        shl ebx, 2
        mov ecx, dword [dword esp+ebx+0B4h]
        cmp ecx, byte 0FFFFFFFFh
        je near .9
        mov edx, ecx
        xor ebx, ebx
        mov eax, dword [dword esp+03E8h]
        call lseek_
        mov ebx, 34h
        lea edx, [dword esp+0364h]
        mov eax, dword [dword esp+03E8h]
        call read_
        lea edx, [byte ebp+019h]
        mov esi, edx
        shl esi, 2
        sub esi, edx
        shl esi, 2
        add esi, edx
        shl esi, 2
        mov edi, dword [statsplayerbuf]
        add edi, esi
        mov ecx, 0Dh
        lea esi, [dword esp+0364h]
        rep movsd
        xor ebx, ebx
        cmp dword [statsfromleague], byte 0
        jne short .7
        mov edx, dword [dword esp+038Ch]
        jmp short .8
.7:
        mov edx, dword [dword esp+0390h]
.8:
        mov eax, dword [dword esp+03ECh]
        call lseek_
        mov ebx, 36h
        lea edx, [dword esp+032Ch]
        mov eax, dword [dword esp+03ECh]
        call read_
        mov edx, dword [dword esp+0408h]
        mov esi, edx
        shl esi, 3
        sub esi, edx
        shl esi, 2
        sub esi, edx
        add esi, esi
        mov edi, dword [statsgoaliebuf]
        add edi, esi
        mov ecx, 0Dh
        lea esi, [dword esp+032Ch]
        rep movsd
        movsw
        lea eax, [byte ebp+019h]
        mov dword [nosplit edx*4+statsgoalieplr], eax
        mov dword [nosplit edx*4+statsgoalieorder], edx
        lea edi, [byte edx+01h]
        mov dword [dword esp+0408h], edi
.9:
        inc ebp
.10:
        cmp ebp, byte 3
        jl near TeamRosterScreen.6
        mov eax, dword [dword esp+03F4h]
        call j___close_
        mov eax, dword [dword esp+03E8h]
        call j___close_
        mov eax, dword [dword esp+03ECh]
        call j___close_
        mov ecx, CmpPoints
        mov ebx, 4
        mov edx, dword [dword esp+03F0h]
        mov eax, statsskaterorder
        call qsort_
        mov ecx, CmpGAA
        mov ebx, 4
        mov edx, dword [dword esp+0408h]
        mov eax, statsgoalieorder
        call qsort_
        call sub_B4BA8
        lea eax, [byte esp+04h]
        push eax
        push str_fmtEmb
        push printfbuf
        call sprintf_
        add esp, byte 0Ch
        xor ecx, ecx
        mov ebx, printfbuf
        mov eax, dword [esp]
        cmp byte [dword eax+fileoncd+070h], 1
        jne short .11
        mov edx, dword [cddriveptr]
        jmp short .12
.11:
        xor edx, edx
.12:
        lea eax, [dword esp+03C8h]
        call MakePath
        push byte 0
        lea eax, [dword esp+03CCh]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        push str_Bkgd2
        push eax
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        push dword 1E0h
        push byte 13h
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        mov ebp, dword [statspalshape]
        push ebp
        call DrawShape
        add esp, byte 4
        push dword 1E0h
        push byte 0
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        mov eax, dword [statsbgshapes]
        push eax
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov ebx, str_Pstatbar6
        cmp byte [fileoncd+013Ch], 1
        jne short .13
        mov edx, dword [cddriveptr]
        jmp short .14
.13:
        xor edx, edx
.14:
        lea eax, [dword esp+03C8h]
        call MakePath
        push byte 0
        lea eax, [dword esp+03CCh]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        push str_Pst25
        push eax
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        push byte 6
        push byte 0
        push eax
        call DrawArt
        add esp, byte 0Ch
        lea eax, [dword esp+02ECh]
        push eax
        call TextSaveState
        add esp, byte 4
        mov edx, dword [dword esp+03FCh]
        push edx
        call TextSetFont
        add esp, byte 4
        call TextGridOpen
        cmp dword [dword_DC734], byte 0
        je short .15
        mov edx, 0C3h
        mov eax, 0C0h
        jmp short .16
.15:
        mov edx, 43h
        mov eax, 40h
.16:
        call SetTextColors
        mov ecx, dword [dword esp+03F8h]
        push ecx
        call TextSetFont
        add esp, byte 4
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        mov esi, 1Bh
        mov dword [dword esp+040Ch], esi
        mov edi, dword [esp]
        cmp edi, byte 18h
        je near .20
        lea eax, [byte esp+09h]
        push eax
        push str_S
        push printfbuf
        call sprintf_
        add esp, byte 0Ch
        push printfbuf
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, 12Ch
        sub edx, eax
        mov eax, edx
        mov ebx, printfbuf
        mov edx, esi
        call PrintOutlinedText
        cmp edi, byte 2
        je short .17
        cmp edi, byte 18h
        je short .17
        cmp edi, byte 19h
        jne short .18
.17:
        push str_Trad
        mov esi, dword [statsbgshapes]
        push esi
        jmp short .19
.18:
        push str_Regi
        mov ecx, dword [statsbgshapes]
        push ecx
.19:
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        mov eax, dword [dword esp+040Ch]
        add eax, byte 6
        push eax
        push printfbuf
        call fputchar
        add esp, byte 4
        sar eax, 1
        add eax, 12Ch
        push eax
        mov edi, dword [statspalshape]
        push edi
        jmp short .21
.20:
        push str_MightyDucksOfAnaheim2
        push printfbuf
        call sprintf_
        add esp, byte 8
        push printfbuf
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, 12Ch
        sub edx, eax
        mov eax, edx
        mov ebx, printfbuf
        mov edx, esi
        call PrintOutlinedText
        push str_Trad
        mov ebp, dword [statsbgshapes]
        push ebp
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        push esi
        push dword 12Ah
        push eax
.21:
        call DrawArt
        add esp, byte 0Ch
        mov ebp, dword [statsbgshapes]
        push ebp
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [dword esp+03FCh]
        push eax
        call TextSetFont
        add esp, byte 4
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        mov dword [dword esp+040Ch], 30h
        mov ecx, dword [dword esp+040Ah]
        sar ecx, 10h
        mov ebx, str_Pos
        mov edx, ecx
        mov eax, 14h
        call PrintShadowText
        mov ebx, str_No
        mov edx, ecx
        mov eax, 42h
        call PrintShadowText
        mov ebx, str_Name
        mov edx, ecx
        mov eax, 60h
        call PrintShadowText
        mov ebx, str_GP5
        mov edx, ecx
        mov eax, 10Eh
        call PrintShadowText
        mov ebx, str_G3
        mov edx, ecx
        mov eax, 136h
        call PrintShadowText
        mov ebx, str_A3
        mov edx, ecx
        mov eax, 15Eh
        call PrintShadowText
        mov ebx, str_PT
        mov edx, ecx
        mov eax, 186h
        call PrintShadowText
        mov ebx, str_Shots3
        mov edx, ecx
        mov eax, 1AEh
        call PrintShadowText
        mov ebx, str_PIM3
        mov edx, ecx
        mov eax, 1E8h
        call PrintShadowText
        mov ebx, str_PlusMinus3
        mov edx, ecx
        mov eax, 210h
        call PrintShadowText
        xor ebp, ebp
        mov dword [dword esp+040Ch], 40h
        jmp near .26
.22:
        mov eax, dword [nosplit ebp*4+statsskaterorder]
        mov dword [dword esp+0404h], eax
        mov edx, dword [nosplit eax*4+statsskaterplr]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        mov esi, dword [statsplayerbuf]
        add esi, eax
        mov ecx, 0Dh
        lea edi, [dword esp+0364h]
        rep movsd
        mov eax, dword [dword esp+0363h]
        sar eax, 18h
        push eax
        push str_C
        push printfbuf
        call sprintf_
        add esp, byte 0Ch
        mov esi, dword [dword esp+040Ah]
        sar esi, 10h
        mov ebx, printfbuf
        mov edx, esi
        mov eax, 14h
        call PrintShadowText
        mov bl, byte [dword esp+0365h]
        cmp bl, 64h
        jae short .23
        xor ecx, ecx
        mov cl, bl
        mov ebx, str_fmt2d
        mov edx, esi
        mov eax, 42h
        call PrintFmt1
.23:
        mov ecx, 0A6h
        lea ebx, [dword esp+0377h]
        lea edx, [dword esp+0367h]
        mov eax, printfbuf
        call FitPlayerName
        mov edx, dword [dword esp+040Ah]
        sar edx, 10h
        mov ebx, printfbuf
        mov eax, 60h
        call PrintShadowText
        mov edx, dword [dword esp+0404h]
        mov esi, edx
        shl esi, 2
        sub esi, edx
        shl esi, 4
        sub esi, edx
        cmp dword [statsplayoffs], byte 0
        jne short .24
        mov eax, dword [statsskaterbuf]
        add esi, eax
        jmp short .25
.24:
        mov eax, dword [statsskaterbuf]
        add esi, eax
        add esi, byte 12h
.25:
        movsx ecx, word [esi]
        mov edi, dword [dword esp+040Ah]
        sar edi, 10h
        mov ebx, str_fmt2d
        mov edx, edi
        mov eax, 10Eh
        call PrintFmt1
        mov ecx, dword [esi]
        sar ecx, 10h
        mov ebx, str_fmt3d
        mov edx, edi
        mov eax, 136h
        call PrintFmt1
        mov ecx, dword [byte esi+02h]
        sar ecx, 10h
        mov ebx, str_fmt3d
        mov edx, edi
        mov eax, 15Eh
        call PrintFmt1
        mov ecx, dword [byte esi+04h]
        sar ecx, 10h
        mov ebx, str_fmt3d
        mov edx, edi
        mov eax, 186h
        call PrintFmt1
        mov ecx, dword [byte esi+0Ch]
        sar ecx, 10h
        mov ebx, str_fmt5d
        mov edx, edi
        mov eax, 1AEh
        call PrintFmt1
        mov ecx, dword [byte esi+0Ah]
        sar ecx, 10h
        mov ebx, str_fmt3d
        mov edx, edi
        mov eax, 1E8h
        call PrintFmt1
        mov ecx, dword [byte esi+0Eh]
        sar ecx, 10h
        mov ebx, str_fmt4d
        mov edx, edi
        mov eax, 210h
        call PrintFmt1
        add dword [dword esp+040Ch], byte 0Dh
        inc ebp
.26:
        cmp ebp, dword [dword esp+03F0h]
        jl near TeamRosterScreen.22
        mov dword [dword esp+040Ch], 195h
        mov ecx, dword [dword esp+040Ah]
        sar ecx, 10h
        mov ebx, str_Pos
        mov edx, ecx
        mov eax, 14h
        call PrintShadowText
        mov ebx, str_No
        mov edx, ecx
        mov eax, 42h
        call PrintShadowText
        mov ebx, str_Name
        mov edx, ecx
        mov eax, 60h
        call PrintShadowText
        mov ebx, str_GP5
        mov edx, ecx
        mov eax, 10Eh
        call PrintShadowText
        mov ebx, str_Min3
        mov edx, ecx
        mov eax, 136h
        call PrintShadowText
        mov ebx, str_GAA3
        mov edx, ecx
        mov eax, 15Eh
        call PrintShadowText
        mov ebx, str_W3
        mov edx, ecx
        mov eax, 190h
        call PrintShadowText
        mov ebx, str_L5
        mov edx, ecx
        mov eax, 1AEh
        call PrintShadowText
        cmp dword [statsplayoffs], byte 0
        jne short .27
        mov ebx, str_T3
        mov edx, ecx
        mov eax, 1CCh
        call PrintShadowText
.27:
        mov ecx, dword [dword esp+040Ah]
        sar ecx, 10h
        mov ebx, str_GA
        mov edx, ecx
        mov eax, 1EAh
        call PrintShadowText
        mov ebx, str_SA2
        mov edx, ecx
        mov eax, 20Eh
        call PrintShadowText
        mov ebx, str_PCT
        mov edx, ecx
        mov eax, 240h
        call PrintShadowText
        xor ebp, ebp
        add dword [dword esp+040Ch], byte 10h
        jmp near .35
.28:
        mov eax, dword [nosplit ebp*4+statsgoalieorder]
        mov dword [dword esp+0404h], eax
        mov edx, dword [nosplit eax*4+statsgoalieplr]
        mov esi, edx
        shl esi, 2
        sub esi, edx
        shl esi, 2
        add esi, edx
        shl esi, 2
        mov eax, dword [statsplayerbuf]
        add esi, eax
        mov ecx, 0Dh
        lea edi, [dword esp+0364h]
        rep movsd
        mov eax, dword [dword esp+0363h]
        sar eax, 18h
        push eax
        push str_C
        push printfbuf
        call sprintf_
        add esp, byte 0Ch
        mov esi, dword [dword esp+040Ah]
        sar esi, 10h
        mov ebx, printfbuf
        mov edx, esi
        mov eax, 14h
        call PrintShadowText
        mov bh, byte [dword esp+0365h]
        cmp bh, 64h
        jae short .29
        xor ecx, ecx
        mov cl, bh
        mov ebx, str_fmt2d
        mov edx, esi
        mov eax, 42h
        call PrintFmt1
.29:
        mov ecx, 0A6h
        lea ebx, [dword esp+0377h]
        lea edx, [dword esp+0367h]
        mov eax, printfbuf
        call FitPlayerName
        mov edx, dword [dword esp+040Ah]
        sar edx, 10h
        mov ebx, printfbuf
        mov eax, 60h
        call PrintShadowText
        mov edx, dword [dword esp+0404h]
        mov esi, edx
        shl esi, 3
        sub esi, edx
        shl esi, 2
        sub esi, edx
        add esi, esi
        cmp dword [statsplayoffs], byte 0
        jne short .30
        mov eax, dword [statsgoaliebuf]
        add esi, eax
        jmp short .31
.30:
        mov eax, dword [statsgoaliebuf]
        add esi, eax
        add esi, byte 16h
.31:
        mov dword [dword esp+0400h], esi
        movsx ecx, word [esi]
        mov edi, dword [dword esp+040Ah]
        sar edi, 10h
        mov ebx, str_fmt2d
        mov edx, edi
        mov eax, 10Eh
        call PrintFmt1
        mov ecx, dword [byte esi+0Ah]
        sar ecx, 10h
        mov ebx, str_fmt4d
        mov edx, edi
        mov eax, 136h
        call PrintFmt1
        xor ebx, ebx
        mov bx, word [byte esi+010h]
        mov ecx, 64h
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ecx
        movsx eax, dx
        push eax
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ecx
        movsx ecx, ax
        mov ebx, str_fmtMinSec
        mov edx, edi
        mov eax, 15Eh
        call PrintFmt2
        mov ecx, dword [esi]
        sar ecx, 10h
        mov ebx, str_fmt2d
        mov edx, edi
        mov eax, 190h
        call PrintFmt1
        mov ecx, dword [byte esi+02h]
        sar ecx, 10h
        mov ebx, str_fmt2d
        mov edx, edi
        mov eax, 1AEh
        call PrintFmt1
        cmp dword [statsplayoffs], byte 0
        jne short .32
        mov ecx, dword [byte esi+04h]
        sar ecx, 10h
        mov ebx, str_fmt2d
        mov edx, edi
        mov eax, 1CCh
        call PrintFmt1
.32:
        mov ecx, dword [dword esp+0400h]
        mov ecx, dword [byte ecx+0Ch]
        sar ecx, 10h
        mov edi, dword [dword esp+040Ah]
        sar edi, 10h
        mov ebx, str_fmt3d
        mov edx, edi
        mov eax, 1EAh
        call PrintFmt1
        mov ecx, dword [dword esp+0400h]
        mov ecx, dword [byte ecx+010h]
        sar ecx, 10h
        mov ebx, str_fmt4d
        mov edx, edi
        mov eax, 20Eh
        call PrintFmt1
        mov eax, dword [dword esp+0400h]
        mov dx, word [byte eax+014h]
        cmp dx, 3E8h
        jae short .33
        xor edx, edx
        mov dx, word [byte eax+014h]
        mov ebx, 3E8h
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        movsx ecx, dx
        mov ebx, str_fmtPct0
        mov edx, edi
        mov eax, 240h
        call PrintFmt1
        jmp short .34
.33:
        xor esi, esi
        mov si, dx
        mov ebx, 3E8h
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ebx
        movsx eax, dx
        push eax
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ebx
        movsx ecx, ax
        mov ebx, str_fmtPct
        mov edx, edi
        mov eax, 240h
        call PrintFmt2
.34:
        add dword [dword esp+040Ch], byte 0Dh
        inc ebp
.35:
        cmp ebp, dword [dword esp+0408h]
        jl near TeamRosterScreen.28
        call TextGridOff
        lea eax, [dword esp+02ECh]
        push eax
        call TextRestoreState
        add esp, byte 4
        mov eax, dword [dword esp+03F0h]
        mov dword [statsnumskaters], eax
        mov eax, dword [dword esp+0408h]
        mov dword [statsnumgoalies], eax
        xor eax, eax
        add esp, 410h
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CmpGoals                                                        25144  95 PC
; Leadersortfns[1] (Goal Leaders)
;-----------------------------------------------------------------------------
; C: src/front/stats/CmpGoals.c
%ifdef CBUILD
%include "c/front/stats/CmpGoals.inc"
%else
CmpGoals:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        mov ebx, edx
        cmp dword [statsplayoffs], byte 0
        jne short .1
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 4
        sub eax, edx
        mov edx, dword [statsskaterbuf]
        add eax, edx
        jmp short .2
.1:
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 4
        sub eax, edx
        mov edx, dword [statsskaterbuf]
        add eax, edx
        add eax, byte 12h
.2:
        mov edx, eax
        cmp dword [statsplayoffs], byte 0
        jne short .3
        mov ebx, dword [ebx]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 4
        sub eax, ebx
        mov ebx, dword [statsskaterbuf]
        add eax, ebx
        jmp short .4
.3:
        mov ebx, dword [ebx]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 4
        sub eax, ebx
        mov ebx, eax
        mov eax, dword [statsskaterbuf]
        add eax, ebx
        add eax, byte 12h
.4:
        mov bx, word [byte eax+02h]
        mov cx, word [byte edx+02h]
        cmp bx, cx
        je short .6
        mov eax, ebx
        and eax, 0FFFFh
        mov edx, ecx
.5:
        and edx, 0FFFFh
        jmp short .9
.6:
        mov bx, word [eax]
        mov si, word [edx]
        cmp bx, si
        je short .7
        mov edx, esi
        and edx, 0FFFFh
        mov eax, ebx
        and eax, 0FFFFh
        sub edx, eax
        mov eax, edx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.7:
        mov bx, word [byte eax+06h]
        mov di, word [byte edx+06h]
        cmp bx, di
        je short .8
        mov eax, ebx
        and eax, 0FFFFh
        mov edx, edi
        jmp short CmpGoals.5
.8:
        mov eax, dword [byte eax+0Eh]
        sar eax, 10h
        mov edx, dword [byte edx+0Eh]
        sar edx, 10h
.9:
        sub eax, edx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CmpAssists                                                      25237  95 PC
; Leadersortfns[2] (Assist Leaders)
;-----------------------------------------------------------------------------
; C: src/front/stats/CmpAssists.c
%ifdef CBUILD
%include "c/front/stats/CmpAssists.inc"
%else
CmpAssists:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        mov ebx, edx
        cmp dword [statsplayoffs], byte 0
        jne short .1
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 4
        sub eax, edx
        mov edx, dword [statsskaterbuf]
        add eax, edx
        jmp short .2
.1:
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 4
        sub eax, edx
        mov edx, dword [statsskaterbuf]
        add eax, edx
        add eax, byte 12h
.2:
        mov edx, eax
        cmp dword [statsplayoffs], byte 0
        jne short .3
        mov ebx, dword [ebx]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 4
        sub eax, ebx
        mov ebx, dword [statsskaterbuf]
        add eax, ebx
        jmp short .4
.3:
        mov ebx, dword [ebx]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 4
        sub eax, ebx
        mov ebx, eax
        mov eax, dword [statsskaterbuf]
        add eax, ebx
        add eax, byte 12h
.4:
        mov bx, word [byte eax+04h]
        mov cx, word [byte edx+04h]
        cmp bx, cx
        je short .6
        mov eax, ebx
        and eax, 0FFFFh
        mov edx, ecx
.5:
        and edx, 0FFFFh
        jmp short .9
.6:
        mov bx, word [eax]
        mov si, word [edx]
        cmp bx, si
        je short .7
        xor ebx, ebx
        mov bx, word [eax]
        xor eax, eax
        mov ax, si
        sub ebx, eax
        mov eax, ebx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.7:
        mov bx, word [byte eax+06h]
        mov di, word [byte edx+06h]
        cmp bx, di
        je short .8
        mov eax, ebx
        and eax, 0FFFFh
        mov edx, edi
        jmp short CmpAssists.5
.8:
        mov eax, dword [byte eax+0Eh]
        sar eax, 10h
        mov edx, dword [byte edx+0Eh]
        sar edx, 10h
.9:
        sub eax, edx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CmpPPGoals                                                      25325  95 PC
; Leadersortfns[3] (Power Play Goal Leaders)
;-----------------------------------------------------------------------------
; C: src/front/stats/CmpPPGoals.c
%ifdef CBUILD
%include "c/front/stats/CmpPPGoals.inc"
%else
CmpPPGoals:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        mov ebx, edx
        cmp dword [statsplayoffs], byte 0
        jne short .1
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 4
        sub eax, edx
        mov edx, dword [statsskaterbuf]
        add eax, edx
        jmp short .2
.1:
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 4
        sub eax, edx
        mov edx, dword [statsskaterbuf]
        add eax, edx
        add eax, byte 12h
.2:
        mov edx, eax
        cmp dword [statsplayoffs], byte 0
        jne short .3
        mov ebx, dword [ebx]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 4
        sub eax, ebx
        mov ebx, dword [statsskaterbuf]
        add eax, ebx
        jmp short .4
.3:
        mov ebx, dword [ebx]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 4
        sub eax, ebx
        mov ebx, dword [statsskaterbuf]
        add eax, ebx
        add eax, byte 12h
.4:
        mov bx, word [byte eax+08h]
        mov cx, word [byte edx+08h]
        cmp bx, cx
        je short .5
        xor ebx, ebx
        mov bx, word [byte eax+08h]
        xor eax, eax
        mov ax, cx
        jmp short .10
.5:
        mov bx, word [eax]
        mov si, word [edx]
        cmp bx, si
        je short .6
        mov edx, esi
        and edx, 0FFFFh
        mov eax, ebx
        and eax, 0FFFFh
        sub edx, eax
        mov eax, edx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.6:
        mov bx, word [byte eax+06h]
        mov di, word [byte edx+06h]
        cmp bx, di
        je short .8
        mov eax, ebx
        and eax, 0FFFFh
        mov edx, edi
.7:
        and edx, 0FFFFh
        sub eax, edx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.8:
        mov bx, word [byte eax+02h]
        mov cx, word [byte edx+02h]
        cmp bx, cx
        je short .9
        mov eax, ebx
        and eax, 0FFFFh
        mov edx, ecx
        jmp short CmpPPGoals.7
.9:
        mov ebx, dword [byte eax+0Eh]
        sar ebx, 10h
        mov eax, dword [byte edx+0Eh]
        sar eax, 10h
.10:
        sub ebx, eax
        mov eax, ebx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CmpSHGoals                                                      25438  95 PC
; Leadersortfns[4] (Shorthanded Goal Leaders)
;-----------------------------------------------------------------------------
; C: src/front/stats/CmpSHGoals.c
%ifdef CBUILD
%include "c/front/stats/CmpSHGoals.inc"
%else
CmpSHGoals:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        mov ebx, edx
        cmp dword [statsplayoffs], byte 0
        jne short .1
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 4
        sub eax, edx
        mov edx, dword [statsskaterbuf]
        add eax, edx
        jmp short .2
.1:
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 4
        sub eax, edx
        mov edx, dword [statsskaterbuf]
        add eax, edx
        add eax, byte 12h
.2:
        mov edx, eax
        cmp dword [statsplayoffs], byte 0
        jne short .3
        mov ebx, dword [ebx]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 4
        sub eax, ebx
        mov ebx, dword [statsskaterbuf]
        add eax, ebx
        jmp short .4
.3:
        mov ebx, dword [ebx]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 4
        sub eax, ebx
        mov ebx, dword [statsskaterbuf]
        add eax, ebx
        add eax, byte 12h
.4:
        mov bx, word [byte eax+0Ah]
        mov cx, word [byte edx+0Ah]
        cmp bx, cx
        je short .5
        xor ebx, ebx
        mov bx, word [byte eax+0Ah]
        xor eax, eax
        mov ax, cx
        jmp short .10
.5:
        mov bx, word [eax]
        mov si, word [edx]
        cmp bx, si
        je short .6
        mov edx, esi
        and edx, 0FFFFh
        mov eax, ebx
        and eax, 0FFFFh
        sub edx, eax
        mov eax, edx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.6:
        mov bx, word [byte eax+06h]
        mov di, word [byte edx+06h]
        cmp bx, di
        je short .8
        mov eax, ebx
        and eax, 0FFFFh
        mov edx, edi
.7:
        and edx, 0FFFFh
        sub eax, edx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.8:
        mov bx, word [byte eax+02h]
        mov cx, word [byte edx+02h]
        cmp bx, cx
        je short .9
        mov eax, ebx
        and eax, 0FFFFh
        mov edx, ecx
        jmp short CmpSHGoals.7
.9:
        mov ebx, dword [byte eax+0Eh]
        sar ebx, 10h
        mov eax, dword [byte edx+0Eh]
        sar eax, 10h
.10:
        sub ebx, eax
        mov eax, ebx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CmpPlusMinus                                                    2554B  95 PC
; Leadersortfns[5] (Plus/Minus Leaders)
;-----------------------------------------------------------------------------
; C: src/front/stats/CmpPlusMinus.c
%ifdef CBUILD
%include "c/front/stats/CmpPlusMinus.inc"
%else
CmpPlusMinus:
        push dword 10h
        call __CHK
        push ebx
        push esi
        push edi
        mov ebx, edx
        cmp dword [statsplayoffs], byte 0
        jne short .1
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 4
        sub eax, edx
        mov edx, dword [statsskaterbuf]
        add eax, edx
        jmp short .2
.1:
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 4
        sub eax, edx
        mov edx, dword [statsskaterbuf]
        add eax, edx
        add eax, byte 12h
.2:
        mov edx, eax
        cmp dword [statsplayoffs], byte 0
        jne short .3
        mov ebx, dword [ebx]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 4
        sub eax, ebx
        mov ebx, dword [statsskaterbuf]
        add eax, ebx
        jmp short .4
.3:
        mov ebx, dword [ebx]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 4
        sub eax, ebx
        mov ebx, eax
        mov eax, dword [statsskaterbuf]
        add eax, ebx
        add eax, byte 12h
.4:
        mov bx, word [byte eax+010h]
        cmp bx, word [byte edx+010h]
        je short .5
        mov eax, dword [byte eax+0Eh]
        sar eax, 10h
        mov edx, dword [byte edx+0Eh]
        sar edx, 10h
        jmp short .8
.5:
        mov bx, word [eax]
        mov si, word [edx]
        cmp bx, si
        je short .6
        mov edx, esi
        and edx, 0FFFFh
        mov eax, ebx
        and eax, 0FFFFh
        sub edx, eax
        mov eax, edx
        pop edi
        pop esi
        pop ebx
        ret
.6:
        mov bx, word [byte eax+06h]
        mov di, word [byte edx+06h]
        cmp bx, di
        je short .7
        mov eax, ebx
        and eax, 0FFFFh
        mov edx, edi
        and edx, 0FFFFh
        jmp short .8
.7:
        mov ax, word [byte eax+02h]
        and eax, 0FFFFh
        mov dx, word [byte edx+02h]
        and edx, 0FFFFh
.8:
        sub eax, edx
        pop edi
        pop esi
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CmpPIM                                                          25642  95 PC
; Leadersortfns[6] (Penalty Minute Leaders)
;-----------------------------------------------------------------------------
; C: src/front/stats/CmpPIM.c
%ifdef CBUILD
%include "c/front/stats/CmpPIM.inc"
%else
CmpPIM:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        mov ebx, edx
        cmp dword [statsplayoffs], byte 0
        jne short .1
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 4
        sub eax, edx
        mov edx, dword [statsskaterbuf]
        add eax, edx
        jmp short .2
.1:
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 4
        sub eax, edx
        mov edx, dword [statsskaterbuf]
        add eax, edx
        add eax, byte 12h
.2:
        mov edx, eax
        cmp dword [statsplayoffs], byte 0
        jne short .3
        mov ebx, dword [ebx]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 4
        sub eax, ebx
        mov ebx, dword [statsskaterbuf]
        add eax, ebx
        jmp short .4
.3:
        mov ebx, dword [ebx]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 4
        sub eax, ebx
        mov ebx, dword [statsskaterbuf]
        add eax, ebx
        add eax, byte 12h
.4:
        mov bx, word [byte eax+0Ch]
        mov cx, word [byte edx+0Ch]
        cmp bx, cx
        je short .5
        xor ebx, ebx
        mov bx, word [byte eax+0Ch]
        xor eax, eax
        mov ax, cx
        jmp short .10
.5:
        mov bx, word [eax]
        mov si, word [edx]
        cmp bx, si
        je short .6
        mov edx, esi
        and edx, 0FFFFh
        mov eax, ebx
        and eax, 0FFFFh
        sub edx, eax
        mov eax, edx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.6:
        mov bx, word [byte eax+06h]
        mov di, word [byte edx+06h]
        cmp bx, di
        je short .8
        mov eax, ebx
        and eax, 0FFFFh
        mov edx, edi
.7:
        and edx, 0FFFFh
        sub eax, edx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.8:
        mov bx, word [byte eax+02h]
        mov cx, word [byte edx+02h]
        cmp bx, cx
        je short .9
        mov eax, ebx
        and eax, 0FFFFh
        mov edx, ecx
        jmp short CmpPIM.7
.9:
        mov ebx, dword [byte eax+0Eh]
        sar ebx, 10h
        mov eax, dword [byte edx+0Eh]
        sar eax, 10h
.10:
        sub ebx, eax
        mov eax, ebx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CmpShootPct                                                     25755  95 PC
; Leadersortfns[7] (Shooting Percentage Leaders)
;-----------------------------------------------------------------------------
; C: src/front/stats/CmpShootPct.c
%ifdef CBUILD
%include "c/front/stats/CmpShootPct.inc"
%else
CmpShootPct:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        mov ebx, edx
        mov ecx, dword [edx]
        shl ecx, 2
        mov edx, dword [statssortkeys]
        add ecx, edx
        mov esi, dword [eax]
        shl esi, 2
        add edx, esi
        mov esi, dword [ecx]
        mov edi, dword [edx]
        cmp esi, edi
        je short .1
        mov eax, esi
        sub eax, edi
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.1:
        cmp dword [statsplayoffs], byte 0
        jne short .2
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 4
        sub eax, edx
        mov edx, dword [statsskaterbuf]
        add eax, edx
        jmp short .3
.2:
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 4
        sub eax, edx
        mov edx, eax
        mov eax, dword [statsskaterbuf]
        add eax, edx
        add eax, byte 12h
.3:
        mov edx, eax
        cmp dword [statsplayoffs], byte 0
        jne short .4
        mov ebx, dword [ebx]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 4
        sub eax, ebx
        mov ebx, dword [statsskaterbuf]
        add eax, ebx
        jmp short .5
.4:
        mov ebx, dword [ebx]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 4
        sub eax, ebx
        mov ebx, dword [statsskaterbuf]
        add eax, ebx
        add eax, byte 12h
.5:
        mov bx, word [eax]
        mov cx, word [edx]
        cmp bx, cx
        je short .6
        xor ebx, ebx
        mov bx, word [eax]
        xor eax, eax
        mov ax, cx
        jmp short .9
.6:
        mov bx, word [byte eax+06h]
        mov si, word [byte edx+06h]
        cmp bx, si
        je short .7
        mov eax, ebx
        and eax, 0FFFFh
        mov edx, esi
        and edx, 0FFFFh
        sub eax, edx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.7:
        mov bx, word [byte eax+02h]
        mov di, word [byte edx+02h]
        cmp bx, di
        je short .8
        xor ebx, ebx
        mov bx, word [byte eax+02h]
        xor eax, eax
        mov ax, di
        jmp short .9
.8:
        mov ebx, dword [byte eax+0Eh]
        sar ebx, 10h
        mov eax, dword [byte edx+0Eh]
        sar eax, 10h
.9:
        sub ebx, eax
        mov eax, ebx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CmpGoalieWins                                                   2586A  95 PC
; Leadersortfns[9] (Goaltender Win Leaders)
;-----------------------------------------------------------------------------
; C: src/front/stats/CmpGoalieWins.c
%ifdef CBUILD
%include "c/front/stats/CmpGoalieWins.inc"
%else
CmpGoalieWins:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        cmp dword [statsplayoffs], byte 0
        jne short .1
        mov ebx, dword [eax]
        mov eax, ebx
        shl eax, 3
        sub eax, ebx
        shl eax, 2
        sub eax, ebx
        lea ebx, [eax+eax]
        mov eax, dword [statsgoaliebuf]
        add eax, ebx
        jmp short .2
.1:
        mov ebx, dword [eax]
        mov eax, ebx
        shl eax, 3
        sub eax, ebx
        shl eax, 2
        sub eax, ebx
        add eax, eax
        mov ebx, dword [statsgoaliebuf]
        add eax, ebx
        add eax, byte 16h
.2:
        cmp dword [statsplayoffs], byte 0
        jne short .3
        mov ebx, dword [edx]
        mov edx, ebx
        shl edx, 3
        sub edx, ebx
        shl edx, 2
        sub edx, ebx
        add edx, edx
        mov ebx, dword [statsgoaliebuf]
        add ebx, edx
        jmp short .4
.3:
        mov ebx, dword [edx]
        mov edx, ebx
        shl edx, 3
        sub edx, ebx
        shl edx, 2
        sub edx, ebx
        add edx, edx
        mov ebx, dword [statsgoaliebuf]
        add ebx, edx
        add ebx, byte 16h
.4:
        mov edx, ebx
        mov cx, word [byte ebx+02h]
        mov si, word [byte eax+02h]
        cmp cx, si
        je short .5
        xor edx, ebx
        mov dx, cx
        mov eax, esi
        jmp near .13
.5:
        cmp dword [statsplayoffs], byte 0
        jne short .7
        mov cx, word [byte ebx+06h]
        mov di, word [byte eax+06h]
        cmp cx, di
        je short .7
        xor edx, ebx
        mov dx, cx
.6:
        mov eax, edi
        jmp near .13
.7:
        mov bx, word [byte edx+04h]
        mov cx, word [byte eax+04h]
        cmp bx, cx
        je short .9
        xor ebx, ebx
        mov bx, cx
        xor eax, eax
        mov ax, word [byte edx+04h]
.8:
        sub ebx, eax
        mov eax, ebx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.9:
        mov bx, word [edx]
        mov si, word [eax]
        cmp bx, si
        je short .10
        mov eax, esi
        and eax, 0FFFFh
        mov edx, ebx
        and edx, 0FFFFh
        sub eax, edx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.10:
        mov bx, word [byte edx+0Ch]
        mov di, word [byte eax+0Ch]
        cmp bx, di
        je short .11
        mov edx, ebx
        and edx, 0FFFFh
        jmp short CmpGoalieWins.6
.11:
        mov bx, word [byte edx+010h]
        mov cx, word [byte eax+010h]
        cmp bx, cx
        je short .12
        xor ebx, ebx
        mov bx, cx
        xor eax, eax
        mov ax, word [byte edx+010h]
        jmp short CmpGoalieWins.8
.12:
        mov dx, word [byte edx+014h]
        and edx, 0FFFFh
        mov ax, word [byte eax+014h]
.13:
        and eax, 0FFFFh
        sub edx, eax
        mov eax, edx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CmpSavePct                                                      259C0  95 PC
; Leadersortfns[10] (Save Percentage Leaders)
;-----------------------------------------------------------------------------
; C: src/front/stats/CmpSavePct.c
%ifdef CBUILD
%include "c/front/stats/CmpSavePct.inc"
%else
CmpSavePct:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        mov ebx, edx
        cmp dword [statsplayoffs], byte 0
        jne short .1
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        mov edx, dword [statsgoaliebuf]
        add eax, edx
        jmp short .2
.1:
        mov edx, dword [eax]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        mov edx, dword [statsgoaliebuf]
        add eax, edx
        add eax, byte 16h
.2:
        mov edx, eax
        cmp dword [statsplayoffs], byte 0
        jne short .3
        mov ebx, dword [ebx]
        mov eax, ebx
        shl eax, 3
        sub eax, ebx
        shl eax, 2
        sub eax, ebx
        add eax, eax
        mov ebx, dword [statsgoaliebuf]
        add eax, ebx
        jmp short .4
.3:
        mov ebx, dword [ebx]
        mov eax, ebx
        shl eax, 3
        sub eax, ebx
        shl eax, 2
        sub eax, ebx
        add eax, eax
        mov ebx, dword [statsgoaliebuf]
        add eax, ebx
        add eax, byte 16h
.4:
        mov bx, word [byte eax+014h]
        mov cx, word [byte edx+014h]
        cmp bx, cx
        je short .6
        xor ebx, ebx
        mov bx, word [byte eax+014h]
        xor eax, eax
        mov ax, cx
.5:
        sub ebx, eax
        mov eax, ebx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.6:
        mov bx, word [byte eax+0Ch]
        mov si, word [byte edx+0Ch]
        cmp bx, si
        je short .8
        mov eax, ebx
        and eax, 0FFFFh
        mov edx, esi
.7:
        and edx, 0FFFFh
        sub eax, edx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.8:
        mov bx, word [eax]
        mov di, word [edx]
        cmp bx, di
        je short .9
        xor ebx, ebx
        mov bx, word [eax]
        xor eax, eax
        mov ax, di
        jmp short CmpSavePct.5
.9:
        mov bx, word [byte eax+02h]
        mov cx, word [byte edx+02h]
        cmp bx, cx
        je short .10
        mov eax, ebx
        and eax, 0FFFFh
        mov edx, ecx
        jmp short CmpSavePct.7
.10:
        mov bx, word [byte eax+04h]
        mov si, word [byte edx+04h]
        cmp bx, si
        je short .11
        mov edx, esi
        and edx, 0FFFFh
        mov eax, ebx
        jmp short .12
.11:
        mov dx, word [byte edx+010h]
        and edx, 0FFFFh
        mov ax, word [byte eax+010h]
.12:
        and eax, 0FFFFh
        sub edx, eax
        mov eax, edx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
        db 08Bh,0C0h
LeadersScreen_coljt:
        dd LeadersScreen_colDefault
        dd LeadersScreen_colDefault
        dd LeadersScreen_colDefault
        dd LeadersScreen_colPPG
        dd LeadersScreen_colSHG
        dd LeadersScreen_colPlusMinus
        dd LeadersScreen_colPIM
        dd LeadersScreen_colShootPct
        dd LeadersScreen_colGAA
        dd LeadersScreen_colWins
        dd LeadersScreen_colSavePct
;-----------------------------------------------------------------------------
; LeadersScreen                                                   25B24  95 PC
; Player leaders table for statscategory 0-10 (titles leadertitles, sorts
; leadersortfns): POS PLAYER TEAM ...
;-----------------------------------------------------------------------------
; C: src/front/stats/LeadersScreen.c
%ifdef CBUILD
%include "c/front/stats/LeadersScreen.inc"
%else
LeadersScreen:
        push dword 2A0h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, 270h
        push eax
        xor edx, edx
        mov dword [dword esp+0258h], edx
        push byte 20h
        push dword 444h
        push str_Keys
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [statsplayerbuf], eax
        cmp dword [esp], byte 8
        jge short .1
        push byte 20h
        push dword 3DBh
        push str_Pstat
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [statsskaterbuf], eax
        jmp short .2
.1:
        push byte 20h
        push dword 46Eh
        push str_Gstat
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [statsgoaliebuf], eax
.2:
        cmp dword [esp], byte 7
        jne short .3
        push byte 20h
        push byte 54h
        push str_Addsort2
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [statssortkeys], eax
.3:
        mov esi, dword [esp]
        cmp esi, byte 8
        je short .4
        cmp esi, byte 0Ah
        je short .4
        cmp esi, byte 5
        je short .4
        cmp esi, byte 7
        jne near .11
.4:
        mov eax, dword [statsfromleague]
        mov ebx, dword [nosplit eax*4+statsteamdbs]
        xor ecx, ecx
        mov edx, statsleague
        lea eax, [dword esp+0238h]
        call MakePath
        push dword 200h
        lea eax, [dword esp+023Ch]
        push eax
        call open_
        add esp, byte 8
        mov esi, eax
        cmp dword [statsfromleague], byte 0
        jne short .5
        mov ecx, 4Ch
        jmp short .6
.5:
        mov ecx, 2E8h
.6:
        xor edi, edi
        mov dword [dword esp+026Ch], edi
.7:
        mov edx, dword [dword esp+026Ch]
        imul edx, ecx
        xor ebx, ebx
        mov eax, esi
        call lseek_
        mov ebx, 4Ch
        lea edx, [dword esp+0110h]
        mov eax, esi
        call read_
        cmp dword [statsplayoffs], byte 0
        jne short .8
        mov al, byte [dword esp+0138h]
        jmp short .9
.8:
        mov al, byte [dword esp+014Ah]
.9:
        xor edx, edx
        mov dl, al
        mov eax, dword [dword esp+026Ch]
        shl eax, 2
        mov dword [byte esp+eax+04h], edx
        mov edx, dword [statsfromleague]
        test edx, edx
        jne short .10
        cmp dword [statsplayoffs], byte 0
        jne short .10
        cmp dword [byte esp+eax+04h], byte 0
        jne short .10
        mov dword [byte esp+eax+04h], edx
.10:
        mov ebx, dword [dword esp+026Ch]
        inc ebx
        mov dword [dword esp+026Ch], ebx
        cmp ebx, byte 1Ah
        jl near LeadersScreen.7
        mov eax, esi
        call j___close_
.11:
        xor ecx, ecx
        mov ebx, str_KeyDb2
        mov edx, statsleague
        lea eax, [dword esp+0238h]
        call MakePath
        push dword 200h
        lea eax, [dword esp+023Ch]
        push eax
        call open_
        add esp, byte 8
        mov dword [dword esp+0260h], eax
        mov eax, dword [statsfromleague]
        mov ebx, dword [nosplit eax*4+statsplayerdbs]
        xor ecx, ecx
        mov edx, statsleague
        lea eax, [dword esp+0238h]
        call MakePath
        push dword 200h
        lea eax, [dword esp+023Ch]
        push eax
        call open_
        add esp, byte 8
        mov dword [dword esp+025Ch], eax
        jmp near .24
.12:
        mov edx, dword [dword esp+0200h]
.13:
        mov eax, dword [dword esp+025Ch]
        call lseek_
        mov ebx, 36h
        lea edx, [dword esp+019Ch]
        mov eax, dword [dword esp+025Ch]
        call read_
        cmp dword [statsplayoffs], byte 0
        jne short .14
        mov eax, dword [dword esp+019Ch]
        jmp short .15
.14:
        mov eax, dword [dword esp+01B2h]
.15:
        and eax, 0FFFFh
        je near .24
        mov edx, dword [esp]
        cmp edx, byte 8
        je short .16
        cmp edx, byte 0Ah
        jne short .17
.16:
        movzx esi, byte [dword esp+01D4h]
        shl esi, 2
        mov edi, dword [byte esp+esi+04h]
        test edi, edi
        je near .24
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add edx, eax
        shl edx, 2
        mov eax, edx
        sar edx, 1Fh
        idiv edi
        cmp eax, byte 1Eh
        jl near .24
        jmp short .20
.17:
        cmp edx, byte 9
        jne short .20
        cmp dword [statsplayoffs], byte 0
        jne short .18
        mov eax, dword [dword esp+019Eh]
        jmp short .19
.18:
        mov eax, dword [dword esp+01B4h]
.19:
        test ax, ax
        jbe near .24
.20:
        mov edx, dword [dword esp+0258h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        mov edi, dword [statsgoaliebuf]
        add edi, eax
        mov ecx, 0Dh
        lea esi, [dword esp+019Ch]
        rep movsd
        movsw
        mov ecx, dword [dword esp+0258h]
        cmp ecx, byte 14h
        jl short .21
        mov ebx, dword [esp]
        mov edx, ecx
        shl edx, 2
        sub edx, byte 4
        lea eax, [dword esp+0C0h]
        add edx, eax
        lea eax, [dword esp+0258h]
        call dword [nosplit ebx*4+leadersortfns]
        test eax, eax
        jge near .24
.21:
        mov esi, dword [dword esp+0258h]
        cmp esi, byte 14h
        jge short .22
        mov eax, esi
        shl eax, 2
        sub eax, esi
        shl eax, 2
        add eax, esi
        shl eax, 2
        mov edi, dword [statsplayerbuf]
        add edi, eax
        mov ecx, 0Dh
        lea esi, [dword esp+01D4h]
        rep movsd
        mov edx, dword [dword esp+0258h]
        mov dword [dword esp+edx*4+0C0h], edx
        lea edi, [byte edx+01h]
        mov dword [dword esp+0258h], edi
        jmp short .23
.22:
        mov eax, dword [dword esp+esi*4+0BCh]
        mov dword [dword esp+0270h], eax
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        mov edi, dword [statsplayerbuf]
        add edi, eax
        mov ecx, 0Dh
        lea esi, [dword esp+01D4h]
        rep movsd
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        mov edi, dword [statsgoaliebuf]
        add edi, eax
        mov ecx, 0Dh
        lea esi, [dword esp+019Ch]
        rep movsd
        movsw
.23:
        mov eax, dword [esp]
        mov ecx, dword [nosplit eax*4+leadersortfns]
        mov ebx, 4
        mov edx, dword [dword esp+0258h]
        lea eax, [dword esp+0C0h]
        call qsort_
.24:
        mov ebx, 34h
        lea edx, [dword esp+01D4h]
        mov eax, dword [dword esp+0260h]
        call read_
        cmp eax, byte 34h
        jne near .40
        cmp byte [dword esp+01D4h], 1Ah
        jae short LeadersScreen.24
        cmp byte [dword esp+01D6h], 47h
        jne short .25
        cmp dword [esp], byte 8
        jl short LeadersScreen.24
        xor ebx, ebx
        cmp dword [statsfromleague], byte 0
        jne near LeadersScreen.12
        mov edx, dword [dword esp+01FCh]
        jmp near LeadersScreen.13
.25:
        cmp dword [esp], byte 8
        jge short LeadersScreen.24
        xor ebx, ebx
        cmp dword [statsfromleague], byte 0
        jne short .26
        mov edx, dword [dword esp+01FCh]
        jmp short .27
.26:
        mov edx, dword [dword esp+0200h]
.27:
        mov eax, dword [dword esp+025Ch]
        call lseek_
        mov ebx, 2Fh
        lea edx, [dword esp+0208h]
        mov eax, dword [dword esp+025Ch]
        call read_
        cmp dword [statsplayoffs], byte 0
        jne short .28
        mov eax, dword [dword esp+0208h]
        jmp short .29
.28:
        mov eax, dword [dword esp+021Ah]
.29:
        and eax, 0FFFFh
        je near LeadersScreen.24
        mov edx, dword [esp]
        cmp edx, byte 5
        je short .30
        cmp edx, byte 7
        jne short .31
.30:
        movzx esi, byte [dword esp+01D4h]
        shl esi, 2
        mov ecx, dword [byte esp+esi+04h]
        test ecx, ecx
        je near LeadersScreen.24
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 3
        add edx, eax
        shl edx, 2
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        cmp eax, byte 50h
        jl near LeadersScreen.24
.31:
        mov edx, dword [dword esp+0258h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 4
        sub eax, edx
        mov edi, dword [statsskaterbuf]
        add edi, eax
        mov ecx, 0Bh
        lea esi, [dword esp+0208h]
        rep movsd
        movsw
        movsb
        cmp dword [esp], byte 7
        jne near .37
        cmp dword [statsplayoffs], byte 0
        jne short .32
        mov eax, dword [dword esp+0216h]
        jmp short .33
.32:
        mov eax, dword [dword esp+0228h]
.33:
        and eax, 0FFFFh
        mov dword [dword esp+0270h], eax
        je short .36
        cmp dword [statsplayoffs], byte 0
        jne short .34
        mov eax, dword [dword esp+020Ah]
        jmp short .35
.34:
        mov eax, dword [dword esp+021Ch]
.35:
        and eax, 0FFFFh
        mov dword [dword esp+026Ch], eax
        mov ebx, eax
        shl ebx, 5
        sub ebx, eax
        shl ebx, 2
        add ebx, eax
        shl ebx, 3
        mov eax, dword [dword esp+0270h]
        mov edx, eax
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        lea edx, [ebx+eax]
        mov eax, edx
        sar edx, 1Fh
        idiv dword [dword esp+0270h]
        mov edx, dword [dword esp+0258h]
        mov ebx, dword [statssortkeys]
        mov dword [ebx+edx*4], eax
        jmp short .37
.36:
        mov eax, dword [dword esp+0258h]
        mov edx, dword [statssortkeys]
        mov dword [edx+eax*4], 0
.37:
        mov edi, dword [dword esp+0258h]
        cmp edi, byte 14h
        jl short .38
        mov ecx, dword [esp]
        mov edx, edi
        shl edx, 2
        sub edx, byte 4
        lea eax, [dword esp+0C0h]
        add edx, eax
        lea eax, [dword esp+0258h]
        call dword [nosplit ecx*4+leadersortfns]
        test eax, eax
        jge near LeadersScreen.24
.38:
        mov eax, dword [dword esp+0258h]
        cmp eax, byte 14h
        jge short .39
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        mov edi, dword [statsplayerbuf]
        add edi, eax
        mov ecx, 0Dh
        lea esi, [dword esp+01D4h]
        rep movsd
        mov edx, dword [dword esp+0258h]
        mov dword [dword esp+edx*4+0C0h], edx
        lea ebx, [byte edx+01h]
        mov dword [dword esp+0258h], ebx
        jmp near LeadersScreen.23
.39:
        mov eax, dword [dword esp+eax*4+0BCh]
        mov dword [dword esp+0270h], eax
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        mov edi, dword [statsplayerbuf]
        add edi, eax
        mov ecx, 0Dh
        lea esi, [dword esp+01D4h]
        rep movsd
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 4
        sub eax, edx
        mov edi, dword [statsskaterbuf]
        add edi, eax
        mov ecx, 0Bh
        lea esi, [dword esp+0208h]
        rep movsd
        movsw
        movsb
        cmp dword [esp], byte 7
        jne near LeadersScreen.23
        mov edx, dword [dword esp+0258h]
        mov eax, dword [statssortkeys]
        mov ebx, dword [dword esp+0270h]
        mov edx, dword [eax+edx*4]
        mov dword [eax+ebx*4], edx
        jmp near LeadersScreen.23
.40:
        mov eax, dword [dword esp+025Ch]
        call j___close_
        mov eax, dword [dword esp+0260h]
        call j___close_
        mov edi, dword [mainfont]
        mov esi, dword [kaufmfont]
        call sub_B4BA8
        xor ecx, ecx
        mov ebx, dword [statsplayoffs]
        mov ebx, dword [nosplit ebx*4+statsbgnames]
        cmp byte [fileoncd+08Ch], 1
        jne short .41
        mov edx, dword [cddriveptr]
        jmp short .42
.41:
        xor edx, edx
.42:
        lea eax, [dword esp+0238h]
        call MakePath
        push byte 0
        lea eax, [dword esp+023Ch]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        push str_Bkgd2
        push eax
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        push dword 1E0h
        push byte 13h
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        mov eax, dword [statspalshape]
        push eax
        call DrawShape
        add esp, byte 4
        push dword 1E0h
        push byte 0
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        mov edx, dword [statsbgshapes]
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov ebx, str_Pstatbar7
        cmp byte [fileoncd+013Ch], 1
        jne short .43
        mov edx, dword [cddriveptr]
        jmp short .44
.43:
        xor edx, edx
.44:
        lea eax, [dword esp+0238h]
        call MakePath
        push byte 0
        lea eax, [dword esp+023Ch]
        push eax
        call LoadBank
        add esp, byte 8
        mov dword [statsbgshapes], eax
        push str_Pst26
        push eax
        call FindShape
        add esp, byte 8
        mov dword [statspalshape], eax
        push byte 1Ch
        push byte 0
        push eax
        call DrawArt
        add esp, byte 0Ch
        mov ebx, dword [statsbgshapes]
        push ebx
        call FreeMemBlock
        add esp, byte 4
        lea eax, [dword esp+015Ch]
        push eax
        call TextSaveState
        add esp, byte 4
        push esi
        call TextSetFont
        add esp, byte 4
        call TextGridOpen
        mov edx, 43h
        mov eax, 40h
        call SetTextColors
        mov eax, dword [esp]
        mov edx, dword [nosplit eax*4+leadertitles]
        lea eax, [byte esp+06Ch]
        call MakeStatsTitle
        lea eax, [byte esp+06Ch]
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, 12Ch
        sub edx, eax
        mov eax, edx
        lea ebx, [byte esp+06Ch]
        mov edx, 31h
        call PrintOutlinedText
        push edi
        call TextSetFont
        add esp, byte 4
        cmp dword [dword esp+0258h], byte 0
        jne short .45
        push esi
        call TextSetFont
        add esp, byte 4
        mov edx, str_StatsUnavailable2
        mov eax, 0EBh
        call PrintCenteredText
        push edi
        call TextSetFont
        add esp, byte 4
        jmp near LeadersScreen_colDefault.2
.45:
        mov dword [dword esp+0264h], 5Ch
        mov ecx, dword [dword esp+0262h]
        sar ecx, 10h
        mov ebx, str_POS
        mov edx, ecx
        mov eax, 0Ah
        call PrintShadowText
        mov ebx, str_NO
        mov edx, ecx
        mov eax, 32h
        call PrintShadowText
        mov ebx, str_PLAYER2
        mov edx, ecx
        mov eax, 50h
        call PrintShadowText
        mov ebx, str_TEAM
        mov edx, ecx
        mov eax, 0FAh
        call PrintShadowText
        mov ebx, str_GP6
        mov edx, ecx
        mov eax, 172h
        call PrintShadowText
        mov edx, dword [esp]
        mov esi, edx
        shl esi, 2
        add esi, edx
        shl esi, 2
        mov ebx, dword [dword esi+leadercolhdrs]
        mov edx, ecx
        mov eax, 19Ah
        call PrintShadowText
        mov ebx, dword [dword esi+leadercolhdrs_c1]
        mov edx, ecx
        mov eax, 1CCh
        call PrintShadowText
        mov ebx, dword [dword esi+leadercolhdrs_c2]
        mov edx, ecx
        mov eax, 1F4h
        call PrintShadowText
        cmp dword [esp], byte 9
        jne short .46
        cmp dword [statsplayoffs], byte 1
        je short .47
.46:
        mov edx, dword [esp]
        mov eax, edx
        shl eax, 2
        add eax, edx
        mov ebx, dword [nosplit eax*4+leadercolhdrs_c3]
        mov edx, dword [dword esp+0262h]
        sar edx, 10h
        mov eax, 21Ch
        call PrintShadowText
.47:
        mov edx, dword [esp]
        mov eax, edx
        shl eax, 2
        add eax, edx
        mov ebx, dword [nosplit eax*4+leadercolhdrs_c4]
        mov edx, dword [dword esp+0262h]
        sar edx, 10h
        mov eax, 24Eh
        call PrintShadowText
        xor edx, edx
        mov dword [dword esp+026Ch], edx
        add dword [dword esp+0264h], byte 10h
        jmp near LeadersScreen_colDefault.1
.48:
        mov eax, dword [dword esp+eax*4+0C0h]
        mov dword [dword esp+0270h], eax
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        mov esi, dword [statsplayerbuf]
        add esi, eax
        mov ecx, 0Dh
        lea edi, [dword esp+01D4h]
        rep movsd
        mov eax, dword [dword esp+01D3h]
        sar eax, 18h
        push eax
        push str_C2
        push printfbuf
        call sprintf_
        add esp, byte 0Ch
        mov esi, dword [dword esp+0262h]
        sar esi, 10h
        mov ebx, printfbuf
        mov edx, esi
        mov eax, 0Ah
        call PrintShadowText
        mov bh, byte [dword esp+01D5h]
        cmp bh, 64h
        jae short .49
        xor ecx, ecx
        mov cl, bh
        mov ebx, str_fmt2d
        mov edx, esi
        mov eax, 32h
        call PrintFmt1
.49:
        mov ecx, 0A0h
        lea ebx, [dword esp+01E7h]
        lea edx, [dword esp+01D7h]
        mov eax, printfbuf
        call FitPlayerName
        mov edi, dword [dword esp+0262h]
        sar edi, 10h
        mov ebx, printfbuf
        mov edx, edi
        mov eax, 50h
        call PrintShadowText
        mov ebx, dword [statsteamdbs]
        xor ecx, ecx
        mov edx, statsleague
        lea eax, [dword esp+0238h]
        call MakePath
        push dword 200h
        lea eax, [dword esp+023Ch]
        push eax
        call open_
        mov esi, eax
        add esp, byte 8
        xor edx, edx
        mov dl, byte [dword esp+01D4h]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, eax
        shl edx, 2
        xor ebx, ebx
        mov eax, esi
        call lseek_
        mov ebx, 27h
        lea edx, [dword esp+0110h]
        mov eax, esi
        call read_
        mov eax, esi
        call j___close_
        lea ebx, [dword esp+012Ah]
        mov edx, edi
        mov eax, 0FAh
        call PrintShadowText
        cmp dword [esp], byte 8
        jge near .52
        mov edx, dword [dword esp+0270h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 4
        sub eax, edx
        cmp dword [statsplayoffs], byte 0
        jne short .50
        mov esi, dword [statsskaterbuf]
        add esi, eax
        jmp short .51
.50:
        mov edx, dword [statsskaterbuf]
        add eax, edx
        lea esi, [byte eax+012h]
.51:
        mov dword [dword esp+0268h], esi
        movsx ecx, word [esi]
        mov edi, dword [dword esp+0262h]
        sar edi, 10h
        mov ebx, str_fmt2d
        mov edx, edi
        mov eax, 172h
        call PrintFmt1
        mov ecx, dword [esi]
        sar ecx, 10h
        mov ebx, str_fmt3d
        mov edx, edi
        mov eax, 19Ah
        call PrintFmt1
        mov ecx, dword [byte esi+02h]
        sar ecx, 10h
        mov ebx, str_fmt3d
        mov edx, edi
        mov eax, 1CCh
        call PrintFmt1
        mov ecx, dword [byte esi+04h]
        sar ecx, 10h
        mov ebx, str_fmt3d
        mov edx, edi
        mov eax, 1F4h
        jmp short .55
.52:
        mov edx, dword [dword esp+0270h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        cmp dword [statsplayoffs], byte 0
        jne short .53
        mov esi, dword [statsgoaliebuf]
        add esi, eax
        jmp short .54
.53:
        mov edx, dword [statsgoaliebuf]
        add eax, edx
        lea esi, [byte eax+016h]
.54:
        mov ebp, esi
        movsx ecx, word [esi]
        mov edi, dword [dword esp+0262h]
        sar edi, 10h
        mov ebx, str_fmt2d
        mov edx, edi
        mov eax, 172h
        call PrintFmt1
        mov ecx, dword [byte esi+0Ah]
        sar ecx, 10h
        mov ebx, str_fmt4d
        mov edx, edi
        mov eax, 19Ah
.55:
        call PrintFmt1
        mov edi, dword [esp]
        cmp edi, byte 0Ah
        ja near LeadersScreen_colDefault
        mov eax, edi
        jmp dword [nosplit cs:eax*4+LeadersScreen_coljt]
LeadersScreen_colPPG:
        mov ecx, dword [dword esp+0268h]
        mov ecx, dword [byte ecx+06h]
        sar ecx, 10h
        mov edx, dword [dword esp+0262h]
        sar edx, 10h
        mov ebx, str_fmt2d
        jmp near LeadersScreen_colWins.2
LeadersScreen_colSHG:
        mov ecx, dword [dword esp+0268h]
        mov ecx, dword [byte ecx+08h]
.1:
        sar ecx, 10h
        mov edx, dword [dword esp+0262h]
        sar edx, 10h
        mov ebx, str_fmt3d
        jmp near LeadersScreen_colWins.2
LeadersScreen_colPIM:
        mov ecx, dword [dword esp+0268h]
        mov ecx, dword [byte ecx+0Ah]
        jmp short LeadersScreen_colSHG.1
LeadersScreen_colPlusMinus:
        mov ecx, dword [dword esp+0268h]
        mov ecx, dword [byte ecx+0Eh]
        sar ecx, 10h
        mov edx, dword [dword esp+0262h]
        sar edx, 10h
        mov ebx, str_fmt4d
        jmp near LeadersScreen_colWins.2
LeadersScreen_colShootPct:
        mov ecx, dword [dword esp+0268h]
        mov ecx, dword [byte ecx+0Ch]
        sar ecx, 10h
        mov edi, dword [dword esp+0262h]
        sar edi, 10h
        mov ebx, str_fmt5d
        mov edx, edi
        mov eax, 21Ch
        call PrintFmt1
        mov esi, dword [dword esp+0270h]
        shl esi, 2
        mov eax, dword [statssortkeys]
        add esi, eax
        mov ebx, 0Ah
        mov eax, dword [esi]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        movsx eax, dx
        push eax
        mov eax, dword [esi]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        movsx ecx, ax
        mov ebx, str_fmtTenths
        mov edx, edi
        mov eax, 24Eh
.1:
        call PrintFmt2
LeadersScreen_colDefault:
        add dword [dword esp+0264h], byte 0Dh
        inc dword [dword esp+026Ch]
.1:
        mov eax, dword [dword esp+026Ch]
        cmp eax, dword [dword esp+0258h]
        jl near LeadersScreen.48
.2:
        call TextGridOff
        lea eax, [dword esp+015Ch]
        push eax
        call TextRestoreState
        add esp, byte 4
        cmp dword [esp], byte 7
        jne short .3
        mov esi, dword [statssortkeys]
        push esi
        call FreeMemBlock
        add esp, byte 4
.3:
        cmp dword [esp], byte 8
        jge near LeadersScreen_colSavePct.2
        mov eax, dword [statsskaterbuf]
        push eax
        jmp near LeadersScreen_colSavePct.3
LeadersScreen_colGAA:
        mov ecx, dword [byte ebp+0Ch]
        sar ecx, 10h
        mov edi, dword [dword esp+0262h]
        sar edi, 10h
        mov ebx, str_fmt3d
        mov edx, edi
        mov eax, 1CCh
        call PrintFmt1
        xor esi, esi
        mov si, word [byte ebp+010h]
        mov ebx, 64h
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ebx
        movsx eax, dx
        push eax
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ebx
        movsx ecx, ax
        mov ebx, str_fmtMinSec
        mov edx, edi
        mov eax, 1F4h
        jmp near LeadersScreen_colShootPct.1
LeadersScreen_colWins:
        mov ecx, dword [byte ebp+00h]
        sar ecx, 10h
        mov esi, dword [dword esp+0262h]
        sar esi, 10h
        mov ebx, str_fmt2d
        mov edx, esi
        mov eax, 1CCh
        call PrintFmt1
        mov ecx, dword [byte ebp+02h]
        sar ecx, 10h
        mov ebx, str_fmt2d
        mov edx, esi
        mov eax, 1F4h
        call PrintFmt1
        cmp dword [statsplayoffs], byte 0
        jne near LeadersScreen_colDefault
        mov ecx, dword [byte ebp+04h]
        sar ecx, 10h
        mov ebx, str_fmt2d
.1:
        mov edx, esi
.2:
        mov eax, 21Ch
        call PrintFmt1
        jmp near LeadersScreen_colDefault
LeadersScreen_colSavePct:
        mov ecx, dword [byte ebp+0Ch]
        sar ecx, 10h
        mov esi, dword [dword esp+0262h]
        sar esi, 10h
        mov ebx, str_fmt3d
        mov edx, esi
        mov eax, 1CCh
        call PrintFmt1
        mov ecx, dword [byte ebp+010h]
        sar ecx, 10h
        mov ebx, str_fmt4d
        mov edx, esi
        mov eax, 1F4h
        call PrintFmt1
        mov dx, word [byte ebp+014h]
        cmp dx, 3E8h
        jae short .1
        xor edx, edx
        mov dx, word [byte ebp+014h]
        mov ebx, 3E8h
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        movsx ecx, dx
        mov ebx, str_fmtPct0
        jmp short LeadersScreen_colWins.1
.1:
        xor edi, edi
        mov di, dx
        mov ebx, 3E8h
        mov eax, edi
        mov edx, edi
        sar edx, 1Fh
        idiv ebx
        movsx eax, dx
        push eax
        mov eax, edi
        mov edx, edi
        sar edx, 1Fh
        idiv ebx
        movsx ecx, ax
        mov ebx, str_fmtPct
        mov edx, esi
        mov eax, 21Ch
        jmp near LeadersScreen_colShootPct.1
.2:
        mov ebp, dword [statsgoaliebuf]
        push ebp
.3:
        call FreeMemBlock
        add esp, byte 4
        mov edx, dword [statsplayerbuf]
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        add esp, 274h
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
stand_tmpl1:
        db 014h,00h,015h,00h,016h,00h,017h,00h,018h,00h
;-----------------------------------------------------------------------------
; stand_tmpl2                                                     269F4  95 PC
;-----------------------------------------------------------------------------
stand_tmpl2:
        xor al, byte [eax]
        xor dword [eax], eax
        xor byte [eax], al
        das
        add byte [esi], ch
        db 00h
CmpConfStandings:
        db 068h,02Ch,00h,00h,00h,0E8h,044h,05Fh,06h,00h,053h,051h,056h,057h
;-----------------------------------------------------------------------------
; CmpConfStandings_m                                              26A0C  95 PC
;-----------------------------------------------------------------------------
CmpConfStandings_m:
        push ebp
        mov ebp, esp
        sub esp, 14h
        mov dword [byte ebp-014h], eax
        mov dword [byte ebp-010h], edx
        mov eax, dword [byte ebp-014h]
        imul eax, dword [eax], byte 1Ah
        mov edx, dword [statsteambuf]
        add edx, eax
        mov dword [byte ebp-04h], edx
        mov eax, dword [byte ebp-010h]
        imul eax, dword [eax], byte 1Ah
        mov edx, dword [statsteambuf]
        add edx, eax
        mov dword [byte ebp-08h], edx
        mov eax, dword [byte ebp-08h]
        mov dl, byte [byte eax+0Dh]
        mov eax, dword [byte ebp-04h]
        cmp dl, byte [byte eax+0Dh]
        je short .1
        mov eax, dword [byte ebp-04h]
        xor edx, edx
        mov dl, byte [byte eax+0Dh]
        mov eax, dword [byte ebp-08h]
        mov al, byte [byte eax+0Dh]
        and eax, 0FFh
        sub edx, eax
        mov dword [byte ebp-0Ch], edx
        jmp near .7
.1:
        mov eax, dword [byte ebp-08h]
        mov dx, word [byte eax+016h]
        mov eax, dword [byte ebp-04h]
        cmp dx, word [byte eax+016h]
        je short .2
        mov eax, dword [byte ebp-08h]
        xor edx, edx
        mov dx, word [byte eax+016h]
        mov eax, dword [byte ebp-04h]
        mov ax, word [byte eax+016h]
        and eax, 0FFFFh
        sub edx, eax
        mov dword [byte ebp-0Ch], edx
        jmp near .7
.2:
        mov eax, dword [byte ebp-08h]
        mov dl, byte [byte eax+0Eh]
        mov eax, dword [byte ebp-04h]
        cmp dl, byte [byte eax+0Eh]
        je short .3
        mov eax, dword [byte ebp-04h]
        xor edx, edx
        mov dl, byte [byte eax+0Eh]
        mov eax, dword [byte ebp-08h]
        mov al, byte [byte eax+0Eh]
        and eax, 0FFh
        sub edx, eax
        mov dword [byte ebp-0Ch], edx
        jmp near .7
.3:
        mov eax, dword [byte ebp-08h]
        mov dl, byte [byte eax+0Fh]
        mov eax, dword [byte ebp-04h]
        cmp dl, byte [byte eax+0Fh]
        je short .4
        mov eax, dword [byte ebp-08h]
        xor edx, edx
        mov dl, byte [byte eax+0Fh]
        mov eax, dword [byte ebp-04h]
        mov al, byte [byte eax+0Fh]
        and eax, 0FFh
        sub edx, eax
        mov dword [byte ebp-0Ch], edx
        jmp short .7
.4:
        mov eax, dword [byte ebp-08h]
        mov dx, word [byte eax+012h]
        mov eax, dword [byte ebp-04h]
        cmp dx, word [byte eax+012h]
        je short .5
        mov eax, dword [byte ebp-08h]
        xor edx, edx
        mov dx, word [byte eax+012h]
        mov eax, dword [byte ebp-04h]
        mov ax, word [byte eax+012h]
        and eax, 0FFFFh
        sub edx, eax
        mov dword [byte ebp-0Ch], edx
        jmp short .7
.5:
        mov eax, dword [byte ebp-08h]
        mov dx, word [byte eax+014h]
        mov eax, dword [byte ebp-04h]
        cmp dx, word [byte eax+014h]
        je short .6
        mov eax, dword [byte ebp-04h]
        xor edx, edx
        mov dx, word [byte eax+014h]
        mov eax, dword [byte ebp-08h]
        mov ax, word [byte eax+014h]
        and eax, 0FFFFh
        sub edx, eax
        mov dword [byte ebp-0Ch], edx
        jmp short .7
.6:
        mov eax, dword [byte ebp-014h]
        mov eax, dword [eax]
        mov edx, dword [byte ebp-010h]
        sub eax, dword [edx]
        mov dword [byte ebp-0Ch], eax
.7:
        mov eax, dword [byte ebp-0Ch]
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; TeamFromMouse                                26B5A  95 PC, medium confidence
; Standings hit test: mouse x/y -> team row (two columns, rows of 0Dh px;
; playoff variant); called by RunTeamPickMenu
;-----------------------------------------------------------------------------
; C: src/front/stats/TeamFromMouse.c
%ifdef CBUILD
%include "c/front/stats/TeamFromMouse.inc"
%else
TeamFromMouse:
        push dword 3Ch
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 28h
        mov dword [byte ebp-028h], eax
        mov dword [byte ebp-024h], edx
        mov dword [byte ebp-020h], ebx
        add dword [byte ebp-028h], byte 4
        cmp dword [statsplayoffs], byte 0
        jne near .9
        mov eax, dword [byte ebp-020h]
        mov dword [eax], 0
        cmp dword [byte ebp-024h], 0A5h
        jge short .1
        mov dword [byte ebp-01Ch], 0
        jmp near .76
.1:
        cmp dword [byte ebp-028h], 140h
        jge near .5
        cmp dword [byte ebp-024h], 0F3h
        jge short .2
        mov edx, dword [byte ebp-024h]
        sub edx, 0A5h
        mov ebx, 0Dh
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov edx, dword [byte ebp-020h]
        mov dword [edx], eax
        mov dword [byte ebp-01Ch], 1
        jmp near .76
.2:
        cmp dword [byte ebp-024h], 14Ah
        jge short .3
        mov dword [byte ebp-01Ch], 0
        jmp near .76
.3:
        cmp dword [byte ebp-024h], 198h
        jge short .4
        mov edx, dword [byte ebp-024h]
        sub edx, 14Ah
        mov ebx, 0Dh
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov edx, dword [byte ebp-020h]
        add eax, byte 6
        mov dword [edx], eax
        mov dword [byte ebp-01Ch], 1
        jmp near .76
.4:
        jmp near .8
.5:
        cmp dword [byte ebp-024h], 100h
        jge short .6
        mov edx, dword [byte ebp-024h]
        sub edx, 0A5h
        mov ebx, 0Dh
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov edx, dword [byte ebp-020h]
        add eax, byte 0Ch
        mov dword [edx], eax
        mov dword [byte ebp-01Ch], 1
        jmp near .76
.6:
        cmp dword [byte ebp-024h], 14Ah
        jge short .7
        mov dword [byte ebp-01Ch], 0
        jmp near .76
.7:
        cmp dword [byte ebp-024h], 1A5h
        jge short .8
        mov edx, dword [byte ebp-024h]
        sub edx, 14Ah
        mov ebx, 0Dh
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov edx, dword [byte ebp-020h]
        add eax, byte 13h
        mov dword [edx], eax
        mov dword [byte ebp-01Ch], 1
        jmp near .76
.8:
        mov dword [byte ebp-01Ch], 0
        jmp near .76
.9:
        mov eax, dword [byte ebp-020h]
        mov dword [eax], 0
        cmp dword [byte ebp-024h], byte 4Ah
        jle short .10
        cmp dword [byte ebp-024h], byte 69h
        jl short .11
.10:
        jmp near .21
.11:
        mov dword [byte ebp-0Ch], 0
.12:
        cmp word [byte ebp-0Ch], byte 4
        jl short .14
        jmp near .20
.13:
        inc dword [byte ebp-0Ch]
        jmp short TeamFromMouse.12
.14:
        mov edx, dword [byte ebp-0Eh]
        sar edx, 10h
        shl edx, 2
        mov eax, dword [byte ebp-028h]
        cmp eax, dword [dword edx+treecolx]
        jl short .15
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        shl eax, 2
        mov eax, dword [dword eax+treecolx]
        add eax, byte 64h
        cmp eax, dword [byte ebp-028h]
        jge short .16
.15:
        jmp short .19
.16:
        cmp dword [byte ebp-024h], byte 5Ah
        jge short .17
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        add eax, eax
        xor edx, edx
        mov dl, byte [dword eax+treecolslots]
        mov eax, dword [byte ebp-020h]
        mov dword [eax], edx
        jmp short .18
.17:
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        add eax, eax
        xor edx, edx
        mov dl, byte [dword eax+treecolslots+1]
        mov eax, dword [byte ebp-020h]
        mov dword [eax], edx
.18:
        mov dword [byte ebp-01Ch], 1
        jmp near .76
.19:
        jmp short TeamFromMouse.13
.20:
        mov dword [byte ebp-01Ch], 0
        jmp near .76
.21:
        cmp dword [byte ebp-024h], 99h
        jle short .22
        cmp dword [byte ebp-024h], 0B9h
        jl short .23
.22:
        jmp near .33
.23:
        mov word [byte ebp-0Ch], 0
.24:
        cmp word [byte ebp-0Ch], byte 2
        jl short .26
        jmp near .32
.25:
        inc word [byte ebp-0Ch]
        jmp short TeamFromMouse.24
.26:
        mov edx, dword [byte ebp-0Eh]
        sar edx, 10h
        shl edx, 2
        mov eax, dword [byte ebp-028h]
        cmp eax, dword [dword edx+treerowy]
        jl short .27
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        shl eax, 2
        mov eax, dword [dword eax+treerowy]
        add eax, byte 64h
        cmp eax, dword [byte ebp-028h]
        jge short .28
.27:
        jmp short .31
.28:
        cmp dword [byte ebp-024h], 0A9h
        jge short .29
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        add eax, eax
        xor edx, edx
        mov dl, byte [dword eax+treecol_Wr2]
        mov eax, dword [byte ebp-020h]
        mov dword [eax], edx
        jmp short .30
.29:
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        add eax, eax
        xor edx, edx
        mov dl, byte [dword eax+treecol_Wr2+1]
        mov eax, dword [byte ebp-020h]
        mov dword [eax], edx
.30:
        mov dword [byte ebp-01Ch], 1
        jmp near .76
.31:
        jmp short TeamFromMouse.25
.32:
        mov dword [byte ebp-01Ch], 0
        jmp near .76
.33:
        cmp dword [byte ebp-024h], 0E5h
        jle short .34
        cmp dword [byte ebp-024h], 104h
        jl short .35
.34:
        jmp near .51
.35:
        cmp dword [byte ebp-028h], byte 48h
        jl short .36
        cmp dword [byte ebp-028h], 0ACh
        jle short .37
.36:
        jmp short .40
.37:
        cmp dword [byte ebp-024h], 0F5h
        jge short .38
        xor edx, edx
        mov dl, byte [treecolslots+10h]
        mov eax, dword [byte ebp-020h]
        mov dword [eax], edx
        jmp short .39
.38:
        xor edx, edx
        mov dl, byte [treecolslots+11h]
        mov eax, dword [byte ebp-020h]
        mov dword [eax], edx
.39:
        mov dword [byte ebp-01Ch], 1
        jmp near .76
.40:
        cmp dword [byte ebp-028h], 10Ch
        jl short .41
        cmp dword [byte ebp-028h], 170h
        jle short .42
.41:
        jmp short .45
.42:
        cmp dword [byte ebp-024h], 0F2h
        jge short .43
        xor edx, edx
        mov dl, byte [treecolslots+18h]
        mov eax, dword [byte ebp-020h]
        mov dword [eax], edx
        jmp short .44
.43:
        xor edx, edx
        mov dl, byte [treecolslots+28h]
        mov eax, dword [byte ebp-020h]
        mov dword [eax], edx
.44:
        mov dword [byte ebp-01Ch], 1
        jmp near .76
.45:
        cmp dword [byte ebp-028h], 1CDh
        jl short .46
        cmp dword [byte ebp-028h], 231h
        jle short .47
.46:
        jmp short .50
.47:
        cmp dword [byte ebp-024h], 0F5h
        jge short .48
        xor edx, edx
        mov dl, byte [treecolslots+30h]
        mov eax, dword [byte ebp-020h]
        mov dword [eax], edx
        jmp short .49
.48:
        xor edx, edx
        mov dl, byte [treecolslots+31h]
        mov eax, dword [byte ebp-020h]
        mov dword [eax], edx
.49:
        mov dword [byte ebp-01Ch], 1
        jmp near .76
.50:
        mov dword [byte ebp-01Ch], 0
        jmp near .76
.51:
        cmp dword [byte ebp-024h], 133h
        jle short .52
        cmp dword [byte ebp-024h], 152h
        jl short .53
.52:
        jmp near .63
.53:
        mov word [byte ebp-0Ch], 0
.54:
        cmp word [byte ebp-0Ch], byte 2
        jl short .56
        jmp near .62
.55:
        inc word [byte ebp-0Ch]
        jmp short TeamFromMouse.54
.56:
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        mov edx, 1
        sub edx, eax
        mov eax, edx
        shl eax, 2
        mov eax, dword [dword eax+treerowy]
        add eax, byte 64h
        mov edx, 280h
        sub edx, eax
        mov eax, edx
        cmp eax, dword [byte ebp-028h]
        jg short .57
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        mov edx, 1
        sub edx, eax
        mov eax, edx
        shl eax, 2
        mov edx, 280h
        sub edx, dword [dword eax+treerowy]
        mov eax, edx
        cmp eax, dword [byte ebp-028h]
        jge short .58
.57:
        jmp short .61
.58:
        cmp dword [byte ebp-024h], 143h
        jge short .59
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        add eax, eax
        xor edx, edx
        mov dl, byte [dword eax+treecol_Er2]
        mov eax, dword [byte ebp-020h]
        mov dword [eax], edx
        jmp short .60
.59:
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        add eax, eax
        xor edx, edx
        mov dl, byte [dword eax+treecol_Er2+1]
        mov eax, dword [byte ebp-020h]
        mov dword [eax], edx
.60:
        mov dword [byte ebp-01Ch], 1
        jmp near .76
.61:
        jmp near TeamFromMouse.55
.62:
        mov dword [byte ebp-01Ch], 0
        jmp near .76
.63:
        cmp dword [byte ebp-024h], 180h
        jle short .64
        cmp dword [byte ebp-024h], 19Fh
        jl short .65
.64:
        jmp near .75
.65:
        mov word [byte ebp-0Ch], 0
.66:
        cmp word [byte ebp-0Ch], byte 4
        jl short .68
        jmp near .74
.67:
        inc word [byte ebp-0Ch]
        jmp short TeamFromMouse.66
.68:
        mov edx, dword [byte ebp-0Eh]
        sar edx, 10h
        shl edx, 2
        mov eax, dword [byte ebp-028h]
        cmp eax, dword [dword edx+treecolx]
        jl short .69
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        shl eax, 2
        mov eax, dword [dword eax+treecolx]
        add eax, byte 64h
        cmp eax, dword [byte ebp-028h]
        jge short .70
.69:
        jmp short .73
.70:
        cmp dword [byte ebp-024h], 190h
        jge short .71
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        add eax, eax
        xor edx, edx
        mov dl, byte [dword eax+treecol_Er1]
        mov eax, dword [byte ebp-020h]
        mov dword [eax], edx
        jmp short .72
.71:
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        add eax, eax
        xor edx, edx
        mov dl, byte [dword eax+treecol_Er1+1]
        mov eax, dword [byte ebp-020h]
        mov dword [eax], edx
.72:
        mov dword [byte ebp-01Ch], 1
        jmp short .76
.73:
        jmp short TeamFromMouse.67
.74:
        mov dword [byte ebp-01Ch], 0
        jmp short .76
.75:
        mov dword [byte ebp-01Ch], 0
.76:
        mov eax, dword [byte ebp-01Ch]
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
