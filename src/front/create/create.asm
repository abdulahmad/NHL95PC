; Create player: names, ratings, shoots / glove, the create screen (95G create95).
bits 32
%include "hockey.inc"
section s_6F159 progbits alloc exec nowrite align=1
extern __CHK, __CHP, _dos_getdiskfree_, AllocMemBlock, attdb_size, btn_CreateFreeAgent, CharClassTable, careerdb_size
extern carteamsdb_size, cddriveptr, ClearInputQueue, ClearScreen, dbdirty, DeleteTempDatabases, DrawArt, DrawBitmap
extern DrawButtons, DrawEditRosters, DrawShape, rosterlistkeys, editptrspr, facount, FadePalStep, falist
extern falistsel, FatalError, FileClose, fileoncd, FileOpenWrite, FileWriteAt, FindShape, FixJerseyNumber
extern fp_10, fp_100, fp_1000, fp_200, fp_30, fp_300, fp_347, fp_390
extern fp_500, fp_58, fp_70, fp_84, fp_90, fp_m50, fputchar, FreeMemBlock
extern fullscrbmp, GetInputEvent, goalieratingmax, goalieratingmin, GrabBlock, InputDialog, kaufmfont, keydb_size
extern KeyDbPtr, leaguedbnames, LoadBank, LoadRosterList, LoadTempDatabases, mainfont, MakePath, memcpy_
extern memset_, MessageBox, mousepollfn, MouseSetPos, msg_FreeAgentDiskSpace, msglines, newgoalieattrs_m3, newgoaliedefaults
extern newgoalieglove, newgoalieratingnames, newskaterattrs_m3, newskaterdefaults, newskaterratingnames, newskatershoots, pointerspr, PrintCenteredText
extern PrintFmt1, PrintOutlinedText, PrintShadowText, ptrupdatefn, PutBlock, F64_RatingNinety, F64_RatingTenth, randomd0
extern RemovePlayerFromTeam, rosterisfa, rosterjersey, rosterlist, rostersel, rosterslot, rosterstat, rosterteam
extern rosterteamrec, savepal, seasondb_size, SetDrawBitmap, SetPalette, SetTextColors, skaterratingmax, skaterratingmin
extern sprintf_, str_3dKbytesOfFree, str_AddAllSelectedPlayers, str_ANewFreeAgent, str_Center, str_CreateAPlayerOr, str_Defence, str_ea2
extern str_EnterAJerseyNumber, str_EnterANewRating, str_EnterAPositionFor, str_EnterNewGoalieName, str_EnterNewPlayerName, str_ErrDiskFree, str_ErrorWhileMakingNew, str_fmt3d
extern str_fmtD, str_fmtpd, str_fmtSS, str_FreeAgent, str_GloveHand, str_GloveHandLeftOr, str_Goalie, str_L9
extern str_LCRD, str_LeftWing, str_NewPlayer, str_NotAddedToDatabases, str_NotEnoughRatingUnits, str_NotEnoughSpaceTo, str_NotEnoughSpaceTo2, str_Pal2
extern str_Prez22, str_Pst2, str_Pstatbar, str_R5, str_RatingRange, str_RatingUnitsAvailable3d, str_RightWing, str_Shoots
extern str_ShootsLeftOrRight, str_space, str_spL, str_spR, str_Temp, str_ThereIsNoSpace, str_TheSelectedPlayer, str_TMP
extern str_Two, str_XXXKbytesOfFree, strcat_, strcpy_, strlen_, strupr_, SetScreenTarget, teamsdb_size
extern TextSetFont, tmpdbpath, TrackButtons, WriteLeagueDbsMem
global SplitPlayerName, MoveToOtherRoster, RatingToFloat, RandomizeNewRatings, CreatePlayerNop, DrawShootsField, DrawShootsField_tail, DrawShootsField_pop
global DrawGloveField, AskLeftRight, EditSkaterRating, EditSkaterRating_tail, EditGoalieRating, DrawCreatePlayer, CreatePlayerLoop, CreateFreeAgent
;-----------------------------------------------------------------------------
; SplitPlayerName                                                 6F159  95 PC
; Splits a full name at the first non-letter run into first name (max 15) and
; last name using the ctype table (C4B69 bit C0h)
;-----------------------------------------------------------------------------
; C: src/front/create/SplitPlayerName.c
%ifdef CBUILD
%include "c/front/create/SplitPlayerName.inc"
%else
SplitPlayerName:
        push dword 20h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 0Ch
        mov ecx, eax
        mov dword [byte esp+04h], edx
        mov dword [byte esp+08h], ebx
        call strlen_
        mov esi, eax
        xor eax, eax
.1:
        mov dl, byte [ecx+eax]
        inc dl
        and edx, 0FFh
        mov edx, dword [dword edx+CharClassTable-3]
        sar edx, 18h
        test dl, 0C0h
        jne short .2
        cmp eax, esi
        jge short .2
        inc eax
        jmp short SplitPlayerName.1
.2:
        xor edx, edx
        mov dword [esp], edx
        jmp short .6
.3:
        lea edi, [ecx+eax]
        mov bl, byte [edi]
        inc bl
        and ebx, 0FFh
        mov ebx, dword [dword ebx+CharClassTable-3]
        sar ebx, 18h
        test bl, 0C0h
        je short .4
        mov ebp, dword [byte esp+04h]
        mov bl, byte [edi]
        mov byte [edx+ebp], bl
        inc edx
        jmp short .5
.4:
        mov dword [esp], 0FFFFFFFFh
.5:
        inc eax
.6:
        cmp eax, esi
        jge short .7
        cmp edx, byte 0Fh
        jge short .7
        cmp dword [esp], byte 0
        je short SplitPlayerName.3
.7:
        mov ebx, dword [byte esp+04h]
        mov byte [edx+ebx], 0
        cmp edx, byte 0Fh
        jne short .9
        mov dl, byte [ecx+eax]
        inc dl
        and edx, 0FFh
        mov edx, dword [dword edx+CharClassTable-3]
        sar edx, 18h
        test dl, 0C0h
        je short .9
.8:
        mov dl, byte [ecx+eax]
        inc dl
        and edx, 0FFh
        mov edx, dword [dword edx+CharClassTable-3]
        sar edx, 18h
        test dl, 0C0h
        je short .9
        cmp eax, esi
        jge short .9
        inc eax
        jmp short SplitPlayerName.8
.9:
        mov dl, byte [ecx+eax]
        inc dl
        and edx, 0FFh
        mov edx, dword [dword edx+CharClassTable-3]
        sar edx, 18h
        test dl, 0C0h
        jne short .10
        cmp eax, esi
        jge short .10
        inc eax
        jmp short SplitPlayerName.9
.10:
        xor edx, edx
        mov dword [esp], edx
        jmp short .14
.11:
        lea edi, [ecx+eax]
        mov bl, byte [edi]
        inc bl
        and ebx, 0FFh
        mov ebx, dword [dword ebx+CharClassTable-3]
        sar ebx, 18h
        test bl, 0C0h
        je short .12
        mov ebp, dword [byte esp+08h]
        mov bl, byte [edi]
        mov byte [edx+ebp], bl
        inc edx
        jmp short .13
.12:
        mov dword [esp], 0FFFFFFFFh
.13:
        inc eax
.14:
        cmp eax, esi
        jge short .15
        cmp edx, byte 0Fh
        jge short .15
        cmp dword [esp], byte 0
        je short SplitPlayerName.11
.15:
        add edx, dword [byte esp+08h]
        mov byte [edx], 0
        add esp, byte 0Ch
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; MoveToOtherRoster                                               6F29C  95 PC
; 'Move to Roster N' menu item: moves the selected players to the other
; panel's team ('There is no space to add the selected player' / 'There is
; not enough space to add all selected players'), FixJerseyNumber, reloads
; and redraws
;-----------------------------------------------------------------------------
MoveToOtherRoster:
        push dword 4Ch
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 1Ch
        push edx
        push ebx
        cmp dword [eax], byte 3
        setne al
        and eax, 0FFh
        mov dword [byte esp+010h], eax
        sete al
        mov ecx, eax
        and ecx, 0FFh
        xor ebx, ebx
        mov dword [byte esp+0Ch], ebx
        mov dword [byte esp+014h], ebx
        xor ebp, ebp
        mov eax, dword [byte esp+010h]
        cmp byte [dword eax+rosterisfa], 0
        jne near .14
        mov dword [byte esp+01Ch], ebx
        jmp near .13
