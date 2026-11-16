; The in-game line editor: jerseys, using or saving a set of lines, and whether the roster is complete.
; One module, with its own copies of the line editor strings.
bits 32
%include "hockey.inc"
section s_767D0 progbits alloc exec nowrite align=1
extern __CHK, __STOSB, str_PlusMinus7, blitclipbottom, blitclipleft, blitclipright, blitcliptop, boxfillcolor
extern boxlitecolor, boxshadecolor, TeamJerseyBase, jerseyremaptrim, jerseypalslot0, jerseypalslot1, jerseypalslot2, jerseypalslot3
extern gamelinespal, gmrosterpos, gmrosterdot, gmrosterspace, gmrostername, CareerDbPtr, CareerDbPtr2, cddriveptr
extern ClearInputQueue, cont2team, crestnames, curperiod, dlgbevelcol1, dlgbevelcol2, dlgedgecol1, dlgedgecol2
extern dlgedgecol3, dlgfillcol, dlgtextbg, dlgtextfg, DrawMenuBar, DrawMenuDropdown, DrawMenuItemNorm, DrawMenuItemSel
extern LineEdPairX, LineEdPairY, LineEdFiveX, LineEdFiveY, LineEdFourX, LineEdFourY, LineEdExtraX, LineEdExtraY
extern LineEdGoalieX, LineEdGoalieY, hmteamrec_skaters, hmteamrec_goalies, RosterFromStandings, leaguestatsmode, editptrspr, exit_
extern fadeend, fadeend2, FadeOutPalCycle, fadepal, fadepal2, FadePalStep, fadestart, fadestart2
extern fadestep, fadestep2, FatalError, fileoncd, FitPlayerName, fputchar, FreeMemBlock, fullscrbmp
extern gameopts, GetInputEvent, gmroster, gmrosterjersey, gmrosterslot, hmroster, hmrosterjersey, hmteamrec
extern HomeTeam, j___close_, j___delay_, jerseydigits, jerseyremap, KeyDbPtr, leaguedbfmt, leaguedbfmt2
extern lineedpanel, lineslotx, linesloty, lseek_, mainfont, MakePath, memcpy_, menuact_dbdress
extern menuact_dbscratch, menuact_gamedress, menuact_gamescratch, menuact_savedeflines, menuact_savedeflines2, menuact_savelines, menuact_uselines, menuact_uselines2
extern MenuHitTest, MessageBox, MouseSetPos, msglines, MusicChanReset2, musichandle, MusicOn, musicslot
extern open_, palfadedin, perror_, pointerspr, PrintCenteredText, PrintFmt1, PrintFmt2, PrintLineEdStatus
extern PrintShadowText, ptrupdatefn, qsort_, read_, rostergstat, rosterjersey, rosterlist, rosterpstat
extern rosterslot, rosterstat, rosterteam, rosterteamrec, RunMenu, SetDrawBitmap, SetTextColors, ShowLoadingScreen
extern songdata, SpeechBusy, sprintf_, statscategory, statsgoaliebuf, statsgoalieorder, statsgoalieplr, statsplayerbuf
extern statsplayoffs, statsredrawcb, statsskaterbuf, statsskaterorder, statsskaterplr, statsteambuf, str_A4, str_Attackers
extern str_Bkgd10, str_Bkgd2, str_C2dS2, str_C2dS3, str_C5, str_Defense3, str_Dress2, str_Embpal4
extern str_Embpal5, str_EmbS, str_ErrA1, str_ErrA2, str_ErrA3, str_ErrA4, str_ErrA5, str_ErrA6
extern str_ErrA7, str_ErrA8, str_ErrB2, str_ErrB2Perror, str_ErrB3, str_ErrB4, str_ErrB5, str_ErrB6
extern str_ErrB7, str_extBIN, str_Extra, str_fmt2d, str_fmt3d, str_fmt4d, str_fmtEmb, str_fmtMinSec
extern str_fmtTenths, str_Forward, str_G4, str_GA3, str_GAA4, str_GoalieW2, str_Goaltenders, str_GP8
extern str_Gstat3, str_Gstat4, str_HOMEPALS3, str_Key, str_Keys3, str_Keys4, str_Kill1, str_Kill2
extern str_L8, str_Lelogo, str_Lelogo2, str_Line1, str_Line2, str_Line3, str_Line4, str_Lineditp2
extern str_Lineditp3, str_Menubuff8, str_Menubuff9, str_Min4, str_Name2, str_No2, str_Pal25, str_Pal26
extern str_Pal27, str_Pal28, str_PCT2, str_Penalty, str_PIM4, str_Play1, str_Play2, str_Player2
extern str_Pntr3, str_Pntr4, str_Pointer13, str_Pointer14, str_Pos2, str_Power, str_Pstat3, str_Pstat4
extern str_PT2, str_RosterIncomplete2, str_S2dSS, str_S2dSS2, str_S6, str_S7, str_SA3, str_Scratch2
extern str_Shots4, str_Shrt2, str_Shrt3, str_SRoster, str_T6, str_Teams2, str_Tstat2, str_W6
extern strcmp_, stub_8C218, AllocMemBlock, PushMemDescriptorLocked, LoadBank, OpenArtArchiveErr, TextSetColors, TextSaveState
extern TextRestoreState, TextSetFont, SndQuery, SetDigiChannelVolume, SetPalette, PutBlock, DrawBitmap, FillRect
extern DrawArtOpaqueAtOwnPos, DrawArt, DrawShape, GrabBlock, PrintString, DrawArtKeyColour, DrawArtMasked, MouseRead
extern SetViewRect, FindShape, ClearScreen, SetTextMode, VgaSetPalette, SetScreenTarget, SetClipWindow, WaitRetraceEnd
extern SetColorRemap, FillRectColor, PlotPixel, TeamRosterScreen, str_dot2, str_dot3, gameplstatsmenubar, rosterstatsmenubar
extern TeamRecLines, _dos_findfirst_, vgapage, VisTeam, WaitKey, write_
global GameLineEditor, GameRosterCmp, GameLineEditorLoop, LineEdHitTest, LoadGameRoster, DrawGameLineJerseys_jt, DrawGameLineJerseys, DrawGameLineJerseys_st1
global DrawGameLineJerseys_st2, DrawGameLineJerseys_st0, DrawGameLineJerseys_join, DrawLineEditorScreen, StubRet4a, LoadJerseyColours, DrawDlgFrame, StubRet4b
global CheckGameRosterComplete, PruneGameLines, MenuUseTheseLines, MenuLineEdCancel, MenuUseOriginalLines, MenuUseOriginalLines_redraw, MenuUseOriginalLines_ret0, MenuUseOriginalLines_ret
global MenuUseDefaultLines, MenuSaveDefaultLines, MenuSaveDefaultLines_ret, MenuSaveDefaultLines_pop, MenuSaveTheseLines, MenuSaveTheseLines_x, MenuGameShowPlayerStats, MenuReturnToLineEditor
global GameScratchPlayer, GameDressPlayer, BlitJerseyDigit, MakeJerseyShape
;-----------------------------------------------------------------------------
; GameLineEditor                                                  767D0  95 PC
; Game / frontend line editor (pre-game, team screens, after trades): music
; stop, loading screen, LoadGameRoster, qsort GameRosterCmp,
;
; GameLineEditorLoop
;-----------------------------------------------------------------------------
; C: src/front/game_lines/GameLineEditor.c
%ifdef CBUILD
%include "c/front/game_lines/GameLineEditor.inc"
%else
GameLineEditor:
        push dword 68h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 48h
        mov esi, eax
        mov dword [byte esp+020h], edx
        mov dword [byte esp+044h], ebx
        mov dword [byte esp+040h], ecx
        push byte 20h
        push dword 300h
        push str_Pal27
        call AllocMemBlock
        mov edi, eax
        add esp, byte 0Ch
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, edi
        mov eax, 1
        call FadePalStep
        push edi
        call FreeMemBlock
        add esp, byte 4
        cmp byte [MusicOn], 0
        je short .2
        cmp dword [songdata], byte 0
        je short .2
        mov eax, dword [musichandle]
        mov ebx, 32h
        mov edx, 3
        call SetDigiChannelVolume
.1:
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        je short GameLineEditor.1
        mov ebx, dword [songdata]
        push ebx
        call PushMemDescriptorLocked
        add esp, byte 4
        xor ecx, ecx
        mov dword [songdata], ecx
.2:
        cmp byte [MusicOn], 0
        je short .4
        test byte [gameopts+1], 1
        je short .4
        call MusicChanReset2
.3:
        call SpeechBusy
        test eax, eax
        jne short GameLineEditor.3
.4:
        call ShowLoadingScreen
        mov eax, dword [dlgfillcol]
        mov dword [byte esp+010h], eax
        mov eax, dword [dlgedgecol1]
        mov dword [byte esp+038h], eax
        mov eax, dword [dlgedgecol2]
        mov dword [byte esp+03Ch], eax
        mov eax, dword [dlgedgecol3]
        mov dword [byte esp+028h], eax
        mov eax, dword [dlgbevelcol1]
        mov dword [byte esp+024h], eax
        mov eax, dword [dlgbevelcol2]
        mov dword [byte esp+01Ch], eax
        mov edi, 0C1h
        mov dword [dlgfillcol], edi
        mov ebp, 0C0h
        mov dword [dlgedgecol1], ebp
        mov dword [dlgedgecol2], edi
        mov edx, 0C2h
        mov dword [dlgedgecol3], edx
        mov dword [dlgbevelcol1], 0C3h
        mov dword [dlgbevelcol2], edx
        mov eax, dword [boxfillcolor]
        mov dword [byte esp+018h], eax
        mov eax, dword [boxlitecolor]
        mov dword [byte esp+014h], eax
        mov eax, dword [boxshadecolor]
        mov dword [byte esp+034h], eax
        mov eax, dword [dlgtextfg]
        mov dword [byte esp+030h], eax
        mov eax, dword [dlgtextbg]
        mov dword [byte esp+02Ch], eax
        mov dword [boxfillcolor], edi
        mov dword [boxlitecolor], ebp
        mov dword [boxshadecolor], edi
        mov dword [dlgtextfg], ebp
        mov dword [dlgtextbg], edi
        call SetScreenTarget
        push dword 1E0h
        push byte 0
        push dword 280h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        push dword 0C8h
        push dword 140h
        call MouseSetPos
        add esp, byte 8
        xor ecx, ecx
        mov ebx, str_Lineditp3
        cmp byte [fileoncd+0E8h], 1
        jne short .5
        mov edx, dword [cddriveptr]
        jmp short .6
.5:
        xor edx, edx
.6:
        mov eax, esp
        call MakePath
        push byte 0
        lea eax, [byte esp+04h]
        push eax
        call LoadBank
        mov ebp, eax
        add esp, byte 8
        push str_Shrt3
        push eax
        call FindShape
        mov edi, eax
        add esp, byte 8
        call FadeOutPalCycle
        mov ecx, dword [byte esp+040h]
        push ecx
        mov ecx, dword [byte esp+048h]
        xor ebx, ebx
        mov edx, edi
        mov eax, esi
        call DrawLineEditorScreen
        mov eax, esi
        call LoadGameRoster
        mov ecx, GameRosterCmp
        mov ebx, 16h
        mov edx, 1Ch
        mov eax, gmroster
        call qsort_
        push ebp
        mov eax, dword [byte esp+044h]
        push eax
        mov edx, dword [byte esp+04Ch]
        push edx
        xor ecx, ecx
        mov ebx, esi
        mov edx, edi
        mov eax, dword [byte esp+02Ch]
        call GameLineEditorLoop
        push ebp
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [byte esp+010h]
        mov dword [dlgfillcol], eax
        mov eax, dword [byte esp+038h]
        mov dword [dlgedgecol1], eax
        mov eax, dword [byte esp+03Ch]
        mov dword [dlgedgecol2], eax
        mov eax, dword [byte esp+028h]
        mov dword [dlgedgecol3], eax
        mov eax, dword [byte esp+024h]
        mov dword [dlgbevelcol1], eax
        mov eax, dword [byte esp+01Ch]
        mov dword [dlgbevelcol2], eax
        mov eax, dword [byte esp+018h]
        mov dword [boxfillcolor], eax
        mov eax, dword [byte esp+014h]
        mov dword [boxlitecolor], eax
        mov eax, dword [byte esp+034h]
        mov dword [boxshadecolor], eax
        mov eax, dword [byte esp+030h]
        mov dword [dlgtextfg], eax
        mov eax, dword [byte esp+02Ch]
        mov dword [dlgtextbg], eax
        add esp, byte 48h
        pop ebp
        pop edi
        pop esi
        ret
%endif ; C
;-----------------------------------------------------------------------------
; GameRosterCmp                                                   76A93  95 PC
; Qsort compare: positions L, C, R, D then G, then name (+6)
;-----------------------------------------------------------------------------
; C: src/front/game_lines/GameRosterCmp.c
%ifdef CBUILD
%include "c/front/game_lines/GameRosterCmp.inc"
%else
GameRosterCmp:
        push dword 8
        call __CHK
        push ebx
        mov bl, byte [eax]
        mov bh, byte [edx]
        cmp bl, bh
        jne short .2
        cmp byte [eax], 0
        jne short .1
        xor eax, eax
        pop ebx
        ret
.1:
        add edx, byte 6
        add eax, byte 6
        call strcmp_
        pop ebx
        ret
.2:
        test bl, bl
        je short .5
        test bh, bh
        jne short .4
.3:
        mov eax, 0FFFFFFFFh
        pop ebx
        ret
.4:
        cmp bl, 4Ch
        je short GameRosterCmp.3
        cmp bh, 4Ch
        je short .5
        cmp bl, 43h
        je short GameRosterCmp.3
        cmp bh, 43h
        je short .5
        cmp bl, 52h
        je short GameRosterCmp.3
        cmp bh, 52h
        je short .5
        cmp bl, 44h
        je short GameRosterCmp.3
.5:
        mov eax, 1
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; GameLineEditorLoop                           76AF5  95 PC, medium confidence
; Game line editor screen and input loop (copy of DbLineEditorLoop on game
; teams)
;-----------------------------------------------------------------------------
GameLineEditorLoop:
        push dword 148h
        call __CHK
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 118h
        push eax
        push edx
        sub ebp, byte 76h
        mov byte [byte ebp+072h], bl
        xor edx, edx
        mov dword [byte ebp+066h], edx
        mov ebx, 0FFFFFFFFh
        mov dword [byte ebp+022h], ebx
        mov dword [byte ebp+01Eh], ebx
        mov dword [byte ebp+04Eh], 0C0h
        mov dword [byte ebp+056h], 0C1h
        mov dword [byte ebp+052h], 0C2h
        push str_Pntr4
        mov edx, dword [dword ebp+08Eh]
        push edx
        call FindShape
        mov dword [byte ebp+03Ah], eax
        add esp, byte 8
        mov eax, dword [dword ebp+086h]
        mov dword [byte ebp+0Eh], eax
        mov eax, dword [dword ebp+08Ah]
        mov dword [byte ebp-012h], eax
        xor ebx, ebx
        mov dword [byte ebp+01Ah], ebx
        mov dword [byte ebp+016h], ebx
        mov dword [byte ebp+012h], ebx
        mov dword [byte ebp-016h], ebx
        mov dword [byte ebp-01Ah], ebx
        mov dword [byte ebp-01Eh], ebx
        mov dword [byte ebp-022h], ebx
        mov dword [byte ebp+0Ah], ebx
        mov dword [byte ebp+06h], ebx
        mov dword [byte ebp+02h], ebx
        mov dword [byte ebp-02h], ebx
        mov dword [byte ebp-06Eh], ebx
        mov dword [byte ebp-072h], ebx
        mov dword [menuact_gamescratch], ebx
        mov dword [menuact_gamedress], ebx
        mov edx, dword [byte ebp+03Ah]
        mov edx, dword [byte edx+02h]
        sar edx, 10h
        mov eax, dword [byte ebp+03Ah]
        mov eax, dword [byte eax+04h]
        sar eax, 10h
        inc eax
        inc edx
        imul eax, edx
        add eax, byte 11h
        push byte 20h
        push eax
        push str_Pointer14
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [byte ebp+05Ah], eax
        mov edi, eax
        mov esi, dword [byte ebp+03Ah]
        movsd
        movsd
        movsd
        movsd
        movsb
        mov edx, dword [byte ebp+03Ah]
        mov dx, word [byte edx+04h]
        inc edx
        mov word [byte eax+04h], dx
        mov edx, dword [byte ebp+03Ah]
        mov dx, word [byte edx+06h]
        inc edx
        mov word [byte eax+06h], dx
        mov edx, dword [byte ebp+0Eh]
        mov edx, dword [edx]
        mov eax, dword [byte ebp+0Eh]
        mov edi, dword [byte eax+08h]
        add edx, edi
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov esi, eax
        mov dword [byte ebp+032h], eax
        mov edx, dword [byte ebp+0Eh]
        mov edx, dword [byte edx+04h]
        mov eax, dword [byte ebp+0Eh]
        mov ebx, dword [byte eax+0Ch]
        add edx, ebx
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov edi, eax
        mov dword [byte ebp+02Eh], eax
        mov dword [menuact_savelines], MenuSaveTheseLines
        mov eax, MenuUseTheseLines
        mov dword [menuact_uselines], eax
        mov dword [menuact_uselines2], eax
        mov ebx, MenuSaveDefaultLines
        mov dword [menuact_savedeflines], ebx
        mov dword [menuact_savedeflines2], ebx
        xor eax, eax
        mov dword [byte ebp+036h], eax
