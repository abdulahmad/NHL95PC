; Skater and goalie stats cards (95G stats95).
bits 32
%include "hockey.inc"
section s_21CDE progbits alloc exec nowrite align=1
extern __CHK, cddriveptr, DrawPhotoWithPal, DrawShape, fileoncd, FindShape, fputchar, FreeMemBlock
extern goaliecardattrs_m3, goalieratingnames, j___close_, kaufmfont, lgstatsfilepos, LoadBank, lseek_, mainfont
extern MakePath, memcpy_, open_, portraitoncd, PrintCenteredText, printfbuf, PrintFmt1, PrintFmt2
extern PrintOutlinedText, PrintShadowText, read_, SetClipWindow, SetTextColors, skatercardattrs_m3, skaterratingnames, sprintf_
extern statsbgshapes, statsfilepos, statsfromleague, statslabels, statsleague, statspalshape, statsplayer, statsplayerdbs
extern statsteamdbs, str_A2, str_AttDb, str_Bkgd2, str_Center2, str_D2, str_Defense, str_DGoalie
extern str_EN2, str_fmt2d, str_fmt3d, str_fmt4d, str_fmt5d, str_fmtEmb, str_fmtMinSec, str_fmtPct
extern str_fmtPct0, str_fmtTenths, str_G2, str_GAA2, str_GloveHand2, str_GP2, str_GP3, str_L2
extern str_L3, str_L4, str_LeftWing2, str_Min2, str_Pct2, str_Pct3, str_PIM2, str_PlayerStats
extern str_PlayerStats2, str_PlusMinus2, str_PORTR, str_PORTR2, str_PPG2, str_Pst1, str_Pst12, str_Pst22
extern str_Pst23, str_Pstatbar3, str_Pstatbar4, str_Pt2, str_R, str_R2, str_Ratings2, str_Ratings3
extern str_RightWing2, str_SA, str_SHG2, str_Shoots2, str_Shots2, str_SO2, str_SS2, str_SS3
extern str_T2, str_W2, strcat_, sub_B30BB, sub_B4BA8, TextGridOff, TextGridOpen, TextRestoreState
extern TextSaveState, TextSetFont
global SkaterStatsCard, GoalieStatsCard
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
; C: src/front/stats_cards/GoalieStatsCard.c
%ifdef CBUILD
%include "c/front/stats_cards/GoalieStatsCard.inc"
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
