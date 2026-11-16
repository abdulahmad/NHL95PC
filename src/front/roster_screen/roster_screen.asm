; Team roster screen (95G stats95).
bits 32
%include "hockey.inc"
section s_24453 progbits alloc exec nowrite align=1
extern __CHK, cddriveptr, CmpGAA, CmpPoints, DrawArt, DrawShape, RosterFromStandings, fileoncd
extern FindShape, FitPlayerName, fputchar, FreeMemBlock, j___close_, kaufmfont, LoadBank, lseek_
extern mainfont, MakePath, open_, printfbuf, PrintFmt1, PrintFmt2, PrintOutlinedText, PrintShadowText
extern qsort_, read_, SetClipWindow, SetTextColors, sprintf_, statsbgshapes, statsfromleague, statsgoaliebuf
extern statsgoalieorder, statsgoalieplr, statsleague, statsnumgoalies, statsnumskaters, statspalshape, statsplayerbuf, statsplayerdbs
extern statsplayoffs, statsskaterbuf, statsskaterorder, statsskaterplr, statsteamdbs, str_A3, str_Bkgd2, str_C
extern str_fmt2d, str_fmt3d, str_fmt4d, str_fmt5d, str_fmtEmb, str_fmtMinSec, str_fmtPct, str_fmtPct0
extern str_G3, str_GA, str_GAA3, str_GP5, str_KeyDb, str_L5, str_MightyDucksOfAnaheim2, str_Min3
extern str_Name, str_No, str_PCT, str_PIM3, str_PlusMinus3, str_Pos, str_Pst25, str_Pstatbar6
extern str_PT, str_Regi, str_S, str_SA2, str_Shots3, str_T3, str_Trad, str_W3
extern SetScreenTarget, TextGridOff, TextGridOpen, TextRestoreState, TextSaveState, TextSetFont
global PlayerFromMouseY, TeamRosterScreen
;-----------------------------------------------------------------------------
; PlayerFromMouseY                                                24453  95 PC
; Roster hit test: y 40h.. skater rows / 1A5h.. goalie rows of 0Dh px ->
; player index; called by RunPlayerPickMenu
;-----------------------------------------------------------------------------
; C: src/front/roster_screen/PlayerFromMouseY.c
%ifdef CBUILD
%include "c/front/roster_screen/PlayerFromMouseY.inc"
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
; C: src/front/roster_screen/TeamRosterScreen.c
%ifdef CBUILD
%include "c/front/roster_screen/TeamRosterScreen.inc"
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
        call SetScreenTarget
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
        cmp dword [RosterFromStandings], byte 0
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