.1:
        mov eax, dword [dword ebp-0A6h]
        add eax, dword [byte ebp+036h]
        cmp byte [eax], 64h
        jne short .2
        xor eax, eax
        mov dword [menuact_savelines], eax
        mov dword [menuact_uselines], eax
        mov dword [menuact_uselines2], eax
        mov dword [menuact_savedeflines], eax
        mov dword [menuact_savedeflines2], eax
        jmp short .3
.2:
        mov ebx, dword [byte ebp+036h]
        inc ebx
        mov dword [byte ebp+036h], ebx
        cmp ebx, byte 28h
        jl short GameLineEditorLoop.1
.3:
        xor edx, edx
        mov dword [byte ebp+036h], edx
.4:
        mov eax, dword [dword ebp-0A6h]
        mov ebx, dword [byte ebp+036h]
        add eax, ebx
        mov dh, byte [eax]
        cmp dh, 64h
        je short .5
        xor edx, edx
        mov dl, byte [eax]
        mov ebx, edx
        shl ebx, 2
        add ebx, edx
        shl ebx, 3
        sub ebx, edx
        xor edx, edx
        mov dl, byte [byte ebp+072h]
        mov eax, edx
        shl eax, 4
        add eax, edx
        shl eax, 4
        add eax, edx
        mov dl, byte [dword ebx+eax*4+hmrosterjersey]
        mov eax, dword [byte ebp+036h]
        mov byte [dword eax+ebp-0A2h], dl
        jmp short .6
.5:
        mov byte [dword ebx+ebp-0A2h], dh
.6:
        mov ecx, dword [byte ebp+036h]
        inc ecx
        mov dword [byte ebp+036h], ecx
        cmp ecx, byte 28h
        jl short GameLineEditorLoop.4
        cmp dword [curperiod], byte 0
        jge short .9
        xor ebx, ebx
        mov dword [byte ebp+036h], ebx
.7:
        mov eax, dword [dword ebp-0A6h]
        add eax, dword [byte ebp+036h]
        mov bh, byte [byte eax+028h]
        cmp bh, 64h
        je short .8
        xor edx, edx
        mov dl, bh
        mov ebx, edx
        shl ebx, 2
        add ebx, edx
        shl ebx, 3
        sub ebx, edx
        xor edx, edx
        mov dl, byte [byte ebp+072h]
        mov eax, edx
        shl eax, 4
        add eax, edx
        shl eax, 4
        add eax, edx
        shl eax, 2
        add eax, ebx
        cmp byte [dword eax+hmroster], 3
        jne short .8
        mov byte [dword eax+hmroster], 2
.8:
        mov eax, dword [byte ebp+036h]
        inc eax
        mov dword [byte ebp+036h], eax
        cmp eax, byte 8
        jl short GameLineEditorLoop.7
.9:
        push byte 20h
        push dword 300h
        push str_Pal27
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [byte ebp+046h], eax
        xor ecx, ecx
        mov ebx, str_Embpal5
        cmp byte [fileoncd+08Eh], 1
        jne short .10
        mov edx, dword [cddriveptr]
        jmp short .11
.10:
        xor edx, edx
.11:
        lea eax, [byte ebp-032h]
        call MakePath
        push byte 0
        lea eax, [byte ebp-032h]
        push eax
        call LoadBank
        mov dword [byte ebp+03Ah], eax
        add esp, byte 8
        push str_Pal28
        push eax
        call FindShape
        add esp, byte 8
        lea edx, [byte eax+010h]
        mov ebx, 300h
        mov eax, dword [byte ebp+046h]
        call memcpy_
        mov ecx, dword [byte ebp+03Ah]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        mov al, byte [byte ebp+072h]
        mov ebx, dword [byte ebp+046h]
        mov edx, dword [dword ebp+08Eh]
        call LoadJerseyColours
        cmp byte [byte ebp+072h], 0
        je short .12
        mov ax, word [VisTeam]
        jmp short .13
.12:
        mov ax, word [HomeTeam]
.13:
        cwde
        mov al, byte [nosplit eax*4+TeamJerseyBase]
        mov byte [byte ebp+06Eh], al
        xor eax, eax
        mov al, byte [byte ebp+06Eh]
        mov al, byte [dword eax+jerseyremap]
        mov byte [byte ebp+06Eh], al
        mov al, byte [jerseyremaptrim]
        mov byte [byte ebp+06Ah], al
        xor ebx, ebx
        mov bl, byte [byte ebp+072h]
        mov edx, dword [dword ebp-0AAh]
        lea eax, [dword ebp-0A2h]
        call DrawGameLineJerseys
        xor ecx, ecx
        mov ebx, str_Lelogo2
        cmp byte [fileoncd+021Bh], 1
        jne short .14
        mov edx, dword [cddriveptr]
        jmp short .15
.14:
        xor edx, edx
.15:
        lea eax, [byte ebp-032h]
        call MakePath
        push byte 0
        lea eax, [byte ebp-032h]
        push eax
        call LoadBank
        mov dword [byte ebp+03Ah], eax
        add esp, byte 8
        push str_Pal28
        push eax
        call FindShape
        add esp, byte 8
        lea edx, [dword eax+026Eh]
        mov eax, dword [byte ebp+046h]
        add eax, 25Eh
        mov ebx, 93h
        call memcpy_
        mov edx, dword [byte ebp+03Ah]
        push edx
        call FreeMemBlock
        add esp, byte 4
        mov ebx, 10h
        mov edx, dword [byte ebp+046h]
        xor eax, eax
        call FadePalStep
        mov ebx, dword [byte ebp+046h]
        push ebx
        call FreeMemBlock
        add esp, byte 4
        cmp edi, byte 20h
        jge short .16
        xor eax, eax
        jmp short .17
.16:
        lea eax, [byte edi-020h]
.17:
        push eax
        cmp esi, byte 1Ch
        jge short .18
        xor eax, eax
        jmp short .19
.18:
        lea eax, [byte esi-01Ch]
.19:
        push eax
        mov ecx, dword [byte ebp+05Ah]
        push ecx
        call GrabBlock
        add esp, byte 0Ch
        push edi
        lea eax, [byte esi-03h]
        push eax
        mov eax, dword [pointerspr]
        push eax
        call DrawArtKeyColour
        add esp, byte 0Ch
        push dword 1E0h
        push dword 280h
        push byte 0
        push byte 0
        call SetViewRect
        add esp, byte 10h
        push edi
        push esi
        call MouseSetPos
        add esp, byte 8
        lea eax, [byte ebp+036h]
        push eax
        push eax
        push eax
        call MouseRead
        add esp, byte 0Ch
        call ClearInputQueue
        jmp near .31
.20:
        sub edi, byte 20h
.21:
        push edi
        cmp esi, byte 1Ch
        jge short .22
        xor esi, esi
        jmp short .23
.22:
        sub esi, byte 1Ch
.23:
        push esi
        mov ebx, dword [byte ebp+05Ah]
        push ebx
        call PutBlock
        add esp, byte 0Ch
        mov ecx, dword [byte ebp+02Eh]
        cmp ecx, byte 20h
        jge short .24
        xor eax, eax
        jmp short .25
.24:
        lea eax, [byte ecx-020h]
.25:
        push eax
        mov esi, dword [byte ebp+032h]
        cmp esi, byte 1Ch
        jge short .26
        xor eax, eax
        jmp short .27
.26:
        lea eax, [byte esi-01Ch]
.27:
        push eax
        mov edi, dword [byte ebp+05Ah]
        push edi
        call GrabBlock
        add esp, byte 0Ch
        mov eax, dword [byte ebp+02Eh]
        mov edx, dword [byte ebp+0Eh]
        cmp eax, dword [byte edx+0Ch]
        jle near .29
        cmp dword [byte ebp+032h], 1F4h
        jge near .29
        cmp dword [byte ebp+022h], byte 0FFFFFFFFh
        je near .29
        cmp dword [byte ebp+012h], byte 0
        je short .28
        lea eax, [byte ebp+026h]
        push eax
        lea eax, [byte ebp+02Ah]
        push eax
        lea eax, [byte ebp-072h]
        push eax
        lea eax, [byte ebp-012h]
        push eax
        mov ecx, dword [byte ebp+066h]
        lea ebx, [byte ebp+0Eh]
        mov edx, dword [byte ebp+02Eh]
        mov eax, dword [byte ebp+032h]
        call MenuHitTest
        test eax, eax
        jne near .29