.1:
        mov edx, dword [byte esp+010h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        add eax, esi
        cmp byte [dword eax+rostersel], 0
        je near .12
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        mov ebx, eax
        shl ebx, 6
        sub ebx, eax
        mov eax, esi
        shl eax, 3
        sub eax, esi
        shl eax, 2
        sub eax, esi
        inc dword [byte esp+014h]
        lea edx, [ebx+eax]
        mov eax, dword [dword edx+rosterlistkeys]
        mov dword [byte esp+018h], eax
        call KeyDbPtr
        mov esi, eax
        mov dword [byte esp+020h], 0FFFFFFFFh
        cmp byte [dword edx+rosterlist], 47h
        jne short .5
        xor ebx, ebx
        jmp short .4
.2:
        mov edx, dword [nosplit ecx*4+rosterteamrec]
        mov eax, ebx
        cmp dword [dword edx+eax*4+0B0h], byte 0FFFFFFFFh
        jne short .3
        lea eax, [byte ebx+019h]
        mov dword [byte esp+020h], eax
.3:
        inc ebx
.4:
        cmp ebx, byte 3
        jge short .9
        cmp dword [byte esp+020h], byte 0
        jl short MoveToOtherRoster.2
        jmp short .9
.5:
        xor ebx, ebx
        jmp short .8
.6:
        mov edx, dword [nosplit ecx*4+rosterteamrec]
        mov eax, ebx
        cmp dword [byte edx+eax*4+04Ch], byte 0FFFFFFFFh
        jne short .7
        mov dword [byte esp+020h], ebx
.7:
        inc ebx
.8:
        cmp ebx, byte 19h
        jge short .9
        cmp dword [byte esp+020h], byte 0
        jl short MoveToOtherRoster.6
.9:
        cmp dword [byte esp+020h], byte 0
        jl near .12
        mov dword [byte esp+0Ch], 0FFFFFFFFh
        mov al, byte [dword ecx+rosterteam]
        mov byte [esi], al
        mov edx, dword [nosplit ecx*4+rosterteamrec]
        mov eax, dword [byte esp+020h]
        shl eax, 2
        inc ebp
        add eax, edx
        mov edx, dword [byte esp+018h]
        mov dword [byte eax+04Ch], edx
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 2
        mov ebx, eax
        shl ebx, 6
        sub ebx, eax
        mov edx, dword [byte esp+020h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        mov byte [dword ebx+eax+rosterstat], 2
        xor eax, eax
        mov edx, dword [byte esp+010h]
        mov al, byte [dword edx+rosterteam]
        mov edx, dword [byte esp+018h]
        call RemovePlayerFromTeam
        xor ebx, ebx
.10:
        mov edx, dword [nosplit ecx*4+rosterteamrec]
        mov eax, ebx
        mov eax, dword [byte edx+eax*4+04Ch]
        call KeyDbPtr
        mov dl, byte [byte esi+01h]
        cmp dl, byte [byte eax+01h]
        jne short .11
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 2
        mov edx, eax
        shl eax, 6
        sub eax, edx
        mov dword [byte esp+08h], eax
        mov edi, 1Ch
        sub edi, ebp
        mov eax, edi
        shl eax, 3
        sub eax, edi
        shl eax, 2
        sub eax, edi
        add eax, dword [byte esp+08h]
        mov dl, byte [byte esi+01h]
        mov byte [dword eax+rosterjersey], dl
        mov dl, byte [byte esp+020h]
        mov byte [dword eax+rosterslot], dl
        mov edx, edi
        mov eax, ecx
        call FixJerseyNumber
.11:
        inc ebx
        cmp ebx, byte 1Ch
        jl short MoveToOtherRoster.10
.12:
        inc dword [byte esp+01Ch]
.13:
        mov esi, dword [byte esp+01Ch]
        cmp esi, byte 1Ch
        jl near MoveToOtherRoster.1
        jmp near .28
.14:
        mov dword [byte esp+01Ch], ebx
        jmp near .27
.15:
        mov eax, dword [falistsel]
        mov ebx, dword [byte esp+01Ch]
        add eax, ebx
        cmp byte [eax], 0
        je near .26
        mov edx, ebx
        shl edx, 3
        sub edx, ebx
        shl edx, 2
        sub edx, ebx
        mov eax, dword [falist]
        inc dword [byte esp+014h]
        mov eax, dword [byte edx+eax+04h]
        mov dword [byte esp+018h], eax
        call KeyDbPtr
        mov esi, eax
        mov dword [byte esp+020h], 0FFFFFFFFh
        mov eax, dword [falist]
        cmp byte [edx+eax], 47h
        jne short .19
        xor ebx, ebx
        jmp short .18
.16:
        mov edx, dword [nosplit ecx*4+rosterteamrec]
        mov eax, ebx
        cmp dword [dword edx+eax*4+0B0h], byte 0FFFFFFFFh
        jne short .17
        lea eax, [byte ebx+019h]
        mov dword [byte esp+020h], eax
.17:
        inc ebx
.18:
        cmp ebx, byte 3
        jge short .23
        cmp dword [byte esp+020h], byte 0
        jl short MoveToOtherRoster.16
        jmp short .23
.19:
        xor ebx, ebx
        jmp short .22
.20:
        mov edx, dword [nosplit ecx*4+rosterteamrec]
        mov eax, ebx
        cmp dword [byte edx+eax*4+04Ch], byte 0FFFFFFFFh
        jne short .21
        mov dword [byte esp+020h], ebx
.21:
        inc ebx
.22:
        cmp ebx, byte 19h
        jge short .23
        cmp dword [byte esp+020h], byte 0
        jl short MoveToOtherRoster.20
.23:
        cmp dword [byte esp+020h], byte 0
        jl near .26
        mov dword [byte esp+0Ch], 0FFFFFFFFh
        mov al, byte [dword ecx+rosterteam]
        mov byte [esi], al
        mov edx, dword [nosplit ecx*4+rosterteamrec]
        mov eax, dword [byte esp+020h]
        shl eax, 2
        inc ebp
        add eax, edx
        mov edx, dword [byte esp+018h]
        mov dword [byte eax+04Ch], edx
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 2
        mov ebx, eax
        shl ebx, 6
        sub ebx, eax
        mov edx, dword [byte esp+020h]
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 2
        sub eax, edx
        mov byte [dword ebx+eax+rosterstat], 2
        xor ebx, ebx
.24:
        mov eax, dword [nosplit ecx*4+rosterteamrec]
        mov edx, ebx
        mov eax, dword [byte eax+edx*4+04Ch]
        call KeyDbPtr
        mov dl, byte [byte esi+01h]
        cmp dl, byte [byte eax+01h]
        jne short .25
        mov eax, ecx
        shl eax, 2
        sub eax, ecx
        shl eax, 2
        mov edx, eax
        shl eax, 6
        sub eax, edx
        mov dword [byte esp+08h], eax
        mov edi, 1Ch
        sub edi, ebp
        mov eax, edi
        shl eax, 3
        sub eax, edi
        shl eax, 2
        sub eax, edi
        add eax, dword [byte esp+08h]
        mov dl, byte [byte esi+01h]
        mov byte [dword eax+rosterjersey], dl
        mov dl, byte [byte esp+020h]
        mov byte [dword eax+rosterslot], dl
        mov edx, edi
        mov eax, ecx
        call FixJerseyNumber
.25:
        inc ebx
        cmp ebx, byte 1Ch
        jl short MoveToOtherRoster.24
.26:
        inc dword [byte esp+01Ch]
.27:
        mov eax, dword [byte esp+01Ch]
        cmp eax, dword [facount]
        jl near MoveToOtherRoster.15
.28:
        mov ecx, dword [byte esp+014h]
        cmp ebp, ecx
        je short .31
        cmp ecx, byte 1
        jne short .29
        mov dword [msglines], str_ThereIsNoSpace
        mov dword [msglines+4], str_TheSelectedPlayer
        push byte 0FFFFFFFFh
        mov esi, dword [byte esp+04h]
        push esi
        mov edi, dword [byte esp+0Ch]
        push edi
        jmp short .30
.29:
        mov dword [msglines], str_NotEnoughSpaceTo2
        mov dword [msglines+4], str_AddAllSelectedPlayers
        push byte 0FFFFFFFFh
        mov eax, dword [byte esp+04h]
        push eax
        mov edx, dword [byte esp+0Ch]
        push edx
.30:
        push byte 0
        push byte 0
        mov ecx, 2
        mov ebx, msglines
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
.31:
        cmp dword [byte esp+0Ch], byte 0
        je short .x
        mov dword [dbdirty], 1
        xor eax, eax
        call LoadRosterList
        mov eax, 1
        call LoadRosterList
        call DrawEditRosters
.x:
        add esp, byte 24h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
;-----------------------------------------------------------------------------
; RatingToFloat                                6F6AD  95 PC, medium confidence
; Returns (rating + 5) * 5 as a float (fild)
;-----------------------------------------------------------------------------
; C: src/front/create/RatingToFloat.c
%ifdef CBUILD
%include "c/front/create/RatingToFloat.inc"
%else
RatingToFloat:
        push dword 0Ch
        call __CHK
        push edx
        sub esp, byte 4
        xor edx, edx
        mov dl, al
        add edx, byte 5
        mov eax, edx
        shl eax, 2
        add eax, edx
        mov dword [esp], eax
        fild dword [esp]
        add esp, byte 4
        pop edx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; RandomizeNewRatings                          6F6D4  95 PC, medium confidence
; CreateFreeAgent: builds the new player's ratings from the chosen values
; with randomd0 and the C2CAC-C2CF0 float tables (RatingToFloat)
;-----------------------------------------------------------------------------
; C: src/front/create/RandomizeNewRatings.c
%ifdef CBUILD
%include "c/front/create/RandomizeNewRatings.inc"
%else
RandomizeNewRatings:
        push dword 64h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 50h
        mov esi, eax
        xor eax, eax
        mov al, byte [byte edx+01h]
        call RatingToFloat
        fstp dword [byte esp+01Ch]
        xor eax, eax
        mov al, byte [byte edx+02h]
        call RatingToFloat
        fstp dword [byte esp+0Ch]
        xor eax, eax
        mov al, byte [byte edx+04h]
        call RatingToFloat
        fstp dword [byte esp+014h]
        xor eax, eax
        mov al, byte [byte edx+05h]
        call RatingToFloat
        fstp dword [byte esp+02Ch]
        xor eax, eax
        mov al, byte [byte edx+06h]
        call RatingToFloat
        fstp dword [byte esp+024h]
        xor eax, eax
        mov al, byte [byte edx+07h]
        call RatingToFloat
        fstp dword [byte esp+010h]
        xor eax, eax
        mov al, byte [byte edx+09h]
        call RatingToFloat
        fstp dword [byte esp+020h]
        xor eax, eax
        mov al, byte [byte edx+0Ah]
        call RatingToFloat
        fstp dword [byte esp+034h]
        xor eax, eax
        mov al, byte [byte edx+0Bh]
        call RatingToFloat
        fstp dword [byte esp+018h]
        xor eax, eax
        mov al, byte [byte edx+0Ch]
        call RatingToFloat
        fstp dword [byte esp+03Ch]
        xor eax, eax
        mov al, byte [byte edx+0Dh]
        call RatingToFloat
        fstp dword [byte esp+028h]
        xor eax, eax
        mov al, byte [byte edx+0Eh]
        call RatingToFloat
        fstp dword [byte esp+044h]
        xor eax, eax
        mov al, byte [byte edx+013h]
        call RatingToFloat
        fstp dword [byte esp+04Ch]
        mov eax, 14Dh
        call randomd0
        mov dword [byte esp+04Ch], eax
        fild dword [byte esp+04Ch]
        fdiv dword [fp_1000]
        fld1
        fsubrp
        fstp dword [byte esp+040h]
        mov eax, 15h
        call randomd0
        add eax, byte 40h
        mov dword [byte esp+04Ch], eax
        fild dword [byte esp+04Ch]
        fstp dword [byte esp+048h]
        fld dword [byte esp+048h]
        call __CHP
        fistp dword [byte esp+04Ch]
        mov eax, dword [byte esp+04Ch]
        mov word [ebx], ax
        fld dword [byte esp+048h]
        fdiv dword [fp_84]
        fstp dword [byte esp+048h]
        fld dword [byte esp+034h]
        fadd dword [byte esp+028h]
        fadd dword [byte esp+044h]
        fdiv dword [fp_300]
        fmul dword [fp_390]
        fmul dword [byte esp+048h]
        fmul dword [byte esp+040h]
        call __CHP
        fistp dword [byte esp+04Ch]
        mov eax, dword [byte esp+04Ch]
        mov word [byte ebx+0Eh], ax
        fld dword [byte esp+034h]
        fadd dword [byte esp+018h]
        fdiv dword [fp_200]
        fmul dword [fp_100]
        fadd dword [fp_m50]
        fmul dword [byte esp+048h]
        fmul dword [byte esp+040h]
        call __CHP
        fistp dword [byte esp+04Ch]
        mov eax, dword [byte esp+04Ch]
        mov word [byte ebx+010h], ax
        fld dword [byte esp+0Ch]
        fadd dword [byte esp+034h]
        fadd dword [byte esp+024h]
        fadd dword [byte esp+01Ch]
        fadd dword [byte esp+028h]
        fdiv dword [fp_500]
        fstp dword [byte esp+08h]
        cmp byte [byte esi+02h], 44h
        je short .1
        fld dword [byte esp+044h]
        fdiv dword [fp_70]
        fstp dword [byte esp+038h]
        fld dword [fp_100]
        fsub dword [byte esp+044h]
        fdiv dword [fp_30]
        jmp short .2
.1:
        fld dword [byte esp+044h]
        fdiv dword [fp_90]
        fstp dword [byte esp+038h]
        fld dword [fp_100]
        fsub dword [byte esp+044h]
        fdiv dword [fp_10]
.2:
        fstp dword [byte esp+030h]
        fld1
        fcomp dword [byte esp+038h]
        fnstsw ax
        sahf
        jbe short .3
        fld dword [byte esp+038h]
        fmul dword [fp_58]
        call __CHP
        fistp dword [byte esp+04Ch]
        mov eax, dword [byte esp+04Ch]
        xor ecx, ecx
        mov cx, ax
        jmp short .4
.3:
        mov ecx, 3Ah
.4:
        fld1
        fcomp dword [byte esp+030h]
        fnstsw ax
        sahf
        jbe short .5
        fld dword [byte esp+030h]
        fmul dword [fp_90]
        call __CHP
        fistp dword [byte esp+04Ch]
        mov eax, dword [byte esp+04Ch]
        xor edx, edx
        mov dx, ax
        jmp short .6
.5:
        mov edx, 5Ah
.6:
        fld dword [byte esp+014h]
        fadd dword [byte esp+010h]
        fdiv dword [fp_200]
        xor eax, eax
        mov ax, cx
        mov dword [byte esp+04Ch], eax
        fild dword [byte esp+04Ch]
        fmulp
        fstp dword [byte esp+04h]
        fld dword [byte esp+020h]
        fdiv dword [fp_100]
        xor eax, eax
        mov ax, dx
        mov dword [byte esp+04Ch], eax
        fild dword [byte esp+04Ch]
        fmulp
        fstp dword [esp]
        fld dword [byte esp+08h]
        fmul dword [byte esp+04h]
        fmul dword [byte esp+048h]
        fmul dword [byte esp+040h]
        call __CHP
        fistp dword [byte esp+04Ch]
        mov eax, dword [byte esp+04Ch]
        mov ecx, eax
        fld dword [byte esp+08h]
        fmul dword [esp]
        fmul dword [byte esp+048h]
        fmul dword [byte esp+040h]
        call __CHP
        fistp dword [byte esp+04Ch]
        mov eax, dword [byte esp+04Ch]
        mov edx, eax
        xor edi, edi
        mov di, cx
        xor esi, esi
        mov si, ax
        lea ebp, [edi+esi]
        cmp ebp, 80h
        jle short .7
        mov eax, ebp
        mov edx, ebp
        sar edx, 1Fh
        shl edx, 7
        LD sbb, eax, edx
        sar eax, 7
        mov ebp, eax
        mov eax, edi
        mov edx, edi
        sar edx, 1Fh
        idiv ebp
        mov ecx, eax
        xor edx, edx
        mov dx, ax
        add edx, esi
        mov eax, edx
        sar edx, 1Fh
        shl edx, 7
        LD sbb, eax, edx
        sar eax, 7
        mov edi, eax
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv edi
        mov edx, eax
.7:
        mov word [byte ebx+02h], cx
        mov word [byte ebx+04h], dx
        mov ax, word [byte ebx+02h]
        add eax, edx
        mov word [byte ebx+06h], ax
        xor edx, edx
        mov dx, word [byte ebx+02h]
        mov ecx, 0Ah
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov word [byte ebx+08h], ax
        xor eax, eax
        mov ax, word [byte ebx+08h]
        call randomd0
        mov word [byte ebx+0Ah], ax
        fld dword [byte esp+03Ch]
        fmul qword [F64_RatingNinety]
        fstp dword [byte esp+03Ch]
        fld dword [byte esp+02Ch]
        fmul qword [F64_RatingTenth]
        fstp dword [byte esp+02Ch]
        fld dword [byte esp+03Ch]
        fadd dword [byte esp+02Ch]
        fdiv dword [fp_100]
        fmul dword [fp_347]
        fmul dword [byte esp+048h]
        fmul dword [byte esp+040h]
        call __CHP
        fistp dword [byte esp+04Ch]
        mov eax, dword [byte esp+04Ch]
        mov word [byte ebx+0Ch], ax
        add esp, byte 50h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CreatePlayerNop                                                 6FA72  95 PC
; Empty function (ret only), unreferenced
;-----------------------------------------------------------------------------
; C: src/front/create/CreatePlayerNop.c
%ifdef CBUILD
%include "c/front/create/CreatePlayerNop.inc"
%else
CreatePlayerNop:
        push dword 4
        call __CHK
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawShootsField                                                 6FA7D  95 PC
; Draws 'Shoots' and '  L' / '  R' with its value on the create-player screen
;-----------------------------------------------------------------------------
; C: src/front/create/DrawShootsField.c
%ifdef CBUILD
%include "c/front/create/DrawShootsField.inc"
%else
DrawShootsField:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 8
        mov esi, 12Ah
        mov dword [byte esp+04h], newskatershoots
        mov ebx, str_Shoots
        mov edx, esi
        mov eax, 1Eh
        call PrintShadowText
        cmp byte [newskatershoots], 0
        je short .1
        mov ebx, str_spL
        jmp short .2
.1:
        mov ebx, str_spR
.2:
        mov edx, esi
        mov eax, 0C8h
        call PrintShadowText
        xor ebp, ebp
        mov edi, 1
        add esi, byte 0Dh
.3:
        cmp edi, byte 8
        jne short .4
        mov ebp, 136h
        sub esi, byte 68h
.4:
        mov ebx, dword [nosplit edi*4+newskaterratingnames]
        lea eax, [byte ebp+01Eh]
        mov edx, esi
        call PrintShadowText
        mov eax, dword [byte esp+04h]
        xor ebx, ebx
        mov bl, byte [edi+eax]
        add ebx, byte 5
        mov ecx, ebx
        shl ecx, 2
        add ecx, ebx
        lea ebx, [dword ebp+0C8h]
        mov dword [esp], ebx
        mov ebx, str_fmt3d
        mov edx, esi
        mov eax, dword [esp]
        call PrintFmt1
        add esi, byte 0Dh
        inc edi
        cmp edi, byte 0Fh
        jl short DrawShootsField.3
DrawShootsField_tail:
        add esp, byte 8
DrawShootsField_pop:
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawGloveField                                                  6FB35  95 PC
; Draws 'Glove Hand' and '  L' / '  R' on the create-goalie screen
;-----------------------------------------------------------------------------
; C: src/front/create/DrawShootsField.c (DrawGloveField)
%ifdef CBUILD
%include "c/front/create/DrawShootsField.DrawGloveField.inc"
%else
DrawGloveField:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 8
        mov esi, 12Ah
        mov dword [byte esp+04h], newgoalieglove
        mov ebx, str_GloveHand
        mov edx, esi
        mov eax, 1Eh
        call PrintShadowText
        cmp byte [newgoalieglove], 0
        je short .1
        mov ebx, str_spL
        jmp short .2
.1:
        mov ebx, str_spR
.2:
        mov edx, esi
        mov eax, 0C8h
        call PrintShadowText
        xor ebp, ebp
        mov edi, 1
        add esi, byte 0Dh
.3:
        cmp edi, byte 6
        jne short .4
        mov ebp, 136h
        sub esi, byte 4Eh
.4:
        mov ebx, dword [nosplit edi*4+newgoalieratingnames]
        lea eax, [byte ebp+01Eh]
        mov edx, esi
        call PrintShadowText
        mov eax, dword [byte esp+04h]
        xor ebx, ebx
        mov bl, byte [edi+eax]
        add ebx, byte 5
        mov ecx, ebx
        shl ecx, 2
        add ecx, ebx
        lea ebx, [dword ebp+0C8h]
        mov dword [esp], ebx
        mov ebx, str_fmt3d
        mov edx, esi
        mov eax, dword [esp]
        call PrintFmt1
        add esi, byte 0Dh
        inc edi
        cmp edi, byte 0Bh
        jl short DrawGloveField.3
        jmp near DrawShootsField_tail
%endif ; C
;-----------------------------------------------------------------------------
; AskLeftRight                                                    6FBE8  95 PC
; (&flag, prompt): one-key input dialog, L/l sets 1, R/r sets 0
;-----------------------------------------------------------------------------
; C: src/front/create/AskLeftRight.c
%ifdef CBUILD
%include "c/front/create/AskLeftRight.inc"
%else
AskLeftRight:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push esi
        sub esp, byte 4
        mov esi, eax
        cmp byte [eax], 0
        je short .1
        mov ax, word [str_L9]
        jmp short .2
.1:
        mov ax, word [str_R5]
.2:
        mov word [esp], ax
        mov dword [msglines], edx
        push byte 0
        push byte 0
        push byte 0
        push byte 0
        push byte 10h
        mov ecx, 1
        lea ebx, [byte esp+014h]
        mov edx, ecx
        mov eax, msglines
        call InputDialog
        cmp al, 0FFh
        je short .x
        mov dl, byte [esp]
        cmp dl, 4Ch
        je short .3
        cmp dl, 6Ch
        jne short .4
.3:
        mov byte [esi], 1
        jmp short .x
.4:
        cmp dl, 52h
        je short .5
        cmp dl, 72h
        jne short .x
.5:
        mov byte [esi], 0
.x:
        add esp, byte 4
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; EditSkaterRating                                                6FC60  95 PC
; Create-player rating click: 'Enter a new rating:' with '%2d < %s < %2d'
; limits, 'Shoots Left or Right?' (AskLeftRight), 'Not enough Rating Units'
;-----------------------------------------------------------------------------
EditSkaterRating:
        push dword 0D4h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, 0A0h
        push eax
        push edx
        push ebx
        xor edx, edx
        mov dword [dword esp+098h], edx
        mov dword [dword esp+09Ch], edx
        mov dword [dword esp+0A8h], 12Ah
        xor ebp, ebp
        jmp near .8
.1:
        cmp ebp, byte 8
        jne short .2
        mov dword [dword esp+09Ch], 136h
        sub dword [dword esp+0A8h], byte 68h
.2:
        mov eax, dword [dword esp+09Ch]
        add eax, 0C8h
        mov edx, dword [byte esp+08h]
        mov ebx, dword [edx]
        cmp eax, ebx
        jg near .7
        mov eax, dword [dword esp+09Ch]
        add eax, 0E4h
        cmp eax, ebx
        jle near .7
        mov eax, dword [byte esp+04h]
        mov eax, dword [eax]
        mov esi, dword [dword esp+0A8h]
        cmp eax, esi
        jl near .7
        lea eax, [byte esi+0Dh]
        mov edx, dword [byte esp+04h]
        cmp eax, dword [edx]
        jle near .7
        mov dword [dword esp+098h], 1
        mov dword [dword esp+094h], newskatershoots
        lea edi, [byte esp+040h]
        mov esi, str_EnterANewRating
        movsd
        movsd
        movsd
        movsd
        movsd
        lea eax, [byte esp+040h]
        mov dword [msglines], eax
        mov edi, skaterratingmax
        add edi, ebp
        xor eax, eax
        mov al, byte [edi]
        add eax, byte 5
        mov ebx, eax
        shl ebx, 2
        add ebx, eax
        push ebx
        mov ebx, dword [nosplit ebp*4+newskaterratingnames]
        push ebx
        mov eax, skaterratingmin
        add eax, ebp
        mov dword [dword esp+0A8h], eax
        xor eax, eax
        mov edx, dword [dword esp+0A8h]
        mov al, byte [edx]
        add eax, byte 5
        mov ebx, eax
        shl ebx, 2
        add ebx, eax
        push ebx
        push str_RatingRange
        lea eax, [byte esp+01Ch]
        push eax
        call sprintf_
        add esp, byte 14h
        lea eax, [byte esp+0Ch]
        mov dword [msglines+4], eax
        mov esi, newskatershoots
        add esi, ebp
        test ebp, ebp
        jne short .3
        mov edx, str_ShootsLeftOrRight
        mov eax, esi
        call AskLeftRight
        jmp near .7
.3:
        xor eax, eax
        mov al, byte [esi]
        add eax, byte 5
        mov ebx, eax
        shl ebx, 2
        add ebx, eax
        push ebx
        push str_fmtpd
        lea eax, [byte esp+07Ch]
        push eax
        call sprintf_
        add esp, byte 0Ch
        xor edx, edx
        mov dl, byte [esi]
        add edx, byte 5
        mov eax, edx
        shl eax, 2
        add eax, edx
        mov dword [dword esp+0A4h], eax
        push byte 0
        xor eax, eax
        mov al, byte [edi]
        add eax, byte 5
        mov ebx, eax
        shl ebx, 2
        add ebx, eax
        push ebx
        xor eax, eax
        mov edx, dword [dword esp+0A8h]
        mov al, byte [edx]
        add eax, byte 5
        mov ebx, eax
        shl ebx, 2
        add ebx, eax
        push ebx
        push byte 0FFFFFFFFh
        push byte 1Ch
        mov ecx, 2
        lea ebx, [dword esp+088h]
        mov edx, ecx
        mov eax, msglines
        call InputDialog
        xor ebx, ebx
        mov bl, al
        cmp ebx, 0FFh
        je near .7
        xor edx, edx
        mov eax, dword [dword esp+0A0h]
        mov dl, byte [eax]
        add edx, byte 5
        mov eax, edx
        shl eax, 2
        add eax, edx
        cmp ebx, eax
        jl near .7
        xor edx, edx
        mov dl, byte [edi]
        add edx, byte 5
        mov eax, edx
        shl eax, 2
        add eax, edx
        cmp ebx, eax
        jg near .7
        mov edi, 5
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv edi
        sub eax, edi
        mov ecx, dword [dword esp+0A4h]
        cmp ebx, ecx
        jge short .4
        mov byte [esi], al
        test ebp, ebp
        je near .7
        cmp ebp, byte 3
        je near .7
        cmp ebp, byte 0Dh
        je near .7
        xor eax, eax
        mov al, byte [esi]
        add eax, edi
        mov ebx, eax
        shl ebx, 2
        add ebx, eax
        mov eax, ecx
        sub eax, ebx
        mov edx, dword [esp]
        add dword [edx], eax
        jmp near .7
.4:
        mov edx, ebx
        sub edx, ecx
        test ebp, ebp
        je short .6
        cmp ebp, byte 3
        je short .6
        cmp ebp, byte 0Dh
        je short .6
        mov ebx, dword [esp]
        cmp edx, dword [ebx]
        jg short .5
        mov byte [esi], al
        xor eax, eax
        mov al, byte [esi]
        add eax, edi
        mov ebx, eax
        shl ebx, 2
        add ebx, eax
        sub ebx, dword [dword esp+0A4h]
        mov eax, dword [esp]
        sub dword [eax], ebx
        jmp short .7
.5:
        mov dword [msglines], str_NotEnoughRatingUnits
        push byte 0FFFFFFFFh
        mov edi, dword [byte esp+08h]
        push edi
        mov eax, dword [byte esp+010h]
        push eax
        push byte 0
        push byte 0
        mov ecx, 1
        mov ebx, msglines
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        jmp short .7
.6:
        mov esi, 5
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv esi
        sub eax, esi
        mov dl, al
        mov eax, dword [dword esp+094h]
        mov byte [eax+ebp], dl
.7:
        inc ebp
        add dword [dword esp+0A8h], byte 0Dh
.8:
        cmp ebp, byte 0Fh
        jge short EditSkaterRating_tail
        cmp dword [dword esp+098h], byte 0
        je near EditSkaterRating.1
EditSkaterRating_tail:
        mov eax, dword [dword esp+098h]
        add esp, 0ACh
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
;-----------------------------------------------------------------------------
; EditGoalieRating                                                6FF69  95 PC
; Goalie version of EditSkaterRating ('Glove hand Left or Right?')
;-----------------------------------------------------------------------------
EditGoalieRating:
        push dword 0D4h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, 0A0h
        push eax
        push edx
        push ebx
        xor edx, edx
        mov dword [dword esp+098h], edx
        mov dword [dword esp+09Ch], edx
        mov dword [dword esp+0A8h], 12Ah
        xor ebp, ebp
        jmp near .8
.1:
        cmp ebp, byte 6
        jne short .2
        mov dword [dword esp+09Ch], 136h
        sub dword [dword esp+0A8h], byte 4Eh
.2:
        mov eax, dword [dword esp+09Ch]
        add eax, 0C8h
        mov edx, dword [byte esp+08h]
        mov ebx, dword [edx]
        cmp eax, ebx
        jg near .7
        mov eax, dword [dword esp+09Ch]
        add eax, 0E4h
        cmp eax, ebx
        jle near .7
        mov eax, dword [byte esp+04h]
        mov eax, dword [eax]
        mov esi, dword [dword esp+0A8h]
        cmp eax, esi
        jl near .7
        lea eax, [byte esi+0Dh]
        mov edx, dword [byte esp+04h]
        cmp eax, dword [edx]
        jle near .7
        mov dword [dword esp+098h], 1
        mov dword [dword esp+094h], newgoalieglove
        lea edi, [byte esp+040h]
        mov esi, str_EnterANewRating
        movsd
        movsd
        movsd
        movsd
        movsd
        lea eax, [byte esp+040h]
        mov dword [msglines], eax
        mov edi, goalieratingmax
        add edi, ebp
        xor eax, eax
        mov al, byte [edi]
        add eax, byte 5
        mov ebx, eax
        shl ebx, 2
        add ebx, eax
        push ebx
        mov ebx, dword [nosplit ebp*4+newgoalieratingnames]
        push ebx
        mov eax, goalieratingmin
        add eax, ebp
        mov dword [dword esp+0A8h], eax
        xor eax, eax
        mov edx, dword [dword esp+0A8h]
        mov al, byte [edx]
        add eax, byte 5
        mov ebx, eax
        shl ebx, 2
        add ebx, eax
        push ebx
        push str_RatingRange
        lea eax, [byte esp+01Ch]
        push eax
        call sprintf_
        add esp, byte 14h
        lea eax, [byte esp+0Ch]
        mov dword [msglines+4], eax
        mov esi, newgoalieglove
        add esi, ebp
        test ebp, ebp
        jne short .3
        mov edx, str_GloveHandLeftOr
        mov eax, esi
        call AskLeftRight
        jmp near .7
.3:
        xor eax, eax
        mov al, byte [esi]
        add eax, byte 5
        mov ebx, eax
        shl ebx, 2
        add ebx, eax
        push ebx
        push str_fmtpd
        lea eax, [byte esp+07Ch]
        push eax
        call sprintf_
        add esp, byte 0Ch
        xor edx, edx
        mov dl, byte [esi]
        add edx, byte 5
        mov eax, edx
        shl eax, 2
        add eax, edx
        mov dword [dword esp+0A4h], eax
        push byte 0
        xor eax, eax
        mov al, byte [edi]
        add eax, byte 5
        mov ebx, eax
        shl ebx, 2
        add ebx, eax
        push ebx
        xor eax, eax
        mov edx, dword [dword esp+0A8h]
        mov al, byte [edx]
        add eax, byte 5
        mov ebx, eax
        shl ebx, 2
        add ebx, eax
        push ebx
        push byte 0FFFFFFFFh
        push byte 1Ch
        mov ecx, 2
        lea ebx, [dword esp+088h]
        mov edx, ecx
        mov eax, msglines
        call InputDialog
        xor ebx, ebx
        mov bl, al
        cmp ebx, 0FFh
        je near .7
        xor edx, edx
        mov eax, dword [dword esp+0A0h]
        mov dl, byte [eax]
        add edx, byte 5
        mov eax, edx
        shl eax, 2
        add eax, edx
        cmp ebx, eax
        jl near .7
        xor edx, edx
        mov dl, byte [edi]
        add edx, byte 5
        mov eax, edx
        shl eax, 2
        add eax, edx
        cmp ebx, eax
        jg near .7
        mov edi, 5
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv edi
        sub eax, edi
        mov ecx, dword [dword esp+0A4h]
        cmp ebx, ecx
        jge short .4
        mov byte [esi], al
        test ebp, ebp
        je near .7
        cmp ebp, byte 8
        je near .7
        xor eax, eax
        mov al, byte [esi]
        add eax, edi
        mov ebx, eax
        shl ebx, 2
        add ebx, eax
        mov eax, ecx
        sub eax, ebx
        mov edx, dword [esp]
        add dword [edx], eax
        jmp near .7
.4:
        mov edx, ebx
        sub edx, ecx
        test ebp, ebp
        je short .6
        cmp ebp, byte 8
        je short .6
        mov ebx, dword [esp]
        cmp edx, dword [ebx]
        jg short .5
        mov byte [esi], al
        xor eax, eax
        mov al, byte [esi]
        add eax, edi
        mov ebx, eax
        shl ebx, 2
        add ebx, eax
        sub ebx, dword [dword esp+0A4h]
        mov eax, dword [esp]
        sub dword [eax], ebx
        jmp short .7
.5:
        mov dword [msglines], str_NotEnoughRatingUnits
        push byte 0FFFFFFFFh
        mov edi, dword [byte esp+08h]
        push edi
        mov eax, dword [byte esp+010h]
        push eax
        push byte 0
        push byte 0
        mov ecx, 1
        mov ebx, msglines
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        jmp short .7
.6:
        mov esi, 5
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv esi
        sub eax, esi
        mov dl, al
        mov eax, dword [dword esp+094h]
        mov byte [eax+ebp], dl
.7:
        inc ebp
        add dword [dword esp+0A8h], byte 0Dh
.8:
        cmp ebp, byte 0Fh
        jge near EditSkaterRating_tail
        cmp dword [dword esp+098h], byte 0
        je near EditGoalieRating.1
        jmp near EditSkaterRating_tail
;-----------------------------------------------------------------------------
; DrawCreatePlayer                                                7025B  95 PC
; Draws the create-player screen (pstatbar, 'Free Agent', name, position
; Center/Defence/Left Wing/Right Wing/Goalie, ratings, 'Rating Units
; Available <%3d>')
;-----------------------------------------------------------------------------
; C: src/front/create/DrawCreatePlayer.c
%ifdef CBUILD
%include "c/front/create/DrawCreatePlayer.inc"
%else
DrawCreatePlayer:
        push dword 6Ch
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 44h
        mov ebp, eax
        mov dword [byte esp+040h], edx
        mov edx, dword [fullscrbmp]
        push edx
        call SetDrawBitmap
        add esp, byte 4
        xor ecx, ecx
        mov ebx, str_Prez22
        cmp byte [fileoncd+01C3h], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
        mov eax, esp
        call MakePath
        push byte 20h
        lea eax, [byte esp+04h]
        push eax
        call LoadBank
        mov esi, eax
        add esp, byte 8
        push str_Pal2
        push eax
        call FindShape
        add esp, byte 8
        lea edx, [byte eax+010h]
        mov ebx, 300h
        mov eax, savepal
        call memcpy_
        push str_ea2
        push esi
        call FindShape
        add esp, byte 8
        push eax
        call DrawShape
        add esp, byte 4
        push esi
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov ebx, str_Pstatbar
        cmp byte [fileoncd+013Ch], 1
        jne short .3
        mov edx, dword [cddriveptr]
        jmp short .4
.3:
        xor edx, edx
.4:
        mov eax, esp
        call MakePath
        push byte 0
        lea eax, [byte esp+04h]
        push eax
        call LoadBank
        mov esi, eax
        add esp, byte 8
        push str_Pst2
        push eax
        call FindShape
        add esp, byte 8
        push eax
        call DrawShape
        add esp, byte 4
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov ebx, dword [kaufmfont]
        push ebx
        call TextSetFont
        add esp, byte 4
        mov edx, 42h
        mov eax, 40h
        call SetTextColors
        mov edi, esp
        mov esi, str_FreeAgent
        movsd
        movsd
        movsw
        movsb
        mov eax, esp
        push eax
        call fputchar
        add esp, byte 4
        sar eax, 1
        mov edx, 140h
        sub edx, eax
        mov eax, edx
        mov ebx, esp
        mov edx, 52h
        call PrintOutlinedText
        mov edx, 42h
        mov eax, 40h
        call SetTextColors
        lea eax, [byte ebp+013h]
        push eax
        lea eax, [byte ebp+03h]
        push eax
        push str_fmtSS
        lea eax, [byte esp+0Ch]
        push eax
        call sprintf_
        add esp, byte 10h
        mov edx, esp
        mov eax, 98h
        call PrintCenteredText
        xor eax, eax
        mov al, byte [byte ebp+01h]
        push eax
        push str_fmtD
        lea eax, [byte esp+08h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov al, byte [byte ebp+02h]
        cmp al, 47h
        jb short .5
        jbe short .10
        cmp al, 4Ch
        jb short .12
        jbe short .8
        cmp al, 52h
        je short .9
        jmp short .12
.5:
        cmp al, 43h
        jb short .12
        jbe short .6
        cmp al, 44h
        je short .7
        jmp short .12
.6:
        mov edx, str_Center
        jmp short .11
.7:
        mov edx, str_Defence
        jmp short .11
.8:
        mov edx, str_LeftWing
        jmp short .11
.9:
        mov edx, str_RightWing
        jmp short .11
.10:
        mov edx, str_Goalie
.11:
        mov eax, esp
        call strcat_
.12:
        mov edx, esp
        mov eax, 0B2h
        call PrintCenteredText
        mov ecx, dword [mainfont]
        push ecx
        call TextSetFont
        add esp, byte 4
        cmp byte [byte ebp+02h], 47h
        jne short .13
        call DrawGloveField
        jmp short .14
.13:
        call DrawShootsField
.14:
        mov esi, dword [byte esp+040h]
        push esi
        push str_RatingUnitsAvailable3d
        lea eax, [byte esp+08h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        mov edx, esp
        mov eax, 110h
        call PrintCenteredText
        mov edx, 2
        mov eax, str_Two
        call DrawButtons
        call SetScreenTarget
        mov eax, dword [fullscrbmp]
        mov edi, dword [byte eax+02Ch]
        push edi
        call DrawBitmap
        add esp, byte 4
        add esp, byte 44h
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CreatePlayerLoop                             704A6  95 PC, medium confidence
; Create-player screen loop: DrawCreatePlayer, mouse clicks to
; EditSkaterRating / EditGoalieRating
;-----------------------------------------------------------------------------
; C: src/front/create/DrawShootsField.c (CreatePlayerLoop)
%ifdef CBUILD
%include "c/front/create/DrawShootsField.CreatePlayerLoop.inc"
%else
CreatePlayerLoop:
        push dword 44h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 1Ch
        mov ebp, eax
        mov dword [byte esp+08h], 118h
        xor ebx, ebx
        mov dword [byte esp+014h], ebx
        push byte 20h
        push dword 300h
        push str_Temp
        call AllocMemBlock
        mov esi, eax
        add esp, byte 0Ch
        mov dword [byte esp+0Ch], eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, esi
        mov eax, 1
        call FadePalStep
        cmp byte [byte ebp+02h], 47h
        jne short .1
        mov dword [byte esp+08h], 104h
        mov edi, newgoalieglove
        mov esi, newgoaliedefaults
        movsd
        movsd
        movsd
        movsd
        jmp short .2
.1:
        mov edi, newskatershoots
        mov esi, newskaterdefaults
        movsd
        movsd
        movsd
        movsd
        movsd
.2:
        mov edx, dword [byte esp+08h]
        mov eax, ebp
        call DrawCreatePlayer
        mov esi, 0F0h
        push esi
        mov edi, 140h
        push edi
        mov eax, dword [editptrspr]
        push eax
        call GrabBlock
        add esp, byte 0Ch
        push esi
        push edi
        mov edx, dword [pointerspr]
        push edx
        call DrawArt
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, dword [byte esp+0Ch]
        xor eax, eax
        call FadePalStep
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call FreeMemBlock
        add esp, byte 4
        mov dword [esp], esi
        push esi
        mov dword [byte esp+08h], edi
        push edi
        call MouseSetPos
        add esp, byte 8
        call dword [mousepollfn]
        call ClearInputQueue
.3:
        xor edx, edx
        mov dword [byte esp+018h], edx
.4:
        call GetInputEvent
        mov ecx, eax
        test eax, eax
        je short .5
        mov ebx, esp
        lea edx, [byte esp+04h]
        call dword [ptrupdatefn]
        mov dword [byte esp+018h], eax
.5:
        test ecx, ecx
        je short .6
        test byte [byte esp+018h], 2
        je short CreatePlayerLoop.4
.6:
        test byte [byte esp+018h], 2
        jne short .8
        cmp edi, dword [byte esp+04h]
        jne short .7
        cmp esi, dword [esp]
        je near .14
.7:
        push esi
        push edi
        mov ebx, dword [editptrspr]
        push ebx
        call PutBlock
        add esp, byte 0Ch
        mov ecx, dword [esp]
        push ecx
        mov esi, dword [byte esp+08h]
        push esi
        mov edi, dword [editptrspr]
        push edi
        call GrabBlock
        add esp, byte 0Ch
        mov eax, dword [esp]
        push eax
        mov edx, dword [byte esp+08h]
        push edx
        mov ebx, dword [pointerspr]
        push ebx
        jmp near .13
.8:
        push esi
        push edi
        mov ebx, dword [editptrspr]
        push ebx
        call PutBlock
        add esp, byte 0Ch
        cmp byte [byte ebp+02h], 47h
        jne short .9
        lea ebx, [byte esp+08h]
        mov edx, esp
        lea eax, [byte esp+04h]
        call EditGoalieRating
        jmp short .10
.9:
        lea ebx, [byte esp+08h]
        mov edx, esp
        lea eax, [byte esp+04h]
        call EditSkaterRating
.10:
        test eax, eax
        je short .11
        mov edx, dword [byte esp+08h]
        mov eax, ebp
        call DrawCreatePlayer
        jmp short .12
.11:
        mov ecx, dword [byte esp+018h]
        push ecx
        mov ecx, dword [byte esp+04h]
        mov ebx, dword [byte esp+08h]
        mov edx, 2
        mov eax, str_Two
        call TrackButtons
        mov dword [byte esp+010h], eax
        test eax, eax
        jl short .12
        mov dword [byte esp+014h], 1
.12:
        mov edi, dword [esp]
        push edi
        mov eax, dword [byte esp+08h]
        push eax
        mov edx, dword [editptrspr]
        push edx
        call GrabBlock
        add esp, byte 0Ch
        mov ebx, dword [esp]
        push ebx
        mov ecx, dword [byte esp+08h]
        push ecx
        mov esi, dword [pointerspr]
        push esi
.13:
        call DrawArt
        add esp, byte 0Ch
        mov edi, dword [byte esp+04h]
        mov esi, dword [esp]
.14:
        cmp dword [byte esp+014h], byte 0
        je near CreatePlayerLoop.3
        mov eax, dword [byte esp+010h]
        add esp, byte 1Ch
        jmp near DrawShootsField_pop
%endif ; C
;-----------------------------------------------------------------------------
; CreateFreeAgent                                                 706E2  95 PC
; 'Create Free Agent ...' menu item: disk-space check ('Not enough space to
; create a new free agent.'), 'Enter the name of the new player/goalie',
; 'Enter a position for (L,C,R,D)', 'Enter a jersey number for',
; CreatePlayerLoop, writes the player into .TMP database copies ('Error while
; making new databases!')
;-----------------------------------------------------------------------------
; C: src/front/create/CreateFreeAgent.c
%ifdef CBUILD
%include "c/front/create/CreateFreeAgent.inc"
%else
CreateFreeAgent:
        push dword 20Ch
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, 1DCh
        push edx
        push ebx
        mov edx, 0FFFFFFFFh
        mov dword [dword esp+01DCh], edx
        mov dword [dword esp+01D8h], edx
        mov dword [dword esp+01D4h], edx
        mov dword [dword esp+01E0h], edx
        lea edx, [dword esp+01CCh]
        xor eax, eax
        call _dos_getdiskfree_
        test eax, eax
        je short .1
        push str_ErrDiskFree
        call FatalError
        add esp, byte 4
.1:
        xor esi, esi
        mov si, word [dword esp+01D0h]
        xor eax, eax
        mov ax, word [dword esp+01D2h]
        imul esi, eax
        mov eax, dword [seasondb_size]
        add eax, byte 36h
        mov dword [dword esp+018Ch], eax
        mov eax, dword [careerdb_size]
        add eax, byte 2Ch
        mov dword [dword esp+0190h], eax
        mov eax, dword [attdb_size]
        add eax, byte 14h
        mov dword [dword esp+01A0h], eax
        mov eax, dword [keydb_size]
        add eax, byte 34h
        mov dword [dword esp+0198h], eax
        mov eax, dword [carteamsdb_size]
        mov dword [dword esp+0194h], eax
        mov eax, dword [teamsdb_size]
        mov dword [dword esp+019Ch], eax
        xor edi, edi
        mov dword [dword esp+01A4h], edi
        xor ecx, ecx
        xor ebx, ebx
.2:
        mov edx, dword [dword esp+ebx*4+018Ch]
        add edx, esi
        dec edx
        mov eax, edx
        sar edx, 1Fh
        idiv esi
        add ecx, eax
        inc ebx
        cmp ebx, byte 6
        jl short CreateFreeAgent.2
        xor eax, eax
        mov ax, word [dword esp+01CEh]
        cmp ecx, eax
        jle short .4
        mov edx, ecx
        imul edx, esi
        mov eax, edx
        sar edx, 1Fh
        shl edx, 0Ah
        LD sbb, eax, edx
        sar eax, 0Ah
        push eax
        push str_3dKbytesOfFree
        push str_XXXKbytesOfFree
        call sprintf_
        add esp, byte 0Ch
        push dword 320h
        mov edi, dword [byte esp+04h]
        push edi
        mov ebp, dword [byte esp+0Ch]
        push ebp
        push byte 0
        push byte 0
        mov ecx, 3
        mov ebx, msg_FreeAgentDiskSpace
.3:
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        jmp near .x
.4:
        cmp dword [facount], byte 1Eh
        jl short .5
        mov dword [msglines], str_NotEnoughSpaceTo
        mov dword [msglines+4], str_ANewFreeAgent
        push byte 0FFFFFFFFh
        mov ecx, dword [byte esp+04h]
        push ecx
        mov esi, dword [byte esp+0Ch]
        push esi
        push byte 0
        push byte 0
        mov ecx, 2
        mov ebx, msglines
        jmp short CreateFreeAgent.3
.5:
        mov dword [msglines], str_CreateAPlayerOr
        push byte 0FFFFFFFFh
        mov edx, dword [byte esp+04h]
        push edx
        mov ebx, dword [byte esp+0Ch]
        push ebx
        push byte 2
        push btn_CreateFreeAgent
        mov ecx, 1
        mov ebx, msglines
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov esi, eax
        test eax, eax
        jl near .x
        jne short .6
        mov dword [msglines], str_EnterNewPlayerName
        jmp short .7
.6:
        mov dword [msglines], str_EnterNewGoalieName
.7:
        xor ah, ah
        mov byte [dword esp+014Ch], ah
        push byte 0
        push byte 0
        push byte 0
        push byte 0
        push dword 0BAh
        mov ecx, 1Fh
        lea ebx, [dword esp+0160h]
        mov edx, 1
        mov eax, msglines
        call InputDialog
        cmp eax, byte 0FFFFFFFFh
        je near .x
        lea eax, [dword esp+014Ch]
        call strlen_
        test eax, eax
        je near .x
        xor dl, dl
        mov byte [dword esp+097h], dl
        mov byte [dword esp+0A7h], dl
        lea ebx, [dword esp+0A7h]
        lea edx, [dword esp+097h]
        lea eax, [dword esp+014Ch]
        call SplitPlayerName
        lea edx, [dword esp+097h]
        lea eax, [dword esp+016Ch]
        call strcpy_
        mov edx, str_space
        lea eax, [dword esp+016Ch]
        call strcat_
        lea edx, [dword esp+0A7h]
        lea eax, [dword esp+016Ch]
        call strcat_
        test esi, esi
        jne near .11
        mov dword [msglines], str_EnterAPositionFor
        lea eax, [dword esp+016Ch]
        mov dword [msglines+4], eax
        mov dword [msglines+8], str_LCRD
        xor bh, bh
        mov byte [dword esp+014Ch], bh
.8:
        push byte 0
        push byte 0
        push byte 0
        push byte 0
        push byte 0Eh
        mov ecx, 1
        lea ebx, [dword esp+0160h]
        mov edx, 3
        mov eax, msglines
        call InputDialog
        cmp eax, byte 0FFFFFFFFh
        je near .x
        lea eax, [dword esp+014Ch]
        call strlen_
        test eax, eax
        je near .x
        lea eax, [dword esp+014Ch]
        call strupr_
        mov cl, byte [dword esp+014Ch]
        cmp cl, 43h
        je short .9
        cmp cl, 4Ch
        je short .9
        cmp cl, 52h
        je short .9
        cmp cl, 44h
        je short .9
        mov eax, 1
        jmp short .10
.9:
        xor eax, eax
.10:
        test eax, eax
        setne al
        and eax, 0FFh
        jne short CreateFreeAgent.8
        mov ebx, 1
        lea edx, [dword esp+014Ch]
        lea eax, [dword esp+096h]
        call memcpy_
        jmp short .12
.11:
        mov byte [dword esp+096h], 47h
.12:
        mov eax, dword [seasondb_size]
        mov dword [dword esp+0C0h], eax
        mov eax, dword [careerdb_size]
        mov dword [dword esp+0BCh], eax
        mov eax, dword [attdb_size]
        mov dword [dword esp+0B8h], eax
        mov ebx, 4
        xor edx, edx
        lea eax, [dword esp+0C4h]
        call memset_
        mov dword [msglines], str_EnterAJerseyNumber
        lea eax, [dword esp+016Ch]
        mov dword [msglines+4], eax
        xor dl, dl
        mov byte [dword esp+014Ch], dl
        push byte 0
        push byte 63h
        push byte 0
        push byte 0FFFFFFFFh
        push byte 16h
        mov ecx, 2
        lea ebx, [dword esp+0160h]
        mov edx, ecx
        mov eax, msglines
        call InputDialog
        test eax, eax
        jl near .x
        mov byte [dword esp+095h], al
        mov byte [dword esp+094h], 0FFh
        push byte 20h
        push dword 300h
        push str_Temp
        call AllocMemBlock
        mov esi, eax
        add esp, byte 0Ch
        mov edi, eax
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        lea eax, [dword esp+094h]
        call CreatePlayerLoop
        cmp eax, byte 1
        jl near .26
        mov ebx, 10h
        mov edx, esi
        mov eax, 1
        call FadePalStep
        push byte 0
        call ClearScreen
        add esp, byte 4
        mov eax, str_TMP
        call WriteLeagueDbsMem
        mov ebx, dword [leaguedbnames]
        mov ecx, str_TMP
        xor edx, edx
        mov eax, tmpdbpath
        call MakePath
        lea edx, [dword esp+01DCh]
        mov eax, tmpdbpath
        call FileOpenWrite
        mov ebx, eax
        test eax, eax
        jne short .13
        mov ebx, dword [leaguedbnames+14h]
        mov ecx, str_TMP
        xor edx, edx
        mov eax, tmpdbpath
        call MakePath
        lea edx, [dword esp+01D8h]
        mov eax, tmpdbpath
        call FileOpenWrite
        mov ebx, eax
.13:
        test ebx, ebx
        jne short .14
        mov ebx, dword [leaguedbnames+4]
        mov ecx, str_TMP
        xor edx, edx
        mov eax, tmpdbpath
        call MakePath
        lea edx, [dword esp+01D4h]
        mov eax, tmpdbpath
        call FileOpenWrite
        mov ebx, eax
.14:
        test ebx, ebx
        jne short .15
        mov ebx, dword [leaguedbnames+8]
        mov ecx, str_TMP
        xor edx, edx
        mov eax, tmpdbpath
        call MakePath
        lea edx, [dword esp+01E0h]
        mov eax, tmpdbpath
        call FileOpenWrite
        mov ebx, eax
.15:
        test ebx, ebx
        jne near .23
        cmp byte [dword esp+096h], 47h
        je near .18
        mov ebx, 2Fh
        xor edx, edx
        lea eax, [dword esp+0C8h]
        call memset_
        mov ebx, 28h
        xor edx, edx
        lea eax, [dword esp+0124h]
        call memset_
        mov ecx, 2Fh
        mov ebx, dword [dword esp+0C0h]
        lea edx, [dword esp+0C8h]
        mov eax, dword [dword esp+01D8h]
        call FileWriteAt
        mov ebx, eax
        test eax, eax
        jne short .17
        lea ecx, [dword esp+01A8h]
        mov esi, newskatershoots
.16:
        mov ebx, dword [dword eax+newskaterattrs_m3]
        sar ebx, 18h
        mov dl, byte [esi+eax]
        mov byte [ecx+ebx], dl
        inc eax
        cmp eax, byte 0Fh
        jl short CreateFreeAgent.16
        lea ebx, [dword esp+0124h]
        lea edx, [dword esp+01A8h]
        lea eax, [dword esp+094h]
        call RandomizeNewRatings
        mov ecx, 28h
        mov ebx, dword [dword esp+0BCh]
        lea edx, [dword esp+0124h]
        mov eax, dword [dword esp+01D4h]
        call FileWriteAt
        mov ebx, eax
.17:
        test ebx, ebx
        jne near .22
        mov ecx, 14h
        mov ebx, dword [dword esp+0B8h]
        lea edx, [dword esp+01A8h]
        jmp near .21
.18:
        mov ebx, 36h
        xor edx, edx
        lea eax, [byte esp+05Ch]
        call memset_
        mov ebx, 2Ch
        xor edx, edx
        lea eax, [dword esp+0F8h]
        call memset_
        mov ecx, 36h
        mov ebx, dword [dword esp+0C0h]
        lea edx, [byte esp+05Ch]
        mov eax, dword [dword esp+01D8h]
        call FileWriteAt
        mov ebx, eax
        test eax, eax
        jne short .20
        lea esi, [dword esp+01BCh]
        mov ecx, newgoalieglove
.19:
        mov edx, dword [dword eax+newgoalieattrs_m3]
        sar edx, 18h
        mov bl, byte [ecx+eax]
        mov byte [edx+esi], bl
        inc eax
        cmp eax, byte 0Bh
        jl short CreateFreeAgent.19
        mov ecx, 2Ch
        mov ebx, dword [dword esp+0BCh]
        lea edx, [dword esp+0F8h]
        mov eax, dword [dword esp+01D4h]
        call FileWriteAt
        mov ebx, eax
.20:
        test ebx, ebx
        jne short .22
        mov ecx, 10h
        mov ebx, dword [dword esp+0B8h]
        lea edx, [dword esp+01BCh]
.21:
        mov eax, dword [dword esp+01E0h]
        call FileWriteAt
        mov ebx, eax
.22:
        test ebx, ebx
        jne short .23
        mov ebx, dword [keydb_size]
        mov ecx, 34h
        lea edx, [dword esp+094h]
        mov eax, dword [dword esp+01DCh]
        call FileWriteAt
        mov ebx, eax
.23:
        lea eax, [dword esp+01E0h]
        call FileClose
        lea eax, [dword esp+01D4h]
        call FileClose
        lea eax, [dword esp+01D8h]
        call FileClose
        lea eax, [dword esp+01DCh]
        call FileClose
        test ebx, ebx
        jne short .24
        call LoadTempDatabases
        xor eax, eax
        call LoadRosterList
        mov eax, 1
        call LoadRosterList
.24:
        call DeleteTempDatabases
        test ebx, ebx
        je short .25
        mov dword [msglines], str_ErrorWhileMakingNew
        mov edx, str_NewPlayer
        lea eax, [byte esp+08h]
        call strcpy_
        mov edx, str_NotAddedToDatabases
        lea eax, [byte esp+08h]
        call strcat_
        mov ebx, 10h
        mov edx, edi
        xor eax, eax
        call FadePalStep
        lea eax, [byte esp+08h]
        mov dword [msglines+4], eax
        push byte 0FFFFFFFFh
        mov ecx, dword [byte esp+04h]
        push ecx
        mov esi, dword [byte esp+0Ch]
        push esi
        push byte 0
        push byte 0
        mov ecx, 2
        mov ebx, msglines
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov ebx, 10h
        mov edx, edi
        jmp short .27
.25:
        mov dword [dbdirty], 1
        jmp short .28
.26:
        mov ebx, 10h
        mov edx, esi
.27:
        mov eax, 1
        call FadePalStep
.28:
        call DrawEditRosters
        mov ebx, 10h
        mov edx, edi
        xor eax, eax
        call FadePalStep
        push edi
        call FreeMemBlock
        add esp, byte 4
.x:
        add esp, 1E4h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