.28:
        mov edx, dword [byte ebp+022h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        lea edx, [eax+eax]
        xor ebx, ebx
        mov bl, byte [dword edx+gmrosterslot]
        mov ecx, ebx
        shl ecx, 2
        add ecx, ebx
        shl ecx, 3
        sub ecx, ebx
        xor ebx, ebx
        mov bl, byte [byte ebp+072h]
        mov eax, ebx
        shl eax, 4
        add eax, ebx
        shl eax, 4
        add eax, ebx
        cmp byte [dword ecx+eax*4+hmroster], 2
        je short .29
        xor ecx, ecx
        mov cl, byte [byte ebp+06Ah]
        xor ebx, ebx
        mov bl, byte [byte ebp+06Eh]
        mov dl, byte [dword edx+gmrosterjersey]
        and edx, 0FFh
        mov eax, jerseyremap
        call MakeJerseyShape
        push jerseyremap
        call SetColorRemap
        add esp, byte 4
        mov eax, dword [byte ebp+02Eh]
        sub eax, byte 20h
        push eax
        mov eax, dword [byte ebp+032h]
        sub eax, byte 1Ch
        push eax
        mov eax, dword [dword ebp-0AAh]
        push eax
        call DrawArtKeyColour
        add esp, byte 0Ch
.29:
        mov edx, dword [byte ebp+02Eh]
        push edx
        mov eax, dword [byte ebp+032h]
        sub eax, byte 3
        push eax
        mov ebx, dword [pointerspr]
        push ebx
.30:
        call DrawArtKeyColour
        add esp, byte 0Ch
        mov esi, dword [byte ebp+032h]
        mov edi, dword [byte ebp+02Eh]
.31:
        xor ecx, ecx
.32:
        call GetInputEvent
        test eax, eax
        je short .33
        lea ebx, [byte ebp+02Eh]
        lea edx, [byte ebp+032h]
        call dword [ptrupdatefn]
        mov ecx, eax
        test al, 2
        je short GameLineEditorLoop.32
.33:
        test cl, 2
        jne short .35
        cmp esi, dword [byte ebp+032h]
        jne short .34
        cmp edi, dword [byte ebp+02Eh]
        je short GameLineEditorLoop.31
.34:
        cmp edi, byte 20h
        jge near GameLineEditorLoop.20
        xor edi, edi
        jmp near GameLineEditorLoop.21
.35:
        lea eax, [byte ebp+026h]
        push eax
        lea eax, [byte ebp+02Ah]
        push eax
        lea eax, [byte ebp-072h]
        push eax
        lea eax, [byte ebp-012h]
        push eax
        mov ecx, dword [byte ebp+066h]
        lea ebx, [byte ebp+0Eh]
        mov edx, dword [byte ebp+02Eh]
        mov eax, dword [byte ebp+032h]
        call MenuHitTest
        lea edx, [byte edi-020h]
        test eax, eax
        je near .63
        mov ebx, dword [byte ebp+02Ah]
        shl ebx, 2
        mov eax, dword [byte ebp+026h]
        shl eax, 5
        mov dword [byte ebp+04Ah], eax
        mov eax, dword [byte ebx+ebp+0Eh]
        add eax, dword [byte ebp+04Ah]
        cmp dword [byte eax+014h], byte 0
        je near .47
        mov eax, dword [byte ebp+026h]
        cmp eax, dword [byte ebx+ebp-02h]
        jne near .42
        cmp edi, byte 20h
        jge short .36
        xor edx, edx
.36:
        push edx
        cmp esi, byte 1Ch
        jge short .37
        xor esi, esi
        jmp short .38
.37:
        sub esi, byte 1Ch
.38:
        push esi
        mov esi, dword [byte ebp+05Ah]
        push esi
        call PutBlock
        add esp, byte 0Ch
        mov dword [byte ebp+036h], 3
        jmp short .41
.39:
        mov eax, ebx
        shl eax, 2
        mov esi, dword [byte eax+ebp-022h]
        test esi, esi
        je short .40
        mov edi, dword [byte ebp+ebx*8-06Eh]
        push edi
        mov ebx, dword [byte ebp+ebx*8-072h]
        push ebx
        push esi
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [byte ebp+036h]
        xor esi, esi
        mov dword [byte ebp+eax*8-06Eh], esi
        mov dword [byte ebp+eax*8-072h], esi
        mov edi, dword [byte ebp+eax*4-022h]
        push edi
        call FreeMemBlock
        add esp, byte 4
.40:
        dec dword [byte ebp+036h]
.41:
        mov ebx, dword [byte ebp+036h]
        test ebx, ebx
        jge short GameLineEditorLoop.39
        xor ecx, ecx
        mov dword [byte ebp+066h], ecx
        mov eax, dword [byte ebp+02Ah]
        mov esi, dword [byte ebp+026h]
        shl esi, 5
        mov eax, dword [byte ebp+eax*4+0Eh]
        add esi, eax
        lea eax, [byte ebp+02Eh]
        push eax
        lea eax, [byte ebp+032h]
        push eax
        mov edi, dword [dword ebp+08Ah]
        push edi
        mov eax, dword [dword ebp+086h]
        push eax
        push ecx
        mov edx, dword [dword ebp-0AAh]
        push edx
        xor ebx, ebx
        mov bl, byte [byte ebp+072h]
        lea ecx, [byte ebp+022h]
        mov edx, dword [dword ebp-0A6h]
        lea eax, [dword ebp-0A2h]
        call dword [byte esi+014h]
        xor ebx, ebx
        mov dword [byte ebp+01Ah], ebx
        mov dword [byte ebp+016h], ebx
        mov dword [byte ebp+012h], ebx
        mov dword [byte ebp-01Ah], ebx
        mov dword [byte ebp-01Eh], ebx
        mov dword [byte ebp-022h], ebx
        mov dword [byte ebp+0Ah], ebx
        mov dword [byte ebp+06h], ebx
        mov dword [byte ebp+02h], ebx
        mov dword [byte ebp-06h], ebx
        mov dword [byte ebp-0Ah], ebx
        mov dword [byte ebp-0Eh], ebx
        cmp eax, byte 1
        je near .111
        call ClearInputQueue
        jmp near .104
.42:
        cmp edi, byte 20h
        jge short .43
        xor edx, edx
.43:
        push edx
        cmp esi, byte 1Ch
        jge short .44
        xor esi, esi
        jmp short .45
.44:
        sub esi, byte 1Ch
.45:
        push esi
        mov esi, dword [byte ebp+05Ah]
        push esi
        call PutBlock
        add esp, byte 0Ch
        mov edi, dword [byte ebp+052h]
        push edi
        mov eax, dword [byte ebp+056h]
        push eax
        mov eax, dword [byte ebp+02Ah]
        mov ebx, dword [byte ebp+eax*8-06Eh]
        mov edx, dword [byte ebp+eax*8-072h]
        mov ecx, dword [byte ebp+eax*4-02h]
        shl ecx, 5
        mov eax, dword [byte ebp+eax*4+0Eh]
        add eax, ecx
        mov ecx, dword [byte ebp+04Eh]
        call DrawMenuItemSel
        mov edx, dword [byte ebp+02Ah]
        mov eax, dword [byte ebp+026h]
        mov dword [byte ebp+edx*4-02h], eax
        push edi
        mov ecx, dword [byte ebp+056h]
        push ecx
        mov ebx, dword [byte ebp+edx*8-06Eh]
        mov esi, dword [byte ebp+edx*8-072h]
        mov ecx, eax
        shl ecx, 5
        mov eax, dword [byte ebp+edx*4+0Eh]
        add eax, ecx
        mov ecx, dword [byte ebp+04Eh]
        mov edx, esi
.46:
        call DrawMenuItemNorm
        jmp near .104
.47:
        cmp dword [byte eax+018h], byte 0
        je near .59
        cmp edi, byte 20h
        jge short .48
        xor edx, edx
.48:
        push edx
        cmp esi, byte 1Ch
        jge short .49
        xor esi, esi
        jmp short .50
.49:
        sub esi, byte 1Ch
.50:
        push esi
        mov ecx, dword [byte ebp+05Ah]
        push ecx
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [byte ebp+066h]
        cmp eax, dword [byte ebp+02Ah]
        je short .54
        mov dword [byte ebp+036h], eax
        jmp short .53
.51:
        shl eax, 2
        xor edi, edi
        mov dword [byte eax+ebp-02h], edi
        cmp dword [byte eax+ebp-022h], byte 0
        je short .52
        mov edx, dword [byte ebp+036h]
        mov ebx, dword [byte ebp+edx*8-06Eh]
        push ebx
        mov ecx, dword [byte ebp+edx*8-072h]
        push ecx
        mov esi, dword [byte eax+ebp-022h]
        push esi
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [byte ebp+036h]
        mov dword [byte ebp+eax*8-06Eh], edi
        mov dword [byte ebp+eax*8-072h], edi
        mov edx, dword [byte ebp+eax*4-022h]
        push edx
        call FreeMemBlock
        add esp, byte 4
        mov eax, dword [byte ebp+036h]
        mov dword [byte ebp+eax*4-022h], edi
        mov dword [byte ebp+eax*4+0Eh], edi
        mov dword [byte ebp+eax*4-012h], edi
.52:
        dec dword [byte ebp+036h]
.53:
        mov eax, dword [byte ebp+036h]
        mov esi, dword [byte ebp+02Ah]
        cmp eax, esi
        jg short GameLineEditorLoop.51
        mov dword [byte ebp+066h], esi
.54:
        mov eax, dword [byte ebp+052h]
        push eax
        mov edx, dword [byte ebp+056h]
        push edx
        mov edi, dword [byte ebp+066h]
        mov ebx, dword [byte ebp+edi*8-06Eh]
        mov edx, dword [byte ebp+edi*8-072h]
        mov eax, dword [byte ebp+edi*4-02h]
        shl eax, 5
        mov ecx, dword [byte ebp+edi*4+0Eh]
        add eax, ecx
        mov ecx, dword [byte ebp+04Eh]
        call DrawMenuItemSel
        mov eax, dword [byte ebp+026h]
        mov dword [byte ebp+edi*4-02h], eax
        mov eax, dword [byte ebp+052h]
        push eax
        mov edx, dword [byte ebp+056h]
        push edx
        mov ebx, dword [byte ebp+edi*8-06Eh]
        mov edx, dword [byte ebp+edi*8-072h]
        mov ecx, dword [byte ebp+026h]
        shl ecx, 5
        mov eax, dword [byte ebp+edi*4+0Eh]
        add eax, ecx
        mov ecx, dword [byte ebp+04Eh]
        call DrawMenuItemNorm
        mov eax, dword [byte ebp+02Ah]
        mov ecx, dword [byte ebp+026h]
        shl ecx, 5
        mov ebx, dword [byte ebp+eax*4+0Eh]
        lea esi, [byte edi+01h]
        mov dword [byte ebp+066h], esi
        mov ebx, dword [byte ecx+ebx+018h]
        mov dword [byte ebp+esi*4+0Eh], ebx
        mov eax, dword [byte ebp+eax*4+0Eh]
        add eax, ecx
        mov ebx, dword [byte eax+01Ch]
        mov dword [byte ebp+esi*4-012h], ebx
        cmp esi, byte 1
        je short .55
        mov edx, dword [byte eax+08h]
        jmp short .56
.55:
        mov edx, dword [eax]
.56:
        mov eax, dword [byte ebp+066h]
        mov ebx, dword [byte ebp+eax*8-07Ah]
        add edx, ebx
        mov dword [byte ebp+eax*8-072h], edx
        mov edx, dword [byte ebp+026h]
        shl edx, 5
        mov eax, dword [byte ebp+02Ah]
        shl eax, 2
        cmp dword [byte ebp+066h], byte 1
        je short .57
        mov eax, dword [byte eax+ebp+0Eh]
        mov eax, dword [byte edx+eax+04h]
        jmp short .58
.57:
        mov eax, dword [byte eax+ebp+0Eh]
        mov eax, dword [byte edx+eax+0Ch]
.58:
        mov edx, dword [byte ebp+066h]
        shl edx, 3
        mov dword [byte ebp+05Eh], edx
        mov esi, dword [byte edx+ebp-076h]
        add eax, esi
        mov dword [byte edx+ebp-06Eh], eax
        mov eax, dword [byte ebp+066h]
        shl eax, 2
        mov dword [byte ebp+062h], eax
        mov edx, dword [byte eax+ebp-012h]
        shl edx, 5
        mov eax, dword [byte eax+ebp+0Eh]
        mov ebx, dword [byte edx+eax-018h]
        sub ebx, dword [eax]
        inc ebx
        mov dword [byte ebp+042h], ebx
        mov edx, dword [byte edx+eax-014h]
        sub edx, dword [byte eax+04h]
        inc edx
        mov dword [byte ebp+03Eh], edx
        push byte 20h
        mov eax, dword [byte ebp+042h]
        imul eax, edx
        add eax, byte 11h
        push eax
        push str_Menubuff9
        call AllocMemBlock
        add esp, byte 0Ch
        mov edx, dword [byte ebp+062h]
        mov dword [byte edx+ebp-022h], eax
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov eax, dword [byte edx+ebp-022h]
        mov edx, dword [byte ebp+042h]
        mov word [byte eax+04h], dx
        mov eax, dword [byte ebp+062h]
        mov eax, dword [byte eax+ebp-022h]
        mov edx, dword [byte ebp+03Eh]
        mov word [byte eax+06h], dx
        mov eax, dword [byte ebp+05Eh]
        mov esi, dword [byte eax+ebp-06Eh]
        push esi
        mov edi, dword [byte eax+ebp-072h]
        push edi
        mov eax, dword [byte ebp+062h]
        mov edx, dword [byte eax+ebp-022h]
        push edx
        call GrabBlock
        add esp, byte 0Ch
        mov ebx, dword [byte ebp+052h]
        push ebx
        mov ecx, dword [byte ebp+056h]
        push ecx
        mov esi, dword [byte ebp+04Eh]
        push esi
        mov ecx, dword [byte ebp+05Eh]
        mov ecx, dword [byte ecx+ebp-06Eh]
        mov ebx, dword [byte ebp+05Eh]
        mov ebx, dword [byte ebx+ebp-072h]
        mov edx, dword [byte ebp+062h]
        mov edx, dword [byte edx+ebp-012h]
        mov eax, dword [byte ebp+062h]
        mov eax, dword [byte eax+ebp+0Eh]
        call DrawMenuDropdown
        mov eax, dword [byte ebp+062h]
        xor edi, edi
        mov dword [byte eax+ebp-02h], edi
        mov eax, dword [byte ebp+052h]
        push eax
        mov edx, dword [byte ebp+056h]
        push edx
        mov ebx, dword [byte ebp+05Eh]
        mov ebx, dword [byte ebx+ebp-06Eh]
        mov edx, dword [byte ebp+05Eh]
        mov edx, dword [byte edx+ebp-072h]
        mov eax, dword [byte ebp+062h]
        mov eax, dword [byte eax+ebp+0Eh]
        mov ecx, esi
        jmp near GameLineEditorLoop.46
.59:
        cmp edi, byte 20h
        jge short .60
        xor edx, edx
.60:
        push edx
        cmp esi, byte 1Ch
        jge short .61
        xor esi, esi
        jmp short .62
.61:
        sub esi, byte 1Ch
.62:
        push esi
        mov ecx, dword [byte ebp+05Ah]
        push ecx
        call PutBlock
        add esp, byte 0Ch
        mov esi, dword [byte ebp+052h]
        push esi
        mov edi, dword [byte ebp+056h]
        push edi
        mov eax, dword [byte ebp+02Ah]
        mov ebx, dword [byte ebp+eax*8-06Eh]
        mov edx, dword [byte ebp+eax*8-072h]
        mov ecx, dword [byte ebp+eax*4-02h]
        shl ecx, 5
        mov eax, dword [byte ebp+eax*4+0Eh]
        add eax, ecx
        mov ecx, dword [byte ebp+04Eh]
        call DrawMenuItemSel
        mov edx, dword [byte ebp+02Ah]
        mov eax, dword [byte ebp+026h]
        mov dword [byte ebp+edx*4-02h], eax
        push esi
        push edi
        mov ebx, dword [byte ebp+edx*8-06Eh]
        mov eax, dword [byte ebp+edx*8-072h]
        mov ecx, dword [byte ebp+edx*4-02h]
        shl ecx, 5
        mov esi, dword [byte ebp+edx*4+0Eh]
        add esi, ecx
        mov ecx, dword [byte ebp+04Eh]
        mov edx, eax
        mov eax, esi
        jmp near GameLineEditorLoop.46
.63:
        cmp edi, byte 20h
        jge short .64
        xor edx, edx
.64:
        push edx
        cmp esi, byte 1Ch
        jge short .65
        xor esi, esi
        jmp short .66
.65:
        sub esi, byte 1Ch
.66:
        push esi
        mov edx, dword [byte ebp+05Ah]
        push edx
        call PutBlock
        add esp, byte 0Ch
        mov dword [byte ebp+036h], 3
        jmp short .69
.67:
        mov eax, ecx
        shl eax, 2
        mov edx, dword [byte eax+ebp-022h]
        test edx, edx
        je short .68
        mov ebx, dword [byte ebp+ecx*8-06Eh]
        push ebx
        mov ecx, dword [byte ebp+ecx*8-072h]
        push ecx
        push edx
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [byte ebp+036h]
        xor edi, edi
        mov dword [byte ebp+eax*8-06Eh], edi
        mov dword [byte ebp+eax*8-072h], edi
        mov edx, dword [byte ebp+eax*4-022h]
        push edx
        call FreeMemBlock
        add esp, byte 4
.68:
        dec dword [byte ebp+036h]
.69:
        mov ecx, dword [byte ebp+036h]
        test ecx, ecx
        jge short GameLineEditorLoop.67
        xor esi, esi
        mov dword [byte ebp+066h], esi
        mov dword [byte ebp+01Ah], esi
        mov dword [byte ebp+016h], esi
        mov dword [byte ebp+012h], esi
        mov dword [byte ebp-01Ah], esi
        mov dword [byte ebp-01Eh], esi
        mov dword [byte ebp-022h], esi
        mov dword [byte ebp+0Ah], esi
        mov dword [byte ebp+06h], esi
        mov dword [byte ebp+02h], esi
        mov dword [byte ebp-06h], esi
        mov dword [byte ebp-0Ah], esi
        mov dword [byte ebp-0Eh], esi
        lea ebx, [byte ebp+01Eh]
        mov edx, dword [byte ebp+02Eh]
        mov eax, dword [byte ebp+032h]
        call LineEdHitTest
        test eax, eax
        je near .104
        cmp dword [byte ebp+01Eh], byte 64h
        jge near .97
        mov eax, dword [byte ebp+022h]
        cmp eax, byte 0FFFFFFFFh
        je near .97
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        xor edx, edx
        mov dl, byte [nosplit eax*2+gmrosterslot]
        mov ebx, edx
        shl ebx, 2
        add ebx, edx
        shl ebx, 3
        sub ebx, edx
        xor edx, edx
        mov dl, byte [byte ebp+072h]
        mov eax, edx
        shl eax, 4
        add eax, edx
        shl eax, 4
        add eax, edx
        cmp byte [dword ebx+eax*4+hmroster], 2
        je near .97
        push dword 0C1h
        push dword 0C0h
        call TextSetColors
        add esp, byte 8
        mov edx, dword [byte ebp+022h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        mov edx, dword [byte ebp+01Eh]
        cmp edx, byte 0Ch
        jge near .74
        mov ch, byte [dword eax+gmroster]
        cmp ch, 43h
        je short .70
        cmp ch, 4Ch
        je short .70
        cmp ch, 52h
        jne near .94
.70:
        mov ebx, 3
        mov eax, dword [byte ebp+01Eh]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        mov dword [byte ebp+036h], eax
        xor esi, esi
.71:
        mov edx, dword [byte ebp+036h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        lea edx, [eax+esi]
        mov ebx, dword [byte ebp+022h]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 2
        sub eax, ebx
        mov bl, byte [dword edx+ebp-0A2h]
        cmp bl, byte [nosplit eax*2+gmrosterjersey]
        jne short .72
        mov byte [dword edx+ebp-0A2h], 64h
.72:
        inc esi
        cmp esi, byte 3
        jl short GameLineEditorLoop.71
        mov ebx, 3
        mov eax, dword [byte ebp+01Eh]
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        mov esi, edx
        mov edx, dword [byte ebp+022h]
        mov ebx, edx
        shl ebx, 2
        sub ebx, edx
        shl ebx, 2
        sub ebx, edx
        add ebx, ebx
        mov edx, dword [byte ebp+036h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add esi, eax
        mov al, byte [dword ebx+gmrosterjersey]
        mov byte [dword esi+ebp-0A2h], al
        xor esi, esi
.73:
        xor ecx, ecx
        mov cl, byte [byte ebp+06Ah]
        xor ebx, ebx
        mov bl, byte [byte ebp+06Eh]
        mov edx, dword [byte ebp+036h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, esi
        xor edx, edx
        mov dl, byte [dword eax+ebp-0A2h]
        mov eax, jerseyremap
        call MakeJerseyShape
        push jerseyremap
        call SetColorRemap
        add esp, byte 4
        mov edx, dword [byte ebp+036h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        add eax, esi
        mov edi, dword [nosplit eax*8+linesloty]
        push edi
        mov edx, dword [nosplit eax*8+lineslotx]
        push edx
        mov ebx, dword [dword ebp-0AAh]
        push ebx
        call DrawArtMasked
        add esp, byte 0Ch
        inc esi
        cmp esi, byte 3
        jl short GameLineEditorLoop.73
        jmp near .94
.74:
        cmp edx, byte 12h
        jge near .78
        cmp byte [dword eax+gmroster], 44h
        jne near .94
        sub edx, byte 0Ch
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov dword [byte ebp+036h], eax
        mov cl, 64h
.75:
        mov edx, dword [byte ebp+036h]
        add edx, edx
        add edx, esi
        mov ebx, dword [byte ebp+022h]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 2
        sub eax, ebx
        mov bl, byte [dword edx+ebp-096h]
        cmp bl, byte [nosplit eax*2+gmrosterjersey]
        jne short .76
        mov byte [dword edx+ebp-096h], cl
.76:
        inc esi
        cmp esi, byte 2
        jl short GameLineEditorLoop.75
        mov edx, dword [byte ebp+01Eh]
        sub edx, byte 0Ch
        mov ebx, 2
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov esi, edx
        mov edx, dword [byte ebp+022h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, dword [byte ebp+036h]
        add edx, edx
        add esi, edx
        mov al, byte [nosplit eax*2+gmrosterjersey]
        mov byte [dword esi+ebp-096h], al
        xor esi, esi
.77:
        xor ecx, ecx
        mov cl, byte [byte ebp+06Ah]
        xor ebx, ebx
        mov bl, byte [byte ebp+06Eh]
        mov eax, dword [byte ebp+036h]
        add eax, eax
        add eax, esi
        xor edx, edx
        mov dl, byte [dword eax+ebp-096h]
        mov eax, jerseyremap
        call MakeJerseyShape
        push jerseyremap
        call SetColorRemap
        add esp, byte 4
        mov eax, dword [byte ebp+036h]
        add eax, eax
        add eax, esi
        mov edx, dword [nosplit eax*8+LineEdPairY]
        push edx
        mov ebx, dword [nosplit eax*8+LineEdPairX]
        push ebx
        mov ecx, dword [dword ebp-0AAh]
        push ecx
        call DrawArtMasked
        add esp, byte 0Ch
        inc esi
        cmp esi, byte 2
        jl short GameLineEditorLoop.77
        jmp near .94
.78:
        cmp edx, byte 1Ch
        jge near .82
        cmp byte [dword eax+gmroster], 47h
        je near .94
        sub edx, byte 12h
        mov ebx, 5
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov dword [byte ebp+036h], eax
.79:
        mov edx, dword [byte ebp+036h]
        mov eax, edx
        shl eax, 2
        add eax, edx
        lea edx, [eax+esi]
        mov ebx, dword [byte ebp+022h]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 2
        sub eax, ebx
        mov bl, byte [dword edx+ebp-090h]
        cmp bl, byte [nosplit eax*2+gmrosterjersey]
        jne short .80
        mov byte [dword edx+ebp-090h], 64h
.80:
        inc esi
        cmp esi, byte 5
        jl short GameLineEditorLoop.79
        mov edx, dword [byte ebp+01Eh]
        sub edx, byte 12h
        mov ebx, 5
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov esi, edx
        mov edx, dword [byte ebp+022h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        lea edx, [eax+eax]
        mov ebx, dword [byte ebp+036h]
        mov eax, ebx
        shl eax, 2
        add eax, ebx
        add esi, eax
        mov al, byte [dword edx+gmrosterjersey]
        mov byte [dword esi+ebp-090h], al
        xor esi, esi
.81:
        xor ecx, ecx
        mov cl, byte [byte ebp+06Ah]
        xor ebx, ebx
        mov bl, byte [byte ebp+06Eh]
        mov edx, dword [byte ebp+036h]
        mov eax, edx
        shl eax, 2
        add eax, edx
        add eax, esi
        xor edx, edx
        mov dl, byte [dword eax+ebp-090h]
        mov eax, jerseyremap
        call MakeJerseyShape
        push jerseyremap
        call SetColorRemap
        add esp, byte 4
        mov edx, dword [byte ebp+036h]
        mov eax, edx
        shl eax, 2
        add eax, edx
        add eax, esi
        mov ecx, dword [nosplit eax*8+LineEdFiveY]
        push ecx
        mov edi, dword [nosplit eax*8+LineEdFiveX]
        push edi
        mov eax, dword [dword ebp-0AAh]
        push eax
        call DrawArtMasked
        add esp, byte 0Ch
        inc esi
        cmp esi, byte 5
        jl short GameLineEditorLoop.81
        jmp near .94
.82:
        cmp edx, byte 24h
        jge near .86
        cmp byte [dword eax+gmroster], 47h
        je near .94
        sub edx, byte 1Ch
        mov eax, edx
        sar edx, 1Fh
        shl edx, 2
        LD sbb, eax, edx
        sar eax, 2
        mov dword [byte ebp+036h], eax
        mov cl, 64h
.83:
        mov edx, dword [byte ebp+036h]
        shl edx, 2
        add edx, esi
        mov ebx, dword [byte ebp+022h]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 2
        sub eax, ebx
        mov bl, byte [dword edx+ebp-086h]
        cmp bl, byte [nosplit eax*2+gmrosterjersey]
        jne short .84
        mov byte [dword edx+ebp-086h], cl
.84:
        inc esi
        cmp esi, byte 4
        jl short GameLineEditorLoop.83
        mov edx, dword [byte ebp+01Eh]
        sub edx, byte 1Ch
        mov ebx, 4
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov esi, edx
        mov edx, dword [byte ebp+022h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        mov edx, dword [byte ebp+036h]
        shl edx, 2
        add esi, edx
        mov al, byte [nosplit eax*2+gmrosterjersey]
        mov byte [dword esi+ebp-086h], al
        xor esi, esi
.85:
        xor ecx, ecx
        mov cl, byte [byte ebp+06Ah]
        xor ebx, ebx
        mov bl, byte [byte ebp+06Eh]
        mov eax, dword [byte ebp+036h]
        shl eax, 2
        add eax, esi
        xor edx, edx
        mov dl, byte [dword eax+ebp-086h]
        mov eax, jerseyremap
        call MakeJerseyShape
        push jerseyremap
        call SetColorRemap
        add esp, byte 4
        mov eax, dword [byte ebp+036h]
        shl eax, 2
        add eax, esi
        mov edi, dword [nosplit eax*8+LineEdFourY]
        push edi
        mov edx, dword [nosplit eax*8+LineEdFourX]
        push edx
        mov ebx, dword [dword ebp-0AAh]
        push ebx
        call DrawArtMasked
        add esp, byte 0Ch
        inc esi
        cmp esi, byte 4
        jl short GameLineEditorLoop.85
        jmp near .94
.86:
        cmp edx, byte 26h
        jge near .90
        cmp byte [dword eax+gmroster], 47h
        jne near .94
        mov ch, 64h
.87:
        mov edx, dword [byte ebp+022h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        mov dl, byte [byte esi+ebp-07Eh]
        cmp dl, byte [nosplit eax*2+gmrosterjersey]
        jne short .88
        mov byte [byte esi+ebp-07Eh], ch
.88:
        inc esi
        cmp esi, byte 2
        jl short GameLineEditorLoop.87
        mov esi, dword [byte ebp+01Eh]
        sub esi, byte 24h
        mov edx, dword [byte ebp+022h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        mov al, byte [nosplit eax*2+gmrosterjersey]
        mov byte [byte esi+ebp-07Eh], al
        xor esi, esi
.89:
        xor ecx, ecx
        mov cl, byte [byte ebp+06Ah]
        xor ebx, ebx
        mov bl, byte [byte ebp+06Eh]
        xor edx, edx
        mov dl, byte [byte esi+ebp-07Eh]
        mov eax, jerseyremap
        call MakeJerseyShape
        push jerseyremap
        call SetColorRemap
        add esp, byte 4
        mov edx, dword [nosplit esi*8+LineEdExtraY]
        push edx
        mov ebx, dword [nosplit esi*8+LineEdExtraX]
        push ebx
        mov ecx, dword [dword ebp-0AAh]
        push ecx
        call DrawArtMasked
        add esp, byte 0Ch
        inc esi
        cmp esi, byte 2
        jl short GameLineEditorLoop.89
        jmp near .94
.90:
        cmp byte [dword eax+gmroster], 47h
        je near .94
        mov bh, 64h
.91:
        mov edx, dword [byte ebp+022h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        mov dl, byte [byte esi+ebp-07Ch]
        cmp dl, byte [nosplit eax*2+gmrosterjersey]
        jne short .92
        mov byte [byte esi+ebp-07Ch], bh
.92:
        inc esi
        cmp esi, byte 2
        jl short GameLineEditorLoop.91
        mov esi, dword [byte ebp+01Eh]
        sub esi, byte 26h
        mov edx, dword [byte ebp+022h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        mov al, byte [nosplit eax*2+gmrosterjersey]
        mov byte [byte esi+ebp-07Ch], al
        xor esi, esi
.93:
        xor ecx, ecx
        mov cl, byte [byte ebp+06Ah]
        xor ebx, ebx
        mov bl, byte [byte ebp+06Eh]
        xor edx, edx
        mov dl, byte [byte esi+ebp-07Ch]
        mov eax, jerseyremap
        call MakeJerseyShape
        push jerseyremap
        call SetColorRemap
        add esp, byte 4
        mov ecx, dword [nosplit esi*8+LineEdGoalieY]
        push ecx
        mov edi, dword [nosplit esi*8+LineEdGoalieX]
        push edi
        mov eax, dword [dword ebp-0AAh]
        push eax
        call DrawArtMasked
        add esp, byte 0Ch
        inc esi
        cmp esi, byte 2
        jl short GameLineEditorLoop.93
.94:
        mov dword [menuact_savelines], MenuSaveTheseLines
        mov esi, MenuUseTheseLines
        mov dword [menuact_uselines], esi
        mov dword [menuact_uselines2], esi
        mov eax, MenuSaveDefaultLines
        mov dword [menuact_savedeflines], eax
        mov dword [menuact_savedeflines2], eax
        xor ebx, ebx
        mov dword [byte ebp+036h], ebx
.95:
        mov eax, dword [byte ebp+036h]
        cmp byte [dword eax+ebp-0A2h], 64h
        jne short .96
        xor edi, edi
        mov dword [menuact_savelines], edi
        mov dword [menuact_uselines], edi
        mov dword [menuact_uselines2], edi
        mov dword [menuact_savedeflines], edi
        mov dword [menuact_savedeflines2], edi
        jmp near .104
.96:
        lea ecx, [byte eax+01h]
        mov dword [byte ebp+036h], ecx
        cmp ecx, byte 28h
        jl short GameLineEditorLoop.95
        jmp near .104
.97:
        mov edx, dword [byte ebp+01Eh]
        cmp edx, byte 64h
        jl near .104
        lea ebx, [byte edx-064h]
        mov dword [byte ebp+01Eh], ebx
        mov edx, ebx
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 2
        sub eax, ebx
        xor edx, ebx
        mov dl, byte [nosplit eax*2+gmrosterslot]
        mov ebx, edx
        shl ebx, 2
        add ebx, edx
        shl ebx, 3
        sub ebx, edx
        xor edx, edx
        mov dl, byte [byte ebp+072h]
        mov eax, edx
        shl eax, 4
        add eax, edx
        shl eax, 4
        add eax, edx
        shl eax, 2
        add eax, ebx
        mov ch, byte [dword eax+hmroster]
        test ch, ch
        je near .104
        cmp ch, 4
        je short .98
        cmp ch, 3
        je short .98
        cmp ch, 2
        jne near .104
        cmp dword [curperiod], byte 0
        jge near .104
.98:
        mov esi, dword [byte ebp+022h]
        cmp esi, byte 0FFFFFFFFh
        je near .101
        mov edx, esi
        mov eax, esi
        shl eax, 2
        sub eax, esi
        shl eax, 2
        sub eax, esi
        xor edx, esi
        mov dl, byte [nosplit eax*2+gmrosterslot]
        mov ebx, edx
        shl ebx, 2
        add ebx, edx
        shl ebx, 3
        sub ebx, edx
        xor edx, edx
        mov dl, byte [byte ebp+072h]
        mov eax, edx
        shl eax, 4
        add eax, edx
        shl eax, 4
        add eax, edx
        cmp byte [dword ebx+eax*4+hmroster], 2
        jne short .99
        push dword 0C1h
        push dword 0FCh
        jmp short .100
.99:
        push dword 0C1h
        push dword 0C3h
.100:
        call TextSetColors
        add esp, byte 8
        mov edx, dword [byte ebp+022h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        mov edx, gmroster
        add edx, eax
        add edx, byte 3
        push edx
        xor edx, edx
        mov dl, byte [dword eax+gmrosterjersey]
        push edx
        mov al, byte [dword eax+gmroster]
        and eax, 0FFh
        push eax
        push str_C2dS3
        lea eax, [byte ebp-052h]
        push eax
        call sprintf_
        add esp, byte 14h
        mov edx, dword [byte ebp+022h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        lea edx, [byte eax+016h]
        lea ebx, [byte ebp-052h]
        mov eax, 1FAh
        call PrintLineEdStatus
.101:
        mov eax, dword [byte ebp+01Eh]
        mov dword [byte ebp+022h], eax
        mov dword [menuact_gamedress], GameDressPlayer
        mov dword [menuact_gamescratch], GameScratchPlayer
        mov edx, dword [byte ebp+01Eh]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        xor edx, edx
        mov dl, byte [nosplit eax*2+gmrosterslot]
        mov ebx, edx
        shl ebx, 2
        add ebx, edx
        shl ebx, 3
        sub ebx, edx
        xor edx, edx
        mov dl, byte [byte ebp+072h]
        mov eax, edx
        shl eax, 4
        add eax, edx
        shl eax, 4
        add eax, edx
        cmp byte [dword ebx+eax*4+hmroster], 2
        jne short .102
        push dword 0C1h
        push dword 0FDh
        jmp short .103
.102:
        push dword 0C1h
        push dword 0C0h
.103:
        call TextSetColors
        add esp, byte 8
        mov edx, dword [byte ebp+022h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        mov edx, gmroster
        add edx, eax
        add edx, byte 3
        push edx
        xor edx, edx
        mov dl, byte [dword eax+gmrosterjersey]
        push edx
        mov al, byte [dword eax+gmroster]
        and eax, 0FFh
        push eax
        push str_C2dS3
        lea eax, [byte ebp-052h]
        push eax
        call sprintf_
        add esp, byte 14h
        mov edx, dword [byte ebp+022h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        lea edx, [byte eax+016h]
        lea ebx, [byte ebp-052h]
        mov eax, 1FAh
        call PrintLineEdStatus
.104:
        mov edx, dword [byte ebp+02Eh]
        cmp edx, byte 20h
        jge short .105
        xor eax, eax
        jmp short .106
.105:
        lea eax, [byte edx-020h]
.106:
        push eax
        mov ebx, dword [byte ebp+032h]
        cmp ebx, byte 1Ch
        jge short .107
        xor eax, eax
        jmp short .108
.107:
        lea eax, [byte ebx-01Ch]
.108:
        push eax
        mov ecx, dword [byte ebp+05Ah]
        push ecx
        call GrabBlock
        add esp, byte 0Ch
        mov eax, dword [byte ebp+02Eh]
        mov edx, dword [byte ebp+0Eh]
        cmp eax, dword [byte edx+0Ch]
        jle near .110
        mov edi, dword [byte ebp+032h]
        cmp edi, 1F4h
        jge near .110
        cmp dword [byte ebp+022h], byte 0FFFFFFFFh
        je near .110
        cmp dword [byte ebp+012h], byte 0
        je short .109
        lea eax, [byte ebp+026h]
        push eax
        lea eax, [byte ebp+02Ah]
        push eax
        lea eax, [byte ebp-072h]
        push eax
        lea eax, [byte ebp-012h]
        push eax
        mov ecx, dword [byte ebp+066h]
        lea ebx, [byte ebp+0Eh]
        mov edx, dword [byte ebp+02Eh]
        mov eax, edi
        call MenuHitTest
        test eax, eax
        jne near .110
.109:
        mov edx, dword [byte ebp+022h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        lea edx, [eax+eax]
        xor ebx, ebx
        mov bl, byte [dword edx+gmrosterslot]
        mov ecx, ebx
        shl ecx, 2
        add ecx, ebx
        shl ecx, 3
        sub ecx, ebx
        xor ebx, ebx
        mov bl, byte [byte ebp+072h]
        mov eax, ebx
        shl eax, 4
        add eax, ebx
        shl eax, 4
        add eax, ebx
        cmp byte [dword ecx+eax*4+hmroster], 2
        je short .110
        xor ecx, ecx
        mov cl, byte [byte ebp+06Ah]
        xor ebx, ebx
        mov bl, byte [byte ebp+06Eh]
        mov dl, byte [dword edx+gmrosterjersey]
        and edx, 0FFh
        mov eax, jerseyremap
        call MakeJerseyShape
        push jerseyremap
        call SetColorRemap
        add esp, byte 4
        mov eax, dword [byte ebp+02Eh]
        sub eax, byte 20h
        push eax
        mov eax, dword [byte ebp+032h]
        sub eax, byte 1Ch
        push eax
        mov ebx, dword [dword ebp-0AAh]
        push ebx
        call DrawArtKeyColour
        add esp, byte 0Ch
.110:
        mov ecx, dword [byte ebp+02Eh]
        push ecx
        mov eax, dword [byte ebp+032h]
        sub eax, byte 3
        push eax
        mov esi, dword [pointerspr]
        push esi
        jmp near GameLineEditorLoop.30
.111:
        call ClearInputQueue
        mov edi, dword [byte ebp+05Ah]
        push edi
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        lea esp, [byte ebp+076h]
        pop ebp
        pop edi
        pop esi
        ret 0Ch
;-----------------------------------------------------------------------------
; LineEdHitTest                                                   77F6F  95 PC
; (x, y, out): line slot (40 rects 3Ah x 28h) or roster list row (100 + (y -
; 16h) / 0Dh)
;-----------------------------------------------------------------------------
; C: src/front/game_lines/LineEdHitTest.c
%ifdef CBUILD
%include "c/front/game_lines/LineEdHitTest.inc"
%else
LineEdHitTest:
        push dword 14h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        mov ecx, eax
        mov esi, edx
        mov edi, ebx
        lea ecx, [byte eax+04h]
        cmp ecx, 1F4h
        jge short .4
        xor edx, edx
.1:
        mov eax, edx
        shl eax, 3
        mov ebx, dword [dword eax+lineslotx]
        cmp ecx, ebx
        jl short .3
        add ebx, byte 3Ah
        cmp ecx, ebx
        jge short .3
        mov ebp, dword [dword eax+linesloty]
        cmp esi, ebp
        jl short .3
        lea eax, [byte ebp+028h]
        cmp esi, eax
        jge short .3
        mov dword [edi], edx
.2:
        mov eax, 1
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
.3:
        inc edx
        cmp edx, byte 28h
        jl short LineEdHitTest.1
        jmp short .5
.4:
        cmp edx, byte 16h
        jl short .5
        cmp edx, 182h
        jge short .5
        sub edx, byte 16h
        mov ebx, 0Dh
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        add eax, byte 64h
        mov dword [edi], eax
        jmp short LineEdHitTest.2
.5:
        xor eax, eax
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; LoadGameRoster                                                  77FF5  95 PC
; (team): reads the team's players from the league "key" file into the roster
; entries (FatalError A1..A8 on file errors)
;-----------------------------------------------------------------------------
LoadGameRoster:
        push dword 0ACh
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, 84h
        mov edi, eax
        xor edx, edx
        mov dword [dword esp+080h], edx
.1:
        mov edx, dword [dword esp+080h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        mov dl, byte [dword esp+080h]
        mov byte [nosplit eax*2+gmrosterslot], dl
        mov ebx, dword [dword esp+080h]
        inc ebx
        mov dword [dword esp+080h], ebx
        cmp ebx, byte 1Ch
        jl short LoadGameRoster.1
        push str_Key
        push leaguedbfmt
        lea eax, [byte esp+068h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        lea ebx, [byte esp+034h]
        xor edx, edx
        lea eax, [byte esp+060h]
        call _dos_findfirst_
        test eax, eax
        je short .2
        push str_ErrA1
        call FatalError
        add esp, byte 4
.2:
        push dword 200h
        lea eax, [byte esp+064h]
        push eax
        call open_
        add esp, byte 8
        mov esi, eax
        test eax, eax
        jge short .3
        push str_ErrA2
        call FatalError
        add esp, byte 4
.3:
        xor ebp, ebp
        mov dword [dword esp+080h], ebp
.4:
        mov eax, edi
        shl eax, 2
        sub eax, edi
        shl eax, 3
        mov edx, eax
        shl eax, 5
        sub eax, edx
        mov edx, eax
        mov eax, dword [dword esp+080h]
        cmp dword [dword edx+eax*4+hmteamrec_skaters], byte 0
        jge short .5
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        xor bh, bh
        mov byte [nosplit eax*2+gmroster], bh
        jmp near .11
.5:
        xor ebx, ebx
        xor edx, edx
        mov eax, esi
        call lseek_
        test eax, eax
        je short .6
        push str_ErrA3
        call FatalError
        add esp, byte 4
.6:
        mov eax, edi
        shl eax, 2
        sub eax, edi
        shl eax, 3
        mov edx, eax
        shl eax, 5
        sub eax, edx
        mov edx, dword [dword esp+080h]
        mov edx, dword [dword eax+edx*4+hmteamrec_skaters]
        xor ebx, ebx
        mov eax, esi
        call lseek_
        test eax, eax
        jge short .7
        push str_ErrA4
        call FatalError
        add esp, byte 4
.7:
        mov ebx, 34h
        mov edx, esp
        mov eax, esi
        call read_
        test eax, eax
        jl short .8
        cmp eax, byte 34h
        je short .9
.8:
        push str_ErrA5
        call FatalError
        add esp, byte 4
.9:
        mov edx, dword [dword esp+080h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        lea edx, [eax+eax]
        mov al, byte [byte esp+02h]
        mov byte [dword edx+gmroster], al
        mov al, byte [byte esp+01h]
        mov byte [dword edx+gmrosterjersey], al
        mov al, byte [byte esp+03h]
        mov byte [dword edx+gmrosterpos], al
        mov byte [dword edx+gmrosterdot], 2Eh
        mov byte [dword edx+gmrosterspace], 20h
        xor eax, eax
.10:
        mov ebx, dword [dword esp+080h]
        mov edx, ebx
        shl edx, 2
        sub edx, ebx
        shl edx, 2
        sub edx, ebx
        mov bl, byte [byte esp+eax+013h]
        mov byte [dword eax+edx*2+gmrostername], bl
        inc eax
        cmp eax, byte 10h
        jl short LoadGameRoster.10
.11:
        mov ecx, dword [dword esp+080h]
        inc ecx
        mov dword [dword esp+080h], ecx
        cmp ecx, byte 19h
        jl near LoadGameRoster.4
        xor eax, eax
        mov dword [dword esp+080h], eax
.12:
        mov eax, edi
        shl eax, 2
        sub eax, edi
        shl eax, 3
        mov edx, eax
        shl eax, 5
        sub eax, edx
        mov edx, eax
        mov eax, dword [dword esp+080h]
        cmp dword [dword edx+eax*4+hmteamrec_goalies], byte 0
        jge short .13
        lea edx, [byte eax+019h]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        xor dl, dl
        mov byte [nosplit eax*2+gmroster], dl
        jmp near .19
.13:
        xor ebx, ebx
        xor edx, edx
        mov eax, esi
        call lseek_
        test eax, eax
        je short .14
        push str_ErrA6
        call FatalError
        add esp, byte 4
.14:
        mov eax, edi
        shl eax, 2
        sub eax, edi
        shl eax, 3
        mov edx, eax
        shl eax, 5
        sub eax, edx
        mov edx, dword [dword esp+080h]
        mov edx, dword [dword eax+edx*4+hmteamrec_goalies]
        xor ebx, ebx
        mov eax, esi
        call lseek_
        test eax, eax
        jge short .15
        push str_ErrA7
        call FatalError
        add esp, byte 4
.15:
        mov ebx, 34h
        mov edx, esp
        mov eax, esi
        call read_
        test eax, eax
        jl short .16
        cmp eax, byte 34h
        je short .17
.16:
        push str_ErrA8
        call FatalError
        add esp, byte 4
.17:
        mov edx, dword [dword esp+080h]
        add edx, byte 19h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        lea edx, [eax+eax]
        mov al, byte [byte esp+02h]
        mov byte [dword edx+gmroster], al
        mov al, byte [byte esp+01h]
        mov byte [dword edx+gmrosterjersey], al
        mov al, byte [byte esp+03h]
        mov byte [dword edx+gmrosterpos], al
        mov byte [dword edx+gmrosterdot], 2Eh
        mov byte [dword edx+gmrosterspace], 20h
        xor eax, eax
.18:
        mov ebx, dword [dword esp+080h]
        add ebx, byte 19h
        mov edx, ebx
        shl edx, 2
        sub edx, ebx
        shl edx, 2
        sub edx, ebx
        mov bl, byte [byte esp+eax+013h]
        mov byte [dword eax+edx*2+gmrostername], bl
        inc eax
        cmp eax, byte 10h
        jl short LoadGameRoster.18
.19:
        mov ecx, dword [dword esp+080h]
        inc ecx
        mov dword [dword esp+080h], ecx
        cmp ecx, byte 3
        jl near LoadGameRoster.12
        mov eax, esi
        call j___close_
        add esp, 84h
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
        db 08Bh,0C0h
DrawGameLineJerseys_jt:                         ; used by DrawGameLineJerseys
        dd DrawGameLineJerseys_st0
        dd DrawGameLineJerseys_st1
        dd DrawGameLineJerseys_st2
        dd DrawGameLineJerseys_st2
        dd DrawGameLineJerseys_st0
        dd DrawGameLineJerseys_st0
        dd DrawGameLineJerseys_join
        dd DrawGameLineJerseys_st0
;-----------------------------------------------------------------------------
; DrawGameLineJerseys                                             78366  95 PC
; Game line editor version of DrawLineJerseys (40 slots, team colours) plus
; the selected player's "%c %2d %s" status
;-----------------------------------------------------------------------------
; C: src/front/game_lines/DrawGameLineJerseys.c
%ifdef CBUILD
%include "c/front/game_lines/DrawGameLineJerseys.inc"
%else
DrawGameLineJerseys:
        push dword 58h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 2Ch
        push eax
        mov ebp, edx
        mov byte [byte esp+024h], bl
        test bl, bl
        je short .1
        mov ax, word [VisTeam]
        jmp short .2
.1:
        mov ax, word [HomeTeam]
.2:
        cwde
        mov al, byte [nosplit eax*4+TeamJerseyBase]
        mov byte [byte esp+02Ch], al
        xor eax, eax
        mov al, byte [byte esp+02Ch]
        mov al, byte [dword eax+jerseyremap]
        mov byte [byte esp+02Ch], al
        mov al, byte [jerseyremaptrim]
        mov byte [byte esp+028h], al
        xor esi, esi
.3:
        xor ecx, ecx
        mov cl, byte [byte esp+028h]
        xor ebx, ebx
        mov bl, byte [byte esp+02Ch]
        mov eax, dword [esp]
        xor edx, edx
        mov dl, byte [esi+eax]
        mov eax, jerseyremap
        call MakeJerseyShape
        push jerseyremap
        call SetColorRemap
        add esp, byte 4
        mov edx, dword [nosplit esi*8+linesloty]
        push edx
        mov ebx, dword [nosplit esi*8+lineslotx]
        push ebx
        push ebp
        call DrawArtMasked
        add esp, byte 0Ch
        inc esi
        cmp esi, byte 28h
        jl short DrawGameLineJerseys.3
        xor esi, esi
.4:
        mov edx, esi
        mov eax, esi
        shl eax, 2
        sub eax, esi
        shl eax, 2
        sub eax, esi
        xor edx, esi
        mov dl, byte [nosplit eax*2+gmrosterslot]
        mov ebx, edx
        shl ebx, 2
        add ebx, edx
        shl ebx, 3
        sub ebx, edx
        xor edx, edx
        mov dl, byte [byte esp+024h]
        mov eax, edx
        shl eax, 4
        add eax, edx
        shl eax, 4
        add eax, edx
        shl eax, 2
        add eax, ebx
        mov dl, byte [dword eax+hmroster]
        test dl, dl
        je near DrawGameLineJerseys_join.x
        mov al, dl
        dec al
        cmp al, 7
        ja short DrawGameLineJerseys_join
        and eax, 0FFh
        jmp dword [nosplit cs:eax*4+DrawGameLineJerseys_jt]
DrawGameLineJerseys_st1:
        cmp dword [curperiod], byte 0
        jge short .1
        mov edi, 0FCh
        jmp short DrawGameLineJerseys_join
.1:
        mov edi, 0C2h
        jmp short DrawGameLineJerseys_join
DrawGameLineJerseys_st2:
        mov edi, 0C3h
        jmp short DrawGameLineJerseys_join
DrawGameLineJerseys_st0:
        mov edi, 0C2h
DrawGameLineJerseys_join:
        push dword 0C1h
        push edi
        call TextSetColors
        add esp, byte 8
        mov eax, esi
        shl eax, 2
        sub eax, esi
        shl eax, 2
        sub eax, esi
        add eax, eax
        mov edx, gmroster
        add edx, eax
        add edx, byte 3
        push edx
        xor edx, edx
        mov dl, byte [dword eax+gmrosterjersey]
        push edx
        mov al, byte [dword eax+gmroster]
        and eax, 0FFh
        push eax
        push str_C2dS3
        lea eax, [byte esp+014h]
        push eax
        call sprintf_
        add esp, byte 14h
        mov eax, esi
        shl eax, 2
        sub eax, esi
        shl eax, 2
        add eax, esi
        lea edx, [byte eax+016h]
        lea ebx, [byte esp+04h]
        mov eax, 1FAh
        call PrintLineEdStatus
        inc esi
        cmp esi, byte 1Ch
        jl near DrawGameLineJerseys.4
.x:
        add esp, byte 30h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawLineEditorScreen                                            78500  95 PC
; Line editor background (bkgd, emb<team> crest, HOMEPALS colours, lelogo),
; menu bar and the line headings (forward line 1..4, power play 1 / 2,
;
; penalty kill 1 / 2, defense, goaltenders, extra attackers)
;-----------------------------------------------------------------------------
; C: src/front/game_lines/DrawLineEditorScreen.c
%ifdef CBUILD
%include "c/front/game_lines/DrawLineEditorScreen.inc"
%else
DrawLineEditorScreen:
        push dword 178h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, 15Ch
        mov edi, eax
        mov ebp, ecx
        mov dword [dword esp+0154h], 0C0h
        mov dword [dword esp+0150h], 0C1h
        mov dword [dword esp+0158h], 0C2h
        shl eax, 2
        sub eax, edi
        shl eax, 3
        mov edx, eax
        shl eax, 5
        sub eax, edx
        add eax, hmteamrec
        push eax
        push str_EmbS
        lea eax, [dword esp+0148h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        xor ecx, ecx
        lea ebx, [dword esp+0140h]
        cmp byte [fileoncd+070h], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
        lea eax, [dword esp+0100h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0104h]
        push eax
        call LoadBank
        add esp, byte 8
        mov esi, eax
        xor eax, eax
.3:
        mov byte [esp+eax], al
        inc eax
        cmp eax, 100h
        jl short DrawLineEditorScreen.3
        mov ecx, str_extBIN
        mov ebx, str_HOMEPALS3
        cmp byte [fileoncd+0A1h], 1
        jne short .4
        mov edx, dword [cddriveptr]
        jmp short .5
.4:
        xor edx, edx
.5:
        lea eax, [dword esp+0100h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0104h]
        push eax
        call OpenArtArchiveErr
        add esp, byte 8
        mov ecx, eax
        test edi, edi
        je short .6
        mov ax, word [VisTeam]
        jmp short .7
.6:
        mov ax, word [HomeTeam]
.7:
        movsx edx, ax
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 6
        lea ebx, [dword ecx+0C0h]
        add ebx, eax
        mov eax, 80h
.8:
        mov dl, byte [ebx+eax]
        mov byte [esp+eax], dl
        inc eax
        cmp eax, 100h
        jl short DrawLineEditorScreen.8
        push ecx
        call FreeMemBlock
        add esp, byte 4
        mov eax, esp
        push eax
        call SetColorRemap
        add esp, byte 4
        push byte 0
        push byte 0FFFFFFB4h
        push str_Bkgd10
        push esi
        call FindShape
        add esp, byte 8
        push eax
        call DrawArtKeyColour
        add esp, byte 0Ch
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov esi, dword [dword esp+0158h]
        push esi
        mov ecx, dword [dword esp+0154h]
        mov ebx, dword [dword esp+0158h]
        mov edx, dword [dword esp+0170h]
        mov eax, ebp
        call DrawMenuBar
        push dword 0C1h
        push dword 0C0h
        call TextSetColors
        add esp, byte 8
        push byte 1
        mov ecx, 1DFh
        mov ebx, 27Fh
        mov edx, 13h
        mov eax, 1F4h
        call DrawDlgFrame
        xor ecx, ecx
        mov ebx, str_Lelogo2
        cmp byte [fileoncd+021Bh], 1
        jne short .9
        mov edx, dword [cddriveptr]
        jmp short .10
.9:
        xor edx, edx
.10:
        lea eax, [dword esp+0100h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0104h]
        push eax
        call LoadBank
        add esp, byte 8
        mov esi, eax
        test edi, edi
        je short .11
        mov ax, word [VisTeam]
        jmp short .12
.11:
        mov ax, word [HomeTeam]
.12:
        cwde
        mov edi, dword [nosplit eax*4+crestnames]
        push edi
        push esi
        call FindShape
        add esp, byte 8
        push dword 191h
        push dword 218h
        push eax
        call DrawArt
        add esp, byte 0Ch
        push esi
        call FreeMemBlock
        add esp, byte 4
        push byte 1
        mov ecx, 54h
        mov ebx, 45h
        mov edx, 2Ch
        mov eax, 5
        call DrawDlgFrame
        push byte 33h
        push byte 0Ch
        push str_Forward
        call PrintString
        add esp, byte 0Ch
        push byte 40h
        push byte 13h
        push str_Line1
        call PrintString
        add esp, byte 0Ch
        push byte 1
        mov ecx, 85h
        mov ebx, 45h
        mov edx, 5Dh
        mov eax, 5
        call DrawDlgFrame
        push byte 64h
        push byte 0Ch
        push str_Forward
        call PrintString
        add esp, byte 0Ch
        push byte 71h
        push byte 13h
        push str_Line2
        call PrintString
        add esp, byte 0Ch
        push byte 1
        mov ecx, 0B6h
        mov ebx, 45h
        mov edx, 8Eh
        mov eax, 5
        call DrawDlgFrame
        push dword 95h
        push byte 0Ch
        push str_Forward
        call PrintString
        add esp, byte 0Ch
        push dword 0A2h
        push byte 13h
        push str_Line3
        call PrintString
        add esp, byte 0Ch
        push byte 1
        mov ecx, 0E7h
        mov ebx, 45h
        mov edx, 0BFh
        mov eax, 5
        call DrawDlgFrame
        push dword 0C6h
        push byte 0Ch
        push str_Forward
        call PrintString
        add esp, byte 0Ch
        push dword 0D3h
        push byte 13h
        push str_Line4
        call PrintString
        add esp, byte 0Ch
        push byte 1
        mov ecx, 122h
        mov ebx, 45h
        mov edx, 0FAh
        mov eax, 5
        call DrawDlgFrame
        push dword 101h
        push byte 10h
        push str_Power
        call PrintString
        add esp, byte 0Ch
        push dword 10Eh
        push byte 11h
        push str_Play1
        call PrintString
        add esp, byte 0Ch
        push byte 1
        mov ecx, 153h
        mov ebx, 45h
        mov edx, 12Bh
        mov eax, 5
        call DrawDlgFrame
        push dword 132h
        push byte 10h
        push str_Power
        call PrintString
        add esp, byte 0Ch
        push dword 13Fh
        push byte 11h
        push str_Play2
        call PrintString
        add esp, byte 0Ch
        push byte 1
        mov ecx, 18Eh
        mov ebx, 45h
        mov edx, 166h
        mov eax, 5
        call DrawDlgFrame
        push dword 16Dh
        push byte 0Ch
        push str_Penalty
        call PrintString
        add esp, byte 0Ch
        push dword 17Ah
        push byte 13h
        push str_Kill1
        call PrintString
        add esp, byte 0Ch
        push byte 1
        mov ecx, 1BFh
        mov ebx, 45h
        mov edx, 197h
        mov eax, 5
        call DrawDlgFrame
        push dword 19Eh
        push byte 0Ch
        push str_Penalty
        call PrintString
        add esp, byte 0Ch
        push dword 1ABh
        push byte 13h
        push str_Kill2
        call PrintString
        add esp, byte 0Ch
        push byte 1
        mov ecx, 54h
        mov ebx, 154h
        mov edx, 2Ch
        mov eax, 114h
        call DrawDlgFrame
        push byte 33h
        push dword 11Bh
        push str_Defense3
        call PrintString
        add esp, byte 0Ch
        push byte 40h
        push dword 120h
        push str_Line1
        call PrintString
        add esp, byte 0Ch
        push byte 1
        mov ecx, 85h
        mov ebx, 154h
        mov edx, 5Dh
        mov eax, 114h
        call DrawDlgFrame
        push byte 64h
        push dword 11Bh
        push str_Defense3
        call PrintString
        add esp, byte 0Ch
        push byte 71h
        push dword 120h
        push str_Line2
        call PrintString
        add esp, byte 0Ch
        push byte 1
        mov ecx, 0B6h
        mov ebx, 154h
        mov edx, 8Eh
        mov eax, 114h
        call DrawDlgFrame
        push dword 95h
        push dword 11Bh
        push str_Defense3
        call PrintString
        add esp, byte 0Ch
        push dword 0A2h
        push dword 120h
        push str_Line3
        call PrintString
        add esp, byte 0Ch
        push byte 1
        mov ecx, 0F0h
        mov ebx, 1E4h
        mov edx, 0C8h
        mov eax, 186h
        call DrawDlgFrame
        push dword 0D5h
        push dword 18Fh
        push str_Goaltenders
        call PrintString
        add esp, byte 0Ch
        push byte 1
        mov ecx, 18Eh
        mov ebx, 1C7h
        mov edx, 166h
        mov eax, 173h
        call DrawDlgFrame
        push dword 16Dh
        push dword 189h
        push str_Extra
        call PrintString
        add esp, byte 0Ch
        push dword 17Ah
        push dword 17Dh
        push str_Attackers
        call PrintString
        add esp, byte 0Ch
        add esp, 15Ch
;-----------------------------------------------------------------------------
; StubRet4a                                                       78A81  95 PC
; Empty function (ret 4)
;-----------------------------------------------------------------------------
StubRet4a:
        pop ebp
        pop edi
        pop esi
        ret 4
%endif ; C
;-----------------------------------------------------------------------------
; LoadJerseyColours                                               78A87  95 PC
; (team): HOMEPALS.BIN record of the team -> jersey colour remap jerseyremap
; / jerseypalslot0..D1336
;-----------------------------------------------------------------------------
; C: src/front/game_lines/LoadJerseyColours.c
%ifdef CBUILD
%include "c/front/game_lines/LoadJerseyColours.inc"
%else
LoadJerseyColours:
        push dword 2Ch
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        mov edi, eax
        mov esi, ebx
        mov ecx, str_extBIN
        mov ebx, str_HOMEPALS3
        cmp byte [fileoncd+0A1h], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
        mov eax, esp
        call MakePath
        push byte 0
        lea eax, [byte esp+04h]
        push eax
        call OpenArtArchiveErr
        add esp, byte 8
        mov ebp, eax
        test edi, edi
        je short .3
        mov ax, word [VisTeam]
        jmp short .4
.3:
        mov ax, word [HomeTeam]
.4:
        movsx edx, ax
        mov eax, edx
        shl eax, 3
        sub eax, edx
        shl eax, 6
        lea ebx, [eax+ebp]
        xor eax, eax
.5:
        mov cl, byte [ebx+eax]
        mov byte [dword esi+eax+0CCh], cl
        inc eax
        cmp eax, 0B4h
        jl short LoadJerseyColours.5
        mov eax, 0B4h
.6:
        mov dl, byte [ebx+eax]
        mov byte [dword esi+eax+0198h], dl
        inc eax
        cmp eax, 0C0h
        jl short LoadJerseyColours.6
        mov byte [dword esi+0264h], 18h
        mov byte [dword esi+0265h], 0
        mov byte [dword esi+0266h], 0
        mov byte [dword esi+0267h], 2Ah
        mov byte [dword esi+0268h], 0
        mov byte [dword esi+0269h], 0
        mov byte [dword esi+026Ah], 3Bh
        mov byte [dword esi+026Bh], 12h
        mov byte [dword esi+026Ch], 0
        mov byte [dword esi+026Dh], 3Bh
        mov byte [dword esi+026Eh], 3Bh
        mov byte [dword esi+026Fh], 3Bh
        mov eax, 80h
        add ebx, 0C0h
.7:
        lea edx, [ebx+eax]
        mov cl, byte [edx]
        cmp cl, 80h
        jge short .8
        movsx esi, cl
        cmp esi, 0BBh
        jg short .9
.8:
        mov dl, byte [ebx+eax]
        sub dl, 3Ch
        jmp short .10
.9:
        mov dl, cl
        add dl, 8
.10:
        mov byte [dword eax+jerseyremap], dl
        inc eax
        cmp eax, 0FFh
        jl short LoadJerseyColours.7
        mov byte [jerseypalslot0], 0FBh
        mov byte [jerseypalslot1], 0FCh
        mov byte [jerseypalslot2], 0FDh
        mov byte [jerseypalslot3], 0FEh
        push ebp
        call FreeMemBlock
        add esp, byte 4
        push jerseyremap
        call SetColorRemap
        add esp, byte 4
        add esp, byte 10h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; DrawDlgFrame                                 78BE7  95 PC, medium confidence
; Dialog box fill and bevel lines in the dialog colours (D0B16..D0B2A); used
; by InputDialog, create_player and the line editors
;-----------------------------------------------------------------------------
; C: src/front/game_lines/DrawLineEditorScreen.c (DrawDlgFrame)
%ifdef CBUILD
%include "c/front/game_lines/DrawLineEditorScreen.DrawDlgFrame.inc"
%else
DrawDlgFrame:
        push dword 38h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 14h
        mov esi, eax
        mov edi, edx
        mov ebp, ebx
        mov dword [byte esp+010h], ecx
        mov edx, dword [dlgfillcol]
        push edx
        mov eax, ecx
        sub eax, edi
        inc eax
        push eax
        mov eax, ebx
        sub eax, esi
        inc eax
        push eax
        push edi
        push esi
        call FillRect
        add esp, byte 14h
        mov ebx, dword [dlgedgecol1]
        push ebx
        push edi
        lea eax, [byte ebp-01h]
        push eax
        push edi
        push esi
        call FillRectColor
        add esp, byte 14h
        mov ecx, dword [dlgedgecol1]
        push ecx
        mov eax, dword [byte esp+014h]
        dec eax
        push eax
        push esi
        push edi
        push esi
        call FillRectColor
        add esp, byte 14h
        mov eax, dword [dlgedgecol2]
        push eax
        mov edx, dword [byte esp+014h]
        push edx
        push ebp
        lea eax, [byte edi+01h]
        push eax
        push ebp
        call FillRectColor
        add esp, byte 14h
        mov ebx, dword [dlgedgecol2]
        push ebx
        mov ecx, dword [byte esp+014h]
        push ecx
        push ebp
        push ecx
        lea eax, [byte esi+01h]
        push eax
        call FillRectColor
        add esp, byte 14h
        mov edx, dword [dlgedgecol3]
        push edx
        mov ebx, dword [byte esp+014h]
        push ebx
        push esi
        call PlotPixel
        add esp, byte 0Ch
        mov ecx, dword [dlgedgecol3]
        push ecx
        push edi
        push ebp
        call PlotPixel
        add esp, byte 0Ch
        cmp dword [byte esp+024h], byte 0
        je near .1
        mov edx, dword [dlgbevelcol2]
        push edx
        mov eax, edi
        add eax, byte 2
        mov dword [byte esp+04h], eax
        push eax
        mov eax, esi
        add eax, byte 2
        mov dword [byte esp+0Ch], eax
        push eax
        call PlotPixel
        add esp, byte 0Ch
        mov eax, dword [dlgbevelcol2]
        push eax
        add edi, byte 3
        mov dword [byte esp+0Ch], edi
        push edi
        lea edi, [byte esi+03h]
        push edi
        call PlotPixel
        add esp, byte 0Ch
        mov ebx, dword [dlgbevelcol1]
        push ebx
        mov ecx, dword [byte esp+04h]
        push ecx
        push edi
        call PlotPixel
        add esp, byte 0Ch
        mov esi, dword [dlgbevelcol1]
        push esi
        mov eax, dword [byte esp+0Ch]
        push eax
        mov edx, dword [byte esp+0Ch]
        push edx
        call PlotPixel
        add esp, byte 0Ch
        mov ebx, dword [dlgbevelcol1]
        push ebx
        mov esi, dword [byte esp+014h]
        sub esi, byte 2
        push esi
        mov ecx, dword [byte esp+0Ch]
        push ecx
        call PlotPixel
        add esp, byte 0Ch
        mov eax, dword [dlgbevelcol1]
        push eax
        mov eax, dword [byte esp+014h]
        sub eax, byte 3
        mov dword [byte esp+010h], eax
        push eax
        push edi
        call PlotPixel
        add esp, byte 0Ch
        mov ebx, dword [dlgbevelcol2]
        push ebx
        push esi
        push edi
        call PlotPixel
        add esp, byte 0Ch
        mov ecx, dword [dlgbevelcol2]
        push ecx
        mov edi, dword [byte esp+010h]
        push edi
        mov eax, dword [byte esp+0Ch]
        push eax
        call PlotPixel
        add esp, byte 0Ch
        mov edx, dword [dlgbevelcol2]
        push edx
        mov ebx, dword [byte esp+04h]
        push ebx
        lea edi, [byte ebp-03h]
        push edi
        call PlotPixel
        add esp, byte 0Ch
        mov ecx, dword [dlgbevelcol2]
        push ecx
        mov eax, dword [byte esp+0Ch]
        push eax
        sub ebp, byte 2
        push ebp
        call PlotPixel
        add esp, byte 0Ch
        mov edx, dword [dlgbevelcol1]
        push edx
        mov ebx, dword [byte esp+04h]
        push ebx
        push ebp
        call PlotPixel
        add esp, byte 0Ch
        mov ecx, dword [dlgbevelcol1]
        push ecx
        mov eax, dword [byte esp+0Ch]
        push eax
        push edi
        call PlotPixel
        add esp, byte 0Ch
        mov edx, dword [dlgbevelcol1]
        push edx
        push esi
        push edi
        call PlotPixel
        add esp, byte 0Ch
        mov ebx, dword [dlgbevelcol1]
        push ebx
        mov ecx, dword [byte esp+010h]
        push ecx
        push ebp
        call PlotPixel
        add esp, byte 0Ch
        mov eax, dword [dlgbevelcol2]
        push eax
        push esi
        push ebp
        call PlotPixel
        add esp, byte 0Ch
        mov edx, dword [dlgbevelcol2]
        push edx
        mov ebx, dword [byte esp+010h]
        push ebx
        push edi
        call PlotPixel
        add esp, byte 0Ch
.1:
        add esp, byte 14h
        jmp near StubRet4a
%endif ; C
;-----------------------------------------------------------------------------
; StubRet4b                                                       78E29  95 PC
; Empty function (ret 4)
;-----------------------------------------------------------------------------
; C: src/front/game_lines/StubRet4b.c
%ifdef CBUILD
%include "c/front/game_lines/StubRet4b.inc"
%else
StubRet4b:
        push dword 10h
        call __CHK
        ret 4
%endif ; C
;-----------------------------------------------------------------------------
; CheckGameRosterComplete                                         78E36  95 PC
; Game line editor: 18 dressed skaters and 2 goalies, else "Your roster is
; incomplete." with counts
;-----------------------------------------------------------------------------
; C: src/front/game_lines/CheckGameRosterComplete.c
%ifdef CBUILD
%include "c/front/game_lines/CheckGameRosterComplete.inc"
%else
CheckGameRosterComplete:
        push dword 0C0h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, 94h
        mov byte [dword esp+090h], al
        mov dword [dword esp+080h], edx
        mov dword [dword esp+084h], ebx
        xor edx, edx
        mov dword [dword esp+08Ch], edx
        xor ebp, ebp
        lea edi, [byte esp+060h]
        mov esi, str_Scratch2
        movsd
        movsd
        lea edi, [byte esp+078h]
        mov esi, str_Dress2
        movsd
        movsw
        lea edi, [byte esp+070h]
        mov esi, str_Player2
        movsd
        movsw
        movsb
        lea edi, [byte esp+068h]
        mov esi, str_GoalieW2
        movsd
        movsw
        movsb
        mov dword [dword esp+088h], str_S2dSS2
        mov ecx, 6
        lea edi, [byte esp+038h]
        mov esi, str_RosterIncomplete2
        rep movsd
        movsw
        movsb
        lea eax, [byte esp+038h]
        mov dword [byte esp+054h], eax
        mov edi, 1
        cmp dword [curperiod], byte 0
        jge near .19
        xor ebx, ebx
.1:
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 2
        sub eax, ebx
        lea edx, [eax+eax]
        xor ecx, ecx
        mov cl, byte [dword edx+gmrosterslot]
        mov esi, ecx
        shl esi, 2
        add esi, ecx
        shl esi, 3
        sub esi, ecx
        xor ecx, ecx
        mov cl, byte [dword esp+090h]
        mov eax, ecx
        shl eax, 4
        add eax, ecx
        shl eax, 4
        add eax, ecx
        cmp byte [dword esi+eax*4+hmroster], 3
        jne short .3
        cmp byte [dword edx+gmroster], 47h
        je short .2
        inc dword [dword esp+08Ch]
        jmp short .3
.2:
        inc ebp
.3:
        inc ebx
        cmp ebx, byte 1Ch
        jl short CheckGameRosterComplete.1
        cmp dword [dword esp+08Ch], byte 12h
        jne short .4
        cmp ebp, byte 2
        je near .19
.4:
        mov edx, dword [dword esp+08Ch]
        cmp edx, byte 12h
        jge short .7
        mov eax, 12h
        sub eax, edx
        cmp eax, byte 1
        jne short .5
        mov eax, str_dot3
        jmp short .6
.5:
        mov eax, str_S7
.6:
        push eax
        lea eax, [byte esp+074h]
        push eax
        mov eax, 12h
        sub eax, dword [dword esp+094h]
        push eax
        lea eax, [dword esp+084h]
        push eax
        mov ebx, dword [dword esp+098h]
        push ebx
        jmp short .10
.7:
        jle short .11
        lea eax, [byte edx-012h]
        cmp eax, byte 1
        jne short .8
        mov eax, str_dot3
        jmp short .9
.8:
        mov eax, str_S7
.9:
        push eax
        lea eax, [byte esp+074h]
        push eax
        mov eax, dword [dword esp+094h]
        sub eax, byte 12h
        push eax
        lea eax, [byte esp+06Ch]
        push eax
        mov ecx, dword [dword esp+098h]
        push ecx
.10:
        lea eax, [byte esp+030h]
        push eax
        call sprintf_
        add esp, byte 18h
        lea edx, [byte esp+01Ch]
        mov dword [byte esp+edi*4+054h], edx
        inc edi
.11:
        cmp ebp, byte 2
        jge short .14
        mov eax, 2
        sub eax, ebp
        cmp eax, byte 1
        jne short .12
        mov eax, str_dot3
        jmp short .13
.12:
        mov eax, str_S7
.13:
        push eax
        lea eax, [byte esp+06Ch]
        push eax
        mov eax, 2
        sub eax, ebp
        push eax
        lea eax, [dword esp+084h]
        push eax
        mov esi, dword [dword esp+098h]
        push esi
        jmp short .17
.14:
        jle short .18
        lea eax, [byte ebp-02h]
        cmp eax, byte 1
        jne short .15
        mov eax, str_dot3
        jmp short .16
.15:
        mov eax, str_S7
.16:
        push eax
        lea eax, [byte esp+06Ch]
        push eax
        sub ebp, byte 2
        push ebp
        lea eax, [byte esp+06Ch]
        push eax
        mov ecx, dword [dword esp+098h]
        push ecx
.17:
        lea eax, [byte esp+014h]
        push eax
        call sprintf_
        add esp, byte 18h
        mov edx, esp
        mov dword [byte esp+edi*4+054h], edx
        inc edi
.18:
        push byte 0FFFFFFFFh
        mov ebp, dword [dword esp+088h]
        push ebp
        mov eax, dword [dword esp+088h]
        push eax
        push byte 0
        push byte 0
        mov ecx, edi
        lea ebx, [byte esp+068h]
        mov edx, 0FFFFFFFFh
        mov eax, edx
        call MessageBox
        mov eax, 1
        jmp short .x
.19:
        xor eax, eax
.x:
        add esp, 94h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; PruneGameLines                               79090  95 PC, medium confidence
; (team, lines): clears line slots whose player is not dressed (hmroster
; status 3 / 4)
;-----------------------------------------------------------------------------
; C: src/front/game_lines/PruneGameLines.c
%ifdef CBUILD
%include "c/front/game_lines/PruneGameLines.inc"
%else
PruneGameLines:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 4
        mov byte [esp], al
        mov esi, edx
        cmp dword [curperiod], byte 0
        jl short .3
        xor eax, eax
.1:
        lea ebx, [esi+eax]
        cmp byte [ebx], 64h
        je short .2
        xor ecx, ecx
        mov cl, byte [ebx]
        mov edi, ecx
        shl edi, 2
        add edi, ecx
        shl edi, 3
        sub edi, ecx
        xor ecx, ecx
        mov cl, byte [esp]
        mov edx, ecx
        shl edx, 4
        add edx, ecx
        shl edx, 4
        add edx, ecx
        shl edx, 2
        add edx, edi
        mov ch, byte [dword edx+hmroster]
        cmp ch, 4
        je short .2
        cmp ch, 3
        je short .2
        mov byte [ebx], 64h
.2:
        inc eax
        cmp eax, byte 28h
        jl short PruneGameLines.1
        jmp near .x
.3:
        xor eax, eax
.4:
        xor ebx, ebx
        mov bl, byte [esp]
        mov ecx, ebx
        shl ecx, 4
        add ecx, ebx
        shl ecx, 4
        add ecx, ebx
        shl ecx, 2
        mov edx, eax
        shl edx, 2
        add edx, eax
        shl edx, 3
        sub edx, eax
        add edx, ecx
        cmp byte [dword edx+hmroster], 2
        jne short .5
        mov byte [dword edx+hmroster], 3
.5:
        inc eax
        cmp eax, byte 1Ch
        jl short PruneGameLines.4
        xor eax, eax
.6:
        lea edx, [esi+eax]
        mov cl, byte [byte edx+028h]
        cmp cl, 64h
        je short .7
        xor ebx, ebx
        mov bl, cl
        mov ecx, ebx
        shl ecx, 2
        add ecx, ebx
        shl ecx, 3
        sub ecx, ebx
        xor ebx, ebx
        mov bl, byte [esp]
        mov edx, ebx
        shl edx, 4
        add edx, ebx
        shl edx, 4
        add edx, ebx
        shl edx, 2
        add edx, ecx
        cmp byte [dword edx+hmroster], 3
        jne short .7
        mov byte [dword edx+hmroster], 2
.7:
        inc eax
        cmp eax, byte 8
        jl short PruneGameLines.6
.x:
        add esp, byte 4
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; MenuUseTheseLines                                               79188  95 PC
; "Use These Lines": CheckGameRosterComplete, maps the line jerseys to
; hmroster indices and the extra slots
;-----------------------------------------------------------------------------
; C: src/front/game_lines/MenuSaveDefaultLines.c (MenuUseTheseLines)
%ifdef CBUILD
%include "c/front/game_lines/MenuSaveDefaultLines.MenuUseTheseLines.inc"
%else
MenuUseTheseLines:
        push dword 18h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 8
        mov esi, eax
        mov edi, edx
        mov byte [byte esp+04h], bl
        xor eax, eax
        mov al, bl
        mov ebx, dword [byte esp+02Ch]
        mov edx, dword [byte esp+028h]
        call CheckGameRosterComplete
        test eax, eax
        jne near MenuUseOriginalLines_ret0
        mov dword [esp], eax
.1:
        xor edx, edx
.2:
        xor ebx, ebx
        mov bl, byte [byte esp+04h]
        mov ecx, ebx
        shl ecx, 4
        add ecx, ebx
        shl ecx, 4
        add ecx, ebx
        shl ecx, 2
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 3
        sub eax, edx
        add eax, ecx
        cmp byte [dword eax+hmroster], 0
        je short .3
        mov ebx, dword [esp]
        mov bl, byte [esi+ebx]
        cmp bl, byte [dword eax+hmrosterjersey]
        jne short .3
        mov eax, dword [esp]
        mov byte [edi+eax], dl
        jmp short .4
.3:
        inc edx
        cmp edx, byte 1Ch
        jl short MenuUseTheseLines.2
.4:
        mov ebx, dword [esp]
        inc ebx
        mov dword [esp], ebx
        cmp ebx, byte 28h
        jl short MenuUseTheseLines.1
        cmp dword [curperiod], byte 0
        jge short .9
        xor ebp, ebp
        mov dword [esp], ebp
.5:
        mov eax, dword [esp]
        mov byte [byte edi+eax+028h], 64h
        inc eax
        mov dword [esp], eax
        cmp eax, byte 8
        jl short MenuUseTheseLines.5
        xor ebx, ebx
        mov dword [esp], ebx
        xor edx, edx
        jmp short .8
.6:
        xor ebx, ebx
        mov bl, byte [byte esp+04h]
        mov ecx, ebx
        shl ecx, 4
        add ecx, ebx
        shl ecx, 4
        add ecx, ebx
        shl ecx, 2
        mov ebx, dword [esp]
        mov eax, ebx
        shl eax, 2
        add eax, ebx
        shl eax, 3
        sub eax, ebx
        add eax, ecx
        mov cl, byte [dword eax+hmroster]
        test cl, cl
        je short .7
        cmp cl, 3
        je short .7
        mov bl, byte [esp]
        mov byte [byte edx+edi+028h], bl
        inc edx
.7:
        inc dword [esp]
.8:
        cmp dword [esp], byte 1Ch
        jl short MenuUseTheseLines.6
.9:
        mov eax, 1
        jmp near MenuUseOriginalLines_ret
%endif ; C
;-----------------------------------------------------------------------------
; MenuLineEdCancel                                                7928A  95 PC
; "Cancel": returns 1
;-----------------------------------------------------------------------------
; C: src/front/game_lines/MenuLineEdCancel.c
%ifdef CBUILD
%include "c/front/game_lines/MenuLineEdCancel.inc"
%else
MenuLineEdCancel:
        push dword 4
        call __CHK
        mov eax, 1
        ret 18h
%endif ; C
;-----------------------------------------------------------------------------
; MenuUseOriginalLines                                            7929C  95 PC
; "Use Original Lines": restores the team record lines, PruneGameLines,
; redraw
;-----------------------------------------------------------------------------
; C: src/front/game_lines/MenuSaveDefaultLines.c (MenuUseOriginalLines)
%ifdef CBUILD
%include "c/front/game_lines/MenuSaveDefaultLines.MenuUseOriginalLines.inc"
%else
MenuUseOriginalLines:
        push dword 18h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 8
        mov edi, eax
        mov byte [byte esp+04h], bl
        mov dword [esp], ecx
        xor ebx, ebx
        mov bl, byte [byte esp+04h]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 3
        mov edx, eax
        shl eax, 5
        sub eax, edx
        mov ebp, hmteamrec
        add ebp, eax
        add ebp, 0ECh
        mov edx, ebp
        mov eax, ebx
        call PruneGameLines
        mov dword [menuact_savelines], MenuSaveTheseLines
        mov ebx, MenuUseTheseLines
        mov dword [menuact_uselines], ebx
        mov dword [menuact_uselines2], ebx
        mov esi, MenuSaveDefaultLines
        mov dword [menuact_savedeflines], esi
        mov dword [menuact_savedeflines2], esi
        xor edx, edx
.1:
        lea eax, [edx+ebp]
        lea ebx, [edi+edx]
        mov cl, byte [eax]
        cmp cl, 64h
        je short .2
        xor ecx, ecx
        mov cl, byte [eax]
        mov esi, ecx
        shl esi, 2
        add esi, ecx
        shl esi, 3
        sub esi, ecx
        xor ecx, ecx
        mov cl, byte [byte esp+04h]
        mov eax, ecx
        shl eax, 4
        add eax, ecx
        shl eax, 4
        add eax, ecx
        mov al, byte [dword esi+eax*4+hmrosterjersey]
        mov byte [ebx], al
        jmp short .3
.2:
        mov byte [ebx], cl
        xor ebx, ebx
        mov dword [menuact_savelines], ebx
        mov dword [menuact_uselines], ebx
        mov dword [menuact_uselines2], ebx
        mov dword [menuact_savedeflines], ebx
        mov dword [menuact_savedeflines2], ebx
.3:
        inc edx
        cmp edx, byte 28h
        jl short MenuUseOriginalLines.1
MenuUseOriginalLines_redraw:
        xor ebx, ebx
        mov bl, byte [byte esp+04h]
        mov edx, dword [byte esp+018h]
        mov eax, edi
        call DrawGameLineJerseys
        mov eax, dword [esp]
        mov dword [eax], 0FFFFFFFFh
        xor ecx, ecx
        mov dword [menuact_gamescratch], ecx
        mov dword [menuact_gamedress], ecx
MenuUseOriginalLines_ret0:
        xor eax, eax
MenuUseOriginalLines_ret:
        add esp, byte 8
        jmp near MenuSaveDefaultLines_pop
%endif ; C
;-----------------------------------------------------------------------------
; MenuUseDefaultLines                                             793A4  95 PC
; "Use Default Lines": reads the team's lines from the league "teams" file
; (FatalError B3..B7), PruneGameLines, enables the save / use items
;-----------------------------------------------------------------------------
; C: src/front/game_lines/MenuSaveDefaultLines.c (MenuUseDefaultLines)
%ifdef CBUILD
%include "c/front/game_lines/MenuSaveDefaultLines.MenuUseDefaultLines.inc"
%else
MenuUseDefaultLines:
        push dword 18h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 8
        mov edi, eax
        mov byte [byte esp+04h], bl
        mov dword [esp], ecx
        xor ebx, ebx
        mov bl, byte [byte esp+04h]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 3
        mov edx, eax
        shl eax, 5
        sub eax, edx
        mov ebp, hmteamrec
        add ebp, eax
        add ebp, 0BCh
        mov edx, ebp
        mov eax, ebx
        call PruneGameLines
        mov dword [menuact_savelines], MenuSaveTheseLines
        mov ebx, MenuUseTheseLines
        mov dword [menuact_uselines], ebx
        mov dword [menuact_uselines2], ebx
        mov esi, MenuSaveDefaultLines
        mov dword [menuact_savedeflines], esi
        mov dword [menuact_savedeflines2], esi
        xor edx, edx
.1:
        lea eax, [edx+ebp]
        lea ebx, [edi+edx]
        mov cl, byte [eax]
        cmp cl, 64h
        je short .2
        xor ecx, ecx
        mov cl, byte [eax]
        mov esi, ecx
        shl esi, 2
        add esi, ecx
        shl esi, 3
        sub esi, ecx
        xor ecx, ecx
        mov cl, byte [byte esp+04h]
        mov eax, ecx
        shl eax, 4
        add eax, ecx
        shl eax, 4
        add eax, ecx
        mov al, byte [dword esi+eax*4+hmrosterjersey]
        mov byte [ebx], al
        jmp short .3
.2:
        mov byte [ebx], cl
        xor ebx, ebx
        mov dword [menuact_savelines], ebx
        mov dword [menuact_uselines], ebx
        mov dword [menuact_uselines2], ebx
        mov dword [menuact_savedeflines], ebx
        mov dword [menuact_savedeflines2], ebx
.3:
        inc edx
        cmp edx, byte 28h
        jl short MenuUseDefaultLines.1
        jmp near MenuUseOriginalLines_redraw
%endif ; C
MenuSaveDefaultLines:                           ; used by GameLineEditorLoop, GameScratchPlayer,
                                                ; MenuLineEdCancel ...
        db 068h,02Ch,03h,00h,00h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, 310h
        mov esi, eax
        mov byte [dword esp+030Ch], bl
        xor eax, eax
        mov al, bl
        mov ebx, dword [dword esp+0334h]
        mov edx, dword [dword esp+0330h]
        call CheckGameRosterComplete
        test eax, eax
        jne near .24
        cmp byte [dword esp+030Ch], 0
        je short .1
        push str_Teams2
        push leaguedbfmt2
        jmp short .2
.1:
        push str_Teams2
        push leaguedbfmt
.2:
        lea eax, [dword esp+02F0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        push dword 202h
        lea eax, [dword esp+02ECh]
        push eax
        call open_
        add esp, byte 8
        mov ebp, eax
        test eax, eax
        jge short .3
        call SetTextMode
        mov eax, str_ErrB2Perror
        call perror_
        call WaitKey
        mov eax, 1
        call exit_
.3:
        xor ebx, ebx
        xor edx, edx
        mov eax, ebp
        call lseek_
        test eax, eax
        je short .4
        push str_ErrB3
        call FatalError
        add esp, byte 4
.4:
        cmp byte [dword esp+030Ch], 0
        je short .5
        mov edx, dword [HomeTeam]
        jmp short .6
.5:
        mov edx, dword [cont2team]
.6:
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
        mov eax, ebp
        call lseek_
        mov ebx, eax
        test ebx, ebx
        jge short .7
        push str_ErrB4
        call FatalError
        add esp, byte 4
.7:
        mov ebx, 2E8h
        mov edx, esp
        mov eax, ebp
        call read_
        test eax, eax
        jl short .8
        cmp eax, 2E8h
        je short .9
.8:
        push str_ErrB5
        call FatalError
        add esp, byte 4
.9:
        mov ebx, 1
        mov edx, 0FFFFFD18h
        mov eax, ebp
        call lseek_
        mov ecx, eax
        mov ebx, eax
        test eax, eax
        jge short .12
        mov edx, dword [HomeTeam-2]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        mov edx, eax
        shl eax, 5
        sub eax, edx
        cmp ecx, eax
        je short .10
        cmp byte [dword esp+030Ch], 0
        je short .11
.10:
        mov edx, dword [VisTeam-2]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        mov edx, eax
        shl eax, 5
        sub eax, edx
        cmp ebx, eax
        je short .12
        cmp byte [dword esp+030Ch], 0
        je short .12
.11:
        push str_ErrB6
        call FatalError
        add esp, byte 4
.12:
        xor edx, edx
        mov dword [dword esp+0308h], edx
.13:
        xor edx, edx
.14:
        xor ebx, ebx
        mov bl, byte [dword esp+030Ch]
        mov ecx, ebx
        shl ecx, 4
        add ecx, ebx
        shl ecx, 4
        add ecx, ebx
        shl ecx, 2
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 3
        sub eax, edx
        add eax, ecx
        cmp byte [dword eax+hmroster], 0
        je short .15
        mov ebx, dword [dword esp+0308h]
        mov bl, byte [esi+ebx]
        cmp bl, byte [dword eax+hmrosterjersey]
        jne short .15
        mov eax, dword [dword esp+0308h]
        mov byte [dword esp+eax+0BCh], dl
        jmp short .16
.15:
        inc edx
        cmp edx, byte 1Ch
        jl short MenuSaveDefaultLines.14
.16:
        mov ebx, dword [dword esp+0308h]
        inc ebx
        mov dword [dword esp+0308h], ebx
        cmp ebx, byte 28h
        jl short MenuSaveDefaultLines.13
        cmp dword [curperiod], byte 0
        jge near .21
        xor edi, edi
        mov dword [dword esp+0308h], edi
        mov ch, 64h
.17:
        mov eax, dword [dword esp+0308h]
        mov byte [dword esp+eax+0E4h], ch
        inc eax
        mov dword [dword esp+0308h], eax
        cmp eax, byte 8
        jl short MenuSaveDefaultLines.17
        xor ebx, ebx
        mov dword [dword esp+0308h], ebx
        xor edx, edx
        jmp short .20
.18:
        xor ebx, ebx
        mov bl, byte [dword esp+030Ch]
        mov ecx, ebx
        shl ecx, 4
        add ecx, ebx
        shl ecx, 4
        add ecx, ebx
        shl ecx, 2
        mov ebx, dword [dword esp+0308h]
        mov eax, ebx
        shl eax, 2
        add eax, ebx
        shl eax, 3
        sub eax, ebx
        add eax, ecx
        mov bl, byte [dword eax+hmroster]
        test bl, bl
        je short .19
        cmp bl, 3
        je short .19
        mov al, byte [dword esp+0308h]
        mov byte [dword esp+edx+0E4h], al
        inc edx
.19:
        inc dword [dword esp+0308h]
.20:
        cmp dword [dword esp+0308h], byte 1Ch
        jl short MenuSaveDefaultLines.18
.21:
        mov ebx, 2E8h
        mov edx, esp
        mov eax, ebp
        call write_
        test eax, eax
        jl short .22
        cmp eax, 2E8h
        je short .23
.22:
        push str_ErrB7
        call FatalError
        add esp, byte 4
.23:
        xor edx, edx
        mov dl, byte [dword esp+030Ch]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        mov edx, eax
        shl eax, 5
        sub eax, edx
        mov ecx, 0Ch
        lea edi, [dword eax+hmteamrec+0BCh]
        lea esi, [dword esp+0BCh]
        rep movsd
        mov ecx, 0Ch
        lea edi, [dword eax+TeamRecLines]
        lea esi, [dword esp+0ECh]
        rep movsd
        mov eax, ebp
        call j___close_
.24:
        xor eax, eax
MenuSaveDefaultLines_ret:
        add esp, 310h
MenuSaveDefaultLines_pop:
        pop ebp
        pop edi
        pop esi
        ret 18h
MenuSaveTheseLines:                             ; used by GameLineEditorLoop, GameScratchPlayer,
                                                ; MenuUseDefaultLines ...
        db 068h,02Ch,03h,00h,00h,0E8h,08Eh,031h,01h,00h,056h,057h,055h,081h,0ECh,010h
        db 03h,00h,00h,089h,0C6h,088h,09Ch,024h,0Ch,03h,00h,00h,031h,0C0h,088h,0D8h
        db 08Bh,09Ch,024h,034h,03h,00h,00h,08Bh,094h,024h,030h,03h,00h,00h,0E8h,04Fh
        db 0F6h,0FFh,0FFh,085h,0C0h,074h,04h,031h,0C0h,0EBh,0B9h,080h,0BCh,024h,0Ch,03h
        db 00h,00h,00h,074h,0Ch,068h
        dd str_Teams2
;-----------------------------------------------------------------------------
; MenuSaveTheseLines_x                                            797FE  95 PC
; MenuSaveTheseLines tail: builds the team file name (sprintf) and opens it
; to write the lines.
;-----------------------------------------------------------------------------
MenuSaveTheseLines_x:
        push leaguedbfmt2
        jmp short .1
        push str_Teams2
        push leaguedbfmt
.1:
        lea eax, [dword esp+02F0h]
        push eax
        call sprintf_
        add esp, byte 0Ch
        push dword 202h
        lea eax, [dword esp+02ECh]
        push eax
        call open_
        add esp, byte 8
        mov ebp, eax
        test eax, eax
        jge short .2
        push str_ErrB2
        call FatalError
        add esp, byte 4
.2:
        xor ebx, ebx
        xor edx, edx
        mov eax, ebp
        call lseek_
        test eax, eax
        je short .3
        push str_ErrB3
        call FatalError
        add esp, byte 4
.3:
        cmp byte [dword esp+030Ch], 0
        je short .4
        mov edx, dword [HomeTeam]
        jmp short .5
.4:
        mov edx, dword [cont2team]
.5:
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
        mov eax, ebp
        call lseek_
        mov ebx, eax
        test ebx, ebx
        jge short .6
        push str_ErrB4
        call FatalError
        add esp, byte 4
.6:
        mov ebx, 2E8h
        mov edx, esp
        mov eax, ebp
        call read_
        test eax, eax
        jl short .7
        cmp eax, 2E8h
        je short .8
.7:
        push str_ErrB5
        call FatalError
        add esp, byte 4
.8:
        mov ebx, 1
        mov edx, 0FFFFFD18h
        mov eax, ebp
        call lseek_
        mov ecx, eax
        mov ebx, eax
        test eax, eax
        jge short .11
        mov edx, dword [HomeTeam-2]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        mov edx, eax
        shl eax, 5
        sub eax, edx
        cmp ecx, eax
        je short .9
        cmp byte [dword esp+030Ch], 0
        je short .10
.9:
        mov edx, dword [VisTeam-2]
        sar edx, 10h
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        mov edx, eax
        shl eax, 5
        sub eax, edx
        cmp ebx, eax
        je short .11
        cmp byte [dword esp+030Ch], 0
        je short .11
.10:
        push str_ErrB6
        call FatalError
        add esp, byte 4
.11:
        xor edx, edx
        mov dword [dword esp+0308h], edx
.12:
        xor ecx, ecx
.13:
        xor edx, edx
        mov dl, byte [dword esp+030Ch]
        mov ebx, edx
        shl ebx, 4
        add ebx, edx
        shl ebx, 4
        add ebx, edx
        shl ebx, 2
        mov eax, ecx
        shl eax, 2
        add eax, ecx
        shl eax, 3
        sub eax, ecx
        add eax, ebx
        cmp byte [dword eax+hmroster], 0
        je short .14
        mov edx, dword [dword esp+0308h]
        mov dl, byte [edx+esi]
        cmp dl, byte [dword eax+hmrosterjersey]
        jne short .14
        mov eax, dword [dword esp+0308h]
        mov byte [dword esp+eax+0BCh], cl
        jmp short .15
.14:
        inc ecx
        cmp ecx, byte 1Ch
        jl short MenuSaveTheseLines_x.13
.15:
        mov ebx, dword [dword esp+0308h]
        inc ebx
        mov dword [dword esp+0308h], ebx
        cmp ebx, byte 28h
        jl short MenuSaveTheseLines_x.12
        xor esi, esi
        mov dword [dword esp+0308h], esi
        mov bl, 64h
.16:
        mov eax, dword [dword esp+0308h]
        mov byte [dword esp+eax+0E4h], bl
        lea edi, [byte eax+01h]
        mov dword [dword esp+0308h], edi
        cmp edi, byte 8
        jl short MenuSaveTheseLines_x.16
        xor edx, edx
        mov dword [dword esp+0308h], edx
        xor ecx, ecx
        jmp short .19
.17:
        xor edx, edx
        mov dl, byte [dword esp+030Ch]
        mov ebx, edx
        shl ebx, 4
        add ebx, edx
        shl ebx, 4
        add ebx, edx
        shl ebx, 2
        mov edx, dword [dword esp+0308h]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 3
        sub eax, edx
        add eax, ebx
        mov bh, byte [dword eax+hmroster]
        test bh, bh
        je short .18
        cmp bh, 3
        je short .18
        mov al, byte [dword esp+0308h]
        mov byte [dword esp+ecx+0E4h], al
        inc ecx
.18:
        inc dword [dword esp+0308h]
.19:
        cmp dword [dword esp+0308h], byte 1Ch
        jl short MenuSaveTheseLines_x.17
        mov ebx, 2E8h
        mov edx, esp
        mov eax, ebp
        call write_
        test eax, eax
        jl short .20
        cmp eax, 2E8h
        je short .21
.20:
        push str_ErrB7
        call FatalError
        add esp, byte 4
.21:
        xor edx, edx
        mov dl, byte [dword esp+030Ch]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 3
        mov edx, eax
        shl eax, 5
        sub eax, edx
        mov ecx, 0Ch
        lea edi, [dword eax+hmteamrec+0BCh]
        lea esi, [dword esp+0BCh]
        rep movsd
        mov ecx, 0Ch
        lea edi, [dword eax+TeamRecLines]
        lea esi, [dword esp+0ECh]
        rep movsd
        mov eax, ebp
        call j___close_
        mov eax, 1
        jmp near MenuSaveDefaultLines_ret
;-----------------------------------------------------------------------------
; MenuGameShowPlayerStats                                         79AC9  95 PC
; Game line editor "Show Player Statistics": tstat / keys / pstat / gstat,
; TeamRosterScreen menu, redraw
;-----------------------------------------------------------------------------
MenuGameShowPlayerStats:
        push dword 348h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, 324h
        mov ebp, eax
        mov byte [dword esp+0320h], bl
        mov esi, ecx
        mov edx, 1
        mov dword [leaguestatsmode], edx
        mov dword [RosterFromStandings], edx
        mov dword [statsredrawcb], TeamRosterScreen
        test bl, bl
        je short .1
        mov eax, dword [HomeTeam]
        jmp short .2
.1:
        mov eax, dword [cont2team]
.2:
        sar eax, 10h
        mov dword [statscategory], eax
        push byte 20h
        push dword 2A4h
        push str_Tstat2
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [statsteambuf], eax
        push byte 20h
        push dword 5B0h
        push str_Keys4
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [statsplayerbuf], eax
        push byte 20h
        push dword 497h
        push str_Pstat4
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [statsskaterbuf], eax
        push byte 20h
        push dword 10Eh
        push str_Gstat4
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [statsgoaliebuf], eax
        push gamelinespal
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        xor eax, eax
.3:
        mov dl, byte [dword eax+gamelinespal]
        mov byte [esp+eax], dl
        inc eax
        cmp eax, 300h
        jl short MenuGameShowPlayerStats.3
        mov ebx, 10h
        mov edx, esp
        mov eax, 1
        call FadePalStep
        cmp byte [dword esp+0320h], 0
        je short .4
        mov eax, dword [HomeTeam]
        jmp short .5
.4:
        mov eax, dword [cont2team]
.5:
        sar eax, 10h
        call TeamRosterScreen
        push dword 0C2h
        mov ecx, 0C1h
        mov ebx, 0C0h
        mov edx, 2
        mov eax, gameplstatsmenubar
        call DrawMenuBar
        xor eax, eax
.6:
        mov dl, byte [dword eax+gamelinespal]
        mov byte [esp+eax], dl
        inc eax
        cmp eax, 300h
        jl short MenuGameShowPlayerStats.6
        mov ebx, 10h
        mov edx, esp
        xor eax, eax
        call FadePalStep
        push dword 0C2h
        mov ecx, 0C1h
        mov ebx, 0C0h
        mov edx, 2
        mov eax, gameplstatsmenubar
        call RunMenu
        mov ebx, 10h
        mov edx, esp
        mov eax, 1
        call FadePalStep
        xor eax, eax
.7:
        mov dl, byte [dword eax+gamelinespal]
        mov byte [esp+eax], dl
        inc eax
        cmp eax, 300h
        jl short MenuGameShowPlayerStats.7
        xor edi, edi
        mov dword [leaguestatsmode], edi
        mov dword [statsredrawcb], edi
        mov edx, dword [statsteambuf]
        push edx
        call FreeMemBlock
        add esp, byte 4
        mov ebx, dword [statsgoaliebuf]
        push ebx
        call FreeMemBlock
        add esp, byte 4
        mov ecx, dword [statsskaterbuf]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        mov edi, dword [statsplayerbuf]
        push edi
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        mov dword [statsplayerbuf], eax
        mov dword [statsteambuf], eax
        xor ebx, ebx
        mov dword [statsgoaliebuf], eax
        mov dword [statsskaterbuf], eax
        mov edi, dword [dword esp+0340h]
        push edi
        movzx edi, byte [dword esp+0324h]
        mov ecx, dword [dword esp+0340h]
        mov edx, dword [dword esp+0338h]
        mov eax, edi
        call DrawLineEditorScreen
        mov ebx, edi
        mov edx, dword [dword esp+0334h]
        mov eax, ebp
        call DrawGameLineJerseys
        mov ebp, dword [esi]
        test ebp, ebp
        jl near .10
        mov edx, ebp
        mov eax, ebp
        shl eax, 2
        sub eax, ebp
        shl eax, 2
        sub eax, ebp
        xor edx, ebp
        mov dl, byte [nosplit eax*2+gmrosterslot]
        mov eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 3
        sub eax, edx
        mov edx, eax
        mov eax, edi
        shl eax, 4
        add eax, edi
        shl eax, 4
        add eax, edi
        cmp byte [dword edx+eax*4+hmroster], 2
        jne short .8
        push dword 0C1h
        push dword 0FDh
        jmp short .9
.8:
        push dword 0C1h
        push dword 0C0h
.9:
        call TextSetColors
        add esp, byte 8
        mov edi, dword [esi]
        mov eax, edi
        shl eax, 2
        sub eax, edi
        shl eax, 2
        sub eax, edi
        add eax, eax
        mov edx, gmroster
        add edx, eax
        add edx, byte 3
        push edx
        xor edx, edx
        mov dl, byte [dword eax+gmrosterjersey]
        push edx
        mov al, byte [dword eax+gmroster]
        and eax, 0FFh
        push eax
        push str_C2dS3
        lea eax, [dword esp+0310h]
        push eax
        call sprintf_
        add esp, byte 14h
        mov edx, dword [esi]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        lea edx, [byte eax+016h]
        lea ebx, [dword esp+0300h]
        mov eax, 1FAh
        call PrintLineEdStatus
.10:
        mov ebx, 10h
        mov edx, esp
        xor eax, eax
        call FadePalStep
        xor eax, eax
        add esp, 324h
        jmp near MenuSaveDefaultLines_pop
;-----------------------------------------------------------------------------
; MenuReturnToLineEditor                                          79DD1  95 PC
; "Line Editor" / "Return To Line Editor": returns 1
;-----------------------------------------------------------------------------
; C: src/front/game_lines/MenuReturnToLineEditor.c
%ifdef CBUILD
%include "c/front/game_lines/MenuReturnToLineEditor.inc"
%else
MenuReturnToLineEditor:
        push dword 4
        call __CHK
        mov eax, 1
        ret
%endif ; C
;-----------------------------------------------------------------------------
; GameScratchPlayer                                               79DE1  95 PC
; Hmroster status 2, removes him from the lines, disables the save / use
; items if a slot is now empty
;-----------------------------------------------------------------------------
; C: src/front/game_lines/MenuSaveDefaultLines.c (GameScratchPlayer)
%ifdef CBUILD
%include "c/front/game_lines/MenuSaveDefaultLines.GameScratchPlayer.inc"
%else
GameScratchPlayer:
        push dword 48h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 24h
        mov edi, eax
        mov byte [byte esp+020h], bl
        mov esi, ecx
        xor edx, edx
.1:
        mov ebx, dword [esi]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 2
        sub eax, ebx
        lea ebx, [eax+eax]
        lea eax, [edi+edx]
        mov cl, byte [eax]
        cmp cl, byte [dword ebx+gmrosterjersey]
        jne short .2
        mov byte [eax], 64h
.2:
        inc edx
        cmp edx, byte 28h
        jl short GameScratchPlayer.1
        mov dword [menuact_savelines], MenuSaveTheseLines
        mov ebx, MenuUseTheseLines
        mov dword [menuact_uselines], ebx
        mov dword [menuact_uselines2], ebx
        mov ebp, MenuSaveDefaultLines
        mov dword [menuact_savedeflines], ebp
        mov dword [menuact_savedeflines2], ebp
        xor edx, edx
.3:
        cmp byte [edx+edi], 64h
        jne short .4
        xor edx, edx
        mov dword [menuact_savelines], edx
        mov dword [menuact_uselines], edx
        mov dword [menuact_uselines2], edx
        mov dword [menuact_savedeflines], edx
        mov dword [menuact_savedeflines2], edx
        jmp short .5
.4:
        inc edx
        cmp edx, byte 28h
        jl short GameScratchPlayer.3
.5:
        mov edx, dword [esi]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        xor edx, edx
        mov dl, byte [nosplit eax*2+gmrosterslot]
        mov ecx, edx
        shl ecx, 2
        add ecx, edx
        shl ecx, 3
        sub ecx, edx
        xor ebx, ebx
        mov bl, byte [byte esp+020h]
        mov eax, ebx
        shl eax, 4
        add eax, ebx
        shl eax, 4
        add eax, ebx
        mov byte [dword ecx+eax*4+hmroster], 2
        mov edx, dword [byte esp+034h]
        mov eax, edi
        call DrawGameLineJerseys
        push dword 0C1h
        push dword 0FCh
        call TextSetColors
        add esp, byte 8
        mov edx, dword [esi]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        mov edx, gmroster
        add edx, eax
        add edx, byte 3
        push edx
        xor edx, edx
        mov dl, byte [dword eax+gmrosterjersey]
        push edx
        mov al, byte [dword eax+gmroster]
        and eax, 0FFh
        push eax
        push str_C2dS3
        lea eax, [byte esp+010h]
        push eax
        call sprintf_
        add esp, byte 14h
        mov edx, dword [esi]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        lea edx, [byte eax+016h]
        mov ebx, esp
        mov eax, 1FAh
        call PrintLineEdStatus
        xor eax, eax
        add esp, byte 24h
        jmp near MenuSaveDefaultLines_pop
%endif ; C
;-----------------------------------------------------------------------------
; GameDressPlayer                                                 79F41  95 PC
; Hmroster status 3, redraw, status line
;-----------------------------------------------------------------------------
; C: src/front/game_lines/GameDressPlayer.c
%ifdef CBUILD
%include "c/front/game_lines/GameDressPlayer.inc"
%else
GameDressPlayer:
        push dword 40h
        call __CHK
        push esi
        push edi
        sub esp, byte 20h
        mov edi, eax
        mov esi, ecx
        mov edx, dword [ecx]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        xor edx, edx
        mov dl, byte [nosplit eax*2+gmrosterslot]
        mov ecx, edx
        shl ecx, 2
        add ecx, edx
        shl ecx, 3
        sub ecx, edx
        and ebx, 0FFh
        mov eax, ebx
        shl eax, 4
        add eax, ebx
        shl eax, 4
        add eax, ebx
        mov byte [dword ecx+eax*4+hmroster], 3
        mov edx, dword [byte esp+02Ch]
        mov eax, edi
        call DrawGameLineJerseys
        push dword 0C1h
        push dword 0C0h
        call TextSetColors
        add esp, byte 8
        mov edx, dword [esi]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        sub eax, edx
        add eax, eax
        mov edx, gmroster
        add edx, eax
        add edx, byte 3
        push edx
        xor edx, edx
        mov dl, byte [dword eax+gmrosterjersey]
        push edx
        mov al, byte [dword eax+gmroster]
        and eax, 0FFh
        push eax
        push str_C2dS3
        lea eax, [byte esp+010h]
        push eax
        call sprintf_
        add esp, byte 14h
        mov edx, dword [esi]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        lea edx, [byte eax+016h]
        mov ebx, esp
        mov eax, 1FAh
        call PrintLineEdStatus
        xor eax, eax
        add esp, byte 20h
        pop edi
        pop esi
        ret 18h
%endif ; C
;-----------------------------------------------------------------------------
; BlitJerseyDigit                                                 7A017  95 PC
; (dst, digit, colour, right): 1-bit 84-pixel digit glyph from jerseydigits
; into a jersey shape
;-----------------------------------------------------------------------------
; C: src/front/game_lines/BlitJerseyDigit.c
%ifdef CBUILD
%include "c/front/game_lines/BlitJerseyDigit.inc"
%else
BlitJerseyDigit:
        push dword 18h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 8
        mov esi, eax
        mov edi, edx
        mov byte [byte esp+04h], bl
        mov ebp, dword [byte esp+018h]
        xor ebx, ebx
.1:
        mov ecx, 20h
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        idiv ecx
        test edx, edx
        jne short .2
        mov ecx, edi
        shl ecx, 2
        sub ecx, edi
        shl ecx, 2
        mov eax, ebx
        mov edx, ebx
        sar edx, 1Fh
        shl edx, 5
        LD sbb, eax, edx
        sar eax, 5
        mov eax, dword [dword ecx+eax*4+jerseydigits]
        mov dword [esp], eax
.2:
        test byte [esp], 1
        je short .5
        test ebp, ebp
        je short .3
        cmp ebx, byte 23h
        jle short .3
        lea eax, [byte ebx+030h]
        jmp short .4
.3:
        mov eax, ebx
.4:
        mov dl, byte [byte esp+04h]
        mov byte [esi+eax], dl
.5:
        sar dword [esp], 1
        inc ebx
        cmp ebx, byte 54h
        jl short BlitJerseyDigit.1
        add esp, byte 8
        pop ebp
        pop edi
        pop esi
        ret 4
%endif ; C
;-----------------------------------------------------------------------------
; MakeJerseyShape                                                 7A099  95 PC
; (buf, number, body, digit colour): fills the jersey colours and blits one
; or two digits
;-----------------------------------------------------------------------------
; C: src/front/game_lines/MakeJerseyShape.c
%ifdef CBUILD
%include "c/front/game_lines/MakeJerseyShape.inc"
%else
MakeJerseyShape:
        push dword 18h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov esi, eax
        mov edi, edx
        xor eax, eax
        jmp short .2
.1:
        movsx edx, ax
        mov byte [edx+esi], cl
        inc eax
.2:
        cmp ax, 8Fh
        jle short MakeJerseyShape.1
        mov eax, 0C0h
        jmp short .4
.3:
        movsx edx, ax
        mov byte [edx+esi], cl
        inc eax
.4:
        cmp ax, 0EFh
        jle short MakeJerseyShape.3
        cmp edi, byte 63h
        ja short .x
        cmp edi, byte 0Ah
        jae short .5
        push byte 0
        and ecx, 0FFh
        and ebx, 0FFh
        lea eax, [byte esi+030h]
        mov edx, edi
        jmp short .6
.5:
        push byte 0
        movzx ebp, cl
        xor eax, eax
        mov al, bl
        mov dword [byte esp+04h], eax
        mov ebx, 0Ah
        xor edx, edx
        mov eax, edi
        div ebx
        mov edx, eax
        mov ecx, ebp
        mov ebx, dword [byte esp+04h]
        mov eax, esi
        call BlitJerseyDigit
        push byte 1
        mov ebx, 0Ah
        xor edx, edx
        mov eax, edi
        div ebx
        lea eax, [byte esi+06Ch]
        mov ecx, ebp
        mov ebx, dword [byte esp+04h]
.6:
        call BlitJerseyDigit
.x:
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        ret
%endif ; C
